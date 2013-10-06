#!/bin/sh
#author: jay
# 用于修复arch linux一段时间后路由表的metric值变大问题
route del -net 0.0.0.0/32 gw 192.168.1.1 dev wlp3s0
route add -net 0.0.0.0/32 gw 192.168.1.1 metric 100 dev wlp3s0 
