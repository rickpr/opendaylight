require "opendaylight/version"
require "httparty"

module Opendaylight
  class Configuration
    attr_accessor :username, :password, :url
  end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

  end

  class API

    class << self

      def makeflow(**params)
        options = build_options(params)
        HTTParty.put("#{options[:url]}controller/nb/v2/flowprogrammer/#{options[:containerName]}/node/#{options[:type]}/#{options[:id]}/staticFlow/#{options[:name]}",options[:request])
      end

      def deleteflow(**params)
        options = build_options(params)
        HTTParty.delete("#{options[:url]}controller/nb/v2/flowprogrammer/#{options[:containerName]}/node/#{options[:type]}/#{options[:id]}/staticFlow/#{options[:name]}",options[:request])
      end

      def topology(username: Opendaylight.configuration.username, password: Opendaylight.configuration.password, url: Opendaylight.configuration.url, containerName: "default")
        auth = {username: username, password: password}
        HTTParty.get("#{url}controller/nb/v2/topology/#{containerName}", basic_auth: auth)
      end

      def hostTracker(username: Opendaylight.configuration.username, password: Opendaylight.configuration.password, url: Opendaylight.configuration.url, containerName: "default")
        auth = {username: username, password: password}
        HTTParty.get("#{url}controller/nb/v2/hosttracker/#{containerName}/hosts/active", basic_auth: auth)
      end

      def listFlows(username: Opendaylight.configuration.username, password: Opendaylight.configuration.password, url: Opendaylight.configuration.url, containerName: "default")
        auth = {username: username, password: password}
        HTTParty.get("#{url}controller/nb/v2/flowprogrammer/#{containerName}", basic_auth: auth)
      end

      def statistics(username: Opendaylight.configuration.username, password: Opendaylight.configuration.password, url: Opendaylight.configuration.url, containerName: "default", stats: "flow")
        auth = {username: username, password: password}
        HTTParty.get("#{url}controller/nb/v2/statistics/#{containerName}/#{stats}", basic_auth: auth)
      end

      def nodes(username: Opendaylight.configuration.username, password: Opendaylight.configuration.password, url: Opendaylight.configuration.url, containerName: "default", id: nil)
        auth = {username: username, password: password}
        if id.nil?
          HTTParty.get("#{url}controller/nb/v2/switchmanager/#{containerName}/nodes", basic_auth: auth)
        else
          HTTParty.get("#{url}controller/nb/v2/switchmanager/#{containerName}/node/OF/#{id}", basic_auth: auth)
        end
      end

      def build_options(tpSrc: nil, protocol: nil, vlanId: nil, id: nil, type: "OF", vlanPriority: nil, idleTimeout: nil, priority: "500", ingressPort: nil, tosBits: nil, name: nil, hardTimeout: nil, dlDst: nil, installInHW: "true", etherType: "0x800", actions: nil, cookie: nil, dlSrc: nil, nwSrc: nil, nwDst: nil, tpDst: nil, username: Opendaylight.configuration.username, password: Opendaylight.configuration.password, url: Opendaylight.configuration.url, containerName: "default")
        auth = {username: username, password: password}
        options = { url: url,
                    containerName: containerName,
                    type: type,
                    id: id,
                    name: name,
                    request: { headers: {"Content-Type" => "application/json"},
                               body: {
                      "tpSrc" => tpSrc,
                      "protocol" => protocol,
                      "vlanId" => vlanId,
                      "node" => {
                        "id" => id,
                        "type" => type
                      },
                      "vlanPriority" => vlanPriority,
                      "idleTimeout" => idleTimeout,
                      "priority" => priority,
                      "ingressPort" => ingressPort,
                      "tosBits" => tosBits,
                      "name" => name,
                      "hardTimeout" => hardTimeout,
                      "dlDst" => dlDst,
                      "installInHW" => installInHW,
                      "etherType" => etherType,
                      "actions" => [actions],
                      "cookie" => cookie,
                      "dlSrc" => dlSrc,
                      "nwSrc" => nwSrc,
                      "nwDst" => nwDst,
                      "tpDst" => tpDst
                    }.to_json,
                    basic_auth: auth
        } }
      end

    end

    Opendaylight.configure

  end

end
