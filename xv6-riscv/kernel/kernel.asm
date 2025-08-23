
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000e117          	auipc	sp,0xe
    80000004:	3f010113          	addi	sp,sp,1008 # 8000e3f0 <stack0>
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
    80000050:	0000e797          	auipc	a5,0xe
    80000054:	26078793          	addi	a5,a5,608 # 8000e2b0 <timer_scratch>
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
    80000066:	8be78793          	addi	a5,a5,-1858 # 80006920 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff8de53>
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
    8000019a:	00016517          	auipc	a0,0x16
    8000019e:	25650513          	addi	a0,a0,598 # 800163f0 <cons>
    800001a2:	00001097          	auipc	ra,0x1
    800001a6:	b92080e7          	jalr	-1134(ra) # 80000d34 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001aa:	00016497          	auipc	s1,0x16
    800001ae:	24648493          	addi	s1,s1,582 # 800163f0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b2:	00016917          	auipc	s2,0x16
    800001b6:	2d690913          	addi	s2,s2,726 # 80016488 <cons+0x98>
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
    800001f6:	00016717          	auipc	a4,0x16
    800001fa:	1fa70713          	addi	a4,a4,506 # 800163f0 <cons>
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
    80000244:	00016517          	auipc	a0,0x16
    80000248:	1ac50513          	addi	a0,a0,428 # 800163f0 <cons>
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
    8000026e:	00016717          	auipc	a4,0x16
    80000272:	20f72d23          	sw	a5,538(a4) # 80016488 <cons+0x98>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	a031                	j	80000284 <consoleread+0x106>
    8000027a:	f456                	sd	s5,40(sp)
    8000027c:	bfad                	j	800001f6 <consoleread+0x78>
    8000027e:	7aa2                	ld	s5,40(sp)
    80000280:	a011                	j	80000284 <consoleread+0x106>
    80000282:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000284:	00016517          	auipc	a0,0x16
    80000288:	16c50513          	addi	a0,a0,364 # 800163f0 <cons>
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
    800002ec:	00016517          	auipc	a0,0x16
    800002f0:	10450513          	addi	a0,a0,260 # 800163f0 <cons>
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
    8000031a:	00016517          	auipc	a0,0x16
    8000031e:	0d650513          	addi	a0,a0,214 # 800163f0 <cons>
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
    8000033c:	00016717          	auipc	a4,0x16
    80000340:	0b470713          	addi	a4,a4,180 # 800163f0 <cons>
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
    80000366:	00016717          	auipc	a4,0x16
    8000036a:	08a70713          	addi	a4,a4,138 # 800163f0 <cons>
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
    80000390:	00016717          	auipc	a4,0x16
    80000394:	0f872703          	lw	a4,248(a4) # 80016488 <cons+0x98>
    80000398:	9f99                	subw	a5,a5,a4
    8000039a:	08000713          	li	a4,128
    8000039e:	f6e79ee3          	bne	a5,a4,8000031a <consoleintr+0x3a>
    800003a2:	a865                	j	8000045a <consoleintr+0x17a>
    800003a4:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800003a6:	00016717          	auipc	a4,0x16
    800003aa:	04a70713          	addi	a4,a4,74 # 800163f0 <cons>
    800003ae:	0a072783          	lw	a5,160(a4)
    800003b2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003b6:	00016497          	auipc	s1,0x16
    800003ba:	03a48493          	addi	s1,s1,58 # 800163f0 <cons>
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
    800003fc:	00016717          	auipc	a4,0x16
    80000400:	ff470713          	addi	a4,a4,-12 # 800163f0 <cons>
    80000404:	0a072783          	lw	a5,160(a4)
    80000408:	09c72703          	lw	a4,156(a4)
    8000040c:	f0f707e3          	beq	a4,a5,8000031a <consoleintr+0x3a>
      cons.e--;
    80000410:	37fd                	addiw	a5,a5,-1
    80000412:	00016717          	auipc	a4,0x16
    80000416:	06f72f23          	sw	a5,126(a4) # 80016490 <cons+0xa0>
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
    80000438:	00016797          	auipc	a5,0x16
    8000043c:	fb878793          	addi	a5,a5,-72 # 800163f0 <cons>
    80000440:	0a07a703          	lw	a4,160(a5)
    80000444:	0017069b          	addiw	a3,a4,1
    80000448:	8636                	mv	a2,a3
    8000044a:	0ad7a023          	sw	a3,160(a5)
    8000044e:	07f77713          	andi	a4,a4,127
    80000452:	97ba                	add	a5,a5,a4
    80000454:	4729                	li	a4,10
    80000456:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000045a:	00016797          	auipc	a5,0x16
    8000045e:	02c7a923          	sw	a2,50(a5) # 8001648c <cons+0x9c>
        wakeup(&cons.r);
    80000462:	00016517          	auipc	a0,0x16
    80000466:	02650513          	addi	a0,a0,38 # 80016488 <cons+0x98>
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
    8000047c:	0000a597          	auipc	a1,0xa
    80000480:	b9458593          	addi	a1,a1,-1132 # 8000a010 <etext+0x10>
    80000484:	00016517          	auipc	a0,0x16
    80000488:	f6c50513          	addi	a0,a0,-148 # 800163f0 <cons>
    8000048c:	00001097          	auipc	ra,0x1
    80000490:	80e080e7          	jalr	-2034(ra) # 80000c9a <initlock>

  uartinit();
    80000494:	00000097          	auipc	ra,0x0
    80000498:	350080e7          	jalr	848(ra) # 800007e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000049c:	0006e797          	auipc	a5,0x6e
    800004a0:	2ec78793          	addi	a5,a5,748 # 8006e788 <devsw>
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
    800004da:	0000b817          	auipc	a6,0xb
    800004de:	85680813          	addi	a6,a6,-1962 # 8000ad30 <digits>
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
    8000056a:	00016797          	auipc	a5,0x16
    8000056e:	f407a323          	sw	zero,-186(a5) # 800164b0 <pr+0x18>
  printf("panic: ");
    80000572:	0000a517          	auipc	a0,0xa
    80000576:	aa650513          	addi	a0,a0,-1370 # 8000a018 <etext+0x18>
    8000057a:	00000097          	auipc	ra,0x0
    8000057e:	02e080e7          	jalr	46(ra) # 800005a8 <printf>
  printf(s);
    80000582:	8526                	mv	a0,s1
    80000584:	00000097          	auipc	ra,0x0
    80000588:	024080e7          	jalr	36(ra) # 800005a8 <printf>
  printf("\n");
    8000058c:	0000a517          	auipc	a0,0xa
    80000590:	a9450513          	addi	a0,a0,-1388 # 8000a020 <etext+0x20>
    80000594:	00000097          	auipc	ra,0x0
    80000598:	014080e7          	jalr	20(ra) # 800005a8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059c:	4785                	li	a5,1
    8000059e:	0000e717          	auipc	a4,0xe
    800005a2:	ccf72123          	sw	a5,-830(a4) # 8000e260 <panicked>
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
    800005c8:	00016d97          	auipc	s11,0x16
    800005cc:	ee8dad83          	lw	s11,-280(s11) # 800164b0 <pr+0x18>
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
    8000060a:	0000aa97          	auipc	s5,0xa
    8000060e:	726a8a93          	addi	s5,s5,1830 # 8000ad30 <digits>
    switch(c){
    80000612:	07300c13          	li	s8,115
    80000616:	a0b9                	j	80000664 <printf+0xbc>
    acquire(&pr.lock);
    80000618:	00016517          	auipc	a0,0x16
    8000061c:	e8050513          	addi	a0,a0,-384 # 80016498 <pr>
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
    8000063c:	0000a517          	auipc	a0,0xa
    80000640:	9f450513          	addi	a0,a0,-1548 # 8000a030 <etext+0x30>
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
    8000073a:	0000a497          	auipc	s1,0xa
    8000073e:	8ee48493          	addi	s1,s1,-1810 # 8000a028 <etext+0x28>
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
    800007a0:	00016517          	auipc	a0,0x16
    800007a4:	cf850513          	addi	a0,a0,-776 # 80016498 <pr>
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
    800007ba:	0000a597          	auipc	a1,0xa
    800007be:	88658593          	addi	a1,a1,-1914 # 8000a040 <etext+0x40>
    800007c2:	00016517          	auipc	a0,0x16
    800007c6:	cd650513          	addi	a0,a0,-810 # 80016498 <pr>
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	4d0080e7          	jalr	1232(ra) # 80000c9a <initlock>
  pr.locking = 1;
    800007d2:	4785                	li	a5,1
    800007d4:	00016717          	auipc	a4,0x16
    800007d8:	ccf72e23          	sw	a5,-804(a4) # 800164b0 <pr+0x18>
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
    8000081e:	0000a597          	auipc	a1,0xa
    80000822:	82a58593          	addi	a1,a1,-2006 # 8000a048 <etext+0x48>
    80000826:	00016517          	auipc	a0,0x16
    8000082a:	c9250513          	addi	a0,a0,-878 # 800164b8 <uart_tx_lock>
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
    80000852:	0000e797          	auipc	a5,0xe
    80000856:	a0e7a783          	lw	a5,-1522(a5) # 8000e260 <panicked>
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
    8000088c:	0000e797          	auipc	a5,0xe
    80000890:	9dc7b783          	ld	a5,-1572(a5) # 8000e268 <uart_tx_r>
    80000894:	0000e717          	auipc	a4,0xe
    80000898:	9dc73703          	ld	a4,-1572(a4) # 8000e270 <uart_tx_w>
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
    800008ba:	00016a97          	auipc	s5,0x16
    800008be:	bfea8a93          	addi	s5,s5,-1026 # 800164b8 <uart_tx_lock>
    uart_tx_r += 1;
    800008c2:	0000e497          	auipc	s1,0xe
    800008c6:	9a648493          	addi	s1,s1,-1626 # 8000e268 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008ca:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ce:	0000e997          	auipc	s3,0xe
    800008d2:	9a298993          	addi	s3,s3,-1630 # 8000e270 <uart_tx_w>
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
    8000092e:	00016517          	auipc	a0,0x16
    80000932:	b8a50513          	addi	a0,a0,-1142 # 800164b8 <uart_tx_lock>
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	3fe080e7          	jalr	1022(ra) # 80000d34 <acquire>
  if(panicked){
    8000093e:	0000e797          	auipc	a5,0xe
    80000942:	9227a783          	lw	a5,-1758(a5) # 8000e260 <panicked>
    80000946:	ebc1                	bnez	a5,800009d6 <uartputc+0xba>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000948:	0000e717          	auipc	a4,0xe
    8000094c:	92873703          	ld	a4,-1752(a4) # 8000e270 <uart_tx_w>
    80000950:	0000e797          	auipc	a5,0xe
    80000954:	9187b783          	ld	a5,-1768(a5) # 8000e268 <uart_tx_r>
    80000958:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095c:	00016997          	auipc	s3,0x16
    80000960:	b5c98993          	addi	s3,s3,-1188 # 800164b8 <uart_tx_lock>
    80000964:	0000e497          	auipc	s1,0xe
    80000968:	90448493          	addi	s1,s1,-1788 # 8000e268 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096c:	0000e917          	auipc	s2,0xe
    80000970:	90490913          	addi	s2,s2,-1788 # 8000e270 <uart_tx_w>
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
    80000996:	00016797          	auipc	a5,0x16
    8000099a:	b2278793          	addi	a5,a5,-1246 # 800164b8 <uart_tx_lock>
    8000099e:	97b6                	add	a5,a5,a3
    800009a0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a4:	0705                	addi	a4,a4,1
    800009a6:	0000e797          	auipc	a5,0xe
    800009aa:	8ce7b523          	sd	a4,-1846(a5) # 8000e270 <uart_tx_w>
  uartstart();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	ede080e7          	jalr	-290(ra) # 8000088c <uartstart>
  release(&uart_tx_lock);
    800009b6:	00016517          	auipc	a0,0x16
    800009ba:	b0250513          	addi	a0,a0,-1278 # 800164b8 <uart_tx_lock>
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
    80000a22:	00016517          	auipc	a0,0x16
    80000a26:	a9650513          	addi	a0,a0,-1386 # 800164b8 <uart_tx_lock>
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	30a080e7          	jalr	778(ra) # 80000d34 <acquire>
  uartstart();
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	e5a080e7          	jalr	-422(ra) # 8000088c <uartstart>
  release(&uart_tx_lock);
    80000a3a:	00016517          	auipc	a0,0x16
    80000a3e:	a7e50513          	addi	a0,a0,-1410 # 800164b8 <uart_tx_lock>
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
    80000a60:	00016517          	auipc	a0,0x16
    80000a64:	a9050513          	addi	a0,a0,-1392 # 800164f0 <kmem>
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	2cc080e7          	jalr	716(ra) # 80000d34 <acquire>
  uint page_num = PGROUNDDOWN((uint64)pointer_in_page)/PGSIZE;
  ref_counter[page_num]++;
    80000a70:	01449793          	slli	a5,s1,0x14
    80000a74:	0207d513          	srli	a0,a5,0x20
    80000a78:	050e                	slli	a0,a0,0x3
    80000a7a:	00016797          	auipc	a5,0x16
    80000a7e:	a9678793          	addi	a5,a5,-1386 # 80016510 <ref_counter>
    80000a82:	97aa                	add	a5,a5,a0
    80000a84:	6398                	ld	a4,0(a5)
    80000a86:	0705                	addi	a4,a4,1
    80000a88:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000a8a:	00016517          	auipc	a0,0x16
    80000a8e:	a6650513          	addi	a0,a0,-1434 # 800164f0 <kmem>
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
    80000aae:	00070797          	auipc	a5,0x70
    80000ab2:	efe78793          	addi	a5,a5,-258 # 800709ac <end>
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
    80000ad0:	00016517          	auipc	a0,0x16
    80000ad4:	a2050513          	addi	a0,a0,-1504 # 800164f0 <kmem>
    80000ad8:	00000097          	auipc	ra,0x0
    80000adc:	25c080e7          	jalr	604(ra) # 80000d34 <acquire>
  uint64 page_num = PGROUNDDOWN((uint64)pa)/PGSIZE;
    80000ae0:	00c4d793          	srli	a5,s1,0xc
  if (ref_counter[page_num] > 1) {
    80000ae4:	00379693          	slli	a3,a5,0x3
    80000ae8:	00016717          	auipc	a4,0x16
    80000aec:	a2870713          	addi	a4,a4,-1496 # 80016510 <ref_counter>
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
    80000afe:	00016717          	auipc	a4,0x16
    80000b02:	a1270713          	addi	a4,a4,-1518 # 80016510 <ref_counter>
    80000b06:	97ba                	add	a5,a5,a4
    80000b08:	0007b023          	sd	zero,0(a5)
  release(&kmem.lock);
    80000b0c:	00016917          	auipc	s2,0x16
    80000b10:	9e490913          	addi	s2,s2,-1564 # 800164f0 <kmem>
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
    80000b58:	00009517          	auipc	a0,0x9
    80000b5c:	4f850513          	addi	a0,a0,1272 # 8000a050 <etext+0x50>
    80000b60:	00000097          	auipc	ra,0x0
    80000b64:	9fe080e7          	jalr	-1538(ra) # 8000055e <panic>
    ref_counter[page_num]--;
    80000b68:	078e                	slli	a5,a5,0x3
    80000b6a:	00016697          	auipc	a3,0x16
    80000b6e:	9a668693          	addi	a3,a3,-1626 # 80016510 <ref_counter>
    80000b72:	97b6                	add	a5,a5,a3
    80000b74:	177d                	addi	a4,a4,-1
    80000b76:	e398                	sd	a4,0(a5)
    release(&kmem.lock);
    80000b78:	00016517          	auipc	a0,0x16
    80000b7c:	97850513          	addi	a0,a0,-1672 # 800164f0 <kmem>
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
    80000bde:	00009597          	auipc	a1,0x9
    80000be2:	47a58593          	addi	a1,a1,1146 # 8000a058 <etext+0x58>
    80000be6:	00016517          	auipc	a0,0x16
    80000bea:	90a50513          	addi	a0,a0,-1782 # 800164f0 <kmem>
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	0ac080e7          	jalr	172(ra) # 80000c9a <initlock>
  freerange(end, (void*)PHYSTOP);
    80000bf6:	45c5                	li	a1,17
    80000bf8:	05ee                	slli	a1,a1,0x1b
    80000bfa:	00070517          	auipc	a0,0x70
    80000bfe:	db250513          	addi	a0,a0,-590 # 800709ac <end>
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
    80000c1c:	00016517          	auipc	a0,0x16
    80000c20:	8d450513          	addi	a0,a0,-1836 # 800164f0 <kmem>
    80000c24:	00000097          	auipc	ra,0x0
    80000c28:	110080e7          	jalr	272(ra) # 80000d34 <acquire>

  r = kmem.freelist;
    80000c2c:	00016497          	auipc	s1,0x16
    80000c30:	8dc4b483          	ld	s1,-1828(s1) # 80016508 <kmem+0x18>
  if(r)
    80000c34:	c4a9                	beqz	s1,80000c7e <kalloc+0x6c>
    kmem.freelist = r->next;
    80000c36:	609c                	ld	a5,0(s1)
    80000c38:	00016717          	auipc	a4,0x16
    80000c3c:	8cf73823          	sd	a5,-1840(a4) # 80016508 <kmem+0x18>
  uint64 page_num = PGROUNDDOWN((uint64)r)/PGSIZE;
    80000c40:	00c4d713          	srli	a4,s1,0xc
  ref_counter[page_num] = 1;
    80000c44:	070e                	slli	a4,a4,0x3
    80000c46:	00016797          	auipc	a5,0x16
    80000c4a:	8ca78793          	addi	a5,a5,-1846 # 80016510 <ref_counter>
    80000c4e:	97ba                	add	a5,a5,a4
    80000c50:	4705                	li	a4,1
    80000c52:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000c54:	00016517          	auipc	a0,0x16
    80000c58:	89c50513          	addi	a0,a0,-1892 # 800164f0 <kmem>
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
    80000c80:	00016717          	auipc	a4,0x16
    80000c84:	88f73823          	sd	a5,-1904(a4) # 80016510 <ref_counter>
  release(&kmem.lock);
    80000c88:	00016517          	auipc	a0,0x16
    80000c8c:	86850513          	addi	a0,a0,-1944 # 800164f0 <kmem>
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
    80000d78:	00009517          	auipc	a0,0x9
    80000d7c:	2e850513          	addi	a0,a0,744 # 8000a060 <etext+0x60>
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
    80000dc4:	00009517          	auipc	a0,0x9
    80000dc8:	2a450513          	addi	a0,a0,676 # 8000a068 <etext+0x68>
    80000dcc:	fffff097          	auipc	ra,0xfffff
    80000dd0:	792080e7          	jalr	1938(ra) # 8000055e <panic>
    panic("pop_off");
    80000dd4:	00009517          	auipc	a0,0x9
    80000dd8:	2ac50513          	addi	a0,a0,684 # 8000a080 <etext+0x80>
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
    80000e1c:	00009517          	auipc	a0,0x9
    80000e20:	26c50513          	addi	a0,a0,620 # 8000a088 <etext+0x88>
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
    socket_init();
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ff6:	0000d717          	auipc	a4,0xd
    80000ffa:	28270713          	addi	a4,a4,642 # 8000e278 <started>
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
    80001014:	00009517          	auipc	a0,0x9
    80001018:	09450513          	addi	a0,a0,148 # 8000a0a8 <etext+0xa8>
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
    80001038:	932080e7          	jalr	-1742(ra) # 80006966 <plicinithart>
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
    80001054:	00009517          	auipc	a0,0x9
    80001058:	fcc50513          	addi	a0,a0,-52 # 8000a020 <etext+0x20>
    8000105c:	fffff097          	auipc	ra,0xfffff
    80001060:	54c080e7          	jalr	1356(ra) # 800005a8 <printf>
    printf("xv6 kernel is booting\n");
    80001064:	00009517          	auipc	a0,0x9
    80001068:	02c50513          	addi	a0,a0,44 # 8000a090 <etext+0x90>
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	53c080e7          	jalr	1340(ra) # 800005a8 <printf>
    printf("\n");
    80001074:	00009517          	auipc	a0,0x9
    80001078:	fac50513          	addi	a0,a0,-84 # 8000a020 <etext+0x20>
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
    800010b8:	896080e7          	jalr	-1898(ra) # 8000694a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800010bc:	00006097          	auipc	ra,0x6
    800010c0:	8aa080e7          	jalr	-1878(ra) # 80006966 <plicinithart>
    binit();         // buffer cache
    800010c4:	00003097          	auipc	ra,0x3
    800010c8:	922080e7          	jalr	-1758(ra) # 800039e6 <binit>
    iinit();         // inode table
    800010cc:	00003097          	auipc	ra,0x3
    800010d0:	fa2080e7          	jalr	-94(ra) # 8000406e <iinit>
    fileinit();      // file table
    800010d4:	00004097          	auipc	ra,0x4
    800010d8:	f8c080e7          	jalr	-116(ra) # 80005060 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010dc:	00006097          	auipc	ra,0x6
    800010e0:	992080e7          	jalr	-1646(ra) # 80006a6e <virtio_disk_init>
    virtio_net_init(); // emulated NIC driver 
    800010e4:	00006097          	auipc	ra,0x6
    800010e8:	f06080e7          	jalr	-250(ra) # 80006fea <virtio_net_init>
    net_init();
    800010ec:	00007097          	auipc	ra,0x7
    800010f0:	024080e7          	jalr	36(ra) # 80008110 <net_init>
    socket_init();
    800010f4:	00007097          	auipc	ra,0x7
    800010f8:	e18080e7          	jalr	-488(ra) # 80007f0c <socket_init>
    userinit();      // first user process
    800010fc:	00001097          	auipc	ra,0x1
    80001100:	06e080e7          	jalr	110(ra) # 8000216a <userinit>
    __sync_synchronize();
    80001104:	0330000f          	fence	rw,rw
    started = 1;
    80001108:	4785                	li	a5,1
    8000110a:	0000d717          	auipc	a4,0xd
    8000110e:	16f72723          	sw	a5,366(a4) # 8000e278 <started>
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
    80001120:	0000d797          	auipc	a5,0xd
    80001124:	1607b783          	ld	a5,352(a5) # 8000e280 <kernel_pagetable>
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
    800011a6:	00009517          	auipc	a0,0x9
    800011aa:	f1a50513          	addi	a0,a0,-230 # 8000a0c0 <etext+0xc0>
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
    8000128a:	00009517          	auipc	a0,0x9
    8000128e:	e3e50513          	addi	a0,a0,-450 # 8000a0c8 <etext+0xc8>
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	2cc080e7          	jalr	716(ra) # 8000055e <panic>
      panic("mappages: remap");
    8000129a:	00009517          	auipc	a0,0x9
    8000129e:	e3e50513          	addi	a0,a0,-450 # 8000a0d8 <etext+0xd8>
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
    800012e6:	00009517          	auipc	a0,0x9
    800012ea:	e0250513          	addi	a0,a0,-510 # 8000a0e8 <etext+0xe8>
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
    8000136a:	80009697          	auipc	a3,0x80009
    8000136e:	c9668693          	addi	a3,a3,-874 # a000 <_entry-0x7fff6000>
    80001372:	4605                	li	a2,1
    80001374:	067e                	slli	a2,a2,0x1f
    80001376:	85b2                	mv	a1,a2
    80001378:	8526                	mv	a0,s1
    8000137a:	00000097          	auipc	ra,0x0
    8000137e:	f4c080e7          	jalr	-180(ra) # 800012c6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001382:	4719                	li	a4,6
    80001384:	00009697          	auipc	a3,0x9
    80001388:	c7c68693          	addi	a3,a3,-900 # 8000a000 <etext>
    8000138c:	47c5                	li	a5,17
    8000138e:	07ee                	slli	a5,a5,0x1b
    80001390:	40d786b3          	sub	a3,a5,a3
    80001394:	00009617          	auipc	a2,0x9
    80001398:	c6c60613          	addi	a2,a2,-916 # 8000a000 <etext>
    8000139c:	85b2                	mv	a1,a2
    8000139e:	8526                	mv	a0,s1
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	f26080e7          	jalr	-218(ra) # 800012c6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800013a8:	4729                	li	a4,10
    800013aa:	6685                	lui	a3,0x1
    800013ac:	00008617          	auipc	a2,0x8
    800013b0:	c5460613          	addi	a2,a2,-940 # 80009000 <_trampoline>
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
    800013ec:	0000d797          	auipc	a5,0xd
    800013f0:	e8a7ba23          	sd	a0,-364(a5) # 8000e280 <kernel_pagetable>
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
    8000143c:	00009517          	auipc	a0,0x9
    80001440:	cb450513          	addi	a0,a0,-844 # 8000a0f0 <etext+0xf0>
    80001444:	fffff097          	auipc	ra,0xfffff
    80001448:	11a080e7          	jalr	282(ra) # 8000055e <panic>
      panic("uvmunmap: walk");
    8000144c:	00009517          	auipc	a0,0x9
    80001450:	cbc50513          	addi	a0,a0,-836 # 8000a108 <etext+0x108>
    80001454:	fffff097          	auipc	ra,0xfffff
    80001458:	10a080e7          	jalr	266(ra) # 8000055e <panic>
      panic("uvmunmap: not mapped");
    8000145c:	00009517          	auipc	a0,0x9
    80001460:	cbc50513          	addi	a0,a0,-836 # 8000a118 <etext+0x118>
    80001464:	fffff097          	auipc	ra,0xfffff
    80001468:	0fa080e7          	jalr	250(ra) # 8000055e <panic>
      panic("uvmunmap: not a leaf");
    8000146c:	00009517          	auipc	a0,0x9
    80001470:	cc450513          	addi	a0,a0,-828 # 8000a130 <etext+0x130>
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
    80001560:	00009517          	auipc	a0,0x9
    80001564:	be850513          	addi	a0,a0,-1048 # 8000a148 <etext+0x148>
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
    800018b4:	00009517          	auipc	a0,0x9
    800018b8:	8b450513          	addi	a0,a0,-1868 # 8000a168 <etext+0x168>
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
    800019b4:	00008517          	auipc	a0,0x8
    800019b8:	7c450513          	addi	a0,a0,1988 # 8000a178 <etext+0x178>
    800019bc:	fffff097          	auipc	ra,0xfffff
    800019c0:	ba2080e7          	jalr	-1118(ra) # 8000055e <panic>
      panic("uvmcopy: page not present");
    800019c4:	00008517          	auipc	a0,0x8
    800019c8:	7d450513          	addi	a0,a0,2004 # 8000a198 <etext+0x198>
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
    80001a30:	00008517          	auipc	a0,0x8
    80001a34:	78850513          	addi	a0,a0,1928 # 8000a1b8 <etext+0x1b8>
    80001a38:	fffff097          	auipc	ra,0xfffff
    80001a3c:	b26080e7          	jalr	-1242(ra) # 8000055e <panic>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001a40:	00008517          	auipc	a0,0x8
    80001a44:	79850513          	addi	a0,a0,1944 # 8000a1d8 <etext+0x1d8>
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
    80001afa:	00008517          	auipc	a0,0x8
    80001afe:	6fe50513          	addi	a0,a0,1790 # 8000a1f8 <etext+0x1f8>
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
    80001cb6:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff8e654>
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
    80001cfe:	00055497          	auipc	s1,0x55
    80001d02:	c4248493          	addi	s1,s1,-958 # 80056940 <proc>
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
    80001d28:	00063a97          	auipc	s5,0x63
    80001d2c:	818a8a93          	addi	s5,s5,-2024 # 80064540 <tickslock>
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
    80001d7e:	00008517          	auipc	a0,0x8
    80001d82:	48a50513          	addi	a0,a0,1162 # 8000a208 <etext+0x208>
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
    80001da2:	00008597          	auipc	a1,0x8
    80001da6:	46e58593          	addi	a1,a1,1134 # 8000a210 <etext+0x210>
    80001daa:	00054517          	auipc	a0,0x54
    80001dae:	76650513          	addi	a0,a0,1894 # 80056510 <pid_lock>
    80001db2:	fffff097          	auipc	ra,0xfffff
    80001db6:	ee8080e7          	jalr	-280(ra) # 80000c9a <initlock>
  initlock(&wait_lock, "wait_lock");
    80001dba:	00008597          	auipc	a1,0x8
    80001dbe:	45e58593          	addi	a1,a1,1118 # 8000a218 <etext+0x218>
    80001dc2:	00054517          	auipc	a0,0x54
    80001dc6:	76650513          	addi	a0,a0,1894 # 80056528 <wait_lock>
    80001dca:	fffff097          	auipc	ra,0xfffff
    80001dce:	ed0080e7          	jalr	-304(ra) # 80000c9a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001dd2:	00055497          	auipc	s1,0x55
    80001dd6:	b6e48493          	addi	s1,s1,-1170 # 80056940 <proc>
      initlock(&p->lock, "proc");
    80001dda:	00008b17          	auipc	s6,0x8
    80001dde:	44eb0b13          	addi	s6,s6,1102 # 8000a228 <etext+0x228>
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
    80001e00:	00062a17          	auipc	s4,0x62
    80001e04:	740a0a13          	addi	s4,s4,1856 # 80064540 <tickslock>
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
    80001e6c:	00054517          	auipc	a0,0x54
    80001e70:	6d450513          	addi	a0,a0,1748 # 80056540 <cpus>
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
    80001e96:	00054717          	auipc	a4,0x54
    80001e9a:	67a70713          	addi	a4,a4,1658 # 80056510 <pid_lock>
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
    80001ed0:	0000c797          	auipc	a5,0xc
    80001ed4:	3407a783          	lw	a5,832(a5) # 8000e210 <first.1>
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
    80001eea:	0000c797          	auipc	a5,0xc
    80001eee:	3207a323          	sw	zero,806(a5) # 8000e210 <first.1>
    fsinit(ROOTDEV);
    80001ef2:	4505                	li	a0,1
    80001ef4:	00002097          	auipc	ra,0x2
    80001ef8:	0fc080e7          	jalr	252(ra) # 80003ff0 <fsinit>
    80001efc:	bff9                	j	80001eda <forkret+0x22>

0000000080001efe <allocpid>:
{
    80001efe:	1101                	addi	sp,sp,-32
    80001f00:	ec06                	sd	ra,24(sp)
    80001f02:	e822                	sd	s0,16(sp)
    80001f04:	e426                	sd	s1,8(sp)
    80001f06:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001f08:	00054517          	auipc	a0,0x54
    80001f0c:	60850513          	addi	a0,a0,1544 # 80056510 <pid_lock>
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	e24080e7          	jalr	-476(ra) # 80000d34 <acquire>
  pid = nextpid;
    80001f18:	0000c797          	auipc	a5,0xc
    80001f1c:	2fc78793          	addi	a5,a5,764 # 8000e214 <nextpid>
    80001f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001f22:	0014871b          	addiw	a4,s1,1
    80001f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001f28:	00054517          	auipc	a0,0x54
    80001f2c:	5e850513          	addi	a0,a0,1512 # 80056510 <pid_lock>
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
    80001f60:	00007697          	auipc	a3,0x7
    80001f64:	0a068693          	addi	a3,a3,160 # 80009000 <_trampoline>
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
    80002096:	00055497          	auipc	s1,0x55
    8000209a:	8aa48493          	addi	s1,s1,-1878 # 80056940 <proc>
    8000209e:	00062917          	auipc	s2,0x62
    800020a2:	4a290913          	addi	s2,s2,1186 # 80064540 <tickslock>
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
    8000217e:	0000c797          	auipc	a5,0xc
    80002182:	10a7b523          	sd	a0,266(a5) # 8000e288 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002186:	03400613          	li	a2,52
    8000218a:	0000c597          	auipc	a1,0xc
    8000218e:	09658593          	addi	a1,a1,150 # 8000e220 <initcode>
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
    800021ac:	00008597          	auipc	a1,0x8
    800021b0:	08458593          	addi	a1,a1,132 # 8000a230 <etext+0x230>
    800021b4:	15848513          	addi	a0,s1,344
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	dcc080e7          	jalr	-564(ra) # 80000f84 <safestrcpy>
  p->cwd = namei("/");
    800021c0:	00008517          	auipc	a0,0x8
    800021c4:	08050513          	addi	a0,a0,128 # 8000a240 <etext+0x240>
    800021c8:	00003097          	auipc	ra,0x3
    800021cc:	894080e7          	jalr	-1900(ra) # 80004a5c <namei>
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
    80002334:	dc2080e7          	jalr	-574(ra) # 800050f2 <filedup>
    80002338:	00a93023          	sd	a0,0(s2)
    8000233c:	b7e5                	j	80002324 <fork+0xa2>
  np->cwd = idup(p->cwd);
    8000233e:	150ab503          	ld	a0,336(s5)
    80002342:	00002097          	auipc	ra,0x2
    80002346:	ef2080e7          	jalr	-270(ra) # 80004234 <idup>
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
    8000236e:	00054517          	auipc	a0,0x54
    80002372:	1ba50513          	addi	a0,a0,442 # 80056528 <wait_lock>
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	9be080e7          	jalr	-1602(ra) # 80000d34 <acquire>
  np->parent = p;
    8000237e:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002382:	00054517          	auipc	a0,0x54
    80002386:	1a650513          	addi	a0,a0,422 # 80056528 <wait_lock>
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
    80002498:	00008517          	auipc	a0,0x8
    8000249c:	db050513          	addi	a0,a0,-592 # 8000a248 <etext+0x248>
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
    800024d4:	c22080e7          	jalr	-990(ra) # 800050f2 <filedup>
    800024d8:	00a93023          	sd	a0,0(s2)
    800024dc:	b7e5                	j	800024c4 <create_thread+0xfc>
  np->cwd = idup(p->cwd);
    800024de:	150ab503          	ld	a0,336(s5)
    800024e2:	00002097          	auipc	ra,0x2
    800024e6:	d52080e7          	jalr	-686(ra) # 80004234 <idup>
    800024ea:	14aa3823          	sd	a0,336(s4)
  release(&np->lock);
    800024ee:	8552                	mv	a0,s4
    800024f0:	fffff097          	auipc	ra,0xfffff
    800024f4:	8f4080e7          	jalr	-1804(ra) # 80000de4 <release>
  acquire(&wait_lock);
    800024f8:	00054517          	auipc	a0,0x54
    800024fc:	03050513          	addi	a0,a0,48 # 80056528 <wait_lock>
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
    80002520:	00054517          	auipc	a0,0x54
    80002524:	00850513          	addi	a0,a0,8 # 80056528 <wait_lock>
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
    8000259c:	00054717          	auipc	a4,0x54
    800025a0:	f7470713          	addi	a4,a4,-140 # 80056510 <pid_lock>
    800025a4:	9756                	add	a4,a4,s5
    800025a6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800025aa:	00054717          	auipc	a4,0x54
    800025ae:	f9e70713          	addi	a4,a4,-98 # 80056548 <cpus+0x8>
    800025b2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800025b4:	498d                	li	s3,3
        p->state = RUNNING;
    800025b6:	4b11                	li	s6,4
        c->proc = p;
    800025b8:	079e                	slli	a5,a5,0x7
    800025ba:	00054a17          	auipc	s4,0x54
    800025be:	f56a0a13          	addi	s4,s4,-170 # 80056510 <pid_lock>
    800025c2:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025c8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025cc:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800025d0:	00054497          	auipc	s1,0x54
    800025d4:	37048493          	addi	s1,s1,880 # 80056940 <proc>
    800025d8:	00062917          	auipc	s2,0x62
    800025dc:	f6890913          	addi	s2,s2,-152 # 80064540 <tickslock>
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
    80002648:	00054717          	auipc	a4,0x54
    8000264c:	ec870713          	addi	a4,a4,-312 # 80056510 <pid_lock>
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
    8000266e:	00054917          	auipc	s2,0x54
    80002672:	ea290913          	addi	s2,s2,-350 # 80056510 <pid_lock>
    80002676:	2781                	sext.w	a5,a5
    80002678:	079e                	slli	a5,a5,0x7
    8000267a:	97ca                	add	a5,a5,s2
    8000267c:	0ac7a983          	lw	s3,172(a5)
    80002680:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002682:	2781                	sext.w	a5,a5
    80002684:	079e                	slli	a5,a5,0x7
    80002686:	07a1                	addi	a5,a5,8
    80002688:	00054597          	auipc	a1,0x54
    8000268c:	eb858593          	addi	a1,a1,-328 # 80056540 <cpus>
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
    800026b8:	00008517          	auipc	a0,0x8
    800026bc:	ba850513          	addi	a0,a0,-1112 # 8000a260 <etext+0x260>
    800026c0:	ffffe097          	auipc	ra,0xffffe
    800026c4:	e9e080e7          	jalr	-354(ra) # 8000055e <panic>
    panic("sched locks");
    800026c8:	00008517          	auipc	a0,0x8
    800026cc:	ba850513          	addi	a0,a0,-1112 # 8000a270 <etext+0x270>
    800026d0:	ffffe097          	auipc	ra,0xffffe
    800026d4:	e8e080e7          	jalr	-370(ra) # 8000055e <panic>
    panic("sched running");
    800026d8:	00008517          	auipc	a0,0x8
    800026dc:	ba850513          	addi	a0,a0,-1112 # 8000a280 <etext+0x280>
    800026e0:	ffffe097          	auipc	ra,0xffffe
    800026e4:	e7e080e7          	jalr	-386(ra) # 8000055e <panic>
    panic("sched interruptible");
    800026e8:	00008517          	auipc	a0,0x8
    800026ec:	ba850513          	addi	a0,a0,-1112 # 8000a290 <etext+0x290>
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
    800027ac:	00054497          	auipc	s1,0x54
    800027b0:	19448493          	addi	s1,s1,404 # 80056940 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800027b4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800027b6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800027b8:	00062917          	auipc	s2,0x62
    800027bc:	d8890913          	addi	s2,s2,-632 # 80064540 <tickslock>
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
    80002820:	00054497          	auipc	s1,0x54
    80002824:	12048493          	addi	s1,s1,288 # 80056940 <proc>
      pp->parent = initproc;
    80002828:	0000ca17          	auipc	s4,0xc
    8000282c:	a60a0a13          	addi	s4,s4,-1440 # 8000e288 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002830:	00062997          	auipc	s3,0x62
    80002834:	d1098993          	addi	s3,s3,-752 # 80064540 <tickslock>
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
    80002884:	0000c797          	auipc	a5,0xc
    80002888:	a047b783          	ld	a5,-1532(a5) # 8000e288 <initproc>
    8000288c:	0d050493          	addi	s1,a0,208
    80002890:	15050913          	addi	s2,a0,336
    80002894:	00a79d63          	bne	a5,a0,800028ae <thread_exit+0x46>
    panic("init exiting");
    80002898:	00008517          	auipc	a0,0x8
    8000289c:	a1050513          	addi	a0,a0,-1520 # 8000a2a8 <etext+0x2a8>
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
    800028b6:	892080e7          	jalr	-1902(ra) # 80005144 <fileclose>
      p->ofile[fd] = 0;
    800028ba:	0004b023          	sd	zero,0(s1)
    800028be:	b7ed                	j	800028a8 <thread_exit+0x40>
  begin_op();
    800028c0:	00002097          	auipc	ra,0x2
    800028c4:	3a2080e7          	jalr	930(ra) # 80004c62 <begin_op>
  iput(p->cwd);
    800028c8:	1509b503          	ld	a0,336(s3)
    800028cc:	00002097          	auipc	ra,0x2
    800028d0:	b64080e7          	jalr	-1180(ra) # 80004430 <iput>
  end_op();
    800028d4:	00002097          	auipc	ra,0x2
    800028d8:	40e080e7          	jalr	1038(ra) # 80004ce2 <end_op>
  p->cwd = 0;
    800028dc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800028e0:	00054517          	auipc	a0,0x54
    800028e4:	c4850513          	addi	a0,a0,-952 # 80056528 <wait_lock>
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
    8000291a:	00054517          	auipc	a0,0x54
    8000291e:	c0e50513          	addi	a0,a0,-1010 # 80056528 <wait_lock>
    80002922:	ffffe097          	auipc	ra,0xffffe
    80002926:	4c2080e7          	jalr	1218(ra) # 80000de4 <release>
  sched();
    8000292a:	00000097          	auipc	ra,0x0
    8000292e:	cf6080e7          	jalr	-778(ra) # 80002620 <sched>
  panic("zombie exit");
    80002932:	00008517          	auipc	a0,0x8
    80002936:	98650513          	addi	a0,a0,-1658 # 8000a2b8 <etext+0x2b8>
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
    8000297a:	00054a97          	auipc	s5,0x54
    8000297e:	baea8a93          	addi	s5,s5,-1106 # 80056528 <wait_lock>
      infant->state = ZOMBIE;
    80002982:	4c95                	li	s9,5
    80002984:	a885                	j	800029f4 <exit+0xb2>
          fileclose(f);
    80002986:	00002097          	auipc	ra,0x2
    8000298a:	7be080e7          	jalr	1982(ra) # 80005144 <fileclose>
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
    800029a2:	2c4080e7          	jalr	708(ra) # 80004c62 <begin_op>
      iput(infant->cwd);
    800029a6:	1509b503          	ld	a0,336(s3)
    800029aa:	00002097          	auipc	ra,0x2
    800029ae:	a86080e7          	jalr	-1402(ra) # 80004430 <iput>
      end_op();
    800029b2:	00002097          	auipc	ra,0x2
    800029b6:	330080e7          	jalr	816(ra) # 80004ce2 <end_op>
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
    80002a06:	0000c797          	auipc	a5,0xc
    80002a0a:	8827b783          	ld	a5,-1918(a5) # 8000e288 <initproc>
    80002a0e:	0d0c0493          	addi	s1,s8,208
    80002a12:	150c0913          	addi	s2,s8,336
    80002a16:	01879d63          	bne	a5,s8,80002a30 <exit+0xee>
    panic("init exiting");
    80002a1a:	00008517          	auipc	a0,0x8
    80002a1e:	88e50513          	addi	a0,a0,-1906 # 8000a2a8 <etext+0x2a8>
    80002a22:	ffffe097          	auipc	ra,0xffffe
    80002a26:	b3c080e7          	jalr	-1220(ra) # 8000055e <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002a2a:	04a1                	addi	s1,s1,8
    80002a2c:	01248b63          	beq	s1,s2,80002a42 <exit+0x100>
    if(p->ofile[fd]){
    80002a30:	6088                	ld	a0,0(s1)
    80002a32:	dd65                	beqz	a0,80002a2a <exit+0xe8>
      fileclose(f);
    80002a34:	00002097          	auipc	ra,0x2
    80002a38:	710080e7          	jalr	1808(ra) # 80005144 <fileclose>
      p->ofile[fd] = 0;
    80002a3c:	0004b023          	sd	zero,0(s1)
    80002a40:	b7ed                	j	80002a2a <exit+0xe8>
  begin_op();
    80002a42:	00002097          	auipc	ra,0x2
    80002a46:	220080e7          	jalr	544(ra) # 80004c62 <begin_op>
  iput(p->cwd);
    80002a4a:	150c3503          	ld	a0,336(s8)
    80002a4e:	00002097          	auipc	ra,0x2
    80002a52:	9e2080e7          	jalr	-1566(ra) # 80004430 <iput>
  end_op();
    80002a56:	00002097          	auipc	ra,0x2
    80002a5a:	28c080e7          	jalr	652(ra) # 80004ce2 <end_op>
  p->cwd = 0;
    80002a5e:	140c3823          	sd	zero,336(s8)
  acquire(&wait_lock);
    80002a62:	00054517          	auipc	a0,0x54
    80002a66:	ac650513          	addi	a0,a0,-1338 # 80056528 <wait_lock>
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
    80002a9c:	00054517          	auipc	a0,0x54
    80002aa0:	a8c50513          	addi	a0,a0,-1396 # 80056528 <wait_lock>
    80002aa4:	ffffe097          	auipc	ra,0xffffe
    80002aa8:	340080e7          	jalr	832(ra) # 80000de4 <release>
  sched();
    80002aac:	00000097          	auipc	ra,0x0
    80002ab0:	b74080e7          	jalr	-1164(ra) # 80002620 <sched>
  panic("zombie exit");
    80002ab4:	00008517          	auipc	a0,0x8
    80002ab8:	80450513          	addi	a0,a0,-2044 # 8000a2b8 <etext+0x2b8>
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
    80002ad4:	00054497          	auipc	s1,0x54
    80002ad8:	e6c48493          	addi	s1,s1,-404 # 80056940 <proc>
    80002adc:	00062997          	auipc	s3,0x62
    80002ae0:	a6498993          	addi	s3,s3,-1436 # 80064540 <tickslock>
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
    80002bbe:	00054517          	auipc	a0,0x54
    80002bc2:	96a50513          	addi	a0,a0,-1686 # 80056528 <wait_lock>
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
    80002bf2:	00054b17          	auipc	s6,0x54
    80002bf6:	936b0b13          	addi	s6,s6,-1738 # 80056528 <wait_lock>
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
    80002c54:	00054517          	auipc	a0,0x54
    80002c58:	8d450513          	addi	a0,a0,-1836 # 80056528 <wait_lock>
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
    80002c82:	00054517          	auipc	a0,0x54
    80002c86:	8a650513          	addi	a0,a0,-1882 # 80056528 <wait_lock>
    80002c8a:	ffffe097          	auipc	ra,0xffffe
    80002c8e:	15a080e7          	jalr	346(ra) # 80000de4 <release>
        return -1;
    80002c92:	557d                	li	a0,-1
    80002c94:	6ae2                	ld	s5,24(sp)
    80002c96:	6b42                	ld	s6,16(sp)
    80002c98:	a821                	j	80002cb0 <join_thread+0x11c>
      release(&wait_lock);
    80002c9a:	00054517          	auipc	a0,0x54
    80002c9e:	88e50513          	addi	a0,a0,-1906 # 80056528 <wait_lock>
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
    80002cc2:	00054517          	auipc	a0,0x54
    80002cc6:	86650513          	addi	a0,a0,-1946 # 80056528 <wait_lock>
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
    80002cf8:	00054517          	auipc	a0,0x54
    80002cfc:	83050513          	addi	a0,a0,-2000 # 80056528 <wait_lock>
    80002d00:	ffffe097          	auipc	ra,0xffffe
    80002d04:	034080e7          	jalr	52(ra) # 80000d34 <acquire>
        if(pp->state == ZOMBIE){
    80002d08:	4a15                	li	s4,5
        havekids = 1;
    80002d0a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002d0c:	00062997          	auipc	s3,0x62
    80002d10:	83498993          	addi	s3,s3,-1996 # 80064540 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002d14:	00054b17          	auipc	s6,0x54
    80002d18:	814b0b13          	addi	s6,s6,-2028 # 80056528 <wait_lock>
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
    80002d52:	00053517          	auipc	a0,0x53
    80002d56:	7d650513          	addi	a0,a0,2006 # 80056528 <wait_lock>
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
    80002d84:	00053517          	auipc	a0,0x53
    80002d88:	7a450513          	addi	a0,a0,1956 # 80056528 <wait_lock>
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
    80002de0:	00054497          	auipc	s1,0x54
    80002de4:	b6048493          	addi	s1,s1,-1184 # 80056940 <proc>
    80002de8:	bf65                	j	80002da0 <wait+0xca>
      release(&wait_lock);
    80002dea:	00053517          	auipc	a0,0x53
    80002dee:	73e50513          	addi	a0,a0,1854 # 80056528 <wait_lock>
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
    80002ec0:	00007517          	auipc	a0,0x7
    80002ec4:	16050513          	addi	a0,a0,352 # 8000a020 <etext+0x20>
    80002ec8:	ffffd097          	auipc	ra,0xffffd
    80002ecc:	6e0080e7          	jalr	1760(ra) # 800005a8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002ed0:	00054497          	auipc	s1,0x54
    80002ed4:	bc848493          	addi	s1,s1,-1080 # 80056a98 <proc+0x158>
    80002ed8:	00061917          	auipc	s2,0x61
    80002edc:	7c090913          	addi	s2,s2,1984 # 80064698 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ee0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002ee2:	00007997          	auipc	s3,0x7
    80002ee6:	3e698993          	addi	s3,s3,998 # 8000a2c8 <etext+0x2c8>
    printf("%d %s %s", p->pid, state, p->name);
    80002eea:	00007a97          	auipc	s5,0x7
    80002eee:	3e6a8a93          	addi	s5,s5,998 # 8000a2d0 <etext+0x2d0>
    printf("\n");
    80002ef2:	00007a17          	auipc	s4,0x7
    80002ef6:	12ea0a13          	addi	s4,s4,302 # 8000a020 <etext+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002efa:	00008b97          	auipc	s7,0x8
    80002efe:	e4eb8b93          	addi	s7,s7,-434 # 8000ad48 <states.0>
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
    80002f64:	00007517          	auipc	a0,0x7
    80002f68:	37c50513          	addi	a0,a0,892 # 8000a2e0 <etext+0x2e0>
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
    80002ff0:	00007597          	auipc	a1,0x7
    80002ff4:	34858593          	addi	a1,a1,840 # 8000a338 <etext+0x338>
    80002ff8:	00061517          	auipc	a0,0x61
    80002ffc:	54850513          	addi	a0,a0,1352 # 80064540 <tickslock>
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
    8000301c:	87878793          	addi	a5,a5,-1928 # 80006890 <kernelvec>
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
    80003046:	00006697          	auipc	a3,0x6
    8000304a:	fba68693          	addi	a3,a3,-70 # 80009000 <_trampoline>
    8000304e:	00006717          	auipc	a4,0x6
    80003052:	fb270713          	addi	a4,a4,-78 # 80009000 <_trampoline>
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
    8000307e:	15060613          	addi	a2,a2,336 # 800031ca <usertrap>
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
    800030a6:	00006717          	auipc	a4,0x6
    800030aa:	ff670713          	addi	a4,a4,-10 # 8000909c <userret>
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
    800030ca:	00061517          	auipc	a0,0x61
    800030ce:	47650513          	addi	a0,a0,1142 # 80064540 <tickslock>
    800030d2:	ffffe097          	auipc	ra,0xffffe
    800030d6:	c62080e7          	jalr	-926(ra) # 80000d34 <acquire>
  ticks++;
    800030da:	0000b717          	auipc	a4,0xb
    800030de:	1b670713          	addi	a4,a4,438 # 8000e290 <ticks>
    800030e2:	431c                	lw	a5,0(a4)
    800030e4:	2785                	addiw	a5,a5,1
    800030e6:	c31c                	sw	a5,0(a4)
  wakeup(&ticks);
    800030e8:	853a                	mv	a0,a4
    800030ea:	fffff097          	auipc	ra,0xfffff
    800030ee:	6ae080e7          	jalr	1710(ra) # 80002798 <wakeup>
  release(&tickslock);
    800030f2:	00061517          	auipc	a0,0x61
    800030f6:	44e50513          	addi	a0,a0,1102 # 80064540 <tickslock>
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
    80003110:	0a07dc63          	bgez	a5,800031c8 <devintr+0xbe>
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
    8000312e:	06e78c63          	beq	a5,a4,800031a6 <devintr+0x9c>
  }
}
    80003132:	60e2                	ld	ra,24(sp)
    80003134:	6442                	ld	s0,16(sp)
    80003136:	6105                	addi	sp,sp,32
    80003138:	8082                	ret
    8000313a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000313c:	00004097          	auipc	ra,0x4
    80003140:	862080e7          	jalr	-1950(ra) # 8000699e <plic_claim>
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
    8000315c:	eb1d                	bnez	a4,80003192 <devintr+0x88>
    8000315e:	64a2                	ld	s1,8(sp)
    80003160:	bfc9                	j	80003132 <devintr+0x28>
      uartintr();
    80003162:	ffffe097          	auipc	ra,0xffffe
    80003166:	89e080e7          	jalr	-1890(ra) # 80000a00 <uartintr>
      plic_complete(irq);
    8000316a:	8526                	mv	a0,s1
    8000316c:	00004097          	auipc	ra,0x4
    80003170:	856080e7          	jalr	-1962(ra) # 800069c2 <plic_complete>
    return 1;
    80003174:	4505                	li	a0,1
    80003176:	64a2                	ld	s1,8(sp)
    80003178:	bf6d                	j	80003132 <devintr+0x28>
      virtio_disk_intr();
    8000317a:	00004097          	auipc	ra,0x4
    8000317e:	d1e080e7          	jalr	-738(ra) # 80006e98 <virtio_disk_intr>
    if(irq)
    80003182:	b7e5                	j	8000316a <devintr+0x60>
      receive_packet(temp, 0);
    80003184:	4581                	li	a1,0
    80003186:	4501                	li	a0,0
    80003188:	00004097          	auipc	ra,0x4
    8000318c:	5bc080e7          	jalr	1468(ra) # 80007744 <receive_packet>
    80003190:	bfe9                	j	8000316a <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80003192:	85ba                	mv	a1,a4
    80003194:	00007517          	auipc	a0,0x7
    80003198:	1ac50513          	addi	a0,a0,428 # 8000a340 <etext+0x340>
    8000319c:	ffffd097          	auipc	ra,0xffffd
    800031a0:	40c080e7          	jalr	1036(ra) # 800005a8 <printf>
    if(irq)
    800031a4:	b7d9                	j	8000316a <devintr+0x60>
    if(cpuid() == 0){
    800031a6:	fffff097          	auipc	ra,0xfffff
    800031aa:	ca4080e7          	jalr	-860(ra) # 80001e4a <cpuid>
    800031ae:	c901                	beqz	a0,800031be <devintr+0xb4>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800031b0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800031b4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800031b6:	14479073          	csrw	sip,a5
    return 2;
    800031ba:	4509                	li	a0,2
    800031bc:	bf9d                	j	80003132 <devintr+0x28>
      clockintr();
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	f04080e7          	jalr	-252(ra) # 800030c2 <clockintr>
    800031c6:	b7ed                	j	800031b0 <devintr+0xa6>
}
    800031c8:	8082                	ret

00000000800031ca <usertrap>:
{
    800031ca:	1101                	addi	sp,sp,-32
    800031cc:	ec06                	sd	ra,24(sp)
    800031ce:	e822                	sd	s0,16(sp)
    800031d0:	e426                	sd	s1,8(sp)
    800031d2:	e04a                	sd	s2,0(sp)
    800031d4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800031d6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800031da:	1007f793          	andi	a5,a5,256
    800031de:	e3b1                	bnez	a5,80003222 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800031e0:	00003797          	auipc	a5,0x3
    800031e4:	6b078793          	addi	a5,a5,1712 # 80006890 <kernelvec>
    800031e8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800031ec:	fffff097          	auipc	ra,0xfffff
    800031f0:	c92080e7          	jalr	-878(ra) # 80001e7e <myproc>
    800031f4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800031f6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800031f8:	14102773          	csrr	a4,sepc
    800031fc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800031fe:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80003202:	47a1                	li	a5,8
    80003204:	02f70763          	beq	a4,a5,80003232 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80003208:	00000097          	auipc	ra,0x0
    8000320c:	f02080e7          	jalr	-254(ra) # 8000310a <devintr>
    80003210:	892a                	mv	s2,a0
    80003212:	c151                	beqz	a0,80003296 <usertrap+0xcc>
  if(killed(p))
    80003214:	8526                	mv	a0,s1
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	94c080e7          	jalr	-1716(ra) # 80002b62 <killed>
    8000321e:	c929                	beqz	a0,80003270 <usertrap+0xa6>
    80003220:	a099                	j	80003266 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80003222:	00007517          	auipc	a0,0x7
    80003226:	13e50513          	addi	a0,a0,318 # 8000a360 <etext+0x360>
    8000322a:	ffffd097          	auipc	ra,0xffffd
    8000322e:	334080e7          	jalr	820(ra) # 8000055e <panic>
    if(killed(p))
    80003232:	00000097          	auipc	ra,0x0
    80003236:	930080e7          	jalr	-1744(ra) # 80002b62 <killed>
    8000323a:	e921                	bnez	a0,8000328a <usertrap+0xc0>
    p->trapframe->epc += 4;
    8000323c:	6cb8                	ld	a4,88(s1)
    8000323e:	6f1c                	ld	a5,24(a4)
    80003240:	0791                	addi	a5,a5,4
    80003242:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003244:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003248:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000324c:	10079073          	csrw	sstatus,a5
    syscall();
    80003250:	00000097          	auipc	ra,0x0
    80003254:	2ce080e7          	jalr	718(ra) # 8000351e <syscall>
  if(killed(p))
    80003258:	8526                	mv	a0,s1
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	908080e7          	jalr	-1784(ra) # 80002b62 <killed>
    80003262:	c911                	beqz	a0,80003276 <usertrap+0xac>
    80003264:	4901                	li	s2,0
    exit(-1);
    80003266:	557d                	li	a0,-1
    80003268:	fffff097          	auipc	ra,0xfffff
    8000326c:	6da080e7          	jalr	1754(ra) # 80002942 <exit>
  if(which_dev == 2)
    80003270:	4789                	li	a5,2
    80003272:	04f90f63          	beq	s2,a5,800032d0 <usertrap+0x106>
  usertrapret();
    80003276:	00000097          	auipc	ra,0x0
    8000327a:	db6080e7          	jalr	-586(ra) # 8000302c <usertrapret>
}
    8000327e:	60e2                	ld	ra,24(sp)
    80003280:	6442                	ld	s0,16(sp)
    80003282:	64a2                	ld	s1,8(sp)
    80003284:	6902                	ld	s2,0(sp)
    80003286:	6105                	addi	sp,sp,32
    80003288:	8082                	ret
      exit(-1);
    8000328a:	557d                	li	a0,-1
    8000328c:	fffff097          	auipc	ra,0xfffff
    80003290:	6b6080e7          	jalr	1718(ra) # 80002942 <exit>
    80003294:	b765                	j	8000323c <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003296:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000329a:	5890                	lw	a2,48(s1)
    8000329c:	00007517          	auipc	a0,0x7
    800032a0:	0e450513          	addi	a0,a0,228 # 8000a380 <etext+0x380>
    800032a4:	ffffd097          	auipc	ra,0xffffd
    800032a8:	304080e7          	jalr	772(ra) # 800005a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800032ac:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800032b0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800032b4:	00007517          	auipc	a0,0x7
    800032b8:	0fc50513          	addi	a0,a0,252 # 8000a3b0 <etext+0x3b0>
    800032bc:	ffffd097          	auipc	ra,0xffffd
    800032c0:	2ec080e7          	jalr	748(ra) # 800005a8 <printf>
    setkilled(p);
    800032c4:	8526                	mv	a0,s1
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	870080e7          	jalr	-1936(ra) # 80002b36 <setkilled>
    800032ce:	b769                	j	80003258 <usertrap+0x8e>
    yield();
    800032d0:	fffff097          	auipc	ra,0xfffff
    800032d4:	428080e7          	jalr	1064(ra) # 800026f8 <yield>
    800032d8:	bf79                	j	80003276 <usertrap+0xac>

00000000800032da <kerneltrap>:
{
    800032da:	7179                	addi	sp,sp,-48
    800032dc:	f406                	sd	ra,40(sp)
    800032de:	f022                	sd	s0,32(sp)
    800032e0:	ec26                	sd	s1,24(sp)
    800032e2:	e84a                	sd	s2,16(sp)
    800032e4:	e44e                	sd	s3,8(sp)
    800032e6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800032e8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032ec:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800032f0:	142027f3          	csrr	a5,scause
    800032f4:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    800032f6:	1004f793          	andi	a5,s1,256
    800032fa:	cb85                	beqz	a5,8000332a <kerneltrap+0x50>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032fc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003300:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80003302:	ef85                	bnez	a5,8000333a <kerneltrap+0x60>
  if((which_dev = devintr()) == 0){
    80003304:	00000097          	auipc	ra,0x0
    80003308:	e06080e7          	jalr	-506(ra) # 8000310a <devintr>
    8000330c:	cd1d                	beqz	a0,8000334a <kerneltrap+0x70>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000330e:	4789                	li	a5,2
    80003310:	06f50a63          	beq	a0,a5,80003384 <kerneltrap+0xaa>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003314:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003318:	10049073          	csrw	sstatus,s1
}
    8000331c:	70a2                	ld	ra,40(sp)
    8000331e:	7402                	ld	s0,32(sp)
    80003320:	64e2                	ld	s1,24(sp)
    80003322:	6942                	ld	s2,16(sp)
    80003324:	69a2                	ld	s3,8(sp)
    80003326:	6145                	addi	sp,sp,48
    80003328:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000332a:	00007517          	auipc	a0,0x7
    8000332e:	0a650513          	addi	a0,a0,166 # 8000a3d0 <etext+0x3d0>
    80003332:	ffffd097          	auipc	ra,0xffffd
    80003336:	22c080e7          	jalr	556(ra) # 8000055e <panic>
    panic("kerneltrap: interrupts enabled");
    8000333a:	00007517          	auipc	a0,0x7
    8000333e:	0be50513          	addi	a0,a0,190 # 8000a3f8 <etext+0x3f8>
    80003342:	ffffd097          	auipc	ra,0xffffd
    80003346:	21c080e7          	jalr	540(ra) # 8000055e <panic>
    printf("scause %p\n", scause);
    8000334a:	85ce                	mv	a1,s3
    8000334c:	00007517          	auipc	a0,0x7
    80003350:	0cc50513          	addi	a0,a0,204 # 8000a418 <etext+0x418>
    80003354:	ffffd097          	auipc	ra,0xffffd
    80003358:	254080e7          	jalr	596(ra) # 800005a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000335c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003360:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003364:	00007517          	auipc	a0,0x7
    80003368:	0c450513          	addi	a0,a0,196 # 8000a428 <etext+0x428>
    8000336c:	ffffd097          	auipc	ra,0xffffd
    80003370:	23c080e7          	jalr	572(ra) # 800005a8 <printf>
    panic("kerneltrap");
    80003374:	00007517          	auipc	a0,0x7
    80003378:	0cc50513          	addi	a0,a0,204 # 8000a440 <etext+0x440>
    8000337c:	ffffd097          	auipc	ra,0xffffd
    80003380:	1e2080e7          	jalr	482(ra) # 8000055e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003384:	fffff097          	auipc	ra,0xfffff
    80003388:	afa080e7          	jalr	-1286(ra) # 80001e7e <myproc>
    8000338c:	d541                	beqz	a0,80003314 <kerneltrap+0x3a>
    8000338e:	fffff097          	auipc	ra,0xfffff
    80003392:	af0080e7          	jalr	-1296(ra) # 80001e7e <myproc>
    80003396:	4d18                	lw	a4,24(a0)
    80003398:	4791                	li	a5,4
    8000339a:	f6f71de3          	bne	a4,a5,80003314 <kerneltrap+0x3a>
    yield();
    8000339e:	fffff097          	auipc	ra,0xfffff
    800033a2:	35a080e7          	jalr	858(ra) # 800026f8 <yield>
    800033a6:	b7bd                	j	80003314 <kerneltrap+0x3a>

00000000800033a8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800033a8:	1101                	addi	sp,sp,-32
    800033aa:	ec06                	sd	ra,24(sp)
    800033ac:	e822                	sd	s0,16(sp)
    800033ae:	e426                	sd	s1,8(sp)
    800033b0:	1000                	addi	s0,sp,32
    800033b2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800033b4:	fffff097          	auipc	ra,0xfffff
    800033b8:	aca080e7          	jalr	-1334(ra) # 80001e7e <myproc>
  switch (n) {
    800033bc:	4795                	li	a5,5
    800033be:	0497e163          	bltu	a5,s1,80003400 <argraw+0x58>
    800033c2:	048a                	slli	s1,s1,0x2
    800033c4:	00008717          	auipc	a4,0x8
    800033c8:	9b470713          	addi	a4,a4,-1612 # 8000ad78 <states.0+0x30>
    800033cc:	94ba                	add	s1,s1,a4
    800033ce:	409c                	lw	a5,0(s1)
    800033d0:	97ba                	add	a5,a5,a4
    800033d2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800033d4:	6d3c                	ld	a5,88(a0)
    800033d6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800033d8:	60e2                	ld	ra,24(sp)
    800033da:	6442                	ld	s0,16(sp)
    800033dc:	64a2                	ld	s1,8(sp)
    800033de:	6105                	addi	sp,sp,32
    800033e0:	8082                	ret
    return p->trapframe->a1;
    800033e2:	6d3c                	ld	a5,88(a0)
    800033e4:	7fa8                	ld	a0,120(a5)
    800033e6:	bfcd                	j	800033d8 <argraw+0x30>
    return p->trapframe->a2;
    800033e8:	6d3c                	ld	a5,88(a0)
    800033ea:	63c8                	ld	a0,128(a5)
    800033ec:	b7f5                	j	800033d8 <argraw+0x30>
    return p->trapframe->a3;
    800033ee:	6d3c                	ld	a5,88(a0)
    800033f0:	67c8                	ld	a0,136(a5)
    800033f2:	b7dd                	j	800033d8 <argraw+0x30>
    return p->trapframe->a4;
    800033f4:	6d3c                	ld	a5,88(a0)
    800033f6:	6bc8                	ld	a0,144(a5)
    800033f8:	b7c5                	j	800033d8 <argraw+0x30>
    return p->trapframe->a5;
    800033fa:	6d3c                	ld	a5,88(a0)
    800033fc:	6fc8                	ld	a0,152(a5)
    800033fe:	bfe9                	j	800033d8 <argraw+0x30>
  panic("argraw");
    80003400:	00007517          	auipc	a0,0x7
    80003404:	05050513          	addi	a0,a0,80 # 8000a450 <etext+0x450>
    80003408:	ffffd097          	auipc	ra,0xffffd
    8000340c:	156080e7          	jalr	342(ra) # 8000055e <panic>

0000000080003410 <fetchaddr>:
{
    80003410:	1101                	addi	sp,sp,-32
    80003412:	ec06                	sd	ra,24(sp)
    80003414:	e822                	sd	s0,16(sp)
    80003416:	e426                	sd	s1,8(sp)
    80003418:	e04a                	sd	s2,0(sp)
    8000341a:	1000                	addi	s0,sp,32
    8000341c:	84aa                	mv	s1,a0
    8000341e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	a5e080e7          	jalr	-1442(ra) # 80001e7e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003428:	653c                	ld	a5,72(a0)
    8000342a:	02f4f863          	bgeu	s1,a5,8000345a <fetchaddr+0x4a>
    8000342e:	00848713          	addi	a4,s1,8
    80003432:	02e7e663          	bltu	a5,a4,8000345e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003436:	46a1                	li	a3,8
    80003438:	8626                	mv	a2,s1
    8000343a:	85ca                	mv	a1,s2
    8000343c:	6928                	ld	a0,80(a0)
    8000343e:	ffffe097          	auipc	ra,0xffffe
    80003442:	758080e7          	jalr	1880(ra) # 80001b96 <copyin>
    80003446:	00a03533          	snez	a0,a0
    8000344a:	40a0053b          	negw	a0,a0
}
    8000344e:	60e2                	ld	ra,24(sp)
    80003450:	6442                	ld	s0,16(sp)
    80003452:	64a2                	ld	s1,8(sp)
    80003454:	6902                	ld	s2,0(sp)
    80003456:	6105                	addi	sp,sp,32
    80003458:	8082                	ret
    return -1;
    8000345a:	557d                	li	a0,-1
    8000345c:	bfcd                	j	8000344e <fetchaddr+0x3e>
    8000345e:	557d                	li	a0,-1
    80003460:	b7fd                	j	8000344e <fetchaddr+0x3e>

0000000080003462 <fetchstr>:
{
    80003462:	7179                	addi	sp,sp,-48
    80003464:	f406                	sd	ra,40(sp)
    80003466:	f022                	sd	s0,32(sp)
    80003468:	ec26                	sd	s1,24(sp)
    8000346a:	e84a                	sd	s2,16(sp)
    8000346c:	e44e                	sd	s3,8(sp)
    8000346e:	1800                	addi	s0,sp,48
    80003470:	89aa                	mv	s3,a0
    80003472:	84ae                	mv	s1,a1
    80003474:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	a08080e7          	jalr	-1528(ra) # 80001e7e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000347e:	86ca                	mv	a3,s2
    80003480:	864e                	mv	a2,s3
    80003482:	85a6                	mv	a1,s1
    80003484:	6928                	ld	a0,80(a0)
    80003486:	ffffe097          	auipc	ra,0xffffe
    8000348a:	79e080e7          	jalr	1950(ra) # 80001c24 <copyinstr>
    8000348e:	00054e63          	bltz	a0,800034aa <fetchstr+0x48>
  return strlen(buf);
    80003492:	8526                	mv	a0,s1
    80003494:	ffffe097          	auipc	ra,0xffffe
    80003498:	b26080e7          	jalr	-1242(ra) # 80000fba <strlen>
}
    8000349c:	70a2                	ld	ra,40(sp)
    8000349e:	7402                	ld	s0,32(sp)
    800034a0:	64e2                	ld	s1,24(sp)
    800034a2:	6942                	ld	s2,16(sp)
    800034a4:	69a2                	ld	s3,8(sp)
    800034a6:	6145                	addi	sp,sp,48
    800034a8:	8082                	ret
    return -1;
    800034aa:	557d                	li	a0,-1
    800034ac:	bfc5                	j	8000349c <fetchstr+0x3a>

00000000800034ae <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800034ae:	1101                	addi	sp,sp,-32
    800034b0:	ec06                	sd	ra,24(sp)
    800034b2:	e822                	sd	s0,16(sp)
    800034b4:	e426                	sd	s1,8(sp)
    800034b6:	1000                	addi	s0,sp,32
    800034b8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800034ba:	00000097          	auipc	ra,0x0
    800034be:	eee080e7          	jalr	-274(ra) # 800033a8 <argraw>
    800034c2:	c088                	sw	a0,0(s1)
}
    800034c4:	60e2                	ld	ra,24(sp)
    800034c6:	6442                	ld	s0,16(sp)
    800034c8:	64a2                	ld	s1,8(sp)
    800034ca:	6105                	addi	sp,sp,32
    800034cc:	8082                	ret

00000000800034ce <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800034ce:	1101                	addi	sp,sp,-32
    800034d0:	ec06                	sd	ra,24(sp)
    800034d2:	e822                	sd	s0,16(sp)
    800034d4:	e426                	sd	s1,8(sp)
    800034d6:	1000                	addi	s0,sp,32
    800034d8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800034da:	00000097          	auipc	ra,0x0
    800034de:	ece080e7          	jalr	-306(ra) # 800033a8 <argraw>
    800034e2:	e088                	sd	a0,0(s1)
}
    800034e4:	60e2                	ld	ra,24(sp)
    800034e6:	6442                	ld	s0,16(sp)
    800034e8:	64a2                	ld	s1,8(sp)
    800034ea:	6105                	addi	sp,sp,32
    800034ec:	8082                	ret

00000000800034ee <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800034ee:	1101                	addi	sp,sp,-32
    800034f0:	ec06                	sd	ra,24(sp)
    800034f2:	e822                	sd	s0,16(sp)
    800034f4:	e426                	sd	s1,8(sp)
    800034f6:	e04a                	sd	s2,0(sp)
    800034f8:	1000                	addi	s0,sp,32
    800034fa:	892e                	mv	s2,a1
    800034fc:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800034fe:	00000097          	auipc	ra,0x0
    80003502:	eaa080e7          	jalr	-342(ra) # 800033a8 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80003506:	8626                	mv	a2,s1
    80003508:	85ca                	mv	a1,s2
    8000350a:	00000097          	auipc	ra,0x0
    8000350e:	f58080e7          	jalr	-168(ra) # 80003462 <fetchstr>
}
    80003512:	60e2                	ld	ra,24(sp)
    80003514:	6442                	ld	s0,16(sp)
    80003516:	64a2                	ld	s1,8(sp)
    80003518:	6902                	ld	s2,0(sp)
    8000351a:	6105                	addi	sp,sp,32
    8000351c:	8082                	ret

000000008000351e <syscall>:
[SYS_connect]       sys_connect,
};

void
syscall(void)
{
    8000351e:	1101                	addi	sp,sp,-32
    80003520:	ec06                	sd	ra,24(sp)
    80003522:	e822                	sd	s0,16(sp)
    80003524:	e426                	sd	s1,8(sp)
    80003526:	e04a                	sd	s2,0(sp)
    80003528:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000352a:	fffff097          	auipc	ra,0xfffff
    8000352e:	954080e7          	jalr	-1708(ra) # 80001e7e <myproc>
    80003532:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003534:	05853903          	ld	s2,88(a0)
    80003538:	0a893783          	ld	a5,168(s2)
    8000353c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003540:	37fd                	addiw	a5,a5,-1
    80003542:	4775                	li	a4,29
    80003544:	00f76f63          	bltu	a4,a5,80003562 <syscall+0x44>
    80003548:	00369713          	slli	a4,a3,0x3
    8000354c:	00008797          	auipc	a5,0x8
    80003550:	84478793          	addi	a5,a5,-1980 # 8000ad90 <syscalls>
    80003554:	97ba                	add	a5,a5,a4
    80003556:	639c                	ld	a5,0(a5)
    80003558:	c789                	beqz	a5,80003562 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000355a:	9782                	jalr	a5
    8000355c:	06a93823          	sd	a0,112(s2)
    80003560:	a839                	j	8000357e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003562:	15848613          	addi	a2,s1,344
    80003566:	588c                	lw	a1,48(s1)
    80003568:	00007517          	auipc	a0,0x7
    8000356c:	ef050513          	addi	a0,a0,-272 # 8000a458 <etext+0x458>
    80003570:	ffffd097          	auipc	ra,0xffffd
    80003574:	038080e7          	jalr	56(ra) # 800005a8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003578:	6cbc                	ld	a5,88(s1)
    8000357a:	577d                	li	a4,-1
    8000357c:	fbb8                	sd	a4,112(a5)
  }
}
    8000357e:	60e2                	ld	ra,24(sp)
    80003580:	6442                	ld	s0,16(sp)
    80003582:	64a2                	ld	s1,8(sp)
    80003584:	6902                	ld	s2,0(sp)
    80003586:	6105                	addi	sp,sp,32
    80003588:	8082                	ret

000000008000358a <sys_exit>:
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void) {
    8000358a:	1101                	addi	sp,sp,-32
    8000358c:	ec06                	sd	ra,24(sp)
    8000358e:	e822                	sd	s0,16(sp)
    80003590:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003592:	fec40593          	addi	a1,s0,-20
    80003596:	4501                	li	a0,0
    80003598:	00000097          	auipc	ra,0x0
    8000359c:	f16080e7          	jalr	-234(ra) # 800034ae <argint>
  exit(n);
    800035a0:	fec42503          	lw	a0,-20(s0)
    800035a4:	fffff097          	auipc	ra,0xfffff
    800035a8:	39e080e7          	jalr	926(ra) # 80002942 <exit>
  return 0; // not reached
}
    800035ac:	4501                	li	a0,0
    800035ae:	60e2                	ld	ra,24(sp)
    800035b0:	6442                	ld	s0,16(sp)
    800035b2:	6105                	addi	sp,sp,32
    800035b4:	8082                	ret

00000000800035b6 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    800035b6:	1141                	addi	sp,sp,-16
    800035b8:	e406                	sd	ra,8(sp)
    800035ba:	e022                	sd	s0,0(sp)
    800035bc:	0800                	addi	s0,sp,16
    800035be:	fffff097          	auipc	ra,0xfffff
    800035c2:	8c0080e7          	jalr	-1856(ra) # 80001e7e <myproc>
    800035c6:	5908                	lw	a0,48(a0)
    800035c8:	60a2                	ld	ra,8(sp)
    800035ca:	6402                	ld	s0,0(sp)
    800035cc:	0141                	addi	sp,sp,16
    800035ce:	8082                	ret

00000000800035d0 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    800035d0:	1141                	addi	sp,sp,-16
    800035d2:	e406                	sd	ra,8(sp)
    800035d4:	e022                	sd	s0,0(sp)
    800035d6:	0800                	addi	s0,sp,16
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	caa080e7          	jalr	-854(ra) # 80002282 <fork>
    800035e0:	60a2                	ld	ra,8(sp)
    800035e2:	6402                	ld	s0,0(sp)
    800035e4:	0141                	addi	sp,sp,16
    800035e6:	8082                	ret

00000000800035e8 <sys_wait>:

uint64 sys_wait(void) {
    800035e8:	1101                	addi	sp,sp,-32
    800035ea:	ec06                	sd	ra,24(sp)
    800035ec:	e822                	sd	s0,16(sp)
    800035ee:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800035f0:	fe840593          	addi	a1,s0,-24
    800035f4:	4501                	li	a0,0
    800035f6:	00000097          	auipc	ra,0x0
    800035fa:	ed8080e7          	jalr	-296(ra) # 800034ce <argaddr>
  return wait(p);
    800035fe:	fe843503          	ld	a0,-24(s0)
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	6d4080e7          	jalr	1748(ra) # 80002cd6 <wait>
}
    8000360a:	60e2                	ld	ra,24(sp)
    8000360c:	6442                	ld	s0,16(sp)
    8000360e:	6105                	addi	sp,sp,32
    80003610:	8082                	ret

0000000080003612 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80003612:	7179                	addi	sp,sp,-48
    80003614:	f406                	sd	ra,40(sp)
    80003616:	f022                	sd	s0,32(sp)
    80003618:	ec26                	sd	s1,24(sp)
    8000361a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000361c:	fdc40593          	addi	a1,s0,-36
    80003620:	4501                	li	a0,0
    80003622:	00000097          	auipc	ra,0x0
    80003626:	e8c080e7          	jalr	-372(ra) # 800034ae <argint>
  addr = myproc()->sz;
    8000362a:	fffff097          	auipc	ra,0xfffff
    8000362e:	854080e7          	jalr	-1964(ra) # 80001e7e <myproc>
    80003632:	653c                	ld	a5,72(a0)
    80003634:	84be                	mv	s1,a5
  if (growproc(n) < 0)
    80003636:	fdc42503          	lw	a0,-36(s0)
    8000363a:	fffff097          	auipc	ra,0xfffff
    8000363e:	bb2080e7          	jalr	-1102(ra) # 800021ec <growproc>
    80003642:	00054863          	bltz	a0,80003652 <sys_sbrk+0x40>
    return -1;
  return addr;
}
    80003646:	8526                	mv	a0,s1
    80003648:	70a2                	ld	ra,40(sp)
    8000364a:	7402                	ld	s0,32(sp)
    8000364c:	64e2                	ld	s1,24(sp)
    8000364e:	6145                	addi	sp,sp,48
    80003650:	8082                	ret
    return -1;
    80003652:	57fd                	li	a5,-1
    80003654:	84be                	mv	s1,a5
    80003656:	bfc5                	j	80003646 <sys_sbrk+0x34>

0000000080003658 <sys_sleep>:

uint64 sys_sleep(void) {
    80003658:	7139                	addi	sp,sp,-64
    8000365a:	fc06                	sd	ra,56(sp)
    8000365c:	f822                	sd	s0,48(sp)
    8000365e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003660:	fcc40593          	addi	a1,s0,-52
    80003664:	4501                	li	a0,0
    80003666:	00000097          	auipc	ra,0x0
    8000366a:	e48080e7          	jalr	-440(ra) # 800034ae <argint>
  acquire(&tickslock);
    8000366e:	00061517          	auipc	a0,0x61
    80003672:	ed250513          	addi	a0,a0,-302 # 80064540 <tickslock>
    80003676:	ffffd097          	auipc	ra,0xffffd
    8000367a:	6be080e7          	jalr	1726(ra) # 80000d34 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    8000367e:	fcc42783          	lw	a5,-52(s0)
    80003682:	cba9                	beqz	a5,800036d4 <sys_sleep+0x7c>
    80003684:	f426                	sd	s1,40(sp)
    80003686:	f04a                	sd	s2,32(sp)
    80003688:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    8000368a:	0000b997          	auipc	s3,0xb
    8000368e:	c069a983          	lw	s3,-1018(s3) # 8000e290 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003692:	00061917          	auipc	s2,0x61
    80003696:	eae90913          	addi	s2,s2,-338 # 80064540 <tickslock>
    8000369a:	0000b497          	auipc	s1,0xb
    8000369e:	bf648493          	addi	s1,s1,-1034 # 8000e290 <ticks>
    if (killed(myproc())) {
    800036a2:	ffffe097          	auipc	ra,0xffffe
    800036a6:	7dc080e7          	jalr	2012(ra) # 80001e7e <myproc>
    800036aa:	fffff097          	auipc	ra,0xfffff
    800036ae:	4b8080e7          	jalr	1208(ra) # 80002b62 <killed>
    800036b2:	ed15                	bnez	a0,800036ee <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800036b4:	85ca                	mv	a1,s2
    800036b6:	8526                	mv	a0,s1
    800036b8:	fffff097          	auipc	ra,0xfffff
    800036bc:	07c080e7          	jalr	124(ra) # 80002734 <sleep>
  while (ticks - ticks0 < n) {
    800036c0:	409c                	lw	a5,0(s1)
    800036c2:	413787bb          	subw	a5,a5,s3
    800036c6:	fcc42703          	lw	a4,-52(s0)
    800036ca:	fce7ece3          	bltu	a5,a4,800036a2 <sys_sleep+0x4a>
    800036ce:	74a2                	ld	s1,40(sp)
    800036d0:	7902                	ld	s2,32(sp)
    800036d2:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800036d4:	00061517          	auipc	a0,0x61
    800036d8:	e6c50513          	addi	a0,a0,-404 # 80064540 <tickslock>
    800036dc:	ffffd097          	auipc	ra,0xffffd
    800036e0:	708080e7          	jalr	1800(ra) # 80000de4 <release>
  return 0;
    800036e4:	4501                	li	a0,0
}
    800036e6:	70e2                	ld	ra,56(sp)
    800036e8:	7442                	ld	s0,48(sp)
    800036ea:	6121                	addi	sp,sp,64
    800036ec:	8082                	ret
      release(&tickslock);
    800036ee:	00061517          	auipc	a0,0x61
    800036f2:	e5250513          	addi	a0,a0,-430 # 80064540 <tickslock>
    800036f6:	ffffd097          	auipc	ra,0xffffd
    800036fa:	6ee080e7          	jalr	1774(ra) # 80000de4 <release>
      return -1;
    800036fe:	557d                	li	a0,-1
    80003700:	74a2                	ld	s1,40(sp)
    80003702:	7902                	ld	s2,32(sp)
    80003704:	69e2                	ld	s3,24(sp)
    80003706:	b7c5                	j	800036e6 <sys_sleep+0x8e>

0000000080003708 <sys_kill>:

uint64 sys_kill(void) {
    80003708:	1101                	addi	sp,sp,-32
    8000370a:	ec06                	sd	ra,24(sp)
    8000370c:	e822                	sd	s0,16(sp)
    8000370e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003710:	fec40593          	addi	a1,s0,-20
    80003714:	4501                	li	a0,0
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	d98080e7          	jalr	-616(ra) # 800034ae <argint>
  return kill(pid);
    8000371e:	fec42503          	lw	a0,-20(s0)
    80003722:	fffff097          	auipc	ra,0xfffff
    80003726:	3a2080e7          	jalr	930(ra) # 80002ac4 <kill>
}
    8000372a:	60e2                	ld	ra,24(sp)
    8000372c:	6442                	ld	s0,16(sp)
    8000372e:	6105                	addi	sp,sp,32
    80003730:	8082                	ret

0000000080003732 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80003732:	1101                	addi	sp,sp,-32
    80003734:	ec06                	sd	ra,24(sp)
    80003736:	e822                	sd	s0,16(sp)
    80003738:	e426                	sd	s1,8(sp)
    8000373a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000373c:	00061517          	auipc	a0,0x61
    80003740:	e0450513          	addi	a0,a0,-508 # 80064540 <tickslock>
    80003744:	ffffd097          	auipc	ra,0xffffd
    80003748:	5f0080e7          	jalr	1520(ra) # 80000d34 <acquire>
  xticks = ticks;
    8000374c:	0000b797          	auipc	a5,0xb
    80003750:	b447a783          	lw	a5,-1212(a5) # 8000e290 <ticks>
    80003754:	84be                	mv	s1,a5
  release(&tickslock);
    80003756:	00061517          	auipc	a0,0x61
    8000375a:	dea50513          	addi	a0,a0,-534 # 80064540 <tickslock>
    8000375e:	ffffd097          	auipc	ra,0xffffd
    80003762:	686080e7          	jalr	1670(ra) # 80000de4 <release>
  return xticks;
}
    80003766:	02049513          	slli	a0,s1,0x20
    8000376a:	9101                	srli	a0,a0,0x20
    8000376c:	60e2                	ld	ra,24(sp)
    8000376e:	6442                	ld	s0,16(sp)
    80003770:	64a2                	ld	s1,8(sp)
    80003772:	6105                	addi	sp,sp,32
    80003774:	8082                	ret

0000000080003776 <sys_spoon>:

uint64 sys_spoon(void) {
    80003776:	1101                	addi	sp,sp,-32
    80003778:	ec06                	sd	ra,24(sp)
    8000377a:	e822                	sd	s0,16(sp)
    8000377c:	1000                	addi	s0,sp,32
  // obtain the argument from the stack, we need some special handling
  uint64 addr;
  argaddr(0, &addr);
    8000377e:	fe840593          	addi	a1,s0,-24
    80003782:	4501                	li	a0,0
    80003784:	00000097          	auipc	ra,0x0
    80003788:	d4a080e7          	jalr	-694(ra) # 800034ce <argaddr>
  return spoon((void *)addr);
    8000378c:	fe843503          	ld	a0,-24(s0)
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	7ca080e7          	jalr	1994(ra) # 80002f5a <spoon>
}
    80003798:	60e2                	ld	ra,24(sp)
    8000379a:	6442                	ld	s0,16(sp)
    8000379c:	6105                	addi	sp,sp,32
    8000379e:	8082                	ret

00000000800037a0 <sys_create_thread>:

uint64 sys_create_thread(void *arg) {
    800037a0:	7179                	addi	sp,sp,-48
    800037a2:	f406                	sd	ra,40(sp)
    800037a4:	f022                	sd	s0,32(sp)
    800037a6:	1800                	addi	s0,sp,48
  uint64 fn_addr, args_addr, stack_addr, exit_fn;
  argaddr(0, &fn_addr);
    800037a8:	fe840593          	addi	a1,s0,-24
    800037ac:	4501                	li	a0,0
    800037ae:	00000097          	auipc	ra,0x0
    800037b2:	d20080e7          	jalr	-736(ra) # 800034ce <argaddr>
  argaddr(1, &args_addr);
    800037b6:	fe040593          	addi	a1,s0,-32
    800037ba:	4505                	li	a0,1
    800037bc:	00000097          	auipc	ra,0x0
    800037c0:	d12080e7          	jalr	-750(ra) # 800034ce <argaddr>
  argaddr(2, &stack_addr);
    800037c4:	fd840593          	addi	a1,s0,-40
    800037c8:	4509                	li	a0,2
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	d04080e7          	jalr	-764(ra) # 800034ce <argaddr>
  argaddr(3, &exit_fn);
    800037d2:	fd040593          	addi	a1,s0,-48
    800037d6:	450d                	li	a0,3
    800037d8:	00000097          	auipc	ra,0x0
    800037dc:	cf6080e7          	jalr	-778(ra) # 800034ce <argaddr>
  return create_thread((void *)fn_addr, (void *)args_addr, (void *)stack_addr,
    800037e0:	fd043683          	ld	a3,-48(s0)
    800037e4:	fd843603          	ld	a2,-40(s0)
    800037e8:	fe043583          	ld	a1,-32(s0)
    800037ec:	fe843503          	ld	a0,-24(s0)
    800037f0:	fffff097          	auipc	ra,0xfffff
    800037f4:	bd8080e7          	jalr	-1064(ra) # 800023c8 <create_thread>
                       (void *)exit_fn);
}
    800037f8:	70a2                	ld	ra,40(sp)
    800037fa:	7402                	ld	s0,32(sp)
    800037fc:	6145                	addi	sp,sp,48
    800037fe:	8082                	ret

0000000080003800 <sys_join_thread>:

uint64 sys_join_thread(void *arg) {
    80003800:	1101                	addi	sp,sp,-32
    80003802:	ec06                	sd	ra,24(sp)
    80003804:	e822                	sd	s0,16(sp)
    80003806:	1000                	addi	s0,sp,32
  uint64 thread_id, status_addr;
  argaddr(0, &thread_id);
    80003808:	fe840593          	addi	a1,s0,-24
    8000380c:	4501                	li	a0,0
    8000380e:	00000097          	auipc	ra,0x0
    80003812:	cc0080e7          	jalr	-832(ra) # 800034ce <argaddr>
  argaddr(1, &status_addr);
    80003816:	fe040593          	addi	a1,s0,-32
    8000381a:	4505                	li	a0,1
    8000381c:	00000097          	auipc	ra,0x0
    80003820:	cb2080e7          	jalr	-846(ra) # 800034ce <argaddr>
  return join_thread(thread_id, status_addr);
    80003824:	fe043583          	ld	a1,-32(s0)
    80003828:	fe843503          	ld	a0,-24(s0)
    8000382c:	fffff097          	auipc	ra,0xfffff
    80003830:	368080e7          	jalr	872(ra) # 80002b94 <join_thread>
}
    80003834:	60e2                	ld	ra,24(sp)
    80003836:	6442                	ld	s0,16(sp)
    80003838:	6105                	addi	sp,sp,32
    8000383a:	8082                	ret

000000008000383c <sys_thread_exit>:

uint64 sys_thread_exit(void *arg) {
    8000383c:	1101                	addi	sp,sp,-32
    8000383e:	ec06                	sd	ra,24(sp)
    80003840:	e822                	sd	s0,16(sp)
    80003842:	1000                	addi	s0,sp,32
  uint64 status_addr;
  argaddr(0, &status_addr);
    80003844:	fe840593          	addi	a1,s0,-24
    80003848:	4501                	li	a0,0
    8000384a:	00000097          	auipc	ra,0x0
    8000384e:	c84080e7          	jalr	-892(ra) # 800034ce <argaddr>
  return thread_exit(status_addr);
    80003852:	fe843503          	ld	a0,-24(s0)
    80003856:	fffff097          	auipc	ra,0xfffff
    8000385a:	012080e7          	jalr	18(ra) # 80002868 <thread_exit>
}
    8000385e:	60e2                	ld	ra,24(sp)
    80003860:	6442                	ld	s0,16(sp)
    80003862:	6105                	addi	sp,sp,32
    80003864:	8082                	ret

0000000080003866 <sys_bind>:

uint64 sys_bind(void *arg) {
    80003866:	7139                	addi	sp,sp,-64
    80003868:	fc06                	sd	ra,56(sp)
    8000386a:	f822                	sd	s0,48(sp)
    8000386c:	f426                	sd	s1,40(sp)
    8000386e:	0080                	addi	s0,sp,64
  uint64 address_family, protocol;
  struct sockaddr address;
  argaddr(0, &address_family);
    80003870:	fd840593          	addi	a1,s0,-40
    80003874:	4501                	li	a0,0
    80003876:	00000097          	auipc	ra,0x0
    8000387a:	c58080e7          	jalr	-936(ra) # 800034ce <argaddr>
  argaddr(1, (uint64 *)&address);
    8000387e:	fc040493          	addi	s1,s0,-64
    80003882:	85a6                	mv	a1,s1
    80003884:	4505                	li	a0,1
    80003886:	00000097          	auipc	ra,0x0
    8000388a:	c48080e7          	jalr	-952(ra) # 800034ce <argaddr>
  argaddr(2, &protocol);
    8000388e:	fd040593          	addi	a1,s0,-48
    80003892:	4509                	li	a0,2
    80003894:	00000097          	auipc	ra,0x0
    80003898:	c3a080e7          	jalr	-966(ra) # 800034ce <argaddr>
  return bind(address_family, &address, protocol);
    8000389c:	fd042603          	lw	a2,-48(s0)
    800038a0:	85a6                	mv	a1,s1
    800038a2:	fd842503          	lw	a0,-40(s0)
    800038a6:	00004097          	auipc	ra,0x4
    800038aa:	098080e7          	jalr	152(ra) # 8000793e <bind>
}
    800038ae:	70e2                	ld	ra,56(sp)
    800038b0:	7442                	ld	s0,48(sp)
    800038b2:	74a2                	ld	s1,40(sp)
    800038b4:	6121                	addi	sp,sp,64
    800038b6:	8082                	ret

00000000800038b8 <sys_listen>:

uint64 sys_listen(void *arg) {
    800038b8:	1101                	addi	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	1000                	addi	s0,sp,32
  uint64 socket, backlog;
  argaddr(0, &socket);
    800038c0:	fe840593          	addi	a1,s0,-24
    800038c4:	4501                	li	a0,0
    800038c6:	00000097          	auipc	ra,0x0
    800038ca:	c08080e7          	jalr	-1016(ra) # 800034ce <argaddr>
  argaddr(1, &backlog);
    800038ce:	fe040593          	addi	a1,s0,-32
    800038d2:	4505                	li	a0,1
    800038d4:	00000097          	auipc	ra,0x0
    800038d8:	bfa080e7          	jalr	-1030(ra) # 800034ce <argaddr>
  return listen(socket, backlog);
    800038dc:	fe042583          	lw	a1,-32(s0)
    800038e0:	fe842503          	lw	a0,-24(s0)
    800038e4:	00004097          	auipc	ra,0x4
    800038e8:	224080e7          	jalr	548(ra) # 80007b08 <listen>
}
    800038ec:	60e2                	ld	ra,24(sp)
    800038ee:	6442                	ld	s0,16(sp)
    800038f0:	6105                	addi	sp,sp,32
    800038f2:	8082                	ret

00000000800038f4 <sys_accept>:

uint64 sys_accept(void *arg) {
    800038f4:	7139                	addi	sp,sp,-64
    800038f6:	fc06                	sd	ra,56(sp)
    800038f8:	f822                	sd	s0,48(sp)
    800038fa:	f426                	sd	s1,40(sp)
    800038fc:	0080                	addi	s0,sp,64
  uint64 socket;
  uint64 address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    800038fe:	fd840593          	addi	a1,s0,-40
    80003902:	4501                	li	a0,0
    80003904:	00000097          	auipc	ra,0x0
    80003908:	bca080e7          	jalr	-1078(ra) # 800034ce <argaddr>
  argaddr(1, (uint64 *)&address);
    8000390c:	fc040493          	addi	s1,s0,-64
    80003910:	85a6                	mv	a1,s1
    80003912:	4505                	li	a0,1
    80003914:	00000097          	auipc	ra,0x0
    80003918:	bba080e7          	jalr	-1094(ra) # 800034ce <argaddr>
  argaddr(2, &address_len);
    8000391c:	fd040593          	addi	a1,s0,-48
    80003920:	4509                	li	a0,2
    80003922:	00000097          	auipc	ra,0x0
    80003926:	bac080e7          	jalr	-1108(ra) # 800034ce <argaddr>
  return accept(socket, &address, address_len);
    8000392a:	fd042603          	lw	a2,-48(s0)
    8000392e:	85a6                	mv	a1,s1
    80003930:	fd842503          	lw	a0,-40(s0)
    80003934:	00004097          	auipc	ra,0x4
    80003938:	236080e7          	jalr	566(ra) # 80007b6a <accept>
}
    8000393c:	70e2                	ld	ra,56(sp)
    8000393e:	7442                	ld	s0,48(sp)
    80003940:	74a2                	ld	s1,40(sp)
    80003942:	6121                	addi	sp,sp,64
    80003944:	8082                	ret

0000000080003946 <sys_socket>:

uint64 sys_socket(void *arg) {
    80003946:	7179                	addi	sp,sp,-48
    80003948:	f406                	sd	ra,40(sp)
    8000394a:	f022                	sd	s0,32(sp)
    8000394c:	1800                	addi	s0,sp,48
  uint64 address_family, address_socktype, protocol;
  argaddr(0, &address_family);
    8000394e:	fe840593          	addi	a1,s0,-24
    80003952:	4501                	li	a0,0
    80003954:	00000097          	auipc	ra,0x0
    80003958:	b7a080e7          	jalr	-1158(ra) # 800034ce <argaddr>
  argaddr(1, &address_socktype);
    8000395c:	fe040593          	addi	a1,s0,-32
    80003960:	4505                	li	a0,1
    80003962:	00000097          	auipc	ra,0x0
    80003966:	b6c080e7          	jalr	-1172(ra) # 800034ce <argaddr>
  argaddr(2, &protocol);
    8000396a:	fd840593          	addi	a1,s0,-40
    8000396e:	4509                	li	a0,2
    80003970:	00000097          	auipc	ra,0x0
    80003974:	b5e080e7          	jalr	-1186(ra) # 800034ce <argaddr>
  return socket(address_family, address_socktype, protocol);
    80003978:	fd842603          	lw	a2,-40(s0)
    8000397c:	fe042583          	lw	a1,-32(s0)
    80003980:	fe842503          	lw	a0,-24(s0)
    80003984:	00004097          	auipc	ra,0x4
    80003988:	312080e7          	jalr	786(ra) # 80007c96 <socket>
}
    8000398c:	70a2                	ld	ra,40(sp)
    8000398e:	7402                	ld	s0,32(sp)
    80003990:	6145                	addi	sp,sp,48
    80003992:	8082                	ret

0000000080003994 <sys_connect>:

uint64 sys_connect(void *arg) {
    80003994:	7139                	addi	sp,sp,-64
    80003996:	fc06                	sd	ra,56(sp)
    80003998:	f822                	sd	s0,48(sp)
    8000399a:	f426                	sd	s1,40(sp)
    8000399c:	0080                	addi	s0,sp,64
  uint64 socket, address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    8000399e:	fd840593          	addi	a1,s0,-40
    800039a2:	4501                	li	a0,0
    800039a4:	00000097          	auipc	ra,0x0
    800039a8:	b2a080e7          	jalr	-1238(ra) # 800034ce <argaddr>
  argaddr(1, (uint64 *)&address);
    800039ac:	fc040493          	addi	s1,s0,-64
    800039b0:	85a6                	mv	a1,s1
    800039b2:	4505                	li	a0,1
    800039b4:	00000097          	auipc	ra,0x0
    800039b8:	b1a080e7          	jalr	-1254(ra) # 800034ce <argaddr>
  argaddr(2, &address_len);
    800039bc:	fd040593          	addi	a1,s0,-48
    800039c0:	4509                	li	a0,2
    800039c2:	00000097          	auipc	ra,0x0
    800039c6:	b0c080e7          	jalr	-1268(ra) # 800034ce <argaddr>
  return connect(socket, &address, address_len);
    800039ca:	fd042603          	lw	a2,-48(s0)
    800039ce:	85a6                	mv	a1,s1
    800039d0:	fd842503          	lw	a0,-40(s0)
    800039d4:	00004097          	auipc	ra,0x4
    800039d8:	266080e7          	jalr	614(ra) # 80007c3a <connect>
}
    800039dc:	70e2                	ld	ra,56(sp)
    800039de:	7442                	ld	s0,48(sp)
    800039e0:	74a2                	ld	s1,40(sp)
    800039e2:	6121                	addi	sp,sp,64
    800039e4:	8082                	ret

00000000800039e6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800039e6:	7179                	addi	sp,sp,-48
    800039e8:	f406                	sd	ra,40(sp)
    800039ea:	f022                	sd	s0,32(sp)
    800039ec:	ec26                	sd	s1,24(sp)
    800039ee:	e84a                	sd	s2,16(sp)
    800039f0:	e44e                	sd	s3,8(sp)
    800039f2:	e052                	sd	s4,0(sp)
    800039f4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800039f6:	00007597          	auipc	a1,0x7
    800039fa:	a8258593          	addi	a1,a1,-1406 # 8000a478 <etext+0x478>
    800039fe:	00061517          	auipc	a0,0x61
    80003a02:	b5a50513          	addi	a0,a0,-1190 # 80064558 <bcache>
    80003a06:	ffffd097          	auipc	ra,0xffffd
    80003a0a:	294080e7          	jalr	660(ra) # 80000c9a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003a0e:	00069797          	auipc	a5,0x69
    80003a12:	b4a78793          	addi	a5,a5,-1206 # 8006c558 <bcache+0x8000>
    80003a16:	00069717          	auipc	a4,0x69
    80003a1a:	daa70713          	addi	a4,a4,-598 # 8006c7c0 <bcache+0x8268>
    80003a1e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003a22:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003a26:	00061497          	auipc	s1,0x61
    80003a2a:	b4a48493          	addi	s1,s1,-1206 # 80064570 <bcache+0x18>
    b->next = bcache.head.next;
    80003a2e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003a30:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003a32:	00007a17          	auipc	s4,0x7
    80003a36:	a4ea0a13          	addi	s4,s4,-1458 # 8000a480 <etext+0x480>
    b->next = bcache.head.next;
    80003a3a:	2b893783          	ld	a5,696(s2)
    80003a3e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003a40:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003a44:	85d2                	mv	a1,s4
    80003a46:	01048513          	addi	a0,s1,16
    80003a4a:	00001097          	auipc	ra,0x1
    80003a4e:	4ec080e7          	jalr	1260(ra) # 80004f36 <initsleeplock>
    bcache.head.next->prev = b;
    80003a52:	2b893783          	ld	a5,696(s2)
    80003a56:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003a58:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003a5c:	45848493          	addi	s1,s1,1112
    80003a60:	fd349de3          	bne	s1,s3,80003a3a <binit+0x54>
  }
}
    80003a64:	70a2                	ld	ra,40(sp)
    80003a66:	7402                	ld	s0,32(sp)
    80003a68:	64e2                	ld	s1,24(sp)
    80003a6a:	6942                	ld	s2,16(sp)
    80003a6c:	69a2                	ld	s3,8(sp)
    80003a6e:	6a02                	ld	s4,0(sp)
    80003a70:	6145                	addi	sp,sp,48
    80003a72:	8082                	ret

0000000080003a74 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003a74:	7179                	addi	sp,sp,-48
    80003a76:	f406                	sd	ra,40(sp)
    80003a78:	f022                	sd	s0,32(sp)
    80003a7a:	ec26                	sd	s1,24(sp)
    80003a7c:	e84a                	sd	s2,16(sp)
    80003a7e:	e44e                	sd	s3,8(sp)
    80003a80:	1800                	addi	s0,sp,48
    80003a82:	892a                	mv	s2,a0
    80003a84:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003a86:	00061517          	auipc	a0,0x61
    80003a8a:	ad250513          	addi	a0,a0,-1326 # 80064558 <bcache>
    80003a8e:	ffffd097          	auipc	ra,0xffffd
    80003a92:	2a6080e7          	jalr	678(ra) # 80000d34 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003a96:	00069497          	auipc	s1,0x69
    80003a9a:	d7a4b483          	ld	s1,-646(s1) # 8006c810 <bcache+0x82b8>
    80003a9e:	00069797          	auipc	a5,0x69
    80003aa2:	d2278793          	addi	a5,a5,-734 # 8006c7c0 <bcache+0x8268>
    80003aa6:	02f48f63          	beq	s1,a5,80003ae4 <bread+0x70>
    80003aaa:	873e                	mv	a4,a5
    80003aac:	a021                	j	80003ab4 <bread+0x40>
    80003aae:	68a4                	ld	s1,80(s1)
    80003ab0:	02e48a63          	beq	s1,a4,80003ae4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003ab4:	449c                	lw	a5,8(s1)
    80003ab6:	ff279ce3          	bne	a5,s2,80003aae <bread+0x3a>
    80003aba:	44dc                	lw	a5,12(s1)
    80003abc:	ff3799e3          	bne	a5,s3,80003aae <bread+0x3a>
      b->refcnt++;
    80003ac0:	40bc                	lw	a5,64(s1)
    80003ac2:	2785                	addiw	a5,a5,1
    80003ac4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003ac6:	00061517          	auipc	a0,0x61
    80003aca:	a9250513          	addi	a0,a0,-1390 # 80064558 <bcache>
    80003ace:	ffffd097          	auipc	ra,0xffffd
    80003ad2:	316080e7          	jalr	790(ra) # 80000de4 <release>
      acquiresleep(&b->lock);
    80003ad6:	01048513          	addi	a0,s1,16
    80003ada:	00001097          	auipc	ra,0x1
    80003ade:	496080e7          	jalr	1174(ra) # 80004f70 <acquiresleep>
      return b;
    80003ae2:	a8b9                	j	80003b40 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003ae4:	00069497          	auipc	s1,0x69
    80003ae8:	d244b483          	ld	s1,-732(s1) # 8006c808 <bcache+0x82b0>
    80003aec:	00069797          	auipc	a5,0x69
    80003af0:	cd478793          	addi	a5,a5,-812 # 8006c7c0 <bcache+0x8268>
    80003af4:	00f48863          	beq	s1,a5,80003b04 <bread+0x90>
    80003af8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003afa:	40bc                	lw	a5,64(s1)
    80003afc:	cf81                	beqz	a5,80003b14 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003afe:	64a4                	ld	s1,72(s1)
    80003b00:	fee49de3          	bne	s1,a4,80003afa <bread+0x86>
  panic("bget: no buffers");
    80003b04:	00007517          	auipc	a0,0x7
    80003b08:	98450513          	addi	a0,a0,-1660 # 8000a488 <etext+0x488>
    80003b0c:	ffffd097          	auipc	ra,0xffffd
    80003b10:	a52080e7          	jalr	-1454(ra) # 8000055e <panic>
      b->dev = dev;
    80003b14:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003b18:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003b1c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003b20:	4785                	li	a5,1
    80003b22:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003b24:	00061517          	auipc	a0,0x61
    80003b28:	a3450513          	addi	a0,a0,-1484 # 80064558 <bcache>
    80003b2c:	ffffd097          	auipc	ra,0xffffd
    80003b30:	2b8080e7          	jalr	696(ra) # 80000de4 <release>
      acquiresleep(&b->lock);
    80003b34:	01048513          	addi	a0,s1,16
    80003b38:	00001097          	auipc	ra,0x1
    80003b3c:	438080e7          	jalr	1080(ra) # 80004f70 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003b40:	409c                	lw	a5,0(s1)
    80003b42:	cb89                	beqz	a5,80003b54 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003b44:	8526                	mv	a0,s1
    80003b46:	70a2                	ld	ra,40(sp)
    80003b48:	7402                	ld	s0,32(sp)
    80003b4a:	64e2                	ld	s1,24(sp)
    80003b4c:	6942                	ld	s2,16(sp)
    80003b4e:	69a2                	ld	s3,8(sp)
    80003b50:	6145                	addi	sp,sp,48
    80003b52:	8082                	ret
    virtio_disk_rw(b, 0);
    80003b54:	4581                	li	a1,0
    80003b56:	8526                	mv	a0,s1
    80003b58:	00003097          	auipc	ra,0x3
    80003b5c:	112080e7          	jalr	274(ra) # 80006c6a <virtio_disk_rw>
    b->valid = 1;
    80003b60:	4785                	li	a5,1
    80003b62:	c09c                	sw	a5,0(s1)
  return b;
    80003b64:	b7c5                	j	80003b44 <bread+0xd0>

0000000080003b66 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003b66:	1101                	addi	sp,sp,-32
    80003b68:	ec06                	sd	ra,24(sp)
    80003b6a:	e822                	sd	s0,16(sp)
    80003b6c:	e426                	sd	s1,8(sp)
    80003b6e:	1000                	addi	s0,sp,32
    80003b70:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003b72:	0541                	addi	a0,a0,16
    80003b74:	00001097          	auipc	ra,0x1
    80003b78:	496080e7          	jalr	1174(ra) # 8000500a <holdingsleep>
    80003b7c:	cd01                	beqz	a0,80003b94 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003b7e:	4585                	li	a1,1
    80003b80:	8526                	mv	a0,s1
    80003b82:	00003097          	auipc	ra,0x3
    80003b86:	0e8080e7          	jalr	232(ra) # 80006c6a <virtio_disk_rw>
}
    80003b8a:	60e2                	ld	ra,24(sp)
    80003b8c:	6442                	ld	s0,16(sp)
    80003b8e:	64a2                	ld	s1,8(sp)
    80003b90:	6105                	addi	sp,sp,32
    80003b92:	8082                	ret
    panic("bwrite");
    80003b94:	00007517          	auipc	a0,0x7
    80003b98:	90c50513          	addi	a0,a0,-1780 # 8000a4a0 <etext+0x4a0>
    80003b9c:	ffffd097          	auipc	ra,0xffffd
    80003ba0:	9c2080e7          	jalr	-1598(ra) # 8000055e <panic>

0000000080003ba4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003ba4:	1101                	addi	sp,sp,-32
    80003ba6:	ec06                	sd	ra,24(sp)
    80003ba8:	e822                	sd	s0,16(sp)
    80003baa:	e426                	sd	s1,8(sp)
    80003bac:	e04a                	sd	s2,0(sp)
    80003bae:	1000                	addi	s0,sp,32
    80003bb0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003bb2:	01050913          	addi	s2,a0,16
    80003bb6:	854a                	mv	a0,s2
    80003bb8:	00001097          	auipc	ra,0x1
    80003bbc:	452080e7          	jalr	1106(ra) # 8000500a <holdingsleep>
    80003bc0:	c535                	beqz	a0,80003c2c <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003bc2:	854a                	mv	a0,s2
    80003bc4:	00001097          	auipc	ra,0x1
    80003bc8:	402080e7          	jalr	1026(ra) # 80004fc6 <releasesleep>

  acquire(&bcache.lock);
    80003bcc:	00061517          	auipc	a0,0x61
    80003bd0:	98c50513          	addi	a0,a0,-1652 # 80064558 <bcache>
    80003bd4:	ffffd097          	auipc	ra,0xffffd
    80003bd8:	160080e7          	jalr	352(ra) # 80000d34 <acquire>
  b->refcnt--;
    80003bdc:	40bc                	lw	a5,64(s1)
    80003bde:	37fd                	addiw	a5,a5,-1
    80003be0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003be2:	e79d                	bnez	a5,80003c10 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003be4:	68b8                	ld	a4,80(s1)
    80003be6:	64bc                	ld	a5,72(s1)
    80003be8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003bea:	68b8                	ld	a4,80(s1)
    80003bec:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003bee:	00069797          	auipc	a5,0x69
    80003bf2:	96a78793          	addi	a5,a5,-1686 # 8006c558 <bcache+0x8000>
    80003bf6:	2b87b703          	ld	a4,696(a5)
    80003bfa:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003bfc:	00069717          	auipc	a4,0x69
    80003c00:	bc470713          	addi	a4,a4,-1084 # 8006c7c0 <bcache+0x8268>
    80003c04:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003c06:	2b87b703          	ld	a4,696(a5)
    80003c0a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003c0c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003c10:	00061517          	auipc	a0,0x61
    80003c14:	94850513          	addi	a0,a0,-1720 # 80064558 <bcache>
    80003c18:	ffffd097          	auipc	ra,0xffffd
    80003c1c:	1cc080e7          	jalr	460(ra) # 80000de4 <release>
}
    80003c20:	60e2                	ld	ra,24(sp)
    80003c22:	6442                	ld	s0,16(sp)
    80003c24:	64a2                	ld	s1,8(sp)
    80003c26:	6902                	ld	s2,0(sp)
    80003c28:	6105                	addi	sp,sp,32
    80003c2a:	8082                	ret
    panic("brelse");
    80003c2c:	00007517          	auipc	a0,0x7
    80003c30:	87c50513          	addi	a0,a0,-1924 # 8000a4a8 <etext+0x4a8>
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	92a080e7          	jalr	-1750(ra) # 8000055e <panic>

0000000080003c3c <bpin>:

void
bpin(struct buf *b) {
    80003c3c:	1101                	addi	sp,sp,-32
    80003c3e:	ec06                	sd	ra,24(sp)
    80003c40:	e822                	sd	s0,16(sp)
    80003c42:	e426                	sd	s1,8(sp)
    80003c44:	1000                	addi	s0,sp,32
    80003c46:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003c48:	00061517          	auipc	a0,0x61
    80003c4c:	91050513          	addi	a0,a0,-1776 # 80064558 <bcache>
    80003c50:	ffffd097          	auipc	ra,0xffffd
    80003c54:	0e4080e7          	jalr	228(ra) # 80000d34 <acquire>
  b->refcnt++;
    80003c58:	40bc                	lw	a5,64(s1)
    80003c5a:	2785                	addiw	a5,a5,1
    80003c5c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003c5e:	00061517          	auipc	a0,0x61
    80003c62:	8fa50513          	addi	a0,a0,-1798 # 80064558 <bcache>
    80003c66:	ffffd097          	auipc	ra,0xffffd
    80003c6a:	17e080e7          	jalr	382(ra) # 80000de4 <release>
}
    80003c6e:	60e2                	ld	ra,24(sp)
    80003c70:	6442                	ld	s0,16(sp)
    80003c72:	64a2                	ld	s1,8(sp)
    80003c74:	6105                	addi	sp,sp,32
    80003c76:	8082                	ret

0000000080003c78 <bunpin>:

void
bunpin(struct buf *b) {
    80003c78:	1101                	addi	sp,sp,-32
    80003c7a:	ec06                	sd	ra,24(sp)
    80003c7c:	e822                	sd	s0,16(sp)
    80003c7e:	e426                	sd	s1,8(sp)
    80003c80:	1000                	addi	s0,sp,32
    80003c82:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003c84:	00061517          	auipc	a0,0x61
    80003c88:	8d450513          	addi	a0,a0,-1836 # 80064558 <bcache>
    80003c8c:	ffffd097          	auipc	ra,0xffffd
    80003c90:	0a8080e7          	jalr	168(ra) # 80000d34 <acquire>
  b->refcnt--;
    80003c94:	40bc                	lw	a5,64(s1)
    80003c96:	37fd                	addiw	a5,a5,-1
    80003c98:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003c9a:	00061517          	auipc	a0,0x61
    80003c9e:	8be50513          	addi	a0,a0,-1858 # 80064558 <bcache>
    80003ca2:	ffffd097          	auipc	ra,0xffffd
    80003ca6:	142080e7          	jalr	322(ra) # 80000de4 <release>
}
    80003caa:	60e2                	ld	ra,24(sp)
    80003cac:	6442                	ld	s0,16(sp)
    80003cae:	64a2                	ld	s1,8(sp)
    80003cb0:	6105                	addi	sp,sp,32
    80003cb2:	8082                	ret

0000000080003cb4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003cb4:	1101                	addi	sp,sp,-32
    80003cb6:	ec06                	sd	ra,24(sp)
    80003cb8:	e822                	sd	s0,16(sp)
    80003cba:	e426                	sd	s1,8(sp)
    80003cbc:	e04a                	sd	s2,0(sp)
    80003cbe:	1000                	addi	s0,sp,32
    80003cc0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003cc2:	00d5d79b          	srliw	a5,a1,0xd
    80003cc6:	00069597          	auipc	a1,0x69
    80003cca:	f6e5a583          	lw	a1,-146(a1) # 8006cc34 <sb+0x1c>
    80003cce:	9dbd                	addw	a1,a1,a5
    80003cd0:	00000097          	auipc	ra,0x0
    80003cd4:	da4080e7          	jalr	-604(ra) # 80003a74 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003cd8:	0074f713          	andi	a4,s1,7
    80003cdc:	4785                	li	a5,1
    80003cde:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003ce2:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003ce4:	90d9                	srli	s1,s1,0x36
    80003ce6:	00950733          	add	a4,a0,s1
    80003cea:	05874703          	lbu	a4,88(a4)
    80003cee:	00e7f6b3          	and	a3,a5,a4
    80003cf2:	c69d                	beqz	a3,80003d20 <bfree+0x6c>
    80003cf4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003cf6:	94aa                	add	s1,s1,a0
    80003cf8:	fff7c793          	not	a5,a5
    80003cfc:	8f7d                	and	a4,a4,a5
    80003cfe:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003d02:	00001097          	auipc	ra,0x1
    80003d06:	14e080e7          	jalr	334(ra) # 80004e50 <log_write>
  brelse(bp);
    80003d0a:	854a                	mv	a0,s2
    80003d0c:	00000097          	auipc	ra,0x0
    80003d10:	e98080e7          	jalr	-360(ra) # 80003ba4 <brelse>
}
    80003d14:	60e2                	ld	ra,24(sp)
    80003d16:	6442                	ld	s0,16(sp)
    80003d18:	64a2                	ld	s1,8(sp)
    80003d1a:	6902                	ld	s2,0(sp)
    80003d1c:	6105                	addi	sp,sp,32
    80003d1e:	8082                	ret
    panic("freeing free block");
    80003d20:	00006517          	auipc	a0,0x6
    80003d24:	79050513          	addi	a0,a0,1936 # 8000a4b0 <etext+0x4b0>
    80003d28:	ffffd097          	auipc	ra,0xffffd
    80003d2c:	836080e7          	jalr	-1994(ra) # 8000055e <panic>

0000000080003d30 <balloc>:
{
    80003d30:	715d                	addi	sp,sp,-80
    80003d32:	e486                	sd	ra,72(sp)
    80003d34:	e0a2                	sd	s0,64(sp)
    80003d36:	fc26                	sd	s1,56(sp)
    80003d38:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003d3a:	00069797          	auipc	a5,0x69
    80003d3e:	ee27a783          	lw	a5,-286(a5) # 8006cc1c <sb+0x4>
    80003d42:	10078263          	beqz	a5,80003e46 <balloc+0x116>
    80003d46:	f84a                	sd	s2,48(sp)
    80003d48:	f44e                	sd	s3,40(sp)
    80003d4a:	f052                	sd	s4,32(sp)
    80003d4c:	ec56                	sd	s5,24(sp)
    80003d4e:	e85a                	sd	s6,16(sp)
    80003d50:	e45e                	sd	s7,8(sp)
    80003d52:	e062                	sd	s8,0(sp)
    80003d54:	8baa                	mv	s7,a0
    80003d56:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003d58:	00069b17          	auipc	s6,0x69
    80003d5c:	ec0b0b13          	addi	s6,s6,-320 # 8006cc18 <sb>
      m = 1 << (bi % 8);
    80003d60:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003d62:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003d64:	6c09                	lui	s8,0x2
    80003d66:	a049                	j	80003de8 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003d68:	97ca                	add	a5,a5,s2
    80003d6a:	8e55                	or	a2,a2,a3
    80003d6c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003d70:	854a                	mv	a0,s2
    80003d72:	00001097          	auipc	ra,0x1
    80003d76:	0de080e7          	jalr	222(ra) # 80004e50 <log_write>
        brelse(bp);
    80003d7a:	854a                	mv	a0,s2
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	e28080e7          	jalr	-472(ra) # 80003ba4 <brelse>
  bp = bread(dev, bno);
    80003d84:	85a6                	mv	a1,s1
    80003d86:	855e                	mv	a0,s7
    80003d88:	00000097          	auipc	ra,0x0
    80003d8c:	cec080e7          	jalr	-788(ra) # 80003a74 <bread>
    80003d90:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003d92:	40000613          	li	a2,1024
    80003d96:	4581                	li	a1,0
    80003d98:	05850513          	addi	a0,a0,88
    80003d9c:	ffffd097          	auipc	ra,0xffffd
    80003da0:	090080e7          	jalr	144(ra) # 80000e2c <memset>
  log_write(bp);
    80003da4:	854a                	mv	a0,s2
    80003da6:	00001097          	auipc	ra,0x1
    80003daa:	0aa080e7          	jalr	170(ra) # 80004e50 <log_write>
  brelse(bp);
    80003dae:	854a                	mv	a0,s2
    80003db0:	00000097          	auipc	ra,0x0
    80003db4:	df4080e7          	jalr	-524(ra) # 80003ba4 <brelse>
}
    80003db8:	7942                	ld	s2,48(sp)
    80003dba:	79a2                	ld	s3,40(sp)
    80003dbc:	7a02                	ld	s4,32(sp)
    80003dbe:	6ae2                	ld	s5,24(sp)
    80003dc0:	6b42                	ld	s6,16(sp)
    80003dc2:	6ba2                	ld	s7,8(sp)
    80003dc4:	6c02                	ld	s8,0(sp)
}
    80003dc6:	8526                	mv	a0,s1
    80003dc8:	60a6                	ld	ra,72(sp)
    80003dca:	6406                	ld	s0,64(sp)
    80003dcc:	74e2                	ld	s1,56(sp)
    80003dce:	6161                	addi	sp,sp,80
    80003dd0:	8082                	ret
    brelse(bp);
    80003dd2:	854a                	mv	a0,s2
    80003dd4:	00000097          	auipc	ra,0x0
    80003dd8:	dd0080e7          	jalr	-560(ra) # 80003ba4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003ddc:	015c0abb          	addw	s5,s8,s5
    80003de0:	004b2783          	lw	a5,4(s6)
    80003de4:	04fafa63          	bgeu	s5,a5,80003e38 <balloc+0x108>
    bp = bread(dev, BBLOCK(b, sb));
    80003de8:	40dad59b          	sraiw	a1,s5,0xd
    80003dec:	01cb2783          	lw	a5,28(s6)
    80003df0:	9dbd                	addw	a1,a1,a5
    80003df2:	855e                	mv	a0,s7
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	c80080e7          	jalr	-896(ra) # 80003a74 <bread>
    80003dfc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003dfe:	004b2503          	lw	a0,4(s6)
    80003e02:	84d6                	mv	s1,s5
    80003e04:	4701                	li	a4,0
    80003e06:	fca4f6e3          	bgeu	s1,a0,80003dd2 <balloc+0xa2>
      m = 1 << (bi % 8);
    80003e0a:	00777693          	andi	a3,a4,7
    80003e0e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003e12:	41f7579b          	sraiw	a5,a4,0x1f
    80003e16:	01d7d79b          	srliw	a5,a5,0x1d
    80003e1a:	9fb9                	addw	a5,a5,a4
    80003e1c:	4037d79b          	sraiw	a5,a5,0x3
    80003e20:	00f90633          	add	a2,s2,a5
    80003e24:	05864603          	lbu	a2,88(a2)
    80003e28:	00c6f5b3          	and	a1,a3,a2
    80003e2c:	dd95                	beqz	a1,80003d68 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003e2e:	2705                	addiw	a4,a4,1
    80003e30:	2485                	addiw	s1,s1,1
    80003e32:	fd471ae3          	bne	a4,s4,80003e06 <balloc+0xd6>
    80003e36:	bf71                	j	80003dd2 <balloc+0xa2>
    80003e38:	7942                	ld	s2,48(sp)
    80003e3a:	79a2                	ld	s3,40(sp)
    80003e3c:	7a02                	ld	s4,32(sp)
    80003e3e:	6ae2                	ld	s5,24(sp)
    80003e40:	6b42                	ld	s6,16(sp)
    80003e42:	6ba2                	ld	s7,8(sp)
    80003e44:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003e46:	00006517          	auipc	a0,0x6
    80003e4a:	68250513          	addi	a0,a0,1666 # 8000a4c8 <etext+0x4c8>
    80003e4e:	ffffc097          	auipc	ra,0xffffc
    80003e52:	75a080e7          	jalr	1882(ra) # 800005a8 <printf>
  return 0;
    80003e56:	4481                	li	s1,0
    80003e58:	b7bd                	j	80003dc6 <balloc+0x96>

0000000080003e5a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003e5a:	7179                	addi	sp,sp,-48
    80003e5c:	f406                	sd	ra,40(sp)
    80003e5e:	f022                	sd	s0,32(sp)
    80003e60:	ec26                	sd	s1,24(sp)
    80003e62:	e84a                	sd	s2,16(sp)
    80003e64:	e44e                	sd	s3,8(sp)
    80003e66:	1800                	addi	s0,sp,48
    80003e68:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003e6a:	47ad                	li	a5,11
    80003e6c:	02b7e563          	bltu	a5,a1,80003e96 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003e70:	02059793          	slli	a5,a1,0x20
    80003e74:	01e7d593          	srli	a1,a5,0x1e
    80003e78:	00b509b3          	add	s3,a0,a1
    80003e7c:	0509a483          	lw	s1,80(s3)
    80003e80:	e8b5                	bnez	s1,80003ef4 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003e82:	4108                	lw	a0,0(a0)
    80003e84:	00000097          	auipc	ra,0x0
    80003e88:	eac080e7          	jalr	-340(ra) # 80003d30 <balloc>
    80003e8c:	84aa                	mv	s1,a0
      if(addr == 0)
    80003e8e:	c13d                	beqz	a0,80003ef4 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003e90:	04a9a823          	sw	a0,80(s3)
    80003e94:	a085                	j	80003ef4 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003e96:	ff45879b          	addiw	a5,a1,-12
    80003e9a:	873e                	mv	a4,a5
    80003e9c:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80003e9e:	0ff00793          	li	a5,255
    80003ea2:	08e7e163          	bltu	a5,a4,80003f24 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003ea6:	08052483          	lw	s1,128(a0)
    80003eaa:	ec81                	bnez	s1,80003ec2 <bmap+0x68>
      addr = balloc(ip->dev);
    80003eac:	4108                	lw	a0,0(a0)
    80003eae:	00000097          	auipc	ra,0x0
    80003eb2:	e82080e7          	jalr	-382(ra) # 80003d30 <balloc>
    80003eb6:	84aa                	mv	s1,a0
      if(addr == 0)
    80003eb8:	cd15                	beqz	a0,80003ef4 <bmap+0x9a>
    80003eba:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003ebc:	08a92023          	sw	a0,128(s2)
    80003ec0:	a011                	j	80003ec4 <bmap+0x6a>
    80003ec2:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003ec4:	85a6                	mv	a1,s1
    80003ec6:	00092503          	lw	a0,0(s2)
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	baa080e7          	jalr	-1110(ra) # 80003a74 <bread>
    80003ed2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003ed4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003ed8:	02099713          	slli	a4,s3,0x20
    80003edc:	01e75593          	srli	a1,a4,0x1e
    80003ee0:	97ae                	add	a5,a5,a1
    80003ee2:	89be                	mv	s3,a5
    80003ee4:	4384                	lw	s1,0(a5)
    80003ee6:	cc99                	beqz	s1,80003f04 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003ee8:	8552                	mv	a0,s4
    80003eea:	00000097          	auipc	ra,0x0
    80003eee:	cba080e7          	jalr	-838(ra) # 80003ba4 <brelse>
    return addr;
    80003ef2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003ef4:	8526                	mv	a0,s1
    80003ef6:	70a2                	ld	ra,40(sp)
    80003ef8:	7402                	ld	s0,32(sp)
    80003efa:	64e2                	ld	s1,24(sp)
    80003efc:	6942                	ld	s2,16(sp)
    80003efe:	69a2                	ld	s3,8(sp)
    80003f00:	6145                	addi	sp,sp,48
    80003f02:	8082                	ret
      addr = balloc(ip->dev);
    80003f04:	00092503          	lw	a0,0(s2)
    80003f08:	00000097          	auipc	ra,0x0
    80003f0c:	e28080e7          	jalr	-472(ra) # 80003d30 <balloc>
    80003f10:	84aa                	mv	s1,a0
      if(addr){
    80003f12:	d979                	beqz	a0,80003ee8 <bmap+0x8e>
        a[bn] = addr;
    80003f14:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003f18:	8552                	mv	a0,s4
    80003f1a:	00001097          	auipc	ra,0x1
    80003f1e:	f36080e7          	jalr	-202(ra) # 80004e50 <log_write>
    80003f22:	b7d9                	j	80003ee8 <bmap+0x8e>
    80003f24:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003f26:	00006517          	auipc	a0,0x6
    80003f2a:	5ba50513          	addi	a0,a0,1466 # 8000a4e0 <etext+0x4e0>
    80003f2e:	ffffc097          	auipc	ra,0xffffc
    80003f32:	630080e7          	jalr	1584(ra) # 8000055e <panic>

0000000080003f36 <iget>:
{
    80003f36:	7179                	addi	sp,sp,-48
    80003f38:	f406                	sd	ra,40(sp)
    80003f3a:	f022                	sd	s0,32(sp)
    80003f3c:	ec26                	sd	s1,24(sp)
    80003f3e:	e84a                	sd	s2,16(sp)
    80003f40:	e44e                	sd	s3,8(sp)
    80003f42:	e052                	sd	s4,0(sp)
    80003f44:	1800                	addi	s0,sp,48
    80003f46:	892a                	mv	s2,a0
    80003f48:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003f4a:	00069517          	auipc	a0,0x69
    80003f4e:	cee50513          	addi	a0,a0,-786 # 8006cc38 <itable>
    80003f52:	ffffd097          	auipc	ra,0xffffd
    80003f56:	de2080e7          	jalr	-542(ra) # 80000d34 <acquire>
  empty = 0;
    80003f5a:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003f5c:	00069497          	auipc	s1,0x69
    80003f60:	cf448493          	addi	s1,s1,-780 # 8006cc50 <itable+0x18>
    80003f64:	0006a697          	auipc	a3,0x6a
    80003f68:	77c68693          	addi	a3,a3,1916 # 8006e6e0 <log>
    80003f6c:	a809                	j	80003f7e <iget+0x48>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003f6e:	e781                	bnez	a5,80003f76 <iget+0x40>
    80003f70:	00099363          	bnez	s3,80003f76 <iget+0x40>
      empty = ip;
    80003f74:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003f76:	08848493          	addi	s1,s1,136
    80003f7a:	02d48763          	beq	s1,a3,80003fa8 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003f7e:	449c                	lw	a5,8(s1)
    80003f80:	fef057e3          	blez	a5,80003f6e <iget+0x38>
    80003f84:	4098                	lw	a4,0(s1)
    80003f86:	ff2718e3          	bne	a4,s2,80003f76 <iget+0x40>
    80003f8a:	40d8                	lw	a4,4(s1)
    80003f8c:	ff4715e3          	bne	a4,s4,80003f76 <iget+0x40>
      ip->ref++;
    80003f90:	2785                	addiw	a5,a5,1
    80003f92:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003f94:	00069517          	auipc	a0,0x69
    80003f98:	ca450513          	addi	a0,a0,-860 # 8006cc38 <itable>
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	e48080e7          	jalr	-440(ra) # 80000de4 <release>
      return ip;
    80003fa4:	89a6                	mv	s3,s1
    80003fa6:	a025                	j	80003fce <iget+0x98>
  if(empty == 0)
    80003fa8:	02098c63          	beqz	s3,80003fe0 <iget+0xaa>
  ip->dev = dev;
    80003fac:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003fb0:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003fb4:	4785                	li	a5,1
    80003fb6:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003fba:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003fbe:	00069517          	auipc	a0,0x69
    80003fc2:	c7a50513          	addi	a0,a0,-902 # 8006cc38 <itable>
    80003fc6:	ffffd097          	auipc	ra,0xffffd
    80003fca:	e1e080e7          	jalr	-482(ra) # 80000de4 <release>
}
    80003fce:	854e                	mv	a0,s3
    80003fd0:	70a2                	ld	ra,40(sp)
    80003fd2:	7402                	ld	s0,32(sp)
    80003fd4:	64e2                	ld	s1,24(sp)
    80003fd6:	6942                	ld	s2,16(sp)
    80003fd8:	69a2                	ld	s3,8(sp)
    80003fda:	6a02                	ld	s4,0(sp)
    80003fdc:	6145                	addi	sp,sp,48
    80003fde:	8082                	ret
    panic("iget: no inodes");
    80003fe0:	00006517          	auipc	a0,0x6
    80003fe4:	51850513          	addi	a0,a0,1304 # 8000a4f8 <etext+0x4f8>
    80003fe8:	ffffc097          	auipc	ra,0xffffc
    80003fec:	576080e7          	jalr	1398(ra) # 8000055e <panic>

0000000080003ff0 <fsinit>:
fsinit(int dev) {
    80003ff0:	1101                	addi	sp,sp,-32
    80003ff2:	ec06                	sd	ra,24(sp)
    80003ff4:	e822                	sd	s0,16(sp)
    80003ff6:	e426                	sd	s1,8(sp)
    80003ff8:	e04a                	sd	s2,0(sp)
    80003ffa:	1000                	addi	s0,sp,32
    80003ffc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003ffe:	4585                	li	a1,1
    80004000:	00000097          	auipc	ra,0x0
    80004004:	a74080e7          	jalr	-1420(ra) # 80003a74 <bread>
    80004008:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000400a:	02000613          	li	a2,32
    8000400e:	05850593          	addi	a1,a0,88
    80004012:	00069517          	auipc	a0,0x69
    80004016:	c0650513          	addi	a0,a0,-1018 # 8006cc18 <sb>
    8000401a:	ffffd097          	auipc	ra,0xffffd
    8000401e:	e72080e7          	jalr	-398(ra) # 80000e8c <memmove>
  brelse(bp);
    80004022:	8526                	mv	a0,s1
    80004024:	00000097          	auipc	ra,0x0
    80004028:	b80080e7          	jalr	-1152(ra) # 80003ba4 <brelse>
  if(sb.magic != FSMAGIC)
    8000402c:	00069717          	auipc	a4,0x69
    80004030:	bec72703          	lw	a4,-1044(a4) # 8006cc18 <sb>
    80004034:	102037b7          	lui	a5,0x10203
    80004038:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000403c:	02f71163          	bne	a4,a5,8000405e <fsinit+0x6e>
  initlog(dev, &sb);
    80004040:	00069597          	auipc	a1,0x69
    80004044:	bd858593          	addi	a1,a1,-1064 # 8006cc18 <sb>
    80004048:	854a                	mv	a0,s2
    8000404a:	00001097          	auipc	ra,0x1
    8000404e:	b80080e7          	jalr	-1152(ra) # 80004bca <initlog>
}
    80004052:	60e2                	ld	ra,24(sp)
    80004054:	6442                	ld	s0,16(sp)
    80004056:	64a2                	ld	s1,8(sp)
    80004058:	6902                	ld	s2,0(sp)
    8000405a:	6105                	addi	sp,sp,32
    8000405c:	8082                	ret
    panic("invalid file system");
    8000405e:	00006517          	auipc	a0,0x6
    80004062:	4aa50513          	addi	a0,a0,1194 # 8000a508 <etext+0x508>
    80004066:	ffffc097          	auipc	ra,0xffffc
    8000406a:	4f8080e7          	jalr	1272(ra) # 8000055e <panic>

000000008000406e <iinit>:
{
    8000406e:	7179                	addi	sp,sp,-48
    80004070:	f406                	sd	ra,40(sp)
    80004072:	f022                	sd	s0,32(sp)
    80004074:	ec26                	sd	s1,24(sp)
    80004076:	e84a                	sd	s2,16(sp)
    80004078:	e44e                	sd	s3,8(sp)
    8000407a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000407c:	00006597          	auipc	a1,0x6
    80004080:	4a458593          	addi	a1,a1,1188 # 8000a520 <etext+0x520>
    80004084:	00069517          	auipc	a0,0x69
    80004088:	bb450513          	addi	a0,a0,-1100 # 8006cc38 <itable>
    8000408c:	ffffd097          	auipc	ra,0xffffd
    80004090:	c0e080e7          	jalr	-1010(ra) # 80000c9a <initlock>
  for(i = 0; i < NINODE; i++) {
    80004094:	00069497          	auipc	s1,0x69
    80004098:	bcc48493          	addi	s1,s1,-1076 # 8006cc60 <itable+0x28>
    8000409c:	0006a997          	auipc	s3,0x6a
    800040a0:	65498993          	addi	s3,s3,1620 # 8006e6f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800040a4:	00006917          	auipc	s2,0x6
    800040a8:	48490913          	addi	s2,s2,1156 # 8000a528 <etext+0x528>
    800040ac:	85ca                	mv	a1,s2
    800040ae:	8526                	mv	a0,s1
    800040b0:	00001097          	auipc	ra,0x1
    800040b4:	e86080e7          	jalr	-378(ra) # 80004f36 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800040b8:	08848493          	addi	s1,s1,136
    800040bc:	ff3498e3          	bne	s1,s3,800040ac <iinit+0x3e>
}
    800040c0:	70a2                	ld	ra,40(sp)
    800040c2:	7402                	ld	s0,32(sp)
    800040c4:	64e2                	ld	s1,24(sp)
    800040c6:	6942                	ld	s2,16(sp)
    800040c8:	69a2                	ld	s3,8(sp)
    800040ca:	6145                	addi	sp,sp,48
    800040cc:	8082                	ret

00000000800040ce <ialloc>:
{
    800040ce:	7139                	addi	sp,sp,-64
    800040d0:	fc06                	sd	ra,56(sp)
    800040d2:	f822                	sd	s0,48(sp)
    800040d4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800040d6:	00069717          	auipc	a4,0x69
    800040da:	b4e72703          	lw	a4,-1202(a4) # 8006cc24 <sb+0xc>
    800040de:	4785                	li	a5,1
    800040e0:	06e7f463          	bgeu	a5,a4,80004148 <ialloc+0x7a>
    800040e4:	f426                	sd	s1,40(sp)
    800040e6:	f04a                	sd	s2,32(sp)
    800040e8:	ec4e                	sd	s3,24(sp)
    800040ea:	e852                	sd	s4,16(sp)
    800040ec:	e456                	sd	s5,8(sp)
    800040ee:	e05a                	sd	s6,0(sp)
    800040f0:	8aaa                	mv	s5,a0
    800040f2:	8b2e                	mv	s6,a1
    800040f4:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800040f6:	00069a17          	auipc	s4,0x69
    800040fa:	b22a0a13          	addi	s4,s4,-1246 # 8006cc18 <sb>
    800040fe:	00495593          	srli	a1,s2,0x4
    80004102:	018a2783          	lw	a5,24(s4)
    80004106:	9dbd                	addw	a1,a1,a5
    80004108:	8556                	mv	a0,s5
    8000410a:	00000097          	auipc	ra,0x0
    8000410e:	96a080e7          	jalr	-1686(ra) # 80003a74 <bread>
    80004112:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80004114:	05850993          	addi	s3,a0,88
    80004118:	00f97793          	andi	a5,s2,15
    8000411c:	079a                	slli	a5,a5,0x6
    8000411e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80004120:	00099783          	lh	a5,0(s3)
    80004124:	cf9d                	beqz	a5,80004162 <ialloc+0x94>
    brelse(bp);
    80004126:	00000097          	auipc	ra,0x0
    8000412a:	a7e080e7          	jalr	-1410(ra) # 80003ba4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000412e:	0905                	addi	s2,s2,1
    80004130:	00ca2703          	lw	a4,12(s4)
    80004134:	0009079b          	sext.w	a5,s2
    80004138:	fce7e3e3          	bltu	a5,a4,800040fe <ialloc+0x30>
    8000413c:	74a2                	ld	s1,40(sp)
    8000413e:	7902                	ld	s2,32(sp)
    80004140:	69e2                	ld	s3,24(sp)
    80004142:	6a42                	ld	s4,16(sp)
    80004144:	6aa2                	ld	s5,8(sp)
    80004146:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80004148:	00006517          	auipc	a0,0x6
    8000414c:	3e850513          	addi	a0,a0,1000 # 8000a530 <etext+0x530>
    80004150:	ffffc097          	auipc	ra,0xffffc
    80004154:	458080e7          	jalr	1112(ra) # 800005a8 <printf>
  return 0;
    80004158:	4501                	li	a0,0
}
    8000415a:	70e2                	ld	ra,56(sp)
    8000415c:	7442                	ld	s0,48(sp)
    8000415e:	6121                	addi	sp,sp,64
    80004160:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80004162:	04000613          	li	a2,64
    80004166:	4581                	li	a1,0
    80004168:	854e                	mv	a0,s3
    8000416a:	ffffd097          	auipc	ra,0xffffd
    8000416e:	cc2080e7          	jalr	-830(ra) # 80000e2c <memset>
      dip->type = type;
    80004172:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80004176:	8526                	mv	a0,s1
    80004178:	00001097          	auipc	ra,0x1
    8000417c:	cd8080e7          	jalr	-808(ra) # 80004e50 <log_write>
      brelse(bp);
    80004180:	8526                	mv	a0,s1
    80004182:	00000097          	auipc	ra,0x0
    80004186:	a22080e7          	jalr	-1502(ra) # 80003ba4 <brelse>
      return iget(dev, inum);
    8000418a:	0009059b          	sext.w	a1,s2
    8000418e:	8556                	mv	a0,s5
    80004190:	00000097          	auipc	ra,0x0
    80004194:	da6080e7          	jalr	-602(ra) # 80003f36 <iget>
    80004198:	74a2                	ld	s1,40(sp)
    8000419a:	7902                	ld	s2,32(sp)
    8000419c:	69e2                	ld	s3,24(sp)
    8000419e:	6a42                	ld	s4,16(sp)
    800041a0:	6aa2                	ld	s5,8(sp)
    800041a2:	6b02                	ld	s6,0(sp)
    800041a4:	bf5d                	j	8000415a <ialloc+0x8c>

00000000800041a6 <iupdate>:
{
    800041a6:	1101                	addi	sp,sp,-32
    800041a8:	ec06                	sd	ra,24(sp)
    800041aa:	e822                	sd	s0,16(sp)
    800041ac:	e426                	sd	s1,8(sp)
    800041ae:	e04a                	sd	s2,0(sp)
    800041b0:	1000                	addi	s0,sp,32
    800041b2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800041b4:	415c                	lw	a5,4(a0)
    800041b6:	0047d79b          	srliw	a5,a5,0x4
    800041ba:	00069597          	auipc	a1,0x69
    800041be:	a765a583          	lw	a1,-1418(a1) # 8006cc30 <sb+0x18>
    800041c2:	9dbd                	addw	a1,a1,a5
    800041c4:	4108                	lw	a0,0(a0)
    800041c6:	00000097          	auipc	ra,0x0
    800041ca:	8ae080e7          	jalr	-1874(ra) # 80003a74 <bread>
    800041ce:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800041d0:	05850793          	addi	a5,a0,88
    800041d4:	40d8                	lw	a4,4(s1)
    800041d6:	8b3d                	andi	a4,a4,15
    800041d8:	071a                	slli	a4,a4,0x6
    800041da:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800041dc:	04449703          	lh	a4,68(s1)
    800041e0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800041e4:	04649703          	lh	a4,70(s1)
    800041e8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800041ec:	04849703          	lh	a4,72(s1)
    800041f0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800041f4:	04a49703          	lh	a4,74(s1)
    800041f8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800041fc:	44f8                	lw	a4,76(s1)
    800041fe:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004200:	03400613          	li	a2,52
    80004204:	05048593          	addi	a1,s1,80
    80004208:	00c78513          	addi	a0,a5,12
    8000420c:	ffffd097          	auipc	ra,0xffffd
    80004210:	c80080e7          	jalr	-896(ra) # 80000e8c <memmove>
  log_write(bp);
    80004214:	854a                	mv	a0,s2
    80004216:	00001097          	auipc	ra,0x1
    8000421a:	c3a080e7          	jalr	-966(ra) # 80004e50 <log_write>
  brelse(bp);
    8000421e:	854a                	mv	a0,s2
    80004220:	00000097          	auipc	ra,0x0
    80004224:	984080e7          	jalr	-1660(ra) # 80003ba4 <brelse>
}
    80004228:	60e2                	ld	ra,24(sp)
    8000422a:	6442                	ld	s0,16(sp)
    8000422c:	64a2                	ld	s1,8(sp)
    8000422e:	6902                	ld	s2,0(sp)
    80004230:	6105                	addi	sp,sp,32
    80004232:	8082                	ret

0000000080004234 <idup>:
{
    80004234:	1101                	addi	sp,sp,-32
    80004236:	ec06                	sd	ra,24(sp)
    80004238:	e822                	sd	s0,16(sp)
    8000423a:	e426                	sd	s1,8(sp)
    8000423c:	1000                	addi	s0,sp,32
    8000423e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004240:	00069517          	auipc	a0,0x69
    80004244:	9f850513          	addi	a0,a0,-1544 # 8006cc38 <itable>
    80004248:	ffffd097          	auipc	ra,0xffffd
    8000424c:	aec080e7          	jalr	-1300(ra) # 80000d34 <acquire>
  ip->ref++;
    80004250:	449c                	lw	a5,8(s1)
    80004252:	2785                	addiw	a5,a5,1
    80004254:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004256:	00069517          	auipc	a0,0x69
    8000425a:	9e250513          	addi	a0,a0,-1566 # 8006cc38 <itable>
    8000425e:	ffffd097          	auipc	ra,0xffffd
    80004262:	b86080e7          	jalr	-1146(ra) # 80000de4 <release>
}
    80004266:	8526                	mv	a0,s1
    80004268:	60e2                	ld	ra,24(sp)
    8000426a:	6442                	ld	s0,16(sp)
    8000426c:	64a2                	ld	s1,8(sp)
    8000426e:	6105                	addi	sp,sp,32
    80004270:	8082                	ret

0000000080004272 <ilock>:
{
    80004272:	1101                	addi	sp,sp,-32
    80004274:	ec06                	sd	ra,24(sp)
    80004276:	e822                	sd	s0,16(sp)
    80004278:	e426                	sd	s1,8(sp)
    8000427a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000427c:	c10d                	beqz	a0,8000429e <ilock+0x2c>
    8000427e:	84aa                	mv	s1,a0
    80004280:	451c                	lw	a5,8(a0)
    80004282:	00f05e63          	blez	a5,8000429e <ilock+0x2c>
  acquiresleep(&ip->lock);
    80004286:	0541                	addi	a0,a0,16
    80004288:	00001097          	auipc	ra,0x1
    8000428c:	ce8080e7          	jalr	-792(ra) # 80004f70 <acquiresleep>
  if(ip->valid == 0){
    80004290:	40bc                	lw	a5,64(s1)
    80004292:	cf99                	beqz	a5,800042b0 <ilock+0x3e>
}
    80004294:	60e2                	ld	ra,24(sp)
    80004296:	6442                	ld	s0,16(sp)
    80004298:	64a2                	ld	s1,8(sp)
    8000429a:	6105                	addi	sp,sp,32
    8000429c:	8082                	ret
    8000429e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800042a0:	00006517          	auipc	a0,0x6
    800042a4:	2a850513          	addi	a0,a0,680 # 8000a548 <etext+0x548>
    800042a8:	ffffc097          	auipc	ra,0xffffc
    800042ac:	2b6080e7          	jalr	694(ra) # 8000055e <panic>
    800042b0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800042b2:	40dc                	lw	a5,4(s1)
    800042b4:	0047d79b          	srliw	a5,a5,0x4
    800042b8:	00069597          	auipc	a1,0x69
    800042bc:	9785a583          	lw	a1,-1672(a1) # 8006cc30 <sb+0x18>
    800042c0:	9dbd                	addw	a1,a1,a5
    800042c2:	4088                	lw	a0,0(s1)
    800042c4:	fffff097          	auipc	ra,0xfffff
    800042c8:	7b0080e7          	jalr	1968(ra) # 80003a74 <bread>
    800042cc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800042ce:	05850593          	addi	a1,a0,88
    800042d2:	40dc                	lw	a5,4(s1)
    800042d4:	8bbd                	andi	a5,a5,15
    800042d6:	079a                	slli	a5,a5,0x6
    800042d8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800042da:	00059783          	lh	a5,0(a1)
    800042de:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800042e2:	00259783          	lh	a5,2(a1)
    800042e6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800042ea:	00459783          	lh	a5,4(a1)
    800042ee:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800042f2:	00659783          	lh	a5,6(a1)
    800042f6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800042fa:	459c                	lw	a5,8(a1)
    800042fc:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800042fe:	03400613          	li	a2,52
    80004302:	05b1                	addi	a1,a1,12
    80004304:	05048513          	addi	a0,s1,80
    80004308:	ffffd097          	auipc	ra,0xffffd
    8000430c:	b84080e7          	jalr	-1148(ra) # 80000e8c <memmove>
    brelse(bp);
    80004310:	854a                	mv	a0,s2
    80004312:	00000097          	auipc	ra,0x0
    80004316:	892080e7          	jalr	-1902(ra) # 80003ba4 <brelse>
    ip->valid = 1;
    8000431a:	4785                	li	a5,1
    8000431c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000431e:	04449783          	lh	a5,68(s1)
    80004322:	c399                	beqz	a5,80004328 <ilock+0xb6>
    80004324:	6902                	ld	s2,0(sp)
    80004326:	b7bd                	j	80004294 <ilock+0x22>
      panic("ilock: no type");
    80004328:	00006517          	auipc	a0,0x6
    8000432c:	22850513          	addi	a0,a0,552 # 8000a550 <etext+0x550>
    80004330:	ffffc097          	auipc	ra,0xffffc
    80004334:	22e080e7          	jalr	558(ra) # 8000055e <panic>

0000000080004338 <iunlock>:
{
    80004338:	1101                	addi	sp,sp,-32
    8000433a:	ec06                	sd	ra,24(sp)
    8000433c:	e822                	sd	s0,16(sp)
    8000433e:	e426                	sd	s1,8(sp)
    80004340:	e04a                	sd	s2,0(sp)
    80004342:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004344:	c905                	beqz	a0,80004374 <iunlock+0x3c>
    80004346:	84aa                	mv	s1,a0
    80004348:	01050913          	addi	s2,a0,16
    8000434c:	854a                	mv	a0,s2
    8000434e:	00001097          	auipc	ra,0x1
    80004352:	cbc080e7          	jalr	-836(ra) # 8000500a <holdingsleep>
    80004356:	cd19                	beqz	a0,80004374 <iunlock+0x3c>
    80004358:	449c                	lw	a5,8(s1)
    8000435a:	00f05d63          	blez	a5,80004374 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000435e:	854a                	mv	a0,s2
    80004360:	00001097          	auipc	ra,0x1
    80004364:	c66080e7          	jalr	-922(ra) # 80004fc6 <releasesleep>
}
    80004368:	60e2                	ld	ra,24(sp)
    8000436a:	6442                	ld	s0,16(sp)
    8000436c:	64a2                	ld	s1,8(sp)
    8000436e:	6902                	ld	s2,0(sp)
    80004370:	6105                	addi	sp,sp,32
    80004372:	8082                	ret
    panic("iunlock");
    80004374:	00006517          	auipc	a0,0x6
    80004378:	1ec50513          	addi	a0,a0,492 # 8000a560 <etext+0x560>
    8000437c:	ffffc097          	auipc	ra,0xffffc
    80004380:	1e2080e7          	jalr	482(ra) # 8000055e <panic>

0000000080004384 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004384:	7179                	addi	sp,sp,-48
    80004386:	f406                	sd	ra,40(sp)
    80004388:	f022                	sd	s0,32(sp)
    8000438a:	ec26                	sd	s1,24(sp)
    8000438c:	e84a                	sd	s2,16(sp)
    8000438e:	e44e                	sd	s3,8(sp)
    80004390:	1800                	addi	s0,sp,48
    80004392:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004394:	05050493          	addi	s1,a0,80
    80004398:	08050913          	addi	s2,a0,128
    8000439c:	a021                	j	800043a4 <itrunc+0x20>
    8000439e:	0491                	addi	s1,s1,4
    800043a0:	01248d63          	beq	s1,s2,800043ba <itrunc+0x36>
    if(ip->addrs[i]){
    800043a4:	408c                	lw	a1,0(s1)
    800043a6:	dde5                	beqz	a1,8000439e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800043a8:	0009a503          	lw	a0,0(s3)
    800043ac:	00000097          	auipc	ra,0x0
    800043b0:	908080e7          	jalr	-1784(ra) # 80003cb4 <bfree>
      ip->addrs[i] = 0;
    800043b4:	0004a023          	sw	zero,0(s1)
    800043b8:	b7dd                	j	8000439e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800043ba:	0809a583          	lw	a1,128(s3)
    800043be:	ed99                	bnez	a1,800043dc <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800043c0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800043c4:	854e                	mv	a0,s3
    800043c6:	00000097          	auipc	ra,0x0
    800043ca:	de0080e7          	jalr	-544(ra) # 800041a6 <iupdate>
}
    800043ce:	70a2                	ld	ra,40(sp)
    800043d0:	7402                	ld	s0,32(sp)
    800043d2:	64e2                	ld	s1,24(sp)
    800043d4:	6942                	ld	s2,16(sp)
    800043d6:	69a2                	ld	s3,8(sp)
    800043d8:	6145                	addi	sp,sp,48
    800043da:	8082                	ret
    800043dc:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800043de:	0009a503          	lw	a0,0(s3)
    800043e2:	fffff097          	auipc	ra,0xfffff
    800043e6:	692080e7          	jalr	1682(ra) # 80003a74 <bread>
    800043ea:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800043ec:	05850493          	addi	s1,a0,88
    800043f0:	45850913          	addi	s2,a0,1112
    800043f4:	a021                	j	800043fc <itrunc+0x78>
    800043f6:	0491                	addi	s1,s1,4
    800043f8:	01248b63          	beq	s1,s2,8000440e <itrunc+0x8a>
      if(a[j])
    800043fc:	408c                	lw	a1,0(s1)
    800043fe:	dde5                	beqz	a1,800043f6 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80004400:	0009a503          	lw	a0,0(s3)
    80004404:	00000097          	auipc	ra,0x0
    80004408:	8b0080e7          	jalr	-1872(ra) # 80003cb4 <bfree>
    8000440c:	b7ed                	j	800043f6 <itrunc+0x72>
    brelse(bp);
    8000440e:	8552                	mv	a0,s4
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	794080e7          	jalr	1940(ra) # 80003ba4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004418:	0809a583          	lw	a1,128(s3)
    8000441c:	0009a503          	lw	a0,0(s3)
    80004420:	00000097          	auipc	ra,0x0
    80004424:	894080e7          	jalr	-1900(ra) # 80003cb4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004428:	0809a023          	sw	zero,128(s3)
    8000442c:	6a02                	ld	s4,0(sp)
    8000442e:	bf49                	j	800043c0 <itrunc+0x3c>

0000000080004430 <iput>:
{
    80004430:	1101                	addi	sp,sp,-32
    80004432:	ec06                	sd	ra,24(sp)
    80004434:	e822                	sd	s0,16(sp)
    80004436:	e426                	sd	s1,8(sp)
    80004438:	1000                	addi	s0,sp,32
    8000443a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000443c:	00068517          	auipc	a0,0x68
    80004440:	7fc50513          	addi	a0,a0,2044 # 8006cc38 <itable>
    80004444:	ffffd097          	auipc	ra,0xffffd
    80004448:	8f0080e7          	jalr	-1808(ra) # 80000d34 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000444c:	4498                	lw	a4,8(s1)
    8000444e:	4785                	li	a5,1
    80004450:	02f70263          	beq	a4,a5,80004474 <iput+0x44>
  ip->ref--;
    80004454:	449c                	lw	a5,8(s1)
    80004456:	37fd                	addiw	a5,a5,-1
    80004458:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000445a:	00068517          	auipc	a0,0x68
    8000445e:	7de50513          	addi	a0,a0,2014 # 8006cc38 <itable>
    80004462:	ffffd097          	auipc	ra,0xffffd
    80004466:	982080e7          	jalr	-1662(ra) # 80000de4 <release>
}
    8000446a:	60e2                	ld	ra,24(sp)
    8000446c:	6442                	ld	s0,16(sp)
    8000446e:	64a2                	ld	s1,8(sp)
    80004470:	6105                	addi	sp,sp,32
    80004472:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004474:	40bc                	lw	a5,64(s1)
    80004476:	dff9                	beqz	a5,80004454 <iput+0x24>
    80004478:	04a49783          	lh	a5,74(s1)
    8000447c:	ffe1                	bnez	a5,80004454 <iput+0x24>
    8000447e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80004480:	01048793          	addi	a5,s1,16
    80004484:	893e                	mv	s2,a5
    80004486:	853e                	mv	a0,a5
    80004488:	00001097          	auipc	ra,0x1
    8000448c:	ae8080e7          	jalr	-1304(ra) # 80004f70 <acquiresleep>
    release(&itable.lock);
    80004490:	00068517          	auipc	a0,0x68
    80004494:	7a850513          	addi	a0,a0,1960 # 8006cc38 <itable>
    80004498:	ffffd097          	auipc	ra,0xffffd
    8000449c:	94c080e7          	jalr	-1716(ra) # 80000de4 <release>
    itrunc(ip);
    800044a0:	8526                	mv	a0,s1
    800044a2:	00000097          	auipc	ra,0x0
    800044a6:	ee2080e7          	jalr	-286(ra) # 80004384 <itrunc>
    ip->type = 0;
    800044aa:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800044ae:	8526                	mv	a0,s1
    800044b0:	00000097          	auipc	ra,0x0
    800044b4:	cf6080e7          	jalr	-778(ra) # 800041a6 <iupdate>
    ip->valid = 0;
    800044b8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800044bc:	854a                	mv	a0,s2
    800044be:	00001097          	auipc	ra,0x1
    800044c2:	b08080e7          	jalr	-1272(ra) # 80004fc6 <releasesleep>
    acquire(&itable.lock);
    800044c6:	00068517          	auipc	a0,0x68
    800044ca:	77250513          	addi	a0,a0,1906 # 8006cc38 <itable>
    800044ce:	ffffd097          	auipc	ra,0xffffd
    800044d2:	866080e7          	jalr	-1946(ra) # 80000d34 <acquire>
    800044d6:	6902                	ld	s2,0(sp)
    800044d8:	bfb5                	j	80004454 <iput+0x24>

00000000800044da <iunlockput>:
{
    800044da:	1101                	addi	sp,sp,-32
    800044dc:	ec06                	sd	ra,24(sp)
    800044de:	e822                	sd	s0,16(sp)
    800044e0:	e426                	sd	s1,8(sp)
    800044e2:	1000                	addi	s0,sp,32
    800044e4:	84aa                	mv	s1,a0
  iunlock(ip);
    800044e6:	00000097          	auipc	ra,0x0
    800044ea:	e52080e7          	jalr	-430(ra) # 80004338 <iunlock>
  iput(ip);
    800044ee:	8526                	mv	a0,s1
    800044f0:	00000097          	auipc	ra,0x0
    800044f4:	f40080e7          	jalr	-192(ra) # 80004430 <iput>
}
    800044f8:	60e2                	ld	ra,24(sp)
    800044fa:	6442                	ld	s0,16(sp)
    800044fc:	64a2                	ld	s1,8(sp)
    800044fe:	6105                	addi	sp,sp,32
    80004500:	8082                	ret

0000000080004502 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004502:	1141                	addi	sp,sp,-16
    80004504:	e406                	sd	ra,8(sp)
    80004506:	e022                	sd	s0,0(sp)
    80004508:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000450a:	411c                	lw	a5,0(a0)
    8000450c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000450e:	415c                	lw	a5,4(a0)
    80004510:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004512:	04451783          	lh	a5,68(a0)
    80004516:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000451a:	04a51783          	lh	a5,74(a0)
    8000451e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004522:	04c56783          	lwu	a5,76(a0)
    80004526:	e99c                	sd	a5,16(a1)
}
    80004528:	60a2                	ld	ra,8(sp)
    8000452a:	6402                	ld	s0,0(sp)
    8000452c:	0141                	addi	sp,sp,16
    8000452e:	8082                	ret

0000000080004530 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004530:	457c                	lw	a5,76(a0)
    80004532:	10d7e063          	bltu	a5,a3,80004632 <readi+0x102>
{
    80004536:	7159                	addi	sp,sp,-112
    80004538:	f486                	sd	ra,104(sp)
    8000453a:	f0a2                	sd	s0,96(sp)
    8000453c:	eca6                	sd	s1,88(sp)
    8000453e:	e0d2                	sd	s4,64(sp)
    80004540:	fc56                	sd	s5,56(sp)
    80004542:	f85a                	sd	s6,48(sp)
    80004544:	f45e                	sd	s7,40(sp)
    80004546:	1880                	addi	s0,sp,112
    80004548:	8b2a                	mv	s6,a0
    8000454a:	8bae                	mv	s7,a1
    8000454c:	8a32                	mv	s4,a2
    8000454e:	84b6                	mv	s1,a3
    80004550:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004552:	9f35                	addw	a4,a4,a3
    return 0;
    80004554:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004556:	0cd76563          	bltu	a4,a3,80004620 <readi+0xf0>
    8000455a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000455c:	00e7f463          	bgeu	a5,a4,80004564 <readi+0x34>
    n = ip->size - off;
    80004560:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004564:	0a0a8563          	beqz	s5,8000460e <readi+0xde>
    80004568:	e8ca                	sd	s2,80(sp)
    8000456a:	f062                	sd	s8,32(sp)
    8000456c:	ec66                	sd	s9,24(sp)
    8000456e:	e86a                	sd	s10,16(sp)
    80004570:	e46e                	sd	s11,8(sp)
    80004572:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004574:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004578:	5c7d                	li	s8,-1
    8000457a:	a82d                	j	800045b4 <readi+0x84>
    8000457c:	020d1d93          	slli	s11,s10,0x20
    80004580:	020ddd93          	srli	s11,s11,0x20
    80004584:	05890613          	addi	a2,s2,88
    80004588:	86ee                	mv	a3,s11
    8000458a:	963e                	add	a2,a2,a5
    8000458c:	85d2                	mv	a1,s4
    8000458e:	855e                	mv	a0,s7
    80004590:	fffff097          	auipc	ra,0xfffff
    80004594:	86e080e7          	jalr	-1938(ra) # 80002dfe <either_copyout>
    80004598:	05850963          	beq	a0,s8,800045ea <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000459c:	854a                	mv	a0,s2
    8000459e:	fffff097          	auipc	ra,0xfffff
    800045a2:	606080e7          	jalr	1542(ra) # 80003ba4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800045a6:	013d09bb          	addw	s3,s10,s3
    800045aa:	009d04bb          	addw	s1,s10,s1
    800045ae:	9a6e                	add	s4,s4,s11
    800045b0:	0559f963          	bgeu	s3,s5,80004602 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    800045b4:	00a4d59b          	srliw	a1,s1,0xa
    800045b8:	855a                	mv	a0,s6
    800045ba:	00000097          	auipc	ra,0x0
    800045be:	8a0080e7          	jalr	-1888(ra) # 80003e5a <bmap>
    800045c2:	85aa                	mv	a1,a0
    if(addr == 0)
    800045c4:	c539                	beqz	a0,80004612 <readi+0xe2>
    bp = bread(ip->dev, addr);
    800045c6:	000b2503          	lw	a0,0(s6)
    800045ca:	fffff097          	auipc	ra,0xfffff
    800045ce:	4aa080e7          	jalr	1194(ra) # 80003a74 <bread>
    800045d2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800045d4:	3ff4f793          	andi	a5,s1,1023
    800045d8:	40fc873b          	subw	a4,s9,a5
    800045dc:	413a86bb          	subw	a3,s5,s3
    800045e0:	8d3a                	mv	s10,a4
    800045e2:	f8e6fde3          	bgeu	a3,a4,8000457c <readi+0x4c>
    800045e6:	8d36                	mv	s10,a3
    800045e8:	bf51                	j	8000457c <readi+0x4c>
      brelse(bp);
    800045ea:	854a                	mv	a0,s2
    800045ec:	fffff097          	auipc	ra,0xfffff
    800045f0:	5b8080e7          	jalr	1464(ra) # 80003ba4 <brelse>
      tot = -1;
    800045f4:	59fd                	li	s3,-1
      break;
    800045f6:	6946                	ld	s2,80(sp)
    800045f8:	7c02                	ld	s8,32(sp)
    800045fa:	6ce2                	ld	s9,24(sp)
    800045fc:	6d42                	ld	s10,16(sp)
    800045fe:	6da2                	ld	s11,8(sp)
    80004600:	a831                	j	8000461c <readi+0xec>
    80004602:	6946                	ld	s2,80(sp)
    80004604:	7c02                	ld	s8,32(sp)
    80004606:	6ce2                	ld	s9,24(sp)
    80004608:	6d42                	ld	s10,16(sp)
    8000460a:	6da2                	ld	s11,8(sp)
    8000460c:	a801                	j	8000461c <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000460e:	89d6                	mv	s3,s5
    80004610:	a031                	j	8000461c <readi+0xec>
    80004612:	6946                	ld	s2,80(sp)
    80004614:	7c02                	ld	s8,32(sp)
    80004616:	6ce2                	ld	s9,24(sp)
    80004618:	6d42                	ld	s10,16(sp)
    8000461a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000461c:	854e                	mv	a0,s3
    8000461e:	69a6                	ld	s3,72(sp)
}
    80004620:	70a6                	ld	ra,104(sp)
    80004622:	7406                	ld	s0,96(sp)
    80004624:	64e6                	ld	s1,88(sp)
    80004626:	6a06                	ld	s4,64(sp)
    80004628:	7ae2                	ld	s5,56(sp)
    8000462a:	7b42                	ld	s6,48(sp)
    8000462c:	7ba2                	ld	s7,40(sp)
    8000462e:	6165                	addi	sp,sp,112
    80004630:	8082                	ret
    return 0;
    80004632:	4501                	li	a0,0
}
    80004634:	8082                	ret

0000000080004636 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004636:	457c                	lw	a5,76(a0)
    80004638:	10d7e963          	bltu	a5,a3,8000474a <writei+0x114>
{
    8000463c:	7159                	addi	sp,sp,-112
    8000463e:	f486                	sd	ra,104(sp)
    80004640:	f0a2                	sd	s0,96(sp)
    80004642:	e8ca                	sd	s2,80(sp)
    80004644:	e0d2                	sd	s4,64(sp)
    80004646:	fc56                	sd	s5,56(sp)
    80004648:	f85a                	sd	s6,48(sp)
    8000464a:	f45e                	sd	s7,40(sp)
    8000464c:	1880                	addi	s0,sp,112
    8000464e:	8aaa                	mv	s5,a0
    80004650:	8bae                	mv	s7,a1
    80004652:	8a32                	mv	s4,a2
    80004654:	8936                	mv	s2,a3
    80004656:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004658:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000465c:	00043737          	lui	a4,0x43
    80004660:	0ef76763          	bltu	a4,a5,8000474e <writei+0x118>
    80004664:	0ed7e563          	bltu	a5,a3,8000474e <writei+0x118>
    80004668:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000466a:	0c0b0863          	beqz	s6,8000473a <writei+0x104>
    8000466e:	eca6                	sd	s1,88(sp)
    80004670:	f062                	sd	s8,32(sp)
    80004672:	ec66                	sd	s9,24(sp)
    80004674:	e86a                	sd	s10,16(sp)
    80004676:	e46e                	sd	s11,8(sp)
    80004678:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000467a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000467e:	5c7d                	li	s8,-1
    80004680:	a091                	j	800046c4 <writei+0x8e>
    80004682:	020d1d93          	slli	s11,s10,0x20
    80004686:	020ddd93          	srli	s11,s11,0x20
    8000468a:	05848513          	addi	a0,s1,88
    8000468e:	86ee                	mv	a3,s11
    80004690:	8652                	mv	a2,s4
    80004692:	85de                	mv	a1,s7
    80004694:	953e                	add	a0,a0,a5
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	7be080e7          	jalr	1982(ra) # 80002e54 <either_copyin>
    8000469e:	05850e63          	beq	a0,s8,800046fa <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    800046a2:	8526                	mv	a0,s1
    800046a4:	00000097          	auipc	ra,0x0
    800046a8:	7ac080e7          	jalr	1964(ra) # 80004e50 <log_write>
    brelse(bp);
    800046ac:	8526                	mv	a0,s1
    800046ae:	fffff097          	auipc	ra,0xfffff
    800046b2:	4f6080e7          	jalr	1270(ra) # 80003ba4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800046b6:	013d09bb          	addw	s3,s10,s3
    800046ba:	012d093b          	addw	s2,s10,s2
    800046be:	9a6e                	add	s4,s4,s11
    800046c0:	0569f263          	bgeu	s3,s6,80004704 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800046c4:	00a9559b          	srliw	a1,s2,0xa
    800046c8:	8556                	mv	a0,s5
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	790080e7          	jalr	1936(ra) # 80003e5a <bmap>
    800046d2:	85aa                	mv	a1,a0
    if(addr == 0)
    800046d4:	c905                	beqz	a0,80004704 <writei+0xce>
    bp = bread(ip->dev, addr);
    800046d6:	000aa503          	lw	a0,0(s5)
    800046da:	fffff097          	auipc	ra,0xfffff
    800046de:	39a080e7          	jalr	922(ra) # 80003a74 <bread>
    800046e2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800046e4:	3ff97793          	andi	a5,s2,1023
    800046e8:	40fc873b          	subw	a4,s9,a5
    800046ec:	413b06bb          	subw	a3,s6,s3
    800046f0:	8d3a                	mv	s10,a4
    800046f2:	f8e6f8e3          	bgeu	a3,a4,80004682 <writei+0x4c>
    800046f6:	8d36                	mv	s10,a3
    800046f8:	b769                	j	80004682 <writei+0x4c>
      brelse(bp);
    800046fa:	8526                	mv	a0,s1
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	4a8080e7          	jalr	1192(ra) # 80003ba4 <brelse>
  }

  if(off > ip->size)
    80004704:	04caa783          	lw	a5,76(s5)
    80004708:	0327fb63          	bgeu	a5,s2,8000473e <writei+0x108>
    ip->size = off;
    8000470c:	052aa623          	sw	s2,76(s5)
    80004710:	64e6                	ld	s1,88(sp)
    80004712:	7c02                	ld	s8,32(sp)
    80004714:	6ce2                	ld	s9,24(sp)
    80004716:	6d42                	ld	s10,16(sp)
    80004718:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000471a:	8556                	mv	a0,s5
    8000471c:	00000097          	auipc	ra,0x0
    80004720:	a8a080e7          	jalr	-1398(ra) # 800041a6 <iupdate>

  return tot;
    80004724:	854e                	mv	a0,s3
    80004726:	69a6                	ld	s3,72(sp)
}
    80004728:	70a6                	ld	ra,104(sp)
    8000472a:	7406                	ld	s0,96(sp)
    8000472c:	6946                	ld	s2,80(sp)
    8000472e:	6a06                	ld	s4,64(sp)
    80004730:	7ae2                	ld	s5,56(sp)
    80004732:	7b42                	ld	s6,48(sp)
    80004734:	7ba2                	ld	s7,40(sp)
    80004736:	6165                	addi	sp,sp,112
    80004738:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000473a:	89da                	mv	s3,s6
    8000473c:	bff9                	j	8000471a <writei+0xe4>
    8000473e:	64e6                	ld	s1,88(sp)
    80004740:	7c02                	ld	s8,32(sp)
    80004742:	6ce2                	ld	s9,24(sp)
    80004744:	6d42                	ld	s10,16(sp)
    80004746:	6da2                	ld	s11,8(sp)
    80004748:	bfc9                	j	8000471a <writei+0xe4>
    return -1;
    8000474a:	557d                	li	a0,-1
}
    8000474c:	8082                	ret
    return -1;
    8000474e:	557d                	li	a0,-1
    80004750:	bfe1                	j	80004728 <writei+0xf2>

0000000080004752 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004752:	1141                	addi	sp,sp,-16
    80004754:	e406                	sd	ra,8(sp)
    80004756:	e022                	sd	s0,0(sp)
    80004758:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000475a:	4639                	li	a2,14
    8000475c:	ffffc097          	auipc	ra,0xffffc
    80004760:	7a8080e7          	jalr	1960(ra) # 80000f04 <strncmp>
}
    80004764:	60a2                	ld	ra,8(sp)
    80004766:	6402                	ld	s0,0(sp)
    80004768:	0141                	addi	sp,sp,16
    8000476a:	8082                	ret

000000008000476c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000476c:	711d                	addi	sp,sp,-96
    8000476e:	ec86                	sd	ra,88(sp)
    80004770:	e8a2                	sd	s0,80(sp)
    80004772:	e4a6                	sd	s1,72(sp)
    80004774:	e0ca                	sd	s2,64(sp)
    80004776:	fc4e                	sd	s3,56(sp)
    80004778:	f852                	sd	s4,48(sp)
    8000477a:	f456                	sd	s5,40(sp)
    8000477c:	f05a                	sd	s6,32(sp)
    8000477e:	ec5e                	sd	s7,24(sp)
    80004780:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004782:	04451703          	lh	a4,68(a0)
    80004786:	4785                	li	a5,1
    80004788:	00f71f63          	bne	a4,a5,800047a6 <dirlookup+0x3a>
    8000478c:	892a                	mv	s2,a0
    8000478e:	8aae                	mv	s5,a1
    80004790:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004792:	457c                	lw	a5,76(a0)
    80004794:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004796:	fa040a13          	addi	s4,s0,-96
    8000479a:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000479c:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800047a0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800047a2:	e79d                	bnez	a5,800047d0 <dirlookup+0x64>
    800047a4:	a88d                	j	80004816 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    800047a6:	00006517          	auipc	a0,0x6
    800047aa:	dc250513          	addi	a0,a0,-574 # 8000a568 <etext+0x568>
    800047ae:	ffffc097          	auipc	ra,0xffffc
    800047b2:	db0080e7          	jalr	-592(ra) # 8000055e <panic>
      panic("dirlookup read");
    800047b6:	00006517          	auipc	a0,0x6
    800047ba:	dca50513          	addi	a0,a0,-566 # 8000a580 <etext+0x580>
    800047be:	ffffc097          	auipc	ra,0xffffc
    800047c2:	da0080e7          	jalr	-608(ra) # 8000055e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800047c6:	24c1                	addiw	s1,s1,16
    800047c8:	04c92783          	lw	a5,76(s2)
    800047cc:	04f4f463          	bgeu	s1,a5,80004814 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800047d0:	874e                	mv	a4,s3
    800047d2:	86a6                	mv	a3,s1
    800047d4:	8652                	mv	a2,s4
    800047d6:	4581                	li	a1,0
    800047d8:	854a                	mv	a0,s2
    800047da:	00000097          	auipc	ra,0x0
    800047de:	d56080e7          	jalr	-682(ra) # 80004530 <readi>
    800047e2:	fd351ae3          	bne	a0,s3,800047b6 <dirlookup+0x4a>
    if(de.inum == 0)
    800047e6:	fa045783          	lhu	a5,-96(s0)
    800047ea:	dff1                	beqz	a5,800047c6 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    800047ec:	85da                	mv	a1,s6
    800047ee:	8556                	mv	a0,s5
    800047f0:	00000097          	auipc	ra,0x0
    800047f4:	f62080e7          	jalr	-158(ra) # 80004752 <namecmp>
    800047f8:	f579                	bnez	a0,800047c6 <dirlookup+0x5a>
      if(poff)
    800047fa:	000b8463          	beqz	s7,80004802 <dirlookup+0x96>
        *poff = off;
    800047fe:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80004802:	fa045583          	lhu	a1,-96(s0)
    80004806:	00092503          	lw	a0,0(s2)
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	72c080e7          	jalr	1836(ra) # 80003f36 <iget>
    80004812:	a011                	j	80004816 <dirlookup+0xaa>
  return 0;
    80004814:	4501                	li	a0,0
}
    80004816:	60e6                	ld	ra,88(sp)
    80004818:	6446                	ld	s0,80(sp)
    8000481a:	64a6                	ld	s1,72(sp)
    8000481c:	6906                	ld	s2,64(sp)
    8000481e:	79e2                	ld	s3,56(sp)
    80004820:	7a42                	ld	s4,48(sp)
    80004822:	7aa2                	ld	s5,40(sp)
    80004824:	7b02                	ld	s6,32(sp)
    80004826:	6be2                	ld	s7,24(sp)
    80004828:	6125                	addi	sp,sp,96
    8000482a:	8082                	ret

000000008000482c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000482c:	711d                	addi	sp,sp,-96
    8000482e:	ec86                	sd	ra,88(sp)
    80004830:	e8a2                	sd	s0,80(sp)
    80004832:	e4a6                	sd	s1,72(sp)
    80004834:	e0ca                	sd	s2,64(sp)
    80004836:	fc4e                	sd	s3,56(sp)
    80004838:	f852                	sd	s4,48(sp)
    8000483a:	f456                	sd	s5,40(sp)
    8000483c:	f05a                	sd	s6,32(sp)
    8000483e:	ec5e                	sd	s7,24(sp)
    80004840:	e862                	sd	s8,16(sp)
    80004842:	e466                	sd	s9,8(sp)
    80004844:	e06a                	sd	s10,0(sp)
    80004846:	1080                	addi	s0,sp,96
    80004848:	84aa                	mv	s1,a0
    8000484a:	8b2e                	mv	s6,a1
    8000484c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000484e:	00054703          	lbu	a4,0(a0)
    80004852:	02f00793          	li	a5,47
    80004856:	02f70363          	beq	a4,a5,8000487c <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000485a:	ffffd097          	auipc	ra,0xffffd
    8000485e:	624080e7          	jalr	1572(ra) # 80001e7e <myproc>
    80004862:	15053503          	ld	a0,336(a0)
    80004866:	00000097          	auipc	ra,0x0
    8000486a:	9ce080e7          	jalr	-1586(ra) # 80004234 <idup>
    8000486e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004870:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80004874:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004876:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004878:	4b85                	li	s7,1
    8000487a:	a87d                	j	80004938 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000487c:	4585                	li	a1,1
    8000487e:	852e                	mv	a0,a1
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	6b6080e7          	jalr	1718(ra) # 80003f36 <iget>
    80004888:	8a2a                	mv	s4,a0
    8000488a:	b7dd                	j	80004870 <namex+0x44>
      iunlockput(ip);
    8000488c:	8552                	mv	a0,s4
    8000488e:	00000097          	auipc	ra,0x0
    80004892:	c4c080e7          	jalr	-948(ra) # 800044da <iunlockput>
      return 0;
    80004896:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004898:	8552                	mv	a0,s4
    8000489a:	60e6                	ld	ra,88(sp)
    8000489c:	6446                	ld	s0,80(sp)
    8000489e:	64a6                	ld	s1,72(sp)
    800048a0:	6906                	ld	s2,64(sp)
    800048a2:	79e2                	ld	s3,56(sp)
    800048a4:	7a42                	ld	s4,48(sp)
    800048a6:	7aa2                	ld	s5,40(sp)
    800048a8:	7b02                	ld	s6,32(sp)
    800048aa:	6be2                	ld	s7,24(sp)
    800048ac:	6c42                	ld	s8,16(sp)
    800048ae:	6ca2                	ld	s9,8(sp)
    800048b0:	6d02                	ld	s10,0(sp)
    800048b2:	6125                	addi	sp,sp,96
    800048b4:	8082                	ret
      iunlock(ip);
    800048b6:	8552                	mv	a0,s4
    800048b8:	00000097          	auipc	ra,0x0
    800048bc:	a80080e7          	jalr	-1408(ra) # 80004338 <iunlock>
      return ip;
    800048c0:	bfe1                	j	80004898 <namex+0x6c>
      iunlockput(ip);
    800048c2:	8552                	mv	a0,s4
    800048c4:	00000097          	auipc	ra,0x0
    800048c8:	c16080e7          	jalr	-1002(ra) # 800044da <iunlockput>
      return 0;
    800048cc:	8a4a                	mv	s4,s2
    800048ce:	b7e9                	j	80004898 <namex+0x6c>
  len = path - s;
    800048d0:	40990633          	sub	a2,s2,s1
    800048d4:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800048d8:	09ac5c63          	bge	s8,s10,80004970 <namex+0x144>
    memmove(name, s, DIRSIZ);
    800048dc:	8666                	mv	a2,s9
    800048de:	85a6                	mv	a1,s1
    800048e0:	8556                	mv	a0,s5
    800048e2:	ffffc097          	auipc	ra,0xffffc
    800048e6:	5aa080e7          	jalr	1450(ra) # 80000e8c <memmove>
    800048ea:	84ca                	mv	s1,s2
  while(*path == '/')
    800048ec:	0004c783          	lbu	a5,0(s1)
    800048f0:	01379763          	bne	a5,s3,800048fe <namex+0xd2>
    path++;
    800048f4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800048f6:	0004c783          	lbu	a5,0(s1)
    800048fa:	ff378de3          	beq	a5,s3,800048f4 <namex+0xc8>
    ilock(ip);
    800048fe:	8552                	mv	a0,s4
    80004900:	00000097          	auipc	ra,0x0
    80004904:	972080e7          	jalr	-1678(ra) # 80004272 <ilock>
    if(ip->type != T_DIR){
    80004908:	044a1783          	lh	a5,68(s4)
    8000490c:	f97790e3          	bne	a5,s7,8000488c <namex+0x60>
    if(nameiparent && *path == '\0'){
    80004910:	000b0563          	beqz	s6,8000491a <namex+0xee>
    80004914:	0004c783          	lbu	a5,0(s1)
    80004918:	dfd9                	beqz	a5,800048b6 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000491a:	4601                	li	a2,0
    8000491c:	85d6                	mv	a1,s5
    8000491e:	8552                	mv	a0,s4
    80004920:	00000097          	auipc	ra,0x0
    80004924:	e4c080e7          	jalr	-436(ra) # 8000476c <dirlookup>
    80004928:	892a                	mv	s2,a0
    8000492a:	dd41                	beqz	a0,800048c2 <namex+0x96>
    iunlockput(ip);
    8000492c:	8552                	mv	a0,s4
    8000492e:	00000097          	auipc	ra,0x0
    80004932:	bac080e7          	jalr	-1108(ra) # 800044da <iunlockput>
    ip = next;
    80004936:	8a4a                	mv	s4,s2
  while(*path == '/')
    80004938:	0004c783          	lbu	a5,0(s1)
    8000493c:	01379763          	bne	a5,s3,8000494a <namex+0x11e>
    path++;
    80004940:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004942:	0004c783          	lbu	a5,0(s1)
    80004946:	ff378de3          	beq	a5,s3,80004940 <namex+0x114>
  if(*path == 0)
    8000494a:	cf9d                	beqz	a5,80004988 <namex+0x15c>
  while(*path != '/' && *path != 0)
    8000494c:	0004c783          	lbu	a5,0(s1)
    80004950:	fd178713          	addi	a4,a5,-47
    80004954:	cb19                	beqz	a4,8000496a <namex+0x13e>
    80004956:	cb91                	beqz	a5,8000496a <namex+0x13e>
    80004958:	8926                	mv	s2,s1
    path++;
    8000495a:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    8000495c:	00094783          	lbu	a5,0(s2)
    80004960:	fd178713          	addi	a4,a5,-47
    80004964:	d735                	beqz	a4,800048d0 <namex+0xa4>
    80004966:	fbf5                	bnez	a5,8000495a <namex+0x12e>
    80004968:	b7a5                	j	800048d0 <namex+0xa4>
    8000496a:	8926                	mv	s2,s1
  len = path - s;
    8000496c:	4d01                	li	s10,0
    8000496e:	4601                	li	a2,0
    memmove(name, s, len);
    80004970:	2601                	sext.w	a2,a2
    80004972:	85a6                	mv	a1,s1
    80004974:	8556                	mv	a0,s5
    80004976:	ffffc097          	auipc	ra,0xffffc
    8000497a:	516080e7          	jalr	1302(ra) # 80000e8c <memmove>
    name[len] = 0;
    8000497e:	9d56                	add	s10,s10,s5
    80004980:	000d0023          	sb	zero,0(s10)
    80004984:	84ca                	mv	s1,s2
    80004986:	b79d                	j	800048ec <namex+0xc0>
  if(nameiparent){
    80004988:	f00b08e3          	beqz	s6,80004898 <namex+0x6c>
    iput(ip);
    8000498c:	8552                	mv	a0,s4
    8000498e:	00000097          	auipc	ra,0x0
    80004992:	aa2080e7          	jalr	-1374(ra) # 80004430 <iput>
    return 0;
    80004996:	4a01                	li	s4,0
    80004998:	b701                	j	80004898 <namex+0x6c>

000000008000499a <dirlink>:
{
    8000499a:	715d                	addi	sp,sp,-80
    8000499c:	e486                	sd	ra,72(sp)
    8000499e:	e0a2                	sd	s0,64(sp)
    800049a0:	f84a                	sd	s2,48(sp)
    800049a2:	ec56                	sd	s5,24(sp)
    800049a4:	e85a                	sd	s6,16(sp)
    800049a6:	0880                	addi	s0,sp,80
    800049a8:	892a                	mv	s2,a0
    800049aa:	8aae                	mv	s5,a1
    800049ac:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800049ae:	4601                	li	a2,0
    800049b0:	00000097          	auipc	ra,0x0
    800049b4:	dbc080e7          	jalr	-580(ra) # 8000476c <dirlookup>
    800049b8:	e129                	bnez	a0,800049fa <dirlink+0x60>
    800049ba:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800049bc:	04c92483          	lw	s1,76(s2)
    800049c0:	cca9                	beqz	s1,80004a1a <dirlink+0x80>
    800049c2:	f44e                	sd	s3,40(sp)
    800049c4:	f052                	sd	s4,32(sp)
    800049c6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049c8:	fb040a13          	addi	s4,s0,-80
    800049cc:	49c1                	li	s3,16
    800049ce:	874e                	mv	a4,s3
    800049d0:	86a6                	mv	a3,s1
    800049d2:	8652                	mv	a2,s4
    800049d4:	4581                	li	a1,0
    800049d6:	854a                	mv	a0,s2
    800049d8:	00000097          	auipc	ra,0x0
    800049dc:	b58080e7          	jalr	-1192(ra) # 80004530 <readi>
    800049e0:	03351363          	bne	a0,s3,80004a06 <dirlink+0x6c>
    if(de.inum == 0)
    800049e4:	fb045783          	lhu	a5,-80(s0)
    800049e8:	c79d                	beqz	a5,80004a16 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800049ea:	24c1                	addiw	s1,s1,16
    800049ec:	04c92783          	lw	a5,76(s2)
    800049f0:	fcf4efe3          	bltu	s1,a5,800049ce <dirlink+0x34>
    800049f4:	79a2                	ld	s3,40(sp)
    800049f6:	7a02                	ld	s4,32(sp)
    800049f8:	a00d                	j	80004a1a <dirlink+0x80>
    iput(ip);
    800049fa:	00000097          	auipc	ra,0x0
    800049fe:	a36080e7          	jalr	-1482(ra) # 80004430 <iput>
    return -1;
    80004a02:	557d                	li	a0,-1
    80004a04:	a0a9                	j	80004a4e <dirlink+0xb4>
      panic("dirlink read");
    80004a06:	00006517          	auipc	a0,0x6
    80004a0a:	b8a50513          	addi	a0,a0,-1142 # 8000a590 <etext+0x590>
    80004a0e:	ffffc097          	auipc	ra,0xffffc
    80004a12:	b50080e7          	jalr	-1200(ra) # 8000055e <panic>
    80004a16:	79a2                	ld	s3,40(sp)
    80004a18:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004a1a:	4639                	li	a2,14
    80004a1c:	85d6                	mv	a1,s5
    80004a1e:	fb240513          	addi	a0,s0,-78
    80004a22:	ffffc097          	auipc	ra,0xffffc
    80004a26:	51c080e7          	jalr	1308(ra) # 80000f3e <strncpy>
  de.inum = inum;
    80004a2a:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a2e:	4741                	li	a4,16
    80004a30:	86a6                	mv	a3,s1
    80004a32:	fb040613          	addi	a2,s0,-80
    80004a36:	4581                	li	a1,0
    80004a38:	854a                	mv	a0,s2
    80004a3a:	00000097          	auipc	ra,0x0
    80004a3e:	bfc080e7          	jalr	-1028(ra) # 80004636 <writei>
    80004a42:	1541                	addi	a0,a0,-16
    80004a44:	00a03533          	snez	a0,a0
    80004a48:	40a0053b          	negw	a0,a0
    80004a4c:	74e2                	ld	s1,56(sp)
}
    80004a4e:	60a6                	ld	ra,72(sp)
    80004a50:	6406                	ld	s0,64(sp)
    80004a52:	7942                	ld	s2,48(sp)
    80004a54:	6ae2                	ld	s5,24(sp)
    80004a56:	6b42                	ld	s6,16(sp)
    80004a58:	6161                	addi	sp,sp,80
    80004a5a:	8082                	ret

0000000080004a5c <namei>:

struct inode*
namei(char *path)
{
    80004a5c:	1101                	addi	sp,sp,-32
    80004a5e:	ec06                	sd	ra,24(sp)
    80004a60:	e822                	sd	s0,16(sp)
    80004a62:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004a64:	fe040613          	addi	a2,s0,-32
    80004a68:	4581                	li	a1,0
    80004a6a:	00000097          	auipc	ra,0x0
    80004a6e:	dc2080e7          	jalr	-574(ra) # 8000482c <namex>
}
    80004a72:	60e2                	ld	ra,24(sp)
    80004a74:	6442                	ld	s0,16(sp)
    80004a76:	6105                	addi	sp,sp,32
    80004a78:	8082                	ret

0000000080004a7a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004a7a:	1141                	addi	sp,sp,-16
    80004a7c:	e406                	sd	ra,8(sp)
    80004a7e:	e022                	sd	s0,0(sp)
    80004a80:	0800                	addi	s0,sp,16
    80004a82:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004a84:	4585                	li	a1,1
    80004a86:	00000097          	auipc	ra,0x0
    80004a8a:	da6080e7          	jalr	-602(ra) # 8000482c <namex>
}
    80004a8e:	60a2                	ld	ra,8(sp)
    80004a90:	6402                	ld	s0,0(sp)
    80004a92:	0141                	addi	sp,sp,16
    80004a94:	8082                	ret

0000000080004a96 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004a96:	1101                	addi	sp,sp,-32
    80004a98:	ec06                	sd	ra,24(sp)
    80004a9a:	e822                	sd	s0,16(sp)
    80004a9c:	e426                	sd	s1,8(sp)
    80004a9e:	e04a                	sd	s2,0(sp)
    80004aa0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004aa2:	0006a917          	auipc	s2,0x6a
    80004aa6:	c3e90913          	addi	s2,s2,-962 # 8006e6e0 <log>
    80004aaa:	01892583          	lw	a1,24(s2)
    80004aae:	02892503          	lw	a0,40(s2)
    80004ab2:	fffff097          	auipc	ra,0xfffff
    80004ab6:	fc2080e7          	jalr	-62(ra) # 80003a74 <bread>
    80004aba:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004abc:	02c92603          	lw	a2,44(s2)
    80004ac0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004ac2:	00c05f63          	blez	a2,80004ae0 <write_head+0x4a>
    80004ac6:	0006a717          	auipc	a4,0x6a
    80004aca:	c4a70713          	addi	a4,a4,-950 # 8006e710 <log+0x30>
    80004ace:	87aa                	mv	a5,a0
    80004ad0:	060a                	slli	a2,a2,0x2
    80004ad2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004ad4:	4314                	lw	a3,0(a4)
    80004ad6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004ad8:	0711                	addi	a4,a4,4
    80004ada:	0791                	addi	a5,a5,4
    80004adc:	fec79ce3          	bne	a5,a2,80004ad4 <write_head+0x3e>
  }
  bwrite(buf);
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	084080e7          	jalr	132(ra) # 80003b66 <bwrite>
  brelse(buf);
    80004aea:	8526                	mv	a0,s1
    80004aec:	fffff097          	auipc	ra,0xfffff
    80004af0:	0b8080e7          	jalr	184(ra) # 80003ba4 <brelse>
}
    80004af4:	60e2                	ld	ra,24(sp)
    80004af6:	6442                	ld	s0,16(sp)
    80004af8:	64a2                	ld	s1,8(sp)
    80004afa:	6902                	ld	s2,0(sp)
    80004afc:	6105                	addi	sp,sp,32
    80004afe:	8082                	ret

0000000080004b00 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b00:	0006a797          	auipc	a5,0x6a
    80004b04:	c0c7a783          	lw	a5,-1012(a5) # 8006e70c <log+0x2c>
    80004b08:	0cf05063          	blez	a5,80004bc8 <install_trans+0xc8>
{
    80004b0c:	715d                	addi	sp,sp,-80
    80004b0e:	e486                	sd	ra,72(sp)
    80004b10:	e0a2                	sd	s0,64(sp)
    80004b12:	fc26                	sd	s1,56(sp)
    80004b14:	f84a                	sd	s2,48(sp)
    80004b16:	f44e                	sd	s3,40(sp)
    80004b18:	f052                	sd	s4,32(sp)
    80004b1a:	ec56                	sd	s5,24(sp)
    80004b1c:	e85a                	sd	s6,16(sp)
    80004b1e:	e45e                	sd	s7,8(sp)
    80004b20:	0880                	addi	s0,sp,80
    80004b22:	8b2a                	mv	s6,a0
    80004b24:	0006aa97          	auipc	s5,0x6a
    80004b28:	beca8a93          	addi	s5,s5,-1044 # 8006e710 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b2c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004b2e:	0006a997          	auipc	s3,0x6a
    80004b32:	bb298993          	addi	s3,s3,-1102 # 8006e6e0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004b36:	40000b93          	li	s7,1024
    80004b3a:	a00d                	j	80004b5c <install_trans+0x5c>
    brelse(lbuf);
    80004b3c:	854a                	mv	a0,s2
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	066080e7          	jalr	102(ra) # 80003ba4 <brelse>
    brelse(dbuf);
    80004b46:	8526                	mv	a0,s1
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	05c080e7          	jalr	92(ra) # 80003ba4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b50:	2a05                	addiw	s4,s4,1
    80004b52:	0a91                	addi	s5,s5,4
    80004b54:	02c9a783          	lw	a5,44(s3)
    80004b58:	04fa5d63          	bge	s4,a5,80004bb2 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004b5c:	0189a583          	lw	a1,24(s3)
    80004b60:	014585bb          	addw	a1,a1,s4
    80004b64:	2585                	addiw	a1,a1,1
    80004b66:	0289a503          	lw	a0,40(s3)
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	f0a080e7          	jalr	-246(ra) # 80003a74 <bread>
    80004b72:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004b74:	000aa583          	lw	a1,0(s5)
    80004b78:	0289a503          	lw	a0,40(s3)
    80004b7c:	fffff097          	auipc	ra,0xfffff
    80004b80:	ef8080e7          	jalr	-264(ra) # 80003a74 <bread>
    80004b84:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004b86:	865e                	mv	a2,s7
    80004b88:	05890593          	addi	a1,s2,88
    80004b8c:	05850513          	addi	a0,a0,88
    80004b90:	ffffc097          	auipc	ra,0xffffc
    80004b94:	2fc080e7          	jalr	764(ra) # 80000e8c <memmove>
    bwrite(dbuf);  // write dst to disk
    80004b98:	8526                	mv	a0,s1
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	fcc080e7          	jalr	-52(ra) # 80003b66 <bwrite>
    if(recovering == 0)
    80004ba2:	f80b1de3          	bnez	s6,80004b3c <install_trans+0x3c>
      bunpin(dbuf);
    80004ba6:	8526                	mv	a0,s1
    80004ba8:	fffff097          	auipc	ra,0xfffff
    80004bac:	0d0080e7          	jalr	208(ra) # 80003c78 <bunpin>
    80004bb0:	b771                	j	80004b3c <install_trans+0x3c>
}
    80004bb2:	60a6                	ld	ra,72(sp)
    80004bb4:	6406                	ld	s0,64(sp)
    80004bb6:	74e2                	ld	s1,56(sp)
    80004bb8:	7942                	ld	s2,48(sp)
    80004bba:	79a2                	ld	s3,40(sp)
    80004bbc:	7a02                	ld	s4,32(sp)
    80004bbe:	6ae2                	ld	s5,24(sp)
    80004bc0:	6b42                	ld	s6,16(sp)
    80004bc2:	6ba2                	ld	s7,8(sp)
    80004bc4:	6161                	addi	sp,sp,80
    80004bc6:	8082                	ret
    80004bc8:	8082                	ret

0000000080004bca <initlog>:
{
    80004bca:	7179                	addi	sp,sp,-48
    80004bcc:	f406                	sd	ra,40(sp)
    80004bce:	f022                	sd	s0,32(sp)
    80004bd0:	ec26                	sd	s1,24(sp)
    80004bd2:	e84a                	sd	s2,16(sp)
    80004bd4:	e44e                	sd	s3,8(sp)
    80004bd6:	1800                	addi	s0,sp,48
    80004bd8:	892a                	mv	s2,a0
    80004bda:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004bdc:	0006a497          	auipc	s1,0x6a
    80004be0:	b0448493          	addi	s1,s1,-1276 # 8006e6e0 <log>
    80004be4:	00006597          	auipc	a1,0x6
    80004be8:	9bc58593          	addi	a1,a1,-1604 # 8000a5a0 <etext+0x5a0>
    80004bec:	8526                	mv	a0,s1
    80004bee:	ffffc097          	auipc	ra,0xffffc
    80004bf2:	0ac080e7          	jalr	172(ra) # 80000c9a <initlock>
  log.start = sb->logstart;
    80004bf6:	0149a583          	lw	a1,20(s3)
    80004bfa:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004bfc:	0109a783          	lw	a5,16(s3)
    80004c00:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004c02:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004c06:	854a                	mv	a0,s2
    80004c08:	fffff097          	auipc	ra,0xfffff
    80004c0c:	e6c080e7          	jalr	-404(ra) # 80003a74 <bread>
  log.lh.n = lh->n;
    80004c10:	4d30                	lw	a2,88(a0)
    80004c12:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004c14:	00c05f63          	blez	a2,80004c32 <initlog+0x68>
    80004c18:	87aa                	mv	a5,a0
    80004c1a:	0006a717          	auipc	a4,0x6a
    80004c1e:	af670713          	addi	a4,a4,-1290 # 8006e710 <log+0x30>
    80004c22:	060a                	slli	a2,a2,0x2
    80004c24:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004c26:	4ff4                	lw	a3,92(a5)
    80004c28:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004c2a:	0791                	addi	a5,a5,4
    80004c2c:	0711                	addi	a4,a4,4
    80004c2e:	fec79ce3          	bne	a5,a2,80004c26 <initlog+0x5c>
  brelse(buf);
    80004c32:	fffff097          	auipc	ra,0xfffff
    80004c36:	f72080e7          	jalr	-142(ra) # 80003ba4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004c3a:	4505                	li	a0,1
    80004c3c:	00000097          	auipc	ra,0x0
    80004c40:	ec4080e7          	jalr	-316(ra) # 80004b00 <install_trans>
  log.lh.n = 0;
    80004c44:	0006a797          	auipc	a5,0x6a
    80004c48:	ac07a423          	sw	zero,-1336(a5) # 8006e70c <log+0x2c>
  write_head(); // clear the log
    80004c4c:	00000097          	auipc	ra,0x0
    80004c50:	e4a080e7          	jalr	-438(ra) # 80004a96 <write_head>
}
    80004c54:	70a2                	ld	ra,40(sp)
    80004c56:	7402                	ld	s0,32(sp)
    80004c58:	64e2                	ld	s1,24(sp)
    80004c5a:	6942                	ld	s2,16(sp)
    80004c5c:	69a2                	ld	s3,8(sp)
    80004c5e:	6145                	addi	sp,sp,48
    80004c60:	8082                	ret

0000000080004c62 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004c62:	1101                	addi	sp,sp,-32
    80004c64:	ec06                	sd	ra,24(sp)
    80004c66:	e822                	sd	s0,16(sp)
    80004c68:	e426                	sd	s1,8(sp)
    80004c6a:	e04a                	sd	s2,0(sp)
    80004c6c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004c6e:	0006a517          	auipc	a0,0x6a
    80004c72:	a7250513          	addi	a0,a0,-1422 # 8006e6e0 <log>
    80004c76:	ffffc097          	auipc	ra,0xffffc
    80004c7a:	0be080e7          	jalr	190(ra) # 80000d34 <acquire>
  while(1){
    if(log.committing){
    80004c7e:	0006a497          	auipc	s1,0x6a
    80004c82:	a6248493          	addi	s1,s1,-1438 # 8006e6e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004c86:	4979                	li	s2,30
    80004c88:	a039                	j	80004c96 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004c8a:	85a6                	mv	a1,s1
    80004c8c:	8526                	mv	a0,s1
    80004c8e:	ffffe097          	auipc	ra,0xffffe
    80004c92:	aa6080e7          	jalr	-1370(ra) # 80002734 <sleep>
    if(log.committing){
    80004c96:	50dc                	lw	a5,36(s1)
    80004c98:	fbed                	bnez	a5,80004c8a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004c9a:	5098                	lw	a4,32(s1)
    80004c9c:	2705                	addiw	a4,a4,1
    80004c9e:	0027179b          	slliw	a5,a4,0x2
    80004ca2:	9fb9                	addw	a5,a5,a4
    80004ca4:	0017979b          	slliw	a5,a5,0x1
    80004ca8:	54d4                	lw	a3,44(s1)
    80004caa:	9fb5                	addw	a5,a5,a3
    80004cac:	00f95963          	bge	s2,a5,80004cbe <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004cb0:	85a6                	mv	a1,s1
    80004cb2:	8526                	mv	a0,s1
    80004cb4:	ffffe097          	auipc	ra,0xffffe
    80004cb8:	a80080e7          	jalr	-1408(ra) # 80002734 <sleep>
    80004cbc:	bfe9                	j	80004c96 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004cbe:	0006a797          	auipc	a5,0x6a
    80004cc2:	a4e7a123          	sw	a4,-1470(a5) # 8006e700 <log+0x20>
      release(&log.lock);
    80004cc6:	0006a517          	auipc	a0,0x6a
    80004cca:	a1a50513          	addi	a0,a0,-1510 # 8006e6e0 <log>
    80004cce:	ffffc097          	auipc	ra,0xffffc
    80004cd2:	116080e7          	jalr	278(ra) # 80000de4 <release>
      break;
    }
  }
}
    80004cd6:	60e2                	ld	ra,24(sp)
    80004cd8:	6442                	ld	s0,16(sp)
    80004cda:	64a2                	ld	s1,8(sp)
    80004cdc:	6902                	ld	s2,0(sp)
    80004cde:	6105                	addi	sp,sp,32
    80004ce0:	8082                	ret

0000000080004ce2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004ce2:	7139                	addi	sp,sp,-64
    80004ce4:	fc06                	sd	ra,56(sp)
    80004ce6:	f822                	sd	s0,48(sp)
    80004ce8:	f426                	sd	s1,40(sp)
    80004cea:	f04a                	sd	s2,32(sp)
    80004cec:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004cee:	0006a497          	auipc	s1,0x6a
    80004cf2:	9f248493          	addi	s1,s1,-1550 # 8006e6e0 <log>
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	ffffc097          	auipc	ra,0xffffc
    80004cfc:	03c080e7          	jalr	60(ra) # 80000d34 <acquire>
  log.outstanding -= 1;
    80004d00:	509c                	lw	a5,32(s1)
    80004d02:	37fd                	addiw	a5,a5,-1
    80004d04:	893e                	mv	s2,a5
    80004d06:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004d08:	50dc                	lw	a5,36(s1)
    80004d0a:	efb1                	bnez	a5,80004d66 <end_op+0x84>
    panic("log.committing");
  if(log.outstanding == 0){
    80004d0c:	06091863          	bnez	s2,80004d7c <end_op+0x9a>
    do_commit = 1;
    log.committing = 1;
    80004d10:	0006a497          	auipc	s1,0x6a
    80004d14:	9d048493          	addi	s1,s1,-1584 # 8006e6e0 <log>
    80004d18:	4785                	li	a5,1
    80004d1a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004d1c:	8526                	mv	a0,s1
    80004d1e:	ffffc097          	auipc	ra,0xffffc
    80004d22:	0c6080e7          	jalr	198(ra) # 80000de4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004d26:	54dc                	lw	a5,44(s1)
    80004d28:	08f04063          	bgtz	a5,80004da8 <end_op+0xc6>
    acquire(&log.lock);
    80004d2c:	0006a517          	auipc	a0,0x6a
    80004d30:	9b450513          	addi	a0,a0,-1612 # 8006e6e0 <log>
    80004d34:	ffffc097          	auipc	ra,0xffffc
    80004d38:	000080e7          	jalr	ra # 80000d34 <acquire>
    log.committing = 0;
    80004d3c:	0006a797          	auipc	a5,0x6a
    80004d40:	9c07a423          	sw	zero,-1592(a5) # 8006e704 <log+0x24>
    wakeup(&log);
    80004d44:	0006a517          	auipc	a0,0x6a
    80004d48:	99c50513          	addi	a0,a0,-1636 # 8006e6e0 <log>
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	a4c080e7          	jalr	-1460(ra) # 80002798 <wakeup>
    release(&log.lock);
    80004d54:	0006a517          	auipc	a0,0x6a
    80004d58:	98c50513          	addi	a0,a0,-1652 # 8006e6e0 <log>
    80004d5c:	ffffc097          	auipc	ra,0xffffc
    80004d60:	088080e7          	jalr	136(ra) # 80000de4 <release>
}
    80004d64:	a825                	j	80004d9c <end_op+0xba>
    80004d66:	ec4e                	sd	s3,24(sp)
    80004d68:	e852                	sd	s4,16(sp)
    80004d6a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004d6c:	00006517          	auipc	a0,0x6
    80004d70:	83c50513          	addi	a0,a0,-1988 # 8000a5a8 <etext+0x5a8>
    80004d74:	ffffb097          	auipc	ra,0xffffb
    80004d78:	7ea080e7          	jalr	2026(ra) # 8000055e <panic>
    wakeup(&log);
    80004d7c:	0006a517          	auipc	a0,0x6a
    80004d80:	96450513          	addi	a0,a0,-1692 # 8006e6e0 <log>
    80004d84:	ffffe097          	auipc	ra,0xffffe
    80004d88:	a14080e7          	jalr	-1516(ra) # 80002798 <wakeup>
  release(&log.lock);
    80004d8c:	0006a517          	auipc	a0,0x6a
    80004d90:	95450513          	addi	a0,a0,-1708 # 8006e6e0 <log>
    80004d94:	ffffc097          	auipc	ra,0xffffc
    80004d98:	050080e7          	jalr	80(ra) # 80000de4 <release>
}
    80004d9c:	70e2                	ld	ra,56(sp)
    80004d9e:	7442                	ld	s0,48(sp)
    80004da0:	74a2                	ld	s1,40(sp)
    80004da2:	7902                	ld	s2,32(sp)
    80004da4:	6121                	addi	sp,sp,64
    80004da6:	8082                	ret
    80004da8:	ec4e                	sd	s3,24(sp)
    80004daa:	e852                	sd	s4,16(sp)
    80004dac:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004dae:	0006aa97          	auipc	s5,0x6a
    80004db2:	962a8a93          	addi	s5,s5,-1694 # 8006e710 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004db6:	0006aa17          	auipc	s4,0x6a
    80004dba:	92aa0a13          	addi	s4,s4,-1750 # 8006e6e0 <log>
    80004dbe:	018a2583          	lw	a1,24(s4)
    80004dc2:	012585bb          	addw	a1,a1,s2
    80004dc6:	2585                	addiw	a1,a1,1
    80004dc8:	028a2503          	lw	a0,40(s4)
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	ca8080e7          	jalr	-856(ra) # 80003a74 <bread>
    80004dd4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004dd6:	000aa583          	lw	a1,0(s5)
    80004dda:	028a2503          	lw	a0,40(s4)
    80004dde:	fffff097          	auipc	ra,0xfffff
    80004de2:	c96080e7          	jalr	-874(ra) # 80003a74 <bread>
    80004de6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004de8:	40000613          	li	a2,1024
    80004dec:	05850593          	addi	a1,a0,88
    80004df0:	05848513          	addi	a0,s1,88
    80004df4:	ffffc097          	auipc	ra,0xffffc
    80004df8:	098080e7          	jalr	152(ra) # 80000e8c <memmove>
    bwrite(to);  // write the log
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	d68080e7          	jalr	-664(ra) # 80003b66 <bwrite>
    brelse(from);
    80004e06:	854e                	mv	a0,s3
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	d9c080e7          	jalr	-612(ra) # 80003ba4 <brelse>
    brelse(to);
    80004e10:	8526                	mv	a0,s1
    80004e12:	fffff097          	auipc	ra,0xfffff
    80004e16:	d92080e7          	jalr	-622(ra) # 80003ba4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e1a:	2905                	addiw	s2,s2,1
    80004e1c:	0a91                	addi	s5,s5,4
    80004e1e:	02ca2783          	lw	a5,44(s4)
    80004e22:	f8f94ee3          	blt	s2,a5,80004dbe <end_op+0xdc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004e26:	00000097          	auipc	ra,0x0
    80004e2a:	c70080e7          	jalr	-912(ra) # 80004a96 <write_head>
    install_trans(0); // Now install writes to home locations
    80004e2e:	4501                	li	a0,0
    80004e30:	00000097          	auipc	ra,0x0
    80004e34:	cd0080e7          	jalr	-816(ra) # 80004b00 <install_trans>
    log.lh.n = 0;
    80004e38:	0006a797          	auipc	a5,0x6a
    80004e3c:	8c07aa23          	sw	zero,-1836(a5) # 8006e70c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004e40:	00000097          	auipc	ra,0x0
    80004e44:	c56080e7          	jalr	-938(ra) # 80004a96 <write_head>
    80004e48:	69e2                	ld	s3,24(sp)
    80004e4a:	6a42                	ld	s4,16(sp)
    80004e4c:	6aa2                	ld	s5,8(sp)
    80004e4e:	bdf9                	j	80004d2c <end_op+0x4a>

0000000080004e50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004e50:	1101                	addi	sp,sp,-32
    80004e52:	ec06                	sd	ra,24(sp)
    80004e54:	e822                	sd	s0,16(sp)
    80004e56:	e426                	sd	s1,8(sp)
    80004e58:	1000                	addi	s0,sp,32
    80004e5a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004e5c:	0006a517          	auipc	a0,0x6a
    80004e60:	88450513          	addi	a0,a0,-1916 # 8006e6e0 <log>
    80004e64:	ffffc097          	auipc	ra,0xffffc
    80004e68:	ed0080e7          	jalr	-304(ra) # 80000d34 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004e6c:	0006a617          	auipc	a2,0x6a
    80004e70:	8a062603          	lw	a2,-1888(a2) # 8006e70c <log+0x2c>
    80004e74:	47f5                	li	a5,29
    80004e76:	06c7c663          	blt	a5,a2,80004ee2 <log_write+0x92>
    80004e7a:	0006a797          	auipc	a5,0x6a
    80004e7e:	8827a783          	lw	a5,-1918(a5) # 8006e6fc <log+0x1c>
    80004e82:	37fd                	addiw	a5,a5,-1
    80004e84:	04f65f63          	bge	a2,a5,80004ee2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004e88:	0006a797          	auipc	a5,0x6a
    80004e8c:	8787a783          	lw	a5,-1928(a5) # 8006e700 <log+0x20>
    80004e90:	06f05163          	blez	a5,80004ef2 <log_write+0xa2>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004e94:	4781                	li	a5,0
    80004e96:	06c05663          	blez	a2,80004f02 <log_write+0xb2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004e9a:	44cc                	lw	a1,12(s1)
    80004e9c:	0006a717          	auipc	a4,0x6a
    80004ea0:	87470713          	addi	a4,a4,-1932 # 8006e710 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004ea4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004ea6:	4314                	lw	a3,0(a4)
    80004ea8:	04b68d63          	beq	a3,a1,80004f02 <log_write+0xb2>
  for (i = 0; i < log.lh.n; i++) {
    80004eac:	2785                	addiw	a5,a5,1
    80004eae:	0711                	addi	a4,a4,4
    80004eb0:	fef61be3          	bne	a2,a5,80004ea6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004eb4:	060a                	slli	a2,a2,0x2
    80004eb6:	02060613          	addi	a2,a2,32
    80004eba:	0006a797          	auipc	a5,0x6a
    80004ebe:	82678793          	addi	a5,a5,-2010 # 8006e6e0 <log>
    80004ec2:	97b2                	add	a5,a5,a2
    80004ec4:	44d8                	lw	a4,12(s1)
    80004ec6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004ec8:	8526                	mv	a0,s1
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	d72080e7          	jalr	-654(ra) # 80003c3c <bpin>
    log.lh.n++;
    80004ed2:	0006a717          	auipc	a4,0x6a
    80004ed6:	80e70713          	addi	a4,a4,-2034 # 8006e6e0 <log>
    80004eda:	575c                	lw	a5,44(a4)
    80004edc:	2785                	addiw	a5,a5,1
    80004ede:	d75c                	sw	a5,44(a4)
    80004ee0:	a835                	j	80004f1c <log_write+0xcc>
    panic("too big a transaction");
    80004ee2:	00005517          	auipc	a0,0x5
    80004ee6:	6d650513          	addi	a0,a0,1750 # 8000a5b8 <etext+0x5b8>
    80004eea:	ffffb097          	auipc	ra,0xffffb
    80004eee:	674080e7          	jalr	1652(ra) # 8000055e <panic>
    panic("log_write outside of trans");
    80004ef2:	00005517          	auipc	a0,0x5
    80004ef6:	6de50513          	addi	a0,a0,1758 # 8000a5d0 <etext+0x5d0>
    80004efa:	ffffb097          	auipc	ra,0xffffb
    80004efe:	664080e7          	jalr	1636(ra) # 8000055e <panic>
  log.lh.block[i] = b->blockno;
    80004f02:	00279693          	slli	a3,a5,0x2
    80004f06:	02068693          	addi	a3,a3,32
    80004f0a:	00069717          	auipc	a4,0x69
    80004f0e:	7d670713          	addi	a4,a4,2006 # 8006e6e0 <log>
    80004f12:	9736                	add	a4,a4,a3
    80004f14:	44d4                	lw	a3,12(s1)
    80004f16:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004f18:	faf608e3          	beq	a2,a5,80004ec8 <log_write+0x78>
  }
  release(&log.lock);
    80004f1c:	00069517          	auipc	a0,0x69
    80004f20:	7c450513          	addi	a0,a0,1988 # 8006e6e0 <log>
    80004f24:	ffffc097          	auipc	ra,0xffffc
    80004f28:	ec0080e7          	jalr	-320(ra) # 80000de4 <release>
}
    80004f2c:	60e2                	ld	ra,24(sp)
    80004f2e:	6442                	ld	s0,16(sp)
    80004f30:	64a2                	ld	s1,8(sp)
    80004f32:	6105                	addi	sp,sp,32
    80004f34:	8082                	ret

0000000080004f36 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004f36:	1101                	addi	sp,sp,-32
    80004f38:	ec06                	sd	ra,24(sp)
    80004f3a:	e822                	sd	s0,16(sp)
    80004f3c:	e426                	sd	s1,8(sp)
    80004f3e:	e04a                	sd	s2,0(sp)
    80004f40:	1000                	addi	s0,sp,32
    80004f42:	84aa                	mv	s1,a0
    80004f44:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004f46:	00005597          	auipc	a1,0x5
    80004f4a:	6aa58593          	addi	a1,a1,1706 # 8000a5f0 <etext+0x5f0>
    80004f4e:	0521                	addi	a0,a0,8
    80004f50:	ffffc097          	auipc	ra,0xffffc
    80004f54:	d4a080e7          	jalr	-694(ra) # 80000c9a <initlock>
  lk->name = name;
    80004f58:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004f5c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004f60:	0204a423          	sw	zero,40(s1)
}
    80004f64:	60e2                	ld	ra,24(sp)
    80004f66:	6442                	ld	s0,16(sp)
    80004f68:	64a2                	ld	s1,8(sp)
    80004f6a:	6902                	ld	s2,0(sp)
    80004f6c:	6105                	addi	sp,sp,32
    80004f6e:	8082                	ret

0000000080004f70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004f70:	1101                	addi	sp,sp,-32
    80004f72:	ec06                	sd	ra,24(sp)
    80004f74:	e822                	sd	s0,16(sp)
    80004f76:	e426                	sd	s1,8(sp)
    80004f78:	e04a                	sd	s2,0(sp)
    80004f7a:	1000                	addi	s0,sp,32
    80004f7c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004f7e:	00850913          	addi	s2,a0,8
    80004f82:	854a                	mv	a0,s2
    80004f84:	ffffc097          	auipc	ra,0xffffc
    80004f88:	db0080e7          	jalr	-592(ra) # 80000d34 <acquire>
  while (lk->locked) {
    80004f8c:	409c                	lw	a5,0(s1)
    80004f8e:	cb89                	beqz	a5,80004fa0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004f90:	85ca                	mv	a1,s2
    80004f92:	8526                	mv	a0,s1
    80004f94:	ffffd097          	auipc	ra,0xffffd
    80004f98:	7a0080e7          	jalr	1952(ra) # 80002734 <sleep>
  while (lk->locked) {
    80004f9c:	409c                	lw	a5,0(s1)
    80004f9e:	fbed                	bnez	a5,80004f90 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004fa0:	4785                	li	a5,1
    80004fa2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004fa4:	ffffd097          	auipc	ra,0xffffd
    80004fa8:	eda080e7          	jalr	-294(ra) # 80001e7e <myproc>
    80004fac:	591c                	lw	a5,48(a0)
    80004fae:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004fb0:	854a                	mv	a0,s2
    80004fb2:	ffffc097          	auipc	ra,0xffffc
    80004fb6:	e32080e7          	jalr	-462(ra) # 80000de4 <release>
}
    80004fba:	60e2                	ld	ra,24(sp)
    80004fbc:	6442                	ld	s0,16(sp)
    80004fbe:	64a2                	ld	s1,8(sp)
    80004fc0:	6902                	ld	s2,0(sp)
    80004fc2:	6105                	addi	sp,sp,32
    80004fc4:	8082                	ret

0000000080004fc6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004fc6:	1101                	addi	sp,sp,-32
    80004fc8:	ec06                	sd	ra,24(sp)
    80004fca:	e822                	sd	s0,16(sp)
    80004fcc:	e426                	sd	s1,8(sp)
    80004fce:	e04a                	sd	s2,0(sp)
    80004fd0:	1000                	addi	s0,sp,32
    80004fd2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004fd4:	00850913          	addi	s2,a0,8
    80004fd8:	854a                	mv	a0,s2
    80004fda:	ffffc097          	auipc	ra,0xffffc
    80004fde:	d5a080e7          	jalr	-678(ra) # 80000d34 <acquire>
  lk->locked = 0;
    80004fe2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004fe6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004fea:	8526                	mv	a0,s1
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	7ac080e7          	jalr	1964(ra) # 80002798 <wakeup>
  release(&lk->lk);
    80004ff4:	854a                	mv	a0,s2
    80004ff6:	ffffc097          	auipc	ra,0xffffc
    80004ffa:	dee080e7          	jalr	-530(ra) # 80000de4 <release>
}
    80004ffe:	60e2                	ld	ra,24(sp)
    80005000:	6442                	ld	s0,16(sp)
    80005002:	64a2                	ld	s1,8(sp)
    80005004:	6902                	ld	s2,0(sp)
    80005006:	6105                	addi	sp,sp,32
    80005008:	8082                	ret

000000008000500a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000500a:	7179                	addi	sp,sp,-48
    8000500c:	f406                	sd	ra,40(sp)
    8000500e:	f022                	sd	s0,32(sp)
    80005010:	ec26                	sd	s1,24(sp)
    80005012:	e84a                	sd	s2,16(sp)
    80005014:	1800                	addi	s0,sp,48
    80005016:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80005018:	00850913          	addi	s2,a0,8
    8000501c:	854a                	mv	a0,s2
    8000501e:	ffffc097          	auipc	ra,0xffffc
    80005022:	d16080e7          	jalr	-746(ra) # 80000d34 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80005026:	409c                	lw	a5,0(s1)
    80005028:	ef91                	bnez	a5,80005044 <holdingsleep+0x3a>
    8000502a:	4481                	li	s1,0
  release(&lk->lk);
    8000502c:	854a                	mv	a0,s2
    8000502e:	ffffc097          	auipc	ra,0xffffc
    80005032:	db6080e7          	jalr	-586(ra) # 80000de4 <release>
  return r;
}
    80005036:	8526                	mv	a0,s1
    80005038:	70a2                	ld	ra,40(sp)
    8000503a:	7402                	ld	s0,32(sp)
    8000503c:	64e2                	ld	s1,24(sp)
    8000503e:	6942                	ld	s2,16(sp)
    80005040:	6145                	addi	sp,sp,48
    80005042:	8082                	ret
    80005044:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80005046:	0284a983          	lw	s3,40(s1)
    8000504a:	ffffd097          	auipc	ra,0xffffd
    8000504e:	e34080e7          	jalr	-460(ra) # 80001e7e <myproc>
    80005052:	5904                	lw	s1,48(a0)
    80005054:	413484b3          	sub	s1,s1,s3
    80005058:	0014b493          	seqz	s1,s1
    8000505c:	69a2                	ld	s3,8(sp)
    8000505e:	b7f9                	j	8000502c <holdingsleep+0x22>

0000000080005060 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005060:	1141                	addi	sp,sp,-16
    80005062:	e406                	sd	ra,8(sp)
    80005064:	e022                	sd	s0,0(sp)
    80005066:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005068:	00005597          	auipc	a1,0x5
    8000506c:	59858593          	addi	a1,a1,1432 # 8000a600 <etext+0x600>
    80005070:	00069517          	auipc	a0,0x69
    80005074:	7b850513          	addi	a0,a0,1976 # 8006e828 <ftable>
    80005078:	ffffc097          	auipc	ra,0xffffc
    8000507c:	c22080e7          	jalr	-990(ra) # 80000c9a <initlock>
}
    80005080:	60a2                	ld	ra,8(sp)
    80005082:	6402                	ld	s0,0(sp)
    80005084:	0141                	addi	sp,sp,16
    80005086:	8082                	ret

0000000080005088 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005088:	1101                	addi	sp,sp,-32
    8000508a:	ec06                	sd	ra,24(sp)
    8000508c:	e822                	sd	s0,16(sp)
    8000508e:	e426                	sd	s1,8(sp)
    80005090:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005092:	00069517          	auipc	a0,0x69
    80005096:	79650513          	addi	a0,a0,1942 # 8006e828 <ftable>
    8000509a:	ffffc097          	auipc	ra,0xffffc
    8000509e:	c9a080e7          	jalr	-870(ra) # 80000d34 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800050a2:	00069497          	auipc	s1,0x69
    800050a6:	79e48493          	addi	s1,s1,1950 # 8006e840 <ftable+0x18>
    800050aa:	0006a717          	auipc	a4,0x6a
    800050ae:	73670713          	addi	a4,a4,1846 # 8006f7e0 <disk>
    if(f->ref == 0){
    800050b2:	40dc                	lw	a5,4(s1)
    800050b4:	cf99                	beqz	a5,800050d2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800050b6:	02848493          	addi	s1,s1,40
    800050ba:	fee49ce3          	bne	s1,a4,800050b2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800050be:	00069517          	auipc	a0,0x69
    800050c2:	76a50513          	addi	a0,a0,1898 # 8006e828 <ftable>
    800050c6:	ffffc097          	auipc	ra,0xffffc
    800050ca:	d1e080e7          	jalr	-738(ra) # 80000de4 <release>
  return 0;
    800050ce:	4481                	li	s1,0
    800050d0:	a819                	j	800050e6 <filealloc+0x5e>
      f->ref = 1;
    800050d2:	4785                	li	a5,1
    800050d4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800050d6:	00069517          	auipc	a0,0x69
    800050da:	75250513          	addi	a0,a0,1874 # 8006e828 <ftable>
    800050de:	ffffc097          	auipc	ra,0xffffc
    800050e2:	d06080e7          	jalr	-762(ra) # 80000de4 <release>
}
    800050e6:	8526                	mv	a0,s1
    800050e8:	60e2                	ld	ra,24(sp)
    800050ea:	6442                	ld	s0,16(sp)
    800050ec:	64a2                	ld	s1,8(sp)
    800050ee:	6105                	addi	sp,sp,32
    800050f0:	8082                	ret

00000000800050f2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800050f2:	1101                	addi	sp,sp,-32
    800050f4:	ec06                	sd	ra,24(sp)
    800050f6:	e822                	sd	s0,16(sp)
    800050f8:	e426                	sd	s1,8(sp)
    800050fa:	1000                	addi	s0,sp,32
    800050fc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800050fe:	00069517          	auipc	a0,0x69
    80005102:	72a50513          	addi	a0,a0,1834 # 8006e828 <ftable>
    80005106:	ffffc097          	auipc	ra,0xffffc
    8000510a:	c2e080e7          	jalr	-978(ra) # 80000d34 <acquire>
  if(f->ref < 1)
    8000510e:	40dc                	lw	a5,4(s1)
    80005110:	02f05263          	blez	a5,80005134 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80005114:	2785                	addiw	a5,a5,1
    80005116:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80005118:	00069517          	auipc	a0,0x69
    8000511c:	71050513          	addi	a0,a0,1808 # 8006e828 <ftable>
    80005120:	ffffc097          	auipc	ra,0xffffc
    80005124:	cc4080e7          	jalr	-828(ra) # 80000de4 <release>
  return f;
}
    80005128:	8526                	mv	a0,s1
    8000512a:	60e2                	ld	ra,24(sp)
    8000512c:	6442                	ld	s0,16(sp)
    8000512e:	64a2                	ld	s1,8(sp)
    80005130:	6105                	addi	sp,sp,32
    80005132:	8082                	ret
    panic("filedup");
    80005134:	00005517          	auipc	a0,0x5
    80005138:	4d450513          	addi	a0,a0,1236 # 8000a608 <etext+0x608>
    8000513c:	ffffb097          	auipc	ra,0xffffb
    80005140:	422080e7          	jalr	1058(ra) # 8000055e <panic>

0000000080005144 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005144:	7139                	addi	sp,sp,-64
    80005146:	fc06                	sd	ra,56(sp)
    80005148:	f822                	sd	s0,48(sp)
    8000514a:	f426                	sd	s1,40(sp)
    8000514c:	0080                	addi	s0,sp,64
    8000514e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005150:	00069517          	auipc	a0,0x69
    80005154:	6d850513          	addi	a0,a0,1752 # 8006e828 <ftable>
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	bdc080e7          	jalr	-1060(ra) # 80000d34 <acquire>
  if(f->ref < 1)
    80005160:	40dc                	lw	a5,4(s1)
    80005162:	04f05c63          	blez	a5,800051ba <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80005166:	37fd                	addiw	a5,a5,-1
    80005168:	c0dc                	sw	a5,4(s1)
    8000516a:	06f04463          	bgtz	a5,800051d2 <fileclose+0x8e>
    8000516e:	f04a                	sd	s2,32(sp)
    80005170:	ec4e                	sd	s3,24(sp)
    80005172:	e852                	sd	s4,16(sp)
    80005174:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80005176:	0004a903          	lw	s2,0(s1)
    8000517a:	0094c783          	lbu	a5,9(s1)
    8000517e:	89be                	mv	s3,a5
    80005180:	689c                	ld	a5,16(s1)
    80005182:	8a3e                	mv	s4,a5
    80005184:	6c9c                	ld	a5,24(s1)
    80005186:	8abe                	mv	s5,a5
  f->ref = 0;
    80005188:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000518c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80005190:	00069517          	auipc	a0,0x69
    80005194:	69850513          	addi	a0,a0,1688 # 8006e828 <ftable>
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	c4c080e7          	jalr	-948(ra) # 80000de4 <release>

  if(ff.type == FD_PIPE){
    800051a0:	4785                	li	a5,1
    800051a2:	04f90563          	beq	s2,a5,800051ec <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800051a6:	ffe9079b          	addiw	a5,s2,-2
    800051aa:	4705                	li	a4,1
    800051ac:	04f77b63          	bgeu	a4,a5,80005202 <fileclose+0xbe>
    800051b0:	7902                	ld	s2,32(sp)
    800051b2:	69e2                	ld	s3,24(sp)
    800051b4:	6a42                	ld	s4,16(sp)
    800051b6:	6aa2                	ld	s5,8(sp)
    800051b8:	a02d                	j	800051e2 <fileclose+0x9e>
    800051ba:	f04a                	sd	s2,32(sp)
    800051bc:	ec4e                	sd	s3,24(sp)
    800051be:	e852                	sd	s4,16(sp)
    800051c0:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800051c2:	00005517          	auipc	a0,0x5
    800051c6:	44e50513          	addi	a0,a0,1102 # 8000a610 <etext+0x610>
    800051ca:	ffffb097          	auipc	ra,0xffffb
    800051ce:	394080e7          	jalr	916(ra) # 8000055e <panic>
    release(&ftable.lock);
    800051d2:	00069517          	auipc	a0,0x69
    800051d6:	65650513          	addi	a0,a0,1622 # 8006e828 <ftable>
    800051da:	ffffc097          	auipc	ra,0xffffc
    800051de:	c0a080e7          	jalr	-1014(ra) # 80000de4 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800051e2:	70e2                	ld	ra,56(sp)
    800051e4:	7442                	ld	s0,48(sp)
    800051e6:	74a2                	ld	s1,40(sp)
    800051e8:	6121                	addi	sp,sp,64
    800051ea:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800051ec:	85ce                	mv	a1,s3
    800051ee:	8552                	mv	a0,s4
    800051f0:	00000097          	auipc	ra,0x0
    800051f4:	3b4080e7          	jalr	948(ra) # 800055a4 <pipeclose>
    800051f8:	7902                	ld	s2,32(sp)
    800051fa:	69e2                	ld	s3,24(sp)
    800051fc:	6a42                	ld	s4,16(sp)
    800051fe:	6aa2                	ld	s5,8(sp)
    80005200:	b7cd                	j	800051e2 <fileclose+0x9e>
    begin_op();
    80005202:	00000097          	auipc	ra,0x0
    80005206:	a60080e7          	jalr	-1440(ra) # 80004c62 <begin_op>
    iput(ff.ip);
    8000520a:	8556                	mv	a0,s5
    8000520c:	fffff097          	auipc	ra,0xfffff
    80005210:	224080e7          	jalr	548(ra) # 80004430 <iput>
    end_op();
    80005214:	00000097          	auipc	ra,0x0
    80005218:	ace080e7          	jalr	-1330(ra) # 80004ce2 <end_op>
    8000521c:	7902                	ld	s2,32(sp)
    8000521e:	69e2                	ld	s3,24(sp)
    80005220:	6a42                	ld	s4,16(sp)
    80005222:	6aa2                	ld	s5,8(sp)
    80005224:	bf7d                	j	800051e2 <fileclose+0x9e>

0000000080005226 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005226:	715d                	addi	sp,sp,-80
    80005228:	e486                	sd	ra,72(sp)
    8000522a:	e0a2                	sd	s0,64(sp)
    8000522c:	fc26                	sd	s1,56(sp)
    8000522e:	f052                	sd	s4,32(sp)
    80005230:	0880                	addi	s0,sp,80
    80005232:	84aa                	mv	s1,a0
    80005234:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80005236:	ffffd097          	auipc	ra,0xffffd
    8000523a:	c48080e7          	jalr	-952(ra) # 80001e7e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000523e:	409c                	lw	a5,0(s1)
    80005240:	37f9                	addiw	a5,a5,-2
    80005242:	4705                	li	a4,1
    80005244:	04f76a63          	bltu	a4,a5,80005298 <filestat+0x72>
    80005248:	f84a                	sd	s2,48(sp)
    8000524a:	f44e                	sd	s3,40(sp)
    8000524c:	89aa                	mv	s3,a0
    ilock(f->ip);
    8000524e:	6c88                	ld	a0,24(s1)
    80005250:	fffff097          	auipc	ra,0xfffff
    80005254:	022080e7          	jalr	34(ra) # 80004272 <ilock>
    stati(f->ip, &st);
    80005258:	fb840913          	addi	s2,s0,-72
    8000525c:	85ca                	mv	a1,s2
    8000525e:	6c88                	ld	a0,24(s1)
    80005260:	fffff097          	auipc	ra,0xfffff
    80005264:	2a2080e7          	jalr	674(ra) # 80004502 <stati>
    iunlock(f->ip);
    80005268:	6c88                	ld	a0,24(s1)
    8000526a:	fffff097          	auipc	ra,0xfffff
    8000526e:	0ce080e7          	jalr	206(ra) # 80004338 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80005272:	46e1                	li	a3,24
    80005274:	864a                	mv	a2,s2
    80005276:	85d2                	mv	a1,s4
    80005278:	0509b503          	ld	a0,80(s3)
    8000527c:	ffffd097          	auipc	ra,0xffffd
    80005280:	88e080e7          	jalr	-1906(ra) # 80001b0a <copyout>
    80005284:	41f5551b          	sraiw	a0,a0,0x1f
    80005288:	7942                	ld	s2,48(sp)
    8000528a:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000528c:	60a6                	ld	ra,72(sp)
    8000528e:	6406                	ld	s0,64(sp)
    80005290:	74e2                	ld	s1,56(sp)
    80005292:	7a02                	ld	s4,32(sp)
    80005294:	6161                	addi	sp,sp,80
    80005296:	8082                	ret
  return -1;
    80005298:	557d                	li	a0,-1
    8000529a:	bfcd                	j	8000528c <filestat+0x66>

000000008000529c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000529c:	7179                	addi	sp,sp,-48
    8000529e:	f406                	sd	ra,40(sp)
    800052a0:	f022                	sd	s0,32(sp)
    800052a2:	e84a                	sd	s2,16(sp)
    800052a4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800052a6:	00854783          	lbu	a5,8(a0)
    800052aa:	cbc5                	beqz	a5,8000535a <fileread+0xbe>
    800052ac:	ec26                	sd	s1,24(sp)
    800052ae:	e44e                	sd	s3,8(sp)
    800052b0:	84aa                	mv	s1,a0
    800052b2:	892e                	mv	s2,a1
    800052b4:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800052b6:	411c                	lw	a5,0(a0)
    800052b8:	4705                	li	a4,1
    800052ba:	04e78963          	beq	a5,a4,8000530c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800052be:	470d                	li	a4,3
    800052c0:	04e78f63          	beq	a5,a4,8000531e <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800052c4:	4709                	li	a4,2
    800052c6:	08e79263          	bne	a5,a4,8000534a <fileread+0xae>
    ilock(f->ip);
    800052ca:	6d08                	ld	a0,24(a0)
    800052cc:	fffff097          	auipc	ra,0xfffff
    800052d0:	fa6080e7          	jalr	-90(ra) # 80004272 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800052d4:	874e                	mv	a4,s3
    800052d6:	5094                	lw	a3,32(s1)
    800052d8:	864a                	mv	a2,s2
    800052da:	4585                	li	a1,1
    800052dc:	6c88                	ld	a0,24(s1)
    800052de:	fffff097          	auipc	ra,0xfffff
    800052e2:	252080e7          	jalr	594(ra) # 80004530 <readi>
    800052e6:	892a                	mv	s2,a0
    800052e8:	00a05563          	blez	a0,800052f2 <fileread+0x56>
      f->off += r;
    800052ec:	509c                	lw	a5,32(s1)
    800052ee:	9fa9                	addw	a5,a5,a0
    800052f0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800052f2:	6c88                	ld	a0,24(s1)
    800052f4:	fffff097          	auipc	ra,0xfffff
    800052f8:	044080e7          	jalr	68(ra) # 80004338 <iunlock>
    800052fc:	64e2                	ld	s1,24(sp)
    800052fe:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80005300:	854a                	mv	a0,s2
    80005302:	70a2                	ld	ra,40(sp)
    80005304:	7402                	ld	s0,32(sp)
    80005306:	6942                	ld	s2,16(sp)
    80005308:	6145                	addi	sp,sp,48
    8000530a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000530c:	6908                	ld	a0,16(a0)
    8000530e:	00000097          	auipc	ra,0x0
    80005312:	428080e7          	jalr	1064(ra) # 80005736 <piperead>
    80005316:	892a                	mv	s2,a0
    80005318:	64e2                	ld	s1,24(sp)
    8000531a:	69a2                	ld	s3,8(sp)
    8000531c:	b7d5                	j	80005300 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000531e:	02451783          	lh	a5,36(a0)
    80005322:	03079693          	slli	a3,a5,0x30
    80005326:	92c1                	srli	a3,a3,0x30
    80005328:	4725                	li	a4,9
    8000532a:	02d76b63          	bltu	a4,a3,80005360 <fileread+0xc4>
    8000532e:	0792                	slli	a5,a5,0x4
    80005330:	00069717          	auipc	a4,0x69
    80005334:	45870713          	addi	a4,a4,1112 # 8006e788 <devsw>
    80005338:	97ba                	add	a5,a5,a4
    8000533a:	639c                	ld	a5,0(a5)
    8000533c:	c79d                	beqz	a5,8000536a <fileread+0xce>
    r = devsw[f->major].read(1, addr, n);
    8000533e:	4505                	li	a0,1
    80005340:	9782                	jalr	a5
    80005342:	892a                	mv	s2,a0
    80005344:	64e2                	ld	s1,24(sp)
    80005346:	69a2                	ld	s3,8(sp)
    80005348:	bf65                	j	80005300 <fileread+0x64>
    panic("fileread");
    8000534a:	00005517          	auipc	a0,0x5
    8000534e:	2d650513          	addi	a0,a0,726 # 8000a620 <etext+0x620>
    80005352:	ffffb097          	auipc	ra,0xffffb
    80005356:	20c080e7          	jalr	524(ra) # 8000055e <panic>
    return -1;
    8000535a:	57fd                	li	a5,-1
    8000535c:	893e                	mv	s2,a5
    8000535e:	b74d                	j	80005300 <fileread+0x64>
      return -1;
    80005360:	57fd                	li	a5,-1
    80005362:	893e                	mv	s2,a5
    80005364:	64e2                	ld	s1,24(sp)
    80005366:	69a2                	ld	s3,8(sp)
    80005368:	bf61                	j	80005300 <fileread+0x64>
    8000536a:	57fd                	li	a5,-1
    8000536c:	893e                	mv	s2,a5
    8000536e:	64e2                	ld	s1,24(sp)
    80005370:	69a2                	ld	s3,8(sp)
    80005372:	b779                	j	80005300 <fileread+0x64>

0000000080005374 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80005374:	00954783          	lbu	a5,9(a0)
    80005378:	12078d63          	beqz	a5,800054b2 <filewrite+0x13e>
{
    8000537c:	711d                	addi	sp,sp,-96
    8000537e:	ec86                	sd	ra,88(sp)
    80005380:	e8a2                	sd	s0,80(sp)
    80005382:	e0ca                	sd	s2,64(sp)
    80005384:	f456                	sd	s5,40(sp)
    80005386:	f05a                	sd	s6,32(sp)
    80005388:	1080                	addi	s0,sp,96
    8000538a:	892a                	mv	s2,a0
    8000538c:	8b2e                	mv	s6,a1
    8000538e:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80005390:	411c                	lw	a5,0(a0)
    80005392:	4705                	li	a4,1
    80005394:	02e78a63          	beq	a5,a4,800053c8 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005398:	470d                	li	a4,3
    8000539a:	02e78d63          	beq	a5,a4,800053d4 <filewrite+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000539e:	4709                	li	a4,2
    800053a0:	0ee79b63          	bne	a5,a4,80005496 <filewrite+0x122>
    800053a4:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800053a6:	0cc05663          	blez	a2,80005472 <filewrite+0xfe>
    800053aa:	e4a6                	sd	s1,72(sp)
    800053ac:	fc4e                	sd	s3,56(sp)
    800053ae:	ec5e                	sd	s7,24(sp)
    800053b0:	e862                	sd	s8,16(sp)
    800053b2:	e466                	sd	s9,8(sp)
    int i = 0;
    800053b4:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800053b6:	6b85                	lui	s7,0x1
    800053b8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800053bc:	6785                	lui	a5,0x1
    800053be:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800053c2:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800053c4:	4c05                	li	s8,1
    800053c6:	a849                	j	80005458 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800053c8:	6908                	ld	a0,16(a0)
    800053ca:	00000097          	auipc	ra,0x0
    800053ce:	250080e7          	jalr	592(ra) # 8000561a <pipewrite>
    800053d2:	a85d                	j	80005488 <filewrite+0x114>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800053d4:	02451783          	lh	a5,36(a0)
    800053d8:	03079693          	slli	a3,a5,0x30
    800053dc:	92c1                	srli	a3,a3,0x30
    800053de:	4725                	li	a4,9
    800053e0:	0cd76b63          	bltu	a4,a3,800054b6 <filewrite+0x142>
    800053e4:	0792                	slli	a5,a5,0x4
    800053e6:	00069717          	auipc	a4,0x69
    800053ea:	3a270713          	addi	a4,a4,930 # 8006e788 <devsw>
    800053ee:	97ba                	add	a5,a5,a4
    800053f0:	679c                	ld	a5,8(a5)
    800053f2:	c7e1                	beqz	a5,800054ba <filewrite+0x146>
    ret = devsw[f->major].write(1, addr, n);
    800053f4:	4505                	li	a0,1
    800053f6:	9782                	jalr	a5
    800053f8:	a841                	j	80005488 <filewrite+0x114>
      if(n1 > max)
    800053fa:	2981                	sext.w	s3,s3
      begin_op();
    800053fc:	00000097          	auipc	ra,0x0
    80005400:	866080e7          	jalr	-1946(ra) # 80004c62 <begin_op>
      ilock(f->ip);
    80005404:	01893503          	ld	a0,24(s2)
    80005408:	fffff097          	auipc	ra,0xfffff
    8000540c:	e6a080e7          	jalr	-406(ra) # 80004272 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005410:	874e                	mv	a4,s3
    80005412:	02092683          	lw	a3,32(s2)
    80005416:	016a0633          	add	a2,s4,s6
    8000541a:	85e2                	mv	a1,s8
    8000541c:	01893503          	ld	a0,24(s2)
    80005420:	fffff097          	auipc	ra,0xfffff
    80005424:	216080e7          	jalr	534(ra) # 80004636 <writei>
    80005428:	84aa                	mv	s1,a0
    8000542a:	00a05763          	blez	a0,80005438 <filewrite+0xc4>
        f->off += r;
    8000542e:	02092783          	lw	a5,32(s2)
    80005432:	9fa9                	addw	a5,a5,a0
    80005434:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005438:	01893503          	ld	a0,24(s2)
    8000543c:	fffff097          	auipc	ra,0xfffff
    80005440:	efc080e7          	jalr	-260(ra) # 80004338 <iunlock>
      end_op();
    80005444:	00000097          	auipc	ra,0x0
    80005448:	89e080e7          	jalr	-1890(ra) # 80004ce2 <end_op>

      if(r != n1){
    8000544c:	02999563          	bne	s3,s1,80005476 <filewrite+0x102>
        // error from writei
        break;
      }
      i += r;
    80005450:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80005454:	015a5963          	bge	s4,s5,80005466 <filewrite+0xf2>
      int n1 = n - i;
    80005458:	414a87bb          	subw	a5,s5,s4
    8000545c:	89be                	mv	s3,a5
      if(n1 > max)
    8000545e:	f8fbdee3          	bge	s7,a5,800053fa <filewrite+0x86>
    80005462:	89e6                	mv	s3,s9
    80005464:	bf59                	j	800053fa <filewrite+0x86>
    80005466:	64a6                	ld	s1,72(sp)
    80005468:	79e2                	ld	s3,56(sp)
    8000546a:	6be2                	ld	s7,24(sp)
    8000546c:	6c42                	ld	s8,16(sp)
    8000546e:	6ca2                	ld	s9,8(sp)
    80005470:	a801                	j	80005480 <filewrite+0x10c>
    int i = 0;
    80005472:	4a01                	li	s4,0
    80005474:	a031                	j	80005480 <filewrite+0x10c>
    80005476:	64a6                	ld	s1,72(sp)
    80005478:	79e2                	ld	s3,56(sp)
    8000547a:	6be2                	ld	s7,24(sp)
    8000547c:	6c42                	ld	s8,16(sp)
    8000547e:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80005480:	034a9f63          	bne	s5,s4,800054be <filewrite+0x14a>
    80005484:	8556                	mv	a0,s5
    80005486:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005488:	60e6                	ld	ra,88(sp)
    8000548a:	6446                	ld	s0,80(sp)
    8000548c:	6906                	ld	s2,64(sp)
    8000548e:	7aa2                	ld	s5,40(sp)
    80005490:	7b02                	ld	s6,32(sp)
    80005492:	6125                	addi	sp,sp,96
    80005494:	8082                	ret
    80005496:	e4a6                	sd	s1,72(sp)
    80005498:	fc4e                	sd	s3,56(sp)
    8000549a:	f852                	sd	s4,48(sp)
    8000549c:	ec5e                	sd	s7,24(sp)
    8000549e:	e862                	sd	s8,16(sp)
    800054a0:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800054a2:	00005517          	auipc	a0,0x5
    800054a6:	18e50513          	addi	a0,a0,398 # 8000a630 <etext+0x630>
    800054aa:	ffffb097          	auipc	ra,0xffffb
    800054ae:	0b4080e7          	jalr	180(ra) # 8000055e <panic>
    return -1;
    800054b2:	557d                	li	a0,-1
}
    800054b4:	8082                	ret
      return -1;
    800054b6:	557d                	li	a0,-1
    800054b8:	bfc1                	j	80005488 <filewrite+0x114>
    800054ba:	557d                	li	a0,-1
    800054bc:	b7f1                	j	80005488 <filewrite+0x114>
    ret = (i == n ? n : -1);
    800054be:	557d                	li	a0,-1
    800054c0:	7a42                	ld	s4,48(sp)
    800054c2:	b7d9                	j	80005488 <filewrite+0x114>

00000000800054c4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800054c4:	7179                	addi	sp,sp,-48
    800054c6:	f406                	sd	ra,40(sp)
    800054c8:	f022                	sd	s0,32(sp)
    800054ca:	ec26                	sd	s1,24(sp)
    800054cc:	e052                	sd	s4,0(sp)
    800054ce:	1800                	addi	s0,sp,48
    800054d0:	84aa                	mv	s1,a0
    800054d2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800054d4:	0005b023          	sd	zero,0(a1)
    800054d8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800054dc:	00000097          	auipc	ra,0x0
    800054e0:	bac080e7          	jalr	-1108(ra) # 80005088 <filealloc>
    800054e4:	e088                	sd	a0,0(s1)
    800054e6:	cd49                	beqz	a0,80005580 <pipealloc+0xbc>
    800054e8:	00000097          	auipc	ra,0x0
    800054ec:	ba0080e7          	jalr	-1120(ra) # 80005088 <filealloc>
    800054f0:	00aa3023          	sd	a0,0(s4)
    800054f4:	c141                	beqz	a0,80005574 <pipealloc+0xb0>
    800054f6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800054f8:	ffffb097          	auipc	ra,0xffffb
    800054fc:	71a080e7          	jalr	1818(ra) # 80000c12 <kalloc>
    80005500:	892a                	mv	s2,a0
    80005502:	c13d                	beqz	a0,80005568 <pipealloc+0xa4>
    80005504:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80005506:	4985                	li	s3,1
    80005508:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000550c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005510:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005514:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80005518:	00005597          	auipc	a1,0x5
    8000551c:	12858593          	addi	a1,a1,296 # 8000a640 <etext+0x640>
    80005520:	ffffb097          	auipc	ra,0xffffb
    80005524:	77a080e7          	jalr	1914(ra) # 80000c9a <initlock>
  (*f0)->type = FD_PIPE;
    80005528:	609c                	ld	a5,0(s1)
    8000552a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000552e:	609c                	ld	a5,0(s1)
    80005530:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005534:	609c                	ld	a5,0(s1)
    80005536:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000553a:	609c                	ld	a5,0(s1)
    8000553c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005540:	000a3783          	ld	a5,0(s4)
    80005544:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80005548:	000a3783          	ld	a5,0(s4)
    8000554c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005550:	000a3783          	ld	a5,0(s4)
    80005554:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80005558:	000a3783          	ld	a5,0(s4)
    8000555c:	0127b823          	sd	s2,16(a5)
  return 0;
    80005560:	4501                	li	a0,0
    80005562:	6942                	ld	s2,16(sp)
    80005564:	69a2                	ld	s3,8(sp)
    80005566:	a03d                	j	80005594 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005568:	6088                	ld	a0,0(s1)
    8000556a:	c119                	beqz	a0,80005570 <pipealloc+0xac>
    8000556c:	6942                	ld	s2,16(sp)
    8000556e:	a029                	j	80005578 <pipealloc+0xb4>
    80005570:	6942                	ld	s2,16(sp)
    80005572:	a039                	j	80005580 <pipealloc+0xbc>
    80005574:	6088                	ld	a0,0(s1)
    80005576:	c50d                	beqz	a0,800055a0 <pipealloc+0xdc>
    fileclose(*f0);
    80005578:	00000097          	auipc	ra,0x0
    8000557c:	bcc080e7          	jalr	-1076(ra) # 80005144 <fileclose>
  if(*f1)
    80005580:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005584:	557d                	li	a0,-1
  if(*f1)
    80005586:	c799                	beqz	a5,80005594 <pipealloc+0xd0>
    fileclose(*f1);
    80005588:	853e                	mv	a0,a5
    8000558a:	00000097          	auipc	ra,0x0
    8000558e:	bba080e7          	jalr	-1094(ra) # 80005144 <fileclose>
  return -1;
    80005592:	557d                	li	a0,-1
}
    80005594:	70a2                	ld	ra,40(sp)
    80005596:	7402                	ld	s0,32(sp)
    80005598:	64e2                	ld	s1,24(sp)
    8000559a:	6a02                	ld	s4,0(sp)
    8000559c:	6145                	addi	sp,sp,48
    8000559e:	8082                	ret
  return -1;
    800055a0:	557d                	li	a0,-1
    800055a2:	bfcd                	j	80005594 <pipealloc+0xd0>

00000000800055a4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800055a4:	1101                	addi	sp,sp,-32
    800055a6:	ec06                	sd	ra,24(sp)
    800055a8:	e822                	sd	s0,16(sp)
    800055aa:	e426                	sd	s1,8(sp)
    800055ac:	e04a                	sd	s2,0(sp)
    800055ae:	1000                	addi	s0,sp,32
    800055b0:	84aa                	mv	s1,a0
    800055b2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800055b4:	ffffb097          	auipc	ra,0xffffb
    800055b8:	780080e7          	jalr	1920(ra) # 80000d34 <acquire>
  if(writable){
    800055bc:	02090b63          	beqz	s2,800055f2 <pipeclose+0x4e>
    pi->writeopen = 0;
    800055c0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800055c4:	21848513          	addi	a0,s1,536
    800055c8:	ffffd097          	auipc	ra,0xffffd
    800055cc:	1d0080e7          	jalr	464(ra) # 80002798 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800055d0:	2204a783          	lw	a5,544(s1)
    800055d4:	e781                	bnez	a5,800055dc <pipeclose+0x38>
    800055d6:	2244a783          	lw	a5,548(s1)
    800055da:	c78d                	beqz	a5,80005604 <pipeclose+0x60>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800055dc:	8526                	mv	a0,s1
    800055de:	ffffc097          	auipc	ra,0xffffc
    800055e2:	806080e7          	jalr	-2042(ra) # 80000de4 <release>
}
    800055e6:	60e2                	ld	ra,24(sp)
    800055e8:	6442                	ld	s0,16(sp)
    800055ea:	64a2                	ld	s1,8(sp)
    800055ec:	6902                	ld	s2,0(sp)
    800055ee:	6105                	addi	sp,sp,32
    800055f0:	8082                	ret
    pi->readopen = 0;
    800055f2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800055f6:	21c48513          	addi	a0,s1,540
    800055fa:	ffffd097          	auipc	ra,0xffffd
    800055fe:	19e080e7          	jalr	414(ra) # 80002798 <wakeup>
    80005602:	b7f9                	j	800055d0 <pipeclose+0x2c>
    release(&pi->lock);
    80005604:	8526                	mv	a0,s1
    80005606:	ffffb097          	auipc	ra,0xffffb
    8000560a:	7de080e7          	jalr	2014(ra) # 80000de4 <release>
    kfree((char*)pi);
    8000560e:	8526                	mv	a0,s1
    80005610:	ffffb097          	auipc	ra,0xffffb
    80005614:	494080e7          	jalr	1172(ra) # 80000aa4 <kfree>
    80005618:	b7f9                	j	800055e6 <pipeclose+0x42>

000000008000561a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000561a:	7159                	addi	sp,sp,-112
    8000561c:	f486                	sd	ra,104(sp)
    8000561e:	f0a2                	sd	s0,96(sp)
    80005620:	eca6                	sd	s1,88(sp)
    80005622:	e8ca                	sd	s2,80(sp)
    80005624:	e4ce                	sd	s3,72(sp)
    80005626:	e0d2                	sd	s4,64(sp)
    80005628:	fc56                	sd	s5,56(sp)
    8000562a:	1880                	addi	s0,sp,112
    8000562c:	84aa                	mv	s1,a0
    8000562e:	8aae                	mv	s5,a1
    80005630:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005632:	ffffd097          	auipc	ra,0xffffd
    80005636:	84c080e7          	jalr	-1972(ra) # 80001e7e <myproc>
    8000563a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000563c:	8526                	mv	a0,s1
    8000563e:	ffffb097          	auipc	ra,0xffffb
    80005642:	6f6080e7          	jalr	1782(ra) # 80000d34 <acquire>
  while(i < n){
    80005646:	0f405063          	blez	s4,80005726 <pipewrite+0x10c>
    8000564a:	f85a                	sd	s6,48(sp)
    8000564c:	f45e                	sd	s7,40(sp)
    8000564e:	f062                	sd	s8,32(sp)
    80005650:	ec66                	sd	s9,24(sp)
    80005652:	e86a                	sd	s10,16(sp)
  int i = 0;
    80005654:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005656:	f9f40c13          	addi	s8,s0,-97
    8000565a:	4b85                	li	s7,1
    8000565c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000565e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005662:	21c48c93          	addi	s9,s1,540
    80005666:	a099                	j	800056ac <pipewrite+0x92>
      release(&pi->lock);
    80005668:	8526                	mv	a0,s1
    8000566a:	ffffb097          	auipc	ra,0xffffb
    8000566e:	77a080e7          	jalr	1914(ra) # 80000de4 <release>
      return -1;
    80005672:	597d                	li	s2,-1
    80005674:	7b42                	ld	s6,48(sp)
    80005676:	7ba2                	ld	s7,40(sp)
    80005678:	7c02                	ld	s8,32(sp)
    8000567a:	6ce2                	ld	s9,24(sp)
    8000567c:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000567e:	854a                	mv	a0,s2
    80005680:	70a6                	ld	ra,104(sp)
    80005682:	7406                	ld	s0,96(sp)
    80005684:	64e6                	ld	s1,88(sp)
    80005686:	6946                	ld	s2,80(sp)
    80005688:	69a6                	ld	s3,72(sp)
    8000568a:	6a06                	ld	s4,64(sp)
    8000568c:	7ae2                	ld	s5,56(sp)
    8000568e:	6165                	addi	sp,sp,112
    80005690:	8082                	ret
      wakeup(&pi->nread);
    80005692:	856a                	mv	a0,s10
    80005694:	ffffd097          	auipc	ra,0xffffd
    80005698:	104080e7          	jalr	260(ra) # 80002798 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000569c:	85a6                	mv	a1,s1
    8000569e:	8566                	mv	a0,s9
    800056a0:	ffffd097          	auipc	ra,0xffffd
    800056a4:	094080e7          	jalr	148(ra) # 80002734 <sleep>
  while(i < n){
    800056a8:	05495e63          	bge	s2,s4,80005704 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    800056ac:	2204a783          	lw	a5,544(s1)
    800056b0:	dfc5                	beqz	a5,80005668 <pipewrite+0x4e>
    800056b2:	854e                	mv	a0,s3
    800056b4:	ffffd097          	auipc	ra,0xffffd
    800056b8:	4ae080e7          	jalr	1198(ra) # 80002b62 <killed>
    800056bc:	f555                	bnez	a0,80005668 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800056be:	2184a783          	lw	a5,536(s1)
    800056c2:	21c4a703          	lw	a4,540(s1)
    800056c6:	2007879b          	addiw	a5,a5,512
    800056ca:	fcf704e3          	beq	a4,a5,80005692 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800056ce:	86de                	mv	a3,s7
    800056d0:	01590633          	add	a2,s2,s5
    800056d4:	85e2                	mv	a1,s8
    800056d6:	0509b503          	ld	a0,80(s3)
    800056da:	ffffc097          	auipc	ra,0xffffc
    800056de:	4bc080e7          	jalr	1212(ra) # 80001b96 <copyin>
    800056e2:	05650463          	beq	a0,s6,8000572a <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800056e6:	21c4a783          	lw	a5,540(s1)
    800056ea:	0017871b          	addiw	a4,a5,1
    800056ee:	20e4ae23          	sw	a4,540(s1)
    800056f2:	1ff7f793          	andi	a5,a5,511
    800056f6:	97a6                	add	a5,a5,s1
    800056f8:	f9f44703          	lbu	a4,-97(s0)
    800056fc:	00e78c23          	sb	a4,24(a5)
      i++;
    80005700:	2905                	addiw	s2,s2,1
    80005702:	b75d                	j	800056a8 <pipewrite+0x8e>
    80005704:	7b42                	ld	s6,48(sp)
    80005706:	7ba2                	ld	s7,40(sp)
    80005708:	7c02                	ld	s8,32(sp)
    8000570a:	6ce2                	ld	s9,24(sp)
    8000570c:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000570e:	21848513          	addi	a0,s1,536
    80005712:	ffffd097          	auipc	ra,0xffffd
    80005716:	086080e7          	jalr	134(ra) # 80002798 <wakeup>
  release(&pi->lock);
    8000571a:	8526                	mv	a0,s1
    8000571c:	ffffb097          	auipc	ra,0xffffb
    80005720:	6c8080e7          	jalr	1736(ra) # 80000de4 <release>
  return i;
    80005724:	bfa9                	j	8000567e <pipewrite+0x64>
  int i = 0;
    80005726:	4901                	li	s2,0
    80005728:	b7dd                	j	8000570e <pipewrite+0xf4>
    8000572a:	7b42                	ld	s6,48(sp)
    8000572c:	7ba2                	ld	s7,40(sp)
    8000572e:	7c02                	ld	s8,32(sp)
    80005730:	6ce2                	ld	s9,24(sp)
    80005732:	6d42                	ld	s10,16(sp)
    80005734:	bfe9                	j	8000570e <pipewrite+0xf4>

0000000080005736 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005736:	711d                	addi	sp,sp,-96
    80005738:	ec86                	sd	ra,88(sp)
    8000573a:	e8a2                	sd	s0,80(sp)
    8000573c:	e4a6                	sd	s1,72(sp)
    8000573e:	e0ca                	sd	s2,64(sp)
    80005740:	fc4e                	sd	s3,56(sp)
    80005742:	f852                	sd	s4,48(sp)
    80005744:	f456                	sd	s5,40(sp)
    80005746:	1080                	addi	s0,sp,96
    80005748:	84aa                	mv	s1,a0
    8000574a:	892e                	mv	s2,a1
    8000574c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000574e:	ffffc097          	auipc	ra,0xffffc
    80005752:	730080e7          	jalr	1840(ra) # 80001e7e <myproc>
    80005756:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005758:	8526                	mv	a0,s1
    8000575a:	ffffb097          	auipc	ra,0xffffb
    8000575e:	5da080e7          	jalr	1498(ra) # 80000d34 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005762:	2184a703          	lw	a4,536(s1)
    80005766:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000576a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000576e:	02f71b63          	bne	a4,a5,800057a4 <piperead+0x6e>
    80005772:	2244a783          	lw	a5,548(s1)
    80005776:	c3b1                	beqz	a5,800057ba <piperead+0x84>
    if(killed(pr)){
    80005778:	8552                	mv	a0,s4
    8000577a:	ffffd097          	auipc	ra,0xffffd
    8000577e:	3e8080e7          	jalr	1000(ra) # 80002b62 <killed>
    80005782:	e50d                	bnez	a0,800057ac <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005784:	85a6                	mv	a1,s1
    80005786:	854e                	mv	a0,s3
    80005788:	ffffd097          	auipc	ra,0xffffd
    8000578c:	fac080e7          	jalr	-84(ra) # 80002734 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005790:	2184a703          	lw	a4,536(s1)
    80005794:	21c4a783          	lw	a5,540(s1)
    80005798:	fcf70de3          	beq	a4,a5,80005772 <piperead+0x3c>
    8000579c:	f05a                	sd	s6,32(sp)
    8000579e:	ec5e                	sd	s7,24(sp)
    800057a0:	e862                	sd	s8,16(sp)
    800057a2:	a839                	j	800057c0 <piperead+0x8a>
    800057a4:	f05a                	sd	s6,32(sp)
    800057a6:	ec5e                	sd	s7,24(sp)
    800057a8:	e862                	sd	s8,16(sp)
    800057aa:	a819                	j	800057c0 <piperead+0x8a>
      release(&pi->lock);
    800057ac:	8526                	mv	a0,s1
    800057ae:	ffffb097          	auipc	ra,0xffffb
    800057b2:	636080e7          	jalr	1590(ra) # 80000de4 <release>
      return -1;
    800057b6:	59fd                	li	s3,-1
    800057b8:	a88d                	j	8000582a <piperead+0xf4>
    800057ba:	f05a                	sd	s6,32(sp)
    800057bc:	ec5e                	sd	s7,24(sp)
    800057be:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800057c0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800057c2:	faf40c13          	addi	s8,s0,-81
    800057c6:	4b85                	li	s7,1
    800057c8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800057ca:	05505263          	blez	s5,8000580e <piperead+0xd8>
    if(pi->nread == pi->nwrite)
    800057ce:	2184a783          	lw	a5,536(s1)
    800057d2:	21c4a703          	lw	a4,540(s1)
    800057d6:	02f70c63          	beq	a4,a5,8000580e <piperead+0xd8>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800057da:	0017871b          	addiw	a4,a5,1
    800057de:	20e4ac23          	sw	a4,536(s1)
    800057e2:	1ff7f793          	andi	a5,a5,511
    800057e6:	97a6                	add	a5,a5,s1
    800057e8:	0187c783          	lbu	a5,24(a5)
    800057ec:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800057f0:	86de                	mv	a3,s7
    800057f2:	8662                	mv	a2,s8
    800057f4:	85ca                	mv	a1,s2
    800057f6:	050a3503          	ld	a0,80(s4)
    800057fa:	ffffc097          	auipc	ra,0xffffc
    800057fe:	310080e7          	jalr	784(ra) # 80001b0a <copyout>
    80005802:	01650663          	beq	a0,s6,8000580e <piperead+0xd8>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005806:	2985                	addiw	s3,s3,1
    80005808:	0905                	addi	s2,s2,1
    8000580a:	fd3a92e3          	bne	s5,s3,800057ce <piperead+0x98>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000580e:	21c48513          	addi	a0,s1,540
    80005812:	ffffd097          	auipc	ra,0xffffd
    80005816:	f86080e7          	jalr	-122(ra) # 80002798 <wakeup>
  release(&pi->lock);
    8000581a:	8526                	mv	a0,s1
    8000581c:	ffffb097          	auipc	ra,0xffffb
    80005820:	5c8080e7          	jalr	1480(ra) # 80000de4 <release>
    80005824:	7b02                	ld	s6,32(sp)
    80005826:	6be2                	ld	s7,24(sp)
    80005828:	6c42                	ld	s8,16(sp)
  return i;
}
    8000582a:	854e                	mv	a0,s3
    8000582c:	60e6                	ld	ra,88(sp)
    8000582e:	6446                	ld	s0,80(sp)
    80005830:	64a6                	ld	s1,72(sp)
    80005832:	6906                	ld	s2,64(sp)
    80005834:	79e2                	ld	s3,56(sp)
    80005836:	7a42                	ld	s4,48(sp)
    80005838:	7aa2                	ld	s5,40(sp)
    8000583a:	6125                	addi	sp,sp,96
    8000583c:	8082                	ret

000000008000583e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000583e:	1141                	addi	sp,sp,-16
    80005840:	e406                	sd	ra,8(sp)
    80005842:	e022                	sd	s0,0(sp)
    80005844:	0800                	addi	s0,sp,16
    80005846:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005848:	0035151b          	slliw	a0,a0,0x3
    8000584c:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    8000584e:	8b89                	andi	a5,a5,2
    80005850:	c399                	beqz	a5,80005856 <flags2perm+0x18>
      perm |= PTE_W;
    80005852:	00456513          	ori	a0,a0,4
    return perm;
}
    80005856:	60a2                	ld	ra,8(sp)
    80005858:	6402                	ld	s0,0(sp)
    8000585a:	0141                	addi	sp,sp,16
    8000585c:	8082                	ret

000000008000585e <exec>:

int
exec(char *path, char **argv)
{
    8000585e:	de010113          	addi	sp,sp,-544
    80005862:	20113c23          	sd	ra,536(sp)
    80005866:	20813823          	sd	s0,528(sp)
    8000586a:	20913423          	sd	s1,520(sp)
    8000586e:	21213023          	sd	s2,512(sp)
    80005872:	1400                	addi	s0,sp,544
    80005874:	892a                	mv	s2,a0
    80005876:	dea43823          	sd	a0,-528(s0)
    8000587a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000587e:	ffffc097          	auipc	ra,0xffffc
    80005882:	600080e7          	jalr	1536(ra) # 80001e7e <myproc>
    80005886:	84aa                	mv	s1,a0

  begin_op();
    80005888:	fffff097          	auipc	ra,0xfffff
    8000588c:	3da080e7          	jalr	986(ra) # 80004c62 <begin_op>

  if((ip = namei(path)) == 0){
    80005890:	854a                	mv	a0,s2
    80005892:	fffff097          	auipc	ra,0xfffff
    80005896:	1ca080e7          	jalr	458(ra) # 80004a5c <namei>
    8000589a:	c525                	beqz	a0,80005902 <exec+0xa4>
    8000589c:	fbd2                	sd	s4,496(sp)
    8000589e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800058a0:	fffff097          	auipc	ra,0xfffff
    800058a4:	9d2080e7          	jalr	-1582(ra) # 80004272 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800058a8:	04000713          	li	a4,64
    800058ac:	4681                	li	a3,0
    800058ae:	e5040613          	addi	a2,s0,-432
    800058b2:	4581                	li	a1,0
    800058b4:	8552                	mv	a0,s4
    800058b6:	fffff097          	auipc	ra,0xfffff
    800058ba:	c7a080e7          	jalr	-902(ra) # 80004530 <readi>
    800058be:	04000793          	li	a5,64
    800058c2:	00f51a63          	bne	a0,a5,800058d6 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800058c6:	e5042703          	lw	a4,-432(s0)
    800058ca:	464c47b7          	lui	a5,0x464c4
    800058ce:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800058d2:	02f70e63          	beq	a4,a5,8000590e <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800058d6:	8552                	mv	a0,s4
    800058d8:	fffff097          	auipc	ra,0xfffff
    800058dc:	c02080e7          	jalr	-1022(ra) # 800044da <iunlockput>
    end_op();
    800058e0:	fffff097          	auipc	ra,0xfffff
    800058e4:	402080e7          	jalr	1026(ra) # 80004ce2 <end_op>
  }
  return -1;
    800058e8:	557d                	li	a0,-1
    800058ea:	7a5e                	ld	s4,496(sp)
}
    800058ec:	21813083          	ld	ra,536(sp)
    800058f0:	21013403          	ld	s0,528(sp)
    800058f4:	20813483          	ld	s1,520(sp)
    800058f8:	20013903          	ld	s2,512(sp)
    800058fc:	22010113          	addi	sp,sp,544
    80005900:	8082                	ret
    end_op();
    80005902:	fffff097          	auipc	ra,0xfffff
    80005906:	3e0080e7          	jalr	992(ra) # 80004ce2 <end_op>
    return -1;
    8000590a:	557d                	li	a0,-1
    8000590c:	b7c5                	j	800058ec <exec+0x8e>
    8000590e:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005910:	8526                	mv	a0,s1
    80005912:	ffffc097          	auipc	ra,0xffffc
    80005916:	632080e7          	jalr	1586(ra) # 80001f44 <proc_pagetable>
    8000591a:	8b2a                	mv	s6,a0
    8000591c:	2c050363          	beqz	a0,80005be2 <exec+0x384>
    80005920:	ffce                	sd	s3,504(sp)
    80005922:	f7d6                	sd	s5,488(sp)
    80005924:	efde                	sd	s7,472(sp)
    80005926:	ebe2                	sd	s8,464(sp)
    80005928:	e7e6                	sd	s9,456(sp)
    8000592a:	e3ea                	sd	s10,448(sp)
    8000592c:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000592e:	e8845783          	lhu	a5,-376(s0)
    80005932:	10078563          	beqz	a5,80005a3c <exec+0x1de>
    80005936:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000593a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000593c:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000593e:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80005942:	6c85                	lui	s9,0x1
    80005944:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005948:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000594c:	6a85                	lui	s5,0x1
    8000594e:	a0b5                	j	800059ba <exec+0x15c>
      panic("loadseg: address should exist");
    80005950:	00005517          	auipc	a0,0x5
    80005954:	cf850513          	addi	a0,a0,-776 # 8000a648 <etext+0x648>
    80005958:	ffffb097          	auipc	ra,0xffffb
    8000595c:	c06080e7          	jalr	-1018(ra) # 8000055e <panic>
    if(sz - i < PGSIZE)
    80005960:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005962:	874a                	mv	a4,s2
    80005964:	009b86bb          	addw	a3,s7,s1
    80005968:	4581                	li	a1,0
    8000596a:	8552                	mv	a0,s4
    8000596c:	fffff097          	auipc	ra,0xfffff
    80005970:	bc4080e7          	jalr	-1084(ra) # 80004530 <readi>
    80005974:	26a91b63          	bne	s2,a0,80005bea <exec+0x38c>
  for(i = 0; i < sz; i += PGSIZE){
    80005978:	009a84bb          	addw	s1,s5,s1
    8000597c:	0334f463          	bgeu	s1,s3,800059a4 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    80005980:	02049593          	slli	a1,s1,0x20
    80005984:	9181                	srli	a1,a1,0x20
    80005986:	95e2                	add	a1,a1,s8
    80005988:	855a                	mv	a0,s6
    8000598a:	ffffc097          	auipc	ra,0xffffc
    8000598e:	85c080e7          	jalr	-1956(ra) # 800011e6 <walkaddr>
    80005992:	862a                	mv	a2,a0
    if(pa == 0)
    80005994:	dd55                	beqz	a0,80005950 <exec+0xf2>
    if(sz - i < PGSIZE)
    80005996:	409987bb          	subw	a5,s3,s1
    8000599a:	893e                	mv	s2,a5
    8000599c:	fcfcf2e3          	bgeu	s9,a5,80005960 <exec+0x102>
    800059a0:	8956                	mv	s2,s5
    800059a2:	bf7d                	j	80005960 <exec+0x102>
    sz = sz1;
    800059a4:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800059a8:	2d05                	addiw	s10,s10,1
    800059aa:	e0843783          	ld	a5,-504(s0)
    800059ae:	0387869b          	addiw	a3,a5,56
    800059b2:	e8845783          	lhu	a5,-376(s0)
    800059b6:	08fd5463          	bge	s10,a5,80005a3e <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800059ba:	e0d43423          	sd	a3,-504(s0)
    800059be:	876e                	mv	a4,s11
    800059c0:	e1840613          	addi	a2,s0,-488
    800059c4:	4581                	li	a1,0
    800059c6:	8552                	mv	a0,s4
    800059c8:	fffff097          	auipc	ra,0xfffff
    800059cc:	b68080e7          	jalr	-1176(ra) # 80004530 <readi>
    800059d0:	21b51b63          	bne	a0,s11,80005be6 <exec+0x388>
    if(ph.type != ELF_PROG_LOAD)
    800059d4:	e1842783          	lw	a5,-488(s0)
    800059d8:	4705                	li	a4,1
    800059da:	fce797e3          	bne	a5,a4,800059a8 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    800059de:	e4043483          	ld	s1,-448(s0)
    800059e2:	e3843783          	ld	a5,-456(s0)
    800059e6:	22f4e263          	bltu	s1,a5,80005c0a <exec+0x3ac>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800059ea:	e2843783          	ld	a5,-472(s0)
    800059ee:	94be                	add	s1,s1,a5
    800059f0:	22f4e063          	bltu	s1,a5,80005c10 <exec+0x3b2>
    if(ph.vaddr % PGSIZE != 0)
    800059f4:	de843703          	ld	a4,-536(s0)
    800059f8:	8ff9                	and	a5,a5,a4
    800059fa:	20079e63          	bnez	a5,80005c16 <exec+0x3b8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800059fe:	e1c42503          	lw	a0,-484(s0)
    80005a02:	00000097          	auipc	ra,0x0
    80005a06:	e3c080e7          	jalr	-452(ra) # 8000583e <flags2perm>
    80005a0a:	86aa                	mv	a3,a0
    80005a0c:	8626                	mv	a2,s1
    80005a0e:	85ca                	mv	a1,s2
    80005a10:	855a                	mv	a0,s6
    80005a12:	ffffc097          	auipc	ra,0xffffc
    80005a16:	ba6080e7          	jalr	-1114(ra) # 800015b8 <uvmalloc>
    80005a1a:	dea43c23          	sd	a0,-520(s0)
    80005a1e:	1e050f63          	beqz	a0,80005c1c <exec+0x3be>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005a22:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005a26:	00098863          	beqz	s3,80005a36 <exec+0x1d8>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005a2a:	e2843c03          	ld	s8,-472(s0)
    80005a2e:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005a32:	4481                	li	s1,0
    80005a34:	b7b1                	j	80005980 <exec+0x122>
    sz = sz1;
    80005a36:	df843903          	ld	s2,-520(s0)
    80005a3a:	b7bd                	j	800059a8 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005a3c:	4901                	li	s2,0
  iunlockput(ip);
    80005a3e:	8552                	mv	a0,s4
    80005a40:	fffff097          	auipc	ra,0xfffff
    80005a44:	a9a080e7          	jalr	-1382(ra) # 800044da <iunlockput>
  end_op();
    80005a48:	fffff097          	auipc	ra,0xfffff
    80005a4c:	29a080e7          	jalr	666(ra) # 80004ce2 <end_op>
  p = myproc();
    80005a50:	ffffc097          	auipc	ra,0xffffc
    80005a54:	42e080e7          	jalr	1070(ra) # 80001e7e <myproc>
    80005a58:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005a5a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005a5e:	6985                	lui	s3,0x1
    80005a60:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005a62:	99ca                	add	s3,s3,s2
    80005a64:	77fd                	lui	a5,0xfffff
    80005a66:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005a6a:	4691                	li	a3,4
    80005a6c:	6609                	lui	a2,0x2
    80005a6e:	964e                	add	a2,a2,s3
    80005a70:	85ce                	mv	a1,s3
    80005a72:	855a                	mv	a0,s6
    80005a74:	ffffc097          	auipc	ra,0xffffc
    80005a78:	b44080e7          	jalr	-1212(ra) # 800015b8 <uvmalloc>
    80005a7c:	8a2a                	mv	s4,a0
    80005a7e:	e115                	bnez	a0,80005aa2 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    80005a80:	85ce                	mv	a1,s3
    80005a82:	855a                	mv	a0,s6
    80005a84:	ffffc097          	auipc	ra,0xffffc
    80005a88:	55c080e7          	jalr	1372(ra) # 80001fe0 <proc_freepagetable>
  return -1;
    80005a8c:	557d                	li	a0,-1
    80005a8e:	79fe                	ld	s3,504(sp)
    80005a90:	7a5e                	ld	s4,496(sp)
    80005a92:	7abe                	ld	s5,488(sp)
    80005a94:	7b1e                	ld	s6,480(sp)
    80005a96:	6bfe                	ld	s7,472(sp)
    80005a98:	6c5e                	ld	s8,464(sp)
    80005a9a:	6cbe                	ld	s9,456(sp)
    80005a9c:	6d1e                	ld	s10,448(sp)
    80005a9e:	7dfa                	ld	s11,440(sp)
    80005aa0:	b5b1                	j	800058ec <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005aa2:	75f9                	lui	a1,0xffffe
    80005aa4:	95aa                	add	a1,a1,a0
    80005aa6:	855a                	mv	a0,s6
    80005aa8:	ffffc097          	auipc	ra,0xffffc
    80005aac:	030080e7          	jalr	48(ra) # 80001ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    80005ab0:	800a0b93          	addi	s7,s4,-2048
    80005ab4:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80005ab8:	e0043783          	ld	a5,-512(s0)
    80005abc:	6388                	ld	a0,0(a5)
  sp = sz;
    80005abe:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80005ac0:	4481                	li	s1,0
    ustack[argc] = sp;
    80005ac2:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005ac6:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005aca:	c135                	beqz	a0,80005b2e <exec+0x2d0>
    sp -= strlen(argv[argc]) + 1;
    80005acc:	ffffb097          	auipc	ra,0xffffb
    80005ad0:	4ee080e7          	jalr	1262(ra) # 80000fba <strlen>
    80005ad4:	0015079b          	addiw	a5,a0,1
    80005ad8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005adc:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005ae0:	15796163          	bltu	s2,s7,80005c22 <exec+0x3c4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005ae4:	e0043d83          	ld	s11,-512(s0)
    80005ae8:	000db983          	ld	s3,0(s11)
    80005aec:	854e                	mv	a0,s3
    80005aee:	ffffb097          	auipc	ra,0xffffb
    80005af2:	4cc080e7          	jalr	1228(ra) # 80000fba <strlen>
    80005af6:	0015069b          	addiw	a3,a0,1
    80005afa:	864e                	mv	a2,s3
    80005afc:	85ca                	mv	a1,s2
    80005afe:	855a                	mv	a0,s6
    80005b00:	ffffc097          	auipc	ra,0xffffc
    80005b04:	00a080e7          	jalr	10(ra) # 80001b0a <copyout>
    80005b08:	10054f63          	bltz	a0,80005c26 <exec+0x3c8>
    ustack[argc] = sp;
    80005b0c:	00349793          	slli	a5,s1,0x3
    80005b10:	97e6                	add	a5,a5,s9
    80005b12:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ff8e654>
  for(argc = 0; argv[argc]; argc++) {
    80005b16:	0485                	addi	s1,s1,1
    80005b18:	008d8793          	addi	a5,s11,8
    80005b1c:	e0f43023          	sd	a5,-512(s0)
    80005b20:	008db503          	ld	a0,8(s11)
    80005b24:	c509                	beqz	a0,80005b2e <exec+0x2d0>
    if(argc >= MAXARG)
    80005b26:	fb8493e3          	bne	s1,s8,80005acc <exec+0x26e>
  sz = sz1;
    80005b2a:	89d2                	mv	s3,s4
    80005b2c:	bf91                	j	80005a80 <exec+0x222>
  ustack[argc] = 0;
    80005b2e:	00349793          	slli	a5,s1,0x3
    80005b32:	f9078793          	addi	a5,a5,-112
    80005b36:	97a2                	add	a5,a5,s0
    80005b38:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005b3c:	00349693          	slli	a3,s1,0x3
    80005b40:	06a1                	addi	a3,a3,8
    80005b42:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005b46:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005b4a:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005b4c:	f3796ae3          	bltu	s2,s7,80005a80 <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005b50:	e9040613          	addi	a2,s0,-368
    80005b54:	85ca                	mv	a1,s2
    80005b56:	855a                	mv	a0,s6
    80005b58:	ffffc097          	auipc	ra,0xffffc
    80005b5c:	fb2080e7          	jalr	-78(ra) # 80001b0a <copyout>
    80005b60:	f20540e3          	bltz	a0,80005a80 <exec+0x222>
  p->trapframe->a1 = sp;
    80005b64:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005b68:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005b6c:	df043783          	ld	a5,-528(s0)
    80005b70:	0007c703          	lbu	a4,0(a5)
    80005b74:	cf11                	beqz	a4,80005b90 <exec+0x332>
    80005b76:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005b78:	02f00693          	li	a3,47
    80005b7c:	a029                	j	80005b86 <exec+0x328>
  for(last=s=path; *s; s++)
    80005b7e:	0785                	addi	a5,a5,1
    80005b80:	fff7c703          	lbu	a4,-1(a5)
    80005b84:	c711                	beqz	a4,80005b90 <exec+0x332>
    if(*s == '/')
    80005b86:	fed71ce3          	bne	a4,a3,80005b7e <exec+0x320>
      last = s+1;
    80005b8a:	def43823          	sd	a5,-528(s0)
    80005b8e:	bfc5                	j	80005b7e <exec+0x320>
  safestrcpy(p->name, last, sizeof(p->name));
    80005b90:	4641                	li	a2,16
    80005b92:	df043583          	ld	a1,-528(s0)
    80005b96:	158a8513          	addi	a0,s5,344
    80005b9a:	ffffb097          	auipc	ra,0xffffb
    80005b9e:	3ea080e7          	jalr	1002(ra) # 80000f84 <safestrcpy>
  oldpagetable = p->pagetable;
    80005ba2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005ba6:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005baa:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005bae:	058ab783          	ld	a5,88(s5)
    80005bb2:	e6843703          	ld	a4,-408(s0)
    80005bb6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005bb8:	058ab783          	ld	a5,88(s5)
    80005bbc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005bc0:	85ea                	mv	a1,s10
    80005bc2:	ffffc097          	auipc	ra,0xffffc
    80005bc6:	41e080e7          	jalr	1054(ra) # 80001fe0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005bca:	0004851b          	sext.w	a0,s1
    80005bce:	79fe                	ld	s3,504(sp)
    80005bd0:	7a5e                	ld	s4,496(sp)
    80005bd2:	7abe                	ld	s5,488(sp)
    80005bd4:	7b1e                	ld	s6,480(sp)
    80005bd6:	6bfe                	ld	s7,472(sp)
    80005bd8:	6c5e                	ld	s8,464(sp)
    80005bda:	6cbe                	ld	s9,456(sp)
    80005bdc:	6d1e                	ld	s10,448(sp)
    80005bde:	7dfa                	ld	s11,440(sp)
    80005be0:	b331                	j	800058ec <exec+0x8e>
    80005be2:	7b1e                	ld	s6,480(sp)
    80005be4:	b9cd                	j	800058d6 <exec+0x78>
    80005be6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005bea:	df843583          	ld	a1,-520(s0)
    80005bee:	855a                	mv	a0,s6
    80005bf0:	ffffc097          	auipc	ra,0xffffc
    80005bf4:	3f0080e7          	jalr	1008(ra) # 80001fe0 <proc_freepagetable>
  if(ip){
    80005bf8:	79fe                	ld	s3,504(sp)
    80005bfa:	7abe                	ld	s5,488(sp)
    80005bfc:	7b1e                	ld	s6,480(sp)
    80005bfe:	6bfe                	ld	s7,472(sp)
    80005c00:	6c5e                	ld	s8,464(sp)
    80005c02:	6cbe                	ld	s9,456(sp)
    80005c04:	6d1e                	ld	s10,448(sp)
    80005c06:	7dfa                	ld	s11,440(sp)
    80005c08:	b1f9                	j	800058d6 <exec+0x78>
    80005c0a:	df243c23          	sd	s2,-520(s0)
    80005c0e:	bff1                	j	80005bea <exec+0x38c>
    80005c10:	df243c23          	sd	s2,-520(s0)
    80005c14:	bfd9                	j	80005bea <exec+0x38c>
    80005c16:	df243c23          	sd	s2,-520(s0)
    80005c1a:	bfc1                	j	80005bea <exec+0x38c>
    80005c1c:	df243c23          	sd	s2,-520(s0)
    80005c20:	b7e9                	j	80005bea <exec+0x38c>
  sz = sz1;
    80005c22:	89d2                	mv	s3,s4
    80005c24:	bdb1                	j	80005a80 <exec+0x222>
    80005c26:	89d2                	mv	s3,s4
    80005c28:	bda1                	j	80005a80 <exec+0x222>

0000000080005c2a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005c2a:	7179                	addi	sp,sp,-48
    80005c2c:	f406                	sd	ra,40(sp)
    80005c2e:	f022                	sd	s0,32(sp)
    80005c30:	ec26                	sd	s1,24(sp)
    80005c32:	e84a                	sd	s2,16(sp)
    80005c34:	1800                	addi	s0,sp,48
    80005c36:	892e                	mv	s2,a1
    80005c38:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005c3a:	fdc40593          	addi	a1,s0,-36
    80005c3e:	ffffe097          	auipc	ra,0xffffe
    80005c42:	870080e7          	jalr	-1936(ra) # 800034ae <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005c46:	fdc42703          	lw	a4,-36(s0)
    80005c4a:	47bd                	li	a5,15
    80005c4c:	02e7ec63          	bltu	a5,a4,80005c84 <argfd+0x5a>
    80005c50:	ffffc097          	auipc	ra,0xffffc
    80005c54:	22e080e7          	jalr	558(ra) # 80001e7e <myproc>
    80005c58:	fdc42703          	lw	a4,-36(s0)
    80005c5c:	00371793          	slli	a5,a4,0x3
    80005c60:	0d078793          	addi	a5,a5,208
    80005c64:	953e                	add	a0,a0,a5
    80005c66:	611c                	ld	a5,0(a0)
    80005c68:	c385                	beqz	a5,80005c88 <argfd+0x5e>
    return -1;
  if(pfd)
    80005c6a:	00090463          	beqz	s2,80005c72 <argfd+0x48>
    *pfd = fd;
    80005c6e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005c72:	4501                	li	a0,0
  if(pf)
    80005c74:	c091                	beqz	s1,80005c78 <argfd+0x4e>
    *pf = f;
    80005c76:	e09c                	sd	a5,0(s1)
}
    80005c78:	70a2                	ld	ra,40(sp)
    80005c7a:	7402                	ld	s0,32(sp)
    80005c7c:	64e2                	ld	s1,24(sp)
    80005c7e:	6942                	ld	s2,16(sp)
    80005c80:	6145                	addi	sp,sp,48
    80005c82:	8082                	ret
    return -1;
    80005c84:	557d                	li	a0,-1
    80005c86:	bfcd                	j	80005c78 <argfd+0x4e>
    80005c88:	557d                	li	a0,-1
    80005c8a:	b7fd                	j	80005c78 <argfd+0x4e>

0000000080005c8c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005c8c:	1101                	addi	sp,sp,-32
    80005c8e:	ec06                	sd	ra,24(sp)
    80005c90:	e822                	sd	s0,16(sp)
    80005c92:	e426                	sd	s1,8(sp)
    80005c94:	1000                	addi	s0,sp,32
    80005c96:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005c98:	ffffc097          	auipc	ra,0xffffc
    80005c9c:	1e6080e7          	jalr	486(ra) # 80001e7e <myproc>
    80005ca0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005ca2:	0d050793          	addi	a5,a0,208
    80005ca6:	4501                	li	a0,0
    80005ca8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005caa:	6398                	ld	a4,0(a5)
    80005cac:	cb19                	beqz	a4,80005cc2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005cae:	2505                	addiw	a0,a0,1
    80005cb0:	07a1                	addi	a5,a5,8
    80005cb2:	fed51ce3          	bne	a0,a3,80005caa <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005cb6:	557d                	li	a0,-1
}
    80005cb8:	60e2                	ld	ra,24(sp)
    80005cba:	6442                	ld	s0,16(sp)
    80005cbc:	64a2                	ld	s1,8(sp)
    80005cbe:	6105                	addi	sp,sp,32
    80005cc0:	8082                	ret
      p->ofile[fd] = f;
    80005cc2:	00351793          	slli	a5,a0,0x3
    80005cc6:	0d078793          	addi	a5,a5,208
    80005cca:	963e                	add	a2,a2,a5
    80005ccc:	e204                	sd	s1,0(a2)
      return fd;
    80005cce:	b7ed                	j	80005cb8 <fdalloc+0x2c>

0000000080005cd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005cd0:	715d                	addi	sp,sp,-80
    80005cd2:	e486                	sd	ra,72(sp)
    80005cd4:	e0a2                	sd	s0,64(sp)
    80005cd6:	fc26                	sd	s1,56(sp)
    80005cd8:	f84a                	sd	s2,48(sp)
    80005cda:	f44e                	sd	s3,40(sp)
    80005cdc:	f052                	sd	s4,32(sp)
    80005cde:	ec56                	sd	s5,24(sp)
    80005ce0:	e85a                	sd	s6,16(sp)
    80005ce2:	0880                	addi	s0,sp,80
    80005ce4:	892e                	mv	s2,a1
    80005ce6:	8a2e                	mv	s4,a1
    80005ce8:	8ab2                	mv	s5,a2
    80005cea:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005cec:	fb040593          	addi	a1,s0,-80
    80005cf0:	fffff097          	auipc	ra,0xfffff
    80005cf4:	d8a080e7          	jalr	-630(ra) # 80004a7a <nameiparent>
    80005cf8:	84aa                	mv	s1,a0
    80005cfa:	14050b63          	beqz	a0,80005e50 <create+0x180>
    return 0;

  ilock(dp);
    80005cfe:	ffffe097          	auipc	ra,0xffffe
    80005d02:	574080e7          	jalr	1396(ra) # 80004272 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005d06:	4601                	li	a2,0
    80005d08:	fb040593          	addi	a1,s0,-80
    80005d0c:	8526                	mv	a0,s1
    80005d0e:	fffff097          	auipc	ra,0xfffff
    80005d12:	a5e080e7          	jalr	-1442(ra) # 8000476c <dirlookup>
    80005d16:	89aa                	mv	s3,a0
    80005d18:	c921                	beqz	a0,80005d68 <create+0x98>
    iunlockput(dp);
    80005d1a:	8526                	mv	a0,s1
    80005d1c:	ffffe097          	auipc	ra,0xffffe
    80005d20:	7be080e7          	jalr	1982(ra) # 800044da <iunlockput>
    ilock(ip);
    80005d24:	854e                	mv	a0,s3
    80005d26:	ffffe097          	auipc	ra,0xffffe
    80005d2a:	54c080e7          	jalr	1356(ra) # 80004272 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005d2e:	4789                	li	a5,2
    80005d30:	02f91563          	bne	s2,a5,80005d5a <create+0x8a>
    80005d34:	0449d783          	lhu	a5,68(s3)
    80005d38:	37f9                	addiw	a5,a5,-2
    80005d3a:	17c2                	slli	a5,a5,0x30
    80005d3c:	93c1                	srli	a5,a5,0x30
    80005d3e:	4705                	li	a4,1
    80005d40:	00f76d63          	bltu	a4,a5,80005d5a <create+0x8a>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005d44:	854e                	mv	a0,s3
    80005d46:	60a6                	ld	ra,72(sp)
    80005d48:	6406                	ld	s0,64(sp)
    80005d4a:	74e2                	ld	s1,56(sp)
    80005d4c:	7942                	ld	s2,48(sp)
    80005d4e:	79a2                	ld	s3,40(sp)
    80005d50:	7a02                	ld	s4,32(sp)
    80005d52:	6ae2                	ld	s5,24(sp)
    80005d54:	6b42                	ld	s6,16(sp)
    80005d56:	6161                	addi	sp,sp,80
    80005d58:	8082                	ret
    iunlockput(ip);
    80005d5a:	854e                	mv	a0,s3
    80005d5c:	ffffe097          	auipc	ra,0xffffe
    80005d60:	77e080e7          	jalr	1918(ra) # 800044da <iunlockput>
    return 0;
    80005d64:	4981                	li	s3,0
    80005d66:	bff9                	j	80005d44 <create+0x74>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005d68:	85ca                	mv	a1,s2
    80005d6a:	4088                	lw	a0,0(s1)
    80005d6c:	ffffe097          	auipc	ra,0xffffe
    80005d70:	362080e7          	jalr	866(ra) # 800040ce <ialloc>
    80005d74:	892a                	mv	s2,a0
    80005d76:	c531                	beqz	a0,80005dc2 <create+0xf2>
  ilock(ip);
    80005d78:	ffffe097          	auipc	ra,0xffffe
    80005d7c:	4fa080e7          	jalr	1274(ra) # 80004272 <ilock>
  ip->major = major;
    80005d80:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80005d84:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80005d88:	4785                	li	a5,1
    80005d8a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005d8e:	854a                	mv	a0,s2
    80005d90:	ffffe097          	auipc	ra,0xffffe
    80005d94:	416080e7          	jalr	1046(ra) # 800041a6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005d98:	4705                	li	a4,1
    80005d9a:	02ea0a63          	beq	s4,a4,80005dce <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005d9e:	00492603          	lw	a2,4(s2)
    80005da2:	fb040593          	addi	a1,s0,-80
    80005da6:	8526                	mv	a0,s1
    80005da8:	fffff097          	auipc	ra,0xfffff
    80005dac:	bf2080e7          	jalr	-1038(ra) # 8000499a <dirlink>
    80005db0:	06054e63          	bltz	a0,80005e2c <create+0x15c>
  iunlockput(dp);
    80005db4:	8526                	mv	a0,s1
    80005db6:	ffffe097          	auipc	ra,0xffffe
    80005dba:	724080e7          	jalr	1828(ra) # 800044da <iunlockput>
  return ip;
    80005dbe:	89ca                	mv	s3,s2
    80005dc0:	b751                	j	80005d44 <create+0x74>
    iunlockput(dp);
    80005dc2:	8526                	mv	a0,s1
    80005dc4:	ffffe097          	auipc	ra,0xffffe
    80005dc8:	716080e7          	jalr	1814(ra) # 800044da <iunlockput>
    return 0;
    80005dcc:	bfa5                	j	80005d44 <create+0x74>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005dce:	00492603          	lw	a2,4(s2)
    80005dd2:	00005597          	auipc	a1,0x5
    80005dd6:	89658593          	addi	a1,a1,-1898 # 8000a668 <etext+0x668>
    80005dda:	854a                	mv	a0,s2
    80005ddc:	fffff097          	auipc	ra,0xfffff
    80005de0:	bbe080e7          	jalr	-1090(ra) # 8000499a <dirlink>
    80005de4:	04054463          	bltz	a0,80005e2c <create+0x15c>
    80005de8:	40d0                	lw	a2,4(s1)
    80005dea:	00005597          	auipc	a1,0x5
    80005dee:	88658593          	addi	a1,a1,-1914 # 8000a670 <etext+0x670>
    80005df2:	854a                	mv	a0,s2
    80005df4:	fffff097          	auipc	ra,0xfffff
    80005df8:	ba6080e7          	jalr	-1114(ra) # 8000499a <dirlink>
    80005dfc:	02054863          	bltz	a0,80005e2c <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005e00:	00492603          	lw	a2,4(s2)
    80005e04:	fb040593          	addi	a1,s0,-80
    80005e08:	8526                	mv	a0,s1
    80005e0a:	fffff097          	auipc	ra,0xfffff
    80005e0e:	b90080e7          	jalr	-1136(ra) # 8000499a <dirlink>
    80005e12:	00054d63          	bltz	a0,80005e2c <create+0x15c>
    dp->nlink++;  // for ".."
    80005e16:	04a4d783          	lhu	a5,74(s1)
    80005e1a:	2785                	addiw	a5,a5,1
    80005e1c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005e20:	8526                	mv	a0,s1
    80005e22:	ffffe097          	auipc	ra,0xffffe
    80005e26:	384080e7          	jalr	900(ra) # 800041a6 <iupdate>
    80005e2a:	b769                	j	80005db4 <create+0xe4>
  ip->nlink = 0;
    80005e2c:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005e30:	854a                	mv	a0,s2
    80005e32:	ffffe097          	auipc	ra,0xffffe
    80005e36:	374080e7          	jalr	884(ra) # 800041a6 <iupdate>
  iunlockput(ip);
    80005e3a:	854a                	mv	a0,s2
    80005e3c:	ffffe097          	auipc	ra,0xffffe
    80005e40:	69e080e7          	jalr	1694(ra) # 800044da <iunlockput>
  iunlockput(dp);
    80005e44:	8526                	mv	a0,s1
    80005e46:	ffffe097          	auipc	ra,0xffffe
    80005e4a:	694080e7          	jalr	1684(ra) # 800044da <iunlockput>
  return 0;
    80005e4e:	bddd                	j	80005d44 <create+0x74>
    return 0;
    80005e50:	89aa                	mv	s3,a0
    80005e52:	bdcd                	j	80005d44 <create+0x74>

0000000080005e54 <sys_dup>:
{
    80005e54:	7179                	addi	sp,sp,-48
    80005e56:	f406                	sd	ra,40(sp)
    80005e58:	f022                	sd	s0,32(sp)
    80005e5a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005e5c:	fd840613          	addi	a2,s0,-40
    80005e60:	4581                	li	a1,0
    80005e62:	4501                	li	a0,0
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	dc6080e7          	jalr	-570(ra) # 80005c2a <argfd>
    return -1;
    80005e6c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005e6e:	02054763          	bltz	a0,80005e9c <sys_dup+0x48>
    80005e72:	ec26                	sd	s1,24(sp)
    80005e74:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005e76:	fd843483          	ld	s1,-40(s0)
    80005e7a:	8526                	mv	a0,s1
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	e10080e7          	jalr	-496(ra) # 80005c8c <fdalloc>
    80005e84:	892a                	mv	s2,a0
    return -1;
    80005e86:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005e88:	00054f63          	bltz	a0,80005ea6 <sys_dup+0x52>
  filedup(f);
    80005e8c:	8526                	mv	a0,s1
    80005e8e:	fffff097          	auipc	ra,0xfffff
    80005e92:	264080e7          	jalr	612(ra) # 800050f2 <filedup>
  return fd;
    80005e96:	87ca                	mv	a5,s2
    80005e98:	64e2                	ld	s1,24(sp)
    80005e9a:	6942                	ld	s2,16(sp)
}
    80005e9c:	853e                	mv	a0,a5
    80005e9e:	70a2                	ld	ra,40(sp)
    80005ea0:	7402                	ld	s0,32(sp)
    80005ea2:	6145                	addi	sp,sp,48
    80005ea4:	8082                	ret
    80005ea6:	64e2                	ld	s1,24(sp)
    80005ea8:	6942                	ld	s2,16(sp)
    80005eaa:	bfcd                	j	80005e9c <sys_dup+0x48>

0000000080005eac <sys_read>:
{
    80005eac:	7179                	addi	sp,sp,-48
    80005eae:	f406                	sd	ra,40(sp)
    80005eb0:	f022                	sd	s0,32(sp)
    80005eb2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005eb4:	fd840593          	addi	a1,s0,-40
    80005eb8:	4505                	li	a0,1
    80005eba:	ffffd097          	auipc	ra,0xffffd
    80005ebe:	614080e7          	jalr	1556(ra) # 800034ce <argaddr>
  argint(2, &n);
    80005ec2:	fe440593          	addi	a1,s0,-28
    80005ec6:	4509                	li	a0,2
    80005ec8:	ffffd097          	auipc	ra,0xffffd
    80005ecc:	5e6080e7          	jalr	1510(ra) # 800034ae <argint>
  if(argfd(0, 0, &f) < 0)
    80005ed0:	fe840613          	addi	a2,s0,-24
    80005ed4:	4581                	li	a1,0
    80005ed6:	4501                	li	a0,0
    80005ed8:	00000097          	auipc	ra,0x0
    80005edc:	d52080e7          	jalr	-686(ra) # 80005c2a <argfd>
    80005ee0:	87aa                	mv	a5,a0
    return -1;
    80005ee2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005ee4:	0007cc63          	bltz	a5,80005efc <sys_read+0x50>
  return fileread(f, p, n);
    80005ee8:	fe442603          	lw	a2,-28(s0)
    80005eec:	fd843583          	ld	a1,-40(s0)
    80005ef0:	fe843503          	ld	a0,-24(s0)
    80005ef4:	fffff097          	auipc	ra,0xfffff
    80005ef8:	3a8080e7          	jalr	936(ra) # 8000529c <fileread>
}
    80005efc:	70a2                	ld	ra,40(sp)
    80005efe:	7402                	ld	s0,32(sp)
    80005f00:	6145                	addi	sp,sp,48
    80005f02:	8082                	ret

0000000080005f04 <sys_write>:
{
    80005f04:	7179                	addi	sp,sp,-48
    80005f06:	f406                	sd	ra,40(sp)
    80005f08:	f022                	sd	s0,32(sp)
    80005f0a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005f0c:	fd840593          	addi	a1,s0,-40
    80005f10:	4505                	li	a0,1
    80005f12:	ffffd097          	auipc	ra,0xffffd
    80005f16:	5bc080e7          	jalr	1468(ra) # 800034ce <argaddr>
  argint(2, &n);
    80005f1a:	fe440593          	addi	a1,s0,-28
    80005f1e:	4509                	li	a0,2
    80005f20:	ffffd097          	auipc	ra,0xffffd
    80005f24:	58e080e7          	jalr	1422(ra) # 800034ae <argint>
  if(argfd(0, 0, &f) < 0)
    80005f28:	fe840613          	addi	a2,s0,-24
    80005f2c:	4581                	li	a1,0
    80005f2e:	4501                	li	a0,0
    80005f30:	00000097          	auipc	ra,0x0
    80005f34:	cfa080e7          	jalr	-774(ra) # 80005c2a <argfd>
    80005f38:	87aa                	mv	a5,a0
    return -1;
    80005f3a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005f3c:	0007cc63          	bltz	a5,80005f54 <sys_write+0x50>
  return filewrite(f, p, n);
    80005f40:	fe442603          	lw	a2,-28(s0)
    80005f44:	fd843583          	ld	a1,-40(s0)
    80005f48:	fe843503          	ld	a0,-24(s0)
    80005f4c:	fffff097          	auipc	ra,0xfffff
    80005f50:	428080e7          	jalr	1064(ra) # 80005374 <filewrite>
}
    80005f54:	70a2                	ld	ra,40(sp)
    80005f56:	7402                	ld	s0,32(sp)
    80005f58:	6145                	addi	sp,sp,48
    80005f5a:	8082                	ret

0000000080005f5c <sys_close>:
{
    80005f5c:	1101                	addi	sp,sp,-32
    80005f5e:	ec06                	sd	ra,24(sp)
    80005f60:	e822                	sd	s0,16(sp)
    80005f62:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005f64:	fe040613          	addi	a2,s0,-32
    80005f68:	fec40593          	addi	a1,s0,-20
    80005f6c:	4501                	li	a0,0
    80005f6e:	00000097          	auipc	ra,0x0
    80005f72:	cbc080e7          	jalr	-836(ra) # 80005c2a <argfd>
    return -1;
    80005f76:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005f78:	02054563          	bltz	a0,80005fa2 <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80005f7c:	ffffc097          	auipc	ra,0xffffc
    80005f80:	f02080e7          	jalr	-254(ra) # 80001e7e <myproc>
    80005f84:	fec42783          	lw	a5,-20(s0)
    80005f88:	078e                	slli	a5,a5,0x3
    80005f8a:	0d078793          	addi	a5,a5,208
    80005f8e:	953e                	add	a0,a0,a5
    80005f90:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005f94:	fe043503          	ld	a0,-32(s0)
    80005f98:	fffff097          	auipc	ra,0xfffff
    80005f9c:	1ac080e7          	jalr	428(ra) # 80005144 <fileclose>
  return 0;
    80005fa0:	4781                	li	a5,0
}
    80005fa2:	853e                	mv	a0,a5
    80005fa4:	60e2                	ld	ra,24(sp)
    80005fa6:	6442                	ld	s0,16(sp)
    80005fa8:	6105                	addi	sp,sp,32
    80005faa:	8082                	ret

0000000080005fac <sys_fstat>:
{
    80005fac:	1101                	addi	sp,sp,-32
    80005fae:	ec06                	sd	ra,24(sp)
    80005fb0:	e822                	sd	s0,16(sp)
    80005fb2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005fb4:	fe040593          	addi	a1,s0,-32
    80005fb8:	4505                	li	a0,1
    80005fba:	ffffd097          	auipc	ra,0xffffd
    80005fbe:	514080e7          	jalr	1300(ra) # 800034ce <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005fc2:	fe840613          	addi	a2,s0,-24
    80005fc6:	4581                	li	a1,0
    80005fc8:	4501                	li	a0,0
    80005fca:	00000097          	auipc	ra,0x0
    80005fce:	c60080e7          	jalr	-928(ra) # 80005c2a <argfd>
    80005fd2:	87aa                	mv	a5,a0
    return -1;
    80005fd4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005fd6:	0007ca63          	bltz	a5,80005fea <sys_fstat+0x3e>
  return filestat(f, st);
    80005fda:	fe043583          	ld	a1,-32(s0)
    80005fde:	fe843503          	ld	a0,-24(s0)
    80005fe2:	fffff097          	auipc	ra,0xfffff
    80005fe6:	244080e7          	jalr	580(ra) # 80005226 <filestat>
}
    80005fea:	60e2                	ld	ra,24(sp)
    80005fec:	6442                	ld	s0,16(sp)
    80005fee:	6105                	addi	sp,sp,32
    80005ff0:	8082                	ret

0000000080005ff2 <sys_link>:
{
    80005ff2:	7169                	addi	sp,sp,-304
    80005ff4:	f606                	sd	ra,296(sp)
    80005ff6:	f222                	sd	s0,288(sp)
    80005ff8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005ffa:	08000613          	li	a2,128
    80005ffe:	ed040593          	addi	a1,s0,-304
    80006002:	4501                	li	a0,0
    80006004:	ffffd097          	auipc	ra,0xffffd
    80006008:	4ea080e7          	jalr	1258(ra) # 800034ee <argstr>
    return -1;
    8000600c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000600e:	12054663          	bltz	a0,8000613a <sys_link+0x148>
    80006012:	08000613          	li	a2,128
    80006016:	f5040593          	addi	a1,s0,-176
    8000601a:	4505                	li	a0,1
    8000601c:	ffffd097          	auipc	ra,0xffffd
    80006020:	4d2080e7          	jalr	1234(ra) # 800034ee <argstr>
    return -1;
    80006024:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006026:	10054a63          	bltz	a0,8000613a <sys_link+0x148>
    8000602a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000602c:	fffff097          	auipc	ra,0xfffff
    80006030:	c36080e7          	jalr	-970(ra) # 80004c62 <begin_op>
  if((ip = namei(old)) == 0){
    80006034:	ed040513          	addi	a0,s0,-304
    80006038:	fffff097          	auipc	ra,0xfffff
    8000603c:	a24080e7          	jalr	-1500(ra) # 80004a5c <namei>
    80006040:	84aa                	mv	s1,a0
    80006042:	c949                	beqz	a0,800060d4 <sys_link+0xe2>
  ilock(ip);
    80006044:	ffffe097          	auipc	ra,0xffffe
    80006048:	22e080e7          	jalr	558(ra) # 80004272 <ilock>
  if(ip->type == T_DIR){
    8000604c:	04449703          	lh	a4,68(s1)
    80006050:	4785                	li	a5,1
    80006052:	08f70863          	beq	a4,a5,800060e2 <sys_link+0xf0>
    80006056:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80006058:	04a4d783          	lhu	a5,74(s1)
    8000605c:	2785                	addiw	a5,a5,1
    8000605e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006062:	8526                	mv	a0,s1
    80006064:	ffffe097          	auipc	ra,0xffffe
    80006068:	142080e7          	jalr	322(ra) # 800041a6 <iupdate>
  iunlock(ip);
    8000606c:	8526                	mv	a0,s1
    8000606e:	ffffe097          	auipc	ra,0xffffe
    80006072:	2ca080e7          	jalr	714(ra) # 80004338 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80006076:	fd040593          	addi	a1,s0,-48
    8000607a:	f5040513          	addi	a0,s0,-176
    8000607e:	fffff097          	auipc	ra,0xfffff
    80006082:	9fc080e7          	jalr	-1540(ra) # 80004a7a <nameiparent>
    80006086:	892a                	mv	s2,a0
    80006088:	cd35                	beqz	a0,80006104 <sys_link+0x112>
  ilock(dp);
    8000608a:	ffffe097          	auipc	ra,0xffffe
    8000608e:	1e8080e7          	jalr	488(ra) # 80004272 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80006092:	854a                	mv	a0,s2
    80006094:	00092703          	lw	a4,0(s2)
    80006098:	409c                	lw	a5,0(s1)
    8000609a:	06f71063          	bne	a4,a5,800060fa <sys_link+0x108>
    8000609e:	40d0                	lw	a2,4(s1)
    800060a0:	fd040593          	addi	a1,s0,-48
    800060a4:	fffff097          	auipc	ra,0xfffff
    800060a8:	8f6080e7          	jalr	-1802(ra) # 8000499a <dirlink>
    800060ac:	04054763          	bltz	a0,800060fa <sys_link+0x108>
  iunlockput(dp);
    800060b0:	854a                	mv	a0,s2
    800060b2:	ffffe097          	auipc	ra,0xffffe
    800060b6:	428080e7          	jalr	1064(ra) # 800044da <iunlockput>
  iput(ip);
    800060ba:	8526                	mv	a0,s1
    800060bc:	ffffe097          	auipc	ra,0xffffe
    800060c0:	374080e7          	jalr	884(ra) # 80004430 <iput>
  end_op();
    800060c4:	fffff097          	auipc	ra,0xfffff
    800060c8:	c1e080e7          	jalr	-994(ra) # 80004ce2 <end_op>
  return 0;
    800060cc:	4781                	li	a5,0
    800060ce:	64f2                	ld	s1,280(sp)
    800060d0:	6952                	ld	s2,272(sp)
    800060d2:	a0a5                	j	8000613a <sys_link+0x148>
    end_op();
    800060d4:	fffff097          	auipc	ra,0xfffff
    800060d8:	c0e080e7          	jalr	-1010(ra) # 80004ce2 <end_op>
    return -1;
    800060dc:	57fd                	li	a5,-1
    800060de:	64f2                	ld	s1,280(sp)
    800060e0:	a8a9                	j	8000613a <sys_link+0x148>
    iunlockput(ip);
    800060e2:	8526                	mv	a0,s1
    800060e4:	ffffe097          	auipc	ra,0xffffe
    800060e8:	3f6080e7          	jalr	1014(ra) # 800044da <iunlockput>
    end_op();
    800060ec:	fffff097          	auipc	ra,0xfffff
    800060f0:	bf6080e7          	jalr	-1034(ra) # 80004ce2 <end_op>
    return -1;
    800060f4:	57fd                	li	a5,-1
    800060f6:	64f2                	ld	s1,280(sp)
    800060f8:	a089                	j	8000613a <sys_link+0x148>
    iunlockput(dp);
    800060fa:	854a                	mv	a0,s2
    800060fc:	ffffe097          	auipc	ra,0xffffe
    80006100:	3de080e7          	jalr	990(ra) # 800044da <iunlockput>
  ilock(ip);
    80006104:	8526                	mv	a0,s1
    80006106:	ffffe097          	auipc	ra,0xffffe
    8000610a:	16c080e7          	jalr	364(ra) # 80004272 <ilock>
  ip->nlink--;
    8000610e:	04a4d783          	lhu	a5,74(s1)
    80006112:	37fd                	addiw	a5,a5,-1
    80006114:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006118:	8526                	mv	a0,s1
    8000611a:	ffffe097          	auipc	ra,0xffffe
    8000611e:	08c080e7          	jalr	140(ra) # 800041a6 <iupdate>
  iunlockput(ip);
    80006122:	8526                	mv	a0,s1
    80006124:	ffffe097          	auipc	ra,0xffffe
    80006128:	3b6080e7          	jalr	950(ra) # 800044da <iunlockput>
  end_op();
    8000612c:	fffff097          	auipc	ra,0xfffff
    80006130:	bb6080e7          	jalr	-1098(ra) # 80004ce2 <end_op>
  return -1;
    80006134:	57fd                	li	a5,-1
    80006136:	64f2                	ld	s1,280(sp)
    80006138:	6952                	ld	s2,272(sp)
}
    8000613a:	853e                	mv	a0,a5
    8000613c:	70b2                	ld	ra,296(sp)
    8000613e:	7412                	ld	s0,288(sp)
    80006140:	6155                	addi	sp,sp,304
    80006142:	8082                	ret

0000000080006144 <sys_unlink>:
{
    80006144:	7151                	addi	sp,sp,-240
    80006146:	f586                	sd	ra,232(sp)
    80006148:	f1a2                	sd	s0,224(sp)
    8000614a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000614c:	08000613          	li	a2,128
    80006150:	f3040593          	addi	a1,s0,-208
    80006154:	4501                	li	a0,0
    80006156:	ffffd097          	auipc	ra,0xffffd
    8000615a:	398080e7          	jalr	920(ra) # 800034ee <argstr>
    8000615e:	1a054763          	bltz	a0,8000630c <sys_unlink+0x1c8>
    80006162:	eda6                	sd	s1,216(sp)
  begin_op();
    80006164:	fffff097          	auipc	ra,0xfffff
    80006168:	afe080e7          	jalr	-1282(ra) # 80004c62 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000616c:	fb040593          	addi	a1,s0,-80
    80006170:	f3040513          	addi	a0,s0,-208
    80006174:	fffff097          	auipc	ra,0xfffff
    80006178:	906080e7          	jalr	-1786(ra) # 80004a7a <nameiparent>
    8000617c:	84aa                	mv	s1,a0
    8000617e:	c165                	beqz	a0,8000625e <sys_unlink+0x11a>
  ilock(dp);
    80006180:	ffffe097          	auipc	ra,0xffffe
    80006184:	0f2080e7          	jalr	242(ra) # 80004272 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006188:	00004597          	auipc	a1,0x4
    8000618c:	4e058593          	addi	a1,a1,1248 # 8000a668 <etext+0x668>
    80006190:	fb040513          	addi	a0,s0,-80
    80006194:	ffffe097          	auipc	ra,0xffffe
    80006198:	5be080e7          	jalr	1470(ra) # 80004752 <namecmp>
    8000619c:	14050963          	beqz	a0,800062ee <sys_unlink+0x1aa>
    800061a0:	00004597          	auipc	a1,0x4
    800061a4:	4d058593          	addi	a1,a1,1232 # 8000a670 <etext+0x670>
    800061a8:	fb040513          	addi	a0,s0,-80
    800061ac:	ffffe097          	auipc	ra,0xffffe
    800061b0:	5a6080e7          	jalr	1446(ra) # 80004752 <namecmp>
    800061b4:	12050d63          	beqz	a0,800062ee <sys_unlink+0x1aa>
    800061b8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800061ba:	f2c40613          	addi	a2,s0,-212
    800061be:	fb040593          	addi	a1,s0,-80
    800061c2:	8526                	mv	a0,s1
    800061c4:	ffffe097          	auipc	ra,0xffffe
    800061c8:	5a8080e7          	jalr	1448(ra) # 8000476c <dirlookup>
    800061cc:	892a                	mv	s2,a0
    800061ce:	10050f63          	beqz	a0,800062ec <sys_unlink+0x1a8>
    800061d2:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800061d4:	ffffe097          	auipc	ra,0xffffe
    800061d8:	09e080e7          	jalr	158(ra) # 80004272 <ilock>
  if(ip->nlink < 1)
    800061dc:	04a91783          	lh	a5,74(s2)
    800061e0:	08f05663          	blez	a5,8000626c <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800061e4:	04491703          	lh	a4,68(s2)
    800061e8:	4785                	li	a5,1
    800061ea:	08f70963          	beq	a4,a5,8000627c <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
    800061ee:	fc040993          	addi	s3,s0,-64
    800061f2:	4641                	li	a2,16
    800061f4:	4581                	li	a1,0
    800061f6:	854e                	mv	a0,s3
    800061f8:	ffffb097          	auipc	ra,0xffffb
    800061fc:	c34080e7          	jalr	-972(ra) # 80000e2c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006200:	4741                	li	a4,16
    80006202:	f2c42683          	lw	a3,-212(s0)
    80006206:	864e                	mv	a2,s3
    80006208:	4581                	li	a1,0
    8000620a:	8526                	mv	a0,s1
    8000620c:	ffffe097          	auipc	ra,0xffffe
    80006210:	42a080e7          	jalr	1066(ra) # 80004636 <writei>
    80006214:	47c1                	li	a5,16
    80006216:	0af51863          	bne	a0,a5,800062c6 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    8000621a:	04491703          	lh	a4,68(s2)
    8000621e:	4785                	li	a5,1
    80006220:	0af70b63          	beq	a4,a5,800062d6 <sys_unlink+0x192>
  iunlockput(dp);
    80006224:	8526                	mv	a0,s1
    80006226:	ffffe097          	auipc	ra,0xffffe
    8000622a:	2b4080e7          	jalr	692(ra) # 800044da <iunlockput>
  ip->nlink--;
    8000622e:	04a95783          	lhu	a5,74(s2)
    80006232:	37fd                	addiw	a5,a5,-1
    80006234:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80006238:	854a                	mv	a0,s2
    8000623a:	ffffe097          	auipc	ra,0xffffe
    8000623e:	f6c080e7          	jalr	-148(ra) # 800041a6 <iupdate>
  iunlockput(ip);
    80006242:	854a                	mv	a0,s2
    80006244:	ffffe097          	auipc	ra,0xffffe
    80006248:	296080e7          	jalr	662(ra) # 800044da <iunlockput>
  end_op();
    8000624c:	fffff097          	auipc	ra,0xfffff
    80006250:	a96080e7          	jalr	-1386(ra) # 80004ce2 <end_op>
  return 0;
    80006254:	4501                	li	a0,0
    80006256:	64ee                	ld	s1,216(sp)
    80006258:	694e                	ld	s2,208(sp)
    8000625a:	69ae                	ld	s3,200(sp)
    8000625c:	a065                	j	80006304 <sys_unlink+0x1c0>
    end_op();
    8000625e:	fffff097          	auipc	ra,0xfffff
    80006262:	a84080e7          	jalr	-1404(ra) # 80004ce2 <end_op>
    return -1;
    80006266:	557d                	li	a0,-1
    80006268:	64ee                	ld	s1,216(sp)
    8000626a:	a869                	j	80006304 <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    8000626c:	00004517          	auipc	a0,0x4
    80006270:	40c50513          	addi	a0,a0,1036 # 8000a678 <etext+0x678>
    80006274:	ffffa097          	auipc	ra,0xffffa
    80006278:	2ea080e7          	jalr	746(ra) # 8000055e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000627c:	04c92703          	lw	a4,76(s2)
    80006280:	02000793          	li	a5,32
    80006284:	f6e7f5e3          	bgeu	a5,a4,800061ee <sys_unlink+0xaa>
    80006288:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000628a:	4741                	li	a4,16
    8000628c:	86ce                	mv	a3,s3
    8000628e:	f1840613          	addi	a2,s0,-232
    80006292:	4581                	li	a1,0
    80006294:	854a                	mv	a0,s2
    80006296:	ffffe097          	auipc	ra,0xffffe
    8000629a:	29a080e7          	jalr	666(ra) # 80004530 <readi>
    8000629e:	47c1                	li	a5,16
    800062a0:	00f51b63          	bne	a0,a5,800062b6 <sys_unlink+0x172>
    if(de.inum != 0)
    800062a4:	f1845783          	lhu	a5,-232(s0)
    800062a8:	e7a5                	bnez	a5,80006310 <sys_unlink+0x1cc>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800062aa:	29c1                	addiw	s3,s3,16
    800062ac:	04c92783          	lw	a5,76(s2)
    800062b0:	fcf9ede3          	bltu	s3,a5,8000628a <sys_unlink+0x146>
    800062b4:	bf2d                	j	800061ee <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800062b6:	00004517          	auipc	a0,0x4
    800062ba:	3da50513          	addi	a0,a0,986 # 8000a690 <etext+0x690>
    800062be:	ffffa097          	auipc	ra,0xffffa
    800062c2:	2a0080e7          	jalr	672(ra) # 8000055e <panic>
    panic("unlink: writei");
    800062c6:	00004517          	auipc	a0,0x4
    800062ca:	3e250513          	addi	a0,a0,994 # 8000a6a8 <etext+0x6a8>
    800062ce:	ffffa097          	auipc	ra,0xffffa
    800062d2:	290080e7          	jalr	656(ra) # 8000055e <panic>
    dp->nlink--;
    800062d6:	04a4d783          	lhu	a5,74(s1)
    800062da:	37fd                	addiw	a5,a5,-1
    800062dc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800062e0:	8526                	mv	a0,s1
    800062e2:	ffffe097          	auipc	ra,0xffffe
    800062e6:	ec4080e7          	jalr	-316(ra) # 800041a6 <iupdate>
    800062ea:	bf2d                	j	80006224 <sys_unlink+0xe0>
    800062ec:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800062ee:	8526                	mv	a0,s1
    800062f0:	ffffe097          	auipc	ra,0xffffe
    800062f4:	1ea080e7          	jalr	490(ra) # 800044da <iunlockput>
  end_op();
    800062f8:	fffff097          	auipc	ra,0xfffff
    800062fc:	9ea080e7          	jalr	-1558(ra) # 80004ce2 <end_op>
  return -1;
    80006300:	557d                	li	a0,-1
    80006302:	64ee                	ld	s1,216(sp)
}
    80006304:	70ae                	ld	ra,232(sp)
    80006306:	740e                	ld	s0,224(sp)
    80006308:	616d                	addi	sp,sp,240
    8000630a:	8082                	ret
    return -1;
    8000630c:	557d                	li	a0,-1
    8000630e:	bfdd                	j	80006304 <sys_unlink+0x1c0>
    iunlockput(ip);
    80006310:	854a                	mv	a0,s2
    80006312:	ffffe097          	auipc	ra,0xffffe
    80006316:	1c8080e7          	jalr	456(ra) # 800044da <iunlockput>
    goto bad;
    8000631a:	694e                	ld	s2,208(sp)
    8000631c:	69ae                	ld	s3,200(sp)
    8000631e:	bfc1                	j	800062ee <sys_unlink+0x1aa>

0000000080006320 <sys_open>:

uint64
sys_open(void)
{
    80006320:	7131                	addi	sp,sp,-192
    80006322:	fd06                	sd	ra,184(sp)
    80006324:	f922                	sd	s0,176(sp)
    80006326:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80006328:	f4c40593          	addi	a1,s0,-180
    8000632c:	4505                	li	a0,1
    8000632e:	ffffd097          	auipc	ra,0xffffd
    80006332:	180080e7          	jalr	384(ra) # 800034ae <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006336:	08000613          	li	a2,128
    8000633a:	f5040593          	addi	a1,s0,-176
    8000633e:	4501                	li	a0,0
    80006340:	ffffd097          	auipc	ra,0xffffd
    80006344:	1ae080e7          	jalr	430(ra) # 800034ee <argstr>
    80006348:	87aa                	mv	a5,a0
    return -1;
    8000634a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000634c:	0a07cf63          	bltz	a5,8000640a <sys_open+0xea>
    80006350:	f526                	sd	s1,168(sp)

  begin_op();
    80006352:	fffff097          	auipc	ra,0xfffff
    80006356:	910080e7          	jalr	-1776(ra) # 80004c62 <begin_op>

  if(omode & O_CREATE){
    8000635a:	f4c42783          	lw	a5,-180(s0)
    8000635e:	2007f793          	andi	a5,a5,512
    80006362:	cfdd                	beqz	a5,80006420 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80006364:	4681                	li	a3,0
    80006366:	4601                	li	a2,0
    80006368:	4589                	li	a1,2
    8000636a:	f5040513          	addi	a0,s0,-176
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	962080e7          	jalr	-1694(ra) # 80005cd0 <create>
    80006376:	84aa                	mv	s1,a0
    if(ip == 0){
    80006378:	cd49                	beqz	a0,80006412 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000637a:	04449703          	lh	a4,68(s1)
    8000637e:	478d                	li	a5,3
    80006380:	00f71763          	bne	a4,a5,8000638e <sys_open+0x6e>
    80006384:	0464d703          	lhu	a4,70(s1)
    80006388:	47a5                	li	a5,9
    8000638a:	0ee7e263          	bltu	a5,a4,8000646e <sys_open+0x14e>
    8000638e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006390:	fffff097          	auipc	ra,0xfffff
    80006394:	cf8080e7          	jalr	-776(ra) # 80005088 <filealloc>
    80006398:	892a                	mv	s2,a0
    8000639a:	cd65                	beqz	a0,80006492 <sys_open+0x172>
    8000639c:	ed4e                	sd	s3,152(sp)
    8000639e:	00000097          	auipc	ra,0x0
    800063a2:	8ee080e7          	jalr	-1810(ra) # 80005c8c <fdalloc>
    800063a6:	89aa                	mv	s3,a0
    800063a8:	0c054f63          	bltz	a0,80006486 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800063ac:	04449703          	lh	a4,68(s1)
    800063b0:	478d                	li	a5,3
    800063b2:	0ef70d63          	beq	a4,a5,800064ac <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800063b6:	4789                	li	a5,2
    800063b8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800063bc:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800063c0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800063c4:	f4c42783          	lw	a5,-180(s0)
    800063c8:	0017f713          	andi	a4,a5,1
    800063cc:	00174713          	xori	a4,a4,1
    800063d0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800063d4:	0037f713          	andi	a4,a5,3
    800063d8:	00e03733          	snez	a4,a4
    800063dc:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800063e0:	4007f793          	andi	a5,a5,1024
    800063e4:	c791                	beqz	a5,800063f0 <sys_open+0xd0>
    800063e6:	04449703          	lh	a4,68(s1)
    800063ea:	4789                	li	a5,2
    800063ec:	0cf70763          	beq	a4,a5,800064ba <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    800063f0:	8526                	mv	a0,s1
    800063f2:	ffffe097          	auipc	ra,0xffffe
    800063f6:	f46080e7          	jalr	-186(ra) # 80004338 <iunlock>
  end_op();
    800063fa:	fffff097          	auipc	ra,0xfffff
    800063fe:	8e8080e7          	jalr	-1816(ra) # 80004ce2 <end_op>

  return fd;
    80006402:	854e                	mv	a0,s3
    80006404:	74aa                	ld	s1,168(sp)
    80006406:	790a                	ld	s2,160(sp)
    80006408:	69ea                	ld	s3,152(sp)
}
    8000640a:	70ea                	ld	ra,184(sp)
    8000640c:	744a                	ld	s0,176(sp)
    8000640e:	6129                	addi	sp,sp,192
    80006410:	8082                	ret
      end_op();
    80006412:	fffff097          	auipc	ra,0xfffff
    80006416:	8d0080e7          	jalr	-1840(ra) # 80004ce2 <end_op>
      return -1;
    8000641a:	557d                	li	a0,-1
    8000641c:	74aa                	ld	s1,168(sp)
    8000641e:	b7f5                	j	8000640a <sys_open+0xea>
    if((ip = namei(path)) == 0){
    80006420:	f5040513          	addi	a0,s0,-176
    80006424:	ffffe097          	auipc	ra,0xffffe
    80006428:	638080e7          	jalr	1592(ra) # 80004a5c <namei>
    8000642c:	84aa                	mv	s1,a0
    8000642e:	c90d                	beqz	a0,80006460 <sys_open+0x140>
    ilock(ip);
    80006430:	ffffe097          	auipc	ra,0xffffe
    80006434:	e42080e7          	jalr	-446(ra) # 80004272 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006438:	04449703          	lh	a4,68(s1)
    8000643c:	4785                	li	a5,1
    8000643e:	f2f71ee3          	bne	a4,a5,8000637a <sys_open+0x5a>
    80006442:	f4c42783          	lw	a5,-180(s0)
    80006446:	d7a1                	beqz	a5,8000638e <sys_open+0x6e>
      iunlockput(ip);
    80006448:	8526                	mv	a0,s1
    8000644a:	ffffe097          	auipc	ra,0xffffe
    8000644e:	090080e7          	jalr	144(ra) # 800044da <iunlockput>
      end_op();
    80006452:	fffff097          	auipc	ra,0xfffff
    80006456:	890080e7          	jalr	-1904(ra) # 80004ce2 <end_op>
      return -1;
    8000645a:	557d                	li	a0,-1
    8000645c:	74aa                	ld	s1,168(sp)
    8000645e:	b775                	j	8000640a <sys_open+0xea>
      end_op();
    80006460:	fffff097          	auipc	ra,0xfffff
    80006464:	882080e7          	jalr	-1918(ra) # 80004ce2 <end_op>
      return -1;
    80006468:	557d                	li	a0,-1
    8000646a:	74aa                	ld	s1,168(sp)
    8000646c:	bf79                	j	8000640a <sys_open+0xea>
    iunlockput(ip);
    8000646e:	8526                	mv	a0,s1
    80006470:	ffffe097          	auipc	ra,0xffffe
    80006474:	06a080e7          	jalr	106(ra) # 800044da <iunlockput>
    end_op();
    80006478:	fffff097          	auipc	ra,0xfffff
    8000647c:	86a080e7          	jalr	-1942(ra) # 80004ce2 <end_op>
    return -1;
    80006480:	557d                	li	a0,-1
    80006482:	74aa                	ld	s1,168(sp)
    80006484:	b759                	j	8000640a <sys_open+0xea>
      fileclose(f);
    80006486:	854a                	mv	a0,s2
    80006488:	fffff097          	auipc	ra,0xfffff
    8000648c:	cbc080e7          	jalr	-836(ra) # 80005144 <fileclose>
    80006490:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80006492:	8526                	mv	a0,s1
    80006494:	ffffe097          	auipc	ra,0xffffe
    80006498:	046080e7          	jalr	70(ra) # 800044da <iunlockput>
    end_op();
    8000649c:	fffff097          	auipc	ra,0xfffff
    800064a0:	846080e7          	jalr	-1978(ra) # 80004ce2 <end_op>
    return -1;
    800064a4:	557d                	li	a0,-1
    800064a6:	74aa                	ld	s1,168(sp)
    800064a8:	790a                	ld	s2,160(sp)
    800064aa:	b785                	j	8000640a <sys_open+0xea>
    f->type = FD_DEVICE;
    800064ac:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800064b0:	04649783          	lh	a5,70(s1)
    800064b4:	02f91223          	sh	a5,36(s2)
    800064b8:	b721                	j	800063c0 <sys_open+0xa0>
    itrunc(ip);
    800064ba:	8526                	mv	a0,s1
    800064bc:	ffffe097          	auipc	ra,0xffffe
    800064c0:	ec8080e7          	jalr	-312(ra) # 80004384 <itrunc>
    800064c4:	b735                	j	800063f0 <sys_open+0xd0>

00000000800064c6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800064c6:	7175                	addi	sp,sp,-144
    800064c8:	e506                	sd	ra,136(sp)
    800064ca:	e122                	sd	s0,128(sp)
    800064cc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800064ce:	ffffe097          	auipc	ra,0xffffe
    800064d2:	794080e7          	jalr	1940(ra) # 80004c62 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800064d6:	08000613          	li	a2,128
    800064da:	f7040593          	addi	a1,s0,-144
    800064de:	4501                	li	a0,0
    800064e0:	ffffd097          	auipc	ra,0xffffd
    800064e4:	00e080e7          	jalr	14(ra) # 800034ee <argstr>
    800064e8:	02054963          	bltz	a0,8000651a <sys_mkdir+0x54>
    800064ec:	4681                	li	a3,0
    800064ee:	4601                	li	a2,0
    800064f0:	4585                	li	a1,1
    800064f2:	f7040513          	addi	a0,s0,-144
    800064f6:	fffff097          	auipc	ra,0xfffff
    800064fa:	7da080e7          	jalr	2010(ra) # 80005cd0 <create>
    800064fe:	cd11                	beqz	a0,8000651a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006500:	ffffe097          	auipc	ra,0xffffe
    80006504:	fda080e7          	jalr	-38(ra) # 800044da <iunlockput>
  end_op();
    80006508:	ffffe097          	auipc	ra,0xffffe
    8000650c:	7da080e7          	jalr	2010(ra) # 80004ce2 <end_op>
  return 0;
    80006510:	4501                	li	a0,0
}
    80006512:	60aa                	ld	ra,136(sp)
    80006514:	640a                	ld	s0,128(sp)
    80006516:	6149                	addi	sp,sp,144
    80006518:	8082                	ret
    end_op();
    8000651a:	ffffe097          	auipc	ra,0xffffe
    8000651e:	7c8080e7          	jalr	1992(ra) # 80004ce2 <end_op>
    return -1;
    80006522:	557d                	li	a0,-1
    80006524:	b7fd                	j	80006512 <sys_mkdir+0x4c>

0000000080006526 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006526:	7135                	addi	sp,sp,-160
    80006528:	ed06                	sd	ra,152(sp)
    8000652a:	e922                	sd	s0,144(sp)
    8000652c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000652e:	ffffe097          	auipc	ra,0xffffe
    80006532:	734080e7          	jalr	1844(ra) # 80004c62 <begin_op>
  argint(1, &major);
    80006536:	f6c40593          	addi	a1,s0,-148
    8000653a:	4505                	li	a0,1
    8000653c:	ffffd097          	auipc	ra,0xffffd
    80006540:	f72080e7          	jalr	-142(ra) # 800034ae <argint>
  argint(2, &minor);
    80006544:	f6840593          	addi	a1,s0,-152
    80006548:	4509                	li	a0,2
    8000654a:	ffffd097          	auipc	ra,0xffffd
    8000654e:	f64080e7          	jalr	-156(ra) # 800034ae <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006552:	08000613          	li	a2,128
    80006556:	f7040593          	addi	a1,s0,-144
    8000655a:	4501                	li	a0,0
    8000655c:	ffffd097          	auipc	ra,0xffffd
    80006560:	f92080e7          	jalr	-110(ra) # 800034ee <argstr>
    80006564:	02054b63          	bltz	a0,8000659a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80006568:	f6841683          	lh	a3,-152(s0)
    8000656c:	f6c41603          	lh	a2,-148(s0)
    80006570:	458d                	li	a1,3
    80006572:	f7040513          	addi	a0,s0,-144
    80006576:	fffff097          	auipc	ra,0xfffff
    8000657a:	75a080e7          	jalr	1882(ra) # 80005cd0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000657e:	cd11                	beqz	a0,8000659a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006580:	ffffe097          	auipc	ra,0xffffe
    80006584:	f5a080e7          	jalr	-166(ra) # 800044da <iunlockput>
  end_op();
    80006588:	ffffe097          	auipc	ra,0xffffe
    8000658c:	75a080e7          	jalr	1882(ra) # 80004ce2 <end_op>
  return 0;
    80006590:	4501                	li	a0,0
}
    80006592:	60ea                	ld	ra,152(sp)
    80006594:	644a                	ld	s0,144(sp)
    80006596:	610d                	addi	sp,sp,160
    80006598:	8082                	ret
    end_op();
    8000659a:	ffffe097          	auipc	ra,0xffffe
    8000659e:	748080e7          	jalr	1864(ra) # 80004ce2 <end_op>
    return -1;
    800065a2:	557d                	li	a0,-1
    800065a4:	b7fd                	j	80006592 <sys_mknod+0x6c>

00000000800065a6 <sys_chdir>:

uint64
sys_chdir(void)
{
    800065a6:	7135                	addi	sp,sp,-160
    800065a8:	ed06                	sd	ra,152(sp)
    800065aa:	e922                	sd	s0,144(sp)
    800065ac:	e14a                	sd	s2,128(sp)
    800065ae:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800065b0:	ffffc097          	auipc	ra,0xffffc
    800065b4:	8ce080e7          	jalr	-1842(ra) # 80001e7e <myproc>
    800065b8:	892a                	mv	s2,a0
  
  begin_op();
    800065ba:	ffffe097          	auipc	ra,0xffffe
    800065be:	6a8080e7          	jalr	1704(ra) # 80004c62 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800065c2:	08000613          	li	a2,128
    800065c6:	f6040593          	addi	a1,s0,-160
    800065ca:	4501                	li	a0,0
    800065cc:	ffffd097          	auipc	ra,0xffffd
    800065d0:	f22080e7          	jalr	-222(ra) # 800034ee <argstr>
    800065d4:	04054d63          	bltz	a0,8000662e <sys_chdir+0x88>
    800065d8:	e526                	sd	s1,136(sp)
    800065da:	f6040513          	addi	a0,s0,-160
    800065de:	ffffe097          	auipc	ra,0xffffe
    800065e2:	47e080e7          	jalr	1150(ra) # 80004a5c <namei>
    800065e6:	84aa                	mv	s1,a0
    800065e8:	c131                	beqz	a0,8000662c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800065ea:	ffffe097          	auipc	ra,0xffffe
    800065ee:	c88080e7          	jalr	-888(ra) # 80004272 <ilock>
  if(ip->type != T_DIR){
    800065f2:	04449703          	lh	a4,68(s1)
    800065f6:	4785                	li	a5,1
    800065f8:	04f71163          	bne	a4,a5,8000663a <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800065fc:	8526                	mv	a0,s1
    800065fe:	ffffe097          	auipc	ra,0xffffe
    80006602:	d3a080e7          	jalr	-710(ra) # 80004338 <iunlock>
  iput(p->cwd);
    80006606:	15093503          	ld	a0,336(s2)
    8000660a:	ffffe097          	auipc	ra,0xffffe
    8000660e:	e26080e7          	jalr	-474(ra) # 80004430 <iput>
  end_op();
    80006612:	ffffe097          	auipc	ra,0xffffe
    80006616:	6d0080e7          	jalr	1744(ra) # 80004ce2 <end_op>
  p->cwd = ip;
    8000661a:	14993823          	sd	s1,336(s2)
  return 0;
    8000661e:	4501                	li	a0,0
    80006620:	64aa                	ld	s1,136(sp)
}
    80006622:	60ea                	ld	ra,152(sp)
    80006624:	644a                	ld	s0,144(sp)
    80006626:	690a                	ld	s2,128(sp)
    80006628:	610d                	addi	sp,sp,160
    8000662a:	8082                	ret
    8000662c:	64aa                	ld	s1,136(sp)
    end_op();
    8000662e:	ffffe097          	auipc	ra,0xffffe
    80006632:	6b4080e7          	jalr	1716(ra) # 80004ce2 <end_op>
    return -1;
    80006636:	557d                	li	a0,-1
    80006638:	b7ed                	j	80006622 <sys_chdir+0x7c>
    iunlockput(ip);
    8000663a:	8526                	mv	a0,s1
    8000663c:	ffffe097          	auipc	ra,0xffffe
    80006640:	e9e080e7          	jalr	-354(ra) # 800044da <iunlockput>
    end_op();
    80006644:	ffffe097          	auipc	ra,0xffffe
    80006648:	69e080e7          	jalr	1694(ra) # 80004ce2 <end_op>
    return -1;
    8000664c:	557d                	li	a0,-1
    8000664e:	64aa                	ld	s1,136(sp)
    80006650:	bfc9                	j	80006622 <sys_chdir+0x7c>

0000000080006652 <sys_exec>:

uint64
sys_exec(void)
{
    80006652:	7105                	addi	sp,sp,-480
    80006654:	ef86                	sd	ra,472(sp)
    80006656:	eba2                	sd	s0,464(sp)
    80006658:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000665a:	e2840593          	addi	a1,s0,-472
    8000665e:	4505                	li	a0,1
    80006660:	ffffd097          	auipc	ra,0xffffd
    80006664:	e6e080e7          	jalr	-402(ra) # 800034ce <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006668:	08000613          	li	a2,128
    8000666c:	f3040593          	addi	a1,s0,-208
    80006670:	4501                	li	a0,0
    80006672:	ffffd097          	auipc	ra,0xffffd
    80006676:	e7c080e7          	jalr	-388(ra) # 800034ee <argstr>
    8000667a:	87aa                	mv	a5,a0
    return -1;
    8000667c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000667e:	0e07ce63          	bltz	a5,8000677a <sys_exec+0x128>
    80006682:	e7a6                	sd	s1,456(sp)
    80006684:	e3ca                	sd	s2,448(sp)
    80006686:	ff4e                	sd	s3,440(sp)
    80006688:	fb52                	sd	s4,432(sp)
    8000668a:	f756                	sd	s5,424(sp)
    8000668c:	f35a                	sd	s6,416(sp)
    8000668e:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80006690:	e3040a13          	addi	s4,s0,-464
    80006694:	10000613          	li	a2,256
    80006698:	4581                	li	a1,0
    8000669a:	8552                	mv	a0,s4
    8000669c:	ffffa097          	auipc	ra,0xffffa
    800066a0:	790080e7          	jalr	1936(ra) # 80000e2c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800066a4:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800066a6:	89d2                	mv	s3,s4
    800066a8:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800066aa:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800066ae:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800066b0:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800066b4:	00391513          	slli	a0,s2,0x3
    800066b8:	85d6                	mv	a1,s5
    800066ba:	e2843783          	ld	a5,-472(s0)
    800066be:	953e                	add	a0,a0,a5
    800066c0:	ffffd097          	auipc	ra,0xffffd
    800066c4:	d50080e7          	jalr	-688(ra) # 80003410 <fetchaddr>
    800066c8:	02054a63          	bltz	a0,800066fc <sys_exec+0xaa>
    if(uarg == 0){
    800066cc:	e2043783          	ld	a5,-480(s0)
    800066d0:	cbb1                	beqz	a5,80006724 <sys_exec+0xd2>
    argv[i] = kalloc();
    800066d2:	ffffa097          	auipc	ra,0xffffa
    800066d6:	540080e7          	jalr	1344(ra) # 80000c12 <kalloc>
    800066da:	85aa                	mv	a1,a0
    800066dc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800066e0:	cd11                	beqz	a0,800066fc <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800066e2:	865a                	mv	a2,s6
    800066e4:	e2043503          	ld	a0,-480(s0)
    800066e8:	ffffd097          	auipc	ra,0xffffd
    800066ec:	d7a080e7          	jalr	-646(ra) # 80003462 <fetchstr>
    800066f0:	00054663          	bltz	a0,800066fc <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    800066f4:	0905                	addi	s2,s2,1
    800066f6:	09a1                	addi	s3,s3,8
    800066f8:	fb791ee3          	bne	s2,s7,800066b4 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800066fc:	100a0a13          	addi	s4,s4,256
    80006700:	6088                	ld	a0,0(s1)
    80006702:	c525                	beqz	a0,8000676a <sys_exec+0x118>
    kfree(argv[i]);
    80006704:	ffffa097          	auipc	ra,0xffffa
    80006708:	3a0080e7          	jalr	928(ra) # 80000aa4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000670c:	04a1                	addi	s1,s1,8
    8000670e:	ff4499e3          	bne	s1,s4,80006700 <sys_exec+0xae>
  return -1;
    80006712:	557d                	li	a0,-1
    80006714:	64be                	ld	s1,456(sp)
    80006716:	691e                	ld	s2,448(sp)
    80006718:	79fa                	ld	s3,440(sp)
    8000671a:	7a5a                	ld	s4,432(sp)
    8000671c:	7aba                	ld	s5,424(sp)
    8000671e:	7b1a                	ld	s6,416(sp)
    80006720:	6bfa                	ld	s7,408(sp)
    80006722:	a8a1                	j	8000677a <sys_exec+0x128>
      argv[i] = 0;
    80006724:	0009079b          	sext.w	a5,s2
    80006728:	e3040593          	addi	a1,s0,-464
    8000672c:	078e                	slli	a5,a5,0x3
    8000672e:	97ae                	add	a5,a5,a1
    80006730:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80006734:	f3040513          	addi	a0,s0,-208
    80006738:	fffff097          	auipc	ra,0xfffff
    8000673c:	126080e7          	jalr	294(ra) # 8000585e <exec>
    80006740:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006742:	100a0a13          	addi	s4,s4,256
    80006746:	6088                	ld	a0,0(s1)
    80006748:	c901                	beqz	a0,80006758 <sys_exec+0x106>
    kfree(argv[i]);
    8000674a:	ffffa097          	auipc	ra,0xffffa
    8000674e:	35a080e7          	jalr	858(ra) # 80000aa4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006752:	04a1                	addi	s1,s1,8
    80006754:	ff4499e3          	bne	s1,s4,80006746 <sys_exec+0xf4>
  return ret;
    80006758:	854a                	mv	a0,s2
    8000675a:	64be                	ld	s1,456(sp)
    8000675c:	691e                	ld	s2,448(sp)
    8000675e:	79fa                	ld	s3,440(sp)
    80006760:	7a5a                	ld	s4,432(sp)
    80006762:	7aba                	ld	s5,424(sp)
    80006764:	7b1a                	ld	s6,416(sp)
    80006766:	6bfa                	ld	s7,408(sp)
    80006768:	a809                	j	8000677a <sys_exec+0x128>
  return -1;
    8000676a:	557d                	li	a0,-1
    8000676c:	64be                	ld	s1,456(sp)
    8000676e:	691e                	ld	s2,448(sp)
    80006770:	79fa                	ld	s3,440(sp)
    80006772:	7a5a                	ld	s4,432(sp)
    80006774:	7aba                	ld	s5,424(sp)
    80006776:	7b1a                	ld	s6,416(sp)
    80006778:	6bfa                	ld	s7,408(sp)
}
    8000677a:	60fe                	ld	ra,472(sp)
    8000677c:	645e                	ld	s0,464(sp)
    8000677e:	613d                	addi	sp,sp,480
    80006780:	8082                	ret

0000000080006782 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006782:	7139                	addi	sp,sp,-64
    80006784:	fc06                	sd	ra,56(sp)
    80006786:	f822                	sd	s0,48(sp)
    80006788:	f426                	sd	s1,40(sp)
    8000678a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000678c:	ffffb097          	auipc	ra,0xffffb
    80006790:	6f2080e7          	jalr	1778(ra) # 80001e7e <myproc>
    80006794:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006796:	fd840593          	addi	a1,s0,-40
    8000679a:	4501                	li	a0,0
    8000679c:	ffffd097          	auipc	ra,0xffffd
    800067a0:	d32080e7          	jalr	-718(ra) # 800034ce <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800067a4:	fc840593          	addi	a1,s0,-56
    800067a8:	fd040513          	addi	a0,s0,-48
    800067ac:	fffff097          	auipc	ra,0xfffff
    800067b0:	d18080e7          	jalr	-744(ra) # 800054c4 <pipealloc>
    return -1;
    800067b4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800067b6:	0c054763          	bltz	a0,80006884 <sys_pipe+0x102>
  fd0 = -1;
    800067ba:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800067be:	fd043503          	ld	a0,-48(s0)
    800067c2:	fffff097          	auipc	ra,0xfffff
    800067c6:	4ca080e7          	jalr	1226(ra) # 80005c8c <fdalloc>
    800067ca:	fca42223          	sw	a0,-60(s0)
    800067ce:	08054e63          	bltz	a0,8000686a <sys_pipe+0xe8>
    800067d2:	fc843503          	ld	a0,-56(s0)
    800067d6:	fffff097          	auipc	ra,0xfffff
    800067da:	4b6080e7          	jalr	1206(ra) # 80005c8c <fdalloc>
    800067de:	fca42023          	sw	a0,-64(s0)
    800067e2:	06054a63          	bltz	a0,80006856 <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800067e6:	4691                	li	a3,4
    800067e8:	fc440613          	addi	a2,s0,-60
    800067ec:	fd843583          	ld	a1,-40(s0)
    800067f0:	68a8                	ld	a0,80(s1)
    800067f2:	ffffb097          	auipc	ra,0xffffb
    800067f6:	318080e7          	jalr	792(ra) # 80001b0a <copyout>
    800067fa:	02054063          	bltz	a0,8000681a <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800067fe:	4691                	li	a3,4
    80006800:	fc040613          	addi	a2,s0,-64
    80006804:	fd843583          	ld	a1,-40(s0)
    80006808:	95b6                	add	a1,a1,a3
    8000680a:	68a8                	ld	a0,80(s1)
    8000680c:	ffffb097          	auipc	ra,0xffffb
    80006810:	2fe080e7          	jalr	766(ra) # 80001b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006814:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006816:	06055763          	bgez	a0,80006884 <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    8000681a:	fc442783          	lw	a5,-60(s0)
    8000681e:	078e                	slli	a5,a5,0x3
    80006820:	0d078793          	addi	a5,a5,208
    80006824:	97a6                	add	a5,a5,s1
    80006826:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000682a:	fc042783          	lw	a5,-64(s0)
    8000682e:	078e                	slli	a5,a5,0x3
    80006830:	0d078793          	addi	a5,a5,208
    80006834:	97a6                	add	a5,a5,s1
    80006836:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000683a:	fd043503          	ld	a0,-48(s0)
    8000683e:	fffff097          	auipc	ra,0xfffff
    80006842:	906080e7          	jalr	-1786(ra) # 80005144 <fileclose>
    fileclose(wf);
    80006846:	fc843503          	ld	a0,-56(s0)
    8000684a:	fffff097          	auipc	ra,0xfffff
    8000684e:	8fa080e7          	jalr	-1798(ra) # 80005144 <fileclose>
    return -1;
    80006852:	57fd                	li	a5,-1
    80006854:	a805                	j	80006884 <sys_pipe+0x102>
    if(fd0 >= 0)
    80006856:	fc442783          	lw	a5,-60(s0)
    8000685a:	0007c863          	bltz	a5,8000686a <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    8000685e:	078e                	slli	a5,a5,0x3
    80006860:	0d078793          	addi	a5,a5,208
    80006864:	97a6                	add	a5,a5,s1
    80006866:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000686a:	fd043503          	ld	a0,-48(s0)
    8000686e:	fffff097          	auipc	ra,0xfffff
    80006872:	8d6080e7          	jalr	-1834(ra) # 80005144 <fileclose>
    fileclose(wf);
    80006876:	fc843503          	ld	a0,-56(s0)
    8000687a:	fffff097          	auipc	ra,0xfffff
    8000687e:	8ca080e7          	jalr	-1846(ra) # 80005144 <fileclose>
    return -1;
    80006882:	57fd                	li	a5,-1
}
    80006884:	853e                	mv	a0,a5
    80006886:	70e2                	ld	ra,56(sp)
    80006888:	7442                	ld	s0,48(sp)
    8000688a:	74a2                	ld	s1,40(sp)
    8000688c:	6121                	addi	sp,sp,64
    8000688e:	8082                	ret

0000000080006890 <kernelvec>:
    80006890:	7111                	addi	sp,sp,-256
    80006892:	e006                	sd	ra,0(sp)
    80006894:	e40a                	sd	sp,8(sp)
    80006896:	e80e                	sd	gp,16(sp)
    80006898:	ec12                	sd	tp,24(sp)
    8000689a:	f016                	sd	t0,32(sp)
    8000689c:	f41a                	sd	t1,40(sp)
    8000689e:	f81e                	sd	t2,48(sp)
    800068a0:	fc22                	sd	s0,56(sp)
    800068a2:	e0a6                	sd	s1,64(sp)
    800068a4:	e4aa                	sd	a0,72(sp)
    800068a6:	e8ae                	sd	a1,80(sp)
    800068a8:	ecb2                	sd	a2,88(sp)
    800068aa:	f0b6                	sd	a3,96(sp)
    800068ac:	f4ba                	sd	a4,104(sp)
    800068ae:	f8be                	sd	a5,112(sp)
    800068b0:	fcc2                	sd	a6,120(sp)
    800068b2:	e146                	sd	a7,128(sp)
    800068b4:	e54a                	sd	s2,136(sp)
    800068b6:	e94e                	sd	s3,144(sp)
    800068b8:	ed52                	sd	s4,152(sp)
    800068ba:	f156                	sd	s5,160(sp)
    800068bc:	f55a                	sd	s6,168(sp)
    800068be:	f95e                	sd	s7,176(sp)
    800068c0:	fd62                	sd	s8,184(sp)
    800068c2:	e1e6                	sd	s9,192(sp)
    800068c4:	e5ea                	sd	s10,200(sp)
    800068c6:	e9ee                	sd	s11,208(sp)
    800068c8:	edf2                	sd	t3,216(sp)
    800068ca:	f1f6                	sd	t4,224(sp)
    800068cc:	f5fa                	sd	t5,232(sp)
    800068ce:	f9fe                	sd	t6,240(sp)
    800068d0:	a0bfc0ef          	jal	800032da <kerneltrap>
    800068d4:	6082                	ld	ra,0(sp)
    800068d6:	6122                	ld	sp,8(sp)
    800068d8:	61c2                	ld	gp,16(sp)
    800068da:	7282                	ld	t0,32(sp)
    800068dc:	7322                	ld	t1,40(sp)
    800068de:	73c2                	ld	t2,48(sp)
    800068e0:	7462                	ld	s0,56(sp)
    800068e2:	6486                	ld	s1,64(sp)
    800068e4:	6526                	ld	a0,72(sp)
    800068e6:	65c6                	ld	a1,80(sp)
    800068e8:	6666                	ld	a2,88(sp)
    800068ea:	7686                	ld	a3,96(sp)
    800068ec:	7726                	ld	a4,104(sp)
    800068ee:	77c6                	ld	a5,112(sp)
    800068f0:	7866                	ld	a6,120(sp)
    800068f2:	688a                	ld	a7,128(sp)
    800068f4:	692a                	ld	s2,136(sp)
    800068f6:	69ca                	ld	s3,144(sp)
    800068f8:	6a6a                	ld	s4,152(sp)
    800068fa:	7a8a                	ld	s5,160(sp)
    800068fc:	7b2a                	ld	s6,168(sp)
    800068fe:	7bca                	ld	s7,176(sp)
    80006900:	7c6a                	ld	s8,184(sp)
    80006902:	6c8e                	ld	s9,192(sp)
    80006904:	6d2e                	ld	s10,200(sp)
    80006906:	6dce                	ld	s11,208(sp)
    80006908:	6e6e                	ld	t3,216(sp)
    8000690a:	7e8e                	ld	t4,224(sp)
    8000690c:	7f2e                	ld	t5,232(sp)
    8000690e:	7fce                	ld	t6,240(sp)
    80006910:	6111                	addi	sp,sp,256
    80006912:	10200073          	sret
    80006916:	00000013          	nop
    8000691a:	00000013          	nop
    8000691e:	0001                	nop

0000000080006920 <timervec>:
    80006920:	34051573          	csrrw	a0,mscratch,a0
    80006924:	e10c                	sd	a1,0(a0)
    80006926:	e510                	sd	a2,8(a0)
    80006928:	e914                	sd	a3,16(a0)
    8000692a:	6d0c                	ld	a1,24(a0)
    8000692c:	7110                	ld	a2,32(a0)
    8000692e:	6194                	ld	a3,0(a1)
    80006930:	96b2                	add	a3,a3,a2
    80006932:	e194                	sd	a3,0(a1)
    80006934:	4589                	li	a1,2
    80006936:	14459073          	csrw	sip,a1
    8000693a:	6914                	ld	a3,16(a0)
    8000693c:	6510                	ld	a2,8(a0)
    8000693e:	610c                	ld	a1,0(a0)
    80006940:	34051573          	csrrw	a0,mscratch,a0
    80006944:	30200073          	mret
    80006948:	0001                	nop

000000008000694a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000694a:	1141                	addi	sp,sp,-16
    8000694c:	e406                	sd	ra,8(sp)
    8000694e:	e022                	sd	s0,0(sp)
    80006950:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006952:	0c000737          	lui	a4,0xc000
    80006956:	4785                	li	a5,1
    80006958:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000695a:	c35c                	sw	a5,4(a4)
  *(uint32*)(PLIC + VIRTIO1_IRQ*4) = 1;
    8000695c:	c71c                	sw	a5,8(a4)
}
    8000695e:	60a2                	ld	ra,8(sp)
    80006960:	6402                	ld	s0,0(sp)
    80006962:	0141                	addi	sp,sp,16
    80006964:	8082                	ret

0000000080006966 <plicinithart>:

void
plicinithart(void)
{
    80006966:	1141                	addi	sp,sp,-16
    80006968:	e406                	sd	ra,8(sp)
    8000696a:	e022                	sd	s0,0(sp)
    8000696c:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000696e:	ffffb097          	auipc	ra,0xffffb
    80006972:	4dc080e7          	jalr	1244(ra) # 80001e4a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ) | (1 << VIRTIO1_IRQ);
    80006976:	0085171b          	slliw	a4,a0,0x8
    8000697a:	0c0027b7          	lui	a5,0xc002
    8000697e:	97ba                	add	a5,a5,a4
    80006980:	40600713          	li	a4,1030
    80006984:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006988:	00d5151b          	slliw	a0,a0,0xd
    8000698c:	0c2017b7          	lui	a5,0xc201
    80006990:	97aa                	add	a5,a5,a0
    80006992:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006996:	60a2                	ld	ra,8(sp)
    80006998:	6402                	ld	s0,0(sp)
    8000699a:	0141                	addi	sp,sp,16
    8000699c:	8082                	ret

000000008000699e <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000699e:	1141                	addi	sp,sp,-16
    800069a0:	e406                	sd	ra,8(sp)
    800069a2:	e022                	sd	s0,0(sp)
    800069a4:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800069a6:	ffffb097          	auipc	ra,0xffffb
    800069aa:	4a4080e7          	jalr	1188(ra) # 80001e4a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800069ae:	00d5151b          	slliw	a0,a0,0xd
    800069b2:	0c2017b7          	lui	a5,0xc201
    800069b6:	97aa                	add	a5,a5,a0
  return irq;
}
    800069b8:	43c8                	lw	a0,4(a5)
    800069ba:	60a2                	ld	ra,8(sp)
    800069bc:	6402                	ld	s0,0(sp)
    800069be:	0141                	addi	sp,sp,16
    800069c0:	8082                	ret

00000000800069c2 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800069c2:	1101                	addi	sp,sp,-32
    800069c4:	ec06                	sd	ra,24(sp)
    800069c6:	e822                	sd	s0,16(sp)
    800069c8:	e426                	sd	s1,8(sp)
    800069ca:	1000                	addi	s0,sp,32
    800069cc:	84aa                	mv	s1,a0
  int hart = cpuid();
    800069ce:	ffffb097          	auipc	ra,0xffffb
    800069d2:	47c080e7          	jalr	1148(ra) # 80001e4a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800069d6:	00d5179b          	slliw	a5,a0,0xd
    800069da:	0c201737          	lui	a4,0xc201
    800069de:	97ba                	add	a5,a5,a4
    800069e0:	c3c4                	sw	s1,4(a5)
}
    800069e2:	60e2                	ld	ra,24(sp)
    800069e4:	6442                	ld	s0,16(sp)
    800069e6:	64a2                	ld	s1,8(sp)
    800069e8:	6105                	addi	sp,sp,32
    800069ea:	8082                	ret

00000000800069ec <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800069ec:	1141                	addi	sp,sp,-16
    800069ee:	e406                	sd	ra,8(sp)
    800069f0:	e022                	sd	s0,0(sp)
    800069f2:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800069f4:	479d                	li	a5,7
    800069f6:	04a7cc63          	blt	a5,a0,80006a4e <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800069fa:	00069797          	auipc	a5,0x69
    800069fe:	de678793          	addi	a5,a5,-538 # 8006f7e0 <disk>
    80006a02:	97aa                	add	a5,a5,a0
    80006a04:	0187c783          	lbu	a5,24(a5)
    80006a08:	ebb9                	bnez	a5,80006a5e <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006a0a:	00451693          	slli	a3,a0,0x4
    80006a0e:	00069797          	auipc	a5,0x69
    80006a12:	dd278793          	addi	a5,a5,-558 # 8006f7e0 <disk>
    80006a16:	6398                	ld	a4,0(a5)
    80006a18:	9736                	add	a4,a4,a3
    80006a1a:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80006a1e:	6398                	ld	a4,0(a5)
    80006a20:	9736                	add	a4,a4,a3
    80006a22:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006a26:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006a2a:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006a2e:	97aa                	add	a5,a5,a0
    80006a30:	4705                	li	a4,1
    80006a32:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006a36:	00069517          	auipc	a0,0x69
    80006a3a:	dc250513          	addi	a0,a0,-574 # 8006f7f8 <disk+0x18>
    80006a3e:	ffffc097          	auipc	ra,0xffffc
    80006a42:	d5a080e7          	jalr	-678(ra) # 80002798 <wakeup>
}
    80006a46:	60a2                	ld	ra,8(sp)
    80006a48:	6402                	ld	s0,0(sp)
    80006a4a:	0141                	addi	sp,sp,16
    80006a4c:	8082                	ret
    panic("free_desc 1");
    80006a4e:	00004517          	auipc	a0,0x4
    80006a52:	c6a50513          	addi	a0,a0,-918 # 8000a6b8 <etext+0x6b8>
    80006a56:	ffffa097          	auipc	ra,0xffffa
    80006a5a:	b08080e7          	jalr	-1272(ra) # 8000055e <panic>
    panic("free_desc 2");
    80006a5e:	00004517          	auipc	a0,0x4
    80006a62:	c6a50513          	addi	a0,a0,-918 # 8000a6c8 <etext+0x6c8>
    80006a66:	ffffa097          	auipc	ra,0xffffa
    80006a6a:	af8080e7          	jalr	-1288(ra) # 8000055e <panic>

0000000080006a6e <virtio_disk_init>:
{
    80006a6e:	1101                	addi	sp,sp,-32
    80006a70:	ec06                	sd	ra,24(sp)
    80006a72:	e822                	sd	s0,16(sp)
    80006a74:	e426                	sd	s1,8(sp)
    80006a76:	e04a                	sd	s2,0(sp)
    80006a78:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006a7a:	00004597          	auipc	a1,0x4
    80006a7e:	c5e58593          	addi	a1,a1,-930 # 8000a6d8 <etext+0x6d8>
    80006a82:	00069517          	auipc	a0,0x69
    80006a86:	e8650513          	addi	a0,a0,-378 # 8006f908 <disk+0x128>
    80006a8a:	ffffa097          	auipc	ra,0xffffa
    80006a8e:	210080e7          	jalr	528(ra) # 80000c9a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006a92:	100017b7          	lui	a5,0x10001
    80006a96:	4398                	lw	a4,0(a5)
    80006a98:	2701                	sext.w	a4,a4
    80006a9a:	747277b7          	lui	a5,0x74727
    80006a9e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006aa2:	16f71463          	bne	a4,a5,80006c0a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006aa6:	100017b7          	lui	a5,0x10001
    80006aaa:	43dc                	lw	a5,4(a5)
    80006aac:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006aae:	4709                	li	a4,2
    80006ab0:	14e79d63          	bne	a5,a4,80006c0a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006ab4:	100017b7          	lui	a5,0x10001
    80006ab8:	479c                	lw	a5,8(a5)
    80006aba:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006abc:	14e79763          	bne	a5,a4,80006c0a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006ac0:	100017b7          	lui	a5,0x10001
    80006ac4:	47d8                	lw	a4,12(a5)
    80006ac6:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006ac8:	554d47b7          	lui	a5,0x554d4
    80006acc:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006ad0:	12f71d63          	bne	a4,a5,80006c0a <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006ad4:	100017b7          	lui	a5,0x10001
    80006ad8:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006adc:	4705                	li	a4,1
    80006ade:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006ae0:	470d                	li	a4,3
    80006ae2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006ae4:	10001737          	lui	a4,0x10001
    80006ae8:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006aea:	c7ffe6b7          	lui	a3,0xc7ffe
    80006aee:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f8ddb3>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006af2:	8f75                	and	a4,a4,a3
    80006af4:	100016b7          	lui	a3,0x10001
    80006af8:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006afa:	472d                	li	a4,11
    80006afc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006afe:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006b02:	439c                	lw	a5,0(a5)
    80006b04:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006b08:	8ba1                	andi	a5,a5,8
    80006b0a:	10078863          	beqz	a5,80006c1a <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006b0e:	100017b7          	lui	a5,0x10001
    80006b12:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006b16:	43fc                	lw	a5,68(a5)
    80006b18:	2781                	sext.w	a5,a5
    80006b1a:	10079863          	bnez	a5,80006c2a <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006b1e:	100017b7          	lui	a5,0x10001
    80006b22:	5bdc                	lw	a5,52(a5)
    80006b24:	2781                	sext.w	a5,a5
  if(max == 0)
    80006b26:	10078a63          	beqz	a5,80006c3a <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006b2a:	471d                	li	a4,7
    80006b2c:	10f77f63          	bgeu	a4,a5,80006c4a <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    80006b30:	ffffa097          	auipc	ra,0xffffa
    80006b34:	0e2080e7          	jalr	226(ra) # 80000c12 <kalloc>
    80006b38:	00069497          	auipc	s1,0x69
    80006b3c:	ca848493          	addi	s1,s1,-856 # 8006f7e0 <disk>
    80006b40:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006b42:	ffffa097          	auipc	ra,0xffffa
    80006b46:	0d0080e7          	jalr	208(ra) # 80000c12 <kalloc>
    80006b4a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006b4c:	ffffa097          	auipc	ra,0xffffa
    80006b50:	0c6080e7          	jalr	198(ra) # 80000c12 <kalloc>
    80006b54:	87aa                	mv	a5,a0
    80006b56:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006b58:	6088                	ld	a0,0(s1)
    80006b5a:	10050063          	beqz	a0,80006c5a <virtio_disk_init+0x1ec>
    80006b5e:	00069717          	auipc	a4,0x69
    80006b62:	c8a73703          	ld	a4,-886(a4) # 8006f7e8 <disk+0x8>
    80006b66:	cb75                	beqz	a4,80006c5a <virtio_disk_init+0x1ec>
    80006b68:	cbed                	beqz	a5,80006c5a <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006b6a:	6605                	lui	a2,0x1
    80006b6c:	4581                	li	a1,0
    80006b6e:	ffffa097          	auipc	ra,0xffffa
    80006b72:	2be080e7          	jalr	702(ra) # 80000e2c <memset>
  memset(disk.avail, 0, PGSIZE);
    80006b76:	00069497          	auipc	s1,0x69
    80006b7a:	c6a48493          	addi	s1,s1,-918 # 8006f7e0 <disk>
    80006b7e:	6605                	lui	a2,0x1
    80006b80:	4581                	li	a1,0
    80006b82:	6488                	ld	a0,8(s1)
    80006b84:	ffffa097          	auipc	ra,0xffffa
    80006b88:	2a8080e7          	jalr	680(ra) # 80000e2c <memset>
  memset(disk.used, 0, PGSIZE);
    80006b8c:	6605                	lui	a2,0x1
    80006b8e:	4581                	li	a1,0
    80006b90:	6888                	ld	a0,16(s1)
    80006b92:	ffffa097          	auipc	ra,0xffffa
    80006b96:	29a080e7          	jalr	666(ra) # 80000e2c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006b9a:	100017b7          	lui	a5,0x10001
    80006b9e:	4721                	li	a4,8
    80006ba0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006ba2:	4098                	lw	a4,0(s1)
    80006ba4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006ba8:	40d8                	lw	a4,4(s1)
    80006baa:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006bae:	649c                	ld	a5,8(s1)
    80006bb0:	0007869b          	sext.w	a3,a5
    80006bb4:	10001737          	lui	a4,0x10001
    80006bb8:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006bbc:	9781                	srai	a5,a5,0x20
    80006bbe:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006bc2:	689c                	ld	a5,16(s1)
    80006bc4:	0007869b          	sext.w	a3,a5
    80006bc8:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006bcc:	9781                	srai	a5,a5,0x20
    80006bce:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006bd2:	4785                	li	a5,1
    80006bd4:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006bd6:	00f48c23          	sb	a5,24(s1)
    80006bda:	00f48ca3          	sb	a5,25(s1)
    80006bde:	00f48d23          	sb	a5,26(s1)
    80006be2:	00f48da3          	sb	a5,27(s1)
    80006be6:	00f48e23          	sb	a5,28(s1)
    80006bea:	00f48ea3          	sb	a5,29(s1)
    80006bee:	00f48f23          	sb	a5,30(s1)
    80006bf2:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006bf6:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006bfa:	07272823          	sw	s2,112(a4)
}
    80006bfe:	60e2                	ld	ra,24(sp)
    80006c00:	6442                	ld	s0,16(sp)
    80006c02:	64a2                	ld	s1,8(sp)
    80006c04:	6902                	ld	s2,0(sp)
    80006c06:	6105                	addi	sp,sp,32
    80006c08:	8082                	ret
    panic("could not find virtio disk");
    80006c0a:	00004517          	auipc	a0,0x4
    80006c0e:	ade50513          	addi	a0,a0,-1314 # 8000a6e8 <etext+0x6e8>
    80006c12:	ffffa097          	auipc	ra,0xffffa
    80006c16:	94c080e7          	jalr	-1716(ra) # 8000055e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006c1a:	00004517          	auipc	a0,0x4
    80006c1e:	aee50513          	addi	a0,a0,-1298 # 8000a708 <etext+0x708>
    80006c22:	ffffa097          	auipc	ra,0xffffa
    80006c26:	93c080e7          	jalr	-1732(ra) # 8000055e <panic>
    panic("virtio disk should not be ready");
    80006c2a:	00004517          	auipc	a0,0x4
    80006c2e:	afe50513          	addi	a0,a0,-1282 # 8000a728 <etext+0x728>
    80006c32:	ffffa097          	auipc	ra,0xffffa
    80006c36:	92c080e7          	jalr	-1748(ra) # 8000055e <panic>
    panic("virtio disk has no queue 0");
    80006c3a:	00004517          	auipc	a0,0x4
    80006c3e:	b0e50513          	addi	a0,a0,-1266 # 8000a748 <etext+0x748>
    80006c42:	ffffa097          	auipc	ra,0xffffa
    80006c46:	91c080e7          	jalr	-1764(ra) # 8000055e <panic>
    panic("virtio disk max queue too short");
    80006c4a:	00004517          	auipc	a0,0x4
    80006c4e:	b1e50513          	addi	a0,a0,-1250 # 8000a768 <etext+0x768>
    80006c52:	ffffa097          	auipc	ra,0xffffa
    80006c56:	90c080e7          	jalr	-1780(ra) # 8000055e <panic>
    panic("virtio disk kalloc");
    80006c5a:	00004517          	auipc	a0,0x4
    80006c5e:	b2e50513          	addi	a0,a0,-1234 # 8000a788 <etext+0x788>
    80006c62:	ffffa097          	auipc	ra,0xffffa
    80006c66:	8fc080e7          	jalr	-1796(ra) # 8000055e <panic>

0000000080006c6a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006c6a:	711d                	addi	sp,sp,-96
    80006c6c:	ec86                	sd	ra,88(sp)
    80006c6e:	e8a2                	sd	s0,80(sp)
    80006c70:	e4a6                	sd	s1,72(sp)
    80006c72:	e0ca                	sd	s2,64(sp)
    80006c74:	fc4e                	sd	s3,56(sp)
    80006c76:	f852                	sd	s4,48(sp)
    80006c78:	f456                	sd	s5,40(sp)
    80006c7a:	f05a                	sd	s6,32(sp)
    80006c7c:	ec5e                	sd	s7,24(sp)
    80006c7e:	e862                	sd	s8,16(sp)
    80006c80:	1080                	addi	s0,sp,96
    80006c82:	89aa                	mv	s3,a0
    80006c84:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006c86:	00c52b83          	lw	s7,12(a0)
    80006c8a:	001b9b9b          	slliw	s7,s7,0x1
    80006c8e:	1b82                	slli	s7,s7,0x20
    80006c90:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006c94:	00069517          	auipc	a0,0x69
    80006c98:	c7450513          	addi	a0,a0,-908 # 8006f908 <disk+0x128>
    80006c9c:	ffffa097          	auipc	ra,0xffffa
    80006ca0:	098080e7          	jalr	152(ra) # 80000d34 <acquire>
  for(int i = 0; i < NUM; i++){
    80006ca4:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006ca6:	00069a97          	auipc	s5,0x69
    80006caa:	b3aa8a93          	addi	s5,s5,-1222 # 8006f7e0 <disk>
  for(int i = 0; i < 3; i++){
    80006cae:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006cb0:	5c7d                	li	s8,-1
    80006cb2:	a885                	j	80006d22 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006cb4:	00fa8733          	add	a4,s5,a5
    80006cb8:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006cbc:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006cbe:	0207c563          	bltz	a5,80006ce8 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006cc2:	2905                	addiw	s2,s2,1
    80006cc4:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006cc6:	07490263          	beq	s2,s4,80006d2a <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006cca:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006ccc:	00069717          	auipc	a4,0x69
    80006cd0:	b1470713          	addi	a4,a4,-1260 # 8006f7e0 <disk>
    80006cd4:	4781                	li	a5,0
    if(disk.free[i]){
    80006cd6:	01874683          	lbu	a3,24(a4)
    80006cda:	fee9                	bnez	a3,80006cb4 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80006cdc:	2785                	addiw	a5,a5,1
    80006cde:	0705                	addi	a4,a4,1
    80006ce0:	fe979be3          	bne	a5,s1,80006cd6 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006ce4:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006ce8:	03205163          	blez	s2,80006d0a <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006cec:	fa042503          	lw	a0,-96(s0)
    80006cf0:	00000097          	auipc	ra,0x0
    80006cf4:	cfc080e7          	jalr	-772(ra) # 800069ec <free_desc>
      for(int j = 0; j < i; j++)
    80006cf8:	4785                	li	a5,1
    80006cfa:	0127d863          	bge	a5,s2,80006d0a <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006cfe:	fa442503          	lw	a0,-92(s0)
    80006d02:	00000097          	auipc	ra,0x0
    80006d06:	cea080e7          	jalr	-790(ra) # 800069ec <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006d0a:	00069597          	auipc	a1,0x69
    80006d0e:	bfe58593          	addi	a1,a1,-1026 # 8006f908 <disk+0x128>
    80006d12:	00069517          	auipc	a0,0x69
    80006d16:	ae650513          	addi	a0,a0,-1306 # 8006f7f8 <disk+0x18>
    80006d1a:	ffffc097          	auipc	ra,0xffffc
    80006d1e:	a1a080e7          	jalr	-1510(ra) # 80002734 <sleep>
  for(int i = 0; i < 3; i++){
    80006d22:	fa040613          	addi	a2,s0,-96
    80006d26:	4901                	li	s2,0
    80006d28:	b74d                	j	80006cca <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006d2a:	fa042503          	lw	a0,-96(s0)
    80006d2e:	00451693          	slli	a3,a0,0x4

  if(write)
    80006d32:	00069797          	auipc	a5,0x69
    80006d36:	aae78793          	addi	a5,a5,-1362 # 8006f7e0 <disk>
    80006d3a:	00451713          	slli	a4,a0,0x4
    80006d3e:	0a070713          	addi	a4,a4,160
    80006d42:	973e                	add	a4,a4,a5
    80006d44:	01603633          	snez	a2,s6
    80006d48:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006d4a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006d4e:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006d52:	6398                	ld	a4,0(a5)
    80006d54:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006d56:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006d5a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006d5c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006d5e:	6390                	ld	a2,0(a5)
    80006d60:	00d60833          	add	a6,a2,a3
    80006d64:	4741                	li	a4,16
    80006d66:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006d6a:	4585                	li	a1,1
    80006d6c:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80006d70:	fa442703          	lw	a4,-92(s0)
    80006d74:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006d78:	0712                	slli	a4,a4,0x4
    80006d7a:	963a                	add	a2,a2,a4
    80006d7c:	05898813          	addi	a6,s3,88
    80006d80:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006d84:	0007b883          	ld	a7,0(a5)
    80006d88:	9746                	add	a4,a4,a7
    80006d8a:	40000613          	li	a2,1024
    80006d8e:	c710                	sw	a2,8(a4)
  if(write)
    80006d90:	001b3613          	seqz	a2,s6
    80006d94:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006d98:	8e4d                	or	a2,a2,a1
    80006d9a:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006d9e:	fa842603          	lw	a2,-88(s0)
    80006da2:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006da6:	00451813          	slli	a6,a0,0x4
    80006daa:	02080813          	addi	a6,a6,32
    80006dae:	983e                	add	a6,a6,a5
    80006db0:	577d                	li	a4,-1
    80006db2:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006db6:	0612                	slli	a2,a2,0x4
    80006db8:	98b2                	add	a7,a7,a2
    80006dba:	03068713          	addi	a4,a3,48
    80006dbe:	973e                	add	a4,a4,a5
    80006dc0:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006dc4:	6398                	ld	a4,0(a5)
    80006dc6:	9732                	add	a4,a4,a2
    80006dc8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006dca:	4689                	li	a3,2
    80006dcc:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006dd0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006dd4:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80006dd8:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006ddc:	6794                	ld	a3,8(a5)
    80006dde:	0026d703          	lhu	a4,2(a3)
    80006de2:	8b1d                	andi	a4,a4,7
    80006de4:	0706                	slli	a4,a4,0x1
    80006de6:	96ba                	add	a3,a3,a4
    80006de8:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006dec:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006df0:	6798                	ld	a4,8(a5)
    80006df2:	00275783          	lhu	a5,2(a4)
    80006df6:	2785                	addiw	a5,a5,1
    80006df8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006dfc:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006e00:	100017b7          	lui	a5,0x10001
    80006e04:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006e08:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006e0c:	00069917          	auipc	s2,0x69
    80006e10:	afc90913          	addi	s2,s2,-1284 # 8006f908 <disk+0x128>
  while(b->disk == 1) {
    80006e14:	84ae                	mv	s1,a1
    80006e16:	00b79c63          	bne	a5,a1,80006e2e <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006e1a:	85ca                	mv	a1,s2
    80006e1c:	854e                	mv	a0,s3
    80006e1e:	ffffc097          	auipc	ra,0xffffc
    80006e22:	916080e7          	jalr	-1770(ra) # 80002734 <sleep>
  while(b->disk == 1) {
    80006e26:	0049a783          	lw	a5,4(s3)
    80006e2a:	fe9788e3          	beq	a5,s1,80006e1a <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006e2e:	fa042903          	lw	s2,-96(s0)
    80006e32:	00491713          	slli	a4,s2,0x4
    80006e36:	02070713          	addi	a4,a4,32
    80006e3a:	00069797          	auipc	a5,0x69
    80006e3e:	9a678793          	addi	a5,a5,-1626 # 8006f7e0 <disk>
    80006e42:	97ba                	add	a5,a5,a4
    80006e44:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006e48:	00069997          	auipc	s3,0x69
    80006e4c:	99898993          	addi	s3,s3,-1640 # 8006f7e0 <disk>
    80006e50:	00491713          	slli	a4,s2,0x4
    80006e54:	0009b783          	ld	a5,0(s3)
    80006e58:	97ba                	add	a5,a5,a4
    80006e5a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006e5e:	854a                	mv	a0,s2
    80006e60:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006e64:	00000097          	auipc	ra,0x0
    80006e68:	b88080e7          	jalr	-1144(ra) # 800069ec <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006e6c:	8885                	andi	s1,s1,1
    80006e6e:	f0ed                	bnez	s1,80006e50 <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006e70:	00069517          	auipc	a0,0x69
    80006e74:	a9850513          	addi	a0,a0,-1384 # 8006f908 <disk+0x128>
    80006e78:	ffffa097          	auipc	ra,0xffffa
    80006e7c:	f6c080e7          	jalr	-148(ra) # 80000de4 <release>
}
    80006e80:	60e6                	ld	ra,88(sp)
    80006e82:	6446                	ld	s0,80(sp)
    80006e84:	64a6                	ld	s1,72(sp)
    80006e86:	6906                	ld	s2,64(sp)
    80006e88:	79e2                	ld	s3,56(sp)
    80006e8a:	7a42                	ld	s4,48(sp)
    80006e8c:	7aa2                	ld	s5,40(sp)
    80006e8e:	7b02                	ld	s6,32(sp)
    80006e90:	6be2                	ld	s7,24(sp)
    80006e92:	6c42                	ld	s8,16(sp)
    80006e94:	6125                	addi	sp,sp,96
    80006e96:	8082                	ret

0000000080006e98 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006e98:	1101                	addi	sp,sp,-32
    80006e9a:	ec06                	sd	ra,24(sp)
    80006e9c:	e822                	sd	s0,16(sp)
    80006e9e:	e426                	sd	s1,8(sp)
    80006ea0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006ea2:	00069497          	auipc	s1,0x69
    80006ea6:	93e48493          	addi	s1,s1,-1730 # 8006f7e0 <disk>
    80006eaa:	00069517          	auipc	a0,0x69
    80006eae:	a5e50513          	addi	a0,a0,-1442 # 8006f908 <disk+0x128>
    80006eb2:	ffffa097          	auipc	ra,0xffffa
    80006eb6:	e82080e7          	jalr	-382(ra) # 80000d34 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006eba:	100017b7          	lui	a5,0x10001
    80006ebe:	53bc                	lw	a5,96(a5)
    80006ec0:	8b8d                	andi	a5,a5,3
    80006ec2:	10001737          	lui	a4,0x10001
    80006ec6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006ec8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006ecc:	689c                	ld	a5,16(s1)
    80006ece:	0204d703          	lhu	a4,32(s1)
    80006ed2:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006ed6:	04f70a63          	beq	a4,a5,80006f2a <virtio_disk_intr+0x92>
    __sync_synchronize();
    80006eda:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006ede:	6898                	ld	a4,16(s1)
    80006ee0:	0204d783          	lhu	a5,32(s1)
    80006ee4:	8b9d                	andi	a5,a5,7
    80006ee6:	078e                	slli	a5,a5,0x3
    80006ee8:	97ba                	add	a5,a5,a4
    80006eea:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006eec:	00479713          	slli	a4,a5,0x4
    80006ef0:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80006ef4:	9726                	add	a4,a4,s1
    80006ef6:	01074703          	lbu	a4,16(a4)
    80006efa:	e729                	bnez	a4,80006f44 <virtio_disk_intr+0xac>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006efc:	0792                	slli	a5,a5,0x4
    80006efe:	02078793          	addi	a5,a5,32
    80006f02:	97a6                	add	a5,a5,s1
    80006f04:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006f06:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006f0a:	ffffc097          	auipc	ra,0xffffc
    80006f0e:	88e080e7          	jalr	-1906(ra) # 80002798 <wakeup>

    disk.used_idx += 1;
    80006f12:	0204d783          	lhu	a5,32(s1)
    80006f16:	2785                	addiw	a5,a5,1
    80006f18:	17c2                	slli	a5,a5,0x30
    80006f1a:	93c1                	srli	a5,a5,0x30
    80006f1c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006f20:	6898                	ld	a4,16(s1)
    80006f22:	00275703          	lhu	a4,2(a4)
    80006f26:	faf71ae3          	bne	a4,a5,80006eda <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006f2a:	00069517          	auipc	a0,0x69
    80006f2e:	9de50513          	addi	a0,a0,-1570 # 8006f908 <disk+0x128>
    80006f32:	ffffa097          	auipc	ra,0xffffa
    80006f36:	eb2080e7          	jalr	-334(ra) # 80000de4 <release>
}
    80006f3a:	60e2                	ld	ra,24(sp)
    80006f3c:	6442                	ld	s0,16(sp)
    80006f3e:	64a2                	ld	s1,8(sp)
    80006f40:	6105                	addi	sp,sp,32
    80006f42:	8082                	ret
      panic("virtio_disk_intr status");
    80006f44:	00004517          	auipc	a0,0x4
    80006f48:	85c50513          	addi	a0,a0,-1956 # 8000a7a0 <etext+0x7a0>
    80006f4c:	ffff9097          	auipc	ra,0xffff9
    80006f50:	612080e7          	jalr	1554(ra) # 8000055e <panic>

0000000080006f54 <alloc_desc>:
 *
 * Output: returns the index of the descriptor on success
 *         returns -1 if there are no free descriptors
 *
 */
int alloc_desc(struct virtq *q) {
    80006f54:	1141                	addi	sp,sp,-16
    80006f56:	e406                	sd	ra,8(sp)
    80006f58:	e022                	sd	s0,0(sp)
    80006f5a:	0800                	addi	s0,sp,16
    80006f5c:	862a                	mv	a2,a0
  for (int i = 0; i < NUM; i++) {
    80006f5e:	01c50793          	addi	a5,a0,28
    80006f62:	4501                	li	a0,0
    80006f64:	46a1                	li	a3,8
    if (q->free[i]) {
    80006f66:	0007c703          	lbu	a4,0(a5)
    80006f6a:	eb11                	bnez	a4,80006f7e <alloc_desc+0x2a>
  for (int i = 0; i < NUM; i++) {
    80006f6c:	2505                	addiw	a0,a0,1
    80006f6e:	0785                	addi	a5,a5,1
    80006f70:	fed51be3          	bne	a0,a3,80006f66 <alloc_desc+0x12>
      q->free[i] = 0;
      return i;
    }
  }
  return -1;
    80006f74:	557d                	li	a0,-1
}
    80006f76:	60a2                	ld	ra,8(sp)
    80006f78:	6402                	ld	s0,0(sp)
    80006f7a:	0141                	addi	sp,sp,16
    80006f7c:	8082                	ret
      q->free[i] = 0;
    80006f7e:	962a                	add	a2,a2,a0
    80006f80:	00060e23          	sb	zero,28(a2)
      return i;
    80006f84:	bfcd                	j	80006f76 <alloc_desc+0x22>

0000000080006f86 <free_desc>:
 * allocated. int i: the index at which a descriptor has been allocated in q
 *
 * Output: None
 *
 */
void free_desc(struct virtq *q, int i) {
    80006f86:	1141                	addi	sp,sp,-16
    80006f88:	e406                	sd	ra,8(sp)
    80006f8a:	e022                	sd	s0,0(sp)
    80006f8c:	0800                	addi	s0,sp,16
  if (i >= NUM)
    80006f8e:	479d                	li	a5,7
    80006f90:	02b7cd63          	blt	a5,a1,80006fca <free_desc+0x44>
    panic("free_desc 1");
  if (q->free[i])
    80006f94:	00b507b3          	add	a5,a0,a1
    80006f98:	01c7c783          	lbu	a5,28(a5)
    80006f9c:	ef9d                	bnez	a5,80006fda <free_desc+0x54>
    panic("free_desc 2");

  q->desc->addr = 0;
    80006f9e:	611c                	ld	a5,0(a0)
    80006fa0:	0007b023          	sd	zero,0(a5)
  q->desc->len = 0;
    80006fa4:	611c                	ld	a5,0(a0)
    80006fa6:	0007a423          	sw	zero,8(a5)
  q->desc->flags = 0;
    80006faa:	611c                	ld	a5,0(a0)
    80006fac:	00079623          	sh	zero,12(a5)
  q->desc->next = 0;
    80006fb0:	611c                	ld	a5,0(a0)
    80006fb2:	00079723          	sh	zero,14(a5)
  wakeup(&q->free[i]);
    80006fb6:	05f1                	addi	a1,a1,28
    80006fb8:	952e                	add	a0,a0,a1
    80006fba:	ffffb097          	auipc	ra,0xffffb
    80006fbe:	7de080e7          	jalr	2014(ra) # 80002798 <wakeup>
}
    80006fc2:	60a2                	ld	ra,8(sp)
    80006fc4:	6402                	ld	s0,0(sp)
    80006fc6:	0141                	addi	sp,sp,16
    80006fc8:	8082                	ret
    panic("free_desc 1");
    80006fca:	00003517          	auipc	a0,0x3
    80006fce:	6ee50513          	addi	a0,a0,1774 # 8000a6b8 <etext+0x6b8>
    80006fd2:	ffff9097          	auipc	ra,0xffff9
    80006fd6:	58c080e7          	jalr	1420(ra) # 8000055e <panic>
    panic("free_desc 2");
    80006fda:	00003517          	auipc	a0,0x3
    80006fde:	6ee50513          	addi	a0,a0,1774 # 8000a6c8 <etext+0x6c8>
    80006fe2:	ffff9097          	auipc	ra,0xffff9
    80006fe6:	57c080e7          	jalr	1404(ra) # 8000055e <panic>

0000000080006fea <virtio_net_init>:
 * VirtualIO (VIRTIO) device. The process of this function is defined in
 * section 5.1.5 of the VIRTIO Device specification. Since I'm creating
 * a minimal netowrk driver, I only negotiate VIRTIO_NET_F_MAC
 *
 */
void virtio_net_init(void) {
    80006fea:	7159                	addi	sp,sp,-112
    80006fec:	f486                	sd	ra,104(sp)
    80006fee:	f0a2                	sd	s0,96(sp)
    80006ff0:	eca6                	sd	s1,88(sp)
    80006ff2:	e8ca                	sd	s2,80(sp)
    80006ff4:	e4ce                	sd	s3,72(sp)
    80006ff6:	e0d2                	sd	s4,64(sp)
    80006ff8:	fc56                	sd	s5,56(sp)
    80006ffa:	f85a                	sd	s6,48(sp)
    80006ffc:	f45e                	sd	s7,40(sp)
    80006ffe:	f062                	sd	s8,32(sp)
    80007000:	ec66                	sd	s9,24(sp)
    80007002:	e86a                	sd	s10,16(sp)
    80007004:	e46e                	sd	s11,8(sp)
    80007006:	1880                	addi	s0,sp,112
  uint32 status = 0;
  initlock(&net.vnet_lock, "virtio_net");
    80007008:	00003597          	auipc	a1,0x3
    8000700c:	7b058593          	addi	a1,a1,1968 # 8000a7b8 <etext+0x7b8>
    80007010:	00069517          	auipc	a0,0x69
    80007014:	92050513          	addi	a0,a0,-1760 # 8006f930 <net+0x10>
    80007018:	ffffa097          	auipc	ra,0xffffa
    8000701c:	c82080e7          	jalr	-894(ra) # 80000c9a <initlock>

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80007020:	100027b7          	lui	a5,0x10002
    80007024:	4398                	lw	a4,0(a5)
    80007026:	2701                	sext.w	a4,a4
    80007028:	747277b7          	lui	a5,0x74727
    8000702c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80007030:	32f71a63          	bne	a4,a5,80007364 <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80007034:	100027b7          	lui	a5,0x10002
    80007038:	43dc                	lw	a5,4(a5)
    8000703a:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000703c:	4709                	li	a4,2
    8000703e:	32e79363          	bne	a5,a4,80007364 <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80007042:	100027b7          	lui	a5,0x10002
    80007046:	479c                	lw	a5,8(a5)
    80007048:	2781                	sext.w	a5,a5
    8000704a:	4705                	li	a4,1
    8000704c:	30e79c63          	bne	a5,a4,80007364 <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80007050:	100027b7          	lui	a5,0x10002
    80007054:	47d8                	lw	a4,12(a5)
    80007056:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80007058:	554d47b7          	lui	a5,0x554d4
    8000705c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80007060:	30f71263          	bne	a4,a5,80007364 <virtio_net_init+0x37a>
    panic("could not find virtio net");
  }

  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    80007064:	100024b7          	lui	s1,0x10002
    80007068:	07048493          	addi	s1,s1,112 # 10002070 <_entry-0x6fffdf90>
    8000706c:	0004a023          	sw	zero,0(s1)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007070:	4785                	li	a5,1
    80007072:	c09c                	sw	a5,0(s1)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007074:	478d                	li	a5,3
    80007076:	c09c                	sw	a5,0(s1)

  // This copies the memory from the config into my driver state struct
  memmove((void *)&net.cfg, (void *)VIRTIO_NET_CONFIG,
    80007078:	4631                	li	a2,12
    8000707a:	100025b7          	lui	a1,0x10002
    8000707e:	10058593          	addi	a1,a1,256 # 10002100 <_entry-0x6fffdf00>
    80007082:	00069517          	auipc	a0,0x69
    80007086:	89e50513          	addi	a0,a0,-1890 # 8006f920 <net>
    8000708a:	ffffa097          	auipc	ra,0xffffa
    8000708e:	e02080e7          	jalr	-510(ra) # 80000e8c <memmove>
          sizeof(struct virtio_net_config));

  // Negotiate the feature bits
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80007092:	100027b7          	lui	a5,0x10002
    80007096:	4b9c                	lw	a5,16(a5)
  features &= VIRTIO_NET_F_MAC;
    80007098:	0207f793          	andi	a5,a5,32
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000709c:	10002737          	lui	a4,0x10002
    800070a0:	d31c                	sw	a5,32(a4)

  // Tell device that feature negotiation is complete
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;
    800070a2:	47ad                	li	a5,11
    800070a4:	c09c                	sw	a5,0(s1)

  // Make sure that FEATURES_OK is set
  status = *R(VIRTIO_MMIO_STATUS);
    800070a6:	409c                	lw	a5,0(s1)
    800070a8:	00078d1b          	sext.w	s10,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800070ac:	8ba1                	andi	a5,a5,8
    800070ae:	2c078363          	beqz	a5,80007374 <virtio_net_init+0x38a>
    panic("virtio net FEATURES_OK unset");

  // Check max queue size
  uint32 max_queue_size = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800070b2:	100027b7          	lui	a5,0x10002
    800070b6:	5bdc                	lw	a5,52(a5)
    800070b8:	2781                	sext.w	a5,a5
  if (max_queue_size == 0)
    800070ba:	2c078563          	beqz	a5,80007384 <virtio_net_init+0x39a>
    panic("virtio net has no queue 1 (QUEUE_TX)");
  if (max_queue_size < NUM)
    800070be:	471d                	li	a4,7
    800070c0:	2cf77a63          	bgeu	a4,a5,80007394 <virtio_net_init+0x3aa>
    panic("virtio net max queue too short");

  /* Initialize QUEUE_TX */
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    800070c4:	10002737          	lui	a4,0x10002
    800070c8:	4785                	li	a5,1
    800070ca:	db1c                	sw	a5,48(a4)
  net.txq.num = QUEUE_TX;
    800070cc:	00069717          	auipc	a4,0x69
    800070d0:	88f72a23          	sw	a5,-1900(a4) # 8006f960 <net+0x40>

  // ensure QUEUE_TX is not in use.
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    800070d4:	100027b7          	lui	a5,0x10002
    800070d8:	43fc                	lw	a5,68(a5)
    800070da:	2781                	sext.w	a5,a5
    800070dc:	2c079463          	bnez	a5,800073a4 <virtio_net_init+0x3ba>
    panic("QUEUE_TX should not be ready\n");

  net.txq.desc = kalloc();
    800070e0:	ffffa097          	auipc	ra,0xffffa
    800070e4:	b32080e7          	jalr	-1230(ra) # 80000c12 <kalloc>
    800070e8:	00069497          	auipc	s1,0x69
    800070ec:	83848493          	addi	s1,s1,-1992 # 8006f920 <net>
    800070f0:	f488                	sd	a0,40(s1)
  net.txq.driver_area = kalloc();
    800070f2:	ffffa097          	auipc	ra,0xffffa
    800070f6:	b20080e7          	jalr	-1248(ra) # 80000c12 <kalloc>
    800070fa:	f888                	sd	a0,48(s1)
  net.txq.device_area = kalloc();
    800070fc:	ffffa097          	auipc	ra,0xffffa
    80007100:	b16080e7          	jalr	-1258(ra) # 80000c12 <kalloc>
    80007104:	87aa                	mv	a5,a0
    80007106:	fc88                	sd	a0,56(s1)
  if (!net.txq.desc || !net.txq.driver_area || !net.txq.device_area)
    80007108:	7488                	ld	a0,40(s1)
    8000710a:	2a050563          	beqz	a0,800073b4 <virtio_net_init+0x3ca>
    8000710e:	00069717          	auipc	a4,0x69
    80007112:	84273703          	ld	a4,-1982(a4) # 8006f950 <net+0x30>
    80007116:	28070f63          	beqz	a4,800073b4 <virtio_net_init+0x3ca>
    8000711a:	28078d63          	beqz	a5,800073b4 <virtio_net_init+0x3ca>
    panic("virtio net alloc\n");
  memset(net.txq.desc, 0, PGSIZE);
    8000711e:	6605                	lui	a2,0x1
    80007120:	4581                	li	a1,0
    80007122:	ffffa097          	auipc	ra,0xffffa
    80007126:	d0a080e7          	jalr	-758(ra) # 80000e2c <memset>
  memset(net.txq.free, 1, NUM);
    8000712a:	00068497          	auipc	s1,0x68
    8000712e:	7f648493          	addi	s1,s1,2038 # 8006f920 <net>
    80007132:	4621                	li	a2,8
    80007134:	4585                	li	a1,1
    80007136:	00069517          	auipc	a0,0x69
    8000713a:	82e50513          	addi	a0,a0,-2002 # 8006f964 <net+0x44>
    8000713e:	ffffa097          	auipc	ra,0xffffa
    80007142:	cee080e7          	jalr	-786(ra) # 80000e2c <memset>
  memset(net.txq.driver_area, 0, PGSIZE);
    80007146:	6605                	lui	a2,0x1
    80007148:	4581                	li	a1,0
    8000714a:	7888                	ld	a0,48(s1)
    8000714c:	ffffa097          	auipc	ra,0xffffa
    80007150:	ce0080e7          	jalr	-800(ra) # 80000e2c <memset>
  memset(net.txq.device_area, 0, PGSIZE);
    80007154:	6605                	lui	a2,0x1
    80007156:	4581                	li	a1,0
    80007158:	7c88                	ld	a0,56(s1)
    8000715a:	ffffa097          	auipc	ra,0xffffa
    8000715e:	cd2080e7          	jalr	-814(ra) # 80000e2c <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80007162:	100027b7          	lui	a5,0x10002
    80007166:	4721                	li	a4,8
    80007168:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.txq.desc;
    8000716a:	749c                	ld	a5,40(s1)
    8000716c:	0007869b          	sext.w	a3,a5
    80007170:	10002737          	lui	a4,0x10002
    80007174:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.txq.desc) >> 32;
    80007178:	9781                	srai	a5,a5,0x20
    8000717a:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.txq.driver_area;
    8000717e:	789c                	ld	a5,48(s1)
    80007180:	0007869b          	sext.w	a3,a5
    80007184:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.txq.driver_area) >> 32;
    80007188:	9781                	srai	a5,a5,0x20
    8000718a:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.txq.device_area;
    8000718e:	7c9c                	ld	a5,56(s1)
    80007190:	0007869b          	sext.w	a3,a5
    80007194:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.txq.device_area) >> 32;
    80007198:	9781                	srai	a5,a5,0x20
    8000719a:	0af72223          	sw	a5,164(a4)

  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000719e:	87ba                	mv	a5,a4
    800071a0:	4705                	li	a4,1
    800071a2:	c3f8                	sw	a4,68(a5)
    800071a4:	04478793          	addi	a5,a5,68 # 10002044 <_entry-0x6fffdfbc>

  /* Initialize QUEUE_RX */

  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_RX;
    800071a8:	10002737          	lui	a4,0x10002
    800071ac:	02072823          	sw	zero,48(a4) # 10002030 <_entry-0x6fffdfd0>
  net.rxq.num = QUEUE_RX;
    800071b0:	0604a423          	sw	zero,104(s1)
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    800071b4:	439c                	lw	a5,0(a5)
    800071b6:	2781                	sext.w	a5,a5
    800071b8:	20079663          	bnez	a5,800073c4 <virtio_net_init+0x3da>
    panic("QUEUE_RX should not be ready\n");

  net.rxq.desc = kalloc();
    800071bc:	ffffa097          	auipc	ra,0xffffa
    800071c0:	a56080e7          	jalr	-1450(ra) # 80000c12 <kalloc>
    800071c4:	00068497          	auipc	s1,0x68
    800071c8:	75c48493          	addi	s1,s1,1884 # 8006f920 <net>
    800071cc:	e8a8                	sd	a0,80(s1)
  net.rxq.driver_area = kalloc();
    800071ce:	ffffa097          	auipc	ra,0xffffa
    800071d2:	a44080e7          	jalr	-1468(ra) # 80000c12 <kalloc>
    800071d6:	eca8                	sd	a0,88(s1)
  net.rxq.device_area = kalloc();
    800071d8:	ffffa097          	auipc	ra,0xffffa
    800071dc:	a3a080e7          	jalr	-1478(ra) # 80000c12 <kalloc>
    800071e0:	87aa                	mv	a5,a0
    800071e2:	f0a8                	sd	a0,96(s1)
  if (!net.rxq.desc || !net.rxq.driver_area || !net.rxq.device_area)
    800071e4:	68a8                	ld	a0,80(s1)
    800071e6:	1e050763          	beqz	a0,800073d4 <virtio_net_init+0x3ea>
    800071ea:	00068717          	auipc	a4,0x68
    800071ee:	78e73703          	ld	a4,1934(a4) # 8006f978 <net+0x58>
    800071f2:	1e070163          	beqz	a4,800073d4 <virtio_net_init+0x3ea>
    800071f6:	1c078f63          	beqz	a5,800073d4 <virtio_net_init+0x3ea>
    panic("virtio net alloc");
  memset(net.rxq.desc, 0, PGSIZE);
    800071fa:	6605                	lui	a2,0x1
    800071fc:	4581                	li	a1,0
    800071fe:	ffffa097          	auipc	ra,0xffffa
    80007202:	c2e080e7          	jalr	-978(ra) # 80000e2c <memset>
  memset(net.rxq.free, 1, NUM);
    80007206:	00068497          	auipc	s1,0x68
    8000720a:	71a48493          	addi	s1,s1,1818 # 8006f920 <net>
    8000720e:	4621                	li	a2,8
    80007210:	4585                	li	a1,1
    80007212:	00068517          	auipc	a0,0x68
    80007216:	77a50513          	addi	a0,a0,1914 # 8006f98c <net+0x6c>
    8000721a:	ffffa097          	auipc	ra,0xffffa
    8000721e:	c12080e7          	jalr	-1006(ra) # 80000e2c <memset>
  memset(net.rxq.driver_area, 0, PGSIZE);
    80007222:	6605                	lui	a2,0x1
    80007224:	4581                	li	a1,0
    80007226:	6ca8                	ld	a0,88(s1)
    80007228:	ffffa097          	auipc	ra,0xffffa
    8000722c:	c04080e7          	jalr	-1020(ra) # 80000e2c <memset>
  memset(net.rxq.device_area, 0, PGSIZE);
    80007230:	6605                	lui	a2,0x1
    80007232:	4581                	li	a1,0
    80007234:	70a8                	ld	a0,96(s1)
    80007236:	ffffa097          	auipc	ra,0xffffa
    8000723a:	bf6080e7          	jalr	-1034(ra) # 80000e2c <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000723e:	100027b7          	lui	a5,0x10002
    80007242:	4721                	li	a4,8
    80007244:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.rxq.desc;
    80007246:	68bc                	ld	a5,80(s1)
    80007248:	0007869b          	sext.w	a3,a5
    8000724c:	10002737          	lui	a4,0x10002
    80007250:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.rxq.desc) >> 32;
    80007254:	9781                	srai	a5,a5,0x20
    80007256:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.rxq.driver_area;
    8000725a:	6cbc                	ld	a5,88(s1)
    8000725c:	0007869b          	sext.w	a3,a5
    80007260:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.rxq.driver_area) >> 32;
    80007264:	9781                	srai	a5,a5,0x20
    80007266:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.rxq.device_area;
    8000726a:	70bc                	ld	a5,96(s1)
    8000726c:	0007869b          	sext.w	a3,a5
    80007270:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.rxq.device_area) >> 32;
    80007274:	9781                	srai	a5,a5,0x20
    80007276:	0af72223          	sw	a5,164(a4)
    8000727a:	4a11                	li	s4,4

  for (int i = 0; i < NUM / 2; i++) {
    int rx_hdr_desc = alloc_desc(&net.rxq);
    8000727c:	00068a97          	auipc	s5,0x68
    80007280:	6f4a8a93          	addi	s5,s5,1780 # 8006f970 <net+0x50>
    struct virtio_net_hdr *hdr = kalloc();
    if (!rxbuf)
      panic("rxbuf alloc failed");

    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    80007284:	4ca9                	li	s9,10
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    80007286:	4c05                	li	s8,1
    net.rxq.desc[rx_hdr_desc].next = rx_desc;

    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    net.rxq.desc[rx_desc].len = PGSIZE;
    80007288:	6b85                	lui	s7,0x1
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    8000728a:	4b09                	li	s6,2
    int rx_hdr_desc = alloc_desc(&net.rxq);
    8000728c:	8556                	mv	a0,s5
    8000728e:	00000097          	auipc	ra,0x0
    80007292:	cc6080e7          	jalr	-826(ra) # 80006f54 <alloc_desc>
    80007296:	89aa                	mv	s3,a0
    int rx_desc = alloc_desc(&net.rxq);
    80007298:	8556                	mv	a0,s5
    8000729a:	00000097          	auipc	ra,0x0
    8000729e:	cba080e7          	jalr	-838(ra) # 80006f54 <alloc_desc>
    800072a2:	8daa                	mv	s11,a0
    void *rxbuf = kalloc();
    800072a4:	ffffa097          	auipc	ra,0xffffa
    800072a8:	96e080e7          	jalr	-1682(ra) # 80000c12 <kalloc>
    800072ac:	892a                	mv	s2,a0
    struct virtio_net_hdr *hdr = kalloc();
    800072ae:	ffffa097          	auipc	ra,0xffffa
    800072b2:	964080e7          	jalr	-1692(ra) # 80000c12 <kalloc>
    if (!rxbuf)
    800072b6:	12090763          	beqz	s2,800073e4 <virtio_net_init+0x3fa>
    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    800072ba:	00499793          	slli	a5,s3,0x4
    800072be:	68b8                	ld	a4,80(s1)
    800072c0:	973e                	add	a4,a4,a5
    800072c2:	e308                	sd	a0,0(a4)
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    800072c4:	68b8                	ld	a4,80(s1)
    800072c6:	973e                	add	a4,a4,a5
    800072c8:	01972423          	sw	s9,8(a4)
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    800072cc:	68b8                	ld	a4,80(s1)
    800072ce:	973e                	add	a4,a4,a5
    800072d0:	01871623          	sh	s8,12(a4)
    net.rxq.desc[rx_hdr_desc].next = rx_desc;
    800072d4:	68b8                	ld	a4,80(s1)
    800072d6:	97ba                	add	a5,a5,a4
    800072d8:	01b79723          	sh	s11,14(a5) # 1000200e <_entry-0x6fffdff2>
    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    800072dc:	004d9793          	slli	a5,s11,0x4
    800072e0:	68b8                	ld	a4,80(s1)
    800072e2:	973e                	add	a4,a4,a5
    800072e4:	01273023          	sd	s2,0(a4)
    net.rxq.desc[rx_desc].len = PGSIZE;
    800072e8:	68b8                	ld	a4,80(s1)
    800072ea:	973e                	add	a4,a4,a5
    800072ec:	01772423          	sw	s7,8(a4)
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    800072f0:	68b8                	ld	a4,80(s1)
    800072f2:	97ba                	add	a5,a5,a4
    800072f4:	01679623          	sh	s6,12(a5)

    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = rx_hdr_desc;
    800072f8:	6cb8                	ld	a4,88(s1)
    800072fa:	00275783          	lhu	a5,2(a4)
    800072fe:	8b9d                	andi	a5,a5,7
    80007300:	0786                	slli	a5,a5,0x1
    80007302:	973e                	add	a4,a4,a5
    80007304:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    80007308:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    8000730c:	6cb8                	ld	a4,88(s1)
    8000730e:	00275783          	lhu	a5,2(a4)
    80007312:	2785                	addiw	a5,a5,1
    80007314:	00f71123          	sh	a5,2(a4)
    __sync_synchronize();
    80007318:	0330000f          	fence	rw,rw
  for (int i = 0; i < NUM / 2; i++) {
    8000731c:	3a7d                	addiw	s4,s4,-1
    8000731e:	f60a17e3          	bnez	s4,8000728c <virtio_net_init+0x2a2>
  }

  // queue is ready
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80007322:	100027b7          	lui	a5,0x10002
    80007326:	4705                	li	a4,1
    80007328:	c3f8                	sw	a4,68(a5)

  // Notify device
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_RX;
    8000732a:	0407a823          	sw	zero,80(a5) # 10002050 <_entry-0x6fffdfb0>

  // Done initializing
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000732e:	004d6d13          	ori	s10,s10,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80007332:	07a7a823          	sw	s10,112(a5)

  // initialize packet buffer
  packet_buf = kalloc();
    80007336:	ffffa097          	auipc	ra,0xffffa
    8000733a:	8dc080e7          	jalr	-1828(ra) # 80000c12 <kalloc>
    8000733e:	00007797          	auipc	a5,0x7
    80007342:	f4a7bd23          	sd	a0,-166(a5) # 8000e298 <packet_buf>
}
    80007346:	70a6                	ld	ra,104(sp)
    80007348:	7406                	ld	s0,96(sp)
    8000734a:	64e6                	ld	s1,88(sp)
    8000734c:	6946                	ld	s2,80(sp)
    8000734e:	69a6                	ld	s3,72(sp)
    80007350:	6a06                	ld	s4,64(sp)
    80007352:	7ae2                	ld	s5,56(sp)
    80007354:	7b42                	ld	s6,48(sp)
    80007356:	7ba2                	ld	s7,40(sp)
    80007358:	7c02                	ld	s8,32(sp)
    8000735a:	6ce2                	ld	s9,24(sp)
    8000735c:	6d42                	ld	s10,16(sp)
    8000735e:	6da2                	ld	s11,8(sp)
    80007360:	6165                	addi	sp,sp,112
    80007362:	8082                	ret
    panic("could not find virtio net");
    80007364:	00003517          	auipc	a0,0x3
    80007368:	46450513          	addi	a0,a0,1124 # 8000a7c8 <etext+0x7c8>
    8000736c:	ffff9097          	auipc	ra,0xffff9
    80007370:	1f2080e7          	jalr	498(ra) # 8000055e <panic>
    panic("virtio net FEATURES_OK unset");
    80007374:	00003517          	auipc	a0,0x3
    80007378:	47450513          	addi	a0,a0,1140 # 8000a7e8 <etext+0x7e8>
    8000737c:	ffff9097          	auipc	ra,0xffff9
    80007380:	1e2080e7          	jalr	482(ra) # 8000055e <panic>
    panic("virtio net has no queue 1 (QUEUE_TX)");
    80007384:	00003517          	auipc	a0,0x3
    80007388:	48450513          	addi	a0,a0,1156 # 8000a808 <etext+0x808>
    8000738c:	ffff9097          	auipc	ra,0xffff9
    80007390:	1d2080e7          	jalr	466(ra) # 8000055e <panic>
    panic("virtio net max queue too short");
    80007394:	00003517          	auipc	a0,0x3
    80007398:	49c50513          	addi	a0,a0,1180 # 8000a830 <etext+0x830>
    8000739c:	ffff9097          	auipc	ra,0xffff9
    800073a0:	1c2080e7          	jalr	450(ra) # 8000055e <panic>
    panic("QUEUE_TX should not be ready\n");
    800073a4:	00003517          	auipc	a0,0x3
    800073a8:	4ac50513          	addi	a0,a0,1196 # 8000a850 <etext+0x850>
    800073ac:	ffff9097          	auipc	ra,0xffff9
    800073b0:	1b2080e7          	jalr	434(ra) # 8000055e <panic>
    panic("virtio net alloc\n");
    800073b4:	00003517          	auipc	a0,0x3
    800073b8:	4bc50513          	addi	a0,a0,1212 # 8000a870 <etext+0x870>
    800073bc:	ffff9097          	auipc	ra,0xffff9
    800073c0:	1a2080e7          	jalr	418(ra) # 8000055e <panic>
    panic("QUEUE_RX should not be ready\n");
    800073c4:	00003517          	auipc	a0,0x3
    800073c8:	4c450513          	addi	a0,a0,1220 # 8000a888 <etext+0x888>
    800073cc:	ffff9097          	auipc	ra,0xffff9
    800073d0:	192080e7          	jalr	402(ra) # 8000055e <panic>
    panic("virtio net alloc");
    800073d4:	00003517          	auipc	a0,0x3
    800073d8:	4d450513          	addi	a0,a0,1236 # 8000a8a8 <etext+0x8a8>
    800073dc:	ffff9097          	auipc	ra,0xffff9
    800073e0:	182080e7          	jalr	386(ra) # 8000055e <panic>
      panic("rxbuf alloc failed");
    800073e4:	00003517          	auipc	a0,0x3
    800073e8:	4dc50513          	addi	a0,a0,1244 # 8000a8c0 <etext+0x8c0>
    800073ec:	ffff9097          	auipc	ra,0xffff9
    800073f0:	172080e7          	jalr	370(ra) # 8000055e <panic>

00000000800073f4 <apply_padding>:
 *      return 1 when the number of bytes calculated does not make sense
 */
int apply_padding(uint8 num_bytes) {
  uint8 *pkt_ptr =
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
  if (num_bytes > 64 - sizeof(struct virtio_net_hdr) || num_bytes < 1) {
    800073f4:	fff5079b          	addiw	a5,a0,-1
    800073f8:	0ff7f793          	zext.b	a5,a5
    800073fc:	03500713          	li	a4,53
    80007400:	02f76863          	bltu	a4,a5,80007430 <apply_padding+0x3c>
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    80007404:	04a00693          	li	a3,74
    80007408:	9e89                	subw	a3,a3,a0
    8000740a:	00007717          	auipc	a4,0x7
    8000740e:	e8e73703          	ld	a4,-370(a4) # 8000e298 <packet_buf>
    80007412:	00e687b3          	add	a5,a3,a4
    80007416:	0705                	addi	a4,a4,1
    80007418:	9736                	add	a4,a4,a3
    8000741a:	357d                	addiw	a0,a0,-1
    8000741c:	1502                	slli	a0,a0,0x20
    8000741e:	9101                	srli	a0,a0,0x20
    80007420:	972a                	add	a4,a4,a0
    printf("malformed packet data");
    return 1;
  }
  for (int i = 0; i < num_bytes; i++) {
    pkt_ptr[i] = 0;
    80007422:	00078023          	sb	zero,0(a5)
  for (int i = 0; i < num_bytes; i++) {
    80007426:	0785                	addi	a5,a5,1
    80007428:	fee79de3          	bne	a5,a4,80007422 <apply_padding+0x2e>
  }
  return 0;
    8000742c:	4501                	li	a0,0
}
    8000742e:	8082                	ret
int apply_padding(uint8 num_bytes) {
    80007430:	1141                	addi	sp,sp,-16
    80007432:	e406                	sd	ra,8(sp)
    80007434:	e022                	sd	s0,0(sp)
    80007436:	0800                	addi	s0,sp,16
    printf("malformed packet data");
    80007438:	00003517          	auipc	a0,0x3
    8000743c:	4a050513          	addi	a0,a0,1184 # 8000a8d8 <etext+0x8d8>
    80007440:	ffff9097          	auipc	ra,0xffff9
    80007444:	168080e7          	jalr	360(ra) # 800005a8 <printf>
    return 1;
    80007448:	4505                	li	a0,1
}
    8000744a:	60a2                	ld	ra,8(sp)
    8000744c:	6402                	ld	s0,0(sp)
    8000744e:	0141                	addi	sp,sp,16
    80007450:	8082                	ret

0000000080007452 <transmit_packet>:
 *                     of the data is 1500 (defined by the ethernet protocol)
 *
 * Output: There is no return value from the function, but the packet frame
 *         is given to the NIC to be transmitted.
 */
void transmit_packet(void *pkt_data, uint16 pkt_len, uint16 protocol) {
    80007452:	711d                	addi	sp,sp,-96
    80007454:	ec86                	sd	ra,88(sp)
    80007456:	e8a2                	sd	s0,80(sp)
    80007458:	e4a6                	sd	s1,72(sp)
    8000745a:	e0ca                	sd	s2,64(sp)
    8000745c:	fc4e                	sd	s3,56(sp)
    8000745e:	f852                	sd	s4,48(sp)
    80007460:	f456                	sd	s5,40(sp)
    80007462:	f05a                	sd	s6,32(sp)
    80007464:	ec5e                	sd	s7,24(sp)
    80007466:	e862                	sd	s8,16(sp)
    80007468:	e466                	sd	s9,8(sp)
    8000746a:	1080                	addi	s0,sp,96
    8000746c:	8caa                	mv	s9,a0
    8000746e:	8aae                	mv	s5,a1
    80007470:	84b2                	mv	s1,a2
  /* Create the header for transmission */
  acquire(&net.vnet_lock);
    80007472:	00068517          	auipc	a0,0x68
    80007476:	4be50513          	addi	a0,a0,1214 # 8006f930 <net+0x10>
    8000747a:	ffffa097          	auipc	ra,0xffffa
    8000747e:	8ba080e7          	jalr	-1862(ra) # 80000d34 <acquire>
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    80007482:	100027b7          	lui	a5,0x10002
    80007486:	4705                	li	a4,1
    80007488:	db98                	sw	a4,48(a5)
  // allocate for packet header and packet_frame
  struct virtio_net_hdr *hdr = kalloc();
    8000748a:	ffff9097          	auipc	ra,0xffff9
    8000748e:	788080e7          	jalr	1928(ra) # 80000c12 <kalloc>
  if (hdr == 0)
    80007492:	1c050f63          	beqz	a0,80007670 <transmit_packet+0x21e>
    80007496:	8baa                	mv	s7,a0
    panic("failed to allocate header\n");
  // initialize the header and packet
  memset(hdr, 0, PGSIZE);
    80007498:	6605                	lui	a2,0x1
    8000749a:	4581                	li	a1,0
    8000749c:	ffffa097          	auipc	ra,0xffffa
    800074a0:	990080e7          	jalr	-1648(ra) # 80000e2c <memset>

  int hdr_desc = alloc_desc(&net.txq);
    800074a4:	00068a17          	auipc	s4,0x68
    800074a8:	47ca0a13          	addi	s4,s4,1148 # 8006f920 <net>
    800074ac:	00068517          	auipc	a0,0x68
    800074b0:	49c50513          	addi	a0,a0,1180 # 8006f948 <net+0x28>
    800074b4:	00000097          	auipc	ra,0x0
    800074b8:	aa0080e7          	jalr	-1376(ra) # 80006f54 <alloc_desc>
    800074bc:	892a                	mv	s2,a0
  int pkt_desc = alloc_desc(&net.txq);
    800074be:	00068517          	auipc	a0,0x68
    800074c2:	48a50513          	addi	a0,a0,1162 # 8006f948 <net+0x28>
    800074c6:	00000097          	auipc	ra,0x0
    800074ca:	a8e080e7          	jalr	-1394(ra) # 80006f54 <alloc_desc>
    800074ce:	89aa                	mv	s3,a0

  hdr->flags = 0;
    800074d0:	000b8023          	sb	zero,0(s7) # 1000 <_entry-0x7ffff000>
  hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
    800074d4:	000b80a3          	sb	zero,1(s7)
  hdr->hdr_len = 0;
    800074d8:	000b9123          	sh	zero,2(s7)

  memmove(packet_buf, "\xe2\x71\xad\xf4\x7b\xff", 6);
    800074dc:	00007b17          	auipc	s6,0x7
    800074e0:	dbcb0b13          	addi	s6,s6,-580 # 8000e298 <packet_buf>
    800074e4:	4619                	li	a2,6
    800074e6:	00003597          	auipc	a1,0x3
    800074ea:	42a58593          	addi	a1,a1,1066 # 8000a910 <etext+0x910>
    800074ee:	000b3503          	ld	a0,0(s6)
    800074f2:	ffffa097          	auipc	ra,0xffffa
    800074f6:	99a080e7          	jalr	-1638(ra) # 80000e8c <memmove>
  memmove(packet_buf + 6, net.cfg.mac, 6);
    800074fa:	000b3503          	ld	a0,0(s6)
    800074fe:	4619                	li	a2,6
    80007500:	85d2                	mv	a1,s4
    80007502:	9532                	add	a0,a0,a2
    80007504:	ffffa097          	auipc	ra,0xffffa
    80007508:	988080e7          	jalr	-1656(ra) # 80000e8c <memmove>

  packet_buf[12] = (protocol >> 8);
    8000750c:	000b3503          	ld	a0,0(s6)
    80007510:	0084d71b          	srliw	a4,s1,0x8
    80007514:	00e50623          	sb	a4,12(a0)
  packet_buf[13] = (protocol & 0xF);
    80007518:	88bd                	andi	s1,s1,15
    8000751a:	009506a3          	sb	s1,13(a0)

  memmove(packet_buf + 14, pkt_data, pkt_len);
    8000751e:	000a8c1b          	sext.w	s8,s5
    80007522:	8662                	mv	a2,s8
    80007524:	85e6                	mv	a1,s9
    80007526:	0539                	addi	a0,a0,14
    80007528:	ffffa097          	auipc	ra,0xffffa
    8000752c:	964080e7          	jalr	-1692(ra) # 80000e8c <memmove>

  net.txq.desc[hdr_desc].flags |=
    80007530:	00491793          	slli	a5,s2,0x4
    80007534:	028a3703          	ld	a4,40(s4)
    80007538:	973e                	add	a4,a4,a5
    8000753a:	00c75683          	lhu	a3,12(a4)
    8000753e:	0016e693          	ori	a3,a3,1
    80007542:	00d71623          	sh	a3,12(a4)
      VRING_DESC_F_NEXT; // This tells the device it's a chain
  net.txq.desc[hdr_desc].len = HDR_SIZE;
    80007546:	028a3703          	ld	a4,40(s4)
    8000754a:	973e                	add	a4,a4,a5
    8000754c:	46a9                	li	a3,10
    8000754e:	c714                	sw	a3,8(a4)
  net.txq.desc[hdr_desc].addr = (uint64)hdr;
    80007550:	028a3703          	ld	a4,40(s4)
    80007554:	973e                	add	a4,a4,a5
    80007556:	01773023          	sd	s7,0(a4)
  net.txq.desc[hdr_desc].next = pkt_desc;
    8000755a:	028a3703          	ld	a4,40(s4)
    8000755e:	97ba                	add	a5,a5,a4
    80007560:	01379723          	sh	s3,14(a5) # 1000200e <_entry-0x6fffdff2>

  net.txq.desc[pkt_desc].len = 14 + pkt_len;
    80007564:	0992                	slli	s3,s3,0x4
    80007566:	028a3783          	ld	a5,40(s4)
    8000756a:	97ce                	add	a5,a5,s3
    8000756c:	00ea871b          	addiw	a4,s5,14
    80007570:	c798                	sw	a4,8(a5)
  net.txq.desc[pkt_desc].addr = (uint64)packet_buf;
    80007572:	028a3783          	ld	a5,40(s4)
    80007576:	97ce                	add	a5,a5,s3
    80007578:	000b3703          	ld	a4,0(s6)
    8000757c:	e398                	sd	a4,0(a5)
  net.txq.desc[pkt_desc].flags = 0;
    8000757e:	028a3783          	ld	a5,40(s4)
    80007582:	97ce                	add	a5,a5,s3
    80007584:	00079623          	sh	zero,12(a5)

  if (pkt_len < 64) {
    80007588:	03f00793          	li	a5,63
    8000758c:	0387e563          	bltu	a5,s8,800075b6 <transmit_packet+0x164>
    int res = apply_padding(64 - pkt_len);
    80007590:	04000513          	li	a0,64
    80007594:	4155053b          	subw	a0,a0,s5
    80007598:	0ff57513          	zext.b	a0,a0
    8000759c:	00000097          	auipc	ra,0x0
    800075a0:	e58080e7          	jalr	-424(ra) # 800073f4 <apply_padding>
    net.txq.desc[pkt_desc].len = 64;
    800075a4:	00068797          	auipc	a5,0x68
    800075a8:	3a47b783          	ld	a5,932(a5) # 8006f948 <net+0x28>
    800075ac:	97ce                	add	a5,a5,s3
    800075ae:	04000713          	li	a4,64
    800075b2:	c798                	sw	a4,8(a5)
    if (res != 0)
    800075b4:	e571                	bnez	a0,80007680 <transmit_packet+0x22e>
      panic("failed to apply padding");
  }

  // Tell the device first index in chain of descriptors
  net.txq.driver_area->ring[net.txq.driver_area->idx % NUM] = hdr_desc;
    800075b6:	00068997          	auipc	s3,0x68
    800075ba:	36a98993          	addi	s3,s3,874 # 8006f920 <net>
    800075be:	0309b703          	ld	a4,48(s3)
    800075c2:	00275783          	lhu	a5,2(a4)
    800075c6:	8b9d                	andi	a5,a5,7
    800075c8:	0786                	slli	a5,a5,0x1
    800075ca:	973e                	add	a4,a4,a5
    800075cc:	01271223          	sh	s2,4(a4)
  __sync_synchronize();
    800075d0:	0330000f          	fence	rw,rw
  // Tell the device another avail ring entry is available
  net.txq.driver_area->idx++;
    800075d4:	0309b703          	ld	a4,48(s3)
    800075d8:	00275783          	lhu	a5,2(a4)
    800075dc:	2785                	addiw	a5,a5,1
    800075de:	00f71123          	sh	a5,2(a4)
  __sync_synchronize();
    800075e2:	0330000f          	fence	rw,rw

  uint16 prev_used_idx = net.txq.device_area->idx;
    800075e6:	0389b783          	ld	a5,56(s3)
    800075ea:	0027d483          	lhu	s1,2(a5)
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_TX;
    800075ee:	100027b7          	lui	a5,0x10002
    800075f2:	4705                	li	a4,1
    800075f4:	cbb8                	sw	a4,80(a5)
  release(&net.vnet_lock);
    800075f6:	00068517          	auipc	a0,0x68
    800075fa:	33a50513          	addi	a0,a0,826 # 8006f930 <net+0x10>
    800075fe:	ffff9097          	auipc	ra,0xffff9
    80007602:	7e6080e7          	jalr	2022(ra) # 80000de4 <release>

  // Wait for the device to use the descriptor. It indicates this by
  // decrementing the index. Polling helps to avoid race conditions
  while (net.txq.device_area->idx == prev_used_idx) {
    80007606:	0389b783          	ld	a5,56(s3)
    8000760a:	0027d783          	lhu	a5,2(a5) # 10002002 <_entry-0x6fffdffe>
    8000760e:	00979c63          	bne	a5,s1,80007626 <transmit_packet+0x1d4>
    80007612:	86ce                	mv	a3,s3
    80007614:	0004871b          	sext.w	a4,s1
    __sync_synchronize();
    80007618:	0330000f          	fence	rw,rw
  while (net.txq.device_area->idx == prev_used_idx) {
    8000761c:	7e9c                	ld	a5,56(a3)
    8000761e:	0027d783          	lhu	a5,2(a5)
    80007622:	fee78be3          	beq	a5,a4,80007618 <transmit_packet+0x1c6>
  }
  printf("mac: %x:%x:%x:%x:%x:%x\n", net.cfg.mac[0], net.cfg.mac[1],
         net.cfg.mac[2], net.cfg.mac[3], net.cfg.mac[4], net.cfg.mac[5]);
    80007626:	00068597          	auipc	a1,0x68
    8000762a:	2fa58593          	addi	a1,a1,762 # 8006f920 <net>
  printf("mac: %x:%x:%x:%x:%x:%x\n", net.cfg.mac[0], net.cfg.mac[1],
    8000762e:	0055c803          	lbu	a6,5(a1)
    80007632:	0045c783          	lbu	a5,4(a1)
    80007636:	0035c703          	lbu	a4,3(a1)
    8000763a:	0025c683          	lbu	a3,2(a1)
    8000763e:	0015c603          	lbu	a2,1(a1)
    80007642:	0005c583          	lbu	a1,0(a1)
    80007646:	00003517          	auipc	a0,0x3
    8000764a:	2ea50513          	addi	a0,a0,746 # 8000a930 <etext+0x930>
    8000764e:	ffff9097          	auipc	ra,0xffff9
    80007652:	f5a080e7          	jalr	-166(ra) # 800005a8 <printf>
}
    80007656:	60e6                	ld	ra,88(sp)
    80007658:	6446                	ld	s0,80(sp)
    8000765a:	64a6                	ld	s1,72(sp)
    8000765c:	6906                	ld	s2,64(sp)
    8000765e:	79e2                	ld	s3,56(sp)
    80007660:	7a42                	ld	s4,48(sp)
    80007662:	7aa2                	ld	s5,40(sp)
    80007664:	7b02                	ld	s6,32(sp)
    80007666:	6be2                	ld	s7,24(sp)
    80007668:	6c42                	ld	s8,16(sp)
    8000766a:	6ca2                	ld	s9,8(sp)
    8000766c:	6125                	addi	sp,sp,96
    8000766e:	8082                	ret
    panic("failed to allocate header\n");
    80007670:	00003517          	auipc	a0,0x3
    80007674:	28050513          	addi	a0,a0,640 # 8000a8f0 <etext+0x8f0>
    80007678:	ffff9097          	auipc	ra,0xffff9
    8000767c:	ee6080e7          	jalr	-282(ra) # 8000055e <panic>
      panic("failed to apply padding");
    80007680:	00003517          	auipc	a0,0x3
    80007684:	29850513          	addi	a0,a0,664 # 8000a918 <etext+0x918>
    80007688:	ffff9097          	auipc	ra,0xffff9
    8000768c:	ed6080e7          	jalr	-298(ra) # 8000055e <panic>

0000000080007690 <print_packet_info>:

void print_packet_info(struct ip_packet *packet) {
    80007690:	7179                	addi	sp,sp,-48
    80007692:	f406                	sd	ra,40(sp)
    80007694:	f022                	sd	s0,32(sp)
    80007696:	e84a                	sd	s2,16(sp)
    80007698:	1800                	addi	s0,sp,48
    8000769a:	892a                	mv	s2,a0
  printf("protocol: %d\n", packet->protocol);
    8000769c:	00b54583          	lbu	a1,11(a0)
    800076a0:	00003517          	auipc	a0,0x3
    800076a4:	2a850513          	addi	a0,a0,680 # 8000a948 <etext+0x948>
    800076a8:	ffff9097          	auipc	ra,0xffff9
    800076ac:	f00080e7          	jalr	-256(ra) # 800005a8 <printf>
  printf("src_ip: %d\n", ntohs(packet->src_ip));
    800076b0:	01095503          	lhu	a0,16(s2)
    800076b4:	00001097          	auipc	ra,0x1
    800076b8:	a20080e7          	jalr	-1504(ra) # 800080d4 <ntohs>
    800076bc:	0005059b          	sext.w	a1,a0
    800076c0:	00003517          	auipc	a0,0x3
    800076c4:	29850513          	addi	a0,a0,664 # 8000a958 <etext+0x958>
    800076c8:	ffff9097          	auipc	ra,0xffff9
    800076cc:	ee0080e7          	jalr	-288(ra) # 800005a8 <printf>
  printf("dst_ip: %d\n", packet->dst_ip);
    800076d0:	01492583          	lw	a1,20(s2)
    800076d4:	00003517          	auipc	a0,0x3
    800076d8:	29450513          	addi	a0,a0,660 # 8000a968 <etext+0x968>
    800076dc:	ffff9097          	auipc	ra,0xffff9
    800076e0:	ecc080e7          	jalr	-308(ra) # 800005a8 <printf>
  for (int i = 0; i < packet->total_len - packet->hdr_len; i++) {
    800076e4:	00495703          	lhu	a4,4(s2)
    800076e8:	00194783          	lbu	a5,1(s2)
    800076ec:	02e7df63          	bge	a5,a4,8000772a <print_packet_info+0x9a>
    800076f0:	ec26                	sd	s1,24(sp)
    800076f2:	e44e                	sd	s3,8(sp)
    800076f4:	4481                	li	s1,0
    printf("%c", packet->data[i]);
    800076f6:	00003997          	auipc	s3,0x3
    800076fa:	28298993          	addi	s3,s3,642 # 8000a978 <etext+0x978>
    800076fe:	01893783          	ld	a5,24(s2)
    80007702:	97a6                	add	a5,a5,s1
    80007704:	0007c583          	lbu	a1,0(a5)
    80007708:	854e                	mv	a0,s3
    8000770a:	ffff9097          	auipc	ra,0xffff9
    8000770e:	e9e080e7          	jalr	-354(ra) # 800005a8 <printf>
  for (int i = 0; i < packet->total_len - packet->hdr_len; i++) {
    80007712:	0485                	addi	s1,s1,1
    80007714:	00495783          	lhu	a5,4(s2)
    80007718:	00194703          	lbu	a4,1(s2)
    8000771c:	9f99                	subw	a5,a5,a4
    8000771e:	0004871b          	sext.w	a4,s1
    80007722:	fcf74ee3          	blt	a4,a5,800076fe <print_packet_info+0x6e>
    80007726:	64e2                	ld	s1,24(sp)
    80007728:	69a2                	ld	s3,8(sp)
  }
  printf("\n");
    8000772a:	00003517          	auipc	a0,0x3
    8000772e:	8f650513          	addi	a0,a0,-1802 # 8000a020 <etext+0x20>
    80007732:	ffff9097          	auipc	ra,0xffff9
    80007736:	e76080e7          	jalr	-394(ra) # 800005a8 <printf>
}
    8000773a:	70a2                	ld	ra,40(sp)
    8000773c:	7402                	ld	s0,32(sp)
    8000773e:	6942                	ld	s2,16(sp)
    80007740:	6145                	addi	sp,sp,48
    80007742:	8082                	ret

0000000080007744 <receive_packet>:

uint16 receive_packet(void *pkt_buf, uint16 num_bytes) {
    80007744:	7179                	addi	sp,sp,-48
    80007746:	f406                	sd	ra,40(sp)
    80007748:	f022                	sd	s0,32(sp)
    8000774a:	ec26                	sd	s1,24(sp)
    8000774c:	1800                	addi	s0,sp,48
  acquire(&net.vnet_lock);
    8000774e:	00068497          	auipc	s1,0x68
    80007752:	1d248493          	addi	s1,s1,466 # 8006f920 <net>
    80007756:	00068517          	auipc	a0,0x68
    8000775a:	1da50513          	addi	a0,a0,474 # 8006f930 <net+0x10>
    8000775e:	ffff9097          	auipc	ra,0xffff9
    80007762:	5d6080e7          	jalr	1494(ra) # 80000d34 <acquire>
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    80007766:	58fc                	lw	a5,116(s1)
    80007768:	70b8                	ld	a4,96(s1)
    8000776a:	00275683          	lhu	a3,2(a4)
    8000776e:	08f68663          	beq	a3,a5,800077fa <receive_packet+0xb6>
    80007772:	e84a                	sd	s2,16(sp)
    80007774:	e44e                	sd	s3,8(sp)
    80007776:	e052                	sd	s4,0(sp)
    int id = net.rxq.device_area->ring[net.rxq.used_idx % NUM].id;
    uint len = net.rxq.device_area->ring[net.rxq.used_idx % NUM].len;

    struct ip_packet *packet = (struct ip_packet *)net.rxq.desc[net.rxq.desc[id].next].addr;

    printf("Interrupt: received packet of length %d\n", len - 10);
    80007778:	00003917          	auipc	s2,0x3
    8000777c:	20890913          	addi	s2,s2,520 # 8000a980 <etext+0x980>
    int id = net.rxq.device_area->ring[net.rxq.used_idx % NUM].id;
    80007780:	41f7d69b          	sraiw	a3,a5,0x1f
    80007784:	01d6d69b          	srliw	a3,a3,0x1d
    80007788:	9fb5                	addw	a5,a5,a3
    8000778a:	8b9d                	andi	a5,a5,7
    8000778c:	9f95                	subw	a5,a5,a3
    8000778e:	078e                	slli	a5,a5,0x3
    80007790:	973e                	add	a4,a4,a5
    80007792:	00472983          	lw	s3,4(a4)
    struct ip_packet *packet = (struct ip_packet *)net.rxq.desc[net.rxq.desc[id].next].addr;
    80007796:	68bc                	ld	a5,80(s1)
    80007798:	00499693          	slli	a3,s3,0x4
    8000779c:	96be                	add	a3,a3,a5
    8000779e:	00e6d683          	lhu	a3,14(a3)
    800077a2:	0692                	slli	a3,a3,0x4
    800077a4:	97b6                	add	a5,a5,a3
    800077a6:	0007ba03          	ld	s4,0(a5)
    printf("Interrupt: received packet of length %d\n", len - 10);
    800077aa:	470c                	lw	a1,8(a4)
    800077ac:	35d9                	addiw	a1,a1,-10
    800077ae:	854a                	mv	a0,s2
    800077b0:	ffff9097          	auipc	ra,0xffff9
    800077b4:	df8080e7          	jalr	-520(ra) # 800005a8 <printf>

    print_packet_info(packet);
    800077b8:	8552                	mv	a0,s4
    800077ba:	00000097          	auipc	ra,0x0
    800077be:	ed6080e7          	jalr	-298(ra) # 80007690 <print_packet_info>

    // Requeue the buffer
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    800077c2:	6cb8                	ld	a4,88(s1)
    800077c4:	00275783          	lhu	a5,2(a4)
    800077c8:	8b9d                	andi	a5,a5,7
    800077ca:	0786                	slli	a5,a5,0x1
    800077cc:	973e                	add	a4,a4,a5
    800077ce:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    800077d2:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    800077d6:	6cb8                	ld	a4,88(s1)
    800077d8:	00275783          	lhu	a5,2(a4)
    800077dc:	2785                	addiw	a5,a5,1
    800077de:	00f71123          	sh	a5,2(a4)
    net.rxq.used_idx++;
    800077e2:	58f8                	lw	a4,116(s1)
    800077e4:	2705                	addiw	a4,a4,1
    800077e6:	87ba                	mv	a5,a4
    800077e8:	d8f8                	sw	a4,116(s1)
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    800077ea:	70b8                	ld	a4,96(s1)
    800077ec:	00275683          	lhu	a3,2(a4)
    800077f0:	f8f698e3          	bne	a3,a5,80007780 <receive_packet+0x3c>
    800077f4:	6942                	ld	s2,16(sp)
    800077f6:	69a2                	ld	s3,8(sp)
    800077f8:	6a02                	ld	s4,0(sp)
  }
  release(&net.vnet_lock);
    800077fa:	00068517          	auipc	a0,0x68
    800077fe:	13650513          	addi	a0,a0,310 # 8006f930 <net+0x10>
    80007802:	ffff9097          	auipc	ra,0xffff9
    80007806:	5e2080e7          	jalr	1506(ra) # 80000de4 <release>
  return 0;
}
    8000780a:	4501                	li	a0,0
    8000780c:	70a2                	ld	ra,40(sp)
    8000780e:	7402                	ld	s0,32(sp)
    80007810:	64e2                	ld	s1,24(sp)
    80007812:	6145                	addi	sp,sp,48
    80007814:	8082                	ret

0000000080007816 <insert_port_binding>:
struct socket_list *tcp_sock_list;
struct socket_list *udp_sock_list;

extern struct net_state netconf;

int insert_port_binding(struct port_binding *bind) {
    80007816:	1141                	addi	sp,sp,-16
    80007818:	e406                	sd	ra,8(sp)
    8000781a:	e022                	sd	s0,0(sp)
    8000781c:	0800                	addi	s0,sp,16
  port_binds[bind->port] = bind;
    8000781e:	00255703          	lhu	a4,2(a0)
    80007822:	070e                	slli	a4,a4,0x3
    80007824:	00068797          	auipc	a5,0x68
    80007828:	17478793          	addi	a5,a5,372 # 8006f998 <port_binds>
    8000782c:	97ba                	add	a5,a5,a4
    8000782e:	e388                	sd	a0,0(a5)
  return 0;
}
    80007830:	4501                	li	a0,0
    80007832:	60a2                	ld	ra,8(sp)
    80007834:	6402                	ld	s0,0(sp)
    80007836:	0141                	addi	sp,sp,16
    80007838:	8082                	ret

000000008000783a <remove_port_binding>:

int remove_port_binding(struct port_binding *bind) {
    8000783a:	1141                	addi	sp,sp,-16
    8000783c:	e406                	sd	ra,8(sp)
    8000783e:	e022                	sd	s0,0(sp)
    80007840:	0800                	addi	s0,sp,16
  if (port_binds[bind->port] == 0)
    80007842:	00255783          	lhu	a5,2(a0)
    80007846:	00379693          	slli	a3,a5,0x3
    8000784a:	00068717          	auipc	a4,0x68
    8000784e:	14e70713          	addi	a4,a4,334 # 8006f998 <port_binds>
    80007852:	9736                	add	a4,a4,a3
    80007854:	6318                	ld	a4,0(a4)
    80007856:	cf11                	beqz	a4,80007872 <remove_port_binding+0x38>
    return -1;

  port_binds[bind->port] = 0;
    80007858:	00068717          	auipc	a4,0x68
    8000785c:	14070713          	addi	a4,a4,320 # 8006f998 <port_binds>
    80007860:	00d707b3          	add	a5,a4,a3
    80007864:	0007b023          	sd	zero,0(a5)

  return 0;
    80007868:	4501                	li	a0,0
}
    8000786a:	60a2                	ld	ra,8(sp)
    8000786c:	6402                	ld	s0,0(sp)
    8000786e:	0141                	addi	sp,sp,16
    80007870:	8082                	ret
    return -1;
    80007872:	557d                	li	a0,-1
    80007874:	bfdd                	j	8000786a <remove_port_binding+0x30>

0000000080007876 <tcp_socket_list_insert>:

int tcp_socket_list_insert(struct socket* sock) {
    80007876:	1141                	addi	sp,sp,-16
    80007878:	e406                	sd	ra,8(sp)
    8000787a:	e022                	sd	s0,0(sp)
    8000787c:	0800                	addi	s0,sp,16
  int fd = -1;

  if (tcp_sock_list->size == MAX_SOCKET_CAPACITY) {
    8000787e:	00007797          	auipc	a5,0x7
    80007882:	a2a7b783          	ld	a5,-1494(a5) # 8000e2a8 <tcp_sock_list>
    80007886:	4794                	lw	a3,8(a5)
    80007888:	20000713          	li	a4,512
    8000788c:	02e68a63          	beq	a3,a4,800078c0 <tcp_socket_list_insert+0x4a>
    80007890:	862a                	mv	a2,a0
    80007892:	639c                	ld	a5,0(a5)
    return -1;
  }

  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    80007894:	4501                	li	a0,0
    80007896:	86ba                	mv	a3,a4
    if (tcp_sock_list->socks[i] == 0) {
    80007898:	6398                	ld	a4,0(a5)
    8000789a:	c719                	beqz	a4,800078a8 <tcp_socket_list_insert+0x32>
  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    8000789c:	2505                	addiw	a0,a0,1
    8000789e:	07a1                	addi	a5,a5,8
    800078a0:	fed51ce3          	bne	a0,a3,80007898 <tcp_socket_list_insert+0x22>
  int fd = -1;
    800078a4:	557d                	li	a0,-1
    800078a6:	a809                	j	800078b8 <tcp_socket_list_insert+0x42>
      tcp_sock_list->socks[i] = sock;
    800078a8:	e390                	sd	a2,0(a5)
      tcp_sock_list->size++;
    800078aa:	00007717          	auipc	a4,0x7
    800078ae:	9fe73703          	ld	a4,-1538(a4) # 8000e2a8 <tcp_sock_list>
    800078b2:	471c                	lw	a5,8(a4)
    800078b4:	2785                	addiw	a5,a5,1
    800078b6:	c71c                	sw	a5,8(a4)
      fd = i;
      break;
    }
  }
  return fd;
}
    800078b8:	60a2                	ld	ra,8(sp)
    800078ba:	6402                	ld	s0,0(sp)
    800078bc:	0141                	addi	sp,sp,16
    800078be:	8082                	ret
    return -1;
    800078c0:	557d                	li	a0,-1
    800078c2:	bfdd                	j	800078b8 <tcp_socket_list_insert+0x42>

00000000800078c4 <sockalloc>:

int
sockalloc(struct socket **sock)
{
    800078c4:	1101                	addi	sp,sp,-32
    800078c6:	ec06                	sd	ra,24(sp)
    800078c8:	e822                	sd	s0,16(sp)
    800078ca:	e426                	sd	s1,8(sp)
    800078cc:	e04a                	sd	s2,0(sp)
    800078ce:	1000                	addi	s0,sp,32
    800078d0:	84aa                	mv	s1,a0
  *sock = (struct socket *)kalloc();
    800078d2:	ffff9097          	auipc	ra,0xffff9
    800078d6:	340080e7          	jalr	832(ra) # 80000c12 <kalloc>
    800078da:	e088                	sd	a0,0(s1)
  if (sock == 0) {
    800078dc:	c88d                	beqz	s1,8000790e <sockalloc+0x4a>
    printf("ERROR: kalloc\n");
    return -1;
  }
  memset(*sock, 0, PGSIZE);
    800078de:	6605                	lui	a2,0x1
    800078e0:	4581                	li	a1,0
    800078e2:	ffff9097          	auipc	ra,0xffff9
    800078e6:	54a080e7          	jalr	1354(ra) # 80000e2c <memset>

  int fd = tcp_socket_list_insert(*sock);
    800078ea:	6088                	ld	a0,0(s1)
    800078ec:	00000097          	auipc	ra,0x0
    800078f0:	f8a080e7          	jalr	-118(ra) # 80007876 <tcp_socket_list_insert>
    800078f4:	892a                	mv	s2,a0
  if (fd == -1) {
    800078f6:	57fd                	li	a5,-1
    800078f8:	02f50563          	beq	a0,a5,80007922 <sockalloc+0x5e>
    printf("socket: fd == -1\n");
    kfree(*sock);
    return -1;
  }
  (*sock)->fd = fd;
    800078fc:	609c                	ld	a5,0(s1)
    800078fe:	c7a8                	sw	a0,72(a5)
  return fd;
}
    80007900:	854a                	mv	a0,s2
    80007902:	60e2                	ld	ra,24(sp)
    80007904:	6442                	ld	s0,16(sp)
    80007906:	64a2                	ld	s1,8(sp)
    80007908:	6902                	ld	s2,0(sp)
    8000790a:	6105                	addi	sp,sp,32
    8000790c:	8082                	ret
    printf("ERROR: kalloc\n");
    8000790e:	00003517          	auipc	a0,0x3
    80007912:	0a250513          	addi	a0,a0,162 # 8000a9b0 <etext+0x9b0>
    80007916:	ffff9097          	auipc	ra,0xffff9
    8000791a:	c92080e7          	jalr	-878(ra) # 800005a8 <printf>
    return -1;
    8000791e:	597d                	li	s2,-1
    80007920:	b7c5                	j	80007900 <sockalloc+0x3c>
    printf("socket: fd == -1\n");
    80007922:	00003517          	auipc	a0,0x3
    80007926:	09e50513          	addi	a0,a0,158 # 8000a9c0 <etext+0x9c0>
    8000792a:	ffff9097          	auipc	ra,0xffff9
    8000792e:	c7e080e7          	jalr	-898(ra) # 800005a8 <printf>
    kfree(*sock);
    80007932:	6088                	ld	a0,0(s1)
    80007934:	ffff9097          	auipc	ra,0xffff9
    80007938:	170080e7          	jalr	368(ra) # 80000aa4 <kfree>
    return -1;
    8000793c:	b7d1                	j	80007900 <sockalloc+0x3c>

000000008000793e <bind>:

int
bind(int socket, const struct sockaddr *sock_address, socklen_t address_len)
{
    8000793e:	7139                	addi	sp,sp,-64
    80007940:	fc06                	sd	ra,56(sp)
    80007942:	f822                	sd	s0,48(sp)
    80007944:	ec4e                	sd	s3,24(sp)
    80007946:	0080                	addi	s0,sp,64
  if (socket < 0) {
    80007948:	0c054a63          	bltz	a0,80007a1c <bind+0xde>
    8000794c:	f426                	sd	s1,40(sp)
    8000794e:	e05a                	sd	s6,0(sp)
    80007950:	84ae                	mv	s1,a1
    80007952:	8b32                	mv	s6,a2
    printf("bind: socket == 0\n");
    return -1;
  } else if (sock_address == 0) {
    80007954:	cdf1                	beqz	a1,80007a30 <bind+0xf2>
    80007956:	f04a                	sd	s2,32(sp)
    80007958:	e456                	sd	s5,8(sp)
    printf("bind: sock_address == 0\n");
    return -1;
  }

  struct socket *sock = tcp_sock_list->socks[socket];
    8000795a:	00007797          	auipc	a5,0x7
    8000795e:	94e7b783          	ld	a5,-1714(a5) # 8000e2a8 <tcp_sock_list>
    80007962:	639c                	ld	a5,0(a5)
    80007964:	050e                	slli	a0,a0,0x3
    80007966:	97aa                	add	a5,a5,a0
    80007968:	0007b903          	ld	s2,0(a5)
  const struct sockaddr_in *sockaddr = (struct sockaddr_in *)sock_address;
  uint16 port = ntohs(sockaddr->sin_port);
    8000796c:	0025d503          	lhu	a0,2(a1)
    80007970:	00000097          	auipc	ra,0x0
    80007974:	764080e7          	jalr	1892(ra) # 800080d4 <ntohs>
    80007978:	8aaa                	mv	s5,a0

  if(sockaddr->sin_port < 0 || sockaddr->sin_port > MAX_PORT_BINDINGS) {
    8000797a:	0024d703          	lhu	a4,2(s1)
    8000797e:	20000793          	li	a5,512
    80007982:	0ce7e363          	bltu	a5,a4,80007a48 <bind+0x10a>
    80007986:	e852                	sd	s4,16(sp)
    printf("bind: port number not valid within range\n");
    return -1;
  } else if (port_binds[port]) {
    80007988:	00050a1b          	sext.w	s4,a0
    8000798c:	003a1713          	slli	a4,s4,0x3
    80007990:	00068797          	auipc	a5,0x68
    80007994:	00878793          	addi	a5,a5,8 # 8006f998 <port_binds>
    80007998:	97ba                	add	a5,a5,a4
    8000799a:	639c                	ld	a5,0(a5)
    8000799c:	e7e1                	bnez	a5,80007a64 <bind+0x126>
    printf("bind: port number already bound\n");
    return -1;
  }

  sock->family = sock_address->sa_family;
    8000799e:	0004d783          	lhu	a5,0(s1)
    800079a2:	0007899b          	sext.w	s3,a5
    800079a6:	04f92023          	sw	a5,64(s2)

  switch(sock->family) {
    800079aa:	14099363          	bnez	s3,80007af0 <bind+0x1b2>
    case(AF_INET): 
      if (address_len != sizeof(struct sockaddr_in)) {
    800079ae:	47c1                	li	a5,16
    800079b0:	0cfb1963          	bne	s6,a5,80007a82 <bind+0x144>
        printf("bind: incorrect address_len for ipv4\n");
        return -1;
      }

      if (port_binds[port]) {
    800079b4:	003a1713          	slli	a4,s4,0x3
    800079b8:	00068797          	auipc	a5,0x68
    800079bc:	fe078793          	addi	a5,a5,-32 # 8006f998 <port_binds>
    800079c0:	97ba                	add	a5,a5,a4
    800079c2:	639c                	ld	a5,0(a5)
    800079c4:	eff1                	bnez	a5,80007aa0 <bind+0x162>
        printf("bind: port %d in use\n", port);
        return -1;
      }

      struct port_binding *binding = (struct port_binding*) kalloc();
    800079c6:	ffff9097          	auipc	ra,0xffff9
    800079ca:	24c080e7          	jalr	588(ra) # 80000c12 <kalloc>
      if (binding == 0) {
    800079ce:	c96d                	beqz	a0,80007ac0 <bind+0x182>
        printf("ERROR: kalloc\n");
        return -1;
      }
      binding->port = port;
    800079d0:	01551123          	sh	s5,2(a0)
      if (sockaddr->sin_addr.s_addr == INADDR_ANY) {
    800079d4:	40dc                	lw	a5,4(s1)
    800079d6:	4705                	li	a4,1
    800079d8:	10e78363          	beq	a5,a4,80007ade <bind+0x1a0>
        sock->src_ip = netconf.ip_addr;
        binding->ip_addr = netconf.ip_addr;
      } else {
        binding->ip_addr = sockaddr->sin_addr.s_addr;
    800079dc:	00f51023          	sh	a5,0(a0)
        sock->src_ip = sockaddr->sin_addr.s_addr;
    800079e0:	40dc                	lw	a5,4(s1)
    800079e2:	02f92423          	sw	a5,40(s2)
      }

      binding->sock = sock;
    800079e6:	01253423          	sd	s2,8(a0)
  port_binds[bind->port] = bind;
    800079ea:	00255703          	lhu	a4,2(a0)
    800079ee:	070e                	slli	a4,a4,0x3
    800079f0:	00068797          	auipc	a5,0x68
    800079f4:	fa878793          	addi	a5,a5,-88 # 8006f998 <port_binds>
    800079f8:	97ba                	add	a5,a5,a4
    800079fa:	e388                	sd	a0,0(a5)
        printf("bind: failed to bind to port\n");
        kfree(binding);
        return -1;
      }

      sock->src_port = port;
    800079fc:	03492823          	sw	s4,48(s2)
      sock->family = sockaddr->sin_family;
    80007a00:	0004d783          	lhu	a5,0(s1)
    80007a04:	04f92023          	sw	a5,64(s2)
      sock->state = BOUND;
    80007a08:	03300793          	li	a5,51
    80007a0c:	04f92223          	sw	a5,68(s2)

      return 0;
    80007a10:	74a2                	ld	s1,40(sp)
    80007a12:	7902                	ld	s2,32(sp)
    80007a14:	6a42                	ld	s4,16(sp)
    80007a16:	6aa2                	ld	s5,8(sp)
    80007a18:	6b02                	ld	s6,0(sp)
    80007a1a:	a0cd                	j	80007afc <bind+0x1be>
    printf("bind: socket == 0\n");
    80007a1c:	00003517          	auipc	a0,0x3
    80007a20:	fbc50513          	addi	a0,a0,-68 # 8000a9d8 <etext+0x9d8>
    80007a24:	ffff9097          	auipc	ra,0xffff9
    80007a28:	b84080e7          	jalr	-1148(ra) # 800005a8 <printf>
    return -1;
    80007a2c:	59fd                	li	s3,-1
    80007a2e:	a0f9                	j	80007afc <bind+0x1be>
    printf("bind: sock_address == 0\n");
    80007a30:	00003517          	auipc	a0,0x3
    80007a34:	fc050513          	addi	a0,a0,-64 # 8000a9f0 <etext+0x9f0>
    80007a38:	ffff9097          	auipc	ra,0xffff9
    80007a3c:	b70080e7          	jalr	-1168(ra) # 800005a8 <printf>
    return -1;
    80007a40:	59fd                	li	s3,-1
    80007a42:	74a2                	ld	s1,40(sp)
    80007a44:	6b02                	ld	s6,0(sp)
    80007a46:	a85d                	j	80007afc <bind+0x1be>
    printf("bind: port number not valid within range\n");
    80007a48:	00003517          	auipc	a0,0x3
    80007a4c:	fc850513          	addi	a0,a0,-56 # 8000aa10 <etext+0xa10>
    80007a50:	ffff9097          	auipc	ra,0xffff9
    80007a54:	b58080e7          	jalr	-1192(ra) # 800005a8 <printf>
    return -1;
    80007a58:	59fd                	li	s3,-1
    80007a5a:	74a2                	ld	s1,40(sp)
    80007a5c:	7902                	ld	s2,32(sp)
    80007a5e:	6aa2                	ld	s5,8(sp)
    80007a60:	6b02                	ld	s6,0(sp)
    80007a62:	a869                	j	80007afc <bind+0x1be>
    printf("bind: port number already bound\n");
    80007a64:	00003517          	auipc	a0,0x3
    80007a68:	fdc50513          	addi	a0,a0,-36 # 8000aa40 <etext+0xa40>
    80007a6c:	ffff9097          	auipc	ra,0xffff9
    80007a70:	b3c080e7          	jalr	-1220(ra) # 800005a8 <printf>
    return -1;
    80007a74:	59fd                	li	s3,-1
    80007a76:	74a2                	ld	s1,40(sp)
    80007a78:	7902                	ld	s2,32(sp)
    80007a7a:	6a42                	ld	s4,16(sp)
    80007a7c:	6aa2                	ld	s5,8(sp)
    80007a7e:	6b02                	ld	s6,0(sp)
    80007a80:	a8b5                	j	80007afc <bind+0x1be>
        printf("bind: incorrect address_len for ipv4\n");
    80007a82:	00003517          	auipc	a0,0x3
    80007a86:	fe650513          	addi	a0,a0,-26 # 8000aa68 <etext+0xa68>
    80007a8a:	ffff9097          	auipc	ra,0xffff9
    80007a8e:	b1e080e7          	jalr	-1250(ra) # 800005a8 <printf>
        return -1;
    80007a92:	59fd                	li	s3,-1
    80007a94:	74a2                	ld	s1,40(sp)
    80007a96:	7902                	ld	s2,32(sp)
    80007a98:	6a42                	ld	s4,16(sp)
    80007a9a:	6aa2                	ld	s5,8(sp)
    80007a9c:	6b02                	ld	s6,0(sp)
    80007a9e:	a8b9                	j	80007afc <bind+0x1be>
        printf("bind: port %d in use\n", port);
    80007aa0:	85d2                	mv	a1,s4
    80007aa2:	00003517          	auipc	a0,0x3
    80007aa6:	fee50513          	addi	a0,a0,-18 # 8000aa90 <etext+0xa90>
    80007aaa:	ffff9097          	auipc	ra,0xffff9
    80007aae:	afe080e7          	jalr	-1282(ra) # 800005a8 <printf>
        return -1;
    80007ab2:	59fd                	li	s3,-1
    80007ab4:	74a2                	ld	s1,40(sp)
    80007ab6:	7902                	ld	s2,32(sp)
    80007ab8:	6a42                	ld	s4,16(sp)
    80007aba:	6aa2                	ld	s5,8(sp)
    80007abc:	6b02                	ld	s6,0(sp)
    80007abe:	a83d                	j	80007afc <bind+0x1be>
        printf("ERROR: kalloc\n");
    80007ac0:	00003517          	auipc	a0,0x3
    80007ac4:	ef050513          	addi	a0,a0,-272 # 8000a9b0 <etext+0x9b0>
    80007ac8:	ffff9097          	auipc	ra,0xffff9
    80007acc:	ae0080e7          	jalr	-1312(ra) # 800005a8 <printf>
        return -1;
    80007ad0:	59fd                	li	s3,-1
    80007ad2:	74a2                	ld	s1,40(sp)
    80007ad4:	7902                	ld	s2,32(sp)
    80007ad6:	6a42                	ld	s4,16(sp)
    80007ad8:	6aa2                	ld	s5,8(sp)
    80007ada:	6b02                	ld	s6,0(sp)
    80007adc:	a005                	j	80007afc <bind+0x1be>
        sock->src_ip = netconf.ip_addr;
    80007ade:	00069797          	auipc	a5,0x69
    80007ae2:	eba7a783          	lw	a5,-326(a5) # 80070998 <netconf>
    80007ae6:	02f92423          	sw	a5,40(s2)
        binding->ip_addr = netconf.ip_addr;
    80007aea:	00f51023          	sh	a5,0(a0)
    80007aee:	bde5                	j	800079e6 <bind+0xa8>
    default:
      break;
  }

  return 0;
    80007af0:	4981                	li	s3,0
    80007af2:	74a2                	ld	s1,40(sp)
    80007af4:	7902                	ld	s2,32(sp)
    80007af6:	6a42                	ld	s4,16(sp)
    80007af8:	6aa2                	ld	s5,8(sp)
    80007afa:	6b02                	ld	s6,0(sp)
}
    80007afc:	854e                	mv	a0,s3
    80007afe:	70e2                	ld	ra,56(sp)
    80007b00:	7442                	ld	s0,48(sp)
    80007b02:	69e2                	ld	s3,24(sp)
    80007b04:	6121                	addi	sp,sp,64
    80007b06:	8082                	ret

0000000080007b08 <listen>:

int
listen(int socket, int backlog)
{
    80007b08:	1141                	addi	sp,sp,-16
    80007b0a:	e406                	sd	ra,8(sp)
    80007b0c:	e022                	sd	s0,0(sp)
    80007b0e:	0800                	addi	s0,sp,16
  struct socket *sock = tcp_sock_list->socks[socket];
    80007b10:	00006797          	auipc	a5,0x6
    80007b14:	7987b783          	ld	a5,1944(a5) # 8000e2a8 <tcp_sock_list>
    80007b18:	639c                	ld	a5,0(a5)
    80007b1a:	050e                	slli	a0,a0,0x3
    80007b1c:	97aa                	add	a5,a5,a0
    80007b1e:	639c                	ld	a5,0(a5)
  if (sock->type != SOCK_STREAM)  {
    80007b20:	5fd4                	lw	a3,60(a5)
    80007b22:	4705                	li	a4,1
    80007b24:	00e69f63          	bne	a3,a4,80007b42 <listen+0x3a>
    printf("listen: cannot listen from a UDP socket\n");
    return -1;
  } else if (!(sock->state == BOUND)) {
    80007b28:	43f4                	lw	a3,68(a5)
    80007b2a:	03300713          	li	a4,51
    80007b2e:	02e69463          	bne	a3,a4,80007b56 <listen+0x4e>
    printf("listen: socket is not bound\n");
    return -1;
  } 

  sock->state = LISTENING;
    80007b32:	03400713          	li	a4,52
    80007b36:	c3f8                	sw	a4,68(a5)

  return 0;
    80007b38:	4501                	li	a0,0
}
    80007b3a:	60a2                	ld	ra,8(sp)
    80007b3c:	6402                	ld	s0,0(sp)
    80007b3e:	0141                	addi	sp,sp,16
    80007b40:	8082                	ret
    printf("listen: cannot listen from a UDP socket\n");
    80007b42:	00003517          	auipc	a0,0x3
    80007b46:	f6650513          	addi	a0,a0,-154 # 8000aaa8 <etext+0xaa8>
    80007b4a:	ffff9097          	auipc	ra,0xffff9
    80007b4e:	a5e080e7          	jalr	-1442(ra) # 800005a8 <printf>
    return -1;
    80007b52:	557d                	li	a0,-1
    80007b54:	b7dd                	j	80007b3a <listen+0x32>
    printf("listen: socket is not bound\n");
    80007b56:	00003517          	auipc	a0,0x3
    80007b5a:	f8250513          	addi	a0,a0,-126 # 8000aad8 <etext+0xad8>
    80007b5e:	ffff9097          	auipc	ra,0xffff9
    80007b62:	a4a080e7          	jalr	-1462(ra) # 800005a8 <printf>
    return -1;
    80007b66:	557d                	li	a0,-1
    80007b68:	bfc9                	j	80007b3a <listen+0x32>

0000000080007b6a <accept>:

int
accept(int socket, struct sockaddr *address, socklen_t address_len)
{
    80007b6a:	7179                	addi	sp,sp,-48
    80007b6c:	f406                	sd	ra,40(sp)
    80007b6e:	f022                	sd	s0,32(sp)
    80007b70:	ec26                	sd	s1,24(sp)
    80007b72:	1800                	addi	s0,sp,48
  struct sockaddr_in *sockaddr = (struct sockaddr_in *)address;
  struct socket *sock = tcp_sock_list->socks[socket];
    80007b74:	00006797          	auipc	a5,0x6
    80007b78:	7347b783          	ld	a5,1844(a5) # 8000e2a8 <tcp_sock_list>
    80007b7c:	639c                	ld	a5,0(a5)
    80007b7e:	050e                	slli	a0,a0,0x3
    80007b80:	97aa                	add	a5,a5,a0
    80007b82:	6384                	ld	s1,0(a5)

  if (sock->protocol != IPPROTO_TCP || sock->type != SOCK_STREAM) {
    80007b84:	5c98                	lw	a4,56(s1)
    80007b86:	47c1                	li	a5,16
    80007b88:	06f71963          	bne	a4,a5,80007bfa <accept+0x90>
    80007b8c:	5cd8                	lw	a4,60(s1)
    80007b8e:	4785                	li	a5,1
    80007b90:	06f71563          	bne	a4,a5,80007bfa <accept+0x90>
    printf("accept: improper protocol and sock_type combination\n");
    return -1;
  }

  if (sock->state != LISTENING){
    80007b94:	40f8                	lw	a4,68(s1)
    80007b96:	03400793          	li	a5,52
    80007b9a:	06f71a63          	bne	a4,a5,80007c0e <accept+0xa4>
    80007b9e:	e84a                	sd	s2,16(sp)
    80007ba0:	e44e                	sd	s3,8(sp)
    printf("accept: socket is not listening\n");
    return -1;
  }

  acquire(&sock->lock);
    80007ba2:	01048993          	addi	s3,s1,16
    80007ba6:	854e                	mv	a0,s3
    80007ba8:	ffff9097          	auipc	ra,0xffff9
    80007bac:	18c080e7          	jalr	396(ra) # 80000d34 <acquire>
  while (!sock->pending) {
    80007bb0:	0084b903          	ld	s2,8(s1)
    80007bb4:	00091c63          	bnez	s2,80007bcc <accept+0x62>
    sleep(sock, &sock->lock);
    80007bb8:	85ce                	mv	a1,s3
    80007bba:	8526                	mv	a0,s1
    80007bbc:	ffffb097          	auipc	ra,0xffffb
    80007bc0:	b78080e7          	jalr	-1160(ra) # 80002734 <sleep>
  while (!sock->pending) {
    80007bc4:	0084b903          	ld	s2,8(s1)
    80007bc8:	fe0908e3          	beqz	s2,80007bb8 <accept+0x4e>
  }
  struct socket *new_sock = sock->pending;
  new_sock->pending = 0;
    80007bcc:	00093423          	sd	zero,8(s2)
  new_sock->pending = 0;
  release(&sock->lock);
    80007bd0:	854e                	mv	a0,s3
    80007bd2:	ffff9097          	auipc	ra,0xffff9
    80007bd6:	212080e7          	jalr	530(ra) # 80000de4 <release>

  new_sock->f = filealloc();
    80007bda:	ffffd097          	auipc	ra,0xffffd
    80007bde:	4ae080e7          	jalr	1198(ra) # 80005088 <filealloc>
    80007be2:	00a93023          	sd	a0,0(s2)
  if (new_sock->f == 0) {
    80007be6:	cd15                	beqz	a0,80007c22 <accept+0xb8>
    printf("accept: failed to allocate a file\n");
    return -1;
  }

  return new_sock->fd;
    80007be8:	04892503          	lw	a0,72(s2)
    80007bec:	6942                	ld	s2,16(sp)
    80007bee:	69a2                	ld	s3,8(sp)
}
    80007bf0:	70a2                	ld	ra,40(sp)
    80007bf2:	7402                	ld	s0,32(sp)
    80007bf4:	64e2                	ld	s1,24(sp)
    80007bf6:	6145                	addi	sp,sp,48
    80007bf8:	8082                	ret
    printf("accept: improper protocol and sock_type combination\n");
    80007bfa:	00003517          	auipc	a0,0x3
    80007bfe:	efe50513          	addi	a0,a0,-258 # 8000aaf8 <etext+0xaf8>
    80007c02:	ffff9097          	auipc	ra,0xffff9
    80007c06:	9a6080e7          	jalr	-1626(ra) # 800005a8 <printf>
    return -1;
    80007c0a:	557d                	li	a0,-1
    80007c0c:	b7d5                	j	80007bf0 <accept+0x86>
    printf("accept: socket is not listening\n");
    80007c0e:	00003517          	auipc	a0,0x3
    80007c12:	f2250513          	addi	a0,a0,-222 # 8000ab30 <etext+0xb30>
    80007c16:	ffff9097          	auipc	ra,0xffff9
    80007c1a:	992080e7          	jalr	-1646(ra) # 800005a8 <printf>
    return -1;
    80007c1e:	557d                	li	a0,-1
    80007c20:	bfc1                	j	80007bf0 <accept+0x86>
    printf("accept: failed to allocate a file\n");
    80007c22:	00003517          	auipc	a0,0x3
    80007c26:	f3650513          	addi	a0,a0,-202 # 8000ab58 <etext+0xb58>
    80007c2a:	ffff9097          	auipc	ra,0xffff9
    80007c2e:	97e080e7          	jalr	-1666(ra) # 800005a8 <printf>
    return -1;
    80007c32:	557d                	li	a0,-1
    80007c34:	6942                	ld	s2,16(sp)
    80007c36:	69a2                	ld	s3,8(sp)
    80007c38:	bf65                	j	80007bf0 <accept+0x86>

0000000080007c3a <connect>:

int
connect(int socket, const struct sockaddr *address, socklen_t address_len)
{
    80007c3a:	1141                	addi	sp,sp,-16
    80007c3c:	e406                	sd	ra,8(sp)
    80007c3e:	e022                	sd	s0,0(sp)
    80007c40:	0800                	addi	s0,sp,16
  return 0;
}
    80007c42:	4501                	li	a0,0
    80007c44:	60a2                	ld	ra,8(sp)
    80007c46:	6402                	ld	s0,0(sp)
    80007c48:	0141                	addi	sp,sp,16
    80007c4a:	8082                	ret

0000000080007c4c <tcp_socket_list_remove>:

int tcp_socket_list_remove(int fd) {
  if (tcp_sock_list->socks[fd] == 0) {
    80007c4c:	050e                	slli	a0,a0,0x3
    80007c4e:	00006797          	auipc	a5,0x6
    80007c52:	65a7b783          	ld	a5,1626(a5) # 8000e2a8 <tcp_sock_list>
    80007c56:	639c                	ld	a5,0(a5)
    80007c58:	97aa                	add	a5,a5,a0
    80007c5a:	6398                	ld	a4,0(a5)
    80007c5c:	cf01                	beqz	a4,80007c74 <tcp_socket_list_remove+0x28>
    printf("socket to remove does not exist\n");
    return -1;
  } else {
    tcp_sock_list->socks[fd] = 0;
    80007c5e:	0007b023          	sd	zero,0(a5)
    tcp_sock_list->size--;
    80007c62:	00006717          	auipc	a4,0x6
    80007c66:	64673703          	ld	a4,1606(a4) # 8000e2a8 <tcp_sock_list>
    80007c6a:	471c                	lw	a5,8(a4)
    80007c6c:	37fd                	addiw	a5,a5,-1
    80007c6e:	c71c                	sw	a5,8(a4)
    return 1;
    80007c70:	4505                	li	a0,1
  }
}
    80007c72:	8082                	ret
int tcp_socket_list_remove(int fd) {
    80007c74:	1141                	addi	sp,sp,-16
    80007c76:	e406                	sd	ra,8(sp)
    80007c78:	e022                	sd	s0,0(sp)
    80007c7a:	0800                	addi	s0,sp,16
    printf("socket to remove does not exist\n");
    80007c7c:	00003517          	auipc	a0,0x3
    80007c80:	f0450513          	addi	a0,a0,-252 # 8000ab80 <etext+0xb80>
    80007c84:	ffff9097          	auipc	ra,0xffff9
    80007c88:	924080e7          	jalr	-1756(ra) # 800005a8 <printf>
    return -1;
    80007c8c:	557d                	li	a0,-1
}
    80007c8e:	60a2                	ld	ra,8(sp)
    80007c90:	6402                	ld	s0,0(sp)
    80007c92:	0141                	addi	sp,sp,16
    80007c94:	8082                	ret

0000000080007c96 <socket>:

int 
socket(int sock_family, int sock_type, int protocol)
{
    80007c96:	7139                	addi	sp,sp,-64
    80007c98:	fc06                	sd	ra,56(sp)
    80007c9a:	f822                	sd	s0,48(sp)
    80007c9c:	e852                	sd	s4,16(sp)
    80007c9e:	0080                	addi	s0,sp,64
  if (sock_family != AF_INET)  {
    80007ca0:	e53d                	bnez	a0,80007d0e <socket+0x78>
    80007ca2:	f426                	sd	s1,40(sp)
    80007ca4:	f04a                	sd	s2,32(sp)
    80007ca6:	892e                	mv	s2,a1
    80007ca8:	84b2                	mv	s1,a2
    printf("socket: invalid sock_family\n");
    return -1;
  }

  if (sock_type != SOCK_STREAM && sock_type != SOCK_DGRAM) {
    80007caa:	fff5879b          	addiw	a5,a1,-1
    80007cae:	4705                	li	a4,1
    80007cb0:	06f76963          	bltu	a4,a5,80007d22 <socket+0x8c>
    printf("socket: invalid sock_type\n");
    return -1;
  }

  if (protocol == 0) {
    80007cb4:	e259                	bnez	a2,80007d3a <socket+0xa4>
    if (sock_type == SOCK_STREAM)
    80007cb6:	4785                	li	a5,1
      protocol = IPPROTO_TCP;
    else if (sock_type == SOCK_DGRAM)
      protocol = IPPROTO_UDP;
    80007cb8:	44c5                	li	s1,17
    if (sock_type == SOCK_STREAM)
    80007cba:	0cf58363          	beq	a1,a5,80007d80 <socket+0xea>
    printf("socket: invalid protocol\n");
    return -1;
  }

  if ((protocol == IPPROTO_TCP && sock_type != SOCK_STREAM) ||
      (protocol == IPPROTO_UDP && sock_type != SOCK_DGRAM)) {
    80007cbe:	fef48793          	addi	a5,s1,-17
  if ((protocol == IPPROTO_TCP && sock_type != SOCK_STREAM) ||
    80007cc2:	e781                	bnez	a5,80007cca <socket+0x34>
      (protocol == IPPROTO_UDP && sock_type != SOCK_DGRAM)) {
    80007cc4:	ffe90793          	addi	a5,s2,-2
  if ((protocol == IPPROTO_TCP && sock_type != SOCK_STREAM) ||
    80007cc8:	e7c1                	bnez	a5,80007d50 <socket+0xba>
    printf("socket: invalid protocol-socktype combination\n");
    return -1;
  }

  struct socket *sock;
  int fd = sockalloc(&sock);
    80007cca:	fc840513          	addi	a0,s0,-56
    80007cce:	00000097          	auipc	ra,0x0
    80007cd2:	bf6080e7          	jalr	-1034(ra) # 800078c4 <sockalloc>
    80007cd6:	8a2a                	mv	s4,a0
  if (fd == -1) {
    80007cd8:	57fd                	li	a5,-1
    80007cda:	0af50563          	beq	a0,a5,80007d84 <socket+0xee>
    80007cde:	ec4e                	sd	s3,24(sp)
    printf("socket: sockalloc failed\n");
    return -1;
  }

  sock->f = filealloc();
    80007ce0:	fc843983          	ld	s3,-56(s0)
    80007ce4:	ffffd097          	auipc	ra,0xffffd
    80007ce8:	3a4080e7          	jalr	932(ra) # 80005088 <filealloc>
    80007cec:	00a9b023          	sd	a0,0(s3)
  if (sock->f == 0) {
    80007cf0:	c54d                	beqz	a0,80007d9a <socket+0x104>
    return -1;
  }

  // TODO: Write the methods for sock_read and sock_write, set the fields of file to those methods

  switch(protocol){
    80007cf2:	47c1                	li	a5,16
    80007cf4:	0cf48063          	beq	s1,a5,80007db4 <socket+0x11e>
    case(IPPROTO_TCP):
      tcp_sock_list->socks[fd] = sock;
      break;
    case(IPPROTO_UDP):
      udp_sock_list->socks[fd] = sock;
    80007cf8:	00006797          	auipc	a5,0x6
    80007cfc:	5a87b783          	ld	a5,1448(a5) # 8000e2a0 <udp_sock_list>
    80007d00:	639c                	ld	a5,0(a5)
    80007d02:	003a1713          	slli	a4,s4,0x3
    80007d06:	97ba                	add	a5,a5,a4
    80007d08:	0137b023          	sd	s3,0(a5)
      break;
    80007d0c:	a875                	j	80007dc8 <socket+0x132>
    printf("socket: invalid sock_family\n");
    80007d0e:	00003517          	auipc	a0,0x3
    80007d12:	e9a50513          	addi	a0,a0,-358 # 8000aba8 <etext+0xba8>
    80007d16:	ffff9097          	auipc	ra,0xffff9
    80007d1a:	892080e7          	jalr	-1902(ra) # 800005a8 <printf>
    return -1;
    80007d1e:	5a7d                	li	s4,-1
    80007d20:	a0f9                	j	80007dee <socket+0x158>
    printf("socket: invalid sock_type\n");
    80007d22:	00003517          	auipc	a0,0x3
    80007d26:	ea650513          	addi	a0,a0,-346 # 8000abc8 <etext+0xbc8>
    80007d2a:	ffff9097          	auipc	ra,0xffff9
    80007d2e:	87e080e7          	jalr	-1922(ra) # 800005a8 <printf>
    return -1;
    80007d32:	5a7d                	li	s4,-1
    80007d34:	74a2                	ld	s1,40(sp)
    80007d36:	7902                	ld	s2,32(sp)
    80007d38:	a85d                	j	80007dee <socket+0x158>
  if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP) {
    80007d3a:	ff06079b          	addiw	a5,a2,-16 # ff0 <_entry-0x7ffff010>
    80007d3e:	4705                	li	a4,1
    80007d40:	02f76463          	bltu	a4,a5,80007d68 <socket+0xd2>
  if ((protocol == IPPROTO_TCP && sock_type != SOCK_STREAM) ||
    80007d44:	ff060793          	addi	a5,a2,-16
    80007d48:	fbbd                	bnez	a5,80007cbe <socket+0x28>
    80007d4a:	fff58793          	addi	a5,a1,-1
    80007d4e:	dba5                	beqz	a5,80007cbe <socket+0x28>
    printf("socket: invalid protocol-socktype combination\n");
    80007d50:	00003517          	auipc	a0,0x3
    80007d54:	eb850513          	addi	a0,a0,-328 # 8000ac08 <etext+0xc08>
    80007d58:	ffff9097          	auipc	ra,0xffff9
    80007d5c:	850080e7          	jalr	-1968(ra) # 800005a8 <printf>
    return -1;
    80007d60:	5a7d                	li	s4,-1
    80007d62:	74a2                	ld	s1,40(sp)
    80007d64:	7902                	ld	s2,32(sp)
    80007d66:	a061                	j	80007dee <socket+0x158>
    printf("socket: invalid protocol\n");
    80007d68:	00003517          	auipc	a0,0x3
    80007d6c:	e8050513          	addi	a0,a0,-384 # 8000abe8 <etext+0xbe8>
    80007d70:	ffff9097          	auipc	ra,0xffff9
    80007d74:	838080e7          	jalr	-1992(ra) # 800005a8 <printf>
    return -1;
    80007d78:	5a7d                	li	s4,-1
    80007d7a:	74a2                	ld	s1,40(sp)
    80007d7c:	7902                	ld	s2,32(sp)
    80007d7e:	a885                	j	80007dee <socket+0x158>
      protocol = IPPROTO_TCP;
    80007d80:	44c1                	li	s1,16
    80007d82:	b7a1                	j	80007cca <socket+0x34>
    printf("socket: sockalloc failed\n");
    80007d84:	00003517          	auipc	a0,0x3
    80007d88:	eb450513          	addi	a0,a0,-332 # 8000ac38 <etext+0xc38>
    80007d8c:	ffff9097          	auipc	ra,0xffff9
    80007d90:	81c080e7          	jalr	-2020(ra) # 800005a8 <printf>
    return -1;
    80007d94:	74a2                	ld	s1,40(sp)
    80007d96:	7902                	ld	s2,32(sp)
    80007d98:	a899                	j	80007dee <socket+0x158>
    printf("ERROR: filealloc\n");
    80007d9a:	00003517          	auipc	a0,0x3
    80007d9e:	ebe50513          	addi	a0,a0,-322 # 8000ac58 <etext+0xc58>
    80007da2:	ffff9097          	auipc	ra,0xffff9
    80007da6:	806080e7          	jalr	-2042(ra) # 800005a8 <printf>
    return -1;
    80007daa:	5a7d                	li	s4,-1
    80007dac:	74a2                	ld	s1,40(sp)
    80007dae:	7902                	ld	s2,32(sp)
    80007db0:	69e2                	ld	s3,24(sp)
    80007db2:	a835                	j	80007dee <socket+0x158>
      tcp_sock_list->socks[fd] = sock;
    80007db4:	00006797          	auipc	a5,0x6
    80007db8:	4f47b783          	ld	a5,1268(a5) # 8000e2a8 <tcp_sock_list>
    80007dbc:	639c                	ld	a5,0(a5)
    80007dbe:	003a1713          	slli	a4,s4,0x3
    80007dc2:	97ba                	add	a5,a5,a4
    80007dc4:	0137b023          	sd	s3,0(a5)
        printf("socket: failed to remove sock from tcp_socklist\n");
      kfree(sock);
      return -1;
  }

  sock->protocol = protocol;
    80007dc8:	0299ac23          	sw	s1,56(s3)
  sock->src_ip = netconf.ip_addr;
    80007dcc:	00069797          	auipc	a5,0x69
    80007dd0:	bcc7a783          	lw	a5,-1076(a5) # 80070998 <netconf>
    80007dd4:	02f9a423          	sw	a5,40(s3)
  sock->type = sock_type;
    80007dd8:	0329ae23          	sw	s2,60(s3)
  sock->family = sock_family;
    80007ddc:	0409a023          	sw	zero,64(s3)
  sock->state = CLOSED;
    80007de0:	03200793          	li	a5,50
    80007de4:	04f9a223          	sw	a5,68(s3)
    80007de8:	74a2                	ld	s1,40(sp)
    80007dea:	7902                	ld	s2,32(sp)
    80007dec:	69e2                	ld	s3,24(sp)

  return fd;
}
    80007dee:	8552                	mv	a0,s4
    80007df0:	70e2                	ld	ra,56(sp)
    80007df2:	7442                	ld	s0,48(sp)
    80007df4:	6a42                	ld	s4,16(sp)
    80007df6:	6121                	addi	sp,sp,64
    80007df8:	8082                	ret

0000000080007dfa <close>:

int 
close()
{
    80007dfa:	1141                	addi	sp,sp,-16
    80007dfc:	e406                	sd	ra,8(sp)
    80007dfe:	e022                	sd	s0,0(sp)
    80007e00:	0800                	addi	s0,sp,16
  return 0;
}
    80007e02:	4501                	li	a0,0
    80007e04:	60a2                	ld	ra,8(sp)
    80007e06:	6402                	ld	s0,0(sp)
    80007e08:	0141                	addi	sp,sp,16
    80007e0a:	8082                	ret

0000000080007e0c <tcp_sock_list_init>:

void tcp_sock_list_init() {
    80007e0c:	1101                	addi	sp,sp,-32
    80007e0e:	ec06                	sd	ra,24(sp)
    80007e10:	e822                	sd	s0,16(sp)
    80007e12:	1000                	addi	s0,sp,32
  tcp_sock_list = (struct socket_list *)kalloc();
    80007e14:	ffff9097          	auipc	ra,0xffff9
    80007e18:	dfe080e7          	jalr	-514(ra) # 80000c12 <kalloc>
    80007e1c:	00006797          	auipc	a5,0x6
    80007e20:	48a7b623          	sd	a0,1164(a5) # 8000e2a8 <tcp_sock_list>
  if (!tcp_sock_list) {
    80007e24:	c90d                	beqz	a0,80007e56 <tcp_sock_list_init+0x4a>
    80007e26:	e426                	sd	s1,8(sp)
    80007e28:	84aa                	mv	s1,a0
    printf("ERROR: failed to allocate tcp_sock_list\n");
    return;
  }

  tcp_sock_list->socks = (struct socket **)kalloc();
    80007e2a:	ffff9097          	auipc	ra,0xffff9
    80007e2e:	de8080e7          	jalr	-536(ra) # 80000c12 <kalloc>
    80007e32:	e088                	sd	a0,0(s1)
  if (!tcp_sock_list->socks) {
    80007e34:	00006797          	auipc	a5,0x6
    80007e38:	4747b783          	ld	a5,1140(a5) # 8000e2a8 <tcp_sock_list>
    80007e3c:	6388                	ld	a0,0(a5)
    80007e3e:	c50d                	beqz	a0,80007e68 <tcp_sock_list_init+0x5c>
    printf("ERROR: failed to allocate tcp_sock_list->socks\n");
    kfree(tcp_sock_list);
    return;
  }
  memset(tcp_sock_list->socks, 0, PGSIZE);
    80007e40:	6605                	lui	a2,0x1
    80007e42:	4581                	li	a1,0
    80007e44:	ffff9097          	auipc	ra,0xffff9
    80007e48:	fe8080e7          	jalr	-24(ra) # 80000e2c <memset>
    80007e4c:	64a2                	ld	s1,8(sp)
}
    80007e4e:	60e2                	ld	ra,24(sp)
    80007e50:	6442                	ld	s0,16(sp)
    80007e52:	6105                	addi	sp,sp,32
    80007e54:	8082                	ret
    printf("ERROR: failed to allocate tcp_sock_list\n");
    80007e56:	00003517          	auipc	a0,0x3
    80007e5a:	e1a50513          	addi	a0,a0,-486 # 8000ac70 <etext+0xc70>
    80007e5e:	ffff8097          	auipc	ra,0xffff8
    80007e62:	74a080e7          	jalr	1866(ra) # 800005a8 <printf>
    return;
    80007e66:	b7e5                	j	80007e4e <tcp_sock_list_init+0x42>
    printf("ERROR: failed to allocate tcp_sock_list->socks\n");
    80007e68:	00003517          	auipc	a0,0x3
    80007e6c:	e3850513          	addi	a0,a0,-456 # 8000aca0 <etext+0xca0>
    80007e70:	ffff8097          	auipc	ra,0xffff8
    80007e74:	738080e7          	jalr	1848(ra) # 800005a8 <printf>
    kfree(tcp_sock_list);
    80007e78:	00006517          	auipc	a0,0x6
    80007e7c:	43053503          	ld	a0,1072(a0) # 8000e2a8 <tcp_sock_list>
    80007e80:	ffff9097          	auipc	ra,0xffff9
    80007e84:	c24080e7          	jalr	-988(ra) # 80000aa4 <kfree>
    return;
    80007e88:	64a2                	ld	s1,8(sp)
    80007e8a:	b7d1                	j	80007e4e <tcp_sock_list_init+0x42>

0000000080007e8c <udp_sock_list_init>:

void udp_sock_list_init() {
    80007e8c:	1101                	addi	sp,sp,-32
    80007e8e:	ec06                	sd	ra,24(sp)
    80007e90:	e822                	sd	s0,16(sp)
    80007e92:	1000                	addi	s0,sp,32
  udp_sock_list = (struct socket_list *)kalloc();
    80007e94:	ffff9097          	auipc	ra,0xffff9
    80007e98:	d7e080e7          	jalr	-642(ra) # 80000c12 <kalloc>
    80007e9c:	00006797          	auipc	a5,0x6
    80007ea0:	40a7b223          	sd	a0,1028(a5) # 8000e2a0 <udp_sock_list>
  if (!udp_sock_list) {
    80007ea4:	c90d                	beqz	a0,80007ed6 <udp_sock_list_init+0x4a>
    80007ea6:	e426                	sd	s1,8(sp)
    80007ea8:	84aa                	mv	s1,a0
    printf("ERROR: failed to allocate udp_sock_list\n");
    return;
  }

  udp_sock_list->socks = (struct socket **)kalloc();
    80007eaa:	ffff9097          	auipc	ra,0xffff9
    80007eae:	d68080e7          	jalr	-664(ra) # 80000c12 <kalloc>
    80007eb2:	e088                	sd	a0,0(s1)
  if (!udp_sock_list->socks) {
    80007eb4:	00006797          	auipc	a5,0x6
    80007eb8:	3ec7b783          	ld	a5,1004(a5) # 8000e2a0 <udp_sock_list>
    80007ebc:	6388                	ld	a0,0(a5)
    80007ebe:	c50d                	beqz	a0,80007ee8 <udp_sock_list_init+0x5c>
    printf("ERROR: failed to allocate udp_sock_list->socks\n");
    kfree(udp_sock_list);
    return;
  }
  memset(udp_sock_list->socks, 0, PGSIZE);
    80007ec0:	6605                	lui	a2,0x1
    80007ec2:	4581                	li	a1,0
    80007ec4:	ffff9097          	auipc	ra,0xffff9
    80007ec8:	f68080e7          	jalr	-152(ra) # 80000e2c <memset>
    80007ecc:	64a2                	ld	s1,8(sp)
}
    80007ece:	60e2                	ld	ra,24(sp)
    80007ed0:	6442                	ld	s0,16(sp)
    80007ed2:	6105                	addi	sp,sp,32
    80007ed4:	8082                	ret
    printf("ERROR: failed to allocate udp_sock_list\n");
    80007ed6:	00003517          	auipc	a0,0x3
    80007eda:	dfa50513          	addi	a0,a0,-518 # 8000acd0 <etext+0xcd0>
    80007ede:	ffff8097          	auipc	ra,0xffff8
    80007ee2:	6ca080e7          	jalr	1738(ra) # 800005a8 <printf>
    return;
    80007ee6:	b7e5                	j	80007ece <udp_sock_list_init+0x42>
    printf("ERROR: failed to allocate udp_sock_list->socks\n");
    80007ee8:	00003517          	auipc	a0,0x3
    80007eec:	e1850513          	addi	a0,a0,-488 # 8000ad00 <etext+0xd00>
    80007ef0:	ffff8097          	auipc	ra,0xffff8
    80007ef4:	6b8080e7          	jalr	1720(ra) # 800005a8 <printf>
    kfree(udp_sock_list);
    80007ef8:	00006517          	auipc	a0,0x6
    80007efc:	3a853503          	ld	a0,936(a0) # 8000e2a0 <udp_sock_list>
    80007f00:	ffff9097          	auipc	ra,0xffff9
    80007f04:	ba4080e7          	jalr	-1116(ra) # 80000aa4 <kfree>
    return;
    80007f08:	64a2                	ld	s1,8(sp)
    80007f0a:	b7d1                	j	80007ece <udp_sock_list_init+0x42>

0000000080007f0c <socket_init>:

void socket_init() {
    80007f0c:	1141                	addi	sp,sp,-16
    80007f0e:	e406                	sd	ra,8(sp)
    80007f10:	e022                	sd	s0,0(sp)
    80007f12:	0800                	addi	s0,sp,16
  tcp_sock_list_init();
    80007f14:	00000097          	auipc	ra,0x0
    80007f18:	ef8080e7          	jalr	-264(ra) # 80007e0c <tcp_sock_list_init>
  udp_sock_list_init();
    80007f1c:	00000097          	auipc	ra,0x0
    80007f20:	f70080e7          	jalr	-144(ra) # 80007e8c <udp_sock_list_init>
}
    80007f24:	60a2                	ld	ra,8(sp)
    80007f26:	6402                	ld	s0,0(sp)
    80007f28:	0141                	addi	sp,sp,16
    80007f2a:	8082                	ret

0000000080007f2c <my_strlen>:

extern struct virtio_net net;

const int temp_ip = 0xC0A80002;

int my_strlen(char *string) {
    80007f2c:	1141                	addi	sp,sp,-16
    80007f2e:	e406                	sd	ra,8(sp)
    80007f30:	e022                	sd	s0,0(sp)
    80007f32:	0800                	addi	s0,sp,16
  for (int i = 0; ; i++) {
    if (string[i] == '\0')
    80007f34:	00054703          	lbu	a4,0(a0)
    80007f38:	00150793          	addi	a5,a0,1
    80007f3c:	cf01                	beqz	a4,80007f54 <my_strlen+0x28>
    80007f3e:	86be                	mv	a3,a5
    80007f40:	0785                	addi	a5,a5,1
    80007f42:	fff7c703          	lbu	a4,-1(a5)
    80007f46:	ff65                	bnez	a4,80007f3e <my_strlen+0x12>
  for (int i = 0; ; i++) {
    80007f48:	40a6853b          	subw	a0,a3,a0
      return i;
  }
}
    80007f4c:	60a2                	ld	ra,8(sp)
    80007f4e:	6402                	ld	s0,0(sp)
    80007f50:	0141                	addi	sp,sp,16
    80007f52:	8082                	ret
  for (int i = 0; ; i++) {
    80007f54:	4501                	li	a0,0
    80007f56:	bfdd                	j	80007f4c <my_strlen+0x20>

0000000080007f58 <getaddrinfo>:

int 
getaddrinfo(char *node, char *port, const struct addrinfo *hints,
                struct addrinfo *result)
{
    80007f58:	1141                	addi	sp,sp,-16
    80007f5a:	e406                	sd	ra,8(sp)
    80007f5c:	e022                	sd	s0,0(sp)
    80007f5e:	0800                	addi	s0,sp,16
  return 0;
}
    80007f60:	4501                	li	a0,0
    80007f62:	60a2                	ld	ra,8(sp)
    80007f64:	6402                	ld	s0,0(sp)
    80007f66:	0141                	addi	sp,sp,16
    80007f68:	8082                	ret

0000000080007f6a <freeaddrinfo>:

int 
freeaddrinfo(struct addrinfo *res)
{
    80007f6a:	1141                	addi	sp,sp,-16
    80007f6c:	e406                	sd	ra,8(sp)
    80007f6e:	e022                	sd	s0,0(sp)
    80007f70:	0800                	addi	s0,sp,16
  return 0;
}
    80007f72:	4501                	li	a0,0
    80007f74:	60a2                	ld	ra,8(sp)
    80007f76:	6402                	ld	s0,0(sp)
    80007f78:	0141                	addi	sp,sp,16
    80007f7a:	8082                	ret

0000000080007f7c <ip_to_u32>:

int ip_to_u32(const char *ip) {
    80007f7c:	1101                	addi	sp,sp,-32
    80007f7e:	ec06                	sd	ra,24(sp)
    80007f80:	e822                	sd	s0,16(sp)
    80007f82:	1000                	addi	s0,sp,32
  int parts[4] = {0};
    80007f84:	fe043023          	sd	zero,-32(s0)
    80007f88:	fe043423          	sd	zero,-24(s0)
  int i = 0;

  // Parse the dotted decimal parts
  while (*ip && i < 4) {
    80007f8c:	00054783          	lbu	a5,0(a0)
    80007f90:	c3dd                	beqz	a5,80008036 <ip_to_u32+0xba>
    80007f92:	fe040593          	addi	a1,s0,-32
  int i = 0;
    80007f96:	4801                	li	a6,0
    int num = 0;
    while (*ip >= '0' && *ip <= '9') {
    80007f98:	4625                	li	a2,9
      num = num * 10 + (*ip - '0');
      ip++;
    }
    if (num < 0 || num > 255)
    80007f9a:	0ff00313          	li	t1,255
      return 0xFFFFFFFF;  // invalid
    parts[i++] = num;

    if (*ip == '.')
    80007f9e:	02e00893          	li	a7,46
    80007fa2:	a809                	j	80007fb4 <ip_to_u32+0x38>
      ip++;
    80007fa4:	0505                	addi	a0,a0,1
  while (*ip && i < 4) {
    80007fa6:	0591                	addi	a1,a1,4
    80007fa8:	00054703          	lbu	a4,0(a0)
    80007fac:	cf29                	beqz	a4,80008006 <ip_to_u32+0x8a>
    80007fae:	0047a793          	slti	a5,a5,4
    80007fb2:	cbb1                	beqz	a5,80008006 <ip_to_u32+0x8a>
    while (*ip >= '0' && *ip <= '9') {
    80007fb4:	00054703          	lbu	a4,0(a0)
    80007fb8:	fd07079b          	addiw	a5,a4,-48
    80007fbc:	0ff7f793          	zext.b	a5,a5
    int num = 0;
    80007fc0:	4681                	li	a3,0
    while (*ip >= '0' && *ip <= '9') {
    80007fc2:	02f66663          	bltu	a2,a5,80007fee <ip_to_u32+0x72>
      num = num * 10 + (*ip - '0');
    80007fc6:	0026979b          	slliw	a5,a3,0x2
    80007fca:	9fb5                	addw	a5,a5,a3
    80007fcc:	0017979b          	slliw	a5,a5,0x1
    80007fd0:	fd07071b          	addiw	a4,a4,-48
    80007fd4:	00f706bb          	addw	a3,a4,a5
      ip++;
    80007fd8:	0505                	addi	a0,a0,1
    while (*ip >= '0' && *ip <= '9') {
    80007fda:	00054703          	lbu	a4,0(a0)
    80007fde:	fd07079b          	addiw	a5,a4,-48
    80007fe2:	0ff7f793          	zext.b	a5,a5
    80007fe6:	fef670e3          	bgeu	a2,a5,80007fc6 <ip_to_u32+0x4a>
    if (num < 0 || num > 255)
    80007fea:	04d36863          	bltu	t1,a3,8000803a <ip_to_u32+0xbe>
    parts[i++] = num;
    80007fee:	0018079b          	addiw	a5,a6,1
    80007ff2:	883e                	mv	a6,a5
    80007ff4:	c194                	sw	a3,0(a1)
    if (*ip == '.')
    80007ff6:	fb1707e3          	beq	a4,a7,80007fa4 <ip_to_u32+0x28>
    else if (*ip && i < 4)
    80007ffa:	0047a693          	slti	a3,a5,4
    80007ffe:	d6c5                	beqz	a3,80007fa6 <ip_to_u32+0x2a>
    80008000:	d35d                	beqz	a4,80007fa6 <ip_to_u32+0x2a>
      return 0xFFFFFFFF;  // invalid format
    80008002:	557d                	li	a0,-1
    80008004:	a02d                	j	8000802e <ip_to_u32+0xb2>
  }

  if (i != 4)
    80008006:	4791                	li	a5,4
    80008008:	02f81b63          	bne	a6,a5,8000803e <ip_to_u32+0xc2>
    return 0xFFFFFFFF;

  // Convert to big-endian 32-bit representation
  return (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | (parts[3]);
    8000800c:	fe042783          	lw	a5,-32(s0)
    80008010:	0187979b          	slliw	a5,a5,0x18
    80008014:	fe442703          	lw	a4,-28(s0)
    80008018:	0107171b          	slliw	a4,a4,0x10
    8000801c:	8fd9                	or	a5,a5,a4
    8000801e:	fec42703          	lw	a4,-20(s0)
    80008022:	8fd9                	or	a5,a5,a4
    80008024:	fe842503          	lw	a0,-24(s0)
    80008028:	0085151b          	slliw	a0,a0,0x8
    8000802c:	8d5d                	or	a0,a0,a5
}
    8000802e:	60e2                	ld	ra,24(sp)
    80008030:	6442                	ld	s0,16(sp)
    80008032:	6105                	addi	sp,sp,32
    80008034:	8082                	ret
    return 0xFFFFFFFF;
    80008036:	557d                	li	a0,-1
    80008038:	bfdd                	j	8000802e <ip_to_u32+0xb2>
      return 0xFFFFFFFF;  // invalid
    8000803a:	557d                	li	a0,-1
    8000803c:	bfcd                	j	8000802e <ip_to_u32+0xb2>
    return 0xFFFFFFFF;
    8000803e:	557d                	li	a0,-1
    80008040:	b7fd                	j	8000802e <ip_to_u32+0xb2>

0000000080008042 <node_to_dns>:

int
node_to_dns(char *name, char *res)
{
    80008042:	1101                	addi	sp,sp,-32
    80008044:	ec06                	sd	ra,24(sp)
    80008046:	e822                	sd	s0,16(sp)
    80008048:	e426                	sd	s1,8(sp)
    8000804a:	e04a                	sd	s2,0(sp)
    8000804c:	1000                	addi	s0,sp,32
    8000804e:	892a                	mv	s2,a0
    80008050:	84ae                	mv	s1,a1
  int name_len = my_strlen(name);
    80008052:	00000097          	auipc	ra,0x0
    80008056:	eda080e7          	jalr	-294(ra) # 80007f2c <my_strlen>
  if (name_len > 253)
    8000805a:	0fd00793          	li	a5,253
    8000805e:	06a7c263          	blt	a5,a0,800080c2 <node_to_dns+0x80>
    return LONG_DOMAIN;

  int len_index = 0;
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    80008062:	4785                	li	a5,1
  int len_index = 0;
    80008064:	4601                	li	a2,0
    if (i - len_index == 64)
    80008066:	04000893          	li	a7,64
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    8000806a:	02055463          	bgez	a0,80008092 <node_to_dns+0x50>
      len_index = res_index;
    } else {
      res[res_index] = name[i];
    }
  }
  res[name_len + 1] = 0;
    8000806e:	94aa                	add	s1,s1,a0
    80008070:	000480a3          	sb	zero,1(s1)
  return 0;
    80008074:	4501                	li	a0,0
    80008076:	a0b9                	j	800080c4 <node_to_dns+0x82>
      res[len_index] = i - len_index;
    80008078:	00c485b3          	add	a1,s1,a2
    8000807c:	fff7871b          	addiw	a4,a5,-1
    80008080:	9f11                	subw	a4,a4,a2
    80008082:	00e58023          	sb	a4,0(a1)
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    80008086:	0007871b          	sext.w	a4,a5
    8000808a:	fee542e3          	blt	a0,a4,8000806e <node_to_dns+0x2c>
    if (i - len_index == 64)
    8000808e:	0785                	addi	a5,a5,1
      len_index = res_index;
    80008090:	8636                	mv	a2,a3
    80008092:	0007869b          	sext.w	a3,a5
    if (name[i] == '.' || name[i] == '\0') {
    80008096:	00f90733          	add	a4,s2,a5
    8000809a:	fff74703          	lbu	a4,-1(a4)
    8000809e:	fd270813          	addi	a6,a4,-46
    800080a2:	fc080be3          	beqz	a6,80008078 <node_to_dns+0x36>
    800080a6:	db69                	beqz	a4,80008078 <node_to_dns+0x36>
      res[res_index] = name[i];
    800080a8:	00f485b3          	add	a1,s1,a5
    800080ac:	00e58023          	sb	a4,0(a1)
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    800080b0:	0007871b          	sext.w	a4,a5
    800080b4:	fae54de3          	blt	a0,a4,8000806e <node_to_dns+0x2c>
    if (i - len_index == 64)
    800080b8:	9e91                	subw	a3,a3,a2
    800080ba:	01168b63          	beq	a3,a7,800080d0 <node_to_dns+0x8e>
    800080be:	0785                	addi	a5,a5,1
    800080c0:	bfc9                	j	80008092 <node_to_dns+0x50>
    return LONG_DOMAIN;
    800080c2:	4505                	li	a0,1
}
    800080c4:	60e2                	ld	ra,24(sp)
    800080c6:	6442                	ld	s0,16(sp)
    800080c8:	64a2                	ld	s1,8(sp)
    800080ca:	6902                	ld	s2,0(sp)
    800080cc:	6105                	addi	sp,sp,32
    800080ce:	8082                	ret
      return LONG_DOMAIN_SECTION;
    800080d0:	4509                	li	a0,2
    800080d2:	bfcd                	j	800080c4 <node_to_dns+0x82>

00000000800080d4 <ntohs>:

uint16
ntohs(uint16 netshort) {
    800080d4:	1141                	addi	sp,sp,-16
    800080d6:	e406                	sd	ra,8(sp)
    800080d8:	e022                	sd	s0,0(sp)
    800080da:	0800                	addi	s0,sp,16
  return (netshort >> 8) | (netshort << 8);
    800080dc:	0085579b          	srliw	a5,a0,0x8
    800080e0:	0085151b          	slliw	a0,a0,0x8
    800080e4:	9d3d                	addw	a0,a0,a5
}
    800080e6:	1542                	slli	a0,a0,0x30
    800080e8:	9141                	srli	a0,a0,0x30
    800080ea:	60a2                	ld	ra,8(sp)
    800080ec:	6402                	ld	s0,0(sp)
    800080ee:	0141                	addi	sp,sp,16
    800080f0:	8082                	ret

00000000800080f2 <htons>:

uint16
htons(uint16 hostshort) {
    800080f2:	1141                	addi	sp,sp,-16
    800080f4:	e406                	sd	ra,8(sp)
    800080f6:	e022                	sd	s0,0(sp)
    800080f8:	0800                	addi	s0,sp,16
  return (hostshort >> 8) | (hostshort << 8);
    800080fa:	0085579b          	srliw	a5,a0,0x8
    800080fe:	0085151b          	slliw	a0,a0,0x8
    80008102:	9d3d                	addw	a0,a0,a5
}
    80008104:	1542                	slli	a0,a0,0x30
    80008106:	9141                	srli	a0,a0,0x30
    80008108:	60a2                	ld	ra,8(sp)
    8000810a:	6402                	ld	s0,0(sp)
    8000810c:	0141                	addi	sp,sp,16
    8000810e:	8082                	ret

0000000080008110 <net_init>:


int net_init() {
    80008110:	1141                	addi	sp,sp,-16
    80008112:	e406                	sd	ra,8(sp)
    80008114:	e022                	sd	s0,0(sp)
    80008116:	0800                	addi	s0,sp,16
  netconf.ip_addr = temp_ip;
    80008118:	c0a807b7          	lui	a5,0xc0a80
    8000811c:	0789                	addi	a5,a5,2 # ffffffffc0a80002 <end+0xffffffff40a0f656>
    8000811e:	00069717          	auipc	a4,0x69
    80008122:	86f72d23          	sw	a5,-1926(a4) # 80070998 <netconf>
  for (int i = 0; i < 6; i++)
    80008126:	00067797          	auipc	a5,0x67
    8000812a:	7fa78793          	addi	a5,a5,2042 # 8006f920 <net>
    8000812e:	00069717          	auipc	a4,0x69
    80008132:	86e70713          	addi	a4,a4,-1938 # 8007099c <netconf+0x4>
    80008136:	00067617          	auipc	a2,0x67
    8000813a:	7f060613          	addi	a2,a2,2032 # 8006f926 <net+0x6>
    netconf.mac_addr[i] = net.cfg.mac[i];
    8000813e:	0007c683          	lbu	a3,0(a5)
    80008142:	00d70023          	sb	a3,0(a4)
  for (int i = 0; i < 6; i++)
    80008146:	0785                	addi	a5,a5,1
    80008148:	0705                	addi	a4,a4,1
    8000814a:	fec79ae3          	bne	a5,a2,8000813e <net_init+0x2e>
  netconf.gateway = 0;
    8000814e:	00069797          	auipc	a5,0x69
    80008152:	84a78793          	addi	a5,a5,-1974 # 80070998 <netconf>
    80008156:	0007a823          	sw	zero,16(a5)
  netconf.subnet_mask = 0;
    8000815a:	0007a623          	sw	zero,12(a5)
  return 0;
}
    8000815e:	4501                	li	a0,0
    80008160:	60a2                	ld	ra,8(sp)
    80008162:	6402                	ld	s0,0(sp)
    80008164:	0141                	addi	sp,sp,16
    80008166:	8082                	ret
	...

0000000080009000 <_trampoline>:
    80009000:	14051073          	csrw	sscratch,a0
    80009004:	02000537          	lui	a0,0x2000
    80009008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000900a:	0536                	slli	a0,a0,0xd
    8000900c:	02153423          	sd	ra,40(a0)
    80009010:	02253823          	sd	sp,48(a0)
    80009014:	02353c23          	sd	gp,56(a0)
    80009018:	04453023          	sd	tp,64(a0)
    8000901c:	04553423          	sd	t0,72(a0)
    80009020:	04653823          	sd	t1,80(a0)
    80009024:	04753c23          	sd	t2,88(a0)
    80009028:	f120                	sd	s0,96(a0)
    8000902a:	f524                	sd	s1,104(a0)
    8000902c:	fd2c                	sd	a1,120(a0)
    8000902e:	e150                	sd	a2,128(a0)
    80009030:	e554                	sd	a3,136(a0)
    80009032:	e958                	sd	a4,144(a0)
    80009034:	ed5c                	sd	a5,152(a0)
    80009036:	0b053023          	sd	a6,160(a0)
    8000903a:	0b153423          	sd	a7,168(a0)
    8000903e:	0b253823          	sd	s2,176(a0)
    80009042:	0b353c23          	sd	s3,184(a0)
    80009046:	0d453023          	sd	s4,192(a0)
    8000904a:	0d553423          	sd	s5,200(a0)
    8000904e:	0d653823          	sd	s6,208(a0)
    80009052:	0d753c23          	sd	s7,216(a0)
    80009056:	0f853023          	sd	s8,224(a0)
    8000905a:	0f953423          	sd	s9,232(a0)
    8000905e:	0fa53823          	sd	s10,240(a0)
    80009062:	0fb53c23          	sd	s11,248(a0)
    80009066:	11c53023          	sd	t3,256(a0)
    8000906a:	11d53423          	sd	t4,264(a0)
    8000906e:	11e53823          	sd	t5,272(a0)
    80009072:	11f53c23          	sd	t6,280(a0)
    80009076:	140022f3          	csrr	t0,sscratch
    8000907a:	06553823          	sd	t0,112(a0)
    8000907e:	00853103          	ld	sp,8(a0)
    80009082:	02053203          	ld	tp,32(a0)
    80009086:	01053283          	ld	t0,16(a0)
    8000908a:	00053303          	ld	t1,0(a0)
    8000908e:	12000073          	sfence.vma
    80009092:	18031073          	csrw	satp,t1
    80009096:	12000073          	sfence.vma
    8000909a:	8282                	jr	t0

000000008000909c <userret>:
    8000909c:	12000073          	sfence.vma
    800090a0:	18051073          	csrw	satp,a0
    800090a4:	12000073          	sfence.vma
    800090a8:	02000537          	lui	a0,0x2000
    800090ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800090ae:	0536                	slli	a0,a0,0xd
    800090b0:	02853083          	ld	ra,40(a0)
    800090b4:	03053103          	ld	sp,48(a0)
    800090b8:	03853183          	ld	gp,56(a0)
    800090bc:	04053203          	ld	tp,64(a0)
    800090c0:	04853283          	ld	t0,72(a0)
    800090c4:	05053303          	ld	t1,80(a0)
    800090c8:	05853383          	ld	t2,88(a0)
    800090cc:	7120                	ld	s0,96(a0)
    800090ce:	7524                	ld	s1,104(a0)
    800090d0:	7d2c                	ld	a1,120(a0)
    800090d2:	6150                	ld	a2,128(a0)
    800090d4:	6554                	ld	a3,136(a0)
    800090d6:	6958                	ld	a4,144(a0)
    800090d8:	6d5c                	ld	a5,152(a0)
    800090da:	0a053803          	ld	a6,160(a0)
    800090de:	0a853883          	ld	a7,168(a0)
    800090e2:	0b053903          	ld	s2,176(a0)
    800090e6:	0b853983          	ld	s3,184(a0)
    800090ea:	0c053a03          	ld	s4,192(a0)
    800090ee:	0c853a83          	ld	s5,200(a0)
    800090f2:	0d053b03          	ld	s6,208(a0)
    800090f6:	0d853b83          	ld	s7,216(a0)
    800090fa:	0e053c03          	ld	s8,224(a0)
    800090fe:	0e853c83          	ld	s9,232(a0)
    80009102:	0f053d03          	ld	s10,240(a0)
    80009106:	0f853d83          	ld	s11,248(a0)
    8000910a:	10053e03          	ld	t3,256(a0)
    8000910e:	10853e83          	ld	t4,264(a0)
    80009112:	11053f03          	ld	t5,272(a0)
    80009116:	11853f83          	ld	t6,280(a0)
    8000911a:	7928                	ld	a0,112(a0)
    8000911c:	10200073          	sret
	...
