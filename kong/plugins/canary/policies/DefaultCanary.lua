---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2020/2/25 15:26
---
local BaseCanary = require 'kong.plugins.canary.policies.BaseCanary';
local policy = 'default'
local DefaultCanary = BaseCanary:new()
function DefaultCanary:new(o, conf)
  o = o or BaseCanary:new(o, policy, conf)
  setmetatable(o, self);
  self.__index = self;
  return o;
end

function DefaultCanary:validate()
  return true, self.name
end

function DefaultCanary:get_upstream()
  return self.conf.canary_upstream;
end

function DefaultCanary:handler(fallback)
  local validate, policy_canary = self:validate();

  -- false fallback default upstream
  if not validate then
    fallback();
    return 'fallback', policy_canary
  end
  -- uid upstream is not nil
  local _upstream = self:get_upstream()
  if _upstream then
    kong.service.set_upstream(_upstream)
    kong.log.notice('Canary policy is ', policy_canary, ',canary upstream:', _upstream);
    return 'end', policy_canary
  end
end

return DefaultCanary
