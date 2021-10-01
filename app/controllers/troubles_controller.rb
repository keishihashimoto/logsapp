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
      @min_count = params[:trouble][:min_count]
    end
    
  end

end
