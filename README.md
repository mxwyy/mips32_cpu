# mips32_cpu

## 关于本项目

一个单周期mips32 CPU设计。  

### 提示

这个项目并不是完美的设计，只限于学校大作业可以参考。这里很多设计都不足够合理、优化。所以如果您有志于FPGA研究，或者只是想实现完整的CPU以帮助简单理解计算机芯片的设计，建议您参考其他更好、更优秀的设计。例如[自己动手写CPU](https://book.douban.com/subject/25960657/)。 github、B站、知乎等平台也有很多可参考的项目，但是需要筛选，很多项目有资料不全、代码跑不了等问题，注意甄别。  

## 模块划分

- ALU: 计算模块  
	- 两个输出信号zero,neg。zero类似ZF,neg和几个b开头的跳转指令的条件判断相关，具体可以看control模块。
- Control: 控制信号生成模块
- DataMem: 数据存储模块，相当于ram
- Extend: 立即数扩展模块
- HILO: （只有几条乘除法指令涉及到了）
	- HI: 乘法结果高32位寄存器/除法运算的余数
	- LO: 乘法结果低32位寄存器/除法运算的商
- InsMem: 指令存储模块
- InsSub: 指令分段（分为opcode rs rt rd+sa+func/imm，传给后续模块）
- mux4: 多路复用器
- PC: 程序计数器（当前指令地址）
- PCNext: 下一条指令地址
- RegGroup: 寄存器组
- CPU：组合起来的最终模块

## 结构图

![cpu](https://github.com/mxwyy/mips32_cpu/raw/main/png/cpu.png)  

(部分控制信号没有画，要不图片太乱。然后PCNext模块是PC右边这一部分，没有单独画出来)

## 控制信号

控制信号表没有画，可以参见Control模块，里面写了每种指令对应的控制信号。
### 控制信号含义
- PCWre: 更新PC值的使能信号（但其实始终为1，没什么用，可以删掉）
- ExtSel: 无符号扩展/符号扩展
- InsMemR: 读指令寄存器
- sign: 符号控制（例如区分add, addu, 有符号加法/无符号加法）
- mul: 乘法控制（例如区分madd, add, 乘加/加）
- RegDst: 写寄存器来源rt/rd
- RegWre: 写寄存器使能信号
- srcA, srcB: ALU输入A, B的选择信号
- HILOWre: HILO的写使能信号
- PCSel: PCNext选择信号
- Op: opcode
- mRD: DataMem读使能
- mWR: Datamem写使能
- DBSel: 结构图中最右侧多路复用器的选择信号
- bitwid: 指令操作数的长度(32, 16, 8)

## 项目
本项目基于vivado，使用quartus，请从src/自己构建项目。  
第一次开发基于vivado 2017.4，后续更改基于vivado 2020.2

## 测试指令
参见pdf  
pdf前三页为测试指令，第四页为测试的数据（Datamem）  
指令参考来源：[32位mips指令说明](https://blog.csdn.net/qq_39559641/article/details/89608132)  
pdf第五页为指令的总结，其中绿色是完成的指令。剩余六条指令中， lwl, lwr, swl, swr为非对齐的读/写指令，可以基于lw, sw，然后再加控制信号去实现，本人懒得写了。剩下两条ll, sc指令涉及到原子操作，以及可能涉及到的中断、多线程等问题，因为本项目没有后面对接的其他计算机系统软硬件结构，所以不做实现，有兴趣可以自行实现。

## 测试与仿真
每条指令，时钟上升沿来临，更新PC，取址译码，生成控制信号，计算，***时钟下降沿写回***  
这里解释一下写回，写回操作按照写回寄存器和读寄存器（操作数）的寄存器一样不一样分成两类。如果都不一样，则可以直接写回，不要等待时钟下降沿，因此时钟频率也可以提高一倍左右。  
但是如果存在着一样的情况，例如一条普通的运算指令 add $1,$2,$2,如果不用时钟下降沿的话，就会反复读写。例如寄存器1、2分别是数字3、4，3+4=7，这时候如果指令还没有更新到下一条，那么就会继续运算3+7=11,3+11=14...直到下一个时钟上升沿，PC更新下一条，控制信号改变等等，才会进行下一条运算。而这个持续运算的时间，针对不同的指令是不一样的（比如乘法、除法计算时间远多余逻辑与或非的运算时间），所以是没法量化的。因为目前一般指令集是支持读写同一个寄存器，因此用下降沿来作为一个标志，进行一次写操作，从而保证计算正确。  
这类指令有两类，一类是读写寄存器一样的指令，另一类是乘累加这种操作，这里面HILO也是读写一样的寄存器。所以如果你的老师不要求这么完整的实现，你们可以把HILO去掉（同时乘除法相关指令也就不实现了），然后测试指令也不写有读写寄存器相同的指令，那么写regGroup就不用检测下降沿了。lui指令也是读写寄存器相同，不过重复运算不影响结果，逻辑上可以不管。  
行为仿真正确，时序仿真也正确。对于时序仿真，选用的器件是xc7a200tlffg1156-2L，普通的指令一般需要16-18ns,乘法、乘累加需要23ns左右，除法没测试了（跑一次时序仿真时间实在是太久了，累了，有兴趣可以自调整下测试指令去测试除法）。取整的话，普通指令，时钟周期20ns×2=40ns，对应频率25MHz。有乘法指令，时钟周期25×2=50ns，对应频率20MHz。除法的因为没测所以不知道，周期更长，频率更低。如果像上面说的，删除了读写寄存器相同的指令，因为不用等待计算出结果再给下降沿来写回，所以频率可以提升一倍，对应频率50MHz、40MHz、unknown.

## 仿真图
这是前面一部分测试指令的时序仿真图
![mips_test_all](https://github.com/mxwyy/mips32_cpu/raw/main/png/mips_test_all.png)
这里以curPC=0x38这条指令说一下前面提到的写回的事。
![mips_test_0x38](https://github.com/mxwyy/mips32_cpu/raw/main/png/mips_test_0x38.png)
该指令为 andi $5,$5,0xffff  
前面0x10指令计算出了$5寄存器值为0x95511559，可以看到ALUA的值也确实为0x95511559，ALUB为另一个操作数0xffff，根据该指令的运算含义，可以得出运算结果为0x1559，可以看到result正确。DB信号为结构图中最右侧多路复用器的输出值。经过下降沿后，DB的值写入到$5，所以会看到时钟下降沿往后一点之后，仍然在该指令的区域，但是ALU变成了0x1559，也就是此时已经写入完成了。那么新的值就会重新运算，直到下一条指令。对于这条指令，重新计算的结果依然是0x1559，所以对于结果的正确性没有影响，但是如果是上面提到的加法指令，那么每当结果写进寄存器，ALU重新计算，新的结果又写进寄存器，不断往复直到离开这条指令。如果写寄存器和操作数不一样，那ALU的输入不会变，也就不会出现这种情况。为了避免这种情况，所以在下降沿写入，从而保证只写一次，也就是第一次。后面再计算新的结果因为已经错过时钟下降沿，所以不会写入，也就不会出错。

## 结语
本项目有诸多不足，例如
- ALU的计算直接使用运算符，没有设计专门的电路，所以时序仿真时，乘除法很慢。
- 作为单周期CPU，没有多周期设计，所以没有状态机/时序，即，这实际上不是时序电路。
- ALU的输入HI、LO也可以合并到ALUA、ALUB的选择器中。
- 这里面的诸多部分可以直接用IP核，比如最明显的mux4。去年弄的了，现在属实是懒得改了。
- 其他等等  
  
### 总而言之，本项目基本没有学习的价值，单纯只为大作业。你懂得。

## 展望

设计CPU应该说是一个比较综合的练习项目。对于你设计的CPU，主要目的应该是提高时钟频率，例如Intel的CPU现在频率都是GHz级别的。对于该项目，时钟频率基本没有提升的余地了，因为为了提高频率，就必须转成多周期CPU。对于我这个项目的话，更新PC、生成控制信号这些，大概每个步骤6ns左右，通过转成多周期CPU，那么周期降低到6ns，频率就可以提升到166.667MHz，结合流水线技术，可以实现更高的吞吐量。进一步提高频率，要么划分更多的周期，要么为每个模块专门设计高速的电路（而不是像我这个项目，直接写verilog语句让vivado去综合），从而缩短周期。与此同时，也就需要设计多周期加法器、乘法器、除法器等等计算的元件。那么新的问题，例如乘法指令后面紧跟的逻辑与指令，完成乘法指令的周期远多于逻辑与指令，在流水线的情况下，乘法指令没完成时，后面的逻辑与指令乃至后面好几条指令就会开始执行/执行完毕，然而后面的指令的操作数可能需要乘法指令的结果；或者连续两条乘法指令，而ALU里只有一个乘法器。这就引申出了指令间的数据依赖、控制依赖、资源冲突等，为了解决这些问题，就需要乱序执行、指令调度等等。这方面有很多专门的书讲了，例如[《微处理器设计：从设计规划到工艺制造》](https://book.douban.com/subject/3301308/)，这部分已经是新的内容，我不再展开说了。  
融会贯通指令这方面，在往后，可以参考[《CPU设计实战》](https://book.douban.com/subject/35414112/)，构建中断，以及外围的缓存，内存等硬件系统，做出麻雀虽小五脏俱全的计算机硬件系统，再然后可以移植linux，完成在FPGA上实现完整的计算机软硬件系统，作为学生，这已经能让你达到很高的水平了。如果确实有很高的能力，可以去参加龙芯杯试试，还是很有帮助的。

## 后记
本人非FPGA专业研究方向，只是突然看到去年课程做的东西，最近花了几天弄完了之前剩的点尾巴。指令众多，不保证某些指令的实现有小错误，不过应该都可以自己改。上面说的写的也可能有不正确的地方，欢迎大家issue指正。现在研究任务还是比较繁重，以后轻松了可能自己会按照上面的路径写一写。不过说实话，这些很多人都已经做过了，如果你现在想学习，网上是有非常多可参考可学习的资源。我对FPGA只能说是有兴趣，专业性的问题、意见建议还是去问专业的人员。最后，加油！
