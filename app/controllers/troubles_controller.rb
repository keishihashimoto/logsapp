class TroublesController < ApplicationController
  def index
    @troubles = Trouble.all
  end

  def new
    @trouble = Trouble.new
  end

  def create
    @troubles = []
    Log.all.each do |log|
      if log.interval == "-"
        # interval == "-"のログを見つけたら、それ以降のログでサーバーが同じものを全て確認する。
        if Log.where(server_id: log.server_id).where("id > ?", log.id).where.not(interval: "-").exists?
          check_list = []
          Log.where(server_id: log.server_id).where("id > ?", log.id).each do |log_for_server|
            check_list << log_for_server
            if log_for_server.interval != "-"
              break
            end
          end
          finish_log = check_list[(check_list.length - 1)]
          trouble_start = log.checked_at
          trouble_end = finish_log.checked_at
          checked_count = check_list.length
          trouble_time = trouble_end - trouble_start
          Trouble.where(server_id: log.server_id, trouble_start: trouble_start).first_or_create do |trouble|
            trouble.trouble_end = trouble_end
            trouble.checked_count = checked_count
            trouble.trouble_time = trouble_time
          end
        else
          Trouble.where(server_id: log.server_id, trouble_start: log.checked_at).first_or_create do |trouble|
            trouble.trouble_end = nil
            trouble.checked_count = nil
            trouble.trouble_time = nil
          end
        end
      end
    end
    Trouble.all.each do |trouble|
      if(trouble.checked_count != nil && trouble.checked_count >= params[:trouble][:min_count].to_i)
        @troubles << trouble
      end
    end

    if params[:trouble][:min_count] == nil
      @min_count = 1
    else
      @min_count = params[:trouble][:min_count].to_i
    end

    # 最後に、同一サブネット内の全てのサーバーが同時にタイムアウトしている瞬間がないかどうかを調べる。
    # まず最初に全てのサブネットのリストを取得
    @subnet_firsts = []
    @subnet_firsts << Server.all[0]
    Server.all.each do |server|
      unique_subnet = "yes"
      @subnet_firsts.each do |subnet_first|
        if server.main_1 == subnet_first.main_1 && server.main_2 == subnet_first.main_2 && server.main_3 == subnet_first.main_3 
          unique_subnet = "no"
          break
        end

      end

      if unique_subnet == "yes"
        @subnet_firsts << server
      end

    end
    # あるサブネット内である時刻からN回の応答確認の間に連続して全てのサーバーがタイムアウトしているかどうかを調べる
    # これを全てのサブネットと全ての時刻に対して行う
    @subnet_troubles = []

    @subnet_firsts.each do |subnet_first|
      count = 0
      subnet_first.logs.each_with_index do |subnet_first_log, i|   
        if subnet_first_log.interval == "-"
          checking_time = subnet_first_log.checked_at.strftime("%Y%m%d")

          if count == 0
            start_time = checking_time
          end

          simultaneous = "yes"

          Log.all.each do |log|
            if log.id != subnet_first.id && log.checked_at.strftime("%Y%m%d") == checking_time && log.interval != "-" && log.server.main_1 == subnet_first.main_1 && log.server.main_2 == subnet_first.main_2 && log.server.main_3 == subnet_first.main_3 
              simultaneous = "no"
              break
            end

          end

          if simultaneous == "yes"
            count += 1
            if i == (subnet_first.logs.length - 1) && count >= @min_count
              @subnet_trouble ={
                main_1: subnet_first.main_1,
                main_2: subnet_first.main_2,
                main_3: subnet_first.main_3,
                main_4: subnet_first.main_4,
                start_time: start_time,
                finish_time: checking_time,
                count: count
              }
              @subnet_troubles << @subnet_trouble
            end
          elsif count >= @min_count
            @subnet_trouble ={
              main_1: subnet_first.main_1,
              main_2: subnet_first.main_2,
              main_3: subnet_first.main_3,
              main_4: subnet_first.main_4,
              start_time: start_time,
              finish_time: checking_time,
              count: count
            }
            @subnet_troubles << @subnet_trouble
          end

        end
        
      end

    end

  end

end
