-- Setting up test environment
    -- sudo apt install orthanc -y && ./Orthanc
    -- verify lua avaliability within wireshark
    -- echo "print('hello')" > test.lua && tshark -X lua_script:test.lua
    -- great source: https://mika-s.github.io/wireshark/lua/dissector/2017/11/04/creating-a-wireshark-dissector-in-lua-1.html

    mongodb_protocol = Proto("MongoDB",  "MongoDB Protocol")

    message_length = ProtoField.int32("mongodb.message_length", "messageLength", base.DEC)
    request_id     = ProtoField.int32("mongodb.requestid"     , "requestID"    , base.DEC)
    response_to    = ProtoField.int32("mongodb.responseto"    , "responseTo"   , base.DEC)
    opcode         = ProtoField.int32("mongodb.opcode"        , "opCode"       , base.DEC)
    
    mongodb_protocol.fields = { message_length, request_id, response_to, opcode }
    
    function mongodb_protocol.dissector(buffer, pinfo, tree)
      length = buffer:len()
      if length == 0 then return end
    
      pinfo.cols.protocol = mongodb_protocol.name
    
      local subtree = tree:add(mongodb_protocol, buffer(), "MongoDB Protocol Data")
    
      subtree:add_le(message_length, buffer(0,4))
      subtree:add_le(request_id,     buffer(4,4))
      subtree:add_le(response_to,    buffer(8,4))
      subtree:add_le(opcode,         buffer(12,4))
    end
    
    local tcp_port = DissectorTable.get("tcp.port")
    tcp_port:add(59274, mongodb_protocol)