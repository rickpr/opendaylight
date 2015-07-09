# Opendaylight

[![Gem Version](https://badge.fury.io/rb/opendaylight.svg)](http://badge.fury.io/rb/opendaylight)

This gem is made as a ruby wrapper for OpenDayligh's FlowProgrammer API

## Installation

Add this line to your application's Gemfile:

    gem 'opendaylight'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opendaylight

## Usage

Configure with an initializer in config/initializers as follows:

    Opendaylight.configure do |config|
      config.username = "your_username"
      config.password = "your_password"
      config.url = "http://yourserver.com:port/"
    end

Then make a call to Opendaylight's API.makeflow:

For example:

    Opendaylight::API.makeflow(id: "00:00:00:00:00:00:00:02", name: "flow1", actions: "DROP")

API.deleteflow works exactly the same way, except you do not need to specify an action:

    Opendaylight::API.deleteflow(id: "00:00:00:00:00:00:00:02", name: "flow1")

Here are the possible arguments for makeflow. All the arguments default to nil unless otherwise specified:

    #Server information
    url			#Your controller's web url, usually "http://yourserver.com:8080/" (defaults to config url in initializer)
    username		#OpenDaylight login username (defaults to config username in initializer)
    password		#OpenDaylight login password (defaults to config password in initializer)

    #Flow Parameters
    id			#Node ID (usually MAC address) *REQUIRED*
    name		#Flow Name *REQUIRED*
    actions		#OpenDaylight OpenFlow Action *REQUIRED*
    priority		#Flow Priority (default "500")
    ingressPort		#Layer 1 (physical) Source Port
    dlSrc		#Layer 2 (MAC address) source
    dlDst		#Layer 2 (MAC address) Destination
    nwSrc		#Layer 3 (IP address) source
    nwDst		#Layer 3 (IP address) destination
    tpSrc		#Layer 4 (Network Socket Port) Source
    tpDst		#Layer 4 (Network Socket Port) destination
    installInHW		#Make the flow installed and active (default "true")
    type		#Node Type (default "OF")
    protocol		#IP Protocol Number
    etherType		#Ethertype field (default "0x800")
    vlanId		#Virtual LAN ID
    vlanPriority	#Virtual LAN QoS Priotity
    idleTimeout		#Flow Idle Timeout
    tosBits		#Type of Service Bits
    hardTimeout		#Flow Hard Timeout
    cookie		#Cookie enhancements


## OpenDaylight Actions for the actions field

    CONTROLLER   # Send to controller
    DROP         # Drop Packet
    ENQUEUE      # Enqueue Packet
    FLOOD        # Flood packet
    FLOOD_ALL    # Flood to all available ports
    HW_PATH      # Take hardware path
    INTERFACE
    LOOPBACK
    OUTPUT       # Set output port
    POP_VLAN     # Remove VLAN Header
    PUSH _VLAN   # Add VLAN Header
    SET_DL_DST   # Set MAC destination
    SET_DL_SRC   # Set MAC Source
    SET_DL_TYPE
    SET_NEXT_HOP # Set static hop
    SET_NW_DST   # Set IP Destination
    SET_NW_SRC   # Set IP Source
    SET_NW_TOS   # Set Type Of Service
    SET_TP_DST   # Set TCP Destination Port
    SET_TP_SRC   # Set TCP Source Port
    SET_VLAN_CFI
    SET_VLAN_ID  # Set VLAN ID
    SET_VLAN_PCP
    SW_PATH      # Take software path

##Topology

To get your topology, use API.topology:

    Opendaylight::API.topology

This returns a hash of all the edges (links). The hash is organized as follows (I have capitalized things that will come back as variables):

    "edgeProperties"=>[{
            "properties"=>{
                "timeStamp"=>{
                    "value"=>TIMESTAMP, "name"=>"NAME"
                }
                , "name"=>{
                    "value"=>"SWITCHNAME-PORTNAME"
                }
                , "state"=>{
                    "value"=>LINKSTATE
                }
                , "config"=>{
                    "value"=>CONFIGSTATE
                }
                , "bandwidth"=>{
                    "value"=>BANDWIDTH
                }

            }
            , "edge"=>{
                "tailNodeConnector"=>{
                    "node"=>{
                        "id"=>"SWITCHID", "type"=>"SWITCHTYPE" #Usually the switch ID is a MAC address and the type is OF for OpenFlow
                    }
                    , "id"=>"PORTID", "type"=>"LINKTYPE" #I believe the PORTID is the interface of the connected device, type is usually OF for OpenFlow
                }
                , "headNodeConnector"=>{
                    "node"=>{
                        "id"=>"SWITCHID", "type"=>"SWITCHTYPE"
                    }
                    , "id"=>"PORTID", "type"=>"LINKTYPE"
                }

            }

        }
            "properties" => {#This would be the next link
            ....
        }
    }]

For a list of hosts, use API.hostTracker:

    Opendaylight::API.hostTracker

For a list of nodes, use
[API.nodes](https://developer.cisco.com/media/XNCREST/switchmanager/resource_SwitchNorthbound.html#path__-containerName-_nodes.html):

    Opendaylight::API.nodes

    Opendaylight::API.nodes(id: "00:00:00:00:00:00:00:02")

To list all flows, use listFlows:

    Opendaylight::API.listFlows

For statistics, use statistics:

    Opendaylight::API.statistics #Optional statistics("node") or statistics("port")

Defaults to flow statistics.

TODO:
Make the code prettier by splitting into files.
Finish covering the API.
Build a better sample app.

For the current working sample app, check out [Faizi](https://github.com/rickpr/faizi)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/opendaylight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
