
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000d117          	auipc	sp,0xd
    80000004:	b3010113          	addi	sp,sp,-1232 # 8000cb30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	8000008e <start>

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
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000024:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000028:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037961b          	slliw	a2,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	963a                	add	a2,a2,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f46b7          	lui	a3,0xf4
    80000040:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9736                	add	a4,a4,a3
    80000046:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00279713          	slli	a4,a5,0x2
    8000004c:	973e                	add	a4,a4,a5
    8000004e:	070e                	slli	a4,a4,0x3
    80000050:	0000d797          	auipc	a5,0xd
    80000054:	9a078793          	addi	a5,a5,-1632 # 8000c9f0 <timer_scratch>
    80000058:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    8000005c:	f394                	sd	a3,32(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00007797          	auipc	a5,0x7
    80000066:	80e78793          	addi	a5,a5,-2034 # 80006870 <timervec>
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
    80000086:	60a2                	ld	ra,8(sp)
    80000088:	6402                	ld	s0,0(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff90727>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	ff678793          	addi	a5,a5,-10 # 800010a4 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	711d                	addi	sp,sp,-96
    80000104:	ec86                	sd	ra,88(sp)
    80000106:	e8a2                	sd	s0,80(sp)
    80000108:	e0ca                	sd	s2,64(sp)
    8000010a:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    8000010c:	04c05b63          	blez	a2,80000162 <consolewrite+0x60>
    80000110:	e4a6                	sd	s1,72(sp)
    80000112:	fc4e                	sd	s3,56(sp)
    80000114:	f852                	sd	s4,48(sp)
    80000116:	f456                	sd	s5,40(sp)
    80000118:	f05a                	sd	s6,32(sp)
    8000011a:	ec5e                	sd	s7,24(sp)
    8000011c:	8a2a                	mv	s4,a0
    8000011e:	84ae                	mv	s1,a1
    80000120:	89b2                	mv	s3,a2
    80000122:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000124:	faf40b93          	addi	s7,s0,-81
    80000128:	4b05                	li	s6,1
    8000012a:	5afd                	li	s5,-1
    8000012c:	86da                	mv	a3,s6
    8000012e:	8626                	mv	a2,s1
    80000130:	85d2                	mv	a1,s4
    80000132:	855e                	mv	a0,s7
    80000134:	00003097          	auipc	ra,0x3
    80000138:	dec080e7          	jalr	-532(ra) # 80002f20 <either_copyin>
    8000013c:	03550563          	beq	a0,s5,80000166 <consolewrite+0x64>
      break;
    uartputc(c);
    80000140:	faf44503          	lbu	a0,-81(s0)
    80000144:	00000097          	auipc	ra,0x0
    80000148:	7d8080e7          	jalr	2008(ra) # 8000091c <uartputc>
  for(i = 0; i < n; i++){
    8000014c:	2905                	addiw	s2,s2,1
    8000014e:	0485                	addi	s1,s1,1
    80000150:	fd299ee3          	bne	s3,s2,8000012c <consolewrite+0x2a>
    80000154:	64a6                	ld	s1,72(sp)
    80000156:	79e2                	ld	s3,56(sp)
    80000158:	7a42                	ld	s4,48(sp)
    8000015a:	7aa2                	ld	s5,40(sp)
    8000015c:	7b02                	ld	s6,32(sp)
    8000015e:	6be2                	ld	s7,24(sp)
    80000160:	a809                	j	80000172 <consolewrite+0x70>
    80000162:	4901                	li	s2,0
    80000164:	a039                	j	80000172 <consolewrite+0x70>
    80000166:	64a6                	ld	s1,72(sp)
    80000168:	79e2                	ld	s3,56(sp)
    8000016a:	7a42                	ld	s4,48(sp)
    8000016c:	7aa2                	ld	s5,40(sp)
    8000016e:	7b02                	ld	s6,32(sp)
    80000170:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80000172:	854a                	mv	a0,s2
    80000174:	60e6                	ld	ra,88(sp)
    80000176:	6446                	ld	s0,80(sp)
    80000178:	6906                	ld	s2,64(sp)
    8000017a:	6125                	addi	sp,sp,96
    8000017c:	8082                	ret

000000008000017e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000017e:	711d                	addi	sp,sp,-96
    80000180:	ec86                	sd	ra,88(sp)
    80000182:	e8a2                	sd	s0,80(sp)
    80000184:	e4a6                	sd	s1,72(sp)
    80000186:	e0ca                	sd	s2,64(sp)
    80000188:	fc4e                	sd	s3,56(sp)
    8000018a:	f852                	sd	s4,48(sp)
    8000018c:	f05a                	sd	s6,32(sp)
    8000018e:	ec5e                	sd	s7,24(sp)
    80000190:	1080                	addi	s0,sp,96
    80000192:	8b2a                	mv	s6,a0
    80000194:	8a2e                	mv	s4,a1
    80000196:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000198:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    8000019a:	00015517          	auipc	a0,0x15
    8000019e:	99650513          	addi	a0,a0,-1642 # 80014b30 <cons>
    800001a2:	00001097          	auipc	ra,0x1
    800001a6:	b92080e7          	jalr	-1134(ra) # 80000d34 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001aa:	00015497          	auipc	s1,0x15
    800001ae:	98648493          	addi	s1,s1,-1658 # 80014b30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b2:	00015917          	auipc	s2,0x15
    800001b6:	a1690913          	addi	s2,s2,-1514 # 80014bc8 <cons+0x98>
  while(n > 0){
    800001ba:	0d305563          	blez	s3,80000284 <consoleread+0x106>
    while(cons.r == cons.w){
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	0af71a63          	bne	a4,a5,8000027a <consoleread+0xfc>
      if(killed(myproc())){
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	d6a080e7          	jalr	-662(ra) # 80001f34 <myproc>
    800001d2:	00003097          	auipc	ra,0x3
    800001d6:	a5c080e7          	jalr	-1444(ra) # 80002c2e <killed>
    800001da:	e52d                	bnez	a0,80000244 <consoleread+0xc6>
      sleep(&cons.r, &cons.lock);
    800001dc:	85a6                	mv	a1,s1
    800001de:	854a                	mv	a0,s2
    800001e0:	00002097          	auipc	ra,0x2
    800001e4:	60a080e7          	jalr	1546(ra) # 800027ea <sleep>
    while(cons.r == cons.w){
    800001e8:	0984a783          	lw	a5,152(s1)
    800001ec:	09c4a703          	lw	a4,156(s1)
    800001f0:	fcf70de3          	beq	a4,a5,800001ca <consoleread+0x4c>
    800001f4:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f6:	00015717          	auipc	a4,0x15
    800001fa:	93a70713          	addi	a4,a4,-1734 # 80014b30 <cons>
    800001fe:	0017869b          	addiw	a3,a5,1
    80000202:	08d72c23          	sw	a3,152(a4)
    80000206:	07f7f693          	andi	a3,a5,127
    8000020a:	9736                	add	a4,a4,a3
    8000020c:	01874703          	lbu	a4,24(a4)
    80000210:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    80000214:	4691                	li	a3,4
    80000216:	04da8a63          	beq	s5,a3,8000026a <consoleread+0xec>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000021a:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000021e:	4685                	li	a3,1
    80000220:	faf40613          	addi	a2,s0,-81
    80000224:	85d2                	mv	a1,s4
    80000226:	855a                	mv	a0,s6
    80000228:	00003097          	auipc	ra,0x3
    8000022c:	ca2080e7          	jalr	-862(ra) # 80002eca <either_copyout>
    80000230:	57fd                	li	a5,-1
    80000232:	04f50863          	beq	a0,a5,80000282 <consoleread+0x104>
      break;

    dst++;
    80000236:	0a05                	addi	s4,s4,1
    --n;
    80000238:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000023a:	47a9                	li	a5,10
    8000023c:	04fa8f63          	beq	s5,a5,8000029a <consoleread+0x11c>
    80000240:	7aa2                	ld	s5,40(sp)
    80000242:	bfa5                	j	800001ba <consoleread+0x3c>
        release(&cons.lock);
    80000244:	00015517          	auipc	a0,0x15
    80000248:	8ec50513          	addi	a0,a0,-1812 # 80014b30 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	b98080e7          	jalr	-1128(ra) # 80000de4 <release>
        return -1;
    80000254:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000256:	60e6                	ld	ra,88(sp)
    80000258:	6446                	ld	s0,80(sp)
    8000025a:	64a6                	ld	s1,72(sp)
    8000025c:	6906                	ld	s2,64(sp)
    8000025e:	79e2                	ld	s3,56(sp)
    80000260:	7a42                	ld	s4,48(sp)
    80000262:	7b02                	ld	s6,32(sp)
    80000264:	6be2                	ld	s7,24(sp)
    80000266:	6125                	addi	sp,sp,96
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0179fa63          	bgeu	s3,s7,8000027e <consoleread+0x100>
        cons.r--;
    8000026e:	00015717          	auipc	a4,0x15
    80000272:	94f72d23          	sw	a5,-1702(a4) # 80014bc8 <cons+0x98>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	a031                	j	80000284 <consoleread+0x106>
    8000027a:	f456                	sd	s5,40(sp)
    8000027c:	bfad                	j	800001f6 <consoleread+0x78>
    8000027e:	7aa2                	ld	s5,40(sp)
    80000280:	a011                	j	80000284 <consoleread+0x106>
    80000282:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000284:	00015517          	auipc	a0,0x15
    80000288:	8ac50513          	addi	a0,a0,-1876 # 80014b30 <cons>
    8000028c:	00001097          	auipc	ra,0x1
    80000290:	b58080e7          	jalr	-1192(ra) # 80000de4 <release>
  return target - n;
    80000294:	413b853b          	subw	a0,s7,s3
    80000298:	bf7d                	j	80000256 <consoleread+0xd8>
    8000029a:	7aa2                	ld	s5,40(sp)
    8000029c:	b7e5                	j	80000284 <consoleread+0x106>

000000008000029e <consputc>:
{
    8000029e:	1141                	addi	sp,sp,-16
    800002a0:	e406                	sd	ra,8(sp)
    800002a2:	e022                	sd	s0,0(sp)
    800002a4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800002a6:	10000793          	li	a5,256
    800002aa:	00f50a63          	beq	a0,a5,800002be <consputc+0x20>
    uartputc_sync(c);
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	590080e7          	jalr	1424(ra) # 8000083e <uartputc_sync>
}
    800002b6:	60a2                	ld	ra,8(sp)
    800002b8:	6402                	ld	s0,0(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002be:	4521                	li	a0,8
    800002c0:	00000097          	auipc	ra,0x0
    800002c4:	57e080e7          	jalr	1406(ra) # 8000083e <uartputc_sync>
    800002c8:	02000513          	li	a0,32
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	572080e7          	jalr	1394(ra) # 8000083e <uartputc_sync>
    800002d4:	4521                	li	a0,8
    800002d6:	00000097          	auipc	ra,0x0
    800002da:	568080e7          	jalr	1384(ra) # 8000083e <uartputc_sync>
    800002de:	bfe1                	j	800002b6 <consputc+0x18>

00000000800002e0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002e0:	1101                	addi	sp,sp,-32
    800002e2:	ec06                	sd	ra,24(sp)
    800002e4:	e822                	sd	s0,16(sp)
    800002e6:	e426                	sd	s1,8(sp)
    800002e8:	1000                	addi	s0,sp,32
    800002ea:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ec:	00015517          	auipc	a0,0x15
    800002f0:	84450513          	addi	a0,a0,-1980 # 80014b30 <cons>
    800002f4:	00001097          	auipc	ra,0x1
    800002f8:	a40080e7          	jalr	-1472(ra) # 80000d34 <acquire>

  switch(c){
    800002fc:	47d5                	li	a5,21
    800002fe:	0af48363          	beq	s1,a5,800003a4 <consoleintr+0xc4>
    80000302:	0297c963          	blt	a5,s1,80000334 <consoleintr+0x54>
    80000306:	47a1                	li	a5,8
    80000308:	0ef48a63          	beq	s1,a5,800003fc <consoleintr+0x11c>
    8000030c:	47c1                	li	a5,16
    8000030e:	10f49d63          	bne	s1,a5,80000428 <consoleintr+0x148>
  case C('P'):  // Print process list.
    procdump();
    80000312:	00003097          	auipc	ra,0x3
    80000316:	c64080e7          	jalr	-924(ra) # 80002f76 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000031a:	00015517          	auipc	a0,0x15
    8000031e:	81650513          	addi	a0,a0,-2026 # 80014b30 <cons>
    80000322:	00001097          	auipc	ra,0x1
    80000326:	ac2080e7          	jalr	-1342(ra) # 80000de4 <release>
}
    8000032a:	60e2                	ld	ra,24(sp)
    8000032c:	6442                	ld	s0,16(sp)
    8000032e:	64a2                	ld	s1,8(sp)
    80000330:	6105                	addi	sp,sp,32
    80000332:	8082                	ret
  switch(c){
    80000334:	07f00793          	li	a5,127
    80000338:	0cf48263          	beq	s1,a5,800003fc <consoleintr+0x11c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000033c:	00014717          	auipc	a4,0x14
    80000340:	7f470713          	addi	a4,a4,2036 # 80014b30 <cons>
    80000344:	0a072783          	lw	a5,160(a4)
    80000348:	09872703          	lw	a4,152(a4)
    8000034c:	9f99                	subw	a5,a5,a4
    8000034e:	07f00713          	li	a4,127
    80000352:	fcf764e3          	bltu	a4,a5,8000031a <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80000356:	47b5                	li	a5,13
    80000358:	0cf48b63          	beq	s1,a5,8000042e <consoleintr+0x14e>
      consputc(c);
    8000035c:	8526                	mv	a0,s1
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	f40080e7          	jalr	-192(ra) # 8000029e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000366:	00014717          	auipc	a4,0x14
    8000036a:	7ca70713          	addi	a4,a4,1994 # 80014b30 <cons>
    8000036e:	0a072683          	lw	a3,160(a4)
    80000372:	0016879b          	addiw	a5,a3,1
    80000376:	863e                	mv	a2,a5
    80000378:	0af72023          	sw	a5,160(a4)
    8000037c:	07f6f693          	andi	a3,a3,127
    80000380:	9736                	add	a4,a4,a3
    80000382:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000386:	ff648713          	addi	a4,s1,-10
    8000038a:	cb61                	beqz	a4,8000045a <consoleintr+0x17a>
    8000038c:	14f1                	addi	s1,s1,-4
    8000038e:	c4f1                	beqz	s1,8000045a <consoleintr+0x17a>
    80000390:	00015717          	auipc	a4,0x15
    80000394:	83872703          	lw	a4,-1992(a4) # 80014bc8 <cons+0x98>
    80000398:	9f99                	subw	a5,a5,a4
    8000039a:	08000713          	li	a4,128
    8000039e:	f6e79ee3          	bne	a5,a4,8000031a <consoleintr+0x3a>
    800003a2:	a865                	j	8000045a <consoleintr+0x17a>
    800003a4:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800003a6:	00014717          	auipc	a4,0x14
    800003aa:	78a70713          	addi	a4,a4,1930 # 80014b30 <cons>
    800003ae:	0a072783          	lw	a5,160(a4)
    800003b2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003b6:	00014497          	auipc	s1,0x14
    800003ba:	77a48493          	addi	s1,s1,1914 # 80014b30 <cons>
    while(cons.e != cons.w &&
    800003be:	4929                	li	s2,10
    800003c0:	02f70a63          	beq	a4,a5,800003f4 <consoleintr+0x114>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003c4:	37fd                	addiw	a5,a5,-1
    800003c6:	07f7f713          	andi	a4,a5,127
    800003ca:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003cc:	01874703          	lbu	a4,24(a4)
    800003d0:	03270463          	beq	a4,s2,800003f8 <consoleintr+0x118>
      cons.e--;
    800003d4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003d8:	10000513          	li	a0,256
    800003dc:	00000097          	auipc	ra,0x0
    800003e0:	ec2080e7          	jalr	-318(ra) # 8000029e <consputc>
    while(cons.e != cons.w &&
    800003e4:	0a04a783          	lw	a5,160(s1)
    800003e8:	09c4a703          	lw	a4,156(s1)
    800003ec:	fcf71ce3          	bne	a4,a5,800003c4 <consoleintr+0xe4>
    800003f0:	6902                	ld	s2,0(sp)
    800003f2:	b725                	j	8000031a <consoleintr+0x3a>
    800003f4:	6902                	ld	s2,0(sp)
    800003f6:	b715                	j	8000031a <consoleintr+0x3a>
    800003f8:	6902                	ld	s2,0(sp)
    800003fa:	b705                	j	8000031a <consoleintr+0x3a>
    if(cons.e != cons.w){
    800003fc:	00014717          	auipc	a4,0x14
    80000400:	73470713          	addi	a4,a4,1844 # 80014b30 <cons>
    80000404:	0a072783          	lw	a5,160(a4)
    80000408:	09c72703          	lw	a4,156(a4)
    8000040c:	f0f707e3          	beq	a4,a5,8000031a <consoleintr+0x3a>
      cons.e--;
    80000410:	37fd                	addiw	a5,a5,-1
    80000412:	00014717          	auipc	a4,0x14
    80000416:	7af72f23          	sw	a5,1982(a4) # 80014bd0 <cons+0xa0>
      consputc(BACKSPACE);
    8000041a:	10000513          	li	a0,256
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	e80080e7          	jalr	-384(ra) # 8000029e <consputc>
    80000426:	bdd5                	j	8000031a <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000428:	ee0489e3          	beqz	s1,8000031a <consoleintr+0x3a>
    8000042c:	bf01                	j	8000033c <consoleintr+0x5c>
      consputc(c);
    8000042e:	4529                	li	a0,10
    80000430:	00000097          	auipc	ra,0x0
    80000434:	e6e080e7          	jalr	-402(ra) # 8000029e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000438:	00014797          	auipc	a5,0x14
    8000043c:	6f878793          	addi	a5,a5,1784 # 80014b30 <cons>
    80000440:	0a07a703          	lw	a4,160(a5)
    80000444:	0017069b          	addiw	a3,a4,1
    80000448:	8636                	mv	a2,a3
    8000044a:	0ad7a023          	sw	a3,160(a5)
    8000044e:	07f77713          	andi	a4,a4,127
    80000452:	97ba                	add	a5,a5,a4
    80000454:	4729                	li	a4,10
    80000456:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000045a:	00014797          	auipc	a5,0x14
    8000045e:	76c7a923          	sw	a2,1906(a5) # 80014bcc <cons+0x9c>
        wakeup(&cons.r);
    80000462:	00014517          	auipc	a0,0x14
    80000466:	76650513          	addi	a0,a0,1894 # 80014bc8 <cons+0x98>
    8000046a:	00002097          	auipc	ra,0x2
    8000046e:	3e4080e7          	jalr	996(ra) # 8000284e <wakeup>
    80000472:	b565                	j	8000031a <consoleintr+0x3a>

0000000080000474 <consoleinit>:

void
consoleinit(void)
{
    80000474:	1141                	addi	sp,sp,-16
    80000476:	e406                	sd	ra,8(sp)
    80000478:	e022                	sd	s0,0(sp)
    8000047a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000047c:	00009597          	auipc	a1,0x9
    80000480:	b8458593          	addi	a1,a1,-1148 # 80009000 <etext>
    80000484:	00014517          	auipc	a0,0x14
    80000488:	6ac50513          	addi	a0,a0,1708 # 80014b30 <cons>
    8000048c:	00001097          	auipc	ra,0x1
    80000490:	80e080e7          	jalr	-2034(ra) # 80000c9a <initlock>

  uartinit();
    80000494:	00000097          	auipc	ra,0x0
    80000498:	350080e7          	jalr	848(ra) # 800007e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000049c:	0006d797          	auipc	a5,0x6d
    800004a0:	a2c78793          	addi	a5,a5,-1492 # 8006cec8 <devsw>
    800004a4:	00000717          	auipc	a4,0x0
    800004a8:	cda70713          	addi	a4,a4,-806 # 8000017e <consoleread>
    800004ac:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004ae:	00000717          	auipc	a4,0x0
    800004b2:	c5470713          	addi	a4,a4,-940 # 80000102 <consolewrite>
    800004b6:	ef98                	sd	a4,24(a5)
}
    800004b8:	60a2                	ld	ra,8(sp)
    800004ba:	6402                	ld	s0,0(sp)
    800004bc:	0141                	addi	sp,sp,16
    800004be:	8082                	ret

00000000800004c0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004c0:	7179                	addi	sp,sp,-48
    800004c2:	f406                	sd	ra,40(sp)
    800004c4:	f022                	sd	s0,32(sp)
    800004c6:	e84a                	sd	s2,16(sp)
    800004c8:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004ca:	c219                	beqz	a2,800004d0 <printint+0x10>
    800004cc:	08054563          	bltz	a0,80000556 <printint+0x96>
    x = -xx;
  else
    x = xx;
    800004d0:	4301                	li	t1,0

  i = 0;
    800004d2:	fd040913          	addi	s2,s0,-48
    x = xx;
    800004d6:	86ca                	mv	a3,s2
  i = 0;
    800004d8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004da:	00009817          	auipc	a6,0x9
    800004de:	4ee80813          	addi	a6,a6,1262 # 800099c8 <digits>
    800004e2:	88ba                	mv	a7,a4
    800004e4:	0017061b          	addiw	a2,a4,1
    800004e8:	8732                	mv	a4,a2
    800004ea:	02b577bb          	remuw	a5,a0,a1
    800004ee:	1782                	slli	a5,a5,0x20
    800004f0:	9381                	srli	a5,a5,0x20
    800004f2:	97c2                	add	a5,a5,a6
    800004f4:	0007c783          	lbu	a5,0(a5)
    800004f8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004fc:	87aa                	mv	a5,a0
    800004fe:	02b5553b          	divuw	a0,a0,a1
    80000502:	0685                	addi	a3,a3,1
    80000504:	fcb7ffe3          	bgeu	a5,a1,800004e2 <printint+0x22>

  if(sign)
    80000508:	00030c63          	beqz	t1,80000520 <printint+0x60>
    buf[i++] = '-';
    8000050c:	fe060793          	addi	a5,a2,-32
    80000510:	00878633          	add	a2,a5,s0
    80000514:	02d00793          	li	a5,45
    80000518:	fef60823          	sb	a5,-16(a2)
    8000051c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    80000520:	02e05663          	blez	a4,8000054c <printint+0x8c>
    80000524:	ec26                	sd	s1,24(sp)
    80000526:	377d                	addiw	a4,a4,-1
    80000528:	00e904b3          	add	s1,s2,a4
    8000052c:	197d                	addi	s2,s2,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	1702                	slli	a4,a4,0x20
    80000532:	9301                	srli	a4,a4,0x20
    80000534:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000538:	0004c503          	lbu	a0,0(s1)
    8000053c:	00000097          	auipc	ra,0x0
    80000540:	d62080e7          	jalr	-670(ra) # 8000029e <consputc>
  while(--i >= 0)
    80000544:	14fd                	addi	s1,s1,-1
    80000546:	ff2499e3          	bne	s1,s2,80000538 <printint+0x78>
    8000054a:	64e2                	ld	s1,24(sp)
}
    8000054c:	70a2                	ld	ra,40(sp)
    8000054e:	7402                	ld	s0,32(sp)
    80000550:	6942                	ld	s2,16(sp)
    80000552:	6145                	addi	sp,sp,48
    80000554:	8082                	ret
    x = -xx;
    80000556:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055a:	4305                	li	t1,1
    x = -xx;
    8000055c:	bf9d                	j	800004d2 <printint+0x12>

000000008000055e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000055e:	1101                	addi	sp,sp,-32
    80000560:	ec06                	sd	ra,24(sp)
    80000562:	e822                	sd	s0,16(sp)
    80000564:	e426                	sd	s1,8(sp)
    80000566:	1000                	addi	s0,sp,32
    80000568:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056a:	00014797          	auipc	a5,0x14
    8000056e:	6807a323          	sw	zero,1670(a5) # 80014bf0 <pr+0x18>
  printf("panic: ");
    80000572:	00009517          	auipc	a0,0x9
    80000576:	a9650513          	addi	a0,a0,-1386 # 80009008 <etext+0x8>
    8000057a:	00000097          	auipc	ra,0x0
    8000057e:	02e080e7          	jalr	46(ra) # 800005a8 <printf>
  printf(s);
    80000582:	8526                	mv	a0,s1
    80000584:	00000097          	auipc	ra,0x0
    80000588:	024080e7          	jalr	36(ra) # 800005a8 <printf>
  printf("\n");
    8000058c:	00009517          	auipc	a0,0x9
    80000590:	a8450513          	addi	a0,a0,-1404 # 80009010 <etext+0x10>
    80000594:	00000097          	auipc	ra,0x0
    80000598:	014080e7          	jalr	20(ra) # 800005a8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059c:	4785                	li	a5,1
    8000059e:	0000c717          	auipc	a4,0xc
    800005a2:	40f72923          	sw	a5,1042(a4) # 8000c9b0 <panicked>
  for(;;)
    800005a6:	a001                	j	800005a6 <panic+0x48>

00000000800005a8 <printf>:
{
    800005a8:	7131                	addi	sp,sp,-192
    800005aa:	fc86                	sd	ra,120(sp)
    800005ac:	f8a2                	sd	s0,112(sp)
    800005ae:	e8d2                	sd	s4,80(sp)
    800005b0:	ec6e                	sd	s11,24(sp)
    800005b2:	0100                	addi	s0,sp,128
    800005b4:	8a2a                	mv	s4,a0
    800005b6:	e40c                	sd	a1,8(s0)
    800005b8:	e810                	sd	a2,16(s0)
    800005ba:	ec14                	sd	a3,24(s0)
    800005bc:	f018                	sd	a4,32(s0)
    800005be:	f41c                	sd	a5,40(s0)
    800005c0:	03043823          	sd	a6,48(s0)
    800005c4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c8:	00014d97          	auipc	s11,0x14
    800005cc:	628dad83          	lw	s11,1576(s11) # 80014bf0 <pr+0x18>
  if(locking)
    800005d0:	040d9463          	bnez	s11,80000618 <printf+0x70>
  if (fmt == 0)
    800005d4:	040a0b63          	beqz	s4,8000062a <printf+0x82>
  va_start(ap, fmt);
    800005d8:	00840793          	addi	a5,s0,8
    800005dc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e0:	000a4503          	lbu	a0,0(s4)
    800005e4:	18050c63          	beqz	a0,8000077c <printf+0x1d4>
    800005e8:	f4a6                	sd	s1,104(sp)
    800005ea:	f0ca                	sd	s2,96(sp)
    800005ec:	ecce                	sd	s3,88(sp)
    800005ee:	e4d6                	sd	s5,72(sp)
    800005f0:	e0da                	sd	s6,64(sp)
    800005f2:	fc5e                	sd	s7,56(sp)
    800005f4:	f862                	sd	s8,48(sp)
    800005f6:	f466                	sd	s9,40(sp)
    800005f8:	f06a                	sd	s10,32(sp)
    800005fa:	4981                	li	s3,0
    if(c != '%'){
    800005fc:	02500b13          	li	s6,37
    switch(c){
    80000600:	07000b93          	li	s7,112
  consputc('x');
    80000604:	07800c93          	li	s9,120
    80000608:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000060a:	00009a97          	auipc	s5,0x9
    8000060e:	3bea8a93          	addi	s5,s5,958 # 800099c8 <digits>
    switch(c){
    80000612:	07300c13          	li	s8,115
    80000616:	a0b9                	j	80000664 <printf+0xbc>
    acquire(&pr.lock);
    80000618:	00014517          	auipc	a0,0x14
    8000061c:	5c050513          	addi	a0,a0,1472 # 80014bd8 <pr>
    80000620:	00000097          	auipc	ra,0x0
    80000624:	714080e7          	jalr	1812(ra) # 80000d34 <acquire>
    80000628:	b775                	j	800005d4 <printf+0x2c>
    8000062a:	f4a6                	sd	s1,104(sp)
    8000062c:	f0ca                	sd	s2,96(sp)
    8000062e:	ecce                	sd	s3,88(sp)
    80000630:	e4d6                	sd	s5,72(sp)
    80000632:	e0da                	sd	s6,64(sp)
    80000634:	fc5e                	sd	s7,56(sp)
    80000636:	f862                	sd	s8,48(sp)
    80000638:	f466                	sd	s9,40(sp)
    8000063a:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    8000063c:	00009517          	auipc	a0,0x9
    80000640:	9e450513          	addi	a0,a0,-1564 # 80009020 <etext+0x20>
    80000644:	00000097          	auipc	ra,0x0
    80000648:	f1a080e7          	jalr	-230(ra) # 8000055e <panic>
      consputc(c);
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	c52080e7          	jalr	-942(ra) # 8000029e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000654:	0019879b          	addiw	a5,s3,1
    80000658:	89be                	mv	s3,a5
    8000065a:	97d2                	add	a5,a5,s4
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c2>
    if(c != '%'){
    80000664:	ff6514e3          	bne	a0,s6,8000064c <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	0019879b          	addiw	a5,s3,1
    8000066c:	89be                	mv	s3,a5
    8000066e:	97d2                	add	a5,a5,s4
    80000670:	0007c783          	lbu	a5,0(a5)
    80000674:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000678:	10078a63          	beqz	a5,8000078c <printf+0x1e4>
    switch(c){
    8000067c:	05778a63          	beq	a5,s7,800006d0 <printf+0x128>
    80000680:	02fbf463          	bgeu	s7,a5,800006a8 <printf+0x100>
    80000684:	09878763          	beq	a5,s8,80000712 <printf+0x16a>
    80000688:	0d979663          	bne	a5,s9,80000754 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4605                	li	a2,1
    8000069a:	85ea                	mv	a1,s10
    8000069c:	4388                	lw	a0,0(a5)
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	e22080e7          	jalr	-478(ra) # 800004c0 <printint>
      break;
    800006a6:	b77d                	j	80000654 <printf+0xac>
    switch(c){
    800006a8:	0b678063          	beq	a5,s6,80000748 <printf+0x1a0>
    800006ac:	06400713          	li	a4,100
    800006b0:	0ae79263          	bne	a5,a4,80000754 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    800006b4:	f8843783          	ld	a5,-120(s0)
    800006b8:	00878713          	addi	a4,a5,8
    800006bc:	f8e43423          	sd	a4,-120(s0)
    800006c0:	4605                	li	a2,1
    800006c2:	45a9                	li	a1,10
    800006c4:	4388                	lw	a0,0(a5)
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	dfa080e7          	jalr	-518(ra) # 800004c0 <printint>
      break;
    800006ce:	b759                	j	80000654 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006d0:	f8843783          	ld	a5,-120(s0)
    800006d4:	00878713          	addi	a4,a5,8
    800006d8:	f8e43423          	sd	a4,-120(s0)
    800006dc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006e0:	03000513          	li	a0,48
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	bba080e7          	jalr	-1094(ra) # 8000029e <consputc>
  consputc('x');
    800006ec:	8566                	mv	a0,s9
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	bb0080e7          	jalr	-1104(ra) # 8000029e <consputc>
    800006f6:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b9c080e7          	jalr	-1124(ra) # 8000029e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x150>
    80000710:	b791                	j	80000654 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x192>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d51d                	beqz	a0,80000654 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b76080e7          	jalr	-1162(ra) # 8000029e <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x180>
    80000738:	bf31                	j	80000654 <printf+0xac>
        s = "(null)";
    8000073a:	00009497          	auipc	s1,0x9
    8000073e:	8de48493          	addi	s1,s1,-1826 # 80009018 <etext+0x18>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x180>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b54080e7          	jalr	-1196(ra) # 8000029e <consputc>
      break;
    80000752:	b709                	j	80000654 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b48080e7          	jalr	-1208(ra) # 8000029e <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b3e080e7          	jalr	-1218(ra) # 8000029e <consputc>
      break;
    80000768:	b5f5                	j	80000654 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	7d02                	ld	s10,32(sp)
  if(locking)
    8000077c:	020d9263          	bnez	s11,800007a0 <printf+0x1f8>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6de2                	ld	s11,24(sp)
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
    8000079c:	7d02                	ld	s10,32(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d4>
    release(&pr.lock);
    800007a0:	00014517          	auipc	a0,0x14
    800007a4:	43850513          	addi	a0,a0,1080 # 80014bd8 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	63c080e7          	jalr	1596(ra) # 80000de4 <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d8>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1141                	addi	sp,sp,-16
    800007b4:	e406                	sd	ra,8(sp)
    800007b6:	e022                	sd	s0,0(sp)
    800007b8:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    800007ba:	00009597          	auipc	a1,0x9
    800007be:	87658593          	addi	a1,a1,-1930 # 80009030 <etext+0x30>
    800007c2:	00014517          	auipc	a0,0x14
    800007c6:	41650513          	addi	a0,a0,1046 # 80014bd8 <pr>
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	4d0080e7          	jalr	1232(ra) # 80000c9a <initlock>
  pr.locking = 1;
    800007d2:	4785                	li	a5,1
    800007d4:	00014717          	auipc	a4,0x14
    800007d8:	40f72e23          	sw	a5,1052(a4) # 80014bf0 <pr+0x18>
}
    800007dc:	60a2                	ld	ra,8(sp)
    800007de:	6402                	ld	s0,0(sp)
    800007e0:	0141                	addi	sp,sp,16
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
    80000812:	8732                	mv	a4,a2
    80000814:	461d                	li	a2,7
    80000816:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081a:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000081e:	00009597          	auipc	a1,0x9
    80000822:	81a58593          	addi	a1,a1,-2022 # 80009038 <etext+0x38>
    80000826:	00014517          	auipc	a0,0x14
    8000082a:	3d250513          	addi	a0,a0,978 # 80014bf8 <uart_tx_lock>
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	46c080e7          	jalr	1132(ra) # 80000c9a <initlock>
}
    80000836:	60a2                	ld	ra,8(sp)
    80000838:	6402                	ld	s0,0(sp)
    8000083a:	0141                	addi	sp,sp,16
    8000083c:	8082                	ret

000000008000083e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000083e:	1101                	addi	sp,sp,-32
    80000840:	ec06                	sd	ra,24(sp)
    80000842:	e822                	sd	s0,16(sp)
    80000844:	e426                	sd	s1,8(sp)
    80000846:	1000                	addi	s0,sp,32
    80000848:	84aa                	mv	s1,a0
  push_off();
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	49a080e7          	jalr	1178(ra) # 80000ce4 <push_off>

  if(panicked){
    80000852:	0000c797          	auipc	a5,0xc
    80000856:	15e7a783          	lw	a5,350(a5) # 8000c9b0 <panicked>
    8000085a:	eb85                	bnez	a5,8000088a <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085c:	10000737          	lui	a4,0x10000
    80000860:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000862:	00074783          	lbu	a5,0(a4)
    80000866:	0207f793          	andi	a5,a5,32
    8000086a:	dfe5                	beqz	a5,80000862 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086c:	0ff4f513          	zext.b	a0,s1
    80000870:	100007b7          	lui	a5,0x10000
    80000874:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	510080e7          	jalr	1296(ra) # 80000d88 <pop_off>
}
    80000880:	60e2                	ld	ra,24(sp)
    80000882:	6442                	ld	s0,16(sp)
    80000884:	64a2                	ld	s1,8(sp)
    80000886:	6105                	addi	sp,sp,32
    80000888:	8082                	ret
    for(;;)
    8000088a:	a001                	j	8000088a <uartputc_sync+0x4c>

000000008000088c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088c:	0000c797          	auipc	a5,0xc
    80000890:	12c7b783          	ld	a5,300(a5) # 8000c9b8 <uart_tx_r>
    80000894:	0000c717          	auipc	a4,0xc
    80000898:	12c73703          	ld	a4,300(a4) # 8000c9c0 <uart_tx_w>
    8000089c:	06f70f63          	beq	a4,a5,8000091a <uartstart+0x8e>
{
    800008a0:	7139                	addi	sp,sp,-64
    800008a2:	fc06                	sd	ra,56(sp)
    800008a4:	f822                	sd	s0,48(sp)
    800008a6:	f426                	sd	s1,40(sp)
    800008a8:	f04a                	sd	s2,32(sp)
    800008aa:	ec4e                	sd	s3,24(sp)
    800008ac:	e852                	sd	s4,16(sp)
    800008ae:	e456                	sd	s5,8(sp)
    800008b0:	e05a                	sd	s6,0(sp)
    800008b2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b4:	10000937          	lui	s2,0x10000
    800008b8:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ba:	00014a97          	auipc	s5,0x14
    800008be:	33ea8a93          	addi	s5,s5,830 # 80014bf8 <uart_tx_lock>
    uart_tx_r += 1;
    800008c2:	0000c497          	auipc	s1,0xc
    800008c6:	0f648493          	addi	s1,s1,246 # 8000c9b8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008ca:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ce:	0000c997          	auipc	s3,0xc
    800008d2:	0f298993          	addi	s3,s3,242 # 8000c9c0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d6:	00094703          	lbu	a4,0(s2)
    800008da:	02077713          	andi	a4,a4,32
    800008de:	c705                	beqz	a4,80000906 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e0:	01f7f713          	andi	a4,a5,31
    800008e4:	9756                	add	a4,a4,s5
    800008e6:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ea:	0785                	addi	a5,a5,1
    800008ec:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008ee:	8526                	mv	a0,s1
    800008f0:	00002097          	auipc	ra,0x2
    800008f4:	f5e080e7          	jalr	-162(ra) # 8000284e <wakeup>
    WriteReg(THR, c);
    800008f8:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fc:	609c                	ld	a5,0(s1)
    800008fe:	0009b703          	ld	a4,0(s3)
    80000902:	fcf71ae3          	bne	a4,a5,800008d6 <uartstart+0x4a>
  }
}
    80000906:	70e2                	ld	ra,56(sp)
    80000908:	7442                	ld	s0,48(sp)
    8000090a:	74a2                	ld	s1,40(sp)
    8000090c:	7902                	ld	s2,32(sp)
    8000090e:	69e2                	ld	s3,24(sp)
    80000910:	6a42                	ld	s4,16(sp)
    80000912:	6aa2                	ld	s5,8(sp)
    80000914:	6b02                	ld	s6,0(sp)
    80000916:	6121                	addi	sp,sp,64
    80000918:	8082                	ret
    8000091a:	8082                	ret

000000008000091c <uartputc>:
{
    8000091c:	7179                	addi	sp,sp,-48
    8000091e:	f406                	sd	ra,40(sp)
    80000920:	f022                	sd	s0,32(sp)
    80000922:	ec26                	sd	s1,24(sp)
    80000924:	e84a                	sd	s2,16(sp)
    80000926:	e44e                	sd	s3,8(sp)
    80000928:	e052                	sd	s4,0(sp)
    8000092a:	1800                	addi	s0,sp,48
    8000092c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000092e:	00014517          	auipc	a0,0x14
    80000932:	2ca50513          	addi	a0,a0,714 # 80014bf8 <uart_tx_lock>
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	3fe080e7          	jalr	1022(ra) # 80000d34 <acquire>
  if(panicked){
    8000093e:	0000c797          	auipc	a5,0xc
    80000942:	0727a783          	lw	a5,114(a5) # 8000c9b0 <panicked>
    80000946:	ebc1                	bnez	a5,800009d6 <uartputc+0xba>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000948:	0000c717          	auipc	a4,0xc
    8000094c:	07873703          	ld	a4,120(a4) # 8000c9c0 <uart_tx_w>
    80000950:	0000c797          	auipc	a5,0xc
    80000954:	0687b783          	ld	a5,104(a5) # 8000c9b8 <uart_tx_r>
    80000958:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095c:	00014997          	auipc	s3,0x14
    80000960:	29c98993          	addi	s3,s3,668 # 80014bf8 <uart_tx_lock>
    80000964:	0000c497          	auipc	s1,0xc
    80000968:	05448493          	addi	s1,s1,84 # 8000c9b8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096c:	0000c917          	auipc	s2,0xc
    80000970:	05490913          	addi	s2,s2,84 # 8000c9c0 <uart_tx_w>
    80000974:	00e79f63          	bne	a5,a4,80000992 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000978:	85ce                	mv	a1,s3
    8000097a:	8526                	mv	a0,s1
    8000097c:	00002097          	auipc	ra,0x2
    80000980:	e6e080e7          	jalr	-402(ra) # 800027ea <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000984:	00093703          	ld	a4,0(s2)
    80000988:	609c                	ld	a5,0(s1)
    8000098a:	02078793          	addi	a5,a5,32
    8000098e:	fee785e3          	beq	a5,a4,80000978 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000992:	01f77693          	andi	a3,a4,31
    80000996:	00014797          	auipc	a5,0x14
    8000099a:	26278793          	addi	a5,a5,610 # 80014bf8 <uart_tx_lock>
    8000099e:	97b6                	add	a5,a5,a3
    800009a0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a4:	0705                	addi	a4,a4,1
    800009a6:	0000c797          	auipc	a5,0xc
    800009aa:	00e7bd23          	sd	a4,26(a5) # 8000c9c0 <uart_tx_w>
  uartstart();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	ede080e7          	jalr	-290(ra) # 8000088c <uartstart>
  release(&uart_tx_lock);
    800009b6:	00014517          	auipc	a0,0x14
    800009ba:	24250513          	addi	a0,a0,578 # 80014bf8 <uart_tx_lock>
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	426080e7          	jalr	1062(ra) # 80000de4 <release>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret
    for(;;)
    800009d6:	a001                	j	800009d6 <uartputc+0xba>

00000000800009d8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d8:	1141                	addi	sp,sp,-16
    800009da:	e406                	sd	ra,8(sp)
    800009dc:	e022                	sd	s0,0(sp)
    800009de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e0:	100007b7          	lui	a5,0x10000
    800009e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009e8:	8b85                	andi	a5,a5,1
    800009ea:	cb89                	beqz	a5,800009fc <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009ec:	100007b7          	lui	a5,0x10000
    800009f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f4:	60a2                	ld	ra,8(sp)
    800009f6:	6402                	ld	s0,0(sp)
    800009f8:	0141                	addi	sp,sp,16
    800009fa:	8082                	ret
    return -1;
    800009fc:	557d                	li	a0,-1
    800009fe:	bfdd                	j	800009f4 <uartgetc+0x1c>

0000000080000a00 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a00:	1101                	addi	sp,sp,-32
    80000a02:	ec06                	sd	ra,24(sp)
    80000a04:	e822                	sd	s0,16(sp)
    80000a06:	e426                	sd	s1,8(sp)
    80000a08:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a0a:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a0c:	00000097          	auipc	ra,0x0
    80000a10:	fcc080e7          	jalr	-52(ra) # 800009d8 <uartgetc>
    if(c == -1)
    80000a14:	00950763          	beq	a0,s1,80000a22 <uartintr+0x22>
      break;
    consoleintr(c);
    80000a18:	00000097          	auipc	ra,0x0
    80000a1c:	8c8080e7          	jalr	-1848(ra) # 800002e0 <consoleintr>
  while(1){
    80000a20:	b7f5                	j	80000a0c <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a22:	00014517          	auipc	a0,0x14
    80000a26:	1d650513          	addi	a0,a0,470 # 80014bf8 <uart_tx_lock>
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	30a080e7          	jalr	778(ra) # 80000d34 <acquire>
  uartstart();
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	e5a080e7          	jalr	-422(ra) # 8000088c <uartstart>
  release(&uart_tx_lock);
    80000a3a:	00014517          	auipc	a0,0x14
    80000a3e:	1be50513          	addi	a0,a0,446 # 80014bf8 <uart_tx_lock>
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	3a2080e7          	jalr	930(ra) # 80000de4 <release>
}
    80000a4a:	60e2                	ld	ra,24(sp)
    80000a4c:	6442                	ld	s0,16(sp)
    80000a4e:	64a2                	ld	s1,8(sp)
    80000a50:	6105                	addi	sp,sp,32
    80000a52:	8082                	ret

0000000080000a54 <add_page_reference>:
struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void add_page_reference(uint64 pointer_in_page){
    80000a54:	1101                	addi	sp,sp,-32
    80000a56:	ec06                	sd	ra,24(sp)
    80000a58:	e822                	sd	s0,16(sp)
    80000a5a:	e426                	sd	s1,8(sp)
    80000a5c:	1000                	addi	s0,sp,32
    80000a5e:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    80000a60:	00014517          	auipc	a0,0x14
    80000a64:	1d050513          	addi	a0,a0,464 # 80014c30 <kmem>
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	2cc080e7          	jalr	716(ra) # 80000d34 <acquire>
  uint page_num = PGROUNDDOWN((uint64)pointer_in_page)/PGSIZE;
  ref_counter[page_num]++;
    80000a70:	01449793          	slli	a5,s1,0x14
    80000a74:	0207d513          	srli	a0,a5,0x20
    80000a78:	050e                	slli	a0,a0,0x3
    80000a7a:	00014797          	auipc	a5,0x14
    80000a7e:	1d678793          	addi	a5,a5,470 # 80014c50 <ref_counter>
    80000a82:	97aa                	add	a5,a5,a0
    80000a84:	6398                	ld	a4,0(a5)
    80000a86:	0705                	addi	a4,a4,1
    80000a88:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000a8a:	00014517          	auipc	a0,0x14
    80000a8e:	1a650513          	addi	a0,a0,422 # 80014c30 <kmem>
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	352080e7          	jalr	850(ra) # 80000de4 <release>
}
    80000a9a:	60e2                	ld	ra,24(sp)
    80000a9c:	6442                	ld	s0,16(sp)
    80000a9e:	64a2                	ld	s1,8(sp)
    80000aa0:	6105                	addi	sp,sp,32
    80000aa2:	8082                	ret

0000000080000aa4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000aa4:	1101                	addi	sp,sp,-32
    80000aa6:	ec06                	sd	ra,24(sp)
    80000aa8:	e822                	sd	s0,16(sp)
    80000aaa:	e426                	sd	s1,8(sp)
    80000aac:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000aae:	0006d797          	auipc	a5,0x6d
    80000ab2:	62a78793          	addi	a5,a5,1578 # 8006e0d8 <end>
    80000ab6:	00f53733          	sltu	a4,a0,a5
    80000aba:	47c5                	li	a5,17
    80000abc:	07ee                	slli	a5,a5,0x1b
    80000abe:	17fd                	addi	a5,a5,-1
    80000ac0:	00a7b7b3          	sltu	a5,a5,a0
    80000ac4:	8fd9                	or	a5,a5,a4
    80000ac6:	ebc1                	bnez	a5,80000b56 <kfree+0xb2>
    80000ac8:	84aa                	mv	s1,a0
    80000aca:	03451793          	slli	a5,a0,0x34
    80000ace:	e7c1                	bnez	a5,80000b56 <kfree+0xb2>
    panic("kfree");

  acquire(&kmem.lock);
    80000ad0:	00014517          	auipc	a0,0x14
    80000ad4:	16050513          	addi	a0,a0,352 # 80014c30 <kmem>
    80000ad8:	00000097          	auipc	ra,0x0
    80000adc:	25c080e7          	jalr	604(ra) # 80000d34 <acquire>
  uint64 page_num = PGROUNDDOWN((uint64)pa)/PGSIZE;
    80000ae0:	00c4d793          	srli	a5,s1,0xc
  if (ref_counter[page_num] > 1) {
    80000ae4:	00379693          	slli	a3,a5,0x3
    80000ae8:	00014717          	auipc	a4,0x14
    80000aec:	16870713          	addi	a4,a4,360 # 80014c50 <ref_counter>
    80000af0:	9736                	add	a4,a4,a3
    80000af2:	6318                	ld	a4,0(a4)
    80000af4:	4685                	li	a3,1
    80000af6:	06e6e963          	bltu	a3,a4,80000b68 <kfree+0xc4>
    80000afa:	e04a                	sd	s2,0(sp)
    ref_counter[page_num]--;
    release(&kmem.lock);
    return;
  }
  ref_counter[page_num] = 0; // insurance
    80000afc:	078e                	slli	a5,a5,0x3
    80000afe:	00014717          	auipc	a4,0x14
    80000b02:	15270713          	addi	a4,a4,338 # 80014c50 <ref_counter>
    80000b06:	97ba                	add	a5,a5,a4
    80000b08:	0007b023          	sd	zero,0(a5)
  release(&kmem.lock);
    80000b0c:	00014917          	auipc	s2,0x14
    80000b10:	12490913          	addi	s2,s2,292 # 80014c30 <kmem>
    80000b14:	854a                	mv	a0,s2
    80000b16:	00000097          	auipc	ra,0x0
    80000b1a:	2ce080e7          	jalr	718(ra) # 80000de4 <release>

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000b1e:	6605                	lui	a2,0x1
    80000b20:	4585                	li	a1,1
    80000b22:	8526                	mv	a0,s1
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	308080e7          	jalr	776(ra) # 80000e2c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000b2c:	854a                	mv	a0,s2
    80000b2e:	00000097          	auipc	ra,0x0
    80000b32:	206080e7          	jalr	518(ra) # 80000d34 <acquire>
  r->next = kmem.freelist;
    80000b36:	01893783          	ld	a5,24(s2)
    80000b3a:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000b3c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000b40:	854a                	mv	a0,s2
    80000b42:	00000097          	auipc	ra,0x0
    80000b46:	2a2080e7          	jalr	674(ra) # 80000de4 <release>
    80000b4a:	6902                	ld	s2,0(sp)
}
    80000b4c:	60e2                	ld	ra,24(sp)
    80000b4e:	6442                	ld	s0,16(sp)
    80000b50:	64a2                	ld	s1,8(sp)
    80000b52:	6105                	addi	sp,sp,32
    80000b54:	8082                	ret
    80000b56:	e04a                	sd	s2,0(sp)
    panic("kfree");
    80000b58:	00008517          	auipc	a0,0x8
    80000b5c:	4e850513          	addi	a0,a0,1256 # 80009040 <etext+0x40>
    80000b60:	00000097          	auipc	ra,0x0
    80000b64:	9fe080e7          	jalr	-1538(ra) # 8000055e <panic>
    ref_counter[page_num]--;
    80000b68:	078e                	slli	a5,a5,0x3
    80000b6a:	00014697          	auipc	a3,0x14
    80000b6e:	0e668693          	addi	a3,a3,230 # 80014c50 <ref_counter>
    80000b72:	97b6                	add	a5,a5,a3
    80000b74:	177d                	addi	a4,a4,-1
    80000b76:	e398                	sd	a4,0(a5)
    release(&kmem.lock);
    80000b78:	00014517          	auipc	a0,0x14
    80000b7c:	0b850513          	addi	a0,a0,184 # 80014c30 <kmem>
    80000b80:	00000097          	auipc	ra,0x0
    80000b84:	264080e7          	jalr	612(ra) # 80000de4 <release>
    return;
    80000b88:	b7d1                	j	80000b4c <kfree+0xa8>

0000000080000b8a <freerange>:
{
    80000b8a:	7179                	addi	sp,sp,-48
    80000b8c:	f406                	sd	ra,40(sp)
    80000b8e:	f022                	sd	s0,32(sp)
    80000b90:	ec26                	sd	s1,24(sp)
    80000b92:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b94:	6785                	lui	a5,0x1
    80000b96:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b9a:	00e504b3          	add	s1,a0,a4
    80000b9e:	777d                	lui	a4,0xfffff
    80000ba0:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ba2:	94be                	add	s1,s1,a5
    80000ba4:	0295e463          	bltu	a1,s1,80000bcc <freerange+0x42>
    80000ba8:	e84a                	sd	s2,16(sp)
    80000baa:	e44e                	sd	s3,8(sp)
    80000bac:	e052                	sd	s4,0(sp)
    80000bae:	892e                	mv	s2,a1
    kfree(p);
    80000bb0:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000bb2:	89be                	mv	s3,a5
    kfree(p);
    80000bb4:	01448533          	add	a0,s1,s4
    80000bb8:	00000097          	auipc	ra,0x0
    80000bbc:	eec080e7          	jalr	-276(ra) # 80000aa4 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000bc0:	94ce                	add	s1,s1,s3
    80000bc2:	fe9979e3          	bgeu	s2,s1,80000bb4 <freerange+0x2a>
    80000bc6:	6942                	ld	s2,16(sp)
    80000bc8:	69a2                	ld	s3,8(sp)
    80000bca:	6a02                	ld	s4,0(sp)
}
    80000bcc:	70a2                	ld	ra,40(sp)
    80000bce:	7402                	ld	s0,32(sp)
    80000bd0:	64e2                	ld	s1,24(sp)
    80000bd2:	6145                	addi	sp,sp,48
    80000bd4:	8082                	ret

0000000080000bd6 <kinit>:
{
    80000bd6:	1141                	addi	sp,sp,-16
    80000bd8:	e406                	sd	ra,8(sp)
    80000bda:	e022                	sd	s0,0(sp)
    80000bdc:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000bde:	00008597          	auipc	a1,0x8
    80000be2:	46a58593          	addi	a1,a1,1130 # 80009048 <etext+0x48>
    80000be6:	00014517          	auipc	a0,0x14
    80000bea:	04a50513          	addi	a0,a0,74 # 80014c30 <kmem>
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	0ac080e7          	jalr	172(ra) # 80000c9a <initlock>
  freerange(end, (void*)PHYSTOP);
    80000bf6:	45c5                	li	a1,17
    80000bf8:	05ee                	slli	a1,a1,0x1b
    80000bfa:	0006d517          	auipc	a0,0x6d
    80000bfe:	4de50513          	addi	a0,a0,1246 # 8006e0d8 <end>
    80000c02:	00000097          	auipc	ra,0x0
    80000c06:	f88080e7          	jalr	-120(ra) # 80000b8a <freerange>
}
    80000c0a:	60a2                	ld	ra,8(sp)
    80000c0c:	6402                	ld	s0,0(sp)
    80000c0e:	0141                	addi	sp,sp,16
    80000c10:	8082                	ret

0000000080000c12 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000c12:	1101                	addi	sp,sp,-32
    80000c14:	ec06                	sd	ra,24(sp)
    80000c16:	e822                	sd	s0,16(sp)
    80000c18:	e426                	sd	s1,8(sp)
    80000c1a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000c1c:	00014517          	auipc	a0,0x14
    80000c20:	01450513          	addi	a0,a0,20 # 80014c30 <kmem>
    80000c24:	00000097          	auipc	ra,0x0
    80000c28:	110080e7          	jalr	272(ra) # 80000d34 <acquire>

  r = kmem.freelist;
    80000c2c:	00014497          	auipc	s1,0x14
    80000c30:	01c4b483          	ld	s1,28(s1) # 80014c48 <kmem+0x18>
  if(r)
    80000c34:	c4a9                	beqz	s1,80000c7e <kalloc+0x6c>
    kmem.freelist = r->next;
    80000c36:	609c                	ld	a5,0(s1)
    80000c38:	00014717          	auipc	a4,0x14
    80000c3c:	00f73823          	sd	a5,16(a4) # 80014c48 <kmem+0x18>
  uint64 page_num = PGROUNDDOWN((uint64)r)/PGSIZE;
    80000c40:	00c4d713          	srli	a4,s1,0xc
  ref_counter[page_num] = 1;
    80000c44:	070e                	slli	a4,a4,0x3
    80000c46:	00014797          	auipc	a5,0x14
    80000c4a:	00a78793          	addi	a5,a5,10 # 80014c50 <ref_counter>
    80000c4e:	97ba                	add	a5,a5,a4
    80000c50:	4705                	li	a4,1
    80000c52:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000c54:	00014517          	auipc	a0,0x14
    80000c58:	fdc50513          	addi	a0,a0,-36 # 80014c30 <kmem>
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	188080e7          	jalr	392(ra) # 80000de4 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000c64:	6605                	lui	a2,0x1
    80000c66:	4595                	li	a1,5
    80000c68:	8526                	mv	a0,s1
    80000c6a:	00000097          	auipc	ra,0x0
    80000c6e:	1c2080e7          	jalr	450(ra) # 80000e2c <memset>
  return (void*)r;
}
    80000c72:	8526                	mv	a0,s1
    80000c74:	60e2                	ld	ra,24(sp)
    80000c76:	6442                	ld	s0,16(sp)
    80000c78:	64a2                	ld	s1,8(sp)
    80000c7a:	6105                	addi	sp,sp,32
    80000c7c:	8082                	ret
  ref_counter[page_num] = 1;
    80000c7e:	4785                	li	a5,1
    80000c80:	00014717          	auipc	a4,0x14
    80000c84:	fcf73823          	sd	a5,-48(a4) # 80014c50 <ref_counter>
  release(&kmem.lock);
    80000c88:	00014517          	auipc	a0,0x14
    80000c8c:	fa850513          	addi	a0,a0,-88 # 80014c30 <kmem>
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	154080e7          	jalr	340(ra) # 80000de4 <release>
  if(r)
    80000c98:	bfe9                	j	80000c72 <kalloc+0x60>

0000000080000c9a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c9a:	1141                	addi	sp,sp,-16
    80000c9c:	e406                	sd	ra,8(sp)
    80000c9e:	e022                	sd	s0,0(sp)
    80000ca0:	0800                	addi	s0,sp,16
  lk->name = name;
    80000ca2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000ca4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000ca8:	00053823          	sd	zero,16(a0)
}
    80000cac:	60a2                	ld	ra,8(sp)
    80000cae:	6402                	ld	s0,0(sp)
    80000cb0:	0141                	addi	sp,sp,16
    80000cb2:	8082                	ret

0000000080000cb4 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000cb4:	411c                	lw	a5,0(a0)
    80000cb6:	e399                	bnez	a5,80000cbc <holding+0x8>
    80000cb8:	4501                	li	a0,0
  return r;
}
    80000cba:	8082                	ret
{
    80000cbc:	1101                	addi	sp,sp,-32
    80000cbe:	ec06                	sd	ra,24(sp)
    80000cc0:	e822                	sd	s0,16(sp)
    80000cc2:	e426                	sd	s1,8(sp)
    80000cc4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000cc6:	691c                	ld	a5,16(a0)
    80000cc8:	84be                	mv	s1,a5
    80000cca:	00001097          	auipc	ra,0x1
    80000cce:	24a080e7          	jalr	586(ra) # 80001f14 <mycpu>
    80000cd2:	40a48533          	sub	a0,s1,a0
    80000cd6:	00153513          	seqz	a0,a0
}
    80000cda:	60e2                	ld	ra,24(sp)
    80000cdc:	6442                	ld	s0,16(sp)
    80000cde:	64a2                	ld	s1,8(sp)
    80000ce0:	6105                	addi	sp,sp,32
    80000ce2:	8082                	ret

0000000080000ce4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000ce4:	1101                	addi	sp,sp,-32
    80000ce6:	ec06                	sd	ra,24(sp)
    80000ce8:	e822                	sd	s0,16(sp)
    80000cea:	e426                	sd	s1,8(sp)
    80000cec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cee:	100027f3          	csrr	a5,sstatus
    80000cf2:	84be                	mv	s1,a5
    80000cf4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000cf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cfa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000cfe:	00001097          	auipc	ra,0x1
    80000d02:	216080e7          	jalr	534(ra) # 80001f14 <mycpu>
    80000d06:	5d3c                	lw	a5,120(a0)
    80000d08:	cf89                	beqz	a5,80000d22 <push_off+0x3e>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d0a:	00001097          	auipc	ra,0x1
    80000d0e:	20a080e7          	jalr	522(ra) # 80001f14 <mycpu>
    80000d12:	5d3c                	lw	a5,120(a0)
    80000d14:	2785                	addiw	a5,a5,1
    80000d16:	dd3c                	sw	a5,120(a0)
}
    80000d18:	60e2                	ld	ra,24(sp)
    80000d1a:	6442                	ld	s0,16(sp)
    80000d1c:	64a2                	ld	s1,8(sp)
    80000d1e:	6105                	addi	sp,sp,32
    80000d20:	8082                	ret
    mycpu()->intena = old;
    80000d22:	00001097          	auipc	ra,0x1
    80000d26:	1f2080e7          	jalr	498(ra) # 80001f14 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000d2a:	0014d793          	srli	a5,s1,0x1
    80000d2e:	8b85                	andi	a5,a5,1
    80000d30:	dd7c                	sw	a5,124(a0)
    80000d32:	bfe1                	j	80000d0a <push_off+0x26>

0000000080000d34 <acquire>:
{
    80000d34:	1101                	addi	sp,sp,-32
    80000d36:	ec06                	sd	ra,24(sp)
    80000d38:	e822                	sd	s0,16(sp)
    80000d3a:	e426                	sd	s1,8(sp)
    80000d3c:	1000                	addi	s0,sp,32
    80000d3e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d40:	00000097          	auipc	ra,0x0
    80000d44:	fa4080e7          	jalr	-92(ra) # 80000ce4 <push_off>
  if(holding(lk))
    80000d48:	8526                	mv	a0,s1
    80000d4a:	00000097          	auipc	ra,0x0
    80000d4e:	f6a080e7          	jalr	-150(ra) # 80000cb4 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d52:	4705                	li	a4,1
  if(holding(lk))
    80000d54:	e115                	bnez	a0,80000d78 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d56:	87ba                	mv	a5,a4
    80000d58:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d5c:	2781                	sext.w	a5,a5
    80000d5e:	ffe5                	bnez	a5,80000d56 <acquire+0x22>
  __sync_synchronize();
    80000d60:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000d64:	00001097          	auipc	ra,0x1
    80000d68:	1b0080e7          	jalr	432(ra) # 80001f14 <mycpu>
    80000d6c:	e888                	sd	a0,16(s1)
}
    80000d6e:	60e2                	ld	ra,24(sp)
    80000d70:	6442                	ld	s0,16(sp)
    80000d72:	64a2                	ld	s1,8(sp)
    80000d74:	6105                	addi	sp,sp,32
    80000d76:	8082                	ret
    panic("acquire");
    80000d78:	00008517          	auipc	a0,0x8
    80000d7c:	2d850513          	addi	a0,a0,728 # 80009050 <etext+0x50>
    80000d80:	fffff097          	auipc	ra,0xfffff
    80000d84:	7de080e7          	jalr	2014(ra) # 8000055e <panic>

0000000080000d88 <pop_off>:

void
pop_off(void)
{
    80000d88:	1141                	addi	sp,sp,-16
    80000d8a:	e406                	sd	ra,8(sp)
    80000d8c:	e022                	sd	s0,0(sp)
    80000d8e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d90:	00001097          	auipc	ra,0x1
    80000d94:	184080e7          	jalr	388(ra) # 80001f14 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d98:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d9c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d9e:	e39d                	bnez	a5,80000dc4 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000da0:	5d3c                	lw	a5,120(a0)
    80000da2:	02f05963          	blez	a5,80000dd4 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000da6:	37fd                	addiw	a5,a5,-1
    80000da8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000daa:	eb89                	bnez	a5,80000dbc <pop_off+0x34>
    80000dac:	5d7c                	lw	a5,124(a0)
    80000dae:	c799                	beqz	a5,80000dbc <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000db0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000db4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000db8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000dbc:	60a2                	ld	ra,8(sp)
    80000dbe:	6402                	ld	s0,0(sp)
    80000dc0:	0141                	addi	sp,sp,16
    80000dc2:	8082                	ret
    panic("pop_off - interruptible");
    80000dc4:	00008517          	auipc	a0,0x8
    80000dc8:	29450513          	addi	a0,a0,660 # 80009058 <etext+0x58>
    80000dcc:	fffff097          	auipc	ra,0xfffff
    80000dd0:	792080e7          	jalr	1938(ra) # 8000055e <panic>
    panic("pop_off");
    80000dd4:	00008517          	auipc	a0,0x8
    80000dd8:	29c50513          	addi	a0,a0,668 # 80009070 <etext+0x70>
    80000ddc:	fffff097          	auipc	ra,0xfffff
    80000de0:	782080e7          	jalr	1922(ra) # 8000055e <panic>

0000000080000de4 <release>:
{
    80000de4:	1101                	addi	sp,sp,-32
    80000de6:	ec06                	sd	ra,24(sp)
    80000de8:	e822                	sd	s0,16(sp)
    80000dea:	e426                	sd	s1,8(sp)
    80000dec:	1000                	addi	s0,sp,32
    80000dee:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000df0:	00000097          	auipc	ra,0x0
    80000df4:	ec4080e7          	jalr	-316(ra) # 80000cb4 <holding>
    80000df8:	c115                	beqz	a0,80000e1c <release+0x38>
  lk->cpu = 0;
    80000dfa:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000dfe:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000e02:	0310000f          	fence	rw,w
    80000e06:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000e0a:	00000097          	auipc	ra,0x0
    80000e0e:	f7e080e7          	jalr	-130(ra) # 80000d88 <pop_off>
}
    80000e12:	60e2                	ld	ra,24(sp)
    80000e14:	6442                	ld	s0,16(sp)
    80000e16:	64a2                	ld	s1,8(sp)
    80000e18:	6105                	addi	sp,sp,32
    80000e1a:	8082                	ret
    panic("release");
    80000e1c:	00008517          	auipc	a0,0x8
    80000e20:	25c50513          	addi	a0,a0,604 # 80009078 <etext+0x78>
    80000e24:	fffff097          	auipc	ra,0xfffff
    80000e28:	73a080e7          	jalr	1850(ra) # 8000055e <panic>

0000000080000e2c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e406                	sd	ra,8(sp)
    80000e30:	e022                	sd	s0,0(sp)
    80000e32:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e34:	ca19                	beqz	a2,80000e4a <memset+0x1e>
    80000e36:	87aa                	mv	a5,a0
    80000e38:	1602                	slli	a2,a2,0x20
    80000e3a:	9201                	srli	a2,a2,0x20
    80000e3c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e40:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e44:	0785                	addi	a5,a5,1
    80000e46:	fee79de3          	bne	a5,a4,80000e40 <memset+0x14>
  }
  return dst;
}
    80000e4a:	60a2                	ld	ra,8(sp)
    80000e4c:	6402                	ld	s0,0(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e52:	1141                	addi	sp,sp,-16
    80000e54:	e406                	sd	ra,8(sp)
    80000e56:	e022                	sd	s0,0(sp)
    80000e58:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e5a:	c61d                	beqz	a2,80000e88 <memcmp+0x36>
    80000e5c:	1602                	slli	a2,a2,0x20
    80000e5e:	9201                	srli	a2,a2,0x20
    80000e60:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000e64:	00054783          	lbu	a5,0(a0)
    80000e68:	0005c703          	lbu	a4,0(a1)
    80000e6c:	00e79863          	bne	a5,a4,80000e7c <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000e70:	0505                	addi	a0,a0,1
    80000e72:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e74:	fed518e3          	bne	a0,a3,80000e64 <memcmp+0x12>
  }

  return 0;
    80000e78:	4501                	li	a0,0
    80000e7a:	a019                	j	80000e80 <memcmp+0x2e>
      return *s1 - *s2;
    80000e7c:	40e7853b          	subw	a0,a5,a4
}
    80000e80:	60a2                	ld	ra,8(sp)
    80000e82:	6402                	ld	s0,0(sp)
    80000e84:	0141                	addi	sp,sp,16
    80000e86:	8082                	ret
  return 0;
    80000e88:	4501                	li	a0,0
    80000e8a:	bfdd                	j	80000e80 <memcmp+0x2e>

0000000080000e8c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e8c:	1141                	addi	sp,sp,-16
    80000e8e:	e406                	sd	ra,8(sp)
    80000e90:	e022                	sd	s0,0(sp)
    80000e92:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e94:	c205                	beqz	a2,80000eb4 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e96:	02a5e363          	bltu	a1,a0,80000ebc <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e9a:	1602                	slli	a2,a2,0x20
    80000e9c:	9201                	srli	a2,a2,0x20
    80000e9e:	00c587b3          	add	a5,a1,a2
{
    80000ea2:	872a                	mv	a4,a0
      *d++ = *s++;
    80000ea4:	0585                	addi	a1,a1,1
    80000ea6:	0705                	addi	a4,a4,1
    80000ea8:	fff5c683          	lbu	a3,-1(a1)
    80000eac:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000eb0:	feb79ae3          	bne	a5,a1,80000ea4 <memmove+0x18>

  return dst;
}
    80000eb4:	60a2                	ld	ra,8(sp)
    80000eb6:	6402                	ld	s0,0(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
  if(s < d && s + n > d){
    80000ebc:	02061693          	slli	a3,a2,0x20
    80000ec0:	9281                	srli	a3,a3,0x20
    80000ec2:	00d58733          	add	a4,a1,a3
    80000ec6:	fce57ae3          	bgeu	a0,a4,80000e9a <memmove+0xe>
    d += n;
    80000eca:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000ecc:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000ed0:	1782                	slli	a5,a5,0x20
    80000ed2:	9381                	srli	a5,a5,0x20
    80000ed4:	fff7c793          	not	a5,a5
    80000ed8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000eda:	177d                	addi	a4,a4,-1
    80000edc:	16fd                	addi	a3,a3,-1
    80000ede:	00074603          	lbu	a2,0(a4)
    80000ee2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000ee6:	fee79ae3          	bne	a5,a4,80000eda <memmove+0x4e>
    80000eea:	b7e9                	j	80000eb4 <memmove+0x28>

0000000080000eec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000eec:	1141                	addi	sp,sp,-16
    80000eee:	e406                	sd	ra,8(sp)
    80000ef0:	e022                	sd	s0,0(sp)
    80000ef2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000ef4:	00000097          	auipc	ra,0x0
    80000ef8:	f98080e7          	jalr	-104(ra) # 80000e8c <memmove>
}
    80000efc:	60a2                	ld	ra,8(sp)
    80000efe:	6402                	ld	s0,0(sp)
    80000f00:	0141                	addi	sp,sp,16
    80000f02:	8082                	ret

0000000080000f04 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000f04:	1141                	addi	sp,sp,-16
    80000f06:	e406                	sd	ra,8(sp)
    80000f08:	e022                	sd	s0,0(sp)
    80000f0a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000f0c:	ce11                	beqz	a2,80000f28 <strncmp+0x24>
    80000f0e:	00054783          	lbu	a5,0(a0)
    80000f12:	cf89                	beqz	a5,80000f2c <strncmp+0x28>
    80000f14:	0005c703          	lbu	a4,0(a1)
    80000f18:	00f71a63          	bne	a4,a5,80000f2c <strncmp+0x28>
    n--, p++, q++;
    80000f1c:	367d                	addiw	a2,a2,-1
    80000f1e:	0505                	addi	a0,a0,1
    80000f20:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000f22:	f675                	bnez	a2,80000f0e <strncmp+0xa>
  if(n == 0)
    return 0;
    80000f24:	4501                	li	a0,0
    80000f26:	a801                	j	80000f36 <strncmp+0x32>
    80000f28:	4501                	li	a0,0
    80000f2a:	a031                	j	80000f36 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000f2c:	00054503          	lbu	a0,0(a0)
    80000f30:	0005c783          	lbu	a5,0(a1)
    80000f34:	9d1d                	subw	a0,a0,a5
}
    80000f36:	60a2                	ld	ra,8(sp)
    80000f38:	6402                	ld	s0,0(sp)
    80000f3a:	0141                	addi	sp,sp,16
    80000f3c:	8082                	ret

0000000080000f3e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f3e:	1141                	addi	sp,sp,-16
    80000f40:	e406                	sd	ra,8(sp)
    80000f42:	e022                	sd	s0,0(sp)
    80000f44:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f46:	87aa                	mv	a5,a0
    80000f48:	a011                	j	80000f4c <strncpy+0xe>
    80000f4a:	8636                	mv	a2,a3
    80000f4c:	02c05863          	blez	a2,80000f7c <strncpy+0x3e>
    80000f50:	fff6069b          	addiw	a3,a2,-1
    80000f54:	8836                	mv	a6,a3
    80000f56:	0785                	addi	a5,a5,1
    80000f58:	0005c703          	lbu	a4,0(a1)
    80000f5c:	fee78fa3          	sb	a4,-1(a5)
    80000f60:	0585                	addi	a1,a1,1
    80000f62:	f765                	bnez	a4,80000f4a <strncpy+0xc>
    ;
  while(n-- > 0)
    80000f64:	873e                	mv	a4,a5
    80000f66:	01005b63          	blez	a6,80000f7c <strncpy+0x3e>
    80000f6a:	9fb1                	addw	a5,a5,a2
    80000f6c:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000f6e:	0705                	addi	a4,a4,1
    80000f70:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000f74:	40e786bb          	subw	a3,a5,a4
    80000f78:	fed04be3          	bgtz	a3,80000f6e <strncpy+0x30>
  return os;
}
    80000f7c:	60a2                	ld	ra,8(sp)
    80000f7e:	6402                	ld	s0,0(sp)
    80000f80:	0141                	addi	sp,sp,16
    80000f82:	8082                	ret

0000000080000f84 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f84:	1141                	addi	sp,sp,-16
    80000f86:	e406                	sd	ra,8(sp)
    80000f88:	e022                	sd	s0,0(sp)
    80000f8a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f8c:	02c05363          	blez	a2,80000fb2 <safestrcpy+0x2e>
    80000f90:	fff6069b          	addiw	a3,a2,-1
    80000f94:	1682                	slli	a3,a3,0x20
    80000f96:	9281                	srli	a3,a3,0x20
    80000f98:	96ae                	add	a3,a3,a1
    80000f9a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f9c:	00d58963          	beq	a1,a3,80000fae <safestrcpy+0x2a>
    80000fa0:	0585                	addi	a1,a1,1
    80000fa2:	0785                	addi	a5,a5,1
    80000fa4:	fff5c703          	lbu	a4,-1(a1)
    80000fa8:	fee78fa3          	sb	a4,-1(a5)
    80000fac:	fb65                	bnez	a4,80000f9c <safestrcpy+0x18>
    ;
  *s = 0;
    80000fae:	00078023          	sb	zero,0(a5)
  return os;
}
    80000fb2:	60a2                	ld	ra,8(sp)
    80000fb4:	6402                	ld	s0,0(sp)
    80000fb6:	0141                	addi	sp,sp,16
    80000fb8:	8082                	ret

0000000080000fba <strlen>:

int
strlen(const char *s)
{
    80000fba:	1141                	addi	sp,sp,-16
    80000fbc:	e406                	sd	ra,8(sp)
    80000fbe:	e022                	sd	s0,0(sp)
    80000fc0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000fc2:	00054783          	lbu	a5,0(a0)
    80000fc6:	cf91                	beqz	a5,80000fe2 <strlen+0x28>
    80000fc8:	00150793          	addi	a5,a0,1
    80000fcc:	86be                	mv	a3,a5
    80000fce:	0785                	addi	a5,a5,1
    80000fd0:	fff7c703          	lbu	a4,-1(a5)
    80000fd4:	ff65                	bnez	a4,80000fcc <strlen+0x12>
    80000fd6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000fda:	60a2                	ld	ra,8(sp)
    80000fdc:	6402                	ld	s0,0(sp)
    80000fde:	0141                	addi	sp,sp,16
    80000fe0:	8082                	ret
  for(n = 0; s[n]; n++)
    80000fe2:	4501                	li	a0,0
    80000fe4:	bfdd                	j	80000fda <strlen+0x20>

0000000080000fe6 <transmit_pkt_test1>:
#include "riscv.h"
#include "defs.h"

volatile static int started = 0;

void transmit_pkt_test1() {
    80000fe6:	1141                	addi	sp,sp,-16
    80000fe8:	e406                	sd	ra,8(sp)
    80000fea:	e022                	sd	s0,0(sp)
    80000fec:	0800                	addi	s0,sp,16
  char *pkt1_str = "Hello, world!";
  uint16 pkt1_len = strlen(pkt1_str);
    80000fee:	00008517          	auipc	a0,0x8
    80000ff2:	09250513          	addi	a0,a0,146 # 80009080 <etext+0x80>
    80000ff6:	00000097          	auipc	ra,0x0
    80000ffa:	fc4080e7          	jalr	-60(ra) # 80000fba <strlen>
  transmit_packet(pkt1_str, pkt1_len);
    80000ffe:	03051593          	slli	a1,a0,0x30
    80001002:	91c1                	srli	a1,a1,0x30
    80001004:	00008517          	auipc	a0,0x8
    80001008:	07c50513          	addi	a0,a0,124 # 80009080 <etext+0x80>
    8000100c:	00006097          	auipc	ra,0x6
    80001010:	396080e7          	jalr	918(ra) # 800073a2 <transmit_packet>
  printf("finished transmit_packet test 1\n");
    80001014:	00008517          	auipc	a0,0x8
    80001018:	07c50513          	addi	a0,a0,124 # 80009090 <etext+0x90>
    8000101c:	fffff097          	auipc	ra,0xfffff
    80001020:	58c080e7          	jalr	1420(ra) # 800005a8 <printf>
}
    80001024:	60a2                	ld	ra,8(sp)
    80001026:	6402                	ld	s0,0(sp)
    80001028:	0141                	addi	sp,sp,16
    8000102a:	8082                	ret

000000008000102c <transmit_pkt_test2>:

void transmit_pkt_test2() {
    8000102c:	1101                	addi	sp,sp,-32
    8000102e:	ec06                	sd	ra,24(sp)
    80001030:	e822                	sd	s0,16(sp)
    80001032:	e426                	sd	s1,8(sp)
    80001034:	e04a                	sd	s2,0(sp)
    80001036:	1000                	addi	s0,sp,32
  char *pkt1_str = "Hello, world!";
  uint16 pkt1_len = strlen(pkt1_str);
    80001038:	00008517          	auipc	a0,0x8
    8000103c:	04850513          	addi	a0,a0,72 # 80009080 <etext+0x80>
    80001040:	00000097          	auipc	ra,0x0
    80001044:	f7a080e7          	jalr	-134(ra) # 80000fba <strlen>
    80001048:	892a                	mv	s2,a0
  char *pkt2_str = "Goodbye, world!";
  uint16 pkt2_len = strlen(pkt2_str);
    8000104a:	00008517          	auipc	a0,0x8
    8000104e:	06e50513          	addi	a0,a0,110 # 800090b8 <etext+0xb8>
    80001052:	00000097          	auipc	ra,0x0
    80001056:	f68080e7          	jalr	-152(ra) # 80000fba <strlen>
    8000105a:	84aa                	mv	s1,a0
  transmit_packet(pkt1_str, pkt1_len);
    8000105c:	03091593          	slli	a1,s2,0x30
    80001060:	91c1                	srli	a1,a1,0x30
    80001062:	00008517          	auipc	a0,0x8
    80001066:	01e50513          	addi	a0,a0,30 # 80009080 <etext+0x80>
    8000106a:	00006097          	auipc	ra,0x6
    8000106e:	338080e7          	jalr	824(ra) # 800073a2 <transmit_packet>
  transmit_packet(pkt2_str, pkt2_len);
    80001072:	03049593          	slli	a1,s1,0x30
    80001076:	91c1                	srli	a1,a1,0x30
    80001078:	00008517          	auipc	a0,0x8
    8000107c:	04050513          	addi	a0,a0,64 # 800090b8 <etext+0xb8>
    80001080:	00006097          	auipc	ra,0x6
    80001084:	322080e7          	jalr	802(ra) # 800073a2 <transmit_packet>
  printf("finished transmit_packet test 2\n");
    80001088:	00008517          	auipc	a0,0x8
    8000108c:	04050513          	addi	a0,a0,64 # 800090c8 <etext+0xc8>
    80001090:	fffff097          	auipc	ra,0xfffff
    80001094:	518080e7          	jalr	1304(ra) # 800005a8 <printf>
}
    80001098:	60e2                	ld	ra,24(sp)
    8000109a:	6442                	ld	s0,16(sp)
    8000109c:	64a2                	ld	s1,8(sp)
    8000109e:	6902                	ld	s2,0(sp)
    800010a0:	6105                	addi	sp,sp,32
    800010a2:	8082                	ret

00000000800010a4 <main>:
// }

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800010a4:	1141                	addi	sp,sp,-16
    800010a6:	e406                	sd	ra,8(sp)
    800010a8:	e022                	sd	s0,0(sp)
    800010aa:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800010ac:	00001097          	auipc	ra,0x1
    800010b0:	e54080e7          	jalr	-428(ra) # 80001f00 <cpuid>
    // transmit_pkt_test2();
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800010b4:	0000c717          	auipc	a4,0xc
    800010b8:	91470713          	addi	a4,a4,-1772 # 8000c9c8 <started>
  if(cpuid() == 0){
    800010bc:	c139                	beqz	a0,80001102 <main+0x5e>
    while(started == 0)
    800010be:	431c                	lw	a5,0(a4)
    800010c0:	2781                	sext.w	a5,a5
    800010c2:	dff5                	beqz	a5,800010be <main+0x1a>
      ;
    __sync_synchronize();
    800010c4:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800010c8:	00001097          	auipc	ra,0x1
    800010cc:	e38080e7          	jalr	-456(ra) # 80001f00 <cpuid>
    800010d0:	85aa                	mv	a1,a0
    800010d2:	00008517          	auipc	a0,0x8
    800010d6:	03650513          	addi	a0,a0,54 # 80009108 <etext+0x108>
    800010da:	fffff097          	auipc	ra,0xfffff
    800010de:	4ce080e7          	jalr	1230(ra) # 800005a8 <printf>
    kvminithart();    // turn on paging
    800010e2:	00000097          	auipc	ra,0x0
    800010e6:	0e8080e7          	jalr	232(ra) # 800011ca <kvminithart>
    trapinithart();   // install kernel trap vector
    800010ea:	00002097          	auipc	ra,0x2
    800010ee:	ff2080e7          	jalr	-14(ra) # 800030dc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800010f2:	00005097          	auipc	ra,0x5
    800010f6:	7c4080e7          	jalr	1988(ra) # 800068b6 <plicinithart>
  }

  scheduler();        
    800010fa:	00001097          	auipc	ra,0x1
    800010fe:	53c080e7          	jalr	1340(ra) # 80002636 <scheduler>
    consoleinit();
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	372080e7          	jalr	882(ra) # 80000474 <consoleinit>
    printfinit();
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	6a8080e7          	jalr	1704(ra) # 800007b2 <printfinit>
    printf("\n");
    80001112:	00008517          	auipc	a0,0x8
    80001116:	efe50513          	addi	a0,a0,-258 # 80009010 <etext+0x10>
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	48e080e7          	jalr	1166(ra) # 800005a8 <printf>
    printf("xv6 kernel is booting\n");
    80001122:	00008517          	auipc	a0,0x8
    80001126:	fce50513          	addi	a0,a0,-50 # 800090f0 <etext+0xf0>
    8000112a:	fffff097          	auipc	ra,0xfffff
    8000112e:	47e080e7          	jalr	1150(ra) # 800005a8 <printf>
    printf("\n");
    80001132:	00008517          	auipc	a0,0x8
    80001136:	ede50513          	addi	a0,a0,-290 # 80009010 <etext+0x10>
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	46e080e7          	jalr	1134(ra) # 800005a8 <printf>
    kinit();         // physical page allocator
    80001142:	00000097          	auipc	ra,0x0
    80001146:	a94080e7          	jalr	-1388(ra) # 80000bd6 <kinit>
    kvminit();       // create kernel page table
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	348080e7          	jalr	840(ra) # 80001492 <kvminit>
    kvminithart();   // turn on paging
    80001152:	00000097          	auipc	ra,0x0
    80001156:	078080e7          	jalr	120(ra) # 800011ca <kvminithart>
    procinit();      // process table
    8000115a:	00001097          	auipc	ra,0x1
    8000115e:	cea080e7          	jalr	-790(ra) # 80001e44 <procinit>
    trapinit();      // trap vectors
    80001162:	00002097          	auipc	ra,0x2
    80001166:	f52080e7          	jalr	-174(ra) # 800030b4 <trapinit>
    trapinithart();  // install kernel trap vector
    8000116a:	00002097          	auipc	ra,0x2
    8000116e:	f72080e7          	jalr	-142(ra) # 800030dc <trapinithart>
    plicinit();      // set up interrupt controller
    80001172:	00005097          	auipc	ra,0x5
    80001176:	728080e7          	jalr	1832(ra) # 8000689a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000117a:	00005097          	auipc	ra,0x5
    8000117e:	73c080e7          	jalr	1852(ra) # 800068b6 <plicinithart>
    binit();         // buffer cache
    80001182:	00002097          	auipc	ra,0x2
    80001186:	7b0080e7          	jalr	1968(ra) # 80003932 <binit>
    iinit();         // inode table
    8000118a:	00003097          	auipc	ra,0x3
    8000118e:	e30080e7          	jalr	-464(ra) # 80003fba <iinit>
    fileinit();      // file table
    80001192:	00004097          	auipc	ra,0x4
    80001196:	e1a080e7          	jalr	-486(ra) # 80004fac <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000119a:	00006097          	auipc	ra,0x6
    8000119e:	824080e7          	jalr	-2012(ra) # 800069be <virtio_disk_init>
    virtio_net_init(); // emulated NIC driver 
    800011a2:	00006097          	auipc	ra,0x6
    800011a6:	d98080e7          	jalr	-616(ra) # 80006f3a <virtio_net_init>
    transmit_pkt_test1();
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	e3c080e7          	jalr	-452(ra) # 80000fe6 <transmit_pkt_test1>
    userinit();      // first user process
    800011b2:	00001097          	auipc	ra,0x1
    800011b6:	06e080e7          	jalr	110(ra) # 80002220 <userinit>
    __sync_synchronize();
    800011ba:	0330000f          	fence	rw,rw
    started = 1;
    800011be:	4785                	li	a5,1
    800011c0:	0000c717          	auipc	a4,0xc
    800011c4:	80f72423          	sw	a5,-2040(a4) # 8000c9c8 <started>
    800011c8:	bf0d                	j	800010fa <main+0x56>

00000000800011ca <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800011ca:	1141                	addi	sp,sp,-16
    800011cc:	e406                	sd	ra,8(sp)
    800011ce:	e022                	sd	s0,0(sp)
    800011d0:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800011d2:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800011d6:	0000b797          	auipc	a5,0xb
    800011da:	7fa7b783          	ld	a5,2042(a5) # 8000c9d0 <kernel_pagetable>
    800011de:	83b1                	srli	a5,a5,0xc
    800011e0:	577d                	li	a4,-1
    800011e2:	177e                	slli	a4,a4,0x3f
    800011e4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800011e6:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800011ea:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800011ee:	60a2                	ld	ra,8(sp)
    800011f0:	6402                	ld	s0,0(sp)
    800011f2:	0141                	addi	sp,sp,16
    800011f4:	8082                	ret

00000000800011f6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800011f6:	7139                	addi	sp,sp,-64
    800011f8:	fc06                	sd	ra,56(sp)
    800011fa:	f822                	sd	s0,48(sp)
    800011fc:	f426                	sd	s1,40(sp)
    800011fe:	f04a                	sd	s2,32(sp)
    80001200:	ec4e                	sd	s3,24(sp)
    80001202:	e852                	sd	s4,16(sp)
    80001204:	e456                	sd	s5,8(sp)
    80001206:	e05a                	sd	s6,0(sp)
    80001208:	0080                	addi	s0,sp,64
    8000120a:	84aa                	mv	s1,a0
    8000120c:	89ae                	mv	s3,a1
    8000120e:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80001210:	57fd                	li	a5,-1
    80001212:	83e9                	srli	a5,a5,0x1a
    80001214:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001216:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80001218:	04b7e263          	bltu	a5,a1,8000125c <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    8000121c:	0149d933          	srl	s2,s3,s4
    80001220:	1ff97913          	andi	s2,s2,511
    80001224:	090e                	slli	s2,s2,0x3
    80001226:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001228:	00093483          	ld	s1,0(s2)
    8000122c:	0014f793          	andi	a5,s1,1
    80001230:	cf95                	beqz	a5,8000126c <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001232:	80a9                	srli	s1,s1,0xa
    80001234:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80001236:	3a5d                	addiw	s4,s4,-9
    80001238:	ff5a12e3          	bne	s4,s5,8000121c <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    8000123c:	00c9d513          	srli	a0,s3,0xc
    80001240:	1ff57513          	andi	a0,a0,511
    80001244:	050e                	slli	a0,a0,0x3
    80001246:	9526                	add	a0,a0,s1
}
    80001248:	70e2                	ld	ra,56(sp)
    8000124a:	7442                	ld	s0,48(sp)
    8000124c:	74a2                	ld	s1,40(sp)
    8000124e:	7902                	ld	s2,32(sp)
    80001250:	69e2                	ld	s3,24(sp)
    80001252:	6a42                	ld	s4,16(sp)
    80001254:	6aa2                	ld	s5,8(sp)
    80001256:	6b02                	ld	s6,0(sp)
    80001258:	6121                	addi	sp,sp,64
    8000125a:	8082                	ret
    panic("walk");
    8000125c:	00008517          	auipc	a0,0x8
    80001260:	ec450513          	addi	a0,a0,-316 # 80009120 <etext+0x120>
    80001264:	fffff097          	auipc	ra,0xfffff
    80001268:	2fa080e7          	jalr	762(ra) # 8000055e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000126c:	020b0663          	beqz	s6,80001298 <walk+0xa2>
    80001270:	00000097          	auipc	ra,0x0
    80001274:	9a2080e7          	jalr	-1630(ra) # 80000c12 <kalloc>
    80001278:	84aa                	mv	s1,a0
    8000127a:	d579                	beqz	a0,80001248 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    8000127c:	6605                	lui	a2,0x1
    8000127e:	4581                	li	a1,0
    80001280:	00000097          	auipc	ra,0x0
    80001284:	bac080e7          	jalr	-1108(ra) # 80000e2c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001288:	00c4d793          	srli	a5,s1,0xc
    8000128c:	07aa                	slli	a5,a5,0xa
    8000128e:	0017e793          	ori	a5,a5,1
    80001292:	00f93023          	sd	a5,0(s2)
    80001296:	b745                	j	80001236 <walk+0x40>
        return 0;
    80001298:	4501                	li	a0,0
    8000129a:	b77d                	j	80001248 <walk+0x52>

000000008000129c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000129c:	57fd                	li	a5,-1
    8000129e:	83e9                	srli	a5,a5,0x1a
    800012a0:	00b7f463          	bgeu	a5,a1,800012a8 <walkaddr+0xc>
    return 0;
    800012a4:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800012a6:	8082                	ret
{
    800012a8:	1141                	addi	sp,sp,-16
    800012aa:	e406                	sd	ra,8(sp)
    800012ac:	e022                	sd	s0,0(sp)
    800012ae:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800012b0:	4601                	li	a2,0
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	f44080e7          	jalr	-188(ra) # 800011f6 <walk>
  if(pte == 0)
    800012ba:	c901                	beqz	a0,800012ca <walkaddr+0x2e>
  if((*pte & PTE_V) == 0)
    800012bc:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800012be:	0117f693          	andi	a3,a5,17
    800012c2:	4745                	li	a4,17
    return 0;
    800012c4:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800012c6:	00e68663          	beq	a3,a4,800012d2 <walkaddr+0x36>
}
    800012ca:	60a2                	ld	ra,8(sp)
    800012cc:	6402                	ld	s0,0(sp)
    800012ce:	0141                	addi	sp,sp,16
    800012d0:	8082                	ret
  pa = PTE2PA(*pte);
    800012d2:	83a9                	srli	a5,a5,0xa
    800012d4:	00c79513          	slli	a0,a5,0xc
  return pa;
    800012d8:	bfcd                	j	800012ca <walkaddr+0x2e>

00000000800012da <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800012da:	715d                	addi	sp,sp,-80
    800012dc:	e486                	sd	ra,72(sp)
    800012de:	e0a2                	sd	s0,64(sp)
    800012e0:	fc26                	sd	s1,56(sp)
    800012e2:	f84a                	sd	s2,48(sp)
    800012e4:	f44e                	sd	s3,40(sp)
    800012e6:	f052                	sd	s4,32(sp)
    800012e8:	ec56                	sd	s5,24(sp)
    800012ea:	e85a                	sd	s6,16(sp)
    800012ec:	e45e                	sd	s7,8(sp)
    800012ee:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800012f0:	ca21                	beqz	a2,80001340 <mappages+0x66>
    800012f2:	8a2a                	mv	s4,a0
    800012f4:	8aba                	mv	s5,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800012f6:	777d                	lui	a4,0xfffff
    800012f8:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800012fc:	fff58913          	addi	s2,a1,-1
    80001300:	9932                	add	s2,s2,a2
    80001302:	00e97933          	and	s2,s2,a4
  a = PGROUNDDOWN(va);
    80001306:	84be                	mv	s1,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001308:	4b05                	li	s6,1
    8000130a:	40f689b3          	sub	s3,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000130e:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    80001310:	865a                	mv	a2,s6
    80001312:	85a6                	mv	a1,s1
    80001314:	8552                	mv	a0,s4
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	ee0080e7          	jalr	-288(ra) # 800011f6 <walk>
    8000131e:	c129                	beqz	a0,80001360 <mappages+0x86>
    if(*pte & PTE_V)
    80001320:	611c                	ld	a5,0(a0)
    80001322:	8b85                	andi	a5,a5,1
    80001324:	e795                	bnez	a5,80001350 <mappages+0x76>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001326:	013487b3          	add	a5,s1,s3
    8000132a:	83b1                	srli	a5,a5,0xc
    8000132c:	07aa                	slli	a5,a5,0xa
    8000132e:	0157e7b3          	or	a5,a5,s5
    80001332:	0017e793          	ori	a5,a5,1
    80001336:	e11c                	sd	a5,0(a0)
    if(a == last)
    80001338:	05248063          	beq	s1,s2,80001378 <mappages+0x9e>
    a += PGSIZE;
    8000133c:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000133e:	bfc9                	j	80001310 <mappages+0x36>
    panic("mappages: size");
    80001340:	00008517          	auipc	a0,0x8
    80001344:	de850513          	addi	a0,a0,-536 # 80009128 <etext+0x128>
    80001348:	fffff097          	auipc	ra,0xfffff
    8000134c:	216080e7          	jalr	534(ra) # 8000055e <panic>
      panic("mappages: remap");
    80001350:	00008517          	auipc	a0,0x8
    80001354:	de850513          	addi	a0,a0,-536 # 80009138 <etext+0x138>
    80001358:	fffff097          	auipc	ra,0xfffff
    8000135c:	206080e7          	jalr	518(ra) # 8000055e <panic>
      return -1;
    80001360:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001362:	60a6                	ld	ra,72(sp)
    80001364:	6406                	ld	s0,64(sp)
    80001366:	74e2                	ld	s1,56(sp)
    80001368:	7942                	ld	s2,48(sp)
    8000136a:	79a2                	ld	s3,40(sp)
    8000136c:	7a02                	ld	s4,32(sp)
    8000136e:	6ae2                	ld	s5,24(sp)
    80001370:	6b42                	ld	s6,16(sp)
    80001372:	6ba2                	ld	s7,8(sp)
    80001374:	6161                	addi	sp,sp,80
    80001376:	8082                	ret
  return 0;
    80001378:	4501                	li	a0,0
    8000137a:	b7e5                	j	80001362 <mappages+0x88>

000000008000137c <kvmmap>:
{
    8000137c:	1141                	addi	sp,sp,-16
    8000137e:	e406                	sd	ra,8(sp)
    80001380:	e022                	sd	s0,0(sp)
    80001382:	0800                	addi	s0,sp,16
    80001384:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001386:	86b2                	mv	a3,a2
    80001388:	863e                	mv	a2,a5
    8000138a:	00000097          	auipc	ra,0x0
    8000138e:	f50080e7          	jalr	-176(ra) # 800012da <mappages>
    80001392:	e509                	bnez	a0,8000139c <kvmmap+0x20>
}
    80001394:	60a2                	ld	ra,8(sp)
    80001396:	6402                	ld	s0,0(sp)
    80001398:	0141                	addi	sp,sp,16
    8000139a:	8082                	ret
    panic("kvmmap");
    8000139c:	00008517          	auipc	a0,0x8
    800013a0:	dac50513          	addi	a0,a0,-596 # 80009148 <etext+0x148>
    800013a4:	fffff097          	auipc	ra,0xfffff
    800013a8:	1ba080e7          	jalr	442(ra) # 8000055e <panic>

00000000800013ac <kvmmake>:
{
    800013ac:	1101                	addi	sp,sp,-32
    800013ae:	ec06                	sd	ra,24(sp)
    800013b0:	e822                	sd	s0,16(sp)
    800013b2:	e426                	sd	s1,8(sp)
    800013b4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800013b6:	00000097          	auipc	ra,0x0
    800013ba:	85c080e7          	jalr	-1956(ra) # 80000c12 <kalloc>
    800013be:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800013c0:	6605                	lui	a2,0x1
    800013c2:	4581                	li	a1,0
    800013c4:	00000097          	auipc	ra,0x0
    800013c8:	a68080e7          	jalr	-1432(ra) # 80000e2c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800013cc:	4719                	li	a4,6
    800013ce:	6685                	lui	a3,0x1
    800013d0:	10000637          	lui	a2,0x10000
    800013d4:	85b2                	mv	a1,a2
    800013d6:	8526                	mv	a0,s1
    800013d8:	00000097          	auipc	ra,0x0
    800013dc:	fa4080e7          	jalr	-92(ra) # 8000137c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800013e0:	4719                	li	a4,6
    800013e2:	6685                	lui	a3,0x1
    800013e4:	10001637          	lui	a2,0x10001
    800013e8:	85b2                	mv	a1,a2
    800013ea:	8526                	mv	a0,s1
    800013ec:	00000097          	auipc	ra,0x0
    800013f0:	f90080e7          	jalr	-112(ra) # 8000137c <kvmmap>
  kvmmap(kpgtbl, VIRTIO1, VIRTIO1, PGSIZE, PTE_R | PTE_W);
    800013f4:	4719                	li	a4,6
    800013f6:	6685                	lui	a3,0x1
    800013f8:	10002637          	lui	a2,0x10002
    800013fc:	85b2                	mv	a1,a2
    800013fe:	8526                	mv	a0,s1
    80001400:	00000097          	auipc	ra,0x0
    80001404:	f7c080e7          	jalr	-132(ra) # 8000137c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001408:	4719                	li	a4,6
    8000140a:	004006b7          	lui	a3,0x400
    8000140e:	0c000637          	lui	a2,0xc000
    80001412:	85b2                	mv	a1,a2
    80001414:	8526                	mv	a0,s1
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	f66080e7          	jalr	-154(ra) # 8000137c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000141e:	4729                	li	a4,10
    80001420:	80008697          	auipc	a3,0x80008
    80001424:	be068693          	addi	a3,a3,-1056 # 9000 <_entry-0x7fff7000>
    80001428:	4605                	li	a2,1
    8000142a:	067e                	slli	a2,a2,0x1f
    8000142c:	85b2                	mv	a1,a2
    8000142e:	8526                	mv	a0,s1
    80001430:	00000097          	auipc	ra,0x0
    80001434:	f4c080e7          	jalr	-180(ra) # 8000137c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001438:	4719                	li	a4,6
    8000143a:	00008697          	auipc	a3,0x8
    8000143e:	bc668693          	addi	a3,a3,-1082 # 80009000 <etext>
    80001442:	47c5                	li	a5,17
    80001444:	07ee                	slli	a5,a5,0x1b
    80001446:	40d786b3          	sub	a3,a5,a3
    8000144a:	00008617          	auipc	a2,0x8
    8000144e:	bb660613          	addi	a2,a2,-1098 # 80009000 <etext>
    80001452:	85b2                	mv	a1,a2
    80001454:	8526                	mv	a0,s1
    80001456:	00000097          	auipc	ra,0x0
    8000145a:	f26080e7          	jalr	-218(ra) # 8000137c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000145e:	4729                	li	a4,10
    80001460:	6685                	lui	a3,0x1
    80001462:	00007617          	auipc	a2,0x7
    80001466:	b9e60613          	addi	a2,a2,-1122 # 80008000 <_trampoline>
    8000146a:	040005b7          	lui	a1,0x4000
    8000146e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001470:	05b2                	slli	a1,a1,0xc
    80001472:	8526                	mv	a0,s1
    80001474:	00000097          	auipc	ra,0x0
    80001478:	f08080e7          	jalr	-248(ra) # 8000137c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000147c:	8526                	mv	a0,s1
    8000147e:	00001097          	auipc	ra,0x1
    80001482:	91c080e7          	jalr	-1764(ra) # 80001d9a <proc_mapstacks>
}
    80001486:	8526                	mv	a0,s1
    80001488:	60e2                	ld	ra,24(sp)
    8000148a:	6442                	ld	s0,16(sp)
    8000148c:	64a2                	ld	s1,8(sp)
    8000148e:	6105                	addi	sp,sp,32
    80001490:	8082                	ret

0000000080001492 <kvminit>:
{
    80001492:	1141                	addi	sp,sp,-16
    80001494:	e406                	sd	ra,8(sp)
    80001496:	e022                	sd	s0,0(sp)
    80001498:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000149a:	00000097          	auipc	ra,0x0
    8000149e:	f12080e7          	jalr	-238(ra) # 800013ac <kvmmake>
    800014a2:	0000b797          	auipc	a5,0xb
    800014a6:	52a7b723          	sd	a0,1326(a5) # 8000c9d0 <kernel_pagetable>
}
    800014aa:	60a2                	ld	ra,8(sp)
    800014ac:	6402                	ld	s0,0(sp)
    800014ae:	0141                	addi	sp,sp,16
    800014b0:	8082                	ret

00000000800014b2 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800014b2:	715d                	addi	sp,sp,-80
    800014b4:	e486                	sd	ra,72(sp)
    800014b6:	e0a2                	sd	s0,64(sp)
    800014b8:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800014ba:	03459793          	slli	a5,a1,0x34
    800014be:	e39d                	bnez	a5,800014e4 <uvmunmap+0x32>
    800014c0:	f84a                	sd	s2,48(sp)
    800014c2:	f44e                	sd	s3,40(sp)
    800014c4:	f052                	sd	s4,32(sp)
    800014c6:	ec56                	sd	s5,24(sp)
    800014c8:	e85a                	sd	s6,16(sp)
    800014ca:	e45e                	sd	s7,8(sp)
    800014cc:	8a2a                	mv	s4,a0
    800014ce:	892e                	mv	s2,a1
    800014d0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014d2:	0632                	slli	a2,a2,0xc
    800014d4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800014d8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014da:	6b05                	lui	s6,0x1
    800014dc:	0935fb63          	bgeu	a1,s3,80001572 <uvmunmap+0xc0>
    800014e0:	fc26                	sd	s1,56(sp)
    800014e2:	a8a9                	j	8000153c <uvmunmap+0x8a>
    800014e4:	fc26                	sd	s1,56(sp)
    800014e6:	f84a                	sd	s2,48(sp)
    800014e8:	f44e                	sd	s3,40(sp)
    800014ea:	f052                	sd	s4,32(sp)
    800014ec:	ec56                	sd	s5,24(sp)
    800014ee:	e85a                	sd	s6,16(sp)
    800014f0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800014f2:	00008517          	auipc	a0,0x8
    800014f6:	c5e50513          	addi	a0,a0,-930 # 80009150 <etext+0x150>
    800014fa:	fffff097          	auipc	ra,0xfffff
    800014fe:	064080e7          	jalr	100(ra) # 8000055e <panic>
      panic("uvmunmap: walk");
    80001502:	00008517          	auipc	a0,0x8
    80001506:	c6650513          	addi	a0,a0,-922 # 80009168 <etext+0x168>
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	054080e7          	jalr	84(ra) # 8000055e <panic>
      panic("uvmunmap: not mapped");
    80001512:	00008517          	auipc	a0,0x8
    80001516:	c6650513          	addi	a0,a0,-922 # 80009178 <etext+0x178>
    8000151a:	fffff097          	auipc	ra,0xfffff
    8000151e:	044080e7          	jalr	68(ra) # 8000055e <panic>
      panic("uvmunmap: not a leaf");
    80001522:	00008517          	auipc	a0,0x8
    80001526:	c6e50513          	addi	a0,a0,-914 # 80009190 <etext+0x190>
    8000152a:	fffff097          	auipc	ra,0xfffff
    8000152e:	034080e7          	jalr	52(ra) # 8000055e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001532:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001536:	995a                	add	s2,s2,s6
    80001538:	03397c63          	bgeu	s2,s3,80001570 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000153c:	4601                	li	a2,0
    8000153e:	85ca                	mv	a1,s2
    80001540:	8552                	mv	a0,s4
    80001542:	00000097          	auipc	ra,0x0
    80001546:	cb4080e7          	jalr	-844(ra) # 800011f6 <walk>
    8000154a:	84aa                	mv	s1,a0
    8000154c:	d95d                	beqz	a0,80001502 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000154e:	6108                	ld	a0,0(a0)
    80001550:	00157793          	andi	a5,a0,1
    80001554:	dfdd                	beqz	a5,80001512 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001556:	3ff57793          	andi	a5,a0,1023
    8000155a:	fd7784e3          	beq	a5,s7,80001522 <uvmunmap+0x70>
    if(do_free){
    8000155e:	fc0a8ae3          	beqz	s5,80001532 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80001562:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001564:	0532                	slli	a0,a0,0xc
    80001566:	fffff097          	auipc	ra,0xfffff
    8000156a:	53e080e7          	jalr	1342(ra) # 80000aa4 <kfree>
    8000156e:	b7d1                	j	80001532 <uvmunmap+0x80>
    80001570:	74e2                	ld	s1,56(sp)
    80001572:	7942                	ld	s2,48(sp)
    80001574:	79a2                	ld	s3,40(sp)
    80001576:	7a02                	ld	s4,32(sp)
    80001578:	6ae2                	ld	s5,24(sp)
    8000157a:	6b42                	ld	s6,16(sp)
    8000157c:	6ba2                	ld	s7,8(sp)
  }
}
    8000157e:	60a6                	ld	ra,72(sp)
    80001580:	6406                	ld	s0,64(sp)
    80001582:	6161                	addi	sp,sp,80
    80001584:	8082                	ret

0000000080001586 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001586:	1101                	addi	sp,sp,-32
    80001588:	ec06                	sd	ra,24(sp)
    8000158a:	e822                	sd	s0,16(sp)
    8000158c:	e426                	sd	s1,8(sp)
    8000158e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001590:	fffff097          	auipc	ra,0xfffff
    80001594:	682080e7          	jalr	1666(ra) # 80000c12 <kalloc>
    80001598:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000159a:	c519                	beqz	a0,800015a8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000159c:	6605                	lui	a2,0x1
    8000159e:	4581                	li	a1,0
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	88c080e7          	jalr	-1908(ra) # 80000e2c <memset>
  return pagetable;
}
    800015a8:	8526                	mv	a0,s1
    800015aa:	60e2                	ld	ra,24(sp)
    800015ac:	6442                	ld	s0,16(sp)
    800015ae:	64a2                	ld	s1,8(sp)
    800015b0:	6105                	addi	sp,sp,32
    800015b2:	8082                	ret

00000000800015b4 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800015b4:	7179                	addi	sp,sp,-48
    800015b6:	f406                	sd	ra,40(sp)
    800015b8:	f022                	sd	s0,32(sp)
    800015ba:	ec26                	sd	s1,24(sp)
    800015bc:	e84a                	sd	s2,16(sp)
    800015be:	e44e                	sd	s3,8(sp)
    800015c0:	e052                	sd	s4,0(sp)
    800015c2:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800015c4:	6785                	lui	a5,0x1
    800015c6:	04f67863          	bgeu	a2,a5,80001616 <uvmfirst+0x62>
    800015ca:	89aa                	mv	s3,a0
    800015cc:	8a2e                	mv	s4,a1
    800015ce:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800015d0:	fffff097          	auipc	ra,0xfffff
    800015d4:	642080e7          	jalr	1602(ra) # 80000c12 <kalloc>
    800015d8:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800015da:	6605                	lui	a2,0x1
    800015dc:	4581                	li	a1,0
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	84e080e7          	jalr	-1970(ra) # 80000e2c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800015e6:	4779                	li	a4,30
    800015e8:	86ca                	mv	a3,s2
    800015ea:	6605                	lui	a2,0x1
    800015ec:	4581                	li	a1,0
    800015ee:	854e                	mv	a0,s3
    800015f0:	00000097          	auipc	ra,0x0
    800015f4:	cea080e7          	jalr	-790(ra) # 800012da <mappages>
  memmove(mem, src, sz);
    800015f8:	8626                	mv	a2,s1
    800015fa:	85d2                	mv	a1,s4
    800015fc:	854a                	mv	a0,s2
    800015fe:	00000097          	auipc	ra,0x0
    80001602:	88e080e7          	jalr	-1906(ra) # 80000e8c <memmove>
}
    80001606:	70a2                	ld	ra,40(sp)
    80001608:	7402                	ld	s0,32(sp)
    8000160a:	64e2                	ld	s1,24(sp)
    8000160c:	6942                	ld	s2,16(sp)
    8000160e:	69a2                	ld	s3,8(sp)
    80001610:	6a02                	ld	s4,0(sp)
    80001612:	6145                	addi	sp,sp,48
    80001614:	8082                	ret
    panic("uvmfirst: more than a page");
    80001616:	00008517          	auipc	a0,0x8
    8000161a:	b9250513          	addi	a0,a0,-1134 # 800091a8 <etext+0x1a8>
    8000161e:	fffff097          	auipc	ra,0xfffff
    80001622:	f40080e7          	jalr	-192(ra) # 8000055e <panic>

0000000080001626 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
  uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001626:	1101                	addi	sp,sp,-32
    80001628:	ec06                	sd	ra,24(sp)
    8000162a:	e822                	sd	s0,16(sp)
    8000162c:	e426                	sd	s1,8(sp)
    8000162e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001630:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001632:	00b67d63          	bgeu	a2,a1,8000164c <uvmdealloc+0x26>
    80001636:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001638:	6785                	lui	a5,0x1
    8000163a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000163c:	00f60733          	add	a4,a2,a5
    80001640:	76fd                	lui	a3,0xfffff
    80001642:	8f75                	and	a4,a4,a3
    80001644:	97ae                	add	a5,a5,a1
    80001646:	8ff5                	and	a5,a5,a3
    80001648:	00f76863          	bltu	a4,a5,80001658 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000164c:	8526                	mv	a0,s1
    8000164e:	60e2                	ld	ra,24(sp)
    80001650:	6442                	ld	s0,16(sp)
    80001652:	64a2                	ld	s1,8(sp)
    80001654:	6105                	addi	sp,sp,32
    80001656:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001658:	8f99                	sub	a5,a5,a4
    8000165a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000165c:	4685                	li	a3,1
    8000165e:	0007861b          	sext.w	a2,a5
    80001662:	85ba                	mv	a1,a4
    80001664:	00000097          	auipc	ra,0x0
    80001668:	e4e080e7          	jalr	-434(ra) # 800014b2 <uvmunmap>
    8000166c:	b7c5                	j	8000164c <uvmdealloc+0x26>

000000008000166e <uvmalloc>:
  if(newsz < oldsz)
    8000166e:	0ab66d63          	bltu	a2,a1,80001728 <uvmalloc+0xba>
{
    80001672:	715d                	addi	sp,sp,-80
    80001674:	e486                	sd	ra,72(sp)
    80001676:	e0a2                	sd	s0,64(sp)
    80001678:	f84a                	sd	s2,48(sp)
    8000167a:	f052                	sd	s4,32(sp)
    8000167c:	ec56                	sd	s5,24(sp)
    8000167e:	e45e                	sd	s7,8(sp)
    80001680:	0880                	addi	s0,sp,80
    80001682:	8aaa                	mv	s5,a0
    80001684:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001686:	6785                	lui	a5,0x1
    80001688:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000168a:	95be                	add	a1,a1,a5
    8000168c:	77fd                	lui	a5,0xfffff
    8000168e:	00f5f933          	and	s2,a1,a5
    80001692:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001694:	08c97c63          	bgeu	s2,a2,8000172c <uvmalloc+0xbe>
    80001698:	fc26                	sd	s1,56(sp)
    8000169a:	f44e                	sd	s3,40(sp)
    8000169c:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    8000169e:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800016a0:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800016a4:	fffff097          	auipc	ra,0xfffff
    800016a8:	56e080e7          	jalr	1390(ra) # 80000c12 <kalloc>
    800016ac:	84aa                	mv	s1,a0
    if(mem == 0){
    800016ae:	c90d                	beqz	a0,800016e0 <uvmalloc+0x72>
    memset(mem, 0, PGSIZE);
    800016b0:	864e                	mv	a2,s3
    800016b2:	4581                	li	a1,0
    800016b4:	fffff097          	auipc	ra,0xfffff
    800016b8:	778080e7          	jalr	1912(ra) # 80000e2c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800016bc:	875a                	mv	a4,s6
    800016be:	86a6                	mv	a3,s1
    800016c0:	864e                	mv	a2,s3
    800016c2:	85ca                	mv	a1,s2
    800016c4:	8556                	mv	a0,s5
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	c14080e7          	jalr	-1004(ra) # 800012da <mappages>
    800016ce:	ed05                	bnez	a0,80001706 <uvmalloc+0x98>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800016d0:	994e                	add	s2,s2,s3
    800016d2:	fd4969e3          	bltu	s2,s4,800016a4 <uvmalloc+0x36>
  return newsz;
    800016d6:	8552                	mv	a0,s4
    800016d8:	74e2                	ld	s1,56(sp)
    800016da:	79a2                	ld	s3,40(sp)
    800016dc:	6b42                	ld	s6,16(sp)
    800016de:	a821                	j	800016f6 <uvmalloc+0x88>
      uvmdealloc(pagetable, a, oldsz);
    800016e0:	865e                	mv	a2,s7
    800016e2:	85ca                	mv	a1,s2
    800016e4:	8556                	mv	a0,s5
    800016e6:	00000097          	auipc	ra,0x0
    800016ea:	f40080e7          	jalr	-192(ra) # 80001626 <uvmdealloc>
      return 0;
    800016ee:	4501                	li	a0,0
    800016f0:	74e2                	ld	s1,56(sp)
    800016f2:	79a2                	ld	s3,40(sp)
    800016f4:	6b42                	ld	s6,16(sp)
}
    800016f6:	60a6                	ld	ra,72(sp)
    800016f8:	6406                	ld	s0,64(sp)
    800016fa:	7942                	ld	s2,48(sp)
    800016fc:	7a02                	ld	s4,32(sp)
    800016fe:	6ae2                	ld	s5,24(sp)
    80001700:	6ba2                	ld	s7,8(sp)
    80001702:	6161                	addi	sp,sp,80
    80001704:	8082                	ret
      kfree(mem);
    80001706:	8526                	mv	a0,s1
    80001708:	fffff097          	auipc	ra,0xfffff
    8000170c:	39c080e7          	jalr	924(ra) # 80000aa4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001710:	865e                	mv	a2,s7
    80001712:	85ca                	mv	a1,s2
    80001714:	8556                	mv	a0,s5
    80001716:	00000097          	auipc	ra,0x0
    8000171a:	f10080e7          	jalr	-240(ra) # 80001626 <uvmdealloc>
      return 0;
    8000171e:	4501                	li	a0,0
    80001720:	74e2                	ld	s1,56(sp)
    80001722:	79a2                	ld	s3,40(sp)
    80001724:	6b42                	ld	s6,16(sp)
    80001726:	bfc1                	j	800016f6 <uvmalloc+0x88>
    return oldsz;
    80001728:	852e                	mv	a0,a1
}
    8000172a:	8082                	ret
  return newsz;
    8000172c:	8532                	mv	a0,a2
    8000172e:	b7e1                	j	800016f6 <uvmalloc+0x88>

0000000080001730 <uvmthreaded_alloc>:
uvmthreaded_alloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz, uint64 xperm) {
    80001730:	7119                	addi	sp,sp,-128
    80001732:	fc86                	sd	ra,120(sp)
    80001734:	f8a2                	sd	s0,112(sp)
    80001736:	0100                	addi	s0,sp,128
    80001738:	f8a43423          	sd	a0,-120(s0)
  if(newsz < oldsz)
    8000173c:	16b66163          	bltu	a2,a1,8000189e <uvmthreaded_alloc+0x16e>
    80001740:	e4d6                	sd	s5,72(sp)
    80001742:	f466                	sd	s9,40(sp)
    80001744:	ec6e                	sd	s11,24(sp)
    80001746:	8ab2                	mv	s5,a2
    80001748:	8db6                	mv	s11,a3
  oldsz = PGROUNDUP(oldsz);
    8000174a:	6785                	lui	a5,0x1
    8000174c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000174e:	95be                	add	a1,a1,a5
    80001750:	77fd                	lui	a5,0xfffff
    80001752:	00f5fcb3          	and	s9,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001756:	14ccf663          	bgeu	s9,a2,800018a2 <uvmthreaded_alloc+0x172>
    8000175a:	f4a6                	sd	s1,104(sp)
    8000175c:	f0ca                	sd	s2,96(sp)
    8000175e:	ecce                	sd	s3,88(sp)
    80001760:	e8d2                	sd	s4,80(sp)
    80001762:	e0da                	sd	s6,64(sp)
    80001764:	fc5e                	sd	s7,56(sp)
    80001766:	f862                	sd	s8,48(sp)
    80001768:	f06a                	sd	s10,32(sp)
  struct proc *p = thread_proc->parent;
    8000176a:	03853d03          	ld	s10,56(a0)
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000176e:	8b66                	mv	s6,s9
    memset(mem, 0, PGSIZE);
    80001770:	6c05                	lui	s8,0x1
    80001772:	370d0a13          	addi	s4,s10,880
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001776:	0126eb93          	ori	s7,a3,18
    8000177a:	2b81                	sext.w	s7,s7
    mem = kalloc();
    8000177c:	fffff097          	auipc	ra,0xfffff
    80001780:	496080e7          	jalr	1174(ra) # 80000c12 <kalloc>
    80001784:	89aa                	mv	s3,a0
    if(mem == 0){
    80001786:	c911                	beqz	a0,8000179a <uvmthreaded_alloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001788:	8662                	mv	a2,s8
    8000178a:	4581                	li	a1,0
    8000178c:	fffff097          	auipc	ra,0xfffff
    80001790:	6a0080e7          	jalr	1696(ra) # 80000e2c <memset>
    for (int i = 0; i < MAX_THREADS; i++) {
    80001794:	170d0493          	addi	s1,s10,368
    80001798:	a0bd                	j	80001806 <uvmthreaded_alloc+0xd6>
      uvmdealloc(thread_proc->pagetable, a, oldsz);
    8000179a:	8666                	mv	a2,s9
    8000179c:	85da                	mv	a1,s6
    8000179e:	f8843783          	ld	a5,-120(s0)
    800017a2:	6ba8                	ld	a0,80(a5)
    800017a4:	00000097          	auipc	ra,0x0
    800017a8:	e82080e7          	jalr	-382(ra) # 80001626 <uvmdealloc>
      return 0;
    800017ac:	4501                	li	a0,0
    800017ae:	74a6                	ld	s1,104(sp)
    800017b0:	7906                	ld	s2,96(sp)
    800017b2:	69e6                	ld	s3,88(sp)
    800017b4:	6a46                	ld	s4,80(sp)
    800017b6:	6aa6                	ld	s5,72(sp)
    800017b8:	6b06                	ld	s6,64(sp)
    800017ba:	7be2                	ld	s7,56(sp)
    800017bc:	7c42                	ld	s8,48(sp)
    800017be:	7ca2                	ld	s9,40(sp)
    800017c0:	7d02                	ld	s10,32(sp)
    800017c2:	6de2                	ld	s11,24(sp)
    800017c4:	a815                	j	800017f8 <uvmthreaded_alloc+0xc8>
        kfree(mem);
    800017c6:	854e                	mv	a0,s3
    800017c8:	fffff097          	auipc	ra,0xfffff
    800017cc:	2dc080e7          	jalr	732(ra) # 80000aa4 <kfree>
        uvmdealloc(infant->pagetable, a, oldsz);
    800017d0:	8666                	mv	a2,s9
    800017d2:	85da                	mv	a1,s6
    800017d4:	05093503          	ld	a0,80(s2)
    800017d8:	00000097          	auipc	ra,0x0
    800017dc:	e4e080e7          	jalr	-434(ra) # 80001626 <uvmdealloc>
        return 0;
    800017e0:	4501                	li	a0,0
    800017e2:	74a6                	ld	s1,104(sp)
    800017e4:	7906                	ld	s2,96(sp)
    800017e6:	69e6                	ld	s3,88(sp)
    800017e8:	6a46                	ld	s4,80(sp)
    800017ea:	6aa6                	ld	s5,72(sp)
    800017ec:	6b06                	ld	s6,64(sp)
    800017ee:	7be2                	ld	s7,56(sp)
    800017f0:	7c42                	ld	s8,48(sp)
    800017f2:	7ca2                	ld	s9,40(sp)
    800017f4:	7d02                	ld	s10,32(sp)
    800017f6:	6de2                	ld	s11,24(sp)
}
    800017f8:	70e6                	ld	ra,120(sp)
    800017fa:	7446                	ld	s0,112(sp)
    800017fc:	6109                	addi	sp,sp,128
    800017fe:	8082                	ret
    for (int i = 0; i < MAX_THREADS; i++) {
    80001800:	04a1                	addi	s1,s1,8
    80001802:	03448463          	beq	s1,s4,8000182a <uvmthreaded_alloc+0xfa>
      struct proc *infant = p->infant_threads[i];
    80001806:	0004b903          	ld	s2,0(s1)
      if (infant == 0)
    8000180a:	fe090be3          	beqz	s2,80001800 <uvmthreaded_alloc+0xd0>
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000180e:	875e                	mv	a4,s7
    80001810:	86ce                	mv	a3,s3
    80001812:	8662                	mv	a2,s8
    80001814:	85da                	mv	a1,s6
    80001816:	05093503          	ld	a0,80(s2)
    8000181a:	00000097          	auipc	ra,0x0
    8000181e:	ac0080e7          	jalr	-1344(ra) # 800012da <mappages>
    80001822:	f155                	bnez	a0,800017c6 <uvmthreaded_alloc+0x96>
      infant->sz = newsz;
    80001824:	05593423          	sd	s5,72(s2)
    80001828:	bfe1                	j	80001800 <uvmthreaded_alloc+0xd0>
    if(mappages(p->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000182a:	012de713          	ori	a4,s11,18
    8000182e:	2701                	sext.w	a4,a4
    80001830:	86ce                	mv	a3,s3
    80001832:	6605                	lui	a2,0x1
    80001834:	85da                	mv	a1,s6
    80001836:	050d3503          	ld	a0,80(s10)
    8000183a:	00000097          	auipc	ra,0x0
    8000183e:	aa0080e7          	jalr	-1376(ra) # 800012da <mappages>
    80001842:	e505                	bnez	a0,8000186a <uvmthreaded_alloc+0x13a>
    p->sz = newsz;
    80001844:	055d3423          	sd	s5,72(s10)
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001848:	6785                	lui	a5,0x1
    8000184a:	9b3e                	add	s6,s6,a5
    8000184c:	f35b68e3          	bltu	s6,s5,8000177c <uvmthreaded_alloc+0x4c>
  return newsz;
    80001850:	8556                	mv	a0,s5
    80001852:	74a6                	ld	s1,104(sp)
    80001854:	7906                	ld	s2,96(sp)
    80001856:	69e6                	ld	s3,88(sp)
    80001858:	6a46                	ld	s4,80(sp)
    8000185a:	6aa6                	ld	s5,72(sp)
    8000185c:	6b06                	ld	s6,64(sp)
    8000185e:	7be2                	ld	s7,56(sp)
    80001860:	7c42                	ld	s8,48(sp)
    80001862:	7ca2                	ld	s9,40(sp)
    80001864:	7d02                	ld	s10,32(sp)
    80001866:	6de2                	ld	s11,24(sp)
    80001868:	bf41                	j	800017f8 <uvmthreaded_alloc+0xc8>
      kfree(mem);
    8000186a:	854e                	mv	a0,s3
    8000186c:	fffff097          	auipc	ra,0xfffff
    80001870:	238080e7          	jalr	568(ra) # 80000aa4 <kfree>
      uvmdealloc(p->pagetable, a, oldsz);
    80001874:	8666                	mv	a2,s9
    80001876:	85da                	mv	a1,s6
    80001878:	050d3503          	ld	a0,80(s10)
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	daa080e7          	jalr	-598(ra) # 80001626 <uvmdealloc>
      return 0;
    80001884:	4501                	li	a0,0
    80001886:	74a6                	ld	s1,104(sp)
    80001888:	7906                	ld	s2,96(sp)
    8000188a:	69e6                	ld	s3,88(sp)
    8000188c:	6a46                	ld	s4,80(sp)
    8000188e:	6aa6                	ld	s5,72(sp)
    80001890:	6b06                	ld	s6,64(sp)
    80001892:	7be2                	ld	s7,56(sp)
    80001894:	7c42                	ld	s8,48(sp)
    80001896:	7ca2                	ld	s9,40(sp)
    80001898:	7d02                	ld	s10,32(sp)
    8000189a:	6de2                	ld	s11,24(sp)
    8000189c:	bfb1                	j	800017f8 <uvmthreaded_alloc+0xc8>
    return oldsz;
    8000189e:	852e                	mv	a0,a1
    800018a0:	bfa1                	j	800017f8 <uvmthreaded_alloc+0xc8>
  return newsz;
    800018a2:	8532                	mv	a0,a2
    800018a4:	6aa6                	ld	s5,72(sp)
    800018a6:	7ca2                	ld	s9,40(sp)
    800018a8:	6de2                	ld	s11,24(sp)
    800018aa:	b7b9                	j	800017f8 <uvmthreaded_alloc+0xc8>

00000000800018ac <uvmthreaded_dealloc>:

uint64
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
  struct proc *p = thread_proc->parent;

  if(newsz >= oldsz)
    800018ac:	0ab67163          	bgeu	a2,a1,8000194e <uvmthreaded_dealloc+0xa2>
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
    800018b0:	715d                	addi	sp,sp,-80
    800018b2:	e486                	sd	ra,72(sp)
    800018b4:	e0a2                	sd	s0,64(sp)
    800018b6:	fc26                	sd	s1,56(sp)
    800018b8:	f84a                	sd	s2,48(sp)
    800018ba:	f44e                	sd	s3,40(sp)
    800018bc:	f052                	sd	s4,32(sp)
    800018be:	ec56                	sd	s5,24(sp)
    800018c0:	e85a                	sd	s6,16(sp)
    800018c2:	e45e                	sd	s7,8(sp)
    800018c4:	e062                	sd	s8,0(sp)
    800018c6:	0880                	addi	s0,sp,80
    800018c8:	8ab2                	mv	s5,a2
  struct proc *p = thread_proc->parent;
    800018ca:	03853c03          	ld	s8,56(a0)
    return oldsz;

  int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800018ce:	6785                	lui	a5,0x1
    800018d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800018d2:	95be                	add	a1,a1,a5
    800018d4:	777d                	lui	a4,0xfffff
    800018d6:	00e5fb33          	and	s6,a1,a4
    800018da:	97b2                	add	a5,a5,a2
    800018dc:	00e7f9b3          	and	s3,a5,a4
    800018e0:	413b0bb3          	sub	s7,s6,s3
    800018e4:	00cbdb93          	srli	s7,s7,0xc
    800018e8:	2b81                	sext.w	s7,s7

  for (int i = 0; i < MAX_THREADS; i++) {
    800018ea:	170c0493          	addi	s1,s8,368 # 1170 <_entry-0x7fffee90>
    800018ee:	370c0a13          	addi	s4,s8,880
    800018f2:	a031                	j	800018fe <uvmthreaded_dealloc+0x52>
      continue;

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    }
    infant->sz = newsz;
    800018f4:	05593423          	sd	s5,72(s2)
  for (int i = 0; i < MAX_THREADS; i++) {
    800018f8:	04a1                	addi	s1,s1,8
    800018fa:	03448263          	beq	s1,s4,8000191e <uvmthreaded_dealloc+0x72>
    struct proc *infant = p->infant_threads[i];
    800018fe:	0004b903          	ld	s2,0(s1)
    if (infant == 0)
    80001902:	fe090be3          	beqz	s2,800018f8 <uvmthreaded_dealloc+0x4c>
    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
    80001906:	ff69f7e3          	bgeu	s3,s6,800018f4 <uvmthreaded_dealloc+0x48>
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    8000190a:	4681                	li	a3,0
    8000190c:	865e                	mv	a2,s7
    8000190e:	85ce                	mv	a1,s3
    80001910:	05093503          	ld	a0,80(s2)
    80001914:	00000097          	auipc	ra,0x0
    80001918:	b9e080e7          	jalr	-1122(ra) # 800014b2 <uvmunmap>
    8000191c:	bfe1                	j	800018f4 <uvmthreaded_dealloc+0x48>
  }

  uvmunmap(p->pagetable, PGROUNDUP(newsz), npages, 1); //unmap with freeing
    8000191e:	4685                	li	a3,1
    80001920:	865e                	mv	a2,s7
    80001922:	85ce                	mv	a1,s3
    80001924:	050c3503          	ld	a0,80(s8)
    80001928:	00000097          	auipc	ra,0x0
    8000192c:	b8a080e7          	jalr	-1142(ra) # 800014b2 <uvmunmap>
  p->sz = newsz;
    80001930:	055c3423          	sd	s5,72(s8)

  return newsz;
    80001934:	8556                	mv	a0,s5
}
    80001936:	60a6                	ld	ra,72(sp)
    80001938:	6406                	ld	s0,64(sp)
    8000193a:	74e2                	ld	s1,56(sp)
    8000193c:	7942                	ld	s2,48(sp)
    8000193e:	79a2                	ld	s3,40(sp)
    80001940:	7a02                	ld	s4,32(sp)
    80001942:	6ae2                	ld	s5,24(sp)
    80001944:	6b42                	ld	s6,16(sp)
    80001946:	6ba2                	ld	s7,8(sp)
    80001948:	6c02                	ld	s8,0(sp)
    8000194a:	6161                	addi	sp,sp,80
    8000194c:	8082                	ret
    return oldsz;
    8000194e:	852e                	mv	a0,a1
}
    80001950:	8082                	ret

0000000080001952 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001952:	7179                	addi	sp,sp,-48
    80001954:	f406                	sd	ra,40(sp)
    80001956:	f022                	sd	s0,32(sp)
    80001958:	ec26                	sd	s1,24(sp)
    8000195a:	e84a                	sd	s2,16(sp)
    8000195c:	e44e                	sd	s3,8(sp)
    8000195e:	1800                	addi	s0,sp,48
    80001960:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001962:	84aa                	mv	s1,a0
    80001964:	6905                	lui	s2,0x1
    80001966:	992a                	add	s2,s2,a0
    80001968:	a821                	j	80001980 <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    8000196a:	00008517          	auipc	a0,0x8
    8000196e:	85e50513          	addi	a0,a0,-1954 # 800091c8 <etext+0x1c8>
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	bec080e7          	jalr	-1044(ra) # 8000055e <panic>
  for(int i = 0; i < 512; i++){
    8000197a:	04a1                	addi	s1,s1,8
    8000197c:	03248363          	beq	s1,s2,800019a2 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001980:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001982:	0017f713          	andi	a4,a5,1
    80001986:	db75                	beqz	a4,8000197a <freewalk+0x28>
    80001988:	00e7f713          	andi	a4,a5,14
    8000198c:	ff79                	bnez	a4,8000196a <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    8000198e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001990:	00c79513          	slli	a0,a5,0xc
    80001994:	00000097          	auipc	ra,0x0
    80001998:	fbe080e7          	jalr	-66(ra) # 80001952 <freewalk>
      pagetable[i] = 0;
    8000199c:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800019a0:	bfe9                	j	8000197a <freewalk+0x28>
    }
  }
  kfree((void*)pagetable);
    800019a2:	854e                	mv	a0,s3
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	100080e7          	jalr	256(ra) # 80000aa4 <kfree>
}
    800019ac:	70a2                	ld	ra,40(sp)
    800019ae:	7402                	ld	s0,32(sp)
    800019b0:	64e2                	ld	s1,24(sp)
    800019b2:	6942                	ld	s2,16(sp)
    800019b4:	69a2                	ld	s3,8(sp)
    800019b6:	6145                	addi	sp,sp,48
    800019b8:	8082                	ret

00000000800019ba <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800019ba:	1101                	addi	sp,sp,-32
    800019bc:	ec06                	sd	ra,24(sp)
    800019be:	e822                	sd	s0,16(sp)
    800019c0:	e426                	sd	s1,8(sp)
    800019c2:	1000                	addi	s0,sp,32
    800019c4:	84aa                	mv	s1,a0
  if(sz > 0)
    800019c6:	e999                	bnez	a1,800019dc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800019c8:	8526                	mv	a0,s1
    800019ca:	00000097          	auipc	ra,0x0
    800019ce:	f88080e7          	jalr	-120(ra) # 80001952 <freewalk>
}
    800019d2:	60e2                	ld	ra,24(sp)
    800019d4:	6442                	ld	s0,16(sp)
    800019d6:	64a2                	ld	s1,8(sp)
    800019d8:	6105                	addi	sp,sp,32
    800019da:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800019dc:	6785                	lui	a5,0x1
    800019de:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800019e0:	95be                	add	a1,a1,a5
    800019e2:	4685                	li	a3,1
    800019e4:	00c5d613          	srli	a2,a1,0xc
    800019e8:	4581                	li	a1,0
    800019ea:	00000097          	auipc	ra,0x0
    800019ee:	ac8080e7          	jalr	-1336(ra) # 800014b2 <uvmunmap>
    800019f2:	bfd9                	j	800019c8 <uvmfree+0xe>

00000000800019f4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800019f4:	c669                	beqz	a2,80001abe <uvmcopy+0xca>
{
    800019f6:	715d                	addi	sp,sp,-80
    800019f8:	e486                	sd	ra,72(sp)
    800019fa:	e0a2                	sd	s0,64(sp)
    800019fc:	fc26                	sd	s1,56(sp)
    800019fe:	f84a                	sd	s2,48(sp)
    80001a00:	f44e                	sd	s3,40(sp)
    80001a02:	f052                	sd	s4,32(sp)
    80001a04:	ec56                	sd	s5,24(sp)
    80001a06:	e85a                	sd	s6,16(sp)
    80001a08:	e45e                	sd	s7,8(sp)
    80001a0a:	0880                	addi	s0,sp,80
    80001a0c:	8b2a                	mv	s6,a0
    80001a0e:	8aae                	mv	s5,a1
    80001a10:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001a12:	4901                	li	s2,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001a14:	6985                	lui	s3,0x1
    if((pte = walk(old, i, 0)) == 0)
    80001a16:	4601                	li	a2,0
    80001a18:	85ca                	mv	a1,s2
    80001a1a:	855a                	mv	a0,s6
    80001a1c:	fffff097          	auipc	ra,0xfffff
    80001a20:	7da080e7          	jalr	2010(ra) # 800011f6 <walk>
    80001a24:	c139                	beqz	a0,80001a6a <uvmcopy+0x76>
    if((*pte & PTE_V) == 0)
    80001a26:	00053b83          	ld	s7,0(a0)
    80001a2a:	001bf793          	andi	a5,s7,1
    80001a2e:	c7b1                	beqz	a5,80001a7a <uvmcopy+0x86>
    if((mem = kalloc()) == 0)
    80001a30:	fffff097          	auipc	ra,0xfffff
    80001a34:	1e2080e7          	jalr	482(ra) # 80000c12 <kalloc>
    80001a38:	84aa                	mv	s1,a0
    80001a3a:	cd29                	beqz	a0,80001a94 <uvmcopy+0xa0>
    pa = PTE2PA(*pte);
    80001a3c:	00abd593          	srli	a1,s7,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80001a40:	864e                	mv	a2,s3
    80001a42:	05b2                	slli	a1,a1,0xc
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	448080e7          	jalr	1096(ra) # 80000e8c <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001a4c:	3ffbf713          	andi	a4,s7,1023
    80001a50:	86a6                	mv	a3,s1
    80001a52:	864e                	mv	a2,s3
    80001a54:	85ca                	mv	a1,s2
    80001a56:	8556                	mv	a0,s5
    80001a58:	00000097          	auipc	ra,0x0
    80001a5c:	882080e7          	jalr	-1918(ra) # 800012da <mappages>
    80001a60:	e50d                	bnez	a0,80001a8a <uvmcopy+0x96>
  for(i = 0; i < sz; i += PGSIZE){
    80001a62:	994e                	add	s2,s2,s3
    80001a64:	fb4969e3          	bltu	s2,s4,80001a16 <uvmcopy+0x22>
    80001a68:	a081                	j	80001aa8 <uvmcopy+0xb4>
      panic("uvmcopy: pte should exist");
    80001a6a:	00007517          	auipc	a0,0x7
    80001a6e:	76e50513          	addi	a0,a0,1902 # 800091d8 <etext+0x1d8>
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	aec080e7          	jalr	-1300(ra) # 8000055e <panic>
      panic("uvmcopy: page not present");
    80001a7a:	00007517          	auipc	a0,0x7
    80001a7e:	77e50513          	addi	a0,a0,1918 # 800091f8 <etext+0x1f8>
    80001a82:	fffff097          	auipc	ra,0xfffff
    80001a86:	adc080e7          	jalr	-1316(ra) # 8000055e <panic>
      kfree(mem);
    80001a8a:	8526                	mv	a0,s1
    80001a8c:	fffff097          	auipc	ra,0xfffff
    80001a90:	018080e7          	jalr	24(ra) # 80000aa4 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001a94:	4685                	li	a3,1
    80001a96:	00c95613          	srli	a2,s2,0xc
    80001a9a:	4581                	li	a1,0
    80001a9c:	8556                	mv	a0,s5
    80001a9e:	00000097          	auipc	ra,0x0
    80001aa2:	a14080e7          	jalr	-1516(ra) # 800014b2 <uvmunmap>
  return -1;
    80001aa6:	557d                	li	a0,-1
}
    80001aa8:	60a6                	ld	ra,72(sp)
    80001aaa:	6406                	ld	s0,64(sp)
    80001aac:	74e2                	ld	s1,56(sp)
    80001aae:	7942                	ld	s2,48(sp)
    80001ab0:	79a2                	ld	s3,40(sp)
    80001ab2:	7a02                	ld	s4,32(sp)
    80001ab4:	6ae2                	ld	s5,24(sp)
    80001ab6:	6b42                	ld	s6,16(sp)
    80001ab8:	6ba2                	ld	s7,8(sp)
    80001aba:	6161                	addi	sp,sp,80
    80001abc:	8082                	ret
  return 0;
    80001abe:	4501                	li	a0,0
}
    80001ac0:	8082                	ret

0000000080001ac2 <uvmshare>:

int
uvmshare(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001ac2:	715d                	addi	sp,sp,-80
    80001ac4:	e486                	sd	ra,72(sp)
    80001ac6:	e0a2                	sd	s0,64(sp)
    80001ac8:	f44e                	sd	s3,40(sp)
    80001aca:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa = 0, i;
  uint flags;
  
  for(i = 0; i < sz; i += PGSIZE) {
    80001acc:	ce5d                	beqz	a2,80001b8a <uvmshare+0xc8>
    80001ace:	fc26                	sd	s1,56(sp)
    80001ad0:	f84a                	sd	s2,48(sp)
    80001ad2:	f052                	sd	s4,32(sp)
    80001ad4:	ec56                	sd	s5,24(sp)
    80001ad6:	e85a                	sd	s6,16(sp)
    80001ad8:	e45e                	sd	s7,8(sp)
    80001ada:	8baa                	mv	s7,a0
    80001adc:	8b2e                	mv	s6,a1
    80001ade:	8ab2                	mv	s5,a2
    80001ae0:	4901                	li	s2,0

    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    // flags |= PTE_W;

    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
    80001ae2:	6a05                	lui	s4,0x1
    80001ae4:	a891                	j	80001b38 <uvmshare+0x76>
    if(pte == 0) panic("uvmshare: pte should exist");
    80001ae6:	00007517          	auipc	a0,0x7
    80001aea:	73250513          	addi	a0,a0,1842 # 80009218 <etext+0x218>
    80001aee:	fffff097          	auipc	ra,0xfffff
    80001af2:	a70080e7          	jalr	-1424(ra) # 8000055e <panic>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001af6:	00007517          	auipc	a0,0x7
    80001afa:	74250513          	addi	a0,a0,1858 # 80009238 <etext+0x238>
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	a60080e7          	jalr	-1440(ra) # 8000055e <panic>
      uvmunmap(new, 0, i / PGSIZE, 0);
    80001b06:	4681                	li	a3,0
    80001b08:	00c95613          	srli	a2,s2,0xc
    80001b0c:	4581                	li	a1,0
    80001b0e:	855a                	mv	a0,s6
    80001b10:	00000097          	auipc	ra,0x0
    80001b14:	9a2080e7          	jalr	-1630(ra) # 800014b2 <uvmunmap>
      return -1;
    80001b18:	59fd                	li	s3,-1
    80001b1a:	74e2                	ld	s1,56(sp)
    80001b1c:	7942                	ld	s2,48(sp)
    80001b1e:	7a02                	ld	s4,32(sp)
    80001b20:	6ae2                	ld	s5,24(sp)
    80001b22:	6b42                	ld	s6,16(sp)
    80001b24:	6ba2                	ld	s7,8(sp)
      add_page_reference((uint64)pa);
  }

  return 0;

}
    80001b26:	854e                	mv	a0,s3
    80001b28:	60a6                	ld	ra,72(sp)
    80001b2a:	6406                	ld	s0,64(sp)
    80001b2c:	79a2                	ld	s3,40(sp)
    80001b2e:	6161                	addi	sp,sp,80
    80001b30:	8082                	ret
  for(i = 0; i < sz; i += PGSIZE) {
    80001b32:	9952                	add	s2,s2,s4
    80001b34:	05597463          	bgeu	s2,s5,80001b7c <uvmshare+0xba>
    pte = walk(old, i, 0);
    80001b38:	4601                	li	a2,0
    80001b3a:	85ca                	mv	a1,s2
    80001b3c:	855e                	mv	a0,s7
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	6b8080e7          	jalr	1720(ra) # 800011f6 <walk>
    if(pte == 0) panic("uvmshare: pte should exist");
    80001b46:	d145                	beqz	a0,80001ae6 <uvmshare+0x24>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001b48:	6118                	ld	a4,0(a0)
    80001b4a:	00177793          	andi	a5,a4,1
    80001b4e:	d7c5                	beqz	a5,80001af6 <uvmshare+0x34>
    pa = PTE2PA(*pte);
    80001b50:	00a75493          	srli	s1,a4,0xa
    80001b54:	04b2                	slli	s1,s1,0xc
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
    80001b56:	3ff77713          	andi	a4,a4,1023
    80001b5a:	86a6                	mv	a3,s1
    80001b5c:	8652                	mv	a2,s4
    80001b5e:	85ca                	mv	a1,s2
    80001b60:	855a                	mv	a0,s6
    80001b62:	fffff097          	auipc	ra,0xfffff
    80001b66:	778080e7          	jalr	1912(ra) # 800012da <mappages>
    80001b6a:	89aa                	mv	s3,a0
    80001b6c:	fd49                	bnez	a0,80001b06 <uvmshare+0x44>
    if (pa != 0)
    80001b6e:	d0f1                	beqz	s1,80001b32 <uvmshare+0x70>
      add_page_reference((uint64)pa);
    80001b70:	8526                	mv	a0,s1
    80001b72:	fffff097          	auipc	ra,0xfffff
    80001b76:	ee2080e7          	jalr	-286(ra) # 80000a54 <add_page_reference>
    80001b7a:	bf65                	j	80001b32 <uvmshare+0x70>
    80001b7c:	74e2                	ld	s1,56(sp)
    80001b7e:	7942                	ld	s2,48(sp)
    80001b80:	7a02                	ld	s4,32(sp)
    80001b82:	6ae2                	ld	s5,24(sp)
    80001b84:	6b42                	ld	s6,16(sp)
    80001b86:	6ba2                	ld	s7,8(sp)
    80001b88:	bf79                	j	80001b26 <uvmshare+0x64>
  return 0;
    80001b8a:	4981                	li	s3,0
    80001b8c:	bf69                	j	80001b26 <uvmshare+0x64>

0000000080001b8e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001b8e:	1141                	addi	sp,sp,-16
    80001b90:	e406                	sd	ra,8(sp)
    80001b92:	e022                	sd	s0,0(sp)
    80001b94:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001b96:	4601                	li	a2,0
    80001b98:	fffff097          	auipc	ra,0xfffff
    80001b9c:	65e080e7          	jalr	1630(ra) # 800011f6 <walk>
  if(pte == 0)
    80001ba0:	c901                	beqz	a0,80001bb0 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001ba2:	611c                	ld	a5,0(a0)
    80001ba4:	9bbd                	andi	a5,a5,-17
    80001ba6:	e11c                	sd	a5,0(a0)
}
    80001ba8:	60a2                	ld	ra,8(sp)
    80001baa:	6402                	ld	s0,0(sp)
    80001bac:	0141                	addi	sp,sp,16
    80001bae:	8082                	ret
    panic("uvmclear");
    80001bb0:	00007517          	auipc	a0,0x7
    80001bb4:	6a850513          	addi	a0,a0,1704 # 80009258 <etext+0x258>
    80001bb8:	fffff097          	auipc	ra,0xfffff
    80001bbc:	9a6080e7          	jalr	-1626(ra) # 8000055e <panic>

0000000080001bc0 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001bc0:	c6bd                	beqz	a3,80001c2e <copyout+0x6e>
{
    80001bc2:	715d                	addi	sp,sp,-80
    80001bc4:	e486                	sd	ra,72(sp)
    80001bc6:	e0a2                	sd	s0,64(sp)
    80001bc8:	fc26                	sd	s1,56(sp)
    80001bca:	f84a                	sd	s2,48(sp)
    80001bcc:	f44e                	sd	s3,40(sp)
    80001bce:	f052                	sd	s4,32(sp)
    80001bd0:	ec56                	sd	s5,24(sp)
    80001bd2:	e85a                	sd	s6,16(sp)
    80001bd4:	e45e                	sd	s7,8(sp)
    80001bd6:	e062                	sd	s8,0(sp)
    80001bd8:	0880                	addi	s0,sp,80
    80001bda:	8b2a                	mv	s6,a0
    80001bdc:	8c2e                	mv	s8,a1
    80001bde:	8a32                	mv	s4,a2
    80001be0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001be2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001be4:	6a85                	lui	s5,0x1
    80001be6:	a015                	j	80001c0a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001be8:	9562                	add	a0,a0,s8
    80001bea:	0004861b          	sext.w	a2,s1
    80001bee:	85d2                	mv	a1,s4
    80001bf0:	41250533          	sub	a0,a0,s2
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	298080e7          	jalr	664(ra) # 80000e8c <memmove>

    len -= n;
    80001bfc:	409989b3          	sub	s3,s3,s1
    src += n;
    80001c00:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001c02:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001c06:	02098263          	beqz	s3,80001c2a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001c0a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001c0e:	85ca                	mv	a1,s2
    80001c10:	855a                	mv	a0,s6
    80001c12:	fffff097          	auipc	ra,0xfffff
    80001c16:	68a080e7          	jalr	1674(ra) # 8000129c <walkaddr>
    if(pa0 == 0)
    80001c1a:	cd01                	beqz	a0,80001c32 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001c1c:	418904b3          	sub	s1,s2,s8
    80001c20:	94d6                	add	s1,s1,s5
    if(n > len)
    80001c22:	fc99f3e3          	bgeu	s3,s1,80001be8 <copyout+0x28>
    80001c26:	84ce                	mv	s1,s3
    80001c28:	b7c1                	j	80001be8 <copyout+0x28>
  }
  return 0;
    80001c2a:	4501                	li	a0,0
    80001c2c:	a021                	j	80001c34 <copyout+0x74>
    80001c2e:	4501                	li	a0,0
}
    80001c30:	8082                	ret
      return -1;
    80001c32:	557d                	li	a0,-1
}
    80001c34:	60a6                	ld	ra,72(sp)
    80001c36:	6406                	ld	s0,64(sp)
    80001c38:	74e2                	ld	s1,56(sp)
    80001c3a:	7942                	ld	s2,48(sp)
    80001c3c:	79a2                	ld	s3,40(sp)
    80001c3e:	7a02                	ld	s4,32(sp)
    80001c40:	6ae2                	ld	s5,24(sp)
    80001c42:	6b42                	ld	s6,16(sp)
    80001c44:	6ba2                	ld	s7,8(sp)
    80001c46:	6c02                	ld	s8,0(sp)
    80001c48:	6161                	addi	sp,sp,80
    80001c4a:	8082                	ret

0000000080001c4c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001c4c:	caa5                	beqz	a3,80001cbc <copyin+0x70>
{
    80001c4e:	715d                	addi	sp,sp,-80
    80001c50:	e486                	sd	ra,72(sp)
    80001c52:	e0a2                	sd	s0,64(sp)
    80001c54:	fc26                	sd	s1,56(sp)
    80001c56:	f84a                	sd	s2,48(sp)
    80001c58:	f44e                	sd	s3,40(sp)
    80001c5a:	f052                	sd	s4,32(sp)
    80001c5c:	ec56                	sd	s5,24(sp)
    80001c5e:	e85a                	sd	s6,16(sp)
    80001c60:	e45e                	sd	s7,8(sp)
    80001c62:	e062                	sd	s8,0(sp)
    80001c64:	0880                	addi	s0,sp,80
    80001c66:	8b2a                	mv	s6,a0
    80001c68:	8a2e                	mv	s4,a1
    80001c6a:	8c32                	mv	s8,a2
    80001c6c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001c6e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001c70:	6a85                	lui	s5,0x1
    80001c72:	a01d                	j	80001c98 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001c74:	018505b3          	add	a1,a0,s8
    80001c78:	0004861b          	sext.w	a2,s1
    80001c7c:	412585b3          	sub	a1,a1,s2
    80001c80:	8552                	mv	a0,s4
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	20a080e7          	jalr	522(ra) # 80000e8c <memmove>

    len -= n;
    80001c8a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001c8e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001c90:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001c94:	02098263          	beqz	s3,80001cb8 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001c98:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001c9c:	85ca                	mv	a1,s2
    80001c9e:	855a                	mv	a0,s6
    80001ca0:	fffff097          	auipc	ra,0xfffff
    80001ca4:	5fc080e7          	jalr	1532(ra) # 8000129c <walkaddr>
    if(pa0 == 0)
    80001ca8:	cd01                	beqz	a0,80001cc0 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001caa:	418904b3          	sub	s1,s2,s8
    80001cae:	94d6                	add	s1,s1,s5
    if(n > len)
    80001cb0:	fc99f2e3          	bgeu	s3,s1,80001c74 <copyin+0x28>
    80001cb4:	84ce                	mv	s1,s3
    80001cb6:	bf7d                	j	80001c74 <copyin+0x28>
  }
  return 0;
    80001cb8:	4501                	li	a0,0
    80001cba:	a021                	j	80001cc2 <copyin+0x76>
    80001cbc:	4501                	li	a0,0
}
    80001cbe:	8082                	ret
      return -1;
    80001cc0:	557d                	li	a0,-1
}
    80001cc2:	60a6                	ld	ra,72(sp)
    80001cc4:	6406                	ld	s0,64(sp)
    80001cc6:	74e2                	ld	s1,56(sp)
    80001cc8:	7942                	ld	s2,48(sp)
    80001cca:	79a2                	ld	s3,40(sp)
    80001ccc:	7a02                	ld	s4,32(sp)
    80001cce:	6ae2                	ld	s5,24(sp)
    80001cd0:	6b42                	ld	s6,16(sp)
    80001cd2:	6ba2                	ld	s7,8(sp)
    80001cd4:	6c02                	ld	s8,0(sp)
    80001cd6:	6161                	addi	sp,sp,80
    80001cd8:	8082                	ret

0000000080001cda <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001cda:	cad5                	beqz	a3,80001d8e <copyinstr+0xb4>
{
    80001cdc:	715d                	addi	sp,sp,-80
    80001cde:	e486                	sd	ra,72(sp)
    80001ce0:	e0a2                	sd	s0,64(sp)
    80001ce2:	fc26                	sd	s1,56(sp)
    80001ce4:	f84a                	sd	s2,48(sp)
    80001ce6:	f44e                	sd	s3,40(sp)
    80001ce8:	f052                	sd	s4,32(sp)
    80001cea:	ec56                	sd	s5,24(sp)
    80001cec:	e85a                	sd	s6,16(sp)
    80001cee:	e45e                	sd	s7,8(sp)
    80001cf0:	0880                	addi	s0,sp,80
    80001cf2:	8aaa                	mv	s5,a0
    80001cf4:	84ae                	mv	s1,a1
    80001cf6:	8bb2                	mv	s7,a2
    80001cf8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001cfa:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001cfc:	6a05                	lui	s4,0x1
    80001cfe:	a82d                	j	80001d38 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001d00:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80001d04:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001d06:	0017c793          	xori	a5,a5,1
    80001d0a:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001d0e:	60a6                	ld	ra,72(sp)
    80001d10:	6406                	ld	s0,64(sp)
    80001d12:	74e2                	ld	s1,56(sp)
    80001d14:	7942                	ld	s2,48(sp)
    80001d16:	79a2                	ld	s3,40(sp)
    80001d18:	7a02                	ld	s4,32(sp)
    80001d1a:	6ae2                	ld	s5,24(sp)
    80001d1c:	6b42                	ld	s6,16(sp)
    80001d1e:	6ba2                	ld	s7,8(sp)
    80001d20:	6161                	addi	sp,sp,80
    80001d22:	8082                	ret
    80001d24:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001d28:	9726                	add	a4,a4,s1
      --max;
    80001d2a:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80001d2e:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001d32:	04e58663          	beq	a1,a4,80001d7e <copyinstr+0xa4>
{
    80001d36:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001d38:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001d3c:	85ca                	mv	a1,s2
    80001d3e:	8556                	mv	a0,s5
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	55c080e7          	jalr	1372(ra) # 8000129c <walkaddr>
    if(pa0 == 0)
    80001d48:	cd0d                	beqz	a0,80001d82 <copyinstr+0xa8>
    n = PGSIZE - (srcva - va0);
    80001d4a:	417906b3          	sub	a3,s2,s7
    80001d4e:	96d2                	add	a3,a3,s4
    if(n > max)
    80001d50:	00d9f363          	bgeu	s3,a3,80001d56 <copyinstr+0x7c>
    80001d54:	86ce                	mv	a3,s3
    while(n > 0){
    80001d56:	ca85                	beqz	a3,80001d86 <copyinstr+0xac>
    char *p = (char *) (pa0 + (srcva - va0));
    80001d58:	01750633          	add	a2,a0,s7
    80001d5c:	41260633          	sub	a2,a2,s2
    80001d60:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80001d62:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80001d64:	96a6                	add	a3,a3,s1
    80001d66:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001d68:	00f60733          	add	a4,a2,a5
    80001d6c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff90f28>
    80001d70:	db41                	beqz	a4,80001d00 <copyinstr+0x26>
        *dst = *p;
    80001d72:	00e78023          	sb	a4,0(a5)
      dst++;
    80001d76:	0785                	addi	a5,a5,1
    while(n > 0){
    80001d78:	fed797e3          	bne	a5,a3,80001d66 <copyinstr+0x8c>
    80001d7c:	b765                	j	80001d24 <copyinstr+0x4a>
    80001d7e:	4781                	li	a5,0
    80001d80:	b759                	j	80001d06 <copyinstr+0x2c>
      return -1;
    80001d82:	557d                	li	a0,-1
    80001d84:	b769                	j	80001d0e <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80001d86:	6b85                	lui	s7,0x1
    80001d88:	9bca                	add	s7,s7,s2
    80001d8a:	87a6                	mv	a5,s1
    80001d8c:	b76d                	j	80001d36 <copyinstr+0x5c>
  int got_null = 0;
    80001d8e:	4781                	li	a5,0
  if(got_null){
    80001d90:	0017c793          	xori	a5,a5,1
    80001d94:	40f0053b          	negw	a0,a5
}
    80001d98:	8082                	ret

0000000080001d9a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001d9a:	715d                	addi	sp,sp,-80
    80001d9c:	e486                	sd	ra,72(sp)
    80001d9e:	e0a2                	sd	s0,64(sp)
    80001da0:	fc26                	sd	s1,56(sp)
    80001da2:	f84a                	sd	s2,48(sp)
    80001da4:	f44e                	sd	s3,40(sp)
    80001da6:	f052                	sd	s4,32(sp)
    80001da8:	ec56                	sd	s5,24(sp)
    80001daa:	e85a                	sd	s6,16(sp)
    80001dac:	e45e                	sd	s7,8(sp)
    80001dae:	e062                	sd	s8,0(sp)
    80001db0:	0880                	addi	s0,sp,80
    80001db2:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001db4:	00053497          	auipc	s1,0x53
    80001db8:	2cc48493          	addi	s1,s1,716 # 80055080 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001dbc:	8c26                	mv	s8,s1
    80001dbe:	586fb7b7          	lui	a5,0x586fb
    80001dc2:	58778793          	addi	a5,a5,1415 # 586fb587 <_entry-0x27904a79>
    80001dc6:	6fb58937          	lui	s2,0x6fb58
    80001dca:	6fb90913          	addi	s2,s2,1787 # 6fb586fb <_entry-0x104a7905>
    80001dce:	1902                	slli	s2,s2,0x20
    80001dd0:	993e                	add	s2,s2,a5
    80001dd2:	040009b7          	lui	s3,0x4000
    80001dd6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001dd8:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001dda:	4b99                	li	s7,6
    80001ddc:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001dde:	00061a97          	auipc	s5,0x61
    80001de2:	ea2a8a93          	addi	s5,s5,-350 # 80062c80 <tickslock>
    char *pa = kalloc();
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	e2c080e7          	jalr	-468(ra) # 80000c12 <kalloc>
    80001dee:	862a                	mv	a2,a0
    if(pa == 0)
    80001df0:	c131                	beqz	a0,80001e34 <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80001df2:	418485b3          	sub	a1,s1,s8
    80001df6:	8591                	srai	a1,a1,0x4
    80001df8:	032585b3          	mul	a1,a1,s2
    80001dfc:	05b6                	slli	a1,a1,0xd
    80001dfe:	6789                	lui	a5,0x2
    80001e00:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001e02:	875e                	mv	a4,s7
    80001e04:	86da                	mv	a3,s6
    80001e06:	40b985b3          	sub	a1,s3,a1
    80001e0a:	8552                	mv	a0,s4
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	570080e7          	jalr	1392(ra) # 8000137c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e14:	37048493          	addi	s1,s1,880
    80001e18:	fd5497e3          	bne	s1,s5,80001de6 <proc_mapstacks+0x4c>
  }
}
    80001e1c:	60a6                	ld	ra,72(sp)
    80001e1e:	6406                	ld	s0,64(sp)
    80001e20:	74e2                	ld	s1,56(sp)
    80001e22:	7942                	ld	s2,48(sp)
    80001e24:	79a2                	ld	s3,40(sp)
    80001e26:	7a02                	ld	s4,32(sp)
    80001e28:	6ae2                	ld	s5,24(sp)
    80001e2a:	6b42                	ld	s6,16(sp)
    80001e2c:	6ba2                	ld	s7,8(sp)
    80001e2e:	6c02                	ld	s8,0(sp)
    80001e30:	6161                	addi	sp,sp,80
    80001e32:	8082                	ret
      panic("kalloc");
    80001e34:	00007517          	auipc	a0,0x7
    80001e38:	43450513          	addi	a0,a0,1076 # 80009268 <etext+0x268>
    80001e3c:	ffffe097          	auipc	ra,0xffffe
    80001e40:	722080e7          	jalr	1826(ra) # 8000055e <panic>

0000000080001e44 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001e44:	7139                	addi	sp,sp,-64
    80001e46:	fc06                	sd	ra,56(sp)
    80001e48:	f822                	sd	s0,48(sp)
    80001e4a:	f426                	sd	s1,40(sp)
    80001e4c:	f04a                	sd	s2,32(sp)
    80001e4e:	ec4e                	sd	s3,24(sp)
    80001e50:	e852                	sd	s4,16(sp)
    80001e52:	e456                	sd	s5,8(sp)
    80001e54:	e05a                	sd	s6,0(sp)
    80001e56:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001e58:	00007597          	auipc	a1,0x7
    80001e5c:	41858593          	addi	a1,a1,1048 # 80009270 <etext+0x270>
    80001e60:	00053517          	auipc	a0,0x53
    80001e64:	df050513          	addi	a0,a0,-528 # 80054c50 <pid_lock>
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	e32080e7          	jalr	-462(ra) # 80000c9a <initlock>
  initlock(&wait_lock, "wait_lock");
    80001e70:	00007597          	auipc	a1,0x7
    80001e74:	40858593          	addi	a1,a1,1032 # 80009278 <etext+0x278>
    80001e78:	00053517          	auipc	a0,0x53
    80001e7c:	df050513          	addi	a0,a0,-528 # 80054c68 <wait_lock>
    80001e80:	fffff097          	auipc	ra,0xfffff
    80001e84:	e1a080e7          	jalr	-486(ra) # 80000c9a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e88:	00053497          	auipc	s1,0x53
    80001e8c:	1f848493          	addi	s1,s1,504 # 80055080 <proc>
      initlock(&p->lock, "proc");
    80001e90:	00007b17          	auipc	s6,0x7
    80001e94:	3f8b0b13          	addi	s6,s6,1016 # 80009288 <etext+0x288>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001e98:	8aa6                	mv	s5,s1
    80001e9a:	586fb7b7          	lui	a5,0x586fb
    80001e9e:	58778793          	addi	a5,a5,1415 # 586fb587 <_entry-0x27904a79>
    80001ea2:	6fb58937          	lui	s2,0x6fb58
    80001ea6:	6fb90913          	addi	s2,s2,1787 # 6fb586fb <_entry-0x104a7905>
    80001eaa:	1902                	slli	s2,s2,0x20
    80001eac:	993e                	add	s2,s2,a5
    80001eae:	040009b7          	lui	s3,0x4000
    80001eb2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001eb4:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001eb6:	00061a17          	auipc	s4,0x61
    80001eba:	dcaa0a13          	addi	s4,s4,-566 # 80062c80 <tickslock>
      initlock(&p->lock, "proc");
    80001ebe:	85da                	mv	a1,s6
    80001ec0:	8526                	mv	a0,s1
    80001ec2:	fffff097          	auipc	ra,0xfffff
    80001ec6:	dd8080e7          	jalr	-552(ra) # 80000c9a <initlock>
      p->state = UNUSED;
    80001eca:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001ece:	415487b3          	sub	a5,s1,s5
    80001ed2:	8791                	srai	a5,a5,0x4
    80001ed4:	032787b3          	mul	a5,a5,s2
    80001ed8:	07b6                	slli	a5,a5,0xd
    80001eda:	6709                	lui	a4,0x2
    80001edc:	9fb9                	addw	a5,a5,a4
    80001ede:	40f987b3          	sub	a5,s3,a5
    80001ee2:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ee4:	37048493          	addi	s1,s1,880
    80001ee8:	fd449be3          	bne	s1,s4,80001ebe <procinit+0x7a>
  }
}
    80001eec:	70e2                	ld	ra,56(sp)
    80001eee:	7442                	ld	s0,48(sp)
    80001ef0:	74a2                	ld	s1,40(sp)
    80001ef2:	7902                	ld	s2,32(sp)
    80001ef4:	69e2                	ld	s3,24(sp)
    80001ef6:	6a42                	ld	s4,16(sp)
    80001ef8:	6aa2                	ld	s5,8(sp)
    80001efa:	6b02                	ld	s6,0(sp)
    80001efc:	6121                	addi	sp,sp,64
    80001efe:	8082                	ret

0000000080001f00 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001f00:	1141                	addi	sp,sp,-16
    80001f02:	e406                	sd	ra,8(sp)
    80001f04:	e022                	sd	s0,0(sp)
    80001f06:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f08:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001f0a:	2501                	sext.w	a0,a0
    80001f0c:	60a2                	ld	ra,8(sp)
    80001f0e:	6402                	ld	s0,0(sp)
    80001f10:	0141                	addi	sp,sp,16
    80001f12:	8082                	ret

0000000080001f14 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001f14:	1141                	addi	sp,sp,-16
    80001f16:	e406                	sd	ra,8(sp)
    80001f18:	e022                	sd	s0,0(sp)
    80001f1a:	0800                	addi	s0,sp,16
    80001f1c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001f1e:	2781                	sext.w	a5,a5
    80001f20:	079e                	slli	a5,a5,0x7
  return c;
}
    80001f22:	00053517          	auipc	a0,0x53
    80001f26:	d5e50513          	addi	a0,a0,-674 # 80054c80 <cpus>
    80001f2a:	953e                	add	a0,a0,a5
    80001f2c:	60a2                	ld	ra,8(sp)
    80001f2e:	6402                	ld	s0,0(sp)
    80001f30:	0141                	addi	sp,sp,16
    80001f32:	8082                	ret

0000000080001f34 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001f34:	1101                	addi	sp,sp,-32
    80001f36:	ec06                	sd	ra,24(sp)
    80001f38:	e822                	sd	s0,16(sp)
    80001f3a:	e426                	sd	s1,8(sp)
    80001f3c:	1000                	addi	s0,sp,32
  push_off();
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	da6080e7          	jalr	-602(ra) # 80000ce4 <push_off>
    80001f46:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001f48:	2781                	sext.w	a5,a5
    80001f4a:	079e                	slli	a5,a5,0x7
    80001f4c:	00053717          	auipc	a4,0x53
    80001f50:	d0470713          	addi	a4,a4,-764 # 80054c50 <pid_lock>
    80001f54:	97ba                	add	a5,a5,a4
    80001f56:	7b9c                	ld	a5,48(a5)
    80001f58:	84be                	mv	s1,a5
  pop_off();
    80001f5a:	fffff097          	auipc	ra,0xfffff
    80001f5e:	e2e080e7          	jalr	-466(ra) # 80000d88 <pop_off>
  return p;
}
    80001f62:	8526                	mv	a0,s1
    80001f64:	60e2                	ld	ra,24(sp)
    80001f66:	6442                	ld	s0,16(sp)
    80001f68:	64a2                	ld	s1,8(sp)
    80001f6a:	6105                	addi	sp,sp,32
    80001f6c:	8082                	ret

0000000080001f6e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001f6e:	1141                	addi	sp,sp,-16
    80001f70:	e406                	sd	ra,8(sp)
    80001f72:	e022                	sd	s0,0(sp)
    80001f74:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001f76:	00000097          	auipc	ra,0x0
    80001f7a:	fbe080e7          	jalr	-66(ra) # 80001f34 <myproc>
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	e66080e7          	jalr	-410(ra) # 80000de4 <release>

  if (first) {
    80001f86:	0000b797          	auipc	a5,0xb
    80001f8a:	9da7a783          	lw	a5,-1574(a5) # 8000c960 <first.1>
    80001f8e:	eb89                	bnez	a5,80001fa0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001f90:	00001097          	auipc	ra,0x1
    80001f94:	168080e7          	jalr	360(ra) # 800030f8 <usertrapret>
}
    80001f98:	60a2                	ld	ra,8(sp)
    80001f9a:	6402                	ld	s0,0(sp)
    80001f9c:	0141                	addi	sp,sp,16
    80001f9e:	8082                	ret
    first = 0;
    80001fa0:	0000b797          	auipc	a5,0xb
    80001fa4:	9c07a023          	sw	zero,-1600(a5) # 8000c960 <first.1>
    fsinit(ROOTDEV);
    80001fa8:	4505                	li	a0,1
    80001faa:	00002097          	auipc	ra,0x2
    80001fae:	f92080e7          	jalr	-110(ra) # 80003f3c <fsinit>
    80001fb2:	bff9                	j	80001f90 <forkret+0x22>

0000000080001fb4 <allocpid>:
{
    80001fb4:	1101                	addi	sp,sp,-32
    80001fb6:	ec06                	sd	ra,24(sp)
    80001fb8:	e822                	sd	s0,16(sp)
    80001fba:	e426                	sd	s1,8(sp)
    80001fbc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001fbe:	00053517          	auipc	a0,0x53
    80001fc2:	c9250513          	addi	a0,a0,-878 # 80054c50 <pid_lock>
    80001fc6:	fffff097          	auipc	ra,0xfffff
    80001fca:	d6e080e7          	jalr	-658(ra) # 80000d34 <acquire>
  pid = nextpid;
    80001fce:	0000b797          	auipc	a5,0xb
    80001fd2:	99678793          	addi	a5,a5,-1642 # 8000c964 <nextpid>
    80001fd6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001fd8:	0014871b          	addiw	a4,s1,1
    80001fdc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001fde:	00053517          	auipc	a0,0x53
    80001fe2:	c7250513          	addi	a0,a0,-910 # 80054c50 <pid_lock>
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	dfe080e7          	jalr	-514(ra) # 80000de4 <release>
}
    80001fee:	8526                	mv	a0,s1
    80001ff0:	60e2                	ld	ra,24(sp)
    80001ff2:	6442                	ld	s0,16(sp)
    80001ff4:	64a2                	ld	s1,8(sp)
    80001ff6:	6105                	addi	sp,sp,32
    80001ff8:	8082                	ret

0000000080001ffa <proc_pagetable>:
{
    80001ffa:	1101                	addi	sp,sp,-32
    80001ffc:	ec06                	sd	ra,24(sp)
    80001ffe:	e822                	sd	s0,16(sp)
    80002000:	e426                	sd	s1,8(sp)
    80002002:	e04a                	sd	s2,0(sp)
    80002004:	1000                	addi	s0,sp,32
    80002006:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80002008:	fffff097          	auipc	ra,0xfffff
    8000200c:	57e080e7          	jalr	1406(ra) # 80001586 <uvmcreate>
    80002010:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80002012:	c121                	beqz	a0,80002052 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80002014:	4729                	li	a4,10
    80002016:	00006697          	auipc	a3,0x6
    8000201a:	fea68693          	addi	a3,a3,-22 # 80008000 <_trampoline>
    8000201e:	6605                	lui	a2,0x1
    80002020:	040005b7          	lui	a1,0x4000
    80002024:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002026:	05b2                	slli	a1,a1,0xc
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	2b2080e7          	jalr	690(ra) # 800012da <mappages>
    80002030:	02054863          	bltz	a0,80002060 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80002034:	4719                	li	a4,6
    80002036:	05893683          	ld	a3,88(s2)
    8000203a:	6605                	lui	a2,0x1
    8000203c:	020005b7          	lui	a1,0x2000
    80002040:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002042:	05b6                	slli	a1,a1,0xd
    80002044:	8526                	mv	a0,s1
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	294080e7          	jalr	660(ra) # 800012da <mappages>
    8000204e:	02054163          	bltz	a0,80002070 <proc_pagetable+0x76>
}
    80002052:	8526                	mv	a0,s1
    80002054:	60e2                	ld	ra,24(sp)
    80002056:	6442                	ld	s0,16(sp)
    80002058:	64a2                	ld	s1,8(sp)
    8000205a:	6902                	ld	s2,0(sp)
    8000205c:	6105                	addi	sp,sp,32
    8000205e:	8082                	ret
    uvmfree(pagetable, 0);
    80002060:	4581                	li	a1,0
    80002062:	8526                	mv	a0,s1
    80002064:	00000097          	auipc	ra,0x0
    80002068:	956080e7          	jalr	-1706(ra) # 800019ba <uvmfree>
    return 0;
    8000206c:	4481                	li	s1,0
    8000206e:	b7d5                	j	80002052 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002070:	4681                	li	a3,0
    80002072:	4605                	li	a2,1
    80002074:	040005b7          	lui	a1,0x4000
    80002078:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000207a:	05b2                	slli	a1,a1,0xc
    8000207c:	8526                	mv	a0,s1
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	434080e7          	jalr	1076(ra) # 800014b2 <uvmunmap>
    uvmfree(pagetable, 0);
    80002086:	4581                	li	a1,0
    80002088:	8526                	mv	a0,s1
    8000208a:	00000097          	auipc	ra,0x0
    8000208e:	930080e7          	jalr	-1744(ra) # 800019ba <uvmfree>
    return 0;
    80002092:	4481                	li	s1,0
    80002094:	bf7d                	j	80002052 <proc_pagetable+0x58>

0000000080002096 <proc_freepagetable>:
{
    80002096:	1101                	addi	sp,sp,-32
    80002098:	ec06                	sd	ra,24(sp)
    8000209a:	e822                	sd	s0,16(sp)
    8000209c:	e426                	sd	s1,8(sp)
    8000209e:	e04a                	sd	s2,0(sp)
    800020a0:	1000                	addi	s0,sp,32
    800020a2:	84aa                	mv	s1,a0
    800020a4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800020a6:	4681                	li	a3,0
    800020a8:	4605                	li	a2,1
    800020aa:	040005b7          	lui	a1,0x4000
    800020ae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800020b0:	05b2                	slli	a1,a1,0xc
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	400080e7          	jalr	1024(ra) # 800014b2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800020ba:	4681                	li	a3,0
    800020bc:	4605                	li	a2,1
    800020be:	020005b7          	lui	a1,0x2000
    800020c2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800020c4:	05b6                	slli	a1,a1,0xd
    800020c6:	8526                	mv	a0,s1
    800020c8:	fffff097          	auipc	ra,0xfffff
    800020cc:	3ea080e7          	jalr	1002(ra) # 800014b2 <uvmunmap>
  uvmfree(pagetable, sz);
    800020d0:	85ca                	mv	a1,s2
    800020d2:	8526                	mv	a0,s1
    800020d4:	00000097          	auipc	ra,0x0
    800020d8:	8e6080e7          	jalr	-1818(ra) # 800019ba <uvmfree>
}
    800020dc:	60e2                	ld	ra,24(sp)
    800020de:	6442                	ld	s0,16(sp)
    800020e0:	64a2                	ld	s1,8(sp)
    800020e2:	6902                	ld	s2,0(sp)
    800020e4:	6105                	addi	sp,sp,32
    800020e6:	8082                	ret

00000000800020e8 <freeproc>:
{
    800020e8:	1101                	addi	sp,sp,-32
    800020ea:	ec06                	sd	ra,24(sp)
    800020ec:	e822                	sd	s0,16(sp)
    800020ee:	e426                	sd	s1,8(sp)
    800020f0:	1000                	addi	s0,sp,32
    800020f2:	84aa                	mv	s1,a0
  if(p->trapframe)
    800020f4:	6d28                	ld	a0,88(a0)
    800020f6:	c509                	beqz	a0,80002100 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	9ac080e7          	jalr	-1620(ra) # 80000aa4 <kfree>
  p->trapframe = 0;
    80002100:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80002104:	68a8                	ld	a0,80(s1)
    80002106:	c511                	beqz	a0,80002112 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80002108:	64ac                	ld	a1,72(s1)
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	f8c080e7          	jalr	-116(ra) # 80002096 <proc_freepagetable>
  p->pagetable = 0;
    80002112:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80002116:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000211a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000211e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80002122:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80002126:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000212a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000212e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80002132:	0004ac23          	sw	zero,24(s1)
}
    80002136:	60e2                	ld	ra,24(sp)
    80002138:	6442                	ld	s0,16(sp)
    8000213a:	64a2                	ld	s1,8(sp)
    8000213c:	6105                	addi	sp,sp,32
    8000213e:	8082                	ret

0000000080002140 <allocproc>:
{
    80002140:	1101                	addi	sp,sp,-32
    80002142:	ec06                	sd	ra,24(sp)
    80002144:	e822                	sd	s0,16(sp)
    80002146:	e426                	sd	s1,8(sp)
    80002148:	e04a                	sd	s2,0(sp)
    8000214a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000214c:	00053497          	auipc	s1,0x53
    80002150:	f3448493          	addi	s1,s1,-204 # 80055080 <proc>
    80002154:	00061917          	auipc	s2,0x61
    80002158:	b2c90913          	addi	s2,s2,-1236 # 80062c80 <tickslock>
    acquire(&p->lock);
    8000215c:	8526                	mv	a0,s1
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	bd6080e7          	jalr	-1066(ra) # 80000d34 <acquire>
    if(p->state == UNUSED) {
    80002166:	4c9c                	lw	a5,24(s1)
    80002168:	cf81                	beqz	a5,80002180 <allocproc+0x40>
      release(&p->lock);
    8000216a:	8526                	mv	a0,s1
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	c78080e7          	jalr	-904(ra) # 80000de4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002174:	37048493          	addi	s1,s1,880
    80002178:	ff2492e3          	bne	s1,s2,8000215c <allocproc+0x1c>
  return 0;
    8000217c:	4481                	li	s1,0
    8000217e:	a095                	j	800021e2 <allocproc+0xa2>
  p->pid = allocpid();
    80002180:	00000097          	auipc	ra,0x0
    80002184:	e34080e7          	jalr	-460(ra) # 80001fb4 <allocpid>
    80002188:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000218a:	4785                	li	a5,1
    8000218c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	a84080e7          	jalr	-1404(ra) # 80000c12 <kalloc>
    80002196:	892a                	mv	s2,a0
    80002198:	eca8                	sd	a0,88(s1)
    8000219a:	c939                	beqz	a0,800021f0 <allocproc+0xb0>
  p->pagetable = proc_pagetable(p);
    8000219c:	8526                	mv	a0,s1
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	e5c080e7          	jalr	-420(ra) # 80001ffa <proc_pagetable>
    800021a6:	892a                	mv	s2,a0
    800021a8:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800021aa:	cd39                	beqz	a0,80002208 <allocproc+0xc8>
  memset(&p->context, 0, sizeof(p->context));
    800021ac:	07000613          	li	a2,112
    800021b0:	4581                	li	a1,0
    800021b2:	06048513          	addi	a0,s1,96
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	c76080e7          	jalr	-906(ra) # 80000e2c <memset>
  p->context.ra = (uint64)forkret;
    800021be:	00000797          	auipc	a5,0x0
    800021c2:	db078793          	addi	a5,a5,-592 # 80001f6e <forkret>
    800021c6:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800021c8:	60bc                	ld	a5,64(s1)
    800021ca:	6705                	lui	a4,0x1
    800021cc:	97ba                	add	a5,a5,a4
    800021ce:	f4bc                	sd	a5,104(s1)
  memset(p->infant_threads, 0, MAX_THREADS);
    800021d0:	04000613          	li	a2,64
    800021d4:	4581                	li	a1,0
    800021d6:	17048513          	addi	a0,s1,368
    800021da:	fffff097          	auipc	ra,0xfffff
    800021de:	c52080e7          	jalr	-942(ra) # 80000e2c <memset>
}
    800021e2:	8526                	mv	a0,s1
    800021e4:	60e2                	ld	ra,24(sp)
    800021e6:	6442                	ld	s0,16(sp)
    800021e8:	64a2                	ld	s1,8(sp)
    800021ea:	6902                	ld	s2,0(sp)
    800021ec:	6105                	addi	sp,sp,32
    800021ee:	8082                	ret
    freeproc(p);
    800021f0:	8526                	mv	a0,s1
    800021f2:	00000097          	auipc	ra,0x0
    800021f6:	ef6080e7          	jalr	-266(ra) # 800020e8 <freeproc>
    release(&p->lock);
    800021fa:	8526                	mv	a0,s1
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	be8080e7          	jalr	-1048(ra) # 80000de4 <release>
    return 0;
    80002204:	84ca                	mv	s1,s2
    80002206:	bff1                	j	800021e2 <allocproc+0xa2>
    freeproc(p);
    80002208:	8526                	mv	a0,s1
    8000220a:	00000097          	auipc	ra,0x0
    8000220e:	ede080e7          	jalr	-290(ra) # 800020e8 <freeproc>
    release(&p->lock);
    80002212:	8526                	mv	a0,s1
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	bd0080e7          	jalr	-1072(ra) # 80000de4 <release>
    return 0;
    8000221c:	84ca                	mv	s1,s2
    8000221e:	b7d1                	j	800021e2 <allocproc+0xa2>

0000000080002220 <userinit>:
{
    80002220:	1101                	addi	sp,sp,-32
    80002222:	ec06                	sd	ra,24(sp)
    80002224:	e822                	sd	s0,16(sp)
    80002226:	e426                	sd	s1,8(sp)
    80002228:	1000                	addi	s0,sp,32
  p = allocproc();
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	f16080e7          	jalr	-234(ra) # 80002140 <allocproc>
    80002232:	84aa                	mv	s1,a0
  initproc = p;
    80002234:	0000a797          	auipc	a5,0xa
    80002238:	7aa7b223          	sd	a0,1956(a5) # 8000c9d8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000223c:	03400613          	li	a2,52
    80002240:	0000a597          	auipc	a1,0xa
    80002244:	73058593          	addi	a1,a1,1840 # 8000c970 <initcode>
    80002248:	6928                	ld	a0,80(a0)
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	36a080e7          	jalr	874(ra) # 800015b4 <uvmfirst>
  p->sz = PGSIZE;
    80002252:	6785                	lui	a5,0x1
    80002254:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80002256:	6cb8                	ld	a4,88(s1)
    80002258:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000225c:	6cb8                	ld	a4,88(s1)
    8000225e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002260:	4641                	li	a2,16
    80002262:	00007597          	auipc	a1,0x7
    80002266:	02e58593          	addi	a1,a1,46 # 80009290 <etext+0x290>
    8000226a:	15848513          	addi	a0,s1,344
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	d16080e7          	jalr	-746(ra) # 80000f84 <safestrcpy>
  p->cwd = namei("/");
    80002276:	00007517          	auipc	a0,0x7
    8000227a:	02a50513          	addi	a0,a0,42 # 800092a0 <etext+0x2a0>
    8000227e:	00002097          	auipc	ra,0x2
    80002282:	72a080e7          	jalr	1834(ra) # 800049a8 <namei>
    80002286:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000228a:	478d                	li	a5,3
    8000228c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000228e:	8526                	mv	a0,s1
    80002290:	fffff097          	auipc	ra,0xfffff
    80002294:	b54080e7          	jalr	-1196(ra) # 80000de4 <release>
}
    80002298:	60e2                	ld	ra,24(sp)
    8000229a:	6442                	ld	s0,16(sp)
    8000229c:	64a2                	ld	s1,8(sp)
    8000229e:	6105                	addi	sp,sp,32
    800022a0:	8082                	ret

00000000800022a2 <growproc>:
{
    800022a2:	1101                	addi	sp,sp,-32
    800022a4:	ec06                	sd	ra,24(sp)
    800022a6:	e822                	sd	s0,16(sp)
    800022a8:	e426                	sd	s1,8(sp)
    800022aa:	e04a                	sd	s2,0(sp)
    800022ac:	1000                	addi	s0,sp,32
    800022ae:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800022b0:	00000097          	auipc	ra,0x0
    800022b4:	c84080e7          	jalr	-892(ra) # 80001f34 <myproc>
    800022b8:	84aa                	mv	s1,a0
  sz = p->sz;
    800022ba:	652c                	ld	a1,72(a0)
  if(n > 0){
    800022bc:	05205463          	blez	s2,80002304 <growproc+0x62>
    if (p->is_thread == 1) {
    800022c0:	16852703          	lw	a4,360(a0)
    800022c4:	4785                	li	a5,1
    800022c6:	02f70463          	beq	a4,a5,800022ee <growproc+0x4c>
    } else if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800022ca:	4691                	li	a3,4
    800022cc:	00b90633          	add	a2,s2,a1
    800022d0:	6928                	ld	a0,80(a0)
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	39c080e7          	jalr	924(ra) # 8000166e <uvmalloc>
    800022da:	85aa                	mv	a1,a0
    800022dc:	cd21                	beqz	a0,80002334 <growproc+0x92>
  p->sz = sz;
    800022de:	e4ac                	sd	a1,72(s1)
  return 0;
    800022e0:	4501                	li	a0,0
}
    800022e2:	60e2                	ld	ra,24(sp)
    800022e4:	6442                	ld	s0,16(sp)
    800022e6:	64a2                	ld	s1,8(sp)
    800022e8:	6902                	ld	s2,0(sp)
    800022ea:	6105                	addi	sp,sp,32
    800022ec:	8082                	ret
      if ((sz = uvmthreaded_alloc(p, sz, sz + n, PTE_W)) == 0) {
    800022ee:	4691                	li	a3,4
    800022f0:	00b90633          	add	a2,s2,a1
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	43c080e7          	jalr	1084(ra) # 80001730 <uvmthreaded_alloc>
    800022fc:	85aa                	mv	a1,a0
    800022fe:	f165                	bnez	a0,800022de <growproc+0x3c>
        return -1;
    80002300:	557d                	li	a0,-1
    80002302:	b7c5                	j	800022e2 <growproc+0x40>
  } else if(n < 0){
    80002304:	fc095de3          	bgez	s2,800022de <growproc+0x3c>
    if (p->is_thread == 1)
    80002308:	16852703          	lw	a4,360(a0)
    8000230c:	4785                	li	a5,1
    8000230e:	00f70b63          	beq	a4,a5,80002324 <growproc+0x82>
      sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002312:	00b90633          	add	a2,s2,a1
    80002316:	6928                	ld	a0,80(a0)
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	30e080e7          	jalr	782(ra) # 80001626 <uvmdealloc>
    80002320:	85aa                	mv	a1,a0
    80002322:	bf75                	j	800022de <growproc+0x3c>
      sz = uvmthreaded_dealloc(p, sz, sz + n);
    80002324:	00b90633          	add	a2,s2,a1
    80002328:	fffff097          	auipc	ra,0xfffff
    8000232c:	584080e7          	jalr	1412(ra) # 800018ac <uvmthreaded_dealloc>
    80002330:	85aa                	mv	a1,a0
    80002332:	b775                	j	800022de <growproc+0x3c>
      return -1;
    80002334:	557d                	li	a0,-1
    80002336:	b775                	j	800022e2 <growproc+0x40>

0000000080002338 <fork>:
{
    80002338:	7139                	addi	sp,sp,-64
    8000233a:	fc06                	sd	ra,56(sp)
    8000233c:	f822                	sd	s0,48(sp)
    8000233e:	f426                	sd	s1,40(sp)
    80002340:	e456                	sd	s5,8(sp)
    80002342:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002344:	00000097          	auipc	ra,0x0
    80002348:	bf0080e7          	jalr	-1040(ra) # 80001f34 <myproc>
    8000234c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000234e:	00000097          	auipc	ra,0x0
    80002352:	df2080e7          	jalr	-526(ra) # 80002140 <allocproc>
    80002356:	12050263          	beqz	a0,8000247a <fork+0x142>
    8000235a:	ec4e                	sd	s3,24(sp)
    8000235c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000235e:	048ab603          	ld	a2,72(s5)
    80002362:	692c                	ld	a1,80(a0)
    80002364:	050ab503          	ld	a0,80(s5)
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	68c080e7          	jalr	1676(ra) # 800019f4 <uvmcopy>
    80002370:	04054863          	bltz	a0,800023c0 <fork+0x88>
    80002374:	f04a                	sd	s2,32(sp)
    80002376:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80002378:	048ab783          	ld	a5,72(s5)
    8000237c:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80002380:	058ab683          	ld	a3,88(s5)
    80002384:	87b6                	mv	a5,a3
    80002386:	0589b703          	ld	a4,88(s3)
    8000238a:	12068693          	addi	a3,a3,288
    8000238e:	6388                	ld	a0,0(a5)
    80002390:	678c                	ld	a1,8(a5)
    80002392:	6b90                	ld	a2,16(a5)
    80002394:	e308                	sd	a0,0(a4)
    80002396:	e70c                	sd	a1,8(a4)
    80002398:	eb10                	sd	a2,16(a4)
    8000239a:	6f90                	ld	a2,24(a5)
    8000239c:	ef10                	sd	a2,24(a4)
    8000239e:	02078793          	addi	a5,a5,32 # 1020 <_entry-0x7fffefe0>
    800023a2:	02070713          	addi	a4,a4,32
    800023a6:	fed794e3          	bne	a5,a3,8000238e <fork+0x56>
  np->trapframe->a0 = 0;
    800023aa:	0589b783          	ld	a5,88(s3)
    800023ae:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800023b2:	0d0a8493          	addi	s1,s5,208
    800023b6:	0d098913          	addi	s2,s3,208
    800023ba:	150a8a13          	addi	s4,s5,336
    800023be:	a015                	j	800023e2 <fork+0xaa>
    freeproc(np);
    800023c0:	854e                	mv	a0,s3
    800023c2:	00000097          	auipc	ra,0x0
    800023c6:	d26080e7          	jalr	-730(ra) # 800020e8 <freeproc>
    release(&np->lock);
    800023ca:	854e                	mv	a0,s3
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	a18080e7          	jalr	-1512(ra) # 80000de4 <release>
    return -1;
    800023d4:	54fd                	li	s1,-1
    800023d6:	69e2                	ld	s3,24(sp)
    800023d8:	a851                	j	8000246c <fork+0x134>
  for(i = 0; i < NOFILE; i++)
    800023da:	04a1                	addi	s1,s1,8
    800023dc:	0921                	addi	s2,s2,8
    800023de:	01448b63          	beq	s1,s4,800023f4 <fork+0xbc>
    if(p->ofile[i])
    800023e2:	6088                	ld	a0,0(s1)
    800023e4:	d97d                	beqz	a0,800023da <fork+0xa2>
      np->ofile[i] = filedup(p->ofile[i]);
    800023e6:	00003097          	auipc	ra,0x3
    800023ea:	c58080e7          	jalr	-936(ra) # 8000503e <filedup>
    800023ee:	00a93023          	sd	a0,0(s2)
    800023f2:	b7e5                	j	800023da <fork+0xa2>
  np->cwd = idup(p->cwd);
    800023f4:	150ab503          	ld	a0,336(s5)
    800023f8:	00002097          	auipc	ra,0x2
    800023fc:	d88080e7          	jalr	-632(ra) # 80004180 <idup>
    80002400:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002404:	4641                	li	a2,16
    80002406:	158a8593          	addi	a1,s5,344
    8000240a:	15898513          	addi	a0,s3,344
    8000240e:	fffff097          	auipc	ra,0xfffff
    80002412:	b76080e7          	jalr	-1162(ra) # 80000f84 <safestrcpy>
  pid = np->pid;
    80002416:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    8000241a:	854e                	mv	a0,s3
    8000241c:	fffff097          	auipc	ra,0xfffff
    80002420:	9c8080e7          	jalr	-1592(ra) # 80000de4 <release>
  acquire(&wait_lock);
    80002424:	00053517          	auipc	a0,0x53
    80002428:	84450513          	addi	a0,a0,-1980 # 80054c68 <wait_lock>
    8000242c:	fffff097          	auipc	ra,0xfffff
    80002430:	908080e7          	jalr	-1784(ra) # 80000d34 <acquire>
  np->parent = p;
    80002434:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002438:	00053517          	auipc	a0,0x53
    8000243c:	83050513          	addi	a0,a0,-2000 # 80054c68 <wait_lock>
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	9a4080e7          	jalr	-1628(ra) # 80000de4 <release>
  acquire(&np->lock);
    80002448:	854e                	mv	a0,s3
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	8ea080e7          	jalr	-1814(ra) # 80000d34 <acquire>
  np->state = RUNNABLE;
    80002452:	478d                	li	a5,3
    80002454:	00f9ac23          	sw	a5,24(s3)
  np->is_thread = 0;
    80002458:	1609a423          	sw	zero,360(s3)
  release(&np->lock);
    8000245c:	854e                	mv	a0,s3
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	986080e7          	jalr	-1658(ra) # 80000de4 <release>
  return pid;
    80002466:	7902                	ld	s2,32(sp)
    80002468:	69e2                	ld	s3,24(sp)
    8000246a:	6a42                	ld	s4,16(sp)
}
    8000246c:	8526                	mv	a0,s1
    8000246e:	70e2                	ld	ra,56(sp)
    80002470:	7442                	ld	s0,48(sp)
    80002472:	74a2                	ld	s1,40(sp)
    80002474:	6aa2                	ld	s5,8(sp)
    80002476:	6121                	addi	sp,sp,64
    80002478:	8082                	ret
    return -1;
    8000247a:	54fd                	li	s1,-1
    8000247c:	bfc5                	j	8000246c <fork+0x134>

000000008000247e <create_thread>:
int create_thread(void* (*fn_addr)(void *), void *args, void *stack_addr, void (*exit_fn)(uint64)) {
    8000247e:	715d                	addi	sp,sp,-80
    80002480:	e486                	sd	ra,72(sp)
    80002482:	e0a2                	sd	s0,64(sp)
    80002484:	fc26                	sd	s1,56(sp)
    80002486:	f84a                	sd	s2,48(sp)
    80002488:	f44e                	sd	s3,40(sp)
    8000248a:	f052                	sd	s4,32(sp)
    8000248c:	ec56                	sd	s5,24(sp)
    8000248e:	e85a                	sd	s6,16(sp)
    80002490:	e45e                	sd	s7,8(sp)
    80002492:	e062                	sd	s8,0(sp)
    80002494:	0880                	addi	s0,sp,80
    80002496:	8baa                	mv	s7,a0
    80002498:	8c2e                	mv	s8,a1
    8000249a:	84b2                	mv	s1,a2
    8000249c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000249e:	00000097          	auipc	ra,0x0
    800024a2:	a96080e7          	jalr	-1386(ra) # 80001f34 <myproc>
    800024a6:	8aaa                	mv	s5,a0
  for (int i = 0; i < MAX_THREADS; i++) {
    800024a8:	89aa                	mv	s3,a0
    800024aa:	17050713          	addi	a4,a0,368
    800024ae:	4781                	li	a5,0
    800024b0:	04000693          	li	a3,64
    if (p->infant_threads[i] == 0) {
    800024b4:	00073803          	ld	a6,0(a4)
    800024b8:	00080863          	beqz	a6,800024c8 <create_thread+0x4a>
  for (int i = 0; i < MAX_THREADS; i++) {
    800024bc:	2785                	addiw	a5,a5,1
    800024be:	0721                	addi	a4,a4,8
    800024c0:	fed79ae3          	bne	a5,a3,800024b4 <create_thread+0x36>
  uint64 thread_idx = 0;
    800024c4:	4b01                	li	s6,0
    800024c6:	a011                	j	800024ca <create_thread+0x4c>
      thread_idx = i;
    800024c8:	8b3e                	mv	s6,a5
  if((np = allocproc()) == 0){
    800024ca:	00000097          	auipc	ra,0x0
    800024ce:	c76080e7          	jalr	-906(ra) # 80002140 <allocproc>
    800024d2:	8a2a                	mv	s4,a0
    800024d4:	cd2d                	beqz	a0,8000254e <create_thread+0xd0>
  if(uvmshare(p->pagetable, np->pagetable, p->sz) < 0){
    800024d6:	048ab603          	ld	a2,72(s5)
    800024da:	692c                	ld	a1,80(a0)
    800024dc:	050ab503          	ld	a0,80(s5)
    800024e0:	fffff097          	auipc	ra,0xfffff
    800024e4:	5e2080e7          	jalr	1506(ra) # 80001ac2 <uvmshare>
    800024e8:	06054d63          	bltz	a0,80002562 <create_thread+0xe4>
  np->sz = p->sz;
    800024ec:	048ab783          	ld	a5,72(s5)
    800024f0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800024f4:	058ab683          	ld	a3,88(s5)
    800024f8:	87b6                	mv	a5,a3
    800024fa:	058a3703          	ld	a4,88(s4)
    800024fe:	12068693          	addi	a3,a3,288
    80002502:	6388                	ld	a0,0(a5)
    80002504:	678c                	ld	a1,8(a5)
    80002506:	6b90                	ld	a2,16(a5)
    80002508:	e308                	sd	a0,0(a4)
    8000250a:	e70c                	sd	a1,8(a4)
    8000250c:	eb10                	sd	a2,16(a4)
    8000250e:	6f90                	ld	a2,24(a5)
    80002510:	ef10                	sd	a2,24(a4)
    80002512:	02078793          	addi	a5,a5,32
    80002516:	02070713          	addi	a4,a4,32
    8000251a:	fed794e3          	bne	a5,a3,80002502 <create_thread+0x84>
  np->trapframe->sp = (uint64)stack_addr + PGSIZE;
    8000251e:	058a3783          	ld	a5,88(s4)
    80002522:	6705                	lui	a4,0x1
    80002524:	94ba                	add	s1,s1,a4
    80002526:	fb84                	sd	s1,48(a5)
  np->trapframe->epc = (uint64)fn_addr;
    80002528:	058a3783          	ld	a5,88(s4)
    8000252c:	0177bc23          	sd	s7,24(a5)
  np->trapframe->a0 = (uint64)args;
    80002530:	058a3783          	ld	a5,88(s4)
    80002534:	0787b823          	sd	s8,112(a5)
  np->trapframe->ra = (uint64)exit_fn;
    80002538:	058a3783          	ld	a5,88(s4)
    8000253c:	0327b423          	sd	s2,40(a5)
  for(i = 0; i < NOFILE; i++)
    80002540:	0d098493          	addi	s1,s3,208
    80002544:	0d0a0913          	addi	s2,s4,208
    80002548:	15098993          	addi	s3,s3,336
    8000254c:	a81d                	j	80002582 <create_thread+0x104>
    printf("Max processes reached\n");
    8000254e:	00007517          	auipc	a0,0x7
    80002552:	d5a50513          	addi	a0,a0,-678 # 800092a8 <etext+0x2a8>
    80002556:	ffffe097          	auipc	ra,0xffffe
    8000255a:	052080e7          	jalr	82(ra) # 800005a8 <printf>
    return -1;
    8000255e:	557d                	li	a0,-1
    80002560:	a865                	j	80002618 <create_thread+0x19a>
    freeproc(np);
    80002562:	8552                	mv	a0,s4
    80002564:	00000097          	auipc	ra,0x0
    80002568:	b84080e7          	jalr	-1148(ra) # 800020e8 <freeproc>
    release(&np->lock);
    8000256c:	8552                	mv	a0,s4
    8000256e:	fffff097          	auipc	ra,0xfffff
    80002572:	876080e7          	jalr	-1930(ra) # 80000de4 <release>
    return -1;
    80002576:	557d                	li	a0,-1
    80002578:	a045                	j	80002618 <create_thread+0x19a>
  for(i = 0; i < NOFILE; i++)
    8000257a:	04a1                	addi	s1,s1,8
    8000257c:	0921                	addi	s2,s2,8
    8000257e:	01348b63          	beq	s1,s3,80002594 <create_thread+0x116>
    if(p->ofile[i])
    80002582:	6088                	ld	a0,0(s1)
    80002584:	d97d                	beqz	a0,8000257a <create_thread+0xfc>
      np->ofile[i] = filedup(p->ofile[i]);
    80002586:	00003097          	auipc	ra,0x3
    8000258a:	ab8080e7          	jalr	-1352(ra) # 8000503e <filedup>
    8000258e:	00a93023          	sd	a0,0(s2)
    80002592:	b7e5                	j	8000257a <create_thread+0xfc>
  np->cwd = idup(p->cwd);
    80002594:	150ab503          	ld	a0,336(s5)
    80002598:	00002097          	auipc	ra,0x2
    8000259c:	be8080e7          	jalr	-1048(ra) # 80004180 <idup>
    800025a0:	14aa3823          	sd	a0,336(s4)
  release(&np->lock);
    800025a4:	8552                	mv	a0,s4
    800025a6:	fffff097          	auipc	ra,0xfffff
    800025aa:	83e080e7          	jalr	-1986(ra) # 80000de4 <release>
  acquire(&wait_lock);
    800025ae:	00052517          	auipc	a0,0x52
    800025b2:	6ba50513          	addi	a0,a0,1722 # 80054c68 <wait_lock>
    800025b6:	ffffe097          	auipc	ra,0xffffe
    800025ba:	77e080e7          	jalr	1918(ra) # 80000d34 <acquire>
  if (p->is_thread) {
    800025be:	168aa783          	lw	a5,360(s5)
    800025c2:	c7bd                	beqz	a5,80002630 <create_thread+0x1b2>
    np->parent = p->parent->parent;
    800025c4:	038ab783          	ld	a5,56(s5)
    800025c8:	7f9c                	ld	a5,56(a5)
    800025ca:	02fa3c23          	sd	a5,56(s4)
    p = p->parent->parent;
    800025ce:	038ab783          	ld	a5,56(s5)
    800025d2:	0387ba83          	ld	s5,56(a5)
  release(&wait_lock);
    800025d6:	00052517          	auipc	a0,0x52
    800025da:	69250513          	addi	a0,a0,1682 # 80054c68 <wait_lock>
    800025de:	fffff097          	auipc	ra,0xfffff
    800025e2:	806080e7          	jalr	-2042(ra) # 80000de4 <release>
  acquire(&np->lock);
    800025e6:	8552                	mv	a0,s4
    800025e8:	ffffe097          	auipc	ra,0xffffe
    800025ec:	74c080e7          	jalr	1868(ra) # 80000d34 <acquire>
  np->is_thread = 1;
    800025f0:	4785                	li	a5,1
    800025f2:	16fa2423          	sw	a5,360(s4)
  np->state = RUNNABLE;
    800025f6:	478d                	li	a5,3
    800025f8:	00fa2c23          	sw	a5,24(s4)
  p->infant_threads[thread_idx] = np;
    800025fc:	003b1793          	slli	a5,s6,0x3
    80002600:	17078793          	addi	a5,a5,368
    80002604:	9abe                	add	s5,s5,a5
    80002606:	014ab023          	sd	s4,0(s5)
  release(&np->lock);
    8000260a:	8552                	mv	a0,s4
    8000260c:	ffffe097          	auipc	ra,0xffffe
    80002610:	7d8080e7          	jalr	2008(ra) # 80000de4 <release>
  return np->pid;
    80002614:	030a2503          	lw	a0,48(s4)
}
    80002618:	60a6                	ld	ra,72(sp)
    8000261a:	6406                	ld	s0,64(sp)
    8000261c:	74e2                	ld	s1,56(sp)
    8000261e:	7942                	ld	s2,48(sp)
    80002620:	79a2                	ld	s3,40(sp)
    80002622:	7a02                	ld	s4,32(sp)
    80002624:	6ae2                	ld	s5,24(sp)
    80002626:	6b42                	ld	s6,16(sp)
    80002628:	6ba2                	ld	s7,8(sp)
    8000262a:	6c02                	ld	s8,0(sp)
    8000262c:	6161                	addi	sp,sp,80
    8000262e:	8082                	ret
    np->parent = p;
    80002630:	035a3c23          	sd	s5,56(s4)
    80002634:	b74d                	j	800025d6 <create_thread+0x158>

0000000080002636 <scheduler>:
{
    80002636:	7139                	addi	sp,sp,-64
    80002638:	fc06                	sd	ra,56(sp)
    8000263a:	f822                	sd	s0,48(sp)
    8000263c:	f426                	sd	s1,40(sp)
    8000263e:	f04a                	sd	s2,32(sp)
    80002640:	ec4e                	sd	s3,24(sp)
    80002642:	e852                	sd	s4,16(sp)
    80002644:	e456                	sd	s5,8(sp)
    80002646:	e05a                	sd	s6,0(sp)
    80002648:	0080                	addi	s0,sp,64
    8000264a:	8792                	mv	a5,tp
  int id = r_tp();
    8000264c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000264e:	00779a93          	slli	s5,a5,0x7
    80002652:	00052717          	auipc	a4,0x52
    80002656:	5fe70713          	addi	a4,a4,1534 # 80054c50 <pid_lock>
    8000265a:	9756                	add	a4,a4,s5
    8000265c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002660:	00052717          	auipc	a4,0x52
    80002664:	62870713          	addi	a4,a4,1576 # 80054c88 <cpus+0x8>
    80002668:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000266a:	498d                	li	s3,3
        p->state = RUNNING;
    8000266c:	4b11                	li	s6,4
        c->proc = p;
    8000266e:	079e                	slli	a5,a5,0x7
    80002670:	00052a17          	auipc	s4,0x52
    80002674:	5e0a0a13          	addi	s4,s4,1504 # 80054c50 <pid_lock>
    80002678:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000267a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000267e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002682:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002686:	00053497          	auipc	s1,0x53
    8000268a:	9fa48493          	addi	s1,s1,-1542 # 80055080 <proc>
    8000268e:	00060917          	auipc	s2,0x60
    80002692:	5f290913          	addi	s2,s2,1522 # 80062c80 <tickslock>
    80002696:	a811                	j	800026aa <scheduler+0x74>
      release(&p->lock);
    80002698:	8526                	mv	a0,s1
    8000269a:	ffffe097          	auipc	ra,0xffffe
    8000269e:	74a080e7          	jalr	1866(ra) # 80000de4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800026a2:	37048493          	addi	s1,s1,880
    800026a6:	fd248ae3          	beq	s1,s2,8000267a <scheduler+0x44>
      acquire(&p->lock);
    800026aa:	8526                	mv	a0,s1
    800026ac:	ffffe097          	auipc	ra,0xffffe
    800026b0:	688080e7          	jalr	1672(ra) # 80000d34 <acquire>
      if(p->state == RUNNABLE) {
    800026b4:	4c9c                	lw	a5,24(s1)
    800026b6:	ff3791e3          	bne	a5,s3,80002698 <scheduler+0x62>
        p->state = RUNNING;
    800026ba:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800026be:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800026c2:	06048593          	addi	a1,s1,96
    800026c6:	8556                	mv	a0,s5
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	982080e7          	jalr	-1662(ra) # 8000304a <swtch>
        c->proc = 0;
    800026d0:	020a3823          	sd	zero,48(s4)
    800026d4:	b7d1                	j	80002698 <scheduler+0x62>

00000000800026d6 <sched>:
{
    800026d6:	7179                	addi	sp,sp,-48
    800026d8:	f406                	sd	ra,40(sp)
    800026da:	f022                	sd	s0,32(sp)
    800026dc:	ec26                	sd	s1,24(sp)
    800026de:	e84a                	sd	s2,16(sp)
    800026e0:	e44e                	sd	s3,8(sp)
    800026e2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800026e4:	00000097          	auipc	ra,0x0
    800026e8:	850080e7          	jalr	-1968(ra) # 80001f34 <myproc>
    800026ec:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800026ee:	ffffe097          	auipc	ra,0xffffe
    800026f2:	5c6080e7          	jalr	1478(ra) # 80000cb4 <holding>
    800026f6:	cd25                	beqz	a0,8000276e <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    800026f8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800026fa:	2781                	sext.w	a5,a5
    800026fc:	079e                	slli	a5,a5,0x7
    800026fe:	00052717          	auipc	a4,0x52
    80002702:	55270713          	addi	a4,a4,1362 # 80054c50 <pid_lock>
    80002706:	97ba                	add	a5,a5,a4
    80002708:	0a87a703          	lw	a4,168(a5)
    8000270c:	4785                	li	a5,1
    8000270e:	06f71863          	bne	a4,a5,8000277e <sched+0xa8>
  if(p->state == RUNNING)
    80002712:	4c98                	lw	a4,24(s1)
    80002714:	4791                	li	a5,4
    80002716:	06f70c63          	beq	a4,a5,8000278e <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000271a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000271e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002720:	efbd                	bnez	a5,8000279e <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002722:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002724:	00052917          	auipc	s2,0x52
    80002728:	52c90913          	addi	s2,s2,1324 # 80054c50 <pid_lock>
    8000272c:	2781                	sext.w	a5,a5
    8000272e:	079e                	slli	a5,a5,0x7
    80002730:	97ca                	add	a5,a5,s2
    80002732:	0ac7a983          	lw	s3,172(a5)
    80002736:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002738:	2781                	sext.w	a5,a5
    8000273a:	079e                	slli	a5,a5,0x7
    8000273c:	07a1                	addi	a5,a5,8
    8000273e:	00052597          	auipc	a1,0x52
    80002742:	54258593          	addi	a1,a1,1346 # 80054c80 <cpus>
    80002746:	95be                	add	a1,a1,a5
    80002748:	06048513          	addi	a0,s1,96
    8000274c:	00001097          	auipc	ra,0x1
    80002750:	8fe080e7          	jalr	-1794(ra) # 8000304a <swtch>
    80002754:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002756:	2781                	sext.w	a5,a5
    80002758:	079e                	slli	a5,a5,0x7
    8000275a:	993e                	add	s2,s2,a5
    8000275c:	0b392623          	sw	s3,172(s2)
}
    80002760:	70a2                	ld	ra,40(sp)
    80002762:	7402                	ld	s0,32(sp)
    80002764:	64e2                	ld	s1,24(sp)
    80002766:	6942                	ld	s2,16(sp)
    80002768:	69a2                	ld	s3,8(sp)
    8000276a:	6145                	addi	sp,sp,48
    8000276c:	8082                	ret
    panic("sched p->lock");
    8000276e:	00007517          	auipc	a0,0x7
    80002772:	b5250513          	addi	a0,a0,-1198 # 800092c0 <etext+0x2c0>
    80002776:	ffffe097          	auipc	ra,0xffffe
    8000277a:	de8080e7          	jalr	-536(ra) # 8000055e <panic>
    panic("sched locks");
    8000277e:	00007517          	auipc	a0,0x7
    80002782:	b5250513          	addi	a0,a0,-1198 # 800092d0 <etext+0x2d0>
    80002786:	ffffe097          	auipc	ra,0xffffe
    8000278a:	dd8080e7          	jalr	-552(ra) # 8000055e <panic>
    panic("sched running");
    8000278e:	00007517          	auipc	a0,0x7
    80002792:	b5250513          	addi	a0,a0,-1198 # 800092e0 <etext+0x2e0>
    80002796:	ffffe097          	auipc	ra,0xffffe
    8000279a:	dc8080e7          	jalr	-568(ra) # 8000055e <panic>
    panic("sched interruptible");
    8000279e:	00007517          	auipc	a0,0x7
    800027a2:	b5250513          	addi	a0,a0,-1198 # 800092f0 <etext+0x2f0>
    800027a6:	ffffe097          	auipc	ra,0xffffe
    800027aa:	db8080e7          	jalr	-584(ra) # 8000055e <panic>

00000000800027ae <yield>:
{
    800027ae:	1101                	addi	sp,sp,-32
    800027b0:	ec06                	sd	ra,24(sp)
    800027b2:	e822                	sd	s0,16(sp)
    800027b4:	e426                	sd	s1,8(sp)
    800027b6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800027b8:	fffff097          	auipc	ra,0xfffff
    800027bc:	77c080e7          	jalr	1916(ra) # 80001f34 <myproc>
    800027c0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800027c2:	ffffe097          	auipc	ra,0xffffe
    800027c6:	572080e7          	jalr	1394(ra) # 80000d34 <acquire>
  p->state = RUNNABLE;
    800027ca:	478d                	li	a5,3
    800027cc:	cc9c                	sw	a5,24(s1)
  sched();
    800027ce:	00000097          	auipc	ra,0x0
    800027d2:	f08080e7          	jalr	-248(ra) # 800026d6 <sched>
  release(&p->lock);
    800027d6:	8526                	mv	a0,s1
    800027d8:	ffffe097          	auipc	ra,0xffffe
    800027dc:	60c080e7          	jalr	1548(ra) # 80000de4 <release>
}
    800027e0:	60e2                	ld	ra,24(sp)
    800027e2:	6442                	ld	s0,16(sp)
    800027e4:	64a2                	ld	s1,8(sp)
    800027e6:	6105                	addi	sp,sp,32
    800027e8:	8082                	ret

00000000800027ea <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800027ea:	7179                	addi	sp,sp,-48
    800027ec:	f406                	sd	ra,40(sp)
    800027ee:	f022                	sd	s0,32(sp)
    800027f0:	ec26                	sd	s1,24(sp)
    800027f2:	e84a                	sd	s2,16(sp)
    800027f4:	e44e                	sd	s3,8(sp)
    800027f6:	1800                	addi	s0,sp,48
    800027f8:	89aa                	mv	s3,a0
    800027fa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027fc:	fffff097          	auipc	ra,0xfffff
    80002800:	738080e7          	jalr	1848(ra) # 80001f34 <myproc>
    80002804:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002806:	ffffe097          	auipc	ra,0xffffe
    8000280a:	52e080e7          	jalr	1326(ra) # 80000d34 <acquire>
  release(lk);
    8000280e:	854a                	mv	a0,s2
    80002810:	ffffe097          	auipc	ra,0xffffe
    80002814:	5d4080e7          	jalr	1492(ra) # 80000de4 <release>

  // Go to sleep.
  p->chan = chan;
    80002818:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000281c:	4789                	li	a5,2
    8000281e:	cc9c                	sw	a5,24(s1)

  sched();
    80002820:	00000097          	auipc	ra,0x0
    80002824:	eb6080e7          	jalr	-330(ra) # 800026d6 <sched>

  // Tidy up.
  p->chan = 0;
    80002828:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000282c:	8526                	mv	a0,s1
    8000282e:	ffffe097          	auipc	ra,0xffffe
    80002832:	5b6080e7          	jalr	1462(ra) # 80000de4 <release>
  acquire(lk);
    80002836:	854a                	mv	a0,s2
    80002838:	ffffe097          	auipc	ra,0xffffe
    8000283c:	4fc080e7          	jalr	1276(ra) # 80000d34 <acquire>
}
    80002840:	70a2                	ld	ra,40(sp)
    80002842:	7402                	ld	s0,32(sp)
    80002844:	64e2                	ld	s1,24(sp)
    80002846:	6942                	ld	s2,16(sp)
    80002848:	69a2                	ld	s3,8(sp)
    8000284a:	6145                	addi	sp,sp,48
    8000284c:	8082                	ret

000000008000284e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000284e:	7139                	addi	sp,sp,-64
    80002850:	fc06                	sd	ra,56(sp)
    80002852:	f822                	sd	s0,48(sp)
    80002854:	f426                	sd	s1,40(sp)
    80002856:	f04a                	sd	s2,32(sp)
    80002858:	ec4e                	sd	s3,24(sp)
    8000285a:	e852                	sd	s4,16(sp)
    8000285c:	e456                	sd	s5,8(sp)
    8000285e:	0080                	addi	s0,sp,64
    80002860:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002862:	00053497          	auipc	s1,0x53
    80002866:	81e48493          	addi	s1,s1,-2018 # 80055080 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000286a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000286c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000286e:	00060917          	auipc	s2,0x60
    80002872:	41290913          	addi	s2,s2,1042 # 80062c80 <tickslock>
    80002876:	a811                	j	8000288a <wakeup+0x3c>
      }
      release(&p->lock);
    80002878:	8526                	mv	a0,s1
    8000287a:	ffffe097          	auipc	ra,0xffffe
    8000287e:	56a080e7          	jalr	1386(ra) # 80000de4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002882:	37048493          	addi	s1,s1,880
    80002886:	03248663          	beq	s1,s2,800028b2 <wakeup+0x64>
    if(p != myproc()){
    8000288a:	fffff097          	auipc	ra,0xfffff
    8000288e:	6aa080e7          	jalr	1706(ra) # 80001f34 <myproc>
    80002892:	fe9508e3          	beq	a0,s1,80002882 <wakeup+0x34>
      acquire(&p->lock);
    80002896:	8526                	mv	a0,s1
    80002898:	ffffe097          	auipc	ra,0xffffe
    8000289c:	49c080e7          	jalr	1180(ra) # 80000d34 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800028a0:	4c9c                	lw	a5,24(s1)
    800028a2:	fd379be3          	bne	a5,s3,80002878 <wakeup+0x2a>
    800028a6:	709c                	ld	a5,32(s1)
    800028a8:	fd4798e3          	bne	a5,s4,80002878 <wakeup+0x2a>
        p->state = RUNNABLE;
    800028ac:	0154ac23          	sw	s5,24(s1)
    800028b0:	b7e1                	j	80002878 <wakeup+0x2a>
    }
  }
}
    800028b2:	70e2                	ld	ra,56(sp)
    800028b4:	7442                	ld	s0,48(sp)
    800028b6:	74a2                	ld	s1,40(sp)
    800028b8:	7902                	ld	s2,32(sp)
    800028ba:	69e2                	ld	s3,24(sp)
    800028bc:	6a42                	ld	s4,16(sp)
    800028be:	6aa2                	ld	s5,8(sp)
    800028c0:	6121                	addi	sp,sp,64
    800028c2:	8082                	ret

00000000800028c4 <reparent>:
{
    800028c4:	7179                	addi	sp,sp,-48
    800028c6:	f406                	sd	ra,40(sp)
    800028c8:	f022                	sd	s0,32(sp)
    800028ca:	ec26                	sd	s1,24(sp)
    800028cc:	e84a                	sd	s2,16(sp)
    800028ce:	e44e                	sd	s3,8(sp)
    800028d0:	e052                	sd	s4,0(sp)
    800028d2:	1800                	addi	s0,sp,48
    800028d4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800028d6:	00052497          	auipc	s1,0x52
    800028da:	7aa48493          	addi	s1,s1,1962 # 80055080 <proc>
      pp->parent = initproc;
    800028de:	0000aa17          	auipc	s4,0xa
    800028e2:	0faa0a13          	addi	s4,s4,250 # 8000c9d8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800028e6:	00060997          	auipc	s3,0x60
    800028ea:	39a98993          	addi	s3,s3,922 # 80062c80 <tickslock>
    800028ee:	a029                	j	800028f8 <reparent+0x34>
    800028f0:	37048493          	addi	s1,s1,880
    800028f4:	01348d63          	beq	s1,s3,8000290e <reparent+0x4a>
    if(pp->parent == p){
    800028f8:	7c9c                	ld	a5,56(s1)
    800028fa:	ff279be3          	bne	a5,s2,800028f0 <reparent+0x2c>
      pp->parent = initproc;
    800028fe:	000a3503          	ld	a0,0(s4)
    80002902:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002904:	00000097          	auipc	ra,0x0
    80002908:	f4a080e7          	jalr	-182(ra) # 8000284e <wakeup>
    8000290c:	b7d5                	j	800028f0 <reparent+0x2c>
}
    8000290e:	70a2                	ld	ra,40(sp)
    80002910:	7402                	ld	s0,32(sp)
    80002912:	64e2                	ld	s1,24(sp)
    80002914:	6942                	ld	s2,16(sp)
    80002916:	69a2                	ld	s3,8(sp)
    80002918:	6a02                	ld	s4,0(sp)
    8000291a:	6145                	addi	sp,sp,48
    8000291c:	8082                	ret

000000008000291e <thread_exit>:
uint64 thread_exit(uint64 status) {
    8000291e:	7179                	addi	sp,sp,-48
    80002920:	f406                	sd	ra,40(sp)
    80002922:	f022                	sd	s0,32(sp)
    80002924:	ec26                	sd	s1,24(sp)
    80002926:	e84a                	sd	s2,16(sp)
    80002928:	e44e                	sd	s3,8(sp)
    8000292a:	e052                	sd	s4,0(sp)
    8000292c:	1800                	addi	s0,sp,48
    8000292e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002930:	fffff097          	auipc	ra,0xfffff
    80002934:	604080e7          	jalr	1540(ra) # 80001f34 <myproc>
    80002938:	89aa                	mv	s3,a0
  if(p == initproc)
    8000293a:	0000a797          	auipc	a5,0xa
    8000293e:	09e7b783          	ld	a5,158(a5) # 8000c9d8 <initproc>
    80002942:	0d050493          	addi	s1,a0,208
    80002946:	15050913          	addi	s2,a0,336
    8000294a:	00a79d63          	bne	a5,a0,80002964 <thread_exit+0x46>
    panic("init exiting");
    8000294e:	00007517          	auipc	a0,0x7
    80002952:	9ba50513          	addi	a0,a0,-1606 # 80009308 <etext+0x308>
    80002956:	ffffe097          	auipc	ra,0xffffe
    8000295a:	c08080e7          	jalr	-1016(ra) # 8000055e <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000295e:	04a1                	addi	s1,s1,8
    80002960:	01248b63          	beq	s1,s2,80002976 <thread_exit+0x58>
    if(p->ofile[fd]){
    80002964:	6088                	ld	a0,0(s1)
    80002966:	dd65                	beqz	a0,8000295e <thread_exit+0x40>
      fileclose(f);
    80002968:	00002097          	auipc	ra,0x2
    8000296c:	728080e7          	jalr	1832(ra) # 80005090 <fileclose>
      p->ofile[fd] = 0;
    80002970:	0004b023          	sd	zero,0(s1)
    80002974:	b7ed                	j	8000295e <thread_exit+0x40>
  begin_op();
    80002976:	00002097          	auipc	ra,0x2
    8000297a:	238080e7          	jalr	568(ra) # 80004bae <begin_op>
  iput(p->cwd);
    8000297e:	1509b503          	ld	a0,336(s3)
    80002982:	00002097          	auipc	ra,0x2
    80002986:	9fa080e7          	jalr	-1542(ra) # 8000437c <iput>
  end_op();
    8000298a:	00002097          	auipc	ra,0x2
    8000298e:	2a4080e7          	jalr	676(ra) # 80004c2e <end_op>
  p->cwd = 0;
    80002992:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002996:	00052517          	auipc	a0,0x52
    8000299a:	2d250513          	addi	a0,a0,722 # 80054c68 <wait_lock>
    8000299e:	ffffe097          	auipc	ra,0xffffe
    800029a2:	396080e7          	jalr	918(ra) # 80000d34 <acquire>
  reparent(p);
    800029a6:	854e                	mv	a0,s3
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	f1c080e7          	jalr	-228(ra) # 800028c4 <reparent>
  wakeup(p->parent);
    800029b0:	0389b503          	ld	a0,56(s3)
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	e9a080e7          	jalr	-358(ra) # 8000284e <wakeup>
  acquire(&p->lock);
    800029bc:	854e                	mv	a0,s3
    800029be:	ffffe097          	auipc	ra,0xffffe
    800029c2:	376080e7          	jalr	886(ra) # 80000d34 <acquire>
  p->xstate = status;
    800029c6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800029ca:	4795                	li	a5,5
    800029cc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800029d0:	00052517          	auipc	a0,0x52
    800029d4:	29850513          	addi	a0,a0,664 # 80054c68 <wait_lock>
    800029d8:	ffffe097          	auipc	ra,0xffffe
    800029dc:	40c080e7          	jalr	1036(ra) # 80000de4 <release>
  sched();
    800029e0:	00000097          	auipc	ra,0x0
    800029e4:	cf6080e7          	jalr	-778(ra) # 800026d6 <sched>
  panic("zombie exit");
    800029e8:	00007517          	auipc	a0,0x7
    800029ec:	93050513          	addi	a0,a0,-1744 # 80009318 <etext+0x318>
    800029f0:	ffffe097          	auipc	ra,0xffffe
    800029f4:	b6e080e7          	jalr	-1170(ra) # 8000055e <panic>

00000000800029f8 <exit>:
{
    800029f8:	715d                	addi	sp,sp,-80
    800029fa:	e486                	sd	ra,72(sp)
    800029fc:	e0a2                	sd	s0,64(sp)
    800029fe:	fc26                	sd	s1,56(sp)
    80002a00:	f84a                	sd	s2,48(sp)
    80002a02:	f44e                	sd	s3,40(sp)
    80002a04:	f052                	sd	s4,32(sp)
    80002a06:	ec56                	sd	s5,24(sp)
    80002a08:	e85a                	sd	s6,16(sp)
    80002a0a:	e45e                	sd	s7,8(sp)
    80002a0c:	e062                	sd	s8,0(sp)
    80002a0e:	0880                	addi	s0,sp,80
    80002a10:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002a12:	fffff097          	auipc	ra,0xfffff
    80002a16:	522080e7          	jalr	1314(ra) # 80001f34 <myproc>
    80002a1a:	89aa                	mv	s3,a0
  if (p->is_thread) {
    80002a1c:	16852783          	lw	a5,360(a0)
    80002a20:	e39d                	bnez	a5,80002a46 <exit+0x4e>
  if(p == initproc)
    80002a22:	0000a797          	auipc	a5,0xa
    80002a26:	fb67b783          	ld	a5,-74(a5) # 8000c9d8 <initproc>
    80002a2a:	0d050493          	addi	s1,a0,208
    80002a2e:	15050913          	addi	s2,a0,336
    80002a32:	0aa79963          	bne	a5,a0,80002ae4 <exit+0xec>
    panic("init exiting");
    80002a36:	00007517          	auipc	a0,0x7
    80002a3a:	8d250513          	addi	a0,a0,-1838 # 80009308 <etext+0x308>
    80002a3e:	ffffe097          	auipc	ra,0xffffe
    80002a42:	b20080e7          	jalr	-1248(ra) # 8000055e <panic>
    for (int i = 0; i < MAX_THREADS; i++) {
    80002a46:	03853b03          	ld	s6,56(a0)
    80002a4a:	170b0a13          	addi	s4,s6,368
    80002a4e:	370b0b13          	addi	s6,s6,880
      acquire(&wait_lock);
    80002a52:	00052a97          	auipc	s5,0x52
    80002a56:	216a8a93          	addi	s5,s5,534 # 80054c68 <wait_lock>
      infant->state = ZOMBIE;
    80002a5a:	4c15                	li	s8,5
    80002a5c:	a885                	j	80002acc <exit+0xd4>
      for(int fd = 0; fd < NOFILE; fd++){
    80002a5e:	04a1                	addi	s1,s1,8
    80002a60:	01248b63          	beq	s1,s2,80002a76 <exit+0x7e>
        if(infant->ofile[fd]){
    80002a64:	6088                	ld	a0,0(s1)
    80002a66:	dd65                	beqz	a0,80002a5e <exit+0x66>
          fileclose(f);
    80002a68:	00002097          	auipc	ra,0x2
    80002a6c:	628080e7          	jalr	1576(ra) # 80005090 <fileclose>
          infant->ofile[fd] = 0;
    80002a70:	0004b023          	sd	zero,0(s1)
    80002a74:	b7ed                	j	80002a5e <exit+0x66>
      begin_op();
    80002a76:	00002097          	auipc	ra,0x2
    80002a7a:	138080e7          	jalr	312(ra) # 80004bae <begin_op>
      iput(infant->cwd);
    80002a7e:	1509b503          	ld	a0,336(s3)
    80002a82:	00002097          	auipc	ra,0x2
    80002a86:	8fa080e7          	jalr	-1798(ra) # 8000437c <iput>
      end_op();
    80002a8a:	00002097          	auipc	ra,0x2
    80002a8e:	1a4080e7          	jalr	420(ra) # 80004c2e <end_op>
      infant->cwd = 0;
    80002a92:	1409b823          	sd	zero,336(s3)
      acquire(&wait_lock);
    80002a96:	8556                	mv	a0,s5
    80002a98:	ffffe097          	auipc	ra,0xffffe
    80002a9c:	29c080e7          	jalr	668(ra) # 80000d34 <acquire>
      acquire(&infant->lock);
    80002aa0:	854e                	mv	a0,s3
    80002aa2:	ffffe097          	auipc	ra,0xffffe
    80002aa6:	292080e7          	jalr	658(ra) # 80000d34 <acquire>
      infant->xstate = status;
    80002aaa:	0379a623          	sw	s7,44(s3)
      infant->state = ZOMBIE;
    80002aae:	0189ac23          	sw	s8,24(s3)
      release(&infant->lock);
    80002ab2:	854e                	mv	a0,s3
    80002ab4:	ffffe097          	auipc	ra,0xffffe
    80002ab8:	330080e7          	jalr	816(ra) # 80000de4 <release>
      release(&wait_lock);
    80002abc:	8556                	mv	a0,s5
    80002abe:	ffffe097          	auipc	ra,0xffffe
    80002ac2:	326080e7          	jalr	806(ra) # 80000de4 <release>
    for (int i = 0; i < MAX_THREADS; i++) {
    80002ac6:	0a21                	addi	s4,s4,8
    80002ac8:	0b6a0863          	beq	s4,s6,80002b78 <exit+0x180>
      struct proc *infant = parent->infant_threads[i];
    80002acc:	000a3983          	ld	s3,0(s4)
      if (infant == 0) 
    80002ad0:	fe098be3          	beqz	s3,80002ac6 <exit+0xce>
    80002ad4:	0d098493          	addi	s1,s3,208
    80002ad8:	15098913          	addi	s2,s3,336
    80002adc:	b761                	j	80002a64 <exit+0x6c>
  for(int fd = 0; fd < NOFILE; fd++){
    80002ade:	04a1                	addi	s1,s1,8
    80002ae0:	01248b63          	beq	s1,s2,80002af6 <exit+0xfe>
    if(p->ofile[fd]){
    80002ae4:	6088                	ld	a0,0(s1)
    80002ae6:	dd65                	beqz	a0,80002ade <exit+0xe6>
      fileclose(f);
    80002ae8:	00002097          	auipc	ra,0x2
    80002aec:	5a8080e7          	jalr	1448(ra) # 80005090 <fileclose>
      p->ofile[fd] = 0;
    80002af0:	0004b023          	sd	zero,0(s1)
    80002af4:	b7ed                	j	80002ade <exit+0xe6>
  begin_op();
    80002af6:	00002097          	auipc	ra,0x2
    80002afa:	0b8080e7          	jalr	184(ra) # 80004bae <begin_op>
  iput(p->cwd);
    80002afe:	1509b503          	ld	a0,336(s3)
    80002b02:	00002097          	auipc	ra,0x2
    80002b06:	87a080e7          	jalr	-1926(ra) # 8000437c <iput>
  end_op();
    80002b0a:	00002097          	auipc	ra,0x2
    80002b0e:	124080e7          	jalr	292(ra) # 80004c2e <end_op>
  p->cwd = 0;
    80002b12:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002b16:	00052517          	auipc	a0,0x52
    80002b1a:	15250513          	addi	a0,a0,338 # 80054c68 <wait_lock>
    80002b1e:	ffffe097          	auipc	ra,0xffffe
    80002b22:	216080e7          	jalr	534(ra) # 80000d34 <acquire>
  reparent(p);
    80002b26:	854e                	mv	a0,s3
    80002b28:	00000097          	auipc	ra,0x0
    80002b2c:	d9c080e7          	jalr	-612(ra) # 800028c4 <reparent>
  wakeup(p->parent);
    80002b30:	0389b503          	ld	a0,56(s3)
    80002b34:	00000097          	auipc	ra,0x0
    80002b38:	d1a080e7          	jalr	-742(ra) # 8000284e <wakeup>
  acquire(&p->lock);
    80002b3c:	854e                	mv	a0,s3
    80002b3e:	ffffe097          	auipc	ra,0xffffe
    80002b42:	1f6080e7          	jalr	502(ra) # 80000d34 <acquire>
  p->xstate = status;
    80002b46:	0379a623          	sw	s7,44(s3)
  p->state = ZOMBIE;
    80002b4a:	4795                	li	a5,5
    80002b4c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002b50:	00052517          	auipc	a0,0x52
    80002b54:	11850513          	addi	a0,a0,280 # 80054c68 <wait_lock>
    80002b58:	ffffe097          	auipc	ra,0xffffe
    80002b5c:	28c080e7          	jalr	652(ra) # 80000de4 <release>
  sched();
    80002b60:	00000097          	auipc	ra,0x0
    80002b64:	b76080e7          	jalr	-1162(ra) # 800026d6 <sched>
  panic("zombie exit");
    80002b68:	00006517          	auipc	a0,0x6
    80002b6c:	7b050513          	addi	a0,a0,1968 # 80009318 <etext+0x318>
    80002b70:	ffffe097          	auipc	ra,0xffffe
    80002b74:	9ee080e7          	jalr	-1554(ra) # 8000055e <panic>
}
    80002b78:	60a6                	ld	ra,72(sp)
    80002b7a:	6406                	ld	s0,64(sp)
    80002b7c:	74e2                	ld	s1,56(sp)
    80002b7e:	7942                	ld	s2,48(sp)
    80002b80:	79a2                	ld	s3,40(sp)
    80002b82:	7a02                	ld	s4,32(sp)
    80002b84:	6ae2                	ld	s5,24(sp)
    80002b86:	6b42                	ld	s6,16(sp)
    80002b88:	6ba2                	ld	s7,8(sp)
    80002b8a:	6c02                	ld	s8,0(sp)
    80002b8c:	6161                	addi	sp,sp,80
    80002b8e:	8082                	ret

0000000080002b90 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002b90:	7179                	addi	sp,sp,-48
    80002b92:	f406                	sd	ra,40(sp)
    80002b94:	f022                	sd	s0,32(sp)
    80002b96:	ec26                	sd	s1,24(sp)
    80002b98:	e84a                	sd	s2,16(sp)
    80002b9a:	e44e                	sd	s3,8(sp)
    80002b9c:	1800                	addi	s0,sp,48
    80002b9e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002ba0:	00052497          	auipc	s1,0x52
    80002ba4:	4e048493          	addi	s1,s1,1248 # 80055080 <proc>
    80002ba8:	00060997          	auipc	s3,0x60
    80002bac:	0d898993          	addi	s3,s3,216 # 80062c80 <tickslock>
    acquire(&p->lock);
    80002bb0:	8526                	mv	a0,s1
    80002bb2:	ffffe097          	auipc	ra,0xffffe
    80002bb6:	182080e7          	jalr	386(ra) # 80000d34 <acquire>
    if(p->pid == pid){
    80002bba:	589c                	lw	a5,48(s1)
    80002bbc:	01278d63          	beq	a5,s2,80002bd6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002bc0:	8526                	mv	a0,s1
    80002bc2:	ffffe097          	auipc	ra,0xffffe
    80002bc6:	222080e7          	jalr	546(ra) # 80000de4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002bca:	37048493          	addi	s1,s1,880
    80002bce:	ff3491e3          	bne	s1,s3,80002bb0 <kill+0x20>
  }
  return -1;
    80002bd2:	557d                	li	a0,-1
    80002bd4:	a829                	j	80002bee <kill+0x5e>
      p->killed = 1;
    80002bd6:	4785                	li	a5,1
    80002bd8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002bda:	4c98                	lw	a4,24(s1)
    80002bdc:	4789                	li	a5,2
    80002bde:	00f70f63          	beq	a4,a5,80002bfc <kill+0x6c>
      release(&p->lock);
    80002be2:	8526                	mv	a0,s1
    80002be4:	ffffe097          	auipc	ra,0xffffe
    80002be8:	200080e7          	jalr	512(ra) # 80000de4 <release>
      return 0;
    80002bec:	4501                	li	a0,0
}
    80002bee:	70a2                	ld	ra,40(sp)
    80002bf0:	7402                	ld	s0,32(sp)
    80002bf2:	64e2                	ld	s1,24(sp)
    80002bf4:	6942                	ld	s2,16(sp)
    80002bf6:	69a2                	ld	s3,8(sp)
    80002bf8:	6145                	addi	sp,sp,48
    80002bfa:	8082                	ret
        p->state = RUNNABLE;
    80002bfc:	478d                	li	a5,3
    80002bfe:	cc9c                	sw	a5,24(s1)
    80002c00:	b7cd                	j	80002be2 <kill+0x52>

0000000080002c02 <setkilled>:

void
setkilled(struct proc *p)
{
    80002c02:	1101                	addi	sp,sp,-32
    80002c04:	ec06                	sd	ra,24(sp)
    80002c06:	e822                	sd	s0,16(sp)
    80002c08:	e426                	sd	s1,8(sp)
    80002c0a:	1000                	addi	s0,sp,32
    80002c0c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002c0e:	ffffe097          	auipc	ra,0xffffe
    80002c12:	126080e7          	jalr	294(ra) # 80000d34 <acquire>
  p->killed = 1;
    80002c16:	4785                	li	a5,1
    80002c18:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002c1a:	8526                	mv	a0,s1
    80002c1c:	ffffe097          	auipc	ra,0xffffe
    80002c20:	1c8080e7          	jalr	456(ra) # 80000de4 <release>
}
    80002c24:	60e2                	ld	ra,24(sp)
    80002c26:	6442                	ld	s0,16(sp)
    80002c28:	64a2                	ld	s1,8(sp)
    80002c2a:	6105                	addi	sp,sp,32
    80002c2c:	8082                	ret

0000000080002c2e <killed>:

int
killed(struct proc *p)
{
    80002c2e:	1101                	addi	sp,sp,-32
    80002c30:	ec06                	sd	ra,24(sp)
    80002c32:	e822                	sd	s0,16(sp)
    80002c34:	e426                	sd	s1,8(sp)
    80002c36:	e04a                	sd	s2,0(sp)
    80002c38:	1000                	addi	s0,sp,32
    80002c3a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002c3c:	ffffe097          	auipc	ra,0xffffe
    80002c40:	0f8080e7          	jalr	248(ra) # 80000d34 <acquire>
  k = p->killed;
    80002c44:	549c                	lw	a5,40(s1)
    80002c46:	893e                	mv	s2,a5
  release(&p->lock);
    80002c48:	8526                	mv	a0,s1
    80002c4a:	ffffe097          	auipc	ra,0xffffe
    80002c4e:	19a080e7          	jalr	410(ra) # 80000de4 <release>
  return k;
}
    80002c52:	854a                	mv	a0,s2
    80002c54:	60e2                	ld	ra,24(sp)
    80002c56:	6442                	ld	s0,16(sp)
    80002c58:	64a2                	ld	s1,8(sp)
    80002c5a:	6902                	ld	s2,0(sp)
    80002c5c:	6105                	addi	sp,sp,32
    80002c5e:	8082                	ret

0000000080002c60 <join_thread>:
uint64 join_thread(uint64 thread_id, uint64 status_addr) {
    80002c60:	715d                	addi	sp,sp,-80
    80002c62:	e486                	sd	ra,72(sp)
    80002c64:	e0a2                	sd	s0,64(sp)
    80002c66:	fc26                	sd	s1,56(sp)
    80002c68:	f84a                	sd	s2,48(sp)
    80002c6a:	f44e                	sd	s3,40(sp)
    80002c6c:	f052                	sd	s4,32(sp)
    80002c6e:	e45e                	sd	s7,8(sp)
    80002c70:	0880                	addi	s0,sp,80
    80002c72:	8a2a                	mv	s4,a0
    80002c74:	8bae                	mv	s7,a1
  struct proc *p = myproc();
    80002c76:	fffff097          	auipc	ra,0xfffff
    80002c7a:	2be080e7          	jalr	702(ra) # 80001f34 <myproc>
    80002c7e:	89aa                	mv	s3,a0
  if (p->is_thread) 
    80002c80:	16852783          	lw	a5,360(a0)
    80002c84:	c399                	beqz	a5,80002c8a <join_thread+0x2a>
    p = p->parent;
    80002c86:	03853983          	ld	s3,56(a0)
  acquire(&wait_lock);
    80002c8a:	00052517          	auipc	a0,0x52
    80002c8e:	fde50513          	addi	a0,a0,-34 # 80054c68 <wait_lock>
    80002c92:	ffffe097          	auipc	ra,0xffffe
    80002c96:	0a2080e7          	jalr	162(ra) # 80000d34 <acquire>
  for (thread_idx = 0; thread_idx < MAX_THREADS; thread_idx++) {
    80002c9a:	17098793          	addi	a5,s3,368
    80002c9e:	4901                	li	s2,0
    80002ca0:	04000693          	li	a3,64
    80002ca4:	a029                	j	80002cae <join_thread+0x4e>
    80002ca6:	2905                	addiw	s2,s2,1
    80002ca8:	07a1                	addi	a5,a5,8
    80002caa:	0ed90263          	beq	s2,a3,80002d8e <join_thread+0x12e>
    if (p->infant_threads[thread_idx] && thread_id == p->infant_threads[thread_idx]->pid) {
    80002cae:	6384                	ld	s1,0(a5)
    80002cb0:	d8fd                	beqz	s1,80002ca6 <join_thread+0x46>
    80002cb2:	5898                	lw	a4,48(s1)
    80002cb4:	ff4719e3          	bne	a4,s4,80002ca6 <join_thread+0x46>
    80002cb8:	ec56                	sd	s5,24(sp)
    80002cba:	e85a                	sd	s6,16(sp)
    if (child->state == ZOMBIE) {
    80002cbc:	4a95                	li	s5,5
    sleep(p, &wait_lock);
    80002cbe:	00052b17          	auipc	s6,0x52
    80002cc2:	faab0b13          	addi	s6,s6,-86 # 80054c68 <wait_lock>
    acquire(&child->lock);
    80002cc6:	8526                	mv	a0,s1
    80002cc8:	ffffe097          	auipc	ra,0xffffe
    80002ccc:	06c080e7          	jalr	108(ra) # 80000d34 <acquire>
    if (child->state == ZOMBIE) {
    80002cd0:	4c9c                	lw	a5,24(s1)
    80002cd2:	03578463          	beq	a5,s5,80002cfa <join_thread+0x9a>
    release(&child->lock);
    80002cd6:	8526                	mv	a0,s1
    80002cd8:	ffffe097          	auipc	ra,0xffffe
    80002cdc:	10c080e7          	jalr	268(ra) # 80000de4 <release>
    if (killed(p)) {
    80002ce0:	854e                	mv	a0,s3
    80002ce2:	00000097          	auipc	ra,0x0
    80002ce6:	f4c080e7          	jalr	-180(ra) # 80002c2e <killed>
    80002cea:	ed35                	bnez	a0,80002d66 <join_thread+0x106>
    sleep(p, &wait_lock);
    80002cec:	85da                	mv	a1,s6
    80002cee:	854e                	mv	a0,s3
    80002cf0:	00000097          	auipc	ra,0x0
    80002cf4:	afa080e7          	jalr	-1286(ra) # 800027ea <sleep>
    acquire(&child->lock);
    80002cf8:	b7f9                	j	80002cc6 <join_thread+0x66>
      if (status_addr != 0 && copyout(p->pagetable, status_addr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
    80002cfa:	000b8e63          	beqz	s7,80002d16 <join_thread+0xb6>
    80002cfe:	4691                	li	a3,4
    80002d00:	02c48613          	addi	a2,s1,44
    80002d04:	85de                	mv	a1,s7
    80002d06:	0509b503          	ld	a0,80(s3)
    80002d0a:	fffff097          	auipc	ra,0xfffff
    80002d0e:	eb6080e7          	jalr	-330(ra) # 80001bc0 <copyout>
    80002d12:	02054963          	bltz	a0,80002d44 <join_thread+0xe4>
      release(&child->lock);
    80002d16:	8526                	mv	a0,s1
    80002d18:	ffffe097          	auipc	ra,0xffffe
    80002d1c:	0cc080e7          	jalr	204(ra) # 80000de4 <release>
      release(&wait_lock);
    80002d20:	00052517          	auipc	a0,0x52
    80002d24:	f4850513          	addi	a0,a0,-184 # 80054c68 <wait_lock>
    80002d28:	ffffe097          	auipc	ra,0xffffe
    80002d2c:	0bc080e7          	jalr	188(ra) # 80000de4 <release>
      p->infant_threads[thread_idx] = 0;
    80002d30:	090e                	slli	s2,s2,0x3
    80002d32:	17090913          	addi	s2,s2,368
    80002d36:	99ca                	add	s3,s3,s2
    80002d38:	0009b023          	sd	zero,0(s3)
      return thread_id;
    80002d3c:	8552                	mv	a0,s4
    80002d3e:	6ae2                	ld	s5,24(sp)
    80002d40:	6b42                	ld	s6,16(sp)
    80002d42:	a82d                	j	80002d7c <join_thread+0x11c>
        release(&child->lock);
    80002d44:	8526                	mv	a0,s1
    80002d46:	ffffe097          	auipc	ra,0xffffe
    80002d4a:	09e080e7          	jalr	158(ra) # 80000de4 <release>
        release(&wait_lock);
    80002d4e:	00052517          	auipc	a0,0x52
    80002d52:	f1a50513          	addi	a0,a0,-230 # 80054c68 <wait_lock>
    80002d56:	ffffe097          	auipc	ra,0xffffe
    80002d5a:	08e080e7          	jalr	142(ra) # 80000de4 <release>
        return -1;
    80002d5e:	557d                	li	a0,-1
    80002d60:	6ae2                	ld	s5,24(sp)
    80002d62:	6b42                	ld	s6,16(sp)
    80002d64:	a821                	j	80002d7c <join_thread+0x11c>
      release(&wait_lock);
    80002d66:	00052517          	auipc	a0,0x52
    80002d6a:	f0250513          	addi	a0,a0,-254 # 80054c68 <wait_lock>
    80002d6e:	ffffe097          	auipc	ra,0xffffe
    80002d72:	076080e7          	jalr	118(ra) # 80000de4 <release>
      return -1;
    80002d76:	557d                	li	a0,-1
    80002d78:	6ae2                	ld	s5,24(sp)
    80002d7a:	6b42                	ld	s6,16(sp)
}
    80002d7c:	60a6                	ld	ra,72(sp)
    80002d7e:	6406                	ld	s0,64(sp)
    80002d80:	74e2                	ld	s1,56(sp)
    80002d82:	7942                	ld	s2,48(sp)
    80002d84:	79a2                	ld	s3,40(sp)
    80002d86:	7a02                	ld	s4,32(sp)
    80002d88:	6ba2                	ld	s7,8(sp)
    80002d8a:	6161                	addi	sp,sp,80
    80002d8c:	8082                	ret
    release(&wait_lock);
    80002d8e:	00052517          	auipc	a0,0x52
    80002d92:	eda50513          	addi	a0,a0,-294 # 80054c68 <wait_lock>
    80002d96:	ffffe097          	auipc	ra,0xffffe
    80002d9a:	04e080e7          	jalr	78(ra) # 80000de4 <release>
    return -1;
    80002d9e:	557d                	li	a0,-1
    80002da0:	bff1                	j	80002d7c <join_thread+0x11c>

0000000080002da2 <wait>:
{
    80002da2:	715d                	addi	sp,sp,-80
    80002da4:	e486                	sd	ra,72(sp)
    80002da6:	e0a2                	sd	s0,64(sp)
    80002da8:	fc26                	sd	s1,56(sp)
    80002daa:	f84a                	sd	s2,48(sp)
    80002dac:	f44e                	sd	s3,40(sp)
    80002dae:	f052                	sd	s4,32(sp)
    80002db0:	ec56                	sd	s5,24(sp)
    80002db2:	e85a                	sd	s6,16(sp)
    80002db4:	e45e                	sd	s7,8(sp)
    80002db6:	0880                	addi	s0,sp,80
    80002db8:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002dba:	fffff097          	auipc	ra,0xfffff
    80002dbe:	17a080e7          	jalr	378(ra) # 80001f34 <myproc>
    80002dc2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002dc4:	00052517          	auipc	a0,0x52
    80002dc8:	ea450513          	addi	a0,a0,-348 # 80054c68 <wait_lock>
    80002dcc:	ffffe097          	auipc	ra,0xffffe
    80002dd0:	f68080e7          	jalr	-152(ra) # 80000d34 <acquire>
        if(pp->state == ZOMBIE){
    80002dd4:	4a15                	li	s4,5
        havekids = 1;
    80002dd6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002dd8:	00060997          	auipc	s3,0x60
    80002ddc:	ea898993          	addi	s3,s3,-344 # 80062c80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002de0:	00052b17          	auipc	s6,0x52
    80002de4:	e88b0b13          	addi	s6,s6,-376 # 80054c68 <wait_lock>
    80002de8:	a0c9                	j	80002eaa <wait+0x108>
          pid = pp->pid;
    80002dea:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002dee:	000b8e63          	beqz	s7,80002e0a <wait+0x68>
    80002df2:	4691                	li	a3,4
    80002df4:	02c48613          	addi	a2,s1,44
    80002df8:	85de                	mv	a1,s7
    80002dfa:	05093503          	ld	a0,80(s2)
    80002dfe:	fffff097          	auipc	ra,0xfffff
    80002e02:	dc2080e7          	jalr	-574(ra) # 80001bc0 <copyout>
    80002e06:	04054063          	bltz	a0,80002e46 <wait+0xa4>
          freeproc(pp);
    80002e0a:	8526                	mv	a0,s1
    80002e0c:	fffff097          	auipc	ra,0xfffff
    80002e10:	2dc080e7          	jalr	732(ra) # 800020e8 <freeproc>
          release(&pp->lock);
    80002e14:	8526                	mv	a0,s1
    80002e16:	ffffe097          	auipc	ra,0xffffe
    80002e1a:	fce080e7          	jalr	-50(ra) # 80000de4 <release>
          release(&wait_lock);
    80002e1e:	00052517          	auipc	a0,0x52
    80002e22:	e4a50513          	addi	a0,a0,-438 # 80054c68 <wait_lock>
    80002e26:	ffffe097          	auipc	ra,0xffffe
    80002e2a:	fbe080e7          	jalr	-66(ra) # 80000de4 <release>
}
    80002e2e:	854e                	mv	a0,s3
    80002e30:	60a6                	ld	ra,72(sp)
    80002e32:	6406                	ld	s0,64(sp)
    80002e34:	74e2                	ld	s1,56(sp)
    80002e36:	7942                	ld	s2,48(sp)
    80002e38:	79a2                	ld	s3,40(sp)
    80002e3a:	7a02                	ld	s4,32(sp)
    80002e3c:	6ae2                	ld	s5,24(sp)
    80002e3e:	6b42                	ld	s6,16(sp)
    80002e40:	6ba2                	ld	s7,8(sp)
    80002e42:	6161                	addi	sp,sp,80
    80002e44:	8082                	ret
            release(&pp->lock);
    80002e46:	8526                	mv	a0,s1
    80002e48:	ffffe097          	auipc	ra,0xffffe
    80002e4c:	f9c080e7          	jalr	-100(ra) # 80000de4 <release>
            release(&wait_lock);
    80002e50:	00052517          	auipc	a0,0x52
    80002e54:	e1850513          	addi	a0,a0,-488 # 80054c68 <wait_lock>
    80002e58:	ffffe097          	auipc	ra,0xffffe
    80002e5c:	f8c080e7          	jalr	-116(ra) # 80000de4 <release>
            return -1;
    80002e60:	59fd                	li	s3,-1
    80002e62:	b7f1                	j	80002e2e <wait+0x8c>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002e64:	37048493          	addi	s1,s1,880
    80002e68:	03348463          	beq	s1,s3,80002e90 <wait+0xee>
      if(pp->parent == p){
    80002e6c:	7c9c                	ld	a5,56(s1)
    80002e6e:	ff279be3          	bne	a5,s2,80002e64 <wait+0xc2>
        acquire(&pp->lock);
    80002e72:	8526                	mv	a0,s1
    80002e74:	ffffe097          	auipc	ra,0xffffe
    80002e78:	ec0080e7          	jalr	-320(ra) # 80000d34 <acquire>
        if(pp->state == ZOMBIE){
    80002e7c:	4c9c                	lw	a5,24(s1)
    80002e7e:	f74786e3          	beq	a5,s4,80002dea <wait+0x48>
        release(&pp->lock);
    80002e82:	8526                	mv	a0,s1
    80002e84:	ffffe097          	auipc	ra,0xffffe
    80002e88:	f60080e7          	jalr	-160(ra) # 80000de4 <release>
        havekids = 1;
    80002e8c:	8756                	mv	a4,s5
    80002e8e:	bfd9                	j	80002e64 <wait+0xc2>
    if(!havekids || killed(p)){
    80002e90:	c31d                	beqz	a4,80002eb6 <wait+0x114>
    80002e92:	854a                	mv	a0,s2
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	d9a080e7          	jalr	-614(ra) # 80002c2e <killed>
    80002e9c:	ed09                	bnez	a0,80002eb6 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002e9e:	85da                	mv	a1,s6
    80002ea0:	854a                	mv	a0,s2
    80002ea2:	00000097          	auipc	ra,0x0
    80002ea6:	948080e7          	jalr	-1720(ra) # 800027ea <sleep>
    havekids = 0;
    80002eaa:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002eac:	00052497          	auipc	s1,0x52
    80002eb0:	1d448493          	addi	s1,s1,468 # 80055080 <proc>
    80002eb4:	bf65                	j	80002e6c <wait+0xca>
      release(&wait_lock);
    80002eb6:	00052517          	auipc	a0,0x52
    80002eba:	db250513          	addi	a0,a0,-590 # 80054c68 <wait_lock>
    80002ebe:	ffffe097          	auipc	ra,0xffffe
    80002ec2:	f26080e7          	jalr	-218(ra) # 80000de4 <release>
      return -1;
    80002ec6:	59fd                	li	s3,-1
    80002ec8:	b79d                	j	80002e2e <wait+0x8c>

0000000080002eca <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002eca:	7179                	addi	sp,sp,-48
    80002ecc:	f406                	sd	ra,40(sp)
    80002ece:	f022                	sd	s0,32(sp)
    80002ed0:	ec26                	sd	s1,24(sp)
    80002ed2:	e84a                	sd	s2,16(sp)
    80002ed4:	e44e                	sd	s3,8(sp)
    80002ed6:	e052                	sd	s4,0(sp)
    80002ed8:	1800                	addi	s0,sp,48
    80002eda:	84aa                	mv	s1,a0
    80002edc:	8a2e                	mv	s4,a1
    80002ede:	89b2                	mv	s3,a2
    80002ee0:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	052080e7          	jalr	82(ra) # 80001f34 <myproc>
  if(user_dst){
    80002eea:	c08d                	beqz	s1,80002f0c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002eec:	86ca                	mv	a3,s2
    80002eee:	864e                	mv	a2,s3
    80002ef0:	85d2                	mv	a1,s4
    80002ef2:	6928                	ld	a0,80(a0)
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	ccc080e7          	jalr	-820(ra) # 80001bc0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002efc:	70a2                	ld	ra,40(sp)
    80002efe:	7402                	ld	s0,32(sp)
    80002f00:	64e2                	ld	s1,24(sp)
    80002f02:	6942                	ld	s2,16(sp)
    80002f04:	69a2                	ld	s3,8(sp)
    80002f06:	6a02                	ld	s4,0(sp)
    80002f08:	6145                	addi	sp,sp,48
    80002f0a:	8082                	ret
    memmove((char *)dst, src, len);
    80002f0c:	0009061b          	sext.w	a2,s2
    80002f10:	85ce                	mv	a1,s3
    80002f12:	8552                	mv	a0,s4
    80002f14:	ffffe097          	auipc	ra,0xffffe
    80002f18:	f78080e7          	jalr	-136(ra) # 80000e8c <memmove>
    return 0;
    80002f1c:	8526                	mv	a0,s1
    80002f1e:	bff9                	j	80002efc <either_copyout+0x32>

0000000080002f20 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002f20:	7179                	addi	sp,sp,-48
    80002f22:	f406                	sd	ra,40(sp)
    80002f24:	f022                	sd	s0,32(sp)
    80002f26:	ec26                	sd	s1,24(sp)
    80002f28:	e84a                	sd	s2,16(sp)
    80002f2a:	e44e                	sd	s3,8(sp)
    80002f2c:	e052                	sd	s4,0(sp)
    80002f2e:	1800                	addi	s0,sp,48
    80002f30:	8a2a                	mv	s4,a0
    80002f32:	84ae                	mv	s1,a1
    80002f34:	89b2                	mv	s3,a2
    80002f36:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002f38:	fffff097          	auipc	ra,0xfffff
    80002f3c:	ffc080e7          	jalr	-4(ra) # 80001f34 <myproc>
  if(user_src){
    80002f40:	c08d                	beqz	s1,80002f62 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002f42:	86ca                	mv	a3,s2
    80002f44:	864e                	mv	a2,s3
    80002f46:	85d2                	mv	a1,s4
    80002f48:	6928                	ld	a0,80(a0)
    80002f4a:	fffff097          	auipc	ra,0xfffff
    80002f4e:	d02080e7          	jalr	-766(ra) # 80001c4c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002f52:	70a2                	ld	ra,40(sp)
    80002f54:	7402                	ld	s0,32(sp)
    80002f56:	64e2                	ld	s1,24(sp)
    80002f58:	6942                	ld	s2,16(sp)
    80002f5a:	69a2                	ld	s3,8(sp)
    80002f5c:	6a02                	ld	s4,0(sp)
    80002f5e:	6145                	addi	sp,sp,48
    80002f60:	8082                	ret
    memmove(dst, (char*)src, len);
    80002f62:	0009061b          	sext.w	a2,s2
    80002f66:	85ce                	mv	a1,s3
    80002f68:	8552                	mv	a0,s4
    80002f6a:	ffffe097          	auipc	ra,0xffffe
    80002f6e:	f22080e7          	jalr	-222(ra) # 80000e8c <memmove>
    return 0;
    80002f72:	8526                	mv	a0,s1
    80002f74:	bff9                	j	80002f52 <either_copyin+0x32>

0000000080002f76 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002f76:	715d                	addi	sp,sp,-80
    80002f78:	e486                	sd	ra,72(sp)
    80002f7a:	e0a2                	sd	s0,64(sp)
    80002f7c:	fc26                	sd	s1,56(sp)
    80002f7e:	f84a                	sd	s2,48(sp)
    80002f80:	f44e                	sd	s3,40(sp)
    80002f82:	f052                	sd	s4,32(sp)
    80002f84:	ec56                	sd	s5,24(sp)
    80002f86:	e85a                	sd	s6,16(sp)
    80002f88:	e45e                	sd	s7,8(sp)
    80002f8a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002f8c:	00006517          	auipc	a0,0x6
    80002f90:	08450513          	addi	a0,a0,132 # 80009010 <etext+0x10>
    80002f94:	ffffd097          	auipc	ra,0xffffd
    80002f98:	614080e7          	jalr	1556(ra) # 800005a8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002f9c:	00052497          	auipc	s1,0x52
    80002fa0:	23c48493          	addi	s1,s1,572 # 800551d8 <proc+0x158>
    80002fa4:	00060917          	auipc	s2,0x60
    80002fa8:	e3490913          	addi	s2,s2,-460 # 80062dd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002fac:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002fae:	00006997          	auipc	s3,0x6
    80002fb2:	37a98993          	addi	s3,s3,890 # 80009328 <etext+0x328>
    printf("%d %s %s", p->pid, state, p->name);
    80002fb6:	00006a97          	auipc	s5,0x6
    80002fba:	37aa8a93          	addi	s5,s5,890 # 80009330 <etext+0x330>
    printf("\n");
    80002fbe:	00006a17          	auipc	s4,0x6
    80002fc2:	052a0a13          	addi	s4,s4,82 # 80009010 <etext+0x10>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002fc6:	00007b97          	auipc	s7,0x7
    80002fca:	a1ab8b93          	addi	s7,s7,-1510 # 800099e0 <states.0>
    80002fce:	a00d                	j	80002ff0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002fd0:	ed86a583          	lw	a1,-296(a3)
    80002fd4:	8556                	mv	a0,s5
    80002fd6:	ffffd097          	auipc	ra,0xffffd
    80002fda:	5d2080e7          	jalr	1490(ra) # 800005a8 <printf>
    printf("\n");
    80002fde:	8552                	mv	a0,s4
    80002fe0:	ffffd097          	auipc	ra,0xffffd
    80002fe4:	5c8080e7          	jalr	1480(ra) # 800005a8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002fe8:	37048493          	addi	s1,s1,880
    80002fec:	03248263          	beq	s1,s2,80003010 <procdump+0x9a>
    if(p->state == UNUSED)
    80002ff0:	86a6                	mv	a3,s1
    80002ff2:	ec04a783          	lw	a5,-320(s1)
    80002ff6:	dbed                	beqz	a5,80002fe8 <procdump+0x72>
      state = "???";
    80002ff8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ffa:	fcfb6be3          	bltu	s6,a5,80002fd0 <procdump+0x5a>
    80002ffe:	02079713          	slli	a4,a5,0x20
    80003002:	01d75793          	srli	a5,a4,0x1d
    80003006:	97de                	add	a5,a5,s7
    80003008:	6390                	ld	a2,0(a5)
    8000300a:	f279                	bnez	a2,80002fd0 <procdump+0x5a>
      state = "???";
    8000300c:	864e                	mv	a2,s3
    8000300e:	b7c9                	j	80002fd0 <procdump+0x5a>
  }
}
    80003010:	60a6                	ld	ra,72(sp)
    80003012:	6406                	ld	s0,64(sp)
    80003014:	74e2                	ld	s1,56(sp)
    80003016:	7942                	ld	s2,48(sp)
    80003018:	79a2                	ld	s3,40(sp)
    8000301a:	7a02                	ld	s4,32(sp)
    8000301c:	6ae2                	ld	s5,24(sp)
    8000301e:	6b42                	ld	s6,16(sp)
    80003020:	6ba2                	ld	s7,8(sp)
    80003022:	6161                	addi	sp,sp,80
    80003024:	8082                	ret

0000000080003026 <spoon>:

uint64 spoon(void *arg)
{
    80003026:	1141                	addi	sp,sp,-16
    80003028:	e406                	sd	ra,8(sp)
    8000302a:	e022                	sd	s0,0(sp)
    8000302c:	0800                	addi	s0,sp,16
    8000302e:	85aa                	mv	a1,a0
  // Add your code here...
  printf("In spoon system call with argument %p\n", arg);
    80003030:	00006517          	auipc	a0,0x6
    80003034:	31050513          	addi	a0,a0,784 # 80009340 <etext+0x340>
    80003038:	ffffd097          	auipc	ra,0xffffd
    8000303c:	570080e7          	jalr	1392(ra) # 800005a8 <printf>
  return 0;
}
    80003040:	4501                	li	a0,0
    80003042:	60a2                	ld	ra,8(sp)
    80003044:	6402                	ld	s0,0(sp)
    80003046:	0141                	addi	sp,sp,16
    80003048:	8082                	ret

000000008000304a <swtch>:
    8000304a:	00153023          	sd	ra,0(a0)
    8000304e:	00253423          	sd	sp,8(a0)
    80003052:	e900                	sd	s0,16(a0)
    80003054:	ed04                	sd	s1,24(a0)
    80003056:	03253023          	sd	s2,32(a0)
    8000305a:	03353423          	sd	s3,40(a0)
    8000305e:	03453823          	sd	s4,48(a0)
    80003062:	03553c23          	sd	s5,56(a0)
    80003066:	05653023          	sd	s6,64(a0)
    8000306a:	05753423          	sd	s7,72(a0)
    8000306e:	05853823          	sd	s8,80(a0)
    80003072:	05953c23          	sd	s9,88(a0)
    80003076:	07a53023          	sd	s10,96(a0)
    8000307a:	07b53423          	sd	s11,104(a0)
    8000307e:	0005b083          	ld	ra,0(a1)
    80003082:	0085b103          	ld	sp,8(a1)
    80003086:	6980                	ld	s0,16(a1)
    80003088:	6d84                	ld	s1,24(a1)
    8000308a:	0205b903          	ld	s2,32(a1)
    8000308e:	0285b983          	ld	s3,40(a1)
    80003092:	0305ba03          	ld	s4,48(a1)
    80003096:	0385ba83          	ld	s5,56(a1)
    8000309a:	0405bb03          	ld	s6,64(a1)
    8000309e:	0485bb83          	ld	s7,72(a1)
    800030a2:	0505bc03          	ld	s8,80(a1)
    800030a6:	0585bc83          	ld	s9,88(a1)
    800030aa:	0605bd03          	ld	s10,96(a1)
    800030ae:	0685bd83          	ld	s11,104(a1)
    800030b2:	8082                	ret

00000000800030b4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800030b4:	1141                	addi	sp,sp,-16
    800030b6:	e406                	sd	ra,8(sp)
    800030b8:	e022                	sd	s0,0(sp)
    800030ba:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800030bc:	00006597          	auipc	a1,0x6
    800030c0:	2dc58593          	addi	a1,a1,732 # 80009398 <etext+0x398>
    800030c4:	00060517          	auipc	a0,0x60
    800030c8:	bbc50513          	addi	a0,a0,-1092 # 80062c80 <tickslock>
    800030cc:	ffffe097          	auipc	ra,0xffffe
    800030d0:	bce080e7          	jalr	-1074(ra) # 80000c9a <initlock>
}
    800030d4:	60a2                	ld	ra,8(sp)
    800030d6:	6402                	ld	s0,0(sp)
    800030d8:	0141                	addi	sp,sp,16
    800030da:	8082                	ret

00000000800030dc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800030dc:	1141                	addi	sp,sp,-16
    800030de:	e406                	sd	ra,8(sp)
    800030e0:	e022                	sd	s0,0(sp)
    800030e2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800030e4:	00003797          	auipc	a5,0x3
    800030e8:	6fc78793          	addi	a5,a5,1788 # 800067e0 <kernelvec>
    800030ec:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800030f0:	60a2                	ld	ra,8(sp)
    800030f2:	6402                	ld	s0,0(sp)
    800030f4:	0141                	addi	sp,sp,16
    800030f6:	8082                	ret

00000000800030f8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800030f8:	1141                	addi	sp,sp,-16
    800030fa:	e406                	sd	ra,8(sp)
    800030fc:	e022                	sd	s0,0(sp)
    800030fe:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80003100:	fffff097          	auipc	ra,0xfffff
    80003104:	e34080e7          	jalr	-460(ra) # 80001f34 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003108:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000310c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000310e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003112:	00005697          	auipc	a3,0x5
    80003116:	eee68693          	addi	a3,a3,-274 # 80008000 <_trampoline>
    8000311a:	00005717          	auipc	a4,0x5
    8000311e:	ee670713          	addi	a4,a4,-282 # 80008000 <_trampoline>
    80003122:	8f15                	sub	a4,a4,a3
    80003124:	040007b7          	lui	a5,0x4000
    80003128:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000312a:	07b2                	slli	a5,a5,0xc
    8000312c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000312e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003132:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003134:	18002673          	csrr	a2,satp
    80003138:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000313a:	6d30                	ld	a2,88(a0)
    8000313c:	6138                	ld	a4,64(a0)
    8000313e:	6585                	lui	a1,0x1
    80003140:	972e                	add	a4,a4,a1
    80003142:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003144:	6d38                	ld	a4,88(a0)
    80003146:	00000617          	auipc	a2,0x0
    8000314a:	15060613          	addi	a2,a2,336 # 80003296 <usertrap>
    8000314e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003150:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80003152:	8612                	mv	a2,tp
    80003154:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003156:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000315a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000315e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003162:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003166:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003168:	6f18                	ld	a4,24(a4)
    8000316a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000316e:	6928                	ld	a0,80(a0)
    80003170:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80003172:	00005717          	auipc	a4,0x5
    80003176:	f2a70713          	addi	a4,a4,-214 # 8000809c <userret>
    8000317a:	8f15                	sub	a4,a4,a3
    8000317c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000317e:	577d                	li	a4,-1
    80003180:	177e                	slli	a4,a4,0x3f
    80003182:	8d59                	or	a0,a0,a4
    80003184:	9782                	jalr	a5
}
    80003186:	60a2                	ld	ra,8(sp)
    80003188:	6402                	ld	s0,0(sp)
    8000318a:	0141                	addi	sp,sp,16
    8000318c:	8082                	ret

000000008000318e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000318e:	1141                	addi	sp,sp,-16
    80003190:	e406                	sd	ra,8(sp)
    80003192:	e022                	sd	s0,0(sp)
    80003194:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    80003196:	00060517          	auipc	a0,0x60
    8000319a:	aea50513          	addi	a0,a0,-1302 # 80062c80 <tickslock>
    8000319e:	ffffe097          	auipc	ra,0xffffe
    800031a2:	b96080e7          	jalr	-1130(ra) # 80000d34 <acquire>
  ticks++;
    800031a6:	0000a717          	auipc	a4,0xa
    800031aa:	83a70713          	addi	a4,a4,-1990 # 8000c9e0 <ticks>
    800031ae:	431c                	lw	a5,0(a4)
    800031b0:	2785                	addiw	a5,a5,1
    800031b2:	c31c                	sw	a5,0(a4)
  wakeup(&ticks);
    800031b4:	853a                	mv	a0,a4
    800031b6:	fffff097          	auipc	ra,0xfffff
    800031ba:	698080e7          	jalr	1688(ra) # 8000284e <wakeup>
  release(&tickslock);
    800031be:	00060517          	auipc	a0,0x60
    800031c2:	ac250513          	addi	a0,a0,-1342 # 80062c80 <tickslock>
    800031c6:	ffffe097          	auipc	ra,0xffffe
    800031ca:	c1e080e7          	jalr	-994(ra) # 80000de4 <release>
}
    800031ce:	60a2                	ld	ra,8(sp)
    800031d0:	6402                	ld	s0,0(sp)
    800031d2:	0141                	addi	sp,sp,16
    800031d4:	8082                	ret

00000000800031d6 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    800031d6:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800031da:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    800031dc:	0a07dc63          	bgez	a5,80003294 <devintr+0xbe>
{
    800031e0:	1101                	addi	sp,sp,-32
    800031e2:	ec06                	sd	ra,24(sp)
    800031e4:	e822                	sd	s0,16(sp)
    800031e6:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    800031e8:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    800031ec:	46a5                	li	a3,9
    800031ee:	00d70c63          	beq	a4,a3,80003206 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    800031f2:	577d                	li	a4,-1
    800031f4:	177e                	slli	a4,a4,0x3f
    800031f6:	0705                	addi	a4,a4,1
    return 0;
    800031f8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800031fa:	06e78c63          	beq	a5,a4,80003272 <devintr+0x9c>
  }
}
    800031fe:	60e2                	ld	ra,24(sp)
    80003200:	6442                	ld	s0,16(sp)
    80003202:	6105                	addi	sp,sp,32
    80003204:	8082                	ret
    80003206:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80003208:	00003097          	auipc	ra,0x3
    8000320c:	6e6080e7          	jalr	1766(ra) # 800068ee <plic_claim>
    80003210:	872a                	mv	a4,a0
    80003212:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80003214:	47a9                	li	a5,10
    80003216:	00f50c63          	beq	a0,a5,8000322e <devintr+0x58>
    } else if(irq == VIRTIO0_IRQ){
    8000321a:	4785                	li	a5,1
    8000321c:	02f50563          	beq	a0,a5,80003246 <devintr+0x70>
    } else if (irq == VIRTIO1_IRQ) {
    80003220:	4789                	li	a5,2
    80003222:	02f50763          	beq	a0,a5,80003250 <devintr+0x7a>
    return 1;
    80003226:	4505                	li	a0,1
    } else if(irq){
    80003228:	eb1d                	bnez	a4,8000325e <devintr+0x88>
    8000322a:	64a2                	ld	s1,8(sp)
    8000322c:	bfc9                	j	800031fe <devintr+0x28>
      uartintr();
    8000322e:	ffffd097          	auipc	ra,0xffffd
    80003232:	7d2080e7          	jalr	2002(ra) # 80000a00 <uartintr>
      plic_complete(irq);
    80003236:	8526                	mv	a0,s1
    80003238:	00003097          	auipc	ra,0x3
    8000323c:	6da080e7          	jalr	1754(ra) # 80006912 <plic_complete>
    return 1;
    80003240:	4505                	li	a0,1
    80003242:	64a2                	ld	s1,8(sp)
    80003244:	bf6d                	j	800031fe <devintr+0x28>
      virtio_disk_intr();
    80003246:	00004097          	auipc	ra,0x4
    8000324a:	ba2080e7          	jalr	-1118(ra) # 80006de8 <virtio_disk_intr>
    if(irq)
    8000324e:	b7e5                	j	80003236 <devintr+0x60>
      receive_packet(temp, 0);
    80003250:	4581                	li	a1,0
    80003252:	4501                	li	a0,0
    80003254:	00004097          	auipc	ra,0x4
    80003258:	350080e7          	jalr	848(ra) # 800075a4 <receive_packet>
    8000325c:	bfe9                	j	80003236 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    8000325e:	85ba                	mv	a1,a4
    80003260:	00006517          	auipc	a0,0x6
    80003264:	14050513          	addi	a0,a0,320 # 800093a0 <etext+0x3a0>
    80003268:	ffffd097          	auipc	ra,0xffffd
    8000326c:	340080e7          	jalr	832(ra) # 800005a8 <printf>
    if(irq)
    80003270:	b7d9                	j	80003236 <devintr+0x60>
    if(cpuid() == 0){
    80003272:	fffff097          	auipc	ra,0xfffff
    80003276:	c8e080e7          	jalr	-882(ra) # 80001f00 <cpuid>
    8000327a:	c901                	beqz	a0,8000328a <devintr+0xb4>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000327c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003280:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003282:	14479073          	csrw	sip,a5
    return 2;
    80003286:	4509                	li	a0,2
    80003288:	bf9d                	j	800031fe <devintr+0x28>
      clockintr();
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	f04080e7          	jalr	-252(ra) # 8000318e <clockintr>
    80003292:	b7ed                	j	8000327c <devintr+0xa6>
}
    80003294:	8082                	ret

0000000080003296 <usertrap>:
{
    80003296:	1101                	addi	sp,sp,-32
    80003298:	ec06                	sd	ra,24(sp)
    8000329a:	e822                	sd	s0,16(sp)
    8000329c:	e426                	sd	s1,8(sp)
    8000329e:	e04a                	sd	s2,0(sp)
    800032a0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032a2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800032a6:	1007f793          	andi	a5,a5,256
    800032aa:	e3b1                	bnez	a5,800032ee <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800032ac:	00003797          	auipc	a5,0x3
    800032b0:	53478793          	addi	a5,a5,1332 # 800067e0 <kernelvec>
    800032b4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800032b8:	fffff097          	auipc	ra,0xfffff
    800032bc:	c7c080e7          	jalr	-900(ra) # 80001f34 <myproc>
    800032c0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800032c2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800032c4:	14102773          	csrr	a4,sepc
    800032c8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800032ca:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800032ce:	47a1                	li	a5,8
    800032d0:	02f70763          	beq	a4,a5,800032fe <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    800032d4:	00000097          	auipc	ra,0x0
    800032d8:	f02080e7          	jalr	-254(ra) # 800031d6 <devintr>
    800032dc:	892a                	mv	s2,a0
    800032de:	c151                	beqz	a0,80003362 <usertrap+0xcc>
  if(killed(p))
    800032e0:	8526                	mv	a0,s1
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	94c080e7          	jalr	-1716(ra) # 80002c2e <killed>
    800032ea:	c929                	beqz	a0,8000333c <usertrap+0xa6>
    800032ec:	a099                	j	80003332 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    800032ee:	00006517          	auipc	a0,0x6
    800032f2:	0d250513          	addi	a0,a0,210 # 800093c0 <etext+0x3c0>
    800032f6:	ffffd097          	auipc	ra,0xffffd
    800032fa:	268080e7          	jalr	616(ra) # 8000055e <panic>
    if(killed(p))
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	930080e7          	jalr	-1744(ra) # 80002c2e <killed>
    80003306:	e921                	bnez	a0,80003356 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80003308:	6cb8                	ld	a4,88(s1)
    8000330a:	6f1c                	ld	a5,24(a4)
    8000330c:	0791                	addi	a5,a5,4
    8000330e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003310:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003314:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003318:	10079073          	csrw	sstatus,a5
    syscall();
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	2ce080e7          	jalr	718(ra) # 800035ea <syscall>
  if(killed(p))
    80003324:	8526                	mv	a0,s1
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	908080e7          	jalr	-1784(ra) # 80002c2e <killed>
    8000332e:	c911                	beqz	a0,80003342 <usertrap+0xac>
    80003330:	4901                	li	s2,0
    exit(-1);
    80003332:	557d                	li	a0,-1
    80003334:	fffff097          	auipc	ra,0xfffff
    80003338:	6c4080e7          	jalr	1732(ra) # 800029f8 <exit>
  if(which_dev == 2)
    8000333c:	4789                	li	a5,2
    8000333e:	04f90f63          	beq	s2,a5,8000339c <usertrap+0x106>
  usertrapret();
    80003342:	00000097          	auipc	ra,0x0
    80003346:	db6080e7          	jalr	-586(ra) # 800030f8 <usertrapret>
}
    8000334a:	60e2                	ld	ra,24(sp)
    8000334c:	6442                	ld	s0,16(sp)
    8000334e:	64a2                	ld	s1,8(sp)
    80003350:	6902                	ld	s2,0(sp)
    80003352:	6105                	addi	sp,sp,32
    80003354:	8082                	ret
      exit(-1);
    80003356:	557d                	li	a0,-1
    80003358:	fffff097          	auipc	ra,0xfffff
    8000335c:	6a0080e7          	jalr	1696(ra) # 800029f8 <exit>
    80003360:	b765                	j	80003308 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003362:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003366:	5890                	lw	a2,48(s1)
    80003368:	00006517          	auipc	a0,0x6
    8000336c:	07850513          	addi	a0,a0,120 # 800093e0 <etext+0x3e0>
    80003370:	ffffd097          	auipc	ra,0xffffd
    80003374:	238080e7          	jalr	568(ra) # 800005a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003378:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000337c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003380:	00006517          	auipc	a0,0x6
    80003384:	09050513          	addi	a0,a0,144 # 80009410 <etext+0x410>
    80003388:	ffffd097          	auipc	ra,0xffffd
    8000338c:	220080e7          	jalr	544(ra) # 800005a8 <printf>
    setkilled(p);
    80003390:	8526                	mv	a0,s1
    80003392:	00000097          	auipc	ra,0x0
    80003396:	870080e7          	jalr	-1936(ra) # 80002c02 <setkilled>
    8000339a:	b769                	j	80003324 <usertrap+0x8e>
    yield();
    8000339c:	fffff097          	auipc	ra,0xfffff
    800033a0:	412080e7          	jalr	1042(ra) # 800027ae <yield>
    800033a4:	bf79                	j	80003342 <usertrap+0xac>

00000000800033a6 <kerneltrap>:
{
    800033a6:	7179                	addi	sp,sp,-48
    800033a8:	f406                	sd	ra,40(sp)
    800033aa:	f022                	sd	s0,32(sp)
    800033ac:	ec26                	sd	s1,24(sp)
    800033ae:	e84a                	sd	s2,16(sp)
    800033b0:	e44e                	sd	s3,8(sp)
    800033b2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800033b4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800033b8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800033bc:	142027f3          	csrr	a5,scause
    800033c0:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    800033c2:	1004f793          	andi	a5,s1,256
    800033c6:	cb85                	beqz	a5,800033f6 <kerneltrap+0x50>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800033c8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800033cc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800033ce:	ef85                	bnez	a5,80003406 <kerneltrap+0x60>
  if((which_dev = devintr()) == 0){
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	e06080e7          	jalr	-506(ra) # 800031d6 <devintr>
    800033d8:	cd1d                	beqz	a0,80003416 <kerneltrap+0x70>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800033da:	4789                	li	a5,2
    800033dc:	06f50a63          	beq	a0,a5,80003450 <kerneltrap+0xaa>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800033e0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800033e4:	10049073          	csrw	sstatus,s1
}
    800033e8:	70a2                	ld	ra,40(sp)
    800033ea:	7402                	ld	s0,32(sp)
    800033ec:	64e2                	ld	s1,24(sp)
    800033ee:	6942                	ld	s2,16(sp)
    800033f0:	69a2                	ld	s3,8(sp)
    800033f2:	6145                	addi	sp,sp,48
    800033f4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800033f6:	00006517          	auipc	a0,0x6
    800033fa:	03a50513          	addi	a0,a0,58 # 80009430 <etext+0x430>
    800033fe:	ffffd097          	auipc	ra,0xffffd
    80003402:	160080e7          	jalr	352(ra) # 8000055e <panic>
    panic("kerneltrap: interrupts enabled");
    80003406:	00006517          	auipc	a0,0x6
    8000340a:	05250513          	addi	a0,a0,82 # 80009458 <etext+0x458>
    8000340e:	ffffd097          	auipc	ra,0xffffd
    80003412:	150080e7          	jalr	336(ra) # 8000055e <panic>
    printf("scause %p\n", scause);
    80003416:	85ce                	mv	a1,s3
    80003418:	00006517          	auipc	a0,0x6
    8000341c:	06050513          	addi	a0,a0,96 # 80009478 <etext+0x478>
    80003420:	ffffd097          	auipc	ra,0xffffd
    80003424:	188080e7          	jalr	392(ra) # 800005a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003428:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000342c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003430:	00006517          	auipc	a0,0x6
    80003434:	05850513          	addi	a0,a0,88 # 80009488 <etext+0x488>
    80003438:	ffffd097          	auipc	ra,0xffffd
    8000343c:	170080e7          	jalr	368(ra) # 800005a8 <printf>
    panic("kerneltrap");
    80003440:	00006517          	auipc	a0,0x6
    80003444:	06050513          	addi	a0,a0,96 # 800094a0 <etext+0x4a0>
    80003448:	ffffd097          	auipc	ra,0xffffd
    8000344c:	116080e7          	jalr	278(ra) # 8000055e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	ae4080e7          	jalr	-1308(ra) # 80001f34 <myproc>
    80003458:	d541                	beqz	a0,800033e0 <kerneltrap+0x3a>
    8000345a:	fffff097          	auipc	ra,0xfffff
    8000345e:	ada080e7          	jalr	-1318(ra) # 80001f34 <myproc>
    80003462:	4d18                	lw	a4,24(a0)
    80003464:	4791                	li	a5,4
    80003466:	f6f71de3          	bne	a4,a5,800033e0 <kerneltrap+0x3a>
    yield();
    8000346a:	fffff097          	auipc	ra,0xfffff
    8000346e:	344080e7          	jalr	836(ra) # 800027ae <yield>
    80003472:	b7bd                	j	800033e0 <kerneltrap+0x3a>

0000000080003474 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003474:	1101                	addi	sp,sp,-32
    80003476:	ec06                	sd	ra,24(sp)
    80003478:	e822                	sd	s0,16(sp)
    8000347a:	e426                	sd	s1,8(sp)
    8000347c:	1000                	addi	s0,sp,32
    8000347e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003480:	fffff097          	auipc	ra,0xfffff
    80003484:	ab4080e7          	jalr	-1356(ra) # 80001f34 <myproc>
  switch (n) {
    80003488:	4795                	li	a5,5
    8000348a:	0497e163          	bltu	a5,s1,800034cc <argraw+0x58>
    8000348e:	048a                	slli	s1,s1,0x2
    80003490:	00006717          	auipc	a4,0x6
    80003494:	58070713          	addi	a4,a4,1408 # 80009a10 <states.0+0x30>
    80003498:	94ba                	add	s1,s1,a4
    8000349a:	409c                	lw	a5,0(s1)
    8000349c:	97ba                	add	a5,a5,a4
    8000349e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800034a0:	6d3c                	ld	a5,88(a0)
    800034a2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800034a4:	60e2                	ld	ra,24(sp)
    800034a6:	6442                	ld	s0,16(sp)
    800034a8:	64a2                	ld	s1,8(sp)
    800034aa:	6105                	addi	sp,sp,32
    800034ac:	8082                	ret
    return p->trapframe->a1;
    800034ae:	6d3c                	ld	a5,88(a0)
    800034b0:	7fa8                	ld	a0,120(a5)
    800034b2:	bfcd                	j	800034a4 <argraw+0x30>
    return p->trapframe->a2;
    800034b4:	6d3c                	ld	a5,88(a0)
    800034b6:	63c8                	ld	a0,128(a5)
    800034b8:	b7f5                	j	800034a4 <argraw+0x30>
    return p->trapframe->a3;
    800034ba:	6d3c                	ld	a5,88(a0)
    800034bc:	67c8                	ld	a0,136(a5)
    800034be:	b7dd                	j	800034a4 <argraw+0x30>
    return p->trapframe->a4;
    800034c0:	6d3c                	ld	a5,88(a0)
    800034c2:	6bc8                	ld	a0,144(a5)
    800034c4:	b7c5                	j	800034a4 <argraw+0x30>
    return p->trapframe->a5;
    800034c6:	6d3c                	ld	a5,88(a0)
    800034c8:	6fc8                	ld	a0,152(a5)
    800034ca:	bfe9                	j	800034a4 <argraw+0x30>
  panic("argraw");
    800034cc:	00006517          	auipc	a0,0x6
    800034d0:	fe450513          	addi	a0,a0,-28 # 800094b0 <etext+0x4b0>
    800034d4:	ffffd097          	auipc	ra,0xffffd
    800034d8:	08a080e7          	jalr	138(ra) # 8000055e <panic>

00000000800034dc <fetchaddr>:
{
    800034dc:	1101                	addi	sp,sp,-32
    800034de:	ec06                	sd	ra,24(sp)
    800034e0:	e822                	sd	s0,16(sp)
    800034e2:	e426                	sd	s1,8(sp)
    800034e4:	e04a                	sd	s2,0(sp)
    800034e6:	1000                	addi	s0,sp,32
    800034e8:	84aa                	mv	s1,a0
    800034ea:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	a48080e7          	jalr	-1464(ra) # 80001f34 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800034f4:	653c                	ld	a5,72(a0)
    800034f6:	02f4f863          	bgeu	s1,a5,80003526 <fetchaddr+0x4a>
    800034fa:	00848713          	addi	a4,s1,8
    800034fe:	02e7e663          	bltu	a5,a4,8000352a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003502:	46a1                	li	a3,8
    80003504:	8626                	mv	a2,s1
    80003506:	85ca                	mv	a1,s2
    80003508:	6928                	ld	a0,80(a0)
    8000350a:	ffffe097          	auipc	ra,0xffffe
    8000350e:	742080e7          	jalr	1858(ra) # 80001c4c <copyin>
    80003512:	00a03533          	snez	a0,a0
    80003516:	40a0053b          	negw	a0,a0
}
    8000351a:	60e2                	ld	ra,24(sp)
    8000351c:	6442                	ld	s0,16(sp)
    8000351e:	64a2                	ld	s1,8(sp)
    80003520:	6902                	ld	s2,0(sp)
    80003522:	6105                	addi	sp,sp,32
    80003524:	8082                	ret
    return -1;
    80003526:	557d                	li	a0,-1
    80003528:	bfcd                	j	8000351a <fetchaddr+0x3e>
    8000352a:	557d                	li	a0,-1
    8000352c:	b7fd                	j	8000351a <fetchaddr+0x3e>

000000008000352e <fetchstr>:
{
    8000352e:	7179                	addi	sp,sp,-48
    80003530:	f406                	sd	ra,40(sp)
    80003532:	f022                	sd	s0,32(sp)
    80003534:	ec26                	sd	s1,24(sp)
    80003536:	e84a                	sd	s2,16(sp)
    80003538:	e44e                	sd	s3,8(sp)
    8000353a:	1800                	addi	s0,sp,48
    8000353c:	89aa                	mv	s3,a0
    8000353e:	84ae                	mv	s1,a1
    80003540:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	9f2080e7          	jalr	-1550(ra) # 80001f34 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000354a:	86ca                	mv	a3,s2
    8000354c:	864e                	mv	a2,s3
    8000354e:	85a6                	mv	a1,s1
    80003550:	6928                	ld	a0,80(a0)
    80003552:	ffffe097          	auipc	ra,0xffffe
    80003556:	788080e7          	jalr	1928(ra) # 80001cda <copyinstr>
    8000355a:	00054e63          	bltz	a0,80003576 <fetchstr+0x48>
  return strlen(buf);
    8000355e:	8526                	mv	a0,s1
    80003560:	ffffe097          	auipc	ra,0xffffe
    80003564:	a5a080e7          	jalr	-1446(ra) # 80000fba <strlen>
}
    80003568:	70a2                	ld	ra,40(sp)
    8000356a:	7402                	ld	s0,32(sp)
    8000356c:	64e2                	ld	s1,24(sp)
    8000356e:	6942                	ld	s2,16(sp)
    80003570:	69a2                	ld	s3,8(sp)
    80003572:	6145                	addi	sp,sp,48
    80003574:	8082                	ret
    return -1;
    80003576:	557d                	li	a0,-1
    80003578:	bfc5                	j	80003568 <fetchstr+0x3a>

000000008000357a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000357a:	1101                	addi	sp,sp,-32
    8000357c:	ec06                	sd	ra,24(sp)
    8000357e:	e822                	sd	s0,16(sp)
    80003580:	e426                	sd	s1,8(sp)
    80003582:	1000                	addi	s0,sp,32
    80003584:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003586:	00000097          	auipc	ra,0x0
    8000358a:	eee080e7          	jalr	-274(ra) # 80003474 <argraw>
    8000358e:	c088                	sw	a0,0(s1)
}
    80003590:	60e2                	ld	ra,24(sp)
    80003592:	6442                	ld	s0,16(sp)
    80003594:	64a2                	ld	s1,8(sp)
    80003596:	6105                	addi	sp,sp,32
    80003598:	8082                	ret

000000008000359a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000359a:	1101                	addi	sp,sp,-32
    8000359c:	ec06                	sd	ra,24(sp)
    8000359e:	e822                	sd	s0,16(sp)
    800035a0:	e426                	sd	s1,8(sp)
    800035a2:	1000                	addi	s0,sp,32
    800035a4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800035a6:	00000097          	auipc	ra,0x0
    800035aa:	ece080e7          	jalr	-306(ra) # 80003474 <argraw>
    800035ae:	e088                	sd	a0,0(s1)
}
    800035b0:	60e2                	ld	ra,24(sp)
    800035b2:	6442                	ld	s0,16(sp)
    800035b4:	64a2                	ld	s1,8(sp)
    800035b6:	6105                	addi	sp,sp,32
    800035b8:	8082                	ret

00000000800035ba <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800035ba:	1101                	addi	sp,sp,-32
    800035bc:	ec06                	sd	ra,24(sp)
    800035be:	e822                	sd	s0,16(sp)
    800035c0:	e426                	sd	s1,8(sp)
    800035c2:	e04a                	sd	s2,0(sp)
    800035c4:	1000                	addi	s0,sp,32
    800035c6:	892e                	mv	s2,a1
    800035c8:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800035ca:	00000097          	auipc	ra,0x0
    800035ce:	eaa080e7          	jalr	-342(ra) # 80003474 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800035d2:	8626                	mv	a2,s1
    800035d4:	85ca                	mv	a1,s2
    800035d6:	00000097          	auipc	ra,0x0
    800035da:	f58080e7          	jalr	-168(ra) # 8000352e <fetchstr>
}
    800035de:	60e2                	ld	ra,24(sp)
    800035e0:	6442                	ld	s0,16(sp)
    800035e2:	64a2                	ld	s1,8(sp)
    800035e4:	6902                	ld	s2,0(sp)
    800035e6:	6105                	addi	sp,sp,32
    800035e8:	8082                	ret

00000000800035ea <syscall>:
[SYS_thread_exit]   sys_thread_exit,
};

void
syscall(void)
{
    800035ea:	1101                	addi	sp,sp,-32
    800035ec:	ec06                	sd	ra,24(sp)
    800035ee:	e822                	sd	s0,16(sp)
    800035f0:	e426                	sd	s1,8(sp)
    800035f2:	e04a                	sd	s2,0(sp)
    800035f4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800035f6:	fffff097          	auipc	ra,0xfffff
    800035fa:	93e080e7          	jalr	-1730(ra) # 80001f34 <myproc>
    800035fe:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003600:	05853903          	ld	s2,88(a0)
    80003604:	0a893783          	ld	a5,168(s2)
    80003608:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000360c:	37fd                	addiw	a5,a5,-1
    8000360e:	4761                	li	a4,24
    80003610:	00f76f63          	bltu	a4,a5,8000362e <syscall+0x44>
    80003614:	00369713          	slli	a4,a3,0x3
    80003618:	00006797          	auipc	a5,0x6
    8000361c:	41078793          	addi	a5,a5,1040 # 80009a28 <syscalls>
    80003620:	97ba                	add	a5,a5,a4
    80003622:	639c                	ld	a5,0(a5)
    80003624:	c789                	beqz	a5,8000362e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003626:	9782                	jalr	a5
    80003628:	06a93823          	sd	a0,112(s2)
    8000362c:	a839                	j	8000364a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000362e:	15848613          	addi	a2,s1,344
    80003632:	588c                	lw	a1,48(s1)
    80003634:	00006517          	auipc	a0,0x6
    80003638:	e8450513          	addi	a0,a0,-380 # 800094b8 <etext+0x4b8>
    8000363c:	ffffd097          	auipc	ra,0xffffd
    80003640:	f6c080e7          	jalr	-148(ra) # 800005a8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003644:	6cbc                	ld	a5,88(s1)
    80003646:	577d                	li	a4,-1
    80003648:	fbb8                	sd	a4,112(a5)
  }
}
    8000364a:	60e2                	ld	ra,24(sp)
    8000364c:	6442                	ld	s0,16(sp)
    8000364e:	64a2                	ld	s1,8(sp)
    80003650:	6902                	ld	s2,0(sp)
    80003652:	6105                	addi	sp,sp,32
    80003654:	8082                	ret

0000000080003656 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003656:	1101                	addi	sp,sp,-32
    80003658:	ec06                	sd	ra,24(sp)
    8000365a:	e822                	sd	s0,16(sp)
    8000365c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000365e:	fec40593          	addi	a1,s0,-20
    80003662:	4501                	li	a0,0
    80003664:	00000097          	auipc	ra,0x0
    80003668:	f16080e7          	jalr	-234(ra) # 8000357a <argint>
  exit(n);
    8000366c:	fec42503          	lw	a0,-20(s0)
    80003670:	fffff097          	auipc	ra,0xfffff
    80003674:	388080e7          	jalr	904(ra) # 800029f8 <exit>
  return 0;  // not reached
}
    80003678:	4501                	li	a0,0
    8000367a:	60e2                	ld	ra,24(sp)
    8000367c:	6442                	ld	s0,16(sp)
    8000367e:	6105                	addi	sp,sp,32
    80003680:	8082                	ret

0000000080003682 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003682:	1141                	addi	sp,sp,-16
    80003684:	e406                	sd	ra,8(sp)
    80003686:	e022                	sd	s0,0(sp)
    80003688:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000368a:	fffff097          	auipc	ra,0xfffff
    8000368e:	8aa080e7          	jalr	-1878(ra) # 80001f34 <myproc>
}
    80003692:	5908                	lw	a0,48(a0)
    80003694:	60a2                	ld	ra,8(sp)
    80003696:	6402                	ld	s0,0(sp)
    80003698:	0141                	addi	sp,sp,16
    8000369a:	8082                	ret

000000008000369c <sys_fork>:

uint64
sys_fork(void)
{
    8000369c:	1141                	addi	sp,sp,-16
    8000369e:	e406                	sd	ra,8(sp)
    800036a0:	e022                	sd	s0,0(sp)
    800036a2:	0800                	addi	s0,sp,16
  return fork();
    800036a4:	fffff097          	auipc	ra,0xfffff
    800036a8:	c94080e7          	jalr	-876(ra) # 80002338 <fork>
}
    800036ac:	60a2                	ld	ra,8(sp)
    800036ae:	6402                	ld	s0,0(sp)
    800036b0:	0141                	addi	sp,sp,16
    800036b2:	8082                	ret

00000000800036b4 <sys_wait>:

uint64
sys_wait(void)
{
    800036b4:	1101                	addi	sp,sp,-32
    800036b6:	ec06                	sd	ra,24(sp)
    800036b8:	e822                	sd	s0,16(sp)
    800036ba:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800036bc:	fe840593          	addi	a1,s0,-24
    800036c0:	4501                	li	a0,0
    800036c2:	00000097          	auipc	ra,0x0
    800036c6:	ed8080e7          	jalr	-296(ra) # 8000359a <argaddr>
  return wait(p);
    800036ca:	fe843503          	ld	a0,-24(s0)
    800036ce:	fffff097          	auipc	ra,0xfffff
    800036d2:	6d4080e7          	jalr	1748(ra) # 80002da2 <wait>
}
    800036d6:	60e2                	ld	ra,24(sp)
    800036d8:	6442                	ld	s0,16(sp)
    800036da:	6105                	addi	sp,sp,32
    800036dc:	8082                	ret

00000000800036de <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800036de:	7179                	addi	sp,sp,-48
    800036e0:	f406                	sd	ra,40(sp)
    800036e2:	f022                	sd	s0,32(sp)
    800036e4:	ec26                	sd	s1,24(sp)
    800036e6:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800036e8:	fdc40593          	addi	a1,s0,-36
    800036ec:	4501                	li	a0,0
    800036ee:	00000097          	auipc	ra,0x0
    800036f2:	e8c080e7          	jalr	-372(ra) # 8000357a <argint>
  addr = myproc()->sz;
    800036f6:	fffff097          	auipc	ra,0xfffff
    800036fa:	83e080e7          	jalr	-1986(ra) # 80001f34 <myproc>
    800036fe:	653c                	ld	a5,72(a0)
    80003700:	84be                	mv	s1,a5
  if(growproc(n) < 0)
    80003702:	fdc42503          	lw	a0,-36(s0)
    80003706:	fffff097          	auipc	ra,0xfffff
    8000370a:	b9c080e7          	jalr	-1124(ra) # 800022a2 <growproc>
    8000370e:	00054863          	bltz	a0,8000371e <sys_sbrk+0x40>
    return -1;
  return addr;
}
    80003712:	8526                	mv	a0,s1
    80003714:	70a2                	ld	ra,40(sp)
    80003716:	7402                	ld	s0,32(sp)
    80003718:	64e2                	ld	s1,24(sp)
    8000371a:	6145                	addi	sp,sp,48
    8000371c:	8082                	ret
    return -1;
    8000371e:	57fd                	li	a5,-1
    80003720:	84be                	mv	s1,a5
    80003722:	bfc5                	j	80003712 <sys_sbrk+0x34>

0000000080003724 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003724:	7139                	addi	sp,sp,-64
    80003726:	fc06                	sd	ra,56(sp)
    80003728:	f822                	sd	s0,48(sp)
    8000372a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000372c:	fcc40593          	addi	a1,s0,-52
    80003730:	4501                	li	a0,0
    80003732:	00000097          	auipc	ra,0x0
    80003736:	e48080e7          	jalr	-440(ra) # 8000357a <argint>
  acquire(&tickslock);
    8000373a:	0005f517          	auipc	a0,0x5f
    8000373e:	54650513          	addi	a0,a0,1350 # 80062c80 <tickslock>
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	5f2080e7          	jalr	1522(ra) # 80000d34 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    8000374a:	fcc42783          	lw	a5,-52(s0)
    8000374e:	cba9                	beqz	a5,800037a0 <sys_sleep+0x7c>
    80003750:	f426                	sd	s1,40(sp)
    80003752:	f04a                	sd	s2,32(sp)
    80003754:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80003756:	00009997          	auipc	s3,0x9
    8000375a:	28a9a983          	lw	s3,650(s3) # 8000c9e0 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000375e:	0005f917          	auipc	s2,0x5f
    80003762:	52290913          	addi	s2,s2,1314 # 80062c80 <tickslock>
    80003766:	00009497          	auipc	s1,0x9
    8000376a:	27a48493          	addi	s1,s1,634 # 8000c9e0 <ticks>
    if(killed(myproc())){
    8000376e:	ffffe097          	auipc	ra,0xffffe
    80003772:	7c6080e7          	jalr	1990(ra) # 80001f34 <myproc>
    80003776:	fffff097          	auipc	ra,0xfffff
    8000377a:	4b8080e7          	jalr	1208(ra) # 80002c2e <killed>
    8000377e:	ed15                	bnez	a0,800037ba <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003780:	85ca                	mv	a1,s2
    80003782:	8526                	mv	a0,s1
    80003784:	fffff097          	auipc	ra,0xfffff
    80003788:	066080e7          	jalr	102(ra) # 800027ea <sleep>
  while(ticks - ticks0 < n){
    8000378c:	409c                	lw	a5,0(s1)
    8000378e:	413787bb          	subw	a5,a5,s3
    80003792:	fcc42703          	lw	a4,-52(s0)
    80003796:	fce7ece3          	bltu	a5,a4,8000376e <sys_sleep+0x4a>
    8000379a:	74a2                	ld	s1,40(sp)
    8000379c:	7902                	ld	s2,32(sp)
    8000379e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800037a0:	0005f517          	auipc	a0,0x5f
    800037a4:	4e050513          	addi	a0,a0,1248 # 80062c80 <tickslock>
    800037a8:	ffffd097          	auipc	ra,0xffffd
    800037ac:	63c080e7          	jalr	1596(ra) # 80000de4 <release>
  return 0;
    800037b0:	4501                	li	a0,0
}
    800037b2:	70e2                	ld	ra,56(sp)
    800037b4:	7442                	ld	s0,48(sp)
    800037b6:	6121                	addi	sp,sp,64
    800037b8:	8082                	ret
      release(&tickslock);
    800037ba:	0005f517          	auipc	a0,0x5f
    800037be:	4c650513          	addi	a0,a0,1222 # 80062c80 <tickslock>
    800037c2:	ffffd097          	auipc	ra,0xffffd
    800037c6:	622080e7          	jalr	1570(ra) # 80000de4 <release>
      return -1;
    800037ca:	557d                	li	a0,-1
    800037cc:	74a2                	ld	s1,40(sp)
    800037ce:	7902                	ld	s2,32(sp)
    800037d0:	69e2                	ld	s3,24(sp)
    800037d2:	b7c5                	j	800037b2 <sys_sleep+0x8e>

00000000800037d4 <sys_kill>:

uint64
sys_kill(void)
{
    800037d4:	1101                	addi	sp,sp,-32
    800037d6:	ec06                	sd	ra,24(sp)
    800037d8:	e822                	sd	s0,16(sp)
    800037da:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800037dc:	fec40593          	addi	a1,s0,-20
    800037e0:	4501                	li	a0,0
    800037e2:	00000097          	auipc	ra,0x0
    800037e6:	d98080e7          	jalr	-616(ra) # 8000357a <argint>
  return kill(pid);
    800037ea:	fec42503          	lw	a0,-20(s0)
    800037ee:	fffff097          	auipc	ra,0xfffff
    800037f2:	3a2080e7          	jalr	930(ra) # 80002b90 <kill>
}
    800037f6:	60e2                	ld	ra,24(sp)
    800037f8:	6442                	ld	s0,16(sp)
    800037fa:	6105                	addi	sp,sp,32
    800037fc:	8082                	ret

00000000800037fe <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800037fe:	1101                	addi	sp,sp,-32
    80003800:	ec06                	sd	ra,24(sp)
    80003802:	e822                	sd	s0,16(sp)
    80003804:	e426                	sd	s1,8(sp)
    80003806:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003808:	0005f517          	auipc	a0,0x5f
    8000380c:	47850513          	addi	a0,a0,1144 # 80062c80 <tickslock>
    80003810:	ffffd097          	auipc	ra,0xffffd
    80003814:	524080e7          	jalr	1316(ra) # 80000d34 <acquire>
  xticks = ticks;
    80003818:	00009797          	auipc	a5,0x9
    8000381c:	1c87a783          	lw	a5,456(a5) # 8000c9e0 <ticks>
    80003820:	84be                	mv	s1,a5
  release(&tickslock);
    80003822:	0005f517          	auipc	a0,0x5f
    80003826:	45e50513          	addi	a0,a0,1118 # 80062c80 <tickslock>
    8000382a:	ffffd097          	auipc	ra,0xffffd
    8000382e:	5ba080e7          	jalr	1466(ra) # 80000de4 <release>
  return xticks;
}
    80003832:	02049513          	slli	a0,s1,0x20
    80003836:	9101                	srli	a0,a0,0x20
    80003838:	60e2                	ld	ra,24(sp)
    8000383a:	6442                	ld	s0,16(sp)
    8000383c:	64a2                	ld	s1,8(sp)
    8000383e:	6105                	addi	sp,sp,32
    80003840:	8082                	ret

0000000080003842 <sys_spoon>:

uint64 sys_spoon(void)
{
    80003842:	1101                	addi	sp,sp,-32
    80003844:	ec06                	sd	ra,24(sp)
    80003846:	e822                	sd	s0,16(sp)
    80003848:	1000                	addi	s0,sp,32
  // obtain the argument from the stack, we need some special handling
  uint64 addr;
  argaddr(0, &addr);
    8000384a:	fe840593          	addi	a1,s0,-24
    8000384e:	4501                	li	a0,0
    80003850:	00000097          	auipc	ra,0x0
    80003854:	d4a080e7          	jalr	-694(ra) # 8000359a <argaddr>
  return spoon((void*)addr);
    80003858:	fe843503          	ld	a0,-24(s0)
    8000385c:	fffff097          	auipc	ra,0xfffff
    80003860:	7ca080e7          	jalr	1994(ra) # 80003026 <spoon>
}
    80003864:	60e2                	ld	ra,24(sp)
    80003866:	6442                	ld	s0,16(sp)
    80003868:	6105                	addi	sp,sp,32
    8000386a:	8082                	ret

000000008000386c <sys_create_thread>:

uint64 sys_create_thread(void* arg) {
    8000386c:	7179                	addi	sp,sp,-48
    8000386e:	f406                	sd	ra,40(sp)
    80003870:	f022                	sd	s0,32(sp)
    80003872:	1800                	addi	s0,sp,48
  uint64 fn_addr, args_addr, stack_addr, exit_fn;
  argaddr(0, &fn_addr);
    80003874:	fe840593          	addi	a1,s0,-24
    80003878:	4501                	li	a0,0
    8000387a:	00000097          	auipc	ra,0x0
    8000387e:	d20080e7          	jalr	-736(ra) # 8000359a <argaddr>
  argaddr(1, &args_addr);
    80003882:	fe040593          	addi	a1,s0,-32
    80003886:	4505                	li	a0,1
    80003888:	00000097          	auipc	ra,0x0
    8000388c:	d12080e7          	jalr	-750(ra) # 8000359a <argaddr>
  argaddr(2, &stack_addr);
    80003890:	fd840593          	addi	a1,s0,-40
    80003894:	4509                	li	a0,2
    80003896:	00000097          	auipc	ra,0x0
    8000389a:	d04080e7          	jalr	-764(ra) # 8000359a <argaddr>
  argaddr(3, &exit_fn);
    8000389e:	fd040593          	addi	a1,s0,-48
    800038a2:	450d                	li	a0,3
    800038a4:	00000097          	auipc	ra,0x0
    800038a8:	cf6080e7          	jalr	-778(ra) # 8000359a <argaddr>
  return create_thread((void*)fn_addr, (void *)args_addr, (void *)stack_addr, (void *)exit_fn);
    800038ac:	fd043683          	ld	a3,-48(s0)
    800038b0:	fd843603          	ld	a2,-40(s0)
    800038b4:	fe043583          	ld	a1,-32(s0)
    800038b8:	fe843503          	ld	a0,-24(s0)
    800038bc:	fffff097          	auipc	ra,0xfffff
    800038c0:	bc2080e7          	jalr	-1086(ra) # 8000247e <create_thread>
}
    800038c4:	70a2                	ld	ra,40(sp)
    800038c6:	7402                	ld	s0,32(sp)
    800038c8:	6145                	addi	sp,sp,48
    800038ca:	8082                	ret

00000000800038cc <sys_join_thread>:

uint64 sys_join_thread(void* arg) {
    800038cc:	1101                	addi	sp,sp,-32
    800038ce:	ec06                	sd	ra,24(sp)
    800038d0:	e822                	sd	s0,16(sp)
    800038d2:	1000                	addi	s0,sp,32
  uint64 thread_id, status_addr;
  argaddr(0, &thread_id);
    800038d4:	fe840593          	addi	a1,s0,-24
    800038d8:	4501                	li	a0,0
    800038da:	00000097          	auipc	ra,0x0
    800038de:	cc0080e7          	jalr	-832(ra) # 8000359a <argaddr>
  argaddr(1, &status_addr);
    800038e2:	fe040593          	addi	a1,s0,-32
    800038e6:	4505                	li	a0,1
    800038e8:	00000097          	auipc	ra,0x0
    800038ec:	cb2080e7          	jalr	-846(ra) # 8000359a <argaddr>
  return join_thread(thread_id, status_addr);
    800038f0:	fe043583          	ld	a1,-32(s0)
    800038f4:	fe843503          	ld	a0,-24(s0)
    800038f8:	fffff097          	auipc	ra,0xfffff
    800038fc:	368080e7          	jalr	872(ra) # 80002c60 <join_thread>
}
    80003900:	60e2                	ld	ra,24(sp)
    80003902:	6442                	ld	s0,16(sp)
    80003904:	6105                	addi	sp,sp,32
    80003906:	8082                	ret

0000000080003908 <sys_thread_exit>:

uint64 sys_thread_exit(void *arg) {
    80003908:	1101                	addi	sp,sp,-32
    8000390a:	ec06                	sd	ra,24(sp)
    8000390c:	e822                	sd	s0,16(sp)
    8000390e:	1000                	addi	s0,sp,32
  uint64 status_addr;
  argaddr(0, &status_addr);
    80003910:	fe840593          	addi	a1,s0,-24
    80003914:	4501                	li	a0,0
    80003916:	00000097          	auipc	ra,0x0
    8000391a:	c84080e7          	jalr	-892(ra) # 8000359a <argaddr>
  return thread_exit(status_addr);
    8000391e:	fe843503          	ld	a0,-24(s0)
    80003922:	fffff097          	auipc	ra,0xfffff
    80003926:	ffc080e7          	jalr	-4(ra) # 8000291e <thread_exit>
}
    8000392a:	60e2                	ld	ra,24(sp)
    8000392c:	6442                	ld	s0,16(sp)
    8000392e:	6105                	addi	sp,sp,32
    80003930:	8082                	ret

0000000080003932 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003932:	7179                	addi	sp,sp,-48
    80003934:	f406                	sd	ra,40(sp)
    80003936:	f022                	sd	s0,32(sp)
    80003938:	ec26                	sd	s1,24(sp)
    8000393a:	e84a                	sd	s2,16(sp)
    8000393c:	e44e                	sd	s3,8(sp)
    8000393e:	e052                	sd	s4,0(sp)
    80003940:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003942:	00006597          	auipc	a1,0x6
    80003946:	b9658593          	addi	a1,a1,-1130 # 800094d8 <etext+0x4d8>
    8000394a:	0005f517          	auipc	a0,0x5f
    8000394e:	34e50513          	addi	a0,a0,846 # 80062c98 <bcache>
    80003952:	ffffd097          	auipc	ra,0xffffd
    80003956:	348080e7          	jalr	840(ra) # 80000c9a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000395a:	00067797          	auipc	a5,0x67
    8000395e:	33e78793          	addi	a5,a5,830 # 8006ac98 <bcache+0x8000>
    80003962:	00067717          	auipc	a4,0x67
    80003966:	59e70713          	addi	a4,a4,1438 # 8006af00 <bcache+0x8268>
    8000396a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000396e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003972:	0005f497          	auipc	s1,0x5f
    80003976:	33e48493          	addi	s1,s1,830 # 80062cb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000397a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000397c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000397e:	00006a17          	auipc	s4,0x6
    80003982:	b62a0a13          	addi	s4,s4,-1182 # 800094e0 <etext+0x4e0>
    b->next = bcache.head.next;
    80003986:	2b893783          	ld	a5,696(s2)
    8000398a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000398c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003990:	85d2                	mv	a1,s4
    80003992:	01048513          	addi	a0,s1,16
    80003996:	00001097          	auipc	ra,0x1
    8000399a:	4ec080e7          	jalr	1260(ra) # 80004e82 <initsleeplock>
    bcache.head.next->prev = b;
    8000399e:	2b893783          	ld	a5,696(s2)
    800039a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800039a4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800039a8:	45848493          	addi	s1,s1,1112
    800039ac:	fd349de3          	bne	s1,s3,80003986 <binit+0x54>
  }
}
    800039b0:	70a2                	ld	ra,40(sp)
    800039b2:	7402                	ld	s0,32(sp)
    800039b4:	64e2                	ld	s1,24(sp)
    800039b6:	6942                	ld	s2,16(sp)
    800039b8:	69a2                	ld	s3,8(sp)
    800039ba:	6a02                	ld	s4,0(sp)
    800039bc:	6145                	addi	sp,sp,48
    800039be:	8082                	ret

00000000800039c0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800039c0:	7179                	addi	sp,sp,-48
    800039c2:	f406                	sd	ra,40(sp)
    800039c4:	f022                	sd	s0,32(sp)
    800039c6:	ec26                	sd	s1,24(sp)
    800039c8:	e84a                	sd	s2,16(sp)
    800039ca:	e44e                	sd	s3,8(sp)
    800039cc:	1800                	addi	s0,sp,48
    800039ce:	892a                	mv	s2,a0
    800039d0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800039d2:	0005f517          	auipc	a0,0x5f
    800039d6:	2c650513          	addi	a0,a0,710 # 80062c98 <bcache>
    800039da:	ffffd097          	auipc	ra,0xffffd
    800039de:	35a080e7          	jalr	858(ra) # 80000d34 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800039e2:	00067497          	auipc	s1,0x67
    800039e6:	56e4b483          	ld	s1,1390(s1) # 8006af50 <bcache+0x82b8>
    800039ea:	00067797          	auipc	a5,0x67
    800039ee:	51678793          	addi	a5,a5,1302 # 8006af00 <bcache+0x8268>
    800039f2:	02f48f63          	beq	s1,a5,80003a30 <bread+0x70>
    800039f6:	873e                	mv	a4,a5
    800039f8:	a021                	j	80003a00 <bread+0x40>
    800039fa:	68a4                	ld	s1,80(s1)
    800039fc:	02e48a63          	beq	s1,a4,80003a30 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003a00:	449c                	lw	a5,8(s1)
    80003a02:	ff279ce3          	bne	a5,s2,800039fa <bread+0x3a>
    80003a06:	44dc                	lw	a5,12(s1)
    80003a08:	ff3799e3          	bne	a5,s3,800039fa <bread+0x3a>
      b->refcnt++;
    80003a0c:	40bc                	lw	a5,64(s1)
    80003a0e:	2785                	addiw	a5,a5,1
    80003a10:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003a12:	0005f517          	auipc	a0,0x5f
    80003a16:	28650513          	addi	a0,a0,646 # 80062c98 <bcache>
    80003a1a:	ffffd097          	auipc	ra,0xffffd
    80003a1e:	3ca080e7          	jalr	970(ra) # 80000de4 <release>
      acquiresleep(&b->lock);
    80003a22:	01048513          	addi	a0,s1,16
    80003a26:	00001097          	auipc	ra,0x1
    80003a2a:	496080e7          	jalr	1174(ra) # 80004ebc <acquiresleep>
      return b;
    80003a2e:	a8b9                	j	80003a8c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003a30:	00067497          	auipc	s1,0x67
    80003a34:	5184b483          	ld	s1,1304(s1) # 8006af48 <bcache+0x82b0>
    80003a38:	00067797          	auipc	a5,0x67
    80003a3c:	4c878793          	addi	a5,a5,1224 # 8006af00 <bcache+0x8268>
    80003a40:	00f48863          	beq	s1,a5,80003a50 <bread+0x90>
    80003a44:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003a46:	40bc                	lw	a5,64(s1)
    80003a48:	cf81                	beqz	a5,80003a60 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003a4a:	64a4                	ld	s1,72(s1)
    80003a4c:	fee49de3          	bne	s1,a4,80003a46 <bread+0x86>
  panic("bget: no buffers");
    80003a50:	00006517          	auipc	a0,0x6
    80003a54:	a9850513          	addi	a0,a0,-1384 # 800094e8 <etext+0x4e8>
    80003a58:	ffffd097          	auipc	ra,0xffffd
    80003a5c:	b06080e7          	jalr	-1274(ra) # 8000055e <panic>
      b->dev = dev;
    80003a60:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003a64:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003a68:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003a6c:	4785                	li	a5,1
    80003a6e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003a70:	0005f517          	auipc	a0,0x5f
    80003a74:	22850513          	addi	a0,a0,552 # 80062c98 <bcache>
    80003a78:	ffffd097          	auipc	ra,0xffffd
    80003a7c:	36c080e7          	jalr	876(ra) # 80000de4 <release>
      acquiresleep(&b->lock);
    80003a80:	01048513          	addi	a0,s1,16
    80003a84:	00001097          	auipc	ra,0x1
    80003a88:	438080e7          	jalr	1080(ra) # 80004ebc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003a8c:	409c                	lw	a5,0(s1)
    80003a8e:	cb89                	beqz	a5,80003aa0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003a90:	8526                	mv	a0,s1
    80003a92:	70a2                	ld	ra,40(sp)
    80003a94:	7402                	ld	s0,32(sp)
    80003a96:	64e2                	ld	s1,24(sp)
    80003a98:	6942                	ld	s2,16(sp)
    80003a9a:	69a2                	ld	s3,8(sp)
    80003a9c:	6145                	addi	sp,sp,48
    80003a9e:	8082                	ret
    virtio_disk_rw(b, 0);
    80003aa0:	4581                	li	a1,0
    80003aa2:	8526                	mv	a0,s1
    80003aa4:	00003097          	auipc	ra,0x3
    80003aa8:	116080e7          	jalr	278(ra) # 80006bba <virtio_disk_rw>
    b->valid = 1;
    80003aac:	4785                	li	a5,1
    80003aae:	c09c                	sw	a5,0(s1)
  return b;
    80003ab0:	b7c5                	j	80003a90 <bread+0xd0>

0000000080003ab2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003ab2:	1101                	addi	sp,sp,-32
    80003ab4:	ec06                	sd	ra,24(sp)
    80003ab6:	e822                	sd	s0,16(sp)
    80003ab8:	e426                	sd	s1,8(sp)
    80003aba:	1000                	addi	s0,sp,32
    80003abc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003abe:	0541                	addi	a0,a0,16
    80003ac0:	00001097          	auipc	ra,0x1
    80003ac4:	496080e7          	jalr	1174(ra) # 80004f56 <holdingsleep>
    80003ac8:	cd01                	beqz	a0,80003ae0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003aca:	4585                	li	a1,1
    80003acc:	8526                	mv	a0,s1
    80003ace:	00003097          	auipc	ra,0x3
    80003ad2:	0ec080e7          	jalr	236(ra) # 80006bba <virtio_disk_rw>
}
    80003ad6:	60e2                	ld	ra,24(sp)
    80003ad8:	6442                	ld	s0,16(sp)
    80003ada:	64a2                	ld	s1,8(sp)
    80003adc:	6105                	addi	sp,sp,32
    80003ade:	8082                	ret
    panic("bwrite");
    80003ae0:	00006517          	auipc	a0,0x6
    80003ae4:	a2050513          	addi	a0,a0,-1504 # 80009500 <etext+0x500>
    80003ae8:	ffffd097          	auipc	ra,0xffffd
    80003aec:	a76080e7          	jalr	-1418(ra) # 8000055e <panic>

0000000080003af0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003af0:	1101                	addi	sp,sp,-32
    80003af2:	ec06                	sd	ra,24(sp)
    80003af4:	e822                	sd	s0,16(sp)
    80003af6:	e426                	sd	s1,8(sp)
    80003af8:	e04a                	sd	s2,0(sp)
    80003afa:	1000                	addi	s0,sp,32
    80003afc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003afe:	01050913          	addi	s2,a0,16
    80003b02:	854a                	mv	a0,s2
    80003b04:	00001097          	auipc	ra,0x1
    80003b08:	452080e7          	jalr	1106(ra) # 80004f56 <holdingsleep>
    80003b0c:	c535                	beqz	a0,80003b78 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003b0e:	854a                	mv	a0,s2
    80003b10:	00001097          	auipc	ra,0x1
    80003b14:	402080e7          	jalr	1026(ra) # 80004f12 <releasesleep>

  acquire(&bcache.lock);
    80003b18:	0005f517          	auipc	a0,0x5f
    80003b1c:	18050513          	addi	a0,a0,384 # 80062c98 <bcache>
    80003b20:	ffffd097          	auipc	ra,0xffffd
    80003b24:	214080e7          	jalr	532(ra) # 80000d34 <acquire>
  b->refcnt--;
    80003b28:	40bc                	lw	a5,64(s1)
    80003b2a:	37fd                	addiw	a5,a5,-1
    80003b2c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003b2e:	e79d                	bnez	a5,80003b5c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003b30:	68b8                	ld	a4,80(s1)
    80003b32:	64bc                	ld	a5,72(s1)
    80003b34:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003b36:	68b8                	ld	a4,80(s1)
    80003b38:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003b3a:	00067797          	auipc	a5,0x67
    80003b3e:	15e78793          	addi	a5,a5,350 # 8006ac98 <bcache+0x8000>
    80003b42:	2b87b703          	ld	a4,696(a5)
    80003b46:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003b48:	00067717          	auipc	a4,0x67
    80003b4c:	3b870713          	addi	a4,a4,952 # 8006af00 <bcache+0x8268>
    80003b50:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003b52:	2b87b703          	ld	a4,696(a5)
    80003b56:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003b58:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003b5c:	0005f517          	auipc	a0,0x5f
    80003b60:	13c50513          	addi	a0,a0,316 # 80062c98 <bcache>
    80003b64:	ffffd097          	auipc	ra,0xffffd
    80003b68:	280080e7          	jalr	640(ra) # 80000de4 <release>
}
    80003b6c:	60e2                	ld	ra,24(sp)
    80003b6e:	6442                	ld	s0,16(sp)
    80003b70:	64a2                	ld	s1,8(sp)
    80003b72:	6902                	ld	s2,0(sp)
    80003b74:	6105                	addi	sp,sp,32
    80003b76:	8082                	ret
    panic("brelse");
    80003b78:	00006517          	auipc	a0,0x6
    80003b7c:	99050513          	addi	a0,a0,-1648 # 80009508 <etext+0x508>
    80003b80:	ffffd097          	auipc	ra,0xffffd
    80003b84:	9de080e7          	jalr	-1570(ra) # 8000055e <panic>

0000000080003b88 <bpin>:

void
bpin(struct buf *b) {
    80003b88:	1101                	addi	sp,sp,-32
    80003b8a:	ec06                	sd	ra,24(sp)
    80003b8c:	e822                	sd	s0,16(sp)
    80003b8e:	e426                	sd	s1,8(sp)
    80003b90:	1000                	addi	s0,sp,32
    80003b92:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003b94:	0005f517          	auipc	a0,0x5f
    80003b98:	10450513          	addi	a0,a0,260 # 80062c98 <bcache>
    80003b9c:	ffffd097          	auipc	ra,0xffffd
    80003ba0:	198080e7          	jalr	408(ra) # 80000d34 <acquire>
  b->refcnt++;
    80003ba4:	40bc                	lw	a5,64(s1)
    80003ba6:	2785                	addiw	a5,a5,1
    80003ba8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003baa:	0005f517          	auipc	a0,0x5f
    80003bae:	0ee50513          	addi	a0,a0,238 # 80062c98 <bcache>
    80003bb2:	ffffd097          	auipc	ra,0xffffd
    80003bb6:	232080e7          	jalr	562(ra) # 80000de4 <release>
}
    80003bba:	60e2                	ld	ra,24(sp)
    80003bbc:	6442                	ld	s0,16(sp)
    80003bbe:	64a2                	ld	s1,8(sp)
    80003bc0:	6105                	addi	sp,sp,32
    80003bc2:	8082                	ret

0000000080003bc4 <bunpin>:

void
bunpin(struct buf *b) {
    80003bc4:	1101                	addi	sp,sp,-32
    80003bc6:	ec06                	sd	ra,24(sp)
    80003bc8:	e822                	sd	s0,16(sp)
    80003bca:	e426                	sd	s1,8(sp)
    80003bcc:	1000                	addi	s0,sp,32
    80003bce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003bd0:	0005f517          	auipc	a0,0x5f
    80003bd4:	0c850513          	addi	a0,a0,200 # 80062c98 <bcache>
    80003bd8:	ffffd097          	auipc	ra,0xffffd
    80003bdc:	15c080e7          	jalr	348(ra) # 80000d34 <acquire>
  b->refcnt--;
    80003be0:	40bc                	lw	a5,64(s1)
    80003be2:	37fd                	addiw	a5,a5,-1
    80003be4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003be6:	0005f517          	auipc	a0,0x5f
    80003bea:	0b250513          	addi	a0,a0,178 # 80062c98 <bcache>
    80003bee:	ffffd097          	auipc	ra,0xffffd
    80003bf2:	1f6080e7          	jalr	502(ra) # 80000de4 <release>
}
    80003bf6:	60e2                	ld	ra,24(sp)
    80003bf8:	6442                	ld	s0,16(sp)
    80003bfa:	64a2                	ld	s1,8(sp)
    80003bfc:	6105                	addi	sp,sp,32
    80003bfe:	8082                	ret

0000000080003c00 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003c00:	1101                	addi	sp,sp,-32
    80003c02:	ec06                	sd	ra,24(sp)
    80003c04:	e822                	sd	s0,16(sp)
    80003c06:	e426                	sd	s1,8(sp)
    80003c08:	e04a                	sd	s2,0(sp)
    80003c0a:	1000                	addi	s0,sp,32
    80003c0c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003c0e:	00d5d79b          	srliw	a5,a1,0xd
    80003c12:	00067597          	auipc	a1,0x67
    80003c16:	7625a583          	lw	a1,1890(a1) # 8006b374 <sb+0x1c>
    80003c1a:	9dbd                	addw	a1,a1,a5
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	da4080e7          	jalr	-604(ra) # 800039c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003c24:	0074f713          	andi	a4,s1,7
    80003c28:	4785                	li	a5,1
    80003c2a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003c2e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003c30:	90d9                	srli	s1,s1,0x36
    80003c32:	00950733          	add	a4,a0,s1
    80003c36:	05874703          	lbu	a4,88(a4)
    80003c3a:	00e7f6b3          	and	a3,a5,a4
    80003c3e:	c69d                	beqz	a3,80003c6c <bfree+0x6c>
    80003c40:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003c42:	94aa                	add	s1,s1,a0
    80003c44:	fff7c793          	not	a5,a5
    80003c48:	8f7d                	and	a4,a4,a5
    80003c4a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003c4e:	00001097          	auipc	ra,0x1
    80003c52:	14e080e7          	jalr	334(ra) # 80004d9c <log_write>
  brelse(bp);
    80003c56:	854a                	mv	a0,s2
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	e98080e7          	jalr	-360(ra) # 80003af0 <brelse>
}
    80003c60:	60e2                	ld	ra,24(sp)
    80003c62:	6442                	ld	s0,16(sp)
    80003c64:	64a2                	ld	s1,8(sp)
    80003c66:	6902                	ld	s2,0(sp)
    80003c68:	6105                	addi	sp,sp,32
    80003c6a:	8082                	ret
    panic("freeing free block");
    80003c6c:	00006517          	auipc	a0,0x6
    80003c70:	8a450513          	addi	a0,a0,-1884 # 80009510 <etext+0x510>
    80003c74:	ffffd097          	auipc	ra,0xffffd
    80003c78:	8ea080e7          	jalr	-1814(ra) # 8000055e <panic>

0000000080003c7c <balloc>:
{
    80003c7c:	715d                	addi	sp,sp,-80
    80003c7e:	e486                	sd	ra,72(sp)
    80003c80:	e0a2                	sd	s0,64(sp)
    80003c82:	fc26                	sd	s1,56(sp)
    80003c84:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003c86:	00067797          	auipc	a5,0x67
    80003c8a:	6d67a783          	lw	a5,1750(a5) # 8006b35c <sb+0x4>
    80003c8e:	10078263          	beqz	a5,80003d92 <balloc+0x116>
    80003c92:	f84a                	sd	s2,48(sp)
    80003c94:	f44e                	sd	s3,40(sp)
    80003c96:	f052                	sd	s4,32(sp)
    80003c98:	ec56                	sd	s5,24(sp)
    80003c9a:	e85a                	sd	s6,16(sp)
    80003c9c:	e45e                	sd	s7,8(sp)
    80003c9e:	e062                	sd	s8,0(sp)
    80003ca0:	8baa                	mv	s7,a0
    80003ca2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003ca4:	00067b17          	auipc	s6,0x67
    80003ca8:	6b4b0b13          	addi	s6,s6,1716 # 8006b358 <sb>
      m = 1 << (bi % 8);
    80003cac:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003cae:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003cb0:	6c09                	lui	s8,0x2
    80003cb2:	a049                	j	80003d34 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003cb4:	97ca                	add	a5,a5,s2
    80003cb6:	8e55                	or	a2,a2,a3
    80003cb8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003cbc:	854a                	mv	a0,s2
    80003cbe:	00001097          	auipc	ra,0x1
    80003cc2:	0de080e7          	jalr	222(ra) # 80004d9c <log_write>
        brelse(bp);
    80003cc6:	854a                	mv	a0,s2
    80003cc8:	00000097          	auipc	ra,0x0
    80003ccc:	e28080e7          	jalr	-472(ra) # 80003af0 <brelse>
  bp = bread(dev, bno);
    80003cd0:	85a6                	mv	a1,s1
    80003cd2:	855e                	mv	a0,s7
    80003cd4:	00000097          	auipc	ra,0x0
    80003cd8:	cec080e7          	jalr	-788(ra) # 800039c0 <bread>
    80003cdc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003cde:	40000613          	li	a2,1024
    80003ce2:	4581                	li	a1,0
    80003ce4:	05850513          	addi	a0,a0,88
    80003ce8:	ffffd097          	auipc	ra,0xffffd
    80003cec:	144080e7          	jalr	324(ra) # 80000e2c <memset>
  log_write(bp);
    80003cf0:	854a                	mv	a0,s2
    80003cf2:	00001097          	auipc	ra,0x1
    80003cf6:	0aa080e7          	jalr	170(ra) # 80004d9c <log_write>
  brelse(bp);
    80003cfa:	854a                	mv	a0,s2
    80003cfc:	00000097          	auipc	ra,0x0
    80003d00:	df4080e7          	jalr	-524(ra) # 80003af0 <brelse>
}
    80003d04:	7942                	ld	s2,48(sp)
    80003d06:	79a2                	ld	s3,40(sp)
    80003d08:	7a02                	ld	s4,32(sp)
    80003d0a:	6ae2                	ld	s5,24(sp)
    80003d0c:	6b42                	ld	s6,16(sp)
    80003d0e:	6ba2                	ld	s7,8(sp)
    80003d10:	6c02                	ld	s8,0(sp)
}
    80003d12:	8526                	mv	a0,s1
    80003d14:	60a6                	ld	ra,72(sp)
    80003d16:	6406                	ld	s0,64(sp)
    80003d18:	74e2                	ld	s1,56(sp)
    80003d1a:	6161                	addi	sp,sp,80
    80003d1c:	8082                	ret
    brelse(bp);
    80003d1e:	854a                	mv	a0,s2
    80003d20:	00000097          	auipc	ra,0x0
    80003d24:	dd0080e7          	jalr	-560(ra) # 80003af0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003d28:	015c0abb          	addw	s5,s8,s5
    80003d2c:	004b2783          	lw	a5,4(s6)
    80003d30:	04fafa63          	bgeu	s5,a5,80003d84 <balloc+0x108>
    bp = bread(dev, BBLOCK(b, sb));
    80003d34:	40dad59b          	sraiw	a1,s5,0xd
    80003d38:	01cb2783          	lw	a5,28(s6)
    80003d3c:	9dbd                	addw	a1,a1,a5
    80003d3e:	855e                	mv	a0,s7
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	c80080e7          	jalr	-896(ra) # 800039c0 <bread>
    80003d48:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003d4a:	004b2503          	lw	a0,4(s6)
    80003d4e:	84d6                	mv	s1,s5
    80003d50:	4701                	li	a4,0
    80003d52:	fca4f6e3          	bgeu	s1,a0,80003d1e <balloc+0xa2>
      m = 1 << (bi % 8);
    80003d56:	00777693          	andi	a3,a4,7
    80003d5a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003d5e:	41f7579b          	sraiw	a5,a4,0x1f
    80003d62:	01d7d79b          	srliw	a5,a5,0x1d
    80003d66:	9fb9                	addw	a5,a5,a4
    80003d68:	4037d79b          	sraiw	a5,a5,0x3
    80003d6c:	00f90633          	add	a2,s2,a5
    80003d70:	05864603          	lbu	a2,88(a2)
    80003d74:	00c6f5b3          	and	a1,a3,a2
    80003d78:	dd95                	beqz	a1,80003cb4 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003d7a:	2705                	addiw	a4,a4,1
    80003d7c:	2485                	addiw	s1,s1,1
    80003d7e:	fd471ae3          	bne	a4,s4,80003d52 <balloc+0xd6>
    80003d82:	bf71                	j	80003d1e <balloc+0xa2>
    80003d84:	7942                	ld	s2,48(sp)
    80003d86:	79a2                	ld	s3,40(sp)
    80003d88:	7a02                	ld	s4,32(sp)
    80003d8a:	6ae2                	ld	s5,24(sp)
    80003d8c:	6b42                	ld	s6,16(sp)
    80003d8e:	6ba2                	ld	s7,8(sp)
    80003d90:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003d92:	00005517          	auipc	a0,0x5
    80003d96:	79650513          	addi	a0,a0,1942 # 80009528 <etext+0x528>
    80003d9a:	ffffd097          	auipc	ra,0xffffd
    80003d9e:	80e080e7          	jalr	-2034(ra) # 800005a8 <printf>
  return 0;
    80003da2:	4481                	li	s1,0
    80003da4:	b7bd                	j	80003d12 <balloc+0x96>

0000000080003da6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003da6:	7179                	addi	sp,sp,-48
    80003da8:	f406                	sd	ra,40(sp)
    80003daa:	f022                	sd	s0,32(sp)
    80003dac:	ec26                	sd	s1,24(sp)
    80003dae:	e84a                	sd	s2,16(sp)
    80003db0:	e44e                	sd	s3,8(sp)
    80003db2:	1800                	addi	s0,sp,48
    80003db4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003db6:	47ad                	li	a5,11
    80003db8:	02b7e563          	bltu	a5,a1,80003de2 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003dbc:	02059793          	slli	a5,a1,0x20
    80003dc0:	01e7d593          	srli	a1,a5,0x1e
    80003dc4:	00b509b3          	add	s3,a0,a1
    80003dc8:	0509a483          	lw	s1,80(s3)
    80003dcc:	e8b5                	bnez	s1,80003e40 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003dce:	4108                	lw	a0,0(a0)
    80003dd0:	00000097          	auipc	ra,0x0
    80003dd4:	eac080e7          	jalr	-340(ra) # 80003c7c <balloc>
    80003dd8:	84aa                	mv	s1,a0
      if(addr == 0)
    80003dda:	c13d                	beqz	a0,80003e40 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003ddc:	04a9a823          	sw	a0,80(s3)
    80003de0:	a085                	j	80003e40 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003de2:	ff45879b          	addiw	a5,a1,-12
    80003de6:	873e                	mv	a4,a5
    80003de8:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80003dea:	0ff00793          	li	a5,255
    80003dee:	08e7e163          	bltu	a5,a4,80003e70 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003df2:	08052483          	lw	s1,128(a0)
    80003df6:	ec81                	bnez	s1,80003e0e <bmap+0x68>
      addr = balloc(ip->dev);
    80003df8:	4108                	lw	a0,0(a0)
    80003dfa:	00000097          	auipc	ra,0x0
    80003dfe:	e82080e7          	jalr	-382(ra) # 80003c7c <balloc>
    80003e02:	84aa                	mv	s1,a0
      if(addr == 0)
    80003e04:	cd15                	beqz	a0,80003e40 <bmap+0x9a>
    80003e06:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003e08:	08a92023          	sw	a0,128(s2)
    80003e0c:	a011                	j	80003e10 <bmap+0x6a>
    80003e0e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003e10:	85a6                	mv	a1,s1
    80003e12:	00092503          	lw	a0,0(s2)
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	baa080e7          	jalr	-1110(ra) # 800039c0 <bread>
    80003e1e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003e20:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003e24:	02099713          	slli	a4,s3,0x20
    80003e28:	01e75593          	srli	a1,a4,0x1e
    80003e2c:	97ae                	add	a5,a5,a1
    80003e2e:	89be                	mv	s3,a5
    80003e30:	4384                	lw	s1,0(a5)
    80003e32:	cc99                	beqz	s1,80003e50 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003e34:	8552                	mv	a0,s4
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	cba080e7          	jalr	-838(ra) # 80003af0 <brelse>
    return addr;
    80003e3e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003e40:	8526                	mv	a0,s1
    80003e42:	70a2                	ld	ra,40(sp)
    80003e44:	7402                	ld	s0,32(sp)
    80003e46:	64e2                	ld	s1,24(sp)
    80003e48:	6942                	ld	s2,16(sp)
    80003e4a:	69a2                	ld	s3,8(sp)
    80003e4c:	6145                	addi	sp,sp,48
    80003e4e:	8082                	ret
      addr = balloc(ip->dev);
    80003e50:	00092503          	lw	a0,0(s2)
    80003e54:	00000097          	auipc	ra,0x0
    80003e58:	e28080e7          	jalr	-472(ra) # 80003c7c <balloc>
    80003e5c:	84aa                	mv	s1,a0
      if(addr){
    80003e5e:	d979                	beqz	a0,80003e34 <bmap+0x8e>
        a[bn] = addr;
    80003e60:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003e64:	8552                	mv	a0,s4
    80003e66:	00001097          	auipc	ra,0x1
    80003e6a:	f36080e7          	jalr	-202(ra) # 80004d9c <log_write>
    80003e6e:	b7d9                	j	80003e34 <bmap+0x8e>
    80003e70:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003e72:	00005517          	auipc	a0,0x5
    80003e76:	6ce50513          	addi	a0,a0,1742 # 80009540 <etext+0x540>
    80003e7a:	ffffc097          	auipc	ra,0xffffc
    80003e7e:	6e4080e7          	jalr	1764(ra) # 8000055e <panic>

0000000080003e82 <iget>:
{
    80003e82:	7179                	addi	sp,sp,-48
    80003e84:	f406                	sd	ra,40(sp)
    80003e86:	f022                	sd	s0,32(sp)
    80003e88:	ec26                	sd	s1,24(sp)
    80003e8a:	e84a                	sd	s2,16(sp)
    80003e8c:	e44e                	sd	s3,8(sp)
    80003e8e:	e052                	sd	s4,0(sp)
    80003e90:	1800                	addi	s0,sp,48
    80003e92:	892a                	mv	s2,a0
    80003e94:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003e96:	00067517          	auipc	a0,0x67
    80003e9a:	4e250513          	addi	a0,a0,1250 # 8006b378 <itable>
    80003e9e:	ffffd097          	auipc	ra,0xffffd
    80003ea2:	e96080e7          	jalr	-362(ra) # 80000d34 <acquire>
  empty = 0;
    80003ea6:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003ea8:	00067497          	auipc	s1,0x67
    80003eac:	4e848493          	addi	s1,s1,1256 # 8006b390 <itable+0x18>
    80003eb0:	00069697          	auipc	a3,0x69
    80003eb4:	f7068693          	addi	a3,a3,-144 # 8006ce20 <log>
    80003eb8:	a809                	j	80003eca <iget+0x48>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003eba:	e781                	bnez	a5,80003ec2 <iget+0x40>
    80003ebc:	00099363          	bnez	s3,80003ec2 <iget+0x40>
      empty = ip;
    80003ec0:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003ec2:	08848493          	addi	s1,s1,136
    80003ec6:	02d48763          	beq	s1,a3,80003ef4 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003eca:	449c                	lw	a5,8(s1)
    80003ecc:	fef057e3          	blez	a5,80003eba <iget+0x38>
    80003ed0:	4098                	lw	a4,0(s1)
    80003ed2:	ff2718e3          	bne	a4,s2,80003ec2 <iget+0x40>
    80003ed6:	40d8                	lw	a4,4(s1)
    80003ed8:	ff4715e3          	bne	a4,s4,80003ec2 <iget+0x40>
      ip->ref++;
    80003edc:	2785                	addiw	a5,a5,1
    80003ede:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003ee0:	00067517          	auipc	a0,0x67
    80003ee4:	49850513          	addi	a0,a0,1176 # 8006b378 <itable>
    80003ee8:	ffffd097          	auipc	ra,0xffffd
    80003eec:	efc080e7          	jalr	-260(ra) # 80000de4 <release>
      return ip;
    80003ef0:	89a6                	mv	s3,s1
    80003ef2:	a025                	j	80003f1a <iget+0x98>
  if(empty == 0)
    80003ef4:	02098c63          	beqz	s3,80003f2c <iget+0xaa>
  ip->dev = dev;
    80003ef8:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003efc:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003f00:	4785                	li	a5,1
    80003f02:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003f06:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003f0a:	00067517          	auipc	a0,0x67
    80003f0e:	46e50513          	addi	a0,a0,1134 # 8006b378 <itable>
    80003f12:	ffffd097          	auipc	ra,0xffffd
    80003f16:	ed2080e7          	jalr	-302(ra) # 80000de4 <release>
}
    80003f1a:	854e                	mv	a0,s3
    80003f1c:	70a2                	ld	ra,40(sp)
    80003f1e:	7402                	ld	s0,32(sp)
    80003f20:	64e2                	ld	s1,24(sp)
    80003f22:	6942                	ld	s2,16(sp)
    80003f24:	69a2                	ld	s3,8(sp)
    80003f26:	6a02                	ld	s4,0(sp)
    80003f28:	6145                	addi	sp,sp,48
    80003f2a:	8082                	ret
    panic("iget: no inodes");
    80003f2c:	00005517          	auipc	a0,0x5
    80003f30:	62c50513          	addi	a0,a0,1580 # 80009558 <etext+0x558>
    80003f34:	ffffc097          	auipc	ra,0xffffc
    80003f38:	62a080e7          	jalr	1578(ra) # 8000055e <panic>

0000000080003f3c <fsinit>:
fsinit(int dev) {
    80003f3c:	1101                	addi	sp,sp,-32
    80003f3e:	ec06                	sd	ra,24(sp)
    80003f40:	e822                	sd	s0,16(sp)
    80003f42:	e426                	sd	s1,8(sp)
    80003f44:	e04a                	sd	s2,0(sp)
    80003f46:	1000                	addi	s0,sp,32
    80003f48:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003f4a:	4585                	li	a1,1
    80003f4c:	00000097          	auipc	ra,0x0
    80003f50:	a74080e7          	jalr	-1420(ra) # 800039c0 <bread>
    80003f54:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003f56:	02000613          	li	a2,32
    80003f5a:	05850593          	addi	a1,a0,88
    80003f5e:	00067517          	auipc	a0,0x67
    80003f62:	3fa50513          	addi	a0,a0,1018 # 8006b358 <sb>
    80003f66:	ffffd097          	auipc	ra,0xffffd
    80003f6a:	f26080e7          	jalr	-218(ra) # 80000e8c <memmove>
  brelse(bp);
    80003f6e:	8526                	mv	a0,s1
    80003f70:	00000097          	auipc	ra,0x0
    80003f74:	b80080e7          	jalr	-1152(ra) # 80003af0 <brelse>
  if(sb.magic != FSMAGIC)
    80003f78:	00067717          	auipc	a4,0x67
    80003f7c:	3e072703          	lw	a4,992(a4) # 8006b358 <sb>
    80003f80:	102037b7          	lui	a5,0x10203
    80003f84:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003f88:	02f71163          	bne	a4,a5,80003faa <fsinit+0x6e>
  initlog(dev, &sb);
    80003f8c:	00067597          	auipc	a1,0x67
    80003f90:	3cc58593          	addi	a1,a1,972 # 8006b358 <sb>
    80003f94:	854a                	mv	a0,s2
    80003f96:	00001097          	auipc	ra,0x1
    80003f9a:	b80080e7          	jalr	-1152(ra) # 80004b16 <initlog>
}
    80003f9e:	60e2                	ld	ra,24(sp)
    80003fa0:	6442                	ld	s0,16(sp)
    80003fa2:	64a2                	ld	s1,8(sp)
    80003fa4:	6902                	ld	s2,0(sp)
    80003fa6:	6105                	addi	sp,sp,32
    80003fa8:	8082                	ret
    panic("invalid file system");
    80003faa:	00005517          	auipc	a0,0x5
    80003fae:	5be50513          	addi	a0,a0,1470 # 80009568 <etext+0x568>
    80003fb2:	ffffc097          	auipc	ra,0xffffc
    80003fb6:	5ac080e7          	jalr	1452(ra) # 8000055e <panic>

0000000080003fba <iinit>:
{
    80003fba:	7179                	addi	sp,sp,-48
    80003fbc:	f406                	sd	ra,40(sp)
    80003fbe:	f022                	sd	s0,32(sp)
    80003fc0:	ec26                	sd	s1,24(sp)
    80003fc2:	e84a                	sd	s2,16(sp)
    80003fc4:	e44e                	sd	s3,8(sp)
    80003fc6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003fc8:	00005597          	auipc	a1,0x5
    80003fcc:	5b858593          	addi	a1,a1,1464 # 80009580 <etext+0x580>
    80003fd0:	00067517          	auipc	a0,0x67
    80003fd4:	3a850513          	addi	a0,a0,936 # 8006b378 <itable>
    80003fd8:	ffffd097          	auipc	ra,0xffffd
    80003fdc:	cc2080e7          	jalr	-830(ra) # 80000c9a <initlock>
  for(i = 0; i < NINODE; i++) {
    80003fe0:	00067497          	auipc	s1,0x67
    80003fe4:	3c048493          	addi	s1,s1,960 # 8006b3a0 <itable+0x28>
    80003fe8:	00069997          	auipc	s3,0x69
    80003fec:	e4898993          	addi	s3,s3,-440 # 8006ce30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003ff0:	00005917          	auipc	s2,0x5
    80003ff4:	59890913          	addi	s2,s2,1432 # 80009588 <etext+0x588>
    80003ff8:	85ca                	mv	a1,s2
    80003ffa:	8526                	mv	a0,s1
    80003ffc:	00001097          	auipc	ra,0x1
    80004000:	e86080e7          	jalr	-378(ra) # 80004e82 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004004:	08848493          	addi	s1,s1,136
    80004008:	ff3498e3          	bne	s1,s3,80003ff8 <iinit+0x3e>
}
    8000400c:	70a2                	ld	ra,40(sp)
    8000400e:	7402                	ld	s0,32(sp)
    80004010:	64e2                	ld	s1,24(sp)
    80004012:	6942                	ld	s2,16(sp)
    80004014:	69a2                	ld	s3,8(sp)
    80004016:	6145                	addi	sp,sp,48
    80004018:	8082                	ret

000000008000401a <ialloc>:
{
    8000401a:	7139                	addi	sp,sp,-64
    8000401c:	fc06                	sd	ra,56(sp)
    8000401e:	f822                	sd	s0,48(sp)
    80004020:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80004022:	00067717          	auipc	a4,0x67
    80004026:	34272703          	lw	a4,834(a4) # 8006b364 <sb+0xc>
    8000402a:	4785                	li	a5,1
    8000402c:	06e7f463          	bgeu	a5,a4,80004094 <ialloc+0x7a>
    80004030:	f426                	sd	s1,40(sp)
    80004032:	f04a                	sd	s2,32(sp)
    80004034:	ec4e                	sd	s3,24(sp)
    80004036:	e852                	sd	s4,16(sp)
    80004038:	e456                	sd	s5,8(sp)
    8000403a:	e05a                	sd	s6,0(sp)
    8000403c:	8aaa                	mv	s5,a0
    8000403e:	8b2e                	mv	s6,a1
    80004040:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80004042:	00067a17          	auipc	s4,0x67
    80004046:	316a0a13          	addi	s4,s4,790 # 8006b358 <sb>
    8000404a:	00495593          	srli	a1,s2,0x4
    8000404e:	018a2783          	lw	a5,24(s4)
    80004052:	9dbd                	addw	a1,a1,a5
    80004054:	8556                	mv	a0,s5
    80004056:	00000097          	auipc	ra,0x0
    8000405a:	96a080e7          	jalr	-1686(ra) # 800039c0 <bread>
    8000405e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80004060:	05850993          	addi	s3,a0,88
    80004064:	00f97793          	andi	a5,s2,15
    80004068:	079a                	slli	a5,a5,0x6
    8000406a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000406c:	00099783          	lh	a5,0(s3)
    80004070:	cf9d                	beqz	a5,800040ae <ialloc+0x94>
    brelse(bp);
    80004072:	00000097          	auipc	ra,0x0
    80004076:	a7e080e7          	jalr	-1410(ra) # 80003af0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000407a:	0905                	addi	s2,s2,1
    8000407c:	00ca2703          	lw	a4,12(s4)
    80004080:	0009079b          	sext.w	a5,s2
    80004084:	fce7e3e3          	bltu	a5,a4,8000404a <ialloc+0x30>
    80004088:	74a2                	ld	s1,40(sp)
    8000408a:	7902                	ld	s2,32(sp)
    8000408c:	69e2                	ld	s3,24(sp)
    8000408e:	6a42                	ld	s4,16(sp)
    80004090:	6aa2                	ld	s5,8(sp)
    80004092:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80004094:	00005517          	auipc	a0,0x5
    80004098:	4fc50513          	addi	a0,a0,1276 # 80009590 <etext+0x590>
    8000409c:	ffffc097          	auipc	ra,0xffffc
    800040a0:	50c080e7          	jalr	1292(ra) # 800005a8 <printf>
  return 0;
    800040a4:	4501                	li	a0,0
}
    800040a6:	70e2                	ld	ra,56(sp)
    800040a8:	7442                	ld	s0,48(sp)
    800040aa:	6121                	addi	sp,sp,64
    800040ac:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800040ae:	04000613          	li	a2,64
    800040b2:	4581                	li	a1,0
    800040b4:	854e                	mv	a0,s3
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	d76080e7          	jalr	-650(ra) # 80000e2c <memset>
      dip->type = type;
    800040be:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800040c2:	8526                	mv	a0,s1
    800040c4:	00001097          	auipc	ra,0x1
    800040c8:	cd8080e7          	jalr	-808(ra) # 80004d9c <log_write>
      brelse(bp);
    800040cc:	8526                	mv	a0,s1
    800040ce:	00000097          	auipc	ra,0x0
    800040d2:	a22080e7          	jalr	-1502(ra) # 80003af0 <brelse>
      return iget(dev, inum);
    800040d6:	0009059b          	sext.w	a1,s2
    800040da:	8556                	mv	a0,s5
    800040dc:	00000097          	auipc	ra,0x0
    800040e0:	da6080e7          	jalr	-602(ra) # 80003e82 <iget>
    800040e4:	74a2                	ld	s1,40(sp)
    800040e6:	7902                	ld	s2,32(sp)
    800040e8:	69e2                	ld	s3,24(sp)
    800040ea:	6a42                	ld	s4,16(sp)
    800040ec:	6aa2                	ld	s5,8(sp)
    800040ee:	6b02                	ld	s6,0(sp)
    800040f0:	bf5d                	j	800040a6 <ialloc+0x8c>

00000000800040f2 <iupdate>:
{
    800040f2:	1101                	addi	sp,sp,-32
    800040f4:	ec06                	sd	ra,24(sp)
    800040f6:	e822                	sd	s0,16(sp)
    800040f8:	e426                	sd	s1,8(sp)
    800040fa:	e04a                	sd	s2,0(sp)
    800040fc:	1000                	addi	s0,sp,32
    800040fe:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004100:	415c                	lw	a5,4(a0)
    80004102:	0047d79b          	srliw	a5,a5,0x4
    80004106:	00067597          	auipc	a1,0x67
    8000410a:	26a5a583          	lw	a1,618(a1) # 8006b370 <sb+0x18>
    8000410e:	9dbd                	addw	a1,a1,a5
    80004110:	4108                	lw	a0,0(a0)
    80004112:	00000097          	auipc	ra,0x0
    80004116:	8ae080e7          	jalr	-1874(ra) # 800039c0 <bread>
    8000411a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000411c:	05850793          	addi	a5,a0,88
    80004120:	40d8                	lw	a4,4(s1)
    80004122:	8b3d                	andi	a4,a4,15
    80004124:	071a                	slli	a4,a4,0x6
    80004126:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80004128:	04449703          	lh	a4,68(s1)
    8000412c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004130:	04649703          	lh	a4,70(s1)
    80004134:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004138:	04849703          	lh	a4,72(s1)
    8000413c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004140:	04a49703          	lh	a4,74(s1)
    80004144:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004148:	44f8                	lw	a4,76(s1)
    8000414a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000414c:	03400613          	li	a2,52
    80004150:	05048593          	addi	a1,s1,80
    80004154:	00c78513          	addi	a0,a5,12
    80004158:	ffffd097          	auipc	ra,0xffffd
    8000415c:	d34080e7          	jalr	-716(ra) # 80000e8c <memmove>
  log_write(bp);
    80004160:	854a                	mv	a0,s2
    80004162:	00001097          	auipc	ra,0x1
    80004166:	c3a080e7          	jalr	-966(ra) # 80004d9c <log_write>
  brelse(bp);
    8000416a:	854a                	mv	a0,s2
    8000416c:	00000097          	auipc	ra,0x0
    80004170:	984080e7          	jalr	-1660(ra) # 80003af0 <brelse>
}
    80004174:	60e2                	ld	ra,24(sp)
    80004176:	6442                	ld	s0,16(sp)
    80004178:	64a2                	ld	s1,8(sp)
    8000417a:	6902                	ld	s2,0(sp)
    8000417c:	6105                	addi	sp,sp,32
    8000417e:	8082                	ret

0000000080004180 <idup>:
{
    80004180:	1101                	addi	sp,sp,-32
    80004182:	ec06                	sd	ra,24(sp)
    80004184:	e822                	sd	s0,16(sp)
    80004186:	e426                	sd	s1,8(sp)
    80004188:	1000                	addi	s0,sp,32
    8000418a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000418c:	00067517          	auipc	a0,0x67
    80004190:	1ec50513          	addi	a0,a0,492 # 8006b378 <itable>
    80004194:	ffffd097          	auipc	ra,0xffffd
    80004198:	ba0080e7          	jalr	-1120(ra) # 80000d34 <acquire>
  ip->ref++;
    8000419c:	449c                	lw	a5,8(s1)
    8000419e:	2785                	addiw	a5,a5,1
    800041a0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800041a2:	00067517          	auipc	a0,0x67
    800041a6:	1d650513          	addi	a0,a0,470 # 8006b378 <itable>
    800041aa:	ffffd097          	auipc	ra,0xffffd
    800041ae:	c3a080e7          	jalr	-966(ra) # 80000de4 <release>
}
    800041b2:	8526                	mv	a0,s1
    800041b4:	60e2                	ld	ra,24(sp)
    800041b6:	6442                	ld	s0,16(sp)
    800041b8:	64a2                	ld	s1,8(sp)
    800041ba:	6105                	addi	sp,sp,32
    800041bc:	8082                	ret

00000000800041be <ilock>:
{
    800041be:	1101                	addi	sp,sp,-32
    800041c0:	ec06                	sd	ra,24(sp)
    800041c2:	e822                	sd	s0,16(sp)
    800041c4:	e426                	sd	s1,8(sp)
    800041c6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800041c8:	c10d                	beqz	a0,800041ea <ilock+0x2c>
    800041ca:	84aa                	mv	s1,a0
    800041cc:	451c                	lw	a5,8(a0)
    800041ce:	00f05e63          	blez	a5,800041ea <ilock+0x2c>
  acquiresleep(&ip->lock);
    800041d2:	0541                	addi	a0,a0,16
    800041d4:	00001097          	auipc	ra,0x1
    800041d8:	ce8080e7          	jalr	-792(ra) # 80004ebc <acquiresleep>
  if(ip->valid == 0){
    800041dc:	40bc                	lw	a5,64(s1)
    800041de:	cf99                	beqz	a5,800041fc <ilock+0x3e>
}
    800041e0:	60e2                	ld	ra,24(sp)
    800041e2:	6442                	ld	s0,16(sp)
    800041e4:	64a2                	ld	s1,8(sp)
    800041e6:	6105                	addi	sp,sp,32
    800041e8:	8082                	ret
    800041ea:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800041ec:	00005517          	auipc	a0,0x5
    800041f0:	3bc50513          	addi	a0,a0,956 # 800095a8 <etext+0x5a8>
    800041f4:	ffffc097          	auipc	ra,0xffffc
    800041f8:	36a080e7          	jalr	874(ra) # 8000055e <panic>
    800041fc:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800041fe:	40dc                	lw	a5,4(s1)
    80004200:	0047d79b          	srliw	a5,a5,0x4
    80004204:	00067597          	auipc	a1,0x67
    80004208:	16c5a583          	lw	a1,364(a1) # 8006b370 <sb+0x18>
    8000420c:	9dbd                	addw	a1,a1,a5
    8000420e:	4088                	lw	a0,0(s1)
    80004210:	fffff097          	auipc	ra,0xfffff
    80004214:	7b0080e7          	jalr	1968(ra) # 800039c0 <bread>
    80004218:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000421a:	05850593          	addi	a1,a0,88
    8000421e:	40dc                	lw	a5,4(s1)
    80004220:	8bbd                	andi	a5,a5,15
    80004222:	079a                	slli	a5,a5,0x6
    80004224:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80004226:	00059783          	lh	a5,0(a1)
    8000422a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000422e:	00259783          	lh	a5,2(a1)
    80004232:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004236:	00459783          	lh	a5,4(a1)
    8000423a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000423e:	00659783          	lh	a5,6(a1)
    80004242:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004246:	459c                	lw	a5,8(a1)
    80004248:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000424a:	03400613          	li	a2,52
    8000424e:	05b1                	addi	a1,a1,12
    80004250:	05048513          	addi	a0,s1,80
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	c38080e7          	jalr	-968(ra) # 80000e8c <memmove>
    brelse(bp);
    8000425c:	854a                	mv	a0,s2
    8000425e:	00000097          	auipc	ra,0x0
    80004262:	892080e7          	jalr	-1902(ra) # 80003af0 <brelse>
    ip->valid = 1;
    80004266:	4785                	li	a5,1
    80004268:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000426a:	04449783          	lh	a5,68(s1)
    8000426e:	c399                	beqz	a5,80004274 <ilock+0xb6>
    80004270:	6902                	ld	s2,0(sp)
    80004272:	b7bd                	j	800041e0 <ilock+0x22>
      panic("ilock: no type");
    80004274:	00005517          	auipc	a0,0x5
    80004278:	33c50513          	addi	a0,a0,828 # 800095b0 <etext+0x5b0>
    8000427c:	ffffc097          	auipc	ra,0xffffc
    80004280:	2e2080e7          	jalr	738(ra) # 8000055e <panic>

0000000080004284 <iunlock>:
{
    80004284:	1101                	addi	sp,sp,-32
    80004286:	ec06                	sd	ra,24(sp)
    80004288:	e822                	sd	s0,16(sp)
    8000428a:	e426                	sd	s1,8(sp)
    8000428c:	e04a                	sd	s2,0(sp)
    8000428e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004290:	c905                	beqz	a0,800042c0 <iunlock+0x3c>
    80004292:	84aa                	mv	s1,a0
    80004294:	01050913          	addi	s2,a0,16
    80004298:	854a                	mv	a0,s2
    8000429a:	00001097          	auipc	ra,0x1
    8000429e:	cbc080e7          	jalr	-836(ra) # 80004f56 <holdingsleep>
    800042a2:	cd19                	beqz	a0,800042c0 <iunlock+0x3c>
    800042a4:	449c                	lw	a5,8(s1)
    800042a6:	00f05d63          	blez	a5,800042c0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800042aa:	854a                	mv	a0,s2
    800042ac:	00001097          	auipc	ra,0x1
    800042b0:	c66080e7          	jalr	-922(ra) # 80004f12 <releasesleep>
}
    800042b4:	60e2                	ld	ra,24(sp)
    800042b6:	6442                	ld	s0,16(sp)
    800042b8:	64a2                	ld	s1,8(sp)
    800042ba:	6902                	ld	s2,0(sp)
    800042bc:	6105                	addi	sp,sp,32
    800042be:	8082                	ret
    panic("iunlock");
    800042c0:	00005517          	auipc	a0,0x5
    800042c4:	30050513          	addi	a0,a0,768 # 800095c0 <etext+0x5c0>
    800042c8:	ffffc097          	auipc	ra,0xffffc
    800042cc:	296080e7          	jalr	662(ra) # 8000055e <panic>

00000000800042d0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800042d0:	7179                	addi	sp,sp,-48
    800042d2:	f406                	sd	ra,40(sp)
    800042d4:	f022                	sd	s0,32(sp)
    800042d6:	ec26                	sd	s1,24(sp)
    800042d8:	e84a                	sd	s2,16(sp)
    800042da:	e44e                	sd	s3,8(sp)
    800042dc:	1800                	addi	s0,sp,48
    800042de:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800042e0:	05050493          	addi	s1,a0,80
    800042e4:	08050913          	addi	s2,a0,128
    800042e8:	a021                	j	800042f0 <itrunc+0x20>
    800042ea:	0491                	addi	s1,s1,4
    800042ec:	01248d63          	beq	s1,s2,80004306 <itrunc+0x36>
    if(ip->addrs[i]){
    800042f0:	408c                	lw	a1,0(s1)
    800042f2:	dde5                	beqz	a1,800042ea <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800042f4:	0009a503          	lw	a0,0(s3)
    800042f8:	00000097          	auipc	ra,0x0
    800042fc:	908080e7          	jalr	-1784(ra) # 80003c00 <bfree>
      ip->addrs[i] = 0;
    80004300:	0004a023          	sw	zero,0(s1)
    80004304:	b7dd                	j	800042ea <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004306:	0809a583          	lw	a1,128(s3)
    8000430a:	ed99                	bnez	a1,80004328 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000430c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004310:	854e                	mv	a0,s3
    80004312:	00000097          	auipc	ra,0x0
    80004316:	de0080e7          	jalr	-544(ra) # 800040f2 <iupdate>
}
    8000431a:	70a2                	ld	ra,40(sp)
    8000431c:	7402                	ld	s0,32(sp)
    8000431e:	64e2                	ld	s1,24(sp)
    80004320:	6942                	ld	s2,16(sp)
    80004322:	69a2                	ld	s3,8(sp)
    80004324:	6145                	addi	sp,sp,48
    80004326:	8082                	ret
    80004328:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000432a:	0009a503          	lw	a0,0(s3)
    8000432e:	fffff097          	auipc	ra,0xfffff
    80004332:	692080e7          	jalr	1682(ra) # 800039c0 <bread>
    80004336:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004338:	05850493          	addi	s1,a0,88
    8000433c:	45850913          	addi	s2,a0,1112
    80004340:	a021                	j	80004348 <itrunc+0x78>
    80004342:	0491                	addi	s1,s1,4
    80004344:	01248b63          	beq	s1,s2,8000435a <itrunc+0x8a>
      if(a[j])
    80004348:	408c                	lw	a1,0(s1)
    8000434a:	dde5                	beqz	a1,80004342 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    8000434c:	0009a503          	lw	a0,0(s3)
    80004350:	00000097          	auipc	ra,0x0
    80004354:	8b0080e7          	jalr	-1872(ra) # 80003c00 <bfree>
    80004358:	b7ed                	j	80004342 <itrunc+0x72>
    brelse(bp);
    8000435a:	8552                	mv	a0,s4
    8000435c:	fffff097          	auipc	ra,0xfffff
    80004360:	794080e7          	jalr	1940(ra) # 80003af0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004364:	0809a583          	lw	a1,128(s3)
    80004368:	0009a503          	lw	a0,0(s3)
    8000436c:	00000097          	auipc	ra,0x0
    80004370:	894080e7          	jalr	-1900(ra) # 80003c00 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004374:	0809a023          	sw	zero,128(s3)
    80004378:	6a02                	ld	s4,0(sp)
    8000437a:	bf49                	j	8000430c <itrunc+0x3c>

000000008000437c <iput>:
{
    8000437c:	1101                	addi	sp,sp,-32
    8000437e:	ec06                	sd	ra,24(sp)
    80004380:	e822                	sd	s0,16(sp)
    80004382:	e426                	sd	s1,8(sp)
    80004384:	1000                	addi	s0,sp,32
    80004386:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004388:	00067517          	auipc	a0,0x67
    8000438c:	ff050513          	addi	a0,a0,-16 # 8006b378 <itable>
    80004390:	ffffd097          	auipc	ra,0xffffd
    80004394:	9a4080e7          	jalr	-1628(ra) # 80000d34 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004398:	4498                	lw	a4,8(s1)
    8000439a:	4785                	li	a5,1
    8000439c:	02f70263          	beq	a4,a5,800043c0 <iput+0x44>
  ip->ref--;
    800043a0:	449c                	lw	a5,8(s1)
    800043a2:	37fd                	addiw	a5,a5,-1
    800043a4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800043a6:	00067517          	auipc	a0,0x67
    800043aa:	fd250513          	addi	a0,a0,-46 # 8006b378 <itable>
    800043ae:	ffffd097          	auipc	ra,0xffffd
    800043b2:	a36080e7          	jalr	-1482(ra) # 80000de4 <release>
}
    800043b6:	60e2                	ld	ra,24(sp)
    800043b8:	6442                	ld	s0,16(sp)
    800043ba:	64a2                	ld	s1,8(sp)
    800043bc:	6105                	addi	sp,sp,32
    800043be:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800043c0:	40bc                	lw	a5,64(s1)
    800043c2:	dff9                	beqz	a5,800043a0 <iput+0x24>
    800043c4:	04a49783          	lh	a5,74(s1)
    800043c8:	ffe1                	bnez	a5,800043a0 <iput+0x24>
    800043ca:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800043cc:	01048793          	addi	a5,s1,16
    800043d0:	893e                	mv	s2,a5
    800043d2:	853e                	mv	a0,a5
    800043d4:	00001097          	auipc	ra,0x1
    800043d8:	ae8080e7          	jalr	-1304(ra) # 80004ebc <acquiresleep>
    release(&itable.lock);
    800043dc:	00067517          	auipc	a0,0x67
    800043e0:	f9c50513          	addi	a0,a0,-100 # 8006b378 <itable>
    800043e4:	ffffd097          	auipc	ra,0xffffd
    800043e8:	a00080e7          	jalr	-1536(ra) # 80000de4 <release>
    itrunc(ip);
    800043ec:	8526                	mv	a0,s1
    800043ee:	00000097          	auipc	ra,0x0
    800043f2:	ee2080e7          	jalr	-286(ra) # 800042d0 <itrunc>
    ip->type = 0;
    800043f6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800043fa:	8526                	mv	a0,s1
    800043fc:	00000097          	auipc	ra,0x0
    80004400:	cf6080e7          	jalr	-778(ra) # 800040f2 <iupdate>
    ip->valid = 0;
    80004404:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004408:	854a                	mv	a0,s2
    8000440a:	00001097          	auipc	ra,0x1
    8000440e:	b08080e7          	jalr	-1272(ra) # 80004f12 <releasesleep>
    acquire(&itable.lock);
    80004412:	00067517          	auipc	a0,0x67
    80004416:	f6650513          	addi	a0,a0,-154 # 8006b378 <itable>
    8000441a:	ffffd097          	auipc	ra,0xffffd
    8000441e:	91a080e7          	jalr	-1766(ra) # 80000d34 <acquire>
    80004422:	6902                	ld	s2,0(sp)
    80004424:	bfb5                	j	800043a0 <iput+0x24>

0000000080004426 <iunlockput>:
{
    80004426:	1101                	addi	sp,sp,-32
    80004428:	ec06                	sd	ra,24(sp)
    8000442a:	e822                	sd	s0,16(sp)
    8000442c:	e426                	sd	s1,8(sp)
    8000442e:	1000                	addi	s0,sp,32
    80004430:	84aa                	mv	s1,a0
  iunlock(ip);
    80004432:	00000097          	auipc	ra,0x0
    80004436:	e52080e7          	jalr	-430(ra) # 80004284 <iunlock>
  iput(ip);
    8000443a:	8526                	mv	a0,s1
    8000443c:	00000097          	auipc	ra,0x0
    80004440:	f40080e7          	jalr	-192(ra) # 8000437c <iput>
}
    80004444:	60e2                	ld	ra,24(sp)
    80004446:	6442                	ld	s0,16(sp)
    80004448:	64a2                	ld	s1,8(sp)
    8000444a:	6105                	addi	sp,sp,32
    8000444c:	8082                	ret

000000008000444e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000444e:	1141                	addi	sp,sp,-16
    80004450:	e406                	sd	ra,8(sp)
    80004452:	e022                	sd	s0,0(sp)
    80004454:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004456:	411c                	lw	a5,0(a0)
    80004458:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000445a:	415c                	lw	a5,4(a0)
    8000445c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000445e:	04451783          	lh	a5,68(a0)
    80004462:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004466:	04a51783          	lh	a5,74(a0)
    8000446a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000446e:	04c56783          	lwu	a5,76(a0)
    80004472:	e99c                	sd	a5,16(a1)
}
    80004474:	60a2                	ld	ra,8(sp)
    80004476:	6402                	ld	s0,0(sp)
    80004478:	0141                	addi	sp,sp,16
    8000447a:	8082                	ret

000000008000447c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000447c:	457c                	lw	a5,76(a0)
    8000447e:	10d7e063          	bltu	a5,a3,8000457e <readi+0x102>
{
    80004482:	7159                	addi	sp,sp,-112
    80004484:	f486                	sd	ra,104(sp)
    80004486:	f0a2                	sd	s0,96(sp)
    80004488:	eca6                	sd	s1,88(sp)
    8000448a:	e0d2                	sd	s4,64(sp)
    8000448c:	fc56                	sd	s5,56(sp)
    8000448e:	f85a                	sd	s6,48(sp)
    80004490:	f45e                	sd	s7,40(sp)
    80004492:	1880                	addi	s0,sp,112
    80004494:	8b2a                	mv	s6,a0
    80004496:	8bae                	mv	s7,a1
    80004498:	8a32                	mv	s4,a2
    8000449a:	84b6                	mv	s1,a3
    8000449c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000449e:	9f35                	addw	a4,a4,a3
    return 0;
    800044a0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800044a2:	0cd76563          	bltu	a4,a3,8000456c <readi+0xf0>
    800044a6:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800044a8:	00e7f463          	bgeu	a5,a4,800044b0 <readi+0x34>
    n = ip->size - off;
    800044ac:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800044b0:	0a0a8563          	beqz	s5,8000455a <readi+0xde>
    800044b4:	e8ca                	sd	s2,80(sp)
    800044b6:	f062                	sd	s8,32(sp)
    800044b8:	ec66                	sd	s9,24(sp)
    800044ba:	e86a                	sd	s10,16(sp)
    800044bc:	e46e                	sd	s11,8(sp)
    800044be:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800044c0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800044c4:	5c7d                	li	s8,-1
    800044c6:	a82d                	j	80004500 <readi+0x84>
    800044c8:	020d1d93          	slli	s11,s10,0x20
    800044cc:	020ddd93          	srli	s11,s11,0x20
    800044d0:	05890613          	addi	a2,s2,88
    800044d4:	86ee                	mv	a3,s11
    800044d6:	963e                	add	a2,a2,a5
    800044d8:	85d2                	mv	a1,s4
    800044da:	855e                	mv	a0,s7
    800044dc:	fffff097          	auipc	ra,0xfffff
    800044e0:	9ee080e7          	jalr	-1554(ra) # 80002eca <either_copyout>
    800044e4:	05850963          	beq	a0,s8,80004536 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800044e8:	854a                	mv	a0,s2
    800044ea:	fffff097          	auipc	ra,0xfffff
    800044ee:	606080e7          	jalr	1542(ra) # 80003af0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800044f2:	013d09bb          	addw	s3,s10,s3
    800044f6:	009d04bb          	addw	s1,s10,s1
    800044fa:	9a6e                	add	s4,s4,s11
    800044fc:	0559f963          	bgeu	s3,s5,8000454e <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80004500:	00a4d59b          	srliw	a1,s1,0xa
    80004504:	855a                	mv	a0,s6
    80004506:	00000097          	auipc	ra,0x0
    8000450a:	8a0080e7          	jalr	-1888(ra) # 80003da6 <bmap>
    8000450e:	85aa                	mv	a1,a0
    if(addr == 0)
    80004510:	c539                	beqz	a0,8000455e <readi+0xe2>
    bp = bread(ip->dev, addr);
    80004512:	000b2503          	lw	a0,0(s6)
    80004516:	fffff097          	auipc	ra,0xfffff
    8000451a:	4aa080e7          	jalr	1194(ra) # 800039c0 <bread>
    8000451e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004520:	3ff4f793          	andi	a5,s1,1023
    80004524:	40fc873b          	subw	a4,s9,a5
    80004528:	413a86bb          	subw	a3,s5,s3
    8000452c:	8d3a                	mv	s10,a4
    8000452e:	f8e6fde3          	bgeu	a3,a4,800044c8 <readi+0x4c>
    80004532:	8d36                	mv	s10,a3
    80004534:	bf51                	j	800044c8 <readi+0x4c>
      brelse(bp);
    80004536:	854a                	mv	a0,s2
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	5b8080e7          	jalr	1464(ra) # 80003af0 <brelse>
      tot = -1;
    80004540:	59fd                	li	s3,-1
      break;
    80004542:	6946                	ld	s2,80(sp)
    80004544:	7c02                	ld	s8,32(sp)
    80004546:	6ce2                	ld	s9,24(sp)
    80004548:	6d42                	ld	s10,16(sp)
    8000454a:	6da2                	ld	s11,8(sp)
    8000454c:	a831                	j	80004568 <readi+0xec>
    8000454e:	6946                	ld	s2,80(sp)
    80004550:	7c02                	ld	s8,32(sp)
    80004552:	6ce2                	ld	s9,24(sp)
    80004554:	6d42                	ld	s10,16(sp)
    80004556:	6da2                	ld	s11,8(sp)
    80004558:	a801                	j	80004568 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000455a:	89d6                	mv	s3,s5
    8000455c:	a031                	j	80004568 <readi+0xec>
    8000455e:	6946                	ld	s2,80(sp)
    80004560:	7c02                	ld	s8,32(sp)
    80004562:	6ce2                	ld	s9,24(sp)
    80004564:	6d42                	ld	s10,16(sp)
    80004566:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004568:	854e                	mv	a0,s3
    8000456a:	69a6                	ld	s3,72(sp)
}
    8000456c:	70a6                	ld	ra,104(sp)
    8000456e:	7406                	ld	s0,96(sp)
    80004570:	64e6                	ld	s1,88(sp)
    80004572:	6a06                	ld	s4,64(sp)
    80004574:	7ae2                	ld	s5,56(sp)
    80004576:	7b42                	ld	s6,48(sp)
    80004578:	7ba2                	ld	s7,40(sp)
    8000457a:	6165                	addi	sp,sp,112
    8000457c:	8082                	ret
    return 0;
    8000457e:	4501                	li	a0,0
}
    80004580:	8082                	ret

0000000080004582 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004582:	457c                	lw	a5,76(a0)
    80004584:	10d7e963          	bltu	a5,a3,80004696 <writei+0x114>
{
    80004588:	7159                	addi	sp,sp,-112
    8000458a:	f486                	sd	ra,104(sp)
    8000458c:	f0a2                	sd	s0,96(sp)
    8000458e:	e8ca                	sd	s2,80(sp)
    80004590:	e0d2                	sd	s4,64(sp)
    80004592:	fc56                	sd	s5,56(sp)
    80004594:	f85a                	sd	s6,48(sp)
    80004596:	f45e                	sd	s7,40(sp)
    80004598:	1880                	addi	s0,sp,112
    8000459a:	8aaa                	mv	s5,a0
    8000459c:	8bae                	mv	s7,a1
    8000459e:	8a32                	mv	s4,a2
    800045a0:	8936                	mv	s2,a3
    800045a2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800045a4:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800045a8:	00043737          	lui	a4,0x43
    800045ac:	0ef76763          	bltu	a4,a5,8000469a <writei+0x118>
    800045b0:	0ed7e563          	bltu	a5,a3,8000469a <writei+0x118>
    800045b4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800045b6:	0c0b0863          	beqz	s6,80004686 <writei+0x104>
    800045ba:	eca6                	sd	s1,88(sp)
    800045bc:	f062                	sd	s8,32(sp)
    800045be:	ec66                	sd	s9,24(sp)
    800045c0:	e86a                	sd	s10,16(sp)
    800045c2:	e46e                	sd	s11,8(sp)
    800045c4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800045c6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800045ca:	5c7d                	li	s8,-1
    800045cc:	a091                	j	80004610 <writei+0x8e>
    800045ce:	020d1d93          	slli	s11,s10,0x20
    800045d2:	020ddd93          	srli	s11,s11,0x20
    800045d6:	05848513          	addi	a0,s1,88
    800045da:	86ee                	mv	a3,s11
    800045dc:	8652                	mv	a2,s4
    800045de:	85de                	mv	a1,s7
    800045e0:	953e                	add	a0,a0,a5
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	93e080e7          	jalr	-1730(ra) # 80002f20 <either_copyin>
    800045ea:	05850e63          	beq	a0,s8,80004646 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    800045ee:	8526                	mv	a0,s1
    800045f0:	00000097          	auipc	ra,0x0
    800045f4:	7ac080e7          	jalr	1964(ra) # 80004d9c <log_write>
    brelse(bp);
    800045f8:	8526                	mv	a0,s1
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	4f6080e7          	jalr	1270(ra) # 80003af0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004602:	013d09bb          	addw	s3,s10,s3
    80004606:	012d093b          	addw	s2,s10,s2
    8000460a:	9a6e                	add	s4,s4,s11
    8000460c:	0569f263          	bgeu	s3,s6,80004650 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80004610:	00a9559b          	srliw	a1,s2,0xa
    80004614:	8556                	mv	a0,s5
    80004616:	fffff097          	auipc	ra,0xfffff
    8000461a:	790080e7          	jalr	1936(ra) # 80003da6 <bmap>
    8000461e:	85aa                	mv	a1,a0
    if(addr == 0)
    80004620:	c905                	beqz	a0,80004650 <writei+0xce>
    bp = bread(ip->dev, addr);
    80004622:	000aa503          	lw	a0,0(s5)
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	39a080e7          	jalr	922(ra) # 800039c0 <bread>
    8000462e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004630:	3ff97793          	andi	a5,s2,1023
    80004634:	40fc873b          	subw	a4,s9,a5
    80004638:	413b06bb          	subw	a3,s6,s3
    8000463c:	8d3a                	mv	s10,a4
    8000463e:	f8e6f8e3          	bgeu	a3,a4,800045ce <writei+0x4c>
    80004642:	8d36                	mv	s10,a3
    80004644:	b769                	j	800045ce <writei+0x4c>
      brelse(bp);
    80004646:	8526                	mv	a0,s1
    80004648:	fffff097          	auipc	ra,0xfffff
    8000464c:	4a8080e7          	jalr	1192(ra) # 80003af0 <brelse>
  }

  if(off > ip->size)
    80004650:	04caa783          	lw	a5,76(s5)
    80004654:	0327fb63          	bgeu	a5,s2,8000468a <writei+0x108>
    ip->size = off;
    80004658:	052aa623          	sw	s2,76(s5)
    8000465c:	64e6                	ld	s1,88(sp)
    8000465e:	7c02                	ld	s8,32(sp)
    80004660:	6ce2                	ld	s9,24(sp)
    80004662:	6d42                	ld	s10,16(sp)
    80004664:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004666:	8556                	mv	a0,s5
    80004668:	00000097          	auipc	ra,0x0
    8000466c:	a8a080e7          	jalr	-1398(ra) # 800040f2 <iupdate>

  return tot;
    80004670:	854e                	mv	a0,s3
    80004672:	69a6                	ld	s3,72(sp)
}
    80004674:	70a6                	ld	ra,104(sp)
    80004676:	7406                	ld	s0,96(sp)
    80004678:	6946                	ld	s2,80(sp)
    8000467a:	6a06                	ld	s4,64(sp)
    8000467c:	7ae2                	ld	s5,56(sp)
    8000467e:	7b42                	ld	s6,48(sp)
    80004680:	7ba2                	ld	s7,40(sp)
    80004682:	6165                	addi	sp,sp,112
    80004684:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004686:	89da                	mv	s3,s6
    80004688:	bff9                	j	80004666 <writei+0xe4>
    8000468a:	64e6                	ld	s1,88(sp)
    8000468c:	7c02                	ld	s8,32(sp)
    8000468e:	6ce2                	ld	s9,24(sp)
    80004690:	6d42                	ld	s10,16(sp)
    80004692:	6da2                	ld	s11,8(sp)
    80004694:	bfc9                	j	80004666 <writei+0xe4>
    return -1;
    80004696:	557d                	li	a0,-1
}
    80004698:	8082                	ret
    return -1;
    8000469a:	557d                	li	a0,-1
    8000469c:	bfe1                	j	80004674 <writei+0xf2>

000000008000469e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000469e:	1141                	addi	sp,sp,-16
    800046a0:	e406                	sd	ra,8(sp)
    800046a2:	e022                	sd	s0,0(sp)
    800046a4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800046a6:	4639                	li	a2,14
    800046a8:	ffffd097          	auipc	ra,0xffffd
    800046ac:	85c080e7          	jalr	-1956(ra) # 80000f04 <strncmp>
}
    800046b0:	60a2                	ld	ra,8(sp)
    800046b2:	6402                	ld	s0,0(sp)
    800046b4:	0141                	addi	sp,sp,16
    800046b6:	8082                	ret

00000000800046b8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800046b8:	711d                	addi	sp,sp,-96
    800046ba:	ec86                	sd	ra,88(sp)
    800046bc:	e8a2                	sd	s0,80(sp)
    800046be:	e4a6                	sd	s1,72(sp)
    800046c0:	e0ca                	sd	s2,64(sp)
    800046c2:	fc4e                	sd	s3,56(sp)
    800046c4:	f852                	sd	s4,48(sp)
    800046c6:	f456                	sd	s5,40(sp)
    800046c8:	f05a                	sd	s6,32(sp)
    800046ca:	ec5e                	sd	s7,24(sp)
    800046cc:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800046ce:	04451703          	lh	a4,68(a0)
    800046d2:	4785                	li	a5,1
    800046d4:	00f71f63          	bne	a4,a5,800046f2 <dirlookup+0x3a>
    800046d8:	892a                	mv	s2,a0
    800046da:	8aae                	mv	s5,a1
    800046dc:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800046de:	457c                	lw	a5,76(a0)
    800046e0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800046e2:	fa040a13          	addi	s4,s0,-96
    800046e6:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800046e8:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800046ec:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800046ee:	e79d                	bnez	a5,8000471c <dirlookup+0x64>
    800046f0:	a88d                	j	80004762 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    800046f2:	00005517          	auipc	a0,0x5
    800046f6:	ed650513          	addi	a0,a0,-298 # 800095c8 <etext+0x5c8>
    800046fa:	ffffc097          	auipc	ra,0xffffc
    800046fe:	e64080e7          	jalr	-412(ra) # 8000055e <panic>
      panic("dirlookup read");
    80004702:	00005517          	auipc	a0,0x5
    80004706:	ede50513          	addi	a0,a0,-290 # 800095e0 <etext+0x5e0>
    8000470a:	ffffc097          	auipc	ra,0xffffc
    8000470e:	e54080e7          	jalr	-428(ra) # 8000055e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004712:	24c1                	addiw	s1,s1,16
    80004714:	04c92783          	lw	a5,76(s2)
    80004718:	04f4f463          	bgeu	s1,a5,80004760 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000471c:	874e                	mv	a4,s3
    8000471e:	86a6                	mv	a3,s1
    80004720:	8652                	mv	a2,s4
    80004722:	4581                	li	a1,0
    80004724:	854a                	mv	a0,s2
    80004726:	00000097          	auipc	ra,0x0
    8000472a:	d56080e7          	jalr	-682(ra) # 8000447c <readi>
    8000472e:	fd351ae3          	bne	a0,s3,80004702 <dirlookup+0x4a>
    if(de.inum == 0)
    80004732:	fa045783          	lhu	a5,-96(s0)
    80004736:	dff1                	beqz	a5,80004712 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80004738:	85da                	mv	a1,s6
    8000473a:	8556                	mv	a0,s5
    8000473c:	00000097          	auipc	ra,0x0
    80004740:	f62080e7          	jalr	-158(ra) # 8000469e <namecmp>
    80004744:	f579                	bnez	a0,80004712 <dirlookup+0x5a>
      if(poff)
    80004746:	000b8463          	beqz	s7,8000474e <dirlookup+0x96>
        *poff = off;
    8000474a:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000474e:	fa045583          	lhu	a1,-96(s0)
    80004752:	00092503          	lw	a0,0(s2)
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	72c080e7          	jalr	1836(ra) # 80003e82 <iget>
    8000475e:	a011                	j	80004762 <dirlookup+0xaa>
  return 0;
    80004760:	4501                	li	a0,0
}
    80004762:	60e6                	ld	ra,88(sp)
    80004764:	6446                	ld	s0,80(sp)
    80004766:	64a6                	ld	s1,72(sp)
    80004768:	6906                	ld	s2,64(sp)
    8000476a:	79e2                	ld	s3,56(sp)
    8000476c:	7a42                	ld	s4,48(sp)
    8000476e:	7aa2                	ld	s5,40(sp)
    80004770:	7b02                	ld	s6,32(sp)
    80004772:	6be2                	ld	s7,24(sp)
    80004774:	6125                	addi	sp,sp,96
    80004776:	8082                	ret

0000000080004778 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004778:	711d                	addi	sp,sp,-96
    8000477a:	ec86                	sd	ra,88(sp)
    8000477c:	e8a2                	sd	s0,80(sp)
    8000477e:	e4a6                	sd	s1,72(sp)
    80004780:	e0ca                	sd	s2,64(sp)
    80004782:	fc4e                	sd	s3,56(sp)
    80004784:	f852                	sd	s4,48(sp)
    80004786:	f456                	sd	s5,40(sp)
    80004788:	f05a                	sd	s6,32(sp)
    8000478a:	ec5e                	sd	s7,24(sp)
    8000478c:	e862                	sd	s8,16(sp)
    8000478e:	e466                	sd	s9,8(sp)
    80004790:	e06a                	sd	s10,0(sp)
    80004792:	1080                	addi	s0,sp,96
    80004794:	84aa                	mv	s1,a0
    80004796:	8b2e                	mv	s6,a1
    80004798:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000479a:	00054703          	lbu	a4,0(a0)
    8000479e:	02f00793          	li	a5,47
    800047a2:	02f70363          	beq	a4,a5,800047c8 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800047a6:	ffffd097          	auipc	ra,0xffffd
    800047aa:	78e080e7          	jalr	1934(ra) # 80001f34 <myproc>
    800047ae:	15053503          	ld	a0,336(a0)
    800047b2:	00000097          	auipc	ra,0x0
    800047b6:	9ce080e7          	jalr	-1586(ra) # 80004180 <idup>
    800047ba:	8a2a                	mv	s4,a0
  while(*path == '/')
    800047bc:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    800047c0:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800047c2:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800047c4:	4b85                	li	s7,1
    800047c6:	a87d                	j	80004884 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800047c8:	4585                	li	a1,1
    800047ca:	852e                	mv	a0,a1
    800047cc:	fffff097          	auipc	ra,0xfffff
    800047d0:	6b6080e7          	jalr	1718(ra) # 80003e82 <iget>
    800047d4:	8a2a                	mv	s4,a0
    800047d6:	b7dd                	j	800047bc <namex+0x44>
      iunlockput(ip);
    800047d8:	8552                	mv	a0,s4
    800047da:	00000097          	auipc	ra,0x0
    800047de:	c4c080e7          	jalr	-948(ra) # 80004426 <iunlockput>
      return 0;
    800047e2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800047e4:	8552                	mv	a0,s4
    800047e6:	60e6                	ld	ra,88(sp)
    800047e8:	6446                	ld	s0,80(sp)
    800047ea:	64a6                	ld	s1,72(sp)
    800047ec:	6906                	ld	s2,64(sp)
    800047ee:	79e2                	ld	s3,56(sp)
    800047f0:	7a42                	ld	s4,48(sp)
    800047f2:	7aa2                	ld	s5,40(sp)
    800047f4:	7b02                	ld	s6,32(sp)
    800047f6:	6be2                	ld	s7,24(sp)
    800047f8:	6c42                	ld	s8,16(sp)
    800047fa:	6ca2                	ld	s9,8(sp)
    800047fc:	6d02                	ld	s10,0(sp)
    800047fe:	6125                	addi	sp,sp,96
    80004800:	8082                	ret
      iunlock(ip);
    80004802:	8552                	mv	a0,s4
    80004804:	00000097          	auipc	ra,0x0
    80004808:	a80080e7          	jalr	-1408(ra) # 80004284 <iunlock>
      return ip;
    8000480c:	bfe1                	j	800047e4 <namex+0x6c>
      iunlockput(ip);
    8000480e:	8552                	mv	a0,s4
    80004810:	00000097          	auipc	ra,0x0
    80004814:	c16080e7          	jalr	-1002(ra) # 80004426 <iunlockput>
      return 0;
    80004818:	8a4a                	mv	s4,s2
    8000481a:	b7e9                	j	800047e4 <namex+0x6c>
  len = path - s;
    8000481c:	40990633          	sub	a2,s2,s1
    80004820:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004824:	09ac5c63          	bge	s8,s10,800048bc <namex+0x144>
    memmove(name, s, DIRSIZ);
    80004828:	8666                	mv	a2,s9
    8000482a:	85a6                	mv	a1,s1
    8000482c:	8556                	mv	a0,s5
    8000482e:	ffffc097          	auipc	ra,0xffffc
    80004832:	65e080e7          	jalr	1630(ra) # 80000e8c <memmove>
    80004836:	84ca                	mv	s1,s2
  while(*path == '/')
    80004838:	0004c783          	lbu	a5,0(s1)
    8000483c:	01379763          	bne	a5,s3,8000484a <namex+0xd2>
    path++;
    80004840:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004842:	0004c783          	lbu	a5,0(s1)
    80004846:	ff378de3          	beq	a5,s3,80004840 <namex+0xc8>
    ilock(ip);
    8000484a:	8552                	mv	a0,s4
    8000484c:	00000097          	auipc	ra,0x0
    80004850:	972080e7          	jalr	-1678(ra) # 800041be <ilock>
    if(ip->type != T_DIR){
    80004854:	044a1783          	lh	a5,68(s4)
    80004858:	f97790e3          	bne	a5,s7,800047d8 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000485c:	000b0563          	beqz	s6,80004866 <namex+0xee>
    80004860:	0004c783          	lbu	a5,0(s1)
    80004864:	dfd9                	beqz	a5,80004802 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004866:	4601                	li	a2,0
    80004868:	85d6                	mv	a1,s5
    8000486a:	8552                	mv	a0,s4
    8000486c:	00000097          	auipc	ra,0x0
    80004870:	e4c080e7          	jalr	-436(ra) # 800046b8 <dirlookup>
    80004874:	892a                	mv	s2,a0
    80004876:	dd41                	beqz	a0,8000480e <namex+0x96>
    iunlockput(ip);
    80004878:	8552                	mv	a0,s4
    8000487a:	00000097          	auipc	ra,0x0
    8000487e:	bac080e7          	jalr	-1108(ra) # 80004426 <iunlockput>
    ip = next;
    80004882:	8a4a                	mv	s4,s2
  while(*path == '/')
    80004884:	0004c783          	lbu	a5,0(s1)
    80004888:	01379763          	bne	a5,s3,80004896 <namex+0x11e>
    path++;
    8000488c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000488e:	0004c783          	lbu	a5,0(s1)
    80004892:	ff378de3          	beq	a5,s3,8000488c <namex+0x114>
  if(*path == 0)
    80004896:	cf9d                	beqz	a5,800048d4 <namex+0x15c>
  while(*path != '/' && *path != 0)
    80004898:	0004c783          	lbu	a5,0(s1)
    8000489c:	fd178713          	addi	a4,a5,-47
    800048a0:	cb19                	beqz	a4,800048b6 <namex+0x13e>
    800048a2:	cb91                	beqz	a5,800048b6 <namex+0x13e>
    800048a4:	8926                	mv	s2,s1
    path++;
    800048a6:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    800048a8:	00094783          	lbu	a5,0(s2)
    800048ac:	fd178713          	addi	a4,a5,-47
    800048b0:	d735                	beqz	a4,8000481c <namex+0xa4>
    800048b2:	fbf5                	bnez	a5,800048a6 <namex+0x12e>
    800048b4:	b7a5                	j	8000481c <namex+0xa4>
    800048b6:	8926                	mv	s2,s1
  len = path - s;
    800048b8:	4d01                	li	s10,0
    800048ba:	4601                	li	a2,0
    memmove(name, s, len);
    800048bc:	2601                	sext.w	a2,a2
    800048be:	85a6                	mv	a1,s1
    800048c0:	8556                	mv	a0,s5
    800048c2:	ffffc097          	auipc	ra,0xffffc
    800048c6:	5ca080e7          	jalr	1482(ra) # 80000e8c <memmove>
    name[len] = 0;
    800048ca:	9d56                	add	s10,s10,s5
    800048cc:	000d0023          	sb	zero,0(s10)
    800048d0:	84ca                	mv	s1,s2
    800048d2:	b79d                	j	80004838 <namex+0xc0>
  if(nameiparent){
    800048d4:	f00b08e3          	beqz	s6,800047e4 <namex+0x6c>
    iput(ip);
    800048d8:	8552                	mv	a0,s4
    800048da:	00000097          	auipc	ra,0x0
    800048de:	aa2080e7          	jalr	-1374(ra) # 8000437c <iput>
    return 0;
    800048e2:	4a01                	li	s4,0
    800048e4:	b701                	j	800047e4 <namex+0x6c>

00000000800048e6 <dirlink>:
{
    800048e6:	715d                	addi	sp,sp,-80
    800048e8:	e486                	sd	ra,72(sp)
    800048ea:	e0a2                	sd	s0,64(sp)
    800048ec:	f84a                	sd	s2,48(sp)
    800048ee:	ec56                	sd	s5,24(sp)
    800048f0:	e85a                	sd	s6,16(sp)
    800048f2:	0880                	addi	s0,sp,80
    800048f4:	892a                	mv	s2,a0
    800048f6:	8aae                	mv	s5,a1
    800048f8:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800048fa:	4601                	li	a2,0
    800048fc:	00000097          	auipc	ra,0x0
    80004900:	dbc080e7          	jalr	-580(ra) # 800046b8 <dirlookup>
    80004904:	e129                	bnez	a0,80004946 <dirlink+0x60>
    80004906:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004908:	04c92483          	lw	s1,76(s2)
    8000490c:	cca9                	beqz	s1,80004966 <dirlink+0x80>
    8000490e:	f44e                	sd	s3,40(sp)
    80004910:	f052                	sd	s4,32(sp)
    80004912:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004914:	fb040a13          	addi	s4,s0,-80
    80004918:	49c1                	li	s3,16
    8000491a:	874e                	mv	a4,s3
    8000491c:	86a6                	mv	a3,s1
    8000491e:	8652                	mv	a2,s4
    80004920:	4581                	li	a1,0
    80004922:	854a                	mv	a0,s2
    80004924:	00000097          	auipc	ra,0x0
    80004928:	b58080e7          	jalr	-1192(ra) # 8000447c <readi>
    8000492c:	03351363          	bne	a0,s3,80004952 <dirlink+0x6c>
    if(de.inum == 0)
    80004930:	fb045783          	lhu	a5,-80(s0)
    80004934:	c79d                	beqz	a5,80004962 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004936:	24c1                	addiw	s1,s1,16
    80004938:	04c92783          	lw	a5,76(s2)
    8000493c:	fcf4efe3          	bltu	s1,a5,8000491a <dirlink+0x34>
    80004940:	79a2                	ld	s3,40(sp)
    80004942:	7a02                	ld	s4,32(sp)
    80004944:	a00d                	j	80004966 <dirlink+0x80>
    iput(ip);
    80004946:	00000097          	auipc	ra,0x0
    8000494a:	a36080e7          	jalr	-1482(ra) # 8000437c <iput>
    return -1;
    8000494e:	557d                	li	a0,-1
    80004950:	a0a9                	j	8000499a <dirlink+0xb4>
      panic("dirlink read");
    80004952:	00005517          	auipc	a0,0x5
    80004956:	c9e50513          	addi	a0,a0,-866 # 800095f0 <etext+0x5f0>
    8000495a:	ffffc097          	auipc	ra,0xffffc
    8000495e:	c04080e7          	jalr	-1020(ra) # 8000055e <panic>
    80004962:	79a2                	ld	s3,40(sp)
    80004964:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004966:	4639                	li	a2,14
    80004968:	85d6                	mv	a1,s5
    8000496a:	fb240513          	addi	a0,s0,-78
    8000496e:	ffffc097          	auipc	ra,0xffffc
    80004972:	5d0080e7          	jalr	1488(ra) # 80000f3e <strncpy>
  de.inum = inum;
    80004976:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000497a:	4741                	li	a4,16
    8000497c:	86a6                	mv	a3,s1
    8000497e:	fb040613          	addi	a2,s0,-80
    80004982:	4581                	li	a1,0
    80004984:	854a                	mv	a0,s2
    80004986:	00000097          	auipc	ra,0x0
    8000498a:	bfc080e7          	jalr	-1028(ra) # 80004582 <writei>
    8000498e:	1541                	addi	a0,a0,-16
    80004990:	00a03533          	snez	a0,a0
    80004994:	40a0053b          	negw	a0,a0
    80004998:	74e2                	ld	s1,56(sp)
}
    8000499a:	60a6                	ld	ra,72(sp)
    8000499c:	6406                	ld	s0,64(sp)
    8000499e:	7942                	ld	s2,48(sp)
    800049a0:	6ae2                	ld	s5,24(sp)
    800049a2:	6b42                	ld	s6,16(sp)
    800049a4:	6161                	addi	sp,sp,80
    800049a6:	8082                	ret

00000000800049a8 <namei>:

struct inode*
namei(char *path)
{
    800049a8:	1101                	addi	sp,sp,-32
    800049aa:	ec06                	sd	ra,24(sp)
    800049ac:	e822                	sd	s0,16(sp)
    800049ae:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800049b0:	fe040613          	addi	a2,s0,-32
    800049b4:	4581                	li	a1,0
    800049b6:	00000097          	auipc	ra,0x0
    800049ba:	dc2080e7          	jalr	-574(ra) # 80004778 <namex>
}
    800049be:	60e2                	ld	ra,24(sp)
    800049c0:	6442                	ld	s0,16(sp)
    800049c2:	6105                	addi	sp,sp,32
    800049c4:	8082                	ret

00000000800049c6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800049c6:	1141                	addi	sp,sp,-16
    800049c8:	e406                	sd	ra,8(sp)
    800049ca:	e022                	sd	s0,0(sp)
    800049cc:	0800                	addi	s0,sp,16
    800049ce:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800049d0:	4585                	li	a1,1
    800049d2:	00000097          	auipc	ra,0x0
    800049d6:	da6080e7          	jalr	-602(ra) # 80004778 <namex>
}
    800049da:	60a2                	ld	ra,8(sp)
    800049dc:	6402                	ld	s0,0(sp)
    800049de:	0141                	addi	sp,sp,16
    800049e0:	8082                	ret

00000000800049e2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800049e2:	1101                	addi	sp,sp,-32
    800049e4:	ec06                	sd	ra,24(sp)
    800049e6:	e822                	sd	s0,16(sp)
    800049e8:	e426                	sd	s1,8(sp)
    800049ea:	e04a                	sd	s2,0(sp)
    800049ec:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800049ee:	00068917          	auipc	s2,0x68
    800049f2:	43290913          	addi	s2,s2,1074 # 8006ce20 <log>
    800049f6:	01892583          	lw	a1,24(s2)
    800049fa:	02892503          	lw	a0,40(s2)
    800049fe:	fffff097          	auipc	ra,0xfffff
    80004a02:	fc2080e7          	jalr	-62(ra) # 800039c0 <bread>
    80004a06:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004a08:	02c92603          	lw	a2,44(s2)
    80004a0c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004a0e:	00c05f63          	blez	a2,80004a2c <write_head+0x4a>
    80004a12:	00068717          	auipc	a4,0x68
    80004a16:	43e70713          	addi	a4,a4,1086 # 8006ce50 <log+0x30>
    80004a1a:	87aa                	mv	a5,a0
    80004a1c:	060a                	slli	a2,a2,0x2
    80004a1e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004a20:	4314                	lw	a3,0(a4)
    80004a22:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004a24:	0711                	addi	a4,a4,4
    80004a26:	0791                	addi	a5,a5,4
    80004a28:	fec79ce3          	bne	a5,a2,80004a20 <write_head+0x3e>
  }
  bwrite(buf);
    80004a2c:	8526                	mv	a0,s1
    80004a2e:	fffff097          	auipc	ra,0xfffff
    80004a32:	084080e7          	jalr	132(ra) # 80003ab2 <bwrite>
  brelse(buf);
    80004a36:	8526                	mv	a0,s1
    80004a38:	fffff097          	auipc	ra,0xfffff
    80004a3c:	0b8080e7          	jalr	184(ra) # 80003af0 <brelse>
}
    80004a40:	60e2                	ld	ra,24(sp)
    80004a42:	6442                	ld	s0,16(sp)
    80004a44:	64a2                	ld	s1,8(sp)
    80004a46:	6902                	ld	s2,0(sp)
    80004a48:	6105                	addi	sp,sp,32
    80004a4a:	8082                	ret

0000000080004a4c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a4c:	00068797          	auipc	a5,0x68
    80004a50:	4007a783          	lw	a5,1024(a5) # 8006ce4c <log+0x2c>
    80004a54:	0cf05063          	blez	a5,80004b14 <install_trans+0xc8>
{
    80004a58:	715d                	addi	sp,sp,-80
    80004a5a:	e486                	sd	ra,72(sp)
    80004a5c:	e0a2                	sd	s0,64(sp)
    80004a5e:	fc26                	sd	s1,56(sp)
    80004a60:	f84a                	sd	s2,48(sp)
    80004a62:	f44e                	sd	s3,40(sp)
    80004a64:	f052                	sd	s4,32(sp)
    80004a66:	ec56                	sd	s5,24(sp)
    80004a68:	e85a                	sd	s6,16(sp)
    80004a6a:	e45e                	sd	s7,8(sp)
    80004a6c:	0880                	addi	s0,sp,80
    80004a6e:	8b2a                	mv	s6,a0
    80004a70:	00068a97          	auipc	s5,0x68
    80004a74:	3e0a8a93          	addi	s5,s5,992 # 8006ce50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a78:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004a7a:	00068997          	auipc	s3,0x68
    80004a7e:	3a698993          	addi	s3,s3,934 # 8006ce20 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004a82:	40000b93          	li	s7,1024
    80004a86:	a00d                	j	80004aa8 <install_trans+0x5c>
    brelse(lbuf);
    80004a88:	854a                	mv	a0,s2
    80004a8a:	fffff097          	auipc	ra,0xfffff
    80004a8e:	066080e7          	jalr	102(ra) # 80003af0 <brelse>
    brelse(dbuf);
    80004a92:	8526                	mv	a0,s1
    80004a94:	fffff097          	auipc	ra,0xfffff
    80004a98:	05c080e7          	jalr	92(ra) # 80003af0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a9c:	2a05                	addiw	s4,s4,1
    80004a9e:	0a91                	addi	s5,s5,4
    80004aa0:	02c9a783          	lw	a5,44(s3)
    80004aa4:	04fa5d63          	bge	s4,a5,80004afe <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004aa8:	0189a583          	lw	a1,24(s3)
    80004aac:	014585bb          	addw	a1,a1,s4
    80004ab0:	2585                	addiw	a1,a1,1
    80004ab2:	0289a503          	lw	a0,40(s3)
    80004ab6:	fffff097          	auipc	ra,0xfffff
    80004aba:	f0a080e7          	jalr	-246(ra) # 800039c0 <bread>
    80004abe:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004ac0:	000aa583          	lw	a1,0(s5)
    80004ac4:	0289a503          	lw	a0,40(s3)
    80004ac8:	fffff097          	auipc	ra,0xfffff
    80004acc:	ef8080e7          	jalr	-264(ra) # 800039c0 <bread>
    80004ad0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004ad2:	865e                	mv	a2,s7
    80004ad4:	05890593          	addi	a1,s2,88
    80004ad8:	05850513          	addi	a0,a0,88
    80004adc:	ffffc097          	auipc	ra,0xffffc
    80004ae0:	3b0080e7          	jalr	944(ra) # 80000e8c <memmove>
    bwrite(dbuf);  // write dst to disk
    80004ae4:	8526                	mv	a0,s1
    80004ae6:	fffff097          	auipc	ra,0xfffff
    80004aea:	fcc080e7          	jalr	-52(ra) # 80003ab2 <bwrite>
    if(recovering == 0)
    80004aee:	f80b1de3          	bnez	s6,80004a88 <install_trans+0x3c>
      bunpin(dbuf);
    80004af2:	8526                	mv	a0,s1
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	0d0080e7          	jalr	208(ra) # 80003bc4 <bunpin>
    80004afc:	b771                	j	80004a88 <install_trans+0x3c>
}
    80004afe:	60a6                	ld	ra,72(sp)
    80004b00:	6406                	ld	s0,64(sp)
    80004b02:	74e2                	ld	s1,56(sp)
    80004b04:	7942                	ld	s2,48(sp)
    80004b06:	79a2                	ld	s3,40(sp)
    80004b08:	7a02                	ld	s4,32(sp)
    80004b0a:	6ae2                	ld	s5,24(sp)
    80004b0c:	6b42                	ld	s6,16(sp)
    80004b0e:	6ba2                	ld	s7,8(sp)
    80004b10:	6161                	addi	sp,sp,80
    80004b12:	8082                	ret
    80004b14:	8082                	ret

0000000080004b16 <initlog>:
{
    80004b16:	7179                	addi	sp,sp,-48
    80004b18:	f406                	sd	ra,40(sp)
    80004b1a:	f022                	sd	s0,32(sp)
    80004b1c:	ec26                	sd	s1,24(sp)
    80004b1e:	e84a                	sd	s2,16(sp)
    80004b20:	e44e                	sd	s3,8(sp)
    80004b22:	1800                	addi	s0,sp,48
    80004b24:	892a                	mv	s2,a0
    80004b26:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004b28:	00068497          	auipc	s1,0x68
    80004b2c:	2f848493          	addi	s1,s1,760 # 8006ce20 <log>
    80004b30:	00005597          	auipc	a1,0x5
    80004b34:	ad058593          	addi	a1,a1,-1328 # 80009600 <etext+0x600>
    80004b38:	8526                	mv	a0,s1
    80004b3a:	ffffc097          	auipc	ra,0xffffc
    80004b3e:	160080e7          	jalr	352(ra) # 80000c9a <initlock>
  log.start = sb->logstart;
    80004b42:	0149a583          	lw	a1,20(s3)
    80004b46:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004b48:	0109a783          	lw	a5,16(s3)
    80004b4c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004b4e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004b52:	854a                	mv	a0,s2
    80004b54:	fffff097          	auipc	ra,0xfffff
    80004b58:	e6c080e7          	jalr	-404(ra) # 800039c0 <bread>
  log.lh.n = lh->n;
    80004b5c:	4d30                	lw	a2,88(a0)
    80004b5e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004b60:	00c05f63          	blez	a2,80004b7e <initlog+0x68>
    80004b64:	87aa                	mv	a5,a0
    80004b66:	00068717          	auipc	a4,0x68
    80004b6a:	2ea70713          	addi	a4,a4,746 # 8006ce50 <log+0x30>
    80004b6e:	060a                	slli	a2,a2,0x2
    80004b70:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004b72:	4ff4                	lw	a3,92(a5)
    80004b74:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004b76:	0791                	addi	a5,a5,4
    80004b78:	0711                	addi	a4,a4,4
    80004b7a:	fec79ce3          	bne	a5,a2,80004b72 <initlog+0x5c>
  brelse(buf);
    80004b7e:	fffff097          	auipc	ra,0xfffff
    80004b82:	f72080e7          	jalr	-142(ra) # 80003af0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004b86:	4505                	li	a0,1
    80004b88:	00000097          	auipc	ra,0x0
    80004b8c:	ec4080e7          	jalr	-316(ra) # 80004a4c <install_trans>
  log.lh.n = 0;
    80004b90:	00068797          	auipc	a5,0x68
    80004b94:	2a07ae23          	sw	zero,700(a5) # 8006ce4c <log+0x2c>
  write_head(); // clear the log
    80004b98:	00000097          	auipc	ra,0x0
    80004b9c:	e4a080e7          	jalr	-438(ra) # 800049e2 <write_head>
}
    80004ba0:	70a2                	ld	ra,40(sp)
    80004ba2:	7402                	ld	s0,32(sp)
    80004ba4:	64e2                	ld	s1,24(sp)
    80004ba6:	6942                	ld	s2,16(sp)
    80004ba8:	69a2                	ld	s3,8(sp)
    80004baa:	6145                	addi	sp,sp,48
    80004bac:	8082                	ret

0000000080004bae <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004bae:	1101                	addi	sp,sp,-32
    80004bb0:	ec06                	sd	ra,24(sp)
    80004bb2:	e822                	sd	s0,16(sp)
    80004bb4:	e426                	sd	s1,8(sp)
    80004bb6:	e04a                	sd	s2,0(sp)
    80004bb8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004bba:	00068517          	auipc	a0,0x68
    80004bbe:	26650513          	addi	a0,a0,614 # 8006ce20 <log>
    80004bc2:	ffffc097          	auipc	ra,0xffffc
    80004bc6:	172080e7          	jalr	370(ra) # 80000d34 <acquire>
  while(1){
    if(log.committing){
    80004bca:	00068497          	auipc	s1,0x68
    80004bce:	25648493          	addi	s1,s1,598 # 8006ce20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004bd2:	4979                	li	s2,30
    80004bd4:	a039                	j	80004be2 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004bd6:	85a6                	mv	a1,s1
    80004bd8:	8526                	mv	a0,s1
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	c10080e7          	jalr	-1008(ra) # 800027ea <sleep>
    if(log.committing){
    80004be2:	50dc                	lw	a5,36(s1)
    80004be4:	fbed                	bnez	a5,80004bd6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004be6:	5098                	lw	a4,32(s1)
    80004be8:	2705                	addiw	a4,a4,1
    80004bea:	0027179b          	slliw	a5,a4,0x2
    80004bee:	9fb9                	addw	a5,a5,a4
    80004bf0:	0017979b          	slliw	a5,a5,0x1
    80004bf4:	54d4                	lw	a3,44(s1)
    80004bf6:	9fb5                	addw	a5,a5,a3
    80004bf8:	00f95963          	bge	s2,a5,80004c0a <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004bfc:	85a6                	mv	a1,s1
    80004bfe:	8526                	mv	a0,s1
    80004c00:	ffffe097          	auipc	ra,0xffffe
    80004c04:	bea080e7          	jalr	-1046(ra) # 800027ea <sleep>
    80004c08:	bfe9                	j	80004be2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004c0a:	00068797          	auipc	a5,0x68
    80004c0e:	22e7ab23          	sw	a4,566(a5) # 8006ce40 <log+0x20>
      release(&log.lock);
    80004c12:	00068517          	auipc	a0,0x68
    80004c16:	20e50513          	addi	a0,a0,526 # 8006ce20 <log>
    80004c1a:	ffffc097          	auipc	ra,0xffffc
    80004c1e:	1ca080e7          	jalr	458(ra) # 80000de4 <release>
      break;
    }
  }
}
    80004c22:	60e2                	ld	ra,24(sp)
    80004c24:	6442                	ld	s0,16(sp)
    80004c26:	64a2                	ld	s1,8(sp)
    80004c28:	6902                	ld	s2,0(sp)
    80004c2a:	6105                	addi	sp,sp,32
    80004c2c:	8082                	ret

0000000080004c2e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004c2e:	7139                	addi	sp,sp,-64
    80004c30:	fc06                	sd	ra,56(sp)
    80004c32:	f822                	sd	s0,48(sp)
    80004c34:	f426                	sd	s1,40(sp)
    80004c36:	f04a                	sd	s2,32(sp)
    80004c38:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004c3a:	00068497          	auipc	s1,0x68
    80004c3e:	1e648493          	addi	s1,s1,486 # 8006ce20 <log>
    80004c42:	8526                	mv	a0,s1
    80004c44:	ffffc097          	auipc	ra,0xffffc
    80004c48:	0f0080e7          	jalr	240(ra) # 80000d34 <acquire>
  log.outstanding -= 1;
    80004c4c:	509c                	lw	a5,32(s1)
    80004c4e:	37fd                	addiw	a5,a5,-1
    80004c50:	893e                	mv	s2,a5
    80004c52:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004c54:	50dc                	lw	a5,36(s1)
    80004c56:	efb1                	bnez	a5,80004cb2 <end_op+0x84>
    panic("log.committing");
  if(log.outstanding == 0){
    80004c58:	06091863          	bnez	s2,80004cc8 <end_op+0x9a>
    do_commit = 1;
    log.committing = 1;
    80004c5c:	00068497          	auipc	s1,0x68
    80004c60:	1c448493          	addi	s1,s1,452 # 8006ce20 <log>
    80004c64:	4785                	li	a5,1
    80004c66:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004c68:	8526                	mv	a0,s1
    80004c6a:	ffffc097          	auipc	ra,0xffffc
    80004c6e:	17a080e7          	jalr	378(ra) # 80000de4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004c72:	54dc                	lw	a5,44(s1)
    80004c74:	08f04063          	bgtz	a5,80004cf4 <end_op+0xc6>
    acquire(&log.lock);
    80004c78:	00068517          	auipc	a0,0x68
    80004c7c:	1a850513          	addi	a0,a0,424 # 8006ce20 <log>
    80004c80:	ffffc097          	auipc	ra,0xffffc
    80004c84:	0b4080e7          	jalr	180(ra) # 80000d34 <acquire>
    log.committing = 0;
    80004c88:	00068797          	auipc	a5,0x68
    80004c8c:	1a07ae23          	sw	zero,444(a5) # 8006ce44 <log+0x24>
    wakeup(&log);
    80004c90:	00068517          	auipc	a0,0x68
    80004c94:	19050513          	addi	a0,a0,400 # 8006ce20 <log>
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	bb6080e7          	jalr	-1098(ra) # 8000284e <wakeup>
    release(&log.lock);
    80004ca0:	00068517          	auipc	a0,0x68
    80004ca4:	18050513          	addi	a0,a0,384 # 8006ce20 <log>
    80004ca8:	ffffc097          	auipc	ra,0xffffc
    80004cac:	13c080e7          	jalr	316(ra) # 80000de4 <release>
}
    80004cb0:	a825                	j	80004ce8 <end_op+0xba>
    80004cb2:	ec4e                	sd	s3,24(sp)
    80004cb4:	e852                	sd	s4,16(sp)
    80004cb6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004cb8:	00005517          	auipc	a0,0x5
    80004cbc:	95050513          	addi	a0,a0,-1712 # 80009608 <etext+0x608>
    80004cc0:	ffffc097          	auipc	ra,0xffffc
    80004cc4:	89e080e7          	jalr	-1890(ra) # 8000055e <panic>
    wakeup(&log);
    80004cc8:	00068517          	auipc	a0,0x68
    80004ccc:	15850513          	addi	a0,a0,344 # 8006ce20 <log>
    80004cd0:	ffffe097          	auipc	ra,0xffffe
    80004cd4:	b7e080e7          	jalr	-1154(ra) # 8000284e <wakeup>
  release(&log.lock);
    80004cd8:	00068517          	auipc	a0,0x68
    80004cdc:	14850513          	addi	a0,a0,328 # 8006ce20 <log>
    80004ce0:	ffffc097          	auipc	ra,0xffffc
    80004ce4:	104080e7          	jalr	260(ra) # 80000de4 <release>
}
    80004ce8:	70e2                	ld	ra,56(sp)
    80004cea:	7442                	ld	s0,48(sp)
    80004cec:	74a2                	ld	s1,40(sp)
    80004cee:	7902                	ld	s2,32(sp)
    80004cf0:	6121                	addi	sp,sp,64
    80004cf2:	8082                	ret
    80004cf4:	ec4e                	sd	s3,24(sp)
    80004cf6:	e852                	sd	s4,16(sp)
    80004cf8:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004cfa:	00068a97          	auipc	s5,0x68
    80004cfe:	156a8a93          	addi	s5,s5,342 # 8006ce50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004d02:	00068a17          	auipc	s4,0x68
    80004d06:	11ea0a13          	addi	s4,s4,286 # 8006ce20 <log>
    80004d0a:	018a2583          	lw	a1,24(s4)
    80004d0e:	012585bb          	addw	a1,a1,s2
    80004d12:	2585                	addiw	a1,a1,1
    80004d14:	028a2503          	lw	a0,40(s4)
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	ca8080e7          	jalr	-856(ra) # 800039c0 <bread>
    80004d20:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004d22:	000aa583          	lw	a1,0(s5)
    80004d26:	028a2503          	lw	a0,40(s4)
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	c96080e7          	jalr	-874(ra) # 800039c0 <bread>
    80004d32:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004d34:	40000613          	li	a2,1024
    80004d38:	05850593          	addi	a1,a0,88
    80004d3c:	05848513          	addi	a0,s1,88
    80004d40:	ffffc097          	auipc	ra,0xffffc
    80004d44:	14c080e7          	jalr	332(ra) # 80000e8c <memmove>
    bwrite(to);  // write the log
    80004d48:	8526                	mv	a0,s1
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	d68080e7          	jalr	-664(ra) # 80003ab2 <bwrite>
    brelse(from);
    80004d52:	854e                	mv	a0,s3
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	d9c080e7          	jalr	-612(ra) # 80003af0 <brelse>
    brelse(to);
    80004d5c:	8526                	mv	a0,s1
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	d92080e7          	jalr	-622(ra) # 80003af0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004d66:	2905                	addiw	s2,s2,1
    80004d68:	0a91                	addi	s5,s5,4
    80004d6a:	02ca2783          	lw	a5,44(s4)
    80004d6e:	f8f94ee3          	blt	s2,a5,80004d0a <end_op+0xdc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004d72:	00000097          	auipc	ra,0x0
    80004d76:	c70080e7          	jalr	-912(ra) # 800049e2 <write_head>
    install_trans(0); // Now install writes to home locations
    80004d7a:	4501                	li	a0,0
    80004d7c:	00000097          	auipc	ra,0x0
    80004d80:	cd0080e7          	jalr	-816(ra) # 80004a4c <install_trans>
    log.lh.n = 0;
    80004d84:	00068797          	auipc	a5,0x68
    80004d88:	0c07a423          	sw	zero,200(a5) # 8006ce4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004d8c:	00000097          	auipc	ra,0x0
    80004d90:	c56080e7          	jalr	-938(ra) # 800049e2 <write_head>
    80004d94:	69e2                	ld	s3,24(sp)
    80004d96:	6a42                	ld	s4,16(sp)
    80004d98:	6aa2                	ld	s5,8(sp)
    80004d9a:	bdf9                	j	80004c78 <end_op+0x4a>

0000000080004d9c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004d9c:	1101                	addi	sp,sp,-32
    80004d9e:	ec06                	sd	ra,24(sp)
    80004da0:	e822                	sd	s0,16(sp)
    80004da2:	e426                	sd	s1,8(sp)
    80004da4:	1000                	addi	s0,sp,32
    80004da6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004da8:	00068517          	auipc	a0,0x68
    80004dac:	07850513          	addi	a0,a0,120 # 8006ce20 <log>
    80004db0:	ffffc097          	auipc	ra,0xffffc
    80004db4:	f84080e7          	jalr	-124(ra) # 80000d34 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004db8:	00068617          	auipc	a2,0x68
    80004dbc:	09462603          	lw	a2,148(a2) # 8006ce4c <log+0x2c>
    80004dc0:	47f5                	li	a5,29
    80004dc2:	06c7c663          	blt	a5,a2,80004e2e <log_write+0x92>
    80004dc6:	00068797          	auipc	a5,0x68
    80004dca:	0767a783          	lw	a5,118(a5) # 8006ce3c <log+0x1c>
    80004dce:	37fd                	addiw	a5,a5,-1
    80004dd0:	04f65f63          	bge	a2,a5,80004e2e <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004dd4:	00068797          	auipc	a5,0x68
    80004dd8:	06c7a783          	lw	a5,108(a5) # 8006ce40 <log+0x20>
    80004ddc:	06f05163          	blez	a5,80004e3e <log_write+0xa2>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004de0:	4781                	li	a5,0
    80004de2:	06c05663          	blez	a2,80004e4e <log_write+0xb2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004de6:	44cc                	lw	a1,12(s1)
    80004de8:	00068717          	auipc	a4,0x68
    80004dec:	06870713          	addi	a4,a4,104 # 8006ce50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004df0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004df2:	4314                	lw	a3,0(a4)
    80004df4:	04b68d63          	beq	a3,a1,80004e4e <log_write+0xb2>
  for (i = 0; i < log.lh.n; i++) {
    80004df8:	2785                	addiw	a5,a5,1
    80004dfa:	0711                	addi	a4,a4,4
    80004dfc:	fef61be3          	bne	a2,a5,80004df2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004e00:	060a                	slli	a2,a2,0x2
    80004e02:	02060613          	addi	a2,a2,32
    80004e06:	00068797          	auipc	a5,0x68
    80004e0a:	01a78793          	addi	a5,a5,26 # 8006ce20 <log>
    80004e0e:	97b2                	add	a5,a5,a2
    80004e10:	44d8                	lw	a4,12(s1)
    80004e12:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004e14:	8526                	mv	a0,s1
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	d72080e7          	jalr	-654(ra) # 80003b88 <bpin>
    log.lh.n++;
    80004e1e:	00068717          	auipc	a4,0x68
    80004e22:	00270713          	addi	a4,a4,2 # 8006ce20 <log>
    80004e26:	575c                	lw	a5,44(a4)
    80004e28:	2785                	addiw	a5,a5,1
    80004e2a:	d75c                	sw	a5,44(a4)
    80004e2c:	a835                	j	80004e68 <log_write+0xcc>
    panic("too big a transaction");
    80004e2e:	00004517          	auipc	a0,0x4
    80004e32:	7ea50513          	addi	a0,a0,2026 # 80009618 <etext+0x618>
    80004e36:	ffffb097          	auipc	ra,0xffffb
    80004e3a:	728080e7          	jalr	1832(ra) # 8000055e <panic>
    panic("log_write outside of trans");
    80004e3e:	00004517          	auipc	a0,0x4
    80004e42:	7f250513          	addi	a0,a0,2034 # 80009630 <etext+0x630>
    80004e46:	ffffb097          	auipc	ra,0xffffb
    80004e4a:	718080e7          	jalr	1816(ra) # 8000055e <panic>
  log.lh.block[i] = b->blockno;
    80004e4e:	00279693          	slli	a3,a5,0x2
    80004e52:	02068693          	addi	a3,a3,32
    80004e56:	00068717          	auipc	a4,0x68
    80004e5a:	fca70713          	addi	a4,a4,-54 # 8006ce20 <log>
    80004e5e:	9736                	add	a4,a4,a3
    80004e60:	44d4                	lw	a3,12(s1)
    80004e62:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004e64:	faf608e3          	beq	a2,a5,80004e14 <log_write+0x78>
  }
  release(&log.lock);
    80004e68:	00068517          	auipc	a0,0x68
    80004e6c:	fb850513          	addi	a0,a0,-72 # 8006ce20 <log>
    80004e70:	ffffc097          	auipc	ra,0xffffc
    80004e74:	f74080e7          	jalr	-140(ra) # 80000de4 <release>
}
    80004e78:	60e2                	ld	ra,24(sp)
    80004e7a:	6442                	ld	s0,16(sp)
    80004e7c:	64a2                	ld	s1,8(sp)
    80004e7e:	6105                	addi	sp,sp,32
    80004e80:	8082                	ret

0000000080004e82 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004e82:	1101                	addi	sp,sp,-32
    80004e84:	ec06                	sd	ra,24(sp)
    80004e86:	e822                	sd	s0,16(sp)
    80004e88:	e426                	sd	s1,8(sp)
    80004e8a:	e04a                	sd	s2,0(sp)
    80004e8c:	1000                	addi	s0,sp,32
    80004e8e:	84aa                	mv	s1,a0
    80004e90:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004e92:	00004597          	auipc	a1,0x4
    80004e96:	7be58593          	addi	a1,a1,1982 # 80009650 <etext+0x650>
    80004e9a:	0521                	addi	a0,a0,8
    80004e9c:	ffffc097          	auipc	ra,0xffffc
    80004ea0:	dfe080e7          	jalr	-514(ra) # 80000c9a <initlock>
  lk->name = name;
    80004ea4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004ea8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004eac:	0204a423          	sw	zero,40(s1)
}
    80004eb0:	60e2                	ld	ra,24(sp)
    80004eb2:	6442                	ld	s0,16(sp)
    80004eb4:	64a2                	ld	s1,8(sp)
    80004eb6:	6902                	ld	s2,0(sp)
    80004eb8:	6105                	addi	sp,sp,32
    80004eba:	8082                	ret

0000000080004ebc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004ebc:	1101                	addi	sp,sp,-32
    80004ebe:	ec06                	sd	ra,24(sp)
    80004ec0:	e822                	sd	s0,16(sp)
    80004ec2:	e426                	sd	s1,8(sp)
    80004ec4:	e04a                	sd	s2,0(sp)
    80004ec6:	1000                	addi	s0,sp,32
    80004ec8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004eca:	00850913          	addi	s2,a0,8
    80004ece:	854a                	mv	a0,s2
    80004ed0:	ffffc097          	auipc	ra,0xffffc
    80004ed4:	e64080e7          	jalr	-412(ra) # 80000d34 <acquire>
  while (lk->locked) {
    80004ed8:	409c                	lw	a5,0(s1)
    80004eda:	cb89                	beqz	a5,80004eec <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004edc:	85ca                	mv	a1,s2
    80004ede:	8526                	mv	a0,s1
    80004ee0:	ffffe097          	auipc	ra,0xffffe
    80004ee4:	90a080e7          	jalr	-1782(ra) # 800027ea <sleep>
  while (lk->locked) {
    80004ee8:	409c                	lw	a5,0(s1)
    80004eea:	fbed                	bnez	a5,80004edc <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004eec:	4785                	li	a5,1
    80004eee:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004ef0:	ffffd097          	auipc	ra,0xffffd
    80004ef4:	044080e7          	jalr	68(ra) # 80001f34 <myproc>
    80004ef8:	591c                	lw	a5,48(a0)
    80004efa:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004efc:	854a                	mv	a0,s2
    80004efe:	ffffc097          	auipc	ra,0xffffc
    80004f02:	ee6080e7          	jalr	-282(ra) # 80000de4 <release>
}
    80004f06:	60e2                	ld	ra,24(sp)
    80004f08:	6442                	ld	s0,16(sp)
    80004f0a:	64a2                	ld	s1,8(sp)
    80004f0c:	6902                	ld	s2,0(sp)
    80004f0e:	6105                	addi	sp,sp,32
    80004f10:	8082                	ret

0000000080004f12 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004f12:	1101                	addi	sp,sp,-32
    80004f14:	ec06                	sd	ra,24(sp)
    80004f16:	e822                	sd	s0,16(sp)
    80004f18:	e426                	sd	s1,8(sp)
    80004f1a:	e04a                	sd	s2,0(sp)
    80004f1c:	1000                	addi	s0,sp,32
    80004f1e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004f20:	00850913          	addi	s2,a0,8
    80004f24:	854a                	mv	a0,s2
    80004f26:	ffffc097          	auipc	ra,0xffffc
    80004f2a:	e0e080e7          	jalr	-498(ra) # 80000d34 <acquire>
  lk->locked = 0;
    80004f2e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004f32:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004f36:	8526                	mv	a0,s1
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	916080e7          	jalr	-1770(ra) # 8000284e <wakeup>
  release(&lk->lk);
    80004f40:	854a                	mv	a0,s2
    80004f42:	ffffc097          	auipc	ra,0xffffc
    80004f46:	ea2080e7          	jalr	-350(ra) # 80000de4 <release>
}
    80004f4a:	60e2                	ld	ra,24(sp)
    80004f4c:	6442                	ld	s0,16(sp)
    80004f4e:	64a2                	ld	s1,8(sp)
    80004f50:	6902                	ld	s2,0(sp)
    80004f52:	6105                	addi	sp,sp,32
    80004f54:	8082                	ret

0000000080004f56 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004f56:	7179                	addi	sp,sp,-48
    80004f58:	f406                	sd	ra,40(sp)
    80004f5a:	f022                	sd	s0,32(sp)
    80004f5c:	ec26                	sd	s1,24(sp)
    80004f5e:	e84a                	sd	s2,16(sp)
    80004f60:	1800                	addi	s0,sp,48
    80004f62:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004f64:	00850913          	addi	s2,a0,8
    80004f68:	854a                	mv	a0,s2
    80004f6a:	ffffc097          	auipc	ra,0xffffc
    80004f6e:	dca080e7          	jalr	-566(ra) # 80000d34 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004f72:	409c                	lw	a5,0(s1)
    80004f74:	ef91                	bnez	a5,80004f90 <holdingsleep+0x3a>
    80004f76:	4481                	li	s1,0
  release(&lk->lk);
    80004f78:	854a                	mv	a0,s2
    80004f7a:	ffffc097          	auipc	ra,0xffffc
    80004f7e:	e6a080e7          	jalr	-406(ra) # 80000de4 <release>
  return r;
}
    80004f82:	8526                	mv	a0,s1
    80004f84:	70a2                	ld	ra,40(sp)
    80004f86:	7402                	ld	s0,32(sp)
    80004f88:	64e2                	ld	s1,24(sp)
    80004f8a:	6942                	ld	s2,16(sp)
    80004f8c:	6145                	addi	sp,sp,48
    80004f8e:	8082                	ret
    80004f90:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004f92:	0284a983          	lw	s3,40(s1)
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	f9e080e7          	jalr	-98(ra) # 80001f34 <myproc>
    80004f9e:	5904                	lw	s1,48(a0)
    80004fa0:	413484b3          	sub	s1,s1,s3
    80004fa4:	0014b493          	seqz	s1,s1
    80004fa8:	69a2                	ld	s3,8(sp)
    80004faa:	b7f9                	j	80004f78 <holdingsleep+0x22>

0000000080004fac <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004fac:	1141                	addi	sp,sp,-16
    80004fae:	e406                	sd	ra,8(sp)
    80004fb0:	e022                	sd	s0,0(sp)
    80004fb2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004fb4:	00004597          	auipc	a1,0x4
    80004fb8:	6ac58593          	addi	a1,a1,1708 # 80009660 <etext+0x660>
    80004fbc:	00068517          	auipc	a0,0x68
    80004fc0:	fac50513          	addi	a0,a0,-84 # 8006cf68 <ftable>
    80004fc4:	ffffc097          	auipc	ra,0xffffc
    80004fc8:	cd6080e7          	jalr	-810(ra) # 80000c9a <initlock>
}
    80004fcc:	60a2                	ld	ra,8(sp)
    80004fce:	6402                	ld	s0,0(sp)
    80004fd0:	0141                	addi	sp,sp,16
    80004fd2:	8082                	ret

0000000080004fd4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004fd4:	1101                	addi	sp,sp,-32
    80004fd6:	ec06                	sd	ra,24(sp)
    80004fd8:	e822                	sd	s0,16(sp)
    80004fda:	e426                	sd	s1,8(sp)
    80004fdc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004fde:	00068517          	auipc	a0,0x68
    80004fe2:	f8a50513          	addi	a0,a0,-118 # 8006cf68 <ftable>
    80004fe6:	ffffc097          	auipc	ra,0xffffc
    80004fea:	d4e080e7          	jalr	-690(ra) # 80000d34 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004fee:	00068497          	auipc	s1,0x68
    80004ff2:	f9248493          	addi	s1,s1,-110 # 8006cf80 <ftable+0x18>
    80004ff6:	00069717          	auipc	a4,0x69
    80004ffa:	f2a70713          	addi	a4,a4,-214 # 8006df20 <disk>
    if(f->ref == 0){
    80004ffe:	40dc                	lw	a5,4(s1)
    80005000:	cf99                	beqz	a5,8000501e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005002:	02848493          	addi	s1,s1,40
    80005006:	fee49ce3          	bne	s1,a4,80004ffe <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000500a:	00068517          	auipc	a0,0x68
    8000500e:	f5e50513          	addi	a0,a0,-162 # 8006cf68 <ftable>
    80005012:	ffffc097          	auipc	ra,0xffffc
    80005016:	dd2080e7          	jalr	-558(ra) # 80000de4 <release>
  return 0;
    8000501a:	4481                	li	s1,0
    8000501c:	a819                	j	80005032 <filealloc+0x5e>
      f->ref = 1;
    8000501e:	4785                	li	a5,1
    80005020:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80005022:	00068517          	auipc	a0,0x68
    80005026:	f4650513          	addi	a0,a0,-186 # 8006cf68 <ftable>
    8000502a:	ffffc097          	auipc	ra,0xffffc
    8000502e:	dba080e7          	jalr	-582(ra) # 80000de4 <release>
}
    80005032:	8526                	mv	a0,s1
    80005034:	60e2                	ld	ra,24(sp)
    80005036:	6442                	ld	s0,16(sp)
    80005038:	64a2                	ld	s1,8(sp)
    8000503a:	6105                	addi	sp,sp,32
    8000503c:	8082                	ret

000000008000503e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000503e:	1101                	addi	sp,sp,-32
    80005040:	ec06                	sd	ra,24(sp)
    80005042:	e822                	sd	s0,16(sp)
    80005044:	e426                	sd	s1,8(sp)
    80005046:	1000                	addi	s0,sp,32
    80005048:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000504a:	00068517          	auipc	a0,0x68
    8000504e:	f1e50513          	addi	a0,a0,-226 # 8006cf68 <ftable>
    80005052:	ffffc097          	auipc	ra,0xffffc
    80005056:	ce2080e7          	jalr	-798(ra) # 80000d34 <acquire>
  if(f->ref < 1)
    8000505a:	40dc                	lw	a5,4(s1)
    8000505c:	02f05263          	blez	a5,80005080 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80005060:	2785                	addiw	a5,a5,1
    80005062:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80005064:	00068517          	auipc	a0,0x68
    80005068:	f0450513          	addi	a0,a0,-252 # 8006cf68 <ftable>
    8000506c:	ffffc097          	auipc	ra,0xffffc
    80005070:	d78080e7          	jalr	-648(ra) # 80000de4 <release>
  return f;
}
    80005074:	8526                	mv	a0,s1
    80005076:	60e2                	ld	ra,24(sp)
    80005078:	6442                	ld	s0,16(sp)
    8000507a:	64a2                	ld	s1,8(sp)
    8000507c:	6105                	addi	sp,sp,32
    8000507e:	8082                	ret
    panic("filedup");
    80005080:	00004517          	auipc	a0,0x4
    80005084:	5e850513          	addi	a0,a0,1512 # 80009668 <etext+0x668>
    80005088:	ffffb097          	auipc	ra,0xffffb
    8000508c:	4d6080e7          	jalr	1238(ra) # 8000055e <panic>

0000000080005090 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005090:	7139                	addi	sp,sp,-64
    80005092:	fc06                	sd	ra,56(sp)
    80005094:	f822                	sd	s0,48(sp)
    80005096:	f426                	sd	s1,40(sp)
    80005098:	0080                	addi	s0,sp,64
    8000509a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000509c:	00068517          	auipc	a0,0x68
    800050a0:	ecc50513          	addi	a0,a0,-308 # 8006cf68 <ftable>
    800050a4:	ffffc097          	auipc	ra,0xffffc
    800050a8:	c90080e7          	jalr	-880(ra) # 80000d34 <acquire>
  if(f->ref < 1)
    800050ac:	40dc                	lw	a5,4(s1)
    800050ae:	04f05c63          	blez	a5,80005106 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    800050b2:	37fd                	addiw	a5,a5,-1
    800050b4:	c0dc                	sw	a5,4(s1)
    800050b6:	06f04463          	bgtz	a5,8000511e <fileclose+0x8e>
    800050ba:	f04a                	sd	s2,32(sp)
    800050bc:	ec4e                	sd	s3,24(sp)
    800050be:	e852                	sd	s4,16(sp)
    800050c0:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800050c2:	0004a903          	lw	s2,0(s1)
    800050c6:	0094c783          	lbu	a5,9(s1)
    800050ca:	89be                	mv	s3,a5
    800050cc:	689c                	ld	a5,16(s1)
    800050ce:	8a3e                	mv	s4,a5
    800050d0:	6c9c                	ld	a5,24(s1)
    800050d2:	8abe                	mv	s5,a5
  f->ref = 0;
    800050d4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800050d8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800050dc:	00068517          	auipc	a0,0x68
    800050e0:	e8c50513          	addi	a0,a0,-372 # 8006cf68 <ftable>
    800050e4:	ffffc097          	auipc	ra,0xffffc
    800050e8:	d00080e7          	jalr	-768(ra) # 80000de4 <release>

  if(ff.type == FD_PIPE){
    800050ec:	4785                	li	a5,1
    800050ee:	04f90563          	beq	s2,a5,80005138 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800050f2:	ffe9079b          	addiw	a5,s2,-2
    800050f6:	4705                	li	a4,1
    800050f8:	04f77b63          	bgeu	a4,a5,8000514e <fileclose+0xbe>
    800050fc:	7902                	ld	s2,32(sp)
    800050fe:	69e2                	ld	s3,24(sp)
    80005100:	6a42                	ld	s4,16(sp)
    80005102:	6aa2                	ld	s5,8(sp)
    80005104:	a02d                	j	8000512e <fileclose+0x9e>
    80005106:	f04a                	sd	s2,32(sp)
    80005108:	ec4e                	sd	s3,24(sp)
    8000510a:	e852                	sd	s4,16(sp)
    8000510c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000510e:	00004517          	auipc	a0,0x4
    80005112:	56250513          	addi	a0,a0,1378 # 80009670 <etext+0x670>
    80005116:	ffffb097          	auipc	ra,0xffffb
    8000511a:	448080e7          	jalr	1096(ra) # 8000055e <panic>
    release(&ftable.lock);
    8000511e:	00068517          	auipc	a0,0x68
    80005122:	e4a50513          	addi	a0,a0,-438 # 8006cf68 <ftable>
    80005126:	ffffc097          	auipc	ra,0xffffc
    8000512a:	cbe080e7          	jalr	-834(ra) # 80000de4 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000512e:	70e2                	ld	ra,56(sp)
    80005130:	7442                	ld	s0,48(sp)
    80005132:	74a2                	ld	s1,40(sp)
    80005134:	6121                	addi	sp,sp,64
    80005136:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80005138:	85ce                	mv	a1,s3
    8000513a:	8552                	mv	a0,s4
    8000513c:	00000097          	auipc	ra,0x0
    80005140:	3b4080e7          	jalr	948(ra) # 800054f0 <pipeclose>
    80005144:	7902                	ld	s2,32(sp)
    80005146:	69e2                	ld	s3,24(sp)
    80005148:	6a42                	ld	s4,16(sp)
    8000514a:	6aa2                	ld	s5,8(sp)
    8000514c:	b7cd                	j	8000512e <fileclose+0x9e>
    begin_op();
    8000514e:	00000097          	auipc	ra,0x0
    80005152:	a60080e7          	jalr	-1440(ra) # 80004bae <begin_op>
    iput(ff.ip);
    80005156:	8556                	mv	a0,s5
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	224080e7          	jalr	548(ra) # 8000437c <iput>
    end_op();
    80005160:	00000097          	auipc	ra,0x0
    80005164:	ace080e7          	jalr	-1330(ra) # 80004c2e <end_op>
    80005168:	7902                	ld	s2,32(sp)
    8000516a:	69e2                	ld	s3,24(sp)
    8000516c:	6a42                	ld	s4,16(sp)
    8000516e:	6aa2                	ld	s5,8(sp)
    80005170:	bf7d                	j	8000512e <fileclose+0x9e>

0000000080005172 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005172:	715d                	addi	sp,sp,-80
    80005174:	e486                	sd	ra,72(sp)
    80005176:	e0a2                	sd	s0,64(sp)
    80005178:	fc26                	sd	s1,56(sp)
    8000517a:	f052                	sd	s4,32(sp)
    8000517c:	0880                	addi	s0,sp,80
    8000517e:	84aa                	mv	s1,a0
    80005180:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80005182:	ffffd097          	auipc	ra,0xffffd
    80005186:	db2080e7          	jalr	-590(ra) # 80001f34 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000518a:	409c                	lw	a5,0(s1)
    8000518c:	37f9                	addiw	a5,a5,-2
    8000518e:	4705                	li	a4,1
    80005190:	04f76a63          	bltu	a4,a5,800051e4 <filestat+0x72>
    80005194:	f84a                	sd	s2,48(sp)
    80005196:	f44e                	sd	s3,40(sp)
    80005198:	89aa                	mv	s3,a0
    ilock(f->ip);
    8000519a:	6c88                	ld	a0,24(s1)
    8000519c:	fffff097          	auipc	ra,0xfffff
    800051a0:	022080e7          	jalr	34(ra) # 800041be <ilock>
    stati(f->ip, &st);
    800051a4:	fb840913          	addi	s2,s0,-72
    800051a8:	85ca                	mv	a1,s2
    800051aa:	6c88                	ld	a0,24(s1)
    800051ac:	fffff097          	auipc	ra,0xfffff
    800051b0:	2a2080e7          	jalr	674(ra) # 8000444e <stati>
    iunlock(f->ip);
    800051b4:	6c88                	ld	a0,24(s1)
    800051b6:	fffff097          	auipc	ra,0xfffff
    800051ba:	0ce080e7          	jalr	206(ra) # 80004284 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800051be:	46e1                	li	a3,24
    800051c0:	864a                	mv	a2,s2
    800051c2:	85d2                	mv	a1,s4
    800051c4:	0509b503          	ld	a0,80(s3)
    800051c8:	ffffd097          	auipc	ra,0xffffd
    800051cc:	9f8080e7          	jalr	-1544(ra) # 80001bc0 <copyout>
    800051d0:	41f5551b          	sraiw	a0,a0,0x1f
    800051d4:	7942                	ld	s2,48(sp)
    800051d6:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800051d8:	60a6                	ld	ra,72(sp)
    800051da:	6406                	ld	s0,64(sp)
    800051dc:	74e2                	ld	s1,56(sp)
    800051de:	7a02                	ld	s4,32(sp)
    800051e0:	6161                	addi	sp,sp,80
    800051e2:	8082                	ret
  return -1;
    800051e4:	557d                	li	a0,-1
    800051e6:	bfcd                	j	800051d8 <filestat+0x66>

00000000800051e8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800051e8:	7179                	addi	sp,sp,-48
    800051ea:	f406                	sd	ra,40(sp)
    800051ec:	f022                	sd	s0,32(sp)
    800051ee:	e84a                	sd	s2,16(sp)
    800051f0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800051f2:	00854783          	lbu	a5,8(a0)
    800051f6:	cbc5                	beqz	a5,800052a6 <fileread+0xbe>
    800051f8:	ec26                	sd	s1,24(sp)
    800051fa:	e44e                	sd	s3,8(sp)
    800051fc:	84aa                	mv	s1,a0
    800051fe:	892e                	mv	s2,a1
    80005200:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80005202:	411c                	lw	a5,0(a0)
    80005204:	4705                	li	a4,1
    80005206:	04e78963          	beq	a5,a4,80005258 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000520a:	470d                	li	a4,3
    8000520c:	04e78f63          	beq	a5,a4,8000526a <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80005210:	4709                	li	a4,2
    80005212:	08e79263          	bne	a5,a4,80005296 <fileread+0xae>
    ilock(f->ip);
    80005216:	6d08                	ld	a0,24(a0)
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	fa6080e7          	jalr	-90(ra) # 800041be <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80005220:	874e                	mv	a4,s3
    80005222:	5094                	lw	a3,32(s1)
    80005224:	864a                	mv	a2,s2
    80005226:	4585                	li	a1,1
    80005228:	6c88                	ld	a0,24(s1)
    8000522a:	fffff097          	auipc	ra,0xfffff
    8000522e:	252080e7          	jalr	594(ra) # 8000447c <readi>
    80005232:	892a                	mv	s2,a0
    80005234:	00a05563          	blez	a0,8000523e <fileread+0x56>
      f->off += r;
    80005238:	509c                	lw	a5,32(s1)
    8000523a:	9fa9                	addw	a5,a5,a0
    8000523c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000523e:	6c88                	ld	a0,24(s1)
    80005240:	fffff097          	auipc	ra,0xfffff
    80005244:	044080e7          	jalr	68(ra) # 80004284 <iunlock>
    80005248:	64e2                	ld	s1,24(sp)
    8000524a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000524c:	854a                	mv	a0,s2
    8000524e:	70a2                	ld	ra,40(sp)
    80005250:	7402                	ld	s0,32(sp)
    80005252:	6942                	ld	s2,16(sp)
    80005254:	6145                	addi	sp,sp,48
    80005256:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005258:	6908                	ld	a0,16(a0)
    8000525a:	00000097          	auipc	ra,0x0
    8000525e:	428080e7          	jalr	1064(ra) # 80005682 <piperead>
    80005262:	892a                	mv	s2,a0
    80005264:	64e2                	ld	s1,24(sp)
    80005266:	69a2                	ld	s3,8(sp)
    80005268:	b7d5                	j	8000524c <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000526a:	02451783          	lh	a5,36(a0)
    8000526e:	03079693          	slli	a3,a5,0x30
    80005272:	92c1                	srli	a3,a3,0x30
    80005274:	4725                	li	a4,9
    80005276:	02d76b63          	bltu	a4,a3,800052ac <fileread+0xc4>
    8000527a:	0792                	slli	a5,a5,0x4
    8000527c:	00068717          	auipc	a4,0x68
    80005280:	c4c70713          	addi	a4,a4,-948 # 8006cec8 <devsw>
    80005284:	97ba                	add	a5,a5,a4
    80005286:	639c                	ld	a5,0(a5)
    80005288:	c79d                	beqz	a5,800052b6 <fileread+0xce>
    r = devsw[f->major].read(1, addr, n);
    8000528a:	4505                	li	a0,1
    8000528c:	9782                	jalr	a5
    8000528e:	892a                	mv	s2,a0
    80005290:	64e2                	ld	s1,24(sp)
    80005292:	69a2                	ld	s3,8(sp)
    80005294:	bf65                	j	8000524c <fileread+0x64>
    panic("fileread");
    80005296:	00004517          	auipc	a0,0x4
    8000529a:	3ea50513          	addi	a0,a0,1002 # 80009680 <etext+0x680>
    8000529e:	ffffb097          	auipc	ra,0xffffb
    800052a2:	2c0080e7          	jalr	704(ra) # 8000055e <panic>
    return -1;
    800052a6:	57fd                	li	a5,-1
    800052a8:	893e                	mv	s2,a5
    800052aa:	b74d                	j	8000524c <fileread+0x64>
      return -1;
    800052ac:	57fd                	li	a5,-1
    800052ae:	893e                	mv	s2,a5
    800052b0:	64e2                	ld	s1,24(sp)
    800052b2:	69a2                	ld	s3,8(sp)
    800052b4:	bf61                	j	8000524c <fileread+0x64>
    800052b6:	57fd                	li	a5,-1
    800052b8:	893e                	mv	s2,a5
    800052ba:	64e2                	ld	s1,24(sp)
    800052bc:	69a2                	ld	s3,8(sp)
    800052be:	b779                	j	8000524c <fileread+0x64>

00000000800052c0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800052c0:	00954783          	lbu	a5,9(a0)
    800052c4:	12078d63          	beqz	a5,800053fe <filewrite+0x13e>
{
    800052c8:	711d                	addi	sp,sp,-96
    800052ca:	ec86                	sd	ra,88(sp)
    800052cc:	e8a2                	sd	s0,80(sp)
    800052ce:	e0ca                	sd	s2,64(sp)
    800052d0:	f456                	sd	s5,40(sp)
    800052d2:	f05a                	sd	s6,32(sp)
    800052d4:	1080                	addi	s0,sp,96
    800052d6:	892a                	mv	s2,a0
    800052d8:	8b2e                	mv	s6,a1
    800052da:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800052dc:	411c                	lw	a5,0(a0)
    800052de:	4705                	li	a4,1
    800052e0:	02e78a63          	beq	a5,a4,80005314 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800052e4:	470d                	li	a4,3
    800052e6:	02e78d63          	beq	a5,a4,80005320 <filewrite+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800052ea:	4709                	li	a4,2
    800052ec:	0ee79b63          	bne	a5,a4,800053e2 <filewrite+0x122>
    800052f0:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800052f2:	0cc05663          	blez	a2,800053be <filewrite+0xfe>
    800052f6:	e4a6                	sd	s1,72(sp)
    800052f8:	fc4e                	sd	s3,56(sp)
    800052fa:	ec5e                	sd	s7,24(sp)
    800052fc:	e862                	sd	s8,16(sp)
    800052fe:	e466                	sd	s9,8(sp)
    int i = 0;
    80005300:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80005302:	6b85                	lui	s7,0x1
    80005304:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005308:	6785                	lui	a5,0x1
    8000530a:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    8000530e:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005310:	4c05                	li	s8,1
    80005312:	a849                	j	800053a4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80005314:	6908                	ld	a0,16(a0)
    80005316:	00000097          	auipc	ra,0x0
    8000531a:	250080e7          	jalr	592(ra) # 80005566 <pipewrite>
    8000531e:	a85d                	j	800053d4 <filewrite+0x114>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005320:	02451783          	lh	a5,36(a0)
    80005324:	03079693          	slli	a3,a5,0x30
    80005328:	92c1                	srli	a3,a3,0x30
    8000532a:	4725                	li	a4,9
    8000532c:	0cd76b63          	bltu	a4,a3,80005402 <filewrite+0x142>
    80005330:	0792                	slli	a5,a5,0x4
    80005332:	00068717          	auipc	a4,0x68
    80005336:	b9670713          	addi	a4,a4,-1130 # 8006cec8 <devsw>
    8000533a:	97ba                	add	a5,a5,a4
    8000533c:	679c                	ld	a5,8(a5)
    8000533e:	c7e1                	beqz	a5,80005406 <filewrite+0x146>
    ret = devsw[f->major].write(1, addr, n);
    80005340:	4505                	li	a0,1
    80005342:	9782                	jalr	a5
    80005344:	a841                	j	800053d4 <filewrite+0x114>
      if(n1 > max)
    80005346:	2981                	sext.w	s3,s3
      begin_op();
    80005348:	00000097          	auipc	ra,0x0
    8000534c:	866080e7          	jalr	-1946(ra) # 80004bae <begin_op>
      ilock(f->ip);
    80005350:	01893503          	ld	a0,24(s2)
    80005354:	fffff097          	auipc	ra,0xfffff
    80005358:	e6a080e7          	jalr	-406(ra) # 800041be <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000535c:	874e                	mv	a4,s3
    8000535e:	02092683          	lw	a3,32(s2)
    80005362:	016a0633          	add	a2,s4,s6
    80005366:	85e2                	mv	a1,s8
    80005368:	01893503          	ld	a0,24(s2)
    8000536c:	fffff097          	auipc	ra,0xfffff
    80005370:	216080e7          	jalr	534(ra) # 80004582 <writei>
    80005374:	84aa                	mv	s1,a0
    80005376:	00a05763          	blez	a0,80005384 <filewrite+0xc4>
        f->off += r;
    8000537a:	02092783          	lw	a5,32(s2)
    8000537e:	9fa9                	addw	a5,a5,a0
    80005380:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005384:	01893503          	ld	a0,24(s2)
    80005388:	fffff097          	auipc	ra,0xfffff
    8000538c:	efc080e7          	jalr	-260(ra) # 80004284 <iunlock>
      end_op();
    80005390:	00000097          	auipc	ra,0x0
    80005394:	89e080e7          	jalr	-1890(ra) # 80004c2e <end_op>

      if(r != n1){
    80005398:	02999563          	bne	s3,s1,800053c2 <filewrite+0x102>
        // error from writei
        break;
      }
      i += r;
    8000539c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800053a0:	015a5963          	bge	s4,s5,800053b2 <filewrite+0xf2>
      int n1 = n - i;
    800053a4:	414a87bb          	subw	a5,s5,s4
    800053a8:	89be                	mv	s3,a5
      if(n1 > max)
    800053aa:	f8fbdee3          	bge	s7,a5,80005346 <filewrite+0x86>
    800053ae:	89e6                	mv	s3,s9
    800053b0:	bf59                	j	80005346 <filewrite+0x86>
    800053b2:	64a6                	ld	s1,72(sp)
    800053b4:	79e2                	ld	s3,56(sp)
    800053b6:	6be2                	ld	s7,24(sp)
    800053b8:	6c42                	ld	s8,16(sp)
    800053ba:	6ca2                	ld	s9,8(sp)
    800053bc:	a801                	j	800053cc <filewrite+0x10c>
    int i = 0;
    800053be:	4a01                	li	s4,0
    800053c0:	a031                	j	800053cc <filewrite+0x10c>
    800053c2:	64a6                	ld	s1,72(sp)
    800053c4:	79e2                	ld	s3,56(sp)
    800053c6:	6be2                	ld	s7,24(sp)
    800053c8:	6c42                	ld	s8,16(sp)
    800053ca:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800053cc:	034a9f63          	bne	s5,s4,8000540a <filewrite+0x14a>
    800053d0:	8556                	mv	a0,s5
    800053d2:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800053d4:	60e6                	ld	ra,88(sp)
    800053d6:	6446                	ld	s0,80(sp)
    800053d8:	6906                	ld	s2,64(sp)
    800053da:	7aa2                	ld	s5,40(sp)
    800053dc:	7b02                	ld	s6,32(sp)
    800053de:	6125                	addi	sp,sp,96
    800053e0:	8082                	ret
    800053e2:	e4a6                	sd	s1,72(sp)
    800053e4:	fc4e                	sd	s3,56(sp)
    800053e6:	f852                	sd	s4,48(sp)
    800053e8:	ec5e                	sd	s7,24(sp)
    800053ea:	e862                	sd	s8,16(sp)
    800053ec:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800053ee:	00004517          	auipc	a0,0x4
    800053f2:	2a250513          	addi	a0,a0,674 # 80009690 <etext+0x690>
    800053f6:	ffffb097          	auipc	ra,0xffffb
    800053fa:	168080e7          	jalr	360(ra) # 8000055e <panic>
    return -1;
    800053fe:	557d                	li	a0,-1
}
    80005400:	8082                	ret
      return -1;
    80005402:	557d                	li	a0,-1
    80005404:	bfc1                	j	800053d4 <filewrite+0x114>
    80005406:	557d                	li	a0,-1
    80005408:	b7f1                	j	800053d4 <filewrite+0x114>
    ret = (i == n ? n : -1);
    8000540a:	557d                	li	a0,-1
    8000540c:	7a42                	ld	s4,48(sp)
    8000540e:	b7d9                	j	800053d4 <filewrite+0x114>

0000000080005410 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005410:	7179                	addi	sp,sp,-48
    80005412:	f406                	sd	ra,40(sp)
    80005414:	f022                	sd	s0,32(sp)
    80005416:	ec26                	sd	s1,24(sp)
    80005418:	e052                	sd	s4,0(sp)
    8000541a:	1800                	addi	s0,sp,48
    8000541c:	84aa                	mv	s1,a0
    8000541e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005420:	0005b023          	sd	zero,0(a1)
    80005424:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005428:	00000097          	auipc	ra,0x0
    8000542c:	bac080e7          	jalr	-1108(ra) # 80004fd4 <filealloc>
    80005430:	e088                	sd	a0,0(s1)
    80005432:	cd49                	beqz	a0,800054cc <pipealloc+0xbc>
    80005434:	00000097          	auipc	ra,0x0
    80005438:	ba0080e7          	jalr	-1120(ra) # 80004fd4 <filealloc>
    8000543c:	00aa3023          	sd	a0,0(s4)
    80005440:	c141                	beqz	a0,800054c0 <pipealloc+0xb0>
    80005442:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005444:	ffffb097          	auipc	ra,0xffffb
    80005448:	7ce080e7          	jalr	1998(ra) # 80000c12 <kalloc>
    8000544c:	892a                	mv	s2,a0
    8000544e:	c13d                	beqz	a0,800054b4 <pipealloc+0xa4>
    80005450:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80005452:	4985                	li	s3,1
    80005454:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005458:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000545c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005460:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80005464:	00004597          	auipc	a1,0x4
    80005468:	23c58593          	addi	a1,a1,572 # 800096a0 <etext+0x6a0>
    8000546c:	ffffc097          	auipc	ra,0xffffc
    80005470:	82e080e7          	jalr	-2002(ra) # 80000c9a <initlock>
  (*f0)->type = FD_PIPE;
    80005474:	609c                	ld	a5,0(s1)
    80005476:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000547a:	609c                	ld	a5,0(s1)
    8000547c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005480:	609c                	ld	a5,0(s1)
    80005482:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80005486:	609c                	ld	a5,0(s1)
    80005488:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000548c:	000a3783          	ld	a5,0(s4)
    80005490:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80005494:	000a3783          	ld	a5,0(s4)
    80005498:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000549c:	000a3783          	ld	a5,0(s4)
    800054a0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800054a4:	000a3783          	ld	a5,0(s4)
    800054a8:	0127b823          	sd	s2,16(a5)
  return 0;
    800054ac:	4501                	li	a0,0
    800054ae:	6942                	ld	s2,16(sp)
    800054b0:	69a2                	ld	s3,8(sp)
    800054b2:	a03d                	j	800054e0 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800054b4:	6088                	ld	a0,0(s1)
    800054b6:	c119                	beqz	a0,800054bc <pipealloc+0xac>
    800054b8:	6942                	ld	s2,16(sp)
    800054ba:	a029                	j	800054c4 <pipealloc+0xb4>
    800054bc:	6942                	ld	s2,16(sp)
    800054be:	a039                	j	800054cc <pipealloc+0xbc>
    800054c0:	6088                	ld	a0,0(s1)
    800054c2:	c50d                	beqz	a0,800054ec <pipealloc+0xdc>
    fileclose(*f0);
    800054c4:	00000097          	auipc	ra,0x0
    800054c8:	bcc080e7          	jalr	-1076(ra) # 80005090 <fileclose>
  if(*f1)
    800054cc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800054d0:	557d                	li	a0,-1
  if(*f1)
    800054d2:	c799                	beqz	a5,800054e0 <pipealloc+0xd0>
    fileclose(*f1);
    800054d4:	853e                	mv	a0,a5
    800054d6:	00000097          	auipc	ra,0x0
    800054da:	bba080e7          	jalr	-1094(ra) # 80005090 <fileclose>
  return -1;
    800054de:	557d                	li	a0,-1
}
    800054e0:	70a2                	ld	ra,40(sp)
    800054e2:	7402                	ld	s0,32(sp)
    800054e4:	64e2                	ld	s1,24(sp)
    800054e6:	6a02                	ld	s4,0(sp)
    800054e8:	6145                	addi	sp,sp,48
    800054ea:	8082                	ret
  return -1;
    800054ec:	557d                	li	a0,-1
    800054ee:	bfcd                	j	800054e0 <pipealloc+0xd0>

00000000800054f0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800054f0:	1101                	addi	sp,sp,-32
    800054f2:	ec06                	sd	ra,24(sp)
    800054f4:	e822                	sd	s0,16(sp)
    800054f6:	e426                	sd	s1,8(sp)
    800054f8:	e04a                	sd	s2,0(sp)
    800054fa:	1000                	addi	s0,sp,32
    800054fc:	84aa                	mv	s1,a0
    800054fe:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005500:	ffffc097          	auipc	ra,0xffffc
    80005504:	834080e7          	jalr	-1996(ra) # 80000d34 <acquire>
  if(writable){
    80005508:	02090b63          	beqz	s2,8000553e <pipeclose+0x4e>
    pi->writeopen = 0;
    8000550c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005510:	21848513          	addi	a0,s1,536
    80005514:	ffffd097          	auipc	ra,0xffffd
    80005518:	33a080e7          	jalr	826(ra) # 8000284e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000551c:	2204a783          	lw	a5,544(s1)
    80005520:	e781                	bnez	a5,80005528 <pipeclose+0x38>
    80005522:	2244a783          	lw	a5,548(s1)
    80005526:	c78d                	beqz	a5,80005550 <pipeclose+0x60>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80005528:	8526                	mv	a0,s1
    8000552a:	ffffc097          	auipc	ra,0xffffc
    8000552e:	8ba080e7          	jalr	-1862(ra) # 80000de4 <release>
}
    80005532:	60e2                	ld	ra,24(sp)
    80005534:	6442                	ld	s0,16(sp)
    80005536:	64a2                	ld	s1,8(sp)
    80005538:	6902                	ld	s2,0(sp)
    8000553a:	6105                	addi	sp,sp,32
    8000553c:	8082                	ret
    pi->readopen = 0;
    8000553e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005542:	21c48513          	addi	a0,s1,540
    80005546:	ffffd097          	auipc	ra,0xffffd
    8000554a:	308080e7          	jalr	776(ra) # 8000284e <wakeup>
    8000554e:	b7f9                	j	8000551c <pipeclose+0x2c>
    release(&pi->lock);
    80005550:	8526                	mv	a0,s1
    80005552:	ffffc097          	auipc	ra,0xffffc
    80005556:	892080e7          	jalr	-1902(ra) # 80000de4 <release>
    kfree((char*)pi);
    8000555a:	8526                	mv	a0,s1
    8000555c:	ffffb097          	auipc	ra,0xffffb
    80005560:	548080e7          	jalr	1352(ra) # 80000aa4 <kfree>
    80005564:	b7f9                	j	80005532 <pipeclose+0x42>

0000000080005566 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005566:	7159                	addi	sp,sp,-112
    80005568:	f486                	sd	ra,104(sp)
    8000556a:	f0a2                	sd	s0,96(sp)
    8000556c:	eca6                	sd	s1,88(sp)
    8000556e:	e8ca                	sd	s2,80(sp)
    80005570:	e4ce                	sd	s3,72(sp)
    80005572:	e0d2                	sd	s4,64(sp)
    80005574:	fc56                	sd	s5,56(sp)
    80005576:	1880                	addi	s0,sp,112
    80005578:	84aa                	mv	s1,a0
    8000557a:	8aae                	mv	s5,a1
    8000557c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000557e:	ffffd097          	auipc	ra,0xffffd
    80005582:	9b6080e7          	jalr	-1610(ra) # 80001f34 <myproc>
    80005586:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005588:	8526                	mv	a0,s1
    8000558a:	ffffb097          	auipc	ra,0xffffb
    8000558e:	7aa080e7          	jalr	1962(ra) # 80000d34 <acquire>
  while(i < n){
    80005592:	0f405063          	blez	s4,80005672 <pipewrite+0x10c>
    80005596:	f85a                	sd	s6,48(sp)
    80005598:	f45e                	sd	s7,40(sp)
    8000559a:	f062                	sd	s8,32(sp)
    8000559c:	ec66                	sd	s9,24(sp)
    8000559e:	e86a                	sd	s10,16(sp)
  int i = 0;
    800055a0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800055a2:	f9f40c13          	addi	s8,s0,-97
    800055a6:	4b85                	li	s7,1
    800055a8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800055aa:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800055ae:	21c48c93          	addi	s9,s1,540
    800055b2:	a099                	j	800055f8 <pipewrite+0x92>
      release(&pi->lock);
    800055b4:	8526                	mv	a0,s1
    800055b6:	ffffc097          	auipc	ra,0xffffc
    800055ba:	82e080e7          	jalr	-2002(ra) # 80000de4 <release>
      return -1;
    800055be:	597d                	li	s2,-1
    800055c0:	7b42                	ld	s6,48(sp)
    800055c2:	7ba2                	ld	s7,40(sp)
    800055c4:	7c02                	ld	s8,32(sp)
    800055c6:	6ce2                	ld	s9,24(sp)
    800055c8:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800055ca:	854a                	mv	a0,s2
    800055cc:	70a6                	ld	ra,104(sp)
    800055ce:	7406                	ld	s0,96(sp)
    800055d0:	64e6                	ld	s1,88(sp)
    800055d2:	6946                	ld	s2,80(sp)
    800055d4:	69a6                	ld	s3,72(sp)
    800055d6:	6a06                	ld	s4,64(sp)
    800055d8:	7ae2                	ld	s5,56(sp)
    800055da:	6165                	addi	sp,sp,112
    800055dc:	8082                	ret
      wakeup(&pi->nread);
    800055de:	856a                	mv	a0,s10
    800055e0:	ffffd097          	auipc	ra,0xffffd
    800055e4:	26e080e7          	jalr	622(ra) # 8000284e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800055e8:	85a6                	mv	a1,s1
    800055ea:	8566                	mv	a0,s9
    800055ec:	ffffd097          	auipc	ra,0xffffd
    800055f0:	1fe080e7          	jalr	510(ra) # 800027ea <sleep>
  while(i < n){
    800055f4:	05495e63          	bge	s2,s4,80005650 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    800055f8:	2204a783          	lw	a5,544(s1)
    800055fc:	dfc5                	beqz	a5,800055b4 <pipewrite+0x4e>
    800055fe:	854e                	mv	a0,s3
    80005600:	ffffd097          	auipc	ra,0xffffd
    80005604:	62e080e7          	jalr	1582(ra) # 80002c2e <killed>
    80005608:	f555                	bnez	a0,800055b4 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000560a:	2184a783          	lw	a5,536(s1)
    8000560e:	21c4a703          	lw	a4,540(s1)
    80005612:	2007879b          	addiw	a5,a5,512
    80005616:	fcf704e3          	beq	a4,a5,800055de <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000561a:	86de                	mv	a3,s7
    8000561c:	01590633          	add	a2,s2,s5
    80005620:	85e2                	mv	a1,s8
    80005622:	0509b503          	ld	a0,80(s3)
    80005626:	ffffc097          	auipc	ra,0xffffc
    8000562a:	626080e7          	jalr	1574(ra) # 80001c4c <copyin>
    8000562e:	05650463          	beq	a0,s6,80005676 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005632:	21c4a783          	lw	a5,540(s1)
    80005636:	0017871b          	addiw	a4,a5,1
    8000563a:	20e4ae23          	sw	a4,540(s1)
    8000563e:	1ff7f793          	andi	a5,a5,511
    80005642:	97a6                	add	a5,a5,s1
    80005644:	f9f44703          	lbu	a4,-97(s0)
    80005648:	00e78c23          	sb	a4,24(a5)
      i++;
    8000564c:	2905                	addiw	s2,s2,1
    8000564e:	b75d                	j	800055f4 <pipewrite+0x8e>
    80005650:	7b42                	ld	s6,48(sp)
    80005652:	7ba2                	ld	s7,40(sp)
    80005654:	7c02                	ld	s8,32(sp)
    80005656:	6ce2                	ld	s9,24(sp)
    80005658:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000565a:	21848513          	addi	a0,s1,536
    8000565e:	ffffd097          	auipc	ra,0xffffd
    80005662:	1f0080e7          	jalr	496(ra) # 8000284e <wakeup>
  release(&pi->lock);
    80005666:	8526                	mv	a0,s1
    80005668:	ffffb097          	auipc	ra,0xffffb
    8000566c:	77c080e7          	jalr	1916(ra) # 80000de4 <release>
  return i;
    80005670:	bfa9                	j	800055ca <pipewrite+0x64>
  int i = 0;
    80005672:	4901                	li	s2,0
    80005674:	b7dd                	j	8000565a <pipewrite+0xf4>
    80005676:	7b42                	ld	s6,48(sp)
    80005678:	7ba2                	ld	s7,40(sp)
    8000567a:	7c02                	ld	s8,32(sp)
    8000567c:	6ce2                	ld	s9,24(sp)
    8000567e:	6d42                	ld	s10,16(sp)
    80005680:	bfe9                	j	8000565a <pipewrite+0xf4>

0000000080005682 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005682:	711d                	addi	sp,sp,-96
    80005684:	ec86                	sd	ra,88(sp)
    80005686:	e8a2                	sd	s0,80(sp)
    80005688:	e4a6                	sd	s1,72(sp)
    8000568a:	e0ca                	sd	s2,64(sp)
    8000568c:	fc4e                	sd	s3,56(sp)
    8000568e:	f852                	sd	s4,48(sp)
    80005690:	f456                	sd	s5,40(sp)
    80005692:	1080                	addi	s0,sp,96
    80005694:	84aa                	mv	s1,a0
    80005696:	892e                	mv	s2,a1
    80005698:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000569a:	ffffd097          	auipc	ra,0xffffd
    8000569e:	89a080e7          	jalr	-1894(ra) # 80001f34 <myproc>
    800056a2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800056a4:	8526                	mv	a0,s1
    800056a6:	ffffb097          	auipc	ra,0xffffb
    800056aa:	68e080e7          	jalr	1678(ra) # 80000d34 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800056ae:	2184a703          	lw	a4,536(s1)
    800056b2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800056b6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800056ba:	02f71b63          	bne	a4,a5,800056f0 <piperead+0x6e>
    800056be:	2244a783          	lw	a5,548(s1)
    800056c2:	c3b1                	beqz	a5,80005706 <piperead+0x84>
    if(killed(pr)){
    800056c4:	8552                	mv	a0,s4
    800056c6:	ffffd097          	auipc	ra,0xffffd
    800056ca:	568080e7          	jalr	1384(ra) # 80002c2e <killed>
    800056ce:	e50d                	bnez	a0,800056f8 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800056d0:	85a6                	mv	a1,s1
    800056d2:	854e                	mv	a0,s3
    800056d4:	ffffd097          	auipc	ra,0xffffd
    800056d8:	116080e7          	jalr	278(ra) # 800027ea <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800056dc:	2184a703          	lw	a4,536(s1)
    800056e0:	21c4a783          	lw	a5,540(s1)
    800056e4:	fcf70de3          	beq	a4,a5,800056be <piperead+0x3c>
    800056e8:	f05a                	sd	s6,32(sp)
    800056ea:	ec5e                	sd	s7,24(sp)
    800056ec:	e862                	sd	s8,16(sp)
    800056ee:	a839                	j	8000570c <piperead+0x8a>
    800056f0:	f05a                	sd	s6,32(sp)
    800056f2:	ec5e                	sd	s7,24(sp)
    800056f4:	e862                	sd	s8,16(sp)
    800056f6:	a819                	j	8000570c <piperead+0x8a>
      release(&pi->lock);
    800056f8:	8526                	mv	a0,s1
    800056fa:	ffffb097          	auipc	ra,0xffffb
    800056fe:	6ea080e7          	jalr	1770(ra) # 80000de4 <release>
      return -1;
    80005702:	59fd                	li	s3,-1
    80005704:	a88d                	j	80005776 <piperead+0xf4>
    80005706:	f05a                	sd	s6,32(sp)
    80005708:	ec5e                	sd	s7,24(sp)
    8000570a:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000570c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000570e:	faf40c13          	addi	s8,s0,-81
    80005712:	4b85                	li	s7,1
    80005714:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005716:	05505263          	blez	s5,8000575a <piperead+0xd8>
    if(pi->nread == pi->nwrite)
    8000571a:	2184a783          	lw	a5,536(s1)
    8000571e:	21c4a703          	lw	a4,540(s1)
    80005722:	02f70c63          	beq	a4,a5,8000575a <piperead+0xd8>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005726:	0017871b          	addiw	a4,a5,1
    8000572a:	20e4ac23          	sw	a4,536(s1)
    8000572e:	1ff7f793          	andi	a5,a5,511
    80005732:	97a6                	add	a5,a5,s1
    80005734:	0187c783          	lbu	a5,24(a5)
    80005738:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000573c:	86de                	mv	a3,s7
    8000573e:	8662                	mv	a2,s8
    80005740:	85ca                	mv	a1,s2
    80005742:	050a3503          	ld	a0,80(s4)
    80005746:	ffffc097          	auipc	ra,0xffffc
    8000574a:	47a080e7          	jalr	1146(ra) # 80001bc0 <copyout>
    8000574e:	01650663          	beq	a0,s6,8000575a <piperead+0xd8>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005752:	2985                	addiw	s3,s3,1
    80005754:	0905                	addi	s2,s2,1
    80005756:	fd3a92e3          	bne	s5,s3,8000571a <piperead+0x98>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000575a:	21c48513          	addi	a0,s1,540
    8000575e:	ffffd097          	auipc	ra,0xffffd
    80005762:	0f0080e7          	jalr	240(ra) # 8000284e <wakeup>
  release(&pi->lock);
    80005766:	8526                	mv	a0,s1
    80005768:	ffffb097          	auipc	ra,0xffffb
    8000576c:	67c080e7          	jalr	1660(ra) # 80000de4 <release>
    80005770:	7b02                	ld	s6,32(sp)
    80005772:	6be2                	ld	s7,24(sp)
    80005774:	6c42                	ld	s8,16(sp)
  return i;
}
    80005776:	854e                	mv	a0,s3
    80005778:	60e6                	ld	ra,88(sp)
    8000577a:	6446                	ld	s0,80(sp)
    8000577c:	64a6                	ld	s1,72(sp)
    8000577e:	6906                	ld	s2,64(sp)
    80005780:	79e2                	ld	s3,56(sp)
    80005782:	7a42                	ld	s4,48(sp)
    80005784:	7aa2                	ld	s5,40(sp)
    80005786:	6125                	addi	sp,sp,96
    80005788:	8082                	ret

000000008000578a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000578a:	1141                	addi	sp,sp,-16
    8000578c:	e406                	sd	ra,8(sp)
    8000578e:	e022                	sd	s0,0(sp)
    80005790:	0800                	addi	s0,sp,16
    80005792:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005794:	0035151b          	slliw	a0,a0,0x3
    80005798:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    8000579a:	8b89                	andi	a5,a5,2
    8000579c:	c399                	beqz	a5,800057a2 <flags2perm+0x18>
      perm |= PTE_W;
    8000579e:	00456513          	ori	a0,a0,4
    return perm;
}
    800057a2:	60a2                	ld	ra,8(sp)
    800057a4:	6402                	ld	s0,0(sp)
    800057a6:	0141                	addi	sp,sp,16
    800057a8:	8082                	ret

00000000800057aa <exec>:

int
exec(char *path, char **argv)
{
    800057aa:	de010113          	addi	sp,sp,-544
    800057ae:	20113c23          	sd	ra,536(sp)
    800057b2:	20813823          	sd	s0,528(sp)
    800057b6:	20913423          	sd	s1,520(sp)
    800057ba:	21213023          	sd	s2,512(sp)
    800057be:	1400                	addi	s0,sp,544
    800057c0:	892a                	mv	s2,a0
    800057c2:	dea43823          	sd	a0,-528(s0)
    800057c6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800057ca:	ffffc097          	auipc	ra,0xffffc
    800057ce:	76a080e7          	jalr	1898(ra) # 80001f34 <myproc>
    800057d2:	84aa                	mv	s1,a0

  begin_op();
    800057d4:	fffff097          	auipc	ra,0xfffff
    800057d8:	3da080e7          	jalr	986(ra) # 80004bae <begin_op>

  if((ip = namei(path)) == 0){
    800057dc:	854a                	mv	a0,s2
    800057de:	fffff097          	auipc	ra,0xfffff
    800057e2:	1ca080e7          	jalr	458(ra) # 800049a8 <namei>
    800057e6:	c525                	beqz	a0,8000584e <exec+0xa4>
    800057e8:	fbd2                	sd	s4,496(sp)
    800057ea:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800057ec:	fffff097          	auipc	ra,0xfffff
    800057f0:	9d2080e7          	jalr	-1582(ra) # 800041be <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800057f4:	04000713          	li	a4,64
    800057f8:	4681                	li	a3,0
    800057fa:	e5040613          	addi	a2,s0,-432
    800057fe:	4581                	li	a1,0
    80005800:	8552                	mv	a0,s4
    80005802:	fffff097          	auipc	ra,0xfffff
    80005806:	c7a080e7          	jalr	-902(ra) # 8000447c <readi>
    8000580a:	04000793          	li	a5,64
    8000580e:	00f51a63          	bne	a0,a5,80005822 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005812:	e5042703          	lw	a4,-432(s0)
    80005816:	464c47b7          	lui	a5,0x464c4
    8000581a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000581e:	02f70e63          	beq	a4,a5,8000585a <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005822:	8552                	mv	a0,s4
    80005824:	fffff097          	auipc	ra,0xfffff
    80005828:	c02080e7          	jalr	-1022(ra) # 80004426 <iunlockput>
    end_op();
    8000582c:	fffff097          	auipc	ra,0xfffff
    80005830:	402080e7          	jalr	1026(ra) # 80004c2e <end_op>
  }
  return -1;
    80005834:	557d                	li	a0,-1
    80005836:	7a5e                	ld	s4,496(sp)
}
    80005838:	21813083          	ld	ra,536(sp)
    8000583c:	21013403          	ld	s0,528(sp)
    80005840:	20813483          	ld	s1,520(sp)
    80005844:	20013903          	ld	s2,512(sp)
    80005848:	22010113          	addi	sp,sp,544
    8000584c:	8082                	ret
    end_op();
    8000584e:	fffff097          	auipc	ra,0xfffff
    80005852:	3e0080e7          	jalr	992(ra) # 80004c2e <end_op>
    return -1;
    80005856:	557d                	li	a0,-1
    80005858:	b7c5                	j	80005838 <exec+0x8e>
    8000585a:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000585c:	8526                	mv	a0,s1
    8000585e:	ffffc097          	auipc	ra,0xffffc
    80005862:	79c080e7          	jalr	1948(ra) # 80001ffa <proc_pagetable>
    80005866:	8b2a                	mv	s6,a0
    80005868:	2c050363          	beqz	a0,80005b2e <exec+0x384>
    8000586c:	ffce                	sd	s3,504(sp)
    8000586e:	f7d6                	sd	s5,488(sp)
    80005870:	efde                	sd	s7,472(sp)
    80005872:	ebe2                	sd	s8,464(sp)
    80005874:	e7e6                	sd	s9,456(sp)
    80005876:	e3ea                	sd	s10,448(sp)
    80005878:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000587a:	e8845783          	lhu	a5,-376(s0)
    8000587e:	10078563          	beqz	a5,80005988 <exec+0x1de>
    80005882:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005886:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005888:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000588a:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    8000588e:	6c85                	lui	s9,0x1
    80005890:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005894:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005898:	6a85                	lui	s5,0x1
    8000589a:	a0b5                	j	80005906 <exec+0x15c>
      panic("loadseg: address should exist");
    8000589c:	00004517          	auipc	a0,0x4
    800058a0:	e0c50513          	addi	a0,a0,-500 # 800096a8 <etext+0x6a8>
    800058a4:	ffffb097          	auipc	ra,0xffffb
    800058a8:	cba080e7          	jalr	-838(ra) # 8000055e <panic>
    if(sz - i < PGSIZE)
    800058ac:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800058ae:	874a                	mv	a4,s2
    800058b0:	009b86bb          	addw	a3,s7,s1
    800058b4:	4581                	li	a1,0
    800058b6:	8552                	mv	a0,s4
    800058b8:	fffff097          	auipc	ra,0xfffff
    800058bc:	bc4080e7          	jalr	-1084(ra) # 8000447c <readi>
    800058c0:	26a91b63          	bne	s2,a0,80005b36 <exec+0x38c>
  for(i = 0; i < sz; i += PGSIZE){
    800058c4:	009a84bb          	addw	s1,s5,s1
    800058c8:	0334f463          	bgeu	s1,s3,800058f0 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    800058cc:	02049593          	slli	a1,s1,0x20
    800058d0:	9181                	srli	a1,a1,0x20
    800058d2:	95e2                	add	a1,a1,s8
    800058d4:	855a                	mv	a0,s6
    800058d6:	ffffc097          	auipc	ra,0xffffc
    800058da:	9c6080e7          	jalr	-1594(ra) # 8000129c <walkaddr>
    800058de:	862a                	mv	a2,a0
    if(pa == 0)
    800058e0:	dd55                	beqz	a0,8000589c <exec+0xf2>
    if(sz - i < PGSIZE)
    800058e2:	409987bb          	subw	a5,s3,s1
    800058e6:	893e                	mv	s2,a5
    800058e8:	fcfcf2e3          	bgeu	s9,a5,800058ac <exec+0x102>
    800058ec:	8956                	mv	s2,s5
    800058ee:	bf7d                	j	800058ac <exec+0x102>
    sz = sz1;
    800058f0:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800058f4:	2d05                	addiw	s10,s10,1
    800058f6:	e0843783          	ld	a5,-504(s0)
    800058fa:	0387869b          	addiw	a3,a5,56
    800058fe:	e8845783          	lhu	a5,-376(s0)
    80005902:	08fd5463          	bge	s10,a5,8000598a <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005906:	e0d43423          	sd	a3,-504(s0)
    8000590a:	876e                	mv	a4,s11
    8000590c:	e1840613          	addi	a2,s0,-488
    80005910:	4581                	li	a1,0
    80005912:	8552                	mv	a0,s4
    80005914:	fffff097          	auipc	ra,0xfffff
    80005918:	b68080e7          	jalr	-1176(ra) # 8000447c <readi>
    8000591c:	21b51b63          	bne	a0,s11,80005b32 <exec+0x388>
    if(ph.type != ELF_PROG_LOAD)
    80005920:	e1842783          	lw	a5,-488(s0)
    80005924:	4705                	li	a4,1
    80005926:	fce797e3          	bne	a5,a4,800058f4 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    8000592a:	e4043483          	ld	s1,-448(s0)
    8000592e:	e3843783          	ld	a5,-456(s0)
    80005932:	22f4e263          	bltu	s1,a5,80005b56 <exec+0x3ac>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005936:	e2843783          	ld	a5,-472(s0)
    8000593a:	94be                	add	s1,s1,a5
    8000593c:	22f4e063          	bltu	s1,a5,80005b5c <exec+0x3b2>
    if(ph.vaddr % PGSIZE != 0)
    80005940:	de843703          	ld	a4,-536(s0)
    80005944:	8ff9                	and	a5,a5,a4
    80005946:	20079e63          	bnez	a5,80005b62 <exec+0x3b8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000594a:	e1c42503          	lw	a0,-484(s0)
    8000594e:	00000097          	auipc	ra,0x0
    80005952:	e3c080e7          	jalr	-452(ra) # 8000578a <flags2perm>
    80005956:	86aa                	mv	a3,a0
    80005958:	8626                	mv	a2,s1
    8000595a:	85ca                	mv	a1,s2
    8000595c:	855a                	mv	a0,s6
    8000595e:	ffffc097          	auipc	ra,0xffffc
    80005962:	d10080e7          	jalr	-752(ra) # 8000166e <uvmalloc>
    80005966:	dea43c23          	sd	a0,-520(s0)
    8000596a:	1e050f63          	beqz	a0,80005b68 <exec+0x3be>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000596e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005972:	00098863          	beqz	s3,80005982 <exec+0x1d8>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005976:	e2843c03          	ld	s8,-472(s0)
    8000597a:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000597e:	4481                	li	s1,0
    80005980:	b7b1                	j	800058cc <exec+0x122>
    sz = sz1;
    80005982:	df843903          	ld	s2,-520(s0)
    80005986:	b7bd                	j	800058f4 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005988:	4901                	li	s2,0
  iunlockput(ip);
    8000598a:	8552                	mv	a0,s4
    8000598c:	fffff097          	auipc	ra,0xfffff
    80005990:	a9a080e7          	jalr	-1382(ra) # 80004426 <iunlockput>
  end_op();
    80005994:	fffff097          	auipc	ra,0xfffff
    80005998:	29a080e7          	jalr	666(ra) # 80004c2e <end_op>
  p = myproc();
    8000599c:	ffffc097          	auipc	ra,0xffffc
    800059a0:	598080e7          	jalr	1432(ra) # 80001f34 <myproc>
    800059a4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800059a6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800059aa:	6985                	lui	s3,0x1
    800059ac:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800059ae:	99ca                	add	s3,s3,s2
    800059b0:	77fd                	lui	a5,0xfffff
    800059b2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800059b6:	4691                	li	a3,4
    800059b8:	6609                	lui	a2,0x2
    800059ba:	964e                	add	a2,a2,s3
    800059bc:	85ce                	mv	a1,s3
    800059be:	855a                	mv	a0,s6
    800059c0:	ffffc097          	auipc	ra,0xffffc
    800059c4:	cae080e7          	jalr	-850(ra) # 8000166e <uvmalloc>
    800059c8:	8a2a                	mv	s4,a0
    800059ca:	e115                	bnez	a0,800059ee <exec+0x244>
    proc_freepagetable(pagetable, sz);
    800059cc:	85ce                	mv	a1,s3
    800059ce:	855a                	mv	a0,s6
    800059d0:	ffffc097          	auipc	ra,0xffffc
    800059d4:	6c6080e7          	jalr	1734(ra) # 80002096 <proc_freepagetable>
  return -1;
    800059d8:	557d                	li	a0,-1
    800059da:	79fe                	ld	s3,504(sp)
    800059dc:	7a5e                	ld	s4,496(sp)
    800059de:	7abe                	ld	s5,488(sp)
    800059e0:	7b1e                	ld	s6,480(sp)
    800059e2:	6bfe                	ld	s7,472(sp)
    800059e4:	6c5e                	ld	s8,464(sp)
    800059e6:	6cbe                	ld	s9,456(sp)
    800059e8:	6d1e                	ld	s10,448(sp)
    800059ea:	7dfa                	ld	s11,440(sp)
    800059ec:	b5b1                	j	80005838 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    800059ee:	75f9                	lui	a1,0xffffe
    800059f0:	95aa                	add	a1,a1,a0
    800059f2:	855a                	mv	a0,s6
    800059f4:	ffffc097          	auipc	ra,0xffffc
    800059f8:	19a080e7          	jalr	410(ra) # 80001b8e <uvmclear>
  stackbase = sp - PGSIZE;
    800059fc:	800a0b93          	addi	s7,s4,-2048
    80005a00:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80005a04:	e0043783          	ld	a5,-512(s0)
    80005a08:	6388                	ld	a0,0(a5)
  sp = sz;
    80005a0a:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80005a0c:	4481                	li	s1,0
    ustack[argc] = sp;
    80005a0e:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005a12:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005a16:	c135                	beqz	a0,80005a7a <exec+0x2d0>
    sp -= strlen(argv[argc]) + 1;
    80005a18:	ffffb097          	auipc	ra,0xffffb
    80005a1c:	5a2080e7          	jalr	1442(ra) # 80000fba <strlen>
    80005a20:	0015079b          	addiw	a5,a0,1
    80005a24:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005a28:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005a2c:	15796163          	bltu	s2,s7,80005b6e <exec+0x3c4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005a30:	e0043d83          	ld	s11,-512(s0)
    80005a34:	000db983          	ld	s3,0(s11)
    80005a38:	854e                	mv	a0,s3
    80005a3a:	ffffb097          	auipc	ra,0xffffb
    80005a3e:	580080e7          	jalr	1408(ra) # 80000fba <strlen>
    80005a42:	0015069b          	addiw	a3,a0,1
    80005a46:	864e                	mv	a2,s3
    80005a48:	85ca                	mv	a1,s2
    80005a4a:	855a                	mv	a0,s6
    80005a4c:	ffffc097          	auipc	ra,0xffffc
    80005a50:	174080e7          	jalr	372(ra) # 80001bc0 <copyout>
    80005a54:	10054f63          	bltz	a0,80005b72 <exec+0x3c8>
    ustack[argc] = sp;
    80005a58:	00349793          	slli	a5,s1,0x3
    80005a5c:	97e6                	add	a5,a5,s9
    80005a5e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ff90f28>
  for(argc = 0; argv[argc]; argc++) {
    80005a62:	0485                	addi	s1,s1,1
    80005a64:	008d8793          	addi	a5,s11,8
    80005a68:	e0f43023          	sd	a5,-512(s0)
    80005a6c:	008db503          	ld	a0,8(s11)
    80005a70:	c509                	beqz	a0,80005a7a <exec+0x2d0>
    if(argc >= MAXARG)
    80005a72:	fb8493e3          	bne	s1,s8,80005a18 <exec+0x26e>
  sz = sz1;
    80005a76:	89d2                	mv	s3,s4
    80005a78:	bf91                	j	800059cc <exec+0x222>
  ustack[argc] = 0;
    80005a7a:	00349793          	slli	a5,s1,0x3
    80005a7e:	f9078793          	addi	a5,a5,-112
    80005a82:	97a2                	add	a5,a5,s0
    80005a84:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005a88:	00349693          	slli	a3,s1,0x3
    80005a8c:	06a1                	addi	a3,a3,8
    80005a8e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005a92:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005a96:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005a98:	f3796ae3          	bltu	s2,s7,800059cc <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005a9c:	e9040613          	addi	a2,s0,-368
    80005aa0:	85ca                	mv	a1,s2
    80005aa2:	855a                	mv	a0,s6
    80005aa4:	ffffc097          	auipc	ra,0xffffc
    80005aa8:	11c080e7          	jalr	284(ra) # 80001bc0 <copyout>
    80005aac:	f20540e3          	bltz	a0,800059cc <exec+0x222>
  p->trapframe->a1 = sp;
    80005ab0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005ab4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005ab8:	df043783          	ld	a5,-528(s0)
    80005abc:	0007c703          	lbu	a4,0(a5)
    80005ac0:	cf11                	beqz	a4,80005adc <exec+0x332>
    80005ac2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005ac4:	02f00693          	li	a3,47
    80005ac8:	a029                	j	80005ad2 <exec+0x328>
  for(last=s=path; *s; s++)
    80005aca:	0785                	addi	a5,a5,1
    80005acc:	fff7c703          	lbu	a4,-1(a5)
    80005ad0:	c711                	beqz	a4,80005adc <exec+0x332>
    if(*s == '/')
    80005ad2:	fed71ce3          	bne	a4,a3,80005aca <exec+0x320>
      last = s+1;
    80005ad6:	def43823          	sd	a5,-528(s0)
    80005ada:	bfc5                	j	80005aca <exec+0x320>
  safestrcpy(p->name, last, sizeof(p->name));
    80005adc:	4641                	li	a2,16
    80005ade:	df043583          	ld	a1,-528(s0)
    80005ae2:	158a8513          	addi	a0,s5,344
    80005ae6:	ffffb097          	auipc	ra,0xffffb
    80005aea:	49e080e7          	jalr	1182(ra) # 80000f84 <safestrcpy>
  oldpagetable = p->pagetable;
    80005aee:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005af2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005af6:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005afa:	058ab783          	ld	a5,88(s5)
    80005afe:	e6843703          	ld	a4,-408(s0)
    80005b02:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005b04:	058ab783          	ld	a5,88(s5)
    80005b08:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005b0c:	85ea                	mv	a1,s10
    80005b0e:	ffffc097          	auipc	ra,0xffffc
    80005b12:	588080e7          	jalr	1416(ra) # 80002096 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005b16:	0004851b          	sext.w	a0,s1
    80005b1a:	79fe                	ld	s3,504(sp)
    80005b1c:	7a5e                	ld	s4,496(sp)
    80005b1e:	7abe                	ld	s5,488(sp)
    80005b20:	7b1e                	ld	s6,480(sp)
    80005b22:	6bfe                	ld	s7,472(sp)
    80005b24:	6c5e                	ld	s8,464(sp)
    80005b26:	6cbe                	ld	s9,456(sp)
    80005b28:	6d1e                	ld	s10,448(sp)
    80005b2a:	7dfa                	ld	s11,440(sp)
    80005b2c:	b331                	j	80005838 <exec+0x8e>
    80005b2e:	7b1e                	ld	s6,480(sp)
    80005b30:	b9cd                	j	80005822 <exec+0x78>
    80005b32:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005b36:	df843583          	ld	a1,-520(s0)
    80005b3a:	855a                	mv	a0,s6
    80005b3c:	ffffc097          	auipc	ra,0xffffc
    80005b40:	55a080e7          	jalr	1370(ra) # 80002096 <proc_freepagetable>
  if(ip){
    80005b44:	79fe                	ld	s3,504(sp)
    80005b46:	7abe                	ld	s5,488(sp)
    80005b48:	7b1e                	ld	s6,480(sp)
    80005b4a:	6bfe                	ld	s7,472(sp)
    80005b4c:	6c5e                	ld	s8,464(sp)
    80005b4e:	6cbe                	ld	s9,456(sp)
    80005b50:	6d1e                	ld	s10,448(sp)
    80005b52:	7dfa                	ld	s11,440(sp)
    80005b54:	b1f9                	j	80005822 <exec+0x78>
    80005b56:	df243c23          	sd	s2,-520(s0)
    80005b5a:	bff1                	j	80005b36 <exec+0x38c>
    80005b5c:	df243c23          	sd	s2,-520(s0)
    80005b60:	bfd9                	j	80005b36 <exec+0x38c>
    80005b62:	df243c23          	sd	s2,-520(s0)
    80005b66:	bfc1                	j	80005b36 <exec+0x38c>
    80005b68:	df243c23          	sd	s2,-520(s0)
    80005b6c:	b7e9                	j	80005b36 <exec+0x38c>
  sz = sz1;
    80005b6e:	89d2                	mv	s3,s4
    80005b70:	bdb1                	j	800059cc <exec+0x222>
    80005b72:	89d2                	mv	s3,s4
    80005b74:	bda1                	j	800059cc <exec+0x222>

0000000080005b76 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005b76:	7179                	addi	sp,sp,-48
    80005b78:	f406                	sd	ra,40(sp)
    80005b7a:	f022                	sd	s0,32(sp)
    80005b7c:	ec26                	sd	s1,24(sp)
    80005b7e:	e84a                	sd	s2,16(sp)
    80005b80:	1800                	addi	s0,sp,48
    80005b82:	892e                	mv	s2,a1
    80005b84:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005b86:	fdc40593          	addi	a1,s0,-36
    80005b8a:	ffffe097          	auipc	ra,0xffffe
    80005b8e:	9f0080e7          	jalr	-1552(ra) # 8000357a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005b92:	fdc42703          	lw	a4,-36(s0)
    80005b96:	47bd                	li	a5,15
    80005b98:	02e7ec63          	bltu	a5,a4,80005bd0 <argfd+0x5a>
    80005b9c:	ffffc097          	auipc	ra,0xffffc
    80005ba0:	398080e7          	jalr	920(ra) # 80001f34 <myproc>
    80005ba4:	fdc42703          	lw	a4,-36(s0)
    80005ba8:	00371793          	slli	a5,a4,0x3
    80005bac:	0d078793          	addi	a5,a5,208
    80005bb0:	953e                	add	a0,a0,a5
    80005bb2:	611c                	ld	a5,0(a0)
    80005bb4:	c385                	beqz	a5,80005bd4 <argfd+0x5e>
    return -1;
  if(pfd)
    80005bb6:	00090463          	beqz	s2,80005bbe <argfd+0x48>
    *pfd = fd;
    80005bba:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005bbe:	4501                	li	a0,0
  if(pf)
    80005bc0:	c091                	beqz	s1,80005bc4 <argfd+0x4e>
    *pf = f;
    80005bc2:	e09c                	sd	a5,0(s1)
}
    80005bc4:	70a2                	ld	ra,40(sp)
    80005bc6:	7402                	ld	s0,32(sp)
    80005bc8:	64e2                	ld	s1,24(sp)
    80005bca:	6942                	ld	s2,16(sp)
    80005bcc:	6145                	addi	sp,sp,48
    80005bce:	8082                	ret
    return -1;
    80005bd0:	557d                	li	a0,-1
    80005bd2:	bfcd                	j	80005bc4 <argfd+0x4e>
    80005bd4:	557d                	li	a0,-1
    80005bd6:	b7fd                	j	80005bc4 <argfd+0x4e>

0000000080005bd8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005bd8:	1101                	addi	sp,sp,-32
    80005bda:	ec06                	sd	ra,24(sp)
    80005bdc:	e822                	sd	s0,16(sp)
    80005bde:	e426                	sd	s1,8(sp)
    80005be0:	1000                	addi	s0,sp,32
    80005be2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005be4:	ffffc097          	auipc	ra,0xffffc
    80005be8:	350080e7          	jalr	848(ra) # 80001f34 <myproc>
    80005bec:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005bee:	0d050793          	addi	a5,a0,208
    80005bf2:	4501                	li	a0,0
    80005bf4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005bf6:	6398                	ld	a4,0(a5)
    80005bf8:	cb19                	beqz	a4,80005c0e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005bfa:	2505                	addiw	a0,a0,1
    80005bfc:	07a1                	addi	a5,a5,8
    80005bfe:	fed51ce3          	bne	a0,a3,80005bf6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005c02:	557d                	li	a0,-1
}
    80005c04:	60e2                	ld	ra,24(sp)
    80005c06:	6442                	ld	s0,16(sp)
    80005c08:	64a2                	ld	s1,8(sp)
    80005c0a:	6105                	addi	sp,sp,32
    80005c0c:	8082                	ret
      p->ofile[fd] = f;
    80005c0e:	00351793          	slli	a5,a0,0x3
    80005c12:	0d078793          	addi	a5,a5,208
    80005c16:	963e                	add	a2,a2,a5
    80005c18:	e204                	sd	s1,0(a2)
      return fd;
    80005c1a:	b7ed                	j	80005c04 <fdalloc+0x2c>

0000000080005c1c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005c1c:	715d                	addi	sp,sp,-80
    80005c1e:	e486                	sd	ra,72(sp)
    80005c20:	e0a2                	sd	s0,64(sp)
    80005c22:	fc26                	sd	s1,56(sp)
    80005c24:	f84a                	sd	s2,48(sp)
    80005c26:	f44e                	sd	s3,40(sp)
    80005c28:	f052                	sd	s4,32(sp)
    80005c2a:	ec56                	sd	s5,24(sp)
    80005c2c:	e85a                	sd	s6,16(sp)
    80005c2e:	0880                	addi	s0,sp,80
    80005c30:	892e                	mv	s2,a1
    80005c32:	8a2e                	mv	s4,a1
    80005c34:	8ab2                	mv	s5,a2
    80005c36:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005c38:	fb040593          	addi	a1,s0,-80
    80005c3c:	fffff097          	auipc	ra,0xfffff
    80005c40:	d8a080e7          	jalr	-630(ra) # 800049c6 <nameiparent>
    80005c44:	84aa                	mv	s1,a0
    80005c46:	14050b63          	beqz	a0,80005d9c <create+0x180>
    return 0;

  ilock(dp);
    80005c4a:	ffffe097          	auipc	ra,0xffffe
    80005c4e:	574080e7          	jalr	1396(ra) # 800041be <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005c52:	4601                	li	a2,0
    80005c54:	fb040593          	addi	a1,s0,-80
    80005c58:	8526                	mv	a0,s1
    80005c5a:	fffff097          	auipc	ra,0xfffff
    80005c5e:	a5e080e7          	jalr	-1442(ra) # 800046b8 <dirlookup>
    80005c62:	89aa                	mv	s3,a0
    80005c64:	c921                	beqz	a0,80005cb4 <create+0x98>
    iunlockput(dp);
    80005c66:	8526                	mv	a0,s1
    80005c68:	ffffe097          	auipc	ra,0xffffe
    80005c6c:	7be080e7          	jalr	1982(ra) # 80004426 <iunlockput>
    ilock(ip);
    80005c70:	854e                	mv	a0,s3
    80005c72:	ffffe097          	auipc	ra,0xffffe
    80005c76:	54c080e7          	jalr	1356(ra) # 800041be <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005c7a:	4789                	li	a5,2
    80005c7c:	02f91563          	bne	s2,a5,80005ca6 <create+0x8a>
    80005c80:	0449d783          	lhu	a5,68(s3)
    80005c84:	37f9                	addiw	a5,a5,-2
    80005c86:	17c2                	slli	a5,a5,0x30
    80005c88:	93c1                	srli	a5,a5,0x30
    80005c8a:	4705                	li	a4,1
    80005c8c:	00f76d63          	bltu	a4,a5,80005ca6 <create+0x8a>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005c90:	854e                	mv	a0,s3
    80005c92:	60a6                	ld	ra,72(sp)
    80005c94:	6406                	ld	s0,64(sp)
    80005c96:	74e2                	ld	s1,56(sp)
    80005c98:	7942                	ld	s2,48(sp)
    80005c9a:	79a2                	ld	s3,40(sp)
    80005c9c:	7a02                	ld	s4,32(sp)
    80005c9e:	6ae2                	ld	s5,24(sp)
    80005ca0:	6b42                	ld	s6,16(sp)
    80005ca2:	6161                	addi	sp,sp,80
    80005ca4:	8082                	ret
    iunlockput(ip);
    80005ca6:	854e                	mv	a0,s3
    80005ca8:	ffffe097          	auipc	ra,0xffffe
    80005cac:	77e080e7          	jalr	1918(ra) # 80004426 <iunlockput>
    return 0;
    80005cb0:	4981                	li	s3,0
    80005cb2:	bff9                	j	80005c90 <create+0x74>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005cb4:	85ca                	mv	a1,s2
    80005cb6:	4088                	lw	a0,0(s1)
    80005cb8:	ffffe097          	auipc	ra,0xffffe
    80005cbc:	362080e7          	jalr	866(ra) # 8000401a <ialloc>
    80005cc0:	892a                	mv	s2,a0
    80005cc2:	c531                	beqz	a0,80005d0e <create+0xf2>
  ilock(ip);
    80005cc4:	ffffe097          	auipc	ra,0xffffe
    80005cc8:	4fa080e7          	jalr	1274(ra) # 800041be <ilock>
  ip->major = major;
    80005ccc:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80005cd0:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80005cd4:	4785                	li	a5,1
    80005cd6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005cda:	854a                	mv	a0,s2
    80005cdc:	ffffe097          	auipc	ra,0xffffe
    80005ce0:	416080e7          	jalr	1046(ra) # 800040f2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005ce4:	4705                	li	a4,1
    80005ce6:	02ea0a63          	beq	s4,a4,80005d1a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005cea:	00492603          	lw	a2,4(s2)
    80005cee:	fb040593          	addi	a1,s0,-80
    80005cf2:	8526                	mv	a0,s1
    80005cf4:	fffff097          	auipc	ra,0xfffff
    80005cf8:	bf2080e7          	jalr	-1038(ra) # 800048e6 <dirlink>
    80005cfc:	06054e63          	bltz	a0,80005d78 <create+0x15c>
  iunlockput(dp);
    80005d00:	8526                	mv	a0,s1
    80005d02:	ffffe097          	auipc	ra,0xffffe
    80005d06:	724080e7          	jalr	1828(ra) # 80004426 <iunlockput>
  return ip;
    80005d0a:	89ca                	mv	s3,s2
    80005d0c:	b751                	j	80005c90 <create+0x74>
    iunlockput(dp);
    80005d0e:	8526                	mv	a0,s1
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	716080e7          	jalr	1814(ra) # 80004426 <iunlockput>
    return 0;
    80005d18:	bfa5                	j	80005c90 <create+0x74>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005d1a:	00492603          	lw	a2,4(s2)
    80005d1e:	00004597          	auipc	a1,0x4
    80005d22:	9aa58593          	addi	a1,a1,-1622 # 800096c8 <etext+0x6c8>
    80005d26:	854a                	mv	a0,s2
    80005d28:	fffff097          	auipc	ra,0xfffff
    80005d2c:	bbe080e7          	jalr	-1090(ra) # 800048e6 <dirlink>
    80005d30:	04054463          	bltz	a0,80005d78 <create+0x15c>
    80005d34:	40d0                	lw	a2,4(s1)
    80005d36:	00004597          	auipc	a1,0x4
    80005d3a:	99a58593          	addi	a1,a1,-1638 # 800096d0 <etext+0x6d0>
    80005d3e:	854a                	mv	a0,s2
    80005d40:	fffff097          	auipc	ra,0xfffff
    80005d44:	ba6080e7          	jalr	-1114(ra) # 800048e6 <dirlink>
    80005d48:	02054863          	bltz	a0,80005d78 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005d4c:	00492603          	lw	a2,4(s2)
    80005d50:	fb040593          	addi	a1,s0,-80
    80005d54:	8526                	mv	a0,s1
    80005d56:	fffff097          	auipc	ra,0xfffff
    80005d5a:	b90080e7          	jalr	-1136(ra) # 800048e6 <dirlink>
    80005d5e:	00054d63          	bltz	a0,80005d78 <create+0x15c>
    dp->nlink++;  // for ".."
    80005d62:	04a4d783          	lhu	a5,74(s1)
    80005d66:	2785                	addiw	a5,a5,1
    80005d68:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005d6c:	8526                	mv	a0,s1
    80005d6e:	ffffe097          	auipc	ra,0xffffe
    80005d72:	384080e7          	jalr	900(ra) # 800040f2 <iupdate>
    80005d76:	b769                	j	80005d00 <create+0xe4>
  ip->nlink = 0;
    80005d78:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005d7c:	854a                	mv	a0,s2
    80005d7e:	ffffe097          	auipc	ra,0xffffe
    80005d82:	374080e7          	jalr	884(ra) # 800040f2 <iupdate>
  iunlockput(ip);
    80005d86:	854a                	mv	a0,s2
    80005d88:	ffffe097          	auipc	ra,0xffffe
    80005d8c:	69e080e7          	jalr	1694(ra) # 80004426 <iunlockput>
  iunlockput(dp);
    80005d90:	8526                	mv	a0,s1
    80005d92:	ffffe097          	auipc	ra,0xffffe
    80005d96:	694080e7          	jalr	1684(ra) # 80004426 <iunlockput>
  return 0;
    80005d9a:	bddd                	j	80005c90 <create+0x74>
    return 0;
    80005d9c:	89aa                	mv	s3,a0
    80005d9e:	bdcd                	j	80005c90 <create+0x74>

0000000080005da0 <sys_dup>:
{
    80005da0:	7179                	addi	sp,sp,-48
    80005da2:	f406                	sd	ra,40(sp)
    80005da4:	f022                	sd	s0,32(sp)
    80005da6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005da8:	fd840613          	addi	a2,s0,-40
    80005dac:	4581                	li	a1,0
    80005dae:	4501                	li	a0,0
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	dc6080e7          	jalr	-570(ra) # 80005b76 <argfd>
    return -1;
    80005db8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005dba:	02054763          	bltz	a0,80005de8 <sys_dup+0x48>
    80005dbe:	ec26                	sd	s1,24(sp)
    80005dc0:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005dc2:	fd843483          	ld	s1,-40(s0)
    80005dc6:	8526                	mv	a0,s1
    80005dc8:	00000097          	auipc	ra,0x0
    80005dcc:	e10080e7          	jalr	-496(ra) # 80005bd8 <fdalloc>
    80005dd0:	892a                	mv	s2,a0
    return -1;
    80005dd2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005dd4:	00054f63          	bltz	a0,80005df2 <sys_dup+0x52>
  filedup(f);
    80005dd8:	8526                	mv	a0,s1
    80005dda:	fffff097          	auipc	ra,0xfffff
    80005dde:	264080e7          	jalr	612(ra) # 8000503e <filedup>
  return fd;
    80005de2:	87ca                	mv	a5,s2
    80005de4:	64e2                	ld	s1,24(sp)
    80005de6:	6942                	ld	s2,16(sp)
}
    80005de8:	853e                	mv	a0,a5
    80005dea:	70a2                	ld	ra,40(sp)
    80005dec:	7402                	ld	s0,32(sp)
    80005dee:	6145                	addi	sp,sp,48
    80005df0:	8082                	ret
    80005df2:	64e2                	ld	s1,24(sp)
    80005df4:	6942                	ld	s2,16(sp)
    80005df6:	bfcd                	j	80005de8 <sys_dup+0x48>

0000000080005df8 <sys_read>:
{
    80005df8:	7179                	addi	sp,sp,-48
    80005dfa:	f406                	sd	ra,40(sp)
    80005dfc:	f022                	sd	s0,32(sp)
    80005dfe:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005e00:	fd840593          	addi	a1,s0,-40
    80005e04:	4505                	li	a0,1
    80005e06:	ffffd097          	auipc	ra,0xffffd
    80005e0a:	794080e7          	jalr	1940(ra) # 8000359a <argaddr>
  argint(2, &n);
    80005e0e:	fe440593          	addi	a1,s0,-28
    80005e12:	4509                	li	a0,2
    80005e14:	ffffd097          	auipc	ra,0xffffd
    80005e18:	766080e7          	jalr	1894(ra) # 8000357a <argint>
  if(argfd(0, 0, &f) < 0)
    80005e1c:	fe840613          	addi	a2,s0,-24
    80005e20:	4581                	li	a1,0
    80005e22:	4501                	li	a0,0
    80005e24:	00000097          	auipc	ra,0x0
    80005e28:	d52080e7          	jalr	-686(ra) # 80005b76 <argfd>
    80005e2c:	87aa                	mv	a5,a0
    return -1;
    80005e2e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005e30:	0007cc63          	bltz	a5,80005e48 <sys_read+0x50>
  return fileread(f, p, n);
    80005e34:	fe442603          	lw	a2,-28(s0)
    80005e38:	fd843583          	ld	a1,-40(s0)
    80005e3c:	fe843503          	ld	a0,-24(s0)
    80005e40:	fffff097          	auipc	ra,0xfffff
    80005e44:	3a8080e7          	jalr	936(ra) # 800051e8 <fileread>
}
    80005e48:	70a2                	ld	ra,40(sp)
    80005e4a:	7402                	ld	s0,32(sp)
    80005e4c:	6145                	addi	sp,sp,48
    80005e4e:	8082                	ret

0000000080005e50 <sys_write>:
{
    80005e50:	7179                	addi	sp,sp,-48
    80005e52:	f406                	sd	ra,40(sp)
    80005e54:	f022                	sd	s0,32(sp)
    80005e56:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005e58:	fd840593          	addi	a1,s0,-40
    80005e5c:	4505                	li	a0,1
    80005e5e:	ffffd097          	auipc	ra,0xffffd
    80005e62:	73c080e7          	jalr	1852(ra) # 8000359a <argaddr>
  argint(2, &n);
    80005e66:	fe440593          	addi	a1,s0,-28
    80005e6a:	4509                	li	a0,2
    80005e6c:	ffffd097          	auipc	ra,0xffffd
    80005e70:	70e080e7          	jalr	1806(ra) # 8000357a <argint>
  if(argfd(0, 0, &f) < 0)
    80005e74:	fe840613          	addi	a2,s0,-24
    80005e78:	4581                	li	a1,0
    80005e7a:	4501                	li	a0,0
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	cfa080e7          	jalr	-774(ra) # 80005b76 <argfd>
    80005e84:	87aa                	mv	a5,a0
    return -1;
    80005e86:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005e88:	0007cc63          	bltz	a5,80005ea0 <sys_write+0x50>
  return filewrite(f, p, n);
    80005e8c:	fe442603          	lw	a2,-28(s0)
    80005e90:	fd843583          	ld	a1,-40(s0)
    80005e94:	fe843503          	ld	a0,-24(s0)
    80005e98:	fffff097          	auipc	ra,0xfffff
    80005e9c:	428080e7          	jalr	1064(ra) # 800052c0 <filewrite>
}
    80005ea0:	70a2                	ld	ra,40(sp)
    80005ea2:	7402                	ld	s0,32(sp)
    80005ea4:	6145                	addi	sp,sp,48
    80005ea6:	8082                	ret

0000000080005ea8 <sys_close>:
{
    80005ea8:	1101                	addi	sp,sp,-32
    80005eaa:	ec06                	sd	ra,24(sp)
    80005eac:	e822                	sd	s0,16(sp)
    80005eae:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005eb0:	fe040613          	addi	a2,s0,-32
    80005eb4:	fec40593          	addi	a1,s0,-20
    80005eb8:	4501                	li	a0,0
    80005eba:	00000097          	auipc	ra,0x0
    80005ebe:	cbc080e7          	jalr	-836(ra) # 80005b76 <argfd>
    return -1;
    80005ec2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005ec4:	02054563          	bltz	a0,80005eee <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80005ec8:	ffffc097          	auipc	ra,0xffffc
    80005ecc:	06c080e7          	jalr	108(ra) # 80001f34 <myproc>
    80005ed0:	fec42783          	lw	a5,-20(s0)
    80005ed4:	078e                	slli	a5,a5,0x3
    80005ed6:	0d078793          	addi	a5,a5,208
    80005eda:	953e                	add	a0,a0,a5
    80005edc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005ee0:	fe043503          	ld	a0,-32(s0)
    80005ee4:	fffff097          	auipc	ra,0xfffff
    80005ee8:	1ac080e7          	jalr	428(ra) # 80005090 <fileclose>
  return 0;
    80005eec:	4781                	li	a5,0
}
    80005eee:	853e                	mv	a0,a5
    80005ef0:	60e2                	ld	ra,24(sp)
    80005ef2:	6442                	ld	s0,16(sp)
    80005ef4:	6105                	addi	sp,sp,32
    80005ef6:	8082                	ret

0000000080005ef8 <sys_fstat>:
{
    80005ef8:	1101                	addi	sp,sp,-32
    80005efa:	ec06                	sd	ra,24(sp)
    80005efc:	e822                	sd	s0,16(sp)
    80005efe:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005f00:	fe040593          	addi	a1,s0,-32
    80005f04:	4505                	li	a0,1
    80005f06:	ffffd097          	auipc	ra,0xffffd
    80005f0a:	694080e7          	jalr	1684(ra) # 8000359a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005f0e:	fe840613          	addi	a2,s0,-24
    80005f12:	4581                	li	a1,0
    80005f14:	4501                	li	a0,0
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	c60080e7          	jalr	-928(ra) # 80005b76 <argfd>
    80005f1e:	87aa                	mv	a5,a0
    return -1;
    80005f20:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005f22:	0007ca63          	bltz	a5,80005f36 <sys_fstat+0x3e>
  return filestat(f, st);
    80005f26:	fe043583          	ld	a1,-32(s0)
    80005f2a:	fe843503          	ld	a0,-24(s0)
    80005f2e:	fffff097          	auipc	ra,0xfffff
    80005f32:	244080e7          	jalr	580(ra) # 80005172 <filestat>
}
    80005f36:	60e2                	ld	ra,24(sp)
    80005f38:	6442                	ld	s0,16(sp)
    80005f3a:	6105                	addi	sp,sp,32
    80005f3c:	8082                	ret

0000000080005f3e <sys_link>:
{
    80005f3e:	7169                	addi	sp,sp,-304
    80005f40:	f606                	sd	ra,296(sp)
    80005f42:	f222                	sd	s0,288(sp)
    80005f44:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005f46:	08000613          	li	a2,128
    80005f4a:	ed040593          	addi	a1,s0,-304
    80005f4e:	4501                	li	a0,0
    80005f50:	ffffd097          	auipc	ra,0xffffd
    80005f54:	66a080e7          	jalr	1642(ra) # 800035ba <argstr>
    return -1;
    80005f58:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005f5a:	12054663          	bltz	a0,80006086 <sys_link+0x148>
    80005f5e:	08000613          	li	a2,128
    80005f62:	f5040593          	addi	a1,s0,-176
    80005f66:	4505                	li	a0,1
    80005f68:	ffffd097          	auipc	ra,0xffffd
    80005f6c:	652080e7          	jalr	1618(ra) # 800035ba <argstr>
    return -1;
    80005f70:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005f72:	10054a63          	bltz	a0,80006086 <sys_link+0x148>
    80005f76:	ee26                	sd	s1,280(sp)
  begin_op();
    80005f78:	fffff097          	auipc	ra,0xfffff
    80005f7c:	c36080e7          	jalr	-970(ra) # 80004bae <begin_op>
  if((ip = namei(old)) == 0){
    80005f80:	ed040513          	addi	a0,s0,-304
    80005f84:	fffff097          	auipc	ra,0xfffff
    80005f88:	a24080e7          	jalr	-1500(ra) # 800049a8 <namei>
    80005f8c:	84aa                	mv	s1,a0
    80005f8e:	c949                	beqz	a0,80006020 <sys_link+0xe2>
  ilock(ip);
    80005f90:	ffffe097          	auipc	ra,0xffffe
    80005f94:	22e080e7          	jalr	558(ra) # 800041be <ilock>
  if(ip->type == T_DIR){
    80005f98:	04449703          	lh	a4,68(s1)
    80005f9c:	4785                	li	a5,1
    80005f9e:	08f70863          	beq	a4,a5,8000602e <sys_link+0xf0>
    80005fa2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005fa4:	04a4d783          	lhu	a5,74(s1)
    80005fa8:	2785                	addiw	a5,a5,1
    80005faa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005fae:	8526                	mv	a0,s1
    80005fb0:	ffffe097          	auipc	ra,0xffffe
    80005fb4:	142080e7          	jalr	322(ra) # 800040f2 <iupdate>
  iunlock(ip);
    80005fb8:	8526                	mv	a0,s1
    80005fba:	ffffe097          	auipc	ra,0xffffe
    80005fbe:	2ca080e7          	jalr	714(ra) # 80004284 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005fc2:	fd040593          	addi	a1,s0,-48
    80005fc6:	f5040513          	addi	a0,s0,-176
    80005fca:	fffff097          	auipc	ra,0xfffff
    80005fce:	9fc080e7          	jalr	-1540(ra) # 800049c6 <nameiparent>
    80005fd2:	892a                	mv	s2,a0
    80005fd4:	cd35                	beqz	a0,80006050 <sys_link+0x112>
  ilock(dp);
    80005fd6:	ffffe097          	auipc	ra,0xffffe
    80005fda:	1e8080e7          	jalr	488(ra) # 800041be <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005fde:	854a                	mv	a0,s2
    80005fe0:	00092703          	lw	a4,0(s2)
    80005fe4:	409c                	lw	a5,0(s1)
    80005fe6:	06f71063          	bne	a4,a5,80006046 <sys_link+0x108>
    80005fea:	40d0                	lw	a2,4(s1)
    80005fec:	fd040593          	addi	a1,s0,-48
    80005ff0:	fffff097          	auipc	ra,0xfffff
    80005ff4:	8f6080e7          	jalr	-1802(ra) # 800048e6 <dirlink>
    80005ff8:	04054763          	bltz	a0,80006046 <sys_link+0x108>
  iunlockput(dp);
    80005ffc:	854a                	mv	a0,s2
    80005ffe:	ffffe097          	auipc	ra,0xffffe
    80006002:	428080e7          	jalr	1064(ra) # 80004426 <iunlockput>
  iput(ip);
    80006006:	8526                	mv	a0,s1
    80006008:	ffffe097          	auipc	ra,0xffffe
    8000600c:	374080e7          	jalr	884(ra) # 8000437c <iput>
  end_op();
    80006010:	fffff097          	auipc	ra,0xfffff
    80006014:	c1e080e7          	jalr	-994(ra) # 80004c2e <end_op>
  return 0;
    80006018:	4781                	li	a5,0
    8000601a:	64f2                	ld	s1,280(sp)
    8000601c:	6952                	ld	s2,272(sp)
    8000601e:	a0a5                	j	80006086 <sys_link+0x148>
    end_op();
    80006020:	fffff097          	auipc	ra,0xfffff
    80006024:	c0e080e7          	jalr	-1010(ra) # 80004c2e <end_op>
    return -1;
    80006028:	57fd                	li	a5,-1
    8000602a:	64f2                	ld	s1,280(sp)
    8000602c:	a8a9                	j	80006086 <sys_link+0x148>
    iunlockput(ip);
    8000602e:	8526                	mv	a0,s1
    80006030:	ffffe097          	auipc	ra,0xffffe
    80006034:	3f6080e7          	jalr	1014(ra) # 80004426 <iunlockput>
    end_op();
    80006038:	fffff097          	auipc	ra,0xfffff
    8000603c:	bf6080e7          	jalr	-1034(ra) # 80004c2e <end_op>
    return -1;
    80006040:	57fd                	li	a5,-1
    80006042:	64f2                	ld	s1,280(sp)
    80006044:	a089                	j	80006086 <sys_link+0x148>
    iunlockput(dp);
    80006046:	854a                	mv	a0,s2
    80006048:	ffffe097          	auipc	ra,0xffffe
    8000604c:	3de080e7          	jalr	990(ra) # 80004426 <iunlockput>
  ilock(ip);
    80006050:	8526                	mv	a0,s1
    80006052:	ffffe097          	auipc	ra,0xffffe
    80006056:	16c080e7          	jalr	364(ra) # 800041be <ilock>
  ip->nlink--;
    8000605a:	04a4d783          	lhu	a5,74(s1)
    8000605e:	37fd                	addiw	a5,a5,-1
    80006060:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006064:	8526                	mv	a0,s1
    80006066:	ffffe097          	auipc	ra,0xffffe
    8000606a:	08c080e7          	jalr	140(ra) # 800040f2 <iupdate>
  iunlockput(ip);
    8000606e:	8526                	mv	a0,s1
    80006070:	ffffe097          	auipc	ra,0xffffe
    80006074:	3b6080e7          	jalr	950(ra) # 80004426 <iunlockput>
  end_op();
    80006078:	fffff097          	auipc	ra,0xfffff
    8000607c:	bb6080e7          	jalr	-1098(ra) # 80004c2e <end_op>
  return -1;
    80006080:	57fd                	li	a5,-1
    80006082:	64f2                	ld	s1,280(sp)
    80006084:	6952                	ld	s2,272(sp)
}
    80006086:	853e                	mv	a0,a5
    80006088:	70b2                	ld	ra,296(sp)
    8000608a:	7412                	ld	s0,288(sp)
    8000608c:	6155                	addi	sp,sp,304
    8000608e:	8082                	ret

0000000080006090 <sys_unlink>:
{
    80006090:	7151                	addi	sp,sp,-240
    80006092:	f586                	sd	ra,232(sp)
    80006094:	f1a2                	sd	s0,224(sp)
    80006096:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80006098:	08000613          	li	a2,128
    8000609c:	f3040593          	addi	a1,s0,-208
    800060a0:	4501                	li	a0,0
    800060a2:	ffffd097          	auipc	ra,0xffffd
    800060a6:	518080e7          	jalr	1304(ra) # 800035ba <argstr>
    800060aa:	1a054763          	bltz	a0,80006258 <sys_unlink+0x1c8>
    800060ae:	eda6                	sd	s1,216(sp)
  begin_op();
    800060b0:	fffff097          	auipc	ra,0xfffff
    800060b4:	afe080e7          	jalr	-1282(ra) # 80004bae <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800060b8:	fb040593          	addi	a1,s0,-80
    800060bc:	f3040513          	addi	a0,s0,-208
    800060c0:	fffff097          	auipc	ra,0xfffff
    800060c4:	906080e7          	jalr	-1786(ra) # 800049c6 <nameiparent>
    800060c8:	84aa                	mv	s1,a0
    800060ca:	c165                	beqz	a0,800061aa <sys_unlink+0x11a>
  ilock(dp);
    800060cc:	ffffe097          	auipc	ra,0xffffe
    800060d0:	0f2080e7          	jalr	242(ra) # 800041be <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800060d4:	00003597          	auipc	a1,0x3
    800060d8:	5f458593          	addi	a1,a1,1524 # 800096c8 <etext+0x6c8>
    800060dc:	fb040513          	addi	a0,s0,-80
    800060e0:	ffffe097          	auipc	ra,0xffffe
    800060e4:	5be080e7          	jalr	1470(ra) # 8000469e <namecmp>
    800060e8:	14050963          	beqz	a0,8000623a <sys_unlink+0x1aa>
    800060ec:	00003597          	auipc	a1,0x3
    800060f0:	5e458593          	addi	a1,a1,1508 # 800096d0 <etext+0x6d0>
    800060f4:	fb040513          	addi	a0,s0,-80
    800060f8:	ffffe097          	auipc	ra,0xffffe
    800060fc:	5a6080e7          	jalr	1446(ra) # 8000469e <namecmp>
    80006100:	12050d63          	beqz	a0,8000623a <sys_unlink+0x1aa>
    80006104:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80006106:	f2c40613          	addi	a2,s0,-212
    8000610a:	fb040593          	addi	a1,s0,-80
    8000610e:	8526                	mv	a0,s1
    80006110:	ffffe097          	auipc	ra,0xffffe
    80006114:	5a8080e7          	jalr	1448(ra) # 800046b8 <dirlookup>
    80006118:	892a                	mv	s2,a0
    8000611a:	10050f63          	beqz	a0,80006238 <sys_unlink+0x1a8>
    8000611e:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80006120:	ffffe097          	auipc	ra,0xffffe
    80006124:	09e080e7          	jalr	158(ra) # 800041be <ilock>
  if(ip->nlink < 1)
    80006128:	04a91783          	lh	a5,74(s2)
    8000612c:	08f05663          	blez	a5,800061b8 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80006130:	04491703          	lh	a4,68(s2)
    80006134:	4785                	li	a5,1
    80006136:	08f70963          	beq	a4,a5,800061c8 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
    8000613a:	fc040993          	addi	s3,s0,-64
    8000613e:	4641                	li	a2,16
    80006140:	4581                	li	a1,0
    80006142:	854e                	mv	a0,s3
    80006144:	ffffb097          	auipc	ra,0xffffb
    80006148:	ce8080e7          	jalr	-792(ra) # 80000e2c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000614c:	4741                	li	a4,16
    8000614e:	f2c42683          	lw	a3,-212(s0)
    80006152:	864e                	mv	a2,s3
    80006154:	4581                	li	a1,0
    80006156:	8526                	mv	a0,s1
    80006158:	ffffe097          	auipc	ra,0xffffe
    8000615c:	42a080e7          	jalr	1066(ra) # 80004582 <writei>
    80006160:	47c1                	li	a5,16
    80006162:	0af51863          	bne	a0,a5,80006212 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    80006166:	04491703          	lh	a4,68(s2)
    8000616a:	4785                	li	a5,1
    8000616c:	0af70b63          	beq	a4,a5,80006222 <sys_unlink+0x192>
  iunlockput(dp);
    80006170:	8526                	mv	a0,s1
    80006172:	ffffe097          	auipc	ra,0xffffe
    80006176:	2b4080e7          	jalr	692(ra) # 80004426 <iunlockput>
  ip->nlink--;
    8000617a:	04a95783          	lhu	a5,74(s2)
    8000617e:	37fd                	addiw	a5,a5,-1
    80006180:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80006184:	854a                	mv	a0,s2
    80006186:	ffffe097          	auipc	ra,0xffffe
    8000618a:	f6c080e7          	jalr	-148(ra) # 800040f2 <iupdate>
  iunlockput(ip);
    8000618e:	854a                	mv	a0,s2
    80006190:	ffffe097          	auipc	ra,0xffffe
    80006194:	296080e7          	jalr	662(ra) # 80004426 <iunlockput>
  end_op();
    80006198:	fffff097          	auipc	ra,0xfffff
    8000619c:	a96080e7          	jalr	-1386(ra) # 80004c2e <end_op>
  return 0;
    800061a0:	4501                	li	a0,0
    800061a2:	64ee                	ld	s1,216(sp)
    800061a4:	694e                	ld	s2,208(sp)
    800061a6:	69ae                	ld	s3,200(sp)
    800061a8:	a065                	j	80006250 <sys_unlink+0x1c0>
    end_op();
    800061aa:	fffff097          	auipc	ra,0xfffff
    800061ae:	a84080e7          	jalr	-1404(ra) # 80004c2e <end_op>
    return -1;
    800061b2:	557d                	li	a0,-1
    800061b4:	64ee                	ld	s1,216(sp)
    800061b6:	a869                	j	80006250 <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    800061b8:	00003517          	auipc	a0,0x3
    800061bc:	52050513          	addi	a0,a0,1312 # 800096d8 <etext+0x6d8>
    800061c0:	ffffa097          	auipc	ra,0xffffa
    800061c4:	39e080e7          	jalr	926(ra) # 8000055e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800061c8:	04c92703          	lw	a4,76(s2)
    800061cc:	02000793          	li	a5,32
    800061d0:	f6e7f5e3          	bgeu	a5,a4,8000613a <sys_unlink+0xaa>
    800061d4:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800061d6:	4741                	li	a4,16
    800061d8:	86ce                	mv	a3,s3
    800061da:	f1840613          	addi	a2,s0,-232
    800061de:	4581                	li	a1,0
    800061e0:	854a                	mv	a0,s2
    800061e2:	ffffe097          	auipc	ra,0xffffe
    800061e6:	29a080e7          	jalr	666(ra) # 8000447c <readi>
    800061ea:	47c1                	li	a5,16
    800061ec:	00f51b63          	bne	a0,a5,80006202 <sys_unlink+0x172>
    if(de.inum != 0)
    800061f0:	f1845783          	lhu	a5,-232(s0)
    800061f4:	e7a5                	bnez	a5,8000625c <sys_unlink+0x1cc>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800061f6:	29c1                	addiw	s3,s3,16
    800061f8:	04c92783          	lw	a5,76(s2)
    800061fc:	fcf9ede3          	bltu	s3,a5,800061d6 <sys_unlink+0x146>
    80006200:	bf2d                	j	8000613a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80006202:	00003517          	auipc	a0,0x3
    80006206:	4ee50513          	addi	a0,a0,1262 # 800096f0 <etext+0x6f0>
    8000620a:	ffffa097          	auipc	ra,0xffffa
    8000620e:	354080e7          	jalr	852(ra) # 8000055e <panic>
    panic("unlink: writei");
    80006212:	00003517          	auipc	a0,0x3
    80006216:	4f650513          	addi	a0,a0,1270 # 80009708 <etext+0x708>
    8000621a:	ffffa097          	auipc	ra,0xffffa
    8000621e:	344080e7          	jalr	836(ra) # 8000055e <panic>
    dp->nlink--;
    80006222:	04a4d783          	lhu	a5,74(s1)
    80006226:	37fd                	addiw	a5,a5,-1
    80006228:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000622c:	8526                	mv	a0,s1
    8000622e:	ffffe097          	auipc	ra,0xffffe
    80006232:	ec4080e7          	jalr	-316(ra) # 800040f2 <iupdate>
    80006236:	bf2d                	j	80006170 <sys_unlink+0xe0>
    80006238:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000623a:	8526                	mv	a0,s1
    8000623c:	ffffe097          	auipc	ra,0xffffe
    80006240:	1ea080e7          	jalr	490(ra) # 80004426 <iunlockput>
  end_op();
    80006244:	fffff097          	auipc	ra,0xfffff
    80006248:	9ea080e7          	jalr	-1558(ra) # 80004c2e <end_op>
  return -1;
    8000624c:	557d                	li	a0,-1
    8000624e:	64ee                	ld	s1,216(sp)
}
    80006250:	70ae                	ld	ra,232(sp)
    80006252:	740e                	ld	s0,224(sp)
    80006254:	616d                	addi	sp,sp,240
    80006256:	8082                	ret
    return -1;
    80006258:	557d                	li	a0,-1
    8000625a:	bfdd                	j	80006250 <sys_unlink+0x1c0>
    iunlockput(ip);
    8000625c:	854a                	mv	a0,s2
    8000625e:	ffffe097          	auipc	ra,0xffffe
    80006262:	1c8080e7          	jalr	456(ra) # 80004426 <iunlockput>
    goto bad;
    80006266:	694e                	ld	s2,208(sp)
    80006268:	69ae                	ld	s3,200(sp)
    8000626a:	bfc1                	j	8000623a <sys_unlink+0x1aa>

000000008000626c <sys_open>:

uint64
sys_open(void)
{
    8000626c:	7131                	addi	sp,sp,-192
    8000626e:	fd06                	sd	ra,184(sp)
    80006270:	f922                	sd	s0,176(sp)
    80006272:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80006274:	f4c40593          	addi	a1,s0,-180
    80006278:	4505                	li	a0,1
    8000627a:	ffffd097          	auipc	ra,0xffffd
    8000627e:	300080e7          	jalr	768(ra) # 8000357a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006282:	08000613          	li	a2,128
    80006286:	f5040593          	addi	a1,s0,-176
    8000628a:	4501                	li	a0,0
    8000628c:	ffffd097          	auipc	ra,0xffffd
    80006290:	32e080e7          	jalr	814(ra) # 800035ba <argstr>
    80006294:	87aa                	mv	a5,a0
    return -1;
    80006296:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006298:	0a07cf63          	bltz	a5,80006356 <sys_open+0xea>
    8000629c:	f526                	sd	s1,168(sp)

  begin_op();
    8000629e:	fffff097          	auipc	ra,0xfffff
    800062a2:	910080e7          	jalr	-1776(ra) # 80004bae <begin_op>

  if(omode & O_CREATE){
    800062a6:	f4c42783          	lw	a5,-180(s0)
    800062aa:	2007f793          	andi	a5,a5,512
    800062ae:	cfdd                	beqz	a5,8000636c <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    800062b0:	4681                	li	a3,0
    800062b2:	4601                	li	a2,0
    800062b4:	4589                	li	a1,2
    800062b6:	f5040513          	addi	a0,s0,-176
    800062ba:	00000097          	auipc	ra,0x0
    800062be:	962080e7          	jalr	-1694(ra) # 80005c1c <create>
    800062c2:	84aa                	mv	s1,a0
    if(ip == 0){
    800062c4:	cd49                	beqz	a0,8000635e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800062c6:	04449703          	lh	a4,68(s1)
    800062ca:	478d                	li	a5,3
    800062cc:	00f71763          	bne	a4,a5,800062da <sys_open+0x6e>
    800062d0:	0464d703          	lhu	a4,70(s1)
    800062d4:	47a5                	li	a5,9
    800062d6:	0ee7e263          	bltu	a5,a4,800063ba <sys_open+0x14e>
    800062da:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800062dc:	fffff097          	auipc	ra,0xfffff
    800062e0:	cf8080e7          	jalr	-776(ra) # 80004fd4 <filealloc>
    800062e4:	892a                	mv	s2,a0
    800062e6:	cd65                	beqz	a0,800063de <sys_open+0x172>
    800062e8:	ed4e                	sd	s3,152(sp)
    800062ea:	00000097          	auipc	ra,0x0
    800062ee:	8ee080e7          	jalr	-1810(ra) # 80005bd8 <fdalloc>
    800062f2:	89aa                	mv	s3,a0
    800062f4:	0c054f63          	bltz	a0,800063d2 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800062f8:	04449703          	lh	a4,68(s1)
    800062fc:	478d                	li	a5,3
    800062fe:	0ef70d63          	beq	a4,a5,800063f8 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006302:	4789                	li	a5,2
    80006304:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80006308:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000630c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006310:	f4c42783          	lw	a5,-180(s0)
    80006314:	0017f713          	andi	a4,a5,1
    80006318:	00174713          	xori	a4,a4,1
    8000631c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006320:	0037f713          	andi	a4,a5,3
    80006324:	00e03733          	snez	a4,a4
    80006328:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000632c:	4007f793          	andi	a5,a5,1024
    80006330:	c791                	beqz	a5,8000633c <sys_open+0xd0>
    80006332:	04449703          	lh	a4,68(s1)
    80006336:	4789                	li	a5,2
    80006338:	0cf70763          	beq	a4,a5,80006406 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    8000633c:	8526                	mv	a0,s1
    8000633e:	ffffe097          	auipc	ra,0xffffe
    80006342:	f46080e7          	jalr	-186(ra) # 80004284 <iunlock>
  end_op();
    80006346:	fffff097          	auipc	ra,0xfffff
    8000634a:	8e8080e7          	jalr	-1816(ra) # 80004c2e <end_op>

  return fd;
    8000634e:	854e                	mv	a0,s3
    80006350:	74aa                	ld	s1,168(sp)
    80006352:	790a                	ld	s2,160(sp)
    80006354:	69ea                	ld	s3,152(sp)
}
    80006356:	70ea                	ld	ra,184(sp)
    80006358:	744a                	ld	s0,176(sp)
    8000635a:	6129                	addi	sp,sp,192
    8000635c:	8082                	ret
      end_op();
    8000635e:	fffff097          	auipc	ra,0xfffff
    80006362:	8d0080e7          	jalr	-1840(ra) # 80004c2e <end_op>
      return -1;
    80006366:	557d                	li	a0,-1
    80006368:	74aa                	ld	s1,168(sp)
    8000636a:	b7f5                	j	80006356 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    8000636c:	f5040513          	addi	a0,s0,-176
    80006370:	ffffe097          	auipc	ra,0xffffe
    80006374:	638080e7          	jalr	1592(ra) # 800049a8 <namei>
    80006378:	84aa                	mv	s1,a0
    8000637a:	c90d                	beqz	a0,800063ac <sys_open+0x140>
    ilock(ip);
    8000637c:	ffffe097          	auipc	ra,0xffffe
    80006380:	e42080e7          	jalr	-446(ra) # 800041be <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006384:	04449703          	lh	a4,68(s1)
    80006388:	4785                	li	a5,1
    8000638a:	f2f71ee3          	bne	a4,a5,800062c6 <sys_open+0x5a>
    8000638e:	f4c42783          	lw	a5,-180(s0)
    80006392:	d7a1                	beqz	a5,800062da <sys_open+0x6e>
      iunlockput(ip);
    80006394:	8526                	mv	a0,s1
    80006396:	ffffe097          	auipc	ra,0xffffe
    8000639a:	090080e7          	jalr	144(ra) # 80004426 <iunlockput>
      end_op();
    8000639e:	fffff097          	auipc	ra,0xfffff
    800063a2:	890080e7          	jalr	-1904(ra) # 80004c2e <end_op>
      return -1;
    800063a6:	557d                	li	a0,-1
    800063a8:	74aa                	ld	s1,168(sp)
    800063aa:	b775                	j	80006356 <sys_open+0xea>
      end_op();
    800063ac:	fffff097          	auipc	ra,0xfffff
    800063b0:	882080e7          	jalr	-1918(ra) # 80004c2e <end_op>
      return -1;
    800063b4:	557d                	li	a0,-1
    800063b6:	74aa                	ld	s1,168(sp)
    800063b8:	bf79                	j	80006356 <sys_open+0xea>
    iunlockput(ip);
    800063ba:	8526                	mv	a0,s1
    800063bc:	ffffe097          	auipc	ra,0xffffe
    800063c0:	06a080e7          	jalr	106(ra) # 80004426 <iunlockput>
    end_op();
    800063c4:	fffff097          	auipc	ra,0xfffff
    800063c8:	86a080e7          	jalr	-1942(ra) # 80004c2e <end_op>
    return -1;
    800063cc:	557d                	li	a0,-1
    800063ce:	74aa                	ld	s1,168(sp)
    800063d0:	b759                	j	80006356 <sys_open+0xea>
      fileclose(f);
    800063d2:	854a                	mv	a0,s2
    800063d4:	fffff097          	auipc	ra,0xfffff
    800063d8:	cbc080e7          	jalr	-836(ra) # 80005090 <fileclose>
    800063dc:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800063de:	8526                	mv	a0,s1
    800063e0:	ffffe097          	auipc	ra,0xffffe
    800063e4:	046080e7          	jalr	70(ra) # 80004426 <iunlockput>
    end_op();
    800063e8:	fffff097          	auipc	ra,0xfffff
    800063ec:	846080e7          	jalr	-1978(ra) # 80004c2e <end_op>
    return -1;
    800063f0:	557d                	li	a0,-1
    800063f2:	74aa                	ld	s1,168(sp)
    800063f4:	790a                	ld	s2,160(sp)
    800063f6:	b785                	j	80006356 <sys_open+0xea>
    f->type = FD_DEVICE;
    800063f8:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800063fc:	04649783          	lh	a5,70(s1)
    80006400:	02f91223          	sh	a5,36(s2)
    80006404:	b721                	j	8000630c <sys_open+0xa0>
    itrunc(ip);
    80006406:	8526                	mv	a0,s1
    80006408:	ffffe097          	auipc	ra,0xffffe
    8000640c:	ec8080e7          	jalr	-312(ra) # 800042d0 <itrunc>
    80006410:	b735                	j	8000633c <sys_open+0xd0>

0000000080006412 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006412:	7175                	addi	sp,sp,-144
    80006414:	e506                	sd	ra,136(sp)
    80006416:	e122                	sd	s0,128(sp)
    80006418:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000641a:	ffffe097          	auipc	ra,0xffffe
    8000641e:	794080e7          	jalr	1940(ra) # 80004bae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006422:	08000613          	li	a2,128
    80006426:	f7040593          	addi	a1,s0,-144
    8000642a:	4501                	li	a0,0
    8000642c:	ffffd097          	auipc	ra,0xffffd
    80006430:	18e080e7          	jalr	398(ra) # 800035ba <argstr>
    80006434:	02054963          	bltz	a0,80006466 <sys_mkdir+0x54>
    80006438:	4681                	li	a3,0
    8000643a:	4601                	li	a2,0
    8000643c:	4585                	li	a1,1
    8000643e:	f7040513          	addi	a0,s0,-144
    80006442:	fffff097          	auipc	ra,0xfffff
    80006446:	7da080e7          	jalr	2010(ra) # 80005c1c <create>
    8000644a:	cd11                	beqz	a0,80006466 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000644c:	ffffe097          	auipc	ra,0xffffe
    80006450:	fda080e7          	jalr	-38(ra) # 80004426 <iunlockput>
  end_op();
    80006454:	ffffe097          	auipc	ra,0xffffe
    80006458:	7da080e7          	jalr	2010(ra) # 80004c2e <end_op>
  return 0;
    8000645c:	4501                	li	a0,0
}
    8000645e:	60aa                	ld	ra,136(sp)
    80006460:	640a                	ld	s0,128(sp)
    80006462:	6149                	addi	sp,sp,144
    80006464:	8082                	ret
    end_op();
    80006466:	ffffe097          	auipc	ra,0xffffe
    8000646a:	7c8080e7          	jalr	1992(ra) # 80004c2e <end_op>
    return -1;
    8000646e:	557d                	li	a0,-1
    80006470:	b7fd                	j	8000645e <sys_mkdir+0x4c>

0000000080006472 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006472:	7135                	addi	sp,sp,-160
    80006474:	ed06                	sd	ra,152(sp)
    80006476:	e922                	sd	s0,144(sp)
    80006478:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000647a:	ffffe097          	auipc	ra,0xffffe
    8000647e:	734080e7          	jalr	1844(ra) # 80004bae <begin_op>
  argint(1, &major);
    80006482:	f6c40593          	addi	a1,s0,-148
    80006486:	4505                	li	a0,1
    80006488:	ffffd097          	auipc	ra,0xffffd
    8000648c:	0f2080e7          	jalr	242(ra) # 8000357a <argint>
  argint(2, &minor);
    80006490:	f6840593          	addi	a1,s0,-152
    80006494:	4509                	li	a0,2
    80006496:	ffffd097          	auipc	ra,0xffffd
    8000649a:	0e4080e7          	jalr	228(ra) # 8000357a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000649e:	08000613          	li	a2,128
    800064a2:	f7040593          	addi	a1,s0,-144
    800064a6:	4501                	li	a0,0
    800064a8:	ffffd097          	auipc	ra,0xffffd
    800064ac:	112080e7          	jalr	274(ra) # 800035ba <argstr>
    800064b0:	02054b63          	bltz	a0,800064e6 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800064b4:	f6841683          	lh	a3,-152(s0)
    800064b8:	f6c41603          	lh	a2,-148(s0)
    800064bc:	458d                	li	a1,3
    800064be:	f7040513          	addi	a0,s0,-144
    800064c2:	fffff097          	auipc	ra,0xfffff
    800064c6:	75a080e7          	jalr	1882(ra) # 80005c1c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800064ca:	cd11                	beqz	a0,800064e6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800064cc:	ffffe097          	auipc	ra,0xffffe
    800064d0:	f5a080e7          	jalr	-166(ra) # 80004426 <iunlockput>
  end_op();
    800064d4:	ffffe097          	auipc	ra,0xffffe
    800064d8:	75a080e7          	jalr	1882(ra) # 80004c2e <end_op>
  return 0;
    800064dc:	4501                	li	a0,0
}
    800064de:	60ea                	ld	ra,152(sp)
    800064e0:	644a                	ld	s0,144(sp)
    800064e2:	610d                	addi	sp,sp,160
    800064e4:	8082                	ret
    end_op();
    800064e6:	ffffe097          	auipc	ra,0xffffe
    800064ea:	748080e7          	jalr	1864(ra) # 80004c2e <end_op>
    return -1;
    800064ee:	557d                	li	a0,-1
    800064f0:	b7fd                	j	800064de <sys_mknod+0x6c>

00000000800064f2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800064f2:	7135                	addi	sp,sp,-160
    800064f4:	ed06                	sd	ra,152(sp)
    800064f6:	e922                	sd	s0,144(sp)
    800064f8:	e14a                	sd	s2,128(sp)
    800064fa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800064fc:	ffffc097          	auipc	ra,0xffffc
    80006500:	a38080e7          	jalr	-1480(ra) # 80001f34 <myproc>
    80006504:	892a                	mv	s2,a0
  
  begin_op();
    80006506:	ffffe097          	auipc	ra,0xffffe
    8000650a:	6a8080e7          	jalr	1704(ra) # 80004bae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000650e:	08000613          	li	a2,128
    80006512:	f6040593          	addi	a1,s0,-160
    80006516:	4501                	li	a0,0
    80006518:	ffffd097          	auipc	ra,0xffffd
    8000651c:	0a2080e7          	jalr	162(ra) # 800035ba <argstr>
    80006520:	04054d63          	bltz	a0,8000657a <sys_chdir+0x88>
    80006524:	e526                	sd	s1,136(sp)
    80006526:	f6040513          	addi	a0,s0,-160
    8000652a:	ffffe097          	auipc	ra,0xffffe
    8000652e:	47e080e7          	jalr	1150(ra) # 800049a8 <namei>
    80006532:	84aa                	mv	s1,a0
    80006534:	c131                	beqz	a0,80006578 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006536:	ffffe097          	auipc	ra,0xffffe
    8000653a:	c88080e7          	jalr	-888(ra) # 800041be <ilock>
  if(ip->type != T_DIR){
    8000653e:	04449703          	lh	a4,68(s1)
    80006542:	4785                	li	a5,1
    80006544:	04f71163          	bne	a4,a5,80006586 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006548:	8526                	mv	a0,s1
    8000654a:	ffffe097          	auipc	ra,0xffffe
    8000654e:	d3a080e7          	jalr	-710(ra) # 80004284 <iunlock>
  iput(p->cwd);
    80006552:	15093503          	ld	a0,336(s2)
    80006556:	ffffe097          	auipc	ra,0xffffe
    8000655a:	e26080e7          	jalr	-474(ra) # 8000437c <iput>
  end_op();
    8000655e:	ffffe097          	auipc	ra,0xffffe
    80006562:	6d0080e7          	jalr	1744(ra) # 80004c2e <end_op>
  p->cwd = ip;
    80006566:	14993823          	sd	s1,336(s2)
  return 0;
    8000656a:	4501                	li	a0,0
    8000656c:	64aa                	ld	s1,136(sp)
}
    8000656e:	60ea                	ld	ra,152(sp)
    80006570:	644a                	ld	s0,144(sp)
    80006572:	690a                	ld	s2,128(sp)
    80006574:	610d                	addi	sp,sp,160
    80006576:	8082                	ret
    80006578:	64aa                	ld	s1,136(sp)
    end_op();
    8000657a:	ffffe097          	auipc	ra,0xffffe
    8000657e:	6b4080e7          	jalr	1716(ra) # 80004c2e <end_op>
    return -1;
    80006582:	557d                	li	a0,-1
    80006584:	b7ed                	j	8000656e <sys_chdir+0x7c>
    iunlockput(ip);
    80006586:	8526                	mv	a0,s1
    80006588:	ffffe097          	auipc	ra,0xffffe
    8000658c:	e9e080e7          	jalr	-354(ra) # 80004426 <iunlockput>
    end_op();
    80006590:	ffffe097          	auipc	ra,0xffffe
    80006594:	69e080e7          	jalr	1694(ra) # 80004c2e <end_op>
    return -1;
    80006598:	557d                	li	a0,-1
    8000659a:	64aa                	ld	s1,136(sp)
    8000659c:	bfc9                	j	8000656e <sys_chdir+0x7c>

000000008000659e <sys_exec>:

uint64
sys_exec(void)
{
    8000659e:	7105                	addi	sp,sp,-480
    800065a0:	ef86                	sd	ra,472(sp)
    800065a2:	eba2                	sd	s0,464(sp)
    800065a4:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800065a6:	e2840593          	addi	a1,s0,-472
    800065aa:	4505                	li	a0,1
    800065ac:	ffffd097          	auipc	ra,0xffffd
    800065b0:	fee080e7          	jalr	-18(ra) # 8000359a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800065b4:	08000613          	li	a2,128
    800065b8:	f3040593          	addi	a1,s0,-208
    800065bc:	4501                	li	a0,0
    800065be:	ffffd097          	auipc	ra,0xffffd
    800065c2:	ffc080e7          	jalr	-4(ra) # 800035ba <argstr>
    800065c6:	87aa                	mv	a5,a0
    return -1;
    800065c8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800065ca:	0e07ce63          	bltz	a5,800066c6 <sys_exec+0x128>
    800065ce:	e7a6                	sd	s1,456(sp)
    800065d0:	e3ca                	sd	s2,448(sp)
    800065d2:	ff4e                	sd	s3,440(sp)
    800065d4:	fb52                	sd	s4,432(sp)
    800065d6:	f756                	sd	s5,424(sp)
    800065d8:	f35a                	sd	s6,416(sp)
    800065da:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800065dc:	e3040a13          	addi	s4,s0,-464
    800065e0:	10000613          	li	a2,256
    800065e4:	4581                	li	a1,0
    800065e6:	8552                	mv	a0,s4
    800065e8:	ffffb097          	auipc	ra,0xffffb
    800065ec:	844080e7          	jalr	-1980(ra) # 80000e2c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800065f0:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800065f2:	89d2                	mv	s3,s4
    800065f4:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800065f6:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800065fa:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800065fc:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006600:	00391513          	slli	a0,s2,0x3
    80006604:	85d6                	mv	a1,s5
    80006606:	e2843783          	ld	a5,-472(s0)
    8000660a:	953e                	add	a0,a0,a5
    8000660c:	ffffd097          	auipc	ra,0xffffd
    80006610:	ed0080e7          	jalr	-304(ra) # 800034dc <fetchaddr>
    80006614:	02054a63          	bltz	a0,80006648 <sys_exec+0xaa>
    if(uarg == 0){
    80006618:	e2043783          	ld	a5,-480(s0)
    8000661c:	cbb1                	beqz	a5,80006670 <sys_exec+0xd2>
    argv[i] = kalloc();
    8000661e:	ffffa097          	auipc	ra,0xffffa
    80006622:	5f4080e7          	jalr	1524(ra) # 80000c12 <kalloc>
    80006626:	85aa                	mv	a1,a0
    80006628:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000662c:	cd11                	beqz	a0,80006648 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000662e:	865a                	mv	a2,s6
    80006630:	e2043503          	ld	a0,-480(s0)
    80006634:	ffffd097          	auipc	ra,0xffffd
    80006638:	efa080e7          	jalr	-262(ra) # 8000352e <fetchstr>
    8000663c:	00054663          	bltz	a0,80006648 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80006640:	0905                	addi	s2,s2,1
    80006642:	09a1                	addi	s3,s3,8
    80006644:	fb791ee3          	bne	s2,s7,80006600 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006648:	100a0a13          	addi	s4,s4,256
    8000664c:	6088                	ld	a0,0(s1)
    8000664e:	c525                	beqz	a0,800066b6 <sys_exec+0x118>
    kfree(argv[i]);
    80006650:	ffffa097          	auipc	ra,0xffffa
    80006654:	454080e7          	jalr	1108(ra) # 80000aa4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006658:	04a1                	addi	s1,s1,8
    8000665a:	ff4499e3          	bne	s1,s4,8000664c <sys_exec+0xae>
  return -1;
    8000665e:	557d                	li	a0,-1
    80006660:	64be                	ld	s1,456(sp)
    80006662:	691e                	ld	s2,448(sp)
    80006664:	79fa                	ld	s3,440(sp)
    80006666:	7a5a                	ld	s4,432(sp)
    80006668:	7aba                	ld	s5,424(sp)
    8000666a:	7b1a                	ld	s6,416(sp)
    8000666c:	6bfa                	ld	s7,408(sp)
    8000666e:	a8a1                	j	800066c6 <sys_exec+0x128>
      argv[i] = 0;
    80006670:	0009079b          	sext.w	a5,s2
    80006674:	e3040593          	addi	a1,s0,-464
    80006678:	078e                	slli	a5,a5,0x3
    8000667a:	97ae                	add	a5,a5,a1
    8000667c:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80006680:	f3040513          	addi	a0,s0,-208
    80006684:	fffff097          	auipc	ra,0xfffff
    80006688:	126080e7          	jalr	294(ra) # 800057aa <exec>
    8000668c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000668e:	100a0a13          	addi	s4,s4,256
    80006692:	6088                	ld	a0,0(s1)
    80006694:	c901                	beqz	a0,800066a4 <sys_exec+0x106>
    kfree(argv[i]);
    80006696:	ffffa097          	auipc	ra,0xffffa
    8000669a:	40e080e7          	jalr	1038(ra) # 80000aa4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000669e:	04a1                	addi	s1,s1,8
    800066a0:	ff4499e3          	bne	s1,s4,80006692 <sys_exec+0xf4>
  return ret;
    800066a4:	854a                	mv	a0,s2
    800066a6:	64be                	ld	s1,456(sp)
    800066a8:	691e                	ld	s2,448(sp)
    800066aa:	79fa                	ld	s3,440(sp)
    800066ac:	7a5a                	ld	s4,432(sp)
    800066ae:	7aba                	ld	s5,424(sp)
    800066b0:	7b1a                	ld	s6,416(sp)
    800066b2:	6bfa                	ld	s7,408(sp)
    800066b4:	a809                	j	800066c6 <sys_exec+0x128>
  return -1;
    800066b6:	557d                	li	a0,-1
    800066b8:	64be                	ld	s1,456(sp)
    800066ba:	691e                	ld	s2,448(sp)
    800066bc:	79fa                	ld	s3,440(sp)
    800066be:	7a5a                	ld	s4,432(sp)
    800066c0:	7aba                	ld	s5,424(sp)
    800066c2:	7b1a                	ld	s6,416(sp)
    800066c4:	6bfa                	ld	s7,408(sp)
}
    800066c6:	60fe                	ld	ra,472(sp)
    800066c8:	645e                	ld	s0,464(sp)
    800066ca:	613d                	addi	sp,sp,480
    800066cc:	8082                	ret

00000000800066ce <sys_pipe>:

uint64
sys_pipe(void)
{
    800066ce:	7139                	addi	sp,sp,-64
    800066d0:	fc06                	sd	ra,56(sp)
    800066d2:	f822                	sd	s0,48(sp)
    800066d4:	f426                	sd	s1,40(sp)
    800066d6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800066d8:	ffffc097          	auipc	ra,0xffffc
    800066dc:	85c080e7          	jalr	-1956(ra) # 80001f34 <myproc>
    800066e0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800066e2:	fd840593          	addi	a1,s0,-40
    800066e6:	4501                	li	a0,0
    800066e8:	ffffd097          	auipc	ra,0xffffd
    800066ec:	eb2080e7          	jalr	-334(ra) # 8000359a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800066f0:	fc840593          	addi	a1,s0,-56
    800066f4:	fd040513          	addi	a0,s0,-48
    800066f8:	fffff097          	auipc	ra,0xfffff
    800066fc:	d18080e7          	jalr	-744(ra) # 80005410 <pipealloc>
    return -1;
    80006700:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006702:	0c054763          	bltz	a0,800067d0 <sys_pipe+0x102>
  fd0 = -1;
    80006706:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000670a:	fd043503          	ld	a0,-48(s0)
    8000670e:	fffff097          	auipc	ra,0xfffff
    80006712:	4ca080e7          	jalr	1226(ra) # 80005bd8 <fdalloc>
    80006716:	fca42223          	sw	a0,-60(s0)
    8000671a:	08054e63          	bltz	a0,800067b6 <sys_pipe+0xe8>
    8000671e:	fc843503          	ld	a0,-56(s0)
    80006722:	fffff097          	auipc	ra,0xfffff
    80006726:	4b6080e7          	jalr	1206(ra) # 80005bd8 <fdalloc>
    8000672a:	fca42023          	sw	a0,-64(s0)
    8000672e:	06054a63          	bltz	a0,800067a2 <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006732:	4691                	li	a3,4
    80006734:	fc440613          	addi	a2,s0,-60
    80006738:	fd843583          	ld	a1,-40(s0)
    8000673c:	68a8                	ld	a0,80(s1)
    8000673e:	ffffb097          	auipc	ra,0xffffb
    80006742:	482080e7          	jalr	1154(ra) # 80001bc0 <copyout>
    80006746:	02054063          	bltz	a0,80006766 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000674a:	4691                	li	a3,4
    8000674c:	fc040613          	addi	a2,s0,-64
    80006750:	fd843583          	ld	a1,-40(s0)
    80006754:	95b6                	add	a1,a1,a3
    80006756:	68a8                	ld	a0,80(s1)
    80006758:	ffffb097          	auipc	ra,0xffffb
    8000675c:	468080e7          	jalr	1128(ra) # 80001bc0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006760:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006762:	06055763          	bgez	a0,800067d0 <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    80006766:	fc442783          	lw	a5,-60(s0)
    8000676a:	078e                	slli	a5,a5,0x3
    8000676c:	0d078793          	addi	a5,a5,208
    80006770:	97a6                	add	a5,a5,s1
    80006772:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006776:	fc042783          	lw	a5,-64(s0)
    8000677a:	078e                	slli	a5,a5,0x3
    8000677c:	0d078793          	addi	a5,a5,208
    80006780:	97a6                	add	a5,a5,s1
    80006782:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006786:	fd043503          	ld	a0,-48(s0)
    8000678a:	fffff097          	auipc	ra,0xfffff
    8000678e:	906080e7          	jalr	-1786(ra) # 80005090 <fileclose>
    fileclose(wf);
    80006792:	fc843503          	ld	a0,-56(s0)
    80006796:	fffff097          	auipc	ra,0xfffff
    8000679a:	8fa080e7          	jalr	-1798(ra) # 80005090 <fileclose>
    return -1;
    8000679e:	57fd                	li	a5,-1
    800067a0:	a805                	j	800067d0 <sys_pipe+0x102>
    if(fd0 >= 0)
    800067a2:	fc442783          	lw	a5,-60(s0)
    800067a6:	0007c863          	bltz	a5,800067b6 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    800067aa:	078e                	slli	a5,a5,0x3
    800067ac:	0d078793          	addi	a5,a5,208
    800067b0:	97a6                	add	a5,a5,s1
    800067b2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800067b6:	fd043503          	ld	a0,-48(s0)
    800067ba:	fffff097          	auipc	ra,0xfffff
    800067be:	8d6080e7          	jalr	-1834(ra) # 80005090 <fileclose>
    fileclose(wf);
    800067c2:	fc843503          	ld	a0,-56(s0)
    800067c6:	fffff097          	auipc	ra,0xfffff
    800067ca:	8ca080e7          	jalr	-1846(ra) # 80005090 <fileclose>
    return -1;
    800067ce:	57fd                	li	a5,-1
}
    800067d0:	853e                	mv	a0,a5
    800067d2:	70e2                	ld	ra,56(sp)
    800067d4:	7442                	ld	s0,48(sp)
    800067d6:	74a2                	ld	s1,40(sp)
    800067d8:	6121                	addi	sp,sp,64
    800067da:	8082                	ret
    800067dc:	0000                	unimp
	...

00000000800067e0 <kernelvec>:
    800067e0:	7111                	addi	sp,sp,-256
    800067e2:	e006                	sd	ra,0(sp)
    800067e4:	e40a                	sd	sp,8(sp)
    800067e6:	e80e                	sd	gp,16(sp)
    800067e8:	ec12                	sd	tp,24(sp)
    800067ea:	f016                	sd	t0,32(sp)
    800067ec:	f41a                	sd	t1,40(sp)
    800067ee:	f81e                	sd	t2,48(sp)
    800067f0:	fc22                	sd	s0,56(sp)
    800067f2:	e0a6                	sd	s1,64(sp)
    800067f4:	e4aa                	sd	a0,72(sp)
    800067f6:	e8ae                	sd	a1,80(sp)
    800067f8:	ecb2                	sd	a2,88(sp)
    800067fa:	f0b6                	sd	a3,96(sp)
    800067fc:	f4ba                	sd	a4,104(sp)
    800067fe:	f8be                	sd	a5,112(sp)
    80006800:	fcc2                	sd	a6,120(sp)
    80006802:	e146                	sd	a7,128(sp)
    80006804:	e54a                	sd	s2,136(sp)
    80006806:	e94e                	sd	s3,144(sp)
    80006808:	ed52                	sd	s4,152(sp)
    8000680a:	f156                	sd	s5,160(sp)
    8000680c:	f55a                	sd	s6,168(sp)
    8000680e:	f95e                	sd	s7,176(sp)
    80006810:	fd62                	sd	s8,184(sp)
    80006812:	e1e6                	sd	s9,192(sp)
    80006814:	e5ea                	sd	s10,200(sp)
    80006816:	e9ee                	sd	s11,208(sp)
    80006818:	edf2                	sd	t3,216(sp)
    8000681a:	f1f6                	sd	t4,224(sp)
    8000681c:	f5fa                	sd	t5,232(sp)
    8000681e:	f9fe                	sd	t6,240(sp)
    80006820:	b87fc0ef          	jal	800033a6 <kerneltrap>
    80006824:	6082                	ld	ra,0(sp)
    80006826:	6122                	ld	sp,8(sp)
    80006828:	61c2                	ld	gp,16(sp)
    8000682a:	7282                	ld	t0,32(sp)
    8000682c:	7322                	ld	t1,40(sp)
    8000682e:	73c2                	ld	t2,48(sp)
    80006830:	7462                	ld	s0,56(sp)
    80006832:	6486                	ld	s1,64(sp)
    80006834:	6526                	ld	a0,72(sp)
    80006836:	65c6                	ld	a1,80(sp)
    80006838:	6666                	ld	a2,88(sp)
    8000683a:	7686                	ld	a3,96(sp)
    8000683c:	7726                	ld	a4,104(sp)
    8000683e:	77c6                	ld	a5,112(sp)
    80006840:	7866                	ld	a6,120(sp)
    80006842:	688a                	ld	a7,128(sp)
    80006844:	692a                	ld	s2,136(sp)
    80006846:	69ca                	ld	s3,144(sp)
    80006848:	6a6a                	ld	s4,152(sp)
    8000684a:	7a8a                	ld	s5,160(sp)
    8000684c:	7b2a                	ld	s6,168(sp)
    8000684e:	7bca                	ld	s7,176(sp)
    80006850:	7c6a                	ld	s8,184(sp)
    80006852:	6c8e                	ld	s9,192(sp)
    80006854:	6d2e                	ld	s10,200(sp)
    80006856:	6dce                	ld	s11,208(sp)
    80006858:	6e6e                	ld	t3,216(sp)
    8000685a:	7e8e                	ld	t4,224(sp)
    8000685c:	7f2e                	ld	t5,232(sp)
    8000685e:	7fce                	ld	t6,240(sp)
    80006860:	6111                	addi	sp,sp,256
    80006862:	10200073          	sret
    80006866:	00000013          	nop
    8000686a:	00000013          	nop
    8000686e:	0001                	nop

0000000080006870 <timervec>:
    80006870:	34051573          	csrrw	a0,mscratch,a0
    80006874:	e10c                	sd	a1,0(a0)
    80006876:	e510                	sd	a2,8(a0)
    80006878:	e914                	sd	a3,16(a0)
    8000687a:	6d0c                	ld	a1,24(a0)
    8000687c:	7110                	ld	a2,32(a0)
    8000687e:	6194                	ld	a3,0(a1)
    80006880:	96b2                	add	a3,a3,a2
    80006882:	e194                	sd	a3,0(a1)
    80006884:	4589                	li	a1,2
    80006886:	14459073          	csrw	sip,a1
    8000688a:	6914                	ld	a3,16(a0)
    8000688c:	6510                	ld	a2,8(a0)
    8000688e:	610c                	ld	a1,0(a0)
    80006890:	34051573          	csrrw	a0,mscratch,a0
    80006894:	30200073          	mret
    80006898:	0001                	nop

000000008000689a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000689a:	1141                	addi	sp,sp,-16
    8000689c:	e406                	sd	ra,8(sp)
    8000689e:	e022                	sd	s0,0(sp)
    800068a0:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800068a2:	0c000737          	lui	a4,0xc000
    800068a6:	4785                	li	a5,1
    800068a8:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800068aa:	c35c                	sw	a5,4(a4)
  *(uint32*)(PLIC + VIRTIO1_IRQ*4) = 1;
    800068ac:	c71c                	sw	a5,8(a4)
}
    800068ae:	60a2                	ld	ra,8(sp)
    800068b0:	6402                	ld	s0,0(sp)
    800068b2:	0141                	addi	sp,sp,16
    800068b4:	8082                	ret

00000000800068b6 <plicinithart>:

void
plicinithart(void)
{
    800068b6:	1141                	addi	sp,sp,-16
    800068b8:	e406                	sd	ra,8(sp)
    800068ba:	e022                	sd	s0,0(sp)
    800068bc:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800068be:	ffffb097          	auipc	ra,0xffffb
    800068c2:	642080e7          	jalr	1602(ra) # 80001f00 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ) | (1 << VIRTIO1_IRQ);
    800068c6:	0085171b          	slliw	a4,a0,0x8
    800068ca:	0c0027b7          	lui	a5,0xc002
    800068ce:	97ba                	add	a5,a5,a4
    800068d0:	40600713          	li	a4,1030
    800068d4:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800068d8:	00d5151b          	slliw	a0,a0,0xd
    800068dc:	0c2017b7          	lui	a5,0xc201
    800068e0:	97aa                	add	a5,a5,a0
    800068e2:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800068e6:	60a2                	ld	ra,8(sp)
    800068e8:	6402                	ld	s0,0(sp)
    800068ea:	0141                	addi	sp,sp,16
    800068ec:	8082                	ret

00000000800068ee <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800068ee:	1141                	addi	sp,sp,-16
    800068f0:	e406                	sd	ra,8(sp)
    800068f2:	e022                	sd	s0,0(sp)
    800068f4:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800068f6:	ffffb097          	auipc	ra,0xffffb
    800068fa:	60a080e7          	jalr	1546(ra) # 80001f00 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800068fe:	00d5151b          	slliw	a0,a0,0xd
    80006902:	0c2017b7          	lui	a5,0xc201
    80006906:	97aa                	add	a5,a5,a0
  return irq;
}
    80006908:	43c8                	lw	a0,4(a5)
    8000690a:	60a2                	ld	ra,8(sp)
    8000690c:	6402                	ld	s0,0(sp)
    8000690e:	0141                	addi	sp,sp,16
    80006910:	8082                	ret

0000000080006912 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006912:	1101                	addi	sp,sp,-32
    80006914:	ec06                	sd	ra,24(sp)
    80006916:	e822                	sd	s0,16(sp)
    80006918:	e426                	sd	s1,8(sp)
    8000691a:	1000                	addi	s0,sp,32
    8000691c:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000691e:	ffffb097          	auipc	ra,0xffffb
    80006922:	5e2080e7          	jalr	1506(ra) # 80001f00 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006926:	00d5179b          	slliw	a5,a0,0xd
    8000692a:	0c201737          	lui	a4,0xc201
    8000692e:	97ba                	add	a5,a5,a4
    80006930:	c3c4                	sw	s1,4(a5)
}
    80006932:	60e2                	ld	ra,24(sp)
    80006934:	6442                	ld	s0,16(sp)
    80006936:	64a2                	ld	s1,8(sp)
    80006938:	6105                	addi	sp,sp,32
    8000693a:	8082                	ret

000000008000693c <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000693c:	1141                	addi	sp,sp,-16
    8000693e:	e406                	sd	ra,8(sp)
    80006940:	e022                	sd	s0,0(sp)
    80006942:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006944:	479d                	li	a5,7
    80006946:	04a7cc63          	blt	a5,a0,8000699e <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    8000694a:	00067797          	auipc	a5,0x67
    8000694e:	5d678793          	addi	a5,a5,1494 # 8006df20 <disk>
    80006952:	97aa                	add	a5,a5,a0
    80006954:	0187c783          	lbu	a5,24(a5)
    80006958:	ebb9                	bnez	a5,800069ae <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000695a:	00451693          	slli	a3,a0,0x4
    8000695e:	00067797          	auipc	a5,0x67
    80006962:	5c278793          	addi	a5,a5,1474 # 8006df20 <disk>
    80006966:	6398                	ld	a4,0(a5)
    80006968:	9736                	add	a4,a4,a3
    8000696a:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    8000696e:	6398                	ld	a4,0(a5)
    80006970:	9736                	add	a4,a4,a3
    80006972:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006976:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000697a:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000697e:	97aa                	add	a5,a5,a0
    80006980:	4705                	li	a4,1
    80006982:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006986:	00067517          	auipc	a0,0x67
    8000698a:	5b250513          	addi	a0,a0,1458 # 8006df38 <disk+0x18>
    8000698e:	ffffc097          	auipc	ra,0xffffc
    80006992:	ec0080e7          	jalr	-320(ra) # 8000284e <wakeup>
}
    80006996:	60a2                	ld	ra,8(sp)
    80006998:	6402                	ld	s0,0(sp)
    8000699a:	0141                	addi	sp,sp,16
    8000699c:	8082                	ret
    panic("free_desc 1");
    8000699e:	00003517          	auipc	a0,0x3
    800069a2:	d7a50513          	addi	a0,a0,-646 # 80009718 <etext+0x718>
    800069a6:	ffffa097          	auipc	ra,0xffffa
    800069aa:	bb8080e7          	jalr	-1096(ra) # 8000055e <panic>
    panic("free_desc 2");
    800069ae:	00003517          	auipc	a0,0x3
    800069b2:	d7a50513          	addi	a0,a0,-646 # 80009728 <etext+0x728>
    800069b6:	ffffa097          	auipc	ra,0xffffa
    800069ba:	ba8080e7          	jalr	-1112(ra) # 8000055e <panic>

00000000800069be <virtio_disk_init>:
{
    800069be:	1101                	addi	sp,sp,-32
    800069c0:	ec06                	sd	ra,24(sp)
    800069c2:	e822                	sd	s0,16(sp)
    800069c4:	e426                	sd	s1,8(sp)
    800069c6:	e04a                	sd	s2,0(sp)
    800069c8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800069ca:	00003597          	auipc	a1,0x3
    800069ce:	d6e58593          	addi	a1,a1,-658 # 80009738 <etext+0x738>
    800069d2:	00067517          	auipc	a0,0x67
    800069d6:	67650513          	addi	a0,a0,1654 # 8006e048 <disk+0x128>
    800069da:	ffffa097          	auipc	ra,0xffffa
    800069de:	2c0080e7          	jalr	704(ra) # 80000c9a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800069e2:	100017b7          	lui	a5,0x10001
    800069e6:	4398                	lw	a4,0(a5)
    800069e8:	2701                	sext.w	a4,a4
    800069ea:	747277b7          	lui	a5,0x74727
    800069ee:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800069f2:	16f71463          	bne	a4,a5,80006b5a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800069f6:	100017b7          	lui	a5,0x10001
    800069fa:	43dc                	lw	a5,4(a5)
    800069fc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800069fe:	4709                	li	a4,2
    80006a00:	14e79d63          	bne	a5,a4,80006b5a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006a04:	100017b7          	lui	a5,0x10001
    80006a08:	479c                	lw	a5,8(a5)
    80006a0a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006a0c:	14e79763          	bne	a5,a4,80006b5a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006a10:	100017b7          	lui	a5,0x10001
    80006a14:	47d8                	lw	a4,12(a5)
    80006a16:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006a18:	554d47b7          	lui	a5,0x554d4
    80006a1c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006a20:	12f71d63          	bne	a4,a5,80006b5a <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006a24:	100017b7          	lui	a5,0x10001
    80006a28:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006a2c:	4705                	li	a4,1
    80006a2e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006a30:	470d                	li	a4,3
    80006a32:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006a34:	10001737          	lui	a4,0x10001
    80006a38:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006a3a:	c7ffe6b7          	lui	a3,0xc7ffe
    80006a3e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f90687>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006a42:	8f75                	and	a4,a4,a3
    80006a44:	100016b7          	lui	a3,0x10001
    80006a48:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006a4a:	472d                	li	a4,11
    80006a4c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006a4e:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006a52:	439c                	lw	a5,0(a5)
    80006a54:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006a58:	8ba1                	andi	a5,a5,8
    80006a5a:	10078863          	beqz	a5,80006b6a <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006a5e:	100017b7          	lui	a5,0x10001
    80006a62:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006a66:	43fc                	lw	a5,68(a5)
    80006a68:	2781                	sext.w	a5,a5
    80006a6a:	10079863          	bnez	a5,80006b7a <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006a6e:	100017b7          	lui	a5,0x10001
    80006a72:	5bdc                	lw	a5,52(a5)
    80006a74:	2781                	sext.w	a5,a5
  if(max == 0)
    80006a76:	10078a63          	beqz	a5,80006b8a <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006a7a:	471d                	li	a4,7
    80006a7c:	10f77f63          	bgeu	a4,a5,80006b9a <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    80006a80:	ffffa097          	auipc	ra,0xffffa
    80006a84:	192080e7          	jalr	402(ra) # 80000c12 <kalloc>
    80006a88:	00067497          	auipc	s1,0x67
    80006a8c:	49848493          	addi	s1,s1,1176 # 8006df20 <disk>
    80006a90:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006a92:	ffffa097          	auipc	ra,0xffffa
    80006a96:	180080e7          	jalr	384(ra) # 80000c12 <kalloc>
    80006a9a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006a9c:	ffffa097          	auipc	ra,0xffffa
    80006aa0:	176080e7          	jalr	374(ra) # 80000c12 <kalloc>
    80006aa4:	87aa                	mv	a5,a0
    80006aa6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006aa8:	6088                	ld	a0,0(s1)
    80006aaa:	10050063          	beqz	a0,80006baa <virtio_disk_init+0x1ec>
    80006aae:	00067717          	auipc	a4,0x67
    80006ab2:	47a73703          	ld	a4,1146(a4) # 8006df28 <disk+0x8>
    80006ab6:	cb75                	beqz	a4,80006baa <virtio_disk_init+0x1ec>
    80006ab8:	cbed                	beqz	a5,80006baa <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006aba:	6605                	lui	a2,0x1
    80006abc:	4581                	li	a1,0
    80006abe:	ffffa097          	auipc	ra,0xffffa
    80006ac2:	36e080e7          	jalr	878(ra) # 80000e2c <memset>
  memset(disk.avail, 0, PGSIZE);
    80006ac6:	00067497          	auipc	s1,0x67
    80006aca:	45a48493          	addi	s1,s1,1114 # 8006df20 <disk>
    80006ace:	6605                	lui	a2,0x1
    80006ad0:	4581                	li	a1,0
    80006ad2:	6488                	ld	a0,8(s1)
    80006ad4:	ffffa097          	auipc	ra,0xffffa
    80006ad8:	358080e7          	jalr	856(ra) # 80000e2c <memset>
  memset(disk.used, 0, PGSIZE);
    80006adc:	6605                	lui	a2,0x1
    80006ade:	4581                	li	a1,0
    80006ae0:	6888                	ld	a0,16(s1)
    80006ae2:	ffffa097          	auipc	ra,0xffffa
    80006ae6:	34a080e7          	jalr	842(ra) # 80000e2c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006aea:	100017b7          	lui	a5,0x10001
    80006aee:	4721                	li	a4,8
    80006af0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006af2:	4098                	lw	a4,0(s1)
    80006af4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006af8:	40d8                	lw	a4,4(s1)
    80006afa:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006afe:	649c                	ld	a5,8(s1)
    80006b00:	0007869b          	sext.w	a3,a5
    80006b04:	10001737          	lui	a4,0x10001
    80006b08:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006b0c:	9781                	srai	a5,a5,0x20
    80006b0e:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006b12:	689c                	ld	a5,16(s1)
    80006b14:	0007869b          	sext.w	a3,a5
    80006b18:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006b1c:	9781                	srai	a5,a5,0x20
    80006b1e:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006b22:	4785                	li	a5,1
    80006b24:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006b26:	00f48c23          	sb	a5,24(s1)
    80006b2a:	00f48ca3          	sb	a5,25(s1)
    80006b2e:	00f48d23          	sb	a5,26(s1)
    80006b32:	00f48da3          	sb	a5,27(s1)
    80006b36:	00f48e23          	sb	a5,28(s1)
    80006b3a:	00f48ea3          	sb	a5,29(s1)
    80006b3e:	00f48f23          	sb	a5,30(s1)
    80006b42:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006b46:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006b4a:	07272823          	sw	s2,112(a4)
}
    80006b4e:	60e2                	ld	ra,24(sp)
    80006b50:	6442                	ld	s0,16(sp)
    80006b52:	64a2                	ld	s1,8(sp)
    80006b54:	6902                	ld	s2,0(sp)
    80006b56:	6105                	addi	sp,sp,32
    80006b58:	8082                	ret
    panic("could not find virtio disk");
    80006b5a:	00003517          	auipc	a0,0x3
    80006b5e:	bee50513          	addi	a0,a0,-1042 # 80009748 <etext+0x748>
    80006b62:	ffffa097          	auipc	ra,0xffffa
    80006b66:	9fc080e7          	jalr	-1540(ra) # 8000055e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006b6a:	00003517          	auipc	a0,0x3
    80006b6e:	bfe50513          	addi	a0,a0,-1026 # 80009768 <etext+0x768>
    80006b72:	ffffa097          	auipc	ra,0xffffa
    80006b76:	9ec080e7          	jalr	-1556(ra) # 8000055e <panic>
    panic("virtio disk should not be ready");
    80006b7a:	00003517          	auipc	a0,0x3
    80006b7e:	c0e50513          	addi	a0,a0,-1010 # 80009788 <etext+0x788>
    80006b82:	ffffa097          	auipc	ra,0xffffa
    80006b86:	9dc080e7          	jalr	-1572(ra) # 8000055e <panic>
    panic("virtio disk has no queue 0");
    80006b8a:	00003517          	auipc	a0,0x3
    80006b8e:	c1e50513          	addi	a0,a0,-994 # 800097a8 <etext+0x7a8>
    80006b92:	ffffa097          	auipc	ra,0xffffa
    80006b96:	9cc080e7          	jalr	-1588(ra) # 8000055e <panic>
    panic("virtio disk max queue too short");
    80006b9a:	00003517          	auipc	a0,0x3
    80006b9e:	c2e50513          	addi	a0,a0,-978 # 800097c8 <etext+0x7c8>
    80006ba2:	ffffa097          	auipc	ra,0xffffa
    80006ba6:	9bc080e7          	jalr	-1604(ra) # 8000055e <panic>
    panic("virtio disk kalloc");
    80006baa:	00003517          	auipc	a0,0x3
    80006bae:	c3e50513          	addi	a0,a0,-962 # 800097e8 <etext+0x7e8>
    80006bb2:	ffffa097          	auipc	ra,0xffffa
    80006bb6:	9ac080e7          	jalr	-1620(ra) # 8000055e <panic>

0000000080006bba <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006bba:	711d                	addi	sp,sp,-96
    80006bbc:	ec86                	sd	ra,88(sp)
    80006bbe:	e8a2                	sd	s0,80(sp)
    80006bc0:	e4a6                	sd	s1,72(sp)
    80006bc2:	e0ca                	sd	s2,64(sp)
    80006bc4:	fc4e                	sd	s3,56(sp)
    80006bc6:	f852                	sd	s4,48(sp)
    80006bc8:	f456                	sd	s5,40(sp)
    80006bca:	f05a                	sd	s6,32(sp)
    80006bcc:	ec5e                	sd	s7,24(sp)
    80006bce:	e862                	sd	s8,16(sp)
    80006bd0:	1080                	addi	s0,sp,96
    80006bd2:	89aa                	mv	s3,a0
    80006bd4:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006bd6:	00c52b83          	lw	s7,12(a0)
    80006bda:	001b9b9b          	slliw	s7,s7,0x1
    80006bde:	1b82                	slli	s7,s7,0x20
    80006be0:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006be4:	00067517          	auipc	a0,0x67
    80006be8:	46450513          	addi	a0,a0,1124 # 8006e048 <disk+0x128>
    80006bec:	ffffa097          	auipc	ra,0xffffa
    80006bf0:	148080e7          	jalr	328(ra) # 80000d34 <acquire>
  for(int i = 0; i < NUM; i++){
    80006bf4:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006bf6:	00067a97          	auipc	s5,0x67
    80006bfa:	32aa8a93          	addi	s5,s5,810 # 8006df20 <disk>
  for(int i = 0; i < 3; i++){
    80006bfe:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006c00:	5c7d                	li	s8,-1
    80006c02:	a885                	j	80006c72 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006c04:	00fa8733          	add	a4,s5,a5
    80006c08:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006c0c:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006c0e:	0207c563          	bltz	a5,80006c38 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006c12:	2905                	addiw	s2,s2,1
    80006c14:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006c16:	07490263          	beq	s2,s4,80006c7a <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006c1a:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006c1c:	00067717          	auipc	a4,0x67
    80006c20:	30470713          	addi	a4,a4,772 # 8006df20 <disk>
    80006c24:	4781                	li	a5,0
    if(disk.free[i]){
    80006c26:	01874683          	lbu	a3,24(a4)
    80006c2a:	fee9                	bnez	a3,80006c04 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80006c2c:	2785                	addiw	a5,a5,1
    80006c2e:	0705                	addi	a4,a4,1
    80006c30:	fe979be3          	bne	a5,s1,80006c26 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006c34:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006c38:	03205163          	blez	s2,80006c5a <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006c3c:	fa042503          	lw	a0,-96(s0)
    80006c40:	00000097          	auipc	ra,0x0
    80006c44:	cfc080e7          	jalr	-772(ra) # 8000693c <free_desc>
      for(int j = 0; j < i; j++)
    80006c48:	4785                	li	a5,1
    80006c4a:	0127d863          	bge	a5,s2,80006c5a <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006c4e:	fa442503          	lw	a0,-92(s0)
    80006c52:	00000097          	auipc	ra,0x0
    80006c56:	cea080e7          	jalr	-790(ra) # 8000693c <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006c5a:	00067597          	auipc	a1,0x67
    80006c5e:	3ee58593          	addi	a1,a1,1006 # 8006e048 <disk+0x128>
    80006c62:	00067517          	auipc	a0,0x67
    80006c66:	2d650513          	addi	a0,a0,726 # 8006df38 <disk+0x18>
    80006c6a:	ffffc097          	auipc	ra,0xffffc
    80006c6e:	b80080e7          	jalr	-1152(ra) # 800027ea <sleep>
  for(int i = 0; i < 3; i++){
    80006c72:	fa040613          	addi	a2,s0,-96
    80006c76:	4901                	li	s2,0
    80006c78:	b74d                	j	80006c1a <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006c7a:	fa042503          	lw	a0,-96(s0)
    80006c7e:	00451693          	slli	a3,a0,0x4

  if(write)
    80006c82:	00067797          	auipc	a5,0x67
    80006c86:	29e78793          	addi	a5,a5,670 # 8006df20 <disk>
    80006c8a:	00451713          	slli	a4,a0,0x4
    80006c8e:	0a070713          	addi	a4,a4,160
    80006c92:	973e                	add	a4,a4,a5
    80006c94:	01603633          	snez	a2,s6
    80006c98:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006c9a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006c9e:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006ca2:	6398                	ld	a4,0(a5)
    80006ca4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006ca6:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006caa:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006cac:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006cae:	6390                	ld	a2,0(a5)
    80006cb0:	00d60833          	add	a6,a2,a3
    80006cb4:	4741                	li	a4,16
    80006cb6:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006cba:	4585                	li	a1,1
    80006cbc:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80006cc0:	fa442703          	lw	a4,-92(s0)
    80006cc4:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006cc8:	0712                	slli	a4,a4,0x4
    80006cca:	963a                	add	a2,a2,a4
    80006ccc:	05898813          	addi	a6,s3,88
    80006cd0:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006cd4:	0007b883          	ld	a7,0(a5)
    80006cd8:	9746                	add	a4,a4,a7
    80006cda:	40000613          	li	a2,1024
    80006cde:	c710                	sw	a2,8(a4)
  if(write)
    80006ce0:	001b3613          	seqz	a2,s6
    80006ce4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006ce8:	8e4d                	or	a2,a2,a1
    80006cea:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006cee:	fa842603          	lw	a2,-88(s0)
    80006cf2:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006cf6:	00451813          	slli	a6,a0,0x4
    80006cfa:	02080813          	addi	a6,a6,32
    80006cfe:	983e                	add	a6,a6,a5
    80006d00:	577d                	li	a4,-1
    80006d02:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006d06:	0612                	slli	a2,a2,0x4
    80006d08:	98b2                	add	a7,a7,a2
    80006d0a:	03068713          	addi	a4,a3,48
    80006d0e:	973e                	add	a4,a4,a5
    80006d10:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006d14:	6398                	ld	a4,0(a5)
    80006d16:	9732                	add	a4,a4,a2
    80006d18:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006d1a:	4689                	li	a3,2
    80006d1c:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006d20:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006d24:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80006d28:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006d2c:	6794                	ld	a3,8(a5)
    80006d2e:	0026d703          	lhu	a4,2(a3)
    80006d32:	8b1d                	andi	a4,a4,7
    80006d34:	0706                	slli	a4,a4,0x1
    80006d36:	96ba                	add	a3,a3,a4
    80006d38:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006d3c:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006d40:	6798                	ld	a4,8(a5)
    80006d42:	00275783          	lhu	a5,2(a4)
    80006d46:	2785                	addiw	a5,a5,1
    80006d48:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006d4c:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006d50:	100017b7          	lui	a5,0x10001
    80006d54:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006d58:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006d5c:	00067917          	auipc	s2,0x67
    80006d60:	2ec90913          	addi	s2,s2,748 # 8006e048 <disk+0x128>
  while(b->disk == 1) {
    80006d64:	84ae                	mv	s1,a1
    80006d66:	00b79c63          	bne	a5,a1,80006d7e <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006d6a:	85ca                	mv	a1,s2
    80006d6c:	854e                	mv	a0,s3
    80006d6e:	ffffc097          	auipc	ra,0xffffc
    80006d72:	a7c080e7          	jalr	-1412(ra) # 800027ea <sleep>
  while(b->disk == 1) {
    80006d76:	0049a783          	lw	a5,4(s3)
    80006d7a:	fe9788e3          	beq	a5,s1,80006d6a <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006d7e:	fa042903          	lw	s2,-96(s0)
    80006d82:	00491713          	slli	a4,s2,0x4
    80006d86:	02070713          	addi	a4,a4,32
    80006d8a:	00067797          	auipc	a5,0x67
    80006d8e:	19678793          	addi	a5,a5,406 # 8006df20 <disk>
    80006d92:	97ba                	add	a5,a5,a4
    80006d94:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006d98:	00067997          	auipc	s3,0x67
    80006d9c:	18898993          	addi	s3,s3,392 # 8006df20 <disk>
    80006da0:	00491713          	slli	a4,s2,0x4
    80006da4:	0009b783          	ld	a5,0(s3)
    80006da8:	97ba                	add	a5,a5,a4
    80006daa:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006dae:	854a                	mv	a0,s2
    80006db0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006db4:	00000097          	auipc	ra,0x0
    80006db8:	b88080e7          	jalr	-1144(ra) # 8000693c <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006dbc:	8885                	andi	s1,s1,1
    80006dbe:	f0ed                	bnez	s1,80006da0 <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006dc0:	00067517          	auipc	a0,0x67
    80006dc4:	28850513          	addi	a0,a0,648 # 8006e048 <disk+0x128>
    80006dc8:	ffffa097          	auipc	ra,0xffffa
    80006dcc:	01c080e7          	jalr	28(ra) # 80000de4 <release>
}
    80006dd0:	60e6                	ld	ra,88(sp)
    80006dd2:	6446                	ld	s0,80(sp)
    80006dd4:	64a6                	ld	s1,72(sp)
    80006dd6:	6906                	ld	s2,64(sp)
    80006dd8:	79e2                	ld	s3,56(sp)
    80006dda:	7a42                	ld	s4,48(sp)
    80006ddc:	7aa2                	ld	s5,40(sp)
    80006dde:	7b02                	ld	s6,32(sp)
    80006de0:	6be2                	ld	s7,24(sp)
    80006de2:	6c42                	ld	s8,16(sp)
    80006de4:	6125                	addi	sp,sp,96
    80006de6:	8082                	ret

0000000080006de8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006de8:	1101                	addi	sp,sp,-32
    80006dea:	ec06                	sd	ra,24(sp)
    80006dec:	e822                	sd	s0,16(sp)
    80006dee:	e426                	sd	s1,8(sp)
    80006df0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006df2:	00067497          	auipc	s1,0x67
    80006df6:	12e48493          	addi	s1,s1,302 # 8006df20 <disk>
    80006dfa:	00067517          	auipc	a0,0x67
    80006dfe:	24e50513          	addi	a0,a0,590 # 8006e048 <disk+0x128>
    80006e02:	ffffa097          	auipc	ra,0xffffa
    80006e06:	f32080e7          	jalr	-206(ra) # 80000d34 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006e0a:	100017b7          	lui	a5,0x10001
    80006e0e:	53bc                	lw	a5,96(a5)
    80006e10:	8b8d                	andi	a5,a5,3
    80006e12:	10001737          	lui	a4,0x10001
    80006e16:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006e18:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006e1c:	689c                	ld	a5,16(s1)
    80006e1e:	0204d703          	lhu	a4,32(s1)
    80006e22:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006e26:	04f70a63          	beq	a4,a5,80006e7a <virtio_disk_intr+0x92>
    __sync_synchronize();
    80006e2a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006e2e:	6898                	ld	a4,16(s1)
    80006e30:	0204d783          	lhu	a5,32(s1)
    80006e34:	8b9d                	andi	a5,a5,7
    80006e36:	078e                	slli	a5,a5,0x3
    80006e38:	97ba                	add	a5,a5,a4
    80006e3a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006e3c:	00479713          	slli	a4,a5,0x4
    80006e40:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80006e44:	9726                	add	a4,a4,s1
    80006e46:	01074703          	lbu	a4,16(a4)
    80006e4a:	e729                	bnez	a4,80006e94 <virtio_disk_intr+0xac>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006e4c:	0792                	slli	a5,a5,0x4
    80006e4e:	02078793          	addi	a5,a5,32
    80006e52:	97a6                	add	a5,a5,s1
    80006e54:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006e56:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006e5a:	ffffc097          	auipc	ra,0xffffc
    80006e5e:	9f4080e7          	jalr	-1548(ra) # 8000284e <wakeup>

    disk.used_idx += 1;
    80006e62:	0204d783          	lhu	a5,32(s1)
    80006e66:	2785                	addiw	a5,a5,1
    80006e68:	17c2                	slli	a5,a5,0x30
    80006e6a:	93c1                	srli	a5,a5,0x30
    80006e6c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006e70:	6898                	ld	a4,16(s1)
    80006e72:	00275703          	lhu	a4,2(a4)
    80006e76:	faf71ae3          	bne	a4,a5,80006e2a <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006e7a:	00067517          	auipc	a0,0x67
    80006e7e:	1ce50513          	addi	a0,a0,462 # 8006e048 <disk+0x128>
    80006e82:	ffffa097          	auipc	ra,0xffffa
    80006e86:	f62080e7          	jalr	-158(ra) # 80000de4 <release>
}
    80006e8a:	60e2                	ld	ra,24(sp)
    80006e8c:	6442                	ld	s0,16(sp)
    80006e8e:	64a2                	ld	s1,8(sp)
    80006e90:	6105                	addi	sp,sp,32
    80006e92:	8082                	ret
      panic("virtio_disk_intr status");
    80006e94:	00003517          	auipc	a0,0x3
    80006e98:	96c50513          	addi	a0,a0,-1684 # 80009800 <etext+0x800>
    80006e9c:	ffff9097          	auipc	ra,0xffff9
    80006ea0:	6c2080e7          	jalr	1730(ra) # 8000055e <panic>

0000000080006ea4 <alloc_desc>:
 * 
 * Output: returns the index of the descriptor on success
 *         returns -1 if there are no free descriptors
 *
 */
int alloc_desc(struct virtq *q) {
    80006ea4:	1141                	addi	sp,sp,-16
    80006ea6:	e406                	sd	ra,8(sp)
    80006ea8:	e022                	sd	s0,0(sp)
    80006eaa:	0800                	addi	s0,sp,16
    80006eac:	862a                	mv	a2,a0
  for (int i = 0; i < NUM; i++) {
    80006eae:	01c50793          	addi	a5,a0,28
    80006eb2:	4501                	li	a0,0
    80006eb4:	46a1                	li	a3,8
    if (q->free[i]) {
    80006eb6:	0007c703          	lbu	a4,0(a5)
    80006eba:	eb11                	bnez	a4,80006ece <alloc_desc+0x2a>
  for (int i = 0; i < NUM; i++) {
    80006ebc:	2505                	addiw	a0,a0,1
    80006ebe:	0785                	addi	a5,a5,1
    80006ec0:	fed51be3          	bne	a0,a3,80006eb6 <alloc_desc+0x12>
      q->free[i] = 0;
      return i;
    }
  }
  return -1;
    80006ec4:	557d                	li	a0,-1
}
    80006ec6:	60a2                	ld	ra,8(sp)
    80006ec8:	6402                	ld	s0,0(sp)
    80006eca:	0141                	addi	sp,sp,16
    80006ecc:	8082                	ret
      q->free[i] = 0;
    80006ece:	962a                	add	a2,a2,a0
    80006ed0:	00060e23          	sb	zero,28(a2)
      return i;
    80006ed4:	bfcd                	j	80006ec6 <alloc_desc+0x22>

0000000080006ed6 <free_desc>:
 *     int i: the index at which a descriptor has been allocated in q
 * 
 * Output: None
 *
 */
void free_desc(struct virtq *q, int i) {
    80006ed6:	1141                	addi	sp,sp,-16
    80006ed8:	e406                	sd	ra,8(sp)
    80006eda:	e022                	sd	s0,0(sp)
    80006edc:	0800                	addi	s0,sp,16
  if (i >= NUM)
    80006ede:	479d                	li	a5,7
    80006ee0:	02b7cd63          	blt	a5,a1,80006f1a <free_desc+0x44>
    panic("free_desc 1");
  if (q->free[i])
    80006ee4:	00b507b3          	add	a5,a0,a1
    80006ee8:	01c7c783          	lbu	a5,28(a5)
    80006eec:	ef9d                	bnez	a5,80006f2a <free_desc+0x54>
    panic("free_desc 2");

  q->desc->addr = 0;
    80006eee:	611c                	ld	a5,0(a0)
    80006ef0:	0007b023          	sd	zero,0(a5)
  q->desc->len = 0;
    80006ef4:	611c                	ld	a5,0(a0)
    80006ef6:	0007a423          	sw	zero,8(a5)
  q->desc->flags = 0;
    80006efa:	611c                	ld	a5,0(a0)
    80006efc:	00079623          	sh	zero,12(a5)
  q->desc->next = 0;
    80006f00:	611c                	ld	a5,0(a0)
    80006f02:	00079723          	sh	zero,14(a5)
  wakeup(&q->free[i]);
    80006f06:	05f1                	addi	a1,a1,28
    80006f08:	952e                	add	a0,a0,a1
    80006f0a:	ffffc097          	auipc	ra,0xffffc
    80006f0e:	944080e7          	jalr	-1724(ra) # 8000284e <wakeup>
}
    80006f12:	60a2                	ld	ra,8(sp)
    80006f14:	6402                	ld	s0,0(sp)
    80006f16:	0141                	addi	sp,sp,16
    80006f18:	8082                	ret
    panic("free_desc 1");
    80006f1a:	00002517          	auipc	a0,0x2
    80006f1e:	7fe50513          	addi	a0,a0,2046 # 80009718 <etext+0x718>
    80006f22:	ffff9097          	auipc	ra,0xffff9
    80006f26:	63c080e7          	jalr	1596(ra) # 8000055e <panic>
    panic("free_desc 2");
    80006f2a:	00002517          	auipc	a0,0x2
    80006f2e:	7fe50513          	addi	a0,a0,2046 # 80009728 <etext+0x728>
    80006f32:	ffff9097          	auipc	ra,0xffff9
    80006f36:	62c080e7          	jalr	1580(ra) # 8000055e <panic>

0000000080006f3a <virtio_net_init>:
 * VirtualIO (VIRTIO) device. The process of this function is defined in 
 * section 5.1.5 of the VIRTIO Device specification. Since I'm creating
 * a minimal netowrk driver, I only negotiate VIRTIO_NET_F_MAC
 *
 */
void virtio_net_init(void) {
    80006f3a:	7159                	addi	sp,sp,-112
    80006f3c:	f486                	sd	ra,104(sp)
    80006f3e:	f0a2                	sd	s0,96(sp)
    80006f40:	eca6                	sd	s1,88(sp)
    80006f42:	e8ca                	sd	s2,80(sp)
    80006f44:	e4ce                	sd	s3,72(sp)
    80006f46:	e0d2                	sd	s4,64(sp)
    80006f48:	fc56                	sd	s5,56(sp)
    80006f4a:	f85a                	sd	s6,48(sp)
    80006f4c:	f45e                	sd	s7,40(sp)
    80006f4e:	f062                	sd	s8,32(sp)
    80006f50:	ec66                	sd	s9,24(sp)
    80006f52:	e86a                	sd	s10,16(sp)
    80006f54:	e46e                	sd	s11,8(sp)
    80006f56:	1880                	addi	s0,sp,112
  uint32 status = 0;
  initlock(&net.vnet_lock, "virtio_net");
    80006f58:	00003597          	auipc	a1,0x3
    80006f5c:	8c058593          	addi	a1,a1,-1856 # 80009818 <etext+0x818>
    80006f60:	00067517          	auipc	a0,0x67
    80006f64:	11050513          	addi	a0,a0,272 # 8006e070 <net+0x10>
    80006f68:	ffffa097          	auipc	ra,0xffffa
    80006f6c:	d32080e7          	jalr	-718(ra) # 80000c9a <initlock>

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006f70:	100027b7          	lui	a5,0x10002
    80006f74:	4398                	lw	a4,0(a5)
    80006f76:	2701                	sext.w	a4,a4
    80006f78:	747277b7          	lui	a5,0x74727
    80006f7c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006f80:	32f71a63          	bne	a4,a5,800072b4 <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || 
    80006f84:	100027b7          	lui	a5,0x10002
    80006f88:	43dc                	lw	a5,4(a5)
    80006f8a:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006f8c:	4709                	li	a4,2
    80006f8e:	32e79363          	bne	a5,a4,800072b4 <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80006f92:	100027b7          	lui	a5,0x10002
    80006f96:	479c                	lw	a5,8(a5)
    80006f98:	2781                	sext.w	a5,a5
      *R(VIRTIO_MMIO_VERSION) != 2 || 
    80006f9a:	4705                	li	a4,1
    80006f9c:	30e79c63          	bne	a5,a4,800072b4 <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80006fa0:	100027b7          	lui	a5,0x10002
    80006fa4:	47d8                	lw	a4,12(a5)
    80006fa6:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80006fa8:	554d47b7          	lui	a5,0x554d4
    80006fac:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006fb0:	30f71263          	bne	a4,a5,800072b4 <virtio_net_init+0x37a>
    panic("could not find virtio net");
  }

  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    80006fb4:	100024b7          	lui	s1,0x10002
    80006fb8:	07048493          	addi	s1,s1,112 # 10002070 <_entry-0x6fffdf90>
    80006fbc:	0004a023          	sw	zero,0(s1)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;
    80006fc0:	4785                	li	a5,1
    80006fc2:	c09c                	sw	a5,0(s1)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;
    80006fc4:	478d                	li	a5,3
    80006fc6:	c09c                	sw	a5,0(s1)
  
  // This copies the memory from the config into my driver state struct
  memmove((void *)&net.cfg, (void *)VIRTIO_NET_CONFIG, sizeof(struct virtio_net_config));
    80006fc8:	4631                	li	a2,12
    80006fca:	100025b7          	lui	a1,0x10002
    80006fce:	10058593          	addi	a1,a1,256 # 10002100 <_entry-0x6fffdf00>
    80006fd2:	00067517          	auipc	a0,0x67
    80006fd6:	08e50513          	addi	a0,a0,142 # 8006e060 <net>
    80006fda:	ffffa097          	auipc	ra,0xffffa
    80006fde:	eb2080e7          	jalr	-334(ra) # 80000e8c <memmove>

  // Negotiate the feature bits
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006fe2:	100027b7          	lui	a5,0x10002
    80006fe6:	4b9c                	lw	a5,16(a5)
  features &= VIRTIO_NET_F_MAC;
    80006fe8:	0207f793          	andi	a5,a5,32
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006fec:	10002737          	lui	a4,0x10002
    80006ff0:	d31c                	sw	a5,32(a4)

  // Tell device that feature negotiation is complete
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;
    80006ff2:	47ad                	li	a5,11
    80006ff4:	c09c                	sw	a5,0(s1)

  // Make sure that FEATURES_OK is set
  status = *R(VIRTIO_MMIO_STATUS);
    80006ff6:	409c                	lw	a5,0(s1)
    80006ff8:	00078d1b          	sext.w	s10,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006ffc:	8ba1                	andi	a5,a5,8
    80006ffe:	2c078363          	beqz	a5,800072c4 <virtio_net_init+0x38a>
    panic("virtio net FEATURES_OK unset");

  // Check max queue size
  uint32 max_queue_size = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80007002:	100027b7          	lui	a5,0x10002
    80007006:	5bdc                	lw	a5,52(a5)
    80007008:	2781                	sext.w	a5,a5
  if (max_queue_size == 0)
    8000700a:	2c078563          	beqz	a5,800072d4 <virtio_net_init+0x39a>
    panic("virtio net has no queue 1 (QUEUE_TX)");
  if (max_queue_size < NUM) 
    8000700e:	471d                	li	a4,7
    80007010:	2cf77a63          	bgeu	a4,a5,800072e4 <virtio_net_init+0x3aa>
    panic("virtio net max queue too short");

  /* Initialize QUEUE_TX */
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    80007014:	10002737          	lui	a4,0x10002
    80007018:	4785                	li	a5,1
    8000701a:	db1c                	sw	a5,48(a4)
  net.txq.num = QUEUE_TX;
    8000701c:	00067717          	auipc	a4,0x67
    80007020:	08f72223          	sw	a5,132(a4) # 8006e0a0 <net+0x40>

  // ensure QUEUE_TX is not in use.
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80007024:	100027b7          	lui	a5,0x10002
    80007028:	43fc                	lw	a5,68(a5)
    8000702a:	2781                	sext.w	a5,a5
    8000702c:	2c079463          	bnez	a5,800072f4 <virtio_net_init+0x3ba>
    panic("QUEUE_TX should not be ready\n");

  net.txq.desc = kalloc();
    80007030:	ffffa097          	auipc	ra,0xffffa
    80007034:	be2080e7          	jalr	-1054(ra) # 80000c12 <kalloc>
    80007038:	00067497          	auipc	s1,0x67
    8000703c:	02848493          	addi	s1,s1,40 # 8006e060 <net>
    80007040:	f488                	sd	a0,40(s1)
  net.txq.driver_area = kalloc();
    80007042:	ffffa097          	auipc	ra,0xffffa
    80007046:	bd0080e7          	jalr	-1072(ra) # 80000c12 <kalloc>
    8000704a:	f888                	sd	a0,48(s1)
  net.txq.device_area = kalloc();
    8000704c:	ffffa097          	auipc	ra,0xffffa
    80007050:	bc6080e7          	jalr	-1082(ra) # 80000c12 <kalloc>
    80007054:	87aa                	mv	a5,a0
    80007056:	fc88                	sd	a0,56(s1)
  if (!net.txq.desc || !net.txq.driver_area || !net.txq.device_area) 
    80007058:	7488                	ld	a0,40(s1)
    8000705a:	2a050563          	beqz	a0,80007304 <virtio_net_init+0x3ca>
    8000705e:	00067717          	auipc	a4,0x67
    80007062:	03273703          	ld	a4,50(a4) # 8006e090 <net+0x30>
    80007066:	28070f63          	beqz	a4,80007304 <virtio_net_init+0x3ca>
    8000706a:	28078d63          	beqz	a5,80007304 <virtio_net_init+0x3ca>
    panic("virtio net alloc\n");
  memset(net.txq.desc, 0, PGSIZE);
    8000706e:	6605                	lui	a2,0x1
    80007070:	4581                	li	a1,0
    80007072:	ffffa097          	auipc	ra,0xffffa
    80007076:	dba080e7          	jalr	-582(ra) # 80000e2c <memset>
  memset(net.txq.free, 1, NUM);
    8000707a:	00067497          	auipc	s1,0x67
    8000707e:	fe648493          	addi	s1,s1,-26 # 8006e060 <net>
    80007082:	4621                	li	a2,8
    80007084:	4585                	li	a1,1
    80007086:	00067517          	auipc	a0,0x67
    8000708a:	01e50513          	addi	a0,a0,30 # 8006e0a4 <net+0x44>
    8000708e:	ffffa097          	auipc	ra,0xffffa
    80007092:	d9e080e7          	jalr	-610(ra) # 80000e2c <memset>
  memset(net.txq.driver_area, 0, PGSIZE);
    80007096:	6605                	lui	a2,0x1
    80007098:	4581                	li	a1,0
    8000709a:	7888                	ld	a0,48(s1)
    8000709c:	ffffa097          	auipc	ra,0xffffa
    800070a0:	d90080e7          	jalr	-624(ra) # 80000e2c <memset>
  memset(net.txq.device_area, 0, PGSIZE);
    800070a4:	6605                	lui	a2,0x1
    800070a6:	4581                	li	a1,0
    800070a8:	7c88                	ld	a0,56(s1)
    800070aa:	ffffa097          	auipc	ra,0xffffa
    800070ae:	d82080e7          	jalr	-638(ra) # 80000e2c <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800070b2:	100027b7          	lui	a5,0x10002
    800070b6:	4721                	li	a4,8
    800070b8:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.txq.desc;
    800070ba:	749c                	ld	a5,40(s1)
    800070bc:	0007869b          	sext.w	a3,a5
    800070c0:	10002737          	lui	a4,0x10002
    800070c4:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.txq.desc) >> 32;
    800070c8:	9781                	srai	a5,a5,0x20
    800070ca:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.txq.driver_area;
    800070ce:	789c                	ld	a5,48(s1)
    800070d0:	0007869b          	sext.w	a3,a5
    800070d4:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.txq.driver_area) >> 32;
    800070d8:	9781                	srai	a5,a5,0x20
    800070da:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.txq.device_area;
    800070de:	7c9c                	ld	a5,56(s1)
    800070e0:	0007869b          	sext.w	a3,a5
    800070e4:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.txq.device_area) >> 32;
    800070e8:	9781                	srai	a5,a5,0x20
    800070ea:	0af72223          	sw	a5,164(a4)

  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800070ee:	87ba                	mv	a5,a4
    800070f0:	4705                	li	a4,1
    800070f2:	c3f8                	sw	a4,68(a5)
    800070f4:	04478793          	addi	a5,a5,68 # 10002044 <_entry-0x6fffdfbc>

  /* Initialize QUEUE_RX */

  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_RX;
    800070f8:	10002737          	lui	a4,0x10002
    800070fc:	02072823          	sw	zero,48(a4) # 10002030 <_entry-0x6fffdfd0>
  net.rxq.num = QUEUE_RX;
    80007100:	0604a423          	sw	zero,104(s1)
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80007104:	439c                	lw	a5,0(a5)
    80007106:	2781                	sext.w	a5,a5
    80007108:	20079663          	bnez	a5,80007314 <virtio_net_init+0x3da>
    panic("QUEUE_RX should not be ready\n");

  net.rxq.desc = kalloc();
    8000710c:	ffffa097          	auipc	ra,0xffffa
    80007110:	b06080e7          	jalr	-1274(ra) # 80000c12 <kalloc>
    80007114:	00067497          	auipc	s1,0x67
    80007118:	f4c48493          	addi	s1,s1,-180 # 8006e060 <net>
    8000711c:	e8a8                	sd	a0,80(s1)
  net.rxq.driver_area = kalloc();
    8000711e:	ffffa097          	auipc	ra,0xffffa
    80007122:	af4080e7          	jalr	-1292(ra) # 80000c12 <kalloc>
    80007126:	eca8                	sd	a0,88(s1)
  net.rxq.device_area = kalloc();
    80007128:	ffffa097          	auipc	ra,0xffffa
    8000712c:	aea080e7          	jalr	-1302(ra) # 80000c12 <kalloc>
    80007130:	87aa                	mv	a5,a0
    80007132:	f0a8                	sd	a0,96(s1)
  if (!net.rxq.desc || !net.rxq.driver_area || !net.rxq.device_area) 
    80007134:	68a8                	ld	a0,80(s1)
    80007136:	1e050763          	beqz	a0,80007324 <virtio_net_init+0x3ea>
    8000713a:	00067717          	auipc	a4,0x67
    8000713e:	f7e73703          	ld	a4,-130(a4) # 8006e0b8 <net+0x58>
    80007142:	1e070163          	beqz	a4,80007324 <virtio_net_init+0x3ea>
    80007146:	1c078f63          	beqz	a5,80007324 <virtio_net_init+0x3ea>
    panic("virtio net alloc");
  memset(net.rxq.desc, 0, PGSIZE);
    8000714a:	6605                	lui	a2,0x1
    8000714c:	4581                	li	a1,0
    8000714e:	ffffa097          	auipc	ra,0xffffa
    80007152:	cde080e7          	jalr	-802(ra) # 80000e2c <memset>
  memset(net.rxq.free, 1, NUM);
    80007156:	00067497          	auipc	s1,0x67
    8000715a:	f0a48493          	addi	s1,s1,-246 # 8006e060 <net>
    8000715e:	4621                	li	a2,8
    80007160:	4585                	li	a1,1
    80007162:	00067517          	auipc	a0,0x67
    80007166:	f6a50513          	addi	a0,a0,-150 # 8006e0cc <net+0x6c>
    8000716a:	ffffa097          	auipc	ra,0xffffa
    8000716e:	cc2080e7          	jalr	-830(ra) # 80000e2c <memset>
  memset(net.rxq.driver_area, 0, PGSIZE);
    80007172:	6605                	lui	a2,0x1
    80007174:	4581                	li	a1,0
    80007176:	6ca8                	ld	a0,88(s1)
    80007178:	ffffa097          	auipc	ra,0xffffa
    8000717c:	cb4080e7          	jalr	-844(ra) # 80000e2c <memset>
  memset(net.rxq.device_area, 0, PGSIZE);
    80007180:	6605                	lui	a2,0x1
    80007182:	4581                	li	a1,0
    80007184:	70a8                	ld	a0,96(s1)
    80007186:	ffffa097          	auipc	ra,0xffffa
    8000718a:	ca6080e7          	jalr	-858(ra) # 80000e2c <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000718e:	100027b7          	lui	a5,0x10002
    80007192:	4721                	li	a4,8
    80007194:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.rxq.desc;
    80007196:	68bc                	ld	a5,80(s1)
    80007198:	0007869b          	sext.w	a3,a5
    8000719c:	10002737          	lui	a4,0x10002
    800071a0:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.rxq.desc) >> 32;
    800071a4:	9781                	srai	a5,a5,0x20
    800071a6:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.rxq.driver_area;
    800071aa:	6cbc                	ld	a5,88(s1)
    800071ac:	0007869b          	sext.w	a3,a5
    800071b0:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.rxq.driver_area) >> 32;
    800071b4:	9781                	srai	a5,a5,0x20
    800071b6:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.rxq.device_area;
    800071ba:	70bc                	ld	a5,96(s1)
    800071bc:	0007869b          	sext.w	a3,a5
    800071c0:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.rxq.device_area) >> 32;
    800071c4:	9781                	srai	a5,a5,0x20
    800071c6:	0af72223          	sw	a5,164(a4)
    800071ca:	4a11                	li	s4,4

  for (int i = 0; i < NUM/2; i++) {
    int rx_hdr_desc = alloc_desc(&net.rxq);
    800071cc:	00067a97          	auipc	s5,0x67
    800071d0:	ee4a8a93          	addi	s5,s5,-284 # 8006e0b0 <net+0x50>
    void *rxbuf = kalloc();
    struct virtio_net_hdr *hdr = kalloc();
    if (!rxbuf) panic("rxbuf alloc failed");

    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    800071d4:	4ca9                	li	s9,10
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    800071d6:	4c05                	li	s8,1
    net.rxq.desc[rx_hdr_desc].next = rx_desc;

    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    net.rxq.desc[rx_desc].len = PGSIZE;
    800071d8:	6b85                	lui	s7,0x1
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    800071da:	4b09                	li	s6,2
    int rx_hdr_desc = alloc_desc(&net.rxq);
    800071dc:	8556                	mv	a0,s5
    800071de:	00000097          	auipc	ra,0x0
    800071e2:	cc6080e7          	jalr	-826(ra) # 80006ea4 <alloc_desc>
    800071e6:	89aa                	mv	s3,a0
    int rx_desc = alloc_desc(&net.rxq);
    800071e8:	8556                	mv	a0,s5
    800071ea:	00000097          	auipc	ra,0x0
    800071ee:	cba080e7          	jalr	-838(ra) # 80006ea4 <alloc_desc>
    800071f2:	8daa                	mv	s11,a0
    void *rxbuf = kalloc();
    800071f4:	ffffa097          	auipc	ra,0xffffa
    800071f8:	a1e080e7          	jalr	-1506(ra) # 80000c12 <kalloc>
    800071fc:	892a                	mv	s2,a0
    struct virtio_net_hdr *hdr = kalloc();
    800071fe:	ffffa097          	auipc	ra,0xffffa
    80007202:	a14080e7          	jalr	-1516(ra) # 80000c12 <kalloc>
    if (!rxbuf) panic("rxbuf alloc failed");
    80007206:	12090763          	beqz	s2,80007334 <virtio_net_init+0x3fa>
    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    8000720a:	00499793          	slli	a5,s3,0x4
    8000720e:	68b8                	ld	a4,80(s1)
    80007210:	973e                	add	a4,a4,a5
    80007212:	e308                	sd	a0,0(a4)
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    80007214:	68b8                	ld	a4,80(s1)
    80007216:	973e                	add	a4,a4,a5
    80007218:	01972423          	sw	s9,8(a4)
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    8000721c:	68b8                	ld	a4,80(s1)
    8000721e:	973e                	add	a4,a4,a5
    80007220:	01871623          	sh	s8,12(a4)
    net.rxq.desc[rx_hdr_desc].next = rx_desc;
    80007224:	68b8                	ld	a4,80(s1)
    80007226:	97ba                	add	a5,a5,a4
    80007228:	01b79723          	sh	s11,14(a5) # 1000200e <_entry-0x6fffdff2>
    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    8000722c:	004d9793          	slli	a5,s11,0x4
    80007230:	68b8                	ld	a4,80(s1)
    80007232:	973e                	add	a4,a4,a5
    80007234:	01273023          	sd	s2,0(a4)
    net.rxq.desc[rx_desc].len = PGSIZE;
    80007238:	68b8                	ld	a4,80(s1)
    8000723a:	973e                	add	a4,a4,a5
    8000723c:	01772423          	sw	s7,8(a4)
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    80007240:	68b8                	ld	a4,80(s1)
    80007242:	97ba                	add	a5,a5,a4
    80007244:	01679623          	sh	s6,12(a5)

    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = rx_hdr_desc;
    80007248:	6cb8                	ld	a4,88(s1)
    8000724a:	00275783          	lhu	a5,2(a4)
    8000724e:	8b9d                	andi	a5,a5,7
    80007250:	0786                	slli	a5,a5,0x1
    80007252:	973e                	add	a4,a4,a5
    80007254:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    80007258:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    8000725c:	6cb8                	ld	a4,88(s1)
    8000725e:	00275783          	lhu	a5,2(a4)
    80007262:	2785                	addiw	a5,a5,1
    80007264:	00f71123          	sh	a5,2(a4)
    __sync_synchronize();
    80007268:	0330000f          	fence	rw,rw
  for (int i = 0; i < NUM/2; i++) {
    8000726c:	3a7d                	addiw	s4,s4,-1
    8000726e:	f60a17e3          	bnez	s4,800071dc <virtio_net_init+0x2a2>
  }
  
  // queue is ready
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80007272:	100027b7          	lui	a5,0x10002
    80007276:	4705                	li	a4,1
    80007278:	c3f8                	sw	a4,68(a5)

  // Notify device
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_RX;
    8000727a:	0407a823          	sw	zero,80(a5) # 10002050 <_entry-0x6fffdfb0>

  // Done initializing
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000727e:	004d6d13          	ori	s10,s10,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80007282:	07a7a823          	sw	s10,112(a5)

  // initialize packet buffer
  packet_buf = kalloc();
    80007286:	ffffa097          	auipc	ra,0xffffa
    8000728a:	98c080e7          	jalr	-1652(ra) # 80000c12 <kalloc>
    8000728e:	00005797          	auipc	a5,0x5
    80007292:	74a7bd23          	sd	a0,1882(a5) # 8000c9e8 <packet_buf>
}
    80007296:	70a6                	ld	ra,104(sp)
    80007298:	7406                	ld	s0,96(sp)
    8000729a:	64e6                	ld	s1,88(sp)
    8000729c:	6946                	ld	s2,80(sp)
    8000729e:	69a6                	ld	s3,72(sp)
    800072a0:	6a06                	ld	s4,64(sp)
    800072a2:	7ae2                	ld	s5,56(sp)
    800072a4:	7b42                	ld	s6,48(sp)
    800072a6:	7ba2                	ld	s7,40(sp)
    800072a8:	7c02                	ld	s8,32(sp)
    800072aa:	6ce2                	ld	s9,24(sp)
    800072ac:	6d42                	ld	s10,16(sp)
    800072ae:	6da2                	ld	s11,8(sp)
    800072b0:	6165                	addi	sp,sp,112
    800072b2:	8082                	ret
    panic("could not find virtio net");
    800072b4:	00002517          	auipc	a0,0x2
    800072b8:	57450513          	addi	a0,a0,1396 # 80009828 <etext+0x828>
    800072bc:	ffff9097          	auipc	ra,0xffff9
    800072c0:	2a2080e7          	jalr	674(ra) # 8000055e <panic>
    panic("virtio net FEATURES_OK unset");
    800072c4:	00002517          	auipc	a0,0x2
    800072c8:	58450513          	addi	a0,a0,1412 # 80009848 <etext+0x848>
    800072cc:	ffff9097          	auipc	ra,0xffff9
    800072d0:	292080e7          	jalr	658(ra) # 8000055e <panic>
    panic("virtio net has no queue 1 (QUEUE_TX)");
    800072d4:	00002517          	auipc	a0,0x2
    800072d8:	59450513          	addi	a0,a0,1428 # 80009868 <etext+0x868>
    800072dc:	ffff9097          	auipc	ra,0xffff9
    800072e0:	282080e7          	jalr	642(ra) # 8000055e <panic>
    panic("virtio net max queue too short");
    800072e4:	00002517          	auipc	a0,0x2
    800072e8:	5ac50513          	addi	a0,a0,1452 # 80009890 <etext+0x890>
    800072ec:	ffff9097          	auipc	ra,0xffff9
    800072f0:	272080e7          	jalr	626(ra) # 8000055e <panic>
    panic("QUEUE_TX should not be ready\n");
    800072f4:	00002517          	auipc	a0,0x2
    800072f8:	5bc50513          	addi	a0,a0,1468 # 800098b0 <etext+0x8b0>
    800072fc:	ffff9097          	auipc	ra,0xffff9
    80007300:	262080e7          	jalr	610(ra) # 8000055e <panic>
    panic("virtio net alloc\n");
    80007304:	00002517          	auipc	a0,0x2
    80007308:	5cc50513          	addi	a0,a0,1484 # 800098d0 <etext+0x8d0>
    8000730c:	ffff9097          	auipc	ra,0xffff9
    80007310:	252080e7          	jalr	594(ra) # 8000055e <panic>
    panic("QUEUE_RX should not be ready\n");
    80007314:	00002517          	auipc	a0,0x2
    80007318:	5d450513          	addi	a0,a0,1492 # 800098e8 <etext+0x8e8>
    8000731c:	ffff9097          	auipc	ra,0xffff9
    80007320:	242080e7          	jalr	578(ra) # 8000055e <panic>
    panic("virtio net alloc");
    80007324:	00002517          	auipc	a0,0x2
    80007328:	5e450513          	addi	a0,a0,1508 # 80009908 <etext+0x908>
    8000732c:	ffff9097          	auipc	ra,0xffff9
    80007330:	232080e7          	jalr	562(ra) # 8000055e <panic>
    if (!rxbuf) panic("rxbuf alloc failed");
    80007334:	00002517          	auipc	a0,0x2
    80007338:	5ec50513          	addi	a0,a0,1516 # 80009920 <etext+0x920>
    8000733c:	ffff9097          	auipc	ra,0xffff9
    80007340:	222080e7          	jalr	546(ra) # 8000055e <panic>

0000000080007344 <apply_padding>:
 *      return 0 on success
 *      return 1 when the number of bytes calculated does not make sense
 */
int apply_padding(uint8 num_bytes) {
  uint8 *pkt_ptr = packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
  if (num_bytes > 64 - sizeof(struct virtio_net_hdr) || num_bytes < 1) {
    80007344:	fff5079b          	addiw	a5,a0,-1
    80007348:	0ff7f793          	zext.b	a5,a5
    8000734c:	03500713          	li	a4,53
    80007350:	02f76863          	bltu	a4,a5,80007380 <apply_padding+0x3c>
  uint8 *pkt_ptr = packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    80007354:	04a00693          	li	a3,74
    80007358:	9e89                	subw	a3,a3,a0
    8000735a:	00005717          	auipc	a4,0x5
    8000735e:	68e73703          	ld	a4,1678(a4) # 8000c9e8 <packet_buf>
    80007362:	00e687b3          	add	a5,a3,a4
    80007366:	0705                	addi	a4,a4,1
    80007368:	9736                	add	a4,a4,a3
    8000736a:	357d                	addiw	a0,a0,-1
    8000736c:	1502                	slli	a0,a0,0x20
    8000736e:	9101                	srli	a0,a0,0x20
    80007370:	972a                	add	a4,a4,a0
    printf("malformed packet data");
    return 1;
  }
  for (int i = 0; i < num_bytes; i++) {
    pkt_ptr[i] = 0;
    80007372:	00078023          	sb	zero,0(a5)
  for (int i = 0; i < num_bytes; i++) {
    80007376:	0785                	addi	a5,a5,1
    80007378:	fee79de3          	bne	a5,a4,80007372 <apply_padding+0x2e>
  }
  return 0;
    8000737c:	4501                	li	a0,0
}
    8000737e:	8082                	ret
int apply_padding(uint8 num_bytes) {
    80007380:	1141                	addi	sp,sp,-16
    80007382:	e406                	sd	ra,8(sp)
    80007384:	e022                	sd	s0,0(sp)
    80007386:	0800                	addi	s0,sp,16
    printf("malformed packet data");
    80007388:	00002517          	auipc	a0,0x2
    8000738c:	5b050513          	addi	a0,a0,1456 # 80009938 <etext+0x938>
    80007390:	ffff9097          	auipc	ra,0xffff9
    80007394:	218080e7          	jalr	536(ra) # 800005a8 <printf>
    return 1;
    80007398:	4505                	li	a0,1
}
    8000739a:	60a2                	ld	ra,8(sp)
    8000739c:	6402                	ld	s0,0(sp)
    8000739e:	0141                	addi	sp,sp,16
    800073a0:	8082                	ret

00000000800073a2 <transmit_packet>:
 *                     of the data is 1500 (defined by the ethernet protocol)
 *
 * Output: There is no return value from the function, but the packet frame
 *         is given to the NIC to be transmitted.
 */
void transmit_packet(void *pkt_data, uint16 pkt_len) {
    800073a2:	715d                	addi	sp,sp,-80
    800073a4:	e486                	sd	ra,72(sp)
    800073a6:	e0a2                	sd	s0,64(sp)
    800073a8:	fc26                	sd	s1,56(sp)
    800073aa:	f84a                	sd	s2,48(sp)
    800073ac:	f44e                	sd	s3,40(sp)
    800073ae:	f052                	sd	s4,32(sp)
    800073b0:	ec56                	sd	s5,24(sp)
    800073b2:	e85a                	sd	s6,16(sp)
    800073b4:	e45e                	sd	s7,8(sp)
    800073b6:	e062                	sd	s8,0(sp)
    800073b8:	0880                	addi	s0,sp,80
    800073ba:	8c2a                	mv	s8,a0
    800073bc:	8aae                	mv	s5,a1
  /* Create the header for transmission */
  acquire(&net.vnet_lock);
    800073be:	00067517          	auipc	a0,0x67
    800073c2:	cb250513          	addi	a0,a0,-846 # 8006e070 <net+0x10>
    800073c6:	ffffa097          	auipc	ra,0xffffa
    800073ca:	96e080e7          	jalr	-1682(ra) # 80000d34 <acquire>
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    800073ce:	100027b7          	lui	a5,0x10002
    800073d2:	4705                	li	a4,1
    800073d4:	db98                	sw	a4,48(a5)
  // allocate for packet header and packet_frame
  struct virtio_net_hdr *hdr = kalloc();
    800073d6:	ffffa097          	auipc	ra,0xffffa
    800073da:	83c080e7          	jalr	-1988(ra) # 80000c12 <kalloc>
  if (hdr == 0) 
    800073de:	1a050363          	beqz	a0,80007584 <transmit_packet+0x1e2>
    800073e2:	84aa                	mv	s1,a0
    panic("failed to allocate header\n");
  // initialize the header and packet
  memset(hdr, 0, PGSIZE);
    800073e4:	6605                	lui	a2,0x1
    800073e6:	4581                	li	a1,0
    800073e8:	ffffa097          	auipc	ra,0xffffa
    800073ec:	a44080e7          	jalr	-1468(ra) # 80000e2c <memset>

  int hdr_desc = alloc_desc(&net.txq);
    800073f0:	00067997          	auipc	s3,0x67
    800073f4:	c7098993          	addi	s3,s3,-912 # 8006e060 <net>
    800073f8:	00067517          	auipc	a0,0x67
    800073fc:	c9050513          	addi	a0,a0,-880 # 8006e088 <net+0x28>
    80007400:	00000097          	auipc	ra,0x0
    80007404:	aa4080e7          	jalr	-1372(ra) # 80006ea4 <alloc_desc>
    80007408:	8a2a                	mv	s4,a0
  int pkt_desc = alloc_desc(&net.txq);
    8000740a:	00067517          	auipc	a0,0x67
    8000740e:	c7e50513          	addi	a0,a0,-898 # 8006e088 <net+0x28>
    80007412:	00000097          	auipc	ra,0x0
    80007416:	a92080e7          	jalr	-1390(ra) # 80006ea4 <alloc_desc>
    8000741a:	892a                	mv	s2,a0

  hdr->flags = 0;
    8000741c:	00048023          	sb	zero,0(s1)
  hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
    80007420:	000480a3          	sb	zero,1(s1)
  hdr->hdr_len = 0;
    80007424:	00049123          	sh	zero,2(s1)
  
  memmove(packet_buf , "\xff\xff\xff\xff\xff\xff", 6);
    80007428:	00005b17          	auipc	s6,0x5
    8000742c:	5c0b0b13          	addi	s6,s6,1472 # 8000c9e8 <packet_buf>
    80007430:	4619                	li	a2,6
    80007432:	00002597          	auipc	a1,0x2
    80007436:	53e58593          	addi	a1,a1,1342 # 80009970 <etext+0x970>
    8000743a:	000b3503          	ld	a0,0(s6)
    8000743e:	ffffa097          	auipc	ra,0xffffa
    80007442:	a4e080e7          	jalr	-1458(ra) # 80000e8c <memmove>
  memmove(packet_buf + 6, net.cfg.mac, 6);
    80007446:	000b3503          	ld	a0,0(s6)
    8000744a:	4619                	li	a2,6
    8000744c:	85ce                	mv	a1,s3
    8000744e:	9532                	add	a0,a0,a2
    80007450:	ffffa097          	auipc	ra,0xffffa
    80007454:	a3c080e7          	jalr	-1476(ra) # 80000e8c <memmove>
  packet_buf[12] = 0xff;
    80007458:	000b3503          	ld	a0,0(s6)
    8000745c:	577d                	li	a4,-1
    8000745e:	00e50623          	sb	a4,12(a0)
  packet_buf[13] = 0xff;
    80007462:	00e506a3          	sb	a4,13(a0)
  memmove(packet_buf + 14, pkt_data, pkt_len);
    80007466:	000a8b9b          	sext.w	s7,s5
    8000746a:	865e                	mv	a2,s7
    8000746c:	85e2                	mv	a1,s8
    8000746e:	0539                	addi	a0,a0,14
    80007470:	ffffa097          	auipc	ra,0xffffa
    80007474:	a1c080e7          	jalr	-1508(ra) # 80000e8c <memmove>

  net.txq.desc[hdr_desc].flags |= VRING_DESC_F_NEXT; // This tells the device it's a chain
    80007478:	004a1793          	slli	a5,s4,0x4
    8000747c:	0289b703          	ld	a4,40(s3)
    80007480:	973e                	add	a4,a4,a5
    80007482:	00c75683          	lhu	a3,12(a4)
    80007486:	0016e693          	ori	a3,a3,1
    8000748a:	00d71623          	sh	a3,12(a4)
  net.txq.desc[hdr_desc].len =  HDR_SIZE;
    8000748e:	0289b703          	ld	a4,40(s3)
    80007492:	973e                	add	a4,a4,a5
    80007494:	46a9                	li	a3,10
    80007496:	c714                	sw	a3,8(a4)
  net.txq.desc[hdr_desc].addr = (uint64)hdr;
    80007498:	0289b703          	ld	a4,40(s3)
    8000749c:	973e                	add	a4,a4,a5
    8000749e:	e304                	sd	s1,0(a4)
  net.txq.desc[hdr_desc].next = pkt_desc;
    800074a0:	0289b703          	ld	a4,40(s3)
    800074a4:	97ba                	add	a5,a5,a4
    800074a6:	01279723          	sh	s2,14(a5) # 1000200e <_entry-0x6fffdff2>

  net.txq.desc[pkt_desc].len = 14 + pkt_len;
    800074aa:	0912                	slli	s2,s2,0x4
    800074ac:	0289b783          	ld	a5,40(s3)
    800074b0:	97ca                	add	a5,a5,s2
    800074b2:	00ea871b          	addiw	a4,s5,14
    800074b6:	c798                	sw	a4,8(a5)
  net.txq.desc[pkt_desc].addr = (uint64)packet_buf;
    800074b8:	0289b783          	ld	a5,40(s3)
    800074bc:	97ca                	add	a5,a5,s2
    800074be:	000b3703          	ld	a4,0(s6)
    800074c2:	e398                	sd	a4,0(a5)
  net.txq.desc[pkt_desc].flags = 0;
    800074c4:	0289b783          	ld	a5,40(s3)
    800074c8:	97ca                	add	a5,a5,s2
    800074ca:	00079623          	sh	zero,12(a5)

  if (pkt_len < 64) {
    800074ce:	03f00793          	li	a5,63
    800074d2:	0377e563          	bltu	a5,s7,800074fc <transmit_packet+0x15a>
    int res = apply_padding(64 - pkt_len);
    800074d6:	04000513          	li	a0,64
    800074da:	4155053b          	subw	a0,a0,s5
    800074de:	0ff57513          	zext.b	a0,a0
    800074e2:	00000097          	auipc	ra,0x0
    800074e6:	e62080e7          	jalr	-414(ra) # 80007344 <apply_padding>
    net.txq.desc[pkt_desc].len = 64;
    800074ea:	00067797          	auipc	a5,0x67
    800074ee:	b9e7b783          	ld	a5,-1122(a5) # 8006e088 <net+0x28>
    800074f2:	97ca                	add	a5,a5,s2
    800074f4:	04000713          	li	a4,64
    800074f8:	c798                	sw	a4,8(a5)
    if (res != 0) 
    800074fa:	ed49                	bnez	a0,80007594 <transmit_packet+0x1f2>
      panic("failed to apply padding");
  }

  // Tell the device first index in chain of descriptors
  net.txq.driver_area->ring[net.txq.driver_area->idx % NUM] = hdr_desc;
    800074fc:	00067917          	auipc	s2,0x67
    80007500:	b6490913          	addi	s2,s2,-1180 # 8006e060 <net>
    80007504:	03093703          	ld	a4,48(s2)
    80007508:	00275783          	lhu	a5,2(a4)
    8000750c:	8b9d                	andi	a5,a5,7
    8000750e:	0786                	slli	a5,a5,0x1
    80007510:	973e                	add	a4,a4,a5
    80007512:	01471223          	sh	s4,4(a4)
  __sync_synchronize();
    80007516:	0330000f          	fence	rw,rw
  // Tell the device another avail ring entry is available
  net.txq.driver_area->idx++;
    8000751a:	03093703          	ld	a4,48(s2)
    8000751e:	00275783          	lhu	a5,2(a4)
    80007522:	2785                	addiw	a5,a5,1
    80007524:	00f71123          	sh	a5,2(a4)
  __sync_synchronize();
    80007528:	0330000f          	fence	rw,rw

  uint16 prev_used_idx = net.txq.device_area->idx;
    8000752c:	03893783          	ld	a5,56(s2)
    80007530:	0027d483          	lhu	s1,2(a5)
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_TX;
    80007534:	100027b7          	lui	a5,0x10002
    80007538:	4705                	li	a4,1
    8000753a:	cbb8                	sw	a4,80(a5)
  release(&net.vnet_lock);
    8000753c:	00067517          	auipc	a0,0x67
    80007540:	b3450513          	addi	a0,a0,-1228 # 8006e070 <net+0x10>
    80007544:	ffffa097          	auipc	ra,0xffffa
    80007548:	8a0080e7          	jalr	-1888(ra) # 80000de4 <release>

  // Wait for the device to use the descriptor. It indicates this by decrementing
  // the index. Polling helps to avoid race conditions
  while (net.txq.device_area->idx == prev_used_idx) {
    8000754c:	03893783          	ld	a5,56(s2)
    80007550:	0027d783          	lhu	a5,2(a5) # 10002002 <_entry-0x6fffdffe>
    80007554:	00979c63          	bne	a5,s1,8000756c <transmit_packet+0x1ca>
    80007558:	86ca                	mv	a3,s2
    8000755a:	0004871b          	sext.w	a4,s1
    __sync_synchronize();
    8000755e:	0330000f          	fence	rw,rw
  while (net.txq.device_area->idx == prev_used_idx) {
    80007562:	7e9c                	ld	a5,56(a3)
    80007564:	0027d783          	lhu	a5,2(a5)
    80007568:	fee78be3          	beq	a5,a4,8000755e <transmit_packet+0x1bc>
  }
}
    8000756c:	60a6                	ld	ra,72(sp)
    8000756e:	6406                	ld	s0,64(sp)
    80007570:	74e2                	ld	s1,56(sp)
    80007572:	7942                	ld	s2,48(sp)
    80007574:	79a2                	ld	s3,40(sp)
    80007576:	7a02                	ld	s4,32(sp)
    80007578:	6ae2                	ld	s5,24(sp)
    8000757a:	6b42                	ld	s6,16(sp)
    8000757c:	6ba2                	ld	s7,8(sp)
    8000757e:	6c02                	ld	s8,0(sp)
    80007580:	6161                	addi	sp,sp,80
    80007582:	8082                	ret
    panic("failed to allocate header\n");
    80007584:	00002517          	auipc	a0,0x2
    80007588:	3cc50513          	addi	a0,a0,972 # 80009950 <etext+0x950>
    8000758c:	ffff9097          	auipc	ra,0xffff9
    80007590:	fd2080e7          	jalr	-46(ra) # 8000055e <panic>
      panic("failed to apply padding");
    80007594:	00002517          	auipc	a0,0x2
    80007598:	3e450513          	addi	a0,a0,996 # 80009978 <etext+0x978>
    8000759c:	ffff9097          	auipc	ra,0xffff9
    800075a0:	fc2080e7          	jalr	-62(ra) # 8000055e <panic>

00000000800075a4 <receive_packet>:

uint16 receive_packet(void *pkt_buf, uint16 num_bytes) {
    800075a4:	7139                	addi	sp,sp,-64
    800075a6:	fc06                	sd	ra,56(sp)
    800075a8:	f822                	sd	s0,48(sp)
    800075aa:	f426                	sd	s1,40(sp)
    800075ac:	0080                	addi	s0,sp,64
  acquire(&net.vnet_lock);
    800075ae:	00067497          	auipc	s1,0x67
    800075b2:	ab248493          	addi	s1,s1,-1358 # 8006e060 <net>
    800075b6:	00067517          	auipc	a0,0x67
    800075ba:	aba50513          	addi	a0,a0,-1350 # 8006e070 <net+0x10>
    800075be:	ffff9097          	auipc	ra,0xffff9
    800075c2:	776080e7          	jalr	1910(ra) # 80000d34 <acquire>
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    800075c6:	58fc                	lw	a5,116(s1)
    800075c8:	70b8                	ld	a4,96(s1)
    800075ca:	00275683          	lhu	a3,2(a4)
    800075ce:	0cf68063          	beq	a3,a5,8000768e <receive_packet+0xea>
    800075d2:	f04a                	sd	s2,32(sp)
    800075d4:	ec4e                	sd	s3,24(sp)
    800075d6:	e852                	sd	s4,16(sp)
    800075d8:	e456                	sd	s5,8(sp)
    800075da:	e05a                	sd	s6,0(sp)
    int id = net.rxq.device_area->ring[net.rxq.used_idx % NUM].id;
    uint len = net.rxq.device_area->ring[net.rxq.used_idx % NUM].len;

    char *packet = (char *)net.rxq.desc[net.rxq.desc[id].next].addr;
    800075dc:	8a26                	mv	s4,s1

    printf("Interrupt: received packet of length %d\n", len);
    800075de:	00002a97          	auipc	s5,0x2
    800075e2:	3b2a8a93          	addi	s5,s5,946 # 80009990 <etext+0x990>
    // Optional: do something with 'packet'
    
    for (int i = 0; i < len; i++) {
      printf("%x", packet[i]);
    800075e6:	00002997          	auipc	s3,0x2
    800075ea:	3da98993          	addi	s3,s3,986 # 800099c0 <etext+0x9c0>
    int id = net.rxq.device_area->ring[net.rxq.used_idx % NUM].id;
    800075ee:	41f7d69b          	sraiw	a3,a5,0x1f
    800075f2:	01d6d69b          	srliw	a3,a3,0x1d
    800075f6:	9fb5                	addw	a5,a5,a3
    800075f8:	8b9d                	andi	a5,a5,7
    800075fa:	9f95                	subw	a5,a5,a3
    800075fc:	078e                	slli	a5,a5,0x3
    800075fe:	973e                	add	a4,a4,a5
    80007600:	00472b03          	lw	s6,4(a4)
    uint len = net.rxq.device_area->ring[net.rxq.used_idx % NUM].len;
    80007604:	00872903          	lw	s2,8(a4)
    char *packet = (char *)net.rxq.desc[net.rxq.desc[id].next].addr;
    80007608:	050a3783          	ld	a5,80(s4)
    8000760c:	004b1713          	slli	a4,s6,0x4
    80007610:	973e                	add	a4,a4,a5
    80007612:	00e75703          	lhu	a4,14(a4)
    80007616:	0712                	slli	a4,a4,0x4
    80007618:	97ba                	add	a5,a5,a4
    8000761a:	6384                	ld	s1,0(a5)
    printf("Interrupt: received packet of length %d\n", len);
    8000761c:	85ca                	mv	a1,s2
    8000761e:	8556                	mv	a0,s5
    80007620:	ffff9097          	auipc	ra,0xffff9
    80007624:	f88080e7          	jalr	-120(ra) # 800005a8 <printf>
    for (int i = 0; i < len; i++) {
    80007628:	02090063          	beqz	s2,80007648 <receive_packet+0xa4>
    8000762c:	1902                	slli	s2,s2,0x20
    8000762e:	02095913          	srli	s2,s2,0x20
    80007632:	9926                	add	s2,s2,s1
      printf("%x", packet[i]);
    80007634:	0004c583          	lbu	a1,0(s1)
    80007638:	854e                	mv	a0,s3
    8000763a:	ffff9097          	auipc	ra,0xffff9
    8000763e:	f6e080e7          	jalr	-146(ra) # 800005a8 <printf>
    for (int i = 0; i < len; i++) {
    80007642:	0485                	addi	s1,s1,1
    80007644:	ff2498e3          	bne	s1,s2,80007634 <receive_packet+0x90>
    } 

    // Requeue the buffer
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    80007648:	058a3703          	ld	a4,88(s4)
    8000764c:	00275783          	lhu	a5,2(a4)
    80007650:	8b9d                	andi	a5,a5,7
    80007652:	0786                	slli	a5,a5,0x1
    80007654:	973e                	add	a4,a4,a5
    80007656:	01671223          	sh	s6,4(a4)
    __sync_synchronize();
    8000765a:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    8000765e:	058a3703          	ld	a4,88(s4)
    80007662:	00275783          	lhu	a5,2(a4)
    80007666:	2785                	addiw	a5,a5,1
    80007668:	00f71123          	sh	a5,2(a4)
    net.rxq.used_idx++;
    8000766c:	074a2703          	lw	a4,116(s4)
    80007670:	2705                	addiw	a4,a4,1
    80007672:	87ba                	mv	a5,a4
    80007674:	06ea2a23          	sw	a4,116(s4)
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    80007678:	060a3703          	ld	a4,96(s4)
    8000767c:	00275683          	lhu	a3,2(a4)
    80007680:	f6f697e3          	bne	a3,a5,800075ee <receive_packet+0x4a>
    80007684:	7902                	ld	s2,32(sp)
    80007686:	69e2                	ld	s3,24(sp)
    80007688:	6a42                	ld	s4,16(sp)
    8000768a:	6aa2                	ld	s5,8(sp)
    8000768c:	6b02                	ld	s6,0(sp)
  }
  release(&net.vnet_lock);
    8000768e:	00067517          	auipc	a0,0x67
    80007692:	9e250513          	addi	a0,a0,-1566 # 8006e070 <net+0x10>
    80007696:	ffff9097          	auipc	ra,0xffff9
    8000769a:	74e080e7          	jalr	1870(ra) # 80000de4 <release>
}
    8000769e:	70e2                	ld	ra,56(sp)
    800076a0:	7442                	ld	s0,48(sp)
    800076a2:	74a2                	ld	s1,40(sp)
    800076a4:	6121                	addi	sp,sp,64
    800076a6:	8082                	ret
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0)
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	jr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800080ae:	0536                	slli	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0)
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
