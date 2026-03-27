
src/kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000d117          	auipc	sp,0xd
    80000004:	ad010113          	addi	sp,sp,-1328 # 8000cad0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000003a:	6318                	ld	a4,0(a4)
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	0000d717          	auipc	a4,0xd
    80000054:	94070713          	addi	a4,a4,-1728 # 8000c990 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00007797          	auipc	a5,0x7
    80000066:	b6e78793          	addi	a5,a5,-1170 # 80006bd0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff8e367>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	efe78793          	addi	a5,a5,-258 # 80000faa <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	f84a                	sd	s2,48(sp)
    80000108:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000010a:	04c05663          	blez	a2,80000156 <consolewrite+0x56>
    8000010e:	fc26                	sd	s1,56(sp)
    80000110:	f44e                	sd	s3,40(sp)
    80000112:	f052                	sd	s4,32(sp)
    80000114:	ec56                	sd	s5,24(sp)
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00003097          	auipc	ra,0x3
    8000012e:	cb6080e7          	jalr	-842(ra) # 80002de0 <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7e4080e7          	jalr	2020(ra) # 8000091e <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
    8000014c:	74e2                	ld	s1,56(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	a039                	j	80000162 <consolewrite+0x62>
    80000156:	4901                	li	s2,0
    80000158:	a029                	j	80000162 <consolewrite+0x62>
    8000015a:	74e2                	ld	s1,56(sp)
    8000015c:	79a2                	ld	s3,40(sp)
    8000015e:	7a02                	ld	s4,32(sp)
    80000160:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80000162:	854a                	mv	a0,s2
    80000164:	60a6                	ld	ra,72(sp)
    80000166:	6406                	ld	s0,64(sp)
    80000168:	7942                	ld	s2,48(sp)
    8000016a:	6161                	addi	sp,sp,80
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018c:	00015517          	auipc	a0,0x15
    80000190:	94450513          	addi	a0,a0,-1724 # 80014ad0 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	b7c080e7          	jalr	-1156(ra) # 80000d10 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019c:	00015497          	auipc	s1,0x15
    800001a0:	93448493          	addi	s1,s1,-1740 # 80014ad0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a4:	00015917          	auipc	s2,0x15
    800001a8:	9c490913          	addi	s2,s2,-1596 # 80014b68 <cons+0x98>
  while(n > 0){
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
    while(cons.r == cons.w){
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
      if(killed(myproc())){
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	c58080e7          	jalr	-936(ra) # 80001e14 <myproc>
    800001c4:	00003097          	auipc	ra,0x3
    800001c8:	924080e7          	jalr	-1756(ra) # 80002ae8 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	4f0080e7          	jalr	1264(ra) # 800026c2 <sleep>
    while(cons.r == cons.w){
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00015717          	auipc	a4,0x15
    800001ec:	8e870713          	addi	a4,a4,-1816 # 80014ad0 <cons>
    800001f0:	0017869b          	addiw	a3,a5,1
    800001f4:	08d72c23          	sw	a3,152(a4)
    800001f8:	07f7f693          	andi	a3,a5,127
    800001fc:	9736                	add	a4,a4,a3
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000206:	4691                	li	a3,4
    80000208:	04db8a63          	beq	s7,a3,8000025c <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000020c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	faf40613          	addi	a2,s0,-81
    80000216:	85d2                	mv	a1,s4
    80000218:	8556                	mv	a0,s5
    8000021a:	00003097          	auipc	ra,0x3
    8000021e:	b70080e7          	jalr	-1168(ra) # 80002d8a <either_copyout>
    80000222:	57fd                	li	a5,-1
    80000224:	04f50a63          	beq	a0,a5,80000278 <consoleread+0x10a>
      break;

    dst++;
    80000228:	0a05                	addi	s4,s4,1
    --n;
    8000022a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000022c:	47a9                	li	a5,10
    8000022e:	06fb8163          	beq	s7,a5,80000290 <consoleread+0x122>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	bfa5                	j	800001ac <consoleread+0x3e>
        release(&cons.lock);
    80000236:	00015517          	auipc	a0,0x15
    8000023a:	89a50513          	addi	a0,a0,-1894 # 80014ad0 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	b86080e7          	jalr	-1146(ra) # 80000dc4 <release>
        return -1;
    80000246:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000248:	60e6                	ld	ra,88(sp)
    8000024a:	6446                	ld	s0,80(sp)
    8000024c:	64a6                	ld	s1,72(sp)
    8000024e:	6906                	ld	s2,64(sp)
    80000250:	79e2                	ld	s3,56(sp)
    80000252:	7a42                	ld	s4,48(sp)
    80000254:	7aa2                	ld	s5,40(sp)
    80000256:	7b02                	ld	s6,32(sp)
    80000258:	6125                	addi	sp,sp,96
    8000025a:	8082                	ret
      if(n < target){
    8000025c:	0009871b          	sext.w	a4,s3
    80000260:	01677a63          	bgeu	a4,s6,80000274 <consoleread+0x106>
        cons.r--;
    80000264:	00015717          	auipc	a4,0x15
    80000268:	90f72223          	sw	a5,-1788(a4) # 80014b68 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000027a:	00015517          	auipc	a0,0x15
    8000027e:	85650513          	addi	a0,a0,-1962 # 80014ad0 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	b42080e7          	jalr	-1214(ra) # 80000dc4 <release>
  return target - n;
    8000028a:	413b053b          	subw	a0,s6,s3
    8000028e:	bf6d                	j	80000248 <consoleread+0xda>
    80000290:	6be2                	ld	s7,24(sp)
    80000292:	b7e5                	j	8000027a <consoleread+0x10c>

0000000080000294 <consputc>:
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e406                	sd	ra,8(sp)
    80000298:	e022                	sd	s0,0(sp)
    8000029a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000029c:	10000793          	li	a5,256
    800002a0:	00f50a63          	beq	a0,a5,800002b4 <consputc+0x20>
    uartputc_sync(c);
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	59c080e7          	jalr	1436(ra) # 80000840 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	58a080e7          	jalr	1418(ra) # 80000840 <uartputc_sync>
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	57e080e7          	jalr	1406(ra) # 80000840 <uartputc_sync>
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	574080e7          	jalr	1396(ra) # 80000840 <uartputc_sync>
    800002d4:	bfe1                	j	800002ac <consputc+0x18>

00000000800002d6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002d6:	1101                	addi	sp,sp,-32
    800002d8:	ec06                	sd	ra,24(sp)
    800002da:	e822                	sd	s0,16(sp)
    800002dc:	e426                	sd	s1,8(sp)
    800002de:	1000                	addi	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e2:	00014517          	auipc	a0,0x14
    800002e6:	7ee50513          	addi	a0,a0,2030 # 80014ad0 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	a26080e7          	jalr	-1498(ra) # 80000d10 <acquire>

  switch(c){
    800002f2:	47d5                	li	a5,21
    800002f4:	0af48563          	beq	s1,a5,8000039e <consoleintr+0xc8>
    800002f8:	0297c963          	blt	a5,s1,8000032a <consoleintr+0x54>
    800002fc:	47a1                	li	a5,8
    800002fe:	0ef48c63          	beq	s1,a5,800003f6 <consoleintr+0x120>
    80000302:	47c1                	li	a5,16
    80000304:	10f49f63          	bne	s1,a5,80000422 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80000308:	00003097          	auipc	ra,0x3
    8000030c:	b2e080e7          	jalr	-1234(ra) # 80002e36 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000310:	00014517          	auipc	a0,0x14
    80000314:	7c050513          	addi	a0,a0,1984 # 80014ad0 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	aac080e7          	jalr	-1364(ra) # 80000dc4 <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6105                	addi	sp,sp,32
    80000328:	8082                	ret
  switch(c){
    8000032a:	07f00793          	li	a5,127
    8000032e:	0cf48463          	beq	s1,a5,800003f6 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000332:	00014717          	auipc	a4,0x14
    80000336:	79e70713          	addi	a4,a4,1950 # 80014ad0 <cons>
    8000033a:	0a072783          	lw	a5,160(a4)
    8000033e:	09872703          	lw	a4,152(a4)
    80000342:	9f99                	subw	a5,a5,a4
    80000344:	07f00713          	li	a4,127
    80000348:	fcf764e3          	bltu	a4,a5,80000310 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    8000034c:	47b5                	li	a5,13
    8000034e:	0cf48d63          	beq	s1,a5,80000428 <consoleintr+0x152>
      consputc(c);
    80000352:	8526                	mv	a0,s1
    80000354:	00000097          	auipc	ra,0x0
    80000358:	f40080e7          	jalr	-192(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000035c:	00014797          	auipc	a5,0x14
    80000360:	77478793          	addi	a5,a5,1908 # 80014ad0 <cons>
    80000364:	0a07a683          	lw	a3,160(a5)
    80000368:	0016871b          	addiw	a4,a3,1
    8000036c:	0007061b          	sext.w	a2,a4
    80000370:	0ae7a023          	sw	a4,160(a5)
    80000374:	07f6f693          	andi	a3,a3,127
    80000378:	97b6                	add	a5,a5,a3
    8000037a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000037e:	47a9                	li	a5,10
    80000380:	0cf48b63          	beq	s1,a5,80000456 <consoleintr+0x180>
    80000384:	4791                	li	a5,4
    80000386:	0cf48863          	beq	s1,a5,80000456 <consoleintr+0x180>
    8000038a:	00014797          	auipc	a5,0x14
    8000038e:	7de7a783          	lw	a5,2014(a5) # 80014b68 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800003a0:	00014717          	auipc	a4,0x14
    800003a4:	73070713          	addi	a4,a4,1840 # 80014ad0 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003b0:	00014497          	auipc	s1,0x14
    800003b4:	72048493          	addi	s1,s1,1824 # 80014ad0 <cons>
    while(cons.e != cons.w &&
    800003b8:	4929                	li	s2,10
    800003ba:	02f70a63          	beq	a4,a5,800003ee <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	07f7f713          	andi	a4,a5,127
    800003c4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c6:	01874703          	lbu	a4,24(a4)
    800003ca:	03270463          	beq	a4,s2,800003f2 <consoleintr+0x11c>
      cons.e--;
    800003ce:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	ebe080e7          	jalr	-322(ra) # 80000294 <consputc>
    while(cons.e != cons.w &&
    800003de:	0a04a783          	lw	a5,160(s1)
    800003e2:	09c4a703          	lw	a4,156(s1)
    800003e6:	fcf71ce3          	bne	a4,a5,800003be <consoleintr+0xe8>
    800003ea:	6902                	ld	s2,0(sp)
    800003ec:	b715                	j	80000310 <consoleintr+0x3a>
    800003ee:	6902                	ld	s2,0(sp)
    800003f0:	b705                	j	80000310 <consoleintr+0x3a>
    800003f2:	6902                	ld	s2,0(sp)
    800003f4:	bf31                	j	80000310 <consoleintr+0x3a>
    if(cons.e != cons.w){
    800003f6:	00014717          	auipc	a4,0x14
    800003fa:	6da70713          	addi	a4,a4,1754 # 80014ad0 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
      cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00014717          	auipc	a4,0x14
    80000410:	76f72223          	sw	a5,1892(a4) # 80014b70 <cons+0xa0>
      consputc(BACKSPACE);
    80000414:	10000513          	li	a0,256
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	e7c080e7          	jalr	-388(ra) # 80000294 <consputc>
    80000420:	bdc5                	j	80000310 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000422:	ee0487e3          	beqz	s1,80000310 <consoleintr+0x3a>
    80000426:	b731                	j	80000332 <consoleintr+0x5c>
      consputc(c);
    80000428:	4529                	li	a0,10
    8000042a:	00000097          	auipc	ra,0x0
    8000042e:	e6a080e7          	jalr	-406(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000432:	00014797          	auipc	a5,0x14
    80000436:	69e78793          	addi	a5,a5,1694 # 80014ad0 <cons>
    8000043a:	0a07a703          	lw	a4,160(a5)
    8000043e:	0017069b          	addiw	a3,a4,1
    80000442:	0006861b          	sext.w	a2,a3
    80000446:	0ad7a023          	sw	a3,160(a5)
    8000044a:	07f77713          	andi	a4,a4,127
    8000044e:	97ba                	add	a5,a5,a4
    80000450:	4729                	li	a4,10
    80000452:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000456:	00014797          	auipc	a5,0x14
    8000045a:	70c7ab23          	sw	a2,1814(a5) # 80014b6c <cons+0x9c>
        wakeup(&cons.r);
    8000045e:	00014517          	auipc	a0,0x14
    80000462:	70a50513          	addi	a0,a0,1802 # 80014b68 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	2c0080e7          	jalr	704(ra) # 80002726 <wakeup>
    8000046e:	b54d                	j	80000310 <consoleintr+0x3a>

0000000080000470 <consoleinit>:

void
consoleinit(void)
{
    80000470:	1141                	addi	sp,sp,-16
    80000472:	e406                	sd	ra,8(sp)
    80000474:	e022                	sd	s0,0(sp)
    80000476:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000478:	0000b597          	auipc	a1,0xb
    8000047c:	b9858593          	addi	a1,a1,-1128 # 8000b010 <etext+0x10>
    80000480:	00014517          	auipc	a0,0x14
    80000484:	65050513          	addi	a0,a0,1616 # 80014ad0 <cons>
    80000488:	00000097          	auipc	ra,0x0
    8000048c:	7f8080e7          	jalr	2040(ra) # 80000c80 <initlock>

  uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	354080e7          	jalr	852(ra) # 800007e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000498:	0006d797          	auipc	a5,0x6d
    8000049c:	9d078793          	addi	a5,a5,-1584 # 8006ce68 <devsw>
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	cce70713          	addi	a4,a4,-818 # 8000016e <consoleread>
    800004a8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004aa:	00000717          	auipc	a4,0x0
    800004ae:	c5670713          	addi	a4,a4,-938 # 80000100 <consolewrite>
    800004b2:	ef98                	sd	a4,24(a5)
}
    800004b4:	60a2                	ld	ra,8(sp)
    800004b6:	6402                	ld	s0,0(sp)
    800004b8:	0141                	addi	sp,sp,16
    800004ba:	8082                	ret

00000000800004bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004bc:	7179                	addi	sp,sp,-48
    800004be:	f406                	sd	ra,40(sp)
    800004c0:	f022                	sd	s0,32(sp)
    800004c2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004c4:	c219                	beqz	a2,800004ca <printint+0xe>
    800004c6:	08054963          	bltz	a0,80000558 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ca:	2501                	sext.w	a0,a0
    800004cc:	4881                	li	a7,0
    800004ce:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	0000c617          	auipc	a2,0xc
    800004da:	a0a60613          	addi	a2,a2,-1526 # 8000bee0 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x22>

  if(sign)
    80000502:	00088c63          	beqz	a7,8000051a <printint+0x5e>
    buf[i++] = '-';
    80000506:	fe070793          	addi	a5,a4,-32
    8000050a:	00878733          	add	a4,a5,s0
    8000050e:	02d00793          	li	a5,45
    80000512:	fef70823          	sb	a5,-16(a4)
    80000516:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000051a:	02e05b63          	blez	a4,80000550 <printint+0x94>
    8000051e:	ec26                	sd	s1,24(sp)
    80000520:	e84a                	sd	s2,16(sp)
    80000522:	fd040793          	addi	a5,s0,-48
    80000526:	00e784b3          	add	s1,a5,a4
    8000052a:	fff78913          	addi	s2,a5,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	377d                	addiw	a4,a4,-1
    80000532:	1702                	slli	a4,a4,0x20
    80000534:	9301                	srli	a4,a4,0x20
    80000536:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000053a:	fff4c503          	lbu	a0,-1(s1)
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	d56080e7          	jalr	-682(ra) # 80000294 <consputc>
  while(--i >= 0)
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	ff2499e3          	bne	s1,s2,8000053a <printint+0x7e>
    8000054c:	64e2                	ld	s1,24(sp)
    8000054e:	6942                	ld	s2,16(sp)
}
    80000550:	70a2                	ld	ra,40(sp)
    80000552:	7402                	ld	s0,32(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
    x = -xx;
    80000558:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055c:	4885                	li	a7,1
    x = -xx;
    8000055e:	bf85                	j	800004ce <printint+0x12>

0000000080000560 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056c:	00014797          	auipc	a5,0x14
    80000570:	6207a223          	sw	zero,1572(a5) # 80014b90 <pr+0x18>
  printf("panic: ");
    80000574:	0000b517          	auipc	a0,0xb
    80000578:	aa450513          	addi	a0,a0,-1372 # 8000b018 <etext+0x18>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	0000b517          	auipc	a0,0xb
    80000592:	a9250513          	addi	a0,a0,-1390 # 8000b020 <etext+0x20>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	0000c717          	auipc	a4,0xc
    800005a4:	38f72823          	sw	a5,912(a4) # 8000c930 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	f06a                	sd	s10,32(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00014d17          	auipc	s10,0x14
    800005ce:	5c6d2d03          	lw	s10,1478(s10) # 80014b90 <pr+0x18>
  if(locking)
    800005d2:	040d1463          	bnez	s10,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050b63          	beqz	a0,8000077c <printf+0x1d2>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	ec6e                	sd	s11,24(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000608:	0000ca97          	auipc	s5,0xc
    8000060c:	8d8a8a93          	addi	s5,s5,-1832 # 8000bee0 <digits>
    switch(c){
    80000610:	07300c13          	li	s8,115
    80000614:	06400d93          	li	s11,100
    80000618:	a0b1                	j	80000664 <printf+0xba>
    acquire(&pr.lock);
    8000061a:	00014517          	auipc	a0,0x14
    8000061e:	55e50513          	addi	a0,a0,1374 # 80014b78 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	6ee080e7          	jalr	1774(ra) # 80000d10 <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000063e:	0000b517          	auipc	a0,0xb
    80000642:	9f250513          	addi	a0,a0,-1550 # 8000b030 <etext+0x30>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c46080e7          	jalr	-954(ra) # 80000294 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	2985                	addiw	s3,s3,1
    80000658:	013a07b3          	add	a5,s4,s3
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c0>
    if(c != '%'){
    80000664:	ff6515e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	2985                	addiw	s3,s3,1
    8000066a:	013a07b3          	add	a5,s4,s3
    8000066e:	0007c783          	lbu	a5,0(a5)
    80000672:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000676:	10078b63          	beqz	a5,8000078c <printf+0x1e2>
    switch(c){
    8000067a:	05778a63          	beq	a5,s7,800006ce <printf+0x124>
    8000067e:	02fbf663          	bgeu	s7,a5,800006aa <printf+0x100>
    80000682:	09878863          	beq	a5,s8,80000712 <printf+0x168>
    80000686:	07800713          	li	a4,120
    8000068a:	0ce79563          	bne	a5,a4,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85e6                	mv	a1,s9
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e1c080e7          	jalr	-484(ra) # 800004bc <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	09678f63          	beq	a5,s6,80000748 <printf+0x19e>
    800006ae:	0bb79363          	bne	a5,s11,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4605                	li	a2,1
    800006c0:	45a9                	li	a1,10
    800006c2:	4388                	lw	a0,0(a5)
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	df8080e7          	jalr	-520(ra) # 800004bc <printint>
      break;
    800006cc:	b769                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006de:	03000513          	li	a0,48
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	bb2080e7          	jalr	-1102(ra) # 80000294 <consputc>
  consputc('x');
    800006ea:	07800513          	li	a0,120
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	ba6080e7          	jalr	-1114(ra) # 80000294 <consputc>
    800006f6:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b92080e7          	jalr	-1134(ra) # 80000294 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x14e>
    80000710:	b799                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x190>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d905                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b6c080e7          	jalr	-1172(ra) # 80000294 <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x17e>
    80000738:	bf39                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073a:	0000b497          	auipc	s1,0xb
    8000073e:	8ee48493          	addi	s1,s1,-1810 # 8000b028 <etext+0x28>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x17e>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b4a080e7          	jalr	-1206(ra) # 80000294 <consputc>
      break;
    80000752:	b711                	j	80000656 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b3e080e7          	jalr	-1218(ra) # 80000294 <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b34080e7          	jalr	-1228(ra) # 80000294 <consputc>
      break;
    80000768:	b5fd                	j	80000656 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	6de2                	ld	s11,24(sp)
  if(locking)
    8000077c:	020d1263          	bnez	s10,800007a0 <printf+0x1f6>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	7d02                	ld	s10,32(sp)
    80000788:	6129                	addi	sp,sp,192
    8000078a:	8082                	ret
    8000078c:	74a6                	ld	s1,104(sp)
    8000078e:	7906                	ld	s2,96(sp)
    80000790:	69e6                	ld	s3,88(sp)
    80000792:	6aa6                	ld	s5,72(sp)
    80000794:	6b06                	ld	s6,64(sp)
    80000796:	7be2                	ld	s7,56(sp)
    80000798:	7c42                	ld	s8,48(sp)
    8000079a:	7ca2                	ld	s9,40(sp)
    8000079c:	6de2                	ld	s11,24(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d2>
    release(&pr.lock);
    800007a0:	00014517          	auipc	a0,0x14
    800007a4:	3d850513          	addi	a0,a0,984 # 80014b78 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	61c080e7          	jalr	1564(ra) # 80000dc4 <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d6>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1101                	addi	sp,sp,-32
    800007b4:	ec06                	sd	ra,24(sp)
    800007b6:	e822                	sd	s0,16(sp)
    800007b8:	e426                	sd	s1,8(sp)
    800007ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007bc:	00014497          	auipc	s1,0x14
    800007c0:	3bc48493          	addi	s1,s1,956 # 80014b78 <pr>
    800007c4:	0000b597          	auipc	a1,0xb
    800007c8:	87c58593          	addi	a1,a1,-1924 # 8000b040 <etext+0x40>
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	4b2080e7          	jalr	1202(ra) # 80000c80 <initlock>
  pr.locking = 1;
    800007d6:	4785                	li	a5,1
    800007d8:	cc9c                	sw	a5,24(s1)
}
    800007da:	60e2                	ld	ra,24(sp)
    800007dc:	6442                	ld	s0,16(sp)
    800007de:	64a2                	ld	s1,8(sp)
    800007e0:	6105                	addi	sp,sp,32
    800007e2:	8082                	ret

00000000800007e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e406                	sd	ra,8(sp)
    800007e8:	e022                	sd	s0,0(sp)
    800007ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ec:	100007b7          	lui	a5,0x10000
    800007f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f4:	10000737          	lui	a4,0x10000
    800007f8:	f8000693          	li	a3,-128
    800007fc:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000800:	468d                	li	a3,3
    80000802:	10000637          	lui	a2,0x10000
    80000806:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000080e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000812:	10000737          	lui	a4,0x10000
    80000816:	461d                	li	a2,7
    80000818:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000820:	0000b597          	auipc	a1,0xb
    80000824:	82858593          	addi	a1,a1,-2008 # 8000b048 <etext+0x48>
    80000828:	00014517          	auipc	a0,0x14
    8000082c:	37050513          	addi	a0,a0,880 # 80014b98 <uart_tx_lock>
    80000830:	00000097          	auipc	ra,0x0
    80000834:	450080e7          	jalr	1104(ra) # 80000c80 <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000840:	1101                	addi	sp,sp,-32
    80000842:	ec06                	sd	ra,24(sp)
    80000844:	e822                	sd	s0,16(sp)
    80000846:	e426                	sd	s1,8(sp)
    80000848:	1000                	addi	s0,sp,32
    8000084a:	84aa                	mv	s1,a0
  push_off();
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	478080e7          	jalr	1144(ra) # 80000cc4 <push_off>

  if(panicked){
    80000854:	0000c797          	auipc	a5,0xc
    80000858:	0dc7a783          	lw	a5,220(a5) # 8000c930 <panicked>
    8000085c:	eb85                	bnez	a5,8000088c <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085e:	10000737          	lui	a4,0x10000
    80000862:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000864:	00074783          	lbu	a5,0(a4)
    80000868:	0207f793          	andi	a5,a5,32
    8000086c:	dfe5                	beqz	a5,80000864 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086e:	0ff4f513          	zext.b	a0,s1
    80000872:	100007b7          	lui	a5,0x10000
    80000876:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	4ea080e7          	jalr	1258(ra) # 80000d64 <pop_off>
}
    80000882:	60e2                	ld	ra,24(sp)
    80000884:	6442                	ld	s0,16(sp)
    80000886:	64a2                	ld	s1,8(sp)
    80000888:	6105                	addi	sp,sp,32
    8000088a:	8082                	ret
    for(;;)
    8000088c:	a001                	j	8000088c <uartputc_sync+0x4c>

000000008000088e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088e:	0000c797          	auipc	a5,0xc
    80000892:	0aa7b783          	ld	a5,170(a5) # 8000c938 <uart_tx_r>
    80000896:	0000c717          	auipc	a4,0xc
    8000089a:	0aa73703          	ld	a4,170(a4) # 8000c940 <uart_tx_w>
    8000089e:	06f70f63          	beq	a4,a5,8000091c <uartstart+0x8e>
{
    800008a2:	7139                	addi	sp,sp,-64
    800008a4:	fc06                	sd	ra,56(sp)
    800008a6:	f822                	sd	s0,48(sp)
    800008a8:	f426                	sd	s1,40(sp)
    800008aa:	f04a                	sd	s2,32(sp)
    800008ac:	ec4e                	sd	s3,24(sp)
    800008ae:	e852                	sd	s4,16(sp)
    800008b0:	e456                	sd	s5,8(sp)
    800008b2:	e05a                	sd	s6,0(sp)
    800008b4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b6:	10000937          	lui	s2,0x10000
    800008ba:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008bc:	00014a97          	auipc	s5,0x14
    800008c0:	2dca8a93          	addi	s5,s5,732 # 80014b98 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000c497          	auipc	s1,0xc
    800008c8:	07448493          	addi	s1,s1,116 # 8000c938 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000c997          	auipc	s3,0xc
    800008d4:	07098993          	addi	s3,s3,112 # 8000c940 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d8:	00094703          	lbu	a4,0(s2)
    800008dc:	02077713          	andi	a4,a4,32
    800008e0:	c705                	beqz	a4,80000908 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e2:	01f7f713          	andi	a4,a5,31
    800008e6:	9756                	add	a4,a4,s5
    800008e8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ec:	0785                	addi	a5,a5,1
    800008ee:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008f0:	8526                	mv	a0,s1
    800008f2:	00002097          	auipc	ra,0x2
    800008f6:	e34080e7          	jalr	-460(ra) # 80002726 <wakeup>
    WriteReg(THR, c);
    800008fa:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fe:	609c                	ld	a5,0(s1)
    80000900:	0009b703          	ld	a4,0(s3)
    80000904:	fcf71ae3          	bne	a4,a5,800008d8 <uartstart+0x4a>
  }
}
    80000908:	70e2                	ld	ra,56(sp)
    8000090a:	7442                	ld	s0,48(sp)
    8000090c:	74a2                	ld	s1,40(sp)
    8000090e:	7902                	ld	s2,32(sp)
    80000910:	69e2                	ld	s3,24(sp)
    80000912:	6a42                	ld	s4,16(sp)
    80000914:	6aa2                	ld	s5,8(sp)
    80000916:	6b02                	ld	s6,0(sp)
    80000918:	6121                	addi	sp,sp,64
    8000091a:	8082                	ret
    8000091c:	8082                	ret

000000008000091e <uartputc>:
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
    8000092e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000930:	00014517          	auipc	a0,0x14
    80000934:	26850513          	addi	a0,a0,616 # 80014b98 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	3d8080e7          	jalr	984(ra) # 80000d10 <acquire>
  if(panicked){
    80000940:	0000c797          	auipc	a5,0xc
    80000944:	ff07a783          	lw	a5,-16(a5) # 8000c930 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000c717          	auipc	a4,0xc
    8000094e:	ff673703          	ld	a4,-10(a4) # 8000c940 <uart_tx_w>
    80000952:	0000c797          	auipc	a5,0xc
    80000956:	fe67b783          	ld	a5,-26(a5) # 8000c938 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00014997          	auipc	s3,0x14
    80000962:	23a98993          	addi	s3,s3,570 # 80014b98 <uart_tx_lock>
    80000966:	0000c497          	auipc	s1,0xc
    8000096a:	fd248493          	addi	s1,s1,-46 # 8000c938 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000c917          	auipc	s2,0xc
    80000972:	fd290913          	addi	s2,s2,-46 # 8000c940 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	d44080e7          	jalr	-700(ra) # 800026c2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00014497          	auipc	s1,0x14
    80000998:	20448493          	addi	s1,s1,516 # 80014b98 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000c797          	auipc	a5,0xc
    800009ac:	f8e7bc23          	sd	a4,-104(a5) # 8000c940 <uart_tx_w>
  uartstart();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	ede080e7          	jalr	-290(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    800009b8:	8526                	mv	a0,s1
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	40a080e7          	jalr	1034(ra) # 80000dc4 <release>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret
    for(;;)
    800009d2:	a001                	j	800009d2 <uartputc+0xb4>

00000000800009d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d4:	1141                	addi	sp,sp,-16
    800009d6:	e422                	sd	s0,8(sp)
    800009d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009da:	100007b7          	lui	a5,0x10000
    800009de:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009e0:	0007c783          	lbu	a5,0(a5)
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb81                	beqz	a5,800009f6 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	6422                	ld	s0,8(sp)
    800009f2:	0141                	addi	sp,sp,16
    800009f4:	8082                	ret
    return -1;
    800009f6:	557d                	li	a0,-1
    800009f8:	bfe5                	j	800009f0 <uartgetc+0x1c>

00000000800009fa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fa:	1101                	addi	sp,sp,-32
    800009fc:	ec06                	sd	ra,24(sp)
    800009fe:	e822                	sd	s0,16(sp)
    80000a00:	e426                	sd	s1,8(sp)
    80000a02:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a04:	54fd                	li	s1,-1
    80000a06:	a029                	j	80000a10 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	8ce080e7          	jalr	-1842(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	fc4080e7          	jalr	-60(ra) # 800009d4 <uartgetc>
    if(c == -1)
    80000a18:	fe9518e3          	bne	a0,s1,80000a08 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1c:	00014497          	auipc	s1,0x14
    80000a20:	17c48493          	addi	s1,s1,380 # 80014b98 <uart_tx_lock>
    80000a24:	8526                	mv	a0,s1
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	2ea080e7          	jalr	746(ra) # 80000d10 <acquire>
  uartstart();
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	e60080e7          	jalr	-416(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	38c080e7          	jalr	908(ra) # 80000dc4 <release>
}
    80000a40:	60e2                	ld	ra,24(sp)
    80000a42:	6442                	ld	s0,16(sp)
    80000a44:	64a2                	ld	s1,8(sp)
    80000a46:	6105                	addi	sp,sp,32
    80000a48:	8082                	ret

0000000080000a4a <add_page_reference>:
struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void add_page_reference(uint64 pointer_in_page){
    80000a4a:	1101                	addi	sp,sp,-32
    80000a4c:	ec06                	sd	ra,24(sp)
    80000a4e:	e822                	sd	s0,16(sp)
    80000a50:	e426                	sd	s1,8(sp)
    80000a52:	e04a                	sd	s2,0(sp)
    80000a54:	1000                	addi	s0,sp,32
    80000a56:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    80000a58:	00014917          	auipc	s2,0x14
    80000a5c:	17890913          	addi	s2,s2,376 # 80014bd0 <kmem>
    80000a60:	854a                	mv	a0,s2
    80000a62:	00000097          	auipc	ra,0x0
    80000a66:	2ae080e7          	jalr	686(ra) # 80000d10 <acquire>
  uint page_num = PGROUNDDOWN((uint64)pointer_in_page)/PGSIZE;
    80000a6a:	80b1                	srli	s1,s1,0xc
  ref_counter[page_num]++;
    80000a6c:	02049793          	slli	a5,s1,0x20
    80000a70:	01d7d493          	srli	s1,a5,0x1d
    80000a74:	00014797          	auipc	a5,0x14
    80000a78:	17c78793          	addi	a5,a5,380 # 80014bf0 <ref_counter>
    80000a7c:	97a6                	add	a5,a5,s1
    80000a7e:	6398                	ld	a4,0(a5)
    80000a80:	0705                	addi	a4,a4,1
    80000a82:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000a84:	854a                	mv	a0,s2
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	33e080e7          	jalr	830(ra) # 80000dc4 <release>
}
    80000a8e:	60e2                	ld	ra,24(sp)
    80000a90:	6442                	ld	s0,16(sp)
    80000a92:	64a2                	ld	s1,8(sp)
    80000a94:	6902                	ld	s2,0(sp)
    80000a96:	6105                	addi	sp,sp,32
    80000a98:	8082                	ret

0000000080000a9a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a9a:	1101                	addi	sp,sp,-32
    80000a9c:	ec06                	sd	ra,24(sp)
    80000a9e:	e822                	sd	s0,16(sp)
    80000aa0:	e426                	sd	s1,8(sp)
    80000aa2:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000aa4:	03451793          	slli	a5,a0,0x34
    80000aa8:	efd9                	bnez	a5,80000b46 <kfree+0xac>
    80000aaa:	84aa                	mv	s1,a0
    80000aac:	00070797          	auipc	a5,0x70
    80000ab0:	9ec78793          	addi	a5,a5,-1556 # 80070498 <end>
    80000ab4:	08f56963          	bltu	a0,a5,80000b46 <kfree+0xac>
    80000ab8:	47c5                	li	a5,17
    80000aba:	07ee                	slli	a5,a5,0x1b
    80000abc:	08f57563          	bgeu	a0,a5,80000b46 <kfree+0xac>
    panic("kfree");

  acquire(&kmem.lock);
    80000ac0:	00014517          	auipc	a0,0x14
    80000ac4:	11050513          	addi	a0,a0,272 # 80014bd0 <kmem>
    80000ac8:	00000097          	auipc	ra,0x0
    80000acc:	248080e7          	jalr	584(ra) # 80000d10 <acquire>
  uint64 page_num = PGROUNDDOWN((uint64)pa)/PGSIZE;
    80000ad0:	00c4d793          	srli	a5,s1,0xc
  if (ref_counter[page_num] > 1) {
    80000ad4:	00379693          	slli	a3,a5,0x3
    80000ad8:	00014717          	auipc	a4,0x14
    80000adc:	11870713          	addi	a4,a4,280 # 80014bf0 <ref_counter>
    80000ae0:	9736                	add	a4,a4,a3
    80000ae2:	6318                	ld	a4,0(a4)
    80000ae4:	4685                	li	a3,1
    80000ae6:	06e6e963          	bltu	a3,a4,80000b58 <kfree+0xbe>
    80000aea:	e04a                	sd	s2,0(sp)
    ref_counter[page_num]--;
    release(&kmem.lock);
    return;
  }
  ref_counter[page_num] = 0; // insurance
    80000aec:	078e                	slli	a5,a5,0x3
    80000aee:	00014717          	auipc	a4,0x14
    80000af2:	10270713          	addi	a4,a4,258 # 80014bf0 <ref_counter>
    80000af6:	97ba                	add	a5,a5,a4
    80000af8:	0007b023          	sd	zero,0(a5)
  release(&kmem.lock);
    80000afc:	00014917          	auipc	s2,0x14
    80000b00:	0d490913          	addi	s2,s2,212 # 80014bd0 <kmem>
    80000b04:	854a                	mv	a0,s2
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	2be080e7          	jalr	702(ra) # 80000dc4 <release>

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000b0e:	6605                	lui	a2,0x1
    80000b10:	4585                	li	a1,1
    80000b12:	8526                	mv	a0,s1
    80000b14:	00000097          	auipc	ra,0x0
    80000b18:	2f8080e7          	jalr	760(ra) # 80000e0c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000b1c:	854a                	mv	a0,s2
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	1f2080e7          	jalr	498(ra) # 80000d10 <acquire>
  r->next = kmem.freelist;
    80000b26:	01893783          	ld	a5,24(s2)
    80000b2a:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000b2c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000b30:	854a                	mv	a0,s2
    80000b32:	00000097          	auipc	ra,0x0
    80000b36:	292080e7          	jalr	658(ra) # 80000dc4 <release>
    80000b3a:	6902                	ld	s2,0(sp)
}
    80000b3c:	60e2                	ld	ra,24(sp)
    80000b3e:	6442                	ld	s0,16(sp)
    80000b40:	64a2                	ld	s1,8(sp)
    80000b42:	6105                	addi	sp,sp,32
    80000b44:	8082                	ret
    80000b46:	e04a                	sd	s2,0(sp)
    panic("kfree");
    80000b48:	0000a517          	auipc	a0,0xa
    80000b4c:	50850513          	addi	a0,a0,1288 # 8000b050 <etext+0x50>
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	a10080e7          	jalr	-1520(ra) # 80000560 <panic>
    ref_counter[page_num]--;
    80000b58:	078e                	slli	a5,a5,0x3
    80000b5a:	00014697          	auipc	a3,0x14
    80000b5e:	09668693          	addi	a3,a3,150 # 80014bf0 <ref_counter>
    80000b62:	97b6                	add	a5,a5,a3
    80000b64:	177d                	addi	a4,a4,-1
    80000b66:	e398                	sd	a4,0(a5)
    release(&kmem.lock);
    80000b68:	00014517          	auipc	a0,0x14
    80000b6c:	06850513          	addi	a0,a0,104 # 80014bd0 <kmem>
    80000b70:	00000097          	auipc	ra,0x0
    80000b74:	254080e7          	jalr	596(ra) # 80000dc4 <release>
    return;
    80000b78:	b7d1                	j	80000b3c <kfree+0xa2>

0000000080000b7a <freerange>:
{
    80000b7a:	7179                	addi	sp,sp,-48
    80000b7c:	f406                	sd	ra,40(sp)
    80000b7e:	f022                	sd	s0,32(sp)
    80000b80:	ec26                	sd	s1,24(sp)
    80000b82:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b84:	6785                	lui	a5,0x1
    80000b86:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b8a:	00e504b3          	add	s1,a0,a4
    80000b8e:	777d                	lui	a4,0xfffff
    80000b90:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b92:	94be                	add	s1,s1,a5
    80000b94:	0295e463          	bltu	a1,s1,80000bbc <freerange+0x42>
    80000b98:	e84a                	sd	s2,16(sp)
    80000b9a:	e44e                	sd	s3,8(sp)
    80000b9c:	e052                	sd	s4,0(sp)
    80000b9e:	892e                	mv	s2,a1
    kfree(p);
    80000ba0:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ba2:	6985                	lui	s3,0x1
    kfree(p);
    80000ba4:	01448533          	add	a0,s1,s4
    80000ba8:	00000097          	auipc	ra,0x0
    80000bac:	ef2080e7          	jalr	-270(ra) # 80000a9a <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000bb0:	94ce                	add	s1,s1,s3
    80000bb2:	fe9979e3          	bgeu	s2,s1,80000ba4 <freerange+0x2a>
    80000bb6:	6942                	ld	s2,16(sp)
    80000bb8:	69a2                	ld	s3,8(sp)
    80000bba:	6a02                	ld	s4,0(sp)
}
    80000bbc:	70a2                	ld	ra,40(sp)
    80000bbe:	7402                	ld	s0,32(sp)
    80000bc0:	64e2                	ld	s1,24(sp)
    80000bc2:	6145                	addi	sp,sp,48
    80000bc4:	8082                	ret

0000000080000bc6 <kinit>:
{
    80000bc6:	1141                	addi	sp,sp,-16
    80000bc8:	e406                	sd	ra,8(sp)
    80000bca:	e022                	sd	s0,0(sp)
    80000bcc:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000bce:	0000a597          	auipc	a1,0xa
    80000bd2:	48a58593          	addi	a1,a1,1162 # 8000b058 <etext+0x58>
    80000bd6:	00014517          	auipc	a0,0x14
    80000bda:	ffa50513          	addi	a0,a0,-6 # 80014bd0 <kmem>
    80000bde:	00000097          	auipc	ra,0x0
    80000be2:	0a2080e7          	jalr	162(ra) # 80000c80 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000be6:	45c5                	li	a1,17
    80000be8:	05ee                	slli	a1,a1,0x1b
    80000bea:	00070517          	auipc	a0,0x70
    80000bee:	8ae50513          	addi	a0,a0,-1874 # 80070498 <end>
    80000bf2:	00000097          	auipc	ra,0x0
    80000bf6:	f88080e7          	jalr	-120(ra) # 80000b7a <freerange>
}
    80000bfa:	60a2                	ld	ra,8(sp)
    80000bfc:	6402                	ld	s0,0(sp)
    80000bfe:	0141                	addi	sp,sp,16
    80000c00:	8082                	ret

0000000080000c02 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000c02:	1101                	addi	sp,sp,-32
    80000c04:	ec06                	sd	ra,24(sp)
    80000c06:	e822                	sd	s0,16(sp)
    80000c08:	e426                	sd	s1,8(sp)
    80000c0a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000c0c:	00014497          	auipc	s1,0x14
    80000c10:	fc448493          	addi	s1,s1,-60 # 80014bd0 <kmem>
    80000c14:	8526                	mv	a0,s1
    80000c16:	00000097          	auipc	ra,0x0
    80000c1a:	0fa080e7          	jalr	250(ra) # 80000d10 <acquire>

  r = kmem.freelist;
    80000c1e:	6c84                	ld	s1,24(s1)
  if(r)
    80000c20:	c0b1                	beqz	s1,80000c64 <kalloc+0x62>
    kmem.freelist = r->next;
    80000c22:	609c                	ld	a5,0(s1)
    80000c24:	00014517          	auipc	a0,0x14
    80000c28:	fac50513          	addi	a0,a0,-84 # 80014bd0 <kmem>
    80000c2c:	ed1c                	sd	a5,24(a0)
  uint64 page_num = PGROUNDDOWN((uint64)r)/PGSIZE;
    80000c2e:	00c4d713          	srli	a4,s1,0xc
  ref_counter[page_num] = 1;
    80000c32:	070e                	slli	a4,a4,0x3
    80000c34:	00014797          	auipc	a5,0x14
    80000c38:	fbc78793          	addi	a5,a5,-68 # 80014bf0 <ref_counter>
    80000c3c:	97ba                	add	a5,a5,a4
    80000c3e:	4705                	li	a4,1
    80000c40:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000c42:	00000097          	auipc	ra,0x0
    80000c46:	182080e7          	jalr	386(ra) # 80000dc4 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000c4a:	6605                	lui	a2,0x1
    80000c4c:	4595                	li	a1,5
    80000c4e:	8526                	mv	a0,s1
    80000c50:	00000097          	auipc	ra,0x0
    80000c54:	1bc080e7          	jalr	444(ra) # 80000e0c <memset>
  return (void*)r;
}
    80000c58:	8526                	mv	a0,s1
    80000c5a:	60e2                	ld	ra,24(sp)
    80000c5c:	6442                	ld	s0,16(sp)
    80000c5e:	64a2                	ld	s1,8(sp)
    80000c60:	6105                	addi	sp,sp,32
    80000c62:	8082                	ret
  ref_counter[page_num] = 1;
    80000c64:	4785                	li	a5,1
    80000c66:	00014717          	auipc	a4,0x14
    80000c6a:	f8f73523          	sd	a5,-118(a4) # 80014bf0 <ref_counter>
  release(&kmem.lock);
    80000c6e:	00014517          	auipc	a0,0x14
    80000c72:	f6250513          	addi	a0,a0,-158 # 80014bd0 <kmem>
    80000c76:	00000097          	auipc	ra,0x0
    80000c7a:	14e080e7          	jalr	334(ra) # 80000dc4 <release>
  if(r)
    80000c7e:	bfe9                	j	80000c58 <kalloc+0x56>

0000000080000c80 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c80:	1141                	addi	sp,sp,-16
    80000c82:	e422                	sd	s0,8(sp)
    80000c84:	0800                	addi	s0,sp,16
  lk->name = name;
    80000c86:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c88:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c8c:	00053823          	sd	zero,16(a0)
}
    80000c90:	6422                	ld	s0,8(sp)
    80000c92:	0141                	addi	sp,sp,16
    80000c94:	8082                	ret

0000000080000c96 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c96:	411c                	lw	a5,0(a0)
    80000c98:	e399                	bnez	a5,80000c9e <holding+0x8>
    80000c9a:	4501                	li	a0,0
  return r;
}
    80000c9c:	8082                	ret
{
    80000c9e:	1101                	addi	sp,sp,-32
    80000ca0:	ec06                	sd	ra,24(sp)
    80000ca2:	e822                	sd	s0,16(sp)
    80000ca4:	e426                	sd	s1,8(sp)
    80000ca6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ca8:	6904                	ld	s1,16(a0)
    80000caa:	00001097          	auipc	ra,0x1
    80000cae:	14e080e7          	jalr	334(ra) # 80001df8 <mycpu>
    80000cb2:	40a48533          	sub	a0,s1,a0
    80000cb6:	00153513          	seqz	a0,a0
}
    80000cba:	60e2                	ld	ra,24(sp)
    80000cbc:	6442                	ld	s0,16(sp)
    80000cbe:	64a2                	ld	s1,8(sp)
    80000cc0:	6105                	addi	sp,sp,32
    80000cc2:	8082                	ret

0000000080000cc4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000cc4:	1101                	addi	sp,sp,-32
    80000cc6:	ec06                	sd	ra,24(sp)
    80000cc8:	e822                	sd	s0,16(sp)
    80000cca:	e426                	sd	s1,8(sp)
    80000ccc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cce:	100024f3          	csrr	s1,sstatus
    80000cd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000cd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cd8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000cdc:	00001097          	auipc	ra,0x1
    80000ce0:	11c080e7          	jalr	284(ra) # 80001df8 <mycpu>
    80000ce4:	5d3c                	lw	a5,120(a0)
    80000ce6:	cf89                	beqz	a5,80000d00 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000ce8:	00001097          	auipc	ra,0x1
    80000cec:	110080e7          	jalr	272(ra) # 80001df8 <mycpu>
    80000cf0:	5d3c                	lw	a5,120(a0)
    80000cf2:	2785                	addiw	a5,a5,1
    80000cf4:	dd3c                	sw	a5,120(a0)
}
    80000cf6:	60e2                	ld	ra,24(sp)
    80000cf8:	6442                	ld	s0,16(sp)
    80000cfa:	64a2                	ld	s1,8(sp)
    80000cfc:	6105                	addi	sp,sp,32
    80000cfe:	8082                	ret
    mycpu()->intena = old;
    80000d00:	00001097          	auipc	ra,0x1
    80000d04:	0f8080e7          	jalr	248(ra) # 80001df8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000d08:	8085                	srli	s1,s1,0x1
    80000d0a:	8885                	andi	s1,s1,1
    80000d0c:	dd64                	sw	s1,124(a0)
    80000d0e:	bfe9                	j	80000ce8 <push_off+0x24>

0000000080000d10 <acquire>:
{
    80000d10:	1101                	addi	sp,sp,-32
    80000d12:	ec06                	sd	ra,24(sp)
    80000d14:	e822                	sd	s0,16(sp)
    80000d16:	e426                	sd	s1,8(sp)
    80000d18:	1000                	addi	s0,sp,32
    80000d1a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d1c:	00000097          	auipc	ra,0x0
    80000d20:	fa8080e7          	jalr	-88(ra) # 80000cc4 <push_off>
  if(holding(lk))
    80000d24:	8526                	mv	a0,s1
    80000d26:	00000097          	auipc	ra,0x0
    80000d2a:	f70080e7          	jalr	-144(ra) # 80000c96 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d2e:	4705                	li	a4,1
  if(holding(lk))
    80000d30:	e115                	bnez	a0,80000d54 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d32:	87ba                	mv	a5,a4
    80000d34:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d38:	2781                	sext.w	a5,a5
    80000d3a:	ffe5                	bnez	a5,80000d32 <acquire+0x22>
  __sync_synchronize();
    80000d3c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000d40:	00001097          	auipc	ra,0x1
    80000d44:	0b8080e7          	jalr	184(ra) # 80001df8 <mycpu>
    80000d48:	e888                	sd	a0,16(s1)
}
    80000d4a:	60e2                	ld	ra,24(sp)
    80000d4c:	6442                	ld	s0,16(sp)
    80000d4e:	64a2                	ld	s1,8(sp)
    80000d50:	6105                	addi	sp,sp,32
    80000d52:	8082                	ret
    panic("acquire");
    80000d54:	0000a517          	auipc	a0,0xa
    80000d58:	30c50513          	addi	a0,a0,780 # 8000b060 <etext+0x60>
    80000d5c:	00000097          	auipc	ra,0x0
    80000d60:	804080e7          	jalr	-2044(ra) # 80000560 <panic>

0000000080000d64 <pop_off>:

void
pop_off(void)
{
    80000d64:	1141                	addi	sp,sp,-16
    80000d66:	e406                	sd	ra,8(sp)
    80000d68:	e022                	sd	s0,0(sp)
    80000d6a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d6c:	00001097          	auipc	ra,0x1
    80000d70:	08c080e7          	jalr	140(ra) # 80001df8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d74:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d78:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d7a:	e78d                	bnez	a5,80000da4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d7c:	5d3c                	lw	a5,120(a0)
    80000d7e:	02f05b63          	blez	a5,80000db4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000d82:	37fd                	addiw	a5,a5,-1
    80000d84:	0007871b          	sext.w	a4,a5
    80000d88:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d8a:	eb09                	bnez	a4,80000d9c <pop_off+0x38>
    80000d8c:	5d7c                	lw	a5,124(a0)
    80000d8e:	c799                	beqz	a5,80000d9c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000d94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d98:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000d9c:	60a2                	ld	ra,8(sp)
    80000d9e:	6402                	ld	s0,0(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret
    panic("pop_off - interruptible");
    80000da4:	0000a517          	auipc	a0,0xa
    80000da8:	2c450513          	addi	a0,a0,708 # 8000b068 <etext+0x68>
    80000dac:	fffff097          	auipc	ra,0xfffff
    80000db0:	7b4080e7          	jalr	1972(ra) # 80000560 <panic>
    panic("pop_off");
    80000db4:	0000a517          	auipc	a0,0xa
    80000db8:	2cc50513          	addi	a0,a0,716 # 8000b080 <etext+0x80>
    80000dbc:	fffff097          	auipc	ra,0xfffff
    80000dc0:	7a4080e7          	jalr	1956(ra) # 80000560 <panic>

0000000080000dc4 <release>:
{
    80000dc4:	1101                	addi	sp,sp,-32
    80000dc6:	ec06                	sd	ra,24(sp)
    80000dc8:	e822                	sd	s0,16(sp)
    80000dca:	e426                	sd	s1,8(sp)
    80000dcc:	1000                	addi	s0,sp,32
    80000dce:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000dd0:	00000097          	auipc	ra,0x0
    80000dd4:	ec6080e7          	jalr	-314(ra) # 80000c96 <holding>
    80000dd8:	c115                	beqz	a0,80000dfc <release+0x38>
  lk->cpu = 0;
    80000dda:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000dde:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000de2:	0f50000f          	fence	iorw,ow
    80000de6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000dea:	00000097          	auipc	ra,0x0
    80000dee:	f7a080e7          	jalr	-134(ra) # 80000d64 <pop_off>
}
    80000df2:	60e2                	ld	ra,24(sp)
    80000df4:	6442                	ld	s0,16(sp)
    80000df6:	64a2                	ld	s1,8(sp)
    80000df8:	6105                	addi	sp,sp,32
    80000dfa:	8082                	ret
    panic("release");
    80000dfc:	0000a517          	auipc	a0,0xa
    80000e00:	28c50513          	addi	a0,a0,652 # 8000b088 <etext+0x88>
    80000e04:	fffff097          	auipc	ra,0xfffff
    80000e08:	75c080e7          	jalr	1884(ra) # 80000560 <panic>

0000000080000e0c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000e0c:	1141                	addi	sp,sp,-16
    80000e0e:	e422                	sd	s0,8(sp)
    80000e10:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e12:	ca19                	beqz	a2,80000e28 <memset+0x1c>
    80000e14:	87aa                	mv	a5,a0
    80000e16:	1602                	slli	a2,a2,0x20
    80000e18:	9201                	srli	a2,a2,0x20
    80000e1a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e1e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e22:	0785                	addi	a5,a5,1
    80000e24:	fee79de3          	bne	a5,a4,80000e1e <memset+0x12>
  }
  return dst;
}
    80000e28:	6422                	ld	s0,8(sp)
    80000e2a:	0141                	addi	sp,sp,16
    80000e2c:	8082                	ret

0000000080000e2e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e2e:	1141                	addi	sp,sp,-16
    80000e30:	e422                	sd	s0,8(sp)
    80000e32:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e34:	ca05                	beqz	a2,80000e64 <memcmp+0x36>
    80000e36:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000e3a:	1682                	slli	a3,a3,0x20
    80000e3c:	9281                	srli	a3,a3,0x20
    80000e3e:	0685                	addi	a3,a3,1
    80000e40:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e42:	00054783          	lbu	a5,0(a0)
    80000e46:	0005c703          	lbu	a4,0(a1)
    80000e4a:	00e79863          	bne	a5,a4,80000e5a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e4e:	0505                	addi	a0,a0,1
    80000e50:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e52:	fed518e3          	bne	a0,a3,80000e42 <memcmp+0x14>
  }

  return 0;
    80000e56:	4501                	li	a0,0
    80000e58:	a019                	j	80000e5e <memcmp+0x30>
      return *s1 - *s2;
    80000e5a:	40e7853b          	subw	a0,a5,a4
}
    80000e5e:	6422                	ld	s0,8(sp)
    80000e60:	0141                	addi	sp,sp,16
    80000e62:	8082                	ret
  return 0;
    80000e64:	4501                	li	a0,0
    80000e66:	bfe5                	j	80000e5e <memcmp+0x30>

0000000080000e68 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e68:	1141                	addi	sp,sp,-16
    80000e6a:	e422                	sd	s0,8(sp)
    80000e6c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e6e:	c205                	beqz	a2,80000e8e <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e70:	02a5e263          	bltu	a1,a0,80000e94 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e74:	1602                	slli	a2,a2,0x20
    80000e76:	9201                	srli	a2,a2,0x20
    80000e78:	00c587b3          	add	a5,a1,a2
{
    80000e7c:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e7e:	0585                	addi	a1,a1,1
    80000e80:	0705                	addi	a4,a4,1
    80000e82:	fff5c683          	lbu	a3,-1(a1)
    80000e86:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e8a:	feb79ae3          	bne	a5,a1,80000e7e <memmove+0x16>

  return dst;
}
    80000e8e:	6422                	ld	s0,8(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret
  if(s < d && s + n > d){
    80000e94:	02061693          	slli	a3,a2,0x20
    80000e98:	9281                	srli	a3,a3,0x20
    80000e9a:	00d58733          	add	a4,a1,a3
    80000e9e:	fce57be3          	bgeu	a0,a4,80000e74 <memmove+0xc>
    d += n;
    80000ea2:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000ea4:	fff6079b          	addiw	a5,a2,-1
    80000ea8:	1782                	slli	a5,a5,0x20
    80000eaa:	9381                	srli	a5,a5,0x20
    80000eac:	fff7c793          	not	a5,a5
    80000eb0:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000eb2:	177d                	addi	a4,a4,-1
    80000eb4:	16fd                	addi	a3,a3,-1
    80000eb6:	00074603          	lbu	a2,0(a4)
    80000eba:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000ebe:	fef71ae3          	bne	a4,a5,80000eb2 <memmove+0x4a>
    80000ec2:	b7f1                	j	80000e8e <memmove+0x26>

0000000080000ec4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000ec4:	1141                	addi	sp,sp,-16
    80000ec6:	e406                	sd	ra,8(sp)
    80000ec8:	e022                	sd	s0,0(sp)
    80000eca:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000ecc:	00000097          	auipc	ra,0x0
    80000ed0:	f9c080e7          	jalr	-100(ra) # 80000e68 <memmove>
}
    80000ed4:	60a2                	ld	ra,8(sp)
    80000ed6:	6402                	ld	s0,0(sp)
    80000ed8:	0141                	addi	sp,sp,16
    80000eda:	8082                	ret

0000000080000edc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000edc:	1141                	addi	sp,sp,-16
    80000ede:	e422                	sd	s0,8(sp)
    80000ee0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000ee2:	ce11                	beqz	a2,80000efe <strncmp+0x22>
    80000ee4:	00054783          	lbu	a5,0(a0)
    80000ee8:	cf89                	beqz	a5,80000f02 <strncmp+0x26>
    80000eea:	0005c703          	lbu	a4,0(a1)
    80000eee:	00f71a63          	bne	a4,a5,80000f02 <strncmp+0x26>
    n--, p++, q++;
    80000ef2:	367d                	addiw	a2,a2,-1
    80000ef4:	0505                	addi	a0,a0,1
    80000ef6:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000ef8:	f675                	bnez	a2,80000ee4 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000efa:	4501                	li	a0,0
    80000efc:	a801                	j	80000f0c <strncmp+0x30>
    80000efe:	4501                	li	a0,0
    80000f00:	a031                	j	80000f0c <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000f02:	00054503          	lbu	a0,0(a0)
    80000f06:	0005c783          	lbu	a5,0(a1)
    80000f0a:	9d1d                	subw	a0,a0,a5
}
    80000f0c:	6422                	ld	s0,8(sp)
    80000f0e:	0141                	addi	sp,sp,16
    80000f10:	8082                	ret

0000000080000f12 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f12:	1141                	addi	sp,sp,-16
    80000f14:	e422                	sd	s0,8(sp)
    80000f16:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f18:	87aa                	mv	a5,a0
    80000f1a:	86b2                	mv	a3,a2
    80000f1c:	367d                	addiw	a2,a2,-1
    80000f1e:	02d05563          	blez	a3,80000f48 <strncpy+0x36>
    80000f22:	0785                	addi	a5,a5,1
    80000f24:	0005c703          	lbu	a4,0(a1)
    80000f28:	fee78fa3          	sb	a4,-1(a5)
    80000f2c:	0585                	addi	a1,a1,1
    80000f2e:	f775                	bnez	a4,80000f1a <strncpy+0x8>
    ;
  while(n-- > 0)
    80000f30:	873e                	mv	a4,a5
    80000f32:	9fb5                	addw	a5,a5,a3
    80000f34:	37fd                	addiw	a5,a5,-1
    80000f36:	00c05963          	blez	a2,80000f48 <strncpy+0x36>
    *s++ = 0;
    80000f3a:	0705                	addi	a4,a4,1
    80000f3c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000f40:	40e786bb          	subw	a3,a5,a4
    80000f44:	fed04be3          	bgtz	a3,80000f3a <strncpy+0x28>
  return os;
}
    80000f48:	6422                	ld	s0,8(sp)
    80000f4a:	0141                	addi	sp,sp,16
    80000f4c:	8082                	ret

0000000080000f4e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f4e:	1141                	addi	sp,sp,-16
    80000f50:	e422                	sd	s0,8(sp)
    80000f52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f54:	02c05363          	blez	a2,80000f7a <safestrcpy+0x2c>
    80000f58:	fff6069b          	addiw	a3,a2,-1
    80000f5c:	1682                	slli	a3,a3,0x20
    80000f5e:	9281                	srli	a3,a3,0x20
    80000f60:	96ae                	add	a3,a3,a1
    80000f62:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f64:	00d58963          	beq	a1,a3,80000f76 <safestrcpy+0x28>
    80000f68:	0585                	addi	a1,a1,1
    80000f6a:	0785                	addi	a5,a5,1
    80000f6c:	fff5c703          	lbu	a4,-1(a1)
    80000f70:	fee78fa3          	sb	a4,-1(a5)
    80000f74:	fb65                	bnez	a4,80000f64 <safestrcpy+0x16>
    ;
  *s = 0;
    80000f76:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f7a:	6422                	ld	s0,8(sp)
    80000f7c:	0141                	addi	sp,sp,16
    80000f7e:	8082                	ret

0000000080000f80 <strlen>:

int
strlen(const char *s)
{
    80000f80:	1141                	addi	sp,sp,-16
    80000f82:	e422                	sd	s0,8(sp)
    80000f84:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f86:	00054783          	lbu	a5,0(a0)
    80000f8a:	cf91                	beqz	a5,80000fa6 <strlen+0x26>
    80000f8c:	0505                	addi	a0,a0,1
    80000f8e:	87aa                	mv	a5,a0
    80000f90:	86be                	mv	a3,a5
    80000f92:	0785                	addi	a5,a5,1
    80000f94:	fff7c703          	lbu	a4,-1(a5)
    80000f98:	ff65                	bnez	a4,80000f90 <strlen+0x10>
    80000f9a:	40a6853b          	subw	a0,a3,a0
    80000f9e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000fa0:	6422                	ld	s0,8(sp)
    80000fa2:	0141                	addi	sp,sp,16
    80000fa4:	8082                	ret
  for(n = 0; s[n]; n++)
    80000fa6:	4501                	li	a0,0
    80000fa8:	bfe5                	j	80000fa0 <strlen+0x20>

0000000080000faa <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000faa:	1141                	addi	sp,sp,-16
    80000fac:	e406                	sd	ra,8(sp)
    80000fae:	e022                	sd	s0,0(sp)
    80000fb0:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000fb2:	00001097          	auipc	ra,0x1
    80000fb6:	e36080e7          	jalr	-458(ra) # 80001de8 <cpuid>
    userinit();      // first user process
    net_init();
    socket_init();
    started = 1;
  } else {
    while(started == 0)
    80000fba:	0000c717          	auipc	a4,0xc
    80000fbe:	98e70713          	addi	a4,a4,-1650 # 8000c948 <started>
  if(cpuid() == 0){
    80000fc2:	c139                	beqz	a0,80001008 <main+0x5e>
    while(started == 0)
    80000fc4:	431c                	lw	a5,0(a4)
    80000fc6:	2781                	sext.w	a5,a5
    80000fc8:	dff5                	beqz	a5,80000fc4 <main+0x1a>
      ;
    __sync_synchronize();
    80000fca:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000fce:	00001097          	auipc	ra,0x1
    80000fd2:	e1a080e7          	jalr	-486(ra) # 80001de8 <cpuid>
    80000fd6:	85aa                	mv	a1,a0
    80000fd8:	0000a517          	auipc	a0,0xa
    80000fdc:	0d050513          	addi	a0,a0,208 # 8000b0a8 <etext+0xa8>
    80000fe0:	fffff097          	auipc	ra,0xfffff
    80000fe4:	5ca080e7          	jalr	1482(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    80000fe8:	00000097          	auipc	ra,0x0
    80000fec:	0f0080e7          	jalr	240(ra) # 800010d8 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ff0:	00002097          	auipc	ra,0x2
    80000ff4:	fac080e7          	jalr	-84(ra) # 80002f9c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ff8:	00006097          	auipc	ra,0x6
    80000ffc:	c22080e7          	jalr	-990(ra) # 80006c1a <plicinithart>
  }

  scheduler();        
    80001000:	00001097          	auipc	ra,0x1
    80001004:	510080e7          	jalr	1296(ra) # 80002510 <scheduler>
    consoleinit();
    80001008:	fffff097          	auipc	ra,0xfffff
    8000100c:	468080e7          	jalr	1128(ra) # 80000470 <consoleinit>
    printfinit();
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	7a2080e7          	jalr	1954(ra) # 800007b2 <printfinit>
    printf("\n");
    80001018:	0000a517          	auipc	a0,0xa
    8000101c:	00850513          	addi	a0,a0,8 # 8000b020 <etext+0x20>
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	58a080e7          	jalr	1418(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80001028:	0000a517          	auipc	a0,0xa
    8000102c:	06850513          	addi	a0,a0,104 # 8000b090 <etext+0x90>
    80001030:	fffff097          	auipc	ra,0xfffff
    80001034:	57a080e7          	jalr	1402(ra) # 800005aa <printf>
    printf("\n");
    80001038:	0000a517          	auipc	a0,0xa
    8000103c:	fe850513          	addi	a0,a0,-24 # 8000b020 <etext+0x20>
    80001040:	fffff097          	auipc	ra,0xfffff
    80001044:	56a080e7          	jalr	1386(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80001048:	00000097          	auipc	ra,0x0
    8000104c:	b7e080e7          	jalr	-1154(ra) # 80000bc6 <kinit>
    kvminit();       // create kernel page table
    80001050:	00000097          	auipc	ra,0x0
    80001054:	354080e7          	jalr	852(ra) # 800013a4 <kvminit>
    kvminithart();   // turn on paging
    80001058:	00000097          	auipc	ra,0x0
    8000105c:	080080e7          	jalr	128(ra) # 800010d8 <kvminithart>
    procinit();      // process table
    80001060:	00001097          	auipc	ra,0x1
    80001064:	cc6080e7          	jalr	-826(ra) # 80001d26 <procinit>
    trapinit();      // trap vectors
    80001068:	00002097          	auipc	ra,0x2
    8000106c:	f0c080e7          	jalr	-244(ra) # 80002f74 <trapinit>
    trapinithart();  // install kernel trap vector
    80001070:	00002097          	auipc	ra,0x2
    80001074:	f2c080e7          	jalr	-212(ra) # 80002f9c <trapinithart>
    plicinit();      // set up interrupt controller
    80001078:	00006097          	auipc	ra,0x6
    8000107c:	b82080e7          	jalr	-1150(ra) # 80006bfa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001080:	00006097          	auipc	ra,0x6
    80001084:	b9a080e7          	jalr	-1126(ra) # 80006c1a <plicinithart>
    binit();         // buffer cache
    80001088:	00003097          	auipc	ra,0x3
    8000108c:	c12080e7          	jalr	-1006(ra) # 80003c9a <binit>
    iinit();         // inode table
    80001090:	00003097          	auipc	ra,0x3
    80001094:	2c8080e7          	jalr	712(ra) # 80004358 <iinit>
    fileinit();      // file table
    80001098:	00004097          	auipc	ra,0x4
    8000109c:	278080e7          	jalr	632(ra) # 80005310 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010a0:	00006097          	auipc	ra,0x6
    800010a4:	c82080e7          	jalr	-894(ra) # 80006d22 <virtio_disk_init>
    virtio_net_init(); // emulated NIC driver 
    800010a8:	00006097          	auipc	ra,0x6
    800010ac:	21e080e7          	jalr	542(ra) # 800072c6 <virtio_net_init>
    __sync_synchronize();
    800010b0:	0ff0000f          	fence
    userinit();      // first user process
    800010b4:	00001097          	auipc	ra,0x1
    800010b8:	04a080e7          	jalr	74(ra) # 800020fe <userinit>
    net_init();
    800010bc:	00007097          	auipc	ra,0x7
    800010c0:	fc2080e7          	jalr	-62(ra) # 8000807e <net_init>
    socket_init();
    800010c4:	00008097          	auipc	ra,0x8
    800010c8:	892080e7          	jalr	-1902(ra) # 80008956 <socket_init>
    started = 1;
    800010cc:	4785                	li	a5,1
    800010ce:	0000c717          	auipc	a4,0xc
    800010d2:	86f72d23          	sw	a5,-1926(a4) # 8000c948 <started>
    800010d6:	b72d                	j	80001000 <main+0x56>

00000000800010d8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800010d8:	1141                	addi	sp,sp,-16
    800010da:	e422                	sd	s0,8(sp)
    800010dc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800010de:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800010e2:	0000c797          	auipc	a5,0xc
    800010e6:	86e7b783          	ld	a5,-1938(a5) # 8000c950 <kernel_pagetable>
    800010ea:	83b1                	srli	a5,a5,0xc
    800010ec:	577d                	li	a4,-1
    800010ee:	177e                	slli	a4,a4,0x3f
    800010f0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800010f2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800010f6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800010fa:	6422                	ld	s0,8(sp)
    800010fc:	0141                	addi	sp,sp,16
    800010fe:	8082                	ret

0000000080001100 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001100:	7139                	addi	sp,sp,-64
    80001102:	fc06                	sd	ra,56(sp)
    80001104:	f822                	sd	s0,48(sp)
    80001106:	f426                	sd	s1,40(sp)
    80001108:	f04a                	sd	s2,32(sp)
    8000110a:	ec4e                	sd	s3,24(sp)
    8000110c:	e852                	sd	s4,16(sp)
    8000110e:	e456                	sd	s5,8(sp)
    80001110:	e05a                	sd	s6,0(sp)
    80001112:	0080                	addi	s0,sp,64
    80001114:	84aa                	mv	s1,a0
    80001116:	89ae                	mv	s3,a1
    80001118:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000111a:	57fd                	li	a5,-1
    8000111c:	83e9                	srli	a5,a5,0x1a
    8000111e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001120:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001122:	04b7f263          	bgeu	a5,a1,80001166 <walk+0x66>
    panic("walk");
    80001126:	0000a517          	auipc	a0,0xa
    8000112a:	f9a50513          	addi	a0,a0,-102 # 8000b0c0 <etext+0xc0>
    8000112e:	fffff097          	auipc	ra,0xfffff
    80001132:	432080e7          	jalr	1074(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001136:	060a8663          	beqz	s5,800011a2 <walk+0xa2>
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	ac8080e7          	jalr	-1336(ra) # 80000c02 <kalloc>
    80001142:	84aa                	mv	s1,a0
    80001144:	c529                	beqz	a0,8000118e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001146:	6605                	lui	a2,0x1
    80001148:	4581                	li	a1,0
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	cc2080e7          	jalr	-830(ra) # 80000e0c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001152:	00c4d793          	srli	a5,s1,0xc
    80001156:	07aa                	slli	a5,a5,0xa
    80001158:	0017e793          	ori	a5,a5,1
    8000115c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001160:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ff8eb5f>
    80001162:	036a0063          	beq	s4,s6,80001182 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001166:	0149d933          	srl	s2,s3,s4
    8000116a:	1ff97913          	andi	s2,s2,511
    8000116e:	090e                	slli	s2,s2,0x3
    80001170:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001172:	00093483          	ld	s1,0(s2)
    80001176:	0014f793          	andi	a5,s1,1
    8000117a:	dfd5                	beqz	a5,80001136 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000117c:	80a9                	srli	s1,s1,0xa
    8000117e:	04b2                	slli	s1,s1,0xc
    80001180:	b7c5                	j	80001160 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001182:	00c9d513          	srli	a0,s3,0xc
    80001186:	1ff57513          	andi	a0,a0,511
    8000118a:	050e                	slli	a0,a0,0x3
    8000118c:	9526                	add	a0,a0,s1
}
    8000118e:	70e2                	ld	ra,56(sp)
    80001190:	7442                	ld	s0,48(sp)
    80001192:	74a2                	ld	s1,40(sp)
    80001194:	7902                	ld	s2,32(sp)
    80001196:	69e2                	ld	s3,24(sp)
    80001198:	6a42                	ld	s4,16(sp)
    8000119a:	6aa2                	ld	s5,8(sp)
    8000119c:	6b02                	ld	s6,0(sp)
    8000119e:	6121                	addi	sp,sp,64
    800011a0:	8082                	ret
        return 0;
    800011a2:	4501                	li	a0,0
    800011a4:	b7ed                	j	8000118e <walk+0x8e>

00000000800011a6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800011a6:	57fd                	li	a5,-1
    800011a8:	83e9                	srli	a5,a5,0x1a
    800011aa:	00b7f463          	bgeu	a5,a1,800011b2 <walkaddr+0xc>
    return 0;
    800011ae:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800011b0:	8082                	ret
{
    800011b2:	1141                	addi	sp,sp,-16
    800011b4:	e406                	sd	ra,8(sp)
    800011b6:	e022                	sd	s0,0(sp)
    800011b8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800011ba:	4601                	li	a2,0
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	f44080e7          	jalr	-188(ra) # 80001100 <walk>
  if(pte == 0)
    800011c4:	c105                	beqz	a0,800011e4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800011c6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800011c8:	0117f693          	andi	a3,a5,17
    800011cc:	4745                	li	a4,17
    return 0;
    800011ce:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800011d0:	00e68663          	beq	a3,a4,800011dc <walkaddr+0x36>
}
    800011d4:	60a2                	ld	ra,8(sp)
    800011d6:	6402                	ld	s0,0(sp)
    800011d8:	0141                	addi	sp,sp,16
    800011da:	8082                	ret
  pa = PTE2PA(*pte);
    800011dc:	83a9                	srli	a5,a5,0xa
    800011de:	00c79513          	slli	a0,a5,0xc
  return pa;
    800011e2:	bfcd                	j	800011d4 <walkaddr+0x2e>
    return 0;
    800011e4:	4501                	li	a0,0
    800011e6:	b7fd                	j	800011d4 <walkaddr+0x2e>

00000000800011e8 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800011e8:	715d                	addi	sp,sp,-80
    800011ea:	e486                	sd	ra,72(sp)
    800011ec:	e0a2                	sd	s0,64(sp)
    800011ee:	fc26                	sd	s1,56(sp)
    800011f0:	f84a                	sd	s2,48(sp)
    800011f2:	f44e                	sd	s3,40(sp)
    800011f4:	f052                	sd	s4,32(sp)
    800011f6:	ec56                	sd	s5,24(sp)
    800011f8:	e85a                	sd	s6,16(sp)
    800011fa:	e45e                	sd	s7,8(sp)
    800011fc:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800011fe:	c639                	beqz	a2,8000124c <mappages+0x64>
    80001200:	8aaa                	mv	s5,a0
    80001202:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001204:	777d                	lui	a4,0xfffff
    80001206:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000120a:	fff58993          	addi	s3,a1,-1
    8000120e:	99b2                	add	s3,s3,a2
    80001210:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001214:	893e                	mv	s2,a5
    80001216:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000121a:	6b85                	lui	s7,0x1
    8000121c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001220:	4605                	li	a2,1
    80001222:	85ca                	mv	a1,s2
    80001224:	8556                	mv	a0,s5
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	eda080e7          	jalr	-294(ra) # 80001100 <walk>
    8000122e:	cd1d                	beqz	a0,8000126c <mappages+0x84>
    if(*pte & PTE_V)
    80001230:	611c                	ld	a5,0(a0)
    80001232:	8b85                	andi	a5,a5,1
    80001234:	e785                	bnez	a5,8000125c <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001236:	80b1                	srli	s1,s1,0xc
    80001238:	04aa                	slli	s1,s1,0xa
    8000123a:	0164e4b3          	or	s1,s1,s6
    8000123e:	0014e493          	ori	s1,s1,1
    80001242:	e104                	sd	s1,0(a0)
    if(a == last)
    80001244:	05390063          	beq	s2,s3,80001284 <mappages+0x9c>
    a += PGSIZE;
    80001248:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000124a:	bfc9                	j	8000121c <mappages+0x34>
    panic("mappages: size");
    8000124c:	0000a517          	auipc	a0,0xa
    80001250:	e7c50513          	addi	a0,a0,-388 # 8000b0c8 <etext+0xc8>
    80001254:	fffff097          	auipc	ra,0xfffff
    80001258:	30c080e7          	jalr	780(ra) # 80000560 <panic>
      panic("mappages: remap");
    8000125c:	0000a517          	auipc	a0,0xa
    80001260:	e7c50513          	addi	a0,a0,-388 # 8000b0d8 <etext+0xd8>
    80001264:	fffff097          	auipc	ra,0xfffff
    80001268:	2fc080e7          	jalr	764(ra) # 80000560 <panic>
      return -1;
    8000126c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000126e:	60a6                	ld	ra,72(sp)
    80001270:	6406                	ld	s0,64(sp)
    80001272:	74e2                	ld	s1,56(sp)
    80001274:	7942                	ld	s2,48(sp)
    80001276:	79a2                	ld	s3,40(sp)
    80001278:	7a02                	ld	s4,32(sp)
    8000127a:	6ae2                	ld	s5,24(sp)
    8000127c:	6b42                	ld	s6,16(sp)
    8000127e:	6ba2                	ld	s7,8(sp)
    80001280:	6161                	addi	sp,sp,80
    80001282:	8082                	ret
  return 0;
    80001284:	4501                	li	a0,0
    80001286:	b7e5                	j	8000126e <mappages+0x86>

0000000080001288 <kvmmap>:
{
    80001288:	1141                	addi	sp,sp,-16
    8000128a:	e406                	sd	ra,8(sp)
    8000128c:	e022                	sd	s0,0(sp)
    8000128e:	0800                	addi	s0,sp,16
    80001290:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001292:	86b2                	mv	a3,a2
    80001294:	863e                	mv	a2,a5
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	f52080e7          	jalr	-174(ra) # 800011e8 <mappages>
    8000129e:	e509                	bnez	a0,800012a8 <kvmmap+0x20>
}
    800012a0:	60a2                	ld	ra,8(sp)
    800012a2:	6402                	ld	s0,0(sp)
    800012a4:	0141                	addi	sp,sp,16
    800012a6:	8082                	ret
    panic("kvmmap");
    800012a8:	0000a517          	auipc	a0,0xa
    800012ac:	e4050513          	addi	a0,a0,-448 # 8000b0e8 <etext+0xe8>
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	2b0080e7          	jalr	688(ra) # 80000560 <panic>

00000000800012b8 <kvmmake>:
{
    800012b8:	1101                	addi	sp,sp,-32
    800012ba:	ec06                	sd	ra,24(sp)
    800012bc:	e822                	sd	s0,16(sp)
    800012be:	e426                	sd	s1,8(sp)
    800012c0:	e04a                	sd	s2,0(sp)
    800012c2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	93e080e7          	jalr	-1730(ra) # 80000c02 <kalloc>
    800012cc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800012ce:	6605                	lui	a2,0x1
    800012d0:	4581                	li	a1,0
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	b3a080e7          	jalr	-1222(ra) # 80000e0c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012da:	4719                	li	a4,6
    800012dc:	6685                	lui	a3,0x1
    800012de:	10000637          	lui	a2,0x10000
    800012e2:	100005b7          	lui	a1,0x10000
    800012e6:	8526                	mv	a0,s1
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	fa0080e7          	jalr	-96(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012f0:	4719                	li	a4,6
    800012f2:	6685                	lui	a3,0x1
    800012f4:	10001637          	lui	a2,0x10001
    800012f8:	100015b7          	lui	a1,0x10001
    800012fc:	8526                	mv	a0,s1
    800012fe:	00000097          	auipc	ra,0x0
    80001302:	f8a080e7          	jalr	-118(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, VIRTIO1, VIRTIO1, PGSIZE, PTE_R | PTE_W);
    80001306:	4719                	li	a4,6
    80001308:	6685                	lui	a3,0x1
    8000130a:	10002637          	lui	a2,0x10002
    8000130e:	100025b7          	lui	a1,0x10002
    80001312:	8526                	mv	a0,s1
    80001314:	00000097          	auipc	ra,0x0
    80001318:	f74080e7          	jalr	-140(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000131c:	4719                	li	a4,6
    8000131e:	004006b7          	lui	a3,0x400
    80001322:	0c000637          	lui	a2,0xc000
    80001326:	0c0005b7          	lui	a1,0xc000
    8000132a:	8526                	mv	a0,s1
    8000132c:	00000097          	auipc	ra,0x0
    80001330:	f5c080e7          	jalr	-164(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001334:	0000a917          	auipc	s2,0xa
    80001338:	ccc90913          	addi	s2,s2,-820 # 8000b000 <etext>
    8000133c:	4729                	li	a4,10
    8000133e:	8000a697          	auipc	a3,0x8000a
    80001342:	cc268693          	addi	a3,a3,-830 # b000 <_entry-0x7fff5000>
    80001346:	4605                	li	a2,1
    80001348:	067e                	slli	a2,a2,0x1f
    8000134a:	85b2                	mv	a1,a2
    8000134c:	8526                	mv	a0,s1
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	f3a080e7          	jalr	-198(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001356:	46c5                	li	a3,17
    80001358:	06ee                	slli	a3,a3,0x1b
    8000135a:	4719                	li	a4,6
    8000135c:	412686b3          	sub	a3,a3,s2
    80001360:	864a                	mv	a2,s2
    80001362:	85ca                	mv	a1,s2
    80001364:	8526                	mv	a0,s1
    80001366:	00000097          	auipc	ra,0x0
    8000136a:	f22080e7          	jalr	-222(ra) # 80001288 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000136e:	4729                	li	a4,10
    80001370:	6685                	lui	a3,0x1
    80001372:	00009617          	auipc	a2,0x9
    80001376:	c8e60613          	addi	a2,a2,-882 # 8000a000 <_trampoline>
    8000137a:	040005b7          	lui	a1,0x4000
    8000137e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001380:	05b2                	slli	a1,a1,0xc
    80001382:	8526                	mv	a0,s1
    80001384:	00000097          	auipc	ra,0x0
    80001388:	f04080e7          	jalr	-252(ra) # 80001288 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000138c:	8526                	mv	a0,s1
    8000138e:	00001097          	auipc	ra,0x1
    80001392:	8f4080e7          	jalr	-1804(ra) # 80001c82 <proc_mapstacks>
}
    80001396:	8526                	mv	a0,s1
    80001398:	60e2                	ld	ra,24(sp)
    8000139a:	6442                	ld	s0,16(sp)
    8000139c:	64a2                	ld	s1,8(sp)
    8000139e:	6902                	ld	s2,0(sp)
    800013a0:	6105                	addi	sp,sp,32
    800013a2:	8082                	ret

00000000800013a4 <kvminit>:
{
    800013a4:	1141                	addi	sp,sp,-16
    800013a6:	e406                	sd	ra,8(sp)
    800013a8:	e022                	sd	s0,0(sp)
    800013aa:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	f0c080e7          	jalr	-244(ra) # 800012b8 <kvmmake>
    800013b4:	0000b797          	auipc	a5,0xb
    800013b8:	58a7be23          	sd	a0,1436(a5) # 8000c950 <kernel_pagetable>
}
    800013bc:	60a2                	ld	ra,8(sp)
    800013be:	6402                	ld	s0,0(sp)
    800013c0:	0141                	addi	sp,sp,16
    800013c2:	8082                	ret

00000000800013c4 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800013c4:	715d                	addi	sp,sp,-80
    800013c6:	e486                	sd	ra,72(sp)
    800013c8:	e0a2                	sd	s0,64(sp)
    800013ca:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800013cc:	03459793          	slli	a5,a1,0x34
    800013d0:	e39d                	bnez	a5,800013f6 <uvmunmap+0x32>
    800013d2:	f84a                	sd	s2,48(sp)
    800013d4:	f44e                	sd	s3,40(sp)
    800013d6:	f052                	sd	s4,32(sp)
    800013d8:	ec56                	sd	s5,24(sp)
    800013da:	e85a                	sd	s6,16(sp)
    800013dc:	e45e                	sd	s7,8(sp)
    800013de:	8a2a                	mv	s4,a0
    800013e0:	892e                	mv	s2,a1
    800013e2:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013e4:	0632                	slli	a2,a2,0xc
    800013e6:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800013ea:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013ec:	6b05                	lui	s6,0x1
    800013ee:	0935fb63          	bgeu	a1,s3,80001484 <uvmunmap+0xc0>
    800013f2:	fc26                	sd	s1,56(sp)
    800013f4:	a8a9                	j	8000144e <uvmunmap+0x8a>
    800013f6:	fc26                	sd	s1,56(sp)
    800013f8:	f84a                	sd	s2,48(sp)
    800013fa:	f44e                	sd	s3,40(sp)
    800013fc:	f052                	sd	s4,32(sp)
    800013fe:	ec56                	sd	s5,24(sp)
    80001400:	e85a                	sd	s6,16(sp)
    80001402:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001404:	0000a517          	auipc	a0,0xa
    80001408:	cec50513          	addi	a0,a0,-788 # 8000b0f0 <etext+0xf0>
    8000140c:	fffff097          	auipc	ra,0xfffff
    80001410:	154080e7          	jalr	340(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    80001414:	0000a517          	auipc	a0,0xa
    80001418:	cf450513          	addi	a0,a0,-780 # 8000b108 <etext+0x108>
    8000141c:	fffff097          	auipc	ra,0xfffff
    80001420:	144080e7          	jalr	324(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    80001424:	0000a517          	auipc	a0,0xa
    80001428:	cf450513          	addi	a0,a0,-780 # 8000b118 <etext+0x118>
    8000142c:	fffff097          	auipc	ra,0xfffff
    80001430:	134080e7          	jalr	308(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    80001434:	0000a517          	auipc	a0,0xa
    80001438:	cfc50513          	addi	a0,a0,-772 # 8000b130 <etext+0x130>
    8000143c:	fffff097          	auipc	ra,0xfffff
    80001440:	124080e7          	jalr	292(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001444:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001448:	995a                	add	s2,s2,s6
    8000144a:	03397c63          	bgeu	s2,s3,80001482 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000144e:	4601                	li	a2,0
    80001450:	85ca                	mv	a1,s2
    80001452:	8552                	mv	a0,s4
    80001454:	00000097          	auipc	ra,0x0
    80001458:	cac080e7          	jalr	-852(ra) # 80001100 <walk>
    8000145c:	84aa                	mv	s1,a0
    8000145e:	d95d                	beqz	a0,80001414 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001460:	6108                	ld	a0,0(a0)
    80001462:	00157793          	andi	a5,a0,1
    80001466:	dfdd                	beqz	a5,80001424 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001468:	3ff57793          	andi	a5,a0,1023
    8000146c:	fd7784e3          	beq	a5,s7,80001434 <uvmunmap+0x70>
    if(do_free){
    80001470:	fc0a8ae3          	beqz	s5,80001444 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80001474:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001476:	0532                	slli	a0,a0,0xc
    80001478:	fffff097          	auipc	ra,0xfffff
    8000147c:	622080e7          	jalr	1570(ra) # 80000a9a <kfree>
    80001480:	b7d1                	j	80001444 <uvmunmap+0x80>
    80001482:	74e2                	ld	s1,56(sp)
    80001484:	7942                	ld	s2,48(sp)
    80001486:	79a2                	ld	s3,40(sp)
    80001488:	7a02                	ld	s4,32(sp)
    8000148a:	6ae2                	ld	s5,24(sp)
    8000148c:	6b42                	ld	s6,16(sp)
    8000148e:	6ba2                	ld	s7,8(sp)
  }
}
    80001490:	60a6                	ld	ra,72(sp)
    80001492:	6406                	ld	s0,64(sp)
    80001494:	6161                	addi	sp,sp,80
    80001496:	8082                	ret

0000000080001498 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001498:	1101                	addi	sp,sp,-32
    8000149a:	ec06                	sd	ra,24(sp)
    8000149c:	e822                	sd	s0,16(sp)
    8000149e:	e426                	sd	s1,8(sp)
    800014a0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800014a2:	fffff097          	auipc	ra,0xfffff
    800014a6:	760080e7          	jalr	1888(ra) # 80000c02 <kalloc>
    800014aa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800014ac:	c519                	beqz	a0,800014ba <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800014ae:	6605                	lui	a2,0x1
    800014b0:	4581                	li	a1,0
    800014b2:	00000097          	auipc	ra,0x0
    800014b6:	95a080e7          	jalr	-1702(ra) # 80000e0c <memset>
  return pagetable;
}
    800014ba:	8526                	mv	a0,s1
    800014bc:	60e2                	ld	ra,24(sp)
    800014be:	6442                	ld	s0,16(sp)
    800014c0:	64a2                	ld	s1,8(sp)
    800014c2:	6105                	addi	sp,sp,32
    800014c4:	8082                	ret

00000000800014c6 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800014c6:	7179                	addi	sp,sp,-48
    800014c8:	f406                	sd	ra,40(sp)
    800014ca:	f022                	sd	s0,32(sp)
    800014cc:	ec26                	sd	s1,24(sp)
    800014ce:	e84a                	sd	s2,16(sp)
    800014d0:	e44e                	sd	s3,8(sp)
    800014d2:	e052                	sd	s4,0(sp)
    800014d4:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800014d6:	6785                	lui	a5,0x1
    800014d8:	04f67863          	bgeu	a2,a5,80001528 <uvmfirst+0x62>
    800014dc:	8a2a                	mv	s4,a0
    800014de:	89ae                	mv	s3,a1
    800014e0:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800014e2:	fffff097          	auipc	ra,0xfffff
    800014e6:	720080e7          	jalr	1824(ra) # 80000c02 <kalloc>
    800014ea:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800014ec:	6605                	lui	a2,0x1
    800014ee:	4581                	li	a1,0
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	91c080e7          	jalr	-1764(ra) # 80000e0c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800014f8:	4779                	li	a4,30
    800014fa:	86ca                	mv	a3,s2
    800014fc:	6605                	lui	a2,0x1
    800014fe:	4581                	li	a1,0
    80001500:	8552                	mv	a0,s4
    80001502:	00000097          	auipc	ra,0x0
    80001506:	ce6080e7          	jalr	-794(ra) # 800011e8 <mappages>
  memmove(mem, src, sz);
    8000150a:	8626                	mv	a2,s1
    8000150c:	85ce                	mv	a1,s3
    8000150e:	854a                	mv	a0,s2
    80001510:	00000097          	auipc	ra,0x0
    80001514:	958080e7          	jalr	-1704(ra) # 80000e68 <memmove>
}
    80001518:	70a2                	ld	ra,40(sp)
    8000151a:	7402                	ld	s0,32(sp)
    8000151c:	64e2                	ld	s1,24(sp)
    8000151e:	6942                	ld	s2,16(sp)
    80001520:	69a2                	ld	s3,8(sp)
    80001522:	6a02                	ld	s4,0(sp)
    80001524:	6145                	addi	sp,sp,48
    80001526:	8082                	ret
    panic("uvmfirst: more than a page");
    80001528:	0000a517          	auipc	a0,0xa
    8000152c:	c2050513          	addi	a0,a0,-992 # 8000b148 <etext+0x148>
    80001530:	fffff097          	auipc	ra,0xfffff
    80001534:	030080e7          	jalr	48(ra) # 80000560 <panic>

0000000080001538 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
  uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001538:	1101                	addi	sp,sp,-32
    8000153a:	ec06                	sd	ra,24(sp)
    8000153c:	e822                	sd	s0,16(sp)
    8000153e:	e426                	sd	s1,8(sp)
    80001540:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001542:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001544:	00b67d63          	bgeu	a2,a1,8000155e <uvmdealloc+0x26>
    80001548:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000154a:	6785                	lui	a5,0x1
    8000154c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000154e:	00f60733          	add	a4,a2,a5
    80001552:	76fd                	lui	a3,0xfffff
    80001554:	8f75                	and	a4,a4,a3
    80001556:	97ae                	add	a5,a5,a1
    80001558:	8ff5                	and	a5,a5,a3
    8000155a:	00f76863          	bltu	a4,a5,8000156a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000155e:	8526                	mv	a0,s1
    80001560:	60e2                	ld	ra,24(sp)
    80001562:	6442                	ld	s0,16(sp)
    80001564:	64a2                	ld	s1,8(sp)
    80001566:	6105                	addi	sp,sp,32
    80001568:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000156a:	8f99                	sub	a5,a5,a4
    8000156c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000156e:	4685                	li	a3,1
    80001570:	0007861b          	sext.w	a2,a5
    80001574:	85ba                	mv	a1,a4
    80001576:	00000097          	auipc	ra,0x0
    8000157a:	e4e080e7          	jalr	-434(ra) # 800013c4 <uvmunmap>
    8000157e:	b7c5                	j	8000155e <uvmdealloc+0x26>

0000000080001580 <uvmalloc>:
  if(newsz < oldsz)
    80001580:	0ab66b63          	bltu	a2,a1,80001636 <uvmalloc+0xb6>
{
    80001584:	7139                	addi	sp,sp,-64
    80001586:	fc06                	sd	ra,56(sp)
    80001588:	f822                	sd	s0,48(sp)
    8000158a:	ec4e                	sd	s3,24(sp)
    8000158c:	e852                	sd	s4,16(sp)
    8000158e:	e456                	sd	s5,8(sp)
    80001590:	0080                	addi	s0,sp,64
    80001592:	8aaa                	mv	s5,a0
    80001594:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001596:	6785                	lui	a5,0x1
    80001598:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000159a:	95be                	add	a1,a1,a5
    8000159c:	77fd                	lui	a5,0xfffff
    8000159e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015a2:	08c9fc63          	bgeu	s3,a2,8000163a <uvmalloc+0xba>
    800015a6:	f426                	sd	s1,40(sp)
    800015a8:	f04a                	sd	s2,32(sp)
    800015aa:	e05a                	sd	s6,0(sp)
    800015ac:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015ae:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800015b2:	fffff097          	auipc	ra,0xfffff
    800015b6:	650080e7          	jalr	1616(ra) # 80000c02 <kalloc>
    800015ba:	84aa                	mv	s1,a0
    if(mem == 0){
    800015bc:	c915                	beqz	a0,800015f0 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    800015be:	6605                	lui	a2,0x1
    800015c0:	4581                	li	a1,0
    800015c2:	00000097          	auipc	ra,0x0
    800015c6:	84a080e7          	jalr	-1974(ra) # 80000e0c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015ca:	875a                	mv	a4,s6
    800015cc:	86a6                	mv	a3,s1
    800015ce:	6605                	lui	a2,0x1
    800015d0:	85ca                	mv	a1,s2
    800015d2:	8556                	mv	a0,s5
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	c14080e7          	jalr	-1004(ra) # 800011e8 <mappages>
    800015dc:	ed05                	bnez	a0,80001614 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015de:	6785                	lui	a5,0x1
    800015e0:	993e                	add	s2,s2,a5
    800015e2:	fd4968e3          	bltu	s2,s4,800015b2 <uvmalloc+0x32>
  return newsz;
    800015e6:	8552                	mv	a0,s4
    800015e8:	74a2                	ld	s1,40(sp)
    800015ea:	7902                	ld	s2,32(sp)
    800015ec:	6b02                	ld	s6,0(sp)
    800015ee:	a821                	j	80001606 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    800015f0:	864e                	mv	a2,s3
    800015f2:	85ca                	mv	a1,s2
    800015f4:	8556                	mv	a0,s5
    800015f6:	00000097          	auipc	ra,0x0
    800015fa:	f42080e7          	jalr	-190(ra) # 80001538 <uvmdealloc>
      return 0;
    800015fe:	4501                	li	a0,0
    80001600:	74a2                	ld	s1,40(sp)
    80001602:	7902                	ld	s2,32(sp)
    80001604:	6b02                	ld	s6,0(sp)
}
    80001606:	70e2                	ld	ra,56(sp)
    80001608:	7442                	ld	s0,48(sp)
    8000160a:	69e2                	ld	s3,24(sp)
    8000160c:	6a42                	ld	s4,16(sp)
    8000160e:	6aa2                	ld	s5,8(sp)
    80001610:	6121                	addi	sp,sp,64
    80001612:	8082                	ret
      kfree(mem);
    80001614:	8526                	mv	a0,s1
    80001616:	fffff097          	auipc	ra,0xfffff
    8000161a:	484080e7          	jalr	1156(ra) # 80000a9a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000161e:	864e                	mv	a2,s3
    80001620:	85ca                	mv	a1,s2
    80001622:	8556                	mv	a0,s5
    80001624:	00000097          	auipc	ra,0x0
    80001628:	f14080e7          	jalr	-236(ra) # 80001538 <uvmdealloc>
      return 0;
    8000162c:	4501                	li	a0,0
    8000162e:	74a2                	ld	s1,40(sp)
    80001630:	7902                	ld	s2,32(sp)
    80001632:	6b02                	ld	s6,0(sp)
    80001634:	bfc9                	j	80001606 <uvmalloc+0x86>
    return oldsz;
    80001636:	852e                	mv	a0,a1
}
    80001638:	8082                	ret
  return newsz;
    8000163a:	8532                	mv	a0,a2
    8000163c:	b7e9                	j	80001606 <uvmalloc+0x86>

000000008000163e <uvmthreaded_alloc>:
  if(newsz < oldsz)
    8000163e:	14b66863          	bltu	a2,a1,8000178e <uvmthreaded_alloc+0x150>
uvmthreaded_alloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz, uint64 xperm) {
    80001642:	7159                	addi	sp,sp,-112
    80001644:	f486                	sd	ra,104(sp)
    80001646:	f0a2                	sd	s0,96(sp)
    80001648:	fc56                	sd	s5,56(sp)
    8000164a:	f062                	sd	s8,32(sp)
    8000164c:	ec66                	sd	s9,24(sp)
    8000164e:	e86a                	sd	s10,16(sp)
    80001650:	1880                	addi	s0,sp,112
    80001652:	8d2a                	mv	s10,a0
    80001654:	8ab2                	mv	s5,a2
    80001656:	8cb6                	mv	s9,a3
  oldsz = PGROUNDUP(oldsz);
    80001658:	6785                	lui	a5,0x1
    8000165a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000165c:	95be                	add	a1,a1,a5
    8000165e:	77fd                	lui	a5,0xfffff
    80001660:	00f5fc33          	and	s8,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001664:	12cc7763          	bgeu	s8,a2,80001792 <uvmthreaded_alloc+0x154>
    80001668:	eca6                	sd	s1,88(sp)
    8000166a:	e8ca                	sd	s2,80(sp)
    8000166c:	e4ce                	sd	s3,72(sp)
    8000166e:	e0d2                	sd	s4,64(sp)
    80001670:	f85a                	sd	s6,48(sp)
    80001672:	f45e                	sd	s7,40(sp)
    80001674:	e46e                	sd	s11,8(sp)
  struct proc *p = thread_proc->parent;
    80001676:	03853d83          	ld	s11,56(a0)
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000167a:	8b62                	mv	s6,s8
    8000167c:	370d8a13          	addi	s4,s11,880
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001680:	0126eb93          	ori	s7,a3,18
    80001684:	2b81                	sext.w	s7,s7
    mem = kalloc();
    80001686:	fffff097          	auipc	ra,0xfffff
    8000168a:	57c080e7          	jalr	1404(ra) # 80000c02 <kalloc>
    8000168e:	89aa                	mv	s3,a0
    if(mem == 0){
    80001690:	c911                	beqz	a0,800016a4 <uvmthreaded_alloc+0x66>
    memset(mem, 0, PGSIZE);
    80001692:	6605                	lui	a2,0x1
    80001694:	4581                	li	a1,0
    80001696:	fffff097          	auipc	ra,0xfffff
    8000169a:	776080e7          	jalr	1910(ra) # 80000e0c <memset>
    for (int i = 0; i < MAX_THREADS; i++) {
    8000169e:	170d8493          	addi	s1,s11,368
    800016a2:	a095                	j	80001706 <uvmthreaded_alloc+0xc8>
      uvmdealloc(thread_proc->pagetable, a, oldsz);
    800016a4:	8662                	mv	a2,s8
    800016a6:	85da                	mv	a1,s6
    800016a8:	050d3503          	ld	a0,80(s10)
    800016ac:	00000097          	auipc	ra,0x0
    800016b0:	e8c080e7          	jalr	-372(ra) # 80001538 <uvmdealloc>
      return 0;
    800016b4:	4501                	li	a0,0
    800016b6:	64e6                	ld	s1,88(sp)
    800016b8:	6946                	ld	s2,80(sp)
    800016ba:	69a6                	ld	s3,72(sp)
    800016bc:	6a06                	ld	s4,64(sp)
    800016be:	7b42                	ld	s6,48(sp)
    800016c0:	7ba2                	ld	s7,40(sp)
    800016c2:	6da2                	ld	s11,8(sp)
    800016c4:	a035                	j	800016f0 <uvmthreaded_alloc+0xb2>
        kfree(mem);
    800016c6:	854e                	mv	a0,s3
    800016c8:	fffff097          	auipc	ra,0xfffff
    800016cc:	3d2080e7          	jalr	978(ra) # 80000a9a <kfree>
        uvmdealloc(infant->pagetable, a, oldsz);
    800016d0:	8662                	mv	a2,s8
    800016d2:	85da                	mv	a1,s6
    800016d4:	05093503          	ld	a0,80(s2)
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	e60080e7          	jalr	-416(ra) # 80001538 <uvmdealloc>
        return 0;
    800016e0:	4501                	li	a0,0
    800016e2:	64e6                	ld	s1,88(sp)
    800016e4:	6946                	ld	s2,80(sp)
    800016e6:	69a6                	ld	s3,72(sp)
    800016e8:	6a06                	ld	s4,64(sp)
    800016ea:	7b42                	ld	s6,48(sp)
    800016ec:	7ba2                	ld	s7,40(sp)
    800016ee:	6da2                	ld	s11,8(sp)
}
    800016f0:	70a6                	ld	ra,104(sp)
    800016f2:	7406                	ld	s0,96(sp)
    800016f4:	7ae2                	ld	s5,56(sp)
    800016f6:	7c02                	ld	s8,32(sp)
    800016f8:	6ce2                	ld	s9,24(sp)
    800016fa:	6d42                	ld	s10,16(sp)
    800016fc:	6165                	addi	sp,sp,112
    800016fe:	8082                	ret
    for (int i = 0; i < MAX_THREADS; i++) {
    80001700:	04a1                	addi	s1,s1,8
    80001702:	03448463          	beq	s1,s4,8000172a <uvmthreaded_alloc+0xec>
      struct proc *infant = p->infant_threads[i];
    80001706:	0004b903          	ld	s2,0(s1)
      if (infant == 0)
    8000170a:	fe090be3          	beqz	s2,80001700 <uvmthreaded_alloc+0xc2>
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000170e:	875e                	mv	a4,s7
    80001710:	86ce                	mv	a3,s3
    80001712:	6605                	lui	a2,0x1
    80001714:	85da                	mv	a1,s6
    80001716:	05093503          	ld	a0,80(s2)
    8000171a:	00000097          	auipc	ra,0x0
    8000171e:	ace080e7          	jalr	-1330(ra) # 800011e8 <mappages>
    80001722:	f155                	bnez	a0,800016c6 <uvmthreaded_alloc+0x88>
      infant->sz = newsz;
    80001724:	05593423          	sd	s5,72(s2)
    80001728:	bfe1                	j	80001700 <uvmthreaded_alloc+0xc2>
    if(mappages(p->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000172a:	012ce713          	ori	a4,s9,18
    8000172e:	2701                	sext.w	a4,a4
    80001730:	86ce                	mv	a3,s3
    80001732:	6605                	lui	a2,0x1
    80001734:	85da                	mv	a1,s6
    80001736:	050db503          	ld	a0,80(s11)
    8000173a:	00000097          	auipc	ra,0x0
    8000173e:	aae080e7          	jalr	-1362(ra) # 800011e8 <mappages>
    80001742:	e105                	bnez	a0,80001762 <uvmthreaded_alloc+0x124>
    p->sz = newsz;
    80001744:	055db423          	sd	s5,72(s11)
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001748:	6785                	lui	a5,0x1
    8000174a:	9b3e                	add	s6,s6,a5
    8000174c:	f35b6de3          	bltu	s6,s5,80001686 <uvmthreaded_alloc+0x48>
  return newsz;
    80001750:	8556                	mv	a0,s5
    80001752:	64e6                	ld	s1,88(sp)
    80001754:	6946                	ld	s2,80(sp)
    80001756:	69a6                	ld	s3,72(sp)
    80001758:	6a06                	ld	s4,64(sp)
    8000175a:	7b42                	ld	s6,48(sp)
    8000175c:	7ba2                	ld	s7,40(sp)
    8000175e:	6da2                	ld	s11,8(sp)
    80001760:	bf41                	j	800016f0 <uvmthreaded_alloc+0xb2>
      kfree(mem);
    80001762:	854e                	mv	a0,s3
    80001764:	fffff097          	auipc	ra,0xfffff
    80001768:	336080e7          	jalr	822(ra) # 80000a9a <kfree>
      uvmdealloc(p->pagetable, a, oldsz);
    8000176c:	8662                	mv	a2,s8
    8000176e:	85da                	mv	a1,s6
    80001770:	050db503          	ld	a0,80(s11)
    80001774:	00000097          	auipc	ra,0x0
    80001778:	dc4080e7          	jalr	-572(ra) # 80001538 <uvmdealloc>
      return 0;
    8000177c:	4501                	li	a0,0
    8000177e:	64e6                	ld	s1,88(sp)
    80001780:	6946                	ld	s2,80(sp)
    80001782:	69a6                	ld	s3,72(sp)
    80001784:	6a06                	ld	s4,64(sp)
    80001786:	7b42                	ld	s6,48(sp)
    80001788:	7ba2                	ld	s7,40(sp)
    8000178a:	6da2                	ld	s11,8(sp)
    8000178c:	b795                	j	800016f0 <uvmthreaded_alloc+0xb2>
    return oldsz;
    8000178e:	852e                	mv	a0,a1
}
    80001790:	8082                	ret
  return newsz;
    80001792:	8532                	mv	a0,a2
    80001794:	bfb1                	j	800016f0 <uvmthreaded_alloc+0xb2>

0000000080001796 <uvmthreaded_dealloc>:

uint64
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
  struct proc *p = thread_proc->parent;

  if(newsz >= oldsz)
    80001796:	0ab67163          	bgeu	a2,a1,80001838 <uvmthreaded_dealloc+0xa2>
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
    8000179a:	715d                	addi	sp,sp,-80
    8000179c:	e486                	sd	ra,72(sp)
    8000179e:	e0a2                	sd	s0,64(sp)
    800017a0:	fc26                	sd	s1,56(sp)
    800017a2:	f84a                	sd	s2,48(sp)
    800017a4:	f44e                	sd	s3,40(sp)
    800017a6:	f052                	sd	s4,32(sp)
    800017a8:	ec56                	sd	s5,24(sp)
    800017aa:	e85a                	sd	s6,16(sp)
    800017ac:	e45e                	sd	s7,8(sp)
    800017ae:	e062                	sd	s8,0(sp)
    800017b0:	0880                	addi	s0,sp,80
    800017b2:	8ab2                	mv	s5,a2
  struct proc *p = thread_proc->parent;
    800017b4:	03853c03          	ld	s8,56(a0)
    return oldsz;

  int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800017b8:	6785                	lui	a5,0x1
    800017ba:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800017bc:	95be                	add	a1,a1,a5
    800017be:	777d                	lui	a4,0xfffff
    800017c0:	00e5fb33          	and	s6,a1,a4
    800017c4:	97b2                	add	a5,a5,a2
    800017c6:	00e7f9b3          	and	s3,a5,a4
    800017ca:	413b0bb3          	sub	s7,s6,s3
    800017ce:	00cbdb93          	srli	s7,s7,0xc
    800017d2:	2b81                	sext.w	s7,s7

  for (int i = 0; i < MAX_THREADS; i++) {
    800017d4:	170c0493          	addi	s1,s8,368
    800017d8:	370c0a13          	addi	s4,s8,880
    800017dc:	a031                	j	800017e8 <uvmthreaded_dealloc+0x52>
      continue;

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    }
    infant->sz = newsz;
    800017de:	05593423          	sd	s5,72(s2)
  for (int i = 0; i < MAX_THREADS; i++) {
    800017e2:	04a1                	addi	s1,s1,8
    800017e4:	03448263          	beq	s1,s4,80001808 <uvmthreaded_dealloc+0x72>
    struct proc *infant = p->infant_threads[i];
    800017e8:	0004b903          	ld	s2,0(s1)
    if (infant == 0)
    800017ec:	fe090be3          	beqz	s2,800017e2 <uvmthreaded_dealloc+0x4c>
    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
    800017f0:	ff69f7e3          	bgeu	s3,s6,800017de <uvmthreaded_dealloc+0x48>
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    800017f4:	4681                	li	a3,0
    800017f6:	865e                	mv	a2,s7
    800017f8:	85ce                	mv	a1,s3
    800017fa:	05093503          	ld	a0,80(s2)
    800017fe:	00000097          	auipc	ra,0x0
    80001802:	bc6080e7          	jalr	-1082(ra) # 800013c4 <uvmunmap>
    80001806:	bfe1                	j	800017de <uvmthreaded_dealloc+0x48>
  }

  uvmunmap(p->pagetable, PGROUNDUP(newsz), npages, 1); //unmap with freeing
    80001808:	4685                	li	a3,1
    8000180a:	865e                	mv	a2,s7
    8000180c:	85ce                	mv	a1,s3
    8000180e:	050c3503          	ld	a0,80(s8)
    80001812:	00000097          	auipc	ra,0x0
    80001816:	bb2080e7          	jalr	-1102(ra) # 800013c4 <uvmunmap>
  p->sz = newsz;
    8000181a:	055c3423          	sd	s5,72(s8)

  return newsz;
    8000181e:	8556                	mv	a0,s5
}
    80001820:	60a6                	ld	ra,72(sp)
    80001822:	6406                	ld	s0,64(sp)
    80001824:	74e2                	ld	s1,56(sp)
    80001826:	7942                	ld	s2,48(sp)
    80001828:	79a2                	ld	s3,40(sp)
    8000182a:	7a02                	ld	s4,32(sp)
    8000182c:	6ae2                	ld	s5,24(sp)
    8000182e:	6b42                	ld	s6,16(sp)
    80001830:	6ba2                	ld	s7,8(sp)
    80001832:	6c02                	ld	s8,0(sp)
    80001834:	6161                	addi	sp,sp,80
    80001836:	8082                	ret
    return oldsz;
    80001838:	852e                	mv	a0,a1
}
    8000183a:	8082                	ret

000000008000183c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000183c:	7179                	addi	sp,sp,-48
    8000183e:	f406                	sd	ra,40(sp)
    80001840:	f022                	sd	s0,32(sp)
    80001842:	ec26                	sd	s1,24(sp)
    80001844:	e84a                	sd	s2,16(sp)
    80001846:	e44e                	sd	s3,8(sp)
    80001848:	e052                	sd	s4,0(sp)
    8000184a:	1800                	addi	s0,sp,48
    8000184c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000184e:	84aa                	mv	s1,a0
    80001850:	6905                	lui	s2,0x1
    80001852:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001854:	4985                	li	s3,1
    80001856:	a829                	j	80001870 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001858:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000185a:	00c79513          	slli	a0,a5,0xc
    8000185e:	00000097          	auipc	ra,0x0
    80001862:	fde080e7          	jalr	-34(ra) # 8000183c <freewalk>
      pagetable[i] = 0;
    80001866:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000186a:	04a1                	addi	s1,s1,8
    8000186c:	03248163          	beq	s1,s2,8000188e <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001870:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001872:	00f7f713          	andi	a4,a5,15
    80001876:	ff3701e3          	beq	a4,s3,80001858 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000187a:	8b85                	andi	a5,a5,1
    8000187c:	d7fd                	beqz	a5,8000186a <freewalk+0x2e>
      panic("freewalk: leaf");
    8000187e:	0000a517          	auipc	a0,0xa
    80001882:	8ea50513          	addi	a0,a0,-1814 # 8000b168 <etext+0x168>
    80001886:	fffff097          	auipc	ra,0xfffff
    8000188a:	cda080e7          	jalr	-806(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    8000188e:	8552                	mv	a0,s4
    80001890:	fffff097          	auipc	ra,0xfffff
    80001894:	20a080e7          	jalr	522(ra) # 80000a9a <kfree>
}
    80001898:	70a2                	ld	ra,40(sp)
    8000189a:	7402                	ld	s0,32(sp)
    8000189c:	64e2                	ld	s1,24(sp)
    8000189e:	6942                	ld	s2,16(sp)
    800018a0:	69a2                	ld	s3,8(sp)
    800018a2:	6a02                	ld	s4,0(sp)
    800018a4:	6145                	addi	sp,sp,48
    800018a6:	8082                	ret

00000000800018a8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800018a8:	1101                	addi	sp,sp,-32
    800018aa:	ec06                	sd	ra,24(sp)
    800018ac:	e822                	sd	s0,16(sp)
    800018ae:	e426                	sd	s1,8(sp)
    800018b0:	1000                	addi	s0,sp,32
    800018b2:	84aa                	mv	s1,a0
  if(sz > 0)
    800018b4:	e999                	bnez	a1,800018ca <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800018b6:	8526                	mv	a0,s1
    800018b8:	00000097          	auipc	ra,0x0
    800018bc:	f84080e7          	jalr	-124(ra) # 8000183c <freewalk>
}
    800018c0:	60e2                	ld	ra,24(sp)
    800018c2:	6442                	ld	s0,16(sp)
    800018c4:	64a2                	ld	s1,8(sp)
    800018c6:	6105                	addi	sp,sp,32
    800018c8:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800018ca:	6785                	lui	a5,0x1
    800018cc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800018ce:	95be                	add	a1,a1,a5
    800018d0:	4685                	li	a3,1
    800018d2:	00c5d613          	srli	a2,a1,0xc
    800018d6:	4581                	li	a1,0
    800018d8:	00000097          	auipc	ra,0x0
    800018dc:	aec080e7          	jalr	-1300(ra) # 800013c4 <uvmunmap>
    800018e0:	bfd9                	j	800018b6 <uvmfree+0xe>

00000000800018e2 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800018e2:	c679                	beqz	a2,800019b0 <uvmcopy+0xce>
{
    800018e4:	715d                	addi	sp,sp,-80
    800018e6:	e486                	sd	ra,72(sp)
    800018e8:	e0a2                	sd	s0,64(sp)
    800018ea:	fc26                	sd	s1,56(sp)
    800018ec:	f84a                	sd	s2,48(sp)
    800018ee:	f44e                	sd	s3,40(sp)
    800018f0:	f052                	sd	s4,32(sp)
    800018f2:	ec56                	sd	s5,24(sp)
    800018f4:	e85a                	sd	s6,16(sp)
    800018f6:	e45e                	sd	s7,8(sp)
    800018f8:	0880                	addi	s0,sp,80
    800018fa:	8b2a                	mv	s6,a0
    800018fc:	8aae                	mv	s5,a1
    800018fe:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001900:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001902:	4601                	li	a2,0
    80001904:	85ce                	mv	a1,s3
    80001906:	855a                	mv	a0,s6
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	7f8080e7          	jalr	2040(ra) # 80001100 <walk>
    80001910:	c531                	beqz	a0,8000195c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001912:	6118                	ld	a4,0(a0)
    80001914:	00177793          	andi	a5,a4,1
    80001918:	cbb1                	beqz	a5,8000196c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000191a:	00a75593          	srli	a1,a4,0xa
    8000191e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001922:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	2dc080e7          	jalr	732(ra) # 80000c02 <kalloc>
    8000192e:	892a                	mv	s2,a0
    80001930:	c939                	beqz	a0,80001986 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001932:	6605                	lui	a2,0x1
    80001934:	85de                	mv	a1,s7
    80001936:	fffff097          	auipc	ra,0xfffff
    8000193a:	532080e7          	jalr	1330(ra) # 80000e68 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000193e:	8726                	mv	a4,s1
    80001940:	86ca                	mv	a3,s2
    80001942:	6605                	lui	a2,0x1
    80001944:	85ce                	mv	a1,s3
    80001946:	8556                	mv	a0,s5
    80001948:	00000097          	auipc	ra,0x0
    8000194c:	8a0080e7          	jalr	-1888(ra) # 800011e8 <mappages>
    80001950:	e515                	bnez	a0,8000197c <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001952:	6785                	lui	a5,0x1
    80001954:	99be                	add	s3,s3,a5
    80001956:	fb49e6e3          	bltu	s3,s4,80001902 <uvmcopy+0x20>
    8000195a:	a081                	j	8000199a <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    8000195c:	0000a517          	auipc	a0,0xa
    80001960:	81c50513          	addi	a0,a0,-2020 # 8000b178 <etext+0x178>
    80001964:	fffff097          	auipc	ra,0xfffff
    80001968:	bfc080e7          	jalr	-1028(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    8000196c:	0000a517          	auipc	a0,0xa
    80001970:	82c50513          	addi	a0,a0,-2004 # 8000b198 <etext+0x198>
    80001974:	fffff097          	auipc	ra,0xfffff
    80001978:	bec080e7          	jalr	-1044(ra) # 80000560 <panic>
      kfree(mem);
    8000197c:	854a                	mv	a0,s2
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	11c080e7          	jalr	284(ra) # 80000a9a <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001986:	4685                	li	a3,1
    80001988:	00c9d613          	srli	a2,s3,0xc
    8000198c:	4581                	li	a1,0
    8000198e:	8556                	mv	a0,s5
    80001990:	00000097          	auipc	ra,0x0
    80001994:	a34080e7          	jalr	-1484(ra) # 800013c4 <uvmunmap>
  return -1;
    80001998:	557d                	li	a0,-1
}
    8000199a:	60a6                	ld	ra,72(sp)
    8000199c:	6406                	ld	s0,64(sp)
    8000199e:	74e2                	ld	s1,56(sp)
    800019a0:	7942                	ld	s2,48(sp)
    800019a2:	79a2                	ld	s3,40(sp)
    800019a4:	7a02                	ld	s4,32(sp)
    800019a6:	6ae2                	ld	s5,24(sp)
    800019a8:	6b42                	ld	s6,16(sp)
    800019aa:	6ba2                	ld	s7,8(sp)
    800019ac:	6161                	addi	sp,sp,80
    800019ae:	8082                	ret
  return 0;
    800019b0:	4501                	li	a0,0
}
    800019b2:	8082                	ret

00000000800019b4 <uvmshare>:

int
uvmshare(pagetable_t old, pagetable_t new, uint64 sz)
{
    800019b4:	7139                	addi	sp,sp,-64
    800019b6:	fc06                	sd	ra,56(sp)
    800019b8:	f822                	sd	s0,48(sp)
    800019ba:	ec4e                	sd	s3,24(sp)
    800019bc:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa = 0, i;
  uint flags;
  
  for(i = 0; i < sz; i += PGSIZE) {
    800019be:	ce45                	beqz	a2,80001a76 <uvmshare+0xc2>
    800019c0:	f426                	sd	s1,40(sp)
    800019c2:	f04a                	sd	s2,32(sp)
    800019c4:	e852                	sd	s4,16(sp)
    800019c6:	e456                	sd	s5,8(sp)
    800019c8:	e05a                	sd	s6,0(sp)
    800019ca:	8b2a                	mv	s6,a0
    800019cc:	8aae                	mv	s5,a1
    800019ce:	8a32                	mv	s4,a2
    800019d0:	4901                	li	s2,0
    800019d2:	a891                	j	80001a26 <uvmshare+0x72>
    pte = walk(old, i, 0);

    if(pte == 0) panic("uvmshare: pte should exist");
    800019d4:	00009517          	auipc	a0,0x9
    800019d8:	7e450513          	addi	a0,a0,2020 # 8000b1b8 <etext+0x1b8>
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	b84080e7          	jalr	-1148(ra) # 80000560 <panic>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    800019e4:	00009517          	auipc	a0,0x9
    800019e8:	7f450513          	addi	a0,a0,2036 # 8000b1d8 <etext+0x1d8>
    800019ec:	fffff097          	auipc	ra,0xfffff
    800019f0:	b74080e7          	jalr	-1164(ra) # 80000560 <panic>
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    // flags |= PTE_W;

    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
      uvmunmap(new, 0, i / PGSIZE, 0);
    800019f4:	4681                	li	a3,0
    800019f6:	00c95613          	srli	a2,s2,0xc
    800019fa:	4581                	li	a1,0
    800019fc:	8556                	mv	a0,s5
    800019fe:	00000097          	auipc	ra,0x0
    80001a02:	9c6080e7          	jalr	-1594(ra) # 800013c4 <uvmunmap>
      return -1;
    80001a06:	59fd                	li	s3,-1
    80001a08:	74a2                	ld	s1,40(sp)
    80001a0a:	7902                	ld	s2,32(sp)
    80001a0c:	6a42                	ld	s4,16(sp)
    80001a0e:	6aa2                	ld	s5,8(sp)
    80001a10:	6b02                	ld	s6,0(sp)
      add_page_reference((uint64)pa);
  }

  return 0;

}
    80001a12:	854e                	mv	a0,s3
    80001a14:	70e2                	ld	ra,56(sp)
    80001a16:	7442                	ld	s0,48(sp)
    80001a18:	69e2                	ld	s3,24(sp)
    80001a1a:	6121                	addi	sp,sp,64
    80001a1c:	8082                	ret
  for(i = 0; i < sz; i += PGSIZE) {
    80001a1e:	6785                	lui	a5,0x1
    80001a20:	993e                	add	s2,s2,a5
    80001a22:	05497463          	bgeu	s2,s4,80001a6a <uvmshare+0xb6>
    pte = walk(old, i, 0);
    80001a26:	4601                	li	a2,0
    80001a28:	85ca                	mv	a1,s2
    80001a2a:	855a                	mv	a0,s6
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	6d4080e7          	jalr	1748(ra) # 80001100 <walk>
    if(pte == 0) panic("uvmshare: pte should exist");
    80001a34:	d145                	beqz	a0,800019d4 <uvmshare+0x20>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001a36:	6118                	ld	a4,0(a0)
    80001a38:	00177793          	andi	a5,a4,1
    80001a3c:	d7c5                	beqz	a5,800019e4 <uvmshare+0x30>
    pa = PTE2PA(*pte);
    80001a3e:	00a75493          	srli	s1,a4,0xa
    80001a42:	04b2                	slli	s1,s1,0xc
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
    80001a44:	3ff77713          	andi	a4,a4,1023
    80001a48:	86a6                	mv	a3,s1
    80001a4a:	6605                	lui	a2,0x1
    80001a4c:	85ca                	mv	a1,s2
    80001a4e:	8556                	mv	a0,s5
    80001a50:	fffff097          	auipc	ra,0xfffff
    80001a54:	798080e7          	jalr	1944(ra) # 800011e8 <mappages>
    80001a58:	89aa                	mv	s3,a0
    80001a5a:	fd49                	bnez	a0,800019f4 <uvmshare+0x40>
    if (pa != 0)
    80001a5c:	d0e9                	beqz	s1,80001a1e <uvmshare+0x6a>
      add_page_reference((uint64)pa);
    80001a5e:	8526                	mv	a0,s1
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	fea080e7          	jalr	-22(ra) # 80000a4a <add_page_reference>
    80001a68:	bf5d                	j	80001a1e <uvmshare+0x6a>
    80001a6a:	74a2                	ld	s1,40(sp)
    80001a6c:	7902                	ld	s2,32(sp)
    80001a6e:	6a42                	ld	s4,16(sp)
    80001a70:	6aa2                	ld	s5,8(sp)
    80001a72:	6b02                	ld	s6,0(sp)
    80001a74:	bf79                	j	80001a12 <uvmshare+0x5e>
  return 0;
    80001a76:	4981                	li	s3,0
    80001a78:	bf69                	j	80001a12 <uvmshare+0x5e>

0000000080001a7a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001a7a:	1141                	addi	sp,sp,-16
    80001a7c:	e406                	sd	ra,8(sp)
    80001a7e:	e022                	sd	s0,0(sp)
    80001a80:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001a82:	4601                	li	a2,0
    80001a84:	fffff097          	auipc	ra,0xfffff
    80001a88:	67c080e7          	jalr	1660(ra) # 80001100 <walk>
  if(pte == 0)
    80001a8c:	c901                	beqz	a0,80001a9c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001a8e:	611c                	ld	a5,0(a0)
    80001a90:	9bbd                	andi	a5,a5,-17
    80001a92:	e11c                	sd	a5,0(a0)
}
    80001a94:	60a2                	ld	ra,8(sp)
    80001a96:	6402                	ld	s0,0(sp)
    80001a98:	0141                	addi	sp,sp,16
    80001a9a:	8082                	ret
    panic("uvmclear");
    80001a9c:	00009517          	auipc	a0,0x9
    80001aa0:	75c50513          	addi	a0,a0,1884 # 8000b1f8 <etext+0x1f8>
    80001aa4:	fffff097          	auipc	ra,0xfffff
    80001aa8:	abc080e7          	jalr	-1348(ra) # 80000560 <panic>

0000000080001aac <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001aac:	c6bd                	beqz	a3,80001b1a <copyout+0x6e>
{
    80001aae:	715d                	addi	sp,sp,-80
    80001ab0:	e486                	sd	ra,72(sp)
    80001ab2:	e0a2                	sd	s0,64(sp)
    80001ab4:	fc26                	sd	s1,56(sp)
    80001ab6:	f84a                	sd	s2,48(sp)
    80001ab8:	f44e                	sd	s3,40(sp)
    80001aba:	f052                	sd	s4,32(sp)
    80001abc:	ec56                	sd	s5,24(sp)
    80001abe:	e85a                	sd	s6,16(sp)
    80001ac0:	e45e                	sd	s7,8(sp)
    80001ac2:	e062                	sd	s8,0(sp)
    80001ac4:	0880                	addi	s0,sp,80
    80001ac6:	8b2a                	mv	s6,a0
    80001ac8:	8c2e                	mv	s8,a1
    80001aca:	8a32                	mv	s4,a2
    80001acc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001ace:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001ad0:	6a85                	lui	s5,0x1
    80001ad2:	a015                	j	80001af6 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001ad4:	9562                	add	a0,a0,s8
    80001ad6:	0004861b          	sext.w	a2,s1
    80001ada:	85d2                	mv	a1,s4
    80001adc:	41250533          	sub	a0,a0,s2
    80001ae0:	fffff097          	auipc	ra,0xfffff
    80001ae4:	388080e7          	jalr	904(ra) # 80000e68 <memmove>

    len -= n;
    80001ae8:	409989b3          	sub	s3,s3,s1
    src += n;
    80001aec:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001aee:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001af2:	02098263          	beqz	s3,80001b16 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001af6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001afa:	85ca                	mv	a1,s2
    80001afc:	855a                	mv	a0,s6
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	6a8080e7          	jalr	1704(ra) # 800011a6 <walkaddr>
    if(pa0 == 0)
    80001b06:	cd01                	beqz	a0,80001b1e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001b08:	418904b3          	sub	s1,s2,s8
    80001b0c:	94d6                	add	s1,s1,s5
    if(n > len)
    80001b0e:	fc99f3e3          	bgeu	s3,s1,80001ad4 <copyout+0x28>
    80001b12:	84ce                	mv	s1,s3
    80001b14:	b7c1                	j	80001ad4 <copyout+0x28>
  }
  return 0;
    80001b16:	4501                	li	a0,0
    80001b18:	a021                	j	80001b20 <copyout+0x74>
    80001b1a:	4501                	li	a0,0
}
    80001b1c:	8082                	ret
      return -1;
    80001b1e:	557d                	li	a0,-1
}
    80001b20:	60a6                	ld	ra,72(sp)
    80001b22:	6406                	ld	s0,64(sp)
    80001b24:	74e2                	ld	s1,56(sp)
    80001b26:	7942                	ld	s2,48(sp)
    80001b28:	79a2                	ld	s3,40(sp)
    80001b2a:	7a02                	ld	s4,32(sp)
    80001b2c:	6ae2                	ld	s5,24(sp)
    80001b2e:	6b42                	ld	s6,16(sp)
    80001b30:	6ba2                	ld	s7,8(sp)
    80001b32:	6c02                	ld	s8,0(sp)
    80001b34:	6161                	addi	sp,sp,80
    80001b36:	8082                	ret

0000000080001b38 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001b38:	caa5                	beqz	a3,80001ba8 <copyin+0x70>
{
    80001b3a:	715d                	addi	sp,sp,-80
    80001b3c:	e486                	sd	ra,72(sp)
    80001b3e:	e0a2                	sd	s0,64(sp)
    80001b40:	fc26                	sd	s1,56(sp)
    80001b42:	f84a                	sd	s2,48(sp)
    80001b44:	f44e                	sd	s3,40(sp)
    80001b46:	f052                	sd	s4,32(sp)
    80001b48:	ec56                	sd	s5,24(sp)
    80001b4a:	e85a                	sd	s6,16(sp)
    80001b4c:	e45e                	sd	s7,8(sp)
    80001b4e:	e062                	sd	s8,0(sp)
    80001b50:	0880                	addi	s0,sp,80
    80001b52:	8b2a                	mv	s6,a0
    80001b54:	8a2e                	mv	s4,a1
    80001b56:	8c32                	mv	s8,a2
    80001b58:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001b5a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001b5c:	6a85                	lui	s5,0x1
    80001b5e:	a01d                	j	80001b84 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001b60:	018505b3          	add	a1,a0,s8
    80001b64:	0004861b          	sext.w	a2,s1
    80001b68:	412585b3          	sub	a1,a1,s2
    80001b6c:	8552                	mv	a0,s4
    80001b6e:	fffff097          	auipc	ra,0xfffff
    80001b72:	2fa080e7          	jalr	762(ra) # 80000e68 <memmove>

    len -= n;
    80001b76:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001b7a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001b7c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001b80:	02098263          	beqz	s3,80001ba4 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001b84:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001b88:	85ca                	mv	a1,s2
    80001b8a:	855a                	mv	a0,s6
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	61a080e7          	jalr	1562(ra) # 800011a6 <walkaddr>
    if(pa0 == 0)
    80001b94:	cd01                	beqz	a0,80001bac <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001b96:	418904b3          	sub	s1,s2,s8
    80001b9a:	94d6                	add	s1,s1,s5
    if(n > len)
    80001b9c:	fc99f2e3          	bgeu	s3,s1,80001b60 <copyin+0x28>
    80001ba0:	84ce                	mv	s1,s3
    80001ba2:	bf7d                	j	80001b60 <copyin+0x28>
  }
  return 0;
    80001ba4:	4501                	li	a0,0
    80001ba6:	a021                	j	80001bae <copyin+0x76>
    80001ba8:	4501                	li	a0,0
}
    80001baa:	8082                	ret
      return -1;
    80001bac:	557d                	li	a0,-1
}
    80001bae:	60a6                	ld	ra,72(sp)
    80001bb0:	6406                	ld	s0,64(sp)
    80001bb2:	74e2                	ld	s1,56(sp)
    80001bb4:	7942                	ld	s2,48(sp)
    80001bb6:	79a2                	ld	s3,40(sp)
    80001bb8:	7a02                	ld	s4,32(sp)
    80001bba:	6ae2                	ld	s5,24(sp)
    80001bbc:	6b42                	ld	s6,16(sp)
    80001bbe:	6ba2                	ld	s7,8(sp)
    80001bc0:	6c02                	ld	s8,0(sp)
    80001bc2:	6161                	addi	sp,sp,80
    80001bc4:	8082                	ret

0000000080001bc6 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001bc6:	cacd                	beqz	a3,80001c78 <copyinstr+0xb2>
{
    80001bc8:	715d                	addi	sp,sp,-80
    80001bca:	e486                	sd	ra,72(sp)
    80001bcc:	e0a2                	sd	s0,64(sp)
    80001bce:	fc26                	sd	s1,56(sp)
    80001bd0:	f84a                	sd	s2,48(sp)
    80001bd2:	f44e                	sd	s3,40(sp)
    80001bd4:	f052                	sd	s4,32(sp)
    80001bd6:	ec56                	sd	s5,24(sp)
    80001bd8:	e85a                	sd	s6,16(sp)
    80001bda:	e45e                	sd	s7,8(sp)
    80001bdc:	0880                	addi	s0,sp,80
    80001bde:	8a2a                	mv	s4,a0
    80001be0:	8b2e                	mv	s6,a1
    80001be2:	8bb2                	mv	s7,a2
    80001be4:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80001be6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001be8:	6985                	lui	s3,0x1
    80001bea:	a825                	j	80001c22 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001bec:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001bf0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001bf2:	37fd                	addiw	a5,a5,-1
    80001bf4:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001bf8:	60a6                	ld	ra,72(sp)
    80001bfa:	6406                	ld	s0,64(sp)
    80001bfc:	74e2                	ld	s1,56(sp)
    80001bfe:	7942                	ld	s2,48(sp)
    80001c00:	79a2                	ld	s3,40(sp)
    80001c02:	7a02                	ld	s4,32(sp)
    80001c04:	6ae2                	ld	s5,24(sp)
    80001c06:	6b42                	ld	s6,16(sp)
    80001c08:	6ba2                	ld	s7,8(sp)
    80001c0a:	6161                	addi	sp,sp,80
    80001c0c:	8082                	ret
    80001c0e:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001c12:	9742                	add	a4,a4,a6
      --max;
    80001c14:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001c18:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001c1c:	04e58663          	beq	a1,a4,80001c68 <copyinstr+0xa2>
{
    80001c20:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001c22:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001c26:	85a6                	mv	a1,s1
    80001c28:	8552                	mv	a0,s4
    80001c2a:	fffff097          	auipc	ra,0xfffff
    80001c2e:	57c080e7          	jalr	1404(ra) # 800011a6 <walkaddr>
    if(pa0 == 0)
    80001c32:	cd0d                	beqz	a0,80001c6c <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80001c34:	417486b3          	sub	a3,s1,s7
    80001c38:	96ce                	add	a3,a3,s3
    if(n > max)
    80001c3a:	00d97363          	bgeu	s2,a3,80001c40 <copyinstr+0x7a>
    80001c3e:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001c40:	955e                	add	a0,a0,s7
    80001c42:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001c44:	c695                	beqz	a3,80001c70 <copyinstr+0xaa>
    80001c46:	87da                	mv	a5,s6
    80001c48:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001c4a:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001c4e:	96da                	add	a3,a3,s6
    80001c50:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001c52:	00f60733          	add	a4,a2,a5
    80001c56:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff8eb68>
    80001c5a:	db49                	beqz	a4,80001bec <copyinstr+0x26>
        *dst = *p;
    80001c5c:	00e78023          	sb	a4,0(a5)
      dst++;
    80001c60:	0785                	addi	a5,a5,1
    while(n > 0){
    80001c62:	fed797e3          	bne	a5,a3,80001c50 <copyinstr+0x8a>
    80001c66:	b765                	j	80001c0e <copyinstr+0x48>
    80001c68:	4781                	li	a5,0
    80001c6a:	b761                	j	80001bf2 <copyinstr+0x2c>
      return -1;
    80001c6c:	557d                	li	a0,-1
    80001c6e:	b769                	j	80001bf8 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001c70:	6b85                	lui	s7,0x1
    80001c72:	9ba6                	add	s7,s7,s1
    80001c74:	87da                	mv	a5,s6
    80001c76:	b76d                	j	80001c20 <copyinstr+0x5a>
  int got_null = 0;
    80001c78:	4781                	li	a5,0
  if(got_null){
    80001c7a:	37fd                	addiw	a5,a5,-1
    80001c7c:	0007851b          	sext.w	a0,a5
}
    80001c80:	8082                	ret

0000000080001c82 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001c82:	7139                	addi	sp,sp,-64
    80001c84:	fc06                	sd	ra,56(sp)
    80001c86:	f822                	sd	s0,48(sp)
    80001c88:	f426                	sd	s1,40(sp)
    80001c8a:	f04a                	sd	s2,32(sp)
    80001c8c:	ec4e                	sd	s3,24(sp)
    80001c8e:	e852                	sd	s4,16(sp)
    80001c90:	e456                	sd	s5,8(sp)
    80001c92:	e05a                	sd	s6,0(sp)
    80001c94:	0080                	addi	s0,sp,64
    80001c96:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c98:	00053497          	auipc	s1,0x53
    80001c9c:	38848493          	addi	s1,s1,904 # 80055020 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001ca0:	8b26                	mv	s6,s1
    80001ca2:	006fb937          	lui	s2,0x6fb
    80001ca6:	58790913          	addi	s2,s2,1415 # 6fb587 <_entry-0x7f904a79>
    80001caa:	0936                	slli	s2,s2,0xd
    80001cac:	f6b90913          	addi	s2,s2,-149
    80001cb0:	093e                	slli	s2,s2,0xf
    80001cb2:	6fb90913          	addi	s2,s2,1787
    80001cb6:	0932                	slli	s2,s2,0xc
    80001cb8:	58790913          	addi	s2,s2,1415
    80001cbc:	040009b7          	lui	s3,0x4000
    80001cc0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001cc2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cc4:	00061a97          	auipc	s5,0x61
    80001cc8:	f5ca8a93          	addi	s5,s5,-164 # 80062c20 <tickslock>
    char *pa = kalloc();
    80001ccc:	fffff097          	auipc	ra,0xfffff
    80001cd0:	f36080e7          	jalr	-202(ra) # 80000c02 <kalloc>
    80001cd4:	862a                	mv	a2,a0
    if(pa == 0)
    80001cd6:	c121                	beqz	a0,80001d16 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80001cd8:	416485b3          	sub	a1,s1,s6
    80001cdc:	8591                	srai	a1,a1,0x4
    80001cde:	032585b3          	mul	a1,a1,s2
    80001ce2:	2585                	addiw	a1,a1,1
    80001ce4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ce8:	4719                	li	a4,6
    80001cea:	6685                	lui	a3,0x1
    80001cec:	40b985b3          	sub	a1,s3,a1
    80001cf0:	8552                	mv	a0,s4
    80001cf2:	fffff097          	auipc	ra,0xfffff
    80001cf6:	596080e7          	jalr	1430(ra) # 80001288 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cfa:	37048493          	addi	s1,s1,880
    80001cfe:	fd5497e3          	bne	s1,s5,80001ccc <proc_mapstacks+0x4a>
  }
}
    80001d02:	70e2                	ld	ra,56(sp)
    80001d04:	7442                	ld	s0,48(sp)
    80001d06:	74a2                	ld	s1,40(sp)
    80001d08:	7902                	ld	s2,32(sp)
    80001d0a:	69e2                	ld	s3,24(sp)
    80001d0c:	6a42                	ld	s4,16(sp)
    80001d0e:	6aa2                	ld	s5,8(sp)
    80001d10:	6b02                	ld	s6,0(sp)
    80001d12:	6121                	addi	sp,sp,64
    80001d14:	8082                	ret
      panic("kalloc");
    80001d16:	00009517          	auipc	a0,0x9
    80001d1a:	4f250513          	addi	a0,a0,1266 # 8000b208 <etext+0x208>
    80001d1e:	fffff097          	auipc	ra,0xfffff
    80001d22:	842080e7          	jalr	-1982(ra) # 80000560 <panic>

0000000080001d26 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001d26:	7139                	addi	sp,sp,-64
    80001d28:	fc06                	sd	ra,56(sp)
    80001d2a:	f822                	sd	s0,48(sp)
    80001d2c:	f426                	sd	s1,40(sp)
    80001d2e:	f04a                	sd	s2,32(sp)
    80001d30:	ec4e                	sd	s3,24(sp)
    80001d32:	e852                	sd	s4,16(sp)
    80001d34:	e456                	sd	s5,8(sp)
    80001d36:	e05a                	sd	s6,0(sp)
    80001d38:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001d3a:	00009597          	auipc	a1,0x9
    80001d3e:	4d658593          	addi	a1,a1,1238 # 8000b210 <etext+0x210>
    80001d42:	00053517          	auipc	a0,0x53
    80001d46:	eae50513          	addi	a0,a0,-338 # 80054bf0 <pid_lock>
    80001d4a:	fffff097          	auipc	ra,0xfffff
    80001d4e:	f36080e7          	jalr	-202(ra) # 80000c80 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001d52:	00009597          	auipc	a1,0x9
    80001d56:	4c658593          	addi	a1,a1,1222 # 8000b218 <etext+0x218>
    80001d5a:	00053517          	auipc	a0,0x53
    80001d5e:	eae50513          	addi	a0,a0,-338 # 80054c08 <wait_lock>
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	f1e080e7          	jalr	-226(ra) # 80000c80 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d6a:	00053497          	auipc	s1,0x53
    80001d6e:	2b648493          	addi	s1,s1,694 # 80055020 <proc>
      initlock(&p->lock, "proc");
    80001d72:	00009b17          	auipc	s6,0x9
    80001d76:	4b6b0b13          	addi	s6,s6,1206 # 8000b228 <etext+0x228>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001d7a:	8aa6                	mv	s5,s1
    80001d7c:	006fb937          	lui	s2,0x6fb
    80001d80:	58790913          	addi	s2,s2,1415 # 6fb587 <_entry-0x7f904a79>
    80001d84:	0936                	slli	s2,s2,0xd
    80001d86:	f6b90913          	addi	s2,s2,-149
    80001d8a:	093e                	slli	s2,s2,0xf
    80001d8c:	6fb90913          	addi	s2,s2,1787
    80001d90:	0932                	slli	s2,s2,0xc
    80001d92:	58790913          	addi	s2,s2,1415
    80001d96:	040009b7          	lui	s3,0x4000
    80001d9a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001d9c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d9e:	00061a17          	auipc	s4,0x61
    80001da2:	e82a0a13          	addi	s4,s4,-382 # 80062c20 <tickslock>
      initlock(&p->lock, "proc");
    80001da6:	85da                	mv	a1,s6
    80001da8:	8526                	mv	a0,s1
    80001daa:	fffff097          	auipc	ra,0xfffff
    80001dae:	ed6080e7          	jalr	-298(ra) # 80000c80 <initlock>
      p->state = UNUSED;
    80001db2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001db6:	415487b3          	sub	a5,s1,s5
    80001dba:	8791                	srai	a5,a5,0x4
    80001dbc:	032787b3          	mul	a5,a5,s2
    80001dc0:	2785                	addiw	a5,a5,1
    80001dc2:	00d7979b          	slliw	a5,a5,0xd
    80001dc6:	40f987b3          	sub	a5,s3,a5
    80001dca:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001dcc:	37048493          	addi	s1,s1,880
    80001dd0:	fd449be3          	bne	s1,s4,80001da6 <procinit+0x80>
  }
}
    80001dd4:	70e2                	ld	ra,56(sp)
    80001dd6:	7442                	ld	s0,48(sp)
    80001dd8:	74a2                	ld	s1,40(sp)
    80001dda:	7902                	ld	s2,32(sp)
    80001ddc:	69e2                	ld	s3,24(sp)
    80001dde:	6a42                	ld	s4,16(sp)
    80001de0:	6aa2                	ld	s5,8(sp)
    80001de2:	6b02                	ld	s6,0(sp)
    80001de4:	6121                	addi	sp,sp,64
    80001de6:	8082                	ret

0000000080001de8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001de8:	1141                	addi	sp,sp,-16
    80001dea:	e422                	sd	s0,8(sp)
    80001dec:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dee:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001df0:	2501                	sext.w	a0,a0
    80001df2:	6422                	ld	s0,8(sp)
    80001df4:	0141                	addi	sp,sp,16
    80001df6:	8082                	ret

0000000080001df8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001df8:	1141                	addi	sp,sp,-16
    80001dfa:	e422                	sd	s0,8(sp)
    80001dfc:	0800                	addi	s0,sp,16
    80001dfe:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001e00:	2781                	sext.w	a5,a5
    80001e02:	079e                	slli	a5,a5,0x7
  return c;
}
    80001e04:	00053517          	auipc	a0,0x53
    80001e08:	e1c50513          	addi	a0,a0,-484 # 80054c20 <cpus>
    80001e0c:	953e                	add	a0,a0,a5
    80001e0e:	6422                	ld	s0,8(sp)
    80001e10:	0141                	addi	sp,sp,16
    80001e12:	8082                	ret

0000000080001e14 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001e14:	1101                	addi	sp,sp,-32
    80001e16:	ec06                	sd	ra,24(sp)
    80001e18:	e822                	sd	s0,16(sp)
    80001e1a:	e426                	sd	s1,8(sp)
    80001e1c:	1000                	addi	s0,sp,32
  push_off();
    80001e1e:	fffff097          	auipc	ra,0xfffff
    80001e22:	ea6080e7          	jalr	-346(ra) # 80000cc4 <push_off>
    80001e26:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001e28:	2781                	sext.w	a5,a5
    80001e2a:	079e                	slli	a5,a5,0x7
    80001e2c:	00053717          	auipc	a4,0x53
    80001e30:	dc470713          	addi	a4,a4,-572 # 80054bf0 <pid_lock>
    80001e34:	97ba                	add	a5,a5,a4
    80001e36:	7b84                	ld	s1,48(a5)
  pop_off();
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	f2c080e7          	jalr	-212(ra) # 80000d64 <pop_off>
  return p;
}
    80001e40:	8526                	mv	a0,s1
    80001e42:	60e2                	ld	ra,24(sp)
    80001e44:	6442                	ld	s0,16(sp)
    80001e46:	64a2                	ld	s1,8(sp)
    80001e48:	6105                	addi	sp,sp,32
    80001e4a:	8082                	ret

0000000080001e4c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001e4c:	1141                	addi	sp,sp,-16
    80001e4e:	e406                	sd	ra,8(sp)
    80001e50:	e022                	sd	s0,0(sp)
    80001e52:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001e54:	00000097          	auipc	ra,0x0
    80001e58:	fc0080e7          	jalr	-64(ra) # 80001e14 <myproc>
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	f68080e7          	jalr	-152(ra) # 80000dc4 <release>

  if (first) {
    80001e64:	0000b797          	auipc	a5,0xb
    80001e68:	9fc7a783          	lw	a5,-1540(a5) # 8000c860 <first.1>
    80001e6c:	eb89                	bnez	a5,80001e7e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001e6e:	00001097          	auipc	ra,0x1
    80001e72:	146080e7          	jalr	326(ra) # 80002fb4 <usertrapret>
}
    80001e76:	60a2                	ld	ra,8(sp)
    80001e78:	6402                	ld	s0,0(sp)
    80001e7a:	0141                	addi	sp,sp,16
    80001e7c:	8082                	ret
    first = 0;
    80001e7e:	0000b797          	auipc	a5,0xb
    80001e82:	9e07a123          	sw	zero,-1566(a5) # 8000c860 <first.1>
    fsinit(ROOTDEV);
    80001e86:	4505                	li	a0,1
    80001e88:	00002097          	auipc	ra,0x2
    80001e8c:	450080e7          	jalr	1104(ra) # 800042d8 <fsinit>
    80001e90:	bff9                	j	80001e6e <forkret+0x22>

0000000080001e92 <allocpid>:
{
    80001e92:	1101                	addi	sp,sp,-32
    80001e94:	ec06                	sd	ra,24(sp)
    80001e96:	e822                	sd	s0,16(sp)
    80001e98:	e426                	sd	s1,8(sp)
    80001e9a:	e04a                	sd	s2,0(sp)
    80001e9c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001e9e:	00053917          	auipc	s2,0x53
    80001ea2:	d5290913          	addi	s2,s2,-686 # 80054bf0 <pid_lock>
    80001ea6:	854a                	mv	a0,s2
    80001ea8:	fffff097          	auipc	ra,0xfffff
    80001eac:	e68080e7          	jalr	-408(ra) # 80000d10 <acquire>
  pid = nextpid;
    80001eb0:	0000b797          	auipc	a5,0xb
    80001eb4:	9b478793          	addi	a5,a5,-1612 # 8000c864 <nextpid>
    80001eb8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001eba:	0014871b          	addiw	a4,s1,1
    80001ebe:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001ec0:	854a                	mv	a0,s2
    80001ec2:	fffff097          	auipc	ra,0xfffff
    80001ec6:	f02080e7          	jalr	-254(ra) # 80000dc4 <release>
}
    80001eca:	8526                	mv	a0,s1
    80001ecc:	60e2                	ld	ra,24(sp)
    80001ece:	6442                	ld	s0,16(sp)
    80001ed0:	64a2                	ld	s1,8(sp)
    80001ed2:	6902                	ld	s2,0(sp)
    80001ed4:	6105                	addi	sp,sp,32
    80001ed6:	8082                	ret

0000000080001ed8 <proc_pagetable>:
{
    80001ed8:	1101                	addi	sp,sp,-32
    80001eda:	ec06                	sd	ra,24(sp)
    80001edc:	e822                	sd	s0,16(sp)
    80001ede:	e426                	sd	s1,8(sp)
    80001ee0:	e04a                	sd	s2,0(sp)
    80001ee2:	1000                	addi	s0,sp,32
    80001ee4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ee6:	fffff097          	auipc	ra,0xfffff
    80001eea:	5b2080e7          	jalr	1458(ra) # 80001498 <uvmcreate>
    80001eee:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001ef0:	c121                	beqz	a0,80001f30 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ef2:	4729                	li	a4,10
    80001ef4:	00008697          	auipc	a3,0x8
    80001ef8:	10c68693          	addi	a3,a3,268 # 8000a000 <_trampoline>
    80001efc:	6605                	lui	a2,0x1
    80001efe:	040005b7          	lui	a1,0x4000
    80001f02:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f04:	05b2                	slli	a1,a1,0xc
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	2e2080e7          	jalr	738(ra) # 800011e8 <mappages>
    80001f0e:	02054863          	bltz	a0,80001f3e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001f12:	4719                	li	a4,6
    80001f14:	05893683          	ld	a3,88(s2)
    80001f18:	6605                	lui	a2,0x1
    80001f1a:	020005b7          	lui	a1,0x2000
    80001f1e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001f20:	05b6                	slli	a1,a1,0xd
    80001f22:	8526                	mv	a0,s1
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	2c4080e7          	jalr	708(ra) # 800011e8 <mappages>
    80001f2c:	02054163          	bltz	a0,80001f4e <proc_pagetable+0x76>
}
    80001f30:	8526                	mv	a0,s1
    80001f32:	60e2                	ld	ra,24(sp)
    80001f34:	6442                	ld	s0,16(sp)
    80001f36:	64a2                	ld	s1,8(sp)
    80001f38:	6902                	ld	s2,0(sp)
    80001f3a:	6105                	addi	sp,sp,32
    80001f3c:	8082                	ret
    uvmfree(pagetable, 0);
    80001f3e:	4581                	li	a1,0
    80001f40:	8526                	mv	a0,s1
    80001f42:	00000097          	auipc	ra,0x0
    80001f46:	966080e7          	jalr	-1690(ra) # 800018a8 <uvmfree>
    return 0;
    80001f4a:	4481                	li	s1,0
    80001f4c:	b7d5                	j	80001f30 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f4e:	4681                	li	a3,0
    80001f50:	4605                	li	a2,1
    80001f52:	040005b7          	lui	a1,0x4000
    80001f56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f58:	05b2                	slli	a1,a1,0xc
    80001f5a:	8526                	mv	a0,s1
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	468080e7          	jalr	1128(ra) # 800013c4 <uvmunmap>
    uvmfree(pagetable, 0);
    80001f64:	4581                	li	a1,0
    80001f66:	8526                	mv	a0,s1
    80001f68:	00000097          	auipc	ra,0x0
    80001f6c:	940080e7          	jalr	-1728(ra) # 800018a8 <uvmfree>
    return 0;
    80001f70:	4481                	li	s1,0
    80001f72:	bf7d                	j	80001f30 <proc_pagetable+0x58>

0000000080001f74 <proc_freepagetable>:
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	e04a                	sd	s2,0(sp)
    80001f7e:	1000                	addi	s0,sp,32
    80001f80:	84aa                	mv	s1,a0
    80001f82:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f84:	4681                	li	a3,0
    80001f86:	4605                	li	a2,1
    80001f88:	040005b7          	lui	a1,0x4000
    80001f8c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f8e:	05b2                	slli	a1,a1,0xc
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	434080e7          	jalr	1076(ra) # 800013c4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001f98:	4681                	li	a3,0
    80001f9a:	4605                	li	a2,1
    80001f9c:	020005b7          	lui	a1,0x2000
    80001fa0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001fa2:	05b6                	slli	a1,a1,0xd
    80001fa4:	8526                	mv	a0,s1
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	41e080e7          	jalr	1054(ra) # 800013c4 <uvmunmap>
  uvmfree(pagetable, sz);
    80001fae:	85ca                	mv	a1,s2
    80001fb0:	8526                	mv	a0,s1
    80001fb2:	00000097          	auipc	ra,0x0
    80001fb6:	8f6080e7          	jalr	-1802(ra) # 800018a8 <uvmfree>
}
    80001fba:	60e2                	ld	ra,24(sp)
    80001fbc:	6442                	ld	s0,16(sp)
    80001fbe:	64a2                	ld	s1,8(sp)
    80001fc0:	6902                	ld	s2,0(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret

0000000080001fc6 <freeproc>:
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	1000                	addi	s0,sp,32
    80001fd0:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001fd2:	6d28                	ld	a0,88(a0)
    80001fd4:	c509                	beqz	a0,80001fde <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	ac4080e7          	jalr	-1340(ra) # 80000a9a <kfree>
  p->trapframe = 0;
    80001fde:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001fe2:	68a8                	ld	a0,80(s1)
    80001fe4:	c511                	beqz	a0,80001ff0 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001fe6:	64ac                	ld	a1,72(s1)
    80001fe8:	00000097          	auipc	ra,0x0
    80001fec:	f8c080e7          	jalr	-116(ra) # 80001f74 <proc_freepagetable>
  p->pagetable = 0;
    80001ff0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ff4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001ff8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ffc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80002000:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80002004:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002008:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000200c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80002010:	0004ac23          	sw	zero,24(s1)
}
    80002014:	60e2                	ld	ra,24(sp)
    80002016:	6442                	ld	s0,16(sp)
    80002018:	64a2                	ld	s1,8(sp)
    8000201a:	6105                	addi	sp,sp,32
    8000201c:	8082                	ret

000000008000201e <allocproc>:
{
    8000201e:	1101                	addi	sp,sp,-32
    80002020:	ec06                	sd	ra,24(sp)
    80002022:	e822                	sd	s0,16(sp)
    80002024:	e426                	sd	s1,8(sp)
    80002026:	e04a                	sd	s2,0(sp)
    80002028:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000202a:	00053497          	auipc	s1,0x53
    8000202e:	ff648493          	addi	s1,s1,-10 # 80055020 <proc>
    80002032:	00061917          	auipc	s2,0x61
    80002036:	bee90913          	addi	s2,s2,-1042 # 80062c20 <tickslock>
    acquire(&p->lock);
    8000203a:	8526                	mv	a0,s1
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	cd4080e7          	jalr	-812(ra) # 80000d10 <acquire>
    if(p->state == UNUSED) {
    80002044:	4c9c                	lw	a5,24(s1)
    80002046:	cf81                	beqz	a5,8000205e <allocproc+0x40>
      release(&p->lock);
    80002048:	8526                	mv	a0,s1
    8000204a:	fffff097          	auipc	ra,0xfffff
    8000204e:	d7a080e7          	jalr	-646(ra) # 80000dc4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002052:	37048493          	addi	s1,s1,880
    80002056:	ff2492e3          	bne	s1,s2,8000203a <allocproc+0x1c>
  return 0;
    8000205a:	4481                	li	s1,0
    8000205c:	a095                	j	800020c0 <allocproc+0xa2>
  p->pid = allocpid();
    8000205e:	00000097          	auipc	ra,0x0
    80002062:	e34080e7          	jalr	-460(ra) # 80001e92 <allocpid>
    80002066:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002068:	4785                	li	a5,1
    8000206a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	b96080e7          	jalr	-1130(ra) # 80000c02 <kalloc>
    80002074:	892a                	mv	s2,a0
    80002076:	eca8                	sd	a0,88(s1)
    80002078:	c939                	beqz	a0,800020ce <allocproc+0xb0>
  p->pagetable = proc_pagetable(p);
    8000207a:	8526                	mv	a0,s1
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	e5c080e7          	jalr	-420(ra) # 80001ed8 <proc_pagetable>
    80002084:	892a                	mv	s2,a0
    80002086:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80002088:	cd39                	beqz	a0,800020e6 <allocproc+0xc8>
  memset(&p->context, 0, sizeof(p->context));
    8000208a:	07000613          	li	a2,112
    8000208e:	4581                	li	a1,0
    80002090:	06048513          	addi	a0,s1,96
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	d78080e7          	jalr	-648(ra) # 80000e0c <memset>
  p->context.ra = (uint64)forkret;
    8000209c:	00000797          	auipc	a5,0x0
    800020a0:	db078793          	addi	a5,a5,-592 # 80001e4c <forkret>
    800020a4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800020a6:	60bc                	ld	a5,64(s1)
    800020a8:	6705                	lui	a4,0x1
    800020aa:	97ba                	add	a5,a5,a4
    800020ac:	f4bc                	sd	a5,104(s1)
  memset(p->infant_threads, 0, MAX_THREADS);
    800020ae:	04000613          	li	a2,64
    800020b2:	4581                	li	a1,0
    800020b4:	17048513          	addi	a0,s1,368
    800020b8:	fffff097          	auipc	ra,0xfffff
    800020bc:	d54080e7          	jalr	-684(ra) # 80000e0c <memset>
}
    800020c0:	8526                	mv	a0,s1
    800020c2:	60e2                	ld	ra,24(sp)
    800020c4:	6442                	ld	s0,16(sp)
    800020c6:	64a2                	ld	s1,8(sp)
    800020c8:	6902                	ld	s2,0(sp)
    800020ca:	6105                	addi	sp,sp,32
    800020cc:	8082                	ret
    freeproc(p);
    800020ce:	8526                	mv	a0,s1
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	ef6080e7          	jalr	-266(ra) # 80001fc6 <freeproc>
    release(&p->lock);
    800020d8:	8526                	mv	a0,s1
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	cea080e7          	jalr	-790(ra) # 80000dc4 <release>
    return 0;
    800020e2:	84ca                	mv	s1,s2
    800020e4:	bff1                	j	800020c0 <allocproc+0xa2>
    freeproc(p);
    800020e6:	8526                	mv	a0,s1
    800020e8:	00000097          	auipc	ra,0x0
    800020ec:	ede080e7          	jalr	-290(ra) # 80001fc6 <freeproc>
    release(&p->lock);
    800020f0:	8526                	mv	a0,s1
    800020f2:	fffff097          	auipc	ra,0xfffff
    800020f6:	cd2080e7          	jalr	-814(ra) # 80000dc4 <release>
    return 0;
    800020fa:	84ca                	mv	s1,s2
    800020fc:	b7d1                	j	800020c0 <allocproc+0xa2>

00000000800020fe <userinit>:
{
    800020fe:	1101                	addi	sp,sp,-32
    80002100:	ec06                	sd	ra,24(sp)
    80002102:	e822                	sd	s0,16(sp)
    80002104:	e426                	sd	s1,8(sp)
    80002106:	1000                	addi	s0,sp,32
  p = allocproc();
    80002108:	00000097          	auipc	ra,0x0
    8000210c:	f16080e7          	jalr	-234(ra) # 8000201e <allocproc>
    80002110:	84aa                	mv	s1,a0
  initproc = p;
    80002112:	0000b797          	auipc	a5,0xb
    80002116:	84a7b323          	sd	a0,-1978(a5) # 8000c958 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000211a:	03400613          	li	a2,52
    8000211e:	0000a597          	auipc	a1,0xa
    80002122:	75258593          	addi	a1,a1,1874 # 8000c870 <initcode>
    80002126:	6928                	ld	a0,80(a0)
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	39e080e7          	jalr	926(ra) # 800014c6 <uvmfirst>
  p->sz = PGSIZE;
    80002130:	6785                	lui	a5,0x1
    80002132:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80002134:	6cb8                	ld	a4,88(s1)
    80002136:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000213a:	6cb8                	ld	a4,88(s1)
    8000213c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000213e:	4641                	li	a2,16
    80002140:	00009597          	auipc	a1,0x9
    80002144:	0f058593          	addi	a1,a1,240 # 8000b230 <etext+0x230>
    80002148:	15848513          	addi	a0,s1,344
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	e02080e7          	jalr	-510(ra) # 80000f4e <safestrcpy>
  p->cwd = namei("/");
    80002154:	00009517          	auipc	a0,0x9
    80002158:	0ec50513          	addi	a0,a0,236 # 8000b240 <etext+0x240>
    8000215c:	00003097          	auipc	ra,0x3
    80002160:	bce080e7          	jalr	-1074(ra) # 80004d2a <namei>
    80002164:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80002168:	478d                	li	a5,3
    8000216a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000216c:	8526                	mv	a0,s1
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	c56080e7          	jalr	-938(ra) # 80000dc4 <release>
}
    80002176:	60e2                	ld	ra,24(sp)
    80002178:	6442                	ld	s0,16(sp)
    8000217a:	64a2                	ld	s1,8(sp)
    8000217c:	6105                	addi	sp,sp,32
    8000217e:	8082                	ret

0000000080002180 <growproc>:
{
    80002180:	1101                	addi	sp,sp,-32
    80002182:	ec06                	sd	ra,24(sp)
    80002184:	e822                	sd	s0,16(sp)
    80002186:	e426                	sd	s1,8(sp)
    80002188:	e04a                	sd	s2,0(sp)
    8000218a:	1000                	addi	s0,sp,32
    8000218c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000218e:	00000097          	auipc	ra,0x0
    80002192:	c86080e7          	jalr	-890(ra) # 80001e14 <myproc>
    80002196:	84aa                	mv	s1,a0
  sz = p->sz;
    80002198:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000219a:	05205463          	blez	s2,800021e2 <growproc+0x62>
    if (p->is_thread == 1) {
    8000219e:	16852703          	lw	a4,360(a0)
    800021a2:	4785                	li	a5,1
    800021a4:	02f70463          	beq	a4,a5,800021cc <growproc+0x4c>
    } else if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800021a8:	4691                	li	a3,4
    800021aa:	00b90633          	add	a2,s2,a1
    800021ae:	6928                	ld	a0,80(a0)
    800021b0:	fffff097          	auipc	ra,0xfffff
    800021b4:	3d0080e7          	jalr	976(ra) # 80001580 <uvmalloc>
    800021b8:	85aa                	mv	a1,a0
    800021ba:	cd21                	beqz	a0,80002212 <growproc+0x92>
  p->sz = sz;
    800021bc:	e4ac                	sd	a1,72(s1)
  return 0;
    800021be:	4501                	li	a0,0
}
    800021c0:	60e2                	ld	ra,24(sp)
    800021c2:	6442                	ld	s0,16(sp)
    800021c4:	64a2                	ld	s1,8(sp)
    800021c6:	6902                	ld	s2,0(sp)
    800021c8:	6105                	addi	sp,sp,32
    800021ca:	8082                	ret
      if ((sz = uvmthreaded_alloc(p, sz, sz + n, PTE_W)) == 0) {
    800021cc:	4691                	li	a3,4
    800021ce:	00b90633          	add	a2,s2,a1
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	46c080e7          	jalr	1132(ra) # 8000163e <uvmthreaded_alloc>
    800021da:	85aa                	mv	a1,a0
    800021dc:	f165                	bnez	a0,800021bc <growproc+0x3c>
        return -1;
    800021de:	557d                	li	a0,-1
    800021e0:	b7c5                	j	800021c0 <growproc+0x40>
  } else if(n < 0){
    800021e2:	fc095de3          	bgez	s2,800021bc <growproc+0x3c>
    if (p->is_thread == 1)
    800021e6:	16852703          	lw	a4,360(a0)
    800021ea:	4785                	li	a5,1
    800021ec:	00f70b63          	beq	a4,a5,80002202 <growproc+0x82>
      sz = uvmdealloc(p->pagetable, sz, sz + n);
    800021f0:	00b90633          	add	a2,s2,a1
    800021f4:	6928                	ld	a0,80(a0)
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	342080e7          	jalr	834(ra) # 80001538 <uvmdealloc>
    800021fe:	85aa                	mv	a1,a0
    80002200:	bf75                	j	800021bc <growproc+0x3c>
      sz = uvmthreaded_dealloc(p, sz, sz + n);
    80002202:	00b90633          	add	a2,s2,a1
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	590080e7          	jalr	1424(ra) # 80001796 <uvmthreaded_dealloc>
    8000220e:	85aa                	mv	a1,a0
    80002210:	b775                	j	800021bc <growproc+0x3c>
      return -1;
    80002212:	557d                	li	a0,-1
    80002214:	b775                	j	800021c0 <growproc+0x40>

0000000080002216 <fork>:
{
    80002216:	7139                	addi	sp,sp,-64
    80002218:	fc06                	sd	ra,56(sp)
    8000221a:	f822                	sd	s0,48(sp)
    8000221c:	f04a                	sd	s2,32(sp)
    8000221e:	e456                	sd	s5,8(sp)
    80002220:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002222:	00000097          	auipc	ra,0x0
    80002226:	bf2080e7          	jalr	-1038(ra) # 80001e14 <myproc>
    8000222a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000222c:	00000097          	auipc	ra,0x0
    80002230:	df2080e7          	jalr	-526(ra) # 8000201e <allocproc>
    80002234:	12050263          	beqz	a0,80002358 <fork+0x142>
    80002238:	ec4e                	sd	s3,24(sp)
    8000223a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000223c:	048ab603          	ld	a2,72(s5)
    80002240:	692c                	ld	a1,80(a0)
    80002242:	050ab503          	ld	a0,80(s5)
    80002246:	fffff097          	auipc	ra,0xfffff
    8000224a:	69c080e7          	jalr	1692(ra) # 800018e2 <uvmcopy>
    8000224e:	04054a63          	bltz	a0,800022a2 <fork+0x8c>
    80002252:	f426                	sd	s1,40(sp)
    80002254:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80002256:	048ab783          	ld	a5,72(s5)
    8000225a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000225e:	058ab683          	ld	a3,88(s5)
    80002262:	87b6                	mv	a5,a3
    80002264:	0589b703          	ld	a4,88(s3)
    80002268:	12068693          	addi	a3,a3,288
    8000226c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002270:	6788                	ld	a0,8(a5)
    80002272:	6b8c                	ld	a1,16(a5)
    80002274:	6f90                	ld	a2,24(a5)
    80002276:	01073023          	sd	a6,0(a4)
    8000227a:	e708                	sd	a0,8(a4)
    8000227c:	eb0c                	sd	a1,16(a4)
    8000227e:	ef10                	sd	a2,24(a4)
    80002280:	02078793          	addi	a5,a5,32
    80002284:	02070713          	addi	a4,a4,32
    80002288:	fed792e3          	bne	a5,a3,8000226c <fork+0x56>
  np->trapframe->a0 = 0;
    8000228c:	0589b783          	ld	a5,88(s3)
    80002290:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002294:	0d0a8493          	addi	s1,s5,208
    80002298:	0d098913          	addi	s2,s3,208
    8000229c:	150a8a13          	addi	s4,s5,336
    800022a0:	a015                	j	800022c4 <fork+0xae>
    freeproc(np);
    800022a2:	854e                	mv	a0,s3
    800022a4:	00000097          	auipc	ra,0x0
    800022a8:	d22080e7          	jalr	-734(ra) # 80001fc6 <freeproc>
    release(&np->lock);
    800022ac:	854e                	mv	a0,s3
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	b16080e7          	jalr	-1258(ra) # 80000dc4 <release>
    return -1;
    800022b6:	597d                	li	s2,-1
    800022b8:	69e2                	ld	s3,24(sp)
    800022ba:	a841                	j	8000234a <fork+0x134>
  for(i = 0; i < NOFILE; i++)
    800022bc:	04a1                	addi	s1,s1,8
    800022be:	0921                	addi	s2,s2,8
    800022c0:	01448b63          	beq	s1,s4,800022d6 <fork+0xc0>
    if(p->ofile[i])
    800022c4:	6088                	ld	a0,0(s1)
    800022c6:	d97d                	beqz	a0,800022bc <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800022c8:	00003097          	auipc	ra,0x3
    800022cc:	0da080e7          	jalr	218(ra) # 800053a2 <filedup>
    800022d0:	00a93023          	sd	a0,0(s2)
    800022d4:	b7e5                	j	800022bc <fork+0xa6>
  np->cwd = idup(p->cwd);
    800022d6:	150ab503          	ld	a0,336(s5)
    800022da:	00002097          	auipc	ra,0x2
    800022de:	244080e7          	jalr	580(ra) # 8000451e <idup>
    800022e2:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800022e6:	4641                	li	a2,16
    800022e8:	158a8593          	addi	a1,s5,344
    800022ec:	15898513          	addi	a0,s3,344
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	c5e080e7          	jalr	-930(ra) # 80000f4e <safestrcpy>
  pid = np->pid;
    800022f8:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800022fc:	854e                	mv	a0,s3
    800022fe:	fffff097          	auipc	ra,0xfffff
    80002302:	ac6080e7          	jalr	-1338(ra) # 80000dc4 <release>
  acquire(&wait_lock);
    80002306:	00053497          	auipc	s1,0x53
    8000230a:	90248493          	addi	s1,s1,-1790 # 80054c08 <wait_lock>
    8000230e:	8526                	mv	a0,s1
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	a00080e7          	jalr	-1536(ra) # 80000d10 <acquire>
  np->parent = p;
    80002318:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000231c:	8526                	mv	a0,s1
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	aa6080e7          	jalr	-1370(ra) # 80000dc4 <release>
  acquire(&np->lock);
    80002326:	854e                	mv	a0,s3
    80002328:	fffff097          	auipc	ra,0xfffff
    8000232c:	9e8080e7          	jalr	-1560(ra) # 80000d10 <acquire>
  np->state = RUNNABLE;
    80002330:	478d                	li	a5,3
    80002332:	00f9ac23          	sw	a5,24(s3)
  np->is_thread = 0;
    80002336:	1609a423          	sw	zero,360(s3)
  release(&np->lock);
    8000233a:	854e                	mv	a0,s3
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	a88080e7          	jalr	-1400(ra) # 80000dc4 <release>
  return pid;
    80002344:	74a2                	ld	s1,40(sp)
    80002346:	69e2                	ld	s3,24(sp)
    80002348:	6a42                	ld	s4,16(sp)
}
    8000234a:	854a                	mv	a0,s2
    8000234c:	70e2                	ld	ra,56(sp)
    8000234e:	7442                	ld	s0,48(sp)
    80002350:	7902                	ld	s2,32(sp)
    80002352:	6aa2                	ld	s5,8(sp)
    80002354:	6121                	addi	sp,sp,64
    80002356:	8082                	ret
    return -1;
    80002358:	597d                	li	s2,-1
    8000235a:	bfc5                	j	8000234a <fork+0x134>

000000008000235c <create_thread>:
int create_thread(void* (*fn_addr)(void *), void *args, void *stack_addr, void (*exit_fn)(uint64)) {
    8000235c:	715d                	addi	sp,sp,-80
    8000235e:	e486                	sd	ra,72(sp)
    80002360:	e0a2                	sd	s0,64(sp)
    80002362:	fc26                	sd	s1,56(sp)
    80002364:	f84a                	sd	s2,48(sp)
    80002366:	f44e                	sd	s3,40(sp)
    80002368:	f052                	sd	s4,32(sp)
    8000236a:	ec56                	sd	s5,24(sp)
    8000236c:	e85a                	sd	s6,16(sp)
    8000236e:	e45e                	sd	s7,8(sp)
    80002370:	0880                	addi	s0,sp,80
    80002372:	8baa                	mv	s7,a0
    80002374:	8b2e                	mv	s6,a1
    80002376:	84b2                	mv	s1,a2
    80002378:	89b6                	mv	s3,a3
  struct proc *p = myproc();
    8000237a:	00000097          	auipc	ra,0x0
    8000237e:	a9a080e7          	jalr	-1382(ra) # 80001e14 <myproc>
    80002382:	8aaa                	mv	s5,a0
  for (int i = 0; i < MAX_THREADS; i++) {
    80002384:	17050713          	addi	a4,a0,368
    80002388:	4781                	li	a5,0
    8000238a:	04000693          	li	a3,64
    if (p->infant_threads[i] == 0) {
    8000238e:	00073803          	ld	a6,0(a4)
    80002392:	00080863          	beqz	a6,800023a2 <create_thread+0x46>
  for (int i = 0; i < MAX_THREADS; i++) {
    80002396:	2785                	addiw	a5,a5,1
    80002398:	0721                	addi	a4,a4,8
    8000239a:	fed79ae3          	bne	a5,a3,8000238e <create_thread+0x32>
  uint64 thread_idx = 0;
    8000239e:	4901                	li	s2,0
    800023a0:	a011                	j	800023a4 <create_thread+0x48>
      thread_idx = i;
    800023a2:	893e                	mv	s2,a5
  if((np = allocproc()) == 0){
    800023a4:	00000097          	auipc	ra,0x0
    800023a8:	c7a080e7          	jalr	-902(ra) # 8000201e <allocproc>
    800023ac:	8a2a                	mv	s4,a0
    800023ae:	cd3d                	beqz	a0,8000242c <create_thread+0xd0>
  if(uvmshare(p->pagetable, np->pagetable, p->sz) < 0){
    800023b0:	048ab603          	ld	a2,72(s5)
    800023b4:	692c                	ld	a1,80(a0)
    800023b6:	050ab503          	ld	a0,80(s5)
    800023ba:	fffff097          	auipc	ra,0xfffff
    800023be:	5fa080e7          	jalr	1530(ra) # 800019b4 <uvmshare>
    800023c2:	06054f63          	bltz	a0,80002440 <create_thread+0xe4>
  np->sz = p->sz;
    800023c6:	048ab783          	ld	a5,72(s5)
    800023ca:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800023ce:	058ab683          	ld	a3,88(s5)
    800023d2:	87b6                	mv	a5,a3
    800023d4:	058a3703          	ld	a4,88(s4)
    800023d8:	12068693          	addi	a3,a3,288
    800023dc:	0007b803          	ld	a6,0(a5)
    800023e0:	6788                	ld	a0,8(a5)
    800023e2:	6b8c                	ld	a1,16(a5)
    800023e4:	6f90                	ld	a2,24(a5)
    800023e6:	01073023          	sd	a6,0(a4)
    800023ea:	e708                	sd	a0,8(a4)
    800023ec:	eb0c                	sd	a1,16(a4)
    800023ee:	ef10                	sd	a2,24(a4)
    800023f0:	02078793          	addi	a5,a5,32
    800023f4:	02070713          	addi	a4,a4,32
    800023f8:	fed792e3          	bne	a5,a3,800023dc <create_thread+0x80>
  np->trapframe->sp = (uint64)stack_addr + PGSIZE;
    800023fc:	058a3783          	ld	a5,88(s4)
    80002400:	6705                	lui	a4,0x1
    80002402:	94ba                	add	s1,s1,a4
    80002404:	fb84                	sd	s1,48(a5)
  np->trapframe->epc = (uint64)fn_addr;
    80002406:	058a3783          	ld	a5,88(s4)
    8000240a:	0177bc23          	sd	s7,24(a5)
  np->trapframe->a0 = (uint64)args;
    8000240e:	058a3783          	ld	a5,88(s4)
    80002412:	0767b823          	sd	s6,112(a5)
  np->trapframe->ra = (uint64)exit_fn;
    80002416:	058a3783          	ld	a5,88(s4)
    8000241a:	0337b423          	sd	s3,40(a5)
  for(i = 0; i < NOFILE; i++)
    8000241e:	0d0a8493          	addi	s1,s5,208
    80002422:	0d0a0993          	addi	s3,s4,208
    80002426:	150a8b13          	addi	s6,s5,336
    8000242a:	a089                	j	8000246c <create_thread+0x110>
    printf("Max processes reached\n");
    8000242c:	00009517          	auipc	a0,0x9
    80002430:	e1c50513          	addi	a0,a0,-484 # 8000b248 <etext+0x248>
    80002434:	ffffe097          	auipc	ra,0xffffe
    80002438:	176080e7          	jalr	374(ra) # 800005aa <printf>
    return -1;
    8000243c:	557d                	li	a0,-1
    8000243e:	a85d                	j	800024f4 <create_thread+0x198>
    freeproc(np);
    80002440:	8552                	mv	a0,s4
    80002442:	00000097          	auipc	ra,0x0
    80002446:	b84080e7          	jalr	-1148(ra) # 80001fc6 <freeproc>
    release(&np->lock);
    8000244a:	8552                	mv	a0,s4
    8000244c:	fffff097          	auipc	ra,0xfffff
    80002450:	978080e7          	jalr	-1672(ra) # 80000dc4 <release>
    return -1;
    80002454:	557d                	li	a0,-1
    80002456:	a879                	j	800024f4 <create_thread+0x198>
      np->ofile[i] = filedup(p->ofile[i]);
    80002458:	00003097          	auipc	ra,0x3
    8000245c:	f4a080e7          	jalr	-182(ra) # 800053a2 <filedup>
    80002460:	00a9b023          	sd	a0,0(s3)
  for(i = 0; i < NOFILE; i++)
    80002464:	04a1                	addi	s1,s1,8
    80002466:	09a1                	addi	s3,s3,8
    80002468:	01648563          	beq	s1,s6,80002472 <create_thread+0x116>
    if(p->ofile[i])
    8000246c:	6088                	ld	a0,0(s1)
    8000246e:	f56d                	bnez	a0,80002458 <create_thread+0xfc>
    80002470:	bfd5                	j	80002464 <create_thread+0x108>
  np->cwd = idup(p->cwd);
    80002472:	150ab503          	ld	a0,336(s5)
    80002476:	00002097          	auipc	ra,0x2
    8000247a:	0a8080e7          	jalr	168(ra) # 8000451e <idup>
    8000247e:	14aa3823          	sd	a0,336(s4)
  release(&np->lock);
    80002482:	8552                	mv	a0,s4
    80002484:	fffff097          	auipc	ra,0xfffff
    80002488:	940080e7          	jalr	-1728(ra) # 80000dc4 <release>
  acquire(&wait_lock);
    8000248c:	00052517          	auipc	a0,0x52
    80002490:	77c50513          	addi	a0,a0,1916 # 80054c08 <wait_lock>
    80002494:	fffff097          	auipc	ra,0xfffff
    80002498:	87c080e7          	jalr	-1924(ra) # 80000d10 <acquire>
  if (p->is_thread) {
    8000249c:	168aa783          	lw	a5,360(s5)
    800024a0:	c7ad                	beqz	a5,8000250a <create_thread+0x1ae>
    np->parent = p->parent->parent;
    800024a2:	038ab783          	ld	a5,56(s5)
    800024a6:	7f9c                	ld	a5,56(a5)
    800024a8:	02fa3c23          	sd	a5,56(s4)
    p = p->parent->parent;
    800024ac:	038ab783          	ld	a5,56(s5)
    800024b0:	0387ba83          	ld	s5,56(a5)
  release(&wait_lock);
    800024b4:	00052517          	auipc	a0,0x52
    800024b8:	75450513          	addi	a0,a0,1876 # 80054c08 <wait_lock>
    800024bc:	fffff097          	auipc	ra,0xfffff
    800024c0:	908080e7          	jalr	-1784(ra) # 80000dc4 <release>
  acquire(&np->lock);
    800024c4:	8552                	mv	a0,s4
    800024c6:	fffff097          	auipc	ra,0xfffff
    800024ca:	84a080e7          	jalr	-1974(ra) # 80000d10 <acquire>
  np->is_thread = 1;
    800024ce:	4785                	li	a5,1
    800024d0:	16fa2423          	sw	a5,360(s4)
  np->state = RUNNABLE;
    800024d4:	478d                	li	a5,3
    800024d6:	00fa2c23          	sw	a5,24(s4)
  p->infant_threads[thread_idx] = np;
    800024da:	02e90793          	addi	a5,s2,46
    800024de:	078e                	slli	a5,a5,0x3
    800024e0:	9abe                	add	s5,s5,a5
    800024e2:	014ab023          	sd	s4,0(s5)
  release(&np->lock);
    800024e6:	8552                	mv	a0,s4
    800024e8:	fffff097          	auipc	ra,0xfffff
    800024ec:	8dc080e7          	jalr	-1828(ra) # 80000dc4 <release>
  return np->pid;
    800024f0:	030a2503          	lw	a0,48(s4)
}
    800024f4:	60a6                	ld	ra,72(sp)
    800024f6:	6406                	ld	s0,64(sp)
    800024f8:	74e2                	ld	s1,56(sp)
    800024fa:	7942                	ld	s2,48(sp)
    800024fc:	79a2                	ld	s3,40(sp)
    800024fe:	7a02                	ld	s4,32(sp)
    80002500:	6ae2                	ld	s5,24(sp)
    80002502:	6b42                	ld	s6,16(sp)
    80002504:	6ba2                	ld	s7,8(sp)
    80002506:	6161                	addi	sp,sp,80
    80002508:	8082                	ret
    np->parent = p;
    8000250a:	035a3c23          	sd	s5,56(s4)
    8000250e:	b75d                	j	800024b4 <create_thread+0x158>

0000000080002510 <scheduler>:
{
    80002510:	7139                	addi	sp,sp,-64
    80002512:	fc06                	sd	ra,56(sp)
    80002514:	f822                	sd	s0,48(sp)
    80002516:	f426                	sd	s1,40(sp)
    80002518:	f04a                	sd	s2,32(sp)
    8000251a:	ec4e                	sd	s3,24(sp)
    8000251c:	e852                	sd	s4,16(sp)
    8000251e:	e456                	sd	s5,8(sp)
    80002520:	e05a                	sd	s6,0(sp)
    80002522:	0080                	addi	s0,sp,64
    80002524:	8792                	mv	a5,tp
  int id = r_tp();
    80002526:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002528:	00779a93          	slli	s5,a5,0x7
    8000252c:	00052717          	auipc	a4,0x52
    80002530:	6c470713          	addi	a4,a4,1732 # 80054bf0 <pid_lock>
    80002534:	9756                	add	a4,a4,s5
    80002536:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000253a:	00052717          	auipc	a4,0x52
    8000253e:	6ee70713          	addi	a4,a4,1774 # 80054c28 <cpus+0x8>
    80002542:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80002544:	498d                	li	s3,3
        p->state = RUNNING;
    80002546:	4b11                	li	s6,4
        c->proc = p;
    80002548:	079e                	slli	a5,a5,0x7
    8000254a:	00052a17          	auipc	s4,0x52
    8000254e:	6a6a0a13          	addi	s4,s4,1702 # 80054bf0 <pid_lock>
    80002552:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002554:	00060917          	auipc	s2,0x60
    80002558:	6cc90913          	addi	s2,s2,1740 # 80062c20 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000255c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002560:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002564:	10079073          	csrw	sstatus,a5
    80002568:	00053497          	auipc	s1,0x53
    8000256c:	ab848493          	addi	s1,s1,-1352 # 80055020 <proc>
    80002570:	a811                	j	80002584 <scheduler+0x74>
      release(&p->lock);
    80002572:	8526                	mv	a0,s1
    80002574:	fffff097          	auipc	ra,0xfffff
    80002578:	850080e7          	jalr	-1968(ra) # 80000dc4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000257c:	37048493          	addi	s1,s1,880
    80002580:	fd248ee3          	beq	s1,s2,8000255c <scheduler+0x4c>
      acquire(&p->lock);
    80002584:	8526                	mv	a0,s1
    80002586:	ffffe097          	auipc	ra,0xffffe
    8000258a:	78a080e7          	jalr	1930(ra) # 80000d10 <acquire>
      if(p->state == RUNNABLE) {
    8000258e:	4c9c                	lw	a5,24(s1)
    80002590:	ff3791e3          	bne	a5,s3,80002572 <scheduler+0x62>
        p->state = RUNNING;
    80002594:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002598:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000259c:	06048593          	addi	a1,s1,96
    800025a0:	8556                	mv	a0,s5
    800025a2:	00001097          	auipc	ra,0x1
    800025a6:	968080e7          	jalr	-1688(ra) # 80002f0a <swtch>
        c->proc = 0;
    800025aa:	020a3823          	sd	zero,48(s4)
    800025ae:	b7d1                	j	80002572 <scheduler+0x62>

00000000800025b0 <sched>:
{
    800025b0:	7179                	addi	sp,sp,-48
    800025b2:	f406                	sd	ra,40(sp)
    800025b4:	f022                	sd	s0,32(sp)
    800025b6:	ec26                	sd	s1,24(sp)
    800025b8:	e84a                	sd	s2,16(sp)
    800025ba:	e44e                	sd	s3,8(sp)
    800025bc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800025be:	00000097          	auipc	ra,0x0
    800025c2:	856080e7          	jalr	-1962(ra) # 80001e14 <myproc>
    800025c6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800025c8:	ffffe097          	auipc	ra,0xffffe
    800025cc:	6ce080e7          	jalr	1742(ra) # 80000c96 <holding>
    800025d0:	c93d                	beqz	a0,80002646 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800025d2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800025d4:	2781                	sext.w	a5,a5
    800025d6:	079e                	slli	a5,a5,0x7
    800025d8:	00052717          	auipc	a4,0x52
    800025dc:	61870713          	addi	a4,a4,1560 # 80054bf0 <pid_lock>
    800025e0:	97ba                	add	a5,a5,a4
    800025e2:	0a87a703          	lw	a4,168(a5)
    800025e6:	4785                	li	a5,1
    800025e8:	06f71763          	bne	a4,a5,80002656 <sched+0xa6>
  if(p->state == RUNNING)
    800025ec:	4c98                	lw	a4,24(s1)
    800025ee:	4791                	li	a5,4
    800025f0:	06f70b63          	beq	a4,a5,80002666 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025f4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800025f8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800025fa:	efb5                	bnez	a5,80002676 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800025fc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800025fe:	00052917          	auipc	s2,0x52
    80002602:	5f290913          	addi	s2,s2,1522 # 80054bf0 <pid_lock>
    80002606:	2781                	sext.w	a5,a5
    80002608:	079e                	slli	a5,a5,0x7
    8000260a:	97ca                	add	a5,a5,s2
    8000260c:	0ac7a983          	lw	s3,172(a5)
    80002610:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002612:	2781                	sext.w	a5,a5
    80002614:	079e                	slli	a5,a5,0x7
    80002616:	00052597          	auipc	a1,0x52
    8000261a:	61258593          	addi	a1,a1,1554 # 80054c28 <cpus+0x8>
    8000261e:	95be                	add	a1,a1,a5
    80002620:	06048513          	addi	a0,s1,96
    80002624:	00001097          	auipc	ra,0x1
    80002628:	8e6080e7          	jalr	-1818(ra) # 80002f0a <swtch>
    8000262c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000262e:	2781                	sext.w	a5,a5
    80002630:	079e                	slli	a5,a5,0x7
    80002632:	993e                	add	s2,s2,a5
    80002634:	0b392623          	sw	s3,172(s2)
}
    80002638:	70a2                	ld	ra,40(sp)
    8000263a:	7402                	ld	s0,32(sp)
    8000263c:	64e2                	ld	s1,24(sp)
    8000263e:	6942                	ld	s2,16(sp)
    80002640:	69a2                	ld	s3,8(sp)
    80002642:	6145                	addi	sp,sp,48
    80002644:	8082                	ret
    panic("sched p->lock");
    80002646:	00009517          	auipc	a0,0x9
    8000264a:	c1a50513          	addi	a0,a0,-998 # 8000b260 <etext+0x260>
    8000264e:	ffffe097          	auipc	ra,0xffffe
    80002652:	f12080e7          	jalr	-238(ra) # 80000560 <panic>
    panic("sched locks");
    80002656:	00009517          	auipc	a0,0x9
    8000265a:	c1a50513          	addi	a0,a0,-998 # 8000b270 <etext+0x270>
    8000265e:	ffffe097          	auipc	ra,0xffffe
    80002662:	f02080e7          	jalr	-254(ra) # 80000560 <panic>
    panic("sched running");
    80002666:	00009517          	auipc	a0,0x9
    8000266a:	c1a50513          	addi	a0,a0,-998 # 8000b280 <etext+0x280>
    8000266e:	ffffe097          	auipc	ra,0xffffe
    80002672:	ef2080e7          	jalr	-270(ra) # 80000560 <panic>
    panic("sched interruptible");
    80002676:	00009517          	auipc	a0,0x9
    8000267a:	c1a50513          	addi	a0,a0,-998 # 8000b290 <etext+0x290>
    8000267e:	ffffe097          	auipc	ra,0xffffe
    80002682:	ee2080e7          	jalr	-286(ra) # 80000560 <panic>

0000000080002686 <yield>:
{
    80002686:	1101                	addi	sp,sp,-32
    80002688:	ec06                	sd	ra,24(sp)
    8000268a:	e822                	sd	s0,16(sp)
    8000268c:	e426                	sd	s1,8(sp)
    8000268e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002690:	fffff097          	auipc	ra,0xfffff
    80002694:	784080e7          	jalr	1924(ra) # 80001e14 <myproc>
    80002698:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000269a:	ffffe097          	auipc	ra,0xffffe
    8000269e:	676080e7          	jalr	1654(ra) # 80000d10 <acquire>
  p->state = RUNNABLE;
    800026a2:	478d                	li	a5,3
    800026a4:	cc9c                	sw	a5,24(s1)
  sched();
    800026a6:	00000097          	auipc	ra,0x0
    800026aa:	f0a080e7          	jalr	-246(ra) # 800025b0 <sched>
  release(&p->lock);
    800026ae:	8526                	mv	a0,s1
    800026b0:	ffffe097          	auipc	ra,0xffffe
    800026b4:	714080e7          	jalr	1812(ra) # 80000dc4 <release>
}
    800026b8:	60e2                	ld	ra,24(sp)
    800026ba:	6442                	ld	s0,16(sp)
    800026bc:	64a2                	ld	s1,8(sp)
    800026be:	6105                	addi	sp,sp,32
    800026c0:	8082                	ret

00000000800026c2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800026c2:	7179                	addi	sp,sp,-48
    800026c4:	f406                	sd	ra,40(sp)
    800026c6:	f022                	sd	s0,32(sp)
    800026c8:	ec26                	sd	s1,24(sp)
    800026ca:	e84a                	sd	s2,16(sp)
    800026cc:	e44e                	sd	s3,8(sp)
    800026ce:	1800                	addi	s0,sp,48
    800026d0:	89aa                	mv	s3,a0
    800026d2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800026d4:	fffff097          	auipc	ra,0xfffff
    800026d8:	740080e7          	jalr	1856(ra) # 80001e14 <myproc>
    800026dc:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800026de:	ffffe097          	auipc	ra,0xffffe
    800026e2:	632080e7          	jalr	1586(ra) # 80000d10 <acquire>
  release(lk);
    800026e6:	854a                	mv	a0,s2
    800026e8:	ffffe097          	auipc	ra,0xffffe
    800026ec:	6dc080e7          	jalr	1756(ra) # 80000dc4 <release>

  // Go to sleep.
  p->chan = chan;
    800026f0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800026f4:	4789                	li	a5,2
    800026f6:	cc9c                	sw	a5,24(s1)

  sched();
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	eb8080e7          	jalr	-328(ra) # 800025b0 <sched>

  // Tidy up.
  p->chan = 0;
    80002700:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002704:	8526                	mv	a0,s1
    80002706:	ffffe097          	auipc	ra,0xffffe
    8000270a:	6be080e7          	jalr	1726(ra) # 80000dc4 <release>
  acquire(lk);
    8000270e:	854a                	mv	a0,s2
    80002710:	ffffe097          	auipc	ra,0xffffe
    80002714:	600080e7          	jalr	1536(ra) # 80000d10 <acquire>
}
    80002718:	70a2                	ld	ra,40(sp)
    8000271a:	7402                	ld	s0,32(sp)
    8000271c:	64e2                	ld	s1,24(sp)
    8000271e:	6942                	ld	s2,16(sp)
    80002720:	69a2                	ld	s3,8(sp)
    80002722:	6145                	addi	sp,sp,48
    80002724:	8082                	ret

0000000080002726 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002726:	7139                	addi	sp,sp,-64
    80002728:	fc06                	sd	ra,56(sp)
    8000272a:	f822                	sd	s0,48(sp)
    8000272c:	f426                	sd	s1,40(sp)
    8000272e:	f04a                	sd	s2,32(sp)
    80002730:	ec4e                	sd	s3,24(sp)
    80002732:	e852                	sd	s4,16(sp)
    80002734:	e456                	sd	s5,8(sp)
    80002736:	0080                	addi	s0,sp,64
    80002738:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000273a:	00053497          	auipc	s1,0x53
    8000273e:	8e648493          	addi	s1,s1,-1818 # 80055020 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002742:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002744:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002746:	00060917          	auipc	s2,0x60
    8000274a:	4da90913          	addi	s2,s2,1242 # 80062c20 <tickslock>
    8000274e:	a811                	j	80002762 <wakeup+0x3c>
      }
      release(&p->lock);
    80002750:	8526                	mv	a0,s1
    80002752:	ffffe097          	auipc	ra,0xffffe
    80002756:	672080e7          	jalr	1650(ra) # 80000dc4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000275a:	37048493          	addi	s1,s1,880
    8000275e:	03248663          	beq	s1,s2,8000278a <wakeup+0x64>
    if(p != myproc()){
    80002762:	fffff097          	auipc	ra,0xfffff
    80002766:	6b2080e7          	jalr	1714(ra) # 80001e14 <myproc>
    8000276a:	fea488e3          	beq	s1,a0,8000275a <wakeup+0x34>
      acquire(&p->lock);
    8000276e:	8526                	mv	a0,s1
    80002770:	ffffe097          	auipc	ra,0xffffe
    80002774:	5a0080e7          	jalr	1440(ra) # 80000d10 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002778:	4c9c                	lw	a5,24(s1)
    8000277a:	fd379be3          	bne	a5,s3,80002750 <wakeup+0x2a>
    8000277e:	709c                	ld	a5,32(s1)
    80002780:	fd4798e3          	bne	a5,s4,80002750 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002784:	0154ac23          	sw	s5,24(s1)
    80002788:	b7e1                	j	80002750 <wakeup+0x2a>
    }
  }
}
    8000278a:	70e2                	ld	ra,56(sp)
    8000278c:	7442                	ld	s0,48(sp)
    8000278e:	74a2                	ld	s1,40(sp)
    80002790:	7902                	ld	s2,32(sp)
    80002792:	69e2                	ld	s3,24(sp)
    80002794:	6a42                	ld	s4,16(sp)
    80002796:	6aa2                	ld	s5,8(sp)
    80002798:	6121                	addi	sp,sp,64
    8000279a:	8082                	ret

000000008000279c <reparent>:
{
    8000279c:	7179                	addi	sp,sp,-48
    8000279e:	f406                	sd	ra,40(sp)
    800027a0:	f022                	sd	s0,32(sp)
    800027a2:	ec26                	sd	s1,24(sp)
    800027a4:	e84a                	sd	s2,16(sp)
    800027a6:	e44e                	sd	s3,8(sp)
    800027a8:	e052                	sd	s4,0(sp)
    800027aa:	1800                	addi	s0,sp,48
    800027ac:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800027ae:	00053497          	auipc	s1,0x53
    800027b2:	87248493          	addi	s1,s1,-1934 # 80055020 <proc>
      pp->parent = initproc;
    800027b6:	0000aa17          	auipc	s4,0xa
    800027ba:	1a2a0a13          	addi	s4,s4,418 # 8000c958 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800027be:	00060997          	auipc	s3,0x60
    800027c2:	46298993          	addi	s3,s3,1122 # 80062c20 <tickslock>
    800027c6:	a029                	j	800027d0 <reparent+0x34>
    800027c8:	37048493          	addi	s1,s1,880
    800027cc:	01348d63          	beq	s1,s3,800027e6 <reparent+0x4a>
    if(pp->parent == p){
    800027d0:	7c9c                	ld	a5,56(s1)
    800027d2:	ff279be3          	bne	a5,s2,800027c8 <reparent+0x2c>
      pp->parent = initproc;
    800027d6:	000a3503          	ld	a0,0(s4)
    800027da:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800027dc:	00000097          	auipc	ra,0x0
    800027e0:	f4a080e7          	jalr	-182(ra) # 80002726 <wakeup>
    800027e4:	b7d5                	j	800027c8 <reparent+0x2c>
}
    800027e6:	70a2                	ld	ra,40(sp)
    800027e8:	7402                	ld	s0,32(sp)
    800027ea:	64e2                	ld	s1,24(sp)
    800027ec:	6942                	ld	s2,16(sp)
    800027ee:	69a2                	ld	s3,8(sp)
    800027f0:	6a02                	ld	s4,0(sp)
    800027f2:	6145                	addi	sp,sp,48
    800027f4:	8082                	ret

00000000800027f6 <thread_exit>:
uint64 thread_exit(uint64 status) {
    800027f6:	7179                	addi	sp,sp,-48
    800027f8:	f406                	sd	ra,40(sp)
    800027fa:	f022                	sd	s0,32(sp)
    800027fc:	ec26                	sd	s1,24(sp)
    800027fe:	e84a                	sd	s2,16(sp)
    80002800:	e44e                	sd	s3,8(sp)
    80002802:	e052                	sd	s4,0(sp)
    80002804:	1800                	addi	s0,sp,48
    80002806:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002808:	fffff097          	auipc	ra,0xfffff
    8000280c:	60c080e7          	jalr	1548(ra) # 80001e14 <myproc>
    80002810:	89aa                	mv	s3,a0
  if(p == initproc)
    80002812:	0000a797          	auipc	a5,0xa
    80002816:	1467b783          	ld	a5,326(a5) # 8000c958 <initproc>
    8000281a:	0d050493          	addi	s1,a0,208
    8000281e:	15050913          	addi	s2,a0,336
    80002822:	02a79363          	bne	a5,a0,80002848 <thread_exit+0x52>
    panic("init exiting");
    80002826:	00009517          	auipc	a0,0x9
    8000282a:	a8250513          	addi	a0,a0,-1406 # 8000b2a8 <etext+0x2a8>
    8000282e:	ffffe097          	auipc	ra,0xffffe
    80002832:	d32080e7          	jalr	-718(ra) # 80000560 <panic>
      fileclose(f);
    80002836:	00003097          	auipc	ra,0x3
    8000283a:	bbe080e7          	jalr	-1090(ra) # 800053f4 <fileclose>
      p->ofile[fd] = 0;
    8000283e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002842:	04a1                	addi	s1,s1,8
    80002844:	01248563          	beq	s1,s2,8000284e <thread_exit+0x58>
    if(p->ofile[fd]){
    80002848:	6088                	ld	a0,0(s1)
    8000284a:	f575                	bnez	a0,80002836 <thread_exit+0x40>
    8000284c:	bfdd                	j	80002842 <thread_exit+0x4c>
  begin_op();
    8000284e:	00002097          	auipc	ra,0x2
    80002852:	6dc080e7          	jalr	1756(ra) # 80004f2a <begin_op>
  iput(p->cwd);
    80002856:	1509b503          	ld	a0,336(s3)
    8000285a:	00002097          	auipc	ra,0x2
    8000285e:	ec0080e7          	jalr	-320(ra) # 8000471a <iput>
  end_op();
    80002862:	00002097          	auipc	ra,0x2
    80002866:	742080e7          	jalr	1858(ra) # 80004fa4 <end_op>
  p->cwd = 0;
    8000286a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000286e:	00052497          	auipc	s1,0x52
    80002872:	39a48493          	addi	s1,s1,922 # 80054c08 <wait_lock>
    80002876:	8526                	mv	a0,s1
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	498080e7          	jalr	1176(ra) # 80000d10 <acquire>
  reparent(p);
    80002880:	854e                	mv	a0,s3
    80002882:	00000097          	auipc	ra,0x0
    80002886:	f1a080e7          	jalr	-230(ra) # 8000279c <reparent>
  wakeup(p->parent);
    8000288a:	0389b503          	ld	a0,56(s3)
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	e98080e7          	jalr	-360(ra) # 80002726 <wakeup>
  acquire(&p->lock);
    80002896:	854e                	mv	a0,s3
    80002898:	ffffe097          	auipc	ra,0xffffe
    8000289c:	478080e7          	jalr	1144(ra) # 80000d10 <acquire>
  p->xstate = status;
    800028a0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800028a4:	4795                	li	a5,5
    800028a6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800028aa:	8526                	mv	a0,s1
    800028ac:	ffffe097          	auipc	ra,0xffffe
    800028b0:	518080e7          	jalr	1304(ra) # 80000dc4 <release>
  sched();
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	cfc080e7          	jalr	-772(ra) # 800025b0 <sched>
  panic("zombie exit");
    800028bc:	00009517          	auipc	a0,0x9
    800028c0:	9fc50513          	addi	a0,a0,-1540 # 8000b2b8 <etext+0x2b8>
    800028c4:	ffffe097          	auipc	ra,0xffffe
    800028c8:	c9c080e7          	jalr	-868(ra) # 80000560 <panic>

00000000800028cc <exit>:
{
    800028cc:	711d                	addi	sp,sp,-96
    800028ce:	ec86                	sd	ra,88(sp)
    800028d0:	e8a2                	sd	s0,80(sp)
    800028d2:	e4a6                	sd	s1,72(sp)
    800028d4:	e0ca                	sd	s2,64(sp)
    800028d6:	fc4e                	sd	s3,56(sp)
    800028d8:	f852                	sd	s4,48(sp)
    800028da:	f456                	sd	s5,40(sp)
    800028dc:	f05a                	sd	s6,32(sp)
    800028de:	ec5e                	sd	s7,24(sp)
    800028e0:	e862                	sd	s8,16(sp)
    800028e2:	e466                	sd	s9,8(sp)
    800028e4:	1080                	addi	s0,sp,96
    800028e6:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800028e8:	fffff097          	auipc	ra,0xfffff
    800028ec:	52c080e7          	jalr	1324(ra) # 80001e14 <myproc>
    800028f0:	8c2a                	mv	s8,a0
  if (p->is_thread) {
    800028f2:	16852783          	lw	a5,360(a0)
    800028f6:	cfc9                	beqz	a5,80002990 <exit+0xc4>
    struct proc *parent = p->parent;
    800028f8:	03853b03          	ld	s6,56(a0)
    for (int i = 0; i < MAX_THREADS; i++) {
    800028fc:	170b0a13          	addi	s4,s6,368
    80002900:	370b0b13          	addi	s6,s6,880
      acquire(&wait_lock);
    80002904:	00052a97          	auipc	s5,0x52
    80002908:	304a8a93          	addi	s5,s5,772 # 80054c08 <wait_lock>
      infant->state = ZOMBIE;
    8000290c:	4c95                	li	s9,5
    8000290e:	a885                	j	8000297e <exit+0xb2>
          fileclose(f);
    80002910:	00003097          	auipc	ra,0x3
    80002914:	ae4080e7          	jalr	-1308(ra) # 800053f4 <fileclose>
          infant->ofile[fd] = 0;
    80002918:	0004b023          	sd	zero,0(s1)
      for(int fd = 0; fd < NOFILE; fd++){
    8000291c:	04a1                	addi	s1,s1,8
    8000291e:	01248563          	beq	s1,s2,80002928 <exit+0x5c>
        if(infant->ofile[fd]){
    80002922:	6088                	ld	a0,0(s1)
    80002924:	f575                	bnez	a0,80002910 <exit+0x44>
    80002926:	bfdd                	j	8000291c <exit+0x50>
      begin_op();
    80002928:	00002097          	auipc	ra,0x2
    8000292c:	602080e7          	jalr	1538(ra) # 80004f2a <begin_op>
      iput(infant->cwd);
    80002930:	1509b503          	ld	a0,336(s3)
    80002934:	00002097          	auipc	ra,0x2
    80002938:	de6080e7          	jalr	-538(ra) # 8000471a <iput>
      end_op();
    8000293c:	00002097          	auipc	ra,0x2
    80002940:	668080e7          	jalr	1640(ra) # 80004fa4 <end_op>
      infant->cwd = 0;
    80002944:	1409b823          	sd	zero,336(s3)
      acquire(&wait_lock);
    80002948:	8556                	mv	a0,s5
    8000294a:	ffffe097          	auipc	ra,0xffffe
    8000294e:	3c6080e7          	jalr	966(ra) # 80000d10 <acquire>
      acquire(&infant->lock);
    80002952:	854e                	mv	a0,s3
    80002954:	ffffe097          	auipc	ra,0xffffe
    80002958:	3bc080e7          	jalr	956(ra) # 80000d10 <acquire>
      infant->xstate = status;
    8000295c:	0379a623          	sw	s7,44(s3)
      infant->state = ZOMBIE;
    80002960:	0199ac23          	sw	s9,24(s3)
      release(&infant->lock);
    80002964:	854e                	mv	a0,s3
    80002966:	ffffe097          	auipc	ra,0xffffe
    8000296a:	45e080e7          	jalr	1118(ra) # 80000dc4 <release>
      release(&wait_lock);
    8000296e:	8556                	mv	a0,s5
    80002970:	ffffe097          	auipc	ra,0xffffe
    80002974:	454080e7          	jalr	1108(ra) # 80000dc4 <release>
    for (int i = 0; i < MAX_THREADS; i++) {
    80002978:	0a21                	addi	s4,s4,8
    8000297a:	016a0b63          	beq	s4,s6,80002990 <exit+0xc4>
      struct proc *infant = parent->infant_threads[i];
    8000297e:	000a3983          	ld	s3,0(s4)
      if (infant == 0) 
    80002982:	fe098be3          	beqz	s3,80002978 <exit+0xac>
    80002986:	0d098493          	addi	s1,s3,208
    8000298a:	15098913          	addi	s2,s3,336
    8000298e:	bf51                	j	80002922 <exit+0x56>
  if(p == initproc)
    80002990:	0000a797          	auipc	a5,0xa
    80002994:	fc87b783          	ld	a5,-56(a5) # 8000c958 <initproc>
    80002998:	0d0c0493          	addi	s1,s8,208
    8000299c:	150c0913          	addi	s2,s8,336
    800029a0:	01879d63          	bne	a5,s8,800029ba <exit+0xee>
    panic("init exiting");
    800029a4:	00009517          	auipc	a0,0x9
    800029a8:	90450513          	addi	a0,a0,-1788 # 8000b2a8 <etext+0x2a8>
    800029ac:	ffffe097          	auipc	ra,0xffffe
    800029b0:	bb4080e7          	jalr	-1100(ra) # 80000560 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800029b4:	04a1                	addi	s1,s1,8
    800029b6:	01248b63          	beq	s1,s2,800029cc <exit+0x100>
    if(p->ofile[fd]){
    800029ba:	6088                	ld	a0,0(s1)
    800029bc:	dd65                	beqz	a0,800029b4 <exit+0xe8>
      fileclose(f);
    800029be:	00003097          	auipc	ra,0x3
    800029c2:	a36080e7          	jalr	-1482(ra) # 800053f4 <fileclose>
      p->ofile[fd] = 0;
    800029c6:	0004b023          	sd	zero,0(s1)
    800029ca:	b7ed                	j	800029b4 <exit+0xe8>
  begin_op();
    800029cc:	00002097          	auipc	ra,0x2
    800029d0:	55e080e7          	jalr	1374(ra) # 80004f2a <begin_op>
  iput(p->cwd);
    800029d4:	150c3503          	ld	a0,336(s8)
    800029d8:	00002097          	auipc	ra,0x2
    800029dc:	d42080e7          	jalr	-702(ra) # 8000471a <iput>
  end_op();
    800029e0:	00002097          	auipc	ra,0x2
    800029e4:	5c4080e7          	jalr	1476(ra) # 80004fa4 <end_op>
  p->cwd = 0;
    800029e8:	140c3823          	sd	zero,336(s8)
  acquire(&wait_lock);
    800029ec:	00052497          	auipc	s1,0x52
    800029f0:	21c48493          	addi	s1,s1,540 # 80054c08 <wait_lock>
    800029f4:	8526                	mv	a0,s1
    800029f6:	ffffe097          	auipc	ra,0xffffe
    800029fa:	31a080e7          	jalr	794(ra) # 80000d10 <acquire>
  reparent(p);
    800029fe:	8562                	mv	a0,s8
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	d9c080e7          	jalr	-612(ra) # 8000279c <reparent>
  wakeup(p->parent);
    80002a08:	038c3503          	ld	a0,56(s8)
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	d1a080e7          	jalr	-742(ra) # 80002726 <wakeup>
  acquire(&p->lock);
    80002a14:	8562                	mv	a0,s8
    80002a16:	ffffe097          	auipc	ra,0xffffe
    80002a1a:	2fa080e7          	jalr	762(ra) # 80000d10 <acquire>
  p->xstate = status;
    80002a1e:	037c2623          	sw	s7,44(s8)
  p->state = ZOMBIE;
    80002a22:	4795                	li	a5,5
    80002a24:	00fc2c23          	sw	a5,24(s8)
  release(&wait_lock);
    80002a28:	8526                	mv	a0,s1
    80002a2a:	ffffe097          	auipc	ra,0xffffe
    80002a2e:	39a080e7          	jalr	922(ra) # 80000dc4 <release>
  sched();
    80002a32:	00000097          	auipc	ra,0x0
    80002a36:	b7e080e7          	jalr	-1154(ra) # 800025b0 <sched>
  panic("zombie exit");
    80002a3a:	00009517          	auipc	a0,0x9
    80002a3e:	87e50513          	addi	a0,a0,-1922 # 8000b2b8 <etext+0x2b8>
    80002a42:	ffffe097          	auipc	ra,0xffffe
    80002a46:	b1e080e7          	jalr	-1250(ra) # 80000560 <panic>

0000000080002a4a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002a4a:	7179                	addi	sp,sp,-48
    80002a4c:	f406                	sd	ra,40(sp)
    80002a4e:	f022                	sd	s0,32(sp)
    80002a50:	ec26                	sd	s1,24(sp)
    80002a52:	e84a                	sd	s2,16(sp)
    80002a54:	e44e                	sd	s3,8(sp)
    80002a56:	1800                	addi	s0,sp,48
    80002a58:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002a5a:	00052497          	auipc	s1,0x52
    80002a5e:	5c648493          	addi	s1,s1,1478 # 80055020 <proc>
    80002a62:	00060997          	auipc	s3,0x60
    80002a66:	1be98993          	addi	s3,s3,446 # 80062c20 <tickslock>
    acquire(&p->lock);
    80002a6a:	8526                	mv	a0,s1
    80002a6c:	ffffe097          	auipc	ra,0xffffe
    80002a70:	2a4080e7          	jalr	676(ra) # 80000d10 <acquire>
    if(p->pid == pid){
    80002a74:	589c                	lw	a5,48(s1)
    80002a76:	01278d63          	beq	a5,s2,80002a90 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002a7a:	8526                	mv	a0,s1
    80002a7c:	ffffe097          	auipc	ra,0xffffe
    80002a80:	348080e7          	jalr	840(ra) # 80000dc4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002a84:	37048493          	addi	s1,s1,880
    80002a88:	ff3491e3          	bne	s1,s3,80002a6a <kill+0x20>
  }
  return -1;
    80002a8c:	557d                	li	a0,-1
    80002a8e:	a829                	j	80002aa8 <kill+0x5e>
      p->killed = 1;
    80002a90:	4785                	li	a5,1
    80002a92:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002a94:	4c98                	lw	a4,24(s1)
    80002a96:	4789                	li	a5,2
    80002a98:	00f70f63          	beq	a4,a5,80002ab6 <kill+0x6c>
      release(&p->lock);
    80002a9c:	8526                	mv	a0,s1
    80002a9e:	ffffe097          	auipc	ra,0xffffe
    80002aa2:	326080e7          	jalr	806(ra) # 80000dc4 <release>
      return 0;
    80002aa6:	4501                	li	a0,0
}
    80002aa8:	70a2                	ld	ra,40(sp)
    80002aaa:	7402                	ld	s0,32(sp)
    80002aac:	64e2                	ld	s1,24(sp)
    80002aae:	6942                	ld	s2,16(sp)
    80002ab0:	69a2                	ld	s3,8(sp)
    80002ab2:	6145                	addi	sp,sp,48
    80002ab4:	8082                	ret
        p->state = RUNNABLE;
    80002ab6:	478d                	li	a5,3
    80002ab8:	cc9c                	sw	a5,24(s1)
    80002aba:	b7cd                	j	80002a9c <kill+0x52>

0000000080002abc <setkilled>:

void
setkilled(struct proc *p)
{
    80002abc:	1101                	addi	sp,sp,-32
    80002abe:	ec06                	sd	ra,24(sp)
    80002ac0:	e822                	sd	s0,16(sp)
    80002ac2:	e426                	sd	s1,8(sp)
    80002ac4:	1000                	addi	s0,sp,32
    80002ac6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002ac8:	ffffe097          	auipc	ra,0xffffe
    80002acc:	248080e7          	jalr	584(ra) # 80000d10 <acquire>
  p->killed = 1;
    80002ad0:	4785                	li	a5,1
    80002ad2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002ad4:	8526                	mv	a0,s1
    80002ad6:	ffffe097          	auipc	ra,0xffffe
    80002ada:	2ee080e7          	jalr	750(ra) # 80000dc4 <release>
}
    80002ade:	60e2                	ld	ra,24(sp)
    80002ae0:	6442                	ld	s0,16(sp)
    80002ae2:	64a2                	ld	s1,8(sp)
    80002ae4:	6105                	addi	sp,sp,32
    80002ae6:	8082                	ret

0000000080002ae8 <killed>:

int
killed(struct proc *p)
{
    80002ae8:	1101                	addi	sp,sp,-32
    80002aea:	ec06                	sd	ra,24(sp)
    80002aec:	e822                	sd	s0,16(sp)
    80002aee:	e426                	sd	s1,8(sp)
    80002af0:	e04a                	sd	s2,0(sp)
    80002af2:	1000                	addi	s0,sp,32
    80002af4:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002af6:	ffffe097          	auipc	ra,0xffffe
    80002afa:	21a080e7          	jalr	538(ra) # 80000d10 <acquire>
  k = p->killed;
    80002afe:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002b02:	8526                	mv	a0,s1
    80002b04:	ffffe097          	auipc	ra,0xffffe
    80002b08:	2c0080e7          	jalr	704(ra) # 80000dc4 <release>
  return k;
}
    80002b0c:	854a                	mv	a0,s2
    80002b0e:	60e2                	ld	ra,24(sp)
    80002b10:	6442                	ld	s0,16(sp)
    80002b12:	64a2                	ld	s1,8(sp)
    80002b14:	6902                	ld	s2,0(sp)
    80002b16:	6105                	addi	sp,sp,32
    80002b18:	8082                	ret

0000000080002b1a <join_thread>:
uint64 join_thread(uint64 thread_id, uint64 status_addr) {
    80002b1a:	715d                	addi	sp,sp,-80
    80002b1c:	e486                	sd	ra,72(sp)
    80002b1e:	e0a2                	sd	s0,64(sp)
    80002b20:	fc26                	sd	s1,56(sp)
    80002b22:	f84a                	sd	s2,48(sp)
    80002b24:	f44e                	sd	s3,40(sp)
    80002b26:	f052                	sd	s4,32(sp)
    80002b28:	e85a                	sd	s6,16(sp)
    80002b2a:	0880                	addi	s0,sp,80
    80002b2c:	8a2a                	mv	s4,a0
    80002b2e:	8b2e                	mv	s6,a1
  struct proc *p = myproc();
    80002b30:	fffff097          	auipc	ra,0xfffff
    80002b34:	2e4080e7          	jalr	740(ra) # 80001e14 <myproc>
    80002b38:	89aa                	mv	s3,a0
  if (p->is_thread) 
    80002b3a:	16852783          	lw	a5,360(a0)
    80002b3e:	c399                	beqz	a5,80002b44 <join_thread+0x2a>
    p = p->parent;
    80002b40:	03853983          	ld	s3,56(a0)
  acquire(&wait_lock);
    80002b44:	00052517          	auipc	a0,0x52
    80002b48:	0c450513          	addi	a0,a0,196 # 80054c08 <wait_lock>
    80002b4c:	ffffe097          	auipc	ra,0xffffe
    80002b50:	1c4080e7          	jalr	452(ra) # 80000d10 <acquire>
  for (thread_idx = 0; thread_idx < MAX_THREADS; thread_idx++) {
    80002b54:	17098793          	addi	a5,s3,368
    80002b58:	4901                	li	s2,0
    80002b5a:	04000693          	li	a3,64
    80002b5e:	a029                	j	80002b68 <join_thread+0x4e>
    80002b60:	2905                	addiw	s2,s2,1
    80002b62:	07a1                	addi	a5,a5,8
    80002b64:	0ed90263          	beq	s2,a3,80002c48 <join_thread+0x12e>
    if (p->infant_threads[thread_idx] && thread_id == p->infant_threads[thread_idx]->pid) {
    80002b68:	6384                	ld	s1,0(a5)
    80002b6a:	d8fd                	beqz	s1,80002b60 <join_thread+0x46>
    80002b6c:	5898                	lw	a4,48(s1)
    80002b6e:	ff4719e3          	bne	a4,s4,80002b60 <join_thread+0x46>
    80002b72:	ec56                	sd	s5,24(sp)
    80002b74:	e45e                	sd	s7,8(sp)
    if (child->state == ZOMBIE) {
    80002b76:	4a95                	li	s5,5
    sleep(p, &wait_lock);
    80002b78:	00052b97          	auipc	s7,0x52
    80002b7c:	090b8b93          	addi	s7,s7,144 # 80054c08 <wait_lock>
    acquire(&child->lock);
    80002b80:	8526                	mv	a0,s1
    80002b82:	ffffe097          	auipc	ra,0xffffe
    80002b86:	18e080e7          	jalr	398(ra) # 80000d10 <acquire>
    if (child->state == ZOMBIE) {
    80002b8a:	4c9c                	lw	a5,24(s1)
    80002b8c:	03578463          	beq	a5,s5,80002bb4 <join_thread+0x9a>
    release(&child->lock);
    80002b90:	8526                	mv	a0,s1
    80002b92:	ffffe097          	auipc	ra,0xffffe
    80002b96:	232080e7          	jalr	562(ra) # 80000dc4 <release>
    if (killed(p)) {
    80002b9a:	854e                	mv	a0,s3
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	f4c080e7          	jalr	-180(ra) # 80002ae8 <killed>
    80002ba4:	ed35                	bnez	a0,80002c20 <join_thread+0x106>
    sleep(p, &wait_lock);
    80002ba6:	85de                	mv	a1,s7
    80002ba8:	854e                	mv	a0,s3
    80002baa:	00000097          	auipc	ra,0x0
    80002bae:	b18080e7          	jalr	-1256(ra) # 800026c2 <sleep>
    acquire(&child->lock);
    80002bb2:	b7f9                	j	80002b80 <join_thread+0x66>
      if (status_addr != 0 && copyout(p->pagetable, status_addr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
    80002bb4:	000b0e63          	beqz	s6,80002bd0 <join_thread+0xb6>
    80002bb8:	4691                	li	a3,4
    80002bba:	02c48613          	addi	a2,s1,44
    80002bbe:	85da                	mv	a1,s6
    80002bc0:	0509b503          	ld	a0,80(s3)
    80002bc4:	fffff097          	auipc	ra,0xfffff
    80002bc8:	ee8080e7          	jalr	-280(ra) # 80001aac <copyout>
    80002bcc:	02054963          	bltz	a0,80002bfe <join_thread+0xe4>
      release(&child->lock);
    80002bd0:	8526                	mv	a0,s1
    80002bd2:	ffffe097          	auipc	ra,0xffffe
    80002bd6:	1f2080e7          	jalr	498(ra) # 80000dc4 <release>
      release(&wait_lock);
    80002bda:	00052517          	auipc	a0,0x52
    80002bde:	02e50513          	addi	a0,a0,46 # 80054c08 <wait_lock>
    80002be2:	ffffe097          	auipc	ra,0xffffe
    80002be6:	1e2080e7          	jalr	482(ra) # 80000dc4 <release>
      p->infant_threads[thread_idx] = 0;
    80002bea:	02e90913          	addi	s2,s2,46
    80002bee:	090e                	slli	s2,s2,0x3
    80002bf0:	99ca                	add	s3,s3,s2
    80002bf2:	0009b023          	sd	zero,0(s3)
      return thread_id;
    80002bf6:	8552                	mv	a0,s4
    80002bf8:	6ae2                	ld	s5,24(sp)
    80002bfa:	6ba2                	ld	s7,8(sp)
    80002bfc:	a82d                	j	80002c36 <join_thread+0x11c>
        release(&child->lock);
    80002bfe:	8526                	mv	a0,s1
    80002c00:	ffffe097          	auipc	ra,0xffffe
    80002c04:	1c4080e7          	jalr	452(ra) # 80000dc4 <release>
        release(&wait_lock);
    80002c08:	00052517          	auipc	a0,0x52
    80002c0c:	00050513          	mv	a0,a0
    80002c10:	ffffe097          	auipc	ra,0xffffe
    80002c14:	1b4080e7          	jalr	436(ra) # 80000dc4 <release>
        return -1;
    80002c18:	557d                	li	a0,-1
    80002c1a:	6ae2                	ld	s5,24(sp)
    80002c1c:	6ba2                	ld	s7,8(sp)
    80002c1e:	a821                	j	80002c36 <join_thread+0x11c>
      release(&wait_lock);
    80002c20:	00052517          	auipc	a0,0x52
    80002c24:	fe850513          	addi	a0,a0,-24 # 80054c08 <wait_lock>
    80002c28:	ffffe097          	auipc	ra,0xffffe
    80002c2c:	19c080e7          	jalr	412(ra) # 80000dc4 <release>
      return -1;
    80002c30:	557d                	li	a0,-1
    80002c32:	6ae2                	ld	s5,24(sp)
    80002c34:	6ba2                	ld	s7,8(sp)
}
    80002c36:	60a6                	ld	ra,72(sp)
    80002c38:	6406                	ld	s0,64(sp)
    80002c3a:	74e2                	ld	s1,56(sp)
    80002c3c:	7942                	ld	s2,48(sp)
    80002c3e:	79a2                	ld	s3,40(sp)
    80002c40:	7a02                	ld	s4,32(sp)
    80002c42:	6b42                	ld	s6,16(sp)
    80002c44:	6161                	addi	sp,sp,80
    80002c46:	8082                	ret
    release(&wait_lock);
    80002c48:	00052517          	auipc	a0,0x52
    80002c4c:	fc050513          	addi	a0,a0,-64 # 80054c08 <wait_lock>
    80002c50:	ffffe097          	auipc	ra,0xffffe
    80002c54:	174080e7          	jalr	372(ra) # 80000dc4 <release>
    return -1;
    80002c58:	557d                	li	a0,-1
    80002c5a:	bff1                	j	80002c36 <join_thread+0x11c>

0000000080002c5c <wait>:
{
    80002c5c:	715d                	addi	sp,sp,-80
    80002c5e:	e486                	sd	ra,72(sp)
    80002c60:	e0a2                	sd	s0,64(sp)
    80002c62:	fc26                	sd	s1,56(sp)
    80002c64:	f84a                	sd	s2,48(sp)
    80002c66:	f44e                	sd	s3,40(sp)
    80002c68:	f052                	sd	s4,32(sp)
    80002c6a:	ec56                	sd	s5,24(sp)
    80002c6c:	e85a                	sd	s6,16(sp)
    80002c6e:	e45e                	sd	s7,8(sp)
    80002c70:	e062                	sd	s8,0(sp)
    80002c72:	0880                	addi	s0,sp,80
    80002c74:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002c76:	fffff097          	auipc	ra,0xfffff
    80002c7a:	19e080e7          	jalr	414(ra) # 80001e14 <myproc>
    80002c7e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002c80:	00052517          	auipc	a0,0x52
    80002c84:	f8850513          	addi	a0,a0,-120 # 80054c08 <wait_lock>
    80002c88:	ffffe097          	auipc	ra,0xffffe
    80002c8c:	088080e7          	jalr	136(ra) # 80000d10 <acquire>
    havekids = 0;
    80002c90:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002c92:	4a15                	li	s4,5
        havekids = 1;
    80002c94:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002c96:	00060997          	auipc	s3,0x60
    80002c9a:	f8a98993          	addi	s3,s3,-118 # 80062c20 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002c9e:	00052c17          	auipc	s8,0x52
    80002ca2:	f6ac0c13          	addi	s8,s8,-150 # 80054c08 <wait_lock>
    80002ca6:	a0d1                	j	80002d6a <wait+0x10e>
          pid = pp->pid;
    80002ca8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002cac:	000b0e63          	beqz	s6,80002cc8 <wait+0x6c>
    80002cb0:	4691                	li	a3,4
    80002cb2:	02c48613          	addi	a2,s1,44
    80002cb6:	85da                	mv	a1,s6
    80002cb8:	05093503          	ld	a0,80(s2)
    80002cbc:	fffff097          	auipc	ra,0xfffff
    80002cc0:	df0080e7          	jalr	-528(ra) # 80001aac <copyout>
    80002cc4:	04054163          	bltz	a0,80002d06 <wait+0xaa>
          freeproc(pp);
    80002cc8:	8526                	mv	a0,s1
    80002cca:	fffff097          	auipc	ra,0xfffff
    80002cce:	2fc080e7          	jalr	764(ra) # 80001fc6 <freeproc>
          release(&pp->lock);
    80002cd2:	8526                	mv	a0,s1
    80002cd4:	ffffe097          	auipc	ra,0xffffe
    80002cd8:	0f0080e7          	jalr	240(ra) # 80000dc4 <release>
          release(&wait_lock);
    80002cdc:	00052517          	auipc	a0,0x52
    80002ce0:	f2c50513          	addi	a0,a0,-212 # 80054c08 <wait_lock>
    80002ce4:	ffffe097          	auipc	ra,0xffffe
    80002ce8:	0e0080e7          	jalr	224(ra) # 80000dc4 <release>
}
    80002cec:	854e                	mv	a0,s3
    80002cee:	60a6                	ld	ra,72(sp)
    80002cf0:	6406                	ld	s0,64(sp)
    80002cf2:	74e2                	ld	s1,56(sp)
    80002cf4:	7942                	ld	s2,48(sp)
    80002cf6:	79a2                	ld	s3,40(sp)
    80002cf8:	7a02                	ld	s4,32(sp)
    80002cfa:	6ae2                	ld	s5,24(sp)
    80002cfc:	6b42                	ld	s6,16(sp)
    80002cfe:	6ba2                	ld	s7,8(sp)
    80002d00:	6c02                	ld	s8,0(sp)
    80002d02:	6161                	addi	sp,sp,80
    80002d04:	8082                	ret
            release(&pp->lock);
    80002d06:	8526                	mv	a0,s1
    80002d08:	ffffe097          	auipc	ra,0xffffe
    80002d0c:	0bc080e7          	jalr	188(ra) # 80000dc4 <release>
            release(&wait_lock);
    80002d10:	00052517          	auipc	a0,0x52
    80002d14:	ef850513          	addi	a0,a0,-264 # 80054c08 <wait_lock>
    80002d18:	ffffe097          	auipc	ra,0xffffe
    80002d1c:	0ac080e7          	jalr	172(ra) # 80000dc4 <release>
            return -1;
    80002d20:	59fd                	li	s3,-1
    80002d22:	b7e9                	j	80002cec <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002d24:	37048493          	addi	s1,s1,880
    80002d28:	03348463          	beq	s1,s3,80002d50 <wait+0xf4>
      if(pp->parent == p){
    80002d2c:	7c9c                	ld	a5,56(s1)
    80002d2e:	ff279be3          	bne	a5,s2,80002d24 <wait+0xc8>
        acquire(&pp->lock);
    80002d32:	8526                	mv	a0,s1
    80002d34:	ffffe097          	auipc	ra,0xffffe
    80002d38:	fdc080e7          	jalr	-36(ra) # 80000d10 <acquire>
        if(pp->state == ZOMBIE){
    80002d3c:	4c9c                	lw	a5,24(s1)
    80002d3e:	f74785e3          	beq	a5,s4,80002ca8 <wait+0x4c>
        release(&pp->lock);
    80002d42:	8526                	mv	a0,s1
    80002d44:	ffffe097          	auipc	ra,0xffffe
    80002d48:	080080e7          	jalr	128(ra) # 80000dc4 <release>
        havekids = 1;
    80002d4c:	8756                	mv	a4,s5
    80002d4e:	bfd9                	j	80002d24 <wait+0xc8>
    if(!havekids || killed(p)){
    80002d50:	c31d                	beqz	a4,80002d76 <wait+0x11a>
    80002d52:	854a                	mv	a0,s2
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	d94080e7          	jalr	-620(ra) # 80002ae8 <killed>
    80002d5c:	ed09                	bnez	a0,80002d76 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002d5e:	85e2                	mv	a1,s8
    80002d60:	854a                	mv	a0,s2
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	960080e7          	jalr	-1696(ra) # 800026c2 <sleep>
    havekids = 0;
    80002d6a:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002d6c:	00052497          	auipc	s1,0x52
    80002d70:	2b448493          	addi	s1,s1,692 # 80055020 <proc>
    80002d74:	bf65                	j	80002d2c <wait+0xd0>
      release(&wait_lock);
    80002d76:	00052517          	auipc	a0,0x52
    80002d7a:	e9250513          	addi	a0,a0,-366 # 80054c08 <wait_lock>
    80002d7e:	ffffe097          	auipc	ra,0xffffe
    80002d82:	046080e7          	jalr	70(ra) # 80000dc4 <release>
      return -1;
    80002d86:	59fd                	li	s3,-1
    80002d88:	b795                	j	80002cec <wait+0x90>

0000000080002d8a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002d8a:	7179                	addi	sp,sp,-48
    80002d8c:	f406                	sd	ra,40(sp)
    80002d8e:	f022                	sd	s0,32(sp)
    80002d90:	ec26                	sd	s1,24(sp)
    80002d92:	e84a                	sd	s2,16(sp)
    80002d94:	e44e                	sd	s3,8(sp)
    80002d96:	e052                	sd	s4,0(sp)
    80002d98:	1800                	addi	s0,sp,48
    80002d9a:	84aa                	mv	s1,a0
    80002d9c:	892e                	mv	s2,a1
    80002d9e:	89b2                	mv	s3,a2
    80002da0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002da2:	fffff097          	auipc	ra,0xfffff
    80002da6:	072080e7          	jalr	114(ra) # 80001e14 <myproc>
  if(user_dst){
    80002daa:	c08d                	beqz	s1,80002dcc <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002dac:	86d2                	mv	a3,s4
    80002dae:	864e                	mv	a2,s3
    80002db0:	85ca                	mv	a1,s2
    80002db2:	6928                	ld	a0,80(a0)
    80002db4:	fffff097          	auipc	ra,0xfffff
    80002db8:	cf8080e7          	jalr	-776(ra) # 80001aac <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002dbc:	70a2                	ld	ra,40(sp)
    80002dbe:	7402                	ld	s0,32(sp)
    80002dc0:	64e2                	ld	s1,24(sp)
    80002dc2:	6942                	ld	s2,16(sp)
    80002dc4:	69a2                	ld	s3,8(sp)
    80002dc6:	6a02                	ld	s4,0(sp)
    80002dc8:	6145                	addi	sp,sp,48
    80002dca:	8082                	ret
    memmove((char *)dst, src, len);
    80002dcc:	000a061b          	sext.w	a2,s4
    80002dd0:	85ce                	mv	a1,s3
    80002dd2:	854a                	mv	a0,s2
    80002dd4:	ffffe097          	auipc	ra,0xffffe
    80002dd8:	094080e7          	jalr	148(ra) # 80000e68 <memmove>
    return 0;
    80002ddc:	8526                	mv	a0,s1
    80002dde:	bff9                	j	80002dbc <either_copyout+0x32>

0000000080002de0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002de0:	7179                	addi	sp,sp,-48
    80002de2:	f406                	sd	ra,40(sp)
    80002de4:	f022                	sd	s0,32(sp)
    80002de6:	ec26                	sd	s1,24(sp)
    80002de8:	e84a                	sd	s2,16(sp)
    80002dea:	e44e                	sd	s3,8(sp)
    80002dec:	e052                	sd	s4,0(sp)
    80002dee:	1800                	addi	s0,sp,48
    80002df0:	892a                	mv	s2,a0
    80002df2:	84ae                	mv	s1,a1
    80002df4:	89b2                	mv	s3,a2
    80002df6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002df8:	fffff097          	auipc	ra,0xfffff
    80002dfc:	01c080e7          	jalr	28(ra) # 80001e14 <myproc>
  if(user_src){
    80002e00:	c08d                	beqz	s1,80002e22 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002e02:	86d2                	mv	a3,s4
    80002e04:	864e                	mv	a2,s3
    80002e06:	85ca                	mv	a1,s2
    80002e08:	6928                	ld	a0,80(a0)
    80002e0a:	fffff097          	auipc	ra,0xfffff
    80002e0e:	d2e080e7          	jalr	-722(ra) # 80001b38 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002e12:	70a2                	ld	ra,40(sp)
    80002e14:	7402                	ld	s0,32(sp)
    80002e16:	64e2                	ld	s1,24(sp)
    80002e18:	6942                	ld	s2,16(sp)
    80002e1a:	69a2                	ld	s3,8(sp)
    80002e1c:	6a02                	ld	s4,0(sp)
    80002e1e:	6145                	addi	sp,sp,48
    80002e20:	8082                	ret
    memmove(dst, (char*)src, len);
    80002e22:	000a061b          	sext.w	a2,s4
    80002e26:	85ce                	mv	a1,s3
    80002e28:	854a                	mv	a0,s2
    80002e2a:	ffffe097          	auipc	ra,0xffffe
    80002e2e:	03e080e7          	jalr	62(ra) # 80000e68 <memmove>
    return 0;
    80002e32:	8526                	mv	a0,s1
    80002e34:	bff9                	j	80002e12 <either_copyin+0x32>

0000000080002e36 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002e36:	715d                	addi	sp,sp,-80
    80002e38:	e486                	sd	ra,72(sp)
    80002e3a:	e0a2                	sd	s0,64(sp)
    80002e3c:	fc26                	sd	s1,56(sp)
    80002e3e:	f84a                	sd	s2,48(sp)
    80002e40:	f44e                	sd	s3,40(sp)
    80002e42:	f052                	sd	s4,32(sp)
    80002e44:	ec56                	sd	s5,24(sp)
    80002e46:	e85a                	sd	s6,16(sp)
    80002e48:	e45e                	sd	s7,8(sp)
    80002e4a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002e4c:	00008517          	auipc	a0,0x8
    80002e50:	1d450513          	addi	a0,a0,468 # 8000b020 <etext+0x20>
    80002e54:	ffffd097          	auipc	ra,0xffffd
    80002e58:	756080e7          	jalr	1878(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002e5c:	00052497          	auipc	s1,0x52
    80002e60:	31c48493          	addi	s1,s1,796 # 80055178 <proc+0x158>
    80002e64:	00060917          	auipc	s2,0x60
    80002e68:	f1490913          	addi	s2,s2,-236 # 80062d78 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002e6c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002e6e:	00008997          	auipc	s3,0x8
    80002e72:	45a98993          	addi	s3,s3,1114 # 8000b2c8 <etext+0x2c8>
    printf("%d %s %s", p->pid, state, p->name);
    80002e76:	00008a97          	auipc	s5,0x8
    80002e7a:	45aa8a93          	addi	s5,s5,1114 # 8000b2d0 <etext+0x2d0>
    printf("\n");
    80002e7e:	00008a17          	auipc	s4,0x8
    80002e82:	1a2a0a13          	addi	s4,s4,418 # 8000b020 <etext+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002e86:	00009b97          	auipc	s7,0x9
    80002e8a:	072b8b93          	addi	s7,s7,114 # 8000bef8 <states.0>
    80002e8e:	a00d                	j	80002eb0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002e90:	ed86a583          	lw	a1,-296(a3)
    80002e94:	8556                	mv	a0,s5
    80002e96:	ffffd097          	auipc	ra,0xffffd
    80002e9a:	714080e7          	jalr	1812(ra) # 800005aa <printf>
    printf("\n");
    80002e9e:	8552                	mv	a0,s4
    80002ea0:	ffffd097          	auipc	ra,0xffffd
    80002ea4:	70a080e7          	jalr	1802(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002ea8:	37048493          	addi	s1,s1,880
    80002eac:	03248263          	beq	s1,s2,80002ed0 <procdump+0x9a>
    if(p->state == UNUSED)
    80002eb0:	86a6                	mv	a3,s1
    80002eb2:	ec04a783          	lw	a5,-320(s1)
    80002eb6:	dbed                	beqz	a5,80002ea8 <procdump+0x72>
      state = "???";
    80002eb8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002eba:	fcfb6be3          	bltu	s6,a5,80002e90 <procdump+0x5a>
    80002ebe:	02079713          	slli	a4,a5,0x20
    80002ec2:	01d75793          	srli	a5,a4,0x1d
    80002ec6:	97de                	add	a5,a5,s7
    80002ec8:	6390                	ld	a2,0(a5)
    80002eca:	f279                	bnez	a2,80002e90 <procdump+0x5a>
      state = "???";
    80002ecc:	864e                	mv	a2,s3
    80002ece:	b7c9                	j	80002e90 <procdump+0x5a>
  }
}
    80002ed0:	60a6                	ld	ra,72(sp)
    80002ed2:	6406                	ld	s0,64(sp)
    80002ed4:	74e2                	ld	s1,56(sp)
    80002ed6:	7942                	ld	s2,48(sp)
    80002ed8:	79a2                	ld	s3,40(sp)
    80002eda:	7a02                	ld	s4,32(sp)
    80002edc:	6ae2                	ld	s5,24(sp)
    80002ede:	6b42                	ld	s6,16(sp)
    80002ee0:	6ba2                	ld	s7,8(sp)
    80002ee2:	6161                	addi	sp,sp,80
    80002ee4:	8082                	ret

0000000080002ee6 <spoon>:

uint64 spoon(void *arg)
{
    80002ee6:	1141                	addi	sp,sp,-16
    80002ee8:	e406                	sd	ra,8(sp)
    80002eea:	e022                	sd	s0,0(sp)
    80002eec:	0800                	addi	s0,sp,16
    80002eee:	85aa                	mv	a1,a0
  // Add your code here...
  printf("In spoon system call with argument %p\n", arg);
    80002ef0:	00008517          	auipc	a0,0x8
    80002ef4:	3f050513          	addi	a0,a0,1008 # 8000b2e0 <etext+0x2e0>
    80002ef8:	ffffd097          	auipc	ra,0xffffd
    80002efc:	6b2080e7          	jalr	1714(ra) # 800005aa <printf>
  return 0;
}
    80002f00:	4501                	li	a0,0
    80002f02:	60a2                	ld	ra,8(sp)
    80002f04:	6402                	ld	s0,0(sp)
    80002f06:	0141                	addi	sp,sp,16
    80002f08:	8082                	ret

0000000080002f0a <swtch>:
    80002f0a:	00153023          	sd	ra,0(a0)
    80002f0e:	00253423          	sd	sp,8(a0)
    80002f12:	e900                	sd	s0,16(a0)
    80002f14:	ed04                	sd	s1,24(a0)
    80002f16:	03253023          	sd	s2,32(a0)
    80002f1a:	03353423          	sd	s3,40(a0)
    80002f1e:	03453823          	sd	s4,48(a0)
    80002f22:	03553c23          	sd	s5,56(a0)
    80002f26:	05653023          	sd	s6,64(a0)
    80002f2a:	05753423          	sd	s7,72(a0)
    80002f2e:	05853823          	sd	s8,80(a0)
    80002f32:	05953c23          	sd	s9,88(a0)
    80002f36:	07a53023          	sd	s10,96(a0)
    80002f3a:	07b53423          	sd	s11,104(a0)
    80002f3e:	0005b083          	ld	ra,0(a1)
    80002f42:	0085b103          	ld	sp,8(a1)
    80002f46:	6980                	ld	s0,16(a1)
    80002f48:	6d84                	ld	s1,24(a1)
    80002f4a:	0205b903          	ld	s2,32(a1)
    80002f4e:	0285b983          	ld	s3,40(a1)
    80002f52:	0305ba03          	ld	s4,48(a1)
    80002f56:	0385ba83          	ld	s5,56(a1)
    80002f5a:	0405bb03          	ld	s6,64(a1)
    80002f5e:	0485bb83          	ld	s7,72(a1)
    80002f62:	0505bc03          	ld	s8,80(a1)
    80002f66:	0585bc83          	ld	s9,88(a1)
    80002f6a:	0605bd03          	ld	s10,96(a1)
    80002f6e:	0685bd83          	ld	s11,104(a1)
    80002f72:	8082                	ret

0000000080002f74 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002f74:	1141                	addi	sp,sp,-16
    80002f76:	e406                	sd	ra,8(sp)
    80002f78:	e022                	sd	s0,0(sp)
    80002f7a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002f7c:	00008597          	auipc	a1,0x8
    80002f80:	3bc58593          	addi	a1,a1,956 # 8000b338 <etext+0x338>
    80002f84:	00060517          	auipc	a0,0x60
    80002f88:	c9c50513          	addi	a0,a0,-868 # 80062c20 <tickslock>
    80002f8c:	ffffe097          	auipc	ra,0xffffe
    80002f90:	cf4080e7          	jalr	-780(ra) # 80000c80 <initlock>
}
    80002f94:	60a2                	ld	ra,8(sp)
    80002f96:	6402                	ld	s0,0(sp)
    80002f98:	0141                	addi	sp,sp,16
    80002f9a:	8082                	ret

0000000080002f9c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002f9c:	1141                	addi	sp,sp,-16
    80002f9e:	e422                	sd	s0,8(sp)
    80002fa0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002fa2:	00004797          	auipc	a5,0x4
    80002fa6:	b9e78793          	addi	a5,a5,-1122 # 80006b40 <kernelvec>
    80002faa:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002fae:	6422                	ld	s0,8(sp)
    80002fb0:	0141                	addi	sp,sp,16
    80002fb2:	8082                	ret

0000000080002fb4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002fb4:	1141                	addi	sp,sp,-16
    80002fb6:	e406                	sd	ra,8(sp)
    80002fb8:	e022                	sd	s0,0(sp)
    80002fba:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002fbc:	fffff097          	auipc	ra,0xfffff
    80002fc0:	e58080e7          	jalr	-424(ra) # 80001e14 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002fc4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002fc8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002fca:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002fce:	00007697          	auipc	a3,0x7
    80002fd2:	03268693          	addi	a3,a3,50 # 8000a000 <_trampoline>
    80002fd6:	00007717          	auipc	a4,0x7
    80002fda:	02a70713          	addi	a4,a4,42 # 8000a000 <_trampoline>
    80002fde:	8f15                	sub	a4,a4,a3
    80002fe0:	040007b7          	lui	a5,0x4000
    80002fe4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002fe6:	07b2                	slli	a5,a5,0xc
    80002fe8:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002fea:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002fee:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ff0:	18002673          	csrr	a2,satp
    80002ff4:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002ff6:	6d30                	ld	a2,88(a0)
    80002ff8:	6138                	ld	a4,64(a0)
    80002ffa:	6585                	lui	a1,0x1
    80002ffc:	972e                	add	a4,a4,a1
    80002ffe:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003000:	6d38                	ld	a4,88(a0)
    80003002:	00000617          	auipc	a2,0x0
    80003006:	14860613          	addi	a2,a2,328 # 8000314a <usertrap>
    8000300a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000300c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000300e:	8612                	mv	a2,tp
    80003010:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003012:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003016:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000301a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000301e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003022:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003024:	6f18                	ld	a4,24(a4)
    80003026:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000302a:	6928                	ld	a0,80(a0)
    8000302c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000302e:	00007717          	auipc	a4,0x7
    80003032:	06e70713          	addi	a4,a4,110 # 8000a09c <userret>
    80003036:	8f15                	sub	a4,a4,a3
    80003038:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000303a:	577d                	li	a4,-1
    8000303c:	177e                	slli	a4,a4,0x3f
    8000303e:	8d59                	or	a0,a0,a4
    80003040:	9782                	jalr	a5
}
    80003042:	60a2                	ld	ra,8(sp)
    80003044:	6402                	ld	s0,0(sp)
    80003046:	0141                	addi	sp,sp,16
    80003048:	8082                	ret

000000008000304a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000304a:	1101                	addi	sp,sp,-32
    8000304c:	ec06                	sd	ra,24(sp)
    8000304e:	e822                	sd	s0,16(sp)
    80003050:	e426                	sd	s1,8(sp)
    80003052:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80003054:	00060497          	auipc	s1,0x60
    80003058:	bcc48493          	addi	s1,s1,-1076 # 80062c20 <tickslock>
    8000305c:	8526                	mv	a0,s1
    8000305e:	ffffe097          	auipc	ra,0xffffe
    80003062:	cb2080e7          	jalr	-846(ra) # 80000d10 <acquire>
  ticks++;
    80003066:	0000a517          	auipc	a0,0xa
    8000306a:	8fe50513          	addi	a0,a0,-1794 # 8000c964 <ticks>
    8000306e:	411c                	lw	a5,0(a0)
    80003070:	2785                	addiw	a5,a5,1
    80003072:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	6b2080e7          	jalr	1714(ra) # 80002726 <wakeup>
  release(&tickslock);
    8000307c:	8526                	mv	a0,s1
    8000307e:	ffffe097          	auipc	ra,0xffffe
    80003082:	d46080e7          	jalr	-698(ra) # 80000dc4 <release>
}
    80003086:	60e2                	ld	ra,24(sp)
    80003088:	6442                	ld	s0,16(sp)
    8000308a:	64a2                	ld	s1,8(sp)
    8000308c:	6105                	addi	sp,sp,32
    8000308e:	8082                	ret

0000000080003090 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003090:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80003094:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80003096:	0a07d963          	bgez	a5,80003148 <devintr+0xb8>
{
    8000309a:	1101                	addi	sp,sp,-32
    8000309c:	ec06                	sd	ra,24(sp)
    8000309e:	e822                	sd	s0,16(sp)
    800030a0:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    800030a2:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    800030a6:	46a5                	li	a3,9
    800030a8:	00d70c63          	beq	a4,a3,800030c0 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    800030ac:	577d                	li	a4,-1
    800030ae:	177e                	slli	a4,a4,0x3f
    800030b0:	0705                	addi	a4,a4,1
    return 0;
    800030b2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800030b4:	06e78963          	beq	a5,a4,80003126 <devintr+0x96>
  }
}
    800030b8:	60e2                	ld	ra,24(sp)
    800030ba:	6442                	ld	s0,16(sp)
    800030bc:	6105                	addi	sp,sp,32
    800030be:	8082                	ret
    800030c0:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800030c2:	00004097          	auipc	ra,0x4
    800030c6:	b90080e7          	jalr	-1136(ra) # 80006c52 <plic_claim>
    800030ca:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800030cc:	47a9                	li	a5,10
    800030ce:	00f50c63          	beq	a0,a5,800030e6 <devintr+0x56>
    } else if(irq == VIRTIO0_IRQ){
    800030d2:	4785                	li	a5,1
    800030d4:	02f50563          	beq	a0,a5,800030fe <devintr+0x6e>
    } else if (irq == VIRTIO1_IRQ) {
    800030d8:	4789                	li	a5,2
    800030da:	02f50763          	beq	a0,a5,80003108 <devintr+0x78>
    return 1;
    800030de:	4505                	li	a0,1
    } else if(irq){
    800030e0:	e88d                	bnez	s1,80003112 <devintr+0x82>
    800030e2:	64a2                	ld	s1,8(sp)
    800030e4:	bfd1                	j	800030b8 <devintr+0x28>
      uartintr();
    800030e6:	ffffe097          	auipc	ra,0xffffe
    800030ea:	914080e7          	jalr	-1772(ra) # 800009fa <uartintr>
      plic_complete(irq);
    800030ee:	8526                	mv	a0,s1
    800030f0:	00004097          	auipc	ra,0x4
    800030f4:	b86080e7          	jalr	-1146(ra) # 80006c76 <plic_complete>
    return 1;
    800030f8:	4505                	li	a0,1
    800030fa:	64a2                	ld	s1,8(sp)
    800030fc:	bf75                	j	800030b8 <devintr+0x28>
      virtio_disk_intr();
    800030fe:	00004097          	auipc	ra,0x4
    80003102:	07e080e7          	jalr	126(ra) # 8000717c <virtio_disk_intr>
    if(irq)
    80003106:	b7e5                	j	800030ee <devintr+0x5e>
      receive_packet();
    80003108:	00005097          	auipc	ra,0x5
    8000310c:	8c8080e7          	jalr	-1848(ra) # 800079d0 <receive_packet>
    if(irq)
    80003110:	bff9                	j	800030ee <devintr+0x5e>
      printf("unexpected interrupt irq=%d\n", irq);
    80003112:	85a6                	mv	a1,s1
    80003114:	00008517          	auipc	a0,0x8
    80003118:	22c50513          	addi	a0,a0,556 # 8000b340 <etext+0x340>
    8000311c:	ffffd097          	auipc	ra,0xffffd
    80003120:	48e080e7          	jalr	1166(ra) # 800005aa <printf>
    if(irq)
    80003124:	b7e9                	j	800030ee <devintr+0x5e>
    if(cpuid() == 0){
    80003126:	fffff097          	auipc	ra,0xfffff
    8000312a:	cc2080e7          	jalr	-830(ra) # 80001de8 <cpuid>
    8000312e:	c901                	beqz	a0,8000313e <devintr+0xae>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003130:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003134:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003136:	14479073          	csrw	sip,a5
    return 2;
    8000313a:	4509                	li	a0,2
    8000313c:	bfb5                	j	800030b8 <devintr+0x28>
      clockintr();
    8000313e:	00000097          	auipc	ra,0x0
    80003142:	f0c080e7          	jalr	-244(ra) # 8000304a <clockintr>
    80003146:	b7ed                	j	80003130 <devintr+0xa0>
}
    80003148:	8082                	ret

000000008000314a <usertrap>:
{
    8000314a:	1101                	addi	sp,sp,-32
    8000314c:	ec06                	sd	ra,24(sp)
    8000314e:	e822                	sd	s0,16(sp)
    80003150:	e426                	sd	s1,8(sp)
    80003152:	e04a                	sd	s2,0(sp)
    80003154:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003156:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000315a:	1007f793          	andi	a5,a5,256
    8000315e:	e3b1                	bnez	a5,800031a2 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003160:	00004797          	auipc	a5,0x4
    80003164:	9e078793          	addi	a5,a5,-1568 # 80006b40 <kernelvec>
    80003168:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000316c:	fffff097          	auipc	ra,0xfffff
    80003170:	ca8080e7          	jalr	-856(ra) # 80001e14 <myproc>
    80003174:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80003176:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003178:	14102773          	csrr	a4,sepc
    8000317c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000317e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80003182:	47a1                	li	a5,8
    80003184:	02f70763          	beq	a4,a5,800031b2 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80003188:	00000097          	auipc	ra,0x0
    8000318c:	f08080e7          	jalr	-248(ra) # 80003090 <devintr>
    80003190:	892a                	mv	s2,a0
    80003192:	c151                	beqz	a0,80003216 <usertrap+0xcc>
  if(killed(p))
    80003194:	8526                	mv	a0,s1
    80003196:	00000097          	auipc	ra,0x0
    8000319a:	952080e7          	jalr	-1710(ra) # 80002ae8 <killed>
    8000319e:	c929                	beqz	a0,800031f0 <usertrap+0xa6>
    800031a0:	a099                	j	800031e6 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    800031a2:	00008517          	auipc	a0,0x8
    800031a6:	1be50513          	addi	a0,a0,446 # 8000b360 <etext+0x360>
    800031aa:	ffffd097          	auipc	ra,0xffffd
    800031ae:	3b6080e7          	jalr	950(ra) # 80000560 <panic>
    if(killed(p))
    800031b2:	00000097          	auipc	ra,0x0
    800031b6:	936080e7          	jalr	-1738(ra) # 80002ae8 <killed>
    800031ba:	e921                	bnez	a0,8000320a <usertrap+0xc0>
    p->trapframe->epc += 4;
    800031bc:	6cb8                	ld	a4,88(s1)
    800031be:	6f1c                	ld	a5,24(a4)
    800031c0:	0791                	addi	a5,a5,4
    800031c2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800031c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800031c8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800031cc:	10079073          	csrw	sstatus,a5
    syscall();
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	2d4080e7          	jalr	724(ra) # 800034a4 <syscall>
  if(killed(p))
    800031d8:	8526                	mv	a0,s1
    800031da:	00000097          	auipc	ra,0x0
    800031de:	90e080e7          	jalr	-1778(ra) # 80002ae8 <killed>
    800031e2:	c911                	beqz	a0,800031f6 <usertrap+0xac>
    800031e4:	4901                	li	s2,0
    exit(-1);
    800031e6:	557d                	li	a0,-1
    800031e8:	fffff097          	auipc	ra,0xfffff
    800031ec:	6e4080e7          	jalr	1764(ra) # 800028cc <exit>
  if(which_dev == 2)
    800031f0:	4789                	li	a5,2
    800031f2:	04f90f63          	beq	s2,a5,80003250 <usertrap+0x106>
  usertrapret();
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	dbe080e7          	jalr	-578(ra) # 80002fb4 <usertrapret>
}
    800031fe:	60e2                	ld	ra,24(sp)
    80003200:	6442                	ld	s0,16(sp)
    80003202:	64a2                	ld	s1,8(sp)
    80003204:	6902                	ld	s2,0(sp)
    80003206:	6105                	addi	sp,sp,32
    80003208:	8082                	ret
      exit(-1);
    8000320a:	557d                	li	a0,-1
    8000320c:	fffff097          	auipc	ra,0xfffff
    80003210:	6c0080e7          	jalr	1728(ra) # 800028cc <exit>
    80003214:	b765                	j	800031bc <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003216:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000321a:	5890                	lw	a2,48(s1)
    8000321c:	00008517          	auipc	a0,0x8
    80003220:	16450513          	addi	a0,a0,356 # 8000b380 <etext+0x380>
    80003224:	ffffd097          	auipc	ra,0xffffd
    80003228:	386080e7          	jalr	902(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000322c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003230:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003234:	00008517          	auipc	a0,0x8
    80003238:	17c50513          	addi	a0,a0,380 # 8000b3b0 <etext+0x3b0>
    8000323c:	ffffd097          	auipc	ra,0xffffd
    80003240:	36e080e7          	jalr	878(ra) # 800005aa <printf>
    setkilled(p);
    80003244:	8526                	mv	a0,s1
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	876080e7          	jalr	-1930(ra) # 80002abc <setkilled>
    8000324e:	b769                	j	800031d8 <usertrap+0x8e>
    yield();
    80003250:	fffff097          	auipc	ra,0xfffff
    80003254:	436080e7          	jalr	1078(ra) # 80002686 <yield>
    80003258:	bf79                	j	800031f6 <usertrap+0xac>

000000008000325a <kerneltrap>:
{
    8000325a:	7179                	addi	sp,sp,-48
    8000325c:	f406                	sd	ra,40(sp)
    8000325e:	f022                	sd	s0,32(sp)
    80003260:	ec26                	sd	s1,24(sp)
    80003262:	e84a                	sd	s2,16(sp)
    80003264:	e44e                	sd	s3,8(sp)
    80003266:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003268:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000326c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003270:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80003274:	1004f793          	andi	a5,s1,256
    80003278:	cb85                	beqz	a5,800032a8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000327a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000327e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80003280:	ef85                	bnez	a5,800032b8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80003282:	00000097          	auipc	ra,0x0
    80003286:	e0e080e7          	jalr	-498(ra) # 80003090 <devintr>
    8000328a:	cd1d                	beqz	a0,800032c8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000328c:	4789                	li	a5,2
    8000328e:	06f50a63          	beq	a0,a5,80003302 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003292:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003296:	10049073          	csrw	sstatus,s1
}
    8000329a:	70a2                	ld	ra,40(sp)
    8000329c:	7402                	ld	s0,32(sp)
    8000329e:	64e2                	ld	s1,24(sp)
    800032a0:	6942                	ld	s2,16(sp)
    800032a2:	69a2                	ld	s3,8(sp)
    800032a4:	6145                	addi	sp,sp,48
    800032a6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800032a8:	00008517          	auipc	a0,0x8
    800032ac:	12850513          	addi	a0,a0,296 # 8000b3d0 <etext+0x3d0>
    800032b0:	ffffd097          	auipc	ra,0xffffd
    800032b4:	2b0080e7          	jalr	688(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    800032b8:	00008517          	auipc	a0,0x8
    800032bc:	14050513          	addi	a0,a0,320 # 8000b3f8 <etext+0x3f8>
    800032c0:	ffffd097          	auipc	ra,0xffffd
    800032c4:	2a0080e7          	jalr	672(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    800032c8:	85ce                	mv	a1,s3
    800032ca:	00008517          	auipc	a0,0x8
    800032ce:	14e50513          	addi	a0,a0,334 # 8000b418 <etext+0x418>
    800032d2:	ffffd097          	auipc	ra,0xffffd
    800032d6:	2d8080e7          	jalr	728(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800032da:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800032de:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800032e2:	00008517          	auipc	a0,0x8
    800032e6:	14650513          	addi	a0,a0,326 # 8000b428 <etext+0x428>
    800032ea:	ffffd097          	auipc	ra,0xffffd
    800032ee:	2c0080e7          	jalr	704(ra) # 800005aa <printf>
    panic("kerneltrap");
    800032f2:	00008517          	auipc	a0,0x8
    800032f6:	14e50513          	addi	a0,a0,334 # 8000b440 <etext+0x440>
    800032fa:	ffffd097          	auipc	ra,0xffffd
    800032fe:	266080e7          	jalr	614(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003302:	fffff097          	auipc	ra,0xfffff
    80003306:	b12080e7          	jalr	-1262(ra) # 80001e14 <myproc>
    8000330a:	d541                	beqz	a0,80003292 <kerneltrap+0x38>
    8000330c:	fffff097          	auipc	ra,0xfffff
    80003310:	b08080e7          	jalr	-1272(ra) # 80001e14 <myproc>
    80003314:	4d18                	lw	a4,24(a0)
    80003316:	4791                	li	a5,4
    80003318:	f6f71de3          	bne	a4,a5,80003292 <kerneltrap+0x38>
    yield();
    8000331c:	fffff097          	auipc	ra,0xfffff
    80003320:	36a080e7          	jalr	874(ra) # 80002686 <yield>
    80003324:	b7bd                	j	80003292 <kerneltrap+0x38>

0000000080003326 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003326:	1101                	addi	sp,sp,-32
    80003328:	ec06                	sd	ra,24(sp)
    8000332a:	e822                	sd	s0,16(sp)
    8000332c:	e426                	sd	s1,8(sp)
    8000332e:	1000                	addi	s0,sp,32
    80003330:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003332:	fffff097          	auipc	ra,0xfffff
    80003336:	ae2080e7          	jalr	-1310(ra) # 80001e14 <myproc>
  switch (n) {
    8000333a:	4795                	li	a5,5
    8000333c:	0497e163          	bltu	a5,s1,8000337e <argraw+0x58>
    80003340:	048a                	slli	s1,s1,0x2
    80003342:	00009717          	auipc	a4,0x9
    80003346:	be670713          	addi	a4,a4,-1050 # 8000bf28 <states.0+0x30>
    8000334a:	94ba                	add	s1,s1,a4
    8000334c:	409c                	lw	a5,0(s1)
    8000334e:	97ba                	add	a5,a5,a4
    80003350:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80003352:	6d3c                	ld	a5,88(a0)
    80003354:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003356:	60e2                	ld	ra,24(sp)
    80003358:	6442                	ld	s0,16(sp)
    8000335a:	64a2                	ld	s1,8(sp)
    8000335c:	6105                	addi	sp,sp,32
    8000335e:	8082                	ret
    return p->trapframe->a1;
    80003360:	6d3c                	ld	a5,88(a0)
    80003362:	7fa8                	ld	a0,120(a5)
    80003364:	bfcd                	j	80003356 <argraw+0x30>
    return p->trapframe->a2;
    80003366:	6d3c                	ld	a5,88(a0)
    80003368:	63c8                	ld	a0,128(a5)
    8000336a:	b7f5                	j	80003356 <argraw+0x30>
    return p->trapframe->a3;
    8000336c:	6d3c                	ld	a5,88(a0)
    8000336e:	67c8                	ld	a0,136(a5)
    80003370:	b7dd                	j	80003356 <argraw+0x30>
    return p->trapframe->a4;
    80003372:	6d3c                	ld	a5,88(a0)
    80003374:	6bc8                	ld	a0,144(a5)
    80003376:	b7c5                	j	80003356 <argraw+0x30>
    return p->trapframe->a5;
    80003378:	6d3c                	ld	a5,88(a0)
    8000337a:	6fc8                	ld	a0,152(a5)
    8000337c:	bfe9                	j	80003356 <argraw+0x30>
  panic("argraw");
    8000337e:	00008517          	auipc	a0,0x8
    80003382:	0d250513          	addi	a0,a0,210 # 8000b450 <etext+0x450>
    80003386:	ffffd097          	auipc	ra,0xffffd
    8000338a:	1da080e7          	jalr	474(ra) # 80000560 <panic>

000000008000338e <fetchaddr>:
{
    8000338e:	1101                	addi	sp,sp,-32
    80003390:	ec06                	sd	ra,24(sp)
    80003392:	e822                	sd	s0,16(sp)
    80003394:	e426                	sd	s1,8(sp)
    80003396:	e04a                	sd	s2,0(sp)
    80003398:	1000                	addi	s0,sp,32
    8000339a:	84aa                	mv	s1,a0
    8000339c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000339e:	fffff097          	auipc	ra,0xfffff
    800033a2:	a76080e7          	jalr	-1418(ra) # 80001e14 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800033a6:	653c                	ld	a5,72(a0)
    800033a8:	02f4f863          	bgeu	s1,a5,800033d8 <fetchaddr+0x4a>
    800033ac:	00848713          	addi	a4,s1,8
    800033b0:	02e7e663          	bltu	a5,a4,800033dc <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800033b4:	46a1                	li	a3,8
    800033b6:	8626                	mv	a2,s1
    800033b8:	85ca                	mv	a1,s2
    800033ba:	6928                	ld	a0,80(a0)
    800033bc:	ffffe097          	auipc	ra,0xffffe
    800033c0:	77c080e7          	jalr	1916(ra) # 80001b38 <copyin>
    800033c4:	00a03533          	snez	a0,a0
    800033c8:	40a00533          	neg	a0,a0
}
    800033cc:	60e2                	ld	ra,24(sp)
    800033ce:	6442                	ld	s0,16(sp)
    800033d0:	64a2                	ld	s1,8(sp)
    800033d2:	6902                	ld	s2,0(sp)
    800033d4:	6105                	addi	sp,sp,32
    800033d6:	8082                	ret
    return -1;
    800033d8:	557d                	li	a0,-1
    800033da:	bfcd                	j	800033cc <fetchaddr+0x3e>
    800033dc:	557d                	li	a0,-1
    800033de:	b7fd                	j	800033cc <fetchaddr+0x3e>

00000000800033e0 <fetchstr>:
{
    800033e0:	7179                	addi	sp,sp,-48
    800033e2:	f406                	sd	ra,40(sp)
    800033e4:	f022                	sd	s0,32(sp)
    800033e6:	ec26                	sd	s1,24(sp)
    800033e8:	e84a                	sd	s2,16(sp)
    800033ea:	e44e                	sd	s3,8(sp)
    800033ec:	1800                	addi	s0,sp,48
    800033ee:	892a                	mv	s2,a0
    800033f0:	84ae                	mv	s1,a1
    800033f2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	a20080e7          	jalr	-1504(ra) # 80001e14 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800033fc:	86ce                	mv	a3,s3
    800033fe:	864a                	mv	a2,s2
    80003400:	85a6                	mv	a1,s1
    80003402:	6928                	ld	a0,80(a0)
    80003404:	ffffe097          	auipc	ra,0xffffe
    80003408:	7c2080e7          	jalr	1986(ra) # 80001bc6 <copyinstr>
    8000340c:	00054e63          	bltz	a0,80003428 <fetchstr+0x48>
  return strlen(buf);
    80003410:	8526                	mv	a0,s1
    80003412:	ffffe097          	auipc	ra,0xffffe
    80003416:	b6e080e7          	jalr	-1170(ra) # 80000f80 <strlen>
}
    8000341a:	70a2                	ld	ra,40(sp)
    8000341c:	7402                	ld	s0,32(sp)
    8000341e:	64e2                	ld	s1,24(sp)
    80003420:	6942                	ld	s2,16(sp)
    80003422:	69a2                	ld	s3,8(sp)
    80003424:	6145                	addi	sp,sp,48
    80003426:	8082                	ret
    return -1;
    80003428:	557d                	li	a0,-1
    8000342a:	bfc5                	j	8000341a <fetchstr+0x3a>

000000008000342c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000342c:	1101                	addi	sp,sp,-32
    8000342e:	ec06                	sd	ra,24(sp)
    80003430:	e822                	sd	s0,16(sp)
    80003432:	e426                	sd	s1,8(sp)
    80003434:	1000                	addi	s0,sp,32
    80003436:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003438:	00000097          	auipc	ra,0x0
    8000343c:	eee080e7          	jalr	-274(ra) # 80003326 <argraw>
    80003440:	c088                	sw	a0,0(s1)
}
    80003442:	60e2                	ld	ra,24(sp)
    80003444:	6442                	ld	s0,16(sp)
    80003446:	64a2                	ld	s1,8(sp)
    80003448:	6105                	addi	sp,sp,32
    8000344a:	8082                	ret

000000008000344c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000344c:	1101                	addi	sp,sp,-32
    8000344e:	ec06                	sd	ra,24(sp)
    80003450:	e822                	sd	s0,16(sp)
    80003452:	e426                	sd	s1,8(sp)
    80003454:	1000                	addi	s0,sp,32
    80003456:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003458:	00000097          	auipc	ra,0x0
    8000345c:	ece080e7          	jalr	-306(ra) # 80003326 <argraw>
    80003460:	e088                	sd	a0,0(s1)
}
    80003462:	60e2                	ld	ra,24(sp)
    80003464:	6442                	ld	s0,16(sp)
    80003466:	64a2                	ld	s1,8(sp)
    80003468:	6105                	addi	sp,sp,32
    8000346a:	8082                	ret

000000008000346c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000346c:	7179                	addi	sp,sp,-48
    8000346e:	f406                	sd	ra,40(sp)
    80003470:	f022                	sd	s0,32(sp)
    80003472:	ec26                	sd	s1,24(sp)
    80003474:	e84a                	sd	s2,16(sp)
    80003476:	1800                	addi	s0,sp,48
    80003478:	84ae                	mv	s1,a1
    8000347a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000347c:	fd840593          	addi	a1,s0,-40
    80003480:	00000097          	auipc	ra,0x0
    80003484:	fcc080e7          	jalr	-52(ra) # 8000344c <argaddr>
  return fetchstr(addr, buf, max);
    80003488:	864a                	mv	a2,s2
    8000348a:	85a6                	mv	a1,s1
    8000348c:	fd843503          	ld	a0,-40(s0)
    80003490:	00000097          	auipc	ra,0x0
    80003494:	f50080e7          	jalr	-176(ra) # 800033e0 <fetchstr>
}
    80003498:	70a2                	ld	ra,40(sp)
    8000349a:	7402                	ld	s0,32(sp)
    8000349c:	64e2                	ld	s1,24(sp)
    8000349e:	6942                	ld	s2,16(sp)
    800034a0:	6145                	addi	sp,sp,48
    800034a2:	8082                	ret

00000000800034a4 <syscall>:
[SYS_recvfrom]      sys_recvfrom,
};

void
syscall(void)
{
    800034a4:	1101                	addi	sp,sp,-32
    800034a6:	ec06                	sd	ra,24(sp)
    800034a8:	e822                	sd	s0,16(sp)
    800034aa:	e426                	sd	s1,8(sp)
    800034ac:	e04a                	sd	s2,0(sp)
    800034ae:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800034b0:	fffff097          	auipc	ra,0xfffff
    800034b4:	964080e7          	jalr	-1692(ra) # 80001e14 <myproc>
    800034b8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800034ba:	05853903          	ld	s2,88(a0)
    800034be:	0a893783          	ld	a5,168(s2)
    800034c2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800034c6:	37fd                	addiw	a5,a5,-1
    800034c8:	02100713          	li	a4,33
    800034cc:	00f76f63          	bltu	a4,a5,800034ea <syscall+0x46>
    800034d0:	00369713          	slli	a4,a3,0x3
    800034d4:	00009797          	auipc	a5,0x9
    800034d8:	a6c78793          	addi	a5,a5,-1428 # 8000bf40 <syscalls>
    800034dc:	97ba                	add	a5,a5,a4
    800034de:	639c                	ld	a5,0(a5)
    800034e0:	c789                	beqz	a5,800034ea <syscall+0x46>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800034e2:	9782                	jalr	a5
    800034e4:	06a93823          	sd	a0,112(s2)
    800034e8:	a839                	j	80003506 <syscall+0x62>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800034ea:	15848613          	addi	a2,s1,344
    800034ee:	588c                	lw	a1,48(s1)
    800034f0:	00008517          	auipc	a0,0x8
    800034f4:	f6850513          	addi	a0,a0,-152 # 8000b458 <etext+0x458>
    800034f8:	ffffd097          	auipc	ra,0xffffd
    800034fc:	0b2080e7          	jalr	178(ra) # 800005aa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003500:	6cbc                	ld	a5,88(s1)
    80003502:	577d                	li	a4,-1
    80003504:	fbb8                	sd	a4,112(a5)
  }
}
    80003506:	60e2                	ld	ra,24(sp)
    80003508:	6442                	ld	s0,16(sp)
    8000350a:	64a2                	ld	s1,8(sp)
    8000350c:	6902                	ld	s2,0(sp)
    8000350e:	6105                	addi	sp,sp,32
    80003510:	8082                	ret

0000000080003512 <sys_exit>:
#include "file.h"
#include "sys/net.h"
#include "sys/socket.h"
#include "proc.h"

uint64 sys_exit(void) {
    80003512:	1101                	addi	sp,sp,-32
    80003514:	ec06                	sd	ra,24(sp)
    80003516:	e822                	sd	s0,16(sp)
    80003518:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000351a:	fec40593          	addi	a1,s0,-20
    8000351e:	4501                	li	a0,0
    80003520:	00000097          	auipc	ra,0x0
    80003524:	f0c080e7          	jalr	-244(ra) # 8000342c <argint>
  exit(n);
    80003528:	fec42503          	lw	a0,-20(s0)
    8000352c:	fffff097          	auipc	ra,0xfffff
    80003530:	3a0080e7          	jalr	928(ra) # 800028cc <exit>
  return 0; // not reached
}
    80003534:	4501                	li	a0,0
    80003536:	60e2                	ld	ra,24(sp)
    80003538:	6442                	ld	s0,16(sp)
    8000353a:	6105                	addi	sp,sp,32
    8000353c:	8082                	ret

000000008000353e <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    8000353e:	1141                	addi	sp,sp,-16
    80003540:	e406                	sd	ra,8(sp)
    80003542:	e022                	sd	s0,0(sp)
    80003544:	0800                	addi	s0,sp,16
    80003546:	fffff097          	auipc	ra,0xfffff
    8000354a:	8ce080e7          	jalr	-1842(ra) # 80001e14 <myproc>
    8000354e:	5908                	lw	a0,48(a0)
    80003550:	60a2                	ld	ra,8(sp)
    80003552:	6402                	ld	s0,0(sp)
    80003554:	0141                	addi	sp,sp,16
    80003556:	8082                	ret

0000000080003558 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80003558:	1141                	addi	sp,sp,-16
    8000355a:	e406                	sd	ra,8(sp)
    8000355c:	e022                	sd	s0,0(sp)
    8000355e:	0800                	addi	s0,sp,16
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	cb6080e7          	jalr	-842(ra) # 80002216 <fork>
    80003568:	60a2                	ld	ra,8(sp)
    8000356a:	6402                	ld	s0,0(sp)
    8000356c:	0141                	addi	sp,sp,16
    8000356e:	8082                	ret

0000000080003570 <sys_wait>:

uint64 sys_wait(void) {
    80003570:	1101                	addi	sp,sp,-32
    80003572:	ec06                	sd	ra,24(sp)
    80003574:	e822                	sd	s0,16(sp)
    80003576:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003578:	fe840593          	addi	a1,s0,-24
    8000357c:	4501                	li	a0,0
    8000357e:	00000097          	auipc	ra,0x0
    80003582:	ece080e7          	jalr	-306(ra) # 8000344c <argaddr>
  return wait(p);
    80003586:	fe843503          	ld	a0,-24(s0)
    8000358a:	fffff097          	auipc	ra,0xfffff
    8000358e:	6d2080e7          	jalr	1746(ra) # 80002c5c <wait>
}
    80003592:	60e2                	ld	ra,24(sp)
    80003594:	6442                	ld	s0,16(sp)
    80003596:	6105                	addi	sp,sp,32
    80003598:	8082                	ret

000000008000359a <sys_sbrk>:

uint64 sys_sbrk(void) {
    8000359a:	7179                	addi	sp,sp,-48
    8000359c:	f406                	sd	ra,40(sp)
    8000359e:	f022                	sd	s0,32(sp)
    800035a0:	ec26                	sd	s1,24(sp)
    800035a2:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800035a4:	fdc40593          	addi	a1,s0,-36
    800035a8:	4501                	li	a0,0
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	e82080e7          	jalr	-382(ra) # 8000342c <argint>
  addr = myproc()->sz;
    800035b2:	fffff097          	auipc	ra,0xfffff
    800035b6:	862080e7          	jalr	-1950(ra) # 80001e14 <myproc>
    800035ba:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    800035bc:	fdc42503          	lw	a0,-36(s0)
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	bc0080e7          	jalr	-1088(ra) # 80002180 <growproc>
    800035c8:	00054863          	bltz	a0,800035d8 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800035cc:	8526                	mv	a0,s1
    800035ce:	70a2                	ld	ra,40(sp)
    800035d0:	7402                	ld	s0,32(sp)
    800035d2:	64e2                	ld	s1,24(sp)
    800035d4:	6145                	addi	sp,sp,48
    800035d6:	8082                	ret
    return -1;
    800035d8:	54fd                	li	s1,-1
    800035da:	bfcd                	j	800035cc <sys_sbrk+0x32>

00000000800035dc <sys_sleep>:

uint64 sys_sleep(void) {
    800035dc:	7139                	addi	sp,sp,-64
    800035de:	fc06                	sd	ra,56(sp)
    800035e0:	f822                	sd	s0,48(sp)
    800035e2:	f04a                	sd	s2,32(sp)
    800035e4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800035e6:	fcc40593          	addi	a1,s0,-52
    800035ea:	4501                	li	a0,0
    800035ec:	00000097          	auipc	ra,0x0
    800035f0:	e40080e7          	jalr	-448(ra) # 8000342c <argint>
  acquire(&tickslock);
    800035f4:	0005f517          	auipc	a0,0x5f
    800035f8:	62c50513          	addi	a0,a0,1580 # 80062c20 <tickslock>
    800035fc:	ffffd097          	auipc	ra,0xffffd
    80003600:	714080e7          	jalr	1812(ra) # 80000d10 <acquire>
  ticks0 = ticks;
    80003604:	00009917          	auipc	s2,0x9
    80003608:	36092903          	lw	s2,864(s2) # 8000c964 <ticks>
  while (ticks - ticks0 < n) {
    8000360c:	fcc42783          	lw	a5,-52(s0)
    80003610:	c3b9                	beqz	a5,80003656 <sys_sleep+0x7a>
    80003612:	f426                	sd	s1,40(sp)
    80003614:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003616:	0005f997          	auipc	s3,0x5f
    8000361a:	60a98993          	addi	s3,s3,1546 # 80062c20 <tickslock>
    8000361e:	00009497          	auipc	s1,0x9
    80003622:	34648493          	addi	s1,s1,838 # 8000c964 <ticks>
    if (killed(myproc())) {
    80003626:	ffffe097          	auipc	ra,0xffffe
    8000362a:	7ee080e7          	jalr	2030(ra) # 80001e14 <myproc>
    8000362e:	fffff097          	auipc	ra,0xfffff
    80003632:	4ba080e7          	jalr	1210(ra) # 80002ae8 <killed>
    80003636:	ed15                	bnez	a0,80003672 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003638:	85ce                	mv	a1,s3
    8000363a:	8526                	mv	a0,s1
    8000363c:	fffff097          	auipc	ra,0xfffff
    80003640:	086080e7          	jalr	134(ra) # 800026c2 <sleep>
  while (ticks - ticks0 < n) {
    80003644:	409c                	lw	a5,0(s1)
    80003646:	412787bb          	subw	a5,a5,s2
    8000364a:	fcc42703          	lw	a4,-52(s0)
    8000364e:	fce7ece3          	bltu	a5,a4,80003626 <sys_sleep+0x4a>
    80003652:	74a2                	ld	s1,40(sp)
    80003654:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003656:	0005f517          	auipc	a0,0x5f
    8000365a:	5ca50513          	addi	a0,a0,1482 # 80062c20 <tickslock>
    8000365e:	ffffd097          	auipc	ra,0xffffd
    80003662:	766080e7          	jalr	1894(ra) # 80000dc4 <release>
  return 0;
    80003666:	4501                	li	a0,0
}
    80003668:	70e2                	ld	ra,56(sp)
    8000366a:	7442                	ld	s0,48(sp)
    8000366c:	7902                	ld	s2,32(sp)
    8000366e:	6121                	addi	sp,sp,64
    80003670:	8082                	ret
      release(&tickslock);
    80003672:	0005f517          	auipc	a0,0x5f
    80003676:	5ae50513          	addi	a0,a0,1454 # 80062c20 <tickslock>
    8000367a:	ffffd097          	auipc	ra,0xffffd
    8000367e:	74a080e7          	jalr	1866(ra) # 80000dc4 <release>
      return -1;
    80003682:	557d                	li	a0,-1
    80003684:	74a2                	ld	s1,40(sp)
    80003686:	69e2                	ld	s3,24(sp)
    80003688:	b7c5                	j	80003668 <sys_sleep+0x8c>

000000008000368a <sys_kill>:

uint64 sys_kill(void) {
    8000368a:	1101                	addi	sp,sp,-32
    8000368c:	ec06                	sd	ra,24(sp)
    8000368e:	e822                	sd	s0,16(sp)
    80003690:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003692:	fec40593          	addi	a1,s0,-20
    80003696:	4501                	li	a0,0
    80003698:	00000097          	auipc	ra,0x0
    8000369c:	d94080e7          	jalr	-620(ra) # 8000342c <argint>
  return kill(pid);
    800036a0:	fec42503          	lw	a0,-20(s0)
    800036a4:	fffff097          	auipc	ra,0xfffff
    800036a8:	3a6080e7          	jalr	934(ra) # 80002a4a <kill>
}
    800036ac:	60e2                	ld	ra,24(sp)
    800036ae:	6442                	ld	s0,16(sp)
    800036b0:	6105                	addi	sp,sp,32
    800036b2:	8082                	ret

00000000800036b4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800036b4:	1101                	addi	sp,sp,-32
    800036b6:	ec06                	sd	ra,24(sp)
    800036b8:	e822                	sd	s0,16(sp)
    800036ba:	e426                	sd	s1,8(sp)
    800036bc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800036be:	0005f517          	auipc	a0,0x5f
    800036c2:	56250513          	addi	a0,a0,1378 # 80062c20 <tickslock>
    800036c6:	ffffd097          	auipc	ra,0xffffd
    800036ca:	64a080e7          	jalr	1610(ra) # 80000d10 <acquire>
  xticks = ticks;
    800036ce:	00009497          	auipc	s1,0x9
    800036d2:	2964a483          	lw	s1,662(s1) # 8000c964 <ticks>
  release(&tickslock);
    800036d6:	0005f517          	auipc	a0,0x5f
    800036da:	54a50513          	addi	a0,a0,1354 # 80062c20 <tickslock>
    800036de:	ffffd097          	auipc	ra,0xffffd
    800036e2:	6e6080e7          	jalr	1766(ra) # 80000dc4 <release>
  return xticks;
}
    800036e6:	02049513          	slli	a0,s1,0x20
    800036ea:	9101                	srli	a0,a0,0x20
    800036ec:	60e2                	ld	ra,24(sp)
    800036ee:	6442                	ld	s0,16(sp)
    800036f0:	64a2                	ld	s1,8(sp)
    800036f2:	6105                	addi	sp,sp,32
    800036f4:	8082                	ret

00000000800036f6 <sys_spoon>:

uint64 sys_spoon(void) {
    800036f6:	1101                	addi	sp,sp,-32
    800036f8:	ec06                	sd	ra,24(sp)
    800036fa:	e822                	sd	s0,16(sp)
    800036fc:	1000                	addi	s0,sp,32
  // obtain the argument from the stack, we need some special handling
  uint64 addr;
  argaddr(0, &addr);
    800036fe:	fe840593          	addi	a1,s0,-24
    80003702:	4501                	li	a0,0
    80003704:	00000097          	auipc	ra,0x0
    80003708:	d48080e7          	jalr	-696(ra) # 8000344c <argaddr>
  return spoon((void *)addr);
    8000370c:	fe843503          	ld	a0,-24(s0)
    80003710:	fffff097          	auipc	ra,0xfffff
    80003714:	7d6080e7          	jalr	2006(ra) # 80002ee6 <spoon>
}
    80003718:	60e2                	ld	ra,24(sp)
    8000371a:	6442                	ld	s0,16(sp)
    8000371c:	6105                	addi	sp,sp,32
    8000371e:	8082                	ret

0000000080003720 <sys_create_thread>:

uint64 sys_create_thread(void *arg) {
    80003720:	7179                	addi	sp,sp,-48
    80003722:	f406                	sd	ra,40(sp)
    80003724:	f022                	sd	s0,32(sp)
    80003726:	1800                	addi	s0,sp,48
  uint64 fn_addr, args_addr, stack_addr, exit_fn;
  argaddr(0, &fn_addr);
    80003728:	fe840593          	addi	a1,s0,-24
    8000372c:	4501                	li	a0,0
    8000372e:	00000097          	auipc	ra,0x0
    80003732:	d1e080e7          	jalr	-738(ra) # 8000344c <argaddr>
  argaddr(1, &args_addr);
    80003736:	fe040593          	addi	a1,s0,-32
    8000373a:	4505                	li	a0,1
    8000373c:	00000097          	auipc	ra,0x0
    80003740:	d10080e7          	jalr	-752(ra) # 8000344c <argaddr>
  argaddr(2, &stack_addr);
    80003744:	fd840593          	addi	a1,s0,-40
    80003748:	4509                	li	a0,2
    8000374a:	00000097          	auipc	ra,0x0
    8000374e:	d02080e7          	jalr	-766(ra) # 8000344c <argaddr>
  argaddr(3, &exit_fn);
    80003752:	fd040593          	addi	a1,s0,-48
    80003756:	450d                	li	a0,3
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	cf4080e7          	jalr	-780(ra) # 8000344c <argaddr>
  return create_thread((void *)fn_addr, (void *)args_addr, (void *)stack_addr,
    80003760:	fd043683          	ld	a3,-48(s0)
    80003764:	fd843603          	ld	a2,-40(s0)
    80003768:	fe043583          	ld	a1,-32(s0)
    8000376c:	fe843503          	ld	a0,-24(s0)
    80003770:	fffff097          	auipc	ra,0xfffff
    80003774:	bec080e7          	jalr	-1044(ra) # 8000235c <create_thread>
                       (void *)exit_fn);
}
    80003778:	70a2                	ld	ra,40(sp)
    8000377a:	7402                	ld	s0,32(sp)
    8000377c:	6145                	addi	sp,sp,48
    8000377e:	8082                	ret

0000000080003780 <sys_join_thread>:

uint64 sys_join_thread(void *arg) {
    80003780:	1101                	addi	sp,sp,-32
    80003782:	ec06                	sd	ra,24(sp)
    80003784:	e822                	sd	s0,16(sp)
    80003786:	1000                	addi	s0,sp,32
  uint64 thread_id, status_addr;
  argaddr(0, &thread_id);
    80003788:	fe840593          	addi	a1,s0,-24
    8000378c:	4501                	li	a0,0
    8000378e:	00000097          	auipc	ra,0x0
    80003792:	cbe080e7          	jalr	-834(ra) # 8000344c <argaddr>
  argaddr(1, &status_addr);
    80003796:	fe040593          	addi	a1,s0,-32
    8000379a:	4505                	li	a0,1
    8000379c:	00000097          	auipc	ra,0x0
    800037a0:	cb0080e7          	jalr	-848(ra) # 8000344c <argaddr>
  return join_thread(thread_id, status_addr);
    800037a4:	fe043583          	ld	a1,-32(s0)
    800037a8:	fe843503          	ld	a0,-24(s0)
    800037ac:	fffff097          	auipc	ra,0xfffff
    800037b0:	36e080e7          	jalr	878(ra) # 80002b1a <join_thread>
}
    800037b4:	60e2                	ld	ra,24(sp)
    800037b6:	6442                	ld	s0,16(sp)
    800037b8:	6105                	addi	sp,sp,32
    800037ba:	8082                	ret

00000000800037bc <sys_thread_exit>:

uint64 sys_thread_exit(void *arg) {
    800037bc:	1101                	addi	sp,sp,-32
    800037be:	ec06                	sd	ra,24(sp)
    800037c0:	e822                	sd	s0,16(sp)
    800037c2:	1000                	addi	s0,sp,32
  uint64 status_addr;
  argaddr(0, &status_addr);
    800037c4:	fe840593          	addi	a1,s0,-24
    800037c8:	4501                	li	a0,0
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	c82080e7          	jalr	-894(ra) # 8000344c <argaddr>
  return thread_exit(status_addr);
    800037d2:	fe843503          	ld	a0,-24(s0)
    800037d6:	fffff097          	auipc	ra,0xfffff
    800037da:	020080e7          	jalr	32(ra) # 800027f6 <thread_exit>
}
    800037de:	60e2                	ld	ra,24(sp)
    800037e0:	6442                	ld	s0,16(sp)
    800037e2:	6105                	addi	sp,sp,32
    800037e4:	8082                	ret

00000000800037e6 <sys_bind>:

uint64 sys_bind(void) {
    800037e6:	715d                	addi	sp,sp,-80
    800037e8:	e486                	sd	ra,72(sp)
    800037ea:	e0a2                	sd	s0,64(sp)
    800037ec:	0880                	addi	s0,sp,80
    int fd;
    uint64 uaddr;
    int addrlen;

    argint(0, &fd);
    800037ee:	fdc40593          	addi	a1,s0,-36
    800037f2:	4501                	li	a0,0
    800037f4:	00000097          	auipc	ra,0x0
    800037f8:	c38080e7          	jalr	-968(ra) # 8000342c <argint>
    argaddr(1, &uaddr);
    800037fc:	fd040593          	addi	a1,s0,-48
    80003800:	4505                	li	a0,1
    80003802:	00000097          	auipc	ra,0x0
    80003806:	c4a080e7          	jalr	-950(ra) # 8000344c <argaddr>
    argint(2, &addrlen);
    8000380a:	fcc40593          	addi	a1,s0,-52
    8000380e:	4509                	li	a0,2
    80003810:	00000097          	auipc	ra,0x0
    80003814:	c1c080e7          	jalr	-996(ra) # 8000342c <argint>

    struct file *f = myproc()->ofile[fd];
    80003818:	ffffe097          	auipc	ra,0xffffe
    8000381c:	5fc080e7          	jalr	1532(ra) # 80001e14 <myproc>
    80003820:	fdc42783          	lw	a5,-36(s0)
    80003824:	07e9                	addi	a5,a5,26
    80003826:	078e                	slli	a5,a5,0x3
    80003828:	953e                	add	a0,a0,a5
    8000382a:	611c                	ld	a5,0(a0)
    if (f == 0 || f->type != FD_SOCKET)
    8000382c:	cbb9                	beqz	a5,80003882 <sys_bind+0x9c>
    8000382e:	4394                	lw	a3,0(a5)
    80003830:	4711                	li	a4,4
        return -1;
    80003832:	557d                	li	a0,-1
    if (f == 0 || f->type != FD_SOCKET)
    80003834:	04e69363          	bne	a3,a4,8000387a <sys_bind+0x94>

    struct socket *sock = f->sock;

    struct sockaddr_in addr;
    if (addrlen > sizeof(addr))
    80003838:	fcc42683          	lw	a3,-52(s0)
    8000383c:	4741                	li	a4,16
    8000383e:	02d76e63          	bltu	a4,a3,8000387a <sys_bind+0x94>
    80003842:	fc26                	sd	s1,56(sp)
    struct socket *sock = f->sock;
    80003844:	7384                	ld	s1,32(a5)
        return -1;

    // Copy user memory → kernel struct
    if (copyin(myproc()->pagetable, (char*)&addr, uaddr, addrlen) < 0)
    80003846:	ffffe097          	auipc	ra,0xffffe
    8000384a:	5ce080e7          	jalr	1486(ra) # 80001e14 <myproc>
    8000384e:	fcc42683          	lw	a3,-52(s0)
    80003852:	fd043603          	ld	a2,-48(s0)
    80003856:	fb840593          	addi	a1,s0,-72
    8000385a:	6928                	ld	a0,80(a0)
    8000385c:	ffffe097          	auipc	ra,0xffffe
    80003860:	2dc080e7          	jalr	732(ra) # 80001b38 <copyin>
    80003864:	02054163          	bltz	a0,80003886 <sys_bind+0xa0>
        return -1;

    return sock->ops->bind(sock, (struct sockaddr*)&addr, addrlen);
    80003868:	64bc                	ld	a5,72(s1)
    8000386a:	639c                	ld	a5,0(a5)
    8000386c:	fcc42603          	lw	a2,-52(s0)
    80003870:	fb840593          	addi	a1,s0,-72
    80003874:	8526                	mv	a0,s1
    80003876:	9782                	jalr	a5
    80003878:	74e2                	ld	s1,56(sp)
}
    8000387a:	60a6                	ld	ra,72(sp)
    8000387c:	6406                	ld	s0,64(sp)
    8000387e:	6161                	addi	sp,sp,80
    80003880:	8082                	ret
        return -1;
    80003882:	557d                	li	a0,-1
    80003884:	bfdd                	j	8000387a <sys_bind+0x94>
        return -1;
    80003886:	557d                	li	a0,-1
    80003888:	74e2                	ld	s1,56(sp)
    8000388a:	bfc5                	j	8000387a <sys_bind+0x94>

000000008000388c <sys_listen>:
uint64 sys_listen(void *arg) {
    8000388c:	1101                	addi	sp,sp,-32
    8000388e:	ec06                	sd	ra,24(sp)
    80003890:	e822                	sd	s0,16(sp)
    80003892:	1000                	addi	s0,sp,32
  uint64 socket, backlog;
  argaddr(0, &socket);
    80003894:	fe840593          	addi	a1,s0,-24
    80003898:	4501                	li	a0,0
    8000389a:	00000097          	auipc	ra,0x0
    8000389e:	bb2080e7          	jalr	-1102(ra) # 8000344c <argaddr>
  argaddr(1, &backlog);
    800038a2:	fe040593          	addi	a1,s0,-32
    800038a6:	4505                	li	a0,1
    800038a8:	00000097          	auipc	ra,0x0
    800038ac:	ba4080e7          	jalr	-1116(ra) # 8000344c <argaddr>
  return listen(socket, backlog);
    800038b0:	fe042583          	lw	a1,-32(s0)
    800038b4:	fe842503          	lw	a0,-24(s0)
    800038b8:	00005097          	auipc	ra,0x5
    800038bc:	c90080e7          	jalr	-880(ra) # 80008548 <listen>
}
    800038c0:	60e2                	ld	ra,24(sp)
    800038c2:	6442                	ld	s0,16(sp)
    800038c4:	6105                	addi	sp,sp,32
    800038c6:	8082                	ret

00000000800038c8 <sys_accept>:

uint64 sys_accept(void *arg) {
    800038c8:	7179                	addi	sp,sp,-48
    800038ca:	f406                	sd	ra,40(sp)
    800038cc:	f022                	sd	s0,32(sp)
    800038ce:	1800                	addi	s0,sp,48
  uint64 socket;
  uint64 address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    800038d0:	fe840593          	addi	a1,s0,-24
    800038d4:	4501                	li	a0,0
    800038d6:	00000097          	auipc	ra,0x0
    800038da:	b76080e7          	jalr	-1162(ra) # 8000344c <argaddr>
  argaddr(1, (uint64 *)&address);
    800038de:	fd040593          	addi	a1,s0,-48
    800038e2:	4505                	li	a0,1
    800038e4:	00000097          	auipc	ra,0x0
    800038e8:	b68080e7          	jalr	-1176(ra) # 8000344c <argaddr>
  argaddr(2, &address_len);
    800038ec:	fe040593          	addi	a1,s0,-32
    800038f0:	4509                	li	a0,2
    800038f2:	00000097          	auipc	ra,0x0
    800038f6:	b5a080e7          	jalr	-1190(ra) # 8000344c <argaddr>
  return accept(socket, &address, address_len);
    800038fa:	fe042603          	lw	a2,-32(s0)
    800038fe:	fd040593          	addi	a1,s0,-48
    80003902:	fe842503          	lw	a0,-24(s0)
    80003906:	00005097          	auipc	ra,0x5
    8000390a:	c70080e7          	jalr	-912(ra) # 80008576 <accept>
}
    8000390e:	70a2                	ld	ra,40(sp)
    80003910:	7402                	ld	s0,32(sp)
    80003912:	6145                	addi	sp,sp,48
    80003914:	8082                	ret

0000000080003916 <sys_socket>:

uint64 sys_socket(void *arg) {;
    80003916:	7139                	addi	sp,sp,-64
    80003918:	fc06                	sd	ra,56(sp)
    8000391a:	f822                	sd	s0,48(sp)
    8000391c:	0080                	addi	s0,sp,64
  uint64 address_family, address_socktype, protocol;
  argaddr(0, &address_family);
    8000391e:	fd840593          	addi	a1,s0,-40
    80003922:	4501                	li	a0,0
    80003924:	00000097          	auipc	ra,0x0
    80003928:	b28080e7          	jalr	-1240(ra) # 8000344c <argaddr>
  argaddr(1, &address_socktype);
    8000392c:	fd040593          	addi	a1,s0,-48
    80003930:	4505                	li	a0,1
    80003932:	00000097          	auipc	ra,0x0
    80003936:	b1a080e7          	jalr	-1254(ra) # 8000344c <argaddr>
  argaddr(2, &protocol);
    8000393a:	fc840593          	addi	a1,s0,-56
    8000393e:	4509                	li	a0,2
    80003940:	00000097          	auipc	ra,0x0
    80003944:	b0c080e7          	jalr	-1268(ra) # 8000344c <argaddr>

  struct socket *sock = (struct socket *)kalloc();
    80003948:	ffffd097          	auipc	ra,0xffffd
    8000394c:	2ba080e7          	jalr	698(ra) # 80000c02 <kalloc>
  if (sock == 0) {
    80003950:	cd29                	beqz	a0,800039aa <sys_socket+0x94>
    80003952:	f426                	sd	s1,40(sp)
    80003954:	f04a                	sd	s2,32(sp)
    80003956:	84aa                	mv	s1,a0
    printf("ERROR: kalloc\n");
    return -1;
  }
  memset(sock, 0, PGSIZE);
    80003958:	6605                	lui	a2,0x1
    8000395a:	4581                	li	a1,0
    8000395c:	ffffd097          	auipc	ra,0xffffd
    80003960:	4b0080e7          	jalr	1200(ra) # 80000e0c <memset>

  initsocket(sock, address_family, address_socktype, protocol);
    80003964:	fc842683          	lw	a3,-56(s0)
    80003968:	fd042603          	lw	a2,-48(s0)
    8000396c:	fd842583          	lw	a1,-40(s0)
    80003970:	8526                	mv	a0,s1
    80003972:	00005097          	auipc	ra,0x5
    80003976:	cae080e7          	jalr	-850(ra) # 80008620 <initsocket>

  struct file *f = filealloc();
    8000397a:	00002097          	auipc	ra,0x2
    8000397e:	9be080e7          	jalr	-1602(ra) # 80005338 <filealloc>
    80003982:	892a                	mv	s2,a0
  if (f == 0) {
    80003984:	cd0d                	beqz	a0,800039be <sys_socket+0xa8>
    kfree(sock);
    return -1;
  }

  int fd = fdalloc(f);
    80003986:	00002097          	auipc	ra,0x2
    8000398a:	756080e7          	jalr	1878(ra) # 800060dc <fdalloc>
  if (fd < 0) {
    8000398e:	04054163          	bltz	a0,800039d0 <sys_socket+0xba>
    fileclose(f);
    kfree(sock);
    return -1;
  }

  f->type = FD_SOCKET;
    80003992:	4791                	li	a5,4
    80003994:	00f92023          	sw	a5,0(s2)
  f->sock = sock;
    80003998:	02993023          	sd	s1,32(s2)
  sock->fd = fd;
    8000399c:	c0a8                	sw	a0,64(s1)
    8000399e:	74a2                	ld	s1,40(sp)
    800039a0:	7902                	ld	s2,32(sp)

  return fd;
}
    800039a2:	70e2                	ld	ra,56(sp)
    800039a4:	7442                	ld	s0,48(sp)
    800039a6:	6121                	addi	sp,sp,64
    800039a8:	8082                	ret
    printf("ERROR: kalloc\n");
    800039aa:	00008517          	auipc	a0,0x8
    800039ae:	ace50513          	addi	a0,a0,-1330 # 8000b478 <etext+0x478>
    800039b2:	ffffd097          	auipc	ra,0xffffd
    800039b6:	bf8080e7          	jalr	-1032(ra) # 800005aa <printf>
    return -1;
    800039ba:	557d                	li	a0,-1
    800039bc:	b7dd                	j	800039a2 <sys_socket+0x8c>
    kfree(sock);
    800039be:	8526                	mv	a0,s1
    800039c0:	ffffd097          	auipc	ra,0xffffd
    800039c4:	0da080e7          	jalr	218(ra) # 80000a9a <kfree>
    return -1;
    800039c8:	557d                	li	a0,-1
    800039ca:	74a2                	ld	s1,40(sp)
    800039cc:	7902                	ld	s2,32(sp)
    800039ce:	bfd1                	j	800039a2 <sys_socket+0x8c>
    fileclose(f);
    800039d0:	854a                	mv	a0,s2
    800039d2:	00002097          	auipc	ra,0x2
    800039d6:	a22080e7          	jalr	-1502(ra) # 800053f4 <fileclose>
    kfree(sock);
    800039da:	8526                	mv	a0,s1
    800039dc:	ffffd097          	auipc	ra,0xffffd
    800039e0:	0be080e7          	jalr	190(ra) # 80000a9a <kfree>
    return -1;
    800039e4:	557d                	li	a0,-1
    800039e6:	74a2                	ld	s1,40(sp)
    800039e8:	7902                	ld	s2,32(sp)
    800039ea:	bf65                	j	800039a2 <sys_socket+0x8c>

00000000800039ec <sys_connect>:

uint64 sys_connect(void *arg) {
    800039ec:	7179                	addi	sp,sp,-48
    800039ee:	f406                	sd	ra,40(sp)
    800039f0:	f022                	sd	s0,32(sp)
    800039f2:	1800                	addi	s0,sp,48
  uint64 socket, address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    800039f4:	fe840593          	addi	a1,s0,-24
    800039f8:	4501                	li	a0,0
    800039fa:	00000097          	auipc	ra,0x0
    800039fe:	a52080e7          	jalr	-1454(ra) # 8000344c <argaddr>
  argaddr(1, (uint64 *)&address);
    80003a02:	fd040593          	addi	a1,s0,-48
    80003a06:	4505                	li	a0,1
    80003a08:	00000097          	auipc	ra,0x0
    80003a0c:	a44080e7          	jalr	-1468(ra) # 8000344c <argaddr>
  argaddr(2, &address_len);
    80003a10:	fe040593          	addi	a1,s0,-32
    80003a14:	4509                	li	a0,2
    80003a16:	00000097          	auipc	ra,0x0
    80003a1a:	a36080e7          	jalr	-1482(ra) # 8000344c <argaddr>
  return connect(socket, &address, address_len);
    80003a1e:	fe042603          	lw	a2,-32(s0)
    80003a22:	fd040593          	addi	a1,s0,-48
    80003a26:	fe842503          	lw	a0,-24(s0)
    80003a2a:	00005097          	auipc	ra,0x5
    80003a2e:	be4080e7          	jalr	-1052(ra) # 8000860e <connect>
}
    80003a32:	70a2                	ld	ra,40(sp)
    80003a34:	7402                	ld	s0,32(sp)
    80003a36:	6145                	addi	sp,sp,48
    80003a38:	8082                	ret

0000000080003a3a <sys_send>:

uint64
sys_send(void)
{
    80003a3a:	7179                	addi	sp,sp,-48
    80003a3c:	f406                	sd	ra,40(sp)
    80003a3e:	f022                	sd	s0,32(sp)
    80003a40:	1800                	addi	s0,sp,48
  int fd;
  uint64 buf;   // user pointer
  int len;
  int flags;

  argint(0, &fd);
    80003a42:	fec40593          	addi	a1,s0,-20
    80003a46:	4501                	li	a0,0
    80003a48:	00000097          	auipc	ra,0x0
    80003a4c:	9e4080e7          	jalr	-1564(ra) # 8000342c <argint>
  argaddr(1, &buf);
    80003a50:	fe040593          	addi	a1,s0,-32
    80003a54:	4505                	li	a0,1
    80003a56:	00000097          	auipc	ra,0x0
    80003a5a:	9f6080e7          	jalr	-1546(ra) # 8000344c <argaddr>
  argint(2, &len);
    80003a5e:	fdc40593          	addi	a1,s0,-36
    80003a62:	4509                	li	a0,2
    80003a64:	00000097          	auipc	ra,0x0
    80003a68:	9c8080e7          	jalr	-1592(ra) # 8000342c <argint>
  argint(3, &flags);
    80003a6c:	fd840593          	addi	a1,s0,-40
    80003a70:	450d                	li	a0,3
    80003a72:	00000097          	auipc	ra,0x0
    80003a76:	9ba080e7          	jalr	-1606(ra) # 8000342c <argint>

  struct file *f = myproc()->ofile[fd];
    80003a7a:	ffffe097          	auipc	ra,0xffffe
    80003a7e:	39a080e7          	jalr	922(ra) # 80001e14 <myproc>
    80003a82:	fec42703          	lw	a4,-20(s0)
    80003a86:	01a70793          	addi	a5,a4,26
    80003a8a:	078e                	slli	a5,a5,0x3
    80003a8c:	97aa                	add	a5,a5,a0
    80003a8e:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003a90:	c795                	beqz	a5,80003abc <sys_send+0x82>
    80003a92:	4394                	lw	a3,0(a5)
    80003a94:	4791                	li	a5,4
    return -1;
    80003a96:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003a98:	00f68663          	beq	a3,a5,80003aa4 <sys_send+0x6a>

  return send(fd, (uint64 *)buf, len, flags);
}
    80003a9c:	70a2                	ld	ra,40(sp)
    80003a9e:	7402                	ld	s0,32(sp)
    80003aa0:	6145                	addi	sp,sp,48
    80003aa2:	8082                	ret
  return send(fd, (uint64 *)buf, len, flags);
    80003aa4:	fd842683          	lw	a3,-40(s0)
    80003aa8:	fdc42603          	lw	a2,-36(s0)
    80003aac:	fe043583          	ld	a1,-32(s0)
    80003ab0:	853a                	mv	a0,a4
    80003ab2:	00005097          	auipc	ra,0x5
    80003ab6:	c64080e7          	jalr	-924(ra) # 80008716 <send>
    80003aba:	b7cd                	j	80003a9c <sys_send+0x62>
    return -1;
    80003abc:	557d                	li	a0,-1
    80003abe:	bff9                	j	80003a9c <sys_send+0x62>

0000000080003ac0 <sys_recv>:

uint64 sys_recv(void *arg) {
    80003ac0:	7179                	addi	sp,sp,-48
    80003ac2:	f406                	sd	ra,40(sp)
    80003ac4:	f022                	sd	s0,32(sp)
    80003ac6:	1800                	addi	s0,sp,48
  int fd;
  uint64 buf;
  int len;
  int flags;

  argint(0, &fd);
    80003ac8:	fec40593          	addi	a1,s0,-20
    80003acc:	4501                	li	a0,0
    80003ace:	00000097          	auipc	ra,0x0
    80003ad2:	95e080e7          	jalr	-1698(ra) # 8000342c <argint>
  argaddr(1, &buf);
    80003ad6:	fe040593          	addi	a1,s0,-32
    80003ada:	4505                	li	a0,1
    80003adc:	00000097          	auipc	ra,0x0
    80003ae0:	970080e7          	jalr	-1680(ra) # 8000344c <argaddr>
  argint(2, &len);
    80003ae4:	fdc40593          	addi	a1,s0,-36
    80003ae8:	4509                	li	a0,2
    80003aea:	00000097          	auipc	ra,0x0
    80003aee:	942080e7          	jalr	-1726(ra) # 8000342c <argint>
  argint(3, &flags);
    80003af2:	fd840593          	addi	a1,s0,-40
    80003af6:	450d                	li	a0,3
    80003af8:	00000097          	auipc	ra,0x0
    80003afc:	934080e7          	jalr	-1740(ra) # 8000342c <argint>

  struct file *f = myproc()->ofile[fd];
    80003b00:	ffffe097          	auipc	ra,0xffffe
    80003b04:	314080e7          	jalr	788(ra) # 80001e14 <myproc>
    80003b08:	fec42703          	lw	a4,-20(s0)
    80003b0c:	01a70793          	addi	a5,a4,26
    80003b10:	078e                	slli	a5,a5,0x3
    80003b12:	97aa                	add	a5,a5,a0
    80003b14:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003b16:	c795                	beqz	a5,80003b42 <sys_recv+0x82>
    80003b18:	4394                	lw	a3,0(a5)
    80003b1a:	4791                	li	a5,4
    return -1;
    80003b1c:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003b1e:	00f68663          	beq	a3,a5,80003b2a <sys_recv+0x6a>

  return recv(fd, (uint64 *)buf, len, flags);
}
    80003b22:	70a2                	ld	ra,40(sp)
    80003b24:	7402                	ld	s0,32(sp)
    80003b26:	6145                	addi	sp,sp,48
    80003b28:	8082                	ret
  return recv(fd, (uint64 *)buf, len, flags);
    80003b2a:	fd842683          	lw	a3,-40(s0)
    80003b2e:	fdc42603          	lw	a2,-36(s0)
    80003b32:	fe043583          	ld	a1,-32(s0)
    80003b36:	853a                	mv	a0,a4
    80003b38:	00005097          	auipc	ra,0x5
    80003b3c:	bf0080e7          	jalr	-1040(ra) # 80008728 <recv>
    80003b40:	b7cd                	j	80003b22 <sys_recv+0x62>
    return -1;
    80003b42:	557d                	li	a0,-1
    80003b44:	bff9                	j	80003b22 <sys_recv+0x62>

0000000080003b46 <sys_sendto>:

uint64 sys_sendto(void) {
    80003b46:	7139                	addi	sp,sp,-64
    80003b48:	fc06                	sd	ra,56(sp)
    80003b4a:	f822                	sd	s0,48(sp)
    80003b4c:	0080                	addi	s0,sp,64
  int len;
  int flags;
  uint64 dest_addr;
  int addrlen;

  argint(0, &fd);
    80003b4e:	fec40593          	addi	a1,s0,-20
    80003b52:	4501                	li	a0,0
    80003b54:	00000097          	auipc	ra,0x0
    80003b58:	8d8080e7          	jalr	-1832(ra) # 8000342c <argint>
  argaddr(1, &buf);
    80003b5c:	fe040593          	addi	a1,s0,-32
    80003b60:	4505                	li	a0,1
    80003b62:	00000097          	auipc	ra,0x0
    80003b66:	8ea080e7          	jalr	-1814(ra) # 8000344c <argaddr>
  argint(2, &len);
    80003b6a:	fdc40593          	addi	a1,s0,-36
    80003b6e:	4509                	li	a0,2
    80003b70:	00000097          	auipc	ra,0x0
    80003b74:	8bc080e7          	jalr	-1860(ra) # 8000342c <argint>
  argint(3, &flags);
    80003b78:	fd840593          	addi	a1,s0,-40
    80003b7c:	450d                	li	a0,3
    80003b7e:	00000097          	auipc	ra,0x0
    80003b82:	8ae080e7          	jalr	-1874(ra) # 8000342c <argint>
  argaddr(4, &dest_addr);
    80003b86:	fd040593          	addi	a1,s0,-48
    80003b8a:	4511                	li	a0,4
    80003b8c:	00000097          	auipc	ra,0x0
    80003b90:	8c0080e7          	jalr	-1856(ra) # 8000344c <argaddr>
  argint(5, &addrlen);
    80003b94:	fcc40593          	addi	a1,s0,-52
    80003b98:	4515                	li	a0,5
    80003b9a:	00000097          	auipc	ra,0x0
    80003b9e:	892080e7          	jalr	-1902(ra) # 8000342c <argint>

  struct file *f = myproc()->ofile[fd];
    80003ba2:	ffffe097          	auipc	ra,0xffffe
    80003ba6:	272080e7          	jalr	626(ra) # 80001e14 <myproc>
    80003baa:	fec42803          	lw	a6,-20(s0)
    80003bae:	01a80793          	addi	a5,a6,26
    80003bb2:	078e                	slli	a5,a5,0x3
    80003bb4:	97aa                	add	a5,a5,a0
    80003bb6:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003bb8:	cb95                	beqz	a5,80003bec <sys_sendto+0xa6>
    80003bba:	4398                	lw	a4,0(a5)
    80003bbc:	4791                	li	a5,4
    return -1;
    80003bbe:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003bc0:	00f70663          	beq	a4,a5,80003bcc <sys_sendto+0x86>

  return sendto(fd, (uint64 *)buf, len, flags,
                     (struct sockaddr *)dest_addr, addrlen);
}
    80003bc4:	70e2                	ld	ra,56(sp)
    80003bc6:	7442                	ld	s0,48(sp)
    80003bc8:	6121                	addi	sp,sp,64
    80003bca:	8082                	ret
  return sendto(fd, (uint64 *)buf, len, flags,
    80003bcc:	fcc42783          	lw	a5,-52(s0)
    80003bd0:	fd043703          	ld	a4,-48(s0)
    80003bd4:	fd842683          	lw	a3,-40(s0)
    80003bd8:	fdc42603          	lw	a2,-36(s0)
    80003bdc:	fe043583          	ld	a1,-32(s0)
    80003be0:	8542                	mv	a0,a6
    80003be2:	00005097          	auipc	ra,0x5
    80003be6:	b58080e7          	jalr	-1192(ra) # 8000873a <sendto>
    80003bea:	bfe9                	j	80003bc4 <sys_sendto+0x7e>
    return -1;
    80003bec:	557d                	li	a0,-1
    80003bee:	bfd9                	j	80003bc4 <sys_sendto+0x7e>

0000000080003bf0 <sys_recvfrom>:

uint64 sys_recvfrom(void *arg) {
    80003bf0:	7139                	addi	sp,sp,-64
    80003bf2:	fc06                	sd	ra,56(sp)
    80003bf4:	f822                	sd	s0,48(sp)
    80003bf6:	0080                	addi	s0,sp,64
  int len;
  int flags;
  uint64 src_addr;
  uint64 addrlen;

  argint(0, &fd);
    80003bf8:	fec40593          	addi	a1,s0,-20
    80003bfc:	4501                	li	a0,0
    80003bfe:	00000097          	auipc	ra,0x0
    80003c02:	82e080e7          	jalr	-2002(ra) # 8000342c <argint>
  argaddr(1, &buf);
    80003c06:	fe040593          	addi	a1,s0,-32
    80003c0a:	4505                	li	a0,1
    80003c0c:	00000097          	auipc	ra,0x0
    80003c10:	840080e7          	jalr	-1984(ra) # 8000344c <argaddr>
  argint(2, &len);
    80003c14:	fdc40593          	addi	a1,s0,-36
    80003c18:	4509                	li	a0,2
    80003c1a:	00000097          	auipc	ra,0x0
    80003c1e:	812080e7          	jalr	-2030(ra) # 8000342c <argint>
  argint(3, &flags);
    80003c22:	fd840593          	addi	a1,s0,-40
    80003c26:	450d                	li	a0,3
    80003c28:	00000097          	auipc	ra,0x0
    80003c2c:	804080e7          	jalr	-2044(ra) # 8000342c <argint>
  argaddr(4, &src_addr);
    80003c30:	fd040593          	addi	a1,s0,-48
    80003c34:	4511                	li	a0,4
    80003c36:	00000097          	auipc	ra,0x0
    80003c3a:	816080e7          	jalr	-2026(ra) # 8000344c <argaddr>
  argaddr(5, &addrlen);
    80003c3e:	fc840593          	addi	a1,s0,-56
    80003c42:	4515                	li	a0,5
    80003c44:	00000097          	auipc	ra,0x0
    80003c48:	808080e7          	jalr	-2040(ra) # 8000344c <argaddr>

  struct file *f = myproc()->ofile[fd];
    80003c4c:	ffffe097          	auipc	ra,0xffffe
    80003c50:	1c8080e7          	jalr	456(ra) # 80001e14 <myproc>
    80003c54:	fec42803          	lw	a6,-20(s0)
    80003c58:	01a80793          	addi	a5,a6,26
    80003c5c:	078e                	slli	a5,a5,0x3
    80003c5e:	97aa                	add	a5,a5,a0
    80003c60:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003c62:	cb95                	beqz	a5,80003c96 <sys_recvfrom+0xa6>
    80003c64:	4398                	lw	a4,0(a5)
    80003c66:	4791                	li	a5,4
    return -1;
    80003c68:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003c6a:	00f70663          	beq	a4,a5,80003c76 <sys_recvfrom+0x86>

  return recvfrom(fd, (uint64 *)buf, len, flags,
                       (struct sockaddr *)src_addr,
                       (socklen_t *)addrlen);
}
    80003c6e:	70e2                	ld	ra,56(sp)
    80003c70:	7442                	ld	s0,48(sp)
    80003c72:	6121                	addi	sp,sp,64
    80003c74:	8082                	ret
  return recvfrom(fd, (uint64 *)buf, len, flags,
    80003c76:	fc843783          	ld	a5,-56(s0)
    80003c7a:	fd043703          	ld	a4,-48(s0)
    80003c7e:	fd842683          	lw	a3,-40(s0)
    80003c82:	fdc42603          	lw	a2,-36(s0)
    80003c86:	fe043583          	ld	a1,-32(s0)
    80003c8a:	8542                	mv	a0,a6
    80003c8c:	00005097          	auipc	ra,0x5
    80003c90:	afc080e7          	jalr	-1284(ra) # 80008788 <recvfrom>
    80003c94:	bfe9                	j	80003c6e <sys_recvfrom+0x7e>
    return -1;
    80003c96:	557d                	li	a0,-1
    80003c98:	bfd9                	j	80003c6e <sys_recvfrom+0x7e>

0000000080003c9a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003c9a:	7179                	addi	sp,sp,-48
    80003c9c:	f406                	sd	ra,40(sp)
    80003c9e:	f022                	sd	s0,32(sp)
    80003ca0:	ec26                	sd	s1,24(sp)
    80003ca2:	e84a                	sd	s2,16(sp)
    80003ca4:	e44e                	sd	s3,8(sp)
    80003ca6:	e052                	sd	s4,0(sp)
    80003ca8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003caa:	00007597          	auipc	a1,0x7
    80003cae:	7de58593          	addi	a1,a1,2014 # 8000b488 <etext+0x488>
    80003cb2:	0005f517          	auipc	a0,0x5f
    80003cb6:	f8650513          	addi	a0,a0,-122 # 80062c38 <bcache>
    80003cba:	ffffd097          	auipc	ra,0xffffd
    80003cbe:	fc6080e7          	jalr	-58(ra) # 80000c80 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003cc2:	00067797          	auipc	a5,0x67
    80003cc6:	f7678793          	addi	a5,a5,-138 # 8006ac38 <bcache+0x8000>
    80003cca:	00067717          	auipc	a4,0x67
    80003cce:	1d670713          	addi	a4,a4,470 # 8006aea0 <bcache+0x8268>
    80003cd2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003cd6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003cda:	0005f497          	auipc	s1,0x5f
    80003cde:	f7648493          	addi	s1,s1,-138 # 80062c50 <bcache+0x18>
    b->next = bcache.head.next;
    80003ce2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003ce4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003ce6:	00007a17          	auipc	s4,0x7
    80003cea:	7aaa0a13          	addi	s4,s4,1962 # 8000b490 <etext+0x490>
    b->next = bcache.head.next;
    80003cee:	2b893783          	ld	a5,696(s2)
    80003cf2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003cf4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003cf8:	85d2                	mv	a1,s4
    80003cfa:	01048513          	addi	a0,s1,16
    80003cfe:	00001097          	auipc	ra,0x1
    80003d02:	4e8080e7          	jalr	1256(ra) # 800051e6 <initsleeplock>
    bcache.head.next->prev = b;
    80003d06:	2b893783          	ld	a5,696(s2)
    80003d0a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003d0c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003d10:	45848493          	addi	s1,s1,1112
    80003d14:	fd349de3          	bne	s1,s3,80003cee <binit+0x54>
  }
}
    80003d18:	70a2                	ld	ra,40(sp)
    80003d1a:	7402                	ld	s0,32(sp)
    80003d1c:	64e2                	ld	s1,24(sp)
    80003d1e:	6942                	ld	s2,16(sp)
    80003d20:	69a2                	ld	s3,8(sp)
    80003d22:	6a02                	ld	s4,0(sp)
    80003d24:	6145                	addi	sp,sp,48
    80003d26:	8082                	ret

0000000080003d28 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003d28:	7179                	addi	sp,sp,-48
    80003d2a:	f406                	sd	ra,40(sp)
    80003d2c:	f022                	sd	s0,32(sp)
    80003d2e:	ec26                	sd	s1,24(sp)
    80003d30:	e84a                	sd	s2,16(sp)
    80003d32:	e44e                	sd	s3,8(sp)
    80003d34:	1800                	addi	s0,sp,48
    80003d36:	892a                	mv	s2,a0
    80003d38:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003d3a:	0005f517          	auipc	a0,0x5f
    80003d3e:	efe50513          	addi	a0,a0,-258 # 80062c38 <bcache>
    80003d42:	ffffd097          	auipc	ra,0xffffd
    80003d46:	fce080e7          	jalr	-50(ra) # 80000d10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003d4a:	00067497          	auipc	s1,0x67
    80003d4e:	1a64b483          	ld	s1,422(s1) # 8006aef0 <bcache+0x82b8>
    80003d52:	00067797          	auipc	a5,0x67
    80003d56:	14e78793          	addi	a5,a5,334 # 8006aea0 <bcache+0x8268>
    80003d5a:	02f48f63          	beq	s1,a5,80003d98 <bread+0x70>
    80003d5e:	873e                	mv	a4,a5
    80003d60:	a021                	j	80003d68 <bread+0x40>
    80003d62:	68a4                	ld	s1,80(s1)
    80003d64:	02e48a63          	beq	s1,a4,80003d98 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003d68:	449c                	lw	a5,8(s1)
    80003d6a:	ff279ce3          	bne	a5,s2,80003d62 <bread+0x3a>
    80003d6e:	44dc                	lw	a5,12(s1)
    80003d70:	ff3799e3          	bne	a5,s3,80003d62 <bread+0x3a>
      b->refcnt++;
    80003d74:	40bc                	lw	a5,64(s1)
    80003d76:	2785                	addiw	a5,a5,1
    80003d78:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003d7a:	0005f517          	auipc	a0,0x5f
    80003d7e:	ebe50513          	addi	a0,a0,-322 # 80062c38 <bcache>
    80003d82:	ffffd097          	auipc	ra,0xffffd
    80003d86:	042080e7          	jalr	66(ra) # 80000dc4 <release>
      acquiresleep(&b->lock);
    80003d8a:	01048513          	addi	a0,s1,16
    80003d8e:	00001097          	auipc	ra,0x1
    80003d92:	492080e7          	jalr	1170(ra) # 80005220 <acquiresleep>
      return b;
    80003d96:	a8b9                	j	80003df4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003d98:	00067497          	auipc	s1,0x67
    80003d9c:	1504b483          	ld	s1,336(s1) # 8006aee8 <bcache+0x82b0>
    80003da0:	00067797          	auipc	a5,0x67
    80003da4:	10078793          	addi	a5,a5,256 # 8006aea0 <bcache+0x8268>
    80003da8:	00f48863          	beq	s1,a5,80003db8 <bread+0x90>
    80003dac:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003dae:	40bc                	lw	a5,64(s1)
    80003db0:	cf81                	beqz	a5,80003dc8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003db2:	64a4                	ld	s1,72(s1)
    80003db4:	fee49de3          	bne	s1,a4,80003dae <bread+0x86>
  panic("bget: no buffers");
    80003db8:	00007517          	auipc	a0,0x7
    80003dbc:	6e050513          	addi	a0,a0,1760 # 8000b498 <etext+0x498>
    80003dc0:	ffffc097          	auipc	ra,0xffffc
    80003dc4:	7a0080e7          	jalr	1952(ra) # 80000560 <panic>
      b->dev = dev;
    80003dc8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003dcc:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003dd0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003dd4:	4785                	li	a5,1
    80003dd6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003dd8:	0005f517          	auipc	a0,0x5f
    80003ddc:	e6050513          	addi	a0,a0,-416 # 80062c38 <bcache>
    80003de0:	ffffd097          	auipc	ra,0xffffd
    80003de4:	fe4080e7          	jalr	-28(ra) # 80000dc4 <release>
      acquiresleep(&b->lock);
    80003de8:	01048513          	addi	a0,s1,16
    80003dec:	00001097          	auipc	ra,0x1
    80003df0:	434080e7          	jalr	1076(ra) # 80005220 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003df4:	409c                	lw	a5,0(s1)
    80003df6:	cb89                	beqz	a5,80003e08 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003df8:	8526                	mv	a0,s1
    80003dfa:	70a2                	ld	ra,40(sp)
    80003dfc:	7402                	ld	s0,32(sp)
    80003dfe:	64e2                	ld	s1,24(sp)
    80003e00:	6942                	ld	s2,16(sp)
    80003e02:	69a2                	ld	s3,8(sp)
    80003e04:	6145                	addi	sp,sp,48
    80003e06:	8082                	ret
    virtio_disk_rw(b, 0);
    80003e08:	4581                	li	a1,0
    80003e0a:	8526                	mv	a0,s1
    80003e0c:	00003097          	auipc	ra,0x3
    80003e10:	142080e7          	jalr	322(ra) # 80006f4e <virtio_disk_rw>
    b->valid = 1;
    80003e14:	4785                	li	a5,1
    80003e16:	c09c                	sw	a5,0(s1)
  return b;
    80003e18:	b7c5                	j	80003df8 <bread+0xd0>

0000000080003e1a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003e1a:	1101                	addi	sp,sp,-32
    80003e1c:	ec06                	sd	ra,24(sp)
    80003e1e:	e822                	sd	s0,16(sp)
    80003e20:	e426                	sd	s1,8(sp)
    80003e22:	1000                	addi	s0,sp,32
    80003e24:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003e26:	0541                	addi	a0,a0,16
    80003e28:	00001097          	auipc	ra,0x1
    80003e2c:	492080e7          	jalr	1170(ra) # 800052ba <holdingsleep>
    80003e30:	cd01                	beqz	a0,80003e48 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003e32:	4585                	li	a1,1
    80003e34:	8526                	mv	a0,s1
    80003e36:	00003097          	auipc	ra,0x3
    80003e3a:	118080e7          	jalr	280(ra) # 80006f4e <virtio_disk_rw>
}
    80003e3e:	60e2                	ld	ra,24(sp)
    80003e40:	6442                	ld	s0,16(sp)
    80003e42:	64a2                	ld	s1,8(sp)
    80003e44:	6105                	addi	sp,sp,32
    80003e46:	8082                	ret
    panic("bwrite");
    80003e48:	00007517          	auipc	a0,0x7
    80003e4c:	66850513          	addi	a0,a0,1640 # 8000b4b0 <etext+0x4b0>
    80003e50:	ffffc097          	auipc	ra,0xffffc
    80003e54:	710080e7          	jalr	1808(ra) # 80000560 <panic>

0000000080003e58 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003e58:	1101                	addi	sp,sp,-32
    80003e5a:	ec06                	sd	ra,24(sp)
    80003e5c:	e822                	sd	s0,16(sp)
    80003e5e:	e426                	sd	s1,8(sp)
    80003e60:	e04a                	sd	s2,0(sp)
    80003e62:	1000                	addi	s0,sp,32
    80003e64:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003e66:	01050913          	addi	s2,a0,16
    80003e6a:	854a                	mv	a0,s2
    80003e6c:	00001097          	auipc	ra,0x1
    80003e70:	44e080e7          	jalr	1102(ra) # 800052ba <holdingsleep>
    80003e74:	c925                	beqz	a0,80003ee4 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003e76:	854a                	mv	a0,s2
    80003e78:	00001097          	auipc	ra,0x1
    80003e7c:	3fe080e7          	jalr	1022(ra) # 80005276 <releasesleep>

  acquire(&bcache.lock);
    80003e80:	0005f517          	auipc	a0,0x5f
    80003e84:	db850513          	addi	a0,a0,-584 # 80062c38 <bcache>
    80003e88:	ffffd097          	auipc	ra,0xffffd
    80003e8c:	e88080e7          	jalr	-376(ra) # 80000d10 <acquire>
  b->refcnt--;
    80003e90:	40bc                	lw	a5,64(s1)
    80003e92:	37fd                	addiw	a5,a5,-1
    80003e94:	0007871b          	sext.w	a4,a5
    80003e98:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003e9a:	e71d                	bnez	a4,80003ec8 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003e9c:	68b8                	ld	a4,80(s1)
    80003e9e:	64bc                	ld	a5,72(s1)
    80003ea0:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003ea2:	68b8                	ld	a4,80(s1)
    80003ea4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003ea6:	00067797          	auipc	a5,0x67
    80003eaa:	d9278793          	addi	a5,a5,-622 # 8006ac38 <bcache+0x8000>
    80003eae:	2b87b703          	ld	a4,696(a5)
    80003eb2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003eb4:	00067717          	auipc	a4,0x67
    80003eb8:	fec70713          	addi	a4,a4,-20 # 8006aea0 <bcache+0x8268>
    80003ebc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003ebe:	2b87b703          	ld	a4,696(a5)
    80003ec2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003ec4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003ec8:	0005f517          	auipc	a0,0x5f
    80003ecc:	d7050513          	addi	a0,a0,-656 # 80062c38 <bcache>
    80003ed0:	ffffd097          	auipc	ra,0xffffd
    80003ed4:	ef4080e7          	jalr	-268(ra) # 80000dc4 <release>
}
    80003ed8:	60e2                	ld	ra,24(sp)
    80003eda:	6442                	ld	s0,16(sp)
    80003edc:	64a2                	ld	s1,8(sp)
    80003ede:	6902                	ld	s2,0(sp)
    80003ee0:	6105                	addi	sp,sp,32
    80003ee2:	8082                	ret
    panic("brelse");
    80003ee4:	00007517          	auipc	a0,0x7
    80003ee8:	5d450513          	addi	a0,a0,1492 # 8000b4b8 <etext+0x4b8>
    80003eec:	ffffc097          	auipc	ra,0xffffc
    80003ef0:	674080e7          	jalr	1652(ra) # 80000560 <panic>

0000000080003ef4 <bpin>:

void
bpin(struct buf *b) {
    80003ef4:	1101                	addi	sp,sp,-32
    80003ef6:	ec06                	sd	ra,24(sp)
    80003ef8:	e822                	sd	s0,16(sp)
    80003efa:	e426                	sd	s1,8(sp)
    80003efc:	1000                	addi	s0,sp,32
    80003efe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003f00:	0005f517          	auipc	a0,0x5f
    80003f04:	d3850513          	addi	a0,a0,-712 # 80062c38 <bcache>
    80003f08:	ffffd097          	auipc	ra,0xffffd
    80003f0c:	e08080e7          	jalr	-504(ra) # 80000d10 <acquire>
  b->refcnt++;
    80003f10:	40bc                	lw	a5,64(s1)
    80003f12:	2785                	addiw	a5,a5,1
    80003f14:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003f16:	0005f517          	auipc	a0,0x5f
    80003f1a:	d2250513          	addi	a0,a0,-734 # 80062c38 <bcache>
    80003f1e:	ffffd097          	auipc	ra,0xffffd
    80003f22:	ea6080e7          	jalr	-346(ra) # 80000dc4 <release>
}
    80003f26:	60e2                	ld	ra,24(sp)
    80003f28:	6442                	ld	s0,16(sp)
    80003f2a:	64a2                	ld	s1,8(sp)
    80003f2c:	6105                	addi	sp,sp,32
    80003f2e:	8082                	ret

0000000080003f30 <bunpin>:

void
bunpin(struct buf *b) {
    80003f30:	1101                	addi	sp,sp,-32
    80003f32:	ec06                	sd	ra,24(sp)
    80003f34:	e822                	sd	s0,16(sp)
    80003f36:	e426                	sd	s1,8(sp)
    80003f38:	1000                	addi	s0,sp,32
    80003f3a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003f3c:	0005f517          	auipc	a0,0x5f
    80003f40:	cfc50513          	addi	a0,a0,-772 # 80062c38 <bcache>
    80003f44:	ffffd097          	auipc	ra,0xffffd
    80003f48:	dcc080e7          	jalr	-564(ra) # 80000d10 <acquire>
  b->refcnt--;
    80003f4c:	40bc                	lw	a5,64(s1)
    80003f4e:	37fd                	addiw	a5,a5,-1
    80003f50:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003f52:	0005f517          	auipc	a0,0x5f
    80003f56:	ce650513          	addi	a0,a0,-794 # 80062c38 <bcache>
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	e6a080e7          	jalr	-406(ra) # 80000dc4 <release>
}
    80003f62:	60e2                	ld	ra,24(sp)
    80003f64:	6442                	ld	s0,16(sp)
    80003f66:	64a2                	ld	s1,8(sp)
    80003f68:	6105                	addi	sp,sp,32
    80003f6a:	8082                	ret

0000000080003f6c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003f6c:	1101                	addi	sp,sp,-32
    80003f6e:	ec06                	sd	ra,24(sp)
    80003f70:	e822                	sd	s0,16(sp)
    80003f72:	e426                	sd	s1,8(sp)
    80003f74:	e04a                	sd	s2,0(sp)
    80003f76:	1000                	addi	s0,sp,32
    80003f78:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003f7a:	00d5d59b          	srliw	a1,a1,0xd
    80003f7e:	00067797          	auipc	a5,0x67
    80003f82:	3967a783          	lw	a5,918(a5) # 8006b314 <sb+0x1c>
    80003f86:	9dbd                	addw	a1,a1,a5
    80003f88:	00000097          	auipc	ra,0x0
    80003f8c:	da0080e7          	jalr	-608(ra) # 80003d28 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003f90:	0074f713          	andi	a4,s1,7
    80003f94:	4785                	li	a5,1
    80003f96:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003f9a:	14ce                	slli	s1,s1,0x33
    80003f9c:	90d9                	srli	s1,s1,0x36
    80003f9e:	00950733          	add	a4,a0,s1
    80003fa2:	05874703          	lbu	a4,88(a4)
    80003fa6:	00e7f6b3          	and	a3,a5,a4
    80003faa:	c69d                	beqz	a3,80003fd8 <bfree+0x6c>
    80003fac:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003fae:	94aa                	add	s1,s1,a0
    80003fb0:	fff7c793          	not	a5,a5
    80003fb4:	8f7d                	and	a4,a4,a5
    80003fb6:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003fba:	00001097          	auipc	ra,0x1
    80003fbe:	148080e7          	jalr	328(ra) # 80005102 <log_write>
  brelse(bp);
    80003fc2:	854a                	mv	a0,s2
    80003fc4:	00000097          	auipc	ra,0x0
    80003fc8:	e94080e7          	jalr	-364(ra) # 80003e58 <brelse>
}
    80003fcc:	60e2                	ld	ra,24(sp)
    80003fce:	6442                	ld	s0,16(sp)
    80003fd0:	64a2                	ld	s1,8(sp)
    80003fd2:	6902                	ld	s2,0(sp)
    80003fd4:	6105                	addi	sp,sp,32
    80003fd6:	8082                	ret
    panic("freeing free block");
    80003fd8:	00007517          	auipc	a0,0x7
    80003fdc:	4e850513          	addi	a0,a0,1256 # 8000b4c0 <etext+0x4c0>
    80003fe0:	ffffc097          	auipc	ra,0xffffc
    80003fe4:	580080e7          	jalr	1408(ra) # 80000560 <panic>

0000000080003fe8 <balloc>:
{
    80003fe8:	711d                	addi	sp,sp,-96
    80003fea:	ec86                	sd	ra,88(sp)
    80003fec:	e8a2                	sd	s0,80(sp)
    80003fee:	e4a6                	sd	s1,72(sp)
    80003ff0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003ff2:	00067797          	auipc	a5,0x67
    80003ff6:	30a7a783          	lw	a5,778(a5) # 8006b2fc <sb+0x4>
    80003ffa:	10078f63          	beqz	a5,80004118 <balloc+0x130>
    80003ffe:	e0ca                	sd	s2,64(sp)
    80004000:	fc4e                	sd	s3,56(sp)
    80004002:	f852                	sd	s4,48(sp)
    80004004:	f456                	sd	s5,40(sp)
    80004006:	f05a                	sd	s6,32(sp)
    80004008:	ec5e                	sd	s7,24(sp)
    8000400a:	e862                	sd	s8,16(sp)
    8000400c:	e466                	sd	s9,8(sp)
    8000400e:	8baa                	mv	s7,a0
    80004010:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80004012:	00067b17          	auipc	s6,0x67
    80004016:	2e6b0b13          	addi	s6,s6,742 # 8006b2f8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000401a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000401c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000401e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80004020:	6c89                	lui	s9,0x2
    80004022:	a061                	j	800040aa <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004024:	97ca                	add	a5,a5,s2
    80004026:	8e55                	or	a2,a2,a3
    80004028:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000402c:	854a                	mv	a0,s2
    8000402e:	00001097          	auipc	ra,0x1
    80004032:	0d4080e7          	jalr	212(ra) # 80005102 <log_write>
        brelse(bp);
    80004036:	854a                	mv	a0,s2
    80004038:	00000097          	auipc	ra,0x0
    8000403c:	e20080e7          	jalr	-480(ra) # 80003e58 <brelse>
  bp = bread(dev, bno);
    80004040:	85a6                	mv	a1,s1
    80004042:	855e                	mv	a0,s7
    80004044:	00000097          	auipc	ra,0x0
    80004048:	ce4080e7          	jalr	-796(ra) # 80003d28 <bread>
    8000404c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000404e:	40000613          	li	a2,1024
    80004052:	4581                	li	a1,0
    80004054:	05850513          	addi	a0,a0,88
    80004058:	ffffd097          	auipc	ra,0xffffd
    8000405c:	db4080e7          	jalr	-588(ra) # 80000e0c <memset>
  log_write(bp);
    80004060:	854a                	mv	a0,s2
    80004062:	00001097          	auipc	ra,0x1
    80004066:	0a0080e7          	jalr	160(ra) # 80005102 <log_write>
  brelse(bp);
    8000406a:	854a                	mv	a0,s2
    8000406c:	00000097          	auipc	ra,0x0
    80004070:	dec080e7          	jalr	-532(ra) # 80003e58 <brelse>
}
    80004074:	6906                	ld	s2,64(sp)
    80004076:	79e2                	ld	s3,56(sp)
    80004078:	7a42                	ld	s4,48(sp)
    8000407a:	7aa2                	ld	s5,40(sp)
    8000407c:	7b02                	ld	s6,32(sp)
    8000407e:	6be2                	ld	s7,24(sp)
    80004080:	6c42                	ld	s8,16(sp)
    80004082:	6ca2                	ld	s9,8(sp)
}
    80004084:	8526                	mv	a0,s1
    80004086:	60e6                	ld	ra,88(sp)
    80004088:	6446                	ld	s0,80(sp)
    8000408a:	64a6                	ld	s1,72(sp)
    8000408c:	6125                	addi	sp,sp,96
    8000408e:	8082                	ret
    brelse(bp);
    80004090:	854a                	mv	a0,s2
    80004092:	00000097          	auipc	ra,0x0
    80004096:	dc6080e7          	jalr	-570(ra) # 80003e58 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000409a:	015c87bb          	addw	a5,s9,s5
    8000409e:	00078a9b          	sext.w	s5,a5
    800040a2:	004b2703          	lw	a4,4(s6)
    800040a6:	06eaf163          	bgeu	s5,a4,80004108 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    800040aa:	41fad79b          	sraiw	a5,s5,0x1f
    800040ae:	0137d79b          	srliw	a5,a5,0x13
    800040b2:	015787bb          	addw	a5,a5,s5
    800040b6:	40d7d79b          	sraiw	a5,a5,0xd
    800040ba:	01cb2583          	lw	a1,28(s6)
    800040be:	9dbd                	addw	a1,a1,a5
    800040c0:	855e                	mv	a0,s7
    800040c2:	00000097          	auipc	ra,0x0
    800040c6:	c66080e7          	jalr	-922(ra) # 80003d28 <bread>
    800040ca:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800040cc:	004b2503          	lw	a0,4(s6)
    800040d0:	000a849b          	sext.w	s1,s5
    800040d4:	8762                	mv	a4,s8
    800040d6:	faa4fde3          	bgeu	s1,a0,80004090 <balloc+0xa8>
      m = 1 << (bi % 8);
    800040da:	00777693          	andi	a3,a4,7
    800040de:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800040e2:	41f7579b          	sraiw	a5,a4,0x1f
    800040e6:	01d7d79b          	srliw	a5,a5,0x1d
    800040ea:	9fb9                	addw	a5,a5,a4
    800040ec:	4037d79b          	sraiw	a5,a5,0x3
    800040f0:	00f90633          	add	a2,s2,a5
    800040f4:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800040f8:	00c6f5b3          	and	a1,a3,a2
    800040fc:	d585                	beqz	a1,80004024 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800040fe:	2705                	addiw	a4,a4,1
    80004100:	2485                	addiw	s1,s1,1
    80004102:	fd471ae3          	bne	a4,s4,800040d6 <balloc+0xee>
    80004106:	b769                	j	80004090 <balloc+0xa8>
    80004108:	6906                	ld	s2,64(sp)
    8000410a:	79e2                	ld	s3,56(sp)
    8000410c:	7a42                	ld	s4,48(sp)
    8000410e:	7aa2                	ld	s5,40(sp)
    80004110:	7b02                	ld	s6,32(sp)
    80004112:	6be2                	ld	s7,24(sp)
    80004114:	6c42                	ld	s8,16(sp)
    80004116:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80004118:	00007517          	auipc	a0,0x7
    8000411c:	3c050513          	addi	a0,a0,960 # 8000b4d8 <etext+0x4d8>
    80004120:	ffffc097          	auipc	ra,0xffffc
    80004124:	48a080e7          	jalr	1162(ra) # 800005aa <printf>
  return 0;
    80004128:	4481                	li	s1,0
    8000412a:	bfa9                	j	80004084 <balloc+0x9c>

000000008000412c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000412c:	7179                	addi	sp,sp,-48
    8000412e:	f406                	sd	ra,40(sp)
    80004130:	f022                	sd	s0,32(sp)
    80004132:	ec26                	sd	s1,24(sp)
    80004134:	e84a                	sd	s2,16(sp)
    80004136:	e44e                	sd	s3,8(sp)
    80004138:	1800                	addi	s0,sp,48
    8000413a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000413c:	47ad                	li	a5,11
    8000413e:	02b7e863          	bltu	a5,a1,8000416e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80004142:	02059793          	slli	a5,a1,0x20
    80004146:	01e7d593          	srli	a1,a5,0x1e
    8000414a:	00b504b3          	add	s1,a0,a1
    8000414e:	0504a903          	lw	s2,80(s1)
    80004152:	08091263          	bnez	s2,800041d6 <bmap+0xaa>
      addr = balloc(ip->dev);
    80004156:	4108                	lw	a0,0(a0)
    80004158:	00000097          	auipc	ra,0x0
    8000415c:	e90080e7          	jalr	-368(ra) # 80003fe8 <balloc>
    80004160:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80004164:	06090963          	beqz	s2,800041d6 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80004168:	0524a823          	sw	s2,80(s1)
    8000416c:	a0ad                	j	800041d6 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000416e:	ff45849b          	addiw	s1,a1,-12
    80004172:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80004176:	0ff00793          	li	a5,255
    8000417a:	08e7e863          	bltu	a5,a4,8000420a <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000417e:	08052903          	lw	s2,128(a0)
    80004182:	00091f63          	bnez	s2,800041a0 <bmap+0x74>
      addr = balloc(ip->dev);
    80004186:	4108                	lw	a0,0(a0)
    80004188:	00000097          	auipc	ra,0x0
    8000418c:	e60080e7          	jalr	-416(ra) # 80003fe8 <balloc>
    80004190:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80004194:	04090163          	beqz	s2,800041d6 <bmap+0xaa>
    80004198:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000419a:	0929a023          	sw	s2,128(s3)
    8000419e:	a011                	j	800041a2 <bmap+0x76>
    800041a0:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800041a2:	85ca                	mv	a1,s2
    800041a4:	0009a503          	lw	a0,0(s3)
    800041a8:	00000097          	auipc	ra,0x0
    800041ac:	b80080e7          	jalr	-1152(ra) # 80003d28 <bread>
    800041b0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800041b2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800041b6:	02049713          	slli	a4,s1,0x20
    800041ba:	01e75593          	srli	a1,a4,0x1e
    800041be:	00b784b3          	add	s1,a5,a1
    800041c2:	0004a903          	lw	s2,0(s1)
    800041c6:	02090063          	beqz	s2,800041e6 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800041ca:	8552                	mv	a0,s4
    800041cc:	00000097          	auipc	ra,0x0
    800041d0:	c8c080e7          	jalr	-884(ra) # 80003e58 <brelse>
    return addr;
    800041d4:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800041d6:	854a                	mv	a0,s2
    800041d8:	70a2                	ld	ra,40(sp)
    800041da:	7402                	ld	s0,32(sp)
    800041dc:	64e2                	ld	s1,24(sp)
    800041de:	6942                	ld	s2,16(sp)
    800041e0:	69a2                	ld	s3,8(sp)
    800041e2:	6145                	addi	sp,sp,48
    800041e4:	8082                	ret
      addr = balloc(ip->dev);
    800041e6:	0009a503          	lw	a0,0(s3)
    800041ea:	00000097          	auipc	ra,0x0
    800041ee:	dfe080e7          	jalr	-514(ra) # 80003fe8 <balloc>
    800041f2:	0005091b          	sext.w	s2,a0
      if(addr){
    800041f6:	fc090ae3          	beqz	s2,800041ca <bmap+0x9e>
        a[bn] = addr;
    800041fa:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800041fe:	8552                	mv	a0,s4
    80004200:	00001097          	auipc	ra,0x1
    80004204:	f02080e7          	jalr	-254(ra) # 80005102 <log_write>
    80004208:	b7c9                	j	800041ca <bmap+0x9e>
    8000420a:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000420c:	00007517          	auipc	a0,0x7
    80004210:	2e450513          	addi	a0,a0,740 # 8000b4f0 <etext+0x4f0>
    80004214:	ffffc097          	auipc	ra,0xffffc
    80004218:	34c080e7          	jalr	844(ra) # 80000560 <panic>

000000008000421c <iget>:
{
    8000421c:	7179                	addi	sp,sp,-48
    8000421e:	f406                	sd	ra,40(sp)
    80004220:	f022                	sd	s0,32(sp)
    80004222:	ec26                	sd	s1,24(sp)
    80004224:	e84a                	sd	s2,16(sp)
    80004226:	e44e                	sd	s3,8(sp)
    80004228:	e052                	sd	s4,0(sp)
    8000422a:	1800                	addi	s0,sp,48
    8000422c:	89aa                	mv	s3,a0
    8000422e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80004230:	00067517          	auipc	a0,0x67
    80004234:	0e850513          	addi	a0,a0,232 # 8006b318 <itable>
    80004238:	ffffd097          	auipc	ra,0xffffd
    8000423c:	ad8080e7          	jalr	-1320(ra) # 80000d10 <acquire>
  empty = 0;
    80004240:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004242:	00067497          	auipc	s1,0x67
    80004246:	0ee48493          	addi	s1,s1,238 # 8006b330 <itable+0x18>
    8000424a:	00069697          	auipc	a3,0x69
    8000424e:	b7668693          	addi	a3,a3,-1162 # 8006cdc0 <log>
    80004252:	a039                	j	80004260 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004254:	02090b63          	beqz	s2,8000428a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004258:	08848493          	addi	s1,s1,136
    8000425c:	02d48a63          	beq	s1,a3,80004290 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80004260:	449c                	lw	a5,8(s1)
    80004262:	fef059e3          	blez	a5,80004254 <iget+0x38>
    80004266:	4098                	lw	a4,0(s1)
    80004268:	ff3716e3          	bne	a4,s3,80004254 <iget+0x38>
    8000426c:	40d8                	lw	a4,4(s1)
    8000426e:	ff4713e3          	bne	a4,s4,80004254 <iget+0x38>
      ip->ref++;
    80004272:	2785                	addiw	a5,a5,1
    80004274:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80004276:	00067517          	auipc	a0,0x67
    8000427a:	0a250513          	addi	a0,a0,162 # 8006b318 <itable>
    8000427e:	ffffd097          	auipc	ra,0xffffd
    80004282:	b46080e7          	jalr	-1210(ra) # 80000dc4 <release>
      return ip;
    80004286:	8926                	mv	s2,s1
    80004288:	a03d                	j	800042b6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000428a:	f7f9                	bnez	a5,80004258 <iget+0x3c>
      empty = ip;
    8000428c:	8926                	mv	s2,s1
    8000428e:	b7e9                	j	80004258 <iget+0x3c>
  if(empty == 0)
    80004290:	02090c63          	beqz	s2,800042c8 <iget+0xac>
  ip->dev = dev;
    80004294:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004298:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000429c:	4785                	li	a5,1
    8000429e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800042a2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800042a6:	00067517          	auipc	a0,0x67
    800042aa:	07250513          	addi	a0,a0,114 # 8006b318 <itable>
    800042ae:	ffffd097          	auipc	ra,0xffffd
    800042b2:	b16080e7          	jalr	-1258(ra) # 80000dc4 <release>
}
    800042b6:	854a                	mv	a0,s2
    800042b8:	70a2                	ld	ra,40(sp)
    800042ba:	7402                	ld	s0,32(sp)
    800042bc:	64e2                	ld	s1,24(sp)
    800042be:	6942                	ld	s2,16(sp)
    800042c0:	69a2                	ld	s3,8(sp)
    800042c2:	6a02                	ld	s4,0(sp)
    800042c4:	6145                	addi	sp,sp,48
    800042c6:	8082                	ret
    panic("iget: no inodes");
    800042c8:	00007517          	auipc	a0,0x7
    800042cc:	24050513          	addi	a0,a0,576 # 8000b508 <etext+0x508>
    800042d0:	ffffc097          	auipc	ra,0xffffc
    800042d4:	290080e7          	jalr	656(ra) # 80000560 <panic>

00000000800042d8 <fsinit>:
fsinit(int dev) {
    800042d8:	7179                	addi	sp,sp,-48
    800042da:	f406                	sd	ra,40(sp)
    800042dc:	f022                	sd	s0,32(sp)
    800042de:	ec26                	sd	s1,24(sp)
    800042e0:	e84a                	sd	s2,16(sp)
    800042e2:	e44e                	sd	s3,8(sp)
    800042e4:	1800                	addi	s0,sp,48
    800042e6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800042e8:	4585                	li	a1,1
    800042ea:	00000097          	auipc	ra,0x0
    800042ee:	a3e080e7          	jalr	-1474(ra) # 80003d28 <bread>
    800042f2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800042f4:	00067997          	auipc	s3,0x67
    800042f8:	00498993          	addi	s3,s3,4 # 8006b2f8 <sb>
    800042fc:	02000613          	li	a2,32
    80004300:	05850593          	addi	a1,a0,88
    80004304:	854e                	mv	a0,s3
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	b62080e7          	jalr	-1182(ra) # 80000e68 <memmove>
  brelse(bp);
    8000430e:	8526                	mv	a0,s1
    80004310:	00000097          	auipc	ra,0x0
    80004314:	b48080e7          	jalr	-1208(ra) # 80003e58 <brelse>
  if(sb.magic != FSMAGIC)
    80004318:	0009a703          	lw	a4,0(s3)
    8000431c:	102037b7          	lui	a5,0x10203
    80004320:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004324:	02f71263          	bne	a4,a5,80004348 <fsinit+0x70>
  initlog(dev, &sb);
    80004328:	00067597          	auipc	a1,0x67
    8000432c:	fd058593          	addi	a1,a1,-48 # 8006b2f8 <sb>
    80004330:	854a                	mv	a0,s2
    80004332:	00001097          	auipc	ra,0x1
    80004336:	b60080e7          	jalr	-1184(ra) # 80004e92 <initlog>
}
    8000433a:	70a2                	ld	ra,40(sp)
    8000433c:	7402                	ld	s0,32(sp)
    8000433e:	64e2                	ld	s1,24(sp)
    80004340:	6942                	ld	s2,16(sp)
    80004342:	69a2                	ld	s3,8(sp)
    80004344:	6145                	addi	sp,sp,48
    80004346:	8082                	ret
    panic("invalid file system");
    80004348:	00007517          	auipc	a0,0x7
    8000434c:	1d050513          	addi	a0,a0,464 # 8000b518 <etext+0x518>
    80004350:	ffffc097          	auipc	ra,0xffffc
    80004354:	210080e7          	jalr	528(ra) # 80000560 <panic>

0000000080004358 <iinit>:
{
    80004358:	7179                	addi	sp,sp,-48
    8000435a:	f406                	sd	ra,40(sp)
    8000435c:	f022                	sd	s0,32(sp)
    8000435e:	ec26                	sd	s1,24(sp)
    80004360:	e84a                	sd	s2,16(sp)
    80004362:	e44e                	sd	s3,8(sp)
    80004364:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80004366:	00007597          	auipc	a1,0x7
    8000436a:	1ca58593          	addi	a1,a1,458 # 8000b530 <etext+0x530>
    8000436e:	00067517          	auipc	a0,0x67
    80004372:	faa50513          	addi	a0,a0,-86 # 8006b318 <itable>
    80004376:	ffffd097          	auipc	ra,0xffffd
    8000437a:	90a080e7          	jalr	-1782(ra) # 80000c80 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000437e:	00067497          	auipc	s1,0x67
    80004382:	fc248493          	addi	s1,s1,-62 # 8006b340 <itable+0x28>
    80004386:	00069997          	auipc	s3,0x69
    8000438a:	a4a98993          	addi	s3,s3,-1462 # 8006cdd0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000438e:	00007917          	auipc	s2,0x7
    80004392:	1aa90913          	addi	s2,s2,426 # 8000b538 <etext+0x538>
    80004396:	85ca                	mv	a1,s2
    80004398:	8526                	mv	a0,s1
    8000439a:	00001097          	auipc	ra,0x1
    8000439e:	e4c080e7          	jalr	-436(ra) # 800051e6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800043a2:	08848493          	addi	s1,s1,136
    800043a6:	ff3498e3          	bne	s1,s3,80004396 <iinit+0x3e>
}
    800043aa:	70a2                	ld	ra,40(sp)
    800043ac:	7402                	ld	s0,32(sp)
    800043ae:	64e2                	ld	s1,24(sp)
    800043b0:	6942                	ld	s2,16(sp)
    800043b2:	69a2                	ld	s3,8(sp)
    800043b4:	6145                	addi	sp,sp,48
    800043b6:	8082                	ret

00000000800043b8 <ialloc>:
{
    800043b8:	7139                	addi	sp,sp,-64
    800043ba:	fc06                	sd	ra,56(sp)
    800043bc:	f822                	sd	s0,48(sp)
    800043be:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800043c0:	00067717          	auipc	a4,0x67
    800043c4:	f4472703          	lw	a4,-188(a4) # 8006b304 <sb+0xc>
    800043c8:	4785                	li	a5,1
    800043ca:	06e7f463          	bgeu	a5,a4,80004432 <ialloc+0x7a>
    800043ce:	f426                	sd	s1,40(sp)
    800043d0:	f04a                	sd	s2,32(sp)
    800043d2:	ec4e                	sd	s3,24(sp)
    800043d4:	e852                	sd	s4,16(sp)
    800043d6:	e456                	sd	s5,8(sp)
    800043d8:	e05a                	sd	s6,0(sp)
    800043da:	8aaa                	mv	s5,a0
    800043dc:	8b2e                	mv	s6,a1
    800043de:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800043e0:	00067a17          	auipc	s4,0x67
    800043e4:	f18a0a13          	addi	s4,s4,-232 # 8006b2f8 <sb>
    800043e8:	00495593          	srli	a1,s2,0x4
    800043ec:	018a2783          	lw	a5,24(s4)
    800043f0:	9dbd                	addw	a1,a1,a5
    800043f2:	8556                	mv	a0,s5
    800043f4:	00000097          	auipc	ra,0x0
    800043f8:	934080e7          	jalr	-1740(ra) # 80003d28 <bread>
    800043fc:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800043fe:	05850993          	addi	s3,a0,88
    80004402:	00f97793          	andi	a5,s2,15
    80004406:	079a                	slli	a5,a5,0x6
    80004408:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000440a:	00099783          	lh	a5,0(s3)
    8000440e:	cf9d                	beqz	a5,8000444c <ialloc+0x94>
    brelse(bp);
    80004410:	00000097          	auipc	ra,0x0
    80004414:	a48080e7          	jalr	-1464(ra) # 80003e58 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004418:	0905                	addi	s2,s2,1
    8000441a:	00ca2703          	lw	a4,12(s4)
    8000441e:	0009079b          	sext.w	a5,s2
    80004422:	fce7e3e3          	bltu	a5,a4,800043e8 <ialloc+0x30>
    80004426:	74a2                	ld	s1,40(sp)
    80004428:	7902                	ld	s2,32(sp)
    8000442a:	69e2                	ld	s3,24(sp)
    8000442c:	6a42                	ld	s4,16(sp)
    8000442e:	6aa2                	ld	s5,8(sp)
    80004430:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80004432:	00007517          	auipc	a0,0x7
    80004436:	10e50513          	addi	a0,a0,270 # 8000b540 <etext+0x540>
    8000443a:	ffffc097          	auipc	ra,0xffffc
    8000443e:	170080e7          	jalr	368(ra) # 800005aa <printf>
  return 0;
    80004442:	4501                	li	a0,0
}
    80004444:	70e2                	ld	ra,56(sp)
    80004446:	7442                	ld	s0,48(sp)
    80004448:	6121                	addi	sp,sp,64
    8000444a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000444c:	04000613          	li	a2,64
    80004450:	4581                	li	a1,0
    80004452:	854e                	mv	a0,s3
    80004454:	ffffd097          	auipc	ra,0xffffd
    80004458:	9b8080e7          	jalr	-1608(ra) # 80000e0c <memset>
      dip->type = type;
    8000445c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80004460:	8526                	mv	a0,s1
    80004462:	00001097          	auipc	ra,0x1
    80004466:	ca0080e7          	jalr	-864(ra) # 80005102 <log_write>
      brelse(bp);
    8000446a:	8526                	mv	a0,s1
    8000446c:	00000097          	auipc	ra,0x0
    80004470:	9ec080e7          	jalr	-1556(ra) # 80003e58 <brelse>
      return iget(dev, inum);
    80004474:	0009059b          	sext.w	a1,s2
    80004478:	8556                	mv	a0,s5
    8000447a:	00000097          	auipc	ra,0x0
    8000447e:	da2080e7          	jalr	-606(ra) # 8000421c <iget>
    80004482:	74a2                	ld	s1,40(sp)
    80004484:	7902                	ld	s2,32(sp)
    80004486:	69e2                	ld	s3,24(sp)
    80004488:	6a42                	ld	s4,16(sp)
    8000448a:	6aa2                	ld	s5,8(sp)
    8000448c:	6b02                	ld	s6,0(sp)
    8000448e:	bf5d                	j	80004444 <ialloc+0x8c>

0000000080004490 <iupdate>:
{
    80004490:	1101                	addi	sp,sp,-32
    80004492:	ec06                	sd	ra,24(sp)
    80004494:	e822                	sd	s0,16(sp)
    80004496:	e426                	sd	s1,8(sp)
    80004498:	e04a                	sd	s2,0(sp)
    8000449a:	1000                	addi	s0,sp,32
    8000449c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000449e:	415c                	lw	a5,4(a0)
    800044a0:	0047d79b          	srliw	a5,a5,0x4
    800044a4:	00067597          	auipc	a1,0x67
    800044a8:	e6c5a583          	lw	a1,-404(a1) # 8006b310 <sb+0x18>
    800044ac:	9dbd                	addw	a1,a1,a5
    800044ae:	4108                	lw	a0,0(a0)
    800044b0:	00000097          	auipc	ra,0x0
    800044b4:	878080e7          	jalr	-1928(ra) # 80003d28 <bread>
    800044b8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800044ba:	05850793          	addi	a5,a0,88
    800044be:	40d8                	lw	a4,4(s1)
    800044c0:	8b3d                	andi	a4,a4,15
    800044c2:	071a                	slli	a4,a4,0x6
    800044c4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800044c6:	04449703          	lh	a4,68(s1)
    800044ca:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800044ce:	04649703          	lh	a4,70(s1)
    800044d2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800044d6:	04849703          	lh	a4,72(s1)
    800044da:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800044de:	04a49703          	lh	a4,74(s1)
    800044e2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800044e6:	44f8                	lw	a4,76(s1)
    800044e8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800044ea:	03400613          	li	a2,52
    800044ee:	05048593          	addi	a1,s1,80
    800044f2:	00c78513          	addi	a0,a5,12
    800044f6:	ffffd097          	auipc	ra,0xffffd
    800044fa:	972080e7          	jalr	-1678(ra) # 80000e68 <memmove>
  log_write(bp);
    800044fe:	854a                	mv	a0,s2
    80004500:	00001097          	auipc	ra,0x1
    80004504:	c02080e7          	jalr	-1022(ra) # 80005102 <log_write>
  brelse(bp);
    80004508:	854a                	mv	a0,s2
    8000450a:	00000097          	auipc	ra,0x0
    8000450e:	94e080e7          	jalr	-1714(ra) # 80003e58 <brelse>
}
    80004512:	60e2                	ld	ra,24(sp)
    80004514:	6442                	ld	s0,16(sp)
    80004516:	64a2                	ld	s1,8(sp)
    80004518:	6902                	ld	s2,0(sp)
    8000451a:	6105                	addi	sp,sp,32
    8000451c:	8082                	ret

000000008000451e <idup>:
{
    8000451e:	1101                	addi	sp,sp,-32
    80004520:	ec06                	sd	ra,24(sp)
    80004522:	e822                	sd	s0,16(sp)
    80004524:	e426                	sd	s1,8(sp)
    80004526:	1000                	addi	s0,sp,32
    80004528:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000452a:	00067517          	auipc	a0,0x67
    8000452e:	dee50513          	addi	a0,a0,-530 # 8006b318 <itable>
    80004532:	ffffc097          	auipc	ra,0xffffc
    80004536:	7de080e7          	jalr	2014(ra) # 80000d10 <acquire>
  ip->ref++;
    8000453a:	449c                	lw	a5,8(s1)
    8000453c:	2785                	addiw	a5,a5,1
    8000453e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004540:	00067517          	auipc	a0,0x67
    80004544:	dd850513          	addi	a0,a0,-552 # 8006b318 <itable>
    80004548:	ffffd097          	auipc	ra,0xffffd
    8000454c:	87c080e7          	jalr	-1924(ra) # 80000dc4 <release>
}
    80004550:	8526                	mv	a0,s1
    80004552:	60e2                	ld	ra,24(sp)
    80004554:	6442                	ld	s0,16(sp)
    80004556:	64a2                	ld	s1,8(sp)
    80004558:	6105                	addi	sp,sp,32
    8000455a:	8082                	ret

000000008000455c <ilock>:
{
    8000455c:	1101                	addi	sp,sp,-32
    8000455e:	ec06                	sd	ra,24(sp)
    80004560:	e822                	sd	s0,16(sp)
    80004562:	e426                	sd	s1,8(sp)
    80004564:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004566:	c10d                	beqz	a0,80004588 <ilock+0x2c>
    80004568:	84aa                	mv	s1,a0
    8000456a:	451c                	lw	a5,8(a0)
    8000456c:	00f05e63          	blez	a5,80004588 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80004570:	0541                	addi	a0,a0,16
    80004572:	00001097          	auipc	ra,0x1
    80004576:	cae080e7          	jalr	-850(ra) # 80005220 <acquiresleep>
  if(ip->valid == 0){
    8000457a:	40bc                	lw	a5,64(s1)
    8000457c:	cf99                	beqz	a5,8000459a <ilock+0x3e>
}
    8000457e:	60e2                	ld	ra,24(sp)
    80004580:	6442                	ld	s0,16(sp)
    80004582:	64a2                	ld	s1,8(sp)
    80004584:	6105                	addi	sp,sp,32
    80004586:	8082                	ret
    80004588:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000458a:	00007517          	auipc	a0,0x7
    8000458e:	fce50513          	addi	a0,a0,-50 # 8000b558 <etext+0x558>
    80004592:	ffffc097          	auipc	ra,0xffffc
    80004596:	fce080e7          	jalr	-50(ra) # 80000560 <panic>
    8000459a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000459c:	40dc                	lw	a5,4(s1)
    8000459e:	0047d79b          	srliw	a5,a5,0x4
    800045a2:	00067597          	auipc	a1,0x67
    800045a6:	d6e5a583          	lw	a1,-658(a1) # 8006b310 <sb+0x18>
    800045aa:	9dbd                	addw	a1,a1,a5
    800045ac:	4088                	lw	a0,0(s1)
    800045ae:	fffff097          	auipc	ra,0xfffff
    800045b2:	77a080e7          	jalr	1914(ra) # 80003d28 <bread>
    800045b6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800045b8:	05850593          	addi	a1,a0,88
    800045bc:	40dc                	lw	a5,4(s1)
    800045be:	8bbd                	andi	a5,a5,15
    800045c0:	079a                	slli	a5,a5,0x6
    800045c2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800045c4:	00059783          	lh	a5,0(a1)
    800045c8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800045cc:	00259783          	lh	a5,2(a1)
    800045d0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800045d4:	00459783          	lh	a5,4(a1)
    800045d8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800045dc:	00659783          	lh	a5,6(a1)
    800045e0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800045e4:	459c                	lw	a5,8(a1)
    800045e6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800045e8:	03400613          	li	a2,52
    800045ec:	05b1                	addi	a1,a1,12
    800045ee:	05048513          	addi	a0,s1,80
    800045f2:	ffffd097          	auipc	ra,0xffffd
    800045f6:	876080e7          	jalr	-1930(ra) # 80000e68 <memmove>
    brelse(bp);
    800045fa:	854a                	mv	a0,s2
    800045fc:	00000097          	auipc	ra,0x0
    80004600:	85c080e7          	jalr	-1956(ra) # 80003e58 <brelse>
    ip->valid = 1;
    80004604:	4785                	li	a5,1
    80004606:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80004608:	04449783          	lh	a5,68(s1)
    8000460c:	c399                	beqz	a5,80004612 <ilock+0xb6>
    8000460e:	6902                	ld	s2,0(sp)
    80004610:	b7bd                	j	8000457e <ilock+0x22>
      panic("ilock: no type");
    80004612:	00007517          	auipc	a0,0x7
    80004616:	f4e50513          	addi	a0,a0,-178 # 8000b560 <etext+0x560>
    8000461a:	ffffc097          	auipc	ra,0xffffc
    8000461e:	f46080e7          	jalr	-186(ra) # 80000560 <panic>

0000000080004622 <iunlock>:
{
    80004622:	1101                	addi	sp,sp,-32
    80004624:	ec06                	sd	ra,24(sp)
    80004626:	e822                	sd	s0,16(sp)
    80004628:	e426                	sd	s1,8(sp)
    8000462a:	e04a                	sd	s2,0(sp)
    8000462c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000462e:	c905                	beqz	a0,8000465e <iunlock+0x3c>
    80004630:	84aa                	mv	s1,a0
    80004632:	01050913          	addi	s2,a0,16
    80004636:	854a                	mv	a0,s2
    80004638:	00001097          	auipc	ra,0x1
    8000463c:	c82080e7          	jalr	-894(ra) # 800052ba <holdingsleep>
    80004640:	cd19                	beqz	a0,8000465e <iunlock+0x3c>
    80004642:	449c                	lw	a5,8(s1)
    80004644:	00f05d63          	blez	a5,8000465e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80004648:	854a                	mv	a0,s2
    8000464a:	00001097          	auipc	ra,0x1
    8000464e:	c2c080e7          	jalr	-980(ra) # 80005276 <releasesleep>
}
    80004652:	60e2                	ld	ra,24(sp)
    80004654:	6442                	ld	s0,16(sp)
    80004656:	64a2                	ld	s1,8(sp)
    80004658:	6902                	ld	s2,0(sp)
    8000465a:	6105                	addi	sp,sp,32
    8000465c:	8082                	ret
    panic("iunlock");
    8000465e:	00007517          	auipc	a0,0x7
    80004662:	f1250513          	addi	a0,a0,-238 # 8000b570 <etext+0x570>
    80004666:	ffffc097          	auipc	ra,0xffffc
    8000466a:	efa080e7          	jalr	-262(ra) # 80000560 <panic>

000000008000466e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000466e:	7179                	addi	sp,sp,-48
    80004670:	f406                	sd	ra,40(sp)
    80004672:	f022                	sd	s0,32(sp)
    80004674:	ec26                	sd	s1,24(sp)
    80004676:	e84a                	sd	s2,16(sp)
    80004678:	e44e                	sd	s3,8(sp)
    8000467a:	1800                	addi	s0,sp,48
    8000467c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000467e:	05050493          	addi	s1,a0,80
    80004682:	08050913          	addi	s2,a0,128
    80004686:	a021                	j	8000468e <itrunc+0x20>
    80004688:	0491                	addi	s1,s1,4
    8000468a:	01248d63          	beq	s1,s2,800046a4 <itrunc+0x36>
    if(ip->addrs[i]){
    8000468e:	408c                	lw	a1,0(s1)
    80004690:	dde5                	beqz	a1,80004688 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80004692:	0009a503          	lw	a0,0(s3)
    80004696:	00000097          	auipc	ra,0x0
    8000469a:	8d6080e7          	jalr	-1834(ra) # 80003f6c <bfree>
      ip->addrs[i] = 0;
    8000469e:	0004a023          	sw	zero,0(s1)
    800046a2:	b7dd                	j	80004688 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800046a4:	0809a583          	lw	a1,128(s3)
    800046a8:	ed99                	bnez	a1,800046c6 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800046aa:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800046ae:	854e                	mv	a0,s3
    800046b0:	00000097          	auipc	ra,0x0
    800046b4:	de0080e7          	jalr	-544(ra) # 80004490 <iupdate>
}
    800046b8:	70a2                	ld	ra,40(sp)
    800046ba:	7402                	ld	s0,32(sp)
    800046bc:	64e2                	ld	s1,24(sp)
    800046be:	6942                	ld	s2,16(sp)
    800046c0:	69a2                	ld	s3,8(sp)
    800046c2:	6145                	addi	sp,sp,48
    800046c4:	8082                	ret
    800046c6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800046c8:	0009a503          	lw	a0,0(s3)
    800046cc:	fffff097          	auipc	ra,0xfffff
    800046d0:	65c080e7          	jalr	1628(ra) # 80003d28 <bread>
    800046d4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800046d6:	05850493          	addi	s1,a0,88
    800046da:	45850913          	addi	s2,a0,1112
    800046de:	a021                	j	800046e6 <itrunc+0x78>
    800046e0:	0491                	addi	s1,s1,4
    800046e2:	01248b63          	beq	s1,s2,800046f8 <itrunc+0x8a>
      if(a[j])
    800046e6:	408c                	lw	a1,0(s1)
    800046e8:	dde5                	beqz	a1,800046e0 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    800046ea:	0009a503          	lw	a0,0(s3)
    800046ee:	00000097          	auipc	ra,0x0
    800046f2:	87e080e7          	jalr	-1922(ra) # 80003f6c <bfree>
    800046f6:	b7ed                	j	800046e0 <itrunc+0x72>
    brelse(bp);
    800046f8:	8552                	mv	a0,s4
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	75e080e7          	jalr	1886(ra) # 80003e58 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004702:	0809a583          	lw	a1,128(s3)
    80004706:	0009a503          	lw	a0,0(s3)
    8000470a:	00000097          	auipc	ra,0x0
    8000470e:	862080e7          	jalr	-1950(ra) # 80003f6c <bfree>
    ip->addrs[NDIRECT] = 0;
    80004712:	0809a023          	sw	zero,128(s3)
    80004716:	6a02                	ld	s4,0(sp)
    80004718:	bf49                	j	800046aa <itrunc+0x3c>

000000008000471a <iput>:
{
    8000471a:	1101                	addi	sp,sp,-32
    8000471c:	ec06                	sd	ra,24(sp)
    8000471e:	e822                	sd	s0,16(sp)
    80004720:	e426                	sd	s1,8(sp)
    80004722:	1000                	addi	s0,sp,32
    80004724:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004726:	00067517          	auipc	a0,0x67
    8000472a:	bf250513          	addi	a0,a0,-1038 # 8006b318 <itable>
    8000472e:	ffffc097          	auipc	ra,0xffffc
    80004732:	5e2080e7          	jalr	1506(ra) # 80000d10 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004736:	4498                	lw	a4,8(s1)
    80004738:	4785                	li	a5,1
    8000473a:	02f70263          	beq	a4,a5,8000475e <iput+0x44>
  ip->ref--;
    8000473e:	449c                	lw	a5,8(s1)
    80004740:	37fd                	addiw	a5,a5,-1
    80004742:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004744:	00067517          	auipc	a0,0x67
    80004748:	bd450513          	addi	a0,a0,-1068 # 8006b318 <itable>
    8000474c:	ffffc097          	auipc	ra,0xffffc
    80004750:	678080e7          	jalr	1656(ra) # 80000dc4 <release>
}
    80004754:	60e2                	ld	ra,24(sp)
    80004756:	6442                	ld	s0,16(sp)
    80004758:	64a2                	ld	s1,8(sp)
    8000475a:	6105                	addi	sp,sp,32
    8000475c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000475e:	40bc                	lw	a5,64(s1)
    80004760:	dff9                	beqz	a5,8000473e <iput+0x24>
    80004762:	04a49783          	lh	a5,74(s1)
    80004766:	ffe1                	bnez	a5,8000473e <iput+0x24>
    80004768:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000476a:	01048913          	addi	s2,s1,16
    8000476e:	854a                	mv	a0,s2
    80004770:	00001097          	auipc	ra,0x1
    80004774:	ab0080e7          	jalr	-1360(ra) # 80005220 <acquiresleep>
    release(&itable.lock);
    80004778:	00067517          	auipc	a0,0x67
    8000477c:	ba050513          	addi	a0,a0,-1120 # 8006b318 <itable>
    80004780:	ffffc097          	auipc	ra,0xffffc
    80004784:	644080e7          	jalr	1604(ra) # 80000dc4 <release>
    itrunc(ip);
    80004788:	8526                	mv	a0,s1
    8000478a:	00000097          	auipc	ra,0x0
    8000478e:	ee4080e7          	jalr	-284(ra) # 8000466e <itrunc>
    ip->type = 0;
    80004792:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004796:	8526                	mv	a0,s1
    80004798:	00000097          	auipc	ra,0x0
    8000479c:	cf8080e7          	jalr	-776(ra) # 80004490 <iupdate>
    ip->valid = 0;
    800047a0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800047a4:	854a                	mv	a0,s2
    800047a6:	00001097          	auipc	ra,0x1
    800047aa:	ad0080e7          	jalr	-1328(ra) # 80005276 <releasesleep>
    acquire(&itable.lock);
    800047ae:	00067517          	auipc	a0,0x67
    800047b2:	b6a50513          	addi	a0,a0,-1174 # 8006b318 <itable>
    800047b6:	ffffc097          	auipc	ra,0xffffc
    800047ba:	55a080e7          	jalr	1370(ra) # 80000d10 <acquire>
    800047be:	6902                	ld	s2,0(sp)
    800047c0:	bfbd                	j	8000473e <iput+0x24>

00000000800047c2 <iunlockput>:
{
    800047c2:	1101                	addi	sp,sp,-32
    800047c4:	ec06                	sd	ra,24(sp)
    800047c6:	e822                	sd	s0,16(sp)
    800047c8:	e426                	sd	s1,8(sp)
    800047ca:	1000                	addi	s0,sp,32
    800047cc:	84aa                	mv	s1,a0
  iunlock(ip);
    800047ce:	00000097          	auipc	ra,0x0
    800047d2:	e54080e7          	jalr	-428(ra) # 80004622 <iunlock>
  iput(ip);
    800047d6:	8526                	mv	a0,s1
    800047d8:	00000097          	auipc	ra,0x0
    800047dc:	f42080e7          	jalr	-190(ra) # 8000471a <iput>
}
    800047e0:	60e2                	ld	ra,24(sp)
    800047e2:	6442                	ld	s0,16(sp)
    800047e4:	64a2                	ld	s1,8(sp)
    800047e6:	6105                	addi	sp,sp,32
    800047e8:	8082                	ret

00000000800047ea <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800047ea:	1141                	addi	sp,sp,-16
    800047ec:	e422                	sd	s0,8(sp)
    800047ee:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800047f0:	411c                	lw	a5,0(a0)
    800047f2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800047f4:	415c                	lw	a5,4(a0)
    800047f6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800047f8:	04451783          	lh	a5,68(a0)
    800047fc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004800:	04a51783          	lh	a5,74(a0)
    80004804:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004808:	04c56783          	lwu	a5,76(a0)
    8000480c:	e99c                	sd	a5,16(a1)
}
    8000480e:	6422                	ld	s0,8(sp)
    80004810:	0141                	addi	sp,sp,16
    80004812:	8082                	ret

0000000080004814 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004814:	457c                	lw	a5,76(a0)
    80004816:	10d7e563          	bltu	a5,a3,80004920 <readi+0x10c>
{
    8000481a:	7159                	addi	sp,sp,-112
    8000481c:	f486                	sd	ra,104(sp)
    8000481e:	f0a2                	sd	s0,96(sp)
    80004820:	eca6                	sd	s1,88(sp)
    80004822:	e0d2                	sd	s4,64(sp)
    80004824:	fc56                	sd	s5,56(sp)
    80004826:	f85a                	sd	s6,48(sp)
    80004828:	f45e                	sd	s7,40(sp)
    8000482a:	1880                	addi	s0,sp,112
    8000482c:	8b2a                	mv	s6,a0
    8000482e:	8bae                	mv	s7,a1
    80004830:	8a32                	mv	s4,a2
    80004832:	84b6                	mv	s1,a3
    80004834:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004836:	9f35                	addw	a4,a4,a3
    return 0;
    80004838:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000483a:	0cd76a63          	bltu	a4,a3,8000490e <readi+0xfa>
    8000483e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004840:	00e7f463          	bgeu	a5,a4,80004848 <readi+0x34>
    n = ip->size - off;
    80004844:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004848:	0a0a8963          	beqz	s5,800048fa <readi+0xe6>
    8000484c:	e8ca                	sd	s2,80(sp)
    8000484e:	f062                	sd	s8,32(sp)
    80004850:	ec66                	sd	s9,24(sp)
    80004852:	e86a                	sd	s10,16(sp)
    80004854:	e46e                	sd	s11,8(sp)
    80004856:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004858:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000485c:	5c7d                	li	s8,-1
    8000485e:	a82d                	j	80004898 <readi+0x84>
    80004860:	020d1d93          	slli	s11,s10,0x20
    80004864:	020ddd93          	srli	s11,s11,0x20
    80004868:	05890613          	addi	a2,s2,88
    8000486c:	86ee                	mv	a3,s11
    8000486e:	963a                	add	a2,a2,a4
    80004870:	85d2                	mv	a1,s4
    80004872:	855e                	mv	a0,s7
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	516080e7          	jalr	1302(ra) # 80002d8a <either_copyout>
    8000487c:	05850d63          	beq	a0,s8,800048d6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004880:	854a                	mv	a0,s2
    80004882:	fffff097          	auipc	ra,0xfffff
    80004886:	5d6080e7          	jalr	1494(ra) # 80003e58 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000488a:	013d09bb          	addw	s3,s10,s3
    8000488e:	009d04bb          	addw	s1,s10,s1
    80004892:	9a6e                	add	s4,s4,s11
    80004894:	0559fd63          	bgeu	s3,s5,800048ee <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80004898:	00a4d59b          	srliw	a1,s1,0xa
    8000489c:	855a                	mv	a0,s6
    8000489e:	00000097          	auipc	ra,0x0
    800048a2:	88e080e7          	jalr	-1906(ra) # 8000412c <bmap>
    800048a6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800048aa:	c9b1                	beqz	a1,800048fe <readi+0xea>
    bp = bread(ip->dev, addr);
    800048ac:	000b2503          	lw	a0,0(s6)
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	478080e7          	jalr	1144(ra) # 80003d28 <bread>
    800048b8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800048ba:	3ff4f713          	andi	a4,s1,1023
    800048be:	40ec87bb          	subw	a5,s9,a4
    800048c2:	413a86bb          	subw	a3,s5,s3
    800048c6:	8d3e                	mv	s10,a5
    800048c8:	2781                	sext.w	a5,a5
    800048ca:	0006861b          	sext.w	a2,a3
    800048ce:	f8f679e3          	bgeu	a2,a5,80004860 <readi+0x4c>
    800048d2:	8d36                	mv	s10,a3
    800048d4:	b771                	j	80004860 <readi+0x4c>
      brelse(bp);
    800048d6:	854a                	mv	a0,s2
    800048d8:	fffff097          	auipc	ra,0xfffff
    800048dc:	580080e7          	jalr	1408(ra) # 80003e58 <brelse>
      tot = -1;
    800048e0:	59fd                	li	s3,-1
      break;
    800048e2:	6946                	ld	s2,80(sp)
    800048e4:	7c02                	ld	s8,32(sp)
    800048e6:	6ce2                	ld	s9,24(sp)
    800048e8:	6d42                	ld	s10,16(sp)
    800048ea:	6da2                	ld	s11,8(sp)
    800048ec:	a831                	j	80004908 <readi+0xf4>
    800048ee:	6946                	ld	s2,80(sp)
    800048f0:	7c02                	ld	s8,32(sp)
    800048f2:	6ce2                	ld	s9,24(sp)
    800048f4:	6d42                	ld	s10,16(sp)
    800048f6:	6da2                	ld	s11,8(sp)
    800048f8:	a801                	j	80004908 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800048fa:	89d6                	mv	s3,s5
    800048fc:	a031                	j	80004908 <readi+0xf4>
    800048fe:	6946                	ld	s2,80(sp)
    80004900:	7c02                	ld	s8,32(sp)
    80004902:	6ce2                	ld	s9,24(sp)
    80004904:	6d42                	ld	s10,16(sp)
    80004906:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004908:	0009851b          	sext.w	a0,s3
    8000490c:	69a6                	ld	s3,72(sp)
}
    8000490e:	70a6                	ld	ra,104(sp)
    80004910:	7406                	ld	s0,96(sp)
    80004912:	64e6                	ld	s1,88(sp)
    80004914:	6a06                	ld	s4,64(sp)
    80004916:	7ae2                	ld	s5,56(sp)
    80004918:	7b42                	ld	s6,48(sp)
    8000491a:	7ba2                	ld	s7,40(sp)
    8000491c:	6165                	addi	sp,sp,112
    8000491e:	8082                	ret
    return 0;
    80004920:	4501                	li	a0,0
}
    80004922:	8082                	ret

0000000080004924 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004924:	457c                	lw	a5,76(a0)
    80004926:	10d7ee63          	bltu	a5,a3,80004a42 <writei+0x11e>
{
    8000492a:	7159                	addi	sp,sp,-112
    8000492c:	f486                	sd	ra,104(sp)
    8000492e:	f0a2                	sd	s0,96(sp)
    80004930:	e8ca                	sd	s2,80(sp)
    80004932:	e0d2                	sd	s4,64(sp)
    80004934:	fc56                	sd	s5,56(sp)
    80004936:	f85a                	sd	s6,48(sp)
    80004938:	f45e                	sd	s7,40(sp)
    8000493a:	1880                	addi	s0,sp,112
    8000493c:	8aaa                	mv	s5,a0
    8000493e:	8bae                	mv	s7,a1
    80004940:	8a32                	mv	s4,a2
    80004942:	8936                	mv	s2,a3
    80004944:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004946:	00e687bb          	addw	a5,a3,a4
    8000494a:	0ed7ee63          	bltu	a5,a3,80004a46 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000494e:	00043737          	lui	a4,0x43
    80004952:	0ef76c63          	bltu	a4,a5,80004a4a <writei+0x126>
    80004956:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004958:	0c0b0d63          	beqz	s6,80004a32 <writei+0x10e>
    8000495c:	eca6                	sd	s1,88(sp)
    8000495e:	f062                	sd	s8,32(sp)
    80004960:	ec66                	sd	s9,24(sp)
    80004962:	e86a                	sd	s10,16(sp)
    80004964:	e46e                	sd	s11,8(sp)
    80004966:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004968:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000496c:	5c7d                	li	s8,-1
    8000496e:	a091                	j	800049b2 <writei+0x8e>
    80004970:	020d1d93          	slli	s11,s10,0x20
    80004974:	020ddd93          	srli	s11,s11,0x20
    80004978:	05848513          	addi	a0,s1,88
    8000497c:	86ee                	mv	a3,s11
    8000497e:	8652                	mv	a2,s4
    80004980:	85de                	mv	a1,s7
    80004982:	953a                	add	a0,a0,a4
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	45c080e7          	jalr	1116(ra) # 80002de0 <either_copyin>
    8000498c:	07850263          	beq	a0,s8,800049f0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004990:	8526                	mv	a0,s1
    80004992:	00000097          	auipc	ra,0x0
    80004996:	770080e7          	jalr	1904(ra) # 80005102 <log_write>
    brelse(bp);
    8000499a:	8526                	mv	a0,s1
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	4bc080e7          	jalr	1212(ra) # 80003e58 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800049a4:	013d09bb          	addw	s3,s10,s3
    800049a8:	012d093b          	addw	s2,s10,s2
    800049ac:	9a6e                	add	s4,s4,s11
    800049ae:	0569f663          	bgeu	s3,s6,800049fa <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800049b2:	00a9559b          	srliw	a1,s2,0xa
    800049b6:	8556                	mv	a0,s5
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	774080e7          	jalr	1908(ra) # 8000412c <bmap>
    800049c0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800049c4:	c99d                	beqz	a1,800049fa <writei+0xd6>
    bp = bread(ip->dev, addr);
    800049c6:	000aa503          	lw	a0,0(s5)
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	35e080e7          	jalr	862(ra) # 80003d28 <bread>
    800049d2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800049d4:	3ff97713          	andi	a4,s2,1023
    800049d8:	40ec87bb          	subw	a5,s9,a4
    800049dc:	413b06bb          	subw	a3,s6,s3
    800049e0:	8d3e                	mv	s10,a5
    800049e2:	2781                	sext.w	a5,a5
    800049e4:	0006861b          	sext.w	a2,a3
    800049e8:	f8f674e3          	bgeu	a2,a5,80004970 <writei+0x4c>
    800049ec:	8d36                	mv	s10,a3
    800049ee:	b749                	j	80004970 <writei+0x4c>
      brelse(bp);
    800049f0:	8526                	mv	a0,s1
    800049f2:	fffff097          	auipc	ra,0xfffff
    800049f6:	466080e7          	jalr	1126(ra) # 80003e58 <brelse>
  }

  if(off > ip->size)
    800049fa:	04caa783          	lw	a5,76(s5)
    800049fe:	0327fc63          	bgeu	a5,s2,80004a36 <writei+0x112>
    ip->size = off;
    80004a02:	052aa623          	sw	s2,76(s5)
    80004a06:	64e6                	ld	s1,88(sp)
    80004a08:	7c02                	ld	s8,32(sp)
    80004a0a:	6ce2                	ld	s9,24(sp)
    80004a0c:	6d42                	ld	s10,16(sp)
    80004a0e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004a10:	8556                	mv	a0,s5
    80004a12:	00000097          	auipc	ra,0x0
    80004a16:	a7e080e7          	jalr	-1410(ra) # 80004490 <iupdate>

  return tot;
    80004a1a:	0009851b          	sext.w	a0,s3
    80004a1e:	69a6                	ld	s3,72(sp)
}
    80004a20:	70a6                	ld	ra,104(sp)
    80004a22:	7406                	ld	s0,96(sp)
    80004a24:	6946                	ld	s2,80(sp)
    80004a26:	6a06                	ld	s4,64(sp)
    80004a28:	7ae2                	ld	s5,56(sp)
    80004a2a:	7b42                	ld	s6,48(sp)
    80004a2c:	7ba2                	ld	s7,40(sp)
    80004a2e:	6165                	addi	sp,sp,112
    80004a30:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004a32:	89da                	mv	s3,s6
    80004a34:	bff1                	j	80004a10 <writei+0xec>
    80004a36:	64e6                	ld	s1,88(sp)
    80004a38:	7c02                	ld	s8,32(sp)
    80004a3a:	6ce2                	ld	s9,24(sp)
    80004a3c:	6d42                	ld	s10,16(sp)
    80004a3e:	6da2                	ld	s11,8(sp)
    80004a40:	bfc1                	j	80004a10 <writei+0xec>
    return -1;
    80004a42:	557d                	li	a0,-1
}
    80004a44:	8082                	ret
    return -1;
    80004a46:	557d                	li	a0,-1
    80004a48:	bfe1                	j	80004a20 <writei+0xfc>
    return -1;
    80004a4a:	557d                	li	a0,-1
    80004a4c:	bfd1                	j	80004a20 <writei+0xfc>

0000000080004a4e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004a4e:	1141                	addi	sp,sp,-16
    80004a50:	e406                	sd	ra,8(sp)
    80004a52:	e022                	sd	s0,0(sp)
    80004a54:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004a56:	4639                	li	a2,14
    80004a58:	ffffc097          	auipc	ra,0xffffc
    80004a5c:	484080e7          	jalr	1156(ra) # 80000edc <strncmp>
}
    80004a60:	60a2                	ld	ra,8(sp)
    80004a62:	6402                	ld	s0,0(sp)
    80004a64:	0141                	addi	sp,sp,16
    80004a66:	8082                	ret

0000000080004a68 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004a68:	7139                	addi	sp,sp,-64
    80004a6a:	fc06                	sd	ra,56(sp)
    80004a6c:	f822                	sd	s0,48(sp)
    80004a6e:	f426                	sd	s1,40(sp)
    80004a70:	f04a                	sd	s2,32(sp)
    80004a72:	ec4e                	sd	s3,24(sp)
    80004a74:	e852                	sd	s4,16(sp)
    80004a76:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004a78:	04451703          	lh	a4,68(a0)
    80004a7c:	4785                	li	a5,1
    80004a7e:	00f71a63          	bne	a4,a5,80004a92 <dirlookup+0x2a>
    80004a82:	892a                	mv	s2,a0
    80004a84:	89ae                	mv	s3,a1
    80004a86:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a88:	457c                	lw	a5,76(a0)
    80004a8a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004a8c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a8e:	e79d                	bnez	a5,80004abc <dirlookup+0x54>
    80004a90:	a8a5                	j	80004b08 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004a92:	00007517          	auipc	a0,0x7
    80004a96:	ae650513          	addi	a0,a0,-1306 # 8000b578 <etext+0x578>
    80004a9a:	ffffc097          	auipc	ra,0xffffc
    80004a9e:	ac6080e7          	jalr	-1338(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004aa2:	00007517          	auipc	a0,0x7
    80004aa6:	aee50513          	addi	a0,a0,-1298 # 8000b590 <etext+0x590>
    80004aaa:	ffffc097          	auipc	ra,0xffffc
    80004aae:	ab6080e7          	jalr	-1354(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004ab2:	24c1                	addiw	s1,s1,16
    80004ab4:	04c92783          	lw	a5,76(s2)
    80004ab8:	04f4f763          	bgeu	s1,a5,80004b06 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004abc:	4741                	li	a4,16
    80004abe:	86a6                	mv	a3,s1
    80004ac0:	fc040613          	addi	a2,s0,-64
    80004ac4:	4581                	li	a1,0
    80004ac6:	854a                	mv	a0,s2
    80004ac8:	00000097          	auipc	ra,0x0
    80004acc:	d4c080e7          	jalr	-692(ra) # 80004814 <readi>
    80004ad0:	47c1                	li	a5,16
    80004ad2:	fcf518e3          	bne	a0,a5,80004aa2 <dirlookup+0x3a>
    if(de.inum == 0)
    80004ad6:	fc045783          	lhu	a5,-64(s0)
    80004ada:	dfe1                	beqz	a5,80004ab2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004adc:	fc240593          	addi	a1,s0,-62
    80004ae0:	854e                	mv	a0,s3
    80004ae2:	00000097          	auipc	ra,0x0
    80004ae6:	f6c080e7          	jalr	-148(ra) # 80004a4e <namecmp>
    80004aea:	f561                	bnez	a0,80004ab2 <dirlookup+0x4a>
      if(poff)
    80004aec:	000a0463          	beqz	s4,80004af4 <dirlookup+0x8c>
        *poff = off;
    80004af0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004af4:	fc045583          	lhu	a1,-64(s0)
    80004af8:	00092503          	lw	a0,0(s2)
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	720080e7          	jalr	1824(ra) # 8000421c <iget>
    80004b04:	a011                	j	80004b08 <dirlookup+0xa0>
  return 0;
    80004b06:	4501                	li	a0,0
}
    80004b08:	70e2                	ld	ra,56(sp)
    80004b0a:	7442                	ld	s0,48(sp)
    80004b0c:	74a2                	ld	s1,40(sp)
    80004b0e:	7902                	ld	s2,32(sp)
    80004b10:	69e2                	ld	s3,24(sp)
    80004b12:	6a42                	ld	s4,16(sp)
    80004b14:	6121                	addi	sp,sp,64
    80004b16:	8082                	ret

0000000080004b18 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004b18:	711d                	addi	sp,sp,-96
    80004b1a:	ec86                	sd	ra,88(sp)
    80004b1c:	e8a2                	sd	s0,80(sp)
    80004b1e:	e4a6                	sd	s1,72(sp)
    80004b20:	e0ca                	sd	s2,64(sp)
    80004b22:	fc4e                	sd	s3,56(sp)
    80004b24:	f852                	sd	s4,48(sp)
    80004b26:	f456                	sd	s5,40(sp)
    80004b28:	f05a                	sd	s6,32(sp)
    80004b2a:	ec5e                	sd	s7,24(sp)
    80004b2c:	e862                	sd	s8,16(sp)
    80004b2e:	e466                	sd	s9,8(sp)
    80004b30:	1080                	addi	s0,sp,96
    80004b32:	84aa                	mv	s1,a0
    80004b34:	8b2e                	mv	s6,a1
    80004b36:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004b38:	00054703          	lbu	a4,0(a0)
    80004b3c:	02f00793          	li	a5,47
    80004b40:	02f70263          	beq	a4,a5,80004b64 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004b44:	ffffd097          	auipc	ra,0xffffd
    80004b48:	2d0080e7          	jalr	720(ra) # 80001e14 <myproc>
    80004b4c:	15053503          	ld	a0,336(a0)
    80004b50:	00000097          	auipc	ra,0x0
    80004b54:	9ce080e7          	jalr	-1586(ra) # 8000451e <idup>
    80004b58:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004b5a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004b5e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004b60:	4b85                	li	s7,1
    80004b62:	a875                	j	80004c1e <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80004b64:	4585                	li	a1,1
    80004b66:	4505                	li	a0,1
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	6b4080e7          	jalr	1716(ra) # 8000421c <iget>
    80004b70:	8a2a                	mv	s4,a0
    80004b72:	b7e5                	j	80004b5a <namex+0x42>
      iunlockput(ip);
    80004b74:	8552                	mv	a0,s4
    80004b76:	00000097          	auipc	ra,0x0
    80004b7a:	c4c080e7          	jalr	-948(ra) # 800047c2 <iunlockput>
      return 0;
    80004b7e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004b80:	8552                	mv	a0,s4
    80004b82:	60e6                	ld	ra,88(sp)
    80004b84:	6446                	ld	s0,80(sp)
    80004b86:	64a6                	ld	s1,72(sp)
    80004b88:	6906                	ld	s2,64(sp)
    80004b8a:	79e2                	ld	s3,56(sp)
    80004b8c:	7a42                	ld	s4,48(sp)
    80004b8e:	7aa2                	ld	s5,40(sp)
    80004b90:	7b02                	ld	s6,32(sp)
    80004b92:	6be2                	ld	s7,24(sp)
    80004b94:	6c42                	ld	s8,16(sp)
    80004b96:	6ca2                	ld	s9,8(sp)
    80004b98:	6125                	addi	sp,sp,96
    80004b9a:	8082                	ret
      iunlock(ip);
    80004b9c:	8552                	mv	a0,s4
    80004b9e:	00000097          	auipc	ra,0x0
    80004ba2:	a84080e7          	jalr	-1404(ra) # 80004622 <iunlock>
      return ip;
    80004ba6:	bfe9                	j	80004b80 <namex+0x68>
      iunlockput(ip);
    80004ba8:	8552                	mv	a0,s4
    80004baa:	00000097          	auipc	ra,0x0
    80004bae:	c18080e7          	jalr	-1000(ra) # 800047c2 <iunlockput>
      return 0;
    80004bb2:	8a4e                	mv	s4,s3
    80004bb4:	b7f1                	j	80004b80 <namex+0x68>
  len = path - s;
    80004bb6:	40998633          	sub	a2,s3,s1
    80004bba:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004bbe:	099c5863          	bge	s8,s9,80004c4e <namex+0x136>
    memmove(name, s, DIRSIZ);
    80004bc2:	4639                	li	a2,14
    80004bc4:	85a6                	mv	a1,s1
    80004bc6:	8556                	mv	a0,s5
    80004bc8:	ffffc097          	auipc	ra,0xffffc
    80004bcc:	2a0080e7          	jalr	672(ra) # 80000e68 <memmove>
    80004bd0:	84ce                	mv	s1,s3
  while(*path == '/')
    80004bd2:	0004c783          	lbu	a5,0(s1)
    80004bd6:	01279763          	bne	a5,s2,80004be4 <namex+0xcc>
    path++;
    80004bda:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004bdc:	0004c783          	lbu	a5,0(s1)
    80004be0:	ff278de3          	beq	a5,s2,80004bda <namex+0xc2>
    ilock(ip);
    80004be4:	8552                	mv	a0,s4
    80004be6:	00000097          	auipc	ra,0x0
    80004bea:	976080e7          	jalr	-1674(ra) # 8000455c <ilock>
    if(ip->type != T_DIR){
    80004bee:	044a1783          	lh	a5,68(s4)
    80004bf2:	f97791e3          	bne	a5,s7,80004b74 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80004bf6:	000b0563          	beqz	s6,80004c00 <namex+0xe8>
    80004bfa:	0004c783          	lbu	a5,0(s1)
    80004bfe:	dfd9                	beqz	a5,80004b9c <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004c00:	4601                	li	a2,0
    80004c02:	85d6                	mv	a1,s5
    80004c04:	8552                	mv	a0,s4
    80004c06:	00000097          	auipc	ra,0x0
    80004c0a:	e62080e7          	jalr	-414(ra) # 80004a68 <dirlookup>
    80004c0e:	89aa                	mv	s3,a0
    80004c10:	dd41                	beqz	a0,80004ba8 <namex+0x90>
    iunlockput(ip);
    80004c12:	8552                	mv	a0,s4
    80004c14:	00000097          	auipc	ra,0x0
    80004c18:	bae080e7          	jalr	-1106(ra) # 800047c2 <iunlockput>
    ip = next;
    80004c1c:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004c1e:	0004c783          	lbu	a5,0(s1)
    80004c22:	01279763          	bne	a5,s2,80004c30 <namex+0x118>
    path++;
    80004c26:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004c28:	0004c783          	lbu	a5,0(s1)
    80004c2c:	ff278de3          	beq	a5,s2,80004c26 <namex+0x10e>
  if(*path == 0)
    80004c30:	cb9d                	beqz	a5,80004c66 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80004c32:	0004c783          	lbu	a5,0(s1)
    80004c36:	89a6                	mv	s3,s1
  len = path - s;
    80004c38:	4c81                	li	s9,0
    80004c3a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004c3c:	01278963          	beq	a5,s2,80004c4e <namex+0x136>
    80004c40:	dbbd                	beqz	a5,80004bb6 <namex+0x9e>
    path++;
    80004c42:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004c44:	0009c783          	lbu	a5,0(s3)
    80004c48:	ff279ce3          	bne	a5,s2,80004c40 <namex+0x128>
    80004c4c:	b7ad                	j	80004bb6 <namex+0x9e>
    memmove(name, s, len);
    80004c4e:	2601                	sext.w	a2,a2
    80004c50:	85a6                	mv	a1,s1
    80004c52:	8556                	mv	a0,s5
    80004c54:	ffffc097          	auipc	ra,0xffffc
    80004c58:	214080e7          	jalr	532(ra) # 80000e68 <memmove>
    name[len] = 0;
    80004c5c:	9cd6                	add	s9,s9,s5
    80004c5e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004c62:	84ce                	mv	s1,s3
    80004c64:	b7bd                	j	80004bd2 <namex+0xba>
  if(nameiparent){
    80004c66:	f00b0de3          	beqz	s6,80004b80 <namex+0x68>
    iput(ip);
    80004c6a:	8552                	mv	a0,s4
    80004c6c:	00000097          	auipc	ra,0x0
    80004c70:	aae080e7          	jalr	-1362(ra) # 8000471a <iput>
    return 0;
    80004c74:	4a01                	li	s4,0
    80004c76:	b729                	j	80004b80 <namex+0x68>

0000000080004c78 <dirlink>:
{
    80004c78:	7139                	addi	sp,sp,-64
    80004c7a:	fc06                	sd	ra,56(sp)
    80004c7c:	f822                	sd	s0,48(sp)
    80004c7e:	f04a                	sd	s2,32(sp)
    80004c80:	ec4e                	sd	s3,24(sp)
    80004c82:	e852                	sd	s4,16(sp)
    80004c84:	0080                	addi	s0,sp,64
    80004c86:	892a                	mv	s2,a0
    80004c88:	8a2e                	mv	s4,a1
    80004c8a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004c8c:	4601                	li	a2,0
    80004c8e:	00000097          	auipc	ra,0x0
    80004c92:	dda080e7          	jalr	-550(ra) # 80004a68 <dirlookup>
    80004c96:	ed25                	bnez	a0,80004d0e <dirlink+0x96>
    80004c98:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004c9a:	04c92483          	lw	s1,76(s2)
    80004c9e:	c49d                	beqz	s1,80004ccc <dirlink+0x54>
    80004ca0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ca2:	4741                	li	a4,16
    80004ca4:	86a6                	mv	a3,s1
    80004ca6:	fc040613          	addi	a2,s0,-64
    80004caa:	4581                	li	a1,0
    80004cac:	854a                	mv	a0,s2
    80004cae:	00000097          	auipc	ra,0x0
    80004cb2:	b66080e7          	jalr	-1178(ra) # 80004814 <readi>
    80004cb6:	47c1                	li	a5,16
    80004cb8:	06f51163          	bne	a0,a5,80004d1a <dirlink+0xa2>
    if(de.inum == 0)
    80004cbc:	fc045783          	lhu	a5,-64(s0)
    80004cc0:	c791                	beqz	a5,80004ccc <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004cc2:	24c1                	addiw	s1,s1,16
    80004cc4:	04c92783          	lw	a5,76(s2)
    80004cc8:	fcf4ede3          	bltu	s1,a5,80004ca2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004ccc:	4639                	li	a2,14
    80004cce:	85d2                	mv	a1,s4
    80004cd0:	fc240513          	addi	a0,s0,-62
    80004cd4:	ffffc097          	auipc	ra,0xffffc
    80004cd8:	23e080e7          	jalr	574(ra) # 80000f12 <strncpy>
  de.inum = inum;
    80004cdc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ce0:	4741                	li	a4,16
    80004ce2:	86a6                	mv	a3,s1
    80004ce4:	fc040613          	addi	a2,s0,-64
    80004ce8:	4581                	li	a1,0
    80004cea:	854a                	mv	a0,s2
    80004cec:	00000097          	auipc	ra,0x0
    80004cf0:	c38080e7          	jalr	-968(ra) # 80004924 <writei>
    80004cf4:	1541                	addi	a0,a0,-16
    80004cf6:	00a03533          	snez	a0,a0
    80004cfa:	40a00533          	neg	a0,a0
    80004cfe:	74a2                	ld	s1,40(sp)
}
    80004d00:	70e2                	ld	ra,56(sp)
    80004d02:	7442                	ld	s0,48(sp)
    80004d04:	7902                	ld	s2,32(sp)
    80004d06:	69e2                	ld	s3,24(sp)
    80004d08:	6a42                	ld	s4,16(sp)
    80004d0a:	6121                	addi	sp,sp,64
    80004d0c:	8082                	ret
    iput(ip);
    80004d0e:	00000097          	auipc	ra,0x0
    80004d12:	a0c080e7          	jalr	-1524(ra) # 8000471a <iput>
    return -1;
    80004d16:	557d                	li	a0,-1
    80004d18:	b7e5                	j	80004d00 <dirlink+0x88>
      panic("dirlink read");
    80004d1a:	00007517          	auipc	a0,0x7
    80004d1e:	88650513          	addi	a0,a0,-1914 # 8000b5a0 <etext+0x5a0>
    80004d22:	ffffc097          	auipc	ra,0xffffc
    80004d26:	83e080e7          	jalr	-1986(ra) # 80000560 <panic>

0000000080004d2a <namei>:

struct inode*
namei(char *path)
{
    80004d2a:	1101                	addi	sp,sp,-32
    80004d2c:	ec06                	sd	ra,24(sp)
    80004d2e:	e822                	sd	s0,16(sp)
    80004d30:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004d32:	fe040613          	addi	a2,s0,-32
    80004d36:	4581                	li	a1,0
    80004d38:	00000097          	auipc	ra,0x0
    80004d3c:	de0080e7          	jalr	-544(ra) # 80004b18 <namex>
}
    80004d40:	60e2                	ld	ra,24(sp)
    80004d42:	6442                	ld	s0,16(sp)
    80004d44:	6105                	addi	sp,sp,32
    80004d46:	8082                	ret

0000000080004d48 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004d48:	1141                	addi	sp,sp,-16
    80004d4a:	e406                	sd	ra,8(sp)
    80004d4c:	e022                	sd	s0,0(sp)
    80004d4e:	0800                	addi	s0,sp,16
    80004d50:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004d52:	4585                	li	a1,1
    80004d54:	00000097          	auipc	ra,0x0
    80004d58:	dc4080e7          	jalr	-572(ra) # 80004b18 <namex>
}
    80004d5c:	60a2                	ld	ra,8(sp)
    80004d5e:	6402                	ld	s0,0(sp)
    80004d60:	0141                	addi	sp,sp,16
    80004d62:	8082                	ret

0000000080004d64 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004d64:	1101                	addi	sp,sp,-32
    80004d66:	ec06                	sd	ra,24(sp)
    80004d68:	e822                	sd	s0,16(sp)
    80004d6a:	e426                	sd	s1,8(sp)
    80004d6c:	e04a                	sd	s2,0(sp)
    80004d6e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004d70:	00068917          	auipc	s2,0x68
    80004d74:	05090913          	addi	s2,s2,80 # 8006cdc0 <log>
    80004d78:	01892583          	lw	a1,24(s2)
    80004d7c:	02892503          	lw	a0,40(s2)
    80004d80:	fffff097          	auipc	ra,0xfffff
    80004d84:	fa8080e7          	jalr	-88(ra) # 80003d28 <bread>
    80004d88:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004d8a:	02c92603          	lw	a2,44(s2)
    80004d8e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004d90:	00c05f63          	blez	a2,80004dae <write_head+0x4a>
    80004d94:	00068717          	auipc	a4,0x68
    80004d98:	05c70713          	addi	a4,a4,92 # 8006cdf0 <log+0x30>
    80004d9c:	87aa                	mv	a5,a0
    80004d9e:	060a                	slli	a2,a2,0x2
    80004da0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004da2:	4314                	lw	a3,0(a4)
    80004da4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004da6:	0711                	addi	a4,a4,4
    80004da8:	0791                	addi	a5,a5,4
    80004daa:	fec79ce3          	bne	a5,a2,80004da2 <write_head+0x3e>
  }
  bwrite(buf);
    80004dae:	8526                	mv	a0,s1
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	06a080e7          	jalr	106(ra) # 80003e1a <bwrite>
  brelse(buf);
    80004db8:	8526                	mv	a0,s1
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	09e080e7          	jalr	158(ra) # 80003e58 <brelse>
}
    80004dc2:	60e2                	ld	ra,24(sp)
    80004dc4:	6442                	ld	s0,16(sp)
    80004dc6:	64a2                	ld	s1,8(sp)
    80004dc8:	6902                	ld	s2,0(sp)
    80004dca:	6105                	addi	sp,sp,32
    80004dcc:	8082                	ret

0000000080004dce <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004dce:	00068797          	auipc	a5,0x68
    80004dd2:	01e7a783          	lw	a5,30(a5) # 8006cdec <log+0x2c>
    80004dd6:	0af05d63          	blez	a5,80004e90 <install_trans+0xc2>
{
    80004dda:	7139                	addi	sp,sp,-64
    80004ddc:	fc06                	sd	ra,56(sp)
    80004dde:	f822                	sd	s0,48(sp)
    80004de0:	f426                	sd	s1,40(sp)
    80004de2:	f04a                	sd	s2,32(sp)
    80004de4:	ec4e                	sd	s3,24(sp)
    80004de6:	e852                	sd	s4,16(sp)
    80004de8:	e456                	sd	s5,8(sp)
    80004dea:	e05a                	sd	s6,0(sp)
    80004dec:	0080                	addi	s0,sp,64
    80004dee:	8b2a                	mv	s6,a0
    80004df0:	00068a97          	auipc	s5,0x68
    80004df4:	000a8a93          	mv	s5,s5
  for (tail = 0; tail < log.lh.n; tail++) {
    80004df8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004dfa:	00068997          	auipc	s3,0x68
    80004dfe:	fc698993          	addi	s3,s3,-58 # 8006cdc0 <log>
    80004e02:	a00d                	j	80004e24 <install_trans+0x56>
    brelse(lbuf);
    80004e04:	854a                	mv	a0,s2
    80004e06:	fffff097          	auipc	ra,0xfffff
    80004e0a:	052080e7          	jalr	82(ra) # 80003e58 <brelse>
    brelse(dbuf);
    80004e0e:	8526                	mv	a0,s1
    80004e10:	fffff097          	auipc	ra,0xfffff
    80004e14:	048080e7          	jalr	72(ra) # 80003e58 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e18:	2a05                	addiw	s4,s4,1
    80004e1a:	0a91                	addi	s5,s5,4 # 8006cdf4 <log+0x34>
    80004e1c:	02c9a783          	lw	a5,44(s3)
    80004e20:	04fa5e63          	bge	s4,a5,80004e7c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004e24:	0189a583          	lw	a1,24(s3)
    80004e28:	014585bb          	addw	a1,a1,s4
    80004e2c:	2585                	addiw	a1,a1,1
    80004e2e:	0289a503          	lw	a0,40(s3)
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	ef6080e7          	jalr	-266(ra) # 80003d28 <bread>
    80004e3a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004e3c:	000aa583          	lw	a1,0(s5)
    80004e40:	0289a503          	lw	a0,40(s3)
    80004e44:	fffff097          	auipc	ra,0xfffff
    80004e48:	ee4080e7          	jalr	-284(ra) # 80003d28 <bread>
    80004e4c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004e4e:	40000613          	li	a2,1024
    80004e52:	05890593          	addi	a1,s2,88
    80004e56:	05850513          	addi	a0,a0,88
    80004e5a:	ffffc097          	auipc	ra,0xffffc
    80004e5e:	00e080e7          	jalr	14(ra) # 80000e68 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004e62:	8526                	mv	a0,s1
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	fb6080e7          	jalr	-74(ra) # 80003e1a <bwrite>
    if(recovering == 0)
    80004e6c:	f80b1ce3          	bnez	s6,80004e04 <install_trans+0x36>
      bunpin(dbuf);
    80004e70:	8526                	mv	a0,s1
    80004e72:	fffff097          	auipc	ra,0xfffff
    80004e76:	0be080e7          	jalr	190(ra) # 80003f30 <bunpin>
    80004e7a:	b769                	j	80004e04 <install_trans+0x36>
}
    80004e7c:	70e2                	ld	ra,56(sp)
    80004e7e:	7442                	ld	s0,48(sp)
    80004e80:	74a2                	ld	s1,40(sp)
    80004e82:	7902                	ld	s2,32(sp)
    80004e84:	69e2                	ld	s3,24(sp)
    80004e86:	6a42                	ld	s4,16(sp)
    80004e88:	6aa2                	ld	s5,8(sp)
    80004e8a:	6b02                	ld	s6,0(sp)
    80004e8c:	6121                	addi	sp,sp,64
    80004e8e:	8082                	ret
    80004e90:	8082                	ret

0000000080004e92 <initlog>:
{
    80004e92:	7179                	addi	sp,sp,-48
    80004e94:	f406                	sd	ra,40(sp)
    80004e96:	f022                	sd	s0,32(sp)
    80004e98:	ec26                	sd	s1,24(sp)
    80004e9a:	e84a                	sd	s2,16(sp)
    80004e9c:	e44e                	sd	s3,8(sp)
    80004e9e:	1800                	addi	s0,sp,48
    80004ea0:	892a                	mv	s2,a0
    80004ea2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004ea4:	00068497          	auipc	s1,0x68
    80004ea8:	f1c48493          	addi	s1,s1,-228 # 8006cdc0 <log>
    80004eac:	00006597          	auipc	a1,0x6
    80004eb0:	70458593          	addi	a1,a1,1796 # 8000b5b0 <etext+0x5b0>
    80004eb4:	8526                	mv	a0,s1
    80004eb6:	ffffc097          	auipc	ra,0xffffc
    80004eba:	dca080e7          	jalr	-566(ra) # 80000c80 <initlock>
  log.start = sb->logstart;
    80004ebe:	0149a583          	lw	a1,20(s3)
    80004ec2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004ec4:	0109a783          	lw	a5,16(s3)
    80004ec8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004eca:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004ece:	854a                	mv	a0,s2
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	e58080e7          	jalr	-424(ra) # 80003d28 <bread>
  log.lh.n = lh->n;
    80004ed8:	4d30                	lw	a2,88(a0)
    80004eda:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004edc:	00c05f63          	blez	a2,80004efa <initlog+0x68>
    80004ee0:	87aa                	mv	a5,a0
    80004ee2:	00068717          	auipc	a4,0x68
    80004ee6:	f0e70713          	addi	a4,a4,-242 # 8006cdf0 <log+0x30>
    80004eea:	060a                	slli	a2,a2,0x2
    80004eec:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004eee:	4ff4                	lw	a3,92(a5)
    80004ef0:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004ef2:	0791                	addi	a5,a5,4
    80004ef4:	0711                	addi	a4,a4,4
    80004ef6:	fec79ce3          	bne	a5,a2,80004eee <initlog+0x5c>
  brelse(buf);
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	f5e080e7          	jalr	-162(ra) # 80003e58 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004f02:	4505                	li	a0,1
    80004f04:	00000097          	auipc	ra,0x0
    80004f08:	eca080e7          	jalr	-310(ra) # 80004dce <install_trans>
  log.lh.n = 0;
    80004f0c:	00068797          	auipc	a5,0x68
    80004f10:	ee07a023          	sw	zero,-288(a5) # 8006cdec <log+0x2c>
  write_head(); // clear the log
    80004f14:	00000097          	auipc	ra,0x0
    80004f18:	e50080e7          	jalr	-432(ra) # 80004d64 <write_head>
}
    80004f1c:	70a2                	ld	ra,40(sp)
    80004f1e:	7402                	ld	s0,32(sp)
    80004f20:	64e2                	ld	s1,24(sp)
    80004f22:	6942                	ld	s2,16(sp)
    80004f24:	69a2                	ld	s3,8(sp)
    80004f26:	6145                	addi	sp,sp,48
    80004f28:	8082                	ret

0000000080004f2a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004f2a:	1101                	addi	sp,sp,-32
    80004f2c:	ec06                	sd	ra,24(sp)
    80004f2e:	e822                	sd	s0,16(sp)
    80004f30:	e426                	sd	s1,8(sp)
    80004f32:	e04a                	sd	s2,0(sp)
    80004f34:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004f36:	00068517          	auipc	a0,0x68
    80004f3a:	e8a50513          	addi	a0,a0,-374 # 8006cdc0 <log>
    80004f3e:	ffffc097          	auipc	ra,0xffffc
    80004f42:	dd2080e7          	jalr	-558(ra) # 80000d10 <acquire>
  while(1){
    if(log.committing){
    80004f46:	00068497          	auipc	s1,0x68
    80004f4a:	e7a48493          	addi	s1,s1,-390 # 8006cdc0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004f4e:	4979                	li	s2,30
    80004f50:	a039                	j	80004f5e <begin_op+0x34>
      sleep(&log, &log.lock);
    80004f52:	85a6                	mv	a1,s1
    80004f54:	8526                	mv	a0,s1
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	76c080e7          	jalr	1900(ra) # 800026c2 <sleep>
    if(log.committing){
    80004f5e:	50dc                	lw	a5,36(s1)
    80004f60:	fbed                	bnez	a5,80004f52 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004f62:	5098                	lw	a4,32(s1)
    80004f64:	2705                	addiw	a4,a4,1
    80004f66:	0027179b          	slliw	a5,a4,0x2
    80004f6a:	9fb9                	addw	a5,a5,a4
    80004f6c:	0017979b          	slliw	a5,a5,0x1
    80004f70:	54d4                	lw	a3,44(s1)
    80004f72:	9fb5                	addw	a5,a5,a3
    80004f74:	00f95963          	bge	s2,a5,80004f86 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004f78:	85a6                	mv	a1,s1
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	ffffd097          	auipc	ra,0xffffd
    80004f80:	746080e7          	jalr	1862(ra) # 800026c2 <sleep>
    80004f84:	bfe9                	j	80004f5e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004f86:	00068517          	auipc	a0,0x68
    80004f8a:	e3a50513          	addi	a0,a0,-454 # 8006cdc0 <log>
    80004f8e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004f90:	ffffc097          	auipc	ra,0xffffc
    80004f94:	e34080e7          	jalr	-460(ra) # 80000dc4 <release>
      break;
    }
  }
}
    80004f98:	60e2                	ld	ra,24(sp)
    80004f9a:	6442                	ld	s0,16(sp)
    80004f9c:	64a2                	ld	s1,8(sp)
    80004f9e:	6902                	ld	s2,0(sp)
    80004fa0:	6105                	addi	sp,sp,32
    80004fa2:	8082                	ret

0000000080004fa4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004fa4:	7139                	addi	sp,sp,-64
    80004fa6:	fc06                	sd	ra,56(sp)
    80004fa8:	f822                	sd	s0,48(sp)
    80004faa:	f426                	sd	s1,40(sp)
    80004fac:	f04a                	sd	s2,32(sp)
    80004fae:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004fb0:	00068497          	auipc	s1,0x68
    80004fb4:	e1048493          	addi	s1,s1,-496 # 8006cdc0 <log>
    80004fb8:	8526                	mv	a0,s1
    80004fba:	ffffc097          	auipc	ra,0xffffc
    80004fbe:	d56080e7          	jalr	-682(ra) # 80000d10 <acquire>
  log.outstanding -= 1;
    80004fc2:	509c                	lw	a5,32(s1)
    80004fc4:	37fd                	addiw	a5,a5,-1
    80004fc6:	0007891b          	sext.w	s2,a5
    80004fca:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004fcc:	50dc                	lw	a5,36(s1)
    80004fce:	e7b9                	bnez	a5,8000501c <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80004fd0:	06091163          	bnez	s2,80005032 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004fd4:	00068497          	auipc	s1,0x68
    80004fd8:	dec48493          	addi	s1,s1,-532 # 8006cdc0 <log>
    80004fdc:	4785                	li	a5,1
    80004fde:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004fe0:	8526                	mv	a0,s1
    80004fe2:	ffffc097          	auipc	ra,0xffffc
    80004fe6:	de2080e7          	jalr	-542(ra) # 80000dc4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004fea:	54dc                	lw	a5,44(s1)
    80004fec:	06f04763          	bgtz	a5,8000505a <end_op+0xb6>
    acquire(&log.lock);
    80004ff0:	00068497          	auipc	s1,0x68
    80004ff4:	dd048493          	addi	s1,s1,-560 # 8006cdc0 <log>
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	ffffc097          	auipc	ra,0xffffc
    80004ffe:	d16080e7          	jalr	-746(ra) # 80000d10 <acquire>
    log.committing = 0;
    80005002:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80005006:	8526                	mv	a0,s1
    80005008:	ffffd097          	auipc	ra,0xffffd
    8000500c:	71e080e7          	jalr	1822(ra) # 80002726 <wakeup>
    release(&log.lock);
    80005010:	8526                	mv	a0,s1
    80005012:	ffffc097          	auipc	ra,0xffffc
    80005016:	db2080e7          	jalr	-590(ra) # 80000dc4 <release>
}
    8000501a:	a815                	j	8000504e <end_op+0xaa>
    8000501c:	ec4e                	sd	s3,24(sp)
    8000501e:	e852                	sd	s4,16(sp)
    80005020:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80005022:	00006517          	auipc	a0,0x6
    80005026:	59650513          	addi	a0,a0,1430 # 8000b5b8 <etext+0x5b8>
    8000502a:	ffffb097          	auipc	ra,0xffffb
    8000502e:	536080e7          	jalr	1334(ra) # 80000560 <panic>
    wakeup(&log);
    80005032:	00068497          	auipc	s1,0x68
    80005036:	d8e48493          	addi	s1,s1,-626 # 8006cdc0 <log>
    8000503a:	8526                	mv	a0,s1
    8000503c:	ffffd097          	auipc	ra,0xffffd
    80005040:	6ea080e7          	jalr	1770(ra) # 80002726 <wakeup>
  release(&log.lock);
    80005044:	8526                	mv	a0,s1
    80005046:	ffffc097          	auipc	ra,0xffffc
    8000504a:	d7e080e7          	jalr	-642(ra) # 80000dc4 <release>
}
    8000504e:	70e2                	ld	ra,56(sp)
    80005050:	7442                	ld	s0,48(sp)
    80005052:	74a2                	ld	s1,40(sp)
    80005054:	7902                	ld	s2,32(sp)
    80005056:	6121                	addi	sp,sp,64
    80005058:	8082                	ret
    8000505a:	ec4e                	sd	s3,24(sp)
    8000505c:	e852                	sd	s4,16(sp)
    8000505e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80005060:	00068a97          	auipc	s5,0x68
    80005064:	d90a8a93          	addi	s5,s5,-624 # 8006cdf0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80005068:	00068a17          	auipc	s4,0x68
    8000506c:	d58a0a13          	addi	s4,s4,-680 # 8006cdc0 <log>
    80005070:	018a2583          	lw	a1,24(s4)
    80005074:	012585bb          	addw	a1,a1,s2
    80005078:	2585                	addiw	a1,a1,1
    8000507a:	028a2503          	lw	a0,40(s4)
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	caa080e7          	jalr	-854(ra) # 80003d28 <bread>
    80005086:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80005088:	000aa583          	lw	a1,0(s5)
    8000508c:	028a2503          	lw	a0,40(s4)
    80005090:	fffff097          	auipc	ra,0xfffff
    80005094:	c98080e7          	jalr	-872(ra) # 80003d28 <bread>
    80005098:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000509a:	40000613          	li	a2,1024
    8000509e:	05850593          	addi	a1,a0,88
    800050a2:	05848513          	addi	a0,s1,88
    800050a6:	ffffc097          	auipc	ra,0xffffc
    800050aa:	dc2080e7          	jalr	-574(ra) # 80000e68 <memmove>
    bwrite(to);  // write the log
    800050ae:	8526                	mv	a0,s1
    800050b0:	fffff097          	auipc	ra,0xfffff
    800050b4:	d6a080e7          	jalr	-662(ra) # 80003e1a <bwrite>
    brelse(from);
    800050b8:	854e                	mv	a0,s3
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	d9e080e7          	jalr	-610(ra) # 80003e58 <brelse>
    brelse(to);
    800050c2:	8526                	mv	a0,s1
    800050c4:	fffff097          	auipc	ra,0xfffff
    800050c8:	d94080e7          	jalr	-620(ra) # 80003e58 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800050cc:	2905                	addiw	s2,s2,1
    800050ce:	0a91                	addi	s5,s5,4
    800050d0:	02ca2783          	lw	a5,44(s4)
    800050d4:	f8f94ee3          	blt	s2,a5,80005070 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800050d8:	00000097          	auipc	ra,0x0
    800050dc:	c8c080e7          	jalr	-884(ra) # 80004d64 <write_head>
    install_trans(0); // Now install writes to home locations
    800050e0:	4501                	li	a0,0
    800050e2:	00000097          	auipc	ra,0x0
    800050e6:	cec080e7          	jalr	-788(ra) # 80004dce <install_trans>
    log.lh.n = 0;
    800050ea:	00068797          	auipc	a5,0x68
    800050ee:	d007a123          	sw	zero,-766(a5) # 8006cdec <log+0x2c>
    write_head();    // Erase the transaction from the log
    800050f2:	00000097          	auipc	ra,0x0
    800050f6:	c72080e7          	jalr	-910(ra) # 80004d64 <write_head>
    800050fa:	69e2                	ld	s3,24(sp)
    800050fc:	6a42                	ld	s4,16(sp)
    800050fe:	6aa2                	ld	s5,8(sp)
    80005100:	bdc5                	j	80004ff0 <end_op+0x4c>

0000000080005102 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80005102:	1101                	addi	sp,sp,-32
    80005104:	ec06                	sd	ra,24(sp)
    80005106:	e822                	sd	s0,16(sp)
    80005108:	e426                	sd	s1,8(sp)
    8000510a:	e04a                	sd	s2,0(sp)
    8000510c:	1000                	addi	s0,sp,32
    8000510e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80005110:	00068917          	auipc	s2,0x68
    80005114:	cb090913          	addi	s2,s2,-848 # 8006cdc0 <log>
    80005118:	854a                	mv	a0,s2
    8000511a:	ffffc097          	auipc	ra,0xffffc
    8000511e:	bf6080e7          	jalr	-1034(ra) # 80000d10 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80005122:	02c92603          	lw	a2,44(s2)
    80005126:	47f5                	li	a5,29
    80005128:	06c7c563          	blt	a5,a2,80005192 <log_write+0x90>
    8000512c:	00068797          	auipc	a5,0x68
    80005130:	cb07a783          	lw	a5,-848(a5) # 8006cddc <log+0x1c>
    80005134:	37fd                	addiw	a5,a5,-1
    80005136:	04f65e63          	bge	a2,a5,80005192 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000513a:	00068797          	auipc	a5,0x68
    8000513e:	ca67a783          	lw	a5,-858(a5) # 8006cde0 <log+0x20>
    80005142:	06f05063          	blez	a5,800051a2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80005146:	4781                	li	a5,0
    80005148:	06c05563          	blez	a2,800051b2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000514c:	44cc                	lw	a1,12(s1)
    8000514e:	00068717          	auipc	a4,0x68
    80005152:	ca270713          	addi	a4,a4,-862 # 8006cdf0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80005156:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005158:	4314                	lw	a3,0(a4)
    8000515a:	04b68c63          	beq	a3,a1,800051b2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000515e:	2785                	addiw	a5,a5,1
    80005160:	0711                	addi	a4,a4,4
    80005162:	fef61be3          	bne	a2,a5,80005158 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80005166:	0621                	addi	a2,a2,8
    80005168:	060a                	slli	a2,a2,0x2
    8000516a:	00068797          	auipc	a5,0x68
    8000516e:	c5678793          	addi	a5,a5,-938 # 8006cdc0 <log>
    80005172:	97b2                	add	a5,a5,a2
    80005174:	44d8                	lw	a4,12(s1)
    80005176:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80005178:	8526                	mv	a0,s1
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	d7a080e7          	jalr	-646(ra) # 80003ef4 <bpin>
    log.lh.n++;
    80005182:	00068717          	auipc	a4,0x68
    80005186:	c3e70713          	addi	a4,a4,-962 # 8006cdc0 <log>
    8000518a:	575c                	lw	a5,44(a4)
    8000518c:	2785                	addiw	a5,a5,1
    8000518e:	d75c                	sw	a5,44(a4)
    80005190:	a82d                	j	800051ca <log_write+0xc8>
    panic("too big a transaction");
    80005192:	00006517          	auipc	a0,0x6
    80005196:	43650513          	addi	a0,a0,1078 # 8000b5c8 <etext+0x5c8>
    8000519a:	ffffb097          	auipc	ra,0xffffb
    8000519e:	3c6080e7          	jalr	966(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    800051a2:	00006517          	auipc	a0,0x6
    800051a6:	43e50513          	addi	a0,a0,1086 # 8000b5e0 <etext+0x5e0>
    800051aa:	ffffb097          	auipc	ra,0xffffb
    800051ae:	3b6080e7          	jalr	950(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    800051b2:	00878693          	addi	a3,a5,8
    800051b6:	068a                	slli	a3,a3,0x2
    800051b8:	00068717          	auipc	a4,0x68
    800051bc:	c0870713          	addi	a4,a4,-1016 # 8006cdc0 <log>
    800051c0:	9736                	add	a4,a4,a3
    800051c2:	44d4                	lw	a3,12(s1)
    800051c4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800051c6:	faf609e3          	beq	a2,a5,80005178 <log_write+0x76>
  }
  release(&log.lock);
    800051ca:	00068517          	auipc	a0,0x68
    800051ce:	bf650513          	addi	a0,a0,-1034 # 8006cdc0 <log>
    800051d2:	ffffc097          	auipc	ra,0xffffc
    800051d6:	bf2080e7          	jalr	-1038(ra) # 80000dc4 <release>
}
    800051da:	60e2                	ld	ra,24(sp)
    800051dc:	6442                	ld	s0,16(sp)
    800051de:	64a2                	ld	s1,8(sp)
    800051e0:	6902                	ld	s2,0(sp)
    800051e2:	6105                	addi	sp,sp,32
    800051e4:	8082                	ret

00000000800051e6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800051e6:	1101                	addi	sp,sp,-32
    800051e8:	ec06                	sd	ra,24(sp)
    800051ea:	e822                	sd	s0,16(sp)
    800051ec:	e426                	sd	s1,8(sp)
    800051ee:	e04a                	sd	s2,0(sp)
    800051f0:	1000                	addi	s0,sp,32
    800051f2:	84aa                	mv	s1,a0
    800051f4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800051f6:	00006597          	auipc	a1,0x6
    800051fa:	40a58593          	addi	a1,a1,1034 # 8000b600 <etext+0x600>
    800051fe:	0521                	addi	a0,a0,8
    80005200:	ffffc097          	auipc	ra,0xffffc
    80005204:	a80080e7          	jalr	-1408(ra) # 80000c80 <initlock>
  lk->name = name;
    80005208:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000520c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005210:	0204a423          	sw	zero,40(s1)
}
    80005214:	60e2                	ld	ra,24(sp)
    80005216:	6442                	ld	s0,16(sp)
    80005218:	64a2                	ld	s1,8(sp)
    8000521a:	6902                	ld	s2,0(sp)
    8000521c:	6105                	addi	sp,sp,32
    8000521e:	8082                	ret

0000000080005220 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80005220:	1101                	addi	sp,sp,-32
    80005222:	ec06                	sd	ra,24(sp)
    80005224:	e822                	sd	s0,16(sp)
    80005226:	e426                	sd	s1,8(sp)
    80005228:	e04a                	sd	s2,0(sp)
    8000522a:	1000                	addi	s0,sp,32
    8000522c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000522e:	00850913          	addi	s2,a0,8
    80005232:	854a                	mv	a0,s2
    80005234:	ffffc097          	auipc	ra,0xffffc
    80005238:	adc080e7          	jalr	-1316(ra) # 80000d10 <acquire>
  while (lk->locked) {
    8000523c:	409c                	lw	a5,0(s1)
    8000523e:	cb89                	beqz	a5,80005250 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80005240:	85ca                	mv	a1,s2
    80005242:	8526                	mv	a0,s1
    80005244:	ffffd097          	auipc	ra,0xffffd
    80005248:	47e080e7          	jalr	1150(ra) # 800026c2 <sleep>
  while (lk->locked) {
    8000524c:	409c                	lw	a5,0(s1)
    8000524e:	fbed                	bnez	a5,80005240 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80005250:	4785                	li	a5,1
    80005252:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80005254:	ffffd097          	auipc	ra,0xffffd
    80005258:	bc0080e7          	jalr	-1088(ra) # 80001e14 <myproc>
    8000525c:	591c                	lw	a5,48(a0)
    8000525e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80005260:	854a                	mv	a0,s2
    80005262:	ffffc097          	auipc	ra,0xffffc
    80005266:	b62080e7          	jalr	-1182(ra) # 80000dc4 <release>
}
    8000526a:	60e2                	ld	ra,24(sp)
    8000526c:	6442                	ld	s0,16(sp)
    8000526e:	64a2                	ld	s1,8(sp)
    80005270:	6902                	ld	s2,0(sp)
    80005272:	6105                	addi	sp,sp,32
    80005274:	8082                	ret

0000000080005276 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005276:	1101                	addi	sp,sp,-32
    80005278:	ec06                	sd	ra,24(sp)
    8000527a:	e822                	sd	s0,16(sp)
    8000527c:	e426                	sd	s1,8(sp)
    8000527e:	e04a                	sd	s2,0(sp)
    80005280:	1000                	addi	s0,sp,32
    80005282:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80005284:	00850913          	addi	s2,a0,8
    80005288:	854a                	mv	a0,s2
    8000528a:	ffffc097          	auipc	ra,0xffffc
    8000528e:	a86080e7          	jalr	-1402(ra) # 80000d10 <acquire>
  lk->locked = 0;
    80005292:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005296:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000529a:	8526                	mv	a0,s1
    8000529c:	ffffd097          	auipc	ra,0xffffd
    800052a0:	48a080e7          	jalr	1162(ra) # 80002726 <wakeup>
  release(&lk->lk);
    800052a4:	854a                	mv	a0,s2
    800052a6:	ffffc097          	auipc	ra,0xffffc
    800052aa:	b1e080e7          	jalr	-1250(ra) # 80000dc4 <release>
}
    800052ae:	60e2                	ld	ra,24(sp)
    800052b0:	6442                	ld	s0,16(sp)
    800052b2:	64a2                	ld	s1,8(sp)
    800052b4:	6902                	ld	s2,0(sp)
    800052b6:	6105                	addi	sp,sp,32
    800052b8:	8082                	ret

00000000800052ba <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800052ba:	7179                	addi	sp,sp,-48
    800052bc:	f406                	sd	ra,40(sp)
    800052be:	f022                	sd	s0,32(sp)
    800052c0:	ec26                	sd	s1,24(sp)
    800052c2:	e84a                	sd	s2,16(sp)
    800052c4:	1800                	addi	s0,sp,48
    800052c6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800052c8:	00850913          	addi	s2,a0,8
    800052cc:	854a                	mv	a0,s2
    800052ce:	ffffc097          	auipc	ra,0xffffc
    800052d2:	a42080e7          	jalr	-1470(ra) # 80000d10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800052d6:	409c                	lw	a5,0(s1)
    800052d8:	ef91                	bnez	a5,800052f4 <holdingsleep+0x3a>
    800052da:	4481                	li	s1,0
  release(&lk->lk);
    800052dc:	854a                	mv	a0,s2
    800052de:	ffffc097          	auipc	ra,0xffffc
    800052e2:	ae6080e7          	jalr	-1306(ra) # 80000dc4 <release>
  return r;
}
    800052e6:	8526                	mv	a0,s1
    800052e8:	70a2                	ld	ra,40(sp)
    800052ea:	7402                	ld	s0,32(sp)
    800052ec:	64e2                	ld	s1,24(sp)
    800052ee:	6942                	ld	s2,16(sp)
    800052f0:	6145                	addi	sp,sp,48
    800052f2:	8082                	ret
    800052f4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800052f6:	0284a983          	lw	s3,40(s1)
    800052fa:	ffffd097          	auipc	ra,0xffffd
    800052fe:	b1a080e7          	jalr	-1254(ra) # 80001e14 <myproc>
    80005302:	5904                	lw	s1,48(a0)
    80005304:	413484b3          	sub	s1,s1,s3
    80005308:	0014b493          	seqz	s1,s1
    8000530c:	69a2                	ld	s3,8(sp)
    8000530e:	b7f9                	j	800052dc <holdingsleep+0x22>

0000000080005310 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005310:	1141                	addi	sp,sp,-16
    80005312:	e406                	sd	ra,8(sp)
    80005314:	e022                	sd	s0,0(sp)
    80005316:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005318:	00006597          	auipc	a1,0x6
    8000531c:	2f858593          	addi	a1,a1,760 # 8000b610 <etext+0x610>
    80005320:	00068517          	auipc	a0,0x68
    80005324:	be850513          	addi	a0,a0,-1048 # 8006cf08 <ftable>
    80005328:	ffffc097          	auipc	ra,0xffffc
    8000532c:	958080e7          	jalr	-1704(ra) # 80000c80 <initlock>
}
    80005330:	60a2                	ld	ra,8(sp)
    80005332:	6402                	ld	s0,0(sp)
    80005334:	0141                	addi	sp,sp,16
    80005336:	8082                	ret

0000000080005338 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005338:	1101                	addi	sp,sp,-32
    8000533a:	ec06                	sd	ra,24(sp)
    8000533c:	e822                	sd	s0,16(sp)
    8000533e:	e426                	sd	s1,8(sp)
    80005340:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005342:	00068517          	auipc	a0,0x68
    80005346:	bc650513          	addi	a0,a0,-1082 # 8006cf08 <ftable>
    8000534a:	ffffc097          	auipc	ra,0xffffc
    8000534e:	9c6080e7          	jalr	-1594(ra) # 80000d10 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005352:	00068497          	auipc	s1,0x68
    80005356:	bce48493          	addi	s1,s1,-1074 # 8006cf20 <ftable+0x18>
    8000535a:	00069717          	auipc	a4,0x69
    8000535e:	e8670713          	addi	a4,a4,-378 # 8006e1e0 <disk>
    if(f->ref == 0){
    80005362:	40dc                	lw	a5,4(s1)
    80005364:	cf99                	beqz	a5,80005382 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005366:	03048493          	addi	s1,s1,48
    8000536a:	fee49ce3          	bne	s1,a4,80005362 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000536e:	00068517          	auipc	a0,0x68
    80005372:	b9a50513          	addi	a0,a0,-1126 # 8006cf08 <ftable>
    80005376:	ffffc097          	auipc	ra,0xffffc
    8000537a:	a4e080e7          	jalr	-1458(ra) # 80000dc4 <release>
  return 0;
    8000537e:	4481                	li	s1,0
    80005380:	a819                	j	80005396 <filealloc+0x5e>
      f->ref = 1;
    80005382:	4785                	li	a5,1
    80005384:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80005386:	00068517          	auipc	a0,0x68
    8000538a:	b8250513          	addi	a0,a0,-1150 # 8006cf08 <ftable>
    8000538e:	ffffc097          	auipc	ra,0xffffc
    80005392:	a36080e7          	jalr	-1482(ra) # 80000dc4 <release>
}
    80005396:	8526                	mv	a0,s1
    80005398:	60e2                	ld	ra,24(sp)
    8000539a:	6442                	ld	s0,16(sp)
    8000539c:	64a2                	ld	s1,8(sp)
    8000539e:	6105                	addi	sp,sp,32
    800053a0:	8082                	ret

00000000800053a2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800053a2:	1101                	addi	sp,sp,-32
    800053a4:	ec06                	sd	ra,24(sp)
    800053a6:	e822                	sd	s0,16(sp)
    800053a8:	e426                	sd	s1,8(sp)
    800053aa:	1000                	addi	s0,sp,32
    800053ac:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800053ae:	00068517          	auipc	a0,0x68
    800053b2:	b5a50513          	addi	a0,a0,-1190 # 8006cf08 <ftable>
    800053b6:	ffffc097          	auipc	ra,0xffffc
    800053ba:	95a080e7          	jalr	-1702(ra) # 80000d10 <acquire>
  if(f->ref < 1)
    800053be:	40dc                	lw	a5,4(s1)
    800053c0:	02f05263          	blez	a5,800053e4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800053c4:	2785                	addiw	a5,a5,1
    800053c6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800053c8:	00068517          	auipc	a0,0x68
    800053cc:	b4050513          	addi	a0,a0,-1216 # 8006cf08 <ftable>
    800053d0:	ffffc097          	auipc	ra,0xffffc
    800053d4:	9f4080e7          	jalr	-1548(ra) # 80000dc4 <release>
  return f;
}
    800053d8:	8526                	mv	a0,s1
    800053da:	60e2                	ld	ra,24(sp)
    800053dc:	6442                	ld	s0,16(sp)
    800053de:	64a2                	ld	s1,8(sp)
    800053e0:	6105                	addi	sp,sp,32
    800053e2:	8082                	ret
    panic("filedup");
    800053e4:	00006517          	auipc	a0,0x6
    800053e8:	23450513          	addi	a0,a0,564 # 8000b618 <etext+0x618>
    800053ec:	ffffb097          	auipc	ra,0xffffb
    800053f0:	174080e7          	jalr	372(ra) # 80000560 <panic>

00000000800053f4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800053f4:	7139                	addi	sp,sp,-64
    800053f6:	fc06                	sd	ra,56(sp)
    800053f8:	f822                	sd	s0,48(sp)
    800053fa:	f426                	sd	s1,40(sp)
    800053fc:	0080                	addi	s0,sp,64
    800053fe:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005400:	00068517          	auipc	a0,0x68
    80005404:	b0850513          	addi	a0,a0,-1272 # 8006cf08 <ftable>
    80005408:	ffffc097          	auipc	ra,0xffffc
    8000540c:	908080e7          	jalr	-1784(ra) # 80000d10 <acquire>
  if(f->ref < 1)
    80005410:	40dc                	lw	a5,4(s1)
    80005412:	06f05d63          	blez	a5,8000548c <fileclose+0x98>
    panic("fileclose");
  if(--f->ref > 0){
    80005416:	37fd                	addiw	a5,a5,-1
    80005418:	0007871b          	sext.w	a4,a5
    8000541c:	c0dc                	sw	a5,4(s1)
    8000541e:	08e04363          	bgtz	a4,800054a4 <fileclose+0xb0>
    80005422:	f04a                	sd	s2,32(sp)
    80005424:	ec4e                	sd	s3,24(sp)
    80005426:	e852                	sd	s4,16(sp)
    80005428:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000542a:	0004a903          	lw	s2,0(s1)
    8000542e:	0094ca83          	lbu	s5,9(s1)
    80005432:	0104ba03          	ld	s4,16(s1)
    80005436:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000543a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000543e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80005442:	00068517          	auipc	a0,0x68
    80005446:	ac650513          	addi	a0,a0,-1338 # 8006cf08 <ftable>
    8000544a:	ffffc097          	auipc	ra,0xffffc
    8000544e:	97a080e7          	jalr	-1670(ra) # 80000dc4 <release>

  switch (ff.type) {
    80005452:	478d                	li	a5,3
    80005454:	0af90663          	beq	s2,a5,80005500 <fileclose+0x10c>
    80005458:	0727e863          	bltu	a5,s2,800054c8 <fileclose+0xd4>
    8000545c:	4785                	li	a5,1
    8000545e:	08f90663          	beq	s2,a5,800054ea <fileclose+0xf6>
    80005462:	4789                	li	a5,2
    80005464:	04f91d63          	bne	s2,a5,800054be <fileclose+0xca>
  case FD_PIPE :
    pipeclose(ff.pipe, ff.writable);
    break;
  case FD_INODE:
    begin_op();
    80005468:	00000097          	auipc	ra,0x0
    8000546c:	ac2080e7          	jalr	-1342(ra) # 80004f2a <begin_op>
    iput(ff.ip);
    80005470:	854e                	mv	a0,s3
    80005472:	fffff097          	auipc	ra,0xfffff
    80005476:	2a8080e7          	jalr	680(ra) # 8000471a <iput>
    end_op();
    8000547a:	00000097          	auipc	ra,0x0
    8000547e:	b2a080e7          	jalr	-1238(ra) # 80004fa4 <end_op>
    break;
    80005482:	7902                	ld	s2,32(sp)
    80005484:	69e2                	ld	s3,24(sp)
    80005486:	6a42                	ld	s4,16(sp)
    80005488:	6aa2                	ld	s5,8(sp)
    8000548a:	a02d                	j	800054b4 <fileclose+0xc0>
    8000548c:	f04a                	sd	s2,32(sp)
    8000548e:	ec4e                	sd	s3,24(sp)
    80005490:	e852                	sd	s4,16(sp)
    80005492:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80005494:	00006517          	auipc	a0,0x6
    80005498:	18c50513          	addi	a0,a0,396 # 8000b620 <etext+0x620>
    8000549c:	ffffb097          	auipc	ra,0xffffb
    800054a0:	0c4080e7          	jalr	196(ra) # 80000560 <panic>
    release(&ftable.lock);
    800054a4:	00068517          	auipc	a0,0x68
    800054a8:	a6450513          	addi	a0,a0,-1436 # 8006cf08 <ftable>
    800054ac:	ffffc097          	auipc	ra,0xffffc
    800054b0:	918080e7          	jalr	-1768(ra) # 80000dc4 <release>
    end_op();
    break;
  case FD_SOCKET:
    f->sock->ops->close(f->sock);
  };
}
    800054b4:	70e2                	ld	ra,56(sp)
    800054b6:	7442                	ld	s0,48(sp)
    800054b8:	74a2                	ld	s1,40(sp)
    800054ba:	6121                	addi	sp,sp,64
    800054bc:	8082                	ret
    800054be:	7902                	ld	s2,32(sp)
    800054c0:	69e2                	ld	s3,24(sp)
    800054c2:	6a42                	ld	s4,16(sp)
    800054c4:	6aa2                	ld	s5,8(sp)
    800054c6:	b7fd                	j	800054b4 <fileclose+0xc0>
  switch (ff.type) {
    800054c8:	4791                	li	a5,4
    800054ca:	00f91b63          	bne	s2,a5,800054e0 <fileclose+0xec>
    f->sock->ops->close(f->sock);
    800054ce:	7088                	ld	a0,32(s1)
    800054d0:	653c                	ld	a5,72(a0)
    800054d2:	7b9c                	ld	a5,48(a5)
    800054d4:	9782                	jalr	a5
    800054d6:	7902                	ld	s2,32(sp)
    800054d8:	69e2                	ld	s3,24(sp)
    800054da:	6a42                	ld	s4,16(sp)
    800054dc:	6aa2                	ld	s5,8(sp)
    800054de:	bfd9                	j	800054b4 <fileclose+0xc0>
    800054e0:	7902                	ld	s2,32(sp)
    800054e2:	69e2                	ld	s3,24(sp)
    800054e4:	6a42                	ld	s4,16(sp)
    800054e6:	6aa2                	ld	s5,8(sp)
    800054e8:	b7f1                	j	800054b4 <fileclose+0xc0>
    pipeclose(ff.pipe, ff.writable);
    800054ea:	85d6                	mv	a1,s5
    800054ec:	8552                	mv	a0,s4
    800054ee:	00000097          	auipc	ra,0x0
    800054f2:	3a2080e7          	jalr	930(ra) # 80005890 <pipeclose>
    break;
    800054f6:	7902                	ld	s2,32(sp)
    800054f8:	69e2                	ld	s3,24(sp)
    800054fa:	6a42                	ld	s4,16(sp)
    800054fc:	6aa2                	ld	s5,8(sp)
    800054fe:	bf5d                	j	800054b4 <fileclose+0xc0>
    begin_op();
    80005500:	00000097          	auipc	ra,0x0
    80005504:	a2a080e7          	jalr	-1494(ra) # 80004f2a <begin_op>
    iput(ff.ip);
    80005508:	854e                	mv	a0,s3
    8000550a:	fffff097          	auipc	ra,0xfffff
    8000550e:	210080e7          	jalr	528(ra) # 8000471a <iput>
    end_op();
    80005512:	00000097          	auipc	ra,0x0
    80005516:	a92080e7          	jalr	-1390(ra) # 80004fa4 <end_op>
    break;
    8000551a:	7902                	ld	s2,32(sp)
    8000551c:	69e2                	ld	s3,24(sp)
    8000551e:	6a42                	ld	s4,16(sp)
    80005520:	6aa2                	ld	s5,8(sp)
    80005522:	bf49                	j	800054b4 <fileclose+0xc0>

0000000080005524 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005524:	715d                	addi	sp,sp,-80
    80005526:	e486                	sd	ra,72(sp)
    80005528:	e0a2                	sd	s0,64(sp)
    8000552a:	fc26                	sd	s1,56(sp)
    8000552c:	f44e                	sd	s3,40(sp)
    8000552e:	0880                	addi	s0,sp,80
    80005530:	84aa                	mv	s1,a0
    80005532:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80005534:	ffffd097          	auipc	ra,0xffffd
    80005538:	8e0080e7          	jalr	-1824(ra) # 80001e14 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000553c:	409c                	lw	a5,0(s1)
    8000553e:	37f9                	addiw	a5,a5,-2
    80005540:	4705                	li	a4,1
    80005542:	04f76863          	bltu	a4,a5,80005592 <filestat+0x6e>
    80005546:	f84a                	sd	s2,48(sp)
    80005548:	892a                	mv	s2,a0
    ilock(f->ip);
    8000554a:	6c88                	ld	a0,24(s1)
    8000554c:	fffff097          	auipc	ra,0xfffff
    80005550:	010080e7          	jalr	16(ra) # 8000455c <ilock>
    stati(f->ip, &st);
    80005554:	fb840593          	addi	a1,s0,-72
    80005558:	6c88                	ld	a0,24(s1)
    8000555a:	fffff097          	auipc	ra,0xfffff
    8000555e:	290080e7          	jalr	656(ra) # 800047ea <stati>
    iunlock(f->ip);
    80005562:	6c88                	ld	a0,24(s1)
    80005564:	fffff097          	auipc	ra,0xfffff
    80005568:	0be080e7          	jalr	190(ra) # 80004622 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000556c:	46e1                	li	a3,24
    8000556e:	fb840613          	addi	a2,s0,-72
    80005572:	85ce                	mv	a1,s3
    80005574:	05093503          	ld	a0,80(s2)
    80005578:	ffffc097          	auipc	ra,0xffffc
    8000557c:	534080e7          	jalr	1332(ra) # 80001aac <copyout>
    80005580:	41f5551b          	sraiw	a0,a0,0x1f
    80005584:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80005586:	60a6                	ld	ra,72(sp)
    80005588:	6406                	ld	s0,64(sp)
    8000558a:	74e2                	ld	s1,56(sp)
    8000558c:	79a2                	ld	s3,40(sp)
    8000558e:	6161                	addi	sp,sp,80
    80005590:	8082                	ret
  return -1;
    80005592:	557d                	li	a0,-1
    80005594:	bfcd                	j	80005586 <filestat+0x62>

0000000080005596 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005596:	7179                	addi	sp,sp,-48
    80005598:	f406                	sd	ra,40(sp)
    8000559a:	f022                	sd	s0,32(sp)
    8000559c:	e84a                	sd	s2,16(sp)
    8000559e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800055a0:	00854783          	lbu	a5,8(a0)
    800055a4:	cbc5                	beqz	a5,80005654 <fileread+0xbe>
    800055a6:	ec26                	sd	s1,24(sp)
    800055a8:	e44e                	sd	s3,8(sp)
    800055aa:	84aa                	mv	s1,a0
    800055ac:	89ae                	mv	s3,a1
    800055ae:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800055b0:	411c                	lw	a5,0(a0)
    800055b2:	4705                	li	a4,1
    800055b4:	04e78963          	beq	a5,a4,80005606 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800055b8:	470d                	li	a4,3
    800055ba:	04e78f63          	beq	a5,a4,80005618 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800055be:	4709                	li	a4,2
    800055c0:	08e79263          	bne	a5,a4,80005644 <fileread+0xae>
    ilock(f->ip);
    800055c4:	6d08                	ld	a0,24(a0)
    800055c6:	fffff097          	auipc	ra,0xfffff
    800055ca:	f96080e7          	jalr	-106(ra) # 8000455c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800055ce:	874a                	mv	a4,s2
    800055d0:	5494                	lw	a3,40(s1)
    800055d2:	864e                	mv	a2,s3
    800055d4:	4585                	li	a1,1
    800055d6:	6c88                	ld	a0,24(s1)
    800055d8:	fffff097          	auipc	ra,0xfffff
    800055dc:	23c080e7          	jalr	572(ra) # 80004814 <readi>
    800055e0:	892a                	mv	s2,a0
    800055e2:	00a05563          	blez	a0,800055ec <fileread+0x56>
      f->off += r;
    800055e6:	549c                	lw	a5,40(s1)
    800055e8:	9fa9                	addw	a5,a5,a0
    800055ea:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    800055ec:	6c88                	ld	a0,24(s1)
    800055ee:	fffff097          	auipc	ra,0xfffff
    800055f2:	034080e7          	jalr	52(ra) # 80004622 <iunlock>
    800055f6:	64e2                	ld	s1,24(sp)
    800055f8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800055fa:	854a                	mv	a0,s2
    800055fc:	70a2                	ld	ra,40(sp)
    800055fe:	7402                	ld	s0,32(sp)
    80005600:	6942                	ld	s2,16(sp)
    80005602:	6145                	addi	sp,sp,48
    80005604:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005606:	6908                	ld	a0,16(a0)
    80005608:	00000097          	auipc	ra,0x0
    8000560c:	400080e7          	jalr	1024(ra) # 80005a08 <piperead>
    80005610:	892a                	mv	s2,a0
    80005612:	64e2                	ld	s1,24(sp)
    80005614:	69a2                	ld	s3,8(sp)
    80005616:	b7d5                	j	800055fa <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80005618:	02c51783          	lh	a5,44(a0)
    8000561c:	03079693          	slli	a3,a5,0x30
    80005620:	92c1                	srli	a3,a3,0x30
    80005622:	4725                	li	a4,9
    80005624:	02d76a63          	bltu	a4,a3,80005658 <fileread+0xc2>
    80005628:	0792                	slli	a5,a5,0x4
    8000562a:	00068717          	auipc	a4,0x68
    8000562e:	83e70713          	addi	a4,a4,-1986 # 8006ce68 <devsw>
    80005632:	97ba                	add	a5,a5,a4
    80005634:	639c                	ld	a5,0(a5)
    80005636:	c78d                	beqz	a5,80005660 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80005638:	4505                	li	a0,1
    8000563a:	9782                	jalr	a5
    8000563c:	892a                	mv	s2,a0
    8000563e:	64e2                	ld	s1,24(sp)
    80005640:	69a2                	ld	s3,8(sp)
    80005642:	bf65                	j	800055fa <fileread+0x64>
    panic("fileread");
    80005644:	00006517          	auipc	a0,0x6
    80005648:	fec50513          	addi	a0,a0,-20 # 8000b630 <etext+0x630>
    8000564c:	ffffb097          	auipc	ra,0xffffb
    80005650:	f14080e7          	jalr	-236(ra) # 80000560 <panic>
    return -1;
    80005654:	597d                	li	s2,-1
    80005656:	b755                	j	800055fa <fileread+0x64>
      return -1;
    80005658:	597d                	li	s2,-1
    8000565a:	64e2                	ld	s1,24(sp)
    8000565c:	69a2                	ld	s3,8(sp)
    8000565e:	bf71                	j	800055fa <fileread+0x64>
    80005660:	597d                	li	s2,-1
    80005662:	64e2                	ld	s1,24(sp)
    80005664:	69a2                	ld	s3,8(sp)
    80005666:	bf51                	j	800055fa <fileread+0x64>

0000000080005668 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80005668:	00954783          	lbu	a5,9(a0)
    8000566c:	12078963          	beqz	a5,8000579e <filewrite+0x136>
{
    80005670:	715d                	addi	sp,sp,-80
    80005672:	e486                	sd	ra,72(sp)
    80005674:	e0a2                	sd	s0,64(sp)
    80005676:	f84a                	sd	s2,48(sp)
    80005678:	f052                	sd	s4,32(sp)
    8000567a:	e85a                	sd	s6,16(sp)
    8000567c:	0880                	addi	s0,sp,80
    8000567e:	892a                	mv	s2,a0
    80005680:	8b2e                	mv	s6,a1
    80005682:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80005684:	411c                	lw	a5,0(a0)
    80005686:	4705                	li	a4,1
    80005688:	02e78763          	beq	a5,a4,800056b6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000568c:	470d                	li	a4,3
    8000568e:	02e78a63          	beq	a5,a4,800056c2 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005692:	4709                	li	a4,2
    80005694:	0ee79863          	bne	a5,a4,80005784 <filewrite+0x11c>
    80005698:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000569a:	0cc05463          	blez	a2,80005762 <filewrite+0xfa>
    8000569e:	fc26                	sd	s1,56(sp)
    800056a0:	ec56                	sd	s5,24(sp)
    800056a2:	e45e                	sd	s7,8(sp)
    800056a4:	e062                	sd	s8,0(sp)
    int i = 0;
    800056a6:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800056a8:	6b85                	lui	s7,0x1
    800056aa:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800056ae:	6c05                	lui	s8,0x1
    800056b0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800056b4:	a851                	j	80005748 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800056b6:	6908                	ld	a0,16(a0)
    800056b8:	00000097          	auipc	ra,0x0
    800056bc:	248080e7          	jalr	584(ra) # 80005900 <pipewrite>
    800056c0:	a85d                	j	80005776 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800056c2:	02c51783          	lh	a5,44(a0)
    800056c6:	03079693          	slli	a3,a5,0x30
    800056ca:	92c1                	srli	a3,a3,0x30
    800056cc:	4725                	li	a4,9
    800056ce:	0cd76a63          	bltu	a4,a3,800057a2 <filewrite+0x13a>
    800056d2:	0792                	slli	a5,a5,0x4
    800056d4:	00067717          	auipc	a4,0x67
    800056d8:	79470713          	addi	a4,a4,1940 # 8006ce68 <devsw>
    800056dc:	97ba                	add	a5,a5,a4
    800056de:	679c                	ld	a5,8(a5)
    800056e0:	c3f9                	beqz	a5,800057a6 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    800056e2:	4505                	li	a0,1
    800056e4:	9782                	jalr	a5
    800056e6:	a841                	j	80005776 <filewrite+0x10e>
      if(n1 > max)
    800056e8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800056ec:	00000097          	auipc	ra,0x0
    800056f0:	83e080e7          	jalr	-1986(ra) # 80004f2a <begin_op>
      ilock(f->ip);
    800056f4:	01893503          	ld	a0,24(s2)
    800056f8:	fffff097          	auipc	ra,0xfffff
    800056fc:	e64080e7          	jalr	-412(ra) # 8000455c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005700:	8756                	mv	a4,s5
    80005702:	02892683          	lw	a3,40(s2)
    80005706:	01698633          	add	a2,s3,s6
    8000570a:	4585                	li	a1,1
    8000570c:	01893503          	ld	a0,24(s2)
    80005710:	fffff097          	auipc	ra,0xfffff
    80005714:	214080e7          	jalr	532(ra) # 80004924 <writei>
    80005718:	84aa                	mv	s1,a0
    8000571a:	00a05763          	blez	a0,80005728 <filewrite+0xc0>
        f->off += r;
    8000571e:	02892783          	lw	a5,40(s2)
    80005722:	9fa9                	addw	a5,a5,a0
    80005724:	02f92423          	sw	a5,40(s2)
      iunlock(f->ip);
    80005728:	01893503          	ld	a0,24(s2)
    8000572c:	fffff097          	auipc	ra,0xfffff
    80005730:	ef6080e7          	jalr	-266(ra) # 80004622 <iunlock>
      end_op();
    80005734:	00000097          	auipc	ra,0x0
    80005738:	870080e7          	jalr	-1936(ra) # 80004fa4 <end_op>

      if(r != n1){
    8000573c:	029a9563          	bne	s5,s1,80005766 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80005740:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80005744:	0149da63          	bge	s3,s4,80005758 <filewrite+0xf0>
      int n1 = n - i;
    80005748:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000574c:	0004879b          	sext.w	a5,s1
    80005750:	f8fbdce3          	bge	s7,a5,800056e8 <filewrite+0x80>
    80005754:	84e2                	mv	s1,s8
    80005756:	bf49                	j	800056e8 <filewrite+0x80>
    80005758:	74e2                	ld	s1,56(sp)
    8000575a:	6ae2                	ld	s5,24(sp)
    8000575c:	6ba2                	ld	s7,8(sp)
    8000575e:	6c02                	ld	s8,0(sp)
    80005760:	a039                	j	8000576e <filewrite+0x106>
    int i = 0;
    80005762:	4981                	li	s3,0
    80005764:	a029                	j	8000576e <filewrite+0x106>
    80005766:	74e2                	ld	s1,56(sp)
    80005768:	6ae2                	ld	s5,24(sp)
    8000576a:	6ba2                	ld	s7,8(sp)
    8000576c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000576e:	033a1e63          	bne	s4,s3,800057aa <filewrite+0x142>
    80005772:	8552                	mv	a0,s4
    80005774:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005776:	60a6                	ld	ra,72(sp)
    80005778:	6406                	ld	s0,64(sp)
    8000577a:	7942                	ld	s2,48(sp)
    8000577c:	7a02                	ld	s4,32(sp)
    8000577e:	6b42                	ld	s6,16(sp)
    80005780:	6161                	addi	sp,sp,80
    80005782:	8082                	ret
    80005784:	fc26                	sd	s1,56(sp)
    80005786:	f44e                	sd	s3,40(sp)
    80005788:	ec56                	sd	s5,24(sp)
    8000578a:	e45e                	sd	s7,8(sp)
    8000578c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000578e:	00006517          	auipc	a0,0x6
    80005792:	eb250513          	addi	a0,a0,-334 # 8000b640 <etext+0x640>
    80005796:	ffffb097          	auipc	ra,0xffffb
    8000579a:	dca080e7          	jalr	-566(ra) # 80000560 <panic>
    return -1;
    8000579e:	557d                	li	a0,-1
}
    800057a0:	8082                	ret
      return -1;
    800057a2:	557d                	li	a0,-1
    800057a4:	bfc9                	j	80005776 <filewrite+0x10e>
    800057a6:	557d                	li	a0,-1
    800057a8:	b7f9                	j	80005776 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    800057aa:	557d                	li	a0,-1
    800057ac:	79a2                	ld	s3,40(sp)
    800057ae:	b7e1                	j	80005776 <filewrite+0x10e>

00000000800057b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800057b0:	7179                	addi	sp,sp,-48
    800057b2:	f406                	sd	ra,40(sp)
    800057b4:	f022                	sd	s0,32(sp)
    800057b6:	ec26                	sd	s1,24(sp)
    800057b8:	e052                	sd	s4,0(sp)
    800057ba:	1800                	addi	s0,sp,48
    800057bc:	84aa                	mv	s1,a0
    800057be:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800057c0:	0005b023          	sd	zero,0(a1)
    800057c4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800057c8:	00000097          	auipc	ra,0x0
    800057cc:	b70080e7          	jalr	-1168(ra) # 80005338 <filealloc>
    800057d0:	e088                	sd	a0,0(s1)
    800057d2:	cd49                	beqz	a0,8000586c <pipealloc+0xbc>
    800057d4:	00000097          	auipc	ra,0x0
    800057d8:	b64080e7          	jalr	-1180(ra) # 80005338 <filealloc>
    800057dc:	00aa3023          	sd	a0,0(s4)
    800057e0:	c141                	beqz	a0,80005860 <pipealloc+0xb0>
    800057e2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800057e4:	ffffb097          	auipc	ra,0xffffb
    800057e8:	41e080e7          	jalr	1054(ra) # 80000c02 <kalloc>
    800057ec:	892a                	mv	s2,a0
    800057ee:	c13d                	beqz	a0,80005854 <pipealloc+0xa4>
    800057f0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800057f2:	4985                	li	s3,1
    800057f4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800057f8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800057fc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005800:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80005804:	00006597          	auipc	a1,0x6
    80005808:	e4c58593          	addi	a1,a1,-436 # 8000b650 <etext+0x650>
    8000580c:	ffffb097          	auipc	ra,0xffffb
    80005810:	474080e7          	jalr	1140(ra) # 80000c80 <initlock>
  (*f0)->type = FD_PIPE;
    80005814:	609c                	ld	a5,0(s1)
    80005816:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000581a:	609c                	ld	a5,0(s1)
    8000581c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005820:	609c                	ld	a5,0(s1)
    80005822:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80005826:	609c                	ld	a5,0(s1)
    80005828:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000582c:	000a3783          	ld	a5,0(s4)
    80005830:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80005834:	000a3783          	ld	a5,0(s4)
    80005838:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000583c:	000a3783          	ld	a5,0(s4)
    80005840:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80005844:	000a3783          	ld	a5,0(s4)
    80005848:	0127b823          	sd	s2,16(a5)
  return 0;
    8000584c:	4501                	li	a0,0
    8000584e:	6942                	ld	s2,16(sp)
    80005850:	69a2                	ld	s3,8(sp)
    80005852:	a03d                	j	80005880 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005854:	6088                	ld	a0,0(s1)
    80005856:	c119                	beqz	a0,8000585c <pipealloc+0xac>
    80005858:	6942                	ld	s2,16(sp)
    8000585a:	a029                	j	80005864 <pipealloc+0xb4>
    8000585c:	6942                	ld	s2,16(sp)
    8000585e:	a039                	j	8000586c <pipealloc+0xbc>
    80005860:	6088                	ld	a0,0(s1)
    80005862:	c50d                	beqz	a0,8000588c <pipealloc+0xdc>
    fileclose(*f0);
    80005864:	00000097          	auipc	ra,0x0
    80005868:	b90080e7          	jalr	-1136(ra) # 800053f4 <fileclose>
  if(*f1)
    8000586c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005870:	557d                	li	a0,-1
  if(*f1)
    80005872:	c799                	beqz	a5,80005880 <pipealloc+0xd0>
    fileclose(*f1);
    80005874:	853e                	mv	a0,a5
    80005876:	00000097          	auipc	ra,0x0
    8000587a:	b7e080e7          	jalr	-1154(ra) # 800053f4 <fileclose>
  return -1;
    8000587e:	557d                	li	a0,-1
}
    80005880:	70a2                	ld	ra,40(sp)
    80005882:	7402                	ld	s0,32(sp)
    80005884:	64e2                	ld	s1,24(sp)
    80005886:	6a02                	ld	s4,0(sp)
    80005888:	6145                	addi	sp,sp,48
    8000588a:	8082                	ret
  return -1;
    8000588c:	557d                	li	a0,-1
    8000588e:	bfcd                	j	80005880 <pipealloc+0xd0>

0000000080005890 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005890:	1101                	addi	sp,sp,-32
    80005892:	ec06                	sd	ra,24(sp)
    80005894:	e822                	sd	s0,16(sp)
    80005896:	e426                	sd	s1,8(sp)
    80005898:	e04a                	sd	s2,0(sp)
    8000589a:	1000                	addi	s0,sp,32
    8000589c:	84aa                	mv	s1,a0
    8000589e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800058a0:	ffffb097          	auipc	ra,0xffffb
    800058a4:	470080e7          	jalr	1136(ra) # 80000d10 <acquire>
  if(writable){
    800058a8:	02090d63          	beqz	s2,800058e2 <pipeclose+0x52>
    pi->writeopen = 0;
    800058ac:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800058b0:	21848513          	addi	a0,s1,536
    800058b4:	ffffd097          	auipc	ra,0xffffd
    800058b8:	e72080e7          	jalr	-398(ra) # 80002726 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800058bc:	2204b783          	ld	a5,544(s1)
    800058c0:	eb95                	bnez	a5,800058f4 <pipeclose+0x64>
    release(&pi->lock);
    800058c2:	8526                	mv	a0,s1
    800058c4:	ffffb097          	auipc	ra,0xffffb
    800058c8:	500080e7          	jalr	1280(ra) # 80000dc4 <release>
    kfree((char*)pi);
    800058cc:	8526                	mv	a0,s1
    800058ce:	ffffb097          	auipc	ra,0xffffb
    800058d2:	1cc080e7          	jalr	460(ra) # 80000a9a <kfree>
  } else
    release(&pi->lock);
}
    800058d6:	60e2                	ld	ra,24(sp)
    800058d8:	6442                	ld	s0,16(sp)
    800058da:	64a2                	ld	s1,8(sp)
    800058dc:	6902                	ld	s2,0(sp)
    800058de:	6105                	addi	sp,sp,32
    800058e0:	8082                	ret
    pi->readopen = 0;
    800058e2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800058e6:	21c48513          	addi	a0,s1,540
    800058ea:	ffffd097          	auipc	ra,0xffffd
    800058ee:	e3c080e7          	jalr	-452(ra) # 80002726 <wakeup>
    800058f2:	b7e9                	j	800058bc <pipeclose+0x2c>
    release(&pi->lock);
    800058f4:	8526                	mv	a0,s1
    800058f6:	ffffb097          	auipc	ra,0xffffb
    800058fa:	4ce080e7          	jalr	1230(ra) # 80000dc4 <release>
}
    800058fe:	bfe1                	j	800058d6 <pipeclose+0x46>

0000000080005900 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005900:	711d                	addi	sp,sp,-96
    80005902:	ec86                	sd	ra,88(sp)
    80005904:	e8a2                	sd	s0,80(sp)
    80005906:	e4a6                	sd	s1,72(sp)
    80005908:	e0ca                	sd	s2,64(sp)
    8000590a:	fc4e                	sd	s3,56(sp)
    8000590c:	f852                	sd	s4,48(sp)
    8000590e:	f456                	sd	s5,40(sp)
    80005910:	1080                	addi	s0,sp,96
    80005912:	84aa                	mv	s1,a0
    80005914:	8aae                	mv	s5,a1
    80005916:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005918:	ffffc097          	auipc	ra,0xffffc
    8000591c:	4fc080e7          	jalr	1276(ra) # 80001e14 <myproc>
    80005920:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005922:	8526                	mv	a0,s1
    80005924:	ffffb097          	auipc	ra,0xffffb
    80005928:	3ec080e7          	jalr	1004(ra) # 80000d10 <acquire>
  while(i < n){
    8000592c:	0d405863          	blez	s4,800059fc <pipewrite+0xfc>
    80005930:	f05a                	sd	s6,32(sp)
    80005932:	ec5e                	sd	s7,24(sp)
    80005934:	e862                	sd	s8,16(sp)
  int i = 0;
    80005936:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005938:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000593a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000593e:	21c48b93          	addi	s7,s1,540
    80005942:	a089                	j	80005984 <pipewrite+0x84>
      release(&pi->lock);
    80005944:	8526                	mv	a0,s1
    80005946:	ffffb097          	auipc	ra,0xffffb
    8000594a:	47e080e7          	jalr	1150(ra) # 80000dc4 <release>
      return -1;
    8000594e:	597d                	li	s2,-1
    80005950:	7b02                	ld	s6,32(sp)
    80005952:	6be2                	ld	s7,24(sp)
    80005954:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005956:	854a                	mv	a0,s2
    80005958:	60e6                	ld	ra,88(sp)
    8000595a:	6446                	ld	s0,80(sp)
    8000595c:	64a6                	ld	s1,72(sp)
    8000595e:	6906                	ld	s2,64(sp)
    80005960:	79e2                	ld	s3,56(sp)
    80005962:	7a42                	ld	s4,48(sp)
    80005964:	7aa2                	ld	s5,40(sp)
    80005966:	6125                	addi	sp,sp,96
    80005968:	8082                	ret
      wakeup(&pi->nread);
    8000596a:	8562                	mv	a0,s8
    8000596c:	ffffd097          	auipc	ra,0xffffd
    80005970:	dba080e7          	jalr	-582(ra) # 80002726 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005974:	85a6                	mv	a1,s1
    80005976:	855e                	mv	a0,s7
    80005978:	ffffd097          	auipc	ra,0xffffd
    8000597c:	d4a080e7          	jalr	-694(ra) # 800026c2 <sleep>
  while(i < n){
    80005980:	05495f63          	bge	s2,s4,800059de <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80005984:	2204a783          	lw	a5,544(s1)
    80005988:	dfd5                	beqz	a5,80005944 <pipewrite+0x44>
    8000598a:	854e                	mv	a0,s3
    8000598c:	ffffd097          	auipc	ra,0xffffd
    80005990:	15c080e7          	jalr	348(ra) # 80002ae8 <killed>
    80005994:	f945                	bnez	a0,80005944 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005996:	2184a783          	lw	a5,536(s1)
    8000599a:	21c4a703          	lw	a4,540(s1)
    8000599e:	2007879b          	addiw	a5,a5,512
    800059a2:	fcf704e3          	beq	a4,a5,8000596a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800059a6:	4685                	li	a3,1
    800059a8:	01590633          	add	a2,s2,s5
    800059ac:	faf40593          	addi	a1,s0,-81
    800059b0:	0509b503          	ld	a0,80(s3)
    800059b4:	ffffc097          	auipc	ra,0xffffc
    800059b8:	184080e7          	jalr	388(ra) # 80001b38 <copyin>
    800059bc:	05650263          	beq	a0,s6,80005a00 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800059c0:	21c4a783          	lw	a5,540(s1)
    800059c4:	0017871b          	addiw	a4,a5,1
    800059c8:	20e4ae23          	sw	a4,540(s1)
    800059cc:	1ff7f793          	andi	a5,a5,511
    800059d0:	97a6                	add	a5,a5,s1
    800059d2:	faf44703          	lbu	a4,-81(s0)
    800059d6:	00e78c23          	sb	a4,24(a5)
      i++;
    800059da:	2905                	addiw	s2,s2,1
    800059dc:	b755                	j	80005980 <pipewrite+0x80>
    800059de:	7b02                	ld	s6,32(sp)
    800059e0:	6be2                	ld	s7,24(sp)
    800059e2:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800059e4:	21848513          	addi	a0,s1,536
    800059e8:	ffffd097          	auipc	ra,0xffffd
    800059ec:	d3e080e7          	jalr	-706(ra) # 80002726 <wakeup>
  release(&pi->lock);
    800059f0:	8526                	mv	a0,s1
    800059f2:	ffffb097          	auipc	ra,0xffffb
    800059f6:	3d2080e7          	jalr	978(ra) # 80000dc4 <release>
  return i;
    800059fa:	bfb1                	j	80005956 <pipewrite+0x56>
  int i = 0;
    800059fc:	4901                	li	s2,0
    800059fe:	b7dd                	j	800059e4 <pipewrite+0xe4>
    80005a00:	7b02                	ld	s6,32(sp)
    80005a02:	6be2                	ld	s7,24(sp)
    80005a04:	6c42                	ld	s8,16(sp)
    80005a06:	bff9                	j	800059e4 <pipewrite+0xe4>

0000000080005a08 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005a08:	715d                	addi	sp,sp,-80
    80005a0a:	e486                	sd	ra,72(sp)
    80005a0c:	e0a2                	sd	s0,64(sp)
    80005a0e:	fc26                	sd	s1,56(sp)
    80005a10:	f84a                	sd	s2,48(sp)
    80005a12:	f44e                	sd	s3,40(sp)
    80005a14:	f052                	sd	s4,32(sp)
    80005a16:	ec56                	sd	s5,24(sp)
    80005a18:	0880                	addi	s0,sp,80
    80005a1a:	84aa                	mv	s1,a0
    80005a1c:	892e                	mv	s2,a1
    80005a1e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005a20:	ffffc097          	auipc	ra,0xffffc
    80005a24:	3f4080e7          	jalr	1012(ra) # 80001e14 <myproc>
    80005a28:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005a2a:	8526                	mv	a0,s1
    80005a2c:	ffffb097          	auipc	ra,0xffffb
    80005a30:	2e4080e7          	jalr	740(ra) # 80000d10 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005a34:	2184a703          	lw	a4,536(s1)
    80005a38:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005a3c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005a40:	02f71963          	bne	a4,a5,80005a72 <piperead+0x6a>
    80005a44:	2244a783          	lw	a5,548(s1)
    80005a48:	cf95                	beqz	a5,80005a84 <piperead+0x7c>
    if(killed(pr)){
    80005a4a:	8552                	mv	a0,s4
    80005a4c:	ffffd097          	auipc	ra,0xffffd
    80005a50:	09c080e7          	jalr	156(ra) # 80002ae8 <killed>
    80005a54:	e10d                	bnez	a0,80005a76 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005a56:	85a6                	mv	a1,s1
    80005a58:	854e                	mv	a0,s3
    80005a5a:	ffffd097          	auipc	ra,0xffffd
    80005a5e:	c68080e7          	jalr	-920(ra) # 800026c2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005a62:	2184a703          	lw	a4,536(s1)
    80005a66:	21c4a783          	lw	a5,540(s1)
    80005a6a:	fcf70de3          	beq	a4,a5,80005a44 <piperead+0x3c>
    80005a6e:	e85a                	sd	s6,16(sp)
    80005a70:	a819                	j	80005a86 <piperead+0x7e>
    80005a72:	e85a                	sd	s6,16(sp)
    80005a74:	a809                	j	80005a86 <piperead+0x7e>
      release(&pi->lock);
    80005a76:	8526                	mv	a0,s1
    80005a78:	ffffb097          	auipc	ra,0xffffb
    80005a7c:	34c080e7          	jalr	844(ra) # 80000dc4 <release>
      return -1;
    80005a80:	59fd                	li	s3,-1
    80005a82:	a0a5                	j	80005aea <piperead+0xe2>
    80005a84:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005a86:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005a88:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005a8a:	05505463          	blez	s5,80005ad2 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80005a8e:	2184a783          	lw	a5,536(s1)
    80005a92:	21c4a703          	lw	a4,540(s1)
    80005a96:	02f70e63          	beq	a4,a5,80005ad2 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005a9a:	0017871b          	addiw	a4,a5,1
    80005a9e:	20e4ac23          	sw	a4,536(s1)
    80005aa2:	1ff7f793          	andi	a5,a5,511
    80005aa6:	97a6                	add	a5,a5,s1
    80005aa8:	0187c783          	lbu	a5,24(a5)
    80005aac:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005ab0:	4685                	li	a3,1
    80005ab2:	fbf40613          	addi	a2,s0,-65
    80005ab6:	85ca                	mv	a1,s2
    80005ab8:	050a3503          	ld	a0,80(s4)
    80005abc:	ffffc097          	auipc	ra,0xffffc
    80005ac0:	ff0080e7          	jalr	-16(ra) # 80001aac <copyout>
    80005ac4:	01650763          	beq	a0,s6,80005ad2 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005ac8:	2985                	addiw	s3,s3,1
    80005aca:	0905                	addi	s2,s2,1
    80005acc:	fd3a91e3          	bne	s5,s3,80005a8e <piperead+0x86>
    80005ad0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005ad2:	21c48513          	addi	a0,s1,540
    80005ad6:	ffffd097          	auipc	ra,0xffffd
    80005ada:	c50080e7          	jalr	-944(ra) # 80002726 <wakeup>
  release(&pi->lock);
    80005ade:	8526                	mv	a0,s1
    80005ae0:	ffffb097          	auipc	ra,0xffffb
    80005ae4:	2e4080e7          	jalr	740(ra) # 80000dc4 <release>
    80005ae8:	6b42                	ld	s6,16(sp)
  return i;
}
    80005aea:	854e                	mv	a0,s3
    80005aec:	60a6                	ld	ra,72(sp)
    80005aee:	6406                	ld	s0,64(sp)
    80005af0:	74e2                	ld	s1,56(sp)
    80005af2:	7942                	ld	s2,48(sp)
    80005af4:	79a2                	ld	s3,40(sp)
    80005af6:	7a02                	ld	s4,32(sp)
    80005af8:	6ae2                	ld	s5,24(sp)
    80005afa:	6161                	addi	sp,sp,80
    80005afc:	8082                	ret

0000000080005afe <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005afe:	1141                	addi	sp,sp,-16
    80005b00:	e422                	sd	s0,8(sp)
    80005b02:	0800                	addi	s0,sp,16
    80005b04:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005b06:	8905                	andi	a0,a0,1
    80005b08:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005b0a:	8b89                	andi	a5,a5,2
    80005b0c:	c399                	beqz	a5,80005b12 <flags2perm+0x14>
      perm |= PTE_W;
    80005b0e:	00456513          	ori	a0,a0,4
    return perm;
}
    80005b12:	6422                	ld	s0,8(sp)
    80005b14:	0141                	addi	sp,sp,16
    80005b16:	8082                	ret

0000000080005b18 <exec>:

int
exec(char *path, char **argv)
{
    80005b18:	df010113          	addi	sp,sp,-528
    80005b1c:	20113423          	sd	ra,520(sp)
    80005b20:	20813023          	sd	s0,512(sp)
    80005b24:	ffa6                	sd	s1,504(sp)
    80005b26:	fbca                	sd	s2,496(sp)
    80005b28:	0c00                	addi	s0,sp,528
    80005b2a:	892a                	mv	s2,a0
    80005b2c:	dea43c23          	sd	a0,-520(s0)
    80005b30:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005b34:	ffffc097          	auipc	ra,0xffffc
    80005b38:	2e0080e7          	jalr	736(ra) # 80001e14 <myproc>
    80005b3c:	84aa                	mv	s1,a0

  begin_op();
    80005b3e:	fffff097          	auipc	ra,0xfffff
    80005b42:	3ec080e7          	jalr	1004(ra) # 80004f2a <begin_op>

  if((ip = namei(path)) == 0){
    80005b46:	854a                	mv	a0,s2
    80005b48:	fffff097          	auipc	ra,0xfffff
    80005b4c:	1e2080e7          	jalr	482(ra) # 80004d2a <namei>
    80005b50:	c135                	beqz	a0,80005bb4 <exec+0x9c>
    80005b52:	f3d2                	sd	s4,480(sp)
    80005b54:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005b56:	fffff097          	auipc	ra,0xfffff
    80005b5a:	a06080e7          	jalr	-1530(ra) # 8000455c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005b5e:	04000713          	li	a4,64
    80005b62:	4681                	li	a3,0
    80005b64:	e5040613          	addi	a2,s0,-432
    80005b68:	4581                	li	a1,0
    80005b6a:	8552                	mv	a0,s4
    80005b6c:	fffff097          	auipc	ra,0xfffff
    80005b70:	ca8080e7          	jalr	-856(ra) # 80004814 <readi>
    80005b74:	04000793          	li	a5,64
    80005b78:	00f51a63          	bne	a0,a5,80005b8c <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005b7c:	e5042703          	lw	a4,-432(s0)
    80005b80:	464c47b7          	lui	a5,0x464c4
    80005b84:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005b88:	02f70c63          	beq	a4,a5,80005bc0 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005b8c:	8552                	mv	a0,s4
    80005b8e:	fffff097          	auipc	ra,0xfffff
    80005b92:	c34080e7          	jalr	-972(ra) # 800047c2 <iunlockput>
    end_op();
    80005b96:	fffff097          	auipc	ra,0xfffff
    80005b9a:	40e080e7          	jalr	1038(ra) # 80004fa4 <end_op>
  }
  return -1;
    80005b9e:	557d                	li	a0,-1
    80005ba0:	7a1e                	ld	s4,480(sp)
}
    80005ba2:	20813083          	ld	ra,520(sp)
    80005ba6:	20013403          	ld	s0,512(sp)
    80005baa:	74fe                	ld	s1,504(sp)
    80005bac:	795e                	ld	s2,496(sp)
    80005bae:	21010113          	addi	sp,sp,528
    80005bb2:	8082                	ret
    end_op();
    80005bb4:	fffff097          	auipc	ra,0xfffff
    80005bb8:	3f0080e7          	jalr	1008(ra) # 80004fa4 <end_op>
    return -1;
    80005bbc:	557d                	li	a0,-1
    80005bbe:	b7d5                	j	80005ba2 <exec+0x8a>
    80005bc0:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005bc2:	8526                	mv	a0,s1
    80005bc4:	ffffc097          	auipc	ra,0xffffc
    80005bc8:	314080e7          	jalr	788(ra) # 80001ed8 <proc_pagetable>
    80005bcc:	8b2a                	mv	s6,a0
    80005bce:	30050f63          	beqz	a0,80005eec <exec+0x3d4>
    80005bd2:	f7ce                	sd	s3,488(sp)
    80005bd4:	efd6                	sd	s5,472(sp)
    80005bd6:	e7de                	sd	s7,456(sp)
    80005bd8:	e3e2                	sd	s8,448(sp)
    80005bda:	ff66                	sd	s9,440(sp)
    80005bdc:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005bde:	e7042d03          	lw	s10,-400(s0)
    80005be2:	e8845783          	lhu	a5,-376(s0)
    80005be6:	14078d63          	beqz	a5,80005d40 <exec+0x228>
    80005bea:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005bec:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005bee:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80005bf0:	6c85                	lui	s9,0x1
    80005bf2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005bf6:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005bfa:	6a85                	lui	s5,0x1
    80005bfc:	a0b5                	j	80005c68 <exec+0x150>
      panic("loadseg: address should exist");
    80005bfe:	00006517          	auipc	a0,0x6
    80005c02:	a5a50513          	addi	a0,a0,-1446 # 8000b658 <etext+0x658>
    80005c06:	ffffb097          	auipc	ra,0xffffb
    80005c0a:	95a080e7          	jalr	-1702(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005c0e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005c10:	8726                	mv	a4,s1
    80005c12:	012c06bb          	addw	a3,s8,s2
    80005c16:	4581                	li	a1,0
    80005c18:	8552                	mv	a0,s4
    80005c1a:	fffff097          	auipc	ra,0xfffff
    80005c1e:	bfa080e7          	jalr	-1030(ra) # 80004814 <readi>
    80005c22:	2501                	sext.w	a0,a0
    80005c24:	28a49863          	bne	s1,a0,80005eb4 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    80005c28:	012a893b          	addw	s2,s5,s2
    80005c2c:	03397563          	bgeu	s2,s3,80005c56 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80005c30:	02091593          	slli	a1,s2,0x20
    80005c34:	9181                	srli	a1,a1,0x20
    80005c36:	95de                	add	a1,a1,s7
    80005c38:	855a                	mv	a0,s6
    80005c3a:	ffffb097          	auipc	ra,0xffffb
    80005c3e:	56c080e7          	jalr	1388(ra) # 800011a6 <walkaddr>
    80005c42:	862a                	mv	a2,a0
    if(pa == 0)
    80005c44:	dd4d                	beqz	a0,80005bfe <exec+0xe6>
    if(sz - i < PGSIZE)
    80005c46:	412984bb          	subw	s1,s3,s2
    80005c4a:	0004879b          	sext.w	a5,s1
    80005c4e:	fcfcf0e3          	bgeu	s9,a5,80005c0e <exec+0xf6>
    80005c52:	84d6                	mv	s1,s5
    80005c54:	bf6d                	j	80005c0e <exec+0xf6>
    sz = sz1;
    80005c56:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005c5a:	2d85                	addiw	s11,s11,1
    80005c5c:	038d0d1b          	addiw	s10,s10,56
    80005c60:	e8845783          	lhu	a5,-376(s0)
    80005c64:	08fdd663          	bge	s11,a5,80005cf0 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005c68:	2d01                	sext.w	s10,s10
    80005c6a:	03800713          	li	a4,56
    80005c6e:	86ea                	mv	a3,s10
    80005c70:	e1840613          	addi	a2,s0,-488
    80005c74:	4581                	li	a1,0
    80005c76:	8552                	mv	a0,s4
    80005c78:	fffff097          	auipc	ra,0xfffff
    80005c7c:	b9c080e7          	jalr	-1124(ra) # 80004814 <readi>
    80005c80:	03800793          	li	a5,56
    80005c84:	20f51063          	bne	a0,a5,80005e84 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    80005c88:	e1842783          	lw	a5,-488(s0)
    80005c8c:	4705                	li	a4,1
    80005c8e:	fce796e3          	bne	a5,a4,80005c5a <exec+0x142>
    if(ph.memsz < ph.filesz)
    80005c92:	e4043483          	ld	s1,-448(s0)
    80005c96:	e3843783          	ld	a5,-456(s0)
    80005c9a:	1ef4e963          	bltu	s1,a5,80005e8c <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005c9e:	e2843783          	ld	a5,-472(s0)
    80005ca2:	94be                	add	s1,s1,a5
    80005ca4:	1ef4e863          	bltu	s1,a5,80005e94 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80005ca8:	df043703          	ld	a4,-528(s0)
    80005cac:	8ff9                	and	a5,a5,a4
    80005cae:	1e079763          	bnez	a5,80005e9c <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005cb2:	e1c42503          	lw	a0,-484(s0)
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	e48080e7          	jalr	-440(ra) # 80005afe <flags2perm>
    80005cbe:	86aa                	mv	a3,a0
    80005cc0:	8626                	mv	a2,s1
    80005cc2:	85ca                	mv	a1,s2
    80005cc4:	855a                	mv	a0,s6
    80005cc6:	ffffc097          	auipc	ra,0xffffc
    80005cca:	8ba080e7          	jalr	-1862(ra) # 80001580 <uvmalloc>
    80005cce:	e0a43423          	sd	a0,-504(s0)
    80005cd2:	1c050963          	beqz	a0,80005ea4 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005cd6:	e2843b83          	ld	s7,-472(s0)
    80005cda:	e2042c03          	lw	s8,-480(s0)
    80005cde:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005ce2:	00098463          	beqz	s3,80005cea <exec+0x1d2>
    80005ce6:	4901                	li	s2,0
    80005ce8:	b7a1                	j	80005c30 <exec+0x118>
    sz = sz1;
    80005cea:	e0843903          	ld	s2,-504(s0)
    80005cee:	b7b5                	j	80005c5a <exec+0x142>
    80005cf0:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80005cf2:	8552                	mv	a0,s4
    80005cf4:	fffff097          	auipc	ra,0xfffff
    80005cf8:	ace080e7          	jalr	-1330(ra) # 800047c2 <iunlockput>
  end_op();
    80005cfc:	fffff097          	auipc	ra,0xfffff
    80005d00:	2a8080e7          	jalr	680(ra) # 80004fa4 <end_op>
  p = myproc();
    80005d04:	ffffc097          	auipc	ra,0xffffc
    80005d08:	110080e7          	jalr	272(ra) # 80001e14 <myproc>
    80005d0c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005d0e:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80005d12:	6985                	lui	s3,0x1
    80005d14:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005d16:	99ca                	add	s3,s3,s2
    80005d18:	77fd                	lui	a5,0xfffff
    80005d1a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005d1e:	4691                	li	a3,4
    80005d20:	6609                	lui	a2,0x2
    80005d22:	964e                	add	a2,a2,s3
    80005d24:	85ce                	mv	a1,s3
    80005d26:	855a                	mv	a0,s6
    80005d28:	ffffc097          	auipc	ra,0xffffc
    80005d2c:	858080e7          	jalr	-1960(ra) # 80001580 <uvmalloc>
    80005d30:	892a                	mv	s2,a0
    80005d32:	e0a43423          	sd	a0,-504(s0)
    80005d36:	e519                	bnez	a0,80005d44 <exec+0x22c>
  if(pagetable)
    80005d38:	e1343423          	sd	s3,-504(s0)
    80005d3c:	4a01                	li	s4,0
    80005d3e:	aaa5                	j	80005eb6 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005d40:	4901                	li	s2,0
    80005d42:	bf45                	j	80005cf2 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005d44:	75f9                	lui	a1,0xffffe
    80005d46:	95aa                	add	a1,a1,a0
    80005d48:	855a                	mv	a0,s6
    80005d4a:	ffffc097          	auipc	ra,0xffffc
    80005d4e:	d30080e7          	jalr	-720(ra) # 80001a7a <uvmclear>
  stackbase = sp - PGSIZE;
    80005d52:	7bfd                	lui	s7,0xfffff
    80005d54:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80005d56:	e0043783          	ld	a5,-512(s0)
    80005d5a:	6388                	ld	a0,0(a5)
    80005d5c:	c52d                	beqz	a0,80005dc6 <exec+0x2ae>
    80005d5e:	e9040993          	addi	s3,s0,-368
    80005d62:	f9040c13          	addi	s8,s0,-112
    80005d66:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005d68:	ffffb097          	auipc	ra,0xffffb
    80005d6c:	218080e7          	jalr	536(ra) # 80000f80 <strlen>
    80005d70:	0015079b          	addiw	a5,a0,1
    80005d74:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005d78:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005d7c:	13796863          	bltu	s2,s7,80005eac <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005d80:	e0043d03          	ld	s10,-512(s0)
    80005d84:	000d3a03          	ld	s4,0(s10)
    80005d88:	8552                	mv	a0,s4
    80005d8a:	ffffb097          	auipc	ra,0xffffb
    80005d8e:	1f6080e7          	jalr	502(ra) # 80000f80 <strlen>
    80005d92:	0015069b          	addiw	a3,a0,1
    80005d96:	8652                	mv	a2,s4
    80005d98:	85ca                	mv	a1,s2
    80005d9a:	855a                	mv	a0,s6
    80005d9c:	ffffc097          	auipc	ra,0xffffc
    80005da0:	d10080e7          	jalr	-752(ra) # 80001aac <copyout>
    80005da4:	10054663          	bltz	a0,80005eb0 <exec+0x398>
    ustack[argc] = sp;
    80005da8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005dac:	0485                	addi	s1,s1,1
    80005dae:	008d0793          	addi	a5,s10,8
    80005db2:	e0f43023          	sd	a5,-512(s0)
    80005db6:	008d3503          	ld	a0,8(s10)
    80005dba:	c909                	beqz	a0,80005dcc <exec+0x2b4>
    if(argc >= MAXARG)
    80005dbc:	09a1                	addi	s3,s3,8
    80005dbe:	fb8995e3          	bne	s3,s8,80005d68 <exec+0x250>
  ip = 0;
    80005dc2:	4a01                	li	s4,0
    80005dc4:	a8cd                	j	80005eb6 <exec+0x39e>
  sp = sz;
    80005dc6:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005dca:	4481                	li	s1,0
  ustack[argc] = 0;
    80005dcc:	00349793          	slli	a5,s1,0x3
    80005dd0:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ff8eaf8>
    80005dd4:	97a2                	add	a5,a5,s0
    80005dd6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005dda:	00148693          	addi	a3,s1,1
    80005dde:	068e                	slli	a3,a3,0x3
    80005de0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005de4:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005de8:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005dec:	f57966e3          	bltu	s2,s7,80005d38 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005df0:	e9040613          	addi	a2,s0,-368
    80005df4:	85ca                	mv	a1,s2
    80005df6:	855a                	mv	a0,s6
    80005df8:	ffffc097          	auipc	ra,0xffffc
    80005dfc:	cb4080e7          	jalr	-844(ra) # 80001aac <copyout>
    80005e00:	0e054863          	bltz	a0,80005ef0 <exec+0x3d8>
  p->trapframe->a1 = sp;
    80005e04:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005e08:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005e0c:	df843783          	ld	a5,-520(s0)
    80005e10:	0007c703          	lbu	a4,0(a5)
    80005e14:	cf11                	beqz	a4,80005e30 <exec+0x318>
    80005e16:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005e18:	02f00693          	li	a3,47
    80005e1c:	a039                	j	80005e2a <exec+0x312>
      last = s+1;
    80005e1e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80005e22:	0785                	addi	a5,a5,1
    80005e24:	fff7c703          	lbu	a4,-1(a5)
    80005e28:	c701                	beqz	a4,80005e30 <exec+0x318>
    if(*s == '/')
    80005e2a:	fed71ce3          	bne	a4,a3,80005e22 <exec+0x30a>
    80005e2e:	bfc5                	j	80005e1e <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80005e30:	4641                	li	a2,16
    80005e32:	df843583          	ld	a1,-520(s0)
    80005e36:	158a8513          	addi	a0,s5,344
    80005e3a:	ffffb097          	auipc	ra,0xffffb
    80005e3e:	114080e7          	jalr	276(ra) # 80000f4e <safestrcpy>
  oldpagetable = p->pagetable;
    80005e42:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005e46:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005e4a:	e0843783          	ld	a5,-504(s0)
    80005e4e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005e52:	058ab783          	ld	a5,88(s5)
    80005e56:	e6843703          	ld	a4,-408(s0)
    80005e5a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005e5c:	058ab783          	ld	a5,88(s5)
    80005e60:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005e64:	85e6                	mv	a1,s9
    80005e66:	ffffc097          	auipc	ra,0xffffc
    80005e6a:	10e080e7          	jalr	270(ra) # 80001f74 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005e6e:	0004851b          	sext.w	a0,s1
    80005e72:	79be                	ld	s3,488(sp)
    80005e74:	7a1e                	ld	s4,480(sp)
    80005e76:	6afe                	ld	s5,472(sp)
    80005e78:	6b5e                	ld	s6,464(sp)
    80005e7a:	6bbe                	ld	s7,456(sp)
    80005e7c:	6c1e                	ld	s8,448(sp)
    80005e7e:	7cfa                	ld	s9,440(sp)
    80005e80:	7d5a                	ld	s10,432(sp)
    80005e82:	b305                	j	80005ba2 <exec+0x8a>
    80005e84:	e1243423          	sd	s2,-504(s0)
    80005e88:	7dba                	ld	s11,424(sp)
    80005e8a:	a035                	j	80005eb6 <exec+0x39e>
    80005e8c:	e1243423          	sd	s2,-504(s0)
    80005e90:	7dba                	ld	s11,424(sp)
    80005e92:	a015                	j	80005eb6 <exec+0x39e>
    80005e94:	e1243423          	sd	s2,-504(s0)
    80005e98:	7dba                	ld	s11,424(sp)
    80005e9a:	a831                	j	80005eb6 <exec+0x39e>
    80005e9c:	e1243423          	sd	s2,-504(s0)
    80005ea0:	7dba                	ld	s11,424(sp)
    80005ea2:	a811                	j	80005eb6 <exec+0x39e>
    80005ea4:	e1243423          	sd	s2,-504(s0)
    80005ea8:	7dba                	ld	s11,424(sp)
    80005eaa:	a031                	j	80005eb6 <exec+0x39e>
  ip = 0;
    80005eac:	4a01                	li	s4,0
    80005eae:	a021                	j	80005eb6 <exec+0x39e>
    80005eb0:	4a01                	li	s4,0
  if(pagetable)
    80005eb2:	a011                	j	80005eb6 <exec+0x39e>
    80005eb4:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80005eb6:	e0843583          	ld	a1,-504(s0)
    80005eba:	855a                	mv	a0,s6
    80005ebc:	ffffc097          	auipc	ra,0xffffc
    80005ec0:	0b8080e7          	jalr	184(ra) # 80001f74 <proc_freepagetable>
  return -1;
    80005ec4:	557d                	li	a0,-1
  if(ip){
    80005ec6:	000a1b63          	bnez	s4,80005edc <exec+0x3c4>
    80005eca:	79be                	ld	s3,488(sp)
    80005ecc:	7a1e                	ld	s4,480(sp)
    80005ece:	6afe                	ld	s5,472(sp)
    80005ed0:	6b5e                	ld	s6,464(sp)
    80005ed2:	6bbe                	ld	s7,456(sp)
    80005ed4:	6c1e                	ld	s8,448(sp)
    80005ed6:	7cfa                	ld	s9,440(sp)
    80005ed8:	7d5a                	ld	s10,432(sp)
    80005eda:	b1e1                	j	80005ba2 <exec+0x8a>
    80005edc:	79be                	ld	s3,488(sp)
    80005ede:	6afe                	ld	s5,472(sp)
    80005ee0:	6b5e                	ld	s6,464(sp)
    80005ee2:	6bbe                	ld	s7,456(sp)
    80005ee4:	6c1e                	ld	s8,448(sp)
    80005ee6:	7cfa                	ld	s9,440(sp)
    80005ee8:	7d5a                	ld	s10,432(sp)
    80005eea:	b14d                	j	80005b8c <exec+0x74>
    80005eec:	6b5e                	ld	s6,464(sp)
    80005eee:	b979                	j	80005b8c <exec+0x74>
  sz = sz1;
    80005ef0:	e0843983          	ld	s3,-504(s0)
    80005ef4:	b591                	j	80005d38 <exec+0x220>

0000000080005ef6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005ef6:	7179                	addi	sp,sp,-48
    80005ef8:	f406                	sd	ra,40(sp)
    80005efa:	f022                	sd	s0,32(sp)
    80005efc:	ec26                	sd	s1,24(sp)
    80005efe:	e84a                	sd	s2,16(sp)
    80005f00:	1800                	addi	s0,sp,48
    80005f02:	892e                	mv	s2,a1
    80005f04:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005f06:	fdc40593          	addi	a1,s0,-36
    80005f0a:	ffffd097          	auipc	ra,0xffffd
    80005f0e:	522080e7          	jalr	1314(ra) # 8000342c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005f12:	fdc42703          	lw	a4,-36(s0)
    80005f16:	47bd                	li	a5,15
    80005f18:	02e7eb63          	bltu	a5,a4,80005f4e <argfd+0x58>
    80005f1c:	ffffc097          	auipc	ra,0xffffc
    80005f20:	ef8080e7          	jalr	-264(ra) # 80001e14 <myproc>
    80005f24:	fdc42703          	lw	a4,-36(s0)
    80005f28:	01a70793          	addi	a5,a4,26
    80005f2c:	078e                	slli	a5,a5,0x3
    80005f2e:	953e                	add	a0,a0,a5
    80005f30:	611c                	ld	a5,0(a0)
    80005f32:	c385                	beqz	a5,80005f52 <argfd+0x5c>
    return -1;
  if(pfd)
    80005f34:	00090463          	beqz	s2,80005f3c <argfd+0x46>
    *pfd = fd;
    80005f38:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005f3c:	4501                	li	a0,0
  if(pf)
    80005f3e:	c091                	beqz	s1,80005f42 <argfd+0x4c>
    *pf = f;
    80005f40:	e09c                	sd	a5,0(s1)
}
    80005f42:	70a2                	ld	ra,40(sp)
    80005f44:	7402                	ld	s0,32(sp)
    80005f46:	64e2                	ld	s1,24(sp)
    80005f48:	6942                	ld	s2,16(sp)
    80005f4a:	6145                	addi	sp,sp,48
    80005f4c:	8082                	ret
    return -1;
    80005f4e:	557d                	li	a0,-1
    80005f50:	bfcd                	j	80005f42 <argfd+0x4c>
    80005f52:	557d                	li	a0,-1
    80005f54:	b7fd                	j	80005f42 <argfd+0x4c>

0000000080005f56 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005f56:	715d                	addi	sp,sp,-80
    80005f58:	e486                	sd	ra,72(sp)
    80005f5a:	e0a2                	sd	s0,64(sp)
    80005f5c:	fc26                	sd	s1,56(sp)
    80005f5e:	f84a                	sd	s2,48(sp)
    80005f60:	f44e                	sd	s3,40(sp)
    80005f62:	ec56                	sd	s5,24(sp)
    80005f64:	e85a                	sd	s6,16(sp)
    80005f66:	0880                	addi	s0,sp,80
    80005f68:	8b2e                	mv	s6,a1
    80005f6a:	89b2                	mv	s3,a2
    80005f6c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005f6e:	fb040593          	addi	a1,s0,-80
    80005f72:	fffff097          	auipc	ra,0xfffff
    80005f76:	dd6080e7          	jalr	-554(ra) # 80004d48 <nameiparent>
    80005f7a:	84aa                	mv	s1,a0
    80005f7c:	14050e63          	beqz	a0,800060d8 <create+0x182>
    return 0;

  ilock(dp);
    80005f80:	ffffe097          	auipc	ra,0xffffe
    80005f84:	5dc080e7          	jalr	1500(ra) # 8000455c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005f88:	4601                	li	a2,0
    80005f8a:	fb040593          	addi	a1,s0,-80
    80005f8e:	8526                	mv	a0,s1
    80005f90:	fffff097          	auipc	ra,0xfffff
    80005f94:	ad8080e7          	jalr	-1320(ra) # 80004a68 <dirlookup>
    80005f98:	8aaa                	mv	s5,a0
    80005f9a:	c539                	beqz	a0,80005fe8 <create+0x92>
    iunlockput(dp);
    80005f9c:	8526                	mv	a0,s1
    80005f9e:	fffff097          	auipc	ra,0xfffff
    80005fa2:	824080e7          	jalr	-2012(ra) # 800047c2 <iunlockput>
    ilock(ip);
    80005fa6:	8556                	mv	a0,s5
    80005fa8:	ffffe097          	auipc	ra,0xffffe
    80005fac:	5b4080e7          	jalr	1460(ra) # 8000455c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005fb0:	4789                	li	a5,2
    80005fb2:	02fb1463          	bne	s6,a5,80005fda <create+0x84>
    80005fb6:	044ad783          	lhu	a5,68(s5)
    80005fba:	37f9                	addiw	a5,a5,-2
    80005fbc:	17c2                	slli	a5,a5,0x30
    80005fbe:	93c1                	srli	a5,a5,0x30
    80005fc0:	4705                	li	a4,1
    80005fc2:	00f76c63          	bltu	a4,a5,80005fda <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005fc6:	8556                	mv	a0,s5
    80005fc8:	60a6                	ld	ra,72(sp)
    80005fca:	6406                	ld	s0,64(sp)
    80005fcc:	74e2                	ld	s1,56(sp)
    80005fce:	7942                	ld	s2,48(sp)
    80005fd0:	79a2                	ld	s3,40(sp)
    80005fd2:	6ae2                	ld	s5,24(sp)
    80005fd4:	6b42                	ld	s6,16(sp)
    80005fd6:	6161                	addi	sp,sp,80
    80005fd8:	8082                	ret
    iunlockput(ip);
    80005fda:	8556                	mv	a0,s5
    80005fdc:	ffffe097          	auipc	ra,0xffffe
    80005fe0:	7e6080e7          	jalr	2022(ra) # 800047c2 <iunlockput>
    return 0;
    80005fe4:	4a81                	li	s5,0
    80005fe6:	b7c5                	j	80005fc6 <create+0x70>
    80005fe8:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005fea:	85da                	mv	a1,s6
    80005fec:	4088                	lw	a0,0(s1)
    80005fee:	ffffe097          	auipc	ra,0xffffe
    80005ff2:	3ca080e7          	jalr	970(ra) # 800043b8 <ialloc>
    80005ff6:	8a2a                	mv	s4,a0
    80005ff8:	c531                	beqz	a0,80006044 <create+0xee>
  ilock(ip);
    80005ffa:	ffffe097          	auipc	ra,0xffffe
    80005ffe:	562080e7          	jalr	1378(ra) # 8000455c <ilock>
  ip->major = major;
    80006002:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80006006:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000600a:	4905                	li	s2,1
    8000600c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80006010:	8552                	mv	a0,s4
    80006012:	ffffe097          	auipc	ra,0xffffe
    80006016:	47e080e7          	jalr	1150(ra) # 80004490 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000601a:	032b0d63          	beq	s6,s2,80006054 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000601e:	004a2603          	lw	a2,4(s4)
    80006022:	fb040593          	addi	a1,s0,-80
    80006026:	8526                	mv	a0,s1
    80006028:	fffff097          	auipc	ra,0xfffff
    8000602c:	c50080e7          	jalr	-944(ra) # 80004c78 <dirlink>
    80006030:	08054163          	bltz	a0,800060b2 <create+0x15c>
  iunlockput(dp);
    80006034:	8526                	mv	a0,s1
    80006036:	ffffe097          	auipc	ra,0xffffe
    8000603a:	78c080e7          	jalr	1932(ra) # 800047c2 <iunlockput>
  return ip;
    8000603e:	8ad2                	mv	s5,s4
    80006040:	7a02                	ld	s4,32(sp)
    80006042:	b751                	j	80005fc6 <create+0x70>
    iunlockput(dp);
    80006044:	8526                	mv	a0,s1
    80006046:	ffffe097          	auipc	ra,0xffffe
    8000604a:	77c080e7          	jalr	1916(ra) # 800047c2 <iunlockput>
    return 0;
    8000604e:	8ad2                	mv	s5,s4
    80006050:	7a02                	ld	s4,32(sp)
    80006052:	bf95                	j	80005fc6 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80006054:	004a2603          	lw	a2,4(s4)
    80006058:	00005597          	auipc	a1,0x5
    8000605c:	62058593          	addi	a1,a1,1568 # 8000b678 <etext+0x678>
    80006060:	8552                	mv	a0,s4
    80006062:	fffff097          	auipc	ra,0xfffff
    80006066:	c16080e7          	jalr	-1002(ra) # 80004c78 <dirlink>
    8000606a:	04054463          	bltz	a0,800060b2 <create+0x15c>
    8000606e:	40d0                	lw	a2,4(s1)
    80006070:	00005597          	auipc	a1,0x5
    80006074:	61058593          	addi	a1,a1,1552 # 8000b680 <etext+0x680>
    80006078:	8552                	mv	a0,s4
    8000607a:	fffff097          	auipc	ra,0xfffff
    8000607e:	bfe080e7          	jalr	-1026(ra) # 80004c78 <dirlink>
    80006082:	02054863          	bltz	a0,800060b2 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80006086:	004a2603          	lw	a2,4(s4)
    8000608a:	fb040593          	addi	a1,s0,-80
    8000608e:	8526                	mv	a0,s1
    80006090:	fffff097          	auipc	ra,0xfffff
    80006094:	be8080e7          	jalr	-1048(ra) # 80004c78 <dirlink>
    80006098:	00054d63          	bltz	a0,800060b2 <create+0x15c>
    dp->nlink++;  // for ".."
    8000609c:	04a4d783          	lhu	a5,74(s1)
    800060a0:	2785                	addiw	a5,a5,1
    800060a2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800060a6:	8526                	mv	a0,s1
    800060a8:	ffffe097          	auipc	ra,0xffffe
    800060ac:	3e8080e7          	jalr	1000(ra) # 80004490 <iupdate>
    800060b0:	b751                	j	80006034 <create+0xde>
  ip->nlink = 0;
    800060b2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800060b6:	8552                	mv	a0,s4
    800060b8:	ffffe097          	auipc	ra,0xffffe
    800060bc:	3d8080e7          	jalr	984(ra) # 80004490 <iupdate>
  iunlockput(ip);
    800060c0:	8552                	mv	a0,s4
    800060c2:	ffffe097          	auipc	ra,0xffffe
    800060c6:	700080e7          	jalr	1792(ra) # 800047c2 <iunlockput>
  iunlockput(dp);
    800060ca:	8526                	mv	a0,s1
    800060cc:	ffffe097          	auipc	ra,0xffffe
    800060d0:	6f6080e7          	jalr	1782(ra) # 800047c2 <iunlockput>
  return 0;
    800060d4:	7a02                	ld	s4,32(sp)
    800060d6:	bdc5                	j	80005fc6 <create+0x70>
    return 0;
    800060d8:	8aaa                	mv	s5,a0
    800060da:	b5f5                	j	80005fc6 <create+0x70>

00000000800060dc <fdalloc>:
{
    800060dc:	1101                	addi	sp,sp,-32
    800060de:	ec06                	sd	ra,24(sp)
    800060e0:	e822                	sd	s0,16(sp)
    800060e2:	e426                	sd	s1,8(sp)
    800060e4:	1000                	addi	s0,sp,32
    800060e6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800060e8:	ffffc097          	auipc	ra,0xffffc
    800060ec:	d2c080e7          	jalr	-724(ra) # 80001e14 <myproc>
    800060f0:	862a                	mv	a2,a0
  for(fd = 0; fd < NOFILE; fd++){
    800060f2:	0d050793          	addi	a5,a0,208
    800060f6:	4501                	li	a0,0
    800060f8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800060fa:	6398                	ld	a4,0(a5)
    800060fc:	cb19                	beqz	a4,80006112 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800060fe:	2505                	addiw	a0,a0,1
    80006100:	07a1                	addi	a5,a5,8
    80006102:	fed51ce3          	bne	a0,a3,800060fa <fdalloc+0x1e>
  return -1;
    80006106:	557d                	li	a0,-1
}
    80006108:	60e2                	ld	ra,24(sp)
    8000610a:	6442                	ld	s0,16(sp)
    8000610c:	64a2                	ld	s1,8(sp)
    8000610e:	6105                	addi	sp,sp,32
    80006110:	8082                	ret
      p->ofile[fd] = f;
    80006112:	01a50793          	addi	a5,a0,26
    80006116:	078e                	slli	a5,a5,0x3
    80006118:	963e                	add	a2,a2,a5
    8000611a:	e204                	sd	s1,0(a2)
      return fd;
    8000611c:	b7f5                	j	80006108 <fdalloc+0x2c>

000000008000611e <sys_dup>:
{
    8000611e:	7179                	addi	sp,sp,-48
    80006120:	f406                	sd	ra,40(sp)
    80006122:	f022                	sd	s0,32(sp)
    80006124:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80006126:	fd840613          	addi	a2,s0,-40
    8000612a:	4581                	li	a1,0
    8000612c:	4501                	li	a0,0
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	dc8080e7          	jalr	-568(ra) # 80005ef6 <argfd>
    return -1;
    80006136:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80006138:	02054763          	bltz	a0,80006166 <sys_dup+0x48>
    8000613c:	ec26                	sd	s1,24(sp)
    8000613e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80006140:	fd843903          	ld	s2,-40(s0)
    80006144:	854a                	mv	a0,s2
    80006146:	00000097          	auipc	ra,0x0
    8000614a:	f96080e7          	jalr	-106(ra) # 800060dc <fdalloc>
    8000614e:	84aa                	mv	s1,a0
    return -1;
    80006150:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80006152:	00054f63          	bltz	a0,80006170 <sys_dup+0x52>
  filedup(f);
    80006156:	854a                	mv	a0,s2
    80006158:	fffff097          	auipc	ra,0xfffff
    8000615c:	24a080e7          	jalr	586(ra) # 800053a2 <filedup>
  return fd;
    80006160:	87a6                	mv	a5,s1
    80006162:	64e2                	ld	s1,24(sp)
    80006164:	6942                	ld	s2,16(sp)
}
    80006166:	853e                	mv	a0,a5
    80006168:	70a2                	ld	ra,40(sp)
    8000616a:	7402                	ld	s0,32(sp)
    8000616c:	6145                	addi	sp,sp,48
    8000616e:	8082                	ret
    80006170:	64e2                	ld	s1,24(sp)
    80006172:	6942                	ld	s2,16(sp)
    80006174:	bfcd                	j	80006166 <sys_dup+0x48>

0000000080006176 <sys_read>:
{
    80006176:	7179                	addi	sp,sp,-48
    80006178:	f406                	sd	ra,40(sp)
    8000617a:	f022                	sd	s0,32(sp)
    8000617c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000617e:	fd840593          	addi	a1,s0,-40
    80006182:	4505                	li	a0,1
    80006184:	ffffd097          	auipc	ra,0xffffd
    80006188:	2c8080e7          	jalr	712(ra) # 8000344c <argaddr>
  argint(2, &n);
    8000618c:	fe440593          	addi	a1,s0,-28
    80006190:	4509                	li	a0,2
    80006192:	ffffd097          	auipc	ra,0xffffd
    80006196:	29a080e7          	jalr	666(ra) # 8000342c <argint>
  if(argfd(0, 0, &f) < 0)
    8000619a:	fe840613          	addi	a2,s0,-24
    8000619e:	4581                	li	a1,0
    800061a0:	4501                	li	a0,0
    800061a2:	00000097          	auipc	ra,0x0
    800061a6:	d54080e7          	jalr	-684(ra) # 80005ef6 <argfd>
    800061aa:	87aa                	mv	a5,a0
    return -1;
    800061ac:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800061ae:	0007cc63          	bltz	a5,800061c6 <sys_read+0x50>
  return fileread(f, p, n);
    800061b2:	fe442603          	lw	a2,-28(s0)
    800061b6:	fd843583          	ld	a1,-40(s0)
    800061ba:	fe843503          	ld	a0,-24(s0)
    800061be:	fffff097          	auipc	ra,0xfffff
    800061c2:	3d8080e7          	jalr	984(ra) # 80005596 <fileread>
}
    800061c6:	70a2                	ld	ra,40(sp)
    800061c8:	7402                	ld	s0,32(sp)
    800061ca:	6145                	addi	sp,sp,48
    800061cc:	8082                	ret

00000000800061ce <sys_write>:
{
    800061ce:	7179                	addi	sp,sp,-48
    800061d0:	f406                	sd	ra,40(sp)
    800061d2:	f022                	sd	s0,32(sp)
    800061d4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800061d6:	fd840593          	addi	a1,s0,-40
    800061da:	4505                	li	a0,1
    800061dc:	ffffd097          	auipc	ra,0xffffd
    800061e0:	270080e7          	jalr	624(ra) # 8000344c <argaddr>
  argint(2, &n);
    800061e4:	fe440593          	addi	a1,s0,-28
    800061e8:	4509                	li	a0,2
    800061ea:	ffffd097          	auipc	ra,0xffffd
    800061ee:	242080e7          	jalr	578(ra) # 8000342c <argint>
  if(argfd(0, 0, &f) < 0)
    800061f2:	fe840613          	addi	a2,s0,-24
    800061f6:	4581                	li	a1,0
    800061f8:	4501                	li	a0,0
    800061fa:	00000097          	auipc	ra,0x0
    800061fe:	cfc080e7          	jalr	-772(ra) # 80005ef6 <argfd>
    80006202:	87aa                	mv	a5,a0
    return -1;
    80006204:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006206:	0007cc63          	bltz	a5,8000621e <sys_write+0x50>
  return filewrite(f, p, n);
    8000620a:	fe442603          	lw	a2,-28(s0)
    8000620e:	fd843583          	ld	a1,-40(s0)
    80006212:	fe843503          	ld	a0,-24(s0)
    80006216:	fffff097          	auipc	ra,0xfffff
    8000621a:	452080e7          	jalr	1106(ra) # 80005668 <filewrite>
}
    8000621e:	70a2                	ld	ra,40(sp)
    80006220:	7402                	ld	s0,32(sp)
    80006222:	6145                	addi	sp,sp,48
    80006224:	8082                	ret

0000000080006226 <sys_close>:
{
    80006226:	1101                	addi	sp,sp,-32
    80006228:	ec06                	sd	ra,24(sp)
    8000622a:	e822                	sd	s0,16(sp)
    8000622c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000622e:	fe040613          	addi	a2,s0,-32
    80006232:	fec40593          	addi	a1,s0,-20
    80006236:	4501                	li	a0,0
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	cbe080e7          	jalr	-834(ra) # 80005ef6 <argfd>
    return -1;
    80006240:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80006242:	02054463          	bltz	a0,8000626a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80006246:	ffffc097          	auipc	ra,0xffffc
    8000624a:	bce080e7          	jalr	-1074(ra) # 80001e14 <myproc>
    8000624e:	fec42783          	lw	a5,-20(s0)
    80006252:	07e9                	addi	a5,a5,26
    80006254:	078e                	slli	a5,a5,0x3
    80006256:	953e                	add	a0,a0,a5
    80006258:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000625c:	fe043503          	ld	a0,-32(s0)
    80006260:	fffff097          	auipc	ra,0xfffff
    80006264:	194080e7          	jalr	404(ra) # 800053f4 <fileclose>
  return 0;
    80006268:	4781                	li	a5,0
}
    8000626a:	853e                	mv	a0,a5
    8000626c:	60e2                	ld	ra,24(sp)
    8000626e:	6442                	ld	s0,16(sp)
    80006270:	6105                	addi	sp,sp,32
    80006272:	8082                	ret

0000000080006274 <sys_fstat>:
{
    80006274:	1101                	addi	sp,sp,-32
    80006276:	ec06                	sd	ra,24(sp)
    80006278:	e822                	sd	s0,16(sp)
    8000627a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000627c:	fe040593          	addi	a1,s0,-32
    80006280:	4505                	li	a0,1
    80006282:	ffffd097          	auipc	ra,0xffffd
    80006286:	1ca080e7          	jalr	458(ra) # 8000344c <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000628a:	fe840613          	addi	a2,s0,-24
    8000628e:	4581                	li	a1,0
    80006290:	4501                	li	a0,0
    80006292:	00000097          	auipc	ra,0x0
    80006296:	c64080e7          	jalr	-924(ra) # 80005ef6 <argfd>
    8000629a:	87aa                	mv	a5,a0
    return -1;
    8000629c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000629e:	0007ca63          	bltz	a5,800062b2 <sys_fstat+0x3e>
  return filestat(f, st);
    800062a2:	fe043583          	ld	a1,-32(s0)
    800062a6:	fe843503          	ld	a0,-24(s0)
    800062aa:	fffff097          	auipc	ra,0xfffff
    800062ae:	27a080e7          	jalr	634(ra) # 80005524 <filestat>
}
    800062b2:	60e2                	ld	ra,24(sp)
    800062b4:	6442                	ld	s0,16(sp)
    800062b6:	6105                	addi	sp,sp,32
    800062b8:	8082                	ret

00000000800062ba <sys_link>:
{
    800062ba:	7169                	addi	sp,sp,-304
    800062bc:	f606                	sd	ra,296(sp)
    800062be:	f222                	sd	s0,288(sp)
    800062c0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800062c2:	08000613          	li	a2,128
    800062c6:	ed040593          	addi	a1,s0,-304
    800062ca:	4501                	li	a0,0
    800062cc:	ffffd097          	auipc	ra,0xffffd
    800062d0:	1a0080e7          	jalr	416(ra) # 8000346c <argstr>
    return -1;
    800062d4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800062d6:	12054663          	bltz	a0,80006402 <sys_link+0x148>
    800062da:	08000613          	li	a2,128
    800062de:	f5040593          	addi	a1,s0,-176
    800062e2:	4505                	li	a0,1
    800062e4:	ffffd097          	auipc	ra,0xffffd
    800062e8:	188080e7          	jalr	392(ra) # 8000346c <argstr>
    return -1;
    800062ec:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800062ee:	10054a63          	bltz	a0,80006402 <sys_link+0x148>
    800062f2:	ee26                	sd	s1,280(sp)
  begin_op();
    800062f4:	fffff097          	auipc	ra,0xfffff
    800062f8:	c36080e7          	jalr	-970(ra) # 80004f2a <begin_op>
  if((ip = namei(old)) == 0){
    800062fc:	ed040513          	addi	a0,s0,-304
    80006300:	fffff097          	auipc	ra,0xfffff
    80006304:	a2a080e7          	jalr	-1494(ra) # 80004d2a <namei>
    80006308:	84aa                	mv	s1,a0
    8000630a:	c949                	beqz	a0,8000639c <sys_link+0xe2>
  ilock(ip);
    8000630c:	ffffe097          	auipc	ra,0xffffe
    80006310:	250080e7          	jalr	592(ra) # 8000455c <ilock>
  if(ip->type == T_DIR){
    80006314:	04449703          	lh	a4,68(s1)
    80006318:	4785                	li	a5,1
    8000631a:	08f70863          	beq	a4,a5,800063aa <sys_link+0xf0>
    8000631e:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80006320:	04a4d783          	lhu	a5,74(s1)
    80006324:	2785                	addiw	a5,a5,1
    80006326:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000632a:	8526                	mv	a0,s1
    8000632c:	ffffe097          	auipc	ra,0xffffe
    80006330:	164080e7          	jalr	356(ra) # 80004490 <iupdate>
  iunlock(ip);
    80006334:	8526                	mv	a0,s1
    80006336:	ffffe097          	auipc	ra,0xffffe
    8000633a:	2ec080e7          	jalr	748(ra) # 80004622 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000633e:	fd040593          	addi	a1,s0,-48
    80006342:	f5040513          	addi	a0,s0,-176
    80006346:	fffff097          	auipc	ra,0xfffff
    8000634a:	a02080e7          	jalr	-1534(ra) # 80004d48 <nameiparent>
    8000634e:	892a                	mv	s2,a0
    80006350:	cd35                	beqz	a0,800063cc <sys_link+0x112>
  ilock(dp);
    80006352:	ffffe097          	auipc	ra,0xffffe
    80006356:	20a080e7          	jalr	522(ra) # 8000455c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000635a:	00092703          	lw	a4,0(s2)
    8000635e:	409c                	lw	a5,0(s1)
    80006360:	06f71163          	bne	a4,a5,800063c2 <sys_link+0x108>
    80006364:	40d0                	lw	a2,4(s1)
    80006366:	fd040593          	addi	a1,s0,-48
    8000636a:	854a                	mv	a0,s2
    8000636c:	fffff097          	auipc	ra,0xfffff
    80006370:	90c080e7          	jalr	-1780(ra) # 80004c78 <dirlink>
    80006374:	04054763          	bltz	a0,800063c2 <sys_link+0x108>
  iunlockput(dp);
    80006378:	854a                	mv	a0,s2
    8000637a:	ffffe097          	auipc	ra,0xffffe
    8000637e:	448080e7          	jalr	1096(ra) # 800047c2 <iunlockput>
  iput(ip);
    80006382:	8526                	mv	a0,s1
    80006384:	ffffe097          	auipc	ra,0xffffe
    80006388:	396080e7          	jalr	918(ra) # 8000471a <iput>
  end_op();
    8000638c:	fffff097          	auipc	ra,0xfffff
    80006390:	c18080e7          	jalr	-1000(ra) # 80004fa4 <end_op>
  return 0;
    80006394:	4781                	li	a5,0
    80006396:	64f2                	ld	s1,280(sp)
    80006398:	6952                	ld	s2,272(sp)
    8000639a:	a0a5                	j	80006402 <sys_link+0x148>
    end_op();
    8000639c:	fffff097          	auipc	ra,0xfffff
    800063a0:	c08080e7          	jalr	-1016(ra) # 80004fa4 <end_op>
    return -1;
    800063a4:	57fd                	li	a5,-1
    800063a6:	64f2                	ld	s1,280(sp)
    800063a8:	a8a9                	j	80006402 <sys_link+0x148>
    iunlockput(ip);
    800063aa:	8526                	mv	a0,s1
    800063ac:	ffffe097          	auipc	ra,0xffffe
    800063b0:	416080e7          	jalr	1046(ra) # 800047c2 <iunlockput>
    end_op();
    800063b4:	fffff097          	auipc	ra,0xfffff
    800063b8:	bf0080e7          	jalr	-1040(ra) # 80004fa4 <end_op>
    return -1;
    800063bc:	57fd                	li	a5,-1
    800063be:	64f2                	ld	s1,280(sp)
    800063c0:	a089                	j	80006402 <sys_link+0x148>
    iunlockput(dp);
    800063c2:	854a                	mv	a0,s2
    800063c4:	ffffe097          	auipc	ra,0xffffe
    800063c8:	3fe080e7          	jalr	1022(ra) # 800047c2 <iunlockput>
  ilock(ip);
    800063cc:	8526                	mv	a0,s1
    800063ce:	ffffe097          	auipc	ra,0xffffe
    800063d2:	18e080e7          	jalr	398(ra) # 8000455c <ilock>
  ip->nlink--;
    800063d6:	04a4d783          	lhu	a5,74(s1)
    800063da:	37fd                	addiw	a5,a5,-1
    800063dc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800063e0:	8526                	mv	a0,s1
    800063e2:	ffffe097          	auipc	ra,0xffffe
    800063e6:	0ae080e7          	jalr	174(ra) # 80004490 <iupdate>
  iunlockput(ip);
    800063ea:	8526                	mv	a0,s1
    800063ec:	ffffe097          	auipc	ra,0xffffe
    800063f0:	3d6080e7          	jalr	982(ra) # 800047c2 <iunlockput>
  end_op();
    800063f4:	fffff097          	auipc	ra,0xfffff
    800063f8:	bb0080e7          	jalr	-1104(ra) # 80004fa4 <end_op>
  return -1;
    800063fc:	57fd                	li	a5,-1
    800063fe:	64f2                	ld	s1,280(sp)
    80006400:	6952                	ld	s2,272(sp)
}
    80006402:	853e                	mv	a0,a5
    80006404:	70b2                	ld	ra,296(sp)
    80006406:	7412                	ld	s0,288(sp)
    80006408:	6155                	addi	sp,sp,304
    8000640a:	8082                	ret

000000008000640c <sys_unlink>:
{
    8000640c:	7151                	addi	sp,sp,-240
    8000640e:	f586                	sd	ra,232(sp)
    80006410:	f1a2                	sd	s0,224(sp)
    80006412:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80006414:	08000613          	li	a2,128
    80006418:	f3040593          	addi	a1,s0,-208
    8000641c:	4501                	li	a0,0
    8000641e:	ffffd097          	auipc	ra,0xffffd
    80006422:	04e080e7          	jalr	78(ra) # 8000346c <argstr>
    80006426:	1a054a63          	bltz	a0,800065da <sys_unlink+0x1ce>
    8000642a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000642c:	fffff097          	auipc	ra,0xfffff
    80006430:	afe080e7          	jalr	-1282(ra) # 80004f2a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80006434:	fb040593          	addi	a1,s0,-80
    80006438:	f3040513          	addi	a0,s0,-208
    8000643c:	fffff097          	auipc	ra,0xfffff
    80006440:	90c080e7          	jalr	-1780(ra) # 80004d48 <nameiparent>
    80006444:	84aa                	mv	s1,a0
    80006446:	cd71                	beqz	a0,80006522 <sys_unlink+0x116>
  ilock(dp);
    80006448:	ffffe097          	auipc	ra,0xffffe
    8000644c:	114080e7          	jalr	276(ra) # 8000455c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006450:	00005597          	auipc	a1,0x5
    80006454:	22858593          	addi	a1,a1,552 # 8000b678 <etext+0x678>
    80006458:	fb040513          	addi	a0,s0,-80
    8000645c:	ffffe097          	auipc	ra,0xffffe
    80006460:	5f2080e7          	jalr	1522(ra) # 80004a4e <namecmp>
    80006464:	14050c63          	beqz	a0,800065bc <sys_unlink+0x1b0>
    80006468:	00005597          	auipc	a1,0x5
    8000646c:	21858593          	addi	a1,a1,536 # 8000b680 <etext+0x680>
    80006470:	fb040513          	addi	a0,s0,-80
    80006474:	ffffe097          	auipc	ra,0xffffe
    80006478:	5da080e7          	jalr	1498(ra) # 80004a4e <namecmp>
    8000647c:	14050063          	beqz	a0,800065bc <sys_unlink+0x1b0>
    80006480:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80006482:	f2c40613          	addi	a2,s0,-212
    80006486:	fb040593          	addi	a1,s0,-80
    8000648a:	8526                	mv	a0,s1
    8000648c:	ffffe097          	auipc	ra,0xffffe
    80006490:	5dc080e7          	jalr	1500(ra) # 80004a68 <dirlookup>
    80006494:	892a                	mv	s2,a0
    80006496:	12050263          	beqz	a0,800065ba <sys_unlink+0x1ae>
  ilock(ip);
    8000649a:	ffffe097          	auipc	ra,0xffffe
    8000649e:	0c2080e7          	jalr	194(ra) # 8000455c <ilock>
  if(ip->nlink < 1)
    800064a2:	04a91783          	lh	a5,74(s2)
    800064a6:	08f05563          	blez	a5,80006530 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800064aa:	04491703          	lh	a4,68(s2)
    800064ae:	4785                	li	a5,1
    800064b0:	08f70963          	beq	a4,a5,80006542 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    800064b4:	4641                	li	a2,16
    800064b6:	4581                	li	a1,0
    800064b8:	fc040513          	addi	a0,s0,-64
    800064bc:	ffffb097          	auipc	ra,0xffffb
    800064c0:	950080e7          	jalr	-1712(ra) # 80000e0c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800064c4:	4741                	li	a4,16
    800064c6:	f2c42683          	lw	a3,-212(s0)
    800064ca:	fc040613          	addi	a2,s0,-64
    800064ce:	4581                	li	a1,0
    800064d0:	8526                	mv	a0,s1
    800064d2:	ffffe097          	auipc	ra,0xffffe
    800064d6:	452080e7          	jalr	1106(ra) # 80004924 <writei>
    800064da:	47c1                	li	a5,16
    800064dc:	0af51b63          	bne	a0,a5,80006592 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    800064e0:	04491703          	lh	a4,68(s2)
    800064e4:	4785                	li	a5,1
    800064e6:	0af70f63          	beq	a4,a5,800065a4 <sys_unlink+0x198>
  iunlockput(dp);
    800064ea:	8526                	mv	a0,s1
    800064ec:	ffffe097          	auipc	ra,0xffffe
    800064f0:	2d6080e7          	jalr	726(ra) # 800047c2 <iunlockput>
  ip->nlink--;
    800064f4:	04a95783          	lhu	a5,74(s2)
    800064f8:	37fd                	addiw	a5,a5,-1
    800064fa:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800064fe:	854a                	mv	a0,s2
    80006500:	ffffe097          	auipc	ra,0xffffe
    80006504:	f90080e7          	jalr	-112(ra) # 80004490 <iupdate>
  iunlockput(ip);
    80006508:	854a                	mv	a0,s2
    8000650a:	ffffe097          	auipc	ra,0xffffe
    8000650e:	2b8080e7          	jalr	696(ra) # 800047c2 <iunlockput>
  end_op();
    80006512:	fffff097          	auipc	ra,0xfffff
    80006516:	a92080e7          	jalr	-1390(ra) # 80004fa4 <end_op>
  return 0;
    8000651a:	4501                	li	a0,0
    8000651c:	64ee                	ld	s1,216(sp)
    8000651e:	694e                	ld	s2,208(sp)
    80006520:	a84d                	j	800065d2 <sys_unlink+0x1c6>
    end_op();
    80006522:	fffff097          	auipc	ra,0xfffff
    80006526:	a82080e7          	jalr	-1406(ra) # 80004fa4 <end_op>
    return -1;
    8000652a:	557d                	li	a0,-1
    8000652c:	64ee                	ld	s1,216(sp)
    8000652e:	a055                	j	800065d2 <sys_unlink+0x1c6>
    80006530:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80006532:	00005517          	auipc	a0,0x5
    80006536:	15650513          	addi	a0,a0,342 # 8000b688 <etext+0x688>
    8000653a:	ffffa097          	auipc	ra,0xffffa
    8000653e:	026080e7          	jalr	38(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006542:	04c92703          	lw	a4,76(s2)
    80006546:	02000793          	li	a5,32
    8000654a:	f6e7f5e3          	bgeu	a5,a4,800064b4 <sys_unlink+0xa8>
    8000654e:	e5ce                	sd	s3,200(sp)
    80006550:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006554:	4741                	li	a4,16
    80006556:	86ce                	mv	a3,s3
    80006558:	f1840613          	addi	a2,s0,-232
    8000655c:	4581                	li	a1,0
    8000655e:	854a                	mv	a0,s2
    80006560:	ffffe097          	auipc	ra,0xffffe
    80006564:	2b4080e7          	jalr	692(ra) # 80004814 <readi>
    80006568:	47c1                	li	a5,16
    8000656a:	00f51c63          	bne	a0,a5,80006582 <sys_unlink+0x176>
    if(de.inum != 0)
    8000656e:	f1845783          	lhu	a5,-232(s0)
    80006572:	e7b5                	bnez	a5,800065de <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006574:	29c1                	addiw	s3,s3,16
    80006576:	04c92783          	lw	a5,76(s2)
    8000657a:	fcf9ede3          	bltu	s3,a5,80006554 <sys_unlink+0x148>
    8000657e:	69ae                	ld	s3,200(sp)
    80006580:	bf15                	j	800064b4 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80006582:	00005517          	auipc	a0,0x5
    80006586:	11e50513          	addi	a0,a0,286 # 8000b6a0 <etext+0x6a0>
    8000658a:	ffffa097          	auipc	ra,0xffffa
    8000658e:	fd6080e7          	jalr	-42(ra) # 80000560 <panic>
    80006592:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80006594:	00005517          	auipc	a0,0x5
    80006598:	12450513          	addi	a0,a0,292 # 8000b6b8 <etext+0x6b8>
    8000659c:	ffffa097          	auipc	ra,0xffffa
    800065a0:	fc4080e7          	jalr	-60(ra) # 80000560 <panic>
    dp->nlink--;
    800065a4:	04a4d783          	lhu	a5,74(s1)
    800065a8:	37fd                	addiw	a5,a5,-1
    800065aa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800065ae:	8526                	mv	a0,s1
    800065b0:	ffffe097          	auipc	ra,0xffffe
    800065b4:	ee0080e7          	jalr	-288(ra) # 80004490 <iupdate>
    800065b8:	bf0d                	j	800064ea <sys_unlink+0xde>
    800065ba:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800065bc:	8526                	mv	a0,s1
    800065be:	ffffe097          	auipc	ra,0xffffe
    800065c2:	204080e7          	jalr	516(ra) # 800047c2 <iunlockput>
  end_op();
    800065c6:	fffff097          	auipc	ra,0xfffff
    800065ca:	9de080e7          	jalr	-1570(ra) # 80004fa4 <end_op>
  return -1;
    800065ce:	557d                	li	a0,-1
    800065d0:	64ee                	ld	s1,216(sp)
}
    800065d2:	70ae                	ld	ra,232(sp)
    800065d4:	740e                	ld	s0,224(sp)
    800065d6:	616d                	addi	sp,sp,240
    800065d8:	8082                	ret
    return -1;
    800065da:	557d                	li	a0,-1
    800065dc:	bfdd                	j	800065d2 <sys_unlink+0x1c6>
    iunlockput(ip);
    800065de:	854a                	mv	a0,s2
    800065e0:	ffffe097          	auipc	ra,0xffffe
    800065e4:	1e2080e7          	jalr	482(ra) # 800047c2 <iunlockput>
    goto bad;
    800065e8:	694e                	ld	s2,208(sp)
    800065ea:	69ae                	ld	s3,200(sp)
    800065ec:	bfc1                	j	800065bc <sys_unlink+0x1b0>

00000000800065ee <sys_open>:

uint64
sys_open(void)
{
    800065ee:	7131                	addi	sp,sp,-192
    800065f0:	fd06                	sd	ra,184(sp)
    800065f2:	f922                	sd	s0,176(sp)
    800065f4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800065f6:	f4c40593          	addi	a1,s0,-180
    800065fa:	4505                	li	a0,1
    800065fc:	ffffd097          	auipc	ra,0xffffd
    80006600:	e30080e7          	jalr	-464(ra) # 8000342c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006604:	08000613          	li	a2,128
    80006608:	f5040593          	addi	a1,s0,-176
    8000660c:	4501                	li	a0,0
    8000660e:	ffffd097          	auipc	ra,0xffffd
    80006612:	e5e080e7          	jalr	-418(ra) # 8000346c <argstr>
    80006616:	87aa                	mv	a5,a0
    return -1;
    80006618:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000661a:	0a07ce63          	bltz	a5,800066d6 <sys_open+0xe8>
    8000661e:	f526                	sd	s1,168(sp)

  begin_op();
    80006620:	fffff097          	auipc	ra,0xfffff
    80006624:	90a080e7          	jalr	-1782(ra) # 80004f2a <begin_op>

  if(omode & O_CREATE){
    80006628:	f4c42783          	lw	a5,-180(s0)
    8000662c:	2007f793          	andi	a5,a5,512
    80006630:	cfd5                	beqz	a5,800066ec <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80006632:	4681                	li	a3,0
    80006634:	4601                	li	a2,0
    80006636:	4589                	li	a1,2
    80006638:	f5040513          	addi	a0,s0,-176
    8000663c:	00000097          	auipc	ra,0x0
    80006640:	91a080e7          	jalr	-1766(ra) # 80005f56 <create>
    80006644:	84aa                	mv	s1,a0
    if(ip == 0){
    80006646:	cd41                	beqz	a0,800066de <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80006648:	04449703          	lh	a4,68(s1)
    8000664c:	478d                	li	a5,3
    8000664e:	00f71763          	bne	a4,a5,8000665c <sys_open+0x6e>
    80006652:	0464d703          	lhu	a4,70(s1)
    80006656:	47a5                	li	a5,9
    80006658:	0ee7e163          	bltu	a5,a4,8000673a <sys_open+0x14c>
    8000665c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000665e:	fffff097          	auipc	ra,0xfffff
    80006662:	cda080e7          	jalr	-806(ra) # 80005338 <filealloc>
    80006666:	892a                	mv	s2,a0
    80006668:	c97d                	beqz	a0,8000675e <sys_open+0x170>
    8000666a:	ed4e                	sd	s3,152(sp)
    8000666c:	00000097          	auipc	ra,0x0
    80006670:	a70080e7          	jalr	-1424(ra) # 800060dc <fdalloc>
    80006674:	89aa                	mv	s3,a0
    80006676:	0c054e63          	bltz	a0,80006752 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000667a:	04449703          	lh	a4,68(s1)
    8000667e:	478d                	li	a5,3
    80006680:	0ef70c63          	beq	a4,a5,80006778 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006684:	4789                	li	a5,2
    80006686:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000668a:	02092423          	sw	zero,40(s2)
  }
  f->ip = ip;
    8000668e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006692:	f4c42783          	lw	a5,-180(s0)
    80006696:	0017c713          	xori	a4,a5,1
    8000669a:	8b05                	andi	a4,a4,1
    8000669c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800066a0:	0037f713          	andi	a4,a5,3
    800066a4:	00e03733          	snez	a4,a4
    800066a8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800066ac:	4007f793          	andi	a5,a5,1024
    800066b0:	c791                	beqz	a5,800066bc <sys_open+0xce>
    800066b2:	04449703          	lh	a4,68(s1)
    800066b6:	4789                	li	a5,2
    800066b8:	0cf70763          	beq	a4,a5,80006786 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    800066bc:	8526                	mv	a0,s1
    800066be:	ffffe097          	auipc	ra,0xffffe
    800066c2:	f64080e7          	jalr	-156(ra) # 80004622 <iunlock>
  end_op();
    800066c6:	fffff097          	auipc	ra,0xfffff
    800066ca:	8de080e7          	jalr	-1826(ra) # 80004fa4 <end_op>

  return fd;
    800066ce:	854e                	mv	a0,s3
    800066d0:	74aa                	ld	s1,168(sp)
    800066d2:	790a                	ld	s2,160(sp)
    800066d4:	69ea                	ld	s3,152(sp)
}
    800066d6:	70ea                	ld	ra,184(sp)
    800066d8:	744a                	ld	s0,176(sp)
    800066da:	6129                	addi	sp,sp,192
    800066dc:	8082                	ret
      end_op();
    800066de:	fffff097          	auipc	ra,0xfffff
    800066e2:	8c6080e7          	jalr	-1850(ra) # 80004fa4 <end_op>
      return -1;
    800066e6:	557d                	li	a0,-1
    800066e8:	74aa                	ld	s1,168(sp)
    800066ea:	b7f5                	j	800066d6 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    800066ec:	f5040513          	addi	a0,s0,-176
    800066f0:	ffffe097          	auipc	ra,0xffffe
    800066f4:	63a080e7          	jalr	1594(ra) # 80004d2a <namei>
    800066f8:	84aa                	mv	s1,a0
    800066fa:	c90d                	beqz	a0,8000672c <sys_open+0x13e>
    ilock(ip);
    800066fc:	ffffe097          	auipc	ra,0xffffe
    80006700:	e60080e7          	jalr	-416(ra) # 8000455c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006704:	04449703          	lh	a4,68(s1)
    80006708:	4785                	li	a5,1
    8000670a:	f2f71fe3          	bne	a4,a5,80006648 <sys_open+0x5a>
    8000670e:	f4c42783          	lw	a5,-180(s0)
    80006712:	d7a9                	beqz	a5,8000665c <sys_open+0x6e>
      iunlockput(ip);
    80006714:	8526                	mv	a0,s1
    80006716:	ffffe097          	auipc	ra,0xffffe
    8000671a:	0ac080e7          	jalr	172(ra) # 800047c2 <iunlockput>
      end_op();
    8000671e:	fffff097          	auipc	ra,0xfffff
    80006722:	886080e7          	jalr	-1914(ra) # 80004fa4 <end_op>
      return -1;
    80006726:	557d                	li	a0,-1
    80006728:	74aa                	ld	s1,168(sp)
    8000672a:	b775                	j	800066d6 <sys_open+0xe8>
      end_op();
    8000672c:	fffff097          	auipc	ra,0xfffff
    80006730:	878080e7          	jalr	-1928(ra) # 80004fa4 <end_op>
      return -1;
    80006734:	557d                	li	a0,-1
    80006736:	74aa                	ld	s1,168(sp)
    80006738:	bf79                	j	800066d6 <sys_open+0xe8>
    iunlockput(ip);
    8000673a:	8526                	mv	a0,s1
    8000673c:	ffffe097          	auipc	ra,0xffffe
    80006740:	086080e7          	jalr	134(ra) # 800047c2 <iunlockput>
    end_op();
    80006744:	fffff097          	auipc	ra,0xfffff
    80006748:	860080e7          	jalr	-1952(ra) # 80004fa4 <end_op>
    return -1;
    8000674c:	557d                	li	a0,-1
    8000674e:	74aa                	ld	s1,168(sp)
    80006750:	b759                	j	800066d6 <sys_open+0xe8>
      fileclose(f);
    80006752:	854a                	mv	a0,s2
    80006754:	fffff097          	auipc	ra,0xfffff
    80006758:	ca0080e7          	jalr	-864(ra) # 800053f4 <fileclose>
    8000675c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000675e:	8526                	mv	a0,s1
    80006760:	ffffe097          	auipc	ra,0xffffe
    80006764:	062080e7          	jalr	98(ra) # 800047c2 <iunlockput>
    end_op();
    80006768:	fffff097          	auipc	ra,0xfffff
    8000676c:	83c080e7          	jalr	-1988(ra) # 80004fa4 <end_op>
    return -1;
    80006770:	557d                	li	a0,-1
    80006772:	74aa                	ld	s1,168(sp)
    80006774:	790a                	ld	s2,160(sp)
    80006776:	b785                	j	800066d6 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80006778:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000677c:	04649783          	lh	a5,70(s1)
    80006780:	02f91623          	sh	a5,44(s2)
    80006784:	b729                	j	8000668e <sys_open+0xa0>
    itrunc(ip);
    80006786:	8526                	mv	a0,s1
    80006788:	ffffe097          	auipc	ra,0xffffe
    8000678c:	ee6080e7          	jalr	-282(ra) # 8000466e <itrunc>
    80006790:	b735                	j	800066bc <sys_open+0xce>

0000000080006792 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006792:	7175                	addi	sp,sp,-144
    80006794:	e506                	sd	ra,136(sp)
    80006796:	e122                	sd	s0,128(sp)
    80006798:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000679a:	ffffe097          	auipc	ra,0xffffe
    8000679e:	790080e7          	jalr	1936(ra) # 80004f2a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800067a2:	08000613          	li	a2,128
    800067a6:	f7040593          	addi	a1,s0,-144
    800067aa:	4501                	li	a0,0
    800067ac:	ffffd097          	auipc	ra,0xffffd
    800067b0:	cc0080e7          	jalr	-832(ra) # 8000346c <argstr>
    800067b4:	02054963          	bltz	a0,800067e6 <sys_mkdir+0x54>
    800067b8:	4681                	li	a3,0
    800067ba:	4601                	li	a2,0
    800067bc:	4585                	li	a1,1
    800067be:	f7040513          	addi	a0,s0,-144
    800067c2:	fffff097          	auipc	ra,0xfffff
    800067c6:	794080e7          	jalr	1940(ra) # 80005f56 <create>
    800067ca:	cd11                	beqz	a0,800067e6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800067cc:	ffffe097          	auipc	ra,0xffffe
    800067d0:	ff6080e7          	jalr	-10(ra) # 800047c2 <iunlockput>
  end_op();
    800067d4:	ffffe097          	auipc	ra,0xffffe
    800067d8:	7d0080e7          	jalr	2000(ra) # 80004fa4 <end_op>
  return 0;
    800067dc:	4501                	li	a0,0
}
    800067de:	60aa                	ld	ra,136(sp)
    800067e0:	640a                	ld	s0,128(sp)
    800067e2:	6149                	addi	sp,sp,144
    800067e4:	8082                	ret
    end_op();
    800067e6:	ffffe097          	auipc	ra,0xffffe
    800067ea:	7be080e7          	jalr	1982(ra) # 80004fa4 <end_op>
    return -1;
    800067ee:	557d                	li	a0,-1
    800067f0:	b7fd                	j	800067de <sys_mkdir+0x4c>

00000000800067f2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800067f2:	7135                	addi	sp,sp,-160
    800067f4:	ed06                	sd	ra,152(sp)
    800067f6:	e922                	sd	s0,144(sp)
    800067f8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800067fa:	ffffe097          	auipc	ra,0xffffe
    800067fe:	730080e7          	jalr	1840(ra) # 80004f2a <begin_op>
  argint(1, &major);
    80006802:	f6c40593          	addi	a1,s0,-148
    80006806:	4505                	li	a0,1
    80006808:	ffffd097          	auipc	ra,0xffffd
    8000680c:	c24080e7          	jalr	-988(ra) # 8000342c <argint>
  argint(2, &minor);
    80006810:	f6840593          	addi	a1,s0,-152
    80006814:	4509                	li	a0,2
    80006816:	ffffd097          	auipc	ra,0xffffd
    8000681a:	c16080e7          	jalr	-1002(ra) # 8000342c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000681e:	08000613          	li	a2,128
    80006822:	f7040593          	addi	a1,s0,-144
    80006826:	4501                	li	a0,0
    80006828:	ffffd097          	auipc	ra,0xffffd
    8000682c:	c44080e7          	jalr	-956(ra) # 8000346c <argstr>
    80006830:	02054b63          	bltz	a0,80006866 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80006834:	f6841683          	lh	a3,-152(s0)
    80006838:	f6c41603          	lh	a2,-148(s0)
    8000683c:	458d                	li	a1,3
    8000683e:	f7040513          	addi	a0,s0,-144
    80006842:	fffff097          	auipc	ra,0xfffff
    80006846:	714080e7          	jalr	1812(ra) # 80005f56 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000684a:	cd11                	beqz	a0,80006866 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000684c:	ffffe097          	auipc	ra,0xffffe
    80006850:	f76080e7          	jalr	-138(ra) # 800047c2 <iunlockput>
  end_op();
    80006854:	ffffe097          	auipc	ra,0xffffe
    80006858:	750080e7          	jalr	1872(ra) # 80004fa4 <end_op>
  return 0;
    8000685c:	4501                	li	a0,0
}
    8000685e:	60ea                	ld	ra,152(sp)
    80006860:	644a                	ld	s0,144(sp)
    80006862:	610d                	addi	sp,sp,160
    80006864:	8082                	ret
    end_op();
    80006866:	ffffe097          	auipc	ra,0xffffe
    8000686a:	73e080e7          	jalr	1854(ra) # 80004fa4 <end_op>
    return -1;
    8000686e:	557d                	li	a0,-1
    80006870:	b7fd                	j	8000685e <sys_mknod+0x6c>

0000000080006872 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006872:	7135                	addi	sp,sp,-160
    80006874:	ed06                	sd	ra,152(sp)
    80006876:	e922                	sd	s0,144(sp)
    80006878:	e14a                	sd	s2,128(sp)
    8000687a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000687c:	ffffb097          	auipc	ra,0xffffb
    80006880:	598080e7          	jalr	1432(ra) # 80001e14 <myproc>
    80006884:	892a                	mv	s2,a0
  
  begin_op();
    80006886:	ffffe097          	auipc	ra,0xffffe
    8000688a:	6a4080e7          	jalr	1700(ra) # 80004f2a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000688e:	08000613          	li	a2,128
    80006892:	f6040593          	addi	a1,s0,-160
    80006896:	4501                	li	a0,0
    80006898:	ffffd097          	auipc	ra,0xffffd
    8000689c:	bd4080e7          	jalr	-1068(ra) # 8000346c <argstr>
    800068a0:	04054d63          	bltz	a0,800068fa <sys_chdir+0x88>
    800068a4:	e526                	sd	s1,136(sp)
    800068a6:	f6040513          	addi	a0,s0,-160
    800068aa:	ffffe097          	auipc	ra,0xffffe
    800068ae:	480080e7          	jalr	1152(ra) # 80004d2a <namei>
    800068b2:	84aa                	mv	s1,a0
    800068b4:	c131                	beqz	a0,800068f8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800068b6:	ffffe097          	auipc	ra,0xffffe
    800068ba:	ca6080e7          	jalr	-858(ra) # 8000455c <ilock>
  if(ip->type != T_DIR){
    800068be:	04449703          	lh	a4,68(s1)
    800068c2:	4785                	li	a5,1
    800068c4:	04f71163          	bne	a4,a5,80006906 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800068c8:	8526                	mv	a0,s1
    800068ca:	ffffe097          	auipc	ra,0xffffe
    800068ce:	d58080e7          	jalr	-680(ra) # 80004622 <iunlock>
  iput(p->cwd);
    800068d2:	15093503          	ld	a0,336(s2)
    800068d6:	ffffe097          	auipc	ra,0xffffe
    800068da:	e44080e7          	jalr	-444(ra) # 8000471a <iput>
  end_op();
    800068de:	ffffe097          	auipc	ra,0xffffe
    800068e2:	6c6080e7          	jalr	1734(ra) # 80004fa4 <end_op>
  p->cwd = ip;
    800068e6:	14993823          	sd	s1,336(s2)
  return 0;
    800068ea:	4501                	li	a0,0
    800068ec:	64aa                	ld	s1,136(sp)
}
    800068ee:	60ea                	ld	ra,152(sp)
    800068f0:	644a                	ld	s0,144(sp)
    800068f2:	690a                	ld	s2,128(sp)
    800068f4:	610d                	addi	sp,sp,160
    800068f6:	8082                	ret
    800068f8:	64aa                	ld	s1,136(sp)
    end_op();
    800068fa:	ffffe097          	auipc	ra,0xffffe
    800068fe:	6aa080e7          	jalr	1706(ra) # 80004fa4 <end_op>
    return -1;
    80006902:	557d                	li	a0,-1
    80006904:	b7ed                	j	800068ee <sys_chdir+0x7c>
    iunlockput(ip);
    80006906:	8526                	mv	a0,s1
    80006908:	ffffe097          	auipc	ra,0xffffe
    8000690c:	eba080e7          	jalr	-326(ra) # 800047c2 <iunlockput>
    end_op();
    80006910:	ffffe097          	auipc	ra,0xffffe
    80006914:	694080e7          	jalr	1684(ra) # 80004fa4 <end_op>
    return -1;
    80006918:	557d                	li	a0,-1
    8000691a:	64aa                	ld	s1,136(sp)
    8000691c:	bfc9                	j	800068ee <sys_chdir+0x7c>

000000008000691e <sys_exec>:

uint64
sys_exec(void)
{
    8000691e:	7121                	addi	sp,sp,-448
    80006920:	ff06                	sd	ra,440(sp)
    80006922:	fb22                	sd	s0,432(sp)
    80006924:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006926:	e4840593          	addi	a1,s0,-440
    8000692a:	4505                	li	a0,1
    8000692c:	ffffd097          	auipc	ra,0xffffd
    80006930:	b20080e7          	jalr	-1248(ra) # 8000344c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006934:	08000613          	li	a2,128
    80006938:	f5040593          	addi	a1,s0,-176
    8000693c:	4501                	li	a0,0
    8000693e:	ffffd097          	auipc	ra,0xffffd
    80006942:	b2e080e7          	jalr	-1234(ra) # 8000346c <argstr>
    80006946:	87aa                	mv	a5,a0
    return -1;
    80006948:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000694a:	0e07c263          	bltz	a5,80006a2e <sys_exec+0x110>
    8000694e:	f726                	sd	s1,424(sp)
    80006950:	f34a                	sd	s2,416(sp)
    80006952:	ef4e                	sd	s3,408(sp)
    80006954:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80006956:	10000613          	li	a2,256
    8000695a:	4581                	li	a1,0
    8000695c:	e5040513          	addi	a0,s0,-432
    80006960:	ffffa097          	auipc	ra,0xffffa
    80006964:	4ac080e7          	jalr	1196(ra) # 80000e0c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006968:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000696c:	89a6                	mv	s3,s1
    8000696e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006970:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006974:	00391513          	slli	a0,s2,0x3
    80006978:	e4040593          	addi	a1,s0,-448
    8000697c:	e4843783          	ld	a5,-440(s0)
    80006980:	953e                	add	a0,a0,a5
    80006982:	ffffd097          	auipc	ra,0xffffd
    80006986:	a0c080e7          	jalr	-1524(ra) # 8000338e <fetchaddr>
    8000698a:	02054a63          	bltz	a0,800069be <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    8000698e:	e4043783          	ld	a5,-448(s0)
    80006992:	c7b9                	beqz	a5,800069e0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80006994:	ffffa097          	auipc	ra,0xffffa
    80006998:	26e080e7          	jalr	622(ra) # 80000c02 <kalloc>
    8000699c:	85aa                	mv	a1,a0
    8000699e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800069a2:	cd11                	beqz	a0,800069be <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800069a4:	6605                	lui	a2,0x1
    800069a6:	e4043503          	ld	a0,-448(s0)
    800069aa:	ffffd097          	auipc	ra,0xffffd
    800069ae:	a36080e7          	jalr	-1482(ra) # 800033e0 <fetchstr>
    800069b2:	00054663          	bltz	a0,800069be <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    800069b6:	0905                	addi	s2,s2,1
    800069b8:	09a1                	addi	s3,s3,8
    800069ba:	fb491de3          	bne	s2,s4,80006974 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800069be:	f5040913          	addi	s2,s0,-176
    800069c2:	6088                	ld	a0,0(s1)
    800069c4:	c125                	beqz	a0,80006a24 <sys_exec+0x106>
    kfree(argv[i]);
    800069c6:	ffffa097          	auipc	ra,0xffffa
    800069ca:	0d4080e7          	jalr	212(ra) # 80000a9a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800069ce:	04a1                	addi	s1,s1,8
    800069d0:	ff2499e3          	bne	s1,s2,800069c2 <sys_exec+0xa4>
  return -1;
    800069d4:	557d                	li	a0,-1
    800069d6:	74ba                	ld	s1,424(sp)
    800069d8:	791a                	ld	s2,416(sp)
    800069da:	69fa                	ld	s3,408(sp)
    800069dc:	6a5a                	ld	s4,400(sp)
    800069de:	a881                	j	80006a2e <sys_exec+0x110>
      argv[i] = 0;
    800069e0:	0009079b          	sext.w	a5,s2
    800069e4:	078e                	slli	a5,a5,0x3
    800069e6:	fd078793          	addi	a5,a5,-48
    800069ea:	97a2                	add	a5,a5,s0
    800069ec:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800069f0:	e5040593          	addi	a1,s0,-432
    800069f4:	f5040513          	addi	a0,s0,-176
    800069f8:	fffff097          	auipc	ra,0xfffff
    800069fc:	120080e7          	jalr	288(ra) # 80005b18 <exec>
    80006a00:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a02:	f5040993          	addi	s3,s0,-176
    80006a06:	6088                	ld	a0,0(s1)
    80006a08:	c901                	beqz	a0,80006a18 <sys_exec+0xfa>
    kfree(argv[i]);
    80006a0a:	ffffa097          	auipc	ra,0xffffa
    80006a0e:	090080e7          	jalr	144(ra) # 80000a9a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a12:	04a1                	addi	s1,s1,8
    80006a14:	ff3499e3          	bne	s1,s3,80006a06 <sys_exec+0xe8>
  return ret;
    80006a18:	854a                	mv	a0,s2
    80006a1a:	74ba                	ld	s1,424(sp)
    80006a1c:	791a                	ld	s2,416(sp)
    80006a1e:	69fa                	ld	s3,408(sp)
    80006a20:	6a5a                	ld	s4,400(sp)
    80006a22:	a031                	j	80006a2e <sys_exec+0x110>
  return -1;
    80006a24:	557d                	li	a0,-1
    80006a26:	74ba                	ld	s1,424(sp)
    80006a28:	791a                	ld	s2,416(sp)
    80006a2a:	69fa                	ld	s3,408(sp)
    80006a2c:	6a5a                	ld	s4,400(sp)
}
    80006a2e:	70fa                	ld	ra,440(sp)
    80006a30:	745a                	ld	s0,432(sp)
    80006a32:	6139                	addi	sp,sp,448
    80006a34:	8082                	ret

0000000080006a36 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006a36:	7139                	addi	sp,sp,-64
    80006a38:	fc06                	sd	ra,56(sp)
    80006a3a:	f822                	sd	s0,48(sp)
    80006a3c:	f426                	sd	s1,40(sp)
    80006a3e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006a40:	ffffb097          	auipc	ra,0xffffb
    80006a44:	3d4080e7          	jalr	980(ra) # 80001e14 <myproc>
    80006a48:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006a4a:	fd840593          	addi	a1,s0,-40
    80006a4e:	4501                	li	a0,0
    80006a50:	ffffd097          	auipc	ra,0xffffd
    80006a54:	9fc080e7          	jalr	-1540(ra) # 8000344c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006a58:	fc840593          	addi	a1,s0,-56
    80006a5c:	fd040513          	addi	a0,s0,-48
    80006a60:	fffff097          	auipc	ra,0xfffff
    80006a64:	d50080e7          	jalr	-688(ra) # 800057b0 <pipealloc>
    return -1;
    80006a68:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006a6a:	0c054463          	bltz	a0,80006b32 <sys_pipe+0xfc>
  fd0 = -1;
    80006a6e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006a72:	fd043503          	ld	a0,-48(s0)
    80006a76:	fffff097          	auipc	ra,0xfffff
    80006a7a:	666080e7          	jalr	1638(ra) # 800060dc <fdalloc>
    80006a7e:	fca42223          	sw	a0,-60(s0)
    80006a82:	08054b63          	bltz	a0,80006b18 <sys_pipe+0xe2>
    80006a86:	fc843503          	ld	a0,-56(s0)
    80006a8a:	fffff097          	auipc	ra,0xfffff
    80006a8e:	652080e7          	jalr	1618(ra) # 800060dc <fdalloc>
    80006a92:	fca42023          	sw	a0,-64(s0)
    80006a96:	06054863          	bltz	a0,80006b06 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006a9a:	4691                	li	a3,4
    80006a9c:	fc440613          	addi	a2,s0,-60
    80006aa0:	fd843583          	ld	a1,-40(s0)
    80006aa4:	68a8                	ld	a0,80(s1)
    80006aa6:	ffffb097          	auipc	ra,0xffffb
    80006aaa:	006080e7          	jalr	6(ra) # 80001aac <copyout>
    80006aae:	02054063          	bltz	a0,80006ace <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006ab2:	4691                	li	a3,4
    80006ab4:	fc040613          	addi	a2,s0,-64
    80006ab8:	fd843583          	ld	a1,-40(s0)
    80006abc:	0591                	addi	a1,a1,4
    80006abe:	68a8                	ld	a0,80(s1)
    80006ac0:	ffffb097          	auipc	ra,0xffffb
    80006ac4:	fec080e7          	jalr	-20(ra) # 80001aac <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006ac8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006aca:	06055463          	bgez	a0,80006b32 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006ace:	fc442783          	lw	a5,-60(s0)
    80006ad2:	07e9                	addi	a5,a5,26
    80006ad4:	078e                	slli	a5,a5,0x3
    80006ad6:	97a6                	add	a5,a5,s1
    80006ad8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006adc:	fc042783          	lw	a5,-64(s0)
    80006ae0:	07e9                	addi	a5,a5,26
    80006ae2:	078e                	slli	a5,a5,0x3
    80006ae4:	94be                	add	s1,s1,a5
    80006ae6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006aea:	fd043503          	ld	a0,-48(s0)
    80006aee:	fffff097          	auipc	ra,0xfffff
    80006af2:	906080e7          	jalr	-1786(ra) # 800053f4 <fileclose>
    fileclose(wf);
    80006af6:	fc843503          	ld	a0,-56(s0)
    80006afa:	fffff097          	auipc	ra,0xfffff
    80006afe:	8fa080e7          	jalr	-1798(ra) # 800053f4 <fileclose>
    return -1;
    80006b02:	57fd                	li	a5,-1
    80006b04:	a03d                	j	80006b32 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006b06:	fc442783          	lw	a5,-60(s0)
    80006b0a:	0007c763          	bltz	a5,80006b18 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006b0e:	07e9                	addi	a5,a5,26
    80006b10:	078e                	slli	a5,a5,0x3
    80006b12:	97a6                	add	a5,a5,s1
    80006b14:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006b18:	fd043503          	ld	a0,-48(s0)
    80006b1c:	fffff097          	auipc	ra,0xfffff
    80006b20:	8d8080e7          	jalr	-1832(ra) # 800053f4 <fileclose>
    fileclose(wf);
    80006b24:	fc843503          	ld	a0,-56(s0)
    80006b28:	fffff097          	auipc	ra,0xfffff
    80006b2c:	8cc080e7          	jalr	-1844(ra) # 800053f4 <fileclose>
    return -1;
    80006b30:	57fd                	li	a5,-1
}
    80006b32:	853e                	mv	a0,a5
    80006b34:	70e2                	ld	ra,56(sp)
    80006b36:	7442                	ld	s0,48(sp)
    80006b38:	74a2                	ld	s1,40(sp)
    80006b3a:	6121                	addi	sp,sp,64
    80006b3c:	8082                	ret
	...

0000000080006b40 <kernelvec>:
    80006b40:	7111                	addi	sp,sp,-256
    80006b42:	e006                	sd	ra,0(sp)
    80006b44:	e40a                	sd	sp,8(sp)
    80006b46:	e80e                	sd	gp,16(sp)
    80006b48:	ec12                	sd	tp,24(sp)
    80006b4a:	f016                	sd	t0,32(sp)
    80006b4c:	f41a                	sd	t1,40(sp)
    80006b4e:	f81e                	sd	t2,48(sp)
    80006b50:	fc22                	sd	s0,56(sp)
    80006b52:	e0a6                	sd	s1,64(sp)
    80006b54:	e4aa                	sd	a0,72(sp)
    80006b56:	e8ae                	sd	a1,80(sp)
    80006b58:	ecb2                	sd	a2,88(sp)
    80006b5a:	f0b6                	sd	a3,96(sp)
    80006b5c:	f4ba                	sd	a4,104(sp)
    80006b5e:	f8be                	sd	a5,112(sp)
    80006b60:	fcc2                	sd	a6,120(sp)
    80006b62:	e146                	sd	a7,128(sp)
    80006b64:	e54a                	sd	s2,136(sp)
    80006b66:	e94e                	sd	s3,144(sp)
    80006b68:	ed52                	sd	s4,152(sp)
    80006b6a:	f156                	sd	s5,160(sp)
    80006b6c:	f55a                	sd	s6,168(sp)
    80006b6e:	f95e                	sd	s7,176(sp)
    80006b70:	fd62                	sd	s8,184(sp)
    80006b72:	e1e6                	sd	s9,192(sp)
    80006b74:	e5ea                	sd	s10,200(sp)
    80006b76:	e9ee                	sd	s11,208(sp)
    80006b78:	edf2                	sd	t3,216(sp)
    80006b7a:	f1f6                	sd	t4,224(sp)
    80006b7c:	f5fa                	sd	t5,232(sp)
    80006b7e:	f9fe                	sd	t6,240(sp)
    80006b80:	edafc0ef          	jal	8000325a <kerneltrap>
    80006b84:	6082                	ld	ra,0(sp)
    80006b86:	6122                	ld	sp,8(sp)
    80006b88:	61c2                	ld	gp,16(sp)
    80006b8a:	7282                	ld	t0,32(sp)
    80006b8c:	7322                	ld	t1,40(sp)
    80006b8e:	73c2                	ld	t2,48(sp)
    80006b90:	7462                	ld	s0,56(sp)
    80006b92:	6486                	ld	s1,64(sp)
    80006b94:	6526                	ld	a0,72(sp)
    80006b96:	65c6                	ld	a1,80(sp)
    80006b98:	6666                	ld	a2,88(sp)
    80006b9a:	7686                	ld	a3,96(sp)
    80006b9c:	7726                	ld	a4,104(sp)
    80006b9e:	77c6                	ld	a5,112(sp)
    80006ba0:	7866                	ld	a6,120(sp)
    80006ba2:	688a                	ld	a7,128(sp)
    80006ba4:	692a                	ld	s2,136(sp)
    80006ba6:	69ca                	ld	s3,144(sp)
    80006ba8:	6a6a                	ld	s4,152(sp)
    80006baa:	7a8a                	ld	s5,160(sp)
    80006bac:	7b2a                	ld	s6,168(sp)
    80006bae:	7bca                	ld	s7,176(sp)
    80006bb0:	7c6a                	ld	s8,184(sp)
    80006bb2:	6c8e                	ld	s9,192(sp)
    80006bb4:	6d2e                	ld	s10,200(sp)
    80006bb6:	6dce                	ld	s11,208(sp)
    80006bb8:	6e6e                	ld	t3,216(sp)
    80006bba:	7e8e                	ld	t4,224(sp)
    80006bbc:	7f2e                	ld	t5,232(sp)
    80006bbe:	7fce                	ld	t6,240(sp)
    80006bc0:	6111                	addi	sp,sp,256
    80006bc2:	10200073          	sret
    80006bc6:	00000013          	nop
    80006bca:	00000013          	nop
    80006bce:	0001                	nop

0000000080006bd0 <timervec>:
    80006bd0:	34051573          	csrrw	a0,mscratch,a0
    80006bd4:	e10c                	sd	a1,0(a0)
    80006bd6:	e510                	sd	a2,8(a0)
    80006bd8:	e914                	sd	a3,16(a0)
    80006bda:	6d0c                	ld	a1,24(a0)
    80006bdc:	7110                	ld	a2,32(a0)
    80006bde:	6194                	ld	a3,0(a1)
    80006be0:	96b2                	add	a3,a3,a2
    80006be2:	e194                	sd	a3,0(a1)
    80006be4:	4589                	li	a1,2
    80006be6:	14459073          	csrw	sip,a1
    80006bea:	6914                	ld	a3,16(a0)
    80006bec:	6510                	ld	a2,8(a0)
    80006bee:	610c                	ld	a1,0(a0)
    80006bf0:	34051573          	csrrw	a0,mscratch,a0
    80006bf4:	30200073          	mret
	...

0000000080006bfa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80006bfa:	1141                	addi	sp,sp,-16
    80006bfc:	e422                	sd	s0,8(sp)
    80006bfe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006c00:	0c0007b7          	lui	a5,0xc000
    80006c04:	4705                	li	a4,1
    80006c06:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006c08:	0c0007b7          	lui	a5,0xc000
    80006c0c:	c3d8                	sw	a4,4(a5)
  *(uint32*)(PLIC + VIRTIO1_IRQ*4) = 1;
    80006c0e:	0c0007b7          	lui	a5,0xc000
    80006c12:	c798                	sw	a4,8(a5)
}
    80006c14:	6422                	ld	s0,8(sp)
    80006c16:	0141                	addi	sp,sp,16
    80006c18:	8082                	ret

0000000080006c1a <plicinithart>:

void
plicinithart(void)
{
    80006c1a:	1141                	addi	sp,sp,-16
    80006c1c:	e406                	sd	ra,8(sp)
    80006c1e:	e022                	sd	s0,0(sp)
    80006c20:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006c22:	ffffb097          	auipc	ra,0xffffb
    80006c26:	1c6080e7          	jalr	454(ra) # 80001de8 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ) | (1 << VIRTIO1_IRQ);
    80006c2a:	0085171b          	slliw	a4,a0,0x8
    80006c2e:	0c0027b7          	lui	a5,0xc002
    80006c32:	97ba                	add	a5,a5,a4
    80006c34:	40600713          	li	a4,1030
    80006c38:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006c3c:	00d5151b          	slliw	a0,a0,0xd
    80006c40:	0c2017b7          	lui	a5,0xc201
    80006c44:	97aa                	add	a5,a5,a0
    80006c46:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006c4a:	60a2                	ld	ra,8(sp)
    80006c4c:	6402                	ld	s0,0(sp)
    80006c4e:	0141                	addi	sp,sp,16
    80006c50:	8082                	ret

0000000080006c52 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006c52:	1141                	addi	sp,sp,-16
    80006c54:	e406                	sd	ra,8(sp)
    80006c56:	e022                	sd	s0,0(sp)
    80006c58:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006c5a:	ffffb097          	auipc	ra,0xffffb
    80006c5e:	18e080e7          	jalr	398(ra) # 80001de8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006c62:	00d5151b          	slliw	a0,a0,0xd
    80006c66:	0c2017b7          	lui	a5,0xc201
    80006c6a:	97aa                	add	a5,a5,a0
  return irq;
}
    80006c6c:	43c8                	lw	a0,4(a5)
    80006c6e:	60a2                	ld	ra,8(sp)
    80006c70:	6402                	ld	s0,0(sp)
    80006c72:	0141                	addi	sp,sp,16
    80006c74:	8082                	ret

0000000080006c76 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006c76:	1101                	addi	sp,sp,-32
    80006c78:	ec06                	sd	ra,24(sp)
    80006c7a:	e822                	sd	s0,16(sp)
    80006c7c:	e426                	sd	s1,8(sp)
    80006c7e:	1000                	addi	s0,sp,32
    80006c80:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006c82:	ffffb097          	auipc	ra,0xffffb
    80006c86:	166080e7          	jalr	358(ra) # 80001de8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006c8a:	00d5151b          	slliw	a0,a0,0xd
    80006c8e:	0c2017b7          	lui	a5,0xc201
    80006c92:	97aa                	add	a5,a5,a0
    80006c94:	c3c4                	sw	s1,4(a5)
}
    80006c96:	60e2                	ld	ra,24(sp)
    80006c98:	6442                	ld	s0,16(sp)
    80006c9a:	64a2                	ld	s1,8(sp)
    80006c9c:	6105                	addi	sp,sp,32
    80006c9e:	8082                	ret

0000000080006ca0 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006ca0:	1141                	addi	sp,sp,-16
    80006ca2:	e406                	sd	ra,8(sp)
    80006ca4:	e022                	sd	s0,0(sp)
    80006ca6:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006ca8:	479d                	li	a5,7
    80006caa:	04a7cc63          	blt	a5,a0,80006d02 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006cae:	00067797          	auipc	a5,0x67
    80006cb2:	53278793          	addi	a5,a5,1330 # 8006e1e0 <disk>
    80006cb6:	97aa                	add	a5,a5,a0
    80006cb8:	0187c783          	lbu	a5,24(a5)
    80006cbc:	ebb9                	bnez	a5,80006d12 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006cbe:	00451693          	slli	a3,a0,0x4
    80006cc2:	00067797          	auipc	a5,0x67
    80006cc6:	51e78793          	addi	a5,a5,1310 # 8006e1e0 <disk>
    80006cca:	6398                	ld	a4,0(a5)
    80006ccc:	9736                	add	a4,a4,a3
    80006cce:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80006cd2:	6398                	ld	a4,0(a5)
    80006cd4:	9736                	add	a4,a4,a3
    80006cd6:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006cda:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006cde:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006ce2:	97aa                	add	a5,a5,a0
    80006ce4:	4705                	li	a4,1
    80006ce6:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006cea:	00067517          	auipc	a0,0x67
    80006cee:	50e50513          	addi	a0,a0,1294 # 8006e1f8 <disk+0x18>
    80006cf2:	ffffc097          	auipc	ra,0xffffc
    80006cf6:	a34080e7          	jalr	-1484(ra) # 80002726 <wakeup>
}
    80006cfa:	60a2                	ld	ra,8(sp)
    80006cfc:	6402                	ld	s0,0(sp)
    80006cfe:	0141                	addi	sp,sp,16
    80006d00:	8082                	ret
    panic("free_desc 1");
    80006d02:	00005517          	auipc	a0,0x5
    80006d06:	9c650513          	addi	a0,a0,-1594 # 8000b6c8 <etext+0x6c8>
    80006d0a:	ffffa097          	auipc	ra,0xffffa
    80006d0e:	856080e7          	jalr	-1962(ra) # 80000560 <panic>
    panic("free_desc 2");
    80006d12:	00005517          	auipc	a0,0x5
    80006d16:	9c650513          	addi	a0,a0,-1594 # 8000b6d8 <etext+0x6d8>
    80006d1a:	ffffa097          	auipc	ra,0xffffa
    80006d1e:	846080e7          	jalr	-1978(ra) # 80000560 <panic>

0000000080006d22 <virtio_disk_init>:
{
    80006d22:	1101                	addi	sp,sp,-32
    80006d24:	ec06                	sd	ra,24(sp)
    80006d26:	e822                	sd	s0,16(sp)
    80006d28:	e426                	sd	s1,8(sp)
    80006d2a:	e04a                	sd	s2,0(sp)
    80006d2c:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006d2e:	00005597          	auipc	a1,0x5
    80006d32:	9ba58593          	addi	a1,a1,-1606 # 8000b6e8 <etext+0x6e8>
    80006d36:	00067517          	auipc	a0,0x67
    80006d3a:	5d250513          	addi	a0,a0,1490 # 8006e308 <disk+0x128>
    80006d3e:	ffffa097          	auipc	ra,0xffffa
    80006d42:	f42080e7          	jalr	-190(ra) # 80000c80 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006d46:	100017b7          	lui	a5,0x10001
    80006d4a:	4398                	lw	a4,0(a5)
    80006d4c:	2701                	sext.w	a4,a4
    80006d4e:	747277b7          	lui	a5,0x74727
    80006d52:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006d56:	18f71c63          	bne	a4,a5,80006eee <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006d5a:	100017b7          	lui	a5,0x10001
    80006d5e:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80006d60:	439c                	lw	a5,0(a5)
    80006d62:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006d64:	4709                	li	a4,2
    80006d66:	18e79463          	bne	a5,a4,80006eee <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006d6a:	100017b7          	lui	a5,0x10001
    80006d6e:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80006d70:	439c                	lw	a5,0(a5)
    80006d72:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006d74:	16e79d63          	bne	a5,a4,80006eee <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006d78:	100017b7          	lui	a5,0x10001
    80006d7c:	47d8                	lw	a4,12(a5)
    80006d7e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006d80:	554d47b7          	lui	a5,0x554d4
    80006d84:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006d88:	16f71363          	bne	a4,a5,80006eee <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d8c:	100017b7          	lui	a5,0x10001
    80006d90:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d94:	4705                	li	a4,1
    80006d96:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d98:	470d                	li	a4,3
    80006d9a:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006d9c:	10001737          	lui	a4,0x10001
    80006da0:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006da2:	c7ffe737          	lui	a4,0xc7ffe
    80006da6:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47f8e2c7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006daa:	8ef9                	and	a3,a3,a4
    80006dac:	10001737          	lui	a4,0x10001
    80006db0:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006db2:	472d                	li	a4,11
    80006db4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006db6:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006dba:	439c                	lw	a5,0(a5)
    80006dbc:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006dc0:	8ba1                	andi	a5,a5,8
    80006dc2:	12078e63          	beqz	a5,80006efe <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006dc6:	100017b7          	lui	a5,0x10001
    80006dca:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006dce:	100017b7          	lui	a5,0x10001
    80006dd2:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006dd6:	439c                	lw	a5,0(a5)
    80006dd8:	2781                	sext.w	a5,a5
    80006dda:	12079a63          	bnez	a5,80006f0e <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006dde:	100017b7          	lui	a5,0x10001
    80006de2:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80006de6:	439c                	lw	a5,0(a5)
    80006de8:	2781                	sext.w	a5,a5
  if(max == 0)
    80006dea:	12078a63          	beqz	a5,80006f1e <virtio_disk_init+0x1fc>
  if(max < NUM)
    80006dee:	471d                	li	a4,7
    80006df0:	12f77f63          	bgeu	a4,a5,80006f2e <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    80006df4:	ffffa097          	auipc	ra,0xffffa
    80006df8:	e0e080e7          	jalr	-498(ra) # 80000c02 <kalloc>
    80006dfc:	00067497          	auipc	s1,0x67
    80006e00:	3e448493          	addi	s1,s1,996 # 8006e1e0 <disk>
    80006e04:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006e06:	ffffa097          	auipc	ra,0xffffa
    80006e0a:	dfc080e7          	jalr	-516(ra) # 80000c02 <kalloc>
    80006e0e:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006e10:	ffffa097          	auipc	ra,0xffffa
    80006e14:	df2080e7          	jalr	-526(ra) # 80000c02 <kalloc>
    80006e18:	87aa                	mv	a5,a0
    80006e1a:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006e1c:	6088                	ld	a0,0(s1)
    80006e1e:	12050063          	beqz	a0,80006f3e <virtio_disk_init+0x21c>
    80006e22:	00067717          	auipc	a4,0x67
    80006e26:	3c673703          	ld	a4,966(a4) # 8006e1e8 <disk+0x8>
    80006e2a:	10070a63          	beqz	a4,80006f3e <virtio_disk_init+0x21c>
    80006e2e:	10078863          	beqz	a5,80006f3e <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    80006e32:	6605                	lui	a2,0x1
    80006e34:	4581                	li	a1,0
    80006e36:	ffffa097          	auipc	ra,0xffffa
    80006e3a:	fd6080e7          	jalr	-42(ra) # 80000e0c <memset>
  memset(disk.avail, 0, PGSIZE);
    80006e3e:	00067497          	auipc	s1,0x67
    80006e42:	3a248493          	addi	s1,s1,930 # 8006e1e0 <disk>
    80006e46:	6605                	lui	a2,0x1
    80006e48:	4581                	li	a1,0
    80006e4a:	6488                	ld	a0,8(s1)
    80006e4c:	ffffa097          	auipc	ra,0xffffa
    80006e50:	fc0080e7          	jalr	-64(ra) # 80000e0c <memset>
  memset(disk.used, 0, PGSIZE);
    80006e54:	6605                	lui	a2,0x1
    80006e56:	4581                	li	a1,0
    80006e58:	6888                	ld	a0,16(s1)
    80006e5a:	ffffa097          	auipc	ra,0xffffa
    80006e5e:	fb2080e7          	jalr	-78(ra) # 80000e0c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006e62:	100017b7          	lui	a5,0x10001
    80006e66:	4721                	li	a4,8
    80006e68:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006e6a:	4098                	lw	a4,0(s1)
    80006e6c:	100017b7          	lui	a5,0x10001
    80006e70:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006e74:	40d8                	lw	a4,4(s1)
    80006e76:	100017b7          	lui	a5,0x10001
    80006e7a:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006e7e:	649c                	ld	a5,8(s1)
    80006e80:	0007869b          	sext.w	a3,a5
    80006e84:	10001737          	lui	a4,0x10001
    80006e88:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006e8c:	9781                	srai	a5,a5,0x20
    80006e8e:	10001737          	lui	a4,0x10001
    80006e92:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006e96:	689c                	ld	a5,16(s1)
    80006e98:	0007869b          	sext.w	a3,a5
    80006e9c:	10001737          	lui	a4,0x10001
    80006ea0:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006ea4:	9781                	srai	a5,a5,0x20
    80006ea6:	10001737          	lui	a4,0x10001
    80006eaa:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006eae:	10001737          	lui	a4,0x10001
    80006eb2:	4785                	li	a5,1
    80006eb4:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006eb6:	00f48c23          	sb	a5,24(s1)
    80006eba:	00f48ca3          	sb	a5,25(s1)
    80006ebe:	00f48d23          	sb	a5,26(s1)
    80006ec2:	00f48da3          	sb	a5,27(s1)
    80006ec6:	00f48e23          	sb	a5,28(s1)
    80006eca:	00f48ea3          	sb	a5,29(s1)
    80006ece:	00f48f23          	sb	a5,30(s1)
    80006ed2:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006ed6:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006eda:	100017b7          	lui	a5,0x10001
    80006ede:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80006ee2:	60e2                	ld	ra,24(sp)
    80006ee4:	6442                	ld	s0,16(sp)
    80006ee6:	64a2                	ld	s1,8(sp)
    80006ee8:	6902                	ld	s2,0(sp)
    80006eea:	6105                	addi	sp,sp,32
    80006eec:	8082                	ret
    panic("could not find virtio disk");
    80006eee:	00005517          	auipc	a0,0x5
    80006ef2:	80a50513          	addi	a0,a0,-2038 # 8000b6f8 <etext+0x6f8>
    80006ef6:	ffff9097          	auipc	ra,0xffff9
    80006efa:	66a080e7          	jalr	1642(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006efe:	00005517          	auipc	a0,0x5
    80006f02:	81a50513          	addi	a0,a0,-2022 # 8000b718 <etext+0x718>
    80006f06:	ffff9097          	auipc	ra,0xffff9
    80006f0a:	65a080e7          	jalr	1626(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006f0e:	00005517          	auipc	a0,0x5
    80006f12:	82a50513          	addi	a0,a0,-2006 # 8000b738 <etext+0x738>
    80006f16:	ffff9097          	auipc	ra,0xffff9
    80006f1a:	64a080e7          	jalr	1610(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006f1e:	00005517          	auipc	a0,0x5
    80006f22:	83a50513          	addi	a0,a0,-1990 # 8000b758 <etext+0x758>
    80006f26:	ffff9097          	auipc	ra,0xffff9
    80006f2a:	63a080e7          	jalr	1594(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006f2e:	00005517          	auipc	a0,0x5
    80006f32:	84a50513          	addi	a0,a0,-1974 # 8000b778 <etext+0x778>
    80006f36:	ffff9097          	auipc	ra,0xffff9
    80006f3a:	62a080e7          	jalr	1578(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006f3e:	00005517          	auipc	a0,0x5
    80006f42:	85a50513          	addi	a0,a0,-1958 # 8000b798 <etext+0x798>
    80006f46:	ffff9097          	auipc	ra,0xffff9
    80006f4a:	61a080e7          	jalr	1562(ra) # 80000560 <panic>

0000000080006f4e <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006f4e:	7159                	addi	sp,sp,-112
    80006f50:	f486                	sd	ra,104(sp)
    80006f52:	f0a2                	sd	s0,96(sp)
    80006f54:	eca6                	sd	s1,88(sp)
    80006f56:	e8ca                	sd	s2,80(sp)
    80006f58:	e4ce                	sd	s3,72(sp)
    80006f5a:	e0d2                	sd	s4,64(sp)
    80006f5c:	fc56                	sd	s5,56(sp)
    80006f5e:	f85a                	sd	s6,48(sp)
    80006f60:	f45e                	sd	s7,40(sp)
    80006f62:	f062                	sd	s8,32(sp)
    80006f64:	ec66                	sd	s9,24(sp)
    80006f66:	1880                	addi	s0,sp,112
    80006f68:	8a2a                	mv	s4,a0
    80006f6a:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006f6c:	00c52c83          	lw	s9,12(a0)
    80006f70:	001c9c9b          	slliw	s9,s9,0x1
    80006f74:	1c82                	slli	s9,s9,0x20
    80006f76:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006f7a:	00067517          	auipc	a0,0x67
    80006f7e:	38e50513          	addi	a0,a0,910 # 8006e308 <disk+0x128>
    80006f82:	ffffa097          	auipc	ra,0xffffa
    80006f86:	d8e080e7          	jalr	-626(ra) # 80000d10 <acquire>
  for(int i = 0; i < 3; i++){
    80006f8a:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006f8c:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006f8e:	00067b17          	auipc	s6,0x67
    80006f92:	252b0b13          	addi	s6,s6,594 # 8006e1e0 <disk>
  for(int i = 0; i < 3; i++){
    80006f96:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006f98:	00067c17          	auipc	s8,0x67
    80006f9c:	370c0c13          	addi	s8,s8,880 # 8006e308 <disk+0x128>
    80006fa0:	a0ad                	j	8000700a <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80006fa2:	00fb0733          	add	a4,s6,a5
    80006fa6:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006faa:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006fac:	0207c563          	bltz	a5,80006fd6 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006fb0:	2905                	addiw	s2,s2,1
    80006fb2:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006fb4:	05590f63          	beq	s2,s5,80007012 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006fb8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006fba:	00067717          	auipc	a4,0x67
    80006fbe:	22670713          	addi	a4,a4,550 # 8006e1e0 <disk>
    80006fc2:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006fc4:	01874683          	lbu	a3,24(a4)
    80006fc8:	fee9                	bnez	a3,80006fa2 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006fca:	2785                	addiw	a5,a5,1
    80006fcc:	0705                	addi	a4,a4,1
    80006fce:	fe979be3          	bne	a5,s1,80006fc4 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006fd2:	57fd                	li	a5,-1
    80006fd4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006fd6:	03205163          	blez	s2,80006ff8 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006fda:	f9042503          	lw	a0,-112(s0)
    80006fde:	00000097          	auipc	ra,0x0
    80006fe2:	cc2080e7          	jalr	-830(ra) # 80006ca0 <free_desc>
      for(int j = 0; j < i; j++)
    80006fe6:	4785                	li	a5,1
    80006fe8:	0127d863          	bge	a5,s2,80006ff8 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006fec:	f9442503          	lw	a0,-108(s0)
    80006ff0:	00000097          	auipc	ra,0x0
    80006ff4:	cb0080e7          	jalr	-848(ra) # 80006ca0 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006ff8:	85e2                	mv	a1,s8
    80006ffa:	00067517          	auipc	a0,0x67
    80006ffe:	1fe50513          	addi	a0,a0,510 # 8006e1f8 <disk+0x18>
    80007002:	ffffb097          	auipc	ra,0xffffb
    80007006:	6c0080e7          	jalr	1728(ra) # 800026c2 <sleep>
  for(int i = 0; i < 3; i++){
    8000700a:	f9040613          	addi	a2,s0,-112
    8000700e:	894e                	mv	s2,s3
    80007010:	b765                	j	80006fb8 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80007012:	f9042503          	lw	a0,-112(s0)
    80007016:	00451693          	slli	a3,a0,0x4

  if(write)
    8000701a:	00067797          	auipc	a5,0x67
    8000701e:	1c678793          	addi	a5,a5,454 # 8006e1e0 <disk>
    80007022:	00a50713          	addi	a4,a0,10
    80007026:	0712                	slli	a4,a4,0x4
    80007028:	973e                	add	a4,a4,a5
    8000702a:	01703633          	snez	a2,s7
    8000702e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80007030:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80007034:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80007038:	6398                	ld	a4,0(a5)
    8000703a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000703c:	0a868613          	addi	a2,a3,168
    80007040:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80007042:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80007044:	6390                	ld	a2,0(a5)
    80007046:	00d605b3          	add	a1,a2,a3
    8000704a:	4741                	li	a4,16
    8000704c:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000704e:	4805                	li	a6,1
    80007050:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80007054:	f9442703          	lw	a4,-108(s0)
    80007058:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000705c:	0712                	slli	a4,a4,0x4
    8000705e:	963a                	add	a2,a2,a4
    80007060:	058a0593          	addi	a1,s4,88
    80007064:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80007066:	0007b883          	ld	a7,0(a5)
    8000706a:	9746                	add	a4,a4,a7
    8000706c:	40000613          	li	a2,1024
    80007070:	c710                	sw	a2,8(a4)
  if(write)
    80007072:	001bb613          	seqz	a2,s7
    80007076:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000707a:	00166613          	ori	a2,a2,1
    8000707e:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80007082:	f9842583          	lw	a1,-104(s0)
    80007086:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000708a:	00250613          	addi	a2,a0,2
    8000708e:	0612                	slli	a2,a2,0x4
    80007090:	963e                	add	a2,a2,a5
    80007092:	577d                	li	a4,-1
    80007094:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80007098:	0592                	slli	a1,a1,0x4
    8000709a:	98ae                	add	a7,a7,a1
    8000709c:	03068713          	addi	a4,a3,48
    800070a0:	973e                	add	a4,a4,a5
    800070a2:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800070a6:	6398                	ld	a4,0(a5)
    800070a8:	972e                	add	a4,a4,a1
    800070aa:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800070ae:	4689                	li	a3,2
    800070b0:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800070b4:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800070b8:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800070bc:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800070c0:	6794                	ld	a3,8(a5)
    800070c2:	0026d703          	lhu	a4,2(a3)
    800070c6:	8b1d                	andi	a4,a4,7
    800070c8:	0706                	slli	a4,a4,0x1
    800070ca:	96ba                	add	a3,a3,a4
    800070cc:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800070d0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800070d4:	6798                	ld	a4,8(a5)
    800070d6:	00275783          	lhu	a5,2(a4)
    800070da:	2785                	addiw	a5,a5,1
    800070dc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800070e0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800070e4:	100017b7          	lui	a5,0x10001
    800070e8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800070ec:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800070f0:	00067917          	auipc	s2,0x67
    800070f4:	21890913          	addi	s2,s2,536 # 8006e308 <disk+0x128>
  while(b->disk == 1) {
    800070f8:	4485                	li	s1,1
    800070fa:	01079c63          	bne	a5,a6,80007112 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800070fe:	85ca                	mv	a1,s2
    80007100:	8552                	mv	a0,s4
    80007102:	ffffb097          	auipc	ra,0xffffb
    80007106:	5c0080e7          	jalr	1472(ra) # 800026c2 <sleep>
  while(b->disk == 1) {
    8000710a:	004a2783          	lw	a5,4(s4)
    8000710e:	fe9788e3          	beq	a5,s1,800070fe <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80007112:	f9042903          	lw	s2,-112(s0)
    80007116:	00290713          	addi	a4,s2,2
    8000711a:	0712                	slli	a4,a4,0x4
    8000711c:	00067797          	auipc	a5,0x67
    80007120:	0c478793          	addi	a5,a5,196 # 8006e1e0 <disk>
    80007124:	97ba                	add	a5,a5,a4
    80007126:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000712a:	00067997          	auipc	s3,0x67
    8000712e:	0b698993          	addi	s3,s3,182 # 8006e1e0 <disk>
    80007132:	00491713          	slli	a4,s2,0x4
    80007136:	0009b783          	ld	a5,0(s3)
    8000713a:	97ba                	add	a5,a5,a4
    8000713c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80007140:	854a                	mv	a0,s2
    80007142:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80007146:	00000097          	auipc	ra,0x0
    8000714a:	b5a080e7          	jalr	-1190(ra) # 80006ca0 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000714e:	8885                	andi	s1,s1,1
    80007150:	f0ed                	bnez	s1,80007132 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80007152:	00067517          	auipc	a0,0x67
    80007156:	1b650513          	addi	a0,a0,438 # 8006e308 <disk+0x128>
    8000715a:	ffffa097          	auipc	ra,0xffffa
    8000715e:	c6a080e7          	jalr	-918(ra) # 80000dc4 <release>
}
    80007162:	70a6                	ld	ra,104(sp)
    80007164:	7406                	ld	s0,96(sp)
    80007166:	64e6                	ld	s1,88(sp)
    80007168:	6946                	ld	s2,80(sp)
    8000716a:	69a6                	ld	s3,72(sp)
    8000716c:	6a06                	ld	s4,64(sp)
    8000716e:	7ae2                	ld	s5,56(sp)
    80007170:	7b42                	ld	s6,48(sp)
    80007172:	7ba2                	ld	s7,40(sp)
    80007174:	7c02                	ld	s8,32(sp)
    80007176:	6ce2                	ld	s9,24(sp)
    80007178:	6165                	addi	sp,sp,112
    8000717a:	8082                	ret

000000008000717c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000717c:	1101                	addi	sp,sp,-32
    8000717e:	ec06                	sd	ra,24(sp)
    80007180:	e822                	sd	s0,16(sp)
    80007182:	e426                	sd	s1,8(sp)
    80007184:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80007186:	00067497          	auipc	s1,0x67
    8000718a:	05a48493          	addi	s1,s1,90 # 8006e1e0 <disk>
    8000718e:	00067517          	auipc	a0,0x67
    80007192:	17a50513          	addi	a0,a0,378 # 8006e308 <disk+0x128>
    80007196:	ffffa097          	auipc	ra,0xffffa
    8000719a:	b7a080e7          	jalr	-1158(ra) # 80000d10 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000719e:	100017b7          	lui	a5,0x10001
    800071a2:	53b8                	lw	a4,96(a5)
    800071a4:	8b0d                	andi	a4,a4,3
    800071a6:	100017b7          	lui	a5,0x10001
    800071aa:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800071ac:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800071b0:	689c                	ld	a5,16(s1)
    800071b2:	0204d703          	lhu	a4,32(s1)
    800071b6:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800071ba:	04f70863          	beq	a4,a5,8000720a <virtio_disk_intr+0x8e>
    __sync_synchronize();
    800071be:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800071c2:	6898                	ld	a4,16(s1)
    800071c4:	0204d783          	lhu	a5,32(s1)
    800071c8:	8b9d                	andi	a5,a5,7
    800071ca:	078e                	slli	a5,a5,0x3
    800071cc:	97ba                	add	a5,a5,a4
    800071ce:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800071d0:	00278713          	addi	a4,a5,2
    800071d4:	0712                	slli	a4,a4,0x4
    800071d6:	9726                	add	a4,a4,s1
    800071d8:	01074703          	lbu	a4,16(a4)
    800071dc:	e721                	bnez	a4,80007224 <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800071de:	0789                	addi	a5,a5,2
    800071e0:	0792                	slli	a5,a5,0x4
    800071e2:	97a6                	add	a5,a5,s1
    800071e4:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800071e6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800071ea:	ffffb097          	auipc	ra,0xffffb
    800071ee:	53c080e7          	jalr	1340(ra) # 80002726 <wakeup>

    disk.used_idx += 1;
    800071f2:	0204d783          	lhu	a5,32(s1)
    800071f6:	2785                	addiw	a5,a5,1
    800071f8:	17c2                	slli	a5,a5,0x30
    800071fa:	93c1                	srli	a5,a5,0x30
    800071fc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80007200:	6898                	ld	a4,16(s1)
    80007202:	00275703          	lhu	a4,2(a4)
    80007206:	faf71ce3          	bne	a4,a5,800071be <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    8000720a:	00067517          	auipc	a0,0x67
    8000720e:	0fe50513          	addi	a0,a0,254 # 8006e308 <disk+0x128>
    80007212:	ffffa097          	auipc	ra,0xffffa
    80007216:	bb2080e7          	jalr	-1102(ra) # 80000dc4 <release>
}
    8000721a:	60e2                	ld	ra,24(sp)
    8000721c:	6442                	ld	s0,16(sp)
    8000721e:	64a2                	ld	s1,8(sp)
    80007220:	6105                	addi	sp,sp,32
    80007222:	8082                	ret
      panic("virtio_disk_intr status");
    80007224:	00004517          	auipc	a0,0x4
    80007228:	58c50513          	addi	a0,a0,1420 # 8000b7b0 <etext+0x7b0>
    8000722c:	ffff9097          	auipc	ra,0xffff9
    80007230:	334080e7          	jalr	820(ra) # 80000560 <panic>

0000000080007234 <alloc_desc>:
 *         returns -1 if there are no free descriptors
 *
 */
int 
alloc_desc(struct virtq *q) 
{
    80007234:	1141                	addi	sp,sp,-16
    80007236:	e422                	sd	s0,8(sp)
    80007238:	0800                	addi	s0,sp,16
    8000723a:	862a                	mv	a2,a0
  for (int i = 0; i < NUM; i++) {
    8000723c:	01c50793          	addi	a5,a0,28
    80007240:	4501                	li	a0,0
    80007242:	46a1                	li	a3,8
    if (q->free[i]) {
    80007244:	0007c703          	lbu	a4,0(a5)
    80007248:	eb09                	bnez	a4,8000725a <alloc_desc+0x26>
  for (int i = 0; i < NUM; i++) {
    8000724a:	2505                	addiw	a0,a0,1
    8000724c:	0785                	addi	a5,a5,1
    8000724e:	fed51be3          	bne	a0,a3,80007244 <alloc_desc+0x10>
      q->free[i] = 0;
      return i;
    }
  }
  return -1;
    80007252:	557d                	li	a0,-1
}
    80007254:	6422                	ld	s0,8(sp)
    80007256:	0141                	addi	sp,sp,16
    80007258:	8082                	ret
      q->free[i] = 0;
    8000725a:	962a                	add	a2,a2,a0
    8000725c:	00060e23          	sb	zero,28(a2)
      return i;
    80007260:	bfd5                	j	80007254 <alloc_desc+0x20>

0000000080007262 <free_desc>:
 * Output: None
 *
 */
void 
free_desc(struct virtq *q, int i) 
{
    80007262:	1141                	addi	sp,sp,-16
    80007264:	e406                	sd	ra,8(sp)
    80007266:	e022                	sd	s0,0(sp)
    80007268:	0800                	addi	s0,sp,16
  if (i >= NUM)
    8000726a:	479d                	li	a5,7
    8000726c:	02b7cd63          	blt	a5,a1,800072a6 <free_desc+0x44>
    panic("free_desc 1");
  if (q->free[i])
    80007270:	00b507b3          	add	a5,a0,a1
    80007274:	01c7c783          	lbu	a5,28(a5)
    80007278:	ef9d                	bnez	a5,800072b6 <free_desc+0x54>
    panic("free_desc 2");

  q->desc->addr = 0;
    8000727a:	611c                	ld	a5,0(a0)
    8000727c:	0007b023          	sd	zero,0(a5)
  q->desc->len = 0;
    80007280:	611c                	ld	a5,0(a0)
    80007282:	0007a423          	sw	zero,8(a5)
  q->desc->flags = 0;
    80007286:	611c                	ld	a5,0(a0)
    80007288:	00079623          	sh	zero,12(a5)
  q->desc->next = 0;
    8000728c:	611c                	ld	a5,0(a0)
    8000728e:	00079723          	sh	zero,14(a5)
  wakeup(&q->free[i]);
    80007292:	05f1                	addi	a1,a1,28
    80007294:	952e                	add	a0,a0,a1
    80007296:	ffffb097          	auipc	ra,0xffffb
    8000729a:	490080e7          	jalr	1168(ra) # 80002726 <wakeup>
}
    8000729e:	60a2                	ld	ra,8(sp)
    800072a0:	6402                	ld	s0,0(sp)
    800072a2:	0141                	addi	sp,sp,16
    800072a4:	8082                	ret
    panic("free_desc 1");
    800072a6:	00004517          	auipc	a0,0x4
    800072aa:	42250513          	addi	a0,a0,1058 # 8000b6c8 <etext+0x6c8>
    800072ae:	ffff9097          	auipc	ra,0xffff9
    800072b2:	2b2080e7          	jalr	690(ra) # 80000560 <panic>
    panic("free_desc 2");
    800072b6:	00004517          	auipc	a0,0x4
    800072ba:	42250513          	addi	a0,a0,1058 # 8000b6d8 <etext+0x6d8>
    800072be:	ffff9097          	auipc	ra,0xffff9
    800072c2:	2a2080e7          	jalr	674(ra) # 80000560 <panic>

00000000800072c6 <virtio_net_init>:
 * a minimal netowrk driver, I only negotiate VIRTIO_NET_F_MAC
 *
 */
void 
virtio_net_init(void) 
{
    800072c6:	7159                	addi	sp,sp,-112
    800072c8:	f486                	sd	ra,104(sp)
    800072ca:	f0a2                	sd	s0,96(sp)
    800072cc:	eca6                	sd	s1,88(sp)
    800072ce:	e8ca                	sd	s2,80(sp)
    800072d0:	e4ce                	sd	s3,72(sp)
    800072d2:	e0d2                	sd	s4,64(sp)
    800072d4:	fc56                	sd	s5,56(sp)
    800072d6:	f85a                	sd	s6,48(sp)
    800072d8:	f45e                	sd	s7,40(sp)
    800072da:	f062                	sd	s8,32(sp)
    800072dc:	ec66                	sd	s9,24(sp)
    800072de:	e86a                	sd	s10,16(sp)
    800072e0:	e46e                	sd	s11,8(sp)
    800072e2:	1880                	addi	s0,sp,112
  uint32 status = 0;
  initlock(&net.vnet_lock, "virtio_net");
    800072e4:	00004597          	auipc	a1,0x4
    800072e8:	4e458593          	addi	a1,a1,1252 # 8000b7c8 <etext+0x7c8>
    800072ec:	00067517          	auipc	a0,0x67
    800072f0:	04450513          	addi	a0,a0,68 # 8006e330 <net+0x10>
    800072f4:	ffffa097          	auipc	ra,0xffffa
    800072f8:	98c080e7          	jalr	-1652(ra) # 80000c80 <initlock>

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800072fc:	100027b7          	lui	a5,0x10002
    80007300:	4398                	lw	a4,0(a5)
    80007302:	2701                	sext.w	a4,a4
    80007304:	747277b7          	lui	a5,0x74727
    80007308:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000730c:	36f71963          	bne	a4,a5,8000767e <virtio_net_init+0x3b8>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80007310:	100027b7          	lui	a5,0x10002
    80007314:	0791                	addi	a5,a5,4 # 10002004 <_entry-0x6fffdffc>
    80007316:	439c                	lw	a5,0(a5)
    80007318:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000731a:	4709                	li	a4,2
    8000731c:	36e79163          	bne	a5,a4,8000767e <virtio_net_init+0x3b8>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80007320:	100027b7          	lui	a5,0x10002
    80007324:	07a1                	addi	a5,a5,8 # 10002008 <_entry-0x6fffdff8>
    80007326:	439c                	lw	a5,0(a5)
    80007328:	2781                	sext.w	a5,a5
    8000732a:	4705                	li	a4,1
    8000732c:	34e79963          	bne	a5,a4,8000767e <virtio_net_init+0x3b8>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80007330:	100027b7          	lui	a5,0x10002
    80007334:	47d8                	lw	a4,12(a5)
    80007336:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80007338:	554d47b7          	lui	a5,0x554d4
    8000733c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80007340:	32f71f63          	bne	a4,a5,8000767e <virtio_net_init+0x3b8>
    panic("could not find virtio net");
  }

  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    80007344:	100024b7          	lui	s1,0x10002
    80007348:	07048493          	addi	s1,s1,112 # 10002070 <_entry-0x6fffdf90>
    8000734c:	0004a023          	sw	zero,0(s1)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007350:	4785                	li	a5,1
    80007352:	c09c                	sw	a5,0(s1)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007354:	478d                	li	a5,3
    80007356:	c09c                	sw	a5,0(s1)

  // This copies the memory from the config into my driver state struct
  memmove((void *)&net.cfg, (void *)VIRTIO_NET_CONFIG,
    80007358:	4631                	li	a2,12
    8000735a:	100025b7          	lui	a1,0x10002
    8000735e:	10058593          	addi	a1,a1,256 # 10002100 <_entry-0x6fffdf00>
    80007362:	00067517          	auipc	a0,0x67
    80007366:	fbe50513          	addi	a0,a0,-66 # 8006e320 <net>
    8000736a:	ffffa097          	auipc	ra,0xffffa
    8000736e:	afe080e7          	jalr	-1282(ra) # 80000e68 <memmove>
          sizeof(struct virtio_net_config));

  // Negotiate the feature bits
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80007372:	100027b7          	lui	a5,0x10002
    80007376:	4b98                	lw	a4,16(a5)
  features &= VIRTIO_NET_F_MAC;
    80007378:	02077713          	andi	a4,a4,32
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000737c:	100027b7          	lui	a5,0x10002
    80007380:	d398                	sw	a4,32(a5)

  // Tell device that feature negotiation is complete
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007382:	47ad                	li	a5,11
    80007384:	c09c                	sw	a5,0(s1)

  // Make sure that FEATURES_OK is set
  status = *R(VIRTIO_MMIO_STATUS);
    80007386:	409c                	lw	a5,0(s1)
    80007388:	00078d1b          	sext.w	s10,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000738c:	8ba1                	andi	a5,a5,8
    8000738e:	30078063          	beqz	a5,8000768e <virtio_net_init+0x3c8>
    panic("virtio net FEATURES_OK unset");

  // Check max queue size
  uint32 max_queue_size = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80007392:	100027b7          	lui	a5,0x10002
    80007396:	03478793          	addi	a5,a5,52 # 10002034 <_entry-0x6fffdfcc>
    8000739a:	439c                	lw	a5,0(a5)
    8000739c:	2781                	sext.w	a5,a5
  if (max_queue_size == 0)
    8000739e:	30078063          	beqz	a5,8000769e <virtio_net_init+0x3d8>
    panic("virtio net has no queue 1 (QUEUE_TX)");
  if (max_queue_size < NUM)
    800073a2:	471d                	li	a4,7
    800073a4:	30f77563          	bgeu	a4,a5,800076ae <virtio_net_init+0x3e8>
    panic("virtio net max queue too short");

  /* Initialize QUEUE_TX */
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    800073a8:	100027b7          	lui	a5,0x10002
    800073ac:	4705                	li	a4,1
    800073ae:	db98                	sw	a4,48(a5)
  net.txq.num = QUEUE_TX;
    800073b0:	00067797          	auipc	a5,0x67
    800073b4:	fae7a823          	sw	a4,-80(a5) # 8006e360 <net+0x40>

  // ensure QUEUE_TX is not in use.
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    800073b8:	100027b7          	lui	a5,0x10002
    800073bc:	04478793          	addi	a5,a5,68 # 10002044 <_entry-0x6fffdfbc>
    800073c0:	439c                	lw	a5,0(a5)
    800073c2:	2781                	sext.w	a5,a5
    800073c4:	2e079d63          	bnez	a5,800076be <virtio_net_init+0x3f8>
    panic("QUEUE_TX should not be ready\n");

  net.txq.desc = kalloc();
    800073c8:	ffffa097          	auipc	ra,0xffffa
    800073cc:	83a080e7          	jalr	-1990(ra) # 80000c02 <kalloc>
    800073d0:	00067497          	auipc	s1,0x67
    800073d4:	f5048493          	addi	s1,s1,-176 # 8006e320 <net>
    800073d8:	f488                	sd	a0,40(s1)
  net.txq.driver_area = kalloc();
    800073da:	ffffa097          	auipc	ra,0xffffa
    800073de:	828080e7          	jalr	-2008(ra) # 80000c02 <kalloc>
    800073e2:	f888                	sd	a0,48(s1)
  net.txq.device_area = kalloc();
    800073e4:	ffffa097          	auipc	ra,0xffffa
    800073e8:	81e080e7          	jalr	-2018(ra) # 80000c02 <kalloc>
    800073ec:	87aa                	mv	a5,a0
    800073ee:	fc88                	sd	a0,56(s1)
  if (!net.txq.desc || !net.txq.driver_area || !net.txq.device_area)
    800073f0:	7488                	ld	a0,40(s1)
    800073f2:	2c050e63          	beqz	a0,800076ce <virtio_net_init+0x408>
    800073f6:	00067717          	auipc	a4,0x67
    800073fa:	f5a73703          	ld	a4,-166(a4) # 8006e350 <net+0x30>
    800073fe:	2c070863          	beqz	a4,800076ce <virtio_net_init+0x408>
    80007402:	2c078663          	beqz	a5,800076ce <virtio_net_init+0x408>
    panic("virtio net alloc\n");
  memset(net.txq.desc, 0, PGSIZE);
    80007406:	6605                	lui	a2,0x1
    80007408:	4581                	li	a1,0
    8000740a:	ffffa097          	auipc	ra,0xffffa
    8000740e:	a02080e7          	jalr	-1534(ra) # 80000e0c <memset>
  memset(net.txq.free, 1, NUM);
    80007412:	00067497          	auipc	s1,0x67
    80007416:	f0e48493          	addi	s1,s1,-242 # 8006e320 <net>
    8000741a:	4621                	li	a2,8
    8000741c:	4585                	li	a1,1
    8000741e:	00067517          	auipc	a0,0x67
    80007422:	f4650513          	addi	a0,a0,-186 # 8006e364 <net+0x44>
    80007426:	ffffa097          	auipc	ra,0xffffa
    8000742a:	9e6080e7          	jalr	-1562(ra) # 80000e0c <memset>
  memset(net.txq.driver_area, 0, PGSIZE);
    8000742e:	6605                	lui	a2,0x1
    80007430:	4581                	li	a1,0
    80007432:	7888                	ld	a0,48(s1)
    80007434:	ffffa097          	auipc	ra,0xffffa
    80007438:	9d8080e7          	jalr	-1576(ra) # 80000e0c <memset>
  memset(net.txq.device_area, 0, PGSIZE);
    8000743c:	6605                	lui	a2,0x1
    8000743e:	4581                	li	a1,0
    80007440:	7c88                	ld	a0,56(s1)
    80007442:	ffffa097          	auipc	ra,0xffffa
    80007446:	9ca080e7          	jalr	-1590(ra) # 80000e0c <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000744a:	100027b7          	lui	a5,0x10002
    8000744e:	4721                	li	a4,8
    80007450:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.txq.desc;
    80007452:	749c                	ld	a5,40(s1)
    80007454:	0007869b          	sext.w	a3,a5
    80007458:	10002737          	lui	a4,0x10002
    8000745c:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.txq.desc) >> 32;
    80007460:	9781                	srai	a5,a5,0x20
    80007462:	10002737          	lui	a4,0x10002
    80007466:	08f72223          	sw	a5,132(a4) # 10002084 <_entry-0x6fffdf7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.txq.driver_area;
    8000746a:	789c                	ld	a5,48(s1)
    8000746c:	0007869b          	sext.w	a3,a5
    80007470:	10002737          	lui	a4,0x10002
    80007474:	08d72823          	sw	a3,144(a4) # 10002090 <_entry-0x6fffdf70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.txq.driver_area) >> 32;
    80007478:	9781                	srai	a5,a5,0x20
    8000747a:	10002737          	lui	a4,0x10002
    8000747e:	08f72a23          	sw	a5,148(a4) # 10002094 <_entry-0x6fffdf6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.txq.device_area;
    80007482:	7c9c                	ld	a5,56(s1)
    80007484:	0007869b          	sext.w	a3,a5
    80007488:	10002737          	lui	a4,0x10002
    8000748c:	0ad72023          	sw	a3,160(a4) # 100020a0 <_entry-0x6fffdf60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.txq.device_area) >> 32;
    80007490:	9781                	srai	a5,a5,0x20
    80007492:	10002737          	lui	a4,0x10002
    80007496:	0af72223          	sw	a5,164(a4) # 100020a4 <_entry-0x6fffdf5c>

  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000749a:	100027b7          	lui	a5,0x10002
    8000749e:	4705                	li	a4,1
    800074a0:	c3f8                	sw	a4,68(a5)
    800074a2:	04478793          	addi	a5,a5,68 # 10002044 <_entry-0x6fffdfbc>

  /* Initialize QUEUE_RX */

  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_RX;
    800074a6:	10002737          	lui	a4,0x10002
    800074aa:	02072823          	sw	zero,48(a4) # 10002030 <_entry-0x6fffdfd0>
  net.rxq.num = QUEUE_RX;
    800074ae:	0604a423          	sw	zero,104(s1)
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    800074b2:	439c                	lw	a5,0(a5)
    800074b4:	2781                	sext.w	a5,a5
    800074b6:	22079463          	bnez	a5,800076de <virtio_net_init+0x418>
    panic("QUEUE_RX should not be ready\n");

  net.rxq.desc = kalloc();
    800074ba:	ffff9097          	auipc	ra,0xffff9
    800074be:	748080e7          	jalr	1864(ra) # 80000c02 <kalloc>
    800074c2:	00067497          	auipc	s1,0x67
    800074c6:	e5e48493          	addi	s1,s1,-418 # 8006e320 <net>
    800074ca:	e8a8                	sd	a0,80(s1)
  net.rxq.driver_area = kalloc();
    800074cc:	ffff9097          	auipc	ra,0xffff9
    800074d0:	736080e7          	jalr	1846(ra) # 80000c02 <kalloc>
    800074d4:	eca8                	sd	a0,88(s1)
  net.rxq.device_area = kalloc();
    800074d6:	ffff9097          	auipc	ra,0xffff9
    800074da:	72c080e7          	jalr	1836(ra) # 80000c02 <kalloc>
    800074de:	87aa                	mv	a5,a0
    800074e0:	f0a8                	sd	a0,96(s1)
  if (!net.rxq.desc || !net.rxq.driver_area || !net.rxq.device_area)
    800074e2:	68a8                	ld	a0,80(s1)
    800074e4:	20050563          	beqz	a0,800076ee <virtio_net_init+0x428>
    800074e8:	00067717          	auipc	a4,0x67
    800074ec:	e9073703          	ld	a4,-368(a4) # 8006e378 <net+0x58>
    800074f0:	1e070f63          	beqz	a4,800076ee <virtio_net_init+0x428>
    800074f4:	1e078d63          	beqz	a5,800076ee <virtio_net_init+0x428>
    panic("virtio net alloc");
  memset(net.rxq.desc, 0, PGSIZE);
    800074f8:	6605                	lui	a2,0x1
    800074fa:	4581                	li	a1,0
    800074fc:	ffffa097          	auipc	ra,0xffffa
    80007500:	910080e7          	jalr	-1776(ra) # 80000e0c <memset>
  memset(net.rxq.free, 1, NUM);
    80007504:	00067497          	auipc	s1,0x67
    80007508:	e1c48493          	addi	s1,s1,-484 # 8006e320 <net>
    8000750c:	4621                	li	a2,8
    8000750e:	4585                	li	a1,1
    80007510:	00067517          	auipc	a0,0x67
    80007514:	e7c50513          	addi	a0,a0,-388 # 8006e38c <net+0x6c>
    80007518:	ffffa097          	auipc	ra,0xffffa
    8000751c:	8f4080e7          	jalr	-1804(ra) # 80000e0c <memset>
  memset(net.rxq.driver_area, 0, PGSIZE);
    80007520:	6605                	lui	a2,0x1
    80007522:	4581                	li	a1,0
    80007524:	6ca8                	ld	a0,88(s1)
    80007526:	ffffa097          	auipc	ra,0xffffa
    8000752a:	8e6080e7          	jalr	-1818(ra) # 80000e0c <memset>
  memset(net.rxq.device_area, 0, PGSIZE);
    8000752e:	6605                	lui	a2,0x1
    80007530:	4581                	li	a1,0
    80007532:	70a8                	ld	a0,96(s1)
    80007534:	ffffa097          	auipc	ra,0xffffa
    80007538:	8d8080e7          	jalr	-1832(ra) # 80000e0c <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000753c:	100027b7          	lui	a5,0x10002
    80007540:	4721                	li	a4,8
    80007542:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.rxq.desc;
    80007544:	68bc                	ld	a5,80(s1)
    80007546:	0007869b          	sext.w	a3,a5
    8000754a:	10002737          	lui	a4,0x10002
    8000754e:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.rxq.desc) >> 32;
    80007552:	9781                	srai	a5,a5,0x20
    80007554:	10002737          	lui	a4,0x10002
    80007558:	08f72223          	sw	a5,132(a4) # 10002084 <_entry-0x6fffdf7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.rxq.driver_area;
    8000755c:	6cbc                	ld	a5,88(s1)
    8000755e:	0007869b          	sext.w	a3,a5
    80007562:	10002737          	lui	a4,0x10002
    80007566:	08d72823          	sw	a3,144(a4) # 10002090 <_entry-0x6fffdf70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.rxq.driver_area) >> 32;
    8000756a:	9781                	srai	a5,a5,0x20
    8000756c:	10002737          	lui	a4,0x10002
    80007570:	08f72a23          	sw	a5,148(a4) # 10002094 <_entry-0x6fffdf6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.rxq.device_area;
    80007574:	70bc                	ld	a5,96(s1)
    80007576:	0007869b          	sext.w	a3,a5
    8000757a:	10002737          	lui	a4,0x10002
    8000757e:	0ad72023          	sw	a3,160(a4) # 100020a0 <_entry-0x6fffdf60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.rxq.device_area) >> 32;
    80007582:	9781                	srai	a5,a5,0x20
    80007584:	10002737          	lui	a4,0x10002
    80007588:	0af72223          	sw	a5,164(a4) # 100020a4 <_entry-0x6fffdf5c>
    8000758c:	4a11                	li	s4,4

  for (int i = 0; i < NUM / 2; i++) {
    int rx_hdr_desc = alloc_desc(&net.rxq);
    8000758e:	00067a97          	auipc	s5,0x67
    80007592:	de2a8a93          	addi	s5,s5,-542 # 8006e370 <net+0x50>
    struct virtio_net_hdr *hdr = kalloc();
    if (!rxbuf)
      panic("rxbuf alloc failed");

    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    80007596:	4ca9                	li	s9,10
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    80007598:	4c05                	li	s8,1
    net.rxq.desc[rx_hdr_desc].next = rx_desc;

    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    net.rxq.desc[rx_desc].len = PGSIZE;
    8000759a:	6b85                	lui	s7,0x1
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    8000759c:	4b09                	li	s6,2
    int rx_hdr_desc = alloc_desc(&net.rxq);
    8000759e:	8556                	mv	a0,s5
    800075a0:	00000097          	auipc	ra,0x0
    800075a4:	c94080e7          	jalr	-876(ra) # 80007234 <alloc_desc>
    800075a8:	89aa                	mv	s3,a0
    int rx_desc = alloc_desc(&net.rxq);
    800075aa:	8556                	mv	a0,s5
    800075ac:	00000097          	auipc	ra,0x0
    800075b0:	c88080e7          	jalr	-888(ra) # 80007234 <alloc_desc>
    800075b4:	8daa                	mv	s11,a0
    void *rxbuf = kalloc();
    800075b6:	ffff9097          	auipc	ra,0xffff9
    800075ba:	64c080e7          	jalr	1612(ra) # 80000c02 <kalloc>
    800075be:	892a                	mv	s2,a0
    struct virtio_net_hdr *hdr = kalloc();
    800075c0:	ffff9097          	auipc	ra,0xffff9
    800075c4:	642080e7          	jalr	1602(ra) # 80000c02 <kalloc>
    if (!rxbuf)
    800075c8:	12090b63          	beqz	s2,800076fe <virtio_net_init+0x438>
    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    800075cc:	00499793          	slli	a5,s3,0x4
    800075d0:	68b8                	ld	a4,80(s1)
    800075d2:	973e                	add	a4,a4,a5
    800075d4:	e308                	sd	a0,0(a4)
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    800075d6:	68b8                	ld	a4,80(s1)
    800075d8:	973e                	add	a4,a4,a5
    800075da:	01972423          	sw	s9,8(a4)
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    800075de:	68b8                	ld	a4,80(s1)
    800075e0:	973e                	add	a4,a4,a5
    800075e2:	01871623          	sh	s8,12(a4)
    net.rxq.desc[rx_hdr_desc].next = rx_desc;
    800075e6:	68b8                	ld	a4,80(s1)
    800075e8:	97ba                	add	a5,a5,a4
    800075ea:	01b79723          	sh	s11,14(a5) # 1000200e <_entry-0x6fffdff2>
    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    800075ee:	004d9793          	slli	a5,s11,0x4
    800075f2:	68b8                	ld	a4,80(s1)
    800075f4:	973e                	add	a4,a4,a5
    800075f6:	01273023          	sd	s2,0(a4)
    net.rxq.desc[rx_desc].len = PGSIZE;
    800075fa:	68b8                	ld	a4,80(s1)
    800075fc:	973e                	add	a4,a4,a5
    800075fe:	01772423          	sw	s7,8(a4)
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    80007602:	68b8                	ld	a4,80(s1)
    80007604:	97ba                	add	a5,a5,a4
    80007606:	01679623          	sh	s6,12(a5)

    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = rx_hdr_desc;
    8000760a:	6cb8                	ld	a4,88(s1)
    8000760c:	00275783          	lhu	a5,2(a4)
    80007610:	8b9d                	andi	a5,a5,7
    80007612:	0786                	slli	a5,a5,0x1
    80007614:	973e                	add	a4,a4,a5
    80007616:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    8000761a:	0ff0000f          	fence
    net.rxq.driver_area->idx++;
    8000761e:	6cb8                	ld	a4,88(s1)
    80007620:	00275783          	lhu	a5,2(a4)
    80007624:	2785                	addiw	a5,a5,1
    80007626:	00f71123          	sh	a5,2(a4)
    __sync_synchronize();
    8000762a:	0ff0000f          	fence
  for (int i = 0; i < NUM / 2; i++) {
    8000762e:	3a7d                	addiw	s4,s4,-1
    80007630:	f60a17e3          	bnez	s4,8000759e <virtio_net_init+0x2d8>
  }

  // queue is ready
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80007634:	100027b7          	lui	a5,0x10002
    80007638:	4705                	li	a4,1
    8000763a:	c3f8                	sw	a4,68(a5)

  // Notify device
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_RX;
    8000763c:	100027b7          	lui	a5,0x10002
    80007640:	0407a823          	sw	zero,80(a5) # 10002050 <_entry-0x6fffdfb0>

  // Done initializing
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80007644:	004d6d13          	ori	s10,s10,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80007648:	100027b7          	lui	a5,0x10002
    8000764c:	07a7a823          	sw	s10,112(a5) # 10002070 <_entry-0x6fffdf90>

  // initialize packet buffer
  packet_buf = kalloc();
    80007650:	ffff9097          	auipc	ra,0xffff9
    80007654:	5b2080e7          	jalr	1458(ra) # 80000c02 <kalloc>
    80007658:	00005797          	auipc	a5,0x5
    8000765c:	30a7b823          	sd	a0,784(a5) # 8000c968 <packet_buf>
}
    80007660:	70a6                	ld	ra,104(sp)
    80007662:	7406                	ld	s0,96(sp)
    80007664:	64e6                	ld	s1,88(sp)
    80007666:	6946                	ld	s2,80(sp)
    80007668:	69a6                	ld	s3,72(sp)
    8000766a:	6a06                	ld	s4,64(sp)
    8000766c:	7ae2                	ld	s5,56(sp)
    8000766e:	7b42                	ld	s6,48(sp)
    80007670:	7ba2                	ld	s7,40(sp)
    80007672:	7c02                	ld	s8,32(sp)
    80007674:	6ce2                	ld	s9,24(sp)
    80007676:	6d42                	ld	s10,16(sp)
    80007678:	6da2                	ld	s11,8(sp)
    8000767a:	6165                	addi	sp,sp,112
    8000767c:	8082                	ret
    panic("could not find virtio net");
    8000767e:	00004517          	auipc	a0,0x4
    80007682:	15a50513          	addi	a0,a0,346 # 8000b7d8 <etext+0x7d8>
    80007686:	ffff9097          	auipc	ra,0xffff9
    8000768a:	eda080e7          	jalr	-294(ra) # 80000560 <panic>
    panic("virtio net FEATURES_OK unset");
    8000768e:	00004517          	auipc	a0,0x4
    80007692:	16a50513          	addi	a0,a0,362 # 8000b7f8 <etext+0x7f8>
    80007696:	ffff9097          	auipc	ra,0xffff9
    8000769a:	eca080e7          	jalr	-310(ra) # 80000560 <panic>
    panic("virtio net has no queue 1 (QUEUE_TX)");
    8000769e:	00004517          	auipc	a0,0x4
    800076a2:	17a50513          	addi	a0,a0,378 # 8000b818 <etext+0x818>
    800076a6:	ffff9097          	auipc	ra,0xffff9
    800076aa:	eba080e7          	jalr	-326(ra) # 80000560 <panic>
    panic("virtio net max queue too short");
    800076ae:	00004517          	auipc	a0,0x4
    800076b2:	19250513          	addi	a0,a0,402 # 8000b840 <etext+0x840>
    800076b6:	ffff9097          	auipc	ra,0xffff9
    800076ba:	eaa080e7          	jalr	-342(ra) # 80000560 <panic>
    panic("QUEUE_TX should not be ready\n");
    800076be:	00004517          	auipc	a0,0x4
    800076c2:	1a250513          	addi	a0,a0,418 # 8000b860 <etext+0x860>
    800076c6:	ffff9097          	auipc	ra,0xffff9
    800076ca:	e9a080e7          	jalr	-358(ra) # 80000560 <panic>
    panic("virtio net alloc\n");
    800076ce:	00004517          	auipc	a0,0x4
    800076d2:	1b250513          	addi	a0,a0,434 # 8000b880 <etext+0x880>
    800076d6:	ffff9097          	auipc	ra,0xffff9
    800076da:	e8a080e7          	jalr	-374(ra) # 80000560 <panic>
    panic("QUEUE_RX should not be ready\n");
    800076de:	00004517          	auipc	a0,0x4
    800076e2:	1ba50513          	addi	a0,a0,442 # 8000b898 <etext+0x898>
    800076e6:	ffff9097          	auipc	ra,0xffff9
    800076ea:	e7a080e7          	jalr	-390(ra) # 80000560 <panic>
    panic("virtio net alloc");
    800076ee:	00004517          	auipc	a0,0x4
    800076f2:	1ca50513          	addi	a0,a0,458 # 8000b8b8 <etext+0x8b8>
    800076f6:	ffff9097          	auipc	ra,0xffff9
    800076fa:	e6a080e7          	jalr	-406(ra) # 80000560 <panic>
      panic("rxbuf alloc failed");
    800076fe:	00004517          	auipc	a0,0x4
    80007702:	1d250513          	addi	a0,a0,466 # 8000b8d0 <etext+0x8d0>
    80007706:	ffff9097          	auipc	ra,0xffff9
    8000770a:	e5a080e7          	jalr	-422(ra) # 80000560 <panic>

000000008000770e <apply_padding>:
 */
int 
apply_padding(uint8 num_bytes)
{
  uint8 *pkt_ptr =
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    8000770e:	00005717          	auipc	a4,0x5
    80007712:	25a73703          	ld	a4,602(a4) # 8000c968 <packet_buf>
    80007716:	04a00693          	li	a3,74
    8000771a:	9e89                	subw	a3,a3,a0
  if (num_bytes > 64 - sizeof(struct virtio_net_hdr) || num_bytes < 1) {
    8000771c:	fff5079b          	addiw	a5,a0,-1
    80007720:	0ff7f793          	zext.b	a5,a5
    80007724:	03500613          	li	a2,53
    80007728:	02f66163          	bltu	a2,a5,8000774a <apply_padding+0x3c>
    8000772c:	00d707b3          	add	a5,a4,a3
    80007730:	0705                	addi	a4,a4,1
    80007732:	9736                	add	a4,a4,a3
    80007734:	357d                	addiw	a0,a0,-1
    80007736:	1502                	slli	a0,a0,0x20
    80007738:	9101                	srli	a0,a0,0x20
    8000773a:	972a                	add	a4,a4,a0
    printf("malformed packet data");
    return 1;
  }
  for (int i = 0; i < num_bytes; i++) {
    pkt_ptr[i] = 0;
    8000773c:	00078023          	sb	zero,0(a5)
  for (int i = 0; i < num_bytes; i++) {
    80007740:	0785                	addi	a5,a5,1
    80007742:	fee79de3          	bne	a5,a4,8000773c <apply_padding+0x2e>
  }
  return 0;
    80007746:	4501                	li	a0,0
}
    80007748:	8082                	ret
{
    8000774a:	1141                	addi	sp,sp,-16
    8000774c:	e406                	sd	ra,8(sp)
    8000774e:	e022                	sd	s0,0(sp)
    80007750:	0800                	addi	s0,sp,16
    printf("malformed packet data");
    80007752:	00004517          	auipc	a0,0x4
    80007756:	19650513          	addi	a0,a0,406 # 8000b8e8 <etext+0x8e8>
    8000775a:	ffff9097          	auipc	ra,0xffff9
    8000775e:	e50080e7          	jalr	-432(ra) # 800005aa <printf>
    return 1;
    80007762:	4505                	li	a0,1
}
    80007764:	60a2                	ld	ra,8(sp)
    80007766:	6402                	ld	s0,0(sp)
    80007768:	0141                	addi	sp,sp,16
    8000776a:	8082                	ret

000000008000776c <transmit_packet>:
 * Output: There is no return value from the function, but the packet frame
 *         is given to the NIC to be transmitted.
 */
void 
transmit_packet(void *pkt_data, uint16 pkt_len, uint16 protocol)
{
    8000776c:	7139                	addi	sp,sp,-64
    8000776e:	fc06                	sd	ra,56(sp)
    80007770:	f822                	sd	s0,48(sp)
    80007772:	ec4e                	sd	s3,24(sp)
    80007774:	e852                	sd	s4,16(sp)
    80007776:	0080                	addi	s0,sp,64
    80007778:	89aa                	mv	s3,a0
    8000777a:	8a2e                	mv	s4,a1
  /* Create the header for transmission */

  acquire(&net.vnet_lock);
    8000777c:	00067517          	auipc	a0,0x67
    80007780:	bb450513          	addi	a0,a0,-1100 # 8006e330 <net+0x10>
    80007784:	ffff9097          	auipc	ra,0xffff9
    80007788:	58c080e7          	jalr	1420(ra) # 80000d10 <acquire>
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    8000778c:	100027b7          	lui	a5,0x10002
    80007790:	4705                	li	a4,1
    80007792:	db98                	sw	a4,48(a5)
  // allocate for packet header and packet_frame
  struct virtio_net_hdr *hdr = kalloc();
    80007794:	ffff9097          	auipc	ra,0xffff9
    80007798:	46e080e7          	jalr	1134(ra) # 80000c02 <kalloc>
  if (hdr == 0)
    8000779c:	14050263          	beqz	a0,800078e0 <transmit_packet+0x174>
    800077a0:	f426                	sd	s1,40(sp)
    800077a2:	f04a                	sd	s2,32(sp)
    800077a4:	e456                	sd	s5,8(sp)
    800077a6:	892a                	mv	s2,a0
    panic("failed to allocate header\n");
  // initialize the header and packet
  memset(hdr, 0, PGSIZE);
    800077a8:	6605                	lui	a2,0x1
    800077aa:	4581                	li	a1,0
    800077ac:	ffff9097          	auipc	ra,0xffff9
    800077b0:	660080e7          	jalr	1632(ra) # 80000e0c <memset>

  int hdr_desc = alloc_desc(&net.txq);
    800077b4:	00067497          	auipc	s1,0x67
    800077b8:	b9448493          	addi	s1,s1,-1132 # 8006e348 <net+0x28>
    800077bc:	8526                	mv	a0,s1
    800077be:	00000097          	auipc	ra,0x0
    800077c2:	a76080e7          	jalr	-1418(ra) # 80007234 <alloc_desc>
    800077c6:	8aaa                	mv	s5,a0
  int pkt_desc = alloc_desc(&net.txq);
    800077c8:	8526                	mv	a0,s1
    800077ca:	00000097          	auipc	ra,0x0
    800077ce:	a6a080e7          	jalr	-1430(ra) # 80007234 <alloc_desc>
    800077d2:	84aa                	mv	s1,a0
  if (hdr_desc ==  -1 || pkt_desc == -1) {
    800077d4:	57fd                	li	a5,-1
    800077d6:	12fa8163          	beq	s5,a5,800078f8 <transmit_packet+0x18c>
    800077da:	10f50f63          	beq	a0,a5,800078f8 <transmit_packet+0x18c>
    800077de:	e05a                	sd	s6,0(sp)
    release(&net.vnet_lock);
    return;
  }

  hdr->flags = 0;
    800077e0:	00090023          	sb	zero,0(s2)
  hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
    800077e4:	000900a3          	sb	zero,1(s2)
  hdr->hdr_len = 0;
    800077e8:	00091123          	sh	zero,2(s2)

  // populate the packet buffer
  memmove(packet_buf, pkt_data, pkt_len);
    800077ec:	00005b17          	auipc	s6,0x5
    800077f0:	17cb0b13          	addi	s6,s6,380 # 8000c968 <packet_buf>
    800077f4:	8652                	mv	a2,s4
    800077f6:	85ce                	mv	a1,s3
    800077f8:	000b3503          	ld	a0,0(s6)
    800077fc:	ffff9097          	auipc	ra,0xffff9
    80007800:	66c080e7          	jalr	1644(ra) # 80000e68 <memmove>

  net.txq.desc[hdr_desc].flags |=
    80007804:	004a9793          	slli	a5,s5,0x4
    80007808:	00067997          	auipc	s3,0x67
    8000780c:	b1898993          	addi	s3,s3,-1256 # 8006e320 <net>
    80007810:	0289b703          	ld	a4,40(s3)
    80007814:	973e                	add	a4,a4,a5
    80007816:	00c75683          	lhu	a3,12(a4)
    8000781a:	0016e693          	ori	a3,a3,1
    8000781e:	00d71623          	sh	a3,12(a4)
      VRING_DESC_F_NEXT; // This tells the device it's a chain
  net.txq.desc[hdr_desc].len = HDR_SIZE;
    80007822:	0289b703          	ld	a4,40(s3)
    80007826:	973e                	add	a4,a4,a5
    80007828:	46a9                	li	a3,10
    8000782a:	c714                	sw	a3,8(a4)
  net.txq.desc[hdr_desc].addr = (uint64)hdr;
    8000782c:	0289b703          	ld	a4,40(s3)
    80007830:	973e                	add	a4,a4,a5
    80007832:	01273023          	sd	s2,0(a4)
  net.txq.desc[hdr_desc].next = pkt_desc;
    80007836:	0289b703          	ld	a4,40(s3)
    8000783a:	97ba                	add	a5,a5,a4
    8000783c:	00979723          	sh	s1,14(a5) # 1000200e <_entry-0x6fffdff2>

  net.txq.desc[pkt_desc].len = 14 + pkt_len;
    80007840:	0492                	slli	s1,s1,0x4
    80007842:	0289b783          	ld	a5,40(s3)
    80007846:	97a6                	add	a5,a5,s1
    80007848:	2a39                	addiw	s4,s4,14
    8000784a:	0147a423          	sw	s4,8(a5)
  net.txq.desc[pkt_desc].addr = (uint64)packet_buf;
    8000784e:	0289b783          	ld	a5,40(s3)
    80007852:	97a6                	add	a5,a5,s1
    80007854:	000b3703          	ld	a4,0(s6)
    80007858:	e398                	sd	a4,0(a5)
  net.txq.desc[pkt_desc].flags = 0;
    8000785a:	0289b783          	ld	a5,40(s3)
    8000785e:	97a6                	add	a5,a5,s1
    80007860:	00079623          	sh	zero,12(a5)
  //   if (res != 0)
  //     panic("failed to apply padding");
  // }

  // Tell the device first index in chain of descriptors
  net.txq.driver_area->ring[net.txq.driver_area->idx % NUM] = hdr_desc;
    80007864:	0309b703          	ld	a4,48(s3)
    80007868:	00275783          	lhu	a5,2(a4)
    8000786c:	8b9d                	andi	a5,a5,7
    8000786e:	0786                	slli	a5,a5,0x1
    80007870:	973e                	add	a4,a4,a5
    80007872:	01571223          	sh	s5,4(a4)
  __sync_synchronize();
    80007876:	0ff0000f          	fence
  // Tell the device another avail ring entry is available
  net.txq.driver_area->idx++;
    8000787a:	0309b703          	ld	a4,48(s3)
    8000787e:	00275783          	lhu	a5,2(a4)
    80007882:	2785                	addiw	a5,a5,1
    80007884:	00f71123          	sh	a5,2(a4)
  __sync_synchronize();
    80007888:	0ff0000f          	fence

  uint16 prev_used_idx = net.txq.device_area->idx;
    8000788c:	0389b783          	ld	a5,56(s3)
    80007890:	0027d483          	lhu	s1,2(a5)
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_TX;
    80007894:	100027b7          	lui	a5,0x10002
    80007898:	4705                	li	a4,1
    8000789a:	cbb8                	sw	a4,80(a5)
  release(&net.vnet_lock);
    8000789c:	00067517          	auipc	a0,0x67
    800078a0:	a9450513          	addi	a0,a0,-1388 # 8006e330 <net+0x10>
    800078a4:	ffff9097          	auipc	ra,0xffff9
    800078a8:	520080e7          	jalr	1312(ra) # 80000dc4 <release>

  // Wait for the device to use the descriptor. It indicates this by
  // decrementing the index. Polling helps to avoid race conditions
  while (net.txq.device_area->idx == prev_used_idx) {
    800078ac:	0389b783          	ld	a5,56(s3)
    800078b0:	0027d783          	lhu	a5,2(a5) # 10002002 <_entry-0x6fffdffe>
    800078b4:	04979b63          	bne	a5,s1,8000790a <transmit_packet+0x19e>
    800078b8:	86ce                	mv	a3,s3
    800078ba:	0004871b          	sext.w	a4,s1
    __sync_synchronize();
    800078be:	0ff0000f          	fence
  while (net.txq.device_area->idx == prev_used_idx) {
    800078c2:	7e9c                	ld	a5,56(a3)
    800078c4:	0027d783          	lhu	a5,2(a5)
    800078c8:	fee78be3          	beq	a5,a4,800078be <transmit_packet+0x152>
    800078cc:	6b02                	ld	s6,0(sp)
    800078ce:	74a2                	ld	s1,40(sp)
    800078d0:	7902                	ld	s2,32(sp)
    800078d2:	6aa2                	ld	s5,8(sp)
  }
}
    800078d4:	70e2                	ld	ra,56(sp)
    800078d6:	7442                	ld	s0,48(sp)
    800078d8:	69e2                	ld	s3,24(sp)
    800078da:	6a42                	ld	s4,16(sp)
    800078dc:	6121                	addi	sp,sp,64
    800078de:	8082                	ret
    800078e0:	f426                	sd	s1,40(sp)
    800078e2:	f04a                	sd	s2,32(sp)
    800078e4:	e456                	sd	s5,8(sp)
    800078e6:	e05a                	sd	s6,0(sp)
    panic("failed to allocate header\n");
    800078e8:	00004517          	auipc	a0,0x4
    800078ec:	01850513          	addi	a0,a0,24 # 8000b900 <etext+0x900>
    800078f0:	ffff9097          	auipc	ra,0xffff9
    800078f4:	c70080e7          	jalr	-912(ra) # 80000560 <panic>
    release(&net.vnet_lock);
    800078f8:	00067517          	auipc	a0,0x67
    800078fc:	a3850513          	addi	a0,a0,-1480 # 8006e330 <net+0x10>
    80007900:	ffff9097          	auipc	ra,0xffff9
    80007904:	4c4080e7          	jalr	1220(ra) # 80000dc4 <release>
    return;
    80007908:	b7d9                	j	800078ce <transmit_packet+0x162>
    8000790a:	6b02                	ld	s6,0(sp)
    8000790c:	b7c9                	j	800078ce <transmit_packet+0x162>

000000008000790e <handle_packet>:

void 
handle_packet(uint8 *packet, uint len) 
{
    8000790e:	7179                	addi	sp,sp,-48
    80007910:	f406                	sd	ra,40(sp)
    80007912:	f022                	sd	s0,32(sp)
    80007914:	ec26                	sd	s1,24(sp)
    80007916:	e84a                	sd	s2,16(sp)
    80007918:	e44e                	sd	s3,8(sp)
    8000791a:	e052                	sd	s4,0(sp)
    8000791c:	1800                	addi	s0,sp,48
    8000791e:	89aa                	mv	s3,a0
    80007920:	8a2e                	mv	s4,a1
    // printf("Interrupt: received packet of length %d\n", len - 10);

    struct eth_frame *eth_frame = kalloc();
    80007922:	ffff9097          	auipc	ra,0xffff9
    80007926:	2e0080e7          	jalr	736(ra) # 80000c02 <kalloc>
    8000792a:	84aa                	mv	s1,a0
    struct ip4_frame *ip4_pkt = kalloc();
    8000792c:	ffff9097          	auipc	ra,0xffff9
    80007930:	2d6080e7          	jalr	726(ra) # 80000c02 <kalloc>
    80007934:	892a                	mv	s2,a0
    memset(eth_frame, 0, PGSIZE);
    80007936:	6605                	lui	a2,0x1
    80007938:	4581                	li	a1,0
    8000793a:	8526                	mv	a0,s1
    8000793c:	ffff9097          	auipc	ra,0xffff9
    80007940:	4d0080e7          	jalr	1232(ra) # 80000e0c <memset>

    if (parse_eth_packet(packet, len, eth_frame) == 0) {
    80007944:	8626                	mv	a2,s1
    80007946:	85d2                	mv	a1,s4
    80007948:	854e                	mv	a0,s3
    8000794a:	00001097          	auipc	ra,0x1
    8000794e:	198080e7          	jalr	408(ra) # 80008ae2 <parse_eth_packet>
    80007952:	e515                	bnez	a0,8000797e <handle_packet+0x70>
      switch(ntohs(eth_frame->hdr.type)) {
    80007954:	00c4c703          	lbu	a4,12(s1)
    80007958:	00d4c783          	lbu	a5,13(s1)
    8000795c:	07a2                	slli	a5,a5,0x8
    8000795e:	00e7e6b3          	or	a3,a5,a4
    80007962:	4721                	li	a4,8
    80007964:	02e68f63          	beq	a3,a4,800079a2 <handle_packet+0x94>
    80007968:	2681                	sext.w	a3,a3
    8000796a:	60800793          	li	a5,1544
    8000796e:	00f69863          	bne	a3,a5,8000797e <handle_packet+0x70>
          if (parse_ip4_packet(eth_frame->payload, eth_frame->payload_len, ip4_pkt) == 0) {
            handle_ip4_packet(ip4_pkt);
          } 
          break;
        case PROTO_ARP:
          arp_recv((struct arp_pkt *)eth_frame->payload);
    80007972:	00e48513          	addi	a0,s1,14
    80007976:	00002097          	auipc	ra,0x2
    8000797a:	18a080e7          	jalr	394(ra) # 80009b00 <arp_recv>
          // printf("Unsupported ethertype %x\n", ntohs(eth_frame->hdr.type));
          break;
      }
    }

    kfree(eth_frame);
    8000797e:	8526                	mv	a0,s1
    80007980:	ffff9097          	auipc	ra,0xffff9
    80007984:	11a080e7          	jalr	282(ra) # 80000a9a <kfree>
    kfree(ip4_pkt);
    80007988:	854a                	mv	a0,s2
    8000798a:	ffff9097          	auipc	ra,0xffff9
    8000798e:	110080e7          	jalr	272(ra) # 80000a9a <kfree>
}
    80007992:	70a2                	ld	ra,40(sp)
    80007994:	7402                	ld	s0,32(sp)
    80007996:	64e2                	ld	s1,24(sp)
    80007998:	6942                	ld	s2,16(sp)
    8000799a:	69a2                	ld	s3,8(sp)
    8000799c:	6a02                	ld	s4,0(sp)
    8000799e:	6145                	addi	sp,sp,48
    800079a0:	8082                	ret
          memset(ip4_pkt, 0, PGSIZE);
    800079a2:	6605                	lui	a2,0x1
    800079a4:	4581                	li	a1,0
    800079a6:	854a                	mv	a0,s2
    800079a8:	ffff9097          	auipc	ra,0xffff9
    800079ac:	464080e7          	jalr	1124(ra) # 80000e0c <memset>
          if (parse_ip4_packet(eth_frame->payload, eth_frame->payload_len, ip4_pkt) == 0) {
    800079b0:	864a                	mv	a2,s2
    800079b2:	5ea4c583          	lbu	a1,1514(s1)
    800079b6:	00e48513          	addi	a0,s1,14
    800079ba:	00000097          	auipc	ra,0x0
    800079be:	1e2080e7          	jalr	482(ra) # 80007b9c <parse_ip4_packet>
    800079c2:	fd55                	bnez	a0,8000797e <handle_packet+0x70>
            handle_ip4_packet(ip4_pkt);
    800079c4:	854a                	mv	a0,s2
    800079c6:	00000097          	auipc	ra,0x0
    800079ca:	464080e7          	jalr	1124(ra) # 80007e2a <handle_ip4_packet>
    800079ce:	bf45                	j	8000797e <handle_packet+0x70>

00000000800079d0 <receive_packet>:

uint16 
receive_packet() 
{
    800079d0:	7139                	addi	sp,sp,-64
    800079d2:	fc06                	sd	ra,56(sp)
    800079d4:	f822                	sd	s0,48(sp)
    800079d6:	f426                	sd	s1,40(sp)
    800079d8:	0080                	addi	s0,sp,64
  acquire(&net.vnet_lock);
    800079da:	00067497          	auipc	s1,0x67
    800079de:	94648493          	addi	s1,s1,-1722 # 8006e320 <net>
    800079e2:	00067517          	auipc	a0,0x67
    800079e6:	94e50513          	addi	a0,a0,-1714 # 8006e330 <net+0x10>
    800079ea:	ffff9097          	auipc	ra,0xffff9
    800079ee:	326080e7          	jalr	806(ra) # 80000d10 <acquire>
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    800079f2:	58fc                	lw	a5,116(s1)
    800079f4:	70b8                	ld	a4,96(s1)
    800079f6:	00275683          	lhu	a3,2(a4)
    800079fa:	0af68063          	beq	a3,a5,80007a9a <receive_packet+0xca>
    800079fe:	f04a                	sd	s2,32(sp)
    80007a00:	ec4e                	sd	s3,24(sp)
    80007a02:	e852                	sd	s4,16(sp)
    80007a04:	e456                	sd	s5,8(sp)
    int id = e->id;
    int len = e->len - 10;

    uint8 *packet = (uint8 *)net.rxq.desc[net.rxq.desc[id].next].addr + 10;

    release(&net.vnet_lock);
    80007a06:	00067917          	auipc	s2,0x67
    80007a0a:	92a90913          	addi	s2,s2,-1750 # 8006e330 <net+0x10>
      &net.rxq.device_area->ring[net.rxq.used_idx % NUM];
    80007a0e:	41f7d69b          	sraiw	a3,a5,0x1f
    80007a12:	01d6d69b          	srliw	a3,a3,0x1d
    80007a16:	9fb5                	addw	a5,a5,a3
    80007a18:	8b9d                	andi	a5,a5,7
    80007a1a:	9f95                	subw	a5,a5,a3
    80007a1c:	078e                	slli	a5,a5,0x3
    80007a1e:	973e                	add	a4,a4,a5
    int id = e->id;
    80007a20:	00472983          	lw	s3,4(a4)
    int len = e->len - 10;
    80007a24:	00872a83          	lw	s5,8(a4)
    80007a28:	3ad9                	addiw	s5,s5,-10
    uint8 *packet = (uint8 *)net.rxq.desc[net.rxq.desc[id].next].addr + 10;
    80007a2a:	68bc                	ld	a5,80(s1)
    80007a2c:	00499713          	slli	a4,s3,0x4
    80007a30:	973e                	add	a4,a4,a5
    80007a32:	00e75703          	lhu	a4,14(a4)
    80007a36:	0712                	slli	a4,a4,0x4
    80007a38:	97ba                	add	a5,a5,a4
    80007a3a:	0007ba03          	ld	s4,0(a5)
    80007a3e:	0a29                	addi	s4,s4,10
    release(&net.vnet_lock);
    80007a40:	854a                	mv	a0,s2
    80007a42:	ffff9097          	auipc	ra,0xffff9
    80007a46:	382080e7          	jalr	898(ra) # 80000dc4 <release>

    handle_packet(packet, len);
    80007a4a:	85d6                	mv	a1,s5
    80007a4c:	8552                	mv	a0,s4
    80007a4e:	00000097          	auipc	ra,0x0
    80007a52:	ec0080e7          	jalr	-320(ra) # 8000790e <handle_packet>

    acquire(&net.vnet_lock);
    80007a56:	854a                	mv	a0,s2
    80007a58:	ffff9097          	auipc	ra,0xffff9
    80007a5c:	2b8080e7          	jalr	696(ra) # 80000d10 <acquire>
    // Move forward (with wrap)
    net.rxq.used_idx++;
    80007a60:	58fc                	lw	a5,116(s1)
    80007a62:	2785                	addiw	a5,a5,1
    80007a64:	d8fc                	sw	a5,116(s1)

    // Requeue descriptor for future packets
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    80007a66:	6cb8                	ld	a4,88(s1)
    80007a68:	00275783          	lhu	a5,2(a4)
    80007a6c:	8b9d                	andi	a5,a5,7
    80007a6e:	0786                	slli	a5,a5,0x1
    80007a70:	973e                	add	a4,a4,a5
    80007a72:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    80007a76:	0ff0000f          	fence
    net.rxq.driver_area->idx++;
    80007a7a:	6cb8                	ld	a4,88(s1)
    80007a7c:	00275783          	lhu	a5,2(a4)
    80007a80:	2785                	addiw	a5,a5,1
    80007a82:	00f71123          	sh	a5,2(a4)
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    80007a86:	58fc                	lw	a5,116(s1)
    80007a88:	70b8                	ld	a4,96(s1)
    80007a8a:	00275683          	lhu	a3,2(a4)
    80007a8e:	f8f690e3          	bne	a3,a5,80007a0e <receive_packet+0x3e>
    80007a92:	7902                	ld	s2,32(sp)
    80007a94:	69e2                	ld	s3,24(sp)
    80007a96:	6a42                	ld	s4,16(sp)
    80007a98:	6aa2                	ld	s5,8(sp)

    // notify device if needed
    // virtio_notify(&net.rxq);
  }
  release(&net.vnet_lock);
    80007a9a:	00067517          	auipc	a0,0x67
    80007a9e:	89650513          	addi	a0,a0,-1898 # 8006e330 <net+0x10>
    80007aa2:	ffff9097          	auipc	ra,0xffff9
    80007aa6:	322080e7          	jalr	802(ra) # 80000dc4 <release>
  return 0;
}
    80007aaa:	4501                	li	a0,0
    80007aac:	70e2                	ld	ra,56(sp)
    80007aae:	7442                	ld	s0,48(sp)
    80007ab0:	74a2                	ld	s1,40(sp)
    80007ab2:	6121                	addi	sp,sp,64
    80007ab4:	8082                	ret

0000000080007ab6 <print_ip4_packet>:
#include "udp.h"
#include "ip4.h"

void 
print_ip4_packet(struct ip4_frame *ip)
{
    80007ab6:	7179                	addi	sp,sp,-48
    80007ab8:	f406                	sd	ra,40(sp)
    80007aba:	f022                	sd	s0,32(sp)
    80007abc:	ec26                	sd	s1,24(sp)
    80007abe:	1800                	addi	s0,sp,48
    80007ac0:	84aa                	mv	s1,a0
  printf("\n");
    80007ac2:	00003517          	auipc	a0,0x3
    80007ac6:	55e50513          	addi	a0,a0,1374 # 8000b020 <etext+0x20>
    80007aca:	ffff9097          	auipc	ra,0xffff9
    80007ace:	ae0080e7          	jalr	-1312(ra) # 800005aa <printf>
  printf("IPv%d packet from %d.%d.%d.%d to %d.%d.%d.%d",
      ip->hdr.ver_ihl >> 4,
      (ip->hdr.src_ip >> 24) & 0xFF, (ip->hdr.src_ip >> 16) & 0xFF,
    80007ad2:	00c4d703          	lhu	a4,12(s1)
    80007ad6:	00e4d783          	lhu	a5,14(s1)
    80007ada:	07c2                	slli	a5,a5,0x10
    80007adc:	8fd9                	or	a5,a5,a4
    80007ade:	0007861b          	sext.w	a2,a5
      (ip->hdr.src_ip >> 8) & 0xFF,  ip->hdr.src_ip & 0xFF,
      (ip->hdr.dst_ip >> 24) & 0xFF, (ip->hdr.dst_ip >> 16) & 0xFF,
    80007ae2:	0104d503          	lhu	a0,16(s1)
    80007ae6:	0124d803          	lhu	a6,18(s1)
      (ip->hdr.src_ip >> 8) & 0xFF,  ip->hdr.src_ip & 0xFF,
    80007aea:	0086571b          	srliw	a4,a2,0x8
      (ip->hdr.src_ip >> 24) & 0xFF, (ip->hdr.src_ip >> 16) & 0xFF,
    80007aee:	0106569b          	srliw	a3,a2,0x10
  printf("IPv%d packet from %d.%d.%d.%d to %d.%d.%d.%d",
    80007af2:	0004c583          	lbu	a1,0(s1)
    80007af6:	0ff57893          	zext.b	a7,a0
    80007afa:	e446                	sd	a7,8(sp)
    80007afc:	8121                	srli	a0,a0,0x8
    80007afe:	e02a                	sd	a0,0(sp)
    80007b00:	0ff87893          	zext.b	a7,a6
    80007b04:	00885813          	srli	a6,a6,0x8
    80007b08:	0ff7f793          	zext.b	a5,a5
    80007b0c:	0ff77713          	zext.b	a4,a4
    80007b10:	0ff6f693          	zext.b	a3,a3
    80007b14:	0186561b          	srliw	a2,a2,0x18
    80007b18:	8191                	srli	a1,a1,0x4
    80007b1a:	00004517          	auipc	a0,0x4
    80007b1e:	e0650513          	addi	a0,a0,-506 # 8000b920 <etext+0x920>
    80007b22:	ffff9097          	auipc	ra,0xffff9
    80007b26:	a88080e7          	jalr	-1400(ra) # 800005aa <printf>
      (ip->hdr.dst_ip >> 8) & 0xFF,  ip->hdr.dst_ip & 0xFF);
  switch(ip->hdr.protocol) {
    80007b2a:	0094c783          	lbu	a5,9(s1)
    80007b2e:	4719                	li	a4,6
    80007b30:	00e78e63          	beq	a5,a4,80007b4c <print_ip4_packet+0x96>
    80007b34:	4745                	li	a4,17
    80007b36:	04e78a63          	beq	a5,a4,80007b8a <print_ip4_packet+0xd4>
      break;
    case(IPPROTO_UDP):
      printf(", proto UDP");
      break;
    default:
      printf("unsupported protocol\n");
    80007b3a:	00004517          	auipc	a0,0x4
    80007b3e:	e3650513          	addi	a0,a0,-458 # 8000b970 <etext+0x970>
    80007b42:	ffff9097          	auipc	ra,0xffff9
    80007b46:	a68080e7          	jalr	-1432(ra) # 800005aa <printf>
      break;
    80007b4a:	a809                	j	80007b5c <print_ip4_packet+0xa6>
      printf(", proto TCP");
    80007b4c:	00004517          	auipc	a0,0x4
    80007b50:	e0450513          	addi	a0,a0,-508 # 8000b950 <etext+0x950>
    80007b54:	ffff9097          	auipc	ra,0xffff9
    80007b58:	a56080e7          	jalr	-1450(ra) # 800005aa <printf>
  }
  printf(", payload %d bytes\n", ip->payload_len);
    80007b5c:	5f04d583          	lhu	a1,1520(s1)
    80007b60:	00004517          	auipc	a0,0x4
    80007b64:	e2850513          	addi	a0,a0,-472 # 8000b988 <etext+0x988>
    80007b68:	ffff9097          	auipc	ra,0xffff9
    80007b6c:	a42080e7          	jalr	-1470(ra) # 800005aa <printf>
  printf("\n");
    80007b70:	00003517          	auipc	a0,0x3
    80007b74:	4b050513          	addi	a0,a0,1200 # 8000b020 <etext+0x20>
    80007b78:	ffff9097          	auipc	ra,0xffff9
    80007b7c:	a32080e7          	jalr	-1486(ra) # 800005aa <printf>
}
    80007b80:	70a2                	ld	ra,40(sp)
    80007b82:	7402                	ld	s0,32(sp)
    80007b84:	64e2                	ld	s1,24(sp)
    80007b86:	6145                	addi	sp,sp,48
    80007b88:	8082                	ret
      printf(", proto UDP");
    80007b8a:	00004517          	auipc	a0,0x4
    80007b8e:	dd650513          	addi	a0,a0,-554 # 8000b960 <etext+0x960>
    80007b92:	ffff9097          	auipc	ra,0xffff9
    80007b96:	a18080e7          	jalr	-1512(ra) # 800005aa <printf>
      break;
    80007b9a:	b7c9                	j	80007b5c <print_ip4_packet+0xa6>

0000000080007b9c <parse_ip4_packet>:

int 
parse_ip4_packet(uint8 *buf, int len, struct ip4_frame *pkt)
{
    80007b9c:	87b2                	mv	a5,a2
  // printf("\tparsing ip packet\n");

  pkt->hdr.ver_ihl = buf[0];
    80007b9e:	00054703          	lbu	a4,0(a0)
    80007ba2:	00e60023          	sb	a4,0(a2) # 1000 <_entry-0x7ffff000>
  pkt->hdr.tos = buf[1];
    80007ba6:	00154703          	lbu	a4,1(a0)
    80007baa:	00e600a3          	sb	a4,1(a2)
  return (hostshort >> 8) | (hostshort << 8);
}

static inline uint16
ntohs(uint16 netshort) {
  return (netshort >> 8) | (netshort << 8);
    80007bae:	00255703          	lhu	a4,2(a0)
    80007bb2:	0087169b          	slliw	a3,a4,0x8
    80007bb6:	8321                	srli	a4,a4,0x8
    80007bb8:	8f55                	or	a4,a4,a3
  pkt->hdr.total_len = ntohs(*(uint16 *)(buf + 2));
    80007bba:	00e61123          	sh	a4,2(a2)
    80007bbe:	00455703          	lhu	a4,4(a0)
    80007bc2:	0087169b          	slliw	a3,a4,0x8
    80007bc6:	8321                	srli	a4,a4,0x8
    80007bc8:	8f55                	or	a4,a4,a3
  pkt->hdr.identification = ntohs(*(uint16 *)(buf + 4));
    80007bca:	00e61223          	sh	a4,4(a2)
    80007bce:	00655703          	lhu	a4,6(a0)
    80007bd2:	0087169b          	slliw	a3,a4,0x8
    80007bd6:	8321                	srli	a4,a4,0x8
    80007bd8:	8f55                	or	a4,a4,a3
  pkt->hdr.fragment_info = ntohs(*(uint16 *)(buf + 6));
    80007bda:	00e61323          	sh	a4,6(a2)
  pkt->hdr.ttl = buf[8];
    80007bde:	00854703          	lbu	a4,8(a0)
    80007be2:	00e60423          	sb	a4,8(a2)
  pkt->hdr.protocol = buf[9];
    80007be6:	00954703          	lbu	a4,9(a0)
    80007bea:	00e604a3          	sb	a4,9(a2)
    80007bee:	00a55703          	lhu	a4,10(a0)
    80007bf2:	0087169b          	slliw	a3,a4,0x8
    80007bf6:	8321                	srli	a4,a4,0x8
    80007bf8:	8f55                	or	a4,a4,a3
  pkt->hdr.csum = ntohs(*(uint16 *)(buf + 10));
    80007bfa:	00e61523          	sh	a4,10(a2)
  pkt->hdr.src_ip = ntohl(*(uint32 *)(buf + 12));
    80007bfe:	4554                	lw	a3,12(a0)
}

static inline uint32
ntohl(uint32 netlong) {
  return ((netlong & 0x000000FFU) << 24) |
    80007c00:	0186971b          	slliw	a4,a3,0x18
    ((netlong & 0x0000FF00U) << 8)  |
    ((netlong & 0x00FF0000U) >> 8)  |
    ((netlong & 0xFF000000U) >> 24);
    80007c04:	0186d61b          	srliw	a2,a3,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80007c08:	8f51                	or	a4,a4,a2
    ((netlong & 0x0000FF00U) << 8)  |
    80007c0a:	0086961b          	slliw	a2,a3,0x8
    80007c0e:	00ff08b7          	lui	a7,0xff0
    80007c12:	01167633          	and	a2,a2,a7
    ((netlong & 0x00FF0000U) >> 8)  |
    80007c16:	8f51                	or	a4,a4,a2
    80007c18:	0086d69b          	srliw	a3,a3,0x8
    80007c1c:	6841                	lui	a6,0x10
    80007c1e:	f0080813          	addi	a6,a6,-256 # ff00 <_entry-0x7fff0100>
    80007c22:	0106f6b3          	and	a3,a3,a6
    80007c26:	8f55                	or	a4,a4,a3
    80007c28:	00e79623          	sh	a4,12(a5)
    80007c2c:	0107571b          	srliw	a4,a4,0x10
    80007c30:	00e79723          	sh	a4,14(a5)
  pkt->hdr.dst_ip = ntohl(*(uint32 *)(buf + 16));
    80007c34:	4914                	lw	a3,16(a0)
  return ((netlong & 0x000000FFU) << 24) |
    80007c36:	0186971b          	slliw	a4,a3,0x18
    ((netlong & 0xFF000000U) >> 24);
    80007c3a:	0186d61b          	srliw	a2,a3,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80007c3e:	8f51                	or	a4,a4,a2
    ((netlong & 0x0000FF00U) << 8)  |
    80007c40:	0086961b          	slliw	a2,a3,0x8
    80007c44:	01167633          	and	a2,a2,a7
    ((netlong & 0x00FF0000U) >> 8)  |
    80007c48:	8f51                	or	a4,a4,a2
    80007c4a:	0086d69b          	srliw	a3,a3,0x8
    80007c4e:	0106f6b3          	and	a3,a3,a6
    80007c52:	8f55                	or	a4,a4,a3
    80007c54:	00e79823          	sh	a4,16(a5)
    80007c58:	0107571b          	srliw	a4,a4,0x10
    80007c5c:	00e79923          	sh	a4,18(a5)
  
  pkt->hdr.ver_ihl = buf[0];
    80007c60:	00054303          	lbu	t1,0(a0)
    80007c64:	00678023          	sb	t1,0(a5)
  pkt->hdr.tos = buf[1];
    80007c68:	00154703          	lbu	a4,1(a0)
    80007c6c:	00e780a3          	sb	a4,1(a5)
  return (netshort >> 8) | (netshort << 8);
    80007c70:	00255703          	lhu	a4,2(a0)
    80007c74:	0087169b          	slliw	a3,a4,0x8
    80007c78:	8321                	srli	a4,a4,0x8
    80007c7a:	8f55                	or	a4,a4,a3
    80007c7c:	1742                	slli	a4,a4,0x30
    80007c7e:	9341                	srli	a4,a4,0x30
  pkt->hdr.total_len = ntohs(*(uint16 *)(buf + 2));
    80007c80:	00e79123          	sh	a4,2(a5)
    80007c84:	00455683          	lhu	a3,4(a0)
    80007c88:	0086961b          	slliw	a2,a3,0x8
    80007c8c:	82a1                	srli	a3,a3,0x8
    80007c8e:	8ed1                	or	a3,a3,a2
  pkt->hdr.identification = ntohs(*(uint16 *)(buf + 4));
    80007c90:	00d79223          	sh	a3,4(a5)
    80007c94:	00655683          	lhu	a3,6(a0)
    80007c98:	0086961b          	slliw	a2,a3,0x8
    80007c9c:	82a1                	srli	a3,a3,0x8
    80007c9e:	8ed1                	or	a3,a3,a2
  pkt->hdr.fragment_info = ntohs(*(uint16 *)(buf + 6));
    80007ca0:	00d79323          	sh	a3,6(a5)
  pkt->hdr.ttl = buf[8];
    80007ca4:	00854683          	lbu	a3,8(a0)
    80007ca8:	00d78423          	sb	a3,8(a5)
  pkt->hdr.protocol = buf[9];
    80007cac:	00954683          	lbu	a3,9(a0)
    80007cb0:	00d784a3          	sb	a3,9(a5)
    80007cb4:	00a55683          	lhu	a3,10(a0)
    80007cb8:	0086961b          	slliw	a2,a3,0x8
    80007cbc:	82a1                	srli	a3,a3,0x8
    80007cbe:	8ed1                	or	a3,a3,a2
  pkt->hdr.csum = ntohs(*(uint16 *)(buf + 10));
    80007cc0:	00d79523          	sh	a3,10(a5)
  pkt->hdr.src_ip = ntohl(*(uint32 *)(buf + 12));
    80007cc4:	4550                	lw	a2,12(a0)
  return ((netlong & 0x000000FFU) << 24) |
    80007cc6:	0186169b          	slliw	a3,a2,0x18
    ((netlong & 0xFF000000U) >> 24);
    80007cca:	01865e1b          	srliw	t3,a2,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80007cce:	01c6e6b3          	or	a3,a3,t3
    ((netlong & 0x0000FF00U) << 8)  |
    80007cd2:	00861e1b          	slliw	t3,a2,0x8
    80007cd6:	011e7e33          	and	t3,t3,a7
    ((netlong & 0x00FF0000U) >> 8)  |
    80007cda:	01c6e6b3          	or	a3,a3,t3
    80007cde:	0086561b          	srliw	a2,a2,0x8
    80007ce2:	01067633          	and	a2,a2,a6
    80007ce6:	8ed1                	or	a3,a3,a2
    80007ce8:	00d79623          	sh	a3,12(a5)
    80007cec:	0106d69b          	srliw	a3,a3,0x10
    80007cf0:	00d79723          	sh	a3,14(a5)
  pkt->hdr.dst_ip = ntohl(*(uint32 *)(buf + 16));
    80007cf4:	4910                	lw	a2,16(a0)
    ((netlong & 0xFF000000U) >> 24);
    80007cf6:	0186569b          	srliw	a3,a2,0x18
  return ((netlong & 0x000000FFU) << 24) |
    80007cfa:	01861e1b          	slliw	t3,a2,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80007cfe:	01c6e6b3          	or	a3,a3,t3
    ((netlong & 0x0000FF00U) << 8)  |
    80007d02:	00861e1b          	slliw	t3,a2,0x8
    80007d06:	011e78b3          	and	a7,t3,a7
    ((netlong & 0x00FF0000U) >> 8)  |
    80007d0a:	0116e6b3          	or	a3,a3,a7
    80007d0e:	0086561b          	srliw	a2,a2,0x8
    80007d12:	01067633          	and	a2,a2,a6
    80007d16:	8ed1                	or	a3,a3,a2
    80007d18:	00d79823          	sh	a3,16(a5)
    80007d1c:	0106d69b          	srliw	a3,a3,0x10
    80007d20:	00d79923          	sh	a3,18(a5)

  int hdr_len = (pkt->hdr.ver_ihl & 0x0F) * 4;
    80007d24:	00f37313          	andi	t1,t1,15
    80007d28:	0023131b          	slliw	t1,t1,0x2
    80007d2c:	0003069b          	sext.w	a3,t1
  if (hdr_len < 20 || hdr_len > len) return -1;
    80007d30:	464d                	li	a2,19
    80007d32:	02d65e63          	bge	a2,a3,80007d6e <parse_ip4_packet+0x1d2>
    80007d36:	02d5ce63          	blt	a1,a3,80007d72 <parse_ip4_packet+0x1d6>
  // printf("\tvalid packet\n");
  if (pkt->hdr.total_len > len) return -1;
    80007d3a:	2701                	sext.w	a4,a4
    80007d3c:	02e5cd63          	blt	a1,a4,80007d76 <parse_ip4_packet+0x1da>
{
    80007d40:	1141                	addi	sp,sp,-16
    80007d42:	e406                	sd	ra,8(sp)
    80007d44:	e022                	sd	s0,0(sp)
    80007d46:	0800                	addi	s0,sp,16

  pkt->payload_len = len - hdr_len;
    80007d48:	4065863b          	subw	a2,a1,t1
    80007d4c:	1642                	slli	a2,a2,0x30
    80007d4e:	9241                	srli	a2,a2,0x30
    80007d50:	5ec79823          	sh	a2,1520(a5)
  memmove(pkt->payload, buf + hdr_len, pkt->payload_len);
    80007d54:	00d505b3          	add	a1,a0,a3
    80007d58:	01478513          	addi	a0,a5,20
    80007d5c:	ffff9097          	auipc	ra,0xffff9
    80007d60:	10c080e7          	jalr	268(ra) # 80000e68 <memmove>

  return 0;
    80007d64:	4501                	li	a0,0
}
    80007d66:	60a2                	ld	ra,8(sp)
    80007d68:	6402                	ld	s0,0(sp)
    80007d6a:	0141                	addi	sp,sp,16
    80007d6c:	8082                	ret
  if (hdr_len < 20 || hdr_len > len) return -1;
    80007d6e:	557d                	li	a0,-1
    80007d70:	8082                	ret
    80007d72:	557d                	li	a0,-1
    80007d74:	8082                	ret
  if (pkt->hdr.total_len > len) return -1;
    80007d76:	557d                	li	a0,-1
}
    80007d78:	8082                	ret

0000000080007d7a <build_ip4>:


void
build_ip4(struct ip4_frame *ip, uint32 src, uint32 dst, uint8 proto, uint16 len)
{
    80007d7a:	1101                	addi	sp,sp,-32
    80007d7c:	ec06                	sd	ra,24(sp)
    80007d7e:	e822                	sd	s0,16(sp)
    80007d80:	e426                	sd	s1,8(sp)
    80007d82:	1000                	addi	s0,sp,32
    80007d84:	84aa                	mv	s1,a0
  ip->hdr.ver_ihl = (4 << 4) | (5);  // v4 + IHL=5 (20 bytes)
    80007d86:	04500793          	li	a5,69
    80007d8a:	00f50023          	sb	a5,0(a0)
  ip->hdr.tos = 0;
    80007d8e:	000500a3          	sb	zero,1(a0)
  return (hostshort >> 8) | (hostshort << 8);
    80007d92:	0087179b          	slliw	a5,a4,0x8
    80007d96:	0087571b          	srliw	a4,a4,0x8
    80007d9a:	8fd9                	or	a5,a5,a4
  ip->hdr.total_len = htons(len);
    80007d9c:	00f51123          	sh	a5,2(a0)
  ip->hdr.identification = htons(0);   // you can increment per packet
    80007da0:	00051223          	sh	zero,4(a0)
  ip->hdr.fragment_info = htons(0);
    80007da4:	00051323          	sh	zero,6(a0)
  ip->hdr.ttl = 64;
    80007da8:	04000793          	li	a5,64
    80007dac:	00f50423          	sb	a5,8(a0)
  ip->hdr.protocol = proto;
    80007db0:	00d504a3          	sb	a3,9(a0)
}

static inline uint32 
htonl(uint32 hostlong) {
    return ((hostlong & 0x000000FFU) << 24) |
    80007db4:	0185979b          	slliw	a5,a1,0x18
           ((hostlong & 0x0000FF00U) << 8)  |
           ((hostlong & 0x00FF0000U) >> 8)  |
           ((hostlong & 0xFF000000U) >> 24);
    80007db8:	0185d71b          	srliw	a4,a1,0x18
           ((hostlong & 0x00FF0000U) >> 8)  |
    80007dbc:	8fd9                	or	a5,a5,a4
           ((hostlong & 0x0000FF00U) << 8)  |
    80007dbe:	0085971b          	slliw	a4,a1,0x8
    80007dc2:	00ff0837          	lui	a6,0xff0
    80007dc6:	01077733          	and	a4,a4,a6
           ((hostlong & 0x00FF0000U) >> 8)  |
    80007dca:	8fd9                	or	a5,a5,a4
    80007dcc:	0085d59b          	srliw	a1,a1,0x8
    80007dd0:	6741                	lui	a4,0x10
    80007dd2:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80007dd6:	8df9                	and	a1,a1,a4
    80007dd8:	8fcd                	or	a5,a5,a1
  ip->hdr.src_ip = htonl(src);
    80007dda:	00f51623          	sh	a5,12(a0)
    80007dde:	0107d79b          	srliw	a5,a5,0x10
    80007de2:	00f51723          	sh	a5,14(a0)
    return ((hostlong & 0x000000FFU) << 24) |
    80007de6:	0186179b          	slliw	a5,a2,0x18
           ((hostlong & 0xFF000000U) >> 24);
    80007dea:	0186569b          	srliw	a3,a2,0x18
           ((hostlong & 0x00FF0000U) >> 8)  |
    80007dee:	8fd5                	or	a5,a5,a3
           ((hostlong & 0x0000FF00U) << 8)  |
    80007df0:	0086169b          	slliw	a3,a2,0x8
    80007df4:	0106f6b3          	and	a3,a3,a6
           ((hostlong & 0x00FF0000U) >> 8)  |
    80007df8:	8fd5                	or	a5,a5,a3
    80007dfa:	0086561b          	srliw	a2,a2,0x8
    80007dfe:	8e79                	and	a2,a2,a4
    80007e00:	8e5d                	or	a2,a2,a5
  ip->hdr.dst_ip = htonl(dst);
    80007e02:	00c51823          	sh	a2,16(a0)
    80007e06:	0106561b          	srliw	a2,a2,0x10
    80007e0a:	00c51923          	sh	a2,18(a0)
  ip->hdr.csum = 0;
    80007e0e:	00051523          	sh	zero,10(a0)
  ip->hdr.csum = chksum((uint16*)ip, sizeof(struct ip4_hdr));
    80007e12:	45d1                	li	a1,20
    80007e14:	00000097          	auipc	ra,0x0
    80007e18:	398080e7          	jalr	920(ra) # 800081ac <chksum>
    80007e1c:	00a49523          	sh	a0,10(s1)
}
    80007e20:	60e2                	ld	ra,24(sp)
    80007e22:	6442                	ld	s0,16(sp)
    80007e24:	64a2                	ld	s1,8(sp)
    80007e26:	6105                	addi	sp,sp,32
    80007e28:	8082                	ret

0000000080007e2a <handle_ip4_packet>:

int 
handle_ip4_packet(struct ip4_frame *ip4_pkt) 
{
    80007e2a:	1101                	addi	sp,sp,-32
    80007e2c:	ec06                	sd	ra,24(sp)
    80007e2e:	e822                	sd	s0,16(sp)
    80007e30:	e426                	sd	s1,8(sp)
    80007e32:	1000                	addi	s0,sp,32
    80007e34:	84aa                	mv	s1,a0
  switch(ip4_pkt->hdr.protocol) {
    80007e36:	00954583          	lbu	a1,9(a0)
    80007e3a:	4799                	li	a5,6
    80007e3c:	02f58363          	beq	a1,a5,80007e62 <handle_ip4_packet+0x38>
    80007e40:	47c5                	li	a5,17
    80007e42:	04f58f63          	beq	a1,a5,80007ea0 <handle_ip4_packet+0x76>
      if (parse_udp_packet(ip4_pkt->payload, ip4_pkt->payload_len, udp) == 0) {
        handle_udp_packet(udp);
      }
      break;
    default:
      printf("unsupported ip protocol: %d\n", ip4_pkt->hdr.protocol);
    80007e46:	00004517          	auipc	a0,0x4
    80007e4a:	b5a50513          	addi	a0,a0,-1190 # 8000b9a0 <etext+0x9a0>
    80007e4e:	ffff8097          	auipc	ra,0xffff8
    80007e52:	75c080e7          	jalr	1884(ra) # 800005aa <printf>
      break;
  }
  return 0;
}
    80007e56:	4501                	li	a0,0
    80007e58:	60e2                	ld	ra,24(sp)
    80007e5a:	6442                	ld	s0,16(sp)
    80007e5c:	64a2                	ld	s1,8(sp)
    80007e5e:	6105                	addi	sp,sp,32
    80007e60:	8082                	ret
    80007e62:	e04a                	sd	s2,0(sp)
      struct tcp_frame *tcp = kalloc();
    80007e64:	ffff9097          	auipc	ra,0xffff9
    80007e68:	d9e080e7          	jalr	-610(ra) # 80000c02 <kalloc>
    80007e6c:	892a                	mv	s2,a0
      memset(tcp, 0, PGSIZE);
    80007e6e:	6605                	lui	a2,0x1
    80007e70:	4581                	li	a1,0
    80007e72:	ffff9097          	auipc	ra,0xffff9
    80007e76:	f9a080e7          	jalr	-102(ra) # 80000e0c <memset>
      if (parse_tcp_packet(ip4_pkt->payload, ip4_pkt->payload_len, tcp) == 0) {
    80007e7a:	864a                	mv	a2,s2
    80007e7c:	5f04d583          	lhu	a1,1520(s1)
    80007e80:	01448513          	addi	a0,s1,20
    80007e84:	00001097          	auipc	ra,0x1
    80007e88:	038080e7          	jalr	56(ra) # 80008ebc <parse_tcp_packet>
    80007e8c:	c119                	beqz	a0,80007e92 <handle_ip4_packet+0x68>
    80007e8e:	6902                	ld	s2,0(sp)
    80007e90:	b7d9                	j	80007e56 <handle_ip4_packet+0x2c>
        handle_tcp_packet(tcp);
    80007e92:	854a                	mv	a0,s2
    80007e94:	00001097          	auipc	ra,0x1
    80007e98:	2c6080e7          	jalr	710(ra) # 8000915a <handle_tcp_packet>
    80007e9c:	6902                	ld	s2,0(sp)
    80007e9e:	bf65                	j	80007e56 <handle_ip4_packet+0x2c>
    80007ea0:	e04a                	sd	s2,0(sp)
      struct udp_frame *udp = kalloc();
    80007ea2:	ffff9097          	auipc	ra,0xffff9
    80007ea6:	d60080e7          	jalr	-672(ra) # 80000c02 <kalloc>
    80007eaa:	892a                	mv	s2,a0
      memset(udp, 0, PGSIZE);
    80007eac:	6605                	lui	a2,0x1
    80007eae:	4581                	li	a1,0
    80007eb0:	ffff9097          	auipc	ra,0xffff9
    80007eb4:	f5c080e7          	jalr	-164(ra) # 80000e0c <memset>
      if (parse_udp_packet(ip4_pkt->payload, ip4_pkt->payload_len, udp) == 0) {
    80007eb8:	864a                	mv	a2,s2
    80007eba:	5f04d583          	lhu	a1,1520(s1)
    80007ebe:	01448513          	addi	a0,s1,20
    80007ec2:	00002097          	auipc	ra,0x2
    80007ec6:	99e080e7          	jalr	-1634(ra) # 80009860 <parse_udp_packet>
    80007eca:	c119                	beqz	a0,80007ed0 <handle_ip4_packet+0xa6>
    80007ecc:	6902                	ld	s2,0(sp)
    80007ece:	b761                	j	80007e56 <handle_ip4_packet+0x2c>
        handle_udp_packet(udp);
    80007ed0:	854a                	mv	a0,s2
    80007ed2:	00002097          	auipc	ra,0x2
    80007ed6:	8ea080e7          	jalr	-1814(ra) # 800097bc <handle_udp_packet>
    80007eda:	6902                	ld	s2,0(sp)
    80007edc:	bfad                	j	80007e56 <handle_ip4_packet+0x2c>

0000000080007ede <my_strlen>:
  .ip_addr = temp_ip,
  .gateway = 0,
  .subnet_mask = 0,
};

int my_strlen(char *string) {
    80007ede:	1141                	addi	sp,sp,-16
    80007ee0:	e422                	sd	s0,8(sp)
    80007ee2:	0800                	addi	s0,sp,16
  for (int i = 0; ; i++) {
    if (string[i] == '\0')
    80007ee4:	00054703          	lbu	a4,0(a0)
    80007ee8:	0505                	addi	a0,a0,1
    80007eea:	87aa                	mv	a5,a0
    80007eec:	cf01                	beqz	a4,80007f04 <my_strlen+0x26>
    80007eee:	86be                	mv	a3,a5
    80007ef0:	0785                	addi	a5,a5,1
    80007ef2:	fff7c703          	lbu	a4,-1(a5)
    80007ef6:	ff65                	bnez	a4,80007eee <my_strlen+0x10>
  for (int i = 0; ; i++) {
    80007ef8:	40a6853b          	subw	a0,a3,a0
    80007efc:	2505                	addiw	a0,a0,1
      return i;
  }
}
    80007efe:	6422                	ld	s0,8(sp)
    80007f00:	0141                	addi	sp,sp,16
    80007f02:	8082                	ret
  for (int i = 0; ; i++) {
    80007f04:	4501                	li	a0,0
    80007f06:	bfe5                	j	80007efe <my_strlen+0x20>

0000000080007f08 <getaddrinfo>:

int 
getaddrinfo(char *node, char *port, const struct addrinfo *hints,
                struct addrinfo *result)
{
    80007f08:	1141                	addi	sp,sp,-16
    80007f0a:	e422                	sd	s0,8(sp)
    80007f0c:	0800                	addi	s0,sp,16
  return 0;
}
    80007f0e:	4501                	li	a0,0
    80007f10:	6422                	ld	s0,8(sp)
    80007f12:	0141                	addi	sp,sp,16
    80007f14:	8082                	ret

0000000080007f16 <freeaddrinfo>:

int 
freeaddrinfo(struct addrinfo *res)
{
    80007f16:	1141                	addi	sp,sp,-16
    80007f18:	e422                	sd	s0,8(sp)
    80007f1a:	0800                	addi	s0,sp,16
  return 0;
}
    80007f1c:	4501                	li	a0,0
    80007f1e:	6422                	ld	s0,8(sp)
    80007f20:	0141                	addi	sp,sp,16
    80007f22:	8082                	ret

0000000080007f24 <ip_to_u32>:

int ip_to_u32(const char *ip) {
    80007f24:	1101                	addi	sp,sp,-32
    80007f26:	ec22                	sd	s0,24(sp)
    80007f28:	1000                	addi	s0,sp,32
  int parts[4] = {0};
    80007f2a:	fe043023          	sd	zero,-32(s0)
    80007f2e:	fe043423          	sd	zero,-24(s0)
  int i = 0;

  // Parse the dotted decimal parts
  while (*ip && i < 4) {
    80007f32:	00054783          	lbu	a5,0(a0)
    80007f36:	c7d5                	beqz	a5,80007fe2 <ip_to_u32+0xbe>
    80007f38:	fe040893          	addi	a7,s0,-32
  int i = 0;
    80007f3c:	4801                	li	a6,0
    int num = 0;
    while (*ip >= '0' && *ip <= '9') {
    80007f3e:	45a5                	li	a1,9
    int num = 0;
    80007f40:	4301                	li	t1,0
      num = num * 10 + (*ip - '0');
      ip++;
    }
    if (num < 0 || num > 255)
    80007f42:	0ff00e93          	li	t4,255
      return 0xFFFFFFFF;  // invalid
    parts[i++] = num;

    if (*ip == '.')
    80007f46:	02e00e13          	li	t3,46
  while (*ip && i < 4) {
    80007f4a:	4f11                	li	t5,4
    80007f4c:	a801                	j	80007f5c <ip_to_u32+0x38>
      ip++;
    80007f4e:	0505                	addi	a0,a0,1
  while (*ip && i < 4) {
    80007f50:	00054783          	lbu	a5,0(a0)
    80007f54:	c3d1                	beqz	a5,80007fd8 <ip_to_u32+0xb4>
    80007f56:	0891                	addi	a7,a7,4 # ff0004 <_entry-0x7f00fffc>
    80007f58:	05e80963          	beq	a6,t5,80007faa <ip_to_u32+0x86>
    while (*ip >= '0' && *ip <= '9') {
    80007f5c:	00054703          	lbu	a4,0(a0)
    80007f60:	fd07079b          	addiw	a5,a4,-48
    80007f64:	0ff7f793          	zext.b	a5,a5
    int num = 0;
    80007f68:	861a                	mv	a2,t1
    while (*ip >= '0' && *ip <= '9') {
    80007f6a:	06f5e563          	bltu	a1,a5,80007fd4 <ip_to_u32+0xb0>
      num = num * 10 + (*ip - '0');
    80007f6e:	0026179b          	slliw	a5,a2,0x2
    80007f72:	9fb1                	addw	a5,a5,a2
    80007f74:	0017979b          	slliw	a5,a5,0x1
    80007f78:	fd07071b          	addiw	a4,a4,-48
    80007f7c:	9fb9                	addw	a5,a5,a4
    80007f7e:	0007861b          	sext.w	a2,a5
      ip++;
    80007f82:	0505                	addi	a0,a0,1
    while (*ip >= '0' && *ip <= '9') {
    80007f84:	00054703          	lbu	a4,0(a0)
    80007f88:	fd07069b          	addiw	a3,a4,-48
    80007f8c:	0ff6f693          	zext.b	a3,a3
    80007f90:	fcd5ffe3          	bgeu	a1,a3,80007f6e <ip_to_u32+0x4a>
    if (num < 0 || num > 255)
    80007f94:	04cee963          	bltu	t4,a2,80007fe6 <ip_to_u32+0xc2>
    parts[i++] = num;
    80007f98:	2805                	addiw	a6,a6,1 # ff0001 <_entry-0x7f00ffff>
    80007f9a:	00c8a023          	sw	a2,0(a7)
    if (*ip == '.')
    80007f9e:	fbc708e3          	beq	a4,t3,80007f4e <ip_to_u32+0x2a>
    else if (*ip && i < 4)
    80007fa2:	d75d                	beqz	a4,80007f50 <ip_to_u32+0x2c>
    80007fa4:	478d                	li	a5,3
    80007fa6:	0507d263          	bge	a5,a6,80007fea <ip_to_u32+0xc6>

  if (i != 4)
    return 0xFFFFFFFF;

  // Convert to big-endian 32-bit representation
  return (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | (parts[3]);
    80007faa:	fe042503          	lw	a0,-32(s0)
    80007fae:	0185151b          	slliw	a0,a0,0x18
    80007fb2:	fe442783          	lw	a5,-28(s0)
    80007fb6:	0107979b          	slliw	a5,a5,0x10
    80007fba:	8d5d                	or	a0,a0,a5
    80007fbc:	fec42783          	lw	a5,-20(s0)
    80007fc0:	8d5d                	or	a0,a0,a5
    80007fc2:	fe842783          	lw	a5,-24(s0)
    80007fc6:	0087979b          	slliw	a5,a5,0x8
    80007fca:	8d5d                	or	a0,a0,a5
    80007fcc:	2501                	sext.w	a0,a0
}
    80007fce:	6462                	ld	s0,24(sp)
    80007fd0:	6105                	addi	sp,sp,32
    80007fd2:	8082                	ret
    int num = 0;
    80007fd4:	4601                	li	a2,0
    80007fd6:	b7c9                	j	80007f98 <ip_to_u32+0x74>
  if (i != 4)
    80007fd8:	4791                	li	a5,4
    80007fda:	fcf808e3          	beq	a6,a5,80007faa <ip_to_u32+0x86>
    return 0xFFFFFFFF;
    80007fde:	557d                	li	a0,-1
    80007fe0:	b7fd                	j	80007fce <ip_to_u32+0xaa>
    80007fe2:	557d                	li	a0,-1
    80007fe4:	b7ed                	j	80007fce <ip_to_u32+0xaa>
      return 0xFFFFFFFF;  // invalid
    80007fe6:	557d                	li	a0,-1
    80007fe8:	b7dd                	j	80007fce <ip_to_u32+0xaa>
      return 0xFFFFFFFF;  // invalid format
    80007fea:	557d                	li	a0,-1
    80007fec:	b7cd                	j	80007fce <ip_to_u32+0xaa>

0000000080007fee <node_to_dns>:

int
node_to_dns(char *name, char *res)
{
    80007fee:	1101                	addi	sp,sp,-32
    80007ff0:	ec06                	sd	ra,24(sp)
    80007ff2:	e822                	sd	s0,16(sp)
    80007ff4:	e426                	sd	s1,8(sp)
    80007ff6:	e04a                	sd	s2,0(sp)
    80007ff8:	1000                	addi	s0,sp,32
    80007ffa:	892a                	mv	s2,a0
    80007ffc:	84ae                	mv	s1,a1
  int name_len = my_strlen(name);
    80007ffe:	00000097          	auipc	ra,0x0
    80008002:	ee0080e7          	jalr	-288(ra) # 80007ede <my_strlen>
  if (name_len > 253)
    80008006:	0fd00793          	li	a5,253
    8000800a:	06a7c363          	blt	a5,a0,80008070 <node_to_dns+0x82>
    return LONG_DOMAIN;

  int len_index = 0;
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    8000800e:	4785                	li	a5,1
  int len_index = 0;
    80008010:	4601                	li	a2,0
    if (i - len_index == 64)
      return LONG_DOMAIN_SECTION;

    if (name[i] == '.' || name[i] == '\0') {
    80008012:	02e00813          	li	a6,46
    if (i - len_index == 64)
    80008016:	04000893          	li	a7,64
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    8000801a:	02055463          	bgez	a0,80008042 <node_to_dns+0x54>
      len_index = res_index;
    } else {
      res[res_index] = name[i];
    }
  }
  res[name_len + 1] = 0;
    8000801e:	94aa                	add	s1,s1,a0
    80008020:	000480a3          	sb	zero,1(s1)
  return 0;
    80008024:	4501                	li	a0,0
    80008026:	a0b1                	j	80008072 <node_to_dns+0x84>
      res[len_index] = i - len_index;
    80008028:	00c485b3          	add	a1,s1,a2
    8000802c:	fff7871b          	addiw	a4,a5,-1
    80008030:	9f11                	subw	a4,a4,a2
    80008032:	00e58023          	sb	a4,0(a1)
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    80008036:	0007871b          	sext.w	a4,a5
    8000803a:	fee542e3          	blt	a0,a4,8000801e <node_to_dns+0x30>
    if (i - len_index == 64)
    8000803e:	0785                	addi	a5,a5,1
      len_index = res_index;
    80008040:	8636                	mv	a2,a3
    80008042:	0007869b          	sext.w	a3,a5
    if (name[i] == '.' || name[i] == '\0') {
    80008046:	00f90733          	add	a4,s2,a5
    8000804a:	fff74703          	lbu	a4,-1(a4)
    8000804e:	fd070de3          	beq	a4,a6,80008028 <node_to_dns+0x3a>
    80008052:	db79                	beqz	a4,80008028 <node_to_dns+0x3a>
      res[res_index] = name[i];
    80008054:	00f485b3          	add	a1,s1,a5
    80008058:	00e58023          	sb	a4,0(a1)
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    8000805c:	0007871b          	sext.w	a4,a5
    80008060:	fae54fe3          	blt	a0,a4,8000801e <node_to_dns+0x30>
    if (i - len_index == 64)
    80008064:	0785                	addi	a5,a5,1
    80008066:	9e91                	subw	a3,a3,a2
    80008068:	fd169de3          	bne	a3,a7,80008042 <node_to_dns+0x54>
      return LONG_DOMAIN_SECTION;
    8000806c:	4509                	li	a0,2
    8000806e:	a011                	j	80008072 <node_to_dns+0x84>
    return LONG_DOMAIN;
    80008070:	4505                	li	a0,1
}
    80008072:	60e2                	ld	ra,24(sp)
    80008074:	6442                	ld	s0,16(sp)
    80008076:	64a2                	ld	s1,8(sp)
    80008078:	6902                	ld	s2,0(sp)
    8000807a:	6105                	addi	sp,sp,32
    8000807c:	8082                	ret

000000008000807e <net_init>:

int net_init() {
    8000807e:	1141                	addi	sp,sp,-16
    80008080:	e406                	sd	ra,8(sp)
    80008082:	e022                	sd	s0,0(sp)
    80008084:	0800                	addi	s0,sp,16
  for (int i = 0; i < 6; i++) {
    80008086:	00066797          	auipc	a5,0x66
    8000808a:	29a78793          	addi	a5,a5,666 # 8006e320 <net>
    8000808e:	00005717          	auipc	a4,0x5
    80008092:	81e70713          	addi	a4,a4,-2018 # 8000c8ac <netconf+0x4>
    80008096:	00066617          	auipc	a2,0x66
    8000809a:	29060613          	addi	a2,a2,656 # 8006e326 <net+0x6>
    netconf.mac_addr[i] = net.cfg.mac[i];
    8000809e:	0007c683          	lbu	a3,0(a5)
    800080a2:	00d70023          	sb	a3,0(a4)
  for (int i = 0; i < 6; i++) {
    800080a6:	0785                	addi	a5,a5,1
    800080a8:	0705                	addi	a4,a4,1
    800080aa:	fec79ae3          	bne	a5,a2,8000809e <net_init+0x20>
  }
  arp_insert(temp_ip, netconf.mac_addr);
    800080ae:	00004597          	auipc	a1,0x4
    800080b2:	7fe58593          	addi	a1,a1,2046 # 8000c8ac <netconf+0x4>
    800080b6:	0a001537          	lui	a0,0xa001
    800080ba:	a0a50513          	addi	a0,a0,-1526 # a000a0a <_entry-0x75fff5f6>
    800080be:	00002097          	auipc	ra,0x2
    800080c2:	88e080e7          	jalr	-1906(ra) # 8000994c <arp_insert>
  return 0;
}
    800080c6:	4501                	li	a0,0
    800080c8:	60a2                	ld	ra,8(sp)
    800080ca:	6402                	ld	s0,0(sp)
    800080cc:	0141                	addi	sp,sp,16
    800080ce:	8082                	ret

00000000800080d0 <udp_checksum>:
// Computes the UDP checksum per RFC 768.
// src_ip and dst_ip must be in network byte order.
// udp_hdr and payload must already be populated; udp_hdr->csum must be 0.
uint16
udp_checksum(uint32 src_ip, uint32 dst_ip, struct udp_hdr *hdr, uint8 *payload, uint16 payload_len)
{
    800080d0:	715d                	addi	sp,sp,-80
    800080d2:	e486                	sd	ra,72(sp)
    800080d4:	e0a2                	sd	s0,64(sp)
    800080d6:	fc26                	sd	s1,56(sp)
    800080d8:	f84a                	sd	s2,48(sp)
    800080da:	f44e                	sd	s3,40(sp)
    800080dc:	0880                	addi	s0,sp,80
    800080de:	87ae                	mv	a5,a1
    800080e0:	85b2                	mv	a1,a2
    800080e2:	84b6                	mv	s1,a3
    800080e4:	893a                	mv	s2,a4
    uint8  zero;
    uint8  protocol;
    uint16 udp_len;
  } pseudo;

  pseudo.src_ip   = src_ip;
    800080e6:	fca42023          	sw	a0,-64(s0)
  pseudo.dst_ip   = dst_ip;
    800080ea:	fcf42223          	sw	a5,-60(s0)
  pseudo.zero     = 0;
    800080ee:	fc040423          	sb	zero,-56(s0)
  pseudo.protocol = IPPROTO_UDP; // IPPROTO_UDP
    800080f2:	47c5                	li	a5,17
    800080f4:	fcf404a3          	sb	a5,-55(s0)
  pseudo.udp_len  = hdr->len; // already in network byte order
    800080f8:	00464703          	lbu	a4,4(a2)
    800080fc:	00564783          	lbu	a5,5(a2)
    80008100:	07a2                	slli	a5,a5,0x8
    80008102:	8fd9                	or	a5,a5,a4
    80008104:	fcf41523          	sh	a5,-54(s0)

  unsigned long cksum = 0;

  // Sum the pseudo-header
  uint16 *p = (uint16 *)&pseudo;
  for (int i = 0; i < (int)sizeof(pseudo) / 2; i++)
    80008108:	fc040793          	addi	a5,s0,-64
    8000810c:	fcc40693          	addi	a3,s0,-52
  unsigned long cksum = 0;
    80008110:	4981                	li	s3,0
    cksum += p[i];
    80008112:	0007d703          	lhu	a4,0(a5)
    80008116:	99ba                	add	s3,s3,a4
  for (int i = 0; i < (int)sizeof(pseudo) / 2; i++)
    80008118:	0789                	addi	a5,a5,2
    8000811a:	fef69ce3          	bne	a3,a5,80008112 <udp_checksum+0x42>

  // Sum the UDP header (with csum field set to 0).
  // Copy into an aligned buffer first to avoid unaligned access on packed struct.
  uint8 hdr_buf[sizeof(struct udp_hdr)];
  memmove(hdr_buf, hdr, sizeof(struct udp_hdr));
    8000811e:	4621                	li	a2,8
    80008120:	fb840513          	addi	a0,s0,-72
    80008124:	ffff9097          	auipc	ra,0xffff9
    80008128:	d44080e7          	jalr	-700(ra) # 80000e68 <memmove>
  p = (uint16 *)hdr_buf;
  for (int i = 0; i < (int)sizeof(struct udp_hdr) / 2; i++)
    cksum += p[i];
    8000812c:	fb845783          	lhu	a5,-72(s0)
    80008130:	fba45703          	lhu	a4,-70(s0)
    80008134:	97ba                	add	a5,a5,a4
    80008136:	fbc45703          	lhu	a4,-68(s0)
    8000813a:	97ba                	add	a5,a5,a4
    8000813c:	fbe45703          	lhu	a4,-66(s0)
    80008140:	97ba                	add	a5,a5,a4
    80008142:	97ce                	add	a5,a5,s3

  // Sum the payload
  p = (uint16 *)payload;
  uint16 len = payload_len;
  while (len > 1) {
    80008144:	0009071b          	sext.w	a4,s2
    80008148:	4685                	li	a3,1
    8000814a:	04e6ff63          	bgeu	a3,a4,800081a8 <udp_checksum+0xd8>
    8000814e:	ffe9069b          	addiw	a3,s2,-2
    80008152:	0106969b          	slliw	a3,a3,0x10
    80008156:	0106d69b          	srliw	a3,a3,0x10
    8000815a:	0016d69b          	srliw	a3,a3,0x1
    8000815e:	2685                	addiw	a3,a3,1
    80008160:	16c2                	slli	a3,a3,0x30
    80008162:	92c1                	srli	a3,a3,0x30
    80008164:	0686                	slli	a3,a3,0x1
    80008166:	96a6                	add	a3,a3,s1
    cksum += *p++;
    80008168:	0489                	addi	s1,s1,2
    8000816a:	ffe4d703          	lhu	a4,-2(s1)
    8000816e:	97ba                	add	a5,a5,a4
  while (len > 1) {
    80008170:	fed49ce3          	bne	s1,a3,80008168 <udp_checksum+0x98>
    80008174:	00197913          	andi	s2,s2,1
    len -= 2;
  }
  if (len)
    80008178:	00090563          	beqz	s2,80008182 <udp_checksum+0xb2>
    cksum += *(uint8 *)p;
    8000817c:	0006c703          	lbu	a4,0(a3)
    80008180:	97ba                	add	a5,a5,a4

  // Fold 32-bit sum into 16 bits
  cksum = (cksum >> 16) + (cksum & 0xffff);
    80008182:	0107d713          	srli	a4,a5,0x10
    80008186:	17c2                	slli	a5,a5,0x30
    80008188:	93c1                	srli	a5,a5,0x30
    8000818a:	97ba                	add	a5,a5,a4
  cksum += (cksum >> 16);
    8000818c:	0107d513          	srli	a0,a5,0x10
    80008190:	953e                	add	a0,a0,a5
  return (uint16)(~cksum);
    80008192:	fff54513          	not	a0,a0
}
    80008196:	1542                	slli	a0,a0,0x30
    80008198:	9141                	srli	a0,a0,0x30
    8000819a:	60a6                	ld	ra,72(sp)
    8000819c:	6406                	ld	s0,64(sp)
    8000819e:	74e2                	ld	s1,56(sp)
    800081a0:	7942                	ld	s2,48(sp)
    800081a2:	79a2                	ld	s3,40(sp)
    800081a4:	6161                	addi	sp,sp,80
    800081a6:	8082                	ret
  p = (uint16 *)payload;
    800081a8:	86a6                	mv	a3,s1
    800081aa:	b7f9                	j	80008178 <udp_checksum+0xa8>

00000000800081ac <chksum>:

int chksum(uint16 *hdr, uint32 len) {
    800081ac:	1141                	addi	sp,sp,-16
    800081ae:	e422                	sd	s0,8(sp)
    800081b0:	0800                	addi	s0,sp,16
  unsigned long cksum = 0;
  while(len > 1) {
    800081b2:	4785                	li	a5,1
    800081b4:	04b7f763          	bgeu	a5,a1,80008202 <chksum+0x56>
    800081b8:	ffe5871b          	addiw	a4,a1,-2
    800081bc:	0017571b          	srliw	a4,a4,0x1
    800081c0:	2705                	addiw	a4,a4,1
    800081c2:	02071793          	slli	a5,a4,0x20
    800081c6:	01f7d713          	srli	a4,a5,0x1f
    800081ca:	972a                	add	a4,a4,a0
  unsigned long cksum = 0;
    800081cc:	4781                	li	a5,0
    cksum += *hdr++;
    800081ce:	0509                	addi	a0,a0,2
    800081d0:	ffe55683          	lhu	a3,-2(a0)
    800081d4:	97b6                	add	a5,a5,a3
  while(len > 1) {
    800081d6:	fee51ce3          	bne	a0,a4,800081ce <chksum+0x22>
    800081da:	8985                	andi	a1,a1,1
    len -= sizeof(uint16);
  }

  if(len) {
    800081dc:	c581                	beqz	a1,800081e4 <chksum+0x38>
    cksum += *(uint8 *)hdr;
    800081de:	00074703          	lbu	a4,0(a4)
    800081e2:	97ba                	add	a5,a5,a4
  }

  cksum = (cksum >> 16) + (cksum & 0xffff);
    800081e4:	0107d713          	srli	a4,a5,0x10
    800081e8:	17c2                	slli	a5,a5,0x30
    800081ea:	93c1                	srli	a5,a5,0x30
    800081ec:	97ba                	add	a5,a5,a4
  cksum += (cksum >> 16);
    800081ee:	0107d513          	srli	a0,a5,0x10
    800081f2:	953e                	add	a0,a0,a5
  return (uint16)(~cksum);
    800081f4:	fff54513          	not	a0,a0
}
    800081f8:	1542                	slli	a0,a0,0x30
    800081fa:	9141                	srli	a0,a0,0x30
    800081fc:	6422                	ld	s0,8(sp)
    800081fe:	0141                	addi	sp,sp,16
    80008200:	8082                	ret
  while(len > 1) {
    80008202:	872a                	mv	a4,a0
  unsigned long cksum = 0;
    80008204:	4781                	li	a5,0
    80008206:	bfd9                	j	800081dc <chksum+0x30>

0000000080008208 <insert_port_binding>:
    80008208:	1141                	addi	sp,sp,-16
    8000820a:	e406                	sd	ra,8(sp)
    8000820c:	e022                	sd	s0,0(sp)
    8000820e:	0800                	addi	s0,sp,16
    80008210:	651c                	ld	a5,8(a0)
    80008212:	5b9c                	lw	a5,48(a5)
    80008214:	4719                	li	a4,6
    80008216:	00e78a63          	beq	a5,a4,8000822a <insert_port_binding+0x22>
    8000821a:	4745                	li	a4,17
    8000821c:	02e78163          	beq	a5,a4,8000823e <insert_port_binding+0x36>
    80008220:	4501                	li	a0,0
    80008222:	60a2                	ld	ra,8(sp)
    80008224:	6402                	ld	s0,0(sp)
    80008226:	0141                	addi	sp,sp,16
    80008228:	8082                	ret
    8000822a:	00255703          	lhu	a4,2(a0)
    8000822e:	070e                	slli	a4,a4,0x3
    80008230:	00066797          	auipc	a5,0x66
    80008234:	16878793          	addi	a5,a5,360 # 8006e398 <tcp_port_binds>
    80008238:	97ba                	add	a5,a5,a4
    8000823a:	e388                	sd	a0,0(a5)
    8000823c:	b7d5                	j	80008220 <insert_port_binding+0x18>
    8000823e:	00255703          	lhu	a4,2(a0)
    80008242:	070e                	slli	a4,a4,0x3
    80008244:	00067797          	auipc	a5,0x67
    80008248:	15478793          	addi	a5,a5,340 # 8006f398 <udp_port_binds>
    8000824c:	97ba                	add	a5,a5,a4
    8000824e:	e388                	sd	a0,0(a5)
    80008250:	bfc1                	j	80008220 <insert_port_binding+0x18>

0000000080008252 <remove_port_binding>:
    80008252:	1141                	addi	sp,sp,-16
    80008254:	e406                	sd	ra,8(sp)
    80008256:	e022                	sd	s0,0(sp)
    80008258:	0800                	addi	s0,sp,16
    8000825a:	87aa                	mv	a5,a0
    8000825c:	6518                	ld	a4,8(a0)
    8000825e:	5b18                	lw	a4,48(a4)
    80008260:	4699                	li	a3,6
    80008262:	00d70a63          	beq	a4,a3,80008276 <remove_port_binding+0x24>
    80008266:	46c5                	li	a3,17
    80008268:	4501                	li	a0,0
    8000826a:	02d70a63          	beq	a4,a3,8000829e <remove_port_binding+0x4c>
    8000826e:	60a2                	ld	ra,8(sp)
    80008270:	6402                	ld	s0,0(sp)
    80008272:	0141                	addi	sp,sp,16
    80008274:	8082                	ret
    80008276:	00255703          	lhu	a4,2(a0)
    8000827a:	00371613          	slli	a2,a4,0x3
    8000827e:	00066697          	auipc	a3,0x66
    80008282:	11a68693          	addi	a3,a3,282 # 8006e398 <tcp_port_binds>
    80008286:	96b2                	add	a3,a3,a2
    80008288:	6294                	ld	a3,0(a3)
    8000828a:	ce95                	beqz	a3,800082c6 <remove_port_binding+0x74>
    8000828c:	00066697          	auipc	a3,0x66
    80008290:	10c68693          	addi	a3,a3,268 # 8006e398 <tcp_port_binds>
    80008294:	00c68733          	add	a4,a3,a2
    80008298:	e308                	sd	a0,0(a4)
    8000829a:	4501                	li	a0,0
    8000829c:	bfc9                	j	8000826e <remove_port_binding+0x1c>
    8000829e:	0027d783          	lhu	a5,2(a5)
    800082a2:	00379693          	slli	a3,a5,0x3
    800082a6:	00067717          	auipc	a4,0x67
    800082aa:	0f270713          	addi	a4,a4,242 # 8006f398 <udp_port_binds>
    800082ae:	9736                	add	a4,a4,a3
    800082b0:	6318                	ld	a4,0(a4)
    800082b2:	cf01                	beqz	a4,800082ca <remove_port_binding+0x78>
    800082b4:	00067717          	auipc	a4,0x67
    800082b8:	0e470713          	addi	a4,a4,228 # 8006f398 <udp_port_binds>
    800082bc:	00d707b3          	add	a5,a4,a3
    800082c0:	0007b023          	sd	zero,0(a5)
    800082c4:	b76d                	j	8000826e <remove_port_binding+0x1c>
    800082c6:	557d                	li	a0,-1
    800082c8:	b75d                	j	8000826e <remove_port_binding+0x1c>
    800082ca:	557d                	li	a0,-1
    800082cc:	b74d                	j	8000826e <remove_port_binding+0x1c>

00000000800082ce <tcp_socket_list_insert>:
    800082ce:	1141                	addi	sp,sp,-16
    800082d0:	e406                	sd	ra,8(sp)
    800082d2:	e022                	sd	s0,0(sp)
    800082d4:	0800                	addi	s0,sp,16
    800082d6:	00004797          	auipc	a5,0x4
    800082da:	6a27b783          	ld	a5,1698(a5) # 8000c978 <tcp_sock_list>
    800082de:	639c                	ld	a5,0(a5)
    800082e0:	6685                	lui	a3,0x1
    800082e2:	96be                	add	a3,a3,a5
    800082e4:	6398                	ld	a4,0(a5)
    800082e6:	c709                	beqz	a4,800082f0 <tcp_socket_list_insert+0x22>
    800082e8:	07a1                	addi	a5,a5,8
    800082ea:	fed79de3          	bne	a5,a3,800082e4 <tcp_socket_list_insert+0x16>
    800082ee:	a809                	j	80008300 <tcp_socket_list_insert+0x32>
    800082f0:	e388                	sd	a0,0(a5)
    800082f2:	00004717          	auipc	a4,0x4
    800082f6:	68673703          	ld	a4,1670(a4) # 8000c978 <tcp_sock_list>
    800082fa:	471c                	lw	a5,8(a4)
    800082fc:	2785                	addiw	a5,a5,1
    800082fe:	c71c                	sw	a5,8(a4)
    80008300:	4501                	li	a0,0
    80008302:	60a2                	ld	ra,8(sp)
    80008304:	6402                	ld	s0,0(sp)
    80008306:	0141                	addi	sp,sp,16
    80008308:	8082                	ret

000000008000830a <udp_socket_list_insert>:
    8000830a:	1141                	addi	sp,sp,-16
    8000830c:	e406                	sd	ra,8(sp)
    8000830e:	e022                	sd	s0,0(sp)
    80008310:	0800                	addi	s0,sp,16
    80008312:	00004797          	auipc	a5,0x4
    80008316:	65e7b783          	ld	a5,1630(a5) # 8000c970 <udp_sock_list>
    8000831a:	639c                	ld	a5,0(a5)
    8000831c:	6685                	lui	a3,0x1
    8000831e:	96be                	add	a3,a3,a5
    80008320:	6398                	ld	a4,0(a5)
    80008322:	c709                	beqz	a4,8000832c <udp_socket_list_insert+0x22>
    80008324:	07a1                	addi	a5,a5,8
    80008326:	fed79de3          	bne	a5,a3,80008320 <udp_socket_list_insert+0x16>
    8000832a:	a809                	j	8000833c <udp_socket_list_insert+0x32>
    8000832c:	e388                	sd	a0,0(a5)
    8000832e:	00004717          	auipc	a4,0x4
    80008332:	64273703          	ld	a4,1602(a4) # 8000c970 <udp_sock_list>
    80008336:	471c                	lw	a5,8(a4)
    80008338:	2785                	addiw	a5,a5,1
    8000833a:	c71c                	sw	a5,8(a4)
    8000833c:	4501                	li	a0,0
    8000833e:	60a2                	ld	ra,8(sp)
    80008340:	6402                	ld	s0,0(sp)
    80008342:	0141                	addi	sp,sp,16
    80008344:	8082                	ret

0000000080008346 <getsock>:
    80008346:	1141                	addi	sp,sp,-16
    80008348:	e406                	sd	ra,8(sp)
    8000834a:	e022                	sd	s0,0(sp)
    8000834c:	0800                	addi	s0,sp,16
    8000834e:	00004797          	auipc	a5,0x4
    80008352:	6327b783          	ld	a5,1586(a5) # 8000c980 <sock_list>
    80008356:	4794                	lw	a3,8(a5)
    80008358:	02d05263          	blez	a3,8000837c <getsock+0x36>
    8000835c:	862a                	mv	a2,a0
    8000835e:	639c                	ld	a5,0(a5)
    80008360:	068e                	slli	a3,a3,0x3
    80008362:	96be                	add	a3,a3,a5
    80008364:	6388                	ld	a0,0(a5)
    80008366:	4138                	lw	a4,64(a0)
    80008368:	00c70663          	beq	a4,a2,80008374 <getsock+0x2e>
    8000836c:	07a1                	addi	a5,a5,8
    8000836e:	fed79be3          	bne	a5,a3,80008364 <getsock+0x1e>
    80008372:	4501                	li	a0,0
    80008374:	60a2                	ld	ra,8(sp)
    80008376:	6402                	ld	s0,0(sp)
    80008378:	0141                	addi	sp,sp,16
    8000837a:	8082                	ret
    8000837c:	4501                	li	a0,0
    8000837e:	bfdd                	j	80008374 <getsock+0x2e>

0000000080008380 <socket_list_remove>:
    80008380:	1101                	addi	sp,sp,-32
    80008382:	ec06                	sd	ra,24(sp)
    80008384:	e822                	sd	s0,16(sp)
    80008386:	e04a                	sd	s2,0(sp)
    80008388:	1000                	addi	s0,sp,32
    8000838a:	00004917          	auipc	s2,0x4
    8000838e:	5f693903          	ld	s2,1526(s2) # 8000c980 <sock_list>
    80008392:	00093783          	ld	a5,0(s2)
    80008396:	00351713          	slli	a4,a0,0x3
    8000839a:	97ba                	add	a5,a5,a4
    8000839c:	639c                	ld	a5,0(a5)
    8000839e:	c7c5                	beqz	a5,80008446 <socket_list_remove+0xc6>
    800083a0:	e426                	sd	s1,8(sp)
    800083a2:	84aa                	mv	s1,a0
    800083a4:	00000097          	auipc	ra,0x0
    800083a8:	fa2080e7          	jalr	-94(ra) # 80008346 <getsock>
    800083ac:	86aa                	mv	a3,a0
    800083ae:	557d                	li	a0,-1
    800083b0:	cec9                	beqz	a3,8000844a <socket_list_remove+0xca>
    800083b2:	00892783          	lw	a5,8(s2)
    800083b6:	37fd                	addiw	a5,a5,-1
    800083b8:	00f92423          	sw	a5,8(s2)
    800083bc:	5adc                	lw	a5,52(a3)
    800083be:	4705                	li	a4,1
    800083c0:	02e78163          	beq	a5,a4,800083e2 <socket_list_remove+0x62>
    800083c4:	4709                	li	a4,2
    800083c6:	04e78763          	beq	a5,a4,80008414 <socket_list_remove+0x94>
    800083ca:	8536                	mv	a0,a3
    800083cc:	ffff8097          	auipc	ra,0xffff8
    800083d0:	6ce080e7          	jalr	1742(ra) # 80000a9a <kfree>
    800083d4:	4505                	li	a0,1
    800083d6:	64a2                	ld	s1,8(sp)
    800083d8:	60e2                	ld	ra,24(sp)
    800083da:	6442                	ld	s0,16(sp)
    800083dc:	6902                	ld	s2,0(sp)
    800083de:	6105                	addi	sp,sp,32
    800083e0:	8082                	ret
    800083e2:	00004797          	auipc	a5,0x4
    800083e6:	5967b783          	ld	a5,1430(a5) # 8000c978 <tcp_sock_list>
    800083ea:	639c                	ld	a5,0(a5)
    800083ec:	6605                	lui	a2,0x1
    800083ee:	963e                	add	a2,a2,a5
    800083f0:	6398                	ld	a4,0(a5)
    800083f2:	4338                	lw	a4,64(a4)
    800083f4:	00970663          	beq	a4,s1,80008400 <socket_list_remove+0x80>
    800083f8:	07a1                	addi	a5,a5,8
    800083fa:	fec79be3          	bne	a5,a2,800083f0 <socket_list_remove+0x70>
    800083fe:	b7f1                	j	800083ca <socket_list_remove+0x4a>
    80008400:	0007b023          	sd	zero,0(a5)
    80008404:	00004717          	auipc	a4,0x4
    80008408:	57473703          	ld	a4,1396(a4) # 8000c978 <tcp_sock_list>
    8000840c:	471c                	lw	a5,8(a4)
    8000840e:	37fd                	addiw	a5,a5,-1
    80008410:	c71c                	sw	a5,8(a4)
    80008412:	bf65                	j	800083ca <socket_list_remove+0x4a>
    80008414:	00004797          	auipc	a5,0x4
    80008418:	55c7b783          	ld	a5,1372(a5) # 8000c970 <udp_sock_list>
    8000841c:	639c                	ld	a5,0(a5)
    8000841e:	6605                	lui	a2,0x1
    80008420:	963e                	add	a2,a2,a5
    80008422:	6398                	ld	a4,0(a5)
    80008424:	4338                	lw	a4,64(a4)
    80008426:	00970663          	beq	a4,s1,80008432 <socket_list_remove+0xb2>
    8000842a:	07a1                	addi	a5,a5,8
    8000842c:	fec79be3          	bne	a5,a2,80008422 <socket_list_remove+0xa2>
    80008430:	bf69                	j	800083ca <socket_list_remove+0x4a>
    80008432:	0007b023          	sd	zero,0(a5)
    80008436:	00004717          	auipc	a4,0x4
    8000843a:	53a73703          	ld	a4,1338(a4) # 8000c970 <udp_sock_list>
    8000843e:	471c                	lw	a5,8(a4)
    80008440:	37fd                	addiw	a5,a5,-1
    80008442:	c71c                	sw	a5,8(a4)
    80008444:	b759                	j	800083ca <socket_list_remove+0x4a>
    80008446:	557d                	li	a0,-1
    80008448:	bf41                	j	800083d8 <socket_list_remove+0x58>
    8000844a:	64a2                	ld	s1,8(sp)
    8000844c:	b771                	j	800083d8 <socket_list_remove+0x58>

000000008000844e <sock_list_insert>:
    8000844e:	00004797          	auipc	a5,0x4
    80008452:	5327b783          	ld	a5,1330(a5) # 8000c980 <sock_list>
    80008456:	4794                	lw	a3,8(a5)
    80008458:	20000713          	li	a4,512
    8000845c:	0ae68a63          	beq	a3,a4,80008510 <sock_list_insert+0xc2>
    80008460:	1101                	addi	sp,sp,-32
    80008462:	ec06                	sd	ra,24(sp)
    80008464:	e822                	sd	s0,16(sp)
    80008466:	e426                	sd	s1,8(sp)
    80008468:	1000                	addi	s0,sp,32
    8000846a:	862a                	mv	a2,a0
    8000846c:	639c                	ld	a5,0(a5)
    8000846e:	4481                	li	s1,0
    80008470:	86ba                	mv	a3,a4
    80008472:	6398                	ld	a4,0(a5)
    80008474:	c719                	beqz	a4,80008482 <sock_list_insert+0x34>
    80008476:	2485                	addiw	s1,s1,1
    80008478:	07a1                	addi	a5,a5,8
    8000847a:	fed49ce3          	bne	s1,a3,80008472 <sock_list_insert+0x24>
    8000847e:	54fd                	li	s1,-1
    80008480:	a809                	j	80008492 <sock_list_insert+0x44>
    80008482:	e390                	sd	a2,0(a5)
    80008484:	00004717          	auipc	a4,0x4
    80008488:	4fc73703          	ld	a4,1276(a4) # 8000c980 <sock_list>
    8000848c:	471c                	lw	a5,8(a4)
    8000848e:	2785                	addiw	a5,a5,1
    80008490:	c71c                	sw	a5,8(a4)
    80008492:	5a5c                	lw	a5,52(a2)
    80008494:	4709                	li	a4,2
    80008496:	00e78b63          	beq	a5,a4,800084ac <sock_list_insert+0x5e>
    8000849a:	4705                	li	a4,1
    8000849c:	4501                	li	a0,0
    8000849e:	04e78063          	beq	a5,a4,800084de <sock_list_insert+0x90>
    800084a2:	60e2                	ld	ra,24(sp)
    800084a4:	6442                	ld	s0,16(sp)
    800084a6:	64a2                	ld	s1,8(sp)
    800084a8:	6105                	addi	sp,sp,32
    800084aa:	8082                	ret
    800084ac:	8532                	mv	a0,a2
    800084ae:	00000097          	auipc	ra,0x0
    800084b2:	e5c080e7          	jalr	-420(ra) # 8000830a <udp_socket_list_insert>
    800084b6:	57fd                	li	a5,-1
    800084b8:	00f50463          	beq	a0,a5,800084c0 <sock_list_insert+0x72>
    800084bc:	4501                	li	a0,0
    800084be:	b7d5                	j	800084a2 <sock_list_insert+0x54>
    800084c0:	00004717          	auipc	a4,0x4
    800084c4:	4c070713          	addi	a4,a4,1216 # 8000c980 <sock_list>
    800084c8:	631c                	ld	a5,0(a4)
    800084ca:	639c                	ld	a5,0(a5)
    800084cc:	048e                	slli	s1,s1,0x3
    800084ce:	97a6                	add	a5,a5,s1
    800084d0:	0007b023          	sd	zero,0(a5)
    800084d4:	6318                	ld	a4,0(a4)
    800084d6:	471c                	lw	a5,8(a4)
    800084d8:	37fd                	addiw	a5,a5,-1
    800084da:	c71c                	sw	a5,8(a4)
    800084dc:	b7d9                	j	800084a2 <sock_list_insert+0x54>
    800084de:	8532                	mv	a0,a2
    800084e0:	00000097          	auipc	ra,0x0
    800084e4:	dee080e7          	jalr	-530(ra) # 800082ce <tcp_socket_list_insert>
    800084e8:	57fd                	li	a5,-1
    800084ea:	00f50463          	beq	a0,a5,800084f2 <sock_list_insert+0xa4>
    800084ee:	4501                	li	a0,0
    800084f0:	bf4d                	j	800084a2 <sock_list_insert+0x54>
    800084f2:	00004717          	auipc	a4,0x4
    800084f6:	48e70713          	addi	a4,a4,1166 # 8000c980 <sock_list>
    800084fa:	631c                	ld	a5,0(a4)
    800084fc:	639c                	ld	a5,0(a5)
    800084fe:	048e                	slli	s1,s1,0x3
    80008500:	97a6                	add	a5,a5,s1
    80008502:	0007b023          	sd	zero,0(a5)
    80008506:	6318                	ld	a4,0(a4)
    80008508:	471c                	lw	a5,8(a4)
    8000850a:	37fd                	addiw	a5,a5,-1
    8000850c:	c71c                	sw	a5,8(a4)
    8000850e:	bf51                	j	800084a2 <sock_list_insert+0x54>
    80008510:	557d                	li	a0,-1
    80008512:	8082                	ret

0000000080008514 <bind>:
    80008514:	1101                	addi	sp,sp,-32
    80008516:	ec06                	sd	ra,24(sp)
    80008518:	e822                	sd	s0,16(sp)
    8000851a:	e426                	sd	s1,8(sp)
    8000851c:	e04a                	sd	s2,0(sp)
    8000851e:	1000                	addi	s0,sp,32
    80008520:	84ae                	mv	s1,a1
    80008522:	8932                	mv	s2,a2
    80008524:	00000097          	auipc	ra,0x0
    80008528:	e22080e7          	jalr	-478(ra) # 80008346 <getsock>
    8000852c:	cd01                	beqz	a0,80008544 <bind+0x30>
    8000852e:	653c                	ld	a5,72(a0)
    80008530:	639c                	ld	a5,0(a5)
    80008532:	864a                	mv	a2,s2
    80008534:	85a6                	mv	a1,s1
    80008536:	9782                	jalr	a5
    80008538:	60e2                	ld	ra,24(sp)
    8000853a:	6442                	ld	s0,16(sp)
    8000853c:	64a2                	ld	s1,8(sp)
    8000853e:	6902                	ld	s2,0(sp)
    80008540:	6105                	addi	sp,sp,32
    80008542:	8082                	ret
    80008544:	557d                	li	a0,-1
    80008546:	bfcd                	j	80008538 <bind+0x24>

0000000080008548 <listen>:
    80008548:	1101                	addi	sp,sp,-32
    8000854a:	ec06                	sd	ra,24(sp)
    8000854c:	e822                	sd	s0,16(sp)
    8000854e:	e426                	sd	s1,8(sp)
    80008550:	1000                	addi	s0,sp,32
    80008552:	84ae                	mv	s1,a1
    80008554:	00000097          	auipc	ra,0x0
    80008558:	df2080e7          	jalr	-526(ra) # 80008346 <getsock>
    8000855c:	c919                	beqz	a0,80008572 <listen+0x2a>
    8000855e:	653c                	ld	a5,72(a0)
    80008560:	6b9c                	ld	a5,16(a5)
    80008562:	85a6                	mv	a1,s1
    80008564:	9782                	jalr	a5
    80008566:	4501                	li	a0,0
    80008568:	60e2                	ld	ra,24(sp)
    8000856a:	6442                	ld	s0,16(sp)
    8000856c:	64a2                	ld	s1,8(sp)
    8000856e:	6105                	addi	sp,sp,32
    80008570:	8082                	ret
    80008572:	557d                	li	a0,-1
    80008574:	bfd5                	j	80008568 <listen+0x20>

0000000080008576 <accept>:
    80008576:	1101                	addi	sp,sp,-32
    80008578:	ec06                	sd	ra,24(sp)
    8000857a:	e822                	sd	s0,16(sp)
    8000857c:	1000                	addi	s0,sp,32
    8000857e:	00000097          	auipc	ra,0x0
    80008582:	dc8080e7          	jalr	-568(ra) # 80008346 <getsock>
    80008586:	c151                	beqz	a0,8000860a <accept+0x94>
    80008588:	e426                	sd	s1,8(sp)
    8000858a:	84aa                	mv	s1,a0
    8000858c:	7918                	ld	a4,48(a0)
    8000858e:	4785                	li	a5,1
    80008590:	1782                	slli	a5,a5,0x20
    80008592:	0799                	addi	a5,a5,6
    80008594:	04f71563          	bne	a4,a5,800085de <accept+0x68>
    80008598:	5d58                	lw	a4,60(a0)
    8000859a:	03400793          	li	a5,52
    8000859e:	04f71b63          	bne	a4,a5,800085f4 <accept+0x7e>
    800085a2:	e04a                	sd	s2,0(sp)
    800085a4:	00850913          	addi	s2,a0,8
    800085a8:	854a                	mv	a0,s2
    800085aa:	ffff8097          	auipc	ra,0xffff8
    800085ae:	766080e7          	jalr	1894(ra) # 80000d10 <acquire>
    800085b2:	609c                	ld	a5,0(s1)
    800085b4:	eb89                	bnez	a5,800085c6 <accept+0x50>
    800085b6:	85ca                	mv	a1,s2
    800085b8:	8526                	mv	a0,s1
    800085ba:	ffffa097          	auipc	ra,0xffffa
    800085be:	108080e7          	jalr	264(ra) # 800026c2 <sleep>
    800085c2:	609c                	ld	a5,0(s1)
    800085c4:	dbed                	beqz	a5,800085b6 <accept+0x40>
    800085c6:	854a                	mv	a0,s2
    800085c8:	ffff8097          	auipc	ra,0xffff8
    800085cc:	7fc080e7          	jalr	2044(ra) # 80000dc4 <release>
    800085d0:	40a8                	lw	a0,64(s1)
    800085d2:	64a2                	ld	s1,8(sp)
    800085d4:	6902                	ld	s2,0(sp)
    800085d6:	60e2                	ld	ra,24(sp)
    800085d8:	6442                	ld	s0,16(sp)
    800085da:	6105                	addi	sp,sp,32
    800085dc:	8082                	ret
    800085de:	00003517          	auipc	a0,0x3
    800085e2:	3e250513          	addi	a0,a0,994 # 8000b9c0 <etext+0x9c0>
    800085e6:	ffff8097          	auipc	ra,0xffff8
    800085ea:	fc4080e7          	jalr	-60(ra) # 800005aa <printf>
    800085ee:	557d                	li	a0,-1
    800085f0:	64a2                	ld	s1,8(sp)
    800085f2:	b7d5                	j	800085d6 <accept+0x60>
    800085f4:	00003517          	auipc	a0,0x3
    800085f8:	40450513          	addi	a0,a0,1028 # 8000b9f8 <etext+0x9f8>
    800085fc:	ffff8097          	auipc	ra,0xffff8
    80008600:	fae080e7          	jalr	-82(ra) # 800005aa <printf>
    80008604:	557d                	li	a0,-1
    80008606:	64a2                	ld	s1,8(sp)
    80008608:	b7f9                	j	800085d6 <accept+0x60>
    8000860a:	557d                	li	a0,-1
    8000860c:	b7e9                	j	800085d6 <accept+0x60>

000000008000860e <connect>:
    8000860e:	1141                	addi	sp,sp,-16
    80008610:	e406                	sd	ra,8(sp)
    80008612:	e022                	sd	s0,0(sp)
    80008614:	0800                	addi	s0,sp,16
    80008616:	4501                	li	a0,0
    80008618:	60a2                	ld	ra,8(sp)
    8000861a:	6402                	ld	s0,0(sp)
    8000861c:	0141                	addi	sp,sp,16
    8000861e:	8082                	ret

0000000080008620 <initsocket>:
    80008620:	1141                	addi	sp,sp,-16
    80008622:	e406                	sd	ra,8(sp)
    80008624:	e022                	sd	s0,0(sp)
    80008626:	0800                	addi	s0,sp,16
    80008628:	4789                	li	a5,2
    8000862a:	04f59e63          	bne	a1,a5,80008686 <initsocket+0x66>
    8000862e:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80008632:	4705                	li	a4,1
    80008634:	06f76363          	bltu	a4,a5,8000869a <initsocket+0x7a>
    80008638:	eabd                	bnez	a3,800086ae <initsocket+0x8e>
    8000863a:	4785                	li	a5,1
    8000863c:	0af60963          	beq	a2,a5,800086ee <initsocket+0xce>
    80008640:	47c5                	li	a5,17
    80008642:	d91c                	sw	a5,48(a0)
    80008644:	00004717          	auipc	a4,0x4
    80008648:	26472703          	lw	a4,612(a4) # 8000c8a8 <netconf>
    8000864c:	00004797          	auipc	a5,0x4
    80008650:	2ac78793          	addi	a5,a5,684 # 8000c8f8 <udp_ops>
    80008654:	d118                	sw	a4,32(a0)
    80008656:	d950                	sw	a2,52(a0)
    80008658:	4709                	li	a4,2
    8000865a:	dd18                	sw	a4,56(a0)
    8000865c:	03200713          	li	a4,50
    80008660:	dd58                	sw	a4,60(a0)
    80008662:	04053823          	sd	zero,80(a0)
    80008666:	04053c23          	sd	zero,88(a0)
    8000866a:	e53c                	sd	a5,72(a0)
    8000866c:	00000097          	auipc	ra,0x0
    80008670:	de2080e7          	jalr	-542(ra) # 8000844e <sock_list_insert>
    80008674:	0505                	addi	a0,a0,1
    80008676:	00153513          	seqz	a0,a0
    8000867a:	40a0053b          	negw	a0,a0
    8000867e:	60a2                	ld	ra,8(sp)
    80008680:	6402                	ld	s0,0(sp)
    80008682:	0141                	addi	sp,sp,16
    80008684:	8082                	ret
    80008686:	00003517          	auipc	a0,0x3
    8000868a:	39a50513          	addi	a0,a0,922 # 8000ba20 <etext+0xa20>
    8000868e:	ffff8097          	auipc	ra,0xffff8
    80008692:	f1c080e7          	jalr	-228(ra) # 800005aa <printf>
    80008696:	557d                	li	a0,-1
    80008698:	b7dd                	j	8000867e <initsocket+0x5e>
    8000869a:	00003517          	auipc	a0,0x3
    8000869e:	3a650513          	addi	a0,a0,934 # 8000ba40 <etext+0xa40>
    800086a2:	ffff8097          	auipc	ra,0xffff8
    800086a6:	f08080e7          	jalr	-248(ra) # 800005aa <printf>
    800086aa:	557d                	li	a0,-1
    800086ac:	bfc9                	j	8000867e <initsocket+0x5e>
    800086ae:	4799                	li	a5,6
    800086b0:	02f68c63          	beq	a3,a5,800086e8 <initsocket+0xc8>
    800086b4:	47c5                	li	a5,17
    800086b6:	00f69f63          	bne	a3,a5,800086d4 <initsocket+0xb4>
    800086ba:	4789                	li	a5,2
    800086bc:	f8f602e3          	beq	a2,a5,80008640 <initsocket+0x20>
    800086c0:	00003517          	auipc	a0,0x3
    800086c4:	3c050513          	addi	a0,a0,960 # 8000ba80 <etext+0xa80>
    800086c8:	ffff8097          	auipc	ra,0xffff8
    800086cc:	ee2080e7          	jalr	-286(ra) # 800005aa <printf>
    800086d0:	557d                	li	a0,-1
    800086d2:	b775                	j	8000867e <initsocket+0x5e>
    800086d4:	00003517          	auipc	a0,0x3
    800086d8:	38c50513          	addi	a0,a0,908 # 8000ba60 <etext+0xa60>
    800086dc:	ffff8097          	auipc	ra,0xffff8
    800086e0:	ece080e7          	jalr	-306(ra) # 800005aa <printf>
    800086e4:	557d                	li	a0,-1
    800086e6:	bf61                	j	8000867e <initsocket+0x5e>
    800086e8:	4785                	li	a5,1
    800086ea:	fcf61be3          	bne	a2,a5,800086c0 <initsocket+0xa0>
    800086ee:	4799                	li	a5,6
    800086f0:	d91c                	sw	a5,48(a0)
    800086f2:	00004717          	auipc	a4,0x4
    800086f6:	1b672703          	lw	a4,438(a4) # 8000c8a8 <netconf>
    800086fa:	00004797          	auipc	a5,0x4
    800086fe:	1c678793          	addi	a5,a5,454 # 8000c8c0 <tcp_ops>
    80008702:	bf89                	j	80008654 <initsocket+0x34>

0000000080008704 <close>:
    80008704:	1141                	addi	sp,sp,-16
    80008706:	e406                	sd	ra,8(sp)
    80008708:	e022                	sd	s0,0(sp)
    8000870a:	0800                	addi	s0,sp,16
    8000870c:	4501                	li	a0,0
    8000870e:	60a2                	ld	ra,8(sp)
    80008710:	6402                	ld	s0,0(sp)
    80008712:	0141                	addi	sp,sp,16
    80008714:	8082                	ret

0000000080008716 <send>:
    80008716:	1141                	addi	sp,sp,-16
    80008718:	e406                	sd	ra,8(sp)
    8000871a:	e022                	sd	s0,0(sp)
    8000871c:	0800                	addi	s0,sp,16
    8000871e:	4501                	li	a0,0
    80008720:	60a2                	ld	ra,8(sp)
    80008722:	6402                	ld	s0,0(sp)
    80008724:	0141                	addi	sp,sp,16
    80008726:	8082                	ret

0000000080008728 <recv>:
    80008728:	1141                	addi	sp,sp,-16
    8000872a:	e406                	sd	ra,8(sp)
    8000872c:	e022                	sd	s0,0(sp)
    8000872e:	0800                	addi	s0,sp,16
    80008730:	4501                	li	a0,0
    80008732:	60a2                	ld	ra,8(sp)
    80008734:	6402                	ld	s0,0(sp)
    80008736:	0141                	addi	sp,sp,16
    80008738:	8082                	ret

000000008000873a <sendto>:
    8000873a:	7139                	addi	sp,sp,-64
    8000873c:	fc06                	sd	ra,56(sp)
    8000873e:	f822                	sd	s0,48(sp)
    80008740:	f426                	sd	s1,40(sp)
    80008742:	f04a                	sd	s2,32(sp)
    80008744:	ec4e                	sd	s3,24(sp)
    80008746:	e852                	sd	s4,16(sp)
    80008748:	e456                	sd	s5,8(sp)
    8000874a:	0080                	addi	s0,sp,64
    8000874c:	8aae                	mv	s5,a1
    8000874e:	8a32                	mv	s4,a2
    80008750:	84b6                	mv	s1,a3
    80008752:	893a                	mv	s2,a4
    80008754:	89be                	mv	s3,a5
    80008756:	00000097          	auipc	ra,0x0
    8000875a:	bf0080e7          	jalr	-1040(ra) # 80008346 <getsock>
    8000875e:	c11d                	beqz	a0,80008784 <sendto+0x4a>
    80008760:	653c                	ld	a5,72(a0)
    80008762:	0207b803          	ld	a6,32(a5)
    80008766:	87ce                	mv	a5,s3
    80008768:	874a                	mv	a4,s2
    8000876a:	86a6                	mv	a3,s1
    8000876c:	8652                	mv	a2,s4
    8000876e:	85d6                	mv	a1,s5
    80008770:	9802                	jalr	a6
    80008772:	70e2                	ld	ra,56(sp)
    80008774:	7442                	ld	s0,48(sp)
    80008776:	74a2                	ld	s1,40(sp)
    80008778:	7902                	ld	s2,32(sp)
    8000877a:	69e2                	ld	s3,24(sp)
    8000877c:	6a42                	ld	s4,16(sp)
    8000877e:	6aa2                	ld	s5,8(sp)
    80008780:	6121                	addi	sp,sp,64
    80008782:	8082                	ret
    80008784:	557d                	li	a0,-1
    80008786:	b7f5                	j	80008772 <sendto+0x38>

0000000080008788 <recvfrom>:
    80008788:	7139                	addi	sp,sp,-64
    8000878a:	fc06                	sd	ra,56(sp)
    8000878c:	f822                	sd	s0,48(sp)
    8000878e:	f426                	sd	s1,40(sp)
    80008790:	f04a                	sd	s2,32(sp)
    80008792:	ec4e                	sd	s3,24(sp)
    80008794:	e852                	sd	s4,16(sp)
    80008796:	e456                	sd	s5,8(sp)
    80008798:	0080                	addi	s0,sp,64
    8000879a:	8aae                	mv	s5,a1
    8000879c:	8a32                	mv	s4,a2
    8000879e:	84b6                	mv	s1,a3
    800087a0:	893a                	mv	s2,a4
    800087a2:	89be                	mv	s3,a5
    800087a4:	00000097          	auipc	ra,0x0
    800087a8:	ba2080e7          	jalr	-1118(ra) # 80008346 <getsock>
    800087ac:	c11d                	beqz	a0,800087d2 <recvfrom+0x4a>
    800087ae:	653c                	ld	a5,72(a0)
    800087b0:	0287b803          	ld	a6,40(a5)
    800087b4:	87ce                	mv	a5,s3
    800087b6:	874a                	mv	a4,s2
    800087b8:	86a6                	mv	a3,s1
    800087ba:	8652                	mv	a2,s4
    800087bc:	85d6                	mv	a1,s5
    800087be:	9802                	jalr	a6
    800087c0:	70e2                	ld	ra,56(sp)
    800087c2:	7442                	ld	s0,48(sp)
    800087c4:	74a2                	ld	s1,40(sp)
    800087c6:	7902                	ld	s2,32(sp)
    800087c8:	69e2                	ld	s3,24(sp)
    800087ca:	6a42                	ld	s4,16(sp)
    800087cc:	6aa2                	ld	s5,8(sp)
    800087ce:	6121                	addi	sp,sp,64
    800087d0:	8082                	ret
    800087d2:	557d                	li	a0,-1
    800087d4:	b7f5                	j	800087c0 <recvfrom+0x38>

00000000800087d6 <sock_list_init>:
    800087d6:	1101                	addi	sp,sp,-32
    800087d8:	ec06                	sd	ra,24(sp)
    800087da:	e822                	sd	s0,16(sp)
    800087dc:	1000                	addi	s0,sp,32
    800087de:	ffff8097          	auipc	ra,0xffff8
    800087e2:	424080e7          	jalr	1060(ra) # 80000c02 <kalloc>
    800087e6:	00004797          	auipc	a5,0x4
    800087ea:	18a7bd23          	sd	a0,410(a5) # 8000c980 <sock_list>
    800087ee:	c90d                	beqz	a0,80008820 <sock_list_init+0x4a>
    800087f0:	e426                	sd	s1,8(sp)
    800087f2:	84aa                	mv	s1,a0
    800087f4:	ffff8097          	auipc	ra,0xffff8
    800087f8:	40e080e7          	jalr	1038(ra) # 80000c02 <kalloc>
    800087fc:	e088                	sd	a0,0(s1)
    800087fe:	00004797          	auipc	a5,0x4
    80008802:	1827b783          	ld	a5,386(a5) # 8000c980 <sock_list>
    80008806:	6388                	ld	a0,0(a5)
    80008808:	c50d                	beqz	a0,80008832 <sock_list_init+0x5c>
    8000880a:	6605                	lui	a2,0x1
    8000880c:	4581                	li	a1,0
    8000880e:	ffff8097          	auipc	ra,0xffff8
    80008812:	5fe080e7          	jalr	1534(ra) # 80000e0c <memset>
    80008816:	64a2                	ld	s1,8(sp)
    80008818:	60e2                	ld	ra,24(sp)
    8000881a:	6442                	ld	s0,16(sp)
    8000881c:	6105                	addi	sp,sp,32
    8000881e:	8082                	ret
    80008820:	00003517          	auipc	a0,0x3
    80008824:	29050513          	addi	a0,a0,656 # 8000bab0 <etext+0xab0>
    80008828:	ffff8097          	auipc	ra,0xffff8
    8000882c:	d82080e7          	jalr	-638(ra) # 800005aa <printf>
    80008830:	b7e5                	j	80008818 <sock_list_init+0x42>
    80008832:	00003517          	auipc	a0,0x3
    80008836:	2ae50513          	addi	a0,a0,686 # 8000bae0 <etext+0xae0>
    8000883a:	ffff8097          	auipc	ra,0xffff8
    8000883e:	d70080e7          	jalr	-656(ra) # 800005aa <printf>
    80008842:	00004517          	auipc	a0,0x4
    80008846:	13e53503          	ld	a0,318(a0) # 8000c980 <sock_list>
    8000884a:	ffff8097          	auipc	ra,0xffff8
    8000884e:	250080e7          	jalr	592(ra) # 80000a9a <kfree>
    80008852:	64a2                	ld	s1,8(sp)
    80008854:	b7d1                	j	80008818 <sock_list_init+0x42>

0000000080008856 <tcp_sock_list_init>:
    80008856:	1101                	addi	sp,sp,-32
    80008858:	ec06                	sd	ra,24(sp)
    8000885a:	e822                	sd	s0,16(sp)
    8000885c:	1000                	addi	s0,sp,32
    8000885e:	ffff8097          	auipc	ra,0xffff8
    80008862:	3a4080e7          	jalr	932(ra) # 80000c02 <kalloc>
    80008866:	00004797          	auipc	a5,0x4
    8000886a:	10a7b923          	sd	a0,274(a5) # 8000c978 <tcp_sock_list>
    8000886e:	c90d                	beqz	a0,800088a0 <tcp_sock_list_init+0x4a>
    80008870:	e426                	sd	s1,8(sp)
    80008872:	84aa                	mv	s1,a0
    80008874:	ffff8097          	auipc	ra,0xffff8
    80008878:	38e080e7          	jalr	910(ra) # 80000c02 <kalloc>
    8000887c:	e088                	sd	a0,0(s1)
    8000887e:	00004797          	auipc	a5,0x4
    80008882:	0fa7b783          	ld	a5,250(a5) # 8000c978 <tcp_sock_list>
    80008886:	6388                	ld	a0,0(a5)
    80008888:	c50d                	beqz	a0,800088b2 <tcp_sock_list_init+0x5c>
    8000888a:	6605                	lui	a2,0x1
    8000888c:	4581                	li	a1,0
    8000888e:	ffff8097          	auipc	ra,0xffff8
    80008892:	57e080e7          	jalr	1406(ra) # 80000e0c <memset>
    80008896:	64a2                	ld	s1,8(sp)
    80008898:	60e2                	ld	ra,24(sp)
    8000889a:	6442                	ld	s0,16(sp)
    8000889c:	6105                	addi	sp,sp,32
    8000889e:	8082                	ret
    800088a0:	00003517          	auipc	a0,0x3
    800088a4:	21050513          	addi	a0,a0,528 # 8000bab0 <etext+0xab0>
    800088a8:	ffff8097          	auipc	ra,0xffff8
    800088ac:	d02080e7          	jalr	-766(ra) # 800005aa <printf>
    800088b0:	b7e5                	j	80008898 <tcp_sock_list_init+0x42>
    800088b2:	00003517          	auipc	a0,0x3
    800088b6:	22e50513          	addi	a0,a0,558 # 8000bae0 <etext+0xae0>
    800088ba:	ffff8097          	auipc	ra,0xffff8
    800088be:	cf0080e7          	jalr	-784(ra) # 800005aa <printf>
    800088c2:	00004517          	auipc	a0,0x4
    800088c6:	0b653503          	ld	a0,182(a0) # 8000c978 <tcp_sock_list>
    800088ca:	ffff8097          	auipc	ra,0xffff8
    800088ce:	1d0080e7          	jalr	464(ra) # 80000a9a <kfree>
    800088d2:	64a2                	ld	s1,8(sp)
    800088d4:	b7d1                	j	80008898 <tcp_sock_list_init+0x42>

00000000800088d6 <udp_sock_list_init>:
    800088d6:	1101                	addi	sp,sp,-32
    800088d8:	ec06                	sd	ra,24(sp)
    800088da:	e822                	sd	s0,16(sp)
    800088dc:	1000                	addi	s0,sp,32
    800088de:	ffff8097          	auipc	ra,0xffff8
    800088e2:	324080e7          	jalr	804(ra) # 80000c02 <kalloc>
    800088e6:	00004797          	auipc	a5,0x4
    800088ea:	08a7b523          	sd	a0,138(a5) # 8000c970 <udp_sock_list>
    800088ee:	c90d                	beqz	a0,80008920 <udp_sock_list_init+0x4a>
    800088f0:	e426                	sd	s1,8(sp)
    800088f2:	84aa                	mv	s1,a0
    800088f4:	ffff8097          	auipc	ra,0xffff8
    800088f8:	30e080e7          	jalr	782(ra) # 80000c02 <kalloc>
    800088fc:	e088                	sd	a0,0(s1)
    800088fe:	00004797          	auipc	a5,0x4
    80008902:	0727b783          	ld	a5,114(a5) # 8000c970 <udp_sock_list>
    80008906:	6388                	ld	a0,0(a5)
    80008908:	c50d                	beqz	a0,80008932 <udp_sock_list_init+0x5c>
    8000890a:	6605                	lui	a2,0x1
    8000890c:	4581                	li	a1,0
    8000890e:	ffff8097          	auipc	ra,0xffff8
    80008912:	4fe080e7          	jalr	1278(ra) # 80000e0c <memset>
    80008916:	64a2                	ld	s1,8(sp)
    80008918:	60e2                	ld	ra,24(sp)
    8000891a:	6442                	ld	s0,16(sp)
    8000891c:	6105                	addi	sp,sp,32
    8000891e:	8082                	ret
    80008920:	00003517          	auipc	a0,0x3
    80008924:	1f050513          	addi	a0,a0,496 # 8000bb10 <etext+0xb10>
    80008928:	ffff8097          	auipc	ra,0xffff8
    8000892c:	c82080e7          	jalr	-894(ra) # 800005aa <printf>
    80008930:	b7e5                	j	80008918 <udp_sock_list_init+0x42>
    80008932:	00003517          	auipc	a0,0x3
    80008936:	20e50513          	addi	a0,a0,526 # 8000bb40 <etext+0xb40>
    8000893a:	ffff8097          	auipc	ra,0xffff8
    8000893e:	c70080e7          	jalr	-912(ra) # 800005aa <printf>
    80008942:	00004517          	auipc	a0,0x4
    80008946:	02e53503          	ld	a0,46(a0) # 8000c970 <udp_sock_list>
    8000894a:	ffff8097          	auipc	ra,0xffff8
    8000894e:	150080e7          	jalr	336(ra) # 80000a9a <kfree>
    80008952:	64a2                	ld	s1,8(sp)
    80008954:	b7d1                	j	80008918 <udp_sock_list_init+0x42>

0000000080008956 <socket_init>:
    80008956:	1141                	addi	sp,sp,-16
    80008958:	e406                	sd	ra,8(sp)
    8000895a:	e022                	sd	s0,0(sp)
    8000895c:	0800                	addi	s0,sp,16
    8000895e:	00000097          	auipc	ra,0x0
    80008962:	e78080e7          	jalr	-392(ra) # 800087d6 <sock_list_init>
    80008966:	00000097          	auipc	ra,0x0
    8000896a:	ef0080e7          	jalr	-272(ra) # 80008856 <tcp_sock_list_init>
    8000896e:	00000097          	auipc	ra,0x0
    80008972:	f68080e7          	jalr	-152(ra) # 800088d6 <udp_sock_list_init>
    80008976:	60a2                	ld	ra,8(sp)
    80008978:	6402                	ld	s0,0(sp)
    8000897a:	0141                	addi	sp,sp,16
    8000897c:	8082                	ret

000000008000897e <print_eth_frame>:
    8000897e:	7139                	addi	sp,sp,-64
    80008980:	fc06                	sd	ra,56(sp)
    80008982:	f822                	sd	s0,48(sp)
    80008984:	f426                	sd	s1,40(sp)
    80008986:	f04a                	sd	s2,32(sp)
    80008988:	ec4e                	sd	s3,24(sp)
    8000898a:	e852                	sd	s4,16(sp)
    8000898c:	e456                	sd	s5,8(sp)
    8000898e:	0080                	addi	s0,sp,64
    80008990:	892a                	mv	s2,a0
    80008992:	00002517          	auipc	a0,0x2
    80008996:	68e50513          	addi	a0,a0,1678 # 8000b020 <etext+0x20>
    8000899a:	ffff8097          	auipc	ra,0xffff8
    8000899e:	c10080e7          	jalr	-1008(ra) # 800005aa <printf>
    800089a2:	00594803          	lbu	a6,5(s2)
    800089a6:	00494783          	lbu	a5,4(s2)
    800089aa:	00394703          	lbu	a4,3(s2)
    800089ae:	00294683          	lbu	a3,2(s2)
    800089b2:	00194603          	lbu	a2,1(s2)
    800089b6:	00094583          	lbu	a1,0(s2)
    800089ba:	00003517          	auipc	a0,0x3
    800089be:	1b650513          	addi	a0,a0,438 # 8000bb70 <etext+0xb70>
    800089c2:	ffff8097          	auipc	ra,0xffff8
    800089c6:	be8080e7          	jalr	-1048(ra) # 800005aa <printf>
    800089ca:	00b94803          	lbu	a6,11(s2)
    800089ce:	00a94783          	lbu	a5,10(s2)
    800089d2:	00994703          	lbu	a4,9(s2)
    800089d6:	00894683          	lbu	a3,8(s2)
    800089da:	00794603          	lbu	a2,7(s2)
    800089de:	00694583          	lbu	a1,6(s2)
    800089e2:	00003517          	auipc	a0,0x3
    800089e6:	1ae50513          	addi	a0,a0,430 # 8000bb90 <etext+0xb90>
    800089ea:	ffff8097          	auipc	ra,0xffff8
    800089ee:	bc0080e7          	jalr	-1088(ra) # 800005aa <printf>
    800089f2:	00c94683          	lbu	a3,12(s2)
    800089f6:	00d94783          	lbu	a5,13(s2)
    800089fa:	07a2                	slli	a5,a5,0x8
    800089fc:	00d7e733          	or	a4,a5,a3
    80008a00:	60800693          	li	a3,1544
    80008a04:	06d70563          	beq	a4,a3,80008a6e <print_eth_frame+0xf0>
    80008a08:	0007069b          	sext.w	a3,a4
    80008a0c:	67b9                	lui	a5,0xe
    80008a0e:	d0878793          	addi	a5,a5,-760 # dd08 <_entry-0x7fff22f8>
    80008a12:	06f68763          	beq	a3,a5,80008a80 <print_eth_frame+0x102>
    80008a16:	47a1                	li	a5,8
    80008a18:	00f69a63          	bne	a3,a5,80008a2c <print_eth_frame+0xae>
    80008a1c:	00003517          	auipc	a0,0x3
    80008a20:	19450513          	addi	a0,a0,404 # 8000bbb0 <etext+0xbb0>
    80008a24:	ffff8097          	auipc	ra,0xffff8
    80008a28:	b86080e7          	jalr	-1146(ra) # 800005aa <printf>
    80008a2c:	5ea94783          	lbu	a5,1514(s2)
    80008a30:	4481                	li	s1,0
    80008a32:	00003997          	auipc	s3,0x3
    80008a36:	1ae98993          	addi	s3,s3,430 # 8000bbe0 <etext+0xbe0>
    80008a3a:	66666a37          	lui	s4,0x66666
    80008a3e:	667a0a13          	addi	s4,s4,1639 # 66666667 <_entry-0x19999999>
    80008a42:	00003a97          	auipc	s5,0x3
    80008a46:	1a6a8a93          	addi	s5,s5,422 # 8000bbe8 <etext+0xbe8>
    80008a4a:	ebb9                	bnez	a5,80008aa0 <print_eth_frame+0x122>
    80008a4c:	00002517          	auipc	a0,0x2
    80008a50:	5d450513          	addi	a0,a0,1492 # 8000b020 <etext+0x20>
    80008a54:	ffff8097          	auipc	ra,0xffff8
    80008a58:	b56080e7          	jalr	-1194(ra) # 800005aa <printf>
    80008a5c:	70e2                	ld	ra,56(sp)
    80008a5e:	7442                	ld	s0,48(sp)
    80008a60:	74a2                	ld	s1,40(sp)
    80008a62:	7902                	ld	s2,32(sp)
    80008a64:	69e2                	ld	s3,24(sp)
    80008a66:	6a42                	ld	s4,16(sp)
    80008a68:	6aa2                	ld	s5,8(sp)
    80008a6a:	6121                	addi	sp,sp,64
    80008a6c:	8082                	ret
    80008a6e:	00003517          	auipc	a0,0x3
    80008a72:	15250513          	addi	a0,a0,338 # 8000bbc0 <etext+0xbc0>
    80008a76:	ffff8097          	auipc	ra,0xffff8
    80008a7a:	b34080e7          	jalr	-1228(ra) # 800005aa <printf>
    80008a7e:	b77d                	j	80008a2c <print_eth_frame+0xae>
    80008a80:	00003517          	auipc	a0,0x3
    80008a84:	15050513          	addi	a0,a0,336 # 8000bbd0 <etext+0xbd0>
    80008a88:	ffff8097          	auipc	ra,0xffff8
    80008a8c:	b22080e7          	jalr	-1246(ra) # 800005aa <printf>
    80008a90:	bf71                	j	80008a2c <print_eth_frame+0xae>
    80008a92:	0485                	addi	s1,s1,1
    80008a94:	5ea94703          	lbu	a4,1514(s2)
    80008a98:	0004879b          	sext.w	a5,s1
    80008a9c:	fae7d8e3          	bge	a5,a4,80008a4c <print_eth_frame+0xce>
    80008aa0:	009907b3          	add	a5,s2,s1
    80008aa4:	00e7c583          	lbu	a1,14(a5)
    80008aa8:	854e                	mv	a0,s3
    80008aaa:	ffff8097          	auipc	ra,0xffff8
    80008aae:	b00080e7          	jalr	-1280(ra) # 800005aa <printf>
    80008ab2:	0004879b          	sext.w	a5,s1
    80008ab6:	fcf05ee3          	blez	a5,80008a92 <print_eth_frame+0x114>
    80008aba:	034787b3          	mul	a5,a5,s4
    80008abe:	9791                	srai	a5,a5,0x24
    80008ac0:	41f4d71b          	sraiw	a4,s1,0x1f
    80008ac4:	9f99                	subw	a5,a5,a4
    80008ac6:	0027971b          	slliw	a4,a5,0x2
    80008aca:	9fb9                	addw	a5,a5,a4
    80008acc:	0037979b          	slliw	a5,a5,0x3
    80008ad0:	40f487bb          	subw	a5,s1,a5
    80008ad4:	ffdd                	bnez	a5,80008a92 <print_eth_frame+0x114>
    80008ad6:	8556                	mv	a0,s5
    80008ad8:	ffff8097          	auipc	ra,0xffff8
    80008adc:	ad2080e7          	jalr	-1326(ra) # 800005aa <printf>
    80008ae0:	bf4d                	j	80008a92 <print_eth_frame+0x114>

0000000080008ae2 <parse_eth_packet>:
    80008ae2:	7179                	addi	sp,sp,-48
    80008ae4:	f406                	sd	ra,40(sp)
    80008ae6:	f022                	sd	s0,32(sp)
    80008ae8:	ec26                	sd	s1,24(sp)
    80008aea:	e84a                	sd	s2,16(sp)
    80008aec:	e44e                	sd	s3,8(sp)
    80008aee:	1800                	addi	s0,sp,48
    80008af0:	89aa                	mv	s3,a0
    80008af2:	8932                	mv	s2,a2
    80008af4:	ff25849b          	addiw	s1,a1,-14
    80008af8:	14c2                	slli	s1,s1,0x30
    80008afa:	90c1                	srli	s1,s1,0x30
    80008afc:	4639                	li	a2,14
    80008afe:	85aa                	mv	a1,a0
    80008b00:	854a                	mv	a0,s2
    80008b02:	ffff8097          	auipc	ra,0xffff8
    80008b06:	366080e7          	jalr	870(ra) # 80000e68 <memmove>
    80008b0a:	8626                	mv	a2,s1
    80008b0c:	00e98593          	addi	a1,s3,14
    80008b10:	00e90513          	addi	a0,s2,14
    80008b14:	ffff8097          	auipc	ra,0xffff8
    80008b18:	354080e7          	jalr	852(ra) # 80000e68 <memmove>
    80008b1c:	5e990523          	sb	s1,1514(s2)
    80008b20:	4501                	li	a0,0
    80008b22:	70a2                	ld	ra,40(sp)
    80008b24:	7402                	ld	s0,32(sp)
    80008b26:	64e2                	ld	s1,24(sp)
    80008b28:	6942                	ld	s2,16(sp)
    80008b2a:	69a2                	ld	s3,8(sp)
    80008b2c:	6145                	addi	sp,sp,48
    80008b2e:	8082                	ret

0000000080008b30 <build_eth>:
    80008b30:	7179                	addi	sp,sp,-48
    80008b32:	f406                	sd	ra,40(sp)
    80008b34:	f022                	sd	s0,32(sp)
    80008b36:	ec26                	sd	s1,24(sp)
    80008b38:	e84a                	sd	s2,16(sp)
    80008b3a:	e44e                	sd	s3,8(sp)
    80008b3c:	1800                	addi	s0,sp,48
    80008b3e:	84aa                	mv	s1,a0
    80008b40:	89b2                	mv	s3,a2
    80008b42:	8936                	mv	s2,a3
    80008b44:	4619                	li	a2,6
    80008b46:	ffff8097          	auipc	ra,0xffff8
    80008b4a:	322080e7          	jalr	802(ra) # 80000e68 <memmove>
    80008b4e:	4619                	li	a2,6
    80008b50:	85ce                	mv	a1,s3
    80008b52:	00c48533          	add	a0,s1,a2
    80008b56:	ffff8097          	auipc	ra,0xffff8
    80008b5a:	312080e7          	jalr	786(ra) # 80000e68 <memmove>
    80008b5e:	0089579b          	srliw	a5,s2,0x8
    80008b62:	00f48623          	sb	a5,12(s1)
    80008b66:	012486a3          	sb	s2,13(s1)
    80008b6a:	70a2                	ld	ra,40(sp)
    80008b6c:	7402                	ld	s0,32(sp)
    80008b6e:	64e2                	ld	s1,24(sp)
    80008b70:	6942                	ld	s2,16(sp)
    80008b72:	69a2                	ld	s3,8(sp)
    80008b74:	6145                	addi	sp,sp,48
    80008b76:	8082                	ret

0000000080008b78 <tcp_bind>:
    80008b78:	7139                	addi	sp,sp,-64
    80008b7a:	fc06                	sd	ra,56(sp)
    80008b7c:	f822                	sd	s0,48(sp)
    80008b7e:	e05a                	sd	s6,0(sp)
    80008b80:	0080                	addi	s0,sp,64
    80008b82:	c5f9                	beqz	a1,80008c50 <tcp_bind+0xd8>
    80008b84:	f426                	sd	s1,40(sp)
    80008b86:	f04a                	sd	s2,32(sp)
    80008b88:	ec4e                	sd	s3,24(sp)
    80008b8a:	84aa                	mv	s1,a0
    80008b8c:	892e                	mv	s2,a1
    80008b8e:	0025d583          	lhu	a1,2(a1)
    80008b92:	0085d99b          	srliw	s3,a1,0x8
    80008b96:	0085979b          	slliw	a5,a1,0x8
    80008b9a:	00f9e9b3          	or	s3,s3,a5
    80008b9e:	19c2                	slli	s3,s3,0x30
    80008ba0:	0309d993          	srli	s3,s3,0x30
    80008ba4:	0005871b          	sext.w	a4,a1
    80008ba8:	20000793          	li	a5,512
    80008bac:	0ae7ec63          	bltu	a5,a4,80008c64 <tcp_bind+0xec>
    80008bb0:	e456                	sd	s5,8(sp)
    80008bb2:	00098a9b          	sext.w	s5,s3
    80008bb6:	00399713          	slli	a4,s3,0x3
    80008bba:	00065797          	auipc	a5,0x65
    80008bbe:	7de78793          	addi	a5,a5,2014 # 8006e398 <tcp_port_binds>
    80008bc2:	97ba                	add	a5,a5,a4
    80008bc4:	639c                	ld	a5,0(a5)
    80008bc6:	efc5                	bnez	a5,80008c7e <tcp_bind+0x106>
    80008bc8:	00095783          	lhu	a5,0(s2)
    80008bcc:	00078b1b          	sext.w	s6,a5
    80008bd0:	dd1c                	sw	a5,56(a0)
    80008bd2:	140b1c63          	bnez	s6,80008d2a <tcp_bind+0x1b2>
    80008bd6:	47c1                	li	a5,16
    80008bd8:	0cf61163          	bne	a2,a5,80008c9a <tcp_bind+0x122>
    80008bdc:	003a9713          	slli	a4,s5,0x3
    80008be0:	00065797          	auipc	a5,0x65
    80008be4:	7b878793          	addi	a5,a5,1976 # 8006e398 <tcp_port_binds>
    80008be8:	97ba                	add	a5,a5,a4
    80008bea:	639c                	ld	a5,0(a5)
    80008bec:	e7e9                	bnez	a5,80008cb6 <tcp_bind+0x13e>
    80008bee:	e852                	sd	s4,16(sp)
    80008bf0:	ffff8097          	auipc	ra,0xffff8
    80008bf4:	012080e7          	jalr	18(ra) # 80000c02 <kalloc>
    80008bf8:	8a2a                	mv	s4,a0
    80008bfa:	cd69                	beqz	a0,80008cd4 <tcp_bind+0x15c>
    80008bfc:	01351123          	sh	s3,2(a0)
    80008c00:	00492783          	lw	a5,4(s2)
    80008c04:	4705                	li	a4,1
    80008c06:	0ee78663          	beq	a5,a4,80008cf2 <tcp_bind+0x17a>
    80008c0a:	00f51023          	sh	a5,0(a0)
    80008c0e:	00492783          	lw	a5,4(s2)
    80008c12:	d09c                	sw	a5,32(s1)
    80008c14:	009a3423          	sd	s1,8(s4)
    80008c18:	8552                	mv	a0,s4
    80008c1a:	fffff097          	auipc	ra,0xfffff
    80008c1e:	5ee080e7          	jalr	1518(ra) # 80008208 <insert_port_binding>
    80008c22:	89aa                	mv	s3,a0
    80008c24:	57fd                	li	a5,-1
    80008c26:	0cf50e63          	beq	a0,a5,80008d02 <tcp_bind+0x18a>
    80008c2a:	0354a423          	sw	s5,40(s1)
    80008c2e:	00095783          	lhu	a5,0(s2)
    80008c32:	dc9c                	sw	a5,56(s1)
    80008c34:	03300793          	li	a5,51
    80008c38:	dcdc                	sw	a5,60(s1)
    80008c3a:	74a2                	ld	s1,40(sp)
    80008c3c:	7902                	ld	s2,32(sp)
    80008c3e:	69e2                	ld	s3,24(sp)
    80008c40:	6a42                	ld	s4,16(sp)
    80008c42:	6aa2                	ld	s5,8(sp)
    80008c44:	855a                	mv	a0,s6
    80008c46:	70e2                	ld	ra,56(sp)
    80008c48:	7442                	ld	s0,48(sp)
    80008c4a:	6b02                	ld	s6,0(sp)
    80008c4c:	6121                	addi	sp,sp,64
    80008c4e:	8082                	ret
    80008c50:	00003517          	auipc	a0,0x3
    80008c54:	fa050513          	addi	a0,a0,-96 # 8000bbf0 <etext+0xbf0>
    80008c58:	ffff8097          	auipc	ra,0xffff8
    80008c5c:	952080e7          	jalr	-1710(ra) # 800005aa <printf>
    80008c60:	5b7d                	li	s6,-1
    80008c62:	b7cd                	j	80008c44 <tcp_bind+0xcc>
    80008c64:	00003517          	auipc	a0,0x3
    80008c68:	fa450513          	addi	a0,a0,-92 # 8000bc08 <etext+0xc08>
    80008c6c:	ffff8097          	auipc	ra,0xffff8
    80008c70:	93e080e7          	jalr	-1730(ra) # 800005aa <printf>
    80008c74:	5b7d                	li	s6,-1
    80008c76:	74a2                	ld	s1,40(sp)
    80008c78:	7902                	ld	s2,32(sp)
    80008c7a:	69e2                	ld	s3,24(sp)
    80008c7c:	b7e1                	j	80008c44 <tcp_bind+0xcc>
    80008c7e:	00003517          	auipc	a0,0x3
    80008c82:	fba50513          	addi	a0,a0,-70 # 8000bc38 <etext+0xc38>
    80008c86:	ffff8097          	auipc	ra,0xffff8
    80008c8a:	924080e7          	jalr	-1756(ra) # 800005aa <printf>
    80008c8e:	5b7d                	li	s6,-1
    80008c90:	74a2                	ld	s1,40(sp)
    80008c92:	7902                	ld	s2,32(sp)
    80008c94:	69e2                	ld	s3,24(sp)
    80008c96:	6aa2                	ld	s5,8(sp)
    80008c98:	b775                	j	80008c44 <tcp_bind+0xcc>
    80008c9a:	00003517          	auipc	a0,0x3
    80008c9e:	fc650513          	addi	a0,a0,-58 # 8000bc60 <etext+0xc60>
    80008ca2:	ffff8097          	auipc	ra,0xffff8
    80008ca6:	908080e7          	jalr	-1784(ra) # 800005aa <printf>
    80008caa:	5b7d                	li	s6,-1
    80008cac:	74a2                	ld	s1,40(sp)
    80008cae:	7902                	ld	s2,32(sp)
    80008cb0:	69e2                	ld	s3,24(sp)
    80008cb2:	6aa2                	ld	s5,8(sp)
    80008cb4:	bf41                	j	80008c44 <tcp_bind+0xcc>
    80008cb6:	85d6                	mv	a1,s5
    80008cb8:	00003517          	auipc	a0,0x3
    80008cbc:	fd050513          	addi	a0,a0,-48 # 8000bc88 <etext+0xc88>
    80008cc0:	ffff8097          	auipc	ra,0xffff8
    80008cc4:	8ea080e7          	jalr	-1814(ra) # 800005aa <printf>
    80008cc8:	5b7d                	li	s6,-1
    80008cca:	74a2                	ld	s1,40(sp)
    80008ccc:	7902                	ld	s2,32(sp)
    80008cce:	69e2                	ld	s3,24(sp)
    80008cd0:	6aa2                	ld	s5,8(sp)
    80008cd2:	bf8d                	j	80008c44 <tcp_bind+0xcc>
    80008cd4:	00002517          	auipc	a0,0x2
    80008cd8:	7a450513          	addi	a0,a0,1956 # 8000b478 <etext+0x478>
    80008cdc:	ffff8097          	auipc	ra,0xffff8
    80008ce0:	8ce080e7          	jalr	-1842(ra) # 800005aa <printf>
    80008ce4:	5b7d                	li	s6,-1
    80008ce6:	74a2                	ld	s1,40(sp)
    80008ce8:	7902                	ld	s2,32(sp)
    80008cea:	69e2                	ld	s3,24(sp)
    80008cec:	6a42                	ld	s4,16(sp)
    80008cee:	6aa2                	ld	s5,8(sp)
    80008cf0:	bf91                	j	80008c44 <tcp_bind+0xcc>
    80008cf2:	00004797          	auipc	a5,0x4
    80008cf6:	bb67a783          	lw	a5,-1098(a5) # 8000c8a8 <netconf>
    80008cfa:	d09c                	sw	a5,32(s1)
    80008cfc:	00f51023          	sh	a5,0(a0)
    80008d00:	bf11                	j	80008c14 <tcp_bind+0x9c>
    80008d02:	00003517          	auipc	a0,0x3
    80008d06:	f9e50513          	addi	a0,a0,-98 # 8000bca0 <etext+0xca0>
    80008d0a:	ffff8097          	auipc	ra,0xffff8
    80008d0e:	8a0080e7          	jalr	-1888(ra) # 800005aa <printf>
    80008d12:	8552                	mv	a0,s4
    80008d14:	ffff8097          	auipc	ra,0xffff8
    80008d18:	d86080e7          	jalr	-634(ra) # 80000a9a <kfree>
    80008d1c:	8b4e                	mv	s6,s3
    80008d1e:	74a2                	ld	s1,40(sp)
    80008d20:	7902                	ld	s2,32(sp)
    80008d22:	69e2                	ld	s3,24(sp)
    80008d24:	6a42                	ld	s4,16(sp)
    80008d26:	6aa2                	ld	s5,8(sp)
    80008d28:	bf31                	j	80008c44 <tcp_bind+0xcc>
    80008d2a:	5b7d                	li	s6,-1
    80008d2c:	74a2                	ld	s1,40(sp)
    80008d2e:	7902                	ld	s2,32(sp)
    80008d30:	69e2                	ld	s3,24(sp)
    80008d32:	6aa2                	ld	s5,8(sp)
    80008d34:	bf01                	j	80008c44 <tcp_bind+0xcc>

0000000080008d36 <tcp_connect>:
    80008d36:	1141                	addi	sp,sp,-16
    80008d38:	e406                	sd	ra,8(sp)
    80008d3a:	e022                	sd	s0,0(sp)
    80008d3c:	0800                	addi	s0,sp,16
    80008d3e:	4501                	li	a0,0
    80008d40:	60a2                	ld	ra,8(sp)
    80008d42:	6402                	ld	s0,0(sp)
    80008d44:	0141                	addi	sp,sp,16
    80008d46:	8082                	ret

0000000080008d48 <tcp_listen>:
    80008d48:	1141                	addi	sp,sp,-16
    80008d4a:	e406                	sd	ra,8(sp)
    80008d4c:	e022                	sd	s0,0(sp)
    80008d4e:	0800                	addi	s0,sp,16
    80008d50:	5958                	lw	a4,52(a0)
    80008d52:	4785                	li	a5,1
    80008d54:	00f71f63          	bne	a4,a5,80008d72 <tcp_listen+0x2a>
    80008d58:	5d58                	lw	a4,60(a0)
    80008d5a:	03300793          	li	a5,51
    80008d5e:	02f71463          	bne	a4,a5,80008d86 <tcp_listen+0x3e>
    80008d62:	03400793          	li	a5,52
    80008d66:	dd5c                	sw	a5,60(a0)
    80008d68:	4501                	li	a0,0
    80008d6a:	60a2                	ld	ra,8(sp)
    80008d6c:	6402                	ld	s0,0(sp)
    80008d6e:	0141                	addi	sp,sp,16
    80008d70:	8082                	ret
    80008d72:	00003517          	auipc	a0,0x3
    80008d76:	f4e50513          	addi	a0,a0,-178 # 8000bcc0 <etext+0xcc0>
    80008d7a:	ffff8097          	auipc	ra,0xffff8
    80008d7e:	830080e7          	jalr	-2000(ra) # 800005aa <printf>
    80008d82:	557d                	li	a0,-1
    80008d84:	b7dd                	j	80008d6a <tcp_listen+0x22>
    80008d86:	00003517          	auipc	a0,0x3
    80008d8a:	f6a50513          	addi	a0,a0,-150 # 8000bcf0 <etext+0xcf0>
    80008d8e:	ffff8097          	auipc	ra,0xffff8
    80008d92:	81c080e7          	jalr	-2020(ra) # 800005aa <printf>
    80008d96:	557d                	li	a0,-1
    80008d98:	bfc9                	j	80008d6a <tcp_listen+0x22>

0000000080008d9a <tcp_accept>:
    80008d9a:	1141                	addi	sp,sp,-16
    80008d9c:	e406                	sd	ra,8(sp)
    80008d9e:	e022                	sd	s0,0(sp)
    80008da0:	0800                	addi	s0,sp,16
    80008da2:	4501                	li	a0,0
    80008da4:	60a2                	ld	ra,8(sp)
    80008da6:	6402                	ld	s0,0(sp)
    80008da8:	0141                	addi	sp,sp,16
    80008daa:	8082                	ret

0000000080008dac <tcp_close>:
    80008dac:	1141                	addi	sp,sp,-16
    80008dae:	e406                	sd	ra,8(sp)
    80008db0:	e022                	sd	s0,0(sp)
    80008db2:	0800                	addi	s0,sp,16
    80008db4:	4501                	li	a0,0
    80008db6:	60a2                	ld	ra,8(sp)
    80008db8:	6402                	ld	s0,0(sp)
    80008dba:	0141                	addi	sp,sp,16
    80008dbc:	8082                	ret

0000000080008dbe <build_tcp>:
    80008dbe:	1101                	addi	sp,sp,-32
    80008dc0:	ec06                	sd	ra,24(sp)
    80008dc2:	e822                	sd	s0,16(sp)
    80008dc4:	e426                	sd	s1,8(sp)
    80008dc6:	e04a                	sd	s2,0(sp)
    80008dc8:	1000                	addi	s0,sp,32
    80008dca:	84aa                	mv	s1,a0
    80008dcc:	852e                	mv	a0,a1
    80008dce:	85c6                	mv	a1,a7
    80008dd0:	00042903          	lw	s2,0(s0)
    80008dd4:	0085589b          	srliw	a7,a0,0x8
    80008dd8:	01148023          	sb	a7,0(s1)
    80008ddc:	00a480a3          	sb	a0,1(s1)
    80008de0:	0086551b          	srliw	a0,a2,0x8
    80008de4:	00a48123          	sb	a0,2(s1)
    80008de8:	00c481a3          	sb	a2,3(s1)
    80008dec:	0186961b          	slliw	a2,a3,0x18
    80008df0:	0186d51b          	srliw	a0,a3,0x18
    80008df4:	8e49                	or	a2,a2,a0
    80008df6:	0086951b          	slliw	a0,a3,0x8
    80008dfa:	00ff08b7          	lui	a7,0xff0
    80008dfe:	01157533          	and	a0,a0,a7
    80008e02:	8e49                	or	a2,a2,a0
    80008e04:	0086d69b          	srliw	a3,a3,0x8
    80008e08:	6541                	lui	a0,0x10
    80008e0a:	f0050513          	addi	a0,a0,-256 # ff00 <_entry-0x7fff0100>
    80008e0e:	8ee9                	and	a3,a3,a0
    80008e10:	00c48223          	sb	a2,4(s1)
    80008e14:	82a1                	srli	a3,a3,0x8
    80008e16:	00d482a3          	sb	a3,5(s1)
    80008e1a:	0106569b          	srliw	a3,a2,0x10
    80008e1e:	00d48323          	sb	a3,6(s1)
    80008e22:	0186561b          	srliw	a2,a2,0x18
    80008e26:	00c483a3          	sb	a2,7(s1)
    80008e2a:	0187169b          	slliw	a3,a4,0x18
    80008e2e:	0187561b          	srliw	a2,a4,0x18
    80008e32:	8ed1                	or	a3,a3,a2
    80008e34:	0087161b          	slliw	a2,a4,0x8
    80008e38:	01167633          	and	a2,a2,a7
    80008e3c:	8ed1                	or	a3,a3,a2
    80008e3e:	0087571b          	srliw	a4,a4,0x8
    80008e42:	8f69                	and	a4,a4,a0
    80008e44:	00d48423          	sb	a3,8(s1)
    80008e48:	8321                	srli	a4,a4,0x8
    80008e4a:	00e484a3          	sb	a4,9(s1)
    80008e4e:	0106d71b          	srliw	a4,a3,0x10
    80008e52:	00e48523          	sb	a4,10(s1)
    80008e56:	0186d69b          	srliw	a3,a3,0x18
    80008e5a:	00d485a3          	sb	a3,11(s1)
    80008e5e:	05000713          	li	a4,80
    80008e62:	00e48623          	sb	a4,12(s1)
    80008e66:	00f486a3          	sb	a5,13(s1)
    80008e6a:	0088579b          	srliw	a5,a6,0x8
    80008e6e:	00f48723          	sb	a5,14(s1)
    80008e72:	010487a3          	sb	a6,15(s1)
    80008e76:	00048823          	sb	zero,16(s1)
    80008e7a:	000488a3          	sb	zero,17(s1)
    80008e7e:	00048923          	sb	zero,18(s1)
    80008e82:	000489a3          	sb	zero,19(s1)
    80008e86:	864a                	mv	a2,s2
    80008e88:	01448513          	addi	a0,s1,20
    80008e8c:	ffff8097          	auipc	ra,0xffff8
    80008e90:	fdc080e7          	jalr	-36(ra) # 80000e68 <memmove>
    80008e94:	5f248823          	sb	s2,1520(s1)
    80008e98:	0089579b          	srliw	a5,s2,0x8
    80008e9c:	5ef488a3          	sb	a5,1521(s1)
    80008ea0:	0109579b          	srliw	a5,s2,0x10
    80008ea4:	5ef48923          	sb	a5,1522(s1)
    80008ea8:	0189591b          	srliw	s2,s2,0x18
    80008eac:	5f2489a3          	sb	s2,1523(s1)
    80008eb0:	60e2                	ld	ra,24(sp)
    80008eb2:	6442                	ld	s0,16(sp)
    80008eb4:	64a2                	ld	s1,8(sp)
    80008eb6:	6902                	ld	s2,0(sp)
    80008eb8:	6105                	addi	sp,sp,32
    80008eba:	8082                	ret

0000000080008ebc <parse_tcp_packet>:
    80008ebc:	474d                	li	a4,19
    80008ebe:	12b75963          	bge	a4,a1,80008ff0 <parse_tcp_packet+0x134>
    80008ec2:	87b2                	mv	a5,a2
    80008ec4:	00055703          	lhu	a4,0(a0)
    80008ec8:	00875693          	srli	a3,a4,0x8
    80008ecc:	00d60023          	sb	a3,0(a2) # 1000 <_entry-0x7ffff000>
    80008ed0:	00e600a3          	sb	a4,1(a2)
    80008ed4:	00255703          	lhu	a4,2(a0)
    80008ed8:	00875693          	srli	a3,a4,0x8
    80008edc:	00d60123          	sb	a3,2(a2)
    80008ee0:	00e601a3          	sb	a4,3(a2)
    80008ee4:	4158                	lw	a4,4(a0)
    80008ee6:	0187169b          	slliw	a3,a4,0x18
    80008eea:	0187561b          	srliw	a2,a4,0x18
    80008eee:	8ed1                	or	a3,a3,a2
    80008ef0:	0087161b          	slliw	a2,a4,0x8
    80008ef4:	00ff08b7          	lui	a7,0xff0
    80008ef8:	01167633          	and	a2,a2,a7
    80008efc:	8ed1                	or	a3,a3,a2
    80008efe:	0087571b          	srliw	a4,a4,0x8
    80008f02:	6641                	lui	a2,0x10
    80008f04:	f0060613          	addi	a2,a2,-256 # ff00 <_entry-0x7fff0100>
    80008f08:	8f71                	and	a4,a4,a2
    80008f0a:	00d78223          	sb	a3,4(a5)
    80008f0e:	8321                	srli	a4,a4,0x8
    80008f10:	00e782a3          	sb	a4,5(a5)
    80008f14:	0106d71b          	srliw	a4,a3,0x10
    80008f18:	00e78323          	sb	a4,6(a5)
    80008f1c:	0186d69b          	srliw	a3,a3,0x18
    80008f20:	00d783a3          	sb	a3,7(a5)
    80008f24:	4518                	lw	a4,8(a0)
    80008f26:	0187169b          	slliw	a3,a4,0x18
    80008f2a:	0187581b          	srliw	a6,a4,0x18
    80008f2e:	0106e6b3          	or	a3,a3,a6
    80008f32:	0087181b          	slliw	a6,a4,0x8
    80008f36:	01187833          	and	a6,a6,a7
    80008f3a:	0106e6b3          	or	a3,a3,a6
    80008f3e:	0087571b          	srliw	a4,a4,0x8
    80008f42:	8f71                	and	a4,a4,a2
    80008f44:	00d78423          	sb	a3,8(a5)
    80008f48:	8321                	srli	a4,a4,0x8
    80008f4a:	00e784a3          	sb	a4,9(a5)
    80008f4e:	0106d71b          	srliw	a4,a3,0x10
    80008f52:	00e78523          	sb	a4,10(a5)
    80008f56:	0186d69b          	srliw	a3,a3,0x18
    80008f5a:	00d785a3          	sb	a3,11(a5)
    80008f5e:	00c54703          	lbu	a4,12(a0)
    80008f62:	8311                	srli	a4,a4,0x4
    80008f64:	00e78623          	sb	a4,12(a5)
    80008f68:	00d54683          	lbu	a3,13(a0)
    80008f6c:	00d786a3          	sb	a3,13(a5)
    80008f70:	00e55683          	lhu	a3,14(a0)
    80008f74:	0086d613          	srli	a2,a3,0x8
    80008f78:	00c78723          	sb	a2,14(a5)
    80008f7c:	00d787a3          	sb	a3,15(a5)
    80008f80:	01055683          	lhu	a3,16(a0)
    80008f84:	0086d613          	srli	a2,a3,0x8
    80008f88:	00c78823          	sb	a2,16(a5)
    80008f8c:	00d788a3          	sb	a3,17(a5)
    80008f90:	01255683          	lhu	a3,18(a0)
    80008f94:	0086d613          	srli	a2,a3,0x8
    80008f98:	00c78923          	sb	a2,18(a5)
    80008f9c:	00d789a3          	sb	a3,19(a5)
    80008fa0:	0027171b          	slliw	a4,a4,0x2
    80008fa4:	464d                	li	a2,19
    80008fa6:	04e65763          	bge	a2,a4,80008ff4 <parse_tcp_packet+0x138>
    80008faa:	04e5c763          	blt	a1,a4,80008ff8 <parse_tcp_packet+0x13c>
    80008fae:	1141                	addi	sp,sp,-16
    80008fb0:	e406                	sd	ra,8(sp)
    80008fb2:	e022                	sd	s0,0(sp)
    80008fb4:	0800                	addi	s0,sp,16
    80008fb6:	40e5863b          	subw	a2,a1,a4
    80008fba:	5ec78823          	sb	a2,1520(a5)
    80008fbe:	0086569b          	srliw	a3,a2,0x8
    80008fc2:	5ed788a3          	sb	a3,1521(a5)
    80008fc6:	0106569b          	srliw	a3,a2,0x10
    80008fca:	5ed78923          	sb	a3,1522(a5)
    80008fce:	0186569b          	srliw	a3,a2,0x18
    80008fd2:	5ed789a3          	sb	a3,1523(a5)
    80008fd6:	00e505b3          	add	a1,a0,a4
    80008fda:	01478513          	addi	a0,a5,20
    80008fde:	ffff8097          	auipc	ra,0xffff8
    80008fe2:	e8a080e7          	jalr	-374(ra) # 80000e68 <memmove>
    80008fe6:	4501                	li	a0,0
    80008fe8:	60a2                	ld	ra,8(sp)
    80008fea:	6402                	ld	s0,0(sp)
    80008fec:	0141                	addi	sp,sp,16
    80008fee:	8082                	ret
    80008ff0:	557d                	li	a0,-1
    80008ff2:	8082                	ret
    80008ff4:	557d                	li	a0,-1
    80008ff6:	8082                	ret
    80008ff8:	557d                	li	a0,-1
    80008ffa:	8082                	ret

0000000080008ffc <syn>:
    80008ffc:	7119                	addi	sp,sp,-128
    80008ffe:	fc86                	sd	ra,120(sp)
    80009000:	f8a2                	sd	s0,112(sp)
    80009002:	ecce                	sd	s3,88(sp)
    80009004:	e8d2                	sd	s4,80(sp)
    80009006:	e4d6                	sd	s5,72(sp)
    80009008:	e0da                	sd	s6,64(sp)
    8000900a:	0100                	addi	s0,sp,128
    8000900c:	8a2a                	mv	s4,a0
    8000900e:	89ae                	mv	s3,a1
    80009010:	8ab2                	mv	s5,a2
    80009012:	8b36                	mv	s6,a3
    80009014:	f6ceb7b7          	lui	a5,0xf6ceb
    80009018:	06378793          	addi	a5,a5,99 # fffffffff6ceb063 <end+0xffffffff76c7abcb>
    8000901c:	faf42423          	sw	a5,-88(s0)
    80009020:	6795                	lui	a5,0x5
    80009022:	0eb78793          	addi	a5,a5,235 # 50eb <_entry-0x7fffaf15>
    80009026:	faf41623          	sh	a5,-84(s0)
    8000902a:	ffff8097          	auipc	ra,0xffff8
    8000902e:	bd8080e7          	jalr	-1064(ra) # 80000c02 <kalloc>
    80009032:	c16d                	beqz	a0,80009114 <syn+0x118>
    80009034:	f4a6                	sd	s1,104(sp)
    80009036:	f862                	sd	s8,48(sp)
    80009038:	8c2a                	mv	s8,a0
    8000903a:	ffff8097          	auipc	ra,0xffff8
    8000903e:	bc8080e7          	jalr	-1080(ra) # 80000c02 <kalloc>
    80009042:	84aa                	mv	s1,a0
    80009044:	c175                	beqz	a0,80009128 <syn+0x12c>
    80009046:	fc5e                	sd	s7,56(sp)
    80009048:	ffff8097          	auipc	ra,0xffff8
    8000904c:	bba080e7          	jalr	-1094(ra) # 80000c02 <kalloc>
    80009050:	8baa                	mv	s7,a0
    80009052:	c57d                	beqz	a0,80009140 <syn+0x144>
    80009054:	f0ca                	sd	s2,96(sp)
    80009056:	e84e                	sd	s3,16(sp)
    80009058:	00004917          	auipc	s2,0x4
    8000905c:	85090913          	addi	s2,s2,-1968 # 8000c8a8 <netconf>
    80009060:	00092783          	lw	a5,0(s2)
    80009064:	e43e                	sd	a5,8(sp)
    80009066:	e002                	sd	zero,0(sp)
    80009068:	4881                	li	a7,0
    8000906a:	40000813          	li	a6,1024
    8000906e:	4781                	li	a5,0
    80009070:	001b071b          	addiw	a4,s6,1
    80009074:	53900693          	li	a3,1337
    80009078:	8656                	mv	a2,s5
    8000907a:	85d2                	mv	a1,s4
    8000907c:	8562                	mv	a0,s8
    8000907e:	00000097          	auipc	ra,0x0
    80009082:	d40080e7          	jalr	-704(ra) # 80008dbe <build_tcp>
    80009086:	4751                	li	a4,20
    80009088:	4699                	li	a3,6
    8000908a:	864e                	mv	a2,s3
    8000908c:	00092583          	lw	a1,0(s2)
    80009090:	8526                	mv	a0,s1
    80009092:	fffff097          	auipc	ra,0xfffff
    80009096:	ce8080e7          	jalr	-792(ra) # 80007d7a <build_ip4>
    8000909a:	6685                	lui	a3,0x1
    8000909c:	80068693          	addi	a3,a3,-2048 # 800 <_entry-0x7ffff800>
    800090a0:	00004617          	auipc	a2,0x4
    800090a4:	80c60613          	addi	a2,a2,-2036 # 8000c8ac <netconf+0x4>
    800090a8:	fa840593          	addi	a1,s0,-88
    800090ac:	855e                	mv	a0,s7
    800090ae:	00000097          	auipc	ra,0x0
    800090b2:	a82080e7          	jalr	-1406(ra) # 80008b30 <build_eth>
    800090b6:	47d1                	li	a5,20
    800090b8:	5ef48823          	sb	a5,1520(s1)
    800090bc:	5e0488a3          	sb	zero,1521(s1)
    800090c0:	863e                	mv	a2,a5
    800090c2:	85e2                	mv	a1,s8
    800090c4:	00f48533          	add	a0,s1,a5
    800090c8:	ffff8097          	auipc	ra,0xffff8
    800090cc:	da0080e7          	jalr	-608(ra) # 80000e68 <memmove>
    800090d0:	4651                	li	a2,20
    800090d2:	5ecb8523          	sb	a2,1514(s7) # 15ea <_entry-0x7fffea16>
    800090d6:	85a6                	mv	a1,s1
    800090d8:	00eb8513          	addi	a0,s7,14
    800090dc:	ffff8097          	auipc	ra,0xffff8
    800090e0:	d8c080e7          	jalr	-628(ra) # 80000e68 <memmove>
    800090e4:	5eabc583          	lbu	a1,1514(s7)
    800090e8:	6605                	lui	a2,0x1
    800090ea:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    800090ee:	05b9                	addi	a1,a1,14
    800090f0:	855e                	mv	a0,s7
    800090f2:	ffffe097          	auipc	ra,0xffffe
    800090f6:	67a080e7          	jalr	1658(ra) # 8000776c <transmit_packet>
    800090fa:	4501                	li	a0,0
    800090fc:	74a6                	ld	s1,104(sp)
    800090fe:	7906                	ld	s2,96(sp)
    80009100:	7be2                	ld	s7,56(sp)
    80009102:	7c42                	ld	s8,48(sp)
    80009104:	70e6                	ld	ra,120(sp)
    80009106:	7446                	ld	s0,112(sp)
    80009108:	69e6                	ld	s3,88(sp)
    8000910a:	6a46                	ld	s4,80(sp)
    8000910c:	6aa6                	ld	s5,72(sp)
    8000910e:	6b06                	ld	s6,64(sp)
    80009110:	6109                	addi	sp,sp,128
    80009112:	8082                	ret
    80009114:	00003517          	auipc	a0,0x3
    80009118:	bfc50513          	addi	a0,a0,-1028 # 8000bd10 <etext+0xd10>
    8000911c:	ffff7097          	auipc	ra,0xffff7
    80009120:	48e080e7          	jalr	1166(ra) # 800005aa <printf>
    80009124:	557d                	li	a0,-1
    80009126:	bff9                	j	80009104 <syn+0x108>
    80009128:	00003517          	auipc	a0,0x3
    8000912c:	be850513          	addi	a0,a0,-1048 # 8000bd10 <etext+0xd10>
    80009130:	ffff7097          	auipc	ra,0xffff7
    80009134:	47a080e7          	jalr	1146(ra) # 800005aa <printf>
    80009138:	557d                	li	a0,-1
    8000913a:	74a6                	ld	s1,104(sp)
    8000913c:	7c42                	ld	s8,48(sp)
    8000913e:	b7d9                	j	80009104 <syn+0x108>
    80009140:	00003517          	auipc	a0,0x3
    80009144:	bd050513          	addi	a0,a0,-1072 # 8000bd10 <etext+0xd10>
    80009148:	ffff7097          	auipc	ra,0xffff7
    8000914c:	462080e7          	jalr	1122(ra) # 800005aa <printf>
    80009150:	557d                	li	a0,-1
    80009152:	74a6                	ld	s1,104(sp)
    80009154:	7be2                	ld	s7,56(sp)
    80009156:	7c42                	ld	s8,48(sp)
    80009158:	b775                	j	80009104 <syn+0x108>

000000008000915a <handle_tcp_packet>:
    8000915a:	1101                	addi	sp,sp,-32
    8000915c:	ec06                	sd	ra,24(sp)
    8000915e:	e822                	sd	s0,16(sp)
    80009160:	e426                	sd	s1,8(sp)
    80009162:	e04a                	sd	s2,0(sp)
    80009164:	1000                	addi	s0,sp,32
    80009166:	84aa                	mv	s1,a0
    80009168:	00854783          	lbu	a5,8(a0)
    8000916c:	00954703          	lbu	a4,9(a0)
    80009170:	0722                	slli	a4,a4,0x8
    80009172:	8f5d                	or	a4,a4,a5
    80009174:	00a54783          	lbu	a5,10(a0)
    80009178:	07c2                	slli	a5,a5,0x10
    8000917a:	8fd9                	or	a5,a5,a4
    8000917c:	00b54703          	lbu	a4,11(a0)
    80009180:	0762                	slli	a4,a4,0x18
    80009182:	8f5d                	or	a4,a4,a5
    80009184:	00454783          	lbu	a5,4(a0)
    80009188:	00554683          	lbu	a3,5(a0)
    8000918c:	06a2                	slli	a3,a3,0x8
    8000918e:	8edd                	or	a3,a3,a5
    80009190:	00654783          	lbu	a5,6(a0)
    80009194:	07c2                	slli	a5,a5,0x10
    80009196:	8fd5                	or	a5,a5,a3
    80009198:	00754683          	lbu	a3,7(a0)
    8000919c:	06e2                	slli	a3,a3,0x18
    8000919e:	8edd                	or	a3,a3,a5
    800091a0:	00254503          	lbu	a0,2(a0)
    800091a4:	0034c603          	lbu	a2,3(s1)
    800091a8:	0622                	slli	a2,a2,0x8
    800091aa:	0004c583          	lbu	a1,0(s1)
    800091ae:	0014c783          	lbu	a5,1(s1)
    800091b2:	07a2                	slli	a5,a5,0x8
    800091b4:	2701                	sext.w	a4,a4
    800091b6:	2681                	sext.w	a3,a3
    800091b8:	8e49                	or	a2,a2,a0
    800091ba:	8ddd                	or	a1,a1,a5
    800091bc:	00003517          	auipc	a0,0x3
    800091c0:	b6450513          	addi	a0,a0,-1180 # 8000bd20 <etext+0xd20>
    800091c4:	ffff7097          	auipc	ra,0xffff7
    800091c8:	3e6080e7          	jalr	998(ra) # 800005aa <printf>
    800091cc:	0024c703          	lbu	a4,2(s1)
    800091d0:	0034c783          	lbu	a5,3(s1)
    800091d4:	07a2                	slli	a5,a5,0x8
    800091d6:	8fd9                	or	a5,a5,a4
    800091d8:	078e                	slli	a5,a5,0x3
    800091da:	00065717          	auipc	a4,0x65
    800091de:	1be70713          	addi	a4,a4,446 # 8006e398 <tcp_port_binds>
    800091e2:	97ba                	add	a5,a5,a4
    800091e4:	0007b903          	ld	s2,0(a5)
    800091e8:	0a090263          	beqz	s2,8000928c <handle_tcp_packet+0x132>
    800091ec:	00893783          	ld	a5,8(s2)
    800091f0:	5fd4                	lw	a3,60(a5)
    800091f2:	00095603          	lhu	a2,0(s2)
    800091f6:	00295583          	lhu	a1,2(s2)
    800091fa:	00003517          	auipc	a0,0x3
    800091fe:	b5e50513          	addi	a0,a0,-1186 # 8000bd58 <etext+0xd58>
    80009202:	ffff7097          	auipc	ra,0xffff7
    80009206:	3a8080e7          	jalr	936(ra) # 800005aa <printf>
    8000920a:	00d4c783          	lbu	a5,13(s1)
    8000920e:	0487f693          	andi	a3,a5,72
    80009212:	04800713          	li	a4,72
    80009216:	00e68f63          	beq	a3,a4,80009234 <handle_tcp_packet+0xda>
    8000921a:	0087f713          	andi	a4,a5,8
    8000921e:	e70d                	bnez	a4,80009248 <handle_tcp_packet+0xee>
    80009220:	0407f793          	andi	a5,a5,64
    80009224:	4501                	li	a0,0
    80009226:	eba9                	bnez	a5,80009278 <handle_tcp_packet+0x11e>
    80009228:	60e2                	ld	ra,24(sp)
    8000922a:	6442                	ld	s0,16(sp)
    8000922c:	64a2                	ld	s1,8(sp)
    8000922e:	6902                	ld	s2,0(sp)
    80009230:	6105                	addi	sp,sp,32
    80009232:	8082                	ret
    80009234:	00003517          	auipc	a0,0x3
    80009238:	b6c50513          	addi	a0,a0,-1172 # 8000bda0 <etext+0xda0>
    8000923c:	ffff7097          	auipc	ra,0xffff7
    80009240:	36e080e7          	jalr	878(ra) # 800005aa <printf>
    80009244:	4501                	li	a0,0
    80009246:	b7cd                	j	80009228 <handle_tcp_packet+0xce>
    80009248:	00003517          	auipc	a0,0x3
    8000924c:	b7050513          	addi	a0,a0,-1168 # 8000bdb8 <etext+0xdb8>
    80009250:	ffff7097          	auipc	ra,0xffff7
    80009254:	35a080e7          	jalr	858(ra) # 800005aa <printf>
    80009258:	00893783          	ld	a5,8(s2)
    8000925c:	5bd4                	lw	a3,52(a5)
    8000925e:	4719                	li	a4,6
    80009260:	02e69863          	bne	a3,a4,80009290 <handle_tcp_packet+0x136>
    80009264:	5fd4                	lw	a3,60(a5)
    80009266:	03400713          	li	a4,52
    8000926a:	02e69563          	bne	a3,a4,80009294 <handle_tcp_packet+0x13a>
    8000926e:	03600713          	li	a4,54
    80009272:	dfd8                	sw	a4,60(a5)
    80009274:	4501                	li	a0,0
    80009276:	bf4d                	j	80009228 <handle_tcp_packet+0xce>
    80009278:	00003517          	auipc	a0,0x3
    8000927c:	b5050513          	addi	a0,a0,-1200 # 8000bdc8 <etext+0xdc8>
    80009280:	ffff7097          	auipc	ra,0xffff7
    80009284:	32a080e7          	jalr	810(ra) # 800005aa <printf>
    80009288:	4501                	li	a0,0
    8000928a:	bf79                	j	80009228 <handle_tcp_packet+0xce>
    8000928c:	557d                	li	a0,-1
    8000928e:	bf69                	j	80009228 <handle_tcp_packet+0xce>
    80009290:	557d                	li	a0,-1
    80009292:	bf59                	j	80009228 <handle_tcp_packet+0xce>
    80009294:	557d                	li	a0,-1
    80009296:	bf49                	j	80009228 <handle_tcp_packet+0xce>

0000000080009298 <build_udp>:
#include "socket.h"
#include "udp.h"

void
build_udp(struct udp_frame *udp, uint16 src_port, uint16 dst_port, uint8 *payload, int payload_len, uint32 src_ip, uint32 dst_ip)
{
    80009298:	7139                	addi	sp,sp,-64
    8000929a:	fc06                	sd	ra,56(sp)
    8000929c:	f822                	sd	s0,48(sp)
    8000929e:	f426                	sd	s1,40(sp)
    800092a0:	f04a                	sd	s2,32(sp)
    800092a2:	ec4e                	sd	s3,24(sp)
    800092a4:	e852                	sd	s4,16(sp)
    800092a6:	e456                	sd	s5,8(sp)
    800092a8:	0080                	addi	s0,sp,64
    800092aa:	84aa                	mv	s1,a0
    800092ac:	893e                	mv	s2,a5
    800092ae:	89c2                	mv	s3,a6
  return (hostshort >> 8) | (hostshort << 8);
    800092b0:	0085979b          	slliw	a5,a1,0x8
    800092b4:	0085d89b          	srliw	a7,a1,0x8
    800092b8:	0117e7b3          	or	a5,a5,a7
  udp->hdr.src_port = htons(src_port);
    800092bc:	00f51023          	sh	a5,0(a0)
  udp->hdr.dst_port = (dst_port);
    800092c0:	00c51123          	sh	a2,2(a0)
  udp->hdr.len = htons(payload_len + UDP_HDR_SIZE);
    800092c4:	03071a93          	slli	s5,a4,0x30
    800092c8:	030ada93          	srli	s5,s5,0x30
    800092cc:	008a889b          	addiw	a7,s5,8
    800092d0:	0088979b          	slliw	a5,a7,0x8
    800092d4:	0108989b          	slliw	a7,a7,0x10
    800092d8:	0108d89b          	srliw	a7,a7,0x10
    800092dc:	0088d89b          	srliw	a7,a7,0x8
    800092e0:	0117e7b3          	or	a5,a5,a7
    800092e4:	00f51223          	sh	a5,4(a0)
  udp->payload_len = payload_len;
    800092e8:	5ee52223          	sw	a4,1508(a0)
  memmove(udp->payload, payload, payload_len);
    800092ec:	00850a13          	addi	s4,a0,8
    800092f0:	863a                	mv	a2,a4
    800092f2:	85b6                	mv	a1,a3
    800092f4:	8552                	mv	a0,s4
    800092f6:	ffff8097          	auipc	ra,0xffff8
    800092fa:	b72080e7          	jalr	-1166(ra) # 80000e68 <memmove>
  udp->hdr.csum = 0;
    800092fe:	00049323          	sh	zero,6(s1)
  udp->hdr.csum = udp_checksum(src_ip, dst_ip, &udp->hdr, udp->payload, payload_len);
    80009302:	8756                	mv	a4,s5
    80009304:	86d2                	mv	a3,s4
    80009306:	8626                	mv	a2,s1
    80009308:	85ce                	mv	a1,s3
    8000930a:	854a                	mv	a0,s2
    8000930c:	fffff097          	auipc	ra,0xfffff
    80009310:	dc4080e7          	jalr	-572(ra) # 800080d0 <udp_checksum>
    80009314:	00a49323          	sh	a0,6(s1)
}
    80009318:	70e2                	ld	ra,56(sp)
    8000931a:	7442                	ld	s0,48(sp)
    8000931c:	74a2                	ld	s1,40(sp)
    8000931e:	7902                	ld	s2,32(sp)
    80009320:	69e2                	ld	s3,24(sp)
    80009322:	6a42                	ld	s4,16(sp)
    80009324:	6aa2                	ld	s5,8(sp)
    80009326:	6121                	addi	sp,sp,64
    80009328:	8082                	ret

000000008000932a <enqueue_udp_packet>:

void
enqueue_udp_packet(struct udp_frame *pkt, struct socket *sock) 
{
    8000932a:	1141                	addi	sp,sp,-16
    8000932c:	e406                	sd	ra,8(sp)
    8000932e:	e022                	sd	s0,0(sp)
    80009330:	0800                	addi	s0,sp,16
  if (sock->rx_head == 0) {
    80009332:	69bc                	ld	a5,80(a1)
    80009334:	cf99                	beqz	a5,80009352 <enqueue_udp_packet+0x28>
    sock->rx_head = pkt;
    sock->rx_tail = pkt;
  } else {
    struct udp_frame *temp = sock->rx_tail;
    80009336:	6dbc                	ld	a5,88(a1)
    sock->rx_tail = pkt;
    80009338:	eda8                	sd	a0,88(a1)
    pkt->next = temp;
    8000933a:	5ef53423          	sd	a5,1512(a0)
  }
  wakeup(&sock->rx_head);
    8000933e:	05058513          	addi	a0,a1,80
    80009342:	ffff9097          	auipc	ra,0xffff9
    80009346:	3e4080e7          	jalr	996(ra) # 80002726 <wakeup>
}
    8000934a:	60a2                	ld	ra,8(sp)
    8000934c:	6402                	ld	s0,0(sp)
    8000934e:	0141                	addi	sp,sp,16
    80009350:	8082                	ret
    sock->rx_head = pkt;
    80009352:	e9a8                	sd	a0,80(a1)
    sock->rx_tail = pkt;
    80009354:	eda8                	sd	a0,88(a1)
    80009356:	b7e5                	j	8000933e <enqueue_udp_packet+0x14>

0000000080009358 <dequeue_udp_packet>:

struct udp_frame*
dequeue_udp_packet(struct socket *sock)
{
    80009358:	1141                	addi	sp,sp,-16
    8000935a:	e422                	sd	s0,8(sp)
    8000935c:	0800                	addi	s0,sp,16
    8000935e:	87aa                	mv	a5,a0
  struct udp_frame *ret = 0;

  if (sock->rx_head) {
    80009360:	6928                	ld	a0,80(a0)
    80009362:	c509                	beqz	a0,8000936c <dequeue_udp_packet+0x14>
    ret = sock->rx_head;
    sock->rx_head = ret->next;
    80009364:	5e853703          	ld	a4,1512(a0)
    80009368:	ebb8                	sd	a4,80(a5)
    if (sock->rx_head == 0)
    8000936a:	c701                	beqz	a4,80009372 <dequeue_udp_packet+0x1a>
      sock->rx_tail = 0;   // queue is now empty
  }
  return ret;   // caller owns ret and must free after use}
}
    8000936c:	6422                	ld	s0,8(sp)
    8000936e:	0141                	addi	sp,sp,16
    80009370:	8082                	ret
      sock->rx_tail = 0;   // queue is now empty
    80009372:	0407bc23          	sd	zero,88(a5)
  return ret;   // caller owns ret and must free after use}
    80009376:	bfdd                	j	8000936c <dequeue_udp_packet+0x14>

0000000080009378 <udp_bind>:

int 
udp_bind(struct socket *sock, const struct sockaddr *sock_address, socklen_t addrlen) {
    80009378:	7139                	addi	sp,sp,-64
    8000937a:	fc06                	sd	ra,56(sp)
    8000937c:	f822                	sd	s0,48(sp)
    8000937e:	f426                	sd	s1,40(sp)
    80009380:	0080                	addi	s0,sp,64
  if (sock == 0) {
    80009382:	c94d                	beqz	a0,80009434 <udp_bind+0xbc>
    80009384:	ec4e                	sd	s3,24(sp)
    80009386:	e852                	sd	s4,16(sp)
    80009388:	89aa                	mv	s3,a0
    8000938a:	8a2e                	mv	s4,a1
    printf("bind: socket == 0\n");
    return -1;
  } else if (sock_address == 0) {
    8000938c:	cdd5                	beqz	a1,80009448 <udp_bind+0xd0>
  return (netshort >> 8) | (netshort << 8);
    8000938e:	0025d483          	lhu	s1,2(a1)
    80009392:	0084979b          	slliw	a5,s1,0x8
    80009396:	80a1                	srli	s1,s1,0x8
    80009398:	8cdd                	or	s1,s1,a5
    8000939a:	14c2                	slli	s1,s1,0x30
    8000939c:	90c1                	srli	s1,s1,0x30
  }

  const struct sockaddr_in *sockaddr = (struct sockaddr_in *)sock_address;
  uint16 port = ntohs(sockaddr->sin_port);

  if(port <= 0 || port >= MAX_PORT_BINDINGS) {
    8000939e:	fff4879b          	addiw	a5,s1,-1
    800093a2:	17c2                	slli	a5,a5,0x30
    800093a4:	93c1                	srli	a5,a5,0x30
    800093a6:	1fe00713          	li	a4,510
    800093aa:	0af76b63          	bltu	a4,a5,80009460 <udp_bind+0xe8>
    800093ae:	e456                	sd	s5,8(sp)
    printf("bind: port number %d not valid within range\n", port);
    return -1;
  } else if (udp_port_binds[port]) {
    800093b0:	00048a9b          	sext.w	s5,s1
    800093b4:	00349713          	slli	a4,s1,0x3
    800093b8:	00066797          	auipc	a5,0x66
    800093bc:	fe078793          	addi	a5,a5,-32 # 8006f398 <udp_port_binds>
    800093c0:	97ba                	add	a5,a5,a4
    800093c2:	639c                	ld	a5,0(a5)
    800093c4:	ebdd                	bnez	a5,8000947a <udp_bind+0x102>
    printf("bind: port number already bound\n");
    return -1;
  }

  switch(sock->family) {
    800093c6:	5d18                	lw	a4,56(a0)
    800093c8:	4789                	li	a5,2
    800093ca:	12f71b63          	bne	a4,a5,80009500 <udp_bind+0x188>
    case(AF_INET):
      if (addrlen != sizeof(struct sockaddr_in)) {
    800093ce:	47c1                	li	a5,16
    800093d0:	0cf61263          	bne	a2,a5,80009494 <udp_bind+0x11c>
    800093d4:	f04a                	sd	s2,32(sp)
        printf("bind: incorrect addrlen for ipv4\n");
        return -1;
      }

      struct port_binding *binding = (struct port_binding*) kalloc();
    800093d6:	ffff8097          	auipc	ra,0xffff8
    800093da:	82c080e7          	jalr	-2004(ra) # 80000c02 <kalloc>
    800093de:	892a                	mv	s2,a0
      if (binding == 0) {
    800093e0:	c579                	beqz	a0,800094ae <udp_bind+0x136>
        printf("ERROR: kalloc\n");
        return -1;
      }
      binding->port = port;
    800093e2:	00951123          	sh	s1,2(a0)
      if (sockaddr->sin_addr.s_addr == INADDR_ANY) {
    800093e6:	004a2783          	lw	a5,4(s4)
    800093ea:	4705                	li	a4,1
    800093ec:	0ce78f63          	beq	a5,a4,800094ca <udp_bind+0x152>
        sock->src_ip = netconf.ip_addr;
        binding->ip_addr = netconf.ip_addr;
      } else {
        binding->ip_addr = sockaddr->sin_addr.s_addr;
    800093f0:	00f51023          	sh	a5,0(a0)
        sock->src_ip = sockaddr->sin_addr.s_addr;
    800093f4:	004a2783          	lw	a5,4(s4)
    800093f8:	02f9a023          	sw	a5,32(s3)
      }

      binding->sock = sock;
    800093fc:	01393423          	sd	s3,8(s2)

      if (insert_port_binding(binding) == -1){
    80009400:	854a                	mv	a0,s2
    80009402:	fffff097          	auipc	ra,0xfffff
    80009406:	e06080e7          	jalr	-506(ra) # 80008208 <insert_port_binding>
    8000940a:	84aa                	mv	s1,a0
    8000940c:	57fd                	li	a5,-1
    8000940e:	0cf50763          	beq	a0,a5,800094dc <udp_bind+0x164>
        printf("bind: failed to bind to port\n");
        kfree(binding);
        return -1;
      }

      sock->src_port = port;
    80009412:	0359a423          	sw	s5,40(s3)
      sock->state = BOUND;
    80009416:	03300793          	li	a5,51
    8000941a:	02f9ae23          	sw	a5,60(s3)
      return 0;
    8000941e:	4481                	li	s1,0
    80009420:	7902                	ld	s2,32(sp)
    80009422:	69e2                	ld	s3,24(sp)
    80009424:	6a42                	ld	s4,16(sp)
    80009426:	6aa2                	ld	s5,8(sp)
    default:
      return -1;
  }

  return 0;
}
    80009428:	8526                	mv	a0,s1
    8000942a:	70e2                	ld	ra,56(sp)
    8000942c:	7442                	ld	s0,48(sp)
    8000942e:	74a2                	ld	s1,40(sp)
    80009430:	6121                	addi	sp,sp,64
    80009432:	8082                	ret
    printf("bind: socket == 0\n");
    80009434:	00003517          	auipc	a0,0x3
    80009438:	9a450513          	addi	a0,a0,-1628 # 8000bdd8 <etext+0xdd8>
    8000943c:	ffff7097          	auipc	ra,0xffff7
    80009440:	16e080e7          	jalr	366(ra) # 800005aa <printf>
    return -1;
    80009444:	54fd                	li	s1,-1
    80009446:	b7cd                	j	80009428 <udp_bind+0xb0>
    printf("bind: sock_address == 0\n");
    80009448:	00003517          	auipc	a0,0x3
    8000944c:	9a850513          	addi	a0,a0,-1624 # 8000bdf0 <etext+0xdf0>
    80009450:	ffff7097          	auipc	ra,0xffff7
    80009454:	15a080e7          	jalr	346(ra) # 800005aa <printf>
    return -1;
    80009458:	54fd                	li	s1,-1
    8000945a:	69e2                	ld	s3,24(sp)
    8000945c:	6a42                	ld	s4,16(sp)
    8000945e:	b7e9                	j	80009428 <udp_bind+0xb0>
    printf("bind: port number %d not valid within range\n", port);
    80009460:	85a6                	mv	a1,s1
    80009462:	00002517          	auipc	a0,0x2
    80009466:	7a650513          	addi	a0,a0,1958 # 8000bc08 <etext+0xc08>
    8000946a:	ffff7097          	auipc	ra,0xffff7
    8000946e:	140080e7          	jalr	320(ra) # 800005aa <printf>
    return -1;
    80009472:	54fd                	li	s1,-1
    80009474:	69e2                	ld	s3,24(sp)
    80009476:	6a42                	ld	s4,16(sp)
    80009478:	bf45                	j	80009428 <udp_bind+0xb0>
    printf("bind: port number already bound\n");
    8000947a:	00002517          	auipc	a0,0x2
    8000947e:	7be50513          	addi	a0,a0,1982 # 8000bc38 <etext+0xc38>
    80009482:	ffff7097          	auipc	ra,0xffff7
    80009486:	128080e7          	jalr	296(ra) # 800005aa <printf>
    return -1;
    8000948a:	54fd                	li	s1,-1
    8000948c:	69e2                	ld	s3,24(sp)
    8000948e:	6a42                	ld	s4,16(sp)
    80009490:	6aa2                	ld	s5,8(sp)
    80009492:	bf59                	j	80009428 <udp_bind+0xb0>
        printf("bind: incorrect addrlen for ipv4\n");
    80009494:	00002517          	auipc	a0,0x2
    80009498:	7cc50513          	addi	a0,a0,1996 # 8000bc60 <etext+0xc60>
    8000949c:	ffff7097          	auipc	ra,0xffff7
    800094a0:	10e080e7          	jalr	270(ra) # 800005aa <printf>
        return -1;
    800094a4:	54fd                	li	s1,-1
    800094a6:	69e2                	ld	s3,24(sp)
    800094a8:	6a42                	ld	s4,16(sp)
    800094aa:	6aa2                	ld	s5,8(sp)
    800094ac:	bfb5                	j	80009428 <udp_bind+0xb0>
        printf("ERROR: kalloc\n");
    800094ae:	00002517          	auipc	a0,0x2
    800094b2:	fca50513          	addi	a0,a0,-54 # 8000b478 <etext+0x478>
    800094b6:	ffff7097          	auipc	ra,0xffff7
    800094ba:	0f4080e7          	jalr	244(ra) # 800005aa <printf>
        return -1;
    800094be:	54fd                	li	s1,-1
    800094c0:	7902                	ld	s2,32(sp)
    800094c2:	69e2                	ld	s3,24(sp)
    800094c4:	6a42                	ld	s4,16(sp)
    800094c6:	6aa2                	ld	s5,8(sp)
    800094c8:	b785                	j	80009428 <udp_bind+0xb0>
        sock->src_ip = netconf.ip_addr;
    800094ca:	00003797          	auipc	a5,0x3
    800094ce:	3de7a783          	lw	a5,990(a5) # 8000c8a8 <netconf>
    800094d2:	02f9a023          	sw	a5,32(s3)
        binding->ip_addr = netconf.ip_addr;
    800094d6:	00f51023          	sh	a5,0(a0)
    800094da:	b70d                	j	800093fc <udp_bind+0x84>
        printf("bind: failed to bind to port\n");
    800094dc:	00002517          	auipc	a0,0x2
    800094e0:	7c450513          	addi	a0,a0,1988 # 8000bca0 <etext+0xca0>
    800094e4:	ffff7097          	auipc	ra,0xffff7
    800094e8:	0c6080e7          	jalr	198(ra) # 800005aa <printf>
        kfree(binding);
    800094ec:	854a                	mv	a0,s2
    800094ee:	ffff7097          	auipc	ra,0xffff7
    800094f2:	5ac080e7          	jalr	1452(ra) # 80000a9a <kfree>
        return -1;
    800094f6:	7902                	ld	s2,32(sp)
    800094f8:	69e2                	ld	s3,24(sp)
    800094fa:	6a42                	ld	s4,16(sp)
    800094fc:	6aa2                	ld	s5,8(sp)
    800094fe:	b72d                	j	80009428 <udp_bind+0xb0>
      return -1;
    80009500:	54fd                	li	s1,-1
    80009502:	69e2                	ld	s3,24(sp)
    80009504:	6a42                	ld	s4,16(sp)
    80009506:	6aa2                	ld	s5,8(sp)
    80009508:	b705                	j	80009428 <udp_bind+0xb0>

000000008000950a <udp_connect>:

int 
udp_connect(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen)
{
    8000950a:	1141                	addi	sp,sp,-16
    8000950c:	e422                	sd	s0,8(sp)
    8000950e:	0800                	addi	s0,sp,16
  return 0;
}
    80009510:	4501                	li	a0,0
    80009512:	6422                	ld	s0,8(sp)
    80009514:	0141                	addi	sp,sp,16
    80009516:	8082                	ret

0000000080009518 <udp_close>:

int
udp_close(struct socket *sock)
{
    80009518:	1141                	addi	sp,sp,-16
    8000951a:	e422                	sd	s0,8(sp)
    8000951c:	0800                	addi	s0,sp,16
  return 0;
}
    8000951e:	4501                	li	a0,0
    80009520:	6422                	ld	s0,8(sp)
    80009522:	0141                	addi	sp,sp,16
    80009524:	8082                	ret

0000000080009526 <udp_sendto>:

int 
udp_sendto(struct socket *sock, const void *buf, int len, int flags, 
    const struct sockaddr *dest, socklen_t addrlen)
{
    80009526:	b9010113          	addi	sp,sp,-1136
    8000952a:	46113423          	sd	ra,1128(sp)
    8000952e:	46813023          	sd	s0,1120(sp)
    80009532:	44913c23          	sd	s1,1112(sp)
    80009536:	47010413          	addi	s0,sp,1136
    8000953a:	b8b43c23          	sd	a1,-1128(s0)
    8000953e:	84ba                	mv	s1,a4
  struct sockaddr_in kaddr;
  if (addrlen < sizeof(kaddr))
    80009540:	473d                	li	a4,15
    80009542:	1af77463          	bgeu	a4,a5,800096ea <udp_sendto+0x1c4>
    80009546:	45313423          	sd	s3,1096(sp)
    8000954a:	43513c23          	sd	s5,1080(sp)
    8000954e:	8aaa                	mv	s5,a0
    80009550:	89b2                	mv	s3,a2
    return -1;

  if (copyin(myproc()->pagetable, (char *)&kaddr, (uint64)dest, sizeof(kaddr)) < 0)
    80009552:	ffff9097          	auipc	ra,0xffff9
    80009556:	8c2080e7          	jalr	-1854(ra) # 80001e14 <myproc>
    8000955a:	46c1                	li	a3,16
    8000955c:	8626                	mv	a2,s1
    8000955e:	fb040593          	addi	a1,s0,-80
    80009562:	6928                	ld	a0,80(a0)
    80009564:	ffff8097          	auipc	ra,0xffff8
    80009568:	5d4080e7          	jalr	1492(ra) # 80001b38 <copyin>
    8000956c:	18054163          	bltz	a0,800096ee <udp_sendto+0x1c8>
    80009570:	45213823          	sd	s2,1104(sp)
    80009574:	45413023          	sd	s4,1088(sp)
    80009578:	43613823          	sd	s6,1072(sp)
    return -1;

  uint32 dst_ip = (&kaddr)->sin_addr.s_addr;
    8000957c:	fb442483          	lw	s1,-76(s0)
  uint8 dst_mac[6];
  if (arp_lookup(dst_ip, dst_mac) == -1) {
    80009580:	fa840593          	addi	a1,s0,-88
    80009584:	8526                	mv	a0,s1
    80009586:	00000097          	auipc	ra,0x0
    8000958a:	36c080e7          	jalr	876(ra) # 800098f2 <arp_lookup>
    8000958e:	57fd                	li	a5,-1
    80009590:	12f50d63          	beq	a0,a5,800096ca <udp_sendto+0x1a4>
      // return -1;
    }
    // return -1;
  }

  struct eth_frame *eth = kalloc();
    80009594:	ffff7097          	auipc	ra,0xffff7
    80009598:	66e080e7          	jalr	1646(ra) # 80000c02 <kalloc>
    8000959c:	892a                	mv	s2,a0
  struct ip4_frame *ip = (struct ip4_frame *)eth->payload;
  struct udp_frame *udp = (struct udp_frame *)ip->payload;

  build_udp(udp, sock->src_port, ((struct sockaddr_in *)&kaddr)->sin_port, (uint8 *)&buf, len, netconf.ip_addr, dst_ip);
    8000959e:	00003b17          	auipc	s6,0x3
    800095a2:	30ab0b13          	addi	s6,s6,778 # 8000c8a8 <netconf>
  struct udp_frame *udp = (struct udp_frame *)ip->payload;
    800095a6:	00e50a13          	addi	s4,a0,14
  build_udp(udp, sock->src_port, ((struct sockaddr_in *)&kaddr)->sin_port, (uint8 *)&buf, len, netconf.ip_addr, dst_ip);
    800095aa:	8826                	mv	a6,s1
    800095ac:	000b2783          	lw	a5,0(s6)
    800095b0:	874e                	mv	a4,s3
    800095b2:	b9840693          	addi	a3,s0,-1128
    800095b6:	fb245603          	lhu	a2,-78(s0)
    800095ba:	028ad583          	lhu	a1,40(s5)
    800095be:	02250513          	addi	a0,a0,34
    800095c2:	00000097          	auipc	ra,0x0
    800095c6:	cd6080e7          	jalr	-810(ra) # 80009298 <build_udp>
  build_ip4(ip, ntohl(netconf.ip_addr), ntohl(dst_ip), IPPROTO_UDP, len + sizeof(struct udp_hdr) + sizeof(struct ip4_hdr));
    800095ca:	000b2783          	lw	a5,0(s6)
    800095ce:	19c2                	slli	s3,s3,0x30
    800095d0:	0309d993          	srli	s3,s3,0x30
    800095d4:	01c9871b          	addiw	a4,s3,28
  return ((netlong & 0x000000FFU) << 24) |
    800095d8:	0184961b          	slliw	a2,s1,0x18
    ((netlong & 0xFF000000U) >> 24);
    800095dc:	0184d69b          	srliw	a3,s1,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    800095e0:	8e55                	or	a2,a2,a3
    ((netlong & 0x0000FF00U) << 8)  |
    800095e2:	0084969b          	slliw	a3,s1,0x8
    800095e6:	00ff0837          	lui	a6,0xff0
    800095ea:	0106f6b3          	and	a3,a3,a6
    ((netlong & 0x00FF0000U) >> 8)  |
    800095ee:	8e55                	or	a2,a2,a3
    800095f0:	0084d49b          	srliw	s1,s1,0x8
    800095f4:	66c1                	lui	a3,0x10
    800095f6:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800095fa:	8cf5                	and	s1,s1,a3
    800095fc:	8e45                	or	a2,a2,s1
  return ((netlong & 0x000000FFU) << 24) |
    800095fe:	0187959b          	slliw	a1,a5,0x18
    ((netlong & 0xFF000000U) >> 24);
    80009602:	0187d51b          	srliw	a0,a5,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80009606:	8dc9                	or	a1,a1,a0
    ((netlong & 0x0000FF00U) << 8)  |
    80009608:	0087951b          	slliw	a0,a5,0x8
    8000960c:	01057533          	and	a0,a0,a6
    ((netlong & 0x00FF0000U) >> 8)  |
    80009610:	8dc9                	or	a1,a1,a0
    80009612:	0087d79b          	srliw	a5,a5,0x8
    80009616:	8ff5                	and	a5,a5,a3
    80009618:	8ddd                	or	a1,a1,a5
    8000961a:	1742                	slli	a4,a4,0x30
    8000961c:	9341                	srli	a4,a4,0x30
    8000961e:	46c5                	li	a3,17
    80009620:	2601                	sext.w	a2,a2
    80009622:	2581                	sext.w	a1,a1
    80009624:	8552                	mv	a0,s4
    80009626:	ffffe097          	auipc	ra,0xffffe
    8000962a:	754080e7          	jalr	1876(ra) # 80007d7a <build_ip4>
  build_eth(eth, dst_mac, netconf.mac_addr, PROTO_IPV4);
    8000962e:	6685                	lui	a3,0x1
    80009630:	80068693          	addi	a3,a3,-2048 # 800 <_entry-0x7ffff800>
    80009634:	00003617          	auipc	a2,0x3
    80009638:	27860613          	addi	a2,a2,632 # 8000c8ac <netconf+0x4>
    8000963c:	fa840593          	addi	a1,s0,-88
    80009640:	854a                	mv	a0,s2
    80009642:	fffff097          	auipc	ra,0xfffff
    80009646:	4ee080e7          	jalr	1262(ra) # 80008b30 <build_eth>

  char buf2[1024];
  
  memmove(buf2, udp->payload, udp->payload_len);
    8000964a:	60692603          	lw	a2,1542(s2)
    8000964e:	02a90593          	addi	a1,s2,42
    80009652:	ba840513          	addi	a0,s0,-1112
    80009656:	ffff8097          	auipc	ra,0xffff8
    8000965a:	812080e7          	jalr	-2030(ra) # 80000e68 <memmove>
  buf2[udp->payload_len] = '\0';
    8000965e:	60692783          	lw	a5,1542(s2)
    80009662:	fc078793          	addi	a5,a5,-64
    80009666:	97a2                	add	a5,a5,s0
    80009668:	be078423          	sb	zero,-1048(a5)
  printf("%s\n", buf2);
    8000966c:	ba840593          	addi	a1,s0,-1112
    80009670:	00002517          	auipc	a0,0x2
    80009674:	7a050513          	addi	a0,a0,1952 # 8000be10 <etext+0xe10>
    80009678:	ffff7097          	auipc	ra,0xffff7
    8000967c:	f32080e7          	jalr	-206(ra) # 800005aa <printf>

  transmit_packet(eth, len + sizeof(struct udp_hdr) + sizeof(struct ip4_hdr) + sizeof(struct eth_hdr), PROTO_IPV4);
    80009680:	02a9859b          	addiw	a1,s3,42
    80009684:	6605                	lui	a2,0x1
    80009686:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000968a:	15c2                	slli	a1,a1,0x30
    8000968c:	91c1                	srli	a1,a1,0x30
    8000968e:	854a                	mv	a0,s2
    80009690:	ffffe097          	auipc	ra,0xffffe
    80009694:	0dc080e7          	jalr	220(ra) # 8000776c <transmit_packet>
  kfree(eth);
    80009698:	854a                	mv	a0,s2
    8000969a:	ffff7097          	auipc	ra,0xffff7
    8000969e:	400080e7          	jalr	1024(ra) # 80000a9a <kfree>
  eth = 0;
  ip = 0;
  udp = 0;

  return 0;
    800096a2:	4501                	li	a0,0
    800096a4:	45013903          	ld	s2,1104(sp)
    800096a8:	44813983          	ld	s3,1096(sp)
    800096ac:	44013a03          	ld	s4,1088(sp)
    800096b0:	43813a83          	ld	s5,1080(sp)
    800096b4:	43013b03          	ld	s6,1072(sp)
}
    800096b8:	46813083          	ld	ra,1128(sp)
    800096bc:	46013403          	ld	s0,1120(sp)
    800096c0:	45813483          	ld	s1,1112(sp)
    800096c4:	47010113          	addi	sp,sp,1136
    800096c8:	8082                	ret
    arp_request(dst_ip);
    800096ca:	8526                	mv	a0,s1
    800096cc:	00000097          	auipc	ra,0x0
    800096d0:	30a080e7          	jalr	778(ra) # 800099d6 <arp_request>
    while (arp_lookup(dst_ip, dst_mac) == -1) {
    800096d4:	597d                	li	s2,-1
    800096d6:	fa840593          	addi	a1,s0,-88
    800096da:	8526                	mv	a0,s1
    800096dc:	00000097          	auipc	ra,0x0
    800096e0:	216080e7          	jalr	534(ra) # 800098f2 <arp_lookup>
    800096e4:	ff2509e3          	beq	a0,s2,800096d6 <udp_sendto+0x1b0>
    800096e8:	b575                	j	80009594 <udp_sendto+0x6e>
    return -1;
    800096ea:	557d                	li	a0,-1
    800096ec:	b7f1                	j	800096b8 <udp_sendto+0x192>
    return -1;
    800096ee:	557d                	li	a0,-1
    800096f0:	44813983          	ld	s3,1096(sp)
    800096f4:	43813a83          	ld	s5,1080(sp)
    800096f8:	b7c1                	j	800096b8 <udp_sendto+0x192>

00000000800096fa <udp_recvfrom>:

int 
udp_recvfrom(struct socket *sock, void *buf, int len, int flags,
    const struct sockaddr *src, socklen_t *addrlen)
{
    800096fa:	7139                	addi	sp,sp,-64
    800096fc:	fc06                	sd	ra,56(sp)
    800096fe:	f822                	sd	s0,48(sp)
    80009700:	f426                	sd	s1,40(sp)
    80009702:	f04a                	sd	s2,32(sp)
    80009704:	e852                	sd	s4,16(sp)
    80009706:	e456                	sd	s5,8(sp)
    80009708:	0080                	addi	s0,sp,64
    8000970a:	84aa                	mv	s1,a0
    8000970c:	8a2e                	mv	s4,a1
    8000970e:	8ab2                	mv	s5,a2
  struct udp_frame *pkt = 0;
  acquire(&sock->lock);
    80009710:	00850913          	addi	s2,a0,8
    80009714:	854a                	mv	a0,s2
    80009716:	ffff7097          	auipc	ra,0xffff7
    8000971a:	5fa080e7          	jalr	1530(ra) # 80000d10 <acquire>
  while (!sock->rx_head) {
    8000971e:	68bc                	ld	a5,80(s1)
    80009720:	ef89                	bnez	a5,8000973a <udp_recvfrom+0x40>
    80009722:	ec4e                	sd	s3,24(sp)
    sleep(&sock->rx_head, &sock->lock);
    80009724:	05048993          	addi	s3,s1,80
    80009728:	85ca                	mv	a1,s2
    8000972a:	854e                	mv	a0,s3
    8000972c:	ffff9097          	auipc	ra,0xffff9
    80009730:	f96080e7          	jalr	-106(ra) # 800026c2 <sleep>
  while (!sock->rx_head) {
    80009734:	68bc                	ld	a5,80(s1)
    80009736:	dbed                	beqz	a5,80009728 <udp_recvfrom+0x2e>
    80009738:	69e2                	ld	s3,24(sp)
  }
  printf("received a packet!\n");
    8000973a:	00002517          	auipc	a0,0x2
    8000973e:	6de50513          	addi	a0,a0,1758 # 8000be18 <etext+0xe18>
    80009742:	ffff7097          	auipc	ra,0xffff7
    80009746:	e68080e7          	jalr	-408(ra) # 800005aa <printf>
  pkt = (struct udp_frame *)dequeue_udp_packet(sock);
    8000974a:	8526                	mv	a0,s1
    8000974c:	00000097          	auipc	ra,0x0
    80009750:	c0c080e7          	jalr	-1012(ra) # 80009358 <dequeue_udp_packet>
    80009754:	84aa                	mv	s1,a0

  int payload_len = len - sizeof(struct udp_hdr);
  release(&sock->lock);
    80009756:	854a                	mv	a0,s2
    80009758:	ffff7097          	auipc	ra,0xffff7
    8000975c:	66c080e7          	jalr	1644(ra) # 80000dc4 <release>

  // Copy payload
  int n;
  if (pkt->payload_len < len) {
    80009760:	5e44a783          	lw	a5,1508(s1)
    80009764:	853e                	mv	a0,a5
    80009766:	2781                	sext.w	a5,a5
    80009768:	00fad363          	bge	s5,a5,8000976e <udp_recvfrom+0x74>
    8000976c:	8556                	mv	a0,s5
    8000976e:	0005091b          	sext.w	s2,a0
    n = pkt->payload_len;
  } else {
    n = len;
  }

  if (copyout(myproc()->pagetable, (uint64)buf, (char *)pkt->payload, pkt->payload_len) < 0) {;;
    80009772:	ffff8097          	auipc	ra,0xffff8
    80009776:	6a2080e7          	jalr	1698(ra) # 80001e14 <myproc>
    8000977a:	5e44a683          	lw	a3,1508(s1)
    8000977e:	00848613          	addi	a2,s1,8
    80009782:	85d2                	mv	a1,s4
    80009784:	6928                	ld	a0,80(a0)
    80009786:	ffff8097          	auipc	ra,0xffff8
    8000978a:	326080e7          	jalr	806(ra) # 80001aac <copyout>
    8000978e:	02054063          	bltz	a0,800097ae <udp_recvfrom+0xb4>
      kfree(pkt);
      return -1;;
  }

  kfree(pkt);
    80009792:	8526                	mv	a0,s1
    80009794:	ffff7097          	auipc	ra,0xffff7
    80009798:	306080e7          	jalr	774(ra) # 80000a9a <kfree>
  return n;
}
    8000979c:	854a                	mv	a0,s2
    8000979e:	70e2                	ld	ra,56(sp)
    800097a0:	7442                	ld	s0,48(sp)
    800097a2:	74a2                	ld	s1,40(sp)
    800097a4:	7902                	ld	s2,32(sp)
    800097a6:	6a42                	ld	s4,16(sp)
    800097a8:	6aa2                	ld	s5,8(sp)
    800097aa:	6121                	addi	sp,sp,64
    800097ac:	8082                	ret
      kfree(pkt);
    800097ae:	8526                	mv	a0,s1
    800097b0:	ffff7097          	auipc	ra,0xffff7
    800097b4:	2ea080e7          	jalr	746(ra) # 80000a9a <kfree>
      return -1;;
    800097b8:	597d                	li	s2,-1
    800097ba:	b7cd                	j	8000979c <udp_recvfrom+0xa2>

00000000800097bc <handle_udp_packet>:

int 
handle_udp_packet(struct udp_frame *udp_pkt) 
{
    800097bc:	1101                	addi	sp,sp,-32
    800097be:	ec06                	sd	ra,24(sp)
    800097c0:	e822                	sd	s0,16(sp)
    800097c2:	e426                	sd	s1,8(sp)
    800097c4:	1000                	addi	s0,sp,32
    800097c6:	84aa                	mv	s1,a0
  printf("\tUDP packet: src_port=%d dst_port=%d len=%d csum=%d\n",
    800097c8:	00655703          	lhu	a4,6(a0)
    800097cc:	00455683          	lhu	a3,4(a0)
    800097d0:	00255603          	lhu	a2,2(a0)
    800097d4:	00055583          	lhu	a1,0(a0)
    800097d8:	00002517          	auipc	a0,0x2
    800097dc:	65850513          	addi	a0,a0,1624 # 8000be30 <etext+0xe30>
    800097e0:	ffff7097          	auipc	ra,0xffff7
    800097e4:	dca080e7          	jalr	-566(ra) # 800005aa <printf>
      udp_pkt->hdr.src_port, udp_pkt->hdr.dst_port, udp_pkt->hdr.len, udp_pkt->hdr.csum);

  // validate the port number
  if (udp_pkt->hdr.dst_port < 0 || udp_pkt->hdr.dst_port >= MAX_PORT_BINDINGS) 
    800097e8:	0024d783          	lhu	a5,2(s1)
    800097ec:	0007869b          	sext.w	a3,a5
    800097f0:	1ff00713          	li	a4,511
    800097f4:	06d76463          	bltu	a4,a3,8000985c <handle_udp_packet+0xa0>
    return -1;

  // validate the socket is listening for datagrams
  if (udp_port_binds[udp_pkt->hdr.dst_port] == 0) {
    800097f8:	078e                	slli	a5,a5,0x3
    800097fa:	00066717          	auipc	a4,0x66
    800097fe:	b9e70713          	addi	a4,a4,-1122 # 8006f398 <udp_port_binds>
    80009802:	97ba                	add	a5,a5,a4
    80009804:	639c                	ld	a5,0(a5)
    80009806:	c385                	beqz	a5,80009826 <handle_udp_packet+0x6a>
    80009808:	e04a                	sd	s2,0(sp)
    printf("port is not bound to socket\n");
    return -1;
  };

  struct socket *sock = udp_port_binds[udp_pkt->hdr.dst_port]->sock;
    8000980a:	0087b903          	ld	s2,8(a5)
  if (sock->proto == IPPROTO_UDP) {
    8000980e:	03092703          	lw	a4,48(s2)
    80009812:	47c5                	li	a5,17
    printf("enqeueing packet\n");
    enqueue_udp_packet(udp_pkt, sock);
  }
  return 0;
    80009814:	4501                	li	a0,0
  if (sock->proto == IPPROTO_UDP) {
    80009816:	02f70263          	beq	a4,a5,8000983a <handle_udp_packet+0x7e>
    8000981a:	6902                	ld	s2,0(sp)
}
    8000981c:	60e2                	ld	ra,24(sp)
    8000981e:	6442                	ld	s0,16(sp)
    80009820:	64a2                	ld	s1,8(sp)
    80009822:	6105                	addi	sp,sp,32
    80009824:	8082                	ret
    printf("port is not bound to socket\n");
    80009826:	00002517          	auipc	a0,0x2
    8000982a:	64250513          	addi	a0,a0,1602 # 8000be68 <etext+0xe68>
    8000982e:	ffff7097          	auipc	ra,0xffff7
    80009832:	d7c080e7          	jalr	-644(ra) # 800005aa <printf>
    return -1;
    80009836:	557d                	li	a0,-1
    80009838:	b7d5                	j	8000981c <handle_udp_packet+0x60>
    printf("enqeueing packet\n");
    8000983a:	00002517          	auipc	a0,0x2
    8000983e:	64e50513          	addi	a0,a0,1614 # 8000be88 <etext+0xe88>
    80009842:	ffff7097          	auipc	ra,0xffff7
    80009846:	d68080e7          	jalr	-664(ra) # 800005aa <printf>
    enqueue_udp_packet(udp_pkt, sock);
    8000984a:	85ca                	mv	a1,s2
    8000984c:	8526                	mv	a0,s1
    8000984e:	00000097          	auipc	ra,0x0
    80009852:	adc080e7          	jalr	-1316(ra) # 8000932a <enqueue_udp_packet>
  return 0;
    80009856:	4501                	li	a0,0
    80009858:	6902                	ld	s2,0(sp)
    8000985a:	b7c9                	j	8000981c <handle_udp_packet+0x60>
    return -1;
    8000985c:	557d                	li	a0,-1
    8000985e:	bf7d                	j	8000981c <handle_udp_packet+0x60>

0000000080009860 <parse_udp_packet>:

int 
parse_udp_packet(uint8 *buf, int len, struct udp_frame *udp_pkt) 
{
  if (len < 8) return -1;  // too short for UDP header
    80009860:	479d                	li	a5,7
    80009862:	08b7d263          	bge	a5,a1,800098e6 <parse_udp_packet+0x86>
    80009866:	8732                	mv	a4,a2
  return (netshort >> 8) | (netshort << 8);
    80009868:	00055783          	lhu	a5,0(a0)
    8000986c:	0087969b          	slliw	a3,a5,0x8
    80009870:	83a1                	srli	a5,a5,0x8
    80009872:	8fd5                	or	a5,a5,a3

  udp_pkt->hdr.src_port = ntohs(*(uint16 *)(buf));
    80009874:	00f61023          	sh	a5,0(a2)
    80009878:	00255783          	lhu	a5,2(a0)
    8000987c:	0087969b          	slliw	a3,a5,0x8
    80009880:	83a1                	srli	a5,a5,0x8
    80009882:	8fd5                	or	a5,a5,a3
  udp_pkt->hdr.dst_port = ntohs(*(uint16 *)(buf + 2));
    80009884:	00f61123          	sh	a5,2(a2)
    80009888:	00455783          	lhu	a5,4(a0)
    8000988c:	0087969b          	slliw	a3,a5,0x8
    80009890:	83a1                	srli	a5,a5,0x8
    80009892:	8fd5                	or	a5,a5,a3
    80009894:	17c2                	slli	a5,a5,0x30
    80009896:	93c1                	srli	a5,a5,0x30
  udp_pkt->hdr.len      = ntohs(*(uint16 *)(buf + 4));
    80009898:	00f61223          	sh	a5,4(a2)
    8000989c:	00655683          	lhu	a3,6(a0)
    800098a0:	0086961b          	slliw	a2,a3,0x8
    800098a4:	82a1                	srli	a3,a3,0x8
    800098a6:	8ed1                	or	a3,a3,a2
  udp_pkt->hdr.csum     = ntohs(*(uint16 *)(buf + 6));
    800098a8:	00d71323          	sh	a3,6(a4)

  if (udp_pkt->hdr.len < 8 || udp_pkt->hdr.len > len)
    800098ac:	0007861b          	sext.w	a2,a5
    800098b0:	469d                	li	a3,7
    800098b2:	02c6fc63          	bgeu	a3,a2,800098ea <parse_udp_packet+0x8a>
    800098b6:	02c5cc63          	blt	a1,a2,800098ee <parse_udp_packet+0x8e>
{
    800098ba:	1141                	addi	sp,sp,-16
    800098bc:	e406                	sd	ra,8(sp)
    800098be:	e022                	sd	s0,0(sp)
    800098c0:	0800                	addi	s0,sp,16
      return -1;  // malformed length

  udp_pkt->payload_len = len - sizeof(struct udp_hdr);
    800098c2:	35e1                	addiw	a1,a1,-8
    800098c4:	5eb72223          	sw	a1,1508(a4)
  memmove(udp_pkt->payload, buf + sizeof(struct udp_hdr), udp_pkt->payload_len);
    800098c8:	0005861b          	sext.w	a2,a1
    800098cc:	00850593          	addi	a1,a0,8
    800098d0:	00870513          	addi	a0,a4,8
    800098d4:	ffff7097          	auipc	ra,0xffff7
    800098d8:	594080e7          	jalr	1428(ra) # 80000e68 <memmove>

  return 0;
    800098dc:	4501                	li	a0,0
}
    800098de:	60a2                	ld	ra,8(sp)
    800098e0:	6402                	ld	s0,0(sp)
    800098e2:	0141                	addi	sp,sp,16
    800098e4:	8082                	ret
  if (len < 8) return -1;  // too short for UDP header
    800098e6:	557d                	li	a0,-1
    800098e8:	8082                	ret
      return -1;  // malformed length
    800098ea:	557d                	li	a0,-1
    800098ec:	8082                	ret
    800098ee:	557d                	li	a0,-1
}
    800098f0:	8082                	ret

00000000800098f2 <arp_lookup>:
    800098f2:	1101                	addi	sp,sp,-32
    800098f4:	ec06                	sd	ra,24(sp)
    800098f6:	e822                	sd	s0,16(sp)
    800098f8:	e426                	sd	s1,8(sp)
    800098fa:	1000                	addi	s0,sp,32
    800098fc:	88aa                	mv	a7,a0
    800098fe:	852e                	mv	a0,a1
    80009900:	00067797          	auipc	a5,0x67
    80009904:	a9878793          	addi	a5,a5,-1384 # 80070398 <arp_cache>
    80009908:	4701                	li	a4,0
    8000990a:	4685                	li	a3,1
    8000990c:	4641                	li	a2,16
    8000990e:	a029                	j	80009918 <arp_lookup+0x26>
    80009910:	2705                	addiw	a4,a4,1
    80009912:	07c1                	addi	a5,a5,16
    80009914:	02c70563          	beq	a4,a2,8000993e <arp_lookup+0x4c>
    80009918:	47c4                	lw	s1,12(a5)
    8000991a:	fed49be3          	bne	s1,a3,80009910 <arp_lookup+0x1e>
    8000991e:	0007a803          	lw	a6,0(a5)
    80009922:	ff1817e3          	bne	a6,a7,80009910 <arp_lookup+0x1e>
    80009926:	0712                	slli	a4,a4,0x4
    80009928:	4619                	li	a2,6
    8000992a:	00067597          	auipc	a1,0x67
    8000992e:	a7258593          	addi	a1,a1,-1422 # 8007039c <arp_cache+0x4>
    80009932:	95ba                	add	a1,a1,a4
    80009934:	ffff7097          	auipc	ra,0xffff7
    80009938:	534080e7          	jalr	1332(ra) # 80000e68 <memmove>
    8000993c:	a011                	j	80009940 <arp_lookup+0x4e>
    8000993e:	54fd                	li	s1,-1
    80009940:	8526                	mv	a0,s1
    80009942:	60e2                	ld	ra,24(sp)
    80009944:	6442                	ld	s0,16(sp)
    80009946:	64a2                	ld	s1,8(sp)
    80009948:	6105                	addi	sp,sp,32
    8000994a:	8082                	ret

000000008000994c <arp_insert>:
    8000994c:	1101                	addi	sp,sp,-32
    8000994e:	ec06                	sd	ra,24(sp)
    80009950:	e822                	sd	s0,16(sp)
    80009952:	1000                	addi	s0,sp,32
    80009954:	00067797          	auipc	a5,0x67
    80009958:	a4478793          	addi	a5,a5,-1468 # 80070398 <arp_cache>
    8000995c:	4701                	li	a4,0
    8000995e:	4605                	li	a2,1
    80009960:	4841                	li	a6,16
    80009962:	4394                	lw	a3,0(a5)
    80009964:	00a68d63          	beq	a3,a0,8000997e <arp_insert+0x32>
    80009968:	47d4                	lw	a3,12(a5)
    8000996a:	04c69163          	bne	a3,a2,800099ac <arp_insert+0x60>
    8000996e:	2705                	addiw	a4,a4,1
    80009970:	07c1                	addi	a5,a5,16
    80009972:	ff0718e3          	bne	a4,a6,80009962 <arp_insert+0x16>
    80009976:	60e2                	ld	ra,24(sp)
    80009978:	6442                	ld	s0,16(sp)
    8000997a:	6105                	addi	sp,sp,32
    8000997c:	8082                	ret
    8000997e:	e426                	sd	s1,8(sp)
    80009980:	e04a                	sd	s2,0(sp)
    80009982:	00067917          	auipc	s2,0x67
    80009986:	a1690913          	addi	s2,s2,-1514 # 80070398 <arp_cache>
    8000998a:	00471493          	slli	s1,a4,0x4
    8000998e:	00448513          	addi	a0,s1,4
    80009992:	4619                	li	a2,6
    80009994:	954a                	add	a0,a0,s2
    80009996:	ffff7097          	auipc	ra,0xffff7
    8000999a:	4d2080e7          	jalr	1234(ra) # 80000e68 <memmove>
    8000999e:	9926                	add	s2,s2,s1
    800099a0:	4785                	li	a5,1
    800099a2:	00f92623          	sw	a5,12(s2)
    800099a6:	64a2                	ld	s1,8(sp)
    800099a8:	6902                	ld	s2,0(sp)
    800099aa:	b7f1                	j	80009976 <arp_insert+0x2a>
    800099ac:	e426                	sd	s1,8(sp)
    800099ae:	00067797          	auipc	a5,0x67
    800099b2:	9ea78793          	addi	a5,a5,-1558 # 80070398 <arp_cache>
    800099b6:	0712                	slli	a4,a4,0x4
    800099b8:	00e784b3          	add	s1,a5,a4
    800099bc:	c088                	sw	a0,0(s1)
    800099be:	0711                	addi	a4,a4,4
    800099c0:	4619                	li	a2,6
    800099c2:	00e78533          	add	a0,a5,a4
    800099c6:	ffff7097          	auipc	ra,0xffff7
    800099ca:	4a2080e7          	jalr	1186(ra) # 80000e68 <memmove>
    800099ce:	4785                	li	a5,1
    800099d0:	c4dc                	sw	a5,12(s1)
    800099d2:	64a2                	ld	s1,8(sp)
    800099d4:	b74d                	j	80009976 <arp_insert+0x2a>

00000000800099d6 <arp_request>:
    800099d6:	7139                	addi	sp,sp,-64
    800099d8:	fc06                	sd	ra,56(sp)
    800099da:	f822                	sd	s0,48(sp)
    800099dc:	f04a                	sd	s2,32(sp)
    800099de:	0080                	addi	s0,sp,64
    800099e0:	892a                	mv	s2,a0
    800099e2:	ffff7097          	auipc	ra,0xffff7
    800099e6:	220080e7          	jalr	544(ra) # 80000c02 <kalloc>
    800099ea:	10050263          	beqz	a0,80009aee <arp_request+0x118>
    800099ee:	f426                	sd	s1,40(sp)
    800099f0:	ec4e                	sd	s3,24(sp)
    800099f2:	e852                	sd	s4,16(sp)
    800099f4:	84aa                	mv	s1,a0
    800099f6:	57fd                	li	a5,-1
    800099f8:	fcf42423          	sw	a5,-56(s0)
    800099fc:	fcf41623          	sh	a5,-52(s0)
    80009a00:	fc840a13          	addi	s4,s0,-56
    80009a04:	6685                	lui	a3,0x1
    80009a06:	80668693          	addi	a3,a3,-2042 # 806 <_entry-0x7ffff7fa>
    80009a0a:	00003617          	auipc	a2,0x3
    80009a0e:	ea260613          	addi	a2,a2,-350 # 8000c8ac <netconf+0x4>
    80009a12:	85d2                	mv	a1,s4
    80009a14:	fffff097          	auipc	ra,0xfffff
    80009a18:	11c080e7          	jalr	284(ra) # 80008b30 <build_eth>
    80009a1c:	00048723          	sb	zero,14(s1)
    80009a20:	4785                	li	a5,1
    80009a22:	00f487a3          	sb	a5,15(s1)
    80009a26:	4721                	li	a4,8
    80009a28:	00e48823          	sb	a4,16(s1)
    80009a2c:	000488a3          	sb	zero,17(s1)
    80009a30:	4999                	li	s3,6
    80009a32:	01348923          	sb	s3,18(s1)
    80009a36:	4711                	li	a4,4
    80009a38:	00e489a3          	sb	a4,19(s1)
    80009a3c:	00048a23          	sb	zero,20(s1)
    80009a40:	00f48aa3          	sb	a5,21(s1)
    80009a44:	00003797          	auipc	a5,0x3
    80009a48:	e6478793          	addi	a5,a5,-412 # 8000c8a8 <netconf>
    80009a4c:	0007c703          	lbu	a4,0(a5)
    80009a50:	00e48e23          	sb	a4,28(s1)
    80009a54:	439c                	lw	a5,0(a5)
    80009a56:	0087d71b          	srliw	a4,a5,0x8
    80009a5a:	00e48ea3          	sb	a4,29(s1)
    80009a5e:	0107d71b          	srliw	a4,a5,0x10
    80009a62:	00e48f23          	sb	a4,30(s1)
    80009a66:	0187d79b          	srliw	a5,a5,0x18
    80009a6a:	00f48fa3          	sb	a5,31(s1)
    80009a6e:	03248323          	sb	s2,38(s1)
    80009a72:	0089579b          	srliw	a5,s2,0x8
    80009a76:	02f483a3          	sb	a5,39(s1)
    80009a7a:	0109579b          	srliw	a5,s2,0x10
    80009a7e:	02f48423          	sb	a5,40(s1)
    80009a82:	0189591b          	srliw	s2,s2,0x18
    80009a86:	032484a3          	sb	s2,41(s1)
    80009a8a:	864e                	mv	a2,s3
    80009a8c:	00003597          	auipc	a1,0x3
    80009a90:	e2058593          	addi	a1,a1,-480 # 8000c8ac <netconf+0x4>
    80009a94:	01648513          	addi	a0,s1,22
    80009a98:	ffff7097          	auipc	ra,0xffff7
    80009a9c:	3d0080e7          	jalr	976(ra) # 80000e68 <memmove>
    80009aa0:	864e                	mv	a2,s3
    80009aa2:	85d2                	mv	a1,s4
    80009aa4:	02048513          	addi	a0,s1,32
    80009aa8:	ffff7097          	auipc	ra,0xffff7
    80009aac:	3c0080e7          	jalr	960(ra) # 80000e68 <memmove>
    80009ab0:	00002517          	auipc	a0,0x2
    80009ab4:	3f050513          	addi	a0,a0,1008 # 8000bea0 <etext+0xea0>
    80009ab8:	ffff7097          	auipc	ra,0xffff7
    80009abc:	af2080e7          	jalr	-1294(ra) # 800005aa <printf>
    80009ac0:	6605                	lui	a2,0x1
    80009ac2:	80660613          	addi	a2,a2,-2042 # 806 <_entry-0x7ffff7fa>
    80009ac6:	02a00593          	li	a1,42
    80009aca:	8526                	mv	a0,s1
    80009acc:	ffffe097          	auipc	ra,0xffffe
    80009ad0:	ca0080e7          	jalr	-864(ra) # 8000776c <transmit_packet>
    80009ad4:	8526                	mv	a0,s1
    80009ad6:	ffff7097          	auipc	ra,0xffff7
    80009ada:	fc4080e7          	jalr	-60(ra) # 80000a9a <kfree>
    80009ade:	74a2                	ld	s1,40(sp)
    80009ae0:	69e2                	ld	s3,24(sp)
    80009ae2:	6a42                	ld	s4,16(sp)
    80009ae4:	70e2                	ld	ra,56(sp)
    80009ae6:	7442                	ld	s0,48(sp)
    80009ae8:	7902                	ld	s2,32(sp)
    80009aea:	6121                	addi	sp,sp,64
    80009aec:	8082                	ret
    80009aee:	00002517          	auipc	a0,0x2
    80009af2:	98a50513          	addi	a0,a0,-1654 # 8000b478 <etext+0x478>
    80009af6:	ffff7097          	auipc	ra,0xffff7
    80009afa:	ab4080e7          	jalr	-1356(ra) # 800005aa <printf>
    80009afe:	b7dd                	j	80009ae4 <arp_request+0x10e>

0000000080009b00 <arp_recv>:
    80009b00:	7179                	addi	sp,sp,-48
    80009b02:	f406                	sd	ra,40(sp)
    80009b04:	f022                	sd	s0,32(sp)
    80009b06:	ec26                	sd	s1,24(sp)
    80009b08:	e052                	sd	s4,0(sp)
    80009b0a:	1800                	addi	s0,sp,48
    80009b0c:	8a2a                	mv	s4,a0
    80009b0e:	00654683          	lbu	a3,6(a0)
    80009b12:	00754783          	lbu	a5,7(a0)
    80009b16:	07a2                	slli	a5,a5,0x8
    80009b18:	00d7e733          	or	a4,a5,a3
    80009b1c:	10000693          	li	a3,256
    80009b20:	06d70f63          	beq	a4,a3,80009b9e <arp_recv+0x9e>
    80009b24:	e84a                	sd	s2,16(sp)
    80009b26:	e44e                	sd	s3,8(sp)
    80009b28:	2701                	sext.w	a4,a4
    80009b2a:	20000793          	li	a5,512
    80009b2e:	84aa                	mv	s1,a0
    80009b30:	01c50993          	addi	s3,a0,28
    80009b34:	00002917          	auipc	s2,0x2
    80009b38:	39490913          	addi	s2,s2,916 # 8000bec8 <etext+0xec8>
    80009b3c:	1cf70863          	beq	a4,a5,80009d0c <arp_recv+0x20c>
    80009b40:	0004c583          	lbu	a1,0(s1)
    80009b44:	854a                	mv	a0,s2
    80009b46:	ffff7097          	auipc	ra,0xffff7
    80009b4a:	a64080e7          	jalr	-1436(ra) # 800005aa <printf>
    80009b4e:	0485                	addi	s1,s1,1
    80009b50:	ff3498e3          	bne	s1,s3,80009b40 <arp_recv+0x40>
    80009b54:	00001517          	auipc	a0,0x1
    80009b58:	4cc50513          	addi	a0,a0,1228 # 8000b020 <etext+0x20>
    80009b5c:	ffff7097          	auipc	ra,0xffff7
    80009b60:	a4e080e7          	jalr	-1458(ra) # 800005aa <printf>
    80009b64:	006a4703          	lbu	a4,6(s4)
    80009b68:	007a4783          	lbu	a5,7(s4)
    80009b6c:	07a2                	slli	a5,a5,0x8
    80009b6e:	8f5d                	or	a4,a4,a5
    80009b70:	83a1                	srli	a5,a5,0x8
    80009b72:	0087171b          	slliw	a4,a4,0x8
    80009b76:	00e7e5b3          	or	a1,a5,a4
    80009b7a:	15c2                	slli	a1,a1,0x30
    80009b7c:	91c1                	srli	a1,a1,0x30
    80009b7e:	00002517          	auipc	a0,0x2
    80009b82:	35250513          	addi	a0,a0,850 # 8000bed0 <etext+0xed0>
    80009b86:	ffff7097          	auipc	ra,0xffff7
    80009b8a:	a24080e7          	jalr	-1500(ra) # 800005aa <printf>
    80009b8e:	6942                	ld	s2,16(sp)
    80009b90:	69a2                	ld	s3,8(sp)
    80009b92:	70a2                	ld	ra,40(sp)
    80009b94:	7402                	ld	s0,32(sp)
    80009b96:	64e2                	ld	s1,24(sp)
    80009b98:	6a02                	ld	s4,0(sp)
    80009b9a:	6145                	addi	sp,sp,48
    80009b9c:	8082                	ret
    80009b9e:	ffff7097          	auipc	ra,0xffff7
    80009ba2:	064080e7          	jalr	100(ra) # 80000c02 <kalloc>
    80009ba6:	84aa                	mv	s1,a0
    80009ba8:	14050963          	beqz	a0,80009cfa <arp_recv+0x1fa>
    80009bac:	e84a                	sd	s2,16(sp)
    80009bae:	008a0913          	addi	s2,s4,8
    80009bb2:	00ea4783          	lbu	a5,14(s4)
    80009bb6:	00fa4703          	lbu	a4,15(s4)
    80009bba:	0722                	slli	a4,a4,0x8
    80009bbc:	8f5d                	or	a4,a4,a5
    80009bbe:	010a4783          	lbu	a5,16(s4)
    80009bc2:	07c2                	slli	a5,a5,0x10
    80009bc4:	8fd9                	or	a5,a5,a4
    80009bc6:	011a4503          	lbu	a0,17(s4)
    80009bca:	0562                	slli	a0,a0,0x18
    80009bcc:	8d5d                	or	a0,a0,a5
    80009bce:	85ca                	mv	a1,s2
    80009bd0:	2501                	sext.w	a0,a0
    80009bd2:	00000097          	auipc	ra,0x0
    80009bd6:	d7a080e7          	jalr	-646(ra) # 8000994c <arp_insert>
    80009bda:	018a4703          	lbu	a4,24(s4)
    80009bde:	019a4783          	lbu	a5,25(s4)
    80009be2:	07a2                	slli	a5,a5,0x8
    80009be4:	8fd9                	or	a5,a5,a4
    80009be6:	01aa4703          	lbu	a4,26(s4)
    80009bea:	0742                	slli	a4,a4,0x10
    80009bec:	8f5d                	or	a4,a4,a5
    80009bee:	01ba4783          	lbu	a5,27(s4)
    80009bf2:	07e2                	slli	a5,a5,0x18
    80009bf4:	8fd9                	or	a5,a5,a4
    80009bf6:	2781                	sext.w	a5,a5
    80009bf8:	00003717          	auipc	a4,0x3
    80009bfc:	cb072703          	lw	a4,-848(a4) # 8000c8a8 <netconf>
    80009c00:	00f70563          	beq	a4,a5,80009c0a <arp_recv+0x10a>
    80009c04:	577d                	li	a4,-1
    80009c06:	12e79b63          	bne	a5,a4,80009d3c <arp_recv+0x23c>
    80009c0a:	e44e                	sd	s3,8(sp)
    80009c0c:	6685                	lui	a3,0x1
    80009c0e:	80668693          	addi	a3,a3,-2042 # 806 <_entry-0x7ffff7fa>
    80009c12:	00003617          	auipc	a2,0x3
    80009c16:	c9a60613          	addi	a2,a2,-870 # 8000c8ac <netconf+0x4>
    80009c1a:	85ca                	mv	a1,s2
    80009c1c:	8526                	mv	a0,s1
    80009c1e:	fffff097          	auipc	ra,0xfffff
    80009c22:	f12080e7          	jalr	-238(ra) # 80008b30 <build_eth>
    80009c26:	00048723          	sb	zero,14(s1)
    80009c2a:	4785                	li	a5,1
    80009c2c:	00f487a3          	sb	a5,15(s1)
    80009c30:	47a1                	li	a5,8
    80009c32:	00f48823          	sb	a5,16(s1)
    80009c36:	000488a3          	sb	zero,17(s1)
    80009c3a:	4999                	li	s3,6
    80009c3c:	01348923          	sb	s3,18(s1)
    80009c40:	4791                	li	a5,4
    80009c42:	00f489a3          	sb	a5,19(s1)
    80009c46:	00048a23          	sb	zero,20(s1)
    80009c4a:	4789                	li	a5,2
    80009c4c:	00f48aa3          	sb	a5,21(s1)
    80009c50:	00003797          	auipc	a5,0x3
    80009c54:	c5878793          	addi	a5,a5,-936 # 8000c8a8 <netconf>
    80009c58:	0007c703          	lbu	a4,0(a5)
    80009c5c:	00e48e23          	sb	a4,28(s1)
    80009c60:	439c                	lw	a5,0(a5)
    80009c62:	0087d71b          	srliw	a4,a5,0x8
    80009c66:	00e48ea3          	sb	a4,29(s1)
    80009c6a:	0107d71b          	srliw	a4,a5,0x10
    80009c6e:	00e48f23          	sb	a4,30(s1)
    80009c72:	0187d79b          	srliw	a5,a5,0x18
    80009c76:	00f48fa3          	sb	a5,31(s1)
    80009c7a:	00ea4703          	lbu	a4,14(s4)
    80009c7e:	00fa4783          	lbu	a5,15(s4)
    80009c82:	07a2                	slli	a5,a5,0x8
    80009c84:	8fd9                	or	a5,a5,a4
    80009c86:	010a4703          	lbu	a4,16(s4)
    80009c8a:	0742                	slli	a4,a4,0x10
    80009c8c:	8f5d                	or	a4,a4,a5
    80009c8e:	011a4783          	lbu	a5,17(s4)
    80009c92:	07e2                	slli	a5,a5,0x18
    80009c94:	8fd9                	or	a5,a5,a4
    80009c96:	02f48323          	sb	a5,38(s1)
    80009c9a:	0087d713          	srli	a4,a5,0x8
    80009c9e:	02e483a3          	sb	a4,39(s1)
    80009ca2:	0107d713          	srli	a4,a5,0x10
    80009ca6:	02e48423          	sb	a4,40(s1)
    80009caa:	83e1                	srli	a5,a5,0x18
    80009cac:	02f484a3          	sb	a5,41(s1)
    80009cb0:	864e                	mv	a2,s3
    80009cb2:	00003597          	auipc	a1,0x3
    80009cb6:	bfa58593          	addi	a1,a1,-1030 # 8000c8ac <netconf+0x4>
    80009cba:	01648513          	addi	a0,s1,22
    80009cbe:	ffff7097          	auipc	ra,0xffff7
    80009cc2:	1aa080e7          	jalr	426(ra) # 80000e68 <memmove>
    80009cc6:	864e                	mv	a2,s3
    80009cc8:	85ca                	mv	a1,s2
    80009cca:	02048513          	addi	a0,s1,32
    80009cce:	ffff7097          	auipc	ra,0xffff7
    80009cd2:	19a080e7          	jalr	410(ra) # 80000e68 <memmove>
    80009cd6:	6605                	lui	a2,0x1
    80009cd8:	80660613          	addi	a2,a2,-2042 # 806 <_entry-0x7ffff7fa>
    80009cdc:	02a00593          	li	a1,42
    80009ce0:	8526                	mv	a0,s1
    80009ce2:	ffffe097          	auipc	ra,0xffffe
    80009ce6:	a8a080e7          	jalr	-1398(ra) # 8000776c <transmit_packet>
    80009cea:	8526                	mv	a0,s1
    80009cec:	ffff7097          	auipc	ra,0xffff7
    80009cf0:	dae080e7          	jalr	-594(ra) # 80000a9a <kfree>
    80009cf4:	6942                	ld	s2,16(sp)
    80009cf6:	69a2                	ld	s3,8(sp)
    80009cf8:	bd69                	j	80009b92 <arp_recv+0x92>
    80009cfa:	00001517          	auipc	a0,0x1
    80009cfe:	77e50513          	addi	a0,a0,1918 # 8000b478 <etext+0x478>
    80009d02:	ffff7097          	auipc	ra,0xffff7
    80009d06:	8a8080e7          	jalr	-1880(ra) # 800005aa <printf>
    80009d0a:	b561                	j	80009b92 <arp_recv+0x92>
    80009d0c:	00e54783          	lbu	a5,14(a0)
    80009d10:	00f54703          	lbu	a4,15(a0)
    80009d14:	0722                	slli	a4,a4,0x8
    80009d16:	8f5d                	or	a4,a4,a5
    80009d18:	01054783          	lbu	a5,16(a0)
    80009d1c:	07c2                	slli	a5,a5,0x10
    80009d1e:	8fd9                	or	a5,a5,a4
    80009d20:	01154503          	lbu	a0,17(a0)
    80009d24:	0562                	slli	a0,a0,0x18
    80009d26:	8d5d                	or	a0,a0,a5
    80009d28:	008a0593          	addi	a1,s4,8
    80009d2c:	2501                	sext.w	a0,a0
    80009d2e:	00000097          	auipc	ra,0x0
    80009d32:	c1e080e7          	jalr	-994(ra) # 8000994c <arp_insert>
    80009d36:	6942                	ld	s2,16(sp)
    80009d38:	69a2                	ld	s3,8(sp)
    80009d3a:	bda1                	j	80009b92 <arp_recv+0x92>
    80009d3c:	6942                	ld	s2,16(sp)
    80009d3e:	bd91                	j	80009b92 <arp_recv+0x92>
	...

000000008000a000 <_trampoline>:
    8000a000:	14051073          	csrw	sscratch,a0
    8000a004:	02000537          	lui	a0,0x2000
    8000a008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000a00a:	0536                	slli	a0,a0,0xd
    8000a00c:	02153423          	sd	ra,40(a0)
    8000a010:	02253823          	sd	sp,48(a0)
    8000a014:	02353c23          	sd	gp,56(a0)
    8000a018:	04453023          	sd	tp,64(a0)
    8000a01c:	04553423          	sd	t0,72(a0)
    8000a020:	04653823          	sd	t1,80(a0)
    8000a024:	04753c23          	sd	t2,88(a0)
    8000a028:	f120                	sd	s0,96(a0)
    8000a02a:	f524                	sd	s1,104(a0)
    8000a02c:	fd2c                	sd	a1,120(a0)
    8000a02e:	e150                	sd	a2,128(a0)
    8000a030:	e554                	sd	a3,136(a0)
    8000a032:	e958                	sd	a4,144(a0)
    8000a034:	ed5c                	sd	a5,152(a0)
    8000a036:	0b053023          	sd	a6,160(a0)
    8000a03a:	0b153423          	sd	a7,168(a0)
    8000a03e:	0b253823          	sd	s2,176(a0)
    8000a042:	0b353c23          	sd	s3,184(a0)
    8000a046:	0d453023          	sd	s4,192(a0)
    8000a04a:	0d553423          	sd	s5,200(a0)
    8000a04e:	0d653823          	sd	s6,208(a0)
    8000a052:	0d753c23          	sd	s7,216(a0)
    8000a056:	0f853023          	sd	s8,224(a0)
    8000a05a:	0f953423          	sd	s9,232(a0)
    8000a05e:	0fa53823          	sd	s10,240(a0)
    8000a062:	0fb53c23          	sd	s11,248(a0)
    8000a066:	11c53023          	sd	t3,256(a0)
    8000a06a:	11d53423          	sd	t4,264(a0)
    8000a06e:	11e53823          	sd	t5,272(a0)
    8000a072:	11f53c23          	sd	t6,280(a0)
    8000a076:	140022f3          	csrr	t0,sscratch
    8000a07a:	06553823          	sd	t0,112(a0)
    8000a07e:	00853103          	ld	sp,8(a0)
    8000a082:	02053203          	ld	tp,32(a0)
    8000a086:	01053283          	ld	t0,16(a0)
    8000a08a:	00053303          	ld	t1,0(a0)
    8000a08e:	12000073          	sfence.vma
    8000a092:	18031073          	csrw	satp,t1
    8000a096:	12000073          	sfence.vma
    8000a09a:	8282                	jr	t0

000000008000a09c <userret>:
    8000a09c:	12000073          	sfence.vma
    8000a0a0:	18051073          	csrw	satp,a0
    8000a0a4:	12000073          	sfence.vma
    8000a0a8:	02000537          	lui	a0,0x2000
    8000a0ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000a0ae:	0536                	slli	a0,a0,0xd
    8000a0b0:	02853083          	ld	ra,40(a0)
    8000a0b4:	03053103          	ld	sp,48(a0)
    8000a0b8:	03853183          	ld	gp,56(a0)
    8000a0bc:	04053203          	ld	tp,64(a0)
    8000a0c0:	04853283          	ld	t0,72(a0)
    8000a0c4:	05053303          	ld	t1,80(a0)
    8000a0c8:	05853383          	ld	t2,88(a0)
    8000a0cc:	7120                	ld	s0,96(a0)
    8000a0ce:	7524                	ld	s1,104(a0)
    8000a0d0:	7d2c                	ld	a1,120(a0)
    8000a0d2:	6150                	ld	a2,128(a0)
    8000a0d4:	6554                	ld	a3,136(a0)
    8000a0d6:	6958                	ld	a4,144(a0)
    8000a0d8:	6d5c                	ld	a5,152(a0)
    8000a0da:	0a053803          	ld	a6,160(a0)
    8000a0de:	0a853883          	ld	a7,168(a0)
    8000a0e2:	0b053903          	ld	s2,176(a0)
    8000a0e6:	0b853983          	ld	s3,184(a0)
    8000a0ea:	0c053a03          	ld	s4,192(a0)
    8000a0ee:	0c853a83          	ld	s5,200(a0)
    8000a0f2:	0d053b03          	ld	s6,208(a0)
    8000a0f6:	0d853b83          	ld	s7,216(a0)
    8000a0fa:	0e053c03          	ld	s8,224(a0)
    8000a0fe:	0e853c83          	ld	s9,232(a0)
    8000a102:	0f053d03          	ld	s10,240(a0)
    8000a106:	0f853d83          	ld	s11,248(a0)
    8000a10a:	10053e03          	ld	t3,256(a0)
    8000a10e:	10853e83          	ld	t4,264(a0)
    8000a112:	11053f03          	ld	t5,272(a0)
    8000a116:	11853f83          	ld	t6,280(a0)
    8000a11a:	7928                	ld	a0,112(a0)
    8000a11c:	10200073          	sret
	...
