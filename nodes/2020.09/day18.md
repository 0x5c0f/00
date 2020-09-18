# IPTABLES 
## DROP 和 REJECT 的区别 
- `REJECT`动作会返回一个拒绝(终止)数据包(`TCP FIN`或`UDP-ICMP-PORT-UNREACHABLE`)，明确的拒绝对方的连接动作。
- `DROP`动作只是简单的直接丢弃数据，并不反馈任何回应。需要`Client`等待超时，`Client`容易发现自己被防火墙所阻挡。


