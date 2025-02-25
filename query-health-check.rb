#!/usr/bin/env ruby

require 'net/http'
require 'logger'
require 'json'

logger = Logger.new('/home/downloader/log/health_check_status.log', 1, 500000)

instance_id = File.open('/var/lib/cloud/data/instance-id', &:readline).strip

ENV['RAILS_ENV'] == 'demo' ? downloader_uri = URI('https://demo.download.library.illinois.edu/downloads/status') : downloader_uri = URI('https://download.library.illinois.edu/downloads/status')

logger.info("Downloader uri: #{downloader_uri}")

downloader_response = Net::HTTP.get_response(downloader_uri)

begin
    mountpoint_monit_status = JSON.parse(downloader_response.body)['mountpointMonitStatus']
    mountpoint_mount_status = JSON.parse(downloader_response.body)['mountpointMountStatus']
    downloader_response_body = {"mountpoint_monit_status" => mountpoint_monit_status, "mountpoint_mount_status" => mountpoint_mount_status}

    downloader_log = {"InstanceId" => instance_id, "downloader_code" => downloader_response.code, "downloader_message" => downloader_response_body}
rescue JSON::ParserError => e
    downloader_log = {"InstanceId" => instance_id, "downloader_code" => downloader_response.code, "downloader_message" => "Error parsing downloader health check JSON"}
end

downloader_response.code == "200" ? logger.info(downloader_log.to_json) : logger.error(downloader_log.to_json)