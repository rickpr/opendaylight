require "httparty"

module Opendaylight

  class ModelDriven
    def initialize(resource_chain = nil)
      @resource_chain = resource_chain ? resource_chain : Array.new
      @auth = {:username => Opendaylight.configuration.username, :password => Opendaylight.configuration.password}
    end

    def create(post_data)
      h = HTTParty.post(form_url_from_method_calls, { :basic_auth => @auth, :body => post_data, headers: {"Content-Type" => "application/json", "Accept" => "application/json"} } )

      h.response
    end

    def delete
      h = HTTParty.delete(form_url_from_method_calls, { :basic_auth => @auth } )

      h.response
    end

    def method_missing(sym, *args, &block)
      @resource_chain << sym
      args.each do |arg|
        @resource_chain << arg.to_s.to_sym
      end
      md = ModelDriven.new(@resource_chain)
      @resource_chain = Array.new

      return md

      super(sym, *args, &block)
    end

    def update(object)
      h = HTTParty.put(form_url_from_method_calls, { :basic_auth => @auth, :body => object, headers: {"Content-Type" => "application/json", "Accept" => "application/json"} } )

      h.response
    end

    def respond_to?(sym, include_private = false)
      @resource_chain << sym.to_s.to_sym
      call_exists_in_mdsal? || super(sym, include_private)
    end

    def resource
      url = form_url_from_method_calls
      h = HTTParty.get(url, { :basic_auth => @auth, headers: {"Accept" => "application/json"} } )
      h.response
    end

    private

    def call_exists_in_mdsal?
      h = HTTParty.head(form_url_from_method_calls, :basic_auth => @auth)
      h.response.code.to_i < 400
    end

    def map_method_to_module(method)
      case method
      when :nodes
        return "opendaylight-inventory:" + method.to_s
      else
        return method.to_s
      end

    end

    def form_url_from_method_calls
      path = Array.new
      path << "restconf"
      @resource_chain[1,@resource_chain.size].each do |resource|
        path << map_method_to_module(resource)
      end

      p = URI::Parser.new
      u = p.parse Opendaylight.configuration.url
      u.path = '/' + path.join('/')
      u.to_s
    end

  end
end
