module Rails
  class Conductor::FullRequestLogger::RequestLogsController < ActionController::Base
    protect_from_forgery with: :reset_session

    before_action :authenticate
    skip_before_action :verify_authenticity_token, only: :create

    layout "rails/conductor"

    def index
    end

    def create
      redirect_to rails_conductor_request_log_url(params[:id])
    end

    def show
      if @logs = FullRequestLogger::Recorder.instance.retrieve(params[:id])
        respond_to do |format|
          format.html
          format.text { send_data @logs, disposition: :attachment, filename: "#{params[:id]}.log" }
          format.json { render json: { logs: @logs.to_json, status: 200 } }
        end
      else
        respond_to do |format|
          format.html { redirect_to rails_conductor_request_logs_url, alert: "Request not found!" }
          format.json { render json: { success: false, status: 404 } }
        end
      end
    end

    private
      def authenticate
        if credentials = FullRequestLogger.credentials
          http_basic_authenticate_or_request_with credentials
        end
      end
  end
end
