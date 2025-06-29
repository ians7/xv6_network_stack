
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000d117          	auipc	sp,0xd
    80000004:	cf010113          	addi	sp,sp,-784 # 8000ccf0 <stack0>
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
    80000054:	b6078793          	addi	a5,a5,-1184 # 8000cbb0 <timer_scratch>
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
    80000066:	98e78793          	addi	a5,a5,-1650 # 800069f0 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff90567>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	fea78793          	addi	a5,a5,-22 # 80001098 <main>
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
    8000010c:	04c05c63          	blez	a2,80000164 <consolewrite+0x62>
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
    80000138:	e0e080e7          	jalr	-498(ra) # 80002f42 <either_copyin>
    8000013c:	03550663          	beq	a0,s5,80000168 <consolewrite+0x66>
      break;
    uartputc(c);
    80000140:	faf44503          	lbu	a0,-81(s0)
    80000144:	00000097          	auipc	ra,0x0
    80000148:	7da080e7          	jalr	2010(ra) # 8000091e <uartputc>
  for(i = 0; i < n; i++){
    8000014c:	2905                	addiw	s2,s2,1
    8000014e:	0485                	addi	s1,s1,1
    80000150:	fd299ee3          	bne	s3,s2,8000012c <consolewrite+0x2a>
    80000154:	894e                	mv	s2,s3
    80000156:	64a6                	ld	s1,72(sp)
    80000158:	79e2                	ld	s3,56(sp)
    8000015a:	7a42                	ld	s4,48(sp)
    8000015c:	7aa2                	ld	s5,40(sp)
    8000015e:	7b02                	ld	s6,32(sp)
    80000160:	6be2                	ld	s7,24(sp)
    80000162:	a809                	j	80000174 <consolewrite+0x72>
    80000164:	4901                	li	s2,0
    80000166:	a039                	j	80000174 <consolewrite+0x72>
    80000168:	64a6                	ld	s1,72(sp)
    8000016a:	79e2                	ld	s3,56(sp)
    8000016c:	7a42                	ld	s4,48(sp)
    8000016e:	7aa2                	ld	s5,40(sp)
    80000170:	7b02                	ld	s6,32(sp)
    80000172:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80000174:	854a                	mv	a0,s2
    80000176:	60e6                	ld	ra,88(sp)
    80000178:	6446                	ld	s0,80(sp)
    8000017a:	6906                	ld	s2,64(sp)
    8000017c:	6125                	addi	sp,sp,96
    8000017e:	8082                	ret

0000000080000180 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000180:	711d                	addi	sp,sp,-96
    80000182:	ec86                	sd	ra,88(sp)
    80000184:	e8a2                	sd	s0,80(sp)
    80000186:	e4a6                	sd	s1,72(sp)
    80000188:	e0ca                	sd	s2,64(sp)
    8000018a:	fc4e                	sd	s3,56(sp)
    8000018c:	f852                	sd	s4,48(sp)
    8000018e:	f456                	sd	s5,40(sp)
    80000190:	f05a                	sd	s6,32(sp)
    80000192:	1080                	addi	s0,sp,96
    80000194:	8aaa                	mv	s5,a0
    80000196:	8a2e                	mv	s4,a1
    80000198:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000019a:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    8000019c:	00015517          	auipc	a0,0x15
    800001a0:	b5450513          	addi	a0,a0,-1196 # 80014cf0 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	b72080e7          	jalr	-1166(ra) # 80000d16 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001ac:	00015497          	auipc	s1,0x15
    800001b0:	b4448493          	addi	s1,s1,-1212 # 80014cf0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b4:	00015917          	auipc	s2,0x15
    800001b8:	bd490913          	addi	s2,s2,-1068 # 80014d88 <cons+0x98>
  while(n > 0){
    800001bc:	0d305563          	blez	s3,80000286 <consoleread+0x106>
    while(cons.r == cons.w){
    800001c0:	0984a783          	lw	a5,152(s1)
    800001c4:	09c4a703          	lw	a4,156(s1)
    800001c8:	0af71a63          	bne	a4,a5,8000027c <consoleread+0xfc>
      if(killed(myproc())){
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	d56080e7          	jalr	-682(ra) # 80001f22 <myproc>
    800001d4:	00003097          	auipc	ra,0x3
    800001d8:	a7c080e7          	jalr	-1412(ra) # 80002c50 <killed>
    800001dc:	e52d                	bnez	a0,80000246 <consoleread+0xc6>
      sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	648080e7          	jalr	1608(ra) # 8000282a <sleep>
    while(cons.r == cons.w){
    800001ea:	0984a783          	lw	a5,152(s1)
    800001ee:	09c4a703          	lw	a4,156(s1)
    800001f2:	fcf70de3          	beq	a4,a5,800001cc <consoleread+0x4c>
    800001f6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f8:	00015717          	auipc	a4,0x15
    800001fc:	af870713          	addi	a4,a4,-1288 # 80014cf0 <cons>
    80000200:	0017869b          	addiw	a3,a5,1
    80000204:	08d72c23          	sw	a3,152(a4)
    80000208:	07f7f693          	andi	a3,a5,127
    8000020c:	9736                	add	a4,a4,a3
    8000020e:	01874703          	lbu	a4,24(a4)
    80000212:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000216:	4691                	li	a3,4
    80000218:	04db8a63          	beq	s7,a3,8000026c <consoleread+0xec>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000021c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000220:	4685                	li	a3,1
    80000222:	faf40613          	addi	a2,s0,-81
    80000226:	85d2                	mv	a1,s4
    80000228:	8556                	mv	a0,s5
    8000022a:	00003097          	auipc	ra,0x3
    8000022e:	cc2080e7          	jalr	-830(ra) # 80002eec <either_copyout>
    80000232:	57fd                	li	a5,-1
    80000234:	04f50863          	beq	a0,a5,80000284 <consoleread+0x104>
      break;

    dst++;
    80000238:	0a05                	addi	s4,s4,1
    --n;
    8000023a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000023c:	47a9                	li	a5,10
    8000023e:	04fb8f63          	beq	s7,a5,8000029c <consoleread+0x11c>
    80000242:	6be2                	ld	s7,24(sp)
    80000244:	bfa5                	j	800001bc <consoleread+0x3c>
        release(&cons.lock);
    80000246:	00015517          	auipc	a0,0x15
    8000024a:	aaa50513          	addi	a0,a0,-1366 # 80014cf0 <cons>
    8000024e:	00001097          	auipc	ra,0x1
    80000252:	b78080e7          	jalr	-1160(ra) # 80000dc6 <release>
        return -1;
    80000256:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000258:	60e6                	ld	ra,88(sp)
    8000025a:	6446                	ld	s0,80(sp)
    8000025c:	64a6                	ld	s1,72(sp)
    8000025e:	6906                	ld	s2,64(sp)
    80000260:	79e2                	ld	s3,56(sp)
    80000262:	7a42                	ld	s4,48(sp)
    80000264:	7aa2                	ld	s5,40(sp)
    80000266:	7b02                	ld	s6,32(sp)
    80000268:	6125                	addi	sp,sp,96
    8000026a:	8082                	ret
      if(n < target){
    8000026c:	0169fa63          	bgeu	s3,s6,80000280 <consoleread+0x100>
        cons.r--;
    80000270:	00015717          	auipc	a4,0x15
    80000274:	b0f72c23          	sw	a5,-1256(a4) # 80014d88 <cons+0x98>
    80000278:	6be2                	ld	s7,24(sp)
    8000027a:	a031                	j	80000286 <consoleread+0x106>
    8000027c:	ec5e                	sd	s7,24(sp)
    8000027e:	bfad                	j	800001f8 <consoleread+0x78>
    80000280:	6be2                	ld	s7,24(sp)
    80000282:	a011                	j	80000286 <consoleread+0x106>
    80000284:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000286:	00015517          	auipc	a0,0x15
    8000028a:	a6a50513          	addi	a0,a0,-1430 # 80014cf0 <cons>
    8000028e:	00001097          	auipc	ra,0x1
    80000292:	b38080e7          	jalr	-1224(ra) # 80000dc6 <release>
  return target - n;
    80000296:	413b053b          	subw	a0,s6,s3
    8000029a:	bf7d                	j	80000258 <consoleread+0xd8>
    8000029c:	6be2                	ld	s7,24(sp)
    8000029e:	b7e5                	j	80000286 <consoleread+0x106>

00000000800002a0 <consputc>:
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800002a8:	10000793          	li	a5,256
    800002ac:	00f50a63          	beq	a0,a5,800002c0 <consputc+0x20>
    uartputc_sync(c);
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	590080e7          	jalr	1424(ra) # 80000840 <uartputc_sync>
}
    800002b8:	60a2                	ld	ra,8(sp)
    800002ba:	6402                	ld	s0,0(sp)
    800002bc:	0141                	addi	sp,sp,16
    800002be:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002c0:	4521                	li	a0,8
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	57e080e7          	jalr	1406(ra) # 80000840 <uartputc_sync>
    800002ca:	02000513          	li	a0,32
    800002ce:	00000097          	auipc	ra,0x0
    800002d2:	572080e7          	jalr	1394(ra) # 80000840 <uartputc_sync>
    800002d6:	4521                	li	a0,8
    800002d8:	00000097          	auipc	ra,0x0
    800002dc:	568080e7          	jalr	1384(ra) # 80000840 <uartputc_sync>
    800002e0:	bfe1                	j	800002b8 <consputc+0x18>

00000000800002e2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002e2:	7179                	addi	sp,sp,-48
    800002e4:	f406                	sd	ra,40(sp)
    800002e6:	f022                	sd	s0,32(sp)
    800002e8:	ec26                	sd	s1,24(sp)
    800002ea:	1800                	addi	s0,sp,48
    800002ec:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ee:	00015517          	auipc	a0,0x15
    800002f2:	a0250513          	addi	a0,a0,-1534 # 80014cf0 <cons>
    800002f6:	00001097          	auipc	ra,0x1
    800002fa:	a20080e7          	jalr	-1504(ra) # 80000d16 <acquire>

  switch(c){
    800002fe:	47d5                	li	a5,21
    80000300:	0af48463          	beq	s1,a5,800003a8 <consoleintr+0xc6>
    80000304:	0297c963          	blt	a5,s1,80000336 <consoleintr+0x54>
    80000308:	47a1                	li	a5,8
    8000030a:	10f48063          	beq	s1,a5,8000040a <consoleintr+0x128>
    8000030e:	47c1                	li	a5,16
    80000310:	12f49363          	bne	s1,a5,80000436 <consoleintr+0x154>
  case C('P'):  // Print process list.
    procdump();
    80000314:	00003097          	auipc	ra,0x3
    80000318:	c84080e7          	jalr	-892(ra) # 80002f98 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000031c:	00015517          	auipc	a0,0x15
    80000320:	9d450513          	addi	a0,a0,-1580 # 80014cf0 <cons>
    80000324:	00001097          	auipc	ra,0x1
    80000328:	aa2080e7          	jalr	-1374(ra) # 80000dc6 <release>
}
    8000032c:	70a2                	ld	ra,40(sp)
    8000032e:	7402                	ld	s0,32(sp)
    80000330:	64e2                	ld	s1,24(sp)
    80000332:	6145                	addi	sp,sp,48
    80000334:	8082                	ret
  switch(c){
    80000336:	07f00793          	li	a5,127
    8000033a:	0cf48863          	beq	s1,a5,8000040a <consoleintr+0x128>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000033e:	00015717          	auipc	a4,0x15
    80000342:	9b270713          	addi	a4,a4,-1614 # 80014cf0 <cons>
    80000346:	0a072783          	lw	a5,160(a4)
    8000034a:	09872703          	lw	a4,152(a4)
    8000034e:	9f99                	subw	a5,a5,a4
    80000350:	07f00713          	li	a4,127
    80000354:	fcf764e3          	bltu	a4,a5,8000031c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80000358:	47b5                	li	a5,13
    8000035a:	0ef48163          	beq	s1,a5,8000043c <consoleintr+0x15a>
      consputc(c);
    8000035e:	8526                	mv	a0,s1
    80000360:	00000097          	auipc	ra,0x0
    80000364:	f40080e7          	jalr	-192(ra) # 800002a0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000368:	00015797          	auipc	a5,0x15
    8000036c:	98878793          	addi	a5,a5,-1656 # 80014cf0 <cons>
    80000370:	0a07a683          	lw	a3,160(a5)
    80000374:	0016871b          	addiw	a4,a3,1
    80000378:	863a                	mv	a2,a4
    8000037a:	0ae7a023          	sw	a4,160(a5)
    8000037e:	07f6f693          	andi	a3,a3,127
    80000382:	97b6                	add	a5,a5,a3
    80000384:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000388:	47a9                	li	a5,10
    8000038a:	0cf48f63          	beq	s1,a5,80000468 <consoleintr+0x186>
    8000038e:	4791                	li	a5,4
    80000390:	0cf48c63          	beq	s1,a5,80000468 <consoleintr+0x186>
    80000394:	00015797          	auipc	a5,0x15
    80000398:	9f47a783          	lw	a5,-1548(a5) # 80014d88 <cons+0x98>
    8000039c:	9f1d                	subw	a4,a4,a5
    8000039e:	08000793          	li	a5,128
    800003a2:	f6f71de3          	bne	a4,a5,8000031c <consoleintr+0x3a>
    800003a6:	a0c9                	j	80000468 <consoleintr+0x186>
    800003a8:	e84a                	sd	s2,16(sp)
    800003aa:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    800003ac:	00015717          	auipc	a4,0x15
    800003b0:	94470713          	addi	a4,a4,-1724 # 80014cf0 <cons>
    800003b4:	0a072783          	lw	a5,160(a4)
    800003b8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003bc:	00015497          	auipc	s1,0x15
    800003c0:	93448493          	addi	s1,s1,-1740 # 80014cf0 <cons>
    while(cons.e != cons.w &&
    800003c4:	4929                	li	s2,10
      consputc(BACKSPACE);
    800003c6:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    800003ca:	02f70a63          	beq	a4,a5,800003fe <consoleintr+0x11c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003ce:	37fd                	addiw	a5,a5,-1
    800003d0:	07f7f713          	andi	a4,a5,127
    800003d4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003d6:	01874703          	lbu	a4,24(a4)
    800003da:	03270563          	beq	a4,s2,80000404 <consoleintr+0x122>
      cons.e--;
    800003de:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003e2:	854e                	mv	a0,s3
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	ebc080e7          	jalr	-324(ra) # 800002a0 <consputc>
    while(cons.e != cons.w &&
    800003ec:	0a04a783          	lw	a5,160(s1)
    800003f0:	09c4a703          	lw	a4,156(s1)
    800003f4:	fcf71de3          	bne	a4,a5,800003ce <consoleintr+0xec>
    800003f8:	6942                	ld	s2,16(sp)
    800003fa:	69a2                	ld	s3,8(sp)
    800003fc:	b705                	j	8000031c <consoleintr+0x3a>
    800003fe:	6942                	ld	s2,16(sp)
    80000400:	69a2                	ld	s3,8(sp)
    80000402:	bf29                	j	8000031c <consoleintr+0x3a>
    80000404:	6942                	ld	s2,16(sp)
    80000406:	69a2                	ld	s3,8(sp)
    80000408:	bf11                	j	8000031c <consoleintr+0x3a>
    if(cons.e != cons.w){
    8000040a:	00015717          	auipc	a4,0x15
    8000040e:	8e670713          	addi	a4,a4,-1818 # 80014cf0 <cons>
    80000412:	0a072783          	lw	a5,160(a4)
    80000416:	09c72703          	lw	a4,156(a4)
    8000041a:	f0f701e3          	beq	a4,a5,8000031c <consoleintr+0x3a>
      cons.e--;
    8000041e:	37fd                	addiw	a5,a5,-1
    80000420:	00015717          	auipc	a4,0x15
    80000424:	96f72823          	sw	a5,-1680(a4) # 80014d90 <cons+0xa0>
      consputc(BACKSPACE);
    80000428:	10000513          	li	a0,256
    8000042c:	00000097          	auipc	ra,0x0
    80000430:	e74080e7          	jalr	-396(ra) # 800002a0 <consputc>
    80000434:	b5e5                	j	8000031c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000436:	ee0483e3          	beqz	s1,8000031c <consoleintr+0x3a>
    8000043a:	b711                	j	8000033e <consoleintr+0x5c>
      consputc(c);
    8000043c:	4529                	li	a0,10
    8000043e:	00000097          	auipc	ra,0x0
    80000442:	e62080e7          	jalr	-414(ra) # 800002a0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000446:	00015797          	auipc	a5,0x15
    8000044a:	8aa78793          	addi	a5,a5,-1878 # 80014cf0 <cons>
    8000044e:	0a07a703          	lw	a4,160(a5)
    80000452:	0017069b          	addiw	a3,a4,1
    80000456:	8636                	mv	a2,a3
    80000458:	0ad7a023          	sw	a3,160(a5)
    8000045c:	07f77713          	andi	a4,a4,127
    80000460:	97ba                	add	a5,a5,a4
    80000462:	4729                	li	a4,10
    80000464:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000468:	00015797          	auipc	a5,0x15
    8000046c:	92c7a223          	sw	a2,-1756(a5) # 80014d8c <cons+0x9c>
        wakeup(&cons.r);
    80000470:	00015517          	auipc	a0,0x15
    80000474:	91850513          	addi	a0,a0,-1768 # 80014d88 <cons+0x98>
    80000478:	00002097          	auipc	ra,0x2
    8000047c:	416080e7          	jalr	1046(ra) # 8000288e <wakeup>
    80000480:	bd71                	j	8000031c <consoleintr+0x3a>

0000000080000482 <consoleinit>:

void
consoleinit(void)
{
    80000482:	1141                	addi	sp,sp,-16
    80000484:	e406                	sd	ra,8(sp)
    80000486:	e022                	sd	s0,0(sp)
    80000488:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000048a:	00009597          	auipc	a1,0x9
    8000048e:	b7658593          	addi	a1,a1,-1162 # 80009000 <etext>
    80000492:	00015517          	auipc	a0,0x15
    80000496:	85e50513          	addi	a0,a0,-1954 # 80014cf0 <cons>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	7e8080e7          	jalr	2024(ra) # 80000c82 <initlock>

  uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	344080e7          	jalr	836(ra) # 800007e6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800004aa:	0006d797          	auipc	a5,0x6d
    800004ae:	bde78793          	addi	a5,a5,-1058 # 8006d088 <devsw>
    800004b2:	00000717          	auipc	a4,0x0
    800004b6:	cce70713          	addi	a4,a4,-818 # 80000180 <consoleread>
    800004ba:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004bc:	00000717          	auipc	a4,0x0
    800004c0:	c4670713          	addi	a4,a4,-954 # 80000102 <consolewrite>
    800004c4:	ef98                	sd	a4,24(a5)
}
    800004c6:	60a2                	ld	ra,8(sp)
    800004c8:	6402                	ld	s0,0(sp)
    800004ca:	0141                	addi	sp,sp,16
    800004cc:	8082                	ret

00000000800004ce <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004ce:	7179                	addi	sp,sp,-48
    800004d0:	f406                	sd	ra,40(sp)
    800004d2:	f022                	sd	s0,32(sp)
    800004d4:	ec26                	sd	s1,24(sp)
    800004d6:	e84a                	sd	s2,16(sp)
    800004d8:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004da:	c219                	beqz	a2,800004e0 <printint+0x12>
    800004dc:	06054e63          	bltz	a0,80000558 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800004e0:	4e01                	li	t3,0

  i = 0;
    800004e2:	fd040313          	addi	t1,s0,-48
    x = xx;
    800004e6:	869a                	mv	a3,t1
  i = 0;
    800004e8:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800004ea:	00009817          	auipc	a6,0x9
    800004ee:	4be80813          	addi	a6,a6,1214 # 800099a8 <digits>
    800004f2:	88be                	mv	a7,a5
    800004f4:	0017861b          	addiw	a2,a5,1
    800004f8:	87b2                	mv	a5,a2
    800004fa:	02b5773b          	remuw	a4,a0,a1
    800004fe:	1702                	slli	a4,a4,0x20
    80000500:	9301                	srli	a4,a4,0x20
    80000502:	9742                	add	a4,a4,a6
    80000504:	00074703          	lbu	a4,0(a4)
    80000508:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000050c:	872a                	mv	a4,a0
    8000050e:	02b5553b          	divuw	a0,a0,a1
    80000512:	0685                	addi	a3,a3,1
    80000514:	fcb77fe3          	bgeu	a4,a1,800004f2 <printint+0x24>

  if(sign)
    80000518:	000e0c63          	beqz	t3,80000530 <printint+0x62>
    buf[i++] = '-';
    8000051c:	fe060793          	addi	a5,a2,-32
    80000520:	00878633          	add	a2,a5,s0
    80000524:	02d00793          	li	a5,45
    80000528:	fef60823          	sb	a5,-16(a2)
    8000052c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80000530:	fff7891b          	addiw	s2,a5,-1
    80000534:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80000538:	fff4c503          	lbu	a0,-1(s1)
    8000053c:	00000097          	auipc	ra,0x0
    80000540:	d64080e7          	jalr	-668(ra) # 800002a0 <consputc>
  while(--i >= 0)
    80000544:	397d                	addiw	s2,s2,-1
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	fe0958e3          	bgez	s2,80000538 <printint+0x6a>
}
    8000054c:	70a2                	ld	ra,40(sp)
    8000054e:	7402                	ld	s0,32(sp)
    80000550:	64e2                	ld	s1,24(sp)
    80000552:	6942                	ld	s2,16(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
    x = -xx;
    80000558:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055c:	4e05                	li	t3,1
    x = -xx;
    8000055e:	b751                	j	800004e2 <printint+0x14>

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
    8000056c:	00015797          	auipc	a5,0x15
    80000570:	8407a223          	sw	zero,-1980(a5) # 80014db0 <pr+0x18>
  printf("panic: ");
    80000574:	00009517          	auipc	a0,0x9
    80000578:	a9450513          	addi	a0,a0,-1388 # 80009008 <etext+0x8>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	00009517          	auipc	a0,0x9
    80000592:	a8250513          	addi	a0,a0,-1406 # 80009010 <etext+0x10>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	0000c717          	auipc	a4,0xc
    800005a4:	5cf72823          	sw	a5,1488(a4) # 8000cb70 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	ec6e                	sd	s11,24(sp)
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
    800005ca:	00014d97          	auipc	s11,0x14
    800005ce:	7e6dad83          	lw	s11,2022(s11) # 80014db0 <pr+0x18>
  if(locking)
    800005d2:	040d9463          	bnez	s11,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050c63          	beqz	a0,8000077e <printf+0x1d4>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	f06a                	sd	s10,32(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	07800c93          	li	s9,120
    8000060a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000060c:	00009a97          	auipc	s5,0x9
    80000610:	39ca8a93          	addi	s5,s5,924 # 800099a8 <digits>
    switch(c){
    80000614:	07300c13          	li	s8,115
    80000618:	a0b9                	j	80000666 <printf+0xbc>
    acquire(&pr.lock);
    8000061a:	00014517          	auipc	a0,0x14
    8000061e:	77e50513          	addi	a0,a0,1918 # 80014d98 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	6f4080e7          	jalr	1780(ra) # 80000d16 <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    8000063e:	00009517          	auipc	a0,0x9
    80000642:	9e250513          	addi	a0,a0,-1566 # 80009020 <etext+0x20>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c52080e7          	jalr	-942(ra) # 800002a0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	0019879b          	addiw	a5,s3,1
    8000065a:	89be                	mv	s3,a5
    8000065c:	97d2                	add	a5,a5,s4
    8000065e:	0007c503          	lbu	a0,0(a5)
    80000662:	10050563          	beqz	a0,8000076c <printf+0x1c2>
    if(c != '%'){
    80000666:	ff6514e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000066a:	0019879b          	addiw	a5,s3,1
    8000066e:	89be                	mv	s3,a5
    80000670:	97d2                	add	a5,a5,s4
    80000672:	0007c783          	lbu	a5,0(a5)
    80000676:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000067a:	10078a63          	beqz	a5,8000078e <printf+0x1e4>
    switch(c){
    8000067e:	05778a63          	beq	a5,s7,800006d2 <printf+0x128>
    80000682:	02fbf463          	bgeu	s7,a5,800006aa <printf+0x100>
    80000686:	09878763          	beq	a5,s8,80000714 <printf+0x16a>
    8000068a:	0d979663          	bne	a5,s9,80000756 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85ea                	mv	a1,s10
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e2e080e7          	jalr	-466(ra) # 800004ce <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	0b678063          	beq	a5,s6,8000074a <printf+0x1a0>
    800006ae:	06400713          	li	a4,100
    800006b2:	0ae79263          	bne	a5,a4,80000756 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    800006b6:	f8843783          	ld	a5,-120(s0)
    800006ba:	00878713          	addi	a4,a5,8
    800006be:	f8e43423          	sd	a4,-120(s0)
    800006c2:	4605                	li	a2,1
    800006c4:	45a9                	li	a1,10
    800006c6:	4388                	lw	a0,0(a5)
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	e06080e7          	jalr	-506(ra) # 800004ce <printint>
      break;
    800006d0:	b759                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006d2:	f8843783          	ld	a5,-120(s0)
    800006d6:	00878713          	addi	a4,a5,8
    800006da:	f8e43423          	sd	a4,-120(s0)
    800006de:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006e2:	03000513          	li	a0,48
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	bba080e7          	jalr	-1094(ra) # 800002a0 <consputc>
  consputc('x');
    800006ee:	8566                	mv	a0,s9
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	bb0080e7          	jalr	-1104(ra) # 800002a0 <consputc>
    800006f8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006fa:	03c95793          	srli	a5,s2,0x3c
    800006fe:	97d6                	add	a5,a5,s5
    80000700:	0007c503          	lbu	a0,0(a5)
    80000704:	00000097          	auipc	ra,0x0
    80000708:	b9c080e7          	jalr	-1124(ra) # 800002a0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070c:	0912                	slli	s2,s2,0x4
    8000070e:	34fd                	addiw	s1,s1,-1
    80000710:	f4ed                	bnez	s1,800006fa <printf+0x150>
    80000712:	b791                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000714:	f8843783          	ld	a5,-120(s0)
    80000718:	00878713          	addi	a4,a5,8
    8000071c:	f8e43423          	sd	a4,-120(s0)
    80000720:	6384                	ld	s1,0(a5)
    80000722:	cc89                	beqz	s1,8000073c <printf+0x192>
      for(; *s; s++)
    80000724:	0004c503          	lbu	a0,0(s1)
    80000728:	d51d                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b76080e7          	jalr	-1162(ra) # 800002a0 <consputc>
      for(; *s; s++)
    80000732:	0485                	addi	s1,s1,1
    80000734:	0004c503          	lbu	a0,0(s1)
    80000738:	f96d                	bnez	a0,8000072a <printf+0x180>
    8000073a:	bf31                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073c:	00009497          	auipc	s1,0x9
    80000740:	8dc48493          	addi	s1,s1,-1828 # 80009018 <etext+0x18>
      for(; *s; s++)
    80000744:	02800513          	li	a0,40
    80000748:	b7cd                	j	8000072a <printf+0x180>
      consputc('%');
    8000074a:	855a                	mv	a0,s6
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	b54080e7          	jalr	-1196(ra) # 800002a0 <consputc>
      break;
    80000754:	b709                	j	80000656 <printf+0xac>
      consputc('%');
    80000756:	855a                	mv	a0,s6
    80000758:	00000097          	auipc	ra,0x0
    8000075c:	b48080e7          	jalr	-1208(ra) # 800002a0 <consputc>
      consputc(c);
    80000760:	8526                	mv	a0,s1
    80000762:	00000097          	auipc	ra,0x0
    80000766:	b3e080e7          	jalr	-1218(ra) # 800002a0 <consputc>
      break;
    8000076a:	b5f5                	j	80000656 <printf+0xac>
    8000076c:	74a6                	ld	s1,104(sp)
    8000076e:	7906                	ld	s2,96(sp)
    80000770:	69e6                	ld	s3,88(sp)
    80000772:	6aa6                	ld	s5,72(sp)
    80000774:	6b06                	ld	s6,64(sp)
    80000776:	7be2                	ld	s7,56(sp)
    80000778:	7c42                	ld	s8,48(sp)
    8000077a:	7ca2                	ld	s9,40(sp)
    8000077c:	7d02                	ld	s10,32(sp)
  if(locking)
    8000077e:	020d9263          	bnez	s11,800007a2 <printf+0x1f8>
}
    80000782:	70e6                	ld	ra,120(sp)
    80000784:	7446                	ld	s0,112(sp)
    80000786:	6a46                	ld	s4,80(sp)
    80000788:	6de2                	ld	s11,24(sp)
    8000078a:	6129                	addi	sp,sp,192
    8000078c:	8082                	ret
    8000078e:	74a6                	ld	s1,104(sp)
    80000790:	7906                	ld	s2,96(sp)
    80000792:	69e6                	ld	s3,88(sp)
    80000794:	6aa6                	ld	s5,72(sp)
    80000796:	6b06                	ld	s6,64(sp)
    80000798:	7be2                	ld	s7,56(sp)
    8000079a:	7c42                	ld	s8,48(sp)
    8000079c:	7ca2                	ld	s9,40(sp)
    8000079e:	7d02                	ld	s10,32(sp)
    800007a0:	bff9                	j	8000077e <printf+0x1d4>
    release(&pr.lock);
    800007a2:	00014517          	auipc	a0,0x14
    800007a6:	5f650513          	addi	a0,a0,1526 # 80014d98 <pr>
    800007aa:	00000097          	auipc	ra,0x0
    800007ae:	61c080e7          	jalr	1564(ra) # 80000dc6 <release>
}
    800007b2:	bfc1                	j	80000782 <printf+0x1d8>

00000000800007b4 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b4:	1101                	addi	sp,sp,-32
    800007b6:	ec06                	sd	ra,24(sp)
    800007b8:	e822                	sd	s0,16(sp)
    800007ba:	e426                	sd	s1,8(sp)
    800007bc:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007be:	00014497          	auipc	s1,0x14
    800007c2:	5da48493          	addi	s1,s1,1498 # 80014d98 <pr>
    800007c6:	00009597          	auipc	a1,0x9
    800007ca:	86a58593          	addi	a1,a1,-1942 # 80009030 <etext+0x30>
    800007ce:	8526                	mv	a0,s1
    800007d0:	00000097          	auipc	ra,0x0
    800007d4:	4b2080e7          	jalr	1202(ra) # 80000c82 <initlock>
  pr.locking = 1;
    800007d8:	4785                	li	a5,1
    800007da:	cc9c                	sw	a5,24(s1)
}
    800007dc:	60e2                	ld	ra,24(sp)
    800007de:	6442                	ld	s0,16(sp)
    800007e0:	64a2                	ld	s1,8(sp)
    800007e2:	6105                	addi	sp,sp,32
    800007e4:	8082                	ret

00000000800007e6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e6:	1141                	addi	sp,sp,-16
    800007e8:	e406                	sd	ra,8(sp)
    800007ea:	e022                	sd	s0,0(sp)
    800007ec:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ee:	100007b7          	lui	a5,0x10000
    800007f2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f6:	10000737          	lui	a4,0x10000
    800007fa:	f8000693          	li	a3,-128
    800007fe:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000802:	468d                	li	a3,3
    80000804:	10000637          	lui	a2,0x10000
    80000808:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000810:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000814:	8732                	mv	a4,a2
    80000816:	461d                	li	a2,7
    80000818:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000820:	00009597          	auipc	a1,0x9
    80000824:	81858593          	addi	a1,a1,-2024 # 80009038 <etext+0x38>
    80000828:	00014517          	auipc	a0,0x14
    8000082c:	59050513          	addi	a0,a0,1424 # 80014db8 <uart_tx_lock>
    80000830:	00000097          	auipc	ra,0x0
    80000834:	452080e7          	jalr	1106(ra) # 80000c82 <initlock>
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
    80000850:	47e080e7          	jalr	1150(ra) # 80000cca <push_off>

  if(panicked){
    80000854:	0000c797          	auipc	a5,0xc
    80000858:	31c7a783          	lw	a5,796(a5) # 8000cb70 <panicked>
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
    8000087e:	4f0080e7          	jalr	1264(ra) # 80000d6a <pop_off>
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
    80000892:	2ea7b783          	ld	a5,746(a5) # 8000cb78 <uart_tx_r>
    80000896:	0000c717          	auipc	a4,0xc
    8000089a:	2ea73703          	ld	a4,746(a4) # 8000cb80 <uart_tx_w>
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
    800008c0:	4fca8a93          	addi	s5,s5,1276 # 80014db8 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000c497          	auipc	s1,0xc
    800008c8:	2b448493          	addi	s1,s1,692 # 8000cb78 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000c997          	auipc	s3,0xc
    800008d4:	2b098993          	addi	s3,s3,688 # 8000cb80 <uart_tx_w>
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
    800008f6:	f9c080e7          	jalr	-100(ra) # 8000288e <wakeup>
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
    80000934:	48850513          	addi	a0,a0,1160 # 80014db8 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	3de080e7          	jalr	990(ra) # 80000d16 <acquire>
  if(panicked){
    80000940:	0000c797          	auipc	a5,0xc
    80000944:	2307a783          	lw	a5,560(a5) # 8000cb70 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000c717          	auipc	a4,0xc
    8000094e:	23673703          	ld	a4,566(a4) # 8000cb80 <uart_tx_w>
    80000952:	0000c797          	auipc	a5,0xc
    80000956:	2267b783          	ld	a5,550(a5) # 8000cb78 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00014997          	auipc	s3,0x14
    80000962:	45a98993          	addi	s3,s3,1114 # 80014db8 <uart_tx_lock>
    80000966:	0000c497          	auipc	s1,0xc
    8000096a:	21248493          	addi	s1,s1,530 # 8000cb78 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000c917          	auipc	s2,0xc
    80000972:	21290913          	addi	s2,s2,530 # 8000cb80 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	eac080e7          	jalr	-340(ra) # 8000282a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00014497          	auipc	s1,0x14
    80000998:	42448493          	addi	s1,s1,1060 # 80014db8 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000c797          	auipc	a5,0xc
    800009ac:	1ce7bc23          	sd	a4,472(a5) # 8000cb80 <uart_tx_w>
  uartstart();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	ede080e7          	jalr	-290(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    800009b8:	8526                	mv	a0,s1
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	40c080e7          	jalr	1036(ra) # 80000dc6 <release>
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
    800009d6:	e406                	sd	ra,8(sp)
    800009d8:	e022                	sd	s0,0(sp)
    800009da:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009dc:	100007b7          	lui	a5,0x10000
    800009e0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb89                	beqz	a5,800009f8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	60a2                	ld	ra,8(sp)
    800009f2:	6402                	ld	s0,0(sp)
    800009f4:	0141                	addi	sp,sp,16
    800009f6:	8082                	ret
    return -1;
    800009f8:	557d                	li	a0,-1
    800009fa:	bfdd                	j	800009f0 <uartgetc+0x1c>

00000000800009fc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fc:	1101                	addi	sp,sp,-32
    800009fe:	ec06                	sd	ra,24(sp)
    80000a00:	e822                	sd	s0,16(sp)
    80000a02:	e426                	sd	s1,8(sp)
    80000a04:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a06:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	fcc080e7          	jalr	-52(ra) # 800009d4 <uartgetc>
    if(c == -1)
    80000a10:	00950763          	beq	a0,s1,80000a1e <uartintr+0x22>
      break;
    consoleintr(c);
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	8ce080e7          	jalr	-1842(ra) # 800002e2 <consoleintr>
  while(1){
    80000a1c:	b7f5                	j	80000a08 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1e:	00014497          	auipc	s1,0x14
    80000a22:	39a48493          	addi	s1,s1,922 # 80014db8 <uart_tx_lock>
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	2ee080e7          	jalr	750(ra) # 80000d16 <acquire>
  uartstart();
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	e5e080e7          	jalr	-418(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    80000a38:	8526                	mv	a0,s1
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	38c080e7          	jalr	908(ra) # 80000dc6 <release>
}
    80000a42:	60e2                	ld	ra,24(sp)
    80000a44:	6442                	ld	s0,16(sp)
    80000a46:	64a2                	ld	s1,8(sp)
    80000a48:	6105                	addi	sp,sp,32
    80000a4a:	8082                	ret

0000000080000a4c <add_page_reference>:
struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void add_page_reference(uint64 pointer_in_page){
    80000a4c:	1101                	addi	sp,sp,-32
    80000a4e:	ec06                	sd	ra,24(sp)
    80000a50:	e822                	sd	s0,16(sp)
    80000a52:	e426                	sd	s1,8(sp)
    80000a54:	e04a                	sd	s2,0(sp)
    80000a56:	1000                	addi	s0,sp,32
    80000a58:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    80000a5a:	00014917          	auipc	s2,0x14
    80000a5e:	39690913          	addi	s2,s2,918 # 80014df0 <kmem>
    80000a62:	854a                	mv	a0,s2
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	2b2080e7          	jalr	690(ra) # 80000d16 <acquire>
  uint page_num = PGROUNDDOWN((uint64)pointer_in_page)/PGSIZE;
    80000a6c:	80b1                	srli	s1,s1,0xc
  ref_counter[page_num]++;
    80000a6e:	02049793          	slli	a5,s1,0x20
    80000a72:	01d7d493          	srli	s1,a5,0x1d
    80000a76:	00014797          	auipc	a5,0x14
    80000a7a:	39a78793          	addi	a5,a5,922 # 80014e10 <ref_counter>
    80000a7e:	97a6                	add	a5,a5,s1
    80000a80:	6398                	ld	a4,0(a5)
    80000a82:	0705                	addi	a4,a4,1
    80000a84:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000a86:	854a                	mv	a0,s2
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	33e080e7          	jalr	830(ra) # 80000dc6 <release>
}
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6902                	ld	s2,0(sp)
    80000a98:	6105                	addi	sp,sp,32
    80000a9a:	8082                	ret

0000000080000a9c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a9c:	1101                	addi	sp,sp,-32
    80000a9e:	ec06                	sd	ra,24(sp)
    80000aa0:	e822                	sd	s0,16(sp)
    80000aa2:	e426                	sd	s1,8(sp)
    80000aa4:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000aa6:	03451793          	slli	a5,a0,0x34
    80000aaa:	efd9                	bnez	a5,80000b48 <kfree+0xac>
    80000aac:	84aa                	mv	s1,a0
    80000aae:	0006d797          	auipc	a5,0x6d
    80000ab2:	7ea78793          	addi	a5,a5,2026 # 8006e298 <end>
    80000ab6:	08f56963          	bltu	a0,a5,80000b48 <kfree+0xac>
    80000aba:	47c5                	li	a5,17
    80000abc:	07ee                	slli	a5,a5,0x1b
    80000abe:	08f57563          	bgeu	a0,a5,80000b48 <kfree+0xac>
    panic("kfree");

  acquire(&kmem.lock);
    80000ac2:	00014517          	auipc	a0,0x14
    80000ac6:	32e50513          	addi	a0,a0,814 # 80014df0 <kmem>
    80000aca:	00000097          	auipc	ra,0x0
    80000ace:	24c080e7          	jalr	588(ra) # 80000d16 <acquire>
  uint64 page_num = PGROUNDDOWN((uint64)pa)/PGSIZE;
    80000ad2:	00c4d793          	srli	a5,s1,0xc
  if (ref_counter[page_num] > 1) {
    80000ad6:	00379693          	slli	a3,a5,0x3
    80000ada:	00014717          	auipc	a4,0x14
    80000ade:	33670713          	addi	a4,a4,822 # 80014e10 <ref_counter>
    80000ae2:	9736                	add	a4,a4,a3
    80000ae4:	6318                	ld	a4,0(a4)
    80000ae6:	4685                	li	a3,1
    80000ae8:	06e6e963          	bltu	a3,a4,80000b5a <kfree+0xbe>
    80000aec:	e04a                	sd	s2,0(sp)
    ref_counter[page_num]--;
    release(&kmem.lock);
    return;
  }
  ref_counter[page_num] = 0; // insurance
    80000aee:	078e                	slli	a5,a5,0x3
    80000af0:	00014717          	auipc	a4,0x14
    80000af4:	32070713          	addi	a4,a4,800 # 80014e10 <ref_counter>
    80000af8:	97ba                	add	a5,a5,a4
    80000afa:	0007b023          	sd	zero,0(a5)
  release(&kmem.lock);
    80000afe:	00014917          	auipc	s2,0x14
    80000b02:	2f290913          	addi	s2,s2,754 # 80014df0 <kmem>
    80000b06:	854a                	mv	a0,s2
    80000b08:	00000097          	auipc	ra,0x0
    80000b0c:	2be080e7          	jalr	702(ra) # 80000dc6 <release>

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000b10:	6605                	lui	a2,0x1
    80000b12:	4585                	li	a1,1
    80000b14:	8526                	mv	a0,s1
    80000b16:	00000097          	auipc	ra,0x0
    80000b1a:	2f8080e7          	jalr	760(ra) # 80000e0e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000b1e:	854a                	mv	a0,s2
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	1f6080e7          	jalr	502(ra) # 80000d16 <acquire>
  r->next = kmem.freelist;
    80000b28:	01893783          	ld	a5,24(s2)
    80000b2c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000b2e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000b32:	854a                	mv	a0,s2
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	292080e7          	jalr	658(ra) # 80000dc6 <release>
    80000b3c:	6902                	ld	s2,0(sp)
}
    80000b3e:	60e2                	ld	ra,24(sp)
    80000b40:	6442                	ld	s0,16(sp)
    80000b42:	64a2                	ld	s1,8(sp)
    80000b44:	6105                	addi	sp,sp,32
    80000b46:	8082                	ret
    80000b48:	e04a                	sd	s2,0(sp)
    panic("kfree");
    80000b4a:	00008517          	auipc	a0,0x8
    80000b4e:	4f650513          	addi	a0,a0,1270 # 80009040 <etext+0x40>
    80000b52:	00000097          	auipc	ra,0x0
    80000b56:	a0e080e7          	jalr	-1522(ra) # 80000560 <panic>
    ref_counter[page_num]--;
    80000b5a:	078e                	slli	a5,a5,0x3
    80000b5c:	00014697          	auipc	a3,0x14
    80000b60:	2b468693          	addi	a3,a3,692 # 80014e10 <ref_counter>
    80000b64:	97b6                	add	a5,a5,a3
    80000b66:	177d                	addi	a4,a4,-1
    80000b68:	e398                	sd	a4,0(a5)
    release(&kmem.lock);
    80000b6a:	00014517          	auipc	a0,0x14
    80000b6e:	28650513          	addi	a0,a0,646 # 80014df0 <kmem>
    80000b72:	00000097          	auipc	ra,0x0
    80000b76:	254080e7          	jalr	596(ra) # 80000dc6 <release>
    return;
    80000b7a:	b7d1                	j	80000b3e <kfree+0xa2>

0000000080000b7c <freerange>:
{
    80000b7c:	7179                	addi	sp,sp,-48
    80000b7e:	f406                	sd	ra,40(sp)
    80000b80:	f022                	sd	s0,32(sp)
    80000b82:	ec26                	sd	s1,24(sp)
    80000b84:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b86:	6785                	lui	a5,0x1
    80000b88:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b8c:	00e504b3          	add	s1,a0,a4
    80000b90:	777d                	lui	a4,0xfffff
    80000b92:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b94:	94be                	add	s1,s1,a5
    80000b96:	0295e463          	bltu	a1,s1,80000bbe <freerange+0x42>
    80000b9a:	e84a                	sd	s2,16(sp)
    80000b9c:	e44e                	sd	s3,8(sp)
    80000b9e:	e052                	sd	s4,0(sp)
    80000ba0:	892e                	mv	s2,a1
    kfree(p);
    80000ba2:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ba4:	89be                	mv	s3,a5
    kfree(p);
    80000ba6:	01448533          	add	a0,s1,s4
    80000baa:	00000097          	auipc	ra,0x0
    80000bae:	ef2080e7          	jalr	-270(ra) # 80000a9c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000bb2:	94ce                	add	s1,s1,s3
    80000bb4:	fe9979e3          	bgeu	s2,s1,80000ba6 <freerange+0x2a>
    80000bb8:	6942                	ld	s2,16(sp)
    80000bba:	69a2                	ld	s3,8(sp)
    80000bbc:	6a02                	ld	s4,0(sp)
}
    80000bbe:	70a2                	ld	ra,40(sp)
    80000bc0:	7402                	ld	s0,32(sp)
    80000bc2:	64e2                	ld	s1,24(sp)
    80000bc4:	6145                	addi	sp,sp,48
    80000bc6:	8082                	ret

0000000080000bc8 <kinit>:
{
    80000bc8:	1141                	addi	sp,sp,-16
    80000bca:	e406                	sd	ra,8(sp)
    80000bcc:	e022                	sd	s0,0(sp)
    80000bce:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000bd0:	00008597          	auipc	a1,0x8
    80000bd4:	47858593          	addi	a1,a1,1144 # 80009048 <etext+0x48>
    80000bd8:	00014517          	auipc	a0,0x14
    80000bdc:	21850513          	addi	a0,a0,536 # 80014df0 <kmem>
    80000be0:	00000097          	auipc	ra,0x0
    80000be4:	0a2080e7          	jalr	162(ra) # 80000c82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000be8:	45c5                	li	a1,17
    80000bea:	05ee                	slli	a1,a1,0x1b
    80000bec:	0006d517          	auipc	a0,0x6d
    80000bf0:	6ac50513          	addi	a0,a0,1708 # 8006e298 <end>
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	f88080e7          	jalr	-120(ra) # 80000b7c <freerange>
}
    80000bfc:	60a2                	ld	ra,8(sp)
    80000bfe:	6402                	ld	s0,0(sp)
    80000c00:	0141                	addi	sp,sp,16
    80000c02:	8082                	ret

0000000080000c04 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000c04:	1101                	addi	sp,sp,-32
    80000c06:	ec06                	sd	ra,24(sp)
    80000c08:	e822                	sd	s0,16(sp)
    80000c0a:	e426                	sd	s1,8(sp)
    80000c0c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000c0e:	00014497          	auipc	s1,0x14
    80000c12:	1e248493          	addi	s1,s1,482 # 80014df0 <kmem>
    80000c16:	8526                	mv	a0,s1
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	0fe080e7          	jalr	254(ra) # 80000d16 <acquire>

  r = kmem.freelist;
    80000c20:	6c84                	ld	s1,24(s1)
  if(r)
    80000c22:	c0b1                	beqz	s1,80000c66 <kalloc+0x62>
    kmem.freelist = r->next;
    80000c24:	609c                	ld	a5,0(s1)
    80000c26:	00014517          	auipc	a0,0x14
    80000c2a:	1ca50513          	addi	a0,a0,458 # 80014df0 <kmem>
    80000c2e:	ed1c                	sd	a5,24(a0)
  uint64 page_num = PGROUNDDOWN((uint64)r)/PGSIZE;
    80000c30:	00c4d713          	srli	a4,s1,0xc
  ref_counter[page_num] = 1;
    80000c34:	070e                	slli	a4,a4,0x3
    80000c36:	00014797          	auipc	a5,0x14
    80000c3a:	1da78793          	addi	a5,a5,474 # 80014e10 <ref_counter>
    80000c3e:	97ba                	add	a5,a5,a4
    80000c40:	4705                	li	a4,1
    80000c42:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000c44:	00000097          	auipc	ra,0x0
    80000c48:	182080e7          	jalr	386(ra) # 80000dc6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000c4c:	6605                	lui	a2,0x1
    80000c4e:	4595                	li	a1,5
    80000c50:	8526                	mv	a0,s1
    80000c52:	00000097          	auipc	ra,0x0
    80000c56:	1bc080e7          	jalr	444(ra) # 80000e0e <memset>
  return (void*)r;
}
    80000c5a:	8526                	mv	a0,s1
    80000c5c:	60e2                	ld	ra,24(sp)
    80000c5e:	6442                	ld	s0,16(sp)
    80000c60:	64a2                	ld	s1,8(sp)
    80000c62:	6105                	addi	sp,sp,32
    80000c64:	8082                	ret
  ref_counter[page_num] = 1;
    80000c66:	4785                	li	a5,1
    80000c68:	00014717          	auipc	a4,0x14
    80000c6c:	1af73423          	sd	a5,424(a4) # 80014e10 <ref_counter>
  release(&kmem.lock);
    80000c70:	00014517          	auipc	a0,0x14
    80000c74:	18050513          	addi	a0,a0,384 # 80014df0 <kmem>
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	14e080e7          	jalr	334(ra) # 80000dc6 <release>
  if(r)
    80000c80:	bfe9                	j	80000c5a <kalloc+0x56>

0000000080000c82 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c82:	1141                	addi	sp,sp,-16
    80000c84:	e406                	sd	ra,8(sp)
    80000c86:	e022                	sd	s0,0(sp)
    80000c88:	0800                	addi	s0,sp,16
  lk->name = name;
    80000c8a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c8c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c90:	00053823          	sd	zero,16(a0)
}
    80000c94:	60a2                	ld	ra,8(sp)
    80000c96:	6402                	ld	s0,0(sp)
    80000c98:	0141                	addi	sp,sp,16
    80000c9a:	8082                	ret

0000000080000c9c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c9c:	411c                	lw	a5,0(a0)
    80000c9e:	e399                	bnez	a5,80000ca4 <holding+0x8>
    80000ca0:	4501                	li	a0,0
  return r;
}
    80000ca2:	8082                	ret
{
    80000ca4:	1101                	addi	sp,sp,-32
    80000ca6:	ec06                	sd	ra,24(sp)
    80000ca8:	e822                	sd	s0,16(sp)
    80000caa:	e426                	sd	s1,8(sp)
    80000cac:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000cae:	6904                	ld	s1,16(a0)
    80000cb0:	00001097          	auipc	ra,0x1
    80000cb4:	252080e7          	jalr	594(ra) # 80001f02 <mycpu>
    80000cb8:	40a48533          	sub	a0,s1,a0
    80000cbc:	00153513          	seqz	a0,a0
}
    80000cc0:	60e2                	ld	ra,24(sp)
    80000cc2:	6442                	ld	s0,16(sp)
    80000cc4:	64a2                	ld	s1,8(sp)
    80000cc6:	6105                	addi	sp,sp,32
    80000cc8:	8082                	ret

0000000080000cca <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000cca:	1101                	addi	sp,sp,-32
    80000ccc:	ec06                	sd	ra,24(sp)
    80000cce:	e822                	sd	s0,16(sp)
    80000cd0:	e426                	sd	s1,8(sp)
    80000cd2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cd4:	100024f3          	csrr	s1,sstatus
    80000cd8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000cdc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cde:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000ce2:	00001097          	auipc	ra,0x1
    80000ce6:	220080e7          	jalr	544(ra) # 80001f02 <mycpu>
    80000cea:	5d3c                	lw	a5,120(a0)
    80000cec:	cf89                	beqz	a5,80000d06 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000cee:	00001097          	auipc	ra,0x1
    80000cf2:	214080e7          	jalr	532(ra) # 80001f02 <mycpu>
    80000cf6:	5d3c                	lw	a5,120(a0)
    80000cf8:	2785                	addiw	a5,a5,1
    80000cfa:	dd3c                	sw	a5,120(a0)
}
    80000cfc:	60e2                	ld	ra,24(sp)
    80000cfe:	6442                	ld	s0,16(sp)
    80000d00:	64a2                	ld	s1,8(sp)
    80000d02:	6105                	addi	sp,sp,32
    80000d04:	8082                	ret
    mycpu()->intena = old;
    80000d06:	00001097          	auipc	ra,0x1
    80000d0a:	1fc080e7          	jalr	508(ra) # 80001f02 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000d0e:	8085                	srli	s1,s1,0x1
    80000d10:	8885                	andi	s1,s1,1
    80000d12:	dd64                	sw	s1,124(a0)
    80000d14:	bfe9                	j	80000cee <push_off+0x24>

0000000080000d16 <acquire>:
{
    80000d16:	1101                	addi	sp,sp,-32
    80000d18:	ec06                	sd	ra,24(sp)
    80000d1a:	e822                	sd	s0,16(sp)
    80000d1c:	e426                	sd	s1,8(sp)
    80000d1e:	1000                	addi	s0,sp,32
    80000d20:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d22:	00000097          	auipc	ra,0x0
    80000d26:	fa8080e7          	jalr	-88(ra) # 80000cca <push_off>
  if(holding(lk))
    80000d2a:	8526                	mv	a0,s1
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	f70080e7          	jalr	-144(ra) # 80000c9c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d34:	4705                	li	a4,1
  if(holding(lk))
    80000d36:	e115                	bnez	a0,80000d5a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d38:	87ba                	mv	a5,a4
    80000d3a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d3e:	2781                	sext.w	a5,a5
    80000d40:	ffe5                	bnez	a5,80000d38 <acquire+0x22>
  __sync_synchronize();
    80000d42:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000d46:	00001097          	auipc	ra,0x1
    80000d4a:	1bc080e7          	jalr	444(ra) # 80001f02 <mycpu>
    80000d4e:	e888                	sd	a0,16(s1)
}
    80000d50:	60e2                	ld	ra,24(sp)
    80000d52:	6442                	ld	s0,16(sp)
    80000d54:	64a2                	ld	s1,8(sp)
    80000d56:	6105                	addi	sp,sp,32
    80000d58:	8082                	ret
    panic("acquire");
    80000d5a:	00008517          	auipc	a0,0x8
    80000d5e:	2f650513          	addi	a0,a0,758 # 80009050 <etext+0x50>
    80000d62:	fffff097          	auipc	ra,0xfffff
    80000d66:	7fe080e7          	jalr	2046(ra) # 80000560 <panic>

0000000080000d6a <pop_off>:

void
pop_off(void)
{
    80000d6a:	1141                	addi	sp,sp,-16
    80000d6c:	e406                	sd	ra,8(sp)
    80000d6e:	e022                	sd	s0,0(sp)
    80000d70:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d72:	00001097          	auipc	ra,0x1
    80000d76:	190080e7          	jalr	400(ra) # 80001f02 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d7a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d7e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d80:	e39d                	bnez	a5,80000da6 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d82:	5d3c                	lw	a5,120(a0)
    80000d84:	02f05963          	blez	a5,80000db6 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000d88:	37fd                	addiw	a5,a5,-1
    80000d8a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d8c:	eb89                	bnez	a5,80000d9e <pop_off+0x34>
    80000d8e:	5d7c                	lw	a5,124(a0)
    80000d90:	c799                	beqz	a5,80000d9e <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d92:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000d96:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d9a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000d9e:	60a2                	ld	ra,8(sp)
    80000da0:	6402                	ld	s0,0(sp)
    80000da2:	0141                	addi	sp,sp,16
    80000da4:	8082                	ret
    panic("pop_off - interruptible");
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	2b250513          	addi	a0,a0,690 # 80009058 <etext+0x58>
    80000dae:	fffff097          	auipc	ra,0xfffff
    80000db2:	7b2080e7          	jalr	1970(ra) # 80000560 <panic>
    panic("pop_off");
    80000db6:	00008517          	auipc	a0,0x8
    80000dba:	2ba50513          	addi	a0,a0,698 # 80009070 <etext+0x70>
    80000dbe:	fffff097          	auipc	ra,0xfffff
    80000dc2:	7a2080e7          	jalr	1954(ra) # 80000560 <panic>

0000000080000dc6 <release>:
{
    80000dc6:	1101                	addi	sp,sp,-32
    80000dc8:	ec06                	sd	ra,24(sp)
    80000dca:	e822                	sd	s0,16(sp)
    80000dcc:	e426                	sd	s1,8(sp)
    80000dce:	1000                	addi	s0,sp,32
    80000dd0:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000dd2:	00000097          	auipc	ra,0x0
    80000dd6:	eca080e7          	jalr	-310(ra) # 80000c9c <holding>
    80000dda:	c115                	beqz	a0,80000dfe <release+0x38>
  lk->cpu = 0;
    80000ddc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000de0:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000de4:	0310000f          	fence	rw,w
    80000de8:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000dec:	00000097          	auipc	ra,0x0
    80000df0:	f7e080e7          	jalr	-130(ra) # 80000d6a <pop_off>
}
    80000df4:	60e2                	ld	ra,24(sp)
    80000df6:	6442                	ld	s0,16(sp)
    80000df8:	64a2                	ld	s1,8(sp)
    80000dfa:	6105                	addi	sp,sp,32
    80000dfc:	8082                	ret
    panic("release");
    80000dfe:	00008517          	auipc	a0,0x8
    80000e02:	27a50513          	addi	a0,a0,634 # 80009078 <etext+0x78>
    80000e06:	fffff097          	auipc	ra,0xfffff
    80000e0a:	75a080e7          	jalr	1882(ra) # 80000560 <panic>

0000000080000e0e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e406                	sd	ra,8(sp)
    80000e12:	e022                	sd	s0,0(sp)
    80000e14:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e16:	ca19                	beqz	a2,80000e2c <memset+0x1e>
    80000e18:	87aa                	mv	a5,a0
    80000e1a:	1602                	slli	a2,a2,0x20
    80000e1c:	9201                	srli	a2,a2,0x20
    80000e1e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e22:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e26:	0785                	addi	a5,a5,1
    80000e28:	fee79de3          	bne	a5,a4,80000e22 <memset+0x14>
  }
  return dst;
}
    80000e2c:	60a2                	ld	ra,8(sp)
    80000e2e:	6402                	ld	s0,0(sp)
    80000e30:	0141                	addi	sp,sp,16
    80000e32:	8082                	ret

0000000080000e34 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e34:	1141                	addi	sp,sp,-16
    80000e36:	e406                	sd	ra,8(sp)
    80000e38:	e022                	sd	s0,0(sp)
    80000e3a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e3c:	ca0d                	beqz	a2,80000e6e <memcmp+0x3a>
    80000e3e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000e42:	1682                	slli	a3,a3,0x20
    80000e44:	9281                	srli	a3,a3,0x20
    80000e46:	0685                	addi	a3,a3,1
    80000e48:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e4a:	00054783          	lbu	a5,0(a0)
    80000e4e:	0005c703          	lbu	a4,0(a1)
    80000e52:	00e79863          	bne	a5,a4,80000e62 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000e56:	0505                	addi	a0,a0,1
    80000e58:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e5a:	fed518e3          	bne	a0,a3,80000e4a <memcmp+0x16>
  }

  return 0;
    80000e5e:	4501                	li	a0,0
    80000e60:	a019                	j	80000e66 <memcmp+0x32>
      return *s1 - *s2;
    80000e62:	40e7853b          	subw	a0,a5,a4
}
    80000e66:	60a2                	ld	ra,8(sp)
    80000e68:	6402                	ld	s0,0(sp)
    80000e6a:	0141                	addi	sp,sp,16
    80000e6c:	8082                	ret
  return 0;
    80000e6e:	4501                	li	a0,0
    80000e70:	bfdd                	j	80000e66 <memcmp+0x32>

0000000080000e72 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e72:	1141                	addi	sp,sp,-16
    80000e74:	e406                	sd	ra,8(sp)
    80000e76:	e022                	sd	s0,0(sp)
    80000e78:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e7a:	c205                	beqz	a2,80000e9a <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e7c:	02a5e363          	bltu	a1,a0,80000ea2 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e80:	1602                	slli	a2,a2,0x20
    80000e82:	9201                	srli	a2,a2,0x20
    80000e84:	00c587b3          	add	a5,a1,a2
{
    80000e88:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e8a:	0585                	addi	a1,a1,1
    80000e8c:	0705                	addi	a4,a4,1
    80000e8e:	fff5c683          	lbu	a3,-1(a1)
    80000e92:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e96:	feb79ae3          	bne	a5,a1,80000e8a <memmove+0x18>

  return dst;
}
    80000e9a:	60a2                	ld	ra,8(sp)
    80000e9c:	6402                	ld	s0,0(sp)
    80000e9e:	0141                	addi	sp,sp,16
    80000ea0:	8082                	ret
  if(s < d && s + n > d){
    80000ea2:	02061693          	slli	a3,a2,0x20
    80000ea6:	9281                	srli	a3,a3,0x20
    80000ea8:	00d58733          	add	a4,a1,a3
    80000eac:	fce57ae3          	bgeu	a0,a4,80000e80 <memmove+0xe>
    d += n;
    80000eb0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000eb2:	fff6079b          	addiw	a5,a2,-1
    80000eb6:	1782                	slli	a5,a5,0x20
    80000eb8:	9381                	srli	a5,a5,0x20
    80000eba:	fff7c793          	not	a5,a5
    80000ebe:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000ec0:	177d                	addi	a4,a4,-1
    80000ec2:	16fd                	addi	a3,a3,-1
    80000ec4:	00074603          	lbu	a2,0(a4)
    80000ec8:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000ecc:	fee79ae3          	bne	a5,a4,80000ec0 <memmove+0x4e>
    80000ed0:	b7e9                	j	80000e9a <memmove+0x28>

0000000080000ed2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000ed2:	1141                	addi	sp,sp,-16
    80000ed4:	e406                	sd	ra,8(sp)
    80000ed6:	e022                	sd	s0,0(sp)
    80000ed8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000eda:	00000097          	auipc	ra,0x0
    80000ede:	f98080e7          	jalr	-104(ra) # 80000e72 <memmove>
}
    80000ee2:	60a2                	ld	ra,8(sp)
    80000ee4:	6402                	ld	s0,0(sp)
    80000ee6:	0141                	addi	sp,sp,16
    80000ee8:	8082                	ret

0000000080000eea <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000eea:	1141                	addi	sp,sp,-16
    80000eec:	e406                	sd	ra,8(sp)
    80000eee:	e022                	sd	s0,0(sp)
    80000ef0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000ef2:	ce11                	beqz	a2,80000f0e <strncmp+0x24>
    80000ef4:	00054783          	lbu	a5,0(a0)
    80000ef8:	cf89                	beqz	a5,80000f12 <strncmp+0x28>
    80000efa:	0005c703          	lbu	a4,0(a1)
    80000efe:	00f71a63          	bne	a4,a5,80000f12 <strncmp+0x28>
    n--, p++, q++;
    80000f02:	367d                	addiw	a2,a2,-1
    80000f04:	0505                	addi	a0,a0,1
    80000f06:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000f08:	f675                	bnez	a2,80000ef4 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000f0a:	4501                	li	a0,0
    80000f0c:	a801                	j	80000f1c <strncmp+0x32>
    80000f0e:	4501                	li	a0,0
    80000f10:	a031                	j	80000f1c <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000f12:	00054503          	lbu	a0,0(a0)
    80000f16:	0005c783          	lbu	a5,0(a1)
    80000f1a:	9d1d                	subw	a0,a0,a5
}
    80000f1c:	60a2                	ld	ra,8(sp)
    80000f1e:	6402                	ld	s0,0(sp)
    80000f20:	0141                	addi	sp,sp,16
    80000f22:	8082                	ret

0000000080000f24 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f24:	1141                	addi	sp,sp,-16
    80000f26:	e406                	sd	ra,8(sp)
    80000f28:	e022                	sd	s0,0(sp)
    80000f2a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f2c:	87aa                	mv	a5,a0
    80000f2e:	86b2                	mv	a3,a2
    80000f30:	367d                	addiw	a2,a2,-1
    80000f32:	02d05563          	blez	a3,80000f5c <strncpy+0x38>
    80000f36:	0785                	addi	a5,a5,1
    80000f38:	0005c703          	lbu	a4,0(a1)
    80000f3c:	fee78fa3          	sb	a4,-1(a5)
    80000f40:	0585                	addi	a1,a1,1
    80000f42:	f775                	bnez	a4,80000f2e <strncpy+0xa>
    ;
  while(n-- > 0)
    80000f44:	873e                	mv	a4,a5
    80000f46:	00c05b63          	blez	a2,80000f5c <strncpy+0x38>
    80000f4a:	9fb5                	addw	a5,a5,a3
    80000f4c:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000f4e:	0705                	addi	a4,a4,1
    80000f50:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000f54:	40e786bb          	subw	a3,a5,a4
    80000f58:	fed04be3          	bgtz	a3,80000f4e <strncpy+0x2a>
  return os;
}
    80000f5c:	60a2                	ld	ra,8(sp)
    80000f5e:	6402                	ld	s0,0(sp)
    80000f60:	0141                	addi	sp,sp,16
    80000f62:	8082                	ret

0000000080000f64 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f64:	1141                	addi	sp,sp,-16
    80000f66:	e406                	sd	ra,8(sp)
    80000f68:	e022                	sd	s0,0(sp)
    80000f6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f6c:	02c05363          	blez	a2,80000f92 <safestrcpy+0x2e>
    80000f70:	fff6069b          	addiw	a3,a2,-1
    80000f74:	1682                	slli	a3,a3,0x20
    80000f76:	9281                	srli	a3,a3,0x20
    80000f78:	96ae                	add	a3,a3,a1
    80000f7a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f7c:	00d58963          	beq	a1,a3,80000f8e <safestrcpy+0x2a>
    80000f80:	0585                	addi	a1,a1,1
    80000f82:	0785                	addi	a5,a5,1
    80000f84:	fff5c703          	lbu	a4,-1(a1)
    80000f88:	fee78fa3          	sb	a4,-1(a5)
    80000f8c:	fb65                	bnez	a4,80000f7c <safestrcpy+0x18>
    ;
  *s = 0;
    80000f8e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f92:	60a2                	ld	ra,8(sp)
    80000f94:	6402                	ld	s0,0(sp)
    80000f96:	0141                	addi	sp,sp,16
    80000f98:	8082                	ret

0000000080000f9a <strlen>:

int
strlen(const char *s)
{
    80000f9a:	1141                	addi	sp,sp,-16
    80000f9c:	e406                	sd	ra,8(sp)
    80000f9e:	e022                	sd	s0,0(sp)
    80000fa0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000fa2:	00054783          	lbu	a5,0(a0)
    80000fa6:	cf99                	beqz	a5,80000fc4 <strlen+0x2a>
    80000fa8:	0505                	addi	a0,a0,1
    80000faa:	87aa                	mv	a5,a0
    80000fac:	86be                	mv	a3,a5
    80000fae:	0785                	addi	a5,a5,1
    80000fb0:	fff7c703          	lbu	a4,-1(a5)
    80000fb4:	ff65                	bnez	a4,80000fac <strlen+0x12>
    80000fb6:	40a6853b          	subw	a0,a3,a0
    80000fba:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000fbc:	60a2                	ld	ra,8(sp)
    80000fbe:	6402                	ld	s0,0(sp)
    80000fc0:	0141                	addi	sp,sp,16
    80000fc2:	8082                	ret
  for(n = 0; s[n]; n++)
    80000fc4:	4501                	li	a0,0
    80000fc6:	bfdd                	j	80000fbc <strlen+0x22>

0000000080000fc8 <transmit_pkt_test1>:
#include "riscv.h"
#include "defs.h"

volatile static int started = 0;

void transmit_pkt_test1() {
    80000fc8:	1141                	addi	sp,sp,-16
    80000fca:	e406                	sd	ra,8(sp)
    80000fcc:	e022                	sd	s0,0(sp)
    80000fce:	0800                	addi	s0,sp,16
  char *pkt1_str = "Hello, world!";
  uint16 pkt1_len = strlen(pkt1_str);
    80000fd0:	00008517          	auipc	a0,0x8
    80000fd4:	0b050513          	addi	a0,a0,176 # 80009080 <etext+0x80>
    80000fd8:	00000097          	auipc	ra,0x0
    80000fdc:	fc2080e7          	jalr	-62(ra) # 80000f9a <strlen>
  transmit_packet(pkt1_str, pkt1_len, 0x7a05);
    80000fe0:	6621                	lui	a2,0x8
    80000fe2:	a0560613          	addi	a2,a2,-1531 # 7a05 <_entry-0x7fff85fb>
    80000fe6:	03051593          	slli	a1,a0,0x30
    80000fea:	91c1                	srli	a1,a1,0x30
    80000fec:	00008517          	auipc	a0,0x8
    80000ff0:	09450513          	addi	a0,a0,148 # 80009080 <etext+0x80>
    80000ff4:	00006097          	auipc	ra,0x6
    80000ff8:	524080e7          	jalr	1316(ra) # 80007518 <transmit_packet>
  printf("finished transmit_packet test 1\n");
    80000ffc:	00008517          	auipc	a0,0x8
    80001000:	09450513          	addi	a0,a0,148 # 80009090 <etext+0x90>
    80001004:	fffff097          	auipc	ra,0xfffff
    80001008:	5a6080e7          	jalr	1446(ra) # 800005aa <printf>
}
    8000100c:	60a2                	ld	ra,8(sp)
    8000100e:	6402                	ld	s0,0(sp)
    80001010:	0141                	addi	sp,sp,16
    80001012:	8082                	ret

0000000080001014 <transmit_pkt_test2>:

void transmit_pkt_test2() {
    80001014:	1101                	addi	sp,sp,-32
    80001016:	ec06                	sd	ra,24(sp)
    80001018:	e822                	sd	s0,16(sp)
    8000101a:	e426                	sd	s1,8(sp)
    8000101c:	e04a                	sd	s2,0(sp)
    8000101e:	1000                	addi	s0,sp,32
  char *pkt1_str = "Hello, world!";
  uint16 pkt1_len = strlen(pkt1_str);
    80001020:	00008517          	auipc	a0,0x8
    80001024:	06050513          	addi	a0,a0,96 # 80009080 <etext+0x80>
    80001028:	00000097          	auipc	ra,0x0
    8000102c:	f72080e7          	jalr	-142(ra) # 80000f9a <strlen>
    80001030:	892a                	mv	s2,a0
  char *pkt2_str = "Goodbye, world!";
  uint16 pkt2_len = strlen(pkt2_str);
    80001032:	00008517          	auipc	a0,0x8
    80001036:	08650513          	addi	a0,a0,134 # 800090b8 <etext+0xb8>
    8000103a:	00000097          	auipc	ra,0x0
    8000103e:	f60080e7          	jalr	-160(ra) # 80000f9a <strlen>
    80001042:	84aa                	mv	s1,a0
  transmit_packet(pkt1_str, pkt1_len, 0x7a05);
    80001044:	6621                	lui	a2,0x8
    80001046:	a0560613          	addi	a2,a2,-1531 # 7a05 <_entry-0x7fff85fb>
    8000104a:	03091593          	slli	a1,s2,0x30
    8000104e:	91c1                	srli	a1,a1,0x30
    80001050:	00008517          	auipc	a0,0x8
    80001054:	03050513          	addi	a0,a0,48 # 80009080 <etext+0x80>
    80001058:	00006097          	auipc	ra,0x6
    8000105c:	4c0080e7          	jalr	1216(ra) # 80007518 <transmit_packet>
  transmit_packet(pkt2_str, pkt2_len, 0x7a05);
    80001060:	6621                	lui	a2,0x8
    80001062:	a0560613          	addi	a2,a2,-1531 # 7a05 <_entry-0x7fff85fb>
    80001066:	03049593          	slli	a1,s1,0x30
    8000106a:	91c1                	srli	a1,a1,0x30
    8000106c:	00008517          	auipc	a0,0x8
    80001070:	04c50513          	addi	a0,a0,76 # 800090b8 <etext+0xb8>
    80001074:	00006097          	auipc	ra,0x6
    80001078:	4a4080e7          	jalr	1188(ra) # 80007518 <transmit_packet>
  printf("finished transmit_packet test 2\n");
    8000107c:	00008517          	auipc	a0,0x8
    80001080:	04c50513          	addi	a0,a0,76 # 800090c8 <etext+0xc8>
    80001084:	fffff097          	auipc	ra,0xfffff
    80001088:	526080e7          	jalr	1318(ra) # 800005aa <printf>
}
    8000108c:	60e2                	ld	ra,24(sp)
    8000108e:	6442                	ld	s0,16(sp)
    80001090:	64a2                	ld	s1,8(sp)
    80001092:	6902                	ld	s2,0(sp)
    80001094:	6105                	addi	sp,sp,32
    80001096:	8082                	ret

0000000080001098 <main>:
// }

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001098:	1141                	addi	sp,sp,-16
    8000109a:	e406                	sd	ra,8(sp)
    8000109c:	e022                	sd	s0,0(sp)
    8000109e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800010a0:	00001097          	auipc	ra,0x1
    800010a4:	e4e080e7          	jalr	-434(ra) # 80001eee <cpuid>
    // transmit_pkt_test2();
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800010a8:	0000c717          	auipc	a4,0xc
    800010ac:	ae070713          	addi	a4,a4,-1312 # 8000cb88 <started>
  if(cpuid() == 0){
    800010b0:	c139                	beqz	a0,800010f6 <main+0x5e>
    while(started == 0)
    800010b2:	431c                	lw	a5,0(a4)
    800010b4:	2781                	sext.w	a5,a5
    800010b6:	dff5                	beqz	a5,800010b2 <main+0x1a>
      ;
    __sync_synchronize();
    800010b8:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800010bc:	00001097          	auipc	ra,0x1
    800010c0:	e32080e7          	jalr	-462(ra) # 80001eee <cpuid>
    800010c4:	85aa                	mv	a1,a0
    800010c6:	00008517          	auipc	a0,0x8
    800010ca:	04250513          	addi	a0,a0,66 # 80009108 <etext+0x108>
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	4dc080e7          	jalr	1244(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    800010d6:	00000097          	auipc	ra,0x0
    800010da:	0e8080e7          	jalr	232(ra) # 800011be <kvminithart>
    trapinithart();   // install kernel trap vector
    800010de:	00002097          	auipc	ra,0x2
    800010e2:	020080e7          	jalr	32(ra) # 800030fe <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800010e6:	00006097          	auipc	ra,0x6
    800010ea:	950080e7          	jalr	-1712(ra) # 80006a36 <plicinithart>
  }

  scheduler();        
    800010ee:	00001097          	auipc	ra,0x1
    800010f2:	58a080e7          	jalr	1418(ra) # 80002678 <scheduler>
    consoleinit();
    800010f6:	fffff097          	auipc	ra,0xfffff
    800010fa:	38c080e7          	jalr	908(ra) # 80000482 <consoleinit>
    printfinit();
    800010fe:	fffff097          	auipc	ra,0xfffff
    80001102:	6b6080e7          	jalr	1718(ra) # 800007b4 <printfinit>
    printf("\n");
    80001106:	00008517          	auipc	a0,0x8
    8000110a:	f0a50513          	addi	a0,a0,-246 # 80009010 <etext+0x10>
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	49c080e7          	jalr	1180(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80001116:	00008517          	auipc	a0,0x8
    8000111a:	fda50513          	addi	a0,a0,-38 # 800090f0 <etext+0xf0>
    8000111e:	fffff097          	auipc	ra,0xfffff
    80001122:	48c080e7          	jalr	1164(ra) # 800005aa <printf>
    printf("\n");
    80001126:	00008517          	auipc	a0,0x8
    8000112a:	eea50513          	addi	a0,a0,-278 # 80009010 <etext+0x10>
    8000112e:	fffff097          	auipc	ra,0xfffff
    80001132:	47c080e7          	jalr	1148(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	a92080e7          	jalr	-1390(ra) # 80000bc8 <kinit>
    kvminit();       // create kernel page table
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	34e080e7          	jalr	846(ra) # 8000148c <kvminit>
    kvminithart();   // turn on paging
    80001146:	00000097          	auipc	ra,0x0
    8000114a:	078080e7          	jalr	120(ra) # 800011be <kvminithart>
    procinit();      // process table
    8000114e:	00001097          	auipc	ra,0x1
    80001152:	ce4080e7          	jalr	-796(ra) # 80001e32 <procinit>
    trapinit();      // trap vectors
    80001156:	00002097          	auipc	ra,0x2
    8000115a:	f80080e7          	jalr	-128(ra) # 800030d6 <trapinit>
    trapinithart();  // install kernel trap vector
    8000115e:	00002097          	auipc	ra,0x2
    80001162:	fa0080e7          	jalr	-96(ra) # 800030fe <trapinithart>
    plicinit();      // set up interrupt controller
    80001166:	00006097          	auipc	ra,0x6
    8000116a:	8b4080e7          	jalr	-1868(ra) # 80006a1a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000116e:	00006097          	auipc	ra,0x6
    80001172:	8c8080e7          	jalr	-1848(ra) # 80006a36 <plicinithart>
    binit();         // buffer cache
    80001176:	00003097          	auipc	ra,0x3
    8000117a:	950080e7          	jalr	-1712(ra) # 80003ac6 <binit>
    iinit();         // inode table
    8000117e:	00003097          	auipc	ra,0x3
    80001182:	fe0080e7          	jalr	-32(ra) # 8000415e <iinit>
    fileinit();      // file table
    80001186:	00004097          	auipc	ra,0x4
    8000118a:	fb2080e7          	jalr	-78(ra) # 80005138 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000118e:	00006097          	auipc	ra,0x6
    80001192:	9b0080e7          	jalr	-1616(ra) # 80006b3e <virtio_disk_init>
    virtio_net_init(); // emulated NIC driver 
    80001196:	00006097          	auipc	ra,0x6
    8000119a:	f1a080e7          	jalr	-230(ra) # 800070b0 <virtio_net_init>
    transmit_pkt_test1();
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	e2a080e7          	jalr	-470(ra) # 80000fc8 <transmit_pkt_test1>
    userinit();      // first user process
    800011a6:	00001097          	auipc	ra,0x1
    800011aa:	066080e7          	jalr	102(ra) # 8000220c <userinit>
    __sync_synchronize();
    800011ae:	0330000f          	fence	rw,rw
    started = 1;
    800011b2:	4785                	li	a5,1
    800011b4:	0000c717          	auipc	a4,0xc
    800011b8:	9cf72a23          	sw	a5,-1580(a4) # 8000cb88 <started>
    800011bc:	bf0d                	j	800010ee <main+0x56>

00000000800011be <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800011be:	1141                	addi	sp,sp,-16
    800011c0:	e406                	sd	ra,8(sp)
    800011c2:	e022                	sd	s0,0(sp)
    800011c4:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800011c6:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800011ca:	0000c797          	auipc	a5,0xc
    800011ce:	9c67b783          	ld	a5,-1594(a5) # 8000cb90 <kernel_pagetable>
    800011d2:	83b1                	srli	a5,a5,0xc
    800011d4:	577d                	li	a4,-1
    800011d6:	177e                	slli	a4,a4,0x3f
    800011d8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800011da:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800011de:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800011e2:	60a2                	ld	ra,8(sp)
    800011e4:	6402                	ld	s0,0(sp)
    800011e6:	0141                	addi	sp,sp,16
    800011e8:	8082                	ret

00000000800011ea <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800011ea:	7139                	addi	sp,sp,-64
    800011ec:	fc06                	sd	ra,56(sp)
    800011ee:	f822                	sd	s0,48(sp)
    800011f0:	f426                	sd	s1,40(sp)
    800011f2:	f04a                	sd	s2,32(sp)
    800011f4:	ec4e                	sd	s3,24(sp)
    800011f6:	e852                	sd	s4,16(sp)
    800011f8:	e456                	sd	s5,8(sp)
    800011fa:	e05a                	sd	s6,0(sp)
    800011fc:	0080                	addi	s0,sp,64
    800011fe:	84aa                	mv	s1,a0
    80001200:	89ae                	mv	s3,a1
    80001202:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001204:	57fd                	li	a5,-1
    80001206:	83e9                	srli	a5,a5,0x1a
    80001208:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000120a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000120c:	04b7e263          	bltu	a5,a1,80001250 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80001210:	0149d933          	srl	s2,s3,s4
    80001214:	1ff97913          	andi	s2,s2,511
    80001218:	090e                	slli	s2,s2,0x3
    8000121a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000121c:	00093483          	ld	s1,0(s2)
    80001220:	0014f793          	andi	a5,s1,1
    80001224:	cf95                	beqz	a5,80001260 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001226:	80a9                	srli	s1,s1,0xa
    80001228:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    8000122a:	3a5d                	addiw	s4,s4,-9
    8000122c:	ff6a12e3          	bne	s4,s6,80001210 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80001230:	00c9d513          	srli	a0,s3,0xc
    80001234:	1ff57513          	andi	a0,a0,511
    80001238:	050e                	slli	a0,a0,0x3
    8000123a:	9526                	add	a0,a0,s1
}
    8000123c:	70e2                	ld	ra,56(sp)
    8000123e:	7442                	ld	s0,48(sp)
    80001240:	74a2                	ld	s1,40(sp)
    80001242:	7902                	ld	s2,32(sp)
    80001244:	69e2                	ld	s3,24(sp)
    80001246:	6a42                	ld	s4,16(sp)
    80001248:	6aa2                	ld	s5,8(sp)
    8000124a:	6b02                	ld	s6,0(sp)
    8000124c:	6121                	addi	sp,sp,64
    8000124e:	8082                	ret
    panic("walk");
    80001250:	00008517          	auipc	a0,0x8
    80001254:	ed050513          	addi	a0,a0,-304 # 80009120 <etext+0x120>
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	308080e7          	jalr	776(ra) # 80000560 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001260:	020a8663          	beqz	s5,8000128c <walk+0xa2>
    80001264:	00000097          	auipc	ra,0x0
    80001268:	9a0080e7          	jalr	-1632(ra) # 80000c04 <kalloc>
    8000126c:	84aa                	mv	s1,a0
    8000126e:	d579                	beqz	a0,8000123c <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80001270:	6605                	lui	a2,0x1
    80001272:	4581                	li	a1,0
    80001274:	00000097          	auipc	ra,0x0
    80001278:	b9a080e7          	jalr	-1126(ra) # 80000e0e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000127c:	00c4d793          	srli	a5,s1,0xc
    80001280:	07aa                	slli	a5,a5,0xa
    80001282:	0017e793          	ori	a5,a5,1
    80001286:	00f93023          	sd	a5,0(s2)
    8000128a:	b745                	j	8000122a <walk+0x40>
        return 0;
    8000128c:	4501                	li	a0,0
    8000128e:	b77d                	j	8000123c <walk+0x52>

0000000080001290 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001290:	57fd                	li	a5,-1
    80001292:	83e9                	srli	a5,a5,0x1a
    80001294:	00b7f463          	bgeu	a5,a1,8000129c <walkaddr+0xc>
    return 0;
    80001298:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000129a:	8082                	ret
{
    8000129c:	1141                	addi	sp,sp,-16
    8000129e:	e406                	sd	ra,8(sp)
    800012a0:	e022                	sd	s0,0(sp)
    800012a2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800012a4:	4601                	li	a2,0
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	f44080e7          	jalr	-188(ra) # 800011ea <walk>
  if(pte == 0)
    800012ae:	c105                	beqz	a0,800012ce <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800012b0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800012b2:	0117f693          	andi	a3,a5,17
    800012b6:	4745                	li	a4,17
    return 0;
    800012b8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800012ba:	00e68663          	beq	a3,a4,800012c6 <walkaddr+0x36>
}
    800012be:	60a2                	ld	ra,8(sp)
    800012c0:	6402                	ld	s0,0(sp)
    800012c2:	0141                	addi	sp,sp,16
    800012c4:	8082                	ret
  pa = PTE2PA(*pte);
    800012c6:	83a9                	srli	a5,a5,0xa
    800012c8:	00c79513          	slli	a0,a5,0xc
  return pa;
    800012cc:	bfcd                	j	800012be <walkaddr+0x2e>
    return 0;
    800012ce:	4501                	li	a0,0
    800012d0:	b7fd                	j	800012be <walkaddr+0x2e>

00000000800012d2 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800012d2:	715d                	addi	sp,sp,-80
    800012d4:	e486                	sd	ra,72(sp)
    800012d6:	e0a2                	sd	s0,64(sp)
    800012d8:	fc26                	sd	s1,56(sp)
    800012da:	f84a                	sd	s2,48(sp)
    800012dc:	f44e                	sd	s3,40(sp)
    800012de:	f052                	sd	s4,32(sp)
    800012e0:	ec56                	sd	s5,24(sp)
    800012e2:	e85a                	sd	s6,16(sp)
    800012e4:	e45e                	sd	s7,8(sp)
    800012e6:	e062                	sd	s8,0(sp)
    800012e8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800012ea:	ca21                	beqz	a2,8000133a <mappages+0x68>
    800012ec:	8aaa                	mv	s5,a0
    800012ee:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800012f0:	777d                	lui	a4,0xfffff
    800012f2:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800012f6:	fff58993          	addi	s3,a1,-1
    800012fa:	99b2                	add	s3,s3,a2
    800012fc:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001300:	893e                	mv	s2,a5
    80001302:	40f68a33          	sub	s4,a3,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001306:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001308:	6c05                	lui	s8,0x1
    8000130a:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000130e:	865e                	mv	a2,s7
    80001310:	85ca                	mv	a1,s2
    80001312:	8556                	mv	a0,s5
    80001314:	00000097          	auipc	ra,0x0
    80001318:	ed6080e7          	jalr	-298(ra) # 800011ea <walk>
    8000131c:	cd1d                	beqz	a0,8000135a <mappages+0x88>
    if(*pte & PTE_V)
    8000131e:	611c                	ld	a5,0(a0)
    80001320:	8b85                	andi	a5,a5,1
    80001322:	e785                	bnez	a5,8000134a <mappages+0x78>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001324:	80b1                	srli	s1,s1,0xc
    80001326:	04aa                	slli	s1,s1,0xa
    80001328:	0164e4b3          	or	s1,s1,s6
    8000132c:	0014e493          	ori	s1,s1,1
    80001330:	e104                	sd	s1,0(a0)
    if(a == last)
    80001332:	05390163          	beq	s2,s3,80001374 <mappages+0xa2>
    a += PGSIZE;
    80001336:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80001338:	bfc9                	j	8000130a <mappages+0x38>
    panic("mappages: size");
    8000133a:	00008517          	auipc	a0,0x8
    8000133e:	dee50513          	addi	a0,a0,-530 # 80009128 <etext+0x128>
    80001342:	fffff097          	auipc	ra,0xfffff
    80001346:	21e080e7          	jalr	542(ra) # 80000560 <panic>
      panic("mappages: remap");
    8000134a:	00008517          	auipc	a0,0x8
    8000134e:	dee50513          	addi	a0,a0,-530 # 80009138 <etext+0x138>
    80001352:	fffff097          	auipc	ra,0xfffff
    80001356:	20e080e7          	jalr	526(ra) # 80000560 <panic>
      return -1;
    8000135a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000135c:	60a6                	ld	ra,72(sp)
    8000135e:	6406                	ld	s0,64(sp)
    80001360:	74e2                	ld	s1,56(sp)
    80001362:	7942                	ld	s2,48(sp)
    80001364:	79a2                	ld	s3,40(sp)
    80001366:	7a02                	ld	s4,32(sp)
    80001368:	6ae2                	ld	s5,24(sp)
    8000136a:	6b42                	ld	s6,16(sp)
    8000136c:	6ba2                	ld	s7,8(sp)
    8000136e:	6c02                	ld	s8,0(sp)
    80001370:	6161                	addi	sp,sp,80
    80001372:	8082                	ret
  return 0;
    80001374:	4501                	li	a0,0
    80001376:	b7dd                	j	8000135c <mappages+0x8a>

0000000080001378 <kvmmap>:
{
    80001378:	1141                	addi	sp,sp,-16
    8000137a:	e406                	sd	ra,8(sp)
    8000137c:	e022                	sd	s0,0(sp)
    8000137e:	0800                	addi	s0,sp,16
    80001380:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001382:	86b2                	mv	a3,a2
    80001384:	863e                	mv	a2,a5
    80001386:	00000097          	auipc	ra,0x0
    8000138a:	f4c080e7          	jalr	-180(ra) # 800012d2 <mappages>
    8000138e:	e509                	bnez	a0,80001398 <kvmmap+0x20>
}
    80001390:	60a2                	ld	ra,8(sp)
    80001392:	6402                	ld	s0,0(sp)
    80001394:	0141                	addi	sp,sp,16
    80001396:	8082                	ret
    panic("kvmmap");
    80001398:	00008517          	auipc	a0,0x8
    8000139c:	db050513          	addi	a0,a0,-592 # 80009148 <etext+0x148>
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	1c0080e7          	jalr	448(ra) # 80000560 <panic>

00000000800013a8 <kvmmake>:
{
    800013a8:	1101                	addi	sp,sp,-32
    800013aa:	ec06                	sd	ra,24(sp)
    800013ac:	e822                	sd	s0,16(sp)
    800013ae:	e426                	sd	s1,8(sp)
    800013b0:	e04a                	sd	s2,0(sp)
    800013b2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	850080e7          	jalr	-1968(ra) # 80000c04 <kalloc>
    800013bc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800013be:	6605                	lui	a2,0x1
    800013c0:	4581                	li	a1,0
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	a4c080e7          	jalr	-1460(ra) # 80000e0e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800013ca:	4719                	li	a4,6
    800013cc:	6685                	lui	a3,0x1
    800013ce:	10000637          	lui	a2,0x10000
    800013d2:	85b2                	mv	a1,a2
    800013d4:	8526                	mv	a0,s1
    800013d6:	00000097          	auipc	ra,0x0
    800013da:	fa2080e7          	jalr	-94(ra) # 80001378 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800013de:	4719                	li	a4,6
    800013e0:	6685                	lui	a3,0x1
    800013e2:	10001637          	lui	a2,0x10001
    800013e6:	85b2                	mv	a1,a2
    800013e8:	8526                	mv	a0,s1
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	f8e080e7          	jalr	-114(ra) # 80001378 <kvmmap>
  kvmmap(kpgtbl, VIRTIO1, VIRTIO1, PGSIZE, PTE_R | PTE_W);
    800013f2:	4719                	li	a4,6
    800013f4:	6685                	lui	a3,0x1
    800013f6:	10002637          	lui	a2,0x10002
    800013fa:	85b2                	mv	a1,a2
    800013fc:	8526                	mv	a0,s1
    800013fe:	00000097          	auipc	ra,0x0
    80001402:	f7a080e7          	jalr	-134(ra) # 80001378 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001406:	4719                	li	a4,6
    80001408:	004006b7          	lui	a3,0x400
    8000140c:	0c000637          	lui	a2,0xc000
    80001410:	85b2                	mv	a1,a2
    80001412:	8526                	mv	a0,s1
    80001414:	00000097          	auipc	ra,0x0
    80001418:	f64080e7          	jalr	-156(ra) # 80001378 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000141c:	00008917          	auipc	s2,0x8
    80001420:	be490913          	addi	s2,s2,-1052 # 80009000 <etext>
    80001424:	4729                	li	a4,10
    80001426:	80008697          	auipc	a3,0x80008
    8000142a:	bda68693          	addi	a3,a3,-1062 # 9000 <_entry-0x7fff7000>
    8000142e:	4605                	li	a2,1
    80001430:	067e                	slli	a2,a2,0x1f
    80001432:	85b2                	mv	a1,a2
    80001434:	8526                	mv	a0,s1
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	f42080e7          	jalr	-190(ra) # 80001378 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000143e:	4719                	li	a4,6
    80001440:	46c5                	li	a3,17
    80001442:	06ee                	slli	a3,a3,0x1b
    80001444:	412686b3          	sub	a3,a3,s2
    80001448:	864a                	mv	a2,s2
    8000144a:	85ca                	mv	a1,s2
    8000144c:	8526                	mv	a0,s1
    8000144e:	00000097          	auipc	ra,0x0
    80001452:	f2a080e7          	jalr	-214(ra) # 80001378 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001456:	4729                	li	a4,10
    80001458:	6685                	lui	a3,0x1
    8000145a:	00007617          	auipc	a2,0x7
    8000145e:	ba660613          	addi	a2,a2,-1114 # 80008000 <_trampoline>
    80001462:	040005b7          	lui	a1,0x4000
    80001466:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001468:	05b2                	slli	a1,a1,0xc
    8000146a:	8526                	mv	a0,s1
    8000146c:	00000097          	auipc	ra,0x0
    80001470:	f0c080e7          	jalr	-244(ra) # 80001378 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001474:	8526                	mv	a0,s1
    80001476:	00001097          	auipc	ra,0x1
    8000147a:	912080e7          	jalr	-1774(ra) # 80001d88 <proc_mapstacks>
}
    8000147e:	8526                	mv	a0,s1
    80001480:	60e2                	ld	ra,24(sp)
    80001482:	6442                	ld	s0,16(sp)
    80001484:	64a2                	ld	s1,8(sp)
    80001486:	6902                	ld	s2,0(sp)
    80001488:	6105                	addi	sp,sp,32
    8000148a:	8082                	ret

000000008000148c <kvminit>:
{
    8000148c:	1141                	addi	sp,sp,-16
    8000148e:	e406                	sd	ra,8(sp)
    80001490:	e022                	sd	s0,0(sp)
    80001492:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001494:	00000097          	auipc	ra,0x0
    80001498:	f14080e7          	jalr	-236(ra) # 800013a8 <kvmmake>
    8000149c:	0000b797          	auipc	a5,0xb
    800014a0:	6ea7ba23          	sd	a0,1780(a5) # 8000cb90 <kernel_pagetable>
}
    800014a4:	60a2                	ld	ra,8(sp)
    800014a6:	6402                	ld	s0,0(sp)
    800014a8:	0141                	addi	sp,sp,16
    800014aa:	8082                	ret

00000000800014ac <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800014ac:	715d                	addi	sp,sp,-80
    800014ae:	e486                	sd	ra,72(sp)
    800014b0:	e0a2                	sd	s0,64(sp)
    800014b2:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800014b4:	03459793          	slli	a5,a1,0x34
    800014b8:	e39d                	bnez	a5,800014de <uvmunmap+0x32>
    800014ba:	f84a                	sd	s2,48(sp)
    800014bc:	f44e                	sd	s3,40(sp)
    800014be:	f052                	sd	s4,32(sp)
    800014c0:	ec56                	sd	s5,24(sp)
    800014c2:	e85a                	sd	s6,16(sp)
    800014c4:	e45e                	sd	s7,8(sp)
    800014c6:	8a2a                	mv	s4,a0
    800014c8:	892e                	mv	s2,a1
    800014ca:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014cc:	0632                	slli	a2,a2,0xc
    800014ce:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800014d2:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014d4:	6b05                	lui	s6,0x1
    800014d6:	0935fb63          	bgeu	a1,s3,8000156c <uvmunmap+0xc0>
    800014da:	fc26                	sd	s1,56(sp)
    800014dc:	a8a9                	j	80001536 <uvmunmap+0x8a>
    800014de:	fc26                	sd	s1,56(sp)
    800014e0:	f84a                	sd	s2,48(sp)
    800014e2:	f44e                	sd	s3,40(sp)
    800014e4:	f052                	sd	s4,32(sp)
    800014e6:	ec56                	sd	s5,24(sp)
    800014e8:	e85a                	sd	s6,16(sp)
    800014ea:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800014ec:	00008517          	auipc	a0,0x8
    800014f0:	c6450513          	addi	a0,a0,-924 # 80009150 <etext+0x150>
    800014f4:	fffff097          	auipc	ra,0xfffff
    800014f8:	06c080e7          	jalr	108(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    800014fc:	00008517          	auipc	a0,0x8
    80001500:	c6c50513          	addi	a0,a0,-916 # 80009168 <etext+0x168>
    80001504:	fffff097          	auipc	ra,0xfffff
    80001508:	05c080e7          	jalr	92(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    8000150c:	00008517          	auipc	a0,0x8
    80001510:	c6c50513          	addi	a0,a0,-916 # 80009178 <etext+0x178>
    80001514:	fffff097          	auipc	ra,0xfffff
    80001518:	04c080e7          	jalr	76(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    8000151c:	00008517          	auipc	a0,0x8
    80001520:	c7450513          	addi	a0,a0,-908 # 80009190 <etext+0x190>
    80001524:	fffff097          	auipc	ra,0xfffff
    80001528:	03c080e7          	jalr	60(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000152c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001530:	995a                	add	s2,s2,s6
    80001532:	03397c63          	bgeu	s2,s3,8000156a <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001536:	4601                	li	a2,0
    80001538:	85ca                	mv	a1,s2
    8000153a:	8552                	mv	a0,s4
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	cae080e7          	jalr	-850(ra) # 800011ea <walk>
    80001544:	84aa                	mv	s1,a0
    80001546:	d95d                	beqz	a0,800014fc <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001548:	6108                	ld	a0,0(a0)
    8000154a:	00157793          	andi	a5,a0,1
    8000154e:	dfdd                	beqz	a5,8000150c <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001550:	3ff57793          	andi	a5,a0,1023
    80001554:	fd7784e3          	beq	a5,s7,8000151c <uvmunmap+0x70>
    if(do_free){
    80001558:	fc0a8ae3          	beqz	s5,8000152c <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000155c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000155e:	0532                	slli	a0,a0,0xc
    80001560:	fffff097          	auipc	ra,0xfffff
    80001564:	53c080e7          	jalr	1340(ra) # 80000a9c <kfree>
    80001568:	b7d1                	j	8000152c <uvmunmap+0x80>
    8000156a:	74e2                	ld	s1,56(sp)
    8000156c:	7942                	ld	s2,48(sp)
    8000156e:	79a2                	ld	s3,40(sp)
    80001570:	7a02                	ld	s4,32(sp)
    80001572:	6ae2                	ld	s5,24(sp)
    80001574:	6b42                	ld	s6,16(sp)
    80001576:	6ba2                	ld	s7,8(sp)
  }
}
    80001578:	60a6                	ld	ra,72(sp)
    8000157a:	6406                	ld	s0,64(sp)
    8000157c:	6161                	addi	sp,sp,80
    8000157e:	8082                	ret

0000000080001580 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001580:	1101                	addi	sp,sp,-32
    80001582:	ec06                	sd	ra,24(sp)
    80001584:	e822                	sd	s0,16(sp)
    80001586:	e426                	sd	s1,8(sp)
    80001588:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000158a:	fffff097          	auipc	ra,0xfffff
    8000158e:	67a080e7          	jalr	1658(ra) # 80000c04 <kalloc>
    80001592:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001594:	c519                	beqz	a0,800015a2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001596:	6605                	lui	a2,0x1
    80001598:	4581                	li	a1,0
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	874080e7          	jalr	-1932(ra) # 80000e0e <memset>
  return pagetable;
}
    800015a2:	8526                	mv	a0,s1
    800015a4:	60e2                	ld	ra,24(sp)
    800015a6:	6442                	ld	s0,16(sp)
    800015a8:	64a2                	ld	s1,8(sp)
    800015aa:	6105                	addi	sp,sp,32
    800015ac:	8082                	ret

00000000800015ae <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800015ae:	7179                	addi	sp,sp,-48
    800015b0:	f406                	sd	ra,40(sp)
    800015b2:	f022                	sd	s0,32(sp)
    800015b4:	ec26                	sd	s1,24(sp)
    800015b6:	e84a                	sd	s2,16(sp)
    800015b8:	e44e                	sd	s3,8(sp)
    800015ba:	e052                	sd	s4,0(sp)
    800015bc:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800015be:	6785                	lui	a5,0x1
    800015c0:	04f67863          	bgeu	a2,a5,80001610 <uvmfirst+0x62>
    800015c4:	8a2a                	mv	s4,a0
    800015c6:	89ae                	mv	s3,a1
    800015c8:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800015ca:	fffff097          	auipc	ra,0xfffff
    800015ce:	63a080e7          	jalr	1594(ra) # 80000c04 <kalloc>
    800015d2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800015d4:	6605                	lui	a2,0x1
    800015d6:	4581                	li	a1,0
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	836080e7          	jalr	-1994(ra) # 80000e0e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800015e0:	4779                	li	a4,30
    800015e2:	86ca                	mv	a3,s2
    800015e4:	6605                	lui	a2,0x1
    800015e6:	4581                	li	a1,0
    800015e8:	8552                	mv	a0,s4
    800015ea:	00000097          	auipc	ra,0x0
    800015ee:	ce8080e7          	jalr	-792(ra) # 800012d2 <mappages>
  memmove(mem, src, sz);
    800015f2:	8626                	mv	a2,s1
    800015f4:	85ce                	mv	a1,s3
    800015f6:	854a                	mv	a0,s2
    800015f8:	00000097          	auipc	ra,0x0
    800015fc:	87a080e7          	jalr	-1926(ra) # 80000e72 <memmove>
}
    80001600:	70a2                	ld	ra,40(sp)
    80001602:	7402                	ld	s0,32(sp)
    80001604:	64e2                	ld	s1,24(sp)
    80001606:	6942                	ld	s2,16(sp)
    80001608:	69a2                	ld	s3,8(sp)
    8000160a:	6a02                	ld	s4,0(sp)
    8000160c:	6145                	addi	sp,sp,48
    8000160e:	8082                	ret
    panic("uvmfirst: more than a page");
    80001610:	00008517          	auipc	a0,0x8
    80001614:	b9850513          	addi	a0,a0,-1128 # 800091a8 <etext+0x1a8>
    80001618:	fffff097          	auipc	ra,0xfffff
    8000161c:	f48080e7          	jalr	-184(ra) # 80000560 <panic>

0000000080001620 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
  uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001620:	1101                	addi	sp,sp,-32
    80001622:	ec06                	sd	ra,24(sp)
    80001624:	e822                	sd	s0,16(sp)
    80001626:	e426                	sd	s1,8(sp)
    80001628:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000162a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000162c:	00b67d63          	bgeu	a2,a1,80001646 <uvmdealloc+0x26>
    80001630:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001632:	6785                	lui	a5,0x1
    80001634:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001636:	00f60733          	add	a4,a2,a5
    8000163a:	76fd                	lui	a3,0xfffff
    8000163c:	8f75                	and	a4,a4,a3
    8000163e:	97ae                	add	a5,a5,a1
    80001640:	8ff5                	and	a5,a5,a3
    80001642:	00f76863          	bltu	a4,a5,80001652 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001646:	8526                	mv	a0,s1
    80001648:	60e2                	ld	ra,24(sp)
    8000164a:	6442                	ld	s0,16(sp)
    8000164c:	64a2                	ld	s1,8(sp)
    8000164e:	6105                	addi	sp,sp,32
    80001650:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001652:	8f99                	sub	a5,a5,a4
    80001654:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001656:	4685                	li	a3,1
    80001658:	0007861b          	sext.w	a2,a5
    8000165c:	85ba                	mv	a1,a4
    8000165e:	00000097          	auipc	ra,0x0
    80001662:	e4e080e7          	jalr	-434(ra) # 800014ac <uvmunmap>
    80001666:	b7c5                	j	80001646 <uvmdealloc+0x26>

0000000080001668 <uvmalloc>:
  if(newsz < oldsz)
    80001668:	0ab66f63          	bltu	a2,a1,80001726 <uvmalloc+0xbe>
{
    8000166c:	715d                	addi	sp,sp,-80
    8000166e:	e486                	sd	ra,72(sp)
    80001670:	e0a2                	sd	s0,64(sp)
    80001672:	f052                	sd	s4,32(sp)
    80001674:	ec56                	sd	s5,24(sp)
    80001676:	e85a                	sd	s6,16(sp)
    80001678:	0880                	addi	s0,sp,80
    8000167a:	8b2a                	mv	s6,a0
    8000167c:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    8000167e:	6785                	lui	a5,0x1
    80001680:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001682:	95be                	add	a1,a1,a5
    80001684:	77fd                	lui	a5,0xfffff
    80001686:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000168a:	0aca7063          	bgeu	s4,a2,8000172a <uvmalloc+0xc2>
    8000168e:	fc26                	sd	s1,56(sp)
    80001690:	f84a                	sd	s2,48(sp)
    80001692:	f44e                	sd	s3,40(sp)
    80001694:	e45e                	sd	s7,8(sp)
    80001696:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80001698:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000169a:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000169e:	fffff097          	auipc	ra,0xfffff
    800016a2:	566080e7          	jalr	1382(ra) # 80000c04 <kalloc>
    800016a6:	84aa                	mv	s1,a0
    if(mem == 0){
    800016a8:	c915                	beqz	a0,800016dc <uvmalloc+0x74>
    memset(mem, 0, PGSIZE);
    800016aa:	864e                	mv	a2,s3
    800016ac:	4581                	li	a1,0
    800016ae:	fffff097          	auipc	ra,0xfffff
    800016b2:	760080e7          	jalr	1888(ra) # 80000e0e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800016b6:	875e                	mv	a4,s7
    800016b8:	86a6                	mv	a3,s1
    800016ba:	864e                	mv	a2,s3
    800016bc:	85ca                	mv	a1,s2
    800016be:	855a                	mv	a0,s6
    800016c0:	00000097          	auipc	ra,0x0
    800016c4:	c12080e7          	jalr	-1006(ra) # 800012d2 <mappages>
    800016c8:	ed0d                	bnez	a0,80001702 <uvmalloc+0x9a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800016ca:	994e                	add	s2,s2,s3
    800016cc:	fd5969e3          	bltu	s2,s5,8000169e <uvmalloc+0x36>
  return newsz;
    800016d0:	8556                	mv	a0,s5
    800016d2:	74e2                	ld	s1,56(sp)
    800016d4:	7942                	ld	s2,48(sp)
    800016d6:	79a2                	ld	s3,40(sp)
    800016d8:	6ba2                	ld	s7,8(sp)
    800016da:	a829                	j	800016f4 <uvmalloc+0x8c>
      uvmdealloc(pagetable, a, oldsz);
    800016dc:	8652                	mv	a2,s4
    800016de:	85ca                	mv	a1,s2
    800016e0:	855a                	mv	a0,s6
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	f3e080e7          	jalr	-194(ra) # 80001620 <uvmdealloc>
      return 0;
    800016ea:	4501                	li	a0,0
    800016ec:	74e2                	ld	s1,56(sp)
    800016ee:	7942                	ld	s2,48(sp)
    800016f0:	79a2                	ld	s3,40(sp)
    800016f2:	6ba2                	ld	s7,8(sp)
}
    800016f4:	60a6                	ld	ra,72(sp)
    800016f6:	6406                	ld	s0,64(sp)
    800016f8:	7a02                	ld	s4,32(sp)
    800016fa:	6ae2                	ld	s5,24(sp)
    800016fc:	6b42                	ld	s6,16(sp)
    800016fe:	6161                	addi	sp,sp,80
    80001700:	8082                	ret
      kfree(mem);
    80001702:	8526                	mv	a0,s1
    80001704:	fffff097          	auipc	ra,0xfffff
    80001708:	398080e7          	jalr	920(ra) # 80000a9c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000170c:	8652                	mv	a2,s4
    8000170e:	85ca                	mv	a1,s2
    80001710:	855a                	mv	a0,s6
    80001712:	00000097          	auipc	ra,0x0
    80001716:	f0e080e7          	jalr	-242(ra) # 80001620 <uvmdealloc>
      return 0;
    8000171a:	4501                	li	a0,0
    8000171c:	74e2                	ld	s1,56(sp)
    8000171e:	7942                	ld	s2,48(sp)
    80001720:	79a2                	ld	s3,40(sp)
    80001722:	6ba2                	ld	s7,8(sp)
    80001724:	bfc1                	j	800016f4 <uvmalloc+0x8c>
    return oldsz;
    80001726:	852e                	mv	a0,a1
}
    80001728:	8082                	ret
  return newsz;
    8000172a:	8532                	mv	a0,a2
    8000172c:	b7e1                	j	800016f4 <uvmalloc+0x8c>

000000008000172e <uvmthreaded_alloc>:
uvmthreaded_alloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz, uint64 xperm) {
    8000172e:	7119                	addi	sp,sp,-128
    80001730:	fc86                	sd	ra,120(sp)
    80001732:	f8a2                	sd	s0,112(sp)
    80001734:	0100                	addi	s0,sp,128
    80001736:	f8a43423          	sd	a0,-120(s0)
  if(newsz < oldsz)
    8000173a:	16b66163          	bltu	a2,a1,8000189c <uvmthreaded_alloc+0x16e>
    8000173e:	e4d6                	sd	s5,72(sp)
    80001740:	f466                	sd	s9,40(sp)
    80001742:	f06a                	sd	s10,32(sp)
    80001744:	8ab2                	mv	s5,a2
    80001746:	8d36                	mv	s10,a3
  oldsz = PGROUNDUP(oldsz);
    80001748:	6785                	lui	a5,0x1
    8000174a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000174c:	95be                	add	a1,a1,a5
    8000174e:	77fd                	lui	a5,0xfffff
    80001750:	00f5fcb3          	and	s9,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001754:	14ccf663          	bgeu	s9,a2,800018a0 <uvmthreaded_alloc+0x172>
    80001758:	f4a6                	sd	s1,104(sp)
    8000175a:	f0ca                	sd	s2,96(sp)
    8000175c:	ecce                	sd	s3,88(sp)
    8000175e:	e8d2                	sd	s4,80(sp)
    80001760:	e0da                	sd	s6,64(sp)
    80001762:	fc5e                	sd	s7,56(sp)
    80001764:	f862                	sd	s8,48(sp)
    80001766:	ec6e                	sd	s11,24(sp)
  struct proc *p = thread_proc->parent;
    80001768:	03853d83          	ld	s11,56(a0)
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000176c:	8b66                	mv	s6,s9
    memset(mem, 0, PGSIZE);
    8000176e:	6c05                	lui	s8,0x1
    80001770:	370d8a13          	addi	s4,s11,880
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001774:	0126eb93          	ori	s7,a3,18
    80001778:	2b81                	sext.w	s7,s7
    mem = kalloc();
    8000177a:	fffff097          	auipc	ra,0xfffff
    8000177e:	48a080e7          	jalr	1162(ra) # 80000c04 <kalloc>
    80001782:	89aa                	mv	s3,a0
    if(mem == 0){
    80001784:	c911                	beqz	a0,80001798 <uvmthreaded_alloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001786:	8662                	mv	a2,s8
    80001788:	4581                	li	a1,0
    8000178a:	fffff097          	auipc	ra,0xfffff
    8000178e:	684080e7          	jalr	1668(ra) # 80000e0e <memset>
    for (int i = 0; i < MAX_THREADS; i++) {
    80001792:	170d8493          	addi	s1,s11,368
    80001796:	a0bd                	j	80001804 <uvmthreaded_alloc+0xd6>
      uvmdealloc(thread_proc->pagetable, a, oldsz);
    80001798:	8666                	mv	a2,s9
    8000179a:	85da                	mv	a1,s6
    8000179c:	f8843783          	ld	a5,-120(s0)
    800017a0:	6ba8                	ld	a0,80(a5)
    800017a2:	00000097          	auipc	ra,0x0
    800017a6:	e7e080e7          	jalr	-386(ra) # 80001620 <uvmdealloc>
      return 0;
    800017aa:	4501                	li	a0,0
    800017ac:	74a6                	ld	s1,104(sp)
    800017ae:	7906                	ld	s2,96(sp)
    800017b0:	69e6                	ld	s3,88(sp)
    800017b2:	6a46                	ld	s4,80(sp)
    800017b4:	6aa6                	ld	s5,72(sp)
    800017b6:	6b06                	ld	s6,64(sp)
    800017b8:	7be2                	ld	s7,56(sp)
    800017ba:	7c42                	ld	s8,48(sp)
    800017bc:	7ca2                	ld	s9,40(sp)
    800017be:	7d02                	ld	s10,32(sp)
    800017c0:	6de2                	ld	s11,24(sp)
    800017c2:	a815                	j	800017f6 <uvmthreaded_alloc+0xc8>
        kfree(mem);
    800017c4:	854e                	mv	a0,s3
    800017c6:	fffff097          	auipc	ra,0xfffff
    800017ca:	2d6080e7          	jalr	726(ra) # 80000a9c <kfree>
        uvmdealloc(infant->pagetable, a, oldsz);
    800017ce:	8666                	mv	a2,s9
    800017d0:	85da                	mv	a1,s6
    800017d2:	05093503          	ld	a0,80(s2)
    800017d6:	00000097          	auipc	ra,0x0
    800017da:	e4a080e7          	jalr	-438(ra) # 80001620 <uvmdealloc>
        return 0;
    800017de:	4501                	li	a0,0
    800017e0:	74a6                	ld	s1,104(sp)
    800017e2:	7906                	ld	s2,96(sp)
    800017e4:	69e6                	ld	s3,88(sp)
    800017e6:	6a46                	ld	s4,80(sp)
    800017e8:	6aa6                	ld	s5,72(sp)
    800017ea:	6b06                	ld	s6,64(sp)
    800017ec:	7be2                	ld	s7,56(sp)
    800017ee:	7c42                	ld	s8,48(sp)
    800017f0:	7ca2                	ld	s9,40(sp)
    800017f2:	7d02                	ld	s10,32(sp)
    800017f4:	6de2                	ld	s11,24(sp)
}
    800017f6:	70e6                	ld	ra,120(sp)
    800017f8:	7446                	ld	s0,112(sp)
    800017fa:	6109                	addi	sp,sp,128
    800017fc:	8082                	ret
    for (int i = 0; i < MAX_THREADS; i++) {
    800017fe:	04a1                	addi	s1,s1,8
    80001800:	03448463          	beq	s1,s4,80001828 <uvmthreaded_alloc+0xfa>
      struct proc *infant = p->infant_threads[i];
    80001804:	0004b903          	ld	s2,0(s1)
      if (infant == 0)
    80001808:	fe090be3          	beqz	s2,800017fe <uvmthreaded_alloc+0xd0>
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000180c:	875e                	mv	a4,s7
    8000180e:	86ce                	mv	a3,s3
    80001810:	8662                	mv	a2,s8
    80001812:	85da                	mv	a1,s6
    80001814:	05093503          	ld	a0,80(s2)
    80001818:	00000097          	auipc	ra,0x0
    8000181c:	aba080e7          	jalr	-1350(ra) # 800012d2 <mappages>
    80001820:	f155                	bnez	a0,800017c4 <uvmthreaded_alloc+0x96>
      infant->sz = newsz;
    80001822:	05593423          	sd	s5,72(s2)
    80001826:	bfe1                	j	800017fe <uvmthreaded_alloc+0xd0>
    if(mappages(p->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001828:	012d6713          	ori	a4,s10,18
    8000182c:	2701                	sext.w	a4,a4
    8000182e:	86ce                	mv	a3,s3
    80001830:	6605                	lui	a2,0x1
    80001832:	85da                	mv	a1,s6
    80001834:	050db503          	ld	a0,80(s11)
    80001838:	00000097          	auipc	ra,0x0
    8000183c:	a9a080e7          	jalr	-1382(ra) # 800012d2 <mappages>
    80001840:	e505                	bnez	a0,80001868 <uvmthreaded_alloc+0x13a>
    p->sz = newsz;
    80001842:	055db423          	sd	s5,72(s11)
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001846:	6785                	lui	a5,0x1
    80001848:	9b3e                	add	s6,s6,a5
    8000184a:	f35b68e3          	bltu	s6,s5,8000177a <uvmthreaded_alloc+0x4c>
  return newsz;
    8000184e:	8556                	mv	a0,s5
    80001850:	74a6                	ld	s1,104(sp)
    80001852:	7906                	ld	s2,96(sp)
    80001854:	69e6                	ld	s3,88(sp)
    80001856:	6a46                	ld	s4,80(sp)
    80001858:	6aa6                	ld	s5,72(sp)
    8000185a:	6b06                	ld	s6,64(sp)
    8000185c:	7be2                	ld	s7,56(sp)
    8000185e:	7c42                	ld	s8,48(sp)
    80001860:	7ca2                	ld	s9,40(sp)
    80001862:	7d02                	ld	s10,32(sp)
    80001864:	6de2                	ld	s11,24(sp)
    80001866:	bf41                	j	800017f6 <uvmthreaded_alloc+0xc8>
      kfree(mem);
    80001868:	854e                	mv	a0,s3
    8000186a:	fffff097          	auipc	ra,0xfffff
    8000186e:	232080e7          	jalr	562(ra) # 80000a9c <kfree>
      uvmdealloc(p->pagetable, a, oldsz);
    80001872:	8666                	mv	a2,s9
    80001874:	85da                	mv	a1,s6
    80001876:	050db503          	ld	a0,80(s11)
    8000187a:	00000097          	auipc	ra,0x0
    8000187e:	da6080e7          	jalr	-602(ra) # 80001620 <uvmdealloc>
      return 0;
    80001882:	4501                	li	a0,0
    80001884:	74a6                	ld	s1,104(sp)
    80001886:	7906                	ld	s2,96(sp)
    80001888:	69e6                	ld	s3,88(sp)
    8000188a:	6a46                	ld	s4,80(sp)
    8000188c:	6aa6                	ld	s5,72(sp)
    8000188e:	6b06                	ld	s6,64(sp)
    80001890:	7be2                	ld	s7,56(sp)
    80001892:	7c42                	ld	s8,48(sp)
    80001894:	7ca2                	ld	s9,40(sp)
    80001896:	7d02                	ld	s10,32(sp)
    80001898:	6de2                	ld	s11,24(sp)
    8000189a:	bfb1                	j	800017f6 <uvmthreaded_alloc+0xc8>
    return oldsz;
    8000189c:	852e                	mv	a0,a1
    8000189e:	bfa1                	j	800017f6 <uvmthreaded_alloc+0xc8>
  return newsz;
    800018a0:	8532                	mv	a0,a2
    800018a2:	6aa6                	ld	s5,72(sp)
    800018a4:	7ca2                	ld	s9,40(sp)
    800018a6:	7d02                	ld	s10,32(sp)
    800018a8:	b7b9                	j	800017f6 <uvmthreaded_alloc+0xc8>

00000000800018aa <uvmthreaded_dealloc>:

uint64
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
  struct proc *p = thread_proc->parent;

  if(newsz >= oldsz)
    800018aa:	0ab67163          	bgeu	a2,a1,8000194c <uvmthreaded_dealloc+0xa2>
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
    800018ae:	715d                	addi	sp,sp,-80
    800018b0:	e486                	sd	ra,72(sp)
    800018b2:	e0a2                	sd	s0,64(sp)
    800018b4:	fc26                	sd	s1,56(sp)
    800018b6:	f84a                	sd	s2,48(sp)
    800018b8:	f44e                	sd	s3,40(sp)
    800018ba:	f052                	sd	s4,32(sp)
    800018bc:	ec56                	sd	s5,24(sp)
    800018be:	e85a                	sd	s6,16(sp)
    800018c0:	e45e                	sd	s7,8(sp)
    800018c2:	e062                	sd	s8,0(sp)
    800018c4:	0880                	addi	s0,sp,80
    800018c6:	8ab2                	mv	s5,a2
  struct proc *p = thread_proc->parent;
    800018c8:	03853c03          	ld	s8,56(a0)
    return oldsz;

  int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800018cc:	6785                	lui	a5,0x1
    800018ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800018d0:	95be                	add	a1,a1,a5
    800018d2:	777d                	lui	a4,0xfffff
    800018d4:	00e5fb33          	and	s6,a1,a4
    800018d8:	97b2                	add	a5,a5,a2
    800018da:	00e7f9b3          	and	s3,a5,a4
    800018de:	413b0bb3          	sub	s7,s6,s3
    800018e2:	00cbdb93          	srli	s7,s7,0xc
    800018e6:	2b81                	sext.w	s7,s7

  for (int i = 0; i < MAX_THREADS; i++) {
    800018e8:	170c0493          	addi	s1,s8,368 # 1170 <_entry-0x7fffee90>
    800018ec:	370c0a13          	addi	s4,s8,880
    800018f0:	a031                	j	800018fc <uvmthreaded_dealloc+0x52>
      continue;

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    }
    infant->sz = newsz;
    800018f2:	05593423          	sd	s5,72(s2)
  for (int i = 0; i < MAX_THREADS; i++) {
    800018f6:	04a1                	addi	s1,s1,8
    800018f8:	03448263          	beq	s1,s4,8000191c <uvmthreaded_dealloc+0x72>
    struct proc *infant = p->infant_threads[i];
    800018fc:	0004b903          	ld	s2,0(s1)
    if (infant == 0)
    80001900:	fe090be3          	beqz	s2,800018f6 <uvmthreaded_dealloc+0x4c>
    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
    80001904:	ff69f7e3          	bgeu	s3,s6,800018f2 <uvmthreaded_dealloc+0x48>
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    80001908:	4681                	li	a3,0
    8000190a:	865e                	mv	a2,s7
    8000190c:	85ce                	mv	a1,s3
    8000190e:	05093503          	ld	a0,80(s2)
    80001912:	00000097          	auipc	ra,0x0
    80001916:	b9a080e7          	jalr	-1126(ra) # 800014ac <uvmunmap>
    8000191a:	bfe1                	j	800018f2 <uvmthreaded_dealloc+0x48>
  }

  uvmunmap(p->pagetable, PGROUNDUP(newsz), npages, 1); //unmap with freeing
    8000191c:	4685                	li	a3,1
    8000191e:	865e                	mv	a2,s7
    80001920:	85ce                	mv	a1,s3
    80001922:	050c3503          	ld	a0,80(s8)
    80001926:	00000097          	auipc	ra,0x0
    8000192a:	b86080e7          	jalr	-1146(ra) # 800014ac <uvmunmap>
  p->sz = newsz;
    8000192e:	055c3423          	sd	s5,72(s8)

  return newsz;
    80001932:	8556                	mv	a0,s5
}
    80001934:	60a6                	ld	ra,72(sp)
    80001936:	6406                	ld	s0,64(sp)
    80001938:	74e2                	ld	s1,56(sp)
    8000193a:	7942                	ld	s2,48(sp)
    8000193c:	79a2                	ld	s3,40(sp)
    8000193e:	7a02                	ld	s4,32(sp)
    80001940:	6ae2                	ld	s5,24(sp)
    80001942:	6b42                	ld	s6,16(sp)
    80001944:	6ba2                	ld	s7,8(sp)
    80001946:	6c02                	ld	s8,0(sp)
    80001948:	6161                	addi	sp,sp,80
    8000194a:	8082                	ret
    return oldsz;
    8000194c:	852e                	mv	a0,a1
}
    8000194e:	8082                	ret

0000000080001950 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001950:	7179                	addi	sp,sp,-48
    80001952:	f406                	sd	ra,40(sp)
    80001954:	f022                	sd	s0,32(sp)
    80001956:	ec26                	sd	s1,24(sp)
    80001958:	e84a                	sd	s2,16(sp)
    8000195a:	e44e                	sd	s3,8(sp)
    8000195c:	e052                	sd	s4,0(sp)
    8000195e:	1800                	addi	s0,sp,48
    80001960:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001962:	84aa                	mv	s1,a0
    80001964:	6905                	lui	s2,0x1
    80001966:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001968:	4985                	li	s3,1
    8000196a:	a829                	j	80001984 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000196c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000196e:	00c79513          	slli	a0,a5,0xc
    80001972:	00000097          	auipc	ra,0x0
    80001976:	fde080e7          	jalr	-34(ra) # 80001950 <freewalk>
      pagetable[i] = 0;
    8000197a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000197e:	04a1                	addi	s1,s1,8
    80001980:	03248163          	beq	s1,s2,800019a2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001984:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001986:	00f7f713          	andi	a4,a5,15
    8000198a:	ff3701e3          	beq	a4,s3,8000196c <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000198e:	8b85                	andi	a5,a5,1
    80001990:	d7fd                	beqz	a5,8000197e <freewalk+0x2e>
      panic("freewalk: leaf");
    80001992:	00008517          	auipc	a0,0x8
    80001996:	83650513          	addi	a0,a0,-1994 # 800091c8 <etext+0x1c8>
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	bc6080e7          	jalr	-1082(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    800019a2:	8552                	mv	a0,s4
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	0f8080e7          	jalr	248(ra) # 80000a9c <kfree>
}
    800019ac:	70a2                	ld	ra,40(sp)
    800019ae:	7402                	ld	s0,32(sp)
    800019b0:	64e2                	ld	s1,24(sp)
    800019b2:	6942                	ld	s2,16(sp)
    800019b4:	69a2                	ld	s3,8(sp)
    800019b6:	6a02                	ld	s4,0(sp)
    800019b8:	6145                	addi	sp,sp,48
    800019ba:	8082                	ret

00000000800019bc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800019bc:	1101                	addi	sp,sp,-32
    800019be:	ec06                	sd	ra,24(sp)
    800019c0:	e822                	sd	s0,16(sp)
    800019c2:	e426                	sd	s1,8(sp)
    800019c4:	1000                	addi	s0,sp,32
    800019c6:	84aa                	mv	s1,a0
  if(sz > 0)
    800019c8:	e999                	bnez	a1,800019de <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800019ca:	8526                	mv	a0,s1
    800019cc:	00000097          	auipc	ra,0x0
    800019d0:	f84080e7          	jalr	-124(ra) # 80001950 <freewalk>
}
    800019d4:	60e2                	ld	ra,24(sp)
    800019d6:	6442                	ld	s0,16(sp)
    800019d8:	64a2                	ld	s1,8(sp)
    800019da:	6105                	addi	sp,sp,32
    800019dc:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800019de:	6785                	lui	a5,0x1
    800019e0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800019e2:	95be                	add	a1,a1,a5
    800019e4:	4685                	li	a3,1
    800019e6:	00c5d613          	srli	a2,a1,0xc
    800019ea:	4581                	li	a1,0
    800019ec:	00000097          	auipc	ra,0x0
    800019f0:	ac0080e7          	jalr	-1344(ra) # 800014ac <uvmunmap>
    800019f4:	bfd9                	j	800019ca <uvmfree+0xe>

00000000800019f6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800019f6:	ca69                	beqz	a2,80001ac8 <uvmcopy+0xd2>
{
    800019f8:	715d                	addi	sp,sp,-80
    800019fa:	e486                	sd	ra,72(sp)
    800019fc:	e0a2                	sd	s0,64(sp)
    800019fe:	fc26                	sd	s1,56(sp)
    80001a00:	f84a                	sd	s2,48(sp)
    80001a02:	f44e                	sd	s3,40(sp)
    80001a04:	f052                	sd	s4,32(sp)
    80001a06:	ec56                	sd	s5,24(sp)
    80001a08:	e85a                	sd	s6,16(sp)
    80001a0a:	e45e                	sd	s7,8(sp)
    80001a0c:	e062                	sd	s8,0(sp)
    80001a0e:	0880                	addi	s0,sp,80
    80001a10:	8baa                	mv	s7,a0
    80001a12:	8b2e                	mv	s6,a1
    80001a14:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001a16:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001a18:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    80001a1a:	4601                	li	a2,0
    80001a1c:	85ce                	mv	a1,s3
    80001a1e:	855e                	mv	a0,s7
    80001a20:	fffff097          	auipc	ra,0xfffff
    80001a24:	7ca080e7          	jalr	1994(ra) # 800011ea <walk>
    80001a28:	c529                	beqz	a0,80001a72 <uvmcopy+0x7c>
    if((*pte & PTE_V) == 0)
    80001a2a:	6118                	ld	a4,0(a0)
    80001a2c:	00177793          	andi	a5,a4,1
    80001a30:	cba9                	beqz	a5,80001a82 <uvmcopy+0x8c>
    pa = PTE2PA(*pte);
    80001a32:	00a75593          	srli	a1,a4,0xa
    80001a36:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001a3a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001a3e:	fffff097          	auipc	ra,0xfffff
    80001a42:	1c6080e7          	jalr	454(ra) # 80000c04 <kalloc>
    80001a46:	892a                	mv	s2,a0
    80001a48:	c931                	beqz	a0,80001a9c <uvmcopy+0xa6>
    memmove(mem, (char*)pa, PGSIZE);
    80001a4a:	8652                	mv	a2,s4
    80001a4c:	85e2                	mv	a1,s8
    80001a4e:	fffff097          	auipc	ra,0xfffff
    80001a52:	424080e7          	jalr	1060(ra) # 80000e72 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001a56:	8726                	mv	a4,s1
    80001a58:	86ca                	mv	a3,s2
    80001a5a:	8652                	mv	a2,s4
    80001a5c:	85ce                	mv	a1,s3
    80001a5e:	855a                	mv	a0,s6
    80001a60:	00000097          	auipc	ra,0x0
    80001a64:	872080e7          	jalr	-1934(ra) # 800012d2 <mappages>
    80001a68:	e50d                	bnez	a0,80001a92 <uvmcopy+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
    80001a6a:	99d2                	add	s3,s3,s4
    80001a6c:	fb59e7e3          	bltu	s3,s5,80001a1a <uvmcopy+0x24>
    80001a70:	a081                	j	80001ab0 <uvmcopy+0xba>
      panic("uvmcopy: pte should exist");
    80001a72:	00007517          	auipc	a0,0x7
    80001a76:	76650513          	addi	a0,a0,1894 # 800091d8 <etext+0x1d8>
    80001a7a:	fffff097          	auipc	ra,0xfffff
    80001a7e:	ae6080e7          	jalr	-1306(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001a82:	00007517          	auipc	a0,0x7
    80001a86:	77650513          	addi	a0,a0,1910 # 800091f8 <etext+0x1f8>
    80001a8a:	fffff097          	auipc	ra,0xfffff
    80001a8e:	ad6080e7          	jalr	-1322(ra) # 80000560 <panic>
      kfree(mem);
    80001a92:	854a                	mv	a0,s2
    80001a94:	fffff097          	auipc	ra,0xfffff
    80001a98:	008080e7          	jalr	8(ra) # 80000a9c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001a9c:	4685                	li	a3,1
    80001a9e:	00c9d613          	srli	a2,s3,0xc
    80001aa2:	4581                	li	a1,0
    80001aa4:	855a                	mv	a0,s6
    80001aa6:	00000097          	auipc	ra,0x0
    80001aaa:	a06080e7          	jalr	-1530(ra) # 800014ac <uvmunmap>
  return -1;
    80001aae:	557d                	li	a0,-1
}
    80001ab0:	60a6                	ld	ra,72(sp)
    80001ab2:	6406                	ld	s0,64(sp)
    80001ab4:	74e2                	ld	s1,56(sp)
    80001ab6:	7942                	ld	s2,48(sp)
    80001ab8:	79a2                	ld	s3,40(sp)
    80001aba:	7a02                	ld	s4,32(sp)
    80001abc:	6ae2                	ld	s5,24(sp)
    80001abe:	6b42                	ld	s6,16(sp)
    80001ac0:	6ba2                	ld	s7,8(sp)
    80001ac2:	6c02                	ld	s8,0(sp)
    80001ac4:	6161                	addi	sp,sp,80
    80001ac6:	8082                	ret
  return 0;
    80001ac8:	4501                	li	a0,0
}
    80001aca:	8082                	ret

0000000080001acc <uvmshare>:

int
uvmshare(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001acc:	715d                	addi	sp,sp,-80
    80001ace:	e486                	sd	ra,72(sp)
    80001ad0:	e0a2                	sd	s0,64(sp)
    80001ad2:	f44e                	sd	s3,40(sp)
    80001ad4:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa = 0, i;
  uint flags;
  
  for(i = 0; i < sz; i += PGSIZE) {
    80001ad6:	ce5d                	beqz	a2,80001b94 <uvmshare+0xc8>
    80001ad8:	fc26                	sd	s1,56(sp)
    80001ada:	f84a                	sd	s2,48(sp)
    80001adc:	f052                	sd	s4,32(sp)
    80001ade:	ec56                	sd	s5,24(sp)
    80001ae0:	e85a                	sd	s6,16(sp)
    80001ae2:	e45e                	sd	s7,8(sp)
    80001ae4:	8baa                	mv	s7,a0
    80001ae6:	8b2e                	mv	s6,a1
    80001ae8:	8ab2                	mv	s5,a2
    80001aea:	4901                	li	s2,0

    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    // flags |= PTE_W;

    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
    80001aec:	6a05                	lui	s4,0x1
    80001aee:	a891                	j	80001b42 <uvmshare+0x76>
    if(pte == 0) panic("uvmshare: pte should exist");
    80001af0:	00007517          	auipc	a0,0x7
    80001af4:	72850513          	addi	a0,a0,1832 # 80009218 <etext+0x218>
    80001af8:	fffff097          	auipc	ra,0xfffff
    80001afc:	a68080e7          	jalr	-1432(ra) # 80000560 <panic>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001b00:	00007517          	auipc	a0,0x7
    80001b04:	73850513          	addi	a0,a0,1848 # 80009238 <etext+0x238>
    80001b08:	fffff097          	auipc	ra,0xfffff
    80001b0c:	a58080e7          	jalr	-1448(ra) # 80000560 <panic>
      uvmunmap(new, 0, i / PGSIZE, 0);
    80001b10:	4681                	li	a3,0
    80001b12:	00c95613          	srli	a2,s2,0xc
    80001b16:	4581                	li	a1,0
    80001b18:	855a                	mv	a0,s6
    80001b1a:	00000097          	auipc	ra,0x0
    80001b1e:	992080e7          	jalr	-1646(ra) # 800014ac <uvmunmap>
      return -1;
    80001b22:	59fd                	li	s3,-1
    80001b24:	74e2                	ld	s1,56(sp)
    80001b26:	7942                	ld	s2,48(sp)
    80001b28:	7a02                	ld	s4,32(sp)
    80001b2a:	6ae2                	ld	s5,24(sp)
    80001b2c:	6b42                	ld	s6,16(sp)
    80001b2e:	6ba2                	ld	s7,8(sp)
      add_page_reference((uint64)pa);
  }

  return 0;

}
    80001b30:	854e                	mv	a0,s3
    80001b32:	60a6                	ld	ra,72(sp)
    80001b34:	6406                	ld	s0,64(sp)
    80001b36:	79a2                	ld	s3,40(sp)
    80001b38:	6161                	addi	sp,sp,80
    80001b3a:	8082                	ret
  for(i = 0; i < sz; i += PGSIZE) {
    80001b3c:	9952                	add	s2,s2,s4
    80001b3e:	05597463          	bgeu	s2,s5,80001b86 <uvmshare+0xba>
    pte = walk(old, i, 0);
    80001b42:	4601                	li	a2,0
    80001b44:	85ca                	mv	a1,s2
    80001b46:	855e                	mv	a0,s7
    80001b48:	fffff097          	auipc	ra,0xfffff
    80001b4c:	6a2080e7          	jalr	1698(ra) # 800011ea <walk>
    if(pte == 0) panic("uvmshare: pte should exist");
    80001b50:	d145                	beqz	a0,80001af0 <uvmshare+0x24>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001b52:	6118                	ld	a4,0(a0)
    80001b54:	00177793          	andi	a5,a4,1
    80001b58:	d7c5                	beqz	a5,80001b00 <uvmshare+0x34>
    pa = PTE2PA(*pte);
    80001b5a:	00a75493          	srli	s1,a4,0xa
    80001b5e:	04b2                	slli	s1,s1,0xc
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
    80001b60:	3ff77713          	andi	a4,a4,1023
    80001b64:	86a6                	mv	a3,s1
    80001b66:	8652                	mv	a2,s4
    80001b68:	85ca                	mv	a1,s2
    80001b6a:	855a                	mv	a0,s6
    80001b6c:	fffff097          	auipc	ra,0xfffff
    80001b70:	766080e7          	jalr	1894(ra) # 800012d2 <mappages>
    80001b74:	89aa                	mv	s3,a0
    80001b76:	fd49                	bnez	a0,80001b10 <uvmshare+0x44>
    if (pa != 0)
    80001b78:	d0f1                	beqz	s1,80001b3c <uvmshare+0x70>
      add_page_reference((uint64)pa);
    80001b7a:	8526                	mv	a0,s1
    80001b7c:	fffff097          	auipc	ra,0xfffff
    80001b80:	ed0080e7          	jalr	-304(ra) # 80000a4c <add_page_reference>
    80001b84:	bf65                	j	80001b3c <uvmshare+0x70>
    80001b86:	74e2                	ld	s1,56(sp)
    80001b88:	7942                	ld	s2,48(sp)
    80001b8a:	7a02                	ld	s4,32(sp)
    80001b8c:	6ae2                	ld	s5,24(sp)
    80001b8e:	6b42                	ld	s6,16(sp)
    80001b90:	6ba2                	ld	s7,8(sp)
    80001b92:	bf79                	j	80001b30 <uvmshare+0x64>
  return 0;
    80001b94:	4981                	li	s3,0
    80001b96:	bf69                	j	80001b30 <uvmshare+0x64>

0000000080001b98 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001b98:	1141                	addi	sp,sp,-16
    80001b9a:	e406                	sd	ra,8(sp)
    80001b9c:	e022                	sd	s0,0(sp)
    80001b9e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001ba0:	4601                	li	a2,0
    80001ba2:	fffff097          	auipc	ra,0xfffff
    80001ba6:	648080e7          	jalr	1608(ra) # 800011ea <walk>
  if(pte == 0)
    80001baa:	c901                	beqz	a0,80001bba <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001bac:	611c                	ld	a5,0(a0)
    80001bae:	9bbd                	andi	a5,a5,-17
    80001bb0:	e11c                	sd	a5,0(a0)
}
    80001bb2:	60a2                	ld	ra,8(sp)
    80001bb4:	6402                	ld	s0,0(sp)
    80001bb6:	0141                	addi	sp,sp,16
    80001bb8:	8082                	ret
    panic("uvmclear");
    80001bba:	00007517          	auipc	a0,0x7
    80001bbe:	69e50513          	addi	a0,a0,1694 # 80009258 <etext+0x258>
    80001bc2:	fffff097          	auipc	ra,0xfffff
    80001bc6:	99e080e7          	jalr	-1634(ra) # 80000560 <panic>

0000000080001bca <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001bca:	c6bd                	beqz	a3,80001c38 <copyout+0x6e>
{
    80001bcc:	715d                	addi	sp,sp,-80
    80001bce:	e486                	sd	ra,72(sp)
    80001bd0:	e0a2                	sd	s0,64(sp)
    80001bd2:	fc26                	sd	s1,56(sp)
    80001bd4:	f84a                	sd	s2,48(sp)
    80001bd6:	f44e                	sd	s3,40(sp)
    80001bd8:	f052                	sd	s4,32(sp)
    80001bda:	ec56                	sd	s5,24(sp)
    80001bdc:	e85a                	sd	s6,16(sp)
    80001bde:	e45e                	sd	s7,8(sp)
    80001be0:	e062                	sd	s8,0(sp)
    80001be2:	0880                	addi	s0,sp,80
    80001be4:	8b2a                	mv	s6,a0
    80001be6:	8c2e                	mv	s8,a1
    80001be8:	8a32                	mv	s4,a2
    80001bea:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001bec:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001bee:	6a85                	lui	s5,0x1
    80001bf0:	a015                	j	80001c14 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001bf2:	9562                	add	a0,a0,s8
    80001bf4:	0004861b          	sext.w	a2,s1
    80001bf8:	85d2                	mv	a1,s4
    80001bfa:	41250533          	sub	a0,a0,s2
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	274080e7          	jalr	628(ra) # 80000e72 <memmove>

    len -= n;
    80001c06:	409989b3          	sub	s3,s3,s1
    src += n;
    80001c0a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001c0c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001c10:	02098263          	beqz	s3,80001c34 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001c14:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001c18:	85ca                	mv	a1,s2
    80001c1a:	855a                	mv	a0,s6
    80001c1c:	fffff097          	auipc	ra,0xfffff
    80001c20:	674080e7          	jalr	1652(ra) # 80001290 <walkaddr>
    if(pa0 == 0)
    80001c24:	cd01                	beqz	a0,80001c3c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001c26:	418904b3          	sub	s1,s2,s8
    80001c2a:	94d6                	add	s1,s1,s5
    if(n > len)
    80001c2c:	fc99f3e3          	bgeu	s3,s1,80001bf2 <copyout+0x28>
    80001c30:	84ce                	mv	s1,s3
    80001c32:	b7c1                	j	80001bf2 <copyout+0x28>
  }
  return 0;
    80001c34:	4501                	li	a0,0
    80001c36:	a021                	j	80001c3e <copyout+0x74>
    80001c38:	4501                	li	a0,0
}
    80001c3a:	8082                	ret
      return -1;
    80001c3c:	557d                	li	a0,-1
}
    80001c3e:	60a6                	ld	ra,72(sp)
    80001c40:	6406                	ld	s0,64(sp)
    80001c42:	74e2                	ld	s1,56(sp)
    80001c44:	7942                	ld	s2,48(sp)
    80001c46:	79a2                	ld	s3,40(sp)
    80001c48:	7a02                	ld	s4,32(sp)
    80001c4a:	6ae2                	ld	s5,24(sp)
    80001c4c:	6b42                	ld	s6,16(sp)
    80001c4e:	6ba2                	ld	s7,8(sp)
    80001c50:	6c02                	ld	s8,0(sp)
    80001c52:	6161                	addi	sp,sp,80
    80001c54:	8082                	ret

0000000080001c56 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001c56:	caa5                	beqz	a3,80001cc6 <copyin+0x70>
{
    80001c58:	715d                	addi	sp,sp,-80
    80001c5a:	e486                	sd	ra,72(sp)
    80001c5c:	e0a2                	sd	s0,64(sp)
    80001c5e:	fc26                	sd	s1,56(sp)
    80001c60:	f84a                	sd	s2,48(sp)
    80001c62:	f44e                	sd	s3,40(sp)
    80001c64:	f052                	sd	s4,32(sp)
    80001c66:	ec56                	sd	s5,24(sp)
    80001c68:	e85a                	sd	s6,16(sp)
    80001c6a:	e45e                	sd	s7,8(sp)
    80001c6c:	e062                	sd	s8,0(sp)
    80001c6e:	0880                	addi	s0,sp,80
    80001c70:	8b2a                	mv	s6,a0
    80001c72:	8a2e                	mv	s4,a1
    80001c74:	8c32                	mv	s8,a2
    80001c76:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001c78:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001c7a:	6a85                	lui	s5,0x1
    80001c7c:	a01d                	j	80001ca2 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001c7e:	018505b3          	add	a1,a0,s8
    80001c82:	0004861b          	sext.w	a2,s1
    80001c86:	412585b3          	sub	a1,a1,s2
    80001c8a:	8552                	mv	a0,s4
    80001c8c:	fffff097          	auipc	ra,0xfffff
    80001c90:	1e6080e7          	jalr	486(ra) # 80000e72 <memmove>

    len -= n;
    80001c94:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001c98:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001c9a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001c9e:	02098263          	beqz	s3,80001cc2 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001ca2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001ca6:	85ca                	mv	a1,s2
    80001ca8:	855a                	mv	a0,s6
    80001caa:	fffff097          	auipc	ra,0xfffff
    80001cae:	5e6080e7          	jalr	1510(ra) # 80001290 <walkaddr>
    if(pa0 == 0)
    80001cb2:	cd01                	beqz	a0,80001cca <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001cb4:	418904b3          	sub	s1,s2,s8
    80001cb8:	94d6                	add	s1,s1,s5
    if(n > len)
    80001cba:	fc99f2e3          	bgeu	s3,s1,80001c7e <copyin+0x28>
    80001cbe:	84ce                	mv	s1,s3
    80001cc0:	bf7d                	j	80001c7e <copyin+0x28>
  }
  return 0;
    80001cc2:	4501                	li	a0,0
    80001cc4:	a021                	j	80001ccc <copyin+0x76>
    80001cc6:	4501                	li	a0,0
}
    80001cc8:	8082                	ret
      return -1;
    80001cca:	557d                	li	a0,-1
}
    80001ccc:	60a6                	ld	ra,72(sp)
    80001cce:	6406                	ld	s0,64(sp)
    80001cd0:	74e2                	ld	s1,56(sp)
    80001cd2:	7942                	ld	s2,48(sp)
    80001cd4:	79a2                	ld	s3,40(sp)
    80001cd6:	7a02                	ld	s4,32(sp)
    80001cd8:	6ae2                	ld	s5,24(sp)
    80001cda:	6b42                	ld	s6,16(sp)
    80001cdc:	6ba2                	ld	s7,8(sp)
    80001cde:	6c02                	ld	s8,0(sp)
    80001ce0:	6161                	addi	sp,sp,80
    80001ce2:	8082                	ret

0000000080001ce4 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
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
    80001cf8:	0880                	addi	s0,sp,80
    80001cfa:	8aaa                	mv	s5,a0
    80001cfc:	89ae                	mv	s3,a1
    80001cfe:	8bb2                	mv	s7,a2
    80001d00:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80001d02:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001d04:	6a05                	lui	s4,0x1
    80001d06:	a02d                	j	80001d30 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001d08:	00078023          	sb	zero,0(a5)
    80001d0c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001d0e:	0017c793          	xori	a5,a5,1
    80001d12:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001d16:	60a6                	ld	ra,72(sp)
    80001d18:	6406                	ld	s0,64(sp)
    80001d1a:	74e2                	ld	s1,56(sp)
    80001d1c:	7942                	ld	s2,48(sp)
    80001d1e:	79a2                	ld	s3,40(sp)
    80001d20:	7a02                	ld	s4,32(sp)
    80001d22:	6ae2                	ld	s5,24(sp)
    80001d24:	6b42                	ld	s6,16(sp)
    80001d26:	6ba2                	ld	s7,8(sp)
    80001d28:	6161                	addi	sp,sp,80
    80001d2a:	8082                	ret
    srcva = va0 + PGSIZE;
    80001d2c:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001d30:	c8a1                	beqz	s1,80001d80 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80001d32:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001d36:	85ca                	mv	a1,s2
    80001d38:	8556                	mv	a0,s5
    80001d3a:	fffff097          	auipc	ra,0xfffff
    80001d3e:	556080e7          	jalr	1366(ra) # 80001290 <walkaddr>
    if(pa0 == 0)
    80001d42:	c129                	beqz	a0,80001d84 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80001d44:	41790633          	sub	a2,s2,s7
    80001d48:	9652                	add	a2,a2,s4
    if(n > max)
    80001d4a:	00c4f363          	bgeu	s1,a2,80001d50 <copyinstr+0x6c>
    80001d4e:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001d50:	412b8bb3          	sub	s7,s7,s2
    80001d54:	9baa                	add	s7,s7,a0
    while(n > 0){
    80001d56:	da79                	beqz	a2,80001d2c <copyinstr+0x48>
    80001d58:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80001d5a:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80001d5e:	964e                	add	a2,a2,s3
    80001d60:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001d62:	00f68733          	add	a4,a3,a5
    80001d66:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff90d68>
    80001d6a:	df59                	beqz	a4,80001d08 <copyinstr+0x24>
        *dst = *p;
    80001d6c:	00e78023          	sb	a4,0(a5)
      dst++;
    80001d70:	0785                	addi	a5,a5,1
    while(n > 0){
    80001d72:	fec797e3          	bne	a5,a2,80001d60 <copyinstr+0x7c>
    80001d76:	14fd                	addi	s1,s1,-1
    80001d78:	94ce                	add	s1,s1,s3
      --max;
    80001d7a:	8c8d                	sub	s1,s1,a1
    80001d7c:	89be                	mv	s3,a5
    80001d7e:	b77d                	j	80001d2c <copyinstr+0x48>
    80001d80:	4781                	li	a5,0
    80001d82:	b771                	j	80001d0e <copyinstr+0x2a>
      return -1;
    80001d84:	557d                	li	a0,-1
    80001d86:	bf41                	j	80001d16 <copyinstr+0x32>

0000000080001d88 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001d88:	715d                	addi	sp,sp,-80
    80001d8a:	e486                	sd	ra,72(sp)
    80001d8c:	e0a2                	sd	s0,64(sp)
    80001d8e:	fc26                	sd	s1,56(sp)
    80001d90:	f84a                	sd	s2,48(sp)
    80001d92:	f44e                	sd	s3,40(sp)
    80001d94:	f052                	sd	s4,32(sp)
    80001d96:	ec56                	sd	s5,24(sp)
    80001d98:	e85a                	sd	s6,16(sp)
    80001d9a:	e45e                	sd	s7,8(sp)
    80001d9c:	e062                	sd	s8,0(sp)
    80001d9e:	0880                	addi	s0,sp,80
    80001da0:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001da2:	00053497          	auipc	s1,0x53
    80001da6:	49e48493          	addi	s1,s1,1182 # 80055240 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001daa:	8c26                	mv	s8,s1
    80001dac:	586fb7b7          	lui	a5,0x586fb
    80001db0:	58778793          	addi	a5,a5,1415 # 586fb587 <_entry-0x27904a79>
    80001db4:	6fb58937          	lui	s2,0x6fb58
    80001db8:	6fb90913          	addi	s2,s2,1787 # 6fb586fb <_entry-0x104a7905>
    80001dbc:	1902                	slli	s2,s2,0x20
    80001dbe:	993e                	add	s2,s2,a5
    80001dc0:	040009b7          	lui	s3,0x4000
    80001dc4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001dc6:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001dc8:	4b99                	li	s7,6
    80001dca:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001dcc:	00061a97          	auipc	s5,0x61
    80001dd0:	074a8a93          	addi	s5,s5,116 # 80062e40 <tickslock>
    char *pa = kalloc();
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	e30080e7          	jalr	-464(ra) # 80000c04 <kalloc>
    80001ddc:	862a                	mv	a2,a0
    if(pa == 0)
    80001dde:	c131                	beqz	a0,80001e22 <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80001de0:	418485b3          	sub	a1,s1,s8
    80001de4:	8591                	srai	a1,a1,0x4
    80001de6:	032585b3          	mul	a1,a1,s2
    80001dea:	2585                	addiw	a1,a1,1
    80001dec:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001df0:	875e                	mv	a4,s7
    80001df2:	86da                	mv	a3,s6
    80001df4:	40b985b3          	sub	a1,s3,a1
    80001df8:	8552                	mv	a0,s4
    80001dfa:	fffff097          	auipc	ra,0xfffff
    80001dfe:	57e080e7          	jalr	1406(ra) # 80001378 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e02:	37048493          	addi	s1,s1,880
    80001e06:	fd5497e3          	bne	s1,s5,80001dd4 <proc_mapstacks+0x4c>
  }
}
    80001e0a:	60a6                	ld	ra,72(sp)
    80001e0c:	6406                	ld	s0,64(sp)
    80001e0e:	74e2                	ld	s1,56(sp)
    80001e10:	7942                	ld	s2,48(sp)
    80001e12:	79a2                	ld	s3,40(sp)
    80001e14:	7a02                	ld	s4,32(sp)
    80001e16:	6ae2                	ld	s5,24(sp)
    80001e18:	6b42                	ld	s6,16(sp)
    80001e1a:	6ba2                	ld	s7,8(sp)
    80001e1c:	6c02                	ld	s8,0(sp)
    80001e1e:	6161                	addi	sp,sp,80
    80001e20:	8082                	ret
      panic("kalloc");
    80001e22:	00007517          	auipc	a0,0x7
    80001e26:	44650513          	addi	a0,a0,1094 # 80009268 <etext+0x268>
    80001e2a:	ffffe097          	auipc	ra,0xffffe
    80001e2e:	736080e7          	jalr	1846(ra) # 80000560 <panic>

0000000080001e32 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001e32:	7139                	addi	sp,sp,-64
    80001e34:	fc06                	sd	ra,56(sp)
    80001e36:	f822                	sd	s0,48(sp)
    80001e38:	f426                	sd	s1,40(sp)
    80001e3a:	f04a                	sd	s2,32(sp)
    80001e3c:	ec4e                	sd	s3,24(sp)
    80001e3e:	e852                	sd	s4,16(sp)
    80001e40:	e456                	sd	s5,8(sp)
    80001e42:	e05a                	sd	s6,0(sp)
    80001e44:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001e46:	00007597          	auipc	a1,0x7
    80001e4a:	42a58593          	addi	a1,a1,1066 # 80009270 <etext+0x270>
    80001e4e:	00053517          	auipc	a0,0x53
    80001e52:	fc250513          	addi	a0,a0,-62 # 80054e10 <pid_lock>
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	e2c080e7          	jalr	-468(ra) # 80000c82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001e5e:	00007597          	auipc	a1,0x7
    80001e62:	41a58593          	addi	a1,a1,1050 # 80009278 <etext+0x278>
    80001e66:	00053517          	auipc	a0,0x53
    80001e6a:	fc250513          	addi	a0,a0,-62 # 80054e28 <wait_lock>
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	e14080e7          	jalr	-492(ra) # 80000c82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e76:	00053497          	auipc	s1,0x53
    80001e7a:	3ca48493          	addi	s1,s1,970 # 80055240 <proc>
      initlock(&p->lock, "proc");
    80001e7e:	00007b17          	auipc	s6,0x7
    80001e82:	40ab0b13          	addi	s6,s6,1034 # 80009288 <etext+0x288>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001e86:	8aa6                	mv	s5,s1
    80001e88:	586fb7b7          	lui	a5,0x586fb
    80001e8c:	58778793          	addi	a5,a5,1415 # 586fb587 <_entry-0x27904a79>
    80001e90:	6fb58937          	lui	s2,0x6fb58
    80001e94:	6fb90913          	addi	s2,s2,1787 # 6fb586fb <_entry-0x104a7905>
    80001e98:	1902                	slli	s2,s2,0x20
    80001e9a:	993e                	add	s2,s2,a5
    80001e9c:	040009b7          	lui	s3,0x4000
    80001ea0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001ea2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ea4:	00061a17          	auipc	s4,0x61
    80001ea8:	f9ca0a13          	addi	s4,s4,-100 # 80062e40 <tickslock>
      initlock(&p->lock, "proc");
    80001eac:	85da                	mv	a1,s6
    80001eae:	8526                	mv	a0,s1
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	dd2080e7          	jalr	-558(ra) # 80000c82 <initlock>
      p->state = UNUSED;
    80001eb8:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001ebc:	415487b3          	sub	a5,s1,s5
    80001ec0:	8791                	srai	a5,a5,0x4
    80001ec2:	032787b3          	mul	a5,a5,s2
    80001ec6:	2785                	addiw	a5,a5,1
    80001ec8:	00d7979b          	slliw	a5,a5,0xd
    80001ecc:	40f987b3          	sub	a5,s3,a5
    80001ed0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ed2:	37048493          	addi	s1,s1,880
    80001ed6:	fd449be3          	bne	s1,s4,80001eac <procinit+0x7a>
  }
}
    80001eda:	70e2                	ld	ra,56(sp)
    80001edc:	7442                	ld	s0,48(sp)
    80001ede:	74a2                	ld	s1,40(sp)
    80001ee0:	7902                	ld	s2,32(sp)
    80001ee2:	69e2                	ld	s3,24(sp)
    80001ee4:	6a42                	ld	s4,16(sp)
    80001ee6:	6aa2                	ld	s5,8(sp)
    80001ee8:	6b02                	ld	s6,0(sp)
    80001eea:	6121                	addi	sp,sp,64
    80001eec:	8082                	ret

0000000080001eee <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001eee:	1141                	addi	sp,sp,-16
    80001ef0:	e406                	sd	ra,8(sp)
    80001ef2:	e022                	sd	s0,0(sp)
    80001ef4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ef6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001ef8:	2501                	sext.w	a0,a0
    80001efa:	60a2                	ld	ra,8(sp)
    80001efc:	6402                	ld	s0,0(sp)
    80001efe:	0141                	addi	sp,sp,16
    80001f00:	8082                	ret

0000000080001f02 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001f02:	1141                	addi	sp,sp,-16
    80001f04:	e406                	sd	ra,8(sp)
    80001f06:	e022                	sd	s0,0(sp)
    80001f08:	0800                	addi	s0,sp,16
    80001f0a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001f0c:	2781                	sext.w	a5,a5
    80001f0e:	079e                	slli	a5,a5,0x7
  return c;
}
    80001f10:	00053517          	auipc	a0,0x53
    80001f14:	f3050513          	addi	a0,a0,-208 # 80054e40 <cpus>
    80001f18:	953e                	add	a0,a0,a5
    80001f1a:	60a2                	ld	ra,8(sp)
    80001f1c:	6402                	ld	s0,0(sp)
    80001f1e:	0141                	addi	sp,sp,16
    80001f20:	8082                	ret

0000000080001f22 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001f22:	1101                	addi	sp,sp,-32
    80001f24:	ec06                	sd	ra,24(sp)
    80001f26:	e822                	sd	s0,16(sp)
    80001f28:	e426                	sd	s1,8(sp)
    80001f2a:	1000                	addi	s0,sp,32
  push_off();
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	d9e080e7          	jalr	-610(ra) # 80000cca <push_off>
    80001f34:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001f36:	2781                	sext.w	a5,a5
    80001f38:	079e                	slli	a5,a5,0x7
    80001f3a:	00053717          	auipc	a4,0x53
    80001f3e:	ed670713          	addi	a4,a4,-298 # 80054e10 <pid_lock>
    80001f42:	97ba                	add	a5,a5,a4
    80001f44:	7b84                	ld	s1,48(a5)
  pop_off();
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	e24080e7          	jalr	-476(ra) # 80000d6a <pop_off>
  return p;
}
    80001f4e:	8526                	mv	a0,s1
    80001f50:	60e2                	ld	ra,24(sp)
    80001f52:	6442                	ld	s0,16(sp)
    80001f54:	64a2                	ld	s1,8(sp)
    80001f56:	6105                	addi	sp,sp,32
    80001f58:	8082                	ret

0000000080001f5a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001f5a:	1141                	addi	sp,sp,-16
    80001f5c:	e406                	sd	ra,8(sp)
    80001f5e:	e022                	sd	s0,0(sp)
    80001f60:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001f62:	00000097          	auipc	ra,0x0
    80001f66:	fc0080e7          	jalr	-64(ra) # 80001f22 <myproc>
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	e5c080e7          	jalr	-420(ra) # 80000dc6 <release>

  if (first) {
    80001f72:	0000b797          	auipc	a5,0xb
    80001f76:	bae7a783          	lw	a5,-1106(a5) # 8000cb20 <first.1>
    80001f7a:	eb89                	bnez	a5,80001f8c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001f7c:	00001097          	auipc	ra,0x1
    80001f80:	19e080e7          	jalr	414(ra) # 8000311a <usertrapret>
}
    80001f84:	60a2                	ld	ra,8(sp)
    80001f86:	6402                	ld	s0,0(sp)
    80001f88:	0141                	addi	sp,sp,16
    80001f8a:	8082                	ret
    first = 0;
    80001f8c:	0000b797          	auipc	a5,0xb
    80001f90:	b807aa23          	sw	zero,-1132(a5) # 8000cb20 <first.1>
    fsinit(ROOTDEV);
    80001f94:	4505                	li	a0,1
    80001f96:	00002097          	auipc	ra,0x2
    80001f9a:	148080e7          	jalr	328(ra) # 800040de <fsinit>
    80001f9e:	bff9                	j	80001f7c <forkret+0x22>

0000000080001fa0 <allocpid>:
{
    80001fa0:	1101                	addi	sp,sp,-32
    80001fa2:	ec06                	sd	ra,24(sp)
    80001fa4:	e822                	sd	s0,16(sp)
    80001fa6:	e426                	sd	s1,8(sp)
    80001fa8:	e04a                	sd	s2,0(sp)
    80001faa:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001fac:	00053917          	auipc	s2,0x53
    80001fb0:	e6490913          	addi	s2,s2,-412 # 80054e10 <pid_lock>
    80001fb4:	854a                	mv	a0,s2
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	d60080e7          	jalr	-672(ra) # 80000d16 <acquire>
  pid = nextpid;
    80001fbe:	0000b797          	auipc	a5,0xb
    80001fc2:	b6678793          	addi	a5,a5,-1178 # 8000cb24 <nextpid>
    80001fc6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001fc8:	0014871b          	addiw	a4,s1,1
    80001fcc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001fce:	854a                	mv	a0,s2
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	df6080e7          	jalr	-522(ra) # 80000dc6 <release>
}
    80001fd8:	8526                	mv	a0,s1
    80001fda:	60e2                	ld	ra,24(sp)
    80001fdc:	6442                	ld	s0,16(sp)
    80001fde:	64a2                	ld	s1,8(sp)
    80001fe0:	6902                	ld	s2,0(sp)
    80001fe2:	6105                	addi	sp,sp,32
    80001fe4:	8082                	ret

0000000080001fe6 <proc_pagetable>:
{
    80001fe6:	1101                	addi	sp,sp,-32
    80001fe8:	ec06                	sd	ra,24(sp)
    80001fea:	e822                	sd	s0,16(sp)
    80001fec:	e426                	sd	s1,8(sp)
    80001fee:	e04a                	sd	s2,0(sp)
    80001ff0:	1000                	addi	s0,sp,32
    80001ff2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	58c080e7          	jalr	1420(ra) # 80001580 <uvmcreate>
    80001ffc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001ffe:	c121                	beqz	a0,8000203e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80002000:	4729                	li	a4,10
    80002002:	00006697          	auipc	a3,0x6
    80002006:	ffe68693          	addi	a3,a3,-2 # 80008000 <_trampoline>
    8000200a:	6605                	lui	a2,0x1
    8000200c:	040005b7          	lui	a1,0x4000
    80002010:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002012:	05b2                	slli	a1,a1,0xc
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	2be080e7          	jalr	702(ra) # 800012d2 <mappages>
    8000201c:	02054863          	bltz	a0,8000204c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80002020:	4719                	li	a4,6
    80002022:	05893683          	ld	a3,88(s2)
    80002026:	6605                	lui	a2,0x1
    80002028:	020005b7          	lui	a1,0x2000
    8000202c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000202e:	05b6                	slli	a1,a1,0xd
    80002030:	8526                	mv	a0,s1
    80002032:	fffff097          	auipc	ra,0xfffff
    80002036:	2a0080e7          	jalr	672(ra) # 800012d2 <mappages>
    8000203a:	02054163          	bltz	a0,8000205c <proc_pagetable+0x76>
}
    8000203e:	8526                	mv	a0,s1
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	64a2                	ld	s1,8(sp)
    80002046:	6902                	ld	s2,0(sp)
    80002048:	6105                	addi	sp,sp,32
    8000204a:	8082                	ret
    uvmfree(pagetable, 0);
    8000204c:	4581                	li	a1,0
    8000204e:	8526                	mv	a0,s1
    80002050:	00000097          	auipc	ra,0x0
    80002054:	96c080e7          	jalr	-1684(ra) # 800019bc <uvmfree>
    return 0;
    80002058:	4481                	li	s1,0
    8000205a:	b7d5                	j	8000203e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000205c:	4681                	li	a3,0
    8000205e:	4605                	li	a2,1
    80002060:	040005b7          	lui	a1,0x4000
    80002064:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002066:	05b2                	slli	a1,a1,0xc
    80002068:	8526                	mv	a0,s1
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	442080e7          	jalr	1090(ra) # 800014ac <uvmunmap>
    uvmfree(pagetable, 0);
    80002072:	4581                	li	a1,0
    80002074:	8526                	mv	a0,s1
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	946080e7          	jalr	-1722(ra) # 800019bc <uvmfree>
    return 0;
    8000207e:	4481                	li	s1,0
    80002080:	bf7d                	j	8000203e <proc_pagetable+0x58>

0000000080002082 <proc_freepagetable>:
{
    80002082:	1101                	addi	sp,sp,-32
    80002084:	ec06                	sd	ra,24(sp)
    80002086:	e822                	sd	s0,16(sp)
    80002088:	e426                	sd	s1,8(sp)
    8000208a:	e04a                	sd	s2,0(sp)
    8000208c:	1000                	addi	s0,sp,32
    8000208e:	84aa                	mv	s1,a0
    80002090:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002092:	4681                	li	a3,0
    80002094:	4605                	li	a2,1
    80002096:	040005b7          	lui	a1,0x4000
    8000209a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000209c:	05b2                	slli	a1,a1,0xc
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	40e080e7          	jalr	1038(ra) # 800014ac <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800020a6:	4681                	li	a3,0
    800020a8:	4605                	li	a2,1
    800020aa:	020005b7          	lui	a1,0x2000
    800020ae:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800020b0:	05b6                	slli	a1,a1,0xd
    800020b2:	8526                	mv	a0,s1
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	3f8080e7          	jalr	1016(ra) # 800014ac <uvmunmap>
  uvmfree(pagetable, sz);
    800020bc:	85ca                	mv	a1,s2
    800020be:	8526                	mv	a0,s1
    800020c0:	00000097          	auipc	ra,0x0
    800020c4:	8fc080e7          	jalr	-1796(ra) # 800019bc <uvmfree>
}
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	64a2                	ld	s1,8(sp)
    800020ce:	6902                	ld	s2,0(sp)
    800020d0:	6105                	addi	sp,sp,32
    800020d2:	8082                	ret

00000000800020d4 <freeproc>:
{
    800020d4:	1101                	addi	sp,sp,-32
    800020d6:	ec06                	sd	ra,24(sp)
    800020d8:	e822                	sd	s0,16(sp)
    800020da:	e426                	sd	s1,8(sp)
    800020dc:	1000                	addi	s0,sp,32
    800020de:	84aa                	mv	s1,a0
  if(p->trapframe)
    800020e0:	6d28                	ld	a0,88(a0)
    800020e2:	c509                	beqz	a0,800020ec <freeproc+0x18>
    kfree((void*)p->trapframe);
    800020e4:	fffff097          	auipc	ra,0xfffff
    800020e8:	9b8080e7          	jalr	-1608(ra) # 80000a9c <kfree>
  p->trapframe = 0;
    800020ec:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800020f0:	68a8                	ld	a0,80(s1)
    800020f2:	c511                	beqz	a0,800020fe <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800020f4:	64ac                	ld	a1,72(s1)
    800020f6:	00000097          	auipc	ra,0x0
    800020fa:	f8c080e7          	jalr	-116(ra) # 80002082 <proc_freepagetable>
  p->pagetable = 0;
    800020fe:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80002102:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80002106:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000210a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000210e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80002112:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002116:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000211a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000211e:	0004ac23          	sw	zero,24(s1)
}
    80002122:	60e2                	ld	ra,24(sp)
    80002124:	6442                	ld	s0,16(sp)
    80002126:	64a2                	ld	s1,8(sp)
    80002128:	6105                	addi	sp,sp,32
    8000212a:	8082                	ret

000000008000212c <allocproc>:
{
    8000212c:	1101                	addi	sp,sp,-32
    8000212e:	ec06                	sd	ra,24(sp)
    80002130:	e822                	sd	s0,16(sp)
    80002132:	e426                	sd	s1,8(sp)
    80002134:	e04a                	sd	s2,0(sp)
    80002136:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80002138:	00053497          	auipc	s1,0x53
    8000213c:	10848493          	addi	s1,s1,264 # 80055240 <proc>
    80002140:	00061917          	auipc	s2,0x61
    80002144:	d0090913          	addi	s2,s2,-768 # 80062e40 <tickslock>
    acquire(&p->lock);
    80002148:	8526                	mv	a0,s1
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	bcc080e7          	jalr	-1076(ra) # 80000d16 <acquire>
    if(p->state == UNUSED) {
    80002152:	4c9c                	lw	a5,24(s1)
    80002154:	cf81                	beqz	a5,8000216c <allocproc+0x40>
      release(&p->lock);
    80002156:	8526                	mv	a0,s1
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	c6e080e7          	jalr	-914(ra) # 80000dc6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002160:	37048493          	addi	s1,s1,880
    80002164:	ff2492e3          	bne	s1,s2,80002148 <allocproc+0x1c>
  return 0;
    80002168:	4481                	li	s1,0
    8000216a:	a095                	j	800021ce <allocproc+0xa2>
  p->pid = allocpid();
    8000216c:	00000097          	auipc	ra,0x0
    80002170:	e34080e7          	jalr	-460(ra) # 80001fa0 <allocpid>
    80002174:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002176:	4785                	li	a5,1
    80002178:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	a8a080e7          	jalr	-1398(ra) # 80000c04 <kalloc>
    80002182:	892a                	mv	s2,a0
    80002184:	eca8                	sd	a0,88(s1)
    80002186:	c939                	beqz	a0,800021dc <allocproc+0xb0>
  p->pagetable = proc_pagetable(p);
    80002188:	8526                	mv	a0,s1
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	e5c080e7          	jalr	-420(ra) # 80001fe6 <proc_pagetable>
    80002192:	892a                	mv	s2,a0
    80002194:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80002196:	cd39                	beqz	a0,800021f4 <allocproc+0xc8>
  memset(&p->context, 0, sizeof(p->context));
    80002198:	07000613          	li	a2,112
    8000219c:	4581                	li	a1,0
    8000219e:	06048513          	addi	a0,s1,96
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	c6c080e7          	jalr	-916(ra) # 80000e0e <memset>
  p->context.ra = (uint64)forkret;
    800021aa:	00000797          	auipc	a5,0x0
    800021ae:	db078793          	addi	a5,a5,-592 # 80001f5a <forkret>
    800021b2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800021b4:	60bc                	ld	a5,64(s1)
    800021b6:	6705                	lui	a4,0x1
    800021b8:	97ba                	add	a5,a5,a4
    800021ba:	f4bc                	sd	a5,104(s1)
  memset(p->infant_threads, 0, MAX_THREADS);
    800021bc:	04000613          	li	a2,64
    800021c0:	4581                	li	a1,0
    800021c2:	17048513          	addi	a0,s1,368
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	c48080e7          	jalr	-952(ra) # 80000e0e <memset>
}
    800021ce:	8526                	mv	a0,s1
    800021d0:	60e2                	ld	ra,24(sp)
    800021d2:	6442                	ld	s0,16(sp)
    800021d4:	64a2                	ld	s1,8(sp)
    800021d6:	6902                	ld	s2,0(sp)
    800021d8:	6105                	addi	sp,sp,32
    800021da:	8082                	ret
    freeproc(p);
    800021dc:	8526                	mv	a0,s1
    800021de:	00000097          	auipc	ra,0x0
    800021e2:	ef6080e7          	jalr	-266(ra) # 800020d4 <freeproc>
    release(&p->lock);
    800021e6:	8526                	mv	a0,s1
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	bde080e7          	jalr	-1058(ra) # 80000dc6 <release>
    return 0;
    800021f0:	84ca                	mv	s1,s2
    800021f2:	bff1                	j	800021ce <allocproc+0xa2>
    freeproc(p);
    800021f4:	8526                	mv	a0,s1
    800021f6:	00000097          	auipc	ra,0x0
    800021fa:	ede080e7          	jalr	-290(ra) # 800020d4 <freeproc>
    release(&p->lock);
    800021fe:	8526                	mv	a0,s1
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	bc6080e7          	jalr	-1082(ra) # 80000dc6 <release>
    return 0;
    80002208:	84ca                	mv	s1,s2
    8000220a:	b7d1                	j	800021ce <allocproc+0xa2>

000000008000220c <userinit>:
{
    8000220c:	1101                	addi	sp,sp,-32
    8000220e:	ec06                	sd	ra,24(sp)
    80002210:	e822                	sd	s0,16(sp)
    80002212:	e426                	sd	s1,8(sp)
    80002214:	1000                	addi	s0,sp,32
  p = allocproc();
    80002216:	00000097          	auipc	ra,0x0
    8000221a:	f16080e7          	jalr	-234(ra) # 8000212c <allocproc>
    8000221e:	84aa                	mv	s1,a0
  initproc = p;
    80002220:	0000b797          	auipc	a5,0xb
    80002224:	96a7bc23          	sd	a0,-1672(a5) # 8000cb98 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002228:	03400613          	li	a2,52
    8000222c:	0000b597          	auipc	a1,0xb
    80002230:	90458593          	addi	a1,a1,-1788 # 8000cb30 <initcode>
    80002234:	6928                	ld	a0,80(a0)
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	378080e7          	jalr	888(ra) # 800015ae <uvmfirst>
  p->sz = PGSIZE;
    8000223e:	6785                	lui	a5,0x1
    80002240:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80002242:	6cb8                	ld	a4,88(s1)
    80002244:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002248:	6cb8                	ld	a4,88(s1)
    8000224a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000224c:	4641                	li	a2,16
    8000224e:	00007597          	auipc	a1,0x7
    80002252:	04258593          	addi	a1,a1,66 # 80009290 <etext+0x290>
    80002256:	15848513          	addi	a0,s1,344
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	d0a080e7          	jalr	-758(ra) # 80000f64 <safestrcpy>
  p->cwd = namei("/");
    80002262:	00007517          	auipc	a0,0x7
    80002266:	03e50513          	addi	a0,a0,62 # 800092a0 <etext+0x2a0>
    8000226a:	00003097          	auipc	ra,0x3
    8000226e:	8dc080e7          	jalr	-1828(ra) # 80004b46 <namei>
    80002272:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80002276:	478d                	li	a5,3
    80002278:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000227a:	8526                	mv	a0,s1
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	b4a080e7          	jalr	-1206(ra) # 80000dc6 <release>
}
    80002284:	60e2                	ld	ra,24(sp)
    80002286:	6442                	ld	s0,16(sp)
    80002288:	64a2                	ld	s1,8(sp)
    8000228a:	6105                	addi	sp,sp,32
    8000228c:	8082                	ret

000000008000228e <growproc>:
{
    8000228e:	1101                	addi	sp,sp,-32
    80002290:	ec06                	sd	ra,24(sp)
    80002292:	e822                	sd	s0,16(sp)
    80002294:	e426                	sd	s1,8(sp)
    80002296:	e04a                	sd	s2,0(sp)
    80002298:	1000                	addi	s0,sp,32
    8000229a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000229c:	00000097          	auipc	ra,0x0
    800022a0:	c86080e7          	jalr	-890(ra) # 80001f22 <myproc>
    800022a4:	84aa                	mv	s1,a0
  sz = p->sz;
    800022a6:	652c                	ld	a1,72(a0)
  if(n > 0){
    800022a8:	05205463          	blez	s2,800022f0 <growproc+0x62>
    if (p->is_thread == 1) {
    800022ac:	16852703          	lw	a4,360(a0)
    800022b0:	4785                	li	a5,1
    800022b2:	02f70463          	beq	a4,a5,800022da <growproc+0x4c>
    } else if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800022b6:	4691                	li	a3,4
    800022b8:	00b90633          	add	a2,s2,a1
    800022bc:	6928                	ld	a0,80(a0)
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	3aa080e7          	jalr	938(ra) # 80001668 <uvmalloc>
    800022c6:	85aa                	mv	a1,a0
    800022c8:	cd21                	beqz	a0,80002320 <growproc+0x92>
  p->sz = sz;
    800022ca:	e4ac                	sd	a1,72(s1)
  return 0;
    800022cc:	4501                	li	a0,0
}
    800022ce:	60e2                	ld	ra,24(sp)
    800022d0:	6442                	ld	s0,16(sp)
    800022d2:	64a2                	ld	s1,8(sp)
    800022d4:	6902                	ld	s2,0(sp)
    800022d6:	6105                	addi	sp,sp,32
    800022d8:	8082                	ret
      if ((sz = uvmthreaded_alloc(p, sz, sz + n, PTE_W)) == 0) {
    800022da:	4691                	li	a3,4
    800022dc:	00b90633          	add	a2,s2,a1
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	44e080e7          	jalr	1102(ra) # 8000172e <uvmthreaded_alloc>
    800022e8:	85aa                	mv	a1,a0
    800022ea:	f165                	bnez	a0,800022ca <growproc+0x3c>
        return -1;
    800022ec:	557d                	li	a0,-1
    800022ee:	b7c5                	j	800022ce <growproc+0x40>
  } else if(n < 0){
    800022f0:	fc095de3          	bgez	s2,800022ca <growproc+0x3c>
    if (p->is_thread == 1)
    800022f4:	16852703          	lw	a4,360(a0)
    800022f8:	4785                	li	a5,1
    800022fa:	00f70b63          	beq	a4,a5,80002310 <growproc+0x82>
      sz = uvmdealloc(p->pagetable, sz, sz + n);
    800022fe:	00b90633          	add	a2,s2,a1
    80002302:	6928                	ld	a0,80(a0)
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	31c080e7          	jalr	796(ra) # 80001620 <uvmdealloc>
    8000230c:	85aa                	mv	a1,a0
    8000230e:	bf75                	j	800022ca <growproc+0x3c>
      sz = uvmthreaded_dealloc(p, sz, sz + n);
    80002310:	00b90633          	add	a2,s2,a1
    80002314:	fffff097          	auipc	ra,0xfffff
    80002318:	596080e7          	jalr	1430(ra) # 800018aa <uvmthreaded_dealloc>
    8000231c:	85aa                	mv	a1,a0
    8000231e:	b775                	j	800022ca <growproc+0x3c>
      return -1;
    80002320:	557d                	li	a0,-1
    80002322:	b775                	j	800022ce <growproc+0x40>

0000000080002324 <fork>:
{
    80002324:	7139                	addi	sp,sp,-64
    80002326:	fc06                	sd	ra,56(sp)
    80002328:	f822                	sd	s0,48(sp)
    8000232a:	f04a                	sd	s2,32(sp)
    8000232c:	e456                	sd	s5,8(sp)
    8000232e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002330:	00000097          	auipc	ra,0x0
    80002334:	bf2080e7          	jalr	-1038(ra) # 80001f22 <myproc>
    80002338:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000233a:	00000097          	auipc	ra,0x0
    8000233e:	df2080e7          	jalr	-526(ra) # 8000212c <allocproc>
    80002342:	12050263          	beqz	a0,80002466 <fork+0x142>
    80002346:	ec4e                	sd	s3,24(sp)
    80002348:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000234a:	048ab603          	ld	a2,72(s5)
    8000234e:	692c                	ld	a1,80(a0)
    80002350:	050ab503          	ld	a0,80(s5)
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	6a2080e7          	jalr	1698(ra) # 800019f6 <uvmcopy>
    8000235c:	04054a63          	bltz	a0,800023b0 <fork+0x8c>
    80002360:	f426                	sd	s1,40(sp)
    80002362:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80002364:	048ab783          	ld	a5,72(s5)
    80002368:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000236c:	058ab683          	ld	a3,88(s5)
    80002370:	87b6                	mv	a5,a3
    80002372:	0589b703          	ld	a4,88(s3)
    80002376:	12068693          	addi	a3,a3,288
    8000237a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000237e:	6788                	ld	a0,8(a5)
    80002380:	6b8c                	ld	a1,16(a5)
    80002382:	6f90                	ld	a2,24(a5)
    80002384:	01073023          	sd	a6,0(a4)
    80002388:	e708                	sd	a0,8(a4)
    8000238a:	eb0c                	sd	a1,16(a4)
    8000238c:	ef10                	sd	a2,24(a4)
    8000238e:	02078793          	addi	a5,a5,32
    80002392:	02070713          	addi	a4,a4,32
    80002396:	fed792e3          	bne	a5,a3,8000237a <fork+0x56>
  np->trapframe->a0 = 0;
    8000239a:	0589b783          	ld	a5,88(s3)
    8000239e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800023a2:	0d0a8493          	addi	s1,s5,208
    800023a6:	0d098913          	addi	s2,s3,208
    800023aa:	150a8a13          	addi	s4,s5,336
    800023ae:	a015                	j	800023d2 <fork+0xae>
    freeproc(np);
    800023b0:	854e                	mv	a0,s3
    800023b2:	00000097          	auipc	ra,0x0
    800023b6:	d22080e7          	jalr	-734(ra) # 800020d4 <freeproc>
    release(&np->lock);
    800023ba:	854e                	mv	a0,s3
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	a0a080e7          	jalr	-1526(ra) # 80000dc6 <release>
    return -1;
    800023c4:	597d                	li	s2,-1
    800023c6:	69e2                	ld	s3,24(sp)
    800023c8:	a841                	j	80002458 <fork+0x134>
  for(i = 0; i < NOFILE; i++)
    800023ca:	04a1                	addi	s1,s1,8
    800023cc:	0921                	addi	s2,s2,8
    800023ce:	01448b63          	beq	s1,s4,800023e4 <fork+0xc0>
    if(p->ofile[i])
    800023d2:	6088                	ld	a0,0(s1)
    800023d4:	d97d                	beqz	a0,800023ca <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800023d6:	00003097          	auipc	ra,0x3
    800023da:	df4080e7          	jalr	-524(ra) # 800051ca <filedup>
    800023de:	00a93023          	sd	a0,0(s2)
    800023e2:	b7e5                	j	800023ca <fork+0xa6>
  np->cwd = idup(p->cwd);
    800023e4:	150ab503          	ld	a0,336(s5)
    800023e8:	00002097          	auipc	ra,0x2
    800023ec:	f3c080e7          	jalr	-196(ra) # 80004324 <idup>
    800023f0:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800023f4:	4641                	li	a2,16
    800023f6:	158a8593          	addi	a1,s5,344
    800023fa:	15898513          	addi	a0,s3,344
    800023fe:	fffff097          	auipc	ra,0xfffff
    80002402:	b66080e7          	jalr	-1178(ra) # 80000f64 <safestrcpy>
  pid = np->pid;
    80002406:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000240a:	854e                	mv	a0,s3
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	9ba080e7          	jalr	-1606(ra) # 80000dc6 <release>
  acquire(&wait_lock);
    80002414:	00053497          	auipc	s1,0x53
    80002418:	a1448493          	addi	s1,s1,-1516 # 80054e28 <wait_lock>
    8000241c:	8526                	mv	a0,s1
    8000241e:	fffff097          	auipc	ra,0xfffff
    80002422:	8f8080e7          	jalr	-1800(ra) # 80000d16 <acquire>
  np->parent = p;
    80002426:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000242a:	8526                	mv	a0,s1
    8000242c:	fffff097          	auipc	ra,0xfffff
    80002430:	99a080e7          	jalr	-1638(ra) # 80000dc6 <release>
  acquire(&np->lock);
    80002434:	854e                	mv	a0,s3
    80002436:	fffff097          	auipc	ra,0xfffff
    8000243a:	8e0080e7          	jalr	-1824(ra) # 80000d16 <acquire>
  np->state = RUNNABLE;
    8000243e:	478d                	li	a5,3
    80002440:	00f9ac23          	sw	a5,24(s3)
  np->is_thread = 0;
    80002444:	1609a423          	sw	zero,360(s3)
  release(&np->lock);
    80002448:	854e                	mv	a0,s3
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	97c080e7          	jalr	-1668(ra) # 80000dc6 <release>
  return pid;
    80002452:	74a2                	ld	s1,40(sp)
    80002454:	69e2                	ld	s3,24(sp)
    80002456:	6a42                	ld	s4,16(sp)
}
    80002458:	854a                	mv	a0,s2
    8000245a:	70e2                	ld	ra,56(sp)
    8000245c:	7442                	ld	s0,48(sp)
    8000245e:	7902                	ld	s2,32(sp)
    80002460:	6aa2                	ld	s5,8(sp)
    80002462:	6121                	addi	sp,sp,64
    80002464:	8082                	ret
    return -1;
    80002466:	597d                	li	s2,-1
    80002468:	bfc5                	j	80002458 <fork+0x134>

000000008000246a <create_thread>:
int create_thread(void* (*fn_addr)(void *), void *args, void *stack_addr, void (*exit_fn)(uint64)) {
    8000246a:	715d                	addi	sp,sp,-80
    8000246c:	e486                	sd	ra,72(sp)
    8000246e:	e0a2                	sd	s0,64(sp)
    80002470:	fc26                	sd	s1,56(sp)
    80002472:	f84a                	sd	s2,48(sp)
    80002474:	f44e                	sd	s3,40(sp)
    80002476:	f052                	sd	s4,32(sp)
    80002478:	ec56                	sd	s5,24(sp)
    8000247a:	e85a                	sd	s6,16(sp)
    8000247c:	e45e                	sd	s7,8(sp)
    8000247e:	0880                	addi	s0,sp,80
    80002480:	8baa                	mv	s7,a0
    80002482:	8aae                	mv	s5,a1
    80002484:	84b2                	mv	s1,a2
    80002486:	89b6                	mv	s3,a3
  struct proc *p = myproc();
    80002488:	00000097          	auipc	ra,0x0
    8000248c:	a9a080e7          	jalr	-1382(ra) # 80001f22 <myproc>
    80002490:	8b2a                	mv	s6,a0
  for (int i = 0; i < MAX_THREADS; i++) {
    80002492:	17050713          	addi	a4,a0,368
    80002496:	4781                	li	a5,0
    80002498:	04000893          	li	a7,64
    if (p->infant_threads[i] == 0) {
    8000249c:	00073803          	ld	a6,0(a4)
    800024a0:	00080863          	beqz	a6,800024b0 <create_thread+0x46>
  for (int i = 0; i < MAX_THREADS; i++) {
    800024a4:	2785                	addiw	a5,a5,1
    800024a6:	0721                	addi	a4,a4,8
    800024a8:	ff179ae3          	bne	a5,a7,8000249c <create_thread+0x32>
  uint64 thread_idx = 0;
    800024ac:	4901                	li	s2,0
    800024ae:	a011                	j	800024b2 <create_thread+0x48>
      thread_idx = i;
    800024b0:	893e                	mv	s2,a5
  if((np = allocproc()) == 0){
    800024b2:	00000097          	auipc	ra,0x0
    800024b6:	c7a080e7          	jalr	-902(ra) # 8000212c <allocproc>
    800024ba:	8a2a                	mv	s4,a0
    800024bc:	cd3d                	beqz	a0,8000253a <create_thread+0xd0>
  if(uvmshare(p->pagetable, np->pagetable, p->sz) < 0){
    800024be:	048b3603          	ld	a2,72(s6)
    800024c2:	692c                	ld	a1,80(a0)
    800024c4:	050b3503          	ld	a0,80(s6)
    800024c8:	fffff097          	auipc	ra,0xfffff
    800024cc:	604080e7          	jalr	1540(ra) # 80001acc <uvmshare>
    800024d0:	06054f63          	bltz	a0,8000254e <create_thread+0xe4>
  np->sz = p->sz;
    800024d4:	048b3783          	ld	a5,72(s6)
    800024d8:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800024dc:	058b3683          	ld	a3,88(s6)
    800024e0:	87b6                	mv	a5,a3
    800024e2:	058a3703          	ld	a4,88(s4)
    800024e6:	12068693          	addi	a3,a3,288
    800024ea:	0007b803          	ld	a6,0(a5)
    800024ee:	6788                	ld	a0,8(a5)
    800024f0:	6b8c                	ld	a1,16(a5)
    800024f2:	6f90                	ld	a2,24(a5)
    800024f4:	01073023          	sd	a6,0(a4)
    800024f8:	e708                	sd	a0,8(a4)
    800024fa:	eb0c                	sd	a1,16(a4)
    800024fc:	ef10                	sd	a2,24(a4)
    800024fe:	02078793          	addi	a5,a5,32
    80002502:	02070713          	addi	a4,a4,32
    80002506:	fed792e3          	bne	a5,a3,800024ea <create_thread+0x80>
  np->trapframe->sp = (uint64)stack_addr + PGSIZE;
    8000250a:	058a3783          	ld	a5,88(s4)
    8000250e:	6705                	lui	a4,0x1
    80002510:	94ba                	add	s1,s1,a4
    80002512:	fb84                	sd	s1,48(a5)
  np->trapframe->epc = (uint64)fn_addr;
    80002514:	058a3783          	ld	a5,88(s4)
    80002518:	0177bc23          	sd	s7,24(a5)
  np->trapframe->a0 = (uint64)args;
    8000251c:	058a3783          	ld	a5,88(s4)
    80002520:	0757b823          	sd	s5,112(a5)
  np->trapframe->ra = (uint64)exit_fn;
    80002524:	058a3783          	ld	a5,88(s4)
    80002528:	0337b423          	sd	s3,40(a5)
  for(i = 0; i < NOFILE; i++)
    8000252c:	0d0b0493          	addi	s1,s6,208
    80002530:	0d0a0993          	addi	s3,s4,208
    80002534:	150b0a93          	addi	s5,s6,336
    80002538:	a81d                	j	8000256e <create_thread+0x104>
    printf("Max processes reached\n");
    8000253a:	00007517          	auipc	a0,0x7
    8000253e:	d6e50513          	addi	a0,a0,-658 # 800092a8 <etext+0x2a8>
    80002542:	ffffe097          	auipc	ra,0xffffe
    80002546:	068080e7          	jalr	104(ra) # 800005aa <printf>
    return -1;
    8000254a:	557d                	li	a0,-1
    8000254c:	a85d                	j	80002602 <create_thread+0x198>
    freeproc(np);
    8000254e:	8552                	mv	a0,s4
    80002550:	00000097          	auipc	ra,0x0
    80002554:	b84080e7          	jalr	-1148(ra) # 800020d4 <freeproc>
    release(&np->lock);
    80002558:	8552                	mv	a0,s4
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	86c080e7          	jalr	-1940(ra) # 80000dc6 <release>
    return -1;
    80002562:	557d                	li	a0,-1
    80002564:	a879                	j	80002602 <create_thread+0x198>
  for(i = 0; i < NOFILE; i++)
    80002566:	04a1                	addi	s1,s1,8
    80002568:	09a1                	addi	s3,s3,8
    8000256a:	01548b63          	beq	s1,s5,80002580 <create_thread+0x116>
    if(p->ofile[i])
    8000256e:	6088                	ld	a0,0(s1)
    80002570:	d97d                	beqz	a0,80002566 <create_thread+0xfc>
      np->ofile[i] = filedup(p->ofile[i]);
    80002572:	00003097          	auipc	ra,0x3
    80002576:	c58080e7          	jalr	-936(ra) # 800051ca <filedup>
    8000257a:	00a9b023          	sd	a0,0(s3)
    8000257e:	b7e5                	j	80002566 <create_thread+0xfc>
  np->cwd = idup(p->cwd);
    80002580:	150b3503          	ld	a0,336(s6)
    80002584:	00002097          	auipc	ra,0x2
    80002588:	da0080e7          	jalr	-608(ra) # 80004324 <idup>
    8000258c:	14aa3823          	sd	a0,336(s4)
  release(&np->lock);
    80002590:	8552                	mv	a0,s4
    80002592:	fffff097          	auipc	ra,0xfffff
    80002596:	834080e7          	jalr	-1996(ra) # 80000dc6 <release>
  acquire(&wait_lock);
    8000259a:	00053517          	auipc	a0,0x53
    8000259e:	88e50513          	addi	a0,a0,-1906 # 80054e28 <wait_lock>
    800025a2:	ffffe097          	auipc	ra,0xffffe
    800025a6:	774080e7          	jalr	1908(ra) # 80000d16 <acquire>
  if (p->is_thread) {
    800025aa:	168b2783          	lw	a5,360(s6)
    800025ae:	c7ad                	beqz	a5,80002618 <create_thread+0x1ae>
    np->parent = p->parent->parent;
    800025b0:	038b3783          	ld	a5,56(s6)
    800025b4:	7f9c                	ld	a5,56(a5)
    800025b6:	02fa3c23          	sd	a5,56(s4)
    p = p->parent->parent;
    800025ba:	038b3783          	ld	a5,56(s6)
    800025be:	0387bb03          	ld	s6,56(a5)
  release(&wait_lock);
    800025c2:	00053517          	auipc	a0,0x53
    800025c6:	86650513          	addi	a0,a0,-1946 # 80054e28 <wait_lock>
    800025ca:	ffffe097          	auipc	ra,0xffffe
    800025ce:	7fc080e7          	jalr	2044(ra) # 80000dc6 <release>
  acquire(&np->lock);
    800025d2:	8552                	mv	a0,s4
    800025d4:	ffffe097          	auipc	ra,0xffffe
    800025d8:	742080e7          	jalr	1858(ra) # 80000d16 <acquire>
  np->is_thread = 1;
    800025dc:	4785                	li	a5,1
    800025de:	16fa2423          	sw	a5,360(s4)
  np->state = RUNNABLE;
    800025e2:	478d                	li	a5,3
    800025e4:	00fa2c23          	sw	a5,24(s4)
  p->infant_threads[thread_idx] = np;
    800025e8:	02e90793          	addi	a5,s2,46
    800025ec:	078e                	slli	a5,a5,0x3
    800025ee:	9b3e                	add	s6,s6,a5
    800025f0:	014b3023          	sd	s4,0(s6)
  release(&np->lock);
    800025f4:	8552                	mv	a0,s4
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	7d0080e7          	jalr	2000(ra) # 80000dc6 <release>
  return np->pid;
    800025fe:	030a2503          	lw	a0,48(s4)
}
    80002602:	60a6                	ld	ra,72(sp)
    80002604:	6406                	ld	s0,64(sp)
    80002606:	74e2                	ld	s1,56(sp)
    80002608:	7942                	ld	s2,48(sp)
    8000260a:	79a2                	ld	s3,40(sp)
    8000260c:	7a02                	ld	s4,32(sp)
    8000260e:	6ae2                	ld	s5,24(sp)
    80002610:	6b42                	ld	s6,16(sp)
    80002612:	6ba2                	ld	s7,8(sp)
    80002614:	6161                	addi	sp,sp,80
    80002616:	8082                	ret
    np->parent = p;
    80002618:	036a3c23          	sd	s6,56(s4)
    8000261c:	b75d                	j	800025c2 <create_thread+0x158>

000000008000261e <socket>:
{
    8000261e:	1141                	addi	sp,sp,-16
    80002620:	e406                	sd	ra,8(sp)
    80002622:	e022                	sd	s0,0(sp)
    80002624:	0800                	addi	s0,sp,16
}
    80002626:	4501                	li	a0,0
    80002628:	60a2                	ld	ra,8(sp)
    8000262a:	6402                	ld	s0,0(sp)
    8000262c:	0141                	addi	sp,sp,16
    8000262e:	8082                	ret

0000000080002630 <bind>:
{
    80002630:	1141                	addi	sp,sp,-16
    80002632:	e406                	sd	ra,8(sp)
    80002634:	e022                	sd	s0,0(sp)
    80002636:	0800                	addi	s0,sp,16
}
    80002638:	4501                	li	a0,0
    8000263a:	60a2                	ld	ra,8(sp)
    8000263c:	6402                	ld	s0,0(sp)
    8000263e:	0141                	addi	sp,sp,16
    80002640:	8082                	ret

0000000080002642 <listen>:
{
    80002642:	1141                	addi	sp,sp,-16
    80002644:	e406                	sd	ra,8(sp)
    80002646:	e022                	sd	s0,0(sp)
    80002648:	0800                	addi	s0,sp,16
}
    8000264a:	4501                	li	a0,0
    8000264c:	60a2                	ld	ra,8(sp)
    8000264e:	6402                	ld	s0,0(sp)
    80002650:	0141                	addi	sp,sp,16
    80002652:	8082                	ret

0000000080002654 <accept>:
{
    80002654:	1141                	addi	sp,sp,-16
    80002656:	e406                	sd	ra,8(sp)
    80002658:	e022                	sd	s0,0(sp)
    8000265a:	0800                	addi	s0,sp,16
}
    8000265c:	4501                	li	a0,0
    8000265e:	60a2                	ld	ra,8(sp)
    80002660:	6402                	ld	s0,0(sp)
    80002662:	0141                	addi	sp,sp,16
    80002664:	8082                	ret

0000000080002666 <connect>:
{
    80002666:	1141                	addi	sp,sp,-16
    80002668:	e406                	sd	ra,8(sp)
    8000266a:	e022                	sd	s0,0(sp)
    8000266c:	0800                	addi	s0,sp,16
}
    8000266e:	4501                	li	a0,0
    80002670:	60a2                	ld	ra,8(sp)
    80002672:	6402                	ld	s0,0(sp)
    80002674:	0141                	addi	sp,sp,16
    80002676:	8082                	ret

0000000080002678 <scheduler>:
{
    80002678:	7139                	addi	sp,sp,-64
    8000267a:	fc06                	sd	ra,56(sp)
    8000267c:	f822                	sd	s0,48(sp)
    8000267e:	f426                	sd	s1,40(sp)
    80002680:	f04a                	sd	s2,32(sp)
    80002682:	ec4e                	sd	s3,24(sp)
    80002684:	e852                	sd	s4,16(sp)
    80002686:	e456                	sd	s5,8(sp)
    80002688:	e05a                	sd	s6,0(sp)
    8000268a:	0080                	addi	s0,sp,64
    8000268c:	8792                	mv	a5,tp
  int id = r_tp();
    8000268e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002690:	00779a93          	slli	s5,a5,0x7
    80002694:	00052717          	auipc	a4,0x52
    80002698:	77c70713          	addi	a4,a4,1916 # 80054e10 <pid_lock>
    8000269c:	9756                	add	a4,a4,s5
    8000269e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800026a2:	00052717          	auipc	a4,0x52
    800026a6:	7a670713          	addi	a4,a4,1958 # 80054e48 <cpus+0x8>
    800026aa:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800026ac:	498d                	li	s3,3
        p->state = RUNNING;
    800026ae:	4b11                	li	s6,4
        c->proc = p;
    800026b0:	079e                	slli	a5,a5,0x7
    800026b2:	00052a17          	auipc	s4,0x52
    800026b6:	75ea0a13          	addi	s4,s4,1886 # 80054e10 <pid_lock>
    800026ba:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800026c0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026c4:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800026c8:	00053497          	auipc	s1,0x53
    800026cc:	b7848493          	addi	s1,s1,-1160 # 80055240 <proc>
    800026d0:	00060917          	auipc	s2,0x60
    800026d4:	77090913          	addi	s2,s2,1904 # 80062e40 <tickslock>
    800026d8:	a811                	j	800026ec <scheduler+0x74>
      release(&p->lock);
    800026da:	8526                	mv	a0,s1
    800026dc:	ffffe097          	auipc	ra,0xffffe
    800026e0:	6ea080e7          	jalr	1770(ra) # 80000dc6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800026e4:	37048493          	addi	s1,s1,880
    800026e8:	fd248ae3          	beq	s1,s2,800026bc <scheduler+0x44>
      acquire(&p->lock);
    800026ec:	8526                	mv	a0,s1
    800026ee:	ffffe097          	auipc	ra,0xffffe
    800026f2:	628080e7          	jalr	1576(ra) # 80000d16 <acquire>
      if(p->state == RUNNABLE) {
    800026f6:	4c9c                	lw	a5,24(s1)
    800026f8:	ff3791e3          	bne	a5,s3,800026da <scheduler+0x62>
        p->state = RUNNING;
    800026fc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002700:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80002704:	06048593          	addi	a1,s1,96
    80002708:	8556                	mv	a0,s5
    8000270a:	00001097          	auipc	ra,0x1
    8000270e:	962080e7          	jalr	-1694(ra) # 8000306c <swtch>
        c->proc = 0;
    80002712:	020a3823          	sd	zero,48(s4)
    80002716:	b7d1                	j	800026da <scheduler+0x62>

0000000080002718 <sched>:
{
    80002718:	7179                	addi	sp,sp,-48
    8000271a:	f406                	sd	ra,40(sp)
    8000271c:	f022                	sd	s0,32(sp)
    8000271e:	ec26                	sd	s1,24(sp)
    80002720:	e84a                	sd	s2,16(sp)
    80002722:	e44e                	sd	s3,8(sp)
    80002724:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002726:	fffff097          	auipc	ra,0xfffff
    8000272a:	7fc080e7          	jalr	2044(ra) # 80001f22 <myproc>
    8000272e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	56c080e7          	jalr	1388(ra) # 80000c9c <holding>
    80002738:	c93d                	beqz	a0,800027ae <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000273a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000273c:	2781                	sext.w	a5,a5
    8000273e:	079e                	slli	a5,a5,0x7
    80002740:	00052717          	auipc	a4,0x52
    80002744:	6d070713          	addi	a4,a4,1744 # 80054e10 <pid_lock>
    80002748:	97ba                	add	a5,a5,a4
    8000274a:	0a87a703          	lw	a4,168(a5)
    8000274e:	4785                	li	a5,1
    80002750:	06f71763          	bne	a4,a5,800027be <sched+0xa6>
  if(p->state == RUNNING)
    80002754:	4c98                	lw	a4,24(s1)
    80002756:	4791                	li	a5,4
    80002758:	06f70b63          	beq	a4,a5,800027ce <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000275c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002760:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002762:	efb5                	bnez	a5,800027de <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002764:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002766:	00052917          	auipc	s2,0x52
    8000276a:	6aa90913          	addi	s2,s2,1706 # 80054e10 <pid_lock>
    8000276e:	2781                	sext.w	a5,a5
    80002770:	079e                	slli	a5,a5,0x7
    80002772:	97ca                	add	a5,a5,s2
    80002774:	0ac7a983          	lw	s3,172(a5)
    80002778:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000277a:	2781                	sext.w	a5,a5
    8000277c:	079e                	slli	a5,a5,0x7
    8000277e:	00052597          	auipc	a1,0x52
    80002782:	6ca58593          	addi	a1,a1,1738 # 80054e48 <cpus+0x8>
    80002786:	95be                	add	a1,a1,a5
    80002788:	06048513          	addi	a0,s1,96
    8000278c:	00001097          	auipc	ra,0x1
    80002790:	8e0080e7          	jalr	-1824(ra) # 8000306c <swtch>
    80002794:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002796:	2781                	sext.w	a5,a5
    80002798:	079e                	slli	a5,a5,0x7
    8000279a:	993e                	add	s2,s2,a5
    8000279c:	0b392623          	sw	s3,172(s2)
}
    800027a0:	70a2                	ld	ra,40(sp)
    800027a2:	7402                	ld	s0,32(sp)
    800027a4:	64e2                	ld	s1,24(sp)
    800027a6:	6942                	ld	s2,16(sp)
    800027a8:	69a2                	ld	s3,8(sp)
    800027aa:	6145                	addi	sp,sp,48
    800027ac:	8082                	ret
    panic("sched p->lock");
    800027ae:	00007517          	auipc	a0,0x7
    800027b2:	b1250513          	addi	a0,a0,-1262 # 800092c0 <etext+0x2c0>
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	daa080e7          	jalr	-598(ra) # 80000560 <panic>
    panic("sched locks");
    800027be:	00007517          	auipc	a0,0x7
    800027c2:	b1250513          	addi	a0,a0,-1262 # 800092d0 <etext+0x2d0>
    800027c6:	ffffe097          	auipc	ra,0xffffe
    800027ca:	d9a080e7          	jalr	-614(ra) # 80000560 <panic>
    panic("sched running");
    800027ce:	00007517          	auipc	a0,0x7
    800027d2:	b1250513          	addi	a0,a0,-1262 # 800092e0 <etext+0x2e0>
    800027d6:	ffffe097          	auipc	ra,0xffffe
    800027da:	d8a080e7          	jalr	-630(ra) # 80000560 <panic>
    panic("sched interruptible");
    800027de:	00007517          	auipc	a0,0x7
    800027e2:	b1250513          	addi	a0,a0,-1262 # 800092f0 <etext+0x2f0>
    800027e6:	ffffe097          	auipc	ra,0xffffe
    800027ea:	d7a080e7          	jalr	-646(ra) # 80000560 <panic>

00000000800027ee <yield>:
{
    800027ee:	1101                	addi	sp,sp,-32
    800027f0:	ec06                	sd	ra,24(sp)
    800027f2:	e822                	sd	s0,16(sp)
    800027f4:	e426                	sd	s1,8(sp)
    800027f6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800027f8:	fffff097          	auipc	ra,0xfffff
    800027fc:	72a080e7          	jalr	1834(ra) # 80001f22 <myproc>
    80002800:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002802:	ffffe097          	auipc	ra,0xffffe
    80002806:	514080e7          	jalr	1300(ra) # 80000d16 <acquire>
  p->state = RUNNABLE;
    8000280a:	478d                	li	a5,3
    8000280c:	cc9c                	sw	a5,24(s1)
  sched();
    8000280e:	00000097          	auipc	ra,0x0
    80002812:	f0a080e7          	jalr	-246(ra) # 80002718 <sched>
  release(&p->lock);
    80002816:	8526                	mv	a0,s1
    80002818:	ffffe097          	auipc	ra,0xffffe
    8000281c:	5ae080e7          	jalr	1454(ra) # 80000dc6 <release>
}
    80002820:	60e2                	ld	ra,24(sp)
    80002822:	6442                	ld	s0,16(sp)
    80002824:	64a2                	ld	s1,8(sp)
    80002826:	6105                	addi	sp,sp,32
    80002828:	8082                	ret

000000008000282a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000282a:	7179                	addi	sp,sp,-48
    8000282c:	f406                	sd	ra,40(sp)
    8000282e:	f022                	sd	s0,32(sp)
    80002830:	ec26                	sd	s1,24(sp)
    80002832:	e84a                	sd	s2,16(sp)
    80002834:	e44e                	sd	s3,8(sp)
    80002836:	1800                	addi	s0,sp,48
    80002838:	89aa                	mv	s3,a0
    8000283a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000283c:	fffff097          	auipc	ra,0xfffff
    80002840:	6e6080e7          	jalr	1766(ra) # 80001f22 <myproc>
    80002844:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002846:	ffffe097          	auipc	ra,0xffffe
    8000284a:	4d0080e7          	jalr	1232(ra) # 80000d16 <acquire>
  release(lk);
    8000284e:	854a                	mv	a0,s2
    80002850:	ffffe097          	auipc	ra,0xffffe
    80002854:	576080e7          	jalr	1398(ra) # 80000dc6 <release>

  // Go to sleep.
  p->chan = chan;
    80002858:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000285c:	4789                	li	a5,2
    8000285e:	cc9c                	sw	a5,24(s1)

  sched();
    80002860:	00000097          	auipc	ra,0x0
    80002864:	eb8080e7          	jalr	-328(ra) # 80002718 <sched>

  // Tidy up.
  p->chan = 0;
    80002868:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000286c:	8526                	mv	a0,s1
    8000286e:	ffffe097          	auipc	ra,0xffffe
    80002872:	558080e7          	jalr	1368(ra) # 80000dc6 <release>
  acquire(lk);
    80002876:	854a                	mv	a0,s2
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	49e080e7          	jalr	1182(ra) # 80000d16 <acquire>
}
    80002880:	70a2                	ld	ra,40(sp)
    80002882:	7402                	ld	s0,32(sp)
    80002884:	64e2                	ld	s1,24(sp)
    80002886:	6942                	ld	s2,16(sp)
    80002888:	69a2                	ld	s3,8(sp)
    8000288a:	6145                	addi	sp,sp,48
    8000288c:	8082                	ret

000000008000288e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000288e:	7139                	addi	sp,sp,-64
    80002890:	fc06                	sd	ra,56(sp)
    80002892:	f822                	sd	s0,48(sp)
    80002894:	f426                	sd	s1,40(sp)
    80002896:	f04a                	sd	s2,32(sp)
    80002898:	ec4e                	sd	s3,24(sp)
    8000289a:	e852                	sd	s4,16(sp)
    8000289c:	e456                	sd	s5,8(sp)
    8000289e:	0080                	addi	s0,sp,64
    800028a0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800028a2:	00053497          	auipc	s1,0x53
    800028a6:	99e48493          	addi	s1,s1,-1634 # 80055240 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800028aa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800028ac:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800028ae:	00060917          	auipc	s2,0x60
    800028b2:	59290913          	addi	s2,s2,1426 # 80062e40 <tickslock>
    800028b6:	a811                	j	800028ca <wakeup+0x3c>
      }
      release(&p->lock);
    800028b8:	8526                	mv	a0,s1
    800028ba:	ffffe097          	auipc	ra,0xffffe
    800028be:	50c080e7          	jalr	1292(ra) # 80000dc6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800028c2:	37048493          	addi	s1,s1,880
    800028c6:	03248663          	beq	s1,s2,800028f2 <wakeup+0x64>
    if(p != myproc()){
    800028ca:	fffff097          	auipc	ra,0xfffff
    800028ce:	658080e7          	jalr	1624(ra) # 80001f22 <myproc>
    800028d2:	fea488e3          	beq	s1,a0,800028c2 <wakeup+0x34>
      acquire(&p->lock);
    800028d6:	8526                	mv	a0,s1
    800028d8:	ffffe097          	auipc	ra,0xffffe
    800028dc:	43e080e7          	jalr	1086(ra) # 80000d16 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800028e0:	4c9c                	lw	a5,24(s1)
    800028e2:	fd379be3          	bne	a5,s3,800028b8 <wakeup+0x2a>
    800028e6:	709c                	ld	a5,32(s1)
    800028e8:	fd4798e3          	bne	a5,s4,800028b8 <wakeup+0x2a>
        p->state = RUNNABLE;
    800028ec:	0154ac23          	sw	s5,24(s1)
    800028f0:	b7e1                	j	800028b8 <wakeup+0x2a>
    }
  }
}
    800028f2:	70e2                	ld	ra,56(sp)
    800028f4:	7442                	ld	s0,48(sp)
    800028f6:	74a2                	ld	s1,40(sp)
    800028f8:	7902                	ld	s2,32(sp)
    800028fa:	69e2                	ld	s3,24(sp)
    800028fc:	6a42                	ld	s4,16(sp)
    800028fe:	6aa2                	ld	s5,8(sp)
    80002900:	6121                	addi	sp,sp,64
    80002902:	8082                	ret

0000000080002904 <reparent>:
{
    80002904:	7179                	addi	sp,sp,-48
    80002906:	f406                	sd	ra,40(sp)
    80002908:	f022                	sd	s0,32(sp)
    8000290a:	ec26                	sd	s1,24(sp)
    8000290c:	e84a                	sd	s2,16(sp)
    8000290e:	e44e                	sd	s3,8(sp)
    80002910:	e052                	sd	s4,0(sp)
    80002912:	1800                	addi	s0,sp,48
    80002914:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002916:	00053497          	auipc	s1,0x53
    8000291a:	92a48493          	addi	s1,s1,-1750 # 80055240 <proc>
      pp->parent = initproc;
    8000291e:	0000aa17          	auipc	s4,0xa
    80002922:	27aa0a13          	addi	s4,s4,634 # 8000cb98 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002926:	00060997          	auipc	s3,0x60
    8000292a:	51a98993          	addi	s3,s3,1306 # 80062e40 <tickslock>
    8000292e:	a029                	j	80002938 <reparent+0x34>
    80002930:	37048493          	addi	s1,s1,880
    80002934:	01348d63          	beq	s1,s3,8000294e <reparent+0x4a>
    if(pp->parent == p){
    80002938:	7c9c                	ld	a5,56(s1)
    8000293a:	ff279be3          	bne	a5,s2,80002930 <reparent+0x2c>
      pp->parent = initproc;
    8000293e:	000a3503          	ld	a0,0(s4)
    80002942:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002944:	00000097          	auipc	ra,0x0
    80002948:	f4a080e7          	jalr	-182(ra) # 8000288e <wakeup>
    8000294c:	b7d5                	j	80002930 <reparent+0x2c>
}
    8000294e:	70a2                	ld	ra,40(sp)
    80002950:	7402                	ld	s0,32(sp)
    80002952:	64e2                	ld	s1,24(sp)
    80002954:	6942                	ld	s2,16(sp)
    80002956:	69a2                	ld	s3,8(sp)
    80002958:	6a02                	ld	s4,0(sp)
    8000295a:	6145                	addi	sp,sp,48
    8000295c:	8082                	ret

000000008000295e <thread_exit>:
uint64 thread_exit(uint64 status) {
    8000295e:	7179                	addi	sp,sp,-48
    80002960:	f406                	sd	ra,40(sp)
    80002962:	f022                	sd	s0,32(sp)
    80002964:	ec26                	sd	s1,24(sp)
    80002966:	e84a                	sd	s2,16(sp)
    80002968:	e44e                	sd	s3,8(sp)
    8000296a:	e052                	sd	s4,0(sp)
    8000296c:	1800                	addi	s0,sp,48
    8000296e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002970:	fffff097          	auipc	ra,0xfffff
    80002974:	5b2080e7          	jalr	1458(ra) # 80001f22 <myproc>
    80002978:	89aa                	mv	s3,a0
  if(p == initproc)
    8000297a:	0000a797          	auipc	a5,0xa
    8000297e:	21e7b783          	ld	a5,542(a5) # 8000cb98 <initproc>
    80002982:	0d050493          	addi	s1,a0,208
    80002986:	15050913          	addi	s2,a0,336
    8000298a:	00a79d63          	bne	a5,a0,800029a4 <thread_exit+0x46>
    panic("init exiting");
    8000298e:	00007517          	auipc	a0,0x7
    80002992:	97a50513          	addi	a0,a0,-1670 # 80009308 <etext+0x308>
    80002996:	ffffe097          	auipc	ra,0xffffe
    8000299a:	bca080e7          	jalr	-1078(ra) # 80000560 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000299e:	04a1                	addi	s1,s1,8
    800029a0:	01248b63          	beq	s1,s2,800029b6 <thread_exit+0x58>
    if(p->ofile[fd]){
    800029a4:	6088                	ld	a0,0(s1)
    800029a6:	dd65                	beqz	a0,8000299e <thread_exit+0x40>
      fileclose(f);
    800029a8:	00003097          	auipc	ra,0x3
    800029ac:	874080e7          	jalr	-1932(ra) # 8000521c <fileclose>
      p->ofile[fd] = 0;
    800029b0:	0004b023          	sd	zero,0(s1)
    800029b4:	b7ed                	j	8000299e <thread_exit+0x40>
  begin_op();
    800029b6:	00002097          	auipc	ra,0x2
    800029ba:	396080e7          	jalr	918(ra) # 80004d4c <begin_op>
  iput(p->cwd);
    800029be:	1509b503          	ld	a0,336(s3)
    800029c2:	00002097          	auipc	ra,0x2
    800029c6:	b5e080e7          	jalr	-1186(ra) # 80004520 <iput>
  end_op();
    800029ca:	00002097          	auipc	ra,0x2
    800029ce:	3fc080e7          	jalr	1020(ra) # 80004dc6 <end_op>
  p->cwd = 0;
    800029d2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800029d6:	00052497          	auipc	s1,0x52
    800029da:	45248493          	addi	s1,s1,1106 # 80054e28 <wait_lock>
    800029de:	8526                	mv	a0,s1
    800029e0:	ffffe097          	auipc	ra,0xffffe
    800029e4:	336080e7          	jalr	822(ra) # 80000d16 <acquire>
  reparent(p);
    800029e8:	854e                	mv	a0,s3
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	f1a080e7          	jalr	-230(ra) # 80002904 <reparent>
  wakeup(p->parent);
    800029f2:	0389b503          	ld	a0,56(s3)
    800029f6:	00000097          	auipc	ra,0x0
    800029fa:	e98080e7          	jalr	-360(ra) # 8000288e <wakeup>
  acquire(&p->lock);
    800029fe:	854e                	mv	a0,s3
    80002a00:	ffffe097          	auipc	ra,0xffffe
    80002a04:	316080e7          	jalr	790(ra) # 80000d16 <acquire>
  p->xstate = status;
    80002a08:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002a0c:	4795                	li	a5,5
    80002a0e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002a12:	8526                	mv	a0,s1
    80002a14:	ffffe097          	auipc	ra,0xffffe
    80002a18:	3b2080e7          	jalr	946(ra) # 80000dc6 <release>
  sched();
    80002a1c:	00000097          	auipc	ra,0x0
    80002a20:	cfc080e7          	jalr	-772(ra) # 80002718 <sched>
  panic("zombie exit");
    80002a24:	00007517          	auipc	a0,0x7
    80002a28:	8f450513          	addi	a0,a0,-1804 # 80009318 <etext+0x318>
    80002a2c:	ffffe097          	auipc	ra,0xffffe
    80002a30:	b34080e7          	jalr	-1228(ra) # 80000560 <panic>

0000000080002a34 <exit>:
{
    80002a34:	711d                	addi	sp,sp,-96
    80002a36:	ec86                	sd	ra,88(sp)
    80002a38:	e8a2                	sd	s0,80(sp)
    80002a3a:	e4a6                	sd	s1,72(sp)
    80002a3c:	e0ca                	sd	s2,64(sp)
    80002a3e:	fc4e                	sd	s3,56(sp)
    80002a40:	f852                	sd	s4,48(sp)
    80002a42:	f456                	sd	s5,40(sp)
    80002a44:	f05a                	sd	s6,32(sp)
    80002a46:	ec5e                	sd	s7,24(sp)
    80002a48:	e862                	sd	s8,16(sp)
    80002a4a:	e466                	sd	s9,8(sp)
    80002a4c:	1080                	addi	s0,sp,96
    80002a4e:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002a50:	fffff097          	auipc	ra,0xfffff
    80002a54:	4d2080e7          	jalr	1234(ra) # 80001f22 <myproc>
    80002a58:	8c2a                	mv	s8,a0
  if (p->is_thread) {
    80002a5a:	16852783          	lw	a5,360(a0)
    80002a5e:	cfc9                	beqz	a5,80002af8 <exit+0xc4>
    struct proc *parent = p->parent;
    80002a60:	03853b03          	ld	s6,56(a0)
    for (int i = 0; i < MAX_THREADS; i++) {
    80002a64:	170b0a13          	addi	s4,s6,368
    80002a68:	370b0b13          	addi	s6,s6,880
      acquire(&wait_lock);
    80002a6c:	00052a97          	auipc	s5,0x52
    80002a70:	3bca8a93          	addi	s5,s5,956 # 80054e28 <wait_lock>
      infant->state = ZOMBIE;
    80002a74:	4c95                	li	s9,5
    80002a76:	a885                	j	80002ae6 <exit+0xb2>
          fileclose(f);
    80002a78:	00002097          	auipc	ra,0x2
    80002a7c:	7a4080e7          	jalr	1956(ra) # 8000521c <fileclose>
          infant->ofile[fd] = 0;
    80002a80:	0004b023          	sd	zero,0(s1)
      for(int fd = 0; fd < NOFILE; fd++){
    80002a84:	04a1                	addi	s1,s1,8
    80002a86:	01248563          	beq	s1,s2,80002a90 <exit+0x5c>
        if(infant->ofile[fd]){
    80002a8a:	6088                	ld	a0,0(s1)
    80002a8c:	f575                	bnez	a0,80002a78 <exit+0x44>
    80002a8e:	bfdd                	j	80002a84 <exit+0x50>
      begin_op();
    80002a90:	00002097          	auipc	ra,0x2
    80002a94:	2bc080e7          	jalr	700(ra) # 80004d4c <begin_op>
      iput(infant->cwd);
    80002a98:	1509b503          	ld	a0,336(s3)
    80002a9c:	00002097          	auipc	ra,0x2
    80002aa0:	a84080e7          	jalr	-1404(ra) # 80004520 <iput>
      end_op();
    80002aa4:	00002097          	auipc	ra,0x2
    80002aa8:	322080e7          	jalr	802(ra) # 80004dc6 <end_op>
      infant->cwd = 0;
    80002aac:	1409b823          	sd	zero,336(s3)
      acquire(&wait_lock);
    80002ab0:	8556                	mv	a0,s5
    80002ab2:	ffffe097          	auipc	ra,0xffffe
    80002ab6:	264080e7          	jalr	612(ra) # 80000d16 <acquire>
      acquire(&infant->lock);
    80002aba:	854e                	mv	a0,s3
    80002abc:	ffffe097          	auipc	ra,0xffffe
    80002ac0:	25a080e7          	jalr	602(ra) # 80000d16 <acquire>
      infant->xstate = status;
    80002ac4:	0379a623          	sw	s7,44(s3)
      infant->state = ZOMBIE;
    80002ac8:	0199ac23          	sw	s9,24(s3)
      release(&infant->lock);
    80002acc:	854e                	mv	a0,s3
    80002ace:	ffffe097          	auipc	ra,0xffffe
    80002ad2:	2f8080e7          	jalr	760(ra) # 80000dc6 <release>
      release(&wait_lock);
    80002ad6:	8556                	mv	a0,s5
    80002ad8:	ffffe097          	auipc	ra,0xffffe
    80002adc:	2ee080e7          	jalr	750(ra) # 80000dc6 <release>
    for (int i = 0; i < MAX_THREADS; i++) {
    80002ae0:	0a21                	addi	s4,s4,8
    80002ae2:	016a0b63          	beq	s4,s6,80002af8 <exit+0xc4>
      struct proc *infant = parent->infant_threads[i];
    80002ae6:	000a3983          	ld	s3,0(s4)
      if (infant == 0) 
    80002aea:	fe098be3          	beqz	s3,80002ae0 <exit+0xac>
    80002aee:	0d098493          	addi	s1,s3,208
    80002af2:	15098913          	addi	s2,s3,336
    80002af6:	bf51                	j	80002a8a <exit+0x56>
  if(p == initproc)
    80002af8:	0000a797          	auipc	a5,0xa
    80002afc:	0a07b783          	ld	a5,160(a5) # 8000cb98 <initproc>
    80002b00:	0d0c0493          	addi	s1,s8,208
    80002b04:	150c0913          	addi	s2,s8,336
    80002b08:	01879d63          	bne	a5,s8,80002b22 <exit+0xee>
    panic("init exiting");
    80002b0c:	00006517          	auipc	a0,0x6
    80002b10:	7fc50513          	addi	a0,a0,2044 # 80009308 <etext+0x308>
    80002b14:	ffffe097          	auipc	ra,0xffffe
    80002b18:	a4c080e7          	jalr	-1460(ra) # 80000560 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002b1c:	04a1                	addi	s1,s1,8
    80002b1e:	01248b63          	beq	s1,s2,80002b34 <exit+0x100>
    if(p->ofile[fd]){
    80002b22:	6088                	ld	a0,0(s1)
    80002b24:	dd65                	beqz	a0,80002b1c <exit+0xe8>
      fileclose(f);
    80002b26:	00002097          	auipc	ra,0x2
    80002b2a:	6f6080e7          	jalr	1782(ra) # 8000521c <fileclose>
      p->ofile[fd] = 0;
    80002b2e:	0004b023          	sd	zero,0(s1)
    80002b32:	b7ed                	j	80002b1c <exit+0xe8>
  begin_op();
    80002b34:	00002097          	auipc	ra,0x2
    80002b38:	218080e7          	jalr	536(ra) # 80004d4c <begin_op>
  iput(p->cwd);
    80002b3c:	150c3503          	ld	a0,336(s8)
    80002b40:	00002097          	auipc	ra,0x2
    80002b44:	9e0080e7          	jalr	-1568(ra) # 80004520 <iput>
  end_op();
    80002b48:	00002097          	auipc	ra,0x2
    80002b4c:	27e080e7          	jalr	638(ra) # 80004dc6 <end_op>
  p->cwd = 0;
    80002b50:	140c3823          	sd	zero,336(s8)
  acquire(&wait_lock);
    80002b54:	00052497          	auipc	s1,0x52
    80002b58:	2d448493          	addi	s1,s1,724 # 80054e28 <wait_lock>
    80002b5c:	8526                	mv	a0,s1
    80002b5e:	ffffe097          	auipc	ra,0xffffe
    80002b62:	1b8080e7          	jalr	440(ra) # 80000d16 <acquire>
  reparent(p);
    80002b66:	8562                	mv	a0,s8
    80002b68:	00000097          	auipc	ra,0x0
    80002b6c:	d9c080e7          	jalr	-612(ra) # 80002904 <reparent>
  wakeup(p->parent);
    80002b70:	038c3503          	ld	a0,56(s8)
    80002b74:	00000097          	auipc	ra,0x0
    80002b78:	d1a080e7          	jalr	-742(ra) # 8000288e <wakeup>
  acquire(&p->lock);
    80002b7c:	8562                	mv	a0,s8
    80002b7e:	ffffe097          	auipc	ra,0xffffe
    80002b82:	198080e7          	jalr	408(ra) # 80000d16 <acquire>
  p->xstate = status;
    80002b86:	037c2623          	sw	s7,44(s8)
  p->state = ZOMBIE;
    80002b8a:	4795                	li	a5,5
    80002b8c:	00fc2c23          	sw	a5,24(s8)
  release(&wait_lock);
    80002b90:	8526                	mv	a0,s1
    80002b92:	ffffe097          	auipc	ra,0xffffe
    80002b96:	234080e7          	jalr	564(ra) # 80000dc6 <release>
  sched();
    80002b9a:	00000097          	auipc	ra,0x0
    80002b9e:	b7e080e7          	jalr	-1154(ra) # 80002718 <sched>
  panic("zombie exit");
    80002ba2:	00006517          	auipc	a0,0x6
    80002ba6:	77650513          	addi	a0,a0,1910 # 80009318 <etext+0x318>
    80002baa:	ffffe097          	auipc	ra,0xffffe
    80002bae:	9b6080e7          	jalr	-1610(ra) # 80000560 <panic>

0000000080002bb2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002bb2:	7179                	addi	sp,sp,-48
    80002bb4:	f406                	sd	ra,40(sp)
    80002bb6:	f022                	sd	s0,32(sp)
    80002bb8:	ec26                	sd	s1,24(sp)
    80002bba:	e84a                	sd	s2,16(sp)
    80002bbc:	e44e                	sd	s3,8(sp)
    80002bbe:	1800                	addi	s0,sp,48
    80002bc0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002bc2:	00052497          	auipc	s1,0x52
    80002bc6:	67e48493          	addi	s1,s1,1662 # 80055240 <proc>
    80002bca:	00060997          	auipc	s3,0x60
    80002bce:	27698993          	addi	s3,s3,630 # 80062e40 <tickslock>
    acquire(&p->lock);
    80002bd2:	8526                	mv	a0,s1
    80002bd4:	ffffe097          	auipc	ra,0xffffe
    80002bd8:	142080e7          	jalr	322(ra) # 80000d16 <acquire>
    if(p->pid == pid){
    80002bdc:	589c                	lw	a5,48(s1)
    80002bde:	01278d63          	beq	a5,s2,80002bf8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002be2:	8526                	mv	a0,s1
    80002be4:	ffffe097          	auipc	ra,0xffffe
    80002be8:	1e2080e7          	jalr	482(ra) # 80000dc6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002bec:	37048493          	addi	s1,s1,880
    80002bf0:	ff3491e3          	bne	s1,s3,80002bd2 <kill+0x20>
  }
  return -1;
    80002bf4:	557d                	li	a0,-1
    80002bf6:	a829                	j	80002c10 <kill+0x5e>
      p->killed = 1;
    80002bf8:	4785                	li	a5,1
    80002bfa:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002bfc:	4c98                	lw	a4,24(s1)
    80002bfe:	4789                	li	a5,2
    80002c00:	00f70f63          	beq	a4,a5,80002c1e <kill+0x6c>
      release(&p->lock);
    80002c04:	8526                	mv	a0,s1
    80002c06:	ffffe097          	auipc	ra,0xffffe
    80002c0a:	1c0080e7          	jalr	448(ra) # 80000dc6 <release>
      return 0;
    80002c0e:	4501                	li	a0,0
}
    80002c10:	70a2                	ld	ra,40(sp)
    80002c12:	7402                	ld	s0,32(sp)
    80002c14:	64e2                	ld	s1,24(sp)
    80002c16:	6942                	ld	s2,16(sp)
    80002c18:	69a2                	ld	s3,8(sp)
    80002c1a:	6145                	addi	sp,sp,48
    80002c1c:	8082                	ret
        p->state = RUNNABLE;
    80002c1e:	478d                	li	a5,3
    80002c20:	cc9c                	sw	a5,24(s1)
    80002c22:	b7cd                	j	80002c04 <kill+0x52>

0000000080002c24 <setkilled>:

void
setkilled(struct proc *p)
{
    80002c24:	1101                	addi	sp,sp,-32
    80002c26:	ec06                	sd	ra,24(sp)
    80002c28:	e822                	sd	s0,16(sp)
    80002c2a:	e426                	sd	s1,8(sp)
    80002c2c:	1000                	addi	s0,sp,32
    80002c2e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002c30:	ffffe097          	auipc	ra,0xffffe
    80002c34:	0e6080e7          	jalr	230(ra) # 80000d16 <acquire>
  p->killed = 1;
    80002c38:	4785                	li	a5,1
    80002c3a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002c3c:	8526                	mv	a0,s1
    80002c3e:	ffffe097          	auipc	ra,0xffffe
    80002c42:	188080e7          	jalr	392(ra) # 80000dc6 <release>
}
    80002c46:	60e2                	ld	ra,24(sp)
    80002c48:	6442                	ld	s0,16(sp)
    80002c4a:	64a2                	ld	s1,8(sp)
    80002c4c:	6105                	addi	sp,sp,32
    80002c4e:	8082                	ret

0000000080002c50 <killed>:

int
killed(struct proc *p)
{
    80002c50:	1101                	addi	sp,sp,-32
    80002c52:	ec06                	sd	ra,24(sp)
    80002c54:	e822                	sd	s0,16(sp)
    80002c56:	e426                	sd	s1,8(sp)
    80002c58:	e04a                	sd	s2,0(sp)
    80002c5a:	1000                	addi	s0,sp,32
    80002c5c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002c5e:	ffffe097          	auipc	ra,0xffffe
    80002c62:	0b8080e7          	jalr	184(ra) # 80000d16 <acquire>
  k = p->killed;
    80002c66:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002c6a:	8526                	mv	a0,s1
    80002c6c:	ffffe097          	auipc	ra,0xffffe
    80002c70:	15a080e7          	jalr	346(ra) # 80000dc6 <release>
  return k;
}
    80002c74:	854a                	mv	a0,s2
    80002c76:	60e2                	ld	ra,24(sp)
    80002c78:	6442                	ld	s0,16(sp)
    80002c7a:	64a2                	ld	s1,8(sp)
    80002c7c:	6902                	ld	s2,0(sp)
    80002c7e:	6105                	addi	sp,sp,32
    80002c80:	8082                	ret

0000000080002c82 <join_thread>:
uint64 join_thread(uint64 thread_id, uint64 status_addr) {
    80002c82:	715d                	addi	sp,sp,-80
    80002c84:	e486                	sd	ra,72(sp)
    80002c86:	e0a2                	sd	s0,64(sp)
    80002c88:	fc26                	sd	s1,56(sp)
    80002c8a:	f84a                	sd	s2,48(sp)
    80002c8c:	f44e                	sd	s3,40(sp)
    80002c8e:	f052                	sd	s4,32(sp)
    80002c90:	e85a                	sd	s6,16(sp)
    80002c92:	0880                	addi	s0,sp,80
    80002c94:	8a2a                	mv	s4,a0
    80002c96:	8b2e                	mv	s6,a1
  struct proc *p = myproc();
    80002c98:	fffff097          	auipc	ra,0xfffff
    80002c9c:	28a080e7          	jalr	650(ra) # 80001f22 <myproc>
    80002ca0:	89aa                	mv	s3,a0
  if (p->is_thread) 
    80002ca2:	16852783          	lw	a5,360(a0)
    80002ca6:	c399                	beqz	a5,80002cac <join_thread+0x2a>
    p = p->parent;
    80002ca8:	03853983          	ld	s3,56(a0)
  acquire(&wait_lock);
    80002cac:	00052517          	auipc	a0,0x52
    80002cb0:	17c50513          	addi	a0,a0,380 # 80054e28 <wait_lock>
    80002cb4:	ffffe097          	auipc	ra,0xffffe
    80002cb8:	062080e7          	jalr	98(ra) # 80000d16 <acquire>
  for (thread_idx = 0; thread_idx < MAX_THREADS; thread_idx++) {
    80002cbc:	17098793          	addi	a5,s3,368
    80002cc0:	4901                	li	s2,0
    80002cc2:	04000693          	li	a3,64
    80002cc6:	a029                	j	80002cd0 <join_thread+0x4e>
    80002cc8:	2905                	addiw	s2,s2,1
    80002cca:	07a1                	addi	a5,a5,8
    80002ccc:	0ed90263          	beq	s2,a3,80002db0 <join_thread+0x12e>
    if (p->infant_threads[thread_idx] && thread_id == p->infant_threads[thread_idx]->pid) {
    80002cd0:	6384                	ld	s1,0(a5)
    80002cd2:	d8fd                	beqz	s1,80002cc8 <join_thread+0x46>
    80002cd4:	5898                	lw	a4,48(s1)
    80002cd6:	ff4719e3          	bne	a4,s4,80002cc8 <join_thread+0x46>
    80002cda:	ec56                	sd	s5,24(sp)
    80002cdc:	e45e                	sd	s7,8(sp)
    if (child->state == ZOMBIE) {
    80002cde:	4a95                	li	s5,5
    sleep(p, &wait_lock);
    80002ce0:	00052b97          	auipc	s7,0x52
    80002ce4:	148b8b93          	addi	s7,s7,328 # 80054e28 <wait_lock>
    acquire(&child->lock);
    80002ce8:	8526                	mv	a0,s1
    80002cea:	ffffe097          	auipc	ra,0xffffe
    80002cee:	02c080e7          	jalr	44(ra) # 80000d16 <acquire>
    if (child->state == ZOMBIE) {
    80002cf2:	4c9c                	lw	a5,24(s1)
    80002cf4:	03578463          	beq	a5,s5,80002d1c <join_thread+0x9a>
    release(&child->lock);
    80002cf8:	8526                	mv	a0,s1
    80002cfa:	ffffe097          	auipc	ra,0xffffe
    80002cfe:	0cc080e7          	jalr	204(ra) # 80000dc6 <release>
    if (killed(p)) {
    80002d02:	854e                	mv	a0,s3
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	f4c080e7          	jalr	-180(ra) # 80002c50 <killed>
    80002d0c:	ed35                	bnez	a0,80002d88 <join_thread+0x106>
    sleep(p, &wait_lock);
    80002d0e:	85de                	mv	a1,s7
    80002d10:	854e                	mv	a0,s3
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	b18080e7          	jalr	-1256(ra) # 8000282a <sleep>
    acquire(&child->lock);
    80002d1a:	b7f9                	j	80002ce8 <join_thread+0x66>
      if (status_addr != 0 && copyout(p->pagetable, status_addr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
    80002d1c:	000b0e63          	beqz	s6,80002d38 <join_thread+0xb6>
    80002d20:	4691                	li	a3,4
    80002d22:	02c48613          	addi	a2,s1,44
    80002d26:	85da                	mv	a1,s6
    80002d28:	0509b503          	ld	a0,80(s3)
    80002d2c:	fffff097          	auipc	ra,0xfffff
    80002d30:	e9e080e7          	jalr	-354(ra) # 80001bca <copyout>
    80002d34:	02054963          	bltz	a0,80002d66 <join_thread+0xe4>
      release(&child->lock);
    80002d38:	8526                	mv	a0,s1
    80002d3a:	ffffe097          	auipc	ra,0xffffe
    80002d3e:	08c080e7          	jalr	140(ra) # 80000dc6 <release>
      release(&wait_lock);
    80002d42:	00052517          	auipc	a0,0x52
    80002d46:	0e650513          	addi	a0,a0,230 # 80054e28 <wait_lock>
    80002d4a:	ffffe097          	auipc	ra,0xffffe
    80002d4e:	07c080e7          	jalr	124(ra) # 80000dc6 <release>
      p->infant_threads[thread_idx] = 0;
    80002d52:	02e90913          	addi	s2,s2,46
    80002d56:	090e                	slli	s2,s2,0x3
    80002d58:	99ca                	add	s3,s3,s2
    80002d5a:	0009b023          	sd	zero,0(s3)
      return thread_id;
    80002d5e:	8552                	mv	a0,s4
    80002d60:	6ae2                	ld	s5,24(sp)
    80002d62:	6ba2                	ld	s7,8(sp)
    80002d64:	a82d                	j	80002d9e <join_thread+0x11c>
        release(&child->lock);
    80002d66:	8526                	mv	a0,s1
    80002d68:	ffffe097          	auipc	ra,0xffffe
    80002d6c:	05e080e7          	jalr	94(ra) # 80000dc6 <release>
        release(&wait_lock);
    80002d70:	00052517          	auipc	a0,0x52
    80002d74:	0b850513          	addi	a0,a0,184 # 80054e28 <wait_lock>
    80002d78:	ffffe097          	auipc	ra,0xffffe
    80002d7c:	04e080e7          	jalr	78(ra) # 80000dc6 <release>
        return -1;
    80002d80:	557d                	li	a0,-1
    80002d82:	6ae2                	ld	s5,24(sp)
    80002d84:	6ba2                	ld	s7,8(sp)
    80002d86:	a821                	j	80002d9e <join_thread+0x11c>
      release(&wait_lock);
    80002d88:	00052517          	auipc	a0,0x52
    80002d8c:	0a050513          	addi	a0,a0,160 # 80054e28 <wait_lock>
    80002d90:	ffffe097          	auipc	ra,0xffffe
    80002d94:	036080e7          	jalr	54(ra) # 80000dc6 <release>
      return -1;
    80002d98:	557d                	li	a0,-1
    80002d9a:	6ae2                	ld	s5,24(sp)
    80002d9c:	6ba2                	ld	s7,8(sp)
}
    80002d9e:	60a6                	ld	ra,72(sp)
    80002da0:	6406                	ld	s0,64(sp)
    80002da2:	74e2                	ld	s1,56(sp)
    80002da4:	7942                	ld	s2,48(sp)
    80002da6:	79a2                	ld	s3,40(sp)
    80002da8:	7a02                	ld	s4,32(sp)
    80002daa:	6b42                	ld	s6,16(sp)
    80002dac:	6161                	addi	sp,sp,80
    80002dae:	8082                	ret
    release(&wait_lock);
    80002db0:	00052517          	auipc	a0,0x52
    80002db4:	07850513          	addi	a0,a0,120 # 80054e28 <wait_lock>
    80002db8:	ffffe097          	auipc	ra,0xffffe
    80002dbc:	00e080e7          	jalr	14(ra) # 80000dc6 <release>
    return -1;
    80002dc0:	557d                	li	a0,-1
    80002dc2:	bff1                	j	80002d9e <join_thread+0x11c>

0000000080002dc4 <wait>:
{
    80002dc4:	715d                	addi	sp,sp,-80
    80002dc6:	e486                	sd	ra,72(sp)
    80002dc8:	e0a2                	sd	s0,64(sp)
    80002dca:	fc26                	sd	s1,56(sp)
    80002dcc:	f84a                	sd	s2,48(sp)
    80002dce:	f44e                	sd	s3,40(sp)
    80002dd0:	f052                	sd	s4,32(sp)
    80002dd2:	ec56                	sd	s5,24(sp)
    80002dd4:	e85a                	sd	s6,16(sp)
    80002dd6:	e45e                	sd	s7,8(sp)
    80002dd8:	0880                	addi	s0,sp,80
    80002dda:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002ddc:	fffff097          	auipc	ra,0xfffff
    80002de0:	146080e7          	jalr	326(ra) # 80001f22 <myproc>
    80002de4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002de6:	00052517          	auipc	a0,0x52
    80002dea:	04250513          	addi	a0,a0,66 # 80054e28 <wait_lock>
    80002dee:	ffffe097          	auipc	ra,0xffffe
    80002df2:	f28080e7          	jalr	-216(ra) # 80000d16 <acquire>
        if(pp->state == ZOMBIE){
    80002df6:	4a15                	li	s4,5
        havekids = 1;
    80002df8:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002dfa:	00060997          	auipc	s3,0x60
    80002dfe:	04698993          	addi	s3,s3,70 # 80062e40 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002e02:	00052b97          	auipc	s7,0x52
    80002e06:	026b8b93          	addi	s7,s7,38 # 80054e28 <wait_lock>
    80002e0a:	a0c9                	j	80002ecc <wait+0x108>
          pid = pp->pid;
    80002e0c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002e10:	000b0e63          	beqz	s6,80002e2c <wait+0x68>
    80002e14:	4691                	li	a3,4
    80002e16:	02c48613          	addi	a2,s1,44
    80002e1a:	85da                	mv	a1,s6
    80002e1c:	05093503          	ld	a0,80(s2)
    80002e20:	fffff097          	auipc	ra,0xfffff
    80002e24:	daa080e7          	jalr	-598(ra) # 80001bca <copyout>
    80002e28:	04054063          	bltz	a0,80002e68 <wait+0xa4>
          freeproc(pp);
    80002e2c:	8526                	mv	a0,s1
    80002e2e:	fffff097          	auipc	ra,0xfffff
    80002e32:	2a6080e7          	jalr	678(ra) # 800020d4 <freeproc>
          release(&pp->lock);
    80002e36:	8526                	mv	a0,s1
    80002e38:	ffffe097          	auipc	ra,0xffffe
    80002e3c:	f8e080e7          	jalr	-114(ra) # 80000dc6 <release>
          release(&wait_lock);
    80002e40:	00052517          	auipc	a0,0x52
    80002e44:	fe850513          	addi	a0,a0,-24 # 80054e28 <wait_lock>
    80002e48:	ffffe097          	auipc	ra,0xffffe
    80002e4c:	f7e080e7          	jalr	-130(ra) # 80000dc6 <release>
}
    80002e50:	854e                	mv	a0,s3
    80002e52:	60a6                	ld	ra,72(sp)
    80002e54:	6406                	ld	s0,64(sp)
    80002e56:	74e2                	ld	s1,56(sp)
    80002e58:	7942                	ld	s2,48(sp)
    80002e5a:	79a2                	ld	s3,40(sp)
    80002e5c:	7a02                	ld	s4,32(sp)
    80002e5e:	6ae2                	ld	s5,24(sp)
    80002e60:	6b42                	ld	s6,16(sp)
    80002e62:	6ba2                	ld	s7,8(sp)
    80002e64:	6161                	addi	sp,sp,80
    80002e66:	8082                	ret
            release(&pp->lock);
    80002e68:	8526                	mv	a0,s1
    80002e6a:	ffffe097          	auipc	ra,0xffffe
    80002e6e:	f5c080e7          	jalr	-164(ra) # 80000dc6 <release>
            release(&wait_lock);
    80002e72:	00052517          	auipc	a0,0x52
    80002e76:	fb650513          	addi	a0,a0,-74 # 80054e28 <wait_lock>
    80002e7a:	ffffe097          	auipc	ra,0xffffe
    80002e7e:	f4c080e7          	jalr	-180(ra) # 80000dc6 <release>
            return -1;
    80002e82:	59fd                	li	s3,-1
    80002e84:	b7f1                	j	80002e50 <wait+0x8c>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002e86:	37048493          	addi	s1,s1,880
    80002e8a:	03348463          	beq	s1,s3,80002eb2 <wait+0xee>
      if(pp->parent == p){
    80002e8e:	7c9c                	ld	a5,56(s1)
    80002e90:	ff279be3          	bne	a5,s2,80002e86 <wait+0xc2>
        acquire(&pp->lock);
    80002e94:	8526                	mv	a0,s1
    80002e96:	ffffe097          	auipc	ra,0xffffe
    80002e9a:	e80080e7          	jalr	-384(ra) # 80000d16 <acquire>
        if(pp->state == ZOMBIE){
    80002e9e:	4c9c                	lw	a5,24(s1)
    80002ea0:	f74786e3          	beq	a5,s4,80002e0c <wait+0x48>
        release(&pp->lock);
    80002ea4:	8526                	mv	a0,s1
    80002ea6:	ffffe097          	auipc	ra,0xffffe
    80002eaa:	f20080e7          	jalr	-224(ra) # 80000dc6 <release>
        havekids = 1;
    80002eae:	8756                	mv	a4,s5
    80002eb0:	bfd9                	j	80002e86 <wait+0xc2>
    if(!havekids || killed(p)){
    80002eb2:	c31d                	beqz	a4,80002ed8 <wait+0x114>
    80002eb4:	854a                	mv	a0,s2
    80002eb6:	00000097          	auipc	ra,0x0
    80002eba:	d9a080e7          	jalr	-614(ra) # 80002c50 <killed>
    80002ebe:	ed09                	bnez	a0,80002ed8 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002ec0:	85de                	mv	a1,s7
    80002ec2:	854a                	mv	a0,s2
    80002ec4:	00000097          	auipc	ra,0x0
    80002ec8:	966080e7          	jalr	-1690(ra) # 8000282a <sleep>
    havekids = 0;
    80002ecc:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002ece:	00052497          	auipc	s1,0x52
    80002ed2:	37248493          	addi	s1,s1,882 # 80055240 <proc>
    80002ed6:	bf65                	j	80002e8e <wait+0xca>
      release(&wait_lock);
    80002ed8:	00052517          	auipc	a0,0x52
    80002edc:	f5050513          	addi	a0,a0,-176 # 80054e28 <wait_lock>
    80002ee0:	ffffe097          	auipc	ra,0xffffe
    80002ee4:	ee6080e7          	jalr	-282(ra) # 80000dc6 <release>
      return -1;
    80002ee8:	59fd                	li	s3,-1
    80002eea:	b79d                	j	80002e50 <wait+0x8c>

0000000080002eec <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002eec:	7179                	addi	sp,sp,-48
    80002eee:	f406                	sd	ra,40(sp)
    80002ef0:	f022                	sd	s0,32(sp)
    80002ef2:	ec26                	sd	s1,24(sp)
    80002ef4:	e84a                	sd	s2,16(sp)
    80002ef6:	e44e                	sd	s3,8(sp)
    80002ef8:	e052                	sd	s4,0(sp)
    80002efa:	1800                	addi	s0,sp,48
    80002efc:	84aa                	mv	s1,a0
    80002efe:	892e                	mv	s2,a1
    80002f00:	89b2                	mv	s3,a2
    80002f02:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002f04:	fffff097          	auipc	ra,0xfffff
    80002f08:	01e080e7          	jalr	30(ra) # 80001f22 <myproc>
  if(user_dst){
    80002f0c:	c08d                	beqz	s1,80002f2e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002f0e:	86d2                	mv	a3,s4
    80002f10:	864e                	mv	a2,s3
    80002f12:	85ca                	mv	a1,s2
    80002f14:	6928                	ld	a0,80(a0)
    80002f16:	fffff097          	auipc	ra,0xfffff
    80002f1a:	cb4080e7          	jalr	-844(ra) # 80001bca <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002f1e:	70a2                	ld	ra,40(sp)
    80002f20:	7402                	ld	s0,32(sp)
    80002f22:	64e2                	ld	s1,24(sp)
    80002f24:	6942                	ld	s2,16(sp)
    80002f26:	69a2                	ld	s3,8(sp)
    80002f28:	6a02                	ld	s4,0(sp)
    80002f2a:	6145                	addi	sp,sp,48
    80002f2c:	8082                	ret
    memmove((char *)dst, src, len);
    80002f2e:	000a061b          	sext.w	a2,s4
    80002f32:	85ce                	mv	a1,s3
    80002f34:	854a                	mv	a0,s2
    80002f36:	ffffe097          	auipc	ra,0xffffe
    80002f3a:	f3c080e7          	jalr	-196(ra) # 80000e72 <memmove>
    return 0;
    80002f3e:	8526                	mv	a0,s1
    80002f40:	bff9                	j	80002f1e <either_copyout+0x32>

0000000080002f42 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002f42:	7179                	addi	sp,sp,-48
    80002f44:	f406                	sd	ra,40(sp)
    80002f46:	f022                	sd	s0,32(sp)
    80002f48:	ec26                	sd	s1,24(sp)
    80002f4a:	e84a                	sd	s2,16(sp)
    80002f4c:	e44e                	sd	s3,8(sp)
    80002f4e:	e052                	sd	s4,0(sp)
    80002f50:	1800                	addi	s0,sp,48
    80002f52:	892a                	mv	s2,a0
    80002f54:	84ae                	mv	s1,a1
    80002f56:	89b2                	mv	s3,a2
    80002f58:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002f5a:	fffff097          	auipc	ra,0xfffff
    80002f5e:	fc8080e7          	jalr	-56(ra) # 80001f22 <myproc>
  if(user_src){
    80002f62:	c08d                	beqz	s1,80002f84 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002f64:	86d2                	mv	a3,s4
    80002f66:	864e                	mv	a2,s3
    80002f68:	85ca                	mv	a1,s2
    80002f6a:	6928                	ld	a0,80(a0)
    80002f6c:	fffff097          	auipc	ra,0xfffff
    80002f70:	cea080e7          	jalr	-790(ra) # 80001c56 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002f74:	70a2                	ld	ra,40(sp)
    80002f76:	7402                	ld	s0,32(sp)
    80002f78:	64e2                	ld	s1,24(sp)
    80002f7a:	6942                	ld	s2,16(sp)
    80002f7c:	69a2                	ld	s3,8(sp)
    80002f7e:	6a02                	ld	s4,0(sp)
    80002f80:	6145                	addi	sp,sp,48
    80002f82:	8082                	ret
    memmove(dst, (char*)src, len);
    80002f84:	000a061b          	sext.w	a2,s4
    80002f88:	85ce                	mv	a1,s3
    80002f8a:	854a                	mv	a0,s2
    80002f8c:	ffffe097          	auipc	ra,0xffffe
    80002f90:	ee6080e7          	jalr	-282(ra) # 80000e72 <memmove>
    return 0;
    80002f94:	8526                	mv	a0,s1
    80002f96:	bff9                	j	80002f74 <either_copyin+0x32>

0000000080002f98 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002f98:	715d                	addi	sp,sp,-80
    80002f9a:	e486                	sd	ra,72(sp)
    80002f9c:	e0a2                	sd	s0,64(sp)
    80002f9e:	fc26                	sd	s1,56(sp)
    80002fa0:	f84a                	sd	s2,48(sp)
    80002fa2:	f44e                	sd	s3,40(sp)
    80002fa4:	f052                	sd	s4,32(sp)
    80002fa6:	ec56                	sd	s5,24(sp)
    80002fa8:	e85a                	sd	s6,16(sp)
    80002faa:	e45e                	sd	s7,8(sp)
    80002fac:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002fae:	00006517          	auipc	a0,0x6
    80002fb2:	06250513          	addi	a0,a0,98 # 80009010 <etext+0x10>
    80002fb6:	ffffd097          	auipc	ra,0xffffd
    80002fba:	5f4080e7          	jalr	1524(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002fbe:	00052497          	auipc	s1,0x52
    80002fc2:	3da48493          	addi	s1,s1,986 # 80055398 <proc+0x158>
    80002fc6:	00060917          	auipc	s2,0x60
    80002fca:	fd290913          	addi	s2,s2,-46 # 80062f98 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002fce:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002fd0:	00006997          	auipc	s3,0x6
    80002fd4:	35898993          	addi	s3,s3,856 # 80009328 <etext+0x328>
    printf("%d %s %s", p->pid, state, p->name);
    80002fd8:	00006a97          	auipc	s5,0x6
    80002fdc:	358a8a93          	addi	s5,s5,856 # 80009330 <etext+0x330>
    printf("\n");
    80002fe0:	00006a17          	auipc	s4,0x6
    80002fe4:	030a0a13          	addi	s4,s4,48 # 80009010 <etext+0x10>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002fe8:	00007b97          	auipc	s7,0x7
    80002fec:	9d8b8b93          	addi	s7,s7,-1576 # 800099c0 <states.0>
    80002ff0:	a00d                	j	80003012 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002ff2:	ed86a583          	lw	a1,-296(a3)
    80002ff6:	8556                	mv	a0,s5
    80002ff8:	ffffd097          	auipc	ra,0xffffd
    80002ffc:	5b2080e7          	jalr	1458(ra) # 800005aa <printf>
    printf("\n");
    80003000:	8552                	mv	a0,s4
    80003002:	ffffd097          	auipc	ra,0xffffd
    80003006:	5a8080e7          	jalr	1448(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000300a:	37048493          	addi	s1,s1,880
    8000300e:	03248263          	beq	s1,s2,80003032 <procdump+0x9a>
    if(p->state == UNUSED)
    80003012:	86a6                	mv	a3,s1
    80003014:	ec04a783          	lw	a5,-320(s1)
    80003018:	dbed                	beqz	a5,8000300a <procdump+0x72>
      state = "???";
    8000301a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000301c:	fcfb6be3          	bltu	s6,a5,80002ff2 <procdump+0x5a>
    80003020:	02079713          	slli	a4,a5,0x20
    80003024:	01d75793          	srli	a5,a4,0x1d
    80003028:	97de                	add	a5,a5,s7
    8000302a:	6390                	ld	a2,0(a5)
    8000302c:	f279                	bnez	a2,80002ff2 <procdump+0x5a>
      state = "???";
    8000302e:	864e                	mv	a2,s3
    80003030:	b7c9                	j	80002ff2 <procdump+0x5a>
  }
}
    80003032:	60a6                	ld	ra,72(sp)
    80003034:	6406                	ld	s0,64(sp)
    80003036:	74e2                	ld	s1,56(sp)
    80003038:	7942                	ld	s2,48(sp)
    8000303a:	79a2                	ld	s3,40(sp)
    8000303c:	7a02                	ld	s4,32(sp)
    8000303e:	6ae2                	ld	s5,24(sp)
    80003040:	6b42                	ld	s6,16(sp)
    80003042:	6ba2                	ld	s7,8(sp)
    80003044:	6161                	addi	sp,sp,80
    80003046:	8082                	ret

0000000080003048 <spoon>:

uint64 spoon(void *arg)
{
    80003048:	1141                	addi	sp,sp,-16
    8000304a:	e406                	sd	ra,8(sp)
    8000304c:	e022                	sd	s0,0(sp)
    8000304e:	0800                	addi	s0,sp,16
    80003050:	85aa                	mv	a1,a0
  // Add your code here...
  printf("In spoon system call with argument %p\n", arg);
    80003052:	00006517          	auipc	a0,0x6
    80003056:	2ee50513          	addi	a0,a0,750 # 80009340 <etext+0x340>
    8000305a:	ffffd097          	auipc	ra,0xffffd
    8000305e:	550080e7          	jalr	1360(ra) # 800005aa <printf>
  return 0;
}
    80003062:	4501                	li	a0,0
    80003064:	60a2                	ld	ra,8(sp)
    80003066:	6402                	ld	s0,0(sp)
    80003068:	0141                	addi	sp,sp,16
    8000306a:	8082                	ret

000000008000306c <swtch>:
    8000306c:	00153023          	sd	ra,0(a0)
    80003070:	00253423          	sd	sp,8(a0)
    80003074:	e900                	sd	s0,16(a0)
    80003076:	ed04                	sd	s1,24(a0)
    80003078:	03253023          	sd	s2,32(a0)
    8000307c:	03353423          	sd	s3,40(a0)
    80003080:	03453823          	sd	s4,48(a0)
    80003084:	03553c23          	sd	s5,56(a0)
    80003088:	05653023          	sd	s6,64(a0)
    8000308c:	05753423          	sd	s7,72(a0)
    80003090:	05853823          	sd	s8,80(a0)
    80003094:	05953c23          	sd	s9,88(a0)
    80003098:	07a53023          	sd	s10,96(a0)
    8000309c:	07b53423          	sd	s11,104(a0)
    800030a0:	0005b083          	ld	ra,0(a1)
    800030a4:	0085b103          	ld	sp,8(a1)
    800030a8:	6980                	ld	s0,16(a1)
    800030aa:	6d84                	ld	s1,24(a1)
    800030ac:	0205b903          	ld	s2,32(a1)
    800030b0:	0285b983          	ld	s3,40(a1)
    800030b4:	0305ba03          	ld	s4,48(a1)
    800030b8:	0385ba83          	ld	s5,56(a1)
    800030bc:	0405bb03          	ld	s6,64(a1)
    800030c0:	0485bb83          	ld	s7,72(a1)
    800030c4:	0505bc03          	ld	s8,80(a1)
    800030c8:	0585bc83          	ld	s9,88(a1)
    800030cc:	0605bd03          	ld	s10,96(a1)
    800030d0:	0685bd83          	ld	s11,104(a1)
    800030d4:	8082                	ret

00000000800030d6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800030d6:	1141                	addi	sp,sp,-16
    800030d8:	e406                	sd	ra,8(sp)
    800030da:	e022                	sd	s0,0(sp)
    800030dc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800030de:	00006597          	auipc	a1,0x6
    800030e2:	2ba58593          	addi	a1,a1,698 # 80009398 <etext+0x398>
    800030e6:	00060517          	auipc	a0,0x60
    800030ea:	d5a50513          	addi	a0,a0,-678 # 80062e40 <tickslock>
    800030ee:	ffffe097          	auipc	ra,0xffffe
    800030f2:	b94080e7          	jalr	-1132(ra) # 80000c82 <initlock>
}
    800030f6:	60a2                	ld	ra,8(sp)
    800030f8:	6402                	ld	s0,0(sp)
    800030fa:	0141                	addi	sp,sp,16
    800030fc:	8082                	ret

00000000800030fe <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800030fe:	1141                	addi	sp,sp,-16
    80003100:	e406                	sd	ra,8(sp)
    80003102:	e022                	sd	s0,0(sp)
    80003104:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003106:	00004797          	auipc	a5,0x4
    8000310a:	85a78793          	addi	a5,a5,-1958 # 80006960 <kernelvec>
    8000310e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80003112:	60a2                	ld	ra,8(sp)
    80003114:	6402                	ld	s0,0(sp)
    80003116:	0141                	addi	sp,sp,16
    80003118:	8082                	ret

000000008000311a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000311a:	1141                	addi	sp,sp,-16
    8000311c:	e406                	sd	ra,8(sp)
    8000311e:	e022                	sd	s0,0(sp)
    80003120:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80003122:	fffff097          	auipc	ra,0xfffff
    80003126:	e00080e7          	jalr	-512(ra) # 80001f22 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000312a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000312e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003130:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003134:	00005697          	auipc	a3,0x5
    80003138:	ecc68693          	addi	a3,a3,-308 # 80008000 <_trampoline>
    8000313c:	00005717          	auipc	a4,0x5
    80003140:	ec470713          	addi	a4,a4,-316 # 80008000 <_trampoline>
    80003144:	8f15                	sub	a4,a4,a3
    80003146:	040007b7          	lui	a5,0x4000
    8000314a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000314c:	07b2                	slli	a5,a5,0xc
    8000314e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003150:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003154:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003156:	18002673          	csrr	a2,satp
    8000315a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000315c:	6d30                	ld	a2,88(a0)
    8000315e:	6138                	ld	a4,64(a0)
    80003160:	6585                	lui	a1,0x1
    80003162:	972e                	add	a4,a4,a1
    80003164:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003166:	6d38                	ld	a4,88(a0)
    80003168:	00000617          	auipc	a2,0x0
    8000316c:	14c60613          	addi	a2,a2,332 # 800032b4 <usertrap>
    80003170:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003172:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80003174:	8612                	mv	a2,tp
    80003176:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003178:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000317c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003180:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003184:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003188:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000318a:	6f18                	ld	a4,24(a4)
    8000318c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003190:	6928                	ld	a0,80(a0)
    80003192:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80003194:	00005717          	auipc	a4,0x5
    80003198:	f0870713          	addi	a4,a4,-248 # 8000809c <userret>
    8000319c:	8f15                	sub	a4,a4,a3
    8000319e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800031a0:	577d                	li	a4,-1
    800031a2:	177e                	slli	a4,a4,0x3f
    800031a4:	8d59                	or	a0,a0,a4
    800031a6:	9782                	jalr	a5
}
    800031a8:	60a2                	ld	ra,8(sp)
    800031aa:	6402                	ld	s0,0(sp)
    800031ac:	0141                	addi	sp,sp,16
    800031ae:	8082                	ret

00000000800031b0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800031b0:	1101                	addi	sp,sp,-32
    800031b2:	ec06                	sd	ra,24(sp)
    800031b4:	e822                	sd	s0,16(sp)
    800031b6:	e426                	sd	s1,8(sp)
    800031b8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800031ba:	00060497          	auipc	s1,0x60
    800031be:	c8648493          	addi	s1,s1,-890 # 80062e40 <tickslock>
    800031c2:	8526                	mv	a0,s1
    800031c4:	ffffe097          	auipc	ra,0xffffe
    800031c8:	b52080e7          	jalr	-1198(ra) # 80000d16 <acquire>
  ticks++;
    800031cc:	0000a517          	auipc	a0,0xa
    800031d0:	9d450513          	addi	a0,a0,-1580 # 8000cba0 <ticks>
    800031d4:	411c                	lw	a5,0(a0)
    800031d6:	2785                	addiw	a5,a5,1
    800031d8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800031da:	fffff097          	auipc	ra,0xfffff
    800031de:	6b4080e7          	jalr	1716(ra) # 8000288e <wakeup>
  release(&tickslock);
    800031e2:	8526                	mv	a0,s1
    800031e4:	ffffe097          	auipc	ra,0xffffe
    800031e8:	be2080e7          	jalr	-1054(ra) # 80000dc6 <release>
}
    800031ec:	60e2                	ld	ra,24(sp)
    800031ee:	6442                	ld	s0,16(sp)
    800031f0:	64a2                	ld	s1,8(sp)
    800031f2:	6105                	addi	sp,sp,32
    800031f4:	8082                	ret

00000000800031f6 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    800031f6:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800031fa:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    800031fc:	0a07db63          	bgez	a5,800032b2 <devintr+0xbc>
{
    80003200:	1101                	addi	sp,sp,-32
    80003202:	ec06                	sd	ra,24(sp)
    80003204:	e822                	sd	s0,16(sp)
    80003206:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80003208:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    8000320c:	46a5                	li	a3,9
    8000320e:	00d70c63          	beq	a4,a3,80003226 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80003212:	577d                	li	a4,-1
    80003214:	177e                	slli	a4,a4,0x3f
    80003216:	0705                	addi	a4,a4,1
    return 0;
    80003218:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000321a:	06e78b63          	beq	a5,a4,80003290 <devintr+0x9a>
  }
}
    8000321e:	60e2                	ld	ra,24(sp)
    80003220:	6442                	ld	s0,16(sp)
    80003222:	6105                	addi	sp,sp,32
    80003224:	8082                	ret
    80003226:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80003228:	00004097          	auipc	ra,0x4
    8000322c:	846080e7          	jalr	-1978(ra) # 80006a6e <plic_claim>
    80003230:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80003232:	47a9                	li	a5,10
    80003234:	00f50c63          	beq	a0,a5,8000324c <devintr+0x56>
    } else if(irq == VIRTIO0_IRQ){
    80003238:	4785                	li	a5,1
    8000323a:	02f50563          	beq	a0,a5,80003264 <devintr+0x6e>
    } else if (irq == VIRTIO1_IRQ) {
    8000323e:	4789                	li	a5,2
    80003240:	02f50763          	beq	a0,a5,8000326e <devintr+0x78>
    return 1;
    80003244:	4505                	li	a0,1
    } else if(irq){
    80003246:	e89d                	bnez	s1,8000327c <devintr+0x86>
    80003248:	64a2                	ld	s1,8(sp)
    8000324a:	bfd1                	j	8000321e <devintr+0x28>
      uartintr();
    8000324c:	ffffd097          	auipc	ra,0xffffd
    80003250:	7b0080e7          	jalr	1968(ra) # 800009fc <uartintr>
      plic_complete(irq);
    80003254:	8526                	mv	a0,s1
    80003256:	00004097          	auipc	ra,0x4
    8000325a:	83c080e7          	jalr	-1988(ra) # 80006a92 <plic_complete>
    return 1;
    8000325e:	4505                	li	a0,1
    80003260:	64a2                	ld	s1,8(sp)
    80003262:	bf75                	j	8000321e <devintr+0x28>
      virtio_disk_intr();
    80003264:	00004097          	auipc	ra,0x4
    80003268:	cfe080e7          	jalr	-770(ra) # 80006f62 <virtio_disk_intr>
    if(irq)
    8000326c:	b7e5                	j	80003254 <devintr+0x5e>
      receive_packet(temp, 0);
    8000326e:	4581                	li	a1,0
    80003270:	4501                	li	a0,0
    80003272:	00004097          	auipc	ra,0x4
    80003276:	4e0080e7          	jalr	1248(ra) # 80007752 <receive_packet>
    8000327a:	bfe9                	j	80003254 <devintr+0x5e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000327c:	85a6                	mv	a1,s1
    8000327e:	00006517          	auipc	a0,0x6
    80003282:	12250513          	addi	a0,a0,290 # 800093a0 <etext+0x3a0>
    80003286:	ffffd097          	auipc	ra,0xffffd
    8000328a:	324080e7          	jalr	804(ra) # 800005aa <printf>
    if(irq)
    8000328e:	b7d9                	j	80003254 <devintr+0x5e>
    if(cpuid() == 0){
    80003290:	fffff097          	auipc	ra,0xfffff
    80003294:	c5e080e7          	jalr	-930(ra) # 80001eee <cpuid>
    80003298:	c901                	beqz	a0,800032a8 <devintr+0xb2>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000329a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000329e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800032a0:	14479073          	csrw	sip,a5
    return 2;
    800032a4:	4509                	li	a0,2
    800032a6:	bfa5                	j	8000321e <devintr+0x28>
      clockintr();
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	f08080e7          	jalr	-248(ra) # 800031b0 <clockintr>
    800032b0:	b7ed                	j	8000329a <devintr+0xa4>
}
    800032b2:	8082                	ret

00000000800032b4 <usertrap>:
{
    800032b4:	1101                	addi	sp,sp,-32
    800032b6:	ec06                	sd	ra,24(sp)
    800032b8:	e822                	sd	s0,16(sp)
    800032ba:	e426                	sd	s1,8(sp)
    800032bc:	e04a                	sd	s2,0(sp)
    800032be:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032c0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800032c4:	1007f793          	andi	a5,a5,256
    800032c8:	e3b1                	bnez	a5,8000330c <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800032ca:	00003797          	auipc	a5,0x3
    800032ce:	69678793          	addi	a5,a5,1686 # 80006960 <kernelvec>
    800032d2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800032d6:	fffff097          	auipc	ra,0xfffff
    800032da:	c4c080e7          	jalr	-948(ra) # 80001f22 <myproc>
    800032de:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800032e0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800032e2:	14102773          	csrr	a4,sepc
    800032e6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800032e8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800032ec:	47a1                	li	a5,8
    800032ee:	02f70763          	beq	a4,a5,8000331c <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    800032f2:	00000097          	auipc	ra,0x0
    800032f6:	f04080e7          	jalr	-252(ra) # 800031f6 <devintr>
    800032fa:	892a                	mv	s2,a0
    800032fc:	c151                	beqz	a0,80003380 <usertrap+0xcc>
  if(killed(p))
    800032fe:	8526                	mv	a0,s1
    80003300:	00000097          	auipc	ra,0x0
    80003304:	950080e7          	jalr	-1712(ra) # 80002c50 <killed>
    80003308:	c929                	beqz	a0,8000335a <usertrap+0xa6>
    8000330a:	a099                	j	80003350 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    8000330c:	00006517          	auipc	a0,0x6
    80003310:	0b450513          	addi	a0,a0,180 # 800093c0 <etext+0x3c0>
    80003314:	ffffd097          	auipc	ra,0xffffd
    80003318:	24c080e7          	jalr	588(ra) # 80000560 <panic>
    if(killed(p))
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	934080e7          	jalr	-1740(ra) # 80002c50 <killed>
    80003324:	e921                	bnez	a0,80003374 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80003326:	6cb8                	ld	a4,88(s1)
    80003328:	6f1c                	ld	a5,24(a4)
    8000332a:	0791                	addi	a5,a5,4
    8000332c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000332e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003332:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003336:	10079073          	csrw	sstatus,a5
    syscall();
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	2cc080e7          	jalr	716(ra) # 80003606 <syscall>
  if(killed(p))
    80003342:	8526                	mv	a0,s1
    80003344:	00000097          	auipc	ra,0x0
    80003348:	90c080e7          	jalr	-1780(ra) # 80002c50 <killed>
    8000334c:	c911                	beqz	a0,80003360 <usertrap+0xac>
    8000334e:	4901                	li	s2,0
    exit(-1);
    80003350:	557d                	li	a0,-1
    80003352:	fffff097          	auipc	ra,0xfffff
    80003356:	6e2080e7          	jalr	1762(ra) # 80002a34 <exit>
  if(which_dev == 2)
    8000335a:	4789                	li	a5,2
    8000335c:	04f90f63          	beq	s2,a5,800033ba <usertrap+0x106>
  usertrapret();
    80003360:	00000097          	auipc	ra,0x0
    80003364:	dba080e7          	jalr	-582(ra) # 8000311a <usertrapret>
}
    80003368:	60e2                	ld	ra,24(sp)
    8000336a:	6442                	ld	s0,16(sp)
    8000336c:	64a2                	ld	s1,8(sp)
    8000336e:	6902                	ld	s2,0(sp)
    80003370:	6105                	addi	sp,sp,32
    80003372:	8082                	ret
      exit(-1);
    80003374:	557d                	li	a0,-1
    80003376:	fffff097          	auipc	ra,0xfffff
    8000337a:	6be080e7          	jalr	1726(ra) # 80002a34 <exit>
    8000337e:	b765                	j	80003326 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003380:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003384:	5890                	lw	a2,48(s1)
    80003386:	00006517          	auipc	a0,0x6
    8000338a:	05a50513          	addi	a0,a0,90 # 800093e0 <etext+0x3e0>
    8000338e:	ffffd097          	auipc	ra,0xffffd
    80003392:	21c080e7          	jalr	540(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003396:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000339a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000339e:	00006517          	auipc	a0,0x6
    800033a2:	07250513          	addi	a0,a0,114 # 80009410 <etext+0x410>
    800033a6:	ffffd097          	auipc	ra,0xffffd
    800033aa:	204080e7          	jalr	516(ra) # 800005aa <printf>
    setkilled(p);
    800033ae:	8526                	mv	a0,s1
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	874080e7          	jalr	-1932(ra) # 80002c24 <setkilled>
    800033b8:	b769                	j	80003342 <usertrap+0x8e>
    yield();
    800033ba:	fffff097          	auipc	ra,0xfffff
    800033be:	434080e7          	jalr	1076(ra) # 800027ee <yield>
    800033c2:	bf79                	j	80003360 <usertrap+0xac>

00000000800033c4 <kerneltrap>:
{
    800033c4:	7179                	addi	sp,sp,-48
    800033c6:	f406                	sd	ra,40(sp)
    800033c8:	f022                	sd	s0,32(sp)
    800033ca:	ec26                	sd	s1,24(sp)
    800033cc:	e84a                	sd	s2,16(sp)
    800033ce:	e44e                	sd	s3,8(sp)
    800033d0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800033d2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800033d6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800033da:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800033de:	1004f793          	andi	a5,s1,256
    800033e2:	cb85                	beqz	a5,80003412 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800033e4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800033e8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800033ea:	ef85                	bnez	a5,80003422 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	e0a080e7          	jalr	-502(ra) # 800031f6 <devintr>
    800033f4:	cd1d                	beqz	a0,80003432 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800033f6:	4789                	li	a5,2
    800033f8:	06f50a63          	beq	a0,a5,8000346c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800033fc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003400:	10049073          	csrw	sstatus,s1
}
    80003404:	70a2                	ld	ra,40(sp)
    80003406:	7402                	ld	s0,32(sp)
    80003408:	64e2                	ld	s1,24(sp)
    8000340a:	6942                	ld	s2,16(sp)
    8000340c:	69a2                	ld	s3,8(sp)
    8000340e:	6145                	addi	sp,sp,48
    80003410:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003412:	00006517          	auipc	a0,0x6
    80003416:	01e50513          	addi	a0,a0,30 # 80009430 <etext+0x430>
    8000341a:	ffffd097          	auipc	ra,0xffffd
    8000341e:	146080e7          	jalr	326(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    80003422:	00006517          	auipc	a0,0x6
    80003426:	03650513          	addi	a0,a0,54 # 80009458 <etext+0x458>
    8000342a:	ffffd097          	auipc	ra,0xffffd
    8000342e:	136080e7          	jalr	310(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    80003432:	85ce                	mv	a1,s3
    80003434:	00006517          	auipc	a0,0x6
    80003438:	04450513          	addi	a0,a0,68 # 80009478 <etext+0x478>
    8000343c:	ffffd097          	auipc	ra,0xffffd
    80003440:	16e080e7          	jalr	366(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003444:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003448:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000344c:	00006517          	auipc	a0,0x6
    80003450:	03c50513          	addi	a0,a0,60 # 80009488 <etext+0x488>
    80003454:	ffffd097          	auipc	ra,0xffffd
    80003458:	156080e7          	jalr	342(ra) # 800005aa <printf>
    panic("kerneltrap");
    8000345c:	00006517          	auipc	a0,0x6
    80003460:	04450513          	addi	a0,a0,68 # 800094a0 <etext+0x4a0>
    80003464:	ffffd097          	auipc	ra,0xffffd
    80003468:	0fc080e7          	jalr	252(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000346c:	fffff097          	auipc	ra,0xfffff
    80003470:	ab6080e7          	jalr	-1354(ra) # 80001f22 <myproc>
    80003474:	d541                	beqz	a0,800033fc <kerneltrap+0x38>
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	aac080e7          	jalr	-1364(ra) # 80001f22 <myproc>
    8000347e:	4d18                	lw	a4,24(a0)
    80003480:	4791                	li	a5,4
    80003482:	f6f71de3          	bne	a4,a5,800033fc <kerneltrap+0x38>
    yield();
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	368080e7          	jalr	872(ra) # 800027ee <yield>
    8000348e:	b7bd                	j	800033fc <kerneltrap+0x38>

0000000080003490 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003490:	1101                	addi	sp,sp,-32
    80003492:	ec06                	sd	ra,24(sp)
    80003494:	e822                	sd	s0,16(sp)
    80003496:	e426                	sd	s1,8(sp)
    80003498:	1000                	addi	s0,sp,32
    8000349a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000349c:	fffff097          	auipc	ra,0xfffff
    800034a0:	a86080e7          	jalr	-1402(ra) # 80001f22 <myproc>
  switch (n) {
    800034a4:	4795                	li	a5,5
    800034a6:	0497e163          	bltu	a5,s1,800034e8 <argraw+0x58>
    800034aa:	048a                	slli	s1,s1,0x2
    800034ac:	00006717          	auipc	a4,0x6
    800034b0:	54470713          	addi	a4,a4,1348 # 800099f0 <states.0+0x30>
    800034b4:	94ba                	add	s1,s1,a4
    800034b6:	409c                	lw	a5,0(s1)
    800034b8:	97ba                	add	a5,a5,a4
    800034ba:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800034bc:	6d3c                	ld	a5,88(a0)
    800034be:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800034c0:	60e2                	ld	ra,24(sp)
    800034c2:	6442                	ld	s0,16(sp)
    800034c4:	64a2                	ld	s1,8(sp)
    800034c6:	6105                	addi	sp,sp,32
    800034c8:	8082                	ret
    return p->trapframe->a1;
    800034ca:	6d3c                	ld	a5,88(a0)
    800034cc:	7fa8                	ld	a0,120(a5)
    800034ce:	bfcd                	j	800034c0 <argraw+0x30>
    return p->trapframe->a2;
    800034d0:	6d3c                	ld	a5,88(a0)
    800034d2:	63c8                	ld	a0,128(a5)
    800034d4:	b7f5                	j	800034c0 <argraw+0x30>
    return p->trapframe->a3;
    800034d6:	6d3c                	ld	a5,88(a0)
    800034d8:	67c8                	ld	a0,136(a5)
    800034da:	b7dd                	j	800034c0 <argraw+0x30>
    return p->trapframe->a4;
    800034dc:	6d3c                	ld	a5,88(a0)
    800034de:	6bc8                	ld	a0,144(a5)
    800034e0:	b7c5                	j	800034c0 <argraw+0x30>
    return p->trapframe->a5;
    800034e2:	6d3c                	ld	a5,88(a0)
    800034e4:	6fc8                	ld	a0,152(a5)
    800034e6:	bfe9                	j	800034c0 <argraw+0x30>
  panic("argraw");
    800034e8:	00006517          	auipc	a0,0x6
    800034ec:	fc850513          	addi	a0,a0,-56 # 800094b0 <etext+0x4b0>
    800034f0:	ffffd097          	auipc	ra,0xffffd
    800034f4:	070080e7          	jalr	112(ra) # 80000560 <panic>

00000000800034f8 <fetchaddr>:
{
    800034f8:	1101                	addi	sp,sp,-32
    800034fa:	ec06                	sd	ra,24(sp)
    800034fc:	e822                	sd	s0,16(sp)
    800034fe:	e426                	sd	s1,8(sp)
    80003500:	e04a                	sd	s2,0(sp)
    80003502:	1000                	addi	s0,sp,32
    80003504:	84aa                	mv	s1,a0
    80003506:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003508:	fffff097          	auipc	ra,0xfffff
    8000350c:	a1a080e7          	jalr	-1510(ra) # 80001f22 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003510:	653c                	ld	a5,72(a0)
    80003512:	02f4f863          	bgeu	s1,a5,80003542 <fetchaddr+0x4a>
    80003516:	00848713          	addi	a4,s1,8
    8000351a:	02e7e663          	bltu	a5,a4,80003546 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000351e:	46a1                	li	a3,8
    80003520:	8626                	mv	a2,s1
    80003522:	85ca                	mv	a1,s2
    80003524:	6928                	ld	a0,80(a0)
    80003526:	ffffe097          	auipc	ra,0xffffe
    8000352a:	730080e7          	jalr	1840(ra) # 80001c56 <copyin>
    8000352e:	00a03533          	snez	a0,a0
    80003532:	40a0053b          	negw	a0,a0
}
    80003536:	60e2                	ld	ra,24(sp)
    80003538:	6442                	ld	s0,16(sp)
    8000353a:	64a2                	ld	s1,8(sp)
    8000353c:	6902                	ld	s2,0(sp)
    8000353e:	6105                	addi	sp,sp,32
    80003540:	8082                	ret
    return -1;
    80003542:	557d                	li	a0,-1
    80003544:	bfcd                	j	80003536 <fetchaddr+0x3e>
    80003546:	557d                	li	a0,-1
    80003548:	b7fd                	j	80003536 <fetchaddr+0x3e>

000000008000354a <fetchstr>:
{
    8000354a:	7179                	addi	sp,sp,-48
    8000354c:	f406                	sd	ra,40(sp)
    8000354e:	f022                	sd	s0,32(sp)
    80003550:	ec26                	sd	s1,24(sp)
    80003552:	e84a                	sd	s2,16(sp)
    80003554:	e44e                	sd	s3,8(sp)
    80003556:	1800                	addi	s0,sp,48
    80003558:	892a                	mv	s2,a0
    8000355a:	84ae                	mv	s1,a1
    8000355c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000355e:	fffff097          	auipc	ra,0xfffff
    80003562:	9c4080e7          	jalr	-1596(ra) # 80001f22 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003566:	86ce                	mv	a3,s3
    80003568:	864a                	mv	a2,s2
    8000356a:	85a6                	mv	a1,s1
    8000356c:	6928                	ld	a0,80(a0)
    8000356e:	ffffe097          	auipc	ra,0xffffe
    80003572:	776080e7          	jalr	1910(ra) # 80001ce4 <copyinstr>
    80003576:	00054e63          	bltz	a0,80003592 <fetchstr+0x48>
  return strlen(buf);
    8000357a:	8526                	mv	a0,s1
    8000357c:	ffffe097          	auipc	ra,0xffffe
    80003580:	a1e080e7          	jalr	-1506(ra) # 80000f9a <strlen>
}
    80003584:	70a2                	ld	ra,40(sp)
    80003586:	7402                	ld	s0,32(sp)
    80003588:	64e2                	ld	s1,24(sp)
    8000358a:	6942                	ld	s2,16(sp)
    8000358c:	69a2                	ld	s3,8(sp)
    8000358e:	6145                	addi	sp,sp,48
    80003590:	8082                	ret
    return -1;
    80003592:	557d                	li	a0,-1
    80003594:	bfc5                	j	80003584 <fetchstr+0x3a>

0000000080003596 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003596:	1101                	addi	sp,sp,-32
    80003598:	ec06                	sd	ra,24(sp)
    8000359a:	e822                	sd	s0,16(sp)
    8000359c:	e426                	sd	s1,8(sp)
    8000359e:	1000                	addi	s0,sp,32
    800035a0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800035a2:	00000097          	auipc	ra,0x0
    800035a6:	eee080e7          	jalr	-274(ra) # 80003490 <argraw>
    800035aa:	c088                	sw	a0,0(s1)
}
    800035ac:	60e2                	ld	ra,24(sp)
    800035ae:	6442                	ld	s0,16(sp)
    800035b0:	64a2                	ld	s1,8(sp)
    800035b2:	6105                	addi	sp,sp,32
    800035b4:	8082                	ret

00000000800035b6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800035b6:	1101                	addi	sp,sp,-32
    800035b8:	ec06                	sd	ra,24(sp)
    800035ba:	e822                	sd	s0,16(sp)
    800035bc:	e426                	sd	s1,8(sp)
    800035be:	1000                	addi	s0,sp,32
    800035c0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800035c2:	00000097          	auipc	ra,0x0
    800035c6:	ece080e7          	jalr	-306(ra) # 80003490 <argraw>
    800035ca:	e088                	sd	a0,0(s1)
}
    800035cc:	60e2                	ld	ra,24(sp)
    800035ce:	6442                	ld	s0,16(sp)
    800035d0:	64a2                	ld	s1,8(sp)
    800035d2:	6105                	addi	sp,sp,32
    800035d4:	8082                	ret

00000000800035d6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800035d6:	1101                	addi	sp,sp,-32
    800035d8:	ec06                	sd	ra,24(sp)
    800035da:	e822                	sd	s0,16(sp)
    800035dc:	e426                	sd	s1,8(sp)
    800035de:	e04a                	sd	s2,0(sp)
    800035e0:	1000                	addi	s0,sp,32
    800035e2:	84ae                	mv	s1,a1
    800035e4:	8932                	mv	s2,a2
  *ip = argraw(n);
    800035e6:	00000097          	auipc	ra,0x0
    800035ea:	eaa080e7          	jalr	-342(ra) # 80003490 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800035ee:	864a                	mv	a2,s2
    800035f0:	85a6                	mv	a1,s1
    800035f2:	00000097          	auipc	ra,0x0
    800035f6:	f58080e7          	jalr	-168(ra) # 8000354a <fetchstr>
}
    800035fa:	60e2                	ld	ra,24(sp)
    800035fc:	6442                	ld	s0,16(sp)
    800035fe:	64a2                	ld	s1,8(sp)
    80003600:	6902                	ld	s2,0(sp)
    80003602:	6105                	addi	sp,sp,32
    80003604:	8082                	ret

0000000080003606 <syscall>:
[SYS_connect]       sys_connect,
};

void
syscall(void)
{
    80003606:	1101                	addi	sp,sp,-32
    80003608:	ec06                	sd	ra,24(sp)
    8000360a:	e822                	sd	s0,16(sp)
    8000360c:	e426                	sd	s1,8(sp)
    8000360e:	e04a                	sd	s2,0(sp)
    80003610:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	910080e7          	jalr	-1776(ra) # 80001f22 <myproc>
    8000361a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000361c:	05853903          	ld	s2,88(a0)
    80003620:	0a893783          	ld	a5,168(s2)
    80003624:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003628:	37fd                	addiw	a5,a5,-1
    8000362a:	4775                	li	a4,29
    8000362c:	00f76f63          	bltu	a4,a5,8000364a <syscall+0x44>
    80003630:	00369713          	slli	a4,a3,0x3
    80003634:	00006797          	auipc	a5,0x6
    80003638:	3d478793          	addi	a5,a5,980 # 80009a08 <syscalls>
    8000363c:	97ba                	add	a5,a5,a4
    8000363e:	639c                	ld	a5,0(a5)
    80003640:	c789                	beqz	a5,8000364a <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003642:	9782                	jalr	a5
    80003644:	06a93823          	sd	a0,112(s2)
    80003648:	a839                	j	80003666 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000364a:	15848613          	addi	a2,s1,344
    8000364e:	588c                	lw	a1,48(s1)
    80003650:	00006517          	auipc	a0,0x6
    80003654:	e6850513          	addi	a0,a0,-408 # 800094b8 <etext+0x4b8>
    80003658:	ffffd097          	auipc	ra,0xffffd
    8000365c:	f52080e7          	jalr	-174(ra) # 800005aa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003660:	6cbc                	ld	a5,88(s1)
    80003662:	577d                	li	a4,-1
    80003664:	fbb8                	sd	a4,112(a5)
  }
}
    80003666:	60e2                	ld	ra,24(sp)
    80003668:	6442                	ld	s0,16(sp)
    8000366a:	64a2                	ld	s1,8(sp)
    8000366c:	6902                	ld	s2,0(sp)
    8000366e:	6105                	addi	sp,sp,32
    80003670:	8082                	ret

0000000080003672 <sys_exit>:
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void) {
    80003672:	1101                	addi	sp,sp,-32
    80003674:	ec06                	sd	ra,24(sp)
    80003676:	e822                	sd	s0,16(sp)
    80003678:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000367a:	fec40593          	addi	a1,s0,-20
    8000367e:	4501                	li	a0,0
    80003680:	00000097          	auipc	ra,0x0
    80003684:	f16080e7          	jalr	-234(ra) # 80003596 <argint>
  exit(n);
    80003688:	fec42503          	lw	a0,-20(s0)
    8000368c:	fffff097          	auipc	ra,0xfffff
    80003690:	3a8080e7          	jalr	936(ra) # 80002a34 <exit>
  return 0; // not reached
}
    80003694:	4501                	li	a0,0
    80003696:	60e2                	ld	ra,24(sp)
    80003698:	6442                	ld	s0,16(sp)
    8000369a:	6105                	addi	sp,sp,32
    8000369c:	8082                	ret

000000008000369e <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    8000369e:	1141                	addi	sp,sp,-16
    800036a0:	e406                	sd	ra,8(sp)
    800036a2:	e022                	sd	s0,0(sp)
    800036a4:	0800                	addi	s0,sp,16
    800036a6:	fffff097          	auipc	ra,0xfffff
    800036aa:	87c080e7          	jalr	-1924(ra) # 80001f22 <myproc>
    800036ae:	5908                	lw	a0,48(a0)
    800036b0:	60a2                	ld	ra,8(sp)
    800036b2:	6402                	ld	s0,0(sp)
    800036b4:	0141                	addi	sp,sp,16
    800036b6:	8082                	ret

00000000800036b8 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    800036b8:	1141                	addi	sp,sp,-16
    800036ba:	e406                	sd	ra,8(sp)
    800036bc:	e022                	sd	s0,0(sp)
    800036be:	0800                	addi	s0,sp,16
    800036c0:	fffff097          	auipc	ra,0xfffff
    800036c4:	c64080e7          	jalr	-924(ra) # 80002324 <fork>
    800036c8:	60a2                	ld	ra,8(sp)
    800036ca:	6402                	ld	s0,0(sp)
    800036cc:	0141                	addi	sp,sp,16
    800036ce:	8082                	ret

00000000800036d0 <sys_wait>:

uint64 sys_wait(void) {
    800036d0:	1101                	addi	sp,sp,-32
    800036d2:	ec06                	sd	ra,24(sp)
    800036d4:	e822                	sd	s0,16(sp)
    800036d6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800036d8:	fe840593          	addi	a1,s0,-24
    800036dc:	4501                	li	a0,0
    800036de:	00000097          	auipc	ra,0x0
    800036e2:	ed8080e7          	jalr	-296(ra) # 800035b6 <argaddr>
  return wait(p);
    800036e6:	fe843503          	ld	a0,-24(s0)
    800036ea:	fffff097          	auipc	ra,0xfffff
    800036ee:	6da080e7          	jalr	1754(ra) # 80002dc4 <wait>
}
    800036f2:	60e2                	ld	ra,24(sp)
    800036f4:	6442                	ld	s0,16(sp)
    800036f6:	6105                	addi	sp,sp,32
    800036f8:	8082                	ret

00000000800036fa <sys_sbrk>:

uint64 sys_sbrk(void) {
    800036fa:	7179                	addi	sp,sp,-48
    800036fc:	f406                	sd	ra,40(sp)
    800036fe:	f022                	sd	s0,32(sp)
    80003700:	ec26                	sd	s1,24(sp)
    80003702:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80003704:	fdc40593          	addi	a1,s0,-36
    80003708:	4501                	li	a0,0
    8000370a:	00000097          	auipc	ra,0x0
    8000370e:	e8c080e7          	jalr	-372(ra) # 80003596 <argint>
  addr = myproc()->sz;
    80003712:	fffff097          	auipc	ra,0xfffff
    80003716:	810080e7          	jalr	-2032(ra) # 80001f22 <myproc>
    8000371a:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    8000371c:	fdc42503          	lw	a0,-36(s0)
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	b6e080e7          	jalr	-1170(ra) # 8000228e <growproc>
    80003728:	00054863          	bltz	a0,80003738 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000372c:	8526                	mv	a0,s1
    8000372e:	70a2                	ld	ra,40(sp)
    80003730:	7402                	ld	s0,32(sp)
    80003732:	64e2                	ld	s1,24(sp)
    80003734:	6145                	addi	sp,sp,48
    80003736:	8082                	ret
    return -1;
    80003738:	54fd                	li	s1,-1
    8000373a:	bfcd                	j	8000372c <sys_sbrk+0x32>

000000008000373c <sys_sleep>:

uint64 sys_sleep(void) {
    8000373c:	7139                	addi	sp,sp,-64
    8000373e:	fc06                	sd	ra,56(sp)
    80003740:	f822                	sd	s0,48(sp)
    80003742:	f04a                	sd	s2,32(sp)
    80003744:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003746:	fcc40593          	addi	a1,s0,-52
    8000374a:	4501                	li	a0,0
    8000374c:	00000097          	auipc	ra,0x0
    80003750:	e4a080e7          	jalr	-438(ra) # 80003596 <argint>
  acquire(&tickslock);
    80003754:	0005f517          	auipc	a0,0x5f
    80003758:	6ec50513          	addi	a0,a0,1772 # 80062e40 <tickslock>
    8000375c:	ffffd097          	auipc	ra,0xffffd
    80003760:	5ba080e7          	jalr	1466(ra) # 80000d16 <acquire>
  ticks0 = ticks;
    80003764:	00009917          	auipc	s2,0x9
    80003768:	43c92903          	lw	s2,1084(s2) # 8000cba0 <ticks>
  while (ticks - ticks0 < n) {
    8000376c:	fcc42783          	lw	a5,-52(s0)
    80003770:	c3b9                	beqz	a5,800037b6 <sys_sleep+0x7a>
    80003772:	f426                	sd	s1,40(sp)
    80003774:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003776:	0005f997          	auipc	s3,0x5f
    8000377a:	6ca98993          	addi	s3,s3,1738 # 80062e40 <tickslock>
    8000377e:	00009497          	auipc	s1,0x9
    80003782:	42248493          	addi	s1,s1,1058 # 8000cba0 <ticks>
    if (killed(myproc())) {
    80003786:	ffffe097          	auipc	ra,0xffffe
    8000378a:	79c080e7          	jalr	1948(ra) # 80001f22 <myproc>
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	4c2080e7          	jalr	1218(ra) # 80002c50 <killed>
    80003796:	ed15                	bnez	a0,800037d2 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003798:	85ce                	mv	a1,s3
    8000379a:	8526                	mv	a0,s1
    8000379c:	fffff097          	auipc	ra,0xfffff
    800037a0:	08e080e7          	jalr	142(ra) # 8000282a <sleep>
  while (ticks - ticks0 < n) {
    800037a4:	409c                	lw	a5,0(s1)
    800037a6:	412787bb          	subw	a5,a5,s2
    800037aa:	fcc42703          	lw	a4,-52(s0)
    800037ae:	fce7ece3          	bltu	a5,a4,80003786 <sys_sleep+0x4a>
    800037b2:	74a2                	ld	s1,40(sp)
    800037b4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800037b6:	0005f517          	auipc	a0,0x5f
    800037ba:	68a50513          	addi	a0,a0,1674 # 80062e40 <tickslock>
    800037be:	ffffd097          	auipc	ra,0xffffd
    800037c2:	608080e7          	jalr	1544(ra) # 80000dc6 <release>
  return 0;
    800037c6:	4501                	li	a0,0
}
    800037c8:	70e2                	ld	ra,56(sp)
    800037ca:	7442                	ld	s0,48(sp)
    800037cc:	7902                	ld	s2,32(sp)
    800037ce:	6121                	addi	sp,sp,64
    800037d0:	8082                	ret
      release(&tickslock);
    800037d2:	0005f517          	auipc	a0,0x5f
    800037d6:	66e50513          	addi	a0,a0,1646 # 80062e40 <tickslock>
    800037da:	ffffd097          	auipc	ra,0xffffd
    800037de:	5ec080e7          	jalr	1516(ra) # 80000dc6 <release>
      return -1;
    800037e2:	557d                	li	a0,-1
    800037e4:	74a2                	ld	s1,40(sp)
    800037e6:	69e2                	ld	s3,24(sp)
    800037e8:	b7c5                	j	800037c8 <sys_sleep+0x8c>

00000000800037ea <sys_kill>:

uint64 sys_kill(void) {
    800037ea:	1101                	addi	sp,sp,-32
    800037ec:	ec06                	sd	ra,24(sp)
    800037ee:	e822                	sd	s0,16(sp)
    800037f0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800037f2:	fec40593          	addi	a1,s0,-20
    800037f6:	4501                	li	a0,0
    800037f8:	00000097          	auipc	ra,0x0
    800037fc:	d9e080e7          	jalr	-610(ra) # 80003596 <argint>
  return kill(pid);
    80003800:	fec42503          	lw	a0,-20(s0)
    80003804:	fffff097          	auipc	ra,0xfffff
    80003808:	3ae080e7          	jalr	942(ra) # 80002bb2 <kill>
}
    8000380c:	60e2                	ld	ra,24(sp)
    8000380e:	6442                	ld	s0,16(sp)
    80003810:	6105                	addi	sp,sp,32
    80003812:	8082                	ret

0000000080003814 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80003814:	1101                	addi	sp,sp,-32
    80003816:	ec06                	sd	ra,24(sp)
    80003818:	e822                	sd	s0,16(sp)
    8000381a:	e426                	sd	s1,8(sp)
    8000381c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000381e:	0005f517          	auipc	a0,0x5f
    80003822:	62250513          	addi	a0,a0,1570 # 80062e40 <tickslock>
    80003826:	ffffd097          	auipc	ra,0xffffd
    8000382a:	4f0080e7          	jalr	1264(ra) # 80000d16 <acquire>
  xticks = ticks;
    8000382e:	00009497          	auipc	s1,0x9
    80003832:	3724a483          	lw	s1,882(s1) # 8000cba0 <ticks>
  release(&tickslock);
    80003836:	0005f517          	auipc	a0,0x5f
    8000383a:	60a50513          	addi	a0,a0,1546 # 80062e40 <tickslock>
    8000383e:	ffffd097          	auipc	ra,0xffffd
    80003842:	588080e7          	jalr	1416(ra) # 80000dc6 <release>
  return xticks;
}
    80003846:	02049513          	slli	a0,s1,0x20
    8000384a:	9101                	srli	a0,a0,0x20
    8000384c:	60e2                	ld	ra,24(sp)
    8000384e:	6442                	ld	s0,16(sp)
    80003850:	64a2                	ld	s1,8(sp)
    80003852:	6105                	addi	sp,sp,32
    80003854:	8082                	ret

0000000080003856 <sys_spoon>:

uint64 sys_spoon(void) {
    80003856:	1101                	addi	sp,sp,-32
    80003858:	ec06                	sd	ra,24(sp)
    8000385a:	e822                	sd	s0,16(sp)
    8000385c:	1000                	addi	s0,sp,32
  // obtain the argument from the stack, we need some special handling
  uint64 addr;
  argaddr(0, &addr);
    8000385e:	fe840593          	addi	a1,s0,-24
    80003862:	4501                	li	a0,0
    80003864:	00000097          	auipc	ra,0x0
    80003868:	d52080e7          	jalr	-686(ra) # 800035b6 <argaddr>
  return spoon((void *)addr);
    8000386c:	fe843503          	ld	a0,-24(s0)
    80003870:	fffff097          	auipc	ra,0xfffff
    80003874:	7d8080e7          	jalr	2008(ra) # 80003048 <spoon>
}
    80003878:	60e2                	ld	ra,24(sp)
    8000387a:	6442                	ld	s0,16(sp)
    8000387c:	6105                	addi	sp,sp,32
    8000387e:	8082                	ret

0000000080003880 <sys_create_thread>:

uint64 sys_create_thread(void *arg) {
    80003880:	7179                	addi	sp,sp,-48
    80003882:	f406                	sd	ra,40(sp)
    80003884:	f022                	sd	s0,32(sp)
    80003886:	1800                	addi	s0,sp,48
  uint64 fn_addr, args_addr, stack_addr, exit_fn;
  argaddr(0, &fn_addr);
    80003888:	fe840593          	addi	a1,s0,-24
    8000388c:	4501                	li	a0,0
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	d28080e7          	jalr	-728(ra) # 800035b6 <argaddr>
  argaddr(1, &args_addr);
    80003896:	fe040593          	addi	a1,s0,-32
    8000389a:	4505                	li	a0,1
    8000389c:	00000097          	auipc	ra,0x0
    800038a0:	d1a080e7          	jalr	-742(ra) # 800035b6 <argaddr>
  argaddr(2, &stack_addr);
    800038a4:	fd840593          	addi	a1,s0,-40
    800038a8:	4509                	li	a0,2
    800038aa:	00000097          	auipc	ra,0x0
    800038ae:	d0c080e7          	jalr	-756(ra) # 800035b6 <argaddr>
  argaddr(3, &exit_fn);
    800038b2:	fd040593          	addi	a1,s0,-48
    800038b6:	450d                	li	a0,3
    800038b8:	00000097          	auipc	ra,0x0
    800038bc:	cfe080e7          	jalr	-770(ra) # 800035b6 <argaddr>
  return create_thread((void *)fn_addr, (void *)args_addr, (void *)stack_addr,
    800038c0:	fd043683          	ld	a3,-48(s0)
    800038c4:	fd843603          	ld	a2,-40(s0)
    800038c8:	fe043583          	ld	a1,-32(s0)
    800038cc:	fe843503          	ld	a0,-24(s0)
    800038d0:	fffff097          	auipc	ra,0xfffff
    800038d4:	b9a080e7          	jalr	-1126(ra) # 8000246a <create_thread>
                       (void *)exit_fn);
}
    800038d8:	70a2                	ld	ra,40(sp)
    800038da:	7402                	ld	s0,32(sp)
    800038dc:	6145                	addi	sp,sp,48
    800038de:	8082                	ret

00000000800038e0 <sys_join_thread>:

uint64 sys_join_thread(void *arg) {
    800038e0:	1101                	addi	sp,sp,-32
    800038e2:	ec06                	sd	ra,24(sp)
    800038e4:	e822                	sd	s0,16(sp)
    800038e6:	1000                	addi	s0,sp,32
  uint64 thread_id, status_addr;
  argaddr(0, &thread_id);
    800038e8:	fe840593          	addi	a1,s0,-24
    800038ec:	4501                	li	a0,0
    800038ee:	00000097          	auipc	ra,0x0
    800038f2:	cc8080e7          	jalr	-824(ra) # 800035b6 <argaddr>
  argaddr(1, &status_addr);
    800038f6:	fe040593          	addi	a1,s0,-32
    800038fa:	4505                	li	a0,1
    800038fc:	00000097          	auipc	ra,0x0
    80003900:	cba080e7          	jalr	-838(ra) # 800035b6 <argaddr>
  return join_thread(thread_id, status_addr);
    80003904:	fe043583          	ld	a1,-32(s0)
    80003908:	fe843503          	ld	a0,-24(s0)
    8000390c:	fffff097          	auipc	ra,0xfffff
    80003910:	376080e7          	jalr	886(ra) # 80002c82 <join_thread>
}
    80003914:	60e2                	ld	ra,24(sp)
    80003916:	6442                	ld	s0,16(sp)
    80003918:	6105                	addi	sp,sp,32
    8000391a:	8082                	ret

000000008000391c <sys_thread_exit>:

uint64 sys_thread_exit(void *arg) {
    8000391c:	1101                	addi	sp,sp,-32
    8000391e:	ec06                	sd	ra,24(sp)
    80003920:	e822                	sd	s0,16(sp)
    80003922:	1000                	addi	s0,sp,32
  uint64 status_addr;
  argaddr(0, &status_addr);
    80003924:	fe840593          	addi	a1,s0,-24
    80003928:	4501                	li	a0,0
    8000392a:	00000097          	auipc	ra,0x0
    8000392e:	c8c080e7          	jalr	-884(ra) # 800035b6 <argaddr>
  return thread_exit(status_addr);
    80003932:	fe843503          	ld	a0,-24(s0)
    80003936:	fffff097          	auipc	ra,0xfffff
    8000393a:	028080e7          	jalr	40(ra) # 8000295e <thread_exit>
}
    8000393e:	60e2                	ld	ra,24(sp)
    80003940:	6442                	ld	s0,16(sp)
    80003942:	6105                	addi	sp,sp,32
    80003944:	8082                	ret

0000000080003946 <sys_bind>:

uint64 sys_bind(void *arg) {
    80003946:	7139                	addi	sp,sp,-64
    80003948:	fc06                	sd	ra,56(sp)
    8000394a:	f822                	sd	s0,48(sp)
    8000394c:	f426                	sd	s1,40(sp)
    8000394e:	0080                	addi	s0,sp,64
  uint64 address_family, protocol;
  struct sockaddr address;
  argaddr(0, &address_family);
    80003950:	fd840593          	addi	a1,s0,-40
    80003954:	4501                	li	a0,0
    80003956:	00000097          	auipc	ra,0x0
    8000395a:	c60080e7          	jalr	-928(ra) # 800035b6 <argaddr>
  argaddr(1, (uint64 *)&address);
    8000395e:	fc040493          	addi	s1,s0,-64
    80003962:	85a6                	mv	a1,s1
    80003964:	4505                	li	a0,1
    80003966:	00000097          	auipc	ra,0x0
    8000396a:	c50080e7          	jalr	-944(ra) # 800035b6 <argaddr>
  argaddr(2, &protocol);
    8000396e:	fd040593          	addi	a1,s0,-48
    80003972:	4509                	li	a0,2
    80003974:	00000097          	auipc	ra,0x0
    80003978:	c42080e7          	jalr	-958(ra) # 800035b6 <argaddr>
  return bind(address_family, &address, protocol);
    8000397c:	fd042603          	lw	a2,-48(s0)
    80003980:	85a6                	mv	a1,s1
    80003982:	fd842503          	lw	a0,-40(s0)
    80003986:	fffff097          	auipc	ra,0xfffff
    8000398a:	caa080e7          	jalr	-854(ra) # 80002630 <bind>
}
    8000398e:	70e2                	ld	ra,56(sp)
    80003990:	7442                	ld	s0,48(sp)
    80003992:	74a2                	ld	s1,40(sp)
    80003994:	6121                	addi	sp,sp,64
    80003996:	8082                	ret

0000000080003998 <sys_listen>:

uint64 sys_listen(void *arg) {
    80003998:	1101                	addi	sp,sp,-32
    8000399a:	ec06                	sd	ra,24(sp)
    8000399c:	e822                	sd	s0,16(sp)
    8000399e:	1000                	addi	s0,sp,32
  uint64 socket, backlog;
  argaddr(0, &socket);
    800039a0:	fe840593          	addi	a1,s0,-24
    800039a4:	4501                	li	a0,0
    800039a6:	00000097          	auipc	ra,0x0
    800039aa:	c10080e7          	jalr	-1008(ra) # 800035b6 <argaddr>
  argaddr(1, &backlog);
    800039ae:	fe040593          	addi	a1,s0,-32
    800039b2:	4505                	li	a0,1
    800039b4:	00000097          	auipc	ra,0x0
    800039b8:	c02080e7          	jalr	-1022(ra) # 800035b6 <argaddr>
  return listen(socket, backlog);
    800039bc:	fe042583          	lw	a1,-32(s0)
    800039c0:	fe842503          	lw	a0,-24(s0)
    800039c4:	fffff097          	auipc	ra,0xfffff
    800039c8:	c7e080e7          	jalr	-898(ra) # 80002642 <listen>
}
    800039cc:	60e2                	ld	ra,24(sp)
    800039ce:	6442                	ld	s0,16(sp)
    800039d0:	6105                	addi	sp,sp,32
    800039d2:	8082                	ret

00000000800039d4 <sys_accept>:

uint64 sys_accept(void *arg) {
    800039d4:	7139                	addi	sp,sp,-64
    800039d6:	fc06                	sd	ra,56(sp)
    800039d8:	f822                	sd	s0,48(sp)
    800039da:	f426                	sd	s1,40(sp)
    800039dc:	0080                	addi	s0,sp,64
  uint64 socket;
  uint64 address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    800039de:	fd840593          	addi	a1,s0,-40
    800039e2:	4501                	li	a0,0
    800039e4:	00000097          	auipc	ra,0x0
    800039e8:	bd2080e7          	jalr	-1070(ra) # 800035b6 <argaddr>
  argaddr(1, (uint64 *)&address);
    800039ec:	fc040493          	addi	s1,s0,-64
    800039f0:	85a6                	mv	a1,s1
    800039f2:	4505                	li	a0,1
    800039f4:	00000097          	auipc	ra,0x0
    800039f8:	bc2080e7          	jalr	-1086(ra) # 800035b6 <argaddr>
  argaddr(2, &address_len);
    800039fc:	fd040593          	addi	a1,s0,-48
    80003a00:	4509                	li	a0,2
    80003a02:	00000097          	auipc	ra,0x0
    80003a06:	bb4080e7          	jalr	-1100(ra) # 800035b6 <argaddr>
  return accept(socket, &address, address_len);
    80003a0a:	fd042603          	lw	a2,-48(s0)
    80003a0e:	85a6                	mv	a1,s1
    80003a10:	fd842503          	lw	a0,-40(s0)
    80003a14:	fffff097          	auipc	ra,0xfffff
    80003a18:	c40080e7          	jalr	-960(ra) # 80002654 <accept>
}
    80003a1c:	70e2                	ld	ra,56(sp)
    80003a1e:	7442                	ld	s0,48(sp)
    80003a20:	74a2                	ld	s1,40(sp)
    80003a22:	6121                	addi	sp,sp,64
    80003a24:	8082                	ret

0000000080003a26 <sys_socket>:

uint64 sys_socket(void *arg) {
    80003a26:	7179                	addi	sp,sp,-48
    80003a28:	f406                	sd	ra,40(sp)
    80003a2a:	f022                	sd	s0,32(sp)
    80003a2c:	1800                	addi	s0,sp,48
  uint64 address_family, address_socktype, protocol;
  argaddr(0, &address_family);
    80003a2e:	fe840593          	addi	a1,s0,-24
    80003a32:	4501                	li	a0,0
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	b82080e7          	jalr	-1150(ra) # 800035b6 <argaddr>
  argaddr(1, &address_socktype);
    80003a3c:	fe040593          	addi	a1,s0,-32
    80003a40:	4505                	li	a0,1
    80003a42:	00000097          	auipc	ra,0x0
    80003a46:	b74080e7          	jalr	-1164(ra) # 800035b6 <argaddr>
  argaddr(2, &protocol);
    80003a4a:	fd840593          	addi	a1,s0,-40
    80003a4e:	4509                	li	a0,2
    80003a50:	00000097          	auipc	ra,0x0
    80003a54:	b66080e7          	jalr	-1178(ra) # 800035b6 <argaddr>
  return socket(address_family, address_socktype, protocol);
    80003a58:	fd842603          	lw	a2,-40(s0)
    80003a5c:	fe042583          	lw	a1,-32(s0)
    80003a60:	fe842503          	lw	a0,-24(s0)
    80003a64:	fffff097          	auipc	ra,0xfffff
    80003a68:	bba080e7          	jalr	-1094(ra) # 8000261e <socket>
}
    80003a6c:	70a2                	ld	ra,40(sp)
    80003a6e:	7402                	ld	s0,32(sp)
    80003a70:	6145                	addi	sp,sp,48
    80003a72:	8082                	ret

0000000080003a74 <sys_connect>:

uint64 sys_connect(void *arg) {
    80003a74:	7139                	addi	sp,sp,-64
    80003a76:	fc06                	sd	ra,56(sp)
    80003a78:	f822                	sd	s0,48(sp)
    80003a7a:	f426                	sd	s1,40(sp)
    80003a7c:	0080                	addi	s0,sp,64
  uint64 socket, address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    80003a7e:	fd840593          	addi	a1,s0,-40
    80003a82:	4501                	li	a0,0
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	b32080e7          	jalr	-1230(ra) # 800035b6 <argaddr>
  argaddr(1, (uint64 *)&address);
    80003a8c:	fc040493          	addi	s1,s0,-64
    80003a90:	85a6                	mv	a1,s1
    80003a92:	4505                	li	a0,1
    80003a94:	00000097          	auipc	ra,0x0
    80003a98:	b22080e7          	jalr	-1246(ra) # 800035b6 <argaddr>
  argaddr(2, &address_len);
    80003a9c:	fd040593          	addi	a1,s0,-48
    80003aa0:	4509                	li	a0,2
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	b14080e7          	jalr	-1260(ra) # 800035b6 <argaddr>
  return connect(socket, &address, address_len);
    80003aaa:	fd042603          	lw	a2,-48(s0)
    80003aae:	85a6                	mv	a1,s1
    80003ab0:	fd842503          	lw	a0,-40(s0)
    80003ab4:	fffff097          	auipc	ra,0xfffff
    80003ab8:	bb2080e7          	jalr	-1102(ra) # 80002666 <connect>
}
    80003abc:	70e2                	ld	ra,56(sp)
    80003abe:	7442                	ld	s0,48(sp)
    80003ac0:	74a2                	ld	s1,40(sp)
    80003ac2:	6121                	addi	sp,sp,64
    80003ac4:	8082                	ret

0000000080003ac6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003ac6:	7179                	addi	sp,sp,-48
    80003ac8:	f406                	sd	ra,40(sp)
    80003aca:	f022                	sd	s0,32(sp)
    80003acc:	ec26                	sd	s1,24(sp)
    80003ace:	e84a                	sd	s2,16(sp)
    80003ad0:	e44e                	sd	s3,8(sp)
    80003ad2:	e052                	sd	s4,0(sp)
    80003ad4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003ad6:	00006597          	auipc	a1,0x6
    80003ada:	a0258593          	addi	a1,a1,-1534 # 800094d8 <etext+0x4d8>
    80003ade:	0005f517          	auipc	a0,0x5f
    80003ae2:	37a50513          	addi	a0,a0,890 # 80062e58 <bcache>
    80003ae6:	ffffd097          	auipc	ra,0xffffd
    80003aea:	19c080e7          	jalr	412(ra) # 80000c82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003aee:	00067797          	auipc	a5,0x67
    80003af2:	36a78793          	addi	a5,a5,874 # 8006ae58 <bcache+0x8000>
    80003af6:	00067717          	auipc	a4,0x67
    80003afa:	5ca70713          	addi	a4,a4,1482 # 8006b0c0 <bcache+0x8268>
    80003afe:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003b02:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003b06:	0005f497          	auipc	s1,0x5f
    80003b0a:	36a48493          	addi	s1,s1,874 # 80062e70 <bcache+0x18>
    b->next = bcache.head.next;
    80003b0e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003b10:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003b12:	00006a17          	auipc	s4,0x6
    80003b16:	9cea0a13          	addi	s4,s4,-1586 # 800094e0 <etext+0x4e0>
    b->next = bcache.head.next;
    80003b1a:	2b893783          	ld	a5,696(s2)
    80003b1e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003b20:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003b24:	85d2                	mv	a1,s4
    80003b26:	01048513          	addi	a0,s1,16
    80003b2a:	00001097          	auipc	ra,0x1
    80003b2e:	4e4080e7          	jalr	1252(ra) # 8000500e <initsleeplock>
    bcache.head.next->prev = b;
    80003b32:	2b893783          	ld	a5,696(s2)
    80003b36:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003b38:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003b3c:	45848493          	addi	s1,s1,1112
    80003b40:	fd349de3          	bne	s1,s3,80003b1a <binit+0x54>
  }
}
    80003b44:	70a2                	ld	ra,40(sp)
    80003b46:	7402                	ld	s0,32(sp)
    80003b48:	64e2                	ld	s1,24(sp)
    80003b4a:	6942                	ld	s2,16(sp)
    80003b4c:	69a2                	ld	s3,8(sp)
    80003b4e:	6a02                	ld	s4,0(sp)
    80003b50:	6145                	addi	sp,sp,48
    80003b52:	8082                	ret

0000000080003b54 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003b54:	7179                	addi	sp,sp,-48
    80003b56:	f406                	sd	ra,40(sp)
    80003b58:	f022                	sd	s0,32(sp)
    80003b5a:	ec26                	sd	s1,24(sp)
    80003b5c:	e84a                	sd	s2,16(sp)
    80003b5e:	e44e                	sd	s3,8(sp)
    80003b60:	1800                	addi	s0,sp,48
    80003b62:	892a                	mv	s2,a0
    80003b64:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003b66:	0005f517          	auipc	a0,0x5f
    80003b6a:	2f250513          	addi	a0,a0,754 # 80062e58 <bcache>
    80003b6e:	ffffd097          	auipc	ra,0xffffd
    80003b72:	1a8080e7          	jalr	424(ra) # 80000d16 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003b76:	00067497          	auipc	s1,0x67
    80003b7a:	59a4b483          	ld	s1,1434(s1) # 8006b110 <bcache+0x82b8>
    80003b7e:	00067797          	auipc	a5,0x67
    80003b82:	54278793          	addi	a5,a5,1346 # 8006b0c0 <bcache+0x8268>
    80003b86:	02f48f63          	beq	s1,a5,80003bc4 <bread+0x70>
    80003b8a:	873e                	mv	a4,a5
    80003b8c:	a021                	j	80003b94 <bread+0x40>
    80003b8e:	68a4                	ld	s1,80(s1)
    80003b90:	02e48a63          	beq	s1,a4,80003bc4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003b94:	449c                	lw	a5,8(s1)
    80003b96:	ff279ce3          	bne	a5,s2,80003b8e <bread+0x3a>
    80003b9a:	44dc                	lw	a5,12(s1)
    80003b9c:	ff3799e3          	bne	a5,s3,80003b8e <bread+0x3a>
      b->refcnt++;
    80003ba0:	40bc                	lw	a5,64(s1)
    80003ba2:	2785                	addiw	a5,a5,1
    80003ba4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003ba6:	0005f517          	auipc	a0,0x5f
    80003baa:	2b250513          	addi	a0,a0,690 # 80062e58 <bcache>
    80003bae:	ffffd097          	auipc	ra,0xffffd
    80003bb2:	218080e7          	jalr	536(ra) # 80000dc6 <release>
      acquiresleep(&b->lock);
    80003bb6:	01048513          	addi	a0,s1,16
    80003bba:	00001097          	auipc	ra,0x1
    80003bbe:	48e080e7          	jalr	1166(ra) # 80005048 <acquiresleep>
      return b;
    80003bc2:	a8b9                	j	80003c20 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003bc4:	00067497          	auipc	s1,0x67
    80003bc8:	5444b483          	ld	s1,1348(s1) # 8006b108 <bcache+0x82b0>
    80003bcc:	00067797          	auipc	a5,0x67
    80003bd0:	4f478793          	addi	a5,a5,1268 # 8006b0c0 <bcache+0x8268>
    80003bd4:	00f48863          	beq	s1,a5,80003be4 <bread+0x90>
    80003bd8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003bda:	40bc                	lw	a5,64(s1)
    80003bdc:	cf81                	beqz	a5,80003bf4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003bde:	64a4                	ld	s1,72(s1)
    80003be0:	fee49de3          	bne	s1,a4,80003bda <bread+0x86>
  panic("bget: no buffers");
    80003be4:	00006517          	auipc	a0,0x6
    80003be8:	90450513          	addi	a0,a0,-1788 # 800094e8 <etext+0x4e8>
    80003bec:	ffffd097          	auipc	ra,0xffffd
    80003bf0:	974080e7          	jalr	-1676(ra) # 80000560 <panic>
      b->dev = dev;
    80003bf4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003bf8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003bfc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003c00:	4785                	li	a5,1
    80003c02:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003c04:	0005f517          	auipc	a0,0x5f
    80003c08:	25450513          	addi	a0,a0,596 # 80062e58 <bcache>
    80003c0c:	ffffd097          	auipc	ra,0xffffd
    80003c10:	1ba080e7          	jalr	442(ra) # 80000dc6 <release>
      acquiresleep(&b->lock);
    80003c14:	01048513          	addi	a0,s1,16
    80003c18:	00001097          	auipc	ra,0x1
    80003c1c:	430080e7          	jalr	1072(ra) # 80005048 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003c20:	409c                	lw	a5,0(s1)
    80003c22:	cb89                	beqz	a5,80003c34 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003c24:	8526                	mv	a0,s1
    80003c26:	70a2                	ld	ra,40(sp)
    80003c28:	7402                	ld	s0,32(sp)
    80003c2a:	64e2                	ld	s1,24(sp)
    80003c2c:	6942                	ld	s2,16(sp)
    80003c2e:	69a2                	ld	s3,8(sp)
    80003c30:	6145                	addi	sp,sp,48
    80003c32:	8082                	ret
    virtio_disk_rw(b, 0);
    80003c34:	4581                	li	a1,0
    80003c36:	8526                	mv	a0,s1
    80003c38:	00003097          	auipc	ra,0x3
    80003c3c:	102080e7          	jalr	258(ra) # 80006d3a <virtio_disk_rw>
    b->valid = 1;
    80003c40:	4785                	li	a5,1
    80003c42:	c09c                	sw	a5,0(s1)
  return b;
    80003c44:	b7c5                	j	80003c24 <bread+0xd0>

0000000080003c46 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003c46:	1101                	addi	sp,sp,-32
    80003c48:	ec06                	sd	ra,24(sp)
    80003c4a:	e822                	sd	s0,16(sp)
    80003c4c:	e426                	sd	s1,8(sp)
    80003c4e:	1000                	addi	s0,sp,32
    80003c50:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003c52:	0541                	addi	a0,a0,16
    80003c54:	00001097          	auipc	ra,0x1
    80003c58:	48e080e7          	jalr	1166(ra) # 800050e2 <holdingsleep>
    80003c5c:	cd01                	beqz	a0,80003c74 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003c5e:	4585                	li	a1,1
    80003c60:	8526                	mv	a0,s1
    80003c62:	00003097          	auipc	ra,0x3
    80003c66:	0d8080e7          	jalr	216(ra) # 80006d3a <virtio_disk_rw>
}
    80003c6a:	60e2                	ld	ra,24(sp)
    80003c6c:	6442                	ld	s0,16(sp)
    80003c6e:	64a2                	ld	s1,8(sp)
    80003c70:	6105                	addi	sp,sp,32
    80003c72:	8082                	ret
    panic("bwrite");
    80003c74:	00006517          	auipc	a0,0x6
    80003c78:	88c50513          	addi	a0,a0,-1908 # 80009500 <etext+0x500>
    80003c7c:	ffffd097          	auipc	ra,0xffffd
    80003c80:	8e4080e7          	jalr	-1820(ra) # 80000560 <panic>

0000000080003c84 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003c84:	1101                	addi	sp,sp,-32
    80003c86:	ec06                	sd	ra,24(sp)
    80003c88:	e822                	sd	s0,16(sp)
    80003c8a:	e426                	sd	s1,8(sp)
    80003c8c:	e04a                	sd	s2,0(sp)
    80003c8e:	1000                	addi	s0,sp,32
    80003c90:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003c92:	01050913          	addi	s2,a0,16
    80003c96:	854a                	mv	a0,s2
    80003c98:	00001097          	auipc	ra,0x1
    80003c9c:	44a080e7          	jalr	1098(ra) # 800050e2 <holdingsleep>
    80003ca0:	c535                	beqz	a0,80003d0c <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003ca2:	854a                	mv	a0,s2
    80003ca4:	00001097          	auipc	ra,0x1
    80003ca8:	3fa080e7          	jalr	1018(ra) # 8000509e <releasesleep>

  acquire(&bcache.lock);
    80003cac:	0005f517          	auipc	a0,0x5f
    80003cb0:	1ac50513          	addi	a0,a0,428 # 80062e58 <bcache>
    80003cb4:	ffffd097          	auipc	ra,0xffffd
    80003cb8:	062080e7          	jalr	98(ra) # 80000d16 <acquire>
  b->refcnt--;
    80003cbc:	40bc                	lw	a5,64(s1)
    80003cbe:	37fd                	addiw	a5,a5,-1
    80003cc0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003cc2:	e79d                	bnez	a5,80003cf0 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003cc4:	68b8                	ld	a4,80(s1)
    80003cc6:	64bc                	ld	a5,72(s1)
    80003cc8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003cca:	68b8                	ld	a4,80(s1)
    80003ccc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003cce:	00067797          	auipc	a5,0x67
    80003cd2:	18a78793          	addi	a5,a5,394 # 8006ae58 <bcache+0x8000>
    80003cd6:	2b87b703          	ld	a4,696(a5)
    80003cda:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003cdc:	00067717          	auipc	a4,0x67
    80003ce0:	3e470713          	addi	a4,a4,996 # 8006b0c0 <bcache+0x8268>
    80003ce4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003ce6:	2b87b703          	ld	a4,696(a5)
    80003cea:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003cec:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003cf0:	0005f517          	auipc	a0,0x5f
    80003cf4:	16850513          	addi	a0,a0,360 # 80062e58 <bcache>
    80003cf8:	ffffd097          	auipc	ra,0xffffd
    80003cfc:	0ce080e7          	jalr	206(ra) # 80000dc6 <release>
}
    80003d00:	60e2                	ld	ra,24(sp)
    80003d02:	6442                	ld	s0,16(sp)
    80003d04:	64a2                	ld	s1,8(sp)
    80003d06:	6902                	ld	s2,0(sp)
    80003d08:	6105                	addi	sp,sp,32
    80003d0a:	8082                	ret
    panic("brelse");
    80003d0c:	00005517          	auipc	a0,0x5
    80003d10:	7fc50513          	addi	a0,a0,2044 # 80009508 <etext+0x508>
    80003d14:	ffffd097          	auipc	ra,0xffffd
    80003d18:	84c080e7          	jalr	-1972(ra) # 80000560 <panic>

0000000080003d1c <bpin>:

void
bpin(struct buf *b) {
    80003d1c:	1101                	addi	sp,sp,-32
    80003d1e:	ec06                	sd	ra,24(sp)
    80003d20:	e822                	sd	s0,16(sp)
    80003d22:	e426                	sd	s1,8(sp)
    80003d24:	1000                	addi	s0,sp,32
    80003d26:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003d28:	0005f517          	auipc	a0,0x5f
    80003d2c:	13050513          	addi	a0,a0,304 # 80062e58 <bcache>
    80003d30:	ffffd097          	auipc	ra,0xffffd
    80003d34:	fe6080e7          	jalr	-26(ra) # 80000d16 <acquire>
  b->refcnt++;
    80003d38:	40bc                	lw	a5,64(s1)
    80003d3a:	2785                	addiw	a5,a5,1
    80003d3c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003d3e:	0005f517          	auipc	a0,0x5f
    80003d42:	11a50513          	addi	a0,a0,282 # 80062e58 <bcache>
    80003d46:	ffffd097          	auipc	ra,0xffffd
    80003d4a:	080080e7          	jalr	128(ra) # 80000dc6 <release>
}
    80003d4e:	60e2                	ld	ra,24(sp)
    80003d50:	6442                	ld	s0,16(sp)
    80003d52:	64a2                	ld	s1,8(sp)
    80003d54:	6105                	addi	sp,sp,32
    80003d56:	8082                	ret

0000000080003d58 <bunpin>:

void
bunpin(struct buf *b) {
    80003d58:	1101                	addi	sp,sp,-32
    80003d5a:	ec06                	sd	ra,24(sp)
    80003d5c:	e822                	sd	s0,16(sp)
    80003d5e:	e426                	sd	s1,8(sp)
    80003d60:	1000                	addi	s0,sp,32
    80003d62:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003d64:	0005f517          	auipc	a0,0x5f
    80003d68:	0f450513          	addi	a0,a0,244 # 80062e58 <bcache>
    80003d6c:	ffffd097          	auipc	ra,0xffffd
    80003d70:	faa080e7          	jalr	-86(ra) # 80000d16 <acquire>
  b->refcnt--;
    80003d74:	40bc                	lw	a5,64(s1)
    80003d76:	37fd                	addiw	a5,a5,-1
    80003d78:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003d7a:	0005f517          	auipc	a0,0x5f
    80003d7e:	0de50513          	addi	a0,a0,222 # 80062e58 <bcache>
    80003d82:	ffffd097          	auipc	ra,0xffffd
    80003d86:	044080e7          	jalr	68(ra) # 80000dc6 <release>
}
    80003d8a:	60e2                	ld	ra,24(sp)
    80003d8c:	6442                	ld	s0,16(sp)
    80003d8e:	64a2                	ld	s1,8(sp)
    80003d90:	6105                	addi	sp,sp,32
    80003d92:	8082                	ret

0000000080003d94 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003d94:	1101                	addi	sp,sp,-32
    80003d96:	ec06                	sd	ra,24(sp)
    80003d98:	e822                	sd	s0,16(sp)
    80003d9a:	e426                	sd	s1,8(sp)
    80003d9c:	e04a                	sd	s2,0(sp)
    80003d9e:	1000                	addi	s0,sp,32
    80003da0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003da2:	00d5d79b          	srliw	a5,a1,0xd
    80003da6:	00067597          	auipc	a1,0x67
    80003daa:	78e5a583          	lw	a1,1934(a1) # 8006b534 <sb+0x1c>
    80003dae:	9dbd                	addw	a1,a1,a5
    80003db0:	00000097          	auipc	ra,0x0
    80003db4:	da4080e7          	jalr	-604(ra) # 80003b54 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003db8:	0074f713          	andi	a4,s1,7
    80003dbc:	4785                	li	a5,1
    80003dbe:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003dc2:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003dc4:	90d9                	srli	s1,s1,0x36
    80003dc6:	00950733          	add	a4,a0,s1
    80003dca:	05874703          	lbu	a4,88(a4)
    80003dce:	00e7f6b3          	and	a3,a5,a4
    80003dd2:	c69d                	beqz	a3,80003e00 <bfree+0x6c>
    80003dd4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003dd6:	94aa                	add	s1,s1,a0
    80003dd8:	fff7c793          	not	a5,a5
    80003ddc:	8f7d                	and	a4,a4,a5
    80003dde:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003de2:	00001097          	auipc	ra,0x1
    80003de6:	148080e7          	jalr	328(ra) # 80004f2a <log_write>
  brelse(bp);
    80003dea:	854a                	mv	a0,s2
    80003dec:	00000097          	auipc	ra,0x0
    80003df0:	e98080e7          	jalr	-360(ra) # 80003c84 <brelse>
}
    80003df4:	60e2                	ld	ra,24(sp)
    80003df6:	6442                	ld	s0,16(sp)
    80003df8:	64a2                	ld	s1,8(sp)
    80003dfa:	6902                	ld	s2,0(sp)
    80003dfc:	6105                	addi	sp,sp,32
    80003dfe:	8082                	ret
    panic("freeing free block");
    80003e00:	00005517          	auipc	a0,0x5
    80003e04:	71050513          	addi	a0,a0,1808 # 80009510 <etext+0x510>
    80003e08:	ffffc097          	auipc	ra,0xffffc
    80003e0c:	758080e7          	jalr	1880(ra) # 80000560 <panic>

0000000080003e10 <balloc>:
{
    80003e10:	715d                	addi	sp,sp,-80
    80003e12:	e486                	sd	ra,72(sp)
    80003e14:	e0a2                	sd	s0,64(sp)
    80003e16:	fc26                	sd	s1,56(sp)
    80003e18:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003e1a:	00067797          	auipc	a5,0x67
    80003e1e:	7027a783          	lw	a5,1794(a5) # 8006b51c <sb+0x4>
    80003e22:	10078863          	beqz	a5,80003f32 <balloc+0x122>
    80003e26:	f84a                	sd	s2,48(sp)
    80003e28:	f44e                	sd	s3,40(sp)
    80003e2a:	f052                	sd	s4,32(sp)
    80003e2c:	ec56                	sd	s5,24(sp)
    80003e2e:	e85a                	sd	s6,16(sp)
    80003e30:	e45e                	sd	s7,8(sp)
    80003e32:	e062                	sd	s8,0(sp)
    80003e34:	8baa                	mv	s7,a0
    80003e36:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003e38:	00067b17          	auipc	s6,0x67
    80003e3c:	6e0b0b13          	addi	s6,s6,1760 # 8006b518 <sb>
      m = 1 << (bi % 8);
    80003e40:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003e42:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003e44:	6c09                	lui	s8,0x2
    80003e46:	a049                	j	80003ec8 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003e48:	97ca                	add	a5,a5,s2
    80003e4a:	8e55                	or	a2,a2,a3
    80003e4c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003e50:	854a                	mv	a0,s2
    80003e52:	00001097          	auipc	ra,0x1
    80003e56:	0d8080e7          	jalr	216(ra) # 80004f2a <log_write>
        brelse(bp);
    80003e5a:	854a                	mv	a0,s2
    80003e5c:	00000097          	auipc	ra,0x0
    80003e60:	e28080e7          	jalr	-472(ra) # 80003c84 <brelse>
  bp = bread(dev, bno);
    80003e64:	85a6                	mv	a1,s1
    80003e66:	855e                	mv	a0,s7
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	cec080e7          	jalr	-788(ra) # 80003b54 <bread>
    80003e70:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003e72:	40000613          	li	a2,1024
    80003e76:	4581                	li	a1,0
    80003e78:	05850513          	addi	a0,a0,88
    80003e7c:	ffffd097          	auipc	ra,0xffffd
    80003e80:	f92080e7          	jalr	-110(ra) # 80000e0e <memset>
  log_write(bp);
    80003e84:	854a                	mv	a0,s2
    80003e86:	00001097          	auipc	ra,0x1
    80003e8a:	0a4080e7          	jalr	164(ra) # 80004f2a <log_write>
  brelse(bp);
    80003e8e:	854a                	mv	a0,s2
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	df4080e7          	jalr	-524(ra) # 80003c84 <brelse>
}
    80003e98:	7942                	ld	s2,48(sp)
    80003e9a:	79a2                	ld	s3,40(sp)
    80003e9c:	7a02                	ld	s4,32(sp)
    80003e9e:	6ae2                	ld	s5,24(sp)
    80003ea0:	6b42                	ld	s6,16(sp)
    80003ea2:	6ba2                	ld	s7,8(sp)
    80003ea4:	6c02                	ld	s8,0(sp)
}
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	60a6                	ld	ra,72(sp)
    80003eaa:	6406                	ld	s0,64(sp)
    80003eac:	74e2                	ld	s1,56(sp)
    80003eae:	6161                	addi	sp,sp,80
    80003eb0:	8082                	ret
    brelse(bp);
    80003eb2:	854a                	mv	a0,s2
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	dd0080e7          	jalr	-560(ra) # 80003c84 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003ebc:	015c0abb          	addw	s5,s8,s5
    80003ec0:	004b2783          	lw	a5,4(s6)
    80003ec4:	06faf063          	bgeu	s5,a5,80003f24 <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    80003ec8:	41fad79b          	sraiw	a5,s5,0x1f
    80003ecc:	0137d79b          	srliw	a5,a5,0x13
    80003ed0:	015787bb          	addw	a5,a5,s5
    80003ed4:	40d7d79b          	sraiw	a5,a5,0xd
    80003ed8:	01cb2583          	lw	a1,28(s6)
    80003edc:	9dbd                	addw	a1,a1,a5
    80003ede:	855e                	mv	a0,s7
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	c74080e7          	jalr	-908(ra) # 80003b54 <bread>
    80003ee8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003eea:	004b2503          	lw	a0,4(s6)
    80003eee:	84d6                	mv	s1,s5
    80003ef0:	4701                	li	a4,0
    80003ef2:	fca4f0e3          	bgeu	s1,a0,80003eb2 <balloc+0xa2>
      m = 1 << (bi % 8);
    80003ef6:	00777693          	andi	a3,a4,7
    80003efa:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003efe:	41f7579b          	sraiw	a5,a4,0x1f
    80003f02:	01d7d79b          	srliw	a5,a5,0x1d
    80003f06:	9fb9                	addw	a5,a5,a4
    80003f08:	4037d79b          	sraiw	a5,a5,0x3
    80003f0c:	00f90633          	add	a2,s2,a5
    80003f10:	05864603          	lbu	a2,88(a2)
    80003f14:	00c6f5b3          	and	a1,a3,a2
    80003f18:	d985                	beqz	a1,80003e48 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003f1a:	2705                	addiw	a4,a4,1
    80003f1c:	2485                	addiw	s1,s1,1
    80003f1e:	fd471ae3          	bne	a4,s4,80003ef2 <balloc+0xe2>
    80003f22:	bf41                	j	80003eb2 <balloc+0xa2>
    80003f24:	7942                	ld	s2,48(sp)
    80003f26:	79a2                	ld	s3,40(sp)
    80003f28:	7a02                	ld	s4,32(sp)
    80003f2a:	6ae2                	ld	s5,24(sp)
    80003f2c:	6b42                	ld	s6,16(sp)
    80003f2e:	6ba2                	ld	s7,8(sp)
    80003f30:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003f32:	00005517          	auipc	a0,0x5
    80003f36:	5f650513          	addi	a0,a0,1526 # 80009528 <etext+0x528>
    80003f3a:	ffffc097          	auipc	ra,0xffffc
    80003f3e:	670080e7          	jalr	1648(ra) # 800005aa <printf>
  return 0;
    80003f42:	4481                	li	s1,0
    80003f44:	b78d                	j	80003ea6 <balloc+0x96>

0000000080003f46 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003f46:	7179                	addi	sp,sp,-48
    80003f48:	f406                	sd	ra,40(sp)
    80003f4a:	f022                	sd	s0,32(sp)
    80003f4c:	ec26                	sd	s1,24(sp)
    80003f4e:	e84a                	sd	s2,16(sp)
    80003f50:	e44e                	sd	s3,8(sp)
    80003f52:	1800                	addi	s0,sp,48
    80003f54:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003f56:	47ad                	li	a5,11
    80003f58:	02b7e563          	bltu	a5,a1,80003f82 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003f5c:	02059793          	slli	a5,a1,0x20
    80003f60:	01e7d593          	srli	a1,a5,0x1e
    80003f64:	00b504b3          	add	s1,a0,a1
    80003f68:	0504a903          	lw	s2,80(s1)
    80003f6c:	06091b63          	bnez	s2,80003fe2 <bmap+0x9c>
      addr = balloc(ip->dev);
    80003f70:	4108                	lw	a0,0(a0)
    80003f72:	00000097          	auipc	ra,0x0
    80003f76:	e9e080e7          	jalr	-354(ra) # 80003e10 <balloc>
    80003f7a:	892a                	mv	s2,a0
      if(addr == 0)
    80003f7c:	c13d                	beqz	a0,80003fe2 <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    80003f7e:	c8a8                	sw	a0,80(s1)
    80003f80:	a08d                	j	80003fe2 <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003f82:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80003f86:	0ff00793          	li	a5,255
    80003f8a:	0897e363          	bltu	a5,s1,80004010 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003f8e:	08052903          	lw	s2,128(a0)
    80003f92:	00091d63          	bnez	s2,80003fac <bmap+0x66>
      addr = balloc(ip->dev);
    80003f96:	4108                	lw	a0,0(a0)
    80003f98:	00000097          	auipc	ra,0x0
    80003f9c:	e78080e7          	jalr	-392(ra) # 80003e10 <balloc>
    80003fa0:	892a                	mv	s2,a0
      if(addr == 0)
    80003fa2:	c121                	beqz	a0,80003fe2 <bmap+0x9c>
    80003fa4:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003fa6:	08a9a023          	sw	a0,128(s3)
    80003faa:	a011                	j	80003fae <bmap+0x68>
    80003fac:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003fae:	85ca                	mv	a1,s2
    80003fb0:	0009a503          	lw	a0,0(s3)
    80003fb4:	00000097          	auipc	ra,0x0
    80003fb8:	ba0080e7          	jalr	-1120(ra) # 80003b54 <bread>
    80003fbc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003fbe:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003fc2:	02049713          	slli	a4,s1,0x20
    80003fc6:	01e75593          	srli	a1,a4,0x1e
    80003fca:	00b784b3          	add	s1,a5,a1
    80003fce:	0004a903          	lw	s2,0(s1)
    80003fd2:	02090063          	beqz	s2,80003ff2 <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003fd6:	8552                	mv	a0,s4
    80003fd8:	00000097          	auipc	ra,0x0
    80003fdc:	cac080e7          	jalr	-852(ra) # 80003c84 <brelse>
    return addr;
    80003fe0:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003fe2:	854a                	mv	a0,s2
    80003fe4:	70a2                	ld	ra,40(sp)
    80003fe6:	7402                	ld	s0,32(sp)
    80003fe8:	64e2                	ld	s1,24(sp)
    80003fea:	6942                	ld	s2,16(sp)
    80003fec:	69a2                	ld	s3,8(sp)
    80003fee:	6145                	addi	sp,sp,48
    80003ff0:	8082                	ret
      addr = balloc(ip->dev);
    80003ff2:	0009a503          	lw	a0,0(s3)
    80003ff6:	00000097          	auipc	ra,0x0
    80003ffa:	e1a080e7          	jalr	-486(ra) # 80003e10 <balloc>
    80003ffe:	892a                	mv	s2,a0
      if(addr){
    80004000:	d979                	beqz	a0,80003fd6 <bmap+0x90>
        a[bn] = addr;
    80004002:	c088                	sw	a0,0(s1)
        log_write(bp);
    80004004:	8552                	mv	a0,s4
    80004006:	00001097          	auipc	ra,0x1
    8000400a:	f24080e7          	jalr	-220(ra) # 80004f2a <log_write>
    8000400e:	b7e1                	j	80003fd6 <bmap+0x90>
    80004010:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80004012:	00005517          	auipc	a0,0x5
    80004016:	52e50513          	addi	a0,a0,1326 # 80009540 <etext+0x540>
    8000401a:	ffffc097          	auipc	ra,0xffffc
    8000401e:	546080e7          	jalr	1350(ra) # 80000560 <panic>

0000000080004022 <iget>:
{
    80004022:	7179                	addi	sp,sp,-48
    80004024:	f406                	sd	ra,40(sp)
    80004026:	f022                	sd	s0,32(sp)
    80004028:	ec26                	sd	s1,24(sp)
    8000402a:	e84a                	sd	s2,16(sp)
    8000402c:	e44e                	sd	s3,8(sp)
    8000402e:	e052                	sd	s4,0(sp)
    80004030:	1800                	addi	s0,sp,48
    80004032:	89aa                	mv	s3,a0
    80004034:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80004036:	00067517          	auipc	a0,0x67
    8000403a:	50250513          	addi	a0,a0,1282 # 8006b538 <itable>
    8000403e:	ffffd097          	auipc	ra,0xffffd
    80004042:	cd8080e7          	jalr	-808(ra) # 80000d16 <acquire>
  empty = 0;
    80004046:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004048:	00067497          	auipc	s1,0x67
    8000404c:	50848493          	addi	s1,s1,1288 # 8006b550 <itable+0x18>
    80004050:	00069697          	auipc	a3,0x69
    80004054:	f9068693          	addi	a3,a3,-112 # 8006cfe0 <log>
    80004058:	a039                	j	80004066 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000405a:	02090b63          	beqz	s2,80004090 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000405e:	08848493          	addi	s1,s1,136
    80004062:	02d48a63          	beq	s1,a3,80004096 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80004066:	449c                	lw	a5,8(s1)
    80004068:	fef059e3          	blez	a5,8000405a <iget+0x38>
    8000406c:	4098                	lw	a4,0(s1)
    8000406e:	ff3716e3          	bne	a4,s3,8000405a <iget+0x38>
    80004072:	40d8                	lw	a4,4(s1)
    80004074:	ff4713e3          	bne	a4,s4,8000405a <iget+0x38>
      ip->ref++;
    80004078:	2785                	addiw	a5,a5,1
    8000407a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000407c:	00067517          	auipc	a0,0x67
    80004080:	4bc50513          	addi	a0,a0,1212 # 8006b538 <itable>
    80004084:	ffffd097          	auipc	ra,0xffffd
    80004088:	d42080e7          	jalr	-702(ra) # 80000dc6 <release>
      return ip;
    8000408c:	8926                	mv	s2,s1
    8000408e:	a03d                	j	800040bc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004090:	f7f9                	bnez	a5,8000405e <iget+0x3c>
      empty = ip;
    80004092:	8926                	mv	s2,s1
    80004094:	b7e9                	j	8000405e <iget+0x3c>
  if(empty == 0)
    80004096:	02090c63          	beqz	s2,800040ce <iget+0xac>
  ip->dev = dev;
    8000409a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000409e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800040a2:	4785                	li	a5,1
    800040a4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800040a8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800040ac:	00067517          	auipc	a0,0x67
    800040b0:	48c50513          	addi	a0,a0,1164 # 8006b538 <itable>
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	d12080e7          	jalr	-750(ra) # 80000dc6 <release>
}
    800040bc:	854a                	mv	a0,s2
    800040be:	70a2                	ld	ra,40(sp)
    800040c0:	7402                	ld	s0,32(sp)
    800040c2:	64e2                	ld	s1,24(sp)
    800040c4:	6942                	ld	s2,16(sp)
    800040c6:	69a2                	ld	s3,8(sp)
    800040c8:	6a02                	ld	s4,0(sp)
    800040ca:	6145                	addi	sp,sp,48
    800040cc:	8082                	ret
    panic("iget: no inodes");
    800040ce:	00005517          	auipc	a0,0x5
    800040d2:	48a50513          	addi	a0,a0,1162 # 80009558 <etext+0x558>
    800040d6:	ffffc097          	auipc	ra,0xffffc
    800040da:	48a080e7          	jalr	1162(ra) # 80000560 <panic>

00000000800040de <fsinit>:
fsinit(int dev) {
    800040de:	7179                	addi	sp,sp,-48
    800040e0:	f406                	sd	ra,40(sp)
    800040e2:	f022                	sd	s0,32(sp)
    800040e4:	ec26                	sd	s1,24(sp)
    800040e6:	e84a                	sd	s2,16(sp)
    800040e8:	e44e                	sd	s3,8(sp)
    800040ea:	1800                	addi	s0,sp,48
    800040ec:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800040ee:	4585                	li	a1,1
    800040f0:	00000097          	auipc	ra,0x0
    800040f4:	a64080e7          	jalr	-1436(ra) # 80003b54 <bread>
    800040f8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800040fa:	00067997          	auipc	s3,0x67
    800040fe:	41e98993          	addi	s3,s3,1054 # 8006b518 <sb>
    80004102:	02000613          	li	a2,32
    80004106:	05850593          	addi	a1,a0,88
    8000410a:	854e                	mv	a0,s3
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	d66080e7          	jalr	-666(ra) # 80000e72 <memmove>
  brelse(bp);
    80004114:	8526                	mv	a0,s1
    80004116:	00000097          	auipc	ra,0x0
    8000411a:	b6e080e7          	jalr	-1170(ra) # 80003c84 <brelse>
  if(sb.magic != FSMAGIC)
    8000411e:	0009a703          	lw	a4,0(s3)
    80004122:	102037b7          	lui	a5,0x10203
    80004126:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000412a:	02f71263          	bne	a4,a5,8000414e <fsinit+0x70>
  initlog(dev, &sb);
    8000412e:	00067597          	auipc	a1,0x67
    80004132:	3ea58593          	addi	a1,a1,1002 # 8006b518 <sb>
    80004136:	854a                	mv	a0,s2
    80004138:	00001097          	auipc	ra,0x1
    8000413c:	b7c080e7          	jalr	-1156(ra) # 80004cb4 <initlog>
}
    80004140:	70a2                	ld	ra,40(sp)
    80004142:	7402                	ld	s0,32(sp)
    80004144:	64e2                	ld	s1,24(sp)
    80004146:	6942                	ld	s2,16(sp)
    80004148:	69a2                	ld	s3,8(sp)
    8000414a:	6145                	addi	sp,sp,48
    8000414c:	8082                	ret
    panic("invalid file system");
    8000414e:	00005517          	auipc	a0,0x5
    80004152:	41a50513          	addi	a0,a0,1050 # 80009568 <etext+0x568>
    80004156:	ffffc097          	auipc	ra,0xffffc
    8000415a:	40a080e7          	jalr	1034(ra) # 80000560 <panic>

000000008000415e <iinit>:
{
    8000415e:	7179                	addi	sp,sp,-48
    80004160:	f406                	sd	ra,40(sp)
    80004162:	f022                	sd	s0,32(sp)
    80004164:	ec26                	sd	s1,24(sp)
    80004166:	e84a                	sd	s2,16(sp)
    80004168:	e44e                	sd	s3,8(sp)
    8000416a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000416c:	00005597          	auipc	a1,0x5
    80004170:	41458593          	addi	a1,a1,1044 # 80009580 <etext+0x580>
    80004174:	00067517          	auipc	a0,0x67
    80004178:	3c450513          	addi	a0,a0,964 # 8006b538 <itable>
    8000417c:	ffffd097          	auipc	ra,0xffffd
    80004180:	b06080e7          	jalr	-1274(ra) # 80000c82 <initlock>
  for(i = 0; i < NINODE; i++) {
    80004184:	00067497          	auipc	s1,0x67
    80004188:	3dc48493          	addi	s1,s1,988 # 8006b560 <itable+0x28>
    8000418c:	00069997          	auipc	s3,0x69
    80004190:	e6498993          	addi	s3,s3,-412 # 8006cff0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80004194:	00005917          	auipc	s2,0x5
    80004198:	3f490913          	addi	s2,s2,1012 # 80009588 <etext+0x588>
    8000419c:	85ca                	mv	a1,s2
    8000419e:	8526                	mv	a0,s1
    800041a0:	00001097          	auipc	ra,0x1
    800041a4:	e6e080e7          	jalr	-402(ra) # 8000500e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800041a8:	08848493          	addi	s1,s1,136
    800041ac:	ff3498e3          	bne	s1,s3,8000419c <iinit+0x3e>
}
    800041b0:	70a2                	ld	ra,40(sp)
    800041b2:	7402                	ld	s0,32(sp)
    800041b4:	64e2                	ld	s1,24(sp)
    800041b6:	6942                	ld	s2,16(sp)
    800041b8:	69a2                	ld	s3,8(sp)
    800041ba:	6145                	addi	sp,sp,48
    800041bc:	8082                	ret

00000000800041be <ialloc>:
{
    800041be:	7139                	addi	sp,sp,-64
    800041c0:	fc06                	sd	ra,56(sp)
    800041c2:	f822                	sd	s0,48(sp)
    800041c4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800041c6:	00067717          	auipc	a4,0x67
    800041ca:	35e72703          	lw	a4,862(a4) # 8006b524 <sb+0xc>
    800041ce:	4785                	li	a5,1
    800041d0:	06e7f463          	bgeu	a5,a4,80004238 <ialloc+0x7a>
    800041d4:	f426                	sd	s1,40(sp)
    800041d6:	f04a                	sd	s2,32(sp)
    800041d8:	ec4e                	sd	s3,24(sp)
    800041da:	e852                	sd	s4,16(sp)
    800041dc:	e456                	sd	s5,8(sp)
    800041de:	e05a                	sd	s6,0(sp)
    800041e0:	8aaa                	mv	s5,a0
    800041e2:	8b2e                	mv	s6,a1
    800041e4:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800041e6:	00067a17          	auipc	s4,0x67
    800041ea:	332a0a13          	addi	s4,s4,818 # 8006b518 <sb>
    800041ee:	00495593          	srli	a1,s2,0x4
    800041f2:	018a2783          	lw	a5,24(s4)
    800041f6:	9dbd                	addw	a1,a1,a5
    800041f8:	8556                	mv	a0,s5
    800041fa:	00000097          	auipc	ra,0x0
    800041fe:	95a080e7          	jalr	-1702(ra) # 80003b54 <bread>
    80004202:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80004204:	05850993          	addi	s3,a0,88
    80004208:	00f97793          	andi	a5,s2,15
    8000420c:	079a                	slli	a5,a5,0x6
    8000420e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80004210:	00099783          	lh	a5,0(s3)
    80004214:	cf9d                	beqz	a5,80004252 <ialloc+0x94>
    brelse(bp);
    80004216:	00000097          	auipc	ra,0x0
    8000421a:	a6e080e7          	jalr	-1426(ra) # 80003c84 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000421e:	0905                	addi	s2,s2,1
    80004220:	00ca2703          	lw	a4,12(s4)
    80004224:	0009079b          	sext.w	a5,s2
    80004228:	fce7e3e3          	bltu	a5,a4,800041ee <ialloc+0x30>
    8000422c:	74a2                	ld	s1,40(sp)
    8000422e:	7902                	ld	s2,32(sp)
    80004230:	69e2                	ld	s3,24(sp)
    80004232:	6a42                	ld	s4,16(sp)
    80004234:	6aa2                	ld	s5,8(sp)
    80004236:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80004238:	00005517          	auipc	a0,0x5
    8000423c:	35850513          	addi	a0,a0,856 # 80009590 <etext+0x590>
    80004240:	ffffc097          	auipc	ra,0xffffc
    80004244:	36a080e7          	jalr	874(ra) # 800005aa <printf>
  return 0;
    80004248:	4501                	li	a0,0
}
    8000424a:	70e2                	ld	ra,56(sp)
    8000424c:	7442                	ld	s0,48(sp)
    8000424e:	6121                	addi	sp,sp,64
    80004250:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80004252:	04000613          	li	a2,64
    80004256:	4581                	li	a1,0
    80004258:	854e                	mv	a0,s3
    8000425a:	ffffd097          	auipc	ra,0xffffd
    8000425e:	bb4080e7          	jalr	-1100(ra) # 80000e0e <memset>
      dip->type = type;
    80004262:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80004266:	8526                	mv	a0,s1
    80004268:	00001097          	auipc	ra,0x1
    8000426c:	cc2080e7          	jalr	-830(ra) # 80004f2a <log_write>
      brelse(bp);
    80004270:	8526                	mv	a0,s1
    80004272:	00000097          	auipc	ra,0x0
    80004276:	a12080e7          	jalr	-1518(ra) # 80003c84 <brelse>
      return iget(dev, inum);
    8000427a:	0009059b          	sext.w	a1,s2
    8000427e:	8556                	mv	a0,s5
    80004280:	00000097          	auipc	ra,0x0
    80004284:	da2080e7          	jalr	-606(ra) # 80004022 <iget>
    80004288:	74a2                	ld	s1,40(sp)
    8000428a:	7902                	ld	s2,32(sp)
    8000428c:	69e2                	ld	s3,24(sp)
    8000428e:	6a42                	ld	s4,16(sp)
    80004290:	6aa2                	ld	s5,8(sp)
    80004292:	6b02                	ld	s6,0(sp)
    80004294:	bf5d                	j	8000424a <ialloc+0x8c>

0000000080004296 <iupdate>:
{
    80004296:	1101                	addi	sp,sp,-32
    80004298:	ec06                	sd	ra,24(sp)
    8000429a:	e822                	sd	s0,16(sp)
    8000429c:	e426                	sd	s1,8(sp)
    8000429e:	e04a                	sd	s2,0(sp)
    800042a0:	1000                	addi	s0,sp,32
    800042a2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800042a4:	415c                	lw	a5,4(a0)
    800042a6:	0047d79b          	srliw	a5,a5,0x4
    800042aa:	00067597          	auipc	a1,0x67
    800042ae:	2865a583          	lw	a1,646(a1) # 8006b530 <sb+0x18>
    800042b2:	9dbd                	addw	a1,a1,a5
    800042b4:	4108                	lw	a0,0(a0)
    800042b6:	00000097          	auipc	ra,0x0
    800042ba:	89e080e7          	jalr	-1890(ra) # 80003b54 <bread>
    800042be:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800042c0:	05850793          	addi	a5,a0,88
    800042c4:	40d8                	lw	a4,4(s1)
    800042c6:	8b3d                	andi	a4,a4,15
    800042c8:	071a                	slli	a4,a4,0x6
    800042ca:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800042cc:	04449703          	lh	a4,68(s1)
    800042d0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800042d4:	04649703          	lh	a4,70(s1)
    800042d8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800042dc:	04849703          	lh	a4,72(s1)
    800042e0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800042e4:	04a49703          	lh	a4,74(s1)
    800042e8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800042ec:	44f8                	lw	a4,76(s1)
    800042ee:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800042f0:	03400613          	li	a2,52
    800042f4:	05048593          	addi	a1,s1,80
    800042f8:	00c78513          	addi	a0,a5,12
    800042fc:	ffffd097          	auipc	ra,0xffffd
    80004300:	b76080e7          	jalr	-1162(ra) # 80000e72 <memmove>
  log_write(bp);
    80004304:	854a                	mv	a0,s2
    80004306:	00001097          	auipc	ra,0x1
    8000430a:	c24080e7          	jalr	-988(ra) # 80004f2a <log_write>
  brelse(bp);
    8000430e:	854a                	mv	a0,s2
    80004310:	00000097          	auipc	ra,0x0
    80004314:	974080e7          	jalr	-1676(ra) # 80003c84 <brelse>
}
    80004318:	60e2                	ld	ra,24(sp)
    8000431a:	6442                	ld	s0,16(sp)
    8000431c:	64a2                	ld	s1,8(sp)
    8000431e:	6902                	ld	s2,0(sp)
    80004320:	6105                	addi	sp,sp,32
    80004322:	8082                	ret

0000000080004324 <idup>:
{
    80004324:	1101                	addi	sp,sp,-32
    80004326:	ec06                	sd	ra,24(sp)
    80004328:	e822                	sd	s0,16(sp)
    8000432a:	e426                	sd	s1,8(sp)
    8000432c:	1000                	addi	s0,sp,32
    8000432e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004330:	00067517          	auipc	a0,0x67
    80004334:	20850513          	addi	a0,a0,520 # 8006b538 <itable>
    80004338:	ffffd097          	auipc	ra,0xffffd
    8000433c:	9de080e7          	jalr	-1570(ra) # 80000d16 <acquire>
  ip->ref++;
    80004340:	449c                	lw	a5,8(s1)
    80004342:	2785                	addiw	a5,a5,1
    80004344:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004346:	00067517          	auipc	a0,0x67
    8000434a:	1f250513          	addi	a0,a0,498 # 8006b538 <itable>
    8000434e:	ffffd097          	auipc	ra,0xffffd
    80004352:	a78080e7          	jalr	-1416(ra) # 80000dc6 <release>
}
    80004356:	8526                	mv	a0,s1
    80004358:	60e2                	ld	ra,24(sp)
    8000435a:	6442                	ld	s0,16(sp)
    8000435c:	64a2                	ld	s1,8(sp)
    8000435e:	6105                	addi	sp,sp,32
    80004360:	8082                	ret

0000000080004362 <ilock>:
{
    80004362:	1101                	addi	sp,sp,-32
    80004364:	ec06                	sd	ra,24(sp)
    80004366:	e822                	sd	s0,16(sp)
    80004368:	e426                	sd	s1,8(sp)
    8000436a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000436c:	c10d                	beqz	a0,8000438e <ilock+0x2c>
    8000436e:	84aa                	mv	s1,a0
    80004370:	451c                	lw	a5,8(a0)
    80004372:	00f05e63          	blez	a5,8000438e <ilock+0x2c>
  acquiresleep(&ip->lock);
    80004376:	0541                	addi	a0,a0,16
    80004378:	00001097          	auipc	ra,0x1
    8000437c:	cd0080e7          	jalr	-816(ra) # 80005048 <acquiresleep>
  if(ip->valid == 0){
    80004380:	40bc                	lw	a5,64(s1)
    80004382:	cf99                	beqz	a5,800043a0 <ilock+0x3e>
}
    80004384:	60e2                	ld	ra,24(sp)
    80004386:	6442                	ld	s0,16(sp)
    80004388:	64a2                	ld	s1,8(sp)
    8000438a:	6105                	addi	sp,sp,32
    8000438c:	8082                	ret
    8000438e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80004390:	00005517          	auipc	a0,0x5
    80004394:	21850513          	addi	a0,a0,536 # 800095a8 <etext+0x5a8>
    80004398:	ffffc097          	auipc	ra,0xffffc
    8000439c:	1c8080e7          	jalr	456(ra) # 80000560 <panic>
    800043a0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800043a2:	40dc                	lw	a5,4(s1)
    800043a4:	0047d79b          	srliw	a5,a5,0x4
    800043a8:	00067597          	auipc	a1,0x67
    800043ac:	1885a583          	lw	a1,392(a1) # 8006b530 <sb+0x18>
    800043b0:	9dbd                	addw	a1,a1,a5
    800043b2:	4088                	lw	a0,0(s1)
    800043b4:	fffff097          	auipc	ra,0xfffff
    800043b8:	7a0080e7          	jalr	1952(ra) # 80003b54 <bread>
    800043bc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800043be:	05850593          	addi	a1,a0,88
    800043c2:	40dc                	lw	a5,4(s1)
    800043c4:	8bbd                	andi	a5,a5,15
    800043c6:	079a                	slli	a5,a5,0x6
    800043c8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800043ca:	00059783          	lh	a5,0(a1)
    800043ce:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800043d2:	00259783          	lh	a5,2(a1)
    800043d6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800043da:	00459783          	lh	a5,4(a1)
    800043de:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800043e2:	00659783          	lh	a5,6(a1)
    800043e6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800043ea:	459c                	lw	a5,8(a1)
    800043ec:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800043ee:	03400613          	li	a2,52
    800043f2:	05b1                	addi	a1,a1,12
    800043f4:	05048513          	addi	a0,s1,80
    800043f8:	ffffd097          	auipc	ra,0xffffd
    800043fc:	a7a080e7          	jalr	-1414(ra) # 80000e72 <memmove>
    brelse(bp);
    80004400:	854a                	mv	a0,s2
    80004402:	00000097          	auipc	ra,0x0
    80004406:	882080e7          	jalr	-1918(ra) # 80003c84 <brelse>
    ip->valid = 1;
    8000440a:	4785                	li	a5,1
    8000440c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000440e:	04449783          	lh	a5,68(s1)
    80004412:	c399                	beqz	a5,80004418 <ilock+0xb6>
    80004414:	6902                	ld	s2,0(sp)
    80004416:	b7bd                	j	80004384 <ilock+0x22>
      panic("ilock: no type");
    80004418:	00005517          	auipc	a0,0x5
    8000441c:	19850513          	addi	a0,a0,408 # 800095b0 <etext+0x5b0>
    80004420:	ffffc097          	auipc	ra,0xffffc
    80004424:	140080e7          	jalr	320(ra) # 80000560 <panic>

0000000080004428 <iunlock>:
{
    80004428:	1101                	addi	sp,sp,-32
    8000442a:	ec06                	sd	ra,24(sp)
    8000442c:	e822                	sd	s0,16(sp)
    8000442e:	e426                	sd	s1,8(sp)
    80004430:	e04a                	sd	s2,0(sp)
    80004432:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004434:	c905                	beqz	a0,80004464 <iunlock+0x3c>
    80004436:	84aa                	mv	s1,a0
    80004438:	01050913          	addi	s2,a0,16
    8000443c:	854a                	mv	a0,s2
    8000443e:	00001097          	auipc	ra,0x1
    80004442:	ca4080e7          	jalr	-860(ra) # 800050e2 <holdingsleep>
    80004446:	cd19                	beqz	a0,80004464 <iunlock+0x3c>
    80004448:	449c                	lw	a5,8(s1)
    8000444a:	00f05d63          	blez	a5,80004464 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000444e:	854a                	mv	a0,s2
    80004450:	00001097          	auipc	ra,0x1
    80004454:	c4e080e7          	jalr	-946(ra) # 8000509e <releasesleep>
}
    80004458:	60e2                	ld	ra,24(sp)
    8000445a:	6442                	ld	s0,16(sp)
    8000445c:	64a2                	ld	s1,8(sp)
    8000445e:	6902                	ld	s2,0(sp)
    80004460:	6105                	addi	sp,sp,32
    80004462:	8082                	ret
    panic("iunlock");
    80004464:	00005517          	auipc	a0,0x5
    80004468:	15c50513          	addi	a0,a0,348 # 800095c0 <etext+0x5c0>
    8000446c:	ffffc097          	auipc	ra,0xffffc
    80004470:	0f4080e7          	jalr	244(ra) # 80000560 <panic>

0000000080004474 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004474:	7179                	addi	sp,sp,-48
    80004476:	f406                	sd	ra,40(sp)
    80004478:	f022                	sd	s0,32(sp)
    8000447a:	ec26                	sd	s1,24(sp)
    8000447c:	e84a                	sd	s2,16(sp)
    8000447e:	e44e                	sd	s3,8(sp)
    80004480:	1800                	addi	s0,sp,48
    80004482:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004484:	05050493          	addi	s1,a0,80
    80004488:	08050913          	addi	s2,a0,128
    8000448c:	a021                	j	80004494 <itrunc+0x20>
    8000448e:	0491                	addi	s1,s1,4
    80004490:	01248d63          	beq	s1,s2,800044aa <itrunc+0x36>
    if(ip->addrs[i]){
    80004494:	408c                	lw	a1,0(s1)
    80004496:	dde5                	beqz	a1,8000448e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80004498:	0009a503          	lw	a0,0(s3)
    8000449c:	00000097          	auipc	ra,0x0
    800044a0:	8f8080e7          	jalr	-1800(ra) # 80003d94 <bfree>
      ip->addrs[i] = 0;
    800044a4:	0004a023          	sw	zero,0(s1)
    800044a8:	b7dd                	j	8000448e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800044aa:	0809a583          	lw	a1,128(s3)
    800044ae:	ed99                	bnez	a1,800044cc <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800044b0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800044b4:	854e                	mv	a0,s3
    800044b6:	00000097          	auipc	ra,0x0
    800044ba:	de0080e7          	jalr	-544(ra) # 80004296 <iupdate>
}
    800044be:	70a2                	ld	ra,40(sp)
    800044c0:	7402                	ld	s0,32(sp)
    800044c2:	64e2                	ld	s1,24(sp)
    800044c4:	6942                	ld	s2,16(sp)
    800044c6:	69a2                	ld	s3,8(sp)
    800044c8:	6145                	addi	sp,sp,48
    800044ca:	8082                	ret
    800044cc:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800044ce:	0009a503          	lw	a0,0(s3)
    800044d2:	fffff097          	auipc	ra,0xfffff
    800044d6:	682080e7          	jalr	1666(ra) # 80003b54 <bread>
    800044da:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800044dc:	05850493          	addi	s1,a0,88
    800044e0:	45850913          	addi	s2,a0,1112
    800044e4:	a021                	j	800044ec <itrunc+0x78>
    800044e6:	0491                	addi	s1,s1,4
    800044e8:	01248b63          	beq	s1,s2,800044fe <itrunc+0x8a>
      if(a[j])
    800044ec:	408c                	lw	a1,0(s1)
    800044ee:	dde5                	beqz	a1,800044e6 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    800044f0:	0009a503          	lw	a0,0(s3)
    800044f4:	00000097          	auipc	ra,0x0
    800044f8:	8a0080e7          	jalr	-1888(ra) # 80003d94 <bfree>
    800044fc:	b7ed                	j	800044e6 <itrunc+0x72>
    brelse(bp);
    800044fe:	8552                	mv	a0,s4
    80004500:	fffff097          	auipc	ra,0xfffff
    80004504:	784080e7          	jalr	1924(ra) # 80003c84 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004508:	0809a583          	lw	a1,128(s3)
    8000450c:	0009a503          	lw	a0,0(s3)
    80004510:	00000097          	auipc	ra,0x0
    80004514:	884080e7          	jalr	-1916(ra) # 80003d94 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004518:	0809a023          	sw	zero,128(s3)
    8000451c:	6a02                	ld	s4,0(sp)
    8000451e:	bf49                	j	800044b0 <itrunc+0x3c>

0000000080004520 <iput>:
{
    80004520:	1101                	addi	sp,sp,-32
    80004522:	ec06                	sd	ra,24(sp)
    80004524:	e822                	sd	s0,16(sp)
    80004526:	e426                	sd	s1,8(sp)
    80004528:	1000                	addi	s0,sp,32
    8000452a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000452c:	00067517          	auipc	a0,0x67
    80004530:	00c50513          	addi	a0,a0,12 # 8006b538 <itable>
    80004534:	ffffc097          	auipc	ra,0xffffc
    80004538:	7e2080e7          	jalr	2018(ra) # 80000d16 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000453c:	4498                	lw	a4,8(s1)
    8000453e:	4785                	li	a5,1
    80004540:	02f70263          	beq	a4,a5,80004564 <iput+0x44>
  ip->ref--;
    80004544:	449c                	lw	a5,8(s1)
    80004546:	37fd                	addiw	a5,a5,-1
    80004548:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000454a:	00067517          	auipc	a0,0x67
    8000454e:	fee50513          	addi	a0,a0,-18 # 8006b538 <itable>
    80004552:	ffffd097          	auipc	ra,0xffffd
    80004556:	874080e7          	jalr	-1932(ra) # 80000dc6 <release>
}
    8000455a:	60e2                	ld	ra,24(sp)
    8000455c:	6442                	ld	s0,16(sp)
    8000455e:	64a2                	ld	s1,8(sp)
    80004560:	6105                	addi	sp,sp,32
    80004562:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004564:	40bc                	lw	a5,64(s1)
    80004566:	dff9                	beqz	a5,80004544 <iput+0x24>
    80004568:	04a49783          	lh	a5,74(s1)
    8000456c:	ffe1                	bnez	a5,80004544 <iput+0x24>
    8000456e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80004570:	01048913          	addi	s2,s1,16
    80004574:	854a                	mv	a0,s2
    80004576:	00001097          	auipc	ra,0x1
    8000457a:	ad2080e7          	jalr	-1326(ra) # 80005048 <acquiresleep>
    release(&itable.lock);
    8000457e:	00067517          	auipc	a0,0x67
    80004582:	fba50513          	addi	a0,a0,-70 # 8006b538 <itable>
    80004586:	ffffd097          	auipc	ra,0xffffd
    8000458a:	840080e7          	jalr	-1984(ra) # 80000dc6 <release>
    itrunc(ip);
    8000458e:	8526                	mv	a0,s1
    80004590:	00000097          	auipc	ra,0x0
    80004594:	ee4080e7          	jalr	-284(ra) # 80004474 <itrunc>
    ip->type = 0;
    80004598:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000459c:	8526                	mv	a0,s1
    8000459e:	00000097          	auipc	ra,0x0
    800045a2:	cf8080e7          	jalr	-776(ra) # 80004296 <iupdate>
    ip->valid = 0;
    800045a6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800045aa:	854a                	mv	a0,s2
    800045ac:	00001097          	auipc	ra,0x1
    800045b0:	af2080e7          	jalr	-1294(ra) # 8000509e <releasesleep>
    acquire(&itable.lock);
    800045b4:	00067517          	auipc	a0,0x67
    800045b8:	f8450513          	addi	a0,a0,-124 # 8006b538 <itable>
    800045bc:	ffffc097          	auipc	ra,0xffffc
    800045c0:	75a080e7          	jalr	1882(ra) # 80000d16 <acquire>
    800045c4:	6902                	ld	s2,0(sp)
    800045c6:	bfbd                	j	80004544 <iput+0x24>

00000000800045c8 <iunlockput>:
{
    800045c8:	1101                	addi	sp,sp,-32
    800045ca:	ec06                	sd	ra,24(sp)
    800045cc:	e822                	sd	s0,16(sp)
    800045ce:	e426                	sd	s1,8(sp)
    800045d0:	1000                	addi	s0,sp,32
    800045d2:	84aa                	mv	s1,a0
  iunlock(ip);
    800045d4:	00000097          	auipc	ra,0x0
    800045d8:	e54080e7          	jalr	-428(ra) # 80004428 <iunlock>
  iput(ip);
    800045dc:	8526                	mv	a0,s1
    800045de:	00000097          	auipc	ra,0x0
    800045e2:	f42080e7          	jalr	-190(ra) # 80004520 <iput>
}
    800045e6:	60e2                	ld	ra,24(sp)
    800045e8:	6442                	ld	s0,16(sp)
    800045ea:	64a2                	ld	s1,8(sp)
    800045ec:	6105                	addi	sp,sp,32
    800045ee:	8082                	ret

00000000800045f0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800045f0:	1141                	addi	sp,sp,-16
    800045f2:	e406                	sd	ra,8(sp)
    800045f4:	e022                	sd	s0,0(sp)
    800045f6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800045f8:	411c                	lw	a5,0(a0)
    800045fa:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800045fc:	415c                	lw	a5,4(a0)
    800045fe:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004600:	04451783          	lh	a5,68(a0)
    80004604:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004608:	04a51783          	lh	a5,74(a0)
    8000460c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004610:	04c56783          	lwu	a5,76(a0)
    80004614:	e99c                	sd	a5,16(a1)
}
    80004616:	60a2                	ld	ra,8(sp)
    80004618:	6402                	ld	s0,0(sp)
    8000461a:	0141                	addi	sp,sp,16
    8000461c:	8082                	ret

000000008000461e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000461e:	457c                	lw	a5,76(a0)
    80004620:	10d7e063          	bltu	a5,a3,80004720 <readi+0x102>
{
    80004624:	7159                	addi	sp,sp,-112
    80004626:	f486                	sd	ra,104(sp)
    80004628:	f0a2                	sd	s0,96(sp)
    8000462a:	eca6                	sd	s1,88(sp)
    8000462c:	e0d2                	sd	s4,64(sp)
    8000462e:	fc56                	sd	s5,56(sp)
    80004630:	f85a                	sd	s6,48(sp)
    80004632:	f45e                	sd	s7,40(sp)
    80004634:	1880                	addi	s0,sp,112
    80004636:	8b2a                	mv	s6,a0
    80004638:	8bae                	mv	s7,a1
    8000463a:	8a32                	mv	s4,a2
    8000463c:	84b6                	mv	s1,a3
    8000463e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004640:	9f35                	addw	a4,a4,a3
    return 0;
    80004642:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004644:	0cd76563          	bltu	a4,a3,8000470e <readi+0xf0>
    80004648:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000464a:	00e7f463          	bgeu	a5,a4,80004652 <readi+0x34>
    n = ip->size - off;
    8000464e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004652:	0a0a8563          	beqz	s5,800046fc <readi+0xde>
    80004656:	e8ca                	sd	s2,80(sp)
    80004658:	f062                	sd	s8,32(sp)
    8000465a:	ec66                	sd	s9,24(sp)
    8000465c:	e86a                	sd	s10,16(sp)
    8000465e:	e46e                	sd	s11,8(sp)
    80004660:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004662:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004666:	5c7d                	li	s8,-1
    80004668:	a82d                	j	800046a2 <readi+0x84>
    8000466a:	020d1d93          	slli	s11,s10,0x20
    8000466e:	020ddd93          	srli	s11,s11,0x20
    80004672:	05890613          	addi	a2,s2,88
    80004676:	86ee                	mv	a3,s11
    80004678:	963e                	add	a2,a2,a5
    8000467a:	85d2                	mv	a1,s4
    8000467c:	855e                	mv	a0,s7
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	86e080e7          	jalr	-1938(ra) # 80002eec <either_copyout>
    80004686:	05850963          	beq	a0,s8,800046d8 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000468a:	854a                	mv	a0,s2
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	5f8080e7          	jalr	1528(ra) # 80003c84 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004694:	013d09bb          	addw	s3,s10,s3
    80004698:	009d04bb          	addw	s1,s10,s1
    8000469c:	9a6e                	add	s4,s4,s11
    8000469e:	0559f963          	bgeu	s3,s5,800046f0 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    800046a2:	00a4d59b          	srliw	a1,s1,0xa
    800046a6:	855a                	mv	a0,s6
    800046a8:	00000097          	auipc	ra,0x0
    800046ac:	89e080e7          	jalr	-1890(ra) # 80003f46 <bmap>
    800046b0:	85aa                	mv	a1,a0
    if(addr == 0)
    800046b2:	c539                	beqz	a0,80004700 <readi+0xe2>
    bp = bread(ip->dev, addr);
    800046b4:	000b2503          	lw	a0,0(s6)
    800046b8:	fffff097          	auipc	ra,0xfffff
    800046bc:	49c080e7          	jalr	1180(ra) # 80003b54 <bread>
    800046c0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800046c2:	3ff4f793          	andi	a5,s1,1023
    800046c6:	40fc873b          	subw	a4,s9,a5
    800046ca:	413a86bb          	subw	a3,s5,s3
    800046ce:	8d3a                	mv	s10,a4
    800046d0:	f8e6fde3          	bgeu	a3,a4,8000466a <readi+0x4c>
    800046d4:	8d36                	mv	s10,a3
    800046d6:	bf51                	j	8000466a <readi+0x4c>
      brelse(bp);
    800046d8:	854a                	mv	a0,s2
    800046da:	fffff097          	auipc	ra,0xfffff
    800046de:	5aa080e7          	jalr	1450(ra) # 80003c84 <brelse>
      tot = -1;
    800046e2:	59fd                	li	s3,-1
      break;
    800046e4:	6946                	ld	s2,80(sp)
    800046e6:	7c02                	ld	s8,32(sp)
    800046e8:	6ce2                	ld	s9,24(sp)
    800046ea:	6d42                	ld	s10,16(sp)
    800046ec:	6da2                	ld	s11,8(sp)
    800046ee:	a831                	j	8000470a <readi+0xec>
    800046f0:	6946                	ld	s2,80(sp)
    800046f2:	7c02                	ld	s8,32(sp)
    800046f4:	6ce2                	ld	s9,24(sp)
    800046f6:	6d42                	ld	s10,16(sp)
    800046f8:	6da2                	ld	s11,8(sp)
    800046fa:	a801                	j	8000470a <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800046fc:	89d6                	mv	s3,s5
    800046fe:	a031                	j	8000470a <readi+0xec>
    80004700:	6946                	ld	s2,80(sp)
    80004702:	7c02                	ld	s8,32(sp)
    80004704:	6ce2                	ld	s9,24(sp)
    80004706:	6d42                	ld	s10,16(sp)
    80004708:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000470a:	854e                	mv	a0,s3
    8000470c:	69a6                	ld	s3,72(sp)
}
    8000470e:	70a6                	ld	ra,104(sp)
    80004710:	7406                	ld	s0,96(sp)
    80004712:	64e6                	ld	s1,88(sp)
    80004714:	6a06                	ld	s4,64(sp)
    80004716:	7ae2                	ld	s5,56(sp)
    80004718:	7b42                	ld	s6,48(sp)
    8000471a:	7ba2                	ld	s7,40(sp)
    8000471c:	6165                	addi	sp,sp,112
    8000471e:	8082                	ret
    return 0;
    80004720:	4501                	li	a0,0
}
    80004722:	8082                	ret

0000000080004724 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004724:	457c                	lw	a5,76(a0)
    80004726:	10d7e963          	bltu	a5,a3,80004838 <writei+0x114>
{
    8000472a:	7159                	addi	sp,sp,-112
    8000472c:	f486                	sd	ra,104(sp)
    8000472e:	f0a2                	sd	s0,96(sp)
    80004730:	e8ca                	sd	s2,80(sp)
    80004732:	e0d2                	sd	s4,64(sp)
    80004734:	fc56                	sd	s5,56(sp)
    80004736:	f85a                	sd	s6,48(sp)
    80004738:	f45e                	sd	s7,40(sp)
    8000473a:	1880                	addi	s0,sp,112
    8000473c:	8aaa                	mv	s5,a0
    8000473e:	8bae                	mv	s7,a1
    80004740:	8a32                	mv	s4,a2
    80004742:	8936                	mv	s2,a3
    80004744:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004746:	00e687bb          	addw	a5,a3,a4
    8000474a:	0ed7e963          	bltu	a5,a3,8000483c <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000474e:	00043737          	lui	a4,0x43
    80004752:	0ef76763          	bltu	a4,a5,80004840 <writei+0x11c>
    80004756:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004758:	0c0b0863          	beqz	s6,80004828 <writei+0x104>
    8000475c:	eca6                	sd	s1,88(sp)
    8000475e:	f062                	sd	s8,32(sp)
    80004760:	ec66                	sd	s9,24(sp)
    80004762:	e86a                	sd	s10,16(sp)
    80004764:	e46e                	sd	s11,8(sp)
    80004766:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004768:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000476c:	5c7d                	li	s8,-1
    8000476e:	a091                	j	800047b2 <writei+0x8e>
    80004770:	020d1d93          	slli	s11,s10,0x20
    80004774:	020ddd93          	srli	s11,s11,0x20
    80004778:	05848513          	addi	a0,s1,88
    8000477c:	86ee                	mv	a3,s11
    8000477e:	8652                	mv	a2,s4
    80004780:	85de                	mv	a1,s7
    80004782:	953e                	add	a0,a0,a5
    80004784:	ffffe097          	auipc	ra,0xffffe
    80004788:	7be080e7          	jalr	1982(ra) # 80002f42 <either_copyin>
    8000478c:	05850e63          	beq	a0,s8,800047e8 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004790:	8526                	mv	a0,s1
    80004792:	00000097          	auipc	ra,0x0
    80004796:	798080e7          	jalr	1944(ra) # 80004f2a <log_write>
    brelse(bp);
    8000479a:	8526                	mv	a0,s1
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	4e8080e7          	jalr	1256(ra) # 80003c84 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800047a4:	013d09bb          	addw	s3,s10,s3
    800047a8:	012d093b          	addw	s2,s10,s2
    800047ac:	9a6e                	add	s4,s4,s11
    800047ae:	0569f263          	bgeu	s3,s6,800047f2 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800047b2:	00a9559b          	srliw	a1,s2,0xa
    800047b6:	8556                	mv	a0,s5
    800047b8:	fffff097          	auipc	ra,0xfffff
    800047bc:	78e080e7          	jalr	1934(ra) # 80003f46 <bmap>
    800047c0:	85aa                	mv	a1,a0
    if(addr == 0)
    800047c2:	c905                	beqz	a0,800047f2 <writei+0xce>
    bp = bread(ip->dev, addr);
    800047c4:	000aa503          	lw	a0,0(s5)
    800047c8:	fffff097          	auipc	ra,0xfffff
    800047cc:	38c080e7          	jalr	908(ra) # 80003b54 <bread>
    800047d0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800047d2:	3ff97793          	andi	a5,s2,1023
    800047d6:	40fc873b          	subw	a4,s9,a5
    800047da:	413b06bb          	subw	a3,s6,s3
    800047de:	8d3a                	mv	s10,a4
    800047e0:	f8e6f8e3          	bgeu	a3,a4,80004770 <writei+0x4c>
    800047e4:	8d36                	mv	s10,a3
    800047e6:	b769                	j	80004770 <writei+0x4c>
      brelse(bp);
    800047e8:	8526                	mv	a0,s1
    800047ea:	fffff097          	auipc	ra,0xfffff
    800047ee:	49a080e7          	jalr	1178(ra) # 80003c84 <brelse>
  }

  if(off > ip->size)
    800047f2:	04caa783          	lw	a5,76(s5)
    800047f6:	0327fb63          	bgeu	a5,s2,8000482c <writei+0x108>
    ip->size = off;
    800047fa:	052aa623          	sw	s2,76(s5)
    800047fe:	64e6                	ld	s1,88(sp)
    80004800:	7c02                	ld	s8,32(sp)
    80004802:	6ce2                	ld	s9,24(sp)
    80004804:	6d42                	ld	s10,16(sp)
    80004806:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004808:	8556                	mv	a0,s5
    8000480a:	00000097          	auipc	ra,0x0
    8000480e:	a8c080e7          	jalr	-1396(ra) # 80004296 <iupdate>

  return tot;
    80004812:	854e                	mv	a0,s3
    80004814:	69a6                	ld	s3,72(sp)
}
    80004816:	70a6                	ld	ra,104(sp)
    80004818:	7406                	ld	s0,96(sp)
    8000481a:	6946                	ld	s2,80(sp)
    8000481c:	6a06                	ld	s4,64(sp)
    8000481e:	7ae2                	ld	s5,56(sp)
    80004820:	7b42                	ld	s6,48(sp)
    80004822:	7ba2                	ld	s7,40(sp)
    80004824:	6165                	addi	sp,sp,112
    80004826:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004828:	89da                	mv	s3,s6
    8000482a:	bff9                	j	80004808 <writei+0xe4>
    8000482c:	64e6                	ld	s1,88(sp)
    8000482e:	7c02                	ld	s8,32(sp)
    80004830:	6ce2                	ld	s9,24(sp)
    80004832:	6d42                	ld	s10,16(sp)
    80004834:	6da2                	ld	s11,8(sp)
    80004836:	bfc9                	j	80004808 <writei+0xe4>
    return -1;
    80004838:	557d                	li	a0,-1
}
    8000483a:	8082                	ret
    return -1;
    8000483c:	557d                	li	a0,-1
    8000483e:	bfe1                	j	80004816 <writei+0xf2>
    return -1;
    80004840:	557d                	li	a0,-1
    80004842:	bfd1                	j	80004816 <writei+0xf2>

0000000080004844 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004844:	1141                	addi	sp,sp,-16
    80004846:	e406                	sd	ra,8(sp)
    80004848:	e022                	sd	s0,0(sp)
    8000484a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000484c:	4639                	li	a2,14
    8000484e:	ffffc097          	auipc	ra,0xffffc
    80004852:	69c080e7          	jalr	1692(ra) # 80000eea <strncmp>
}
    80004856:	60a2                	ld	ra,8(sp)
    80004858:	6402                	ld	s0,0(sp)
    8000485a:	0141                	addi	sp,sp,16
    8000485c:	8082                	ret

000000008000485e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000485e:	711d                	addi	sp,sp,-96
    80004860:	ec86                	sd	ra,88(sp)
    80004862:	e8a2                	sd	s0,80(sp)
    80004864:	e4a6                	sd	s1,72(sp)
    80004866:	e0ca                	sd	s2,64(sp)
    80004868:	fc4e                	sd	s3,56(sp)
    8000486a:	f852                	sd	s4,48(sp)
    8000486c:	f456                	sd	s5,40(sp)
    8000486e:	f05a                	sd	s6,32(sp)
    80004870:	ec5e                	sd	s7,24(sp)
    80004872:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004874:	04451703          	lh	a4,68(a0)
    80004878:	4785                	li	a5,1
    8000487a:	00f71f63          	bne	a4,a5,80004898 <dirlookup+0x3a>
    8000487e:	892a                	mv	s2,a0
    80004880:	8aae                	mv	s5,a1
    80004882:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004884:	457c                	lw	a5,76(a0)
    80004886:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004888:	fa040a13          	addi	s4,s0,-96
    8000488c:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000488e:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004892:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004894:	e79d                	bnez	a5,800048c2 <dirlookup+0x64>
    80004896:	a88d                	j	80004908 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80004898:	00005517          	auipc	a0,0x5
    8000489c:	d3050513          	addi	a0,a0,-720 # 800095c8 <etext+0x5c8>
    800048a0:	ffffc097          	auipc	ra,0xffffc
    800048a4:	cc0080e7          	jalr	-832(ra) # 80000560 <panic>
      panic("dirlookup read");
    800048a8:	00005517          	auipc	a0,0x5
    800048ac:	d3850513          	addi	a0,a0,-712 # 800095e0 <etext+0x5e0>
    800048b0:	ffffc097          	auipc	ra,0xffffc
    800048b4:	cb0080e7          	jalr	-848(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800048b8:	24c1                	addiw	s1,s1,16
    800048ba:	04c92783          	lw	a5,76(s2)
    800048be:	04f4f463          	bgeu	s1,a5,80004906 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800048c2:	874e                	mv	a4,s3
    800048c4:	86a6                	mv	a3,s1
    800048c6:	8652                	mv	a2,s4
    800048c8:	4581                	li	a1,0
    800048ca:	854a                	mv	a0,s2
    800048cc:	00000097          	auipc	ra,0x0
    800048d0:	d52080e7          	jalr	-686(ra) # 8000461e <readi>
    800048d4:	fd351ae3          	bne	a0,s3,800048a8 <dirlookup+0x4a>
    if(de.inum == 0)
    800048d8:	fa045783          	lhu	a5,-96(s0)
    800048dc:	dff1                	beqz	a5,800048b8 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    800048de:	85da                	mv	a1,s6
    800048e0:	8556                	mv	a0,s5
    800048e2:	00000097          	auipc	ra,0x0
    800048e6:	f62080e7          	jalr	-158(ra) # 80004844 <namecmp>
    800048ea:	f579                	bnez	a0,800048b8 <dirlookup+0x5a>
      if(poff)
    800048ec:	000b8463          	beqz	s7,800048f4 <dirlookup+0x96>
        *poff = off;
    800048f0:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800048f4:	fa045583          	lhu	a1,-96(s0)
    800048f8:	00092503          	lw	a0,0(s2)
    800048fc:	fffff097          	auipc	ra,0xfffff
    80004900:	726080e7          	jalr	1830(ra) # 80004022 <iget>
    80004904:	a011                	j	80004908 <dirlookup+0xaa>
  return 0;
    80004906:	4501                	li	a0,0
}
    80004908:	60e6                	ld	ra,88(sp)
    8000490a:	6446                	ld	s0,80(sp)
    8000490c:	64a6                	ld	s1,72(sp)
    8000490e:	6906                	ld	s2,64(sp)
    80004910:	79e2                	ld	s3,56(sp)
    80004912:	7a42                	ld	s4,48(sp)
    80004914:	7aa2                	ld	s5,40(sp)
    80004916:	7b02                	ld	s6,32(sp)
    80004918:	6be2                	ld	s7,24(sp)
    8000491a:	6125                	addi	sp,sp,96
    8000491c:	8082                	ret

000000008000491e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000491e:	711d                	addi	sp,sp,-96
    80004920:	ec86                	sd	ra,88(sp)
    80004922:	e8a2                	sd	s0,80(sp)
    80004924:	e4a6                	sd	s1,72(sp)
    80004926:	e0ca                	sd	s2,64(sp)
    80004928:	fc4e                	sd	s3,56(sp)
    8000492a:	f852                	sd	s4,48(sp)
    8000492c:	f456                	sd	s5,40(sp)
    8000492e:	f05a                	sd	s6,32(sp)
    80004930:	ec5e                	sd	s7,24(sp)
    80004932:	e862                	sd	s8,16(sp)
    80004934:	e466                	sd	s9,8(sp)
    80004936:	e06a                	sd	s10,0(sp)
    80004938:	1080                	addi	s0,sp,96
    8000493a:	84aa                	mv	s1,a0
    8000493c:	8b2e                	mv	s6,a1
    8000493e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004940:	00054703          	lbu	a4,0(a0)
    80004944:	02f00793          	li	a5,47
    80004948:	02f70363          	beq	a4,a5,8000496e <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000494c:	ffffd097          	auipc	ra,0xffffd
    80004950:	5d6080e7          	jalr	1494(ra) # 80001f22 <myproc>
    80004954:	15053503          	ld	a0,336(a0)
    80004958:	00000097          	auipc	ra,0x0
    8000495c:	9cc080e7          	jalr	-1588(ra) # 80004324 <idup>
    80004960:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004962:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004966:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004968:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000496a:	4b85                	li	s7,1
    8000496c:	a87d                	j	80004a2a <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000496e:	4585                	li	a1,1
    80004970:	852e                	mv	a0,a1
    80004972:	fffff097          	auipc	ra,0xfffff
    80004976:	6b0080e7          	jalr	1712(ra) # 80004022 <iget>
    8000497a:	8a2a                	mv	s4,a0
    8000497c:	b7dd                	j	80004962 <namex+0x44>
      iunlockput(ip);
    8000497e:	8552                	mv	a0,s4
    80004980:	00000097          	auipc	ra,0x0
    80004984:	c48080e7          	jalr	-952(ra) # 800045c8 <iunlockput>
      return 0;
    80004988:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000498a:	8552                	mv	a0,s4
    8000498c:	60e6                	ld	ra,88(sp)
    8000498e:	6446                	ld	s0,80(sp)
    80004990:	64a6                	ld	s1,72(sp)
    80004992:	6906                	ld	s2,64(sp)
    80004994:	79e2                	ld	s3,56(sp)
    80004996:	7a42                	ld	s4,48(sp)
    80004998:	7aa2                	ld	s5,40(sp)
    8000499a:	7b02                	ld	s6,32(sp)
    8000499c:	6be2                	ld	s7,24(sp)
    8000499e:	6c42                	ld	s8,16(sp)
    800049a0:	6ca2                	ld	s9,8(sp)
    800049a2:	6d02                	ld	s10,0(sp)
    800049a4:	6125                	addi	sp,sp,96
    800049a6:	8082                	ret
      iunlock(ip);
    800049a8:	8552                	mv	a0,s4
    800049aa:	00000097          	auipc	ra,0x0
    800049ae:	a7e080e7          	jalr	-1410(ra) # 80004428 <iunlock>
      return ip;
    800049b2:	bfe1                	j	8000498a <namex+0x6c>
      iunlockput(ip);
    800049b4:	8552                	mv	a0,s4
    800049b6:	00000097          	auipc	ra,0x0
    800049ba:	c12080e7          	jalr	-1006(ra) # 800045c8 <iunlockput>
      return 0;
    800049be:	8a4e                	mv	s4,s3
    800049c0:	b7e9                	j	8000498a <namex+0x6c>
  len = path - s;
    800049c2:	40998633          	sub	a2,s3,s1
    800049c6:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800049ca:	09ac5863          	bge	s8,s10,80004a5a <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800049ce:	8666                	mv	a2,s9
    800049d0:	85a6                	mv	a1,s1
    800049d2:	8556                	mv	a0,s5
    800049d4:	ffffc097          	auipc	ra,0xffffc
    800049d8:	49e080e7          	jalr	1182(ra) # 80000e72 <memmove>
    800049dc:	84ce                	mv	s1,s3
  while(*path == '/')
    800049de:	0004c783          	lbu	a5,0(s1)
    800049e2:	01279763          	bne	a5,s2,800049f0 <namex+0xd2>
    path++;
    800049e6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800049e8:	0004c783          	lbu	a5,0(s1)
    800049ec:	ff278de3          	beq	a5,s2,800049e6 <namex+0xc8>
    ilock(ip);
    800049f0:	8552                	mv	a0,s4
    800049f2:	00000097          	auipc	ra,0x0
    800049f6:	970080e7          	jalr	-1680(ra) # 80004362 <ilock>
    if(ip->type != T_DIR){
    800049fa:	044a1783          	lh	a5,68(s4)
    800049fe:	f97790e3          	bne	a5,s7,8000497e <namex+0x60>
    if(nameiparent && *path == '\0'){
    80004a02:	000b0563          	beqz	s6,80004a0c <namex+0xee>
    80004a06:	0004c783          	lbu	a5,0(s1)
    80004a0a:	dfd9                	beqz	a5,800049a8 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004a0c:	4601                	li	a2,0
    80004a0e:	85d6                	mv	a1,s5
    80004a10:	8552                	mv	a0,s4
    80004a12:	00000097          	auipc	ra,0x0
    80004a16:	e4c080e7          	jalr	-436(ra) # 8000485e <dirlookup>
    80004a1a:	89aa                	mv	s3,a0
    80004a1c:	dd41                	beqz	a0,800049b4 <namex+0x96>
    iunlockput(ip);
    80004a1e:	8552                	mv	a0,s4
    80004a20:	00000097          	auipc	ra,0x0
    80004a24:	ba8080e7          	jalr	-1112(ra) # 800045c8 <iunlockput>
    ip = next;
    80004a28:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004a2a:	0004c783          	lbu	a5,0(s1)
    80004a2e:	01279763          	bne	a5,s2,80004a3c <namex+0x11e>
    path++;
    80004a32:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004a34:	0004c783          	lbu	a5,0(s1)
    80004a38:	ff278de3          	beq	a5,s2,80004a32 <namex+0x114>
  if(*path == 0)
    80004a3c:	cb9d                	beqz	a5,80004a72 <namex+0x154>
  while(*path != '/' && *path != 0)
    80004a3e:	0004c783          	lbu	a5,0(s1)
    80004a42:	89a6                	mv	s3,s1
  len = path - s;
    80004a44:	4d01                	li	s10,0
    80004a46:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004a48:	01278963          	beq	a5,s2,80004a5a <namex+0x13c>
    80004a4c:	dbbd                	beqz	a5,800049c2 <namex+0xa4>
    path++;
    80004a4e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004a50:	0009c783          	lbu	a5,0(s3)
    80004a54:	ff279ce3          	bne	a5,s2,80004a4c <namex+0x12e>
    80004a58:	b7ad                	j	800049c2 <namex+0xa4>
    memmove(name, s, len);
    80004a5a:	2601                	sext.w	a2,a2
    80004a5c:	85a6                	mv	a1,s1
    80004a5e:	8556                	mv	a0,s5
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	412080e7          	jalr	1042(ra) # 80000e72 <memmove>
    name[len] = 0;
    80004a68:	9d56                	add	s10,s10,s5
    80004a6a:	000d0023          	sb	zero,0(s10)
    80004a6e:	84ce                	mv	s1,s3
    80004a70:	b7bd                	j	800049de <namex+0xc0>
  if(nameiparent){
    80004a72:	f00b0ce3          	beqz	s6,8000498a <namex+0x6c>
    iput(ip);
    80004a76:	8552                	mv	a0,s4
    80004a78:	00000097          	auipc	ra,0x0
    80004a7c:	aa8080e7          	jalr	-1368(ra) # 80004520 <iput>
    return 0;
    80004a80:	4a01                	li	s4,0
    80004a82:	b721                	j	8000498a <namex+0x6c>

0000000080004a84 <dirlink>:
{
    80004a84:	715d                	addi	sp,sp,-80
    80004a86:	e486                	sd	ra,72(sp)
    80004a88:	e0a2                	sd	s0,64(sp)
    80004a8a:	f84a                	sd	s2,48(sp)
    80004a8c:	ec56                	sd	s5,24(sp)
    80004a8e:	e85a                	sd	s6,16(sp)
    80004a90:	0880                	addi	s0,sp,80
    80004a92:	892a                	mv	s2,a0
    80004a94:	8aae                	mv	s5,a1
    80004a96:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004a98:	4601                	li	a2,0
    80004a9a:	00000097          	auipc	ra,0x0
    80004a9e:	dc4080e7          	jalr	-572(ra) # 8000485e <dirlookup>
    80004aa2:	e129                	bnez	a0,80004ae4 <dirlink+0x60>
    80004aa4:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004aa6:	04c92483          	lw	s1,76(s2)
    80004aaa:	cca9                	beqz	s1,80004b04 <dirlink+0x80>
    80004aac:	f44e                	sd	s3,40(sp)
    80004aae:	f052                	sd	s4,32(sp)
    80004ab0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ab2:	fb040a13          	addi	s4,s0,-80
    80004ab6:	49c1                	li	s3,16
    80004ab8:	874e                	mv	a4,s3
    80004aba:	86a6                	mv	a3,s1
    80004abc:	8652                	mv	a2,s4
    80004abe:	4581                	li	a1,0
    80004ac0:	854a                	mv	a0,s2
    80004ac2:	00000097          	auipc	ra,0x0
    80004ac6:	b5c080e7          	jalr	-1188(ra) # 8000461e <readi>
    80004aca:	03351363          	bne	a0,s3,80004af0 <dirlink+0x6c>
    if(de.inum == 0)
    80004ace:	fb045783          	lhu	a5,-80(s0)
    80004ad2:	c79d                	beqz	a5,80004b00 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004ad4:	24c1                	addiw	s1,s1,16
    80004ad6:	04c92783          	lw	a5,76(s2)
    80004ada:	fcf4efe3          	bltu	s1,a5,80004ab8 <dirlink+0x34>
    80004ade:	79a2                	ld	s3,40(sp)
    80004ae0:	7a02                	ld	s4,32(sp)
    80004ae2:	a00d                	j	80004b04 <dirlink+0x80>
    iput(ip);
    80004ae4:	00000097          	auipc	ra,0x0
    80004ae8:	a3c080e7          	jalr	-1476(ra) # 80004520 <iput>
    return -1;
    80004aec:	557d                	li	a0,-1
    80004aee:	a0a9                	j	80004b38 <dirlink+0xb4>
      panic("dirlink read");
    80004af0:	00005517          	auipc	a0,0x5
    80004af4:	b0050513          	addi	a0,a0,-1280 # 800095f0 <etext+0x5f0>
    80004af8:	ffffc097          	auipc	ra,0xffffc
    80004afc:	a68080e7          	jalr	-1432(ra) # 80000560 <panic>
    80004b00:	79a2                	ld	s3,40(sp)
    80004b02:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004b04:	4639                	li	a2,14
    80004b06:	85d6                	mv	a1,s5
    80004b08:	fb240513          	addi	a0,s0,-78
    80004b0c:	ffffc097          	auipc	ra,0xffffc
    80004b10:	418080e7          	jalr	1048(ra) # 80000f24 <strncpy>
  de.inum = inum;
    80004b14:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b18:	4741                	li	a4,16
    80004b1a:	86a6                	mv	a3,s1
    80004b1c:	fb040613          	addi	a2,s0,-80
    80004b20:	4581                	li	a1,0
    80004b22:	854a                	mv	a0,s2
    80004b24:	00000097          	auipc	ra,0x0
    80004b28:	c00080e7          	jalr	-1024(ra) # 80004724 <writei>
    80004b2c:	1541                	addi	a0,a0,-16
    80004b2e:	00a03533          	snez	a0,a0
    80004b32:	40a0053b          	negw	a0,a0
    80004b36:	74e2                	ld	s1,56(sp)
}
    80004b38:	60a6                	ld	ra,72(sp)
    80004b3a:	6406                	ld	s0,64(sp)
    80004b3c:	7942                	ld	s2,48(sp)
    80004b3e:	6ae2                	ld	s5,24(sp)
    80004b40:	6b42                	ld	s6,16(sp)
    80004b42:	6161                	addi	sp,sp,80
    80004b44:	8082                	ret

0000000080004b46 <namei>:

struct inode*
namei(char *path)
{
    80004b46:	1101                	addi	sp,sp,-32
    80004b48:	ec06                	sd	ra,24(sp)
    80004b4a:	e822                	sd	s0,16(sp)
    80004b4c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004b4e:	fe040613          	addi	a2,s0,-32
    80004b52:	4581                	li	a1,0
    80004b54:	00000097          	auipc	ra,0x0
    80004b58:	dca080e7          	jalr	-566(ra) # 8000491e <namex>
}
    80004b5c:	60e2                	ld	ra,24(sp)
    80004b5e:	6442                	ld	s0,16(sp)
    80004b60:	6105                	addi	sp,sp,32
    80004b62:	8082                	ret

0000000080004b64 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004b64:	1141                	addi	sp,sp,-16
    80004b66:	e406                	sd	ra,8(sp)
    80004b68:	e022                	sd	s0,0(sp)
    80004b6a:	0800                	addi	s0,sp,16
    80004b6c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004b6e:	4585                	li	a1,1
    80004b70:	00000097          	auipc	ra,0x0
    80004b74:	dae080e7          	jalr	-594(ra) # 8000491e <namex>
}
    80004b78:	60a2                	ld	ra,8(sp)
    80004b7a:	6402                	ld	s0,0(sp)
    80004b7c:	0141                	addi	sp,sp,16
    80004b7e:	8082                	ret

0000000080004b80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004b80:	1101                	addi	sp,sp,-32
    80004b82:	ec06                	sd	ra,24(sp)
    80004b84:	e822                	sd	s0,16(sp)
    80004b86:	e426                	sd	s1,8(sp)
    80004b88:	e04a                	sd	s2,0(sp)
    80004b8a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004b8c:	00068917          	auipc	s2,0x68
    80004b90:	45490913          	addi	s2,s2,1108 # 8006cfe0 <log>
    80004b94:	01892583          	lw	a1,24(s2)
    80004b98:	02892503          	lw	a0,40(s2)
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	fb8080e7          	jalr	-72(ra) # 80003b54 <bread>
    80004ba4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004ba6:	02c92603          	lw	a2,44(s2)
    80004baa:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004bac:	00c05f63          	blez	a2,80004bca <write_head+0x4a>
    80004bb0:	00068717          	auipc	a4,0x68
    80004bb4:	46070713          	addi	a4,a4,1120 # 8006d010 <log+0x30>
    80004bb8:	87aa                	mv	a5,a0
    80004bba:	060a                	slli	a2,a2,0x2
    80004bbc:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004bbe:	4314                	lw	a3,0(a4)
    80004bc0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004bc2:	0711                	addi	a4,a4,4
    80004bc4:	0791                	addi	a5,a5,4
    80004bc6:	fec79ce3          	bne	a5,a2,80004bbe <write_head+0x3e>
  }
  bwrite(buf);
    80004bca:	8526                	mv	a0,s1
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	07a080e7          	jalr	122(ra) # 80003c46 <bwrite>
  brelse(buf);
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	0ae080e7          	jalr	174(ra) # 80003c84 <brelse>
}
    80004bde:	60e2                	ld	ra,24(sp)
    80004be0:	6442                	ld	s0,16(sp)
    80004be2:	64a2                	ld	s1,8(sp)
    80004be4:	6902                	ld	s2,0(sp)
    80004be6:	6105                	addi	sp,sp,32
    80004be8:	8082                	ret

0000000080004bea <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004bea:	00068797          	auipc	a5,0x68
    80004bee:	4227a783          	lw	a5,1058(a5) # 8006d00c <log+0x2c>
    80004bf2:	0cf05063          	blez	a5,80004cb2 <install_trans+0xc8>
{
    80004bf6:	715d                	addi	sp,sp,-80
    80004bf8:	e486                	sd	ra,72(sp)
    80004bfa:	e0a2                	sd	s0,64(sp)
    80004bfc:	fc26                	sd	s1,56(sp)
    80004bfe:	f84a                	sd	s2,48(sp)
    80004c00:	f44e                	sd	s3,40(sp)
    80004c02:	f052                	sd	s4,32(sp)
    80004c04:	ec56                	sd	s5,24(sp)
    80004c06:	e85a                	sd	s6,16(sp)
    80004c08:	e45e                	sd	s7,8(sp)
    80004c0a:	0880                	addi	s0,sp,80
    80004c0c:	8b2a                	mv	s6,a0
    80004c0e:	00068a97          	auipc	s5,0x68
    80004c12:	402a8a93          	addi	s5,s5,1026 # 8006d010 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004c16:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004c18:	00068997          	auipc	s3,0x68
    80004c1c:	3c898993          	addi	s3,s3,968 # 8006cfe0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004c20:	40000b93          	li	s7,1024
    80004c24:	a00d                	j	80004c46 <install_trans+0x5c>
    brelse(lbuf);
    80004c26:	854a                	mv	a0,s2
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	05c080e7          	jalr	92(ra) # 80003c84 <brelse>
    brelse(dbuf);
    80004c30:	8526                	mv	a0,s1
    80004c32:	fffff097          	auipc	ra,0xfffff
    80004c36:	052080e7          	jalr	82(ra) # 80003c84 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004c3a:	2a05                	addiw	s4,s4,1
    80004c3c:	0a91                	addi	s5,s5,4
    80004c3e:	02c9a783          	lw	a5,44(s3)
    80004c42:	04fa5d63          	bge	s4,a5,80004c9c <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004c46:	0189a583          	lw	a1,24(s3)
    80004c4a:	014585bb          	addw	a1,a1,s4
    80004c4e:	2585                	addiw	a1,a1,1
    80004c50:	0289a503          	lw	a0,40(s3)
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	f00080e7          	jalr	-256(ra) # 80003b54 <bread>
    80004c5c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004c5e:	000aa583          	lw	a1,0(s5)
    80004c62:	0289a503          	lw	a0,40(s3)
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	eee080e7          	jalr	-274(ra) # 80003b54 <bread>
    80004c6e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004c70:	865e                	mv	a2,s7
    80004c72:	05890593          	addi	a1,s2,88
    80004c76:	05850513          	addi	a0,a0,88
    80004c7a:	ffffc097          	auipc	ra,0xffffc
    80004c7e:	1f8080e7          	jalr	504(ra) # 80000e72 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004c82:	8526                	mv	a0,s1
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	fc2080e7          	jalr	-62(ra) # 80003c46 <bwrite>
    if(recovering == 0)
    80004c8c:	f80b1de3          	bnez	s6,80004c26 <install_trans+0x3c>
      bunpin(dbuf);
    80004c90:	8526                	mv	a0,s1
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	0c6080e7          	jalr	198(ra) # 80003d58 <bunpin>
    80004c9a:	b771                	j	80004c26 <install_trans+0x3c>
}
    80004c9c:	60a6                	ld	ra,72(sp)
    80004c9e:	6406                	ld	s0,64(sp)
    80004ca0:	74e2                	ld	s1,56(sp)
    80004ca2:	7942                	ld	s2,48(sp)
    80004ca4:	79a2                	ld	s3,40(sp)
    80004ca6:	7a02                	ld	s4,32(sp)
    80004ca8:	6ae2                	ld	s5,24(sp)
    80004caa:	6b42                	ld	s6,16(sp)
    80004cac:	6ba2                	ld	s7,8(sp)
    80004cae:	6161                	addi	sp,sp,80
    80004cb0:	8082                	ret
    80004cb2:	8082                	ret

0000000080004cb4 <initlog>:
{
    80004cb4:	7179                	addi	sp,sp,-48
    80004cb6:	f406                	sd	ra,40(sp)
    80004cb8:	f022                	sd	s0,32(sp)
    80004cba:	ec26                	sd	s1,24(sp)
    80004cbc:	e84a                	sd	s2,16(sp)
    80004cbe:	e44e                	sd	s3,8(sp)
    80004cc0:	1800                	addi	s0,sp,48
    80004cc2:	892a                	mv	s2,a0
    80004cc4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004cc6:	00068497          	auipc	s1,0x68
    80004cca:	31a48493          	addi	s1,s1,794 # 8006cfe0 <log>
    80004cce:	00005597          	auipc	a1,0x5
    80004cd2:	93258593          	addi	a1,a1,-1742 # 80009600 <etext+0x600>
    80004cd6:	8526                	mv	a0,s1
    80004cd8:	ffffc097          	auipc	ra,0xffffc
    80004cdc:	faa080e7          	jalr	-86(ra) # 80000c82 <initlock>
  log.start = sb->logstart;
    80004ce0:	0149a583          	lw	a1,20(s3)
    80004ce4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004ce6:	0109a783          	lw	a5,16(s3)
    80004cea:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004cec:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004cf0:	854a                	mv	a0,s2
    80004cf2:	fffff097          	auipc	ra,0xfffff
    80004cf6:	e62080e7          	jalr	-414(ra) # 80003b54 <bread>
  log.lh.n = lh->n;
    80004cfa:	4d30                	lw	a2,88(a0)
    80004cfc:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004cfe:	00c05f63          	blez	a2,80004d1c <initlog+0x68>
    80004d02:	87aa                	mv	a5,a0
    80004d04:	00068717          	auipc	a4,0x68
    80004d08:	30c70713          	addi	a4,a4,780 # 8006d010 <log+0x30>
    80004d0c:	060a                	slli	a2,a2,0x2
    80004d0e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004d10:	4ff4                	lw	a3,92(a5)
    80004d12:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004d14:	0791                	addi	a5,a5,4
    80004d16:	0711                	addi	a4,a4,4
    80004d18:	fec79ce3          	bne	a5,a2,80004d10 <initlog+0x5c>
  brelse(buf);
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	f68080e7          	jalr	-152(ra) # 80003c84 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004d24:	4505                	li	a0,1
    80004d26:	00000097          	auipc	ra,0x0
    80004d2a:	ec4080e7          	jalr	-316(ra) # 80004bea <install_trans>
  log.lh.n = 0;
    80004d2e:	00068797          	auipc	a5,0x68
    80004d32:	2c07af23          	sw	zero,734(a5) # 8006d00c <log+0x2c>
  write_head(); // clear the log
    80004d36:	00000097          	auipc	ra,0x0
    80004d3a:	e4a080e7          	jalr	-438(ra) # 80004b80 <write_head>
}
    80004d3e:	70a2                	ld	ra,40(sp)
    80004d40:	7402                	ld	s0,32(sp)
    80004d42:	64e2                	ld	s1,24(sp)
    80004d44:	6942                	ld	s2,16(sp)
    80004d46:	69a2                	ld	s3,8(sp)
    80004d48:	6145                	addi	sp,sp,48
    80004d4a:	8082                	ret

0000000080004d4c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004d4c:	1101                	addi	sp,sp,-32
    80004d4e:	ec06                	sd	ra,24(sp)
    80004d50:	e822                	sd	s0,16(sp)
    80004d52:	e426                	sd	s1,8(sp)
    80004d54:	e04a                	sd	s2,0(sp)
    80004d56:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004d58:	00068517          	auipc	a0,0x68
    80004d5c:	28850513          	addi	a0,a0,648 # 8006cfe0 <log>
    80004d60:	ffffc097          	auipc	ra,0xffffc
    80004d64:	fb6080e7          	jalr	-74(ra) # 80000d16 <acquire>
  while(1){
    if(log.committing){
    80004d68:	00068497          	auipc	s1,0x68
    80004d6c:	27848493          	addi	s1,s1,632 # 8006cfe0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004d70:	4979                	li	s2,30
    80004d72:	a039                	j	80004d80 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004d74:	85a6                	mv	a1,s1
    80004d76:	8526                	mv	a0,s1
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	ab2080e7          	jalr	-1358(ra) # 8000282a <sleep>
    if(log.committing){
    80004d80:	50dc                	lw	a5,36(s1)
    80004d82:	fbed                	bnez	a5,80004d74 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004d84:	5098                	lw	a4,32(s1)
    80004d86:	2705                	addiw	a4,a4,1
    80004d88:	0027179b          	slliw	a5,a4,0x2
    80004d8c:	9fb9                	addw	a5,a5,a4
    80004d8e:	0017979b          	slliw	a5,a5,0x1
    80004d92:	54d4                	lw	a3,44(s1)
    80004d94:	9fb5                	addw	a5,a5,a3
    80004d96:	00f95963          	bge	s2,a5,80004da8 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004d9a:	85a6                	mv	a1,s1
    80004d9c:	8526                	mv	a0,s1
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	a8c080e7          	jalr	-1396(ra) # 8000282a <sleep>
    80004da6:	bfe9                	j	80004d80 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004da8:	00068517          	auipc	a0,0x68
    80004dac:	23850513          	addi	a0,a0,568 # 8006cfe0 <log>
    80004db0:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004db2:	ffffc097          	auipc	ra,0xffffc
    80004db6:	014080e7          	jalr	20(ra) # 80000dc6 <release>
      break;
    }
  }
}
    80004dba:	60e2                	ld	ra,24(sp)
    80004dbc:	6442                	ld	s0,16(sp)
    80004dbe:	64a2                	ld	s1,8(sp)
    80004dc0:	6902                	ld	s2,0(sp)
    80004dc2:	6105                	addi	sp,sp,32
    80004dc4:	8082                	ret

0000000080004dc6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004dc6:	7139                	addi	sp,sp,-64
    80004dc8:	fc06                	sd	ra,56(sp)
    80004dca:	f822                	sd	s0,48(sp)
    80004dcc:	f426                	sd	s1,40(sp)
    80004dce:	f04a                	sd	s2,32(sp)
    80004dd0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004dd2:	00068497          	auipc	s1,0x68
    80004dd6:	20e48493          	addi	s1,s1,526 # 8006cfe0 <log>
    80004dda:	8526                	mv	a0,s1
    80004ddc:	ffffc097          	auipc	ra,0xffffc
    80004de0:	f3a080e7          	jalr	-198(ra) # 80000d16 <acquire>
  log.outstanding -= 1;
    80004de4:	509c                	lw	a5,32(s1)
    80004de6:	37fd                	addiw	a5,a5,-1
    80004de8:	893e                	mv	s2,a5
    80004dea:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004dec:	50dc                	lw	a5,36(s1)
    80004dee:	e7b9                	bnez	a5,80004e3c <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    80004df0:	06091263          	bnez	s2,80004e54 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004df4:	00068497          	auipc	s1,0x68
    80004df8:	1ec48493          	addi	s1,s1,492 # 8006cfe0 <log>
    80004dfc:	4785                	li	a5,1
    80004dfe:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004e00:	8526                	mv	a0,s1
    80004e02:	ffffc097          	auipc	ra,0xffffc
    80004e06:	fc4080e7          	jalr	-60(ra) # 80000dc6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004e0a:	54dc                	lw	a5,44(s1)
    80004e0c:	06f04863          	bgtz	a5,80004e7c <end_op+0xb6>
    acquire(&log.lock);
    80004e10:	00068497          	auipc	s1,0x68
    80004e14:	1d048493          	addi	s1,s1,464 # 8006cfe0 <log>
    80004e18:	8526                	mv	a0,s1
    80004e1a:	ffffc097          	auipc	ra,0xffffc
    80004e1e:	efc080e7          	jalr	-260(ra) # 80000d16 <acquire>
    log.committing = 0;
    80004e22:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004e26:	8526                	mv	a0,s1
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	a66080e7          	jalr	-1434(ra) # 8000288e <wakeup>
    release(&log.lock);
    80004e30:	8526                	mv	a0,s1
    80004e32:	ffffc097          	auipc	ra,0xffffc
    80004e36:	f94080e7          	jalr	-108(ra) # 80000dc6 <release>
}
    80004e3a:	a81d                	j	80004e70 <end_op+0xaa>
    80004e3c:	ec4e                	sd	s3,24(sp)
    80004e3e:	e852                	sd	s4,16(sp)
    80004e40:	e456                	sd	s5,8(sp)
    80004e42:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80004e44:	00004517          	auipc	a0,0x4
    80004e48:	7c450513          	addi	a0,a0,1988 # 80009608 <etext+0x608>
    80004e4c:	ffffb097          	auipc	ra,0xffffb
    80004e50:	714080e7          	jalr	1812(ra) # 80000560 <panic>
    wakeup(&log);
    80004e54:	00068497          	auipc	s1,0x68
    80004e58:	18c48493          	addi	s1,s1,396 # 8006cfe0 <log>
    80004e5c:	8526                	mv	a0,s1
    80004e5e:	ffffe097          	auipc	ra,0xffffe
    80004e62:	a30080e7          	jalr	-1488(ra) # 8000288e <wakeup>
  release(&log.lock);
    80004e66:	8526                	mv	a0,s1
    80004e68:	ffffc097          	auipc	ra,0xffffc
    80004e6c:	f5e080e7          	jalr	-162(ra) # 80000dc6 <release>
}
    80004e70:	70e2                	ld	ra,56(sp)
    80004e72:	7442                	ld	s0,48(sp)
    80004e74:	74a2                	ld	s1,40(sp)
    80004e76:	7902                	ld	s2,32(sp)
    80004e78:	6121                	addi	sp,sp,64
    80004e7a:	8082                	ret
    80004e7c:	ec4e                	sd	s3,24(sp)
    80004e7e:	e852                	sd	s4,16(sp)
    80004e80:	e456                	sd	s5,8(sp)
    80004e82:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e84:	00068a97          	auipc	s5,0x68
    80004e88:	18ca8a93          	addi	s5,s5,396 # 8006d010 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004e8c:	00068a17          	auipc	s4,0x68
    80004e90:	154a0a13          	addi	s4,s4,340 # 8006cfe0 <log>
    memmove(to->data, from->data, BSIZE);
    80004e94:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004e98:	018a2583          	lw	a1,24(s4)
    80004e9c:	012585bb          	addw	a1,a1,s2
    80004ea0:	2585                	addiw	a1,a1,1
    80004ea2:	028a2503          	lw	a0,40(s4)
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	cae080e7          	jalr	-850(ra) # 80003b54 <bread>
    80004eae:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004eb0:	000aa583          	lw	a1,0(s5)
    80004eb4:	028a2503          	lw	a0,40(s4)
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	c9c080e7          	jalr	-868(ra) # 80003b54 <bread>
    80004ec0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004ec2:	865a                	mv	a2,s6
    80004ec4:	05850593          	addi	a1,a0,88
    80004ec8:	05848513          	addi	a0,s1,88
    80004ecc:	ffffc097          	auipc	ra,0xffffc
    80004ed0:	fa6080e7          	jalr	-90(ra) # 80000e72 <memmove>
    bwrite(to);  // write the log
    80004ed4:	8526                	mv	a0,s1
    80004ed6:	fffff097          	auipc	ra,0xfffff
    80004eda:	d70080e7          	jalr	-656(ra) # 80003c46 <bwrite>
    brelse(from);
    80004ede:	854e                	mv	a0,s3
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	da4080e7          	jalr	-604(ra) # 80003c84 <brelse>
    brelse(to);
    80004ee8:	8526                	mv	a0,s1
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	d9a080e7          	jalr	-614(ra) # 80003c84 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004ef2:	2905                	addiw	s2,s2,1
    80004ef4:	0a91                	addi	s5,s5,4
    80004ef6:	02ca2783          	lw	a5,44(s4)
    80004efa:	f8f94fe3          	blt	s2,a5,80004e98 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004efe:	00000097          	auipc	ra,0x0
    80004f02:	c82080e7          	jalr	-894(ra) # 80004b80 <write_head>
    install_trans(0); // Now install writes to home locations
    80004f06:	4501                	li	a0,0
    80004f08:	00000097          	auipc	ra,0x0
    80004f0c:	ce2080e7          	jalr	-798(ra) # 80004bea <install_trans>
    log.lh.n = 0;
    80004f10:	00068797          	auipc	a5,0x68
    80004f14:	0e07ae23          	sw	zero,252(a5) # 8006d00c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004f18:	00000097          	auipc	ra,0x0
    80004f1c:	c68080e7          	jalr	-920(ra) # 80004b80 <write_head>
    80004f20:	69e2                	ld	s3,24(sp)
    80004f22:	6a42                	ld	s4,16(sp)
    80004f24:	6aa2                	ld	s5,8(sp)
    80004f26:	6b02                	ld	s6,0(sp)
    80004f28:	b5e5                	j	80004e10 <end_op+0x4a>

0000000080004f2a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004f2a:	1101                	addi	sp,sp,-32
    80004f2c:	ec06                	sd	ra,24(sp)
    80004f2e:	e822                	sd	s0,16(sp)
    80004f30:	e426                	sd	s1,8(sp)
    80004f32:	e04a                	sd	s2,0(sp)
    80004f34:	1000                	addi	s0,sp,32
    80004f36:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004f38:	00068917          	auipc	s2,0x68
    80004f3c:	0a890913          	addi	s2,s2,168 # 8006cfe0 <log>
    80004f40:	854a                	mv	a0,s2
    80004f42:	ffffc097          	auipc	ra,0xffffc
    80004f46:	dd4080e7          	jalr	-556(ra) # 80000d16 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004f4a:	02c92603          	lw	a2,44(s2)
    80004f4e:	47f5                	li	a5,29
    80004f50:	06c7c563          	blt	a5,a2,80004fba <log_write+0x90>
    80004f54:	00068797          	auipc	a5,0x68
    80004f58:	0a87a783          	lw	a5,168(a5) # 8006cffc <log+0x1c>
    80004f5c:	37fd                	addiw	a5,a5,-1
    80004f5e:	04f65e63          	bge	a2,a5,80004fba <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004f62:	00068797          	auipc	a5,0x68
    80004f66:	09e7a783          	lw	a5,158(a5) # 8006d000 <log+0x20>
    80004f6a:	06f05063          	blez	a5,80004fca <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004f6e:	4781                	li	a5,0
    80004f70:	06c05563          	blez	a2,80004fda <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004f74:	44cc                	lw	a1,12(s1)
    80004f76:	00068717          	auipc	a4,0x68
    80004f7a:	09a70713          	addi	a4,a4,154 # 8006d010 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004f7e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004f80:	4314                	lw	a3,0(a4)
    80004f82:	04b68c63          	beq	a3,a1,80004fda <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004f86:	2785                	addiw	a5,a5,1
    80004f88:	0711                	addi	a4,a4,4
    80004f8a:	fef61be3          	bne	a2,a5,80004f80 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004f8e:	0621                	addi	a2,a2,8
    80004f90:	060a                	slli	a2,a2,0x2
    80004f92:	00068797          	auipc	a5,0x68
    80004f96:	04e78793          	addi	a5,a5,78 # 8006cfe0 <log>
    80004f9a:	97b2                	add	a5,a5,a2
    80004f9c:	44d8                	lw	a4,12(s1)
    80004f9e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004fa0:	8526                	mv	a0,s1
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	d7a080e7          	jalr	-646(ra) # 80003d1c <bpin>
    log.lh.n++;
    80004faa:	00068717          	auipc	a4,0x68
    80004fae:	03670713          	addi	a4,a4,54 # 8006cfe0 <log>
    80004fb2:	575c                	lw	a5,44(a4)
    80004fb4:	2785                	addiw	a5,a5,1
    80004fb6:	d75c                	sw	a5,44(a4)
    80004fb8:	a82d                	j	80004ff2 <log_write+0xc8>
    panic("too big a transaction");
    80004fba:	00004517          	auipc	a0,0x4
    80004fbe:	65e50513          	addi	a0,a0,1630 # 80009618 <etext+0x618>
    80004fc2:	ffffb097          	auipc	ra,0xffffb
    80004fc6:	59e080e7          	jalr	1438(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004fca:	00004517          	auipc	a0,0x4
    80004fce:	66650513          	addi	a0,a0,1638 # 80009630 <etext+0x630>
    80004fd2:	ffffb097          	auipc	ra,0xffffb
    80004fd6:	58e080e7          	jalr	1422(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004fda:	00878693          	addi	a3,a5,8
    80004fde:	068a                	slli	a3,a3,0x2
    80004fe0:	00068717          	auipc	a4,0x68
    80004fe4:	00070713          	mv	a4,a4
    80004fe8:	9736                	add	a4,a4,a3
    80004fea:	44d4                	lw	a3,12(s1)
    80004fec:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004fee:	faf609e3          	beq	a2,a5,80004fa0 <log_write+0x76>
  }
  release(&log.lock);
    80004ff2:	00068517          	auipc	a0,0x68
    80004ff6:	fee50513          	addi	a0,a0,-18 # 8006cfe0 <log>
    80004ffa:	ffffc097          	auipc	ra,0xffffc
    80004ffe:	dcc080e7          	jalr	-564(ra) # 80000dc6 <release>
}
    80005002:	60e2                	ld	ra,24(sp)
    80005004:	6442                	ld	s0,16(sp)
    80005006:	64a2                	ld	s1,8(sp)
    80005008:	6902                	ld	s2,0(sp)
    8000500a:	6105                	addi	sp,sp,32
    8000500c:	8082                	ret

000000008000500e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000500e:	1101                	addi	sp,sp,-32
    80005010:	ec06                	sd	ra,24(sp)
    80005012:	e822                	sd	s0,16(sp)
    80005014:	e426                	sd	s1,8(sp)
    80005016:	e04a                	sd	s2,0(sp)
    80005018:	1000                	addi	s0,sp,32
    8000501a:	84aa                	mv	s1,a0
    8000501c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000501e:	00004597          	auipc	a1,0x4
    80005022:	63258593          	addi	a1,a1,1586 # 80009650 <etext+0x650>
    80005026:	0521                	addi	a0,a0,8
    80005028:	ffffc097          	auipc	ra,0xffffc
    8000502c:	c5a080e7          	jalr	-934(ra) # 80000c82 <initlock>
  lk->name = name;
    80005030:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80005034:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005038:	0204a423          	sw	zero,40(s1)
}
    8000503c:	60e2                	ld	ra,24(sp)
    8000503e:	6442                	ld	s0,16(sp)
    80005040:	64a2                	ld	s1,8(sp)
    80005042:	6902                	ld	s2,0(sp)
    80005044:	6105                	addi	sp,sp,32
    80005046:	8082                	ret

0000000080005048 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80005048:	1101                	addi	sp,sp,-32
    8000504a:	ec06                	sd	ra,24(sp)
    8000504c:	e822                	sd	s0,16(sp)
    8000504e:	e426                	sd	s1,8(sp)
    80005050:	e04a                	sd	s2,0(sp)
    80005052:	1000                	addi	s0,sp,32
    80005054:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80005056:	00850913          	addi	s2,a0,8
    8000505a:	854a                	mv	a0,s2
    8000505c:	ffffc097          	auipc	ra,0xffffc
    80005060:	cba080e7          	jalr	-838(ra) # 80000d16 <acquire>
  while (lk->locked) {
    80005064:	409c                	lw	a5,0(s1)
    80005066:	cb89                	beqz	a5,80005078 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80005068:	85ca                	mv	a1,s2
    8000506a:	8526                	mv	a0,s1
    8000506c:	ffffd097          	auipc	ra,0xffffd
    80005070:	7be080e7          	jalr	1982(ra) # 8000282a <sleep>
  while (lk->locked) {
    80005074:	409c                	lw	a5,0(s1)
    80005076:	fbed                	bnez	a5,80005068 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80005078:	4785                	li	a5,1
    8000507a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000507c:	ffffd097          	auipc	ra,0xffffd
    80005080:	ea6080e7          	jalr	-346(ra) # 80001f22 <myproc>
    80005084:	591c                	lw	a5,48(a0)
    80005086:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80005088:	854a                	mv	a0,s2
    8000508a:	ffffc097          	auipc	ra,0xffffc
    8000508e:	d3c080e7          	jalr	-708(ra) # 80000dc6 <release>
}
    80005092:	60e2                	ld	ra,24(sp)
    80005094:	6442                	ld	s0,16(sp)
    80005096:	64a2                	ld	s1,8(sp)
    80005098:	6902                	ld	s2,0(sp)
    8000509a:	6105                	addi	sp,sp,32
    8000509c:	8082                	ret

000000008000509e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000509e:	1101                	addi	sp,sp,-32
    800050a0:	ec06                	sd	ra,24(sp)
    800050a2:	e822                	sd	s0,16(sp)
    800050a4:	e426                	sd	s1,8(sp)
    800050a6:	e04a                	sd	s2,0(sp)
    800050a8:	1000                	addi	s0,sp,32
    800050aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800050ac:	00850913          	addi	s2,a0,8
    800050b0:	854a                	mv	a0,s2
    800050b2:	ffffc097          	auipc	ra,0xffffc
    800050b6:	c64080e7          	jalr	-924(ra) # 80000d16 <acquire>
  lk->locked = 0;
    800050ba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800050be:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800050c2:	8526                	mv	a0,s1
    800050c4:	ffffd097          	auipc	ra,0xffffd
    800050c8:	7ca080e7          	jalr	1994(ra) # 8000288e <wakeup>
  release(&lk->lk);
    800050cc:	854a                	mv	a0,s2
    800050ce:	ffffc097          	auipc	ra,0xffffc
    800050d2:	cf8080e7          	jalr	-776(ra) # 80000dc6 <release>
}
    800050d6:	60e2                	ld	ra,24(sp)
    800050d8:	6442                	ld	s0,16(sp)
    800050da:	64a2                	ld	s1,8(sp)
    800050dc:	6902                	ld	s2,0(sp)
    800050de:	6105                	addi	sp,sp,32
    800050e0:	8082                	ret

00000000800050e2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800050e2:	7179                	addi	sp,sp,-48
    800050e4:	f406                	sd	ra,40(sp)
    800050e6:	f022                	sd	s0,32(sp)
    800050e8:	ec26                	sd	s1,24(sp)
    800050ea:	e84a                	sd	s2,16(sp)
    800050ec:	1800                	addi	s0,sp,48
    800050ee:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800050f0:	00850913          	addi	s2,a0,8
    800050f4:	854a                	mv	a0,s2
    800050f6:	ffffc097          	auipc	ra,0xffffc
    800050fa:	c20080e7          	jalr	-992(ra) # 80000d16 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800050fe:	409c                	lw	a5,0(s1)
    80005100:	ef91                	bnez	a5,8000511c <holdingsleep+0x3a>
    80005102:	4481                	li	s1,0
  release(&lk->lk);
    80005104:	854a                	mv	a0,s2
    80005106:	ffffc097          	auipc	ra,0xffffc
    8000510a:	cc0080e7          	jalr	-832(ra) # 80000dc6 <release>
  return r;
}
    8000510e:	8526                	mv	a0,s1
    80005110:	70a2                	ld	ra,40(sp)
    80005112:	7402                	ld	s0,32(sp)
    80005114:	64e2                	ld	s1,24(sp)
    80005116:	6942                	ld	s2,16(sp)
    80005118:	6145                	addi	sp,sp,48
    8000511a:	8082                	ret
    8000511c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000511e:	0284a983          	lw	s3,40(s1)
    80005122:	ffffd097          	auipc	ra,0xffffd
    80005126:	e00080e7          	jalr	-512(ra) # 80001f22 <myproc>
    8000512a:	5904                	lw	s1,48(a0)
    8000512c:	413484b3          	sub	s1,s1,s3
    80005130:	0014b493          	seqz	s1,s1
    80005134:	69a2                	ld	s3,8(sp)
    80005136:	b7f9                	j	80005104 <holdingsleep+0x22>

0000000080005138 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005138:	1141                	addi	sp,sp,-16
    8000513a:	e406                	sd	ra,8(sp)
    8000513c:	e022                	sd	s0,0(sp)
    8000513e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005140:	00004597          	auipc	a1,0x4
    80005144:	52058593          	addi	a1,a1,1312 # 80009660 <etext+0x660>
    80005148:	00068517          	auipc	a0,0x68
    8000514c:	fe050513          	addi	a0,a0,-32 # 8006d128 <ftable>
    80005150:	ffffc097          	auipc	ra,0xffffc
    80005154:	b32080e7          	jalr	-1230(ra) # 80000c82 <initlock>
}
    80005158:	60a2                	ld	ra,8(sp)
    8000515a:	6402                	ld	s0,0(sp)
    8000515c:	0141                	addi	sp,sp,16
    8000515e:	8082                	ret

0000000080005160 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005160:	1101                	addi	sp,sp,-32
    80005162:	ec06                	sd	ra,24(sp)
    80005164:	e822                	sd	s0,16(sp)
    80005166:	e426                	sd	s1,8(sp)
    80005168:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000516a:	00068517          	auipc	a0,0x68
    8000516e:	fbe50513          	addi	a0,a0,-66 # 8006d128 <ftable>
    80005172:	ffffc097          	auipc	ra,0xffffc
    80005176:	ba4080e7          	jalr	-1116(ra) # 80000d16 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000517a:	00068497          	auipc	s1,0x68
    8000517e:	fc648493          	addi	s1,s1,-58 # 8006d140 <ftable+0x18>
    80005182:	00069717          	auipc	a4,0x69
    80005186:	f5e70713          	addi	a4,a4,-162 # 8006e0e0 <disk>
    if(f->ref == 0){
    8000518a:	40dc                	lw	a5,4(s1)
    8000518c:	cf99                	beqz	a5,800051aa <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000518e:	02848493          	addi	s1,s1,40
    80005192:	fee49ce3          	bne	s1,a4,8000518a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005196:	00068517          	auipc	a0,0x68
    8000519a:	f9250513          	addi	a0,a0,-110 # 8006d128 <ftable>
    8000519e:	ffffc097          	auipc	ra,0xffffc
    800051a2:	c28080e7          	jalr	-984(ra) # 80000dc6 <release>
  return 0;
    800051a6:	4481                	li	s1,0
    800051a8:	a819                	j	800051be <filealloc+0x5e>
      f->ref = 1;
    800051aa:	4785                	li	a5,1
    800051ac:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800051ae:	00068517          	auipc	a0,0x68
    800051b2:	f7a50513          	addi	a0,a0,-134 # 8006d128 <ftable>
    800051b6:	ffffc097          	auipc	ra,0xffffc
    800051ba:	c10080e7          	jalr	-1008(ra) # 80000dc6 <release>
}
    800051be:	8526                	mv	a0,s1
    800051c0:	60e2                	ld	ra,24(sp)
    800051c2:	6442                	ld	s0,16(sp)
    800051c4:	64a2                	ld	s1,8(sp)
    800051c6:	6105                	addi	sp,sp,32
    800051c8:	8082                	ret

00000000800051ca <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800051ca:	1101                	addi	sp,sp,-32
    800051cc:	ec06                	sd	ra,24(sp)
    800051ce:	e822                	sd	s0,16(sp)
    800051d0:	e426                	sd	s1,8(sp)
    800051d2:	1000                	addi	s0,sp,32
    800051d4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800051d6:	00068517          	auipc	a0,0x68
    800051da:	f5250513          	addi	a0,a0,-174 # 8006d128 <ftable>
    800051de:	ffffc097          	auipc	ra,0xffffc
    800051e2:	b38080e7          	jalr	-1224(ra) # 80000d16 <acquire>
  if(f->ref < 1)
    800051e6:	40dc                	lw	a5,4(s1)
    800051e8:	02f05263          	blez	a5,8000520c <filedup+0x42>
    panic("filedup");
  f->ref++;
    800051ec:	2785                	addiw	a5,a5,1
    800051ee:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800051f0:	00068517          	auipc	a0,0x68
    800051f4:	f3850513          	addi	a0,a0,-200 # 8006d128 <ftable>
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	bce080e7          	jalr	-1074(ra) # 80000dc6 <release>
  return f;
}
    80005200:	8526                	mv	a0,s1
    80005202:	60e2                	ld	ra,24(sp)
    80005204:	6442                	ld	s0,16(sp)
    80005206:	64a2                	ld	s1,8(sp)
    80005208:	6105                	addi	sp,sp,32
    8000520a:	8082                	ret
    panic("filedup");
    8000520c:	00004517          	auipc	a0,0x4
    80005210:	45c50513          	addi	a0,a0,1116 # 80009668 <etext+0x668>
    80005214:	ffffb097          	auipc	ra,0xffffb
    80005218:	34c080e7          	jalr	844(ra) # 80000560 <panic>

000000008000521c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000521c:	7139                	addi	sp,sp,-64
    8000521e:	fc06                	sd	ra,56(sp)
    80005220:	f822                	sd	s0,48(sp)
    80005222:	f426                	sd	s1,40(sp)
    80005224:	0080                	addi	s0,sp,64
    80005226:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005228:	00068517          	auipc	a0,0x68
    8000522c:	f0050513          	addi	a0,a0,-256 # 8006d128 <ftable>
    80005230:	ffffc097          	auipc	ra,0xffffc
    80005234:	ae6080e7          	jalr	-1306(ra) # 80000d16 <acquire>
  if(f->ref < 1)
    80005238:	40dc                	lw	a5,4(s1)
    8000523a:	04f05a63          	blez	a5,8000528e <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    8000523e:	37fd                	addiw	a5,a5,-1
    80005240:	c0dc                	sw	a5,4(s1)
    80005242:	06f04263          	bgtz	a5,800052a6 <fileclose+0x8a>
    80005246:	f04a                	sd	s2,32(sp)
    80005248:	ec4e                	sd	s3,24(sp)
    8000524a:	e852                	sd	s4,16(sp)
    8000524c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000524e:	0004a903          	lw	s2,0(s1)
    80005252:	0094ca83          	lbu	s5,9(s1)
    80005256:	0104ba03          	ld	s4,16(s1)
    8000525a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000525e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80005262:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80005266:	00068517          	auipc	a0,0x68
    8000526a:	ec250513          	addi	a0,a0,-318 # 8006d128 <ftable>
    8000526e:	ffffc097          	auipc	ra,0xffffc
    80005272:	b58080e7          	jalr	-1192(ra) # 80000dc6 <release>

  if(ff.type == FD_PIPE){
    80005276:	4785                	li	a5,1
    80005278:	04f90463          	beq	s2,a5,800052c0 <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000527c:	3979                	addiw	s2,s2,-2
    8000527e:	4785                	li	a5,1
    80005280:	0527fb63          	bgeu	a5,s2,800052d6 <fileclose+0xba>
    80005284:	7902                	ld	s2,32(sp)
    80005286:	69e2                	ld	s3,24(sp)
    80005288:	6a42                	ld	s4,16(sp)
    8000528a:	6aa2                	ld	s5,8(sp)
    8000528c:	a02d                	j	800052b6 <fileclose+0x9a>
    8000528e:	f04a                	sd	s2,32(sp)
    80005290:	ec4e                	sd	s3,24(sp)
    80005292:	e852                	sd	s4,16(sp)
    80005294:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80005296:	00004517          	auipc	a0,0x4
    8000529a:	3da50513          	addi	a0,a0,986 # 80009670 <etext+0x670>
    8000529e:	ffffb097          	auipc	ra,0xffffb
    800052a2:	2c2080e7          	jalr	706(ra) # 80000560 <panic>
    release(&ftable.lock);
    800052a6:	00068517          	auipc	a0,0x68
    800052aa:	e8250513          	addi	a0,a0,-382 # 8006d128 <ftable>
    800052ae:	ffffc097          	auipc	ra,0xffffc
    800052b2:	b18080e7          	jalr	-1256(ra) # 80000dc6 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800052b6:	70e2                	ld	ra,56(sp)
    800052b8:	7442                	ld	s0,48(sp)
    800052ba:	74a2                	ld	s1,40(sp)
    800052bc:	6121                	addi	sp,sp,64
    800052be:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800052c0:	85d6                	mv	a1,s5
    800052c2:	8552                	mv	a0,s4
    800052c4:	00000097          	auipc	ra,0x0
    800052c8:	3ac080e7          	jalr	940(ra) # 80005670 <pipeclose>
    800052cc:	7902                	ld	s2,32(sp)
    800052ce:	69e2                	ld	s3,24(sp)
    800052d0:	6a42                	ld	s4,16(sp)
    800052d2:	6aa2                	ld	s5,8(sp)
    800052d4:	b7cd                	j	800052b6 <fileclose+0x9a>
    begin_op();
    800052d6:	00000097          	auipc	ra,0x0
    800052da:	a76080e7          	jalr	-1418(ra) # 80004d4c <begin_op>
    iput(ff.ip);
    800052de:	854e                	mv	a0,s3
    800052e0:	fffff097          	auipc	ra,0xfffff
    800052e4:	240080e7          	jalr	576(ra) # 80004520 <iput>
    end_op();
    800052e8:	00000097          	auipc	ra,0x0
    800052ec:	ade080e7          	jalr	-1314(ra) # 80004dc6 <end_op>
    800052f0:	7902                	ld	s2,32(sp)
    800052f2:	69e2                	ld	s3,24(sp)
    800052f4:	6a42                	ld	s4,16(sp)
    800052f6:	6aa2                	ld	s5,8(sp)
    800052f8:	bf7d                	j	800052b6 <fileclose+0x9a>

00000000800052fa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800052fa:	715d                	addi	sp,sp,-80
    800052fc:	e486                	sd	ra,72(sp)
    800052fe:	e0a2                	sd	s0,64(sp)
    80005300:	fc26                	sd	s1,56(sp)
    80005302:	f44e                	sd	s3,40(sp)
    80005304:	0880                	addi	s0,sp,80
    80005306:	84aa                	mv	s1,a0
    80005308:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000530a:	ffffd097          	auipc	ra,0xffffd
    8000530e:	c18080e7          	jalr	-1000(ra) # 80001f22 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80005312:	409c                	lw	a5,0(s1)
    80005314:	37f9                	addiw	a5,a5,-2
    80005316:	4705                	li	a4,1
    80005318:	04f76a63          	bltu	a4,a5,8000536c <filestat+0x72>
    8000531c:	f84a                	sd	s2,48(sp)
    8000531e:	f052                	sd	s4,32(sp)
    80005320:	892a                	mv	s2,a0
    ilock(f->ip);
    80005322:	6c88                	ld	a0,24(s1)
    80005324:	fffff097          	auipc	ra,0xfffff
    80005328:	03e080e7          	jalr	62(ra) # 80004362 <ilock>
    stati(f->ip, &st);
    8000532c:	fb840a13          	addi	s4,s0,-72
    80005330:	85d2                	mv	a1,s4
    80005332:	6c88                	ld	a0,24(s1)
    80005334:	fffff097          	auipc	ra,0xfffff
    80005338:	2bc080e7          	jalr	700(ra) # 800045f0 <stati>
    iunlock(f->ip);
    8000533c:	6c88                	ld	a0,24(s1)
    8000533e:	fffff097          	auipc	ra,0xfffff
    80005342:	0ea080e7          	jalr	234(ra) # 80004428 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80005346:	46e1                	li	a3,24
    80005348:	8652                	mv	a2,s4
    8000534a:	85ce                	mv	a1,s3
    8000534c:	05093503          	ld	a0,80(s2)
    80005350:	ffffd097          	auipc	ra,0xffffd
    80005354:	87a080e7          	jalr	-1926(ra) # 80001bca <copyout>
    80005358:	41f5551b          	sraiw	a0,a0,0x1f
    8000535c:	7942                	ld	s2,48(sp)
    8000535e:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80005360:	60a6                	ld	ra,72(sp)
    80005362:	6406                	ld	s0,64(sp)
    80005364:	74e2                	ld	s1,56(sp)
    80005366:	79a2                	ld	s3,40(sp)
    80005368:	6161                	addi	sp,sp,80
    8000536a:	8082                	ret
  return -1;
    8000536c:	557d                	li	a0,-1
    8000536e:	bfcd                	j	80005360 <filestat+0x66>

0000000080005370 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005370:	7179                	addi	sp,sp,-48
    80005372:	f406                	sd	ra,40(sp)
    80005374:	f022                	sd	s0,32(sp)
    80005376:	e84a                	sd	s2,16(sp)
    80005378:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000537a:	00854783          	lbu	a5,8(a0)
    8000537e:	cbc5                	beqz	a5,8000542e <fileread+0xbe>
    80005380:	ec26                	sd	s1,24(sp)
    80005382:	e44e                	sd	s3,8(sp)
    80005384:	84aa                	mv	s1,a0
    80005386:	89ae                	mv	s3,a1
    80005388:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000538a:	411c                	lw	a5,0(a0)
    8000538c:	4705                	li	a4,1
    8000538e:	04e78963          	beq	a5,a4,800053e0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005392:	470d                	li	a4,3
    80005394:	04e78f63          	beq	a5,a4,800053f2 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80005398:	4709                	li	a4,2
    8000539a:	08e79263          	bne	a5,a4,8000541e <fileread+0xae>
    ilock(f->ip);
    8000539e:	6d08                	ld	a0,24(a0)
    800053a0:	fffff097          	auipc	ra,0xfffff
    800053a4:	fc2080e7          	jalr	-62(ra) # 80004362 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800053a8:	874a                	mv	a4,s2
    800053aa:	5094                	lw	a3,32(s1)
    800053ac:	864e                	mv	a2,s3
    800053ae:	4585                	li	a1,1
    800053b0:	6c88                	ld	a0,24(s1)
    800053b2:	fffff097          	auipc	ra,0xfffff
    800053b6:	26c080e7          	jalr	620(ra) # 8000461e <readi>
    800053ba:	892a                	mv	s2,a0
    800053bc:	00a05563          	blez	a0,800053c6 <fileread+0x56>
      f->off += r;
    800053c0:	509c                	lw	a5,32(s1)
    800053c2:	9fa9                	addw	a5,a5,a0
    800053c4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800053c6:	6c88                	ld	a0,24(s1)
    800053c8:	fffff097          	auipc	ra,0xfffff
    800053cc:	060080e7          	jalr	96(ra) # 80004428 <iunlock>
    800053d0:	64e2                	ld	s1,24(sp)
    800053d2:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800053d4:	854a                	mv	a0,s2
    800053d6:	70a2                	ld	ra,40(sp)
    800053d8:	7402                	ld	s0,32(sp)
    800053da:	6942                	ld	s2,16(sp)
    800053dc:	6145                	addi	sp,sp,48
    800053de:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800053e0:	6908                	ld	a0,16(a0)
    800053e2:	00000097          	auipc	ra,0x0
    800053e6:	41a080e7          	jalr	1050(ra) # 800057fc <piperead>
    800053ea:	892a                	mv	s2,a0
    800053ec:	64e2                	ld	s1,24(sp)
    800053ee:	69a2                	ld	s3,8(sp)
    800053f0:	b7d5                	j	800053d4 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800053f2:	02451783          	lh	a5,36(a0)
    800053f6:	03079693          	slli	a3,a5,0x30
    800053fa:	92c1                	srli	a3,a3,0x30
    800053fc:	4725                	li	a4,9
    800053fe:	02d76a63          	bltu	a4,a3,80005432 <fileread+0xc2>
    80005402:	0792                	slli	a5,a5,0x4
    80005404:	00068717          	auipc	a4,0x68
    80005408:	c8470713          	addi	a4,a4,-892 # 8006d088 <devsw>
    8000540c:	97ba                	add	a5,a5,a4
    8000540e:	639c                	ld	a5,0(a5)
    80005410:	c78d                	beqz	a5,8000543a <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80005412:	4505                	li	a0,1
    80005414:	9782                	jalr	a5
    80005416:	892a                	mv	s2,a0
    80005418:	64e2                	ld	s1,24(sp)
    8000541a:	69a2                	ld	s3,8(sp)
    8000541c:	bf65                	j	800053d4 <fileread+0x64>
    panic("fileread");
    8000541e:	00004517          	auipc	a0,0x4
    80005422:	26250513          	addi	a0,a0,610 # 80009680 <etext+0x680>
    80005426:	ffffb097          	auipc	ra,0xffffb
    8000542a:	13a080e7          	jalr	314(ra) # 80000560 <panic>
    return -1;
    8000542e:	597d                	li	s2,-1
    80005430:	b755                	j	800053d4 <fileread+0x64>
      return -1;
    80005432:	597d                	li	s2,-1
    80005434:	64e2                	ld	s1,24(sp)
    80005436:	69a2                	ld	s3,8(sp)
    80005438:	bf71                	j	800053d4 <fileread+0x64>
    8000543a:	597d                	li	s2,-1
    8000543c:	64e2                	ld	s1,24(sp)
    8000543e:	69a2                	ld	s3,8(sp)
    80005440:	bf51                	j	800053d4 <fileread+0x64>

0000000080005442 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80005442:	00954783          	lbu	a5,9(a0)
    80005446:	12078c63          	beqz	a5,8000557e <filewrite+0x13c>
{
    8000544a:	711d                	addi	sp,sp,-96
    8000544c:	ec86                	sd	ra,88(sp)
    8000544e:	e8a2                	sd	s0,80(sp)
    80005450:	e0ca                	sd	s2,64(sp)
    80005452:	f456                	sd	s5,40(sp)
    80005454:	f05a                	sd	s6,32(sp)
    80005456:	1080                	addi	s0,sp,96
    80005458:	892a                	mv	s2,a0
    8000545a:	8b2e                	mv	s6,a1
    8000545c:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000545e:	411c                	lw	a5,0(a0)
    80005460:	4705                	li	a4,1
    80005462:	02e78963          	beq	a5,a4,80005494 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005466:	470d                	li	a4,3
    80005468:	02e78c63          	beq	a5,a4,800054a0 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000546c:	4709                	li	a4,2
    8000546e:	0ee79a63          	bne	a5,a4,80005562 <filewrite+0x120>
    80005472:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005474:	0cc05563          	blez	a2,8000553e <filewrite+0xfc>
    80005478:	e4a6                	sd	s1,72(sp)
    8000547a:	fc4e                	sd	s3,56(sp)
    8000547c:	ec5e                	sd	s7,24(sp)
    8000547e:	e862                	sd	s8,16(sp)
    80005480:	e466                	sd	s9,8(sp)
    int i = 0;
    80005482:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80005484:	6b85                	lui	s7,0x1
    80005486:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000548a:	6c85                	lui	s9,0x1
    8000548c:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005490:	4c05                	li	s8,1
    80005492:	a849                	j	80005524 <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80005494:	6908                	ld	a0,16(a0)
    80005496:	00000097          	auipc	ra,0x0
    8000549a:	24a080e7          	jalr	586(ra) # 800056e0 <pipewrite>
    8000549e:	a85d                	j	80005554 <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800054a0:	02451783          	lh	a5,36(a0)
    800054a4:	03079693          	slli	a3,a5,0x30
    800054a8:	92c1                	srli	a3,a3,0x30
    800054aa:	4725                	li	a4,9
    800054ac:	0cd76b63          	bltu	a4,a3,80005582 <filewrite+0x140>
    800054b0:	0792                	slli	a5,a5,0x4
    800054b2:	00068717          	auipc	a4,0x68
    800054b6:	bd670713          	addi	a4,a4,-1066 # 8006d088 <devsw>
    800054ba:	97ba                	add	a5,a5,a4
    800054bc:	679c                	ld	a5,8(a5)
    800054be:	c7e1                	beqz	a5,80005586 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    800054c0:	4505                	li	a0,1
    800054c2:	9782                	jalr	a5
    800054c4:	a841                	j	80005554 <filewrite+0x112>
      if(n1 > max)
    800054c6:	2981                	sext.w	s3,s3
      begin_op();
    800054c8:	00000097          	auipc	ra,0x0
    800054cc:	884080e7          	jalr	-1916(ra) # 80004d4c <begin_op>
      ilock(f->ip);
    800054d0:	01893503          	ld	a0,24(s2)
    800054d4:	fffff097          	auipc	ra,0xfffff
    800054d8:	e8e080e7          	jalr	-370(ra) # 80004362 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800054dc:	874e                	mv	a4,s3
    800054de:	02092683          	lw	a3,32(s2)
    800054e2:	016a0633          	add	a2,s4,s6
    800054e6:	85e2                	mv	a1,s8
    800054e8:	01893503          	ld	a0,24(s2)
    800054ec:	fffff097          	auipc	ra,0xfffff
    800054f0:	238080e7          	jalr	568(ra) # 80004724 <writei>
    800054f4:	84aa                	mv	s1,a0
    800054f6:	00a05763          	blez	a0,80005504 <filewrite+0xc2>
        f->off += r;
    800054fa:	02092783          	lw	a5,32(s2)
    800054fe:	9fa9                	addw	a5,a5,a0
    80005500:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005504:	01893503          	ld	a0,24(s2)
    80005508:	fffff097          	auipc	ra,0xfffff
    8000550c:	f20080e7          	jalr	-224(ra) # 80004428 <iunlock>
      end_op();
    80005510:	00000097          	auipc	ra,0x0
    80005514:	8b6080e7          	jalr	-1866(ra) # 80004dc6 <end_op>

      if(r != n1){
    80005518:	02999563          	bne	s3,s1,80005542 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    8000551c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80005520:	015a5963          	bge	s4,s5,80005532 <filewrite+0xf0>
      int n1 = n - i;
    80005524:	414a87bb          	subw	a5,s5,s4
    80005528:	89be                	mv	s3,a5
      if(n1 > max)
    8000552a:	f8fbdee3          	bge	s7,a5,800054c6 <filewrite+0x84>
    8000552e:	89e6                	mv	s3,s9
    80005530:	bf59                	j	800054c6 <filewrite+0x84>
    80005532:	64a6                	ld	s1,72(sp)
    80005534:	79e2                	ld	s3,56(sp)
    80005536:	6be2                	ld	s7,24(sp)
    80005538:	6c42                	ld	s8,16(sp)
    8000553a:	6ca2                	ld	s9,8(sp)
    8000553c:	a801                	j	8000554c <filewrite+0x10a>
    int i = 0;
    8000553e:	4a01                	li	s4,0
    80005540:	a031                	j	8000554c <filewrite+0x10a>
    80005542:	64a6                	ld	s1,72(sp)
    80005544:	79e2                	ld	s3,56(sp)
    80005546:	6be2                	ld	s7,24(sp)
    80005548:	6c42                	ld	s8,16(sp)
    8000554a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000554c:	034a9f63          	bne	s5,s4,8000558a <filewrite+0x148>
    80005550:	8556                	mv	a0,s5
    80005552:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005554:	60e6                	ld	ra,88(sp)
    80005556:	6446                	ld	s0,80(sp)
    80005558:	6906                	ld	s2,64(sp)
    8000555a:	7aa2                	ld	s5,40(sp)
    8000555c:	7b02                	ld	s6,32(sp)
    8000555e:	6125                	addi	sp,sp,96
    80005560:	8082                	ret
    80005562:	e4a6                	sd	s1,72(sp)
    80005564:	fc4e                	sd	s3,56(sp)
    80005566:	f852                	sd	s4,48(sp)
    80005568:	ec5e                	sd	s7,24(sp)
    8000556a:	e862                	sd	s8,16(sp)
    8000556c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000556e:	00004517          	auipc	a0,0x4
    80005572:	12250513          	addi	a0,a0,290 # 80009690 <etext+0x690>
    80005576:	ffffb097          	auipc	ra,0xffffb
    8000557a:	fea080e7          	jalr	-22(ra) # 80000560 <panic>
    return -1;
    8000557e:	557d                	li	a0,-1
}
    80005580:	8082                	ret
      return -1;
    80005582:	557d                	li	a0,-1
    80005584:	bfc1                	j	80005554 <filewrite+0x112>
    80005586:	557d                	li	a0,-1
    80005588:	b7f1                	j	80005554 <filewrite+0x112>
    ret = (i == n ? n : -1);
    8000558a:	557d                	li	a0,-1
    8000558c:	7a42                	ld	s4,48(sp)
    8000558e:	b7d9                	j	80005554 <filewrite+0x112>

0000000080005590 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005590:	7179                	addi	sp,sp,-48
    80005592:	f406                	sd	ra,40(sp)
    80005594:	f022                	sd	s0,32(sp)
    80005596:	ec26                	sd	s1,24(sp)
    80005598:	e052                	sd	s4,0(sp)
    8000559a:	1800                	addi	s0,sp,48
    8000559c:	84aa                	mv	s1,a0
    8000559e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800055a0:	0005b023          	sd	zero,0(a1)
    800055a4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800055a8:	00000097          	auipc	ra,0x0
    800055ac:	bb8080e7          	jalr	-1096(ra) # 80005160 <filealloc>
    800055b0:	e088                	sd	a0,0(s1)
    800055b2:	cd49                	beqz	a0,8000564c <pipealloc+0xbc>
    800055b4:	00000097          	auipc	ra,0x0
    800055b8:	bac080e7          	jalr	-1108(ra) # 80005160 <filealloc>
    800055bc:	00aa3023          	sd	a0,0(s4)
    800055c0:	c141                	beqz	a0,80005640 <pipealloc+0xb0>
    800055c2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800055c4:	ffffb097          	auipc	ra,0xffffb
    800055c8:	640080e7          	jalr	1600(ra) # 80000c04 <kalloc>
    800055cc:	892a                	mv	s2,a0
    800055ce:	c13d                	beqz	a0,80005634 <pipealloc+0xa4>
    800055d0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800055d2:	4985                	li	s3,1
    800055d4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800055d8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800055dc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800055e0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800055e4:	00004597          	auipc	a1,0x4
    800055e8:	0bc58593          	addi	a1,a1,188 # 800096a0 <etext+0x6a0>
    800055ec:	ffffb097          	auipc	ra,0xffffb
    800055f0:	696080e7          	jalr	1686(ra) # 80000c82 <initlock>
  (*f0)->type = FD_PIPE;
    800055f4:	609c                	ld	a5,0(s1)
    800055f6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800055fa:	609c                	ld	a5,0(s1)
    800055fc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005600:	609c                	ld	a5,0(s1)
    80005602:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80005606:	609c                	ld	a5,0(s1)
    80005608:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000560c:	000a3783          	ld	a5,0(s4)
    80005610:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80005614:	000a3783          	ld	a5,0(s4)
    80005618:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000561c:	000a3783          	ld	a5,0(s4)
    80005620:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80005624:	000a3783          	ld	a5,0(s4)
    80005628:	0127b823          	sd	s2,16(a5)
  return 0;
    8000562c:	4501                	li	a0,0
    8000562e:	6942                	ld	s2,16(sp)
    80005630:	69a2                	ld	s3,8(sp)
    80005632:	a03d                	j	80005660 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005634:	6088                	ld	a0,0(s1)
    80005636:	c119                	beqz	a0,8000563c <pipealloc+0xac>
    80005638:	6942                	ld	s2,16(sp)
    8000563a:	a029                	j	80005644 <pipealloc+0xb4>
    8000563c:	6942                	ld	s2,16(sp)
    8000563e:	a039                	j	8000564c <pipealloc+0xbc>
    80005640:	6088                	ld	a0,0(s1)
    80005642:	c50d                	beqz	a0,8000566c <pipealloc+0xdc>
    fileclose(*f0);
    80005644:	00000097          	auipc	ra,0x0
    80005648:	bd8080e7          	jalr	-1064(ra) # 8000521c <fileclose>
  if(*f1)
    8000564c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005650:	557d                	li	a0,-1
  if(*f1)
    80005652:	c799                	beqz	a5,80005660 <pipealloc+0xd0>
    fileclose(*f1);
    80005654:	853e                	mv	a0,a5
    80005656:	00000097          	auipc	ra,0x0
    8000565a:	bc6080e7          	jalr	-1082(ra) # 8000521c <fileclose>
  return -1;
    8000565e:	557d                	li	a0,-1
}
    80005660:	70a2                	ld	ra,40(sp)
    80005662:	7402                	ld	s0,32(sp)
    80005664:	64e2                	ld	s1,24(sp)
    80005666:	6a02                	ld	s4,0(sp)
    80005668:	6145                	addi	sp,sp,48
    8000566a:	8082                	ret
  return -1;
    8000566c:	557d                	li	a0,-1
    8000566e:	bfcd                	j	80005660 <pipealloc+0xd0>

0000000080005670 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005670:	1101                	addi	sp,sp,-32
    80005672:	ec06                	sd	ra,24(sp)
    80005674:	e822                	sd	s0,16(sp)
    80005676:	e426                	sd	s1,8(sp)
    80005678:	e04a                	sd	s2,0(sp)
    8000567a:	1000                	addi	s0,sp,32
    8000567c:	84aa                	mv	s1,a0
    8000567e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005680:	ffffb097          	auipc	ra,0xffffb
    80005684:	696080e7          	jalr	1686(ra) # 80000d16 <acquire>
  if(writable){
    80005688:	02090d63          	beqz	s2,800056c2 <pipeclose+0x52>
    pi->writeopen = 0;
    8000568c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005690:	21848513          	addi	a0,s1,536
    80005694:	ffffd097          	auipc	ra,0xffffd
    80005698:	1fa080e7          	jalr	506(ra) # 8000288e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000569c:	2204b783          	ld	a5,544(s1)
    800056a0:	eb95                	bnez	a5,800056d4 <pipeclose+0x64>
    release(&pi->lock);
    800056a2:	8526                	mv	a0,s1
    800056a4:	ffffb097          	auipc	ra,0xffffb
    800056a8:	722080e7          	jalr	1826(ra) # 80000dc6 <release>
    kfree((char*)pi);
    800056ac:	8526                	mv	a0,s1
    800056ae:	ffffb097          	auipc	ra,0xffffb
    800056b2:	3ee080e7          	jalr	1006(ra) # 80000a9c <kfree>
  } else
    release(&pi->lock);
}
    800056b6:	60e2                	ld	ra,24(sp)
    800056b8:	6442                	ld	s0,16(sp)
    800056ba:	64a2                	ld	s1,8(sp)
    800056bc:	6902                	ld	s2,0(sp)
    800056be:	6105                	addi	sp,sp,32
    800056c0:	8082                	ret
    pi->readopen = 0;
    800056c2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800056c6:	21c48513          	addi	a0,s1,540
    800056ca:	ffffd097          	auipc	ra,0xffffd
    800056ce:	1c4080e7          	jalr	452(ra) # 8000288e <wakeup>
    800056d2:	b7e9                	j	8000569c <pipeclose+0x2c>
    release(&pi->lock);
    800056d4:	8526                	mv	a0,s1
    800056d6:	ffffb097          	auipc	ra,0xffffb
    800056da:	6f0080e7          	jalr	1776(ra) # 80000dc6 <release>
}
    800056de:	bfe1                	j	800056b6 <pipeclose+0x46>

00000000800056e0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800056e0:	7159                	addi	sp,sp,-112
    800056e2:	f486                	sd	ra,104(sp)
    800056e4:	f0a2                	sd	s0,96(sp)
    800056e6:	eca6                	sd	s1,88(sp)
    800056e8:	e8ca                	sd	s2,80(sp)
    800056ea:	e4ce                	sd	s3,72(sp)
    800056ec:	e0d2                	sd	s4,64(sp)
    800056ee:	fc56                	sd	s5,56(sp)
    800056f0:	1880                	addi	s0,sp,112
    800056f2:	84aa                	mv	s1,a0
    800056f4:	8aae                	mv	s5,a1
    800056f6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800056f8:	ffffd097          	auipc	ra,0xffffd
    800056fc:	82a080e7          	jalr	-2006(ra) # 80001f22 <myproc>
    80005700:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005702:	8526                	mv	a0,s1
    80005704:	ffffb097          	auipc	ra,0xffffb
    80005708:	612080e7          	jalr	1554(ra) # 80000d16 <acquire>
  while(i < n){
    8000570c:	0f405063          	blez	s4,800057ec <pipewrite+0x10c>
    80005710:	f85a                	sd	s6,48(sp)
    80005712:	f45e                	sd	s7,40(sp)
    80005714:	f062                	sd	s8,32(sp)
    80005716:	ec66                	sd	s9,24(sp)
    80005718:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000571a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000571c:	f9f40c13          	addi	s8,s0,-97
    80005720:	4b85                	li	s7,1
    80005722:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80005724:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005728:	21c48c93          	addi	s9,s1,540
    8000572c:	a099                	j	80005772 <pipewrite+0x92>
      release(&pi->lock);
    8000572e:	8526                	mv	a0,s1
    80005730:	ffffb097          	auipc	ra,0xffffb
    80005734:	696080e7          	jalr	1686(ra) # 80000dc6 <release>
      return -1;
    80005738:	597d                	li	s2,-1
    8000573a:	7b42                	ld	s6,48(sp)
    8000573c:	7ba2                	ld	s7,40(sp)
    8000573e:	7c02                	ld	s8,32(sp)
    80005740:	6ce2                	ld	s9,24(sp)
    80005742:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005744:	854a                	mv	a0,s2
    80005746:	70a6                	ld	ra,104(sp)
    80005748:	7406                	ld	s0,96(sp)
    8000574a:	64e6                	ld	s1,88(sp)
    8000574c:	6946                	ld	s2,80(sp)
    8000574e:	69a6                	ld	s3,72(sp)
    80005750:	6a06                	ld	s4,64(sp)
    80005752:	7ae2                	ld	s5,56(sp)
    80005754:	6165                	addi	sp,sp,112
    80005756:	8082                	ret
      wakeup(&pi->nread);
    80005758:	856a                	mv	a0,s10
    8000575a:	ffffd097          	auipc	ra,0xffffd
    8000575e:	134080e7          	jalr	308(ra) # 8000288e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005762:	85a6                	mv	a1,s1
    80005764:	8566                	mv	a0,s9
    80005766:	ffffd097          	auipc	ra,0xffffd
    8000576a:	0c4080e7          	jalr	196(ra) # 8000282a <sleep>
  while(i < n){
    8000576e:	05495e63          	bge	s2,s4,800057ca <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    80005772:	2204a783          	lw	a5,544(s1)
    80005776:	dfc5                	beqz	a5,8000572e <pipewrite+0x4e>
    80005778:	854e                	mv	a0,s3
    8000577a:	ffffd097          	auipc	ra,0xffffd
    8000577e:	4d6080e7          	jalr	1238(ra) # 80002c50 <killed>
    80005782:	f555                	bnez	a0,8000572e <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005784:	2184a783          	lw	a5,536(s1)
    80005788:	21c4a703          	lw	a4,540(s1)
    8000578c:	2007879b          	addiw	a5,a5,512
    80005790:	fcf704e3          	beq	a4,a5,80005758 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005794:	86de                	mv	a3,s7
    80005796:	01590633          	add	a2,s2,s5
    8000579a:	85e2                	mv	a1,s8
    8000579c:	0509b503          	ld	a0,80(s3)
    800057a0:	ffffc097          	auipc	ra,0xffffc
    800057a4:	4b6080e7          	jalr	1206(ra) # 80001c56 <copyin>
    800057a8:	05650463          	beq	a0,s6,800057f0 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800057ac:	21c4a783          	lw	a5,540(s1)
    800057b0:	0017871b          	addiw	a4,a5,1
    800057b4:	20e4ae23          	sw	a4,540(s1)
    800057b8:	1ff7f793          	andi	a5,a5,511
    800057bc:	97a6                	add	a5,a5,s1
    800057be:	f9f44703          	lbu	a4,-97(s0)
    800057c2:	00e78c23          	sb	a4,24(a5)
      i++;
    800057c6:	2905                	addiw	s2,s2,1
    800057c8:	b75d                	j	8000576e <pipewrite+0x8e>
    800057ca:	7b42                	ld	s6,48(sp)
    800057cc:	7ba2                	ld	s7,40(sp)
    800057ce:	7c02                	ld	s8,32(sp)
    800057d0:	6ce2                	ld	s9,24(sp)
    800057d2:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800057d4:	21848513          	addi	a0,s1,536
    800057d8:	ffffd097          	auipc	ra,0xffffd
    800057dc:	0b6080e7          	jalr	182(ra) # 8000288e <wakeup>
  release(&pi->lock);
    800057e0:	8526                	mv	a0,s1
    800057e2:	ffffb097          	auipc	ra,0xffffb
    800057e6:	5e4080e7          	jalr	1508(ra) # 80000dc6 <release>
  return i;
    800057ea:	bfa9                	j	80005744 <pipewrite+0x64>
  int i = 0;
    800057ec:	4901                	li	s2,0
    800057ee:	b7dd                	j	800057d4 <pipewrite+0xf4>
    800057f0:	7b42                	ld	s6,48(sp)
    800057f2:	7ba2                	ld	s7,40(sp)
    800057f4:	7c02                	ld	s8,32(sp)
    800057f6:	6ce2                	ld	s9,24(sp)
    800057f8:	6d42                	ld	s10,16(sp)
    800057fa:	bfe9                	j	800057d4 <pipewrite+0xf4>

00000000800057fc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800057fc:	711d                	addi	sp,sp,-96
    800057fe:	ec86                	sd	ra,88(sp)
    80005800:	e8a2                	sd	s0,80(sp)
    80005802:	e4a6                	sd	s1,72(sp)
    80005804:	e0ca                	sd	s2,64(sp)
    80005806:	fc4e                	sd	s3,56(sp)
    80005808:	f852                	sd	s4,48(sp)
    8000580a:	f456                	sd	s5,40(sp)
    8000580c:	1080                	addi	s0,sp,96
    8000580e:	84aa                	mv	s1,a0
    80005810:	892e                	mv	s2,a1
    80005812:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005814:	ffffc097          	auipc	ra,0xffffc
    80005818:	70e080e7          	jalr	1806(ra) # 80001f22 <myproc>
    8000581c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000581e:	8526                	mv	a0,s1
    80005820:	ffffb097          	auipc	ra,0xffffb
    80005824:	4f6080e7          	jalr	1270(ra) # 80000d16 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005828:	2184a703          	lw	a4,536(s1)
    8000582c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005830:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005834:	02f71b63          	bne	a4,a5,8000586a <piperead+0x6e>
    80005838:	2244a783          	lw	a5,548(s1)
    8000583c:	c3b1                	beqz	a5,80005880 <piperead+0x84>
    if(killed(pr)){
    8000583e:	8552                	mv	a0,s4
    80005840:	ffffd097          	auipc	ra,0xffffd
    80005844:	410080e7          	jalr	1040(ra) # 80002c50 <killed>
    80005848:	e50d                	bnez	a0,80005872 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000584a:	85a6                	mv	a1,s1
    8000584c:	854e                	mv	a0,s3
    8000584e:	ffffd097          	auipc	ra,0xffffd
    80005852:	fdc080e7          	jalr	-36(ra) # 8000282a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005856:	2184a703          	lw	a4,536(s1)
    8000585a:	21c4a783          	lw	a5,540(s1)
    8000585e:	fcf70de3          	beq	a4,a5,80005838 <piperead+0x3c>
    80005862:	f05a                	sd	s6,32(sp)
    80005864:	ec5e                	sd	s7,24(sp)
    80005866:	e862                	sd	s8,16(sp)
    80005868:	a839                	j	80005886 <piperead+0x8a>
    8000586a:	f05a                	sd	s6,32(sp)
    8000586c:	ec5e                	sd	s7,24(sp)
    8000586e:	e862                	sd	s8,16(sp)
    80005870:	a819                	j	80005886 <piperead+0x8a>
      release(&pi->lock);
    80005872:	8526                	mv	a0,s1
    80005874:	ffffb097          	auipc	ra,0xffffb
    80005878:	552080e7          	jalr	1362(ra) # 80000dc6 <release>
      return -1;
    8000587c:	59fd                	li	s3,-1
    8000587e:	a895                	j	800058f2 <piperead+0xf6>
    80005880:	f05a                	sd	s6,32(sp)
    80005882:	ec5e                	sd	s7,24(sp)
    80005884:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005886:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005888:	faf40c13          	addi	s8,s0,-81
    8000588c:	4b85                	li	s7,1
    8000588e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005890:	05505363          	blez	s5,800058d6 <piperead+0xda>
    if(pi->nread == pi->nwrite)
    80005894:	2184a783          	lw	a5,536(s1)
    80005898:	21c4a703          	lw	a4,540(s1)
    8000589c:	02f70d63          	beq	a4,a5,800058d6 <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800058a0:	0017871b          	addiw	a4,a5,1
    800058a4:	20e4ac23          	sw	a4,536(s1)
    800058a8:	1ff7f793          	andi	a5,a5,511
    800058ac:	97a6                	add	a5,a5,s1
    800058ae:	0187c783          	lbu	a5,24(a5)
    800058b2:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800058b6:	86de                	mv	a3,s7
    800058b8:	8662                	mv	a2,s8
    800058ba:	85ca                	mv	a1,s2
    800058bc:	050a3503          	ld	a0,80(s4)
    800058c0:	ffffc097          	auipc	ra,0xffffc
    800058c4:	30a080e7          	jalr	778(ra) # 80001bca <copyout>
    800058c8:	01650763          	beq	a0,s6,800058d6 <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800058cc:	2985                	addiw	s3,s3,1
    800058ce:	0905                	addi	s2,s2,1
    800058d0:	fd3a92e3          	bne	s5,s3,80005894 <piperead+0x98>
    800058d4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800058d6:	21c48513          	addi	a0,s1,540
    800058da:	ffffd097          	auipc	ra,0xffffd
    800058de:	fb4080e7          	jalr	-76(ra) # 8000288e <wakeup>
  release(&pi->lock);
    800058e2:	8526                	mv	a0,s1
    800058e4:	ffffb097          	auipc	ra,0xffffb
    800058e8:	4e2080e7          	jalr	1250(ra) # 80000dc6 <release>
    800058ec:	7b02                	ld	s6,32(sp)
    800058ee:	6be2                	ld	s7,24(sp)
    800058f0:	6c42                	ld	s8,16(sp)
  return i;
}
    800058f2:	854e                	mv	a0,s3
    800058f4:	60e6                	ld	ra,88(sp)
    800058f6:	6446                	ld	s0,80(sp)
    800058f8:	64a6                	ld	s1,72(sp)
    800058fa:	6906                	ld	s2,64(sp)
    800058fc:	79e2                	ld	s3,56(sp)
    800058fe:	7a42                	ld	s4,48(sp)
    80005900:	7aa2                	ld	s5,40(sp)
    80005902:	6125                	addi	sp,sp,96
    80005904:	8082                	ret

0000000080005906 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005906:	1141                	addi	sp,sp,-16
    80005908:	e406                	sd	ra,8(sp)
    8000590a:	e022                	sd	s0,0(sp)
    8000590c:	0800                	addi	s0,sp,16
    8000590e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005910:	0035151b          	slliw	a0,a0,0x3
    80005914:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80005916:	8b89                	andi	a5,a5,2
    80005918:	c399                	beqz	a5,8000591e <flags2perm+0x18>
      perm |= PTE_W;
    8000591a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000591e:	60a2                	ld	ra,8(sp)
    80005920:	6402                	ld	s0,0(sp)
    80005922:	0141                	addi	sp,sp,16
    80005924:	8082                	ret

0000000080005926 <exec>:

int
exec(char *path, char **argv)
{
    80005926:	de010113          	addi	sp,sp,-544
    8000592a:	20113c23          	sd	ra,536(sp)
    8000592e:	20813823          	sd	s0,528(sp)
    80005932:	20913423          	sd	s1,520(sp)
    80005936:	21213023          	sd	s2,512(sp)
    8000593a:	1400                	addi	s0,sp,544
    8000593c:	892a                	mv	s2,a0
    8000593e:	dea43823          	sd	a0,-528(s0)
    80005942:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005946:	ffffc097          	auipc	ra,0xffffc
    8000594a:	5dc080e7          	jalr	1500(ra) # 80001f22 <myproc>
    8000594e:	84aa                	mv	s1,a0

  begin_op();
    80005950:	fffff097          	auipc	ra,0xfffff
    80005954:	3fc080e7          	jalr	1020(ra) # 80004d4c <begin_op>

  if((ip = namei(path)) == 0){
    80005958:	854a                	mv	a0,s2
    8000595a:	fffff097          	auipc	ra,0xfffff
    8000595e:	1ec080e7          	jalr	492(ra) # 80004b46 <namei>
    80005962:	c525                	beqz	a0,800059ca <exec+0xa4>
    80005964:	fbd2                	sd	s4,496(sp)
    80005966:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005968:	fffff097          	auipc	ra,0xfffff
    8000596c:	9fa080e7          	jalr	-1542(ra) # 80004362 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005970:	04000713          	li	a4,64
    80005974:	4681                	li	a3,0
    80005976:	e5040613          	addi	a2,s0,-432
    8000597a:	4581                	li	a1,0
    8000597c:	8552                	mv	a0,s4
    8000597e:	fffff097          	auipc	ra,0xfffff
    80005982:	ca0080e7          	jalr	-864(ra) # 8000461e <readi>
    80005986:	04000793          	li	a5,64
    8000598a:	00f51a63          	bne	a0,a5,8000599e <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000598e:	e5042703          	lw	a4,-432(s0)
    80005992:	464c47b7          	lui	a5,0x464c4
    80005996:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000599a:	02f70e63          	beq	a4,a5,800059d6 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000599e:	8552                	mv	a0,s4
    800059a0:	fffff097          	auipc	ra,0xfffff
    800059a4:	c28080e7          	jalr	-984(ra) # 800045c8 <iunlockput>
    end_op();
    800059a8:	fffff097          	auipc	ra,0xfffff
    800059ac:	41e080e7          	jalr	1054(ra) # 80004dc6 <end_op>
  }
  return -1;
    800059b0:	557d                	li	a0,-1
    800059b2:	7a5e                	ld	s4,496(sp)
}
    800059b4:	21813083          	ld	ra,536(sp)
    800059b8:	21013403          	ld	s0,528(sp)
    800059bc:	20813483          	ld	s1,520(sp)
    800059c0:	20013903          	ld	s2,512(sp)
    800059c4:	22010113          	addi	sp,sp,544
    800059c8:	8082                	ret
    end_op();
    800059ca:	fffff097          	auipc	ra,0xfffff
    800059ce:	3fc080e7          	jalr	1020(ra) # 80004dc6 <end_op>
    return -1;
    800059d2:	557d                	li	a0,-1
    800059d4:	b7c5                	j	800059b4 <exec+0x8e>
    800059d6:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800059d8:	8526                	mv	a0,s1
    800059da:	ffffc097          	auipc	ra,0xffffc
    800059de:	60c080e7          	jalr	1548(ra) # 80001fe6 <proc_pagetable>
    800059e2:	8b2a                	mv	s6,a0
    800059e4:	2c050163          	beqz	a0,80005ca6 <exec+0x380>
    800059e8:	ffce                	sd	s3,504(sp)
    800059ea:	f7d6                	sd	s5,488(sp)
    800059ec:	efde                	sd	s7,472(sp)
    800059ee:	ebe2                	sd	s8,464(sp)
    800059f0:	e7e6                	sd	s9,456(sp)
    800059f2:	e3ea                	sd	s10,448(sp)
    800059f4:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800059f6:	e7042683          	lw	a3,-400(s0)
    800059fa:	e8845783          	lhu	a5,-376(s0)
    800059fe:	10078363          	beqz	a5,80005b04 <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005a02:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005a04:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005a06:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80005a0a:	6c85                	lui	s9,0x1
    80005a0c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005a10:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005a14:	6a85                	lui	s5,0x1
    80005a16:	a0b5                	j	80005a82 <exec+0x15c>
      panic("loadseg: address should exist");
    80005a18:	00004517          	auipc	a0,0x4
    80005a1c:	c9050513          	addi	a0,a0,-880 # 800096a8 <etext+0x6a8>
    80005a20:	ffffb097          	auipc	ra,0xffffb
    80005a24:	b40080e7          	jalr	-1216(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005a28:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005a2a:	874a                	mv	a4,s2
    80005a2c:	009c06bb          	addw	a3,s8,s1
    80005a30:	4581                	li	a1,0
    80005a32:	8552                	mv	a0,s4
    80005a34:	fffff097          	auipc	ra,0xfffff
    80005a38:	bea080e7          	jalr	-1046(ra) # 8000461e <readi>
    80005a3c:	26a91963          	bne	s2,a0,80005cae <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    80005a40:	009a84bb          	addw	s1,s5,s1
    80005a44:	0334f463          	bgeu	s1,s3,80005a6c <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    80005a48:	02049593          	slli	a1,s1,0x20
    80005a4c:	9181                	srli	a1,a1,0x20
    80005a4e:	95de                	add	a1,a1,s7
    80005a50:	855a                	mv	a0,s6
    80005a52:	ffffc097          	auipc	ra,0xffffc
    80005a56:	83e080e7          	jalr	-1986(ra) # 80001290 <walkaddr>
    80005a5a:	862a                	mv	a2,a0
    if(pa == 0)
    80005a5c:	dd55                	beqz	a0,80005a18 <exec+0xf2>
    if(sz - i < PGSIZE)
    80005a5e:	409987bb          	subw	a5,s3,s1
    80005a62:	893e                	mv	s2,a5
    80005a64:	fcfcf2e3          	bgeu	s9,a5,80005a28 <exec+0x102>
    80005a68:	8956                	mv	s2,s5
    80005a6a:	bf7d                	j	80005a28 <exec+0x102>
    sz = sz1;
    80005a6c:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005a70:	2d05                	addiw	s10,s10,1
    80005a72:	e0843783          	ld	a5,-504(s0)
    80005a76:	0387869b          	addiw	a3,a5,56
    80005a7a:	e8845783          	lhu	a5,-376(s0)
    80005a7e:	08fd5463          	bge	s10,a5,80005b06 <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005a82:	e0d43423          	sd	a3,-504(s0)
    80005a86:	876e                	mv	a4,s11
    80005a88:	e1840613          	addi	a2,s0,-488
    80005a8c:	4581                	li	a1,0
    80005a8e:	8552                	mv	a0,s4
    80005a90:	fffff097          	auipc	ra,0xfffff
    80005a94:	b8e080e7          	jalr	-1138(ra) # 8000461e <readi>
    80005a98:	21b51963          	bne	a0,s11,80005caa <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    80005a9c:	e1842783          	lw	a5,-488(s0)
    80005aa0:	4705                	li	a4,1
    80005aa2:	fce797e3          	bne	a5,a4,80005a70 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    80005aa6:	e4043483          	ld	s1,-448(s0)
    80005aaa:	e3843783          	ld	a5,-456(s0)
    80005aae:	22f4e063          	bltu	s1,a5,80005cce <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005ab2:	e2843783          	ld	a5,-472(s0)
    80005ab6:	94be                	add	s1,s1,a5
    80005ab8:	20f4ee63          	bltu	s1,a5,80005cd4 <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    80005abc:	de843703          	ld	a4,-536(s0)
    80005ac0:	8ff9                	and	a5,a5,a4
    80005ac2:	20079c63          	bnez	a5,80005cda <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005ac6:	e1c42503          	lw	a0,-484(s0)
    80005aca:	00000097          	auipc	ra,0x0
    80005ace:	e3c080e7          	jalr	-452(ra) # 80005906 <flags2perm>
    80005ad2:	86aa                	mv	a3,a0
    80005ad4:	8626                	mv	a2,s1
    80005ad6:	85ca                	mv	a1,s2
    80005ad8:	855a                	mv	a0,s6
    80005ada:	ffffc097          	auipc	ra,0xffffc
    80005ade:	b8e080e7          	jalr	-1138(ra) # 80001668 <uvmalloc>
    80005ae2:	dea43c23          	sd	a0,-520(s0)
    80005ae6:	1e050d63          	beqz	a0,80005ce0 <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005aea:	e2843b83          	ld	s7,-472(s0)
    80005aee:	e2042c03          	lw	s8,-480(s0)
    80005af2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005af6:	00098463          	beqz	s3,80005afe <exec+0x1d8>
    80005afa:	4481                	li	s1,0
    80005afc:	b7b1                	j	80005a48 <exec+0x122>
    sz = sz1;
    80005afe:	df843903          	ld	s2,-520(s0)
    80005b02:	b7bd                	j	80005a70 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005b04:	4901                	li	s2,0
  iunlockput(ip);
    80005b06:	8552                	mv	a0,s4
    80005b08:	fffff097          	auipc	ra,0xfffff
    80005b0c:	ac0080e7          	jalr	-1344(ra) # 800045c8 <iunlockput>
  end_op();
    80005b10:	fffff097          	auipc	ra,0xfffff
    80005b14:	2b6080e7          	jalr	694(ra) # 80004dc6 <end_op>
  p = myproc();
    80005b18:	ffffc097          	auipc	ra,0xffffc
    80005b1c:	40a080e7          	jalr	1034(ra) # 80001f22 <myproc>
    80005b20:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005b22:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005b26:	6985                	lui	s3,0x1
    80005b28:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005b2a:	99ca                	add	s3,s3,s2
    80005b2c:	77fd                	lui	a5,0xfffff
    80005b2e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005b32:	4691                	li	a3,4
    80005b34:	6609                	lui	a2,0x2
    80005b36:	964e                	add	a2,a2,s3
    80005b38:	85ce                	mv	a1,s3
    80005b3a:	855a                	mv	a0,s6
    80005b3c:	ffffc097          	auipc	ra,0xffffc
    80005b40:	b2c080e7          	jalr	-1236(ra) # 80001668 <uvmalloc>
    80005b44:	8a2a                	mv	s4,a0
    80005b46:	e115                	bnez	a0,80005b6a <exec+0x244>
    proc_freepagetable(pagetable, sz);
    80005b48:	85ce                	mv	a1,s3
    80005b4a:	855a                	mv	a0,s6
    80005b4c:	ffffc097          	auipc	ra,0xffffc
    80005b50:	536080e7          	jalr	1334(ra) # 80002082 <proc_freepagetable>
  return -1;
    80005b54:	557d                	li	a0,-1
    80005b56:	79fe                	ld	s3,504(sp)
    80005b58:	7a5e                	ld	s4,496(sp)
    80005b5a:	7abe                	ld	s5,488(sp)
    80005b5c:	7b1e                	ld	s6,480(sp)
    80005b5e:	6bfe                	ld	s7,472(sp)
    80005b60:	6c5e                	ld	s8,464(sp)
    80005b62:	6cbe                	ld	s9,456(sp)
    80005b64:	6d1e                	ld	s10,448(sp)
    80005b66:	7dfa                	ld	s11,440(sp)
    80005b68:	b5b1                	j	800059b4 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005b6a:	75f9                	lui	a1,0xffffe
    80005b6c:	95aa                	add	a1,a1,a0
    80005b6e:	855a                	mv	a0,s6
    80005b70:	ffffc097          	auipc	ra,0xffffc
    80005b74:	028080e7          	jalr	40(ra) # 80001b98 <uvmclear>
  stackbase = sp - PGSIZE;
    80005b78:	7bfd                	lui	s7,0xfffff
    80005b7a:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80005b7c:	e0043783          	ld	a5,-512(s0)
    80005b80:	6388                	ld	a0,0(a5)
  sp = sz;
    80005b82:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80005b84:	4481                	li	s1,0
    ustack[argc] = sp;
    80005b86:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005b8a:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005b8e:	c135                	beqz	a0,80005bf2 <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    80005b90:	ffffb097          	auipc	ra,0xffffb
    80005b94:	40a080e7          	jalr	1034(ra) # 80000f9a <strlen>
    80005b98:	0015079b          	addiw	a5,a0,1
    80005b9c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005ba0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005ba4:	15796163          	bltu	s2,s7,80005ce6 <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005ba8:	e0043d83          	ld	s11,-512(s0)
    80005bac:	000db983          	ld	s3,0(s11)
    80005bb0:	854e                	mv	a0,s3
    80005bb2:	ffffb097          	auipc	ra,0xffffb
    80005bb6:	3e8080e7          	jalr	1000(ra) # 80000f9a <strlen>
    80005bba:	0015069b          	addiw	a3,a0,1
    80005bbe:	864e                	mv	a2,s3
    80005bc0:	85ca                	mv	a1,s2
    80005bc2:	855a                	mv	a0,s6
    80005bc4:	ffffc097          	auipc	ra,0xffffc
    80005bc8:	006080e7          	jalr	6(ra) # 80001bca <copyout>
    80005bcc:	10054f63          	bltz	a0,80005cea <exec+0x3c4>
    ustack[argc] = sp;
    80005bd0:	00349793          	slli	a5,s1,0x3
    80005bd4:	97e6                	add	a5,a5,s9
    80005bd6:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ff90d68>
  for(argc = 0; argv[argc]; argc++) {
    80005bda:	0485                	addi	s1,s1,1
    80005bdc:	008d8793          	addi	a5,s11,8
    80005be0:	e0f43023          	sd	a5,-512(s0)
    80005be4:	008db503          	ld	a0,8(s11)
    80005be8:	c509                	beqz	a0,80005bf2 <exec+0x2cc>
    if(argc >= MAXARG)
    80005bea:	fb8493e3          	bne	s1,s8,80005b90 <exec+0x26a>
  sz = sz1;
    80005bee:	89d2                	mv	s3,s4
    80005bf0:	bfa1                	j	80005b48 <exec+0x222>
  ustack[argc] = 0;
    80005bf2:	00349793          	slli	a5,s1,0x3
    80005bf6:	f9078793          	addi	a5,a5,-112
    80005bfa:	97a2                	add	a5,a5,s0
    80005bfc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005c00:	00148693          	addi	a3,s1,1
    80005c04:	068e                	slli	a3,a3,0x3
    80005c06:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005c0a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005c0e:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005c10:	f3796ce3          	bltu	s2,s7,80005b48 <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005c14:	e9040613          	addi	a2,s0,-368
    80005c18:	85ca                	mv	a1,s2
    80005c1a:	855a                	mv	a0,s6
    80005c1c:	ffffc097          	auipc	ra,0xffffc
    80005c20:	fae080e7          	jalr	-82(ra) # 80001bca <copyout>
    80005c24:	f20542e3          	bltz	a0,80005b48 <exec+0x222>
  p->trapframe->a1 = sp;
    80005c28:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005c2c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005c30:	df043783          	ld	a5,-528(s0)
    80005c34:	0007c703          	lbu	a4,0(a5)
    80005c38:	cf11                	beqz	a4,80005c54 <exec+0x32e>
    80005c3a:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005c3c:	02f00693          	li	a3,47
    80005c40:	a029                	j	80005c4a <exec+0x324>
  for(last=s=path; *s; s++)
    80005c42:	0785                	addi	a5,a5,1
    80005c44:	fff7c703          	lbu	a4,-1(a5)
    80005c48:	c711                	beqz	a4,80005c54 <exec+0x32e>
    if(*s == '/')
    80005c4a:	fed71ce3          	bne	a4,a3,80005c42 <exec+0x31c>
      last = s+1;
    80005c4e:	def43823          	sd	a5,-528(s0)
    80005c52:	bfc5                	j	80005c42 <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005c54:	4641                	li	a2,16
    80005c56:	df043583          	ld	a1,-528(s0)
    80005c5a:	158a8513          	addi	a0,s5,344
    80005c5e:	ffffb097          	auipc	ra,0xffffb
    80005c62:	306080e7          	jalr	774(ra) # 80000f64 <safestrcpy>
  oldpagetable = p->pagetable;
    80005c66:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005c6a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005c6e:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005c72:	058ab783          	ld	a5,88(s5)
    80005c76:	e6843703          	ld	a4,-408(s0)
    80005c7a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005c7c:	058ab783          	ld	a5,88(s5)
    80005c80:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005c84:	85ea                	mv	a1,s10
    80005c86:	ffffc097          	auipc	ra,0xffffc
    80005c8a:	3fc080e7          	jalr	1020(ra) # 80002082 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005c8e:	0004851b          	sext.w	a0,s1
    80005c92:	79fe                	ld	s3,504(sp)
    80005c94:	7a5e                	ld	s4,496(sp)
    80005c96:	7abe                	ld	s5,488(sp)
    80005c98:	7b1e                	ld	s6,480(sp)
    80005c9a:	6bfe                	ld	s7,472(sp)
    80005c9c:	6c5e                	ld	s8,464(sp)
    80005c9e:	6cbe                	ld	s9,456(sp)
    80005ca0:	6d1e                	ld	s10,448(sp)
    80005ca2:	7dfa                	ld	s11,440(sp)
    80005ca4:	bb01                	j	800059b4 <exec+0x8e>
    80005ca6:	7b1e                	ld	s6,480(sp)
    80005ca8:	b9dd                	j	8000599e <exec+0x78>
    80005caa:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005cae:	df843583          	ld	a1,-520(s0)
    80005cb2:	855a                	mv	a0,s6
    80005cb4:	ffffc097          	auipc	ra,0xffffc
    80005cb8:	3ce080e7          	jalr	974(ra) # 80002082 <proc_freepagetable>
  if(ip){
    80005cbc:	79fe                	ld	s3,504(sp)
    80005cbe:	7abe                	ld	s5,488(sp)
    80005cc0:	7b1e                	ld	s6,480(sp)
    80005cc2:	6bfe                	ld	s7,472(sp)
    80005cc4:	6c5e                	ld	s8,464(sp)
    80005cc6:	6cbe                	ld	s9,456(sp)
    80005cc8:	6d1e                	ld	s10,448(sp)
    80005cca:	7dfa                	ld	s11,440(sp)
    80005ccc:	b9c9                	j	8000599e <exec+0x78>
    80005cce:	df243c23          	sd	s2,-520(s0)
    80005cd2:	bff1                	j	80005cae <exec+0x388>
    80005cd4:	df243c23          	sd	s2,-520(s0)
    80005cd8:	bfd9                	j	80005cae <exec+0x388>
    80005cda:	df243c23          	sd	s2,-520(s0)
    80005cde:	bfc1                	j	80005cae <exec+0x388>
    80005ce0:	df243c23          	sd	s2,-520(s0)
    80005ce4:	b7e9                	j	80005cae <exec+0x388>
  sz = sz1;
    80005ce6:	89d2                	mv	s3,s4
    80005ce8:	b585                	j	80005b48 <exec+0x222>
    80005cea:	89d2                	mv	s3,s4
    80005cec:	bdb1                	j	80005b48 <exec+0x222>

0000000080005cee <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005cee:	7179                	addi	sp,sp,-48
    80005cf0:	f406                	sd	ra,40(sp)
    80005cf2:	f022                	sd	s0,32(sp)
    80005cf4:	ec26                	sd	s1,24(sp)
    80005cf6:	e84a                	sd	s2,16(sp)
    80005cf8:	1800                	addi	s0,sp,48
    80005cfa:	892e                	mv	s2,a1
    80005cfc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005cfe:	fdc40593          	addi	a1,s0,-36
    80005d02:	ffffe097          	auipc	ra,0xffffe
    80005d06:	894080e7          	jalr	-1900(ra) # 80003596 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005d0a:	fdc42703          	lw	a4,-36(s0)
    80005d0e:	47bd                	li	a5,15
    80005d10:	02e7eb63          	bltu	a5,a4,80005d46 <argfd+0x58>
    80005d14:	ffffc097          	auipc	ra,0xffffc
    80005d18:	20e080e7          	jalr	526(ra) # 80001f22 <myproc>
    80005d1c:	fdc42703          	lw	a4,-36(s0)
    80005d20:	01a70793          	addi	a5,a4,26
    80005d24:	078e                	slli	a5,a5,0x3
    80005d26:	953e                	add	a0,a0,a5
    80005d28:	611c                	ld	a5,0(a0)
    80005d2a:	c385                	beqz	a5,80005d4a <argfd+0x5c>
    return -1;
  if(pfd)
    80005d2c:	00090463          	beqz	s2,80005d34 <argfd+0x46>
    *pfd = fd;
    80005d30:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005d34:	4501                	li	a0,0
  if(pf)
    80005d36:	c091                	beqz	s1,80005d3a <argfd+0x4c>
    *pf = f;
    80005d38:	e09c                	sd	a5,0(s1)
}
    80005d3a:	70a2                	ld	ra,40(sp)
    80005d3c:	7402                	ld	s0,32(sp)
    80005d3e:	64e2                	ld	s1,24(sp)
    80005d40:	6942                	ld	s2,16(sp)
    80005d42:	6145                	addi	sp,sp,48
    80005d44:	8082                	ret
    return -1;
    80005d46:	557d                	li	a0,-1
    80005d48:	bfcd                	j	80005d3a <argfd+0x4c>
    80005d4a:	557d                	li	a0,-1
    80005d4c:	b7fd                	j	80005d3a <argfd+0x4c>

0000000080005d4e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005d4e:	1101                	addi	sp,sp,-32
    80005d50:	ec06                	sd	ra,24(sp)
    80005d52:	e822                	sd	s0,16(sp)
    80005d54:	e426                	sd	s1,8(sp)
    80005d56:	1000                	addi	s0,sp,32
    80005d58:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005d5a:	ffffc097          	auipc	ra,0xffffc
    80005d5e:	1c8080e7          	jalr	456(ra) # 80001f22 <myproc>
    80005d62:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005d64:	0d050793          	addi	a5,a0,208
    80005d68:	4501                	li	a0,0
    80005d6a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005d6c:	6398                	ld	a4,0(a5)
    80005d6e:	cb19                	beqz	a4,80005d84 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005d70:	2505                	addiw	a0,a0,1
    80005d72:	07a1                	addi	a5,a5,8
    80005d74:	fed51ce3          	bne	a0,a3,80005d6c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005d78:	557d                	li	a0,-1
}
    80005d7a:	60e2                	ld	ra,24(sp)
    80005d7c:	6442                	ld	s0,16(sp)
    80005d7e:	64a2                	ld	s1,8(sp)
    80005d80:	6105                	addi	sp,sp,32
    80005d82:	8082                	ret
      p->ofile[fd] = f;
    80005d84:	01a50793          	addi	a5,a0,26
    80005d88:	078e                	slli	a5,a5,0x3
    80005d8a:	963e                	add	a2,a2,a5
    80005d8c:	e204                	sd	s1,0(a2)
      return fd;
    80005d8e:	b7f5                	j	80005d7a <fdalloc+0x2c>

0000000080005d90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005d90:	715d                	addi	sp,sp,-80
    80005d92:	e486                	sd	ra,72(sp)
    80005d94:	e0a2                	sd	s0,64(sp)
    80005d96:	fc26                	sd	s1,56(sp)
    80005d98:	f84a                	sd	s2,48(sp)
    80005d9a:	f44e                	sd	s3,40(sp)
    80005d9c:	ec56                	sd	s5,24(sp)
    80005d9e:	e85a                	sd	s6,16(sp)
    80005da0:	0880                	addi	s0,sp,80
    80005da2:	8b2e                	mv	s6,a1
    80005da4:	89b2                	mv	s3,a2
    80005da6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005da8:	fb040593          	addi	a1,s0,-80
    80005dac:	fffff097          	auipc	ra,0xfffff
    80005db0:	db8080e7          	jalr	-584(ra) # 80004b64 <nameiparent>
    80005db4:	84aa                	mv	s1,a0
    80005db6:	14050e63          	beqz	a0,80005f12 <create+0x182>
    return 0;

  ilock(dp);
    80005dba:	ffffe097          	auipc	ra,0xffffe
    80005dbe:	5a8080e7          	jalr	1448(ra) # 80004362 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005dc2:	4601                	li	a2,0
    80005dc4:	fb040593          	addi	a1,s0,-80
    80005dc8:	8526                	mv	a0,s1
    80005dca:	fffff097          	auipc	ra,0xfffff
    80005dce:	a94080e7          	jalr	-1388(ra) # 8000485e <dirlookup>
    80005dd2:	8aaa                	mv	s5,a0
    80005dd4:	c539                	beqz	a0,80005e22 <create+0x92>
    iunlockput(dp);
    80005dd6:	8526                	mv	a0,s1
    80005dd8:	ffffe097          	auipc	ra,0xffffe
    80005ddc:	7f0080e7          	jalr	2032(ra) # 800045c8 <iunlockput>
    ilock(ip);
    80005de0:	8556                	mv	a0,s5
    80005de2:	ffffe097          	auipc	ra,0xffffe
    80005de6:	580080e7          	jalr	1408(ra) # 80004362 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005dea:	4789                	li	a5,2
    80005dec:	02fb1463          	bne	s6,a5,80005e14 <create+0x84>
    80005df0:	044ad783          	lhu	a5,68(s5)
    80005df4:	37f9                	addiw	a5,a5,-2
    80005df6:	17c2                	slli	a5,a5,0x30
    80005df8:	93c1                	srli	a5,a5,0x30
    80005dfa:	4705                	li	a4,1
    80005dfc:	00f76c63          	bltu	a4,a5,80005e14 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005e00:	8556                	mv	a0,s5
    80005e02:	60a6                	ld	ra,72(sp)
    80005e04:	6406                	ld	s0,64(sp)
    80005e06:	74e2                	ld	s1,56(sp)
    80005e08:	7942                	ld	s2,48(sp)
    80005e0a:	79a2                	ld	s3,40(sp)
    80005e0c:	6ae2                	ld	s5,24(sp)
    80005e0e:	6b42                	ld	s6,16(sp)
    80005e10:	6161                	addi	sp,sp,80
    80005e12:	8082                	ret
    iunlockput(ip);
    80005e14:	8556                	mv	a0,s5
    80005e16:	ffffe097          	auipc	ra,0xffffe
    80005e1a:	7b2080e7          	jalr	1970(ra) # 800045c8 <iunlockput>
    return 0;
    80005e1e:	4a81                	li	s5,0
    80005e20:	b7c5                	j	80005e00 <create+0x70>
    80005e22:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005e24:	85da                	mv	a1,s6
    80005e26:	4088                	lw	a0,0(s1)
    80005e28:	ffffe097          	auipc	ra,0xffffe
    80005e2c:	396080e7          	jalr	918(ra) # 800041be <ialloc>
    80005e30:	8a2a                	mv	s4,a0
    80005e32:	c531                	beqz	a0,80005e7e <create+0xee>
  ilock(ip);
    80005e34:	ffffe097          	auipc	ra,0xffffe
    80005e38:	52e080e7          	jalr	1326(ra) # 80004362 <ilock>
  ip->major = major;
    80005e3c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005e40:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005e44:	4905                	li	s2,1
    80005e46:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005e4a:	8552                	mv	a0,s4
    80005e4c:	ffffe097          	auipc	ra,0xffffe
    80005e50:	44a080e7          	jalr	1098(ra) # 80004296 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005e54:	032b0d63          	beq	s6,s2,80005e8e <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005e58:	004a2603          	lw	a2,4(s4)
    80005e5c:	fb040593          	addi	a1,s0,-80
    80005e60:	8526                	mv	a0,s1
    80005e62:	fffff097          	auipc	ra,0xfffff
    80005e66:	c22080e7          	jalr	-990(ra) # 80004a84 <dirlink>
    80005e6a:	08054163          	bltz	a0,80005eec <create+0x15c>
  iunlockput(dp);
    80005e6e:	8526                	mv	a0,s1
    80005e70:	ffffe097          	auipc	ra,0xffffe
    80005e74:	758080e7          	jalr	1880(ra) # 800045c8 <iunlockput>
  return ip;
    80005e78:	8ad2                	mv	s5,s4
    80005e7a:	7a02                	ld	s4,32(sp)
    80005e7c:	b751                	j	80005e00 <create+0x70>
    iunlockput(dp);
    80005e7e:	8526                	mv	a0,s1
    80005e80:	ffffe097          	auipc	ra,0xffffe
    80005e84:	748080e7          	jalr	1864(ra) # 800045c8 <iunlockput>
    return 0;
    80005e88:	8ad2                	mv	s5,s4
    80005e8a:	7a02                	ld	s4,32(sp)
    80005e8c:	bf95                	j	80005e00 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005e8e:	004a2603          	lw	a2,4(s4)
    80005e92:	00004597          	auipc	a1,0x4
    80005e96:	83658593          	addi	a1,a1,-1994 # 800096c8 <etext+0x6c8>
    80005e9a:	8552                	mv	a0,s4
    80005e9c:	fffff097          	auipc	ra,0xfffff
    80005ea0:	be8080e7          	jalr	-1048(ra) # 80004a84 <dirlink>
    80005ea4:	04054463          	bltz	a0,80005eec <create+0x15c>
    80005ea8:	40d0                	lw	a2,4(s1)
    80005eaa:	00004597          	auipc	a1,0x4
    80005eae:	82658593          	addi	a1,a1,-2010 # 800096d0 <etext+0x6d0>
    80005eb2:	8552                	mv	a0,s4
    80005eb4:	fffff097          	auipc	ra,0xfffff
    80005eb8:	bd0080e7          	jalr	-1072(ra) # 80004a84 <dirlink>
    80005ebc:	02054863          	bltz	a0,80005eec <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005ec0:	004a2603          	lw	a2,4(s4)
    80005ec4:	fb040593          	addi	a1,s0,-80
    80005ec8:	8526                	mv	a0,s1
    80005eca:	fffff097          	auipc	ra,0xfffff
    80005ece:	bba080e7          	jalr	-1094(ra) # 80004a84 <dirlink>
    80005ed2:	00054d63          	bltz	a0,80005eec <create+0x15c>
    dp->nlink++;  // for ".."
    80005ed6:	04a4d783          	lhu	a5,74(s1)
    80005eda:	2785                	addiw	a5,a5,1
    80005edc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005ee0:	8526                	mv	a0,s1
    80005ee2:	ffffe097          	auipc	ra,0xffffe
    80005ee6:	3b4080e7          	jalr	948(ra) # 80004296 <iupdate>
    80005eea:	b751                	j	80005e6e <create+0xde>
  ip->nlink = 0;
    80005eec:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005ef0:	8552                	mv	a0,s4
    80005ef2:	ffffe097          	auipc	ra,0xffffe
    80005ef6:	3a4080e7          	jalr	932(ra) # 80004296 <iupdate>
  iunlockput(ip);
    80005efa:	8552                	mv	a0,s4
    80005efc:	ffffe097          	auipc	ra,0xffffe
    80005f00:	6cc080e7          	jalr	1740(ra) # 800045c8 <iunlockput>
  iunlockput(dp);
    80005f04:	8526                	mv	a0,s1
    80005f06:	ffffe097          	auipc	ra,0xffffe
    80005f0a:	6c2080e7          	jalr	1730(ra) # 800045c8 <iunlockput>
  return 0;
    80005f0e:	7a02                	ld	s4,32(sp)
    80005f10:	bdc5                	j	80005e00 <create+0x70>
    return 0;
    80005f12:	8aaa                	mv	s5,a0
    80005f14:	b5f5                	j	80005e00 <create+0x70>

0000000080005f16 <sys_dup>:
{
    80005f16:	7179                	addi	sp,sp,-48
    80005f18:	f406                	sd	ra,40(sp)
    80005f1a:	f022                	sd	s0,32(sp)
    80005f1c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005f1e:	fd840613          	addi	a2,s0,-40
    80005f22:	4581                	li	a1,0
    80005f24:	4501                	li	a0,0
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	dc8080e7          	jalr	-568(ra) # 80005cee <argfd>
    return -1;
    80005f2e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005f30:	02054763          	bltz	a0,80005f5e <sys_dup+0x48>
    80005f34:	ec26                	sd	s1,24(sp)
    80005f36:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005f38:	fd843903          	ld	s2,-40(s0)
    80005f3c:	854a                	mv	a0,s2
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	e10080e7          	jalr	-496(ra) # 80005d4e <fdalloc>
    80005f46:	84aa                	mv	s1,a0
    return -1;
    80005f48:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005f4a:	00054f63          	bltz	a0,80005f68 <sys_dup+0x52>
  filedup(f);
    80005f4e:	854a                	mv	a0,s2
    80005f50:	fffff097          	auipc	ra,0xfffff
    80005f54:	27a080e7          	jalr	634(ra) # 800051ca <filedup>
  return fd;
    80005f58:	87a6                	mv	a5,s1
    80005f5a:	64e2                	ld	s1,24(sp)
    80005f5c:	6942                	ld	s2,16(sp)
}
    80005f5e:	853e                	mv	a0,a5
    80005f60:	70a2                	ld	ra,40(sp)
    80005f62:	7402                	ld	s0,32(sp)
    80005f64:	6145                	addi	sp,sp,48
    80005f66:	8082                	ret
    80005f68:	64e2                	ld	s1,24(sp)
    80005f6a:	6942                	ld	s2,16(sp)
    80005f6c:	bfcd                	j	80005f5e <sys_dup+0x48>

0000000080005f6e <sys_read>:
{
    80005f6e:	7179                	addi	sp,sp,-48
    80005f70:	f406                	sd	ra,40(sp)
    80005f72:	f022                	sd	s0,32(sp)
    80005f74:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005f76:	fd840593          	addi	a1,s0,-40
    80005f7a:	4505                	li	a0,1
    80005f7c:	ffffd097          	auipc	ra,0xffffd
    80005f80:	63a080e7          	jalr	1594(ra) # 800035b6 <argaddr>
  argint(2, &n);
    80005f84:	fe440593          	addi	a1,s0,-28
    80005f88:	4509                	li	a0,2
    80005f8a:	ffffd097          	auipc	ra,0xffffd
    80005f8e:	60c080e7          	jalr	1548(ra) # 80003596 <argint>
  if(argfd(0, 0, &f) < 0)
    80005f92:	fe840613          	addi	a2,s0,-24
    80005f96:	4581                	li	a1,0
    80005f98:	4501                	li	a0,0
    80005f9a:	00000097          	auipc	ra,0x0
    80005f9e:	d54080e7          	jalr	-684(ra) # 80005cee <argfd>
    80005fa2:	87aa                	mv	a5,a0
    return -1;
    80005fa4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005fa6:	0007cc63          	bltz	a5,80005fbe <sys_read+0x50>
  return fileread(f, p, n);
    80005faa:	fe442603          	lw	a2,-28(s0)
    80005fae:	fd843583          	ld	a1,-40(s0)
    80005fb2:	fe843503          	ld	a0,-24(s0)
    80005fb6:	fffff097          	auipc	ra,0xfffff
    80005fba:	3ba080e7          	jalr	954(ra) # 80005370 <fileread>
}
    80005fbe:	70a2                	ld	ra,40(sp)
    80005fc0:	7402                	ld	s0,32(sp)
    80005fc2:	6145                	addi	sp,sp,48
    80005fc4:	8082                	ret

0000000080005fc6 <sys_write>:
{
    80005fc6:	7179                	addi	sp,sp,-48
    80005fc8:	f406                	sd	ra,40(sp)
    80005fca:	f022                	sd	s0,32(sp)
    80005fcc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005fce:	fd840593          	addi	a1,s0,-40
    80005fd2:	4505                	li	a0,1
    80005fd4:	ffffd097          	auipc	ra,0xffffd
    80005fd8:	5e2080e7          	jalr	1506(ra) # 800035b6 <argaddr>
  argint(2, &n);
    80005fdc:	fe440593          	addi	a1,s0,-28
    80005fe0:	4509                	li	a0,2
    80005fe2:	ffffd097          	auipc	ra,0xffffd
    80005fe6:	5b4080e7          	jalr	1460(ra) # 80003596 <argint>
  if(argfd(0, 0, &f) < 0)
    80005fea:	fe840613          	addi	a2,s0,-24
    80005fee:	4581                	li	a1,0
    80005ff0:	4501                	li	a0,0
    80005ff2:	00000097          	auipc	ra,0x0
    80005ff6:	cfc080e7          	jalr	-772(ra) # 80005cee <argfd>
    80005ffa:	87aa                	mv	a5,a0
    return -1;
    80005ffc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005ffe:	0007cc63          	bltz	a5,80006016 <sys_write+0x50>
  return filewrite(f, p, n);
    80006002:	fe442603          	lw	a2,-28(s0)
    80006006:	fd843583          	ld	a1,-40(s0)
    8000600a:	fe843503          	ld	a0,-24(s0)
    8000600e:	fffff097          	auipc	ra,0xfffff
    80006012:	434080e7          	jalr	1076(ra) # 80005442 <filewrite>
}
    80006016:	70a2                	ld	ra,40(sp)
    80006018:	7402                	ld	s0,32(sp)
    8000601a:	6145                	addi	sp,sp,48
    8000601c:	8082                	ret

000000008000601e <sys_close>:
{
    8000601e:	1101                	addi	sp,sp,-32
    80006020:	ec06                	sd	ra,24(sp)
    80006022:	e822                	sd	s0,16(sp)
    80006024:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80006026:	fe040613          	addi	a2,s0,-32
    8000602a:	fec40593          	addi	a1,s0,-20
    8000602e:	4501                	li	a0,0
    80006030:	00000097          	auipc	ra,0x0
    80006034:	cbe080e7          	jalr	-834(ra) # 80005cee <argfd>
    return -1;
    80006038:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000603a:	02054463          	bltz	a0,80006062 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000603e:	ffffc097          	auipc	ra,0xffffc
    80006042:	ee4080e7          	jalr	-284(ra) # 80001f22 <myproc>
    80006046:	fec42783          	lw	a5,-20(s0)
    8000604a:	07e9                	addi	a5,a5,26
    8000604c:	078e                	slli	a5,a5,0x3
    8000604e:	953e                	add	a0,a0,a5
    80006050:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80006054:	fe043503          	ld	a0,-32(s0)
    80006058:	fffff097          	auipc	ra,0xfffff
    8000605c:	1c4080e7          	jalr	452(ra) # 8000521c <fileclose>
  return 0;
    80006060:	4781                	li	a5,0
}
    80006062:	853e                	mv	a0,a5
    80006064:	60e2                	ld	ra,24(sp)
    80006066:	6442                	ld	s0,16(sp)
    80006068:	6105                	addi	sp,sp,32
    8000606a:	8082                	ret

000000008000606c <sys_fstat>:
{
    8000606c:	1101                	addi	sp,sp,-32
    8000606e:	ec06                	sd	ra,24(sp)
    80006070:	e822                	sd	s0,16(sp)
    80006072:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80006074:	fe040593          	addi	a1,s0,-32
    80006078:	4505                	li	a0,1
    8000607a:	ffffd097          	auipc	ra,0xffffd
    8000607e:	53c080e7          	jalr	1340(ra) # 800035b6 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80006082:	fe840613          	addi	a2,s0,-24
    80006086:	4581                	li	a1,0
    80006088:	4501                	li	a0,0
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	c64080e7          	jalr	-924(ra) # 80005cee <argfd>
    80006092:	87aa                	mv	a5,a0
    return -1;
    80006094:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006096:	0007ca63          	bltz	a5,800060aa <sys_fstat+0x3e>
  return filestat(f, st);
    8000609a:	fe043583          	ld	a1,-32(s0)
    8000609e:	fe843503          	ld	a0,-24(s0)
    800060a2:	fffff097          	auipc	ra,0xfffff
    800060a6:	258080e7          	jalr	600(ra) # 800052fa <filestat>
}
    800060aa:	60e2                	ld	ra,24(sp)
    800060ac:	6442                	ld	s0,16(sp)
    800060ae:	6105                	addi	sp,sp,32
    800060b0:	8082                	ret

00000000800060b2 <sys_link>:
{
    800060b2:	7169                	addi	sp,sp,-304
    800060b4:	f606                	sd	ra,296(sp)
    800060b6:	f222                	sd	s0,288(sp)
    800060b8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800060ba:	08000613          	li	a2,128
    800060be:	ed040593          	addi	a1,s0,-304
    800060c2:	4501                	li	a0,0
    800060c4:	ffffd097          	auipc	ra,0xffffd
    800060c8:	512080e7          	jalr	1298(ra) # 800035d6 <argstr>
    return -1;
    800060cc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800060ce:	12054663          	bltz	a0,800061fa <sys_link+0x148>
    800060d2:	08000613          	li	a2,128
    800060d6:	f5040593          	addi	a1,s0,-176
    800060da:	4505                	li	a0,1
    800060dc:	ffffd097          	auipc	ra,0xffffd
    800060e0:	4fa080e7          	jalr	1274(ra) # 800035d6 <argstr>
    return -1;
    800060e4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800060e6:	10054a63          	bltz	a0,800061fa <sys_link+0x148>
    800060ea:	ee26                	sd	s1,280(sp)
  begin_op();
    800060ec:	fffff097          	auipc	ra,0xfffff
    800060f0:	c60080e7          	jalr	-928(ra) # 80004d4c <begin_op>
  if((ip = namei(old)) == 0){
    800060f4:	ed040513          	addi	a0,s0,-304
    800060f8:	fffff097          	auipc	ra,0xfffff
    800060fc:	a4e080e7          	jalr	-1458(ra) # 80004b46 <namei>
    80006100:	84aa                	mv	s1,a0
    80006102:	c949                	beqz	a0,80006194 <sys_link+0xe2>
  ilock(ip);
    80006104:	ffffe097          	auipc	ra,0xffffe
    80006108:	25e080e7          	jalr	606(ra) # 80004362 <ilock>
  if(ip->type == T_DIR){
    8000610c:	04449703          	lh	a4,68(s1)
    80006110:	4785                	li	a5,1
    80006112:	08f70863          	beq	a4,a5,800061a2 <sys_link+0xf0>
    80006116:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80006118:	04a4d783          	lhu	a5,74(s1)
    8000611c:	2785                	addiw	a5,a5,1
    8000611e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006122:	8526                	mv	a0,s1
    80006124:	ffffe097          	auipc	ra,0xffffe
    80006128:	172080e7          	jalr	370(ra) # 80004296 <iupdate>
  iunlock(ip);
    8000612c:	8526                	mv	a0,s1
    8000612e:	ffffe097          	auipc	ra,0xffffe
    80006132:	2fa080e7          	jalr	762(ra) # 80004428 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80006136:	fd040593          	addi	a1,s0,-48
    8000613a:	f5040513          	addi	a0,s0,-176
    8000613e:	fffff097          	auipc	ra,0xfffff
    80006142:	a26080e7          	jalr	-1498(ra) # 80004b64 <nameiparent>
    80006146:	892a                	mv	s2,a0
    80006148:	cd35                	beqz	a0,800061c4 <sys_link+0x112>
  ilock(dp);
    8000614a:	ffffe097          	auipc	ra,0xffffe
    8000614e:	218080e7          	jalr	536(ra) # 80004362 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80006152:	00092703          	lw	a4,0(s2)
    80006156:	409c                	lw	a5,0(s1)
    80006158:	06f71163          	bne	a4,a5,800061ba <sys_link+0x108>
    8000615c:	40d0                	lw	a2,4(s1)
    8000615e:	fd040593          	addi	a1,s0,-48
    80006162:	854a                	mv	a0,s2
    80006164:	fffff097          	auipc	ra,0xfffff
    80006168:	920080e7          	jalr	-1760(ra) # 80004a84 <dirlink>
    8000616c:	04054763          	bltz	a0,800061ba <sys_link+0x108>
  iunlockput(dp);
    80006170:	854a                	mv	a0,s2
    80006172:	ffffe097          	auipc	ra,0xffffe
    80006176:	456080e7          	jalr	1110(ra) # 800045c8 <iunlockput>
  iput(ip);
    8000617a:	8526                	mv	a0,s1
    8000617c:	ffffe097          	auipc	ra,0xffffe
    80006180:	3a4080e7          	jalr	932(ra) # 80004520 <iput>
  end_op();
    80006184:	fffff097          	auipc	ra,0xfffff
    80006188:	c42080e7          	jalr	-958(ra) # 80004dc6 <end_op>
  return 0;
    8000618c:	4781                	li	a5,0
    8000618e:	64f2                	ld	s1,280(sp)
    80006190:	6952                	ld	s2,272(sp)
    80006192:	a0a5                	j	800061fa <sys_link+0x148>
    end_op();
    80006194:	fffff097          	auipc	ra,0xfffff
    80006198:	c32080e7          	jalr	-974(ra) # 80004dc6 <end_op>
    return -1;
    8000619c:	57fd                	li	a5,-1
    8000619e:	64f2                	ld	s1,280(sp)
    800061a0:	a8a9                	j	800061fa <sys_link+0x148>
    iunlockput(ip);
    800061a2:	8526                	mv	a0,s1
    800061a4:	ffffe097          	auipc	ra,0xffffe
    800061a8:	424080e7          	jalr	1060(ra) # 800045c8 <iunlockput>
    end_op();
    800061ac:	fffff097          	auipc	ra,0xfffff
    800061b0:	c1a080e7          	jalr	-998(ra) # 80004dc6 <end_op>
    return -1;
    800061b4:	57fd                	li	a5,-1
    800061b6:	64f2                	ld	s1,280(sp)
    800061b8:	a089                	j	800061fa <sys_link+0x148>
    iunlockput(dp);
    800061ba:	854a                	mv	a0,s2
    800061bc:	ffffe097          	auipc	ra,0xffffe
    800061c0:	40c080e7          	jalr	1036(ra) # 800045c8 <iunlockput>
  ilock(ip);
    800061c4:	8526                	mv	a0,s1
    800061c6:	ffffe097          	auipc	ra,0xffffe
    800061ca:	19c080e7          	jalr	412(ra) # 80004362 <ilock>
  ip->nlink--;
    800061ce:	04a4d783          	lhu	a5,74(s1)
    800061d2:	37fd                	addiw	a5,a5,-1
    800061d4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800061d8:	8526                	mv	a0,s1
    800061da:	ffffe097          	auipc	ra,0xffffe
    800061de:	0bc080e7          	jalr	188(ra) # 80004296 <iupdate>
  iunlockput(ip);
    800061e2:	8526                	mv	a0,s1
    800061e4:	ffffe097          	auipc	ra,0xffffe
    800061e8:	3e4080e7          	jalr	996(ra) # 800045c8 <iunlockput>
  end_op();
    800061ec:	fffff097          	auipc	ra,0xfffff
    800061f0:	bda080e7          	jalr	-1062(ra) # 80004dc6 <end_op>
  return -1;
    800061f4:	57fd                	li	a5,-1
    800061f6:	64f2                	ld	s1,280(sp)
    800061f8:	6952                	ld	s2,272(sp)
}
    800061fa:	853e                	mv	a0,a5
    800061fc:	70b2                	ld	ra,296(sp)
    800061fe:	7412                	ld	s0,288(sp)
    80006200:	6155                	addi	sp,sp,304
    80006202:	8082                	ret

0000000080006204 <sys_unlink>:
{
    80006204:	7111                	addi	sp,sp,-256
    80006206:	fd86                	sd	ra,248(sp)
    80006208:	f9a2                	sd	s0,240(sp)
    8000620a:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    8000620c:	08000613          	li	a2,128
    80006210:	f2040593          	addi	a1,s0,-224
    80006214:	4501                	li	a0,0
    80006216:	ffffd097          	auipc	ra,0xffffd
    8000621a:	3c0080e7          	jalr	960(ra) # 800035d6 <argstr>
    8000621e:	1c054063          	bltz	a0,800063de <sys_unlink+0x1da>
    80006222:	f5a6                	sd	s1,232(sp)
  begin_op();
    80006224:	fffff097          	auipc	ra,0xfffff
    80006228:	b28080e7          	jalr	-1240(ra) # 80004d4c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000622c:	fa040593          	addi	a1,s0,-96
    80006230:	f2040513          	addi	a0,s0,-224
    80006234:	fffff097          	auipc	ra,0xfffff
    80006238:	930080e7          	jalr	-1744(ra) # 80004b64 <nameiparent>
    8000623c:	84aa                	mv	s1,a0
    8000623e:	c165                	beqz	a0,8000631e <sys_unlink+0x11a>
  ilock(dp);
    80006240:	ffffe097          	auipc	ra,0xffffe
    80006244:	122080e7          	jalr	290(ra) # 80004362 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006248:	00003597          	auipc	a1,0x3
    8000624c:	48058593          	addi	a1,a1,1152 # 800096c8 <etext+0x6c8>
    80006250:	fa040513          	addi	a0,s0,-96
    80006254:	ffffe097          	auipc	ra,0xffffe
    80006258:	5f0080e7          	jalr	1520(ra) # 80004844 <namecmp>
    8000625c:	16050263          	beqz	a0,800063c0 <sys_unlink+0x1bc>
    80006260:	00003597          	auipc	a1,0x3
    80006264:	47058593          	addi	a1,a1,1136 # 800096d0 <etext+0x6d0>
    80006268:	fa040513          	addi	a0,s0,-96
    8000626c:	ffffe097          	auipc	ra,0xffffe
    80006270:	5d8080e7          	jalr	1496(ra) # 80004844 <namecmp>
    80006274:	14050663          	beqz	a0,800063c0 <sys_unlink+0x1bc>
    80006278:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000627a:	f1c40613          	addi	a2,s0,-228
    8000627e:	fa040593          	addi	a1,s0,-96
    80006282:	8526                	mv	a0,s1
    80006284:	ffffe097          	auipc	ra,0xffffe
    80006288:	5da080e7          	jalr	1498(ra) # 8000485e <dirlookup>
    8000628c:	892a                	mv	s2,a0
    8000628e:	12050863          	beqz	a0,800063be <sys_unlink+0x1ba>
    80006292:	edce                	sd	s3,216(sp)
  ilock(ip);
    80006294:	ffffe097          	auipc	ra,0xffffe
    80006298:	0ce080e7          	jalr	206(ra) # 80004362 <ilock>
  if(ip->nlink < 1)
    8000629c:	04a91783          	lh	a5,74(s2)
    800062a0:	08f05663          	blez	a5,8000632c <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800062a4:	04491703          	lh	a4,68(s2)
    800062a8:	4785                	li	a5,1
    800062aa:	08f70b63          	beq	a4,a5,80006340 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    800062ae:	fb040993          	addi	s3,s0,-80
    800062b2:	4641                	li	a2,16
    800062b4:	4581                	li	a1,0
    800062b6:	854e                	mv	a0,s3
    800062b8:	ffffb097          	auipc	ra,0xffffb
    800062bc:	b56080e7          	jalr	-1194(ra) # 80000e0e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800062c0:	4741                	li	a4,16
    800062c2:	f1c42683          	lw	a3,-228(s0)
    800062c6:	864e                	mv	a2,s3
    800062c8:	4581                	li	a1,0
    800062ca:	8526                	mv	a0,s1
    800062cc:	ffffe097          	auipc	ra,0xffffe
    800062d0:	458080e7          	jalr	1112(ra) # 80004724 <writei>
    800062d4:	47c1                	li	a5,16
    800062d6:	0af51f63          	bne	a0,a5,80006394 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    800062da:	04491703          	lh	a4,68(s2)
    800062de:	4785                	li	a5,1
    800062e0:	0cf70463          	beq	a4,a5,800063a8 <sys_unlink+0x1a4>
  iunlockput(dp);
    800062e4:	8526                	mv	a0,s1
    800062e6:	ffffe097          	auipc	ra,0xffffe
    800062ea:	2e2080e7          	jalr	738(ra) # 800045c8 <iunlockput>
  ip->nlink--;
    800062ee:	04a95783          	lhu	a5,74(s2)
    800062f2:	37fd                	addiw	a5,a5,-1
    800062f4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800062f8:	854a                	mv	a0,s2
    800062fa:	ffffe097          	auipc	ra,0xffffe
    800062fe:	f9c080e7          	jalr	-100(ra) # 80004296 <iupdate>
  iunlockput(ip);
    80006302:	854a                	mv	a0,s2
    80006304:	ffffe097          	auipc	ra,0xffffe
    80006308:	2c4080e7          	jalr	708(ra) # 800045c8 <iunlockput>
  end_op();
    8000630c:	fffff097          	auipc	ra,0xfffff
    80006310:	aba080e7          	jalr	-1350(ra) # 80004dc6 <end_op>
  return 0;
    80006314:	4501                	li	a0,0
    80006316:	74ae                	ld	s1,232(sp)
    80006318:	790e                	ld	s2,224(sp)
    8000631a:	69ee                	ld	s3,216(sp)
    8000631c:	a86d                	j	800063d6 <sys_unlink+0x1d2>
    end_op();
    8000631e:	fffff097          	auipc	ra,0xfffff
    80006322:	aa8080e7          	jalr	-1368(ra) # 80004dc6 <end_op>
    return -1;
    80006326:	557d                	li	a0,-1
    80006328:	74ae                	ld	s1,232(sp)
    8000632a:	a075                	j	800063d6 <sys_unlink+0x1d2>
    8000632c:	e9d2                	sd	s4,208(sp)
    8000632e:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80006330:	00003517          	auipc	a0,0x3
    80006334:	3a850513          	addi	a0,a0,936 # 800096d8 <etext+0x6d8>
    80006338:	ffffa097          	auipc	ra,0xffffa
    8000633c:	228080e7          	jalr	552(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006340:	04c92703          	lw	a4,76(s2)
    80006344:	02000793          	li	a5,32
    80006348:	f6e7f3e3          	bgeu	a5,a4,800062ae <sys_unlink+0xaa>
    8000634c:	e9d2                	sd	s4,208(sp)
    8000634e:	e5d6                	sd	s5,200(sp)
    80006350:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006352:	f0840a93          	addi	s5,s0,-248
    80006356:	4a41                	li	s4,16
    80006358:	8752                	mv	a4,s4
    8000635a:	86ce                	mv	a3,s3
    8000635c:	8656                	mv	a2,s5
    8000635e:	4581                	li	a1,0
    80006360:	854a                	mv	a0,s2
    80006362:	ffffe097          	auipc	ra,0xffffe
    80006366:	2bc080e7          	jalr	700(ra) # 8000461e <readi>
    8000636a:	01451d63          	bne	a0,s4,80006384 <sys_unlink+0x180>
    if(de.inum != 0)
    8000636e:	f0845783          	lhu	a5,-248(s0)
    80006372:	eba5                	bnez	a5,800063e2 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006374:	29c1                	addiw	s3,s3,16
    80006376:	04c92783          	lw	a5,76(s2)
    8000637a:	fcf9efe3          	bltu	s3,a5,80006358 <sys_unlink+0x154>
    8000637e:	6a4e                	ld	s4,208(sp)
    80006380:	6aae                	ld	s5,200(sp)
    80006382:	b735                	j	800062ae <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80006384:	00003517          	auipc	a0,0x3
    80006388:	36c50513          	addi	a0,a0,876 # 800096f0 <etext+0x6f0>
    8000638c:	ffffa097          	auipc	ra,0xffffa
    80006390:	1d4080e7          	jalr	468(ra) # 80000560 <panic>
    80006394:	e9d2                	sd	s4,208(sp)
    80006396:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80006398:	00003517          	auipc	a0,0x3
    8000639c:	37050513          	addi	a0,a0,880 # 80009708 <etext+0x708>
    800063a0:	ffffa097          	auipc	ra,0xffffa
    800063a4:	1c0080e7          	jalr	448(ra) # 80000560 <panic>
    dp->nlink--;
    800063a8:	04a4d783          	lhu	a5,74(s1)
    800063ac:	37fd                	addiw	a5,a5,-1
    800063ae:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800063b2:	8526                	mv	a0,s1
    800063b4:	ffffe097          	auipc	ra,0xffffe
    800063b8:	ee2080e7          	jalr	-286(ra) # 80004296 <iupdate>
    800063bc:	b725                	j	800062e4 <sys_unlink+0xe0>
    800063be:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    800063c0:	8526                	mv	a0,s1
    800063c2:	ffffe097          	auipc	ra,0xffffe
    800063c6:	206080e7          	jalr	518(ra) # 800045c8 <iunlockput>
  end_op();
    800063ca:	fffff097          	auipc	ra,0xfffff
    800063ce:	9fc080e7          	jalr	-1540(ra) # 80004dc6 <end_op>
  return -1;
    800063d2:	557d                	li	a0,-1
    800063d4:	74ae                	ld	s1,232(sp)
}
    800063d6:	70ee                	ld	ra,248(sp)
    800063d8:	744e                	ld	s0,240(sp)
    800063da:	6111                	addi	sp,sp,256
    800063dc:	8082                	ret
    return -1;
    800063de:	557d                	li	a0,-1
    800063e0:	bfdd                	j	800063d6 <sys_unlink+0x1d2>
    iunlockput(ip);
    800063e2:	854a                	mv	a0,s2
    800063e4:	ffffe097          	auipc	ra,0xffffe
    800063e8:	1e4080e7          	jalr	484(ra) # 800045c8 <iunlockput>
    goto bad;
    800063ec:	790e                	ld	s2,224(sp)
    800063ee:	69ee                	ld	s3,216(sp)
    800063f0:	6a4e                	ld	s4,208(sp)
    800063f2:	6aae                	ld	s5,200(sp)
    800063f4:	b7f1                	j	800063c0 <sys_unlink+0x1bc>

00000000800063f6 <sys_open>:

uint64
sys_open(void)
{
    800063f6:	7131                	addi	sp,sp,-192
    800063f8:	fd06                	sd	ra,184(sp)
    800063fa:	f922                	sd	s0,176(sp)
    800063fc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800063fe:	f4c40593          	addi	a1,s0,-180
    80006402:	4505                	li	a0,1
    80006404:	ffffd097          	auipc	ra,0xffffd
    80006408:	192080e7          	jalr	402(ra) # 80003596 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000640c:	08000613          	li	a2,128
    80006410:	f5040593          	addi	a1,s0,-176
    80006414:	4501                	li	a0,0
    80006416:	ffffd097          	auipc	ra,0xffffd
    8000641a:	1c0080e7          	jalr	448(ra) # 800035d6 <argstr>
    8000641e:	87aa                	mv	a5,a0
    return -1;
    80006420:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006422:	0a07cf63          	bltz	a5,800064e0 <sys_open+0xea>
    80006426:	f526                	sd	s1,168(sp)

  begin_op();
    80006428:	fffff097          	auipc	ra,0xfffff
    8000642c:	924080e7          	jalr	-1756(ra) # 80004d4c <begin_op>

  if(omode & O_CREATE){
    80006430:	f4c42783          	lw	a5,-180(s0)
    80006434:	2007f793          	andi	a5,a5,512
    80006438:	cfdd                	beqz	a5,800064f6 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    8000643a:	4681                	li	a3,0
    8000643c:	4601                	li	a2,0
    8000643e:	4589                	li	a1,2
    80006440:	f5040513          	addi	a0,s0,-176
    80006444:	00000097          	auipc	ra,0x0
    80006448:	94c080e7          	jalr	-1716(ra) # 80005d90 <create>
    8000644c:	84aa                	mv	s1,a0
    if(ip == 0){
    8000644e:	cd49                	beqz	a0,800064e8 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80006450:	04449703          	lh	a4,68(s1)
    80006454:	478d                	li	a5,3
    80006456:	00f71763          	bne	a4,a5,80006464 <sys_open+0x6e>
    8000645a:	0464d703          	lhu	a4,70(s1)
    8000645e:	47a5                	li	a5,9
    80006460:	0ee7e263          	bltu	a5,a4,80006544 <sys_open+0x14e>
    80006464:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006466:	fffff097          	auipc	ra,0xfffff
    8000646a:	cfa080e7          	jalr	-774(ra) # 80005160 <filealloc>
    8000646e:	892a                	mv	s2,a0
    80006470:	cd65                	beqz	a0,80006568 <sys_open+0x172>
    80006472:	ed4e                	sd	s3,152(sp)
    80006474:	00000097          	auipc	ra,0x0
    80006478:	8da080e7          	jalr	-1830(ra) # 80005d4e <fdalloc>
    8000647c:	89aa                	mv	s3,a0
    8000647e:	0c054f63          	bltz	a0,8000655c <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80006482:	04449703          	lh	a4,68(s1)
    80006486:	478d                	li	a5,3
    80006488:	0ef70d63          	beq	a4,a5,80006582 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000648c:	4789                	li	a5,2
    8000648e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80006492:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80006496:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000649a:	f4c42783          	lw	a5,-180(s0)
    8000649e:	0017f713          	andi	a4,a5,1
    800064a2:	00174713          	xori	a4,a4,1
    800064a6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800064aa:	0037f713          	andi	a4,a5,3
    800064ae:	00e03733          	snez	a4,a4
    800064b2:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800064b6:	4007f793          	andi	a5,a5,1024
    800064ba:	c791                	beqz	a5,800064c6 <sys_open+0xd0>
    800064bc:	04449703          	lh	a4,68(s1)
    800064c0:	4789                	li	a5,2
    800064c2:	0cf70763          	beq	a4,a5,80006590 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    800064c6:	8526                	mv	a0,s1
    800064c8:	ffffe097          	auipc	ra,0xffffe
    800064cc:	f60080e7          	jalr	-160(ra) # 80004428 <iunlock>
  end_op();
    800064d0:	fffff097          	auipc	ra,0xfffff
    800064d4:	8f6080e7          	jalr	-1802(ra) # 80004dc6 <end_op>

  return fd;
    800064d8:	854e                	mv	a0,s3
    800064da:	74aa                	ld	s1,168(sp)
    800064dc:	790a                	ld	s2,160(sp)
    800064de:	69ea                	ld	s3,152(sp)
}
    800064e0:	70ea                	ld	ra,184(sp)
    800064e2:	744a                	ld	s0,176(sp)
    800064e4:	6129                	addi	sp,sp,192
    800064e6:	8082                	ret
      end_op();
    800064e8:	fffff097          	auipc	ra,0xfffff
    800064ec:	8de080e7          	jalr	-1826(ra) # 80004dc6 <end_op>
      return -1;
    800064f0:	557d                	li	a0,-1
    800064f2:	74aa                	ld	s1,168(sp)
    800064f4:	b7f5                	j	800064e0 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    800064f6:	f5040513          	addi	a0,s0,-176
    800064fa:	ffffe097          	auipc	ra,0xffffe
    800064fe:	64c080e7          	jalr	1612(ra) # 80004b46 <namei>
    80006502:	84aa                	mv	s1,a0
    80006504:	c90d                	beqz	a0,80006536 <sys_open+0x140>
    ilock(ip);
    80006506:	ffffe097          	auipc	ra,0xffffe
    8000650a:	e5c080e7          	jalr	-420(ra) # 80004362 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000650e:	04449703          	lh	a4,68(s1)
    80006512:	4785                	li	a5,1
    80006514:	f2f71ee3          	bne	a4,a5,80006450 <sys_open+0x5a>
    80006518:	f4c42783          	lw	a5,-180(s0)
    8000651c:	d7a1                	beqz	a5,80006464 <sys_open+0x6e>
      iunlockput(ip);
    8000651e:	8526                	mv	a0,s1
    80006520:	ffffe097          	auipc	ra,0xffffe
    80006524:	0a8080e7          	jalr	168(ra) # 800045c8 <iunlockput>
      end_op();
    80006528:	fffff097          	auipc	ra,0xfffff
    8000652c:	89e080e7          	jalr	-1890(ra) # 80004dc6 <end_op>
      return -1;
    80006530:	557d                	li	a0,-1
    80006532:	74aa                	ld	s1,168(sp)
    80006534:	b775                	j	800064e0 <sys_open+0xea>
      end_op();
    80006536:	fffff097          	auipc	ra,0xfffff
    8000653a:	890080e7          	jalr	-1904(ra) # 80004dc6 <end_op>
      return -1;
    8000653e:	557d                	li	a0,-1
    80006540:	74aa                	ld	s1,168(sp)
    80006542:	bf79                	j	800064e0 <sys_open+0xea>
    iunlockput(ip);
    80006544:	8526                	mv	a0,s1
    80006546:	ffffe097          	auipc	ra,0xffffe
    8000654a:	082080e7          	jalr	130(ra) # 800045c8 <iunlockput>
    end_op();
    8000654e:	fffff097          	auipc	ra,0xfffff
    80006552:	878080e7          	jalr	-1928(ra) # 80004dc6 <end_op>
    return -1;
    80006556:	557d                	li	a0,-1
    80006558:	74aa                	ld	s1,168(sp)
    8000655a:	b759                	j	800064e0 <sys_open+0xea>
      fileclose(f);
    8000655c:	854a                	mv	a0,s2
    8000655e:	fffff097          	auipc	ra,0xfffff
    80006562:	cbe080e7          	jalr	-834(ra) # 8000521c <fileclose>
    80006566:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80006568:	8526                	mv	a0,s1
    8000656a:	ffffe097          	auipc	ra,0xffffe
    8000656e:	05e080e7          	jalr	94(ra) # 800045c8 <iunlockput>
    end_op();
    80006572:	fffff097          	auipc	ra,0xfffff
    80006576:	854080e7          	jalr	-1964(ra) # 80004dc6 <end_op>
    return -1;
    8000657a:	557d                	li	a0,-1
    8000657c:	74aa                	ld	s1,168(sp)
    8000657e:	790a                	ld	s2,160(sp)
    80006580:	b785                	j	800064e0 <sys_open+0xea>
    f->type = FD_DEVICE;
    80006582:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80006586:	04649783          	lh	a5,70(s1)
    8000658a:	02f91223          	sh	a5,36(s2)
    8000658e:	b721                	j	80006496 <sys_open+0xa0>
    itrunc(ip);
    80006590:	8526                	mv	a0,s1
    80006592:	ffffe097          	auipc	ra,0xffffe
    80006596:	ee2080e7          	jalr	-286(ra) # 80004474 <itrunc>
    8000659a:	b735                	j	800064c6 <sys_open+0xd0>

000000008000659c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000659c:	7175                	addi	sp,sp,-144
    8000659e:	e506                	sd	ra,136(sp)
    800065a0:	e122                	sd	s0,128(sp)
    800065a2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800065a4:	ffffe097          	auipc	ra,0xffffe
    800065a8:	7a8080e7          	jalr	1960(ra) # 80004d4c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800065ac:	08000613          	li	a2,128
    800065b0:	f7040593          	addi	a1,s0,-144
    800065b4:	4501                	li	a0,0
    800065b6:	ffffd097          	auipc	ra,0xffffd
    800065ba:	020080e7          	jalr	32(ra) # 800035d6 <argstr>
    800065be:	02054963          	bltz	a0,800065f0 <sys_mkdir+0x54>
    800065c2:	4681                	li	a3,0
    800065c4:	4601                	li	a2,0
    800065c6:	4585                	li	a1,1
    800065c8:	f7040513          	addi	a0,s0,-144
    800065cc:	fffff097          	auipc	ra,0xfffff
    800065d0:	7c4080e7          	jalr	1988(ra) # 80005d90 <create>
    800065d4:	cd11                	beqz	a0,800065f0 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800065d6:	ffffe097          	auipc	ra,0xffffe
    800065da:	ff2080e7          	jalr	-14(ra) # 800045c8 <iunlockput>
  end_op();
    800065de:	ffffe097          	auipc	ra,0xffffe
    800065e2:	7e8080e7          	jalr	2024(ra) # 80004dc6 <end_op>
  return 0;
    800065e6:	4501                	li	a0,0
}
    800065e8:	60aa                	ld	ra,136(sp)
    800065ea:	640a                	ld	s0,128(sp)
    800065ec:	6149                	addi	sp,sp,144
    800065ee:	8082                	ret
    end_op();
    800065f0:	ffffe097          	auipc	ra,0xffffe
    800065f4:	7d6080e7          	jalr	2006(ra) # 80004dc6 <end_op>
    return -1;
    800065f8:	557d                	li	a0,-1
    800065fa:	b7fd                	j	800065e8 <sys_mkdir+0x4c>

00000000800065fc <sys_mknod>:

uint64
sys_mknod(void)
{
    800065fc:	7135                	addi	sp,sp,-160
    800065fe:	ed06                	sd	ra,152(sp)
    80006600:	e922                	sd	s0,144(sp)
    80006602:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80006604:	ffffe097          	auipc	ra,0xffffe
    80006608:	748080e7          	jalr	1864(ra) # 80004d4c <begin_op>
  argint(1, &major);
    8000660c:	f6c40593          	addi	a1,s0,-148
    80006610:	4505                	li	a0,1
    80006612:	ffffd097          	auipc	ra,0xffffd
    80006616:	f84080e7          	jalr	-124(ra) # 80003596 <argint>
  argint(2, &minor);
    8000661a:	f6840593          	addi	a1,s0,-152
    8000661e:	4509                	li	a0,2
    80006620:	ffffd097          	auipc	ra,0xffffd
    80006624:	f76080e7          	jalr	-138(ra) # 80003596 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006628:	08000613          	li	a2,128
    8000662c:	f7040593          	addi	a1,s0,-144
    80006630:	4501                	li	a0,0
    80006632:	ffffd097          	auipc	ra,0xffffd
    80006636:	fa4080e7          	jalr	-92(ra) # 800035d6 <argstr>
    8000663a:	02054b63          	bltz	a0,80006670 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000663e:	f6841683          	lh	a3,-152(s0)
    80006642:	f6c41603          	lh	a2,-148(s0)
    80006646:	458d                	li	a1,3
    80006648:	f7040513          	addi	a0,s0,-144
    8000664c:	fffff097          	auipc	ra,0xfffff
    80006650:	744080e7          	jalr	1860(ra) # 80005d90 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006654:	cd11                	beqz	a0,80006670 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006656:	ffffe097          	auipc	ra,0xffffe
    8000665a:	f72080e7          	jalr	-142(ra) # 800045c8 <iunlockput>
  end_op();
    8000665e:	ffffe097          	auipc	ra,0xffffe
    80006662:	768080e7          	jalr	1896(ra) # 80004dc6 <end_op>
  return 0;
    80006666:	4501                	li	a0,0
}
    80006668:	60ea                	ld	ra,152(sp)
    8000666a:	644a                	ld	s0,144(sp)
    8000666c:	610d                	addi	sp,sp,160
    8000666e:	8082                	ret
    end_op();
    80006670:	ffffe097          	auipc	ra,0xffffe
    80006674:	756080e7          	jalr	1878(ra) # 80004dc6 <end_op>
    return -1;
    80006678:	557d                	li	a0,-1
    8000667a:	b7fd                	j	80006668 <sys_mknod+0x6c>

000000008000667c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000667c:	7135                	addi	sp,sp,-160
    8000667e:	ed06                	sd	ra,152(sp)
    80006680:	e922                	sd	s0,144(sp)
    80006682:	e14a                	sd	s2,128(sp)
    80006684:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80006686:	ffffc097          	auipc	ra,0xffffc
    8000668a:	89c080e7          	jalr	-1892(ra) # 80001f22 <myproc>
    8000668e:	892a                	mv	s2,a0
  
  begin_op();
    80006690:	ffffe097          	auipc	ra,0xffffe
    80006694:	6bc080e7          	jalr	1724(ra) # 80004d4c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006698:	08000613          	li	a2,128
    8000669c:	f6040593          	addi	a1,s0,-160
    800066a0:	4501                	li	a0,0
    800066a2:	ffffd097          	auipc	ra,0xffffd
    800066a6:	f34080e7          	jalr	-204(ra) # 800035d6 <argstr>
    800066aa:	04054d63          	bltz	a0,80006704 <sys_chdir+0x88>
    800066ae:	e526                	sd	s1,136(sp)
    800066b0:	f6040513          	addi	a0,s0,-160
    800066b4:	ffffe097          	auipc	ra,0xffffe
    800066b8:	492080e7          	jalr	1170(ra) # 80004b46 <namei>
    800066bc:	84aa                	mv	s1,a0
    800066be:	c131                	beqz	a0,80006702 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800066c0:	ffffe097          	auipc	ra,0xffffe
    800066c4:	ca2080e7          	jalr	-862(ra) # 80004362 <ilock>
  if(ip->type != T_DIR){
    800066c8:	04449703          	lh	a4,68(s1)
    800066cc:	4785                	li	a5,1
    800066ce:	04f71163          	bne	a4,a5,80006710 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800066d2:	8526                	mv	a0,s1
    800066d4:	ffffe097          	auipc	ra,0xffffe
    800066d8:	d54080e7          	jalr	-684(ra) # 80004428 <iunlock>
  iput(p->cwd);
    800066dc:	15093503          	ld	a0,336(s2)
    800066e0:	ffffe097          	auipc	ra,0xffffe
    800066e4:	e40080e7          	jalr	-448(ra) # 80004520 <iput>
  end_op();
    800066e8:	ffffe097          	auipc	ra,0xffffe
    800066ec:	6de080e7          	jalr	1758(ra) # 80004dc6 <end_op>
  p->cwd = ip;
    800066f0:	14993823          	sd	s1,336(s2)
  return 0;
    800066f4:	4501                	li	a0,0
    800066f6:	64aa                	ld	s1,136(sp)
}
    800066f8:	60ea                	ld	ra,152(sp)
    800066fa:	644a                	ld	s0,144(sp)
    800066fc:	690a                	ld	s2,128(sp)
    800066fe:	610d                	addi	sp,sp,160
    80006700:	8082                	ret
    80006702:	64aa                	ld	s1,136(sp)
    end_op();
    80006704:	ffffe097          	auipc	ra,0xffffe
    80006708:	6c2080e7          	jalr	1730(ra) # 80004dc6 <end_op>
    return -1;
    8000670c:	557d                	li	a0,-1
    8000670e:	b7ed                	j	800066f8 <sys_chdir+0x7c>
    iunlockput(ip);
    80006710:	8526                	mv	a0,s1
    80006712:	ffffe097          	auipc	ra,0xffffe
    80006716:	eb6080e7          	jalr	-330(ra) # 800045c8 <iunlockput>
    end_op();
    8000671a:	ffffe097          	auipc	ra,0xffffe
    8000671e:	6ac080e7          	jalr	1708(ra) # 80004dc6 <end_op>
    return -1;
    80006722:	557d                	li	a0,-1
    80006724:	64aa                	ld	s1,136(sp)
    80006726:	bfc9                	j	800066f8 <sys_chdir+0x7c>

0000000080006728 <sys_exec>:

uint64
sys_exec(void)
{
    80006728:	7105                	addi	sp,sp,-480
    8000672a:	ef86                	sd	ra,472(sp)
    8000672c:	eba2                	sd	s0,464(sp)
    8000672e:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006730:	e2840593          	addi	a1,s0,-472
    80006734:	4505                	li	a0,1
    80006736:	ffffd097          	auipc	ra,0xffffd
    8000673a:	e80080e7          	jalr	-384(ra) # 800035b6 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000673e:	08000613          	li	a2,128
    80006742:	f3040593          	addi	a1,s0,-208
    80006746:	4501                	li	a0,0
    80006748:	ffffd097          	auipc	ra,0xffffd
    8000674c:	e8e080e7          	jalr	-370(ra) # 800035d6 <argstr>
    80006750:	87aa                	mv	a5,a0
    return -1;
    80006752:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006754:	0e07ce63          	bltz	a5,80006850 <sys_exec+0x128>
    80006758:	e7a6                	sd	s1,456(sp)
    8000675a:	e3ca                	sd	s2,448(sp)
    8000675c:	ff4e                	sd	s3,440(sp)
    8000675e:	fb52                	sd	s4,432(sp)
    80006760:	f756                	sd	s5,424(sp)
    80006762:	f35a                	sd	s6,416(sp)
    80006764:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80006766:	e3040a13          	addi	s4,s0,-464
    8000676a:	10000613          	li	a2,256
    8000676e:	4581                	li	a1,0
    80006770:	8552                	mv	a0,s4
    80006772:	ffffa097          	auipc	ra,0xffffa
    80006776:	69c080e7          	jalr	1692(ra) # 80000e0e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000677a:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000677c:	89d2                	mv	s3,s4
    8000677e:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006780:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006784:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80006786:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000678a:	00391513          	slli	a0,s2,0x3
    8000678e:	85d6                	mv	a1,s5
    80006790:	e2843783          	ld	a5,-472(s0)
    80006794:	953e                	add	a0,a0,a5
    80006796:	ffffd097          	auipc	ra,0xffffd
    8000679a:	d62080e7          	jalr	-670(ra) # 800034f8 <fetchaddr>
    8000679e:	02054a63          	bltz	a0,800067d2 <sys_exec+0xaa>
    if(uarg == 0){
    800067a2:	e2043783          	ld	a5,-480(s0)
    800067a6:	cbb1                	beqz	a5,800067fa <sys_exec+0xd2>
    argv[i] = kalloc();
    800067a8:	ffffa097          	auipc	ra,0xffffa
    800067ac:	45c080e7          	jalr	1116(ra) # 80000c04 <kalloc>
    800067b0:	85aa                	mv	a1,a0
    800067b2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800067b6:	cd11                	beqz	a0,800067d2 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800067b8:	865a                	mv	a2,s6
    800067ba:	e2043503          	ld	a0,-480(s0)
    800067be:	ffffd097          	auipc	ra,0xffffd
    800067c2:	d8c080e7          	jalr	-628(ra) # 8000354a <fetchstr>
    800067c6:	00054663          	bltz	a0,800067d2 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    800067ca:	0905                	addi	s2,s2,1
    800067cc:	09a1                	addi	s3,s3,8
    800067ce:	fb791ee3          	bne	s2,s7,8000678a <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800067d2:	100a0a13          	addi	s4,s4,256
    800067d6:	6088                	ld	a0,0(s1)
    800067d8:	c525                	beqz	a0,80006840 <sys_exec+0x118>
    kfree(argv[i]);
    800067da:	ffffa097          	auipc	ra,0xffffa
    800067de:	2c2080e7          	jalr	706(ra) # 80000a9c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800067e2:	04a1                	addi	s1,s1,8
    800067e4:	ff4499e3          	bne	s1,s4,800067d6 <sys_exec+0xae>
  return -1;
    800067e8:	557d                	li	a0,-1
    800067ea:	64be                	ld	s1,456(sp)
    800067ec:	691e                	ld	s2,448(sp)
    800067ee:	79fa                	ld	s3,440(sp)
    800067f0:	7a5a                	ld	s4,432(sp)
    800067f2:	7aba                	ld	s5,424(sp)
    800067f4:	7b1a                	ld	s6,416(sp)
    800067f6:	6bfa                	ld	s7,408(sp)
    800067f8:	a8a1                	j	80006850 <sys_exec+0x128>
      argv[i] = 0;
    800067fa:	0009079b          	sext.w	a5,s2
    800067fe:	e3040593          	addi	a1,s0,-464
    80006802:	078e                	slli	a5,a5,0x3
    80006804:	97ae                	add	a5,a5,a1
    80006806:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    8000680a:	f3040513          	addi	a0,s0,-208
    8000680e:	fffff097          	auipc	ra,0xfffff
    80006812:	118080e7          	jalr	280(ra) # 80005926 <exec>
    80006816:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006818:	100a0a13          	addi	s4,s4,256
    8000681c:	6088                	ld	a0,0(s1)
    8000681e:	c901                	beqz	a0,8000682e <sys_exec+0x106>
    kfree(argv[i]);
    80006820:	ffffa097          	auipc	ra,0xffffa
    80006824:	27c080e7          	jalr	636(ra) # 80000a9c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006828:	04a1                	addi	s1,s1,8
    8000682a:	ff4499e3          	bne	s1,s4,8000681c <sys_exec+0xf4>
  return ret;
    8000682e:	854a                	mv	a0,s2
    80006830:	64be                	ld	s1,456(sp)
    80006832:	691e                	ld	s2,448(sp)
    80006834:	79fa                	ld	s3,440(sp)
    80006836:	7a5a                	ld	s4,432(sp)
    80006838:	7aba                	ld	s5,424(sp)
    8000683a:	7b1a                	ld	s6,416(sp)
    8000683c:	6bfa                	ld	s7,408(sp)
    8000683e:	a809                	j	80006850 <sys_exec+0x128>
  return -1;
    80006840:	557d                	li	a0,-1
    80006842:	64be                	ld	s1,456(sp)
    80006844:	691e                	ld	s2,448(sp)
    80006846:	79fa                	ld	s3,440(sp)
    80006848:	7a5a                	ld	s4,432(sp)
    8000684a:	7aba                	ld	s5,424(sp)
    8000684c:	7b1a                	ld	s6,416(sp)
    8000684e:	6bfa                	ld	s7,408(sp)
}
    80006850:	60fe                	ld	ra,472(sp)
    80006852:	645e                	ld	s0,464(sp)
    80006854:	613d                	addi	sp,sp,480
    80006856:	8082                	ret

0000000080006858 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006858:	7139                	addi	sp,sp,-64
    8000685a:	fc06                	sd	ra,56(sp)
    8000685c:	f822                	sd	s0,48(sp)
    8000685e:	f426                	sd	s1,40(sp)
    80006860:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006862:	ffffb097          	auipc	ra,0xffffb
    80006866:	6c0080e7          	jalr	1728(ra) # 80001f22 <myproc>
    8000686a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000686c:	fd840593          	addi	a1,s0,-40
    80006870:	4501                	li	a0,0
    80006872:	ffffd097          	auipc	ra,0xffffd
    80006876:	d44080e7          	jalr	-700(ra) # 800035b6 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000687a:	fc840593          	addi	a1,s0,-56
    8000687e:	fd040513          	addi	a0,s0,-48
    80006882:	fffff097          	auipc	ra,0xfffff
    80006886:	d0e080e7          	jalr	-754(ra) # 80005590 <pipealloc>
    return -1;
    8000688a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000688c:	0c054463          	bltz	a0,80006954 <sys_pipe+0xfc>
  fd0 = -1;
    80006890:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006894:	fd043503          	ld	a0,-48(s0)
    80006898:	fffff097          	auipc	ra,0xfffff
    8000689c:	4b6080e7          	jalr	1206(ra) # 80005d4e <fdalloc>
    800068a0:	fca42223          	sw	a0,-60(s0)
    800068a4:	08054b63          	bltz	a0,8000693a <sys_pipe+0xe2>
    800068a8:	fc843503          	ld	a0,-56(s0)
    800068ac:	fffff097          	auipc	ra,0xfffff
    800068b0:	4a2080e7          	jalr	1186(ra) # 80005d4e <fdalloc>
    800068b4:	fca42023          	sw	a0,-64(s0)
    800068b8:	06054863          	bltz	a0,80006928 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800068bc:	4691                	li	a3,4
    800068be:	fc440613          	addi	a2,s0,-60
    800068c2:	fd843583          	ld	a1,-40(s0)
    800068c6:	68a8                	ld	a0,80(s1)
    800068c8:	ffffb097          	auipc	ra,0xffffb
    800068cc:	302080e7          	jalr	770(ra) # 80001bca <copyout>
    800068d0:	02054063          	bltz	a0,800068f0 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800068d4:	4691                	li	a3,4
    800068d6:	fc040613          	addi	a2,s0,-64
    800068da:	fd843583          	ld	a1,-40(s0)
    800068de:	95b6                	add	a1,a1,a3
    800068e0:	68a8                	ld	a0,80(s1)
    800068e2:	ffffb097          	auipc	ra,0xffffb
    800068e6:	2e8080e7          	jalr	744(ra) # 80001bca <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800068ea:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800068ec:	06055463          	bgez	a0,80006954 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800068f0:	fc442783          	lw	a5,-60(s0)
    800068f4:	07e9                	addi	a5,a5,26
    800068f6:	078e                	slli	a5,a5,0x3
    800068f8:	97a6                	add	a5,a5,s1
    800068fa:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800068fe:	fc042783          	lw	a5,-64(s0)
    80006902:	07e9                	addi	a5,a5,26
    80006904:	078e                	slli	a5,a5,0x3
    80006906:	94be                	add	s1,s1,a5
    80006908:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000690c:	fd043503          	ld	a0,-48(s0)
    80006910:	fffff097          	auipc	ra,0xfffff
    80006914:	90c080e7          	jalr	-1780(ra) # 8000521c <fileclose>
    fileclose(wf);
    80006918:	fc843503          	ld	a0,-56(s0)
    8000691c:	fffff097          	auipc	ra,0xfffff
    80006920:	900080e7          	jalr	-1792(ra) # 8000521c <fileclose>
    return -1;
    80006924:	57fd                	li	a5,-1
    80006926:	a03d                	j	80006954 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006928:	fc442783          	lw	a5,-60(s0)
    8000692c:	0007c763          	bltz	a5,8000693a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006930:	07e9                	addi	a5,a5,26
    80006932:	078e                	slli	a5,a5,0x3
    80006934:	97a6                	add	a5,a5,s1
    80006936:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000693a:	fd043503          	ld	a0,-48(s0)
    8000693e:	fffff097          	auipc	ra,0xfffff
    80006942:	8de080e7          	jalr	-1826(ra) # 8000521c <fileclose>
    fileclose(wf);
    80006946:	fc843503          	ld	a0,-56(s0)
    8000694a:	fffff097          	auipc	ra,0xfffff
    8000694e:	8d2080e7          	jalr	-1838(ra) # 8000521c <fileclose>
    return -1;
    80006952:	57fd                	li	a5,-1
}
    80006954:	853e                	mv	a0,a5
    80006956:	70e2                	ld	ra,56(sp)
    80006958:	7442                	ld	s0,48(sp)
    8000695a:	74a2                	ld	s1,40(sp)
    8000695c:	6121                	addi	sp,sp,64
    8000695e:	8082                	ret

0000000080006960 <kernelvec>:
    80006960:	7111                	addi	sp,sp,-256
    80006962:	e006                	sd	ra,0(sp)
    80006964:	e40a                	sd	sp,8(sp)
    80006966:	e80e                	sd	gp,16(sp)
    80006968:	ec12                	sd	tp,24(sp)
    8000696a:	f016                	sd	t0,32(sp)
    8000696c:	f41a                	sd	t1,40(sp)
    8000696e:	f81e                	sd	t2,48(sp)
    80006970:	fc22                	sd	s0,56(sp)
    80006972:	e0a6                	sd	s1,64(sp)
    80006974:	e4aa                	sd	a0,72(sp)
    80006976:	e8ae                	sd	a1,80(sp)
    80006978:	ecb2                	sd	a2,88(sp)
    8000697a:	f0b6                	sd	a3,96(sp)
    8000697c:	f4ba                	sd	a4,104(sp)
    8000697e:	f8be                	sd	a5,112(sp)
    80006980:	fcc2                	sd	a6,120(sp)
    80006982:	e146                	sd	a7,128(sp)
    80006984:	e54a                	sd	s2,136(sp)
    80006986:	e94e                	sd	s3,144(sp)
    80006988:	ed52                	sd	s4,152(sp)
    8000698a:	f156                	sd	s5,160(sp)
    8000698c:	f55a                	sd	s6,168(sp)
    8000698e:	f95e                	sd	s7,176(sp)
    80006990:	fd62                	sd	s8,184(sp)
    80006992:	e1e6                	sd	s9,192(sp)
    80006994:	e5ea                	sd	s10,200(sp)
    80006996:	e9ee                	sd	s11,208(sp)
    80006998:	edf2                	sd	t3,216(sp)
    8000699a:	f1f6                	sd	t4,224(sp)
    8000699c:	f5fa                	sd	t5,232(sp)
    8000699e:	f9fe                	sd	t6,240(sp)
    800069a0:	a25fc0ef          	jal	800033c4 <kerneltrap>
    800069a4:	6082                	ld	ra,0(sp)
    800069a6:	6122                	ld	sp,8(sp)
    800069a8:	61c2                	ld	gp,16(sp)
    800069aa:	7282                	ld	t0,32(sp)
    800069ac:	7322                	ld	t1,40(sp)
    800069ae:	73c2                	ld	t2,48(sp)
    800069b0:	7462                	ld	s0,56(sp)
    800069b2:	6486                	ld	s1,64(sp)
    800069b4:	6526                	ld	a0,72(sp)
    800069b6:	65c6                	ld	a1,80(sp)
    800069b8:	6666                	ld	a2,88(sp)
    800069ba:	7686                	ld	a3,96(sp)
    800069bc:	7726                	ld	a4,104(sp)
    800069be:	77c6                	ld	a5,112(sp)
    800069c0:	7866                	ld	a6,120(sp)
    800069c2:	688a                	ld	a7,128(sp)
    800069c4:	692a                	ld	s2,136(sp)
    800069c6:	69ca                	ld	s3,144(sp)
    800069c8:	6a6a                	ld	s4,152(sp)
    800069ca:	7a8a                	ld	s5,160(sp)
    800069cc:	7b2a                	ld	s6,168(sp)
    800069ce:	7bca                	ld	s7,176(sp)
    800069d0:	7c6a                	ld	s8,184(sp)
    800069d2:	6c8e                	ld	s9,192(sp)
    800069d4:	6d2e                	ld	s10,200(sp)
    800069d6:	6dce                	ld	s11,208(sp)
    800069d8:	6e6e                	ld	t3,216(sp)
    800069da:	7e8e                	ld	t4,224(sp)
    800069dc:	7f2e                	ld	t5,232(sp)
    800069de:	7fce                	ld	t6,240(sp)
    800069e0:	6111                	addi	sp,sp,256
    800069e2:	10200073          	sret
    800069e6:	00000013          	nop
    800069ea:	00000013          	nop
    800069ee:	0001                	nop

00000000800069f0 <timervec>:
    800069f0:	34051573          	csrrw	a0,mscratch,a0
    800069f4:	e10c                	sd	a1,0(a0)
    800069f6:	e510                	sd	a2,8(a0)
    800069f8:	e914                	sd	a3,16(a0)
    800069fa:	6d0c                	ld	a1,24(a0)
    800069fc:	7110                	ld	a2,32(a0)
    800069fe:	6194                	ld	a3,0(a1)
    80006a00:	96b2                	add	a3,a3,a2
    80006a02:	e194                	sd	a3,0(a1)
    80006a04:	4589                	li	a1,2
    80006a06:	14459073          	csrw	sip,a1
    80006a0a:	6914                	ld	a3,16(a0)
    80006a0c:	6510                	ld	a2,8(a0)
    80006a0e:	610c                	ld	a1,0(a0)
    80006a10:	34051573          	csrrw	a0,mscratch,a0
    80006a14:	30200073          	mret
	...

0000000080006a1a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80006a1a:	1141                	addi	sp,sp,-16
    80006a1c:	e406                	sd	ra,8(sp)
    80006a1e:	e022                	sd	s0,0(sp)
    80006a20:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006a22:	0c000737          	lui	a4,0xc000
    80006a26:	4785                	li	a5,1
    80006a28:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006a2a:	c35c                	sw	a5,4(a4)
  *(uint32*)(PLIC + VIRTIO1_IRQ*4) = 1;
    80006a2c:	c71c                	sw	a5,8(a4)
}
    80006a2e:	60a2                	ld	ra,8(sp)
    80006a30:	6402                	ld	s0,0(sp)
    80006a32:	0141                	addi	sp,sp,16
    80006a34:	8082                	ret

0000000080006a36 <plicinithart>:

void
plicinithart(void)
{
    80006a36:	1141                	addi	sp,sp,-16
    80006a38:	e406                	sd	ra,8(sp)
    80006a3a:	e022                	sd	s0,0(sp)
    80006a3c:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006a3e:	ffffb097          	auipc	ra,0xffffb
    80006a42:	4b0080e7          	jalr	1200(ra) # 80001eee <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ) | (1 << VIRTIO1_IRQ);
    80006a46:	0085171b          	slliw	a4,a0,0x8
    80006a4a:	0c0027b7          	lui	a5,0xc002
    80006a4e:	97ba                	add	a5,a5,a4
    80006a50:	40600713          	li	a4,1030
    80006a54:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006a58:	00d5151b          	slliw	a0,a0,0xd
    80006a5c:	0c2017b7          	lui	a5,0xc201
    80006a60:	97aa                	add	a5,a5,a0
    80006a62:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006a66:	60a2                	ld	ra,8(sp)
    80006a68:	6402                	ld	s0,0(sp)
    80006a6a:	0141                	addi	sp,sp,16
    80006a6c:	8082                	ret

0000000080006a6e <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006a6e:	1141                	addi	sp,sp,-16
    80006a70:	e406                	sd	ra,8(sp)
    80006a72:	e022                	sd	s0,0(sp)
    80006a74:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006a76:	ffffb097          	auipc	ra,0xffffb
    80006a7a:	478080e7          	jalr	1144(ra) # 80001eee <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006a7e:	00d5151b          	slliw	a0,a0,0xd
    80006a82:	0c2017b7          	lui	a5,0xc201
    80006a86:	97aa                	add	a5,a5,a0
  return irq;
}
    80006a88:	43c8                	lw	a0,4(a5)
    80006a8a:	60a2                	ld	ra,8(sp)
    80006a8c:	6402                	ld	s0,0(sp)
    80006a8e:	0141                	addi	sp,sp,16
    80006a90:	8082                	ret

0000000080006a92 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006a92:	1101                	addi	sp,sp,-32
    80006a94:	ec06                	sd	ra,24(sp)
    80006a96:	e822                	sd	s0,16(sp)
    80006a98:	e426                	sd	s1,8(sp)
    80006a9a:	1000                	addi	s0,sp,32
    80006a9c:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006a9e:	ffffb097          	auipc	ra,0xffffb
    80006aa2:	450080e7          	jalr	1104(ra) # 80001eee <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006aa6:	00d5179b          	slliw	a5,a0,0xd
    80006aaa:	0c201737          	lui	a4,0xc201
    80006aae:	97ba                	add	a5,a5,a4
    80006ab0:	c3c4                	sw	s1,4(a5)
}
    80006ab2:	60e2                	ld	ra,24(sp)
    80006ab4:	6442                	ld	s0,16(sp)
    80006ab6:	64a2                	ld	s1,8(sp)
    80006ab8:	6105                	addi	sp,sp,32
    80006aba:	8082                	ret

0000000080006abc <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006abc:	1141                	addi	sp,sp,-16
    80006abe:	e406                	sd	ra,8(sp)
    80006ac0:	e022                	sd	s0,0(sp)
    80006ac2:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006ac4:	479d                	li	a5,7
    80006ac6:	04a7cc63          	blt	a5,a0,80006b1e <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006aca:	00067797          	auipc	a5,0x67
    80006ace:	61678793          	addi	a5,a5,1558 # 8006e0e0 <disk>
    80006ad2:	97aa                	add	a5,a5,a0
    80006ad4:	0187c783          	lbu	a5,24(a5)
    80006ad8:	ebb9                	bnez	a5,80006b2e <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006ada:	00451693          	slli	a3,a0,0x4
    80006ade:	00067797          	auipc	a5,0x67
    80006ae2:	60278793          	addi	a5,a5,1538 # 8006e0e0 <disk>
    80006ae6:	6398                	ld	a4,0(a5)
    80006ae8:	9736                	add	a4,a4,a3
    80006aea:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80006aee:	6398                	ld	a4,0(a5)
    80006af0:	9736                	add	a4,a4,a3
    80006af2:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006af6:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006afa:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006afe:	97aa                	add	a5,a5,a0
    80006b00:	4705                	li	a4,1
    80006b02:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006b06:	00067517          	auipc	a0,0x67
    80006b0a:	5f250513          	addi	a0,a0,1522 # 8006e0f8 <disk+0x18>
    80006b0e:	ffffc097          	auipc	ra,0xffffc
    80006b12:	d80080e7          	jalr	-640(ra) # 8000288e <wakeup>
}
    80006b16:	60a2                	ld	ra,8(sp)
    80006b18:	6402                	ld	s0,0(sp)
    80006b1a:	0141                	addi	sp,sp,16
    80006b1c:	8082                	ret
    panic("free_desc 1");
    80006b1e:	00003517          	auipc	a0,0x3
    80006b22:	bfa50513          	addi	a0,a0,-1030 # 80009718 <etext+0x718>
    80006b26:	ffffa097          	auipc	ra,0xffffa
    80006b2a:	a3a080e7          	jalr	-1478(ra) # 80000560 <panic>
    panic("free_desc 2");
    80006b2e:	00003517          	auipc	a0,0x3
    80006b32:	bfa50513          	addi	a0,a0,-1030 # 80009728 <etext+0x728>
    80006b36:	ffffa097          	auipc	ra,0xffffa
    80006b3a:	a2a080e7          	jalr	-1494(ra) # 80000560 <panic>

0000000080006b3e <virtio_disk_init>:
{
    80006b3e:	1101                	addi	sp,sp,-32
    80006b40:	ec06                	sd	ra,24(sp)
    80006b42:	e822                	sd	s0,16(sp)
    80006b44:	e426                	sd	s1,8(sp)
    80006b46:	e04a                	sd	s2,0(sp)
    80006b48:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006b4a:	00003597          	auipc	a1,0x3
    80006b4e:	bee58593          	addi	a1,a1,-1042 # 80009738 <etext+0x738>
    80006b52:	00067517          	auipc	a0,0x67
    80006b56:	6b650513          	addi	a0,a0,1718 # 8006e208 <disk+0x128>
    80006b5a:	ffffa097          	auipc	ra,0xffffa
    80006b5e:	128080e7          	jalr	296(ra) # 80000c82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006b62:	100017b7          	lui	a5,0x10001
    80006b66:	4398                	lw	a4,0(a5)
    80006b68:	2701                	sext.w	a4,a4
    80006b6a:	747277b7          	lui	a5,0x74727
    80006b6e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006b72:	16f71463          	bne	a4,a5,80006cda <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006b76:	100017b7          	lui	a5,0x10001
    80006b7a:	43dc                	lw	a5,4(a5)
    80006b7c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006b7e:	4709                	li	a4,2
    80006b80:	14e79d63          	bne	a5,a4,80006cda <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006b84:	100017b7          	lui	a5,0x10001
    80006b88:	479c                	lw	a5,8(a5)
    80006b8a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006b8c:	14e79763          	bne	a5,a4,80006cda <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006b90:	100017b7          	lui	a5,0x10001
    80006b94:	47d8                	lw	a4,12(a5)
    80006b96:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006b98:	554d47b7          	lui	a5,0x554d4
    80006b9c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006ba0:	12f71d63          	bne	a4,a5,80006cda <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006ba4:	100017b7          	lui	a5,0x10001
    80006ba8:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006bac:	4705                	li	a4,1
    80006bae:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006bb0:	470d                	li	a4,3
    80006bb2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006bb4:	10001737          	lui	a4,0x10001
    80006bb8:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006bba:	c7ffe6b7          	lui	a3,0xc7ffe
    80006bbe:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f904c7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006bc2:	8f75                	and	a4,a4,a3
    80006bc4:	100016b7          	lui	a3,0x10001
    80006bc8:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006bca:	472d                	li	a4,11
    80006bcc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006bce:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006bd2:	439c                	lw	a5,0(a5)
    80006bd4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006bd8:	8ba1                	andi	a5,a5,8
    80006bda:	10078863          	beqz	a5,80006cea <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006bde:	100017b7          	lui	a5,0x10001
    80006be2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006be6:	43fc                	lw	a5,68(a5)
    80006be8:	2781                	sext.w	a5,a5
    80006bea:	10079863          	bnez	a5,80006cfa <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006bee:	100017b7          	lui	a5,0x10001
    80006bf2:	5bdc                	lw	a5,52(a5)
    80006bf4:	2781                	sext.w	a5,a5
  if(max == 0)
    80006bf6:	10078a63          	beqz	a5,80006d0a <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006bfa:	471d                	li	a4,7
    80006bfc:	10f77f63          	bgeu	a4,a5,80006d1a <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    80006c00:	ffffa097          	auipc	ra,0xffffa
    80006c04:	004080e7          	jalr	4(ra) # 80000c04 <kalloc>
    80006c08:	00067497          	auipc	s1,0x67
    80006c0c:	4d848493          	addi	s1,s1,1240 # 8006e0e0 <disk>
    80006c10:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006c12:	ffffa097          	auipc	ra,0xffffa
    80006c16:	ff2080e7          	jalr	-14(ra) # 80000c04 <kalloc>
    80006c1a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006c1c:	ffffa097          	auipc	ra,0xffffa
    80006c20:	fe8080e7          	jalr	-24(ra) # 80000c04 <kalloc>
    80006c24:	87aa                	mv	a5,a0
    80006c26:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006c28:	6088                	ld	a0,0(s1)
    80006c2a:	10050063          	beqz	a0,80006d2a <virtio_disk_init+0x1ec>
    80006c2e:	00067717          	auipc	a4,0x67
    80006c32:	4ba73703          	ld	a4,1210(a4) # 8006e0e8 <disk+0x8>
    80006c36:	cb75                	beqz	a4,80006d2a <virtio_disk_init+0x1ec>
    80006c38:	cbed                	beqz	a5,80006d2a <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006c3a:	6605                	lui	a2,0x1
    80006c3c:	4581                	li	a1,0
    80006c3e:	ffffa097          	auipc	ra,0xffffa
    80006c42:	1d0080e7          	jalr	464(ra) # 80000e0e <memset>
  memset(disk.avail, 0, PGSIZE);
    80006c46:	00067497          	auipc	s1,0x67
    80006c4a:	49a48493          	addi	s1,s1,1178 # 8006e0e0 <disk>
    80006c4e:	6605                	lui	a2,0x1
    80006c50:	4581                	li	a1,0
    80006c52:	6488                	ld	a0,8(s1)
    80006c54:	ffffa097          	auipc	ra,0xffffa
    80006c58:	1ba080e7          	jalr	442(ra) # 80000e0e <memset>
  memset(disk.used, 0, PGSIZE);
    80006c5c:	6605                	lui	a2,0x1
    80006c5e:	4581                	li	a1,0
    80006c60:	6888                	ld	a0,16(s1)
    80006c62:	ffffa097          	auipc	ra,0xffffa
    80006c66:	1ac080e7          	jalr	428(ra) # 80000e0e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006c6a:	100017b7          	lui	a5,0x10001
    80006c6e:	4721                	li	a4,8
    80006c70:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006c72:	4098                	lw	a4,0(s1)
    80006c74:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006c78:	40d8                	lw	a4,4(s1)
    80006c7a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006c7e:	649c                	ld	a5,8(s1)
    80006c80:	0007869b          	sext.w	a3,a5
    80006c84:	10001737          	lui	a4,0x10001
    80006c88:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006c8c:	9781                	srai	a5,a5,0x20
    80006c8e:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006c92:	689c                	ld	a5,16(s1)
    80006c94:	0007869b          	sext.w	a3,a5
    80006c98:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006c9c:	9781                	srai	a5,a5,0x20
    80006c9e:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006ca2:	4785                	li	a5,1
    80006ca4:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006ca6:	00f48c23          	sb	a5,24(s1)
    80006caa:	00f48ca3          	sb	a5,25(s1)
    80006cae:	00f48d23          	sb	a5,26(s1)
    80006cb2:	00f48da3          	sb	a5,27(s1)
    80006cb6:	00f48e23          	sb	a5,28(s1)
    80006cba:	00f48ea3          	sb	a5,29(s1)
    80006cbe:	00f48f23          	sb	a5,30(s1)
    80006cc2:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006cc6:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006cca:	07272823          	sw	s2,112(a4)
}
    80006cce:	60e2                	ld	ra,24(sp)
    80006cd0:	6442                	ld	s0,16(sp)
    80006cd2:	64a2                	ld	s1,8(sp)
    80006cd4:	6902                	ld	s2,0(sp)
    80006cd6:	6105                	addi	sp,sp,32
    80006cd8:	8082                	ret
    panic("could not find virtio disk");
    80006cda:	00003517          	auipc	a0,0x3
    80006cde:	a6e50513          	addi	a0,a0,-1426 # 80009748 <etext+0x748>
    80006ce2:	ffffa097          	auipc	ra,0xffffa
    80006ce6:	87e080e7          	jalr	-1922(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006cea:	00003517          	auipc	a0,0x3
    80006cee:	a7e50513          	addi	a0,a0,-1410 # 80009768 <etext+0x768>
    80006cf2:	ffffa097          	auipc	ra,0xffffa
    80006cf6:	86e080e7          	jalr	-1938(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006cfa:	00003517          	auipc	a0,0x3
    80006cfe:	a8e50513          	addi	a0,a0,-1394 # 80009788 <etext+0x788>
    80006d02:	ffffa097          	auipc	ra,0xffffa
    80006d06:	85e080e7          	jalr	-1954(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006d0a:	00003517          	auipc	a0,0x3
    80006d0e:	a9e50513          	addi	a0,a0,-1378 # 800097a8 <etext+0x7a8>
    80006d12:	ffffa097          	auipc	ra,0xffffa
    80006d16:	84e080e7          	jalr	-1970(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006d1a:	00003517          	auipc	a0,0x3
    80006d1e:	aae50513          	addi	a0,a0,-1362 # 800097c8 <etext+0x7c8>
    80006d22:	ffffa097          	auipc	ra,0xffffa
    80006d26:	83e080e7          	jalr	-1986(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006d2a:	00003517          	auipc	a0,0x3
    80006d2e:	abe50513          	addi	a0,a0,-1346 # 800097e8 <etext+0x7e8>
    80006d32:	ffffa097          	auipc	ra,0xffffa
    80006d36:	82e080e7          	jalr	-2002(ra) # 80000560 <panic>

0000000080006d3a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006d3a:	711d                	addi	sp,sp,-96
    80006d3c:	ec86                	sd	ra,88(sp)
    80006d3e:	e8a2                	sd	s0,80(sp)
    80006d40:	e4a6                	sd	s1,72(sp)
    80006d42:	e0ca                	sd	s2,64(sp)
    80006d44:	fc4e                	sd	s3,56(sp)
    80006d46:	f852                	sd	s4,48(sp)
    80006d48:	f456                	sd	s5,40(sp)
    80006d4a:	f05a                	sd	s6,32(sp)
    80006d4c:	ec5e                	sd	s7,24(sp)
    80006d4e:	e862                	sd	s8,16(sp)
    80006d50:	1080                	addi	s0,sp,96
    80006d52:	89aa                	mv	s3,a0
    80006d54:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006d56:	00c52b83          	lw	s7,12(a0)
    80006d5a:	001b9b9b          	slliw	s7,s7,0x1
    80006d5e:	1b82                	slli	s7,s7,0x20
    80006d60:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006d64:	00067517          	auipc	a0,0x67
    80006d68:	4a450513          	addi	a0,a0,1188 # 8006e208 <disk+0x128>
    80006d6c:	ffffa097          	auipc	ra,0xffffa
    80006d70:	faa080e7          	jalr	-86(ra) # 80000d16 <acquire>
  for(int i = 0; i < NUM; i++){
    80006d74:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006d76:	00067a97          	auipc	s5,0x67
    80006d7a:	36aa8a93          	addi	s5,s5,874 # 8006e0e0 <disk>
  for(int i = 0; i < 3; i++){
    80006d7e:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006d80:	5c7d                	li	s8,-1
    80006d82:	a885                	j	80006df2 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006d84:	00fa8733          	add	a4,s5,a5
    80006d88:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006d8c:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006d8e:	0207c563          	bltz	a5,80006db8 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006d92:	2905                	addiw	s2,s2,1
    80006d94:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006d96:	07490263          	beq	s2,s4,80006dfa <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006d9a:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006d9c:	00067717          	auipc	a4,0x67
    80006da0:	34470713          	addi	a4,a4,836 # 8006e0e0 <disk>
    80006da4:	4781                	li	a5,0
    if(disk.free[i]){
    80006da6:	01874683          	lbu	a3,24(a4)
    80006daa:	fee9                	bnez	a3,80006d84 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80006dac:	2785                	addiw	a5,a5,1
    80006dae:	0705                	addi	a4,a4,1
    80006db0:	fe979be3          	bne	a5,s1,80006da6 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006db4:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006db8:	03205163          	blez	s2,80006dda <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006dbc:	fa042503          	lw	a0,-96(s0)
    80006dc0:	00000097          	auipc	ra,0x0
    80006dc4:	cfc080e7          	jalr	-772(ra) # 80006abc <free_desc>
      for(int j = 0; j < i; j++)
    80006dc8:	4785                	li	a5,1
    80006dca:	0127d863          	bge	a5,s2,80006dda <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006dce:	fa442503          	lw	a0,-92(s0)
    80006dd2:	00000097          	auipc	ra,0x0
    80006dd6:	cea080e7          	jalr	-790(ra) # 80006abc <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006dda:	00067597          	auipc	a1,0x67
    80006dde:	42e58593          	addi	a1,a1,1070 # 8006e208 <disk+0x128>
    80006de2:	00067517          	auipc	a0,0x67
    80006de6:	31650513          	addi	a0,a0,790 # 8006e0f8 <disk+0x18>
    80006dea:	ffffc097          	auipc	ra,0xffffc
    80006dee:	a40080e7          	jalr	-1472(ra) # 8000282a <sleep>
  for(int i = 0; i < 3; i++){
    80006df2:	fa040613          	addi	a2,s0,-96
    80006df6:	4901                	li	s2,0
    80006df8:	b74d                	j	80006d9a <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006dfa:	fa042503          	lw	a0,-96(s0)
    80006dfe:	00451693          	slli	a3,a0,0x4

  if(write)
    80006e02:	00067797          	auipc	a5,0x67
    80006e06:	2de78793          	addi	a5,a5,734 # 8006e0e0 <disk>
    80006e0a:	00a50713          	addi	a4,a0,10
    80006e0e:	0712                	slli	a4,a4,0x4
    80006e10:	973e                	add	a4,a4,a5
    80006e12:	01603633          	snez	a2,s6
    80006e16:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006e18:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006e1c:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006e20:	6398                	ld	a4,0(a5)
    80006e22:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006e24:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006e28:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006e2a:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006e2c:	6390                	ld	a2,0(a5)
    80006e2e:	00d605b3          	add	a1,a2,a3
    80006e32:	4741                	li	a4,16
    80006e34:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006e36:	4805                	li	a6,1
    80006e38:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80006e3c:	fa442703          	lw	a4,-92(s0)
    80006e40:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006e44:	0712                	slli	a4,a4,0x4
    80006e46:	963a                	add	a2,a2,a4
    80006e48:	05898593          	addi	a1,s3,88
    80006e4c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006e4e:	0007b883          	ld	a7,0(a5)
    80006e52:	9746                	add	a4,a4,a7
    80006e54:	40000613          	li	a2,1024
    80006e58:	c710                	sw	a2,8(a4)
  if(write)
    80006e5a:	001b3613          	seqz	a2,s6
    80006e5e:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006e62:	01066633          	or	a2,a2,a6
    80006e66:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006e6a:	fa842583          	lw	a1,-88(s0)
    80006e6e:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006e72:	00250613          	addi	a2,a0,2
    80006e76:	0612                	slli	a2,a2,0x4
    80006e78:	963e                	add	a2,a2,a5
    80006e7a:	577d                	li	a4,-1
    80006e7c:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006e80:	0592                	slli	a1,a1,0x4
    80006e82:	98ae                	add	a7,a7,a1
    80006e84:	03068713          	addi	a4,a3,48
    80006e88:	973e                	add	a4,a4,a5
    80006e8a:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006e8e:	6398                	ld	a4,0(a5)
    80006e90:	972e                	add	a4,a4,a1
    80006e92:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006e96:	4689                	li	a3,2
    80006e98:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006e9c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006ea0:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80006ea4:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006ea8:	6794                	ld	a3,8(a5)
    80006eaa:	0026d703          	lhu	a4,2(a3)
    80006eae:	8b1d                	andi	a4,a4,7
    80006eb0:	0706                	slli	a4,a4,0x1
    80006eb2:	96ba                	add	a3,a3,a4
    80006eb4:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006eb8:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006ebc:	6798                	ld	a4,8(a5)
    80006ebe:	00275783          	lhu	a5,2(a4)
    80006ec2:	2785                	addiw	a5,a5,1
    80006ec4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006ec8:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006ecc:	100017b7          	lui	a5,0x10001
    80006ed0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006ed4:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006ed8:	00067917          	auipc	s2,0x67
    80006edc:	33090913          	addi	s2,s2,816 # 8006e208 <disk+0x128>
  while(b->disk == 1) {
    80006ee0:	84c2                	mv	s1,a6
    80006ee2:	01079c63          	bne	a5,a6,80006efa <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    80006ee6:	85ca                	mv	a1,s2
    80006ee8:	854e                	mv	a0,s3
    80006eea:	ffffc097          	auipc	ra,0xffffc
    80006eee:	940080e7          	jalr	-1728(ra) # 8000282a <sleep>
  while(b->disk == 1) {
    80006ef2:	0049a783          	lw	a5,4(s3)
    80006ef6:	fe9788e3          	beq	a5,s1,80006ee6 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    80006efa:	fa042903          	lw	s2,-96(s0)
    80006efe:	00290713          	addi	a4,s2,2
    80006f02:	0712                	slli	a4,a4,0x4
    80006f04:	00067797          	auipc	a5,0x67
    80006f08:	1dc78793          	addi	a5,a5,476 # 8006e0e0 <disk>
    80006f0c:	97ba                	add	a5,a5,a4
    80006f0e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006f12:	00067997          	auipc	s3,0x67
    80006f16:	1ce98993          	addi	s3,s3,462 # 8006e0e0 <disk>
    80006f1a:	00491713          	slli	a4,s2,0x4
    80006f1e:	0009b783          	ld	a5,0(s3)
    80006f22:	97ba                	add	a5,a5,a4
    80006f24:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006f28:	854a                	mv	a0,s2
    80006f2a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006f2e:	00000097          	auipc	ra,0x0
    80006f32:	b8e080e7          	jalr	-1138(ra) # 80006abc <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006f36:	8885                	andi	s1,s1,1
    80006f38:	f0ed                	bnez	s1,80006f1a <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006f3a:	00067517          	auipc	a0,0x67
    80006f3e:	2ce50513          	addi	a0,a0,718 # 8006e208 <disk+0x128>
    80006f42:	ffffa097          	auipc	ra,0xffffa
    80006f46:	e84080e7          	jalr	-380(ra) # 80000dc6 <release>
}
    80006f4a:	60e6                	ld	ra,88(sp)
    80006f4c:	6446                	ld	s0,80(sp)
    80006f4e:	64a6                	ld	s1,72(sp)
    80006f50:	6906                	ld	s2,64(sp)
    80006f52:	79e2                	ld	s3,56(sp)
    80006f54:	7a42                	ld	s4,48(sp)
    80006f56:	7aa2                	ld	s5,40(sp)
    80006f58:	7b02                	ld	s6,32(sp)
    80006f5a:	6be2                	ld	s7,24(sp)
    80006f5c:	6c42                	ld	s8,16(sp)
    80006f5e:	6125                	addi	sp,sp,96
    80006f60:	8082                	ret

0000000080006f62 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006f62:	1101                	addi	sp,sp,-32
    80006f64:	ec06                	sd	ra,24(sp)
    80006f66:	e822                	sd	s0,16(sp)
    80006f68:	e426                	sd	s1,8(sp)
    80006f6a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006f6c:	00067497          	auipc	s1,0x67
    80006f70:	17448493          	addi	s1,s1,372 # 8006e0e0 <disk>
    80006f74:	00067517          	auipc	a0,0x67
    80006f78:	29450513          	addi	a0,a0,660 # 8006e208 <disk+0x128>
    80006f7c:	ffffa097          	auipc	ra,0xffffa
    80006f80:	d9a080e7          	jalr	-614(ra) # 80000d16 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006f84:	100017b7          	lui	a5,0x10001
    80006f88:	53bc                	lw	a5,96(a5)
    80006f8a:	8b8d                	andi	a5,a5,3
    80006f8c:	10001737          	lui	a4,0x10001
    80006f90:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006f92:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006f96:	689c                	ld	a5,16(s1)
    80006f98:	0204d703          	lhu	a4,32(s1)
    80006f9c:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006fa0:	04f70863          	beq	a4,a5,80006ff0 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006fa4:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006fa8:	6898                	ld	a4,16(s1)
    80006faa:	0204d783          	lhu	a5,32(s1)
    80006fae:	8b9d                	andi	a5,a5,7
    80006fb0:	078e                	slli	a5,a5,0x3
    80006fb2:	97ba                	add	a5,a5,a4
    80006fb4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006fb6:	00278713          	addi	a4,a5,2
    80006fba:	0712                	slli	a4,a4,0x4
    80006fbc:	9726                	add	a4,a4,s1
    80006fbe:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006fc2:	e721                	bnez	a4,8000700a <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006fc4:	0789                	addi	a5,a5,2
    80006fc6:	0792                	slli	a5,a5,0x4
    80006fc8:	97a6                	add	a5,a5,s1
    80006fca:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006fcc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006fd0:	ffffc097          	auipc	ra,0xffffc
    80006fd4:	8be080e7          	jalr	-1858(ra) # 8000288e <wakeup>

    disk.used_idx += 1;
    80006fd8:	0204d783          	lhu	a5,32(s1)
    80006fdc:	2785                	addiw	a5,a5,1
    80006fde:	17c2                	slli	a5,a5,0x30
    80006fe0:	93c1                	srli	a5,a5,0x30
    80006fe2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006fe6:	6898                	ld	a4,16(s1)
    80006fe8:	00275703          	lhu	a4,2(a4)
    80006fec:	faf71ce3          	bne	a4,a5,80006fa4 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006ff0:	00067517          	auipc	a0,0x67
    80006ff4:	21850513          	addi	a0,a0,536 # 8006e208 <disk+0x128>
    80006ff8:	ffffa097          	auipc	ra,0xffffa
    80006ffc:	dce080e7          	jalr	-562(ra) # 80000dc6 <release>
}
    80007000:	60e2                	ld	ra,24(sp)
    80007002:	6442                	ld	s0,16(sp)
    80007004:	64a2                	ld	s1,8(sp)
    80007006:	6105                	addi	sp,sp,32
    80007008:	8082                	ret
      panic("virtio_disk_intr status");
    8000700a:	00002517          	auipc	a0,0x2
    8000700e:	7f650513          	addi	a0,a0,2038 # 80009800 <etext+0x800>
    80007012:	ffff9097          	auipc	ra,0xffff9
    80007016:	54e080e7          	jalr	1358(ra) # 80000560 <panic>

000000008000701a <alloc_desc>:
 *
 * Output: returns the index of the descriptor on success
 *         returns -1 if there are no free descriptors
 *
 */
int alloc_desc(struct virtq *q) {
    8000701a:	1141                	addi	sp,sp,-16
    8000701c:	e406                	sd	ra,8(sp)
    8000701e:	e022                	sd	s0,0(sp)
    80007020:	0800                	addi	s0,sp,16
    80007022:	862a                	mv	a2,a0
  for (int i = 0; i < NUM; i++) {
    80007024:	01c50793          	addi	a5,a0,28
    80007028:	4501                	li	a0,0
    8000702a:	46a1                	li	a3,8
    if (q->free[i]) {
    8000702c:	0007c703          	lbu	a4,0(a5)
    80007030:	eb11                	bnez	a4,80007044 <alloc_desc+0x2a>
  for (int i = 0; i < NUM; i++) {
    80007032:	2505                	addiw	a0,a0,1
    80007034:	0785                	addi	a5,a5,1
    80007036:	fed51be3          	bne	a0,a3,8000702c <alloc_desc+0x12>
      q->free[i] = 0;
      return i;
    }
  }
  return -1;
    8000703a:	557d                	li	a0,-1
}
    8000703c:	60a2                	ld	ra,8(sp)
    8000703e:	6402                	ld	s0,0(sp)
    80007040:	0141                	addi	sp,sp,16
    80007042:	8082                	ret
      q->free[i] = 0;
    80007044:	962a                	add	a2,a2,a0
    80007046:	00060e23          	sb	zero,28(a2)
      return i;
    8000704a:	bfcd                	j	8000703c <alloc_desc+0x22>

000000008000704c <free_desc>:
 * allocated. int i: the index at which a descriptor has been allocated in q
 *
 * Output: None
 *
 */
void free_desc(struct virtq *q, int i) {
    8000704c:	1141                	addi	sp,sp,-16
    8000704e:	e406                	sd	ra,8(sp)
    80007050:	e022                	sd	s0,0(sp)
    80007052:	0800                	addi	s0,sp,16
  if (i >= NUM)
    80007054:	479d                	li	a5,7
    80007056:	02b7cd63          	blt	a5,a1,80007090 <free_desc+0x44>
    panic("free_desc 1");
  if (q->free[i])
    8000705a:	00b507b3          	add	a5,a0,a1
    8000705e:	01c7c783          	lbu	a5,28(a5)
    80007062:	ef9d                	bnez	a5,800070a0 <free_desc+0x54>
    panic("free_desc 2");

  q->desc->addr = 0;
    80007064:	611c                	ld	a5,0(a0)
    80007066:	0007b023          	sd	zero,0(a5)
  q->desc->len = 0;
    8000706a:	611c                	ld	a5,0(a0)
    8000706c:	0007a423          	sw	zero,8(a5)
  q->desc->flags = 0;
    80007070:	611c                	ld	a5,0(a0)
    80007072:	00079623          	sh	zero,12(a5)
  q->desc->next = 0;
    80007076:	611c                	ld	a5,0(a0)
    80007078:	00079723          	sh	zero,14(a5)
  wakeup(&q->free[i]);
    8000707c:	05f1                	addi	a1,a1,28
    8000707e:	952e                	add	a0,a0,a1
    80007080:	ffffc097          	auipc	ra,0xffffc
    80007084:	80e080e7          	jalr	-2034(ra) # 8000288e <wakeup>
}
    80007088:	60a2                	ld	ra,8(sp)
    8000708a:	6402                	ld	s0,0(sp)
    8000708c:	0141                	addi	sp,sp,16
    8000708e:	8082                	ret
    panic("free_desc 1");
    80007090:	00002517          	auipc	a0,0x2
    80007094:	68850513          	addi	a0,a0,1672 # 80009718 <etext+0x718>
    80007098:	ffff9097          	auipc	ra,0xffff9
    8000709c:	4c8080e7          	jalr	1224(ra) # 80000560 <panic>
    panic("free_desc 2");
    800070a0:	00002517          	auipc	a0,0x2
    800070a4:	68850513          	addi	a0,a0,1672 # 80009728 <etext+0x728>
    800070a8:	ffff9097          	auipc	ra,0xffff9
    800070ac:	4b8080e7          	jalr	1208(ra) # 80000560 <panic>

00000000800070b0 <virtio_net_init>:
 * VirtualIO (VIRTIO) device. The process of this function is defined in
 * section 5.1.5 of the VIRTIO Device specification. Since I'm creating
 * a minimal netowrk driver, I only negotiate VIRTIO_NET_F_MAC
 *
 */
void virtio_net_init(void) {
    800070b0:	7159                	addi	sp,sp,-112
    800070b2:	f486                	sd	ra,104(sp)
    800070b4:	f0a2                	sd	s0,96(sp)
    800070b6:	eca6                	sd	s1,88(sp)
    800070b8:	e8ca                	sd	s2,80(sp)
    800070ba:	e4ce                	sd	s3,72(sp)
    800070bc:	e0d2                	sd	s4,64(sp)
    800070be:	fc56                	sd	s5,56(sp)
    800070c0:	f85a                	sd	s6,48(sp)
    800070c2:	f45e                	sd	s7,40(sp)
    800070c4:	f062                	sd	s8,32(sp)
    800070c6:	ec66                	sd	s9,24(sp)
    800070c8:	e86a                	sd	s10,16(sp)
    800070ca:	e46e                	sd	s11,8(sp)
    800070cc:	1880                	addi	s0,sp,112
  uint32 status = 0;
  initlock(&net.vnet_lock, "virtio_net");
    800070ce:	00002597          	auipc	a1,0x2
    800070d2:	74a58593          	addi	a1,a1,1866 # 80009818 <etext+0x818>
    800070d6:	00067517          	auipc	a0,0x67
    800070da:	15a50513          	addi	a0,a0,346 # 8006e230 <net+0x10>
    800070de:	ffffa097          	auipc	ra,0xffffa
    800070e2:	ba4080e7          	jalr	-1116(ra) # 80000c82 <initlock>

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800070e6:	100027b7          	lui	a5,0x10002
    800070ea:	4398                	lw	a4,0(a5)
    800070ec:	2701                	sext.w	a4,a4
    800070ee:	747277b7          	lui	a5,0x74727
    800070f2:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800070f6:	32f71a63          	bne	a4,a5,8000742a <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    800070fa:	100027b7          	lui	a5,0x10002
    800070fe:	43dc                	lw	a5,4(a5)
    80007100:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80007102:	4709                	li	a4,2
    80007104:	32e79363          	bne	a5,a4,8000742a <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80007108:	100027b7          	lui	a5,0x10002
    8000710c:	479c                	lw	a5,8(a5)
    8000710e:	2781                	sext.w	a5,a5
    80007110:	4705                	li	a4,1
    80007112:	30e79c63          	bne	a5,a4,8000742a <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80007116:	100027b7          	lui	a5,0x10002
    8000711a:	47d8                	lw	a4,12(a5)
    8000711c:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    8000711e:	554d47b7          	lui	a5,0x554d4
    80007122:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80007126:	30f71263          	bne	a4,a5,8000742a <virtio_net_init+0x37a>
    panic("could not find virtio net");
  }

  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    8000712a:	100024b7          	lui	s1,0x10002
    8000712e:	07048493          	addi	s1,s1,112 # 10002070 <_entry-0x6fffdf90>
    80007132:	0004a023          	sw	zero,0(s1)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007136:	4785                	li	a5,1
    80007138:	c09c                	sw	a5,0(s1)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;
    8000713a:	478d                	li	a5,3
    8000713c:	c09c                	sw	a5,0(s1)

  // This copies the memory from the config into my driver state struct
  memmove((void *)&net.cfg, (void *)VIRTIO_NET_CONFIG,
    8000713e:	4631                	li	a2,12
    80007140:	100025b7          	lui	a1,0x10002
    80007144:	10058593          	addi	a1,a1,256 # 10002100 <_entry-0x6fffdf00>
    80007148:	00067517          	auipc	a0,0x67
    8000714c:	0d850513          	addi	a0,a0,216 # 8006e220 <net>
    80007150:	ffffa097          	auipc	ra,0xffffa
    80007154:	d22080e7          	jalr	-734(ra) # 80000e72 <memmove>
          sizeof(struct virtio_net_config));

  // Negotiate the feature bits
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80007158:	100027b7          	lui	a5,0x10002
    8000715c:	4b9c                	lw	a5,16(a5)
  features &= VIRTIO_NET_F_MAC;
    8000715e:	0207f793          	andi	a5,a5,32
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80007162:	10002737          	lui	a4,0x10002
    80007166:	d31c                	sw	a5,32(a4)

  // Tell device that feature negotiation is complete
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007168:	47ad                	li	a5,11
    8000716a:	c09c                	sw	a5,0(s1)

  // Make sure that FEATURES_OK is set
  status = *R(VIRTIO_MMIO_STATUS);
    8000716c:	409c                	lw	a5,0(s1)
    8000716e:	00078d1b          	sext.w	s10,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80007172:	8ba1                	andi	a5,a5,8
    80007174:	2c078363          	beqz	a5,8000743a <virtio_net_init+0x38a>
    panic("virtio net FEATURES_OK unset");

  // Check max queue size
  uint32 max_queue_size = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80007178:	100027b7          	lui	a5,0x10002
    8000717c:	5bdc                	lw	a5,52(a5)
    8000717e:	2781                	sext.w	a5,a5
  if (max_queue_size == 0)
    80007180:	2c078563          	beqz	a5,8000744a <virtio_net_init+0x39a>
    panic("virtio net has no queue 1 (QUEUE_TX)");
  if (max_queue_size < NUM)
    80007184:	471d                	li	a4,7
    80007186:	2cf77a63          	bgeu	a4,a5,8000745a <virtio_net_init+0x3aa>
    panic("virtio net max queue too short");

  /* Initialize QUEUE_TX */
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    8000718a:	10002737          	lui	a4,0x10002
    8000718e:	4785                	li	a5,1
    80007190:	db1c                	sw	a5,48(a4)
  net.txq.num = QUEUE_TX;
    80007192:	00067717          	auipc	a4,0x67
    80007196:	0cf72723          	sw	a5,206(a4) # 8006e260 <net+0x40>

  // ensure QUEUE_TX is not in use.
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000719a:	100027b7          	lui	a5,0x10002
    8000719e:	43fc                	lw	a5,68(a5)
    800071a0:	2781                	sext.w	a5,a5
    800071a2:	2c079463          	bnez	a5,8000746a <virtio_net_init+0x3ba>
    panic("QUEUE_TX should not be ready\n");

  net.txq.desc = kalloc();
    800071a6:	ffffa097          	auipc	ra,0xffffa
    800071aa:	a5e080e7          	jalr	-1442(ra) # 80000c04 <kalloc>
    800071ae:	00067497          	auipc	s1,0x67
    800071b2:	07248493          	addi	s1,s1,114 # 8006e220 <net>
    800071b6:	f488                	sd	a0,40(s1)
  net.txq.driver_area = kalloc();
    800071b8:	ffffa097          	auipc	ra,0xffffa
    800071bc:	a4c080e7          	jalr	-1460(ra) # 80000c04 <kalloc>
    800071c0:	f888                	sd	a0,48(s1)
  net.txq.device_area = kalloc();
    800071c2:	ffffa097          	auipc	ra,0xffffa
    800071c6:	a42080e7          	jalr	-1470(ra) # 80000c04 <kalloc>
    800071ca:	87aa                	mv	a5,a0
    800071cc:	fc88                	sd	a0,56(s1)
  if (!net.txq.desc || !net.txq.driver_area || !net.txq.device_area)
    800071ce:	7488                	ld	a0,40(s1)
    800071d0:	2a050563          	beqz	a0,8000747a <virtio_net_init+0x3ca>
    800071d4:	00067717          	auipc	a4,0x67
    800071d8:	07c73703          	ld	a4,124(a4) # 8006e250 <net+0x30>
    800071dc:	28070f63          	beqz	a4,8000747a <virtio_net_init+0x3ca>
    800071e0:	28078d63          	beqz	a5,8000747a <virtio_net_init+0x3ca>
    panic("virtio net alloc\n");
  memset(net.txq.desc, 0, PGSIZE);
    800071e4:	6605                	lui	a2,0x1
    800071e6:	4581                	li	a1,0
    800071e8:	ffffa097          	auipc	ra,0xffffa
    800071ec:	c26080e7          	jalr	-986(ra) # 80000e0e <memset>
  memset(net.txq.free, 1, NUM);
    800071f0:	00067497          	auipc	s1,0x67
    800071f4:	03048493          	addi	s1,s1,48 # 8006e220 <net>
    800071f8:	4621                	li	a2,8
    800071fa:	4585                	li	a1,1
    800071fc:	00067517          	auipc	a0,0x67
    80007200:	06850513          	addi	a0,a0,104 # 8006e264 <net+0x44>
    80007204:	ffffa097          	auipc	ra,0xffffa
    80007208:	c0a080e7          	jalr	-1014(ra) # 80000e0e <memset>
  memset(net.txq.driver_area, 0, PGSIZE);
    8000720c:	6605                	lui	a2,0x1
    8000720e:	4581                	li	a1,0
    80007210:	7888                	ld	a0,48(s1)
    80007212:	ffffa097          	auipc	ra,0xffffa
    80007216:	bfc080e7          	jalr	-1028(ra) # 80000e0e <memset>
  memset(net.txq.device_area, 0, PGSIZE);
    8000721a:	6605                	lui	a2,0x1
    8000721c:	4581                	li	a1,0
    8000721e:	7c88                	ld	a0,56(s1)
    80007220:	ffffa097          	auipc	ra,0xffffa
    80007224:	bee080e7          	jalr	-1042(ra) # 80000e0e <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80007228:	100027b7          	lui	a5,0x10002
    8000722c:	4721                	li	a4,8
    8000722e:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.txq.desc;
    80007230:	749c                	ld	a5,40(s1)
    80007232:	0007869b          	sext.w	a3,a5
    80007236:	10002737          	lui	a4,0x10002
    8000723a:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.txq.desc) >> 32;
    8000723e:	9781                	srai	a5,a5,0x20
    80007240:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.txq.driver_area;
    80007244:	789c                	ld	a5,48(s1)
    80007246:	0007869b          	sext.w	a3,a5
    8000724a:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.txq.driver_area) >> 32;
    8000724e:	9781                	srai	a5,a5,0x20
    80007250:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.txq.device_area;
    80007254:	7c9c                	ld	a5,56(s1)
    80007256:	0007869b          	sext.w	a3,a5
    8000725a:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.txq.device_area) >> 32;
    8000725e:	9781                	srai	a5,a5,0x20
    80007260:	0af72223          	sw	a5,164(a4)

  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80007264:	87ba                	mv	a5,a4
    80007266:	4705                	li	a4,1
    80007268:	c3f8                	sw	a4,68(a5)
    8000726a:	04478793          	addi	a5,a5,68 # 10002044 <_entry-0x6fffdfbc>

  /* Initialize QUEUE_RX */

  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_RX;
    8000726e:	10002737          	lui	a4,0x10002
    80007272:	02072823          	sw	zero,48(a4) # 10002030 <_entry-0x6fffdfd0>
  net.rxq.num = QUEUE_RX;
    80007276:	0604a423          	sw	zero,104(s1)
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000727a:	439c                	lw	a5,0(a5)
    8000727c:	2781                	sext.w	a5,a5
    8000727e:	20079663          	bnez	a5,8000748a <virtio_net_init+0x3da>
    panic("QUEUE_RX should not be ready\n");

  net.rxq.desc = kalloc();
    80007282:	ffffa097          	auipc	ra,0xffffa
    80007286:	982080e7          	jalr	-1662(ra) # 80000c04 <kalloc>
    8000728a:	00067497          	auipc	s1,0x67
    8000728e:	f9648493          	addi	s1,s1,-106 # 8006e220 <net>
    80007292:	e8a8                	sd	a0,80(s1)
  net.rxq.driver_area = kalloc();
    80007294:	ffffa097          	auipc	ra,0xffffa
    80007298:	970080e7          	jalr	-1680(ra) # 80000c04 <kalloc>
    8000729c:	eca8                	sd	a0,88(s1)
  net.rxq.device_area = kalloc();
    8000729e:	ffffa097          	auipc	ra,0xffffa
    800072a2:	966080e7          	jalr	-1690(ra) # 80000c04 <kalloc>
    800072a6:	87aa                	mv	a5,a0
    800072a8:	f0a8                	sd	a0,96(s1)
  if (!net.rxq.desc || !net.rxq.driver_area || !net.rxq.device_area)
    800072aa:	68a8                	ld	a0,80(s1)
    800072ac:	1e050763          	beqz	a0,8000749a <virtio_net_init+0x3ea>
    800072b0:	00067717          	auipc	a4,0x67
    800072b4:	fc873703          	ld	a4,-56(a4) # 8006e278 <net+0x58>
    800072b8:	1e070163          	beqz	a4,8000749a <virtio_net_init+0x3ea>
    800072bc:	1c078f63          	beqz	a5,8000749a <virtio_net_init+0x3ea>
    panic("virtio net alloc");
  memset(net.rxq.desc, 0, PGSIZE);
    800072c0:	6605                	lui	a2,0x1
    800072c2:	4581                	li	a1,0
    800072c4:	ffffa097          	auipc	ra,0xffffa
    800072c8:	b4a080e7          	jalr	-1206(ra) # 80000e0e <memset>
  memset(net.rxq.free, 1, NUM);
    800072cc:	00067497          	auipc	s1,0x67
    800072d0:	f5448493          	addi	s1,s1,-172 # 8006e220 <net>
    800072d4:	4621                	li	a2,8
    800072d6:	4585                	li	a1,1
    800072d8:	00067517          	auipc	a0,0x67
    800072dc:	fb450513          	addi	a0,a0,-76 # 8006e28c <net+0x6c>
    800072e0:	ffffa097          	auipc	ra,0xffffa
    800072e4:	b2e080e7          	jalr	-1234(ra) # 80000e0e <memset>
  memset(net.rxq.driver_area, 0, PGSIZE);
    800072e8:	6605                	lui	a2,0x1
    800072ea:	4581                	li	a1,0
    800072ec:	6ca8                	ld	a0,88(s1)
    800072ee:	ffffa097          	auipc	ra,0xffffa
    800072f2:	b20080e7          	jalr	-1248(ra) # 80000e0e <memset>
  memset(net.rxq.device_area, 0, PGSIZE);
    800072f6:	6605                	lui	a2,0x1
    800072f8:	4581                	li	a1,0
    800072fa:	70a8                	ld	a0,96(s1)
    800072fc:	ffffa097          	auipc	ra,0xffffa
    80007300:	b12080e7          	jalr	-1262(ra) # 80000e0e <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80007304:	100027b7          	lui	a5,0x10002
    80007308:	4721                	li	a4,8
    8000730a:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.rxq.desc;
    8000730c:	68bc                	ld	a5,80(s1)
    8000730e:	0007869b          	sext.w	a3,a5
    80007312:	10002737          	lui	a4,0x10002
    80007316:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.rxq.desc) >> 32;
    8000731a:	9781                	srai	a5,a5,0x20
    8000731c:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.rxq.driver_area;
    80007320:	6cbc                	ld	a5,88(s1)
    80007322:	0007869b          	sext.w	a3,a5
    80007326:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.rxq.driver_area) >> 32;
    8000732a:	9781                	srai	a5,a5,0x20
    8000732c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.rxq.device_area;
    80007330:	70bc                	ld	a5,96(s1)
    80007332:	0007869b          	sext.w	a3,a5
    80007336:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.rxq.device_area) >> 32;
    8000733a:	9781                	srai	a5,a5,0x20
    8000733c:	0af72223          	sw	a5,164(a4)
    80007340:	4a11                	li	s4,4

  for (int i = 0; i < NUM / 2; i++) {
    int rx_hdr_desc = alloc_desc(&net.rxq);
    80007342:	00067a97          	auipc	s5,0x67
    80007346:	f2ea8a93          	addi	s5,s5,-210 # 8006e270 <net+0x50>
    struct virtio_net_hdr *hdr = kalloc();
    if (!rxbuf)
      panic("rxbuf alloc failed");

    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    8000734a:	4ca9                	li	s9,10
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    8000734c:	4c05                	li	s8,1
    net.rxq.desc[rx_hdr_desc].next = rx_desc;

    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    net.rxq.desc[rx_desc].len = PGSIZE;
    8000734e:	6b85                	lui	s7,0x1
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    80007350:	4b09                	li	s6,2
    int rx_hdr_desc = alloc_desc(&net.rxq);
    80007352:	8556                	mv	a0,s5
    80007354:	00000097          	auipc	ra,0x0
    80007358:	cc6080e7          	jalr	-826(ra) # 8000701a <alloc_desc>
    8000735c:	89aa                	mv	s3,a0
    int rx_desc = alloc_desc(&net.rxq);
    8000735e:	8556                	mv	a0,s5
    80007360:	00000097          	auipc	ra,0x0
    80007364:	cba080e7          	jalr	-838(ra) # 8000701a <alloc_desc>
    80007368:	8daa                	mv	s11,a0
    void *rxbuf = kalloc();
    8000736a:	ffffa097          	auipc	ra,0xffffa
    8000736e:	89a080e7          	jalr	-1894(ra) # 80000c04 <kalloc>
    80007372:	892a                	mv	s2,a0
    struct virtio_net_hdr *hdr = kalloc();
    80007374:	ffffa097          	auipc	ra,0xffffa
    80007378:	890080e7          	jalr	-1904(ra) # 80000c04 <kalloc>
    if (!rxbuf)
    8000737c:	12090763          	beqz	s2,800074aa <virtio_net_init+0x3fa>
    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    80007380:	00499793          	slli	a5,s3,0x4
    80007384:	68b8                	ld	a4,80(s1)
    80007386:	973e                	add	a4,a4,a5
    80007388:	e308                	sd	a0,0(a4)
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    8000738a:	68b8                	ld	a4,80(s1)
    8000738c:	973e                	add	a4,a4,a5
    8000738e:	01972423          	sw	s9,8(a4)
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    80007392:	68b8                	ld	a4,80(s1)
    80007394:	973e                	add	a4,a4,a5
    80007396:	01871623          	sh	s8,12(a4)
    net.rxq.desc[rx_hdr_desc].next = rx_desc;
    8000739a:	68b8                	ld	a4,80(s1)
    8000739c:	97ba                	add	a5,a5,a4
    8000739e:	01b79723          	sh	s11,14(a5) # 1000200e <_entry-0x6fffdff2>
    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    800073a2:	004d9793          	slli	a5,s11,0x4
    800073a6:	68b8                	ld	a4,80(s1)
    800073a8:	973e                	add	a4,a4,a5
    800073aa:	01273023          	sd	s2,0(a4)
    net.rxq.desc[rx_desc].len = PGSIZE;
    800073ae:	68b8                	ld	a4,80(s1)
    800073b0:	973e                	add	a4,a4,a5
    800073b2:	01772423          	sw	s7,8(a4)
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    800073b6:	68b8                	ld	a4,80(s1)
    800073b8:	97ba                	add	a5,a5,a4
    800073ba:	01679623          	sh	s6,12(a5)

    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = rx_hdr_desc;
    800073be:	6cb8                	ld	a4,88(s1)
    800073c0:	00275783          	lhu	a5,2(a4)
    800073c4:	8b9d                	andi	a5,a5,7
    800073c6:	0786                	slli	a5,a5,0x1
    800073c8:	973e                	add	a4,a4,a5
    800073ca:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    800073ce:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    800073d2:	6cb8                	ld	a4,88(s1)
    800073d4:	00275783          	lhu	a5,2(a4)
    800073d8:	2785                	addiw	a5,a5,1
    800073da:	00f71123          	sh	a5,2(a4)
    __sync_synchronize();
    800073de:	0330000f          	fence	rw,rw
  for (int i = 0; i < NUM / 2; i++) {
    800073e2:	3a7d                	addiw	s4,s4,-1
    800073e4:	f60a17e3          	bnez	s4,80007352 <virtio_net_init+0x2a2>
  }

  // queue is ready
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800073e8:	100027b7          	lui	a5,0x10002
    800073ec:	4705                	li	a4,1
    800073ee:	c3f8                	sw	a4,68(a5)

  // Notify device
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_RX;
    800073f0:	0407a823          	sw	zero,80(a5) # 10002050 <_entry-0x6fffdfb0>

  // Done initializing
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800073f4:	004d6d13          	ori	s10,s10,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800073f8:	07a7a823          	sw	s10,112(a5)

  // initialize packet buffer
  packet_buf = kalloc();
    800073fc:	ffffa097          	auipc	ra,0xffffa
    80007400:	808080e7          	jalr	-2040(ra) # 80000c04 <kalloc>
    80007404:	00005797          	auipc	a5,0x5
    80007408:	7aa7b223          	sd	a0,1956(a5) # 8000cba8 <packet_buf>
}
    8000740c:	70a6                	ld	ra,104(sp)
    8000740e:	7406                	ld	s0,96(sp)
    80007410:	64e6                	ld	s1,88(sp)
    80007412:	6946                	ld	s2,80(sp)
    80007414:	69a6                	ld	s3,72(sp)
    80007416:	6a06                	ld	s4,64(sp)
    80007418:	7ae2                	ld	s5,56(sp)
    8000741a:	7b42                	ld	s6,48(sp)
    8000741c:	7ba2                	ld	s7,40(sp)
    8000741e:	7c02                	ld	s8,32(sp)
    80007420:	6ce2                	ld	s9,24(sp)
    80007422:	6d42                	ld	s10,16(sp)
    80007424:	6da2                	ld	s11,8(sp)
    80007426:	6165                	addi	sp,sp,112
    80007428:	8082                	ret
    panic("could not find virtio net");
    8000742a:	00002517          	auipc	a0,0x2
    8000742e:	3fe50513          	addi	a0,a0,1022 # 80009828 <etext+0x828>
    80007432:	ffff9097          	auipc	ra,0xffff9
    80007436:	12e080e7          	jalr	302(ra) # 80000560 <panic>
    panic("virtio net FEATURES_OK unset");
    8000743a:	00002517          	auipc	a0,0x2
    8000743e:	40e50513          	addi	a0,a0,1038 # 80009848 <etext+0x848>
    80007442:	ffff9097          	auipc	ra,0xffff9
    80007446:	11e080e7          	jalr	286(ra) # 80000560 <panic>
    panic("virtio net has no queue 1 (QUEUE_TX)");
    8000744a:	00002517          	auipc	a0,0x2
    8000744e:	41e50513          	addi	a0,a0,1054 # 80009868 <etext+0x868>
    80007452:	ffff9097          	auipc	ra,0xffff9
    80007456:	10e080e7          	jalr	270(ra) # 80000560 <panic>
    panic("virtio net max queue too short");
    8000745a:	00002517          	auipc	a0,0x2
    8000745e:	43650513          	addi	a0,a0,1078 # 80009890 <etext+0x890>
    80007462:	ffff9097          	auipc	ra,0xffff9
    80007466:	0fe080e7          	jalr	254(ra) # 80000560 <panic>
    panic("QUEUE_TX should not be ready\n");
    8000746a:	00002517          	auipc	a0,0x2
    8000746e:	44650513          	addi	a0,a0,1094 # 800098b0 <etext+0x8b0>
    80007472:	ffff9097          	auipc	ra,0xffff9
    80007476:	0ee080e7          	jalr	238(ra) # 80000560 <panic>
    panic("virtio net alloc\n");
    8000747a:	00002517          	auipc	a0,0x2
    8000747e:	45650513          	addi	a0,a0,1110 # 800098d0 <etext+0x8d0>
    80007482:	ffff9097          	auipc	ra,0xffff9
    80007486:	0de080e7          	jalr	222(ra) # 80000560 <panic>
    panic("QUEUE_RX should not be ready\n");
    8000748a:	00002517          	auipc	a0,0x2
    8000748e:	45e50513          	addi	a0,a0,1118 # 800098e8 <etext+0x8e8>
    80007492:	ffff9097          	auipc	ra,0xffff9
    80007496:	0ce080e7          	jalr	206(ra) # 80000560 <panic>
    panic("virtio net alloc");
    8000749a:	00002517          	auipc	a0,0x2
    8000749e:	46e50513          	addi	a0,a0,1134 # 80009908 <etext+0x908>
    800074a2:	ffff9097          	auipc	ra,0xffff9
    800074a6:	0be080e7          	jalr	190(ra) # 80000560 <panic>
      panic("rxbuf alloc failed");
    800074aa:	00002517          	auipc	a0,0x2
    800074ae:	47650513          	addi	a0,a0,1142 # 80009920 <etext+0x920>
    800074b2:	ffff9097          	auipc	ra,0xffff9
    800074b6:	0ae080e7          	jalr	174(ra) # 80000560 <panic>

00000000800074ba <apply_padding>:
 *      return 0 on success
 *      return 1 when the number of bytes calculated does not make sense
 */
int apply_padding(uint8 num_bytes) {
  uint8 *pkt_ptr =
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    800074ba:	04a00693          	li	a3,74
    800074be:	9e89                	subw	a3,a3,a0
  if (num_bytes > 64 - sizeof(struct virtio_net_hdr) || num_bytes < 1) {
    800074c0:	fff5079b          	addiw	a5,a0,-1
    800074c4:	0ff7f793          	zext.b	a5,a5
    800074c8:	03500713          	li	a4,53
    800074cc:	02f76563          	bltu	a4,a5,800074f6 <apply_padding+0x3c>
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    800074d0:	00005717          	auipc	a4,0x5
    800074d4:	6d873703          	ld	a4,1752(a4) # 8000cba8 <packet_buf>
    800074d8:	00d707b3          	add	a5,a4,a3
    800074dc:	0705                	addi	a4,a4,1
    800074de:	9736                	add	a4,a4,a3
    800074e0:	357d                	addiw	a0,a0,-1
    800074e2:	1502                	slli	a0,a0,0x20
    800074e4:	9101                	srli	a0,a0,0x20
    800074e6:	972a                	add	a4,a4,a0
    printf("malformed packet data");
    return 1;
  }
  for (int i = 0; i < num_bytes; i++) {
    pkt_ptr[i] = 0;
    800074e8:	00078023          	sb	zero,0(a5)
  for (int i = 0; i < num_bytes; i++) {
    800074ec:	0785                	addi	a5,a5,1
    800074ee:	fee79de3          	bne	a5,a4,800074e8 <apply_padding+0x2e>
  }
  return 0;
    800074f2:	4501                	li	a0,0
}
    800074f4:	8082                	ret
int apply_padding(uint8 num_bytes) {
    800074f6:	1141                	addi	sp,sp,-16
    800074f8:	e406                	sd	ra,8(sp)
    800074fa:	e022                	sd	s0,0(sp)
    800074fc:	0800                	addi	s0,sp,16
    printf("malformed packet data");
    800074fe:	00002517          	auipc	a0,0x2
    80007502:	43a50513          	addi	a0,a0,1082 # 80009938 <etext+0x938>
    80007506:	ffff9097          	auipc	ra,0xffff9
    8000750a:	0a4080e7          	jalr	164(ra) # 800005aa <printf>
    return 1;
    8000750e:	4505                	li	a0,1
}
    80007510:	60a2                	ld	ra,8(sp)
    80007512:	6402                	ld	s0,0(sp)
    80007514:	0141                	addi	sp,sp,16
    80007516:	8082                	ret

0000000080007518 <transmit_packet>:
 *                     of the data is 1500 (defined by the ethernet protocol)
 *
 * Output: There is no return value from the function, but the packet frame
 *         is given to the NIC to be transmitted.
 */
void transmit_packet(void *pkt_data, uint16 pkt_len, uint16 protocol) {
    80007518:	711d                	addi	sp,sp,-96
    8000751a:	ec86                	sd	ra,88(sp)
    8000751c:	e8a2                	sd	s0,80(sp)
    8000751e:	e4a6                	sd	s1,72(sp)
    80007520:	e0ca                	sd	s2,64(sp)
    80007522:	fc4e                	sd	s3,56(sp)
    80007524:	f852                	sd	s4,48(sp)
    80007526:	f456                	sd	s5,40(sp)
    80007528:	f05a                	sd	s6,32(sp)
    8000752a:	ec5e                	sd	s7,24(sp)
    8000752c:	e862                	sd	s8,16(sp)
    8000752e:	e466                	sd	s9,8(sp)
    80007530:	1080                	addi	s0,sp,96
    80007532:	8caa                	mv	s9,a0
    80007534:	8aae                	mv	s5,a1
    80007536:	84b2                	mv	s1,a2
  /* Create the header for transmission */
  acquire(&net.vnet_lock);
    80007538:	00067517          	auipc	a0,0x67
    8000753c:	cf850513          	addi	a0,a0,-776 # 8006e230 <net+0x10>
    80007540:	ffff9097          	auipc	ra,0xffff9
    80007544:	7d6080e7          	jalr	2006(ra) # 80000d16 <acquire>
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    80007548:	100027b7          	lui	a5,0x10002
    8000754c:	4705                	li	a4,1
    8000754e:	db98                	sw	a4,48(a5)
  // allocate for packet header and packet_frame
  struct virtio_net_hdr *hdr = kalloc();
    80007550:	ffff9097          	auipc	ra,0xffff9
    80007554:	6b4080e7          	jalr	1716(ra) # 80000c04 <kalloc>
  if (hdr == 0)
    80007558:	1c050d63          	beqz	a0,80007732 <transmit_packet+0x21a>
    8000755c:	8baa                	mv	s7,a0
    panic("failed to allocate header\n");
  // initialize the header and packet
  memset(hdr, 0, PGSIZE);
    8000755e:	6605                	lui	a2,0x1
    80007560:	4581                	li	a1,0
    80007562:	ffffa097          	auipc	ra,0xffffa
    80007566:	8ac080e7          	jalr	-1876(ra) # 80000e0e <memset>

  int hdr_desc = alloc_desc(&net.txq);
    8000756a:	00067a17          	auipc	s4,0x67
    8000756e:	cb6a0a13          	addi	s4,s4,-842 # 8006e220 <net>
    80007572:	00067997          	auipc	s3,0x67
    80007576:	cd698993          	addi	s3,s3,-810 # 8006e248 <net+0x28>
    8000757a:	854e                	mv	a0,s3
    8000757c:	00000097          	auipc	ra,0x0
    80007580:	a9e080e7          	jalr	-1378(ra) # 8000701a <alloc_desc>
    80007584:	892a                	mv	s2,a0
  int pkt_desc = alloc_desc(&net.txq);
    80007586:	854e                	mv	a0,s3
    80007588:	00000097          	auipc	ra,0x0
    8000758c:	a92080e7          	jalr	-1390(ra) # 8000701a <alloc_desc>
    80007590:	89aa                	mv	s3,a0

  hdr->flags = 0;
    80007592:	000b8023          	sb	zero,0(s7) # 1000 <_entry-0x7ffff000>
  hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
    80007596:	000b80a3          	sb	zero,1(s7)
  hdr->hdr_len = 0;
    8000759a:	000b9123          	sh	zero,2(s7)

  memmove(packet_buf, "\xe2\x71\xad\xf4\x7b\xff", 6);
    8000759e:	00005b17          	auipc	s6,0x5
    800075a2:	60ab0b13          	addi	s6,s6,1546 # 8000cba8 <packet_buf>
    800075a6:	4619                	li	a2,6
    800075a8:	00002597          	auipc	a1,0x2
    800075ac:	3c858593          	addi	a1,a1,968 # 80009970 <etext+0x970>
    800075b0:	000b3503          	ld	a0,0(s6)
    800075b4:	ffffa097          	auipc	ra,0xffffa
    800075b8:	8be080e7          	jalr	-1858(ra) # 80000e72 <memmove>
  memmove(packet_buf + 6, net.cfg.mac, 6);
    800075bc:	000b3503          	ld	a0,0(s6)
    800075c0:	4619                	li	a2,6
    800075c2:	85d2                	mv	a1,s4
    800075c4:	9532                	add	a0,a0,a2
    800075c6:	ffffa097          	auipc	ra,0xffffa
    800075ca:	8ac080e7          	jalr	-1876(ra) # 80000e72 <memmove>

  packet_buf[12] = (protocol >> 8);
    800075ce:	000b3503          	ld	a0,0(s6)
    800075d2:	0084d71b          	srliw	a4,s1,0x8
    800075d6:	00e50623          	sb	a4,12(a0)
  packet_buf[13] = (protocol & 0xF);
    800075da:	88bd                	andi	s1,s1,15
    800075dc:	009506a3          	sb	s1,13(a0)

  memmove(packet_buf + 14, pkt_data, pkt_len);
    800075e0:	000a8c1b          	sext.w	s8,s5
    800075e4:	8662                	mv	a2,s8
    800075e6:	85e6                	mv	a1,s9
    800075e8:	0539                	addi	a0,a0,14
    800075ea:	ffffa097          	auipc	ra,0xffffa
    800075ee:	888080e7          	jalr	-1912(ra) # 80000e72 <memmove>

  net.txq.desc[hdr_desc].flags |=
    800075f2:	00491793          	slli	a5,s2,0x4
    800075f6:	028a3703          	ld	a4,40(s4)
    800075fa:	973e                	add	a4,a4,a5
    800075fc:	00c75683          	lhu	a3,12(a4)
    80007600:	0016e693          	ori	a3,a3,1
    80007604:	00d71623          	sh	a3,12(a4)
      VRING_DESC_F_NEXT; // This tells the device it's a chain
  net.txq.desc[hdr_desc].len = HDR_SIZE;
    80007608:	028a3703          	ld	a4,40(s4)
    8000760c:	973e                	add	a4,a4,a5
    8000760e:	46a9                	li	a3,10
    80007610:	c714                	sw	a3,8(a4)
  net.txq.desc[hdr_desc].addr = (uint64)hdr;
    80007612:	028a3703          	ld	a4,40(s4)
    80007616:	973e                	add	a4,a4,a5
    80007618:	01773023          	sd	s7,0(a4)
  net.txq.desc[hdr_desc].next = pkt_desc;
    8000761c:	028a3703          	ld	a4,40(s4)
    80007620:	97ba                	add	a5,a5,a4
    80007622:	01379723          	sh	s3,14(a5) # 1000200e <_entry-0x6fffdff2>

  net.txq.desc[pkt_desc].len = 14 + pkt_len;
    80007626:	0992                	slli	s3,s3,0x4
    80007628:	028a3783          	ld	a5,40(s4)
    8000762c:	97ce                	add	a5,a5,s3
    8000762e:	00ea871b          	addiw	a4,s5,14
    80007632:	c798                	sw	a4,8(a5)
  net.txq.desc[pkt_desc].addr = (uint64)packet_buf;
    80007634:	028a3783          	ld	a5,40(s4)
    80007638:	97ce                	add	a5,a5,s3
    8000763a:	000b3703          	ld	a4,0(s6)
    8000763e:	e398                	sd	a4,0(a5)
  net.txq.desc[pkt_desc].flags = 0;
    80007640:	028a3783          	ld	a5,40(s4)
    80007644:	97ce                	add	a5,a5,s3
    80007646:	00079623          	sh	zero,12(a5)

  if (pkt_len < 64) {
    8000764a:	03f00793          	li	a5,63
    8000764e:	0387e563          	bltu	a5,s8,80007678 <transmit_packet+0x160>
    int res = apply_padding(64 - pkt_len);
    80007652:	04000513          	li	a0,64
    80007656:	4155053b          	subw	a0,a0,s5
    8000765a:	0ff57513          	zext.b	a0,a0
    8000765e:	00000097          	auipc	ra,0x0
    80007662:	e5c080e7          	jalr	-420(ra) # 800074ba <apply_padding>
    net.txq.desc[pkt_desc].len = 64;
    80007666:	00067797          	auipc	a5,0x67
    8000766a:	be27b783          	ld	a5,-1054(a5) # 8006e248 <net+0x28>
    8000766e:	97ce                	add	a5,a5,s3
    80007670:	04000713          	li	a4,64
    80007674:	c798                	sw	a4,8(a5)
    if (res != 0)
    80007676:	e571                	bnez	a0,80007742 <transmit_packet+0x22a>
      panic("failed to apply padding");
  }

  // Tell the device first index in chain of descriptors
  net.txq.driver_area->ring[net.txq.driver_area->idx % NUM] = hdr_desc;
    80007678:	00067997          	auipc	s3,0x67
    8000767c:	ba898993          	addi	s3,s3,-1112 # 8006e220 <net>
    80007680:	0309b703          	ld	a4,48(s3)
    80007684:	00275783          	lhu	a5,2(a4)
    80007688:	8b9d                	andi	a5,a5,7
    8000768a:	0786                	slli	a5,a5,0x1
    8000768c:	973e                	add	a4,a4,a5
    8000768e:	01271223          	sh	s2,4(a4)
  __sync_synchronize();
    80007692:	0330000f          	fence	rw,rw
  // Tell the device another avail ring entry is available
  net.txq.driver_area->idx++;
    80007696:	0309b703          	ld	a4,48(s3)
    8000769a:	00275783          	lhu	a5,2(a4)
    8000769e:	2785                	addiw	a5,a5,1
    800076a0:	00f71123          	sh	a5,2(a4)
  __sync_synchronize();
    800076a4:	0330000f          	fence	rw,rw

  uint16 prev_used_idx = net.txq.device_area->idx;
    800076a8:	0389b783          	ld	a5,56(s3)
    800076ac:	0027d483          	lhu	s1,2(a5)
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_TX;
    800076b0:	100027b7          	lui	a5,0x10002
    800076b4:	4705                	li	a4,1
    800076b6:	cbb8                	sw	a4,80(a5)
  release(&net.vnet_lock);
    800076b8:	00067517          	auipc	a0,0x67
    800076bc:	b7850513          	addi	a0,a0,-1160 # 8006e230 <net+0x10>
    800076c0:	ffff9097          	auipc	ra,0xffff9
    800076c4:	706080e7          	jalr	1798(ra) # 80000dc6 <release>

  // Wait for the device to use the descriptor. It indicates this by
  // decrementing the index. Polling helps to avoid race conditions
  while (net.txq.device_area->idx == prev_used_idx) {
    800076c8:	0389b783          	ld	a5,56(s3)
    800076cc:	0027d783          	lhu	a5,2(a5) # 10002002 <_entry-0x6fffdffe>
    800076d0:	00979c63          	bne	a5,s1,800076e8 <transmit_packet+0x1d0>
    800076d4:	86ce                	mv	a3,s3
    800076d6:	0004871b          	sext.w	a4,s1
    __sync_synchronize();
    800076da:	0330000f          	fence	rw,rw
  while (net.txq.device_area->idx == prev_used_idx) {
    800076de:	7e9c                	ld	a5,56(a3)
    800076e0:	0027d783          	lhu	a5,2(a5)
    800076e4:	fee78be3          	beq	a5,a4,800076da <transmit_packet+0x1c2>
  }
  printf("mac: %x:%x:%x:%x:%x:%x\n", net.cfg.mac[0], net.cfg.mac[1],
         net.cfg.mac[2], net.cfg.mac[3], net.cfg.mac[4], net.cfg.mac[5]);
    800076e8:	00067597          	auipc	a1,0x67
    800076ec:	b3858593          	addi	a1,a1,-1224 # 8006e220 <net>
  printf("mac: %x:%x:%x:%x:%x:%x\n", net.cfg.mac[0], net.cfg.mac[1],
    800076f0:	0055c803          	lbu	a6,5(a1)
    800076f4:	0045c783          	lbu	a5,4(a1)
    800076f8:	0035c703          	lbu	a4,3(a1)
    800076fc:	0025c683          	lbu	a3,2(a1)
    80007700:	0015c603          	lbu	a2,1(a1)
    80007704:	0005c583          	lbu	a1,0(a1)
    80007708:	00002517          	auipc	a0,0x2
    8000770c:	28850513          	addi	a0,a0,648 # 80009990 <etext+0x990>
    80007710:	ffff9097          	auipc	ra,0xffff9
    80007714:	e9a080e7          	jalr	-358(ra) # 800005aa <printf>
}
    80007718:	60e6                	ld	ra,88(sp)
    8000771a:	6446                	ld	s0,80(sp)
    8000771c:	64a6                	ld	s1,72(sp)
    8000771e:	6906                	ld	s2,64(sp)
    80007720:	79e2                	ld	s3,56(sp)
    80007722:	7a42                	ld	s4,48(sp)
    80007724:	7aa2                	ld	s5,40(sp)
    80007726:	7b02                	ld	s6,32(sp)
    80007728:	6be2                	ld	s7,24(sp)
    8000772a:	6c42                	ld	s8,16(sp)
    8000772c:	6ca2                	ld	s9,8(sp)
    8000772e:	6125                	addi	sp,sp,96
    80007730:	8082                	ret
    panic("failed to allocate header\n");
    80007732:	00002517          	auipc	a0,0x2
    80007736:	21e50513          	addi	a0,a0,542 # 80009950 <etext+0x950>
    8000773a:	ffff9097          	auipc	ra,0xffff9
    8000773e:	e26080e7          	jalr	-474(ra) # 80000560 <panic>
      panic("failed to apply padding");
    80007742:	00002517          	auipc	a0,0x2
    80007746:	23650513          	addi	a0,a0,566 # 80009978 <etext+0x978>
    8000774a:	ffff9097          	auipc	ra,0xffff9
    8000774e:	e16080e7          	jalr	-490(ra) # 80000560 <panic>

0000000080007752 <receive_packet>:

uint16 receive_packet(void *pkt_buf, uint16 num_bytes) {
    80007752:	1101                	addi	sp,sp,-32
    80007754:	ec06                	sd	ra,24(sp)
    80007756:	e822                	sd	s0,16(sp)
    80007758:	e426                	sd	s1,8(sp)
    8000775a:	1000                	addi	s0,sp,32
  acquire(&net.vnet_lock);
    8000775c:	00067497          	auipc	s1,0x67
    80007760:	ac448493          	addi	s1,s1,-1340 # 8006e220 <net>
    80007764:	00067517          	auipc	a0,0x67
    80007768:	acc50513          	addi	a0,a0,-1332 # 8006e230 <net+0x10>
    8000776c:	ffff9097          	auipc	ra,0xffff9
    80007770:	5aa080e7          	jalr	1450(ra) # 80000d16 <acquire>
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    80007774:	58fc                	lw	a5,116(s1)
    80007776:	70b4                	ld	a3,96(s1)
    80007778:	0026d703          	lhu	a4,2(a3)
    8000777c:	04f70663          	beq	a4,a5,800077c8 <receive_packet+0x76>
    // for (int i = 0; i < len; i++) {
    //   printf("%x", packet[i]);
    // }

    // Requeue the buffer
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    80007780:	8626                	mv	a2,s1
    80007782:	6e2c                	ld	a1,88(a2)
    80007784:	0025d703          	lhu	a4,2(a1)
    80007788:	8b1d                	andi	a4,a4,7
    8000778a:	0706                	slli	a4,a4,0x1
    8000778c:	95ba                	add	a1,a1,a4
    int id = net.rxq.device_area->ring[net.rxq.used_idx % NUM].id;
    8000778e:	41f7d71b          	sraiw	a4,a5,0x1f
    80007792:	01d7571b          	srliw	a4,a4,0x1d
    80007796:	9fb9                	addw	a5,a5,a4
    80007798:	8b9d                	andi	a5,a5,7
    8000779a:	9f99                	subw	a5,a5,a4
    8000779c:	078e                	slli	a5,a5,0x3
    8000779e:	96be                	add	a3,a3,a5
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    800077a0:	42dc                	lw	a5,4(a3)
    800077a2:	00f59223          	sh	a5,4(a1)
    __sync_synchronize();
    800077a6:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    800077aa:	6e38                	ld	a4,88(a2)
    800077ac:	00275783          	lhu	a5,2(a4)
    800077b0:	2785                	addiw	a5,a5,1
    800077b2:	00f71123          	sh	a5,2(a4)
    net.rxq.used_idx++;
    800077b6:	5a78                	lw	a4,116(a2)
    800077b8:	2705                	addiw	a4,a4,1
    800077ba:	87ba                	mv	a5,a4
    800077bc:	da78                	sw	a4,116(a2)
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    800077be:	7234                	ld	a3,96(a2)
    800077c0:	0026d703          	lhu	a4,2(a3)
    800077c4:	faf71fe3          	bne	a4,a5,80007782 <receive_packet+0x30>
  }
  release(&net.vnet_lock);
    800077c8:	00067517          	auipc	a0,0x67
    800077cc:	a6850513          	addi	a0,a0,-1432 # 8006e230 <net+0x10>
    800077d0:	ffff9097          	auipc	ra,0xffff9
    800077d4:	5f6080e7          	jalr	1526(ra) # 80000dc6 <release>
  return 0;
}
    800077d8:	4501                	li	a0,0
    800077da:	60e2                	ld	ra,24(sp)
    800077dc:	6442                	ld	s0,16(sp)
    800077de:	64a2                	ld	s1,8(sp)
    800077e0:	6105                	addi	sp,sp,32
    800077e2:	8082                	ret
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
