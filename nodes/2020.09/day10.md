
# netstat 命令 
>[https://www.cnblogs.com/passzhang/articles/9367534.html](https://www.cnblogs.com/passzhang/articles/9367534.html)  

>[https://www.cnblogs.com/passzhang/articles/9367534.html](https://www.cnblogs.com/passzhang/articles/9367534.html)


`netstat`列含义： 
- `Proto`: 协议名（tcp协议或者udp协议)  
- `recv-Q`: 网络接收队列  
    - 表示收到的数据已经在本地接收缓冲，但是还有多少没有被进程取走，recv()  
    - 如果接收队列Recv-Q一直处于阻塞状态，可能是遭受了拒绝服务 denial-of-service 攻击。  

- `Send-Q`: 网路发送队列  
    - 对方没有收到的数据或者说没有Ack的,还是本地缓冲区. 
    - 如果发送队列Send-Q不能很快的清零，可能是有应用向外发送数据包过快，或者是对方接收数据包不够快。 

**`Recv-Q`和`Send-Q`通常应该为0，如果不为0可能是有问题的。packets在两个队列里都不应该有堆积状态。可接受短暂的非0情况。**  
- `Local Address`: 本地监听地址和端口号 
- `Foreign Address`: 与本机端口通信的外部socket。显示规则与Local Address相同
- `State`: 链路状态，共有11种 
    - `LISTEN`： 侦听状态，等待远程机器的连接请求。
    - `CLOSED`: 初始（无连接）状态。
    - `SYN_SEND`: 尝试建立一个连接,在`TCP`三次握手期间，主动连接端发送了`SYN`包后，进入`SYN_SEND`状态，等待对方的`ACK`包。
    - `SYN_RECV`: 已经接受到了一个连接请求,在`TCP`三次握手期间，主动连接端收到`SYN`包后，进入`SYN_RECV`状态。
    - `ESTABLISHED`: 已经有一个有效连接，完成`TCP`三次握手后，主动连接端进入`ESTABLISHED`状态。此时，`TCP`连接已经建立，可以进行通信。
    - `FIN_WAIT_1`: 等待远程`TCP`的连接中断请求或先前的连接中断请求的确认，在`TCP`四次挥手时，主动关闭端发送`FIN`包后，进入`FIN_WAIT_1`状态。
    - `FIN_WAIT_2`: 从远程`TCP`等待连接中断请求 ,在`TCP`四次挥手时，主动关闭端收到`ACK`包后，进入`FIN_WAIT_2`状态。
    - `TIME_WAIT`: 等待足够的时间以确保远程`TCP`接收到连接中断请求的确认, 在`TCP`四次挥手时，主动关闭端发送了`ACK`包之后，进入`TIME_WAIT`状态，等待最多`MSL`时间，让被动关闭端收到`ACK`包。
    - `CLOSING`: 等待远程`TCP`对连接中断的确认, 在`TCP`四次挥手期间，主动关闭端发送了`FIN`包后，没有收到对应的`ACK`包，却收到对方的`FIN`包，此时，进入`CLOSING`状态。
    - `CLOSE_WAIT`: 等待从本地用户发来的连接中断请求,在`TCP`四次挥手期间，被动关闭端收到`FIN`包后，进入`CLOSE_WAIT`状态。
    - `LAST_ACK`：等待原来发向远程`TCP`的连接中断请求的确,在`TCP`四次挥手时，被动关闭端发送`FIN`包后，进入`LAST_ACK`状态，等待对方的`ACK`包。 

## netstat -i 列说明
- `Iface`: 接口名
- `MTU`: 网络最大传输单元(字节),大部分网络设备都是1500。如果本机的MTU比网关的MTU大，大的数据包就会被拆开来传送，这样会产生很多数据包碎片，增加丢包率，降低网络速度。把本机的MTU设成比网关的MTU小或相同，就可以减少丢包 [https://www.cnblogs.com/wjoyxt/p/6873714.html](https://www.cnblogs.com/wjoyxt/p/6873714.html)。 
- `RX-OK/TX-OK`: 正确接收了多少数据包，发送了多少数据包 
- `RX-ERR/TX-ERR`: 接收、发送数据包的时候，丢弃了多少数据包 
- `RX-OVR/TX-OVR`: 由于错误遗失了多少数据包  
- `Flg`: 标记 
    - `L`: 代表回环地址 
    - `R`: 这个网络接口正在运行中 
    - `U`: 接口正在处于活动中 
    - `B`: 设置了广播地址  
    - `M`: 接收所有数据包  
    - `O`: 表示在该接口上禁止arp
    - `P`: 端对端的连接 
