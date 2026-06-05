#!/usr/bin/env ruby

require 'net/http'
require 'logger'
require 'json'

logger = Logger.new('/home/downloader/log/health_check_status.log', 1, 500000)

instance_id = File.open('/var/lib/cloud/data/instance-id', &:readline).strip
working_env = ENV['RAILS_ENV']
working_env == 'demo' ? downloader_uri = URI('https://demo.download.library.illinois.edu/downloads/status') : downloader_uri = URI('https://download.library.illinois.edu/downloads/status')

downloader_response = Net::HTTP.get_response(downloader_uri)

begin
    mountpoint_monit_status = JSON.parse(downloader_response.body)['mountpointMonitStatus']
    mountpoint_monit_status_hash = {"mountpoint_monit_status" => mountpoint_monit_status}
    mountpoint_mount_status = JSON.parse(downloader_response.body)['mountpointMountStatus']
    mountpoint_mount_status_hash = {"mountpoint_mount_status" => mountpoint_mount_status}
    amqp_listener_status = JSON.parse(downloader_response.body)['amqpListener']['status']
    amqp_listener_status_hash = {"amqp_listener_status" => amqp_listener_status}
    delayed_job_status = JSON.parse(downloader_response.body)['delayedJobs']['status']
    delayed_job_status_hash = {"delayed_job_status" => delayed_job_status}
    
    downloader_response_body = {}
    downloader_response_body.merge!(mountpoint_monit_status_hash) unless mountpoint_monit_status.nil?
    downloader_response_body.merge!(mountpoint_mount_status_hash) unless mountpoint_mount_status.nil?
    downloader_response_body.merge!(amqp_listener_status_hash) unless amqp_listener_status.nil?
    downloader_response_body.merge!(delayed_job_status_hash) unless delayed_job_status.nil?

    downloader_log = {"InstanceId" => instance_id, "downloader_code" => downloader_response.code, "downloader_message" => downloader_response_body}
rescue JSON::ParserError => e
    downloader_log = {"InstanceId" => instance_id, "downloader_code" => downloader_response.code, "downloader_message" => "Error parsing downloader health check JSON"}
end

downloader_response.code == "200" ? logger.info(downloader_log.to_json) : logger.error(downloader_log.to_json)