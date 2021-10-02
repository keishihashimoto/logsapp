class ServersController < ApplicationController
  def index
    @servers = Server.all
  end

  def new
    @server = Server.new
  end

  def create
    @server = Server.new(server_params)
    if @server.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def search
    @count = params[:count].to_i
    @time = params[:time].to_i
    @recent_logs = []
    Server.all.each do |server|
      interval_sum = 0
      if Log.where(server_id: server.id).where.not(interval: "-").length < @count
        server.logs.each do |log|
          interval_sum += log.interval.to_i
        end
        average_interval = (interval_sum.to_f) / server.logs.length
        if average_interval >= @time
          recent_log = {
            ip_address: server.ip_address,
            average_interval: average_interval
          }
          @recent_logs << recent_log
        end
      else
        @count.times do |i|
          target_log = Log.where(server_id: server.id).where.not(interval: "-").order(checked_at: "desc")[i]
          interval_sum += target_log.interval.to_i
        end
        average_interval = (interval_sum.to_f) / @count
        if average_interval >= @time
          recent_log = {
            ip_address: server.ip_address,
            average_interval: average_interval
          }
          @recent_logs << recent_log
        end
      end
    end
  end


  private
  def server_params
    ip_address = "#{params[:server][:main_1]}.#{params[:server][:main_2]}.#{params[:server][:main_3]}.#{params[:server][:main_4]}/#{params[:server][:sub]}"
    params.require(:server).permit(:main_1, :main_2, :main_3, :main_4, :sub).merge(ip_address: ip_address)
  end
end
