
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00010117          	auipc	sp,0x10
    80000004:	ed010113          	addi	sp,sp,-304 # 8000fed0 <stack0>
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
    80000050:	00010797          	auipc	a5,0x10
    80000054:	d4078793          	addi	a5,a5,-704 # 8000fd90 <timer_scratch>
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
    80000066:	c4e78793          	addi	a5,a5,-946 # 80006cb0 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff8af67>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	f3878793          	addi	a5,a5,-200 # 80000fe6 <main>
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
    80000138:	d20080e7          	jalr	-736(ra) # 80002e54 <either_copyin>
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
    8000019a:	00018517          	auipc	a0,0x18
    8000019e:	d3650513          	addi	a0,a0,-714 # 80017ed0 <cons>
    800001a2:	00001097          	auipc	ra,0x1
    800001a6:	b92080e7          	jalr	-1134(ra) # 80000d34 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001aa:	00018497          	auipc	s1,0x18
    800001ae:	d2648493          	addi	s1,s1,-730 # 80017ed0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b2:	00018917          	auipc	s2,0x18
    800001b6:	db690913          	addi	s2,s2,-586 # 80017f68 <cons+0x98>
  while(n > 0){
    800001ba:	0d305563          	blez	s3,80000284 <consoleread+0x106>
    while(cons.r == cons.w){
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	0af71a63          	bne	a4,a5,8000027a <consoleread+0xfc>
      if(killed(myproc())){
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	cb4080e7          	jalr	-844(ra) # 80001e7e <myproc>
    800001d2:	00003097          	auipc	ra,0x3
    800001d6:	990080e7          	jalr	-1648(ra) # 80002b62 <killed>
    800001da:	e52d                	bnez	a0,80000244 <consoleread+0xc6>
      sleep(&cons.r, &cons.lock);
    800001dc:	85a6                	mv	a1,s1
    800001de:	854a                	mv	a0,s2
    800001e0:	00002097          	auipc	ra,0x2
    800001e4:	554080e7          	jalr	1364(ra) # 80002734 <sleep>
    while(cons.r == cons.w){
    800001e8:	0984a783          	lw	a5,152(s1)
    800001ec:	09c4a703          	lw	a4,156(s1)
    800001f0:	fcf70de3          	beq	a4,a5,800001ca <consoleread+0x4c>
    800001f4:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f6:	00018717          	auipc	a4,0x18
    800001fa:	cda70713          	addi	a4,a4,-806 # 80017ed0 <cons>
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
    8000022c:	bd6080e7          	jalr	-1066(ra) # 80002dfe <either_copyout>
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
    80000244:	00018517          	auipc	a0,0x18
    80000248:	c8c50513          	addi	a0,a0,-884 # 80017ed0 <cons>
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
    8000026e:	00018717          	auipc	a4,0x18
    80000272:	cef72d23          	sw	a5,-774(a4) # 80017f68 <cons+0x98>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	a031                	j	80000284 <consoleread+0x106>
    8000027a:	f456                	sd	s5,40(sp)
    8000027c:	bfad                	j	800001f6 <consoleread+0x78>
    8000027e:	7aa2                	ld	s5,40(sp)
    80000280:	a011                	j	80000284 <consoleread+0x106>
    80000282:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000284:	00018517          	auipc	a0,0x18
    80000288:	c4c50513          	addi	a0,a0,-948 # 80017ed0 <cons>
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
    800002ec:	00018517          	auipc	a0,0x18
    800002f0:	be450513          	addi	a0,a0,-1052 # 80017ed0 <cons>
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
    80000316:	b98080e7          	jalr	-1128(ra) # 80002eaa <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000031a:	00018517          	auipc	a0,0x18
    8000031e:	bb650513          	addi	a0,a0,-1098 # 80017ed0 <cons>
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
    8000033c:	00018717          	auipc	a4,0x18
    80000340:	b9470713          	addi	a4,a4,-1132 # 80017ed0 <cons>
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
    80000366:	00018717          	auipc	a4,0x18
    8000036a:	b6a70713          	addi	a4,a4,-1174 # 80017ed0 <cons>
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
    80000390:	00018717          	auipc	a4,0x18
    80000394:	bd872703          	lw	a4,-1064(a4) # 80017f68 <cons+0x98>
    80000398:	9f99                	subw	a5,a5,a4
    8000039a:	08000713          	li	a4,128
    8000039e:	f6e79ee3          	bne	a5,a4,8000031a <consoleintr+0x3a>
    800003a2:	a865                	j	8000045a <consoleintr+0x17a>
    800003a4:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800003a6:	00018717          	auipc	a4,0x18
    800003aa:	b2a70713          	addi	a4,a4,-1238 # 80017ed0 <cons>
    800003ae:	0a072783          	lw	a5,160(a4)
    800003b2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003b6:	00018497          	auipc	s1,0x18
    800003ba:	b1a48493          	addi	s1,s1,-1254 # 80017ed0 <cons>
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
    800003fc:	00018717          	auipc	a4,0x18
    80000400:	ad470713          	addi	a4,a4,-1324 # 80017ed0 <cons>
    80000404:	0a072783          	lw	a5,160(a4)
    80000408:	09c72703          	lw	a4,156(a4)
    8000040c:	f0f707e3          	beq	a4,a5,8000031a <consoleintr+0x3a>
      cons.e--;
    80000410:	37fd                	addiw	a5,a5,-1
    80000412:	00018717          	auipc	a4,0x18
    80000416:	b4f72f23          	sw	a5,-1186(a4) # 80017f70 <cons+0xa0>
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
    80000438:	00018797          	auipc	a5,0x18
    8000043c:	a9878793          	addi	a5,a5,-1384 # 80017ed0 <cons>
    80000440:	0a07a703          	lw	a4,160(a5)
    80000444:	0017069b          	addiw	a3,a4,1
    80000448:	8636                	mv	a2,a3
    8000044a:	0ad7a023          	sw	a3,160(a5)
    8000044e:	07f77713          	andi	a4,a4,127
    80000452:	97ba                	add	a5,a5,a4
    80000454:	4729                	li	a4,10
    80000456:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000045a:	00018797          	auipc	a5,0x18
    8000045e:	b0c7a923          	sw	a2,-1262(a5) # 80017f6c <cons+0x9c>
        wakeup(&cons.r);
    80000462:	00018517          	auipc	a0,0x18
    80000466:	b0650513          	addi	a0,a0,-1274 # 80017f68 <cons+0x98>
    8000046a:	00002097          	auipc	ra,0x2
    8000046e:	32e080e7          	jalr	814(ra) # 80002798 <wakeup>
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
    8000047c:	0000b597          	auipc	a1,0xb
    80000480:	b9458593          	addi	a1,a1,-1132 # 8000b010 <etext+0x10>
    80000484:	00018517          	auipc	a0,0x18
    80000488:	a4c50513          	addi	a0,a0,-1460 # 80017ed0 <cons>
    8000048c:	00001097          	auipc	ra,0x1
    80000490:	80e080e7          	jalr	-2034(ra) # 80000c9a <initlock>

  uartinit();
    80000494:	00000097          	auipc	ra,0x0
    80000498:	350080e7          	jalr	848(ra) # 800007e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000049c:	00070797          	auipc	a5,0x70
    800004a0:	dcc78793          	addi	a5,a5,-564 # 80070268 <devsw>
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
    800004da:	0000c817          	auipc	a6,0xc
    800004de:	9fe80813          	addi	a6,a6,-1538 # 8000bed8 <digits>
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
    8000056a:	00018797          	auipc	a5,0x18
    8000056e:	a207a323          	sw	zero,-1498(a5) # 80017f90 <pr+0x18>
  printf("panic: ");
    80000572:	0000b517          	auipc	a0,0xb
    80000576:	aa650513          	addi	a0,a0,-1370 # 8000b018 <etext+0x18>
    8000057a:	00000097          	auipc	ra,0x0
    8000057e:	02e080e7          	jalr	46(ra) # 800005a8 <printf>
  printf(s);
    80000582:	8526                	mv	a0,s1
    80000584:	00000097          	auipc	ra,0x0
    80000588:	024080e7          	jalr	36(ra) # 800005a8 <printf>
  printf("\n");
    8000058c:	0000b517          	auipc	a0,0xb
    80000590:	a9450513          	addi	a0,a0,-1388 # 8000b020 <etext+0x20>
    80000594:	00000097          	auipc	ra,0x0
    80000598:	014080e7          	jalr	20(ra) # 800005a8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059c:	4785                	li	a5,1
    8000059e:	0000f717          	auipc	a4,0xf
    800005a2:	78f72923          	sw	a5,1938(a4) # 8000fd30 <panicked>
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
    800005c8:	00018d97          	auipc	s11,0x18
    800005cc:	9c8dad83          	lw	s11,-1592(s11) # 80017f90 <pr+0x18>
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
    8000060a:	0000ca97          	auipc	s5,0xc
    8000060e:	8cea8a93          	addi	s5,s5,-1842 # 8000bed8 <digits>
    switch(c){
    80000612:	07300c13          	li	s8,115
    80000616:	a0b9                	j	80000664 <printf+0xbc>
    acquire(&pr.lock);
    80000618:	00018517          	auipc	a0,0x18
    8000061c:	96050513          	addi	a0,a0,-1696 # 80017f78 <pr>
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
    8000063c:	0000b517          	auipc	a0,0xb
    80000640:	9f450513          	addi	a0,a0,-1548 # 8000b030 <etext+0x30>
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
    8000073a:	0000b497          	auipc	s1,0xb
    8000073e:	8ee48493          	addi	s1,s1,-1810 # 8000b028 <etext+0x28>
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
    800007a0:	00017517          	auipc	a0,0x17
    800007a4:	7d850513          	addi	a0,a0,2008 # 80017f78 <pr>
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
    800007ba:	0000b597          	auipc	a1,0xb
    800007be:	88658593          	addi	a1,a1,-1914 # 8000b040 <etext+0x40>
    800007c2:	00017517          	auipc	a0,0x17
    800007c6:	7b650513          	addi	a0,a0,1974 # 80017f78 <pr>
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	4d0080e7          	jalr	1232(ra) # 80000c9a <initlock>
  pr.locking = 1;
    800007d2:	4785                	li	a5,1
    800007d4:	00017717          	auipc	a4,0x17
    800007d8:	7af72e23          	sw	a5,1980(a4) # 80017f90 <pr+0x18>
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
    8000081e:	0000b597          	auipc	a1,0xb
    80000822:	82a58593          	addi	a1,a1,-2006 # 8000b048 <etext+0x48>
    80000826:	00017517          	auipc	a0,0x17
    8000082a:	77250513          	addi	a0,a0,1906 # 80017f98 <uart_tx_lock>
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
    80000852:	0000f797          	auipc	a5,0xf
    80000856:	4de7a783          	lw	a5,1246(a5) # 8000fd30 <panicked>
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
    8000088c:	0000f797          	auipc	a5,0xf
    80000890:	4ac7b783          	ld	a5,1196(a5) # 8000fd38 <uart_tx_r>
    80000894:	0000f717          	auipc	a4,0xf
    80000898:	4ac73703          	ld	a4,1196(a4) # 8000fd40 <uart_tx_w>
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
    800008ba:	00017a97          	auipc	s5,0x17
    800008be:	6dea8a93          	addi	s5,s5,1758 # 80017f98 <uart_tx_lock>
    uart_tx_r += 1;
    800008c2:	0000f497          	auipc	s1,0xf
    800008c6:	47648493          	addi	s1,s1,1142 # 8000fd38 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008ca:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ce:	0000f997          	auipc	s3,0xf
    800008d2:	47298993          	addi	s3,s3,1138 # 8000fd40 <uart_tx_w>
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
    800008f4:	ea8080e7          	jalr	-344(ra) # 80002798 <wakeup>
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
    8000092e:	00017517          	auipc	a0,0x17
    80000932:	66a50513          	addi	a0,a0,1642 # 80017f98 <uart_tx_lock>
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	3fe080e7          	jalr	1022(ra) # 80000d34 <acquire>
  if(panicked){
    8000093e:	0000f797          	auipc	a5,0xf
    80000942:	3f27a783          	lw	a5,1010(a5) # 8000fd30 <panicked>
    80000946:	ebc1                	bnez	a5,800009d6 <uartputc+0xba>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000948:	0000f717          	auipc	a4,0xf
    8000094c:	3f873703          	ld	a4,1016(a4) # 8000fd40 <uart_tx_w>
    80000950:	0000f797          	auipc	a5,0xf
    80000954:	3e87b783          	ld	a5,1000(a5) # 8000fd38 <uart_tx_r>
    80000958:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095c:	00017997          	auipc	s3,0x17
    80000960:	63c98993          	addi	s3,s3,1596 # 80017f98 <uart_tx_lock>
    80000964:	0000f497          	auipc	s1,0xf
    80000968:	3d448493          	addi	s1,s1,980 # 8000fd38 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096c:	0000f917          	auipc	s2,0xf
    80000970:	3d490913          	addi	s2,s2,980 # 8000fd40 <uart_tx_w>
    80000974:	00e79f63          	bne	a5,a4,80000992 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000978:	85ce                	mv	a1,s3
    8000097a:	8526                	mv	a0,s1
    8000097c:	00002097          	auipc	ra,0x2
    80000980:	db8080e7          	jalr	-584(ra) # 80002734 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000984:	00093703          	ld	a4,0(s2)
    80000988:	609c                	ld	a5,0(s1)
    8000098a:	02078793          	addi	a5,a5,32
    8000098e:	fee785e3          	beq	a5,a4,80000978 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000992:	01f77693          	andi	a3,a4,31
    80000996:	00017797          	auipc	a5,0x17
    8000099a:	60278793          	addi	a5,a5,1538 # 80017f98 <uart_tx_lock>
    8000099e:	97b6                	add	a5,a5,a3
    800009a0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a4:	0705                	addi	a4,a4,1
    800009a6:	0000f797          	auipc	a5,0xf
    800009aa:	38e7bd23          	sd	a4,922(a5) # 8000fd40 <uart_tx_w>
  uartstart();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	ede080e7          	jalr	-290(ra) # 8000088c <uartstart>
  release(&uart_tx_lock);
    800009b6:	00017517          	auipc	a0,0x17
    800009ba:	5e250513          	addi	a0,a0,1506 # 80017f98 <uart_tx_lock>
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
    80000a22:	00017517          	auipc	a0,0x17
    80000a26:	57650513          	addi	a0,a0,1398 # 80017f98 <uart_tx_lock>
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	30a080e7          	jalr	778(ra) # 80000d34 <acquire>
  uartstart();
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	e5a080e7          	jalr	-422(ra) # 8000088c <uartstart>
  release(&uart_tx_lock);
    80000a3a:	00017517          	auipc	a0,0x17
    80000a3e:	55e50513          	addi	a0,a0,1374 # 80017f98 <uart_tx_lock>
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
    80000a60:	00017517          	auipc	a0,0x17
    80000a64:	57050513          	addi	a0,a0,1392 # 80017fd0 <kmem>
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	2cc080e7          	jalr	716(ra) # 80000d34 <acquire>
  uint page_num = PGROUNDDOWN((uint64)pointer_in_page)/PGSIZE;
  ref_counter[page_num]++;
    80000a70:	01449793          	slli	a5,s1,0x14
    80000a74:	0207d513          	srli	a0,a5,0x20
    80000a78:	050e                	slli	a0,a0,0x3
    80000a7a:	00017797          	auipc	a5,0x17
    80000a7e:	57678793          	addi	a5,a5,1398 # 80017ff0 <ref_counter>
    80000a82:	97aa                	add	a5,a5,a0
    80000a84:	6398                	ld	a4,0(a5)
    80000a86:	0705                	addi	a4,a4,1
    80000a88:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000a8a:	00017517          	auipc	a0,0x17
    80000a8e:	54650513          	addi	a0,a0,1350 # 80017fd0 <kmem>
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
    80000aae:	00073797          	auipc	a5,0x73
    80000ab2:	dea78793          	addi	a5,a5,-534 # 80073898 <end>
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
    80000ad0:	00017517          	auipc	a0,0x17
    80000ad4:	50050513          	addi	a0,a0,1280 # 80017fd0 <kmem>
    80000ad8:	00000097          	auipc	ra,0x0
    80000adc:	25c080e7          	jalr	604(ra) # 80000d34 <acquire>
  uint64 page_num = PGROUNDDOWN((uint64)pa)/PGSIZE;
    80000ae0:	00c4d793          	srli	a5,s1,0xc
  if (ref_counter[page_num] > 1) {
    80000ae4:	00379693          	slli	a3,a5,0x3
    80000ae8:	00017717          	auipc	a4,0x17
    80000aec:	50870713          	addi	a4,a4,1288 # 80017ff0 <ref_counter>
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
    80000afe:	00017717          	auipc	a4,0x17
    80000b02:	4f270713          	addi	a4,a4,1266 # 80017ff0 <ref_counter>
    80000b06:	97ba                	add	a5,a5,a4
    80000b08:	0007b023          	sd	zero,0(a5)
  release(&kmem.lock);
    80000b0c:	00017917          	auipc	s2,0x17
    80000b10:	4c490913          	addi	s2,s2,1220 # 80017fd0 <kmem>
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
    80000b58:	0000a517          	auipc	a0,0xa
    80000b5c:	4f850513          	addi	a0,a0,1272 # 8000b050 <etext+0x50>
    80000b60:	00000097          	auipc	ra,0x0
    80000b64:	9fe080e7          	jalr	-1538(ra) # 8000055e <panic>
    ref_counter[page_num]--;
    80000b68:	078e                	slli	a5,a5,0x3
    80000b6a:	00017697          	auipc	a3,0x17
    80000b6e:	48668693          	addi	a3,a3,1158 # 80017ff0 <ref_counter>
    80000b72:	97b6                	add	a5,a5,a3
    80000b74:	177d                	addi	a4,a4,-1
    80000b76:	e398                	sd	a4,0(a5)
    release(&kmem.lock);
    80000b78:	00017517          	auipc	a0,0x17
    80000b7c:	45850513          	addi	a0,a0,1112 # 80017fd0 <kmem>
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
    80000bde:	0000a597          	auipc	a1,0xa
    80000be2:	47a58593          	addi	a1,a1,1146 # 8000b058 <etext+0x58>
    80000be6:	00017517          	auipc	a0,0x17
    80000bea:	3ea50513          	addi	a0,a0,1002 # 80017fd0 <kmem>
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	0ac080e7          	jalr	172(ra) # 80000c9a <initlock>
  freerange(end, (void*)PHYSTOP);
    80000bf6:	45c5                	li	a1,17
    80000bf8:	05ee                	slli	a1,a1,0x1b
    80000bfa:	00073517          	auipc	a0,0x73
    80000bfe:	c9e50513          	addi	a0,a0,-866 # 80073898 <end>
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
    80000c1c:	00017517          	auipc	a0,0x17
    80000c20:	3b450513          	addi	a0,a0,948 # 80017fd0 <kmem>
    80000c24:	00000097          	auipc	ra,0x0
    80000c28:	110080e7          	jalr	272(ra) # 80000d34 <acquire>

  r = kmem.freelist;
    80000c2c:	00017497          	auipc	s1,0x17
    80000c30:	3bc4b483          	ld	s1,956(s1) # 80017fe8 <kmem+0x18>
  if(r)
    80000c34:	c4a9                	beqz	s1,80000c7e <kalloc+0x6c>
    kmem.freelist = r->next;
    80000c36:	609c                	ld	a5,0(s1)
    80000c38:	00017717          	auipc	a4,0x17
    80000c3c:	3af73823          	sd	a5,944(a4) # 80017fe8 <kmem+0x18>
  uint64 page_num = PGROUNDDOWN((uint64)r)/PGSIZE;
    80000c40:	00c4d713          	srli	a4,s1,0xc
  ref_counter[page_num] = 1;
    80000c44:	070e                	slli	a4,a4,0x3
    80000c46:	00017797          	auipc	a5,0x17
    80000c4a:	3aa78793          	addi	a5,a5,938 # 80017ff0 <ref_counter>
    80000c4e:	97ba                	add	a5,a5,a4
    80000c50:	4705                	li	a4,1
    80000c52:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000c54:	00017517          	auipc	a0,0x17
    80000c58:	37c50513          	addi	a0,a0,892 # 80017fd0 <kmem>
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
    80000c80:	00017717          	auipc	a4,0x17
    80000c84:	36f73823          	sd	a5,880(a4) # 80017ff0 <ref_counter>
  release(&kmem.lock);
    80000c88:	00017517          	auipc	a0,0x17
    80000c8c:	34850513          	addi	a0,a0,840 # 80017fd0 <kmem>
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
    80000cce:	194080e7          	jalr	404(ra) # 80001e5e <mycpu>
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
    80000d02:	160080e7          	jalr	352(ra) # 80001e5e <mycpu>
    80000d06:	5d3c                	lw	a5,120(a0)
    80000d08:	cf89                	beqz	a5,80000d22 <push_off+0x3e>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d0a:	00001097          	auipc	ra,0x1
    80000d0e:	154080e7          	jalr	340(ra) # 80001e5e <mycpu>
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
    80000d26:	13c080e7          	jalr	316(ra) # 80001e5e <mycpu>
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
    80000d68:	0fa080e7          	jalr	250(ra) # 80001e5e <mycpu>
    80000d6c:	e888                	sd	a0,16(s1)
}
    80000d6e:	60e2                	ld	ra,24(sp)
    80000d70:	6442                	ld	s0,16(sp)
    80000d72:	64a2                	ld	s1,8(sp)
    80000d74:	6105                	addi	sp,sp,32
    80000d76:	8082                	ret
    panic("acquire");
    80000d78:	0000a517          	auipc	a0,0xa
    80000d7c:	2e850513          	addi	a0,a0,744 # 8000b060 <etext+0x60>
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
    80000d94:	0ce080e7          	jalr	206(ra) # 80001e5e <mycpu>
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
    80000dc4:	0000a517          	auipc	a0,0xa
    80000dc8:	2a450513          	addi	a0,a0,676 # 8000b068 <etext+0x68>
    80000dcc:	fffff097          	auipc	ra,0xfffff
    80000dd0:	792080e7          	jalr	1938(ra) # 8000055e <panic>
    panic("pop_off");
    80000dd4:	0000a517          	auipc	a0,0xa
    80000dd8:	2ac50513          	addi	a0,a0,684 # 8000b080 <etext+0x80>
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
    80000e1c:	0000a517          	auipc	a0,0xa
    80000e20:	26c50513          	addi	a0,a0,620 # 8000b088 <etext+0x88>
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

0000000080000fe6 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000fe6:	1141                	addi	sp,sp,-16
    80000fe8:	e406                	sd	ra,8(sp)
    80000fea:	e022                	sd	s0,0(sp)
    80000fec:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000fee:	00001097          	auipc	ra,0x1
    80000ff2:	e5c080e7          	jalr	-420(ra) # 80001e4a <cpuid>
    userinit();      // first user process
    net_init();
    socket_init();
    started = 1;
  } else {
    while(started == 0)
    80000ff6:	0000f717          	auipc	a4,0xf
    80000ffa:	d5270713          	addi	a4,a4,-686 # 8000fd48 <started>
  if(cpuid() == 0){
    80000ffe:	c139                	beqz	a0,80001044 <main+0x5e>
    while(started == 0)
    80001000:	431c                	lw	a5,0(a4)
    80001002:	2781                	sext.w	a5,a5
    80001004:	dff5                	beqz	a5,80001000 <main+0x1a>
      ;
    __sync_synchronize();
    80001006:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000100a:	00001097          	auipc	ra,0x1
    8000100e:	e40080e7          	jalr	-448(ra) # 80001e4a <cpuid>
    80001012:	85aa                	mv	a1,a0
    80001014:	0000a517          	auipc	a0,0xa
    80001018:	09450513          	addi	a0,a0,148 # 8000b0a8 <etext+0xa8>
    8000101c:	fffff097          	auipc	ra,0xfffff
    80001020:	58c080e7          	jalr	1420(ra) # 800005a8 <printf>
    kvminithart();    // turn on paging
    80001024:	00000097          	auipc	ra,0x0
    80001028:	0f0080e7          	jalr	240(ra) # 80001114 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000102c:	00002097          	auipc	ra,0x2
    80001030:	fe4080e7          	jalr	-28(ra) # 80003010 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001034:	00006097          	auipc	ra,0x6
    80001038:	cc2080e7          	jalr	-830(ra) # 80006cf6 <plicinithart>
  }

  scheduler();        
    8000103c:	00001097          	auipc	ra,0x1
    80001040:	544080e7          	jalr	1348(ra) # 80002580 <scheduler>
    consoleinit();
    80001044:	fffff097          	auipc	ra,0xfffff
    80001048:	430080e7          	jalr	1072(ra) # 80000474 <consoleinit>
    printfinit();
    8000104c:	fffff097          	auipc	ra,0xfffff
    80001050:	766080e7          	jalr	1894(ra) # 800007b2 <printfinit>
    printf("\n");
    80001054:	0000a517          	auipc	a0,0xa
    80001058:	fcc50513          	addi	a0,a0,-52 # 8000b020 <etext+0x20>
    8000105c:	fffff097          	auipc	ra,0xfffff
    80001060:	54c080e7          	jalr	1356(ra) # 800005a8 <printf>
    printf("xv6 kernel is booting\n");
    80001064:	0000a517          	auipc	a0,0xa
    80001068:	02c50513          	addi	a0,a0,44 # 8000b090 <etext+0x90>
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	53c080e7          	jalr	1340(ra) # 800005a8 <printf>
    printf("\n");
    80001074:	0000a517          	auipc	a0,0xa
    80001078:	fac50513          	addi	a0,a0,-84 # 8000b020 <etext+0x20>
    8000107c:	fffff097          	auipc	ra,0xfffff
    80001080:	52c080e7          	jalr	1324(ra) # 800005a8 <printf>
    kinit();         // physical page allocator
    80001084:	00000097          	auipc	ra,0x0
    80001088:	b52080e7          	jalr	-1198(ra) # 80000bd6 <kinit>
    kvminit();       // create kernel page table
    8000108c:	00000097          	auipc	ra,0x0
    80001090:	350080e7          	jalr	848(ra) # 800013dc <kvminit>
    kvminithart();   // turn on paging
    80001094:	00000097          	auipc	ra,0x0
    80001098:	080080e7          	jalr	128(ra) # 80001114 <kvminithart>
    procinit();      // process table
    8000109c:	00001097          	auipc	ra,0x1
    800010a0:	cf2080e7          	jalr	-782(ra) # 80001d8e <procinit>
    trapinit();      // trap vectors
    800010a4:	00002097          	auipc	ra,0x2
    800010a8:	f44080e7          	jalr	-188(ra) # 80002fe8 <trapinit>
    trapinithart();  // install kernel trap vector
    800010ac:	00002097          	auipc	ra,0x2
    800010b0:	f64080e7          	jalr	-156(ra) # 80003010 <trapinithart>
    plicinit();      // set up interrupt controller
    800010b4:	00006097          	auipc	ra,0x6
    800010b8:	c26080e7          	jalr	-986(ra) # 80006cda <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800010bc:	00006097          	auipc	ra,0x6
    800010c0:	c3a080e7          	jalr	-966(ra) # 80006cf6 <plicinithart>
    binit();         // buffer cache
    800010c4:	00003097          	auipc	ra,0x3
    800010c8:	c66080e7          	jalr	-922(ra) # 80003d2a <binit>
    iinit();         // inode table
    800010cc:	00003097          	auipc	ra,0x3
    800010d0:	2e6080e7          	jalr	742(ra) # 800043b2 <iinit>
    fileinit();      // file table
    800010d4:	00004097          	auipc	ra,0x4
    800010d8:	2d0080e7          	jalr	720(ra) # 800053a4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010dc:	00006097          	auipc	ra,0x6
    800010e0:	d22080e7          	jalr	-734(ra) # 80006dfe <virtio_disk_init>
    virtio_net_init(); // emulated NIC driver 
    800010e4:	00006097          	auipc	ra,0x6
    800010e8:	296080e7          	jalr	662(ra) # 8000737a <virtio_net_init>
    __sync_synchronize();
    800010ec:	0330000f          	fence	rw,rw
    userinit();      // first user process
    800010f0:	00001097          	auipc	ra,0x1
    800010f4:	07a080e7          	jalr	122(ra) # 8000216a <userinit>
    net_init();
    800010f8:	00007097          	auipc	ra,0x7
    800010fc:	06e080e7          	jalr	110(ra) # 80008166 <net_init>
    socket_init();
    80001100:	00008097          	auipc	ra,0x8
    80001104:	806080e7          	jalr	-2042(ra) # 80008906 <socket_init>
    started = 1;
    80001108:	4785                	li	a5,1
    8000110a:	0000f717          	auipc	a4,0xf
    8000110e:	c2f72f23          	sw	a5,-962(a4) # 8000fd48 <started>
    80001112:	b72d                	j	8000103c <main+0x56>

0000000080001114 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001114:	1141                	addi	sp,sp,-16
    80001116:	e406                	sd	ra,8(sp)
    80001118:	e022                	sd	s0,0(sp)
    8000111a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000111c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001120:	0000f797          	auipc	a5,0xf
    80001124:	c307b783          	ld	a5,-976(a5) # 8000fd50 <kernel_pagetable>
    80001128:	83b1                	srli	a5,a5,0xc
    8000112a:	577d                	li	a4,-1
    8000112c:	177e                	slli	a4,a4,0x3f
    8000112e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001130:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001134:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001138:	60a2                	ld	ra,8(sp)
    8000113a:	6402                	ld	s0,0(sp)
    8000113c:	0141                	addi	sp,sp,16
    8000113e:	8082                	ret

0000000080001140 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001140:	7139                	addi	sp,sp,-64
    80001142:	fc06                	sd	ra,56(sp)
    80001144:	f822                	sd	s0,48(sp)
    80001146:	f426                	sd	s1,40(sp)
    80001148:	f04a                	sd	s2,32(sp)
    8000114a:	ec4e                	sd	s3,24(sp)
    8000114c:	e852                	sd	s4,16(sp)
    8000114e:	e456                	sd	s5,8(sp)
    80001150:	e05a                	sd	s6,0(sp)
    80001152:	0080                	addi	s0,sp,64
    80001154:	84aa                	mv	s1,a0
    80001156:	89ae                	mv	s3,a1
    80001158:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    8000115a:	57fd                	li	a5,-1
    8000115c:	83e9                	srli	a5,a5,0x1a
    8000115e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001160:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80001162:	04b7e263          	bltu	a5,a1,800011a6 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80001166:	0149d933          	srl	s2,s3,s4
    8000116a:	1ff97913          	andi	s2,s2,511
    8000116e:	090e                	slli	s2,s2,0x3
    80001170:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001172:	00093483          	ld	s1,0(s2)
    80001176:	0014f793          	andi	a5,s1,1
    8000117a:	cf95                	beqz	a5,800011b6 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000117c:	80a9                	srli	s1,s1,0xa
    8000117e:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80001180:	3a5d                	addiw	s4,s4,-9
    80001182:	ff5a12e3          	bne	s4,s5,80001166 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80001186:	00c9d513          	srli	a0,s3,0xc
    8000118a:	1ff57513          	andi	a0,a0,511
    8000118e:	050e                	slli	a0,a0,0x3
    80001190:	9526                	add	a0,a0,s1
}
    80001192:	70e2                	ld	ra,56(sp)
    80001194:	7442                	ld	s0,48(sp)
    80001196:	74a2                	ld	s1,40(sp)
    80001198:	7902                	ld	s2,32(sp)
    8000119a:	69e2                	ld	s3,24(sp)
    8000119c:	6a42                	ld	s4,16(sp)
    8000119e:	6aa2                	ld	s5,8(sp)
    800011a0:	6b02                	ld	s6,0(sp)
    800011a2:	6121                	addi	sp,sp,64
    800011a4:	8082                	ret
    panic("walk");
    800011a6:	0000a517          	auipc	a0,0xa
    800011aa:	f1a50513          	addi	a0,a0,-230 # 8000b0c0 <etext+0xc0>
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	3b0080e7          	jalr	944(ra) # 8000055e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800011b6:	020b0663          	beqz	s6,800011e2 <walk+0xa2>
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	a58080e7          	jalr	-1448(ra) # 80000c12 <kalloc>
    800011c2:	84aa                	mv	s1,a0
    800011c4:	d579                	beqz	a0,80001192 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800011c6:	6605                	lui	a2,0x1
    800011c8:	4581                	li	a1,0
    800011ca:	00000097          	auipc	ra,0x0
    800011ce:	c62080e7          	jalr	-926(ra) # 80000e2c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800011d2:	00c4d793          	srli	a5,s1,0xc
    800011d6:	07aa                	slli	a5,a5,0xa
    800011d8:	0017e793          	ori	a5,a5,1
    800011dc:	00f93023          	sd	a5,0(s2)
    800011e0:	b745                	j	80001180 <walk+0x40>
        return 0;
    800011e2:	4501                	li	a0,0
    800011e4:	b77d                	j	80001192 <walk+0x52>

00000000800011e6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800011e6:	57fd                	li	a5,-1
    800011e8:	83e9                	srli	a5,a5,0x1a
    800011ea:	00b7f463          	bgeu	a5,a1,800011f2 <walkaddr+0xc>
    return 0;
    800011ee:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800011f0:	8082                	ret
{
    800011f2:	1141                	addi	sp,sp,-16
    800011f4:	e406                	sd	ra,8(sp)
    800011f6:	e022                	sd	s0,0(sp)
    800011f8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800011fa:	4601                	li	a2,0
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	f44080e7          	jalr	-188(ra) # 80001140 <walk>
  if(pte == 0)
    80001204:	c901                	beqz	a0,80001214 <walkaddr+0x2e>
  if((*pte & PTE_V) == 0)
    80001206:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001208:	0117f693          	andi	a3,a5,17
    8000120c:	4745                	li	a4,17
    return 0;
    8000120e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001210:	00e68663          	beq	a3,a4,8000121c <walkaddr+0x36>
}
    80001214:	60a2                	ld	ra,8(sp)
    80001216:	6402                	ld	s0,0(sp)
    80001218:	0141                	addi	sp,sp,16
    8000121a:	8082                	ret
  pa = PTE2PA(*pte);
    8000121c:	83a9                	srli	a5,a5,0xa
    8000121e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001222:	bfcd                	j	80001214 <walkaddr+0x2e>

0000000080001224 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001224:	715d                	addi	sp,sp,-80
    80001226:	e486                	sd	ra,72(sp)
    80001228:	e0a2                	sd	s0,64(sp)
    8000122a:	fc26                	sd	s1,56(sp)
    8000122c:	f84a                	sd	s2,48(sp)
    8000122e:	f44e                	sd	s3,40(sp)
    80001230:	f052                	sd	s4,32(sp)
    80001232:	ec56                	sd	s5,24(sp)
    80001234:	e85a                	sd	s6,16(sp)
    80001236:	e45e                	sd	s7,8(sp)
    80001238:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000123a:	ca21                	beqz	a2,8000128a <mappages+0x66>
    8000123c:	8a2a                	mv	s4,a0
    8000123e:	8aba                	mv	s5,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001240:	777d                	lui	a4,0xfffff
    80001242:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001246:	fff58913          	addi	s2,a1,-1
    8000124a:	9932                	add	s2,s2,a2
    8000124c:	00e97933          	and	s2,s2,a4
  a = PGROUNDDOWN(va);
    80001250:	84be                	mv	s1,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001252:	4b05                	li	s6,1
    80001254:	40f689b3          	sub	s3,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001258:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    8000125a:	865a                	mv	a2,s6
    8000125c:	85a6                	mv	a1,s1
    8000125e:	8552                	mv	a0,s4
    80001260:	00000097          	auipc	ra,0x0
    80001264:	ee0080e7          	jalr	-288(ra) # 80001140 <walk>
    80001268:	c129                	beqz	a0,800012aa <mappages+0x86>
    if(*pte & PTE_V)
    8000126a:	611c                	ld	a5,0(a0)
    8000126c:	8b85                	andi	a5,a5,1
    8000126e:	e795                	bnez	a5,8000129a <mappages+0x76>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001270:	013487b3          	add	a5,s1,s3
    80001274:	83b1                	srli	a5,a5,0xc
    80001276:	07aa                	slli	a5,a5,0xa
    80001278:	0157e7b3          	or	a5,a5,s5
    8000127c:	0017e793          	ori	a5,a5,1
    80001280:	e11c                	sd	a5,0(a0)
    if(a == last)
    80001282:	05248063          	beq	s1,s2,800012c2 <mappages+0x9e>
    a += PGSIZE;
    80001286:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001288:	bfc9                	j	8000125a <mappages+0x36>
    panic("mappages: size");
    8000128a:	0000a517          	auipc	a0,0xa
    8000128e:	e3e50513          	addi	a0,a0,-450 # 8000b0c8 <etext+0xc8>
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	2cc080e7          	jalr	716(ra) # 8000055e <panic>
      panic("mappages: remap");
    8000129a:	0000a517          	auipc	a0,0xa
    8000129e:	e3e50513          	addi	a0,a0,-450 # 8000b0d8 <etext+0xd8>
    800012a2:	fffff097          	auipc	ra,0xfffff
    800012a6:	2bc080e7          	jalr	700(ra) # 8000055e <panic>
      return -1;
    800012aa:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800012ac:	60a6                	ld	ra,72(sp)
    800012ae:	6406                	ld	s0,64(sp)
    800012b0:	74e2                	ld	s1,56(sp)
    800012b2:	7942                	ld	s2,48(sp)
    800012b4:	79a2                	ld	s3,40(sp)
    800012b6:	7a02                	ld	s4,32(sp)
    800012b8:	6ae2                	ld	s5,24(sp)
    800012ba:	6b42                	ld	s6,16(sp)
    800012bc:	6ba2                	ld	s7,8(sp)
    800012be:	6161                	addi	sp,sp,80
    800012c0:	8082                	ret
  return 0;
    800012c2:	4501                	li	a0,0
    800012c4:	b7e5                	j	800012ac <mappages+0x88>

00000000800012c6 <kvmmap>:
{
    800012c6:	1141                	addi	sp,sp,-16
    800012c8:	e406                	sd	ra,8(sp)
    800012ca:	e022                	sd	s0,0(sp)
    800012cc:	0800                	addi	s0,sp,16
    800012ce:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800012d0:	86b2                	mv	a3,a2
    800012d2:	863e                	mv	a2,a5
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	f50080e7          	jalr	-176(ra) # 80001224 <mappages>
    800012dc:	e509                	bnez	a0,800012e6 <kvmmap+0x20>
}
    800012de:	60a2                	ld	ra,8(sp)
    800012e0:	6402                	ld	s0,0(sp)
    800012e2:	0141                	addi	sp,sp,16
    800012e4:	8082                	ret
    panic("kvmmap");
    800012e6:	0000a517          	auipc	a0,0xa
    800012ea:	e0250513          	addi	a0,a0,-510 # 8000b0e8 <etext+0xe8>
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	270080e7          	jalr	624(ra) # 8000055e <panic>

00000000800012f6 <kvmmake>:
{
    800012f6:	1101                	addi	sp,sp,-32
    800012f8:	ec06                	sd	ra,24(sp)
    800012fa:	e822                	sd	s0,16(sp)
    800012fc:	e426                	sd	s1,8(sp)
    800012fe:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001300:	00000097          	auipc	ra,0x0
    80001304:	912080e7          	jalr	-1774(ra) # 80000c12 <kalloc>
    80001308:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000130a:	6605                	lui	a2,0x1
    8000130c:	4581                	li	a1,0
    8000130e:	00000097          	auipc	ra,0x0
    80001312:	b1e080e7          	jalr	-1250(ra) # 80000e2c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001316:	4719                	li	a4,6
    80001318:	6685                	lui	a3,0x1
    8000131a:	10000637          	lui	a2,0x10000
    8000131e:	85b2                	mv	a1,a2
    80001320:	8526                	mv	a0,s1
    80001322:	00000097          	auipc	ra,0x0
    80001326:	fa4080e7          	jalr	-92(ra) # 800012c6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000132a:	4719                	li	a4,6
    8000132c:	6685                	lui	a3,0x1
    8000132e:	10001637          	lui	a2,0x10001
    80001332:	85b2                	mv	a1,a2
    80001334:	8526                	mv	a0,s1
    80001336:	00000097          	auipc	ra,0x0
    8000133a:	f90080e7          	jalr	-112(ra) # 800012c6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO1, VIRTIO1, PGSIZE, PTE_R | PTE_W);
    8000133e:	4719                	li	a4,6
    80001340:	6685                	lui	a3,0x1
    80001342:	10002637          	lui	a2,0x10002
    80001346:	85b2                	mv	a1,a2
    80001348:	8526                	mv	a0,s1
    8000134a:	00000097          	auipc	ra,0x0
    8000134e:	f7c080e7          	jalr	-132(ra) # 800012c6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001352:	4719                	li	a4,6
    80001354:	004006b7          	lui	a3,0x400
    80001358:	0c000637          	lui	a2,0xc000
    8000135c:	85b2                	mv	a1,a2
    8000135e:	8526                	mv	a0,s1
    80001360:	00000097          	auipc	ra,0x0
    80001364:	f66080e7          	jalr	-154(ra) # 800012c6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001368:	4729                	li	a4,10
    8000136a:	8000a697          	auipc	a3,0x8000a
    8000136e:	c9668693          	addi	a3,a3,-874 # b000 <_entry-0x7fff5000>
    80001372:	4605                	li	a2,1
    80001374:	067e                	slli	a2,a2,0x1f
    80001376:	85b2                	mv	a1,a2
    80001378:	8526                	mv	a0,s1
    8000137a:	00000097          	auipc	ra,0x0
    8000137e:	f4c080e7          	jalr	-180(ra) # 800012c6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001382:	4719                	li	a4,6
    80001384:	0000a697          	auipc	a3,0xa
    80001388:	c7c68693          	addi	a3,a3,-900 # 8000b000 <etext>
    8000138c:	47c5                	li	a5,17
    8000138e:	07ee                	slli	a5,a5,0x1b
    80001390:	40d786b3          	sub	a3,a5,a3
    80001394:	0000a617          	auipc	a2,0xa
    80001398:	c6c60613          	addi	a2,a2,-916 # 8000b000 <etext>
    8000139c:	85b2                	mv	a1,a2
    8000139e:	8526                	mv	a0,s1
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	f26080e7          	jalr	-218(ra) # 800012c6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800013a8:	4729                	li	a4,10
    800013aa:	6685                	lui	a3,0x1
    800013ac:	00009617          	auipc	a2,0x9
    800013b0:	c5460613          	addi	a2,a2,-940 # 8000a000 <_trampoline>
    800013b4:	040005b7          	lui	a1,0x4000
    800013b8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800013ba:	05b2                	slli	a1,a1,0xc
    800013bc:	8526                	mv	a0,s1
    800013be:	00000097          	auipc	ra,0x0
    800013c2:	f08080e7          	jalr	-248(ra) # 800012c6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800013c6:	8526                	mv	a0,s1
    800013c8:	00001097          	auipc	ra,0x1
    800013cc:	91c080e7          	jalr	-1764(ra) # 80001ce4 <proc_mapstacks>
}
    800013d0:	8526                	mv	a0,s1
    800013d2:	60e2                	ld	ra,24(sp)
    800013d4:	6442                	ld	s0,16(sp)
    800013d6:	64a2                	ld	s1,8(sp)
    800013d8:	6105                	addi	sp,sp,32
    800013da:	8082                	ret

00000000800013dc <kvminit>:
{
    800013dc:	1141                	addi	sp,sp,-16
    800013de:	e406                	sd	ra,8(sp)
    800013e0:	e022                	sd	s0,0(sp)
    800013e2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800013e4:	00000097          	auipc	ra,0x0
    800013e8:	f12080e7          	jalr	-238(ra) # 800012f6 <kvmmake>
    800013ec:	0000f797          	auipc	a5,0xf
    800013f0:	96a7b223          	sd	a0,-1692(a5) # 8000fd50 <kernel_pagetable>
}
    800013f4:	60a2                	ld	ra,8(sp)
    800013f6:	6402                	ld	s0,0(sp)
    800013f8:	0141                	addi	sp,sp,16
    800013fa:	8082                	ret

00000000800013fc <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800013fc:	715d                	addi	sp,sp,-80
    800013fe:	e486                	sd	ra,72(sp)
    80001400:	e0a2                	sd	s0,64(sp)
    80001402:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001404:	03459793          	slli	a5,a1,0x34
    80001408:	e39d                	bnez	a5,8000142e <uvmunmap+0x32>
    8000140a:	f84a                	sd	s2,48(sp)
    8000140c:	f44e                	sd	s3,40(sp)
    8000140e:	f052                	sd	s4,32(sp)
    80001410:	ec56                	sd	s5,24(sp)
    80001412:	e85a                	sd	s6,16(sp)
    80001414:	e45e                	sd	s7,8(sp)
    80001416:	8a2a                	mv	s4,a0
    80001418:	892e                	mv	s2,a1
    8000141a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000141c:	0632                	slli	a2,a2,0xc
    8000141e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001422:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001424:	6b05                	lui	s6,0x1
    80001426:	0935fb63          	bgeu	a1,s3,800014bc <uvmunmap+0xc0>
    8000142a:	fc26                	sd	s1,56(sp)
    8000142c:	a8a9                	j	80001486 <uvmunmap+0x8a>
    8000142e:	fc26                	sd	s1,56(sp)
    80001430:	f84a                	sd	s2,48(sp)
    80001432:	f44e                	sd	s3,40(sp)
    80001434:	f052                	sd	s4,32(sp)
    80001436:	ec56                	sd	s5,24(sp)
    80001438:	e85a                	sd	s6,16(sp)
    8000143a:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000143c:	0000a517          	auipc	a0,0xa
    80001440:	cb450513          	addi	a0,a0,-844 # 8000b0f0 <etext+0xf0>
    80001444:	fffff097          	auipc	ra,0xfffff
    80001448:	11a080e7          	jalr	282(ra) # 8000055e <panic>
      panic("uvmunmap: walk");
    8000144c:	0000a517          	auipc	a0,0xa
    80001450:	cbc50513          	addi	a0,a0,-836 # 8000b108 <etext+0x108>
    80001454:	fffff097          	auipc	ra,0xfffff
    80001458:	10a080e7          	jalr	266(ra) # 8000055e <panic>
      panic("uvmunmap: not mapped");
    8000145c:	0000a517          	auipc	a0,0xa
    80001460:	cbc50513          	addi	a0,a0,-836 # 8000b118 <etext+0x118>
    80001464:	fffff097          	auipc	ra,0xfffff
    80001468:	0fa080e7          	jalr	250(ra) # 8000055e <panic>
      panic("uvmunmap: not a leaf");
    8000146c:	0000a517          	auipc	a0,0xa
    80001470:	cc450513          	addi	a0,a0,-828 # 8000b130 <etext+0x130>
    80001474:	fffff097          	auipc	ra,0xfffff
    80001478:	0ea080e7          	jalr	234(ra) # 8000055e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000147c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001480:	995a                	add	s2,s2,s6
    80001482:	03397c63          	bgeu	s2,s3,800014ba <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001486:	4601                	li	a2,0
    80001488:	85ca                	mv	a1,s2
    8000148a:	8552                	mv	a0,s4
    8000148c:	00000097          	auipc	ra,0x0
    80001490:	cb4080e7          	jalr	-844(ra) # 80001140 <walk>
    80001494:	84aa                	mv	s1,a0
    80001496:	d95d                	beqz	a0,8000144c <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001498:	6108                	ld	a0,0(a0)
    8000149a:	00157793          	andi	a5,a0,1
    8000149e:	dfdd                	beqz	a5,8000145c <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800014a0:	3ff57793          	andi	a5,a0,1023
    800014a4:	fd7784e3          	beq	a5,s7,8000146c <uvmunmap+0x70>
    if(do_free){
    800014a8:	fc0a8ae3          	beqz	s5,8000147c <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800014ac:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800014ae:	0532                	slli	a0,a0,0xc
    800014b0:	fffff097          	auipc	ra,0xfffff
    800014b4:	5f4080e7          	jalr	1524(ra) # 80000aa4 <kfree>
    800014b8:	b7d1                	j	8000147c <uvmunmap+0x80>
    800014ba:	74e2                	ld	s1,56(sp)
    800014bc:	7942                	ld	s2,48(sp)
    800014be:	79a2                	ld	s3,40(sp)
    800014c0:	7a02                	ld	s4,32(sp)
    800014c2:	6ae2                	ld	s5,24(sp)
    800014c4:	6b42                	ld	s6,16(sp)
    800014c6:	6ba2                	ld	s7,8(sp)
  }
}
    800014c8:	60a6                	ld	ra,72(sp)
    800014ca:	6406                	ld	s0,64(sp)
    800014cc:	6161                	addi	sp,sp,80
    800014ce:	8082                	ret

00000000800014d0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800014d0:	1101                	addi	sp,sp,-32
    800014d2:	ec06                	sd	ra,24(sp)
    800014d4:	e822                	sd	s0,16(sp)
    800014d6:	e426                	sd	s1,8(sp)
    800014d8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800014da:	fffff097          	auipc	ra,0xfffff
    800014de:	738080e7          	jalr	1848(ra) # 80000c12 <kalloc>
    800014e2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800014e4:	c519                	beqz	a0,800014f2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800014e6:	6605                	lui	a2,0x1
    800014e8:	4581                	li	a1,0
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	942080e7          	jalr	-1726(ra) # 80000e2c <memset>
  return pagetable;
}
    800014f2:	8526                	mv	a0,s1
    800014f4:	60e2                	ld	ra,24(sp)
    800014f6:	6442                	ld	s0,16(sp)
    800014f8:	64a2                	ld	s1,8(sp)
    800014fa:	6105                	addi	sp,sp,32
    800014fc:	8082                	ret

00000000800014fe <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800014fe:	7179                	addi	sp,sp,-48
    80001500:	f406                	sd	ra,40(sp)
    80001502:	f022                	sd	s0,32(sp)
    80001504:	ec26                	sd	s1,24(sp)
    80001506:	e84a                	sd	s2,16(sp)
    80001508:	e44e                	sd	s3,8(sp)
    8000150a:	e052                	sd	s4,0(sp)
    8000150c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000150e:	6785                	lui	a5,0x1
    80001510:	04f67863          	bgeu	a2,a5,80001560 <uvmfirst+0x62>
    80001514:	89aa                	mv	s3,a0
    80001516:	8a2e                	mv	s4,a1
    80001518:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000151a:	fffff097          	auipc	ra,0xfffff
    8000151e:	6f8080e7          	jalr	1784(ra) # 80000c12 <kalloc>
    80001522:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001524:	6605                	lui	a2,0x1
    80001526:	4581                	li	a1,0
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	904080e7          	jalr	-1788(ra) # 80000e2c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001530:	4779                	li	a4,30
    80001532:	86ca                	mv	a3,s2
    80001534:	6605                	lui	a2,0x1
    80001536:	4581                	li	a1,0
    80001538:	854e                	mv	a0,s3
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	cea080e7          	jalr	-790(ra) # 80001224 <mappages>
  memmove(mem, src, sz);
    80001542:	8626                	mv	a2,s1
    80001544:	85d2                	mv	a1,s4
    80001546:	854a                	mv	a0,s2
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	944080e7          	jalr	-1724(ra) # 80000e8c <memmove>
}
    80001550:	70a2                	ld	ra,40(sp)
    80001552:	7402                	ld	s0,32(sp)
    80001554:	64e2                	ld	s1,24(sp)
    80001556:	6942                	ld	s2,16(sp)
    80001558:	69a2                	ld	s3,8(sp)
    8000155a:	6a02                	ld	s4,0(sp)
    8000155c:	6145                	addi	sp,sp,48
    8000155e:	8082                	ret
    panic("uvmfirst: more than a page");
    80001560:	0000a517          	auipc	a0,0xa
    80001564:	be850513          	addi	a0,a0,-1048 # 8000b148 <etext+0x148>
    80001568:	fffff097          	auipc	ra,0xfffff
    8000156c:	ff6080e7          	jalr	-10(ra) # 8000055e <panic>

0000000080001570 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
  uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001570:	1101                	addi	sp,sp,-32
    80001572:	ec06                	sd	ra,24(sp)
    80001574:	e822                	sd	s0,16(sp)
    80001576:	e426                	sd	s1,8(sp)
    80001578:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000157a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000157c:	00b67d63          	bgeu	a2,a1,80001596 <uvmdealloc+0x26>
    80001580:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001582:	6785                	lui	a5,0x1
    80001584:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001586:	00f60733          	add	a4,a2,a5
    8000158a:	76fd                	lui	a3,0xfffff
    8000158c:	8f75                	and	a4,a4,a3
    8000158e:	97ae                	add	a5,a5,a1
    80001590:	8ff5                	and	a5,a5,a3
    80001592:	00f76863          	bltu	a4,a5,800015a2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001596:	8526                	mv	a0,s1
    80001598:	60e2                	ld	ra,24(sp)
    8000159a:	6442                	ld	s0,16(sp)
    8000159c:	64a2                	ld	s1,8(sp)
    8000159e:	6105                	addi	sp,sp,32
    800015a0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800015a2:	8f99                	sub	a5,a5,a4
    800015a4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800015a6:	4685                	li	a3,1
    800015a8:	0007861b          	sext.w	a2,a5
    800015ac:	85ba                	mv	a1,a4
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	e4e080e7          	jalr	-434(ra) # 800013fc <uvmunmap>
    800015b6:	b7c5                	j	80001596 <uvmdealloc+0x26>

00000000800015b8 <uvmalloc>:
  if(newsz < oldsz)
    800015b8:	0ab66d63          	bltu	a2,a1,80001672 <uvmalloc+0xba>
{
    800015bc:	715d                	addi	sp,sp,-80
    800015be:	e486                	sd	ra,72(sp)
    800015c0:	e0a2                	sd	s0,64(sp)
    800015c2:	f84a                	sd	s2,48(sp)
    800015c4:	f052                	sd	s4,32(sp)
    800015c6:	ec56                	sd	s5,24(sp)
    800015c8:	e45e                	sd	s7,8(sp)
    800015ca:	0880                	addi	s0,sp,80
    800015cc:	8aaa                	mv	s5,a0
    800015ce:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800015d0:	6785                	lui	a5,0x1
    800015d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015d4:	95be                	add	a1,a1,a5
    800015d6:	77fd                	lui	a5,0xfffff
    800015d8:	00f5f933          	and	s2,a1,a5
    800015dc:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015de:	08c97c63          	bgeu	s2,a2,80001676 <uvmalloc+0xbe>
    800015e2:	fc26                	sd	s1,56(sp)
    800015e4:	f44e                	sd	s3,40(sp)
    800015e6:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    800015e8:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015ea:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800015ee:	fffff097          	auipc	ra,0xfffff
    800015f2:	624080e7          	jalr	1572(ra) # 80000c12 <kalloc>
    800015f6:	84aa                	mv	s1,a0
    if(mem == 0){
    800015f8:	c90d                	beqz	a0,8000162a <uvmalloc+0x72>
    memset(mem, 0, PGSIZE);
    800015fa:	864e                	mv	a2,s3
    800015fc:	4581                	li	a1,0
    800015fe:	00000097          	auipc	ra,0x0
    80001602:	82e080e7          	jalr	-2002(ra) # 80000e2c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001606:	875a                	mv	a4,s6
    80001608:	86a6                	mv	a3,s1
    8000160a:	864e                	mv	a2,s3
    8000160c:	85ca                	mv	a1,s2
    8000160e:	8556                	mv	a0,s5
    80001610:	00000097          	auipc	ra,0x0
    80001614:	c14080e7          	jalr	-1004(ra) # 80001224 <mappages>
    80001618:	ed05                	bnez	a0,80001650 <uvmalloc+0x98>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000161a:	994e                	add	s2,s2,s3
    8000161c:	fd4969e3          	bltu	s2,s4,800015ee <uvmalloc+0x36>
  return newsz;
    80001620:	8552                	mv	a0,s4
    80001622:	74e2                	ld	s1,56(sp)
    80001624:	79a2                	ld	s3,40(sp)
    80001626:	6b42                	ld	s6,16(sp)
    80001628:	a821                	j	80001640 <uvmalloc+0x88>
      uvmdealloc(pagetable, a, oldsz);
    8000162a:	865e                	mv	a2,s7
    8000162c:	85ca                	mv	a1,s2
    8000162e:	8556                	mv	a0,s5
    80001630:	00000097          	auipc	ra,0x0
    80001634:	f40080e7          	jalr	-192(ra) # 80001570 <uvmdealloc>
      return 0;
    80001638:	4501                	li	a0,0
    8000163a:	74e2                	ld	s1,56(sp)
    8000163c:	79a2                	ld	s3,40(sp)
    8000163e:	6b42                	ld	s6,16(sp)
}
    80001640:	60a6                	ld	ra,72(sp)
    80001642:	6406                	ld	s0,64(sp)
    80001644:	7942                	ld	s2,48(sp)
    80001646:	7a02                	ld	s4,32(sp)
    80001648:	6ae2                	ld	s5,24(sp)
    8000164a:	6ba2                	ld	s7,8(sp)
    8000164c:	6161                	addi	sp,sp,80
    8000164e:	8082                	ret
      kfree(mem);
    80001650:	8526                	mv	a0,s1
    80001652:	fffff097          	auipc	ra,0xfffff
    80001656:	452080e7          	jalr	1106(ra) # 80000aa4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000165a:	865e                	mv	a2,s7
    8000165c:	85ca                	mv	a1,s2
    8000165e:	8556                	mv	a0,s5
    80001660:	00000097          	auipc	ra,0x0
    80001664:	f10080e7          	jalr	-240(ra) # 80001570 <uvmdealloc>
      return 0;
    80001668:	4501                	li	a0,0
    8000166a:	74e2                	ld	s1,56(sp)
    8000166c:	79a2                	ld	s3,40(sp)
    8000166e:	6b42                	ld	s6,16(sp)
    80001670:	bfc1                	j	80001640 <uvmalloc+0x88>
    return oldsz;
    80001672:	852e                	mv	a0,a1
}
    80001674:	8082                	ret
  return newsz;
    80001676:	8532                	mv	a0,a2
    80001678:	b7e1                	j	80001640 <uvmalloc+0x88>

000000008000167a <uvmthreaded_alloc>:
uvmthreaded_alloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz, uint64 xperm) {
    8000167a:	7119                	addi	sp,sp,-128
    8000167c:	fc86                	sd	ra,120(sp)
    8000167e:	f8a2                	sd	s0,112(sp)
    80001680:	0100                	addi	s0,sp,128
    80001682:	f8a43423          	sd	a0,-120(s0)
  if(newsz < oldsz)
    80001686:	16b66163          	bltu	a2,a1,800017e8 <uvmthreaded_alloc+0x16e>
    8000168a:	e4d6                	sd	s5,72(sp)
    8000168c:	f466                	sd	s9,40(sp)
    8000168e:	ec6e                	sd	s11,24(sp)
    80001690:	8ab2                	mv	s5,a2
    80001692:	8db6                	mv	s11,a3
  oldsz = PGROUNDUP(oldsz);
    80001694:	6785                	lui	a5,0x1
    80001696:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001698:	95be                	add	a1,a1,a5
    8000169a:	77fd                	lui	a5,0xfffff
    8000169c:	00f5fcb3          	and	s9,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800016a0:	14ccf663          	bgeu	s9,a2,800017ec <uvmthreaded_alloc+0x172>
    800016a4:	f4a6                	sd	s1,104(sp)
    800016a6:	f0ca                	sd	s2,96(sp)
    800016a8:	ecce                	sd	s3,88(sp)
    800016aa:	e8d2                	sd	s4,80(sp)
    800016ac:	e0da                	sd	s6,64(sp)
    800016ae:	fc5e                	sd	s7,56(sp)
    800016b0:	f862                	sd	s8,48(sp)
    800016b2:	f06a                	sd	s10,32(sp)
  struct proc *p = thread_proc->parent;
    800016b4:	03853d03          	ld	s10,56(a0)
  for(a = oldsz; a < newsz; a += PGSIZE){
    800016b8:	8b66                	mv	s6,s9
    memset(mem, 0, PGSIZE);
    800016ba:	6c05                	lui	s8,0x1
    800016bc:	370d0a13          	addi	s4,s10,880
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800016c0:	0126eb93          	ori	s7,a3,18
    800016c4:	2b81                	sext.w	s7,s7
    mem = kalloc();
    800016c6:	fffff097          	auipc	ra,0xfffff
    800016ca:	54c080e7          	jalr	1356(ra) # 80000c12 <kalloc>
    800016ce:	89aa                	mv	s3,a0
    if(mem == 0){
    800016d0:	c911                	beqz	a0,800016e4 <uvmthreaded_alloc+0x6a>
    memset(mem, 0, PGSIZE);
    800016d2:	8662                	mv	a2,s8
    800016d4:	4581                	li	a1,0
    800016d6:	fffff097          	auipc	ra,0xfffff
    800016da:	756080e7          	jalr	1878(ra) # 80000e2c <memset>
    for (int i = 0; i < MAX_THREADS; i++) {
    800016de:	170d0493          	addi	s1,s10,368
    800016e2:	a0bd                	j	80001750 <uvmthreaded_alloc+0xd6>
      uvmdealloc(thread_proc->pagetable, a, oldsz);
    800016e4:	8666                	mv	a2,s9
    800016e6:	85da                	mv	a1,s6
    800016e8:	f8843783          	ld	a5,-120(s0)
    800016ec:	6ba8                	ld	a0,80(a5)
    800016ee:	00000097          	auipc	ra,0x0
    800016f2:	e82080e7          	jalr	-382(ra) # 80001570 <uvmdealloc>
      return 0;
    800016f6:	4501                	li	a0,0
    800016f8:	74a6                	ld	s1,104(sp)
    800016fa:	7906                	ld	s2,96(sp)
    800016fc:	69e6                	ld	s3,88(sp)
    800016fe:	6a46                	ld	s4,80(sp)
    80001700:	6aa6                	ld	s5,72(sp)
    80001702:	6b06                	ld	s6,64(sp)
    80001704:	7be2                	ld	s7,56(sp)
    80001706:	7c42                	ld	s8,48(sp)
    80001708:	7ca2                	ld	s9,40(sp)
    8000170a:	7d02                	ld	s10,32(sp)
    8000170c:	6de2                	ld	s11,24(sp)
    8000170e:	a815                	j	80001742 <uvmthreaded_alloc+0xc8>
        kfree(mem);
    80001710:	854e                	mv	a0,s3
    80001712:	fffff097          	auipc	ra,0xfffff
    80001716:	392080e7          	jalr	914(ra) # 80000aa4 <kfree>
        uvmdealloc(infant->pagetable, a, oldsz);
    8000171a:	8666                	mv	a2,s9
    8000171c:	85da                	mv	a1,s6
    8000171e:	05093503          	ld	a0,80(s2)
    80001722:	00000097          	auipc	ra,0x0
    80001726:	e4e080e7          	jalr	-434(ra) # 80001570 <uvmdealloc>
        return 0;
    8000172a:	4501                	li	a0,0
    8000172c:	74a6                	ld	s1,104(sp)
    8000172e:	7906                	ld	s2,96(sp)
    80001730:	69e6                	ld	s3,88(sp)
    80001732:	6a46                	ld	s4,80(sp)
    80001734:	6aa6                	ld	s5,72(sp)
    80001736:	6b06                	ld	s6,64(sp)
    80001738:	7be2                	ld	s7,56(sp)
    8000173a:	7c42                	ld	s8,48(sp)
    8000173c:	7ca2                	ld	s9,40(sp)
    8000173e:	7d02                	ld	s10,32(sp)
    80001740:	6de2                	ld	s11,24(sp)
}
    80001742:	70e6                	ld	ra,120(sp)
    80001744:	7446                	ld	s0,112(sp)
    80001746:	6109                	addi	sp,sp,128
    80001748:	8082                	ret
    for (int i = 0; i < MAX_THREADS; i++) {
    8000174a:	04a1                	addi	s1,s1,8
    8000174c:	03448463          	beq	s1,s4,80001774 <uvmthreaded_alloc+0xfa>
      struct proc *infant = p->infant_threads[i];
    80001750:	0004b903          	ld	s2,0(s1)
      if (infant == 0)
    80001754:	fe090be3          	beqz	s2,8000174a <uvmthreaded_alloc+0xd0>
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001758:	875e                	mv	a4,s7
    8000175a:	86ce                	mv	a3,s3
    8000175c:	8662                	mv	a2,s8
    8000175e:	85da                	mv	a1,s6
    80001760:	05093503          	ld	a0,80(s2)
    80001764:	00000097          	auipc	ra,0x0
    80001768:	ac0080e7          	jalr	-1344(ra) # 80001224 <mappages>
    8000176c:	f155                	bnez	a0,80001710 <uvmthreaded_alloc+0x96>
      infant->sz = newsz;
    8000176e:	05593423          	sd	s5,72(s2)
    80001772:	bfe1                	j	8000174a <uvmthreaded_alloc+0xd0>
    if(mappages(p->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001774:	012de713          	ori	a4,s11,18
    80001778:	2701                	sext.w	a4,a4
    8000177a:	86ce                	mv	a3,s3
    8000177c:	6605                	lui	a2,0x1
    8000177e:	85da                	mv	a1,s6
    80001780:	050d3503          	ld	a0,80(s10)
    80001784:	00000097          	auipc	ra,0x0
    80001788:	aa0080e7          	jalr	-1376(ra) # 80001224 <mappages>
    8000178c:	e505                	bnez	a0,800017b4 <uvmthreaded_alloc+0x13a>
    p->sz = newsz;
    8000178e:	055d3423          	sd	s5,72(s10)
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001792:	6785                	lui	a5,0x1
    80001794:	9b3e                	add	s6,s6,a5
    80001796:	f35b68e3          	bltu	s6,s5,800016c6 <uvmthreaded_alloc+0x4c>
  return newsz;
    8000179a:	8556                	mv	a0,s5
    8000179c:	74a6                	ld	s1,104(sp)
    8000179e:	7906                	ld	s2,96(sp)
    800017a0:	69e6                	ld	s3,88(sp)
    800017a2:	6a46                	ld	s4,80(sp)
    800017a4:	6aa6                	ld	s5,72(sp)
    800017a6:	6b06                	ld	s6,64(sp)
    800017a8:	7be2                	ld	s7,56(sp)
    800017aa:	7c42                	ld	s8,48(sp)
    800017ac:	7ca2                	ld	s9,40(sp)
    800017ae:	7d02                	ld	s10,32(sp)
    800017b0:	6de2                	ld	s11,24(sp)
    800017b2:	bf41                	j	80001742 <uvmthreaded_alloc+0xc8>
      kfree(mem);
    800017b4:	854e                	mv	a0,s3
    800017b6:	fffff097          	auipc	ra,0xfffff
    800017ba:	2ee080e7          	jalr	750(ra) # 80000aa4 <kfree>
      uvmdealloc(p->pagetable, a, oldsz);
    800017be:	8666                	mv	a2,s9
    800017c0:	85da                	mv	a1,s6
    800017c2:	050d3503          	ld	a0,80(s10)
    800017c6:	00000097          	auipc	ra,0x0
    800017ca:	daa080e7          	jalr	-598(ra) # 80001570 <uvmdealloc>
      return 0;
    800017ce:	4501                	li	a0,0
    800017d0:	74a6                	ld	s1,104(sp)
    800017d2:	7906                	ld	s2,96(sp)
    800017d4:	69e6                	ld	s3,88(sp)
    800017d6:	6a46                	ld	s4,80(sp)
    800017d8:	6aa6                	ld	s5,72(sp)
    800017da:	6b06                	ld	s6,64(sp)
    800017dc:	7be2                	ld	s7,56(sp)
    800017de:	7c42                	ld	s8,48(sp)
    800017e0:	7ca2                	ld	s9,40(sp)
    800017e2:	7d02                	ld	s10,32(sp)
    800017e4:	6de2                	ld	s11,24(sp)
    800017e6:	bfb1                	j	80001742 <uvmthreaded_alloc+0xc8>
    return oldsz;
    800017e8:	852e                	mv	a0,a1
    800017ea:	bfa1                	j	80001742 <uvmthreaded_alloc+0xc8>
  return newsz;
    800017ec:	8532                	mv	a0,a2
    800017ee:	6aa6                	ld	s5,72(sp)
    800017f0:	7ca2                	ld	s9,40(sp)
    800017f2:	6de2                	ld	s11,24(sp)
    800017f4:	b7b9                	j	80001742 <uvmthreaded_alloc+0xc8>

00000000800017f6 <uvmthreaded_dealloc>:

uint64
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
  struct proc *p = thread_proc->parent;

  if(newsz >= oldsz)
    800017f6:	0ab67163          	bgeu	a2,a1,80001898 <uvmthreaded_dealloc+0xa2>
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
    800017fa:	715d                	addi	sp,sp,-80
    800017fc:	e486                	sd	ra,72(sp)
    800017fe:	e0a2                	sd	s0,64(sp)
    80001800:	fc26                	sd	s1,56(sp)
    80001802:	f84a                	sd	s2,48(sp)
    80001804:	f44e                	sd	s3,40(sp)
    80001806:	f052                	sd	s4,32(sp)
    80001808:	ec56                	sd	s5,24(sp)
    8000180a:	e85a                	sd	s6,16(sp)
    8000180c:	e45e                	sd	s7,8(sp)
    8000180e:	e062                	sd	s8,0(sp)
    80001810:	0880                	addi	s0,sp,80
    80001812:	8ab2                	mv	s5,a2
  struct proc *p = thread_proc->parent;
    80001814:	03853c03          	ld	s8,56(a0)
    return oldsz;

  int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001818:	6785                	lui	a5,0x1
    8000181a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000181c:	95be                	add	a1,a1,a5
    8000181e:	777d                	lui	a4,0xfffff
    80001820:	00e5fb33          	and	s6,a1,a4
    80001824:	97b2                	add	a5,a5,a2
    80001826:	00e7f9b3          	and	s3,a5,a4
    8000182a:	413b0bb3          	sub	s7,s6,s3
    8000182e:	00cbdb93          	srli	s7,s7,0xc
    80001832:	2b81                	sext.w	s7,s7

  for (int i = 0; i < MAX_THREADS; i++) {
    80001834:	170c0493          	addi	s1,s8,368 # 1170 <_entry-0x7fffee90>
    80001838:	370c0a13          	addi	s4,s8,880
    8000183c:	a031                	j	80001848 <uvmthreaded_dealloc+0x52>
      continue;

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    }
    infant->sz = newsz;
    8000183e:	05593423          	sd	s5,72(s2)
  for (int i = 0; i < MAX_THREADS; i++) {
    80001842:	04a1                	addi	s1,s1,8
    80001844:	03448263          	beq	s1,s4,80001868 <uvmthreaded_dealloc+0x72>
    struct proc *infant = p->infant_threads[i];
    80001848:	0004b903          	ld	s2,0(s1)
    if (infant == 0)
    8000184c:	fe090be3          	beqz	s2,80001842 <uvmthreaded_dealloc+0x4c>
    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
    80001850:	ff69f7e3          	bgeu	s3,s6,8000183e <uvmthreaded_dealloc+0x48>
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    80001854:	4681                	li	a3,0
    80001856:	865e                	mv	a2,s7
    80001858:	85ce                	mv	a1,s3
    8000185a:	05093503          	ld	a0,80(s2)
    8000185e:	00000097          	auipc	ra,0x0
    80001862:	b9e080e7          	jalr	-1122(ra) # 800013fc <uvmunmap>
    80001866:	bfe1                	j	8000183e <uvmthreaded_dealloc+0x48>
  }

  uvmunmap(p->pagetable, PGROUNDUP(newsz), npages, 1); //unmap with freeing
    80001868:	4685                	li	a3,1
    8000186a:	865e                	mv	a2,s7
    8000186c:	85ce                	mv	a1,s3
    8000186e:	050c3503          	ld	a0,80(s8)
    80001872:	00000097          	auipc	ra,0x0
    80001876:	b8a080e7          	jalr	-1142(ra) # 800013fc <uvmunmap>
  p->sz = newsz;
    8000187a:	055c3423          	sd	s5,72(s8)

  return newsz;
    8000187e:	8556                	mv	a0,s5
}
    80001880:	60a6                	ld	ra,72(sp)
    80001882:	6406                	ld	s0,64(sp)
    80001884:	74e2                	ld	s1,56(sp)
    80001886:	7942                	ld	s2,48(sp)
    80001888:	79a2                	ld	s3,40(sp)
    8000188a:	7a02                	ld	s4,32(sp)
    8000188c:	6ae2                	ld	s5,24(sp)
    8000188e:	6b42                	ld	s6,16(sp)
    80001890:	6ba2                	ld	s7,8(sp)
    80001892:	6c02                	ld	s8,0(sp)
    80001894:	6161                	addi	sp,sp,80
    80001896:	8082                	ret
    return oldsz;
    80001898:	852e                	mv	a0,a1
}
    8000189a:	8082                	ret

000000008000189c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000189c:	7179                	addi	sp,sp,-48
    8000189e:	f406                	sd	ra,40(sp)
    800018a0:	f022                	sd	s0,32(sp)
    800018a2:	ec26                	sd	s1,24(sp)
    800018a4:	e84a                	sd	s2,16(sp)
    800018a6:	e44e                	sd	s3,8(sp)
    800018a8:	1800                	addi	s0,sp,48
    800018aa:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800018ac:	84aa                	mv	s1,a0
    800018ae:	6905                	lui	s2,0x1
    800018b0:	992a                	add	s2,s2,a0
    800018b2:	a821                	j	800018ca <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    800018b4:	0000a517          	auipc	a0,0xa
    800018b8:	8b450513          	addi	a0,a0,-1868 # 8000b168 <etext+0x168>
    800018bc:	fffff097          	auipc	ra,0xfffff
    800018c0:	ca2080e7          	jalr	-862(ra) # 8000055e <panic>
  for(int i = 0; i < 512; i++){
    800018c4:	04a1                	addi	s1,s1,8
    800018c6:	03248363          	beq	s1,s2,800018ec <freewalk+0x50>
    pte_t pte = pagetable[i];
    800018ca:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800018cc:	0017f713          	andi	a4,a5,1
    800018d0:	db75                	beqz	a4,800018c4 <freewalk+0x28>
    800018d2:	00e7f713          	andi	a4,a5,14
    800018d6:	ff79                	bnez	a4,800018b4 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800018d8:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800018da:	00c79513          	slli	a0,a5,0xc
    800018de:	00000097          	auipc	ra,0x0
    800018e2:	fbe080e7          	jalr	-66(ra) # 8000189c <freewalk>
      pagetable[i] = 0;
    800018e6:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800018ea:	bfe9                	j	800018c4 <freewalk+0x28>
    }
  }
  kfree((void*)pagetable);
    800018ec:	854e                	mv	a0,s3
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	1b6080e7          	jalr	438(ra) # 80000aa4 <kfree>
}
    800018f6:	70a2                	ld	ra,40(sp)
    800018f8:	7402                	ld	s0,32(sp)
    800018fa:	64e2                	ld	s1,24(sp)
    800018fc:	6942                	ld	s2,16(sp)
    800018fe:	69a2                	ld	s3,8(sp)
    80001900:	6145                	addi	sp,sp,48
    80001902:	8082                	ret

0000000080001904 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001904:	1101                	addi	sp,sp,-32
    80001906:	ec06                	sd	ra,24(sp)
    80001908:	e822                	sd	s0,16(sp)
    8000190a:	e426                	sd	s1,8(sp)
    8000190c:	1000                	addi	s0,sp,32
    8000190e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001910:	e999                	bnez	a1,80001926 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001912:	8526                	mv	a0,s1
    80001914:	00000097          	auipc	ra,0x0
    80001918:	f88080e7          	jalr	-120(ra) # 8000189c <freewalk>
}
    8000191c:	60e2                	ld	ra,24(sp)
    8000191e:	6442                	ld	s0,16(sp)
    80001920:	64a2                	ld	s1,8(sp)
    80001922:	6105                	addi	sp,sp,32
    80001924:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001926:	6785                	lui	a5,0x1
    80001928:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000192a:	95be                	add	a1,a1,a5
    8000192c:	4685                	li	a3,1
    8000192e:	00c5d613          	srli	a2,a1,0xc
    80001932:	4581                	li	a1,0
    80001934:	00000097          	auipc	ra,0x0
    80001938:	ac8080e7          	jalr	-1336(ra) # 800013fc <uvmunmap>
    8000193c:	bfd9                	j	80001912 <uvmfree+0xe>

000000008000193e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000193e:	c669                	beqz	a2,80001a08 <uvmcopy+0xca>
{
    80001940:	715d                	addi	sp,sp,-80
    80001942:	e486                	sd	ra,72(sp)
    80001944:	e0a2                	sd	s0,64(sp)
    80001946:	fc26                	sd	s1,56(sp)
    80001948:	f84a                	sd	s2,48(sp)
    8000194a:	f44e                	sd	s3,40(sp)
    8000194c:	f052                	sd	s4,32(sp)
    8000194e:	ec56                	sd	s5,24(sp)
    80001950:	e85a                	sd	s6,16(sp)
    80001952:	e45e                	sd	s7,8(sp)
    80001954:	0880                	addi	s0,sp,80
    80001956:	8b2a                	mv	s6,a0
    80001958:	8aae                	mv	s5,a1
    8000195a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000195c:	4901                	li	s2,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000195e:	6985                	lui	s3,0x1
    if((pte = walk(old, i, 0)) == 0)
    80001960:	4601                	li	a2,0
    80001962:	85ca                	mv	a1,s2
    80001964:	855a                	mv	a0,s6
    80001966:	fffff097          	auipc	ra,0xfffff
    8000196a:	7da080e7          	jalr	2010(ra) # 80001140 <walk>
    8000196e:	c139                	beqz	a0,800019b4 <uvmcopy+0x76>
    if((*pte & PTE_V) == 0)
    80001970:	00053b83          	ld	s7,0(a0)
    80001974:	001bf793          	andi	a5,s7,1
    80001978:	c7b1                	beqz	a5,800019c4 <uvmcopy+0x86>
    if((mem = kalloc()) == 0)
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	298080e7          	jalr	664(ra) # 80000c12 <kalloc>
    80001982:	84aa                	mv	s1,a0
    80001984:	cd29                	beqz	a0,800019de <uvmcopy+0xa0>
    pa = PTE2PA(*pte);
    80001986:	00abd593          	srli	a1,s7,0xa
    memmove(mem, (char*)pa, PGSIZE);
    8000198a:	864e                	mv	a2,s3
    8000198c:	05b2                	slli	a1,a1,0xc
    8000198e:	fffff097          	auipc	ra,0xfffff
    80001992:	4fe080e7          	jalr	1278(ra) # 80000e8c <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001996:	3ffbf713          	andi	a4,s7,1023
    8000199a:	86a6                	mv	a3,s1
    8000199c:	864e                	mv	a2,s3
    8000199e:	85ca                	mv	a1,s2
    800019a0:	8556                	mv	a0,s5
    800019a2:	00000097          	auipc	ra,0x0
    800019a6:	882080e7          	jalr	-1918(ra) # 80001224 <mappages>
    800019aa:	e50d                	bnez	a0,800019d4 <uvmcopy+0x96>
  for(i = 0; i < sz; i += PGSIZE){
    800019ac:	994e                	add	s2,s2,s3
    800019ae:	fb4969e3          	bltu	s2,s4,80001960 <uvmcopy+0x22>
    800019b2:	a081                	j	800019f2 <uvmcopy+0xb4>
      panic("uvmcopy: pte should exist");
    800019b4:	00009517          	auipc	a0,0x9
    800019b8:	7c450513          	addi	a0,a0,1988 # 8000b178 <etext+0x178>
    800019bc:	fffff097          	auipc	ra,0xfffff
    800019c0:	ba2080e7          	jalr	-1118(ra) # 8000055e <panic>
      panic("uvmcopy: page not present");
    800019c4:	00009517          	auipc	a0,0x9
    800019c8:	7d450513          	addi	a0,a0,2004 # 8000b198 <etext+0x198>
    800019cc:	fffff097          	auipc	ra,0xfffff
    800019d0:	b92080e7          	jalr	-1134(ra) # 8000055e <panic>
      kfree(mem);
    800019d4:	8526                	mv	a0,s1
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	0ce080e7          	jalr	206(ra) # 80000aa4 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800019de:	4685                	li	a3,1
    800019e0:	00c95613          	srli	a2,s2,0xc
    800019e4:	4581                	li	a1,0
    800019e6:	8556                	mv	a0,s5
    800019e8:	00000097          	auipc	ra,0x0
    800019ec:	a14080e7          	jalr	-1516(ra) # 800013fc <uvmunmap>
  return -1;
    800019f0:	557d                	li	a0,-1
}
    800019f2:	60a6                	ld	ra,72(sp)
    800019f4:	6406                	ld	s0,64(sp)
    800019f6:	74e2                	ld	s1,56(sp)
    800019f8:	7942                	ld	s2,48(sp)
    800019fa:	79a2                	ld	s3,40(sp)
    800019fc:	7a02                	ld	s4,32(sp)
    800019fe:	6ae2                	ld	s5,24(sp)
    80001a00:	6b42                	ld	s6,16(sp)
    80001a02:	6ba2                	ld	s7,8(sp)
    80001a04:	6161                	addi	sp,sp,80
    80001a06:	8082                	ret
  return 0;
    80001a08:	4501                	li	a0,0
}
    80001a0a:	8082                	ret

0000000080001a0c <uvmshare>:

int
uvmshare(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001a0c:	715d                	addi	sp,sp,-80
    80001a0e:	e486                	sd	ra,72(sp)
    80001a10:	e0a2                	sd	s0,64(sp)
    80001a12:	f44e                	sd	s3,40(sp)
    80001a14:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa = 0, i;
  uint flags;
  
  for(i = 0; i < sz; i += PGSIZE) {
    80001a16:	ce5d                	beqz	a2,80001ad4 <uvmshare+0xc8>
    80001a18:	fc26                	sd	s1,56(sp)
    80001a1a:	f84a                	sd	s2,48(sp)
    80001a1c:	f052                	sd	s4,32(sp)
    80001a1e:	ec56                	sd	s5,24(sp)
    80001a20:	e85a                	sd	s6,16(sp)
    80001a22:	e45e                	sd	s7,8(sp)
    80001a24:	8baa                	mv	s7,a0
    80001a26:	8b2e                	mv	s6,a1
    80001a28:	8ab2                	mv	s5,a2
    80001a2a:	4901                	li	s2,0

    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    // flags |= PTE_W;

    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
    80001a2c:	6a05                	lui	s4,0x1
    80001a2e:	a891                	j	80001a82 <uvmshare+0x76>
    if(pte == 0) panic("uvmshare: pte should exist");
    80001a30:	00009517          	auipc	a0,0x9
    80001a34:	78850513          	addi	a0,a0,1928 # 8000b1b8 <etext+0x1b8>
    80001a38:	fffff097          	auipc	ra,0xfffff
    80001a3c:	b26080e7          	jalr	-1242(ra) # 8000055e <panic>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001a40:	00009517          	auipc	a0,0x9
    80001a44:	79850513          	addi	a0,a0,1944 # 8000b1d8 <etext+0x1d8>
    80001a48:	fffff097          	auipc	ra,0xfffff
    80001a4c:	b16080e7          	jalr	-1258(ra) # 8000055e <panic>
      uvmunmap(new, 0, i / PGSIZE, 0);
    80001a50:	4681                	li	a3,0
    80001a52:	00c95613          	srli	a2,s2,0xc
    80001a56:	4581                	li	a1,0
    80001a58:	855a                	mv	a0,s6
    80001a5a:	00000097          	auipc	ra,0x0
    80001a5e:	9a2080e7          	jalr	-1630(ra) # 800013fc <uvmunmap>
      return -1;
    80001a62:	59fd                	li	s3,-1
    80001a64:	74e2                	ld	s1,56(sp)
    80001a66:	7942                	ld	s2,48(sp)
    80001a68:	7a02                	ld	s4,32(sp)
    80001a6a:	6ae2                	ld	s5,24(sp)
    80001a6c:	6b42                	ld	s6,16(sp)
    80001a6e:	6ba2                	ld	s7,8(sp)
      add_page_reference((uint64)pa);
  }

  return 0;

}
    80001a70:	854e                	mv	a0,s3
    80001a72:	60a6                	ld	ra,72(sp)
    80001a74:	6406                	ld	s0,64(sp)
    80001a76:	79a2                	ld	s3,40(sp)
    80001a78:	6161                	addi	sp,sp,80
    80001a7a:	8082                	ret
  for(i = 0; i < sz; i += PGSIZE) {
    80001a7c:	9952                	add	s2,s2,s4
    80001a7e:	05597463          	bgeu	s2,s5,80001ac6 <uvmshare+0xba>
    pte = walk(old, i, 0);
    80001a82:	4601                	li	a2,0
    80001a84:	85ca                	mv	a1,s2
    80001a86:	855e                	mv	a0,s7
    80001a88:	fffff097          	auipc	ra,0xfffff
    80001a8c:	6b8080e7          	jalr	1720(ra) # 80001140 <walk>
    if(pte == 0) panic("uvmshare: pte should exist");
    80001a90:	d145                	beqz	a0,80001a30 <uvmshare+0x24>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001a92:	6118                	ld	a4,0(a0)
    80001a94:	00177793          	andi	a5,a4,1
    80001a98:	d7c5                	beqz	a5,80001a40 <uvmshare+0x34>
    pa = PTE2PA(*pte);
    80001a9a:	00a75493          	srli	s1,a4,0xa
    80001a9e:	04b2                	slli	s1,s1,0xc
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
    80001aa0:	3ff77713          	andi	a4,a4,1023
    80001aa4:	86a6                	mv	a3,s1
    80001aa6:	8652                	mv	a2,s4
    80001aa8:	85ca                	mv	a1,s2
    80001aaa:	855a                	mv	a0,s6
    80001aac:	fffff097          	auipc	ra,0xfffff
    80001ab0:	778080e7          	jalr	1912(ra) # 80001224 <mappages>
    80001ab4:	89aa                	mv	s3,a0
    80001ab6:	fd49                	bnez	a0,80001a50 <uvmshare+0x44>
    if (pa != 0)
    80001ab8:	d0f1                	beqz	s1,80001a7c <uvmshare+0x70>
      add_page_reference((uint64)pa);
    80001aba:	8526                	mv	a0,s1
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	f98080e7          	jalr	-104(ra) # 80000a54 <add_page_reference>
    80001ac4:	bf65                	j	80001a7c <uvmshare+0x70>
    80001ac6:	74e2                	ld	s1,56(sp)
    80001ac8:	7942                	ld	s2,48(sp)
    80001aca:	7a02                	ld	s4,32(sp)
    80001acc:	6ae2                	ld	s5,24(sp)
    80001ace:	6b42                	ld	s6,16(sp)
    80001ad0:	6ba2                	ld	s7,8(sp)
    80001ad2:	bf79                	j	80001a70 <uvmshare+0x64>
  return 0;
    80001ad4:	4981                	li	s3,0
    80001ad6:	bf69                	j	80001a70 <uvmshare+0x64>

0000000080001ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001ad8:	1141                	addi	sp,sp,-16
    80001ada:	e406                	sd	ra,8(sp)
    80001adc:	e022                	sd	s0,0(sp)
    80001ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001ae0:	4601                	li	a2,0
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	65e080e7          	jalr	1630(ra) # 80001140 <walk>
  if(pte == 0)
    80001aea:	c901                	beqz	a0,80001afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001aec:	611c                	ld	a5,0(a0)
    80001aee:	9bbd                	andi	a5,a5,-17
    80001af0:	e11c                	sd	a5,0(a0)
}
    80001af2:	60a2                	ld	ra,8(sp)
    80001af4:	6402                	ld	s0,0(sp)
    80001af6:	0141                	addi	sp,sp,16
    80001af8:	8082                	ret
    panic("uvmclear");
    80001afa:	00009517          	auipc	a0,0x9
    80001afe:	6fe50513          	addi	a0,a0,1790 # 8000b1f8 <etext+0x1f8>
    80001b02:	fffff097          	auipc	ra,0xfffff
    80001b06:	a5c080e7          	jalr	-1444(ra) # 8000055e <panic>

0000000080001b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001b0a:	c6bd                	beqz	a3,80001b78 <copyout+0x6e>
{
    80001b0c:	715d                	addi	sp,sp,-80
    80001b0e:	e486                	sd	ra,72(sp)
    80001b10:	e0a2                	sd	s0,64(sp)
    80001b12:	fc26                	sd	s1,56(sp)
    80001b14:	f84a                	sd	s2,48(sp)
    80001b16:	f44e                	sd	s3,40(sp)
    80001b18:	f052                	sd	s4,32(sp)
    80001b1a:	ec56                	sd	s5,24(sp)
    80001b1c:	e85a                	sd	s6,16(sp)
    80001b1e:	e45e                	sd	s7,8(sp)
    80001b20:	e062                	sd	s8,0(sp)
    80001b22:	0880                	addi	s0,sp,80
    80001b24:	8b2a                	mv	s6,a0
    80001b26:	8c2e                	mv	s8,a1
    80001b28:	8a32                	mv	s4,a2
    80001b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001b2e:	6a85                	lui	s5,0x1
    80001b30:	a015                	j	80001b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001b32:	9562                	add	a0,a0,s8
    80001b34:	0004861b          	sext.w	a2,s1
    80001b38:	85d2                	mv	a1,s4
    80001b3a:	41250533          	sub	a0,a0,s2
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	34e080e7          	jalr	846(ra) # 80000e8c <memmove>

    len -= n;
    80001b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80001b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001b50:	02098263          	beqz	s3,80001b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001b58:	85ca                	mv	a1,s2
    80001b5a:	855a                	mv	a0,s6
    80001b5c:	fffff097          	auipc	ra,0xfffff
    80001b60:	68a080e7          	jalr	1674(ra) # 800011e6 <walkaddr>
    if(pa0 == 0)
    80001b64:	cd01                	beqz	a0,80001b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001b66:	418904b3          	sub	s1,s2,s8
    80001b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80001b6c:	fc99f3e3          	bgeu	s3,s1,80001b32 <copyout+0x28>
    80001b70:	84ce                	mv	s1,s3
    80001b72:	b7c1                	j	80001b32 <copyout+0x28>
  }
  return 0;
    80001b74:	4501                	li	a0,0
    80001b76:	a021                	j	80001b7e <copyout+0x74>
    80001b78:	4501                	li	a0,0
}
    80001b7a:	8082                	ret
      return -1;
    80001b7c:	557d                	li	a0,-1
}
    80001b7e:	60a6                	ld	ra,72(sp)
    80001b80:	6406                	ld	s0,64(sp)
    80001b82:	74e2                	ld	s1,56(sp)
    80001b84:	7942                	ld	s2,48(sp)
    80001b86:	79a2                	ld	s3,40(sp)
    80001b88:	7a02                	ld	s4,32(sp)
    80001b8a:	6ae2                	ld	s5,24(sp)
    80001b8c:	6b42                	ld	s6,16(sp)
    80001b8e:	6ba2                	ld	s7,8(sp)
    80001b90:	6c02                	ld	s8,0(sp)
    80001b92:	6161                	addi	sp,sp,80
    80001b94:	8082                	ret

0000000080001b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001b96:	caa5                	beqz	a3,80001c06 <copyin+0x70>
{
    80001b98:	715d                	addi	sp,sp,-80
    80001b9a:	e486                	sd	ra,72(sp)
    80001b9c:	e0a2                	sd	s0,64(sp)
    80001b9e:	fc26                	sd	s1,56(sp)
    80001ba0:	f84a                	sd	s2,48(sp)
    80001ba2:	f44e                	sd	s3,40(sp)
    80001ba4:	f052                	sd	s4,32(sp)
    80001ba6:	ec56                	sd	s5,24(sp)
    80001ba8:	e85a                	sd	s6,16(sp)
    80001baa:	e45e                	sd	s7,8(sp)
    80001bac:	e062                	sd	s8,0(sp)
    80001bae:	0880                	addi	s0,sp,80
    80001bb0:	8b2a                	mv	s6,a0
    80001bb2:	8a2e                	mv	s4,a1
    80001bb4:	8c32                	mv	s8,a2
    80001bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001bba:	6a85                	lui	s5,0x1
    80001bbc:	a01d                	j	80001be2 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001bbe:	018505b3          	add	a1,a0,s8
    80001bc2:	0004861b          	sext.w	a2,s1
    80001bc6:	412585b3          	sub	a1,a1,s2
    80001bca:	8552                	mv	a0,s4
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	2c0080e7          	jalr	704(ra) # 80000e8c <memmove>

    len -= n;
    80001bd4:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001bd8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001bda:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001bde:	02098263          	beqz	s3,80001c02 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001be2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001be6:	85ca                	mv	a1,s2
    80001be8:	855a                	mv	a0,s6
    80001bea:	fffff097          	auipc	ra,0xfffff
    80001bee:	5fc080e7          	jalr	1532(ra) # 800011e6 <walkaddr>
    if(pa0 == 0)
    80001bf2:	cd01                	beqz	a0,80001c0a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001bf4:	418904b3          	sub	s1,s2,s8
    80001bf8:	94d6                	add	s1,s1,s5
    if(n > len)
    80001bfa:	fc99f2e3          	bgeu	s3,s1,80001bbe <copyin+0x28>
    80001bfe:	84ce                	mv	s1,s3
    80001c00:	bf7d                	j	80001bbe <copyin+0x28>
  }
  return 0;
    80001c02:	4501                	li	a0,0
    80001c04:	a021                	j	80001c0c <copyin+0x76>
    80001c06:	4501                	li	a0,0
}
    80001c08:	8082                	ret
      return -1;
    80001c0a:	557d                	li	a0,-1
}
    80001c0c:	60a6                	ld	ra,72(sp)
    80001c0e:	6406                	ld	s0,64(sp)
    80001c10:	74e2                	ld	s1,56(sp)
    80001c12:	7942                	ld	s2,48(sp)
    80001c14:	79a2                	ld	s3,40(sp)
    80001c16:	7a02                	ld	s4,32(sp)
    80001c18:	6ae2                	ld	s5,24(sp)
    80001c1a:	6b42                	ld	s6,16(sp)
    80001c1c:	6ba2                	ld	s7,8(sp)
    80001c1e:	6c02                	ld	s8,0(sp)
    80001c20:	6161                	addi	sp,sp,80
    80001c22:	8082                	ret

0000000080001c24 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001c24:	cad5                	beqz	a3,80001cd8 <copyinstr+0xb4>
{
    80001c26:	715d                	addi	sp,sp,-80
    80001c28:	e486                	sd	ra,72(sp)
    80001c2a:	e0a2                	sd	s0,64(sp)
    80001c2c:	fc26                	sd	s1,56(sp)
    80001c2e:	f84a                	sd	s2,48(sp)
    80001c30:	f44e                	sd	s3,40(sp)
    80001c32:	f052                	sd	s4,32(sp)
    80001c34:	ec56                	sd	s5,24(sp)
    80001c36:	e85a                	sd	s6,16(sp)
    80001c38:	e45e                	sd	s7,8(sp)
    80001c3a:	0880                	addi	s0,sp,80
    80001c3c:	8aaa                	mv	s5,a0
    80001c3e:	84ae                	mv	s1,a1
    80001c40:	8bb2                	mv	s7,a2
    80001c42:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001c44:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001c46:	6a05                	lui	s4,0x1
    80001c48:	a82d                	j	80001c82 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001c4a:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80001c4e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001c50:	0017c793          	xori	a5,a5,1
    80001c54:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001c58:	60a6                	ld	ra,72(sp)
    80001c5a:	6406                	ld	s0,64(sp)
    80001c5c:	74e2                	ld	s1,56(sp)
    80001c5e:	7942                	ld	s2,48(sp)
    80001c60:	79a2                	ld	s3,40(sp)
    80001c62:	7a02                	ld	s4,32(sp)
    80001c64:	6ae2                	ld	s5,24(sp)
    80001c66:	6b42                	ld	s6,16(sp)
    80001c68:	6ba2                	ld	s7,8(sp)
    80001c6a:	6161                	addi	sp,sp,80
    80001c6c:	8082                	ret
    80001c6e:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001c72:	9726                	add	a4,a4,s1
      --max;
    80001c74:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80001c78:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001c7c:	04e58663          	beq	a1,a4,80001cc8 <copyinstr+0xa4>
{
    80001c80:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001c82:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001c86:	85ca                	mv	a1,s2
    80001c88:	8556                	mv	a0,s5
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	55c080e7          	jalr	1372(ra) # 800011e6 <walkaddr>
    if(pa0 == 0)
    80001c92:	cd0d                	beqz	a0,80001ccc <copyinstr+0xa8>
    n = PGSIZE - (srcva - va0);
    80001c94:	417906b3          	sub	a3,s2,s7
    80001c98:	96d2                	add	a3,a3,s4
    if(n > max)
    80001c9a:	00d9f363          	bgeu	s3,a3,80001ca0 <copyinstr+0x7c>
    80001c9e:	86ce                	mv	a3,s3
    while(n > 0){
    80001ca0:	ca85                	beqz	a3,80001cd0 <copyinstr+0xac>
    char *p = (char *) (pa0 + (srcva - va0));
    80001ca2:	01750633          	add	a2,a0,s7
    80001ca6:	41260633          	sub	a2,a2,s2
    80001caa:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80001cac:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80001cae:	96a6                	add	a3,a3,s1
    80001cb0:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001cb2:	00f60733          	add	a4,a2,a5
    80001cb6:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff8b768>
    80001cba:	db41                	beqz	a4,80001c4a <copyinstr+0x26>
        *dst = *p;
    80001cbc:	00e78023          	sb	a4,0(a5)
      dst++;
    80001cc0:	0785                	addi	a5,a5,1
    while(n > 0){
    80001cc2:	fed797e3          	bne	a5,a3,80001cb0 <copyinstr+0x8c>
    80001cc6:	b765                	j	80001c6e <copyinstr+0x4a>
    80001cc8:	4781                	li	a5,0
    80001cca:	b759                	j	80001c50 <copyinstr+0x2c>
      return -1;
    80001ccc:	557d                	li	a0,-1
    80001cce:	b769                	j	80001c58 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80001cd0:	6b85                	lui	s7,0x1
    80001cd2:	9bca                	add	s7,s7,s2
    80001cd4:	87a6                	mv	a5,s1
    80001cd6:	b76d                	j	80001c80 <copyinstr+0x5c>
  int got_null = 0;
    80001cd8:	4781                	li	a5,0
  if(got_null){
    80001cda:	0017c793          	xori	a5,a5,1
    80001cde:	40f0053b          	negw	a0,a5
}
    80001ce2:	8082                	ret

0000000080001ce4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001ce4:	715d                	addi	sp,sp,-80
    80001ce6:	e486                	sd	ra,72(sp)
    80001ce8:	e0a2                	sd	s0,64(sp)
    80001cea:	fc26                	sd	s1,56(sp)
    80001cec:	f84a                	sd	s2,48(sp)
    80001cee:	f44e                	sd	s3,40(sp)
    80001cf0:	f052                	sd	s4,32(sp)
    80001cf2:	ec56                	sd	s5,24(sp)
    80001cf4:	e85a                	sd	s6,16(sp)
    80001cf6:	e45e                	sd	s7,8(sp)
    80001cf8:	e062                	sd	s8,0(sp)
    80001cfa:	0880                	addi	s0,sp,80
    80001cfc:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cfe:	00056497          	auipc	s1,0x56
    80001d02:	72248493          	addi	s1,s1,1826 # 80058420 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001d06:	8c26                	mv	s8,s1
    80001d08:	586fb7b7          	lui	a5,0x586fb
    80001d0c:	58778793          	addi	a5,a5,1415 # 586fb587 <_entry-0x27904a79>
    80001d10:	6fb58937          	lui	s2,0x6fb58
    80001d14:	6fb90913          	addi	s2,s2,1787 # 6fb586fb <_entry-0x104a7905>
    80001d18:	1902                	slli	s2,s2,0x20
    80001d1a:	993e                	add	s2,s2,a5
    80001d1c:	040009b7          	lui	s3,0x4000
    80001d20:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001d22:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001d24:	4b99                	li	s7,6
    80001d26:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d28:	00064a97          	auipc	s5,0x64
    80001d2c:	2f8a8a93          	addi	s5,s5,760 # 80066020 <tickslock>
    char *pa = kalloc();
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	ee2080e7          	jalr	-286(ra) # 80000c12 <kalloc>
    80001d38:	862a                	mv	a2,a0
    if(pa == 0)
    80001d3a:	c131                	beqz	a0,80001d7e <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80001d3c:	418485b3          	sub	a1,s1,s8
    80001d40:	8591                	srai	a1,a1,0x4
    80001d42:	032585b3          	mul	a1,a1,s2
    80001d46:	05b6                	slli	a1,a1,0xd
    80001d48:	6789                	lui	a5,0x2
    80001d4a:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001d4c:	875e                	mv	a4,s7
    80001d4e:	86da                	mv	a3,s6
    80001d50:	40b985b3          	sub	a1,s3,a1
    80001d54:	8552                	mv	a0,s4
    80001d56:	fffff097          	auipc	ra,0xfffff
    80001d5a:	570080e7          	jalr	1392(ra) # 800012c6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d5e:	37048493          	addi	s1,s1,880
    80001d62:	fd5497e3          	bne	s1,s5,80001d30 <proc_mapstacks+0x4c>
  }
}
    80001d66:	60a6                	ld	ra,72(sp)
    80001d68:	6406                	ld	s0,64(sp)
    80001d6a:	74e2                	ld	s1,56(sp)
    80001d6c:	7942                	ld	s2,48(sp)
    80001d6e:	79a2                	ld	s3,40(sp)
    80001d70:	7a02                	ld	s4,32(sp)
    80001d72:	6ae2                	ld	s5,24(sp)
    80001d74:	6b42                	ld	s6,16(sp)
    80001d76:	6ba2                	ld	s7,8(sp)
    80001d78:	6c02                	ld	s8,0(sp)
    80001d7a:	6161                	addi	sp,sp,80
    80001d7c:	8082                	ret
      panic("kalloc");
    80001d7e:	00009517          	auipc	a0,0x9
    80001d82:	48a50513          	addi	a0,a0,1162 # 8000b208 <etext+0x208>
    80001d86:	ffffe097          	auipc	ra,0xffffe
    80001d8a:	7d8080e7          	jalr	2008(ra) # 8000055e <panic>

0000000080001d8e <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001d8e:	7139                	addi	sp,sp,-64
    80001d90:	fc06                	sd	ra,56(sp)
    80001d92:	f822                	sd	s0,48(sp)
    80001d94:	f426                	sd	s1,40(sp)
    80001d96:	f04a                	sd	s2,32(sp)
    80001d98:	ec4e                	sd	s3,24(sp)
    80001d9a:	e852                	sd	s4,16(sp)
    80001d9c:	e456                	sd	s5,8(sp)
    80001d9e:	e05a                	sd	s6,0(sp)
    80001da0:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001da2:	00009597          	auipc	a1,0x9
    80001da6:	46e58593          	addi	a1,a1,1134 # 8000b210 <etext+0x210>
    80001daa:	00056517          	auipc	a0,0x56
    80001dae:	24650513          	addi	a0,a0,582 # 80057ff0 <pid_lock>
    80001db2:	fffff097          	auipc	ra,0xfffff
    80001db6:	ee8080e7          	jalr	-280(ra) # 80000c9a <initlock>
  initlock(&wait_lock, "wait_lock");
    80001dba:	00009597          	auipc	a1,0x9
    80001dbe:	45e58593          	addi	a1,a1,1118 # 8000b218 <etext+0x218>
    80001dc2:	00056517          	auipc	a0,0x56
    80001dc6:	24650513          	addi	a0,a0,582 # 80058008 <wait_lock>
    80001dca:	fffff097          	auipc	ra,0xfffff
    80001dce:	ed0080e7          	jalr	-304(ra) # 80000c9a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001dd2:	00056497          	auipc	s1,0x56
    80001dd6:	64e48493          	addi	s1,s1,1614 # 80058420 <proc>
      initlock(&p->lock, "proc");
    80001dda:	00009b17          	auipc	s6,0x9
    80001dde:	44eb0b13          	addi	s6,s6,1102 # 8000b228 <etext+0x228>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001de2:	8aa6                	mv	s5,s1
    80001de4:	586fb7b7          	lui	a5,0x586fb
    80001de8:	58778793          	addi	a5,a5,1415 # 586fb587 <_entry-0x27904a79>
    80001dec:	6fb58937          	lui	s2,0x6fb58
    80001df0:	6fb90913          	addi	s2,s2,1787 # 6fb586fb <_entry-0x104a7905>
    80001df4:	1902                	slli	s2,s2,0x20
    80001df6:	993e                	add	s2,s2,a5
    80001df8:	040009b7          	lui	s3,0x4000
    80001dfc:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001dfe:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e00:	00064a17          	auipc	s4,0x64
    80001e04:	220a0a13          	addi	s4,s4,544 # 80066020 <tickslock>
      initlock(&p->lock, "proc");
    80001e08:	85da                	mv	a1,s6
    80001e0a:	8526                	mv	a0,s1
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	e8e080e7          	jalr	-370(ra) # 80000c9a <initlock>
      p->state = UNUSED;
    80001e14:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001e18:	415487b3          	sub	a5,s1,s5
    80001e1c:	8791                	srai	a5,a5,0x4
    80001e1e:	032787b3          	mul	a5,a5,s2
    80001e22:	07b6                	slli	a5,a5,0xd
    80001e24:	6709                	lui	a4,0x2
    80001e26:	9fb9                	addw	a5,a5,a4
    80001e28:	40f987b3          	sub	a5,s3,a5
    80001e2c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e2e:	37048493          	addi	s1,s1,880
    80001e32:	fd449be3          	bne	s1,s4,80001e08 <procinit+0x7a>
  }
}
    80001e36:	70e2                	ld	ra,56(sp)
    80001e38:	7442                	ld	s0,48(sp)
    80001e3a:	74a2                	ld	s1,40(sp)
    80001e3c:	7902                	ld	s2,32(sp)
    80001e3e:	69e2                	ld	s3,24(sp)
    80001e40:	6a42                	ld	s4,16(sp)
    80001e42:	6aa2                	ld	s5,8(sp)
    80001e44:	6b02                	ld	s6,0(sp)
    80001e46:	6121                	addi	sp,sp,64
    80001e48:	8082                	ret

0000000080001e4a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001e4a:	1141                	addi	sp,sp,-16
    80001e4c:	e406                	sd	ra,8(sp)
    80001e4e:	e022                	sd	s0,0(sp)
    80001e50:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e52:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001e54:	2501                	sext.w	a0,a0
    80001e56:	60a2                	ld	ra,8(sp)
    80001e58:	6402                	ld	s0,0(sp)
    80001e5a:	0141                	addi	sp,sp,16
    80001e5c:	8082                	ret

0000000080001e5e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001e5e:	1141                	addi	sp,sp,-16
    80001e60:	e406                	sd	ra,8(sp)
    80001e62:	e022                	sd	s0,0(sp)
    80001e64:	0800                	addi	s0,sp,16
    80001e66:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001e68:	2781                	sext.w	a5,a5
    80001e6a:	079e                	slli	a5,a5,0x7
  return c;
}
    80001e6c:	00056517          	auipc	a0,0x56
    80001e70:	1b450513          	addi	a0,a0,436 # 80058020 <cpus>
    80001e74:	953e                	add	a0,a0,a5
    80001e76:	60a2                	ld	ra,8(sp)
    80001e78:	6402                	ld	s0,0(sp)
    80001e7a:	0141                	addi	sp,sp,16
    80001e7c:	8082                	ret

0000000080001e7e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001e7e:	1101                	addi	sp,sp,-32
    80001e80:	ec06                	sd	ra,24(sp)
    80001e82:	e822                	sd	s0,16(sp)
    80001e84:	e426                	sd	s1,8(sp)
    80001e86:	1000                	addi	s0,sp,32
  push_off();
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	e5c080e7          	jalr	-420(ra) # 80000ce4 <push_off>
    80001e90:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001e92:	2781                	sext.w	a5,a5
    80001e94:	079e                	slli	a5,a5,0x7
    80001e96:	00056717          	auipc	a4,0x56
    80001e9a:	15a70713          	addi	a4,a4,346 # 80057ff0 <pid_lock>
    80001e9e:	97ba                	add	a5,a5,a4
    80001ea0:	7b9c                	ld	a5,48(a5)
    80001ea2:	84be                	mv	s1,a5
  pop_off();
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	ee4080e7          	jalr	-284(ra) # 80000d88 <pop_off>
  return p;
}
    80001eac:	8526                	mv	a0,s1
    80001eae:	60e2                	ld	ra,24(sp)
    80001eb0:	6442                	ld	s0,16(sp)
    80001eb2:	64a2                	ld	s1,8(sp)
    80001eb4:	6105                	addi	sp,sp,32
    80001eb6:	8082                	ret

0000000080001eb8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001eb8:	1141                	addi	sp,sp,-16
    80001eba:	e406                	sd	ra,8(sp)
    80001ebc:	e022                	sd	s0,0(sp)
    80001ebe:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001ec0:	00000097          	auipc	ra,0x0
    80001ec4:	fbe080e7          	jalr	-66(ra) # 80001e7e <myproc>
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	f1c080e7          	jalr	-228(ra) # 80000de4 <release>

  if (first) {
    80001ed0:	0000e797          	auipc	a5,0xe
    80001ed4:	d907a783          	lw	a5,-624(a5) # 8000fc60 <first.1>
    80001ed8:	eb89                	bnez	a5,80001eea <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001eda:	00001097          	auipc	ra,0x1
    80001ede:	152080e7          	jalr	338(ra) # 8000302c <usertrapret>
}
    80001ee2:	60a2                	ld	ra,8(sp)
    80001ee4:	6402                	ld	s0,0(sp)
    80001ee6:	0141                	addi	sp,sp,16
    80001ee8:	8082                	ret
    first = 0;
    80001eea:	0000e797          	auipc	a5,0xe
    80001eee:	d607ab23          	sw	zero,-650(a5) # 8000fc60 <first.1>
    fsinit(ROOTDEV);
    80001ef2:	4505                	li	a0,1
    80001ef4:	00002097          	auipc	ra,0x2
    80001ef8:	440080e7          	jalr	1088(ra) # 80004334 <fsinit>
    80001efc:	bff9                	j	80001eda <forkret+0x22>

0000000080001efe <allocpid>:
{
    80001efe:	1101                	addi	sp,sp,-32
    80001f00:	ec06                	sd	ra,24(sp)
    80001f02:	e822                	sd	s0,16(sp)
    80001f04:	e426                	sd	s1,8(sp)
    80001f06:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001f08:	00056517          	auipc	a0,0x56
    80001f0c:	0e850513          	addi	a0,a0,232 # 80057ff0 <pid_lock>
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	e24080e7          	jalr	-476(ra) # 80000d34 <acquire>
  pid = nextpid;
    80001f18:	0000e797          	auipc	a5,0xe
    80001f1c:	d4c78793          	addi	a5,a5,-692 # 8000fc64 <nextpid>
    80001f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001f22:	0014871b          	addiw	a4,s1,1
    80001f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001f28:	00056517          	auipc	a0,0x56
    80001f2c:	0c850513          	addi	a0,a0,200 # 80057ff0 <pid_lock>
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	eb4080e7          	jalr	-332(ra) # 80000de4 <release>
}
    80001f38:	8526                	mv	a0,s1
    80001f3a:	60e2                	ld	ra,24(sp)
    80001f3c:	6442                	ld	s0,16(sp)
    80001f3e:	64a2                	ld	s1,8(sp)
    80001f40:	6105                	addi	sp,sp,32
    80001f42:	8082                	ret

0000000080001f44 <proc_pagetable>:
{
    80001f44:	1101                	addi	sp,sp,-32
    80001f46:	ec06                	sd	ra,24(sp)
    80001f48:	e822                	sd	s0,16(sp)
    80001f4a:	e426                	sd	s1,8(sp)
    80001f4c:	e04a                	sd	s2,0(sp)
    80001f4e:	1000                	addi	s0,sp,32
    80001f50:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	57e080e7          	jalr	1406(ra) # 800014d0 <uvmcreate>
    80001f5a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001f5c:	c121                	beqz	a0,80001f9c <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001f5e:	4729                	li	a4,10
    80001f60:	00008697          	auipc	a3,0x8
    80001f64:	0a068693          	addi	a3,a3,160 # 8000a000 <_trampoline>
    80001f68:	6605                	lui	a2,0x1
    80001f6a:	040005b7          	lui	a1,0x4000
    80001f6e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f70:	05b2                	slli	a1,a1,0xc
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	2b2080e7          	jalr	690(ra) # 80001224 <mappages>
    80001f7a:	02054863          	bltz	a0,80001faa <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001f7e:	4719                	li	a4,6
    80001f80:	05893683          	ld	a3,88(s2)
    80001f84:	6605                	lui	a2,0x1
    80001f86:	020005b7          	lui	a1,0x2000
    80001f8a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001f8c:	05b6                	slli	a1,a1,0xd
    80001f8e:	8526                	mv	a0,s1
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	294080e7          	jalr	660(ra) # 80001224 <mappages>
    80001f98:	02054163          	bltz	a0,80001fba <proc_pagetable+0x76>
}
    80001f9c:	8526                	mv	a0,s1
    80001f9e:	60e2                	ld	ra,24(sp)
    80001fa0:	6442                	ld	s0,16(sp)
    80001fa2:	64a2                	ld	s1,8(sp)
    80001fa4:	6902                	ld	s2,0(sp)
    80001fa6:	6105                	addi	sp,sp,32
    80001fa8:	8082                	ret
    uvmfree(pagetable, 0);
    80001faa:	4581                	li	a1,0
    80001fac:	8526                	mv	a0,s1
    80001fae:	00000097          	auipc	ra,0x0
    80001fb2:	956080e7          	jalr	-1706(ra) # 80001904 <uvmfree>
    return 0;
    80001fb6:	4481                	li	s1,0
    80001fb8:	b7d5                	j	80001f9c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001fba:	4681                	li	a3,0
    80001fbc:	4605                	li	a2,1
    80001fbe:	040005b7          	lui	a1,0x4000
    80001fc2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001fc4:	05b2                	slli	a1,a1,0xc
    80001fc6:	8526                	mv	a0,s1
    80001fc8:	fffff097          	auipc	ra,0xfffff
    80001fcc:	434080e7          	jalr	1076(ra) # 800013fc <uvmunmap>
    uvmfree(pagetable, 0);
    80001fd0:	4581                	li	a1,0
    80001fd2:	8526                	mv	a0,s1
    80001fd4:	00000097          	auipc	ra,0x0
    80001fd8:	930080e7          	jalr	-1744(ra) # 80001904 <uvmfree>
    return 0;
    80001fdc:	4481                	li	s1,0
    80001fde:	bf7d                	j	80001f9c <proc_pagetable+0x58>

0000000080001fe0 <proc_freepagetable>:
{
    80001fe0:	1101                	addi	sp,sp,-32
    80001fe2:	ec06                	sd	ra,24(sp)
    80001fe4:	e822                	sd	s0,16(sp)
    80001fe6:	e426                	sd	s1,8(sp)
    80001fe8:	e04a                	sd	s2,0(sp)
    80001fea:	1000                	addi	s0,sp,32
    80001fec:	84aa                	mv	s1,a0
    80001fee:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ff0:	4681                	li	a3,0
    80001ff2:	4605                	li	a2,1
    80001ff4:	040005b7          	lui	a1,0x4000
    80001ff8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ffa:	05b2                	slli	a1,a1,0xc
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	400080e7          	jalr	1024(ra) # 800013fc <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002004:	4681                	li	a3,0
    80002006:	4605                	li	a2,1
    80002008:	020005b7          	lui	a1,0x2000
    8000200c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000200e:	05b6                	slli	a1,a1,0xd
    80002010:	8526                	mv	a0,s1
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	3ea080e7          	jalr	1002(ra) # 800013fc <uvmunmap>
  uvmfree(pagetable, sz);
    8000201a:	85ca                	mv	a1,s2
    8000201c:	8526                	mv	a0,s1
    8000201e:	00000097          	auipc	ra,0x0
    80002022:	8e6080e7          	jalr	-1818(ra) # 80001904 <uvmfree>
}
    80002026:	60e2                	ld	ra,24(sp)
    80002028:	6442                	ld	s0,16(sp)
    8000202a:	64a2                	ld	s1,8(sp)
    8000202c:	6902                	ld	s2,0(sp)
    8000202e:	6105                	addi	sp,sp,32
    80002030:	8082                	ret

0000000080002032 <freeproc>:
{
    80002032:	1101                	addi	sp,sp,-32
    80002034:	ec06                	sd	ra,24(sp)
    80002036:	e822                	sd	s0,16(sp)
    80002038:	e426                	sd	s1,8(sp)
    8000203a:	1000                	addi	s0,sp,32
    8000203c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000203e:	6d28                	ld	a0,88(a0)
    80002040:	c509                	beqz	a0,8000204a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80002042:	fffff097          	auipc	ra,0xfffff
    80002046:	a62080e7          	jalr	-1438(ra) # 80000aa4 <kfree>
  p->trapframe = 0;
    8000204a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000204e:	68a8                	ld	a0,80(s1)
    80002050:	c511                	beqz	a0,8000205c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80002052:	64ac                	ld	a1,72(s1)
    80002054:	00000097          	auipc	ra,0x0
    80002058:	f8c080e7          	jalr	-116(ra) # 80001fe0 <proc_freepagetable>
  p->pagetable = 0;
    8000205c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80002060:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80002064:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80002068:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000206c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80002070:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002074:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80002078:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000207c:	0004ac23          	sw	zero,24(s1)
}
    80002080:	60e2                	ld	ra,24(sp)
    80002082:	6442                	ld	s0,16(sp)
    80002084:	64a2                	ld	s1,8(sp)
    80002086:	6105                	addi	sp,sp,32
    80002088:	8082                	ret

000000008000208a <allocproc>:
{
    8000208a:	1101                	addi	sp,sp,-32
    8000208c:	ec06                	sd	ra,24(sp)
    8000208e:	e822                	sd	s0,16(sp)
    80002090:	e426                	sd	s1,8(sp)
    80002092:	e04a                	sd	s2,0(sp)
    80002094:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80002096:	00056497          	auipc	s1,0x56
    8000209a:	38a48493          	addi	s1,s1,906 # 80058420 <proc>
    8000209e:	00064917          	auipc	s2,0x64
    800020a2:	f8290913          	addi	s2,s2,-126 # 80066020 <tickslock>
    acquire(&p->lock);
    800020a6:	8526                	mv	a0,s1
    800020a8:	fffff097          	auipc	ra,0xfffff
    800020ac:	c8c080e7          	jalr	-884(ra) # 80000d34 <acquire>
    if(p->state == UNUSED) {
    800020b0:	4c9c                	lw	a5,24(s1)
    800020b2:	cf81                	beqz	a5,800020ca <allocproc+0x40>
      release(&p->lock);
    800020b4:	8526                	mv	a0,s1
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	d2e080e7          	jalr	-722(ra) # 80000de4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800020be:	37048493          	addi	s1,s1,880
    800020c2:	ff2492e3          	bne	s1,s2,800020a6 <allocproc+0x1c>
  return 0;
    800020c6:	4481                	li	s1,0
    800020c8:	a095                	j	8000212c <allocproc+0xa2>
  p->pid = allocpid();
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	e34080e7          	jalr	-460(ra) # 80001efe <allocpid>
    800020d2:	d888                	sw	a0,48(s1)
  p->state = USED;
    800020d4:	4785                	li	a5,1
    800020d6:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	b3a080e7          	jalr	-1222(ra) # 80000c12 <kalloc>
    800020e0:	892a                	mv	s2,a0
    800020e2:	eca8                	sd	a0,88(s1)
    800020e4:	c939                	beqz	a0,8000213a <allocproc+0xb0>
  p->pagetable = proc_pagetable(p);
    800020e6:	8526                	mv	a0,s1
    800020e8:	00000097          	auipc	ra,0x0
    800020ec:	e5c080e7          	jalr	-420(ra) # 80001f44 <proc_pagetable>
    800020f0:	892a                	mv	s2,a0
    800020f2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800020f4:	cd39                	beqz	a0,80002152 <allocproc+0xc8>
  memset(&p->context, 0, sizeof(p->context));
    800020f6:	07000613          	li	a2,112
    800020fa:	4581                	li	a1,0
    800020fc:	06048513          	addi	a0,s1,96
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	d2c080e7          	jalr	-724(ra) # 80000e2c <memset>
  p->context.ra = (uint64)forkret;
    80002108:	00000797          	auipc	a5,0x0
    8000210c:	db078793          	addi	a5,a5,-592 # 80001eb8 <forkret>
    80002110:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002112:	60bc                	ld	a5,64(s1)
    80002114:	6705                	lui	a4,0x1
    80002116:	97ba                	add	a5,a5,a4
    80002118:	f4bc                	sd	a5,104(s1)
  memset(p->infant_threads, 0, MAX_THREADS);
    8000211a:	04000613          	li	a2,64
    8000211e:	4581                	li	a1,0
    80002120:	17048513          	addi	a0,s1,368
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	d08080e7          	jalr	-760(ra) # 80000e2c <memset>
}
    8000212c:	8526                	mv	a0,s1
    8000212e:	60e2                	ld	ra,24(sp)
    80002130:	6442                	ld	s0,16(sp)
    80002132:	64a2                	ld	s1,8(sp)
    80002134:	6902                	ld	s2,0(sp)
    80002136:	6105                	addi	sp,sp,32
    80002138:	8082                	ret
    freeproc(p);
    8000213a:	8526                	mv	a0,s1
    8000213c:	00000097          	auipc	ra,0x0
    80002140:	ef6080e7          	jalr	-266(ra) # 80002032 <freeproc>
    release(&p->lock);
    80002144:	8526                	mv	a0,s1
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	c9e080e7          	jalr	-866(ra) # 80000de4 <release>
    return 0;
    8000214e:	84ca                	mv	s1,s2
    80002150:	bff1                	j	8000212c <allocproc+0xa2>
    freeproc(p);
    80002152:	8526                	mv	a0,s1
    80002154:	00000097          	auipc	ra,0x0
    80002158:	ede080e7          	jalr	-290(ra) # 80002032 <freeproc>
    release(&p->lock);
    8000215c:	8526                	mv	a0,s1
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	c86080e7          	jalr	-890(ra) # 80000de4 <release>
    return 0;
    80002166:	84ca                	mv	s1,s2
    80002168:	b7d1                	j	8000212c <allocproc+0xa2>

000000008000216a <userinit>:
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	e426                	sd	s1,8(sp)
    80002172:	1000                	addi	s0,sp,32
  p = allocproc();
    80002174:	00000097          	auipc	ra,0x0
    80002178:	f16080e7          	jalr	-234(ra) # 8000208a <allocproc>
    8000217c:	84aa                	mv	s1,a0
  initproc = p;
    8000217e:	0000e797          	auipc	a5,0xe
    80002182:	bca7bd23          	sd	a0,-1062(a5) # 8000fd58 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002186:	03400613          	li	a2,52
    8000218a:	0000e597          	auipc	a1,0xe
    8000218e:	ae658593          	addi	a1,a1,-1306 # 8000fc70 <initcode>
    80002192:	6928                	ld	a0,80(a0)
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	36a080e7          	jalr	874(ra) # 800014fe <uvmfirst>
  p->sz = PGSIZE;
    8000219c:	6785                	lui	a5,0x1
    8000219e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800021a0:	6cb8                	ld	a4,88(s1)
    800021a2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800021a6:	6cb8                	ld	a4,88(s1)
    800021a8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800021aa:	4641                	li	a2,16
    800021ac:	00009597          	auipc	a1,0x9
    800021b0:	08458593          	addi	a1,a1,132 # 8000b230 <etext+0x230>
    800021b4:	15848513          	addi	a0,s1,344
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	dcc080e7          	jalr	-564(ra) # 80000f84 <safestrcpy>
  p->cwd = namei("/");
    800021c0:	00009517          	auipc	a0,0x9
    800021c4:	08050513          	addi	a0,a0,128 # 8000b240 <etext+0x240>
    800021c8:	00003097          	auipc	ra,0x3
    800021cc:	bd8080e7          	jalr	-1064(ra) # 80004da0 <namei>
    800021d0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800021d4:	478d                	li	a5,3
    800021d6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800021d8:	8526                	mv	a0,s1
    800021da:	fffff097          	auipc	ra,0xfffff
    800021de:	c0a080e7          	jalr	-1014(ra) # 80000de4 <release>
}
    800021e2:	60e2                	ld	ra,24(sp)
    800021e4:	6442                	ld	s0,16(sp)
    800021e6:	64a2                	ld	s1,8(sp)
    800021e8:	6105                	addi	sp,sp,32
    800021ea:	8082                	ret

00000000800021ec <growproc>:
{
    800021ec:	1101                	addi	sp,sp,-32
    800021ee:	ec06                	sd	ra,24(sp)
    800021f0:	e822                	sd	s0,16(sp)
    800021f2:	e426                	sd	s1,8(sp)
    800021f4:	e04a                	sd	s2,0(sp)
    800021f6:	1000                	addi	s0,sp,32
    800021f8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800021fa:	00000097          	auipc	ra,0x0
    800021fe:	c84080e7          	jalr	-892(ra) # 80001e7e <myproc>
    80002202:	84aa                	mv	s1,a0
  sz = p->sz;
    80002204:	652c                	ld	a1,72(a0)
  if(n > 0){
    80002206:	05205463          	blez	s2,8000224e <growproc+0x62>
    if (p->is_thread == 1) {
    8000220a:	16852703          	lw	a4,360(a0)
    8000220e:	4785                	li	a5,1
    80002210:	02f70463          	beq	a4,a5,80002238 <growproc+0x4c>
    } else if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80002214:	4691                	li	a3,4
    80002216:	00b90633          	add	a2,s2,a1
    8000221a:	6928                	ld	a0,80(a0)
    8000221c:	fffff097          	auipc	ra,0xfffff
    80002220:	39c080e7          	jalr	924(ra) # 800015b8 <uvmalloc>
    80002224:	85aa                	mv	a1,a0
    80002226:	cd21                	beqz	a0,8000227e <growproc+0x92>
  p->sz = sz;
    80002228:	e4ac                	sd	a1,72(s1)
  return 0;
    8000222a:	4501                	li	a0,0
}
    8000222c:	60e2                	ld	ra,24(sp)
    8000222e:	6442                	ld	s0,16(sp)
    80002230:	64a2                	ld	s1,8(sp)
    80002232:	6902                	ld	s2,0(sp)
    80002234:	6105                	addi	sp,sp,32
    80002236:	8082                	ret
      if ((sz = uvmthreaded_alloc(p, sz, sz + n, PTE_W)) == 0) {
    80002238:	4691                	li	a3,4
    8000223a:	00b90633          	add	a2,s2,a1
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	43c080e7          	jalr	1084(ra) # 8000167a <uvmthreaded_alloc>
    80002246:	85aa                	mv	a1,a0
    80002248:	f165                	bnez	a0,80002228 <growproc+0x3c>
        return -1;
    8000224a:	557d                	li	a0,-1
    8000224c:	b7c5                	j	8000222c <growproc+0x40>
  } else if(n < 0){
    8000224e:	fc095de3          	bgez	s2,80002228 <growproc+0x3c>
    if (p->is_thread == 1)
    80002252:	16852703          	lw	a4,360(a0)
    80002256:	4785                	li	a5,1
    80002258:	00f70b63          	beq	a4,a5,8000226e <growproc+0x82>
      sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000225c:	00b90633          	add	a2,s2,a1
    80002260:	6928                	ld	a0,80(a0)
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	30e080e7          	jalr	782(ra) # 80001570 <uvmdealloc>
    8000226a:	85aa                	mv	a1,a0
    8000226c:	bf75                	j	80002228 <growproc+0x3c>
      sz = uvmthreaded_dealloc(p, sz, sz + n);
    8000226e:	00b90633          	add	a2,s2,a1
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	584080e7          	jalr	1412(ra) # 800017f6 <uvmthreaded_dealloc>
    8000227a:	85aa                	mv	a1,a0
    8000227c:	b775                	j	80002228 <growproc+0x3c>
      return -1;
    8000227e:	557d                	li	a0,-1
    80002280:	b775                	j	8000222c <growproc+0x40>

0000000080002282 <fork>:
{
    80002282:	7139                	addi	sp,sp,-64
    80002284:	fc06                	sd	ra,56(sp)
    80002286:	f822                	sd	s0,48(sp)
    80002288:	f426                	sd	s1,40(sp)
    8000228a:	e456                	sd	s5,8(sp)
    8000228c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000228e:	00000097          	auipc	ra,0x0
    80002292:	bf0080e7          	jalr	-1040(ra) # 80001e7e <myproc>
    80002296:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	df2080e7          	jalr	-526(ra) # 8000208a <allocproc>
    800022a0:	12050263          	beqz	a0,800023c4 <fork+0x142>
    800022a4:	ec4e                	sd	s3,24(sp)
    800022a6:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800022a8:	048ab603          	ld	a2,72(s5)
    800022ac:	692c                	ld	a1,80(a0)
    800022ae:	050ab503          	ld	a0,80(s5)
    800022b2:	fffff097          	auipc	ra,0xfffff
    800022b6:	68c080e7          	jalr	1676(ra) # 8000193e <uvmcopy>
    800022ba:	04054863          	bltz	a0,8000230a <fork+0x88>
    800022be:	f04a                	sd	s2,32(sp)
    800022c0:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800022c2:	048ab783          	ld	a5,72(s5)
    800022c6:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800022ca:	058ab683          	ld	a3,88(s5)
    800022ce:	87b6                	mv	a5,a3
    800022d0:	0589b703          	ld	a4,88(s3)
    800022d4:	12068693          	addi	a3,a3,288
    800022d8:	6388                	ld	a0,0(a5)
    800022da:	678c                	ld	a1,8(a5)
    800022dc:	6b90                	ld	a2,16(a5)
    800022de:	e308                	sd	a0,0(a4)
    800022e0:	e70c                	sd	a1,8(a4)
    800022e2:	eb10                	sd	a2,16(a4)
    800022e4:	6f90                	ld	a2,24(a5)
    800022e6:	ef10                	sd	a2,24(a4)
    800022e8:	02078793          	addi	a5,a5,32 # 1020 <_entry-0x7fffefe0>
    800022ec:	02070713          	addi	a4,a4,32
    800022f0:	fed794e3          	bne	a5,a3,800022d8 <fork+0x56>
  np->trapframe->a0 = 0;
    800022f4:	0589b783          	ld	a5,88(s3)
    800022f8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800022fc:	0d0a8493          	addi	s1,s5,208
    80002300:	0d098913          	addi	s2,s3,208
    80002304:	150a8a13          	addi	s4,s5,336
    80002308:	a015                	j	8000232c <fork+0xaa>
    freeproc(np);
    8000230a:	854e                	mv	a0,s3
    8000230c:	00000097          	auipc	ra,0x0
    80002310:	d26080e7          	jalr	-730(ra) # 80002032 <freeproc>
    release(&np->lock);
    80002314:	854e                	mv	a0,s3
    80002316:	fffff097          	auipc	ra,0xfffff
    8000231a:	ace080e7          	jalr	-1330(ra) # 80000de4 <release>
    return -1;
    8000231e:	54fd                	li	s1,-1
    80002320:	69e2                	ld	s3,24(sp)
    80002322:	a851                	j	800023b6 <fork+0x134>
  for(i = 0; i < NOFILE; i++)
    80002324:	04a1                	addi	s1,s1,8
    80002326:	0921                	addi	s2,s2,8
    80002328:	01448b63          	beq	s1,s4,8000233e <fork+0xbc>
    if(p->ofile[i])
    8000232c:	6088                	ld	a0,0(s1)
    8000232e:	d97d                	beqz	a0,80002324 <fork+0xa2>
      np->ofile[i] = filedup(p->ofile[i]);
    80002330:	00003097          	auipc	ra,0x3
    80002334:	106080e7          	jalr	262(ra) # 80005436 <filedup>
    80002338:	00a93023          	sd	a0,0(s2)
    8000233c:	b7e5                	j	80002324 <fork+0xa2>
  np->cwd = idup(p->cwd);
    8000233e:	150ab503          	ld	a0,336(s5)
    80002342:	00002097          	auipc	ra,0x2
    80002346:	236080e7          	jalr	566(ra) # 80004578 <idup>
    8000234a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000234e:	4641                	li	a2,16
    80002350:	158a8593          	addi	a1,s5,344
    80002354:	15898513          	addi	a0,s3,344
    80002358:	fffff097          	auipc	ra,0xfffff
    8000235c:	c2c080e7          	jalr	-980(ra) # 80000f84 <safestrcpy>
  pid = np->pid;
    80002360:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80002364:	854e                	mv	a0,s3
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	a7e080e7          	jalr	-1410(ra) # 80000de4 <release>
  acquire(&wait_lock);
    8000236e:	00056517          	auipc	a0,0x56
    80002372:	c9a50513          	addi	a0,a0,-870 # 80058008 <wait_lock>
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	9be080e7          	jalr	-1602(ra) # 80000d34 <acquire>
  np->parent = p;
    8000237e:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002382:	00056517          	auipc	a0,0x56
    80002386:	c8650513          	addi	a0,a0,-890 # 80058008 <wait_lock>
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	a5a080e7          	jalr	-1446(ra) # 80000de4 <release>
  acquire(&np->lock);
    80002392:	854e                	mv	a0,s3
    80002394:	fffff097          	auipc	ra,0xfffff
    80002398:	9a0080e7          	jalr	-1632(ra) # 80000d34 <acquire>
  np->state = RUNNABLE;
    8000239c:	478d                	li	a5,3
    8000239e:	00f9ac23          	sw	a5,24(s3)
  np->is_thread = 0;
    800023a2:	1609a423          	sw	zero,360(s3)
  release(&np->lock);
    800023a6:	854e                	mv	a0,s3
    800023a8:	fffff097          	auipc	ra,0xfffff
    800023ac:	a3c080e7          	jalr	-1476(ra) # 80000de4 <release>
  return pid;
    800023b0:	7902                	ld	s2,32(sp)
    800023b2:	69e2                	ld	s3,24(sp)
    800023b4:	6a42                	ld	s4,16(sp)
}
    800023b6:	8526                	mv	a0,s1
    800023b8:	70e2                	ld	ra,56(sp)
    800023ba:	7442                	ld	s0,48(sp)
    800023bc:	74a2                	ld	s1,40(sp)
    800023be:	6aa2                	ld	s5,8(sp)
    800023c0:	6121                	addi	sp,sp,64
    800023c2:	8082                	ret
    return -1;
    800023c4:	54fd                	li	s1,-1
    800023c6:	bfc5                	j	800023b6 <fork+0x134>

00000000800023c8 <create_thread>:
int create_thread(void* (*fn_addr)(void *), void *args, void *stack_addr, void (*exit_fn)(uint64)) {
    800023c8:	715d                	addi	sp,sp,-80
    800023ca:	e486                	sd	ra,72(sp)
    800023cc:	e0a2                	sd	s0,64(sp)
    800023ce:	fc26                	sd	s1,56(sp)
    800023d0:	f84a                	sd	s2,48(sp)
    800023d2:	f44e                	sd	s3,40(sp)
    800023d4:	f052                	sd	s4,32(sp)
    800023d6:	ec56                	sd	s5,24(sp)
    800023d8:	e85a                	sd	s6,16(sp)
    800023da:	e45e                	sd	s7,8(sp)
    800023dc:	e062                	sd	s8,0(sp)
    800023de:	0880                	addi	s0,sp,80
    800023e0:	8baa                	mv	s7,a0
    800023e2:	8c2e                	mv	s8,a1
    800023e4:	84b2                	mv	s1,a2
    800023e6:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800023e8:	00000097          	auipc	ra,0x0
    800023ec:	a96080e7          	jalr	-1386(ra) # 80001e7e <myproc>
    800023f0:	8aaa                	mv	s5,a0
  for (int i = 0; i < MAX_THREADS; i++) {
    800023f2:	89aa                	mv	s3,a0
    800023f4:	17050713          	addi	a4,a0,368
    800023f8:	4781                	li	a5,0
    800023fa:	04000693          	li	a3,64
    if (p->infant_threads[i] == 0) {
    800023fe:	00073803          	ld	a6,0(a4)
    80002402:	00080863          	beqz	a6,80002412 <create_thread+0x4a>
  for (int i = 0; i < MAX_THREADS; i++) {
    80002406:	2785                	addiw	a5,a5,1
    80002408:	0721                	addi	a4,a4,8
    8000240a:	fed79ae3          	bne	a5,a3,800023fe <create_thread+0x36>
  uint64 thread_idx = 0;
    8000240e:	4b01                	li	s6,0
    80002410:	a011                	j	80002414 <create_thread+0x4c>
      thread_idx = i;
    80002412:	8b3e                	mv	s6,a5
  if((np = allocproc()) == 0){
    80002414:	00000097          	auipc	ra,0x0
    80002418:	c76080e7          	jalr	-906(ra) # 8000208a <allocproc>
    8000241c:	8a2a                	mv	s4,a0
    8000241e:	cd2d                	beqz	a0,80002498 <create_thread+0xd0>
  if(uvmshare(p->pagetable, np->pagetable, p->sz) < 0){
    80002420:	048ab603          	ld	a2,72(s5)
    80002424:	692c                	ld	a1,80(a0)
    80002426:	050ab503          	ld	a0,80(s5)
    8000242a:	fffff097          	auipc	ra,0xfffff
    8000242e:	5e2080e7          	jalr	1506(ra) # 80001a0c <uvmshare>
    80002432:	06054d63          	bltz	a0,800024ac <create_thread+0xe4>
  np->sz = p->sz;
    80002436:	048ab783          	ld	a5,72(s5)
    8000243a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000243e:	058ab683          	ld	a3,88(s5)
    80002442:	87b6                	mv	a5,a3
    80002444:	058a3703          	ld	a4,88(s4)
    80002448:	12068693          	addi	a3,a3,288
    8000244c:	6388                	ld	a0,0(a5)
    8000244e:	678c                	ld	a1,8(a5)
    80002450:	6b90                	ld	a2,16(a5)
    80002452:	e308                	sd	a0,0(a4)
    80002454:	e70c                	sd	a1,8(a4)
    80002456:	eb10                	sd	a2,16(a4)
    80002458:	6f90                	ld	a2,24(a5)
    8000245a:	ef10                	sd	a2,24(a4)
    8000245c:	02078793          	addi	a5,a5,32
    80002460:	02070713          	addi	a4,a4,32
    80002464:	fed794e3          	bne	a5,a3,8000244c <create_thread+0x84>
  np->trapframe->sp = (uint64)stack_addr + PGSIZE;
    80002468:	058a3783          	ld	a5,88(s4)
    8000246c:	6705                	lui	a4,0x1
    8000246e:	94ba                	add	s1,s1,a4
    80002470:	fb84                	sd	s1,48(a5)
  np->trapframe->epc = (uint64)fn_addr;
    80002472:	058a3783          	ld	a5,88(s4)
    80002476:	0177bc23          	sd	s7,24(a5)
  np->trapframe->a0 = (uint64)args;
    8000247a:	058a3783          	ld	a5,88(s4)
    8000247e:	0787b823          	sd	s8,112(a5)
  np->trapframe->ra = (uint64)exit_fn;
    80002482:	058a3783          	ld	a5,88(s4)
    80002486:	0327b423          	sd	s2,40(a5)
  for(i = 0; i < NOFILE; i++)
    8000248a:	0d098493          	addi	s1,s3,208
    8000248e:	0d0a0913          	addi	s2,s4,208
    80002492:	15098993          	addi	s3,s3,336
    80002496:	a81d                	j	800024cc <create_thread+0x104>
    printf("Max processes reached\n");
    80002498:	00009517          	auipc	a0,0x9
    8000249c:	db050513          	addi	a0,a0,-592 # 8000b248 <etext+0x248>
    800024a0:	ffffe097          	auipc	ra,0xffffe
    800024a4:	108080e7          	jalr	264(ra) # 800005a8 <printf>
    return -1;
    800024a8:	557d                	li	a0,-1
    800024aa:	a865                	j	80002562 <create_thread+0x19a>
    freeproc(np);
    800024ac:	8552                	mv	a0,s4
    800024ae:	00000097          	auipc	ra,0x0
    800024b2:	b84080e7          	jalr	-1148(ra) # 80002032 <freeproc>
    release(&np->lock);
    800024b6:	8552                	mv	a0,s4
    800024b8:	fffff097          	auipc	ra,0xfffff
    800024bc:	92c080e7          	jalr	-1748(ra) # 80000de4 <release>
    return -1;
    800024c0:	557d                	li	a0,-1
    800024c2:	a045                	j	80002562 <create_thread+0x19a>
  for(i = 0; i < NOFILE; i++)
    800024c4:	04a1                	addi	s1,s1,8
    800024c6:	0921                	addi	s2,s2,8
    800024c8:	01348b63          	beq	s1,s3,800024de <create_thread+0x116>
    if(p->ofile[i])
    800024cc:	6088                	ld	a0,0(s1)
    800024ce:	d97d                	beqz	a0,800024c4 <create_thread+0xfc>
      np->ofile[i] = filedup(p->ofile[i]);
    800024d0:	00003097          	auipc	ra,0x3
    800024d4:	f66080e7          	jalr	-154(ra) # 80005436 <filedup>
    800024d8:	00a93023          	sd	a0,0(s2)
    800024dc:	b7e5                	j	800024c4 <create_thread+0xfc>
  np->cwd = idup(p->cwd);
    800024de:	150ab503          	ld	a0,336(s5)
    800024e2:	00002097          	auipc	ra,0x2
    800024e6:	096080e7          	jalr	150(ra) # 80004578 <idup>
    800024ea:	14aa3823          	sd	a0,336(s4)
  release(&np->lock);
    800024ee:	8552                	mv	a0,s4
    800024f0:	fffff097          	auipc	ra,0xfffff
    800024f4:	8f4080e7          	jalr	-1804(ra) # 80000de4 <release>
  acquire(&wait_lock);
    800024f8:	00056517          	auipc	a0,0x56
    800024fc:	b1050513          	addi	a0,a0,-1264 # 80058008 <wait_lock>
    80002500:	fffff097          	auipc	ra,0xfffff
    80002504:	834080e7          	jalr	-1996(ra) # 80000d34 <acquire>
  if (p->is_thread) {
    80002508:	168aa783          	lw	a5,360(s5)
    8000250c:	c7bd                	beqz	a5,8000257a <create_thread+0x1b2>
    np->parent = p->parent->parent;
    8000250e:	038ab783          	ld	a5,56(s5)
    80002512:	7f9c                	ld	a5,56(a5)
    80002514:	02fa3c23          	sd	a5,56(s4)
    p = p->parent->parent;
    80002518:	038ab783          	ld	a5,56(s5)
    8000251c:	0387ba83          	ld	s5,56(a5)
  release(&wait_lock);
    80002520:	00056517          	auipc	a0,0x56
    80002524:	ae850513          	addi	a0,a0,-1304 # 80058008 <wait_lock>
    80002528:	fffff097          	auipc	ra,0xfffff
    8000252c:	8bc080e7          	jalr	-1860(ra) # 80000de4 <release>
  acquire(&np->lock);
    80002530:	8552                	mv	a0,s4
    80002532:	fffff097          	auipc	ra,0xfffff
    80002536:	802080e7          	jalr	-2046(ra) # 80000d34 <acquire>
  np->is_thread = 1;
    8000253a:	4785                	li	a5,1
    8000253c:	16fa2423          	sw	a5,360(s4)
  np->state = RUNNABLE;
    80002540:	478d                	li	a5,3
    80002542:	00fa2c23          	sw	a5,24(s4)
  p->infant_threads[thread_idx] = np;
    80002546:	003b1793          	slli	a5,s6,0x3
    8000254a:	17078793          	addi	a5,a5,368
    8000254e:	9abe                	add	s5,s5,a5
    80002550:	014ab023          	sd	s4,0(s5)
  release(&np->lock);
    80002554:	8552                	mv	a0,s4
    80002556:	fffff097          	auipc	ra,0xfffff
    8000255a:	88e080e7          	jalr	-1906(ra) # 80000de4 <release>
  return np->pid;
    8000255e:	030a2503          	lw	a0,48(s4)
}
    80002562:	60a6                	ld	ra,72(sp)
    80002564:	6406                	ld	s0,64(sp)
    80002566:	74e2                	ld	s1,56(sp)
    80002568:	7942                	ld	s2,48(sp)
    8000256a:	79a2                	ld	s3,40(sp)
    8000256c:	7a02                	ld	s4,32(sp)
    8000256e:	6ae2                	ld	s5,24(sp)
    80002570:	6b42                	ld	s6,16(sp)
    80002572:	6ba2                	ld	s7,8(sp)
    80002574:	6c02                	ld	s8,0(sp)
    80002576:	6161                	addi	sp,sp,80
    80002578:	8082                	ret
    np->parent = p;
    8000257a:	035a3c23          	sd	s5,56(s4)
    8000257e:	b74d                	j	80002520 <create_thread+0x158>

0000000080002580 <scheduler>:
{
    80002580:	7139                	addi	sp,sp,-64
    80002582:	fc06                	sd	ra,56(sp)
    80002584:	f822                	sd	s0,48(sp)
    80002586:	f426                	sd	s1,40(sp)
    80002588:	f04a                	sd	s2,32(sp)
    8000258a:	ec4e                	sd	s3,24(sp)
    8000258c:	e852                	sd	s4,16(sp)
    8000258e:	e456                	sd	s5,8(sp)
    80002590:	e05a                	sd	s6,0(sp)
    80002592:	0080                	addi	s0,sp,64
    80002594:	8792                	mv	a5,tp
  int id = r_tp();
    80002596:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002598:	00779a93          	slli	s5,a5,0x7
    8000259c:	00056717          	auipc	a4,0x56
    800025a0:	a5470713          	addi	a4,a4,-1452 # 80057ff0 <pid_lock>
    800025a4:	9756                	add	a4,a4,s5
    800025a6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800025aa:	00056717          	auipc	a4,0x56
    800025ae:	a7e70713          	addi	a4,a4,-1410 # 80058028 <cpus+0x8>
    800025b2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800025b4:	498d                	li	s3,3
        p->state = RUNNING;
    800025b6:	4b11                	li	s6,4
        c->proc = p;
    800025b8:	079e                	slli	a5,a5,0x7
    800025ba:	00056a17          	auipc	s4,0x56
    800025be:	a36a0a13          	addi	s4,s4,-1482 # 80057ff0 <pid_lock>
    800025c2:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025c8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025cc:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800025d0:	00056497          	auipc	s1,0x56
    800025d4:	e5048493          	addi	s1,s1,-432 # 80058420 <proc>
    800025d8:	00064917          	auipc	s2,0x64
    800025dc:	a4890913          	addi	s2,s2,-1464 # 80066020 <tickslock>
    800025e0:	a811                	j	800025f4 <scheduler+0x74>
      release(&p->lock);
    800025e2:	8526                	mv	a0,s1
    800025e4:	fffff097          	auipc	ra,0xfffff
    800025e8:	800080e7          	jalr	-2048(ra) # 80000de4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800025ec:	37048493          	addi	s1,s1,880
    800025f0:	fd248ae3          	beq	s1,s2,800025c4 <scheduler+0x44>
      acquire(&p->lock);
    800025f4:	8526                	mv	a0,s1
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	73e080e7          	jalr	1854(ra) # 80000d34 <acquire>
      if(p->state == RUNNABLE) {
    800025fe:	4c9c                	lw	a5,24(s1)
    80002600:	ff3791e3          	bne	a5,s3,800025e2 <scheduler+0x62>
        p->state = RUNNING;
    80002604:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002608:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000260c:	06048593          	addi	a1,s1,96
    80002610:	8556                	mv	a0,s5
    80002612:	00001097          	auipc	ra,0x1
    80002616:	96c080e7          	jalr	-1684(ra) # 80002f7e <swtch>
        c->proc = 0;
    8000261a:	020a3823          	sd	zero,48(s4)
    8000261e:	b7d1                	j	800025e2 <scheduler+0x62>

0000000080002620 <sched>:
{
    80002620:	7179                	addi	sp,sp,-48
    80002622:	f406                	sd	ra,40(sp)
    80002624:	f022                	sd	s0,32(sp)
    80002626:	ec26                	sd	s1,24(sp)
    80002628:	e84a                	sd	s2,16(sp)
    8000262a:	e44e                	sd	s3,8(sp)
    8000262c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000262e:	00000097          	auipc	ra,0x0
    80002632:	850080e7          	jalr	-1968(ra) # 80001e7e <myproc>
    80002636:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002638:	ffffe097          	auipc	ra,0xffffe
    8000263c:	67c080e7          	jalr	1660(ra) # 80000cb4 <holding>
    80002640:	cd25                	beqz	a0,800026b8 <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002642:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002644:	2781                	sext.w	a5,a5
    80002646:	079e                	slli	a5,a5,0x7
    80002648:	00056717          	auipc	a4,0x56
    8000264c:	9a870713          	addi	a4,a4,-1624 # 80057ff0 <pid_lock>
    80002650:	97ba                	add	a5,a5,a4
    80002652:	0a87a703          	lw	a4,168(a5)
    80002656:	4785                	li	a5,1
    80002658:	06f71863          	bne	a4,a5,800026c8 <sched+0xa8>
  if(p->state == RUNNING)
    8000265c:	4c98                	lw	a4,24(s1)
    8000265e:	4791                	li	a5,4
    80002660:	06f70c63          	beq	a4,a5,800026d8 <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002664:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002668:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000266a:	efbd                	bnez	a5,800026e8 <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000266c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000266e:	00056917          	auipc	s2,0x56
    80002672:	98290913          	addi	s2,s2,-1662 # 80057ff0 <pid_lock>
    80002676:	2781                	sext.w	a5,a5
    80002678:	079e                	slli	a5,a5,0x7
    8000267a:	97ca                	add	a5,a5,s2
    8000267c:	0ac7a983          	lw	s3,172(a5)
    80002680:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002682:	2781                	sext.w	a5,a5
    80002684:	079e                	slli	a5,a5,0x7
    80002686:	07a1                	addi	a5,a5,8
    80002688:	00056597          	auipc	a1,0x56
    8000268c:	99858593          	addi	a1,a1,-1640 # 80058020 <cpus>
    80002690:	95be                	add	a1,a1,a5
    80002692:	06048513          	addi	a0,s1,96
    80002696:	00001097          	auipc	ra,0x1
    8000269a:	8e8080e7          	jalr	-1816(ra) # 80002f7e <swtch>
    8000269e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800026a0:	2781                	sext.w	a5,a5
    800026a2:	079e                	slli	a5,a5,0x7
    800026a4:	993e                	add	s2,s2,a5
    800026a6:	0b392623          	sw	s3,172(s2)
}
    800026aa:	70a2                	ld	ra,40(sp)
    800026ac:	7402                	ld	s0,32(sp)
    800026ae:	64e2                	ld	s1,24(sp)
    800026b0:	6942                	ld	s2,16(sp)
    800026b2:	69a2                	ld	s3,8(sp)
    800026b4:	6145                	addi	sp,sp,48
    800026b6:	8082                	ret
    panic("sched p->lock");
    800026b8:	00009517          	auipc	a0,0x9
    800026bc:	ba850513          	addi	a0,a0,-1112 # 8000b260 <etext+0x260>
    800026c0:	ffffe097          	auipc	ra,0xffffe
    800026c4:	e9e080e7          	jalr	-354(ra) # 8000055e <panic>
    panic("sched locks");
    800026c8:	00009517          	auipc	a0,0x9
    800026cc:	ba850513          	addi	a0,a0,-1112 # 8000b270 <etext+0x270>
    800026d0:	ffffe097          	auipc	ra,0xffffe
    800026d4:	e8e080e7          	jalr	-370(ra) # 8000055e <panic>
    panic("sched running");
    800026d8:	00009517          	auipc	a0,0x9
    800026dc:	ba850513          	addi	a0,a0,-1112 # 8000b280 <etext+0x280>
    800026e0:	ffffe097          	auipc	ra,0xffffe
    800026e4:	e7e080e7          	jalr	-386(ra) # 8000055e <panic>
    panic("sched interruptible");
    800026e8:	00009517          	auipc	a0,0x9
    800026ec:	ba850513          	addi	a0,a0,-1112 # 8000b290 <etext+0x290>
    800026f0:	ffffe097          	auipc	ra,0xffffe
    800026f4:	e6e080e7          	jalr	-402(ra) # 8000055e <panic>

00000000800026f8 <yield>:
{
    800026f8:	1101                	addi	sp,sp,-32
    800026fa:	ec06                	sd	ra,24(sp)
    800026fc:	e822                	sd	s0,16(sp)
    800026fe:	e426                	sd	s1,8(sp)
    80002700:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002702:	fffff097          	auipc	ra,0xfffff
    80002706:	77c080e7          	jalr	1916(ra) # 80001e7e <myproc>
    8000270a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000270c:	ffffe097          	auipc	ra,0xffffe
    80002710:	628080e7          	jalr	1576(ra) # 80000d34 <acquire>
  p->state = RUNNABLE;
    80002714:	478d                	li	a5,3
    80002716:	cc9c                	sw	a5,24(s1)
  sched();
    80002718:	00000097          	auipc	ra,0x0
    8000271c:	f08080e7          	jalr	-248(ra) # 80002620 <sched>
  release(&p->lock);
    80002720:	8526                	mv	a0,s1
    80002722:	ffffe097          	auipc	ra,0xffffe
    80002726:	6c2080e7          	jalr	1730(ra) # 80000de4 <release>
}
    8000272a:	60e2                	ld	ra,24(sp)
    8000272c:	6442                	ld	s0,16(sp)
    8000272e:	64a2                	ld	s1,8(sp)
    80002730:	6105                	addi	sp,sp,32
    80002732:	8082                	ret

0000000080002734 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002734:	7179                	addi	sp,sp,-48
    80002736:	f406                	sd	ra,40(sp)
    80002738:	f022                	sd	s0,32(sp)
    8000273a:	ec26                	sd	s1,24(sp)
    8000273c:	e84a                	sd	s2,16(sp)
    8000273e:	e44e                	sd	s3,8(sp)
    80002740:	1800                	addi	s0,sp,48
    80002742:	89aa                	mv	s3,a0
    80002744:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002746:	fffff097          	auipc	ra,0xfffff
    8000274a:	738080e7          	jalr	1848(ra) # 80001e7e <myproc>
    8000274e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002750:	ffffe097          	auipc	ra,0xffffe
    80002754:	5e4080e7          	jalr	1508(ra) # 80000d34 <acquire>
  release(lk);
    80002758:	854a                	mv	a0,s2
    8000275a:	ffffe097          	auipc	ra,0xffffe
    8000275e:	68a080e7          	jalr	1674(ra) # 80000de4 <release>

  // Go to sleep.
  p->chan = chan;
    80002762:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002766:	4789                	li	a5,2
    80002768:	cc9c                	sw	a5,24(s1)

  sched();
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	eb6080e7          	jalr	-330(ra) # 80002620 <sched>

  // Tidy up.
  p->chan = 0;
    80002772:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002776:	8526                	mv	a0,s1
    80002778:	ffffe097          	auipc	ra,0xffffe
    8000277c:	66c080e7          	jalr	1644(ra) # 80000de4 <release>
  acquire(lk);
    80002780:	854a                	mv	a0,s2
    80002782:	ffffe097          	auipc	ra,0xffffe
    80002786:	5b2080e7          	jalr	1458(ra) # 80000d34 <acquire>
}
    8000278a:	70a2                	ld	ra,40(sp)
    8000278c:	7402                	ld	s0,32(sp)
    8000278e:	64e2                	ld	s1,24(sp)
    80002790:	6942                	ld	s2,16(sp)
    80002792:	69a2                	ld	s3,8(sp)
    80002794:	6145                	addi	sp,sp,48
    80002796:	8082                	ret

0000000080002798 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002798:	7139                	addi	sp,sp,-64
    8000279a:	fc06                	sd	ra,56(sp)
    8000279c:	f822                	sd	s0,48(sp)
    8000279e:	f426                	sd	s1,40(sp)
    800027a0:	f04a                	sd	s2,32(sp)
    800027a2:	ec4e                	sd	s3,24(sp)
    800027a4:	e852                	sd	s4,16(sp)
    800027a6:	e456                	sd	s5,8(sp)
    800027a8:	0080                	addi	s0,sp,64
    800027aa:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800027ac:	00056497          	auipc	s1,0x56
    800027b0:	c7448493          	addi	s1,s1,-908 # 80058420 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800027b4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800027b6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800027b8:	00064917          	auipc	s2,0x64
    800027bc:	86890913          	addi	s2,s2,-1944 # 80066020 <tickslock>
    800027c0:	a811                	j	800027d4 <wakeup+0x3c>
      }
      release(&p->lock);
    800027c2:	8526                	mv	a0,s1
    800027c4:	ffffe097          	auipc	ra,0xffffe
    800027c8:	620080e7          	jalr	1568(ra) # 80000de4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800027cc:	37048493          	addi	s1,s1,880
    800027d0:	03248663          	beq	s1,s2,800027fc <wakeup+0x64>
    if(p != myproc()){
    800027d4:	fffff097          	auipc	ra,0xfffff
    800027d8:	6aa080e7          	jalr	1706(ra) # 80001e7e <myproc>
    800027dc:	fe9508e3          	beq	a0,s1,800027cc <wakeup+0x34>
      acquire(&p->lock);
    800027e0:	8526                	mv	a0,s1
    800027e2:	ffffe097          	auipc	ra,0xffffe
    800027e6:	552080e7          	jalr	1362(ra) # 80000d34 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800027ea:	4c9c                	lw	a5,24(s1)
    800027ec:	fd379be3          	bne	a5,s3,800027c2 <wakeup+0x2a>
    800027f0:	709c                	ld	a5,32(s1)
    800027f2:	fd4798e3          	bne	a5,s4,800027c2 <wakeup+0x2a>
        p->state = RUNNABLE;
    800027f6:	0154ac23          	sw	s5,24(s1)
    800027fa:	b7e1                	j	800027c2 <wakeup+0x2a>
    }
  }
}
    800027fc:	70e2                	ld	ra,56(sp)
    800027fe:	7442                	ld	s0,48(sp)
    80002800:	74a2                	ld	s1,40(sp)
    80002802:	7902                	ld	s2,32(sp)
    80002804:	69e2                	ld	s3,24(sp)
    80002806:	6a42                	ld	s4,16(sp)
    80002808:	6aa2                	ld	s5,8(sp)
    8000280a:	6121                	addi	sp,sp,64
    8000280c:	8082                	ret

000000008000280e <reparent>:
{
    8000280e:	7179                	addi	sp,sp,-48
    80002810:	f406                	sd	ra,40(sp)
    80002812:	f022                	sd	s0,32(sp)
    80002814:	ec26                	sd	s1,24(sp)
    80002816:	e84a                	sd	s2,16(sp)
    80002818:	e44e                	sd	s3,8(sp)
    8000281a:	e052                	sd	s4,0(sp)
    8000281c:	1800                	addi	s0,sp,48
    8000281e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002820:	00056497          	auipc	s1,0x56
    80002824:	c0048493          	addi	s1,s1,-1024 # 80058420 <proc>
      pp->parent = initproc;
    80002828:	0000da17          	auipc	s4,0xd
    8000282c:	530a0a13          	addi	s4,s4,1328 # 8000fd58 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002830:	00063997          	auipc	s3,0x63
    80002834:	7f098993          	addi	s3,s3,2032 # 80066020 <tickslock>
    80002838:	a029                	j	80002842 <reparent+0x34>
    8000283a:	37048493          	addi	s1,s1,880
    8000283e:	01348d63          	beq	s1,s3,80002858 <reparent+0x4a>
    if(pp->parent == p){
    80002842:	7c9c                	ld	a5,56(s1)
    80002844:	ff279be3          	bne	a5,s2,8000283a <reparent+0x2c>
      pp->parent = initproc;
    80002848:	000a3503          	ld	a0,0(s4)
    8000284c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000284e:	00000097          	auipc	ra,0x0
    80002852:	f4a080e7          	jalr	-182(ra) # 80002798 <wakeup>
    80002856:	b7d5                	j	8000283a <reparent+0x2c>
}
    80002858:	70a2                	ld	ra,40(sp)
    8000285a:	7402                	ld	s0,32(sp)
    8000285c:	64e2                	ld	s1,24(sp)
    8000285e:	6942                	ld	s2,16(sp)
    80002860:	69a2                	ld	s3,8(sp)
    80002862:	6a02                	ld	s4,0(sp)
    80002864:	6145                	addi	sp,sp,48
    80002866:	8082                	ret

0000000080002868 <thread_exit>:
uint64 thread_exit(uint64 status) {
    80002868:	7179                	addi	sp,sp,-48
    8000286a:	f406                	sd	ra,40(sp)
    8000286c:	f022                	sd	s0,32(sp)
    8000286e:	ec26                	sd	s1,24(sp)
    80002870:	e84a                	sd	s2,16(sp)
    80002872:	e44e                	sd	s3,8(sp)
    80002874:	e052                	sd	s4,0(sp)
    80002876:	1800                	addi	s0,sp,48
    80002878:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000287a:	fffff097          	auipc	ra,0xfffff
    8000287e:	604080e7          	jalr	1540(ra) # 80001e7e <myproc>
    80002882:	89aa                	mv	s3,a0
  if(p == initproc)
    80002884:	0000d797          	auipc	a5,0xd
    80002888:	4d47b783          	ld	a5,1236(a5) # 8000fd58 <initproc>
    8000288c:	0d050493          	addi	s1,a0,208
    80002890:	15050913          	addi	s2,a0,336
    80002894:	00a79d63          	bne	a5,a0,800028ae <thread_exit+0x46>
    panic("init exiting");
    80002898:	00009517          	auipc	a0,0x9
    8000289c:	a1050513          	addi	a0,a0,-1520 # 8000b2a8 <etext+0x2a8>
    800028a0:	ffffe097          	auipc	ra,0xffffe
    800028a4:	cbe080e7          	jalr	-834(ra) # 8000055e <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800028a8:	04a1                	addi	s1,s1,8
    800028aa:	01248b63          	beq	s1,s2,800028c0 <thread_exit+0x58>
    if(p->ofile[fd]){
    800028ae:	6088                	ld	a0,0(s1)
    800028b0:	dd65                	beqz	a0,800028a8 <thread_exit+0x40>
      fileclose(f);
    800028b2:	00003097          	auipc	ra,0x3
    800028b6:	bd6080e7          	jalr	-1066(ra) # 80005488 <fileclose>
      p->ofile[fd] = 0;
    800028ba:	0004b023          	sd	zero,0(s1)
    800028be:	b7ed                	j	800028a8 <thread_exit+0x40>
  begin_op();
    800028c0:	00002097          	auipc	ra,0x2
    800028c4:	6e6080e7          	jalr	1766(ra) # 80004fa6 <begin_op>
  iput(p->cwd);
    800028c8:	1509b503          	ld	a0,336(s3)
    800028cc:	00002097          	auipc	ra,0x2
    800028d0:	ea8080e7          	jalr	-344(ra) # 80004774 <iput>
  end_op();
    800028d4:	00002097          	auipc	ra,0x2
    800028d8:	752080e7          	jalr	1874(ra) # 80005026 <end_op>
  p->cwd = 0;
    800028dc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800028e0:	00055517          	auipc	a0,0x55
    800028e4:	72850513          	addi	a0,a0,1832 # 80058008 <wait_lock>
    800028e8:	ffffe097          	auipc	ra,0xffffe
    800028ec:	44c080e7          	jalr	1100(ra) # 80000d34 <acquire>
  reparent(p);
    800028f0:	854e                	mv	a0,s3
    800028f2:	00000097          	auipc	ra,0x0
    800028f6:	f1c080e7          	jalr	-228(ra) # 8000280e <reparent>
  wakeup(p->parent);
    800028fa:	0389b503          	ld	a0,56(s3)
    800028fe:	00000097          	auipc	ra,0x0
    80002902:	e9a080e7          	jalr	-358(ra) # 80002798 <wakeup>
  acquire(&p->lock);
    80002906:	854e                	mv	a0,s3
    80002908:	ffffe097          	auipc	ra,0xffffe
    8000290c:	42c080e7          	jalr	1068(ra) # 80000d34 <acquire>
  p->xstate = status;
    80002910:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002914:	4795                	li	a5,5
    80002916:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000291a:	00055517          	auipc	a0,0x55
    8000291e:	6ee50513          	addi	a0,a0,1774 # 80058008 <wait_lock>
    80002922:	ffffe097          	auipc	ra,0xffffe
    80002926:	4c2080e7          	jalr	1218(ra) # 80000de4 <release>
  sched();
    8000292a:	00000097          	auipc	ra,0x0
    8000292e:	cf6080e7          	jalr	-778(ra) # 80002620 <sched>
  panic("zombie exit");
    80002932:	00009517          	auipc	a0,0x9
    80002936:	98650513          	addi	a0,a0,-1658 # 8000b2b8 <etext+0x2b8>
    8000293a:	ffffe097          	auipc	ra,0xffffe
    8000293e:	c24080e7          	jalr	-988(ra) # 8000055e <panic>

0000000080002942 <exit>:
{
    80002942:	711d                	addi	sp,sp,-96
    80002944:	ec86                	sd	ra,88(sp)
    80002946:	e8a2                	sd	s0,80(sp)
    80002948:	e4a6                	sd	s1,72(sp)
    8000294a:	e0ca                	sd	s2,64(sp)
    8000294c:	fc4e                	sd	s3,56(sp)
    8000294e:	f852                	sd	s4,48(sp)
    80002950:	f456                	sd	s5,40(sp)
    80002952:	f05a                	sd	s6,32(sp)
    80002954:	ec5e                	sd	s7,24(sp)
    80002956:	e862                	sd	s8,16(sp)
    80002958:	e466                	sd	s9,8(sp)
    8000295a:	1080                	addi	s0,sp,96
    8000295c:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000295e:	fffff097          	auipc	ra,0xfffff
    80002962:	520080e7          	jalr	1312(ra) # 80001e7e <myproc>
    80002966:	8c2a                	mv	s8,a0
  if (p->is_thread) {
    80002968:	16852783          	lw	a5,360(a0)
    8000296c:	cfc9                	beqz	a5,80002a06 <exit+0xc4>
    for (int i = 0; i < MAX_THREADS; i++) {
    8000296e:	03853b03          	ld	s6,56(a0)
    80002972:	170b0a13          	addi	s4,s6,368
    80002976:	370b0b13          	addi	s6,s6,880
      acquire(&wait_lock);
    8000297a:	00055a97          	auipc	s5,0x55
    8000297e:	68ea8a93          	addi	s5,s5,1678 # 80058008 <wait_lock>
      infant->state = ZOMBIE;
    80002982:	4c95                	li	s9,5
    80002984:	a885                	j	800029f4 <exit+0xb2>
          fileclose(f);
    80002986:	00003097          	auipc	ra,0x3
    8000298a:	b02080e7          	jalr	-1278(ra) # 80005488 <fileclose>
          infant->ofile[fd] = 0;
    8000298e:	0004b023          	sd	zero,0(s1)
      for(int fd = 0; fd < NOFILE; fd++){
    80002992:	04a1                	addi	s1,s1,8
    80002994:	01248563          	beq	s1,s2,8000299e <exit+0x5c>
        if(infant->ofile[fd]){
    80002998:	6088                	ld	a0,0(s1)
    8000299a:	f575                	bnez	a0,80002986 <exit+0x44>
    8000299c:	bfdd                	j	80002992 <exit+0x50>
      begin_op();
    8000299e:	00002097          	auipc	ra,0x2
    800029a2:	608080e7          	jalr	1544(ra) # 80004fa6 <begin_op>
      iput(infant->cwd);
    800029a6:	1509b503          	ld	a0,336(s3)
    800029aa:	00002097          	auipc	ra,0x2
    800029ae:	dca080e7          	jalr	-566(ra) # 80004774 <iput>
      end_op();
    800029b2:	00002097          	auipc	ra,0x2
    800029b6:	674080e7          	jalr	1652(ra) # 80005026 <end_op>
      infant->cwd = 0;
    800029ba:	1409b823          	sd	zero,336(s3)
      acquire(&wait_lock);
    800029be:	8556                	mv	a0,s5
    800029c0:	ffffe097          	auipc	ra,0xffffe
    800029c4:	374080e7          	jalr	884(ra) # 80000d34 <acquire>
      acquire(&infant->lock);
    800029c8:	854e                	mv	a0,s3
    800029ca:	ffffe097          	auipc	ra,0xffffe
    800029ce:	36a080e7          	jalr	874(ra) # 80000d34 <acquire>
      infant->xstate = status;
    800029d2:	0379a623          	sw	s7,44(s3)
      infant->state = ZOMBIE;
    800029d6:	0199ac23          	sw	s9,24(s3)
      release(&infant->lock);
    800029da:	854e                	mv	a0,s3
    800029dc:	ffffe097          	auipc	ra,0xffffe
    800029e0:	408080e7          	jalr	1032(ra) # 80000de4 <release>
      release(&wait_lock);
    800029e4:	8556                	mv	a0,s5
    800029e6:	ffffe097          	auipc	ra,0xffffe
    800029ea:	3fe080e7          	jalr	1022(ra) # 80000de4 <release>
    for (int i = 0; i < MAX_THREADS; i++) {
    800029ee:	0a21                	addi	s4,s4,8
    800029f0:	016a0b63          	beq	s4,s6,80002a06 <exit+0xc4>
      struct proc *infant = parent->infant_threads[i];
    800029f4:	000a3983          	ld	s3,0(s4)
      if (infant == 0) 
    800029f8:	fe098be3          	beqz	s3,800029ee <exit+0xac>
    800029fc:	0d098493          	addi	s1,s3,208
    80002a00:	15098913          	addi	s2,s3,336
    80002a04:	bf51                	j	80002998 <exit+0x56>
  if(p == initproc)
    80002a06:	0000d797          	auipc	a5,0xd
    80002a0a:	3527b783          	ld	a5,850(a5) # 8000fd58 <initproc>
    80002a0e:	0d0c0493          	addi	s1,s8,208
    80002a12:	150c0913          	addi	s2,s8,336
    80002a16:	01879d63          	bne	a5,s8,80002a30 <exit+0xee>
    panic("init exiting");
    80002a1a:	00009517          	auipc	a0,0x9
    80002a1e:	88e50513          	addi	a0,a0,-1906 # 8000b2a8 <etext+0x2a8>
    80002a22:	ffffe097          	auipc	ra,0xffffe
    80002a26:	b3c080e7          	jalr	-1220(ra) # 8000055e <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002a2a:	04a1                	addi	s1,s1,8
    80002a2c:	01248b63          	beq	s1,s2,80002a42 <exit+0x100>
    if(p->ofile[fd]){
    80002a30:	6088                	ld	a0,0(s1)
    80002a32:	dd65                	beqz	a0,80002a2a <exit+0xe8>
      fileclose(f);
    80002a34:	00003097          	auipc	ra,0x3
    80002a38:	a54080e7          	jalr	-1452(ra) # 80005488 <fileclose>
      p->ofile[fd] = 0;
    80002a3c:	0004b023          	sd	zero,0(s1)
    80002a40:	b7ed                	j	80002a2a <exit+0xe8>
  begin_op();
    80002a42:	00002097          	auipc	ra,0x2
    80002a46:	564080e7          	jalr	1380(ra) # 80004fa6 <begin_op>
  iput(p->cwd);
    80002a4a:	150c3503          	ld	a0,336(s8)
    80002a4e:	00002097          	auipc	ra,0x2
    80002a52:	d26080e7          	jalr	-730(ra) # 80004774 <iput>
  end_op();
    80002a56:	00002097          	auipc	ra,0x2
    80002a5a:	5d0080e7          	jalr	1488(ra) # 80005026 <end_op>
  p->cwd = 0;
    80002a5e:	140c3823          	sd	zero,336(s8)
  acquire(&wait_lock);
    80002a62:	00055517          	auipc	a0,0x55
    80002a66:	5a650513          	addi	a0,a0,1446 # 80058008 <wait_lock>
    80002a6a:	ffffe097          	auipc	ra,0xffffe
    80002a6e:	2ca080e7          	jalr	714(ra) # 80000d34 <acquire>
  reparent(p);
    80002a72:	8562                	mv	a0,s8
    80002a74:	00000097          	auipc	ra,0x0
    80002a78:	d9a080e7          	jalr	-614(ra) # 8000280e <reparent>
  wakeup(p->parent);
    80002a7c:	038c3503          	ld	a0,56(s8)
    80002a80:	00000097          	auipc	ra,0x0
    80002a84:	d18080e7          	jalr	-744(ra) # 80002798 <wakeup>
  acquire(&p->lock);
    80002a88:	8562                	mv	a0,s8
    80002a8a:	ffffe097          	auipc	ra,0xffffe
    80002a8e:	2aa080e7          	jalr	682(ra) # 80000d34 <acquire>
  p->xstate = status;
    80002a92:	037c2623          	sw	s7,44(s8)
  p->state = ZOMBIE;
    80002a96:	4795                	li	a5,5
    80002a98:	00fc2c23          	sw	a5,24(s8)
  release(&wait_lock);
    80002a9c:	00055517          	auipc	a0,0x55
    80002aa0:	56c50513          	addi	a0,a0,1388 # 80058008 <wait_lock>
    80002aa4:	ffffe097          	auipc	ra,0xffffe
    80002aa8:	340080e7          	jalr	832(ra) # 80000de4 <release>
  sched();
    80002aac:	00000097          	auipc	ra,0x0
    80002ab0:	b74080e7          	jalr	-1164(ra) # 80002620 <sched>
  panic("zombie exit");
    80002ab4:	00009517          	auipc	a0,0x9
    80002ab8:	80450513          	addi	a0,a0,-2044 # 8000b2b8 <etext+0x2b8>
    80002abc:	ffffe097          	auipc	ra,0xffffe
    80002ac0:	aa2080e7          	jalr	-1374(ra) # 8000055e <panic>

0000000080002ac4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002ac4:	7179                	addi	sp,sp,-48
    80002ac6:	f406                	sd	ra,40(sp)
    80002ac8:	f022                	sd	s0,32(sp)
    80002aca:	ec26                	sd	s1,24(sp)
    80002acc:	e84a                	sd	s2,16(sp)
    80002ace:	e44e                	sd	s3,8(sp)
    80002ad0:	1800                	addi	s0,sp,48
    80002ad2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002ad4:	00056497          	auipc	s1,0x56
    80002ad8:	94c48493          	addi	s1,s1,-1716 # 80058420 <proc>
    80002adc:	00063997          	auipc	s3,0x63
    80002ae0:	54498993          	addi	s3,s3,1348 # 80066020 <tickslock>
    acquire(&p->lock);
    80002ae4:	8526                	mv	a0,s1
    80002ae6:	ffffe097          	auipc	ra,0xffffe
    80002aea:	24e080e7          	jalr	590(ra) # 80000d34 <acquire>
    if(p->pid == pid){
    80002aee:	589c                	lw	a5,48(s1)
    80002af0:	01278d63          	beq	a5,s2,80002b0a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002af4:	8526                	mv	a0,s1
    80002af6:	ffffe097          	auipc	ra,0xffffe
    80002afa:	2ee080e7          	jalr	750(ra) # 80000de4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002afe:	37048493          	addi	s1,s1,880
    80002b02:	ff3491e3          	bne	s1,s3,80002ae4 <kill+0x20>
  }
  return -1;
    80002b06:	557d                	li	a0,-1
    80002b08:	a829                	j	80002b22 <kill+0x5e>
      p->killed = 1;
    80002b0a:	4785                	li	a5,1
    80002b0c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002b0e:	4c98                	lw	a4,24(s1)
    80002b10:	4789                	li	a5,2
    80002b12:	00f70f63          	beq	a4,a5,80002b30 <kill+0x6c>
      release(&p->lock);
    80002b16:	8526                	mv	a0,s1
    80002b18:	ffffe097          	auipc	ra,0xffffe
    80002b1c:	2cc080e7          	jalr	716(ra) # 80000de4 <release>
      return 0;
    80002b20:	4501                	li	a0,0
}
    80002b22:	70a2                	ld	ra,40(sp)
    80002b24:	7402                	ld	s0,32(sp)
    80002b26:	64e2                	ld	s1,24(sp)
    80002b28:	6942                	ld	s2,16(sp)
    80002b2a:	69a2                	ld	s3,8(sp)
    80002b2c:	6145                	addi	sp,sp,48
    80002b2e:	8082                	ret
        p->state = RUNNABLE;
    80002b30:	478d                	li	a5,3
    80002b32:	cc9c                	sw	a5,24(s1)
    80002b34:	b7cd                	j	80002b16 <kill+0x52>

0000000080002b36 <setkilled>:

void
setkilled(struct proc *p)
{
    80002b36:	1101                	addi	sp,sp,-32
    80002b38:	ec06                	sd	ra,24(sp)
    80002b3a:	e822                	sd	s0,16(sp)
    80002b3c:	e426                	sd	s1,8(sp)
    80002b3e:	1000                	addi	s0,sp,32
    80002b40:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002b42:	ffffe097          	auipc	ra,0xffffe
    80002b46:	1f2080e7          	jalr	498(ra) # 80000d34 <acquire>
  p->killed = 1;
    80002b4a:	4785                	li	a5,1
    80002b4c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002b4e:	8526                	mv	a0,s1
    80002b50:	ffffe097          	auipc	ra,0xffffe
    80002b54:	294080e7          	jalr	660(ra) # 80000de4 <release>
}
    80002b58:	60e2                	ld	ra,24(sp)
    80002b5a:	6442                	ld	s0,16(sp)
    80002b5c:	64a2                	ld	s1,8(sp)
    80002b5e:	6105                	addi	sp,sp,32
    80002b60:	8082                	ret

0000000080002b62 <killed>:

int
killed(struct proc *p)
{
    80002b62:	1101                	addi	sp,sp,-32
    80002b64:	ec06                	sd	ra,24(sp)
    80002b66:	e822                	sd	s0,16(sp)
    80002b68:	e426                	sd	s1,8(sp)
    80002b6a:	e04a                	sd	s2,0(sp)
    80002b6c:	1000                	addi	s0,sp,32
    80002b6e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002b70:	ffffe097          	auipc	ra,0xffffe
    80002b74:	1c4080e7          	jalr	452(ra) # 80000d34 <acquire>
  k = p->killed;
    80002b78:	549c                	lw	a5,40(s1)
    80002b7a:	893e                	mv	s2,a5
  release(&p->lock);
    80002b7c:	8526                	mv	a0,s1
    80002b7e:	ffffe097          	auipc	ra,0xffffe
    80002b82:	266080e7          	jalr	614(ra) # 80000de4 <release>
  return k;
}
    80002b86:	854a                	mv	a0,s2
    80002b88:	60e2                	ld	ra,24(sp)
    80002b8a:	6442                	ld	s0,16(sp)
    80002b8c:	64a2                	ld	s1,8(sp)
    80002b8e:	6902                	ld	s2,0(sp)
    80002b90:	6105                	addi	sp,sp,32
    80002b92:	8082                	ret

0000000080002b94 <join_thread>:
uint64 join_thread(uint64 thread_id, uint64 status_addr) {
    80002b94:	715d                	addi	sp,sp,-80
    80002b96:	e486                	sd	ra,72(sp)
    80002b98:	e0a2                	sd	s0,64(sp)
    80002b9a:	fc26                	sd	s1,56(sp)
    80002b9c:	f84a                	sd	s2,48(sp)
    80002b9e:	f44e                	sd	s3,40(sp)
    80002ba0:	f052                	sd	s4,32(sp)
    80002ba2:	e45e                	sd	s7,8(sp)
    80002ba4:	0880                	addi	s0,sp,80
    80002ba6:	8a2a                	mv	s4,a0
    80002ba8:	8bae                	mv	s7,a1
  struct proc *p = myproc();
    80002baa:	fffff097          	auipc	ra,0xfffff
    80002bae:	2d4080e7          	jalr	724(ra) # 80001e7e <myproc>
    80002bb2:	89aa                	mv	s3,a0
  if (p->is_thread) 
    80002bb4:	16852783          	lw	a5,360(a0)
    80002bb8:	c399                	beqz	a5,80002bbe <join_thread+0x2a>
    p = p->parent;
    80002bba:	03853983          	ld	s3,56(a0)
  acquire(&wait_lock);
    80002bbe:	00055517          	auipc	a0,0x55
    80002bc2:	44a50513          	addi	a0,a0,1098 # 80058008 <wait_lock>
    80002bc6:	ffffe097          	auipc	ra,0xffffe
    80002bca:	16e080e7          	jalr	366(ra) # 80000d34 <acquire>
  for (thread_idx = 0; thread_idx < MAX_THREADS; thread_idx++) {
    80002bce:	17098793          	addi	a5,s3,368
    80002bd2:	4901                	li	s2,0
    80002bd4:	04000693          	li	a3,64
    80002bd8:	a029                	j	80002be2 <join_thread+0x4e>
    80002bda:	2905                	addiw	s2,s2,1
    80002bdc:	07a1                	addi	a5,a5,8
    80002bde:	0ed90263          	beq	s2,a3,80002cc2 <join_thread+0x12e>
    if (p->infant_threads[thread_idx] && thread_id == p->infant_threads[thread_idx]->pid) {
    80002be2:	6384                	ld	s1,0(a5)
    80002be4:	d8fd                	beqz	s1,80002bda <join_thread+0x46>
    80002be6:	5898                	lw	a4,48(s1)
    80002be8:	ff4719e3          	bne	a4,s4,80002bda <join_thread+0x46>
    80002bec:	ec56                	sd	s5,24(sp)
    80002bee:	e85a                	sd	s6,16(sp)
    if (child->state == ZOMBIE) {
    80002bf0:	4a95                	li	s5,5
    sleep(p, &wait_lock);
    80002bf2:	00055b17          	auipc	s6,0x55
    80002bf6:	416b0b13          	addi	s6,s6,1046 # 80058008 <wait_lock>
    acquire(&child->lock);
    80002bfa:	8526                	mv	a0,s1
    80002bfc:	ffffe097          	auipc	ra,0xffffe
    80002c00:	138080e7          	jalr	312(ra) # 80000d34 <acquire>
    if (child->state == ZOMBIE) {
    80002c04:	4c9c                	lw	a5,24(s1)
    80002c06:	03578463          	beq	a5,s5,80002c2e <join_thread+0x9a>
    release(&child->lock);
    80002c0a:	8526                	mv	a0,s1
    80002c0c:	ffffe097          	auipc	ra,0xffffe
    80002c10:	1d8080e7          	jalr	472(ra) # 80000de4 <release>
    if (killed(p)) {
    80002c14:	854e                	mv	a0,s3
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	f4c080e7          	jalr	-180(ra) # 80002b62 <killed>
    80002c1e:	ed35                	bnez	a0,80002c9a <join_thread+0x106>
    sleep(p, &wait_lock);
    80002c20:	85da                	mv	a1,s6
    80002c22:	854e                	mv	a0,s3
    80002c24:	00000097          	auipc	ra,0x0
    80002c28:	b10080e7          	jalr	-1264(ra) # 80002734 <sleep>
    acquire(&child->lock);
    80002c2c:	b7f9                	j	80002bfa <join_thread+0x66>
      if (status_addr != 0 && copyout(p->pagetable, status_addr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
    80002c2e:	000b8e63          	beqz	s7,80002c4a <join_thread+0xb6>
    80002c32:	4691                	li	a3,4
    80002c34:	02c48613          	addi	a2,s1,44
    80002c38:	85de                	mv	a1,s7
    80002c3a:	0509b503          	ld	a0,80(s3)
    80002c3e:	fffff097          	auipc	ra,0xfffff
    80002c42:	ecc080e7          	jalr	-308(ra) # 80001b0a <copyout>
    80002c46:	02054963          	bltz	a0,80002c78 <join_thread+0xe4>
      release(&child->lock);
    80002c4a:	8526                	mv	a0,s1
    80002c4c:	ffffe097          	auipc	ra,0xffffe
    80002c50:	198080e7          	jalr	408(ra) # 80000de4 <release>
      release(&wait_lock);
    80002c54:	00055517          	auipc	a0,0x55
    80002c58:	3b450513          	addi	a0,a0,948 # 80058008 <wait_lock>
    80002c5c:	ffffe097          	auipc	ra,0xffffe
    80002c60:	188080e7          	jalr	392(ra) # 80000de4 <release>
      p->infant_threads[thread_idx] = 0;
    80002c64:	090e                	slli	s2,s2,0x3
    80002c66:	17090913          	addi	s2,s2,368
    80002c6a:	99ca                	add	s3,s3,s2
    80002c6c:	0009b023          	sd	zero,0(s3)
      return thread_id;
    80002c70:	8552                	mv	a0,s4
    80002c72:	6ae2                	ld	s5,24(sp)
    80002c74:	6b42                	ld	s6,16(sp)
    80002c76:	a82d                	j	80002cb0 <join_thread+0x11c>
        release(&child->lock);
    80002c78:	8526                	mv	a0,s1
    80002c7a:	ffffe097          	auipc	ra,0xffffe
    80002c7e:	16a080e7          	jalr	362(ra) # 80000de4 <release>
        release(&wait_lock);
    80002c82:	00055517          	auipc	a0,0x55
    80002c86:	38650513          	addi	a0,a0,902 # 80058008 <wait_lock>
    80002c8a:	ffffe097          	auipc	ra,0xffffe
    80002c8e:	15a080e7          	jalr	346(ra) # 80000de4 <release>
        return -1;
    80002c92:	557d                	li	a0,-1
    80002c94:	6ae2                	ld	s5,24(sp)
    80002c96:	6b42                	ld	s6,16(sp)
    80002c98:	a821                	j	80002cb0 <join_thread+0x11c>
      release(&wait_lock);
    80002c9a:	00055517          	auipc	a0,0x55
    80002c9e:	36e50513          	addi	a0,a0,878 # 80058008 <wait_lock>
    80002ca2:	ffffe097          	auipc	ra,0xffffe
    80002ca6:	142080e7          	jalr	322(ra) # 80000de4 <release>
      return -1;
    80002caa:	557d                	li	a0,-1
    80002cac:	6ae2                	ld	s5,24(sp)
    80002cae:	6b42                	ld	s6,16(sp)
}
    80002cb0:	60a6                	ld	ra,72(sp)
    80002cb2:	6406                	ld	s0,64(sp)
    80002cb4:	74e2                	ld	s1,56(sp)
    80002cb6:	7942                	ld	s2,48(sp)
    80002cb8:	79a2                	ld	s3,40(sp)
    80002cba:	7a02                	ld	s4,32(sp)
    80002cbc:	6ba2                	ld	s7,8(sp)
    80002cbe:	6161                	addi	sp,sp,80
    80002cc0:	8082                	ret
    release(&wait_lock);
    80002cc2:	00055517          	auipc	a0,0x55
    80002cc6:	34650513          	addi	a0,a0,838 # 80058008 <wait_lock>
    80002cca:	ffffe097          	auipc	ra,0xffffe
    80002cce:	11a080e7          	jalr	282(ra) # 80000de4 <release>
    return -1;
    80002cd2:	557d                	li	a0,-1
    80002cd4:	bff1                	j	80002cb0 <join_thread+0x11c>

0000000080002cd6 <wait>:
{
    80002cd6:	715d                	addi	sp,sp,-80
    80002cd8:	e486                	sd	ra,72(sp)
    80002cda:	e0a2                	sd	s0,64(sp)
    80002cdc:	fc26                	sd	s1,56(sp)
    80002cde:	f84a                	sd	s2,48(sp)
    80002ce0:	f44e                	sd	s3,40(sp)
    80002ce2:	f052                	sd	s4,32(sp)
    80002ce4:	ec56                	sd	s5,24(sp)
    80002ce6:	e85a                	sd	s6,16(sp)
    80002ce8:	e45e                	sd	s7,8(sp)
    80002cea:	0880                	addi	s0,sp,80
    80002cec:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002cee:	fffff097          	auipc	ra,0xfffff
    80002cf2:	190080e7          	jalr	400(ra) # 80001e7e <myproc>
    80002cf6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002cf8:	00055517          	auipc	a0,0x55
    80002cfc:	31050513          	addi	a0,a0,784 # 80058008 <wait_lock>
    80002d00:	ffffe097          	auipc	ra,0xffffe
    80002d04:	034080e7          	jalr	52(ra) # 80000d34 <acquire>
        if(pp->state == ZOMBIE){
    80002d08:	4a15                	li	s4,5
        havekids = 1;
    80002d0a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002d0c:	00063997          	auipc	s3,0x63
    80002d10:	31498993          	addi	s3,s3,788 # 80066020 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002d14:	00055b17          	auipc	s6,0x55
    80002d18:	2f4b0b13          	addi	s6,s6,756 # 80058008 <wait_lock>
    80002d1c:	a0c9                	j	80002dde <wait+0x108>
          pid = pp->pid;
    80002d1e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002d22:	000b8e63          	beqz	s7,80002d3e <wait+0x68>
    80002d26:	4691                	li	a3,4
    80002d28:	02c48613          	addi	a2,s1,44
    80002d2c:	85de                	mv	a1,s7
    80002d2e:	05093503          	ld	a0,80(s2)
    80002d32:	fffff097          	auipc	ra,0xfffff
    80002d36:	dd8080e7          	jalr	-552(ra) # 80001b0a <copyout>
    80002d3a:	04054063          	bltz	a0,80002d7a <wait+0xa4>
          freeproc(pp);
    80002d3e:	8526                	mv	a0,s1
    80002d40:	fffff097          	auipc	ra,0xfffff
    80002d44:	2f2080e7          	jalr	754(ra) # 80002032 <freeproc>
          release(&pp->lock);
    80002d48:	8526                	mv	a0,s1
    80002d4a:	ffffe097          	auipc	ra,0xffffe
    80002d4e:	09a080e7          	jalr	154(ra) # 80000de4 <release>
          release(&wait_lock);
    80002d52:	00055517          	auipc	a0,0x55
    80002d56:	2b650513          	addi	a0,a0,694 # 80058008 <wait_lock>
    80002d5a:	ffffe097          	auipc	ra,0xffffe
    80002d5e:	08a080e7          	jalr	138(ra) # 80000de4 <release>
}
    80002d62:	854e                	mv	a0,s3
    80002d64:	60a6                	ld	ra,72(sp)
    80002d66:	6406                	ld	s0,64(sp)
    80002d68:	74e2                	ld	s1,56(sp)
    80002d6a:	7942                	ld	s2,48(sp)
    80002d6c:	79a2                	ld	s3,40(sp)
    80002d6e:	7a02                	ld	s4,32(sp)
    80002d70:	6ae2                	ld	s5,24(sp)
    80002d72:	6b42                	ld	s6,16(sp)
    80002d74:	6ba2                	ld	s7,8(sp)
    80002d76:	6161                	addi	sp,sp,80
    80002d78:	8082                	ret
            release(&pp->lock);
    80002d7a:	8526                	mv	a0,s1
    80002d7c:	ffffe097          	auipc	ra,0xffffe
    80002d80:	068080e7          	jalr	104(ra) # 80000de4 <release>
            release(&wait_lock);
    80002d84:	00055517          	auipc	a0,0x55
    80002d88:	28450513          	addi	a0,a0,644 # 80058008 <wait_lock>
    80002d8c:	ffffe097          	auipc	ra,0xffffe
    80002d90:	058080e7          	jalr	88(ra) # 80000de4 <release>
            return -1;
    80002d94:	59fd                	li	s3,-1
    80002d96:	b7f1                	j	80002d62 <wait+0x8c>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002d98:	37048493          	addi	s1,s1,880
    80002d9c:	03348463          	beq	s1,s3,80002dc4 <wait+0xee>
      if(pp->parent == p){
    80002da0:	7c9c                	ld	a5,56(s1)
    80002da2:	ff279be3          	bne	a5,s2,80002d98 <wait+0xc2>
        acquire(&pp->lock);
    80002da6:	8526                	mv	a0,s1
    80002da8:	ffffe097          	auipc	ra,0xffffe
    80002dac:	f8c080e7          	jalr	-116(ra) # 80000d34 <acquire>
        if(pp->state == ZOMBIE){
    80002db0:	4c9c                	lw	a5,24(s1)
    80002db2:	f74786e3          	beq	a5,s4,80002d1e <wait+0x48>
        release(&pp->lock);
    80002db6:	8526                	mv	a0,s1
    80002db8:	ffffe097          	auipc	ra,0xffffe
    80002dbc:	02c080e7          	jalr	44(ra) # 80000de4 <release>
        havekids = 1;
    80002dc0:	8756                	mv	a4,s5
    80002dc2:	bfd9                	j	80002d98 <wait+0xc2>
    if(!havekids || killed(p)){
    80002dc4:	c31d                	beqz	a4,80002dea <wait+0x114>
    80002dc6:	854a                	mv	a0,s2
    80002dc8:	00000097          	auipc	ra,0x0
    80002dcc:	d9a080e7          	jalr	-614(ra) # 80002b62 <killed>
    80002dd0:	ed09                	bnez	a0,80002dea <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002dd2:	85da                	mv	a1,s6
    80002dd4:	854a                	mv	a0,s2
    80002dd6:	00000097          	auipc	ra,0x0
    80002dda:	95e080e7          	jalr	-1698(ra) # 80002734 <sleep>
    havekids = 0;
    80002dde:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002de0:	00055497          	auipc	s1,0x55
    80002de4:	64048493          	addi	s1,s1,1600 # 80058420 <proc>
    80002de8:	bf65                	j	80002da0 <wait+0xca>
      release(&wait_lock);
    80002dea:	00055517          	auipc	a0,0x55
    80002dee:	21e50513          	addi	a0,a0,542 # 80058008 <wait_lock>
    80002df2:	ffffe097          	auipc	ra,0xffffe
    80002df6:	ff2080e7          	jalr	-14(ra) # 80000de4 <release>
      return -1;
    80002dfa:	59fd                	li	s3,-1
    80002dfc:	b79d                	j	80002d62 <wait+0x8c>

0000000080002dfe <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002dfe:	7179                	addi	sp,sp,-48
    80002e00:	f406                	sd	ra,40(sp)
    80002e02:	f022                	sd	s0,32(sp)
    80002e04:	ec26                	sd	s1,24(sp)
    80002e06:	e84a                	sd	s2,16(sp)
    80002e08:	e44e                	sd	s3,8(sp)
    80002e0a:	e052                	sd	s4,0(sp)
    80002e0c:	1800                	addi	s0,sp,48
    80002e0e:	84aa                	mv	s1,a0
    80002e10:	8a2e                	mv	s4,a1
    80002e12:	89b2                	mv	s3,a2
    80002e14:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002e16:	fffff097          	auipc	ra,0xfffff
    80002e1a:	068080e7          	jalr	104(ra) # 80001e7e <myproc>
  if(user_dst){
    80002e1e:	c08d                	beqz	s1,80002e40 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002e20:	86ca                	mv	a3,s2
    80002e22:	864e                	mv	a2,s3
    80002e24:	85d2                	mv	a1,s4
    80002e26:	6928                	ld	a0,80(a0)
    80002e28:	fffff097          	auipc	ra,0xfffff
    80002e2c:	ce2080e7          	jalr	-798(ra) # 80001b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002e30:	70a2                	ld	ra,40(sp)
    80002e32:	7402                	ld	s0,32(sp)
    80002e34:	64e2                	ld	s1,24(sp)
    80002e36:	6942                	ld	s2,16(sp)
    80002e38:	69a2                	ld	s3,8(sp)
    80002e3a:	6a02                	ld	s4,0(sp)
    80002e3c:	6145                	addi	sp,sp,48
    80002e3e:	8082                	ret
    memmove((char *)dst, src, len);
    80002e40:	0009061b          	sext.w	a2,s2
    80002e44:	85ce                	mv	a1,s3
    80002e46:	8552                	mv	a0,s4
    80002e48:	ffffe097          	auipc	ra,0xffffe
    80002e4c:	044080e7          	jalr	68(ra) # 80000e8c <memmove>
    return 0;
    80002e50:	8526                	mv	a0,s1
    80002e52:	bff9                	j	80002e30 <either_copyout+0x32>

0000000080002e54 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002e54:	7179                	addi	sp,sp,-48
    80002e56:	f406                	sd	ra,40(sp)
    80002e58:	f022                	sd	s0,32(sp)
    80002e5a:	ec26                	sd	s1,24(sp)
    80002e5c:	e84a                	sd	s2,16(sp)
    80002e5e:	e44e                	sd	s3,8(sp)
    80002e60:	e052                	sd	s4,0(sp)
    80002e62:	1800                	addi	s0,sp,48
    80002e64:	8a2a                	mv	s4,a0
    80002e66:	84ae                	mv	s1,a1
    80002e68:	89b2                	mv	s3,a2
    80002e6a:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002e6c:	fffff097          	auipc	ra,0xfffff
    80002e70:	012080e7          	jalr	18(ra) # 80001e7e <myproc>
  if(user_src){
    80002e74:	c08d                	beqz	s1,80002e96 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002e76:	86ca                	mv	a3,s2
    80002e78:	864e                	mv	a2,s3
    80002e7a:	85d2                	mv	a1,s4
    80002e7c:	6928                	ld	a0,80(a0)
    80002e7e:	fffff097          	auipc	ra,0xfffff
    80002e82:	d18080e7          	jalr	-744(ra) # 80001b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002e86:	70a2                	ld	ra,40(sp)
    80002e88:	7402                	ld	s0,32(sp)
    80002e8a:	64e2                	ld	s1,24(sp)
    80002e8c:	6942                	ld	s2,16(sp)
    80002e8e:	69a2                	ld	s3,8(sp)
    80002e90:	6a02                	ld	s4,0(sp)
    80002e92:	6145                	addi	sp,sp,48
    80002e94:	8082                	ret
    memmove(dst, (char*)src, len);
    80002e96:	0009061b          	sext.w	a2,s2
    80002e9a:	85ce                	mv	a1,s3
    80002e9c:	8552                	mv	a0,s4
    80002e9e:	ffffe097          	auipc	ra,0xffffe
    80002ea2:	fee080e7          	jalr	-18(ra) # 80000e8c <memmove>
    return 0;
    80002ea6:	8526                	mv	a0,s1
    80002ea8:	bff9                	j	80002e86 <either_copyin+0x32>

0000000080002eaa <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002eaa:	715d                	addi	sp,sp,-80
    80002eac:	e486                	sd	ra,72(sp)
    80002eae:	e0a2                	sd	s0,64(sp)
    80002eb0:	fc26                	sd	s1,56(sp)
    80002eb2:	f84a                	sd	s2,48(sp)
    80002eb4:	f44e                	sd	s3,40(sp)
    80002eb6:	f052                	sd	s4,32(sp)
    80002eb8:	ec56                	sd	s5,24(sp)
    80002eba:	e85a                	sd	s6,16(sp)
    80002ebc:	e45e                	sd	s7,8(sp)
    80002ebe:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002ec0:	00008517          	auipc	a0,0x8
    80002ec4:	16050513          	addi	a0,a0,352 # 8000b020 <etext+0x20>
    80002ec8:	ffffd097          	auipc	ra,0xffffd
    80002ecc:	6e0080e7          	jalr	1760(ra) # 800005a8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002ed0:	00055497          	auipc	s1,0x55
    80002ed4:	6a848493          	addi	s1,s1,1704 # 80058578 <proc+0x158>
    80002ed8:	00063917          	auipc	s2,0x63
    80002edc:	2a090913          	addi	s2,s2,672 # 80066178 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ee0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002ee2:	00008997          	auipc	s3,0x8
    80002ee6:	3e698993          	addi	s3,s3,998 # 8000b2c8 <etext+0x2c8>
    printf("%d %s %s", p->pid, state, p->name);
    80002eea:	00008a97          	auipc	s5,0x8
    80002eee:	3e6a8a93          	addi	s5,s5,998 # 8000b2d0 <etext+0x2d0>
    printf("\n");
    80002ef2:	00008a17          	auipc	s4,0x8
    80002ef6:	12ea0a13          	addi	s4,s4,302 # 8000b020 <etext+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002efa:	00009b97          	auipc	s7,0x9
    80002efe:	ff6b8b93          	addi	s7,s7,-10 # 8000bef0 <states.0>
    80002f02:	a00d                	j	80002f24 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002f04:	ed86a583          	lw	a1,-296(a3)
    80002f08:	8556                	mv	a0,s5
    80002f0a:	ffffd097          	auipc	ra,0xffffd
    80002f0e:	69e080e7          	jalr	1694(ra) # 800005a8 <printf>
    printf("\n");
    80002f12:	8552                	mv	a0,s4
    80002f14:	ffffd097          	auipc	ra,0xffffd
    80002f18:	694080e7          	jalr	1684(ra) # 800005a8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002f1c:	37048493          	addi	s1,s1,880
    80002f20:	03248263          	beq	s1,s2,80002f44 <procdump+0x9a>
    if(p->state == UNUSED)
    80002f24:	86a6                	mv	a3,s1
    80002f26:	ec04a783          	lw	a5,-320(s1)
    80002f2a:	dbed                	beqz	a5,80002f1c <procdump+0x72>
      state = "???";
    80002f2c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002f2e:	fcfb6be3          	bltu	s6,a5,80002f04 <procdump+0x5a>
    80002f32:	02079713          	slli	a4,a5,0x20
    80002f36:	01d75793          	srli	a5,a4,0x1d
    80002f3a:	97de                	add	a5,a5,s7
    80002f3c:	6390                	ld	a2,0(a5)
    80002f3e:	f279                	bnez	a2,80002f04 <procdump+0x5a>
      state = "???";
    80002f40:	864e                	mv	a2,s3
    80002f42:	b7c9                	j	80002f04 <procdump+0x5a>
  }
}
    80002f44:	60a6                	ld	ra,72(sp)
    80002f46:	6406                	ld	s0,64(sp)
    80002f48:	74e2                	ld	s1,56(sp)
    80002f4a:	7942                	ld	s2,48(sp)
    80002f4c:	79a2                	ld	s3,40(sp)
    80002f4e:	7a02                	ld	s4,32(sp)
    80002f50:	6ae2                	ld	s5,24(sp)
    80002f52:	6b42                	ld	s6,16(sp)
    80002f54:	6ba2                	ld	s7,8(sp)
    80002f56:	6161                	addi	sp,sp,80
    80002f58:	8082                	ret

0000000080002f5a <spoon>:

uint64 spoon(void *arg)
{
    80002f5a:	1141                	addi	sp,sp,-16
    80002f5c:	e406                	sd	ra,8(sp)
    80002f5e:	e022                	sd	s0,0(sp)
    80002f60:	0800                	addi	s0,sp,16
    80002f62:	85aa                	mv	a1,a0
  // Add your code here...
  printf("In spoon system call with argument %p\n", arg);
    80002f64:	00008517          	auipc	a0,0x8
    80002f68:	37c50513          	addi	a0,a0,892 # 8000b2e0 <etext+0x2e0>
    80002f6c:	ffffd097          	auipc	ra,0xffffd
    80002f70:	63c080e7          	jalr	1596(ra) # 800005a8 <printf>
  return 0;
}
    80002f74:	4501                	li	a0,0
    80002f76:	60a2                	ld	ra,8(sp)
    80002f78:	6402                	ld	s0,0(sp)
    80002f7a:	0141                	addi	sp,sp,16
    80002f7c:	8082                	ret

0000000080002f7e <swtch>:
    80002f7e:	00153023          	sd	ra,0(a0)
    80002f82:	00253423          	sd	sp,8(a0)
    80002f86:	e900                	sd	s0,16(a0)
    80002f88:	ed04                	sd	s1,24(a0)
    80002f8a:	03253023          	sd	s2,32(a0)
    80002f8e:	03353423          	sd	s3,40(a0)
    80002f92:	03453823          	sd	s4,48(a0)
    80002f96:	03553c23          	sd	s5,56(a0)
    80002f9a:	05653023          	sd	s6,64(a0)
    80002f9e:	05753423          	sd	s7,72(a0)
    80002fa2:	05853823          	sd	s8,80(a0)
    80002fa6:	05953c23          	sd	s9,88(a0)
    80002faa:	07a53023          	sd	s10,96(a0)
    80002fae:	07b53423          	sd	s11,104(a0)
    80002fb2:	0005b083          	ld	ra,0(a1)
    80002fb6:	0085b103          	ld	sp,8(a1)
    80002fba:	6980                	ld	s0,16(a1)
    80002fbc:	6d84                	ld	s1,24(a1)
    80002fbe:	0205b903          	ld	s2,32(a1)
    80002fc2:	0285b983          	ld	s3,40(a1)
    80002fc6:	0305ba03          	ld	s4,48(a1)
    80002fca:	0385ba83          	ld	s5,56(a1)
    80002fce:	0405bb03          	ld	s6,64(a1)
    80002fd2:	0485bb83          	ld	s7,72(a1)
    80002fd6:	0505bc03          	ld	s8,80(a1)
    80002fda:	0585bc83          	ld	s9,88(a1)
    80002fde:	0605bd03          	ld	s10,96(a1)
    80002fe2:	0685bd83          	ld	s11,104(a1)
    80002fe6:	8082                	ret

0000000080002fe8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002fe8:	1141                	addi	sp,sp,-16
    80002fea:	e406                	sd	ra,8(sp)
    80002fec:	e022                	sd	s0,0(sp)
    80002fee:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002ff0:	00008597          	auipc	a1,0x8
    80002ff4:	34858593          	addi	a1,a1,840 # 8000b338 <etext+0x338>
    80002ff8:	00063517          	auipc	a0,0x63
    80002ffc:	02850513          	addi	a0,a0,40 # 80066020 <tickslock>
    80003000:	ffffe097          	auipc	ra,0xffffe
    80003004:	c9a080e7          	jalr	-870(ra) # 80000c9a <initlock>
}
    80003008:	60a2                	ld	ra,8(sp)
    8000300a:	6402                	ld	s0,0(sp)
    8000300c:	0141                	addi	sp,sp,16
    8000300e:	8082                	ret

0000000080003010 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003010:	1141                	addi	sp,sp,-16
    80003012:	e406                	sd	ra,8(sp)
    80003014:	e022                	sd	s0,0(sp)
    80003016:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003018:	00004797          	auipc	a5,0x4
    8000301c:	c0878793          	addi	a5,a5,-1016 # 80006c20 <kernelvec>
    80003020:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80003024:	60a2                	ld	ra,8(sp)
    80003026:	6402                	ld	s0,0(sp)
    80003028:	0141                	addi	sp,sp,16
    8000302a:	8082                	ret

000000008000302c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000302c:	1141                	addi	sp,sp,-16
    8000302e:	e406                	sd	ra,8(sp)
    80003030:	e022                	sd	s0,0(sp)
    80003032:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80003034:	fffff097          	auipc	ra,0xfffff
    80003038:	e4a080e7          	jalr	-438(ra) # 80001e7e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000303c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003040:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003042:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003046:	00007697          	auipc	a3,0x7
    8000304a:	fba68693          	addi	a3,a3,-70 # 8000a000 <_trampoline>
    8000304e:	00007717          	auipc	a4,0x7
    80003052:	fb270713          	addi	a4,a4,-78 # 8000a000 <_trampoline>
    80003056:	8f15                	sub	a4,a4,a3
    80003058:	040007b7          	lui	a5,0x4000
    8000305c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000305e:	07b2                	slli	a5,a5,0xc
    80003060:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003062:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003066:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003068:	18002673          	csrr	a2,satp
    8000306c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000306e:	6d30                	ld	a2,88(a0)
    80003070:	6138                	ld	a4,64(a0)
    80003072:	6585                	lui	a1,0x1
    80003074:	972e                	add	a4,a4,a1
    80003076:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003078:	6d38                	ld	a4,88(a0)
    8000307a:	00000617          	auipc	a2,0x0
    8000307e:	14c60613          	addi	a2,a2,332 # 800031c6 <usertrap>
    80003082:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003084:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80003086:	8612                	mv	a2,tp
    80003088:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000308a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000308e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003092:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003096:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000309a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000309c:	6f18                	ld	a4,24(a4)
    8000309e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800030a2:	6928                	ld	a0,80(a0)
    800030a4:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800030a6:	00007717          	auipc	a4,0x7
    800030aa:	ff670713          	addi	a4,a4,-10 # 8000a09c <userret>
    800030ae:	8f15                	sub	a4,a4,a3
    800030b0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800030b2:	577d                	li	a4,-1
    800030b4:	177e                	slli	a4,a4,0x3f
    800030b6:	8d59                	or	a0,a0,a4
    800030b8:	9782                	jalr	a5
}
    800030ba:	60a2                	ld	ra,8(sp)
    800030bc:	6402                	ld	s0,0(sp)
    800030be:	0141                	addi	sp,sp,16
    800030c0:	8082                	ret

00000000800030c2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800030c2:	1141                	addi	sp,sp,-16
    800030c4:	e406                	sd	ra,8(sp)
    800030c6:	e022                	sd	s0,0(sp)
    800030c8:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    800030ca:	00063517          	auipc	a0,0x63
    800030ce:	f5650513          	addi	a0,a0,-170 # 80066020 <tickslock>
    800030d2:	ffffe097          	auipc	ra,0xffffe
    800030d6:	c62080e7          	jalr	-926(ra) # 80000d34 <acquire>
  ticks++;
    800030da:	0000d717          	auipc	a4,0xd
    800030de:	c8a70713          	addi	a4,a4,-886 # 8000fd64 <ticks>
    800030e2:	431c                	lw	a5,0(a4)
    800030e4:	2785                	addiw	a5,a5,1
    800030e6:	c31c                	sw	a5,0(a4)
  wakeup(&ticks);
    800030e8:	853a                	mv	a0,a4
    800030ea:	fffff097          	auipc	ra,0xfffff
    800030ee:	6ae080e7          	jalr	1710(ra) # 80002798 <wakeup>
  release(&tickslock);
    800030f2:	00063517          	auipc	a0,0x63
    800030f6:	f2e50513          	addi	a0,a0,-210 # 80066020 <tickslock>
    800030fa:	ffffe097          	auipc	ra,0xffffe
    800030fe:	cea080e7          	jalr	-790(ra) # 80000de4 <release>
}
    80003102:	60a2                	ld	ra,8(sp)
    80003104:	6402                	ld	s0,0(sp)
    80003106:	0141                	addi	sp,sp,16
    80003108:	8082                	ret

000000008000310a <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000310a:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000310e:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80003110:	0a07da63          	bgez	a5,800031c4 <devintr+0xba>
{
    80003114:	1101                	addi	sp,sp,-32
    80003116:	ec06                	sd	ra,24(sp)
    80003118:	e822                	sd	s0,16(sp)
    8000311a:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    8000311c:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80003120:	46a5                	li	a3,9
    80003122:	00d70c63          	beq	a4,a3,8000313a <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80003126:	577d                	li	a4,-1
    80003128:	177e                	slli	a4,a4,0x3f
    8000312a:	0705                	addi	a4,a4,1
    return 0;
    8000312c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000312e:	06e78a63          	beq	a5,a4,800031a2 <devintr+0x98>
  }
}
    80003132:	60e2                	ld	ra,24(sp)
    80003134:	6442                	ld	s0,16(sp)
    80003136:	6105                	addi	sp,sp,32
    80003138:	8082                	ret
    8000313a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000313c:	00004097          	auipc	ra,0x4
    80003140:	bf2080e7          	jalr	-1038(ra) # 80006d2e <plic_claim>
    80003144:	872a                	mv	a4,a0
    80003146:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80003148:	47a9                	li	a5,10
    8000314a:	00f50c63          	beq	a0,a5,80003162 <devintr+0x58>
    } else if(irq == VIRTIO0_IRQ){
    8000314e:	4785                	li	a5,1
    80003150:	02f50563          	beq	a0,a5,8000317a <devintr+0x70>
    } else if (irq == VIRTIO1_IRQ) {
    80003154:	4789                	li	a5,2
    80003156:	02f50763          	beq	a0,a5,80003184 <devintr+0x7a>
    return 1;
    8000315a:	4505                	li	a0,1
    } else if(irq){
    8000315c:	eb0d                	bnez	a4,8000318e <devintr+0x84>
    8000315e:	64a2                	ld	s1,8(sp)
    80003160:	bfc9                	j	80003132 <devintr+0x28>
      uartintr();
    80003162:	ffffe097          	auipc	ra,0xffffe
    80003166:	89e080e7          	jalr	-1890(ra) # 80000a00 <uartintr>
      plic_complete(irq);
    8000316a:	8526                	mv	a0,s1
    8000316c:	00004097          	auipc	ra,0x4
    80003170:	be6080e7          	jalr	-1050(ra) # 80006d52 <plic_complete>
    return 1;
    80003174:	4505                	li	a0,1
    80003176:	64a2                	ld	s1,8(sp)
    80003178:	bf6d                	j	80003132 <devintr+0x28>
      virtio_disk_intr();
    8000317a:	00004097          	auipc	ra,0x4
    8000317e:	0ae080e7          	jalr	174(ra) # 80007228 <virtio_disk_intr>
    if(irq)
    80003182:	b7e5                	j	8000316a <devintr+0x60>
      receive_packet();
    80003184:	00005097          	auipc	ra,0x5
    80003188:	8a0080e7          	jalr	-1888(ra) # 80007a24 <receive_packet>
    if(irq)
    8000318c:	bff9                	j	8000316a <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    8000318e:	85ba                	mv	a1,a4
    80003190:	00008517          	auipc	a0,0x8
    80003194:	1b050513          	addi	a0,a0,432 # 8000b340 <etext+0x340>
    80003198:	ffffd097          	auipc	ra,0xffffd
    8000319c:	410080e7          	jalr	1040(ra) # 800005a8 <printf>
    if(irq)
    800031a0:	b7e9                	j	8000316a <devintr+0x60>
    if(cpuid() == 0){
    800031a2:	fffff097          	auipc	ra,0xfffff
    800031a6:	ca8080e7          	jalr	-856(ra) # 80001e4a <cpuid>
    800031aa:	c901                	beqz	a0,800031ba <devintr+0xb0>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800031ac:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800031b0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800031b2:	14479073          	csrw	sip,a5
    return 2;
    800031b6:	4509                	li	a0,2
    800031b8:	bfad                	j	80003132 <devintr+0x28>
      clockintr();
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	f08080e7          	jalr	-248(ra) # 800030c2 <clockintr>
    800031c2:	b7ed                	j	800031ac <devintr+0xa2>
}
    800031c4:	8082                	ret

00000000800031c6 <usertrap>:
{
    800031c6:	1101                	addi	sp,sp,-32
    800031c8:	ec06                	sd	ra,24(sp)
    800031ca:	e822                	sd	s0,16(sp)
    800031cc:	e426                	sd	s1,8(sp)
    800031ce:	e04a                	sd	s2,0(sp)
    800031d0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800031d2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800031d6:	1007f793          	andi	a5,a5,256
    800031da:	e3b1                	bnez	a5,8000321e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800031dc:	00004797          	auipc	a5,0x4
    800031e0:	a4478793          	addi	a5,a5,-1468 # 80006c20 <kernelvec>
    800031e4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800031e8:	fffff097          	auipc	ra,0xfffff
    800031ec:	c96080e7          	jalr	-874(ra) # 80001e7e <myproc>
    800031f0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800031f2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800031f4:	14102773          	csrr	a4,sepc
    800031f8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800031fa:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800031fe:	47a1                	li	a5,8
    80003200:	02f70763          	beq	a4,a5,8000322e <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80003204:	00000097          	auipc	ra,0x0
    80003208:	f06080e7          	jalr	-250(ra) # 8000310a <devintr>
    8000320c:	892a                	mv	s2,a0
    8000320e:	c151                	beqz	a0,80003292 <usertrap+0xcc>
  if(killed(p))
    80003210:	8526                	mv	a0,s1
    80003212:	00000097          	auipc	ra,0x0
    80003216:	950080e7          	jalr	-1712(ra) # 80002b62 <killed>
    8000321a:	c929                	beqz	a0,8000326c <usertrap+0xa6>
    8000321c:	a099                	j	80003262 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    8000321e:	00008517          	auipc	a0,0x8
    80003222:	14250513          	addi	a0,a0,322 # 8000b360 <etext+0x360>
    80003226:	ffffd097          	auipc	ra,0xffffd
    8000322a:	338080e7          	jalr	824(ra) # 8000055e <panic>
    if(killed(p))
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	934080e7          	jalr	-1740(ra) # 80002b62 <killed>
    80003236:	e921                	bnez	a0,80003286 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80003238:	6cb8                	ld	a4,88(s1)
    8000323a:	6f1c                	ld	a5,24(a4)
    8000323c:	0791                	addi	a5,a5,4
    8000323e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003240:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003244:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003248:	10079073          	csrw	sstatus,a5
    syscall();
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	2ce080e7          	jalr	718(ra) # 8000351a <syscall>
  if(killed(p))
    80003254:	8526                	mv	a0,s1
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	90c080e7          	jalr	-1780(ra) # 80002b62 <killed>
    8000325e:	c911                	beqz	a0,80003272 <usertrap+0xac>
    80003260:	4901                	li	s2,0
    exit(-1);
    80003262:	557d                	li	a0,-1
    80003264:	fffff097          	auipc	ra,0xfffff
    80003268:	6de080e7          	jalr	1758(ra) # 80002942 <exit>
  if(which_dev == 2)
    8000326c:	4789                	li	a5,2
    8000326e:	04f90f63          	beq	s2,a5,800032cc <usertrap+0x106>
  usertrapret();
    80003272:	00000097          	auipc	ra,0x0
    80003276:	dba080e7          	jalr	-582(ra) # 8000302c <usertrapret>
}
    8000327a:	60e2                	ld	ra,24(sp)
    8000327c:	6442                	ld	s0,16(sp)
    8000327e:	64a2                	ld	s1,8(sp)
    80003280:	6902                	ld	s2,0(sp)
    80003282:	6105                	addi	sp,sp,32
    80003284:	8082                	ret
      exit(-1);
    80003286:	557d                	li	a0,-1
    80003288:	fffff097          	auipc	ra,0xfffff
    8000328c:	6ba080e7          	jalr	1722(ra) # 80002942 <exit>
    80003290:	b765                	j	80003238 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003292:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003296:	5890                	lw	a2,48(s1)
    80003298:	00008517          	auipc	a0,0x8
    8000329c:	0e850513          	addi	a0,a0,232 # 8000b380 <etext+0x380>
    800032a0:	ffffd097          	auipc	ra,0xffffd
    800032a4:	308080e7          	jalr	776(ra) # 800005a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800032a8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800032ac:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800032b0:	00008517          	auipc	a0,0x8
    800032b4:	10050513          	addi	a0,a0,256 # 8000b3b0 <etext+0x3b0>
    800032b8:	ffffd097          	auipc	ra,0xffffd
    800032bc:	2f0080e7          	jalr	752(ra) # 800005a8 <printf>
    setkilled(p);
    800032c0:	8526                	mv	a0,s1
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	874080e7          	jalr	-1932(ra) # 80002b36 <setkilled>
    800032ca:	b769                	j	80003254 <usertrap+0x8e>
    yield();
    800032cc:	fffff097          	auipc	ra,0xfffff
    800032d0:	42c080e7          	jalr	1068(ra) # 800026f8 <yield>
    800032d4:	bf79                	j	80003272 <usertrap+0xac>

00000000800032d6 <kerneltrap>:
{
    800032d6:	7179                	addi	sp,sp,-48
    800032d8:	f406                	sd	ra,40(sp)
    800032da:	f022                	sd	s0,32(sp)
    800032dc:	ec26                	sd	s1,24(sp)
    800032de:	e84a                	sd	s2,16(sp)
    800032e0:	e44e                	sd	s3,8(sp)
    800032e2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800032e4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032e8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800032ec:	142027f3          	csrr	a5,scause
    800032f0:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    800032f2:	1004f793          	andi	a5,s1,256
    800032f6:	cb85                	beqz	a5,80003326 <kerneltrap+0x50>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032f8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800032fc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800032fe:	ef85                	bnez	a5,80003336 <kerneltrap+0x60>
  if((which_dev = devintr()) == 0){
    80003300:	00000097          	auipc	ra,0x0
    80003304:	e0a080e7          	jalr	-502(ra) # 8000310a <devintr>
    80003308:	cd1d                	beqz	a0,80003346 <kerneltrap+0x70>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000330a:	4789                	li	a5,2
    8000330c:	06f50a63          	beq	a0,a5,80003380 <kerneltrap+0xaa>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003310:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003314:	10049073          	csrw	sstatus,s1
}
    80003318:	70a2                	ld	ra,40(sp)
    8000331a:	7402                	ld	s0,32(sp)
    8000331c:	64e2                	ld	s1,24(sp)
    8000331e:	6942                	ld	s2,16(sp)
    80003320:	69a2                	ld	s3,8(sp)
    80003322:	6145                	addi	sp,sp,48
    80003324:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003326:	00008517          	auipc	a0,0x8
    8000332a:	0aa50513          	addi	a0,a0,170 # 8000b3d0 <etext+0x3d0>
    8000332e:	ffffd097          	auipc	ra,0xffffd
    80003332:	230080e7          	jalr	560(ra) # 8000055e <panic>
    panic("kerneltrap: interrupts enabled");
    80003336:	00008517          	auipc	a0,0x8
    8000333a:	0c250513          	addi	a0,a0,194 # 8000b3f8 <etext+0x3f8>
    8000333e:	ffffd097          	auipc	ra,0xffffd
    80003342:	220080e7          	jalr	544(ra) # 8000055e <panic>
    printf("scause %p\n", scause);
    80003346:	85ce                	mv	a1,s3
    80003348:	00008517          	auipc	a0,0x8
    8000334c:	0d050513          	addi	a0,a0,208 # 8000b418 <etext+0x418>
    80003350:	ffffd097          	auipc	ra,0xffffd
    80003354:	258080e7          	jalr	600(ra) # 800005a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003358:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000335c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003360:	00008517          	auipc	a0,0x8
    80003364:	0c850513          	addi	a0,a0,200 # 8000b428 <etext+0x428>
    80003368:	ffffd097          	auipc	ra,0xffffd
    8000336c:	240080e7          	jalr	576(ra) # 800005a8 <printf>
    panic("kerneltrap");
    80003370:	00008517          	auipc	a0,0x8
    80003374:	0d050513          	addi	a0,a0,208 # 8000b440 <etext+0x440>
    80003378:	ffffd097          	auipc	ra,0xffffd
    8000337c:	1e6080e7          	jalr	486(ra) # 8000055e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003380:	fffff097          	auipc	ra,0xfffff
    80003384:	afe080e7          	jalr	-1282(ra) # 80001e7e <myproc>
    80003388:	d541                	beqz	a0,80003310 <kerneltrap+0x3a>
    8000338a:	fffff097          	auipc	ra,0xfffff
    8000338e:	af4080e7          	jalr	-1292(ra) # 80001e7e <myproc>
    80003392:	4d18                	lw	a4,24(a0)
    80003394:	4791                	li	a5,4
    80003396:	f6f71de3          	bne	a4,a5,80003310 <kerneltrap+0x3a>
    yield();
    8000339a:	fffff097          	auipc	ra,0xfffff
    8000339e:	35e080e7          	jalr	862(ra) # 800026f8 <yield>
    800033a2:	b7bd                	j	80003310 <kerneltrap+0x3a>

00000000800033a4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800033a4:	1101                	addi	sp,sp,-32
    800033a6:	ec06                	sd	ra,24(sp)
    800033a8:	e822                	sd	s0,16(sp)
    800033aa:	e426                	sd	s1,8(sp)
    800033ac:	1000                	addi	s0,sp,32
    800033ae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800033b0:	fffff097          	auipc	ra,0xfffff
    800033b4:	ace080e7          	jalr	-1330(ra) # 80001e7e <myproc>
  switch (n) {
    800033b8:	4795                	li	a5,5
    800033ba:	0497e163          	bltu	a5,s1,800033fc <argraw+0x58>
    800033be:	048a                	slli	s1,s1,0x2
    800033c0:	00009717          	auipc	a4,0x9
    800033c4:	b6070713          	addi	a4,a4,-1184 # 8000bf20 <states.0+0x30>
    800033c8:	94ba                	add	s1,s1,a4
    800033ca:	409c                	lw	a5,0(s1)
    800033cc:	97ba                	add	a5,a5,a4
    800033ce:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800033d0:	6d3c                	ld	a5,88(a0)
    800033d2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800033d4:	60e2                	ld	ra,24(sp)
    800033d6:	6442                	ld	s0,16(sp)
    800033d8:	64a2                	ld	s1,8(sp)
    800033da:	6105                	addi	sp,sp,32
    800033dc:	8082                	ret
    return p->trapframe->a1;
    800033de:	6d3c                	ld	a5,88(a0)
    800033e0:	7fa8                	ld	a0,120(a5)
    800033e2:	bfcd                	j	800033d4 <argraw+0x30>
    return p->trapframe->a2;
    800033e4:	6d3c                	ld	a5,88(a0)
    800033e6:	63c8                	ld	a0,128(a5)
    800033e8:	b7f5                	j	800033d4 <argraw+0x30>
    return p->trapframe->a3;
    800033ea:	6d3c                	ld	a5,88(a0)
    800033ec:	67c8                	ld	a0,136(a5)
    800033ee:	b7dd                	j	800033d4 <argraw+0x30>
    return p->trapframe->a4;
    800033f0:	6d3c                	ld	a5,88(a0)
    800033f2:	6bc8                	ld	a0,144(a5)
    800033f4:	b7c5                	j	800033d4 <argraw+0x30>
    return p->trapframe->a5;
    800033f6:	6d3c                	ld	a5,88(a0)
    800033f8:	6fc8                	ld	a0,152(a5)
    800033fa:	bfe9                	j	800033d4 <argraw+0x30>
  panic("argraw");
    800033fc:	00008517          	auipc	a0,0x8
    80003400:	05450513          	addi	a0,a0,84 # 8000b450 <etext+0x450>
    80003404:	ffffd097          	auipc	ra,0xffffd
    80003408:	15a080e7          	jalr	346(ra) # 8000055e <panic>

000000008000340c <fetchaddr>:
{
    8000340c:	1101                	addi	sp,sp,-32
    8000340e:	ec06                	sd	ra,24(sp)
    80003410:	e822                	sd	s0,16(sp)
    80003412:	e426                	sd	s1,8(sp)
    80003414:	e04a                	sd	s2,0(sp)
    80003416:	1000                	addi	s0,sp,32
    80003418:	84aa                	mv	s1,a0
    8000341a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000341c:	fffff097          	auipc	ra,0xfffff
    80003420:	a62080e7          	jalr	-1438(ra) # 80001e7e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003424:	653c                	ld	a5,72(a0)
    80003426:	02f4f863          	bgeu	s1,a5,80003456 <fetchaddr+0x4a>
    8000342a:	00848713          	addi	a4,s1,8
    8000342e:	02e7e663          	bltu	a5,a4,8000345a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003432:	46a1                	li	a3,8
    80003434:	8626                	mv	a2,s1
    80003436:	85ca                	mv	a1,s2
    80003438:	6928                	ld	a0,80(a0)
    8000343a:	ffffe097          	auipc	ra,0xffffe
    8000343e:	75c080e7          	jalr	1884(ra) # 80001b96 <copyin>
    80003442:	00a03533          	snez	a0,a0
    80003446:	40a0053b          	negw	a0,a0
}
    8000344a:	60e2                	ld	ra,24(sp)
    8000344c:	6442                	ld	s0,16(sp)
    8000344e:	64a2                	ld	s1,8(sp)
    80003450:	6902                	ld	s2,0(sp)
    80003452:	6105                	addi	sp,sp,32
    80003454:	8082                	ret
    return -1;
    80003456:	557d                	li	a0,-1
    80003458:	bfcd                	j	8000344a <fetchaddr+0x3e>
    8000345a:	557d                	li	a0,-1
    8000345c:	b7fd                	j	8000344a <fetchaddr+0x3e>

000000008000345e <fetchstr>:
{
    8000345e:	7179                	addi	sp,sp,-48
    80003460:	f406                	sd	ra,40(sp)
    80003462:	f022                	sd	s0,32(sp)
    80003464:	ec26                	sd	s1,24(sp)
    80003466:	e84a                	sd	s2,16(sp)
    80003468:	e44e                	sd	s3,8(sp)
    8000346a:	1800                	addi	s0,sp,48
    8000346c:	89aa                	mv	s3,a0
    8000346e:	84ae                	mv	s1,a1
    80003470:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	a0c080e7          	jalr	-1524(ra) # 80001e7e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000347a:	86ca                	mv	a3,s2
    8000347c:	864e                	mv	a2,s3
    8000347e:	85a6                	mv	a1,s1
    80003480:	6928                	ld	a0,80(a0)
    80003482:	ffffe097          	auipc	ra,0xffffe
    80003486:	7a2080e7          	jalr	1954(ra) # 80001c24 <copyinstr>
    8000348a:	00054e63          	bltz	a0,800034a6 <fetchstr+0x48>
  return strlen(buf);
    8000348e:	8526                	mv	a0,s1
    80003490:	ffffe097          	auipc	ra,0xffffe
    80003494:	b2a080e7          	jalr	-1238(ra) # 80000fba <strlen>
}
    80003498:	70a2                	ld	ra,40(sp)
    8000349a:	7402                	ld	s0,32(sp)
    8000349c:	64e2                	ld	s1,24(sp)
    8000349e:	6942                	ld	s2,16(sp)
    800034a0:	69a2                	ld	s3,8(sp)
    800034a2:	6145                	addi	sp,sp,48
    800034a4:	8082                	ret
    return -1;
    800034a6:	557d                	li	a0,-1
    800034a8:	bfc5                	j	80003498 <fetchstr+0x3a>

00000000800034aa <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800034aa:	1101                	addi	sp,sp,-32
    800034ac:	ec06                	sd	ra,24(sp)
    800034ae:	e822                	sd	s0,16(sp)
    800034b0:	e426                	sd	s1,8(sp)
    800034b2:	1000                	addi	s0,sp,32
    800034b4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800034b6:	00000097          	auipc	ra,0x0
    800034ba:	eee080e7          	jalr	-274(ra) # 800033a4 <argraw>
    800034be:	c088                	sw	a0,0(s1)
}
    800034c0:	60e2                	ld	ra,24(sp)
    800034c2:	6442                	ld	s0,16(sp)
    800034c4:	64a2                	ld	s1,8(sp)
    800034c6:	6105                	addi	sp,sp,32
    800034c8:	8082                	ret

00000000800034ca <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800034ca:	1101                	addi	sp,sp,-32
    800034cc:	ec06                	sd	ra,24(sp)
    800034ce:	e822                	sd	s0,16(sp)
    800034d0:	e426                	sd	s1,8(sp)
    800034d2:	1000                	addi	s0,sp,32
    800034d4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800034d6:	00000097          	auipc	ra,0x0
    800034da:	ece080e7          	jalr	-306(ra) # 800033a4 <argraw>
    800034de:	e088                	sd	a0,0(s1)
}
    800034e0:	60e2                	ld	ra,24(sp)
    800034e2:	6442                	ld	s0,16(sp)
    800034e4:	64a2                	ld	s1,8(sp)
    800034e6:	6105                	addi	sp,sp,32
    800034e8:	8082                	ret

00000000800034ea <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800034ea:	1101                	addi	sp,sp,-32
    800034ec:	ec06                	sd	ra,24(sp)
    800034ee:	e822                	sd	s0,16(sp)
    800034f0:	e426                	sd	s1,8(sp)
    800034f2:	e04a                	sd	s2,0(sp)
    800034f4:	1000                	addi	s0,sp,32
    800034f6:	892e                	mv	s2,a1
    800034f8:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800034fa:	00000097          	auipc	ra,0x0
    800034fe:	eaa080e7          	jalr	-342(ra) # 800033a4 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80003502:	8626                	mv	a2,s1
    80003504:	85ca                	mv	a1,s2
    80003506:	00000097          	auipc	ra,0x0
    8000350a:	f58080e7          	jalr	-168(ra) # 8000345e <fetchstr>
}
    8000350e:	60e2                	ld	ra,24(sp)
    80003510:	6442                	ld	s0,16(sp)
    80003512:	64a2                	ld	s1,8(sp)
    80003514:	6902                	ld	s2,0(sp)
    80003516:	6105                	addi	sp,sp,32
    80003518:	8082                	ret

000000008000351a <syscall>:
[SYS_recvfrom]      sys_recvfrom,
};

void
syscall(void)
{
    8000351a:	1101                	addi	sp,sp,-32
    8000351c:	ec06                	sd	ra,24(sp)
    8000351e:	e822                	sd	s0,16(sp)
    80003520:	e426                	sd	s1,8(sp)
    80003522:	e04a                	sd	s2,0(sp)
    80003524:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003526:	fffff097          	auipc	ra,0xfffff
    8000352a:	958080e7          	jalr	-1704(ra) # 80001e7e <myproc>
    8000352e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003530:	05853903          	ld	s2,88(a0)
    80003534:	0a893783          	ld	a5,168(s2)
    80003538:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000353c:	37fd                	addiw	a5,a5,-1
    8000353e:	02100713          	li	a4,33
    80003542:	00f76f63          	bltu	a4,a5,80003560 <syscall+0x46>
    80003546:	00369713          	slli	a4,a3,0x3
    8000354a:	00009797          	auipc	a5,0x9
    8000354e:	9ee78793          	addi	a5,a5,-1554 # 8000bf38 <syscalls>
    80003552:	97ba                	add	a5,a5,a4
    80003554:	639c                	ld	a5,0(a5)
    80003556:	c789                	beqz	a5,80003560 <syscall+0x46>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003558:	9782                	jalr	a5
    8000355a:	06a93823          	sd	a0,112(s2)
    8000355e:	a839                	j	8000357c <syscall+0x62>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003560:	15848613          	addi	a2,s1,344
    80003564:	588c                	lw	a1,48(s1)
    80003566:	00008517          	auipc	a0,0x8
    8000356a:	ef250513          	addi	a0,a0,-270 # 8000b458 <etext+0x458>
    8000356e:	ffffd097          	auipc	ra,0xffffd
    80003572:	03a080e7          	jalr	58(ra) # 800005a8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003576:	6cbc                	ld	a5,88(s1)
    80003578:	577d                	li	a4,-1
    8000357a:	fbb8                	sd	a4,112(a5)
  }
}
    8000357c:	60e2                	ld	ra,24(sp)
    8000357e:	6442                	ld	s0,16(sp)
    80003580:	64a2                	ld	s1,8(sp)
    80003582:	6902                	ld	s2,0(sp)
    80003584:	6105                	addi	sp,sp,32
    80003586:	8082                	ret

0000000080003588 <sys_exit>:
#include "file.h"
#include "sys/net.h"
#include "sys/socket.h"
#include "proc.h"

uint64 sys_exit(void) {
    80003588:	1101                	addi	sp,sp,-32
    8000358a:	ec06                	sd	ra,24(sp)
    8000358c:	e822                	sd	s0,16(sp)
    8000358e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003590:	fec40593          	addi	a1,s0,-20
    80003594:	4501                	li	a0,0
    80003596:	00000097          	auipc	ra,0x0
    8000359a:	f14080e7          	jalr	-236(ra) # 800034aa <argint>
  exit(n);
    8000359e:	fec42503          	lw	a0,-20(s0)
    800035a2:	fffff097          	auipc	ra,0xfffff
    800035a6:	3a0080e7          	jalr	928(ra) # 80002942 <exit>
  return 0; // not reached
}
    800035aa:	4501                	li	a0,0
    800035ac:	60e2                	ld	ra,24(sp)
    800035ae:	6442                	ld	s0,16(sp)
    800035b0:	6105                	addi	sp,sp,32
    800035b2:	8082                	ret

00000000800035b4 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    800035b4:	1141                	addi	sp,sp,-16
    800035b6:	e406                	sd	ra,8(sp)
    800035b8:	e022                	sd	s0,0(sp)
    800035ba:	0800                	addi	s0,sp,16
    800035bc:	fffff097          	auipc	ra,0xfffff
    800035c0:	8c2080e7          	jalr	-1854(ra) # 80001e7e <myproc>
    800035c4:	5908                	lw	a0,48(a0)
    800035c6:	60a2                	ld	ra,8(sp)
    800035c8:	6402                	ld	s0,0(sp)
    800035ca:	0141                	addi	sp,sp,16
    800035cc:	8082                	ret

00000000800035ce <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    800035ce:	1141                	addi	sp,sp,-16
    800035d0:	e406                	sd	ra,8(sp)
    800035d2:	e022                	sd	s0,0(sp)
    800035d4:	0800                	addi	s0,sp,16
    800035d6:	fffff097          	auipc	ra,0xfffff
    800035da:	cac080e7          	jalr	-852(ra) # 80002282 <fork>
    800035de:	60a2                	ld	ra,8(sp)
    800035e0:	6402                	ld	s0,0(sp)
    800035e2:	0141                	addi	sp,sp,16
    800035e4:	8082                	ret

00000000800035e6 <sys_wait>:

uint64 sys_wait(void) {
    800035e6:	1101                	addi	sp,sp,-32
    800035e8:	ec06                	sd	ra,24(sp)
    800035ea:	e822                	sd	s0,16(sp)
    800035ec:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800035ee:	fe840593          	addi	a1,s0,-24
    800035f2:	4501                	li	a0,0
    800035f4:	00000097          	auipc	ra,0x0
    800035f8:	ed6080e7          	jalr	-298(ra) # 800034ca <argaddr>
  return wait(p);
    800035fc:	fe843503          	ld	a0,-24(s0)
    80003600:	fffff097          	auipc	ra,0xfffff
    80003604:	6d6080e7          	jalr	1750(ra) # 80002cd6 <wait>
}
    80003608:	60e2                	ld	ra,24(sp)
    8000360a:	6442                	ld	s0,16(sp)
    8000360c:	6105                	addi	sp,sp,32
    8000360e:	8082                	ret

0000000080003610 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80003610:	7179                	addi	sp,sp,-48
    80003612:	f406                	sd	ra,40(sp)
    80003614:	f022                	sd	s0,32(sp)
    80003616:	ec26                	sd	s1,24(sp)
    80003618:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000361a:	fdc40593          	addi	a1,s0,-36
    8000361e:	4501                	li	a0,0
    80003620:	00000097          	auipc	ra,0x0
    80003624:	e8a080e7          	jalr	-374(ra) # 800034aa <argint>
  addr = myproc()->sz;
    80003628:	fffff097          	auipc	ra,0xfffff
    8000362c:	856080e7          	jalr	-1962(ra) # 80001e7e <myproc>
    80003630:	653c                	ld	a5,72(a0)
    80003632:	84be                	mv	s1,a5
  if (growproc(n) < 0)
    80003634:	fdc42503          	lw	a0,-36(s0)
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	bb4080e7          	jalr	-1100(ra) # 800021ec <growproc>
    80003640:	00054863          	bltz	a0,80003650 <sys_sbrk+0x40>
    return -1;
  return addr;
}
    80003644:	8526                	mv	a0,s1
    80003646:	70a2                	ld	ra,40(sp)
    80003648:	7402                	ld	s0,32(sp)
    8000364a:	64e2                	ld	s1,24(sp)
    8000364c:	6145                	addi	sp,sp,48
    8000364e:	8082                	ret
    return -1;
    80003650:	57fd                	li	a5,-1
    80003652:	84be                	mv	s1,a5
    80003654:	bfc5                	j	80003644 <sys_sbrk+0x34>

0000000080003656 <sys_sleep>:

uint64 sys_sleep(void) {
    80003656:	7139                	addi	sp,sp,-64
    80003658:	fc06                	sd	ra,56(sp)
    8000365a:	f822                	sd	s0,48(sp)
    8000365c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000365e:	fcc40593          	addi	a1,s0,-52
    80003662:	4501                	li	a0,0
    80003664:	00000097          	auipc	ra,0x0
    80003668:	e46080e7          	jalr	-442(ra) # 800034aa <argint>
  acquire(&tickslock);
    8000366c:	00063517          	auipc	a0,0x63
    80003670:	9b450513          	addi	a0,a0,-1612 # 80066020 <tickslock>
    80003674:	ffffd097          	auipc	ra,0xffffd
    80003678:	6c0080e7          	jalr	1728(ra) # 80000d34 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    8000367c:	fcc42783          	lw	a5,-52(s0)
    80003680:	cba9                	beqz	a5,800036d2 <sys_sleep+0x7c>
    80003682:	f426                	sd	s1,40(sp)
    80003684:	f04a                	sd	s2,32(sp)
    80003686:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80003688:	0000c997          	auipc	s3,0xc
    8000368c:	6dc9a983          	lw	s3,1756(s3) # 8000fd64 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003690:	00063917          	auipc	s2,0x63
    80003694:	99090913          	addi	s2,s2,-1648 # 80066020 <tickslock>
    80003698:	0000c497          	auipc	s1,0xc
    8000369c:	6cc48493          	addi	s1,s1,1740 # 8000fd64 <ticks>
    if (killed(myproc())) {
    800036a0:	ffffe097          	auipc	ra,0xffffe
    800036a4:	7de080e7          	jalr	2014(ra) # 80001e7e <myproc>
    800036a8:	fffff097          	auipc	ra,0xfffff
    800036ac:	4ba080e7          	jalr	1210(ra) # 80002b62 <killed>
    800036b0:	ed15                	bnez	a0,800036ec <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800036b2:	85ca                	mv	a1,s2
    800036b4:	8526                	mv	a0,s1
    800036b6:	fffff097          	auipc	ra,0xfffff
    800036ba:	07e080e7          	jalr	126(ra) # 80002734 <sleep>
  while (ticks - ticks0 < n) {
    800036be:	409c                	lw	a5,0(s1)
    800036c0:	413787bb          	subw	a5,a5,s3
    800036c4:	fcc42703          	lw	a4,-52(s0)
    800036c8:	fce7ece3          	bltu	a5,a4,800036a0 <sys_sleep+0x4a>
    800036cc:	74a2                	ld	s1,40(sp)
    800036ce:	7902                	ld	s2,32(sp)
    800036d0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800036d2:	00063517          	auipc	a0,0x63
    800036d6:	94e50513          	addi	a0,a0,-1714 # 80066020 <tickslock>
    800036da:	ffffd097          	auipc	ra,0xffffd
    800036de:	70a080e7          	jalr	1802(ra) # 80000de4 <release>
  return 0;
    800036e2:	4501                	li	a0,0
}
    800036e4:	70e2                	ld	ra,56(sp)
    800036e6:	7442                	ld	s0,48(sp)
    800036e8:	6121                	addi	sp,sp,64
    800036ea:	8082                	ret
      release(&tickslock);
    800036ec:	00063517          	auipc	a0,0x63
    800036f0:	93450513          	addi	a0,a0,-1740 # 80066020 <tickslock>
    800036f4:	ffffd097          	auipc	ra,0xffffd
    800036f8:	6f0080e7          	jalr	1776(ra) # 80000de4 <release>
      return -1;
    800036fc:	557d                	li	a0,-1
    800036fe:	74a2                	ld	s1,40(sp)
    80003700:	7902                	ld	s2,32(sp)
    80003702:	69e2                	ld	s3,24(sp)
    80003704:	b7c5                	j	800036e4 <sys_sleep+0x8e>

0000000080003706 <sys_kill>:

uint64 sys_kill(void) {
    80003706:	1101                	addi	sp,sp,-32
    80003708:	ec06                	sd	ra,24(sp)
    8000370a:	e822                	sd	s0,16(sp)
    8000370c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000370e:	fec40593          	addi	a1,s0,-20
    80003712:	4501                	li	a0,0
    80003714:	00000097          	auipc	ra,0x0
    80003718:	d96080e7          	jalr	-618(ra) # 800034aa <argint>
  return kill(pid);
    8000371c:	fec42503          	lw	a0,-20(s0)
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	3a4080e7          	jalr	932(ra) # 80002ac4 <kill>
}
    80003728:	60e2                	ld	ra,24(sp)
    8000372a:	6442                	ld	s0,16(sp)
    8000372c:	6105                	addi	sp,sp,32
    8000372e:	8082                	ret

0000000080003730 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80003730:	1101                	addi	sp,sp,-32
    80003732:	ec06                	sd	ra,24(sp)
    80003734:	e822                	sd	s0,16(sp)
    80003736:	e426                	sd	s1,8(sp)
    80003738:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000373a:	00063517          	auipc	a0,0x63
    8000373e:	8e650513          	addi	a0,a0,-1818 # 80066020 <tickslock>
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	5f2080e7          	jalr	1522(ra) # 80000d34 <acquire>
  xticks = ticks;
    8000374a:	0000c797          	auipc	a5,0xc
    8000374e:	61a7a783          	lw	a5,1562(a5) # 8000fd64 <ticks>
    80003752:	84be                	mv	s1,a5
  release(&tickslock);
    80003754:	00063517          	auipc	a0,0x63
    80003758:	8cc50513          	addi	a0,a0,-1844 # 80066020 <tickslock>
    8000375c:	ffffd097          	auipc	ra,0xffffd
    80003760:	688080e7          	jalr	1672(ra) # 80000de4 <release>
  return xticks;
}
    80003764:	02049513          	slli	a0,s1,0x20
    80003768:	9101                	srli	a0,a0,0x20
    8000376a:	60e2                	ld	ra,24(sp)
    8000376c:	6442                	ld	s0,16(sp)
    8000376e:	64a2                	ld	s1,8(sp)
    80003770:	6105                	addi	sp,sp,32
    80003772:	8082                	ret

0000000080003774 <sys_spoon>:

uint64 sys_spoon(void) {
    80003774:	1101                	addi	sp,sp,-32
    80003776:	ec06                	sd	ra,24(sp)
    80003778:	e822                	sd	s0,16(sp)
    8000377a:	1000                	addi	s0,sp,32
  // obtain the argument from the stack, we need some special handling
  uint64 addr;
  argaddr(0, &addr);
    8000377c:	fe840593          	addi	a1,s0,-24
    80003780:	4501                	li	a0,0
    80003782:	00000097          	auipc	ra,0x0
    80003786:	d48080e7          	jalr	-696(ra) # 800034ca <argaddr>
  return spoon((void *)addr);
    8000378a:	fe843503          	ld	a0,-24(s0)
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	7cc080e7          	jalr	1996(ra) # 80002f5a <spoon>
}
    80003796:	60e2                	ld	ra,24(sp)
    80003798:	6442                	ld	s0,16(sp)
    8000379a:	6105                	addi	sp,sp,32
    8000379c:	8082                	ret

000000008000379e <sys_create_thread>:

uint64 sys_create_thread(void *arg) {
    8000379e:	7179                	addi	sp,sp,-48
    800037a0:	f406                	sd	ra,40(sp)
    800037a2:	f022                	sd	s0,32(sp)
    800037a4:	1800                	addi	s0,sp,48
  uint64 fn_addr, args_addr, stack_addr, exit_fn;
  argaddr(0, &fn_addr);
    800037a6:	fe840593          	addi	a1,s0,-24
    800037aa:	4501                	li	a0,0
    800037ac:	00000097          	auipc	ra,0x0
    800037b0:	d1e080e7          	jalr	-738(ra) # 800034ca <argaddr>
  argaddr(1, &args_addr);
    800037b4:	fe040593          	addi	a1,s0,-32
    800037b8:	4505                	li	a0,1
    800037ba:	00000097          	auipc	ra,0x0
    800037be:	d10080e7          	jalr	-752(ra) # 800034ca <argaddr>
  argaddr(2, &stack_addr);
    800037c2:	fd840593          	addi	a1,s0,-40
    800037c6:	4509                	li	a0,2
    800037c8:	00000097          	auipc	ra,0x0
    800037cc:	d02080e7          	jalr	-766(ra) # 800034ca <argaddr>
  argaddr(3, &exit_fn);
    800037d0:	fd040593          	addi	a1,s0,-48
    800037d4:	450d                	li	a0,3
    800037d6:	00000097          	auipc	ra,0x0
    800037da:	cf4080e7          	jalr	-780(ra) # 800034ca <argaddr>
  return create_thread((void *)fn_addr, (void *)args_addr, (void *)stack_addr,
    800037de:	fd043683          	ld	a3,-48(s0)
    800037e2:	fd843603          	ld	a2,-40(s0)
    800037e6:	fe043583          	ld	a1,-32(s0)
    800037ea:	fe843503          	ld	a0,-24(s0)
    800037ee:	fffff097          	auipc	ra,0xfffff
    800037f2:	bda080e7          	jalr	-1062(ra) # 800023c8 <create_thread>
                       (void *)exit_fn);
}
    800037f6:	70a2                	ld	ra,40(sp)
    800037f8:	7402                	ld	s0,32(sp)
    800037fa:	6145                	addi	sp,sp,48
    800037fc:	8082                	ret

00000000800037fe <sys_join_thread>:

uint64 sys_join_thread(void *arg) {
    800037fe:	1101                	addi	sp,sp,-32
    80003800:	ec06                	sd	ra,24(sp)
    80003802:	e822                	sd	s0,16(sp)
    80003804:	1000                	addi	s0,sp,32
  uint64 thread_id, status_addr;
  argaddr(0, &thread_id);
    80003806:	fe840593          	addi	a1,s0,-24
    8000380a:	4501                	li	a0,0
    8000380c:	00000097          	auipc	ra,0x0
    80003810:	cbe080e7          	jalr	-834(ra) # 800034ca <argaddr>
  argaddr(1, &status_addr);
    80003814:	fe040593          	addi	a1,s0,-32
    80003818:	4505                	li	a0,1
    8000381a:	00000097          	auipc	ra,0x0
    8000381e:	cb0080e7          	jalr	-848(ra) # 800034ca <argaddr>
  return join_thread(thread_id, status_addr);
    80003822:	fe043583          	ld	a1,-32(s0)
    80003826:	fe843503          	ld	a0,-24(s0)
    8000382a:	fffff097          	auipc	ra,0xfffff
    8000382e:	36a080e7          	jalr	874(ra) # 80002b94 <join_thread>
}
    80003832:	60e2                	ld	ra,24(sp)
    80003834:	6442                	ld	s0,16(sp)
    80003836:	6105                	addi	sp,sp,32
    80003838:	8082                	ret

000000008000383a <sys_thread_exit>:

uint64 sys_thread_exit(void *arg) {
    8000383a:	1101                	addi	sp,sp,-32
    8000383c:	ec06                	sd	ra,24(sp)
    8000383e:	e822                	sd	s0,16(sp)
    80003840:	1000                	addi	s0,sp,32
  uint64 status_addr;
  argaddr(0, &status_addr);
    80003842:	fe840593          	addi	a1,s0,-24
    80003846:	4501                	li	a0,0
    80003848:	00000097          	auipc	ra,0x0
    8000384c:	c82080e7          	jalr	-894(ra) # 800034ca <argaddr>
  return thread_exit(status_addr);
    80003850:	fe843503          	ld	a0,-24(s0)
    80003854:	fffff097          	auipc	ra,0xfffff
    80003858:	014080e7          	jalr	20(ra) # 80002868 <thread_exit>
}
    8000385c:	60e2                	ld	ra,24(sp)
    8000385e:	6442                	ld	s0,16(sp)
    80003860:	6105                	addi	sp,sp,32
    80003862:	8082                	ret

0000000080003864 <sys_bind>:

uint64 sys_bind(void) {
    80003864:	715d                	addi	sp,sp,-80
    80003866:	e486                	sd	ra,72(sp)
    80003868:	e0a2                	sd	s0,64(sp)
    8000386a:	0880                	addi	s0,sp,80
    int fd;
    uint64 uaddr;
    int addrlen;

    argint(0, &fd);
    8000386c:	fdc40593          	addi	a1,s0,-36
    80003870:	4501                	li	a0,0
    80003872:	00000097          	auipc	ra,0x0
    80003876:	c38080e7          	jalr	-968(ra) # 800034aa <argint>
    argaddr(1, &uaddr);
    8000387a:	fd040593          	addi	a1,s0,-48
    8000387e:	4505                	li	a0,1
    80003880:	00000097          	auipc	ra,0x0
    80003884:	c4a080e7          	jalr	-950(ra) # 800034ca <argaddr>
    argint(2, &addrlen);
    80003888:	fcc40593          	addi	a1,s0,-52
    8000388c:	4509                	li	a0,2
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	c1c080e7          	jalr	-996(ra) # 800034aa <argint>

    struct file *f = myproc()->ofile[fd];
    80003896:	ffffe097          	auipc	ra,0xffffe
    8000389a:	5e8080e7          	jalr	1512(ra) # 80001e7e <myproc>
    8000389e:	fdc42783          	lw	a5,-36(s0)
    800038a2:	078e                	slli	a5,a5,0x3
    800038a4:	0d078793          	addi	a5,a5,208
    800038a8:	953e                	add	a0,a0,a5
    800038aa:	611c                	ld	a5,0(a0)
    if (f == 0 || f->type != FD_SOCKET)
    800038ac:	cbb9                	beqz	a5,80003902 <sys_bind+0x9e>
    800038ae:	4394                	lw	a3,0(a5)
    800038b0:	4711                	li	a4,4
        return -1;
    800038b2:	557d                	li	a0,-1
    if (f == 0 || f->type != FD_SOCKET)
    800038b4:	04e69363          	bne	a3,a4,800038fa <sys_bind+0x96>

    struct socket *sock = f->sock;

    struct sockaddr_in addr;
    if (addrlen > sizeof(addr))
    800038b8:	fcc42683          	lw	a3,-52(s0)
    800038bc:	4741                	li	a4,16
    800038be:	02d76e63          	bltu	a4,a3,800038fa <sys_bind+0x96>
    800038c2:	fc26                	sd	s1,56(sp)
    struct socket *sock = f->sock;
    800038c4:	7384                	ld	s1,32(a5)
        return -1;

    // Copy user memory → kernel struct
    if (copyin(myproc()->pagetable, (char*)&addr, uaddr, addrlen) < 0)
    800038c6:	ffffe097          	auipc	ra,0xffffe
    800038ca:	5b8080e7          	jalr	1464(ra) # 80001e7e <myproc>
    800038ce:	fcc42683          	lw	a3,-52(s0)
    800038d2:	fd043603          	ld	a2,-48(s0)
    800038d6:	fb840593          	addi	a1,s0,-72
    800038da:	6928                	ld	a0,80(a0)
    800038dc:	ffffe097          	auipc	ra,0xffffe
    800038e0:	2ba080e7          	jalr	698(ra) # 80001b96 <copyin>
    800038e4:	02054163          	bltz	a0,80003906 <sys_bind+0xa2>
        return -1;

    return sock->ops->bind(sock, (struct sockaddr*)&addr, addrlen);
    800038e8:	8526                	mv	a0,s1
    800038ea:	64bc                	ld	a5,72(s1)
    800038ec:	639c                	ld	a5,0(a5)
    800038ee:	fcc42603          	lw	a2,-52(s0)
    800038f2:	fb840593          	addi	a1,s0,-72
    800038f6:	9782                	jalr	a5
    800038f8:	74e2                	ld	s1,56(sp)
}
    800038fa:	60a6                	ld	ra,72(sp)
    800038fc:	6406                	ld	s0,64(sp)
    800038fe:	6161                	addi	sp,sp,80
    80003900:	8082                	ret
        return -1;
    80003902:	557d                	li	a0,-1
    80003904:	bfdd                	j	800038fa <sys_bind+0x96>
        return -1;
    80003906:	557d                	li	a0,-1
    80003908:	74e2                	ld	s1,56(sp)
    8000390a:	bfc5                	j	800038fa <sys_bind+0x96>

000000008000390c <sys_listen>:
uint64 sys_listen(void *arg) {
    8000390c:	1101                	addi	sp,sp,-32
    8000390e:	ec06                	sd	ra,24(sp)
    80003910:	e822                	sd	s0,16(sp)
    80003912:	1000                	addi	s0,sp,32
  uint64 socket, backlog;
  argaddr(0, &socket);
    80003914:	fe840593          	addi	a1,s0,-24
    80003918:	4501                	li	a0,0
    8000391a:	00000097          	auipc	ra,0x0
    8000391e:	bb0080e7          	jalr	-1104(ra) # 800034ca <argaddr>
  argaddr(1, &backlog);
    80003922:	fe040593          	addi	a1,s0,-32
    80003926:	4505                	li	a0,1
    80003928:	00000097          	auipc	ra,0x0
    8000392c:	ba2080e7          	jalr	-1118(ra) # 800034ca <argaddr>
  return listen(socket, backlog);
    80003930:	fe042583          	lw	a1,-32(s0)
    80003934:	fe842503          	lw	a0,-24(s0)
    80003938:	00005097          	auipc	ra,0x5
    8000393c:	bc0080e7          	jalr	-1088(ra) # 800084f8 <listen>
}
    80003940:	60e2                	ld	ra,24(sp)
    80003942:	6442                	ld	s0,16(sp)
    80003944:	6105                	addi	sp,sp,32
    80003946:	8082                	ret

0000000080003948 <sys_accept>:

uint64 sys_accept(void *arg) {
    80003948:	7139                	addi	sp,sp,-64
    8000394a:	fc06                	sd	ra,56(sp)
    8000394c:	f822                	sd	s0,48(sp)
    8000394e:	f426                	sd	s1,40(sp)
    80003950:	0080                	addi	s0,sp,64
  uint64 socket;
  uint64 address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    80003952:	fd840593          	addi	a1,s0,-40
    80003956:	4501                	li	a0,0
    80003958:	00000097          	auipc	ra,0x0
    8000395c:	b72080e7          	jalr	-1166(ra) # 800034ca <argaddr>
  argaddr(1, (uint64 *)&address);
    80003960:	fc040493          	addi	s1,s0,-64
    80003964:	85a6                	mv	a1,s1
    80003966:	4505                	li	a0,1
    80003968:	00000097          	auipc	ra,0x0
    8000396c:	b62080e7          	jalr	-1182(ra) # 800034ca <argaddr>
  argaddr(2, &address_len);
    80003970:	fd040593          	addi	a1,s0,-48
    80003974:	4509                	li	a0,2
    80003976:	00000097          	auipc	ra,0x0
    8000397a:	b54080e7          	jalr	-1196(ra) # 800034ca <argaddr>
  return accept(socket, &address, address_len);
    8000397e:	fd042603          	lw	a2,-48(s0)
    80003982:	85a6                	mv	a1,s1
    80003984:	fd842503          	lw	a0,-40(s0)
    80003988:	00005097          	auipc	ra,0x5
    8000398c:	b9e080e7          	jalr	-1122(ra) # 80008526 <accept>
}
    80003990:	70e2                	ld	ra,56(sp)
    80003992:	7442                	ld	s0,48(sp)
    80003994:	74a2                	ld	s1,40(sp)
    80003996:	6121                	addi	sp,sp,64
    80003998:	8082                	ret

000000008000399a <sys_socket>:

uint64 sys_socket(void *arg) {;
    8000399a:	7139                	addi	sp,sp,-64
    8000399c:	fc06                	sd	ra,56(sp)
    8000399e:	f822                	sd	s0,48(sp)
    800039a0:	0080                	addi	s0,sp,64
  uint64 address_family, address_socktype, protocol;
  argaddr(0, &address_family);
    800039a2:	fd840593          	addi	a1,s0,-40
    800039a6:	4501                	li	a0,0
    800039a8:	00000097          	auipc	ra,0x0
    800039ac:	b22080e7          	jalr	-1246(ra) # 800034ca <argaddr>
  argaddr(1, &address_socktype);
    800039b0:	fd040593          	addi	a1,s0,-48
    800039b4:	4505                	li	a0,1
    800039b6:	00000097          	auipc	ra,0x0
    800039ba:	b14080e7          	jalr	-1260(ra) # 800034ca <argaddr>
  argaddr(2, &protocol);
    800039be:	fc840593          	addi	a1,s0,-56
    800039c2:	4509                	li	a0,2
    800039c4:	00000097          	auipc	ra,0x0
    800039c8:	b06080e7          	jalr	-1274(ra) # 800034ca <argaddr>

  struct socket *sock = (struct socket *)kalloc();
    800039cc:	ffffd097          	auipc	ra,0xffffd
    800039d0:	246080e7          	jalr	582(ra) # 80000c12 <kalloc>
  if (sock == 0) {
    800039d4:	cd29                	beqz	a0,80003a2e <sys_socket+0x94>
    800039d6:	f426                	sd	s1,40(sp)
    800039d8:	f04a                	sd	s2,32(sp)
    800039da:	84aa                	mv	s1,a0
    printf("ERROR: kalloc\n");
    return -1;
  }
  memset(sock, 0, PGSIZE);
    800039dc:	6605                	lui	a2,0x1
    800039de:	4581                	li	a1,0
    800039e0:	ffffd097          	auipc	ra,0xffffd
    800039e4:	44c080e7          	jalr	1100(ra) # 80000e2c <memset>

  initsocket(sock, address_family, address_socktype, protocol);
    800039e8:	fc842683          	lw	a3,-56(s0)
    800039ec:	fd042603          	lw	a2,-48(s0)
    800039f0:	fd842583          	lw	a1,-40(s0)
    800039f4:	8526                	mv	a0,s1
    800039f6:	00005097          	auipc	ra,0x5
    800039fa:	bda080e7          	jalr	-1062(ra) # 800085d0 <initsocket>

  struct file *f = filealloc();
    800039fe:	00002097          	auipc	ra,0x2
    80003a02:	9ce080e7          	jalr	-1586(ra) # 800053cc <filealloc>
    80003a06:	892a                	mv	s2,a0
  if (f == 0) {
    80003a08:	cd0d                	beqz	a0,80003a42 <sys_socket+0xa8>
    kfree(sock);
    return -1;
  }

  int fd = fdalloc(f);
    80003a0a:	00002097          	auipc	ra,0x2
    80003a0e:	796080e7          	jalr	1942(ra) # 800061a0 <fdalloc>
  if (fd < 0) {
    80003a12:	04054163          	bltz	a0,80003a54 <sys_socket+0xba>
    fileclose(f);
    kfree(sock);
    return -1;
  }

  f->type = FD_SOCKET;
    80003a16:	4791                	li	a5,4
    80003a18:	00f92023          	sw	a5,0(s2)
  f->sock = sock;
    80003a1c:	02993023          	sd	s1,32(s2)
  sock->fd = fd;
    80003a20:	c0a8                	sw	a0,64(s1)
    80003a22:	74a2                	ld	s1,40(sp)
    80003a24:	7902                	ld	s2,32(sp)

  return fd;
}
    80003a26:	70e2                	ld	ra,56(sp)
    80003a28:	7442                	ld	s0,48(sp)
    80003a2a:	6121                	addi	sp,sp,64
    80003a2c:	8082                	ret
    printf("ERROR: kalloc\n");
    80003a2e:	00008517          	auipc	a0,0x8
    80003a32:	a4a50513          	addi	a0,a0,-1462 # 8000b478 <etext+0x478>
    80003a36:	ffffd097          	auipc	ra,0xffffd
    80003a3a:	b72080e7          	jalr	-1166(ra) # 800005a8 <printf>
    return -1;
    80003a3e:	557d                	li	a0,-1
    80003a40:	b7dd                	j	80003a26 <sys_socket+0x8c>
    kfree(sock);
    80003a42:	8526                	mv	a0,s1
    80003a44:	ffffd097          	auipc	ra,0xffffd
    80003a48:	060080e7          	jalr	96(ra) # 80000aa4 <kfree>
    return -1;
    80003a4c:	557d                	li	a0,-1
    80003a4e:	74a2                	ld	s1,40(sp)
    80003a50:	7902                	ld	s2,32(sp)
    80003a52:	bfd1                	j	80003a26 <sys_socket+0x8c>
    fileclose(f);
    80003a54:	854a                	mv	a0,s2
    80003a56:	00002097          	auipc	ra,0x2
    80003a5a:	a32080e7          	jalr	-1486(ra) # 80005488 <fileclose>
    kfree(sock);
    80003a5e:	8526                	mv	a0,s1
    80003a60:	ffffd097          	auipc	ra,0xffffd
    80003a64:	044080e7          	jalr	68(ra) # 80000aa4 <kfree>
    return -1;
    80003a68:	557d                	li	a0,-1
    80003a6a:	74a2                	ld	s1,40(sp)
    80003a6c:	7902                	ld	s2,32(sp)
    80003a6e:	bf65                	j	80003a26 <sys_socket+0x8c>

0000000080003a70 <sys_connect>:

uint64 sys_connect(void *arg) {
    80003a70:	7139                	addi	sp,sp,-64
    80003a72:	fc06                	sd	ra,56(sp)
    80003a74:	f822                	sd	s0,48(sp)
    80003a76:	f426                	sd	s1,40(sp)
    80003a78:	0080                	addi	s0,sp,64
  uint64 socket, address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    80003a7a:	fd840593          	addi	a1,s0,-40
    80003a7e:	4501                	li	a0,0
    80003a80:	00000097          	auipc	ra,0x0
    80003a84:	a4a080e7          	jalr	-1462(ra) # 800034ca <argaddr>
  argaddr(1, (uint64 *)&address);
    80003a88:	fc040493          	addi	s1,s0,-64
    80003a8c:	85a6                	mv	a1,s1
    80003a8e:	4505                	li	a0,1
    80003a90:	00000097          	auipc	ra,0x0
    80003a94:	a3a080e7          	jalr	-1478(ra) # 800034ca <argaddr>
  argaddr(2, &address_len);
    80003a98:	fd040593          	addi	a1,s0,-48
    80003a9c:	4509                	li	a0,2
    80003a9e:	00000097          	auipc	ra,0x0
    80003aa2:	a2c080e7          	jalr	-1492(ra) # 800034ca <argaddr>
  return connect(socket, &address, address_len);
    80003aa6:	fd042603          	lw	a2,-48(s0)
    80003aaa:	85a6                	mv	a1,s1
    80003aac:	fd842503          	lw	a0,-40(s0)
    80003ab0:	00005097          	auipc	ra,0x5
    80003ab4:	b0e080e7          	jalr	-1266(ra) # 800085be <connect>
}
    80003ab8:	70e2                	ld	ra,56(sp)
    80003aba:	7442                	ld	s0,48(sp)
    80003abc:	74a2                	ld	s1,40(sp)
    80003abe:	6121                	addi	sp,sp,64
    80003ac0:	8082                	ret

0000000080003ac2 <sys_send>:

uint64
sys_send(void)
{
    80003ac2:	7179                	addi	sp,sp,-48
    80003ac4:	f406                	sd	ra,40(sp)
    80003ac6:	f022                	sd	s0,32(sp)
    80003ac8:	1800                	addi	s0,sp,48
  int fd;
  uint64 buf;   // user pointer
  int len;
  int flags;

  argint(0, &fd);
    80003aca:	fec40593          	addi	a1,s0,-20
    80003ace:	4501                	li	a0,0
    80003ad0:	00000097          	auipc	ra,0x0
    80003ad4:	9da080e7          	jalr	-1574(ra) # 800034aa <argint>
  argaddr(1, &buf);
    80003ad8:	fe040593          	addi	a1,s0,-32
    80003adc:	4505                	li	a0,1
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	9ec080e7          	jalr	-1556(ra) # 800034ca <argaddr>
  argint(2, &len);
    80003ae6:	fdc40593          	addi	a1,s0,-36
    80003aea:	4509                	li	a0,2
    80003aec:	00000097          	auipc	ra,0x0
    80003af0:	9be080e7          	jalr	-1602(ra) # 800034aa <argint>
  argint(3, &flags);
    80003af4:	fd840593          	addi	a1,s0,-40
    80003af8:	450d                	li	a0,3
    80003afa:	00000097          	auipc	ra,0x0
    80003afe:	9b0080e7          	jalr	-1616(ra) # 800034aa <argint>

  struct file *f = myproc()->ofile[fd];
    80003b02:	ffffe097          	auipc	ra,0xffffe
    80003b06:	37c080e7          	jalr	892(ra) # 80001e7e <myproc>
    80003b0a:	fec42703          	lw	a4,-20(s0)
    80003b0e:	00371793          	slli	a5,a4,0x3
    80003b12:	0d078793          	addi	a5,a5,208
    80003b16:	97aa                	add	a5,a5,a0
    80003b18:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003b1a:	c795                	beqz	a5,80003b46 <sys_send+0x84>
    80003b1c:	4394                	lw	a3,0(a5)
    80003b1e:	4791                	li	a5,4
    return -1;
    80003b20:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003b22:	00f68663          	beq	a3,a5,80003b2e <sys_send+0x6c>

  return send(fd, (uint64 *)buf, len, flags);
}
    80003b26:	70a2                	ld	ra,40(sp)
    80003b28:	7402                	ld	s0,32(sp)
    80003b2a:	6145                	addi	sp,sp,48
    80003b2c:	8082                	ret
  return send(fd, (uint64 *)buf, len, flags);
    80003b2e:	fd842683          	lw	a3,-40(s0)
    80003b32:	fdc42603          	lw	a2,-36(s0)
    80003b36:	fe043583          	ld	a1,-32(s0)
    80003b3a:	853a                	mv	a0,a4
    80003b3c:	00005097          	auipc	ra,0x5
    80003b40:	b8a080e7          	jalr	-1142(ra) # 800086c6 <send>
    80003b44:	b7cd                	j	80003b26 <sys_send+0x64>
    return -1;
    80003b46:	557d                	li	a0,-1
    80003b48:	bff9                	j	80003b26 <sys_send+0x64>

0000000080003b4a <sys_recv>:

uint64 sys_recv(void *arg) {
    80003b4a:	7179                	addi	sp,sp,-48
    80003b4c:	f406                	sd	ra,40(sp)
    80003b4e:	f022                	sd	s0,32(sp)
    80003b50:	1800                	addi	s0,sp,48
  int fd;
  uint64 buf;
  int len;
  int flags;

  argint(0, &fd);
    80003b52:	fec40593          	addi	a1,s0,-20
    80003b56:	4501                	li	a0,0
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	952080e7          	jalr	-1710(ra) # 800034aa <argint>
  argaddr(1, &buf);
    80003b60:	fe040593          	addi	a1,s0,-32
    80003b64:	4505                	li	a0,1
    80003b66:	00000097          	auipc	ra,0x0
    80003b6a:	964080e7          	jalr	-1692(ra) # 800034ca <argaddr>
  argint(2, &len);
    80003b6e:	fdc40593          	addi	a1,s0,-36
    80003b72:	4509                	li	a0,2
    80003b74:	00000097          	auipc	ra,0x0
    80003b78:	936080e7          	jalr	-1738(ra) # 800034aa <argint>
  argint(3, &flags);
    80003b7c:	fd840593          	addi	a1,s0,-40
    80003b80:	450d                	li	a0,3
    80003b82:	00000097          	auipc	ra,0x0
    80003b86:	928080e7          	jalr	-1752(ra) # 800034aa <argint>

  struct file *f = myproc()->ofile[fd];
    80003b8a:	ffffe097          	auipc	ra,0xffffe
    80003b8e:	2f4080e7          	jalr	756(ra) # 80001e7e <myproc>
    80003b92:	fec42703          	lw	a4,-20(s0)
    80003b96:	00371793          	slli	a5,a4,0x3
    80003b9a:	0d078793          	addi	a5,a5,208
    80003b9e:	97aa                	add	a5,a5,a0
    80003ba0:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003ba2:	c795                	beqz	a5,80003bce <sys_recv+0x84>
    80003ba4:	4394                	lw	a3,0(a5)
    80003ba6:	4791                	li	a5,4
    return -1;
    80003ba8:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003baa:	00f68663          	beq	a3,a5,80003bb6 <sys_recv+0x6c>

  return recv(fd, (uint64 *)buf, len, flags);
}
    80003bae:	70a2                	ld	ra,40(sp)
    80003bb0:	7402                	ld	s0,32(sp)
    80003bb2:	6145                	addi	sp,sp,48
    80003bb4:	8082                	ret
  return recv(fd, (uint64 *)buf, len, flags);
    80003bb6:	fd842683          	lw	a3,-40(s0)
    80003bba:	fdc42603          	lw	a2,-36(s0)
    80003bbe:	fe043583          	ld	a1,-32(s0)
    80003bc2:	853a                	mv	a0,a4
    80003bc4:	00005097          	auipc	ra,0x5
    80003bc8:	b14080e7          	jalr	-1260(ra) # 800086d8 <recv>
    80003bcc:	b7cd                	j	80003bae <sys_recv+0x64>
    return -1;
    80003bce:	557d                	li	a0,-1
    80003bd0:	bff9                	j	80003bae <sys_recv+0x64>

0000000080003bd2 <sys_sendto>:

uint64 sys_sendto(void) {
    80003bd2:	7139                	addi	sp,sp,-64
    80003bd4:	fc06                	sd	ra,56(sp)
    80003bd6:	f822                	sd	s0,48(sp)
    80003bd8:	0080                	addi	s0,sp,64
  int len;
  int flags;
  uint64 dest_addr;
  int addrlen;

  argint(0, &fd);
    80003bda:	fec40593          	addi	a1,s0,-20
    80003bde:	4501                	li	a0,0
    80003be0:	00000097          	auipc	ra,0x0
    80003be4:	8ca080e7          	jalr	-1846(ra) # 800034aa <argint>
  argaddr(1, &buf);
    80003be8:	fe040593          	addi	a1,s0,-32
    80003bec:	4505                	li	a0,1
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	8dc080e7          	jalr	-1828(ra) # 800034ca <argaddr>
  argint(2, &len);
    80003bf6:	fdc40593          	addi	a1,s0,-36
    80003bfa:	4509                	li	a0,2
    80003bfc:	00000097          	auipc	ra,0x0
    80003c00:	8ae080e7          	jalr	-1874(ra) # 800034aa <argint>
  argint(3, &flags);
    80003c04:	fd840593          	addi	a1,s0,-40
    80003c08:	450d                	li	a0,3
    80003c0a:	00000097          	auipc	ra,0x0
    80003c0e:	8a0080e7          	jalr	-1888(ra) # 800034aa <argint>
  argaddr(4, &dest_addr);
    80003c12:	fd040593          	addi	a1,s0,-48
    80003c16:	4511                	li	a0,4
    80003c18:	00000097          	auipc	ra,0x0
    80003c1c:	8b2080e7          	jalr	-1870(ra) # 800034ca <argaddr>
  argint(5, &addrlen);
    80003c20:	fcc40593          	addi	a1,s0,-52
    80003c24:	4515                	li	a0,5
    80003c26:	00000097          	auipc	ra,0x0
    80003c2a:	884080e7          	jalr	-1916(ra) # 800034aa <argint>

  struct file *f = myproc()->ofile[fd];
    80003c2e:	ffffe097          	auipc	ra,0xffffe
    80003c32:	250080e7          	jalr	592(ra) # 80001e7e <myproc>
    80003c36:	fec42803          	lw	a6,-20(s0)
    80003c3a:	00381793          	slli	a5,a6,0x3
    80003c3e:	0d078793          	addi	a5,a5,208
    80003c42:	97aa                	add	a5,a5,a0
    80003c44:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003c46:	cb95                	beqz	a5,80003c7a <sys_sendto+0xa8>
    80003c48:	4398                	lw	a4,0(a5)
    80003c4a:	4791                	li	a5,4
    return -1;
    80003c4c:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003c4e:	00f70663          	beq	a4,a5,80003c5a <sys_sendto+0x88>

  return sendto(fd, (uint64 *)buf, len, flags,
                     (struct sockaddr *)dest_addr, addrlen);
}
    80003c52:	70e2                	ld	ra,56(sp)
    80003c54:	7442                	ld	s0,48(sp)
    80003c56:	6121                	addi	sp,sp,64
    80003c58:	8082                	ret
  return sendto(fd, (uint64 *)buf, len, flags,
    80003c5a:	fcc42783          	lw	a5,-52(s0)
    80003c5e:	fd043703          	ld	a4,-48(s0)
    80003c62:	fd842683          	lw	a3,-40(s0)
    80003c66:	fdc42603          	lw	a2,-36(s0)
    80003c6a:	fe043583          	ld	a1,-32(s0)
    80003c6e:	8542                	mv	a0,a6
    80003c70:	00005097          	auipc	ra,0x5
    80003c74:	a7a080e7          	jalr	-1414(ra) # 800086ea <sendto>
    80003c78:	bfe9                	j	80003c52 <sys_sendto+0x80>
    return -1;
    80003c7a:	557d                	li	a0,-1
    80003c7c:	bfd9                	j	80003c52 <sys_sendto+0x80>

0000000080003c7e <sys_recvfrom>:

uint64 sys_recvfrom(void *arg) {
    80003c7e:	7139                	addi	sp,sp,-64
    80003c80:	fc06                	sd	ra,56(sp)
    80003c82:	f822                	sd	s0,48(sp)
    80003c84:	0080                	addi	s0,sp,64
  int len;
  int flags;
  uint64 src_addr;
  uint64 addrlen;

  argint(0, &fd);
    80003c86:	fec40593          	addi	a1,s0,-20
    80003c8a:	4501                	li	a0,0
    80003c8c:	00000097          	auipc	ra,0x0
    80003c90:	81e080e7          	jalr	-2018(ra) # 800034aa <argint>
  argaddr(1, &buf);
    80003c94:	fe040593          	addi	a1,s0,-32
    80003c98:	4505                	li	a0,1
    80003c9a:	00000097          	auipc	ra,0x0
    80003c9e:	830080e7          	jalr	-2000(ra) # 800034ca <argaddr>
  argint(2, &len);
    80003ca2:	fdc40593          	addi	a1,s0,-36
    80003ca6:	4509                	li	a0,2
    80003ca8:	00000097          	auipc	ra,0x0
    80003cac:	802080e7          	jalr	-2046(ra) # 800034aa <argint>
  argint(3, &flags);
    80003cb0:	fd840593          	addi	a1,s0,-40
    80003cb4:	450d                	li	a0,3
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	7f4080e7          	jalr	2036(ra) # 800034aa <argint>
  argaddr(4, &src_addr);
    80003cbe:	fd040593          	addi	a1,s0,-48
    80003cc2:	4511                	li	a0,4
    80003cc4:	00000097          	auipc	ra,0x0
    80003cc8:	806080e7          	jalr	-2042(ra) # 800034ca <argaddr>
  argaddr(5, &addrlen);
    80003ccc:	fc840593          	addi	a1,s0,-56
    80003cd0:	4515                	li	a0,5
    80003cd2:	fffff097          	auipc	ra,0xfffff
    80003cd6:	7f8080e7          	jalr	2040(ra) # 800034ca <argaddr>

  struct file *f = myproc()->ofile[fd];
    80003cda:	ffffe097          	auipc	ra,0xffffe
    80003cde:	1a4080e7          	jalr	420(ra) # 80001e7e <myproc>
    80003ce2:	fec42803          	lw	a6,-20(s0)
    80003ce6:	00381793          	slli	a5,a6,0x3
    80003cea:	0d078793          	addi	a5,a5,208
    80003cee:	97aa                	add	a5,a5,a0
    80003cf0:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003cf2:	cb95                	beqz	a5,80003d26 <sys_recvfrom+0xa8>
    80003cf4:	4398                	lw	a4,0(a5)
    80003cf6:	4791                	li	a5,4
    return -1;
    80003cf8:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003cfa:	00f70663          	beq	a4,a5,80003d06 <sys_recvfrom+0x88>

  return recvfrom(fd, (uint64 *)buf, len, flags,
                       (struct sockaddr *)src_addr,
                       (socklen_t *)addrlen);
}
    80003cfe:	70e2                	ld	ra,56(sp)
    80003d00:	7442                	ld	s0,48(sp)
    80003d02:	6121                	addi	sp,sp,64
    80003d04:	8082                	ret
  return recvfrom(fd, (uint64 *)buf, len, flags,
    80003d06:	fc843783          	ld	a5,-56(s0)
    80003d0a:	fd043703          	ld	a4,-48(s0)
    80003d0e:	fd842683          	lw	a3,-40(s0)
    80003d12:	fdc42603          	lw	a2,-36(s0)
    80003d16:	fe043583          	ld	a1,-32(s0)
    80003d1a:	8542                	mv	a0,a6
    80003d1c:	00005097          	auipc	ra,0x5
    80003d20:	a1c080e7          	jalr	-1508(ra) # 80008738 <recvfrom>
    80003d24:	bfe9                	j	80003cfe <sys_recvfrom+0x80>
    return -1;
    80003d26:	557d                	li	a0,-1
    80003d28:	bfd9                	j	80003cfe <sys_recvfrom+0x80>

0000000080003d2a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003d2a:	7179                	addi	sp,sp,-48
    80003d2c:	f406                	sd	ra,40(sp)
    80003d2e:	f022                	sd	s0,32(sp)
    80003d30:	ec26                	sd	s1,24(sp)
    80003d32:	e84a                	sd	s2,16(sp)
    80003d34:	e44e                	sd	s3,8(sp)
    80003d36:	e052                	sd	s4,0(sp)
    80003d38:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003d3a:	00007597          	auipc	a1,0x7
    80003d3e:	74e58593          	addi	a1,a1,1870 # 8000b488 <etext+0x488>
    80003d42:	00062517          	auipc	a0,0x62
    80003d46:	2f650513          	addi	a0,a0,758 # 80066038 <bcache>
    80003d4a:	ffffd097          	auipc	ra,0xffffd
    80003d4e:	f50080e7          	jalr	-176(ra) # 80000c9a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003d52:	0006a797          	auipc	a5,0x6a
    80003d56:	2e678793          	addi	a5,a5,742 # 8006e038 <bcache+0x8000>
    80003d5a:	0006a717          	auipc	a4,0x6a
    80003d5e:	54670713          	addi	a4,a4,1350 # 8006e2a0 <bcache+0x8268>
    80003d62:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003d66:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003d6a:	00062497          	auipc	s1,0x62
    80003d6e:	2e648493          	addi	s1,s1,742 # 80066050 <bcache+0x18>
    b->next = bcache.head.next;
    80003d72:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003d74:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003d76:	00007a17          	auipc	s4,0x7
    80003d7a:	71aa0a13          	addi	s4,s4,1818 # 8000b490 <etext+0x490>
    b->next = bcache.head.next;
    80003d7e:	2b893783          	ld	a5,696(s2)
    80003d82:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003d84:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003d88:	85d2                	mv	a1,s4
    80003d8a:	01048513          	addi	a0,s1,16
    80003d8e:	00001097          	auipc	ra,0x1
    80003d92:	4ec080e7          	jalr	1260(ra) # 8000527a <initsleeplock>
    bcache.head.next->prev = b;
    80003d96:	2b893783          	ld	a5,696(s2)
    80003d9a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003d9c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003da0:	45848493          	addi	s1,s1,1112
    80003da4:	fd349de3          	bne	s1,s3,80003d7e <binit+0x54>
  }
}
    80003da8:	70a2                	ld	ra,40(sp)
    80003daa:	7402                	ld	s0,32(sp)
    80003dac:	64e2                	ld	s1,24(sp)
    80003dae:	6942                	ld	s2,16(sp)
    80003db0:	69a2                	ld	s3,8(sp)
    80003db2:	6a02                	ld	s4,0(sp)
    80003db4:	6145                	addi	sp,sp,48
    80003db6:	8082                	ret

0000000080003db8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003db8:	7179                	addi	sp,sp,-48
    80003dba:	f406                	sd	ra,40(sp)
    80003dbc:	f022                	sd	s0,32(sp)
    80003dbe:	ec26                	sd	s1,24(sp)
    80003dc0:	e84a                	sd	s2,16(sp)
    80003dc2:	e44e                	sd	s3,8(sp)
    80003dc4:	1800                	addi	s0,sp,48
    80003dc6:	892a                	mv	s2,a0
    80003dc8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003dca:	00062517          	auipc	a0,0x62
    80003dce:	26e50513          	addi	a0,a0,622 # 80066038 <bcache>
    80003dd2:	ffffd097          	auipc	ra,0xffffd
    80003dd6:	f62080e7          	jalr	-158(ra) # 80000d34 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003dda:	0006a497          	auipc	s1,0x6a
    80003dde:	5164b483          	ld	s1,1302(s1) # 8006e2f0 <bcache+0x82b8>
    80003de2:	0006a797          	auipc	a5,0x6a
    80003de6:	4be78793          	addi	a5,a5,1214 # 8006e2a0 <bcache+0x8268>
    80003dea:	02f48f63          	beq	s1,a5,80003e28 <bread+0x70>
    80003dee:	873e                	mv	a4,a5
    80003df0:	a021                	j	80003df8 <bread+0x40>
    80003df2:	68a4                	ld	s1,80(s1)
    80003df4:	02e48a63          	beq	s1,a4,80003e28 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003df8:	449c                	lw	a5,8(s1)
    80003dfa:	ff279ce3          	bne	a5,s2,80003df2 <bread+0x3a>
    80003dfe:	44dc                	lw	a5,12(s1)
    80003e00:	ff3799e3          	bne	a5,s3,80003df2 <bread+0x3a>
      b->refcnt++;
    80003e04:	40bc                	lw	a5,64(s1)
    80003e06:	2785                	addiw	a5,a5,1
    80003e08:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003e0a:	00062517          	auipc	a0,0x62
    80003e0e:	22e50513          	addi	a0,a0,558 # 80066038 <bcache>
    80003e12:	ffffd097          	auipc	ra,0xffffd
    80003e16:	fd2080e7          	jalr	-46(ra) # 80000de4 <release>
      acquiresleep(&b->lock);
    80003e1a:	01048513          	addi	a0,s1,16
    80003e1e:	00001097          	auipc	ra,0x1
    80003e22:	496080e7          	jalr	1174(ra) # 800052b4 <acquiresleep>
      return b;
    80003e26:	a8b9                	j	80003e84 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003e28:	0006a497          	auipc	s1,0x6a
    80003e2c:	4c04b483          	ld	s1,1216(s1) # 8006e2e8 <bcache+0x82b0>
    80003e30:	0006a797          	auipc	a5,0x6a
    80003e34:	47078793          	addi	a5,a5,1136 # 8006e2a0 <bcache+0x8268>
    80003e38:	00f48863          	beq	s1,a5,80003e48 <bread+0x90>
    80003e3c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003e3e:	40bc                	lw	a5,64(s1)
    80003e40:	cf81                	beqz	a5,80003e58 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003e42:	64a4                	ld	s1,72(s1)
    80003e44:	fee49de3          	bne	s1,a4,80003e3e <bread+0x86>
  panic("bget: no buffers");
    80003e48:	00007517          	auipc	a0,0x7
    80003e4c:	65050513          	addi	a0,a0,1616 # 8000b498 <etext+0x498>
    80003e50:	ffffc097          	auipc	ra,0xffffc
    80003e54:	70e080e7          	jalr	1806(ra) # 8000055e <panic>
      b->dev = dev;
    80003e58:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003e5c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003e60:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003e64:	4785                	li	a5,1
    80003e66:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003e68:	00062517          	auipc	a0,0x62
    80003e6c:	1d050513          	addi	a0,a0,464 # 80066038 <bcache>
    80003e70:	ffffd097          	auipc	ra,0xffffd
    80003e74:	f74080e7          	jalr	-140(ra) # 80000de4 <release>
      acquiresleep(&b->lock);
    80003e78:	01048513          	addi	a0,s1,16
    80003e7c:	00001097          	auipc	ra,0x1
    80003e80:	438080e7          	jalr	1080(ra) # 800052b4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003e84:	409c                	lw	a5,0(s1)
    80003e86:	cb89                	beqz	a5,80003e98 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003e88:	8526                	mv	a0,s1
    80003e8a:	70a2                	ld	ra,40(sp)
    80003e8c:	7402                	ld	s0,32(sp)
    80003e8e:	64e2                	ld	s1,24(sp)
    80003e90:	6942                	ld	s2,16(sp)
    80003e92:	69a2                	ld	s3,8(sp)
    80003e94:	6145                	addi	sp,sp,48
    80003e96:	8082                	ret
    virtio_disk_rw(b, 0);
    80003e98:	4581                	li	a1,0
    80003e9a:	8526                	mv	a0,s1
    80003e9c:	00003097          	auipc	ra,0x3
    80003ea0:	15e080e7          	jalr	350(ra) # 80006ffa <virtio_disk_rw>
    b->valid = 1;
    80003ea4:	4785                	li	a5,1
    80003ea6:	c09c                	sw	a5,0(s1)
  return b;
    80003ea8:	b7c5                	j	80003e88 <bread+0xd0>

0000000080003eaa <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003eaa:	1101                	addi	sp,sp,-32
    80003eac:	ec06                	sd	ra,24(sp)
    80003eae:	e822                	sd	s0,16(sp)
    80003eb0:	e426                	sd	s1,8(sp)
    80003eb2:	1000                	addi	s0,sp,32
    80003eb4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003eb6:	0541                	addi	a0,a0,16
    80003eb8:	00001097          	auipc	ra,0x1
    80003ebc:	496080e7          	jalr	1174(ra) # 8000534e <holdingsleep>
    80003ec0:	cd01                	beqz	a0,80003ed8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003ec2:	4585                	li	a1,1
    80003ec4:	8526                	mv	a0,s1
    80003ec6:	00003097          	auipc	ra,0x3
    80003eca:	134080e7          	jalr	308(ra) # 80006ffa <virtio_disk_rw>
}
    80003ece:	60e2                	ld	ra,24(sp)
    80003ed0:	6442                	ld	s0,16(sp)
    80003ed2:	64a2                	ld	s1,8(sp)
    80003ed4:	6105                	addi	sp,sp,32
    80003ed6:	8082                	ret
    panic("bwrite");
    80003ed8:	00007517          	auipc	a0,0x7
    80003edc:	5d850513          	addi	a0,a0,1496 # 8000b4b0 <etext+0x4b0>
    80003ee0:	ffffc097          	auipc	ra,0xffffc
    80003ee4:	67e080e7          	jalr	1662(ra) # 8000055e <panic>

0000000080003ee8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003ee8:	1101                	addi	sp,sp,-32
    80003eea:	ec06                	sd	ra,24(sp)
    80003eec:	e822                	sd	s0,16(sp)
    80003eee:	e426                	sd	s1,8(sp)
    80003ef0:	e04a                	sd	s2,0(sp)
    80003ef2:	1000                	addi	s0,sp,32
    80003ef4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003ef6:	01050913          	addi	s2,a0,16
    80003efa:	854a                	mv	a0,s2
    80003efc:	00001097          	auipc	ra,0x1
    80003f00:	452080e7          	jalr	1106(ra) # 8000534e <holdingsleep>
    80003f04:	c535                	beqz	a0,80003f70 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003f06:	854a                	mv	a0,s2
    80003f08:	00001097          	auipc	ra,0x1
    80003f0c:	402080e7          	jalr	1026(ra) # 8000530a <releasesleep>

  acquire(&bcache.lock);
    80003f10:	00062517          	auipc	a0,0x62
    80003f14:	12850513          	addi	a0,a0,296 # 80066038 <bcache>
    80003f18:	ffffd097          	auipc	ra,0xffffd
    80003f1c:	e1c080e7          	jalr	-484(ra) # 80000d34 <acquire>
  b->refcnt--;
    80003f20:	40bc                	lw	a5,64(s1)
    80003f22:	37fd                	addiw	a5,a5,-1
    80003f24:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003f26:	e79d                	bnez	a5,80003f54 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003f28:	68b8                	ld	a4,80(s1)
    80003f2a:	64bc                	ld	a5,72(s1)
    80003f2c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003f2e:	68b8                	ld	a4,80(s1)
    80003f30:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003f32:	0006a797          	auipc	a5,0x6a
    80003f36:	10678793          	addi	a5,a5,262 # 8006e038 <bcache+0x8000>
    80003f3a:	2b87b703          	ld	a4,696(a5)
    80003f3e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003f40:	0006a717          	auipc	a4,0x6a
    80003f44:	36070713          	addi	a4,a4,864 # 8006e2a0 <bcache+0x8268>
    80003f48:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003f4a:	2b87b703          	ld	a4,696(a5)
    80003f4e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003f50:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003f54:	00062517          	auipc	a0,0x62
    80003f58:	0e450513          	addi	a0,a0,228 # 80066038 <bcache>
    80003f5c:	ffffd097          	auipc	ra,0xffffd
    80003f60:	e88080e7          	jalr	-376(ra) # 80000de4 <release>
}
    80003f64:	60e2                	ld	ra,24(sp)
    80003f66:	6442                	ld	s0,16(sp)
    80003f68:	64a2                	ld	s1,8(sp)
    80003f6a:	6902                	ld	s2,0(sp)
    80003f6c:	6105                	addi	sp,sp,32
    80003f6e:	8082                	ret
    panic("brelse");
    80003f70:	00007517          	auipc	a0,0x7
    80003f74:	54850513          	addi	a0,a0,1352 # 8000b4b8 <etext+0x4b8>
    80003f78:	ffffc097          	auipc	ra,0xffffc
    80003f7c:	5e6080e7          	jalr	1510(ra) # 8000055e <panic>

0000000080003f80 <bpin>:

void
bpin(struct buf *b) {
    80003f80:	1101                	addi	sp,sp,-32
    80003f82:	ec06                	sd	ra,24(sp)
    80003f84:	e822                	sd	s0,16(sp)
    80003f86:	e426                	sd	s1,8(sp)
    80003f88:	1000                	addi	s0,sp,32
    80003f8a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003f8c:	00062517          	auipc	a0,0x62
    80003f90:	0ac50513          	addi	a0,a0,172 # 80066038 <bcache>
    80003f94:	ffffd097          	auipc	ra,0xffffd
    80003f98:	da0080e7          	jalr	-608(ra) # 80000d34 <acquire>
  b->refcnt++;
    80003f9c:	40bc                	lw	a5,64(s1)
    80003f9e:	2785                	addiw	a5,a5,1
    80003fa0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003fa2:	00062517          	auipc	a0,0x62
    80003fa6:	09650513          	addi	a0,a0,150 # 80066038 <bcache>
    80003faa:	ffffd097          	auipc	ra,0xffffd
    80003fae:	e3a080e7          	jalr	-454(ra) # 80000de4 <release>
}
    80003fb2:	60e2                	ld	ra,24(sp)
    80003fb4:	6442                	ld	s0,16(sp)
    80003fb6:	64a2                	ld	s1,8(sp)
    80003fb8:	6105                	addi	sp,sp,32
    80003fba:	8082                	ret

0000000080003fbc <bunpin>:

void
bunpin(struct buf *b) {
    80003fbc:	1101                	addi	sp,sp,-32
    80003fbe:	ec06                	sd	ra,24(sp)
    80003fc0:	e822                	sd	s0,16(sp)
    80003fc2:	e426                	sd	s1,8(sp)
    80003fc4:	1000                	addi	s0,sp,32
    80003fc6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003fc8:	00062517          	auipc	a0,0x62
    80003fcc:	07050513          	addi	a0,a0,112 # 80066038 <bcache>
    80003fd0:	ffffd097          	auipc	ra,0xffffd
    80003fd4:	d64080e7          	jalr	-668(ra) # 80000d34 <acquire>
  b->refcnt--;
    80003fd8:	40bc                	lw	a5,64(s1)
    80003fda:	37fd                	addiw	a5,a5,-1
    80003fdc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003fde:	00062517          	auipc	a0,0x62
    80003fe2:	05a50513          	addi	a0,a0,90 # 80066038 <bcache>
    80003fe6:	ffffd097          	auipc	ra,0xffffd
    80003fea:	dfe080e7          	jalr	-514(ra) # 80000de4 <release>
}
    80003fee:	60e2                	ld	ra,24(sp)
    80003ff0:	6442                	ld	s0,16(sp)
    80003ff2:	64a2                	ld	s1,8(sp)
    80003ff4:	6105                	addi	sp,sp,32
    80003ff6:	8082                	ret

0000000080003ff8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003ff8:	1101                	addi	sp,sp,-32
    80003ffa:	ec06                	sd	ra,24(sp)
    80003ffc:	e822                	sd	s0,16(sp)
    80003ffe:	e426                	sd	s1,8(sp)
    80004000:	e04a                	sd	s2,0(sp)
    80004002:	1000                	addi	s0,sp,32
    80004004:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80004006:	00d5d79b          	srliw	a5,a1,0xd
    8000400a:	0006a597          	auipc	a1,0x6a
    8000400e:	70a5a583          	lw	a1,1802(a1) # 8006e714 <sb+0x1c>
    80004012:	9dbd                	addw	a1,a1,a5
    80004014:	00000097          	auipc	ra,0x0
    80004018:	da4080e7          	jalr	-604(ra) # 80003db8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000401c:	0074f713          	andi	a4,s1,7
    80004020:	4785                	li	a5,1
    80004022:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80004026:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80004028:	90d9                	srli	s1,s1,0x36
    8000402a:	00950733          	add	a4,a0,s1
    8000402e:	05874703          	lbu	a4,88(a4)
    80004032:	00e7f6b3          	and	a3,a5,a4
    80004036:	c69d                	beqz	a3,80004064 <bfree+0x6c>
    80004038:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000403a:	94aa                	add	s1,s1,a0
    8000403c:	fff7c793          	not	a5,a5
    80004040:	8f7d                	and	a4,a4,a5
    80004042:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80004046:	00001097          	auipc	ra,0x1
    8000404a:	14e080e7          	jalr	334(ra) # 80005194 <log_write>
  brelse(bp);
    8000404e:	854a                	mv	a0,s2
    80004050:	00000097          	auipc	ra,0x0
    80004054:	e98080e7          	jalr	-360(ra) # 80003ee8 <brelse>
}
    80004058:	60e2                	ld	ra,24(sp)
    8000405a:	6442                	ld	s0,16(sp)
    8000405c:	64a2                	ld	s1,8(sp)
    8000405e:	6902                	ld	s2,0(sp)
    80004060:	6105                	addi	sp,sp,32
    80004062:	8082                	ret
    panic("freeing free block");
    80004064:	00007517          	auipc	a0,0x7
    80004068:	45c50513          	addi	a0,a0,1116 # 8000b4c0 <etext+0x4c0>
    8000406c:	ffffc097          	auipc	ra,0xffffc
    80004070:	4f2080e7          	jalr	1266(ra) # 8000055e <panic>

0000000080004074 <balloc>:
{
    80004074:	715d                	addi	sp,sp,-80
    80004076:	e486                	sd	ra,72(sp)
    80004078:	e0a2                	sd	s0,64(sp)
    8000407a:	fc26                	sd	s1,56(sp)
    8000407c:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000407e:	0006a797          	auipc	a5,0x6a
    80004082:	67e7a783          	lw	a5,1662(a5) # 8006e6fc <sb+0x4>
    80004086:	10078263          	beqz	a5,8000418a <balloc+0x116>
    8000408a:	f84a                	sd	s2,48(sp)
    8000408c:	f44e                	sd	s3,40(sp)
    8000408e:	f052                	sd	s4,32(sp)
    80004090:	ec56                	sd	s5,24(sp)
    80004092:	e85a                	sd	s6,16(sp)
    80004094:	e45e                	sd	s7,8(sp)
    80004096:	e062                	sd	s8,0(sp)
    80004098:	8baa                	mv	s7,a0
    8000409a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000409c:	0006ab17          	auipc	s6,0x6a
    800040a0:	65cb0b13          	addi	s6,s6,1628 # 8006e6f8 <sb>
      m = 1 << (bi % 8);
    800040a4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800040a6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800040a8:	6c09                	lui	s8,0x2
    800040aa:	a049                	j	8000412c <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    800040ac:	97ca                	add	a5,a5,s2
    800040ae:	8e55                	or	a2,a2,a3
    800040b0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800040b4:	854a                	mv	a0,s2
    800040b6:	00001097          	auipc	ra,0x1
    800040ba:	0de080e7          	jalr	222(ra) # 80005194 <log_write>
        brelse(bp);
    800040be:	854a                	mv	a0,s2
    800040c0:	00000097          	auipc	ra,0x0
    800040c4:	e28080e7          	jalr	-472(ra) # 80003ee8 <brelse>
  bp = bread(dev, bno);
    800040c8:	85a6                	mv	a1,s1
    800040ca:	855e                	mv	a0,s7
    800040cc:	00000097          	auipc	ra,0x0
    800040d0:	cec080e7          	jalr	-788(ra) # 80003db8 <bread>
    800040d4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800040d6:	40000613          	li	a2,1024
    800040da:	4581                	li	a1,0
    800040dc:	05850513          	addi	a0,a0,88
    800040e0:	ffffd097          	auipc	ra,0xffffd
    800040e4:	d4c080e7          	jalr	-692(ra) # 80000e2c <memset>
  log_write(bp);
    800040e8:	854a                	mv	a0,s2
    800040ea:	00001097          	auipc	ra,0x1
    800040ee:	0aa080e7          	jalr	170(ra) # 80005194 <log_write>
  brelse(bp);
    800040f2:	854a                	mv	a0,s2
    800040f4:	00000097          	auipc	ra,0x0
    800040f8:	df4080e7          	jalr	-524(ra) # 80003ee8 <brelse>
}
    800040fc:	7942                	ld	s2,48(sp)
    800040fe:	79a2                	ld	s3,40(sp)
    80004100:	7a02                	ld	s4,32(sp)
    80004102:	6ae2                	ld	s5,24(sp)
    80004104:	6b42                	ld	s6,16(sp)
    80004106:	6ba2                	ld	s7,8(sp)
    80004108:	6c02                	ld	s8,0(sp)
}
    8000410a:	8526                	mv	a0,s1
    8000410c:	60a6                	ld	ra,72(sp)
    8000410e:	6406                	ld	s0,64(sp)
    80004110:	74e2                	ld	s1,56(sp)
    80004112:	6161                	addi	sp,sp,80
    80004114:	8082                	ret
    brelse(bp);
    80004116:	854a                	mv	a0,s2
    80004118:	00000097          	auipc	ra,0x0
    8000411c:	dd0080e7          	jalr	-560(ra) # 80003ee8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004120:	015c0abb          	addw	s5,s8,s5
    80004124:	004b2783          	lw	a5,4(s6)
    80004128:	04fafa63          	bgeu	s5,a5,8000417c <balloc+0x108>
    bp = bread(dev, BBLOCK(b, sb));
    8000412c:	40dad59b          	sraiw	a1,s5,0xd
    80004130:	01cb2783          	lw	a5,28(s6)
    80004134:	9dbd                	addw	a1,a1,a5
    80004136:	855e                	mv	a0,s7
    80004138:	00000097          	auipc	ra,0x0
    8000413c:	c80080e7          	jalr	-896(ra) # 80003db8 <bread>
    80004140:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004142:	004b2503          	lw	a0,4(s6)
    80004146:	84d6                	mv	s1,s5
    80004148:	4701                	li	a4,0
    8000414a:	fca4f6e3          	bgeu	s1,a0,80004116 <balloc+0xa2>
      m = 1 << (bi % 8);
    8000414e:	00777693          	andi	a3,a4,7
    80004152:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004156:	41f7579b          	sraiw	a5,a4,0x1f
    8000415a:	01d7d79b          	srliw	a5,a5,0x1d
    8000415e:	9fb9                	addw	a5,a5,a4
    80004160:	4037d79b          	sraiw	a5,a5,0x3
    80004164:	00f90633          	add	a2,s2,a5
    80004168:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    8000416c:	00c6f5b3          	and	a1,a3,a2
    80004170:	dd95                	beqz	a1,800040ac <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004172:	2705                	addiw	a4,a4,1
    80004174:	2485                	addiw	s1,s1,1
    80004176:	fd471ae3          	bne	a4,s4,8000414a <balloc+0xd6>
    8000417a:	bf71                	j	80004116 <balloc+0xa2>
    8000417c:	7942                	ld	s2,48(sp)
    8000417e:	79a2                	ld	s3,40(sp)
    80004180:	7a02                	ld	s4,32(sp)
    80004182:	6ae2                	ld	s5,24(sp)
    80004184:	6b42                	ld	s6,16(sp)
    80004186:	6ba2                	ld	s7,8(sp)
    80004188:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000418a:	00007517          	auipc	a0,0x7
    8000418e:	34e50513          	addi	a0,a0,846 # 8000b4d8 <etext+0x4d8>
    80004192:	ffffc097          	auipc	ra,0xffffc
    80004196:	416080e7          	jalr	1046(ra) # 800005a8 <printf>
  return 0;
    8000419a:	4481                	li	s1,0
    8000419c:	b7bd                	j	8000410a <balloc+0x96>

000000008000419e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000419e:	7179                	addi	sp,sp,-48
    800041a0:	f406                	sd	ra,40(sp)
    800041a2:	f022                	sd	s0,32(sp)
    800041a4:	ec26                	sd	s1,24(sp)
    800041a6:	e84a                	sd	s2,16(sp)
    800041a8:	e44e                	sd	s3,8(sp)
    800041aa:	1800                	addi	s0,sp,48
    800041ac:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800041ae:	47ad                	li	a5,11
    800041b0:	02b7e563          	bltu	a5,a1,800041da <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    800041b4:	02059793          	slli	a5,a1,0x20
    800041b8:	01e7d593          	srli	a1,a5,0x1e
    800041bc:	00b509b3          	add	s3,a0,a1
    800041c0:	0509a483          	lw	s1,80(s3)
    800041c4:	e8b5                	bnez	s1,80004238 <bmap+0x9a>
      addr = balloc(ip->dev);
    800041c6:	4108                	lw	a0,0(a0)
    800041c8:	00000097          	auipc	ra,0x0
    800041cc:	eac080e7          	jalr	-340(ra) # 80004074 <balloc>
    800041d0:	84aa                	mv	s1,a0
      if(addr == 0)
    800041d2:	c13d                	beqz	a0,80004238 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800041d4:	04a9a823          	sw	a0,80(s3)
    800041d8:	a085                	j	80004238 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800041da:	ff45879b          	addiw	a5,a1,-12
    800041de:	873e                	mv	a4,a5
    800041e0:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    800041e2:	0ff00793          	li	a5,255
    800041e6:	08e7e163          	bltu	a5,a4,80004268 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800041ea:	08052483          	lw	s1,128(a0)
    800041ee:	ec81                	bnez	s1,80004206 <bmap+0x68>
      addr = balloc(ip->dev);
    800041f0:	4108                	lw	a0,0(a0)
    800041f2:	00000097          	auipc	ra,0x0
    800041f6:	e82080e7          	jalr	-382(ra) # 80004074 <balloc>
    800041fa:	84aa                	mv	s1,a0
      if(addr == 0)
    800041fc:	cd15                	beqz	a0,80004238 <bmap+0x9a>
    800041fe:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80004200:	08a92023          	sw	a0,128(s2)
    80004204:	a011                	j	80004208 <bmap+0x6a>
    80004206:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80004208:	85a6                	mv	a1,s1
    8000420a:	00092503          	lw	a0,0(s2)
    8000420e:	00000097          	auipc	ra,0x0
    80004212:	baa080e7          	jalr	-1110(ra) # 80003db8 <bread>
    80004216:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80004218:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000421c:	02099713          	slli	a4,s3,0x20
    80004220:	01e75593          	srli	a1,a4,0x1e
    80004224:	97ae                	add	a5,a5,a1
    80004226:	89be                	mv	s3,a5
    80004228:	4384                	lw	s1,0(a5)
    8000422a:	cc99                	beqz	s1,80004248 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000422c:	8552                	mv	a0,s4
    8000422e:	00000097          	auipc	ra,0x0
    80004232:	cba080e7          	jalr	-838(ra) # 80003ee8 <brelse>
    return addr;
    80004236:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80004238:	8526                	mv	a0,s1
    8000423a:	70a2                	ld	ra,40(sp)
    8000423c:	7402                	ld	s0,32(sp)
    8000423e:	64e2                	ld	s1,24(sp)
    80004240:	6942                	ld	s2,16(sp)
    80004242:	69a2                	ld	s3,8(sp)
    80004244:	6145                	addi	sp,sp,48
    80004246:	8082                	ret
      addr = balloc(ip->dev);
    80004248:	00092503          	lw	a0,0(s2)
    8000424c:	00000097          	auipc	ra,0x0
    80004250:	e28080e7          	jalr	-472(ra) # 80004074 <balloc>
    80004254:	84aa                	mv	s1,a0
      if(addr){
    80004256:	d979                	beqz	a0,8000422c <bmap+0x8e>
        a[bn] = addr;
    80004258:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    8000425c:	8552                	mv	a0,s4
    8000425e:	00001097          	auipc	ra,0x1
    80004262:	f36080e7          	jalr	-202(ra) # 80005194 <log_write>
    80004266:	b7d9                	j	8000422c <bmap+0x8e>
    80004268:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000426a:	00007517          	auipc	a0,0x7
    8000426e:	28650513          	addi	a0,a0,646 # 8000b4f0 <etext+0x4f0>
    80004272:	ffffc097          	auipc	ra,0xffffc
    80004276:	2ec080e7          	jalr	748(ra) # 8000055e <panic>

000000008000427a <iget>:
{
    8000427a:	7179                	addi	sp,sp,-48
    8000427c:	f406                	sd	ra,40(sp)
    8000427e:	f022                	sd	s0,32(sp)
    80004280:	ec26                	sd	s1,24(sp)
    80004282:	e84a                	sd	s2,16(sp)
    80004284:	e44e                	sd	s3,8(sp)
    80004286:	e052                	sd	s4,0(sp)
    80004288:	1800                	addi	s0,sp,48
    8000428a:	892a                	mv	s2,a0
    8000428c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000428e:	0006a517          	auipc	a0,0x6a
    80004292:	48a50513          	addi	a0,a0,1162 # 8006e718 <itable>
    80004296:	ffffd097          	auipc	ra,0xffffd
    8000429a:	a9e080e7          	jalr	-1378(ra) # 80000d34 <acquire>
  empty = 0;
    8000429e:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800042a0:	0006a497          	auipc	s1,0x6a
    800042a4:	49048493          	addi	s1,s1,1168 # 8006e730 <itable+0x18>
    800042a8:	0006c697          	auipc	a3,0x6c
    800042ac:	f1868693          	addi	a3,a3,-232 # 800701c0 <log>
    800042b0:	a809                	j	800042c2 <iget+0x48>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800042b2:	e781                	bnez	a5,800042ba <iget+0x40>
    800042b4:	00099363          	bnez	s3,800042ba <iget+0x40>
      empty = ip;
    800042b8:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800042ba:	08848493          	addi	s1,s1,136
    800042be:	02d48763          	beq	s1,a3,800042ec <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800042c2:	449c                	lw	a5,8(s1)
    800042c4:	fef057e3          	blez	a5,800042b2 <iget+0x38>
    800042c8:	4098                	lw	a4,0(s1)
    800042ca:	ff2718e3          	bne	a4,s2,800042ba <iget+0x40>
    800042ce:	40d8                	lw	a4,4(s1)
    800042d0:	ff4715e3          	bne	a4,s4,800042ba <iget+0x40>
      ip->ref++;
    800042d4:	2785                	addiw	a5,a5,1
    800042d6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800042d8:	0006a517          	auipc	a0,0x6a
    800042dc:	44050513          	addi	a0,a0,1088 # 8006e718 <itable>
    800042e0:	ffffd097          	auipc	ra,0xffffd
    800042e4:	b04080e7          	jalr	-1276(ra) # 80000de4 <release>
      return ip;
    800042e8:	89a6                	mv	s3,s1
    800042ea:	a025                	j	80004312 <iget+0x98>
  if(empty == 0)
    800042ec:	02098c63          	beqz	s3,80004324 <iget+0xaa>
  ip->dev = dev;
    800042f0:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    800042f4:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    800042f8:	4785                	li	a5,1
    800042fa:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    800042fe:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80004302:	0006a517          	auipc	a0,0x6a
    80004306:	41650513          	addi	a0,a0,1046 # 8006e718 <itable>
    8000430a:	ffffd097          	auipc	ra,0xffffd
    8000430e:	ada080e7          	jalr	-1318(ra) # 80000de4 <release>
}
    80004312:	854e                	mv	a0,s3
    80004314:	70a2                	ld	ra,40(sp)
    80004316:	7402                	ld	s0,32(sp)
    80004318:	64e2                	ld	s1,24(sp)
    8000431a:	6942                	ld	s2,16(sp)
    8000431c:	69a2                	ld	s3,8(sp)
    8000431e:	6a02                	ld	s4,0(sp)
    80004320:	6145                	addi	sp,sp,48
    80004322:	8082                	ret
    panic("iget: no inodes");
    80004324:	00007517          	auipc	a0,0x7
    80004328:	1e450513          	addi	a0,a0,484 # 8000b508 <etext+0x508>
    8000432c:	ffffc097          	auipc	ra,0xffffc
    80004330:	232080e7          	jalr	562(ra) # 8000055e <panic>

0000000080004334 <fsinit>:
fsinit(int dev) {
    80004334:	1101                	addi	sp,sp,-32
    80004336:	ec06                	sd	ra,24(sp)
    80004338:	e822                	sd	s0,16(sp)
    8000433a:	e426                	sd	s1,8(sp)
    8000433c:	e04a                	sd	s2,0(sp)
    8000433e:	1000                	addi	s0,sp,32
    80004340:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80004342:	4585                	li	a1,1
    80004344:	00000097          	auipc	ra,0x0
    80004348:	a74080e7          	jalr	-1420(ra) # 80003db8 <bread>
    8000434c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000434e:	02000613          	li	a2,32
    80004352:	05850593          	addi	a1,a0,88
    80004356:	0006a517          	auipc	a0,0x6a
    8000435a:	3a250513          	addi	a0,a0,930 # 8006e6f8 <sb>
    8000435e:	ffffd097          	auipc	ra,0xffffd
    80004362:	b2e080e7          	jalr	-1234(ra) # 80000e8c <memmove>
  brelse(bp);
    80004366:	8526                	mv	a0,s1
    80004368:	00000097          	auipc	ra,0x0
    8000436c:	b80080e7          	jalr	-1152(ra) # 80003ee8 <brelse>
  if(sb.magic != FSMAGIC)
    80004370:	0006a717          	auipc	a4,0x6a
    80004374:	38872703          	lw	a4,904(a4) # 8006e6f8 <sb>
    80004378:	102037b7          	lui	a5,0x10203
    8000437c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004380:	02f71163          	bne	a4,a5,800043a2 <fsinit+0x6e>
  initlog(dev, &sb);
    80004384:	0006a597          	auipc	a1,0x6a
    80004388:	37458593          	addi	a1,a1,884 # 8006e6f8 <sb>
    8000438c:	854a                	mv	a0,s2
    8000438e:	00001097          	auipc	ra,0x1
    80004392:	b80080e7          	jalr	-1152(ra) # 80004f0e <initlog>
}
    80004396:	60e2                	ld	ra,24(sp)
    80004398:	6442                	ld	s0,16(sp)
    8000439a:	64a2                	ld	s1,8(sp)
    8000439c:	6902                	ld	s2,0(sp)
    8000439e:	6105                	addi	sp,sp,32
    800043a0:	8082                	ret
    panic("invalid file system");
    800043a2:	00007517          	auipc	a0,0x7
    800043a6:	17650513          	addi	a0,a0,374 # 8000b518 <etext+0x518>
    800043aa:	ffffc097          	auipc	ra,0xffffc
    800043ae:	1b4080e7          	jalr	436(ra) # 8000055e <panic>

00000000800043b2 <iinit>:
{
    800043b2:	7179                	addi	sp,sp,-48
    800043b4:	f406                	sd	ra,40(sp)
    800043b6:	f022                	sd	s0,32(sp)
    800043b8:	ec26                	sd	s1,24(sp)
    800043ba:	e84a                	sd	s2,16(sp)
    800043bc:	e44e                	sd	s3,8(sp)
    800043be:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800043c0:	00007597          	auipc	a1,0x7
    800043c4:	17058593          	addi	a1,a1,368 # 8000b530 <etext+0x530>
    800043c8:	0006a517          	auipc	a0,0x6a
    800043cc:	35050513          	addi	a0,a0,848 # 8006e718 <itable>
    800043d0:	ffffd097          	auipc	ra,0xffffd
    800043d4:	8ca080e7          	jalr	-1846(ra) # 80000c9a <initlock>
  for(i = 0; i < NINODE; i++) {
    800043d8:	0006a497          	auipc	s1,0x6a
    800043dc:	36848493          	addi	s1,s1,872 # 8006e740 <itable+0x28>
    800043e0:	0006c997          	auipc	s3,0x6c
    800043e4:	df098993          	addi	s3,s3,-528 # 800701d0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800043e8:	00007917          	auipc	s2,0x7
    800043ec:	15090913          	addi	s2,s2,336 # 8000b538 <etext+0x538>
    800043f0:	85ca                	mv	a1,s2
    800043f2:	8526                	mv	a0,s1
    800043f4:	00001097          	auipc	ra,0x1
    800043f8:	e86080e7          	jalr	-378(ra) # 8000527a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800043fc:	08848493          	addi	s1,s1,136
    80004400:	ff3498e3          	bne	s1,s3,800043f0 <iinit+0x3e>
}
    80004404:	70a2                	ld	ra,40(sp)
    80004406:	7402                	ld	s0,32(sp)
    80004408:	64e2                	ld	s1,24(sp)
    8000440a:	6942                	ld	s2,16(sp)
    8000440c:	69a2                	ld	s3,8(sp)
    8000440e:	6145                	addi	sp,sp,48
    80004410:	8082                	ret

0000000080004412 <ialloc>:
{
    80004412:	7139                	addi	sp,sp,-64
    80004414:	fc06                	sd	ra,56(sp)
    80004416:	f822                	sd	s0,48(sp)
    80004418:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000441a:	0006a717          	auipc	a4,0x6a
    8000441e:	2ea72703          	lw	a4,746(a4) # 8006e704 <sb+0xc>
    80004422:	4785                	li	a5,1
    80004424:	06e7f463          	bgeu	a5,a4,8000448c <ialloc+0x7a>
    80004428:	f426                	sd	s1,40(sp)
    8000442a:	f04a                	sd	s2,32(sp)
    8000442c:	ec4e                	sd	s3,24(sp)
    8000442e:	e852                	sd	s4,16(sp)
    80004430:	e456                	sd	s5,8(sp)
    80004432:	e05a                	sd	s6,0(sp)
    80004434:	8aaa                	mv	s5,a0
    80004436:	8b2e                	mv	s6,a1
    80004438:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000443a:	0006aa17          	auipc	s4,0x6a
    8000443e:	2bea0a13          	addi	s4,s4,702 # 8006e6f8 <sb>
    80004442:	00495593          	srli	a1,s2,0x4
    80004446:	018a2783          	lw	a5,24(s4)
    8000444a:	9dbd                	addw	a1,a1,a5
    8000444c:	8556                	mv	a0,s5
    8000444e:	00000097          	auipc	ra,0x0
    80004452:	96a080e7          	jalr	-1686(ra) # 80003db8 <bread>
    80004456:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80004458:	05850993          	addi	s3,a0,88
    8000445c:	00f97793          	andi	a5,s2,15
    80004460:	079a                	slli	a5,a5,0x6
    80004462:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80004464:	00099783          	lh	a5,0(s3)
    80004468:	cf9d                	beqz	a5,800044a6 <ialloc+0x94>
    brelse(bp);
    8000446a:	00000097          	auipc	ra,0x0
    8000446e:	a7e080e7          	jalr	-1410(ra) # 80003ee8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004472:	0905                	addi	s2,s2,1
    80004474:	00ca2703          	lw	a4,12(s4)
    80004478:	0009079b          	sext.w	a5,s2
    8000447c:	fce7e3e3          	bltu	a5,a4,80004442 <ialloc+0x30>
    80004480:	74a2                	ld	s1,40(sp)
    80004482:	7902                	ld	s2,32(sp)
    80004484:	69e2                	ld	s3,24(sp)
    80004486:	6a42                	ld	s4,16(sp)
    80004488:	6aa2                	ld	s5,8(sp)
    8000448a:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000448c:	00007517          	auipc	a0,0x7
    80004490:	0b450513          	addi	a0,a0,180 # 8000b540 <etext+0x540>
    80004494:	ffffc097          	auipc	ra,0xffffc
    80004498:	114080e7          	jalr	276(ra) # 800005a8 <printf>
  return 0;
    8000449c:	4501                	li	a0,0
}
    8000449e:	70e2                	ld	ra,56(sp)
    800044a0:	7442                	ld	s0,48(sp)
    800044a2:	6121                	addi	sp,sp,64
    800044a4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800044a6:	04000613          	li	a2,64
    800044aa:	4581                	li	a1,0
    800044ac:	854e                	mv	a0,s3
    800044ae:	ffffd097          	auipc	ra,0xffffd
    800044b2:	97e080e7          	jalr	-1666(ra) # 80000e2c <memset>
      dip->type = type;
    800044b6:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800044ba:	8526                	mv	a0,s1
    800044bc:	00001097          	auipc	ra,0x1
    800044c0:	cd8080e7          	jalr	-808(ra) # 80005194 <log_write>
      brelse(bp);
    800044c4:	8526                	mv	a0,s1
    800044c6:	00000097          	auipc	ra,0x0
    800044ca:	a22080e7          	jalr	-1502(ra) # 80003ee8 <brelse>
      return iget(dev, inum);
    800044ce:	0009059b          	sext.w	a1,s2
    800044d2:	8556                	mv	a0,s5
    800044d4:	00000097          	auipc	ra,0x0
    800044d8:	da6080e7          	jalr	-602(ra) # 8000427a <iget>
    800044dc:	74a2                	ld	s1,40(sp)
    800044de:	7902                	ld	s2,32(sp)
    800044e0:	69e2                	ld	s3,24(sp)
    800044e2:	6a42                	ld	s4,16(sp)
    800044e4:	6aa2                	ld	s5,8(sp)
    800044e6:	6b02                	ld	s6,0(sp)
    800044e8:	bf5d                	j	8000449e <ialloc+0x8c>

00000000800044ea <iupdate>:
{
    800044ea:	1101                	addi	sp,sp,-32
    800044ec:	ec06                	sd	ra,24(sp)
    800044ee:	e822                	sd	s0,16(sp)
    800044f0:	e426                	sd	s1,8(sp)
    800044f2:	e04a                	sd	s2,0(sp)
    800044f4:	1000                	addi	s0,sp,32
    800044f6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800044f8:	415c                	lw	a5,4(a0)
    800044fa:	0047d79b          	srliw	a5,a5,0x4
    800044fe:	0006a597          	auipc	a1,0x6a
    80004502:	2125a583          	lw	a1,530(a1) # 8006e710 <sb+0x18>
    80004506:	9dbd                	addw	a1,a1,a5
    80004508:	4108                	lw	a0,0(a0)
    8000450a:	00000097          	auipc	ra,0x0
    8000450e:	8ae080e7          	jalr	-1874(ra) # 80003db8 <bread>
    80004512:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004514:	05850793          	addi	a5,a0,88
    80004518:	40d8                	lw	a4,4(s1)
    8000451a:	8b3d                	andi	a4,a4,15
    8000451c:	071a                	slli	a4,a4,0x6
    8000451e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80004520:	04449703          	lh	a4,68(s1)
    80004524:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004528:	04649703          	lh	a4,70(s1)
    8000452c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004530:	04849703          	lh	a4,72(s1)
    80004534:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004538:	04a49703          	lh	a4,74(s1)
    8000453c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004540:	44f8                	lw	a4,76(s1)
    80004542:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004544:	03400613          	li	a2,52
    80004548:	05048593          	addi	a1,s1,80
    8000454c:	00c78513          	addi	a0,a5,12
    80004550:	ffffd097          	auipc	ra,0xffffd
    80004554:	93c080e7          	jalr	-1732(ra) # 80000e8c <memmove>
  log_write(bp);
    80004558:	854a                	mv	a0,s2
    8000455a:	00001097          	auipc	ra,0x1
    8000455e:	c3a080e7          	jalr	-966(ra) # 80005194 <log_write>
  brelse(bp);
    80004562:	854a                	mv	a0,s2
    80004564:	00000097          	auipc	ra,0x0
    80004568:	984080e7          	jalr	-1660(ra) # 80003ee8 <brelse>
}
    8000456c:	60e2                	ld	ra,24(sp)
    8000456e:	6442                	ld	s0,16(sp)
    80004570:	64a2                	ld	s1,8(sp)
    80004572:	6902                	ld	s2,0(sp)
    80004574:	6105                	addi	sp,sp,32
    80004576:	8082                	ret

0000000080004578 <idup>:
{
    80004578:	1101                	addi	sp,sp,-32
    8000457a:	ec06                	sd	ra,24(sp)
    8000457c:	e822                	sd	s0,16(sp)
    8000457e:	e426                	sd	s1,8(sp)
    80004580:	1000                	addi	s0,sp,32
    80004582:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004584:	0006a517          	auipc	a0,0x6a
    80004588:	19450513          	addi	a0,a0,404 # 8006e718 <itable>
    8000458c:	ffffc097          	auipc	ra,0xffffc
    80004590:	7a8080e7          	jalr	1960(ra) # 80000d34 <acquire>
  ip->ref++;
    80004594:	449c                	lw	a5,8(s1)
    80004596:	2785                	addiw	a5,a5,1
    80004598:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000459a:	0006a517          	auipc	a0,0x6a
    8000459e:	17e50513          	addi	a0,a0,382 # 8006e718 <itable>
    800045a2:	ffffd097          	auipc	ra,0xffffd
    800045a6:	842080e7          	jalr	-1982(ra) # 80000de4 <release>
}
    800045aa:	8526                	mv	a0,s1
    800045ac:	60e2                	ld	ra,24(sp)
    800045ae:	6442                	ld	s0,16(sp)
    800045b0:	64a2                	ld	s1,8(sp)
    800045b2:	6105                	addi	sp,sp,32
    800045b4:	8082                	ret

00000000800045b6 <ilock>:
{
    800045b6:	1101                	addi	sp,sp,-32
    800045b8:	ec06                	sd	ra,24(sp)
    800045ba:	e822                	sd	s0,16(sp)
    800045bc:	e426                	sd	s1,8(sp)
    800045be:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800045c0:	c10d                	beqz	a0,800045e2 <ilock+0x2c>
    800045c2:	84aa                	mv	s1,a0
    800045c4:	451c                	lw	a5,8(a0)
    800045c6:	00f05e63          	blez	a5,800045e2 <ilock+0x2c>
  acquiresleep(&ip->lock);
    800045ca:	0541                	addi	a0,a0,16
    800045cc:	00001097          	auipc	ra,0x1
    800045d0:	ce8080e7          	jalr	-792(ra) # 800052b4 <acquiresleep>
  if(ip->valid == 0){
    800045d4:	40bc                	lw	a5,64(s1)
    800045d6:	cf99                	beqz	a5,800045f4 <ilock+0x3e>
}
    800045d8:	60e2                	ld	ra,24(sp)
    800045da:	6442                	ld	s0,16(sp)
    800045dc:	64a2                	ld	s1,8(sp)
    800045de:	6105                	addi	sp,sp,32
    800045e0:	8082                	ret
    800045e2:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800045e4:	00007517          	auipc	a0,0x7
    800045e8:	f7450513          	addi	a0,a0,-140 # 8000b558 <etext+0x558>
    800045ec:	ffffc097          	auipc	ra,0xffffc
    800045f0:	f72080e7          	jalr	-142(ra) # 8000055e <panic>
    800045f4:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800045f6:	40dc                	lw	a5,4(s1)
    800045f8:	0047d79b          	srliw	a5,a5,0x4
    800045fc:	0006a597          	auipc	a1,0x6a
    80004600:	1145a583          	lw	a1,276(a1) # 8006e710 <sb+0x18>
    80004604:	9dbd                	addw	a1,a1,a5
    80004606:	4088                	lw	a0,0(s1)
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	7b0080e7          	jalr	1968(ra) # 80003db8 <bread>
    80004610:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004612:	05850593          	addi	a1,a0,88
    80004616:	40dc                	lw	a5,4(s1)
    80004618:	8bbd                	andi	a5,a5,15
    8000461a:	079a                	slli	a5,a5,0x6
    8000461c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000461e:	00059783          	lh	a5,0(a1)
    80004622:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80004626:	00259783          	lh	a5,2(a1)
    8000462a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000462e:	00459783          	lh	a5,4(a1)
    80004632:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004636:	00659783          	lh	a5,6(a1)
    8000463a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000463e:	459c                	lw	a5,8(a1)
    80004640:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004642:	03400613          	li	a2,52
    80004646:	05b1                	addi	a1,a1,12
    80004648:	05048513          	addi	a0,s1,80
    8000464c:	ffffd097          	auipc	ra,0xffffd
    80004650:	840080e7          	jalr	-1984(ra) # 80000e8c <memmove>
    brelse(bp);
    80004654:	854a                	mv	a0,s2
    80004656:	00000097          	auipc	ra,0x0
    8000465a:	892080e7          	jalr	-1902(ra) # 80003ee8 <brelse>
    ip->valid = 1;
    8000465e:	4785                	li	a5,1
    80004660:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80004662:	04449783          	lh	a5,68(s1)
    80004666:	c399                	beqz	a5,8000466c <ilock+0xb6>
    80004668:	6902                	ld	s2,0(sp)
    8000466a:	b7bd                	j	800045d8 <ilock+0x22>
      panic("ilock: no type");
    8000466c:	00007517          	auipc	a0,0x7
    80004670:	ef450513          	addi	a0,a0,-268 # 8000b560 <etext+0x560>
    80004674:	ffffc097          	auipc	ra,0xffffc
    80004678:	eea080e7          	jalr	-278(ra) # 8000055e <panic>

000000008000467c <iunlock>:
{
    8000467c:	1101                	addi	sp,sp,-32
    8000467e:	ec06                	sd	ra,24(sp)
    80004680:	e822                	sd	s0,16(sp)
    80004682:	e426                	sd	s1,8(sp)
    80004684:	e04a                	sd	s2,0(sp)
    80004686:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004688:	c905                	beqz	a0,800046b8 <iunlock+0x3c>
    8000468a:	84aa                	mv	s1,a0
    8000468c:	01050913          	addi	s2,a0,16
    80004690:	854a                	mv	a0,s2
    80004692:	00001097          	auipc	ra,0x1
    80004696:	cbc080e7          	jalr	-836(ra) # 8000534e <holdingsleep>
    8000469a:	cd19                	beqz	a0,800046b8 <iunlock+0x3c>
    8000469c:	449c                	lw	a5,8(s1)
    8000469e:	00f05d63          	blez	a5,800046b8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800046a2:	854a                	mv	a0,s2
    800046a4:	00001097          	auipc	ra,0x1
    800046a8:	c66080e7          	jalr	-922(ra) # 8000530a <releasesleep>
}
    800046ac:	60e2                	ld	ra,24(sp)
    800046ae:	6442                	ld	s0,16(sp)
    800046b0:	64a2                	ld	s1,8(sp)
    800046b2:	6902                	ld	s2,0(sp)
    800046b4:	6105                	addi	sp,sp,32
    800046b6:	8082                	ret
    panic("iunlock");
    800046b8:	00007517          	auipc	a0,0x7
    800046bc:	eb850513          	addi	a0,a0,-328 # 8000b570 <etext+0x570>
    800046c0:	ffffc097          	auipc	ra,0xffffc
    800046c4:	e9e080e7          	jalr	-354(ra) # 8000055e <panic>

00000000800046c8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800046c8:	7179                	addi	sp,sp,-48
    800046ca:	f406                	sd	ra,40(sp)
    800046cc:	f022                	sd	s0,32(sp)
    800046ce:	ec26                	sd	s1,24(sp)
    800046d0:	e84a                	sd	s2,16(sp)
    800046d2:	e44e                	sd	s3,8(sp)
    800046d4:	1800                	addi	s0,sp,48
    800046d6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800046d8:	05050493          	addi	s1,a0,80
    800046dc:	08050913          	addi	s2,a0,128
    800046e0:	a021                	j	800046e8 <itrunc+0x20>
    800046e2:	0491                	addi	s1,s1,4
    800046e4:	01248d63          	beq	s1,s2,800046fe <itrunc+0x36>
    if(ip->addrs[i]){
    800046e8:	408c                	lw	a1,0(s1)
    800046ea:	dde5                	beqz	a1,800046e2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800046ec:	0009a503          	lw	a0,0(s3)
    800046f0:	00000097          	auipc	ra,0x0
    800046f4:	908080e7          	jalr	-1784(ra) # 80003ff8 <bfree>
      ip->addrs[i] = 0;
    800046f8:	0004a023          	sw	zero,0(s1)
    800046fc:	b7dd                	j	800046e2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800046fe:	0809a583          	lw	a1,128(s3)
    80004702:	ed99                	bnez	a1,80004720 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004704:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004708:	854e                	mv	a0,s3
    8000470a:	00000097          	auipc	ra,0x0
    8000470e:	de0080e7          	jalr	-544(ra) # 800044ea <iupdate>
}
    80004712:	70a2                	ld	ra,40(sp)
    80004714:	7402                	ld	s0,32(sp)
    80004716:	64e2                	ld	s1,24(sp)
    80004718:	6942                	ld	s2,16(sp)
    8000471a:	69a2                	ld	s3,8(sp)
    8000471c:	6145                	addi	sp,sp,48
    8000471e:	8082                	ret
    80004720:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004722:	0009a503          	lw	a0,0(s3)
    80004726:	fffff097          	auipc	ra,0xfffff
    8000472a:	692080e7          	jalr	1682(ra) # 80003db8 <bread>
    8000472e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004730:	05850493          	addi	s1,a0,88
    80004734:	45850913          	addi	s2,a0,1112
    80004738:	a021                	j	80004740 <itrunc+0x78>
    8000473a:	0491                	addi	s1,s1,4
    8000473c:	01248b63          	beq	s1,s2,80004752 <itrunc+0x8a>
      if(a[j])
    80004740:	408c                	lw	a1,0(s1)
    80004742:	dde5                	beqz	a1,8000473a <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80004744:	0009a503          	lw	a0,0(s3)
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	8b0080e7          	jalr	-1872(ra) # 80003ff8 <bfree>
    80004750:	b7ed                	j	8000473a <itrunc+0x72>
    brelse(bp);
    80004752:	8552                	mv	a0,s4
    80004754:	fffff097          	auipc	ra,0xfffff
    80004758:	794080e7          	jalr	1940(ra) # 80003ee8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000475c:	0809a583          	lw	a1,128(s3)
    80004760:	0009a503          	lw	a0,0(s3)
    80004764:	00000097          	auipc	ra,0x0
    80004768:	894080e7          	jalr	-1900(ra) # 80003ff8 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000476c:	0809a023          	sw	zero,128(s3)
    80004770:	6a02                	ld	s4,0(sp)
    80004772:	bf49                	j	80004704 <itrunc+0x3c>

0000000080004774 <iput>:
{
    80004774:	1101                	addi	sp,sp,-32
    80004776:	ec06                	sd	ra,24(sp)
    80004778:	e822                	sd	s0,16(sp)
    8000477a:	e426                	sd	s1,8(sp)
    8000477c:	1000                	addi	s0,sp,32
    8000477e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004780:	0006a517          	auipc	a0,0x6a
    80004784:	f9850513          	addi	a0,a0,-104 # 8006e718 <itable>
    80004788:	ffffc097          	auipc	ra,0xffffc
    8000478c:	5ac080e7          	jalr	1452(ra) # 80000d34 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004790:	4498                	lw	a4,8(s1)
    80004792:	4785                	li	a5,1
    80004794:	02f70263          	beq	a4,a5,800047b8 <iput+0x44>
  ip->ref--;
    80004798:	449c                	lw	a5,8(s1)
    8000479a:	37fd                	addiw	a5,a5,-1
    8000479c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000479e:	0006a517          	auipc	a0,0x6a
    800047a2:	f7a50513          	addi	a0,a0,-134 # 8006e718 <itable>
    800047a6:	ffffc097          	auipc	ra,0xffffc
    800047aa:	63e080e7          	jalr	1598(ra) # 80000de4 <release>
}
    800047ae:	60e2                	ld	ra,24(sp)
    800047b0:	6442                	ld	s0,16(sp)
    800047b2:	64a2                	ld	s1,8(sp)
    800047b4:	6105                	addi	sp,sp,32
    800047b6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800047b8:	40bc                	lw	a5,64(s1)
    800047ba:	dff9                	beqz	a5,80004798 <iput+0x24>
    800047bc:	04a49783          	lh	a5,74(s1)
    800047c0:	ffe1                	bnez	a5,80004798 <iput+0x24>
    800047c2:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800047c4:	01048793          	addi	a5,s1,16
    800047c8:	893e                	mv	s2,a5
    800047ca:	853e                	mv	a0,a5
    800047cc:	00001097          	auipc	ra,0x1
    800047d0:	ae8080e7          	jalr	-1304(ra) # 800052b4 <acquiresleep>
    release(&itable.lock);
    800047d4:	0006a517          	auipc	a0,0x6a
    800047d8:	f4450513          	addi	a0,a0,-188 # 8006e718 <itable>
    800047dc:	ffffc097          	auipc	ra,0xffffc
    800047e0:	608080e7          	jalr	1544(ra) # 80000de4 <release>
    itrunc(ip);
    800047e4:	8526                	mv	a0,s1
    800047e6:	00000097          	auipc	ra,0x0
    800047ea:	ee2080e7          	jalr	-286(ra) # 800046c8 <itrunc>
    ip->type = 0;
    800047ee:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800047f2:	8526                	mv	a0,s1
    800047f4:	00000097          	auipc	ra,0x0
    800047f8:	cf6080e7          	jalr	-778(ra) # 800044ea <iupdate>
    ip->valid = 0;
    800047fc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004800:	854a                	mv	a0,s2
    80004802:	00001097          	auipc	ra,0x1
    80004806:	b08080e7          	jalr	-1272(ra) # 8000530a <releasesleep>
    acquire(&itable.lock);
    8000480a:	0006a517          	auipc	a0,0x6a
    8000480e:	f0e50513          	addi	a0,a0,-242 # 8006e718 <itable>
    80004812:	ffffc097          	auipc	ra,0xffffc
    80004816:	522080e7          	jalr	1314(ra) # 80000d34 <acquire>
    8000481a:	6902                	ld	s2,0(sp)
    8000481c:	bfb5                	j	80004798 <iput+0x24>

000000008000481e <iunlockput>:
{
    8000481e:	1101                	addi	sp,sp,-32
    80004820:	ec06                	sd	ra,24(sp)
    80004822:	e822                	sd	s0,16(sp)
    80004824:	e426                	sd	s1,8(sp)
    80004826:	1000                	addi	s0,sp,32
    80004828:	84aa                	mv	s1,a0
  iunlock(ip);
    8000482a:	00000097          	auipc	ra,0x0
    8000482e:	e52080e7          	jalr	-430(ra) # 8000467c <iunlock>
  iput(ip);
    80004832:	8526                	mv	a0,s1
    80004834:	00000097          	auipc	ra,0x0
    80004838:	f40080e7          	jalr	-192(ra) # 80004774 <iput>
}
    8000483c:	60e2                	ld	ra,24(sp)
    8000483e:	6442                	ld	s0,16(sp)
    80004840:	64a2                	ld	s1,8(sp)
    80004842:	6105                	addi	sp,sp,32
    80004844:	8082                	ret

0000000080004846 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004846:	1141                	addi	sp,sp,-16
    80004848:	e406                	sd	ra,8(sp)
    8000484a:	e022                	sd	s0,0(sp)
    8000484c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000484e:	411c                	lw	a5,0(a0)
    80004850:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004852:	415c                	lw	a5,4(a0)
    80004854:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004856:	04451783          	lh	a5,68(a0)
    8000485a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000485e:	04a51783          	lh	a5,74(a0)
    80004862:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004866:	04c56783          	lwu	a5,76(a0)
    8000486a:	e99c                	sd	a5,16(a1)
}
    8000486c:	60a2                	ld	ra,8(sp)
    8000486e:	6402                	ld	s0,0(sp)
    80004870:	0141                	addi	sp,sp,16
    80004872:	8082                	ret

0000000080004874 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004874:	457c                	lw	a5,76(a0)
    80004876:	10d7e063          	bltu	a5,a3,80004976 <readi+0x102>
{
    8000487a:	7159                	addi	sp,sp,-112
    8000487c:	f486                	sd	ra,104(sp)
    8000487e:	f0a2                	sd	s0,96(sp)
    80004880:	eca6                	sd	s1,88(sp)
    80004882:	e0d2                	sd	s4,64(sp)
    80004884:	fc56                	sd	s5,56(sp)
    80004886:	f85a                	sd	s6,48(sp)
    80004888:	f45e                	sd	s7,40(sp)
    8000488a:	1880                	addi	s0,sp,112
    8000488c:	8b2a                	mv	s6,a0
    8000488e:	8bae                	mv	s7,a1
    80004890:	8a32                	mv	s4,a2
    80004892:	84b6                	mv	s1,a3
    80004894:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004896:	9f35                	addw	a4,a4,a3
    return 0;
    80004898:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000489a:	0cd76563          	bltu	a4,a3,80004964 <readi+0xf0>
    8000489e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800048a0:	00e7f463          	bgeu	a5,a4,800048a8 <readi+0x34>
    n = ip->size - off;
    800048a4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800048a8:	0a0a8563          	beqz	s5,80004952 <readi+0xde>
    800048ac:	e8ca                	sd	s2,80(sp)
    800048ae:	f062                	sd	s8,32(sp)
    800048b0:	ec66                	sd	s9,24(sp)
    800048b2:	e86a                	sd	s10,16(sp)
    800048b4:	e46e                	sd	s11,8(sp)
    800048b6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800048b8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800048bc:	5c7d                	li	s8,-1
    800048be:	a82d                	j	800048f8 <readi+0x84>
    800048c0:	020d1d93          	slli	s11,s10,0x20
    800048c4:	020ddd93          	srli	s11,s11,0x20
    800048c8:	05890613          	addi	a2,s2,88
    800048cc:	86ee                	mv	a3,s11
    800048ce:	963e                	add	a2,a2,a5
    800048d0:	85d2                	mv	a1,s4
    800048d2:	855e                	mv	a0,s7
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	52a080e7          	jalr	1322(ra) # 80002dfe <either_copyout>
    800048dc:	05850963          	beq	a0,s8,8000492e <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800048e0:	854a                	mv	a0,s2
    800048e2:	fffff097          	auipc	ra,0xfffff
    800048e6:	606080e7          	jalr	1542(ra) # 80003ee8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800048ea:	013d09bb          	addw	s3,s10,s3
    800048ee:	009d04bb          	addw	s1,s10,s1
    800048f2:	9a6e                	add	s4,s4,s11
    800048f4:	0559f963          	bgeu	s3,s5,80004946 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    800048f8:	00a4d59b          	srliw	a1,s1,0xa
    800048fc:	855a                	mv	a0,s6
    800048fe:	00000097          	auipc	ra,0x0
    80004902:	8a0080e7          	jalr	-1888(ra) # 8000419e <bmap>
    80004906:	85aa                	mv	a1,a0
    if(addr == 0)
    80004908:	c539                	beqz	a0,80004956 <readi+0xe2>
    bp = bread(ip->dev, addr);
    8000490a:	000b2503          	lw	a0,0(s6)
    8000490e:	fffff097          	auipc	ra,0xfffff
    80004912:	4aa080e7          	jalr	1194(ra) # 80003db8 <bread>
    80004916:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004918:	3ff4f793          	andi	a5,s1,1023
    8000491c:	40fc873b          	subw	a4,s9,a5
    80004920:	413a86bb          	subw	a3,s5,s3
    80004924:	8d3a                	mv	s10,a4
    80004926:	f8e6fde3          	bgeu	a3,a4,800048c0 <readi+0x4c>
    8000492a:	8d36                	mv	s10,a3
    8000492c:	bf51                	j	800048c0 <readi+0x4c>
      brelse(bp);
    8000492e:	854a                	mv	a0,s2
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	5b8080e7          	jalr	1464(ra) # 80003ee8 <brelse>
      tot = -1;
    80004938:	59fd                	li	s3,-1
      break;
    8000493a:	6946                	ld	s2,80(sp)
    8000493c:	7c02                	ld	s8,32(sp)
    8000493e:	6ce2                	ld	s9,24(sp)
    80004940:	6d42                	ld	s10,16(sp)
    80004942:	6da2                	ld	s11,8(sp)
    80004944:	a831                	j	80004960 <readi+0xec>
    80004946:	6946                	ld	s2,80(sp)
    80004948:	7c02                	ld	s8,32(sp)
    8000494a:	6ce2                	ld	s9,24(sp)
    8000494c:	6d42                	ld	s10,16(sp)
    8000494e:	6da2                	ld	s11,8(sp)
    80004950:	a801                	j	80004960 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004952:	89d6                	mv	s3,s5
    80004954:	a031                	j	80004960 <readi+0xec>
    80004956:	6946                	ld	s2,80(sp)
    80004958:	7c02                	ld	s8,32(sp)
    8000495a:	6ce2                	ld	s9,24(sp)
    8000495c:	6d42                	ld	s10,16(sp)
    8000495e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004960:	854e                	mv	a0,s3
    80004962:	69a6                	ld	s3,72(sp)
}
    80004964:	70a6                	ld	ra,104(sp)
    80004966:	7406                	ld	s0,96(sp)
    80004968:	64e6                	ld	s1,88(sp)
    8000496a:	6a06                	ld	s4,64(sp)
    8000496c:	7ae2                	ld	s5,56(sp)
    8000496e:	7b42                	ld	s6,48(sp)
    80004970:	7ba2                	ld	s7,40(sp)
    80004972:	6165                	addi	sp,sp,112
    80004974:	8082                	ret
    return 0;
    80004976:	4501                	li	a0,0
}
    80004978:	8082                	ret

000000008000497a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000497a:	457c                	lw	a5,76(a0)
    8000497c:	10d7e963          	bltu	a5,a3,80004a8e <writei+0x114>
{
    80004980:	7159                	addi	sp,sp,-112
    80004982:	f486                	sd	ra,104(sp)
    80004984:	f0a2                	sd	s0,96(sp)
    80004986:	e8ca                	sd	s2,80(sp)
    80004988:	e0d2                	sd	s4,64(sp)
    8000498a:	fc56                	sd	s5,56(sp)
    8000498c:	f85a                	sd	s6,48(sp)
    8000498e:	f45e                	sd	s7,40(sp)
    80004990:	1880                	addi	s0,sp,112
    80004992:	8aaa                	mv	s5,a0
    80004994:	8bae                	mv	s7,a1
    80004996:	8a32                	mv	s4,a2
    80004998:	8936                	mv	s2,a3
    8000499a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000499c:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800049a0:	00043737          	lui	a4,0x43
    800049a4:	0ef76763          	bltu	a4,a5,80004a92 <writei+0x118>
    800049a8:	0ed7e563          	bltu	a5,a3,80004a92 <writei+0x118>
    800049ac:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800049ae:	0c0b0863          	beqz	s6,80004a7e <writei+0x104>
    800049b2:	eca6                	sd	s1,88(sp)
    800049b4:	f062                	sd	s8,32(sp)
    800049b6:	ec66                	sd	s9,24(sp)
    800049b8:	e86a                	sd	s10,16(sp)
    800049ba:	e46e                	sd	s11,8(sp)
    800049bc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800049be:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800049c2:	5c7d                	li	s8,-1
    800049c4:	a091                	j	80004a08 <writei+0x8e>
    800049c6:	020d1d93          	slli	s11,s10,0x20
    800049ca:	020ddd93          	srli	s11,s11,0x20
    800049ce:	05848513          	addi	a0,s1,88
    800049d2:	86ee                	mv	a3,s11
    800049d4:	8652                	mv	a2,s4
    800049d6:	85de                	mv	a1,s7
    800049d8:	953e                	add	a0,a0,a5
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	47a080e7          	jalr	1146(ra) # 80002e54 <either_copyin>
    800049e2:	05850e63          	beq	a0,s8,80004a3e <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    800049e6:	8526                	mv	a0,s1
    800049e8:	00000097          	auipc	ra,0x0
    800049ec:	7ac080e7          	jalr	1964(ra) # 80005194 <log_write>
    brelse(bp);
    800049f0:	8526                	mv	a0,s1
    800049f2:	fffff097          	auipc	ra,0xfffff
    800049f6:	4f6080e7          	jalr	1270(ra) # 80003ee8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800049fa:	013d09bb          	addw	s3,s10,s3
    800049fe:	012d093b          	addw	s2,s10,s2
    80004a02:	9a6e                	add	s4,s4,s11
    80004a04:	0569f263          	bgeu	s3,s6,80004a48 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80004a08:	00a9559b          	srliw	a1,s2,0xa
    80004a0c:	8556                	mv	a0,s5
    80004a0e:	fffff097          	auipc	ra,0xfffff
    80004a12:	790080e7          	jalr	1936(ra) # 8000419e <bmap>
    80004a16:	85aa                	mv	a1,a0
    if(addr == 0)
    80004a18:	c905                	beqz	a0,80004a48 <writei+0xce>
    bp = bread(ip->dev, addr);
    80004a1a:	000aa503          	lw	a0,0(s5)
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	39a080e7          	jalr	922(ra) # 80003db8 <bread>
    80004a26:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004a28:	3ff97793          	andi	a5,s2,1023
    80004a2c:	40fc873b          	subw	a4,s9,a5
    80004a30:	413b06bb          	subw	a3,s6,s3
    80004a34:	8d3a                	mv	s10,a4
    80004a36:	f8e6f8e3          	bgeu	a3,a4,800049c6 <writei+0x4c>
    80004a3a:	8d36                	mv	s10,a3
    80004a3c:	b769                	j	800049c6 <writei+0x4c>
      brelse(bp);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	fffff097          	auipc	ra,0xfffff
    80004a44:	4a8080e7          	jalr	1192(ra) # 80003ee8 <brelse>
  }

  if(off > ip->size)
    80004a48:	04caa783          	lw	a5,76(s5)
    80004a4c:	0327fb63          	bgeu	a5,s2,80004a82 <writei+0x108>
    ip->size = off;
    80004a50:	052aa623          	sw	s2,76(s5)
    80004a54:	64e6                	ld	s1,88(sp)
    80004a56:	7c02                	ld	s8,32(sp)
    80004a58:	6ce2                	ld	s9,24(sp)
    80004a5a:	6d42                	ld	s10,16(sp)
    80004a5c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004a5e:	8556                	mv	a0,s5
    80004a60:	00000097          	auipc	ra,0x0
    80004a64:	a8a080e7          	jalr	-1398(ra) # 800044ea <iupdate>

  return tot;
    80004a68:	854e                	mv	a0,s3
    80004a6a:	69a6                	ld	s3,72(sp)
}
    80004a6c:	70a6                	ld	ra,104(sp)
    80004a6e:	7406                	ld	s0,96(sp)
    80004a70:	6946                	ld	s2,80(sp)
    80004a72:	6a06                	ld	s4,64(sp)
    80004a74:	7ae2                	ld	s5,56(sp)
    80004a76:	7b42                	ld	s6,48(sp)
    80004a78:	7ba2                	ld	s7,40(sp)
    80004a7a:	6165                	addi	sp,sp,112
    80004a7c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004a7e:	89da                	mv	s3,s6
    80004a80:	bff9                	j	80004a5e <writei+0xe4>
    80004a82:	64e6                	ld	s1,88(sp)
    80004a84:	7c02                	ld	s8,32(sp)
    80004a86:	6ce2                	ld	s9,24(sp)
    80004a88:	6d42                	ld	s10,16(sp)
    80004a8a:	6da2                	ld	s11,8(sp)
    80004a8c:	bfc9                	j	80004a5e <writei+0xe4>
    return -1;
    80004a8e:	557d                	li	a0,-1
}
    80004a90:	8082                	ret
    return -1;
    80004a92:	557d                	li	a0,-1
    80004a94:	bfe1                	j	80004a6c <writei+0xf2>

0000000080004a96 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004a96:	1141                	addi	sp,sp,-16
    80004a98:	e406                	sd	ra,8(sp)
    80004a9a:	e022                	sd	s0,0(sp)
    80004a9c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004a9e:	4639                	li	a2,14
    80004aa0:	ffffc097          	auipc	ra,0xffffc
    80004aa4:	464080e7          	jalr	1124(ra) # 80000f04 <strncmp>
}
    80004aa8:	60a2                	ld	ra,8(sp)
    80004aaa:	6402                	ld	s0,0(sp)
    80004aac:	0141                	addi	sp,sp,16
    80004aae:	8082                	ret

0000000080004ab0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004ab0:	711d                	addi	sp,sp,-96
    80004ab2:	ec86                	sd	ra,88(sp)
    80004ab4:	e8a2                	sd	s0,80(sp)
    80004ab6:	e4a6                	sd	s1,72(sp)
    80004ab8:	e0ca                	sd	s2,64(sp)
    80004aba:	fc4e                	sd	s3,56(sp)
    80004abc:	f852                	sd	s4,48(sp)
    80004abe:	f456                	sd	s5,40(sp)
    80004ac0:	f05a                	sd	s6,32(sp)
    80004ac2:	ec5e                	sd	s7,24(sp)
    80004ac4:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004ac6:	04451703          	lh	a4,68(a0)
    80004aca:	4785                	li	a5,1
    80004acc:	00f71f63          	bne	a4,a5,80004aea <dirlookup+0x3a>
    80004ad0:	892a                	mv	s2,a0
    80004ad2:	8aae                	mv	s5,a1
    80004ad4:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004ad6:	457c                	lw	a5,76(a0)
    80004ad8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ada:	fa040a13          	addi	s4,s0,-96
    80004ade:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80004ae0:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004ae4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004ae6:	e79d                	bnez	a5,80004b14 <dirlookup+0x64>
    80004ae8:	a88d                	j	80004b5a <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80004aea:	00007517          	auipc	a0,0x7
    80004aee:	a8e50513          	addi	a0,a0,-1394 # 8000b578 <etext+0x578>
    80004af2:	ffffc097          	auipc	ra,0xffffc
    80004af6:	a6c080e7          	jalr	-1428(ra) # 8000055e <panic>
      panic("dirlookup read");
    80004afa:	00007517          	auipc	a0,0x7
    80004afe:	a9650513          	addi	a0,a0,-1386 # 8000b590 <etext+0x590>
    80004b02:	ffffc097          	auipc	ra,0xffffc
    80004b06:	a5c080e7          	jalr	-1444(ra) # 8000055e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004b0a:	24c1                	addiw	s1,s1,16
    80004b0c:	04c92783          	lw	a5,76(s2)
    80004b10:	04f4f463          	bgeu	s1,a5,80004b58 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b14:	874e                	mv	a4,s3
    80004b16:	86a6                	mv	a3,s1
    80004b18:	8652                	mv	a2,s4
    80004b1a:	4581                	li	a1,0
    80004b1c:	854a                	mv	a0,s2
    80004b1e:	00000097          	auipc	ra,0x0
    80004b22:	d56080e7          	jalr	-682(ra) # 80004874 <readi>
    80004b26:	fd351ae3          	bne	a0,s3,80004afa <dirlookup+0x4a>
    if(de.inum == 0)
    80004b2a:	fa045783          	lhu	a5,-96(s0)
    80004b2e:	dff1                	beqz	a5,80004b0a <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80004b30:	85da                	mv	a1,s6
    80004b32:	8556                	mv	a0,s5
    80004b34:	00000097          	auipc	ra,0x0
    80004b38:	f62080e7          	jalr	-158(ra) # 80004a96 <namecmp>
    80004b3c:	f579                	bnez	a0,80004b0a <dirlookup+0x5a>
      if(poff)
    80004b3e:	000b8463          	beqz	s7,80004b46 <dirlookup+0x96>
        *poff = off;
    80004b42:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80004b46:	fa045583          	lhu	a1,-96(s0)
    80004b4a:	00092503          	lw	a0,0(s2)
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	72c080e7          	jalr	1836(ra) # 8000427a <iget>
    80004b56:	a011                	j	80004b5a <dirlookup+0xaa>
  return 0;
    80004b58:	4501                	li	a0,0
}
    80004b5a:	60e6                	ld	ra,88(sp)
    80004b5c:	6446                	ld	s0,80(sp)
    80004b5e:	64a6                	ld	s1,72(sp)
    80004b60:	6906                	ld	s2,64(sp)
    80004b62:	79e2                	ld	s3,56(sp)
    80004b64:	7a42                	ld	s4,48(sp)
    80004b66:	7aa2                	ld	s5,40(sp)
    80004b68:	7b02                	ld	s6,32(sp)
    80004b6a:	6be2                	ld	s7,24(sp)
    80004b6c:	6125                	addi	sp,sp,96
    80004b6e:	8082                	ret

0000000080004b70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004b70:	711d                	addi	sp,sp,-96
    80004b72:	ec86                	sd	ra,88(sp)
    80004b74:	e8a2                	sd	s0,80(sp)
    80004b76:	e4a6                	sd	s1,72(sp)
    80004b78:	e0ca                	sd	s2,64(sp)
    80004b7a:	fc4e                	sd	s3,56(sp)
    80004b7c:	f852                	sd	s4,48(sp)
    80004b7e:	f456                	sd	s5,40(sp)
    80004b80:	f05a                	sd	s6,32(sp)
    80004b82:	ec5e                	sd	s7,24(sp)
    80004b84:	e862                	sd	s8,16(sp)
    80004b86:	e466                	sd	s9,8(sp)
    80004b88:	e06a                	sd	s10,0(sp)
    80004b8a:	1080                	addi	s0,sp,96
    80004b8c:	84aa                	mv	s1,a0
    80004b8e:	8b2e                	mv	s6,a1
    80004b90:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004b92:	00054703          	lbu	a4,0(a0)
    80004b96:	02f00793          	li	a5,47
    80004b9a:	02f70363          	beq	a4,a5,80004bc0 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004b9e:	ffffd097          	auipc	ra,0xffffd
    80004ba2:	2e0080e7          	jalr	736(ra) # 80001e7e <myproc>
    80004ba6:	15053503          	ld	a0,336(a0)
    80004baa:	00000097          	auipc	ra,0x0
    80004bae:	9ce080e7          	jalr	-1586(ra) # 80004578 <idup>
    80004bb2:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004bb4:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80004bb8:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004bba:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004bbc:	4b85                	li	s7,1
    80004bbe:	a87d                	j	80004c7c <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004bc0:	4585                	li	a1,1
    80004bc2:	852e                	mv	a0,a1
    80004bc4:	fffff097          	auipc	ra,0xfffff
    80004bc8:	6b6080e7          	jalr	1718(ra) # 8000427a <iget>
    80004bcc:	8a2a                	mv	s4,a0
    80004bce:	b7dd                	j	80004bb4 <namex+0x44>
      iunlockput(ip);
    80004bd0:	8552                	mv	a0,s4
    80004bd2:	00000097          	auipc	ra,0x0
    80004bd6:	c4c080e7          	jalr	-948(ra) # 8000481e <iunlockput>
      return 0;
    80004bda:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004bdc:	8552                	mv	a0,s4
    80004bde:	60e6                	ld	ra,88(sp)
    80004be0:	6446                	ld	s0,80(sp)
    80004be2:	64a6                	ld	s1,72(sp)
    80004be4:	6906                	ld	s2,64(sp)
    80004be6:	79e2                	ld	s3,56(sp)
    80004be8:	7a42                	ld	s4,48(sp)
    80004bea:	7aa2                	ld	s5,40(sp)
    80004bec:	7b02                	ld	s6,32(sp)
    80004bee:	6be2                	ld	s7,24(sp)
    80004bf0:	6c42                	ld	s8,16(sp)
    80004bf2:	6ca2                	ld	s9,8(sp)
    80004bf4:	6d02                	ld	s10,0(sp)
    80004bf6:	6125                	addi	sp,sp,96
    80004bf8:	8082                	ret
      iunlock(ip);
    80004bfa:	8552                	mv	a0,s4
    80004bfc:	00000097          	auipc	ra,0x0
    80004c00:	a80080e7          	jalr	-1408(ra) # 8000467c <iunlock>
      return ip;
    80004c04:	bfe1                	j	80004bdc <namex+0x6c>
      iunlockput(ip);
    80004c06:	8552                	mv	a0,s4
    80004c08:	00000097          	auipc	ra,0x0
    80004c0c:	c16080e7          	jalr	-1002(ra) # 8000481e <iunlockput>
      return 0;
    80004c10:	8a4a                	mv	s4,s2
    80004c12:	b7e9                	j	80004bdc <namex+0x6c>
  len = path - s;
    80004c14:	40990633          	sub	a2,s2,s1
    80004c18:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004c1c:	09ac5c63          	bge	s8,s10,80004cb4 <namex+0x144>
    memmove(name, s, DIRSIZ);
    80004c20:	8666                	mv	a2,s9
    80004c22:	85a6                	mv	a1,s1
    80004c24:	8556                	mv	a0,s5
    80004c26:	ffffc097          	auipc	ra,0xffffc
    80004c2a:	266080e7          	jalr	614(ra) # 80000e8c <memmove>
    80004c2e:	84ca                	mv	s1,s2
  while(*path == '/')
    80004c30:	0004c783          	lbu	a5,0(s1)
    80004c34:	01379763          	bne	a5,s3,80004c42 <namex+0xd2>
    path++;
    80004c38:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004c3a:	0004c783          	lbu	a5,0(s1)
    80004c3e:	ff378de3          	beq	a5,s3,80004c38 <namex+0xc8>
    ilock(ip);
    80004c42:	8552                	mv	a0,s4
    80004c44:	00000097          	auipc	ra,0x0
    80004c48:	972080e7          	jalr	-1678(ra) # 800045b6 <ilock>
    if(ip->type != T_DIR){
    80004c4c:	044a1783          	lh	a5,68(s4)
    80004c50:	f97790e3          	bne	a5,s7,80004bd0 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80004c54:	000b0563          	beqz	s6,80004c5e <namex+0xee>
    80004c58:	0004c783          	lbu	a5,0(s1)
    80004c5c:	dfd9                	beqz	a5,80004bfa <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004c5e:	4601                	li	a2,0
    80004c60:	85d6                	mv	a1,s5
    80004c62:	8552                	mv	a0,s4
    80004c64:	00000097          	auipc	ra,0x0
    80004c68:	e4c080e7          	jalr	-436(ra) # 80004ab0 <dirlookup>
    80004c6c:	892a                	mv	s2,a0
    80004c6e:	dd41                	beqz	a0,80004c06 <namex+0x96>
    iunlockput(ip);
    80004c70:	8552                	mv	a0,s4
    80004c72:	00000097          	auipc	ra,0x0
    80004c76:	bac080e7          	jalr	-1108(ra) # 8000481e <iunlockput>
    ip = next;
    80004c7a:	8a4a                	mv	s4,s2
  while(*path == '/')
    80004c7c:	0004c783          	lbu	a5,0(s1)
    80004c80:	01379763          	bne	a5,s3,80004c8e <namex+0x11e>
    path++;
    80004c84:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004c86:	0004c783          	lbu	a5,0(s1)
    80004c8a:	ff378de3          	beq	a5,s3,80004c84 <namex+0x114>
  if(*path == 0)
    80004c8e:	cf9d                	beqz	a5,80004ccc <namex+0x15c>
  while(*path != '/' && *path != 0)
    80004c90:	0004c783          	lbu	a5,0(s1)
    80004c94:	fd178713          	addi	a4,a5,-47
    80004c98:	cb19                	beqz	a4,80004cae <namex+0x13e>
    80004c9a:	cb91                	beqz	a5,80004cae <namex+0x13e>
    80004c9c:	8926                	mv	s2,s1
    path++;
    80004c9e:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80004ca0:	00094783          	lbu	a5,0(s2)
    80004ca4:	fd178713          	addi	a4,a5,-47
    80004ca8:	d735                	beqz	a4,80004c14 <namex+0xa4>
    80004caa:	fbf5                	bnez	a5,80004c9e <namex+0x12e>
    80004cac:	b7a5                	j	80004c14 <namex+0xa4>
    80004cae:	8926                	mv	s2,s1
  len = path - s;
    80004cb0:	4d01                	li	s10,0
    80004cb2:	4601                	li	a2,0
    memmove(name, s, len);
    80004cb4:	2601                	sext.w	a2,a2
    80004cb6:	85a6                	mv	a1,s1
    80004cb8:	8556                	mv	a0,s5
    80004cba:	ffffc097          	auipc	ra,0xffffc
    80004cbe:	1d2080e7          	jalr	466(ra) # 80000e8c <memmove>
    name[len] = 0;
    80004cc2:	9d56                	add	s10,s10,s5
    80004cc4:	000d0023          	sb	zero,0(s10)
    80004cc8:	84ca                	mv	s1,s2
    80004cca:	b79d                	j	80004c30 <namex+0xc0>
  if(nameiparent){
    80004ccc:	f00b08e3          	beqz	s6,80004bdc <namex+0x6c>
    iput(ip);
    80004cd0:	8552                	mv	a0,s4
    80004cd2:	00000097          	auipc	ra,0x0
    80004cd6:	aa2080e7          	jalr	-1374(ra) # 80004774 <iput>
    return 0;
    80004cda:	4a01                	li	s4,0
    80004cdc:	b701                	j	80004bdc <namex+0x6c>

0000000080004cde <dirlink>:
{
    80004cde:	715d                	addi	sp,sp,-80
    80004ce0:	e486                	sd	ra,72(sp)
    80004ce2:	e0a2                	sd	s0,64(sp)
    80004ce4:	f84a                	sd	s2,48(sp)
    80004ce6:	ec56                	sd	s5,24(sp)
    80004ce8:	e85a                	sd	s6,16(sp)
    80004cea:	0880                	addi	s0,sp,80
    80004cec:	892a                	mv	s2,a0
    80004cee:	8aae                	mv	s5,a1
    80004cf0:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004cf2:	4601                	li	a2,0
    80004cf4:	00000097          	auipc	ra,0x0
    80004cf8:	dbc080e7          	jalr	-580(ra) # 80004ab0 <dirlookup>
    80004cfc:	e129                	bnez	a0,80004d3e <dirlink+0x60>
    80004cfe:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004d00:	04c92483          	lw	s1,76(s2)
    80004d04:	cca9                	beqz	s1,80004d5e <dirlink+0x80>
    80004d06:	f44e                	sd	s3,40(sp)
    80004d08:	f052                	sd	s4,32(sp)
    80004d0a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d0c:	fb040a13          	addi	s4,s0,-80
    80004d10:	49c1                	li	s3,16
    80004d12:	874e                	mv	a4,s3
    80004d14:	86a6                	mv	a3,s1
    80004d16:	8652                	mv	a2,s4
    80004d18:	4581                	li	a1,0
    80004d1a:	854a                	mv	a0,s2
    80004d1c:	00000097          	auipc	ra,0x0
    80004d20:	b58080e7          	jalr	-1192(ra) # 80004874 <readi>
    80004d24:	03351363          	bne	a0,s3,80004d4a <dirlink+0x6c>
    if(de.inum == 0)
    80004d28:	fb045783          	lhu	a5,-80(s0)
    80004d2c:	c79d                	beqz	a5,80004d5a <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004d2e:	24c1                	addiw	s1,s1,16
    80004d30:	04c92783          	lw	a5,76(s2)
    80004d34:	fcf4efe3          	bltu	s1,a5,80004d12 <dirlink+0x34>
    80004d38:	79a2                	ld	s3,40(sp)
    80004d3a:	7a02                	ld	s4,32(sp)
    80004d3c:	a00d                	j	80004d5e <dirlink+0x80>
    iput(ip);
    80004d3e:	00000097          	auipc	ra,0x0
    80004d42:	a36080e7          	jalr	-1482(ra) # 80004774 <iput>
    return -1;
    80004d46:	557d                	li	a0,-1
    80004d48:	a0a9                	j	80004d92 <dirlink+0xb4>
      panic("dirlink read");
    80004d4a:	00007517          	auipc	a0,0x7
    80004d4e:	85650513          	addi	a0,a0,-1962 # 8000b5a0 <etext+0x5a0>
    80004d52:	ffffc097          	auipc	ra,0xffffc
    80004d56:	80c080e7          	jalr	-2036(ra) # 8000055e <panic>
    80004d5a:	79a2                	ld	s3,40(sp)
    80004d5c:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004d5e:	4639                	li	a2,14
    80004d60:	85d6                	mv	a1,s5
    80004d62:	fb240513          	addi	a0,s0,-78
    80004d66:	ffffc097          	auipc	ra,0xffffc
    80004d6a:	1d8080e7          	jalr	472(ra) # 80000f3e <strncpy>
  de.inum = inum;
    80004d6e:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d72:	4741                	li	a4,16
    80004d74:	86a6                	mv	a3,s1
    80004d76:	fb040613          	addi	a2,s0,-80
    80004d7a:	4581                	li	a1,0
    80004d7c:	854a                	mv	a0,s2
    80004d7e:	00000097          	auipc	ra,0x0
    80004d82:	bfc080e7          	jalr	-1028(ra) # 8000497a <writei>
    80004d86:	1541                	addi	a0,a0,-16
    80004d88:	00a03533          	snez	a0,a0
    80004d8c:	40a0053b          	negw	a0,a0
    80004d90:	74e2                	ld	s1,56(sp)
}
    80004d92:	60a6                	ld	ra,72(sp)
    80004d94:	6406                	ld	s0,64(sp)
    80004d96:	7942                	ld	s2,48(sp)
    80004d98:	6ae2                	ld	s5,24(sp)
    80004d9a:	6b42                	ld	s6,16(sp)
    80004d9c:	6161                	addi	sp,sp,80
    80004d9e:	8082                	ret

0000000080004da0 <namei>:

struct inode*
namei(char *path)
{
    80004da0:	1101                	addi	sp,sp,-32
    80004da2:	ec06                	sd	ra,24(sp)
    80004da4:	e822                	sd	s0,16(sp)
    80004da6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004da8:	fe040613          	addi	a2,s0,-32
    80004dac:	4581                	li	a1,0
    80004dae:	00000097          	auipc	ra,0x0
    80004db2:	dc2080e7          	jalr	-574(ra) # 80004b70 <namex>
}
    80004db6:	60e2                	ld	ra,24(sp)
    80004db8:	6442                	ld	s0,16(sp)
    80004dba:	6105                	addi	sp,sp,32
    80004dbc:	8082                	ret

0000000080004dbe <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004dbe:	1141                	addi	sp,sp,-16
    80004dc0:	e406                	sd	ra,8(sp)
    80004dc2:	e022                	sd	s0,0(sp)
    80004dc4:	0800                	addi	s0,sp,16
    80004dc6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004dc8:	4585                	li	a1,1
    80004dca:	00000097          	auipc	ra,0x0
    80004dce:	da6080e7          	jalr	-602(ra) # 80004b70 <namex>
}
    80004dd2:	60a2                	ld	ra,8(sp)
    80004dd4:	6402                	ld	s0,0(sp)
    80004dd6:	0141                	addi	sp,sp,16
    80004dd8:	8082                	ret

0000000080004dda <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004dda:	1101                	addi	sp,sp,-32
    80004ddc:	ec06                	sd	ra,24(sp)
    80004dde:	e822                	sd	s0,16(sp)
    80004de0:	e426                	sd	s1,8(sp)
    80004de2:	e04a                	sd	s2,0(sp)
    80004de4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004de6:	0006b917          	auipc	s2,0x6b
    80004dea:	3da90913          	addi	s2,s2,986 # 800701c0 <log>
    80004dee:	01892583          	lw	a1,24(s2)
    80004df2:	02892503          	lw	a0,40(s2)
    80004df6:	fffff097          	auipc	ra,0xfffff
    80004dfa:	fc2080e7          	jalr	-62(ra) # 80003db8 <bread>
    80004dfe:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004e00:	02c92603          	lw	a2,44(s2)
    80004e04:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004e06:	00c05f63          	blez	a2,80004e24 <write_head+0x4a>
    80004e0a:	0006b717          	auipc	a4,0x6b
    80004e0e:	3e670713          	addi	a4,a4,998 # 800701f0 <log+0x30>
    80004e12:	87aa                	mv	a5,a0
    80004e14:	060a                	slli	a2,a2,0x2
    80004e16:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004e18:	4314                	lw	a3,0(a4)
    80004e1a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004e1c:	0711                	addi	a4,a4,4
    80004e1e:	0791                	addi	a5,a5,4
    80004e20:	fec79ce3          	bne	a5,a2,80004e18 <write_head+0x3e>
  }
  bwrite(buf);
    80004e24:	8526                	mv	a0,s1
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	084080e7          	jalr	132(ra) # 80003eaa <bwrite>
  brelse(buf);
    80004e2e:	8526                	mv	a0,s1
    80004e30:	fffff097          	auipc	ra,0xfffff
    80004e34:	0b8080e7          	jalr	184(ra) # 80003ee8 <brelse>
}
    80004e38:	60e2                	ld	ra,24(sp)
    80004e3a:	6442                	ld	s0,16(sp)
    80004e3c:	64a2                	ld	s1,8(sp)
    80004e3e:	6902                	ld	s2,0(sp)
    80004e40:	6105                	addi	sp,sp,32
    80004e42:	8082                	ret

0000000080004e44 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e44:	0006b797          	auipc	a5,0x6b
    80004e48:	3a87a783          	lw	a5,936(a5) # 800701ec <log+0x2c>
    80004e4c:	0cf05063          	blez	a5,80004f0c <install_trans+0xc8>
{
    80004e50:	715d                	addi	sp,sp,-80
    80004e52:	e486                	sd	ra,72(sp)
    80004e54:	e0a2                	sd	s0,64(sp)
    80004e56:	fc26                	sd	s1,56(sp)
    80004e58:	f84a                	sd	s2,48(sp)
    80004e5a:	f44e                	sd	s3,40(sp)
    80004e5c:	f052                	sd	s4,32(sp)
    80004e5e:	ec56                	sd	s5,24(sp)
    80004e60:	e85a                	sd	s6,16(sp)
    80004e62:	e45e                	sd	s7,8(sp)
    80004e64:	0880                	addi	s0,sp,80
    80004e66:	8b2a                	mv	s6,a0
    80004e68:	0006ba97          	auipc	s5,0x6b
    80004e6c:	388a8a93          	addi	s5,s5,904 # 800701f0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e70:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004e72:	0006b997          	auipc	s3,0x6b
    80004e76:	34e98993          	addi	s3,s3,846 # 800701c0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004e7a:	40000b93          	li	s7,1024
    80004e7e:	a00d                	j	80004ea0 <install_trans+0x5c>
    brelse(lbuf);
    80004e80:	854a                	mv	a0,s2
    80004e82:	fffff097          	auipc	ra,0xfffff
    80004e86:	066080e7          	jalr	102(ra) # 80003ee8 <brelse>
    brelse(dbuf);
    80004e8a:	8526                	mv	a0,s1
    80004e8c:	fffff097          	auipc	ra,0xfffff
    80004e90:	05c080e7          	jalr	92(ra) # 80003ee8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e94:	2a05                	addiw	s4,s4,1
    80004e96:	0a91                	addi	s5,s5,4
    80004e98:	02c9a783          	lw	a5,44(s3)
    80004e9c:	04fa5d63          	bge	s4,a5,80004ef6 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004ea0:	0189a583          	lw	a1,24(s3)
    80004ea4:	014585bb          	addw	a1,a1,s4
    80004ea8:	2585                	addiw	a1,a1,1
    80004eaa:	0289a503          	lw	a0,40(s3)
    80004eae:	fffff097          	auipc	ra,0xfffff
    80004eb2:	f0a080e7          	jalr	-246(ra) # 80003db8 <bread>
    80004eb6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004eb8:	000aa583          	lw	a1,0(s5)
    80004ebc:	0289a503          	lw	a0,40(s3)
    80004ec0:	fffff097          	auipc	ra,0xfffff
    80004ec4:	ef8080e7          	jalr	-264(ra) # 80003db8 <bread>
    80004ec8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004eca:	865e                	mv	a2,s7
    80004ecc:	05890593          	addi	a1,s2,88
    80004ed0:	05850513          	addi	a0,a0,88
    80004ed4:	ffffc097          	auipc	ra,0xffffc
    80004ed8:	fb8080e7          	jalr	-72(ra) # 80000e8c <memmove>
    bwrite(dbuf);  // write dst to disk
    80004edc:	8526                	mv	a0,s1
    80004ede:	fffff097          	auipc	ra,0xfffff
    80004ee2:	fcc080e7          	jalr	-52(ra) # 80003eaa <bwrite>
    if(recovering == 0)
    80004ee6:	f80b1de3          	bnez	s6,80004e80 <install_trans+0x3c>
      bunpin(dbuf);
    80004eea:	8526                	mv	a0,s1
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	0d0080e7          	jalr	208(ra) # 80003fbc <bunpin>
    80004ef4:	b771                	j	80004e80 <install_trans+0x3c>
}
    80004ef6:	60a6                	ld	ra,72(sp)
    80004ef8:	6406                	ld	s0,64(sp)
    80004efa:	74e2                	ld	s1,56(sp)
    80004efc:	7942                	ld	s2,48(sp)
    80004efe:	79a2                	ld	s3,40(sp)
    80004f00:	7a02                	ld	s4,32(sp)
    80004f02:	6ae2                	ld	s5,24(sp)
    80004f04:	6b42                	ld	s6,16(sp)
    80004f06:	6ba2                	ld	s7,8(sp)
    80004f08:	6161                	addi	sp,sp,80
    80004f0a:	8082                	ret
    80004f0c:	8082                	ret

0000000080004f0e <initlog>:
{
    80004f0e:	7179                	addi	sp,sp,-48
    80004f10:	f406                	sd	ra,40(sp)
    80004f12:	f022                	sd	s0,32(sp)
    80004f14:	ec26                	sd	s1,24(sp)
    80004f16:	e84a                	sd	s2,16(sp)
    80004f18:	e44e                	sd	s3,8(sp)
    80004f1a:	1800                	addi	s0,sp,48
    80004f1c:	892a                	mv	s2,a0
    80004f1e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004f20:	0006b497          	auipc	s1,0x6b
    80004f24:	2a048493          	addi	s1,s1,672 # 800701c0 <log>
    80004f28:	00006597          	auipc	a1,0x6
    80004f2c:	68858593          	addi	a1,a1,1672 # 8000b5b0 <etext+0x5b0>
    80004f30:	8526                	mv	a0,s1
    80004f32:	ffffc097          	auipc	ra,0xffffc
    80004f36:	d68080e7          	jalr	-664(ra) # 80000c9a <initlock>
  log.start = sb->logstart;
    80004f3a:	0149a583          	lw	a1,20(s3)
    80004f3e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004f40:	0109a783          	lw	a5,16(s3)
    80004f44:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004f46:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004f4a:	854a                	mv	a0,s2
    80004f4c:	fffff097          	auipc	ra,0xfffff
    80004f50:	e6c080e7          	jalr	-404(ra) # 80003db8 <bread>
  log.lh.n = lh->n;
    80004f54:	4d30                	lw	a2,88(a0)
    80004f56:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004f58:	00c05f63          	blez	a2,80004f76 <initlog+0x68>
    80004f5c:	87aa                	mv	a5,a0
    80004f5e:	0006b717          	auipc	a4,0x6b
    80004f62:	29270713          	addi	a4,a4,658 # 800701f0 <log+0x30>
    80004f66:	060a                	slli	a2,a2,0x2
    80004f68:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004f6a:	4ff4                	lw	a3,92(a5)
    80004f6c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004f6e:	0791                	addi	a5,a5,4
    80004f70:	0711                	addi	a4,a4,4
    80004f72:	fec79ce3          	bne	a5,a2,80004f6a <initlog+0x5c>
  brelse(buf);
    80004f76:	fffff097          	auipc	ra,0xfffff
    80004f7a:	f72080e7          	jalr	-142(ra) # 80003ee8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004f7e:	4505                	li	a0,1
    80004f80:	00000097          	auipc	ra,0x0
    80004f84:	ec4080e7          	jalr	-316(ra) # 80004e44 <install_trans>
  log.lh.n = 0;
    80004f88:	0006b797          	auipc	a5,0x6b
    80004f8c:	2607a223          	sw	zero,612(a5) # 800701ec <log+0x2c>
  write_head(); // clear the log
    80004f90:	00000097          	auipc	ra,0x0
    80004f94:	e4a080e7          	jalr	-438(ra) # 80004dda <write_head>
}
    80004f98:	70a2                	ld	ra,40(sp)
    80004f9a:	7402                	ld	s0,32(sp)
    80004f9c:	64e2                	ld	s1,24(sp)
    80004f9e:	6942                	ld	s2,16(sp)
    80004fa0:	69a2                	ld	s3,8(sp)
    80004fa2:	6145                	addi	sp,sp,48
    80004fa4:	8082                	ret

0000000080004fa6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004fa6:	1101                	addi	sp,sp,-32
    80004fa8:	ec06                	sd	ra,24(sp)
    80004faa:	e822                	sd	s0,16(sp)
    80004fac:	e426                	sd	s1,8(sp)
    80004fae:	e04a                	sd	s2,0(sp)
    80004fb0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004fb2:	0006b517          	auipc	a0,0x6b
    80004fb6:	20e50513          	addi	a0,a0,526 # 800701c0 <log>
    80004fba:	ffffc097          	auipc	ra,0xffffc
    80004fbe:	d7a080e7          	jalr	-646(ra) # 80000d34 <acquire>
  while(1){
    if(log.committing){
    80004fc2:	0006b497          	auipc	s1,0x6b
    80004fc6:	1fe48493          	addi	s1,s1,510 # 800701c0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004fca:	4979                	li	s2,30
    80004fcc:	a039                	j	80004fda <begin_op+0x34>
      sleep(&log, &log.lock);
    80004fce:	85a6                	mv	a1,s1
    80004fd0:	8526                	mv	a0,s1
    80004fd2:	ffffd097          	auipc	ra,0xffffd
    80004fd6:	762080e7          	jalr	1890(ra) # 80002734 <sleep>
    if(log.committing){
    80004fda:	50dc                	lw	a5,36(s1)
    80004fdc:	fbed                	bnez	a5,80004fce <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004fde:	5098                	lw	a4,32(s1)
    80004fe0:	2705                	addiw	a4,a4,1
    80004fe2:	0027179b          	slliw	a5,a4,0x2
    80004fe6:	9fb9                	addw	a5,a5,a4
    80004fe8:	0017979b          	slliw	a5,a5,0x1
    80004fec:	54d4                	lw	a3,44(s1)
    80004fee:	9fb5                	addw	a5,a5,a3
    80004ff0:	00f95963          	bge	s2,a5,80005002 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004ff4:	85a6                	mv	a1,s1
    80004ff6:	8526                	mv	a0,s1
    80004ff8:	ffffd097          	auipc	ra,0xffffd
    80004ffc:	73c080e7          	jalr	1852(ra) # 80002734 <sleep>
    80005000:	bfe9                	j	80004fda <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80005002:	0006b797          	auipc	a5,0x6b
    80005006:	1ce7af23          	sw	a4,478(a5) # 800701e0 <log+0x20>
      release(&log.lock);
    8000500a:	0006b517          	auipc	a0,0x6b
    8000500e:	1b650513          	addi	a0,a0,438 # 800701c0 <log>
    80005012:	ffffc097          	auipc	ra,0xffffc
    80005016:	dd2080e7          	jalr	-558(ra) # 80000de4 <release>
      break;
    }
  }
}
    8000501a:	60e2                	ld	ra,24(sp)
    8000501c:	6442                	ld	s0,16(sp)
    8000501e:	64a2                	ld	s1,8(sp)
    80005020:	6902                	ld	s2,0(sp)
    80005022:	6105                	addi	sp,sp,32
    80005024:	8082                	ret

0000000080005026 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80005026:	7139                	addi	sp,sp,-64
    80005028:	fc06                	sd	ra,56(sp)
    8000502a:	f822                	sd	s0,48(sp)
    8000502c:	f426                	sd	s1,40(sp)
    8000502e:	f04a                	sd	s2,32(sp)
    80005030:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80005032:	0006b497          	auipc	s1,0x6b
    80005036:	18e48493          	addi	s1,s1,398 # 800701c0 <log>
    8000503a:	8526                	mv	a0,s1
    8000503c:	ffffc097          	auipc	ra,0xffffc
    80005040:	cf8080e7          	jalr	-776(ra) # 80000d34 <acquire>
  log.outstanding -= 1;
    80005044:	509c                	lw	a5,32(s1)
    80005046:	37fd                	addiw	a5,a5,-1
    80005048:	893e                	mv	s2,a5
    8000504a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000504c:	50dc                	lw	a5,36(s1)
    8000504e:	efb1                	bnez	a5,800050aa <end_op+0x84>
    panic("log.committing");
  if(log.outstanding == 0){
    80005050:	06091863          	bnez	s2,800050c0 <end_op+0x9a>
    do_commit = 1;
    log.committing = 1;
    80005054:	0006b497          	auipc	s1,0x6b
    80005058:	16c48493          	addi	s1,s1,364 # 800701c0 <log>
    8000505c:	4785                	li	a5,1
    8000505e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80005060:	8526                	mv	a0,s1
    80005062:	ffffc097          	auipc	ra,0xffffc
    80005066:	d82080e7          	jalr	-638(ra) # 80000de4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000506a:	54dc                	lw	a5,44(s1)
    8000506c:	08f04063          	bgtz	a5,800050ec <end_op+0xc6>
    acquire(&log.lock);
    80005070:	0006b517          	auipc	a0,0x6b
    80005074:	15050513          	addi	a0,a0,336 # 800701c0 <log>
    80005078:	ffffc097          	auipc	ra,0xffffc
    8000507c:	cbc080e7          	jalr	-836(ra) # 80000d34 <acquire>
    log.committing = 0;
    80005080:	0006b797          	auipc	a5,0x6b
    80005084:	1607a223          	sw	zero,356(a5) # 800701e4 <log+0x24>
    wakeup(&log);
    80005088:	0006b517          	auipc	a0,0x6b
    8000508c:	13850513          	addi	a0,a0,312 # 800701c0 <log>
    80005090:	ffffd097          	auipc	ra,0xffffd
    80005094:	708080e7          	jalr	1800(ra) # 80002798 <wakeup>
    release(&log.lock);
    80005098:	0006b517          	auipc	a0,0x6b
    8000509c:	12850513          	addi	a0,a0,296 # 800701c0 <log>
    800050a0:	ffffc097          	auipc	ra,0xffffc
    800050a4:	d44080e7          	jalr	-700(ra) # 80000de4 <release>
}
    800050a8:	a825                	j	800050e0 <end_op+0xba>
    800050aa:	ec4e                	sd	s3,24(sp)
    800050ac:	e852                	sd	s4,16(sp)
    800050ae:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800050b0:	00006517          	auipc	a0,0x6
    800050b4:	50850513          	addi	a0,a0,1288 # 8000b5b8 <etext+0x5b8>
    800050b8:	ffffb097          	auipc	ra,0xffffb
    800050bc:	4a6080e7          	jalr	1190(ra) # 8000055e <panic>
    wakeup(&log);
    800050c0:	0006b517          	auipc	a0,0x6b
    800050c4:	10050513          	addi	a0,a0,256 # 800701c0 <log>
    800050c8:	ffffd097          	auipc	ra,0xffffd
    800050cc:	6d0080e7          	jalr	1744(ra) # 80002798 <wakeup>
  release(&log.lock);
    800050d0:	0006b517          	auipc	a0,0x6b
    800050d4:	0f050513          	addi	a0,a0,240 # 800701c0 <log>
    800050d8:	ffffc097          	auipc	ra,0xffffc
    800050dc:	d0c080e7          	jalr	-756(ra) # 80000de4 <release>
}
    800050e0:	70e2                	ld	ra,56(sp)
    800050e2:	7442                	ld	s0,48(sp)
    800050e4:	74a2                	ld	s1,40(sp)
    800050e6:	7902                	ld	s2,32(sp)
    800050e8:	6121                	addi	sp,sp,64
    800050ea:	8082                	ret
    800050ec:	ec4e                	sd	s3,24(sp)
    800050ee:	e852                	sd	s4,16(sp)
    800050f0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800050f2:	0006ba97          	auipc	s5,0x6b
    800050f6:	0fea8a93          	addi	s5,s5,254 # 800701f0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800050fa:	0006ba17          	auipc	s4,0x6b
    800050fe:	0c6a0a13          	addi	s4,s4,198 # 800701c0 <log>
    80005102:	018a2583          	lw	a1,24(s4)
    80005106:	012585bb          	addw	a1,a1,s2
    8000510a:	2585                	addiw	a1,a1,1
    8000510c:	028a2503          	lw	a0,40(s4)
    80005110:	fffff097          	auipc	ra,0xfffff
    80005114:	ca8080e7          	jalr	-856(ra) # 80003db8 <bread>
    80005118:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000511a:	000aa583          	lw	a1,0(s5)
    8000511e:	028a2503          	lw	a0,40(s4)
    80005122:	fffff097          	auipc	ra,0xfffff
    80005126:	c96080e7          	jalr	-874(ra) # 80003db8 <bread>
    8000512a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000512c:	40000613          	li	a2,1024
    80005130:	05850593          	addi	a1,a0,88
    80005134:	05848513          	addi	a0,s1,88
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	d54080e7          	jalr	-684(ra) # 80000e8c <memmove>
    bwrite(to);  // write the log
    80005140:	8526                	mv	a0,s1
    80005142:	fffff097          	auipc	ra,0xfffff
    80005146:	d68080e7          	jalr	-664(ra) # 80003eaa <bwrite>
    brelse(from);
    8000514a:	854e                	mv	a0,s3
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	d9c080e7          	jalr	-612(ra) # 80003ee8 <brelse>
    brelse(to);
    80005154:	8526                	mv	a0,s1
    80005156:	fffff097          	auipc	ra,0xfffff
    8000515a:	d92080e7          	jalr	-622(ra) # 80003ee8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000515e:	2905                	addiw	s2,s2,1
    80005160:	0a91                	addi	s5,s5,4
    80005162:	02ca2783          	lw	a5,44(s4)
    80005166:	f8f94ee3          	blt	s2,a5,80005102 <end_op+0xdc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000516a:	00000097          	auipc	ra,0x0
    8000516e:	c70080e7          	jalr	-912(ra) # 80004dda <write_head>
    install_trans(0); // Now install writes to home locations
    80005172:	4501                	li	a0,0
    80005174:	00000097          	auipc	ra,0x0
    80005178:	cd0080e7          	jalr	-816(ra) # 80004e44 <install_trans>
    log.lh.n = 0;
    8000517c:	0006b797          	auipc	a5,0x6b
    80005180:	0607a823          	sw	zero,112(a5) # 800701ec <log+0x2c>
    write_head();    // Erase the transaction from the log
    80005184:	00000097          	auipc	ra,0x0
    80005188:	c56080e7          	jalr	-938(ra) # 80004dda <write_head>
    8000518c:	69e2                	ld	s3,24(sp)
    8000518e:	6a42                	ld	s4,16(sp)
    80005190:	6aa2                	ld	s5,8(sp)
    80005192:	bdf9                	j	80005070 <end_op+0x4a>

0000000080005194 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80005194:	1101                	addi	sp,sp,-32
    80005196:	ec06                	sd	ra,24(sp)
    80005198:	e822                	sd	s0,16(sp)
    8000519a:	e426                	sd	s1,8(sp)
    8000519c:	1000                	addi	s0,sp,32
    8000519e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800051a0:	0006b517          	auipc	a0,0x6b
    800051a4:	02050513          	addi	a0,a0,32 # 800701c0 <log>
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	b8c080e7          	jalr	-1140(ra) # 80000d34 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800051b0:	0006b617          	auipc	a2,0x6b
    800051b4:	03c62603          	lw	a2,60(a2) # 800701ec <log+0x2c>
    800051b8:	47f5                	li	a5,29
    800051ba:	06c7c663          	blt	a5,a2,80005226 <log_write+0x92>
    800051be:	0006b797          	auipc	a5,0x6b
    800051c2:	01e7a783          	lw	a5,30(a5) # 800701dc <log+0x1c>
    800051c6:	37fd                	addiw	a5,a5,-1
    800051c8:	04f65f63          	bge	a2,a5,80005226 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800051cc:	0006b797          	auipc	a5,0x6b
    800051d0:	0147a783          	lw	a5,20(a5) # 800701e0 <log+0x20>
    800051d4:	06f05163          	blez	a5,80005236 <log_write+0xa2>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800051d8:	4781                	li	a5,0
    800051da:	06c05663          	blez	a2,80005246 <log_write+0xb2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800051de:	44cc                	lw	a1,12(s1)
    800051e0:	0006b717          	auipc	a4,0x6b
    800051e4:	01070713          	addi	a4,a4,16 # 800701f0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800051e8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800051ea:	4314                	lw	a3,0(a4)
    800051ec:	04b68d63          	beq	a3,a1,80005246 <log_write+0xb2>
  for (i = 0; i < log.lh.n; i++) {
    800051f0:	2785                	addiw	a5,a5,1
    800051f2:	0711                	addi	a4,a4,4
    800051f4:	fef61be3          	bne	a2,a5,800051ea <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800051f8:	060a                	slli	a2,a2,0x2
    800051fa:	02060613          	addi	a2,a2,32
    800051fe:	0006b797          	auipc	a5,0x6b
    80005202:	fc278793          	addi	a5,a5,-62 # 800701c0 <log>
    80005206:	97b2                	add	a5,a5,a2
    80005208:	44d8                	lw	a4,12(s1)
    8000520a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000520c:	8526                	mv	a0,s1
    8000520e:	fffff097          	auipc	ra,0xfffff
    80005212:	d72080e7          	jalr	-654(ra) # 80003f80 <bpin>
    log.lh.n++;
    80005216:	0006b717          	auipc	a4,0x6b
    8000521a:	faa70713          	addi	a4,a4,-86 # 800701c0 <log>
    8000521e:	575c                	lw	a5,44(a4)
    80005220:	2785                	addiw	a5,a5,1
    80005222:	d75c                	sw	a5,44(a4)
    80005224:	a835                	j	80005260 <log_write+0xcc>
    panic("too big a transaction");
    80005226:	00006517          	auipc	a0,0x6
    8000522a:	3a250513          	addi	a0,a0,930 # 8000b5c8 <etext+0x5c8>
    8000522e:	ffffb097          	auipc	ra,0xffffb
    80005232:	330080e7          	jalr	816(ra) # 8000055e <panic>
    panic("log_write outside of trans");
    80005236:	00006517          	auipc	a0,0x6
    8000523a:	3aa50513          	addi	a0,a0,938 # 8000b5e0 <etext+0x5e0>
    8000523e:	ffffb097          	auipc	ra,0xffffb
    80005242:	320080e7          	jalr	800(ra) # 8000055e <panic>
  log.lh.block[i] = b->blockno;
    80005246:	00279693          	slli	a3,a5,0x2
    8000524a:	02068693          	addi	a3,a3,32
    8000524e:	0006b717          	auipc	a4,0x6b
    80005252:	f7270713          	addi	a4,a4,-142 # 800701c0 <log>
    80005256:	9736                	add	a4,a4,a3
    80005258:	44d4                	lw	a3,12(s1)
    8000525a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000525c:	faf608e3          	beq	a2,a5,8000520c <log_write+0x78>
  }
  release(&log.lock);
    80005260:	0006b517          	auipc	a0,0x6b
    80005264:	f6050513          	addi	a0,a0,-160 # 800701c0 <log>
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	b7c080e7          	jalr	-1156(ra) # 80000de4 <release>
}
    80005270:	60e2                	ld	ra,24(sp)
    80005272:	6442                	ld	s0,16(sp)
    80005274:	64a2                	ld	s1,8(sp)
    80005276:	6105                	addi	sp,sp,32
    80005278:	8082                	ret

000000008000527a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000527a:	1101                	addi	sp,sp,-32
    8000527c:	ec06                	sd	ra,24(sp)
    8000527e:	e822                	sd	s0,16(sp)
    80005280:	e426                	sd	s1,8(sp)
    80005282:	e04a                	sd	s2,0(sp)
    80005284:	1000                	addi	s0,sp,32
    80005286:	84aa                	mv	s1,a0
    80005288:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000528a:	00006597          	auipc	a1,0x6
    8000528e:	37658593          	addi	a1,a1,886 # 8000b600 <etext+0x600>
    80005292:	0521                	addi	a0,a0,8
    80005294:	ffffc097          	auipc	ra,0xffffc
    80005298:	a06080e7          	jalr	-1530(ra) # 80000c9a <initlock>
  lk->name = name;
    8000529c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800052a0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800052a4:	0204a423          	sw	zero,40(s1)
}
    800052a8:	60e2                	ld	ra,24(sp)
    800052aa:	6442                	ld	s0,16(sp)
    800052ac:	64a2                	ld	s1,8(sp)
    800052ae:	6902                	ld	s2,0(sp)
    800052b0:	6105                	addi	sp,sp,32
    800052b2:	8082                	ret

00000000800052b4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800052b4:	1101                	addi	sp,sp,-32
    800052b6:	ec06                	sd	ra,24(sp)
    800052b8:	e822                	sd	s0,16(sp)
    800052ba:	e426                	sd	s1,8(sp)
    800052bc:	e04a                	sd	s2,0(sp)
    800052be:	1000                	addi	s0,sp,32
    800052c0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800052c2:	00850913          	addi	s2,a0,8
    800052c6:	854a                	mv	a0,s2
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	a6c080e7          	jalr	-1428(ra) # 80000d34 <acquire>
  while (lk->locked) {
    800052d0:	409c                	lw	a5,0(s1)
    800052d2:	cb89                	beqz	a5,800052e4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800052d4:	85ca                	mv	a1,s2
    800052d6:	8526                	mv	a0,s1
    800052d8:	ffffd097          	auipc	ra,0xffffd
    800052dc:	45c080e7          	jalr	1116(ra) # 80002734 <sleep>
  while (lk->locked) {
    800052e0:	409c                	lw	a5,0(s1)
    800052e2:	fbed                	bnez	a5,800052d4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800052e4:	4785                	li	a5,1
    800052e6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800052e8:	ffffd097          	auipc	ra,0xffffd
    800052ec:	b96080e7          	jalr	-1130(ra) # 80001e7e <myproc>
    800052f0:	591c                	lw	a5,48(a0)
    800052f2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800052f4:	854a                	mv	a0,s2
    800052f6:	ffffc097          	auipc	ra,0xffffc
    800052fa:	aee080e7          	jalr	-1298(ra) # 80000de4 <release>
}
    800052fe:	60e2                	ld	ra,24(sp)
    80005300:	6442                	ld	s0,16(sp)
    80005302:	64a2                	ld	s1,8(sp)
    80005304:	6902                	ld	s2,0(sp)
    80005306:	6105                	addi	sp,sp,32
    80005308:	8082                	ret

000000008000530a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000530a:	1101                	addi	sp,sp,-32
    8000530c:	ec06                	sd	ra,24(sp)
    8000530e:	e822                	sd	s0,16(sp)
    80005310:	e426                	sd	s1,8(sp)
    80005312:	e04a                	sd	s2,0(sp)
    80005314:	1000                	addi	s0,sp,32
    80005316:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80005318:	00850913          	addi	s2,a0,8
    8000531c:	854a                	mv	a0,s2
    8000531e:	ffffc097          	auipc	ra,0xffffc
    80005322:	a16080e7          	jalr	-1514(ra) # 80000d34 <acquire>
  lk->locked = 0;
    80005326:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000532a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000532e:	8526                	mv	a0,s1
    80005330:	ffffd097          	auipc	ra,0xffffd
    80005334:	468080e7          	jalr	1128(ra) # 80002798 <wakeup>
  release(&lk->lk);
    80005338:	854a                	mv	a0,s2
    8000533a:	ffffc097          	auipc	ra,0xffffc
    8000533e:	aaa080e7          	jalr	-1366(ra) # 80000de4 <release>
}
    80005342:	60e2                	ld	ra,24(sp)
    80005344:	6442                	ld	s0,16(sp)
    80005346:	64a2                	ld	s1,8(sp)
    80005348:	6902                	ld	s2,0(sp)
    8000534a:	6105                	addi	sp,sp,32
    8000534c:	8082                	ret

000000008000534e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000534e:	7179                	addi	sp,sp,-48
    80005350:	f406                	sd	ra,40(sp)
    80005352:	f022                	sd	s0,32(sp)
    80005354:	ec26                	sd	s1,24(sp)
    80005356:	e84a                	sd	s2,16(sp)
    80005358:	1800                	addi	s0,sp,48
    8000535a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000535c:	00850913          	addi	s2,a0,8
    80005360:	854a                	mv	a0,s2
    80005362:	ffffc097          	auipc	ra,0xffffc
    80005366:	9d2080e7          	jalr	-1582(ra) # 80000d34 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000536a:	409c                	lw	a5,0(s1)
    8000536c:	ef91                	bnez	a5,80005388 <holdingsleep+0x3a>
    8000536e:	4481                	li	s1,0
  release(&lk->lk);
    80005370:	854a                	mv	a0,s2
    80005372:	ffffc097          	auipc	ra,0xffffc
    80005376:	a72080e7          	jalr	-1422(ra) # 80000de4 <release>
  return r;
}
    8000537a:	8526                	mv	a0,s1
    8000537c:	70a2                	ld	ra,40(sp)
    8000537e:	7402                	ld	s0,32(sp)
    80005380:	64e2                	ld	s1,24(sp)
    80005382:	6942                	ld	s2,16(sp)
    80005384:	6145                	addi	sp,sp,48
    80005386:	8082                	ret
    80005388:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000538a:	0284a983          	lw	s3,40(s1)
    8000538e:	ffffd097          	auipc	ra,0xffffd
    80005392:	af0080e7          	jalr	-1296(ra) # 80001e7e <myproc>
    80005396:	5904                	lw	s1,48(a0)
    80005398:	413484b3          	sub	s1,s1,s3
    8000539c:	0014b493          	seqz	s1,s1
    800053a0:	69a2                	ld	s3,8(sp)
    800053a2:	b7f9                	j	80005370 <holdingsleep+0x22>

00000000800053a4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800053a4:	1141                	addi	sp,sp,-16
    800053a6:	e406                	sd	ra,8(sp)
    800053a8:	e022                	sd	s0,0(sp)
    800053aa:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800053ac:	00006597          	auipc	a1,0x6
    800053b0:	26458593          	addi	a1,a1,612 # 8000b610 <etext+0x610>
    800053b4:	0006b517          	auipc	a0,0x6b
    800053b8:	f5450513          	addi	a0,a0,-172 # 80070308 <ftable>
    800053bc:	ffffc097          	auipc	ra,0xffffc
    800053c0:	8de080e7          	jalr	-1826(ra) # 80000c9a <initlock>
}
    800053c4:	60a2                	ld	ra,8(sp)
    800053c6:	6402                	ld	s0,0(sp)
    800053c8:	0141                	addi	sp,sp,16
    800053ca:	8082                	ret

00000000800053cc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800053cc:	1101                	addi	sp,sp,-32
    800053ce:	ec06                	sd	ra,24(sp)
    800053d0:	e822                	sd	s0,16(sp)
    800053d2:	e426                	sd	s1,8(sp)
    800053d4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800053d6:	0006b517          	auipc	a0,0x6b
    800053da:	f3250513          	addi	a0,a0,-206 # 80070308 <ftable>
    800053de:	ffffc097          	auipc	ra,0xffffc
    800053e2:	956080e7          	jalr	-1706(ra) # 80000d34 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800053e6:	0006b497          	auipc	s1,0x6b
    800053ea:	f3a48493          	addi	s1,s1,-198 # 80070320 <ftable+0x18>
    800053ee:	0006c717          	auipc	a4,0x6c
    800053f2:	1f270713          	addi	a4,a4,498 # 800715e0 <disk>
    if(f->ref == 0){
    800053f6:	40dc                	lw	a5,4(s1)
    800053f8:	cf99                	beqz	a5,80005416 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800053fa:	03048493          	addi	s1,s1,48
    800053fe:	fee49ce3          	bne	s1,a4,800053f6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005402:	0006b517          	auipc	a0,0x6b
    80005406:	f0650513          	addi	a0,a0,-250 # 80070308 <ftable>
    8000540a:	ffffc097          	auipc	ra,0xffffc
    8000540e:	9da080e7          	jalr	-1574(ra) # 80000de4 <release>
  return 0;
    80005412:	4481                	li	s1,0
    80005414:	a819                	j	8000542a <filealloc+0x5e>
      f->ref = 1;
    80005416:	4785                	li	a5,1
    80005418:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000541a:	0006b517          	auipc	a0,0x6b
    8000541e:	eee50513          	addi	a0,a0,-274 # 80070308 <ftable>
    80005422:	ffffc097          	auipc	ra,0xffffc
    80005426:	9c2080e7          	jalr	-1598(ra) # 80000de4 <release>
}
    8000542a:	8526                	mv	a0,s1
    8000542c:	60e2                	ld	ra,24(sp)
    8000542e:	6442                	ld	s0,16(sp)
    80005430:	64a2                	ld	s1,8(sp)
    80005432:	6105                	addi	sp,sp,32
    80005434:	8082                	ret

0000000080005436 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005436:	1101                	addi	sp,sp,-32
    80005438:	ec06                	sd	ra,24(sp)
    8000543a:	e822                	sd	s0,16(sp)
    8000543c:	e426                	sd	s1,8(sp)
    8000543e:	1000                	addi	s0,sp,32
    80005440:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80005442:	0006b517          	auipc	a0,0x6b
    80005446:	ec650513          	addi	a0,a0,-314 # 80070308 <ftable>
    8000544a:	ffffc097          	auipc	ra,0xffffc
    8000544e:	8ea080e7          	jalr	-1814(ra) # 80000d34 <acquire>
  if(f->ref < 1)
    80005452:	40dc                	lw	a5,4(s1)
    80005454:	02f05263          	blez	a5,80005478 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80005458:	2785                	addiw	a5,a5,1
    8000545a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000545c:	0006b517          	auipc	a0,0x6b
    80005460:	eac50513          	addi	a0,a0,-340 # 80070308 <ftable>
    80005464:	ffffc097          	auipc	ra,0xffffc
    80005468:	980080e7          	jalr	-1664(ra) # 80000de4 <release>
  return f;
}
    8000546c:	8526                	mv	a0,s1
    8000546e:	60e2                	ld	ra,24(sp)
    80005470:	6442                	ld	s0,16(sp)
    80005472:	64a2                	ld	s1,8(sp)
    80005474:	6105                	addi	sp,sp,32
    80005476:	8082                	ret
    panic("filedup");
    80005478:	00006517          	auipc	a0,0x6
    8000547c:	1a050513          	addi	a0,a0,416 # 8000b618 <etext+0x618>
    80005480:	ffffb097          	auipc	ra,0xffffb
    80005484:	0de080e7          	jalr	222(ra) # 8000055e <panic>

0000000080005488 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005488:	7139                	addi	sp,sp,-64
    8000548a:	fc06                	sd	ra,56(sp)
    8000548c:	f822                	sd	s0,48(sp)
    8000548e:	f426                	sd	s1,40(sp)
    80005490:	0080                	addi	s0,sp,64
    80005492:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005494:	0006b517          	auipc	a0,0x6b
    80005498:	e7450513          	addi	a0,a0,-396 # 80070308 <ftable>
    8000549c:	ffffc097          	auipc	ra,0xffffc
    800054a0:	898080e7          	jalr	-1896(ra) # 80000d34 <acquire>
  if(f->ref < 1)
    800054a4:	40dc                	lw	a5,4(s1)
    800054a6:	06f05c63          	blez	a5,8000551e <fileclose+0x96>
    panic("fileclose");
  if(--f->ref > 0){
    800054aa:	37fd                	addiw	a5,a5,-1
    800054ac:	c0dc                	sw	a5,4(s1)
    800054ae:	08f04463          	bgtz	a5,80005536 <fileclose+0xae>
    800054b2:	f04a                	sd	s2,32(sp)
    800054b4:	ec4e                	sd	s3,24(sp)
    800054b6:	e852                	sd	s4,16(sp)
    800054b8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800054ba:	0004a903          	lw	s2,0(s1)
    800054be:	0094c783          	lbu	a5,9(s1)
    800054c2:	8a3e                	mv	s4,a5
    800054c4:	689c                	ld	a5,16(s1)
    800054c6:	8abe                	mv	s5,a5
    800054c8:	6c9c                	ld	a5,24(s1)
    800054ca:	89be                	mv	s3,a5
  f->ref = 0;
    800054cc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800054d0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800054d4:	0006b517          	auipc	a0,0x6b
    800054d8:	e3450513          	addi	a0,a0,-460 # 80070308 <ftable>
    800054dc:	ffffc097          	auipc	ra,0xffffc
    800054e0:	908080e7          	jalr	-1784(ra) # 80000de4 <release>

  switch (ff.type) {
    800054e4:	478d                	li	a5,3
    800054e6:	0af90663          	beq	s2,a5,80005592 <fileclose+0x10a>
    800054ea:	0727e863          	bltu	a5,s2,8000555a <fileclose+0xd2>
    800054ee:	4785                	li	a5,1
    800054f0:	08f90663          	beq	s2,a5,8000557c <fileclose+0xf4>
    800054f4:	4789                	li	a5,2
    800054f6:	04f91d63          	bne	s2,a5,80005550 <fileclose+0xc8>
  case FD_PIPE :
    pipeclose(ff.pipe, ff.writable);
    break;
  case FD_INODE:
    begin_op();
    800054fa:	00000097          	auipc	ra,0x0
    800054fe:	aac080e7          	jalr	-1364(ra) # 80004fa6 <begin_op>
    iput(ff.ip);
    80005502:	854e                	mv	a0,s3
    80005504:	fffff097          	auipc	ra,0xfffff
    80005508:	270080e7          	jalr	624(ra) # 80004774 <iput>
    end_op();
    8000550c:	00000097          	auipc	ra,0x0
    80005510:	b1a080e7          	jalr	-1254(ra) # 80005026 <end_op>
    break;
    80005514:	7902                	ld	s2,32(sp)
    80005516:	69e2                	ld	s3,24(sp)
    80005518:	6a42                	ld	s4,16(sp)
    8000551a:	6aa2                	ld	s5,8(sp)
    8000551c:	a02d                	j	80005546 <fileclose+0xbe>
    8000551e:	f04a                	sd	s2,32(sp)
    80005520:	ec4e                	sd	s3,24(sp)
    80005522:	e852                	sd	s4,16(sp)
    80005524:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80005526:	00006517          	auipc	a0,0x6
    8000552a:	0fa50513          	addi	a0,a0,250 # 8000b620 <etext+0x620>
    8000552e:	ffffb097          	auipc	ra,0xffffb
    80005532:	030080e7          	jalr	48(ra) # 8000055e <panic>
    release(&ftable.lock);
    80005536:	0006b517          	auipc	a0,0x6b
    8000553a:	dd250513          	addi	a0,a0,-558 # 80070308 <ftable>
    8000553e:	ffffc097          	auipc	ra,0xffffc
    80005542:	8a6080e7          	jalr	-1882(ra) # 80000de4 <release>
    end_op();
    break;
  case FD_SOCKET:
    f->sock->ops->close(f->sock);
  };
}
    80005546:	70e2                	ld	ra,56(sp)
    80005548:	7442                	ld	s0,48(sp)
    8000554a:	74a2                	ld	s1,40(sp)
    8000554c:	6121                	addi	sp,sp,64
    8000554e:	8082                	ret
    80005550:	7902                	ld	s2,32(sp)
    80005552:	69e2                	ld	s3,24(sp)
    80005554:	6a42                	ld	s4,16(sp)
    80005556:	6aa2                	ld	s5,8(sp)
    80005558:	b7fd                	j	80005546 <fileclose+0xbe>
  switch (ff.type) {
    8000555a:	4791                	li	a5,4
    8000555c:	00f91b63          	bne	s2,a5,80005572 <fileclose+0xea>
    f->sock->ops->close(f->sock);
    80005560:	7088                	ld	a0,32(s1)
    80005562:	653c                	ld	a5,72(a0)
    80005564:	7b9c                	ld	a5,48(a5)
    80005566:	9782                	jalr	a5
    80005568:	7902                	ld	s2,32(sp)
    8000556a:	69e2                	ld	s3,24(sp)
    8000556c:	6a42                	ld	s4,16(sp)
    8000556e:	6aa2                	ld	s5,8(sp)
    80005570:	bfd9                	j	80005546 <fileclose+0xbe>
    80005572:	7902                	ld	s2,32(sp)
    80005574:	69e2                	ld	s3,24(sp)
    80005576:	6a42                	ld	s4,16(sp)
    80005578:	6aa2                	ld	s5,8(sp)
    8000557a:	b7f1                	j	80005546 <fileclose+0xbe>
    pipeclose(ff.pipe, ff.writable);
    8000557c:	85d2                	mv	a1,s4
    8000557e:	8556                	mv	a0,s5
    80005580:	00000097          	auipc	ra,0x0
    80005584:	3b4080e7          	jalr	948(ra) # 80005934 <pipeclose>
    break;
    80005588:	7902                	ld	s2,32(sp)
    8000558a:	69e2                	ld	s3,24(sp)
    8000558c:	6a42                	ld	s4,16(sp)
    8000558e:	6aa2                	ld	s5,8(sp)
    80005590:	bf5d                	j	80005546 <fileclose+0xbe>
    begin_op();
    80005592:	00000097          	auipc	ra,0x0
    80005596:	a14080e7          	jalr	-1516(ra) # 80004fa6 <begin_op>
    iput(ff.ip);
    8000559a:	854e                	mv	a0,s3
    8000559c:	fffff097          	auipc	ra,0xfffff
    800055a0:	1d8080e7          	jalr	472(ra) # 80004774 <iput>
    end_op();
    800055a4:	00000097          	auipc	ra,0x0
    800055a8:	a82080e7          	jalr	-1406(ra) # 80005026 <end_op>
    break;
    800055ac:	7902                	ld	s2,32(sp)
    800055ae:	69e2                	ld	s3,24(sp)
    800055b0:	6a42                	ld	s4,16(sp)
    800055b2:	6aa2                	ld	s5,8(sp)
    800055b4:	bf49                	j	80005546 <fileclose+0xbe>

00000000800055b6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800055b6:	715d                	addi	sp,sp,-80
    800055b8:	e486                	sd	ra,72(sp)
    800055ba:	e0a2                	sd	s0,64(sp)
    800055bc:	fc26                	sd	s1,56(sp)
    800055be:	f052                	sd	s4,32(sp)
    800055c0:	0880                	addi	s0,sp,80
    800055c2:	84aa                	mv	s1,a0
    800055c4:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800055c6:	ffffd097          	auipc	ra,0xffffd
    800055ca:	8b8080e7          	jalr	-1864(ra) # 80001e7e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800055ce:	409c                	lw	a5,0(s1)
    800055d0:	37f9                	addiw	a5,a5,-2
    800055d2:	4705                	li	a4,1
    800055d4:	04f76a63          	bltu	a4,a5,80005628 <filestat+0x72>
    800055d8:	f84a                	sd	s2,48(sp)
    800055da:	f44e                	sd	s3,40(sp)
    800055dc:	89aa                	mv	s3,a0
    ilock(f->ip);
    800055de:	6c88                	ld	a0,24(s1)
    800055e0:	fffff097          	auipc	ra,0xfffff
    800055e4:	fd6080e7          	jalr	-42(ra) # 800045b6 <ilock>
    stati(f->ip, &st);
    800055e8:	fb840913          	addi	s2,s0,-72
    800055ec:	85ca                	mv	a1,s2
    800055ee:	6c88                	ld	a0,24(s1)
    800055f0:	fffff097          	auipc	ra,0xfffff
    800055f4:	256080e7          	jalr	598(ra) # 80004846 <stati>
    iunlock(f->ip);
    800055f8:	6c88                	ld	a0,24(s1)
    800055fa:	fffff097          	auipc	ra,0xfffff
    800055fe:	082080e7          	jalr	130(ra) # 8000467c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80005602:	46e1                	li	a3,24
    80005604:	864a                	mv	a2,s2
    80005606:	85d2                	mv	a1,s4
    80005608:	0509b503          	ld	a0,80(s3)
    8000560c:	ffffc097          	auipc	ra,0xffffc
    80005610:	4fe080e7          	jalr	1278(ra) # 80001b0a <copyout>
    80005614:	41f5551b          	sraiw	a0,a0,0x1f
    80005618:	7942                	ld	s2,48(sp)
    8000561a:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000561c:	60a6                	ld	ra,72(sp)
    8000561e:	6406                	ld	s0,64(sp)
    80005620:	74e2                	ld	s1,56(sp)
    80005622:	7a02                	ld	s4,32(sp)
    80005624:	6161                	addi	sp,sp,80
    80005626:	8082                	ret
  return -1;
    80005628:	557d                	li	a0,-1
    8000562a:	bfcd                	j	8000561c <filestat+0x66>

000000008000562c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000562c:	7179                	addi	sp,sp,-48
    8000562e:	f406                	sd	ra,40(sp)
    80005630:	f022                	sd	s0,32(sp)
    80005632:	e84a                	sd	s2,16(sp)
    80005634:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80005636:	00854783          	lbu	a5,8(a0)
    8000563a:	cbc5                	beqz	a5,800056ea <fileread+0xbe>
    8000563c:	ec26                	sd	s1,24(sp)
    8000563e:	e44e                	sd	s3,8(sp)
    80005640:	84aa                	mv	s1,a0
    80005642:	892e                	mv	s2,a1
    80005644:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80005646:	411c                	lw	a5,0(a0)
    80005648:	4705                	li	a4,1
    8000564a:	04e78963          	beq	a5,a4,8000569c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000564e:	470d                	li	a4,3
    80005650:	04e78f63          	beq	a5,a4,800056ae <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80005654:	4709                	li	a4,2
    80005656:	08e79263          	bne	a5,a4,800056da <fileread+0xae>
    ilock(f->ip);
    8000565a:	6d08                	ld	a0,24(a0)
    8000565c:	fffff097          	auipc	ra,0xfffff
    80005660:	f5a080e7          	jalr	-166(ra) # 800045b6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80005664:	874e                	mv	a4,s3
    80005666:	5494                	lw	a3,40(s1)
    80005668:	864a                	mv	a2,s2
    8000566a:	4585                	li	a1,1
    8000566c:	6c88                	ld	a0,24(s1)
    8000566e:	fffff097          	auipc	ra,0xfffff
    80005672:	206080e7          	jalr	518(ra) # 80004874 <readi>
    80005676:	892a                	mv	s2,a0
    80005678:	00a05563          	blez	a0,80005682 <fileread+0x56>
      f->off += r;
    8000567c:	549c                	lw	a5,40(s1)
    8000567e:	9fa9                	addw	a5,a5,a0
    80005680:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    80005682:	6c88                	ld	a0,24(s1)
    80005684:	fffff097          	auipc	ra,0xfffff
    80005688:	ff8080e7          	jalr	-8(ra) # 8000467c <iunlock>
    8000568c:	64e2                	ld	s1,24(sp)
    8000568e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80005690:	854a                	mv	a0,s2
    80005692:	70a2                	ld	ra,40(sp)
    80005694:	7402                	ld	s0,32(sp)
    80005696:	6942                	ld	s2,16(sp)
    80005698:	6145                	addi	sp,sp,48
    8000569a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000569c:	6908                	ld	a0,16(a0)
    8000569e:	00000097          	auipc	ra,0x0
    800056a2:	428080e7          	jalr	1064(ra) # 80005ac6 <piperead>
    800056a6:	892a                	mv	s2,a0
    800056a8:	64e2                	ld	s1,24(sp)
    800056aa:	69a2                	ld	s3,8(sp)
    800056ac:	b7d5                	j	80005690 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800056ae:	02c51783          	lh	a5,44(a0)
    800056b2:	03079693          	slli	a3,a5,0x30
    800056b6:	92c1                	srli	a3,a3,0x30
    800056b8:	4725                	li	a4,9
    800056ba:	02d76b63          	bltu	a4,a3,800056f0 <fileread+0xc4>
    800056be:	0792                	slli	a5,a5,0x4
    800056c0:	0006b717          	auipc	a4,0x6b
    800056c4:	ba870713          	addi	a4,a4,-1112 # 80070268 <devsw>
    800056c8:	97ba                	add	a5,a5,a4
    800056ca:	639c                	ld	a5,0(a5)
    800056cc:	c79d                	beqz	a5,800056fa <fileread+0xce>
    r = devsw[f->major].read(1, addr, n);
    800056ce:	4505                	li	a0,1
    800056d0:	9782                	jalr	a5
    800056d2:	892a                	mv	s2,a0
    800056d4:	64e2                	ld	s1,24(sp)
    800056d6:	69a2                	ld	s3,8(sp)
    800056d8:	bf65                	j	80005690 <fileread+0x64>
    panic("fileread");
    800056da:	00006517          	auipc	a0,0x6
    800056de:	f5650513          	addi	a0,a0,-170 # 8000b630 <etext+0x630>
    800056e2:	ffffb097          	auipc	ra,0xffffb
    800056e6:	e7c080e7          	jalr	-388(ra) # 8000055e <panic>
    return -1;
    800056ea:	57fd                	li	a5,-1
    800056ec:	893e                	mv	s2,a5
    800056ee:	b74d                	j	80005690 <fileread+0x64>
      return -1;
    800056f0:	57fd                	li	a5,-1
    800056f2:	893e                	mv	s2,a5
    800056f4:	64e2                	ld	s1,24(sp)
    800056f6:	69a2                	ld	s3,8(sp)
    800056f8:	bf61                	j	80005690 <fileread+0x64>
    800056fa:	57fd                	li	a5,-1
    800056fc:	893e                	mv	s2,a5
    800056fe:	64e2                	ld	s1,24(sp)
    80005700:	69a2                	ld	s3,8(sp)
    80005702:	b779                	j	80005690 <fileread+0x64>

0000000080005704 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80005704:	00954783          	lbu	a5,9(a0)
    80005708:	12078d63          	beqz	a5,80005842 <filewrite+0x13e>
{
    8000570c:	711d                	addi	sp,sp,-96
    8000570e:	ec86                	sd	ra,88(sp)
    80005710:	e8a2                	sd	s0,80(sp)
    80005712:	e0ca                	sd	s2,64(sp)
    80005714:	f456                	sd	s5,40(sp)
    80005716:	f05a                	sd	s6,32(sp)
    80005718:	1080                	addi	s0,sp,96
    8000571a:	892a                	mv	s2,a0
    8000571c:	8b2e                	mv	s6,a1
    8000571e:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80005720:	411c                	lw	a5,0(a0)
    80005722:	4705                	li	a4,1
    80005724:	02e78a63          	beq	a5,a4,80005758 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005728:	470d                	li	a4,3
    8000572a:	02e78d63          	beq	a5,a4,80005764 <filewrite+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000572e:	4709                	li	a4,2
    80005730:	0ee79b63          	bne	a5,a4,80005826 <filewrite+0x122>
    80005734:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005736:	0cc05663          	blez	a2,80005802 <filewrite+0xfe>
    8000573a:	e4a6                	sd	s1,72(sp)
    8000573c:	fc4e                	sd	s3,56(sp)
    8000573e:	ec5e                	sd	s7,24(sp)
    80005740:	e862                	sd	s8,16(sp)
    80005742:	e466                	sd	s9,8(sp)
    int i = 0;
    80005744:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80005746:	6b85                	lui	s7,0x1
    80005748:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000574c:	6785                	lui	a5,0x1
    8000574e:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80005752:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005754:	4c05                	li	s8,1
    80005756:	a849                	j	800057e8 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80005758:	6908                	ld	a0,16(a0)
    8000575a:	00000097          	auipc	ra,0x0
    8000575e:	250080e7          	jalr	592(ra) # 800059aa <pipewrite>
    80005762:	a85d                	j	80005818 <filewrite+0x114>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005764:	02c51783          	lh	a5,44(a0)
    80005768:	03079693          	slli	a3,a5,0x30
    8000576c:	92c1                	srli	a3,a3,0x30
    8000576e:	4725                	li	a4,9
    80005770:	0cd76b63          	bltu	a4,a3,80005846 <filewrite+0x142>
    80005774:	0792                	slli	a5,a5,0x4
    80005776:	0006b717          	auipc	a4,0x6b
    8000577a:	af270713          	addi	a4,a4,-1294 # 80070268 <devsw>
    8000577e:	97ba                	add	a5,a5,a4
    80005780:	679c                	ld	a5,8(a5)
    80005782:	c7e1                	beqz	a5,8000584a <filewrite+0x146>
    ret = devsw[f->major].write(1, addr, n);
    80005784:	4505                	li	a0,1
    80005786:	9782                	jalr	a5
    80005788:	a841                	j	80005818 <filewrite+0x114>
      if(n1 > max)
    8000578a:	2981                	sext.w	s3,s3
      begin_op();
    8000578c:	00000097          	auipc	ra,0x0
    80005790:	81a080e7          	jalr	-2022(ra) # 80004fa6 <begin_op>
      ilock(f->ip);
    80005794:	01893503          	ld	a0,24(s2)
    80005798:	fffff097          	auipc	ra,0xfffff
    8000579c:	e1e080e7          	jalr	-482(ra) # 800045b6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800057a0:	874e                	mv	a4,s3
    800057a2:	02892683          	lw	a3,40(s2)
    800057a6:	016a0633          	add	a2,s4,s6
    800057aa:	85e2                	mv	a1,s8
    800057ac:	01893503          	ld	a0,24(s2)
    800057b0:	fffff097          	auipc	ra,0xfffff
    800057b4:	1ca080e7          	jalr	458(ra) # 8000497a <writei>
    800057b8:	84aa                	mv	s1,a0
    800057ba:	00a05763          	blez	a0,800057c8 <filewrite+0xc4>
        f->off += r;
    800057be:	02892783          	lw	a5,40(s2)
    800057c2:	9fa9                	addw	a5,a5,a0
    800057c4:	02f92423          	sw	a5,40(s2)
      iunlock(f->ip);
    800057c8:	01893503          	ld	a0,24(s2)
    800057cc:	fffff097          	auipc	ra,0xfffff
    800057d0:	eb0080e7          	jalr	-336(ra) # 8000467c <iunlock>
      end_op();
    800057d4:	00000097          	auipc	ra,0x0
    800057d8:	852080e7          	jalr	-1966(ra) # 80005026 <end_op>

      if(r != n1){
    800057dc:	02999563          	bne	s3,s1,80005806 <filewrite+0x102>
        // error from writei
        break;
      }
      i += r;
    800057e0:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800057e4:	015a5963          	bge	s4,s5,800057f6 <filewrite+0xf2>
      int n1 = n - i;
    800057e8:	414a87bb          	subw	a5,s5,s4
    800057ec:	89be                	mv	s3,a5
      if(n1 > max)
    800057ee:	f8fbdee3          	bge	s7,a5,8000578a <filewrite+0x86>
    800057f2:	89e6                	mv	s3,s9
    800057f4:	bf59                	j	8000578a <filewrite+0x86>
    800057f6:	64a6                	ld	s1,72(sp)
    800057f8:	79e2                	ld	s3,56(sp)
    800057fa:	6be2                	ld	s7,24(sp)
    800057fc:	6c42                	ld	s8,16(sp)
    800057fe:	6ca2                	ld	s9,8(sp)
    80005800:	a801                	j	80005810 <filewrite+0x10c>
    int i = 0;
    80005802:	4a01                	li	s4,0
    80005804:	a031                	j	80005810 <filewrite+0x10c>
    80005806:	64a6                	ld	s1,72(sp)
    80005808:	79e2                	ld	s3,56(sp)
    8000580a:	6be2                	ld	s7,24(sp)
    8000580c:	6c42                	ld	s8,16(sp)
    8000580e:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80005810:	034a9f63          	bne	s5,s4,8000584e <filewrite+0x14a>
    80005814:	8556                	mv	a0,s5
    80005816:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005818:	60e6                	ld	ra,88(sp)
    8000581a:	6446                	ld	s0,80(sp)
    8000581c:	6906                	ld	s2,64(sp)
    8000581e:	7aa2                	ld	s5,40(sp)
    80005820:	7b02                	ld	s6,32(sp)
    80005822:	6125                	addi	sp,sp,96
    80005824:	8082                	ret
    80005826:	e4a6                	sd	s1,72(sp)
    80005828:	fc4e                	sd	s3,56(sp)
    8000582a:	f852                	sd	s4,48(sp)
    8000582c:	ec5e                	sd	s7,24(sp)
    8000582e:	e862                	sd	s8,16(sp)
    80005830:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80005832:	00006517          	auipc	a0,0x6
    80005836:	e0e50513          	addi	a0,a0,-498 # 8000b640 <etext+0x640>
    8000583a:	ffffb097          	auipc	ra,0xffffb
    8000583e:	d24080e7          	jalr	-732(ra) # 8000055e <panic>
    return -1;
    80005842:	557d                	li	a0,-1
}
    80005844:	8082                	ret
      return -1;
    80005846:	557d                	li	a0,-1
    80005848:	bfc1                	j	80005818 <filewrite+0x114>
    8000584a:	557d                	li	a0,-1
    8000584c:	b7f1                	j	80005818 <filewrite+0x114>
    ret = (i == n ? n : -1);
    8000584e:	557d                	li	a0,-1
    80005850:	7a42                	ld	s4,48(sp)
    80005852:	b7d9                	j	80005818 <filewrite+0x114>

0000000080005854 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005854:	7179                	addi	sp,sp,-48
    80005856:	f406                	sd	ra,40(sp)
    80005858:	f022                	sd	s0,32(sp)
    8000585a:	ec26                	sd	s1,24(sp)
    8000585c:	e052                	sd	s4,0(sp)
    8000585e:	1800                	addi	s0,sp,48
    80005860:	84aa                	mv	s1,a0
    80005862:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005864:	0005b023          	sd	zero,0(a1)
    80005868:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000586c:	00000097          	auipc	ra,0x0
    80005870:	b60080e7          	jalr	-1184(ra) # 800053cc <filealloc>
    80005874:	e088                	sd	a0,0(s1)
    80005876:	cd49                	beqz	a0,80005910 <pipealloc+0xbc>
    80005878:	00000097          	auipc	ra,0x0
    8000587c:	b54080e7          	jalr	-1196(ra) # 800053cc <filealloc>
    80005880:	00aa3023          	sd	a0,0(s4)
    80005884:	c141                	beqz	a0,80005904 <pipealloc+0xb0>
    80005886:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005888:	ffffb097          	auipc	ra,0xffffb
    8000588c:	38a080e7          	jalr	906(ra) # 80000c12 <kalloc>
    80005890:	892a                	mv	s2,a0
    80005892:	c13d                	beqz	a0,800058f8 <pipealloc+0xa4>
    80005894:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80005896:	4985                	li	s3,1
    80005898:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000589c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800058a0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800058a4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800058a8:	00006597          	auipc	a1,0x6
    800058ac:	da858593          	addi	a1,a1,-600 # 8000b650 <etext+0x650>
    800058b0:	ffffb097          	auipc	ra,0xffffb
    800058b4:	3ea080e7          	jalr	1002(ra) # 80000c9a <initlock>
  (*f0)->type = FD_PIPE;
    800058b8:	609c                	ld	a5,0(s1)
    800058ba:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800058be:	609c                	ld	a5,0(s1)
    800058c0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800058c4:	609c                	ld	a5,0(s1)
    800058c6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800058ca:	609c                	ld	a5,0(s1)
    800058cc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800058d0:	000a3783          	ld	a5,0(s4)
    800058d4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800058d8:	000a3783          	ld	a5,0(s4)
    800058dc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800058e0:	000a3783          	ld	a5,0(s4)
    800058e4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800058e8:	000a3783          	ld	a5,0(s4)
    800058ec:	0127b823          	sd	s2,16(a5)
  return 0;
    800058f0:	4501                	li	a0,0
    800058f2:	6942                	ld	s2,16(sp)
    800058f4:	69a2                	ld	s3,8(sp)
    800058f6:	a03d                	j	80005924 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800058f8:	6088                	ld	a0,0(s1)
    800058fa:	c119                	beqz	a0,80005900 <pipealloc+0xac>
    800058fc:	6942                	ld	s2,16(sp)
    800058fe:	a029                	j	80005908 <pipealloc+0xb4>
    80005900:	6942                	ld	s2,16(sp)
    80005902:	a039                	j	80005910 <pipealloc+0xbc>
    80005904:	6088                	ld	a0,0(s1)
    80005906:	c50d                	beqz	a0,80005930 <pipealloc+0xdc>
    fileclose(*f0);
    80005908:	00000097          	auipc	ra,0x0
    8000590c:	b80080e7          	jalr	-1152(ra) # 80005488 <fileclose>
  if(*f1)
    80005910:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005914:	557d                	li	a0,-1
  if(*f1)
    80005916:	c799                	beqz	a5,80005924 <pipealloc+0xd0>
    fileclose(*f1);
    80005918:	853e                	mv	a0,a5
    8000591a:	00000097          	auipc	ra,0x0
    8000591e:	b6e080e7          	jalr	-1170(ra) # 80005488 <fileclose>
  return -1;
    80005922:	557d                	li	a0,-1
}
    80005924:	70a2                	ld	ra,40(sp)
    80005926:	7402                	ld	s0,32(sp)
    80005928:	64e2                	ld	s1,24(sp)
    8000592a:	6a02                	ld	s4,0(sp)
    8000592c:	6145                	addi	sp,sp,48
    8000592e:	8082                	ret
  return -1;
    80005930:	557d                	li	a0,-1
    80005932:	bfcd                	j	80005924 <pipealloc+0xd0>

0000000080005934 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005934:	1101                	addi	sp,sp,-32
    80005936:	ec06                	sd	ra,24(sp)
    80005938:	e822                	sd	s0,16(sp)
    8000593a:	e426                	sd	s1,8(sp)
    8000593c:	e04a                	sd	s2,0(sp)
    8000593e:	1000                	addi	s0,sp,32
    80005940:	84aa                	mv	s1,a0
    80005942:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005944:	ffffb097          	auipc	ra,0xffffb
    80005948:	3f0080e7          	jalr	1008(ra) # 80000d34 <acquire>
  if(writable){
    8000594c:	02090b63          	beqz	s2,80005982 <pipeclose+0x4e>
    pi->writeopen = 0;
    80005950:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005954:	21848513          	addi	a0,s1,536
    80005958:	ffffd097          	auipc	ra,0xffffd
    8000595c:	e40080e7          	jalr	-448(ra) # 80002798 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005960:	2204a783          	lw	a5,544(s1)
    80005964:	e781                	bnez	a5,8000596c <pipeclose+0x38>
    80005966:	2244a783          	lw	a5,548(s1)
    8000596a:	c78d                	beqz	a5,80005994 <pipeclose+0x60>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    8000596c:	8526                	mv	a0,s1
    8000596e:	ffffb097          	auipc	ra,0xffffb
    80005972:	476080e7          	jalr	1142(ra) # 80000de4 <release>
}
    80005976:	60e2                	ld	ra,24(sp)
    80005978:	6442                	ld	s0,16(sp)
    8000597a:	64a2                	ld	s1,8(sp)
    8000597c:	6902                	ld	s2,0(sp)
    8000597e:	6105                	addi	sp,sp,32
    80005980:	8082                	ret
    pi->readopen = 0;
    80005982:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005986:	21c48513          	addi	a0,s1,540
    8000598a:	ffffd097          	auipc	ra,0xffffd
    8000598e:	e0e080e7          	jalr	-498(ra) # 80002798 <wakeup>
    80005992:	b7f9                	j	80005960 <pipeclose+0x2c>
    release(&pi->lock);
    80005994:	8526                	mv	a0,s1
    80005996:	ffffb097          	auipc	ra,0xffffb
    8000599a:	44e080e7          	jalr	1102(ra) # 80000de4 <release>
    kfree((char*)pi);
    8000599e:	8526                	mv	a0,s1
    800059a0:	ffffb097          	auipc	ra,0xffffb
    800059a4:	104080e7          	jalr	260(ra) # 80000aa4 <kfree>
    800059a8:	b7f9                	j	80005976 <pipeclose+0x42>

00000000800059aa <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800059aa:	7159                	addi	sp,sp,-112
    800059ac:	f486                	sd	ra,104(sp)
    800059ae:	f0a2                	sd	s0,96(sp)
    800059b0:	eca6                	sd	s1,88(sp)
    800059b2:	e8ca                	sd	s2,80(sp)
    800059b4:	e4ce                	sd	s3,72(sp)
    800059b6:	e0d2                	sd	s4,64(sp)
    800059b8:	fc56                	sd	s5,56(sp)
    800059ba:	1880                	addi	s0,sp,112
    800059bc:	84aa                	mv	s1,a0
    800059be:	8aae                	mv	s5,a1
    800059c0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800059c2:	ffffc097          	auipc	ra,0xffffc
    800059c6:	4bc080e7          	jalr	1212(ra) # 80001e7e <myproc>
    800059ca:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800059cc:	8526                	mv	a0,s1
    800059ce:	ffffb097          	auipc	ra,0xffffb
    800059d2:	366080e7          	jalr	870(ra) # 80000d34 <acquire>
  while(i < n){
    800059d6:	0f405063          	blez	s4,80005ab6 <pipewrite+0x10c>
    800059da:	f85a                	sd	s6,48(sp)
    800059dc:	f45e                	sd	s7,40(sp)
    800059de:	f062                	sd	s8,32(sp)
    800059e0:	ec66                	sd	s9,24(sp)
    800059e2:	e86a                	sd	s10,16(sp)
  int i = 0;
    800059e4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800059e6:	f9f40c13          	addi	s8,s0,-97
    800059ea:	4b85                	li	s7,1
    800059ec:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800059ee:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800059f2:	21c48c93          	addi	s9,s1,540
    800059f6:	a099                	j	80005a3c <pipewrite+0x92>
      release(&pi->lock);
    800059f8:	8526                	mv	a0,s1
    800059fa:	ffffb097          	auipc	ra,0xffffb
    800059fe:	3ea080e7          	jalr	1002(ra) # 80000de4 <release>
      return -1;
    80005a02:	597d                	li	s2,-1
    80005a04:	7b42                	ld	s6,48(sp)
    80005a06:	7ba2                	ld	s7,40(sp)
    80005a08:	7c02                	ld	s8,32(sp)
    80005a0a:	6ce2                	ld	s9,24(sp)
    80005a0c:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005a0e:	854a                	mv	a0,s2
    80005a10:	70a6                	ld	ra,104(sp)
    80005a12:	7406                	ld	s0,96(sp)
    80005a14:	64e6                	ld	s1,88(sp)
    80005a16:	6946                	ld	s2,80(sp)
    80005a18:	69a6                	ld	s3,72(sp)
    80005a1a:	6a06                	ld	s4,64(sp)
    80005a1c:	7ae2                	ld	s5,56(sp)
    80005a1e:	6165                	addi	sp,sp,112
    80005a20:	8082                	ret
      wakeup(&pi->nread);
    80005a22:	856a                	mv	a0,s10
    80005a24:	ffffd097          	auipc	ra,0xffffd
    80005a28:	d74080e7          	jalr	-652(ra) # 80002798 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005a2c:	85a6                	mv	a1,s1
    80005a2e:	8566                	mv	a0,s9
    80005a30:	ffffd097          	auipc	ra,0xffffd
    80005a34:	d04080e7          	jalr	-764(ra) # 80002734 <sleep>
  while(i < n){
    80005a38:	05495e63          	bge	s2,s4,80005a94 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    80005a3c:	2204a783          	lw	a5,544(s1)
    80005a40:	dfc5                	beqz	a5,800059f8 <pipewrite+0x4e>
    80005a42:	854e                	mv	a0,s3
    80005a44:	ffffd097          	auipc	ra,0xffffd
    80005a48:	11e080e7          	jalr	286(ra) # 80002b62 <killed>
    80005a4c:	f555                	bnez	a0,800059f8 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005a4e:	2184a783          	lw	a5,536(s1)
    80005a52:	21c4a703          	lw	a4,540(s1)
    80005a56:	2007879b          	addiw	a5,a5,512
    80005a5a:	fcf704e3          	beq	a4,a5,80005a22 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005a5e:	86de                	mv	a3,s7
    80005a60:	01590633          	add	a2,s2,s5
    80005a64:	85e2                	mv	a1,s8
    80005a66:	0509b503          	ld	a0,80(s3)
    80005a6a:	ffffc097          	auipc	ra,0xffffc
    80005a6e:	12c080e7          	jalr	300(ra) # 80001b96 <copyin>
    80005a72:	05650463          	beq	a0,s6,80005aba <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005a76:	21c4a783          	lw	a5,540(s1)
    80005a7a:	0017871b          	addiw	a4,a5,1
    80005a7e:	20e4ae23          	sw	a4,540(s1)
    80005a82:	1ff7f793          	andi	a5,a5,511
    80005a86:	97a6                	add	a5,a5,s1
    80005a88:	f9f44703          	lbu	a4,-97(s0)
    80005a8c:	00e78c23          	sb	a4,24(a5)
      i++;
    80005a90:	2905                	addiw	s2,s2,1
    80005a92:	b75d                	j	80005a38 <pipewrite+0x8e>
    80005a94:	7b42                	ld	s6,48(sp)
    80005a96:	7ba2                	ld	s7,40(sp)
    80005a98:	7c02                	ld	s8,32(sp)
    80005a9a:	6ce2                	ld	s9,24(sp)
    80005a9c:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80005a9e:	21848513          	addi	a0,s1,536
    80005aa2:	ffffd097          	auipc	ra,0xffffd
    80005aa6:	cf6080e7          	jalr	-778(ra) # 80002798 <wakeup>
  release(&pi->lock);
    80005aaa:	8526                	mv	a0,s1
    80005aac:	ffffb097          	auipc	ra,0xffffb
    80005ab0:	338080e7          	jalr	824(ra) # 80000de4 <release>
  return i;
    80005ab4:	bfa9                	j	80005a0e <pipewrite+0x64>
  int i = 0;
    80005ab6:	4901                	li	s2,0
    80005ab8:	b7dd                	j	80005a9e <pipewrite+0xf4>
    80005aba:	7b42                	ld	s6,48(sp)
    80005abc:	7ba2                	ld	s7,40(sp)
    80005abe:	7c02                	ld	s8,32(sp)
    80005ac0:	6ce2                	ld	s9,24(sp)
    80005ac2:	6d42                	ld	s10,16(sp)
    80005ac4:	bfe9                	j	80005a9e <pipewrite+0xf4>

0000000080005ac6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005ac6:	711d                	addi	sp,sp,-96
    80005ac8:	ec86                	sd	ra,88(sp)
    80005aca:	e8a2                	sd	s0,80(sp)
    80005acc:	e4a6                	sd	s1,72(sp)
    80005ace:	e0ca                	sd	s2,64(sp)
    80005ad0:	fc4e                	sd	s3,56(sp)
    80005ad2:	f852                	sd	s4,48(sp)
    80005ad4:	f456                	sd	s5,40(sp)
    80005ad6:	1080                	addi	s0,sp,96
    80005ad8:	84aa                	mv	s1,a0
    80005ada:	892e                	mv	s2,a1
    80005adc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005ade:	ffffc097          	auipc	ra,0xffffc
    80005ae2:	3a0080e7          	jalr	928(ra) # 80001e7e <myproc>
    80005ae6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005ae8:	8526                	mv	a0,s1
    80005aea:	ffffb097          	auipc	ra,0xffffb
    80005aee:	24a080e7          	jalr	586(ra) # 80000d34 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005af2:	2184a703          	lw	a4,536(s1)
    80005af6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005afa:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005afe:	02f71b63          	bne	a4,a5,80005b34 <piperead+0x6e>
    80005b02:	2244a783          	lw	a5,548(s1)
    80005b06:	c3b1                	beqz	a5,80005b4a <piperead+0x84>
    if(killed(pr)){
    80005b08:	8552                	mv	a0,s4
    80005b0a:	ffffd097          	auipc	ra,0xffffd
    80005b0e:	058080e7          	jalr	88(ra) # 80002b62 <killed>
    80005b12:	e50d                	bnez	a0,80005b3c <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005b14:	85a6                	mv	a1,s1
    80005b16:	854e                	mv	a0,s3
    80005b18:	ffffd097          	auipc	ra,0xffffd
    80005b1c:	c1c080e7          	jalr	-996(ra) # 80002734 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005b20:	2184a703          	lw	a4,536(s1)
    80005b24:	21c4a783          	lw	a5,540(s1)
    80005b28:	fcf70de3          	beq	a4,a5,80005b02 <piperead+0x3c>
    80005b2c:	f05a                	sd	s6,32(sp)
    80005b2e:	ec5e                	sd	s7,24(sp)
    80005b30:	e862                	sd	s8,16(sp)
    80005b32:	a839                	j	80005b50 <piperead+0x8a>
    80005b34:	f05a                	sd	s6,32(sp)
    80005b36:	ec5e                	sd	s7,24(sp)
    80005b38:	e862                	sd	s8,16(sp)
    80005b3a:	a819                	j	80005b50 <piperead+0x8a>
      release(&pi->lock);
    80005b3c:	8526                	mv	a0,s1
    80005b3e:	ffffb097          	auipc	ra,0xffffb
    80005b42:	2a6080e7          	jalr	678(ra) # 80000de4 <release>
      return -1;
    80005b46:	59fd                	li	s3,-1
    80005b48:	a88d                	j	80005bba <piperead+0xf4>
    80005b4a:	f05a                	sd	s6,32(sp)
    80005b4c:	ec5e                	sd	s7,24(sp)
    80005b4e:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005b50:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005b52:	faf40c13          	addi	s8,s0,-81
    80005b56:	4b85                	li	s7,1
    80005b58:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005b5a:	05505263          	blez	s5,80005b9e <piperead+0xd8>
    if(pi->nread == pi->nwrite)
    80005b5e:	2184a783          	lw	a5,536(s1)
    80005b62:	21c4a703          	lw	a4,540(s1)
    80005b66:	02f70c63          	beq	a4,a5,80005b9e <piperead+0xd8>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005b6a:	0017871b          	addiw	a4,a5,1
    80005b6e:	20e4ac23          	sw	a4,536(s1)
    80005b72:	1ff7f793          	andi	a5,a5,511
    80005b76:	97a6                	add	a5,a5,s1
    80005b78:	0187c783          	lbu	a5,24(a5)
    80005b7c:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005b80:	86de                	mv	a3,s7
    80005b82:	8662                	mv	a2,s8
    80005b84:	85ca                	mv	a1,s2
    80005b86:	050a3503          	ld	a0,80(s4)
    80005b8a:	ffffc097          	auipc	ra,0xffffc
    80005b8e:	f80080e7          	jalr	-128(ra) # 80001b0a <copyout>
    80005b92:	01650663          	beq	a0,s6,80005b9e <piperead+0xd8>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005b96:	2985                	addiw	s3,s3,1
    80005b98:	0905                	addi	s2,s2,1
    80005b9a:	fd3a92e3          	bne	s5,s3,80005b5e <piperead+0x98>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005b9e:	21c48513          	addi	a0,s1,540
    80005ba2:	ffffd097          	auipc	ra,0xffffd
    80005ba6:	bf6080e7          	jalr	-1034(ra) # 80002798 <wakeup>
  release(&pi->lock);
    80005baa:	8526                	mv	a0,s1
    80005bac:	ffffb097          	auipc	ra,0xffffb
    80005bb0:	238080e7          	jalr	568(ra) # 80000de4 <release>
    80005bb4:	7b02                	ld	s6,32(sp)
    80005bb6:	6be2                	ld	s7,24(sp)
    80005bb8:	6c42                	ld	s8,16(sp)
  return i;
}
    80005bba:	854e                	mv	a0,s3
    80005bbc:	60e6                	ld	ra,88(sp)
    80005bbe:	6446                	ld	s0,80(sp)
    80005bc0:	64a6                	ld	s1,72(sp)
    80005bc2:	6906                	ld	s2,64(sp)
    80005bc4:	79e2                	ld	s3,56(sp)
    80005bc6:	7a42                	ld	s4,48(sp)
    80005bc8:	7aa2                	ld	s5,40(sp)
    80005bca:	6125                	addi	sp,sp,96
    80005bcc:	8082                	ret

0000000080005bce <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005bce:	1141                	addi	sp,sp,-16
    80005bd0:	e406                	sd	ra,8(sp)
    80005bd2:	e022                	sd	s0,0(sp)
    80005bd4:	0800                	addi	s0,sp,16
    80005bd6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005bd8:	0035151b          	slliw	a0,a0,0x3
    80005bdc:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80005bde:	8b89                	andi	a5,a5,2
    80005be0:	c399                	beqz	a5,80005be6 <flags2perm+0x18>
      perm |= PTE_W;
    80005be2:	00456513          	ori	a0,a0,4
    return perm;
}
    80005be6:	60a2                	ld	ra,8(sp)
    80005be8:	6402                	ld	s0,0(sp)
    80005bea:	0141                	addi	sp,sp,16
    80005bec:	8082                	ret

0000000080005bee <exec>:

int
exec(char *path, char **argv)
{
    80005bee:	de010113          	addi	sp,sp,-544
    80005bf2:	20113c23          	sd	ra,536(sp)
    80005bf6:	20813823          	sd	s0,528(sp)
    80005bfa:	20913423          	sd	s1,520(sp)
    80005bfe:	21213023          	sd	s2,512(sp)
    80005c02:	1400                	addi	s0,sp,544
    80005c04:	892a                	mv	s2,a0
    80005c06:	dea43823          	sd	a0,-528(s0)
    80005c0a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005c0e:	ffffc097          	auipc	ra,0xffffc
    80005c12:	270080e7          	jalr	624(ra) # 80001e7e <myproc>
    80005c16:	84aa                	mv	s1,a0

  begin_op();
    80005c18:	fffff097          	auipc	ra,0xfffff
    80005c1c:	38e080e7          	jalr	910(ra) # 80004fa6 <begin_op>

  if((ip = namei(path)) == 0){
    80005c20:	854a                	mv	a0,s2
    80005c22:	fffff097          	auipc	ra,0xfffff
    80005c26:	17e080e7          	jalr	382(ra) # 80004da0 <namei>
    80005c2a:	c525                	beqz	a0,80005c92 <exec+0xa4>
    80005c2c:	fbd2                	sd	s4,496(sp)
    80005c2e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005c30:	fffff097          	auipc	ra,0xfffff
    80005c34:	986080e7          	jalr	-1658(ra) # 800045b6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005c38:	04000713          	li	a4,64
    80005c3c:	4681                	li	a3,0
    80005c3e:	e5040613          	addi	a2,s0,-432
    80005c42:	4581                	li	a1,0
    80005c44:	8552                	mv	a0,s4
    80005c46:	fffff097          	auipc	ra,0xfffff
    80005c4a:	c2e080e7          	jalr	-978(ra) # 80004874 <readi>
    80005c4e:	04000793          	li	a5,64
    80005c52:	00f51a63          	bne	a0,a5,80005c66 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005c56:	e5042703          	lw	a4,-432(s0)
    80005c5a:	464c47b7          	lui	a5,0x464c4
    80005c5e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005c62:	02f70e63          	beq	a4,a5,80005c9e <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005c66:	8552                	mv	a0,s4
    80005c68:	fffff097          	auipc	ra,0xfffff
    80005c6c:	bb6080e7          	jalr	-1098(ra) # 8000481e <iunlockput>
    end_op();
    80005c70:	fffff097          	auipc	ra,0xfffff
    80005c74:	3b6080e7          	jalr	950(ra) # 80005026 <end_op>
  }
  return -1;
    80005c78:	557d                	li	a0,-1
    80005c7a:	7a5e                	ld	s4,496(sp)
}
    80005c7c:	21813083          	ld	ra,536(sp)
    80005c80:	21013403          	ld	s0,528(sp)
    80005c84:	20813483          	ld	s1,520(sp)
    80005c88:	20013903          	ld	s2,512(sp)
    80005c8c:	22010113          	addi	sp,sp,544
    80005c90:	8082                	ret
    end_op();
    80005c92:	fffff097          	auipc	ra,0xfffff
    80005c96:	394080e7          	jalr	916(ra) # 80005026 <end_op>
    return -1;
    80005c9a:	557d                	li	a0,-1
    80005c9c:	b7c5                	j	80005c7c <exec+0x8e>
    80005c9e:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005ca0:	8526                	mv	a0,s1
    80005ca2:	ffffc097          	auipc	ra,0xffffc
    80005ca6:	2a2080e7          	jalr	674(ra) # 80001f44 <proc_pagetable>
    80005caa:	8b2a                	mv	s6,a0
    80005cac:	2c050363          	beqz	a0,80005f72 <exec+0x384>
    80005cb0:	ffce                	sd	s3,504(sp)
    80005cb2:	f7d6                	sd	s5,488(sp)
    80005cb4:	efde                	sd	s7,472(sp)
    80005cb6:	ebe2                	sd	s8,464(sp)
    80005cb8:	e7e6                	sd	s9,456(sp)
    80005cba:	e3ea                	sd	s10,448(sp)
    80005cbc:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005cbe:	e8845783          	lhu	a5,-376(s0)
    80005cc2:	10078563          	beqz	a5,80005dcc <exec+0x1de>
    80005cc6:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005cca:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005ccc:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005cce:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80005cd2:	6c85                	lui	s9,0x1
    80005cd4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005cd8:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005cdc:	6a85                	lui	s5,0x1
    80005cde:	a0b5                	j	80005d4a <exec+0x15c>
      panic("loadseg: address should exist");
    80005ce0:	00006517          	auipc	a0,0x6
    80005ce4:	97850513          	addi	a0,a0,-1672 # 8000b658 <etext+0x658>
    80005ce8:	ffffb097          	auipc	ra,0xffffb
    80005cec:	876080e7          	jalr	-1930(ra) # 8000055e <panic>
    if(sz - i < PGSIZE)
    80005cf0:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005cf2:	874a                	mv	a4,s2
    80005cf4:	009b86bb          	addw	a3,s7,s1
    80005cf8:	4581                	li	a1,0
    80005cfa:	8552                	mv	a0,s4
    80005cfc:	fffff097          	auipc	ra,0xfffff
    80005d00:	b78080e7          	jalr	-1160(ra) # 80004874 <readi>
    80005d04:	26a91b63          	bne	s2,a0,80005f7a <exec+0x38c>
  for(i = 0; i < sz; i += PGSIZE){
    80005d08:	009a84bb          	addw	s1,s5,s1
    80005d0c:	0334f463          	bgeu	s1,s3,80005d34 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    80005d10:	02049593          	slli	a1,s1,0x20
    80005d14:	9181                	srli	a1,a1,0x20
    80005d16:	95e2                	add	a1,a1,s8
    80005d18:	855a                	mv	a0,s6
    80005d1a:	ffffb097          	auipc	ra,0xffffb
    80005d1e:	4cc080e7          	jalr	1228(ra) # 800011e6 <walkaddr>
    80005d22:	862a                	mv	a2,a0
    if(pa == 0)
    80005d24:	dd55                	beqz	a0,80005ce0 <exec+0xf2>
    if(sz - i < PGSIZE)
    80005d26:	409987bb          	subw	a5,s3,s1
    80005d2a:	893e                	mv	s2,a5
    80005d2c:	fcfcf2e3          	bgeu	s9,a5,80005cf0 <exec+0x102>
    80005d30:	8956                	mv	s2,s5
    80005d32:	bf7d                	j	80005cf0 <exec+0x102>
    sz = sz1;
    80005d34:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005d38:	2d05                	addiw	s10,s10,1
    80005d3a:	e0843783          	ld	a5,-504(s0)
    80005d3e:	0387869b          	addiw	a3,a5,56
    80005d42:	e8845783          	lhu	a5,-376(s0)
    80005d46:	08fd5463          	bge	s10,a5,80005dce <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005d4a:	e0d43423          	sd	a3,-504(s0)
    80005d4e:	876e                	mv	a4,s11
    80005d50:	e1840613          	addi	a2,s0,-488
    80005d54:	4581                	li	a1,0
    80005d56:	8552                	mv	a0,s4
    80005d58:	fffff097          	auipc	ra,0xfffff
    80005d5c:	b1c080e7          	jalr	-1252(ra) # 80004874 <readi>
    80005d60:	21b51b63          	bne	a0,s11,80005f76 <exec+0x388>
    if(ph.type != ELF_PROG_LOAD)
    80005d64:	e1842783          	lw	a5,-488(s0)
    80005d68:	4705                	li	a4,1
    80005d6a:	fce797e3          	bne	a5,a4,80005d38 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    80005d6e:	e4043483          	ld	s1,-448(s0)
    80005d72:	e3843783          	ld	a5,-456(s0)
    80005d76:	22f4e263          	bltu	s1,a5,80005f9a <exec+0x3ac>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005d7a:	e2843783          	ld	a5,-472(s0)
    80005d7e:	94be                	add	s1,s1,a5
    80005d80:	22f4e063          	bltu	s1,a5,80005fa0 <exec+0x3b2>
    if(ph.vaddr % PGSIZE != 0)
    80005d84:	de843703          	ld	a4,-536(s0)
    80005d88:	8ff9                	and	a5,a5,a4
    80005d8a:	20079e63          	bnez	a5,80005fa6 <exec+0x3b8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005d8e:	e1c42503          	lw	a0,-484(s0)
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	e3c080e7          	jalr	-452(ra) # 80005bce <flags2perm>
    80005d9a:	86aa                	mv	a3,a0
    80005d9c:	8626                	mv	a2,s1
    80005d9e:	85ca                	mv	a1,s2
    80005da0:	855a                	mv	a0,s6
    80005da2:	ffffc097          	auipc	ra,0xffffc
    80005da6:	816080e7          	jalr	-2026(ra) # 800015b8 <uvmalloc>
    80005daa:	dea43c23          	sd	a0,-520(s0)
    80005dae:	1e050f63          	beqz	a0,80005fac <exec+0x3be>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005db2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005db6:	00098863          	beqz	s3,80005dc6 <exec+0x1d8>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005dba:	e2843c03          	ld	s8,-472(s0)
    80005dbe:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005dc2:	4481                	li	s1,0
    80005dc4:	b7b1                	j	80005d10 <exec+0x122>
    sz = sz1;
    80005dc6:	df843903          	ld	s2,-520(s0)
    80005dca:	b7bd                	j	80005d38 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005dcc:	4901                	li	s2,0
  iunlockput(ip);
    80005dce:	8552                	mv	a0,s4
    80005dd0:	fffff097          	auipc	ra,0xfffff
    80005dd4:	a4e080e7          	jalr	-1458(ra) # 8000481e <iunlockput>
  end_op();
    80005dd8:	fffff097          	auipc	ra,0xfffff
    80005ddc:	24e080e7          	jalr	590(ra) # 80005026 <end_op>
  p = myproc();
    80005de0:	ffffc097          	auipc	ra,0xffffc
    80005de4:	09e080e7          	jalr	158(ra) # 80001e7e <myproc>
    80005de8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005dea:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005dee:	6985                	lui	s3,0x1
    80005df0:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005df2:	99ca                	add	s3,s3,s2
    80005df4:	77fd                	lui	a5,0xfffff
    80005df6:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005dfa:	4691                	li	a3,4
    80005dfc:	6609                	lui	a2,0x2
    80005dfe:	964e                	add	a2,a2,s3
    80005e00:	85ce                	mv	a1,s3
    80005e02:	855a                	mv	a0,s6
    80005e04:	ffffb097          	auipc	ra,0xffffb
    80005e08:	7b4080e7          	jalr	1972(ra) # 800015b8 <uvmalloc>
    80005e0c:	8a2a                	mv	s4,a0
    80005e0e:	e115                	bnez	a0,80005e32 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    80005e10:	85ce                	mv	a1,s3
    80005e12:	855a                	mv	a0,s6
    80005e14:	ffffc097          	auipc	ra,0xffffc
    80005e18:	1cc080e7          	jalr	460(ra) # 80001fe0 <proc_freepagetable>
  return -1;
    80005e1c:	557d                	li	a0,-1
    80005e1e:	79fe                	ld	s3,504(sp)
    80005e20:	7a5e                	ld	s4,496(sp)
    80005e22:	7abe                	ld	s5,488(sp)
    80005e24:	7b1e                	ld	s6,480(sp)
    80005e26:	6bfe                	ld	s7,472(sp)
    80005e28:	6c5e                	ld	s8,464(sp)
    80005e2a:	6cbe                	ld	s9,456(sp)
    80005e2c:	6d1e                	ld	s10,448(sp)
    80005e2e:	7dfa                	ld	s11,440(sp)
    80005e30:	b5b1                	j	80005c7c <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005e32:	75f9                	lui	a1,0xffffe
    80005e34:	95aa                	add	a1,a1,a0
    80005e36:	855a                	mv	a0,s6
    80005e38:	ffffc097          	auipc	ra,0xffffc
    80005e3c:	ca0080e7          	jalr	-864(ra) # 80001ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    80005e40:	800a0b93          	addi	s7,s4,-2048
    80005e44:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80005e48:	e0043783          	ld	a5,-512(s0)
    80005e4c:	6388                	ld	a0,0(a5)
  sp = sz;
    80005e4e:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80005e50:	4481                	li	s1,0
    ustack[argc] = sp;
    80005e52:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005e56:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005e5a:	c135                	beqz	a0,80005ebe <exec+0x2d0>
    sp -= strlen(argv[argc]) + 1;
    80005e5c:	ffffb097          	auipc	ra,0xffffb
    80005e60:	15e080e7          	jalr	350(ra) # 80000fba <strlen>
    80005e64:	0015079b          	addiw	a5,a0,1
    80005e68:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005e6c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005e70:	15796163          	bltu	s2,s7,80005fb2 <exec+0x3c4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005e74:	e0043d83          	ld	s11,-512(s0)
    80005e78:	000db983          	ld	s3,0(s11)
    80005e7c:	854e                	mv	a0,s3
    80005e7e:	ffffb097          	auipc	ra,0xffffb
    80005e82:	13c080e7          	jalr	316(ra) # 80000fba <strlen>
    80005e86:	0015069b          	addiw	a3,a0,1
    80005e8a:	864e                	mv	a2,s3
    80005e8c:	85ca                	mv	a1,s2
    80005e8e:	855a                	mv	a0,s6
    80005e90:	ffffc097          	auipc	ra,0xffffc
    80005e94:	c7a080e7          	jalr	-902(ra) # 80001b0a <copyout>
    80005e98:	10054f63          	bltz	a0,80005fb6 <exec+0x3c8>
    ustack[argc] = sp;
    80005e9c:	00349793          	slli	a5,s1,0x3
    80005ea0:	97e6                	add	a5,a5,s9
    80005ea2:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ff8b768>
  for(argc = 0; argv[argc]; argc++) {
    80005ea6:	0485                	addi	s1,s1,1
    80005ea8:	008d8793          	addi	a5,s11,8
    80005eac:	e0f43023          	sd	a5,-512(s0)
    80005eb0:	008db503          	ld	a0,8(s11)
    80005eb4:	c509                	beqz	a0,80005ebe <exec+0x2d0>
    if(argc >= MAXARG)
    80005eb6:	fb8493e3          	bne	s1,s8,80005e5c <exec+0x26e>
  sz = sz1;
    80005eba:	89d2                	mv	s3,s4
    80005ebc:	bf91                	j	80005e10 <exec+0x222>
  ustack[argc] = 0;
    80005ebe:	00349793          	slli	a5,s1,0x3
    80005ec2:	f9078793          	addi	a5,a5,-112
    80005ec6:	97a2                	add	a5,a5,s0
    80005ec8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005ecc:	00349693          	slli	a3,s1,0x3
    80005ed0:	06a1                	addi	a3,a3,8
    80005ed2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005ed6:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005eda:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005edc:	f3796ae3          	bltu	s2,s7,80005e10 <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005ee0:	e9040613          	addi	a2,s0,-368
    80005ee4:	85ca                	mv	a1,s2
    80005ee6:	855a                	mv	a0,s6
    80005ee8:	ffffc097          	auipc	ra,0xffffc
    80005eec:	c22080e7          	jalr	-990(ra) # 80001b0a <copyout>
    80005ef0:	f20540e3          	bltz	a0,80005e10 <exec+0x222>
  p->trapframe->a1 = sp;
    80005ef4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005ef8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005efc:	df043783          	ld	a5,-528(s0)
    80005f00:	0007c703          	lbu	a4,0(a5)
    80005f04:	cf11                	beqz	a4,80005f20 <exec+0x332>
    80005f06:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005f08:	02f00693          	li	a3,47
    80005f0c:	a029                	j	80005f16 <exec+0x328>
  for(last=s=path; *s; s++)
    80005f0e:	0785                	addi	a5,a5,1
    80005f10:	fff7c703          	lbu	a4,-1(a5)
    80005f14:	c711                	beqz	a4,80005f20 <exec+0x332>
    if(*s == '/')
    80005f16:	fed71ce3          	bne	a4,a3,80005f0e <exec+0x320>
      last = s+1;
    80005f1a:	def43823          	sd	a5,-528(s0)
    80005f1e:	bfc5                	j	80005f0e <exec+0x320>
  safestrcpy(p->name, last, sizeof(p->name));
    80005f20:	4641                	li	a2,16
    80005f22:	df043583          	ld	a1,-528(s0)
    80005f26:	158a8513          	addi	a0,s5,344
    80005f2a:	ffffb097          	auipc	ra,0xffffb
    80005f2e:	05a080e7          	jalr	90(ra) # 80000f84 <safestrcpy>
  oldpagetable = p->pagetable;
    80005f32:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005f36:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005f3a:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005f3e:	058ab783          	ld	a5,88(s5)
    80005f42:	e6843703          	ld	a4,-408(s0)
    80005f46:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005f48:	058ab783          	ld	a5,88(s5)
    80005f4c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005f50:	85ea                	mv	a1,s10
    80005f52:	ffffc097          	auipc	ra,0xffffc
    80005f56:	08e080e7          	jalr	142(ra) # 80001fe0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005f5a:	0004851b          	sext.w	a0,s1
    80005f5e:	79fe                	ld	s3,504(sp)
    80005f60:	7a5e                	ld	s4,496(sp)
    80005f62:	7abe                	ld	s5,488(sp)
    80005f64:	7b1e                	ld	s6,480(sp)
    80005f66:	6bfe                	ld	s7,472(sp)
    80005f68:	6c5e                	ld	s8,464(sp)
    80005f6a:	6cbe                	ld	s9,456(sp)
    80005f6c:	6d1e                	ld	s10,448(sp)
    80005f6e:	7dfa                	ld	s11,440(sp)
    80005f70:	b331                	j	80005c7c <exec+0x8e>
    80005f72:	7b1e                	ld	s6,480(sp)
    80005f74:	b9cd                	j	80005c66 <exec+0x78>
    80005f76:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005f7a:	df843583          	ld	a1,-520(s0)
    80005f7e:	855a                	mv	a0,s6
    80005f80:	ffffc097          	auipc	ra,0xffffc
    80005f84:	060080e7          	jalr	96(ra) # 80001fe0 <proc_freepagetable>
  if(ip){
    80005f88:	79fe                	ld	s3,504(sp)
    80005f8a:	7abe                	ld	s5,488(sp)
    80005f8c:	7b1e                	ld	s6,480(sp)
    80005f8e:	6bfe                	ld	s7,472(sp)
    80005f90:	6c5e                	ld	s8,464(sp)
    80005f92:	6cbe                	ld	s9,456(sp)
    80005f94:	6d1e                	ld	s10,448(sp)
    80005f96:	7dfa                	ld	s11,440(sp)
    80005f98:	b1f9                	j	80005c66 <exec+0x78>
    80005f9a:	df243c23          	sd	s2,-520(s0)
    80005f9e:	bff1                	j	80005f7a <exec+0x38c>
    80005fa0:	df243c23          	sd	s2,-520(s0)
    80005fa4:	bfd9                	j	80005f7a <exec+0x38c>
    80005fa6:	df243c23          	sd	s2,-520(s0)
    80005faa:	bfc1                	j	80005f7a <exec+0x38c>
    80005fac:	df243c23          	sd	s2,-520(s0)
    80005fb0:	b7e9                	j	80005f7a <exec+0x38c>
  sz = sz1;
    80005fb2:	89d2                	mv	s3,s4
    80005fb4:	bdb1                	j	80005e10 <exec+0x222>
    80005fb6:	89d2                	mv	s3,s4
    80005fb8:	bda1                	j	80005e10 <exec+0x222>

0000000080005fba <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005fba:	7179                	addi	sp,sp,-48
    80005fbc:	f406                	sd	ra,40(sp)
    80005fbe:	f022                	sd	s0,32(sp)
    80005fc0:	ec26                	sd	s1,24(sp)
    80005fc2:	e84a                	sd	s2,16(sp)
    80005fc4:	1800                	addi	s0,sp,48
    80005fc6:	892e                	mv	s2,a1
    80005fc8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005fca:	fdc40593          	addi	a1,s0,-36
    80005fce:	ffffd097          	auipc	ra,0xffffd
    80005fd2:	4dc080e7          	jalr	1244(ra) # 800034aa <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005fd6:	fdc42703          	lw	a4,-36(s0)
    80005fda:	47bd                	li	a5,15
    80005fdc:	02e7ec63          	bltu	a5,a4,80006014 <argfd+0x5a>
    80005fe0:	ffffc097          	auipc	ra,0xffffc
    80005fe4:	e9e080e7          	jalr	-354(ra) # 80001e7e <myproc>
    80005fe8:	fdc42703          	lw	a4,-36(s0)
    80005fec:	00371793          	slli	a5,a4,0x3
    80005ff0:	0d078793          	addi	a5,a5,208
    80005ff4:	953e                	add	a0,a0,a5
    80005ff6:	611c                	ld	a5,0(a0)
    80005ff8:	c385                	beqz	a5,80006018 <argfd+0x5e>
    return -1;
  if(pfd)
    80005ffa:	00090463          	beqz	s2,80006002 <argfd+0x48>
    *pfd = fd;
    80005ffe:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80006002:	4501                	li	a0,0
  if(pf)
    80006004:	c091                	beqz	s1,80006008 <argfd+0x4e>
    *pf = f;
    80006006:	e09c                	sd	a5,0(s1)
}
    80006008:	70a2                	ld	ra,40(sp)
    8000600a:	7402                	ld	s0,32(sp)
    8000600c:	64e2                	ld	s1,24(sp)
    8000600e:	6942                	ld	s2,16(sp)
    80006010:	6145                	addi	sp,sp,48
    80006012:	8082                	ret
    return -1;
    80006014:	557d                	li	a0,-1
    80006016:	bfcd                	j	80006008 <argfd+0x4e>
    80006018:	557d                	li	a0,-1
    8000601a:	b7fd                	j	80006008 <argfd+0x4e>

000000008000601c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000601c:	715d                	addi	sp,sp,-80
    8000601e:	e486                	sd	ra,72(sp)
    80006020:	e0a2                	sd	s0,64(sp)
    80006022:	fc26                	sd	s1,56(sp)
    80006024:	f84a                	sd	s2,48(sp)
    80006026:	f44e                	sd	s3,40(sp)
    80006028:	f052                	sd	s4,32(sp)
    8000602a:	ec56                	sd	s5,24(sp)
    8000602c:	e85a                	sd	s6,16(sp)
    8000602e:	0880                	addi	s0,sp,80
    80006030:	892e                	mv	s2,a1
    80006032:	8a2e                	mv	s4,a1
    80006034:	8ab2                	mv	s5,a2
    80006036:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80006038:	fb040593          	addi	a1,s0,-80
    8000603c:	fffff097          	auipc	ra,0xfffff
    80006040:	d82080e7          	jalr	-638(ra) # 80004dbe <nameiparent>
    80006044:	84aa                	mv	s1,a0
    80006046:	14050b63          	beqz	a0,8000619c <create+0x180>
    return 0;

  ilock(dp);
    8000604a:	ffffe097          	auipc	ra,0xffffe
    8000604e:	56c080e7          	jalr	1388(ra) # 800045b6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80006052:	4601                	li	a2,0
    80006054:	fb040593          	addi	a1,s0,-80
    80006058:	8526                	mv	a0,s1
    8000605a:	fffff097          	auipc	ra,0xfffff
    8000605e:	a56080e7          	jalr	-1450(ra) # 80004ab0 <dirlookup>
    80006062:	89aa                	mv	s3,a0
    80006064:	c921                	beqz	a0,800060b4 <create+0x98>
    iunlockput(dp);
    80006066:	8526                	mv	a0,s1
    80006068:	ffffe097          	auipc	ra,0xffffe
    8000606c:	7b6080e7          	jalr	1974(ra) # 8000481e <iunlockput>
    ilock(ip);
    80006070:	854e                	mv	a0,s3
    80006072:	ffffe097          	auipc	ra,0xffffe
    80006076:	544080e7          	jalr	1348(ra) # 800045b6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000607a:	4789                	li	a5,2
    8000607c:	02f91563          	bne	s2,a5,800060a6 <create+0x8a>
    80006080:	0449d783          	lhu	a5,68(s3)
    80006084:	37f9                	addiw	a5,a5,-2
    80006086:	17c2                	slli	a5,a5,0x30
    80006088:	93c1                	srli	a5,a5,0x30
    8000608a:	4705                	li	a4,1
    8000608c:	00f76d63          	bltu	a4,a5,800060a6 <create+0x8a>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80006090:	854e                	mv	a0,s3
    80006092:	60a6                	ld	ra,72(sp)
    80006094:	6406                	ld	s0,64(sp)
    80006096:	74e2                	ld	s1,56(sp)
    80006098:	7942                	ld	s2,48(sp)
    8000609a:	79a2                	ld	s3,40(sp)
    8000609c:	7a02                	ld	s4,32(sp)
    8000609e:	6ae2                	ld	s5,24(sp)
    800060a0:	6b42                	ld	s6,16(sp)
    800060a2:	6161                	addi	sp,sp,80
    800060a4:	8082                	ret
    iunlockput(ip);
    800060a6:	854e                	mv	a0,s3
    800060a8:	ffffe097          	auipc	ra,0xffffe
    800060ac:	776080e7          	jalr	1910(ra) # 8000481e <iunlockput>
    return 0;
    800060b0:	4981                	li	s3,0
    800060b2:	bff9                	j	80006090 <create+0x74>
  if((ip = ialloc(dp->dev, type)) == 0){
    800060b4:	85ca                	mv	a1,s2
    800060b6:	4088                	lw	a0,0(s1)
    800060b8:	ffffe097          	auipc	ra,0xffffe
    800060bc:	35a080e7          	jalr	858(ra) # 80004412 <ialloc>
    800060c0:	892a                	mv	s2,a0
    800060c2:	c531                	beqz	a0,8000610e <create+0xf2>
  ilock(ip);
    800060c4:	ffffe097          	auipc	ra,0xffffe
    800060c8:	4f2080e7          	jalr	1266(ra) # 800045b6 <ilock>
  ip->major = major;
    800060cc:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    800060d0:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    800060d4:	4785                	li	a5,1
    800060d6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800060da:	854a                	mv	a0,s2
    800060dc:	ffffe097          	auipc	ra,0xffffe
    800060e0:	40e080e7          	jalr	1038(ra) # 800044ea <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800060e4:	4705                	li	a4,1
    800060e6:	02ea0a63          	beq	s4,a4,8000611a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800060ea:	00492603          	lw	a2,4(s2)
    800060ee:	fb040593          	addi	a1,s0,-80
    800060f2:	8526                	mv	a0,s1
    800060f4:	fffff097          	auipc	ra,0xfffff
    800060f8:	bea080e7          	jalr	-1046(ra) # 80004cde <dirlink>
    800060fc:	06054e63          	bltz	a0,80006178 <create+0x15c>
  iunlockput(dp);
    80006100:	8526                	mv	a0,s1
    80006102:	ffffe097          	auipc	ra,0xffffe
    80006106:	71c080e7          	jalr	1820(ra) # 8000481e <iunlockput>
  return ip;
    8000610a:	89ca                	mv	s3,s2
    8000610c:	b751                	j	80006090 <create+0x74>
    iunlockput(dp);
    8000610e:	8526                	mv	a0,s1
    80006110:	ffffe097          	auipc	ra,0xffffe
    80006114:	70e080e7          	jalr	1806(ra) # 8000481e <iunlockput>
    return 0;
    80006118:	bfa5                	j	80006090 <create+0x74>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000611a:	00492603          	lw	a2,4(s2)
    8000611e:	00005597          	auipc	a1,0x5
    80006122:	55a58593          	addi	a1,a1,1370 # 8000b678 <etext+0x678>
    80006126:	854a                	mv	a0,s2
    80006128:	fffff097          	auipc	ra,0xfffff
    8000612c:	bb6080e7          	jalr	-1098(ra) # 80004cde <dirlink>
    80006130:	04054463          	bltz	a0,80006178 <create+0x15c>
    80006134:	40d0                	lw	a2,4(s1)
    80006136:	00005597          	auipc	a1,0x5
    8000613a:	54a58593          	addi	a1,a1,1354 # 8000b680 <etext+0x680>
    8000613e:	854a                	mv	a0,s2
    80006140:	fffff097          	auipc	ra,0xfffff
    80006144:	b9e080e7          	jalr	-1122(ra) # 80004cde <dirlink>
    80006148:	02054863          	bltz	a0,80006178 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000614c:	00492603          	lw	a2,4(s2)
    80006150:	fb040593          	addi	a1,s0,-80
    80006154:	8526                	mv	a0,s1
    80006156:	fffff097          	auipc	ra,0xfffff
    8000615a:	b88080e7          	jalr	-1144(ra) # 80004cde <dirlink>
    8000615e:	00054d63          	bltz	a0,80006178 <create+0x15c>
    dp->nlink++;  // for ".."
    80006162:	04a4d783          	lhu	a5,74(s1)
    80006166:	2785                	addiw	a5,a5,1
    80006168:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000616c:	8526                	mv	a0,s1
    8000616e:	ffffe097          	auipc	ra,0xffffe
    80006172:	37c080e7          	jalr	892(ra) # 800044ea <iupdate>
    80006176:	b769                	j	80006100 <create+0xe4>
  ip->nlink = 0;
    80006178:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    8000617c:	854a                	mv	a0,s2
    8000617e:	ffffe097          	auipc	ra,0xffffe
    80006182:	36c080e7          	jalr	876(ra) # 800044ea <iupdate>
  iunlockput(ip);
    80006186:	854a                	mv	a0,s2
    80006188:	ffffe097          	auipc	ra,0xffffe
    8000618c:	696080e7          	jalr	1686(ra) # 8000481e <iunlockput>
  iunlockput(dp);
    80006190:	8526                	mv	a0,s1
    80006192:	ffffe097          	auipc	ra,0xffffe
    80006196:	68c080e7          	jalr	1676(ra) # 8000481e <iunlockput>
  return 0;
    8000619a:	bddd                	j	80006090 <create+0x74>
    return 0;
    8000619c:	89aa                	mv	s3,a0
    8000619e:	bdcd                	j	80006090 <create+0x74>

00000000800061a0 <fdalloc>:
{
    800061a0:	1101                	addi	sp,sp,-32
    800061a2:	ec06                	sd	ra,24(sp)
    800061a4:	e822                	sd	s0,16(sp)
    800061a6:	e426                	sd	s1,8(sp)
    800061a8:	1000                	addi	s0,sp,32
    800061aa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800061ac:	ffffc097          	auipc	ra,0xffffc
    800061b0:	cd2080e7          	jalr	-814(ra) # 80001e7e <myproc>
    800061b4:	862a                	mv	a2,a0
  for(fd = 0; fd < NOFILE; fd++){
    800061b6:	0d050793          	addi	a5,a0,208
    800061ba:	4501                	li	a0,0
    800061bc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800061be:	6398                	ld	a4,0(a5)
    800061c0:	cb19                	beqz	a4,800061d6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800061c2:	2505                	addiw	a0,a0,1
    800061c4:	07a1                	addi	a5,a5,8
    800061c6:	fed51ce3          	bne	a0,a3,800061be <fdalloc+0x1e>
  return -1;
    800061ca:	557d                	li	a0,-1
}
    800061cc:	60e2                	ld	ra,24(sp)
    800061ce:	6442                	ld	s0,16(sp)
    800061d0:	64a2                	ld	s1,8(sp)
    800061d2:	6105                	addi	sp,sp,32
    800061d4:	8082                	ret
      p->ofile[fd] = f;
    800061d6:	00351793          	slli	a5,a0,0x3
    800061da:	0d078793          	addi	a5,a5,208
    800061de:	963e                	add	a2,a2,a5
    800061e0:	e204                	sd	s1,0(a2)
      return fd;
    800061e2:	b7ed                	j	800061cc <fdalloc+0x2c>

00000000800061e4 <sys_dup>:
{
    800061e4:	7179                	addi	sp,sp,-48
    800061e6:	f406                	sd	ra,40(sp)
    800061e8:	f022                	sd	s0,32(sp)
    800061ea:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800061ec:	fd840613          	addi	a2,s0,-40
    800061f0:	4581                	li	a1,0
    800061f2:	4501                	li	a0,0
    800061f4:	00000097          	auipc	ra,0x0
    800061f8:	dc6080e7          	jalr	-570(ra) # 80005fba <argfd>
    return -1;
    800061fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800061fe:	02054763          	bltz	a0,8000622c <sys_dup+0x48>
    80006202:	ec26                	sd	s1,24(sp)
    80006204:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80006206:	fd843483          	ld	s1,-40(s0)
    8000620a:	8526                	mv	a0,s1
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	f94080e7          	jalr	-108(ra) # 800061a0 <fdalloc>
    80006214:	892a                	mv	s2,a0
    return -1;
    80006216:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80006218:	00054f63          	bltz	a0,80006236 <sys_dup+0x52>
  filedup(f);
    8000621c:	8526                	mv	a0,s1
    8000621e:	fffff097          	auipc	ra,0xfffff
    80006222:	218080e7          	jalr	536(ra) # 80005436 <filedup>
  return fd;
    80006226:	87ca                	mv	a5,s2
    80006228:	64e2                	ld	s1,24(sp)
    8000622a:	6942                	ld	s2,16(sp)
}
    8000622c:	853e                	mv	a0,a5
    8000622e:	70a2                	ld	ra,40(sp)
    80006230:	7402                	ld	s0,32(sp)
    80006232:	6145                	addi	sp,sp,48
    80006234:	8082                	ret
    80006236:	64e2                	ld	s1,24(sp)
    80006238:	6942                	ld	s2,16(sp)
    8000623a:	bfcd                	j	8000622c <sys_dup+0x48>

000000008000623c <sys_read>:
{
    8000623c:	7179                	addi	sp,sp,-48
    8000623e:	f406                	sd	ra,40(sp)
    80006240:	f022                	sd	s0,32(sp)
    80006242:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80006244:	fd840593          	addi	a1,s0,-40
    80006248:	4505                	li	a0,1
    8000624a:	ffffd097          	auipc	ra,0xffffd
    8000624e:	280080e7          	jalr	640(ra) # 800034ca <argaddr>
  argint(2, &n);
    80006252:	fe440593          	addi	a1,s0,-28
    80006256:	4509                	li	a0,2
    80006258:	ffffd097          	auipc	ra,0xffffd
    8000625c:	252080e7          	jalr	594(ra) # 800034aa <argint>
  if(argfd(0, 0, &f) < 0)
    80006260:	fe840613          	addi	a2,s0,-24
    80006264:	4581                	li	a1,0
    80006266:	4501                	li	a0,0
    80006268:	00000097          	auipc	ra,0x0
    8000626c:	d52080e7          	jalr	-686(ra) # 80005fba <argfd>
    80006270:	87aa                	mv	a5,a0
    return -1;
    80006272:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006274:	0007cc63          	bltz	a5,8000628c <sys_read+0x50>
  return fileread(f, p, n);
    80006278:	fe442603          	lw	a2,-28(s0)
    8000627c:	fd843583          	ld	a1,-40(s0)
    80006280:	fe843503          	ld	a0,-24(s0)
    80006284:	fffff097          	auipc	ra,0xfffff
    80006288:	3a8080e7          	jalr	936(ra) # 8000562c <fileread>
}
    8000628c:	70a2                	ld	ra,40(sp)
    8000628e:	7402                	ld	s0,32(sp)
    80006290:	6145                	addi	sp,sp,48
    80006292:	8082                	ret

0000000080006294 <sys_write>:
{
    80006294:	7179                	addi	sp,sp,-48
    80006296:	f406                	sd	ra,40(sp)
    80006298:	f022                	sd	s0,32(sp)
    8000629a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000629c:	fd840593          	addi	a1,s0,-40
    800062a0:	4505                	li	a0,1
    800062a2:	ffffd097          	auipc	ra,0xffffd
    800062a6:	228080e7          	jalr	552(ra) # 800034ca <argaddr>
  argint(2, &n);
    800062aa:	fe440593          	addi	a1,s0,-28
    800062ae:	4509                	li	a0,2
    800062b0:	ffffd097          	auipc	ra,0xffffd
    800062b4:	1fa080e7          	jalr	506(ra) # 800034aa <argint>
  if(argfd(0, 0, &f) < 0)
    800062b8:	fe840613          	addi	a2,s0,-24
    800062bc:	4581                	li	a1,0
    800062be:	4501                	li	a0,0
    800062c0:	00000097          	auipc	ra,0x0
    800062c4:	cfa080e7          	jalr	-774(ra) # 80005fba <argfd>
    800062c8:	87aa                	mv	a5,a0
    return -1;
    800062ca:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800062cc:	0007cc63          	bltz	a5,800062e4 <sys_write+0x50>
  return filewrite(f, p, n);
    800062d0:	fe442603          	lw	a2,-28(s0)
    800062d4:	fd843583          	ld	a1,-40(s0)
    800062d8:	fe843503          	ld	a0,-24(s0)
    800062dc:	fffff097          	auipc	ra,0xfffff
    800062e0:	428080e7          	jalr	1064(ra) # 80005704 <filewrite>
}
    800062e4:	70a2                	ld	ra,40(sp)
    800062e6:	7402                	ld	s0,32(sp)
    800062e8:	6145                	addi	sp,sp,48
    800062ea:	8082                	ret

00000000800062ec <sys_close>:
{
    800062ec:	1101                	addi	sp,sp,-32
    800062ee:	ec06                	sd	ra,24(sp)
    800062f0:	e822                	sd	s0,16(sp)
    800062f2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800062f4:	fe040613          	addi	a2,s0,-32
    800062f8:	fec40593          	addi	a1,s0,-20
    800062fc:	4501                	li	a0,0
    800062fe:	00000097          	auipc	ra,0x0
    80006302:	cbc080e7          	jalr	-836(ra) # 80005fba <argfd>
    return -1;
    80006306:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80006308:	02054563          	bltz	a0,80006332 <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    8000630c:	ffffc097          	auipc	ra,0xffffc
    80006310:	b72080e7          	jalr	-1166(ra) # 80001e7e <myproc>
    80006314:	fec42783          	lw	a5,-20(s0)
    80006318:	078e                	slli	a5,a5,0x3
    8000631a:	0d078793          	addi	a5,a5,208
    8000631e:	953e                	add	a0,a0,a5
    80006320:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80006324:	fe043503          	ld	a0,-32(s0)
    80006328:	fffff097          	auipc	ra,0xfffff
    8000632c:	160080e7          	jalr	352(ra) # 80005488 <fileclose>
  return 0;
    80006330:	4781                	li	a5,0
}
    80006332:	853e                	mv	a0,a5
    80006334:	60e2                	ld	ra,24(sp)
    80006336:	6442                	ld	s0,16(sp)
    80006338:	6105                	addi	sp,sp,32
    8000633a:	8082                	ret

000000008000633c <sys_fstat>:
{
    8000633c:	1101                	addi	sp,sp,-32
    8000633e:	ec06                	sd	ra,24(sp)
    80006340:	e822                	sd	s0,16(sp)
    80006342:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80006344:	fe040593          	addi	a1,s0,-32
    80006348:	4505                	li	a0,1
    8000634a:	ffffd097          	auipc	ra,0xffffd
    8000634e:	180080e7          	jalr	384(ra) # 800034ca <argaddr>
  if(argfd(0, 0, &f) < 0)
    80006352:	fe840613          	addi	a2,s0,-24
    80006356:	4581                	li	a1,0
    80006358:	4501                	li	a0,0
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	c60080e7          	jalr	-928(ra) # 80005fba <argfd>
    80006362:	87aa                	mv	a5,a0
    return -1;
    80006364:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006366:	0007ca63          	bltz	a5,8000637a <sys_fstat+0x3e>
  return filestat(f, st);
    8000636a:	fe043583          	ld	a1,-32(s0)
    8000636e:	fe843503          	ld	a0,-24(s0)
    80006372:	fffff097          	auipc	ra,0xfffff
    80006376:	244080e7          	jalr	580(ra) # 800055b6 <filestat>
}
    8000637a:	60e2                	ld	ra,24(sp)
    8000637c:	6442                	ld	s0,16(sp)
    8000637e:	6105                	addi	sp,sp,32
    80006380:	8082                	ret

0000000080006382 <sys_link>:
{
    80006382:	7169                	addi	sp,sp,-304
    80006384:	f606                	sd	ra,296(sp)
    80006386:	f222                	sd	s0,288(sp)
    80006388:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000638a:	08000613          	li	a2,128
    8000638e:	ed040593          	addi	a1,s0,-304
    80006392:	4501                	li	a0,0
    80006394:	ffffd097          	auipc	ra,0xffffd
    80006398:	156080e7          	jalr	342(ra) # 800034ea <argstr>
    return -1;
    8000639c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000639e:	12054663          	bltz	a0,800064ca <sys_link+0x148>
    800063a2:	08000613          	li	a2,128
    800063a6:	f5040593          	addi	a1,s0,-176
    800063aa:	4505                	li	a0,1
    800063ac:	ffffd097          	auipc	ra,0xffffd
    800063b0:	13e080e7          	jalr	318(ra) # 800034ea <argstr>
    return -1;
    800063b4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800063b6:	10054a63          	bltz	a0,800064ca <sys_link+0x148>
    800063ba:	ee26                	sd	s1,280(sp)
  begin_op();
    800063bc:	fffff097          	auipc	ra,0xfffff
    800063c0:	bea080e7          	jalr	-1046(ra) # 80004fa6 <begin_op>
  if((ip = namei(old)) == 0){
    800063c4:	ed040513          	addi	a0,s0,-304
    800063c8:	fffff097          	auipc	ra,0xfffff
    800063cc:	9d8080e7          	jalr	-1576(ra) # 80004da0 <namei>
    800063d0:	84aa                	mv	s1,a0
    800063d2:	c949                	beqz	a0,80006464 <sys_link+0xe2>
  ilock(ip);
    800063d4:	ffffe097          	auipc	ra,0xffffe
    800063d8:	1e2080e7          	jalr	482(ra) # 800045b6 <ilock>
  if(ip->type == T_DIR){
    800063dc:	04449703          	lh	a4,68(s1)
    800063e0:	4785                	li	a5,1
    800063e2:	08f70863          	beq	a4,a5,80006472 <sys_link+0xf0>
    800063e6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800063e8:	04a4d783          	lhu	a5,74(s1)
    800063ec:	2785                	addiw	a5,a5,1
    800063ee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800063f2:	8526                	mv	a0,s1
    800063f4:	ffffe097          	auipc	ra,0xffffe
    800063f8:	0f6080e7          	jalr	246(ra) # 800044ea <iupdate>
  iunlock(ip);
    800063fc:	8526                	mv	a0,s1
    800063fe:	ffffe097          	auipc	ra,0xffffe
    80006402:	27e080e7          	jalr	638(ra) # 8000467c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80006406:	fd040593          	addi	a1,s0,-48
    8000640a:	f5040513          	addi	a0,s0,-176
    8000640e:	fffff097          	auipc	ra,0xfffff
    80006412:	9b0080e7          	jalr	-1616(ra) # 80004dbe <nameiparent>
    80006416:	892a                	mv	s2,a0
    80006418:	cd35                	beqz	a0,80006494 <sys_link+0x112>
  ilock(dp);
    8000641a:	ffffe097          	auipc	ra,0xffffe
    8000641e:	19c080e7          	jalr	412(ra) # 800045b6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80006422:	854a                	mv	a0,s2
    80006424:	00092703          	lw	a4,0(s2)
    80006428:	409c                	lw	a5,0(s1)
    8000642a:	06f71063          	bne	a4,a5,8000648a <sys_link+0x108>
    8000642e:	40d0                	lw	a2,4(s1)
    80006430:	fd040593          	addi	a1,s0,-48
    80006434:	fffff097          	auipc	ra,0xfffff
    80006438:	8aa080e7          	jalr	-1878(ra) # 80004cde <dirlink>
    8000643c:	04054763          	bltz	a0,8000648a <sys_link+0x108>
  iunlockput(dp);
    80006440:	854a                	mv	a0,s2
    80006442:	ffffe097          	auipc	ra,0xffffe
    80006446:	3dc080e7          	jalr	988(ra) # 8000481e <iunlockput>
  iput(ip);
    8000644a:	8526                	mv	a0,s1
    8000644c:	ffffe097          	auipc	ra,0xffffe
    80006450:	328080e7          	jalr	808(ra) # 80004774 <iput>
  end_op();
    80006454:	fffff097          	auipc	ra,0xfffff
    80006458:	bd2080e7          	jalr	-1070(ra) # 80005026 <end_op>
  return 0;
    8000645c:	4781                	li	a5,0
    8000645e:	64f2                	ld	s1,280(sp)
    80006460:	6952                	ld	s2,272(sp)
    80006462:	a0a5                	j	800064ca <sys_link+0x148>
    end_op();
    80006464:	fffff097          	auipc	ra,0xfffff
    80006468:	bc2080e7          	jalr	-1086(ra) # 80005026 <end_op>
    return -1;
    8000646c:	57fd                	li	a5,-1
    8000646e:	64f2                	ld	s1,280(sp)
    80006470:	a8a9                	j	800064ca <sys_link+0x148>
    iunlockput(ip);
    80006472:	8526                	mv	a0,s1
    80006474:	ffffe097          	auipc	ra,0xffffe
    80006478:	3aa080e7          	jalr	938(ra) # 8000481e <iunlockput>
    end_op();
    8000647c:	fffff097          	auipc	ra,0xfffff
    80006480:	baa080e7          	jalr	-1110(ra) # 80005026 <end_op>
    return -1;
    80006484:	57fd                	li	a5,-1
    80006486:	64f2                	ld	s1,280(sp)
    80006488:	a089                	j	800064ca <sys_link+0x148>
    iunlockput(dp);
    8000648a:	854a                	mv	a0,s2
    8000648c:	ffffe097          	auipc	ra,0xffffe
    80006490:	392080e7          	jalr	914(ra) # 8000481e <iunlockput>
  ilock(ip);
    80006494:	8526                	mv	a0,s1
    80006496:	ffffe097          	auipc	ra,0xffffe
    8000649a:	120080e7          	jalr	288(ra) # 800045b6 <ilock>
  ip->nlink--;
    8000649e:	04a4d783          	lhu	a5,74(s1)
    800064a2:	37fd                	addiw	a5,a5,-1
    800064a4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800064a8:	8526                	mv	a0,s1
    800064aa:	ffffe097          	auipc	ra,0xffffe
    800064ae:	040080e7          	jalr	64(ra) # 800044ea <iupdate>
  iunlockput(ip);
    800064b2:	8526                	mv	a0,s1
    800064b4:	ffffe097          	auipc	ra,0xffffe
    800064b8:	36a080e7          	jalr	874(ra) # 8000481e <iunlockput>
  end_op();
    800064bc:	fffff097          	auipc	ra,0xfffff
    800064c0:	b6a080e7          	jalr	-1174(ra) # 80005026 <end_op>
  return -1;
    800064c4:	57fd                	li	a5,-1
    800064c6:	64f2                	ld	s1,280(sp)
    800064c8:	6952                	ld	s2,272(sp)
}
    800064ca:	853e                	mv	a0,a5
    800064cc:	70b2                	ld	ra,296(sp)
    800064ce:	7412                	ld	s0,288(sp)
    800064d0:	6155                	addi	sp,sp,304
    800064d2:	8082                	ret

00000000800064d4 <sys_unlink>:
{
    800064d4:	7151                	addi	sp,sp,-240
    800064d6:	f586                	sd	ra,232(sp)
    800064d8:	f1a2                	sd	s0,224(sp)
    800064da:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800064dc:	08000613          	li	a2,128
    800064e0:	f3040593          	addi	a1,s0,-208
    800064e4:	4501                	li	a0,0
    800064e6:	ffffd097          	auipc	ra,0xffffd
    800064ea:	004080e7          	jalr	4(ra) # 800034ea <argstr>
    800064ee:	1a054763          	bltz	a0,8000669c <sys_unlink+0x1c8>
    800064f2:	eda6                	sd	s1,216(sp)
  begin_op();
    800064f4:	fffff097          	auipc	ra,0xfffff
    800064f8:	ab2080e7          	jalr	-1358(ra) # 80004fa6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800064fc:	fb040593          	addi	a1,s0,-80
    80006500:	f3040513          	addi	a0,s0,-208
    80006504:	fffff097          	auipc	ra,0xfffff
    80006508:	8ba080e7          	jalr	-1862(ra) # 80004dbe <nameiparent>
    8000650c:	84aa                	mv	s1,a0
    8000650e:	c165                	beqz	a0,800065ee <sys_unlink+0x11a>
  ilock(dp);
    80006510:	ffffe097          	auipc	ra,0xffffe
    80006514:	0a6080e7          	jalr	166(ra) # 800045b6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006518:	00005597          	auipc	a1,0x5
    8000651c:	16058593          	addi	a1,a1,352 # 8000b678 <etext+0x678>
    80006520:	fb040513          	addi	a0,s0,-80
    80006524:	ffffe097          	auipc	ra,0xffffe
    80006528:	572080e7          	jalr	1394(ra) # 80004a96 <namecmp>
    8000652c:	14050963          	beqz	a0,8000667e <sys_unlink+0x1aa>
    80006530:	00005597          	auipc	a1,0x5
    80006534:	15058593          	addi	a1,a1,336 # 8000b680 <etext+0x680>
    80006538:	fb040513          	addi	a0,s0,-80
    8000653c:	ffffe097          	auipc	ra,0xffffe
    80006540:	55a080e7          	jalr	1370(ra) # 80004a96 <namecmp>
    80006544:	12050d63          	beqz	a0,8000667e <sys_unlink+0x1aa>
    80006548:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000654a:	f2c40613          	addi	a2,s0,-212
    8000654e:	fb040593          	addi	a1,s0,-80
    80006552:	8526                	mv	a0,s1
    80006554:	ffffe097          	auipc	ra,0xffffe
    80006558:	55c080e7          	jalr	1372(ra) # 80004ab0 <dirlookup>
    8000655c:	892a                	mv	s2,a0
    8000655e:	10050f63          	beqz	a0,8000667c <sys_unlink+0x1a8>
    80006562:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80006564:	ffffe097          	auipc	ra,0xffffe
    80006568:	052080e7          	jalr	82(ra) # 800045b6 <ilock>
  if(ip->nlink < 1)
    8000656c:	04a91783          	lh	a5,74(s2)
    80006570:	08f05663          	blez	a5,800065fc <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80006574:	04491703          	lh	a4,68(s2)
    80006578:	4785                	li	a5,1
    8000657a:	08f70963          	beq	a4,a5,8000660c <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
    8000657e:	fc040993          	addi	s3,s0,-64
    80006582:	4641                	li	a2,16
    80006584:	4581                	li	a1,0
    80006586:	854e                	mv	a0,s3
    80006588:	ffffb097          	auipc	ra,0xffffb
    8000658c:	8a4080e7          	jalr	-1884(ra) # 80000e2c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006590:	4741                	li	a4,16
    80006592:	f2c42683          	lw	a3,-212(s0)
    80006596:	864e                	mv	a2,s3
    80006598:	4581                	li	a1,0
    8000659a:	8526                	mv	a0,s1
    8000659c:	ffffe097          	auipc	ra,0xffffe
    800065a0:	3de080e7          	jalr	990(ra) # 8000497a <writei>
    800065a4:	47c1                	li	a5,16
    800065a6:	0af51863          	bne	a0,a5,80006656 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    800065aa:	04491703          	lh	a4,68(s2)
    800065ae:	4785                	li	a5,1
    800065b0:	0af70b63          	beq	a4,a5,80006666 <sys_unlink+0x192>
  iunlockput(dp);
    800065b4:	8526                	mv	a0,s1
    800065b6:	ffffe097          	auipc	ra,0xffffe
    800065ba:	268080e7          	jalr	616(ra) # 8000481e <iunlockput>
  ip->nlink--;
    800065be:	04a95783          	lhu	a5,74(s2)
    800065c2:	37fd                	addiw	a5,a5,-1
    800065c4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800065c8:	854a                	mv	a0,s2
    800065ca:	ffffe097          	auipc	ra,0xffffe
    800065ce:	f20080e7          	jalr	-224(ra) # 800044ea <iupdate>
  iunlockput(ip);
    800065d2:	854a                	mv	a0,s2
    800065d4:	ffffe097          	auipc	ra,0xffffe
    800065d8:	24a080e7          	jalr	586(ra) # 8000481e <iunlockput>
  end_op();
    800065dc:	fffff097          	auipc	ra,0xfffff
    800065e0:	a4a080e7          	jalr	-1462(ra) # 80005026 <end_op>
  return 0;
    800065e4:	4501                	li	a0,0
    800065e6:	64ee                	ld	s1,216(sp)
    800065e8:	694e                	ld	s2,208(sp)
    800065ea:	69ae                	ld	s3,200(sp)
    800065ec:	a065                	j	80006694 <sys_unlink+0x1c0>
    end_op();
    800065ee:	fffff097          	auipc	ra,0xfffff
    800065f2:	a38080e7          	jalr	-1480(ra) # 80005026 <end_op>
    return -1;
    800065f6:	557d                	li	a0,-1
    800065f8:	64ee                	ld	s1,216(sp)
    800065fa:	a869                	j	80006694 <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    800065fc:	00005517          	auipc	a0,0x5
    80006600:	08c50513          	addi	a0,a0,140 # 8000b688 <etext+0x688>
    80006604:	ffffa097          	auipc	ra,0xffffa
    80006608:	f5a080e7          	jalr	-166(ra) # 8000055e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000660c:	04c92703          	lw	a4,76(s2)
    80006610:	02000793          	li	a5,32
    80006614:	f6e7f5e3          	bgeu	a5,a4,8000657e <sys_unlink+0xaa>
    80006618:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000661a:	4741                	li	a4,16
    8000661c:	86ce                	mv	a3,s3
    8000661e:	f1840613          	addi	a2,s0,-232
    80006622:	4581                	li	a1,0
    80006624:	854a                	mv	a0,s2
    80006626:	ffffe097          	auipc	ra,0xffffe
    8000662a:	24e080e7          	jalr	590(ra) # 80004874 <readi>
    8000662e:	47c1                	li	a5,16
    80006630:	00f51b63          	bne	a0,a5,80006646 <sys_unlink+0x172>
    if(de.inum != 0)
    80006634:	f1845783          	lhu	a5,-232(s0)
    80006638:	e7a5                	bnez	a5,800066a0 <sys_unlink+0x1cc>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000663a:	29c1                	addiw	s3,s3,16
    8000663c:	04c92783          	lw	a5,76(s2)
    80006640:	fcf9ede3          	bltu	s3,a5,8000661a <sys_unlink+0x146>
    80006644:	bf2d                	j	8000657e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80006646:	00005517          	auipc	a0,0x5
    8000664a:	05a50513          	addi	a0,a0,90 # 8000b6a0 <etext+0x6a0>
    8000664e:	ffffa097          	auipc	ra,0xffffa
    80006652:	f10080e7          	jalr	-240(ra) # 8000055e <panic>
    panic("unlink: writei");
    80006656:	00005517          	auipc	a0,0x5
    8000665a:	06250513          	addi	a0,a0,98 # 8000b6b8 <etext+0x6b8>
    8000665e:	ffffa097          	auipc	ra,0xffffa
    80006662:	f00080e7          	jalr	-256(ra) # 8000055e <panic>
    dp->nlink--;
    80006666:	04a4d783          	lhu	a5,74(s1)
    8000666a:	37fd                	addiw	a5,a5,-1
    8000666c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006670:	8526                	mv	a0,s1
    80006672:	ffffe097          	auipc	ra,0xffffe
    80006676:	e78080e7          	jalr	-392(ra) # 800044ea <iupdate>
    8000667a:	bf2d                	j	800065b4 <sys_unlink+0xe0>
    8000667c:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000667e:	8526                	mv	a0,s1
    80006680:	ffffe097          	auipc	ra,0xffffe
    80006684:	19e080e7          	jalr	414(ra) # 8000481e <iunlockput>
  end_op();
    80006688:	fffff097          	auipc	ra,0xfffff
    8000668c:	99e080e7          	jalr	-1634(ra) # 80005026 <end_op>
  return -1;
    80006690:	557d                	li	a0,-1
    80006692:	64ee                	ld	s1,216(sp)
}
    80006694:	70ae                	ld	ra,232(sp)
    80006696:	740e                	ld	s0,224(sp)
    80006698:	616d                	addi	sp,sp,240
    8000669a:	8082                	ret
    return -1;
    8000669c:	557d                	li	a0,-1
    8000669e:	bfdd                	j	80006694 <sys_unlink+0x1c0>
    iunlockput(ip);
    800066a0:	854a                	mv	a0,s2
    800066a2:	ffffe097          	auipc	ra,0xffffe
    800066a6:	17c080e7          	jalr	380(ra) # 8000481e <iunlockput>
    goto bad;
    800066aa:	694e                	ld	s2,208(sp)
    800066ac:	69ae                	ld	s3,200(sp)
    800066ae:	bfc1                	j	8000667e <sys_unlink+0x1aa>

00000000800066b0 <sys_open>:

uint64
sys_open(void)
{
    800066b0:	7131                	addi	sp,sp,-192
    800066b2:	fd06                	sd	ra,184(sp)
    800066b4:	f922                	sd	s0,176(sp)
    800066b6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800066b8:	f4c40593          	addi	a1,s0,-180
    800066bc:	4505                	li	a0,1
    800066be:	ffffd097          	auipc	ra,0xffffd
    800066c2:	dec080e7          	jalr	-532(ra) # 800034aa <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800066c6:	08000613          	li	a2,128
    800066ca:	f5040593          	addi	a1,s0,-176
    800066ce:	4501                	li	a0,0
    800066d0:	ffffd097          	auipc	ra,0xffffd
    800066d4:	e1a080e7          	jalr	-486(ra) # 800034ea <argstr>
    800066d8:	87aa                	mv	a5,a0
    return -1;
    800066da:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800066dc:	0a07cf63          	bltz	a5,8000679a <sys_open+0xea>
    800066e0:	f526                	sd	s1,168(sp)

  begin_op();
    800066e2:	fffff097          	auipc	ra,0xfffff
    800066e6:	8c4080e7          	jalr	-1852(ra) # 80004fa6 <begin_op>

  if(omode & O_CREATE){
    800066ea:	f4c42783          	lw	a5,-180(s0)
    800066ee:	2007f793          	andi	a5,a5,512
    800066f2:	cfdd                	beqz	a5,800067b0 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    800066f4:	4681                	li	a3,0
    800066f6:	4601                	li	a2,0
    800066f8:	4589                	li	a1,2
    800066fa:	f5040513          	addi	a0,s0,-176
    800066fe:	00000097          	auipc	ra,0x0
    80006702:	91e080e7          	jalr	-1762(ra) # 8000601c <create>
    80006706:	84aa                	mv	s1,a0
    if(ip == 0){
    80006708:	cd49                	beqz	a0,800067a2 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000670a:	04449703          	lh	a4,68(s1)
    8000670e:	478d                	li	a5,3
    80006710:	00f71763          	bne	a4,a5,8000671e <sys_open+0x6e>
    80006714:	0464d703          	lhu	a4,70(s1)
    80006718:	47a5                	li	a5,9
    8000671a:	0ee7e263          	bltu	a5,a4,800067fe <sys_open+0x14e>
    8000671e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006720:	fffff097          	auipc	ra,0xfffff
    80006724:	cac080e7          	jalr	-852(ra) # 800053cc <filealloc>
    80006728:	892a                	mv	s2,a0
    8000672a:	cd65                	beqz	a0,80006822 <sys_open+0x172>
    8000672c:	ed4e                	sd	s3,152(sp)
    8000672e:	00000097          	auipc	ra,0x0
    80006732:	a72080e7          	jalr	-1422(ra) # 800061a0 <fdalloc>
    80006736:	89aa                	mv	s3,a0
    80006738:	0c054f63          	bltz	a0,80006816 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000673c:	04449703          	lh	a4,68(s1)
    80006740:	478d                	li	a5,3
    80006742:	0ef70d63          	beq	a4,a5,8000683c <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006746:	4789                	li	a5,2
    80006748:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000674c:	02092423          	sw	zero,40(s2)
  }
  f->ip = ip;
    80006750:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006754:	f4c42783          	lw	a5,-180(s0)
    80006758:	0017f713          	andi	a4,a5,1
    8000675c:	00174713          	xori	a4,a4,1
    80006760:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006764:	0037f713          	andi	a4,a5,3
    80006768:	00e03733          	snez	a4,a4
    8000676c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80006770:	4007f793          	andi	a5,a5,1024
    80006774:	c791                	beqz	a5,80006780 <sys_open+0xd0>
    80006776:	04449703          	lh	a4,68(s1)
    8000677a:	4789                	li	a5,2
    8000677c:	0cf70763          	beq	a4,a5,8000684a <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    80006780:	8526                	mv	a0,s1
    80006782:	ffffe097          	auipc	ra,0xffffe
    80006786:	efa080e7          	jalr	-262(ra) # 8000467c <iunlock>
  end_op();
    8000678a:	fffff097          	auipc	ra,0xfffff
    8000678e:	89c080e7          	jalr	-1892(ra) # 80005026 <end_op>

  return fd;
    80006792:	854e                	mv	a0,s3
    80006794:	74aa                	ld	s1,168(sp)
    80006796:	790a                	ld	s2,160(sp)
    80006798:	69ea                	ld	s3,152(sp)
}
    8000679a:	70ea                	ld	ra,184(sp)
    8000679c:	744a                	ld	s0,176(sp)
    8000679e:	6129                	addi	sp,sp,192
    800067a0:	8082                	ret
      end_op();
    800067a2:	fffff097          	auipc	ra,0xfffff
    800067a6:	884080e7          	jalr	-1916(ra) # 80005026 <end_op>
      return -1;
    800067aa:	557d                	li	a0,-1
    800067ac:	74aa                	ld	s1,168(sp)
    800067ae:	b7f5                	j	8000679a <sys_open+0xea>
    if((ip = namei(path)) == 0){
    800067b0:	f5040513          	addi	a0,s0,-176
    800067b4:	ffffe097          	auipc	ra,0xffffe
    800067b8:	5ec080e7          	jalr	1516(ra) # 80004da0 <namei>
    800067bc:	84aa                	mv	s1,a0
    800067be:	c90d                	beqz	a0,800067f0 <sys_open+0x140>
    ilock(ip);
    800067c0:	ffffe097          	auipc	ra,0xffffe
    800067c4:	df6080e7          	jalr	-522(ra) # 800045b6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800067c8:	04449703          	lh	a4,68(s1)
    800067cc:	4785                	li	a5,1
    800067ce:	f2f71ee3          	bne	a4,a5,8000670a <sys_open+0x5a>
    800067d2:	f4c42783          	lw	a5,-180(s0)
    800067d6:	d7a1                	beqz	a5,8000671e <sys_open+0x6e>
      iunlockput(ip);
    800067d8:	8526                	mv	a0,s1
    800067da:	ffffe097          	auipc	ra,0xffffe
    800067de:	044080e7          	jalr	68(ra) # 8000481e <iunlockput>
      end_op();
    800067e2:	fffff097          	auipc	ra,0xfffff
    800067e6:	844080e7          	jalr	-1980(ra) # 80005026 <end_op>
      return -1;
    800067ea:	557d                	li	a0,-1
    800067ec:	74aa                	ld	s1,168(sp)
    800067ee:	b775                	j	8000679a <sys_open+0xea>
      end_op();
    800067f0:	fffff097          	auipc	ra,0xfffff
    800067f4:	836080e7          	jalr	-1994(ra) # 80005026 <end_op>
      return -1;
    800067f8:	557d                	li	a0,-1
    800067fa:	74aa                	ld	s1,168(sp)
    800067fc:	bf79                	j	8000679a <sys_open+0xea>
    iunlockput(ip);
    800067fe:	8526                	mv	a0,s1
    80006800:	ffffe097          	auipc	ra,0xffffe
    80006804:	01e080e7          	jalr	30(ra) # 8000481e <iunlockput>
    end_op();
    80006808:	fffff097          	auipc	ra,0xfffff
    8000680c:	81e080e7          	jalr	-2018(ra) # 80005026 <end_op>
    return -1;
    80006810:	557d                	li	a0,-1
    80006812:	74aa                	ld	s1,168(sp)
    80006814:	b759                	j	8000679a <sys_open+0xea>
      fileclose(f);
    80006816:	854a                	mv	a0,s2
    80006818:	fffff097          	auipc	ra,0xfffff
    8000681c:	c70080e7          	jalr	-912(ra) # 80005488 <fileclose>
    80006820:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80006822:	8526                	mv	a0,s1
    80006824:	ffffe097          	auipc	ra,0xffffe
    80006828:	ffa080e7          	jalr	-6(ra) # 8000481e <iunlockput>
    end_op();
    8000682c:	ffffe097          	auipc	ra,0xffffe
    80006830:	7fa080e7          	jalr	2042(ra) # 80005026 <end_op>
    return -1;
    80006834:	557d                	li	a0,-1
    80006836:	74aa                	ld	s1,168(sp)
    80006838:	790a                	ld	s2,160(sp)
    8000683a:	b785                	j	8000679a <sys_open+0xea>
    f->type = FD_DEVICE;
    8000683c:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80006840:	04649783          	lh	a5,70(s1)
    80006844:	02f91623          	sh	a5,44(s2)
    80006848:	b721                	j	80006750 <sys_open+0xa0>
    itrunc(ip);
    8000684a:	8526                	mv	a0,s1
    8000684c:	ffffe097          	auipc	ra,0xffffe
    80006850:	e7c080e7          	jalr	-388(ra) # 800046c8 <itrunc>
    80006854:	b735                	j	80006780 <sys_open+0xd0>

0000000080006856 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006856:	7175                	addi	sp,sp,-144
    80006858:	e506                	sd	ra,136(sp)
    8000685a:	e122                	sd	s0,128(sp)
    8000685c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000685e:	ffffe097          	auipc	ra,0xffffe
    80006862:	748080e7          	jalr	1864(ra) # 80004fa6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006866:	08000613          	li	a2,128
    8000686a:	f7040593          	addi	a1,s0,-144
    8000686e:	4501                	li	a0,0
    80006870:	ffffd097          	auipc	ra,0xffffd
    80006874:	c7a080e7          	jalr	-902(ra) # 800034ea <argstr>
    80006878:	02054963          	bltz	a0,800068aa <sys_mkdir+0x54>
    8000687c:	4681                	li	a3,0
    8000687e:	4601                	li	a2,0
    80006880:	4585                	li	a1,1
    80006882:	f7040513          	addi	a0,s0,-144
    80006886:	fffff097          	auipc	ra,0xfffff
    8000688a:	796080e7          	jalr	1942(ra) # 8000601c <create>
    8000688e:	cd11                	beqz	a0,800068aa <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006890:	ffffe097          	auipc	ra,0xffffe
    80006894:	f8e080e7          	jalr	-114(ra) # 8000481e <iunlockput>
  end_op();
    80006898:	ffffe097          	auipc	ra,0xffffe
    8000689c:	78e080e7          	jalr	1934(ra) # 80005026 <end_op>
  return 0;
    800068a0:	4501                	li	a0,0
}
    800068a2:	60aa                	ld	ra,136(sp)
    800068a4:	640a                	ld	s0,128(sp)
    800068a6:	6149                	addi	sp,sp,144
    800068a8:	8082                	ret
    end_op();
    800068aa:	ffffe097          	auipc	ra,0xffffe
    800068ae:	77c080e7          	jalr	1916(ra) # 80005026 <end_op>
    return -1;
    800068b2:	557d                	li	a0,-1
    800068b4:	b7fd                	j	800068a2 <sys_mkdir+0x4c>

00000000800068b6 <sys_mknod>:

uint64
sys_mknod(void)
{
    800068b6:	7135                	addi	sp,sp,-160
    800068b8:	ed06                	sd	ra,152(sp)
    800068ba:	e922                	sd	s0,144(sp)
    800068bc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800068be:	ffffe097          	auipc	ra,0xffffe
    800068c2:	6e8080e7          	jalr	1768(ra) # 80004fa6 <begin_op>
  argint(1, &major);
    800068c6:	f6c40593          	addi	a1,s0,-148
    800068ca:	4505                	li	a0,1
    800068cc:	ffffd097          	auipc	ra,0xffffd
    800068d0:	bde080e7          	jalr	-1058(ra) # 800034aa <argint>
  argint(2, &minor);
    800068d4:	f6840593          	addi	a1,s0,-152
    800068d8:	4509                	li	a0,2
    800068da:	ffffd097          	auipc	ra,0xffffd
    800068de:	bd0080e7          	jalr	-1072(ra) # 800034aa <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800068e2:	08000613          	li	a2,128
    800068e6:	f7040593          	addi	a1,s0,-144
    800068ea:	4501                	li	a0,0
    800068ec:	ffffd097          	auipc	ra,0xffffd
    800068f0:	bfe080e7          	jalr	-1026(ra) # 800034ea <argstr>
    800068f4:	02054b63          	bltz	a0,8000692a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800068f8:	f6841683          	lh	a3,-152(s0)
    800068fc:	f6c41603          	lh	a2,-148(s0)
    80006900:	458d                	li	a1,3
    80006902:	f7040513          	addi	a0,s0,-144
    80006906:	fffff097          	auipc	ra,0xfffff
    8000690a:	716080e7          	jalr	1814(ra) # 8000601c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000690e:	cd11                	beqz	a0,8000692a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006910:	ffffe097          	auipc	ra,0xffffe
    80006914:	f0e080e7          	jalr	-242(ra) # 8000481e <iunlockput>
  end_op();
    80006918:	ffffe097          	auipc	ra,0xffffe
    8000691c:	70e080e7          	jalr	1806(ra) # 80005026 <end_op>
  return 0;
    80006920:	4501                	li	a0,0
}
    80006922:	60ea                	ld	ra,152(sp)
    80006924:	644a                	ld	s0,144(sp)
    80006926:	610d                	addi	sp,sp,160
    80006928:	8082                	ret
    end_op();
    8000692a:	ffffe097          	auipc	ra,0xffffe
    8000692e:	6fc080e7          	jalr	1788(ra) # 80005026 <end_op>
    return -1;
    80006932:	557d                	li	a0,-1
    80006934:	b7fd                	j	80006922 <sys_mknod+0x6c>

0000000080006936 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006936:	7135                	addi	sp,sp,-160
    80006938:	ed06                	sd	ra,152(sp)
    8000693a:	e922                	sd	s0,144(sp)
    8000693c:	e14a                	sd	s2,128(sp)
    8000693e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80006940:	ffffb097          	auipc	ra,0xffffb
    80006944:	53e080e7          	jalr	1342(ra) # 80001e7e <myproc>
    80006948:	892a                	mv	s2,a0
  
  begin_op();
    8000694a:	ffffe097          	auipc	ra,0xffffe
    8000694e:	65c080e7          	jalr	1628(ra) # 80004fa6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006952:	08000613          	li	a2,128
    80006956:	f6040593          	addi	a1,s0,-160
    8000695a:	4501                	li	a0,0
    8000695c:	ffffd097          	auipc	ra,0xffffd
    80006960:	b8e080e7          	jalr	-1138(ra) # 800034ea <argstr>
    80006964:	04054d63          	bltz	a0,800069be <sys_chdir+0x88>
    80006968:	e526                	sd	s1,136(sp)
    8000696a:	f6040513          	addi	a0,s0,-160
    8000696e:	ffffe097          	auipc	ra,0xffffe
    80006972:	432080e7          	jalr	1074(ra) # 80004da0 <namei>
    80006976:	84aa                	mv	s1,a0
    80006978:	c131                	beqz	a0,800069bc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000697a:	ffffe097          	auipc	ra,0xffffe
    8000697e:	c3c080e7          	jalr	-964(ra) # 800045b6 <ilock>
  if(ip->type != T_DIR){
    80006982:	04449703          	lh	a4,68(s1)
    80006986:	4785                	li	a5,1
    80006988:	04f71163          	bne	a4,a5,800069ca <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000698c:	8526                	mv	a0,s1
    8000698e:	ffffe097          	auipc	ra,0xffffe
    80006992:	cee080e7          	jalr	-786(ra) # 8000467c <iunlock>
  iput(p->cwd);
    80006996:	15093503          	ld	a0,336(s2)
    8000699a:	ffffe097          	auipc	ra,0xffffe
    8000699e:	dda080e7          	jalr	-550(ra) # 80004774 <iput>
  end_op();
    800069a2:	ffffe097          	auipc	ra,0xffffe
    800069a6:	684080e7          	jalr	1668(ra) # 80005026 <end_op>
  p->cwd = ip;
    800069aa:	14993823          	sd	s1,336(s2)
  return 0;
    800069ae:	4501                	li	a0,0
    800069b0:	64aa                	ld	s1,136(sp)
}
    800069b2:	60ea                	ld	ra,152(sp)
    800069b4:	644a                	ld	s0,144(sp)
    800069b6:	690a                	ld	s2,128(sp)
    800069b8:	610d                	addi	sp,sp,160
    800069ba:	8082                	ret
    800069bc:	64aa                	ld	s1,136(sp)
    end_op();
    800069be:	ffffe097          	auipc	ra,0xffffe
    800069c2:	668080e7          	jalr	1640(ra) # 80005026 <end_op>
    return -1;
    800069c6:	557d                	li	a0,-1
    800069c8:	b7ed                	j	800069b2 <sys_chdir+0x7c>
    iunlockput(ip);
    800069ca:	8526                	mv	a0,s1
    800069cc:	ffffe097          	auipc	ra,0xffffe
    800069d0:	e52080e7          	jalr	-430(ra) # 8000481e <iunlockput>
    end_op();
    800069d4:	ffffe097          	auipc	ra,0xffffe
    800069d8:	652080e7          	jalr	1618(ra) # 80005026 <end_op>
    return -1;
    800069dc:	557d                	li	a0,-1
    800069de:	64aa                	ld	s1,136(sp)
    800069e0:	bfc9                	j	800069b2 <sys_chdir+0x7c>

00000000800069e2 <sys_exec>:

uint64
sys_exec(void)
{
    800069e2:	7105                	addi	sp,sp,-480
    800069e4:	ef86                	sd	ra,472(sp)
    800069e6:	eba2                	sd	s0,464(sp)
    800069e8:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800069ea:	e2840593          	addi	a1,s0,-472
    800069ee:	4505                	li	a0,1
    800069f0:	ffffd097          	auipc	ra,0xffffd
    800069f4:	ada080e7          	jalr	-1318(ra) # 800034ca <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800069f8:	08000613          	li	a2,128
    800069fc:	f3040593          	addi	a1,s0,-208
    80006a00:	4501                	li	a0,0
    80006a02:	ffffd097          	auipc	ra,0xffffd
    80006a06:	ae8080e7          	jalr	-1304(ra) # 800034ea <argstr>
    80006a0a:	87aa                	mv	a5,a0
    return -1;
    80006a0c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006a0e:	0e07ce63          	bltz	a5,80006b0a <sys_exec+0x128>
    80006a12:	e7a6                	sd	s1,456(sp)
    80006a14:	e3ca                	sd	s2,448(sp)
    80006a16:	ff4e                	sd	s3,440(sp)
    80006a18:	fb52                	sd	s4,432(sp)
    80006a1a:	f756                	sd	s5,424(sp)
    80006a1c:	f35a                	sd	s6,416(sp)
    80006a1e:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80006a20:	e3040a13          	addi	s4,s0,-464
    80006a24:	10000613          	li	a2,256
    80006a28:	4581                	li	a1,0
    80006a2a:	8552                	mv	a0,s4
    80006a2c:	ffffa097          	auipc	ra,0xffffa
    80006a30:	400080e7          	jalr	1024(ra) # 80000e2c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006a34:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80006a36:	89d2                	mv	s3,s4
    80006a38:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006a3a:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006a3e:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80006a40:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006a44:	00391513          	slli	a0,s2,0x3
    80006a48:	85d6                	mv	a1,s5
    80006a4a:	e2843783          	ld	a5,-472(s0)
    80006a4e:	953e                	add	a0,a0,a5
    80006a50:	ffffd097          	auipc	ra,0xffffd
    80006a54:	9bc080e7          	jalr	-1604(ra) # 8000340c <fetchaddr>
    80006a58:	02054a63          	bltz	a0,80006a8c <sys_exec+0xaa>
    if(uarg == 0){
    80006a5c:	e2043783          	ld	a5,-480(s0)
    80006a60:	cbb1                	beqz	a5,80006ab4 <sys_exec+0xd2>
    argv[i] = kalloc();
    80006a62:	ffffa097          	auipc	ra,0xffffa
    80006a66:	1b0080e7          	jalr	432(ra) # 80000c12 <kalloc>
    80006a6a:	85aa                	mv	a1,a0
    80006a6c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006a70:	cd11                	beqz	a0,80006a8c <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006a72:	865a                	mv	a2,s6
    80006a74:	e2043503          	ld	a0,-480(s0)
    80006a78:	ffffd097          	auipc	ra,0xffffd
    80006a7c:	9e6080e7          	jalr	-1562(ra) # 8000345e <fetchstr>
    80006a80:	00054663          	bltz	a0,80006a8c <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80006a84:	0905                	addi	s2,s2,1
    80006a86:	09a1                	addi	s3,s3,8
    80006a88:	fb791ee3          	bne	s2,s7,80006a44 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a8c:	100a0a13          	addi	s4,s4,256
    80006a90:	6088                	ld	a0,0(s1)
    80006a92:	c525                	beqz	a0,80006afa <sys_exec+0x118>
    kfree(argv[i]);
    80006a94:	ffffa097          	auipc	ra,0xffffa
    80006a98:	010080e7          	jalr	16(ra) # 80000aa4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a9c:	04a1                	addi	s1,s1,8
    80006a9e:	ff4499e3          	bne	s1,s4,80006a90 <sys_exec+0xae>
  return -1;
    80006aa2:	557d                	li	a0,-1
    80006aa4:	64be                	ld	s1,456(sp)
    80006aa6:	691e                	ld	s2,448(sp)
    80006aa8:	79fa                	ld	s3,440(sp)
    80006aaa:	7a5a                	ld	s4,432(sp)
    80006aac:	7aba                	ld	s5,424(sp)
    80006aae:	7b1a                	ld	s6,416(sp)
    80006ab0:	6bfa                	ld	s7,408(sp)
    80006ab2:	a8a1                	j	80006b0a <sys_exec+0x128>
      argv[i] = 0;
    80006ab4:	0009079b          	sext.w	a5,s2
    80006ab8:	e3040593          	addi	a1,s0,-464
    80006abc:	078e                	slli	a5,a5,0x3
    80006abe:	97ae                	add	a5,a5,a1
    80006ac0:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80006ac4:	f3040513          	addi	a0,s0,-208
    80006ac8:	fffff097          	auipc	ra,0xfffff
    80006acc:	126080e7          	jalr	294(ra) # 80005bee <exec>
    80006ad0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006ad2:	100a0a13          	addi	s4,s4,256
    80006ad6:	6088                	ld	a0,0(s1)
    80006ad8:	c901                	beqz	a0,80006ae8 <sys_exec+0x106>
    kfree(argv[i]);
    80006ada:	ffffa097          	auipc	ra,0xffffa
    80006ade:	fca080e7          	jalr	-54(ra) # 80000aa4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006ae2:	04a1                	addi	s1,s1,8
    80006ae4:	ff4499e3          	bne	s1,s4,80006ad6 <sys_exec+0xf4>
  return ret;
    80006ae8:	854a                	mv	a0,s2
    80006aea:	64be                	ld	s1,456(sp)
    80006aec:	691e                	ld	s2,448(sp)
    80006aee:	79fa                	ld	s3,440(sp)
    80006af0:	7a5a                	ld	s4,432(sp)
    80006af2:	7aba                	ld	s5,424(sp)
    80006af4:	7b1a                	ld	s6,416(sp)
    80006af6:	6bfa                	ld	s7,408(sp)
    80006af8:	a809                	j	80006b0a <sys_exec+0x128>
  return -1;
    80006afa:	557d                	li	a0,-1
    80006afc:	64be                	ld	s1,456(sp)
    80006afe:	691e                	ld	s2,448(sp)
    80006b00:	79fa                	ld	s3,440(sp)
    80006b02:	7a5a                	ld	s4,432(sp)
    80006b04:	7aba                	ld	s5,424(sp)
    80006b06:	7b1a                	ld	s6,416(sp)
    80006b08:	6bfa                	ld	s7,408(sp)
}
    80006b0a:	60fe                	ld	ra,472(sp)
    80006b0c:	645e                	ld	s0,464(sp)
    80006b0e:	613d                	addi	sp,sp,480
    80006b10:	8082                	ret

0000000080006b12 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006b12:	7139                	addi	sp,sp,-64
    80006b14:	fc06                	sd	ra,56(sp)
    80006b16:	f822                	sd	s0,48(sp)
    80006b18:	f426                	sd	s1,40(sp)
    80006b1a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006b1c:	ffffb097          	auipc	ra,0xffffb
    80006b20:	362080e7          	jalr	866(ra) # 80001e7e <myproc>
    80006b24:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006b26:	fd840593          	addi	a1,s0,-40
    80006b2a:	4501                	li	a0,0
    80006b2c:	ffffd097          	auipc	ra,0xffffd
    80006b30:	99e080e7          	jalr	-1634(ra) # 800034ca <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006b34:	fc840593          	addi	a1,s0,-56
    80006b38:	fd040513          	addi	a0,s0,-48
    80006b3c:	fffff097          	auipc	ra,0xfffff
    80006b40:	d18080e7          	jalr	-744(ra) # 80005854 <pipealloc>
    return -1;
    80006b44:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006b46:	0c054763          	bltz	a0,80006c14 <sys_pipe+0x102>
  fd0 = -1;
    80006b4a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006b4e:	fd043503          	ld	a0,-48(s0)
    80006b52:	fffff097          	auipc	ra,0xfffff
    80006b56:	64e080e7          	jalr	1614(ra) # 800061a0 <fdalloc>
    80006b5a:	fca42223          	sw	a0,-60(s0)
    80006b5e:	08054e63          	bltz	a0,80006bfa <sys_pipe+0xe8>
    80006b62:	fc843503          	ld	a0,-56(s0)
    80006b66:	fffff097          	auipc	ra,0xfffff
    80006b6a:	63a080e7          	jalr	1594(ra) # 800061a0 <fdalloc>
    80006b6e:	fca42023          	sw	a0,-64(s0)
    80006b72:	06054a63          	bltz	a0,80006be6 <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006b76:	4691                	li	a3,4
    80006b78:	fc440613          	addi	a2,s0,-60
    80006b7c:	fd843583          	ld	a1,-40(s0)
    80006b80:	68a8                	ld	a0,80(s1)
    80006b82:	ffffb097          	auipc	ra,0xffffb
    80006b86:	f88080e7          	jalr	-120(ra) # 80001b0a <copyout>
    80006b8a:	02054063          	bltz	a0,80006baa <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006b8e:	4691                	li	a3,4
    80006b90:	fc040613          	addi	a2,s0,-64
    80006b94:	fd843583          	ld	a1,-40(s0)
    80006b98:	95b6                	add	a1,a1,a3
    80006b9a:	68a8                	ld	a0,80(s1)
    80006b9c:	ffffb097          	auipc	ra,0xffffb
    80006ba0:	f6e080e7          	jalr	-146(ra) # 80001b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006ba4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006ba6:	06055763          	bgez	a0,80006c14 <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    80006baa:	fc442783          	lw	a5,-60(s0)
    80006bae:	078e                	slli	a5,a5,0x3
    80006bb0:	0d078793          	addi	a5,a5,208
    80006bb4:	97a6                	add	a5,a5,s1
    80006bb6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006bba:	fc042783          	lw	a5,-64(s0)
    80006bbe:	078e                	slli	a5,a5,0x3
    80006bc0:	0d078793          	addi	a5,a5,208
    80006bc4:	97a6                	add	a5,a5,s1
    80006bc6:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006bca:	fd043503          	ld	a0,-48(s0)
    80006bce:	fffff097          	auipc	ra,0xfffff
    80006bd2:	8ba080e7          	jalr	-1862(ra) # 80005488 <fileclose>
    fileclose(wf);
    80006bd6:	fc843503          	ld	a0,-56(s0)
    80006bda:	fffff097          	auipc	ra,0xfffff
    80006bde:	8ae080e7          	jalr	-1874(ra) # 80005488 <fileclose>
    return -1;
    80006be2:	57fd                	li	a5,-1
    80006be4:	a805                	j	80006c14 <sys_pipe+0x102>
    if(fd0 >= 0)
    80006be6:	fc442783          	lw	a5,-60(s0)
    80006bea:	0007c863          	bltz	a5,80006bfa <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    80006bee:	078e                	slli	a5,a5,0x3
    80006bf0:	0d078793          	addi	a5,a5,208
    80006bf4:	97a6                	add	a5,a5,s1
    80006bf6:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006bfa:	fd043503          	ld	a0,-48(s0)
    80006bfe:	fffff097          	auipc	ra,0xfffff
    80006c02:	88a080e7          	jalr	-1910(ra) # 80005488 <fileclose>
    fileclose(wf);
    80006c06:	fc843503          	ld	a0,-56(s0)
    80006c0a:	fffff097          	auipc	ra,0xfffff
    80006c0e:	87e080e7          	jalr	-1922(ra) # 80005488 <fileclose>
    return -1;
    80006c12:	57fd                	li	a5,-1
}
    80006c14:	853e                	mv	a0,a5
    80006c16:	70e2                	ld	ra,56(sp)
    80006c18:	7442                	ld	s0,48(sp)
    80006c1a:	74a2                	ld	s1,40(sp)
    80006c1c:	6121                	addi	sp,sp,64
    80006c1e:	8082                	ret

0000000080006c20 <kernelvec>:
    80006c20:	7111                	addi	sp,sp,-256
    80006c22:	e006                	sd	ra,0(sp)
    80006c24:	e40a                	sd	sp,8(sp)
    80006c26:	e80e                	sd	gp,16(sp)
    80006c28:	ec12                	sd	tp,24(sp)
    80006c2a:	f016                	sd	t0,32(sp)
    80006c2c:	f41a                	sd	t1,40(sp)
    80006c2e:	f81e                	sd	t2,48(sp)
    80006c30:	fc22                	sd	s0,56(sp)
    80006c32:	e0a6                	sd	s1,64(sp)
    80006c34:	e4aa                	sd	a0,72(sp)
    80006c36:	e8ae                	sd	a1,80(sp)
    80006c38:	ecb2                	sd	a2,88(sp)
    80006c3a:	f0b6                	sd	a3,96(sp)
    80006c3c:	f4ba                	sd	a4,104(sp)
    80006c3e:	f8be                	sd	a5,112(sp)
    80006c40:	fcc2                	sd	a6,120(sp)
    80006c42:	e146                	sd	a7,128(sp)
    80006c44:	e54a                	sd	s2,136(sp)
    80006c46:	e94e                	sd	s3,144(sp)
    80006c48:	ed52                	sd	s4,152(sp)
    80006c4a:	f156                	sd	s5,160(sp)
    80006c4c:	f55a                	sd	s6,168(sp)
    80006c4e:	f95e                	sd	s7,176(sp)
    80006c50:	fd62                	sd	s8,184(sp)
    80006c52:	e1e6                	sd	s9,192(sp)
    80006c54:	e5ea                	sd	s10,200(sp)
    80006c56:	e9ee                	sd	s11,208(sp)
    80006c58:	edf2                	sd	t3,216(sp)
    80006c5a:	f1f6                	sd	t4,224(sp)
    80006c5c:	f5fa                	sd	t5,232(sp)
    80006c5e:	f9fe                	sd	t6,240(sp)
    80006c60:	e76fc0ef          	jal	800032d6 <kerneltrap>
    80006c64:	6082                	ld	ra,0(sp)
    80006c66:	6122                	ld	sp,8(sp)
    80006c68:	61c2                	ld	gp,16(sp)
    80006c6a:	7282                	ld	t0,32(sp)
    80006c6c:	7322                	ld	t1,40(sp)
    80006c6e:	73c2                	ld	t2,48(sp)
    80006c70:	7462                	ld	s0,56(sp)
    80006c72:	6486                	ld	s1,64(sp)
    80006c74:	6526                	ld	a0,72(sp)
    80006c76:	65c6                	ld	a1,80(sp)
    80006c78:	6666                	ld	a2,88(sp)
    80006c7a:	7686                	ld	a3,96(sp)
    80006c7c:	7726                	ld	a4,104(sp)
    80006c7e:	77c6                	ld	a5,112(sp)
    80006c80:	7866                	ld	a6,120(sp)
    80006c82:	688a                	ld	a7,128(sp)
    80006c84:	692a                	ld	s2,136(sp)
    80006c86:	69ca                	ld	s3,144(sp)
    80006c88:	6a6a                	ld	s4,152(sp)
    80006c8a:	7a8a                	ld	s5,160(sp)
    80006c8c:	7b2a                	ld	s6,168(sp)
    80006c8e:	7bca                	ld	s7,176(sp)
    80006c90:	7c6a                	ld	s8,184(sp)
    80006c92:	6c8e                	ld	s9,192(sp)
    80006c94:	6d2e                	ld	s10,200(sp)
    80006c96:	6dce                	ld	s11,208(sp)
    80006c98:	6e6e                	ld	t3,216(sp)
    80006c9a:	7e8e                	ld	t4,224(sp)
    80006c9c:	7f2e                	ld	t5,232(sp)
    80006c9e:	7fce                	ld	t6,240(sp)
    80006ca0:	6111                	addi	sp,sp,256
    80006ca2:	10200073          	sret
    80006ca6:	00000013          	nop
    80006caa:	00000013          	nop
    80006cae:	0001                	nop

0000000080006cb0 <timervec>:
    80006cb0:	34051573          	csrrw	a0,mscratch,a0
    80006cb4:	e10c                	sd	a1,0(a0)
    80006cb6:	e510                	sd	a2,8(a0)
    80006cb8:	e914                	sd	a3,16(a0)
    80006cba:	6d0c                	ld	a1,24(a0)
    80006cbc:	7110                	ld	a2,32(a0)
    80006cbe:	6194                	ld	a3,0(a1)
    80006cc0:	96b2                	add	a3,a3,a2
    80006cc2:	e194                	sd	a3,0(a1)
    80006cc4:	4589                	li	a1,2
    80006cc6:	14459073          	csrw	sip,a1
    80006cca:	6914                	ld	a3,16(a0)
    80006ccc:	6510                	ld	a2,8(a0)
    80006cce:	610c                	ld	a1,0(a0)
    80006cd0:	34051573          	csrrw	a0,mscratch,a0
    80006cd4:	30200073          	mret
    80006cd8:	0001                	nop

0000000080006cda <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80006cda:	1141                	addi	sp,sp,-16
    80006cdc:	e406                	sd	ra,8(sp)
    80006cde:	e022                	sd	s0,0(sp)
    80006ce0:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006ce2:	0c000737          	lui	a4,0xc000
    80006ce6:	4785                	li	a5,1
    80006ce8:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006cea:	c35c                	sw	a5,4(a4)
  *(uint32*)(PLIC + VIRTIO1_IRQ*4) = 1;
    80006cec:	c71c                	sw	a5,8(a4)
}
    80006cee:	60a2                	ld	ra,8(sp)
    80006cf0:	6402                	ld	s0,0(sp)
    80006cf2:	0141                	addi	sp,sp,16
    80006cf4:	8082                	ret

0000000080006cf6 <plicinithart>:

void
plicinithart(void)
{
    80006cf6:	1141                	addi	sp,sp,-16
    80006cf8:	e406                	sd	ra,8(sp)
    80006cfa:	e022                	sd	s0,0(sp)
    80006cfc:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006cfe:	ffffb097          	auipc	ra,0xffffb
    80006d02:	14c080e7          	jalr	332(ra) # 80001e4a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ) | (1 << VIRTIO1_IRQ);
    80006d06:	0085171b          	slliw	a4,a0,0x8
    80006d0a:	0c0027b7          	lui	a5,0xc002
    80006d0e:	97ba                	add	a5,a5,a4
    80006d10:	40600713          	li	a4,1030
    80006d14:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006d18:	00d5151b          	slliw	a0,a0,0xd
    80006d1c:	0c2017b7          	lui	a5,0xc201
    80006d20:	97aa                	add	a5,a5,a0
    80006d22:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006d26:	60a2                	ld	ra,8(sp)
    80006d28:	6402                	ld	s0,0(sp)
    80006d2a:	0141                	addi	sp,sp,16
    80006d2c:	8082                	ret

0000000080006d2e <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006d2e:	1141                	addi	sp,sp,-16
    80006d30:	e406                	sd	ra,8(sp)
    80006d32:	e022                	sd	s0,0(sp)
    80006d34:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006d36:	ffffb097          	auipc	ra,0xffffb
    80006d3a:	114080e7          	jalr	276(ra) # 80001e4a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006d3e:	00d5151b          	slliw	a0,a0,0xd
    80006d42:	0c2017b7          	lui	a5,0xc201
    80006d46:	97aa                	add	a5,a5,a0
  return irq;
}
    80006d48:	43c8                	lw	a0,4(a5)
    80006d4a:	60a2                	ld	ra,8(sp)
    80006d4c:	6402                	ld	s0,0(sp)
    80006d4e:	0141                	addi	sp,sp,16
    80006d50:	8082                	ret

0000000080006d52 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006d52:	1101                	addi	sp,sp,-32
    80006d54:	ec06                	sd	ra,24(sp)
    80006d56:	e822                	sd	s0,16(sp)
    80006d58:	e426                	sd	s1,8(sp)
    80006d5a:	1000                	addi	s0,sp,32
    80006d5c:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006d5e:	ffffb097          	auipc	ra,0xffffb
    80006d62:	0ec080e7          	jalr	236(ra) # 80001e4a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006d66:	00d5179b          	slliw	a5,a0,0xd
    80006d6a:	0c201737          	lui	a4,0xc201
    80006d6e:	97ba                	add	a5,a5,a4
    80006d70:	c3c4                	sw	s1,4(a5)
}
    80006d72:	60e2                	ld	ra,24(sp)
    80006d74:	6442                	ld	s0,16(sp)
    80006d76:	64a2                	ld	s1,8(sp)
    80006d78:	6105                	addi	sp,sp,32
    80006d7a:	8082                	ret

0000000080006d7c <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006d7c:	1141                	addi	sp,sp,-16
    80006d7e:	e406                	sd	ra,8(sp)
    80006d80:	e022                	sd	s0,0(sp)
    80006d82:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006d84:	479d                	li	a5,7
    80006d86:	04a7cc63          	blt	a5,a0,80006dde <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006d8a:	0006b797          	auipc	a5,0x6b
    80006d8e:	85678793          	addi	a5,a5,-1962 # 800715e0 <disk>
    80006d92:	97aa                	add	a5,a5,a0
    80006d94:	0187c783          	lbu	a5,24(a5)
    80006d98:	ebb9                	bnez	a5,80006dee <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006d9a:	00451693          	slli	a3,a0,0x4
    80006d9e:	0006b797          	auipc	a5,0x6b
    80006da2:	84278793          	addi	a5,a5,-1982 # 800715e0 <disk>
    80006da6:	6398                	ld	a4,0(a5)
    80006da8:	9736                	add	a4,a4,a3
    80006daa:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80006dae:	6398                	ld	a4,0(a5)
    80006db0:	9736                	add	a4,a4,a3
    80006db2:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006db6:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006dba:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006dbe:	97aa                	add	a5,a5,a0
    80006dc0:	4705                	li	a4,1
    80006dc2:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006dc6:	0006b517          	auipc	a0,0x6b
    80006dca:	83250513          	addi	a0,a0,-1998 # 800715f8 <disk+0x18>
    80006dce:	ffffc097          	auipc	ra,0xffffc
    80006dd2:	9ca080e7          	jalr	-1590(ra) # 80002798 <wakeup>
}
    80006dd6:	60a2                	ld	ra,8(sp)
    80006dd8:	6402                	ld	s0,0(sp)
    80006dda:	0141                	addi	sp,sp,16
    80006ddc:	8082                	ret
    panic("free_desc 1");
    80006dde:	00005517          	auipc	a0,0x5
    80006de2:	8ea50513          	addi	a0,a0,-1814 # 8000b6c8 <etext+0x6c8>
    80006de6:	ffff9097          	auipc	ra,0xffff9
    80006dea:	778080e7          	jalr	1912(ra) # 8000055e <panic>
    panic("free_desc 2");
    80006dee:	00005517          	auipc	a0,0x5
    80006df2:	8ea50513          	addi	a0,a0,-1814 # 8000b6d8 <etext+0x6d8>
    80006df6:	ffff9097          	auipc	ra,0xffff9
    80006dfa:	768080e7          	jalr	1896(ra) # 8000055e <panic>

0000000080006dfe <virtio_disk_init>:
{
    80006dfe:	1101                	addi	sp,sp,-32
    80006e00:	ec06                	sd	ra,24(sp)
    80006e02:	e822                	sd	s0,16(sp)
    80006e04:	e426                	sd	s1,8(sp)
    80006e06:	e04a                	sd	s2,0(sp)
    80006e08:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006e0a:	00005597          	auipc	a1,0x5
    80006e0e:	8de58593          	addi	a1,a1,-1826 # 8000b6e8 <etext+0x6e8>
    80006e12:	0006b517          	auipc	a0,0x6b
    80006e16:	8f650513          	addi	a0,a0,-1802 # 80071708 <disk+0x128>
    80006e1a:	ffffa097          	auipc	ra,0xffffa
    80006e1e:	e80080e7          	jalr	-384(ra) # 80000c9a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006e22:	100017b7          	lui	a5,0x10001
    80006e26:	4398                	lw	a4,0(a5)
    80006e28:	2701                	sext.w	a4,a4
    80006e2a:	747277b7          	lui	a5,0x74727
    80006e2e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006e32:	16f71463          	bne	a4,a5,80006f9a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006e36:	100017b7          	lui	a5,0x10001
    80006e3a:	43dc                	lw	a5,4(a5)
    80006e3c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006e3e:	4709                	li	a4,2
    80006e40:	14e79d63          	bne	a5,a4,80006f9a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006e44:	100017b7          	lui	a5,0x10001
    80006e48:	479c                	lw	a5,8(a5)
    80006e4a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006e4c:	14e79763          	bne	a5,a4,80006f9a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006e50:	100017b7          	lui	a5,0x10001
    80006e54:	47d8                	lw	a4,12(a5)
    80006e56:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006e58:	554d47b7          	lui	a5,0x554d4
    80006e5c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006e60:	12f71d63          	bne	a4,a5,80006f9a <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e64:	100017b7          	lui	a5,0x10001
    80006e68:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e6c:	4705                	li	a4,1
    80006e6e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e70:	470d                	li	a4,3
    80006e72:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006e74:	10001737          	lui	a4,0x10001
    80006e78:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006e7a:	c7ffe6b7          	lui	a3,0xc7ffe
    80006e7e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f8aec7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006e82:	8f75                	and	a4,a4,a3
    80006e84:	100016b7          	lui	a3,0x10001
    80006e88:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e8a:	472d                	li	a4,11
    80006e8c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e8e:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006e92:	439c                	lw	a5,0(a5)
    80006e94:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006e98:	8ba1                	andi	a5,a5,8
    80006e9a:	10078863          	beqz	a5,80006faa <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006e9e:	100017b7          	lui	a5,0x10001
    80006ea2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006ea6:	43fc                	lw	a5,68(a5)
    80006ea8:	2781                	sext.w	a5,a5
    80006eaa:	10079863          	bnez	a5,80006fba <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006eae:	100017b7          	lui	a5,0x10001
    80006eb2:	5bdc                	lw	a5,52(a5)
    80006eb4:	2781                	sext.w	a5,a5
  if(max == 0)
    80006eb6:	10078a63          	beqz	a5,80006fca <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006eba:	471d                	li	a4,7
    80006ebc:	10f77f63          	bgeu	a4,a5,80006fda <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    80006ec0:	ffffa097          	auipc	ra,0xffffa
    80006ec4:	d52080e7          	jalr	-686(ra) # 80000c12 <kalloc>
    80006ec8:	0006a497          	auipc	s1,0x6a
    80006ecc:	71848493          	addi	s1,s1,1816 # 800715e0 <disk>
    80006ed0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006ed2:	ffffa097          	auipc	ra,0xffffa
    80006ed6:	d40080e7          	jalr	-704(ra) # 80000c12 <kalloc>
    80006eda:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006edc:	ffffa097          	auipc	ra,0xffffa
    80006ee0:	d36080e7          	jalr	-714(ra) # 80000c12 <kalloc>
    80006ee4:	87aa                	mv	a5,a0
    80006ee6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006ee8:	6088                	ld	a0,0(s1)
    80006eea:	10050063          	beqz	a0,80006fea <virtio_disk_init+0x1ec>
    80006eee:	0006a717          	auipc	a4,0x6a
    80006ef2:	6fa73703          	ld	a4,1786(a4) # 800715e8 <disk+0x8>
    80006ef6:	cb75                	beqz	a4,80006fea <virtio_disk_init+0x1ec>
    80006ef8:	cbed                	beqz	a5,80006fea <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006efa:	6605                	lui	a2,0x1
    80006efc:	4581                	li	a1,0
    80006efe:	ffffa097          	auipc	ra,0xffffa
    80006f02:	f2e080e7          	jalr	-210(ra) # 80000e2c <memset>
  memset(disk.avail, 0, PGSIZE);
    80006f06:	0006a497          	auipc	s1,0x6a
    80006f0a:	6da48493          	addi	s1,s1,1754 # 800715e0 <disk>
    80006f0e:	6605                	lui	a2,0x1
    80006f10:	4581                	li	a1,0
    80006f12:	6488                	ld	a0,8(s1)
    80006f14:	ffffa097          	auipc	ra,0xffffa
    80006f18:	f18080e7          	jalr	-232(ra) # 80000e2c <memset>
  memset(disk.used, 0, PGSIZE);
    80006f1c:	6605                	lui	a2,0x1
    80006f1e:	4581                	li	a1,0
    80006f20:	6888                	ld	a0,16(s1)
    80006f22:	ffffa097          	auipc	ra,0xffffa
    80006f26:	f0a080e7          	jalr	-246(ra) # 80000e2c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006f2a:	100017b7          	lui	a5,0x10001
    80006f2e:	4721                	li	a4,8
    80006f30:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006f32:	4098                	lw	a4,0(s1)
    80006f34:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006f38:	40d8                	lw	a4,4(s1)
    80006f3a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006f3e:	649c                	ld	a5,8(s1)
    80006f40:	0007869b          	sext.w	a3,a5
    80006f44:	10001737          	lui	a4,0x10001
    80006f48:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006f4c:	9781                	srai	a5,a5,0x20
    80006f4e:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006f52:	689c                	ld	a5,16(s1)
    80006f54:	0007869b          	sext.w	a3,a5
    80006f58:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006f5c:	9781                	srai	a5,a5,0x20
    80006f5e:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006f62:	4785                	li	a5,1
    80006f64:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006f66:	00f48c23          	sb	a5,24(s1)
    80006f6a:	00f48ca3          	sb	a5,25(s1)
    80006f6e:	00f48d23          	sb	a5,26(s1)
    80006f72:	00f48da3          	sb	a5,27(s1)
    80006f76:	00f48e23          	sb	a5,28(s1)
    80006f7a:	00f48ea3          	sb	a5,29(s1)
    80006f7e:	00f48f23          	sb	a5,30(s1)
    80006f82:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006f86:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006f8a:	07272823          	sw	s2,112(a4)
}
    80006f8e:	60e2                	ld	ra,24(sp)
    80006f90:	6442                	ld	s0,16(sp)
    80006f92:	64a2                	ld	s1,8(sp)
    80006f94:	6902                	ld	s2,0(sp)
    80006f96:	6105                	addi	sp,sp,32
    80006f98:	8082                	ret
    panic("could not find virtio disk");
    80006f9a:	00004517          	auipc	a0,0x4
    80006f9e:	75e50513          	addi	a0,a0,1886 # 8000b6f8 <etext+0x6f8>
    80006fa2:	ffff9097          	auipc	ra,0xffff9
    80006fa6:	5bc080e7          	jalr	1468(ra) # 8000055e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006faa:	00004517          	auipc	a0,0x4
    80006fae:	76e50513          	addi	a0,a0,1902 # 8000b718 <etext+0x718>
    80006fb2:	ffff9097          	auipc	ra,0xffff9
    80006fb6:	5ac080e7          	jalr	1452(ra) # 8000055e <panic>
    panic("virtio disk should not be ready");
    80006fba:	00004517          	auipc	a0,0x4
    80006fbe:	77e50513          	addi	a0,a0,1918 # 8000b738 <etext+0x738>
    80006fc2:	ffff9097          	auipc	ra,0xffff9
    80006fc6:	59c080e7          	jalr	1436(ra) # 8000055e <panic>
    panic("virtio disk has no queue 0");
    80006fca:	00004517          	auipc	a0,0x4
    80006fce:	78e50513          	addi	a0,a0,1934 # 8000b758 <etext+0x758>
    80006fd2:	ffff9097          	auipc	ra,0xffff9
    80006fd6:	58c080e7          	jalr	1420(ra) # 8000055e <panic>
    panic("virtio disk max queue too short");
    80006fda:	00004517          	auipc	a0,0x4
    80006fde:	79e50513          	addi	a0,a0,1950 # 8000b778 <etext+0x778>
    80006fe2:	ffff9097          	auipc	ra,0xffff9
    80006fe6:	57c080e7          	jalr	1404(ra) # 8000055e <panic>
    panic("virtio disk kalloc");
    80006fea:	00004517          	auipc	a0,0x4
    80006fee:	7ae50513          	addi	a0,a0,1966 # 8000b798 <etext+0x798>
    80006ff2:	ffff9097          	auipc	ra,0xffff9
    80006ff6:	56c080e7          	jalr	1388(ra) # 8000055e <panic>

0000000080006ffa <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006ffa:	711d                	addi	sp,sp,-96
    80006ffc:	ec86                	sd	ra,88(sp)
    80006ffe:	e8a2                	sd	s0,80(sp)
    80007000:	e4a6                	sd	s1,72(sp)
    80007002:	e0ca                	sd	s2,64(sp)
    80007004:	fc4e                	sd	s3,56(sp)
    80007006:	f852                	sd	s4,48(sp)
    80007008:	f456                	sd	s5,40(sp)
    8000700a:	f05a                	sd	s6,32(sp)
    8000700c:	ec5e                	sd	s7,24(sp)
    8000700e:	e862                	sd	s8,16(sp)
    80007010:	1080                	addi	s0,sp,96
    80007012:	89aa                	mv	s3,a0
    80007014:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80007016:	00c52b83          	lw	s7,12(a0)
    8000701a:	001b9b9b          	slliw	s7,s7,0x1
    8000701e:	1b82                	slli	s7,s7,0x20
    80007020:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80007024:	0006a517          	auipc	a0,0x6a
    80007028:	6e450513          	addi	a0,a0,1764 # 80071708 <disk+0x128>
    8000702c:	ffffa097          	auipc	ra,0xffffa
    80007030:	d08080e7          	jalr	-760(ra) # 80000d34 <acquire>
  for(int i = 0; i < NUM; i++){
    80007034:	44a1                	li	s1,8
      disk.free[i] = 0;
    80007036:	0006aa97          	auipc	s5,0x6a
    8000703a:	5aaa8a93          	addi	s5,s5,1450 # 800715e0 <disk>
  for(int i = 0; i < 3; i++){
    8000703e:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80007040:	5c7d                	li	s8,-1
    80007042:	a885                	j	800070b2 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80007044:	00fa8733          	add	a4,s5,a5
    80007048:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000704c:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000704e:	0207c563          	bltz	a5,80007078 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80007052:	2905                	addiw	s2,s2,1
    80007054:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80007056:	07490263          	beq	s2,s4,800070ba <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    8000705a:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000705c:	0006a717          	auipc	a4,0x6a
    80007060:	58470713          	addi	a4,a4,1412 # 800715e0 <disk>
    80007064:	4781                	li	a5,0
    if(disk.free[i]){
    80007066:	01874683          	lbu	a3,24(a4)
    8000706a:	fee9                	bnez	a3,80007044 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    8000706c:	2785                	addiw	a5,a5,1
    8000706e:	0705                	addi	a4,a4,1
    80007070:	fe979be3          	bne	a5,s1,80007066 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80007074:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80007078:	03205163          	blez	s2,8000709a <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000707c:	fa042503          	lw	a0,-96(s0)
    80007080:	00000097          	auipc	ra,0x0
    80007084:	cfc080e7          	jalr	-772(ra) # 80006d7c <free_desc>
      for(int j = 0; j < i; j++)
    80007088:	4785                	li	a5,1
    8000708a:	0127d863          	bge	a5,s2,8000709a <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000708e:	fa442503          	lw	a0,-92(s0)
    80007092:	00000097          	auipc	ra,0x0
    80007096:	cea080e7          	jalr	-790(ra) # 80006d7c <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000709a:	0006a597          	auipc	a1,0x6a
    8000709e:	66e58593          	addi	a1,a1,1646 # 80071708 <disk+0x128>
    800070a2:	0006a517          	auipc	a0,0x6a
    800070a6:	55650513          	addi	a0,a0,1366 # 800715f8 <disk+0x18>
    800070aa:	ffffb097          	auipc	ra,0xffffb
    800070ae:	68a080e7          	jalr	1674(ra) # 80002734 <sleep>
  for(int i = 0; i < 3; i++){
    800070b2:	fa040613          	addi	a2,s0,-96
    800070b6:	4901                	li	s2,0
    800070b8:	b74d                	j	8000705a <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800070ba:	fa042503          	lw	a0,-96(s0)
    800070be:	00451693          	slli	a3,a0,0x4

  if(write)
    800070c2:	0006a797          	auipc	a5,0x6a
    800070c6:	51e78793          	addi	a5,a5,1310 # 800715e0 <disk>
    800070ca:	00451713          	slli	a4,a0,0x4
    800070ce:	0a070713          	addi	a4,a4,160
    800070d2:	973e                	add	a4,a4,a5
    800070d4:	01603633          	snez	a2,s6
    800070d8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800070da:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800070de:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800070e2:	6398                	ld	a4,0(a5)
    800070e4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800070e6:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800070ea:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800070ec:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800070ee:	6390                	ld	a2,0(a5)
    800070f0:	00d60833          	add	a6,a2,a3
    800070f4:	4741                	li	a4,16
    800070f6:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800070fa:	4585                	li	a1,1
    800070fc:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80007100:	fa442703          	lw	a4,-92(s0)
    80007104:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80007108:	0712                	slli	a4,a4,0x4
    8000710a:	963a                	add	a2,a2,a4
    8000710c:	05898813          	addi	a6,s3,88
    80007110:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80007114:	0007b883          	ld	a7,0(a5)
    80007118:	9746                	add	a4,a4,a7
    8000711a:	40000613          	li	a2,1024
    8000711e:	c710                	sw	a2,8(a4)
  if(write)
    80007120:	001b3613          	seqz	a2,s6
    80007124:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80007128:	8e4d                	or	a2,a2,a1
    8000712a:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000712e:	fa842603          	lw	a2,-88(s0)
    80007132:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80007136:	00451813          	slli	a6,a0,0x4
    8000713a:	02080813          	addi	a6,a6,32
    8000713e:	983e                	add	a6,a6,a5
    80007140:	577d                	li	a4,-1
    80007142:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80007146:	0612                	slli	a2,a2,0x4
    80007148:	98b2                	add	a7,a7,a2
    8000714a:	03068713          	addi	a4,a3,48
    8000714e:	973e                	add	a4,a4,a5
    80007150:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80007154:	6398                	ld	a4,0(a5)
    80007156:	9732                	add	a4,a4,a2
    80007158:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000715a:	4689                	li	a3,2
    8000715c:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80007160:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80007164:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80007168:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000716c:	6794                	ld	a3,8(a5)
    8000716e:	0026d703          	lhu	a4,2(a3)
    80007172:	8b1d                	andi	a4,a4,7
    80007174:	0706                	slli	a4,a4,0x1
    80007176:	96ba                	add	a3,a3,a4
    80007178:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000717c:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80007180:	6798                	ld	a4,8(a5)
    80007182:	00275783          	lhu	a5,2(a4)
    80007186:	2785                	addiw	a5,a5,1
    80007188:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000718c:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80007190:	100017b7          	lui	a5,0x10001
    80007194:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80007198:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    8000719c:	0006a917          	auipc	s2,0x6a
    800071a0:	56c90913          	addi	s2,s2,1388 # 80071708 <disk+0x128>
  while(b->disk == 1) {
    800071a4:	84ae                	mv	s1,a1
    800071a6:	00b79c63          	bne	a5,a1,800071be <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800071aa:	85ca                	mv	a1,s2
    800071ac:	854e                	mv	a0,s3
    800071ae:	ffffb097          	auipc	ra,0xffffb
    800071b2:	586080e7          	jalr	1414(ra) # 80002734 <sleep>
  while(b->disk == 1) {
    800071b6:	0049a783          	lw	a5,4(s3)
    800071ba:	fe9788e3          	beq	a5,s1,800071aa <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800071be:	fa042903          	lw	s2,-96(s0)
    800071c2:	00491713          	slli	a4,s2,0x4
    800071c6:	02070713          	addi	a4,a4,32
    800071ca:	0006a797          	auipc	a5,0x6a
    800071ce:	41678793          	addi	a5,a5,1046 # 800715e0 <disk>
    800071d2:	97ba                	add	a5,a5,a4
    800071d4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800071d8:	0006a997          	auipc	s3,0x6a
    800071dc:	40898993          	addi	s3,s3,1032 # 800715e0 <disk>
    800071e0:	00491713          	slli	a4,s2,0x4
    800071e4:	0009b783          	ld	a5,0(s3)
    800071e8:	97ba                	add	a5,a5,a4
    800071ea:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800071ee:	854a                	mv	a0,s2
    800071f0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800071f4:	00000097          	auipc	ra,0x0
    800071f8:	b88080e7          	jalr	-1144(ra) # 80006d7c <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800071fc:	8885                	andi	s1,s1,1
    800071fe:	f0ed                	bnez	s1,800071e0 <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80007200:	0006a517          	auipc	a0,0x6a
    80007204:	50850513          	addi	a0,a0,1288 # 80071708 <disk+0x128>
    80007208:	ffffa097          	auipc	ra,0xffffa
    8000720c:	bdc080e7          	jalr	-1060(ra) # 80000de4 <release>
}
    80007210:	60e6                	ld	ra,88(sp)
    80007212:	6446                	ld	s0,80(sp)
    80007214:	64a6                	ld	s1,72(sp)
    80007216:	6906                	ld	s2,64(sp)
    80007218:	79e2                	ld	s3,56(sp)
    8000721a:	7a42                	ld	s4,48(sp)
    8000721c:	7aa2                	ld	s5,40(sp)
    8000721e:	7b02                	ld	s6,32(sp)
    80007220:	6be2                	ld	s7,24(sp)
    80007222:	6c42                	ld	s8,16(sp)
    80007224:	6125                	addi	sp,sp,96
    80007226:	8082                	ret

0000000080007228 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80007228:	1101                	addi	sp,sp,-32
    8000722a:	ec06                	sd	ra,24(sp)
    8000722c:	e822                	sd	s0,16(sp)
    8000722e:	e426                	sd	s1,8(sp)
    80007230:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80007232:	0006a497          	auipc	s1,0x6a
    80007236:	3ae48493          	addi	s1,s1,942 # 800715e0 <disk>
    8000723a:	0006a517          	auipc	a0,0x6a
    8000723e:	4ce50513          	addi	a0,a0,1230 # 80071708 <disk+0x128>
    80007242:	ffffa097          	auipc	ra,0xffffa
    80007246:	af2080e7          	jalr	-1294(ra) # 80000d34 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000724a:	100017b7          	lui	a5,0x10001
    8000724e:	53bc                	lw	a5,96(a5)
    80007250:	8b8d                	andi	a5,a5,3
    80007252:	10001737          	lui	a4,0x10001
    80007256:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80007258:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000725c:	689c                	ld	a5,16(s1)
    8000725e:	0204d703          	lhu	a4,32(s1)
    80007262:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80007266:	04f70a63          	beq	a4,a5,800072ba <virtio_disk_intr+0x92>
    __sync_synchronize();
    8000726a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000726e:	6898                	ld	a4,16(s1)
    80007270:	0204d783          	lhu	a5,32(s1)
    80007274:	8b9d                	andi	a5,a5,7
    80007276:	078e                	slli	a5,a5,0x3
    80007278:	97ba                	add	a5,a5,a4
    8000727a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000727c:	00479713          	slli	a4,a5,0x4
    80007280:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80007284:	9726                	add	a4,a4,s1
    80007286:	01074703          	lbu	a4,16(a4)
    8000728a:	e729                	bnez	a4,800072d4 <virtio_disk_intr+0xac>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000728c:	0792                	slli	a5,a5,0x4
    8000728e:	02078793          	addi	a5,a5,32
    80007292:	97a6                	add	a5,a5,s1
    80007294:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80007296:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000729a:	ffffb097          	auipc	ra,0xffffb
    8000729e:	4fe080e7          	jalr	1278(ra) # 80002798 <wakeup>

    disk.used_idx += 1;
    800072a2:	0204d783          	lhu	a5,32(s1)
    800072a6:	2785                	addiw	a5,a5,1
    800072a8:	17c2                	slli	a5,a5,0x30
    800072aa:	93c1                	srli	a5,a5,0x30
    800072ac:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800072b0:	6898                	ld	a4,16(s1)
    800072b2:	00275703          	lhu	a4,2(a4)
    800072b6:	faf71ae3          	bne	a4,a5,8000726a <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    800072ba:	0006a517          	auipc	a0,0x6a
    800072be:	44e50513          	addi	a0,a0,1102 # 80071708 <disk+0x128>
    800072c2:	ffffa097          	auipc	ra,0xffffa
    800072c6:	b22080e7          	jalr	-1246(ra) # 80000de4 <release>
}
    800072ca:	60e2                	ld	ra,24(sp)
    800072cc:	6442                	ld	s0,16(sp)
    800072ce:	64a2                	ld	s1,8(sp)
    800072d0:	6105                	addi	sp,sp,32
    800072d2:	8082                	ret
      panic("virtio_disk_intr status");
    800072d4:	00004517          	auipc	a0,0x4
    800072d8:	4dc50513          	addi	a0,a0,1244 # 8000b7b0 <etext+0x7b0>
    800072dc:	ffff9097          	auipc	ra,0xffff9
    800072e0:	282080e7          	jalr	642(ra) # 8000055e <panic>

00000000800072e4 <alloc_desc>:
 *         returns -1 if there are no free descriptors
 *
 */
int 
alloc_desc(struct virtq *q) 
{
    800072e4:	1141                	addi	sp,sp,-16
    800072e6:	e406                	sd	ra,8(sp)
    800072e8:	e022                	sd	s0,0(sp)
    800072ea:	0800                	addi	s0,sp,16
    800072ec:	862a                	mv	a2,a0
  for (int i = 0; i < NUM; i++) {
    800072ee:	01c50793          	addi	a5,a0,28
    800072f2:	4501                	li	a0,0
    800072f4:	46a1                	li	a3,8
    if (q->free[i]) {
    800072f6:	0007c703          	lbu	a4,0(a5)
    800072fa:	eb11                	bnez	a4,8000730e <alloc_desc+0x2a>
  for (int i = 0; i < NUM; i++) {
    800072fc:	2505                	addiw	a0,a0,1
    800072fe:	0785                	addi	a5,a5,1
    80007300:	fed51be3          	bne	a0,a3,800072f6 <alloc_desc+0x12>
      q->free[i] = 0;
      return i;
    }
  }
  return -1;
    80007304:	557d                	li	a0,-1
}
    80007306:	60a2                	ld	ra,8(sp)
    80007308:	6402                	ld	s0,0(sp)
    8000730a:	0141                	addi	sp,sp,16
    8000730c:	8082                	ret
      q->free[i] = 0;
    8000730e:	962a                	add	a2,a2,a0
    80007310:	00060e23          	sb	zero,28(a2)
      return i;
    80007314:	bfcd                	j	80007306 <alloc_desc+0x22>

0000000080007316 <free_desc>:
 * Output: None
 *
 */
void 
free_desc(struct virtq *q, int i) 
{
    80007316:	1141                	addi	sp,sp,-16
    80007318:	e406                	sd	ra,8(sp)
    8000731a:	e022                	sd	s0,0(sp)
    8000731c:	0800                	addi	s0,sp,16
  if (i >= NUM)
    8000731e:	479d                	li	a5,7
    80007320:	02b7cd63          	blt	a5,a1,8000735a <free_desc+0x44>
    panic("free_desc 1");
  if (q->free[i])
    80007324:	00b507b3          	add	a5,a0,a1
    80007328:	01c7c783          	lbu	a5,28(a5)
    8000732c:	ef9d                	bnez	a5,8000736a <free_desc+0x54>
    panic("free_desc 2");

  q->desc->addr = 0;
    8000732e:	611c                	ld	a5,0(a0)
    80007330:	0007b023          	sd	zero,0(a5)
  q->desc->len = 0;
    80007334:	611c                	ld	a5,0(a0)
    80007336:	0007a423          	sw	zero,8(a5)
  q->desc->flags = 0;
    8000733a:	611c                	ld	a5,0(a0)
    8000733c:	00079623          	sh	zero,12(a5)
  q->desc->next = 0;
    80007340:	611c                	ld	a5,0(a0)
    80007342:	00079723          	sh	zero,14(a5)
  wakeup(&q->free[i]);
    80007346:	05f1                	addi	a1,a1,28
    80007348:	952e                	add	a0,a0,a1
    8000734a:	ffffb097          	auipc	ra,0xffffb
    8000734e:	44e080e7          	jalr	1102(ra) # 80002798 <wakeup>
}
    80007352:	60a2                	ld	ra,8(sp)
    80007354:	6402                	ld	s0,0(sp)
    80007356:	0141                	addi	sp,sp,16
    80007358:	8082                	ret
    panic("free_desc 1");
    8000735a:	00004517          	auipc	a0,0x4
    8000735e:	36e50513          	addi	a0,a0,878 # 8000b6c8 <etext+0x6c8>
    80007362:	ffff9097          	auipc	ra,0xffff9
    80007366:	1fc080e7          	jalr	508(ra) # 8000055e <panic>
    panic("free_desc 2");
    8000736a:	00004517          	auipc	a0,0x4
    8000736e:	36e50513          	addi	a0,a0,878 # 8000b6d8 <etext+0x6d8>
    80007372:	ffff9097          	auipc	ra,0xffff9
    80007376:	1ec080e7          	jalr	492(ra) # 8000055e <panic>

000000008000737a <virtio_net_init>:
 * a minimal netowrk driver, I only negotiate VIRTIO_NET_F_MAC
 *
 */
void 
virtio_net_init(void) 
{
    8000737a:	7159                	addi	sp,sp,-112
    8000737c:	f486                	sd	ra,104(sp)
    8000737e:	f0a2                	sd	s0,96(sp)
    80007380:	eca6                	sd	s1,88(sp)
    80007382:	e8ca                	sd	s2,80(sp)
    80007384:	e4ce                	sd	s3,72(sp)
    80007386:	e0d2                	sd	s4,64(sp)
    80007388:	fc56                	sd	s5,56(sp)
    8000738a:	f85a                	sd	s6,48(sp)
    8000738c:	f45e                	sd	s7,40(sp)
    8000738e:	f062                	sd	s8,32(sp)
    80007390:	ec66                	sd	s9,24(sp)
    80007392:	e86a                	sd	s10,16(sp)
    80007394:	e46e                	sd	s11,8(sp)
    80007396:	1880                	addi	s0,sp,112
  uint32 status = 0;
  initlock(&net.vnet_lock, "virtio_net");
    80007398:	00004597          	auipc	a1,0x4
    8000739c:	43058593          	addi	a1,a1,1072 # 8000b7c8 <etext+0x7c8>
    800073a0:	0006a517          	auipc	a0,0x6a
    800073a4:	39050513          	addi	a0,a0,912 # 80071730 <net+0x10>
    800073a8:	ffffa097          	auipc	ra,0xffffa
    800073ac:	8f2080e7          	jalr	-1806(ra) # 80000c9a <initlock>

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800073b0:	100027b7          	lui	a5,0x10002
    800073b4:	4398                	lw	a4,0(a5)
    800073b6:	2701                	sext.w	a4,a4
    800073b8:	747277b7          	lui	a5,0x74727
    800073bc:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800073c0:	32f71a63          	bne	a4,a5,800076f4 <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    800073c4:	100027b7          	lui	a5,0x10002
    800073c8:	43dc                	lw	a5,4(a5)
    800073ca:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800073cc:	4709                	li	a4,2
    800073ce:	32e79363          	bne	a5,a4,800076f4 <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    800073d2:	100027b7          	lui	a5,0x10002
    800073d6:	479c                	lw	a5,8(a5)
    800073d8:	2781                	sext.w	a5,a5
    800073da:	4705                	li	a4,1
    800073dc:	30e79c63          	bne	a5,a4,800076f4 <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    800073e0:	100027b7          	lui	a5,0x10002
    800073e4:	47d8                	lw	a4,12(a5)
    800073e6:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    800073e8:	554d47b7          	lui	a5,0x554d4
    800073ec:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800073f0:	30f71263          	bne	a4,a5,800076f4 <virtio_net_init+0x37a>
    panic("could not find virtio net");
  }

  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    800073f4:	100024b7          	lui	s1,0x10002
    800073f8:	07048493          	addi	s1,s1,112 # 10002070 <_entry-0x6fffdf90>
    800073fc:	0004a023          	sw	zero,0(s1)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007400:	4785                	li	a5,1
    80007402:	c09c                	sw	a5,0(s1)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007404:	478d                	li	a5,3
    80007406:	c09c                	sw	a5,0(s1)

  // This copies the memory from the config into my driver state struct
  memmove((void *)&net.cfg, (void *)VIRTIO_NET_CONFIG,
    80007408:	4631                	li	a2,12
    8000740a:	100025b7          	lui	a1,0x10002
    8000740e:	10058593          	addi	a1,a1,256 # 10002100 <_entry-0x6fffdf00>
    80007412:	0006a517          	auipc	a0,0x6a
    80007416:	30e50513          	addi	a0,a0,782 # 80071720 <net>
    8000741a:	ffffa097          	auipc	ra,0xffffa
    8000741e:	a72080e7          	jalr	-1422(ra) # 80000e8c <memmove>
          sizeof(struct virtio_net_config));

  // Negotiate the feature bits
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80007422:	100027b7          	lui	a5,0x10002
    80007426:	4b9c                	lw	a5,16(a5)
  features &= VIRTIO_NET_F_MAC;
    80007428:	0207f793          	andi	a5,a5,32
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000742c:	10002737          	lui	a4,0x10002
    80007430:	d31c                	sw	a5,32(a4)

  // Tell device that feature negotiation is complete
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007432:	47ad                	li	a5,11
    80007434:	c09c                	sw	a5,0(s1)

  // Make sure that FEATURES_OK is set
  status = *R(VIRTIO_MMIO_STATUS);
    80007436:	409c                	lw	a5,0(s1)
    80007438:	00078d1b          	sext.w	s10,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000743c:	8ba1                	andi	a5,a5,8
    8000743e:	2c078363          	beqz	a5,80007704 <virtio_net_init+0x38a>
    panic("virtio net FEATURES_OK unset");

  // Check max queue size
  uint32 max_queue_size = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80007442:	100027b7          	lui	a5,0x10002
    80007446:	5bdc                	lw	a5,52(a5)
    80007448:	2781                	sext.w	a5,a5
  if (max_queue_size == 0)
    8000744a:	2c078563          	beqz	a5,80007714 <virtio_net_init+0x39a>
    panic("virtio net has no queue 1 (QUEUE_TX)");
  if (max_queue_size < NUM)
    8000744e:	471d                	li	a4,7
    80007450:	2cf77a63          	bgeu	a4,a5,80007724 <virtio_net_init+0x3aa>
    panic("virtio net max queue too short");

  /* Initialize QUEUE_TX */
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    80007454:	10002737          	lui	a4,0x10002
    80007458:	4785                	li	a5,1
    8000745a:	db1c                	sw	a5,48(a4)
  net.txq.num = QUEUE_TX;
    8000745c:	0006a717          	auipc	a4,0x6a
    80007460:	30f72223          	sw	a5,772(a4) # 80071760 <net+0x40>

  // ensure QUEUE_TX is not in use.
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80007464:	100027b7          	lui	a5,0x10002
    80007468:	43fc                	lw	a5,68(a5)
    8000746a:	2781                	sext.w	a5,a5
    8000746c:	2c079463          	bnez	a5,80007734 <virtio_net_init+0x3ba>
    panic("QUEUE_TX should not be ready\n");

  net.txq.desc = kalloc();
    80007470:	ffff9097          	auipc	ra,0xffff9
    80007474:	7a2080e7          	jalr	1954(ra) # 80000c12 <kalloc>
    80007478:	0006a497          	auipc	s1,0x6a
    8000747c:	2a848493          	addi	s1,s1,680 # 80071720 <net>
    80007480:	f488                	sd	a0,40(s1)
  net.txq.driver_area = kalloc();
    80007482:	ffff9097          	auipc	ra,0xffff9
    80007486:	790080e7          	jalr	1936(ra) # 80000c12 <kalloc>
    8000748a:	f888                	sd	a0,48(s1)
  net.txq.device_area = kalloc();
    8000748c:	ffff9097          	auipc	ra,0xffff9
    80007490:	786080e7          	jalr	1926(ra) # 80000c12 <kalloc>
    80007494:	87aa                	mv	a5,a0
    80007496:	fc88                	sd	a0,56(s1)
  if (!net.txq.desc || !net.txq.driver_area || !net.txq.device_area)
    80007498:	7488                	ld	a0,40(s1)
    8000749a:	2a050563          	beqz	a0,80007744 <virtio_net_init+0x3ca>
    8000749e:	0006a717          	auipc	a4,0x6a
    800074a2:	2b273703          	ld	a4,690(a4) # 80071750 <net+0x30>
    800074a6:	28070f63          	beqz	a4,80007744 <virtio_net_init+0x3ca>
    800074aa:	28078d63          	beqz	a5,80007744 <virtio_net_init+0x3ca>
    panic("virtio net alloc\n");
  memset(net.txq.desc, 0, PGSIZE);
    800074ae:	6605                	lui	a2,0x1
    800074b0:	4581                	li	a1,0
    800074b2:	ffffa097          	auipc	ra,0xffffa
    800074b6:	97a080e7          	jalr	-1670(ra) # 80000e2c <memset>
  memset(net.txq.free, 1, NUM);
    800074ba:	0006a497          	auipc	s1,0x6a
    800074be:	26648493          	addi	s1,s1,614 # 80071720 <net>
    800074c2:	4621                	li	a2,8
    800074c4:	4585                	li	a1,1
    800074c6:	0006a517          	auipc	a0,0x6a
    800074ca:	29e50513          	addi	a0,a0,670 # 80071764 <net+0x44>
    800074ce:	ffffa097          	auipc	ra,0xffffa
    800074d2:	95e080e7          	jalr	-1698(ra) # 80000e2c <memset>
  memset(net.txq.driver_area, 0, PGSIZE);
    800074d6:	6605                	lui	a2,0x1
    800074d8:	4581                	li	a1,0
    800074da:	7888                	ld	a0,48(s1)
    800074dc:	ffffa097          	auipc	ra,0xffffa
    800074e0:	950080e7          	jalr	-1712(ra) # 80000e2c <memset>
  memset(net.txq.device_area, 0, PGSIZE);
    800074e4:	6605                	lui	a2,0x1
    800074e6:	4581                	li	a1,0
    800074e8:	7c88                	ld	a0,56(s1)
    800074ea:	ffffa097          	auipc	ra,0xffffa
    800074ee:	942080e7          	jalr	-1726(ra) # 80000e2c <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800074f2:	100027b7          	lui	a5,0x10002
    800074f6:	4721                	li	a4,8
    800074f8:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.txq.desc;
    800074fa:	749c                	ld	a5,40(s1)
    800074fc:	0007869b          	sext.w	a3,a5
    80007500:	10002737          	lui	a4,0x10002
    80007504:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.txq.desc) >> 32;
    80007508:	9781                	srai	a5,a5,0x20
    8000750a:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.txq.driver_area;
    8000750e:	789c                	ld	a5,48(s1)
    80007510:	0007869b          	sext.w	a3,a5
    80007514:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.txq.driver_area) >> 32;
    80007518:	9781                	srai	a5,a5,0x20
    8000751a:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.txq.device_area;
    8000751e:	7c9c                	ld	a5,56(s1)
    80007520:	0007869b          	sext.w	a3,a5
    80007524:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.txq.device_area) >> 32;
    80007528:	9781                	srai	a5,a5,0x20
    8000752a:	0af72223          	sw	a5,164(a4)

  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000752e:	87ba                	mv	a5,a4
    80007530:	4705                	li	a4,1
    80007532:	c3f8                	sw	a4,68(a5)
    80007534:	04478793          	addi	a5,a5,68 # 10002044 <_entry-0x6fffdfbc>

  /* Initialize QUEUE_RX */

  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_RX;
    80007538:	10002737          	lui	a4,0x10002
    8000753c:	02072823          	sw	zero,48(a4) # 10002030 <_entry-0x6fffdfd0>
  net.rxq.num = QUEUE_RX;
    80007540:	0604a423          	sw	zero,104(s1)
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80007544:	439c                	lw	a5,0(a5)
    80007546:	2781                	sext.w	a5,a5
    80007548:	20079663          	bnez	a5,80007754 <virtio_net_init+0x3da>
    panic("QUEUE_RX should not be ready\n");

  net.rxq.desc = kalloc();
    8000754c:	ffff9097          	auipc	ra,0xffff9
    80007550:	6c6080e7          	jalr	1734(ra) # 80000c12 <kalloc>
    80007554:	0006a497          	auipc	s1,0x6a
    80007558:	1cc48493          	addi	s1,s1,460 # 80071720 <net>
    8000755c:	e8a8                	sd	a0,80(s1)
  net.rxq.driver_area = kalloc();
    8000755e:	ffff9097          	auipc	ra,0xffff9
    80007562:	6b4080e7          	jalr	1716(ra) # 80000c12 <kalloc>
    80007566:	eca8                	sd	a0,88(s1)
  net.rxq.device_area = kalloc();
    80007568:	ffff9097          	auipc	ra,0xffff9
    8000756c:	6aa080e7          	jalr	1706(ra) # 80000c12 <kalloc>
    80007570:	87aa                	mv	a5,a0
    80007572:	f0a8                	sd	a0,96(s1)
  if (!net.rxq.desc || !net.rxq.driver_area || !net.rxq.device_area)
    80007574:	68a8                	ld	a0,80(s1)
    80007576:	1e050763          	beqz	a0,80007764 <virtio_net_init+0x3ea>
    8000757a:	0006a717          	auipc	a4,0x6a
    8000757e:	1fe73703          	ld	a4,510(a4) # 80071778 <net+0x58>
    80007582:	1e070163          	beqz	a4,80007764 <virtio_net_init+0x3ea>
    80007586:	1c078f63          	beqz	a5,80007764 <virtio_net_init+0x3ea>
    panic("virtio net alloc");
  memset(net.rxq.desc, 0, PGSIZE);
    8000758a:	6605                	lui	a2,0x1
    8000758c:	4581                	li	a1,0
    8000758e:	ffffa097          	auipc	ra,0xffffa
    80007592:	89e080e7          	jalr	-1890(ra) # 80000e2c <memset>
  memset(net.rxq.free, 1, NUM);
    80007596:	0006a497          	auipc	s1,0x6a
    8000759a:	18a48493          	addi	s1,s1,394 # 80071720 <net>
    8000759e:	4621                	li	a2,8
    800075a0:	4585                	li	a1,1
    800075a2:	0006a517          	auipc	a0,0x6a
    800075a6:	1ea50513          	addi	a0,a0,490 # 8007178c <net+0x6c>
    800075aa:	ffffa097          	auipc	ra,0xffffa
    800075ae:	882080e7          	jalr	-1918(ra) # 80000e2c <memset>
  memset(net.rxq.driver_area, 0, PGSIZE);
    800075b2:	6605                	lui	a2,0x1
    800075b4:	4581                	li	a1,0
    800075b6:	6ca8                	ld	a0,88(s1)
    800075b8:	ffffa097          	auipc	ra,0xffffa
    800075bc:	874080e7          	jalr	-1932(ra) # 80000e2c <memset>
  memset(net.rxq.device_area, 0, PGSIZE);
    800075c0:	6605                	lui	a2,0x1
    800075c2:	4581                	li	a1,0
    800075c4:	70a8                	ld	a0,96(s1)
    800075c6:	ffffa097          	auipc	ra,0xffffa
    800075ca:	866080e7          	jalr	-1946(ra) # 80000e2c <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800075ce:	100027b7          	lui	a5,0x10002
    800075d2:	4721                	li	a4,8
    800075d4:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.rxq.desc;
    800075d6:	68bc                	ld	a5,80(s1)
    800075d8:	0007869b          	sext.w	a3,a5
    800075dc:	10002737          	lui	a4,0x10002
    800075e0:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.rxq.desc) >> 32;
    800075e4:	9781                	srai	a5,a5,0x20
    800075e6:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.rxq.driver_area;
    800075ea:	6cbc                	ld	a5,88(s1)
    800075ec:	0007869b          	sext.w	a3,a5
    800075f0:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.rxq.driver_area) >> 32;
    800075f4:	9781                	srai	a5,a5,0x20
    800075f6:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.rxq.device_area;
    800075fa:	70bc                	ld	a5,96(s1)
    800075fc:	0007869b          	sext.w	a3,a5
    80007600:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.rxq.device_area) >> 32;
    80007604:	9781                	srai	a5,a5,0x20
    80007606:	0af72223          	sw	a5,164(a4)
    8000760a:	4a11                	li	s4,4

  for (int i = 0; i < NUM / 2; i++) {
    int rx_hdr_desc = alloc_desc(&net.rxq);
    8000760c:	0006aa97          	auipc	s5,0x6a
    80007610:	164a8a93          	addi	s5,s5,356 # 80071770 <net+0x50>
    struct virtio_net_hdr *hdr = kalloc();
    if (!rxbuf)
      panic("rxbuf alloc failed");

    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    80007614:	4ca9                	li	s9,10
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    80007616:	4c05                	li	s8,1
    net.rxq.desc[rx_hdr_desc].next = rx_desc;

    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    net.rxq.desc[rx_desc].len = PGSIZE;
    80007618:	6b85                	lui	s7,0x1
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    8000761a:	4b09                	li	s6,2
    int rx_hdr_desc = alloc_desc(&net.rxq);
    8000761c:	8556                	mv	a0,s5
    8000761e:	00000097          	auipc	ra,0x0
    80007622:	cc6080e7          	jalr	-826(ra) # 800072e4 <alloc_desc>
    80007626:	89aa                	mv	s3,a0
    int rx_desc = alloc_desc(&net.rxq);
    80007628:	8556                	mv	a0,s5
    8000762a:	00000097          	auipc	ra,0x0
    8000762e:	cba080e7          	jalr	-838(ra) # 800072e4 <alloc_desc>
    80007632:	8daa                	mv	s11,a0
    void *rxbuf = kalloc();
    80007634:	ffff9097          	auipc	ra,0xffff9
    80007638:	5de080e7          	jalr	1502(ra) # 80000c12 <kalloc>
    8000763c:	892a                	mv	s2,a0
    struct virtio_net_hdr *hdr = kalloc();
    8000763e:	ffff9097          	auipc	ra,0xffff9
    80007642:	5d4080e7          	jalr	1492(ra) # 80000c12 <kalloc>
    if (!rxbuf)
    80007646:	12090763          	beqz	s2,80007774 <virtio_net_init+0x3fa>
    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    8000764a:	00499793          	slli	a5,s3,0x4
    8000764e:	68b8                	ld	a4,80(s1)
    80007650:	973e                	add	a4,a4,a5
    80007652:	e308                	sd	a0,0(a4)
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    80007654:	68b8                	ld	a4,80(s1)
    80007656:	973e                	add	a4,a4,a5
    80007658:	01972423          	sw	s9,8(a4)
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    8000765c:	68b8                	ld	a4,80(s1)
    8000765e:	973e                	add	a4,a4,a5
    80007660:	01871623          	sh	s8,12(a4)
    net.rxq.desc[rx_hdr_desc].next = rx_desc;
    80007664:	68b8                	ld	a4,80(s1)
    80007666:	97ba                	add	a5,a5,a4
    80007668:	01b79723          	sh	s11,14(a5) # 1000200e <_entry-0x6fffdff2>
    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    8000766c:	004d9793          	slli	a5,s11,0x4
    80007670:	68b8                	ld	a4,80(s1)
    80007672:	973e                	add	a4,a4,a5
    80007674:	01273023          	sd	s2,0(a4)
    net.rxq.desc[rx_desc].len = PGSIZE;
    80007678:	68b8                	ld	a4,80(s1)
    8000767a:	973e                	add	a4,a4,a5
    8000767c:	01772423          	sw	s7,8(a4)
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    80007680:	68b8                	ld	a4,80(s1)
    80007682:	97ba                	add	a5,a5,a4
    80007684:	01679623          	sh	s6,12(a5)

    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = rx_hdr_desc;
    80007688:	6cb8                	ld	a4,88(s1)
    8000768a:	00275783          	lhu	a5,2(a4)
    8000768e:	8b9d                	andi	a5,a5,7
    80007690:	0786                	slli	a5,a5,0x1
    80007692:	973e                	add	a4,a4,a5
    80007694:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    80007698:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    8000769c:	6cb8                	ld	a4,88(s1)
    8000769e:	00275783          	lhu	a5,2(a4)
    800076a2:	2785                	addiw	a5,a5,1
    800076a4:	00f71123          	sh	a5,2(a4)
    __sync_synchronize();
    800076a8:	0330000f          	fence	rw,rw
  for (int i = 0; i < NUM / 2; i++) {
    800076ac:	3a7d                	addiw	s4,s4,-1
    800076ae:	f60a17e3          	bnez	s4,8000761c <virtio_net_init+0x2a2>
  }

  // queue is ready
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800076b2:	100027b7          	lui	a5,0x10002
    800076b6:	4705                	li	a4,1
    800076b8:	c3f8                	sw	a4,68(a5)

  // Notify device
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_RX;
    800076ba:	0407a823          	sw	zero,80(a5) # 10002050 <_entry-0x6fffdfb0>

  // Done initializing
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800076be:	004d6d13          	ori	s10,s10,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800076c2:	07a7a823          	sw	s10,112(a5)

  // initialize packet buffer
  packet_buf = kalloc();
    800076c6:	ffff9097          	auipc	ra,0xffff9
    800076ca:	54c080e7          	jalr	1356(ra) # 80000c12 <kalloc>
    800076ce:	00008797          	auipc	a5,0x8
    800076d2:	68a7bd23          	sd	a0,1690(a5) # 8000fd68 <packet_buf>
}
    800076d6:	70a6                	ld	ra,104(sp)
    800076d8:	7406                	ld	s0,96(sp)
    800076da:	64e6                	ld	s1,88(sp)
    800076dc:	6946                	ld	s2,80(sp)
    800076de:	69a6                	ld	s3,72(sp)
    800076e0:	6a06                	ld	s4,64(sp)
    800076e2:	7ae2                	ld	s5,56(sp)
    800076e4:	7b42                	ld	s6,48(sp)
    800076e6:	7ba2                	ld	s7,40(sp)
    800076e8:	7c02                	ld	s8,32(sp)
    800076ea:	6ce2                	ld	s9,24(sp)
    800076ec:	6d42                	ld	s10,16(sp)
    800076ee:	6da2                	ld	s11,8(sp)
    800076f0:	6165                	addi	sp,sp,112
    800076f2:	8082                	ret
    panic("could not find virtio net");
    800076f4:	00004517          	auipc	a0,0x4
    800076f8:	0e450513          	addi	a0,a0,228 # 8000b7d8 <etext+0x7d8>
    800076fc:	ffff9097          	auipc	ra,0xffff9
    80007700:	e62080e7          	jalr	-414(ra) # 8000055e <panic>
    panic("virtio net FEATURES_OK unset");
    80007704:	00004517          	auipc	a0,0x4
    80007708:	0f450513          	addi	a0,a0,244 # 8000b7f8 <etext+0x7f8>
    8000770c:	ffff9097          	auipc	ra,0xffff9
    80007710:	e52080e7          	jalr	-430(ra) # 8000055e <panic>
    panic("virtio net has no queue 1 (QUEUE_TX)");
    80007714:	00004517          	auipc	a0,0x4
    80007718:	10450513          	addi	a0,a0,260 # 8000b818 <etext+0x818>
    8000771c:	ffff9097          	auipc	ra,0xffff9
    80007720:	e42080e7          	jalr	-446(ra) # 8000055e <panic>
    panic("virtio net max queue too short");
    80007724:	00004517          	auipc	a0,0x4
    80007728:	11c50513          	addi	a0,a0,284 # 8000b840 <etext+0x840>
    8000772c:	ffff9097          	auipc	ra,0xffff9
    80007730:	e32080e7          	jalr	-462(ra) # 8000055e <panic>
    panic("QUEUE_TX should not be ready\n");
    80007734:	00004517          	auipc	a0,0x4
    80007738:	12c50513          	addi	a0,a0,300 # 8000b860 <etext+0x860>
    8000773c:	ffff9097          	auipc	ra,0xffff9
    80007740:	e22080e7          	jalr	-478(ra) # 8000055e <panic>
    panic("virtio net alloc\n");
    80007744:	00004517          	auipc	a0,0x4
    80007748:	13c50513          	addi	a0,a0,316 # 8000b880 <etext+0x880>
    8000774c:	ffff9097          	auipc	ra,0xffff9
    80007750:	e12080e7          	jalr	-494(ra) # 8000055e <panic>
    panic("QUEUE_RX should not be ready\n");
    80007754:	00004517          	auipc	a0,0x4
    80007758:	14450513          	addi	a0,a0,324 # 8000b898 <etext+0x898>
    8000775c:	ffff9097          	auipc	ra,0xffff9
    80007760:	e02080e7          	jalr	-510(ra) # 8000055e <panic>
    panic("virtio net alloc");
    80007764:	00004517          	auipc	a0,0x4
    80007768:	15450513          	addi	a0,a0,340 # 8000b8b8 <etext+0x8b8>
    8000776c:	ffff9097          	auipc	ra,0xffff9
    80007770:	df2080e7          	jalr	-526(ra) # 8000055e <panic>
      panic("rxbuf alloc failed");
    80007774:	00004517          	auipc	a0,0x4
    80007778:	15c50513          	addi	a0,a0,348 # 8000b8d0 <etext+0x8d0>
    8000777c:	ffff9097          	auipc	ra,0xffff9
    80007780:	de2080e7          	jalr	-542(ra) # 8000055e <panic>

0000000080007784 <apply_padding>:
int 
apply_padding(uint8 num_bytes)
{
  uint8 *pkt_ptr =
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
  if (num_bytes > 64 - sizeof(struct virtio_net_hdr) || num_bytes < 1) {
    80007784:	fff5079b          	addiw	a5,a0,-1
    80007788:	0ff7f793          	zext.b	a5,a5
    8000778c:	03500713          	li	a4,53
    80007790:	02f76863          	bltu	a4,a5,800077c0 <apply_padding+0x3c>
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    80007794:	04a00693          	li	a3,74
    80007798:	9e89                	subw	a3,a3,a0
    8000779a:	00008717          	auipc	a4,0x8
    8000779e:	5ce73703          	ld	a4,1486(a4) # 8000fd68 <packet_buf>
    800077a2:	00e687b3          	add	a5,a3,a4
    800077a6:	0705                	addi	a4,a4,1
    800077a8:	9736                	add	a4,a4,a3
    800077aa:	357d                	addiw	a0,a0,-1
    800077ac:	1502                	slli	a0,a0,0x20
    800077ae:	9101                	srli	a0,a0,0x20
    800077b0:	972a                	add	a4,a4,a0
    printf("malformed packet data");
    return 1;
  }
  for (int i = 0; i < num_bytes; i++) {
    pkt_ptr[i] = 0;
    800077b2:	00078023          	sb	zero,0(a5)
  for (int i = 0; i < num_bytes; i++) {
    800077b6:	0785                	addi	a5,a5,1
    800077b8:	fee79de3          	bne	a5,a4,800077b2 <apply_padding+0x2e>
  }
  return 0;
    800077bc:	4501                	li	a0,0
}
    800077be:	8082                	ret
{
    800077c0:	1141                	addi	sp,sp,-16
    800077c2:	e406                	sd	ra,8(sp)
    800077c4:	e022                	sd	s0,0(sp)
    800077c6:	0800                	addi	s0,sp,16
    printf("malformed packet data");
    800077c8:	00004517          	auipc	a0,0x4
    800077cc:	12050513          	addi	a0,a0,288 # 8000b8e8 <etext+0x8e8>
    800077d0:	ffff9097          	auipc	ra,0xffff9
    800077d4:	dd8080e7          	jalr	-552(ra) # 800005a8 <printf>
    return 1;
    800077d8:	4505                	li	a0,1
}
    800077da:	60a2                	ld	ra,8(sp)
    800077dc:	6402                	ld	s0,0(sp)
    800077de:	0141                	addi	sp,sp,16
    800077e0:	8082                	ret

00000000800077e2 <transmit_packet>:
 * Output: There is no return value from the function, but the packet frame
 *         is given to the NIC to be transmitted.
 */
void 
transmit_packet(void *pkt_data, uint16 pkt_len, uint16 protocol)
{
    800077e2:	7139                	addi	sp,sp,-64
    800077e4:	fc06                	sd	ra,56(sp)
    800077e6:	f822                	sd	s0,48(sp)
    800077e8:	f426                	sd	s1,40(sp)
    800077ea:	f04a                	sd	s2,32(sp)
    800077ec:	ec4e                	sd	s3,24(sp)
    800077ee:	e852                	sd	s4,16(sp)
    800077f0:	e05a                	sd	s6,0(sp)
    800077f2:	0080                	addi	s0,sp,64
    800077f4:	84aa                	mv	s1,a0
    800077f6:	8b2e                	mv	s6,a1
  /* Create the header for transmission */

  acquire(&net.vnet_lock);
    800077f8:	0006a517          	auipc	a0,0x6a
    800077fc:	f3850513          	addi	a0,a0,-200 # 80071730 <net+0x10>
    80007800:	ffff9097          	auipc	ra,0xffff9
    80007804:	534080e7          	jalr	1332(ra) # 80000d34 <acquire>
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    80007808:	100027b7          	lui	a5,0x10002
    8000780c:	4705                	li	a4,1
    8000780e:	db98                	sw	a4,48(a5)
  // allocate for packet header and packet_frame
  struct virtio_net_hdr *hdr = kalloc();
    80007810:	ffff9097          	auipc	ra,0xffff9
    80007814:	402080e7          	jalr	1026(ra) # 80000c12 <kalloc>
  if (hdr == 0)
    80007818:	12050963          	beqz	a0,8000794a <transmit_packet+0x168>
    8000781c:	89aa                	mv	s3,a0
    panic("failed to allocate header\n");
  // initialize the header and packet
  memset(hdr, 0, PGSIZE);
    8000781e:	6605                	lui	a2,0x1
    80007820:	4581                	li	a1,0
    80007822:	ffff9097          	auipc	ra,0xffff9
    80007826:	60a080e7          	jalr	1546(ra) # 80000e2c <memset>

  int hdr_desc = alloc_desc(&net.txq);
    8000782a:	0006a517          	auipc	a0,0x6a
    8000782e:	f1e50513          	addi	a0,a0,-226 # 80071748 <net+0x28>
    80007832:	00000097          	auipc	ra,0x0
    80007836:	ab2080e7          	jalr	-1358(ra) # 800072e4 <alloc_desc>
    8000783a:	8a2a                	mv	s4,a0
  int pkt_desc = alloc_desc(&net.txq);
    8000783c:	0006a517          	auipc	a0,0x6a
    80007840:	f0c50513          	addi	a0,a0,-244 # 80071748 <net+0x28>
    80007844:	00000097          	auipc	ra,0x0
    80007848:	aa0080e7          	jalr	-1376(ra) # 800072e4 <alloc_desc>
    8000784c:	892a                	mv	s2,a0
  if (hdr_desc ==  -1 || pkt_desc == -1) {
    8000784e:	001a0793          	addi	a5,s4,1
    80007852:	10078563          	beqz	a5,8000795c <transmit_packet+0x17a>
    80007856:	00150793          	addi	a5,a0,1
    8000785a:	10078163          	beqz	a5,8000795c <transmit_packet+0x17a>
    8000785e:	e456                	sd	s5,8(sp)
    release(&net.vnet_lock);
    return;
  }

  hdr->flags = 0;
    80007860:	00098023          	sb	zero,0(s3)
  hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
    80007864:	000980a3          	sb	zero,1(s3)
  hdr->hdr_len = 0;
    80007868:	00099123          	sh	zero,2(s3)

  // populate the packet buffer
  memmove(packet_buf, pkt_data, pkt_len);
    8000786c:	00008a97          	auipc	s5,0x8
    80007870:	4fca8a93          	addi	s5,s5,1276 # 8000fd68 <packet_buf>
    80007874:	865a                	mv	a2,s6
    80007876:	85a6                	mv	a1,s1
    80007878:	000ab503          	ld	a0,0(s5)
    8000787c:	ffff9097          	auipc	ra,0xffff9
    80007880:	610080e7          	jalr	1552(ra) # 80000e8c <memmove>

  net.txq.desc[hdr_desc].flags |=
    80007884:	004a1793          	slli	a5,s4,0x4
    80007888:	0006a497          	auipc	s1,0x6a
    8000788c:	e9848493          	addi	s1,s1,-360 # 80071720 <net>
    80007890:	7498                	ld	a4,40(s1)
    80007892:	973e                	add	a4,a4,a5
    80007894:	00c75683          	lhu	a3,12(a4)
    80007898:	0016e693          	ori	a3,a3,1
    8000789c:	00d71623          	sh	a3,12(a4)
      VRING_DESC_F_NEXT; // This tells the device it's a chain
  net.txq.desc[hdr_desc].len = HDR_SIZE;
    800078a0:	7498                	ld	a4,40(s1)
    800078a2:	973e                	add	a4,a4,a5
    800078a4:	46a9                	li	a3,10
    800078a6:	c714                	sw	a3,8(a4)
  net.txq.desc[hdr_desc].addr = (uint64)hdr;
    800078a8:	7498                	ld	a4,40(s1)
    800078aa:	973e                	add	a4,a4,a5
    800078ac:	01373023          	sd	s3,0(a4)
  net.txq.desc[hdr_desc].next = pkt_desc;
    800078b0:	7498                	ld	a4,40(s1)
    800078b2:	97ba                	add	a5,a5,a4
    800078b4:	01279723          	sh	s2,14(a5) # 1000200e <_entry-0x6fffdff2>

  net.txq.desc[pkt_desc].len = 14 + pkt_len;
    800078b8:	0912                	slli	s2,s2,0x4
    800078ba:	7498                	ld	a4,40(s1)
    800078bc:	974a                	add	a4,a4,s2
    800078be:	00eb079b          	addiw	a5,s6,14 # 100e <_entry-0x7fffeff2>
    800078c2:	c71c                	sw	a5,8(a4)
  net.txq.desc[pkt_desc].addr = (uint64)packet_buf;
    800078c4:	749c                	ld	a5,40(s1)
    800078c6:	97ca                	add	a5,a5,s2
    800078c8:	000ab703          	ld	a4,0(s5)
    800078cc:	e398                	sd	a4,0(a5)
  net.txq.desc[pkt_desc].flags = 0;
    800078ce:	749c                	ld	a5,40(s1)
    800078d0:	97ca                	add	a5,a5,s2
    800078d2:	00079623          	sh	zero,12(a5)
  //   if (res != 0)
  //     panic("failed to apply padding");
  // }

  // Tell the device first index in chain of descriptors
  net.txq.driver_area->ring[net.txq.driver_area->idx % NUM] = hdr_desc;
    800078d6:	7898                	ld	a4,48(s1)
    800078d8:	00275783          	lhu	a5,2(a4)
    800078dc:	8b9d                	andi	a5,a5,7
    800078de:	0786                	slli	a5,a5,0x1
    800078e0:	973e                	add	a4,a4,a5
    800078e2:	01471223          	sh	s4,4(a4)
  __sync_synchronize();
    800078e6:	0330000f          	fence	rw,rw
  // Tell the device another avail ring entry is available
  net.txq.driver_area->idx++;
    800078ea:	7898                	ld	a4,48(s1)
    800078ec:	00275783          	lhu	a5,2(a4)
    800078f0:	2785                	addiw	a5,a5,1
    800078f2:	00f71123          	sh	a5,2(a4)
  __sync_synchronize();
    800078f6:	0330000f          	fence	rw,rw

  uint16 prev_used_idx = net.txq.device_area->idx;
    800078fa:	7c9c                	ld	a5,56(s1)
    800078fc:	0027d903          	lhu	s2,2(a5)
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_TX;
    80007900:	100027b7          	lui	a5,0x10002
    80007904:	4705                	li	a4,1
    80007906:	cbb8                	sw	a4,80(a5)
  release(&net.vnet_lock);
    80007908:	0006a517          	auipc	a0,0x6a
    8000790c:	e2850513          	addi	a0,a0,-472 # 80071730 <net+0x10>
    80007910:	ffff9097          	auipc	ra,0xffff9
    80007914:	4d4080e7          	jalr	1236(ra) # 80000de4 <release>

  // Wait for the device to use the descriptor. It indicates this by
  // decrementing the index. Polling helps to avoid race conditions
  while (net.txq.device_area->idx == prev_used_idx) {
    80007918:	7c9c                	ld	a5,56(s1)
    8000791a:	0027d783          	lhu	a5,2(a5) # 10002002 <_entry-0x6fffdffe>
    8000791e:	05279863          	bne	a5,s2,8000796e <transmit_packet+0x18c>
    80007922:	86a6                	mv	a3,s1
    80007924:	0009071b          	sext.w	a4,s2
    __sync_synchronize();
    80007928:	0330000f          	fence	rw,rw
  while (net.txq.device_area->idx == prev_used_idx) {
    8000792c:	7e9c                	ld	a5,56(a3)
    8000792e:	0027d783          	lhu	a5,2(a5)
    80007932:	fee78be3          	beq	a5,a4,80007928 <transmit_packet+0x146>
    80007936:	6aa2                	ld	s5,8(sp)
  }
}
    80007938:	70e2                	ld	ra,56(sp)
    8000793a:	7442                	ld	s0,48(sp)
    8000793c:	74a2                	ld	s1,40(sp)
    8000793e:	7902                	ld	s2,32(sp)
    80007940:	69e2                	ld	s3,24(sp)
    80007942:	6a42                	ld	s4,16(sp)
    80007944:	6b02                	ld	s6,0(sp)
    80007946:	6121                	addi	sp,sp,64
    80007948:	8082                	ret
    8000794a:	e456                	sd	s5,8(sp)
    panic("failed to allocate header\n");
    8000794c:	00004517          	auipc	a0,0x4
    80007950:	fb450513          	addi	a0,a0,-76 # 8000b900 <etext+0x900>
    80007954:	ffff9097          	auipc	ra,0xffff9
    80007958:	c0a080e7          	jalr	-1014(ra) # 8000055e <panic>
    release(&net.vnet_lock);
    8000795c:	0006a517          	auipc	a0,0x6a
    80007960:	dd450513          	addi	a0,a0,-556 # 80071730 <net+0x10>
    80007964:	ffff9097          	auipc	ra,0xffff9
    80007968:	480080e7          	jalr	1152(ra) # 80000de4 <release>
    return;
    8000796c:	b7f1                	j	80007938 <transmit_packet+0x156>
    8000796e:	6aa2                	ld	s5,8(sp)
    80007970:	b7e1                	j	80007938 <transmit_packet+0x156>

0000000080007972 <handle_packet>:

void 
handle_packet(uint8 *packet, uint len) 
{
    80007972:	7179                	addi	sp,sp,-48
    80007974:	f406                	sd	ra,40(sp)
    80007976:	f022                	sd	s0,32(sp)
    80007978:	ec26                	sd	s1,24(sp)
    8000797a:	e84a                	sd	s2,16(sp)
    8000797c:	e44e                	sd	s3,8(sp)
    8000797e:	1800                	addi	s0,sp,48
    80007980:	89aa                	mv	s3,a0
    80007982:	892e                	mv	s2,a1
    // printf("Interrupt: received packet of length %d\n", len - 10);

    struct eth_frame *eth_frame = kalloc();
    80007984:	ffff9097          	auipc	ra,0xffff9
    80007988:	28e080e7          	jalr	654(ra) # 80000c12 <kalloc>
    8000798c:	84aa                	mv	s1,a0
    memset(eth_frame, 0, PGSIZE);
    8000798e:	6605                	lui	a2,0x1
    80007990:	4581                	li	a1,0
    80007992:	ffff9097          	auipc	ra,0xffff9
    80007996:	49a080e7          	jalr	1178(ra) # 80000e2c <memset>

    if (parse_eth_packet(packet, len, eth_frame) == 0) {
    8000799a:	8626                	mv	a2,s1
    8000799c:	85ca                	mv	a1,s2
    8000799e:	854e                	mv	a0,s3
    800079a0:	00001097          	auipc	ra,0x1
    800079a4:	0f2080e7          	jalr	242(ra) # 80008a92 <parse_eth_packet>
    800079a8:	e12d                	bnez	a0,80007a0a <handle_packet+0x98>
      switch(ntohs(eth_frame->hdr.type)) {
    800079aa:	00c4c703          	lbu	a4,12(s1)
    800079ae:	00d4c783          	lbu	a5,13(s1)
    800079b2:	07a2                	slli	a5,a5,0x8
    800079b4:	00e7e6b3          	or	a3,a5,a4
    800079b8:	4721                	li	a4,8
    800079ba:	00e68e63          	beq	a3,a4,800079d6 <handle_packet+0x64>
    800079be:	2681                	sext.w	a3,a3
    800079c0:	60800793          	li	a5,1544
    800079c4:	04f69363          	bne	a3,a5,80007a0a <handle_packet+0x98>
            handle_ip4_packet(ip4_pkt);
          } 
          kfree(ip4_pkt);
          break;
        case PROTO_ARP:
          arp_recv((struct arp_pkt *)eth_frame->payload);
    800079c8:	00e48513          	addi	a0,s1,14
    800079cc:	00002097          	auipc	ra,0x2
    800079d0:	15e080e7          	jalr	350(ra) # 80009b2a <arp_recv>
          break;
      }
    }

    // kfree(eth_frame);
}
    800079d4:	a81d                	j	80007a0a <handle_packet+0x98>
          struct ip4_frame *ip4_pkt = kalloc();
    800079d6:	ffff9097          	auipc	ra,0xffff9
    800079da:	23c080e7          	jalr	572(ra) # 80000c12 <kalloc>
    800079de:	892a                	mv	s2,a0
          memset(ip4_pkt, 0, PGSIZE);
    800079e0:	6605                	lui	a2,0x1
    800079e2:	4581                	li	a1,0
    800079e4:	ffff9097          	auipc	ra,0xffff9
    800079e8:	448080e7          	jalr	1096(ra) # 80000e2c <memset>
          if (parse_ip4_packet(eth_frame->payload, eth_frame->payload_len, ip4_pkt) == 0) {
    800079ec:	864a                	mv	a2,s2
    800079ee:	5ea4c583          	lbu	a1,1514(s1)
    800079f2:	00e48513          	addi	a0,s1,14
    800079f6:	00000097          	auipc	ra,0x0
    800079fa:	22c080e7          	jalr	556(ra) # 80007c22 <parse_ip4_packet>
    800079fe:	cd09                	beqz	a0,80007a18 <handle_packet+0xa6>
          kfree(ip4_pkt);
    80007a00:	854a                	mv	a0,s2
    80007a02:	ffff9097          	auipc	ra,0xffff9
    80007a06:	0a2080e7          	jalr	162(ra) # 80000aa4 <kfree>
}
    80007a0a:	70a2                	ld	ra,40(sp)
    80007a0c:	7402                	ld	s0,32(sp)
    80007a0e:	64e2                	ld	s1,24(sp)
    80007a10:	6942                	ld	s2,16(sp)
    80007a12:	69a2                	ld	s3,8(sp)
    80007a14:	6145                	addi	sp,sp,48
    80007a16:	8082                	ret
            handle_ip4_packet(ip4_pkt);
    80007a18:	854a                	mv	a0,s2
    80007a1a:	00000097          	auipc	ra,0x0
    80007a1e:	4e2080e7          	jalr	1250(ra) # 80007efc <handle_ip4_packet>
    80007a22:	bff9                	j	80007a00 <handle_packet+0x8e>

0000000080007a24 <receive_packet>:

uint16 
receive_packet() 
{
    80007a24:	7139                	addi	sp,sp,-64
    80007a26:	fc06                	sd	ra,56(sp)
    80007a28:	f822                	sd	s0,48(sp)
    80007a2a:	f426                	sd	s1,40(sp)
    80007a2c:	0080                	addi	s0,sp,64
  acquire(&net.vnet_lock);
    80007a2e:	0006a497          	auipc	s1,0x6a
    80007a32:	cf248493          	addi	s1,s1,-782 # 80071720 <net>
    80007a36:	0006a517          	auipc	a0,0x6a
    80007a3a:	cfa50513          	addi	a0,a0,-774 # 80071730 <net+0x10>
    80007a3e:	ffff9097          	auipc	ra,0xffff9
    80007a42:	2f6080e7          	jalr	758(ra) # 80000d34 <acquire>
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    80007a46:	58fc                	lw	a5,116(s1)
    80007a48:	70b8                	ld	a4,96(s1)
    80007a4a:	00275683          	lhu	a3,2(a4)
    80007a4e:	0af68063          	beq	a3,a5,80007aee <receive_packet+0xca>
    80007a52:	f04a                	sd	s2,32(sp)
    80007a54:	ec4e                	sd	s3,24(sp)
    80007a56:	e852                	sd	s4,16(sp)
    80007a58:	e456                	sd	s5,8(sp)
    int id = e->id;
    int len = e->len - 10;

    uint8 *packet = (uint8 *)net.rxq.desc[net.rxq.desc[id].next].addr + 10;

    release(&net.vnet_lock);
    80007a5a:	0006a917          	auipc	s2,0x6a
    80007a5e:	cd690913          	addi	s2,s2,-810 # 80071730 <net+0x10>
      &net.rxq.device_area->ring[net.rxq.used_idx % NUM];
    80007a62:	41f7d69b          	sraiw	a3,a5,0x1f
    80007a66:	01d6d69b          	srliw	a3,a3,0x1d
    80007a6a:	9fb5                	addw	a5,a5,a3
    80007a6c:	8b9d                	andi	a5,a5,7
    80007a6e:	9f95                	subw	a5,a5,a3
    80007a70:	078e                	slli	a5,a5,0x3
    80007a72:	973e                	add	a4,a4,a5
    int id = e->id;
    80007a74:	00472983          	lw	s3,4(a4)
    int len = e->len - 10;
    80007a78:	00872a83          	lw	s5,8(a4)
    80007a7c:	3ad9                	addiw	s5,s5,-10
    uint8 *packet = (uint8 *)net.rxq.desc[net.rxq.desc[id].next].addr + 10;
    80007a7e:	68bc                	ld	a5,80(s1)
    80007a80:	00499713          	slli	a4,s3,0x4
    80007a84:	973e                	add	a4,a4,a5
    80007a86:	00e75703          	lhu	a4,14(a4)
    80007a8a:	0712                	slli	a4,a4,0x4
    80007a8c:	97ba                	add	a5,a5,a4
    80007a8e:	0007ba03          	ld	s4,0(a5)
    80007a92:	0a29                	addi	s4,s4,10
    release(&net.vnet_lock);
    80007a94:	854a                	mv	a0,s2
    80007a96:	ffff9097          	auipc	ra,0xffff9
    80007a9a:	34e080e7          	jalr	846(ra) # 80000de4 <release>

    handle_packet(packet, len);
    80007a9e:	85d6                	mv	a1,s5
    80007aa0:	8552                	mv	a0,s4
    80007aa2:	00000097          	auipc	ra,0x0
    80007aa6:	ed0080e7          	jalr	-304(ra) # 80007972 <handle_packet>

    acquire(&net.vnet_lock);
    80007aaa:	854a                	mv	a0,s2
    80007aac:	ffff9097          	auipc	ra,0xffff9
    80007ab0:	288080e7          	jalr	648(ra) # 80000d34 <acquire>
    // Move forward (with wrap)
    net.rxq.used_idx++;
    80007ab4:	58fc                	lw	a5,116(s1)
    80007ab6:	2785                	addiw	a5,a5,1
    80007ab8:	d8fc                	sw	a5,116(s1)

    // Requeue descriptor for future packets
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    80007aba:	6cb8                	ld	a4,88(s1)
    80007abc:	00275783          	lhu	a5,2(a4)
    80007ac0:	8b9d                	andi	a5,a5,7
    80007ac2:	0786                	slli	a5,a5,0x1
    80007ac4:	973e                	add	a4,a4,a5
    80007ac6:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    80007aca:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    80007ace:	6cb8                	ld	a4,88(s1)
    80007ad0:	00275783          	lhu	a5,2(a4)
    80007ad4:	2785                	addiw	a5,a5,1
    80007ad6:	00f71123          	sh	a5,2(a4)
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    80007ada:	58fc                	lw	a5,116(s1)
    80007adc:	70b8                	ld	a4,96(s1)
    80007ade:	00275683          	lhu	a3,2(a4)
    80007ae2:	f8f690e3          	bne	a3,a5,80007a62 <receive_packet+0x3e>
    80007ae6:	7902                	ld	s2,32(sp)
    80007ae8:	69e2                	ld	s3,24(sp)
    80007aea:	6a42                	ld	s4,16(sp)
    80007aec:	6aa2                	ld	s5,8(sp)

    // notify device if needed
    // virtio_notify(&net.rxq);
  }
  release(&net.vnet_lock);
    80007aee:	0006a517          	auipc	a0,0x6a
    80007af2:	c4250513          	addi	a0,a0,-958 # 80071730 <net+0x10>
    80007af6:	ffff9097          	auipc	ra,0xffff9
    80007afa:	2ee080e7          	jalr	750(ra) # 80000de4 <release>
  return 0;
}
    80007afe:	4501                	li	a0,0
    80007b00:	70e2                	ld	ra,56(sp)
    80007b02:	7442                	ld	s0,48(sp)
    80007b04:	74a2                	ld	s1,40(sp)
    80007b06:	6121                	addi	sp,sp,64
    80007b08:	8082                	ret

0000000080007b0a <print_ip4_packet>:
    80007b0a:	7179                	addi	sp,sp,-48
    80007b0c:	f406                	sd	ra,40(sp)
    80007b0e:	f022                	sd	s0,32(sp)
    80007b10:	ec26                	sd	s1,24(sp)
    80007b12:	1800                	addi	s0,sp,48
    80007b14:	84aa                	mv	s1,a0
    80007b16:	00003517          	auipc	a0,0x3
    80007b1a:	50a50513          	addi	a0,a0,1290 # 8000b020 <etext+0x20>
    80007b1e:	ffff9097          	auipc	ra,0xffff9
    80007b22:	a8a080e7          	jalr	-1398(ra) # 800005a8 <printf>
    80007b26:	00c4c783          	lbu	a5,12(s1)
    80007b2a:	00d4c703          	lbu	a4,13(s1)
    80007b2e:	0722                	slli	a4,a4,0x8
    80007b30:	8f5d                	or	a4,a4,a5
    80007b32:	00e4c783          	lbu	a5,14(s1)
    80007b36:	07c2                	slli	a5,a5,0x10
    80007b38:	8fd9                	or	a5,a5,a4
    80007b3a:	00f4c603          	lbu	a2,15(s1)
    80007b3e:	0662                	slli	a2,a2,0x18
    80007b40:	8e5d                	or	a2,a2,a5
    80007b42:	0104c703          	lbu	a4,16(s1)
    80007b46:	0114c683          	lbu	a3,17(s1)
    80007b4a:	06a2                	slli	a3,a3,0x8
    80007b4c:	8ed9                	or	a3,a3,a4
    80007b4e:	0124c703          	lbu	a4,18(s1)
    80007b52:	0742                	slli	a4,a4,0x10
    80007b54:	8f55                	or	a4,a4,a3
    80007b56:	0134c803          	lbu	a6,19(s1)
    80007b5a:	0862                	slli	a6,a6,0x18
    80007b5c:	00e86833          	or	a6,a6,a4
    80007b60:	01085893          	srli	a7,a6,0x10
    80007b64:	00865713          	srli	a4,a2,0x8
    80007b68:	01065693          	srli	a3,a2,0x10
    80007b6c:	0004c583          	lbu	a1,0(s1)
    80007b70:	0ff87513          	zext.b	a0,a6
    80007b74:	e42a                	sd	a0,8(sp)
    80007b76:	0088551b          	srliw	a0,a6,0x8
    80007b7a:	0ff57513          	zext.b	a0,a0
    80007b7e:	e02a                	sd	a0,0(sp)
    80007b80:	0ff8f893          	zext.b	a7,a7
    80007b84:	01885813          	srli	a6,a6,0x18
    80007b88:	0ff7f793          	zext.b	a5,a5
    80007b8c:	0ff77713          	zext.b	a4,a4
    80007b90:	0ff6f693          	zext.b	a3,a3
    80007b94:	8261                	srli	a2,a2,0x18
    80007b96:	8191                	srli	a1,a1,0x4
    80007b98:	00004517          	auipc	a0,0x4
    80007b9c:	d8850513          	addi	a0,a0,-632 # 8000b920 <etext+0x920>
    80007ba0:	ffff9097          	auipc	ra,0xffff9
    80007ba4:	a08080e7          	jalr	-1528(ra) # 800005a8 <printf>
    80007ba8:	0094c783          	lbu	a5,9(s1)
    80007bac:	4719                	li	a4,6
    80007bae:	00e78e63          	beq	a5,a4,80007bca <print_ip4_packet+0xc0>
    80007bb2:	4745                	li	a4,17
    80007bb4:	04e78e63          	beq	a5,a4,80007c10 <print_ip4_packet+0x106>
    80007bb8:	00004517          	auipc	a0,0x4
    80007bbc:	db850513          	addi	a0,a0,-584 # 8000b970 <etext+0x970>
    80007bc0:	ffff9097          	auipc	ra,0xffff9
    80007bc4:	9e8080e7          	jalr	-1560(ra) # 800005a8 <printf>
    80007bc8:	a809                	j	80007bda <print_ip4_packet+0xd0>
    80007bca:	00004517          	auipc	a0,0x4
    80007bce:	d8650513          	addi	a0,a0,-634 # 8000b950 <etext+0x950>
    80007bd2:	ffff9097          	auipc	ra,0xffff9
    80007bd6:	9d6080e7          	jalr	-1578(ra) # 800005a8 <printf>
    80007bda:	5f04c583          	lbu	a1,1520(s1)
    80007bde:	5f14c783          	lbu	a5,1521(s1)
    80007be2:	07a2                	slli	a5,a5,0x8
    80007be4:	8ddd                	or	a1,a1,a5
    80007be6:	00004517          	auipc	a0,0x4
    80007bea:	da250513          	addi	a0,a0,-606 # 8000b988 <etext+0x988>
    80007bee:	ffff9097          	auipc	ra,0xffff9
    80007bf2:	9ba080e7          	jalr	-1606(ra) # 800005a8 <printf>
    80007bf6:	00003517          	auipc	a0,0x3
    80007bfa:	42a50513          	addi	a0,a0,1066 # 8000b020 <etext+0x20>
    80007bfe:	ffff9097          	auipc	ra,0xffff9
    80007c02:	9aa080e7          	jalr	-1622(ra) # 800005a8 <printf>
    80007c06:	70a2                	ld	ra,40(sp)
    80007c08:	7402                	ld	s0,32(sp)
    80007c0a:	64e2                	ld	s1,24(sp)
    80007c0c:	6145                	addi	sp,sp,48
    80007c0e:	8082                	ret
    80007c10:	00004517          	auipc	a0,0x4
    80007c14:	d5050513          	addi	a0,a0,-688 # 8000b960 <etext+0x960>
    80007c18:	ffff9097          	auipc	ra,0xffff9
    80007c1c:	990080e7          	jalr	-1648(ra) # 800005a8 <printf>
    80007c20:	bf6d                	j	80007bda <print_ip4_packet+0xd0>

0000000080007c22 <parse_ip4_packet>:
    80007c22:	87b2                	mv	a5,a2
    80007c24:	00054703          	lbu	a4,0(a0)
    80007c28:	00e60023          	sb	a4,0(a2) # 1000 <_entry-0x7ffff000>
    80007c2c:	00154703          	lbu	a4,1(a0)
    80007c30:	00e600a3          	sb	a4,1(a2)
    80007c34:	00255703          	lhu	a4,2(a0)
    80007c38:	00875693          	srli	a3,a4,0x8
    80007c3c:	00d60123          	sb	a3,2(a2)
    80007c40:	00e601a3          	sb	a4,3(a2)
    80007c44:	00455703          	lhu	a4,4(a0)
    80007c48:	00875693          	srli	a3,a4,0x8
    80007c4c:	00d60223          	sb	a3,4(a2)
    80007c50:	00e602a3          	sb	a4,5(a2)
    80007c54:	00655703          	lhu	a4,6(a0)
    80007c58:	00875693          	srli	a3,a4,0x8
    80007c5c:	00d60323          	sb	a3,6(a2)
    80007c60:	00e603a3          	sb	a4,7(a2)
    80007c64:	00854703          	lbu	a4,8(a0)
    80007c68:	00e60423          	sb	a4,8(a2)
    80007c6c:	00954703          	lbu	a4,9(a0)
    80007c70:	00e604a3          	sb	a4,9(a2)
    80007c74:	00a55703          	lhu	a4,10(a0)
    80007c78:	00875693          	srli	a3,a4,0x8
    80007c7c:	00d60523          	sb	a3,10(a2)
    80007c80:	00e605a3          	sb	a4,11(a2)
    80007c84:	4558                	lw	a4,12(a0)
    80007c86:	0187169b          	slliw	a3,a4,0x18
    80007c8a:	0187561b          	srliw	a2,a4,0x18
    80007c8e:	8ed1                	or	a3,a3,a2
    80007c90:	0087161b          	slliw	a2,a4,0x8
    80007c94:	00ff0837          	lui	a6,0xff0
    80007c98:	01067633          	and	a2,a2,a6
    80007c9c:	8ed1                	or	a3,a3,a2
    80007c9e:	0087571b          	srliw	a4,a4,0x8
    80007ca2:	6641                	lui	a2,0x10
    80007ca4:	f0060613          	addi	a2,a2,-256 # ff00 <_entry-0x7fff0100>
    80007ca8:	8f71                	and	a4,a4,a2
    80007caa:	00d78623          	sb	a3,12(a5)
    80007cae:	8321                	srli	a4,a4,0x8
    80007cb0:	00e786a3          	sb	a4,13(a5)
    80007cb4:	0106d71b          	srliw	a4,a3,0x10
    80007cb8:	00e78723          	sb	a4,14(a5)
    80007cbc:	0186d69b          	srliw	a3,a3,0x18
    80007cc0:	00d787a3          	sb	a3,15(a5)
    80007cc4:	4918                	lw	a4,16(a0)
    80007cc6:	0187169b          	slliw	a3,a4,0x18
    80007cca:	0187589b          	srliw	a7,a4,0x18
    80007cce:	0116e6b3          	or	a3,a3,a7
    80007cd2:	0087189b          	slliw	a7,a4,0x8
    80007cd6:	0108f8b3          	and	a7,a7,a6
    80007cda:	0116e6b3          	or	a3,a3,a7
    80007cde:	0087571b          	srliw	a4,a4,0x8
    80007ce2:	8f71                	and	a4,a4,a2
    80007ce4:	00d78823          	sb	a3,16(a5)
    80007ce8:	8321                	srli	a4,a4,0x8
    80007cea:	00e788a3          	sb	a4,17(a5)
    80007cee:	0106d71b          	srliw	a4,a3,0x10
    80007cf2:	00e78923          	sb	a4,18(a5)
    80007cf6:	0186d69b          	srliw	a3,a3,0x18
    80007cfa:	00d789a3          	sb	a3,19(a5)
    80007cfe:	00054883          	lbu	a7,0(a0)
    80007d02:	01178023          	sb	a7,0(a5)
    80007d06:	00154703          	lbu	a4,1(a0)
    80007d0a:	00e780a3          	sb	a4,1(a5)
    80007d0e:	00255683          	lhu	a3,2(a0)
    80007d12:	0086d713          	srli	a4,a3,0x8
    80007d16:	0086969b          	slliw	a3,a3,0x8
    80007d1a:	8f55                	or	a4,a4,a3
    80007d1c:	03071313          	slli	t1,a4,0x30
    80007d20:	03035313          	srli	t1,t1,0x30
    80007d24:	00e78123          	sb	a4,2(a5)
    80007d28:	00835713          	srli	a4,t1,0x8
    80007d2c:	00e781a3          	sb	a4,3(a5)
    80007d30:	00455703          	lhu	a4,4(a0)
    80007d34:	00875693          	srli	a3,a4,0x8
    80007d38:	00d78223          	sb	a3,4(a5)
    80007d3c:	00e782a3          	sb	a4,5(a5)
    80007d40:	00655703          	lhu	a4,6(a0)
    80007d44:	00875693          	srli	a3,a4,0x8
    80007d48:	00d78323          	sb	a3,6(a5)
    80007d4c:	00e783a3          	sb	a4,7(a5)
    80007d50:	00854703          	lbu	a4,8(a0)
    80007d54:	00e78423          	sb	a4,8(a5)
    80007d58:	00954703          	lbu	a4,9(a0)
    80007d5c:	00e784a3          	sb	a4,9(a5)
    80007d60:	00a55703          	lhu	a4,10(a0)
    80007d64:	00875693          	srli	a3,a4,0x8
    80007d68:	00d78523          	sb	a3,10(a5)
    80007d6c:	00e785a3          	sb	a4,11(a5)
    80007d70:	4558                	lw	a4,12(a0)
    80007d72:	0187169b          	slliw	a3,a4,0x18
    80007d76:	01875e1b          	srliw	t3,a4,0x18
    80007d7a:	01c6e6b3          	or	a3,a3,t3
    80007d7e:	00871e1b          	slliw	t3,a4,0x8
    80007d82:	010e7e33          	and	t3,t3,a6
    80007d86:	01c6e6b3          	or	a3,a3,t3
    80007d8a:	0087571b          	srliw	a4,a4,0x8
    80007d8e:	8f71                	and	a4,a4,a2
    80007d90:	00d78623          	sb	a3,12(a5)
    80007d94:	8321                	srli	a4,a4,0x8
    80007d96:	00e786a3          	sb	a4,13(a5)
    80007d9a:	0106d71b          	srliw	a4,a3,0x10
    80007d9e:	00e78723          	sb	a4,14(a5)
    80007da2:	0186d69b          	srliw	a3,a3,0x18
    80007da6:	00d787a3          	sb	a3,15(a5)
    80007daa:	4918                	lw	a4,16(a0)
    80007dac:	0187569b          	srliw	a3,a4,0x18
    80007db0:	01871e1b          	slliw	t3,a4,0x18
    80007db4:	01c6e6b3          	or	a3,a3,t3
    80007db8:	00871e1b          	slliw	t3,a4,0x8
    80007dbc:	010e7833          	and	a6,t3,a6
    80007dc0:	0106e6b3          	or	a3,a3,a6
    80007dc4:	0087571b          	srliw	a4,a4,0x8
    80007dc8:	8f71                	and	a4,a4,a2
    80007dca:	00d78823          	sb	a3,16(a5)
    80007dce:	8321                	srli	a4,a4,0x8
    80007dd0:	00e788a3          	sb	a4,17(a5)
    80007dd4:	0106d71b          	srliw	a4,a3,0x10
    80007dd8:	00e78923          	sb	a4,18(a5)
    80007ddc:	0186d69b          	srliw	a3,a3,0x18
    80007de0:	00d789a3          	sb	a3,19(a5)
    80007de4:	00f8f713          	andi	a4,a7,15
    80007de8:	0027171b          	slliw	a4,a4,0x2
    80007dec:	464d                	li	a2,19
    80007dee:	04e65263          	bge	a2,a4,80007e32 <parse_ip4_packet+0x210>
    80007df2:	04e5c263          	blt	a1,a4,80007e36 <parse_ip4_packet+0x214>
    80007df6:	2301                	sext.w	t1,t1
    80007df8:	0465c163          	blt	a1,t1,80007e3a <parse_ip4_packet+0x218>
    80007dfc:	1141                	addi	sp,sp,-16
    80007dfe:	e406                	sd	ra,8(sp)
    80007e00:	e022                	sd	s0,0(sp)
    80007e02:	0800                	addi	s0,sp,16
    80007e04:	9d99                	subw	a1,a1,a4
    80007e06:	03059613          	slli	a2,a1,0x30
    80007e0a:	9241                	srli	a2,a2,0x30
    80007e0c:	5eb78823          	sb	a1,1520(a5)
    80007e10:	00865693          	srli	a3,a2,0x8
    80007e14:	5ed788a3          	sb	a3,1521(a5)
    80007e18:	00e505b3          	add	a1,a0,a4
    80007e1c:	01478513          	addi	a0,a5,20
    80007e20:	ffff9097          	auipc	ra,0xffff9
    80007e24:	06c080e7          	jalr	108(ra) # 80000e8c <memmove>
    80007e28:	4501                	li	a0,0
    80007e2a:	60a2                	ld	ra,8(sp)
    80007e2c:	6402                	ld	s0,0(sp)
    80007e2e:	0141                	addi	sp,sp,16
    80007e30:	8082                	ret
    80007e32:	557d                	li	a0,-1
    80007e34:	8082                	ret
    80007e36:	557d                	li	a0,-1
    80007e38:	8082                	ret
    80007e3a:	557d                	li	a0,-1
    80007e3c:	8082                	ret

0000000080007e3e <build_ip4>:
    80007e3e:	1141                	addi	sp,sp,-16
    80007e40:	e406                	sd	ra,8(sp)
    80007e42:	e022                	sd	s0,0(sp)
    80007e44:	0800                	addi	s0,sp,16
    80007e46:	04500793          	li	a5,69
    80007e4a:	00f50023          	sb	a5,0(a0)
    80007e4e:	000500a3          	sb	zero,1(a0)
    80007e52:	0087579b          	srliw	a5,a4,0x8
    80007e56:	00f50123          	sb	a5,2(a0)
    80007e5a:	00e501a3          	sb	a4,3(a0)
    80007e5e:	00050223          	sb	zero,4(a0)
    80007e62:	000502a3          	sb	zero,5(a0)
    80007e66:	00050323          	sb	zero,6(a0)
    80007e6a:	000503a3          	sb	zero,7(a0)
    80007e6e:	04000793          	li	a5,64
    80007e72:	00f50423          	sb	a5,8(a0)
    80007e76:	00d504a3          	sb	a3,9(a0)
    80007e7a:	00050523          	sb	zero,10(a0)
    80007e7e:	000505a3          	sb	zero,11(a0)
    80007e82:	0185979b          	slliw	a5,a1,0x18
    80007e86:	0185d71b          	srliw	a4,a1,0x18
    80007e8a:	8fd9                	or	a5,a5,a4
    80007e8c:	0085971b          	slliw	a4,a1,0x8
    80007e90:	00ff0837          	lui	a6,0xff0
    80007e94:	01077733          	and	a4,a4,a6
    80007e98:	8fd9                	or	a5,a5,a4
    80007e9a:	0085d59b          	srliw	a1,a1,0x8
    80007e9e:	6741                	lui	a4,0x10
    80007ea0:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80007ea4:	8df9                	and	a1,a1,a4
    80007ea6:	00f50623          	sb	a5,12(a0)
    80007eaa:	81a1                	srli	a1,a1,0x8
    80007eac:	00b506a3          	sb	a1,13(a0)
    80007eb0:	0107d69b          	srliw	a3,a5,0x10
    80007eb4:	00d50723          	sb	a3,14(a0)
    80007eb8:	0187d79b          	srliw	a5,a5,0x18
    80007ebc:	00f507a3          	sb	a5,15(a0)
    80007ec0:	0186179b          	slliw	a5,a2,0x18
    80007ec4:	0186569b          	srliw	a3,a2,0x18
    80007ec8:	8fd5                	or	a5,a5,a3
    80007eca:	0086169b          	slliw	a3,a2,0x8
    80007ece:	0106f6b3          	and	a3,a3,a6
    80007ed2:	8fd5                	or	a5,a5,a3
    80007ed4:	0086561b          	srliw	a2,a2,0x8
    80007ed8:	8e79                	and	a2,a2,a4
    80007eda:	00f50823          	sb	a5,16(a0)
    80007ede:	8221                	srli	a2,a2,0x8
    80007ee0:	00c508a3          	sb	a2,17(a0)
    80007ee4:	0107d71b          	srliw	a4,a5,0x10
    80007ee8:	00e50923          	sb	a4,18(a0)
    80007eec:	0187d79b          	srliw	a5,a5,0x18
    80007ef0:	00f509a3          	sb	a5,19(a0)
    80007ef4:	60a2                	ld	ra,8(sp)
    80007ef6:	6402                	ld	s0,0(sp)
    80007ef8:	0141                	addi	sp,sp,16
    80007efa:	8082                	ret

0000000080007efc <handle_ip4_packet>:
    80007efc:	1101                	addi	sp,sp,-32
    80007efe:	ec06                	sd	ra,24(sp)
    80007f00:	e822                	sd	s0,16(sp)
    80007f02:	e426                	sd	s1,8(sp)
    80007f04:	1000                	addi	s0,sp,32
    80007f06:	84aa                	mv	s1,a0
    80007f08:	00954583          	lbu	a1,9(a0)
    80007f0c:	4799                	li	a5,6
    80007f0e:	02f58363          	beq	a1,a5,80007f34 <handle_ip4_packet+0x38>
    80007f12:	47c5                	li	a5,17
    80007f14:	06f58363          	beq	a1,a5,80007f7a <handle_ip4_packet+0x7e>
    80007f18:	00004517          	auipc	a0,0x4
    80007f1c:	a8850513          	addi	a0,a0,-1400 # 8000b9a0 <etext+0x9a0>
    80007f20:	ffff8097          	auipc	ra,0xffff8
    80007f24:	688080e7          	jalr	1672(ra) # 800005a8 <printf>
    80007f28:	4501                	li	a0,0
    80007f2a:	60e2                	ld	ra,24(sp)
    80007f2c:	6442                	ld	s0,16(sp)
    80007f2e:	64a2                	ld	s1,8(sp)
    80007f30:	6105                	addi	sp,sp,32
    80007f32:	8082                	ret
    80007f34:	e04a                	sd	s2,0(sp)
    80007f36:	ffff9097          	auipc	ra,0xffff9
    80007f3a:	cdc080e7          	jalr	-804(ra) # 80000c12 <kalloc>
    80007f3e:	892a                	mv	s2,a0
    80007f40:	6605                	lui	a2,0x1
    80007f42:	4581                	li	a1,0
    80007f44:	ffff9097          	auipc	ra,0xffff9
    80007f48:	ee8080e7          	jalr	-280(ra) # 80000e2c <memset>
    80007f4c:	5f04c583          	lbu	a1,1520(s1)
    80007f50:	5f14c783          	lbu	a5,1521(s1)
    80007f54:	07a2                	slli	a5,a5,0x8
    80007f56:	864a                	mv	a2,s2
    80007f58:	8ddd                	or	a1,a1,a5
    80007f5a:	01448513          	addi	a0,s1,20
    80007f5e:	00001097          	auipc	ra,0x1
    80007f62:	f0e080e7          	jalr	-242(ra) # 80008e6c <parse_tcp_packet>
    80007f66:	c119                	beqz	a0,80007f6c <handle_ip4_packet+0x70>
    80007f68:	6902                	ld	s2,0(sp)
    80007f6a:	bf7d                	j	80007f28 <handle_ip4_packet+0x2c>
    80007f6c:	854a                	mv	a0,s2
    80007f6e:	00001097          	auipc	ra,0x1
    80007f72:	19c080e7          	jalr	412(ra) # 8000910a <handle_tcp_packet>
    80007f76:	6902                	ld	s2,0(sp)
    80007f78:	bf45                	j	80007f28 <handle_ip4_packet+0x2c>
    80007f7a:	e04a                	sd	s2,0(sp)
    80007f7c:	ffff9097          	auipc	ra,0xffff9
    80007f80:	c96080e7          	jalr	-874(ra) # 80000c12 <kalloc>
    80007f84:	892a                	mv	s2,a0
    80007f86:	6605                	lui	a2,0x1
    80007f88:	4581                	li	a1,0
    80007f8a:	ffff9097          	auipc	ra,0xffff9
    80007f8e:	ea2080e7          	jalr	-350(ra) # 80000e2c <memset>
    80007f92:	5f04c583          	lbu	a1,1520(s1)
    80007f96:	5f14c783          	lbu	a5,1521(s1)
    80007f9a:	07a2                	slli	a5,a5,0x8
    80007f9c:	864a                	mv	a2,s2
    80007f9e:	8ddd                	or	a1,a1,a5
    80007fa0:	01448513          	addi	a0,s1,20
    80007fa4:	00002097          	auipc	ra,0x2
    80007fa8:	8c4080e7          	jalr	-1852(ra) # 80009868 <parse_udp_packet>
    80007fac:	c119                	beqz	a0,80007fb2 <handle_ip4_packet+0xb6>
    80007fae:	6902                	ld	s2,0(sp)
    80007fb0:	bfa5                	j	80007f28 <handle_ip4_packet+0x2c>
    80007fb2:	854a                	mv	a0,s2
    80007fb4:	00001097          	auipc	ra,0x1
    80007fb8:	7e6080e7          	jalr	2022(ra) # 8000979a <handle_udp_packet>
    80007fbc:	6902                	ld	s2,0(sp)
    80007fbe:	b7ad                	j	80007f28 <handle_ip4_packet+0x2c>

0000000080007fc0 <my_strlen>:
    80007fc0:	1141                	addi	sp,sp,-16
    80007fc2:	e406                	sd	ra,8(sp)
    80007fc4:	e022                	sd	s0,0(sp)
    80007fc6:	0800                	addi	s0,sp,16
    80007fc8:	00054703          	lbu	a4,0(a0)
    80007fcc:	0505                	addi	a0,a0,1
    80007fce:	87aa                	mv	a5,a0
    80007fd0:	cf09                	beqz	a4,80007fea <my_strlen+0x2a>
    80007fd2:	86be                	mv	a3,a5
    80007fd4:	0785                	addi	a5,a5,1
    80007fd6:	fff7c703          	lbu	a4,-1(a5)
    80007fda:	ff65                	bnez	a4,80007fd2 <my_strlen+0x12>
    80007fdc:	40a6853b          	subw	a0,a3,a0
    80007fe0:	2505                	addiw	a0,a0,1
    80007fe2:	60a2                	ld	ra,8(sp)
    80007fe4:	6402                	ld	s0,0(sp)
    80007fe6:	0141                	addi	sp,sp,16
    80007fe8:	8082                	ret
    80007fea:	4501                	li	a0,0
    80007fec:	bfdd                	j	80007fe2 <my_strlen+0x22>

0000000080007fee <getaddrinfo>:
    80007fee:	1141                	addi	sp,sp,-16
    80007ff0:	e406                	sd	ra,8(sp)
    80007ff2:	e022                	sd	s0,0(sp)
    80007ff4:	0800                	addi	s0,sp,16
    80007ff6:	4501                	li	a0,0
    80007ff8:	60a2                	ld	ra,8(sp)
    80007ffa:	6402                	ld	s0,0(sp)
    80007ffc:	0141                	addi	sp,sp,16
    80007ffe:	8082                	ret

0000000080008000 <freeaddrinfo>:
    80008000:	1141                	addi	sp,sp,-16
    80008002:	e406                	sd	ra,8(sp)
    80008004:	e022                	sd	s0,0(sp)
    80008006:	0800                	addi	s0,sp,16
    80008008:	4501                	li	a0,0
    8000800a:	60a2                	ld	ra,8(sp)
    8000800c:	6402                	ld	s0,0(sp)
    8000800e:	0141                	addi	sp,sp,16
    80008010:	8082                	ret

0000000080008012 <ip_to_u32>:
    80008012:	1101                	addi	sp,sp,-32
    80008014:	ec06                	sd	ra,24(sp)
    80008016:	e822                	sd	s0,16(sp)
    80008018:	1000                	addi	s0,sp,32
    8000801a:	fe043023          	sd	zero,-32(s0)
    8000801e:	fe043423          	sd	zero,-24(s0)
    80008022:	00054783          	lbu	a5,0(a0)
    80008026:	c3d5                	beqz	a5,800080ca <ip_to_u32+0xb8>
    80008028:	fe040813          	addi	a6,s0,-32
    8000802c:	4581                	li	a1,0
    8000802e:	4625                	li	a2,9
    80008030:	0ff00313          	li	t1,255
    80008034:	02e00893          	li	a7,46
    80008038:	4e11                	li	t3,4
    8000803a:	a801                	j	8000804a <ip_to_u32+0x38>
    8000803c:	0505                	addi	a0,a0,1
    8000803e:	00054783          	lbu	a5,0(a0)
    80008042:	cfbd                	beqz	a5,800080c0 <ip_to_u32+0xae>
    80008044:	0811                	addi	a6,a6,4 # ff0004 <_entry-0x7f00fffc>
    80008046:	05c58863          	beq	a1,t3,80008096 <ip_to_u32+0x84>
    8000804a:	00054703          	lbu	a4,0(a0)
    8000804e:	fd07079b          	addiw	a5,a4,-48
    80008052:	0ff7f793          	zext.b	a5,a5
    80008056:	4681                	li	a3,0
    80008058:	02f66663          	bltu	a2,a5,80008084 <ip_to_u32+0x72>
    8000805c:	0026979b          	slliw	a5,a3,0x2
    80008060:	9fb5                	addw	a5,a5,a3
    80008062:	0017979b          	slliw	a5,a5,0x1
    80008066:	fd07071b          	addiw	a4,a4,-48
    8000806a:	00f706bb          	addw	a3,a4,a5
    8000806e:	0505                	addi	a0,a0,1
    80008070:	00054703          	lbu	a4,0(a0)
    80008074:	fd07079b          	addiw	a5,a4,-48
    80008078:	0ff7f793          	zext.b	a5,a5
    8000807c:	fef670e3          	bgeu	a2,a5,8000805c <ip_to_u32+0x4a>
    80008080:	04d36763          	bltu	t1,a3,800080ce <ip_to_u32+0xbc>
    80008084:	2585                	addiw	a1,a1,1
    80008086:	00d82023          	sw	a3,0(a6)
    8000808a:	fb1709e3          	beq	a4,a7,8000803c <ip_to_u32+0x2a>
    8000808e:	db45                	beqz	a4,8000803e <ip_to_u32+0x2c>
    80008090:	478d                	li	a5,3
    80008092:	04b7d063          	bge	a5,a1,800080d2 <ip_to_u32+0xc0>
    80008096:	fe042783          	lw	a5,-32(s0)
    8000809a:	0187979b          	slliw	a5,a5,0x18
    8000809e:	fe442703          	lw	a4,-28(s0)
    800080a2:	0107171b          	slliw	a4,a4,0x10
    800080a6:	8fd9                	or	a5,a5,a4
    800080a8:	fec42703          	lw	a4,-20(s0)
    800080ac:	8fd9                	or	a5,a5,a4
    800080ae:	fe842503          	lw	a0,-24(s0)
    800080b2:	0085151b          	slliw	a0,a0,0x8
    800080b6:	8d5d                	or	a0,a0,a5
    800080b8:	60e2                	ld	ra,24(sp)
    800080ba:	6442                	ld	s0,16(sp)
    800080bc:	6105                	addi	sp,sp,32
    800080be:	8082                	ret
    800080c0:	4791                	li	a5,4
    800080c2:	fcf58ae3          	beq	a1,a5,80008096 <ip_to_u32+0x84>
    800080c6:	557d                	li	a0,-1
    800080c8:	bfc5                	j	800080b8 <ip_to_u32+0xa6>
    800080ca:	557d                	li	a0,-1
    800080cc:	b7f5                	j	800080b8 <ip_to_u32+0xa6>
    800080ce:	557d                	li	a0,-1
    800080d0:	b7e5                	j	800080b8 <ip_to_u32+0xa6>
    800080d2:	557d                	li	a0,-1
    800080d4:	b7d5                	j	800080b8 <ip_to_u32+0xa6>

00000000800080d6 <node_to_dns>:
    800080d6:	1101                	addi	sp,sp,-32
    800080d8:	ec06                	sd	ra,24(sp)
    800080da:	e822                	sd	s0,16(sp)
    800080dc:	e426                	sd	s1,8(sp)
    800080de:	e04a                	sd	s2,0(sp)
    800080e0:	1000                	addi	s0,sp,32
    800080e2:	892a                	mv	s2,a0
    800080e4:	84ae                	mv	s1,a1
    800080e6:	00000097          	auipc	ra,0x0
    800080ea:	eda080e7          	jalr	-294(ra) # 80007fc0 <my_strlen>
    800080ee:	0fd00793          	li	a5,253
    800080f2:	06a7c363          	blt	a5,a0,80008158 <node_to_dns+0x82>
    800080f6:	4785                	li	a5,1
    800080f8:	4601                	li	a2,0
    800080fa:	02e00813          	li	a6,46
    800080fe:	04000893          	li	a7,64
    80008102:	02055463          	bgez	a0,8000812a <node_to_dns+0x54>
    80008106:	94aa                	add	s1,s1,a0
    80008108:	000480a3          	sb	zero,1(s1)
    8000810c:	4501                	li	a0,0
    8000810e:	a0b1                	j	8000815a <node_to_dns+0x84>
    80008110:	00c485b3          	add	a1,s1,a2
    80008114:	fff7871b          	addiw	a4,a5,-1
    80008118:	9f11                	subw	a4,a4,a2
    8000811a:	00e58023          	sb	a4,0(a1)
    8000811e:	0007871b          	sext.w	a4,a5
    80008122:	fee542e3          	blt	a0,a4,80008106 <node_to_dns+0x30>
    80008126:	0785                	addi	a5,a5,1
    80008128:	8636                	mv	a2,a3
    8000812a:	0007869b          	sext.w	a3,a5
    8000812e:	00f90733          	add	a4,s2,a5
    80008132:	fff74703          	lbu	a4,-1(a4)
    80008136:	fd070de3          	beq	a4,a6,80008110 <node_to_dns+0x3a>
    8000813a:	db79                	beqz	a4,80008110 <node_to_dns+0x3a>
    8000813c:	00f485b3          	add	a1,s1,a5
    80008140:	00e58023          	sb	a4,0(a1)
    80008144:	0007871b          	sext.w	a4,a5
    80008148:	fae54fe3          	blt	a0,a4,80008106 <node_to_dns+0x30>
    8000814c:	0785                	addi	a5,a5,1
    8000814e:	9e91                	subw	a3,a3,a2
    80008150:	fd169de3          	bne	a3,a7,8000812a <node_to_dns+0x54>
    80008154:	4509                	li	a0,2
    80008156:	a011                	j	8000815a <node_to_dns+0x84>
    80008158:	4505                	li	a0,1
    8000815a:	60e2                	ld	ra,24(sp)
    8000815c:	6442                	ld	s0,16(sp)
    8000815e:	64a2                	ld	s1,8(sp)
    80008160:	6902                	ld	s2,0(sp)
    80008162:	6105                	addi	sp,sp,32
    80008164:	8082                	ret

0000000080008166 <net_init>:
    80008166:	1141                	addi	sp,sp,-16
    80008168:	e406                	sd	ra,8(sp)
    8000816a:	e022                	sd	s0,0(sp)
    8000816c:	0800                	addi	s0,sp,16
    8000816e:	00069797          	auipc	a5,0x69
    80008172:	5b278793          	addi	a5,a5,1458 # 80071720 <net>
    80008176:	00008717          	auipc	a4,0x8
    8000817a:	b3670713          	addi	a4,a4,-1226 # 8000fcac <netconf+0x4>
    8000817e:	00069617          	auipc	a2,0x69
    80008182:	5a860613          	addi	a2,a2,1448 # 80071726 <net+0x6>
    80008186:	0007c683          	lbu	a3,0(a5)
    8000818a:	00d70023          	sb	a3,0(a4)
    8000818e:	0785                	addi	a5,a5,1
    80008190:	0705                	addi	a4,a4,1
    80008192:	fec79ae3          	bne	a5,a2,80008186 <net_init+0x20>
    80008196:	00008597          	auipc	a1,0x8
    8000819a:	b1658593          	addi	a1,a1,-1258 # 8000fcac <netconf+0x4>
    8000819e:	89feb537          	lui	a0,0x89feb
    800081a2:	8c050513          	addi	a0,a0,-1856 # ffffffff89fea8c0 <end+0xffffffff09f77028>
    800081a6:	00001097          	auipc	ra,0x1
    800081aa:	7d0080e7          	jalr	2000(ra) # 80009976 <arp_insert>
    800081ae:	4501                	li	a0,0
    800081b0:	60a2                	ld	ra,8(sp)
    800081b2:	6402                	ld	s0,0(sp)
    800081b4:	0141                	addi	sp,sp,16
    800081b6:	8082                	ret

00000000800081b8 <insert_port_binding>:
    800081b8:	1141                	addi	sp,sp,-16
    800081ba:	e406                	sd	ra,8(sp)
    800081bc:	e022                	sd	s0,0(sp)
    800081be:	0800                	addi	s0,sp,16
    800081c0:	651c                	ld	a5,8(a0)
    800081c2:	5b9c                	lw	a5,48(a5)
    800081c4:	4719                	li	a4,6
    800081c6:	00e78a63          	beq	a5,a4,800081da <insert_port_binding+0x22>
    800081ca:	4745                	li	a4,17
    800081cc:	02e78163          	beq	a5,a4,800081ee <insert_port_binding+0x36>
    800081d0:	4501                	li	a0,0
    800081d2:	60a2                	ld	ra,8(sp)
    800081d4:	6402                	ld	s0,0(sp)
    800081d6:	0141                	addi	sp,sp,16
    800081d8:	8082                	ret
    800081da:	00255703          	lhu	a4,2(a0)
    800081de:	070e                	slli	a4,a4,0x3
    800081e0:	00069797          	auipc	a5,0x69
    800081e4:	5b878793          	addi	a5,a5,1464 # 80071798 <tcp_port_binds>
    800081e8:	97ba                	add	a5,a5,a4
    800081ea:	e388                	sd	a0,0(a5)
    800081ec:	b7d5                	j	800081d0 <insert_port_binding+0x18>
    800081ee:	00255703          	lhu	a4,2(a0)
    800081f2:	070e                	slli	a4,a4,0x3
    800081f4:	0006a797          	auipc	a5,0x6a
    800081f8:	5a478793          	addi	a5,a5,1444 # 80072798 <udp_port_binds>
    800081fc:	97ba                	add	a5,a5,a4
    800081fe:	e388                	sd	a0,0(a5)
    80008200:	bfc1                	j	800081d0 <insert_port_binding+0x18>

0000000080008202 <remove_port_binding>:
    80008202:	1141                	addi	sp,sp,-16
    80008204:	e406                	sd	ra,8(sp)
    80008206:	e022                	sd	s0,0(sp)
    80008208:	0800                	addi	s0,sp,16
    8000820a:	87aa                	mv	a5,a0
    8000820c:	6518                	ld	a4,8(a0)
    8000820e:	5b18                	lw	a4,48(a4)
    80008210:	4699                	li	a3,6
    80008212:	00d70a63          	beq	a4,a3,80008226 <remove_port_binding+0x24>
    80008216:	46c5                	li	a3,17
    80008218:	4501                	li	a0,0
    8000821a:	02d70a63          	beq	a4,a3,8000824e <remove_port_binding+0x4c>
    8000821e:	60a2                	ld	ra,8(sp)
    80008220:	6402                	ld	s0,0(sp)
    80008222:	0141                	addi	sp,sp,16
    80008224:	8082                	ret
    80008226:	00255703          	lhu	a4,2(a0)
    8000822a:	00371613          	slli	a2,a4,0x3
    8000822e:	00069697          	auipc	a3,0x69
    80008232:	56a68693          	addi	a3,a3,1386 # 80071798 <tcp_port_binds>
    80008236:	96b2                	add	a3,a3,a2
    80008238:	6294                	ld	a3,0(a3)
    8000823a:	ce95                	beqz	a3,80008276 <remove_port_binding+0x74>
    8000823c:	00069697          	auipc	a3,0x69
    80008240:	55c68693          	addi	a3,a3,1372 # 80071798 <tcp_port_binds>
    80008244:	00c68733          	add	a4,a3,a2
    80008248:	e308                	sd	a0,0(a4)
    8000824a:	4501                	li	a0,0
    8000824c:	bfc9                	j	8000821e <remove_port_binding+0x1c>
    8000824e:	0027d783          	lhu	a5,2(a5)
    80008252:	00379693          	slli	a3,a5,0x3
    80008256:	0006a717          	auipc	a4,0x6a
    8000825a:	54270713          	addi	a4,a4,1346 # 80072798 <udp_port_binds>
    8000825e:	9736                	add	a4,a4,a3
    80008260:	6318                	ld	a4,0(a4)
    80008262:	cf01                	beqz	a4,8000827a <remove_port_binding+0x78>
    80008264:	0006a717          	auipc	a4,0x6a
    80008268:	53470713          	addi	a4,a4,1332 # 80072798 <udp_port_binds>
    8000826c:	00d707b3          	add	a5,a4,a3
    80008270:	0007b023          	sd	zero,0(a5)
    80008274:	b76d                	j	8000821e <remove_port_binding+0x1c>
    80008276:	557d                	li	a0,-1
    80008278:	b75d                	j	8000821e <remove_port_binding+0x1c>
    8000827a:	557d                	li	a0,-1
    8000827c:	b74d                	j	8000821e <remove_port_binding+0x1c>

000000008000827e <tcp_socket_list_insert>:
    8000827e:	1141                	addi	sp,sp,-16
    80008280:	e406                	sd	ra,8(sp)
    80008282:	e022                	sd	s0,0(sp)
    80008284:	0800                	addi	s0,sp,16
    80008286:	00008797          	auipc	a5,0x8
    8000828a:	af27b783          	ld	a5,-1294(a5) # 8000fd78 <tcp_sock_list>
    8000828e:	639c                	ld	a5,0(a5)
    80008290:	6685                	lui	a3,0x1
    80008292:	96be                	add	a3,a3,a5
    80008294:	6398                	ld	a4,0(a5)
    80008296:	c709                	beqz	a4,800082a0 <tcp_socket_list_insert+0x22>
    80008298:	07a1                	addi	a5,a5,8
    8000829a:	fed79de3          	bne	a5,a3,80008294 <tcp_socket_list_insert+0x16>
    8000829e:	a809                	j	800082b0 <tcp_socket_list_insert+0x32>
    800082a0:	e388                	sd	a0,0(a5)
    800082a2:	00008717          	auipc	a4,0x8
    800082a6:	ad673703          	ld	a4,-1322(a4) # 8000fd78 <tcp_sock_list>
    800082aa:	471c                	lw	a5,8(a4)
    800082ac:	2785                	addiw	a5,a5,1
    800082ae:	c71c                	sw	a5,8(a4)
    800082b0:	4501                	li	a0,0
    800082b2:	60a2                	ld	ra,8(sp)
    800082b4:	6402                	ld	s0,0(sp)
    800082b6:	0141                	addi	sp,sp,16
    800082b8:	8082                	ret

00000000800082ba <udp_socket_list_insert>:
    800082ba:	1141                	addi	sp,sp,-16
    800082bc:	e406                	sd	ra,8(sp)
    800082be:	e022                	sd	s0,0(sp)
    800082c0:	0800                	addi	s0,sp,16
    800082c2:	00008797          	auipc	a5,0x8
    800082c6:	aae7b783          	ld	a5,-1362(a5) # 8000fd70 <udp_sock_list>
    800082ca:	639c                	ld	a5,0(a5)
    800082cc:	6685                	lui	a3,0x1
    800082ce:	96be                	add	a3,a3,a5
    800082d0:	6398                	ld	a4,0(a5)
    800082d2:	c709                	beqz	a4,800082dc <udp_socket_list_insert+0x22>
    800082d4:	07a1                	addi	a5,a5,8
    800082d6:	fed79de3          	bne	a5,a3,800082d0 <udp_socket_list_insert+0x16>
    800082da:	a809                	j	800082ec <udp_socket_list_insert+0x32>
    800082dc:	e388                	sd	a0,0(a5)
    800082de:	00008717          	auipc	a4,0x8
    800082e2:	a9273703          	ld	a4,-1390(a4) # 8000fd70 <udp_sock_list>
    800082e6:	471c                	lw	a5,8(a4)
    800082e8:	2785                	addiw	a5,a5,1
    800082ea:	c71c                	sw	a5,8(a4)
    800082ec:	4501                	li	a0,0
    800082ee:	60a2                	ld	ra,8(sp)
    800082f0:	6402                	ld	s0,0(sp)
    800082f2:	0141                	addi	sp,sp,16
    800082f4:	8082                	ret

00000000800082f6 <getsock>:
    800082f6:	1141                	addi	sp,sp,-16
    800082f8:	e406                	sd	ra,8(sp)
    800082fa:	e022                	sd	s0,0(sp)
    800082fc:	0800                	addi	s0,sp,16
    800082fe:	00008797          	auipc	a5,0x8
    80008302:	a827b783          	ld	a5,-1406(a5) # 8000fd80 <sock_list>
    80008306:	4794                	lw	a3,8(a5)
    80008308:	02d05263          	blez	a3,8000832c <getsock+0x36>
    8000830c:	862a                	mv	a2,a0
    8000830e:	639c                	ld	a5,0(a5)
    80008310:	068e                	slli	a3,a3,0x3
    80008312:	96be                	add	a3,a3,a5
    80008314:	6388                	ld	a0,0(a5)
    80008316:	4138                	lw	a4,64(a0)
    80008318:	00c70663          	beq	a4,a2,80008324 <getsock+0x2e>
    8000831c:	07a1                	addi	a5,a5,8
    8000831e:	fed79be3          	bne	a5,a3,80008314 <getsock+0x1e>
    80008322:	4501                	li	a0,0
    80008324:	60a2                	ld	ra,8(sp)
    80008326:	6402                	ld	s0,0(sp)
    80008328:	0141                	addi	sp,sp,16
    8000832a:	8082                	ret
    8000832c:	4501                	li	a0,0
    8000832e:	bfdd                	j	80008324 <getsock+0x2e>

0000000080008330 <socket_list_remove>:
    80008330:	1101                	addi	sp,sp,-32
    80008332:	ec06                	sd	ra,24(sp)
    80008334:	e822                	sd	s0,16(sp)
    80008336:	e04a                	sd	s2,0(sp)
    80008338:	1000                	addi	s0,sp,32
    8000833a:	00008917          	auipc	s2,0x8
    8000833e:	a4693903          	ld	s2,-1466(s2) # 8000fd80 <sock_list>
    80008342:	00093783          	ld	a5,0(s2)
    80008346:	00351713          	slli	a4,a0,0x3
    8000834a:	97ba                	add	a5,a5,a4
    8000834c:	639c                	ld	a5,0(a5)
    8000834e:	c7c5                	beqz	a5,800083f6 <socket_list_remove+0xc6>
    80008350:	e426                	sd	s1,8(sp)
    80008352:	84aa                	mv	s1,a0
    80008354:	00000097          	auipc	ra,0x0
    80008358:	fa2080e7          	jalr	-94(ra) # 800082f6 <getsock>
    8000835c:	86aa                	mv	a3,a0
    8000835e:	557d                	li	a0,-1
    80008360:	cec9                	beqz	a3,800083fa <socket_list_remove+0xca>
    80008362:	00892783          	lw	a5,8(s2)
    80008366:	37fd                	addiw	a5,a5,-1
    80008368:	00f92423          	sw	a5,8(s2)
    8000836c:	5adc                	lw	a5,52(a3)
    8000836e:	4705                	li	a4,1
    80008370:	02e78163          	beq	a5,a4,80008392 <socket_list_remove+0x62>
    80008374:	4709                	li	a4,2
    80008376:	04e78763          	beq	a5,a4,800083c4 <socket_list_remove+0x94>
    8000837a:	8536                	mv	a0,a3
    8000837c:	ffff8097          	auipc	ra,0xffff8
    80008380:	728080e7          	jalr	1832(ra) # 80000aa4 <kfree>
    80008384:	4505                	li	a0,1
    80008386:	64a2                	ld	s1,8(sp)
    80008388:	60e2                	ld	ra,24(sp)
    8000838a:	6442                	ld	s0,16(sp)
    8000838c:	6902                	ld	s2,0(sp)
    8000838e:	6105                	addi	sp,sp,32
    80008390:	8082                	ret
    80008392:	00008797          	auipc	a5,0x8
    80008396:	9e67b783          	ld	a5,-1562(a5) # 8000fd78 <tcp_sock_list>
    8000839a:	639c                	ld	a5,0(a5)
    8000839c:	6605                	lui	a2,0x1
    8000839e:	963e                	add	a2,a2,a5
    800083a0:	6398                	ld	a4,0(a5)
    800083a2:	4338                	lw	a4,64(a4)
    800083a4:	00970663          	beq	a4,s1,800083b0 <socket_list_remove+0x80>
    800083a8:	07a1                	addi	a5,a5,8
    800083aa:	fec79be3          	bne	a5,a2,800083a0 <socket_list_remove+0x70>
    800083ae:	b7f1                	j	8000837a <socket_list_remove+0x4a>
    800083b0:	0007b023          	sd	zero,0(a5)
    800083b4:	00008717          	auipc	a4,0x8
    800083b8:	9c473703          	ld	a4,-1596(a4) # 8000fd78 <tcp_sock_list>
    800083bc:	471c                	lw	a5,8(a4)
    800083be:	37fd                	addiw	a5,a5,-1
    800083c0:	c71c                	sw	a5,8(a4)
    800083c2:	bf65                	j	8000837a <socket_list_remove+0x4a>
    800083c4:	00008797          	auipc	a5,0x8
    800083c8:	9ac7b783          	ld	a5,-1620(a5) # 8000fd70 <udp_sock_list>
    800083cc:	639c                	ld	a5,0(a5)
    800083ce:	6605                	lui	a2,0x1
    800083d0:	963e                	add	a2,a2,a5
    800083d2:	6398                	ld	a4,0(a5)
    800083d4:	4338                	lw	a4,64(a4)
    800083d6:	00970663          	beq	a4,s1,800083e2 <socket_list_remove+0xb2>
    800083da:	07a1                	addi	a5,a5,8
    800083dc:	fec79be3          	bne	a5,a2,800083d2 <socket_list_remove+0xa2>
    800083e0:	bf69                	j	8000837a <socket_list_remove+0x4a>
    800083e2:	0007b023          	sd	zero,0(a5)
    800083e6:	00008717          	auipc	a4,0x8
    800083ea:	98a73703          	ld	a4,-1654(a4) # 8000fd70 <udp_sock_list>
    800083ee:	471c                	lw	a5,8(a4)
    800083f0:	37fd                	addiw	a5,a5,-1
    800083f2:	c71c                	sw	a5,8(a4)
    800083f4:	b759                	j	8000837a <socket_list_remove+0x4a>
    800083f6:	557d                	li	a0,-1
    800083f8:	bf41                	j	80008388 <socket_list_remove+0x58>
    800083fa:	64a2                	ld	s1,8(sp)
    800083fc:	b771                	j	80008388 <socket_list_remove+0x58>

00000000800083fe <sock_list_insert>:
    800083fe:	00008797          	auipc	a5,0x8
    80008402:	9827b783          	ld	a5,-1662(a5) # 8000fd80 <sock_list>
    80008406:	4794                	lw	a3,8(a5)
    80008408:	20000713          	li	a4,512
    8000840c:	0ae68a63          	beq	a3,a4,800084c0 <sock_list_insert+0xc2>
    80008410:	1101                	addi	sp,sp,-32
    80008412:	ec06                	sd	ra,24(sp)
    80008414:	e822                	sd	s0,16(sp)
    80008416:	e426                	sd	s1,8(sp)
    80008418:	1000                	addi	s0,sp,32
    8000841a:	862a                	mv	a2,a0
    8000841c:	639c                	ld	a5,0(a5)
    8000841e:	4481                	li	s1,0
    80008420:	86ba                	mv	a3,a4
    80008422:	6398                	ld	a4,0(a5)
    80008424:	c719                	beqz	a4,80008432 <sock_list_insert+0x34>
    80008426:	2485                	addiw	s1,s1,1
    80008428:	07a1                	addi	a5,a5,8
    8000842a:	fed49ce3          	bne	s1,a3,80008422 <sock_list_insert+0x24>
    8000842e:	54fd                	li	s1,-1
    80008430:	a809                	j	80008442 <sock_list_insert+0x44>
    80008432:	e390                	sd	a2,0(a5)
    80008434:	00008717          	auipc	a4,0x8
    80008438:	94c73703          	ld	a4,-1716(a4) # 8000fd80 <sock_list>
    8000843c:	471c                	lw	a5,8(a4)
    8000843e:	2785                	addiw	a5,a5,1
    80008440:	c71c                	sw	a5,8(a4)
    80008442:	5a5c                	lw	a5,52(a2)
    80008444:	4709                	li	a4,2
    80008446:	00e78b63          	beq	a5,a4,8000845c <sock_list_insert+0x5e>
    8000844a:	4705                	li	a4,1
    8000844c:	4501                	li	a0,0
    8000844e:	04e78063          	beq	a5,a4,8000848e <sock_list_insert+0x90>
    80008452:	60e2                	ld	ra,24(sp)
    80008454:	6442                	ld	s0,16(sp)
    80008456:	64a2                	ld	s1,8(sp)
    80008458:	6105                	addi	sp,sp,32
    8000845a:	8082                	ret
    8000845c:	8532                	mv	a0,a2
    8000845e:	00000097          	auipc	ra,0x0
    80008462:	e5c080e7          	jalr	-420(ra) # 800082ba <udp_socket_list_insert>
    80008466:	57fd                	li	a5,-1
    80008468:	00f50463          	beq	a0,a5,80008470 <sock_list_insert+0x72>
    8000846c:	4501                	li	a0,0
    8000846e:	b7d5                	j	80008452 <sock_list_insert+0x54>
    80008470:	00008717          	auipc	a4,0x8
    80008474:	91070713          	addi	a4,a4,-1776 # 8000fd80 <sock_list>
    80008478:	631c                	ld	a5,0(a4)
    8000847a:	639c                	ld	a5,0(a5)
    8000847c:	048e                	slli	s1,s1,0x3
    8000847e:	97a6                	add	a5,a5,s1
    80008480:	0007b023          	sd	zero,0(a5)
    80008484:	6318                	ld	a4,0(a4)
    80008486:	471c                	lw	a5,8(a4)
    80008488:	37fd                	addiw	a5,a5,-1
    8000848a:	c71c                	sw	a5,8(a4)
    8000848c:	b7d9                	j	80008452 <sock_list_insert+0x54>
    8000848e:	8532                	mv	a0,a2
    80008490:	00000097          	auipc	ra,0x0
    80008494:	dee080e7          	jalr	-530(ra) # 8000827e <tcp_socket_list_insert>
    80008498:	57fd                	li	a5,-1
    8000849a:	00f50463          	beq	a0,a5,800084a2 <sock_list_insert+0xa4>
    8000849e:	4501                	li	a0,0
    800084a0:	bf4d                	j	80008452 <sock_list_insert+0x54>
    800084a2:	00008717          	auipc	a4,0x8
    800084a6:	8de70713          	addi	a4,a4,-1826 # 8000fd80 <sock_list>
    800084aa:	631c                	ld	a5,0(a4)
    800084ac:	639c                	ld	a5,0(a5)
    800084ae:	048e                	slli	s1,s1,0x3
    800084b0:	97a6                	add	a5,a5,s1
    800084b2:	0007b023          	sd	zero,0(a5)
    800084b6:	6318                	ld	a4,0(a4)
    800084b8:	471c                	lw	a5,8(a4)
    800084ba:	37fd                	addiw	a5,a5,-1
    800084bc:	c71c                	sw	a5,8(a4)
    800084be:	bf51                	j	80008452 <sock_list_insert+0x54>
    800084c0:	557d                	li	a0,-1
    800084c2:	8082                	ret

00000000800084c4 <bind>:
    800084c4:	1101                	addi	sp,sp,-32
    800084c6:	ec06                	sd	ra,24(sp)
    800084c8:	e822                	sd	s0,16(sp)
    800084ca:	e426                	sd	s1,8(sp)
    800084cc:	e04a                	sd	s2,0(sp)
    800084ce:	1000                	addi	s0,sp,32
    800084d0:	84ae                	mv	s1,a1
    800084d2:	8932                	mv	s2,a2
    800084d4:	00000097          	auipc	ra,0x0
    800084d8:	e22080e7          	jalr	-478(ra) # 800082f6 <getsock>
    800084dc:	cd01                	beqz	a0,800084f4 <bind+0x30>
    800084de:	653c                	ld	a5,72(a0)
    800084e0:	639c                	ld	a5,0(a5)
    800084e2:	864a                	mv	a2,s2
    800084e4:	85a6                	mv	a1,s1
    800084e6:	9782                	jalr	a5
    800084e8:	60e2                	ld	ra,24(sp)
    800084ea:	6442                	ld	s0,16(sp)
    800084ec:	64a2                	ld	s1,8(sp)
    800084ee:	6902                	ld	s2,0(sp)
    800084f0:	6105                	addi	sp,sp,32
    800084f2:	8082                	ret
    800084f4:	557d                	li	a0,-1
    800084f6:	bfcd                	j	800084e8 <bind+0x24>

00000000800084f8 <listen>:
    800084f8:	1101                	addi	sp,sp,-32
    800084fa:	ec06                	sd	ra,24(sp)
    800084fc:	e822                	sd	s0,16(sp)
    800084fe:	e426                	sd	s1,8(sp)
    80008500:	1000                	addi	s0,sp,32
    80008502:	84ae                	mv	s1,a1
    80008504:	00000097          	auipc	ra,0x0
    80008508:	df2080e7          	jalr	-526(ra) # 800082f6 <getsock>
    8000850c:	c919                	beqz	a0,80008522 <listen+0x2a>
    8000850e:	653c                	ld	a5,72(a0)
    80008510:	6b9c                	ld	a5,16(a5)
    80008512:	85a6                	mv	a1,s1
    80008514:	9782                	jalr	a5
    80008516:	4501                	li	a0,0
    80008518:	60e2                	ld	ra,24(sp)
    8000851a:	6442                	ld	s0,16(sp)
    8000851c:	64a2                	ld	s1,8(sp)
    8000851e:	6105                	addi	sp,sp,32
    80008520:	8082                	ret
    80008522:	557d                	li	a0,-1
    80008524:	bfd5                	j	80008518 <listen+0x20>

0000000080008526 <accept>:
    80008526:	1101                	addi	sp,sp,-32
    80008528:	ec06                	sd	ra,24(sp)
    8000852a:	e822                	sd	s0,16(sp)
    8000852c:	1000                	addi	s0,sp,32
    8000852e:	00000097          	auipc	ra,0x0
    80008532:	dc8080e7          	jalr	-568(ra) # 800082f6 <getsock>
    80008536:	c151                	beqz	a0,800085ba <accept+0x94>
    80008538:	e426                	sd	s1,8(sp)
    8000853a:	84aa                	mv	s1,a0
    8000853c:	7918                	ld	a4,48(a0)
    8000853e:	4785                	li	a5,1
    80008540:	1782                	slli	a5,a5,0x20
    80008542:	0799                	addi	a5,a5,6
    80008544:	04f71563          	bne	a4,a5,8000858e <accept+0x68>
    80008548:	5d58                	lw	a4,60(a0)
    8000854a:	03400793          	li	a5,52
    8000854e:	04f71b63          	bne	a4,a5,800085a4 <accept+0x7e>
    80008552:	e04a                	sd	s2,0(sp)
    80008554:	00850913          	addi	s2,a0,8
    80008558:	854a                	mv	a0,s2
    8000855a:	ffff8097          	auipc	ra,0xffff8
    8000855e:	7da080e7          	jalr	2010(ra) # 80000d34 <acquire>
    80008562:	609c                	ld	a5,0(s1)
    80008564:	eb89                	bnez	a5,80008576 <accept+0x50>
    80008566:	85ca                	mv	a1,s2
    80008568:	8526                	mv	a0,s1
    8000856a:	ffffa097          	auipc	ra,0xffffa
    8000856e:	1ca080e7          	jalr	458(ra) # 80002734 <sleep>
    80008572:	609c                	ld	a5,0(s1)
    80008574:	dbed                	beqz	a5,80008566 <accept+0x40>
    80008576:	854a                	mv	a0,s2
    80008578:	ffff9097          	auipc	ra,0xffff9
    8000857c:	86c080e7          	jalr	-1940(ra) # 80000de4 <release>
    80008580:	40a8                	lw	a0,64(s1)
    80008582:	64a2                	ld	s1,8(sp)
    80008584:	6902                	ld	s2,0(sp)
    80008586:	60e2                	ld	ra,24(sp)
    80008588:	6442                	ld	s0,16(sp)
    8000858a:	6105                	addi	sp,sp,32
    8000858c:	8082                	ret
    8000858e:	00003517          	auipc	a0,0x3
    80008592:	43250513          	addi	a0,a0,1074 # 8000b9c0 <etext+0x9c0>
    80008596:	ffff8097          	auipc	ra,0xffff8
    8000859a:	012080e7          	jalr	18(ra) # 800005a8 <printf>
    8000859e:	557d                	li	a0,-1
    800085a0:	64a2                	ld	s1,8(sp)
    800085a2:	b7d5                	j	80008586 <accept+0x60>
    800085a4:	00003517          	auipc	a0,0x3
    800085a8:	45450513          	addi	a0,a0,1108 # 8000b9f8 <etext+0x9f8>
    800085ac:	ffff8097          	auipc	ra,0xffff8
    800085b0:	ffc080e7          	jalr	-4(ra) # 800005a8 <printf>
    800085b4:	557d                	li	a0,-1
    800085b6:	64a2                	ld	s1,8(sp)
    800085b8:	b7f9                	j	80008586 <accept+0x60>
    800085ba:	557d                	li	a0,-1
    800085bc:	b7e9                	j	80008586 <accept+0x60>

00000000800085be <connect>:
    800085be:	1141                	addi	sp,sp,-16
    800085c0:	e406                	sd	ra,8(sp)
    800085c2:	e022                	sd	s0,0(sp)
    800085c4:	0800                	addi	s0,sp,16
    800085c6:	4501                	li	a0,0
    800085c8:	60a2                	ld	ra,8(sp)
    800085ca:	6402                	ld	s0,0(sp)
    800085cc:	0141                	addi	sp,sp,16
    800085ce:	8082                	ret

00000000800085d0 <initsocket>:
    800085d0:	1141                	addi	sp,sp,-16
    800085d2:	e406                	sd	ra,8(sp)
    800085d4:	e022                	sd	s0,0(sp)
    800085d6:	0800                	addi	s0,sp,16
    800085d8:	4789                	li	a5,2
    800085da:	04f59e63          	bne	a1,a5,80008636 <initsocket+0x66>
    800085de:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    800085e2:	4705                	li	a4,1
    800085e4:	06f76363          	bltu	a4,a5,8000864a <initsocket+0x7a>
    800085e8:	eabd                	bnez	a3,8000865e <initsocket+0x8e>
    800085ea:	4785                	li	a5,1
    800085ec:	0af60963          	beq	a2,a5,8000869e <initsocket+0xce>
    800085f0:	47c5                	li	a5,17
    800085f2:	d91c                	sw	a5,48(a0)
    800085f4:	00007717          	auipc	a4,0x7
    800085f8:	6b472703          	lw	a4,1716(a4) # 8000fca8 <netconf>
    800085fc:	00007797          	auipc	a5,0x7
    80008600:	6fc78793          	addi	a5,a5,1788 # 8000fcf8 <udp_ops>
    80008604:	d118                	sw	a4,32(a0)
    80008606:	d950                	sw	a2,52(a0)
    80008608:	4709                	li	a4,2
    8000860a:	dd18                	sw	a4,56(a0)
    8000860c:	03200713          	li	a4,50
    80008610:	dd58                	sw	a4,60(a0)
    80008612:	04053823          	sd	zero,80(a0)
    80008616:	04053c23          	sd	zero,88(a0)
    8000861a:	e53c                	sd	a5,72(a0)
    8000861c:	00000097          	auipc	ra,0x0
    80008620:	de2080e7          	jalr	-542(ra) # 800083fe <sock_list_insert>
    80008624:	0505                	addi	a0,a0,1
    80008626:	00153513          	seqz	a0,a0
    8000862a:	40a0053b          	negw	a0,a0
    8000862e:	60a2                	ld	ra,8(sp)
    80008630:	6402                	ld	s0,0(sp)
    80008632:	0141                	addi	sp,sp,16
    80008634:	8082                	ret
    80008636:	00003517          	auipc	a0,0x3
    8000863a:	3ea50513          	addi	a0,a0,1002 # 8000ba20 <etext+0xa20>
    8000863e:	ffff8097          	auipc	ra,0xffff8
    80008642:	f6a080e7          	jalr	-150(ra) # 800005a8 <printf>
    80008646:	557d                	li	a0,-1
    80008648:	b7dd                	j	8000862e <initsocket+0x5e>
    8000864a:	00003517          	auipc	a0,0x3
    8000864e:	3f650513          	addi	a0,a0,1014 # 8000ba40 <etext+0xa40>
    80008652:	ffff8097          	auipc	ra,0xffff8
    80008656:	f56080e7          	jalr	-170(ra) # 800005a8 <printf>
    8000865a:	557d                	li	a0,-1
    8000865c:	bfc9                	j	8000862e <initsocket+0x5e>
    8000865e:	4799                	li	a5,6
    80008660:	02f68c63          	beq	a3,a5,80008698 <initsocket+0xc8>
    80008664:	47c5                	li	a5,17
    80008666:	00f69f63          	bne	a3,a5,80008684 <initsocket+0xb4>
    8000866a:	4789                	li	a5,2
    8000866c:	f8f602e3          	beq	a2,a5,800085f0 <initsocket+0x20>
    80008670:	00003517          	auipc	a0,0x3
    80008674:	41050513          	addi	a0,a0,1040 # 8000ba80 <etext+0xa80>
    80008678:	ffff8097          	auipc	ra,0xffff8
    8000867c:	f30080e7          	jalr	-208(ra) # 800005a8 <printf>
    80008680:	557d                	li	a0,-1
    80008682:	b775                	j	8000862e <initsocket+0x5e>
    80008684:	00003517          	auipc	a0,0x3
    80008688:	3dc50513          	addi	a0,a0,988 # 8000ba60 <etext+0xa60>
    8000868c:	ffff8097          	auipc	ra,0xffff8
    80008690:	f1c080e7          	jalr	-228(ra) # 800005a8 <printf>
    80008694:	557d                	li	a0,-1
    80008696:	bf61                	j	8000862e <initsocket+0x5e>
    80008698:	4785                	li	a5,1
    8000869a:	fcf61be3          	bne	a2,a5,80008670 <initsocket+0xa0>
    8000869e:	4799                	li	a5,6
    800086a0:	d91c                	sw	a5,48(a0)
    800086a2:	00007717          	auipc	a4,0x7
    800086a6:	60672703          	lw	a4,1542(a4) # 8000fca8 <netconf>
    800086aa:	00007797          	auipc	a5,0x7
    800086ae:	61678793          	addi	a5,a5,1558 # 8000fcc0 <tcp_ops>
    800086b2:	bf89                	j	80008604 <initsocket+0x34>

00000000800086b4 <close>:
    800086b4:	1141                	addi	sp,sp,-16
    800086b6:	e406                	sd	ra,8(sp)
    800086b8:	e022                	sd	s0,0(sp)
    800086ba:	0800                	addi	s0,sp,16
    800086bc:	4501                	li	a0,0
    800086be:	60a2                	ld	ra,8(sp)
    800086c0:	6402                	ld	s0,0(sp)
    800086c2:	0141                	addi	sp,sp,16
    800086c4:	8082                	ret

00000000800086c6 <send>:
    800086c6:	1141                	addi	sp,sp,-16
    800086c8:	e406                	sd	ra,8(sp)
    800086ca:	e022                	sd	s0,0(sp)
    800086cc:	0800                	addi	s0,sp,16
    800086ce:	4501                	li	a0,0
    800086d0:	60a2                	ld	ra,8(sp)
    800086d2:	6402                	ld	s0,0(sp)
    800086d4:	0141                	addi	sp,sp,16
    800086d6:	8082                	ret

00000000800086d8 <recv>:
    800086d8:	1141                	addi	sp,sp,-16
    800086da:	e406                	sd	ra,8(sp)
    800086dc:	e022                	sd	s0,0(sp)
    800086de:	0800                	addi	s0,sp,16
    800086e0:	4501                	li	a0,0
    800086e2:	60a2                	ld	ra,8(sp)
    800086e4:	6402                	ld	s0,0(sp)
    800086e6:	0141                	addi	sp,sp,16
    800086e8:	8082                	ret

00000000800086ea <sendto>:
    800086ea:	7139                	addi	sp,sp,-64
    800086ec:	fc06                	sd	ra,56(sp)
    800086ee:	f822                	sd	s0,48(sp)
    800086f0:	f426                	sd	s1,40(sp)
    800086f2:	f04a                	sd	s2,32(sp)
    800086f4:	ec4e                	sd	s3,24(sp)
    800086f6:	e852                	sd	s4,16(sp)
    800086f8:	e456                	sd	s5,8(sp)
    800086fa:	0080                	addi	s0,sp,64
    800086fc:	8aae                	mv	s5,a1
    800086fe:	8a32                	mv	s4,a2
    80008700:	84b6                	mv	s1,a3
    80008702:	893a                	mv	s2,a4
    80008704:	89be                	mv	s3,a5
    80008706:	00000097          	auipc	ra,0x0
    8000870a:	bf0080e7          	jalr	-1040(ra) # 800082f6 <getsock>
    8000870e:	c11d                	beqz	a0,80008734 <sendto+0x4a>
    80008710:	653c                	ld	a5,72(a0)
    80008712:	0207b803          	ld	a6,32(a5)
    80008716:	87ce                	mv	a5,s3
    80008718:	874a                	mv	a4,s2
    8000871a:	86a6                	mv	a3,s1
    8000871c:	8652                	mv	a2,s4
    8000871e:	85d6                	mv	a1,s5
    80008720:	9802                	jalr	a6
    80008722:	70e2                	ld	ra,56(sp)
    80008724:	7442                	ld	s0,48(sp)
    80008726:	74a2                	ld	s1,40(sp)
    80008728:	7902                	ld	s2,32(sp)
    8000872a:	69e2                	ld	s3,24(sp)
    8000872c:	6a42                	ld	s4,16(sp)
    8000872e:	6aa2                	ld	s5,8(sp)
    80008730:	6121                	addi	sp,sp,64
    80008732:	8082                	ret
    80008734:	557d                	li	a0,-1
    80008736:	b7f5                	j	80008722 <sendto+0x38>

0000000080008738 <recvfrom>:
    80008738:	7139                	addi	sp,sp,-64
    8000873a:	fc06                	sd	ra,56(sp)
    8000873c:	f822                	sd	s0,48(sp)
    8000873e:	f426                	sd	s1,40(sp)
    80008740:	f04a                	sd	s2,32(sp)
    80008742:	ec4e                	sd	s3,24(sp)
    80008744:	e852                	sd	s4,16(sp)
    80008746:	e456                	sd	s5,8(sp)
    80008748:	0080                	addi	s0,sp,64
    8000874a:	8aae                	mv	s5,a1
    8000874c:	8a32                	mv	s4,a2
    8000874e:	84b6                	mv	s1,a3
    80008750:	893a                	mv	s2,a4
    80008752:	89be                	mv	s3,a5
    80008754:	00000097          	auipc	ra,0x0
    80008758:	ba2080e7          	jalr	-1118(ra) # 800082f6 <getsock>
    8000875c:	c11d                	beqz	a0,80008782 <recvfrom+0x4a>
    8000875e:	653c                	ld	a5,72(a0)
    80008760:	0287b803          	ld	a6,40(a5)
    80008764:	87ce                	mv	a5,s3
    80008766:	874a                	mv	a4,s2
    80008768:	86a6                	mv	a3,s1
    8000876a:	8652                	mv	a2,s4
    8000876c:	85d6                	mv	a1,s5
    8000876e:	9802                	jalr	a6
    80008770:	70e2                	ld	ra,56(sp)
    80008772:	7442                	ld	s0,48(sp)
    80008774:	74a2                	ld	s1,40(sp)
    80008776:	7902                	ld	s2,32(sp)
    80008778:	69e2                	ld	s3,24(sp)
    8000877a:	6a42                	ld	s4,16(sp)
    8000877c:	6aa2                	ld	s5,8(sp)
    8000877e:	6121                	addi	sp,sp,64
    80008780:	8082                	ret
    80008782:	557d                	li	a0,-1
    80008784:	b7f5                	j	80008770 <recvfrom+0x38>

0000000080008786 <sock_list_init>:
    80008786:	1101                	addi	sp,sp,-32
    80008788:	ec06                	sd	ra,24(sp)
    8000878a:	e822                	sd	s0,16(sp)
    8000878c:	1000                	addi	s0,sp,32
    8000878e:	ffff8097          	auipc	ra,0xffff8
    80008792:	484080e7          	jalr	1156(ra) # 80000c12 <kalloc>
    80008796:	00007797          	auipc	a5,0x7
    8000879a:	5ea7b523          	sd	a0,1514(a5) # 8000fd80 <sock_list>
    8000879e:	c90d                	beqz	a0,800087d0 <sock_list_init+0x4a>
    800087a0:	e426                	sd	s1,8(sp)
    800087a2:	84aa                	mv	s1,a0
    800087a4:	ffff8097          	auipc	ra,0xffff8
    800087a8:	46e080e7          	jalr	1134(ra) # 80000c12 <kalloc>
    800087ac:	e088                	sd	a0,0(s1)
    800087ae:	00007797          	auipc	a5,0x7
    800087b2:	5d27b783          	ld	a5,1490(a5) # 8000fd80 <sock_list>
    800087b6:	6388                	ld	a0,0(a5)
    800087b8:	c50d                	beqz	a0,800087e2 <sock_list_init+0x5c>
    800087ba:	6605                	lui	a2,0x1
    800087bc:	4581                	li	a1,0
    800087be:	ffff8097          	auipc	ra,0xffff8
    800087c2:	66e080e7          	jalr	1646(ra) # 80000e2c <memset>
    800087c6:	64a2                	ld	s1,8(sp)
    800087c8:	60e2                	ld	ra,24(sp)
    800087ca:	6442                	ld	s0,16(sp)
    800087cc:	6105                	addi	sp,sp,32
    800087ce:	8082                	ret
    800087d0:	00003517          	auipc	a0,0x3
    800087d4:	2e050513          	addi	a0,a0,736 # 8000bab0 <etext+0xab0>
    800087d8:	ffff8097          	auipc	ra,0xffff8
    800087dc:	dd0080e7          	jalr	-560(ra) # 800005a8 <printf>
    800087e0:	b7e5                	j	800087c8 <sock_list_init+0x42>
    800087e2:	00003517          	auipc	a0,0x3
    800087e6:	2fe50513          	addi	a0,a0,766 # 8000bae0 <etext+0xae0>
    800087ea:	ffff8097          	auipc	ra,0xffff8
    800087ee:	dbe080e7          	jalr	-578(ra) # 800005a8 <printf>
    800087f2:	00007517          	auipc	a0,0x7
    800087f6:	58e53503          	ld	a0,1422(a0) # 8000fd80 <sock_list>
    800087fa:	ffff8097          	auipc	ra,0xffff8
    800087fe:	2aa080e7          	jalr	682(ra) # 80000aa4 <kfree>
    80008802:	64a2                	ld	s1,8(sp)
    80008804:	b7d1                	j	800087c8 <sock_list_init+0x42>

0000000080008806 <tcp_sock_list_init>:
    80008806:	1101                	addi	sp,sp,-32
    80008808:	ec06                	sd	ra,24(sp)
    8000880a:	e822                	sd	s0,16(sp)
    8000880c:	1000                	addi	s0,sp,32
    8000880e:	ffff8097          	auipc	ra,0xffff8
    80008812:	404080e7          	jalr	1028(ra) # 80000c12 <kalloc>
    80008816:	00007797          	auipc	a5,0x7
    8000881a:	56a7b123          	sd	a0,1378(a5) # 8000fd78 <tcp_sock_list>
    8000881e:	c90d                	beqz	a0,80008850 <tcp_sock_list_init+0x4a>
    80008820:	e426                	sd	s1,8(sp)
    80008822:	84aa                	mv	s1,a0
    80008824:	ffff8097          	auipc	ra,0xffff8
    80008828:	3ee080e7          	jalr	1006(ra) # 80000c12 <kalloc>
    8000882c:	e088                	sd	a0,0(s1)
    8000882e:	00007797          	auipc	a5,0x7
    80008832:	54a7b783          	ld	a5,1354(a5) # 8000fd78 <tcp_sock_list>
    80008836:	6388                	ld	a0,0(a5)
    80008838:	c50d                	beqz	a0,80008862 <tcp_sock_list_init+0x5c>
    8000883a:	6605                	lui	a2,0x1
    8000883c:	4581                	li	a1,0
    8000883e:	ffff8097          	auipc	ra,0xffff8
    80008842:	5ee080e7          	jalr	1518(ra) # 80000e2c <memset>
    80008846:	64a2                	ld	s1,8(sp)
    80008848:	60e2                	ld	ra,24(sp)
    8000884a:	6442                	ld	s0,16(sp)
    8000884c:	6105                	addi	sp,sp,32
    8000884e:	8082                	ret
    80008850:	00003517          	auipc	a0,0x3
    80008854:	26050513          	addi	a0,a0,608 # 8000bab0 <etext+0xab0>
    80008858:	ffff8097          	auipc	ra,0xffff8
    8000885c:	d50080e7          	jalr	-688(ra) # 800005a8 <printf>
    80008860:	b7e5                	j	80008848 <tcp_sock_list_init+0x42>
    80008862:	00003517          	auipc	a0,0x3
    80008866:	27e50513          	addi	a0,a0,638 # 8000bae0 <etext+0xae0>
    8000886a:	ffff8097          	auipc	ra,0xffff8
    8000886e:	d3e080e7          	jalr	-706(ra) # 800005a8 <printf>
    80008872:	00007517          	auipc	a0,0x7
    80008876:	50653503          	ld	a0,1286(a0) # 8000fd78 <tcp_sock_list>
    8000887a:	ffff8097          	auipc	ra,0xffff8
    8000887e:	22a080e7          	jalr	554(ra) # 80000aa4 <kfree>
    80008882:	64a2                	ld	s1,8(sp)
    80008884:	b7d1                	j	80008848 <tcp_sock_list_init+0x42>

0000000080008886 <udp_sock_list_init>:
    80008886:	1101                	addi	sp,sp,-32
    80008888:	ec06                	sd	ra,24(sp)
    8000888a:	e822                	sd	s0,16(sp)
    8000888c:	1000                	addi	s0,sp,32
    8000888e:	ffff8097          	auipc	ra,0xffff8
    80008892:	384080e7          	jalr	900(ra) # 80000c12 <kalloc>
    80008896:	00007797          	auipc	a5,0x7
    8000889a:	4ca7bd23          	sd	a0,1242(a5) # 8000fd70 <udp_sock_list>
    8000889e:	c90d                	beqz	a0,800088d0 <udp_sock_list_init+0x4a>
    800088a0:	e426                	sd	s1,8(sp)
    800088a2:	84aa                	mv	s1,a0
    800088a4:	ffff8097          	auipc	ra,0xffff8
    800088a8:	36e080e7          	jalr	878(ra) # 80000c12 <kalloc>
    800088ac:	e088                	sd	a0,0(s1)
    800088ae:	00007797          	auipc	a5,0x7
    800088b2:	4c27b783          	ld	a5,1218(a5) # 8000fd70 <udp_sock_list>
    800088b6:	6388                	ld	a0,0(a5)
    800088b8:	c50d                	beqz	a0,800088e2 <udp_sock_list_init+0x5c>
    800088ba:	6605                	lui	a2,0x1
    800088bc:	4581                	li	a1,0
    800088be:	ffff8097          	auipc	ra,0xffff8
    800088c2:	56e080e7          	jalr	1390(ra) # 80000e2c <memset>
    800088c6:	64a2                	ld	s1,8(sp)
    800088c8:	60e2                	ld	ra,24(sp)
    800088ca:	6442                	ld	s0,16(sp)
    800088cc:	6105                	addi	sp,sp,32
    800088ce:	8082                	ret
    800088d0:	00003517          	auipc	a0,0x3
    800088d4:	24050513          	addi	a0,a0,576 # 8000bb10 <etext+0xb10>
    800088d8:	ffff8097          	auipc	ra,0xffff8
    800088dc:	cd0080e7          	jalr	-816(ra) # 800005a8 <printf>
    800088e0:	b7e5                	j	800088c8 <udp_sock_list_init+0x42>
    800088e2:	00003517          	auipc	a0,0x3
    800088e6:	25e50513          	addi	a0,a0,606 # 8000bb40 <etext+0xb40>
    800088ea:	ffff8097          	auipc	ra,0xffff8
    800088ee:	cbe080e7          	jalr	-834(ra) # 800005a8 <printf>
    800088f2:	00007517          	auipc	a0,0x7
    800088f6:	47e53503          	ld	a0,1150(a0) # 8000fd70 <udp_sock_list>
    800088fa:	ffff8097          	auipc	ra,0xffff8
    800088fe:	1aa080e7          	jalr	426(ra) # 80000aa4 <kfree>
    80008902:	64a2                	ld	s1,8(sp)
    80008904:	b7d1                	j	800088c8 <udp_sock_list_init+0x42>

0000000080008906 <socket_init>:
    80008906:	1141                	addi	sp,sp,-16
    80008908:	e406                	sd	ra,8(sp)
    8000890a:	e022                	sd	s0,0(sp)
    8000890c:	0800                	addi	s0,sp,16
    8000890e:	00000097          	auipc	ra,0x0
    80008912:	e78080e7          	jalr	-392(ra) # 80008786 <sock_list_init>
    80008916:	00000097          	auipc	ra,0x0
    8000891a:	ef0080e7          	jalr	-272(ra) # 80008806 <tcp_sock_list_init>
    8000891e:	00000097          	auipc	ra,0x0
    80008922:	f68080e7          	jalr	-152(ra) # 80008886 <udp_sock_list_init>
    80008926:	60a2                	ld	ra,8(sp)
    80008928:	6402                	ld	s0,0(sp)
    8000892a:	0141                	addi	sp,sp,16
    8000892c:	8082                	ret

000000008000892e <print_eth_frame>:
    8000892e:	7139                	addi	sp,sp,-64
    80008930:	fc06                	sd	ra,56(sp)
    80008932:	f822                	sd	s0,48(sp)
    80008934:	f426                	sd	s1,40(sp)
    80008936:	f04a                	sd	s2,32(sp)
    80008938:	ec4e                	sd	s3,24(sp)
    8000893a:	e852                	sd	s4,16(sp)
    8000893c:	e456                	sd	s5,8(sp)
    8000893e:	0080                	addi	s0,sp,64
    80008940:	892a                	mv	s2,a0
    80008942:	00002517          	auipc	a0,0x2
    80008946:	6de50513          	addi	a0,a0,1758 # 8000b020 <etext+0x20>
    8000894a:	ffff8097          	auipc	ra,0xffff8
    8000894e:	c5e080e7          	jalr	-930(ra) # 800005a8 <printf>
    80008952:	00594803          	lbu	a6,5(s2)
    80008956:	00494783          	lbu	a5,4(s2)
    8000895a:	00394703          	lbu	a4,3(s2)
    8000895e:	00294683          	lbu	a3,2(s2)
    80008962:	00194603          	lbu	a2,1(s2)
    80008966:	00094583          	lbu	a1,0(s2)
    8000896a:	00003517          	auipc	a0,0x3
    8000896e:	20650513          	addi	a0,a0,518 # 8000bb70 <etext+0xb70>
    80008972:	ffff8097          	auipc	ra,0xffff8
    80008976:	c36080e7          	jalr	-970(ra) # 800005a8 <printf>
    8000897a:	00b94803          	lbu	a6,11(s2)
    8000897e:	00a94783          	lbu	a5,10(s2)
    80008982:	00994703          	lbu	a4,9(s2)
    80008986:	00894683          	lbu	a3,8(s2)
    8000898a:	00794603          	lbu	a2,7(s2)
    8000898e:	00694583          	lbu	a1,6(s2)
    80008992:	00003517          	auipc	a0,0x3
    80008996:	1fe50513          	addi	a0,a0,510 # 8000bb90 <etext+0xb90>
    8000899a:	ffff8097          	auipc	ra,0xffff8
    8000899e:	c0e080e7          	jalr	-1010(ra) # 800005a8 <printf>
    800089a2:	00c94683          	lbu	a3,12(s2)
    800089a6:	00d94783          	lbu	a5,13(s2)
    800089aa:	07a2                	slli	a5,a5,0x8
    800089ac:	00d7e733          	or	a4,a5,a3
    800089b0:	60800693          	li	a3,1544
    800089b4:	06d70563          	beq	a4,a3,80008a1e <print_eth_frame+0xf0>
    800089b8:	0007069b          	sext.w	a3,a4
    800089bc:	67b9                	lui	a5,0xe
    800089be:	d0878793          	addi	a5,a5,-760 # dd08 <_entry-0x7fff22f8>
    800089c2:	06f68763          	beq	a3,a5,80008a30 <print_eth_frame+0x102>
    800089c6:	47a1                	li	a5,8
    800089c8:	00f69a63          	bne	a3,a5,800089dc <print_eth_frame+0xae>
    800089cc:	00003517          	auipc	a0,0x3
    800089d0:	1e450513          	addi	a0,a0,484 # 8000bbb0 <etext+0xbb0>
    800089d4:	ffff8097          	auipc	ra,0xffff8
    800089d8:	bd4080e7          	jalr	-1068(ra) # 800005a8 <printf>
    800089dc:	5ea94783          	lbu	a5,1514(s2)
    800089e0:	4481                	li	s1,0
    800089e2:	00003997          	auipc	s3,0x3
    800089e6:	1fe98993          	addi	s3,s3,510 # 8000bbe0 <etext+0xbe0>
    800089ea:	66666a37          	lui	s4,0x66666
    800089ee:	667a0a13          	addi	s4,s4,1639 # 66666667 <_entry-0x19999999>
    800089f2:	00003a97          	auipc	s5,0x3
    800089f6:	1f6a8a93          	addi	s5,s5,502 # 8000bbe8 <etext+0xbe8>
    800089fa:	ebb9                	bnez	a5,80008a50 <print_eth_frame+0x122>
    800089fc:	00002517          	auipc	a0,0x2
    80008a00:	62450513          	addi	a0,a0,1572 # 8000b020 <etext+0x20>
    80008a04:	ffff8097          	auipc	ra,0xffff8
    80008a08:	ba4080e7          	jalr	-1116(ra) # 800005a8 <printf>
    80008a0c:	70e2                	ld	ra,56(sp)
    80008a0e:	7442                	ld	s0,48(sp)
    80008a10:	74a2                	ld	s1,40(sp)
    80008a12:	7902                	ld	s2,32(sp)
    80008a14:	69e2                	ld	s3,24(sp)
    80008a16:	6a42                	ld	s4,16(sp)
    80008a18:	6aa2                	ld	s5,8(sp)
    80008a1a:	6121                	addi	sp,sp,64
    80008a1c:	8082                	ret
    80008a1e:	00003517          	auipc	a0,0x3
    80008a22:	1a250513          	addi	a0,a0,418 # 8000bbc0 <etext+0xbc0>
    80008a26:	ffff8097          	auipc	ra,0xffff8
    80008a2a:	b82080e7          	jalr	-1150(ra) # 800005a8 <printf>
    80008a2e:	b77d                	j	800089dc <print_eth_frame+0xae>
    80008a30:	00003517          	auipc	a0,0x3
    80008a34:	1a050513          	addi	a0,a0,416 # 8000bbd0 <etext+0xbd0>
    80008a38:	ffff8097          	auipc	ra,0xffff8
    80008a3c:	b70080e7          	jalr	-1168(ra) # 800005a8 <printf>
    80008a40:	bf71                	j	800089dc <print_eth_frame+0xae>
    80008a42:	0485                	addi	s1,s1,1
    80008a44:	5ea94703          	lbu	a4,1514(s2)
    80008a48:	0004879b          	sext.w	a5,s1
    80008a4c:	fae7d8e3          	bge	a5,a4,800089fc <print_eth_frame+0xce>
    80008a50:	009907b3          	add	a5,s2,s1
    80008a54:	00e7c583          	lbu	a1,14(a5)
    80008a58:	854e                	mv	a0,s3
    80008a5a:	ffff8097          	auipc	ra,0xffff8
    80008a5e:	b4e080e7          	jalr	-1202(ra) # 800005a8 <printf>
    80008a62:	0004879b          	sext.w	a5,s1
    80008a66:	fcf05ee3          	blez	a5,80008a42 <print_eth_frame+0x114>
    80008a6a:	034787b3          	mul	a5,a5,s4
    80008a6e:	9791                	srai	a5,a5,0x24
    80008a70:	41f4d71b          	sraiw	a4,s1,0x1f
    80008a74:	9f99                	subw	a5,a5,a4
    80008a76:	0027971b          	slliw	a4,a5,0x2
    80008a7a:	9fb9                	addw	a5,a5,a4
    80008a7c:	0037979b          	slliw	a5,a5,0x3
    80008a80:	40f487bb          	subw	a5,s1,a5
    80008a84:	ffdd                	bnez	a5,80008a42 <print_eth_frame+0x114>
    80008a86:	8556                	mv	a0,s5
    80008a88:	ffff8097          	auipc	ra,0xffff8
    80008a8c:	b20080e7          	jalr	-1248(ra) # 800005a8 <printf>
    80008a90:	bf4d                	j	80008a42 <print_eth_frame+0x114>

0000000080008a92 <parse_eth_packet>:
    80008a92:	7179                	addi	sp,sp,-48
    80008a94:	f406                	sd	ra,40(sp)
    80008a96:	f022                	sd	s0,32(sp)
    80008a98:	ec26                	sd	s1,24(sp)
    80008a9a:	e84a                	sd	s2,16(sp)
    80008a9c:	e44e                	sd	s3,8(sp)
    80008a9e:	1800                	addi	s0,sp,48
    80008aa0:	89aa                	mv	s3,a0
    80008aa2:	8932                	mv	s2,a2
    80008aa4:	ff25849b          	addiw	s1,a1,-14
    80008aa8:	14c2                	slli	s1,s1,0x30
    80008aaa:	90c1                	srli	s1,s1,0x30
    80008aac:	4639                	li	a2,14
    80008aae:	85aa                	mv	a1,a0
    80008ab0:	854a                	mv	a0,s2
    80008ab2:	ffff8097          	auipc	ra,0xffff8
    80008ab6:	3da080e7          	jalr	986(ra) # 80000e8c <memmove>
    80008aba:	8626                	mv	a2,s1
    80008abc:	00e98593          	addi	a1,s3,14
    80008ac0:	00e90513          	addi	a0,s2,14
    80008ac4:	ffff8097          	auipc	ra,0xffff8
    80008ac8:	3c8080e7          	jalr	968(ra) # 80000e8c <memmove>
    80008acc:	5e990523          	sb	s1,1514(s2)
    80008ad0:	4501                	li	a0,0
    80008ad2:	70a2                	ld	ra,40(sp)
    80008ad4:	7402                	ld	s0,32(sp)
    80008ad6:	64e2                	ld	s1,24(sp)
    80008ad8:	6942                	ld	s2,16(sp)
    80008ada:	69a2                	ld	s3,8(sp)
    80008adc:	6145                	addi	sp,sp,48
    80008ade:	8082                	ret

0000000080008ae0 <build_eth>:
    80008ae0:	7179                	addi	sp,sp,-48
    80008ae2:	f406                	sd	ra,40(sp)
    80008ae4:	f022                	sd	s0,32(sp)
    80008ae6:	ec26                	sd	s1,24(sp)
    80008ae8:	e84a                	sd	s2,16(sp)
    80008aea:	e44e                	sd	s3,8(sp)
    80008aec:	1800                	addi	s0,sp,48
    80008aee:	84aa                	mv	s1,a0
    80008af0:	89b2                	mv	s3,a2
    80008af2:	8936                	mv	s2,a3
    80008af4:	4619                	li	a2,6
    80008af6:	ffff8097          	auipc	ra,0xffff8
    80008afa:	396080e7          	jalr	918(ra) # 80000e8c <memmove>
    80008afe:	4619                	li	a2,6
    80008b00:	85ce                	mv	a1,s3
    80008b02:	00c48533          	add	a0,s1,a2
    80008b06:	ffff8097          	auipc	ra,0xffff8
    80008b0a:	386080e7          	jalr	902(ra) # 80000e8c <memmove>
    80008b0e:	0089579b          	srliw	a5,s2,0x8
    80008b12:	00f48623          	sb	a5,12(s1)
    80008b16:	012486a3          	sb	s2,13(s1)
    80008b1a:	70a2                	ld	ra,40(sp)
    80008b1c:	7402                	ld	s0,32(sp)
    80008b1e:	64e2                	ld	s1,24(sp)
    80008b20:	6942                	ld	s2,16(sp)
    80008b22:	69a2                	ld	s3,8(sp)
    80008b24:	6145                	addi	sp,sp,48
    80008b26:	8082                	ret

0000000080008b28 <tcp_bind>:
    80008b28:	7139                	addi	sp,sp,-64
    80008b2a:	fc06                	sd	ra,56(sp)
    80008b2c:	f822                	sd	s0,48(sp)
    80008b2e:	e05a                	sd	s6,0(sp)
    80008b30:	0080                	addi	s0,sp,64
    80008b32:	c5f9                	beqz	a1,80008c00 <tcp_bind+0xd8>
    80008b34:	f426                	sd	s1,40(sp)
    80008b36:	f04a                	sd	s2,32(sp)
    80008b38:	ec4e                	sd	s3,24(sp)
    80008b3a:	84aa                	mv	s1,a0
    80008b3c:	892e                	mv	s2,a1
    80008b3e:	0025d583          	lhu	a1,2(a1)
    80008b42:	0085d99b          	srliw	s3,a1,0x8
    80008b46:	0085979b          	slliw	a5,a1,0x8
    80008b4a:	00f9e9b3          	or	s3,s3,a5
    80008b4e:	19c2                	slli	s3,s3,0x30
    80008b50:	0309d993          	srli	s3,s3,0x30
    80008b54:	0005871b          	sext.w	a4,a1
    80008b58:	20000793          	li	a5,512
    80008b5c:	0ae7ec63          	bltu	a5,a4,80008c14 <tcp_bind+0xec>
    80008b60:	e456                	sd	s5,8(sp)
    80008b62:	00098a9b          	sext.w	s5,s3
    80008b66:	00399713          	slli	a4,s3,0x3
    80008b6a:	00069797          	auipc	a5,0x69
    80008b6e:	c2e78793          	addi	a5,a5,-978 # 80071798 <tcp_port_binds>
    80008b72:	97ba                	add	a5,a5,a4
    80008b74:	639c                	ld	a5,0(a5)
    80008b76:	efc5                	bnez	a5,80008c2e <tcp_bind+0x106>
    80008b78:	00095783          	lhu	a5,0(s2)
    80008b7c:	00078b1b          	sext.w	s6,a5
    80008b80:	dd1c                	sw	a5,56(a0)
    80008b82:	140b1c63          	bnez	s6,80008cda <tcp_bind+0x1b2>
    80008b86:	47c1                	li	a5,16
    80008b88:	0cf61163          	bne	a2,a5,80008c4a <tcp_bind+0x122>
    80008b8c:	003a9713          	slli	a4,s5,0x3
    80008b90:	00069797          	auipc	a5,0x69
    80008b94:	c0878793          	addi	a5,a5,-1016 # 80071798 <tcp_port_binds>
    80008b98:	97ba                	add	a5,a5,a4
    80008b9a:	639c                	ld	a5,0(a5)
    80008b9c:	e7e9                	bnez	a5,80008c66 <tcp_bind+0x13e>
    80008b9e:	e852                	sd	s4,16(sp)
    80008ba0:	ffff8097          	auipc	ra,0xffff8
    80008ba4:	072080e7          	jalr	114(ra) # 80000c12 <kalloc>
    80008ba8:	8a2a                	mv	s4,a0
    80008baa:	cd69                	beqz	a0,80008c84 <tcp_bind+0x15c>
    80008bac:	01351123          	sh	s3,2(a0)
    80008bb0:	00492783          	lw	a5,4(s2)
    80008bb4:	4705                	li	a4,1
    80008bb6:	0ee78663          	beq	a5,a4,80008ca2 <tcp_bind+0x17a>
    80008bba:	00f51023          	sh	a5,0(a0)
    80008bbe:	00492783          	lw	a5,4(s2)
    80008bc2:	d09c                	sw	a5,32(s1)
    80008bc4:	009a3423          	sd	s1,8(s4)
    80008bc8:	8552                	mv	a0,s4
    80008bca:	fffff097          	auipc	ra,0xfffff
    80008bce:	5ee080e7          	jalr	1518(ra) # 800081b8 <insert_port_binding>
    80008bd2:	89aa                	mv	s3,a0
    80008bd4:	57fd                	li	a5,-1
    80008bd6:	0cf50e63          	beq	a0,a5,80008cb2 <tcp_bind+0x18a>
    80008bda:	0354a423          	sw	s5,40(s1)
    80008bde:	00095783          	lhu	a5,0(s2)
    80008be2:	dc9c                	sw	a5,56(s1)
    80008be4:	03300793          	li	a5,51
    80008be8:	dcdc                	sw	a5,60(s1)
    80008bea:	74a2                	ld	s1,40(sp)
    80008bec:	7902                	ld	s2,32(sp)
    80008bee:	69e2                	ld	s3,24(sp)
    80008bf0:	6a42                	ld	s4,16(sp)
    80008bf2:	6aa2                	ld	s5,8(sp)
    80008bf4:	855a                	mv	a0,s6
    80008bf6:	70e2                	ld	ra,56(sp)
    80008bf8:	7442                	ld	s0,48(sp)
    80008bfa:	6b02                	ld	s6,0(sp)
    80008bfc:	6121                	addi	sp,sp,64
    80008bfe:	8082                	ret
    80008c00:	00003517          	auipc	a0,0x3
    80008c04:	ff050513          	addi	a0,a0,-16 # 8000bbf0 <etext+0xbf0>
    80008c08:	ffff8097          	auipc	ra,0xffff8
    80008c0c:	9a0080e7          	jalr	-1632(ra) # 800005a8 <printf>
    80008c10:	5b7d                	li	s6,-1
    80008c12:	b7cd                	j	80008bf4 <tcp_bind+0xcc>
    80008c14:	00003517          	auipc	a0,0x3
    80008c18:	ff450513          	addi	a0,a0,-12 # 8000bc08 <etext+0xc08>
    80008c1c:	ffff8097          	auipc	ra,0xffff8
    80008c20:	98c080e7          	jalr	-1652(ra) # 800005a8 <printf>
    80008c24:	5b7d                	li	s6,-1
    80008c26:	74a2                	ld	s1,40(sp)
    80008c28:	7902                	ld	s2,32(sp)
    80008c2a:	69e2                	ld	s3,24(sp)
    80008c2c:	b7e1                	j	80008bf4 <tcp_bind+0xcc>
    80008c2e:	00003517          	auipc	a0,0x3
    80008c32:	00a50513          	addi	a0,a0,10 # 8000bc38 <etext+0xc38>
    80008c36:	ffff8097          	auipc	ra,0xffff8
    80008c3a:	972080e7          	jalr	-1678(ra) # 800005a8 <printf>
    80008c3e:	5b7d                	li	s6,-1
    80008c40:	74a2                	ld	s1,40(sp)
    80008c42:	7902                	ld	s2,32(sp)
    80008c44:	69e2                	ld	s3,24(sp)
    80008c46:	6aa2                	ld	s5,8(sp)
    80008c48:	b775                	j	80008bf4 <tcp_bind+0xcc>
    80008c4a:	00003517          	auipc	a0,0x3
    80008c4e:	01650513          	addi	a0,a0,22 # 8000bc60 <etext+0xc60>
    80008c52:	ffff8097          	auipc	ra,0xffff8
    80008c56:	956080e7          	jalr	-1706(ra) # 800005a8 <printf>
    80008c5a:	5b7d                	li	s6,-1
    80008c5c:	74a2                	ld	s1,40(sp)
    80008c5e:	7902                	ld	s2,32(sp)
    80008c60:	69e2                	ld	s3,24(sp)
    80008c62:	6aa2                	ld	s5,8(sp)
    80008c64:	bf41                	j	80008bf4 <tcp_bind+0xcc>
    80008c66:	85d6                	mv	a1,s5
    80008c68:	00003517          	auipc	a0,0x3
    80008c6c:	02050513          	addi	a0,a0,32 # 8000bc88 <etext+0xc88>
    80008c70:	ffff8097          	auipc	ra,0xffff8
    80008c74:	938080e7          	jalr	-1736(ra) # 800005a8 <printf>
    80008c78:	5b7d                	li	s6,-1
    80008c7a:	74a2                	ld	s1,40(sp)
    80008c7c:	7902                	ld	s2,32(sp)
    80008c7e:	69e2                	ld	s3,24(sp)
    80008c80:	6aa2                	ld	s5,8(sp)
    80008c82:	bf8d                	j	80008bf4 <tcp_bind+0xcc>
    80008c84:	00002517          	auipc	a0,0x2
    80008c88:	7f450513          	addi	a0,a0,2036 # 8000b478 <etext+0x478>
    80008c8c:	ffff8097          	auipc	ra,0xffff8
    80008c90:	91c080e7          	jalr	-1764(ra) # 800005a8 <printf>
    80008c94:	5b7d                	li	s6,-1
    80008c96:	74a2                	ld	s1,40(sp)
    80008c98:	7902                	ld	s2,32(sp)
    80008c9a:	69e2                	ld	s3,24(sp)
    80008c9c:	6a42                	ld	s4,16(sp)
    80008c9e:	6aa2                	ld	s5,8(sp)
    80008ca0:	bf91                	j	80008bf4 <tcp_bind+0xcc>
    80008ca2:	00007797          	auipc	a5,0x7
    80008ca6:	0067a783          	lw	a5,6(a5) # 8000fca8 <netconf>
    80008caa:	d09c                	sw	a5,32(s1)
    80008cac:	00f51023          	sh	a5,0(a0)
    80008cb0:	bf11                	j	80008bc4 <tcp_bind+0x9c>
    80008cb2:	00003517          	auipc	a0,0x3
    80008cb6:	fee50513          	addi	a0,a0,-18 # 8000bca0 <etext+0xca0>
    80008cba:	ffff8097          	auipc	ra,0xffff8
    80008cbe:	8ee080e7          	jalr	-1810(ra) # 800005a8 <printf>
    80008cc2:	8552                	mv	a0,s4
    80008cc4:	ffff8097          	auipc	ra,0xffff8
    80008cc8:	de0080e7          	jalr	-544(ra) # 80000aa4 <kfree>
    80008ccc:	8b4e                	mv	s6,s3
    80008cce:	74a2                	ld	s1,40(sp)
    80008cd0:	7902                	ld	s2,32(sp)
    80008cd2:	69e2                	ld	s3,24(sp)
    80008cd4:	6a42                	ld	s4,16(sp)
    80008cd6:	6aa2                	ld	s5,8(sp)
    80008cd8:	bf31                	j	80008bf4 <tcp_bind+0xcc>
    80008cda:	5b7d                	li	s6,-1
    80008cdc:	74a2                	ld	s1,40(sp)
    80008cde:	7902                	ld	s2,32(sp)
    80008ce0:	69e2                	ld	s3,24(sp)
    80008ce2:	6aa2                	ld	s5,8(sp)
    80008ce4:	bf01                	j	80008bf4 <tcp_bind+0xcc>

0000000080008ce6 <tcp_connect>:
    80008ce6:	1141                	addi	sp,sp,-16
    80008ce8:	e406                	sd	ra,8(sp)
    80008cea:	e022                	sd	s0,0(sp)
    80008cec:	0800                	addi	s0,sp,16
    80008cee:	4501                	li	a0,0
    80008cf0:	60a2                	ld	ra,8(sp)
    80008cf2:	6402                	ld	s0,0(sp)
    80008cf4:	0141                	addi	sp,sp,16
    80008cf6:	8082                	ret

0000000080008cf8 <tcp_listen>:
    80008cf8:	1141                	addi	sp,sp,-16
    80008cfa:	e406                	sd	ra,8(sp)
    80008cfc:	e022                	sd	s0,0(sp)
    80008cfe:	0800                	addi	s0,sp,16
    80008d00:	5958                	lw	a4,52(a0)
    80008d02:	4785                	li	a5,1
    80008d04:	00f71f63          	bne	a4,a5,80008d22 <tcp_listen+0x2a>
    80008d08:	5d58                	lw	a4,60(a0)
    80008d0a:	03300793          	li	a5,51
    80008d0e:	02f71463          	bne	a4,a5,80008d36 <tcp_listen+0x3e>
    80008d12:	03400793          	li	a5,52
    80008d16:	dd5c                	sw	a5,60(a0)
    80008d18:	4501                	li	a0,0
    80008d1a:	60a2                	ld	ra,8(sp)
    80008d1c:	6402                	ld	s0,0(sp)
    80008d1e:	0141                	addi	sp,sp,16
    80008d20:	8082                	ret
    80008d22:	00003517          	auipc	a0,0x3
    80008d26:	f9e50513          	addi	a0,a0,-98 # 8000bcc0 <etext+0xcc0>
    80008d2a:	ffff8097          	auipc	ra,0xffff8
    80008d2e:	87e080e7          	jalr	-1922(ra) # 800005a8 <printf>
    80008d32:	557d                	li	a0,-1
    80008d34:	b7dd                	j	80008d1a <tcp_listen+0x22>
    80008d36:	00003517          	auipc	a0,0x3
    80008d3a:	fba50513          	addi	a0,a0,-70 # 8000bcf0 <etext+0xcf0>
    80008d3e:	ffff8097          	auipc	ra,0xffff8
    80008d42:	86a080e7          	jalr	-1942(ra) # 800005a8 <printf>
    80008d46:	557d                	li	a0,-1
    80008d48:	bfc9                	j	80008d1a <tcp_listen+0x22>

0000000080008d4a <tcp_accept>:
    80008d4a:	1141                	addi	sp,sp,-16
    80008d4c:	e406                	sd	ra,8(sp)
    80008d4e:	e022                	sd	s0,0(sp)
    80008d50:	0800                	addi	s0,sp,16
    80008d52:	4501                	li	a0,0
    80008d54:	60a2                	ld	ra,8(sp)
    80008d56:	6402                	ld	s0,0(sp)
    80008d58:	0141                	addi	sp,sp,16
    80008d5a:	8082                	ret

0000000080008d5c <tcp_close>:
    80008d5c:	1141                	addi	sp,sp,-16
    80008d5e:	e406                	sd	ra,8(sp)
    80008d60:	e022                	sd	s0,0(sp)
    80008d62:	0800                	addi	s0,sp,16
    80008d64:	4501                	li	a0,0
    80008d66:	60a2                	ld	ra,8(sp)
    80008d68:	6402                	ld	s0,0(sp)
    80008d6a:	0141                	addi	sp,sp,16
    80008d6c:	8082                	ret

0000000080008d6e <build_tcp>:
    80008d6e:	1101                	addi	sp,sp,-32
    80008d70:	ec06                	sd	ra,24(sp)
    80008d72:	e822                	sd	s0,16(sp)
    80008d74:	e426                	sd	s1,8(sp)
    80008d76:	e04a                	sd	s2,0(sp)
    80008d78:	1000                	addi	s0,sp,32
    80008d7a:	84aa                	mv	s1,a0
    80008d7c:	852e                	mv	a0,a1
    80008d7e:	85c6                	mv	a1,a7
    80008d80:	00042903          	lw	s2,0(s0)
    80008d84:	0085589b          	srliw	a7,a0,0x8
    80008d88:	01148023          	sb	a7,0(s1)
    80008d8c:	00a480a3          	sb	a0,1(s1)
    80008d90:	0086551b          	srliw	a0,a2,0x8
    80008d94:	00a48123          	sb	a0,2(s1)
    80008d98:	00c481a3          	sb	a2,3(s1)
    80008d9c:	0186961b          	slliw	a2,a3,0x18
    80008da0:	0186d51b          	srliw	a0,a3,0x18
    80008da4:	8e49                	or	a2,a2,a0
    80008da6:	0086951b          	slliw	a0,a3,0x8
    80008daa:	00ff08b7          	lui	a7,0xff0
    80008dae:	01157533          	and	a0,a0,a7
    80008db2:	8e49                	or	a2,a2,a0
    80008db4:	0086d69b          	srliw	a3,a3,0x8
    80008db8:	6541                	lui	a0,0x10
    80008dba:	f0050513          	addi	a0,a0,-256 # ff00 <_entry-0x7fff0100>
    80008dbe:	8ee9                	and	a3,a3,a0
    80008dc0:	00c48223          	sb	a2,4(s1)
    80008dc4:	82a1                	srli	a3,a3,0x8
    80008dc6:	00d482a3          	sb	a3,5(s1)
    80008dca:	0106569b          	srliw	a3,a2,0x10
    80008dce:	00d48323          	sb	a3,6(s1)
    80008dd2:	0186561b          	srliw	a2,a2,0x18
    80008dd6:	00c483a3          	sb	a2,7(s1)
    80008dda:	0187169b          	slliw	a3,a4,0x18
    80008dde:	0187561b          	srliw	a2,a4,0x18
    80008de2:	8ed1                	or	a3,a3,a2
    80008de4:	0087161b          	slliw	a2,a4,0x8
    80008de8:	01167633          	and	a2,a2,a7
    80008dec:	8ed1                	or	a3,a3,a2
    80008dee:	0087571b          	srliw	a4,a4,0x8
    80008df2:	8f69                	and	a4,a4,a0
    80008df4:	00d48423          	sb	a3,8(s1)
    80008df8:	8321                	srli	a4,a4,0x8
    80008dfa:	00e484a3          	sb	a4,9(s1)
    80008dfe:	0106d71b          	srliw	a4,a3,0x10
    80008e02:	00e48523          	sb	a4,10(s1)
    80008e06:	0186d69b          	srliw	a3,a3,0x18
    80008e0a:	00d485a3          	sb	a3,11(s1)
    80008e0e:	05000713          	li	a4,80
    80008e12:	00e48623          	sb	a4,12(s1)
    80008e16:	00f486a3          	sb	a5,13(s1)
    80008e1a:	0088579b          	srliw	a5,a6,0x8
    80008e1e:	00f48723          	sb	a5,14(s1)
    80008e22:	010487a3          	sb	a6,15(s1)
    80008e26:	00048823          	sb	zero,16(s1)
    80008e2a:	000488a3          	sb	zero,17(s1)
    80008e2e:	00048923          	sb	zero,18(s1)
    80008e32:	000489a3          	sb	zero,19(s1)
    80008e36:	864a                	mv	a2,s2
    80008e38:	01448513          	addi	a0,s1,20
    80008e3c:	ffff8097          	auipc	ra,0xffff8
    80008e40:	050080e7          	jalr	80(ra) # 80000e8c <memmove>
    80008e44:	5f248823          	sb	s2,1520(s1)
    80008e48:	0089579b          	srliw	a5,s2,0x8
    80008e4c:	5ef488a3          	sb	a5,1521(s1)
    80008e50:	0109579b          	srliw	a5,s2,0x10
    80008e54:	5ef48923          	sb	a5,1522(s1)
    80008e58:	0189591b          	srliw	s2,s2,0x18
    80008e5c:	5f2489a3          	sb	s2,1523(s1)
    80008e60:	60e2                	ld	ra,24(sp)
    80008e62:	6442                	ld	s0,16(sp)
    80008e64:	64a2                	ld	s1,8(sp)
    80008e66:	6902                	ld	s2,0(sp)
    80008e68:	6105                	addi	sp,sp,32
    80008e6a:	8082                	ret

0000000080008e6c <parse_tcp_packet>:
    80008e6c:	474d                	li	a4,19
    80008e6e:	12b75963          	bge	a4,a1,80008fa0 <parse_tcp_packet+0x134>
    80008e72:	87b2                	mv	a5,a2
    80008e74:	00055703          	lhu	a4,0(a0)
    80008e78:	00875693          	srli	a3,a4,0x8
    80008e7c:	00d60023          	sb	a3,0(a2) # 1000 <_entry-0x7ffff000>
    80008e80:	00e600a3          	sb	a4,1(a2)
    80008e84:	00255703          	lhu	a4,2(a0)
    80008e88:	00875693          	srli	a3,a4,0x8
    80008e8c:	00d60123          	sb	a3,2(a2)
    80008e90:	00e601a3          	sb	a4,3(a2)
    80008e94:	4158                	lw	a4,4(a0)
    80008e96:	0187169b          	slliw	a3,a4,0x18
    80008e9a:	0187561b          	srliw	a2,a4,0x18
    80008e9e:	8ed1                	or	a3,a3,a2
    80008ea0:	0087161b          	slliw	a2,a4,0x8
    80008ea4:	00ff08b7          	lui	a7,0xff0
    80008ea8:	01167633          	and	a2,a2,a7
    80008eac:	8ed1                	or	a3,a3,a2
    80008eae:	0087571b          	srliw	a4,a4,0x8
    80008eb2:	6641                	lui	a2,0x10
    80008eb4:	f0060613          	addi	a2,a2,-256 # ff00 <_entry-0x7fff0100>
    80008eb8:	8f71                	and	a4,a4,a2
    80008eba:	00d78223          	sb	a3,4(a5)
    80008ebe:	8321                	srli	a4,a4,0x8
    80008ec0:	00e782a3          	sb	a4,5(a5)
    80008ec4:	0106d71b          	srliw	a4,a3,0x10
    80008ec8:	00e78323          	sb	a4,6(a5)
    80008ecc:	0186d69b          	srliw	a3,a3,0x18
    80008ed0:	00d783a3          	sb	a3,7(a5)
    80008ed4:	4518                	lw	a4,8(a0)
    80008ed6:	0187169b          	slliw	a3,a4,0x18
    80008eda:	0187581b          	srliw	a6,a4,0x18
    80008ede:	0106e6b3          	or	a3,a3,a6
    80008ee2:	0087181b          	slliw	a6,a4,0x8
    80008ee6:	01187833          	and	a6,a6,a7
    80008eea:	0106e6b3          	or	a3,a3,a6
    80008eee:	0087571b          	srliw	a4,a4,0x8
    80008ef2:	8f71                	and	a4,a4,a2
    80008ef4:	00d78423          	sb	a3,8(a5)
    80008ef8:	8321                	srli	a4,a4,0x8
    80008efa:	00e784a3          	sb	a4,9(a5)
    80008efe:	0106d71b          	srliw	a4,a3,0x10
    80008f02:	00e78523          	sb	a4,10(a5)
    80008f06:	0186d69b          	srliw	a3,a3,0x18
    80008f0a:	00d785a3          	sb	a3,11(a5)
    80008f0e:	00c54703          	lbu	a4,12(a0)
    80008f12:	8311                	srli	a4,a4,0x4
    80008f14:	00e78623          	sb	a4,12(a5)
    80008f18:	00d54683          	lbu	a3,13(a0)
    80008f1c:	00d786a3          	sb	a3,13(a5)
    80008f20:	00e55683          	lhu	a3,14(a0)
    80008f24:	0086d613          	srli	a2,a3,0x8
    80008f28:	00c78723          	sb	a2,14(a5)
    80008f2c:	00d787a3          	sb	a3,15(a5)
    80008f30:	01055683          	lhu	a3,16(a0)
    80008f34:	0086d613          	srli	a2,a3,0x8
    80008f38:	00c78823          	sb	a2,16(a5)
    80008f3c:	00d788a3          	sb	a3,17(a5)
    80008f40:	01255683          	lhu	a3,18(a0)
    80008f44:	0086d613          	srli	a2,a3,0x8
    80008f48:	00c78923          	sb	a2,18(a5)
    80008f4c:	00d789a3          	sb	a3,19(a5)
    80008f50:	0027171b          	slliw	a4,a4,0x2
    80008f54:	464d                	li	a2,19
    80008f56:	04e65763          	bge	a2,a4,80008fa4 <parse_tcp_packet+0x138>
    80008f5a:	04e5c763          	blt	a1,a4,80008fa8 <parse_tcp_packet+0x13c>
    80008f5e:	1141                	addi	sp,sp,-16
    80008f60:	e406                	sd	ra,8(sp)
    80008f62:	e022                	sd	s0,0(sp)
    80008f64:	0800                	addi	s0,sp,16
    80008f66:	40e5863b          	subw	a2,a1,a4
    80008f6a:	5ec78823          	sb	a2,1520(a5)
    80008f6e:	0086569b          	srliw	a3,a2,0x8
    80008f72:	5ed788a3          	sb	a3,1521(a5)
    80008f76:	0106569b          	srliw	a3,a2,0x10
    80008f7a:	5ed78923          	sb	a3,1522(a5)
    80008f7e:	0186569b          	srliw	a3,a2,0x18
    80008f82:	5ed789a3          	sb	a3,1523(a5)
    80008f86:	00e505b3          	add	a1,a0,a4
    80008f8a:	01478513          	addi	a0,a5,20
    80008f8e:	ffff8097          	auipc	ra,0xffff8
    80008f92:	efe080e7          	jalr	-258(ra) # 80000e8c <memmove>
    80008f96:	4501                	li	a0,0
    80008f98:	60a2                	ld	ra,8(sp)
    80008f9a:	6402                	ld	s0,0(sp)
    80008f9c:	0141                	addi	sp,sp,16
    80008f9e:	8082                	ret
    80008fa0:	557d                	li	a0,-1
    80008fa2:	8082                	ret
    80008fa4:	557d                	li	a0,-1
    80008fa6:	8082                	ret
    80008fa8:	557d                	li	a0,-1
    80008faa:	8082                	ret

0000000080008fac <syn>:
    80008fac:	7119                	addi	sp,sp,-128
    80008fae:	fc86                	sd	ra,120(sp)
    80008fb0:	f8a2                	sd	s0,112(sp)
    80008fb2:	ecce                	sd	s3,88(sp)
    80008fb4:	e8d2                	sd	s4,80(sp)
    80008fb6:	e4d6                	sd	s5,72(sp)
    80008fb8:	e0da                	sd	s6,64(sp)
    80008fba:	0100                	addi	s0,sp,128
    80008fbc:	8a2a                	mv	s4,a0
    80008fbe:	89ae                	mv	s3,a1
    80008fc0:	8ab2                	mv	s5,a2
    80008fc2:	8b36                	mv	s6,a3
    80008fc4:	f6ceb7b7          	lui	a5,0xf6ceb
    80008fc8:	06378793          	addi	a5,a5,99 # fffffffff6ceb063 <end+0xffffffff76c777cb>
    80008fcc:	faf42423          	sw	a5,-88(s0)
    80008fd0:	6795                	lui	a5,0x5
    80008fd2:	0eb78793          	addi	a5,a5,235 # 50eb <_entry-0x7fffaf15>
    80008fd6:	faf41623          	sh	a5,-84(s0)
    80008fda:	ffff8097          	auipc	ra,0xffff8
    80008fde:	c38080e7          	jalr	-968(ra) # 80000c12 <kalloc>
    80008fe2:	c16d                	beqz	a0,800090c4 <syn+0x118>
    80008fe4:	f4a6                	sd	s1,104(sp)
    80008fe6:	f862                	sd	s8,48(sp)
    80008fe8:	8c2a                	mv	s8,a0
    80008fea:	ffff8097          	auipc	ra,0xffff8
    80008fee:	c28080e7          	jalr	-984(ra) # 80000c12 <kalloc>
    80008ff2:	84aa                	mv	s1,a0
    80008ff4:	c175                	beqz	a0,800090d8 <syn+0x12c>
    80008ff6:	fc5e                	sd	s7,56(sp)
    80008ff8:	ffff8097          	auipc	ra,0xffff8
    80008ffc:	c1a080e7          	jalr	-998(ra) # 80000c12 <kalloc>
    80009000:	8baa                	mv	s7,a0
    80009002:	c57d                	beqz	a0,800090f0 <syn+0x144>
    80009004:	f0ca                	sd	s2,96(sp)
    80009006:	e84e                	sd	s3,16(sp)
    80009008:	00007917          	auipc	s2,0x7
    8000900c:	ca090913          	addi	s2,s2,-864 # 8000fca8 <netconf>
    80009010:	00092783          	lw	a5,0(s2)
    80009014:	e43e                	sd	a5,8(sp)
    80009016:	e002                	sd	zero,0(sp)
    80009018:	4881                	li	a7,0
    8000901a:	40000813          	li	a6,1024
    8000901e:	4781                	li	a5,0
    80009020:	001b071b          	addiw	a4,s6,1
    80009024:	53900693          	li	a3,1337
    80009028:	8656                	mv	a2,s5
    8000902a:	85d2                	mv	a1,s4
    8000902c:	8562                	mv	a0,s8
    8000902e:	00000097          	auipc	ra,0x0
    80009032:	d40080e7          	jalr	-704(ra) # 80008d6e <build_tcp>
    80009036:	4751                	li	a4,20
    80009038:	4699                	li	a3,6
    8000903a:	864e                	mv	a2,s3
    8000903c:	00092583          	lw	a1,0(s2)
    80009040:	8526                	mv	a0,s1
    80009042:	fffff097          	auipc	ra,0xfffff
    80009046:	dfc080e7          	jalr	-516(ra) # 80007e3e <build_ip4>
    8000904a:	6685                	lui	a3,0x1
    8000904c:	80068693          	addi	a3,a3,-2048 # 800 <_entry-0x7ffff800>
    80009050:	00007617          	auipc	a2,0x7
    80009054:	c5c60613          	addi	a2,a2,-932 # 8000fcac <netconf+0x4>
    80009058:	fa840593          	addi	a1,s0,-88
    8000905c:	855e                	mv	a0,s7
    8000905e:	00000097          	auipc	ra,0x0
    80009062:	a82080e7          	jalr	-1406(ra) # 80008ae0 <build_eth>
    80009066:	47d1                	li	a5,20
    80009068:	5ef48823          	sb	a5,1520(s1)
    8000906c:	5e0488a3          	sb	zero,1521(s1)
    80009070:	863e                	mv	a2,a5
    80009072:	85e2                	mv	a1,s8
    80009074:	00f48533          	add	a0,s1,a5
    80009078:	ffff8097          	auipc	ra,0xffff8
    8000907c:	e14080e7          	jalr	-492(ra) # 80000e8c <memmove>
    80009080:	4651                	li	a2,20
    80009082:	5ecb8523          	sb	a2,1514(s7) # 15ea <_entry-0x7fffea16>
    80009086:	85a6                	mv	a1,s1
    80009088:	00eb8513          	addi	a0,s7,14
    8000908c:	ffff8097          	auipc	ra,0xffff8
    80009090:	e00080e7          	jalr	-512(ra) # 80000e8c <memmove>
    80009094:	5eabc583          	lbu	a1,1514(s7)
    80009098:	6605                	lui	a2,0x1
    8000909a:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000909e:	05b9                	addi	a1,a1,14
    800090a0:	855e                	mv	a0,s7
    800090a2:	ffffe097          	auipc	ra,0xffffe
    800090a6:	740080e7          	jalr	1856(ra) # 800077e2 <transmit_packet>
    800090aa:	4501                	li	a0,0
    800090ac:	74a6                	ld	s1,104(sp)
    800090ae:	7906                	ld	s2,96(sp)
    800090b0:	7be2                	ld	s7,56(sp)
    800090b2:	7c42                	ld	s8,48(sp)
    800090b4:	70e6                	ld	ra,120(sp)
    800090b6:	7446                	ld	s0,112(sp)
    800090b8:	69e6                	ld	s3,88(sp)
    800090ba:	6a46                	ld	s4,80(sp)
    800090bc:	6aa6                	ld	s5,72(sp)
    800090be:	6b06                	ld	s6,64(sp)
    800090c0:	6109                	addi	sp,sp,128
    800090c2:	8082                	ret
    800090c4:	00003517          	auipc	a0,0x3
    800090c8:	c4c50513          	addi	a0,a0,-948 # 8000bd10 <etext+0xd10>
    800090cc:	ffff7097          	auipc	ra,0xffff7
    800090d0:	4dc080e7          	jalr	1244(ra) # 800005a8 <printf>
    800090d4:	557d                	li	a0,-1
    800090d6:	bff9                	j	800090b4 <syn+0x108>
    800090d8:	00003517          	auipc	a0,0x3
    800090dc:	c3850513          	addi	a0,a0,-968 # 8000bd10 <etext+0xd10>
    800090e0:	ffff7097          	auipc	ra,0xffff7
    800090e4:	4c8080e7          	jalr	1224(ra) # 800005a8 <printf>
    800090e8:	557d                	li	a0,-1
    800090ea:	74a6                	ld	s1,104(sp)
    800090ec:	7c42                	ld	s8,48(sp)
    800090ee:	b7d9                	j	800090b4 <syn+0x108>
    800090f0:	00003517          	auipc	a0,0x3
    800090f4:	c2050513          	addi	a0,a0,-992 # 8000bd10 <etext+0xd10>
    800090f8:	ffff7097          	auipc	ra,0xffff7
    800090fc:	4b0080e7          	jalr	1200(ra) # 800005a8 <printf>
    80009100:	557d                	li	a0,-1
    80009102:	74a6                	ld	s1,104(sp)
    80009104:	7be2                	ld	s7,56(sp)
    80009106:	7c42                	ld	s8,48(sp)
    80009108:	b775                	j	800090b4 <syn+0x108>

000000008000910a <handle_tcp_packet>:
    8000910a:	1101                	addi	sp,sp,-32
    8000910c:	ec06                	sd	ra,24(sp)
    8000910e:	e822                	sd	s0,16(sp)
    80009110:	e426                	sd	s1,8(sp)
    80009112:	e04a                	sd	s2,0(sp)
    80009114:	1000                	addi	s0,sp,32
    80009116:	84aa                	mv	s1,a0
    80009118:	00854783          	lbu	a5,8(a0)
    8000911c:	00954703          	lbu	a4,9(a0)
    80009120:	0722                	slli	a4,a4,0x8
    80009122:	8f5d                	or	a4,a4,a5
    80009124:	00a54783          	lbu	a5,10(a0)
    80009128:	07c2                	slli	a5,a5,0x10
    8000912a:	8fd9                	or	a5,a5,a4
    8000912c:	00b54703          	lbu	a4,11(a0)
    80009130:	0762                	slli	a4,a4,0x18
    80009132:	8f5d                	or	a4,a4,a5
    80009134:	00454783          	lbu	a5,4(a0)
    80009138:	00554683          	lbu	a3,5(a0)
    8000913c:	06a2                	slli	a3,a3,0x8
    8000913e:	8edd                	or	a3,a3,a5
    80009140:	00654783          	lbu	a5,6(a0)
    80009144:	07c2                	slli	a5,a5,0x10
    80009146:	8fd5                	or	a5,a5,a3
    80009148:	00754683          	lbu	a3,7(a0)
    8000914c:	06e2                	slli	a3,a3,0x18
    8000914e:	8edd                	or	a3,a3,a5
    80009150:	00254503          	lbu	a0,2(a0)
    80009154:	0034c603          	lbu	a2,3(s1)
    80009158:	0622                	slli	a2,a2,0x8
    8000915a:	0004c583          	lbu	a1,0(s1)
    8000915e:	0014c783          	lbu	a5,1(s1)
    80009162:	07a2                	slli	a5,a5,0x8
    80009164:	2701                	sext.w	a4,a4
    80009166:	2681                	sext.w	a3,a3
    80009168:	8e49                	or	a2,a2,a0
    8000916a:	8ddd                	or	a1,a1,a5
    8000916c:	00003517          	auipc	a0,0x3
    80009170:	bb450513          	addi	a0,a0,-1100 # 8000bd20 <etext+0xd20>
    80009174:	ffff7097          	auipc	ra,0xffff7
    80009178:	434080e7          	jalr	1076(ra) # 800005a8 <printf>
    8000917c:	0024c703          	lbu	a4,2(s1)
    80009180:	0034c783          	lbu	a5,3(s1)
    80009184:	07a2                	slli	a5,a5,0x8
    80009186:	8fd9                	or	a5,a5,a4
    80009188:	078e                	slli	a5,a5,0x3
    8000918a:	00068717          	auipc	a4,0x68
    8000918e:	60e70713          	addi	a4,a4,1550 # 80071798 <tcp_port_binds>
    80009192:	97ba                	add	a5,a5,a4
    80009194:	0007b903          	ld	s2,0(a5)
    80009198:	0a090263          	beqz	s2,8000923c <handle_tcp_packet+0x132>
    8000919c:	00893783          	ld	a5,8(s2)
    800091a0:	5fd4                	lw	a3,60(a5)
    800091a2:	00095603          	lhu	a2,0(s2)
    800091a6:	00295583          	lhu	a1,2(s2)
    800091aa:	00003517          	auipc	a0,0x3
    800091ae:	bae50513          	addi	a0,a0,-1106 # 8000bd58 <etext+0xd58>
    800091b2:	ffff7097          	auipc	ra,0xffff7
    800091b6:	3f6080e7          	jalr	1014(ra) # 800005a8 <printf>
    800091ba:	00d4c783          	lbu	a5,13(s1)
    800091be:	0487f693          	andi	a3,a5,72
    800091c2:	04800713          	li	a4,72
    800091c6:	00e68f63          	beq	a3,a4,800091e4 <handle_tcp_packet+0xda>
    800091ca:	0087f713          	andi	a4,a5,8
    800091ce:	e70d                	bnez	a4,800091f8 <handle_tcp_packet+0xee>
    800091d0:	0407f793          	andi	a5,a5,64
    800091d4:	4501                	li	a0,0
    800091d6:	eba9                	bnez	a5,80009228 <handle_tcp_packet+0x11e>
    800091d8:	60e2                	ld	ra,24(sp)
    800091da:	6442                	ld	s0,16(sp)
    800091dc:	64a2                	ld	s1,8(sp)
    800091de:	6902                	ld	s2,0(sp)
    800091e0:	6105                	addi	sp,sp,32
    800091e2:	8082                	ret
    800091e4:	00003517          	auipc	a0,0x3
    800091e8:	bbc50513          	addi	a0,a0,-1092 # 8000bda0 <etext+0xda0>
    800091ec:	ffff7097          	auipc	ra,0xffff7
    800091f0:	3bc080e7          	jalr	956(ra) # 800005a8 <printf>
    800091f4:	4501                	li	a0,0
    800091f6:	b7cd                	j	800091d8 <handle_tcp_packet+0xce>
    800091f8:	00003517          	auipc	a0,0x3
    800091fc:	bc050513          	addi	a0,a0,-1088 # 8000bdb8 <etext+0xdb8>
    80009200:	ffff7097          	auipc	ra,0xffff7
    80009204:	3a8080e7          	jalr	936(ra) # 800005a8 <printf>
    80009208:	00893783          	ld	a5,8(s2)
    8000920c:	5bd4                	lw	a3,52(a5)
    8000920e:	4719                	li	a4,6
    80009210:	02e69863          	bne	a3,a4,80009240 <handle_tcp_packet+0x136>
    80009214:	5fd4                	lw	a3,60(a5)
    80009216:	03400713          	li	a4,52
    8000921a:	02e69563          	bne	a3,a4,80009244 <handle_tcp_packet+0x13a>
    8000921e:	03600713          	li	a4,54
    80009222:	dfd8                	sw	a4,60(a5)
    80009224:	4501                	li	a0,0
    80009226:	bf4d                	j	800091d8 <handle_tcp_packet+0xce>
    80009228:	00003517          	auipc	a0,0x3
    8000922c:	ba050513          	addi	a0,a0,-1120 # 8000bdc8 <etext+0xdc8>
    80009230:	ffff7097          	auipc	ra,0xffff7
    80009234:	378080e7          	jalr	888(ra) # 800005a8 <printf>
    80009238:	4501                	li	a0,0
    8000923a:	bf79                	j	800091d8 <handle_tcp_packet+0xce>
    8000923c:	557d                	li	a0,-1
    8000923e:	bf69                	j	800091d8 <handle_tcp_packet+0xce>
    80009240:	557d                	li	a0,-1
    80009242:	bf59                	j	800091d8 <handle_tcp_packet+0xce>
    80009244:	557d                	li	a0,-1
    80009246:	bf49                	j	800091d8 <handle_tcp_packet+0xce>

0000000080009248 <build_udp>:
    80009248:	1141                	addi	sp,sp,-16
    8000924a:	e406                	sd	ra,8(sp)
    8000924c:	e022                	sd	s0,0(sp)
    8000924e:	0800                	addi	s0,sp,16
    80009250:	87b2                	mv	a5,a2
    80009252:	863a                	mv	a2,a4
    80009254:	0085d71b          	srliw	a4,a1,0x8
    80009258:	00e50023          	sb	a4,0(a0)
    8000925c:	00b500a3          	sb	a1,1(a0)
    80009260:	00f50123          	sb	a5,2(a0)
    80009264:	83a1                	srli	a5,a5,0x8
    80009266:	00f501a3          	sb	a5,3(a0)
    8000926a:	03061793          	slli	a5,a2,0x30
    8000926e:	93c1                	srli	a5,a5,0x30
    80009270:	0087881b          	addiw	a6,a5,8
    80009274:	0108171b          	slliw	a4,a6,0x10
    80009278:	0107571b          	srliw	a4,a4,0x10
    8000927c:	0087571b          	srliw	a4,a4,0x8
    80009280:	00e50223          	sb	a4,4(a0)
    80009284:	010502a3          	sb	a6,5(a0)
    80009288:	00050323          	sb	zero,6(a0)
    8000928c:	000503a3          	sb	zero,7(a0)
    80009290:	0087d71b          	srliw	a4,a5,0x8
    80009294:	0087979b          	slliw	a5,a5,0x8
    80009298:	8fd9                	or	a5,a5,a4
    8000929a:	0107971b          	slliw	a4,a5,0x10
    8000929e:	0107571b          	srliw	a4,a4,0x10
    800092a2:	5ef50223          	sb	a5,1508(a0)
    800092a6:	0087579b          	srliw	a5,a4,0x8
    800092aa:	5ef502a3          	sb	a5,1509(a0)
    800092ae:	5e050323          	sb	zero,1510(a0)
    800092b2:	5e0503a3          	sb	zero,1511(a0)
    800092b6:	85b6                	mv	a1,a3
    800092b8:	0521                	addi	a0,a0,8
    800092ba:	ffff8097          	auipc	ra,0xffff8
    800092be:	bd2080e7          	jalr	-1070(ra) # 80000e8c <memmove>
    800092c2:	60a2                	ld	ra,8(sp)
    800092c4:	6402                	ld	s0,0(sp)
    800092c6:	0141                	addi	sp,sp,16
    800092c8:	8082                	ret

00000000800092ca <enqueue_udp_packet>:
    800092ca:	1141                	addi	sp,sp,-16
    800092cc:	e406                	sd	ra,8(sp)
    800092ce:	e022                	sd	s0,0(sp)
    800092d0:	0800                	addi	s0,sp,16
    800092d2:	69bc                	ld	a5,80(a1)
    800092d4:	cbb1                	beqz	a5,80009328 <enqueue_udp_packet+0x5e>
    800092d6:	6dbc                	ld	a5,88(a1)
    800092d8:	eda8                	sd	a0,88(a1)
    800092da:	5ef50423          	sb	a5,1512(a0)
    800092de:	0087d713          	srli	a4,a5,0x8
    800092e2:	5ee504a3          	sb	a4,1513(a0)
    800092e6:	0107d713          	srli	a4,a5,0x10
    800092ea:	5ee50523          	sb	a4,1514(a0)
    800092ee:	0187d71b          	srliw	a4,a5,0x18
    800092f2:	5ee505a3          	sb	a4,1515(a0)
    800092f6:	0207d713          	srli	a4,a5,0x20
    800092fa:	5ee50623          	sb	a4,1516(a0)
    800092fe:	0287d713          	srli	a4,a5,0x28
    80009302:	5ee506a3          	sb	a4,1517(a0)
    80009306:	0307d713          	srli	a4,a5,0x30
    8000930a:	5ee50723          	sb	a4,1518(a0)
    8000930e:	93e1                	srli	a5,a5,0x38
    80009310:	5ef507a3          	sb	a5,1519(a0)
    80009314:	05058513          	addi	a0,a1,80
    80009318:	ffff9097          	auipc	ra,0xffff9
    8000931c:	480080e7          	jalr	1152(ra) # 80002798 <wakeup>
    80009320:	60a2                	ld	ra,8(sp)
    80009322:	6402                	ld	s0,0(sp)
    80009324:	0141                	addi	sp,sp,16
    80009326:	8082                	ret
    80009328:	e9a8                	sd	a0,80(a1)
    8000932a:	eda8                	sd	a0,88(a1)
    8000932c:	b7e5                	j	80009314 <enqueue_udp_packet+0x4a>

000000008000932e <dequeue_udp_packet>:
    8000932e:	1141                	addi	sp,sp,-16
    80009330:	e406                	sd	ra,8(sp)
    80009332:	e022                	sd	s0,0(sp)
    80009334:	0800                	addi	s0,sp,16
    80009336:	872a                	mv	a4,a0
    80009338:	6928                	ld	a0,80(a0)
    8000933a:	c129                	beqz	a0,8000937c <dequeue_udp_packet+0x4e>
    8000933c:	5e854683          	lbu	a3,1512(a0)
    80009340:	5e954783          	lbu	a5,1513(a0)
    80009344:	07a2                	slli	a5,a5,0x8
    80009346:	8fd5                	or	a5,a5,a3
    80009348:	5ea54683          	lbu	a3,1514(a0)
    8000934c:	06c2                	slli	a3,a3,0x10
    8000934e:	8edd                	or	a3,a3,a5
    80009350:	5eb54783          	lbu	a5,1515(a0)
    80009354:	07e2                	slli	a5,a5,0x18
    80009356:	8fd5                	or	a5,a5,a3
    80009358:	5ec54683          	lbu	a3,1516(a0)
    8000935c:	1682                	slli	a3,a3,0x20
    8000935e:	8edd                	or	a3,a3,a5
    80009360:	5ed54783          	lbu	a5,1517(a0)
    80009364:	17a2                	slli	a5,a5,0x28
    80009366:	8fd5                	or	a5,a5,a3
    80009368:	5ee54683          	lbu	a3,1518(a0)
    8000936c:	16c2                	slli	a3,a3,0x30
    8000936e:	8edd                	or	a3,a3,a5
    80009370:	5ef54783          	lbu	a5,1519(a0)
    80009374:	17e2                	slli	a5,a5,0x38
    80009376:	8fd5                	or	a5,a5,a3
    80009378:	eb3c                	sd	a5,80(a4)
    8000937a:	c789                	beqz	a5,80009384 <dequeue_udp_packet+0x56>
    8000937c:	60a2                	ld	ra,8(sp)
    8000937e:	6402                	ld	s0,0(sp)
    80009380:	0141                	addi	sp,sp,16
    80009382:	8082                	ret
    80009384:	04073c23          	sd	zero,88(a4)
    80009388:	bfd5                	j	8000937c <dequeue_udp_packet+0x4e>

000000008000938a <udp_bind>:
    8000938a:	7139                	addi	sp,sp,-64
    8000938c:	fc06                	sd	ra,56(sp)
    8000938e:	f822                	sd	s0,48(sp)
    80009390:	f426                	sd	s1,40(sp)
    80009392:	0080                	addi	s0,sp,64
    80009394:	c955                	beqz	a0,80009448 <udp_bind+0xbe>
    80009396:	ec4e                	sd	s3,24(sp)
    80009398:	e852                	sd	s4,16(sp)
    8000939a:	89aa                	mv	s3,a0
    8000939c:	8a2e                	mv	s4,a1
    8000939e:	cddd                	beqz	a1,8000945c <udp_bind+0xd2>
    800093a0:	0025d783          	lhu	a5,2(a1)
    800093a4:	0087d493          	srli	s1,a5,0x8
    800093a8:	0087979b          	slliw	a5,a5,0x8
    800093ac:	8cdd                	or	s1,s1,a5
    800093ae:	14c2                	slli	s1,s1,0x30
    800093b0:	90c1                	srli	s1,s1,0x30
    800093b2:	fff4879b          	addiw	a5,s1,-1
    800093b6:	17c2                	slli	a5,a5,0x30
    800093b8:	93c1                	srli	a5,a5,0x30
    800093ba:	1fe00713          	li	a4,510
    800093be:	0af76b63          	bltu	a4,a5,80009474 <udp_bind+0xea>
    800093c2:	e456                	sd	s5,8(sp)
    800093c4:	00048a9b          	sext.w	s5,s1
    800093c8:	00349713          	slli	a4,s1,0x3
    800093cc:	00069797          	auipc	a5,0x69
    800093d0:	3cc78793          	addi	a5,a5,972 # 80072798 <udp_port_binds>
    800093d4:	97ba                	add	a5,a5,a4
    800093d6:	639c                	ld	a5,0(a5)
    800093d8:	ebdd                	bnez	a5,8000948e <udp_bind+0x104>
    800093da:	5d18                	lw	a4,56(a0)
    800093dc:	4789                	li	a5,2
    800093de:	12f71b63          	bne	a4,a5,80009514 <udp_bind+0x18a>
    800093e2:	47c1                	li	a5,16
    800093e4:	0cf61263          	bne	a2,a5,800094a8 <udp_bind+0x11e>
    800093e8:	f04a                	sd	s2,32(sp)
    800093ea:	ffff8097          	auipc	ra,0xffff8
    800093ee:	828080e7          	jalr	-2008(ra) # 80000c12 <kalloc>
    800093f2:	892a                	mv	s2,a0
    800093f4:	c579                	beqz	a0,800094c2 <udp_bind+0x138>
    800093f6:	00951123          	sh	s1,2(a0)
    800093fa:	004a2783          	lw	a5,4(s4)
    800093fe:	4705                	li	a4,1
    80009400:	0ce78f63          	beq	a5,a4,800094de <udp_bind+0x154>
    80009404:	00f51023          	sh	a5,0(a0)
    80009408:	004a2783          	lw	a5,4(s4)
    8000940c:	02f9a023          	sw	a5,32(s3)
    80009410:	01393423          	sd	s3,8(s2)
    80009414:	854a                	mv	a0,s2
    80009416:	fffff097          	auipc	ra,0xfffff
    8000941a:	da2080e7          	jalr	-606(ra) # 800081b8 <insert_port_binding>
    8000941e:	84aa                	mv	s1,a0
    80009420:	57fd                	li	a5,-1
    80009422:	0cf50763          	beq	a0,a5,800094f0 <udp_bind+0x166>
    80009426:	0359a423          	sw	s5,40(s3)
    8000942a:	03300793          	li	a5,51
    8000942e:	02f9ae23          	sw	a5,60(s3)
    80009432:	4481                	li	s1,0
    80009434:	7902                	ld	s2,32(sp)
    80009436:	69e2                	ld	s3,24(sp)
    80009438:	6a42                	ld	s4,16(sp)
    8000943a:	6aa2                	ld	s5,8(sp)
    8000943c:	8526                	mv	a0,s1
    8000943e:	70e2                	ld	ra,56(sp)
    80009440:	7442                	ld	s0,48(sp)
    80009442:	74a2                	ld	s1,40(sp)
    80009444:	6121                	addi	sp,sp,64
    80009446:	8082                	ret
    80009448:	00003517          	auipc	a0,0x3
    8000944c:	99050513          	addi	a0,a0,-1648 # 8000bdd8 <etext+0xdd8>
    80009450:	ffff7097          	auipc	ra,0xffff7
    80009454:	158080e7          	jalr	344(ra) # 800005a8 <printf>
    80009458:	54fd                	li	s1,-1
    8000945a:	b7cd                	j	8000943c <udp_bind+0xb2>
    8000945c:	00003517          	auipc	a0,0x3
    80009460:	99450513          	addi	a0,a0,-1644 # 8000bdf0 <etext+0xdf0>
    80009464:	ffff7097          	auipc	ra,0xffff7
    80009468:	144080e7          	jalr	324(ra) # 800005a8 <printf>
    8000946c:	54fd                	li	s1,-1
    8000946e:	69e2                	ld	s3,24(sp)
    80009470:	6a42                	ld	s4,16(sp)
    80009472:	b7e9                	j	8000943c <udp_bind+0xb2>
    80009474:	85a6                	mv	a1,s1
    80009476:	00002517          	auipc	a0,0x2
    8000947a:	79250513          	addi	a0,a0,1938 # 8000bc08 <etext+0xc08>
    8000947e:	ffff7097          	auipc	ra,0xffff7
    80009482:	12a080e7          	jalr	298(ra) # 800005a8 <printf>
    80009486:	54fd                	li	s1,-1
    80009488:	69e2                	ld	s3,24(sp)
    8000948a:	6a42                	ld	s4,16(sp)
    8000948c:	bf45                	j	8000943c <udp_bind+0xb2>
    8000948e:	00002517          	auipc	a0,0x2
    80009492:	7aa50513          	addi	a0,a0,1962 # 8000bc38 <etext+0xc38>
    80009496:	ffff7097          	auipc	ra,0xffff7
    8000949a:	112080e7          	jalr	274(ra) # 800005a8 <printf>
    8000949e:	54fd                	li	s1,-1
    800094a0:	69e2                	ld	s3,24(sp)
    800094a2:	6a42                	ld	s4,16(sp)
    800094a4:	6aa2                	ld	s5,8(sp)
    800094a6:	bf59                	j	8000943c <udp_bind+0xb2>
    800094a8:	00002517          	auipc	a0,0x2
    800094ac:	7b850513          	addi	a0,a0,1976 # 8000bc60 <etext+0xc60>
    800094b0:	ffff7097          	auipc	ra,0xffff7
    800094b4:	0f8080e7          	jalr	248(ra) # 800005a8 <printf>
    800094b8:	54fd                	li	s1,-1
    800094ba:	69e2                	ld	s3,24(sp)
    800094bc:	6a42                	ld	s4,16(sp)
    800094be:	6aa2                	ld	s5,8(sp)
    800094c0:	bfb5                	j	8000943c <udp_bind+0xb2>
    800094c2:	00002517          	auipc	a0,0x2
    800094c6:	fb650513          	addi	a0,a0,-74 # 8000b478 <etext+0x478>
    800094ca:	ffff7097          	auipc	ra,0xffff7
    800094ce:	0de080e7          	jalr	222(ra) # 800005a8 <printf>
    800094d2:	54fd                	li	s1,-1
    800094d4:	7902                	ld	s2,32(sp)
    800094d6:	69e2                	ld	s3,24(sp)
    800094d8:	6a42                	ld	s4,16(sp)
    800094da:	6aa2                	ld	s5,8(sp)
    800094dc:	b785                	j	8000943c <udp_bind+0xb2>
    800094de:	00006797          	auipc	a5,0x6
    800094e2:	7ca7a783          	lw	a5,1994(a5) # 8000fca8 <netconf>
    800094e6:	02f9a023          	sw	a5,32(s3)
    800094ea:	00f51023          	sh	a5,0(a0)
    800094ee:	b70d                	j	80009410 <udp_bind+0x86>
    800094f0:	00002517          	auipc	a0,0x2
    800094f4:	7b050513          	addi	a0,a0,1968 # 8000bca0 <etext+0xca0>
    800094f8:	ffff7097          	auipc	ra,0xffff7
    800094fc:	0b0080e7          	jalr	176(ra) # 800005a8 <printf>
    80009500:	854a                	mv	a0,s2
    80009502:	ffff7097          	auipc	ra,0xffff7
    80009506:	5a2080e7          	jalr	1442(ra) # 80000aa4 <kfree>
    8000950a:	7902                	ld	s2,32(sp)
    8000950c:	69e2                	ld	s3,24(sp)
    8000950e:	6a42                	ld	s4,16(sp)
    80009510:	6aa2                	ld	s5,8(sp)
    80009512:	b72d                	j	8000943c <udp_bind+0xb2>
    80009514:	54fd                	li	s1,-1
    80009516:	69e2                	ld	s3,24(sp)
    80009518:	6a42                	ld	s4,16(sp)
    8000951a:	6aa2                	ld	s5,8(sp)
    8000951c:	b705                	j	8000943c <udp_bind+0xb2>

000000008000951e <udp_connect>:
    8000951e:	1141                	addi	sp,sp,-16
    80009520:	e406                	sd	ra,8(sp)
    80009522:	e022                	sd	s0,0(sp)
    80009524:	0800                	addi	s0,sp,16
    80009526:	4501                	li	a0,0
    80009528:	60a2                	ld	ra,8(sp)
    8000952a:	6402                	ld	s0,0(sp)
    8000952c:	0141                	addi	sp,sp,16
    8000952e:	8082                	ret

0000000080009530 <udp_close>:
    80009530:	1141                	addi	sp,sp,-16
    80009532:	e406                	sd	ra,8(sp)
    80009534:	e022                	sd	s0,0(sp)
    80009536:	0800                	addi	s0,sp,16
    80009538:	4501                	li	a0,0
    8000953a:	60a2                	ld	ra,8(sp)
    8000953c:	6402                	ld	s0,0(sp)
    8000953e:	0141                	addi	sp,sp,16
    80009540:	8082                	ret

0000000080009542 <udp_sendto>:
    80009542:	7159                	addi	sp,sp,-112
    80009544:	f486                	sd	ra,104(sp)
    80009546:	f0a2                	sd	s0,96(sp)
    80009548:	eca6                	sd	s1,88(sp)
    8000954a:	1880                	addi	s0,sp,112
    8000954c:	f8b43c23          	sd	a1,-104(s0)
    80009550:	84ba                	mv	s1,a4
    80009552:	473d                	li	a4,15
    80009554:	14f77363          	bgeu	a4,a5,8000969a <udp_sendto+0x158>
    80009558:	e8ca                	sd	s2,80(sp)
    8000955a:	fc56                	sd	s5,56(sp)
    8000955c:	8aaa                	mv	s5,a0
    8000955e:	8932                	mv	s2,a2
    80009560:	ffff9097          	auipc	ra,0xffff9
    80009564:	91e080e7          	jalr	-1762(ra) # 80001e7e <myproc>
    80009568:	46c1                	li	a3,16
    8000956a:	8626                	mv	a2,s1
    8000956c:	fb040593          	addi	a1,s0,-80
    80009570:	6928                	ld	a0,80(a0)
    80009572:	ffff8097          	auipc	ra,0xffff8
    80009576:	624080e7          	jalr	1572(ra) # 80001b96 <copyin>
    8000957a:	12054263          	bltz	a0,8000969e <udp_sendto+0x15c>
    8000957e:	e4ce                	sd	s3,72(sp)
    80009580:	e0d2                	sd	s4,64(sp)
    80009582:	fb442483          	lw	s1,-76(s0)
    80009586:	fa840593          	addi	a1,s0,-88
    8000958a:	8526                	mv	a0,s1
    8000958c:	00000097          	auipc	ra,0x0
    80009590:	390080e7          	jalr	912(ra) # 8000991c <arp_lookup>
    80009594:	57fd                	li	a5,-1
    80009596:	0ef50163          	beq	a0,a5,80009678 <udp_sendto+0x136>
    8000959a:	ffff7097          	auipc	ra,0xffff7
    8000959e:	678080e7          	jalr	1656(ra) # 80000c12 <kalloc>
    800095a2:	89aa                	mv	s3,a0
    800095a4:	00e50a13          	addi	s4,a0,14
    800095a8:	874a                	mv	a4,s2
    800095aa:	f9840693          	addi	a3,s0,-104
    800095ae:	fb245603          	lhu	a2,-78(s0)
    800095b2:	028ad583          	lhu	a1,40(s5)
    800095b6:	02250513          	addi	a0,a0,34
    800095ba:	00000097          	auipc	ra,0x0
    800095be:	c8e080e7          	jalr	-882(ra) # 80009248 <build_udp>
    800095c2:	00006797          	auipc	a5,0x6
    800095c6:	6e67a783          	lw	a5,1766(a5) # 8000fca8 <netconf>
    800095ca:	1942                	slli	s2,s2,0x30
    800095cc:	03095913          	srli	s2,s2,0x30
    800095d0:	01c9071b          	addiw	a4,s2,28
    800095d4:	0184961b          	slliw	a2,s1,0x18
    800095d8:	0184d69b          	srliw	a3,s1,0x18
    800095dc:	8e55                	or	a2,a2,a3
    800095de:	0084969b          	slliw	a3,s1,0x8
    800095e2:	00ff0837          	lui	a6,0xff0
    800095e6:	0106f6b3          	and	a3,a3,a6
    800095ea:	8e55                	or	a2,a2,a3
    800095ec:	0084d49b          	srliw	s1,s1,0x8
    800095f0:	66c1                	lui	a3,0x10
    800095f2:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800095f6:	8cf5                	and	s1,s1,a3
    800095f8:	0187959b          	slliw	a1,a5,0x18
    800095fc:	0187d51b          	srliw	a0,a5,0x18
    80009600:	8dc9                	or	a1,a1,a0
    80009602:	0087951b          	slliw	a0,a5,0x8
    80009606:	01057533          	and	a0,a0,a6
    8000960a:	8dc9                	or	a1,a1,a0
    8000960c:	0087d79b          	srliw	a5,a5,0x8
    80009610:	8ff5                	and	a5,a5,a3
    80009612:	1742                	slli	a4,a4,0x30
    80009614:	9341                	srli	a4,a4,0x30
    80009616:	46c5                	li	a3,17
    80009618:	8e45                	or	a2,a2,s1
    8000961a:	8ddd                	or	a1,a1,a5
    8000961c:	8552                	mv	a0,s4
    8000961e:	fffff097          	auipc	ra,0xfffff
    80009622:	820080e7          	jalr	-2016(ra) # 80007e3e <build_ip4>
    80009626:	6685                	lui	a3,0x1
    80009628:	80068693          	addi	a3,a3,-2048 # 800 <_entry-0x7ffff800>
    8000962c:	00006617          	auipc	a2,0x6
    80009630:	68060613          	addi	a2,a2,1664 # 8000fcac <netconf+0x4>
    80009634:	fa840593          	addi	a1,s0,-88
    80009638:	854e                	mv	a0,s3
    8000963a:	fffff097          	auipc	ra,0xfffff
    8000963e:	4a6080e7          	jalr	1190(ra) # 80008ae0 <build_eth>
    80009642:	02a9059b          	addiw	a1,s2,42
    80009646:	6605                	lui	a2,0x1
    80009648:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000964c:	15c2                	slli	a1,a1,0x30
    8000964e:	91c1                	srli	a1,a1,0x30
    80009650:	854e                	mv	a0,s3
    80009652:	ffffe097          	auipc	ra,0xffffe
    80009656:	190080e7          	jalr	400(ra) # 800077e2 <transmit_packet>
    8000965a:	854e                	mv	a0,s3
    8000965c:	ffff7097          	auipc	ra,0xffff7
    80009660:	448080e7          	jalr	1096(ra) # 80000aa4 <kfree>
    80009664:	4501                	li	a0,0
    80009666:	6946                	ld	s2,80(sp)
    80009668:	69a6                	ld	s3,72(sp)
    8000966a:	6a06                	ld	s4,64(sp)
    8000966c:	7ae2                	ld	s5,56(sp)
    8000966e:	70a6                	ld	ra,104(sp)
    80009670:	7406                	ld	s0,96(sp)
    80009672:	64e6                	ld	s1,88(sp)
    80009674:	6165                	addi	sp,sp,112
    80009676:	8082                	ret
    80009678:	8526                	mv	a0,s1
    8000967a:	00000097          	auipc	ra,0x0
    8000967e:	386080e7          	jalr	902(ra) # 80009a00 <arp_request>
    80009682:	fa840a13          	addi	s4,s0,-88
    80009686:	59fd                	li	s3,-1
    80009688:	85d2                	mv	a1,s4
    8000968a:	8526                	mv	a0,s1
    8000968c:	00000097          	auipc	ra,0x0
    80009690:	290080e7          	jalr	656(ra) # 8000991c <arp_lookup>
    80009694:	ff350ae3          	beq	a0,s3,80009688 <udp_sendto+0x146>
    80009698:	b709                	j	8000959a <udp_sendto+0x58>
    8000969a:	557d                	li	a0,-1
    8000969c:	bfc9                	j	8000966e <udp_sendto+0x12c>
    8000969e:	557d                	li	a0,-1
    800096a0:	6946                	ld	s2,80(sp)
    800096a2:	7ae2                	ld	s5,56(sp)
    800096a4:	b7e9                	j	8000966e <udp_sendto+0x12c>

00000000800096a6 <udp_recvfrom>:
    800096a6:	7139                	addi	sp,sp,-64
    800096a8:	fc06                	sd	ra,56(sp)
    800096aa:	f822                	sd	s0,48(sp)
    800096ac:	f426                	sd	s1,40(sp)
    800096ae:	f04a                	sd	s2,32(sp)
    800096b0:	ec4e                	sd	s3,24(sp)
    800096b2:	e852                	sd	s4,16(sp)
    800096b4:	0080                	addi	s0,sp,64
    800096b6:	84aa                	mv	s1,a0
    800096b8:	8a2e                	mv	s4,a1
    800096ba:	89b2                	mv	s3,a2
    800096bc:	00850913          	addi	s2,a0,8
    800096c0:	854a                	mv	a0,s2
    800096c2:	ffff7097          	auipc	ra,0xffff7
    800096c6:	672080e7          	jalr	1650(ra) # 80000d34 <acquire>
    800096ca:	68bc                	ld	a5,80(s1)
    800096cc:	ef89                	bnez	a5,800096e6 <udp_recvfrom+0x40>
    800096ce:	e456                	sd	s5,8(sp)
    800096d0:	05048a93          	addi	s5,s1,80
    800096d4:	85ca                	mv	a1,s2
    800096d6:	8556                	mv	a0,s5
    800096d8:	ffff9097          	auipc	ra,0xffff9
    800096dc:	05c080e7          	jalr	92(ra) # 80002734 <sleep>
    800096e0:	68bc                	ld	a5,80(s1)
    800096e2:	dbed                	beqz	a5,800096d4 <udp_recvfrom+0x2e>
    800096e4:	6aa2                	ld	s5,8(sp)
    800096e6:	00002517          	auipc	a0,0x2
    800096ea:	72a50513          	addi	a0,a0,1834 # 8000be10 <etext+0xe10>
    800096ee:	ffff7097          	auipc	ra,0xffff7
    800096f2:	eba080e7          	jalr	-326(ra) # 800005a8 <printf>
    800096f6:	8526                	mv	a0,s1
    800096f8:	00000097          	auipc	ra,0x0
    800096fc:	c36080e7          	jalr	-970(ra) # 8000932e <dequeue_udp_packet>
    80009700:	84aa                	mv	s1,a0
    80009702:	854a                	mv	a0,s2
    80009704:	ffff7097          	auipc	ra,0xffff7
    80009708:	6e0080e7          	jalr	1760(ra) # 80000de4 <release>
    8000970c:	5e44c703          	lbu	a4,1508(s1)
    80009710:	5e54c783          	lbu	a5,1509(s1)
    80009714:	07a2                	slli	a5,a5,0x8
    80009716:	8fd9                	or	a5,a5,a4
    80009718:	5e64c703          	lbu	a4,1510(s1)
    8000971c:	0742                	slli	a4,a4,0x10
    8000971e:	8f5d                	or	a4,a4,a5
    80009720:	5e74c783          	lbu	a5,1511(s1)
    80009724:	07e2                	slli	a5,a5,0x18
    80009726:	8fd9                	or	a5,a5,a4
    80009728:	2781                	sext.w	a5,a5
    8000972a:	893e                	mv	s2,a5
    8000972c:	2781                	sext.w	a5,a5
    8000972e:	00f9d363          	bge	s3,a5,80009734 <udp_recvfrom+0x8e>
    80009732:	894e                	mv	s2,s3
    80009734:	2901                	sext.w	s2,s2
    80009736:	ffff8097          	auipc	ra,0xffff8
    8000973a:	748080e7          	jalr	1864(ra) # 80001e7e <myproc>
    8000973e:	5e44c783          	lbu	a5,1508(s1)
    80009742:	5e54c703          	lbu	a4,1509(s1)
    80009746:	0722                	slli	a4,a4,0x8
    80009748:	8f5d                	or	a4,a4,a5
    8000974a:	5e64c783          	lbu	a5,1510(s1)
    8000974e:	07c2                	slli	a5,a5,0x10
    80009750:	8fd9                	or	a5,a5,a4
    80009752:	5e74c683          	lbu	a3,1511(s1)
    80009756:	06e2                	slli	a3,a3,0x18
    80009758:	8edd                	or	a3,a3,a5
    8000975a:	2681                	sext.w	a3,a3
    8000975c:	00848613          	addi	a2,s1,8
    80009760:	85d2                	mv	a1,s4
    80009762:	6928                	ld	a0,80(a0)
    80009764:	ffff8097          	auipc	ra,0xffff8
    80009768:	3a6080e7          	jalr	934(ra) # 80001b0a <copyout>
    8000976c:	02054063          	bltz	a0,8000978c <udp_recvfrom+0xe6>
    80009770:	8526                	mv	a0,s1
    80009772:	ffff7097          	auipc	ra,0xffff7
    80009776:	332080e7          	jalr	818(ra) # 80000aa4 <kfree>
    8000977a:	854a                	mv	a0,s2
    8000977c:	70e2                	ld	ra,56(sp)
    8000977e:	7442                	ld	s0,48(sp)
    80009780:	74a2                	ld	s1,40(sp)
    80009782:	7902                	ld	s2,32(sp)
    80009784:	69e2                	ld	s3,24(sp)
    80009786:	6a42                	ld	s4,16(sp)
    80009788:	6121                	addi	sp,sp,64
    8000978a:	8082                	ret
    8000978c:	8526                	mv	a0,s1
    8000978e:	ffff7097          	auipc	ra,0xffff7
    80009792:	316080e7          	jalr	790(ra) # 80000aa4 <kfree>
    80009796:	597d                	li	s2,-1
    80009798:	b7cd                	j	8000977a <udp_recvfrom+0xd4>

000000008000979a <handle_udp_packet>:
    8000979a:	1101                	addi	sp,sp,-32
    8000979c:	ec06                	sd	ra,24(sp)
    8000979e:	e822                	sd	s0,16(sp)
    800097a0:	e426                	sd	s1,8(sp)
    800097a2:	1000                	addi	s0,sp,32
    800097a4:	84aa                	mv	s1,a0
    800097a6:	00654883          	lbu	a7,6(a0)
    800097aa:	00754703          	lbu	a4,7(a0)
    800097ae:	0722                	slli	a4,a4,0x8
    800097b0:	00454803          	lbu	a6,4(a0)
    800097b4:	00554683          	lbu	a3,5(a0)
    800097b8:	06a2                	slli	a3,a3,0x8
    800097ba:	00254503          	lbu	a0,2(a0)
    800097be:	0034c603          	lbu	a2,3(s1)
    800097c2:	0622                	slli	a2,a2,0x8
    800097c4:	0004c583          	lbu	a1,0(s1)
    800097c8:	0014c783          	lbu	a5,1(s1)
    800097cc:	07a2                	slli	a5,a5,0x8
    800097ce:	01176733          	or	a4,a4,a7
    800097d2:	0106e6b3          	or	a3,a3,a6
    800097d6:	8e49                	or	a2,a2,a0
    800097d8:	8ddd                	or	a1,a1,a5
    800097da:	00002517          	auipc	a0,0x2
    800097de:	64e50513          	addi	a0,a0,1614 # 8000be28 <etext+0xe28>
    800097e2:	ffff7097          	auipc	ra,0xffff7
    800097e6:	dc6080e7          	jalr	-570(ra) # 800005a8 <printf>
    800097ea:	0024c683          	lbu	a3,2(s1)
    800097ee:	0034c783          	lbu	a5,3(s1)
    800097f2:	07a2                	slli	a5,a5,0x8
    800097f4:	00d7e733          	or	a4,a5,a3
    800097f8:	1ff00693          	li	a3,511
    800097fc:	06e6e463          	bltu	a3,a4,80009864 <handle_udp_packet+0xca>
    80009800:	070e                	slli	a4,a4,0x3
    80009802:	00069797          	auipc	a5,0x69
    80009806:	f9678793          	addi	a5,a5,-106 # 80072798 <udp_port_binds>
    8000980a:	97ba                	add	a5,a5,a4
    8000980c:	639c                	ld	a5,0(a5)
    8000980e:	c385                	beqz	a5,8000982e <handle_udp_packet+0x94>
    80009810:	e04a                	sd	s2,0(sp)
    80009812:	0087b903          	ld	s2,8(a5)
    80009816:	03092703          	lw	a4,48(s2)
    8000981a:	47c5                	li	a5,17
    8000981c:	4501                	li	a0,0
    8000981e:	02f70263          	beq	a4,a5,80009842 <handle_udp_packet+0xa8>
    80009822:	6902                	ld	s2,0(sp)
    80009824:	60e2                	ld	ra,24(sp)
    80009826:	6442                	ld	s0,16(sp)
    80009828:	64a2                	ld	s1,8(sp)
    8000982a:	6105                	addi	sp,sp,32
    8000982c:	8082                	ret
    8000982e:	00002517          	auipc	a0,0x2
    80009832:	63250513          	addi	a0,a0,1586 # 8000be60 <etext+0xe60>
    80009836:	ffff7097          	auipc	ra,0xffff7
    8000983a:	d72080e7          	jalr	-654(ra) # 800005a8 <printf>
    8000983e:	557d                	li	a0,-1
    80009840:	b7d5                	j	80009824 <handle_udp_packet+0x8a>
    80009842:	00002517          	auipc	a0,0x2
    80009846:	63e50513          	addi	a0,a0,1598 # 8000be80 <etext+0xe80>
    8000984a:	ffff7097          	auipc	ra,0xffff7
    8000984e:	d5e080e7          	jalr	-674(ra) # 800005a8 <printf>
    80009852:	85ca                	mv	a1,s2
    80009854:	8526                	mv	a0,s1
    80009856:	00000097          	auipc	ra,0x0
    8000985a:	a74080e7          	jalr	-1420(ra) # 800092ca <enqueue_udp_packet>
    8000985e:	4501                	li	a0,0
    80009860:	6902                	ld	s2,0(sp)
    80009862:	b7c9                	j	80009824 <handle_udp_packet+0x8a>
    80009864:	557d                	li	a0,-1
    80009866:	bf7d                	j	80009824 <handle_udp_packet+0x8a>

0000000080009868 <parse_udp_packet>:
    80009868:	471d                	li	a4,7
    8000986a:	0ab75363          	bge	a4,a1,80009910 <parse_udp_packet+0xa8>
    8000986e:	87b2                	mv	a5,a2
    80009870:	00055703          	lhu	a4,0(a0)
    80009874:	00875693          	srli	a3,a4,0x8
    80009878:	00d60023          	sb	a3,0(a2)
    8000987c:	00e600a3          	sb	a4,1(a2)
    80009880:	00255703          	lhu	a4,2(a0)
    80009884:	00875693          	srli	a3,a4,0x8
    80009888:	00d60123          	sb	a3,2(a2)
    8000988c:	00e601a3          	sb	a4,3(a2)
    80009890:	00455703          	lhu	a4,4(a0)
    80009894:	00875693          	srli	a3,a4,0x8
    80009898:	0087171b          	slliw	a4,a4,0x8
    8000989c:	8ed9                	or	a3,a3,a4
    8000989e:	03069713          	slli	a4,a3,0x30
    800098a2:	9341                	srli	a4,a4,0x30
    800098a4:	00d60223          	sb	a3,4(a2)
    800098a8:	00875693          	srli	a3,a4,0x8
    800098ac:	00d602a3          	sb	a3,5(a2)
    800098b0:	00655683          	lhu	a3,6(a0)
    800098b4:	0086d613          	srli	a2,a3,0x8
    800098b8:	00c78323          	sb	a2,6(a5)
    800098bc:	00d783a3          	sb	a3,7(a5)
    800098c0:	0007061b          	sext.w	a2,a4
    800098c4:	469d                	li	a3,7
    800098c6:	04c6f763          	bgeu	a3,a2,80009914 <parse_udp_packet+0xac>
    800098ca:	04c5c763          	blt	a1,a2,80009918 <parse_udp_packet+0xb0>
    800098ce:	1141                	addi	sp,sp,-16
    800098d0:	e406                	sd	ra,8(sp)
    800098d2:	e022                	sd	s0,0(sp)
    800098d4:	0800                	addi	s0,sp,16
    800098d6:	ff85861b          	addiw	a2,a1,-8
    800098da:	5ec78223          	sb	a2,1508(a5)
    800098de:	0086571b          	srliw	a4,a2,0x8
    800098e2:	5ee782a3          	sb	a4,1509(a5)
    800098e6:	0106571b          	srliw	a4,a2,0x10
    800098ea:	5ee78323          	sb	a4,1510(a5)
    800098ee:	0186571b          	srliw	a4,a2,0x18
    800098f2:	5ee783a3          	sb	a4,1511(a5)
    800098f6:	00850593          	addi	a1,a0,8
    800098fa:	00878513          	addi	a0,a5,8
    800098fe:	ffff7097          	auipc	ra,0xffff7
    80009902:	58e080e7          	jalr	1422(ra) # 80000e8c <memmove>
    80009906:	4501                	li	a0,0
    80009908:	60a2                	ld	ra,8(sp)
    8000990a:	6402                	ld	s0,0(sp)
    8000990c:	0141                	addi	sp,sp,16
    8000990e:	8082                	ret
    80009910:	557d                	li	a0,-1
    80009912:	8082                	ret
    80009914:	557d                	li	a0,-1
    80009916:	8082                	ret
    80009918:	557d                	li	a0,-1
    8000991a:	8082                	ret

000000008000991c <arp_lookup>:
    8000991c:	1101                	addi	sp,sp,-32
    8000991e:	ec06                	sd	ra,24(sp)
    80009920:	e822                	sd	s0,16(sp)
    80009922:	e426                	sd	s1,8(sp)
    80009924:	1000                	addi	s0,sp,32
    80009926:	88aa                	mv	a7,a0
    80009928:	852e                	mv	a0,a1
    8000992a:	0006a797          	auipc	a5,0x6a
    8000992e:	e6e78793          	addi	a5,a5,-402 # 80073798 <arp_cache>
    80009932:	4701                	li	a4,0
    80009934:	4685                	li	a3,1
    80009936:	4641                	li	a2,16
    80009938:	a029                	j	80009942 <arp_lookup+0x26>
    8000993a:	2705                	addiw	a4,a4,1
    8000993c:	07c1                	addi	a5,a5,16
    8000993e:	02c70563          	beq	a4,a2,80009968 <arp_lookup+0x4c>
    80009942:	47c4                	lw	s1,12(a5)
    80009944:	fed49be3          	bne	s1,a3,8000993a <arp_lookup+0x1e>
    80009948:	0007a803          	lw	a6,0(a5)
    8000994c:	ff1817e3          	bne	a6,a7,8000993a <arp_lookup+0x1e>
    80009950:	0712                	slli	a4,a4,0x4
    80009952:	4619                	li	a2,6
    80009954:	0006a597          	auipc	a1,0x6a
    80009958:	e4858593          	addi	a1,a1,-440 # 8007379c <arp_cache+0x4>
    8000995c:	95ba                	add	a1,a1,a4
    8000995e:	ffff7097          	auipc	ra,0xffff7
    80009962:	52e080e7          	jalr	1326(ra) # 80000e8c <memmove>
    80009966:	a011                	j	8000996a <arp_lookup+0x4e>
    80009968:	54fd                	li	s1,-1
    8000996a:	8526                	mv	a0,s1
    8000996c:	60e2                	ld	ra,24(sp)
    8000996e:	6442                	ld	s0,16(sp)
    80009970:	64a2                	ld	s1,8(sp)
    80009972:	6105                	addi	sp,sp,32
    80009974:	8082                	ret

0000000080009976 <arp_insert>:
    80009976:	1101                	addi	sp,sp,-32
    80009978:	ec06                	sd	ra,24(sp)
    8000997a:	e822                	sd	s0,16(sp)
    8000997c:	1000                	addi	s0,sp,32
    8000997e:	0006a797          	auipc	a5,0x6a
    80009982:	e1a78793          	addi	a5,a5,-486 # 80073798 <arp_cache>
    80009986:	4701                	li	a4,0
    80009988:	4605                	li	a2,1
    8000998a:	4841                	li	a6,16
    8000998c:	4394                	lw	a3,0(a5)
    8000998e:	00a68d63          	beq	a3,a0,800099a8 <arp_insert+0x32>
    80009992:	47d4                	lw	a3,12(a5)
    80009994:	04c69163          	bne	a3,a2,800099d6 <arp_insert+0x60>
    80009998:	2705                	addiw	a4,a4,1
    8000999a:	07c1                	addi	a5,a5,16
    8000999c:	ff0718e3          	bne	a4,a6,8000998c <arp_insert+0x16>
    800099a0:	60e2                	ld	ra,24(sp)
    800099a2:	6442                	ld	s0,16(sp)
    800099a4:	6105                	addi	sp,sp,32
    800099a6:	8082                	ret
    800099a8:	e426                	sd	s1,8(sp)
    800099aa:	e04a                	sd	s2,0(sp)
    800099ac:	0006a917          	auipc	s2,0x6a
    800099b0:	dec90913          	addi	s2,s2,-532 # 80073798 <arp_cache>
    800099b4:	00471493          	slli	s1,a4,0x4
    800099b8:	00448513          	addi	a0,s1,4
    800099bc:	4619                	li	a2,6
    800099be:	954a                	add	a0,a0,s2
    800099c0:	ffff7097          	auipc	ra,0xffff7
    800099c4:	4cc080e7          	jalr	1228(ra) # 80000e8c <memmove>
    800099c8:	9926                	add	s2,s2,s1
    800099ca:	4785                	li	a5,1
    800099cc:	00f92623          	sw	a5,12(s2)
    800099d0:	64a2                	ld	s1,8(sp)
    800099d2:	6902                	ld	s2,0(sp)
    800099d4:	b7f1                	j	800099a0 <arp_insert+0x2a>
    800099d6:	e426                	sd	s1,8(sp)
    800099d8:	0006a797          	auipc	a5,0x6a
    800099dc:	dc078793          	addi	a5,a5,-576 # 80073798 <arp_cache>
    800099e0:	0712                	slli	a4,a4,0x4
    800099e2:	00e784b3          	add	s1,a5,a4
    800099e6:	c088                	sw	a0,0(s1)
    800099e8:	0711                	addi	a4,a4,4
    800099ea:	4619                	li	a2,6
    800099ec:	00e78533          	add	a0,a5,a4
    800099f0:	ffff7097          	auipc	ra,0xffff7
    800099f4:	49c080e7          	jalr	1180(ra) # 80000e8c <memmove>
    800099f8:	4785                	li	a5,1
    800099fa:	c4dc                	sw	a5,12(s1)
    800099fc:	64a2                	ld	s1,8(sp)
    800099fe:	b74d                	j	800099a0 <arp_insert+0x2a>

0000000080009a00 <arp_request>:
    80009a00:	7139                	addi	sp,sp,-64
    80009a02:	fc06                	sd	ra,56(sp)
    80009a04:	f822                	sd	s0,48(sp)
    80009a06:	f04a                	sd	s2,32(sp)
    80009a08:	0080                	addi	s0,sp,64
    80009a0a:	892a                	mv	s2,a0
    80009a0c:	ffff7097          	auipc	ra,0xffff7
    80009a10:	206080e7          	jalr	518(ra) # 80000c12 <kalloc>
    80009a14:	10050263          	beqz	a0,80009b18 <arp_request+0x118>
    80009a18:	f426                	sd	s1,40(sp)
    80009a1a:	ec4e                	sd	s3,24(sp)
    80009a1c:	e852                	sd	s4,16(sp)
    80009a1e:	84aa                	mv	s1,a0
    80009a20:	57fd                	li	a5,-1
    80009a22:	fcf42423          	sw	a5,-56(s0)
    80009a26:	fcf41623          	sh	a5,-52(s0)
    80009a2a:	fc840a13          	addi	s4,s0,-56
    80009a2e:	6685                	lui	a3,0x1
    80009a30:	80668693          	addi	a3,a3,-2042 # 806 <_entry-0x7ffff7fa>
    80009a34:	00006617          	auipc	a2,0x6
    80009a38:	27860613          	addi	a2,a2,632 # 8000fcac <netconf+0x4>
    80009a3c:	85d2                	mv	a1,s4
    80009a3e:	fffff097          	auipc	ra,0xfffff
    80009a42:	0a2080e7          	jalr	162(ra) # 80008ae0 <build_eth>
    80009a46:	00048723          	sb	zero,14(s1)
    80009a4a:	4785                	li	a5,1
    80009a4c:	00f487a3          	sb	a5,15(s1)
    80009a50:	4721                	li	a4,8
    80009a52:	00e48823          	sb	a4,16(s1)
    80009a56:	000488a3          	sb	zero,17(s1)
    80009a5a:	4999                	li	s3,6
    80009a5c:	01348923          	sb	s3,18(s1)
    80009a60:	4711                	li	a4,4
    80009a62:	00e489a3          	sb	a4,19(s1)
    80009a66:	00048a23          	sb	zero,20(s1)
    80009a6a:	00f48aa3          	sb	a5,21(s1)
    80009a6e:	00006797          	auipc	a5,0x6
    80009a72:	23a78793          	addi	a5,a5,570 # 8000fca8 <netconf>
    80009a76:	0007c703          	lbu	a4,0(a5)
    80009a7a:	00e48e23          	sb	a4,28(s1)
    80009a7e:	439c                	lw	a5,0(a5)
    80009a80:	0087d71b          	srliw	a4,a5,0x8
    80009a84:	00e48ea3          	sb	a4,29(s1)
    80009a88:	0107d71b          	srliw	a4,a5,0x10
    80009a8c:	00e48f23          	sb	a4,30(s1)
    80009a90:	0187d79b          	srliw	a5,a5,0x18
    80009a94:	00f48fa3          	sb	a5,31(s1)
    80009a98:	03248323          	sb	s2,38(s1)
    80009a9c:	0089579b          	srliw	a5,s2,0x8
    80009aa0:	02f483a3          	sb	a5,39(s1)
    80009aa4:	0109579b          	srliw	a5,s2,0x10
    80009aa8:	02f48423          	sb	a5,40(s1)
    80009aac:	0189591b          	srliw	s2,s2,0x18
    80009ab0:	032484a3          	sb	s2,41(s1)
    80009ab4:	864e                	mv	a2,s3
    80009ab6:	00006597          	auipc	a1,0x6
    80009aba:	1f658593          	addi	a1,a1,502 # 8000fcac <netconf+0x4>
    80009abe:	01648513          	addi	a0,s1,22
    80009ac2:	ffff7097          	auipc	ra,0xffff7
    80009ac6:	3ca080e7          	jalr	970(ra) # 80000e8c <memmove>
    80009aca:	864e                	mv	a2,s3
    80009acc:	85d2                	mv	a1,s4
    80009ace:	02048513          	addi	a0,s1,32
    80009ad2:	ffff7097          	auipc	ra,0xffff7
    80009ad6:	3ba080e7          	jalr	954(ra) # 80000e8c <memmove>
    80009ada:	00002517          	auipc	a0,0x2
    80009ade:	3be50513          	addi	a0,a0,958 # 8000be98 <etext+0xe98>
    80009ae2:	ffff7097          	auipc	ra,0xffff7
    80009ae6:	ac6080e7          	jalr	-1338(ra) # 800005a8 <printf>
    80009aea:	6605                	lui	a2,0x1
    80009aec:	80660613          	addi	a2,a2,-2042 # 806 <_entry-0x7ffff7fa>
    80009af0:	02a00593          	li	a1,42
    80009af4:	8526                	mv	a0,s1
    80009af6:	ffffe097          	auipc	ra,0xffffe
    80009afa:	cec080e7          	jalr	-788(ra) # 800077e2 <transmit_packet>
    80009afe:	8526                	mv	a0,s1
    80009b00:	ffff7097          	auipc	ra,0xffff7
    80009b04:	fa4080e7          	jalr	-92(ra) # 80000aa4 <kfree>
    80009b08:	74a2                	ld	s1,40(sp)
    80009b0a:	69e2                	ld	s3,24(sp)
    80009b0c:	6a42                	ld	s4,16(sp)
    80009b0e:	70e2                	ld	ra,56(sp)
    80009b10:	7442                	ld	s0,48(sp)
    80009b12:	7902                	ld	s2,32(sp)
    80009b14:	6121                	addi	sp,sp,64
    80009b16:	8082                	ret
    80009b18:	00002517          	auipc	a0,0x2
    80009b1c:	96050513          	addi	a0,a0,-1696 # 8000b478 <etext+0x478>
    80009b20:	ffff7097          	auipc	ra,0xffff7
    80009b24:	a88080e7          	jalr	-1400(ra) # 800005a8 <printf>
    80009b28:	b7dd                	j	80009b0e <arp_request+0x10e>

0000000080009b2a <arp_recv>:
    80009b2a:	7179                	addi	sp,sp,-48
    80009b2c:	f406                	sd	ra,40(sp)
    80009b2e:	f022                	sd	s0,32(sp)
    80009b30:	ec26                	sd	s1,24(sp)
    80009b32:	e052                	sd	s4,0(sp)
    80009b34:	1800                	addi	s0,sp,48
    80009b36:	8a2a                	mv	s4,a0
    80009b38:	00654683          	lbu	a3,6(a0)
    80009b3c:	00754783          	lbu	a5,7(a0)
    80009b40:	07a2                	slli	a5,a5,0x8
    80009b42:	00d7e733          	or	a4,a5,a3
    80009b46:	10000693          	li	a3,256
    80009b4a:	06d70f63          	beq	a4,a3,80009bc8 <arp_recv+0x9e>
    80009b4e:	e84a                	sd	s2,16(sp)
    80009b50:	e44e                	sd	s3,8(sp)
    80009b52:	2701                	sext.w	a4,a4
    80009b54:	20000793          	li	a5,512
    80009b58:	84aa                	mv	s1,a0
    80009b5a:	01c50993          	addi	s3,a0,28
    80009b5e:	00002917          	auipc	s2,0x2
    80009b62:	36290913          	addi	s2,s2,866 # 8000bec0 <etext+0xec0>
    80009b66:	1cf70863          	beq	a4,a5,80009d36 <arp_recv+0x20c>
    80009b6a:	0004c583          	lbu	a1,0(s1)
    80009b6e:	854a                	mv	a0,s2
    80009b70:	ffff7097          	auipc	ra,0xffff7
    80009b74:	a38080e7          	jalr	-1480(ra) # 800005a8 <printf>
    80009b78:	0485                	addi	s1,s1,1
    80009b7a:	ff3498e3          	bne	s1,s3,80009b6a <arp_recv+0x40>
    80009b7e:	00001517          	auipc	a0,0x1
    80009b82:	4a250513          	addi	a0,a0,1186 # 8000b020 <etext+0x20>
    80009b86:	ffff7097          	auipc	ra,0xffff7
    80009b8a:	a22080e7          	jalr	-1502(ra) # 800005a8 <printf>
    80009b8e:	006a4703          	lbu	a4,6(s4)
    80009b92:	007a4783          	lbu	a5,7(s4)
    80009b96:	07a2                	slli	a5,a5,0x8
    80009b98:	8f5d                	or	a4,a4,a5
    80009b9a:	83a1                	srli	a5,a5,0x8
    80009b9c:	0087171b          	slliw	a4,a4,0x8
    80009ba0:	00e7e5b3          	or	a1,a5,a4
    80009ba4:	15c2                	slli	a1,a1,0x30
    80009ba6:	91c1                	srli	a1,a1,0x30
    80009ba8:	00002517          	auipc	a0,0x2
    80009bac:	32050513          	addi	a0,a0,800 # 8000bec8 <etext+0xec8>
    80009bb0:	ffff7097          	auipc	ra,0xffff7
    80009bb4:	9f8080e7          	jalr	-1544(ra) # 800005a8 <printf>
    80009bb8:	6942                	ld	s2,16(sp)
    80009bba:	69a2                	ld	s3,8(sp)
    80009bbc:	70a2                	ld	ra,40(sp)
    80009bbe:	7402                	ld	s0,32(sp)
    80009bc0:	64e2                	ld	s1,24(sp)
    80009bc2:	6a02                	ld	s4,0(sp)
    80009bc4:	6145                	addi	sp,sp,48
    80009bc6:	8082                	ret
    80009bc8:	ffff7097          	auipc	ra,0xffff7
    80009bcc:	04a080e7          	jalr	74(ra) # 80000c12 <kalloc>
    80009bd0:	84aa                	mv	s1,a0
    80009bd2:	14050963          	beqz	a0,80009d24 <arp_recv+0x1fa>
    80009bd6:	e84a                	sd	s2,16(sp)
    80009bd8:	008a0913          	addi	s2,s4,8
    80009bdc:	00ea4783          	lbu	a5,14(s4)
    80009be0:	00fa4703          	lbu	a4,15(s4)
    80009be4:	0722                	slli	a4,a4,0x8
    80009be6:	8f5d                	or	a4,a4,a5
    80009be8:	010a4783          	lbu	a5,16(s4)
    80009bec:	07c2                	slli	a5,a5,0x10
    80009bee:	8fd9                	or	a5,a5,a4
    80009bf0:	011a4503          	lbu	a0,17(s4)
    80009bf4:	0562                	slli	a0,a0,0x18
    80009bf6:	8d5d                	or	a0,a0,a5
    80009bf8:	85ca                	mv	a1,s2
    80009bfa:	2501                	sext.w	a0,a0
    80009bfc:	00000097          	auipc	ra,0x0
    80009c00:	d7a080e7          	jalr	-646(ra) # 80009976 <arp_insert>
    80009c04:	018a4703          	lbu	a4,24(s4)
    80009c08:	019a4783          	lbu	a5,25(s4)
    80009c0c:	07a2                	slli	a5,a5,0x8
    80009c0e:	8fd9                	or	a5,a5,a4
    80009c10:	01aa4703          	lbu	a4,26(s4)
    80009c14:	0742                	slli	a4,a4,0x10
    80009c16:	8f5d                	or	a4,a4,a5
    80009c18:	01ba4783          	lbu	a5,27(s4)
    80009c1c:	07e2                	slli	a5,a5,0x18
    80009c1e:	8fd9                	or	a5,a5,a4
    80009c20:	2781                	sext.w	a5,a5
    80009c22:	00006717          	auipc	a4,0x6
    80009c26:	08672703          	lw	a4,134(a4) # 8000fca8 <netconf>
    80009c2a:	00f70563          	beq	a4,a5,80009c34 <arp_recv+0x10a>
    80009c2e:	577d                	li	a4,-1
    80009c30:	12e79b63          	bne	a5,a4,80009d66 <arp_recv+0x23c>
    80009c34:	e44e                	sd	s3,8(sp)
    80009c36:	6685                	lui	a3,0x1
    80009c38:	80668693          	addi	a3,a3,-2042 # 806 <_entry-0x7ffff7fa>
    80009c3c:	00006617          	auipc	a2,0x6
    80009c40:	07060613          	addi	a2,a2,112 # 8000fcac <netconf+0x4>
    80009c44:	85ca                	mv	a1,s2
    80009c46:	8526                	mv	a0,s1
    80009c48:	fffff097          	auipc	ra,0xfffff
    80009c4c:	e98080e7          	jalr	-360(ra) # 80008ae0 <build_eth>
    80009c50:	00048723          	sb	zero,14(s1)
    80009c54:	4785                	li	a5,1
    80009c56:	00f487a3          	sb	a5,15(s1)
    80009c5a:	47a1                	li	a5,8
    80009c5c:	00f48823          	sb	a5,16(s1)
    80009c60:	000488a3          	sb	zero,17(s1)
    80009c64:	4999                	li	s3,6
    80009c66:	01348923          	sb	s3,18(s1)
    80009c6a:	4791                	li	a5,4
    80009c6c:	00f489a3          	sb	a5,19(s1)
    80009c70:	00048a23          	sb	zero,20(s1)
    80009c74:	4789                	li	a5,2
    80009c76:	00f48aa3          	sb	a5,21(s1)
    80009c7a:	00006797          	auipc	a5,0x6
    80009c7e:	02e78793          	addi	a5,a5,46 # 8000fca8 <netconf>
    80009c82:	0007c703          	lbu	a4,0(a5)
    80009c86:	00e48e23          	sb	a4,28(s1)
    80009c8a:	439c                	lw	a5,0(a5)
    80009c8c:	0087d71b          	srliw	a4,a5,0x8
    80009c90:	00e48ea3          	sb	a4,29(s1)
    80009c94:	0107d71b          	srliw	a4,a5,0x10
    80009c98:	00e48f23          	sb	a4,30(s1)
    80009c9c:	0187d79b          	srliw	a5,a5,0x18
    80009ca0:	00f48fa3          	sb	a5,31(s1)
    80009ca4:	00ea4703          	lbu	a4,14(s4)
    80009ca8:	00fa4783          	lbu	a5,15(s4)
    80009cac:	07a2                	slli	a5,a5,0x8
    80009cae:	8fd9                	or	a5,a5,a4
    80009cb0:	010a4703          	lbu	a4,16(s4)
    80009cb4:	0742                	slli	a4,a4,0x10
    80009cb6:	8f5d                	or	a4,a4,a5
    80009cb8:	011a4783          	lbu	a5,17(s4)
    80009cbc:	07e2                	slli	a5,a5,0x18
    80009cbe:	8fd9                	or	a5,a5,a4
    80009cc0:	02f48323          	sb	a5,38(s1)
    80009cc4:	0087d713          	srli	a4,a5,0x8
    80009cc8:	02e483a3          	sb	a4,39(s1)
    80009ccc:	0107d713          	srli	a4,a5,0x10
    80009cd0:	02e48423          	sb	a4,40(s1)
    80009cd4:	83e1                	srli	a5,a5,0x18
    80009cd6:	02f484a3          	sb	a5,41(s1)
    80009cda:	864e                	mv	a2,s3
    80009cdc:	00006597          	auipc	a1,0x6
    80009ce0:	fd058593          	addi	a1,a1,-48 # 8000fcac <netconf+0x4>
    80009ce4:	01648513          	addi	a0,s1,22
    80009ce8:	ffff7097          	auipc	ra,0xffff7
    80009cec:	1a4080e7          	jalr	420(ra) # 80000e8c <memmove>
    80009cf0:	864e                	mv	a2,s3
    80009cf2:	85ca                	mv	a1,s2
    80009cf4:	02048513          	addi	a0,s1,32
    80009cf8:	ffff7097          	auipc	ra,0xffff7
    80009cfc:	194080e7          	jalr	404(ra) # 80000e8c <memmove>
    80009d00:	6605                	lui	a2,0x1
    80009d02:	80660613          	addi	a2,a2,-2042 # 806 <_entry-0x7ffff7fa>
    80009d06:	02a00593          	li	a1,42
    80009d0a:	8526                	mv	a0,s1
    80009d0c:	ffffe097          	auipc	ra,0xffffe
    80009d10:	ad6080e7          	jalr	-1322(ra) # 800077e2 <transmit_packet>
    80009d14:	8526                	mv	a0,s1
    80009d16:	ffff7097          	auipc	ra,0xffff7
    80009d1a:	d8e080e7          	jalr	-626(ra) # 80000aa4 <kfree>
    80009d1e:	6942                	ld	s2,16(sp)
    80009d20:	69a2                	ld	s3,8(sp)
    80009d22:	bd69                	j	80009bbc <arp_recv+0x92>
    80009d24:	00001517          	auipc	a0,0x1
    80009d28:	75450513          	addi	a0,a0,1876 # 8000b478 <etext+0x478>
    80009d2c:	ffff7097          	auipc	ra,0xffff7
    80009d30:	87c080e7          	jalr	-1924(ra) # 800005a8 <printf>
    80009d34:	b561                	j	80009bbc <arp_recv+0x92>
    80009d36:	00e54783          	lbu	a5,14(a0)
    80009d3a:	00f54703          	lbu	a4,15(a0)
    80009d3e:	0722                	slli	a4,a4,0x8
    80009d40:	8f5d                	or	a4,a4,a5
    80009d42:	01054783          	lbu	a5,16(a0)
    80009d46:	07c2                	slli	a5,a5,0x10
    80009d48:	8fd9                	or	a5,a5,a4
    80009d4a:	01154503          	lbu	a0,17(a0)
    80009d4e:	0562                	slli	a0,a0,0x18
    80009d50:	8d5d                	or	a0,a0,a5
    80009d52:	008a0593          	addi	a1,s4,8
    80009d56:	2501                	sext.w	a0,a0
    80009d58:	00000097          	auipc	ra,0x0
    80009d5c:	c1e080e7          	jalr	-994(ra) # 80009976 <arp_insert>
    80009d60:	6942                	ld	s2,16(sp)
    80009d62:	69a2                	ld	s3,8(sp)
    80009d64:	bda1                	j	80009bbc <arp_recv+0x92>
    80009d66:	6942                	ld	s2,16(sp)
    80009d68:	bd91                	j	80009bbc <arp_recv+0x92>
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
