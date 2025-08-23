
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000e117          	auipc	sp,0xe
    80000004:	45010113          	addi	sp,sp,1104 # 8000e450 <stack0>
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
    80000054:	2c078793          	addi	a5,a5,704 # 8000e310 <timer_scratch>
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
    80000066:	86e78793          	addi	a5,a5,-1938 # 800068d0 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff8ddf3>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	f1a78793          	addi	a5,a5,-230 # 80000fc8 <main>
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
    80000138:	cec080e7          	jalr	-788(ra) # 80002e20 <either_copyin>
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
    8000019c:	00016517          	auipc	a0,0x16
    800001a0:	2b450513          	addi	a0,a0,692 # 80016450 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	b72080e7          	jalr	-1166(ra) # 80000d16 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001ac:	00016497          	auipc	s1,0x16
    800001b0:	2a448493          	addi	s1,s1,676 # 80016450 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b4:	00016917          	auipc	s2,0x16
    800001b8:	33490913          	addi	s2,s2,820 # 800164e8 <cons+0x98>
  while(n > 0){
    800001bc:	0d305563          	blez	s3,80000286 <consoleread+0x106>
    while(cons.r == cons.w){
    800001c0:	0984a783          	lw	a5,152(s1)
    800001c4:	09c4a703          	lw	a4,156(s1)
    800001c8:	0af71a63          	bne	a4,a5,8000027c <consoleread+0xfc>
      if(killed(myproc())){
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	c8e080e7          	jalr	-882(ra) # 80001e5a <myproc>
    800001d4:	00003097          	auipc	ra,0x3
    800001d8:	95a080e7          	jalr	-1702(ra) # 80002b2e <killed>
    800001dc:	e52d                	bnez	a0,80000246 <consoleread+0xc6>
      sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	526080e7          	jalr	1318(ra) # 80002708 <sleep>
    while(cons.r == cons.w){
    800001ea:	0984a783          	lw	a5,152(s1)
    800001ee:	09c4a703          	lw	a4,156(s1)
    800001f2:	fcf70de3          	beq	a4,a5,800001cc <consoleread+0x4c>
    800001f6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f8:	00016717          	auipc	a4,0x16
    800001fc:	25870713          	addi	a4,a4,600 # 80016450 <cons>
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
    8000022e:	ba0080e7          	jalr	-1120(ra) # 80002dca <either_copyout>
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
    80000246:	00016517          	auipc	a0,0x16
    8000024a:	20a50513          	addi	a0,a0,522 # 80016450 <cons>
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
    80000270:	00016717          	auipc	a4,0x16
    80000274:	26f72c23          	sw	a5,632(a4) # 800164e8 <cons+0x98>
    80000278:	6be2                	ld	s7,24(sp)
    8000027a:	a031                	j	80000286 <consoleread+0x106>
    8000027c:	ec5e                	sd	s7,24(sp)
    8000027e:	bfad                	j	800001f8 <consoleread+0x78>
    80000280:	6be2                	ld	s7,24(sp)
    80000282:	a011                	j	80000286 <consoleread+0x106>
    80000284:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000286:	00016517          	auipc	a0,0x16
    8000028a:	1ca50513          	addi	a0,a0,458 # 80016450 <cons>
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
    800002ee:	00016517          	auipc	a0,0x16
    800002f2:	16250513          	addi	a0,a0,354 # 80016450 <cons>
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
    80000318:	b62080e7          	jalr	-1182(ra) # 80002e76 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000031c:	00016517          	auipc	a0,0x16
    80000320:	13450513          	addi	a0,a0,308 # 80016450 <cons>
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
    8000033e:	00016717          	auipc	a4,0x16
    80000342:	11270713          	addi	a4,a4,274 # 80016450 <cons>
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
    80000368:	00016797          	auipc	a5,0x16
    8000036c:	0e878793          	addi	a5,a5,232 # 80016450 <cons>
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
    80000394:	00016797          	auipc	a5,0x16
    80000398:	1547a783          	lw	a5,340(a5) # 800164e8 <cons+0x98>
    8000039c:	9f1d                	subw	a4,a4,a5
    8000039e:	08000793          	li	a5,128
    800003a2:	f6f71de3          	bne	a4,a5,8000031c <consoleintr+0x3a>
    800003a6:	a0c9                	j	80000468 <consoleintr+0x186>
    800003a8:	e84a                	sd	s2,16(sp)
    800003aa:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    800003ac:	00016717          	auipc	a4,0x16
    800003b0:	0a470713          	addi	a4,a4,164 # 80016450 <cons>
    800003b4:	0a072783          	lw	a5,160(a4)
    800003b8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003bc:	00016497          	auipc	s1,0x16
    800003c0:	09448493          	addi	s1,s1,148 # 80016450 <cons>
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
    8000040a:	00016717          	auipc	a4,0x16
    8000040e:	04670713          	addi	a4,a4,70 # 80016450 <cons>
    80000412:	0a072783          	lw	a5,160(a4)
    80000416:	09c72703          	lw	a4,156(a4)
    8000041a:	f0f701e3          	beq	a4,a5,8000031c <consoleintr+0x3a>
      cons.e--;
    8000041e:	37fd                	addiw	a5,a5,-1
    80000420:	00016717          	auipc	a4,0x16
    80000424:	0cf72823          	sw	a5,208(a4) # 800164f0 <cons+0xa0>
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
    80000446:	00016797          	auipc	a5,0x16
    8000044a:	00a78793          	addi	a5,a5,10 # 80016450 <cons>
    8000044e:	0a07a703          	lw	a4,160(a5)
    80000452:	0017069b          	addiw	a3,a4,1
    80000456:	8636                	mv	a2,a3
    80000458:	0ad7a023          	sw	a3,160(a5)
    8000045c:	07f77713          	andi	a4,a4,127
    80000460:	97ba                	add	a5,a5,a4
    80000462:	4729                	li	a4,10
    80000464:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000468:	00016797          	auipc	a5,0x16
    8000046c:	08c7a223          	sw	a2,132(a5) # 800164ec <cons+0x9c>
        wakeup(&cons.r);
    80000470:	00016517          	auipc	a0,0x16
    80000474:	07850513          	addi	a0,a0,120 # 800164e8 <cons+0x98>
    80000478:	00002097          	auipc	ra,0x2
    8000047c:	2f4080e7          	jalr	756(ra) # 8000276c <wakeup>
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
    8000048a:	0000a597          	auipc	a1,0xa
    8000048e:	b8658593          	addi	a1,a1,-1146 # 8000a010 <etext+0x10>
    80000492:	00016517          	auipc	a0,0x16
    80000496:	fbe50513          	addi	a0,a0,-66 # 80016450 <cons>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	7e8080e7          	jalr	2024(ra) # 80000c82 <initlock>

  uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	344080e7          	jalr	836(ra) # 800007e6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800004aa:	0006e797          	auipc	a5,0x6e
    800004ae:	33e78793          	addi	a5,a5,830 # 8006e7e8 <devsw>
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
    800004ea:	0000b817          	auipc	a6,0xb
    800004ee:	84680813          	addi	a6,a6,-1978 # 8000ad30 <digits>
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
    8000056c:	00016797          	auipc	a5,0x16
    80000570:	fa07a223          	sw	zero,-92(a5) # 80016510 <pr+0x18>
  printf("panic: ");
    80000574:	0000a517          	auipc	a0,0xa
    80000578:	aa450513          	addi	a0,a0,-1372 # 8000a018 <etext+0x18>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	0000a517          	auipc	a0,0xa
    80000592:	a9250513          	addi	a0,a0,-1390 # 8000a020 <etext+0x20>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	0000e717          	auipc	a4,0xe
    800005a4:	d2f72023          	sw	a5,-736(a4) # 8000e2c0 <panicked>
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
    800005ca:	00016d97          	auipc	s11,0x16
    800005ce:	f46dad83          	lw	s11,-186(s11) # 80016510 <pr+0x18>
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
    8000060c:	0000aa97          	auipc	s5,0xa
    80000610:	724a8a93          	addi	s5,s5,1828 # 8000ad30 <digits>
    switch(c){
    80000614:	07300c13          	li	s8,115
    80000618:	a0b9                	j	80000666 <printf+0xbc>
    acquire(&pr.lock);
    8000061a:	00016517          	auipc	a0,0x16
    8000061e:	ede50513          	addi	a0,a0,-290 # 800164f8 <pr>
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
    8000063e:	0000a517          	auipc	a0,0xa
    80000642:	9f250513          	addi	a0,a0,-1550 # 8000a030 <etext+0x30>
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
    8000073c:	0000a497          	auipc	s1,0xa
    80000740:	8ec48493          	addi	s1,s1,-1812 # 8000a028 <etext+0x28>
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
    800007a2:	00016517          	auipc	a0,0x16
    800007a6:	d5650513          	addi	a0,a0,-682 # 800164f8 <pr>
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
    800007be:	00016497          	auipc	s1,0x16
    800007c2:	d3a48493          	addi	s1,s1,-710 # 800164f8 <pr>
    800007c6:	0000a597          	auipc	a1,0xa
    800007ca:	87a58593          	addi	a1,a1,-1926 # 8000a040 <etext+0x40>
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
    80000820:	0000a597          	auipc	a1,0xa
    80000824:	82858593          	addi	a1,a1,-2008 # 8000a048 <etext+0x48>
    80000828:	00016517          	auipc	a0,0x16
    8000082c:	cf050513          	addi	a0,a0,-784 # 80016518 <uart_tx_lock>
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
    80000854:	0000e797          	auipc	a5,0xe
    80000858:	a6c7a783          	lw	a5,-1428(a5) # 8000e2c0 <panicked>
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
    8000088e:	0000e797          	auipc	a5,0xe
    80000892:	a3a7b783          	ld	a5,-1478(a5) # 8000e2c8 <uart_tx_r>
    80000896:	0000e717          	auipc	a4,0xe
    8000089a:	a3a73703          	ld	a4,-1478(a4) # 8000e2d0 <uart_tx_w>
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
    800008bc:	00016a97          	auipc	s5,0x16
    800008c0:	c5ca8a93          	addi	s5,s5,-932 # 80016518 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000e497          	auipc	s1,0xe
    800008c8:	a0448493          	addi	s1,s1,-1532 # 8000e2c8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000e997          	auipc	s3,0xe
    800008d4:	a0098993          	addi	s3,s3,-1536 # 8000e2d0 <uart_tx_w>
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
    800008f6:	e7a080e7          	jalr	-390(ra) # 8000276c <wakeup>
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
    80000930:	00016517          	auipc	a0,0x16
    80000934:	be850513          	addi	a0,a0,-1048 # 80016518 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	3de080e7          	jalr	990(ra) # 80000d16 <acquire>
  if(panicked){
    80000940:	0000e797          	auipc	a5,0xe
    80000944:	9807a783          	lw	a5,-1664(a5) # 8000e2c0 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000e717          	auipc	a4,0xe
    8000094e:	98673703          	ld	a4,-1658(a4) # 8000e2d0 <uart_tx_w>
    80000952:	0000e797          	auipc	a5,0xe
    80000956:	9767b783          	ld	a5,-1674(a5) # 8000e2c8 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00016997          	auipc	s3,0x16
    80000962:	bba98993          	addi	s3,s3,-1094 # 80016518 <uart_tx_lock>
    80000966:	0000e497          	auipc	s1,0xe
    8000096a:	96248493          	addi	s1,s1,-1694 # 8000e2c8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000e917          	auipc	s2,0xe
    80000972:	96290913          	addi	s2,s2,-1694 # 8000e2d0 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	d8a080e7          	jalr	-630(ra) # 80002708 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00016497          	auipc	s1,0x16
    80000998:	b8448493          	addi	s1,s1,-1148 # 80016518 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000e797          	auipc	a5,0xe
    800009ac:	92e7b423          	sd	a4,-1752(a5) # 8000e2d0 <uart_tx_w>
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
    80000a1e:	00016497          	auipc	s1,0x16
    80000a22:	afa48493          	addi	s1,s1,-1286 # 80016518 <uart_tx_lock>
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
    80000a5a:	00016917          	auipc	s2,0x16
    80000a5e:	af690913          	addi	s2,s2,-1290 # 80016550 <kmem>
    80000a62:	854a                	mv	a0,s2
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	2b2080e7          	jalr	690(ra) # 80000d16 <acquire>
  uint page_num = PGROUNDDOWN((uint64)pointer_in_page)/PGSIZE;
    80000a6c:	80b1                	srli	s1,s1,0xc
  ref_counter[page_num]++;
    80000a6e:	02049793          	slli	a5,s1,0x20
    80000a72:	01d7d493          	srli	s1,a5,0x1d
    80000a76:	00016797          	auipc	a5,0x16
    80000a7a:	afa78793          	addi	a5,a5,-1286 # 80016570 <ref_counter>
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
    80000aae:	00070797          	auipc	a5,0x70
    80000ab2:	f5e78793          	addi	a5,a5,-162 # 80070a0c <end>
    80000ab6:	08f56963          	bltu	a0,a5,80000b48 <kfree+0xac>
    80000aba:	47c5                	li	a5,17
    80000abc:	07ee                	slli	a5,a5,0x1b
    80000abe:	08f57563          	bgeu	a0,a5,80000b48 <kfree+0xac>
    panic("kfree");

  acquire(&kmem.lock);
    80000ac2:	00016517          	auipc	a0,0x16
    80000ac6:	a8e50513          	addi	a0,a0,-1394 # 80016550 <kmem>
    80000aca:	00000097          	auipc	ra,0x0
    80000ace:	24c080e7          	jalr	588(ra) # 80000d16 <acquire>
  uint64 page_num = PGROUNDDOWN((uint64)pa)/PGSIZE;
    80000ad2:	00c4d793          	srli	a5,s1,0xc
  if (ref_counter[page_num] > 1) {
    80000ad6:	00379693          	slli	a3,a5,0x3
    80000ada:	00016717          	auipc	a4,0x16
    80000ade:	a9670713          	addi	a4,a4,-1386 # 80016570 <ref_counter>
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
    80000af0:	00016717          	auipc	a4,0x16
    80000af4:	a8070713          	addi	a4,a4,-1408 # 80016570 <ref_counter>
    80000af8:	97ba                	add	a5,a5,a4
    80000afa:	0007b023          	sd	zero,0(a5)
  release(&kmem.lock);
    80000afe:	00016917          	auipc	s2,0x16
    80000b02:	a5290913          	addi	s2,s2,-1454 # 80016550 <kmem>
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
    80000b4a:	00009517          	auipc	a0,0x9
    80000b4e:	50650513          	addi	a0,a0,1286 # 8000a050 <etext+0x50>
    80000b52:	00000097          	auipc	ra,0x0
    80000b56:	a0e080e7          	jalr	-1522(ra) # 80000560 <panic>
    ref_counter[page_num]--;
    80000b5a:	078e                	slli	a5,a5,0x3
    80000b5c:	00016697          	auipc	a3,0x16
    80000b60:	a1468693          	addi	a3,a3,-1516 # 80016570 <ref_counter>
    80000b64:	97b6                	add	a5,a5,a3
    80000b66:	177d                	addi	a4,a4,-1
    80000b68:	e398                	sd	a4,0(a5)
    release(&kmem.lock);
    80000b6a:	00016517          	auipc	a0,0x16
    80000b6e:	9e650513          	addi	a0,a0,-1562 # 80016550 <kmem>
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
    80000bd0:	00009597          	auipc	a1,0x9
    80000bd4:	48858593          	addi	a1,a1,1160 # 8000a058 <etext+0x58>
    80000bd8:	00016517          	auipc	a0,0x16
    80000bdc:	97850513          	addi	a0,a0,-1672 # 80016550 <kmem>
    80000be0:	00000097          	auipc	ra,0x0
    80000be4:	0a2080e7          	jalr	162(ra) # 80000c82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000be8:	45c5                	li	a1,17
    80000bea:	05ee                	slli	a1,a1,0x1b
    80000bec:	00070517          	auipc	a0,0x70
    80000bf0:	e2050513          	addi	a0,a0,-480 # 80070a0c <end>
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
    80000c0e:	00016497          	auipc	s1,0x16
    80000c12:	94248493          	addi	s1,s1,-1726 # 80016550 <kmem>
    80000c16:	8526                	mv	a0,s1
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	0fe080e7          	jalr	254(ra) # 80000d16 <acquire>

  r = kmem.freelist;
    80000c20:	6c84                	ld	s1,24(s1)
  if(r)
    80000c22:	c0b1                	beqz	s1,80000c66 <kalloc+0x62>
    kmem.freelist = r->next;
    80000c24:	609c                	ld	a5,0(s1)
    80000c26:	00016517          	auipc	a0,0x16
    80000c2a:	92a50513          	addi	a0,a0,-1750 # 80016550 <kmem>
    80000c2e:	ed1c                	sd	a5,24(a0)
  uint64 page_num = PGROUNDDOWN((uint64)r)/PGSIZE;
    80000c30:	00c4d713          	srli	a4,s1,0xc
  ref_counter[page_num] = 1;
    80000c34:	070e                	slli	a4,a4,0x3
    80000c36:	00016797          	auipc	a5,0x16
    80000c3a:	93a78793          	addi	a5,a5,-1734 # 80016570 <ref_counter>
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
    80000c68:	00016717          	auipc	a4,0x16
    80000c6c:	90f73423          	sd	a5,-1784(a4) # 80016570 <ref_counter>
  release(&kmem.lock);
    80000c70:	00016517          	auipc	a0,0x16
    80000c74:	8e050513          	addi	a0,a0,-1824 # 80016550 <kmem>
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
    80000cb4:	18a080e7          	jalr	394(ra) # 80001e3a <mycpu>
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
    80000ce6:	158080e7          	jalr	344(ra) # 80001e3a <mycpu>
    80000cea:	5d3c                	lw	a5,120(a0)
    80000cec:	cf89                	beqz	a5,80000d06 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000cee:	00001097          	auipc	ra,0x1
    80000cf2:	14c080e7          	jalr	332(ra) # 80001e3a <mycpu>
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
    80000d0a:	134080e7          	jalr	308(ra) # 80001e3a <mycpu>
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
    80000d4a:	0f4080e7          	jalr	244(ra) # 80001e3a <mycpu>
    80000d4e:	e888                	sd	a0,16(s1)
}
    80000d50:	60e2                	ld	ra,24(sp)
    80000d52:	6442                	ld	s0,16(sp)
    80000d54:	64a2                	ld	s1,8(sp)
    80000d56:	6105                	addi	sp,sp,32
    80000d58:	8082                	ret
    panic("acquire");
    80000d5a:	00009517          	auipc	a0,0x9
    80000d5e:	30650513          	addi	a0,a0,774 # 8000a060 <etext+0x60>
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
    80000d76:	0c8080e7          	jalr	200(ra) # 80001e3a <mycpu>
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
    80000da6:	00009517          	auipc	a0,0x9
    80000daa:	2c250513          	addi	a0,a0,706 # 8000a068 <etext+0x68>
    80000dae:	fffff097          	auipc	ra,0xfffff
    80000db2:	7b2080e7          	jalr	1970(ra) # 80000560 <panic>
    panic("pop_off");
    80000db6:	00009517          	auipc	a0,0x9
    80000dba:	2ca50513          	addi	a0,a0,714 # 8000a080 <etext+0x80>
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
    80000dfe:	00009517          	auipc	a0,0x9
    80000e02:	28a50513          	addi	a0,a0,650 # 8000a088 <etext+0x88>
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

0000000080000fc8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000fc8:	1141                	addi	sp,sp,-16
    80000fca:	e406                	sd	ra,8(sp)
    80000fcc:	e022                	sd	s0,0(sp)
    80000fce:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	e56080e7          	jalr	-426(ra) # 80001e26 <cpuid>
    socket_init();
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000fd8:	0000d717          	auipc	a4,0xd
    80000fdc:	30070713          	addi	a4,a4,768 # 8000e2d8 <started>
  if(cpuid() == 0){
    80000fe0:	c139                	beqz	a0,80001026 <main+0x5e>
    while(started == 0)
    80000fe2:	431c                	lw	a5,0(a4)
    80000fe4:	2781                	sext.w	a5,a5
    80000fe6:	dff5                	beqz	a5,80000fe2 <main+0x1a>
      ;
    __sync_synchronize();
    80000fe8:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000fec:	00001097          	auipc	ra,0x1
    80000ff0:	e3a080e7          	jalr	-454(ra) # 80001e26 <cpuid>
    80000ff4:	85aa                	mv	a1,a0
    80000ff6:	00009517          	auipc	a0,0x9
    80000ffa:	0b250513          	addi	a0,a0,178 # 8000a0a8 <etext+0xa8>
    80000ffe:	fffff097          	auipc	ra,0xfffff
    80001002:	5ac080e7          	jalr	1452(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    80001006:	00000097          	auipc	ra,0x0
    8000100a:	0f0080e7          	jalr	240(ra) # 800010f6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000100e:	00002097          	auipc	ra,0x2
    80001012:	fce080e7          	jalr	-50(ra) # 80002fdc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001016:	00006097          	auipc	ra,0x6
    8000101a:	900080e7          	jalr	-1792(ra) # 80006916 <plicinithart>
  }

  scheduler();        
    8000101e:	00001097          	auipc	ra,0x1
    80001022:	538080e7          	jalr	1336(ra) # 80002556 <scheduler>
    consoleinit();
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	45c080e7          	jalr	1116(ra) # 80000482 <consoleinit>
    printfinit();
    8000102e:	fffff097          	auipc	ra,0xfffff
    80001032:	786080e7          	jalr	1926(ra) # 800007b4 <printfinit>
    printf("\n");
    80001036:	00009517          	auipc	a0,0x9
    8000103a:	fea50513          	addi	a0,a0,-22 # 8000a020 <etext+0x20>
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	56c080e7          	jalr	1388(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80001046:	00009517          	auipc	a0,0x9
    8000104a:	04a50513          	addi	a0,a0,74 # 8000a090 <etext+0x90>
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	55c080e7          	jalr	1372(ra) # 800005aa <printf>
    printf("\n");
    80001056:	00009517          	auipc	a0,0x9
    8000105a:	fca50513          	addi	a0,a0,-54 # 8000a020 <etext+0x20>
    8000105e:	fffff097          	auipc	ra,0xfffff
    80001062:	54c080e7          	jalr	1356(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80001066:	00000097          	auipc	ra,0x0
    8000106a:	b62080e7          	jalr	-1182(ra) # 80000bc8 <kinit>
    kvminit();       // create kernel page table
    8000106e:	00000097          	auipc	ra,0x0
    80001072:	356080e7          	jalr	854(ra) # 800013c4 <kvminit>
    kvminithart();   // turn on paging
    80001076:	00000097          	auipc	ra,0x0
    8000107a:	080080e7          	jalr	128(ra) # 800010f6 <kvminithart>
    procinit();      // process table
    8000107e:	00001097          	auipc	ra,0x1
    80001082:	cec080e7          	jalr	-788(ra) # 80001d6a <procinit>
    trapinit();      // trap vectors
    80001086:	00002097          	auipc	ra,0x2
    8000108a:	f2e080e7          	jalr	-210(ra) # 80002fb4 <trapinit>
    trapinithart();  // install kernel trap vector
    8000108e:	00002097          	auipc	ra,0x2
    80001092:	f4e080e7          	jalr	-178(ra) # 80002fdc <trapinithart>
    plicinit();      // set up interrupt controller
    80001096:	00006097          	auipc	ra,0x6
    8000109a:	864080e7          	jalr	-1948(ra) # 800068fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000109e:	00006097          	auipc	ra,0x6
    800010a2:	878080e7          	jalr	-1928(ra) # 80006916 <plicinithart>
    binit();         // buffer cache
    800010a6:	00003097          	auipc	ra,0x3
    800010aa:	8fe080e7          	jalr	-1794(ra) # 800039a4 <binit>
    iinit();         // inode table
    800010ae:	00003097          	auipc	ra,0x3
    800010b2:	f8e080e7          	jalr	-114(ra) # 8000403c <iinit>
    fileinit();      // file table
    800010b6:	00004097          	auipc	ra,0x4
    800010ba:	f60080e7          	jalr	-160(ra) # 80005016 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010be:	00006097          	auipc	ra,0x6
    800010c2:	960080e7          	jalr	-1696(ra) # 80006a1e <virtio_disk_init>
    virtio_net_init(); // emulated NIC driver 
    800010c6:	00006097          	auipc	ra,0x6
    800010ca:	eca080e7          	jalr	-310(ra) # 80006f90 <virtio_net_init>
    net_init();
    800010ce:	00007097          	auipc	ra,0x7
    800010d2:	fe4080e7          	jalr	-28(ra) # 800080b2 <net_init>
    socket_init();
    800010d6:	00007097          	auipc	ra,0x7
    800010da:	dd8080e7          	jalr	-552(ra) # 80007eae <socket_init>
    userinit();      // first user process
    800010de:	00001097          	auipc	ra,0x1
    800010e2:	066080e7          	jalr	102(ra) # 80002144 <userinit>
    __sync_synchronize();
    800010e6:	0330000f          	fence	rw,rw
    started = 1;
    800010ea:	4785                	li	a5,1
    800010ec:	0000d717          	auipc	a4,0xd
    800010f0:	1ef72623          	sw	a5,492(a4) # 8000e2d8 <started>
    800010f4:	b72d                	j	8000101e <main+0x56>

00000000800010f6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800010f6:	1141                	addi	sp,sp,-16
    800010f8:	e406                	sd	ra,8(sp)
    800010fa:	e022                	sd	s0,0(sp)
    800010fc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800010fe:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001102:	0000d797          	auipc	a5,0xd
    80001106:	1de7b783          	ld	a5,478(a5) # 8000e2e0 <kernel_pagetable>
    8000110a:	83b1                	srli	a5,a5,0xc
    8000110c:	577d                	li	a4,-1
    8000110e:	177e                	slli	a4,a4,0x3f
    80001110:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001112:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001116:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000111a:	60a2                	ld	ra,8(sp)
    8000111c:	6402                	ld	s0,0(sp)
    8000111e:	0141                	addi	sp,sp,16
    80001120:	8082                	ret

0000000080001122 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001122:	7139                	addi	sp,sp,-64
    80001124:	fc06                	sd	ra,56(sp)
    80001126:	f822                	sd	s0,48(sp)
    80001128:	f426                	sd	s1,40(sp)
    8000112a:	f04a                	sd	s2,32(sp)
    8000112c:	ec4e                	sd	s3,24(sp)
    8000112e:	e852                	sd	s4,16(sp)
    80001130:	e456                	sd	s5,8(sp)
    80001132:	e05a                	sd	s6,0(sp)
    80001134:	0080                	addi	s0,sp,64
    80001136:	84aa                	mv	s1,a0
    80001138:	89ae                	mv	s3,a1
    8000113a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000113c:	57fd                	li	a5,-1
    8000113e:	83e9                	srli	a5,a5,0x1a
    80001140:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001142:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001144:	04b7e263          	bltu	a5,a1,80001188 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80001148:	0149d933          	srl	s2,s3,s4
    8000114c:	1ff97913          	andi	s2,s2,511
    80001150:	090e                	slli	s2,s2,0x3
    80001152:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001154:	00093483          	ld	s1,0(s2)
    80001158:	0014f793          	andi	a5,s1,1
    8000115c:	cf95                	beqz	a5,80001198 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000115e:	80a9                	srli	s1,s1,0xa
    80001160:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80001162:	3a5d                	addiw	s4,s4,-9
    80001164:	ff6a12e3          	bne	s4,s6,80001148 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80001168:	00c9d513          	srli	a0,s3,0xc
    8000116c:	1ff57513          	andi	a0,a0,511
    80001170:	050e                	slli	a0,a0,0x3
    80001172:	9526                	add	a0,a0,s1
}
    80001174:	70e2                	ld	ra,56(sp)
    80001176:	7442                	ld	s0,48(sp)
    80001178:	74a2                	ld	s1,40(sp)
    8000117a:	7902                	ld	s2,32(sp)
    8000117c:	69e2                	ld	s3,24(sp)
    8000117e:	6a42                	ld	s4,16(sp)
    80001180:	6aa2                	ld	s5,8(sp)
    80001182:	6b02                	ld	s6,0(sp)
    80001184:	6121                	addi	sp,sp,64
    80001186:	8082                	ret
    panic("walk");
    80001188:	00009517          	auipc	a0,0x9
    8000118c:	f3850513          	addi	a0,a0,-200 # 8000a0c0 <etext+0xc0>
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	3d0080e7          	jalr	976(ra) # 80000560 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001198:	020a8663          	beqz	s5,800011c4 <walk+0xa2>
    8000119c:	00000097          	auipc	ra,0x0
    800011a0:	a68080e7          	jalr	-1432(ra) # 80000c04 <kalloc>
    800011a4:	84aa                	mv	s1,a0
    800011a6:	d579                	beqz	a0,80001174 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800011a8:	6605                	lui	a2,0x1
    800011aa:	4581                	li	a1,0
    800011ac:	00000097          	auipc	ra,0x0
    800011b0:	c62080e7          	jalr	-926(ra) # 80000e0e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800011b4:	00c4d793          	srli	a5,s1,0xc
    800011b8:	07aa                	slli	a5,a5,0xa
    800011ba:	0017e793          	ori	a5,a5,1
    800011be:	00f93023          	sd	a5,0(s2)
    800011c2:	b745                	j	80001162 <walk+0x40>
        return 0;
    800011c4:	4501                	li	a0,0
    800011c6:	b77d                	j	80001174 <walk+0x52>

00000000800011c8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800011c8:	57fd                	li	a5,-1
    800011ca:	83e9                	srli	a5,a5,0x1a
    800011cc:	00b7f463          	bgeu	a5,a1,800011d4 <walkaddr+0xc>
    return 0;
    800011d0:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800011d2:	8082                	ret
{
    800011d4:	1141                	addi	sp,sp,-16
    800011d6:	e406                	sd	ra,8(sp)
    800011d8:	e022                	sd	s0,0(sp)
    800011da:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800011dc:	4601                	li	a2,0
    800011de:	00000097          	auipc	ra,0x0
    800011e2:	f44080e7          	jalr	-188(ra) # 80001122 <walk>
  if(pte == 0)
    800011e6:	c105                	beqz	a0,80001206 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800011e8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800011ea:	0117f693          	andi	a3,a5,17
    800011ee:	4745                	li	a4,17
    return 0;
    800011f0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800011f2:	00e68663          	beq	a3,a4,800011fe <walkaddr+0x36>
}
    800011f6:	60a2                	ld	ra,8(sp)
    800011f8:	6402                	ld	s0,0(sp)
    800011fa:	0141                	addi	sp,sp,16
    800011fc:	8082                	ret
  pa = PTE2PA(*pte);
    800011fe:	83a9                	srli	a5,a5,0xa
    80001200:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001204:	bfcd                	j	800011f6 <walkaddr+0x2e>
    return 0;
    80001206:	4501                	li	a0,0
    80001208:	b7fd                	j	800011f6 <walkaddr+0x2e>

000000008000120a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000120a:	715d                	addi	sp,sp,-80
    8000120c:	e486                	sd	ra,72(sp)
    8000120e:	e0a2                	sd	s0,64(sp)
    80001210:	fc26                	sd	s1,56(sp)
    80001212:	f84a                	sd	s2,48(sp)
    80001214:	f44e                	sd	s3,40(sp)
    80001216:	f052                	sd	s4,32(sp)
    80001218:	ec56                	sd	s5,24(sp)
    8000121a:	e85a                	sd	s6,16(sp)
    8000121c:	e45e                	sd	s7,8(sp)
    8000121e:	e062                	sd	s8,0(sp)
    80001220:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001222:	ca21                	beqz	a2,80001272 <mappages+0x68>
    80001224:	8aaa                	mv	s5,a0
    80001226:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001228:	777d                	lui	a4,0xfffff
    8000122a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000122e:	fff58993          	addi	s3,a1,-1
    80001232:	99b2                	add	s3,s3,a2
    80001234:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001238:	893e                	mv	s2,a5
    8000123a:	40f68a33          	sub	s4,a3,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    8000123e:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001240:	6c05                	lui	s8,0x1
    80001242:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001246:	865e                	mv	a2,s7
    80001248:	85ca                	mv	a1,s2
    8000124a:	8556                	mv	a0,s5
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	ed6080e7          	jalr	-298(ra) # 80001122 <walk>
    80001254:	cd1d                	beqz	a0,80001292 <mappages+0x88>
    if(*pte & PTE_V)
    80001256:	611c                	ld	a5,0(a0)
    80001258:	8b85                	andi	a5,a5,1
    8000125a:	e785                	bnez	a5,80001282 <mappages+0x78>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000125c:	80b1                	srli	s1,s1,0xc
    8000125e:	04aa                	slli	s1,s1,0xa
    80001260:	0164e4b3          	or	s1,s1,s6
    80001264:	0014e493          	ori	s1,s1,1
    80001268:	e104                	sd	s1,0(a0)
    if(a == last)
    8000126a:	05390163          	beq	s2,s3,800012ac <mappages+0xa2>
    a += PGSIZE;
    8000126e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80001270:	bfc9                	j	80001242 <mappages+0x38>
    panic("mappages: size");
    80001272:	00009517          	auipc	a0,0x9
    80001276:	e5650513          	addi	a0,a0,-426 # 8000a0c8 <etext+0xc8>
    8000127a:	fffff097          	auipc	ra,0xfffff
    8000127e:	2e6080e7          	jalr	742(ra) # 80000560 <panic>
      panic("mappages: remap");
    80001282:	00009517          	auipc	a0,0x9
    80001286:	e5650513          	addi	a0,a0,-426 # 8000a0d8 <etext+0xd8>
    8000128a:	fffff097          	auipc	ra,0xfffff
    8000128e:	2d6080e7          	jalr	726(ra) # 80000560 <panic>
      return -1;
    80001292:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001294:	60a6                	ld	ra,72(sp)
    80001296:	6406                	ld	s0,64(sp)
    80001298:	74e2                	ld	s1,56(sp)
    8000129a:	7942                	ld	s2,48(sp)
    8000129c:	79a2                	ld	s3,40(sp)
    8000129e:	7a02                	ld	s4,32(sp)
    800012a0:	6ae2                	ld	s5,24(sp)
    800012a2:	6b42                	ld	s6,16(sp)
    800012a4:	6ba2                	ld	s7,8(sp)
    800012a6:	6c02                	ld	s8,0(sp)
    800012a8:	6161                	addi	sp,sp,80
    800012aa:	8082                	ret
  return 0;
    800012ac:	4501                	li	a0,0
    800012ae:	b7dd                	j	80001294 <mappages+0x8a>

00000000800012b0 <kvmmap>:
{
    800012b0:	1141                	addi	sp,sp,-16
    800012b2:	e406                	sd	ra,8(sp)
    800012b4:	e022                	sd	s0,0(sp)
    800012b6:	0800                	addi	s0,sp,16
    800012b8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800012ba:	86b2                	mv	a3,a2
    800012bc:	863e                	mv	a2,a5
    800012be:	00000097          	auipc	ra,0x0
    800012c2:	f4c080e7          	jalr	-180(ra) # 8000120a <mappages>
    800012c6:	e509                	bnez	a0,800012d0 <kvmmap+0x20>
}
    800012c8:	60a2                	ld	ra,8(sp)
    800012ca:	6402                	ld	s0,0(sp)
    800012cc:	0141                	addi	sp,sp,16
    800012ce:	8082                	ret
    panic("kvmmap");
    800012d0:	00009517          	auipc	a0,0x9
    800012d4:	e1850513          	addi	a0,a0,-488 # 8000a0e8 <etext+0xe8>
    800012d8:	fffff097          	auipc	ra,0xfffff
    800012dc:	288080e7          	jalr	648(ra) # 80000560 <panic>

00000000800012e0 <kvmmake>:
{
    800012e0:	1101                	addi	sp,sp,-32
    800012e2:	ec06                	sd	ra,24(sp)
    800012e4:	e822                	sd	s0,16(sp)
    800012e6:	e426                	sd	s1,8(sp)
    800012e8:	e04a                	sd	s2,0(sp)
    800012ea:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	918080e7          	jalr	-1768(ra) # 80000c04 <kalloc>
    800012f4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800012f6:	6605                	lui	a2,0x1
    800012f8:	4581                	li	a1,0
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	b14080e7          	jalr	-1260(ra) # 80000e0e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001302:	4719                	li	a4,6
    80001304:	6685                	lui	a3,0x1
    80001306:	10000637          	lui	a2,0x10000
    8000130a:	85b2                	mv	a1,a2
    8000130c:	8526                	mv	a0,s1
    8000130e:	00000097          	auipc	ra,0x0
    80001312:	fa2080e7          	jalr	-94(ra) # 800012b0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001316:	4719                	li	a4,6
    80001318:	6685                	lui	a3,0x1
    8000131a:	10001637          	lui	a2,0x10001
    8000131e:	85b2                	mv	a1,a2
    80001320:	8526                	mv	a0,s1
    80001322:	00000097          	auipc	ra,0x0
    80001326:	f8e080e7          	jalr	-114(ra) # 800012b0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO1, VIRTIO1, PGSIZE, PTE_R | PTE_W);
    8000132a:	4719                	li	a4,6
    8000132c:	6685                	lui	a3,0x1
    8000132e:	10002637          	lui	a2,0x10002
    80001332:	85b2                	mv	a1,a2
    80001334:	8526                	mv	a0,s1
    80001336:	00000097          	auipc	ra,0x0
    8000133a:	f7a080e7          	jalr	-134(ra) # 800012b0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000133e:	4719                	li	a4,6
    80001340:	004006b7          	lui	a3,0x400
    80001344:	0c000637          	lui	a2,0xc000
    80001348:	85b2                	mv	a1,a2
    8000134a:	8526                	mv	a0,s1
    8000134c:	00000097          	auipc	ra,0x0
    80001350:	f64080e7          	jalr	-156(ra) # 800012b0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001354:	00009917          	auipc	s2,0x9
    80001358:	cac90913          	addi	s2,s2,-852 # 8000a000 <etext>
    8000135c:	4729                	li	a4,10
    8000135e:	80009697          	auipc	a3,0x80009
    80001362:	ca268693          	addi	a3,a3,-862 # a000 <_entry-0x7fff6000>
    80001366:	4605                	li	a2,1
    80001368:	067e                	slli	a2,a2,0x1f
    8000136a:	85b2                	mv	a1,a2
    8000136c:	8526                	mv	a0,s1
    8000136e:	00000097          	auipc	ra,0x0
    80001372:	f42080e7          	jalr	-190(ra) # 800012b0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001376:	4719                	li	a4,6
    80001378:	46c5                	li	a3,17
    8000137a:	06ee                	slli	a3,a3,0x1b
    8000137c:	412686b3          	sub	a3,a3,s2
    80001380:	864a                	mv	a2,s2
    80001382:	85ca                	mv	a1,s2
    80001384:	8526                	mv	a0,s1
    80001386:	00000097          	auipc	ra,0x0
    8000138a:	f2a080e7          	jalr	-214(ra) # 800012b0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000138e:	4729                	li	a4,10
    80001390:	6685                	lui	a3,0x1
    80001392:	00008617          	auipc	a2,0x8
    80001396:	c6e60613          	addi	a2,a2,-914 # 80009000 <_trampoline>
    8000139a:	040005b7          	lui	a1,0x4000
    8000139e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800013a0:	05b2                	slli	a1,a1,0xc
    800013a2:	8526                	mv	a0,s1
    800013a4:	00000097          	auipc	ra,0x0
    800013a8:	f0c080e7          	jalr	-244(ra) # 800012b0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800013ac:	8526                	mv	a0,s1
    800013ae:	00001097          	auipc	ra,0x1
    800013b2:	912080e7          	jalr	-1774(ra) # 80001cc0 <proc_mapstacks>
}
    800013b6:	8526                	mv	a0,s1
    800013b8:	60e2                	ld	ra,24(sp)
    800013ba:	6442                	ld	s0,16(sp)
    800013bc:	64a2                	ld	s1,8(sp)
    800013be:	6902                	ld	s2,0(sp)
    800013c0:	6105                	addi	sp,sp,32
    800013c2:	8082                	ret

00000000800013c4 <kvminit>:
{
    800013c4:	1141                	addi	sp,sp,-16
    800013c6:	e406                	sd	ra,8(sp)
    800013c8:	e022                	sd	s0,0(sp)
    800013ca:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800013cc:	00000097          	auipc	ra,0x0
    800013d0:	f14080e7          	jalr	-236(ra) # 800012e0 <kvmmake>
    800013d4:	0000d797          	auipc	a5,0xd
    800013d8:	f0a7b623          	sd	a0,-244(a5) # 8000e2e0 <kernel_pagetable>
}
    800013dc:	60a2                	ld	ra,8(sp)
    800013de:	6402                	ld	s0,0(sp)
    800013e0:	0141                	addi	sp,sp,16
    800013e2:	8082                	ret

00000000800013e4 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800013e4:	715d                	addi	sp,sp,-80
    800013e6:	e486                	sd	ra,72(sp)
    800013e8:	e0a2                	sd	s0,64(sp)
    800013ea:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800013ec:	03459793          	slli	a5,a1,0x34
    800013f0:	e39d                	bnez	a5,80001416 <uvmunmap+0x32>
    800013f2:	f84a                	sd	s2,48(sp)
    800013f4:	f44e                	sd	s3,40(sp)
    800013f6:	f052                	sd	s4,32(sp)
    800013f8:	ec56                	sd	s5,24(sp)
    800013fa:	e85a                	sd	s6,16(sp)
    800013fc:	e45e                	sd	s7,8(sp)
    800013fe:	8a2a                	mv	s4,a0
    80001400:	892e                	mv	s2,a1
    80001402:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001404:	0632                	slli	a2,a2,0xc
    80001406:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000140a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000140c:	6b05                	lui	s6,0x1
    8000140e:	0935fb63          	bgeu	a1,s3,800014a4 <uvmunmap+0xc0>
    80001412:	fc26                	sd	s1,56(sp)
    80001414:	a8a9                	j	8000146e <uvmunmap+0x8a>
    80001416:	fc26                	sd	s1,56(sp)
    80001418:	f84a                	sd	s2,48(sp)
    8000141a:	f44e                	sd	s3,40(sp)
    8000141c:	f052                	sd	s4,32(sp)
    8000141e:	ec56                	sd	s5,24(sp)
    80001420:	e85a                	sd	s6,16(sp)
    80001422:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001424:	00009517          	auipc	a0,0x9
    80001428:	ccc50513          	addi	a0,a0,-820 # 8000a0f0 <etext+0xf0>
    8000142c:	fffff097          	auipc	ra,0xfffff
    80001430:	134080e7          	jalr	308(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    80001434:	00009517          	auipc	a0,0x9
    80001438:	cd450513          	addi	a0,a0,-812 # 8000a108 <etext+0x108>
    8000143c:	fffff097          	auipc	ra,0xfffff
    80001440:	124080e7          	jalr	292(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    80001444:	00009517          	auipc	a0,0x9
    80001448:	cd450513          	addi	a0,a0,-812 # 8000a118 <etext+0x118>
    8000144c:	fffff097          	auipc	ra,0xfffff
    80001450:	114080e7          	jalr	276(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    80001454:	00009517          	auipc	a0,0x9
    80001458:	cdc50513          	addi	a0,a0,-804 # 8000a130 <etext+0x130>
    8000145c:	fffff097          	auipc	ra,0xfffff
    80001460:	104080e7          	jalr	260(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001464:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001468:	995a                	add	s2,s2,s6
    8000146a:	03397c63          	bgeu	s2,s3,800014a2 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000146e:	4601                	li	a2,0
    80001470:	85ca                	mv	a1,s2
    80001472:	8552                	mv	a0,s4
    80001474:	00000097          	auipc	ra,0x0
    80001478:	cae080e7          	jalr	-850(ra) # 80001122 <walk>
    8000147c:	84aa                	mv	s1,a0
    8000147e:	d95d                	beqz	a0,80001434 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001480:	6108                	ld	a0,0(a0)
    80001482:	00157793          	andi	a5,a0,1
    80001486:	dfdd                	beqz	a5,80001444 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001488:	3ff57793          	andi	a5,a0,1023
    8000148c:	fd7784e3          	beq	a5,s7,80001454 <uvmunmap+0x70>
    if(do_free){
    80001490:	fc0a8ae3          	beqz	s5,80001464 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80001494:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001496:	0532                	slli	a0,a0,0xc
    80001498:	fffff097          	auipc	ra,0xfffff
    8000149c:	604080e7          	jalr	1540(ra) # 80000a9c <kfree>
    800014a0:	b7d1                	j	80001464 <uvmunmap+0x80>
    800014a2:	74e2                	ld	s1,56(sp)
    800014a4:	7942                	ld	s2,48(sp)
    800014a6:	79a2                	ld	s3,40(sp)
    800014a8:	7a02                	ld	s4,32(sp)
    800014aa:	6ae2                	ld	s5,24(sp)
    800014ac:	6b42                	ld	s6,16(sp)
    800014ae:	6ba2                	ld	s7,8(sp)
  }
}
    800014b0:	60a6                	ld	ra,72(sp)
    800014b2:	6406                	ld	s0,64(sp)
    800014b4:	6161                	addi	sp,sp,80
    800014b6:	8082                	ret

00000000800014b8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800014b8:	1101                	addi	sp,sp,-32
    800014ba:	ec06                	sd	ra,24(sp)
    800014bc:	e822                	sd	s0,16(sp)
    800014be:	e426                	sd	s1,8(sp)
    800014c0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800014c2:	fffff097          	auipc	ra,0xfffff
    800014c6:	742080e7          	jalr	1858(ra) # 80000c04 <kalloc>
    800014ca:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800014cc:	c519                	beqz	a0,800014da <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800014ce:	6605                	lui	a2,0x1
    800014d0:	4581                	li	a1,0
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	93c080e7          	jalr	-1732(ra) # 80000e0e <memset>
  return pagetable;
}
    800014da:	8526                	mv	a0,s1
    800014dc:	60e2                	ld	ra,24(sp)
    800014de:	6442                	ld	s0,16(sp)
    800014e0:	64a2                	ld	s1,8(sp)
    800014e2:	6105                	addi	sp,sp,32
    800014e4:	8082                	ret

00000000800014e6 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800014e6:	7179                	addi	sp,sp,-48
    800014e8:	f406                	sd	ra,40(sp)
    800014ea:	f022                	sd	s0,32(sp)
    800014ec:	ec26                	sd	s1,24(sp)
    800014ee:	e84a                	sd	s2,16(sp)
    800014f0:	e44e                	sd	s3,8(sp)
    800014f2:	e052                	sd	s4,0(sp)
    800014f4:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800014f6:	6785                	lui	a5,0x1
    800014f8:	04f67863          	bgeu	a2,a5,80001548 <uvmfirst+0x62>
    800014fc:	8a2a                	mv	s4,a0
    800014fe:	89ae                	mv	s3,a1
    80001500:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001502:	fffff097          	auipc	ra,0xfffff
    80001506:	702080e7          	jalr	1794(ra) # 80000c04 <kalloc>
    8000150a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000150c:	6605                	lui	a2,0x1
    8000150e:	4581                	li	a1,0
    80001510:	00000097          	auipc	ra,0x0
    80001514:	8fe080e7          	jalr	-1794(ra) # 80000e0e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001518:	4779                	li	a4,30
    8000151a:	86ca                	mv	a3,s2
    8000151c:	6605                	lui	a2,0x1
    8000151e:	4581                	li	a1,0
    80001520:	8552                	mv	a0,s4
    80001522:	00000097          	auipc	ra,0x0
    80001526:	ce8080e7          	jalr	-792(ra) # 8000120a <mappages>
  memmove(mem, src, sz);
    8000152a:	8626                	mv	a2,s1
    8000152c:	85ce                	mv	a1,s3
    8000152e:	854a                	mv	a0,s2
    80001530:	00000097          	auipc	ra,0x0
    80001534:	942080e7          	jalr	-1726(ra) # 80000e72 <memmove>
}
    80001538:	70a2                	ld	ra,40(sp)
    8000153a:	7402                	ld	s0,32(sp)
    8000153c:	64e2                	ld	s1,24(sp)
    8000153e:	6942                	ld	s2,16(sp)
    80001540:	69a2                	ld	s3,8(sp)
    80001542:	6a02                	ld	s4,0(sp)
    80001544:	6145                	addi	sp,sp,48
    80001546:	8082                	ret
    panic("uvmfirst: more than a page");
    80001548:	00009517          	auipc	a0,0x9
    8000154c:	c0050513          	addi	a0,a0,-1024 # 8000a148 <etext+0x148>
    80001550:	fffff097          	auipc	ra,0xfffff
    80001554:	010080e7          	jalr	16(ra) # 80000560 <panic>

0000000080001558 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
  uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001558:	1101                	addi	sp,sp,-32
    8000155a:	ec06                	sd	ra,24(sp)
    8000155c:	e822                	sd	s0,16(sp)
    8000155e:	e426                	sd	s1,8(sp)
    80001560:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001562:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001564:	00b67d63          	bgeu	a2,a1,8000157e <uvmdealloc+0x26>
    80001568:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000156a:	6785                	lui	a5,0x1
    8000156c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000156e:	00f60733          	add	a4,a2,a5
    80001572:	76fd                	lui	a3,0xfffff
    80001574:	8f75                	and	a4,a4,a3
    80001576:	97ae                	add	a5,a5,a1
    80001578:	8ff5                	and	a5,a5,a3
    8000157a:	00f76863          	bltu	a4,a5,8000158a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000157e:	8526                	mv	a0,s1
    80001580:	60e2                	ld	ra,24(sp)
    80001582:	6442                	ld	s0,16(sp)
    80001584:	64a2                	ld	s1,8(sp)
    80001586:	6105                	addi	sp,sp,32
    80001588:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000158a:	8f99                	sub	a5,a5,a4
    8000158c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000158e:	4685                	li	a3,1
    80001590:	0007861b          	sext.w	a2,a5
    80001594:	85ba                	mv	a1,a4
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	e4e080e7          	jalr	-434(ra) # 800013e4 <uvmunmap>
    8000159e:	b7c5                	j	8000157e <uvmdealloc+0x26>

00000000800015a0 <uvmalloc>:
  if(newsz < oldsz)
    800015a0:	0ab66f63          	bltu	a2,a1,8000165e <uvmalloc+0xbe>
{
    800015a4:	715d                	addi	sp,sp,-80
    800015a6:	e486                	sd	ra,72(sp)
    800015a8:	e0a2                	sd	s0,64(sp)
    800015aa:	f052                	sd	s4,32(sp)
    800015ac:	ec56                	sd	s5,24(sp)
    800015ae:	e85a                	sd	s6,16(sp)
    800015b0:	0880                	addi	s0,sp,80
    800015b2:	8b2a                	mv	s6,a0
    800015b4:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800015b6:	6785                	lui	a5,0x1
    800015b8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015ba:	95be                	add	a1,a1,a5
    800015bc:	77fd                	lui	a5,0xfffff
    800015be:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015c2:	0aca7063          	bgeu	s4,a2,80001662 <uvmalloc+0xc2>
    800015c6:	fc26                	sd	s1,56(sp)
    800015c8:	f84a                	sd	s2,48(sp)
    800015ca:	f44e                	sd	s3,40(sp)
    800015cc:	e45e                	sd	s7,8(sp)
    800015ce:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    800015d0:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015d2:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    800015d6:	fffff097          	auipc	ra,0xfffff
    800015da:	62e080e7          	jalr	1582(ra) # 80000c04 <kalloc>
    800015de:	84aa                	mv	s1,a0
    if(mem == 0){
    800015e0:	c915                	beqz	a0,80001614 <uvmalloc+0x74>
    memset(mem, 0, PGSIZE);
    800015e2:	864e                	mv	a2,s3
    800015e4:	4581                	li	a1,0
    800015e6:	00000097          	auipc	ra,0x0
    800015ea:	828080e7          	jalr	-2008(ra) # 80000e0e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015ee:	875e                	mv	a4,s7
    800015f0:	86a6                	mv	a3,s1
    800015f2:	864e                	mv	a2,s3
    800015f4:	85ca                	mv	a1,s2
    800015f6:	855a                	mv	a0,s6
    800015f8:	00000097          	auipc	ra,0x0
    800015fc:	c12080e7          	jalr	-1006(ra) # 8000120a <mappages>
    80001600:	ed0d                	bnez	a0,8000163a <uvmalloc+0x9a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001602:	994e                	add	s2,s2,s3
    80001604:	fd5969e3          	bltu	s2,s5,800015d6 <uvmalloc+0x36>
  return newsz;
    80001608:	8556                	mv	a0,s5
    8000160a:	74e2                	ld	s1,56(sp)
    8000160c:	7942                	ld	s2,48(sp)
    8000160e:	79a2                	ld	s3,40(sp)
    80001610:	6ba2                	ld	s7,8(sp)
    80001612:	a829                	j	8000162c <uvmalloc+0x8c>
      uvmdealloc(pagetable, a, oldsz);
    80001614:	8652                	mv	a2,s4
    80001616:	85ca                	mv	a1,s2
    80001618:	855a                	mv	a0,s6
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	f3e080e7          	jalr	-194(ra) # 80001558 <uvmdealloc>
      return 0;
    80001622:	4501                	li	a0,0
    80001624:	74e2                	ld	s1,56(sp)
    80001626:	7942                	ld	s2,48(sp)
    80001628:	79a2                	ld	s3,40(sp)
    8000162a:	6ba2                	ld	s7,8(sp)
}
    8000162c:	60a6                	ld	ra,72(sp)
    8000162e:	6406                	ld	s0,64(sp)
    80001630:	7a02                	ld	s4,32(sp)
    80001632:	6ae2                	ld	s5,24(sp)
    80001634:	6b42                	ld	s6,16(sp)
    80001636:	6161                	addi	sp,sp,80
    80001638:	8082                	ret
      kfree(mem);
    8000163a:	8526                	mv	a0,s1
    8000163c:	fffff097          	auipc	ra,0xfffff
    80001640:	460080e7          	jalr	1120(ra) # 80000a9c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001644:	8652                	mv	a2,s4
    80001646:	85ca                	mv	a1,s2
    80001648:	855a                	mv	a0,s6
    8000164a:	00000097          	auipc	ra,0x0
    8000164e:	f0e080e7          	jalr	-242(ra) # 80001558 <uvmdealloc>
      return 0;
    80001652:	4501                	li	a0,0
    80001654:	74e2                	ld	s1,56(sp)
    80001656:	7942                	ld	s2,48(sp)
    80001658:	79a2                	ld	s3,40(sp)
    8000165a:	6ba2                	ld	s7,8(sp)
    8000165c:	bfc1                	j	8000162c <uvmalloc+0x8c>
    return oldsz;
    8000165e:	852e                	mv	a0,a1
}
    80001660:	8082                	ret
  return newsz;
    80001662:	8532                	mv	a0,a2
    80001664:	b7e1                	j	8000162c <uvmalloc+0x8c>

0000000080001666 <uvmthreaded_alloc>:
uvmthreaded_alloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz, uint64 xperm) {
    80001666:	7119                	addi	sp,sp,-128
    80001668:	fc86                	sd	ra,120(sp)
    8000166a:	f8a2                	sd	s0,112(sp)
    8000166c:	0100                	addi	s0,sp,128
    8000166e:	f8a43423          	sd	a0,-120(s0)
  if(newsz < oldsz)
    80001672:	16b66163          	bltu	a2,a1,800017d4 <uvmthreaded_alloc+0x16e>
    80001676:	e4d6                	sd	s5,72(sp)
    80001678:	f466                	sd	s9,40(sp)
    8000167a:	f06a                	sd	s10,32(sp)
    8000167c:	8ab2                	mv	s5,a2
    8000167e:	8d36                	mv	s10,a3
  oldsz = PGROUNDUP(oldsz);
    80001680:	6785                	lui	a5,0x1
    80001682:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001684:	95be                	add	a1,a1,a5
    80001686:	77fd                	lui	a5,0xfffff
    80001688:	00f5fcb3          	and	s9,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000168c:	14ccf663          	bgeu	s9,a2,800017d8 <uvmthreaded_alloc+0x172>
    80001690:	f4a6                	sd	s1,104(sp)
    80001692:	f0ca                	sd	s2,96(sp)
    80001694:	ecce                	sd	s3,88(sp)
    80001696:	e8d2                	sd	s4,80(sp)
    80001698:	e0da                	sd	s6,64(sp)
    8000169a:	fc5e                	sd	s7,56(sp)
    8000169c:	f862                	sd	s8,48(sp)
    8000169e:	ec6e                	sd	s11,24(sp)
  struct proc *p = thread_proc->parent;
    800016a0:	03853d83          	ld	s11,56(a0)
  for(a = oldsz; a < newsz; a += PGSIZE){
    800016a4:	8b66                	mv	s6,s9
    memset(mem, 0, PGSIZE);
    800016a6:	6c05                	lui	s8,0x1
    800016a8:	370d8a13          	addi	s4,s11,880
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800016ac:	0126eb93          	ori	s7,a3,18
    800016b0:	2b81                	sext.w	s7,s7
    mem = kalloc();
    800016b2:	fffff097          	auipc	ra,0xfffff
    800016b6:	552080e7          	jalr	1362(ra) # 80000c04 <kalloc>
    800016ba:	89aa                	mv	s3,a0
    if(mem == 0){
    800016bc:	c911                	beqz	a0,800016d0 <uvmthreaded_alloc+0x6a>
    memset(mem, 0, PGSIZE);
    800016be:	8662                	mv	a2,s8
    800016c0:	4581                	li	a1,0
    800016c2:	fffff097          	auipc	ra,0xfffff
    800016c6:	74c080e7          	jalr	1868(ra) # 80000e0e <memset>
    for (int i = 0; i < MAX_THREADS; i++) {
    800016ca:	170d8493          	addi	s1,s11,368
    800016ce:	a0bd                	j	8000173c <uvmthreaded_alloc+0xd6>
      uvmdealloc(thread_proc->pagetable, a, oldsz);
    800016d0:	8666                	mv	a2,s9
    800016d2:	85da                	mv	a1,s6
    800016d4:	f8843783          	ld	a5,-120(s0)
    800016d8:	6ba8                	ld	a0,80(a5)
    800016da:	00000097          	auipc	ra,0x0
    800016de:	e7e080e7          	jalr	-386(ra) # 80001558 <uvmdealloc>
      return 0;
    800016e2:	4501                	li	a0,0
    800016e4:	74a6                	ld	s1,104(sp)
    800016e6:	7906                	ld	s2,96(sp)
    800016e8:	69e6                	ld	s3,88(sp)
    800016ea:	6a46                	ld	s4,80(sp)
    800016ec:	6aa6                	ld	s5,72(sp)
    800016ee:	6b06                	ld	s6,64(sp)
    800016f0:	7be2                	ld	s7,56(sp)
    800016f2:	7c42                	ld	s8,48(sp)
    800016f4:	7ca2                	ld	s9,40(sp)
    800016f6:	7d02                	ld	s10,32(sp)
    800016f8:	6de2                	ld	s11,24(sp)
    800016fa:	a815                	j	8000172e <uvmthreaded_alloc+0xc8>
        kfree(mem);
    800016fc:	854e                	mv	a0,s3
    800016fe:	fffff097          	auipc	ra,0xfffff
    80001702:	39e080e7          	jalr	926(ra) # 80000a9c <kfree>
        uvmdealloc(infant->pagetable, a, oldsz);
    80001706:	8666                	mv	a2,s9
    80001708:	85da                	mv	a1,s6
    8000170a:	05093503          	ld	a0,80(s2)
    8000170e:	00000097          	auipc	ra,0x0
    80001712:	e4a080e7          	jalr	-438(ra) # 80001558 <uvmdealloc>
        return 0;
    80001716:	4501                	li	a0,0
    80001718:	74a6                	ld	s1,104(sp)
    8000171a:	7906                	ld	s2,96(sp)
    8000171c:	69e6                	ld	s3,88(sp)
    8000171e:	6a46                	ld	s4,80(sp)
    80001720:	6aa6                	ld	s5,72(sp)
    80001722:	6b06                	ld	s6,64(sp)
    80001724:	7be2                	ld	s7,56(sp)
    80001726:	7c42                	ld	s8,48(sp)
    80001728:	7ca2                	ld	s9,40(sp)
    8000172a:	7d02                	ld	s10,32(sp)
    8000172c:	6de2                	ld	s11,24(sp)
}
    8000172e:	70e6                	ld	ra,120(sp)
    80001730:	7446                	ld	s0,112(sp)
    80001732:	6109                	addi	sp,sp,128
    80001734:	8082                	ret
    for (int i = 0; i < MAX_THREADS; i++) {
    80001736:	04a1                	addi	s1,s1,8
    80001738:	03448463          	beq	s1,s4,80001760 <uvmthreaded_alloc+0xfa>
      struct proc *infant = p->infant_threads[i];
    8000173c:	0004b903          	ld	s2,0(s1)
      if (infant == 0)
    80001740:	fe090be3          	beqz	s2,80001736 <uvmthreaded_alloc+0xd0>
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001744:	875e                	mv	a4,s7
    80001746:	86ce                	mv	a3,s3
    80001748:	8662                	mv	a2,s8
    8000174a:	85da                	mv	a1,s6
    8000174c:	05093503          	ld	a0,80(s2)
    80001750:	00000097          	auipc	ra,0x0
    80001754:	aba080e7          	jalr	-1350(ra) # 8000120a <mappages>
    80001758:	f155                	bnez	a0,800016fc <uvmthreaded_alloc+0x96>
      infant->sz = newsz;
    8000175a:	05593423          	sd	s5,72(s2)
    8000175e:	bfe1                	j	80001736 <uvmthreaded_alloc+0xd0>
    if(mappages(p->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001760:	012d6713          	ori	a4,s10,18
    80001764:	2701                	sext.w	a4,a4
    80001766:	86ce                	mv	a3,s3
    80001768:	6605                	lui	a2,0x1
    8000176a:	85da                	mv	a1,s6
    8000176c:	050db503          	ld	a0,80(s11)
    80001770:	00000097          	auipc	ra,0x0
    80001774:	a9a080e7          	jalr	-1382(ra) # 8000120a <mappages>
    80001778:	e505                	bnez	a0,800017a0 <uvmthreaded_alloc+0x13a>
    p->sz = newsz;
    8000177a:	055db423          	sd	s5,72(s11)
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000177e:	6785                	lui	a5,0x1
    80001780:	9b3e                	add	s6,s6,a5
    80001782:	f35b68e3          	bltu	s6,s5,800016b2 <uvmthreaded_alloc+0x4c>
  return newsz;
    80001786:	8556                	mv	a0,s5
    80001788:	74a6                	ld	s1,104(sp)
    8000178a:	7906                	ld	s2,96(sp)
    8000178c:	69e6                	ld	s3,88(sp)
    8000178e:	6a46                	ld	s4,80(sp)
    80001790:	6aa6                	ld	s5,72(sp)
    80001792:	6b06                	ld	s6,64(sp)
    80001794:	7be2                	ld	s7,56(sp)
    80001796:	7c42                	ld	s8,48(sp)
    80001798:	7ca2                	ld	s9,40(sp)
    8000179a:	7d02                	ld	s10,32(sp)
    8000179c:	6de2                	ld	s11,24(sp)
    8000179e:	bf41                	j	8000172e <uvmthreaded_alloc+0xc8>
      kfree(mem);
    800017a0:	854e                	mv	a0,s3
    800017a2:	fffff097          	auipc	ra,0xfffff
    800017a6:	2fa080e7          	jalr	762(ra) # 80000a9c <kfree>
      uvmdealloc(p->pagetable, a, oldsz);
    800017aa:	8666                	mv	a2,s9
    800017ac:	85da                	mv	a1,s6
    800017ae:	050db503          	ld	a0,80(s11)
    800017b2:	00000097          	auipc	ra,0x0
    800017b6:	da6080e7          	jalr	-602(ra) # 80001558 <uvmdealloc>
      return 0;
    800017ba:	4501                	li	a0,0
    800017bc:	74a6                	ld	s1,104(sp)
    800017be:	7906                	ld	s2,96(sp)
    800017c0:	69e6                	ld	s3,88(sp)
    800017c2:	6a46                	ld	s4,80(sp)
    800017c4:	6aa6                	ld	s5,72(sp)
    800017c6:	6b06                	ld	s6,64(sp)
    800017c8:	7be2                	ld	s7,56(sp)
    800017ca:	7c42                	ld	s8,48(sp)
    800017cc:	7ca2                	ld	s9,40(sp)
    800017ce:	7d02                	ld	s10,32(sp)
    800017d0:	6de2                	ld	s11,24(sp)
    800017d2:	bfb1                	j	8000172e <uvmthreaded_alloc+0xc8>
    return oldsz;
    800017d4:	852e                	mv	a0,a1
    800017d6:	bfa1                	j	8000172e <uvmthreaded_alloc+0xc8>
  return newsz;
    800017d8:	8532                	mv	a0,a2
    800017da:	6aa6                	ld	s5,72(sp)
    800017dc:	7ca2                	ld	s9,40(sp)
    800017de:	7d02                	ld	s10,32(sp)
    800017e0:	b7b9                	j	8000172e <uvmthreaded_alloc+0xc8>

00000000800017e2 <uvmthreaded_dealloc>:

uint64
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
  struct proc *p = thread_proc->parent;

  if(newsz >= oldsz)
    800017e2:	0ab67163          	bgeu	a2,a1,80001884 <uvmthreaded_dealloc+0xa2>
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
    800017e6:	715d                	addi	sp,sp,-80
    800017e8:	e486                	sd	ra,72(sp)
    800017ea:	e0a2                	sd	s0,64(sp)
    800017ec:	fc26                	sd	s1,56(sp)
    800017ee:	f84a                	sd	s2,48(sp)
    800017f0:	f44e                	sd	s3,40(sp)
    800017f2:	f052                	sd	s4,32(sp)
    800017f4:	ec56                	sd	s5,24(sp)
    800017f6:	e85a                	sd	s6,16(sp)
    800017f8:	e45e                	sd	s7,8(sp)
    800017fa:	e062                	sd	s8,0(sp)
    800017fc:	0880                	addi	s0,sp,80
    800017fe:	8ab2                	mv	s5,a2
  struct proc *p = thread_proc->parent;
    80001800:	03853c03          	ld	s8,56(a0)
    return oldsz;

  int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001804:	6785                	lui	a5,0x1
    80001806:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001808:	95be                	add	a1,a1,a5
    8000180a:	777d                	lui	a4,0xfffff
    8000180c:	00e5fb33          	and	s6,a1,a4
    80001810:	97b2                	add	a5,a5,a2
    80001812:	00e7f9b3          	and	s3,a5,a4
    80001816:	413b0bb3          	sub	s7,s6,s3
    8000181a:	00cbdb93          	srli	s7,s7,0xc
    8000181e:	2b81                	sext.w	s7,s7

  for (int i = 0; i < MAX_THREADS; i++) {
    80001820:	170c0493          	addi	s1,s8,368 # 1170 <_entry-0x7fffee90>
    80001824:	370c0a13          	addi	s4,s8,880
    80001828:	a031                	j	80001834 <uvmthreaded_dealloc+0x52>
      continue;

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    }
    infant->sz = newsz;
    8000182a:	05593423          	sd	s5,72(s2)
  for (int i = 0; i < MAX_THREADS; i++) {
    8000182e:	04a1                	addi	s1,s1,8
    80001830:	03448263          	beq	s1,s4,80001854 <uvmthreaded_dealloc+0x72>
    struct proc *infant = p->infant_threads[i];
    80001834:	0004b903          	ld	s2,0(s1)
    if (infant == 0)
    80001838:	fe090be3          	beqz	s2,8000182e <uvmthreaded_dealloc+0x4c>
    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
    8000183c:	ff69f7e3          	bgeu	s3,s6,8000182a <uvmthreaded_dealloc+0x48>
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    80001840:	4681                	li	a3,0
    80001842:	865e                	mv	a2,s7
    80001844:	85ce                	mv	a1,s3
    80001846:	05093503          	ld	a0,80(s2)
    8000184a:	00000097          	auipc	ra,0x0
    8000184e:	b9a080e7          	jalr	-1126(ra) # 800013e4 <uvmunmap>
    80001852:	bfe1                	j	8000182a <uvmthreaded_dealloc+0x48>
  }

  uvmunmap(p->pagetable, PGROUNDUP(newsz), npages, 1); //unmap with freeing
    80001854:	4685                	li	a3,1
    80001856:	865e                	mv	a2,s7
    80001858:	85ce                	mv	a1,s3
    8000185a:	050c3503          	ld	a0,80(s8)
    8000185e:	00000097          	auipc	ra,0x0
    80001862:	b86080e7          	jalr	-1146(ra) # 800013e4 <uvmunmap>
  p->sz = newsz;
    80001866:	055c3423          	sd	s5,72(s8)

  return newsz;
    8000186a:	8556                	mv	a0,s5
}
    8000186c:	60a6                	ld	ra,72(sp)
    8000186e:	6406                	ld	s0,64(sp)
    80001870:	74e2                	ld	s1,56(sp)
    80001872:	7942                	ld	s2,48(sp)
    80001874:	79a2                	ld	s3,40(sp)
    80001876:	7a02                	ld	s4,32(sp)
    80001878:	6ae2                	ld	s5,24(sp)
    8000187a:	6b42                	ld	s6,16(sp)
    8000187c:	6ba2                	ld	s7,8(sp)
    8000187e:	6c02                	ld	s8,0(sp)
    80001880:	6161                	addi	sp,sp,80
    80001882:	8082                	ret
    return oldsz;
    80001884:	852e                	mv	a0,a1
}
    80001886:	8082                	ret

0000000080001888 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001888:	7179                	addi	sp,sp,-48
    8000188a:	f406                	sd	ra,40(sp)
    8000188c:	f022                	sd	s0,32(sp)
    8000188e:	ec26                	sd	s1,24(sp)
    80001890:	e84a                	sd	s2,16(sp)
    80001892:	e44e                	sd	s3,8(sp)
    80001894:	e052                	sd	s4,0(sp)
    80001896:	1800                	addi	s0,sp,48
    80001898:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000189a:	84aa                	mv	s1,a0
    8000189c:	6905                	lui	s2,0x1
    8000189e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800018a0:	4985                	li	s3,1
    800018a2:	a829                	j	800018bc <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800018a4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800018a6:	00c79513          	slli	a0,a5,0xc
    800018aa:	00000097          	auipc	ra,0x0
    800018ae:	fde080e7          	jalr	-34(ra) # 80001888 <freewalk>
      pagetable[i] = 0;
    800018b2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800018b6:	04a1                	addi	s1,s1,8
    800018b8:	03248163          	beq	s1,s2,800018da <freewalk+0x52>
    pte_t pte = pagetable[i];
    800018bc:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800018be:	00f7f713          	andi	a4,a5,15
    800018c2:	ff3701e3          	beq	a4,s3,800018a4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800018c6:	8b85                	andi	a5,a5,1
    800018c8:	d7fd                	beqz	a5,800018b6 <freewalk+0x2e>
      panic("freewalk: leaf");
    800018ca:	00009517          	auipc	a0,0x9
    800018ce:	89e50513          	addi	a0,a0,-1890 # 8000a168 <etext+0x168>
    800018d2:	fffff097          	auipc	ra,0xfffff
    800018d6:	c8e080e7          	jalr	-882(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    800018da:	8552                	mv	a0,s4
    800018dc:	fffff097          	auipc	ra,0xfffff
    800018e0:	1c0080e7          	jalr	448(ra) # 80000a9c <kfree>
}
    800018e4:	70a2                	ld	ra,40(sp)
    800018e6:	7402                	ld	s0,32(sp)
    800018e8:	64e2                	ld	s1,24(sp)
    800018ea:	6942                	ld	s2,16(sp)
    800018ec:	69a2                	ld	s3,8(sp)
    800018ee:	6a02                	ld	s4,0(sp)
    800018f0:	6145                	addi	sp,sp,48
    800018f2:	8082                	ret

00000000800018f4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800018f4:	1101                	addi	sp,sp,-32
    800018f6:	ec06                	sd	ra,24(sp)
    800018f8:	e822                	sd	s0,16(sp)
    800018fa:	e426                	sd	s1,8(sp)
    800018fc:	1000                	addi	s0,sp,32
    800018fe:	84aa                	mv	s1,a0
  if(sz > 0)
    80001900:	e999                	bnez	a1,80001916 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001902:	8526                	mv	a0,s1
    80001904:	00000097          	auipc	ra,0x0
    80001908:	f84080e7          	jalr	-124(ra) # 80001888 <freewalk>
}
    8000190c:	60e2                	ld	ra,24(sp)
    8000190e:	6442                	ld	s0,16(sp)
    80001910:	64a2                	ld	s1,8(sp)
    80001912:	6105                	addi	sp,sp,32
    80001914:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001916:	6785                	lui	a5,0x1
    80001918:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000191a:	95be                	add	a1,a1,a5
    8000191c:	4685                	li	a3,1
    8000191e:	00c5d613          	srli	a2,a1,0xc
    80001922:	4581                	li	a1,0
    80001924:	00000097          	auipc	ra,0x0
    80001928:	ac0080e7          	jalr	-1344(ra) # 800013e4 <uvmunmap>
    8000192c:	bfd9                	j	80001902 <uvmfree+0xe>

000000008000192e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000192e:	ca69                	beqz	a2,80001a00 <uvmcopy+0xd2>
{
    80001930:	715d                	addi	sp,sp,-80
    80001932:	e486                	sd	ra,72(sp)
    80001934:	e0a2                	sd	s0,64(sp)
    80001936:	fc26                	sd	s1,56(sp)
    80001938:	f84a                	sd	s2,48(sp)
    8000193a:	f44e                	sd	s3,40(sp)
    8000193c:	f052                	sd	s4,32(sp)
    8000193e:	ec56                	sd	s5,24(sp)
    80001940:	e85a                	sd	s6,16(sp)
    80001942:	e45e                	sd	s7,8(sp)
    80001944:	e062                	sd	s8,0(sp)
    80001946:	0880                	addi	s0,sp,80
    80001948:	8baa                	mv	s7,a0
    8000194a:	8b2e                	mv	s6,a1
    8000194c:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000194e:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001950:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    80001952:	4601                	li	a2,0
    80001954:	85ce                	mv	a1,s3
    80001956:	855e                	mv	a0,s7
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	7ca080e7          	jalr	1994(ra) # 80001122 <walk>
    80001960:	c529                	beqz	a0,800019aa <uvmcopy+0x7c>
    if((*pte & PTE_V) == 0)
    80001962:	6118                	ld	a4,0(a0)
    80001964:	00177793          	andi	a5,a4,1
    80001968:	cba9                	beqz	a5,800019ba <uvmcopy+0x8c>
    pa = PTE2PA(*pte);
    8000196a:	00a75593          	srli	a1,a4,0xa
    8000196e:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001972:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001976:	fffff097          	auipc	ra,0xfffff
    8000197a:	28e080e7          	jalr	654(ra) # 80000c04 <kalloc>
    8000197e:	892a                	mv	s2,a0
    80001980:	c931                	beqz	a0,800019d4 <uvmcopy+0xa6>
    memmove(mem, (char*)pa, PGSIZE);
    80001982:	8652                	mv	a2,s4
    80001984:	85e2                	mv	a1,s8
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	4ec080e7          	jalr	1260(ra) # 80000e72 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000198e:	8726                	mv	a4,s1
    80001990:	86ca                	mv	a3,s2
    80001992:	8652                	mv	a2,s4
    80001994:	85ce                	mv	a1,s3
    80001996:	855a                	mv	a0,s6
    80001998:	00000097          	auipc	ra,0x0
    8000199c:	872080e7          	jalr	-1934(ra) # 8000120a <mappages>
    800019a0:	e50d                	bnez	a0,800019ca <uvmcopy+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
    800019a2:	99d2                	add	s3,s3,s4
    800019a4:	fb59e7e3          	bltu	s3,s5,80001952 <uvmcopy+0x24>
    800019a8:	a081                	j	800019e8 <uvmcopy+0xba>
      panic("uvmcopy: pte should exist");
    800019aa:	00008517          	auipc	a0,0x8
    800019ae:	7ce50513          	addi	a0,a0,1998 # 8000a178 <etext+0x178>
    800019b2:	fffff097          	auipc	ra,0xfffff
    800019b6:	bae080e7          	jalr	-1106(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    800019ba:	00008517          	auipc	a0,0x8
    800019be:	7de50513          	addi	a0,a0,2014 # 8000a198 <etext+0x198>
    800019c2:	fffff097          	auipc	ra,0xfffff
    800019c6:	b9e080e7          	jalr	-1122(ra) # 80000560 <panic>
      kfree(mem);
    800019ca:	854a                	mv	a0,s2
    800019cc:	fffff097          	auipc	ra,0xfffff
    800019d0:	0d0080e7          	jalr	208(ra) # 80000a9c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800019d4:	4685                	li	a3,1
    800019d6:	00c9d613          	srli	a2,s3,0xc
    800019da:	4581                	li	a1,0
    800019dc:	855a                	mv	a0,s6
    800019de:	00000097          	auipc	ra,0x0
    800019e2:	a06080e7          	jalr	-1530(ra) # 800013e4 <uvmunmap>
  return -1;
    800019e6:	557d                	li	a0,-1
}
    800019e8:	60a6                	ld	ra,72(sp)
    800019ea:	6406                	ld	s0,64(sp)
    800019ec:	74e2                	ld	s1,56(sp)
    800019ee:	7942                	ld	s2,48(sp)
    800019f0:	79a2                	ld	s3,40(sp)
    800019f2:	7a02                	ld	s4,32(sp)
    800019f4:	6ae2                	ld	s5,24(sp)
    800019f6:	6b42                	ld	s6,16(sp)
    800019f8:	6ba2                	ld	s7,8(sp)
    800019fa:	6c02                	ld	s8,0(sp)
    800019fc:	6161                	addi	sp,sp,80
    800019fe:	8082                	ret
  return 0;
    80001a00:	4501                	li	a0,0
}
    80001a02:	8082                	ret

0000000080001a04 <uvmshare>:

int
uvmshare(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001a04:	715d                	addi	sp,sp,-80
    80001a06:	e486                	sd	ra,72(sp)
    80001a08:	e0a2                	sd	s0,64(sp)
    80001a0a:	f44e                	sd	s3,40(sp)
    80001a0c:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa = 0, i;
  uint flags;
  
  for(i = 0; i < sz; i += PGSIZE) {
    80001a0e:	ce5d                	beqz	a2,80001acc <uvmshare+0xc8>
    80001a10:	fc26                	sd	s1,56(sp)
    80001a12:	f84a                	sd	s2,48(sp)
    80001a14:	f052                	sd	s4,32(sp)
    80001a16:	ec56                	sd	s5,24(sp)
    80001a18:	e85a                	sd	s6,16(sp)
    80001a1a:	e45e                	sd	s7,8(sp)
    80001a1c:	8baa                	mv	s7,a0
    80001a1e:	8b2e                	mv	s6,a1
    80001a20:	8ab2                	mv	s5,a2
    80001a22:	4901                	li	s2,0

    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    // flags |= PTE_W;

    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
    80001a24:	6a05                	lui	s4,0x1
    80001a26:	a891                	j	80001a7a <uvmshare+0x76>
    if(pte == 0) panic("uvmshare: pte should exist");
    80001a28:	00008517          	auipc	a0,0x8
    80001a2c:	79050513          	addi	a0,a0,1936 # 8000a1b8 <etext+0x1b8>
    80001a30:	fffff097          	auipc	ra,0xfffff
    80001a34:	b30080e7          	jalr	-1232(ra) # 80000560 <panic>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001a38:	00008517          	auipc	a0,0x8
    80001a3c:	7a050513          	addi	a0,a0,1952 # 8000a1d8 <etext+0x1d8>
    80001a40:	fffff097          	auipc	ra,0xfffff
    80001a44:	b20080e7          	jalr	-1248(ra) # 80000560 <panic>
      uvmunmap(new, 0, i / PGSIZE, 0);
    80001a48:	4681                	li	a3,0
    80001a4a:	00c95613          	srli	a2,s2,0xc
    80001a4e:	4581                	li	a1,0
    80001a50:	855a                	mv	a0,s6
    80001a52:	00000097          	auipc	ra,0x0
    80001a56:	992080e7          	jalr	-1646(ra) # 800013e4 <uvmunmap>
      return -1;
    80001a5a:	59fd                	li	s3,-1
    80001a5c:	74e2                	ld	s1,56(sp)
    80001a5e:	7942                	ld	s2,48(sp)
    80001a60:	7a02                	ld	s4,32(sp)
    80001a62:	6ae2                	ld	s5,24(sp)
    80001a64:	6b42                	ld	s6,16(sp)
    80001a66:	6ba2                	ld	s7,8(sp)
      add_page_reference((uint64)pa);
  }

  return 0;

}
    80001a68:	854e                	mv	a0,s3
    80001a6a:	60a6                	ld	ra,72(sp)
    80001a6c:	6406                	ld	s0,64(sp)
    80001a6e:	79a2                	ld	s3,40(sp)
    80001a70:	6161                	addi	sp,sp,80
    80001a72:	8082                	ret
  for(i = 0; i < sz; i += PGSIZE) {
    80001a74:	9952                	add	s2,s2,s4
    80001a76:	05597463          	bgeu	s2,s5,80001abe <uvmshare+0xba>
    pte = walk(old, i, 0);
    80001a7a:	4601                	li	a2,0
    80001a7c:	85ca                	mv	a1,s2
    80001a7e:	855e                	mv	a0,s7
    80001a80:	fffff097          	auipc	ra,0xfffff
    80001a84:	6a2080e7          	jalr	1698(ra) # 80001122 <walk>
    if(pte == 0) panic("uvmshare: pte should exist");
    80001a88:	d145                	beqz	a0,80001a28 <uvmshare+0x24>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001a8a:	6118                	ld	a4,0(a0)
    80001a8c:	00177793          	andi	a5,a4,1
    80001a90:	d7c5                	beqz	a5,80001a38 <uvmshare+0x34>
    pa = PTE2PA(*pte);
    80001a92:	00a75493          	srli	s1,a4,0xa
    80001a96:	04b2                	slli	s1,s1,0xc
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
    80001a98:	3ff77713          	andi	a4,a4,1023
    80001a9c:	86a6                	mv	a3,s1
    80001a9e:	8652                	mv	a2,s4
    80001aa0:	85ca                	mv	a1,s2
    80001aa2:	855a                	mv	a0,s6
    80001aa4:	fffff097          	auipc	ra,0xfffff
    80001aa8:	766080e7          	jalr	1894(ra) # 8000120a <mappages>
    80001aac:	89aa                	mv	s3,a0
    80001aae:	fd49                	bnez	a0,80001a48 <uvmshare+0x44>
    if (pa != 0)
    80001ab0:	d0f1                	beqz	s1,80001a74 <uvmshare+0x70>
      add_page_reference((uint64)pa);
    80001ab2:	8526                	mv	a0,s1
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	f98080e7          	jalr	-104(ra) # 80000a4c <add_page_reference>
    80001abc:	bf65                	j	80001a74 <uvmshare+0x70>
    80001abe:	74e2                	ld	s1,56(sp)
    80001ac0:	7942                	ld	s2,48(sp)
    80001ac2:	7a02                	ld	s4,32(sp)
    80001ac4:	6ae2                	ld	s5,24(sp)
    80001ac6:	6b42                	ld	s6,16(sp)
    80001ac8:	6ba2                	ld	s7,8(sp)
    80001aca:	bf79                	j	80001a68 <uvmshare+0x64>
  return 0;
    80001acc:	4981                	li	s3,0
    80001ace:	bf69                	j	80001a68 <uvmshare+0x64>

0000000080001ad0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001ad0:	1141                	addi	sp,sp,-16
    80001ad2:	e406                	sd	ra,8(sp)
    80001ad4:	e022                	sd	s0,0(sp)
    80001ad6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001ad8:	4601                	li	a2,0
    80001ada:	fffff097          	auipc	ra,0xfffff
    80001ade:	648080e7          	jalr	1608(ra) # 80001122 <walk>
  if(pte == 0)
    80001ae2:	c901                	beqz	a0,80001af2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001ae4:	611c                	ld	a5,0(a0)
    80001ae6:	9bbd                	andi	a5,a5,-17
    80001ae8:	e11c                	sd	a5,0(a0)
}
    80001aea:	60a2                	ld	ra,8(sp)
    80001aec:	6402                	ld	s0,0(sp)
    80001aee:	0141                	addi	sp,sp,16
    80001af0:	8082                	ret
    panic("uvmclear");
    80001af2:	00008517          	auipc	a0,0x8
    80001af6:	70650513          	addi	a0,a0,1798 # 8000a1f8 <etext+0x1f8>
    80001afa:	fffff097          	auipc	ra,0xfffff
    80001afe:	a66080e7          	jalr	-1434(ra) # 80000560 <panic>

0000000080001b02 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001b02:	c6bd                	beqz	a3,80001b70 <copyout+0x6e>
{
    80001b04:	715d                	addi	sp,sp,-80
    80001b06:	e486                	sd	ra,72(sp)
    80001b08:	e0a2                	sd	s0,64(sp)
    80001b0a:	fc26                	sd	s1,56(sp)
    80001b0c:	f84a                	sd	s2,48(sp)
    80001b0e:	f44e                	sd	s3,40(sp)
    80001b10:	f052                	sd	s4,32(sp)
    80001b12:	ec56                	sd	s5,24(sp)
    80001b14:	e85a                	sd	s6,16(sp)
    80001b16:	e45e                	sd	s7,8(sp)
    80001b18:	e062                	sd	s8,0(sp)
    80001b1a:	0880                	addi	s0,sp,80
    80001b1c:	8b2a                	mv	s6,a0
    80001b1e:	8c2e                	mv	s8,a1
    80001b20:	8a32                	mv	s4,a2
    80001b22:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001b24:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001b26:	6a85                	lui	s5,0x1
    80001b28:	a015                	j	80001b4c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001b2a:	9562                	add	a0,a0,s8
    80001b2c:	0004861b          	sext.w	a2,s1
    80001b30:	85d2                	mv	a1,s4
    80001b32:	41250533          	sub	a0,a0,s2
    80001b36:	fffff097          	auipc	ra,0xfffff
    80001b3a:	33c080e7          	jalr	828(ra) # 80000e72 <memmove>

    len -= n;
    80001b3e:	409989b3          	sub	s3,s3,s1
    src += n;
    80001b42:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001b44:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001b48:	02098263          	beqz	s3,80001b6c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001b4c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001b50:	85ca                	mv	a1,s2
    80001b52:	855a                	mv	a0,s6
    80001b54:	fffff097          	auipc	ra,0xfffff
    80001b58:	674080e7          	jalr	1652(ra) # 800011c8 <walkaddr>
    if(pa0 == 0)
    80001b5c:	cd01                	beqz	a0,80001b74 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001b5e:	418904b3          	sub	s1,s2,s8
    80001b62:	94d6                	add	s1,s1,s5
    if(n > len)
    80001b64:	fc99f3e3          	bgeu	s3,s1,80001b2a <copyout+0x28>
    80001b68:	84ce                	mv	s1,s3
    80001b6a:	b7c1                	j	80001b2a <copyout+0x28>
  }
  return 0;
    80001b6c:	4501                	li	a0,0
    80001b6e:	a021                	j	80001b76 <copyout+0x74>
    80001b70:	4501                	li	a0,0
}
    80001b72:	8082                	ret
      return -1;
    80001b74:	557d                	li	a0,-1
}
    80001b76:	60a6                	ld	ra,72(sp)
    80001b78:	6406                	ld	s0,64(sp)
    80001b7a:	74e2                	ld	s1,56(sp)
    80001b7c:	7942                	ld	s2,48(sp)
    80001b7e:	79a2                	ld	s3,40(sp)
    80001b80:	7a02                	ld	s4,32(sp)
    80001b82:	6ae2                	ld	s5,24(sp)
    80001b84:	6b42                	ld	s6,16(sp)
    80001b86:	6ba2                	ld	s7,8(sp)
    80001b88:	6c02                	ld	s8,0(sp)
    80001b8a:	6161                	addi	sp,sp,80
    80001b8c:	8082                	ret

0000000080001b8e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001b8e:	caa5                	beqz	a3,80001bfe <copyin+0x70>
{
    80001b90:	715d                	addi	sp,sp,-80
    80001b92:	e486                	sd	ra,72(sp)
    80001b94:	e0a2                	sd	s0,64(sp)
    80001b96:	fc26                	sd	s1,56(sp)
    80001b98:	f84a                	sd	s2,48(sp)
    80001b9a:	f44e                	sd	s3,40(sp)
    80001b9c:	f052                	sd	s4,32(sp)
    80001b9e:	ec56                	sd	s5,24(sp)
    80001ba0:	e85a                	sd	s6,16(sp)
    80001ba2:	e45e                	sd	s7,8(sp)
    80001ba4:	e062                	sd	s8,0(sp)
    80001ba6:	0880                	addi	s0,sp,80
    80001ba8:	8b2a                	mv	s6,a0
    80001baa:	8a2e                	mv	s4,a1
    80001bac:	8c32                	mv	s8,a2
    80001bae:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001bb0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001bb2:	6a85                	lui	s5,0x1
    80001bb4:	a01d                	j	80001bda <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001bb6:	018505b3          	add	a1,a0,s8
    80001bba:	0004861b          	sext.w	a2,s1
    80001bbe:	412585b3          	sub	a1,a1,s2
    80001bc2:	8552                	mv	a0,s4
    80001bc4:	fffff097          	auipc	ra,0xfffff
    80001bc8:	2ae080e7          	jalr	686(ra) # 80000e72 <memmove>

    len -= n;
    80001bcc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001bd0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001bd2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001bd6:	02098263          	beqz	s3,80001bfa <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001bda:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001bde:	85ca                	mv	a1,s2
    80001be0:	855a                	mv	a0,s6
    80001be2:	fffff097          	auipc	ra,0xfffff
    80001be6:	5e6080e7          	jalr	1510(ra) # 800011c8 <walkaddr>
    if(pa0 == 0)
    80001bea:	cd01                	beqz	a0,80001c02 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001bec:	418904b3          	sub	s1,s2,s8
    80001bf0:	94d6                	add	s1,s1,s5
    if(n > len)
    80001bf2:	fc99f2e3          	bgeu	s3,s1,80001bb6 <copyin+0x28>
    80001bf6:	84ce                	mv	s1,s3
    80001bf8:	bf7d                	j	80001bb6 <copyin+0x28>
  }
  return 0;
    80001bfa:	4501                	li	a0,0
    80001bfc:	a021                	j	80001c04 <copyin+0x76>
    80001bfe:	4501                	li	a0,0
}
    80001c00:	8082                	ret
      return -1;
    80001c02:	557d                	li	a0,-1
}
    80001c04:	60a6                	ld	ra,72(sp)
    80001c06:	6406                	ld	s0,64(sp)
    80001c08:	74e2                	ld	s1,56(sp)
    80001c0a:	7942                	ld	s2,48(sp)
    80001c0c:	79a2                	ld	s3,40(sp)
    80001c0e:	7a02                	ld	s4,32(sp)
    80001c10:	6ae2                	ld	s5,24(sp)
    80001c12:	6b42                	ld	s6,16(sp)
    80001c14:	6ba2                	ld	s7,8(sp)
    80001c16:	6c02                	ld	s8,0(sp)
    80001c18:	6161                	addi	sp,sp,80
    80001c1a:	8082                	ret

0000000080001c1c <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80001c1c:	715d                	addi	sp,sp,-80
    80001c1e:	e486                	sd	ra,72(sp)
    80001c20:	e0a2                	sd	s0,64(sp)
    80001c22:	fc26                	sd	s1,56(sp)
    80001c24:	f84a                	sd	s2,48(sp)
    80001c26:	f44e                	sd	s3,40(sp)
    80001c28:	f052                	sd	s4,32(sp)
    80001c2a:	ec56                	sd	s5,24(sp)
    80001c2c:	e85a                	sd	s6,16(sp)
    80001c2e:	e45e                	sd	s7,8(sp)
    80001c30:	0880                	addi	s0,sp,80
    80001c32:	8aaa                	mv	s5,a0
    80001c34:	89ae                	mv	s3,a1
    80001c36:	8bb2                	mv	s7,a2
    80001c38:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80001c3a:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001c3c:	6a05                	lui	s4,0x1
    80001c3e:	a02d                	j	80001c68 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001c40:	00078023          	sb	zero,0(a5)
    80001c44:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001c46:	0017c793          	xori	a5,a5,1
    80001c4a:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001c4e:	60a6                	ld	ra,72(sp)
    80001c50:	6406                	ld	s0,64(sp)
    80001c52:	74e2                	ld	s1,56(sp)
    80001c54:	7942                	ld	s2,48(sp)
    80001c56:	79a2                	ld	s3,40(sp)
    80001c58:	7a02                	ld	s4,32(sp)
    80001c5a:	6ae2                	ld	s5,24(sp)
    80001c5c:	6b42                	ld	s6,16(sp)
    80001c5e:	6ba2                	ld	s7,8(sp)
    80001c60:	6161                	addi	sp,sp,80
    80001c62:	8082                	ret
    srcva = va0 + PGSIZE;
    80001c64:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001c68:	c8a1                	beqz	s1,80001cb8 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80001c6a:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001c6e:	85ca                	mv	a1,s2
    80001c70:	8556                	mv	a0,s5
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	556080e7          	jalr	1366(ra) # 800011c8 <walkaddr>
    if(pa0 == 0)
    80001c7a:	c129                	beqz	a0,80001cbc <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80001c7c:	41790633          	sub	a2,s2,s7
    80001c80:	9652                	add	a2,a2,s4
    if(n > max)
    80001c82:	00c4f363          	bgeu	s1,a2,80001c88 <copyinstr+0x6c>
    80001c86:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001c88:	412b8bb3          	sub	s7,s7,s2
    80001c8c:	9baa                	add	s7,s7,a0
    while(n > 0){
    80001c8e:	da79                	beqz	a2,80001c64 <copyinstr+0x48>
    80001c90:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80001c92:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80001c96:	964e                	add	a2,a2,s3
    80001c98:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001c9a:	00f68733          	add	a4,a3,a5
    80001c9e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff8e5f4>
    80001ca2:	df59                	beqz	a4,80001c40 <copyinstr+0x24>
        *dst = *p;
    80001ca4:	00e78023          	sb	a4,0(a5)
      dst++;
    80001ca8:	0785                	addi	a5,a5,1
    while(n > 0){
    80001caa:	fec797e3          	bne	a5,a2,80001c98 <copyinstr+0x7c>
    80001cae:	14fd                	addi	s1,s1,-1
    80001cb0:	94ce                	add	s1,s1,s3
      --max;
    80001cb2:	8c8d                	sub	s1,s1,a1
    80001cb4:	89be                	mv	s3,a5
    80001cb6:	b77d                	j	80001c64 <copyinstr+0x48>
    80001cb8:	4781                	li	a5,0
    80001cba:	b771                	j	80001c46 <copyinstr+0x2a>
      return -1;
    80001cbc:	557d                	li	a0,-1
    80001cbe:	bf41                	j	80001c4e <copyinstr+0x32>

0000000080001cc0 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001cc0:	715d                	addi	sp,sp,-80
    80001cc2:	e486                	sd	ra,72(sp)
    80001cc4:	e0a2                	sd	s0,64(sp)
    80001cc6:	fc26                	sd	s1,56(sp)
    80001cc8:	f84a                	sd	s2,48(sp)
    80001cca:	f44e                	sd	s3,40(sp)
    80001ccc:	f052                	sd	s4,32(sp)
    80001cce:	ec56                	sd	s5,24(sp)
    80001cd0:	e85a                	sd	s6,16(sp)
    80001cd2:	e45e                	sd	s7,8(sp)
    80001cd4:	e062                	sd	s8,0(sp)
    80001cd6:	0880                	addi	s0,sp,80
    80001cd8:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cda:	00055497          	auipc	s1,0x55
    80001cde:	cc648493          	addi	s1,s1,-826 # 800569a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001ce2:	8c26                	mv	s8,s1
    80001ce4:	586fb7b7          	lui	a5,0x586fb
    80001ce8:	58778793          	addi	a5,a5,1415 # 586fb587 <_entry-0x27904a79>
    80001cec:	6fb58937          	lui	s2,0x6fb58
    80001cf0:	6fb90913          	addi	s2,s2,1787 # 6fb586fb <_entry-0x104a7905>
    80001cf4:	1902                	slli	s2,s2,0x20
    80001cf6:	993e                	add	s2,s2,a5
    80001cf8:	040009b7          	lui	s3,0x4000
    80001cfc:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001cfe:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001d00:	4b99                	li	s7,6
    80001d02:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d04:	00063a97          	auipc	s5,0x63
    80001d08:	89ca8a93          	addi	s5,s5,-1892 # 800645a0 <tickslock>
    char *pa = kalloc();
    80001d0c:	fffff097          	auipc	ra,0xfffff
    80001d10:	ef8080e7          	jalr	-264(ra) # 80000c04 <kalloc>
    80001d14:	862a                	mv	a2,a0
    if(pa == 0)
    80001d16:	c131                	beqz	a0,80001d5a <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80001d18:	418485b3          	sub	a1,s1,s8
    80001d1c:	8591                	srai	a1,a1,0x4
    80001d1e:	032585b3          	mul	a1,a1,s2
    80001d22:	2585                	addiw	a1,a1,1
    80001d24:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001d28:	875e                	mv	a4,s7
    80001d2a:	86da                	mv	a3,s6
    80001d2c:	40b985b3          	sub	a1,s3,a1
    80001d30:	8552                	mv	a0,s4
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	57e080e7          	jalr	1406(ra) # 800012b0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d3a:	37048493          	addi	s1,s1,880
    80001d3e:	fd5497e3          	bne	s1,s5,80001d0c <proc_mapstacks+0x4c>
  }
}
    80001d42:	60a6                	ld	ra,72(sp)
    80001d44:	6406                	ld	s0,64(sp)
    80001d46:	74e2                	ld	s1,56(sp)
    80001d48:	7942                	ld	s2,48(sp)
    80001d4a:	79a2                	ld	s3,40(sp)
    80001d4c:	7a02                	ld	s4,32(sp)
    80001d4e:	6ae2                	ld	s5,24(sp)
    80001d50:	6b42                	ld	s6,16(sp)
    80001d52:	6ba2                	ld	s7,8(sp)
    80001d54:	6c02                	ld	s8,0(sp)
    80001d56:	6161                	addi	sp,sp,80
    80001d58:	8082                	ret
      panic("kalloc");
    80001d5a:	00008517          	auipc	a0,0x8
    80001d5e:	4ae50513          	addi	a0,a0,1198 # 8000a208 <etext+0x208>
    80001d62:	ffffe097          	auipc	ra,0xffffe
    80001d66:	7fe080e7          	jalr	2046(ra) # 80000560 <panic>

0000000080001d6a <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001d6a:	7139                	addi	sp,sp,-64
    80001d6c:	fc06                	sd	ra,56(sp)
    80001d6e:	f822                	sd	s0,48(sp)
    80001d70:	f426                	sd	s1,40(sp)
    80001d72:	f04a                	sd	s2,32(sp)
    80001d74:	ec4e                	sd	s3,24(sp)
    80001d76:	e852                	sd	s4,16(sp)
    80001d78:	e456                	sd	s5,8(sp)
    80001d7a:	e05a                	sd	s6,0(sp)
    80001d7c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001d7e:	00008597          	auipc	a1,0x8
    80001d82:	49258593          	addi	a1,a1,1170 # 8000a210 <etext+0x210>
    80001d86:	00054517          	auipc	a0,0x54
    80001d8a:	7ea50513          	addi	a0,a0,2026 # 80056570 <pid_lock>
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	ef4080e7          	jalr	-268(ra) # 80000c82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001d96:	00008597          	auipc	a1,0x8
    80001d9a:	48258593          	addi	a1,a1,1154 # 8000a218 <etext+0x218>
    80001d9e:	00054517          	auipc	a0,0x54
    80001da2:	7ea50513          	addi	a0,a0,2026 # 80056588 <wait_lock>
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	edc080e7          	jalr	-292(ra) # 80000c82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001dae:	00055497          	auipc	s1,0x55
    80001db2:	bf248493          	addi	s1,s1,-1038 # 800569a0 <proc>
      initlock(&p->lock, "proc");
    80001db6:	00008b17          	auipc	s6,0x8
    80001dba:	472b0b13          	addi	s6,s6,1138 # 8000a228 <etext+0x228>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001dbe:	8aa6                	mv	s5,s1
    80001dc0:	586fb7b7          	lui	a5,0x586fb
    80001dc4:	58778793          	addi	a5,a5,1415 # 586fb587 <_entry-0x27904a79>
    80001dc8:	6fb58937          	lui	s2,0x6fb58
    80001dcc:	6fb90913          	addi	s2,s2,1787 # 6fb586fb <_entry-0x104a7905>
    80001dd0:	1902                	slli	s2,s2,0x20
    80001dd2:	993e                	add	s2,s2,a5
    80001dd4:	040009b7          	lui	s3,0x4000
    80001dd8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001dda:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ddc:	00062a17          	auipc	s4,0x62
    80001de0:	7c4a0a13          	addi	s4,s4,1988 # 800645a0 <tickslock>
      initlock(&p->lock, "proc");
    80001de4:	85da                	mv	a1,s6
    80001de6:	8526                	mv	a0,s1
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	e9a080e7          	jalr	-358(ra) # 80000c82 <initlock>
      p->state = UNUSED;
    80001df0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001df4:	415487b3          	sub	a5,s1,s5
    80001df8:	8791                	srai	a5,a5,0x4
    80001dfa:	032787b3          	mul	a5,a5,s2
    80001dfe:	2785                	addiw	a5,a5,1
    80001e00:	00d7979b          	slliw	a5,a5,0xd
    80001e04:	40f987b3          	sub	a5,s3,a5
    80001e08:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e0a:	37048493          	addi	s1,s1,880
    80001e0e:	fd449be3          	bne	s1,s4,80001de4 <procinit+0x7a>
  }
}
    80001e12:	70e2                	ld	ra,56(sp)
    80001e14:	7442                	ld	s0,48(sp)
    80001e16:	74a2                	ld	s1,40(sp)
    80001e18:	7902                	ld	s2,32(sp)
    80001e1a:	69e2                	ld	s3,24(sp)
    80001e1c:	6a42                	ld	s4,16(sp)
    80001e1e:	6aa2                	ld	s5,8(sp)
    80001e20:	6b02                	ld	s6,0(sp)
    80001e22:	6121                	addi	sp,sp,64
    80001e24:	8082                	ret

0000000080001e26 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001e26:	1141                	addi	sp,sp,-16
    80001e28:	e406                	sd	ra,8(sp)
    80001e2a:	e022                	sd	s0,0(sp)
    80001e2c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e2e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001e30:	2501                	sext.w	a0,a0
    80001e32:	60a2                	ld	ra,8(sp)
    80001e34:	6402                	ld	s0,0(sp)
    80001e36:	0141                	addi	sp,sp,16
    80001e38:	8082                	ret

0000000080001e3a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001e3a:	1141                	addi	sp,sp,-16
    80001e3c:	e406                	sd	ra,8(sp)
    80001e3e:	e022                	sd	s0,0(sp)
    80001e40:	0800                	addi	s0,sp,16
    80001e42:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001e44:	2781                	sext.w	a5,a5
    80001e46:	079e                	slli	a5,a5,0x7
  return c;
}
    80001e48:	00054517          	auipc	a0,0x54
    80001e4c:	75850513          	addi	a0,a0,1880 # 800565a0 <cpus>
    80001e50:	953e                	add	a0,a0,a5
    80001e52:	60a2                	ld	ra,8(sp)
    80001e54:	6402                	ld	s0,0(sp)
    80001e56:	0141                	addi	sp,sp,16
    80001e58:	8082                	ret

0000000080001e5a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001e5a:	1101                	addi	sp,sp,-32
    80001e5c:	ec06                	sd	ra,24(sp)
    80001e5e:	e822                	sd	s0,16(sp)
    80001e60:	e426                	sd	s1,8(sp)
    80001e62:	1000                	addi	s0,sp,32
  push_off();
    80001e64:	fffff097          	auipc	ra,0xfffff
    80001e68:	e66080e7          	jalr	-410(ra) # 80000cca <push_off>
    80001e6c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001e6e:	2781                	sext.w	a5,a5
    80001e70:	079e                	slli	a5,a5,0x7
    80001e72:	00054717          	auipc	a4,0x54
    80001e76:	6fe70713          	addi	a4,a4,1790 # 80056570 <pid_lock>
    80001e7a:	97ba                	add	a5,a5,a4
    80001e7c:	7b84                	ld	s1,48(a5)
  pop_off();
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	eec080e7          	jalr	-276(ra) # 80000d6a <pop_off>
  return p;
}
    80001e86:	8526                	mv	a0,s1
    80001e88:	60e2                	ld	ra,24(sp)
    80001e8a:	6442                	ld	s0,16(sp)
    80001e8c:	64a2                	ld	s1,8(sp)
    80001e8e:	6105                	addi	sp,sp,32
    80001e90:	8082                	ret

0000000080001e92 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001e92:	1141                	addi	sp,sp,-16
    80001e94:	e406                	sd	ra,8(sp)
    80001e96:	e022                	sd	s0,0(sp)
    80001e98:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001e9a:	00000097          	auipc	ra,0x0
    80001e9e:	fc0080e7          	jalr	-64(ra) # 80001e5a <myproc>
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	f24080e7          	jalr	-220(ra) # 80000dc6 <release>

  if (first) {
    80001eaa:	0000c797          	auipc	a5,0xc
    80001eae:	3c67a783          	lw	a5,966(a5) # 8000e270 <first.1>
    80001eb2:	eb89                	bnez	a5,80001ec4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001eb4:	00001097          	auipc	ra,0x1
    80001eb8:	144080e7          	jalr	324(ra) # 80002ff8 <usertrapret>
}
    80001ebc:	60a2                	ld	ra,8(sp)
    80001ebe:	6402                	ld	s0,0(sp)
    80001ec0:	0141                	addi	sp,sp,16
    80001ec2:	8082                	ret
    first = 0;
    80001ec4:	0000c797          	auipc	a5,0xc
    80001ec8:	3a07a623          	sw	zero,940(a5) # 8000e270 <first.1>
    fsinit(ROOTDEV);
    80001ecc:	4505                	li	a0,1
    80001ece:	00002097          	auipc	ra,0x2
    80001ed2:	0ee080e7          	jalr	238(ra) # 80003fbc <fsinit>
    80001ed6:	bff9                	j	80001eb4 <forkret+0x22>

0000000080001ed8 <allocpid>:
{
    80001ed8:	1101                	addi	sp,sp,-32
    80001eda:	ec06                	sd	ra,24(sp)
    80001edc:	e822                	sd	s0,16(sp)
    80001ede:	e426                	sd	s1,8(sp)
    80001ee0:	e04a                	sd	s2,0(sp)
    80001ee2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001ee4:	00054917          	auipc	s2,0x54
    80001ee8:	68c90913          	addi	s2,s2,1676 # 80056570 <pid_lock>
    80001eec:	854a                	mv	a0,s2
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	e28080e7          	jalr	-472(ra) # 80000d16 <acquire>
  pid = nextpid;
    80001ef6:	0000c797          	auipc	a5,0xc
    80001efa:	37e78793          	addi	a5,a5,894 # 8000e274 <nextpid>
    80001efe:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001f00:	0014871b          	addiw	a4,s1,1
    80001f04:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001f06:	854a                	mv	a0,s2
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	ebe080e7          	jalr	-322(ra) # 80000dc6 <release>
}
    80001f10:	8526                	mv	a0,s1
    80001f12:	60e2                	ld	ra,24(sp)
    80001f14:	6442                	ld	s0,16(sp)
    80001f16:	64a2                	ld	s1,8(sp)
    80001f18:	6902                	ld	s2,0(sp)
    80001f1a:	6105                	addi	sp,sp,32
    80001f1c:	8082                	ret

0000000080001f1e <proc_pagetable>:
{
    80001f1e:	1101                	addi	sp,sp,-32
    80001f20:	ec06                	sd	ra,24(sp)
    80001f22:	e822                	sd	s0,16(sp)
    80001f24:	e426                	sd	s1,8(sp)
    80001f26:	e04a                	sd	s2,0(sp)
    80001f28:	1000                	addi	s0,sp,32
    80001f2a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	58c080e7          	jalr	1420(ra) # 800014b8 <uvmcreate>
    80001f34:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001f36:	c121                	beqz	a0,80001f76 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001f38:	4729                	li	a4,10
    80001f3a:	00007697          	auipc	a3,0x7
    80001f3e:	0c668693          	addi	a3,a3,198 # 80009000 <_trampoline>
    80001f42:	6605                	lui	a2,0x1
    80001f44:	040005b7          	lui	a1,0x4000
    80001f48:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f4a:	05b2                	slli	a1,a1,0xc
    80001f4c:	fffff097          	auipc	ra,0xfffff
    80001f50:	2be080e7          	jalr	702(ra) # 8000120a <mappages>
    80001f54:	02054863          	bltz	a0,80001f84 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001f58:	4719                	li	a4,6
    80001f5a:	05893683          	ld	a3,88(s2)
    80001f5e:	6605                	lui	a2,0x1
    80001f60:	020005b7          	lui	a1,0x2000
    80001f64:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001f66:	05b6                	slli	a1,a1,0xd
    80001f68:	8526                	mv	a0,s1
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	2a0080e7          	jalr	672(ra) # 8000120a <mappages>
    80001f72:	02054163          	bltz	a0,80001f94 <proc_pagetable+0x76>
}
    80001f76:	8526                	mv	a0,s1
    80001f78:	60e2                	ld	ra,24(sp)
    80001f7a:	6442                	ld	s0,16(sp)
    80001f7c:	64a2                	ld	s1,8(sp)
    80001f7e:	6902                	ld	s2,0(sp)
    80001f80:	6105                	addi	sp,sp,32
    80001f82:	8082                	ret
    uvmfree(pagetable, 0);
    80001f84:	4581                	li	a1,0
    80001f86:	8526                	mv	a0,s1
    80001f88:	00000097          	auipc	ra,0x0
    80001f8c:	96c080e7          	jalr	-1684(ra) # 800018f4 <uvmfree>
    return 0;
    80001f90:	4481                	li	s1,0
    80001f92:	b7d5                	j	80001f76 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f94:	4681                	li	a3,0
    80001f96:	4605                	li	a2,1
    80001f98:	040005b7          	lui	a1,0x4000
    80001f9c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f9e:	05b2                	slli	a1,a1,0xc
    80001fa0:	8526                	mv	a0,s1
    80001fa2:	fffff097          	auipc	ra,0xfffff
    80001fa6:	442080e7          	jalr	1090(ra) # 800013e4 <uvmunmap>
    uvmfree(pagetable, 0);
    80001faa:	4581                	li	a1,0
    80001fac:	8526                	mv	a0,s1
    80001fae:	00000097          	auipc	ra,0x0
    80001fb2:	946080e7          	jalr	-1722(ra) # 800018f4 <uvmfree>
    return 0;
    80001fb6:	4481                	li	s1,0
    80001fb8:	bf7d                	j	80001f76 <proc_pagetable+0x58>

0000000080001fba <proc_freepagetable>:
{
    80001fba:	1101                	addi	sp,sp,-32
    80001fbc:	ec06                	sd	ra,24(sp)
    80001fbe:	e822                	sd	s0,16(sp)
    80001fc0:	e426                	sd	s1,8(sp)
    80001fc2:	e04a                	sd	s2,0(sp)
    80001fc4:	1000                	addi	s0,sp,32
    80001fc6:	84aa                	mv	s1,a0
    80001fc8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001fca:	4681                	li	a3,0
    80001fcc:	4605                	li	a2,1
    80001fce:	040005b7          	lui	a1,0x4000
    80001fd2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001fd4:	05b2                	slli	a1,a1,0xc
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	40e080e7          	jalr	1038(ra) # 800013e4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001fde:	4681                	li	a3,0
    80001fe0:	4605                	li	a2,1
    80001fe2:	020005b7          	lui	a1,0x2000
    80001fe6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001fe8:	05b6                	slli	a1,a1,0xd
    80001fea:	8526                	mv	a0,s1
    80001fec:	fffff097          	auipc	ra,0xfffff
    80001ff0:	3f8080e7          	jalr	1016(ra) # 800013e4 <uvmunmap>
  uvmfree(pagetable, sz);
    80001ff4:	85ca                	mv	a1,s2
    80001ff6:	8526                	mv	a0,s1
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	8fc080e7          	jalr	-1796(ra) # 800018f4 <uvmfree>
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6902                	ld	s2,0(sp)
    80002008:	6105                	addi	sp,sp,32
    8000200a:	8082                	ret

000000008000200c <freeproc>:
{
    8000200c:	1101                	addi	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	e426                	sd	s1,8(sp)
    80002014:	1000                	addi	s0,sp,32
    80002016:	84aa                	mv	s1,a0
  if(p->trapframe)
    80002018:	6d28                	ld	a0,88(a0)
    8000201a:	c509                	beqz	a0,80002024 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	a80080e7          	jalr	-1408(ra) # 80000a9c <kfree>
  p->trapframe = 0;
    80002024:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80002028:	68a8                	ld	a0,80(s1)
    8000202a:	c511                	beqz	a0,80002036 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000202c:	64ac                	ld	a1,72(s1)
    8000202e:	00000097          	auipc	ra,0x0
    80002032:	f8c080e7          	jalr	-116(ra) # 80001fba <proc_freepagetable>
  p->pagetable = 0;
    80002036:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000203a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000203e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80002042:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80002046:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000204a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000204e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80002052:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80002056:	0004ac23          	sw	zero,24(s1)
}
    8000205a:	60e2                	ld	ra,24(sp)
    8000205c:	6442                	ld	s0,16(sp)
    8000205e:	64a2                	ld	s1,8(sp)
    80002060:	6105                	addi	sp,sp,32
    80002062:	8082                	ret

0000000080002064 <allocproc>:
{
    80002064:	1101                	addi	sp,sp,-32
    80002066:	ec06                	sd	ra,24(sp)
    80002068:	e822                	sd	s0,16(sp)
    8000206a:	e426                	sd	s1,8(sp)
    8000206c:	e04a                	sd	s2,0(sp)
    8000206e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80002070:	00055497          	auipc	s1,0x55
    80002074:	93048493          	addi	s1,s1,-1744 # 800569a0 <proc>
    80002078:	00062917          	auipc	s2,0x62
    8000207c:	52890913          	addi	s2,s2,1320 # 800645a0 <tickslock>
    acquire(&p->lock);
    80002080:	8526                	mv	a0,s1
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	c94080e7          	jalr	-876(ra) # 80000d16 <acquire>
    if(p->state == UNUSED) {
    8000208a:	4c9c                	lw	a5,24(s1)
    8000208c:	cf81                	beqz	a5,800020a4 <allocproc+0x40>
      release(&p->lock);
    8000208e:	8526                	mv	a0,s1
    80002090:	fffff097          	auipc	ra,0xfffff
    80002094:	d36080e7          	jalr	-714(ra) # 80000dc6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002098:	37048493          	addi	s1,s1,880
    8000209c:	ff2492e3          	bne	s1,s2,80002080 <allocproc+0x1c>
  return 0;
    800020a0:	4481                	li	s1,0
    800020a2:	a095                	j	80002106 <allocproc+0xa2>
  p->pid = allocpid();
    800020a4:	00000097          	auipc	ra,0x0
    800020a8:	e34080e7          	jalr	-460(ra) # 80001ed8 <allocpid>
    800020ac:	d888                	sw	a0,48(s1)
  p->state = USED;
    800020ae:	4785                	li	a5,1
    800020b0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	b52080e7          	jalr	-1198(ra) # 80000c04 <kalloc>
    800020ba:	892a                	mv	s2,a0
    800020bc:	eca8                	sd	a0,88(s1)
    800020be:	c939                	beqz	a0,80002114 <allocproc+0xb0>
  p->pagetable = proc_pagetable(p);
    800020c0:	8526                	mv	a0,s1
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	e5c080e7          	jalr	-420(ra) # 80001f1e <proc_pagetable>
    800020ca:	892a                	mv	s2,a0
    800020cc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800020ce:	cd39                	beqz	a0,8000212c <allocproc+0xc8>
  memset(&p->context, 0, sizeof(p->context));
    800020d0:	07000613          	li	a2,112
    800020d4:	4581                	li	a1,0
    800020d6:	06048513          	addi	a0,s1,96
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	d34080e7          	jalr	-716(ra) # 80000e0e <memset>
  p->context.ra = (uint64)forkret;
    800020e2:	00000797          	auipc	a5,0x0
    800020e6:	db078793          	addi	a5,a5,-592 # 80001e92 <forkret>
    800020ea:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800020ec:	60bc                	ld	a5,64(s1)
    800020ee:	6705                	lui	a4,0x1
    800020f0:	97ba                	add	a5,a5,a4
    800020f2:	f4bc                	sd	a5,104(s1)
  memset(p->infant_threads, 0, MAX_THREADS);
    800020f4:	04000613          	li	a2,64
    800020f8:	4581                	li	a1,0
    800020fa:	17048513          	addi	a0,s1,368
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	d10080e7          	jalr	-752(ra) # 80000e0e <memset>
}
    80002106:	8526                	mv	a0,s1
    80002108:	60e2                	ld	ra,24(sp)
    8000210a:	6442                	ld	s0,16(sp)
    8000210c:	64a2                	ld	s1,8(sp)
    8000210e:	6902                	ld	s2,0(sp)
    80002110:	6105                	addi	sp,sp,32
    80002112:	8082                	ret
    freeproc(p);
    80002114:	8526                	mv	a0,s1
    80002116:	00000097          	auipc	ra,0x0
    8000211a:	ef6080e7          	jalr	-266(ra) # 8000200c <freeproc>
    release(&p->lock);
    8000211e:	8526                	mv	a0,s1
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	ca6080e7          	jalr	-858(ra) # 80000dc6 <release>
    return 0;
    80002128:	84ca                	mv	s1,s2
    8000212a:	bff1                	j	80002106 <allocproc+0xa2>
    freeproc(p);
    8000212c:	8526                	mv	a0,s1
    8000212e:	00000097          	auipc	ra,0x0
    80002132:	ede080e7          	jalr	-290(ra) # 8000200c <freeproc>
    release(&p->lock);
    80002136:	8526                	mv	a0,s1
    80002138:	fffff097          	auipc	ra,0xfffff
    8000213c:	c8e080e7          	jalr	-882(ra) # 80000dc6 <release>
    return 0;
    80002140:	84ca                	mv	s1,s2
    80002142:	b7d1                	j	80002106 <allocproc+0xa2>

0000000080002144 <userinit>:
{
    80002144:	1101                	addi	sp,sp,-32
    80002146:	ec06                	sd	ra,24(sp)
    80002148:	e822                	sd	s0,16(sp)
    8000214a:	e426                	sd	s1,8(sp)
    8000214c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	f16080e7          	jalr	-234(ra) # 80002064 <allocproc>
    80002156:	84aa                	mv	s1,a0
  initproc = p;
    80002158:	0000c797          	auipc	a5,0xc
    8000215c:	18a7b823          	sd	a0,400(a5) # 8000e2e8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002160:	03400613          	li	a2,52
    80002164:	0000c597          	auipc	a1,0xc
    80002168:	11c58593          	addi	a1,a1,284 # 8000e280 <initcode>
    8000216c:	6928                	ld	a0,80(a0)
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	378080e7          	jalr	888(ra) # 800014e6 <uvmfirst>
  p->sz = PGSIZE;
    80002176:	6785                	lui	a5,0x1
    80002178:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000217a:	6cb8                	ld	a4,88(s1)
    8000217c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002180:	6cb8                	ld	a4,88(s1)
    80002182:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002184:	4641                	li	a2,16
    80002186:	00008597          	auipc	a1,0x8
    8000218a:	0aa58593          	addi	a1,a1,170 # 8000a230 <etext+0x230>
    8000218e:	15848513          	addi	a0,s1,344
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	dd2080e7          	jalr	-558(ra) # 80000f64 <safestrcpy>
  p->cwd = namei("/");
    8000219a:	00008517          	auipc	a0,0x8
    8000219e:	0a650513          	addi	a0,a0,166 # 8000a240 <etext+0x240>
    800021a2:	00003097          	auipc	ra,0x3
    800021a6:	882080e7          	jalr	-1918(ra) # 80004a24 <namei>
    800021aa:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800021ae:	478d                	li	a5,3
    800021b0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800021b2:	8526                	mv	a0,s1
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	c12080e7          	jalr	-1006(ra) # 80000dc6 <release>
}
    800021bc:	60e2                	ld	ra,24(sp)
    800021be:	6442                	ld	s0,16(sp)
    800021c0:	64a2                	ld	s1,8(sp)
    800021c2:	6105                	addi	sp,sp,32
    800021c4:	8082                	ret

00000000800021c6 <growproc>:
{
    800021c6:	1101                	addi	sp,sp,-32
    800021c8:	ec06                	sd	ra,24(sp)
    800021ca:	e822                	sd	s0,16(sp)
    800021cc:	e426                	sd	s1,8(sp)
    800021ce:	e04a                	sd	s2,0(sp)
    800021d0:	1000                	addi	s0,sp,32
    800021d2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800021d4:	00000097          	auipc	ra,0x0
    800021d8:	c86080e7          	jalr	-890(ra) # 80001e5a <myproc>
    800021dc:	84aa                	mv	s1,a0
  sz = p->sz;
    800021de:	652c                	ld	a1,72(a0)
  if(n > 0){
    800021e0:	05205463          	blez	s2,80002228 <growproc+0x62>
    if (p->is_thread == 1) {
    800021e4:	16852703          	lw	a4,360(a0)
    800021e8:	4785                	li	a5,1
    800021ea:	02f70463          	beq	a4,a5,80002212 <growproc+0x4c>
    } else if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800021ee:	4691                	li	a3,4
    800021f0:	00b90633          	add	a2,s2,a1
    800021f4:	6928                	ld	a0,80(a0)
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	3aa080e7          	jalr	938(ra) # 800015a0 <uvmalloc>
    800021fe:	85aa                	mv	a1,a0
    80002200:	cd21                	beqz	a0,80002258 <growproc+0x92>
  p->sz = sz;
    80002202:	e4ac                	sd	a1,72(s1)
  return 0;
    80002204:	4501                	li	a0,0
}
    80002206:	60e2                	ld	ra,24(sp)
    80002208:	6442                	ld	s0,16(sp)
    8000220a:	64a2                	ld	s1,8(sp)
    8000220c:	6902                	ld	s2,0(sp)
    8000220e:	6105                	addi	sp,sp,32
    80002210:	8082                	ret
      if ((sz = uvmthreaded_alloc(p, sz, sz + n, PTE_W)) == 0) {
    80002212:	4691                	li	a3,4
    80002214:	00b90633          	add	a2,s2,a1
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	44e080e7          	jalr	1102(ra) # 80001666 <uvmthreaded_alloc>
    80002220:	85aa                	mv	a1,a0
    80002222:	f165                	bnez	a0,80002202 <growproc+0x3c>
        return -1;
    80002224:	557d                	li	a0,-1
    80002226:	b7c5                	j	80002206 <growproc+0x40>
  } else if(n < 0){
    80002228:	fc095de3          	bgez	s2,80002202 <growproc+0x3c>
    if (p->is_thread == 1)
    8000222c:	16852703          	lw	a4,360(a0)
    80002230:	4785                	li	a5,1
    80002232:	00f70b63          	beq	a4,a5,80002248 <growproc+0x82>
      sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002236:	00b90633          	add	a2,s2,a1
    8000223a:	6928                	ld	a0,80(a0)
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	31c080e7          	jalr	796(ra) # 80001558 <uvmdealloc>
    80002244:	85aa                	mv	a1,a0
    80002246:	bf75                	j	80002202 <growproc+0x3c>
      sz = uvmthreaded_dealloc(p, sz, sz + n);
    80002248:	00b90633          	add	a2,s2,a1
    8000224c:	fffff097          	auipc	ra,0xfffff
    80002250:	596080e7          	jalr	1430(ra) # 800017e2 <uvmthreaded_dealloc>
    80002254:	85aa                	mv	a1,a0
    80002256:	b775                	j	80002202 <growproc+0x3c>
      return -1;
    80002258:	557d                	li	a0,-1
    8000225a:	b775                	j	80002206 <growproc+0x40>

000000008000225c <fork>:
{
    8000225c:	7139                	addi	sp,sp,-64
    8000225e:	fc06                	sd	ra,56(sp)
    80002260:	f822                	sd	s0,48(sp)
    80002262:	f04a                	sd	s2,32(sp)
    80002264:	e456                	sd	s5,8(sp)
    80002266:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002268:	00000097          	auipc	ra,0x0
    8000226c:	bf2080e7          	jalr	-1038(ra) # 80001e5a <myproc>
    80002270:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80002272:	00000097          	auipc	ra,0x0
    80002276:	df2080e7          	jalr	-526(ra) # 80002064 <allocproc>
    8000227a:	12050263          	beqz	a0,8000239e <fork+0x142>
    8000227e:	ec4e                	sd	s3,24(sp)
    80002280:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002282:	048ab603          	ld	a2,72(s5)
    80002286:	692c                	ld	a1,80(a0)
    80002288:	050ab503          	ld	a0,80(s5)
    8000228c:	fffff097          	auipc	ra,0xfffff
    80002290:	6a2080e7          	jalr	1698(ra) # 8000192e <uvmcopy>
    80002294:	04054a63          	bltz	a0,800022e8 <fork+0x8c>
    80002298:	f426                	sd	s1,40(sp)
    8000229a:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    8000229c:	048ab783          	ld	a5,72(s5)
    800022a0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800022a4:	058ab683          	ld	a3,88(s5)
    800022a8:	87b6                	mv	a5,a3
    800022aa:	0589b703          	ld	a4,88(s3)
    800022ae:	12068693          	addi	a3,a3,288
    800022b2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800022b6:	6788                	ld	a0,8(a5)
    800022b8:	6b8c                	ld	a1,16(a5)
    800022ba:	6f90                	ld	a2,24(a5)
    800022bc:	01073023          	sd	a6,0(a4)
    800022c0:	e708                	sd	a0,8(a4)
    800022c2:	eb0c                	sd	a1,16(a4)
    800022c4:	ef10                	sd	a2,24(a4)
    800022c6:	02078793          	addi	a5,a5,32
    800022ca:	02070713          	addi	a4,a4,32
    800022ce:	fed792e3          	bne	a5,a3,800022b2 <fork+0x56>
  np->trapframe->a0 = 0;
    800022d2:	0589b783          	ld	a5,88(s3)
    800022d6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800022da:	0d0a8493          	addi	s1,s5,208
    800022de:	0d098913          	addi	s2,s3,208
    800022e2:	150a8a13          	addi	s4,s5,336
    800022e6:	a015                	j	8000230a <fork+0xae>
    freeproc(np);
    800022e8:	854e                	mv	a0,s3
    800022ea:	00000097          	auipc	ra,0x0
    800022ee:	d22080e7          	jalr	-734(ra) # 8000200c <freeproc>
    release(&np->lock);
    800022f2:	854e                	mv	a0,s3
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	ad2080e7          	jalr	-1326(ra) # 80000dc6 <release>
    return -1;
    800022fc:	597d                	li	s2,-1
    800022fe:	69e2                	ld	s3,24(sp)
    80002300:	a841                	j	80002390 <fork+0x134>
  for(i = 0; i < NOFILE; i++)
    80002302:	04a1                	addi	s1,s1,8
    80002304:	0921                	addi	s2,s2,8
    80002306:	01448b63          	beq	s1,s4,8000231c <fork+0xc0>
    if(p->ofile[i])
    8000230a:	6088                	ld	a0,0(s1)
    8000230c:	d97d                	beqz	a0,80002302 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000230e:	00003097          	auipc	ra,0x3
    80002312:	d9a080e7          	jalr	-614(ra) # 800050a8 <filedup>
    80002316:	00a93023          	sd	a0,0(s2)
    8000231a:	b7e5                	j	80002302 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000231c:	150ab503          	ld	a0,336(s5)
    80002320:	00002097          	auipc	ra,0x2
    80002324:	ee2080e7          	jalr	-286(ra) # 80004202 <idup>
    80002328:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000232c:	4641                	li	a2,16
    8000232e:	158a8593          	addi	a1,s5,344
    80002332:	15898513          	addi	a0,s3,344
    80002336:	fffff097          	auipc	ra,0xfffff
    8000233a:	c2e080e7          	jalr	-978(ra) # 80000f64 <safestrcpy>
  pid = np->pid;
    8000233e:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80002342:	854e                	mv	a0,s3
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	a82080e7          	jalr	-1406(ra) # 80000dc6 <release>
  acquire(&wait_lock);
    8000234c:	00054497          	auipc	s1,0x54
    80002350:	23c48493          	addi	s1,s1,572 # 80056588 <wait_lock>
    80002354:	8526                	mv	a0,s1
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	9c0080e7          	jalr	-1600(ra) # 80000d16 <acquire>
  np->parent = p;
    8000235e:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002362:	8526                	mv	a0,s1
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	a62080e7          	jalr	-1438(ra) # 80000dc6 <release>
  acquire(&np->lock);
    8000236c:	854e                	mv	a0,s3
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	9a8080e7          	jalr	-1624(ra) # 80000d16 <acquire>
  np->state = RUNNABLE;
    80002376:	478d                	li	a5,3
    80002378:	00f9ac23          	sw	a5,24(s3)
  np->is_thread = 0;
    8000237c:	1609a423          	sw	zero,360(s3)
  release(&np->lock);
    80002380:	854e                	mv	a0,s3
    80002382:	fffff097          	auipc	ra,0xfffff
    80002386:	a44080e7          	jalr	-1468(ra) # 80000dc6 <release>
  return pid;
    8000238a:	74a2                	ld	s1,40(sp)
    8000238c:	69e2                	ld	s3,24(sp)
    8000238e:	6a42                	ld	s4,16(sp)
}
    80002390:	854a                	mv	a0,s2
    80002392:	70e2                	ld	ra,56(sp)
    80002394:	7442                	ld	s0,48(sp)
    80002396:	7902                	ld	s2,32(sp)
    80002398:	6aa2                	ld	s5,8(sp)
    8000239a:	6121                	addi	sp,sp,64
    8000239c:	8082                	ret
    return -1;
    8000239e:	597d                	li	s2,-1
    800023a0:	bfc5                	j	80002390 <fork+0x134>

00000000800023a2 <create_thread>:
int create_thread(void* (*fn_addr)(void *), void *args, void *stack_addr, void (*exit_fn)(uint64)) {
    800023a2:	715d                	addi	sp,sp,-80
    800023a4:	e486                	sd	ra,72(sp)
    800023a6:	e0a2                	sd	s0,64(sp)
    800023a8:	fc26                	sd	s1,56(sp)
    800023aa:	f84a                	sd	s2,48(sp)
    800023ac:	f44e                	sd	s3,40(sp)
    800023ae:	f052                	sd	s4,32(sp)
    800023b0:	ec56                	sd	s5,24(sp)
    800023b2:	e85a                	sd	s6,16(sp)
    800023b4:	e45e                	sd	s7,8(sp)
    800023b6:	0880                	addi	s0,sp,80
    800023b8:	8baa                	mv	s7,a0
    800023ba:	8aae                	mv	s5,a1
    800023bc:	84b2                	mv	s1,a2
    800023be:	89b6                	mv	s3,a3
  struct proc *p = myproc();
    800023c0:	00000097          	auipc	ra,0x0
    800023c4:	a9a080e7          	jalr	-1382(ra) # 80001e5a <myproc>
    800023c8:	8b2a                	mv	s6,a0
  for (int i = 0; i < MAX_THREADS; i++) {
    800023ca:	17050713          	addi	a4,a0,368
    800023ce:	4781                	li	a5,0
    800023d0:	04000893          	li	a7,64
    if (p->infant_threads[i] == 0) {
    800023d4:	00073803          	ld	a6,0(a4)
    800023d8:	00080863          	beqz	a6,800023e8 <create_thread+0x46>
  for (int i = 0; i < MAX_THREADS; i++) {
    800023dc:	2785                	addiw	a5,a5,1
    800023de:	0721                	addi	a4,a4,8
    800023e0:	ff179ae3          	bne	a5,a7,800023d4 <create_thread+0x32>
  uint64 thread_idx = 0;
    800023e4:	4901                	li	s2,0
    800023e6:	a011                	j	800023ea <create_thread+0x48>
      thread_idx = i;
    800023e8:	893e                	mv	s2,a5
  if((np = allocproc()) == 0){
    800023ea:	00000097          	auipc	ra,0x0
    800023ee:	c7a080e7          	jalr	-902(ra) # 80002064 <allocproc>
    800023f2:	8a2a                	mv	s4,a0
    800023f4:	cd3d                	beqz	a0,80002472 <create_thread+0xd0>
  if(uvmshare(p->pagetable, np->pagetable, p->sz) < 0){
    800023f6:	048b3603          	ld	a2,72(s6)
    800023fa:	692c                	ld	a1,80(a0)
    800023fc:	050b3503          	ld	a0,80(s6)
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	604080e7          	jalr	1540(ra) # 80001a04 <uvmshare>
    80002408:	06054f63          	bltz	a0,80002486 <create_thread+0xe4>
  np->sz = p->sz;
    8000240c:	048b3783          	ld	a5,72(s6)
    80002410:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80002414:	058b3683          	ld	a3,88(s6)
    80002418:	87b6                	mv	a5,a3
    8000241a:	058a3703          	ld	a4,88(s4)
    8000241e:	12068693          	addi	a3,a3,288
    80002422:	0007b803          	ld	a6,0(a5)
    80002426:	6788                	ld	a0,8(a5)
    80002428:	6b8c                	ld	a1,16(a5)
    8000242a:	6f90                	ld	a2,24(a5)
    8000242c:	01073023          	sd	a6,0(a4)
    80002430:	e708                	sd	a0,8(a4)
    80002432:	eb0c                	sd	a1,16(a4)
    80002434:	ef10                	sd	a2,24(a4)
    80002436:	02078793          	addi	a5,a5,32
    8000243a:	02070713          	addi	a4,a4,32
    8000243e:	fed792e3          	bne	a5,a3,80002422 <create_thread+0x80>
  np->trapframe->sp = (uint64)stack_addr + PGSIZE;
    80002442:	058a3783          	ld	a5,88(s4)
    80002446:	6705                	lui	a4,0x1
    80002448:	94ba                	add	s1,s1,a4
    8000244a:	fb84                	sd	s1,48(a5)
  np->trapframe->epc = (uint64)fn_addr;
    8000244c:	058a3783          	ld	a5,88(s4)
    80002450:	0177bc23          	sd	s7,24(a5)
  np->trapframe->a0 = (uint64)args;
    80002454:	058a3783          	ld	a5,88(s4)
    80002458:	0757b823          	sd	s5,112(a5)
  np->trapframe->ra = (uint64)exit_fn;
    8000245c:	058a3783          	ld	a5,88(s4)
    80002460:	0337b423          	sd	s3,40(a5)
  for(i = 0; i < NOFILE; i++)
    80002464:	0d0b0493          	addi	s1,s6,208
    80002468:	0d0a0993          	addi	s3,s4,208
    8000246c:	150b0a93          	addi	s5,s6,336
    80002470:	a81d                	j	800024a6 <create_thread+0x104>
    printf("Max processes reached\n");
    80002472:	00008517          	auipc	a0,0x8
    80002476:	dd650513          	addi	a0,a0,-554 # 8000a248 <etext+0x248>
    8000247a:	ffffe097          	auipc	ra,0xffffe
    8000247e:	130080e7          	jalr	304(ra) # 800005aa <printf>
    return -1;
    80002482:	557d                	li	a0,-1
    80002484:	a85d                	j	8000253a <create_thread+0x198>
    freeproc(np);
    80002486:	8552                	mv	a0,s4
    80002488:	00000097          	auipc	ra,0x0
    8000248c:	b84080e7          	jalr	-1148(ra) # 8000200c <freeproc>
    release(&np->lock);
    80002490:	8552                	mv	a0,s4
    80002492:	fffff097          	auipc	ra,0xfffff
    80002496:	934080e7          	jalr	-1740(ra) # 80000dc6 <release>
    return -1;
    8000249a:	557d                	li	a0,-1
    8000249c:	a879                	j	8000253a <create_thread+0x198>
  for(i = 0; i < NOFILE; i++)
    8000249e:	04a1                	addi	s1,s1,8
    800024a0:	09a1                	addi	s3,s3,8
    800024a2:	01548b63          	beq	s1,s5,800024b8 <create_thread+0x116>
    if(p->ofile[i])
    800024a6:	6088                	ld	a0,0(s1)
    800024a8:	d97d                	beqz	a0,8000249e <create_thread+0xfc>
      np->ofile[i] = filedup(p->ofile[i]);
    800024aa:	00003097          	auipc	ra,0x3
    800024ae:	bfe080e7          	jalr	-1026(ra) # 800050a8 <filedup>
    800024b2:	00a9b023          	sd	a0,0(s3)
    800024b6:	b7e5                	j	8000249e <create_thread+0xfc>
  np->cwd = idup(p->cwd);
    800024b8:	150b3503          	ld	a0,336(s6)
    800024bc:	00002097          	auipc	ra,0x2
    800024c0:	d46080e7          	jalr	-698(ra) # 80004202 <idup>
    800024c4:	14aa3823          	sd	a0,336(s4)
  release(&np->lock);
    800024c8:	8552                	mv	a0,s4
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	8fc080e7          	jalr	-1796(ra) # 80000dc6 <release>
  acquire(&wait_lock);
    800024d2:	00054517          	auipc	a0,0x54
    800024d6:	0b650513          	addi	a0,a0,182 # 80056588 <wait_lock>
    800024da:	fffff097          	auipc	ra,0xfffff
    800024de:	83c080e7          	jalr	-1988(ra) # 80000d16 <acquire>
  if (p->is_thread) {
    800024e2:	168b2783          	lw	a5,360(s6)
    800024e6:	c7ad                	beqz	a5,80002550 <create_thread+0x1ae>
    np->parent = p->parent->parent;
    800024e8:	038b3783          	ld	a5,56(s6)
    800024ec:	7f9c                	ld	a5,56(a5)
    800024ee:	02fa3c23          	sd	a5,56(s4)
    p = p->parent->parent;
    800024f2:	038b3783          	ld	a5,56(s6)
    800024f6:	0387bb03          	ld	s6,56(a5)
  release(&wait_lock);
    800024fa:	00054517          	auipc	a0,0x54
    800024fe:	08e50513          	addi	a0,a0,142 # 80056588 <wait_lock>
    80002502:	fffff097          	auipc	ra,0xfffff
    80002506:	8c4080e7          	jalr	-1852(ra) # 80000dc6 <release>
  acquire(&np->lock);
    8000250a:	8552                	mv	a0,s4
    8000250c:	fffff097          	auipc	ra,0xfffff
    80002510:	80a080e7          	jalr	-2038(ra) # 80000d16 <acquire>
  np->is_thread = 1;
    80002514:	4785                	li	a5,1
    80002516:	16fa2423          	sw	a5,360(s4)
  np->state = RUNNABLE;
    8000251a:	478d                	li	a5,3
    8000251c:	00fa2c23          	sw	a5,24(s4)
  p->infant_threads[thread_idx] = np;
    80002520:	02e90793          	addi	a5,s2,46
    80002524:	078e                	slli	a5,a5,0x3
    80002526:	9b3e                	add	s6,s6,a5
    80002528:	014b3023          	sd	s4,0(s6)
  release(&np->lock);
    8000252c:	8552                	mv	a0,s4
    8000252e:	fffff097          	auipc	ra,0xfffff
    80002532:	898080e7          	jalr	-1896(ra) # 80000dc6 <release>
  return np->pid;
    80002536:	030a2503          	lw	a0,48(s4)
}
    8000253a:	60a6                	ld	ra,72(sp)
    8000253c:	6406                	ld	s0,64(sp)
    8000253e:	74e2                	ld	s1,56(sp)
    80002540:	7942                	ld	s2,48(sp)
    80002542:	79a2                	ld	s3,40(sp)
    80002544:	7a02                	ld	s4,32(sp)
    80002546:	6ae2                	ld	s5,24(sp)
    80002548:	6b42                	ld	s6,16(sp)
    8000254a:	6ba2                	ld	s7,8(sp)
    8000254c:	6161                	addi	sp,sp,80
    8000254e:	8082                	ret
    np->parent = p;
    80002550:	036a3c23          	sd	s6,56(s4)
    80002554:	b75d                	j	800024fa <create_thread+0x158>

0000000080002556 <scheduler>:
{
    80002556:	7139                	addi	sp,sp,-64
    80002558:	fc06                	sd	ra,56(sp)
    8000255a:	f822                	sd	s0,48(sp)
    8000255c:	f426                	sd	s1,40(sp)
    8000255e:	f04a                	sd	s2,32(sp)
    80002560:	ec4e                	sd	s3,24(sp)
    80002562:	e852                	sd	s4,16(sp)
    80002564:	e456                	sd	s5,8(sp)
    80002566:	e05a                	sd	s6,0(sp)
    80002568:	0080                	addi	s0,sp,64
    8000256a:	8792                	mv	a5,tp
  int id = r_tp();
    8000256c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000256e:	00779a93          	slli	s5,a5,0x7
    80002572:	00054717          	auipc	a4,0x54
    80002576:	ffe70713          	addi	a4,a4,-2 # 80056570 <pid_lock>
    8000257a:	9756                	add	a4,a4,s5
    8000257c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002580:	00054717          	auipc	a4,0x54
    80002584:	02870713          	addi	a4,a4,40 # 800565a8 <cpus+0x8>
    80002588:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000258a:	498d                	li	s3,3
        p->state = RUNNING;
    8000258c:	4b11                	li	s6,4
        c->proc = p;
    8000258e:	079e                	slli	a5,a5,0x7
    80002590:	00054a17          	auipc	s4,0x54
    80002594:	fe0a0a13          	addi	s4,s4,-32 # 80056570 <pid_lock>
    80002598:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000259a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000259e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025a2:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800025a6:	00054497          	auipc	s1,0x54
    800025aa:	3fa48493          	addi	s1,s1,1018 # 800569a0 <proc>
    800025ae:	00062917          	auipc	s2,0x62
    800025b2:	ff290913          	addi	s2,s2,-14 # 800645a0 <tickslock>
    800025b6:	a811                	j	800025ca <scheduler+0x74>
      release(&p->lock);
    800025b8:	8526                	mv	a0,s1
    800025ba:	fffff097          	auipc	ra,0xfffff
    800025be:	80c080e7          	jalr	-2036(ra) # 80000dc6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800025c2:	37048493          	addi	s1,s1,880
    800025c6:	fd248ae3          	beq	s1,s2,8000259a <scheduler+0x44>
      acquire(&p->lock);
    800025ca:	8526                	mv	a0,s1
    800025cc:	ffffe097          	auipc	ra,0xffffe
    800025d0:	74a080e7          	jalr	1866(ra) # 80000d16 <acquire>
      if(p->state == RUNNABLE) {
    800025d4:	4c9c                	lw	a5,24(s1)
    800025d6:	ff3791e3          	bne	a5,s3,800025b8 <scheduler+0x62>
        p->state = RUNNING;
    800025da:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800025de:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800025e2:	06048593          	addi	a1,s1,96
    800025e6:	8556                	mv	a0,s5
    800025e8:	00001097          	auipc	ra,0x1
    800025ec:	962080e7          	jalr	-1694(ra) # 80002f4a <swtch>
        c->proc = 0;
    800025f0:	020a3823          	sd	zero,48(s4)
    800025f4:	b7d1                	j	800025b8 <scheduler+0x62>

00000000800025f6 <sched>:
{
    800025f6:	7179                	addi	sp,sp,-48
    800025f8:	f406                	sd	ra,40(sp)
    800025fa:	f022                	sd	s0,32(sp)
    800025fc:	ec26                	sd	s1,24(sp)
    800025fe:	e84a                	sd	s2,16(sp)
    80002600:	e44e                	sd	s3,8(sp)
    80002602:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002604:	00000097          	auipc	ra,0x0
    80002608:	856080e7          	jalr	-1962(ra) # 80001e5a <myproc>
    8000260c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000260e:	ffffe097          	auipc	ra,0xffffe
    80002612:	68e080e7          	jalr	1678(ra) # 80000c9c <holding>
    80002616:	c93d                	beqz	a0,8000268c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002618:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000261a:	2781                	sext.w	a5,a5
    8000261c:	079e                	slli	a5,a5,0x7
    8000261e:	00054717          	auipc	a4,0x54
    80002622:	f5270713          	addi	a4,a4,-174 # 80056570 <pid_lock>
    80002626:	97ba                	add	a5,a5,a4
    80002628:	0a87a703          	lw	a4,168(a5)
    8000262c:	4785                	li	a5,1
    8000262e:	06f71763          	bne	a4,a5,8000269c <sched+0xa6>
  if(p->state == RUNNING)
    80002632:	4c98                	lw	a4,24(s1)
    80002634:	4791                	li	a5,4
    80002636:	06f70b63          	beq	a4,a5,800026ac <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000263a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000263e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002640:	efb5                	bnez	a5,800026bc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002642:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002644:	00054917          	auipc	s2,0x54
    80002648:	f2c90913          	addi	s2,s2,-212 # 80056570 <pid_lock>
    8000264c:	2781                	sext.w	a5,a5
    8000264e:	079e                	slli	a5,a5,0x7
    80002650:	97ca                	add	a5,a5,s2
    80002652:	0ac7a983          	lw	s3,172(a5)
    80002656:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002658:	2781                	sext.w	a5,a5
    8000265a:	079e                	slli	a5,a5,0x7
    8000265c:	00054597          	auipc	a1,0x54
    80002660:	f4c58593          	addi	a1,a1,-180 # 800565a8 <cpus+0x8>
    80002664:	95be                	add	a1,a1,a5
    80002666:	06048513          	addi	a0,s1,96
    8000266a:	00001097          	auipc	ra,0x1
    8000266e:	8e0080e7          	jalr	-1824(ra) # 80002f4a <swtch>
    80002672:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002674:	2781                	sext.w	a5,a5
    80002676:	079e                	slli	a5,a5,0x7
    80002678:	993e                	add	s2,s2,a5
    8000267a:	0b392623          	sw	s3,172(s2)
}
    8000267e:	70a2                	ld	ra,40(sp)
    80002680:	7402                	ld	s0,32(sp)
    80002682:	64e2                	ld	s1,24(sp)
    80002684:	6942                	ld	s2,16(sp)
    80002686:	69a2                	ld	s3,8(sp)
    80002688:	6145                	addi	sp,sp,48
    8000268a:	8082                	ret
    panic("sched p->lock");
    8000268c:	00008517          	auipc	a0,0x8
    80002690:	bd450513          	addi	a0,a0,-1068 # 8000a260 <etext+0x260>
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	ecc080e7          	jalr	-308(ra) # 80000560 <panic>
    panic("sched locks");
    8000269c:	00008517          	auipc	a0,0x8
    800026a0:	bd450513          	addi	a0,a0,-1068 # 8000a270 <etext+0x270>
    800026a4:	ffffe097          	auipc	ra,0xffffe
    800026a8:	ebc080e7          	jalr	-324(ra) # 80000560 <panic>
    panic("sched running");
    800026ac:	00008517          	auipc	a0,0x8
    800026b0:	bd450513          	addi	a0,a0,-1068 # 8000a280 <etext+0x280>
    800026b4:	ffffe097          	auipc	ra,0xffffe
    800026b8:	eac080e7          	jalr	-340(ra) # 80000560 <panic>
    panic("sched interruptible");
    800026bc:	00008517          	auipc	a0,0x8
    800026c0:	bd450513          	addi	a0,a0,-1068 # 8000a290 <etext+0x290>
    800026c4:	ffffe097          	auipc	ra,0xffffe
    800026c8:	e9c080e7          	jalr	-356(ra) # 80000560 <panic>

00000000800026cc <yield>:
{
    800026cc:	1101                	addi	sp,sp,-32
    800026ce:	ec06                	sd	ra,24(sp)
    800026d0:	e822                	sd	s0,16(sp)
    800026d2:	e426                	sd	s1,8(sp)
    800026d4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800026d6:	fffff097          	auipc	ra,0xfffff
    800026da:	784080e7          	jalr	1924(ra) # 80001e5a <myproc>
    800026de:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800026e0:	ffffe097          	auipc	ra,0xffffe
    800026e4:	636080e7          	jalr	1590(ra) # 80000d16 <acquire>
  p->state = RUNNABLE;
    800026e8:	478d                	li	a5,3
    800026ea:	cc9c                	sw	a5,24(s1)
  sched();
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	f0a080e7          	jalr	-246(ra) # 800025f6 <sched>
  release(&p->lock);
    800026f4:	8526                	mv	a0,s1
    800026f6:	ffffe097          	auipc	ra,0xffffe
    800026fa:	6d0080e7          	jalr	1744(ra) # 80000dc6 <release>
}
    800026fe:	60e2                	ld	ra,24(sp)
    80002700:	6442                	ld	s0,16(sp)
    80002702:	64a2                	ld	s1,8(sp)
    80002704:	6105                	addi	sp,sp,32
    80002706:	8082                	ret

0000000080002708 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002708:	7179                	addi	sp,sp,-48
    8000270a:	f406                	sd	ra,40(sp)
    8000270c:	f022                	sd	s0,32(sp)
    8000270e:	ec26                	sd	s1,24(sp)
    80002710:	e84a                	sd	s2,16(sp)
    80002712:	e44e                	sd	s3,8(sp)
    80002714:	1800                	addi	s0,sp,48
    80002716:	89aa                	mv	s3,a0
    80002718:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000271a:	fffff097          	auipc	ra,0xfffff
    8000271e:	740080e7          	jalr	1856(ra) # 80001e5a <myproc>
    80002722:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002724:	ffffe097          	auipc	ra,0xffffe
    80002728:	5f2080e7          	jalr	1522(ra) # 80000d16 <acquire>
  release(lk);
    8000272c:	854a                	mv	a0,s2
    8000272e:	ffffe097          	auipc	ra,0xffffe
    80002732:	698080e7          	jalr	1688(ra) # 80000dc6 <release>

  // Go to sleep.
  p->chan = chan;
    80002736:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000273a:	4789                	li	a5,2
    8000273c:	cc9c                	sw	a5,24(s1)

  sched();
    8000273e:	00000097          	auipc	ra,0x0
    80002742:	eb8080e7          	jalr	-328(ra) # 800025f6 <sched>

  // Tidy up.
  p->chan = 0;
    80002746:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000274a:	8526                	mv	a0,s1
    8000274c:	ffffe097          	auipc	ra,0xffffe
    80002750:	67a080e7          	jalr	1658(ra) # 80000dc6 <release>
  acquire(lk);
    80002754:	854a                	mv	a0,s2
    80002756:	ffffe097          	auipc	ra,0xffffe
    8000275a:	5c0080e7          	jalr	1472(ra) # 80000d16 <acquire>
}
    8000275e:	70a2                	ld	ra,40(sp)
    80002760:	7402                	ld	s0,32(sp)
    80002762:	64e2                	ld	s1,24(sp)
    80002764:	6942                	ld	s2,16(sp)
    80002766:	69a2                	ld	s3,8(sp)
    80002768:	6145                	addi	sp,sp,48
    8000276a:	8082                	ret

000000008000276c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000276c:	7139                	addi	sp,sp,-64
    8000276e:	fc06                	sd	ra,56(sp)
    80002770:	f822                	sd	s0,48(sp)
    80002772:	f426                	sd	s1,40(sp)
    80002774:	f04a                	sd	s2,32(sp)
    80002776:	ec4e                	sd	s3,24(sp)
    80002778:	e852                	sd	s4,16(sp)
    8000277a:	e456                	sd	s5,8(sp)
    8000277c:	0080                	addi	s0,sp,64
    8000277e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002780:	00054497          	auipc	s1,0x54
    80002784:	22048493          	addi	s1,s1,544 # 800569a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002788:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000278a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000278c:	00062917          	auipc	s2,0x62
    80002790:	e1490913          	addi	s2,s2,-492 # 800645a0 <tickslock>
    80002794:	a811                	j	800027a8 <wakeup+0x3c>
      }
      release(&p->lock);
    80002796:	8526                	mv	a0,s1
    80002798:	ffffe097          	auipc	ra,0xffffe
    8000279c:	62e080e7          	jalr	1582(ra) # 80000dc6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800027a0:	37048493          	addi	s1,s1,880
    800027a4:	03248663          	beq	s1,s2,800027d0 <wakeup+0x64>
    if(p != myproc()){
    800027a8:	fffff097          	auipc	ra,0xfffff
    800027ac:	6b2080e7          	jalr	1714(ra) # 80001e5a <myproc>
    800027b0:	fea488e3          	beq	s1,a0,800027a0 <wakeup+0x34>
      acquire(&p->lock);
    800027b4:	8526                	mv	a0,s1
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	560080e7          	jalr	1376(ra) # 80000d16 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800027be:	4c9c                	lw	a5,24(s1)
    800027c0:	fd379be3          	bne	a5,s3,80002796 <wakeup+0x2a>
    800027c4:	709c                	ld	a5,32(s1)
    800027c6:	fd4798e3          	bne	a5,s4,80002796 <wakeup+0x2a>
        p->state = RUNNABLE;
    800027ca:	0154ac23          	sw	s5,24(s1)
    800027ce:	b7e1                	j	80002796 <wakeup+0x2a>
    }
  }
}
    800027d0:	70e2                	ld	ra,56(sp)
    800027d2:	7442                	ld	s0,48(sp)
    800027d4:	74a2                	ld	s1,40(sp)
    800027d6:	7902                	ld	s2,32(sp)
    800027d8:	69e2                	ld	s3,24(sp)
    800027da:	6a42                	ld	s4,16(sp)
    800027dc:	6aa2                	ld	s5,8(sp)
    800027de:	6121                	addi	sp,sp,64
    800027e0:	8082                	ret

00000000800027e2 <reparent>:
{
    800027e2:	7179                	addi	sp,sp,-48
    800027e4:	f406                	sd	ra,40(sp)
    800027e6:	f022                	sd	s0,32(sp)
    800027e8:	ec26                	sd	s1,24(sp)
    800027ea:	e84a                	sd	s2,16(sp)
    800027ec:	e44e                	sd	s3,8(sp)
    800027ee:	e052                	sd	s4,0(sp)
    800027f0:	1800                	addi	s0,sp,48
    800027f2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800027f4:	00054497          	auipc	s1,0x54
    800027f8:	1ac48493          	addi	s1,s1,428 # 800569a0 <proc>
      pp->parent = initproc;
    800027fc:	0000ca17          	auipc	s4,0xc
    80002800:	aeca0a13          	addi	s4,s4,-1300 # 8000e2e8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002804:	00062997          	auipc	s3,0x62
    80002808:	d9c98993          	addi	s3,s3,-612 # 800645a0 <tickslock>
    8000280c:	a029                	j	80002816 <reparent+0x34>
    8000280e:	37048493          	addi	s1,s1,880
    80002812:	01348d63          	beq	s1,s3,8000282c <reparent+0x4a>
    if(pp->parent == p){
    80002816:	7c9c                	ld	a5,56(s1)
    80002818:	ff279be3          	bne	a5,s2,8000280e <reparent+0x2c>
      pp->parent = initproc;
    8000281c:	000a3503          	ld	a0,0(s4)
    80002820:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002822:	00000097          	auipc	ra,0x0
    80002826:	f4a080e7          	jalr	-182(ra) # 8000276c <wakeup>
    8000282a:	b7d5                	j	8000280e <reparent+0x2c>
}
    8000282c:	70a2                	ld	ra,40(sp)
    8000282e:	7402                	ld	s0,32(sp)
    80002830:	64e2                	ld	s1,24(sp)
    80002832:	6942                	ld	s2,16(sp)
    80002834:	69a2                	ld	s3,8(sp)
    80002836:	6a02                	ld	s4,0(sp)
    80002838:	6145                	addi	sp,sp,48
    8000283a:	8082                	ret

000000008000283c <thread_exit>:
uint64 thread_exit(uint64 status) {
    8000283c:	7179                	addi	sp,sp,-48
    8000283e:	f406                	sd	ra,40(sp)
    80002840:	f022                	sd	s0,32(sp)
    80002842:	ec26                	sd	s1,24(sp)
    80002844:	e84a                	sd	s2,16(sp)
    80002846:	e44e                	sd	s3,8(sp)
    80002848:	e052                	sd	s4,0(sp)
    8000284a:	1800                	addi	s0,sp,48
    8000284c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000284e:	fffff097          	auipc	ra,0xfffff
    80002852:	60c080e7          	jalr	1548(ra) # 80001e5a <myproc>
    80002856:	89aa                	mv	s3,a0
  if(p == initproc)
    80002858:	0000c797          	auipc	a5,0xc
    8000285c:	a907b783          	ld	a5,-1392(a5) # 8000e2e8 <initproc>
    80002860:	0d050493          	addi	s1,a0,208
    80002864:	15050913          	addi	s2,a0,336
    80002868:	00a79d63          	bne	a5,a0,80002882 <thread_exit+0x46>
    panic("init exiting");
    8000286c:	00008517          	auipc	a0,0x8
    80002870:	a3c50513          	addi	a0,a0,-1476 # 8000a2a8 <etext+0x2a8>
    80002874:	ffffe097          	auipc	ra,0xffffe
    80002878:	cec080e7          	jalr	-788(ra) # 80000560 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000287c:	04a1                	addi	s1,s1,8
    8000287e:	01248b63          	beq	s1,s2,80002894 <thread_exit+0x58>
    if(p->ofile[fd]){
    80002882:	6088                	ld	a0,0(s1)
    80002884:	dd65                	beqz	a0,8000287c <thread_exit+0x40>
      fileclose(f);
    80002886:	00003097          	auipc	ra,0x3
    8000288a:	874080e7          	jalr	-1932(ra) # 800050fa <fileclose>
      p->ofile[fd] = 0;
    8000288e:	0004b023          	sd	zero,0(s1)
    80002892:	b7ed                	j	8000287c <thread_exit+0x40>
  begin_op();
    80002894:	00002097          	auipc	ra,0x2
    80002898:	396080e7          	jalr	918(ra) # 80004c2a <begin_op>
  iput(p->cwd);
    8000289c:	1509b503          	ld	a0,336(s3)
    800028a0:	00002097          	auipc	ra,0x2
    800028a4:	b5e080e7          	jalr	-1186(ra) # 800043fe <iput>
  end_op();
    800028a8:	00002097          	auipc	ra,0x2
    800028ac:	3fc080e7          	jalr	1020(ra) # 80004ca4 <end_op>
  p->cwd = 0;
    800028b0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800028b4:	00054497          	auipc	s1,0x54
    800028b8:	cd448493          	addi	s1,s1,-812 # 80056588 <wait_lock>
    800028bc:	8526                	mv	a0,s1
    800028be:	ffffe097          	auipc	ra,0xffffe
    800028c2:	458080e7          	jalr	1112(ra) # 80000d16 <acquire>
  reparent(p);
    800028c6:	854e                	mv	a0,s3
    800028c8:	00000097          	auipc	ra,0x0
    800028cc:	f1a080e7          	jalr	-230(ra) # 800027e2 <reparent>
  wakeup(p->parent);
    800028d0:	0389b503          	ld	a0,56(s3)
    800028d4:	00000097          	auipc	ra,0x0
    800028d8:	e98080e7          	jalr	-360(ra) # 8000276c <wakeup>
  acquire(&p->lock);
    800028dc:	854e                	mv	a0,s3
    800028de:	ffffe097          	auipc	ra,0xffffe
    800028e2:	438080e7          	jalr	1080(ra) # 80000d16 <acquire>
  p->xstate = status;
    800028e6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800028ea:	4795                	li	a5,5
    800028ec:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800028f0:	8526                	mv	a0,s1
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	4d4080e7          	jalr	1236(ra) # 80000dc6 <release>
  sched();
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	cfc080e7          	jalr	-772(ra) # 800025f6 <sched>
  panic("zombie exit");
    80002902:	00008517          	auipc	a0,0x8
    80002906:	9b650513          	addi	a0,a0,-1610 # 8000a2b8 <etext+0x2b8>
    8000290a:	ffffe097          	auipc	ra,0xffffe
    8000290e:	c56080e7          	jalr	-938(ra) # 80000560 <panic>

0000000080002912 <exit>:
{
    80002912:	711d                	addi	sp,sp,-96
    80002914:	ec86                	sd	ra,88(sp)
    80002916:	e8a2                	sd	s0,80(sp)
    80002918:	e4a6                	sd	s1,72(sp)
    8000291a:	e0ca                	sd	s2,64(sp)
    8000291c:	fc4e                	sd	s3,56(sp)
    8000291e:	f852                	sd	s4,48(sp)
    80002920:	f456                	sd	s5,40(sp)
    80002922:	f05a                	sd	s6,32(sp)
    80002924:	ec5e                	sd	s7,24(sp)
    80002926:	e862                	sd	s8,16(sp)
    80002928:	e466                	sd	s9,8(sp)
    8000292a:	1080                	addi	s0,sp,96
    8000292c:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000292e:	fffff097          	auipc	ra,0xfffff
    80002932:	52c080e7          	jalr	1324(ra) # 80001e5a <myproc>
    80002936:	8c2a                	mv	s8,a0
  if (p->is_thread) {
    80002938:	16852783          	lw	a5,360(a0)
    8000293c:	cfc9                	beqz	a5,800029d6 <exit+0xc4>
    struct proc *parent = p->parent;
    8000293e:	03853b03          	ld	s6,56(a0)
    for (int i = 0; i < MAX_THREADS; i++) {
    80002942:	170b0a13          	addi	s4,s6,368
    80002946:	370b0b13          	addi	s6,s6,880
      acquire(&wait_lock);
    8000294a:	00054a97          	auipc	s5,0x54
    8000294e:	c3ea8a93          	addi	s5,s5,-962 # 80056588 <wait_lock>
      infant->state = ZOMBIE;
    80002952:	4c95                	li	s9,5
    80002954:	a885                	j	800029c4 <exit+0xb2>
          fileclose(f);
    80002956:	00002097          	auipc	ra,0x2
    8000295a:	7a4080e7          	jalr	1956(ra) # 800050fa <fileclose>
          infant->ofile[fd] = 0;
    8000295e:	0004b023          	sd	zero,0(s1)
      for(int fd = 0; fd < NOFILE; fd++){
    80002962:	04a1                	addi	s1,s1,8
    80002964:	01248563          	beq	s1,s2,8000296e <exit+0x5c>
        if(infant->ofile[fd]){
    80002968:	6088                	ld	a0,0(s1)
    8000296a:	f575                	bnez	a0,80002956 <exit+0x44>
    8000296c:	bfdd                	j	80002962 <exit+0x50>
      begin_op();
    8000296e:	00002097          	auipc	ra,0x2
    80002972:	2bc080e7          	jalr	700(ra) # 80004c2a <begin_op>
      iput(infant->cwd);
    80002976:	1509b503          	ld	a0,336(s3)
    8000297a:	00002097          	auipc	ra,0x2
    8000297e:	a84080e7          	jalr	-1404(ra) # 800043fe <iput>
      end_op();
    80002982:	00002097          	auipc	ra,0x2
    80002986:	322080e7          	jalr	802(ra) # 80004ca4 <end_op>
      infant->cwd = 0;
    8000298a:	1409b823          	sd	zero,336(s3)
      acquire(&wait_lock);
    8000298e:	8556                	mv	a0,s5
    80002990:	ffffe097          	auipc	ra,0xffffe
    80002994:	386080e7          	jalr	902(ra) # 80000d16 <acquire>
      acquire(&infant->lock);
    80002998:	854e                	mv	a0,s3
    8000299a:	ffffe097          	auipc	ra,0xffffe
    8000299e:	37c080e7          	jalr	892(ra) # 80000d16 <acquire>
      infant->xstate = status;
    800029a2:	0379a623          	sw	s7,44(s3)
      infant->state = ZOMBIE;
    800029a6:	0199ac23          	sw	s9,24(s3)
      release(&infant->lock);
    800029aa:	854e                	mv	a0,s3
    800029ac:	ffffe097          	auipc	ra,0xffffe
    800029b0:	41a080e7          	jalr	1050(ra) # 80000dc6 <release>
      release(&wait_lock);
    800029b4:	8556                	mv	a0,s5
    800029b6:	ffffe097          	auipc	ra,0xffffe
    800029ba:	410080e7          	jalr	1040(ra) # 80000dc6 <release>
    for (int i = 0; i < MAX_THREADS; i++) {
    800029be:	0a21                	addi	s4,s4,8
    800029c0:	016a0b63          	beq	s4,s6,800029d6 <exit+0xc4>
      struct proc *infant = parent->infant_threads[i];
    800029c4:	000a3983          	ld	s3,0(s4)
      if (infant == 0) 
    800029c8:	fe098be3          	beqz	s3,800029be <exit+0xac>
    800029cc:	0d098493          	addi	s1,s3,208
    800029d0:	15098913          	addi	s2,s3,336
    800029d4:	bf51                	j	80002968 <exit+0x56>
  if(p == initproc)
    800029d6:	0000c797          	auipc	a5,0xc
    800029da:	9127b783          	ld	a5,-1774(a5) # 8000e2e8 <initproc>
    800029de:	0d0c0493          	addi	s1,s8,208
    800029e2:	150c0913          	addi	s2,s8,336
    800029e6:	01879d63          	bne	a5,s8,80002a00 <exit+0xee>
    panic("init exiting");
    800029ea:	00008517          	auipc	a0,0x8
    800029ee:	8be50513          	addi	a0,a0,-1858 # 8000a2a8 <etext+0x2a8>
    800029f2:	ffffe097          	auipc	ra,0xffffe
    800029f6:	b6e080e7          	jalr	-1170(ra) # 80000560 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800029fa:	04a1                	addi	s1,s1,8
    800029fc:	01248b63          	beq	s1,s2,80002a12 <exit+0x100>
    if(p->ofile[fd]){
    80002a00:	6088                	ld	a0,0(s1)
    80002a02:	dd65                	beqz	a0,800029fa <exit+0xe8>
      fileclose(f);
    80002a04:	00002097          	auipc	ra,0x2
    80002a08:	6f6080e7          	jalr	1782(ra) # 800050fa <fileclose>
      p->ofile[fd] = 0;
    80002a0c:	0004b023          	sd	zero,0(s1)
    80002a10:	b7ed                	j	800029fa <exit+0xe8>
  begin_op();
    80002a12:	00002097          	auipc	ra,0x2
    80002a16:	218080e7          	jalr	536(ra) # 80004c2a <begin_op>
  iput(p->cwd);
    80002a1a:	150c3503          	ld	a0,336(s8)
    80002a1e:	00002097          	auipc	ra,0x2
    80002a22:	9e0080e7          	jalr	-1568(ra) # 800043fe <iput>
  end_op();
    80002a26:	00002097          	auipc	ra,0x2
    80002a2a:	27e080e7          	jalr	638(ra) # 80004ca4 <end_op>
  p->cwd = 0;
    80002a2e:	140c3823          	sd	zero,336(s8)
  acquire(&wait_lock);
    80002a32:	00054497          	auipc	s1,0x54
    80002a36:	b5648493          	addi	s1,s1,-1194 # 80056588 <wait_lock>
    80002a3a:	8526                	mv	a0,s1
    80002a3c:	ffffe097          	auipc	ra,0xffffe
    80002a40:	2da080e7          	jalr	730(ra) # 80000d16 <acquire>
  reparent(p);
    80002a44:	8562                	mv	a0,s8
    80002a46:	00000097          	auipc	ra,0x0
    80002a4a:	d9c080e7          	jalr	-612(ra) # 800027e2 <reparent>
  wakeup(p->parent);
    80002a4e:	038c3503          	ld	a0,56(s8)
    80002a52:	00000097          	auipc	ra,0x0
    80002a56:	d1a080e7          	jalr	-742(ra) # 8000276c <wakeup>
  acquire(&p->lock);
    80002a5a:	8562                	mv	a0,s8
    80002a5c:	ffffe097          	auipc	ra,0xffffe
    80002a60:	2ba080e7          	jalr	698(ra) # 80000d16 <acquire>
  p->xstate = status;
    80002a64:	037c2623          	sw	s7,44(s8)
  p->state = ZOMBIE;
    80002a68:	4795                	li	a5,5
    80002a6a:	00fc2c23          	sw	a5,24(s8)
  release(&wait_lock);
    80002a6e:	8526                	mv	a0,s1
    80002a70:	ffffe097          	auipc	ra,0xffffe
    80002a74:	356080e7          	jalr	854(ra) # 80000dc6 <release>
  sched();
    80002a78:	00000097          	auipc	ra,0x0
    80002a7c:	b7e080e7          	jalr	-1154(ra) # 800025f6 <sched>
  panic("zombie exit");
    80002a80:	00008517          	auipc	a0,0x8
    80002a84:	83850513          	addi	a0,a0,-1992 # 8000a2b8 <etext+0x2b8>
    80002a88:	ffffe097          	auipc	ra,0xffffe
    80002a8c:	ad8080e7          	jalr	-1320(ra) # 80000560 <panic>

0000000080002a90 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002a90:	7179                	addi	sp,sp,-48
    80002a92:	f406                	sd	ra,40(sp)
    80002a94:	f022                	sd	s0,32(sp)
    80002a96:	ec26                	sd	s1,24(sp)
    80002a98:	e84a                	sd	s2,16(sp)
    80002a9a:	e44e                	sd	s3,8(sp)
    80002a9c:	1800                	addi	s0,sp,48
    80002a9e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002aa0:	00054497          	auipc	s1,0x54
    80002aa4:	f0048493          	addi	s1,s1,-256 # 800569a0 <proc>
    80002aa8:	00062997          	auipc	s3,0x62
    80002aac:	af898993          	addi	s3,s3,-1288 # 800645a0 <tickslock>
    acquire(&p->lock);
    80002ab0:	8526                	mv	a0,s1
    80002ab2:	ffffe097          	auipc	ra,0xffffe
    80002ab6:	264080e7          	jalr	612(ra) # 80000d16 <acquire>
    if(p->pid == pid){
    80002aba:	589c                	lw	a5,48(s1)
    80002abc:	01278d63          	beq	a5,s2,80002ad6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002ac0:	8526                	mv	a0,s1
    80002ac2:	ffffe097          	auipc	ra,0xffffe
    80002ac6:	304080e7          	jalr	772(ra) # 80000dc6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002aca:	37048493          	addi	s1,s1,880
    80002ace:	ff3491e3          	bne	s1,s3,80002ab0 <kill+0x20>
  }
  return -1;
    80002ad2:	557d                	li	a0,-1
    80002ad4:	a829                	j	80002aee <kill+0x5e>
      p->killed = 1;
    80002ad6:	4785                	li	a5,1
    80002ad8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002ada:	4c98                	lw	a4,24(s1)
    80002adc:	4789                	li	a5,2
    80002ade:	00f70f63          	beq	a4,a5,80002afc <kill+0x6c>
      release(&p->lock);
    80002ae2:	8526                	mv	a0,s1
    80002ae4:	ffffe097          	auipc	ra,0xffffe
    80002ae8:	2e2080e7          	jalr	738(ra) # 80000dc6 <release>
      return 0;
    80002aec:	4501                	li	a0,0
}
    80002aee:	70a2                	ld	ra,40(sp)
    80002af0:	7402                	ld	s0,32(sp)
    80002af2:	64e2                	ld	s1,24(sp)
    80002af4:	6942                	ld	s2,16(sp)
    80002af6:	69a2                	ld	s3,8(sp)
    80002af8:	6145                	addi	sp,sp,48
    80002afa:	8082                	ret
        p->state = RUNNABLE;
    80002afc:	478d                	li	a5,3
    80002afe:	cc9c                	sw	a5,24(s1)
    80002b00:	b7cd                	j	80002ae2 <kill+0x52>

0000000080002b02 <setkilled>:

void
setkilled(struct proc *p)
{
    80002b02:	1101                	addi	sp,sp,-32
    80002b04:	ec06                	sd	ra,24(sp)
    80002b06:	e822                	sd	s0,16(sp)
    80002b08:	e426                	sd	s1,8(sp)
    80002b0a:	1000                	addi	s0,sp,32
    80002b0c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002b0e:	ffffe097          	auipc	ra,0xffffe
    80002b12:	208080e7          	jalr	520(ra) # 80000d16 <acquire>
  p->killed = 1;
    80002b16:	4785                	li	a5,1
    80002b18:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002b1a:	8526                	mv	a0,s1
    80002b1c:	ffffe097          	auipc	ra,0xffffe
    80002b20:	2aa080e7          	jalr	682(ra) # 80000dc6 <release>
}
    80002b24:	60e2                	ld	ra,24(sp)
    80002b26:	6442                	ld	s0,16(sp)
    80002b28:	64a2                	ld	s1,8(sp)
    80002b2a:	6105                	addi	sp,sp,32
    80002b2c:	8082                	ret

0000000080002b2e <killed>:

int
killed(struct proc *p)
{
    80002b2e:	1101                	addi	sp,sp,-32
    80002b30:	ec06                	sd	ra,24(sp)
    80002b32:	e822                	sd	s0,16(sp)
    80002b34:	e426                	sd	s1,8(sp)
    80002b36:	e04a                	sd	s2,0(sp)
    80002b38:	1000                	addi	s0,sp,32
    80002b3a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002b3c:	ffffe097          	auipc	ra,0xffffe
    80002b40:	1da080e7          	jalr	474(ra) # 80000d16 <acquire>
  k = p->killed;
    80002b44:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002b48:	8526                	mv	a0,s1
    80002b4a:	ffffe097          	auipc	ra,0xffffe
    80002b4e:	27c080e7          	jalr	636(ra) # 80000dc6 <release>
  return k;
}
    80002b52:	854a                	mv	a0,s2
    80002b54:	60e2                	ld	ra,24(sp)
    80002b56:	6442                	ld	s0,16(sp)
    80002b58:	64a2                	ld	s1,8(sp)
    80002b5a:	6902                	ld	s2,0(sp)
    80002b5c:	6105                	addi	sp,sp,32
    80002b5e:	8082                	ret

0000000080002b60 <join_thread>:
uint64 join_thread(uint64 thread_id, uint64 status_addr) {
    80002b60:	715d                	addi	sp,sp,-80
    80002b62:	e486                	sd	ra,72(sp)
    80002b64:	e0a2                	sd	s0,64(sp)
    80002b66:	fc26                	sd	s1,56(sp)
    80002b68:	f84a                	sd	s2,48(sp)
    80002b6a:	f44e                	sd	s3,40(sp)
    80002b6c:	f052                	sd	s4,32(sp)
    80002b6e:	e85a                	sd	s6,16(sp)
    80002b70:	0880                	addi	s0,sp,80
    80002b72:	8a2a                	mv	s4,a0
    80002b74:	8b2e                	mv	s6,a1
  struct proc *p = myproc();
    80002b76:	fffff097          	auipc	ra,0xfffff
    80002b7a:	2e4080e7          	jalr	740(ra) # 80001e5a <myproc>
    80002b7e:	89aa                	mv	s3,a0
  if (p->is_thread) 
    80002b80:	16852783          	lw	a5,360(a0)
    80002b84:	c399                	beqz	a5,80002b8a <join_thread+0x2a>
    p = p->parent;
    80002b86:	03853983          	ld	s3,56(a0)
  acquire(&wait_lock);
    80002b8a:	00054517          	auipc	a0,0x54
    80002b8e:	9fe50513          	addi	a0,a0,-1538 # 80056588 <wait_lock>
    80002b92:	ffffe097          	auipc	ra,0xffffe
    80002b96:	184080e7          	jalr	388(ra) # 80000d16 <acquire>
  for (thread_idx = 0; thread_idx < MAX_THREADS; thread_idx++) {
    80002b9a:	17098793          	addi	a5,s3,368
    80002b9e:	4901                	li	s2,0
    80002ba0:	04000693          	li	a3,64
    80002ba4:	a029                	j	80002bae <join_thread+0x4e>
    80002ba6:	2905                	addiw	s2,s2,1
    80002ba8:	07a1                	addi	a5,a5,8
    80002baa:	0ed90263          	beq	s2,a3,80002c8e <join_thread+0x12e>
    if (p->infant_threads[thread_idx] && thread_id == p->infant_threads[thread_idx]->pid) {
    80002bae:	6384                	ld	s1,0(a5)
    80002bb0:	d8fd                	beqz	s1,80002ba6 <join_thread+0x46>
    80002bb2:	5898                	lw	a4,48(s1)
    80002bb4:	ff4719e3          	bne	a4,s4,80002ba6 <join_thread+0x46>
    80002bb8:	ec56                	sd	s5,24(sp)
    80002bba:	e45e                	sd	s7,8(sp)
    if (child->state == ZOMBIE) {
    80002bbc:	4a95                	li	s5,5
    sleep(p, &wait_lock);
    80002bbe:	00054b97          	auipc	s7,0x54
    80002bc2:	9cab8b93          	addi	s7,s7,-1590 # 80056588 <wait_lock>
    acquire(&child->lock);
    80002bc6:	8526                	mv	a0,s1
    80002bc8:	ffffe097          	auipc	ra,0xffffe
    80002bcc:	14e080e7          	jalr	334(ra) # 80000d16 <acquire>
    if (child->state == ZOMBIE) {
    80002bd0:	4c9c                	lw	a5,24(s1)
    80002bd2:	03578463          	beq	a5,s5,80002bfa <join_thread+0x9a>
    release(&child->lock);
    80002bd6:	8526                	mv	a0,s1
    80002bd8:	ffffe097          	auipc	ra,0xffffe
    80002bdc:	1ee080e7          	jalr	494(ra) # 80000dc6 <release>
    if (killed(p)) {
    80002be0:	854e                	mv	a0,s3
    80002be2:	00000097          	auipc	ra,0x0
    80002be6:	f4c080e7          	jalr	-180(ra) # 80002b2e <killed>
    80002bea:	ed35                	bnez	a0,80002c66 <join_thread+0x106>
    sleep(p, &wait_lock);
    80002bec:	85de                	mv	a1,s7
    80002bee:	854e                	mv	a0,s3
    80002bf0:	00000097          	auipc	ra,0x0
    80002bf4:	b18080e7          	jalr	-1256(ra) # 80002708 <sleep>
    acquire(&child->lock);
    80002bf8:	b7f9                	j	80002bc6 <join_thread+0x66>
      if (status_addr != 0 && copyout(p->pagetable, status_addr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
    80002bfa:	000b0e63          	beqz	s6,80002c16 <join_thread+0xb6>
    80002bfe:	4691                	li	a3,4
    80002c00:	02c48613          	addi	a2,s1,44
    80002c04:	85da                	mv	a1,s6
    80002c06:	0509b503          	ld	a0,80(s3)
    80002c0a:	fffff097          	auipc	ra,0xfffff
    80002c0e:	ef8080e7          	jalr	-264(ra) # 80001b02 <copyout>
    80002c12:	02054963          	bltz	a0,80002c44 <join_thread+0xe4>
      release(&child->lock);
    80002c16:	8526                	mv	a0,s1
    80002c18:	ffffe097          	auipc	ra,0xffffe
    80002c1c:	1ae080e7          	jalr	430(ra) # 80000dc6 <release>
      release(&wait_lock);
    80002c20:	00054517          	auipc	a0,0x54
    80002c24:	96850513          	addi	a0,a0,-1688 # 80056588 <wait_lock>
    80002c28:	ffffe097          	auipc	ra,0xffffe
    80002c2c:	19e080e7          	jalr	414(ra) # 80000dc6 <release>
      p->infant_threads[thread_idx] = 0;
    80002c30:	02e90913          	addi	s2,s2,46
    80002c34:	090e                	slli	s2,s2,0x3
    80002c36:	99ca                	add	s3,s3,s2
    80002c38:	0009b023          	sd	zero,0(s3)
      return thread_id;
    80002c3c:	8552                	mv	a0,s4
    80002c3e:	6ae2                	ld	s5,24(sp)
    80002c40:	6ba2                	ld	s7,8(sp)
    80002c42:	a82d                	j	80002c7c <join_thread+0x11c>
        release(&child->lock);
    80002c44:	8526                	mv	a0,s1
    80002c46:	ffffe097          	auipc	ra,0xffffe
    80002c4a:	180080e7          	jalr	384(ra) # 80000dc6 <release>
        release(&wait_lock);
    80002c4e:	00054517          	auipc	a0,0x54
    80002c52:	93a50513          	addi	a0,a0,-1734 # 80056588 <wait_lock>
    80002c56:	ffffe097          	auipc	ra,0xffffe
    80002c5a:	170080e7          	jalr	368(ra) # 80000dc6 <release>
        return -1;
    80002c5e:	557d                	li	a0,-1
    80002c60:	6ae2                	ld	s5,24(sp)
    80002c62:	6ba2                	ld	s7,8(sp)
    80002c64:	a821                	j	80002c7c <join_thread+0x11c>
      release(&wait_lock);
    80002c66:	00054517          	auipc	a0,0x54
    80002c6a:	92250513          	addi	a0,a0,-1758 # 80056588 <wait_lock>
    80002c6e:	ffffe097          	auipc	ra,0xffffe
    80002c72:	158080e7          	jalr	344(ra) # 80000dc6 <release>
      return -1;
    80002c76:	557d                	li	a0,-1
    80002c78:	6ae2                	ld	s5,24(sp)
    80002c7a:	6ba2                	ld	s7,8(sp)
}
    80002c7c:	60a6                	ld	ra,72(sp)
    80002c7e:	6406                	ld	s0,64(sp)
    80002c80:	74e2                	ld	s1,56(sp)
    80002c82:	7942                	ld	s2,48(sp)
    80002c84:	79a2                	ld	s3,40(sp)
    80002c86:	7a02                	ld	s4,32(sp)
    80002c88:	6b42                	ld	s6,16(sp)
    80002c8a:	6161                	addi	sp,sp,80
    80002c8c:	8082                	ret
    release(&wait_lock);
    80002c8e:	00054517          	auipc	a0,0x54
    80002c92:	8fa50513          	addi	a0,a0,-1798 # 80056588 <wait_lock>
    80002c96:	ffffe097          	auipc	ra,0xffffe
    80002c9a:	130080e7          	jalr	304(ra) # 80000dc6 <release>
    return -1;
    80002c9e:	557d                	li	a0,-1
    80002ca0:	bff1                	j	80002c7c <join_thread+0x11c>

0000000080002ca2 <wait>:
{
    80002ca2:	715d                	addi	sp,sp,-80
    80002ca4:	e486                	sd	ra,72(sp)
    80002ca6:	e0a2                	sd	s0,64(sp)
    80002ca8:	fc26                	sd	s1,56(sp)
    80002caa:	f84a                	sd	s2,48(sp)
    80002cac:	f44e                	sd	s3,40(sp)
    80002cae:	f052                	sd	s4,32(sp)
    80002cb0:	ec56                	sd	s5,24(sp)
    80002cb2:	e85a                	sd	s6,16(sp)
    80002cb4:	e45e                	sd	s7,8(sp)
    80002cb6:	0880                	addi	s0,sp,80
    80002cb8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002cba:	fffff097          	auipc	ra,0xfffff
    80002cbe:	1a0080e7          	jalr	416(ra) # 80001e5a <myproc>
    80002cc2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002cc4:	00054517          	auipc	a0,0x54
    80002cc8:	8c450513          	addi	a0,a0,-1852 # 80056588 <wait_lock>
    80002ccc:	ffffe097          	auipc	ra,0xffffe
    80002cd0:	04a080e7          	jalr	74(ra) # 80000d16 <acquire>
        if(pp->state == ZOMBIE){
    80002cd4:	4a15                	li	s4,5
        havekids = 1;
    80002cd6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002cd8:	00062997          	auipc	s3,0x62
    80002cdc:	8c898993          	addi	s3,s3,-1848 # 800645a0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002ce0:	00054b97          	auipc	s7,0x54
    80002ce4:	8a8b8b93          	addi	s7,s7,-1880 # 80056588 <wait_lock>
    80002ce8:	a0c9                	j	80002daa <wait+0x108>
          pid = pp->pid;
    80002cea:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002cee:	000b0e63          	beqz	s6,80002d0a <wait+0x68>
    80002cf2:	4691                	li	a3,4
    80002cf4:	02c48613          	addi	a2,s1,44
    80002cf8:	85da                	mv	a1,s6
    80002cfa:	05093503          	ld	a0,80(s2)
    80002cfe:	fffff097          	auipc	ra,0xfffff
    80002d02:	e04080e7          	jalr	-508(ra) # 80001b02 <copyout>
    80002d06:	04054063          	bltz	a0,80002d46 <wait+0xa4>
          freeproc(pp);
    80002d0a:	8526                	mv	a0,s1
    80002d0c:	fffff097          	auipc	ra,0xfffff
    80002d10:	300080e7          	jalr	768(ra) # 8000200c <freeproc>
          release(&pp->lock);
    80002d14:	8526                	mv	a0,s1
    80002d16:	ffffe097          	auipc	ra,0xffffe
    80002d1a:	0b0080e7          	jalr	176(ra) # 80000dc6 <release>
          release(&wait_lock);
    80002d1e:	00054517          	auipc	a0,0x54
    80002d22:	86a50513          	addi	a0,a0,-1942 # 80056588 <wait_lock>
    80002d26:	ffffe097          	auipc	ra,0xffffe
    80002d2a:	0a0080e7          	jalr	160(ra) # 80000dc6 <release>
}
    80002d2e:	854e                	mv	a0,s3
    80002d30:	60a6                	ld	ra,72(sp)
    80002d32:	6406                	ld	s0,64(sp)
    80002d34:	74e2                	ld	s1,56(sp)
    80002d36:	7942                	ld	s2,48(sp)
    80002d38:	79a2                	ld	s3,40(sp)
    80002d3a:	7a02                	ld	s4,32(sp)
    80002d3c:	6ae2                	ld	s5,24(sp)
    80002d3e:	6b42                	ld	s6,16(sp)
    80002d40:	6ba2                	ld	s7,8(sp)
    80002d42:	6161                	addi	sp,sp,80
    80002d44:	8082                	ret
            release(&pp->lock);
    80002d46:	8526                	mv	a0,s1
    80002d48:	ffffe097          	auipc	ra,0xffffe
    80002d4c:	07e080e7          	jalr	126(ra) # 80000dc6 <release>
            release(&wait_lock);
    80002d50:	00054517          	auipc	a0,0x54
    80002d54:	83850513          	addi	a0,a0,-1992 # 80056588 <wait_lock>
    80002d58:	ffffe097          	auipc	ra,0xffffe
    80002d5c:	06e080e7          	jalr	110(ra) # 80000dc6 <release>
            return -1;
    80002d60:	59fd                	li	s3,-1
    80002d62:	b7f1                	j	80002d2e <wait+0x8c>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002d64:	37048493          	addi	s1,s1,880
    80002d68:	03348463          	beq	s1,s3,80002d90 <wait+0xee>
      if(pp->parent == p){
    80002d6c:	7c9c                	ld	a5,56(s1)
    80002d6e:	ff279be3          	bne	a5,s2,80002d64 <wait+0xc2>
        acquire(&pp->lock);
    80002d72:	8526                	mv	a0,s1
    80002d74:	ffffe097          	auipc	ra,0xffffe
    80002d78:	fa2080e7          	jalr	-94(ra) # 80000d16 <acquire>
        if(pp->state == ZOMBIE){
    80002d7c:	4c9c                	lw	a5,24(s1)
    80002d7e:	f74786e3          	beq	a5,s4,80002cea <wait+0x48>
        release(&pp->lock);
    80002d82:	8526                	mv	a0,s1
    80002d84:	ffffe097          	auipc	ra,0xffffe
    80002d88:	042080e7          	jalr	66(ra) # 80000dc6 <release>
        havekids = 1;
    80002d8c:	8756                	mv	a4,s5
    80002d8e:	bfd9                	j	80002d64 <wait+0xc2>
    if(!havekids || killed(p)){
    80002d90:	c31d                	beqz	a4,80002db6 <wait+0x114>
    80002d92:	854a                	mv	a0,s2
    80002d94:	00000097          	auipc	ra,0x0
    80002d98:	d9a080e7          	jalr	-614(ra) # 80002b2e <killed>
    80002d9c:	ed09                	bnez	a0,80002db6 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002d9e:	85de                	mv	a1,s7
    80002da0:	854a                	mv	a0,s2
    80002da2:	00000097          	auipc	ra,0x0
    80002da6:	966080e7          	jalr	-1690(ra) # 80002708 <sleep>
    havekids = 0;
    80002daa:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002dac:	00054497          	auipc	s1,0x54
    80002db0:	bf448493          	addi	s1,s1,-1036 # 800569a0 <proc>
    80002db4:	bf65                	j	80002d6c <wait+0xca>
      release(&wait_lock);
    80002db6:	00053517          	auipc	a0,0x53
    80002dba:	7d250513          	addi	a0,a0,2002 # 80056588 <wait_lock>
    80002dbe:	ffffe097          	auipc	ra,0xffffe
    80002dc2:	008080e7          	jalr	8(ra) # 80000dc6 <release>
      return -1;
    80002dc6:	59fd                	li	s3,-1
    80002dc8:	b79d                	j	80002d2e <wait+0x8c>

0000000080002dca <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002dca:	7179                	addi	sp,sp,-48
    80002dcc:	f406                	sd	ra,40(sp)
    80002dce:	f022                	sd	s0,32(sp)
    80002dd0:	ec26                	sd	s1,24(sp)
    80002dd2:	e84a                	sd	s2,16(sp)
    80002dd4:	e44e                	sd	s3,8(sp)
    80002dd6:	e052                	sd	s4,0(sp)
    80002dd8:	1800                	addi	s0,sp,48
    80002dda:	84aa                	mv	s1,a0
    80002ddc:	892e                	mv	s2,a1
    80002dde:	89b2                	mv	s3,a2
    80002de0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002de2:	fffff097          	auipc	ra,0xfffff
    80002de6:	078080e7          	jalr	120(ra) # 80001e5a <myproc>
  if(user_dst){
    80002dea:	c08d                	beqz	s1,80002e0c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002dec:	86d2                	mv	a3,s4
    80002dee:	864e                	mv	a2,s3
    80002df0:	85ca                	mv	a1,s2
    80002df2:	6928                	ld	a0,80(a0)
    80002df4:	fffff097          	auipc	ra,0xfffff
    80002df8:	d0e080e7          	jalr	-754(ra) # 80001b02 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002dfc:	70a2                	ld	ra,40(sp)
    80002dfe:	7402                	ld	s0,32(sp)
    80002e00:	64e2                	ld	s1,24(sp)
    80002e02:	6942                	ld	s2,16(sp)
    80002e04:	69a2                	ld	s3,8(sp)
    80002e06:	6a02                	ld	s4,0(sp)
    80002e08:	6145                	addi	sp,sp,48
    80002e0a:	8082                	ret
    memmove((char *)dst, src, len);
    80002e0c:	000a061b          	sext.w	a2,s4
    80002e10:	85ce                	mv	a1,s3
    80002e12:	854a                	mv	a0,s2
    80002e14:	ffffe097          	auipc	ra,0xffffe
    80002e18:	05e080e7          	jalr	94(ra) # 80000e72 <memmove>
    return 0;
    80002e1c:	8526                	mv	a0,s1
    80002e1e:	bff9                	j	80002dfc <either_copyout+0x32>

0000000080002e20 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002e20:	7179                	addi	sp,sp,-48
    80002e22:	f406                	sd	ra,40(sp)
    80002e24:	f022                	sd	s0,32(sp)
    80002e26:	ec26                	sd	s1,24(sp)
    80002e28:	e84a                	sd	s2,16(sp)
    80002e2a:	e44e                	sd	s3,8(sp)
    80002e2c:	e052                	sd	s4,0(sp)
    80002e2e:	1800                	addi	s0,sp,48
    80002e30:	892a                	mv	s2,a0
    80002e32:	84ae                	mv	s1,a1
    80002e34:	89b2                	mv	s3,a2
    80002e36:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	022080e7          	jalr	34(ra) # 80001e5a <myproc>
  if(user_src){
    80002e40:	c08d                	beqz	s1,80002e62 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002e42:	86d2                	mv	a3,s4
    80002e44:	864e                	mv	a2,s3
    80002e46:	85ca                	mv	a1,s2
    80002e48:	6928                	ld	a0,80(a0)
    80002e4a:	fffff097          	auipc	ra,0xfffff
    80002e4e:	d44080e7          	jalr	-700(ra) # 80001b8e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002e52:	70a2                	ld	ra,40(sp)
    80002e54:	7402                	ld	s0,32(sp)
    80002e56:	64e2                	ld	s1,24(sp)
    80002e58:	6942                	ld	s2,16(sp)
    80002e5a:	69a2                	ld	s3,8(sp)
    80002e5c:	6a02                	ld	s4,0(sp)
    80002e5e:	6145                	addi	sp,sp,48
    80002e60:	8082                	ret
    memmove(dst, (char*)src, len);
    80002e62:	000a061b          	sext.w	a2,s4
    80002e66:	85ce                	mv	a1,s3
    80002e68:	854a                	mv	a0,s2
    80002e6a:	ffffe097          	auipc	ra,0xffffe
    80002e6e:	008080e7          	jalr	8(ra) # 80000e72 <memmove>
    return 0;
    80002e72:	8526                	mv	a0,s1
    80002e74:	bff9                	j	80002e52 <either_copyin+0x32>

0000000080002e76 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002e76:	715d                	addi	sp,sp,-80
    80002e78:	e486                	sd	ra,72(sp)
    80002e7a:	e0a2                	sd	s0,64(sp)
    80002e7c:	fc26                	sd	s1,56(sp)
    80002e7e:	f84a                	sd	s2,48(sp)
    80002e80:	f44e                	sd	s3,40(sp)
    80002e82:	f052                	sd	s4,32(sp)
    80002e84:	ec56                	sd	s5,24(sp)
    80002e86:	e85a                	sd	s6,16(sp)
    80002e88:	e45e                	sd	s7,8(sp)
    80002e8a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002e8c:	00007517          	auipc	a0,0x7
    80002e90:	19450513          	addi	a0,a0,404 # 8000a020 <etext+0x20>
    80002e94:	ffffd097          	auipc	ra,0xffffd
    80002e98:	716080e7          	jalr	1814(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002e9c:	00054497          	auipc	s1,0x54
    80002ea0:	c5c48493          	addi	s1,s1,-932 # 80056af8 <proc+0x158>
    80002ea4:	00062917          	auipc	s2,0x62
    80002ea8:	85490913          	addi	s2,s2,-1964 # 800646f8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002eac:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002eae:	00007997          	auipc	s3,0x7
    80002eb2:	41a98993          	addi	s3,s3,1050 # 8000a2c8 <etext+0x2c8>
    printf("%d %s %s", p->pid, state, p->name);
    80002eb6:	00007a97          	auipc	s5,0x7
    80002eba:	41aa8a93          	addi	s5,s5,1050 # 8000a2d0 <etext+0x2d0>
    printf("\n");
    80002ebe:	00007a17          	auipc	s4,0x7
    80002ec2:	162a0a13          	addi	s4,s4,354 # 8000a020 <etext+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ec6:	00008b97          	auipc	s7,0x8
    80002eca:	e82b8b93          	addi	s7,s7,-382 # 8000ad48 <states.0>
    80002ece:	a00d                	j	80002ef0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002ed0:	ed86a583          	lw	a1,-296(a3)
    80002ed4:	8556                	mv	a0,s5
    80002ed6:	ffffd097          	auipc	ra,0xffffd
    80002eda:	6d4080e7          	jalr	1748(ra) # 800005aa <printf>
    printf("\n");
    80002ede:	8552                	mv	a0,s4
    80002ee0:	ffffd097          	auipc	ra,0xffffd
    80002ee4:	6ca080e7          	jalr	1738(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002ee8:	37048493          	addi	s1,s1,880
    80002eec:	03248263          	beq	s1,s2,80002f10 <procdump+0x9a>
    if(p->state == UNUSED)
    80002ef0:	86a6                	mv	a3,s1
    80002ef2:	ec04a783          	lw	a5,-320(s1)
    80002ef6:	dbed                	beqz	a5,80002ee8 <procdump+0x72>
      state = "???";
    80002ef8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002efa:	fcfb6be3          	bltu	s6,a5,80002ed0 <procdump+0x5a>
    80002efe:	02079713          	slli	a4,a5,0x20
    80002f02:	01d75793          	srli	a5,a4,0x1d
    80002f06:	97de                	add	a5,a5,s7
    80002f08:	6390                	ld	a2,0(a5)
    80002f0a:	f279                	bnez	a2,80002ed0 <procdump+0x5a>
      state = "???";
    80002f0c:	864e                	mv	a2,s3
    80002f0e:	b7c9                	j	80002ed0 <procdump+0x5a>
  }
}
    80002f10:	60a6                	ld	ra,72(sp)
    80002f12:	6406                	ld	s0,64(sp)
    80002f14:	74e2                	ld	s1,56(sp)
    80002f16:	7942                	ld	s2,48(sp)
    80002f18:	79a2                	ld	s3,40(sp)
    80002f1a:	7a02                	ld	s4,32(sp)
    80002f1c:	6ae2                	ld	s5,24(sp)
    80002f1e:	6b42                	ld	s6,16(sp)
    80002f20:	6ba2                	ld	s7,8(sp)
    80002f22:	6161                	addi	sp,sp,80
    80002f24:	8082                	ret

0000000080002f26 <spoon>:

uint64 spoon(void *arg)
{
    80002f26:	1141                	addi	sp,sp,-16
    80002f28:	e406                	sd	ra,8(sp)
    80002f2a:	e022                	sd	s0,0(sp)
    80002f2c:	0800                	addi	s0,sp,16
    80002f2e:	85aa                	mv	a1,a0
  // Add your code here...
  printf("In spoon system call with argument %p\n", arg);
    80002f30:	00007517          	auipc	a0,0x7
    80002f34:	3b050513          	addi	a0,a0,944 # 8000a2e0 <etext+0x2e0>
    80002f38:	ffffd097          	auipc	ra,0xffffd
    80002f3c:	672080e7          	jalr	1650(ra) # 800005aa <printf>
  return 0;
}
    80002f40:	4501                	li	a0,0
    80002f42:	60a2                	ld	ra,8(sp)
    80002f44:	6402                	ld	s0,0(sp)
    80002f46:	0141                	addi	sp,sp,16
    80002f48:	8082                	ret

0000000080002f4a <swtch>:
    80002f4a:	00153023          	sd	ra,0(a0)
    80002f4e:	00253423          	sd	sp,8(a0)
    80002f52:	e900                	sd	s0,16(a0)
    80002f54:	ed04                	sd	s1,24(a0)
    80002f56:	03253023          	sd	s2,32(a0)
    80002f5a:	03353423          	sd	s3,40(a0)
    80002f5e:	03453823          	sd	s4,48(a0)
    80002f62:	03553c23          	sd	s5,56(a0)
    80002f66:	05653023          	sd	s6,64(a0)
    80002f6a:	05753423          	sd	s7,72(a0)
    80002f6e:	05853823          	sd	s8,80(a0)
    80002f72:	05953c23          	sd	s9,88(a0)
    80002f76:	07a53023          	sd	s10,96(a0)
    80002f7a:	07b53423          	sd	s11,104(a0)
    80002f7e:	0005b083          	ld	ra,0(a1)
    80002f82:	0085b103          	ld	sp,8(a1)
    80002f86:	6980                	ld	s0,16(a1)
    80002f88:	6d84                	ld	s1,24(a1)
    80002f8a:	0205b903          	ld	s2,32(a1)
    80002f8e:	0285b983          	ld	s3,40(a1)
    80002f92:	0305ba03          	ld	s4,48(a1)
    80002f96:	0385ba83          	ld	s5,56(a1)
    80002f9a:	0405bb03          	ld	s6,64(a1)
    80002f9e:	0485bb83          	ld	s7,72(a1)
    80002fa2:	0505bc03          	ld	s8,80(a1)
    80002fa6:	0585bc83          	ld	s9,88(a1)
    80002faa:	0605bd03          	ld	s10,96(a1)
    80002fae:	0685bd83          	ld	s11,104(a1)
    80002fb2:	8082                	ret

0000000080002fb4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002fb4:	1141                	addi	sp,sp,-16
    80002fb6:	e406                	sd	ra,8(sp)
    80002fb8:	e022                	sd	s0,0(sp)
    80002fba:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002fbc:	00007597          	auipc	a1,0x7
    80002fc0:	37c58593          	addi	a1,a1,892 # 8000a338 <etext+0x338>
    80002fc4:	00061517          	auipc	a0,0x61
    80002fc8:	5dc50513          	addi	a0,a0,1500 # 800645a0 <tickslock>
    80002fcc:	ffffe097          	auipc	ra,0xffffe
    80002fd0:	cb6080e7          	jalr	-842(ra) # 80000c82 <initlock>
}
    80002fd4:	60a2                	ld	ra,8(sp)
    80002fd6:	6402                	ld	s0,0(sp)
    80002fd8:	0141                	addi	sp,sp,16
    80002fda:	8082                	ret

0000000080002fdc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002fdc:	1141                	addi	sp,sp,-16
    80002fde:	e406                	sd	ra,8(sp)
    80002fe0:	e022                	sd	s0,0(sp)
    80002fe2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002fe4:	00004797          	auipc	a5,0x4
    80002fe8:	85c78793          	addi	a5,a5,-1956 # 80006840 <kernelvec>
    80002fec:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002ff0:	60a2                	ld	ra,8(sp)
    80002ff2:	6402                	ld	s0,0(sp)
    80002ff4:	0141                	addi	sp,sp,16
    80002ff6:	8082                	ret

0000000080002ff8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002ff8:	1141                	addi	sp,sp,-16
    80002ffa:	e406                	sd	ra,8(sp)
    80002ffc:	e022                	sd	s0,0(sp)
    80002ffe:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80003000:	fffff097          	auipc	ra,0xfffff
    80003004:	e5a080e7          	jalr	-422(ra) # 80001e5a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003008:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000300c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000300e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003012:	00006697          	auipc	a3,0x6
    80003016:	fee68693          	addi	a3,a3,-18 # 80009000 <_trampoline>
    8000301a:	00006717          	auipc	a4,0x6
    8000301e:	fe670713          	addi	a4,a4,-26 # 80009000 <_trampoline>
    80003022:	8f15                	sub	a4,a4,a3
    80003024:	040007b7          	lui	a5,0x4000
    80003028:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000302a:	07b2                	slli	a5,a5,0xc
    8000302c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000302e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003032:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003034:	18002673          	csrr	a2,satp
    80003038:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000303a:	6d30                	ld	a2,88(a0)
    8000303c:	6138                	ld	a4,64(a0)
    8000303e:	6585                	lui	a1,0x1
    80003040:	972e                	add	a4,a4,a1
    80003042:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003044:	6d38                	ld	a4,88(a0)
    80003046:	00000617          	auipc	a2,0x0
    8000304a:	14c60613          	addi	a2,a2,332 # 80003192 <usertrap>
    8000304e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003050:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80003052:	8612                	mv	a2,tp
    80003054:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003056:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000305a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000305e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003062:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003066:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003068:	6f18                	ld	a4,24(a4)
    8000306a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000306e:	6928                	ld	a0,80(a0)
    80003070:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80003072:	00006717          	auipc	a4,0x6
    80003076:	02a70713          	addi	a4,a4,42 # 8000909c <userret>
    8000307a:	8f15                	sub	a4,a4,a3
    8000307c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000307e:	577d                	li	a4,-1
    80003080:	177e                	slli	a4,a4,0x3f
    80003082:	8d59                	or	a0,a0,a4
    80003084:	9782                	jalr	a5
}
    80003086:	60a2                	ld	ra,8(sp)
    80003088:	6402                	ld	s0,0(sp)
    8000308a:	0141                	addi	sp,sp,16
    8000308c:	8082                	ret

000000008000308e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000308e:	1101                	addi	sp,sp,-32
    80003090:	ec06                	sd	ra,24(sp)
    80003092:	e822                	sd	s0,16(sp)
    80003094:	e426                	sd	s1,8(sp)
    80003096:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80003098:	00061497          	auipc	s1,0x61
    8000309c:	50848493          	addi	s1,s1,1288 # 800645a0 <tickslock>
    800030a0:	8526                	mv	a0,s1
    800030a2:	ffffe097          	auipc	ra,0xffffe
    800030a6:	c74080e7          	jalr	-908(ra) # 80000d16 <acquire>
  ticks++;
    800030aa:	0000b517          	auipc	a0,0xb
    800030ae:	24650513          	addi	a0,a0,582 # 8000e2f0 <ticks>
    800030b2:	411c                	lw	a5,0(a0)
    800030b4:	2785                	addiw	a5,a5,1
    800030b6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800030b8:	fffff097          	auipc	ra,0xfffff
    800030bc:	6b4080e7          	jalr	1716(ra) # 8000276c <wakeup>
  release(&tickslock);
    800030c0:	8526                	mv	a0,s1
    800030c2:	ffffe097          	auipc	ra,0xffffe
    800030c6:	d04080e7          	jalr	-764(ra) # 80000dc6 <release>
}
    800030ca:	60e2                	ld	ra,24(sp)
    800030cc:	6442                	ld	s0,16(sp)
    800030ce:	64a2                	ld	s1,8(sp)
    800030d0:	6105                	addi	sp,sp,32
    800030d2:	8082                	ret

00000000800030d4 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    800030d4:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800030d8:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    800030da:	0a07db63          	bgez	a5,80003190 <devintr+0xbc>
{
    800030de:	1101                	addi	sp,sp,-32
    800030e0:	ec06                	sd	ra,24(sp)
    800030e2:	e822                	sd	s0,16(sp)
    800030e4:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    800030e6:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    800030ea:	46a5                	li	a3,9
    800030ec:	00d70c63          	beq	a4,a3,80003104 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    800030f0:	577d                	li	a4,-1
    800030f2:	177e                	slli	a4,a4,0x3f
    800030f4:	0705                	addi	a4,a4,1
    return 0;
    800030f6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800030f8:	06e78b63          	beq	a5,a4,8000316e <devintr+0x9a>
  }
}
    800030fc:	60e2                	ld	ra,24(sp)
    800030fe:	6442                	ld	s0,16(sp)
    80003100:	6105                	addi	sp,sp,32
    80003102:	8082                	ret
    80003104:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80003106:	00004097          	auipc	ra,0x4
    8000310a:	848080e7          	jalr	-1976(ra) # 8000694e <plic_claim>
    8000310e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80003110:	47a9                	li	a5,10
    80003112:	00f50c63          	beq	a0,a5,8000312a <devintr+0x56>
    } else if(irq == VIRTIO0_IRQ){
    80003116:	4785                	li	a5,1
    80003118:	02f50563          	beq	a0,a5,80003142 <devintr+0x6e>
    } else if (irq == VIRTIO1_IRQ) {
    8000311c:	4789                	li	a5,2
    8000311e:	02f50763          	beq	a0,a5,8000314c <devintr+0x78>
    return 1;
    80003122:	4505                	li	a0,1
    } else if(irq){
    80003124:	e89d                	bnez	s1,8000315a <devintr+0x86>
    80003126:	64a2                	ld	s1,8(sp)
    80003128:	bfd1                	j	800030fc <devintr+0x28>
      uartintr();
    8000312a:	ffffe097          	auipc	ra,0xffffe
    8000312e:	8d2080e7          	jalr	-1838(ra) # 800009fc <uartintr>
      plic_complete(irq);
    80003132:	8526                	mv	a0,s1
    80003134:	00004097          	auipc	ra,0x4
    80003138:	83e080e7          	jalr	-1986(ra) # 80006972 <plic_complete>
    return 1;
    8000313c:	4505                	li	a0,1
    8000313e:	64a2                	ld	s1,8(sp)
    80003140:	bf75                	j	800030fc <devintr+0x28>
      virtio_disk_intr();
    80003142:	00004097          	auipc	ra,0x4
    80003146:	d00080e7          	jalr	-768(ra) # 80006e42 <virtio_disk_intr>
    if(irq)
    8000314a:	b7e5                	j	80003132 <devintr+0x5e>
      receive_packet(temp, 0);
    8000314c:	4581                	li	a1,0
    8000314e:	4501                	li	a0,0
    80003150:	00004097          	auipc	ra,0x4
    80003154:	596080e7          	jalr	1430(ra) # 800076e6 <receive_packet>
    80003158:	bfe9                	j	80003132 <devintr+0x5e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000315a:	85a6                	mv	a1,s1
    8000315c:	00007517          	auipc	a0,0x7
    80003160:	1e450513          	addi	a0,a0,484 # 8000a340 <etext+0x340>
    80003164:	ffffd097          	auipc	ra,0xffffd
    80003168:	446080e7          	jalr	1094(ra) # 800005aa <printf>
    if(irq)
    8000316c:	b7d9                	j	80003132 <devintr+0x5e>
    if(cpuid() == 0){
    8000316e:	fffff097          	auipc	ra,0xfffff
    80003172:	cb8080e7          	jalr	-840(ra) # 80001e26 <cpuid>
    80003176:	c901                	beqz	a0,80003186 <devintr+0xb2>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003178:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000317c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000317e:	14479073          	csrw	sip,a5
    return 2;
    80003182:	4509                	li	a0,2
    80003184:	bfa5                	j	800030fc <devintr+0x28>
      clockintr();
    80003186:	00000097          	auipc	ra,0x0
    8000318a:	f08080e7          	jalr	-248(ra) # 8000308e <clockintr>
    8000318e:	b7ed                	j	80003178 <devintr+0xa4>
}
    80003190:	8082                	ret

0000000080003192 <usertrap>:
{
    80003192:	1101                	addi	sp,sp,-32
    80003194:	ec06                	sd	ra,24(sp)
    80003196:	e822                	sd	s0,16(sp)
    80003198:	e426                	sd	s1,8(sp)
    8000319a:	e04a                	sd	s2,0(sp)
    8000319c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000319e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800031a2:	1007f793          	andi	a5,a5,256
    800031a6:	e3b1                	bnez	a5,800031ea <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800031a8:	00003797          	auipc	a5,0x3
    800031ac:	69878793          	addi	a5,a5,1688 # 80006840 <kernelvec>
    800031b0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800031b4:	fffff097          	auipc	ra,0xfffff
    800031b8:	ca6080e7          	jalr	-858(ra) # 80001e5a <myproc>
    800031bc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800031be:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800031c0:	14102773          	csrr	a4,sepc
    800031c4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800031c6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800031ca:	47a1                	li	a5,8
    800031cc:	02f70763          	beq	a4,a5,800031fa <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	f04080e7          	jalr	-252(ra) # 800030d4 <devintr>
    800031d8:	892a                	mv	s2,a0
    800031da:	c151                	beqz	a0,8000325e <usertrap+0xcc>
  if(killed(p))
    800031dc:	8526                	mv	a0,s1
    800031de:	00000097          	auipc	ra,0x0
    800031e2:	950080e7          	jalr	-1712(ra) # 80002b2e <killed>
    800031e6:	c929                	beqz	a0,80003238 <usertrap+0xa6>
    800031e8:	a099                	j	8000322e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    800031ea:	00007517          	auipc	a0,0x7
    800031ee:	17650513          	addi	a0,a0,374 # 8000a360 <etext+0x360>
    800031f2:	ffffd097          	auipc	ra,0xffffd
    800031f6:	36e080e7          	jalr	878(ra) # 80000560 <panic>
    if(killed(p))
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	934080e7          	jalr	-1740(ra) # 80002b2e <killed>
    80003202:	e921                	bnez	a0,80003252 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80003204:	6cb8                	ld	a4,88(s1)
    80003206:	6f1c                	ld	a5,24(a4)
    80003208:	0791                	addi	a5,a5,4
    8000320a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000320c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003210:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003214:	10079073          	csrw	sstatus,a5
    syscall();
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	2cc080e7          	jalr	716(ra) # 800034e4 <syscall>
  if(killed(p))
    80003220:	8526                	mv	a0,s1
    80003222:	00000097          	auipc	ra,0x0
    80003226:	90c080e7          	jalr	-1780(ra) # 80002b2e <killed>
    8000322a:	c911                	beqz	a0,8000323e <usertrap+0xac>
    8000322c:	4901                	li	s2,0
    exit(-1);
    8000322e:	557d                	li	a0,-1
    80003230:	fffff097          	auipc	ra,0xfffff
    80003234:	6e2080e7          	jalr	1762(ra) # 80002912 <exit>
  if(which_dev == 2)
    80003238:	4789                	li	a5,2
    8000323a:	04f90f63          	beq	s2,a5,80003298 <usertrap+0x106>
  usertrapret();
    8000323e:	00000097          	auipc	ra,0x0
    80003242:	dba080e7          	jalr	-582(ra) # 80002ff8 <usertrapret>
}
    80003246:	60e2                	ld	ra,24(sp)
    80003248:	6442                	ld	s0,16(sp)
    8000324a:	64a2                	ld	s1,8(sp)
    8000324c:	6902                	ld	s2,0(sp)
    8000324e:	6105                	addi	sp,sp,32
    80003250:	8082                	ret
      exit(-1);
    80003252:	557d                	li	a0,-1
    80003254:	fffff097          	auipc	ra,0xfffff
    80003258:	6be080e7          	jalr	1726(ra) # 80002912 <exit>
    8000325c:	b765                	j	80003204 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000325e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003262:	5890                	lw	a2,48(s1)
    80003264:	00007517          	auipc	a0,0x7
    80003268:	11c50513          	addi	a0,a0,284 # 8000a380 <etext+0x380>
    8000326c:	ffffd097          	auipc	ra,0xffffd
    80003270:	33e080e7          	jalr	830(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003274:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003278:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000327c:	00007517          	auipc	a0,0x7
    80003280:	13450513          	addi	a0,a0,308 # 8000a3b0 <etext+0x3b0>
    80003284:	ffffd097          	auipc	ra,0xffffd
    80003288:	326080e7          	jalr	806(ra) # 800005aa <printf>
    setkilled(p);
    8000328c:	8526                	mv	a0,s1
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	874080e7          	jalr	-1932(ra) # 80002b02 <setkilled>
    80003296:	b769                	j	80003220 <usertrap+0x8e>
    yield();
    80003298:	fffff097          	auipc	ra,0xfffff
    8000329c:	434080e7          	jalr	1076(ra) # 800026cc <yield>
    800032a0:	bf79                	j	8000323e <usertrap+0xac>

00000000800032a2 <kerneltrap>:
{
    800032a2:	7179                	addi	sp,sp,-48
    800032a4:	f406                	sd	ra,40(sp)
    800032a6:	f022                	sd	s0,32(sp)
    800032a8:	ec26                	sd	s1,24(sp)
    800032aa:	e84a                	sd	s2,16(sp)
    800032ac:	e44e                	sd	s3,8(sp)
    800032ae:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800032b0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032b4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800032b8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800032bc:	1004f793          	andi	a5,s1,256
    800032c0:	cb85                	beqz	a5,800032f0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032c2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800032c6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800032c8:	ef85                	bnez	a5,80003300 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	e0a080e7          	jalr	-502(ra) # 800030d4 <devintr>
    800032d2:	cd1d                	beqz	a0,80003310 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800032d4:	4789                	li	a5,2
    800032d6:	06f50a63          	beq	a0,a5,8000334a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800032da:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800032de:	10049073          	csrw	sstatus,s1
}
    800032e2:	70a2                	ld	ra,40(sp)
    800032e4:	7402                	ld	s0,32(sp)
    800032e6:	64e2                	ld	s1,24(sp)
    800032e8:	6942                	ld	s2,16(sp)
    800032ea:	69a2                	ld	s3,8(sp)
    800032ec:	6145                	addi	sp,sp,48
    800032ee:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800032f0:	00007517          	auipc	a0,0x7
    800032f4:	0e050513          	addi	a0,a0,224 # 8000a3d0 <etext+0x3d0>
    800032f8:	ffffd097          	auipc	ra,0xffffd
    800032fc:	268080e7          	jalr	616(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    80003300:	00007517          	auipc	a0,0x7
    80003304:	0f850513          	addi	a0,a0,248 # 8000a3f8 <etext+0x3f8>
    80003308:	ffffd097          	auipc	ra,0xffffd
    8000330c:	258080e7          	jalr	600(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    80003310:	85ce                	mv	a1,s3
    80003312:	00007517          	auipc	a0,0x7
    80003316:	10650513          	addi	a0,a0,262 # 8000a418 <etext+0x418>
    8000331a:	ffffd097          	auipc	ra,0xffffd
    8000331e:	290080e7          	jalr	656(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003322:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003326:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000332a:	00007517          	auipc	a0,0x7
    8000332e:	0fe50513          	addi	a0,a0,254 # 8000a428 <etext+0x428>
    80003332:	ffffd097          	auipc	ra,0xffffd
    80003336:	278080e7          	jalr	632(ra) # 800005aa <printf>
    panic("kerneltrap");
    8000333a:	00007517          	auipc	a0,0x7
    8000333e:	10650513          	addi	a0,a0,262 # 8000a440 <etext+0x440>
    80003342:	ffffd097          	auipc	ra,0xffffd
    80003346:	21e080e7          	jalr	542(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000334a:	fffff097          	auipc	ra,0xfffff
    8000334e:	b10080e7          	jalr	-1264(ra) # 80001e5a <myproc>
    80003352:	d541                	beqz	a0,800032da <kerneltrap+0x38>
    80003354:	fffff097          	auipc	ra,0xfffff
    80003358:	b06080e7          	jalr	-1274(ra) # 80001e5a <myproc>
    8000335c:	4d18                	lw	a4,24(a0)
    8000335e:	4791                	li	a5,4
    80003360:	f6f71de3          	bne	a4,a5,800032da <kerneltrap+0x38>
    yield();
    80003364:	fffff097          	auipc	ra,0xfffff
    80003368:	368080e7          	jalr	872(ra) # 800026cc <yield>
    8000336c:	b7bd                	j	800032da <kerneltrap+0x38>

000000008000336e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000336e:	1101                	addi	sp,sp,-32
    80003370:	ec06                	sd	ra,24(sp)
    80003372:	e822                	sd	s0,16(sp)
    80003374:	e426                	sd	s1,8(sp)
    80003376:	1000                	addi	s0,sp,32
    80003378:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000337a:	fffff097          	auipc	ra,0xfffff
    8000337e:	ae0080e7          	jalr	-1312(ra) # 80001e5a <myproc>
  switch (n) {
    80003382:	4795                	li	a5,5
    80003384:	0497e163          	bltu	a5,s1,800033c6 <argraw+0x58>
    80003388:	048a                	slli	s1,s1,0x2
    8000338a:	00008717          	auipc	a4,0x8
    8000338e:	9ee70713          	addi	a4,a4,-1554 # 8000ad78 <states.0+0x30>
    80003392:	94ba                	add	s1,s1,a4
    80003394:	409c                	lw	a5,0(s1)
    80003396:	97ba                	add	a5,a5,a4
    80003398:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000339a:	6d3c                	ld	a5,88(a0)
    8000339c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000339e:	60e2                	ld	ra,24(sp)
    800033a0:	6442                	ld	s0,16(sp)
    800033a2:	64a2                	ld	s1,8(sp)
    800033a4:	6105                	addi	sp,sp,32
    800033a6:	8082                	ret
    return p->trapframe->a1;
    800033a8:	6d3c                	ld	a5,88(a0)
    800033aa:	7fa8                	ld	a0,120(a5)
    800033ac:	bfcd                	j	8000339e <argraw+0x30>
    return p->trapframe->a2;
    800033ae:	6d3c                	ld	a5,88(a0)
    800033b0:	63c8                	ld	a0,128(a5)
    800033b2:	b7f5                	j	8000339e <argraw+0x30>
    return p->trapframe->a3;
    800033b4:	6d3c                	ld	a5,88(a0)
    800033b6:	67c8                	ld	a0,136(a5)
    800033b8:	b7dd                	j	8000339e <argraw+0x30>
    return p->trapframe->a4;
    800033ba:	6d3c                	ld	a5,88(a0)
    800033bc:	6bc8                	ld	a0,144(a5)
    800033be:	b7c5                	j	8000339e <argraw+0x30>
    return p->trapframe->a5;
    800033c0:	6d3c                	ld	a5,88(a0)
    800033c2:	6fc8                	ld	a0,152(a5)
    800033c4:	bfe9                	j	8000339e <argraw+0x30>
  panic("argraw");
    800033c6:	00007517          	auipc	a0,0x7
    800033ca:	08a50513          	addi	a0,a0,138 # 8000a450 <etext+0x450>
    800033ce:	ffffd097          	auipc	ra,0xffffd
    800033d2:	192080e7          	jalr	402(ra) # 80000560 <panic>

00000000800033d6 <fetchaddr>:
{
    800033d6:	1101                	addi	sp,sp,-32
    800033d8:	ec06                	sd	ra,24(sp)
    800033da:	e822                	sd	s0,16(sp)
    800033dc:	e426                	sd	s1,8(sp)
    800033de:	e04a                	sd	s2,0(sp)
    800033e0:	1000                	addi	s0,sp,32
    800033e2:	84aa                	mv	s1,a0
    800033e4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	a74080e7          	jalr	-1420(ra) # 80001e5a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800033ee:	653c                	ld	a5,72(a0)
    800033f0:	02f4f863          	bgeu	s1,a5,80003420 <fetchaddr+0x4a>
    800033f4:	00848713          	addi	a4,s1,8
    800033f8:	02e7e663          	bltu	a5,a4,80003424 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800033fc:	46a1                	li	a3,8
    800033fe:	8626                	mv	a2,s1
    80003400:	85ca                	mv	a1,s2
    80003402:	6928                	ld	a0,80(a0)
    80003404:	ffffe097          	auipc	ra,0xffffe
    80003408:	78a080e7          	jalr	1930(ra) # 80001b8e <copyin>
    8000340c:	00a03533          	snez	a0,a0
    80003410:	40a0053b          	negw	a0,a0
}
    80003414:	60e2                	ld	ra,24(sp)
    80003416:	6442                	ld	s0,16(sp)
    80003418:	64a2                	ld	s1,8(sp)
    8000341a:	6902                	ld	s2,0(sp)
    8000341c:	6105                	addi	sp,sp,32
    8000341e:	8082                	ret
    return -1;
    80003420:	557d                	li	a0,-1
    80003422:	bfcd                	j	80003414 <fetchaddr+0x3e>
    80003424:	557d                	li	a0,-1
    80003426:	b7fd                	j	80003414 <fetchaddr+0x3e>

0000000080003428 <fetchstr>:
{
    80003428:	7179                	addi	sp,sp,-48
    8000342a:	f406                	sd	ra,40(sp)
    8000342c:	f022                	sd	s0,32(sp)
    8000342e:	ec26                	sd	s1,24(sp)
    80003430:	e84a                	sd	s2,16(sp)
    80003432:	e44e                	sd	s3,8(sp)
    80003434:	1800                	addi	s0,sp,48
    80003436:	892a                	mv	s2,a0
    80003438:	84ae                	mv	s1,a1
    8000343a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000343c:	fffff097          	auipc	ra,0xfffff
    80003440:	a1e080e7          	jalr	-1506(ra) # 80001e5a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003444:	86ce                	mv	a3,s3
    80003446:	864a                	mv	a2,s2
    80003448:	85a6                	mv	a1,s1
    8000344a:	6928                	ld	a0,80(a0)
    8000344c:	ffffe097          	auipc	ra,0xffffe
    80003450:	7d0080e7          	jalr	2000(ra) # 80001c1c <copyinstr>
    80003454:	00054e63          	bltz	a0,80003470 <fetchstr+0x48>
  return strlen(buf);
    80003458:	8526                	mv	a0,s1
    8000345a:	ffffe097          	auipc	ra,0xffffe
    8000345e:	b40080e7          	jalr	-1216(ra) # 80000f9a <strlen>
}
    80003462:	70a2                	ld	ra,40(sp)
    80003464:	7402                	ld	s0,32(sp)
    80003466:	64e2                	ld	s1,24(sp)
    80003468:	6942                	ld	s2,16(sp)
    8000346a:	69a2                	ld	s3,8(sp)
    8000346c:	6145                	addi	sp,sp,48
    8000346e:	8082                	ret
    return -1;
    80003470:	557d                	li	a0,-1
    80003472:	bfc5                	j	80003462 <fetchstr+0x3a>

0000000080003474 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003474:	1101                	addi	sp,sp,-32
    80003476:	ec06                	sd	ra,24(sp)
    80003478:	e822                	sd	s0,16(sp)
    8000347a:	e426                	sd	s1,8(sp)
    8000347c:	1000                	addi	s0,sp,32
    8000347e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003480:	00000097          	auipc	ra,0x0
    80003484:	eee080e7          	jalr	-274(ra) # 8000336e <argraw>
    80003488:	c088                	sw	a0,0(s1)
}
    8000348a:	60e2                	ld	ra,24(sp)
    8000348c:	6442                	ld	s0,16(sp)
    8000348e:	64a2                	ld	s1,8(sp)
    80003490:	6105                	addi	sp,sp,32
    80003492:	8082                	ret

0000000080003494 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80003494:	1101                	addi	sp,sp,-32
    80003496:	ec06                	sd	ra,24(sp)
    80003498:	e822                	sd	s0,16(sp)
    8000349a:	e426                	sd	s1,8(sp)
    8000349c:	1000                	addi	s0,sp,32
    8000349e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800034a0:	00000097          	auipc	ra,0x0
    800034a4:	ece080e7          	jalr	-306(ra) # 8000336e <argraw>
    800034a8:	e088                	sd	a0,0(s1)
}
    800034aa:	60e2                	ld	ra,24(sp)
    800034ac:	6442                	ld	s0,16(sp)
    800034ae:	64a2                	ld	s1,8(sp)
    800034b0:	6105                	addi	sp,sp,32
    800034b2:	8082                	ret

00000000800034b4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800034b4:	1101                	addi	sp,sp,-32
    800034b6:	ec06                	sd	ra,24(sp)
    800034b8:	e822                	sd	s0,16(sp)
    800034ba:	e426                	sd	s1,8(sp)
    800034bc:	e04a                	sd	s2,0(sp)
    800034be:	1000                	addi	s0,sp,32
    800034c0:	84ae                	mv	s1,a1
    800034c2:	8932                	mv	s2,a2
  *ip = argraw(n);
    800034c4:	00000097          	auipc	ra,0x0
    800034c8:	eaa080e7          	jalr	-342(ra) # 8000336e <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800034cc:	864a                	mv	a2,s2
    800034ce:	85a6                	mv	a1,s1
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	f58080e7          	jalr	-168(ra) # 80003428 <fetchstr>
}
    800034d8:	60e2                	ld	ra,24(sp)
    800034da:	6442                	ld	s0,16(sp)
    800034dc:	64a2                	ld	s1,8(sp)
    800034de:	6902                	ld	s2,0(sp)
    800034e0:	6105                	addi	sp,sp,32
    800034e2:	8082                	ret

00000000800034e4 <syscall>:
[SYS_connect]       sys_connect,
};

void
syscall(void)
{
    800034e4:	1101                	addi	sp,sp,-32
    800034e6:	ec06                	sd	ra,24(sp)
    800034e8:	e822                	sd	s0,16(sp)
    800034ea:	e426                	sd	s1,8(sp)
    800034ec:	e04a                	sd	s2,0(sp)
    800034ee:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800034f0:	fffff097          	auipc	ra,0xfffff
    800034f4:	96a080e7          	jalr	-1686(ra) # 80001e5a <myproc>
    800034f8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800034fa:	05853903          	ld	s2,88(a0)
    800034fe:	0a893783          	ld	a5,168(s2)
    80003502:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003506:	37fd                	addiw	a5,a5,-1
    80003508:	4775                	li	a4,29
    8000350a:	00f76f63          	bltu	a4,a5,80003528 <syscall+0x44>
    8000350e:	00369713          	slli	a4,a3,0x3
    80003512:	00008797          	auipc	a5,0x8
    80003516:	87e78793          	addi	a5,a5,-1922 # 8000ad90 <syscalls>
    8000351a:	97ba                	add	a5,a5,a4
    8000351c:	639c                	ld	a5,0(a5)
    8000351e:	c789                	beqz	a5,80003528 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003520:	9782                	jalr	a5
    80003522:	06a93823          	sd	a0,112(s2)
    80003526:	a839                	j	80003544 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003528:	15848613          	addi	a2,s1,344
    8000352c:	588c                	lw	a1,48(s1)
    8000352e:	00007517          	auipc	a0,0x7
    80003532:	f2a50513          	addi	a0,a0,-214 # 8000a458 <etext+0x458>
    80003536:	ffffd097          	auipc	ra,0xffffd
    8000353a:	074080e7          	jalr	116(ra) # 800005aa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000353e:	6cbc                	ld	a5,88(s1)
    80003540:	577d                	li	a4,-1
    80003542:	fbb8                	sd	a4,112(a5)
  }
}
    80003544:	60e2                	ld	ra,24(sp)
    80003546:	6442                	ld	s0,16(sp)
    80003548:	64a2                	ld	s1,8(sp)
    8000354a:	6902                	ld	s2,0(sp)
    8000354c:	6105                	addi	sp,sp,32
    8000354e:	8082                	ret

0000000080003550 <sys_exit>:
#include "memlayout.h"
#include "spinlock.h"
#include "sys/socket.h"
#include "proc.h"

uint64 sys_exit(void) {
    80003550:	1101                	addi	sp,sp,-32
    80003552:	ec06                	sd	ra,24(sp)
    80003554:	e822                	sd	s0,16(sp)
    80003556:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003558:	fec40593          	addi	a1,s0,-20
    8000355c:	4501                	li	a0,0
    8000355e:	00000097          	auipc	ra,0x0
    80003562:	f16080e7          	jalr	-234(ra) # 80003474 <argint>
  exit(n);
    80003566:	fec42503          	lw	a0,-20(s0)
    8000356a:	fffff097          	auipc	ra,0xfffff
    8000356e:	3a8080e7          	jalr	936(ra) # 80002912 <exit>
  return 0; // not reached
}
    80003572:	4501                	li	a0,0
    80003574:	60e2                	ld	ra,24(sp)
    80003576:	6442                	ld	s0,16(sp)
    80003578:	6105                	addi	sp,sp,32
    8000357a:	8082                	ret

000000008000357c <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    8000357c:	1141                	addi	sp,sp,-16
    8000357e:	e406                	sd	ra,8(sp)
    80003580:	e022                	sd	s0,0(sp)
    80003582:	0800                	addi	s0,sp,16
    80003584:	fffff097          	auipc	ra,0xfffff
    80003588:	8d6080e7          	jalr	-1834(ra) # 80001e5a <myproc>
    8000358c:	5908                	lw	a0,48(a0)
    8000358e:	60a2                	ld	ra,8(sp)
    80003590:	6402                	ld	s0,0(sp)
    80003592:	0141                	addi	sp,sp,16
    80003594:	8082                	ret

0000000080003596 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80003596:	1141                	addi	sp,sp,-16
    80003598:	e406                	sd	ra,8(sp)
    8000359a:	e022                	sd	s0,0(sp)
    8000359c:	0800                	addi	s0,sp,16
    8000359e:	fffff097          	auipc	ra,0xfffff
    800035a2:	cbe080e7          	jalr	-834(ra) # 8000225c <fork>
    800035a6:	60a2                	ld	ra,8(sp)
    800035a8:	6402                	ld	s0,0(sp)
    800035aa:	0141                	addi	sp,sp,16
    800035ac:	8082                	ret

00000000800035ae <sys_wait>:

uint64 sys_wait(void) {
    800035ae:	1101                	addi	sp,sp,-32
    800035b0:	ec06                	sd	ra,24(sp)
    800035b2:	e822                	sd	s0,16(sp)
    800035b4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800035b6:	fe840593          	addi	a1,s0,-24
    800035ba:	4501                	li	a0,0
    800035bc:	00000097          	auipc	ra,0x0
    800035c0:	ed8080e7          	jalr	-296(ra) # 80003494 <argaddr>
  return wait(p);
    800035c4:	fe843503          	ld	a0,-24(s0)
    800035c8:	fffff097          	auipc	ra,0xfffff
    800035cc:	6da080e7          	jalr	1754(ra) # 80002ca2 <wait>
}
    800035d0:	60e2                	ld	ra,24(sp)
    800035d2:	6442                	ld	s0,16(sp)
    800035d4:	6105                	addi	sp,sp,32
    800035d6:	8082                	ret

00000000800035d8 <sys_sbrk>:

uint64 sys_sbrk(void) {
    800035d8:	7179                	addi	sp,sp,-48
    800035da:	f406                	sd	ra,40(sp)
    800035dc:	f022                	sd	s0,32(sp)
    800035de:	ec26                	sd	s1,24(sp)
    800035e0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800035e2:	fdc40593          	addi	a1,s0,-36
    800035e6:	4501                	li	a0,0
    800035e8:	00000097          	auipc	ra,0x0
    800035ec:	e8c080e7          	jalr	-372(ra) # 80003474 <argint>
  addr = myproc()->sz;
    800035f0:	fffff097          	auipc	ra,0xfffff
    800035f4:	86a080e7          	jalr	-1942(ra) # 80001e5a <myproc>
    800035f8:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    800035fa:	fdc42503          	lw	a0,-36(s0)
    800035fe:	fffff097          	auipc	ra,0xfffff
    80003602:	bc8080e7          	jalr	-1080(ra) # 800021c6 <growproc>
    80003606:	00054863          	bltz	a0,80003616 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000360a:	8526                	mv	a0,s1
    8000360c:	70a2                	ld	ra,40(sp)
    8000360e:	7402                	ld	s0,32(sp)
    80003610:	64e2                	ld	s1,24(sp)
    80003612:	6145                	addi	sp,sp,48
    80003614:	8082                	ret
    return -1;
    80003616:	54fd                	li	s1,-1
    80003618:	bfcd                	j	8000360a <sys_sbrk+0x32>

000000008000361a <sys_sleep>:

uint64 sys_sleep(void) {
    8000361a:	7139                	addi	sp,sp,-64
    8000361c:	fc06                	sd	ra,56(sp)
    8000361e:	f822                	sd	s0,48(sp)
    80003620:	f04a                	sd	s2,32(sp)
    80003622:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003624:	fcc40593          	addi	a1,s0,-52
    80003628:	4501                	li	a0,0
    8000362a:	00000097          	auipc	ra,0x0
    8000362e:	e4a080e7          	jalr	-438(ra) # 80003474 <argint>
  acquire(&tickslock);
    80003632:	00061517          	auipc	a0,0x61
    80003636:	f6e50513          	addi	a0,a0,-146 # 800645a0 <tickslock>
    8000363a:	ffffd097          	auipc	ra,0xffffd
    8000363e:	6dc080e7          	jalr	1756(ra) # 80000d16 <acquire>
  ticks0 = ticks;
    80003642:	0000b917          	auipc	s2,0xb
    80003646:	cae92903          	lw	s2,-850(s2) # 8000e2f0 <ticks>
  while (ticks - ticks0 < n) {
    8000364a:	fcc42783          	lw	a5,-52(s0)
    8000364e:	c3b9                	beqz	a5,80003694 <sys_sleep+0x7a>
    80003650:	f426                	sd	s1,40(sp)
    80003652:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003654:	00061997          	auipc	s3,0x61
    80003658:	f4c98993          	addi	s3,s3,-180 # 800645a0 <tickslock>
    8000365c:	0000b497          	auipc	s1,0xb
    80003660:	c9448493          	addi	s1,s1,-876 # 8000e2f0 <ticks>
    if (killed(myproc())) {
    80003664:	ffffe097          	auipc	ra,0xffffe
    80003668:	7f6080e7          	jalr	2038(ra) # 80001e5a <myproc>
    8000366c:	fffff097          	auipc	ra,0xfffff
    80003670:	4c2080e7          	jalr	1218(ra) # 80002b2e <killed>
    80003674:	ed15                	bnez	a0,800036b0 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003676:	85ce                	mv	a1,s3
    80003678:	8526                	mv	a0,s1
    8000367a:	fffff097          	auipc	ra,0xfffff
    8000367e:	08e080e7          	jalr	142(ra) # 80002708 <sleep>
  while (ticks - ticks0 < n) {
    80003682:	409c                	lw	a5,0(s1)
    80003684:	412787bb          	subw	a5,a5,s2
    80003688:	fcc42703          	lw	a4,-52(s0)
    8000368c:	fce7ece3          	bltu	a5,a4,80003664 <sys_sleep+0x4a>
    80003690:	74a2                	ld	s1,40(sp)
    80003692:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003694:	00061517          	auipc	a0,0x61
    80003698:	f0c50513          	addi	a0,a0,-244 # 800645a0 <tickslock>
    8000369c:	ffffd097          	auipc	ra,0xffffd
    800036a0:	72a080e7          	jalr	1834(ra) # 80000dc6 <release>
  return 0;
    800036a4:	4501                	li	a0,0
}
    800036a6:	70e2                	ld	ra,56(sp)
    800036a8:	7442                	ld	s0,48(sp)
    800036aa:	7902                	ld	s2,32(sp)
    800036ac:	6121                	addi	sp,sp,64
    800036ae:	8082                	ret
      release(&tickslock);
    800036b0:	00061517          	auipc	a0,0x61
    800036b4:	ef050513          	addi	a0,a0,-272 # 800645a0 <tickslock>
    800036b8:	ffffd097          	auipc	ra,0xffffd
    800036bc:	70e080e7          	jalr	1806(ra) # 80000dc6 <release>
      return -1;
    800036c0:	557d                	li	a0,-1
    800036c2:	74a2                	ld	s1,40(sp)
    800036c4:	69e2                	ld	s3,24(sp)
    800036c6:	b7c5                	j	800036a6 <sys_sleep+0x8c>

00000000800036c8 <sys_kill>:

uint64 sys_kill(void) {
    800036c8:	1101                	addi	sp,sp,-32
    800036ca:	ec06                	sd	ra,24(sp)
    800036cc:	e822                	sd	s0,16(sp)
    800036ce:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800036d0:	fec40593          	addi	a1,s0,-20
    800036d4:	4501                	li	a0,0
    800036d6:	00000097          	auipc	ra,0x0
    800036da:	d9e080e7          	jalr	-610(ra) # 80003474 <argint>
  return kill(pid);
    800036de:	fec42503          	lw	a0,-20(s0)
    800036e2:	fffff097          	auipc	ra,0xfffff
    800036e6:	3ae080e7          	jalr	942(ra) # 80002a90 <kill>
}
    800036ea:	60e2                	ld	ra,24(sp)
    800036ec:	6442                	ld	s0,16(sp)
    800036ee:	6105                	addi	sp,sp,32
    800036f0:	8082                	ret

00000000800036f2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800036f2:	1101                	addi	sp,sp,-32
    800036f4:	ec06                	sd	ra,24(sp)
    800036f6:	e822                	sd	s0,16(sp)
    800036f8:	e426                	sd	s1,8(sp)
    800036fa:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800036fc:	00061517          	auipc	a0,0x61
    80003700:	ea450513          	addi	a0,a0,-348 # 800645a0 <tickslock>
    80003704:	ffffd097          	auipc	ra,0xffffd
    80003708:	612080e7          	jalr	1554(ra) # 80000d16 <acquire>
  xticks = ticks;
    8000370c:	0000b497          	auipc	s1,0xb
    80003710:	be44a483          	lw	s1,-1052(s1) # 8000e2f0 <ticks>
  release(&tickslock);
    80003714:	00061517          	auipc	a0,0x61
    80003718:	e8c50513          	addi	a0,a0,-372 # 800645a0 <tickslock>
    8000371c:	ffffd097          	auipc	ra,0xffffd
    80003720:	6aa080e7          	jalr	1706(ra) # 80000dc6 <release>
  return xticks;
}
    80003724:	02049513          	slli	a0,s1,0x20
    80003728:	9101                	srli	a0,a0,0x20
    8000372a:	60e2                	ld	ra,24(sp)
    8000372c:	6442                	ld	s0,16(sp)
    8000372e:	64a2                	ld	s1,8(sp)
    80003730:	6105                	addi	sp,sp,32
    80003732:	8082                	ret

0000000080003734 <sys_spoon>:

uint64 sys_spoon(void) {
    80003734:	1101                	addi	sp,sp,-32
    80003736:	ec06                	sd	ra,24(sp)
    80003738:	e822                	sd	s0,16(sp)
    8000373a:	1000                	addi	s0,sp,32
  // obtain the argument from the stack, we need some special handling
  uint64 addr;
  argaddr(0, &addr);
    8000373c:	fe840593          	addi	a1,s0,-24
    80003740:	4501                	li	a0,0
    80003742:	00000097          	auipc	ra,0x0
    80003746:	d52080e7          	jalr	-686(ra) # 80003494 <argaddr>
  return spoon((void *)addr);
    8000374a:	fe843503          	ld	a0,-24(s0)
    8000374e:	fffff097          	auipc	ra,0xfffff
    80003752:	7d8080e7          	jalr	2008(ra) # 80002f26 <spoon>
}
    80003756:	60e2                	ld	ra,24(sp)
    80003758:	6442                	ld	s0,16(sp)
    8000375a:	6105                	addi	sp,sp,32
    8000375c:	8082                	ret

000000008000375e <sys_create_thread>:

uint64 sys_create_thread(void *arg) {
    8000375e:	7179                	addi	sp,sp,-48
    80003760:	f406                	sd	ra,40(sp)
    80003762:	f022                	sd	s0,32(sp)
    80003764:	1800                	addi	s0,sp,48
  uint64 fn_addr, args_addr, stack_addr, exit_fn;
  argaddr(0, &fn_addr);
    80003766:	fe840593          	addi	a1,s0,-24
    8000376a:	4501                	li	a0,0
    8000376c:	00000097          	auipc	ra,0x0
    80003770:	d28080e7          	jalr	-728(ra) # 80003494 <argaddr>
  argaddr(1, &args_addr);
    80003774:	fe040593          	addi	a1,s0,-32
    80003778:	4505                	li	a0,1
    8000377a:	00000097          	auipc	ra,0x0
    8000377e:	d1a080e7          	jalr	-742(ra) # 80003494 <argaddr>
  argaddr(2, &stack_addr);
    80003782:	fd840593          	addi	a1,s0,-40
    80003786:	4509                	li	a0,2
    80003788:	00000097          	auipc	ra,0x0
    8000378c:	d0c080e7          	jalr	-756(ra) # 80003494 <argaddr>
  argaddr(3, &exit_fn);
    80003790:	fd040593          	addi	a1,s0,-48
    80003794:	450d                	li	a0,3
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	cfe080e7          	jalr	-770(ra) # 80003494 <argaddr>
  return create_thread((void *)fn_addr, (void *)args_addr, (void *)stack_addr,
    8000379e:	fd043683          	ld	a3,-48(s0)
    800037a2:	fd843603          	ld	a2,-40(s0)
    800037a6:	fe043583          	ld	a1,-32(s0)
    800037aa:	fe843503          	ld	a0,-24(s0)
    800037ae:	fffff097          	auipc	ra,0xfffff
    800037b2:	bf4080e7          	jalr	-1036(ra) # 800023a2 <create_thread>
                       (void *)exit_fn);
}
    800037b6:	70a2                	ld	ra,40(sp)
    800037b8:	7402                	ld	s0,32(sp)
    800037ba:	6145                	addi	sp,sp,48
    800037bc:	8082                	ret

00000000800037be <sys_join_thread>:

uint64 sys_join_thread(void *arg) {
    800037be:	1101                	addi	sp,sp,-32
    800037c0:	ec06                	sd	ra,24(sp)
    800037c2:	e822                	sd	s0,16(sp)
    800037c4:	1000                	addi	s0,sp,32
  uint64 thread_id, status_addr;
  argaddr(0, &thread_id);
    800037c6:	fe840593          	addi	a1,s0,-24
    800037ca:	4501                	li	a0,0
    800037cc:	00000097          	auipc	ra,0x0
    800037d0:	cc8080e7          	jalr	-824(ra) # 80003494 <argaddr>
  argaddr(1, &status_addr);
    800037d4:	fe040593          	addi	a1,s0,-32
    800037d8:	4505                	li	a0,1
    800037da:	00000097          	auipc	ra,0x0
    800037de:	cba080e7          	jalr	-838(ra) # 80003494 <argaddr>
  return join_thread(thread_id, status_addr);
    800037e2:	fe043583          	ld	a1,-32(s0)
    800037e6:	fe843503          	ld	a0,-24(s0)
    800037ea:	fffff097          	auipc	ra,0xfffff
    800037ee:	376080e7          	jalr	886(ra) # 80002b60 <join_thread>
}
    800037f2:	60e2                	ld	ra,24(sp)
    800037f4:	6442                	ld	s0,16(sp)
    800037f6:	6105                	addi	sp,sp,32
    800037f8:	8082                	ret

00000000800037fa <sys_thread_exit>:

uint64 sys_thread_exit(void *arg) {
    800037fa:	1101                	addi	sp,sp,-32
    800037fc:	ec06                	sd	ra,24(sp)
    800037fe:	e822                	sd	s0,16(sp)
    80003800:	1000                	addi	s0,sp,32
  uint64 status_addr;
  argaddr(0, &status_addr);
    80003802:	fe840593          	addi	a1,s0,-24
    80003806:	4501                	li	a0,0
    80003808:	00000097          	auipc	ra,0x0
    8000380c:	c8c080e7          	jalr	-884(ra) # 80003494 <argaddr>
  return thread_exit(status_addr);
    80003810:	fe843503          	ld	a0,-24(s0)
    80003814:	fffff097          	auipc	ra,0xfffff
    80003818:	028080e7          	jalr	40(ra) # 8000283c <thread_exit>
}
    8000381c:	60e2                	ld	ra,24(sp)
    8000381e:	6442                	ld	s0,16(sp)
    80003820:	6105                	addi	sp,sp,32
    80003822:	8082                	ret

0000000080003824 <sys_bind>:

uint64 sys_bind(void *arg) {
    80003824:	7139                	addi	sp,sp,-64
    80003826:	fc06                	sd	ra,56(sp)
    80003828:	f822                	sd	s0,48(sp)
    8000382a:	f426                	sd	s1,40(sp)
    8000382c:	0080                	addi	s0,sp,64
  uint64 address_family, protocol;
  struct sockaddr address;
  argaddr(0, &address_family);
    8000382e:	fd840593          	addi	a1,s0,-40
    80003832:	4501                	li	a0,0
    80003834:	00000097          	auipc	ra,0x0
    80003838:	c60080e7          	jalr	-928(ra) # 80003494 <argaddr>
  argaddr(1, (uint64 *)&address);
    8000383c:	fc040493          	addi	s1,s0,-64
    80003840:	85a6                	mv	a1,s1
    80003842:	4505                	li	a0,1
    80003844:	00000097          	auipc	ra,0x0
    80003848:	c50080e7          	jalr	-944(ra) # 80003494 <argaddr>
  argaddr(2, &protocol);
    8000384c:	fd040593          	addi	a1,s0,-48
    80003850:	4509                	li	a0,2
    80003852:	00000097          	auipc	ra,0x0
    80003856:	c42080e7          	jalr	-958(ra) # 80003494 <argaddr>
  return bind(address_family, &address, protocol);
    8000385a:	fd042603          	lw	a2,-48(s0)
    8000385e:	85a6                	mv	a1,s1
    80003860:	fd842503          	lw	a0,-40(s0)
    80003864:	00004097          	auipc	ra,0x4
    80003868:	07c080e7          	jalr	124(ra) # 800078e0 <bind>
}
    8000386c:	70e2                	ld	ra,56(sp)
    8000386e:	7442                	ld	s0,48(sp)
    80003870:	74a2                	ld	s1,40(sp)
    80003872:	6121                	addi	sp,sp,64
    80003874:	8082                	ret

0000000080003876 <sys_listen>:

uint64 sys_listen(void *arg) {
    80003876:	1101                	addi	sp,sp,-32
    80003878:	ec06                	sd	ra,24(sp)
    8000387a:	e822                	sd	s0,16(sp)
    8000387c:	1000                	addi	s0,sp,32
  uint64 socket, backlog;
  argaddr(0, &socket);
    8000387e:	fe840593          	addi	a1,s0,-24
    80003882:	4501                	li	a0,0
    80003884:	00000097          	auipc	ra,0x0
    80003888:	c10080e7          	jalr	-1008(ra) # 80003494 <argaddr>
  argaddr(1, &backlog);
    8000388c:	fe040593          	addi	a1,s0,-32
    80003890:	4505                	li	a0,1
    80003892:	00000097          	auipc	ra,0x0
    80003896:	c02080e7          	jalr	-1022(ra) # 80003494 <argaddr>
  return listen(socket, backlog);
    8000389a:	fe042583          	lw	a1,-32(s0)
    8000389e:	fe842503          	lw	a0,-24(s0)
    800038a2:	00004097          	auipc	ra,0x4
    800038a6:	208080e7          	jalr	520(ra) # 80007aaa <listen>
}
    800038aa:	60e2                	ld	ra,24(sp)
    800038ac:	6442                	ld	s0,16(sp)
    800038ae:	6105                	addi	sp,sp,32
    800038b0:	8082                	ret

00000000800038b2 <sys_accept>:

uint64 sys_accept(void *arg) {
    800038b2:	7139                	addi	sp,sp,-64
    800038b4:	fc06                	sd	ra,56(sp)
    800038b6:	f822                	sd	s0,48(sp)
    800038b8:	f426                	sd	s1,40(sp)
    800038ba:	0080                	addi	s0,sp,64
  uint64 socket;
  uint64 address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    800038bc:	fd840593          	addi	a1,s0,-40
    800038c0:	4501                	li	a0,0
    800038c2:	00000097          	auipc	ra,0x0
    800038c6:	bd2080e7          	jalr	-1070(ra) # 80003494 <argaddr>
  argaddr(1, (uint64 *)&address);
    800038ca:	fc040493          	addi	s1,s0,-64
    800038ce:	85a6                	mv	a1,s1
    800038d0:	4505                	li	a0,1
    800038d2:	00000097          	auipc	ra,0x0
    800038d6:	bc2080e7          	jalr	-1086(ra) # 80003494 <argaddr>
  argaddr(2, &address_len);
    800038da:	fd040593          	addi	a1,s0,-48
    800038de:	4509                	li	a0,2
    800038e0:	00000097          	auipc	ra,0x0
    800038e4:	bb4080e7          	jalr	-1100(ra) # 80003494 <argaddr>
  return accept(socket, &address, address_len);
    800038e8:	fd042603          	lw	a2,-48(s0)
    800038ec:	85a6                	mv	a1,s1
    800038ee:	fd842503          	lw	a0,-40(s0)
    800038f2:	00004097          	auipc	ra,0x4
    800038f6:	21a080e7          	jalr	538(ra) # 80007b0c <accept>
}
    800038fa:	70e2                	ld	ra,56(sp)
    800038fc:	7442                	ld	s0,48(sp)
    800038fe:	74a2                	ld	s1,40(sp)
    80003900:	6121                	addi	sp,sp,64
    80003902:	8082                	ret

0000000080003904 <sys_socket>:

uint64 sys_socket(void *arg) {
    80003904:	7179                	addi	sp,sp,-48
    80003906:	f406                	sd	ra,40(sp)
    80003908:	f022                	sd	s0,32(sp)
    8000390a:	1800                	addi	s0,sp,48
  uint64 address_family, address_socktype, protocol;
  argaddr(0, &address_family);
    8000390c:	fe840593          	addi	a1,s0,-24
    80003910:	4501                	li	a0,0
    80003912:	00000097          	auipc	ra,0x0
    80003916:	b82080e7          	jalr	-1150(ra) # 80003494 <argaddr>
  argaddr(1, &address_socktype);
    8000391a:	fe040593          	addi	a1,s0,-32
    8000391e:	4505                	li	a0,1
    80003920:	00000097          	auipc	ra,0x0
    80003924:	b74080e7          	jalr	-1164(ra) # 80003494 <argaddr>
  argaddr(2, &protocol);
    80003928:	fd840593          	addi	a1,s0,-40
    8000392c:	4509                	li	a0,2
    8000392e:	00000097          	auipc	ra,0x0
    80003932:	b66080e7          	jalr	-1178(ra) # 80003494 <argaddr>
  return socket(address_family, address_socktype, protocol);
    80003936:	fd842603          	lw	a2,-40(s0)
    8000393a:	fe042583          	lw	a1,-32(s0)
    8000393e:	fe842503          	lw	a0,-24(s0)
    80003942:	00004097          	auipc	ra,0x4
    80003946:	2f6080e7          	jalr	758(ra) # 80007c38 <socket>
}
    8000394a:	70a2                	ld	ra,40(sp)
    8000394c:	7402                	ld	s0,32(sp)
    8000394e:	6145                	addi	sp,sp,48
    80003950:	8082                	ret

0000000080003952 <sys_connect>:

uint64 sys_connect(void *arg) {
    80003952:	7139                	addi	sp,sp,-64
    80003954:	fc06                	sd	ra,56(sp)
    80003956:	f822                	sd	s0,48(sp)
    80003958:	f426                	sd	s1,40(sp)
    8000395a:	0080                	addi	s0,sp,64
  uint64 socket, address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    8000395c:	fd840593          	addi	a1,s0,-40
    80003960:	4501                	li	a0,0
    80003962:	00000097          	auipc	ra,0x0
    80003966:	b32080e7          	jalr	-1230(ra) # 80003494 <argaddr>
  argaddr(1, (uint64 *)&address);
    8000396a:	fc040493          	addi	s1,s0,-64
    8000396e:	85a6                	mv	a1,s1
    80003970:	4505                	li	a0,1
    80003972:	00000097          	auipc	ra,0x0
    80003976:	b22080e7          	jalr	-1246(ra) # 80003494 <argaddr>
  argaddr(2, &address_len);
    8000397a:	fd040593          	addi	a1,s0,-48
    8000397e:	4509                	li	a0,2
    80003980:	00000097          	auipc	ra,0x0
    80003984:	b14080e7          	jalr	-1260(ra) # 80003494 <argaddr>
  return connect(socket, &address, address_len);
    80003988:	fd042603          	lw	a2,-48(s0)
    8000398c:	85a6                	mv	a1,s1
    8000398e:	fd842503          	lw	a0,-40(s0)
    80003992:	00004097          	auipc	ra,0x4
    80003996:	24a080e7          	jalr	586(ra) # 80007bdc <connect>
}
    8000399a:	70e2                	ld	ra,56(sp)
    8000399c:	7442                	ld	s0,48(sp)
    8000399e:	74a2                	ld	s1,40(sp)
    800039a0:	6121                	addi	sp,sp,64
    800039a2:	8082                	ret

00000000800039a4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800039a4:	7179                	addi	sp,sp,-48
    800039a6:	f406                	sd	ra,40(sp)
    800039a8:	f022                	sd	s0,32(sp)
    800039aa:	ec26                	sd	s1,24(sp)
    800039ac:	e84a                	sd	s2,16(sp)
    800039ae:	e44e                	sd	s3,8(sp)
    800039b0:	e052                	sd	s4,0(sp)
    800039b2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800039b4:	00007597          	auipc	a1,0x7
    800039b8:	ac458593          	addi	a1,a1,-1340 # 8000a478 <etext+0x478>
    800039bc:	00061517          	auipc	a0,0x61
    800039c0:	bfc50513          	addi	a0,a0,-1028 # 800645b8 <bcache>
    800039c4:	ffffd097          	auipc	ra,0xffffd
    800039c8:	2be080e7          	jalr	702(ra) # 80000c82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800039cc:	00069797          	auipc	a5,0x69
    800039d0:	bec78793          	addi	a5,a5,-1044 # 8006c5b8 <bcache+0x8000>
    800039d4:	00069717          	auipc	a4,0x69
    800039d8:	e4c70713          	addi	a4,a4,-436 # 8006c820 <bcache+0x8268>
    800039dc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800039e0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800039e4:	00061497          	auipc	s1,0x61
    800039e8:	bec48493          	addi	s1,s1,-1044 # 800645d0 <bcache+0x18>
    b->next = bcache.head.next;
    800039ec:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800039ee:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800039f0:	00007a17          	auipc	s4,0x7
    800039f4:	a90a0a13          	addi	s4,s4,-1392 # 8000a480 <etext+0x480>
    b->next = bcache.head.next;
    800039f8:	2b893783          	ld	a5,696(s2)
    800039fc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800039fe:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003a02:	85d2                	mv	a1,s4
    80003a04:	01048513          	addi	a0,s1,16
    80003a08:	00001097          	auipc	ra,0x1
    80003a0c:	4e4080e7          	jalr	1252(ra) # 80004eec <initsleeplock>
    bcache.head.next->prev = b;
    80003a10:	2b893783          	ld	a5,696(s2)
    80003a14:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003a16:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003a1a:	45848493          	addi	s1,s1,1112
    80003a1e:	fd349de3          	bne	s1,s3,800039f8 <binit+0x54>
  }
}
    80003a22:	70a2                	ld	ra,40(sp)
    80003a24:	7402                	ld	s0,32(sp)
    80003a26:	64e2                	ld	s1,24(sp)
    80003a28:	6942                	ld	s2,16(sp)
    80003a2a:	69a2                	ld	s3,8(sp)
    80003a2c:	6a02                	ld	s4,0(sp)
    80003a2e:	6145                	addi	sp,sp,48
    80003a30:	8082                	ret

0000000080003a32 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003a32:	7179                	addi	sp,sp,-48
    80003a34:	f406                	sd	ra,40(sp)
    80003a36:	f022                	sd	s0,32(sp)
    80003a38:	ec26                	sd	s1,24(sp)
    80003a3a:	e84a                	sd	s2,16(sp)
    80003a3c:	e44e                	sd	s3,8(sp)
    80003a3e:	1800                	addi	s0,sp,48
    80003a40:	892a                	mv	s2,a0
    80003a42:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003a44:	00061517          	auipc	a0,0x61
    80003a48:	b7450513          	addi	a0,a0,-1164 # 800645b8 <bcache>
    80003a4c:	ffffd097          	auipc	ra,0xffffd
    80003a50:	2ca080e7          	jalr	714(ra) # 80000d16 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003a54:	00069497          	auipc	s1,0x69
    80003a58:	e1c4b483          	ld	s1,-484(s1) # 8006c870 <bcache+0x82b8>
    80003a5c:	00069797          	auipc	a5,0x69
    80003a60:	dc478793          	addi	a5,a5,-572 # 8006c820 <bcache+0x8268>
    80003a64:	02f48f63          	beq	s1,a5,80003aa2 <bread+0x70>
    80003a68:	873e                	mv	a4,a5
    80003a6a:	a021                	j	80003a72 <bread+0x40>
    80003a6c:	68a4                	ld	s1,80(s1)
    80003a6e:	02e48a63          	beq	s1,a4,80003aa2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003a72:	449c                	lw	a5,8(s1)
    80003a74:	ff279ce3          	bne	a5,s2,80003a6c <bread+0x3a>
    80003a78:	44dc                	lw	a5,12(s1)
    80003a7a:	ff3799e3          	bne	a5,s3,80003a6c <bread+0x3a>
      b->refcnt++;
    80003a7e:	40bc                	lw	a5,64(s1)
    80003a80:	2785                	addiw	a5,a5,1
    80003a82:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003a84:	00061517          	auipc	a0,0x61
    80003a88:	b3450513          	addi	a0,a0,-1228 # 800645b8 <bcache>
    80003a8c:	ffffd097          	auipc	ra,0xffffd
    80003a90:	33a080e7          	jalr	826(ra) # 80000dc6 <release>
      acquiresleep(&b->lock);
    80003a94:	01048513          	addi	a0,s1,16
    80003a98:	00001097          	auipc	ra,0x1
    80003a9c:	48e080e7          	jalr	1166(ra) # 80004f26 <acquiresleep>
      return b;
    80003aa0:	a8b9                	j	80003afe <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003aa2:	00069497          	auipc	s1,0x69
    80003aa6:	dc64b483          	ld	s1,-570(s1) # 8006c868 <bcache+0x82b0>
    80003aaa:	00069797          	auipc	a5,0x69
    80003aae:	d7678793          	addi	a5,a5,-650 # 8006c820 <bcache+0x8268>
    80003ab2:	00f48863          	beq	s1,a5,80003ac2 <bread+0x90>
    80003ab6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003ab8:	40bc                	lw	a5,64(s1)
    80003aba:	cf81                	beqz	a5,80003ad2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003abc:	64a4                	ld	s1,72(s1)
    80003abe:	fee49de3          	bne	s1,a4,80003ab8 <bread+0x86>
  panic("bget: no buffers");
    80003ac2:	00007517          	auipc	a0,0x7
    80003ac6:	9c650513          	addi	a0,a0,-1594 # 8000a488 <etext+0x488>
    80003aca:	ffffd097          	auipc	ra,0xffffd
    80003ace:	a96080e7          	jalr	-1386(ra) # 80000560 <panic>
      b->dev = dev;
    80003ad2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003ad6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003ada:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003ade:	4785                	li	a5,1
    80003ae0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003ae2:	00061517          	auipc	a0,0x61
    80003ae6:	ad650513          	addi	a0,a0,-1322 # 800645b8 <bcache>
    80003aea:	ffffd097          	auipc	ra,0xffffd
    80003aee:	2dc080e7          	jalr	732(ra) # 80000dc6 <release>
      acquiresleep(&b->lock);
    80003af2:	01048513          	addi	a0,s1,16
    80003af6:	00001097          	auipc	ra,0x1
    80003afa:	430080e7          	jalr	1072(ra) # 80004f26 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003afe:	409c                	lw	a5,0(s1)
    80003b00:	cb89                	beqz	a5,80003b12 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003b02:	8526                	mv	a0,s1
    80003b04:	70a2                	ld	ra,40(sp)
    80003b06:	7402                	ld	s0,32(sp)
    80003b08:	64e2                	ld	s1,24(sp)
    80003b0a:	6942                	ld	s2,16(sp)
    80003b0c:	69a2                	ld	s3,8(sp)
    80003b0e:	6145                	addi	sp,sp,48
    80003b10:	8082                	ret
    virtio_disk_rw(b, 0);
    80003b12:	4581                	li	a1,0
    80003b14:	8526                	mv	a0,s1
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	104080e7          	jalr	260(ra) # 80006c1a <virtio_disk_rw>
    b->valid = 1;
    80003b1e:	4785                	li	a5,1
    80003b20:	c09c                	sw	a5,0(s1)
  return b;
    80003b22:	b7c5                	j	80003b02 <bread+0xd0>

0000000080003b24 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003b24:	1101                	addi	sp,sp,-32
    80003b26:	ec06                	sd	ra,24(sp)
    80003b28:	e822                	sd	s0,16(sp)
    80003b2a:	e426                	sd	s1,8(sp)
    80003b2c:	1000                	addi	s0,sp,32
    80003b2e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003b30:	0541                	addi	a0,a0,16
    80003b32:	00001097          	auipc	ra,0x1
    80003b36:	48e080e7          	jalr	1166(ra) # 80004fc0 <holdingsleep>
    80003b3a:	cd01                	beqz	a0,80003b52 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003b3c:	4585                	li	a1,1
    80003b3e:	8526                	mv	a0,s1
    80003b40:	00003097          	auipc	ra,0x3
    80003b44:	0da080e7          	jalr	218(ra) # 80006c1a <virtio_disk_rw>
}
    80003b48:	60e2                	ld	ra,24(sp)
    80003b4a:	6442                	ld	s0,16(sp)
    80003b4c:	64a2                	ld	s1,8(sp)
    80003b4e:	6105                	addi	sp,sp,32
    80003b50:	8082                	ret
    panic("bwrite");
    80003b52:	00007517          	auipc	a0,0x7
    80003b56:	94e50513          	addi	a0,a0,-1714 # 8000a4a0 <etext+0x4a0>
    80003b5a:	ffffd097          	auipc	ra,0xffffd
    80003b5e:	a06080e7          	jalr	-1530(ra) # 80000560 <panic>

0000000080003b62 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003b62:	1101                	addi	sp,sp,-32
    80003b64:	ec06                	sd	ra,24(sp)
    80003b66:	e822                	sd	s0,16(sp)
    80003b68:	e426                	sd	s1,8(sp)
    80003b6a:	e04a                	sd	s2,0(sp)
    80003b6c:	1000                	addi	s0,sp,32
    80003b6e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003b70:	01050913          	addi	s2,a0,16
    80003b74:	854a                	mv	a0,s2
    80003b76:	00001097          	auipc	ra,0x1
    80003b7a:	44a080e7          	jalr	1098(ra) # 80004fc0 <holdingsleep>
    80003b7e:	c535                	beqz	a0,80003bea <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003b80:	854a                	mv	a0,s2
    80003b82:	00001097          	auipc	ra,0x1
    80003b86:	3fa080e7          	jalr	1018(ra) # 80004f7c <releasesleep>

  acquire(&bcache.lock);
    80003b8a:	00061517          	auipc	a0,0x61
    80003b8e:	a2e50513          	addi	a0,a0,-1490 # 800645b8 <bcache>
    80003b92:	ffffd097          	auipc	ra,0xffffd
    80003b96:	184080e7          	jalr	388(ra) # 80000d16 <acquire>
  b->refcnt--;
    80003b9a:	40bc                	lw	a5,64(s1)
    80003b9c:	37fd                	addiw	a5,a5,-1
    80003b9e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003ba0:	e79d                	bnez	a5,80003bce <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003ba2:	68b8                	ld	a4,80(s1)
    80003ba4:	64bc                	ld	a5,72(s1)
    80003ba6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003ba8:	68b8                	ld	a4,80(s1)
    80003baa:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003bac:	00069797          	auipc	a5,0x69
    80003bb0:	a0c78793          	addi	a5,a5,-1524 # 8006c5b8 <bcache+0x8000>
    80003bb4:	2b87b703          	ld	a4,696(a5)
    80003bb8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003bba:	00069717          	auipc	a4,0x69
    80003bbe:	c6670713          	addi	a4,a4,-922 # 8006c820 <bcache+0x8268>
    80003bc2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003bc4:	2b87b703          	ld	a4,696(a5)
    80003bc8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003bca:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003bce:	00061517          	auipc	a0,0x61
    80003bd2:	9ea50513          	addi	a0,a0,-1558 # 800645b8 <bcache>
    80003bd6:	ffffd097          	auipc	ra,0xffffd
    80003bda:	1f0080e7          	jalr	496(ra) # 80000dc6 <release>
}
    80003bde:	60e2                	ld	ra,24(sp)
    80003be0:	6442                	ld	s0,16(sp)
    80003be2:	64a2                	ld	s1,8(sp)
    80003be4:	6902                	ld	s2,0(sp)
    80003be6:	6105                	addi	sp,sp,32
    80003be8:	8082                	ret
    panic("brelse");
    80003bea:	00007517          	auipc	a0,0x7
    80003bee:	8be50513          	addi	a0,a0,-1858 # 8000a4a8 <etext+0x4a8>
    80003bf2:	ffffd097          	auipc	ra,0xffffd
    80003bf6:	96e080e7          	jalr	-1682(ra) # 80000560 <panic>

0000000080003bfa <bpin>:

void
bpin(struct buf *b) {
    80003bfa:	1101                	addi	sp,sp,-32
    80003bfc:	ec06                	sd	ra,24(sp)
    80003bfe:	e822                	sd	s0,16(sp)
    80003c00:	e426                	sd	s1,8(sp)
    80003c02:	1000                	addi	s0,sp,32
    80003c04:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003c06:	00061517          	auipc	a0,0x61
    80003c0a:	9b250513          	addi	a0,a0,-1614 # 800645b8 <bcache>
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	108080e7          	jalr	264(ra) # 80000d16 <acquire>
  b->refcnt++;
    80003c16:	40bc                	lw	a5,64(s1)
    80003c18:	2785                	addiw	a5,a5,1
    80003c1a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003c1c:	00061517          	auipc	a0,0x61
    80003c20:	99c50513          	addi	a0,a0,-1636 # 800645b8 <bcache>
    80003c24:	ffffd097          	auipc	ra,0xffffd
    80003c28:	1a2080e7          	jalr	418(ra) # 80000dc6 <release>
}
    80003c2c:	60e2                	ld	ra,24(sp)
    80003c2e:	6442                	ld	s0,16(sp)
    80003c30:	64a2                	ld	s1,8(sp)
    80003c32:	6105                	addi	sp,sp,32
    80003c34:	8082                	ret

0000000080003c36 <bunpin>:

void
bunpin(struct buf *b) {
    80003c36:	1101                	addi	sp,sp,-32
    80003c38:	ec06                	sd	ra,24(sp)
    80003c3a:	e822                	sd	s0,16(sp)
    80003c3c:	e426                	sd	s1,8(sp)
    80003c3e:	1000                	addi	s0,sp,32
    80003c40:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003c42:	00061517          	auipc	a0,0x61
    80003c46:	97650513          	addi	a0,a0,-1674 # 800645b8 <bcache>
    80003c4a:	ffffd097          	auipc	ra,0xffffd
    80003c4e:	0cc080e7          	jalr	204(ra) # 80000d16 <acquire>
  b->refcnt--;
    80003c52:	40bc                	lw	a5,64(s1)
    80003c54:	37fd                	addiw	a5,a5,-1
    80003c56:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003c58:	00061517          	auipc	a0,0x61
    80003c5c:	96050513          	addi	a0,a0,-1696 # 800645b8 <bcache>
    80003c60:	ffffd097          	auipc	ra,0xffffd
    80003c64:	166080e7          	jalr	358(ra) # 80000dc6 <release>
}
    80003c68:	60e2                	ld	ra,24(sp)
    80003c6a:	6442                	ld	s0,16(sp)
    80003c6c:	64a2                	ld	s1,8(sp)
    80003c6e:	6105                	addi	sp,sp,32
    80003c70:	8082                	ret

0000000080003c72 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003c72:	1101                	addi	sp,sp,-32
    80003c74:	ec06                	sd	ra,24(sp)
    80003c76:	e822                	sd	s0,16(sp)
    80003c78:	e426                	sd	s1,8(sp)
    80003c7a:	e04a                	sd	s2,0(sp)
    80003c7c:	1000                	addi	s0,sp,32
    80003c7e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003c80:	00d5d79b          	srliw	a5,a1,0xd
    80003c84:	00069597          	auipc	a1,0x69
    80003c88:	0105a583          	lw	a1,16(a1) # 8006cc94 <sb+0x1c>
    80003c8c:	9dbd                	addw	a1,a1,a5
    80003c8e:	00000097          	auipc	ra,0x0
    80003c92:	da4080e7          	jalr	-604(ra) # 80003a32 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003c96:	0074f713          	andi	a4,s1,7
    80003c9a:	4785                	li	a5,1
    80003c9c:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003ca0:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003ca2:	90d9                	srli	s1,s1,0x36
    80003ca4:	00950733          	add	a4,a0,s1
    80003ca8:	05874703          	lbu	a4,88(a4)
    80003cac:	00e7f6b3          	and	a3,a5,a4
    80003cb0:	c69d                	beqz	a3,80003cde <bfree+0x6c>
    80003cb2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003cb4:	94aa                	add	s1,s1,a0
    80003cb6:	fff7c793          	not	a5,a5
    80003cba:	8f7d                	and	a4,a4,a5
    80003cbc:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003cc0:	00001097          	auipc	ra,0x1
    80003cc4:	148080e7          	jalr	328(ra) # 80004e08 <log_write>
  brelse(bp);
    80003cc8:	854a                	mv	a0,s2
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	e98080e7          	jalr	-360(ra) # 80003b62 <brelse>
}
    80003cd2:	60e2                	ld	ra,24(sp)
    80003cd4:	6442                	ld	s0,16(sp)
    80003cd6:	64a2                	ld	s1,8(sp)
    80003cd8:	6902                	ld	s2,0(sp)
    80003cda:	6105                	addi	sp,sp,32
    80003cdc:	8082                	ret
    panic("freeing free block");
    80003cde:	00006517          	auipc	a0,0x6
    80003ce2:	7d250513          	addi	a0,a0,2002 # 8000a4b0 <etext+0x4b0>
    80003ce6:	ffffd097          	auipc	ra,0xffffd
    80003cea:	87a080e7          	jalr	-1926(ra) # 80000560 <panic>

0000000080003cee <balloc>:
{
    80003cee:	715d                	addi	sp,sp,-80
    80003cf0:	e486                	sd	ra,72(sp)
    80003cf2:	e0a2                	sd	s0,64(sp)
    80003cf4:	fc26                	sd	s1,56(sp)
    80003cf6:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003cf8:	00069797          	auipc	a5,0x69
    80003cfc:	f847a783          	lw	a5,-124(a5) # 8006cc7c <sb+0x4>
    80003d00:	10078863          	beqz	a5,80003e10 <balloc+0x122>
    80003d04:	f84a                	sd	s2,48(sp)
    80003d06:	f44e                	sd	s3,40(sp)
    80003d08:	f052                	sd	s4,32(sp)
    80003d0a:	ec56                	sd	s5,24(sp)
    80003d0c:	e85a                	sd	s6,16(sp)
    80003d0e:	e45e                	sd	s7,8(sp)
    80003d10:	e062                	sd	s8,0(sp)
    80003d12:	8baa                	mv	s7,a0
    80003d14:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003d16:	00069b17          	auipc	s6,0x69
    80003d1a:	f62b0b13          	addi	s6,s6,-158 # 8006cc78 <sb>
      m = 1 << (bi % 8);
    80003d1e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003d20:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003d22:	6c09                	lui	s8,0x2
    80003d24:	a049                	j	80003da6 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003d26:	97ca                	add	a5,a5,s2
    80003d28:	8e55                	or	a2,a2,a3
    80003d2a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003d2e:	854a                	mv	a0,s2
    80003d30:	00001097          	auipc	ra,0x1
    80003d34:	0d8080e7          	jalr	216(ra) # 80004e08 <log_write>
        brelse(bp);
    80003d38:	854a                	mv	a0,s2
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	e28080e7          	jalr	-472(ra) # 80003b62 <brelse>
  bp = bread(dev, bno);
    80003d42:	85a6                	mv	a1,s1
    80003d44:	855e                	mv	a0,s7
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	cec080e7          	jalr	-788(ra) # 80003a32 <bread>
    80003d4e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003d50:	40000613          	li	a2,1024
    80003d54:	4581                	li	a1,0
    80003d56:	05850513          	addi	a0,a0,88
    80003d5a:	ffffd097          	auipc	ra,0xffffd
    80003d5e:	0b4080e7          	jalr	180(ra) # 80000e0e <memset>
  log_write(bp);
    80003d62:	854a                	mv	a0,s2
    80003d64:	00001097          	auipc	ra,0x1
    80003d68:	0a4080e7          	jalr	164(ra) # 80004e08 <log_write>
  brelse(bp);
    80003d6c:	854a                	mv	a0,s2
    80003d6e:	00000097          	auipc	ra,0x0
    80003d72:	df4080e7          	jalr	-524(ra) # 80003b62 <brelse>
}
    80003d76:	7942                	ld	s2,48(sp)
    80003d78:	79a2                	ld	s3,40(sp)
    80003d7a:	7a02                	ld	s4,32(sp)
    80003d7c:	6ae2                	ld	s5,24(sp)
    80003d7e:	6b42                	ld	s6,16(sp)
    80003d80:	6ba2                	ld	s7,8(sp)
    80003d82:	6c02                	ld	s8,0(sp)
}
    80003d84:	8526                	mv	a0,s1
    80003d86:	60a6                	ld	ra,72(sp)
    80003d88:	6406                	ld	s0,64(sp)
    80003d8a:	74e2                	ld	s1,56(sp)
    80003d8c:	6161                	addi	sp,sp,80
    80003d8e:	8082                	ret
    brelse(bp);
    80003d90:	854a                	mv	a0,s2
    80003d92:	00000097          	auipc	ra,0x0
    80003d96:	dd0080e7          	jalr	-560(ra) # 80003b62 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003d9a:	015c0abb          	addw	s5,s8,s5
    80003d9e:	004b2783          	lw	a5,4(s6)
    80003da2:	06faf063          	bgeu	s5,a5,80003e02 <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    80003da6:	41fad79b          	sraiw	a5,s5,0x1f
    80003daa:	0137d79b          	srliw	a5,a5,0x13
    80003dae:	015787bb          	addw	a5,a5,s5
    80003db2:	40d7d79b          	sraiw	a5,a5,0xd
    80003db6:	01cb2583          	lw	a1,28(s6)
    80003dba:	9dbd                	addw	a1,a1,a5
    80003dbc:	855e                	mv	a0,s7
    80003dbe:	00000097          	auipc	ra,0x0
    80003dc2:	c74080e7          	jalr	-908(ra) # 80003a32 <bread>
    80003dc6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003dc8:	004b2503          	lw	a0,4(s6)
    80003dcc:	84d6                	mv	s1,s5
    80003dce:	4701                	li	a4,0
    80003dd0:	fca4f0e3          	bgeu	s1,a0,80003d90 <balloc+0xa2>
      m = 1 << (bi % 8);
    80003dd4:	00777693          	andi	a3,a4,7
    80003dd8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003ddc:	41f7579b          	sraiw	a5,a4,0x1f
    80003de0:	01d7d79b          	srliw	a5,a5,0x1d
    80003de4:	9fb9                	addw	a5,a5,a4
    80003de6:	4037d79b          	sraiw	a5,a5,0x3
    80003dea:	00f90633          	add	a2,s2,a5
    80003dee:	05864603          	lbu	a2,88(a2)
    80003df2:	00c6f5b3          	and	a1,a3,a2
    80003df6:	d985                	beqz	a1,80003d26 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003df8:	2705                	addiw	a4,a4,1
    80003dfa:	2485                	addiw	s1,s1,1
    80003dfc:	fd471ae3          	bne	a4,s4,80003dd0 <balloc+0xe2>
    80003e00:	bf41                	j	80003d90 <balloc+0xa2>
    80003e02:	7942                	ld	s2,48(sp)
    80003e04:	79a2                	ld	s3,40(sp)
    80003e06:	7a02                	ld	s4,32(sp)
    80003e08:	6ae2                	ld	s5,24(sp)
    80003e0a:	6b42                	ld	s6,16(sp)
    80003e0c:	6ba2                	ld	s7,8(sp)
    80003e0e:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003e10:	00006517          	auipc	a0,0x6
    80003e14:	6b850513          	addi	a0,a0,1720 # 8000a4c8 <etext+0x4c8>
    80003e18:	ffffc097          	auipc	ra,0xffffc
    80003e1c:	792080e7          	jalr	1938(ra) # 800005aa <printf>
  return 0;
    80003e20:	4481                	li	s1,0
    80003e22:	b78d                	j	80003d84 <balloc+0x96>

0000000080003e24 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003e24:	7179                	addi	sp,sp,-48
    80003e26:	f406                	sd	ra,40(sp)
    80003e28:	f022                	sd	s0,32(sp)
    80003e2a:	ec26                	sd	s1,24(sp)
    80003e2c:	e84a                	sd	s2,16(sp)
    80003e2e:	e44e                	sd	s3,8(sp)
    80003e30:	1800                	addi	s0,sp,48
    80003e32:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003e34:	47ad                	li	a5,11
    80003e36:	02b7e563          	bltu	a5,a1,80003e60 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003e3a:	02059793          	slli	a5,a1,0x20
    80003e3e:	01e7d593          	srli	a1,a5,0x1e
    80003e42:	00b504b3          	add	s1,a0,a1
    80003e46:	0504a903          	lw	s2,80(s1)
    80003e4a:	06091b63          	bnez	s2,80003ec0 <bmap+0x9c>
      addr = balloc(ip->dev);
    80003e4e:	4108                	lw	a0,0(a0)
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	e9e080e7          	jalr	-354(ra) # 80003cee <balloc>
    80003e58:	892a                	mv	s2,a0
      if(addr == 0)
    80003e5a:	c13d                	beqz	a0,80003ec0 <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    80003e5c:	c8a8                	sw	a0,80(s1)
    80003e5e:	a08d                	j	80003ec0 <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003e60:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80003e64:	0ff00793          	li	a5,255
    80003e68:	0897e363          	bltu	a5,s1,80003eee <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003e6c:	08052903          	lw	s2,128(a0)
    80003e70:	00091d63          	bnez	s2,80003e8a <bmap+0x66>
      addr = balloc(ip->dev);
    80003e74:	4108                	lw	a0,0(a0)
    80003e76:	00000097          	auipc	ra,0x0
    80003e7a:	e78080e7          	jalr	-392(ra) # 80003cee <balloc>
    80003e7e:	892a                	mv	s2,a0
      if(addr == 0)
    80003e80:	c121                	beqz	a0,80003ec0 <bmap+0x9c>
    80003e82:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003e84:	08a9a023          	sw	a0,128(s3)
    80003e88:	a011                	j	80003e8c <bmap+0x68>
    80003e8a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003e8c:	85ca                	mv	a1,s2
    80003e8e:	0009a503          	lw	a0,0(s3)
    80003e92:	00000097          	auipc	ra,0x0
    80003e96:	ba0080e7          	jalr	-1120(ra) # 80003a32 <bread>
    80003e9a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003e9c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003ea0:	02049713          	slli	a4,s1,0x20
    80003ea4:	01e75593          	srli	a1,a4,0x1e
    80003ea8:	00b784b3          	add	s1,a5,a1
    80003eac:	0004a903          	lw	s2,0(s1)
    80003eb0:	02090063          	beqz	s2,80003ed0 <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003eb4:	8552                	mv	a0,s4
    80003eb6:	00000097          	auipc	ra,0x0
    80003eba:	cac080e7          	jalr	-852(ra) # 80003b62 <brelse>
    return addr;
    80003ebe:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003ec0:	854a                	mv	a0,s2
    80003ec2:	70a2                	ld	ra,40(sp)
    80003ec4:	7402                	ld	s0,32(sp)
    80003ec6:	64e2                	ld	s1,24(sp)
    80003ec8:	6942                	ld	s2,16(sp)
    80003eca:	69a2                	ld	s3,8(sp)
    80003ecc:	6145                	addi	sp,sp,48
    80003ece:	8082                	ret
      addr = balloc(ip->dev);
    80003ed0:	0009a503          	lw	a0,0(s3)
    80003ed4:	00000097          	auipc	ra,0x0
    80003ed8:	e1a080e7          	jalr	-486(ra) # 80003cee <balloc>
    80003edc:	892a                	mv	s2,a0
      if(addr){
    80003ede:	d979                	beqz	a0,80003eb4 <bmap+0x90>
        a[bn] = addr;
    80003ee0:	c088                	sw	a0,0(s1)
        log_write(bp);
    80003ee2:	8552                	mv	a0,s4
    80003ee4:	00001097          	auipc	ra,0x1
    80003ee8:	f24080e7          	jalr	-220(ra) # 80004e08 <log_write>
    80003eec:	b7e1                	j	80003eb4 <bmap+0x90>
    80003eee:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003ef0:	00006517          	auipc	a0,0x6
    80003ef4:	5f050513          	addi	a0,a0,1520 # 8000a4e0 <etext+0x4e0>
    80003ef8:	ffffc097          	auipc	ra,0xffffc
    80003efc:	668080e7          	jalr	1640(ra) # 80000560 <panic>

0000000080003f00 <iget>:
{
    80003f00:	7179                	addi	sp,sp,-48
    80003f02:	f406                	sd	ra,40(sp)
    80003f04:	f022                	sd	s0,32(sp)
    80003f06:	ec26                	sd	s1,24(sp)
    80003f08:	e84a                	sd	s2,16(sp)
    80003f0a:	e44e                	sd	s3,8(sp)
    80003f0c:	e052                	sd	s4,0(sp)
    80003f0e:	1800                	addi	s0,sp,48
    80003f10:	89aa                	mv	s3,a0
    80003f12:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003f14:	00069517          	auipc	a0,0x69
    80003f18:	d8450513          	addi	a0,a0,-636 # 8006cc98 <itable>
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	dfa080e7          	jalr	-518(ra) # 80000d16 <acquire>
  empty = 0;
    80003f24:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003f26:	00069497          	auipc	s1,0x69
    80003f2a:	d8a48493          	addi	s1,s1,-630 # 8006ccb0 <itable+0x18>
    80003f2e:	0006b697          	auipc	a3,0x6b
    80003f32:	81268693          	addi	a3,a3,-2030 # 8006e740 <log>
    80003f36:	a039                	j	80003f44 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003f38:	02090b63          	beqz	s2,80003f6e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003f3c:	08848493          	addi	s1,s1,136
    80003f40:	02d48a63          	beq	s1,a3,80003f74 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003f44:	449c                	lw	a5,8(s1)
    80003f46:	fef059e3          	blez	a5,80003f38 <iget+0x38>
    80003f4a:	4098                	lw	a4,0(s1)
    80003f4c:	ff3716e3          	bne	a4,s3,80003f38 <iget+0x38>
    80003f50:	40d8                	lw	a4,4(s1)
    80003f52:	ff4713e3          	bne	a4,s4,80003f38 <iget+0x38>
      ip->ref++;
    80003f56:	2785                	addiw	a5,a5,1
    80003f58:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003f5a:	00069517          	auipc	a0,0x69
    80003f5e:	d3e50513          	addi	a0,a0,-706 # 8006cc98 <itable>
    80003f62:	ffffd097          	auipc	ra,0xffffd
    80003f66:	e64080e7          	jalr	-412(ra) # 80000dc6 <release>
      return ip;
    80003f6a:	8926                	mv	s2,s1
    80003f6c:	a03d                	j	80003f9a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003f6e:	f7f9                	bnez	a5,80003f3c <iget+0x3c>
      empty = ip;
    80003f70:	8926                	mv	s2,s1
    80003f72:	b7e9                	j	80003f3c <iget+0x3c>
  if(empty == 0)
    80003f74:	02090c63          	beqz	s2,80003fac <iget+0xac>
  ip->dev = dev;
    80003f78:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003f7c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003f80:	4785                	li	a5,1
    80003f82:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003f86:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003f8a:	00069517          	auipc	a0,0x69
    80003f8e:	d0e50513          	addi	a0,a0,-754 # 8006cc98 <itable>
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	e34080e7          	jalr	-460(ra) # 80000dc6 <release>
}
    80003f9a:	854a                	mv	a0,s2
    80003f9c:	70a2                	ld	ra,40(sp)
    80003f9e:	7402                	ld	s0,32(sp)
    80003fa0:	64e2                	ld	s1,24(sp)
    80003fa2:	6942                	ld	s2,16(sp)
    80003fa4:	69a2                	ld	s3,8(sp)
    80003fa6:	6a02                	ld	s4,0(sp)
    80003fa8:	6145                	addi	sp,sp,48
    80003faa:	8082                	ret
    panic("iget: no inodes");
    80003fac:	00006517          	auipc	a0,0x6
    80003fb0:	54c50513          	addi	a0,a0,1356 # 8000a4f8 <etext+0x4f8>
    80003fb4:	ffffc097          	auipc	ra,0xffffc
    80003fb8:	5ac080e7          	jalr	1452(ra) # 80000560 <panic>

0000000080003fbc <fsinit>:
fsinit(int dev) {
    80003fbc:	7179                	addi	sp,sp,-48
    80003fbe:	f406                	sd	ra,40(sp)
    80003fc0:	f022                	sd	s0,32(sp)
    80003fc2:	ec26                	sd	s1,24(sp)
    80003fc4:	e84a                	sd	s2,16(sp)
    80003fc6:	e44e                	sd	s3,8(sp)
    80003fc8:	1800                	addi	s0,sp,48
    80003fca:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003fcc:	4585                	li	a1,1
    80003fce:	00000097          	auipc	ra,0x0
    80003fd2:	a64080e7          	jalr	-1436(ra) # 80003a32 <bread>
    80003fd6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003fd8:	00069997          	auipc	s3,0x69
    80003fdc:	ca098993          	addi	s3,s3,-864 # 8006cc78 <sb>
    80003fe0:	02000613          	li	a2,32
    80003fe4:	05850593          	addi	a1,a0,88
    80003fe8:	854e                	mv	a0,s3
    80003fea:	ffffd097          	auipc	ra,0xffffd
    80003fee:	e88080e7          	jalr	-376(ra) # 80000e72 <memmove>
  brelse(bp);
    80003ff2:	8526                	mv	a0,s1
    80003ff4:	00000097          	auipc	ra,0x0
    80003ff8:	b6e080e7          	jalr	-1170(ra) # 80003b62 <brelse>
  if(sb.magic != FSMAGIC)
    80003ffc:	0009a703          	lw	a4,0(s3)
    80004000:	102037b7          	lui	a5,0x10203
    80004004:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004008:	02f71263          	bne	a4,a5,8000402c <fsinit+0x70>
  initlog(dev, &sb);
    8000400c:	00069597          	auipc	a1,0x69
    80004010:	c6c58593          	addi	a1,a1,-916 # 8006cc78 <sb>
    80004014:	854a                	mv	a0,s2
    80004016:	00001097          	auipc	ra,0x1
    8000401a:	b7c080e7          	jalr	-1156(ra) # 80004b92 <initlog>
}
    8000401e:	70a2                	ld	ra,40(sp)
    80004020:	7402                	ld	s0,32(sp)
    80004022:	64e2                	ld	s1,24(sp)
    80004024:	6942                	ld	s2,16(sp)
    80004026:	69a2                	ld	s3,8(sp)
    80004028:	6145                	addi	sp,sp,48
    8000402a:	8082                	ret
    panic("invalid file system");
    8000402c:	00006517          	auipc	a0,0x6
    80004030:	4dc50513          	addi	a0,a0,1244 # 8000a508 <etext+0x508>
    80004034:	ffffc097          	auipc	ra,0xffffc
    80004038:	52c080e7          	jalr	1324(ra) # 80000560 <panic>

000000008000403c <iinit>:
{
    8000403c:	7179                	addi	sp,sp,-48
    8000403e:	f406                	sd	ra,40(sp)
    80004040:	f022                	sd	s0,32(sp)
    80004042:	ec26                	sd	s1,24(sp)
    80004044:	e84a                	sd	s2,16(sp)
    80004046:	e44e                	sd	s3,8(sp)
    80004048:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000404a:	00006597          	auipc	a1,0x6
    8000404e:	4d658593          	addi	a1,a1,1238 # 8000a520 <etext+0x520>
    80004052:	00069517          	auipc	a0,0x69
    80004056:	c4650513          	addi	a0,a0,-954 # 8006cc98 <itable>
    8000405a:	ffffd097          	auipc	ra,0xffffd
    8000405e:	c28080e7          	jalr	-984(ra) # 80000c82 <initlock>
  for(i = 0; i < NINODE; i++) {
    80004062:	00069497          	auipc	s1,0x69
    80004066:	c5e48493          	addi	s1,s1,-930 # 8006ccc0 <itable+0x28>
    8000406a:	0006a997          	auipc	s3,0x6a
    8000406e:	6e698993          	addi	s3,s3,1766 # 8006e750 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80004072:	00006917          	auipc	s2,0x6
    80004076:	4b690913          	addi	s2,s2,1206 # 8000a528 <etext+0x528>
    8000407a:	85ca                	mv	a1,s2
    8000407c:	8526                	mv	a0,s1
    8000407e:	00001097          	auipc	ra,0x1
    80004082:	e6e080e7          	jalr	-402(ra) # 80004eec <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004086:	08848493          	addi	s1,s1,136
    8000408a:	ff3498e3          	bne	s1,s3,8000407a <iinit+0x3e>
}
    8000408e:	70a2                	ld	ra,40(sp)
    80004090:	7402                	ld	s0,32(sp)
    80004092:	64e2                	ld	s1,24(sp)
    80004094:	6942                	ld	s2,16(sp)
    80004096:	69a2                	ld	s3,8(sp)
    80004098:	6145                	addi	sp,sp,48
    8000409a:	8082                	ret

000000008000409c <ialloc>:
{
    8000409c:	7139                	addi	sp,sp,-64
    8000409e:	fc06                	sd	ra,56(sp)
    800040a0:	f822                	sd	s0,48(sp)
    800040a2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800040a4:	00069717          	auipc	a4,0x69
    800040a8:	be072703          	lw	a4,-1056(a4) # 8006cc84 <sb+0xc>
    800040ac:	4785                	li	a5,1
    800040ae:	06e7f463          	bgeu	a5,a4,80004116 <ialloc+0x7a>
    800040b2:	f426                	sd	s1,40(sp)
    800040b4:	f04a                	sd	s2,32(sp)
    800040b6:	ec4e                	sd	s3,24(sp)
    800040b8:	e852                	sd	s4,16(sp)
    800040ba:	e456                	sd	s5,8(sp)
    800040bc:	e05a                	sd	s6,0(sp)
    800040be:	8aaa                	mv	s5,a0
    800040c0:	8b2e                	mv	s6,a1
    800040c2:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800040c4:	00069a17          	auipc	s4,0x69
    800040c8:	bb4a0a13          	addi	s4,s4,-1100 # 8006cc78 <sb>
    800040cc:	00495593          	srli	a1,s2,0x4
    800040d0:	018a2783          	lw	a5,24(s4)
    800040d4:	9dbd                	addw	a1,a1,a5
    800040d6:	8556                	mv	a0,s5
    800040d8:	00000097          	auipc	ra,0x0
    800040dc:	95a080e7          	jalr	-1702(ra) # 80003a32 <bread>
    800040e0:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800040e2:	05850993          	addi	s3,a0,88
    800040e6:	00f97793          	andi	a5,s2,15
    800040ea:	079a                	slli	a5,a5,0x6
    800040ec:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800040ee:	00099783          	lh	a5,0(s3)
    800040f2:	cf9d                	beqz	a5,80004130 <ialloc+0x94>
    brelse(bp);
    800040f4:	00000097          	auipc	ra,0x0
    800040f8:	a6e080e7          	jalr	-1426(ra) # 80003b62 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800040fc:	0905                	addi	s2,s2,1
    800040fe:	00ca2703          	lw	a4,12(s4)
    80004102:	0009079b          	sext.w	a5,s2
    80004106:	fce7e3e3          	bltu	a5,a4,800040cc <ialloc+0x30>
    8000410a:	74a2                	ld	s1,40(sp)
    8000410c:	7902                	ld	s2,32(sp)
    8000410e:	69e2                	ld	s3,24(sp)
    80004110:	6a42                	ld	s4,16(sp)
    80004112:	6aa2                	ld	s5,8(sp)
    80004114:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80004116:	00006517          	auipc	a0,0x6
    8000411a:	41a50513          	addi	a0,a0,1050 # 8000a530 <etext+0x530>
    8000411e:	ffffc097          	auipc	ra,0xffffc
    80004122:	48c080e7          	jalr	1164(ra) # 800005aa <printf>
  return 0;
    80004126:	4501                	li	a0,0
}
    80004128:	70e2                	ld	ra,56(sp)
    8000412a:	7442                	ld	s0,48(sp)
    8000412c:	6121                	addi	sp,sp,64
    8000412e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80004130:	04000613          	li	a2,64
    80004134:	4581                	li	a1,0
    80004136:	854e                	mv	a0,s3
    80004138:	ffffd097          	auipc	ra,0xffffd
    8000413c:	cd6080e7          	jalr	-810(ra) # 80000e0e <memset>
      dip->type = type;
    80004140:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80004144:	8526                	mv	a0,s1
    80004146:	00001097          	auipc	ra,0x1
    8000414a:	cc2080e7          	jalr	-830(ra) # 80004e08 <log_write>
      brelse(bp);
    8000414e:	8526                	mv	a0,s1
    80004150:	00000097          	auipc	ra,0x0
    80004154:	a12080e7          	jalr	-1518(ra) # 80003b62 <brelse>
      return iget(dev, inum);
    80004158:	0009059b          	sext.w	a1,s2
    8000415c:	8556                	mv	a0,s5
    8000415e:	00000097          	auipc	ra,0x0
    80004162:	da2080e7          	jalr	-606(ra) # 80003f00 <iget>
    80004166:	74a2                	ld	s1,40(sp)
    80004168:	7902                	ld	s2,32(sp)
    8000416a:	69e2                	ld	s3,24(sp)
    8000416c:	6a42                	ld	s4,16(sp)
    8000416e:	6aa2                	ld	s5,8(sp)
    80004170:	6b02                	ld	s6,0(sp)
    80004172:	bf5d                	j	80004128 <ialloc+0x8c>

0000000080004174 <iupdate>:
{
    80004174:	1101                	addi	sp,sp,-32
    80004176:	ec06                	sd	ra,24(sp)
    80004178:	e822                	sd	s0,16(sp)
    8000417a:	e426                	sd	s1,8(sp)
    8000417c:	e04a                	sd	s2,0(sp)
    8000417e:	1000                	addi	s0,sp,32
    80004180:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004182:	415c                	lw	a5,4(a0)
    80004184:	0047d79b          	srliw	a5,a5,0x4
    80004188:	00069597          	auipc	a1,0x69
    8000418c:	b085a583          	lw	a1,-1272(a1) # 8006cc90 <sb+0x18>
    80004190:	9dbd                	addw	a1,a1,a5
    80004192:	4108                	lw	a0,0(a0)
    80004194:	00000097          	auipc	ra,0x0
    80004198:	89e080e7          	jalr	-1890(ra) # 80003a32 <bread>
    8000419c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000419e:	05850793          	addi	a5,a0,88
    800041a2:	40d8                	lw	a4,4(s1)
    800041a4:	8b3d                	andi	a4,a4,15
    800041a6:	071a                	slli	a4,a4,0x6
    800041a8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800041aa:	04449703          	lh	a4,68(s1)
    800041ae:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800041b2:	04649703          	lh	a4,70(s1)
    800041b6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800041ba:	04849703          	lh	a4,72(s1)
    800041be:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800041c2:	04a49703          	lh	a4,74(s1)
    800041c6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800041ca:	44f8                	lw	a4,76(s1)
    800041cc:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800041ce:	03400613          	li	a2,52
    800041d2:	05048593          	addi	a1,s1,80
    800041d6:	00c78513          	addi	a0,a5,12
    800041da:	ffffd097          	auipc	ra,0xffffd
    800041de:	c98080e7          	jalr	-872(ra) # 80000e72 <memmove>
  log_write(bp);
    800041e2:	854a                	mv	a0,s2
    800041e4:	00001097          	auipc	ra,0x1
    800041e8:	c24080e7          	jalr	-988(ra) # 80004e08 <log_write>
  brelse(bp);
    800041ec:	854a                	mv	a0,s2
    800041ee:	00000097          	auipc	ra,0x0
    800041f2:	974080e7          	jalr	-1676(ra) # 80003b62 <brelse>
}
    800041f6:	60e2                	ld	ra,24(sp)
    800041f8:	6442                	ld	s0,16(sp)
    800041fa:	64a2                	ld	s1,8(sp)
    800041fc:	6902                	ld	s2,0(sp)
    800041fe:	6105                	addi	sp,sp,32
    80004200:	8082                	ret

0000000080004202 <idup>:
{
    80004202:	1101                	addi	sp,sp,-32
    80004204:	ec06                	sd	ra,24(sp)
    80004206:	e822                	sd	s0,16(sp)
    80004208:	e426                	sd	s1,8(sp)
    8000420a:	1000                	addi	s0,sp,32
    8000420c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000420e:	00069517          	auipc	a0,0x69
    80004212:	a8a50513          	addi	a0,a0,-1398 # 8006cc98 <itable>
    80004216:	ffffd097          	auipc	ra,0xffffd
    8000421a:	b00080e7          	jalr	-1280(ra) # 80000d16 <acquire>
  ip->ref++;
    8000421e:	449c                	lw	a5,8(s1)
    80004220:	2785                	addiw	a5,a5,1
    80004222:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004224:	00069517          	auipc	a0,0x69
    80004228:	a7450513          	addi	a0,a0,-1420 # 8006cc98 <itable>
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	b9a080e7          	jalr	-1126(ra) # 80000dc6 <release>
}
    80004234:	8526                	mv	a0,s1
    80004236:	60e2                	ld	ra,24(sp)
    80004238:	6442                	ld	s0,16(sp)
    8000423a:	64a2                	ld	s1,8(sp)
    8000423c:	6105                	addi	sp,sp,32
    8000423e:	8082                	ret

0000000080004240 <ilock>:
{
    80004240:	1101                	addi	sp,sp,-32
    80004242:	ec06                	sd	ra,24(sp)
    80004244:	e822                	sd	s0,16(sp)
    80004246:	e426                	sd	s1,8(sp)
    80004248:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000424a:	c10d                	beqz	a0,8000426c <ilock+0x2c>
    8000424c:	84aa                	mv	s1,a0
    8000424e:	451c                	lw	a5,8(a0)
    80004250:	00f05e63          	blez	a5,8000426c <ilock+0x2c>
  acquiresleep(&ip->lock);
    80004254:	0541                	addi	a0,a0,16
    80004256:	00001097          	auipc	ra,0x1
    8000425a:	cd0080e7          	jalr	-816(ra) # 80004f26 <acquiresleep>
  if(ip->valid == 0){
    8000425e:	40bc                	lw	a5,64(s1)
    80004260:	cf99                	beqz	a5,8000427e <ilock+0x3e>
}
    80004262:	60e2                	ld	ra,24(sp)
    80004264:	6442                	ld	s0,16(sp)
    80004266:	64a2                	ld	s1,8(sp)
    80004268:	6105                	addi	sp,sp,32
    8000426a:	8082                	ret
    8000426c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000426e:	00006517          	auipc	a0,0x6
    80004272:	2da50513          	addi	a0,a0,730 # 8000a548 <etext+0x548>
    80004276:	ffffc097          	auipc	ra,0xffffc
    8000427a:	2ea080e7          	jalr	746(ra) # 80000560 <panic>
    8000427e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004280:	40dc                	lw	a5,4(s1)
    80004282:	0047d79b          	srliw	a5,a5,0x4
    80004286:	00069597          	auipc	a1,0x69
    8000428a:	a0a5a583          	lw	a1,-1526(a1) # 8006cc90 <sb+0x18>
    8000428e:	9dbd                	addw	a1,a1,a5
    80004290:	4088                	lw	a0,0(s1)
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	7a0080e7          	jalr	1952(ra) # 80003a32 <bread>
    8000429a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000429c:	05850593          	addi	a1,a0,88
    800042a0:	40dc                	lw	a5,4(s1)
    800042a2:	8bbd                	andi	a5,a5,15
    800042a4:	079a                	slli	a5,a5,0x6
    800042a6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800042a8:	00059783          	lh	a5,0(a1)
    800042ac:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800042b0:	00259783          	lh	a5,2(a1)
    800042b4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800042b8:	00459783          	lh	a5,4(a1)
    800042bc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800042c0:	00659783          	lh	a5,6(a1)
    800042c4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800042c8:	459c                	lw	a5,8(a1)
    800042ca:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800042cc:	03400613          	li	a2,52
    800042d0:	05b1                	addi	a1,a1,12
    800042d2:	05048513          	addi	a0,s1,80
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	b9c080e7          	jalr	-1124(ra) # 80000e72 <memmove>
    brelse(bp);
    800042de:	854a                	mv	a0,s2
    800042e0:	00000097          	auipc	ra,0x0
    800042e4:	882080e7          	jalr	-1918(ra) # 80003b62 <brelse>
    ip->valid = 1;
    800042e8:	4785                	li	a5,1
    800042ea:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800042ec:	04449783          	lh	a5,68(s1)
    800042f0:	c399                	beqz	a5,800042f6 <ilock+0xb6>
    800042f2:	6902                	ld	s2,0(sp)
    800042f4:	b7bd                	j	80004262 <ilock+0x22>
      panic("ilock: no type");
    800042f6:	00006517          	auipc	a0,0x6
    800042fa:	25a50513          	addi	a0,a0,602 # 8000a550 <etext+0x550>
    800042fe:	ffffc097          	auipc	ra,0xffffc
    80004302:	262080e7          	jalr	610(ra) # 80000560 <panic>

0000000080004306 <iunlock>:
{
    80004306:	1101                	addi	sp,sp,-32
    80004308:	ec06                	sd	ra,24(sp)
    8000430a:	e822                	sd	s0,16(sp)
    8000430c:	e426                	sd	s1,8(sp)
    8000430e:	e04a                	sd	s2,0(sp)
    80004310:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004312:	c905                	beqz	a0,80004342 <iunlock+0x3c>
    80004314:	84aa                	mv	s1,a0
    80004316:	01050913          	addi	s2,a0,16
    8000431a:	854a                	mv	a0,s2
    8000431c:	00001097          	auipc	ra,0x1
    80004320:	ca4080e7          	jalr	-860(ra) # 80004fc0 <holdingsleep>
    80004324:	cd19                	beqz	a0,80004342 <iunlock+0x3c>
    80004326:	449c                	lw	a5,8(s1)
    80004328:	00f05d63          	blez	a5,80004342 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000432c:	854a                	mv	a0,s2
    8000432e:	00001097          	auipc	ra,0x1
    80004332:	c4e080e7          	jalr	-946(ra) # 80004f7c <releasesleep>
}
    80004336:	60e2                	ld	ra,24(sp)
    80004338:	6442                	ld	s0,16(sp)
    8000433a:	64a2                	ld	s1,8(sp)
    8000433c:	6902                	ld	s2,0(sp)
    8000433e:	6105                	addi	sp,sp,32
    80004340:	8082                	ret
    panic("iunlock");
    80004342:	00006517          	auipc	a0,0x6
    80004346:	21e50513          	addi	a0,a0,542 # 8000a560 <etext+0x560>
    8000434a:	ffffc097          	auipc	ra,0xffffc
    8000434e:	216080e7          	jalr	534(ra) # 80000560 <panic>

0000000080004352 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004352:	7179                	addi	sp,sp,-48
    80004354:	f406                	sd	ra,40(sp)
    80004356:	f022                	sd	s0,32(sp)
    80004358:	ec26                	sd	s1,24(sp)
    8000435a:	e84a                	sd	s2,16(sp)
    8000435c:	e44e                	sd	s3,8(sp)
    8000435e:	1800                	addi	s0,sp,48
    80004360:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004362:	05050493          	addi	s1,a0,80
    80004366:	08050913          	addi	s2,a0,128
    8000436a:	a021                	j	80004372 <itrunc+0x20>
    8000436c:	0491                	addi	s1,s1,4
    8000436e:	01248d63          	beq	s1,s2,80004388 <itrunc+0x36>
    if(ip->addrs[i]){
    80004372:	408c                	lw	a1,0(s1)
    80004374:	dde5                	beqz	a1,8000436c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80004376:	0009a503          	lw	a0,0(s3)
    8000437a:	00000097          	auipc	ra,0x0
    8000437e:	8f8080e7          	jalr	-1800(ra) # 80003c72 <bfree>
      ip->addrs[i] = 0;
    80004382:	0004a023          	sw	zero,0(s1)
    80004386:	b7dd                	j	8000436c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004388:	0809a583          	lw	a1,128(s3)
    8000438c:	ed99                	bnez	a1,800043aa <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000438e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004392:	854e                	mv	a0,s3
    80004394:	00000097          	auipc	ra,0x0
    80004398:	de0080e7          	jalr	-544(ra) # 80004174 <iupdate>
}
    8000439c:	70a2                	ld	ra,40(sp)
    8000439e:	7402                	ld	s0,32(sp)
    800043a0:	64e2                	ld	s1,24(sp)
    800043a2:	6942                	ld	s2,16(sp)
    800043a4:	69a2                	ld	s3,8(sp)
    800043a6:	6145                	addi	sp,sp,48
    800043a8:	8082                	ret
    800043aa:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800043ac:	0009a503          	lw	a0,0(s3)
    800043b0:	fffff097          	auipc	ra,0xfffff
    800043b4:	682080e7          	jalr	1666(ra) # 80003a32 <bread>
    800043b8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800043ba:	05850493          	addi	s1,a0,88
    800043be:	45850913          	addi	s2,a0,1112
    800043c2:	a021                	j	800043ca <itrunc+0x78>
    800043c4:	0491                	addi	s1,s1,4
    800043c6:	01248b63          	beq	s1,s2,800043dc <itrunc+0x8a>
      if(a[j])
    800043ca:	408c                	lw	a1,0(s1)
    800043cc:	dde5                	beqz	a1,800043c4 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    800043ce:	0009a503          	lw	a0,0(s3)
    800043d2:	00000097          	auipc	ra,0x0
    800043d6:	8a0080e7          	jalr	-1888(ra) # 80003c72 <bfree>
    800043da:	b7ed                	j	800043c4 <itrunc+0x72>
    brelse(bp);
    800043dc:	8552                	mv	a0,s4
    800043de:	fffff097          	auipc	ra,0xfffff
    800043e2:	784080e7          	jalr	1924(ra) # 80003b62 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800043e6:	0809a583          	lw	a1,128(s3)
    800043ea:	0009a503          	lw	a0,0(s3)
    800043ee:	00000097          	auipc	ra,0x0
    800043f2:	884080e7          	jalr	-1916(ra) # 80003c72 <bfree>
    ip->addrs[NDIRECT] = 0;
    800043f6:	0809a023          	sw	zero,128(s3)
    800043fa:	6a02                	ld	s4,0(sp)
    800043fc:	bf49                	j	8000438e <itrunc+0x3c>

00000000800043fe <iput>:
{
    800043fe:	1101                	addi	sp,sp,-32
    80004400:	ec06                	sd	ra,24(sp)
    80004402:	e822                	sd	s0,16(sp)
    80004404:	e426                	sd	s1,8(sp)
    80004406:	1000                	addi	s0,sp,32
    80004408:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000440a:	00069517          	auipc	a0,0x69
    8000440e:	88e50513          	addi	a0,a0,-1906 # 8006cc98 <itable>
    80004412:	ffffd097          	auipc	ra,0xffffd
    80004416:	904080e7          	jalr	-1788(ra) # 80000d16 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000441a:	4498                	lw	a4,8(s1)
    8000441c:	4785                	li	a5,1
    8000441e:	02f70263          	beq	a4,a5,80004442 <iput+0x44>
  ip->ref--;
    80004422:	449c                	lw	a5,8(s1)
    80004424:	37fd                	addiw	a5,a5,-1
    80004426:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004428:	00069517          	auipc	a0,0x69
    8000442c:	87050513          	addi	a0,a0,-1936 # 8006cc98 <itable>
    80004430:	ffffd097          	auipc	ra,0xffffd
    80004434:	996080e7          	jalr	-1642(ra) # 80000dc6 <release>
}
    80004438:	60e2                	ld	ra,24(sp)
    8000443a:	6442                	ld	s0,16(sp)
    8000443c:	64a2                	ld	s1,8(sp)
    8000443e:	6105                	addi	sp,sp,32
    80004440:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004442:	40bc                	lw	a5,64(s1)
    80004444:	dff9                	beqz	a5,80004422 <iput+0x24>
    80004446:	04a49783          	lh	a5,74(s1)
    8000444a:	ffe1                	bnez	a5,80004422 <iput+0x24>
    8000444c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000444e:	01048913          	addi	s2,s1,16
    80004452:	854a                	mv	a0,s2
    80004454:	00001097          	auipc	ra,0x1
    80004458:	ad2080e7          	jalr	-1326(ra) # 80004f26 <acquiresleep>
    release(&itable.lock);
    8000445c:	00069517          	auipc	a0,0x69
    80004460:	83c50513          	addi	a0,a0,-1988 # 8006cc98 <itable>
    80004464:	ffffd097          	auipc	ra,0xffffd
    80004468:	962080e7          	jalr	-1694(ra) # 80000dc6 <release>
    itrunc(ip);
    8000446c:	8526                	mv	a0,s1
    8000446e:	00000097          	auipc	ra,0x0
    80004472:	ee4080e7          	jalr	-284(ra) # 80004352 <itrunc>
    ip->type = 0;
    80004476:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000447a:	8526                	mv	a0,s1
    8000447c:	00000097          	auipc	ra,0x0
    80004480:	cf8080e7          	jalr	-776(ra) # 80004174 <iupdate>
    ip->valid = 0;
    80004484:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004488:	854a                	mv	a0,s2
    8000448a:	00001097          	auipc	ra,0x1
    8000448e:	af2080e7          	jalr	-1294(ra) # 80004f7c <releasesleep>
    acquire(&itable.lock);
    80004492:	00069517          	auipc	a0,0x69
    80004496:	80650513          	addi	a0,a0,-2042 # 8006cc98 <itable>
    8000449a:	ffffd097          	auipc	ra,0xffffd
    8000449e:	87c080e7          	jalr	-1924(ra) # 80000d16 <acquire>
    800044a2:	6902                	ld	s2,0(sp)
    800044a4:	bfbd                	j	80004422 <iput+0x24>

00000000800044a6 <iunlockput>:
{
    800044a6:	1101                	addi	sp,sp,-32
    800044a8:	ec06                	sd	ra,24(sp)
    800044aa:	e822                	sd	s0,16(sp)
    800044ac:	e426                	sd	s1,8(sp)
    800044ae:	1000                	addi	s0,sp,32
    800044b0:	84aa                	mv	s1,a0
  iunlock(ip);
    800044b2:	00000097          	auipc	ra,0x0
    800044b6:	e54080e7          	jalr	-428(ra) # 80004306 <iunlock>
  iput(ip);
    800044ba:	8526                	mv	a0,s1
    800044bc:	00000097          	auipc	ra,0x0
    800044c0:	f42080e7          	jalr	-190(ra) # 800043fe <iput>
}
    800044c4:	60e2                	ld	ra,24(sp)
    800044c6:	6442                	ld	s0,16(sp)
    800044c8:	64a2                	ld	s1,8(sp)
    800044ca:	6105                	addi	sp,sp,32
    800044cc:	8082                	ret

00000000800044ce <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800044ce:	1141                	addi	sp,sp,-16
    800044d0:	e406                	sd	ra,8(sp)
    800044d2:	e022                	sd	s0,0(sp)
    800044d4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800044d6:	411c                	lw	a5,0(a0)
    800044d8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800044da:	415c                	lw	a5,4(a0)
    800044dc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800044de:	04451783          	lh	a5,68(a0)
    800044e2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800044e6:	04a51783          	lh	a5,74(a0)
    800044ea:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800044ee:	04c56783          	lwu	a5,76(a0)
    800044f2:	e99c                	sd	a5,16(a1)
}
    800044f4:	60a2                	ld	ra,8(sp)
    800044f6:	6402                	ld	s0,0(sp)
    800044f8:	0141                	addi	sp,sp,16
    800044fa:	8082                	ret

00000000800044fc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800044fc:	457c                	lw	a5,76(a0)
    800044fe:	10d7e063          	bltu	a5,a3,800045fe <readi+0x102>
{
    80004502:	7159                	addi	sp,sp,-112
    80004504:	f486                	sd	ra,104(sp)
    80004506:	f0a2                	sd	s0,96(sp)
    80004508:	eca6                	sd	s1,88(sp)
    8000450a:	e0d2                	sd	s4,64(sp)
    8000450c:	fc56                	sd	s5,56(sp)
    8000450e:	f85a                	sd	s6,48(sp)
    80004510:	f45e                	sd	s7,40(sp)
    80004512:	1880                	addi	s0,sp,112
    80004514:	8b2a                	mv	s6,a0
    80004516:	8bae                	mv	s7,a1
    80004518:	8a32                	mv	s4,a2
    8000451a:	84b6                	mv	s1,a3
    8000451c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000451e:	9f35                	addw	a4,a4,a3
    return 0;
    80004520:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004522:	0cd76563          	bltu	a4,a3,800045ec <readi+0xf0>
    80004526:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004528:	00e7f463          	bgeu	a5,a4,80004530 <readi+0x34>
    n = ip->size - off;
    8000452c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004530:	0a0a8563          	beqz	s5,800045da <readi+0xde>
    80004534:	e8ca                	sd	s2,80(sp)
    80004536:	f062                	sd	s8,32(sp)
    80004538:	ec66                	sd	s9,24(sp)
    8000453a:	e86a                	sd	s10,16(sp)
    8000453c:	e46e                	sd	s11,8(sp)
    8000453e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004540:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004544:	5c7d                	li	s8,-1
    80004546:	a82d                	j	80004580 <readi+0x84>
    80004548:	020d1d93          	slli	s11,s10,0x20
    8000454c:	020ddd93          	srli	s11,s11,0x20
    80004550:	05890613          	addi	a2,s2,88
    80004554:	86ee                	mv	a3,s11
    80004556:	963e                	add	a2,a2,a5
    80004558:	85d2                	mv	a1,s4
    8000455a:	855e                	mv	a0,s7
    8000455c:	fffff097          	auipc	ra,0xfffff
    80004560:	86e080e7          	jalr	-1938(ra) # 80002dca <either_copyout>
    80004564:	05850963          	beq	a0,s8,800045b6 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004568:	854a                	mv	a0,s2
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	5f8080e7          	jalr	1528(ra) # 80003b62 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004572:	013d09bb          	addw	s3,s10,s3
    80004576:	009d04bb          	addw	s1,s10,s1
    8000457a:	9a6e                	add	s4,s4,s11
    8000457c:	0559f963          	bgeu	s3,s5,800045ce <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80004580:	00a4d59b          	srliw	a1,s1,0xa
    80004584:	855a                	mv	a0,s6
    80004586:	00000097          	auipc	ra,0x0
    8000458a:	89e080e7          	jalr	-1890(ra) # 80003e24 <bmap>
    8000458e:	85aa                	mv	a1,a0
    if(addr == 0)
    80004590:	c539                	beqz	a0,800045de <readi+0xe2>
    bp = bread(ip->dev, addr);
    80004592:	000b2503          	lw	a0,0(s6)
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	49c080e7          	jalr	1180(ra) # 80003a32 <bread>
    8000459e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800045a0:	3ff4f793          	andi	a5,s1,1023
    800045a4:	40fc873b          	subw	a4,s9,a5
    800045a8:	413a86bb          	subw	a3,s5,s3
    800045ac:	8d3a                	mv	s10,a4
    800045ae:	f8e6fde3          	bgeu	a3,a4,80004548 <readi+0x4c>
    800045b2:	8d36                	mv	s10,a3
    800045b4:	bf51                	j	80004548 <readi+0x4c>
      brelse(bp);
    800045b6:	854a                	mv	a0,s2
    800045b8:	fffff097          	auipc	ra,0xfffff
    800045bc:	5aa080e7          	jalr	1450(ra) # 80003b62 <brelse>
      tot = -1;
    800045c0:	59fd                	li	s3,-1
      break;
    800045c2:	6946                	ld	s2,80(sp)
    800045c4:	7c02                	ld	s8,32(sp)
    800045c6:	6ce2                	ld	s9,24(sp)
    800045c8:	6d42                	ld	s10,16(sp)
    800045ca:	6da2                	ld	s11,8(sp)
    800045cc:	a831                	j	800045e8 <readi+0xec>
    800045ce:	6946                	ld	s2,80(sp)
    800045d0:	7c02                	ld	s8,32(sp)
    800045d2:	6ce2                	ld	s9,24(sp)
    800045d4:	6d42                	ld	s10,16(sp)
    800045d6:	6da2                	ld	s11,8(sp)
    800045d8:	a801                	j	800045e8 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800045da:	89d6                	mv	s3,s5
    800045dc:	a031                	j	800045e8 <readi+0xec>
    800045de:	6946                	ld	s2,80(sp)
    800045e0:	7c02                	ld	s8,32(sp)
    800045e2:	6ce2                	ld	s9,24(sp)
    800045e4:	6d42                	ld	s10,16(sp)
    800045e6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800045e8:	854e                	mv	a0,s3
    800045ea:	69a6                	ld	s3,72(sp)
}
    800045ec:	70a6                	ld	ra,104(sp)
    800045ee:	7406                	ld	s0,96(sp)
    800045f0:	64e6                	ld	s1,88(sp)
    800045f2:	6a06                	ld	s4,64(sp)
    800045f4:	7ae2                	ld	s5,56(sp)
    800045f6:	7b42                	ld	s6,48(sp)
    800045f8:	7ba2                	ld	s7,40(sp)
    800045fa:	6165                	addi	sp,sp,112
    800045fc:	8082                	ret
    return 0;
    800045fe:	4501                	li	a0,0
}
    80004600:	8082                	ret

0000000080004602 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004602:	457c                	lw	a5,76(a0)
    80004604:	10d7e963          	bltu	a5,a3,80004716 <writei+0x114>
{
    80004608:	7159                	addi	sp,sp,-112
    8000460a:	f486                	sd	ra,104(sp)
    8000460c:	f0a2                	sd	s0,96(sp)
    8000460e:	e8ca                	sd	s2,80(sp)
    80004610:	e0d2                	sd	s4,64(sp)
    80004612:	fc56                	sd	s5,56(sp)
    80004614:	f85a                	sd	s6,48(sp)
    80004616:	f45e                	sd	s7,40(sp)
    80004618:	1880                	addi	s0,sp,112
    8000461a:	8aaa                	mv	s5,a0
    8000461c:	8bae                	mv	s7,a1
    8000461e:	8a32                	mv	s4,a2
    80004620:	8936                	mv	s2,a3
    80004622:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004624:	00e687bb          	addw	a5,a3,a4
    80004628:	0ed7e963          	bltu	a5,a3,8000471a <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000462c:	00043737          	lui	a4,0x43
    80004630:	0ef76763          	bltu	a4,a5,8000471e <writei+0x11c>
    80004634:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004636:	0c0b0863          	beqz	s6,80004706 <writei+0x104>
    8000463a:	eca6                	sd	s1,88(sp)
    8000463c:	f062                	sd	s8,32(sp)
    8000463e:	ec66                	sd	s9,24(sp)
    80004640:	e86a                	sd	s10,16(sp)
    80004642:	e46e                	sd	s11,8(sp)
    80004644:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004646:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000464a:	5c7d                	li	s8,-1
    8000464c:	a091                	j	80004690 <writei+0x8e>
    8000464e:	020d1d93          	slli	s11,s10,0x20
    80004652:	020ddd93          	srli	s11,s11,0x20
    80004656:	05848513          	addi	a0,s1,88
    8000465a:	86ee                	mv	a3,s11
    8000465c:	8652                	mv	a2,s4
    8000465e:	85de                	mv	a1,s7
    80004660:	953e                	add	a0,a0,a5
    80004662:	ffffe097          	auipc	ra,0xffffe
    80004666:	7be080e7          	jalr	1982(ra) # 80002e20 <either_copyin>
    8000466a:	05850e63          	beq	a0,s8,800046c6 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000466e:	8526                	mv	a0,s1
    80004670:	00000097          	auipc	ra,0x0
    80004674:	798080e7          	jalr	1944(ra) # 80004e08 <log_write>
    brelse(bp);
    80004678:	8526                	mv	a0,s1
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	4e8080e7          	jalr	1256(ra) # 80003b62 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004682:	013d09bb          	addw	s3,s10,s3
    80004686:	012d093b          	addw	s2,s10,s2
    8000468a:	9a6e                	add	s4,s4,s11
    8000468c:	0569f263          	bgeu	s3,s6,800046d0 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80004690:	00a9559b          	srliw	a1,s2,0xa
    80004694:	8556                	mv	a0,s5
    80004696:	fffff097          	auipc	ra,0xfffff
    8000469a:	78e080e7          	jalr	1934(ra) # 80003e24 <bmap>
    8000469e:	85aa                	mv	a1,a0
    if(addr == 0)
    800046a0:	c905                	beqz	a0,800046d0 <writei+0xce>
    bp = bread(ip->dev, addr);
    800046a2:	000aa503          	lw	a0,0(s5)
    800046a6:	fffff097          	auipc	ra,0xfffff
    800046aa:	38c080e7          	jalr	908(ra) # 80003a32 <bread>
    800046ae:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800046b0:	3ff97793          	andi	a5,s2,1023
    800046b4:	40fc873b          	subw	a4,s9,a5
    800046b8:	413b06bb          	subw	a3,s6,s3
    800046bc:	8d3a                	mv	s10,a4
    800046be:	f8e6f8e3          	bgeu	a3,a4,8000464e <writei+0x4c>
    800046c2:	8d36                	mv	s10,a3
    800046c4:	b769                	j	8000464e <writei+0x4c>
      brelse(bp);
    800046c6:	8526                	mv	a0,s1
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	49a080e7          	jalr	1178(ra) # 80003b62 <brelse>
  }

  if(off > ip->size)
    800046d0:	04caa783          	lw	a5,76(s5)
    800046d4:	0327fb63          	bgeu	a5,s2,8000470a <writei+0x108>
    ip->size = off;
    800046d8:	052aa623          	sw	s2,76(s5)
    800046dc:	64e6                	ld	s1,88(sp)
    800046de:	7c02                	ld	s8,32(sp)
    800046e0:	6ce2                	ld	s9,24(sp)
    800046e2:	6d42                	ld	s10,16(sp)
    800046e4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800046e6:	8556                	mv	a0,s5
    800046e8:	00000097          	auipc	ra,0x0
    800046ec:	a8c080e7          	jalr	-1396(ra) # 80004174 <iupdate>

  return tot;
    800046f0:	854e                	mv	a0,s3
    800046f2:	69a6                	ld	s3,72(sp)
}
    800046f4:	70a6                	ld	ra,104(sp)
    800046f6:	7406                	ld	s0,96(sp)
    800046f8:	6946                	ld	s2,80(sp)
    800046fa:	6a06                	ld	s4,64(sp)
    800046fc:	7ae2                	ld	s5,56(sp)
    800046fe:	7b42                	ld	s6,48(sp)
    80004700:	7ba2                	ld	s7,40(sp)
    80004702:	6165                	addi	sp,sp,112
    80004704:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004706:	89da                	mv	s3,s6
    80004708:	bff9                	j	800046e6 <writei+0xe4>
    8000470a:	64e6                	ld	s1,88(sp)
    8000470c:	7c02                	ld	s8,32(sp)
    8000470e:	6ce2                	ld	s9,24(sp)
    80004710:	6d42                	ld	s10,16(sp)
    80004712:	6da2                	ld	s11,8(sp)
    80004714:	bfc9                	j	800046e6 <writei+0xe4>
    return -1;
    80004716:	557d                	li	a0,-1
}
    80004718:	8082                	ret
    return -1;
    8000471a:	557d                	li	a0,-1
    8000471c:	bfe1                	j	800046f4 <writei+0xf2>
    return -1;
    8000471e:	557d                	li	a0,-1
    80004720:	bfd1                	j	800046f4 <writei+0xf2>

0000000080004722 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004722:	1141                	addi	sp,sp,-16
    80004724:	e406                	sd	ra,8(sp)
    80004726:	e022                	sd	s0,0(sp)
    80004728:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000472a:	4639                	li	a2,14
    8000472c:	ffffc097          	auipc	ra,0xffffc
    80004730:	7be080e7          	jalr	1982(ra) # 80000eea <strncmp>
}
    80004734:	60a2                	ld	ra,8(sp)
    80004736:	6402                	ld	s0,0(sp)
    80004738:	0141                	addi	sp,sp,16
    8000473a:	8082                	ret

000000008000473c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000473c:	711d                	addi	sp,sp,-96
    8000473e:	ec86                	sd	ra,88(sp)
    80004740:	e8a2                	sd	s0,80(sp)
    80004742:	e4a6                	sd	s1,72(sp)
    80004744:	e0ca                	sd	s2,64(sp)
    80004746:	fc4e                	sd	s3,56(sp)
    80004748:	f852                	sd	s4,48(sp)
    8000474a:	f456                	sd	s5,40(sp)
    8000474c:	f05a                	sd	s6,32(sp)
    8000474e:	ec5e                	sd	s7,24(sp)
    80004750:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004752:	04451703          	lh	a4,68(a0)
    80004756:	4785                	li	a5,1
    80004758:	00f71f63          	bne	a4,a5,80004776 <dirlookup+0x3a>
    8000475c:	892a                	mv	s2,a0
    8000475e:	8aae                	mv	s5,a1
    80004760:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004762:	457c                	lw	a5,76(a0)
    80004764:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004766:	fa040a13          	addi	s4,s0,-96
    8000476a:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000476c:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004770:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004772:	e79d                	bnez	a5,800047a0 <dirlookup+0x64>
    80004774:	a88d                	j	800047e6 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80004776:	00006517          	auipc	a0,0x6
    8000477a:	df250513          	addi	a0,a0,-526 # 8000a568 <etext+0x568>
    8000477e:	ffffc097          	auipc	ra,0xffffc
    80004782:	de2080e7          	jalr	-542(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004786:	00006517          	auipc	a0,0x6
    8000478a:	dfa50513          	addi	a0,a0,-518 # 8000a580 <etext+0x580>
    8000478e:	ffffc097          	auipc	ra,0xffffc
    80004792:	dd2080e7          	jalr	-558(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004796:	24c1                	addiw	s1,s1,16
    80004798:	04c92783          	lw	a5,76(s2)
    8000479c:	04f4f463          	bgeu	s1,a5,800047e4 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800047a0:	874e                	mv	a4,s3
    800047a2:	86a6                	mv	a3,s1
    800047a4:	8652                	mv	a2,s4
    800047a6:	4581                	li	a1,0
    800047a8:	854a                	mv	a0,s2
    800047aa:	00000097          	auipc	ra,0x0
    800047ae:	d52080e7          	jalr	-686(ra) # 800044fc <readi>
    800047b2:	fd351ae3          	bne	a0,s3,80004786 <dirlookup+0x4a>
    if(de.inum == 0)
    800047b6:	fa045783          	lhu	a5,-96(s0)
    800047ba:	dff1                	beqz	a5,80004796 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    800047bc:	85da                	mv	a1,s6
    800047be:	8556                	mv	a0,s5
    800047c0:	00000097          	auipc	ra,0x0
    800047c4:	f62080e7          	jalr	-158(ra) # 80004722 <namecmp>
    800047c8:	f579                	bnez	a0,80004796 <dirlookup+0x5a>
      if(poff)
    800047ca:	000b8463          	beqz	s7,800047d2 <dirlookup+0x96>
        *poff = off;
    800047ce:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800047d2:	fa045583          	lhu	a1,-96(s0)
    800047d6:	00092503          	lw	a0,0(s2)
    800047da:	fffff097          	auipc	ra,0xfffff
    800047de:	726080e7          	jalr	1830(ra) # 80003f00 <iget>
    800047e2:	a011                	j	800047e6 <dirlookup+0xaa>
  return 0;
    800047e4:	4501                	li	a0,0
}
    800047e6:	60e6                	ld	ra,88(sp)
    800047e8:	6446                	ld	s0,80(sp)
    800047ea:	64a6                	ld	s1,72(sp)
    800047ec:	6906                	ld	s2,64(sp)
    800047ee:	79e2                	ld	s3,56(sp)
    800047f0:	7a42                	ld	s4,48(sp)
    800047f2:	7aa2                	ld	s5,40(sp)
    800047f4:	7b02                	ld	s6,32(sp)
    800047f6:	6be2                	ld	s7,24(sp)
    800047f8:	6125                	addi	sp,sp,96
    800047fa:	8082                	ret

00000000800047fc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800047fc:	711d                	addi	sp,sp,-96
    800047fe:	ec86                	sd	ra,88(sp)
    80004800:	e8a2                	sd	s0,80(sp)
    80004802:	e4a6                	sd	s1,72(sp)
    80004804:	e0ca                	sd	s2,64(sp)
    80004806:	fc4e                	sd	s3,56(sp)
    80004808:	f852                	sd	s4,48(sp)
    8000480a:	f456                	sd	s5,40(sp)
    8000480c:	f05a                	sd	s6,32(sp)
    8000480e:	ec5e                	sd	s7,24(sp)
    80004810:	e862                	sd	s8,16(sp)
    80004812:	e466                	sd	s9,8(sp)
    80004814:	e06a                	sd	s10,0(sp)
    80004816:	1080                	addi	s0,sp,96
    80004818:	84aa                	mv	s1,a0
    8000481a:	8b2e                	mv	s6,a1
    8000481c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000481e:	00054703          	lbu	a4,0(a0)
    80004822:	02f00793          	li	a5,47
    80004826:	02f70363          	beq	a4,a5,8000484c <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000482a:	ffffd097          	auipc	ra,0xffffd
    8000482e:	630080e7          	jalr	1584(ra) # 80001e5a <myproc>
    80004832:	15053503          	ld	a0,336(a0)
    80004836:	00000097          	auipc	ra,0x0
    8000483a:	9cc080e7          	jalr	-1588(ra) # 80004202 <idup>
    8000483e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004840:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004844:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004846:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004848:	4b85                	li	s7,1
    8000484a:	a87d                	j	80004908 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000484c:	4585                	li	a1,1
    8000484e:	852e                	mv	a0,a1
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	6b0080e7          	jalr	1712(ra) # 80003f00 <iget>
    80004858:	8a2a                	mv	s4,a0
    8000485a:	b7dd                	j	80004840 <namex+0x44>
      iunlockput(ip);
    8000485c:	8552                	mv	a0,s4
    8000485e:	00000097          	auipc	ra,0x0
    80004862:	c48080e7          	jalr	-952(ra) # 800044a6 <iunlockput>
      return 0;
    80004866:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004868:	8552                	mv	a0,s4
    8000486a:	60e6                	ld	ra,88(sp)
    8000486c:	6446                	ld	s0,80(sp)
    8000486e:	64a6                	ld	s1,72(sp)
    80004870:	6906                	ld	s2,64(sp)
    80004872:	79e2                	ld	s3,56(sp)
    80004874:	7a42                	ld	s4,48(sp)
    80004876:	7aa2                	ld	s5,40(sp)
    80004878:	7b02                	ld	s6,32(sp)
    8000487a:	6be2                	ld	s7,24(sp)
    8000487c:	6c42                	ld	s8,16(sp)
    8000487e:	6ca2                	ld	s9,8(sp)
    80004880:	6d02                	ld	s10,0(sp)
    80004882:	6125                	addi	sp,sp,96
    80004884:	8082                	ret
      iunlock(ip);
    80004886:	8552                	mv	a0,s4
    80004888:	00000097          	auipc	ra,0x0
    8000488c:	a7e080e7          	jalr	-1410(ra) # 80004306 <iunlock>
      return ip;
    80004890:	bfe1                	j	80004868 <namex+0x6c>
      iunlockput(ip);
    80004892:	8552                	mv	a0,s4
    80004894:	00000097          	auipc	ra,0x0
    80004898:	c12080e7          	jalr	-1006(ra) # 800044a6 <iunlockput>
      return 0;
    8000489c:	8a4e                	mv	s4,s3
    8000489e:	b7e9                	j	80004868 <namex+0x6c>
  len = path - s;
    800048a0:	40998633          	sub	a2,s3,s1
    800048a4:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800048a8:	09ac5863          	bge	s8,s10,80004938 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800048ac:	8666                	mv	a2,s9
    800048ae:	85a6                	mv	a1,s1
    800048b0:	8556                	mv	a0,s5
    800048b2:	ffffc097          	auipc	ra,0xffffc
    800048b6:	5c0080e7          	jalr	1472(ra) # 80000e72 <memmove>
    800048ba:	84ce                	mv	s1,s3
  while(*path == '/')
    800048bc:	0004c783          	lbu	a5,0(s1)
    800048c0:	01279763          	bne	a5,s2,800048ce <namex+0xd2>
    path++;
    800048c4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800048c6:	0004c783          	lbu	a5,0(s1)
    800048ca:	ff278de3          	beq	a5,s2,800048c4 <namex+0xc8>
    ilock(ip);
    800048ce:	8552                	mv	a0,s4
    800048d0:	00000097          	auipc	ra,0x0
    800048d4:	970080e7          	jalr	-1680(ra) # 80004240 <ilock>
    if(ip->type != T_DIR){
    800048d8:	044a1783          	lh	a5,68(s4)
    800048dc:	f97790e3          	bne	a5,s7,8000485c <namex+0x60>
    if(nameiparent && *path == '\0'){
    800048e0:	000b0563          	beqz	s6,800048ea <namex+0xee>
    800048e4:	0004c783          	lbu	a5,0(s1)
    800048e8:	dfd9                	beqz	a5,80004886 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800048ea:	4601                	li	a2,0
    800048ec:	85d6                	mv	a1,s5
    800048ee:	8552                	mv	a0,s4
    800048f0:	00000097          	auipc	ra,0x0
    800048f4:	e4c080e7          	jalr	-436(ra) # 8000473c <dirlookup>
    800048f8:	89aa                	mv	s3,a0
    800048fa:	dd41                	beqz	a0,80004892 <namex+0x96>
    iunlockput(ip);
    800048fc:	8552                	mv	a0,s4
    800048fe:	00000097          	auipc	ra,0x0
    80004902:	ba8080e7          	jalr	-1112(ra) # 800044a6 <iunlockput>
    ip = next;
    80004906:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004908:	0004c783          	lbu	a5,0(s1)
    8000490c:	01279763          	bne	a5,s2,8000491a <namex+0x11e>
    path++;
    80004910:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004912:	0004c783          	lbu	a5,0(s1)
    80004916:	ff278de3          	beq	a5,s2,80004910 <namex+0x114>
  if(*path == 0)
    8000491a:	cb9d                	beqz	a5,80004950 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000491c:	0004c783          	lbu	a5,0(s1)
    80004920:	89a6                	mv	s3,s1
  len = path - s;
    80004922:	4d01                	li	s10,0
    80004924:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004926:	01278963          	beq	a5,s2,80004938 <namex+0x13c>
    8000492a:	dbbd                	beqz	a5,800048a0 <namex+0xa4>
    path++;
    8000492c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000492e:	0009c783          	lbu	a5,0(s3)
    80004932:	ff279ce3          	bne	a5,s2,8000492a <namex+0x12e>
    80004936:	b7ad                	j	800048a0 <namex+0xa4>
    memmove(name, s, len);
    80004938:	2601                	sext.w	a2,a2
    8000493a:	85a6                	mv	a1,s1
    8000493c:	8556                	mv	a0,s5
    8000493e:	ffffc097          	auipc	ra,0xffffc
    80004942:	534080e7          	jalr	1332(ra) # 80000e72 <memmove>
    name[len] = 0;
    80004946:	9d56                	add	s10,s10,s5
    80004948:	000d0023          	sb	zero,0(s10)
    8000494c:	84ce                	mv	s1,s3
    8000494e:	b7bd                	j	800048bc <namex+0xc0>
  if(nameiparent){
    80004950:	f00b0ce3          	beqz	s6,80004868 <namex+0x6c>
    iput(ip);
    80004954:	8552                	mv	a0,s4
    80004956:	00000097          	auipc	ra,0x0
    8000495a:	aa8080e7          	jalr	-1368(ra) # 800043fe <iput>
    return 0;
    8000495e:	4a01                	li	s4,0
    80004960:	b721                	j	80004868 <namex+0x6c>

0000000080004962 <dirlink>:
{
    80004962:	715d                	addi	sp,sp,-80
    80004964:	e486                	sd	ra,72(sp)
    80004966:	e0a2                	sd	s0,64(sp)
    80004968:	f84a                	sd	s2,48(sp)
    8000496a:	ec56                	sd	s5,24(sp)
    8000496c:	e85a                	sd	s6,16(sp)
    8000496e:	0880                	addi	s0,sp,80
    80004970:	892a                	mv	s2,a0
    80004972:	8aae                	mv	s5,a1
    80004974:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004976:	4601                	li	a2,0
    80004978:	00000097          	auipc	ra,0x0
    8000497c:	dc4080e7          	jalr	-572(ra) # 8000473c <dirlookup>
    80004980:	e129                	bnez	a0,800049c2 <dirlink+0x60>
    80004982:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004984:	04c92483          	lw	s1,76(s2)
    80004988:	cca9                	beqz	s1,800049e2 <dirlink+0x80>
    8000498a:	f44e                	sd	s3,40(sp)
    8000498c:	f052                	sd	s4,32(sp)
    8000498e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004990:	fb040a13          	addi	s4,s0,-80
    80004994:	49c1                	li	s3,16
    80004996:	874e                	mv	a4,s3
    80004998:	86a6                	mv	a3,s1
    8000499a:	8652                	mv	a2,s4
    8000499c:	4581                	li	a1,0
    8000499e:	854a                	mv	a0,s2
    800049a0:	00000097          	auipc	ra,0x0
    800049a4:	b5c080e7          	jalr	-1188(ra) # 800044fc <readi>
    800049a8:	03351363          	bne	a0,s3,800049ce <dirlink+0x6c>
    if(de.inum == 0)
    800049ac:	fb045783          	lhu	a5,-80(s0)
    800049b0:	c79d                	beqz	a5,800049de <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800049b2:	24c1                	addiw	s1,s1,16
    800049b4:	04c92783          	lw	a5,76(s2)
    800049b8:	fcf4efe3          	bltu	s1,a5,80004996 <dirlink+0x34>
    800049bc:	79a2                	ld	s3,40(sp)
    800049be:	7a02                	ld	s4,32(sp)
    800049c0:	a00d                	j	800049e2 <dirlink+0x80>
    iput(ip);
    800049c2:	00000097          	auipc	ra,0x0
    800049c6:	a3c080e7          	jalr	-1476(ra) # 800043fe <iput>
    return -1;
    800049ca:	557d                	li	a0,-1
    800049cc:	a0a9                	j	80004a16 <dirlink+0xb4>
      panic("dirlink read");
    800049ce:	00006517          	auipc	a0,0x6
    800049d2:	bc250513          	addi	a0,a0,-1086 # 8000a590 <etext+0x590>
    800049d6:	ffffc097          	auipc	ra,0xffffc
    800049da:	b8a080e7          	jalr	-1142(ra) # 80000560 <panic>
    800049de:	79a2                	ld	s3,40(sp)
    800049e0:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800049e2:	4639                	li	a2,14
    800049e4:	85d6                	mv	a1,s5
    800049e6:	fb240513          	addi	a0,s0,-78
    800049ea:	ffffc097          	auipc	ra,0xffffc
    800049ee:	53a080e7          	jalr	1338(ra) # 80000f24 <strncpy>
  de.inum = inum;
    800049f2:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049f6:	4741                	li	a4,16
    800049f8:	86a6                	mv	a3,s1
    800049fa:	fb040613          	addi	a2,s0,-80
    800049fe:	4581                	li	a1,0
    80004a00:	854a                	mv	a0,s2
    80004a02:	00000097          	auipc	ra,0x0
    80004a06:	c00080e7          	jalr	-1024(ra) # 80004602 <writei>
    80004a0a:	1541                	addi	a0,a0,-16
    80004a0c:	00a03533          	snez	a0,a0
    80004a10:	40a0053b          	negw	a0,a0
    80004a14:	74e2                	ld	s1,56(sp)
}
    80004a16:	60a6                	ld	ra,72(sp)
    80004a18:	6406                	ld	s0,64(sp)
    80004a1a:	7942                	ld	s2,48(sp)
    80004a1c:	6ae2                	ld	s5,24(sp)
    80004a1e:	6b42                	ld	s6,16(sp)
    80004a20:	6161                	addi	sp,sp,80
    80004a22:	8082                	ret

0000000080004a24 <namei>:

struct inode*
namei(char *path)
{
    80004a24:	1101                	addi	sp,sp,-32
    80004a26:	ec06                	sd	ra,24(sp)
    80004a28:	e822                	sd	s0,16(sp)
    80004a2a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004a2c:	fe040613          	addi	a2,s0,-32
    80004a30:	4581                	li	a1,0
    80004a32:	00000097          	auipc	ra,0x0
    80004a36:	dca080e7          	jalr	-566(ra) # 800047fc <namex>
}
    80004a3a:	60e2                	ld	ra,24(sp)
    80004a3c:	6442                	ld	s0,16(sp)
    80004a3e:	6105                	addi	sp,sp,32
    80004a40:	8082                	ret

0000000080004a42 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004a42:	1141                	addi	sp,sp,-16
    80004a44:	e406                	sd	ra,8(sp)
    80004a46:	e022                	sd	s0,0(sp)
    80004a48:	0800                	addi	s0,sp,16
    80004a4a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004a4c:	4585                	li	a1,1
    80004a4e:	00000097          	auipc	ra,0x0
    80004a52:	dae080e7          	jalr	-594(ra) # 800047fc <namex>
}
    80004a56:	60a2                	ld	ra,8(sp)
    80004a58:	6402                	ld	s0,0(sp)
    80004a5a:	0141                	addi	sp,sp,16
    80004a5c:	8082                	ret

0000000080004a5e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004a5e:	1101                	addi	sp,sp,-32
    80004a60:	ec06                	sd	ra,24(sp)
    80004a62:	e822                	sd	s0,16(sp)
    80004a64:	e426                	sd	s1,8(sp)
    80004a66:	e04a                	sd	s2,0(sp)
    80004a68:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004a6a:	0006a917          	auipc	s2,0x6a
    80004a6e:	cd690913          	addi	s2,s2,-810 # 8006e740 <log>
    80004a72:	01892583          	lw	a1,24(s2)
    80004a76:	02892503          	lw	a0,40(s2)
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	fb8080e7          	jalr	-72(ra) # 80003a32 <bread>
    80004a82:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004a84:	02c92603          	lw	a2,44(s2)
    80004a88:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004a8a:	00c05f63          	blez	a2,80004aa8 <write_head+0x4a>
    80004a8e:	0006a717          	auipc	a4,0x6a
    80004a92:	ce270713          	addi	a4,a4,-798 # 8006e770 <log+0x30>
    80004a96:	87aa                	mv	a5,a0
    80004a98:	060a                	slli	a2,a2,0x2
    80004a9a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004a9c:	4314                	lw	a3,0(a4)
    80004a9e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004aa0:	0711                	addi	a4,a4,4
    80004aa2:	0791                	addi	a5,a5,4
    80004aa4:	fec79ce3          	bne	a5,a2,80004a9c <write_head+0x3e>
  }
  bwrite(buf);
    80004aa8:	8526                	mv	a0,s1
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	07a080e7          	jalr	122(ra) # 80003b24 <bwrite>
  brelse(buf);
    80004ab2:	8526                	mv	a0,s1
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	0ae080e7          	jalr	174(ra) # 80003b62 <brelse>
}
    80004abc:	60e2                	ld	ra,24(sp)
    80004abe:	6442                	ld	s0,16(sp)
    80004ac0:	64a2                	ld	s1,8(sp)
    80004ac2:	6902                	ld	s2,0(sp)
    80004ac4:	6105                	addi	sp,sp,32
    80004ac6:	8082                	ret

0000000080004ac8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004ac8:	0006a797          	auipc	a5,0x6a
    80004acc:	ca47a783          	lw	a5,-860(a5) # 8006e76c <log+0x2c>
    80004ad0:	0cf05063          	blez	a5,80004b90 <install_trans+0xc8>
{
    80004ad4:	715d                	addi	sp,sp,-80
    80004ad6:	e486                	sd	ra,72(sp)
    80004ad8:	e0a2                	sd	s0,64(sp)
    80004ada:	fc26                	sd	s1,56(sp)
    80004adc:	f84a                	sd	s2,48(sp)
    80004ade:	f44e                	sd	s3,40(sp)
    80004ae0:	f052                	sd	s4,32(sp)
    80004ae2:	ec56                	sd	s5,24(sp)
    80004ae4:	e85a                	sd	s6,16(sp)
    80004ae6:	e45e                	sd	s7,8(sp)
    80004ae8:	0880                	addi	s0,sp,80
    80004aea:	8b2a                	mv	s6,a0
    80004aec:	0006aa97          	auipc	s5,0x6a
    80004af0:	c84a8a93          	addi	s5,s5,-892 # 8006e770 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004af4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004af6:	0006a997          	auipc	s3,0x6a
    80004afa:	c4a98993          	addi	s3,s3,-950 # 8006e740 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004afe:	40000b93          	li	s7,1024
    80004b02:	a00d                	j	80004b24 <install_trans+0x5c>
    brelse(lbuf);
    80004b04:	854a                	mv	a0,s2
    80004b06:	fffff097          	auipc	ra,0xfffff
    80004b0a:	05c080e7          	jalr	92(ra) # 80003b62 <brelse>
    brelse(dbuf);
    80004b0e:	8526                	mv	a0,s1
    80004b10:	fffff097          	auipc	ra,0xfffff
    80004b14:	052080e7          	jalr	82(ra) # 80003b62 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b18:	2a05                	addiw	s4,s4,1
    80004b1a:	0a91                	addi	s5,s5,4
    80004b1c:	02c9a783          	lw	a5,44(s3)
    80004b20:	04fa5d63          	bge	s4,a5,80004b7a <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004b24:	0189a583          	lw	a1,24(s3)
    80004b28:	014585bb          	addw	a1,a1,s4
    80004b2c:	2585                	addiw	a1,a1,1
    80004b2e:	0289a503          	lw	a0,40(s3)
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	f00080e7          	jalr	-256(ra) # 80003a32 <bread>
    80004b3a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004b3c:	000aa583          	lw	a1,0(s5)
    80004b40:	0289a503          	lw	a0,40(s3)
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	eee080e7          	jalr	-274(ra) # 80003a32 <bread>
    80004b4c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004b4e:	865e                	mv	a2,s7
    80004b50:	05890593          	addi	a1,s2,88
    80004b54:	05850513          	addi	a0,a0,88
    80004b58:	ffffc097          	auipc	ra,0xffffc
    80004b5c:	31a080e7          	jalr	794(ra) # 80000e72 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004b60:	8526                	mv	a0,s1
    80004b62:	fffff097          	auipc	ra,0xfffff
    80004b66:	fc2080e7          	jalr	-62(ra) # 80003b24 <bwrite>
    if(recovering == 0)
    80004b6a:	f80b1de3          	bnez	s6,80004b04 <install_trans+0x3c>
      bunpin(dbuf);
    80004b6e:	8526                	mv	a0,s1
    80004b70:	fffff097          	auipc	ra,0xfffff
    80004b74:	0c6080e7          	jalr	198(ra) # 80003c36 <bunpin>
    80004b78:	b771                	j	80004b04 <install_trans+0x3c>
}
    80004b7a:	60a6                	ld	ra,72(sp)
    80004b7c:	6406                	ld	s0,64(sp)
    80004b7e:	74e2                	ld	s1,56(sp)
    80004b80:	7942                	ld	s2,48(sp)
    80004b82:	79a2                	ld	s3,40(sp)
    80004b84:	7a02                	ld	s4,32(sp)
    80004b86:	6ae2                	ld	s5,24(sp)
    80004b88:	6b42                	ld	s6,16(sp)
    80004b8a:	6ba2                	ld	s7,8(sp)
    80004b8c:	6161                	addi	sp,sp,80
    80004b8e:	8082                	ret
    80004b90:	8082                	ret

0000000080004b92 <initlog>:
{
    80004b92:	7179                	addi	sp,sp,-48
    80004b94:	f406                	sd	ra,40(sp)
    80004b96:	f022                	sd	s0,32(sp)
    80004b98:	ec26                	sd	s1,24(sp)
    80004b9a:	e84a                	sd	s2,16(sp)
    80004b9c:	e44e                	sd	s3,8(sp)
    80004b9e:	1800                	addi	s0,sp,48
    80004ba0:	892a                	mv	s2,a0
    80004ba2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004ba4:	0006a497          	auipc	s1,0x6a
    80004ba8:	b9c48493          	addi	s1,s1,-1124 # 8006e740 <log>
    80004bac:	00006597          	auipc	a1,0x6
    80004bb0:	9f458593          	addi	a1,a1,-1548 # 8000a5a0 <etext+0x5a0>
    80004bb4:	8526                	mv	a0,s1
    80004bb6:	ffffc097          	auipc	ra,0xffffc
    80004bba:	0cc080e7          	jalr	204(ra) # 80000c82 <initlock>
  log.start = sb->logstart;
    80004bbe:	0149a583          	lw	a1,20(s3)
    80004bc2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004bc4:	0109a783          	lw	a5,16(s3)
    80004bc8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004bca:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004bce:	854a                	mv	a0,s2
    80004bd0:	fffff097          	auipc	ra,0xfffff
    80004bd4:	e62080e7          	jalr	-414(ra) # 80003a32 <bread>
  log.lh.n = lh->n;
    80004bd8:	4d30                	lw	a2,88(a0)
    80004bda:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004bdc:	00c05f63          	blez	a2,80004bfa <initlog+0x68>
    80004be0:	87aa                	mv	a5,a0
    80004be2:	0006a717          	auipc	a4,0x6a
    80004be6:	b8e70713          	addi	a4,a4,-1138 # 8006e770 <log+0x30>
    80004bea:	060a                	slli	a2,a2,0x2
    80004bec:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004bee:	4ff4                	lw	a3,92(a5)
    80004bf0:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004bf2:	0791                	addi	a5,a5,4
    80004bf4:	0711                	addi	a4,a4,4
    80004bf6:	fec79ce3          	bne	a5,a2,80004bee <initlog+0x5c>
  brelse(buf);
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	f68080e7          	jalr	-152(ra) # 80003b62 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004c02:	4505                	li	a0,1
    80004c04:	00000097          	auipc	ra,0x0
    80004c08:	ec4080e7          	jalr	-316(ra) # 80004ac8 <install_trans>
  log.lh.n = 0;
    80004c0c:	0006a797          	auipc	a5,0x6a
    80004c10:	b607a023          	sw	zero,-1184(a5) # 8006e76c <log+0x2c>
  write_head(); // clear the log
    80004c14:	00000097          	auipc	ra,0x0
    80004c18:	e4a080e7          	jalr	-438(ra) # 80004a5e <write_head>
}
    80004c1c:	70a2                	ld	ra,40(sp)
    80004c1e:	7402                	ld	s0,32(sp)
    80004c20:	64e2                	ld	s1,24(sp)
    80004c22:	6942                	ld	s2,16(sp)
    80004c24:	69a2                	ld	s3,8(sp)
    80004c26:	6145                	addi	sp,sp,48
    80004c28:	8082                	ret

0000000080004c2a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004c2a:	1101                	addi	sp,sp,-32
    80004c2c:	ec06                	sd	ra,24(sp)
    80004c2e:	e822                	sd	s0,16(sp)
    80004c30:	e426                	sd	s1,8(sp)
    80004c32:	e04a                	sd	s2,0(sp)
    80004c34:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004c36:	0006a517          	auipc	a0,0x6a
    80004c3a:	b0a50513          	addi	a0,a0,-1270 # 8006e740 <log>
    80004c3e:	ffffc097          	auipc	ra,0xffffc
    80004c42:	0d8080e7          	jalr	216(ra) # 80000d16 <acquire>
  while(1){
    if(log.committing){
    80004c46:	0006a497          	auipc	s1,0x6a
    80004c4a:	afa48493          	addi	s1,s1,-1286 # 8006e740 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004c4e:	4979                	li	s2,30
    80004c50:	a039                	j	80004c5e <begin_op+0x34>
      sleep(&log, &log.lock);
    80004c52:	85a6                	mv	a1,s1
    80004c54:	8526                	mv	a0,s1
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	ab2080e7          	jalr	-1358(ra) # 80002708 <sleep>
    if(log.committing){
    80004c5e:	50dc                	lw	a5,36(s1)
    80004c60:	fbed                	bnez	a5,80004c52 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004c62:	5098                	lw	a4,32(s1)
    80004c64:	2705                	addiw	a4,a4,1
    80004c66:	0027179b          	slliw	a5,a4,0x2
    80004c6a:	9fb9                	addw	a5,a5,a4
    80004c6c:	0017979b          	slliw	a5,a5,0x1
    80004c70:	54d4                	lw	a3,44(s1)
    80004c72:	9fb5                	addw	a5,a5,a3
    80004c74:	00f95963          	bge	s2,a5,80004c86 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004c78:	85a6                	mv	a1,s1
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	a8c080e7          	jalr	-1396(ra) # 80002708 <sleep>
    80004c84:	bfe9                	j	80004c5e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004c86:	0006a517          	auipc	a0,0x6a
    80004c8a:	aba50513          	addi	a0,a0,-1350 # 8006e740 <log>
    80004c8e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004c90:	ffffc097          	auipc	ra,0xffffc
    80004c94:	136080e7          	jalr	310(ra) # 80000dc6 <release>
      break;
    }
  }
}
    80004c98:	60e2                	ld	ra,24(sp)
    80004c9a:	6442                	ld	s0,16(sp)
    80004c9c:	64a2                	ld	s1,8(sp)
    80004c9e:	6902                	ld	s2,0(sp)
    80004ca0:	6105                	addi	sp,sp,32
    80004ca2:	8082                	ret

0000000080004ca4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004ca4:	7139                	addi	sp,sp,-64
    80004ca6:	fc06                	sd	ra,56(sp)
    80004ca8:	f822                	sd	s0,48(sp)
    80004caa:	f426                	sd	s1,40(sp)
    80004cac:	f04a                	sd	s2,32(sp)
    80004cae:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004cb0:	0006a497          	auipc	s1,0x6a
    80004cb4:	a9048493          	addi	s1,s1,-1392 # 8006e740 <log>
    80004cb8:	8526                	mv	a0,s1
    80004cba:	ffffc097          	auipc	ra,0xffffc
    80004cbe:	05c080e7          	jalr	92(ra) # 80000d16 <acquire>
  log.outstanding -= 1;
    80004cc2:	509c                	lw	a5,32(s1)
    80004cc4:	37fd                	addiw	a5,a5,-1
    80004cc6:	893e                	mv	s2,a5
    80004cc8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004cca:	50dc                	lw	a5,36(s1)
    80004ccc:	e7b9                	bnez	a5,80004d1a <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    80004cce:	06091263          	bnez	s2,80004d32 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004cd2:	0006a497          	auipc	s1,0x6a
    80004cd6:	a6e48493          	addi	s1,s1,-1426 # 8006e740 <log>
    80004cda:	4785                	li	a5,1
    80004cdc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004cde:	8526                	mv	a0,s1
    80004ce0:	ffffc097          	auipc	ra,0xffffc
    80004ce4:	0e6080e7          	jalr	230(ra) # 80000dc6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004ce8:	54dc                	lw	a5,44(s1)
    80004cea:	06f04863          	bgtz	a5,80004d5a <end_op+0xb6>
    acquire(&log.lock);
    80004cee:	0006a497          	auipc	s1,0x6a
    80004cf2:	a5248493          	addi	s1,s1,-1454 # 8006e740 <log>
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	ffffc097          	auipc	ra,0xffffc
    80004cfc:	01e080e7          	jalr	30(ra) # 80000d16 <acquire>
    log.committing = 0;
    80004d00:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004d04:	8526                	mv	a0,s1
    80004d06:	ffffe097          	auipc	ra,0xffffe
    80004d0a:	a66080e7          	jalr	-1434(ra) # 8000276c <wakeup>
    release(&log.lock);
    80004d0e:	8526                	mv	a0,s1
    80004d10:	ffffc097          	auipc	ra,0xffffc
    80004d14:	0b6080e7          	jalr	182(ra) # 80000dc6 <release>
}
    80004d18:	a81d                	j	80004d4e <end_op+0xaa>
    80004d1a:	ec4e                	sd	s3,24(sp)
    80004d1c:	e852                	sd	s4,16(sp)
    80004d1e:	e456                	sd	s5,8(sp)
    80004d20:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80004d22:	00006517          	auipc	a0,0x6
    80004d26:	88650513          	addi	a0,a0,-1914 # 8000a5a8 <etext+0x5a8>
    80004d2a:	ffffc097          	auipc	ra,0xffffc
    80004d2e:	836080e7          	jalr	-1994(ra) # 80000560 <panic>
    wakeup(&log);
    80004d32:	0006a497          	auipc	s1,0x6a
    80004d36:	a0e48493          	addi	s1,s1,-1522 # 8006e740 <log>
    80004d3a:	8526                	mv	a0,s1
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	a30080e7          	jalr	-1488(ra) # 8000276c <wakeup>
  release(&log.lock);
    80004d44:	8526                	mv	a0,s1
    80004d46:	ffffc097          	auipc	ra,0xffffc
    80004d4a:	080080e7          	jalr	128(ra) # 80000dc6 <release>
}
    80004d4e:	70e2                	ld	ra,56(sp)
    80004d50:	7442                	ld	s0,48(sp)
    80004d52:	74a2                	ld	s1,40(sp)
    80004d54:	7902                	ld	s2,32(sp)
    80004d56:	6121                	addi	sp,sp,64
    80004d58:	8082                	ret
    80004d5a:	ec4e                	sd	s3,24(sp)
    80004d5c:	e852                	sd	s4,16(sp)
    80004d5e:	e456                	sd	s5,8(sp)
    80004d60:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004d62:	0006aa97          	auipc	s5,0x6a
    80004d66:	a0ea8a93          	addi	s5,s5,-1522 # 8006e770 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004d6a:	0006aa17          	auipc	s4,0x6a
    80004d6e:	9d6a0a13          	addi	s4,s4,-1578 # 8006e740 <log>
    memmove(to->data, from->data, BSIZE);
    80004d72:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004d76:	018a2583          	lw	a1,24(s4)
    80004d7a:	012585bb          	addw	a1,a1,s2
    80004d7e:	2585                	addiw	a1,a1,1
    80004d80:	028a2503          	lw	a0,40(s4)
    80004d84:	fffff097          	auipc	ra,0xfffff
    80004d88:	cae080e7          	jalr	-850(ra) # 80003a32 <bread>
    80004d8c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004d8e:	000aa583          	lw	a1,0(s5)
    80004d92:	028a2503          	lw	a0,40(s4)
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	c9c080e7          	jalr	-868(ra) # 80003a32 <bread>
    80004d9e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004da0:	865a                	mv	a2,s6
    80004da2:	05850593          	addi	a1,a0,88
    80004da6:	05848513          	addi	a0,s1,88
    80004daa:	ffffc097          	auipc	ra,0xffffc
    80004dae:	0c8080e7          	jalr	200(ra) # 80000e72 <memmove>
    bwrite(to);  // write the log
    80004db2:	8526                	mv	a0,s1
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	d70080e7          	jalr	-656(ra) # 80003b24 <bwrite>
    brelse(from);
    80004dbc:	854e                	mv	a0,s3
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	da4080e7          	jalr	-604(ra) # 80003b62 <brelse>
    brelse(to);
    80004dc6:	8526                	mv	a0,s1
    80004dc8:	fffff097          	auipc	ra,0xfffff
    80004dcc:	d9a080e7          	jalr	-614(ra) # 80003b62 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004dd0:	2905                	addiw	s2,s2,1
    80004dd2:	0a91                	addi	s5,s5,4
    80004dd4:	02ca2783          	lw	a5,44(s4)
    80004dd8:	f8f94fe3          	blt	s2,a5,80004d76 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004ddc:	00000097          	auipc	ra,0x0
    80004de0:	c82080e7          	jalr	-894(ra) # 80004a5e <write_head>
    install_trans(0); // Now install writes to home locations
    80004de4:	4501                	li	a0,0
    80004de6:	00000097          	auipc	ra,0x0
    80004dea:	ce2080e7          	jalr	-798(ra) # 80004ac8 <install_trans>
    log.lh.n = 0;
    80004dee:	0006a797          	auipc	a5,0x6a
    80004df2:	9607af23          	sw	zero,-1666(a5) # 8006e76c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004df6:	00000097          	auipc	ra,0x0
    80004dfa:	c68080e7          	jalr	-920(ra) # 80004a5e <write_head>
    80004dfe:	69e2                	ld	s3,24(sp)
    80004e00:	6a42                	ld	s4,16(sp)
    80004e02:	6aa2                	ld	s5,8(sp)
    80004e04:	6b02                	ld	s6,0(sp)
    80004e06:	b5e5                	j	80004cee <end_op+0x4a>

0000000080004e08 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004e08:	1101                	addi	sp,sp,-32
    80004e0a:	ec06                	sd	ra,24(sp)
    80004e0c:	e822                	sd	s0,16(sp)
    80004e0e:	e426                	sd	s1,8(sp)
    80004e10:	e04a                	sd	s2,0(sp)
    80004e12:	1000                	addi	s0,sp,32
    80004e14:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004e16:	0006a917          	auipc	s2,0x6a
    80004e1a:	92a90913          	addi	s2,s2,-1750 # 8006e740 <log>
    80004e1e:	854a                	mv	a0,s2
    80004e20:	ffffc097          	auipc	ra,0xffffc
    80004e24:	ef6080e7          	jalr	-266(ra) # 80000d16 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004e28:	02c92603          	lw	a2,44(s2)
    80004e2c:	47f5                	li	a5,29
    80004e2e:	06c7c563          	blt	a5,a2,80004e98 <log_write+0x90>
    80004e32:	0006a797          	auipc	a5,0x6a
    80004e36:	92a7a783          	lw	a5,-1750(a5) # 8006e75c <log+0x1c>
    80004e3a:	37fd                	addiw	a5,a5,-1
    80004e3c:	04f65e63          	bge	a2,a5,80004e98 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004e40:	0006a797          	auipc	a5,0x6a
    80004e44:	9207a783          	lw	a5,-1760(a5) # 8006e760 <log+0x20>
    80004e48:	06f05063          	blez	a5,80004ea8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004e4c:	4781                	li	a5,0
    80004e4e:	06c05563          	blez	a2,80004eb8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004e52:	44cc                	lw	a1,12(s1)
    80004e54:	0006a717          	auipc	a4,0x6a
    80004e58:	91c70713          	addi	a4,a4,-1764 # 8006e770 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004e5c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004e5e:	4314                	lw	a3,0(a4)
    80004e60:	04b68c63          	beq	a3,a1,80004eb8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004e64:	2785                	addiw	a5,a5,1
    80004e66:	0711                	addi	a4,a4,4
    80004e68:	fef61be3          	bne	a2,a5,80004e5e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004e6c:	0621                	addi	a2,a2,8
    80004e6e:	060a                	slli	a2,a2,0x2
    80004e70:	0006a797          	auipc	a5,0x6a
    80004e74:	8d078793          	addi	a5,a5,-1840 # 8006e740 <log>
    80004e78:	97b2                	add	a5,a5,a2
    80004e7a:	44d8                	lw	a4,12(s1)
    80004e7c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004e7e:	8526                	mv	a0,s1
    80004e80:	fffff097          	auipc	ra,0xfffff
    80004e84:	d7a080e7          	jalr	-646(ra) # 80003bfa <bpin>
    log.lh.n++;
    80004e88:	0006a717          	auipc	a4,0x6a
    80004e8c:	8b870713          	addi	a4,a4,-1864 # 8006e740 <log>
    80004e90:	575c                	lw	a5,44(a4)
    80004e92:	2785                	addiw	a5,a5,1
    80004e94:	d75c                	sw	a5,44(a4)
    80004e96:	a82d                	j	80004ed0 <log_write+0xc8>
    panic("too big a transaction");
    80004e98:	00005517          	auipc	a0,0x5
    80004e9c:	72050513          	addi	a0,a0,1824 # 8000a5b8 <etext+0x5b8>
    80004ea0:	ffffb097          	auipc	ra,0xffffb
    80004ea4:	6c0080e7          	jalr	1728(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004ea8:	00005517          	auipc	a0,0x5
    80004eac:	72850513          	addi	a0,a0,1832 # 8000a5d0 <etext+0x5d0>
    80004eb0:	ffffb097          	auipc	ra,0xffffb
    80004eb4:	6b0080e7          	jalr	1712(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004eb8:	00878693          	addi	a3,a5,8
    80004ebc:	068a                	slli	a3,a3,0x2
    80004ebe:	0006a717          	auipc	a4,0x6a
    80004ec2:	88270713          	addi	a4,a4,-1918 # 8006e740 <log>
    80004ec6:	9736                	add	a4,a4,a3
    80004ec8:	44d4                	lw	a3,12(s1)
    80004eca:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004ecc:	faf609e3          	beq	a2,a5,80004e7e <log_write+0x76>
  }
  release(&log.lock);
    80004ed0:	0006a517          	auipc	a0,0x6a
    80004ed4:	87050513          	addi	a0,a0,-1936 # 8006e740 <log>
    80004ed8:	ffffc097          	auipc	ra,0xffffc
    80004edc:	eee080e7          	jalr	-274(ra) # 80000dc6 <release>
}
    80004ee0:	60e2                	ld	ra,24(sp)
    80004ee2:	6442                	ld	s0,16(sp)
    80004ee4:	64a2                	ld	s1,8(sp)
    80004ee6:	6902                	ld	s2,0(sp)
    80004ee8:	6105                	addi	sp,sp,32
    80004eea:	8082                	ret

0000000080004eec <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004eec:	1101                	addi	sp,sp,-32
    80004eee:	ec06                	sd	ra,24(sp)
    80004ef0:	e822                	sd	s0,16(sp)
    80004ef2:	e426                	sd	s1,8(sp)
    80004ef4:	e04a                	sd	s2,0(sp)
    80004ef6:	1000                	addi	s0,sp,32
    80004ef8:	84aa                	mv	s1,a0
    80004efa:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004efc:	00005597          	auipc	a1,0x5
    80004f00:	6f458593          	addi	a1,a1,1780 # 8000a5f0 <etext+0x5f0>
    80004f04:	0521                	addi	a0,a0,8
    80004f06:	ffffc097          	auipc	ra,0xffffc
    80004f0a:	d7c080e7          	jalr	-644(ra) # 80000c82 <initlock>
  lk->name = name;
    80004f0e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004f12:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004f16:	0204a423          	sw	zero,40(s1)
}
    80004f1a:	60e2                	ld	ra,24(sp)
    80004f1c:	6442                	ld	s0,16(sp)
    80004f1e:	64a2                	ld	s1,8(sp)
    80004f20:	6902                	ld	s2,0(sp)
    80004f22:	6105                	addi	sp,sp,32
    80004f24:	8082                	ret

0000000080004f26 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004f26:	1101                	addi	sp,sp,-32
    80004f28:	ec06                	sd	ra,24(sp)
    80004f2a:	e822                	sd	s0,16(sp)
    80004f2c:	e426                	sd	s1,8(sp)
    80004f2e:	e04a                	sd	s2,0(sp)
    80004f30:	1000                	addi	s0,sp,32
    80004f32:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004f34:	00850913          	addi	s2,a0,8
    80004f38:	854a                	mv	a0,s2
    80004f3a:	ffffc097          	auipc	ra,0xffffc
    80004f3e:	ddc080e7          	jalr	-548(ra) # 80000d16 <acquire>
  while (lk->locked) {
    80004f42:	409c                	lw	a5,0(s1)
    80004f44:	cb89                	beqz	a5,80004f56 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004f46:	85ca                	mv	a1,s2
    80004f48:	8526                	mv	a0,s1
    80004f4a:	ffffd097          	auipc	ra,0xffffd
    80004f4e:	7be080e7          	jalr	1982(ra) # 80002708 <sleep>
  while (lk->locked) {
    80004f52:	409c                	lw	a5,0(s1)
    80004f54:	fbed                	bnez	a5,80004f46 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004f56:	4785                	li	a5,1
    80004f58:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004f5a:	ffffd097          	auipc	ra,0xffffd
    80004f5e:	f00080e7          	jalr	-256(ra) # 80001e5a <myproc>
    80004f62:	591c                	lw	a5,48(a0)
    80004f64:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004f66:	854a                	mv	a0,s2
    80004f68:	ffffc097          	auipc	ra,0xffffc
    80004f6c:	e5e080e7          	jalr	-418(ra) # 80000dc6 <release>
}
    80004f70:	60e2                	ld	ra,24(sp)
    80004f72:	6442                	ld	s0,16(sp)
    80004f74:	64a2                	ld	s1,8(sp)
    80004f76:	6902                	ld	s2,0(sp)
    80004f78:	6105                	addi	sp,sp,32
    80004f7a:	8082                	ret

0000000080004f7c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004f7c:	1101                	addi	sp,sp,-32
    80004f7e:	ec06                	sd	ra,24(sp)
    80004f80:	e822                	sd	s0,16(sp)
    80004f82:	e426                	sd	s1,8(sp)
    80004f84:	e04a                	sd	s2,0(sp)
    80004f86:	1000                	addi	s0,sp,32
    80004f88:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004f8a:	00850913          	addi	s2,a0,8
    80004f8e:	854a                	mv	a0,s2
    80004f90:	ffffc097          	auipc	ra,0xffffc
    80004f94:	d86080e7          	jalr	-634(ra) # 80000d16 <acquire>
  lk->locked = 0;
    80004f98:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004f9c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004fa0:	8526                	mv	a0,s1
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	7ca080e7          	jalr	1994(ra) # 8000276c <wakeup>
  release(&lk->lk);
    80004faa:	854a                	mv	a0,s2
    80004fac:	ffffc097          	auipc	ra,0xffffc
    80004fb0:	e1a080e7          	jalr	-486(ra) # 80000dc6 <release>
}
    80004fb4:	60e2                	ld	ra,24(sp)
    80004fb6:	6442                	ld	s0,16(sp)
    80004fb8:	64a2                	ld	s1,8(sp)
    80004fba:	6902                	ld	s2,0(sp)
    80004fbc:	6105                	addi	sp,sp,32
    80004fbe:	8082                	ret

0000000080004fc0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004fc0:	7179                	addi	sp,sp,-48
    80004fc2:	f406                	sd	ra,40(sp)
    80004fc4:	f022                	sd	s0,32(sp)
    80004fc6:	ec26                	sd	s1,24(sp)
    80004fc8:	e84a                	sd	s2,16(sp)
    80004fca:	1800                	addi	s0,sp,48
    80004fcc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004fce:	00850913          	addi	s2,a0,8
    80004fd2:	854a                	mv	a0,s2
    80004fd4:	ffffc097          	auipc	ra,0xffffc
    80004fd8:	d42080e7          	jalr	-702(ra) # 80000d16 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004fdc:	409c                	lw	a5,0(s1)
    80004fde:	ef91                	bnez	a5,80004ffa <holdingsleep+0x3a>
    80004fe0:	4481                	li	s1,0
  release(&lk->lk);
    80004fe2:	854a                	mv	a0,s2
    80004fe4:	ffffc097          	auipc	ra,0xffffc
    80004fe8:	de2080e7          	jalr	-542(ra) # 80000dc6 <release>
  return r;
}
    80004fec:	8526                	mv	a0,s1
    80004fee:	70a2                	ld	ra,40(sp)
    80004ff0:	7402                	ld	s0,32(sp)
    80004ff2:	64e2                	ld	s1,24(sp)
    80004ff4:	6942                	ld	s2,16(sp)
    80004ff6:	6145                	addi	sp,sp,48
    80004ff8:	8082                	ret
    80004ffa:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004ffc:	0284a983          	lw	s3,40(s1)
    80005000:	ffffd097          	auipc	ra,0xffffd
    80005004:	e5a080e7          	jalr	-422(ra) # 80001e5a <myproc>
    80005008:	5904                	lw	s1,48(a0)
    8000500a:	413484b3          	sub	s1,s1,s3
    8000500e:	0014b493          	seqz	s1,s1
    80005012:	69a2                	ld	s3,8(sp)
    80005014:	b7f9                	j	80004fe2 <holdingsleep+0x22>

0000000080005016 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005016:	1141                	addi	sp,sp,-16
    80005018:	e406                	sd	ra,8(sp)
    8000501a:	e022                	sd	s0,0(sp)
    8000501c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000501e:	00005597          	auipc	a1,0x5
    80005022:	5e258593          	addi	a1,a1,1506 # 8000a600 <etext+0x600>
    80005026:	0006a517          	auipc	a0,0x6a
    8000502a:	86250513          	addi	a0,a0,-1950 # 8006e888 <ftable>
    8000502e:	ffffc097          	auipc	ra,0xffffc
    80005032:	c54080e7          	jalr	-940(ra) # 80000c82 <initlock>
}
    80005036:	60a2                	ld	ra,8(sp)
    80005038:	6402                	ld	s0,0(sp)
    8000503a:	0141                	addi	sp,sp,16
    8000503c:	8082                	ret

000000008000503e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000503e:	1101                	addi	sp,sp,-32
    80005040:	ec06                	sd	ra,24(sp)
    80005042:	e822                	sd	s0,16(sp)
    80005044:	e426                	sd	s1,8(sp)
    80005046:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005048:	0006a517          	auipc	a0,0x6a
    8000504c:	84050513          	addi	a0,a0,-1984 # 8006e888 <ftable>
    80005050:	ffffc097          	auipc	ra,0xffffc
    80005054:	cc6080e7          	jalr	-826(ra) # 80000d16 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005058:	0006a497          	auipc	s1,0x6a
    8000505c:	84848493          	addi	s1,s1,-1976 # 8006e8a0 <ftable+0x18>
    80005060:	0006a717          	auipc	a4,0x6a
    80005064:	7e070713          	addi	a4,a4,2016 # 8006f840 <disk>
    if(f->ref == 0){
    80005068:	40dc                	lw	a5,4(s1)
    8000506a:	cf99                	beqz	a5,80005088 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000506c:	02848493          	addi	s1,s1,40
    80005070:	fee49ce3          	bne	s1,a4,80005068 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005074:	0006a517          	auipc	a0,0x6a
    80005078:	81450513          	addi	a0,a0,-2028 # 8006e888 <ftable>
    8000507c:	ffffc097          	auipc	ra,0xffffc
    80005080:	d4a080e7          	jalr	-694(ra) # 80000dc6 <release>
  return 0;
    80005084:	4481                	li	s1,0
    80005086:	a819                	j	8000509c <filealloc+0x5e>
      f->ref = 1;
    80005088:	4785                	li	a5,1
    8000508a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000508c:	00069517          	auipc	a0,0x69
    80005090:	7fc50513          	addi	a0,a0,2044 # 8006e888 <ftable>
    80005094:	ffffc097          	auipc	ra,0xffffc
    80005098:	d32080e7          	jalr	-718(ra) # 80000dc6 <release>
}
    8000509c:	8526                	mv	a0,s1
    8000509e:	60e2                	ld	ra,24(sp)
    800050a0:	6442                	ld	s0,16(sp)
    800050a2:	64a2                	ld	s1,8(sp)
    800050a4:	6105                	addi	sp,sp,32
    800050a6:	8082                	ret

00000000800050a8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800050a8:	1101                	addi	sp,sp,-32
    800050aa:	ec06                	sd	ra,24(sp)
    800050ac:	e822                	sd	s0,16(sp)
    800050ae:	e426                	sd	s1,8(sp)
    800050b0:	1000                	addi	s0,sp,32
    800050b2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800050b4:	00069517          	auipc	a0,0x69
    800050b8:	7d450513          	addi	a0,a0,2004 # 8006e888 <ftable>
    800050bc:	ffffc097          	auipc	ra,0xffffc
    800050c0:	c5a080e7          	jalr	-934(ra) # 80000d16 <acquire>
  if(f->ref < 1)
    800050c4:	40dc                	lw	a5,4(s1)
    800050c6:	02f05263          	blez	a5,800050ea <filedup+0x42>
    panic("filedup");
  f->ref++;
    800050ca:	2785                	addiw	a5,a5,1
    800050cc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800050ce:	00069517          	auipc	a0,0x69
    800050d2:	7ba50513          	addi	a0,a0,1978 # 8006e888 <ftable>
    800050d6:	ffffc097          	auipc	ra,0xffffc
    800050da:	cf0080e7          	jalr	-784(ra) # 80000dc6 <release>
  return f;
}
    800050de:	8526                	mv	a0,s1
    800050e0:	60e2                	ld	ra,24(sp)
    800050e2:	6442                	ld	s0,16(sp)
    800050e4:	64a2                	ld	s1,8(sp)
    800050e6:	6105                	addi	sp,sp,32
    800050e8:	8082                	ret
    panic("filedup");
    800050ea:	00005517          	auipc	a0,0x5
    800050ee:	51e50513          	addi	a0,a0,1310 # 8000a608 <etext+0x608>
    800050f2:	ffffb097          	auipc	ra,0xffffb
    800050f6:	46e080e7          	jalr	1134(ra) # 80000560 <panic>

00000000800050fa <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800050fa:	7139                	addi	sp,sp,-64
    800050fc:	fc06                	sd	ra,56(sp)
    800050fe:	f822                	sd	s0,48(sp)
    80005100:	f426                	sd	s1,40(sp)
    80005102:	0080                	addi	s0,sp,64
    80005104:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005106:	00069517          	auipc	a0,0x69
    8000510a:	78250513          	addi	a0,a0,1922 # 8006e888 <ftable>
    8000510e:	ffffc097          	auipc	ra,0xffffc
    80005112:	c08080e7          	jalr	-1016(ra) # 80000d16 <acquire>
  if(f->ref < 1)
    80005116:	40dc                	lw	a5,4(s1)
    80005118:	04f05a63          	blez	a5,8000516c <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    8000511c:	37fd                	addiw	a5,a5,-1
    8000511e:	c0dc                	sw	a5,4(s1)
    80005120:	06f04263          	bgtz	a5,80005184 <fileclose+0x8a>
    80005124:	f04a                	sd	s2,32(sp)
    80005126:	ec4e                	sd	s3,24(sp)
    80005128:	e852                	sd	s4,16(sp)
    8000512a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000512c:	0004a903          	lw	s2,0(s1)
    80005130:	0094ca83          	lbu	s5,9(s1)
    80005134:	0104ba03          	ld	s4,16(s1)
    80005138:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000513c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80005140:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80005144:	00069517          	auipc	a0,0x69
    80005148:	74450513          	addi	a0,a0,1860 # 8006e888 <ftable>
    8000514c:	ffffc097          	auipc	ra,0xffffc
    80005150:	c7a080e7          	jalr	-902(ra) # 80000dc6 <release>

  if(ff.type == FD_PIPE){
    80005154:	4785                	li	a5,1
    80005156:	04f90463          	beq	s2,a5,8000519e <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000515a:	3979                	addiw	s2,s2,-2
    8000515c:	4785                	li	a5,1
    8000515e:	0527fb63          	bgeu	a5,s2,800051b4 <fileclose+0xba>
    80005162:	7902                	ld	s2,32(sp)
    80005164:	69e2                	ld	s3,24(sp)
    80005166:	6a42                	ld	s4,16(sp)
    80005168:	6aa2                	ld	s5,8(sp)
    8000516a:	a02d                	j	80005194 <fileclose+0x9a>
    8000516c:	f04a                	sd	s2,32(sp)
    8000516e:	ec4e                	sd	s3,24(sp)
    80005170:	e852                	sd	s4,16(sp)
    80005172:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80005174:	00005517          	auipc	a0,0x5
    80005178:	49c50513          	addi	a0,a0,1180 # 8000a610 <etext+0x610>
    8000517c:	ffffb097          	auipc	ra,0xffffb
    80005180:	3e4080e7          	jalr	996(ra) # 80000560 <panic>
    release(&ftable.lock);
    80005184:	00069517          	auipc	a0,0x69
    80005188:	70450513          	addi	a0,a0,1796 # 8006e888 <ftable>
    8000518c:	ffffc097          	auipc	ra,0xffffc
    80005190:	c3a080e7          	jalr	-966(ra) # 80000dc6 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80005194:	70e2                	ld	ra,56(sp)
    80005196:	7442                	ld	s0,48(sp)
    80005198:	74a2                	ld	s1,40(sp)
    8000519a:	6121                	addi	sp,sp,64
    8000519c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000519e:	85d6                	mv	a1,s5
    800051a0:	8552                	mv	a0,s4
    800051a2:	00000097          	auipc	ra,0x0
    800051a6:	3ac080e7          	jalr	940(ra) # 8000554e <pipeclose>
    800051aa:	7902                	ld	s2,32(sp)
    800051ac:	69e2                	ld	s3,24(sp)
    800051ae:	6a42                	ld	s4,16(sp)
    800051b0:	6aa2                	ld	s5,8(sp)
    800051b2:	b7cd                	j	80005194 <fileclose+0x9a>
    begin_op();
    800051b4:	00000097          	auipc	ra,0x0
    800051b8:	a76080e7          	jalr	-1418(ra) # 80004c2a <begin_op>
    iput(ff.ip);
    800051bc:	854e                	mv	a0,s3
    800051be:	fffff097          	auipc	ra,0xfffff
    800051c2:	240080e7          	jalr	576(ra) # 800043fe <iput>
    end_op();
    800051c6:	00000097          	auipc	ra,0x0
    800051ca:	ade080e7          	jalr	-1314(ra) # 80004ca4 <end_op>
    800051ce:	7902                	ld	s2,32(sp)
    800051d0:	69e2                	ld	s3,24(sp)
    800051d2:	6a42                	ld	s4,16(sp)
    800051d4:	6aa2                	ld	s5,8(sp)
    800051d6:	bf7d                	j	80005194 <fileclose+0x9a>

00000000800051d8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800051d8:	715d                	addi	sp,sp,-80
    800051da:	e486                	sd	ra,72(sp)
    800051dc:	e0a2                	sd	s0,64(sp)
    800051de:	fc26                	sd	s1,56(sp)
    800051e0:	f44e                	sd	s3,40(sp)
    800051e2:	0880                	addi	s0,sp,80
    800051e4:	84aa                	mv	s1,a0
    800051e6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800051e8:	ffffd097          	auipc	ra,0xffffd
    800051ec:	c72080e7          	jalr	-910(ra) # 80001e5a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800051f0:	409c                	lw	a5,0(s1)
    800051f2:	37f9                	addiw	a5,a5,-2
    800051f4:	4705                	li	a4,1
    800051f6:	04f76a63          	bltu	a4,a5,8000524a <filestat+0x72>
    800051fa:	f84a                	sd	s2,48(sp)
    800051fc:	f052                	sd	s4,32(sp)
    800051fe:	892a                	mv	s2,a0
    ilock(f->ip);
    80005200:	6c88                	ld	a0,24(s1)
    80005202:	fffff097          	auipc	ra,0xfffff
    80005206:	03e080e7          	jalr	62(ra) # 80004240 <ilock>
    stati(f->ip, &st);
    8000520a:	fb840a13          	addi	s4,s0,-72
    8000520e:	85d2                	mv	a1,s4
    80005210:	6c88                	ld	a0,24(s1)
    80005212:	fffff097          	auipc	ra,0xfffff
    80005216:	2bc080e7          	jalr	700(ra) # 800044ce <stati>
    iunlock(f->ip);
    8000521a:	6c88                	ld	a0,24(s1)
    8000521c:	fffff097          	auipc	ra,0xfffff
    80005220:	0ea080e7          	jalr	234(ra) # 80004306 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80005224:	46e1                	li	a3,24
    80005226:	8652                	mv	a2,s4
    80005228:	85ce                	mv	a1,s3
    8000522a:	05093503          	ld	a0,80(s2)
    8000522e:	ffffd097          	auipc	ra,0xffffd
    80005232:	8d4080e7          	jalr	-1836(ra) # 80001b02 <copyout>
    80005236:	41f5551b          	sraiw	a0,a0,0x1f
    8000523a:	7942                	ld	s2,48(sp)
    8000523c:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000523e:	60a6                	ld	ra,72(sp)
    80005240:	6406                	ld	s0,64(sp)
    80005242:	74e2                	ld	s1,56(sp)
    80005244:	79a2                	ld	s3,40(sp)
    80005246:	6161                	addi	sp,sp,80
    80005248:	8082                	ret
  return -1;
    8000524a:	557d                	li	a0,-1
    8000524c:	bfcd                	j	8000523e <filestat+0x66>

000000008000524e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000524e:	7179                	addi	sp,sp,-48
    80005250:	f406                	sd	ra,40(sp)
    80005252:	f022                	sd	s0,32(sp)
    80005254:	e84a                	sd	s2,16(sp)
    80005256:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80005258:	00854783          	lbu	a5,8(a0)
    8000525c:	cbc5                	beqz	a5,8000530c <fileread+0xbe>
    8000525e:	ec26                	sd	s1,24(sp)
    80005260:	e44e                	sd	s3,8(sp)
    80005262:	84aa                	mv	s1,a0
    80005264:	89ae                	mv	s3,a1
    80005266:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80005268:	411c                	lw	a5,0(a0)
    8000526a:	4705                	li	a4,1
    8000526c:	04e78963          	beq	a5,a4,800052be <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005270:	470d                	li	a4,3
    80005272:	04e78f63          	beq	a5,a4,800052d0 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80005276:	4709                	li	a4,2
    80005278:	08e79263          	bne	a5,a4,800052fc <fileread+0xae>
    ilock(f->ip);
    8000527c:	6d08                	ld	a0,24(a0)
    8000527e:	fffff097          	auipc	ra,0xfffff
    80005282:	fc2080e7          	jalr	-62(ra) # 80004240 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80005286:	874a                	mv	a4,s2
    80005288:	5094                	lw	a3,32(s1)
    8000528a:	864e                	mv	a2,s3
    8000528c:	4585                	li	a1,1
    8000528e:	6c88                	ld	a0,24(s1)
    80005290:	fffff097          	auipc	ra,0xfffff
    80005294:	26c080e7          	jalr	620(ra) # 800044fc <readi>
    80005298:	892a                	mv	s2,a0
    8000529a:	00a05563          	blez	a0,800052a4 <fileread+0x56>
      f->off += r;
    8000529e:	509c                	lw	a5,32(s1)
    800052a0:	9fa9                	addw	a5,a5,a0
    800052a2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800052a4:	6c88                	ld	a0,24(s1)
    800052a6:	fffff097          	auipc	ra,0xfffff
    800052aa:	060080e7          	jalr	96(ra) # 80004306 <iunlock>
    800052ae:	64e2                	ld	s1,24(sp)
    800052b0:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800052b2:	854a                	mv	a0,s2
    800052b4:	70a2                	ld	ra,40(sp)
    800052b6:	7402                	ld	s0,32(sp)
    800052b8:	6942                	ld	s2,16(sp)
    800052ba:	6145                	addi	sp,sp,48
    800052bc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800052be:	6908                	ld	a0,16(a0)
    800052c0:	00000097          	auipc	ra,0x0
    800052c4:	41a080e7          	jalr	1050(ra) # 800056da <piperead>
    800052c8:	892a                	mv	s2,a0
    800052ca:	64e2                	ld	s1,24(sp)
    800052cc:	69a2                	ld	s3,8(sp)
    800052ce:	b7d5                	j	800052b2 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800052d0:	02451783          	lh	a5,36(a0)
    800052d4:	03079693          	slli	a3,a5,0x30
    800052d8:	92c1                	srli	a3,a3,0x30
    800052da:	4725                	li	a4,9
    800052dc:	02d76a63          	bltu	a4,a3,80005310 <fileread+0xc2>
    800052e0:	0792                	slli	a5,a5,0x4
    800052e2:	00069717          	auipc	a4,0x69
    800052e6:	50670713          	addi	a4,a4,1286 # 8006e7e8 <devsw>
    800052ea:	97ba                	add	a5,a5,a4
    800052ec:	639c                	ld	a5,0(a5)
    800052ee:	c78d                	beqz	a5,80005318 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    800052f0:	4505                	li	a0,1
    800052f2:	9782                	jalr	a5
    800052f4:	892a                	mv	s2,a0
    800052f6:	64e2                	ld	s1,24(sp)
    800052f8:	69a2                	ld	s3,8(sp)
    800052fa:	bf65                	j	800052b2 <fileread+0x64>
    panic("fileread");
    800052fc:	00005517          	auipc	a0,0x5
    80005300:	32450513          	addi	a0,a0,804 # 8000a620 <etext+0x620>
    80005304:	ffffb097          	auipc	ra,0xffffb
    80005308:	25c080e7          	jalr	604(ra) # 80000560 <panic>
    return -1;
    8000530c:	597d                	li	s2,-1
    8000530e:	b755                	j	800052b2 <fileread+0x64>
      return -1;
    80005310:	597d                	li	s2,-1
    80005312:	64e2                	ld	s1,24(sp)
    80005314:	69a2                	ld	s3,8(sp)
    80005316:	bf71                	j	800052b2 <fileread+0x64>
    80005318:	597d                	li	s2,-1
    8000531a:	64e2                	ld	s1,24(sp)
    8000531c:	69a2                	ld	s3,8(sp)
    8000531e:	bf51                	j	800052b2 <fileread+0x64>

0000000080005320 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80005320:	00954783          	lbu	a5,9(a0)
    80005324:	12078c63          	beqz	a5,8000545c <filewrite+0x13c>
{
    80005328:	711d                	addi	sp,sp,-96
    8000532a:	ec86                	sd	ra,88(sp)
    8000532c:	e8a2                	sd	s0,80(sp)
    8000532e:	e0ca                	sd	s2,64(sp)
    80005330:	f456                	sd	s5,40(sp)
    80005332:	f05a                	sd	s6,32(sp)
    80005334:	1080                	addi	s0,sp,96
    80005336:	892a                	mv	s2,a0
    80005338:	8b2e                	mv	s6,a1
    8000533a:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000533c:	411c                	lw	a5,0(a0)
    8000533e:	4705                	li	a4,1
    80005340:	02e78963          	beq	a5,a4,80005372 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005344:	470d                	li	a4,3
    80005346:	02e78c63          	beq	a5,a4,8000537e <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000534a:	4709                	li	a4,2
    8000534c:	0ee79a63          	bne	a5,a4,80005440 <filewrite+0x120>
    80005350:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005352:	0cc05563          	blez	a2,8000541c <filewrite+0xfc>
    80005356:	e4a6                	sd	s1,72(sp)
    80005358:	fc4e                	sd	s3,56(sp)
    8000535a:	ec5e                	sd	s7,24(sp)
    8000535c:	e862                	sd	s8,16(sp)
    8000535e:	e466                	sd	s9,8(sp)
    int i = 0;
    80005360:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80005362:	6b85                	lui	s7,0x1
    80005364:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005368:	6c85                	lui	s9,0x1
    8000536a:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000536e:	4c05                	li	s8,1
    80005370:	a849                	j	80005402 <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80005372:	6908                	ld	a0,16(a0)
    80005374:	00000097          	auipc	ra,0x0
    80005378:	24a080e7          	jalr	586(ra) # 800055be <pipewrite>
    8000537c:	a85d                	j	80005432 <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000537e:	02451783          	lh	a5,36(a0)
    80005382:	03079693          	slli	a3,a5,0x30
    80005386:	92c1                	srli	a3,a3,0x30
    80005388:	4725                	li	a4,9
    8000538a:	0cd76b63          	bltu	a4,a3,80005460 <filewrite+0x140>
    8000538e:	0792                	slli	a5,a5,0x4
    80005390:	00069717          	auipc	a4,0x69
    80005394:	45870713          	addi	a4,a4,1112 # 8006e7e8 <devsw>
    80005398:	97ba                	add	a5,a5,a4
    8000539a:	679c                	ld	a5,8(a5)
    8000539c:	c7e1                	beqz	a5,80005464 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    8000539e:	4505                	li	a0,1
    800053a0:	9782                	jalr	a5
    800053a2:	a841                	j	80005432 <filewrite+0x112>
      if(n1 > max)
    800053a4:	2981                	sext.w	s3,s3
      begin_op();
    800053a6:	00000097          	auipc	ra,0x0
    800053aa:	884080e7          	jalr	-1916(ra) # 80004c2a <begin_op>
      ilock(f->ip);
    800053ae:	01893503          	ld	a0,24(s2)
    800053b2:	fffff097          	auipc	ra,0xfffff
    800053b6:	e8e080e7          	jalr	-370(ra) # 80004240 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800053ba:	874e                	mv	a4,s3
    800053bc:	02092683          	lw	a3,32(s2)
    800053c0:	016a0633          	add	a2,s4,s6
    800053c4:	85e2                	mv	a1,s8
    800053c6:	01893503          	ld	a0,24(s2)
    800053ca:	fffff097          	auipc	ra,0xfffff
    800053ce:	238080e7          	jalr	568(ra) # 80004602 <writei>
    800053d2:	84aa                	mv	s1,a0
    800053d4:	00a05763          	blez	a0,800053e2 <filewrite+0xc2>
        f->off += r;
    800053d8:	02092783          	lw	a5,32(s2)
    800053dc:	9fa9                	addw	a5,a5,a0
    800053de:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800053e2:	01893503          	ld	a0,24(s2)
    800053e6:	fffff097          	auipc	ra,0xfffff
    800053ea:	f20080e7          	jalr	-224(ra) # 80004306 <iunlock>
      end_op();
    800053ee:	00000097          	auipc	ra,0x0
    800053f2:	8b6080e7          	jalr	-1866(ra) # 80004ca4 <end_op>

      if(r != n1){
    800053f6:	02999563          	bne	s3,s1,80005420 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    800053fa:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800053fe:	015a5963          	bge	s4,s5,80005410 <filewrite+0xf0>
      int n1 = n - i;
    80005402:	414a87bb          	subw	a5,s5,s4
    80005406:	89be                	mv	s3,a5
      if(n1 > max)
    80005408:	f8fbdee3          	bge	s7,a5,800053a4 <filewrite+0x84>
    8000540c:	89e6                	mv	s3,s9
    8000540e:	bf59                	j	800053a4 <filewrite+0x84>
    80005410:	64a6                	ld	s1,72(sp)
    80005412:	79e2                	ld	s3,56(sp)
    80005414:	6be2                	ld	s7,24(sp)
    80005416:	6c42                	ld	s8,16(sp)
    80005418:	6ca2                	ld	s9,8(sp)
    8000541a:	a801                	j	8000542a <filewrite+0x10a>
    int i = 0;
    8000541c:	4a01                	li	s4,0
    8000541e:	a031                	j	8000542a <filewrite+0x10a>
    80005420:	64a6                	ld	s1,72(sp)
    80005422:	79e2                	ld	s3,56(sp)
    80005424:	6be2                	ld	s7,24(sp)
    80005426:	6c42                	ld	s8,16(sp)
    80005428:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000542a:	034a9f63          	bne	s5,s4,80005468 <filewrite+0x148>
    8000542e:	8556                	mv	a0,s5
    80005430:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005432:	60e6                	ld	ra,88(sp)
    80005434:	6446                	ld	s0,80(sp)
    80005436:	6906                	ld	s2,64(sp)
    80005438:	7aa2                	ld	s5,40(sp)
    8000543a:	7b02                	ld	s6,32(sp)
    8000543c:	6125                	addi	sp,sp,96
    8000543e:	8082                	ret
    80005440:	e4a6                	sd	s1,72(sp)
    80005442:	fc4e                	sd	s3,56(sp)
    80005444:	f852                	sd	s4,48(sp)
    80005446:	ec5e                	sd	s7,24(sp)
    80005448:	e862                	sd	s8,16(sp)
    8000544a:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000544c:	00005517          	auipc	a0,0x5
    80005450:	1e450513          	addi	a0,a0,484 # 8000a630 <etext+0x630>
    80005454:	ffffb097          	auipc	ra,0xffffb
    80005458:	10c080e7          	jalr	268(ra) # 80000560 <panic>
    return -1;
    8000545c:	557d                	li	a0,-1
}
    8000545e:	8082                	ret
      return -1;
    80005460:	557d                	li	a0,-1
    80005462:	bfc1                	j	80005432 <filewrite+0x112>
    80005464:	557d                	li	a0,-1
    80005466:	b7f1                	j	80005432 <filewrite+0x112>
    ret = (i == n ? n : -1);
    80005468:	557d                	li	a0,-1
    8000546a:	7a42                	ld	s4,48(sp)
    8000546c:	b7d9                	j	80005432 <filewrite+0x112>

000000008000546e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000546e:	7179                	addi	sp,sp,-48
    80005470:	f406                	sd	ra,40(sp)
    80005472:	f022                	sd	s0,32(sp)
    80005474:	ec26                	sd	s1,24(sp)
    80005476:	e052                	sd	s4,0(sp)
    80005478:	1800                	addi	s0,sp,48
    8000547a:	84aa                	mv	s1,a0
    8000547c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000547e:	0005b023          	sd	zero,0(a1)
    80005482:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005486:	00000097          	auipc	ra,0x0
    8000548a:	bb8080e7          	jalr	-1096(ra) # 8000503e <filealloc>
    8000548e:	e088                	sd	a0,0(s1)
    80005490:	cd49                	beqz	a0,8000552a <pipealloc+0xbc>
    80005492:	00000097          	auipc	ra,0x0
    80005496:	bac080e7          	jalr	-1108(ra) # 8000503e <filealloc>
    8000549a:	00aa3023          	sd	a0,0(s4)
    8000549e:	c141                	beqz	a0,8000551e <pipealloc+0xb0>
    800054a0:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800054a2:	ffffb097          	auipc	ra,0xffffb
    800054a6:	762080e7          	jalr	1890(ra) # 80000c04 <kalloc>
    800054aa:	892a                	mv	s2,a0
    800054ac:	c13d                	beqz	a0,80005512 <pipealloc+0xa4>
    800054ae:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800054b0:	4985                	li	s3,1
    800054b2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800054b6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800054ba:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800054be:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800054c2:	00005597          	auipc	a1,0x5
    800054c6:	17e58593          	addi	a1,a1,382 # 8000a640 <etext+0x640>
    800054ca:	ffffb097          	auipc	ra,0xffffb
    800054ce:	7b8080e7          	jalr	1976(ra) # 80000c82 <initlock>
  (*f0)->type = FD_PIPE;
    800054d2:	609c                	ld	a5,0(s1)
    800054d4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800054d8:	609c                	ld	a5,0(s1)
    800054da:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800054de:	609c                	ld	a5,0(s1)
    800054e0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800054e4:	609c                	ld	a5,0(s1)
    800054e6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800054ea:	000a3783          	ld	a5,0(s4)
    800054ee:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800054f2:	000a3783          	ld	a5,0(s4)
    800054f6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800054fa:	000a3783          	ld	a5,0(s4)
    800054fe:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80005502:	000a3783          	ld	a5,0(s4)
    80005506:	0127b823          	sd	s2,16(a5)
  return 0;
    8000550a:	4501                	li	a0,0
    8000550c:	6942                	ld	s2,16(sp)
    8000550e:	69a2                	ld	s3,8(sp)
    80005510:	a03d                	j	8000553e <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005512:	6088                	ld	a0,0(s1)
    80005514:	c119                	beqz	a0,8000551a <pipealloc+0xac>
    80005516:	6942                	ld	s2,16(sp)
    80005518:	a029                	j	80005522 <pipealloc+0xb4>
    8000551a:	6942                	ld	s2,16(sp)
    8000551c:	a039                	j	8000552a <pipealloc+0xbc>
    8000551e:	6088                	ld	a0,0(s1)
    80005520:	c50d                	beqz	a0,8000554a <pipealloc+0xdc>
    fileclose(*f0);
    80005522:	00000097          	auipc	ra,0x0
    80005526:	bd8080e7          	jalr	-1064(ra) # 800050fa <fileclose>
  if(*f1)
    8000552a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000552e:	557d                	li	a0,-1
  if(*f1)
    80005530:	c799                	beqz	a5,8000553e <pipealloc+0xd0>
    fileclose(*f1);
    80005532:	853e                	mv	a0,a5
    80005534:	00000097          	auipc	ra,0x0
    80005538:	bc6080e7          	jalr	-1082(ra) # 800050fa <fileclose>
  return -1;
    8000553c:	557d                	li	a0,-1
}
    8000553e:	70a2                	ld	ra,40(sp)
    80005540:	7402                	ld	s0,32(sp)
    80005542:	64e2                	ld	s1,24(sp)
    80005544:	6a02                	ld	s4,0(sp)
    80005546:	6145                	addi	sp,sp,48
    80005548:	8082                	ret
  return -1;
    8000554a:	557d                	li	a0,-1
    8000554c:	bfcd                	j	8000553e <pipealloc+0xd0>

000000008000554e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000554e:	1101                	addi	sp,sp,-32
    80005550:	ec06                	sd	ra,24(sp)
    80005552:	e822                	sd	s0,16(sp)
    80005554:	e426                	sd	s1,8(sp)
    80005556:	e04a                	sd	s2,0(sp)
    80005558:	1000                	addi	s0,sp,32
    8000555a:	84aa                	mv	s1,a0
    8000555c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000555e:	ffffb097          	auipc	ra,0xffffb
    80005562:	7b8080e7          	jalr	1976(ra) # 80000d16 <acquire>
  if(writable){
    80005566:	02090d63          	beqz	s2,800055a0 <pipeclose+0x52>
    pi->writeopen = 0;
    8000556a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000556e:	21848513          	addi	a0,s1,536
    80005572:	ffffd097          	auipc	ra,0xffffd
    80005576:	1fa080e7          	jalr	506(ra) # 8000276c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000557a:	2204b783          	ld	a5,544(s1)
    8000557e:	eb95                	bnez	a5,800055b2 <pipeclose+0x64>
    release(&pi->lock);
    80005580:	8526                	mv	a0,s1
    80005582:	ffffc097          	auipc	ra,0xffffc
    80005586:	844080e7          	jalr	-1980(ra) # 80000dc6 <release>
    kfree((char*)pi);
    8000558a:	8526                	mv	a0,s1
    8000558c:	ffffb097          	auipc	ra,0xffffb
    80005590:	510080e7          	jalr	1296(ra) # 80000a9c <kfree>
  } else
    release(&pi->lock);
}
    80005594:	60e2                	ld	ra,24(sp)
    80005596:	6442                	ld	s0,16(sp)
    80005598:	64a2                	ld	s1,8(sp)
    8000559a:	6902                	ld	s2,0(sp)
    8000559c:	6105                	addi	sp,sp,32
    8000559e:	8082                	ret
    pi->readopen = 0;
    800055a0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800055a4:	21c48513          	addi	a0,s1,540
    800055a8:	ffffd097          	auipc	ra,0xffffd
    800055ac:	1c4080e7          	jalr	452(ra) # 8000276c <wakeup>
    800055b0:	b7e9                	j	8000557a <pipeclose+0x2c>
    release(&pi->lock);
    800055b2:	8526                	mv	a0,s1
    800055b4:	ffffc097          	auipc	ra,0xffffc
    800055b8:	812080e7          	jalr	-2030(ra) # 80000dc6 <release>
}
    800055bc:	bfe1                	j	80005594 <pipeclose+0x46>

00000000800055be <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800055be:	7159                	addi	sp,sp,-112
    800055c0:	f486                	sd	ra,104(sp)
    800055c2:	f0a2                	sd	s0,96(sp)
    800055c4:	eca6                	sd	s1,88(sp)
    800055c6:	e8ca                	sd	s2,80(sp)
    800055c8:	e4ce                	sd	s3,72(sp)
    800055ca:	e0d2                	sd	s4,64(sp)
    800055cc:	fc56                	sd	s5,56(sp)
    800055ce:	1880                	addi	s0,sp,112
    800055d0:	84aa                	mv	s1,a0
    800055d2:	8aae                	mv	s5,a1
    800055d4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800055d6:	ffffd097          	auipc	ra,0xffffd
    800055da:	884080e7          	jalr	-1916(ra) # 80001e5a <myproc>
    800055de:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800055e0:	8526                	mv	a0,s1
    800055e2:	ffffb097          	auipc	ra,0xffffb
    800055e6:	734080e7          	jalr	1844(ra) # 80000d16 <acquire>
  while(i < n){
    800055ea:	0f405063          	blez	s4,800056ca <pipewrite+0x10c>
    800055ee:	f85a                	sd	s6,48(sp)
    800055f0:	f45e                	sd	s7,40(sp)
    800055f2:	f062                	sd	s8,32(sp)
    800055f4:	ec66                	sd	s9,24(sp)
    800055f6:	e86a                	sd	s10,16(sp)
  int i = 0;
    800055f8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800055fa:	f9f40c13          	addi	s8,s0,-97
    800055fe:	4b85                	li	s7,1
    80005600:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80005602:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005606:	21c48c93          	addi	s9,s1,540
    8000560a:	a099                	j	80005650 <pipewrite+0x92>
      release(&pi->lock);
    8000560c:	8526                	mv	a0,s1
    8000560e:	ffffb097          	auipc	ra,0xffffb
    80005612:	7b8080e7          	jalr	1976(ra) # 80000dc6 <release>
      return -1;
    80005616:	597d                	li	s2,-1
    80005618:	7b42                	ld	s6,48(sp)
    8000561a:	7ba2                	ld	s7,40(sp)
    8000561c:	7c02                	ld	s8,32(sp)
    8000561e:	6ce2                	ld	s9,24(sp)
    80005620:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005622:	854a                	mv	a0,s2
    80005624:	70a6                	ld	ra,104(sp)
    80005626:	7406                	ld	s0,96(sp)
    80005628:	64e6                	ld	s1,88(sp)
    8000562a:	6946                	ld	s2,80(sp)
    8000562c:	69a6                	ld	s3,72(sp)
    8000562e:	6a06                	ld	s4,64(sp)
    80005630:	7ae2                	ld	s5,56(sp)
    80005632:	6165                	addi	sp,sp,112
    80005634:	8082                	ret
      wakeup(&pi->nread);
    80005636:	856a                	mv	a0,s10
    80005638:	ffffd097          	auipc	ra,0xffffd
    8000563c:	134080e7          	jalr	308(ra) # 8000276c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005640:	85a6                	mv	a1,s1
    80005642:	8566                	mv	a0,s9
    80005644:	ffffd097          	auipc	ra,0xffffd
    80005648:	0c4080e7          	jalr	196(ra) # 80002708 <sleep>
  while(i < n){
    8000564c:	05495e63          	bge	s2,s4,800056a8 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    80005650:	2204a783          	lw	a5,544(s1)
    80005654:	dfc5                	beqz	a5,8000560c <pipewrite+0x4e>
    80005656:	854e                	mv	a0,s3
    80005658:	ffffd097          	auipc	ra,0xffffd
    8000565c:	4d6080e7          	jalr	1238(ra) # 80002b2e <killed>
    80005660:	f555                	bnez	a0,8000560c <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005662:	2184a783          	lw	a5,536(s1)
    80005666:	21c4a703          	lw	a4,540(s1)
    8000566a:	2007879b          	addiw	a5,a5,512
    8000566e:	fcf704e3          	beq	a4,a5,80005636 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005672:	86de                	mv	a3,s7
    80005674:	01590633          	add	a2,s2,s5
    80005678:	85e2                	mv	a1,s8
    8000567a:	0509b503          	ld	a0,80(s3)
    8000567e:	ffffc097          	auipc	ra,0xffffc
    80005682:	510080e7          	jalr	1296(ra) # 80001b8e <copyin>
    80005686:	05650463          	beq	a0,s6,800056ce <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000568a:	21c4a783          	lw	a5,540(s1)
    8000568e:	0017871b          	addiw	a4,a5,1
    80005692:	20e4ae23          	sw	a4,540(s1)
    80005696:	1ff7f793          	andi	a5,a5,511
    8000569a:	97a6                	add	a5,a5,s1
    8000569c:	f9f44703          	lbu	a4,-97(s0)
    800056a0:	00e78c23          	sb	a4,24(a5)
      i++;
    800056a4:	2905                	addiw	s2,s2,1
    800056a6:	b75d                	j	8000564c <pipewrite+0x8e>
    800056a8:	7b42                	ld	s6,48(sp)
    800056aa:	7ba2                	ld	s7,40(sp)
    800056ac:	7c02                	ld	s8,32(sp)
    800056ae:	6ce2                	ld	s9,24(sp)
    800056b0:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800056b2:	21848513          	addi	a0,s1,536
    800056b6:	ffffd097          	auipc	ra,0xffffd
    800056ba:	0b6080e7          	jalr	182(ra) # 8000276c <wakeup>
  release(&pi->lock);
    800056be:	8526                	mv	a0,s1
    800056c0:	ffffb097          	auipc	ra,0xffffb
    800056c4:	706080e7          	jalr	1798(ra) # 80000dc6 <release>
  return i;
    800056c8:	bfa9                	j	80005622 <pipewrite+0x64>
  int i = 0;
    800056ca:	4901                	li	s2,0
    800056cc:	b7dd                	j	800056b2 <pipewrite+0xf4>
    800056ce:	7b42                	ld	s6,48(sp)
    800056d0:	7ba2                	ld	s7,40(sp)
    800056d2:	7c02                	ld	s8,32(sp)
    800056d4:	6ce2                	ld	s9,24(sp)
    800056d6:	6d42                	ld	s10,16(sp)
    800056d8:	bfe9                	j	800056b2 <pipewrite+0xf4>

00000000800056da <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800056da:	711d                	addi	sp,sp,-96
    800056dc:	ec86                	sd	ra,88(sp)
    800056de:	e8a2                	sd	s0,80(sp)
    800056e0:	e4a6                	sd	s1,72(sp)
    800056e2:	e0ca                	sd	s2,64(sp)
    800056e4:	fc4e                	sd	s3,56(sp)
    800056e6:	f852                	sd	s4,48(sp)
    800056e8:	f456                	sd	s5,40(sp)
    800056ea:	1080                	addi	s0,sp,96
    800056ec:	84aa                	mv	s1,a0
    800056ee:	892e                	mv	s2,a1
    800056f0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800056f2:	ffffc097          	auipc	ra,0xffffc
    800056f6:	768080e7          	jalr	1896(ra) # 80001e5a <myproc>
    800056fa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800056fc:	8526                	mv	a0,s1
    800056fe:	ffffb097          	auipc	ra,0xffffb
    80005702:	618080e7          	jalr	1560(ra) # 80000d16 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005706:	2184a703          	lw	a4,536(s1)
    8000570a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000570e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005712:	02f71b63          	bne	a4,a5,80005748 <piperead+0x6e>
    80005716:	2244a783          	lw	a5,548(s1)
    8000571a:	c3b1                	beqz	a5,8000575e <piperead+0x84>
    if(killed(pr)){
    8000571c:	8552                	mv	a0,s4
    8000571e:	ffffd097          	auipc	ra,0xffffd
    80005722:	410080e7          	jalr	1040(ra) # 80002b2e <killed>
    80005726:	e50d                	bnez	a0,80005750 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005728:	85a6                	mv	a1,s1
    8000572a:	854e                	mv	a0,s3
    8000572c:	ffffd097          	auipc	ra,0xffffd
    80005730:	fdc080e7          	jalr	-36(ra) # 80002708 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005734:	2184a703          	lw	a4,536(s1)
    80005738:	21c4a783          	lw	a5,540(s1)
    8000573c:	fcf70de3          	beq	a4,a5,80005716 <piperead+0x3c>
    80005740:	f05a                	sd	s6,32(sp)
    80005742:	ec5e                	sd	s7,24(sp)
    80005744:	e862                	sd	s8,16(sp)
    80005746:	a839                	j	80005764 <piperead+0x8a>
    80005748:	f05a                	sd	s6,32(sp)
    8000574a:	ec5e                	sd	s7,24(sp)
    8000574c:	e862                	sd	s8,16(sp)
    8000574e:	a819                	j	80005764 <piperead+0x8a>
      release(&pi->lock);
    80005750:	8526                	mv	a0,s1
    80005752:	ffffb097          	auipc	ra,0xffffb
    80005756:	674080e7          	jalr	1652(ra) # 80000dc6 <release>
      return -1;
    8000575a:	59fd                	li	s3,-1
    8000575c:	a895                	j	800057d0 <piperead+0xf6>
    8000575e:	f05a                	sd	s6,32(sp)
    80005760:	ec5e                	sd	s7,24(sp)
    80005762:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005764:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005766:	faf40c13          	addi	s8,s0,-81
    8000576a:	4b85                	li	s7,1
    8000576c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000576e:	05505363          	blez	s5,800057b4 <piperead+0xda>
    if(pi->nread == pi->nwrite)
    80005772:	2184a783          	lw	a5,536(s1)
    80005776:	21c4a703          	lw	a4,540(s1)
    8000577a:	02f70d63          	beq	a4,a5,800057b4 <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000577e:	0017871b          	addiw	a4,a5,1
    80005782:	20e4ac23          	sw	a4,536(s1)
    80005786:	1ff7f793          	andi	a5,a5,511
    8000578a:	97a6                	add	a5,a5,s1
    8000578c:	0187c783          	lbu	a5,24(a5)
    80005790:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005794:	86de                	mv	a3,s7
    80005796:	8662                	mv	a2,s8
    80005798:	85ca                	mv	a1,s2
    8000579a:	050a3503          	ld	a0,80(s4)
    8000579e:	ffffc097          	auipc	ra,0xffffc
    800057a2:	364080e7          	jalr	868(ra) # 80001b02 <copyout>
    800057a6:	01650763          	beq	a0,s6,800057b4 <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800057aa:	2985                	addiw	s3,s3,1
    800057ac:	0905                	addi	s2,s2,1
    800057ae:	fd3a92e3          	bne	s5,s3,80005772 <piperead+0x98>
    800057b2:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800057b4:	21c48513          	addi	a0,s1,540
    800057b8:	ffffd097          	auipc	ra,0xffffd
    800057bc:	fb4080e7          	jalr	-76(ra) # 8000276c <wakeup>
  release(&pi->lock);
    800057c0:	8526                	mv	a0,s1
    800057c2:	ffffb097          	auipc	ra,0xffffb
    800057c6:	604080e7          	jalr	1540(ra) # 80000dc6 <release>
    800057ca:	7b02                	ld	s6,32(sp)
    800057cc:	6be2                	ld	s7,24(sp)
    800057ce:	6c42                	ld	s8,16(sp)
  return i;
}
    800057d0:	854e                	mv	a0,s3
    800057d2:	60e6                	ld	ra,88(sp)
    800057d4:	6446                	ld	s0,80(sp)
    800057d6:	64a6                	ld	s1,72(sp)
    800057d8:	6906                	ld	s2,64(sp)
    800057da:	79e2                	ld	s3,56(sp)
    800057dc:	7a42                	ld	s4,48(sp)
    800057de:	7aa2                	ld	s5,40(sp)
    800057e0:	6125                	addi	sp,sp,96
    800057e2:	8082                	ret

00000000800057e4 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800057e4:	1141                	addi	sp,sp,-16
    800057e6:	e406                	sd	ra,8(sp)
    800057e8:	e022                	sd	s0,0(sp)
    800057ea:	0800                	addi	s0,sp,16
    800057ec:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800057ee:	0035151b          	slliw	a0,a0,0x3
    800057f2:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800057f4:	8b89                	andi	a5,a5,2
    800057f6:	c399                	beqz	a5,800057fc <flags2perm+0x18>
      perm |= PTE_W;
    800057f8:	00456513          	ori	a0,a0,4
    return perm;
}
    800057fc:	60a2                	ld	ra,8(sp)
    800057fe:	6402                	ld	s0,0(sp)
    80005800:	0141                	addi	sp,sp,16
    80005802:	8082                	ret

0000000080005804 <exec>:

int
exec(char *path, char **argv)
{
    80005804:	de010113          	addi	sp,sp,-544
    80005808:	20113c23          	sd	ra,536(sp)
    8000580c:	20813823          	sd	s0,528(sp)
    80005810:	20913423          	sd	s1,520(sp)
    80005814:	21213023          	sd	s2,512(sp)
    80005818:	1400                	addi	s0,sp,544
    8000581a:	892a                	mv	s2,a0
    8000581c:	dea43823          	sd	a0,-528(s0)
    80005820:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005824:	ffffc097          	auipc	ra,0xffffc
    80005828:	636080e7          	jalr	1590(ra) # 80001e5a <myproc>
    8000582c:	84aa                	mv	s1,a0

  begin_op();
    8000582e:	fffff097          	auipc	ra,0xfffff
    80005832:	3fc080e7          	jalr	1020(ra) # 80004c2a <begin_op>

  if((ip = namei(path)) == 0){
    80005836:	854a                	mv	a0,s2
    80005838:	fffff097          	auipc	ra,0xfffff
    8000583c:	1ec080e7          	jalr	492(ra) # 80004a24 <namei>
    80005840:	c525                	beqz	a0,800058a8 <exec+0xa4>
    80005842:	fbd2                	sd	s4,496(sp)
    80005844:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005846:	fffff097          	auipc	ra,0xfffff
    8000584a:	9fa080e7          	jalr	-1542(ra) # 80004240 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000584e:	04000713          	li	a4,64
    80005852:	4681                	li	a3,0
    80005854:	e5040613          	addi	a2,s0,-432
    80005858:	4581                	li	a1,0
    8000585a:	8552                	mv	a0,s4
    8000585c:	fffff097          	auipc	ra,0xfffff
    80005860:	ca0080e7          	jalr	-864(ra) # 800044fc <readi>
    80005864:	04000793          	li	a5,64
    80005868:	00f51a63          	bne	a0,a5,8000587c <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000586c:	e5042703          	lw	a4,-432(s0)
    80005870:	464c47b7          	lui	a5,0x464c4
    80005874:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005878:	02f70e63          	beq	a4,a5,800058b4 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000587c:	8552                	mv	a0,s4
    8000587e:	fffff097          	auipc	ra,0xfffff
    80005882:	c28080e7          	jalr	-984(ra) # 800044a6 <iunlockput>
    end_op();
    80005886:	fffff097          	auipc	ra,0xfffff
    8000588a:	41e080e7          	jalr	1054(ra) # 80004ca4 <end_op>
  }
  return -1;
    8000588e:	557d                	li	a0,-1
    80005890:	7a5e                	ld	s4,496(sp)
}
    80005892:	21813083          	ld	ra,536(sp)
    80005896:	21013403          	ld	s0,528(sp)
    8000589a:	20813483          	ld	s1,520(sp)
    8000589e:	20013903          	ld	s2,512(sp)
    800058a2:	22010113          	addi	sp,sp,544
    800058a6:	8082                	ret
    end_op();
    800058a8:	fffff097          	auipc	ra,0xfffff
    800058ac:	3fc080e7          	jalr	1020(ra) # 80004ca4 <end_op>
    return -1;
    800058b0:	557d                	li	a0,-1
    800058b2:	b7c5                	j	80005892 <exec+0x8e>
    800058b4:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800058b6:	8526                	mv	a0,s1
    800058b8:	ffffc097          	auipc	ra,0xffffc
    800058bc:	666080e7          	jalr	1638(ra) # 80001f1e <proc_pagetable>
    800058c0:	8b2a                	mv	s6,a0
    800058c2:	2c050163          	beqz	a0,80005b84 <exec+0x380>
    800058c6:	ffce                	sd	s3,504(sp)
    800058c8:	f7d6                	sd	s5,488(sp)
    800058ca:	efde                	sd	s7,472(sp)
    800058cc:	ebe2                	sd	s8,464(sp)
    800058ce:	e7e6                	sd	s9,456(sp)
    800058d0:	e3ea                	sd	s10,448(sp)
    800058d2:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800058d4:	e7042683          	lw	a3,-400(s0)
    800058d8:	e8845783          	lhu	a5,-376(s0)
    800058dc:	10078363          	beqz	a5,800059e2 <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800058e0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800058e2:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800058e4:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800058e8:	6c85                	lui	s9,0x1
    800058ea:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800058ee:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800058f2:	6a85                	lui	s5,0x1
    800058f4:	a0b5                	j	80005960 <exec+0x15c>
      panic("loadseg: address should exist");
    800058f6:	00005517          	auipc	a0,0x5
    800058fa:	d5250513          	addi	a0,a0,-686 # 8000a648 <etext+0x648>
    800058fe:	ffffb097          	auipc	ra,0xffffb
    80005902:	c62080e7          	jalr	-926(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005906:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005908:	874a                	mv	a4,s2
    8000590a:	009c06bb          	addw	a3,s8,s1
    8000590e:	4581                	li	a1,0
    80005910:	8552                	mv	a0,s4
    80005912:	fffff097          	auipc	ra,0xfffff
    80005916:	bea080e7          	jalr	-1046(ra) # 800044fc <readi>
    8000591a:	26a91963          	bne	s2,a0,80005b8c <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000591e:	009a84bb          	addw	s1,s5,s1
    80005922:	0334f463          	bgeu	s1,s3,8000594a <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    80005926:	02049593          	slli	a1,s1,0x20
    8000592a:	9181                	srli	a1,a1,0x20
    8000592c:	95de                	add	a1,a1,s7
    8000592e:	855a                	mv	a0,s6
    80005930:	ffffc097          	auipc	ra,0xffffc
    80005934:	898080e7          	jalr	-1896(ra) # 800011c8 <walkaddr>
    80005938:	862a                	mv	a2,a0
    if(pa == 0)
    8000593a:	dd55                	beqz	a0,800058f6 <exec+0xf2>
    if(sz - i < PGSIZE)
    8000593c:	409987bb          	subw	a5,s3,s1
    80005940:	893e                	mv	s2,a5
    80005942:	fcfcf2e3          	bgeu	s9,a5,80005906 <exec+0x102>
    80005946:	8956                	mv	s2,s5
    80005948:	bf7d                	j	80005906 <exec+0x102>
    sz = sz1;
    8000594a:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000594e:	2d05                	addiw	s10,s10,1
    80005950:	e0843783          	ld	a5,-504(s0)
    80005954:	0387869b          	addiw	a3,a5,56
    80005958:	e8845783          	lhu	a5,-376(s0)
    8000595c:	08fd5463          	bge	s10,a5,800059e4 <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005960:	e0d43423          	sd	a3,-504(s0)
    80005964:	876e                	mv	a4,s11
    80005966:	e1840613          	addi	a2,s0,-488
    8000596a:	4581                	li	a1,0
    8000596c:	8552                	mv	a0,s4
    8000596e:	fffff097          	auipc	ra,0xfffff
    80005972:	b8e080e7          	jalr	-1138(ra) # 800044fc <readi>
    80005976:	21b51963          	bne	a0,s11,80005b88 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    8000597a:	e1842783          	lw	a5,-488(s0)
    8000597e:	4705                	li	a4,1
    80005980:	fce797e3          	bne	a5,a4,8000594e <exec+0x14a>
    if(ph.memsz < ph.filesz)
    80005984:	e4043483          	ld	s1,-448(s0)
    80005988:	e3843783          	ld	a5,-456(s0)
    8000598c:	22f4e063          	bltu	s1,a5,80005bac <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005990:	e2843783          	ld	a5,-472(s0)
    80005994:	94be                	add	s1,s1,a5
    80005996:	20f4ee63          	bltu	s1,a5,80005bb2 <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    8000599a:	de843703          	ld	a4,-536(s0)
    8000599e:	8ff9                	and	a5,a5,a4
    800059a0:	20079c63          	bnez	a5,80005bb8 <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800059a4:	e1c42503          	lw	a0,-484(s0)
    800059a8:	00000097          	auipc	ra,0x0
    800059ac:	e3c080e7          	jalr	-452(ra) # 800057e4 <flags2perm>
    800059b0:	86aa                	mv	a3,a0
    800059b2:	8626                	mv	a2,s1
    800059b4:	85ca                	mv	a1,s2
    800059b6:	855a                	mv	a0,s6
    800059b8:	ffffc097          	auipc	ra,0xffffc
    800059bc:	be8080e7          	jalr	-1048(ra) # 800015a0 <uvmalloc>
    800059c0:	dea43c23          	sd	a0,-520(s0)
    800059c4:	1e050d63          	beqz	a0,80005bbe <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800059c8:	e2843b83          	ld	s7,-472(s0)
    800059cc:	e2042c03          	lw	s8,-480(s0)
    800059d0:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800059d4:	00098463          	beqz	s3,800059dc <exec+0x1d8>
    800059d8:	4481                	li	s1,0
    800059da:	b7b1                	j	80005926 <exec+0x122>
    sz = sz1;
    800059dc:	df843903          	ld	s2,-520(s0)
    800059e0:	b7bd                	j	8000594e <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800059e2:	4901                	li	s2,0
  iunlockput(ip);
    800059e4:	8552                	mv	a0,s4
    800059e6:	fffff097          	auipc	ra,0xfffff
    800059ea:	ac0080e7          	jalr	-1344(ra) # 800044a6 <iunlockput>
  end_op();
    800059ee:	fffff097          	auipc	ra,0xfffff
    800059f2:	2b6080e7          	jalr	694(ra) # 80004ca4 <end_op>
  p = myproc();
    800059f6:	ffffc097          	auipc	ra,0xffffc
    800059fa:	464080e7          	jalr	1124(ra) # 80001e5a <myproc>
    800059fe:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005a00:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005a04:	6985                	lui	s3,0x1
    80005a06:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005a08:	99ca                	add	s3,s3,s2
    80005a0a:	77fd                	lui	a5,0xfffff
    80005a0c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005a10:	4691                	li	a3,4
    80005a12:	6609                	lui	a2,0x2
    80005a14:	964e                	add	a2,a2,s3
    80005a16:	85ce                	mv	a1,s3
    80005a18:	855a                	mv	a0,s6
    80005a1a:	ffffc097          	auipc	ra,0xffffc
    80005a1e:	b86080e7          	jalr	-1146(ra) # 800015a0 <uvmalloc>
    80005a22:	8a2a                	mv	s4,a0
    80005a24:	e115                	bnez	a0,80005a48 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    80005a26:	85ce                	mv	a1,s3
    80005a28:	855a                	mv	a0,s6
    80005a2a:	ffffc097          	auipc	ra,0xffffc
    80005a2e:	590080e7          	jalr	1424(ra) # 80001fba <proc_freepagetable>
  return -1;
    80005a32:	557d                	li	a0,-1
    80005a34:	79fe                	ld	s3,504(sp)
    80005a36:	7a5e                	ld	s4,496(sp)
    80005a38:	7abe                	ld	s5,488(sp)
    80005a3a:	7b1e                	ld	s6,480(sp)
    80005a3c:	6bfe                	ld	s7,472(sp)
    80005a3e:	6c5e                	ld	s8,464(sp)
    80005a40:	6cbe                	ld	s9,456(sp)
    80005a42:	6d1e                	ld	s10,448(sp)
    80005a44:	7dfa                	ld	s11,440(sp)
    80005a46:	b5b1                	j	80005892 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005a48:	75f9                	lui	a1,0xffffe
    80005a4a:	95aa                	add	a1,a1,a0
    80005a4c:	855a                	mv	a0,s6
    80005a4e:	ffffc097          	auipc	ra,0xffffc
    80005a52:	082080e7          	jalr	130(ra) # 80001ad0 <uvmclear>
  stackbase = sp - PGSIZE;
    80005a56:	7bfd                	lui	s7,0xfffff
    80005a58:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80005a5a:	e0043783          	ld	a5,-512(s0)
    80005a5e:	6388                	ld	a0,0(a5)
  sp = sz;
    80005a60:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80005a62:	4481                	li	s1,0
    ustack[argc] = sp;
    80005a64:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005a68:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005a6c:	c135                	beqz	a0,80005ad0 <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    80005a6e:	ffffb097          	auipc	ra,0xffffb
    80005a72:	52c080e7          	jalr	1324(ra) # 80000f9a <strlen>
    80005a76:	0015079b          	addiw	a5,a0,1
    80005a7a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005a7e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005a82:	15796163          	bltu	s2,s7,80005bc4 <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005a86:	e0043d83          	ld	s11,-512(s0)
    80005a8a:	000db983          	ld	s3,0(s11)
    80005a8e:	854e                	mv	a0,s3
    80005a90:	ffffb097          	auipc	ra,0xffffb
    80005a94:	50a080e7          	jalr	1290(ra) # 80000f9a <strlen>
    80005a98:	0015069b          	addiw	a3,a0,1
    80005a9c:	864e                	mv	a2,s3
    80005a9e:	85ca                	mv	a1,s2
    80005aa0:	855a                	mv	a0,s6
    80005aa2:	ffffc097          	auipc	ra,0xffffc
    80005aa6:	060080e7          	jalr	96(ra) # 80001b02 <copyout>
    80005aaa:	10054f63          	bltz	a0,80005bc8 <exec+0x3c4>
    ustack[argc] = sp;
    80005aae:	00349793          	slli	a5,s1,0x3
    80005ab2:	97e6                	add	a5,a5,s9
    80005ab4:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ff8e5f4>
  for(argc = 0; argv[argc]; argc++) {
    80005ab8:	0485                	addi	s1,s1,1
    80005aba:	008d8793          	addi	a5,s11,8
    80005abe:	e0f43023          	sd	a5,-512(s0)
    80005ac2:	008db503          	ld	a0,8(s11)
    80005ac6:	c509                	beqz	a0,80005ad0 <exec+0x2cc>
    if(argc >= MAXARG)
    80005ac8:	fb8493e3          	bne	s1,s8,80005a6e <exec+0x26a>
  sz = sz1;
    80005acc:	89d2                	mv	s3,s4
    80005ace:	bfa1                	j	80005a26 <exec+0x222>
  ustack[argc] = 0;
    80005ad0:	00349793          	slli	a5,s1,0x3
    80005ad4:	f9078793          	addi	a5,a5,-112
    80005ad8:	97a2                	add	a5,a5,s0
    80005ada:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005ade:	00148693          	addi	a3,s1,1
    80005ae2:	068e                	slli	a3,a3,0x3
    80005ae4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005ae8:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005aec:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005aee:	f3796ce3          	bltu	s2,s7,80005a26 <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005af2:	e9040613          	addi	a2,s0,-368
    80005af6:	85ca                	mv	a1,s2
    80005af8:	855a                	mv	a0,s6
    80005afa:	ffffc097          	auipc	ra,0xffffc
    80005afe:	008080e7          	jalr	8(ra) # 80001b02 <copyout>
    80005b02:	f20542e3          	bltz	a0,80005a26 <exec+0x222>
  p->trapframe->a1 = sp;
    80005b06:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005b0a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005b0e:	df043783          	ld	a5,-528(s0)
    80005b12:	0007c703          	lbu	a4,0(a5)
    80005b16:	cf11                	beqz	a4,80005b32 <exec+0x32e>
    80005b18:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005b1a:	02f00693          	li	a3,47
    80005b1e:	a029                	j	80005b28 <exec+0x324>
  for(last=s=path; *s; s++)
    80005b20:	0785                	addi	a5,a5,1
    80005b22:	fff7c703          	lbu	a4,-1(a5)
    80005b26:	c711                	beqz	a4,80005b32 <exec+0x32e>
    if(*s == '/')
    80005b28:	fed71ce3          	bne	a4,a3,80005b20 <exec+0x31c>
      last = s+1;
    80005b2c:	def43823          	sd	a5,-528(s0)
    80005b30:	bfc5                	j	80005b20 <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005b32:	4641                	li	a2,16
    80005b34:	df043583          	ld	a1,-528(s0)
    80005b38:	158a8513          	addi	a0,s5,344
    80005b3c:	ffffb097          	auipc	ra,0xffffb
    80005b40:	428080e7          	jalr	1064(ra) # 80000f64 <safestrcpy>
  oldpagetable = p->pagetable;
    80005b44:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005b48:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005b4c:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005b50:	058ab783          	ld	a5,88(s5)
    80005b54:	e6843703          	ld	a4,-408(s0)
    80005b58:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005b5a:	058ab783          	ld	a5,88(s5)
    80005b5e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005b62:	85ea                	mv	a1,s10
    80005b64:	ffffc097          	auipc	ra,0xffffc
    80005b68:	456080e7          	jalr	1110(ra) # 80001fba <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005b6c:	0004851b          	sext.w	a0,s1
    80005b70:	79fe                	ld	s3,504(sp)
    80005b72:	7a5e                	ld	s4,496(sp)
    80005b74:	7abe                	ld	s5,488(sp)
    80005b76:	7b1e                	ld	s6,480(sp)
    80005b78:	6bfe                	ld	s7,472(sp)
    80005b7a:	6c5e                	ld	s8,464(sp)
    80005b7c:	6cbe                	ld	s9,456(sp)
    80005b7e:	6d1e                	ld	s10,448(sp)
    80005b80:	7dfa                	ld	s11,440(sp)
    80005b82:	bb01                	j	80005892 <exec+0x8e>
    80005b84:	7b1e                	ld	s6,480(sp)
    80005b86:	b9dd                	j	8000587c <exec+0x78>
    80005b88:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005b8c:	df843583          	ld	a1,-520(s0)
    80005b90:	855a                	mv	a0,s6
    80005b92:	ffffc097          	auipc	ra,0xffffc
    80005b96:	428080e7          	jalr	1064(ra) # 80001fba <proc_freepagetable>
  if(ip){
    80005b9a:	79fe                	ld	s3,504(sp)
    80005b9c:	7abe                	ld	s5,488(sp)
    80005b9e:	7b1e                	ld	s6,480(sp)
    80005ba0:	6bfe                	ld	s7,472(sp)
    80005ba2:	6c5e                	ld	s8,464(sp)
    80005ba4:	6cbe                	ld	s9,456(sp)
    80005ba6:	6d1e                	ld	s10,448(sp)
    80005ba8:	7dfa                	ld	s11,440(sp)
    80005baa:	b9c9                	j	8000587c <exec+0x78>
    80005bac:	df243c23          	sd	s2,-520(s0)
    80005bb0:	bff1                	j	80005b8c <exec+0x388>
    80005bb2:	df243c23          	sd	s2,-520(s0)
    80005bb6:	bfd9                	j	80005b8c <exec+0x388>
    80005bb8:	df243c23          	sd	s2,-520(s0)
    80005bbc:	bfc1                	j	80005b8c <exec+0x388>
    80005bbe:	df243c23          	sd	s2,-520(s0)
    80005bc2:	b7e9                	j	80005b8c <exec+0x388>
  sz = sz1;
    80005bc4:	89d2                	mv	s3,s4
    80005bc6:	b585                	j	80005a26 <exec+0x222>
    80005bc8:	89d2                	mv	s3,s4
    80005bca:	bdb1                	j	80005a26 <exec+0x222>

0000000080005bcc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005bcc:	7179                	addi	sp,sp,-48
    80005bce:	f406                	sd	ra,40(sp)
    80005bd0:	f022                	sd	s0,32(sp)
    80005bd2:	ec26                	sd	s1,24(sp)
    80005bd4:	e84a                	sd	s2,16(sp)
    80005bd6:	1800                	addi	s0,sp,48
    80005bd8:	892e                	mv	s2,a1
    80005bda:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005bdc:	fdc40593          	addi	a1,s0,-36
    80005be0:	ffffe097          	auipc	ra,0xffffe
    80005be4:	894080e7          	jalr	-1900(ra) # 80003474 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005be8:	fdc42703          	lw	a4,-36(s0)
    80005bec:	47bd                	li	a5,15
    80005bee:	02e7eb63          	bltu	a5,a4,80005c24 <argfd+0x58>
    80005bf2:	ffffc097          	auipc	ra,0xffffc
    80005bf6:	268080e7          	jalr	616(ra) # 80001e5a <myproc>
    80005bfa:	fdc42703          	lw	a4,-36(s0)
    80005bfe:	01a70793          	addi	a5,a4,26
    80005c02:	078e                	slli	a5,a5,0x3
    80005c04:	953e                	add	a0,a0,a5
    80005c06:	611c                	ld	a5,0(a0)
    80005c08:	c385                	beqz	a5,80005c28 <argfd+0x5c>
    return -1;
  if(pfd)
    80005c0a:	00090463          	beqz	s2,80005c12 <argfd+0x46>
    *pfd = fd;
    80005c0e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005c12:	4501                	li	a0,0
  if(pf)
    80005c14:	c091                	beqz	s1,80005c18 <argfd+0x4c>
    *pf = f;
    80005c16:	e09c                	sd	a5,0(s1)
}
    80005c18:	70a2                	ld	ra,40(sp)
    80005c1a:	7402                	ld	s0,32(sp)
    80005c1c:	64e2                	ld	s1,24(sp)
    80005c1e:	6942                	ld	s2,16(sp)
    80005c20:	6145                	addi	sp,sp,48
    80005c22:	8082                	ret
    return -1;
    80005c24:	557d                	li	a0,-1
    80005c26:	bfcd                	j	80005c18 <argfd+0x4c>
    80005c28:	557d                	li	a0,-1
    80005c2a:	b7fd                	j	80005c18 <argfd+0x4c>

0000000080005c2c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005c2c:	1101                	addi	sp,sp,-32
    80005c2e:	ec06                	sd	ra,24(sp)
    80005c30:	e822                	sd	s0,16(sp)
    80005c32:	e426                	sd	s1,8(sp)
    80005c34:	1000                	addi	s0,sp,32
    80005c36:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005c38:	ffffc097          	auipc	ra,0xffffc
    80005c3c:	222080e7          	jalr	546(ra) # 80001e5a <myproc>
    80005c40:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005c42:	0d050793          	addi	a5,a0,208
    80005c46:	4501                	li	a0,0
    80005c48:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005c4a:	6398                	ld	a4,0(a5)
    80005c4c:	cb19                	beqz	a4,80005c62 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005c4e:	2505                	addiw	a0,a0,1
    80005c50:	07a1                	addi	a5,a5,8
    80005c52:	fed51ce3          	bne	a0,a3,80005c4a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005c56:	557d                	li	a0,-1
}
    80005c58:	60e2                	ld	ra,24(sp)
    80005c5a:	6442                	ld	s0,16(sp)
    80005c5c:	64a2                	ld	s1,8(sp)
    80005c5e:	6105                	addi	sp,sp,32
    80005c60:	8082                	ret
      p->ofile[fd] = f;
    80005c62:	01a50793          	addi	a5,a0,26
    80005c66:	078e                	slli	a5,a5,0x3
    80005c68:	963e                	add	a2,a2,a5
    80005c6a:	e204                	sd	s1,0(a2)
      return fd;
    80005c6c:	b7f5                	j	80005c58 <fdalloc+0x2c>

0000000080005c6e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005c6e:	715d                	addi	sp,sp,-80
    80005c70:	e486                	sd	ra,72(sp)
    80005c72:	e0a2                	sd	s0,64(sp)
    80005c74:	fc26                	sd	s1,56(sp)
    80005c76:	f84a                	sd	s2,48(sp)
    80005c78:	f44e                	sd	s3,40(sp)
    80005c7a:	ec56                	sd	s5,24(sp)
    80005c7c:	e85a                	sd	s6,16(sp)
    80005c7e:	0880                	addi	s0,sp,80
    80005c80:	8b2e                	mv	s6,a1
    80005c82:	89b2                	mv	s3,a2
    80005c84:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005c86:	fb040593          	addi	a1,s0,-80
    80005c8a:	fffff097          	auipc	ra,0xfffff
    80005c8e:	db8080e7          	jalr	-584(ra) # 80004a42 <nameiparent>
    80005c92:	84aa                	mv	s1,a0
    80005c94:	14050e63          	beqz	a0,80005df0 <create+0x182>
    return 0;

  ilock(dp);
    80005c98:	ffffe097          	auipc	ra,0xffffe
    80005c9c:	5a8080e7          	jalr	1448(ra) # 80004240 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005ca0:	4601                	li	a2,0
    80005ca2:	fb040593          	addi	a1,s0,-80
    80005ca6:	8526                	mv	a0,s1
    80005ca8:	fffff097          	auipc	ra,0xfffff
    80005cac:	a94080e7          	jalr	-1388(ra) # 8000473c <dirlookup>
    80005cb0:	8aaa                	mv	s5,a0
    80005cb2:	c539                	beqz	a0,80005d00 <create+0x92>
    iunlockput(dp);
    80005cb4:	8526                	mv	a0,s1
    80005cb6:	ffffe097          	auipc	ra,0xffffe
    80005cba:	7f0080e7          	jalr	2032(ra) # 800044a6 <iunlockput>
    ilock(ip);
    80005cbe:	8556                	mv	a0,s5
    80005cc0:	ffffe097          	auipc	ra,0xffffe
    80005cc4:	580080e7          	jalr	1408(ra) # 80004240 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005cc8:	4789                	li	a5,2
    80005cca:	02fb1463          	bne	s6,a5,80005cf2 <create+0x84>
    80005cce:	044ad783          	lhu	a5,68(s5)
    80005cd2:	37f9                	addiw	a5,a5,-2
    80005cd4:	17c2                	slli	a5,a5,0x30
    80005cd6:	93c1                	srli	a5,a5,0x30
    80005cd8:	4705                	li	a4,1
    80005cda:	00f76c63          	bltu	a4,a5,80005cf2 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005cde:	8556                	mv	a0,s5
    80005ce0:	60a6                	ld	ra,72(sp)
    80005ce2:	6406                	ld	s0,64(sp)
    80005ce4:	74e2                	ld	s1,56(sp)
    80005ce6:	7942                	ld	s2,48(sp)
    80005ce8:	79a2                	ld	s3,40(sp)
    80005cea:	6ae2                	ld	s5,24(sp)
    80005cec:	6b42                	ld	s6,16(sp)
    80005cee:	6161                	addi	sp,sp,80
    80005cf0:	8082                	ret
    iunlockput(ip);
    80005cf2:	8556                	mv	a0,s5
    80005cf4:	ffffe097          	auipc	ra,0xffffe
    80005cf8:	7b2080e7          	jalr	1970(ra) # 800044a6 <iunlockput>
    return 0;
    80005cfc:	4a81                	li	s5,0
    80005cfe:	b7c5                	j	80005cde <create+0x70>
    80005d00:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005d02:	85da                	mv	a1,s6
    80005d04:	4088                	lw	a0,0(s1)
    80005d06:	ffffe097          	auipc	ra,0xffffe
    80005d0a:	396080e7          	jalr	918(ra) # 8000409c <ialloc>
    80005d0e:	8a2a                	mv	s4,a0
    80005d10:	c531                	beqz	a0,80005d5c <create+0xee>
  ilock(ip);
    80005d12:	ffffe097          	auipc	ra,0xffffe
    80005d16:	52e080e7          	jalr	1326(ra) # 80004240 <ilock>
  ip->major = major;
    80005d1a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005d1e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005d22:	4905                	li	s2,1
    80005d24:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005d28:	8552                	mv	a0,s4
    80005d2a:	ffffe097          	auipc	ra,0xffffe
    80005d2e:	44a080e7          	jalr	1098(ra) # 80004174 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005d32:	032b0d63          	beq	s6,s2,80005d6c <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005d36:	004a2603          	lw	a2,4(s4)
    80005d3a:	fb040593          	addi	a1,s0,-80
    80005d3e:	8526                	mv	a0,s1
    80005d40:	fffff097          	auipc	ra,0xfffff
    80005d44:	c22080e7          	jalr	-990(ra) # 80004962 <dirlink>
    80005d48:	08054163          	bltz	a0,80005dca <create+0x15c>
  iunlockput(dp);
    80005d4c:	8526                	mv	a0,s1
    80005d4e:	ffffe097          	auipc	ra,0xffffe
    80005d52:	758080e7          	jalr	1880(ra) # 800044a6 <iunlockput>
  return ip;
    80005d56:	8ad2                	mv	s5,s4
    80005d58:	7a02                	ld	s4,32(sp)
    80005d5a:	b751                	j	80005cde <create+0x70>
    iunlockput(dp);
    80005d5c:	8526                	mv	a0,s1
    80005d5e:	ffffe097          	auipc	ra,0xffffe
    80005d62:	748080e7          	jalr	1864(ra) # 800044a6 <iunlockput>
    return 0;
    80005d66:	8ad2                	mv	s5,s4
    80005d68:	7a02                	ld	s4,32(sp)
    80005d6a:	bf95                	j	80005cde <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005d6c:	004a2603          	lw	a2,4(s4)
    80005d70:	00005597          	auipc	a1,0x5
    80005d74:	8f858593          	addi	a1,a1,-1800 # 8000a668 <etext+0x668>
    80005d78:	8552                	mv	a0,s4
    80005d7a:	fffff097          	auipc	ra,0xfffff
    80005d7e:	be8080e7          	jalr	-1048(ra) # 80004962 <dirlink>
    80005d82:	04054463          	bltz	a0,80005dca <create+0x15c>
    80005d86:	40d0                	lw	a2,4(s1)
    80005d88:	00005597          	auipc	a1,0x5
    80005d8c:	8e858593          	addi	a1,a1,-1816 # 8000a670 <etext+0x670>
    80005d90:	8552                	mv	a0,s4
    80005d92:	fffff097          	auipc	ra,0xfffff
    80005d96:	bd0080e7          	jalr	-1072(ra) # 80004962 <dirlink>
    80005d9a:	02054863          	bltz	a0,80005dca <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005d9e:	004a2603          	lw	a2,4(s4)
    80005da2:	fb040593          	addi	a1,s0,-80
    80005da6:	8526                	mv	a0,s1
    80005da8:	fffff097          	auipc	ra,0xfffff
    80005dac:	bba080e7          	jalr	-1094(ra) # 80004962 <dirlink>
    80005db0:	00054d63          	bltz	a0,80005dca <create+0x15c>
    dp->nlink++;  // for ".."
    80005db4:	04a4d783          	lhu	a5,74(s1)
    80005db8:	2785                	addiw	a5,a5,1
    80005dba:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005dbe:	8526                	mv	a0,s1
    80005dc0:	ffffe097          	auipc	ra,0xffffe
    80005dc4:	3b4080e7          	jalr	948(ra) # 80004174 <iupdate>
    80005dc8:	b751                	j	80005d4c <create+0xde>
  ip->nlink = 0;
    80005dca:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005dce:	8552                	mv	a0,s4
    80005dd0:	ffffe097          	auipc	ra,0xffffe
    80005dd4:	3a4080e7          	jalr	932(ra) # 80004174 <iupdate>
  iunlockput(ip);
    80005dd8:	8552                	mv	a0,s4
    80005dda:	ffffe097          	auipc	ra,0xffffe
    80005dde:	6cc080e7          	jalr	1740(ra) # 800044a6 <iunlockput>
  iunlockput(dp);
    80005de2:	8526                	mv	a0,s1
    80005de4:	ffffe097          	auipc	ra,0xffffe
    80005de8:	6c2080e7          	jalr	1730(ra) # 800044a6 <iunlockput>
  return 0;
    80005dec:	7a02                	ld	s4,32(sp)
    80005dee:	bdc5                	j	80005cde <create+0x70>
    return 0;
    80005df0:	8aaa                	mv	s5,a0
    80005df2:	b5f5                	j	80005cde <create+0x70>

0000000080005df4 <sys_dup>:
{
    80005df4:	7179                	addi	sp,sp,-48
    80005df6:	f406                	sd	ra,40(sp)
    80005df8:	f022                	sd	s0,32(sp)
    80005dfa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005dfc:	fd840613          	addi	a2,s0,-40
    80005e00:	4581                	li	a1,0
    80005e02:	4501                	li	a0,0
    80005e04:	00000097          	auipc	ra,0x0
    80005e08:	dc8080e7          	jalr	-568(ra) # 80005bcc <argfd>
    return -1;
    80005e0c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005e0e:	02054763          	bltz	a0,80005e3c <sys_dup+0x48>
    80005e12:	ec26                	sd	s1,24(sp)
    80005e14:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005e16:	fd843903          	ld	s2,-40(s0)
    80005e1a:	854a                	mv	a0,s2
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	e10080e7          	jalr	-496(ra) # 80005c2c <fdalloc>
    80005e24:	84aa                	mv	s1,a0
    return -1;
    80005e26:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005e28:	00054f63          	bltz	a0,80005e46 <sys_dup+0x52>
  filedup(f);
    80005e2c:	854a                	mv	a0,s2
    80005e2e:	fffff097          	auipc	ra,0xfffff
    80005e32:	27a080e7          	jalr	634(ra) # 800050a8 <filedup>
  return fd;
    80005e36:	87a6                	mv	a5,s1
    80005e38:	64e2                	ld	s1,24(sp)
    80005e3a:	6942                	ld	s2,16(sp)
}
    80005e3c:	853e                	mv	a0,a5
    80005e3e:	70a2                	ld	ra,40(sp)
    80005e40:	7402                	ld	s0,32(sp)
    80005e42:	6145                	addi	sp,sp,48
    80005e44:	8082                	ret
    80005e46:	64e2                	ld	s1,24(sp)
    80005e48:	6942                	ld	s2,16(sp)
    80005e4a:	bfcd                	j	80005e3c <sys_dup+0x48>

0000000080005e4c <sys_read>:
{
    80005e4c:	7179                	addi	sp,sp,-48
    80005e4e:	f406                	sd	ra,40(sp)
    80005e50:	f022                	sd	s0,32(sp)
    80005e52:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005e54:	fd840593          	addi	a1,s0,-40
    80005e58:	4505                	li	a0,1
    80005e5a:	ffffd097          	auipc	ra,0xffffd
    80005e5e:	63a080e7          	jalr	1594(ra) # 80003494 <argaddr>
  argint(2, &n);
    80005e62:	fe440593          	addi	a1,s0,-28
    80005e66:	4509                	li	a0,2
    80005e68:	ffffd097          	auipc	ra,0xffffd
    80005e6c:	60c080e7          	jalr	1548(ra) # 80003474 <argint>
  if(argfd(0, 0, &f) < 0)
    80005e70:	fe840613          	addi	a2,s0,-24
    80005e74:	4581                	li	a1,0
    80005e76:	4501                	li	a0,0
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	d54080e7          	jalr	-684(ra) # 80005bcc <argfd>
    80005e80:	87aa                	mv	a5,a0
    return -1;
    80005e82:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005e84:	0007cc63          	bltz	a5,80005e9c <sys_read+0x50>
  return fileread(f, p, n);
    80005e88:	fe442603          	lw	a2,-28(s0)
    80005e8c:	fd843583          	ld	a1,-40(s0)
    80005e90:	fe843503          	ld	a0,-24(s0)
    80005e94:	fffff097          	auipc	ra,0xfffff
    80005e98:	3ba080e7          	jalr	954(ra) # 8000524e <fileread>
}
    80005e9c:	70a2                	ld	ra,40(sp)
    80005e9e:	7402                	ld	s0,32(sp)
    80005ea0:	6145                	addi	sp,sp,48
    80005ea2:	8082                	ret

0000000080005ea4 <sys_write>:
{
    80005ea4:	7179                	addi	sp,sp,-48
    80005ea6:	f406                	sd	ra,40(sp)
    80005ea8:	f022                	sd	s0,32(sp)
    80005eaa:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005eac:	fd840593          	addi	a1,s0,-40
    80005eb0:	4505                	li	a0,1
    80005eb2:	ffffd097          	auipc	ra,0xffffd
    80005eb6:	5e2080e7          	jalr	1506(ra) # 80003494 <argaddr>
  argint(2, &n);
    80005eba:	fe440593          	addi	a1,s0,-28
    80005ebe:	4509                	li	a0,2
    80005ec0:	ffffd097          	auipc	ra,0xffffd
    80005ec4:	5b4080e7          	jalr	1460(ra) # 80003474 <argint>
  if(argfd(0, 0, &f) < 0)
    80005ec8:	fe840613          	addi	a2,s0,-24
    80005ecc:	4581                	li	a1,0
    80005ece:	4501                	li	a0,0
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	cfc080e7          	jalr	-772(ra) # 80005bcc <argfd>
    80005ed8:	87aa                	mv	a5,a0
    return -1;
    80005eda:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005edc:	0007cc63          	bltz	a5,80005ef4 <sys_write+0x50>
  return filewrite(f, p, n);
    80005ee0:	fe442603          	lw	a2,-28(s0)
    80005ee4:	fd843583          	ld	a1,-40(s0)
    80005ee8:	fe843503          	ld	a0,-24(s0)
    80005eec:	fffff097          	auipc	ra,0xfffff
    80005ef0:	434080e7          	jalr	1076(ra) # 80005320 <filewrite>
}
    80005ef4:	70a2                	ld	ra,40(sp)
    80005ef6:	7402                	ld	s0,32(sp)
    80005ef8:	6145                	addi	sp,sp,48
    80005efa:	8082                	ret

0000000080005efc <sys_close>:
{
    80005efc:	1101                	addi	sp,sp,-32
    80005efe:	ec06                	sd	ra,24(sp)
    80005f00:	e822                	sd	s0,16(sp)
    80005f02:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005f04:	fe040613          	addi	a2,s0,-32
    80005f08:	fec40593          	addi	a1,s0,-20
    80005f0c:	4501                	li	a0,0
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	cbe080e7          	jalr	-834(ra) # 80005bcc <argfd>
    return -1;
    80005f16:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005f18:	02054463          	bltz	a0,80005f40 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005f1c:	ffffc097          	auipc	ra,0xffffc
    80005f20:	f3e080e7          	jalr	-194(ra) # 80001e5a <myproc>
    80005f24:	fec42783          	lw	a5,-20(s0)
    80005f28:	07e9                	addi	a5,a5,26
    80005f2a:	078e                	slli	a5,a5,0x3
    80005f2c:	953e                	add	a0,a0,a5
    80005f2e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005f32:	fe043503          	ld	a0,-32(s0)
    80005f36:	fffff097          	auipc	ra,0xfffff
    80005f3a:	1c4080e7          	jalr	452(ra) # 800050fa <fileclose>
  return 0;
    80005f3e:	4781                	li	a5,0
}
    80005f40:	853e                	mv	a0,a5
    80005f42:	60e2                	ld	ra,24(sp)
    80005f44:	6442                	ld	s0,16(sp)
    80005f46:	6105                	addi	sp,sp,32
    80005f48:	8082                	ret

0000000080005f4a <sys_fstat>:
{
    80005f4a:	1101                	addi	sp,sp,-32
    80005f4c:	ec06                	sd	ra,24(sp)
    80005f4e:	e822                	sd	s0,16(sp)
    80005f50:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005f52:	fe040593          	addi	a1,s0,-32
    80005f56:	4505                	li	a0,1
    80005f58:	ffffd097          	auipc	ra,0xffffd
    80005f5c:	53c080e7          	jalr	1340(ra) # 80003494 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005f60:	fe840613          	addi	a2,s0,-24
    80005f64:	4581                	li	a1,0
    80005f66:	4501                	li	a0,0
    80005f68:	00000097          	auipc	ra,0x0
    80005f6c:	c64080e7          	jalr	-924(ra) # 80005bcc <argfd>
    80005f70:	87aa                	mv	a5,a0
    return -1;
    80005f72:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005f74:	0007ca63          	bltz	a5,80005f88 <sys_fstat+0x3e>
  return filestat(f, st);
    80005f78:	fe043583          	ld	a1,-32(s0)
    80005f7c:	fe843503          	ld	a0,-24(s0)
    80005f80:	fffff097          	auipc	ra,0xfffff
    80005f84:	258080e7          	jalr	600(ra) # 800051d8 <filestat>
}
    80005f88:	60e2                	ld	ra,24(sp)
    80005f8a:	6442                	ld	s0,16(sp)
    80005f8c:	6105                	addi	sp,sp,32
    80005f8e:	8082                	ret

0000000080005f90 <sys_link>:
{
    80005f90:	7169                	addi	sp,sp,-304
    80005f92:	f606                	sd	ra,296(sp)
    80005f94:	f222                	sd	s0,288(sp)
    80005f96:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005f98:	08000613          	li	a2,128
    80005f9c:	ed040593          	addi	a1,s0,-304
    80005fa0:	4501                	li	a0,0
    80005fa2:	ffffd097          	auipc	ra,0xffffd
    80005fa6:	512080e7          	jalr	1298(ra) # 800034b4 <argstr>
    return -1;
    80005faa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005fac:	12054663          	bltz	a0,800060d8 <sys_link+0x148>
    80005fb0:	08000613          	li	a2,128
    80005fb4:	f5040593          	addi	a1,s0,-176
    80005fb8:	4505                	li	a0,1
    80005fba:	ffffd097          	auipc	ra,0xffffd
    80005fbe:	4fa080e7          	jalr	1274(ra) # 800034b4 <argstr>
    return -1;
    80005fc2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005fc4:	10054a63          	bltz	a0,800060d8 <sys_link+0x148>
    80005fc8:	ee26                	sd	s1,280(sp)
  begin_op();
    80005fca:	fffff097          	auipc	ra,0xfffff
    80005fce:	c60080e7          	jalr	-928(ra) # 80004c2a <begin_op>
  if((ip = namei(old)) == 0){
    80005fd2:	ed040513          	addi	a0,s0,-304
    80005fd6:	fffff097          	auipc	ra,0xfffff
    80005fda:	a4e080e7          	jalr	-1458(ra) # 80004a24 <namei>
    80005fde:	84aa                	mv	s1,a0
    80005fe0:	c949                	beqz	a0,80006072 <sys_link+0xe2>
  ilock(ip);
    80005fe2:	ffffe097          	auipc	ra,0xffffe
    80005fe6:	25e080e7          	jalr	606(ra) # 80004240 <ilock>
  if(ip->type == T_DIR){
    80005fea:	04449703          	lh	a4,68(s1)
    80005fee:	4785                	li	a5,1
    80005ff0:	08f70863          	beq	a4,a5,80006080 <sys_link+0xf0>
    80005ff4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005ff6:	04a4d783          	lhu	a5,74(s1)
    80005ffa:	2785                	addiw	a5,a5,1
    80005ffc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006000:	8526                	mv	a0,s1
    80006002:	ffffe097          	auipc	ra,0xffffe
    80006006:	172080e7          	jalr	370(ra) # 80004174 <iupdate>
  iunlock(ip);
    8000600a:	8526                	mv	a0,s1
    8000600c:	ffffe097          	auipc	ra,0xffffe
    80006010:	2fa080e7          	jalr	762(ra) # 80004306 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80006014:	fd040593          	addi	a1,s0,-48
    80006018:	f5040513          	addi	a0,s0,-176
    8000601c:	fffff097          	auipc	ra,0xfffff
    80006020:	a26080e7          	jalr	-1498(ra) # 80004a42 <nameiparent>
    80006024:	892a                	mv	s2,a0
    80006026:	cd35                	beqz	a0,800060a2 <sys_link+0x112>
  ilock(dp);
    80006028:	ffffe097          	auipc	ra,0xffffe
    8000602c:	218080e7          	jalr	536(ra) # 80004240 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80006030:	00092703          	lw	a4,0(s2)
    80006034:	409c                	lw	a5,0(s1)
    80006036:	06f71163          	bne	a4,a5,80006098 <sys_link+0x108>
    8000603a:	40d0                	lw	a2,4(s1)
    8000603c:	fd040593          	addi	a1,s0,-48
    80006040:	854a                	mv	a0,s2
    80006042:	fffff097          	auipc	ra,0xfffff
    80006046:	920080e7          	jalr	-1760(ra) # 80004962 <dirlink>
    8000604a:	04054763          	bltz	a0,80006098 <sys_link+0x108>
  iunlockput(dp);
    8000604e:	854a                	mv	a0,s2
    80006050:	ffffe097          	auipc	ra,0xffffe
    80006054:	456080e7          	jalr	1110(ra) # 800044a6 <iunlockput>
  iput(ip);
    80006058:	8526                	mv	a0,s1
    8000605a:	ffffe097          	auipc	ra,0xffffe
    8000605e:	3a4080e7          	jalr	932(ra) # 800043fe <iput>
  end_op();
    80006062:	fffff097          	auipc	ra,0xfffff
    80006066:	c42080e7          	jalr	-958(ra) # 80004ca4 <end_op>
  return 0;
    8000606a:	4781                	li	a5,0
    8000606c:	64f2                	ld	s1,280(sp)
    8000606e:	6952                	ld	s2,272(sp)
    80006070:	a0a5                	j	800060d8 <sys_link+0x148>
    end_op();
    80006072:	fffff097          	auipc	ra,0xfffff
    80006076:	c32080e7          	jalr	-974(ra) # 80004ca4 <end_op>
    return -1;
    8000607a:	57fd                	li	a5,-1
    8000607c:	64f2                	ld	s1,280(sp)
    8000607e:	a8a9                	j	800060d8 <sys_link+0x148>
    iunlockput(ip);
    80006080:	8526                	mv	a0,s1
    80006082:	ffffe097          	auipc	ra,0xffffe
    80006086:	424080e7          	jalr	1060(ra) # 800044a6 <iunlockput>
    end_op();
    8000608a:	fffff097          	auipc	ra,0xfffff
    8000608e:	c1a080e7          	jalr	-998(ra) # 80004ca4 <end_op>
    return -1;
    80006092:	57fd                	li	a5,-1
    80006094:	64f2                	ld	s1,280(sp)
    80006096:	a089                	j	800060d8 <sys_link+0x148>
    iunlockput(dp);
    80006098:	854a                	mv	a0,s2
    8000609a:	ffffe097          	auipc	ra,0xffffe
    8000609e:	40c080e7          	jalr	1036(ra) # 800044a6 <iunlockput>
  ilock(ip);
    800060a2:	8526                	mv	a0,s1
    800060a4:	ffffe097          	auipc	ra,0xffffe
    800060a8:	19c080e7          	jalr	412(ra) # 80004240 <ilock>
  ip->nlink--;
    800060ac:	04a4d783          	lhu	a5,74(s1)
    800060b0:	37fd                	addiw	a5,a5,-1
    800060b2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800060b6:	8526                	mv	a0,s1
    800060b8:	ffffe097          	auipc	ra,0xffffe
    800060bc:	0bc080e7          	jalr	188(ra) # 80004174 <iupdate>
  iunlockput(ip);
    800060c0:	8526                	mv	a0,s1
    800060c2:	ffffe097          	auipc	ra,0xffffe
    800060c6:	3e4080e7          	jalr	996(ra) # 800044a6 <iunlockput>
  end_op();
    800060ca:	fffff097          	auipc	ra,0xfffff
    800060ce:	bda080e7          	jalr	-1062(ra) # 80004ca4 <end_op>
  return -1;
    800060d2:	57fd                	li	a5,-1
    800060d4:	64f2                	ld	s1,280(sp)
    800060d6:	6952                	ld	s2,272(sp)
}
    800060d8:	853e                	mv	a0,a5
    800060da:	70b2                	ld	ra,296(sp)
    800060dc:	7412                	ld	s0,288(sp)
    800060de:	6155                	addi	sp,sp,304
    800060e0:	8082                	ret

00000000800060e2 <sys_unlink>:
{
    800060e2:	7111                	addi	sp,sp,-256
    800060e4:	fd86                	sd	ra,248(sp)
    800060e6:	f9a2                	sd	s0,240(sp)
    800060e8:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    800060ea:	08000613          	li	a2,128
    800060ee:	f2040593          	addi	a1,s0,-224
    800060f2:	4501                	li	a0,0
    800060f4:	ffffd097          	auipc	ra,0xffffd
    800060f8:	3c0080e7          	jalr	960(ra) # 800034b4 <argstr>
    800060fc:	1c054063          	bltz	a0,800062bc <sys_unlink+0x1da>
    80006100:	f5a6                	sd	s1,232(sp)
  begin_op();
    80006102:	fffff097          	auipc	ra,0xfffff
    80006106:	b28080e7          	jalr	-1240(ra) # 80004c2a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000610a:	fa040593          	addi	a1,s0,-96
    8000610e:	f2040513          	addi	a0,s0,-224
    80006112:	fffff097          	auipc	ra,0xfffff
    80006116:	930080e7          	jalr	-1744(ra) # 80004a42 <nameiparent>
    8000611a:	84aa                	mv	s1,a0
    8000611c:	c165                	beqz	a0,800061fc <sys_unlink+0x11a>
  ilock(dp);
    8000611e:	ffffe097          	auipc	ra,0xffffe
    80006122:	122080e7          	jalr	290(ra) # 80004240 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006126:	00004597          	auipc	a1,0x4
    8000612a:	54258593          	addi	a1,a1,1346 # 8000a668 <etext+0x668>
    8000612e:	fa040513          	addi	a0,s0,-96
    80006132:	ffffe097          	auipc	ra,0xffffe
    80006136:	5f0080e7          	jalr	1520(ra) # 80004722 <namecmp>
    8000613a:	16050263          	beqz	a0,8000629e <sys_unlink+0x1bc>
    8000613e:	00004597          	auipc	a1,0x4
    80006142:	53258593          	addi	a1,a1,1330 # 8000a670 <etext+0x670>
    80006146:	fa040513          	addi	a0,s0,-96
    8000614a:	ffffe097          	auipc	ra,0xffffe
    8000614e:	5d8080e7          	jalr	1496(ra) # 80004722 <namecmp>
    80006152:	14050663          	beqz	a0,8000629e <sys_unlink+0x1bc>
    80006156:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80006158:	f1c40613          	addi	a2,s0,-228
    8000615c:	fa040593          	addi	a1,s0,-96
    80006160:	8526                	mv	a0,s1
    80006162:	ffffe097          	auipc	ra,0xffffe
    80006166:	5da080e7          	jalr	1498(ra) # 8000473c <dirlookup>
    8000616a:	892a                	mv	s2,a0
    8000616c:	12050863          	beqz	a0,8000629c <sys_unlink+0x1ba>
    80006170:	edce                	sd	s3,216(sp)
  ilock(ip);
    80006172:	ffffe097          	auipc	ra,0xffffe
    80006176:	0ce080e7          	jalr	206(ra) # 80004240 <ilock>
  if(ip->nlink < 1)
    8000617a:	04a91783          	lh	a5,74(s2)
    8000617e:	08f05663          	blez	a5,8000620a <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80006182:	04491703          	lh	a4,68(s2)
    80006186:	4785                	li	a5,1
    80006188:	08f70b63          	beq	a4,a5,8000621e <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    8000618c:	fb040993          	addi	s3,s0,-80
    80006190:	4641                	li	a2,16
    80006192:	4581                	li	a1,0
    80006194:	854e                	mv	a0,s3
    80006196:	ffffb097          	auipc	ra,0xffffb
    8000619a:	c78080e7          	jalr	-904(ra) # 80000e0e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000619e:	4741                	li	a4,16
    800061a0:	f1c42683          	lw	a3,-228(s0)
    800061a4:	864e                	mv	a2,s3
    800061a6:	4581                	li	a1,0
    800061a8:	8526                	mv	a0,s1
    800061aa:	ffffe097          	auipc	ra,0xffffe
    800061ae:	458080e7          	jalr	1112(ra) # 80004602 <writei>
    800061b2:	47c1                	li	a5,16
    800061b4:	0af51f63          	bne	a0,a5,80006272 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    800061b8:	04491703          	lh	a4,68(s2)
    800061bc:	4785                	li	a5,1
    800061be:	0cf70463          	beq	a4,a5,80006286 <sys_unlink+0x1a4>
  iunlockput(dp);
    800061c2:	8526                	mv	a0,s1
    800061c4:	ffffe097          	auipc	ra,0xffffe
    800061c8:	2e2080e7          	jalr	738(ra) # 800044a6 <iunlockput>
  ip->nlink--;
    800061cc:	04a95783          	lhu	a5,74(s2)
    800061d0:	37fd                	addiw	a5,a5,-1
    800061d2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800061d6:	854a                	mv	a0,s2
    800061d8:	ffffe097          	auipc	ra,0xffffe
    800061dc:	f9c080e7          	jalr	-100(ra) # 80004174 <iupdate>
  iunlockput(ip);
    800061e0:	854a                	mv	a0,s2
    800061e2:	ffffe097          	auipc	ra,0xffffe
    800061e6:	2c4080e7          	jalr	708(ra) # 800044a6 <iunlockput>
  end_op();
    800061ea:	fffff097          	auipc	ra,0xfffff
    800061ee:	aba080e7          	jalr	-1350(ra) # 80004ca4 <end_op>
  return 0;
    800061f2:	4501                	li	a0,0
    800061f4:	74ae                	ld	s1,232(sp)
    800061f6:	790e                	ld	s2,224(sp)
    800061f8:	69ee                	ld	s3,216(sp)
    800061fa:	a86d                	j	800062b4 <sys_unlink+0x1d2>
    end_op();
    800061fc:	fffff097          	auipc	ra,0xfffff
    80006200:	aa8080e7          	jalr	-1368(ra) # 80004ca4 <end_op>
    return -1;
    80006204:	557d                	li	a0,-1
    80006206:	74ae                	ld	s1,232(sp)
    80006208:	a075                	j	800062b4 <sys_unlink+0x1d2>
    8000620a:	e9d2                	sd	s4,208(sp)
    8000620c:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    8000620e:	00004517          	auipc	a0,0x4
    80006212:	46a50513          	addi	a0,a0,1130 # 8000a678 <etext+0x678>
    80006216:	ffffa097          	auipc	ra,0xffffa
    8000621a:	34a080e7          	jalr	842(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000621e:	04c92703          	lw	a4,76(s2)
    80006222:	02000793          	li	a5,32
    80006226:	f6e7f3e3          	bgeu	a5,a4,8000618c <sys_unlink+0xaa>
    8000622a:	e9d2                	sd	s4,208(sp)
    8000622c:	e5d6                	sd	s5,200(sp)
    8000622e:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006230:	f0840a93          	addi	s5,s0,-248
    80006234:	4a41                	li	s4,16
    80006236:	8752                	mv	a4,s4
    80006238:	86ce                	mv	a3,s3
    8000623a:	8656                	mv	a2,s5
    8000623c:	4581                	li	a1,0
    8000623e:	854a                	mv	a0,s2
    80006240:	ffffe097          	auipc	ra,0xffffe
    80006244:	2bc080e7          	jalr	700(ra) # 800044fc <readi>
    80006248:	01451d63          	bne	a0,s4,80006262 <sys_unlink+0x180>
    if(de.inum != 0)
    8000624c:	f0845783          	lhu	a5,-248(s0)
    80006250:	eba5                	bnez	a5,800062c0 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006252:	29c1                	addiw	s3,s3,16
    80006254:	04c92783          	lw	a5,76(s2)
    80006258:	fcf9efe3          	bltu	s3,a5,80006236 <sys_unlink+0x154>
    8000625c:	6a4e                	ld	s4,208(sp)
    8000625e:	6aae                	ld	s5,200(sp)
    80006260:	b735                	j	8000618c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80006262:	00004517          	auipc	a0,0x4
    80006266:	42e50513          	addi	a0,a0,1070 # 8000a690 <etext+0x690>
    8000626a:	ffffa097          	auipc	ra,0xffffa
    8000626e:	2f6080e7          	jalr	758(ra) # 80000560 <panic>
    80006272:	e9d2                	sd	s4,208(sp)
    80006274:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80006276:	00004517          	auipc	a0,0x4
    8000627a:	43250513          	addi	a0,a0,1074 # 8000a6a8 <etext+0x6a8>
    8000627e:	ffffa097          	auipc	ra,0xffffa
    80006282:	2e2080e7          	jalr	738(ra) # 80000560 <panic>
    dp->nlink--;
    80006286:	04a4d783          	lhu	a5,74(s1)
    8000628a:	37fd                	addiw	a5,a5,-1
    8000628c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006290:	8526                	mv	a0,s1
    80006292:	ffffe097          	auipc	ra,0xffffe
    80006296:	ee2080e7          	jalr	-286(ra) # 80004174 <iupdate>
    8000629a:	b725                	j	800061c2 <sys_unlink+0xe0>
    8000629c:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    8000629e:	8526                	mv	a0,s1
    800062a0:	ffffe097          	auipc	ra,0xffffe
    800062a4:	206080e7          	jalr	518(ra) # 800044a6 <iunlockput>
  end_op();
    800062a8:	fffff097          	auipc	ra,0xfffff
    800062ac:	9fc080e7          	jalr	-1540(ra) # 80004ca4 <end_op>
  return -1;
    800062b0:	557d                	li	a0,-1
    800062b2:	74ae                	ld	s1,232(sp)
}
    800062b4:	70ee                	ld	ra,248(sp)
    800062b6:	744e                	ld	s0,240(sp)
    800062b8:	6111                	addi	sp,sp,256
    800062ba:	8082                	ret
    return -1;
    800062bc:	557d                	li	a0,-1
    800062be:	bfdd                	j	800062b4 <sys_unlink+0x1d2>
    iunlockput(ip);
    800062c0:	854a                	mv	a0,s2
    800062c2:	ffffe097          	auipc	ra,0xffffe
    800062c6:	1e4080e7          	jalr	484(ra) # 800044a6 <iunlockput>
    goto bad;
    800062ca:	790e                	ld	s2,224(sp)
    800062cc:	69ee                	ld	s3,216(sp)
    800062ce:	6a4e                	ld	s4,208(sp)
    800062d0:	6aae                	ld	s5,200(sp)
    800062d2:	b7f1                	j	8000629e <sys_unlink+0x1bc>

00000000800062d4 <sys_open>:

uint64
sys_open(void)
{
    800062d4:	7131                	addi	sp,sp,-192
    800062d6:	fd06                	sd	ra,184(sp)
    800062d8:	f922                	sd	s0,176(sp)
    800062da:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800062dc:	f4c40593          	addi	a1,s0,-180
    800062e0:	4505                	li	a0,1
    800062e2:	ffffd097          	auipc	ra,0xffffd
    800062e6:	192080e7          	jalr	402(ra) # 80003474 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800062ea:	08000613          	li	a2,128
    800062ee:	f5040593          	addi	a1,s0,-176
    800062f2:	4501                	li	a0,0
    800062f4:	ffffd097          	auipc	ra,0xffffd
    800062f8:	1c0080e7          	jalr	448(ra) # 800034b4 <argstr>
    800062fc:	87aa                	mv	a5,a0
    return -1;
    800062fe:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006300:	0a07cf63          	bltz	a5,800063be <sys_open+0xea>
    80006304:	f526                	sd	s1,168(sp)

  begin_op();
    80006306:	fffff097          	auipc	ra,0xfffff
    8000630a:	924080e7          	jalr	-1756(ra) # 80004c2a <begin_op>

  if(omode & O_CREATE){
    8000630e:	f4c42783          	lw	a5,-180(s0)
    80006312:	2007f793          	andi	a5,a5,512
    80006316:	cfdd                	beqz	a5,800063d4 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80006318:	4681                	li	a3,0
    8000631a:	4601                	li	a2,0
    8000631c:	4589                	li	a1,2
    8000631e:	f5040513          	addi	a0,s0,-176
    80006322:	00000097          	auipc	ra,0x0
    80006326:	94c080e7          	jalr	-1716(ra) # 80005c6e <create>
    8000632a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000632c:	cd49                	beqz	a0,800063c6 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000632e:	04449703          	lh	a4,68(s1)
    80006332:	478d                	li	a5,3
    80006334:	00f71763          	bne	a4,a5,80006342 <sys_open+0x6e>
    80006338:	0464d703          	lhu	a4,70(s1)
    8000633c:	47a5                	li	a5,9
    8000633e:	0ee7e263          	bltu	a5,a4,80006422 <sys_open+0x14e>
    80006342:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006344:	fffff097          	auipc	ra,0xfffff
    80006348:	cfa080e7          	jalr	-774(ra) # 8000503e <filealloc>
    8000634c:	892a                	mv	s2,a0
    8000634e:	cd65                	beqz	a0,80006446 <sys_open+0x172>
    80006350:	ed4e                	sd	s3,152(sp)
    80006352:	00000097          	auipc	ra,0x0
    80006356:	8da080e7          	jalr	-1830(ra) # 80005c2c <fdalloc>
    8000635a:	89aa                	mv	s3,a0
    8000635c:	0c054f63          	bltz	a0,8000643a <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80006360:	04449703          	lh	a4,68(s1)
    80006364:	478d                	li	a5,3
    80006366:	0ef70d63          	beq	a4,a5,80006460 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000636a:	4789                	li	a5,2
    8000636c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80006370:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80006374:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006378:	f4c42783          	lw	a5,-180(s0)
    8000637c:	0017f713          	andi	a4,a5,1
    80006380:	00174713          	xori	a4,a4,1
    80006384:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006388:	0037f713          	andi	a4,a5,3
    8000638c:	00e03733          	snez	a4,a4
    80006390:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80006394:	4007f793          	andi	a5,a5,1024
    80006398:	c791                	beqz	a5,800063a4 <sys_open+0xd0>
    8000639a:	04449703          	lh	a4,68(s1)
    8000639e:	4789                	li	a5,2
    800063a0:	0cf70763          	beq	a4,a5,8000646e <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    800063a4:	8526                	mv	a0,s1
    800063a6:	ffffe097          	auipc	ra,0xffffe
    800063aa:	f60080e7          	jalr	-160(ra) # 80004306 <iunlock>
  end_op();
    800063ae:	fffff097          	auipc	ra,0xfffff
    800063b2:	8f6080e7          	jalr	-1802(ra) # 80004ca4 <end_op>

  return fd;
    800063b6:	854e                	mv	a0,s3
    800063b8:	74aa                	ld	s1,168(sp)
    800063ba:	790a                	ld	s2,160(sp)
    800063bc:	69ea                	ld	s3,152(sp)
}
    800063be:	70ea                	ld	ra,184(sp)
    800063c0:	744a                	ld	s0,176(sp)
    800063c2:	6129                	addi	sp,sp,192
    800063c4:	8082                	ret
      end_op();
    800063c6:	fffff097          	auipc	ra,0xfffff
    800063ca:	8de080e7          	jalr	-1826(ra) # 80004ca4 <end_op>
      return -1;
    800063ce:	557d                	li	a0,-1
    800063d0:	74aa                	ld	s1,168(sp)
    800063d2:	b7f5                	j	800063be <sys_open+0xea>
    if((ip = namei(path)) == 0){
    800063d4:	f5040513          	addi	a0,s0,-176
    800063d8:	ffffe097          	auipc	ra,0xffffe
    800063dc:	64c080e7          	jalr	1612(ra) # 80004a24 <namei>
    800063e0:	84aa                	mv	s1,a0
    800063e2:	c90d                	beqz	a0,80006414 <sys_open+0x140>
    ilock(ip);
    800063e4:	ffffe097          	auipc	ra,0xffffe
    800063e8:	e5c080e7          	jalr	-420(ra) # 80004240 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800063ec:	04449703          	lh	a4,68(s1)
    800063f0:	4785                	li	a5,1
    800063f2:	f2f71ee3          	bne	a4,a5,8000632e <sys_open+0x5a>
    800063f6:	f4c42783          	lw	a5,-180(s0)
    800063fa:	d7a1                	beqz	a5,80006342 <sys_open+0x6e>
      iunlockput(ip);
    800063fc:	8526                	mv	a0,s1
    800063fe:	ffffe097          	auipc	ra,0xffffe
    80006402:	0a8080e7          	jalr	168(ra) # 800044a6 <iunlockput>
      end_op();
    80006406:	fffff097          	auipc	ra,0xfffff
    8000640a:	89e080e7          	jalr	-1890(ra) # 80004ca4 <end_op>
      return -1;
    8000640e:	557d                	li	a0,-1
    80006410:	74aa                	ld	s1,168(sp)
    80006412:	b775                	j	800063be <sys_open+0xea>
      end_op();
    80006414:	fffff097          	auipc	ra,0xfffff
    80006418:	890080e7          	jalr	-1904(ra) # 80004ca4 <end_op>
      return -1;
    8000641c:	557d                	li	a0,-1
    8000641e:	74aa                	ld	s1,168(sp)
    80006420:	bf79                	j	800063be <sys_open+0xea>
    iunlockput(ip);
    80006422:	8526                	mv	a0,s1
    80006424:	ffffe097          	auipc	ra,0xffffe
    80006428:	082080e7          	jalr	130(ra) # 800044a6 <iunlockput>
    end_op();
    8000642c:	fffff097          	auipc	ra,0xfffff
    80006430:	878080e7          	jalr	-1928(ra) # 80004ca4 <end_op>
    return -1;
    80006434:	557d                	li	a0,-1
    80006436:	74aa                	ld	s1,168(sp)
    80006438:	b759                	j	800063be <sys_open+0xea>
      fileclose(f);
    8000643a:	854a                	mv	a0,s2
    8000643c:	fffff097          	auipc	ra,0xfffff
    80006440:	cbe080e7          	jalr	-834(ra) # 800050fa <fileclose>
    80006444:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80006446:	8526                	mv	a0,s1
    80006448:	ffffe097          	auipc	ra,0xffffe
    8000644c:	05e080e7          	jalr	94(ra) # 800044a6 <iunlockput>
    end_op();
    80006450:	fffff097          	auipc	ra,0xfffff
    80006454:	854080e7          	jalr	-1964(ra) # 80004ca4 <end_op>
    return -1;
    80006458:	557d                	li	a0,-1
    8000645a:	74aa                	ld	s1,168(sp)
    8000645c:	790a                	ld	s2,160(sp)
    8000645e:	b785                	j	800063be <sys_open+0xea>
    f->type = FD_DEVICE;
    80006460:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80006464:	04649783          	lh	a5,70(s1)
    80006468:	02f91223          	sh	a5,36(s2)
    8000646c:	b721                	j	80006374 <sys_open+0xa0>
    itrunc(ip);
    8000646e:	8526                	mv	a0,s1
    80006470:	ffffe097          	auipc	ra,0xffffe
    80006474:	ee2080e7          	jalr	-286(ra) # 80004352 <itrunc>
    80006478:	b735                	j	800063a4 <sys_open+0xd0>

000000008000647a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000647a:	7175                	addi	sp,sp,-144
    8000647c:	e506                	sd	ra,136(sp)
    8000647e:	e122                	sd	s0,128(sp)
    80006480:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006482:	ffffe097          	auipc	ra,0xffffe
    80006486:	7a8080e7          	jalr	1960(ra) # 80004c2a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000648a:	08000613          	li	a2,128
    8000648e:	f7040593          	addi	a1,s0,-144
    80006492:	4501                	li	a0,0
    80006494:	ffffd097          	auipc	ra,0xffffd
    80006498:	020080e7          	jalr	32(ra) # 800034b4 <argstr>
    8000649c:	02054963          	bltz	a0,800064ce <sys_mkdir+0x54>
    800064a0:	4681                	li	a3,0
    800064a2:	4601                	li	a2,0
    800064a4:	4585                	li	a1,1
    800064a6:	f7040513          	addi	a0,s0,-144
    800064aa:	fffff097          	auipc	ra,0xfffff
    800064ae:	7c4080e7          	jalr	1988(ra) # 80005c6e <create>
    800064b2:	cd11                	beqz	a0,800064ce <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800064b4:	ffffe097          	auipc	ra,0xffffe
    800064b8:	ff2080e7          	jalr	-14(ra) # 800044a6 <iunlockput>
  end_op();
    800064bc:	ffffe097          	auipc	ra,0xffffe
    800064c0:	7e8080e7          	jalr	2024(ra) # 80004ca4 <end_op>
  return 0;
    800064c4:	4501                	li	a0,0
}
    800064c6:	60aa                	ld	ra,136(sp)
    800064c8:	640a                	ld	s0,128(sp)
    800064ca:	6149                	addi	sp,sp,144
    800064cc:	8082                	ret
    end_op();
    800064ce:	ffffe097          	auipc	ra,0xffffe
    800064d2:	7d6080e7          	jalr	2006(ra) # 80004ca4 <end_op>
    return -1;
    800064d6:	557d                	li	a0,-1
    800064d8:	b7fd                	j	800064c6 <sys_mkdir+0x4c>

00000000800064da <sys_mknod>:

uint64
sys_mknod(void)
{
    800064da:	7135                	addi	sp,sp,-160
    800064dc:	ed06                	sd	ra,152(sp)
    800064de:	e922                	sd	s0,144(sp)
    800064e0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800064e2:	ffffe097          	auipc	ra,0xffffe
    800064e6:	748080e7          	jalr	1864(ra) # 80004c2a <begin_op>
  argint(1, &major);
    800064ea:	f6c40593          	addi	a1,s0,-148
    800064ee:	4505                	li	a0,1
    800064f0:	ffffd097          	auipc	ra,0xffffd
    800064f4:	f84080e7          	jalr	-124(ra) # 80003474 <argint>
  argint(2, &minor);
    800064f8:	f6840593          	addi	a1,s0,-152
    800064fc:	4509                	li	a0,2
    800064fe:	ffffd097          	auipc	ra,0xffffd
    80006502:	f76080e7          	jalr	-138(ra) # 80003474 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006506:	08000613          	li	a2,128
    8000650a:	f7040593          	addi	a1,s0,-144
    8000650e:	4501                	li	a0,0
    80006510:	ffffd097          	auipc	ra,0xffffd
    80006514:	fa4080e7          	jalr	-92(ra) # 800034b4 <argstr>
    80006518:	02054b63          	bltz	a0,8000654e <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000651c:	f6841683          	lh	a3,-152(s0)
    80006520:	f6c41603          	lh	a2,-148(s0)
    80006524:	458d                	li	a1,3
    80006526:	f7040513          	addi	a0,s0,-144
    8000652a:	fffff097          	auipc	ra,0xfffff
    8000652e:	744080e7          	jalr	1860(ra) # 80005c6e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006532:	cd11                	beqz	a0,8000654e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006534:	ffffe097          	auipc	ra,0xffffe
    80006538:	f72080e7          	jalr	-142(ra) # 800044a6 <iunlockput>
  end_op();
    8000653c:	ffffe097          	auipc	ra,0xffffe
    80006540:	768080e7          	jalr	1896(ra) # 80004ca4 <end_op>
  return 0;
    80006544:	4501                	li	a0,0
}
    80006546:	60ea                	ld	ra,152(sp)
    80006548:	644a                	ld	s0,144(sp)
    8000654a:	610d                	addi	sp,sp,160
    8000654c:	8082                	ret
    end_op();
    8000654e:	ffffe097          	auipc	ra,0xffffe
    80006552:	756080e7          	jalr	1878(ra) # 80004ca4 <end_op>
    return -1;
    80006556:	557d                	li	a0,-1
    80006558:	b7fd                	j	80006546 <sys_mknod+0x6c>

000000008000655a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000655a:	7135                	addi	sp,sp,-160
    8000655c:	ed06                	sd	ra,152(sp)
    8000655e:	e922                	sd	s0,144(sp)
    80006560:	e14a                	sd	s2,128(sp)
    80006562:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80006564:	ffffc097          	auipc	ra,0xffffc
    80006568:	8f6080e7          	jalr	-1802(ra) # 80001e5a <myproc>
    8000656c:	892a                	mv	s2,a0
  
  begin_op();
    8000656e:	ffffe097          	auipc	ra,0xffffe
    80006572:	6bc080e7          	jalr	1724(ra) # 80004c2a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006576:	08000613          	li	a2,128
    8000657a:	f6040593          	addi	a1,s0,-160
    8000657e:	4501                	li	a0,0
    80006580:	ffffd097          	auipc	ra,0xffffd
    80006584:	f34080e7          	jalr	-204(ra) # 800034b4 <argstr>
    80006588:	04054d63          	bltz	a0,800065e2 <sys_chdir+0x88>
    8000658c:	e526                	sd	s1,136(sp)
    8000658e:	f6040513          	addi	a0,s0,-160
    80006592:	ffffe097          	auipc	ra,0xffffe
    80006596:	492080e7          	jalr	1170(ra) # 80004a24 <namei>
    8000659a:	84aa                	mv	s1,a0
    8000659c:	c131                	beqz	a0,800065e0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000659e:	ffffe097          	auipc	ra,0xffffe
    800065a2:	ca2080e7          	jalr	-862(ra) # 80004240 <ilock>
  if(ip->type != T_DIR){
    800065a6:	04449703          	lh	a4,68(s1)
    800065aa:	4785                	li	a5,1
    800065ac:	04f71163          	bne	a4,a5,800065ee <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800065b0:	8526                	mv	a0,s1
    800065b2:	ffffe097          	auipc	ra,0xffffe
    800065b6:	d54080e7          	jalr	-684(ra) # 80004306 <iunlock>
  iput(p->cwd);
    800065ba:	15093503          	ld	a0,336(s2)
    800065be:	ffffe097          	auipc	ra,0xffffe
    800065c2:	e40080e7          	jalr	-448(ra) # 800043fe <iput>
  end_op();
    800065c6:	ffffe097          	auipc	ra,0xffffe
    800065ca:	6de080e7          	jalr	1758(ra) # 80004ca4 <end_op>
  p->cwd = ip;
    800065ce:	14993823          	sd	s1,336(s2)
  return 0;
    800065d2:	4501                	li	a0,0
    800065d4:	64aa                	ld	s1,136(sp)
}
    800065d6:	60ea                	ld	ra,152(sp)
    800065d8:	644a                	ld	s0,144(sp)
    800065da:	690a                	ld	s2,128(sp)
    800065dc:	610d                	addi	sp,sp,160
    800065de:	8082                	ret
    800065e0:	64aa                	ld	s1,136(sp)
    end_op();
    800065e2:	ffffe097          	auipc	ra,0xffffe
    800065e6:	6c2080e7          	jalr	1730(ra) # 80004ca4 <end_op>
    return -1;
    800065ea:	557d                	li	a0,-1
    800065ec:	b7ed                	j	800065d6 <sys_chdir+0x7c>
    iunlockput(ip);
    800065ee:	8526                	mv	a0,s1
    800065f0:	ffffe097          	auipc	ra,0xffffe
    800065f4:	eb6080e7          	jalr	-330(ra) # 800044a6 <iunlockput>
    end_op();
    800065f8:	ffffe097          	auipc	ra,0xffffe
    800065fc:	6ac080e7          	jalr	1708(ra) # 80004ca4 <end_op>
    return -1;
    80006600:	557d                	li	a0,-1
    80006602:	64aa                	ld	s1,136(sp)
    80006604:	bfc9                	j	800065d6 <sys_chdir+0x7c>

0000000080006606 <sys_exec>:

uint64
sys_exec(void)
{
    80006606:	7105                	addi	sp,sp,-480
    80006608:	ef86                	sd	ra,472(sp)
    8000660a:	eba2                	sd	s0,464(sp)
    8000660c:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000660e:	e2840593          	addi	a1,s0,-472
    80006612:	4505                	li	a0,1
    80006614:	ffffd097          	auipc	ra,0xffffd
    80006618:	e80080e7          	jalr	-384(ra) # 80003494 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000661c:	08000613          	li	a2,128
    80006620:	f3040593          	addi	a1,s0,-208
    80006624:	4501                	li	a0,0
    80006626:	ffffd097          	auipc	ra,0xffffd
    8000662a:	e8e080e7          	jalr	-370(ra) # 800034b4 <argstr>
    8000662e:	87aa                	mv	a5,a0
    return -1;
    80006630:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006632:	0e07ce63          	bltz	a5,8000672e <sys_exec+0x128>
    80006636:	e7a6                	sd	s1,456(sp)
    80006638:	e3ca                	sd	s2,448(sp)
    8000663a:	ff4e                	sd	s3,440(sp)
    8000663c:	fb52                	sd	s4,432(sp)
    8000663e:	f756                	sd	s5,424(sp)
    80006640:	f35a                	sd	s6,416(sp)
    80006642:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80006644:	e3040a13          	addi	s4,s0,-464
    80006648:	10000613          	li	a2,256
    8000664c:	4581                	li	a1,0
    8000664e:	8552                	mv	a0,s4
    80006650:	ffffa097          	auipc	ra,0xffffa
    80006654:	7be080e7          	jalr	1982(ra) # 80000e0e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006658:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000665a:	89d2                	mv	s3,s4
    8000665c:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000665e:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006662:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80006664:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006668:	00391513          	slli	a0,s2,0x3
    8000666c:	85d6                	mv	a1,s5
    8000666e:	e2843783          	ld	a5,-472(s0)
    80006672:	953e                	add	a0,a0,a5
    80006674:	ffffd097          	auipc	ra,0xffffd
    80006678:	d62080e7          	jalr	-670(ra) # 800033d6 <fetchaddr>
    8000667c:	02054a63          	bltz	a0,800066b0 <sys_exec+0xaa>
    if(uarg == 0){
    80006680:	e2043783          	ld	a5,-480(s0)
    80006684:	cbb1                	beqz	a5,800066d8 <sys_exec+0xd2>
    argv[i] = kalloc();
    80006686:	ffffa097          	auipc	ra,0xffffa
    8000668a:	57e080e7          	jalr	1406(ra) # 80000c04 <kalloc>
    8000668e:	85aa                	mv	a1,a0
    80006690:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006694:	cd11                	beqz	a0,800066b0 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006696:	865a                	mv	a2,s6
    80006698:	e2043503          	ld	a0,-480(s0)
    8000669c:	ffffd097          	auipc	ra,0xffffd
    800066a0:	d8c080e7          	jalr	-628(ra) # 80003428 <fetchstr>
    800066a4:	00054663          	bltz	a0,800066b0 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    800066a8:	0905                	addi	s2,s2,1
    800066aa:	09a1                	addi	s3,s3,8
    800066ac:	fb791ee3          	bne	s2,s7,80006668 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800066b0:	100a0a13          	addi	s4,s4,256
    800066b4:	6088                	ld	a0,0(s1)
    800066b6:	c525                	beqz	a0,8000671e <sys_exec+0x118>
    kfree(argv[i]);
    800066b8:	ffffa097          	auipc	ra,0xffffa
    800066bc:	3e4080e7          	jalr	996(ra) # 80000a9c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800066c0:	04a1                	addi	s1,s1,8
    800066c2:	ff4499e3          	bne	s1,s4,800066b4 <sys_exec+0xae>
  return -1;
    800066c6:	557d                	li	a0,-1
    800066c8:	64be                	ld	s1,456(sp)
    800066ca:	691e                	ld	s2,448(sp)
    800066cc:	79fa                	ld	s3,440(sp)
    800066ce:	7a5a                	ld	s4,432(sp)
    800066d0:	7aba                	ld	s5,424(sp)
    800066d2:	7b1a                	ld	s6,416(sp)
    800066d4:	6bfa                	ld	s7,408(sp)
    800066d6:	a8a1                	j	8000672e <sys_exec+0x128>
      argv[i] = 0;
    800066d8:	0009079b          	sext.w	a5,s2
    800066dc:	e3040593          	addi	a1,s0,-464
    800066e0:	078e                	slli	a5,a5,0x3
    800066e2:	97ae                	add	a5,a5,a1
    800066e4:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800066e8:	f3040513          	addi	a0,s0,-208
    800066ec:	fffff097          	auipc	ra,0xfffff
    800066f0:	118080e7          	jalr	280(ra) # 80005804 <exec>
    800066f4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800066f6:	100a0a13          	addi	s4,s4,256
    800066fa:	6088                	ld	a0,0(s1)
    800066fc:	c901                	beqz	a0,8000670c <sys_exec+0x106>
    kfree(argv[i]);
    800066fe:	ffffa097          	auipc	ra,0xffffa
    80006702:	39e080e7          	jalr	926(ra) # 80000a9c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006706:	04a1                	addi	s1,s1,8
    80006708:	ff4499e3          	bne	s1,s4,800066fa <sys_exec+0xf4>
  return ret;
    8000670c:	854a                	mv	a0,s2
    8000670e:	64be                	ld	s1,456(sp)
    80006710:	691e                	ld	s2,448(sp)
    80006712:	79fa                	ld	s3,440(sp)
    80006714:	7a5a                	ld	s4,432(sp)
    80006716:	7aba                	ld	s5,424(sp)
    80006718:	7b1a                	ld	s6,416(sp)
    8000671a:	6bfa                	ld	s7,408(sp)
    8000671c:	a809                	j	8000672e <sys_exec+0x128>
  return -1;
    8000671e:	557d                	li	a0,-1
    80006720:	64be                	ld	s1,456(sp)
    80006722:	691e                	ld	s2,448(sp)
    80006724:	79fa                	ld	s3,440(sp)
    80006726:	7a5a                	ld	s4,432(sp)
    80006728:	7aba                	ld	s5,424(sp)
    8000672a:	7b1a                	ld	s6,416(sp)
    8000672c:	6bfa                	ld	s7,408(sp)
}
    8000672e:	60fe                	ld	ra,472(sp)
    80006730:	645e                	ld	s0,464(sp)
    80006732:	613d                	addi	sp,sp,480
    80006734:	8082                	ret

0000000080006736 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006736:	7139                	addi	sp,sp,-64
    80006738:	fc06                	sd	ra,56(sp)
    8000673a:	f822                	sd	s0,48(sp)
    8000673c:	f426                	sd	s1,40(sp)
    8000673e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006740:	ffffb097          	auipc	ra,0xffffb
    80006744:	71a080e7          	jalr	1818(ra) # 80001e5a <myproc>
    80006748:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000674a:	fd840593          	addi	a1,s0,-40
    8000674e:	4501                	li	a0,0
    80006750:	ffffd097          	auipc	ra,0xffffd
    80006754:	d44080e7          	jalr	-700(ra) # 80003494 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006758:	fc840593          	addi	a1,s0,-56
    8000675c:	fd040513          	addi	a0,s0,-48
    80006760:	fffff097          	auipc	ra,0xfffff
    80006764:	d0e080e7          	jalr	-754(ra) # 8000546e <pipealloc>
    return -1;
    80006768:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000676a:	0c054463          	bltz	a0,80006832 <sys_pipe+0xfc>
  fd0 = -1;
    8000676e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006772:	fd043503          	ld	a0,-48(s0)
    80006776:	fffff097          	auipc	ra,0xfffff
    8000677a:	4b6080e7          	jalr	1206(ra) # 80005c2c <fdalloc>
    8000677e:	fca42223          	sw	a0,-60(s0)
    80006782:	08054b63          	bltz	a0,80006818 <sys_pipe+0xe2>
    80006786:	fc843503          	ld	a0,-56(s0)
    8000678a:	fffff097          	auipc	ra,0xfffff
    8000678e:	4a2080e7          	jalr	1186(ra) # 80005c2c <fdalloc>
    80006792:	fca42023          	sw	a0,-64(s0)
    80006796:	06054863          	bltz	a0,80006806 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000679a:	4691                	li	a3,4
    8000679c:	fc440613          	addi	a2,s0,-60
    800067a0:	fd843583          	ld	a1,-40(s0)
    800067a4:	68a8                	ld	a0,80(s1)
    800067a6:	ffffb097          	auipc	ra,0xffffb
    800067aa:	35c080e7          	jalr	860(ra) # 80001b02 <copyout>
    800067ae:	02054063          	bltz	a0,800067ce <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800067b2:	4691                	li	a3,4
    800067b4:	fc040613          	addi	a2,s0,-64
    800067b8:	fd843583          	ld	a1,-40(s0)
    800067bc:	95b6                	add	a1,a1,a3
    800067be:	68a8                	ld	a0,80(s1)
    800067c0:	ffffb097          	auipc	ra,0xffffb
    800067c4:	342080e7          	jalr	834(ra) # 80001b02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800067c8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800067ca:	06055463          	bgez	a0,80006832 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800067ce:	fc442783          	lw	a5,-60(s0)
    800067d2:	07e9                	addi	a5,a5,26
    800067d4:	078e                	slli	a5,a5,0x3
    800067d6:	97a6                	add	a5,a5,s1
    800067d8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800067dc:	fc042783          	lw	a5,-64(s0)
    800067e0:	07e9                	addi	a5,a5,26
    800067e2:	078e                	slli	a5,a5,0x3
    800067e4:	94be                	add	s1,s1,a5
    800067e6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800067ea:	fd043503          	ld	a0,-48(s0)
    800067ee:	fffff097          	auipc	ra,0xfffff
    800067f2:	90c080e7          	jalr	-1780(ra) # 800050fa <fileclose>
    fileclose(wf);
    800067f6:	fc843503          	ld	a0,-56(s0)
    800067fa:	fffff097          	auipc	ra,0xfffff
    800067fe:	900080e7          	jalr	-1792(ra) # 800050fa <fileclose>
    return -1;
    80006802:	57fd                	li	a5,-1
    80006804:	a03d                	j	80006832 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006806:	fc442783          	lw	a5,-60(s0)
    8000680a:	0007c763          	bltz	a5,80006818 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000680e:	07e9                	addi	a5,a5,26
    80006810:	078e                	slli	a5,a5,0x3
    80006812:	97a6                	add	a5,a5,s1
    80006814:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006818:	fd043503          	ld	a0,-48(s0)
    8000681c:	fffff097          	auipc	ra,0xfffff
    80006820:	8de080e7          	jalr	-1826(ra) # 800050fa <fileclose>
    fileclose(wf);
    80006824:	fc843503          	ld	a0,-56(s0)
    80006828:	fffff097          	auipc	ra,0xfffff
    8000682c:	8d2080e7          	jalr	-1838(ra) # 800050fa <fileclose>
    return -1;
    80006830:	57fd                	li	a5,-1
}
    80006832:	853e                	mv	a0,a5
    80006834:	70e2                	ld	ra,56(sp)
    80006836:	7442                	ld	s0,48(sp)
    80006838:	74a2                	ld	s1,40(sp)
    8000683a:	6121                	addi	sp,sp,64
    8000683c:	8082                	ret
	...

0000000080006840 <kernelvec>:
    80006840:	7111                	addi	sp,sp,-256
    80006842:	e006                	sd	ra,0(sp)
    80006844:	e40a                	sd	sp,8(sp)
    80006846:	e80e                	sd	gp,16(sp)
    80006848:	ec12                	sd	tp,24(sp)
    8000684a:	f016                	sd	t0,32(sp)
    8000684c:	f41a                	sd	t1,40(sp)
    8000684e:	f81e                	sd	t2,48(sp)
    80006850:	fc22                	sd	s0,56(sp)
    80006852:	e0a6                	sd	s1,64(sp)
    80006854:	e4aa                	sd	a0,72(sp)
    80006856:	e8ae                	sd	a1,80(sp)
    80006858:	ecb2                	sd	a2,88(sp)
    8000685a:	f0b6                	sd	a3,96(sp)
    8000685c:	f4ba                	sd	a4,104(sp)
    8000685e:	f8be                	sd	a5,112(sp)
    80006860:	fcc2                	sd	a6,120(sp)
    80006862:	e146                	sd	a7,128(sp)
    80006864:	e54a                	sd	s2,136(sp)
    80006866:	e94e                	sd	s3,144(sp)
    80006868:	ed52                	sd	s4,152(sp)
    8000686a:	f156                	sd	s5,160(sp)
    8000686c:	f55a                	sd	s6,168(sp)
    8000686e:	f95e                	sd	s7,176(sp)
    80006870:	fd62                	sd	s8,184(sp)
    80006872:	e1e6                	sd	s9,192(sp)
    80006874:	e5ea                	sd	s10,200(sp)
    80006876:	e9ee                	sd	s11,208(sp)
    80006878:	edf2                	sd	t3,216(sp)
    8000687a:	f1f6                	sd	t4,224(sp)
    8000687c:	f5fa                	sd	t5,232(sp)
    8000687e:	f9fe                	sd	t6,240(sp)
    80006880:	a23fc0ef          	jal	800032a2 <kerneltrap>
    80006884:	6082                	ld	ra,0(sp)
    80006886:	6122                	ld	sp,8(sp)
    80006888:	61c2                	ld	gp,16(sp)
    8000688a:	7282                	ld	t0,32(sp)
    8000688c:	7322                	ld	t1,40(sp)
    8000688e:	73c2                	ld	t2,48(sp)
    80006890:	7462                	ld	s0,56(sp)
    80006892:	6486                	ld	s1,64(sp)
    80006894:	6526                	ld	a0,72(sp)
    80006896:	65c6                	ld	a1,80(sp)
    80006898:	6666                	ld	a2,88(sp)
    8000689a:	7686                	ld	a3,96(sp)
    8000689c:	7726                	ld	a4,104(sp)
    8000689e:	77c6                	ld	a5,112(sp)
    800068a0:	7866                	ld	a6,120(sp)
    800068a2:	688a                	ld	a7,128(sp)
    800068a4:	692a                	ld	s2,136(sp)
    800068a6:	69ca                	ld	s3,144(sp)
    800068a8:	6a6a                	ld	s4,152(sp)
    800068aa:	7a8a                	ld	s5,160(sp)
    800068ac:	7b2a                	ld	s6,168(sp)
    800068ae:	7bca                	ld	s7,176(sp)
    800068b0:	7c6a                	ld	s8,184(sp)
    800068b2:	6c8e                	ld	s9,192(sp)
    800068b4:	6d2e                	ld	s10,200(sp)
    800068b6:	6dce                	ld	s11,208(sp)
    800068b8:	6e6e                	ld	t3,216(sp)
    800068ba:	7e8e                	ld	t4,224(sp)
    800068bc:	7f2e                	ld	t5,232(sp)
    800068be:	7fce                	ld	t6,240(sp)
    800068c0:	6111                	addi	sp,sp,256
    800068c2:	10200073          	sret
    800068c6:	00000013          	nop
    800068ca:	00000013          	nop
    800068ce:	0001                	nop

00000000800068d0 <timervec>:
    800068d0:	34051573          	csrrw	a0,mscratch,a0
    800068d4:	e10c                	sd	a1,0(a0)
    800068d6:	e510                	sd	a2,8(a0)
    800068d8:	e914                	sd	a3,16(a0)
    800068da:	6d0c                	ld	a1,24(a0)
    800068dc:	7110                	ld	a2,32(a0)
    800068de:	6194                	ld	a3,0(a1)
    800068e0:	96b2                	add	a3,a3,a2
    800068e2:	e194                	sd	a3,0(a1)
    800068e4:	4589                	li	a1,2
    800068e6:	14459073          	csrw	sip,a1
    800068ea:	6914                	ld	a3,16(a0)
    800068ec:	6510                	ld	a2,8(a0)
    800068ee:	610c                	ld	a1,0(a0)
    800068f0:	34051573          	csrrw	a0,mscratch,a0
    800068f4:	30200073          	mret
	...

00000000800068fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800068fa:	1141                	addi	sp,sp,-16
    800068fc:	e406                	sd	ra,8(sp)
    800068fe:	e022                	sd	s0,0(sp)
    80006900:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006902:	0c000737          	lui	a4,0xc000
    80006906:	4785                	li	a5,1
    80006908:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000690a:	c35c                	sw	a5,4(a4)
  *(uint32*)(PLIC + VIRTIO1_IRQ*4) = 1;
    8000690c:	c71c                	sw	a5,8(a4)
}
    8000690e:	60a2                	ld	ra,8(sp)
    80006910:	6402                	ld	s0,0(sp)
    80006912:	0141                	addi	sp,sp,16
    80006914:	8082                	ret

0000000080006916 <plicinithart>:

void
plicinithart(void)
{
    80006916:	1141                	addi	sp,sp,-16
    80006918:	e406                	sd	ra,8(sp)
    8000691a:	e022                	sd	s0,0(sp)
    8000691c:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000691e:	ffffb097          	auipc	ra,0xffffb
    80006922:	508080e7          	jalr	1288(ra) # 80001e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ) | (1 << VIRTIO1_IRQ);
    80006926:	0085171b          	slliw	a4,a0,0x8
    8000692a:	0c0027b7          	lui	a5,0xc002
    8000692e:	97ba                	add	a5,a5,a4
    80006930:	40600713          	li	a4,1030
    80006934:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006938:	00d5151b          	slliw	a0,a0,0xd
    8000693c:	0c2017b7          	lui	a5,0xc201
    80006940:	97aa                	add	a5,a5,a0
    80006942:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006946:	60a2                	ld	ra,8(sp)
    80006948:	6402                	ld	s0,0(sp)
    8000694a:	0141                	addi	sp,sp,16
    8000694c:	8082                	ret

000000008000694e <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000694e:	1141                	addi	sp,sp,-16
    80006950:	e406                	sd	ra,8(sp)
    80006952:	e022                	sd	s0,0(sp)
    80006954:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006956:	ffffb097          	auipc	ra,0xffffb
    8000695a:	4d0080e7          	jalr	1232(ra) # 80001e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000695e:	00d5151b          	slliw	a0,a0,0xd
    80006962:	0c2017b7          	lui	a5,0xc201
    80006966:	97aa                	add	a5,a5,a0
  return irq;
}
    80006968:	43c8                	lw	a0,4(a5)
    8000696a:	60a2                	ld	ra,8(sp)
    8000696c:	6402                	ld	s0,0(sp)
    8000696e:	0141                	addi	sp,sp,16
    80006970:	8082                	ret

0000000080006972 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006972:	1101                	addi	sp,sp,-32
    80006974:	ec06                	sd	ra,24(sp)
    80006976:	e822                	sd	s0,16(sp)
    80006978:	e426                	sd	s1,8(sp)
    8000697a:	1000                	addi	s0,sp,32
    8000697c:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000697e:	ffffb097          	auipc	ra,0xffffb
    80006982:	4a8080e7          	jalr	1192(ra) # 80001e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006986:	00d5179b          	slliw	a5,a0,0xd
    8000698a:	0c201737          	lui	a4,0xc201
    8000698e:	97ba                	add	a5,a5,a4
    80006990:	c3c4                	sw	s1,4(a5)
}
    80006992:	60e2                	ld	ra,24(sp)
    80006994:	6442                	ld	s0,16(sp)
    80006996:	64a2                	ld	s1,8(sp)
    80006998:	6105                	addi	sp,sp,32
    8000699a:	8082                	ret

000000008000699c <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000699c:	1141                	addi	sp,sp,-16
    8000699e:	e406                	sd	ra,8(sp)
    800069a0:	e022                	sd	s0,0(sp)
    800069a2:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800069a4:	479d                	li	a5,7
    800069a6:	04a7cc63          	blt	a5,a0,800069fe <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800069aa:	00069797          	auipc	a5,0x69
    800069ae:	e9678793          	addi	a5,a5,-362 # 8006f840 <disk>
    800069b2:	97aa                	add	a5,a5,a0
    800069b4:	0187c783          	lbu	a5,24(a5)
    800069b8:	ebb9                	bnez	a5,80006a0e <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800069ba:	00451693          	slli	a3,a0,0x4
    800069be:	00069797          	auipc	a5,0x69
    800069c2:	e8278793          	addi	a5,a5,-382 # 8006f840 <disk>
    800069c6:	6398                	ld	a4,0(a5)
    800069c8:	9736                	add	a4,a4,a3
    800069ca:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800069ce:	6398                	ld	a4,0(a5)
    800069d0:	9736                	add	a4,a4,a3
    800069d2:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800069d6:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800069da:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800069de:	97aa                	add	a5,a5,a0
    800069e0:	4705                	li	a4,1
    800069e2:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800069e6:	00069517          	auipc	a0,0x69
    800069ea:	e7250513          	addi	a0,a0,-398 # 8006f858 <disk+0x18>
    800069ee:	ffffc097          	auipc	ra,0xffffc
    800069f2:	d7e080e7          	jalr	-642(ra) # 8000276c <wakeup>
}
    800069f6:	60a2                	ld	ra,8(sp)
    800069f8:	6402                	ld	s0,0(sp)
    800069fa:	0141                	addi	sp,sp,16
    800069fc:	8082                	ret
    panic("free_desc 1");
    800069fe:	00004517          	auipc	a0,0x4
    80006a02:	cba50513          	addi	a0,a0,-838 # 8000a6b8 <etext+0x6b8>
    80006a06:	ffffa097          	auipc	ra,0xffffa
    80006a0a:	b5a080e7          	jalr	-1190(ra) # 80000560 <panic>
    panic("free_desc 2");
    80006a0e:	00004517          	auipc	a0,0x4
    80006a12:	cba50513          	addi	a0,a0,-838 # 8000a6c8 <etext+0x6c8>
    80006a16:	ffffa097          	auipc	ra,0xffffa
    80006a1a:	b4a080e7          	jalr	-1206(ra) # 80000560 <panic>

0000000080006a1e <virtio_disk_init>:
{
    80006a1e:	1101                	addi	sp,sp,-32
    80006a20:	ec06                	sd	ra,24(sp)
    80006a22:	e822                	sd	s0,16(sp)
    80006a24:	e426                	sd	s1,8(sp)
    80006a26:	e04a                	sd	s2,0(sp)
    80006a28:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006a2a:	00004597          	auipc	a1,0x4
    80006a2e:	cae58593          	addi	a1,a1,-850 # 8000a6d8 <etext+0x6d8>
    80006a32:	00069517          	auipc	a0,0x69
    80006a36:	f3650513          	addi	a0,a0,-202 # 8006f968 <disk+0x128>
    80006a3a:	ffffa097          	auipc	ra,0xffffa
    80006a3e:	248080e7          	jalr	584(ra) # 80000c82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006a42:	100017b7          	lui	a5,0x10001
    80006a46:	4398                	lw	a4,0(a5)
    80006a48:	2701                	sext.w	a4,a4
    80006a4a:	747277b7          	lui	a5,0x74727
    80006a4e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006a52:	16f71463          	bne	a4,a5,80006bba <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006a56:	100017b7          	lui	a5,0x10001
    80006a5a:	43dc                	lw	a5,4(a5)
    80006a5c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006a5e:	4709                	li	a4,2
    80006a60:	14e79d63          	bne	a5,a4,80006bba <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006a64:	100017b7          	lui	a5,0x10001
    80006a68:	479c                	lw	a5,8(a5)
    80006a6a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006a6c:	14e79763          	bne	a5,a4,80006bba <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006a70:	100017b7          	lui	a5,0x10001
    80006a74:	47d8                	lw	a4,12(a5)
    80006a76:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006a78:	554d47b7          	lui	a5,0x554d4
    80006a7c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006a80:	12f71d63          	bne	a4,a5,80006bba <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006a84:	100017b7          	lui	a5,0x10001
    80006a88:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006a8c:	4705                	li	a4,1
    80006a8e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006a90:	470d                	li	a4,3
    80006a92:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006a94:	10001737          	lui	a4,0x10001
    80006a98:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006a9a:	c7ffe6b7          	lui	a3,0xc7ffe
    80006a9e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f8dd53>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006aa2:	8f75                	and	a4,a4,a3
    80006aa4:	100016b7          	lui	a3,0x10001
    80006aa8:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006aaa:	472d                	li	a4,11
    80006aac:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006aae:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006ab2:	439c                	lw	a5,0(a5)
    80006ab4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006ab8:	8ba1                	andi	a5,a5,8
    80006aba:	10078863          	beqz	a5,80006bca <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006abe:	100017b7          	lui	a5,0x10001
    80006ac2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006ac6:	43fc                	lw	a5,68(a5)
    80006ac8:	2781                	sext.w	a5,a5
    80006aca:	10079863          	bnez	a5,80006bda <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006ace:	100017b7          	lui	a5,0x10001
    80006ad2:	5bdc                	lw	a5,52(a5)
    80006ad4:	2781                	sext.w	a5,a5
  if(max == 0)
    80006ad6:	10078a63          	beqz	a5,80006bea <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006ada:	471d                	li	a4,7
    80006adc:	10f77f63          	bgeu	a4,a5,80006bfa <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    80006ae0:	ffffa097          	auipc	ra,0xffffa
    80006ae4:	124080e7          	jalr	292(ra) # 80000c04 <kalloc>
    80006ae8:	00069497          	auipc	s1,0x69
    80006aec:	d5848493          	addi	s1,s1,-680 # 8006f840 <disk>
    80006af0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006af2:	ffffa097          	auipc	ra,0xffffa
    80006af6:	112080e7          	jalr	274(ra) # 80000c04 <kalloc>
    80006afa:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006afc:	ffffa097          	auipc	ra,0xffffa
    80006b00:	108080e7          	jalr	264(ra) # 80000c04 <kalloc>
    80006b04:	87aa                	mv	a5,a0
    80006b06:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006b08:	6088                	ld	a0,0(s1)
    80006b0a:	10050063          	beqz	a0,80006c0a <virtio_disk_init+0x1ec>
    80006b0e:	00069717          	auipc	a4,0x69
    80006b12:	d3a73703          	ld	a4,-710(a4) # 8006f848 <disk+0x8>
    80006b16:	cb75                	beqz	a4,80006c0a <virtio_disk_init+0x1ec>
    80006b18:	cbed                	beqz	a5,80006c0a <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006b1a:	6605                	lui	a2,0x1
    80006b1c:	4581                	li	a1,0
    80006b1e:	ffffa097          	auipc	ra,0xffffa
    80006b22:	2f0080e7          	jalr	752(ra) # 80000e0e <memset>
  memset(disk.avail, 0, PGSIZE);
    80006b26:	00069497          	auipc	s1,0x69
    80006b2a:	d1a48493          	addi	s1,s1,-742 # 8006f840 <disk>
    80006b2e:	6605                	lui	a2,0x1
    80006b30:	4581                	li	a1,0
    80006b32:	6488                	ld	a0,8(s1)
    80006b34:	ffffa097          	auipc	ra,0xffffa
    80006b38:	2da080e7          	jalr	730(ra) # 80000e0e <memset>
  memset(disk.used, 0, PGSIZE);
    80006b3c:	6605                	lui	a2,0x1
    80006b3e:	4581                	li	a1,0
    80006b40:	6888                	ld	a0,16(s1)
    80006b42:	ffffa097          	auipc	ra,0xffffa
    80006b46:	2cc080e7          	jalr	716(ra) # 80000e0e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006b4a:	100017b7          	lui	a5,0x10001
    80006b4e:	4721                	li	a4,8
    80006b50:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006b52:	4098                	lw	a4,0(s1)
    80006b54:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006b58:	40d8                	lw	a4,4(s1)
    80006b5a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006b5e:	649c                	ld	a5,8(s1)
    80006b60:	0007869b          	sext.w	a3,a5
    80006b64:	10001737          	lui	a4,0x10001
    80006b68:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006b6c:	9781                	srai	a5,a5,0x20
    80006b6e:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006b72:	689c                	ld	a5,16(s1)
    80006b74:	0007869b          	sext.w	a3,a5
    80006b78:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006b7c:	9781                	srai	a5,a5,0x20
    80006b7e:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006b82:	4785                	li	a5,1
    80006b84:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006b86:	00f48c23          	sb	a5,24(s1)
    80006b8a:	00f48ca3          	sb	a5,25(s1)
    80006b8e:	00f48d23          	sb	a5,26(s1)
    80006b92:	00f48da3          	sb	a5,27(s1)
    80006b96:	00f48e23          	sb	a5,28(s1)
    80006b9a:	00f48ea3          	sb	a5,29(s1)
    80006b9e:	00f48f23          	sb	a5,30(s1)
    80006ba2:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006ba6:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006baa:	07272823          	sw	s2,112(a4)
}
    80006bae:	60e2                	ld	ra,24(sp)
    80006bb0:	6442                	ld	s0,16(sp)
    80006bb2:	64a2                	ld	s1,8(sp)
    80006bb4:	6902                	ld	s2,0(sp)
    80006bb6:	6105                	addi	sp,sp,32
    80006bb8:	8082                	ret
    panic("could not find virtio disk");
    80006bba:	00004517          	auipc	a0,0x4
    80006bbe:	b2e50513          	addi	a0,a0,-1234 # 8000a6e8 <etext+0x6e8>
    80006bc2:	ffffa097          	auipc	ra,0xffffa
    80006bc6:	99e080e7          	jalr	-1634(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006bca:	00004517          	auipc	a0,0x4
    80006bce:	b3e50513          	addi	a0,a0,-1218 # 8000a708 <etext+0x708>
    80006bd2:	ffffa097          	auipc	ra,0xffffa
    80006bd6:	98e080e7          	jalr	-1650(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006bda:	00004517          	auipc	a0,0x4
    80006bde:	b4e50513          	addi	a0,a0,-1202 # 8000a728 <etext+0x728>
    80006be2:	ffffa097          	auipc	ra,0xffffa
    80006be6:	97e080e7          	jalr	-1666(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006bea:	00004517          	auipc	a0,0x4
    80006bee:	b5e50513          	addi	a0,a0,-1186 # 8000a748 <etext+0x748>
    80006bf2:	ffffa097          	auipc	ra,0xffffa
    80006bf6:	96e080e7          	jalr	-1682(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006bfa:	00004517          	auipc	a0,0x4
    80006bfe:	b6e50513          	addi	a0,a0,-1170 # 8000a768 <etext+0x768>
    80006c02:	ffffa097          	auipc	ra,0xffffa
    80006c06:	95e080e7          	jalr	-1698(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006c0a:	00004517          	auipc	a0,0x4
    80006c0e:	b7e50513          	addi	a0,a0,-1154 # 8000a788 <etext+0x788>
    80006c12:	ffffa097          	auipc	ra,0xffffa
    80006c16:	94e080e7          	jalr	-1714(ra) # 80000560 <panic>

0000000080006c1a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006c1a:	711d                	addi	sp,sp,-96
    80006c1c:	ec86                	sd	ra,88(sp)
    80006c1e:	e8a2                	sd	s0,80(sp)
    80006c20:	e4a6                	sd	s1,72(sp)
    80006c22:	e0ca                	sd	s2,64(sp)
    80006c24:	fc4e                	sd	s3,56(sp)
    80006c26:	f852                	sd	s4,48(sp)
    80006c28:	f456                	sd	s5,40(sp)
    80006c2a:	f05a                	sd	s6,32(sp)
    80006c2c:	ec5e                	sd	s7,24(sp)
    80006c2e:	e862                	sd	s8,16(sp)
    80006c30:	1080                	addi	s0,sp,96
    80006c32:	89aa                	mv	s3,a0
    80006c34:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006c36:	00c52b83          	lw	s7,12(a0)
    80006c3a:	001b9b9b          	slliw	s7,s7,0x1
    80006c3e:	1b82                	slli	s7,s7,0x20
    80006c40:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006c44:	00069517          	auipc	a0,0x69
    80006c48:	d2450513          	addi	a0,a0,-732 # 8006f968 <disk+0x128>
    80006c4c:	ffffa097          	auipc	ra,0xffffa
    80006c50:	0ca080e7          	jalr	202(ra) # 80000d16 <acquire>
  for(int i = 0; i < NUM; i++){
    80006c54:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006c56:	00069a97          	auipc	s5,0x69
    80006c5a:	beaa8a93          	addi	s5,s5,-1046 # 8006f840 <disk>
  for(int i = 0; i < 3; i++){
    80006c5e:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006c60:	5c7d                	li	s8,-1
    80006c62:	a885                	j	80006cd2 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006c64:	00fa8733          	add	a4,s5,a5
    80006c68:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006c6c:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006c6e:	0207c563          	bltz	a5,80006c98 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006c72:	2905                	addiw	s2,s2,1
    80006c74:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006c76:	07490263          	beq	s2,s4,80006cda <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006c7a:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006c7c:	00069717          	auipc	a4,0x69
    80006c80:	bc470713          	addi	a4,a4,-1084 # 8006f840 <disk>
    80006c84:	4781                	li	a5,0
    if(disk.free[i]){
    80006c86:	01874683          	lbu	a3,24(a4)
    80006c8a:	fee9                	bnez	a3,80006c64 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80006c8c:	2785                	addiw	a5,a5,1
    80006c8e:	0705                	addi	a4,a4,1
    80006c90:	fe979be3          	bne	a5,s1,80006c86 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006c94:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006c98:	03205163          	blez	s2,80006cba <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006c9c:	fa042503          	lw	a0,-96(s0)
    80006ca0:	00000097          	auipc	ra,0x0
    80006ca4:	cfc080e7          	jalr	-772(ra) # 8000699c <free_desc>
      for(int j = 0; j < i; j++)
    80006ca8:	4785                	li	a5,1
    80006caa:	0127d863          	bge	a5,s2,80006cba <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006cae:	fa442503          	lw	a0,-92(s0)
    80006cb2:	00000097          	auipc	ra,0x0
    80006cb6:	cea080e7          	jalr	-790(ra) # 8000699c <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006cba:	00069597          	auipc	a1,0x69
    80006cbe:	cae58593          	addi	a1,a1,-850 # 8006f968 <disk+0x128>
    80006cc2:	00069517          	auipc	a0,0x69
    80006cc6:	b9650513          	addi	a0,a0,-1130 # 8006f858 <disk+0x18>
    80006cca:	ffffc097          	auipc	ra,0xffffc
    80006cce:	a3e080e7          	jalr	-1474(ra) # 80002708 <sleep>
  for(int i = 0; i < 3; i++){
    80006cd2:	fa040613          	addi	a2,s0,-96
    80006cd6:	4901                	li	s2,0
    80006cd8:	b74d                	j	80006c7a <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006cda:	fa042503          	lw	a0,-96(s0)
    80006cde:	00451693          	slli	a3,a0,0x4

  if(write)
    80006ce2:	00069797          	auipc	a5,0x69
    80006ce6:	b5e78793          	addi	a5,a5,-1186 # 8006f840 <disk>
    80006cea:	00a50713          	addi	a4,a0,10
    80006cee:	0712                	slli	a4,a4,0x4
    80006cf0:	973e                	add	a4,a4,a5
    80006cf2:	01603633          	snez	a2,s6
    80006cf6:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006cf8:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006cfc:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006d00:	6398                	ld	a4,0(a5)
    80006d02:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006d04:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006d08:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006d0a:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006d0c:	6390                	ld	a2,0(a5)
    80006d0e:	00d605b3          	add	a1,a2,a3
    80006d12:	4741                	li	a4,16
    80006d14:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006d16:	4805                	li	a6,1
    80006d18:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80006d1c:	fa442703          	lw	a4,-92(s0)
    80006d20:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006d24:	0712                	slli	a4,a4,0x4
    80006d26:	963a                	add	a2,a2,a4
    80006d28:	05898593          	addi	a1,s3,88
    80006d2c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006d2e:	0007b883          	ld	a7,0(a5)
    80006d32:	9746                	add	a4,a4,a7
    80006d34:	40000613          	li	a2,1024
    80006d38:	c710                	sw	a2,8(a4)
  if(write)
    80006d3a:	001b3613          	seqz	a2,s6
    80006d3e:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006d42:	01066633          	or	a2,a2,a6
    80006d46:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006d4a:	fa842583          	lw	a1,-88(s0)
    80006d4e:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006d52:	00250613          	addi	a2,a0,2
    80006d56:	0612                	slli	a2,a2,0x4
    80006d58:	963e                	add	a2,a2,a5
    80006d5a:	577d                	li	a4,-1
    80006d5c:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006d60:	0592                	slli	a1,a1,0x4
    80006d62:	98ae                	add	a7,a7,a1
    80006d64:	03068713          	addi	a4,a3,48
    80006d68:	973e                	add	a4,a4,a5
    80006d6a:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006d6e:	6398                	ld	a4,0(a5)
    80006d70:	972e                	add	a4,a4,a1
    80006d72:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006d76:	4689                	li	a3,2
    80006d78:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006d7c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006d80:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80006d84:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006d88:	6794                	ld	a3,8(a5)
    80006d8a:	0026d703          	lhu	a4,2(a3)
    80006d8e:	8b1d                	andi	a4,a4,7
    80006d90:	0706                	slli	a4,a4,0x1
    80006d92:	96ba                	add	a3,a3,a4
    80006d94:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006d98:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006d9c:	6798                	ld	a4,8(a5)
    80006d9e:	00275783          	lhu	a5,2(a4)
    80006da2:	2785                	addiw	a5,a5,1
    80006da4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006da8:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006dac:	100017b7          	lui	a5,0x10001
    80006db0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006db4:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006db8:	00069917          	auipc	s2,0x69
    80006dbc:	bb090913          	addi	s2,s2,-1104 # 8006f968 <disk+0x128>
  while(b->disk == 1) {
    80006dc0:	84c2                	mv	s1,a6
    80006dc2:	01079c63          	bne	a5,a6,80006dda <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    80006dc6:	85ca                	mv	a1,s2
    80006dc8:	854e                	mv	a0,s3
    80006dca:	ffffc097          	auipc	ra,0xffffc
    80006dce:	93e080e7          	jalr	-1730(ra) # 80002708 <sleep>
  while(b->disk == 1) {
    80006dd2:	0049a783          	lw	a5,4(s3)
    80006dd6:	fe9788e3          	beq	a5,s1,80006dc6 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    80006dda:	fa042903          	lw	s2,-96(s0)
    80006dde:	00290713          	addi	a4,s2,2
    80006de2:	0712                	slli	a4,a4,0x4
    80006de4:	00069797          	auipc	a5,0x69
    80006de8:	a5c78793          	addi	a5,a5,-1444 # 8006f840 <disk>
    80006dec:	97ba                	add	a5,a5,a4
    80006dee:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006df2:	00069997          	auipc	s3,0x69
    80006df6:	a4e98993          	addi	s3,s3,-1458 # 8006f840 <disk>
    80006dfa:	00491713          	slli	a4,s2,0x4
    80006dfe:	0009b783          	ld	a5,0(s3)
    80006e02:	97ba                	add	a5,a5,a4
    80006e04:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006e08:	854a                	mv	a0,s2
    80006e0a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006e0e:	00000097          	auipc	ra,0x0
    80006e12:	b8e080e7          	jalr	-1138(ra) # 8000699c <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006e16:	8885                	andi	s1,s1,1
    80006e18:	f0ed                	bnez	s1,80006dfa <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006e1a:	00069517          	auipc	a0,0x69
    80006e1e:	b4e50513          	addi	a0,a0,-1202 # 8006f968 <disk+0x128>
    80006e22:	ffffa097          	auipc	ra,0xffffa
    80006e26:	fa4080e7          	jalr	-92(ra) # 80000dc6 <release>
}
    80006e2a:	60e6                	ld	ra,88(sp)
    80006e2c:	6446                	ld	s0,80(sp)
    80006e2e:	64a6                	ld	s1,72(sp)
    80006e30:	6906                	ld	s2,64(sp)
    80006e32:	79e2                	ld	s3,56(sp)
    80006e34:	7a42                	ld	s4,48(sp)
    80006e36:	7aa2                	ld	s5,40(sp)
    80006e38:	7b02                	ld	s6,32(sp)
    80006e3a:	6be2                	ld	s7,24(sp)
    80006e3c:	6c42                	ld	s8,16(sp)
    80006e3e:	6125                	addi	sp,sp,96
    80006e40:	8082                	ret

0000000080006e42 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006e42:	1101                	addi	sp,sp,-32
    80006e44:	ec06                	sd	ra,24(sp)
    80006e46:	e822                	sd	s0,16(sp)
    80006e48:	e426                	sd	s1,8(sp)
    80006e4a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006e4c:	00069497          	auipc	s1,0x69
    80006e50:	9f448493          	addi	s1,s1,-1548 # 8006f840 <disk>
    80006e54:	00069517          	auipc	a0,0x69
    80006e58:	b1450513          	addi	a0,a0,-1260 # 8006f968 <disk+0x128>
    80006e5c:	ffffa097          	auipc	ra,0xffffa
    80006e60:	eba080e7          	jalr	-326(ra) # 80000d16 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006e64:	100017b7          	lui	a5,0x10001
    80006e68:	53bc                	lw	a5,96(a5)
    80006e6a:	8b8d                	andi	a5,a5,3
    80006e6c:	10001737          	lui	a4,0x10001
    80006e70:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006e72:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006e76:	689c                	ld	a5,16(s1)
    80006e78:	0204d703          	lhu	a4,32(s1)
    80006e7c:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006e80:	04f70863          	beq	a4,a5,80006ed0 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006e84:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006e88:	6898                	ld	a4,16(s1)
    80006e8a:	0204d783          	lhu	a5,32(s1)
    80006e8e:	8b9d                	andi	a5,a5,7
    80006e90:	078e                	slli	a5,a5,0x3
    80006e92:	97ba                	add	a5,a5,a4
    80006e94:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006e96:	00278713          	addi	a4,a5,2
    80006e9a:	0712                	slli	a4,a4,0x4
    80006e9c:	9726                	add	a4,a4,s1
    80006e9e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006ea2:	e721                	bnez	a4,80006eea <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006ea4:	0789                	addi	a5,a5,2
    80006ea6:	0792                	slli	a5,a5,0x4
    80006ea8:	97a6                	add	a5,a5,s1
    80006eaa:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006eac:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006eb0:	ffffc097          	auipc	ra,0xffffc
    80006eb4:	8bc080e7          	jalr	-1860(ra) # 8000276c <wakeup>

    disk.used_idx += 1;
    80006eb8:	0204d783          	lhu	a5,32(s1)
    80006ebc:	2785                	addiw	a5,a5,1
    80006ebe:	17c2                	slli	a5,a5,0x30
    80006ec0:	93c1                	srli	a5,a5,0x30
    80006ec2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006ec6:	6898                	ld	a4,16(s1)
    80006ec8:	00275703          	lhu	a4,2(a4)
    80006ecc:	faf71ce3          	bne	a4,a5,80006e84 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006ed0:	00069517          	auipc	a0,0x69
    80006ed4:	a9850513          	addi	a0,a0,-1384 # 8006f968 <disk+0x128>
    80006ed8:	ffffa097          	auipc	ra,0xffffa
    80006edc:	eee080e7          	jalr	-274(ra) # 80000dc6 <release>
}
    80006ee0:	60e2                	ld	ra,24(sp)
    80006ee2:	6442                	ld	s0,16(sp)
    80006ee4:	64a2                	ld	s1,8(sp)
    80006ee6:	6105                	addi	sp,sp,32
    80006ee8:	8082                	ret
      panic("virtio_disk_intr status");
    80006eea:	00004517          	auipc	a0,0x4
    80006eee:	8b650513          	addi	a0,a0,-1866 # 8000a7a0 <etext+0x7a0>
    80006ef2:	ffff9097          	auipc	ra,0xffff9
    80006ef6:	66e080e7          	jalr	1646(ra) # 80000560 <panic>

0000000080006efa <alloc_desc>:
 *
 * Output: returns the index of the descriptor on success
 *         returns -1 if there are no free descriptors
 *
 */
int alloc_desc(struct virtq *q) {
    80006efa:	1141                	addi	sp,sp,-16
    80006efc:	e406                	sd	ra,8(sp)
    80006efe:	e022                	sd	s0,0(sp)
    80006f00:	0800                	addi	s0,sp,16
    80006f02:	862a                	mv	a2,a0
  for (int i = 0; i < NUM; i++) {
    80006f04:	01c50793          	addi	a5,a0,28
    80006f08:	4501                	li	a0,0
    80006f0a:	46a1                	li	a3,8
    if (q->free[i]) {
    80006f0c:	0007c703          	lbu	a4,0(a5)
    80006f10:	eb11                	bnez	a4,80006f24 <alloc_desc+0x2a>
  for (int i = 0; i < NUM; i++) {
    80006f12:	2505                	addiw	a0,a0,1
    80006f14:	0785                	addi	a5,a5,1
    80006f16:	fed51be3          	bne	a0,a3,80006f0c <alloc_desc+0x12>
      q->free[i] = 0;
      return i;
    }
  }
  return -1;
    80006f1a:	557d                	li	a0,-1
}
    80006f1c:	60a2                	ld	ra,8(sp)
    80006f1e:	6402                	ld	s0,0(sp)
    80006f20:	0141                	addi	sp,sp,16
    80006f22:	8082                	ret
      q->free[i] = 0;
    80006f24:	962a                	add	a2,a2,a0
    80006f26:	00060e23          	sb	zero,28(a2)
      return i;
    80006f2a:	bfcd                	j	80006f1c <alloc_desc+0x22>

0000000080006f2c <free_desc>:
 * allocated. int i: the index at which a descriptor has been allocated in q
 *
 * Output: None
 *
 */
void free_desc(struct virtq *q, int i) {
    80006f2c:	1141                	addi	sp,sp,-16
    80006f2e:	e406                	sd	ra,8(sp)
    80006f30:	e022                	sd	s0,0(sp)
    80006f32:	0800                	addi	s0,sp,16
  if (i >= NUM)
    80006f34:	479d                	li	a5,7
    80006f36:	02b7cd63          	blt	a5,a1,80006f70 <free_desc+0x44>
    panic("free_desc 1");
  if (q->free[i])
    80006f3a:	00b507b3          	add	a5,a0,a1
    80006f3e:	01c7c783          	lbu	a5,28(a5)
    80006f42:	ef9d                	bnez	a5,80006f80 <free_desc+0x54>
    panic("free_desc 2");

  q->desc->addr = 0;
    80006f44:	611c                	ld	a5,0(a0)
    80006f46:	0007b023          	sd	zero,0(a5)
  q->desc->len = 0;
    80006f4a:	611c                	ld	a5,0(a0)
    80006f4c:	0007a423          	sw	zero,8(a5)
  q->desc->flags = 0;
    80006f50:	611c                	ld	a5,0(a0)
    80006f52:	00079623          	sh	zero,12(a5)
  q->desc->next = 0;
    80006f56:	611c                	ld	a5,0(a0)
    80006f58:	00079723          	sh	zero,14(a5)
  wakeup(&q->free[i]);
    80006f5c:	05f1                	addi	a1,a1,28
    80006f5e:	952e                	add	a0,a0,a1
    80006f60:	ffffc097          	auipc	ra,0xffffc
    80006f64:	80c080e7          	jalr	-2036(ra) # 8000276c <wakeup>
}
    80006f68:	60a2                	ld	ra,8(sp)
    80006f6a:	6402                	ld	s0,0(sp)
    80006f6c:	0141                	addi	sp,sp,16
    80006f6e:	8082                	ret
    panic("free_desc 1");
    80006f70:	00003517          	auipc	a0,0x3
    80006f74:	74850513          	addi	a0,a0,1864 # 8000a6b8 <etext+0x6b8>
    80006f78:	ffff9097          	auipc	ra,0xffff9
    80006f7c:	5e8080e7          	jalr	1512(ra) # 80000560 <panic>
    panic("free_desc 2");
    80006f80:	00003517          	auipc	a0,0x3
    80006f84:	74850513          	addi	a0,a0,1864 # 8000a6c8 <etext+0x6c8>
    80006f88:	ffff9097          	auipc	ra,0xffff9
    80006f8c:	5d8080e7          	jalr	1496(ra) # 80000560 <panic>

0000000080006f90 <virtio_net_init>:
 * VirtualIO (VIRTIO) device. The process of this function is defined in
 * section 5.1.5 of the VIRTIO Device specification. Since I'm creating
 * a minimal netowrk driver, I only negotiate VIRTIO_NET_F_MAC
 *
 */
void virtio_net_init(void) {
    80006f90:	7159                	addi	sp,sp,-112
    80006f92:	f486                	sd	ra,104(sp)
    80006f94:	f0a2                	sd	s0,96(sp)
    80006f96:	eca6                	sd	s1,88(sp)
    80006f98:	e8ca                	sd	s2,80(sp)
    80006f9a:	e4ce                	sd	s3,72(sp)
    80006f9c:	e0d2                	sd	s4,64(sp)
    80006f9e:	fc56                	sd	s5,56(sp)
    80006fa0:	f85a                	sd	s6,48(sp)
    80006fa2:	f45e                	sd	s7,40(sp)
    80006fa4:	f062                	sd	s8,32(sp)
    80006fa6:	ec66                	sd	s9,24(sp)
    80006fa8:	e86a                	sd	s10,16(sp)
    80006faa:	e46e                	sd	s11,8(sp)
    80006fac:	1880                	addi	s0,sp,112
  uint32 status = 0;
  initlock(&net.vnet_lock, "virtio_net");
    80006fae:	00004597          	auipc	a1,0x4
    80006fb2:	80a58593          	addi	a1,a1,-2038 # 8000a7b8 <etext+0x7b8>
    80006fb6:	00069517          	auipc	a0,0x69
    80006fba:	9da50513          	addi	a0,a0,-1574 # 8006f990 <net+0x10>
    80006fbe:	ffffa097          	auipc	ra,0xffffa
    80006fc2:	cc4080e7          	jalr	-828(ra) # 80000c82 <initlock>

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006fc6:	100027b7          	lui	a5,0x10002
    80006fca:	4398                	lw	a4,0(a5)
    80006fcc:	2701                	sext.w	a4,a4
    80006fce:	747277b7          	lui	a5,0x74727
    80006fd2:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006fd6:	32f71a63          	bne	a4,a5,8000730a <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80006fda:	100027b7          	lui	a5,0x10002
    80006fde:	43dc                	lw	a5,4(a5)
    80006fe0:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006fe2:	4709                	li	a4,2
    80006fe4:	32e79363          	bne	a5,a4,8000730a <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80006fe8:	100027b7          	lui	a5,0x10002
    80006fec:	479c                	lw	a5,8(a5)
    80006fee:	2781                	sext.w	a5,a5
    80006ff0:	4705                	li	a4,1
    80006ff2:	30e79c63          	bne	a5,a4,8000730a <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80006ff6:	100027b7          	lui	a5,0x10002
    80006ffa:	47d8                	lw	a4,12(a5)
    80006ffc:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80006ffe:	554d47b7          	lui	a5,0x554d4
    80007002:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80007006:	30f71263          	bne	a4,a5,8000730a <virtio_net_init+0x37a>
    panic("could not find virtio net");
  }

  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    8000700a:	100024b7          	lui	s1,0x10002
    8000700e:	07048493          	addi	s1,s1,112 # 10002070 <_entry-0x6fffdf90>
    80007012:	0004a023          	sw	zero,0(s1)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007016:	4785                	li	a5,1
    80007018:	c09c                	sw	a5,0(s1)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;
    8000701a:	478d                	li	a5,3
    8000701c:	c09c                	sw	a5,0(s1)

  // This copies the memory from the config into my driver state struct
  memmove((void *)&net.cfg, (void *)VIRTIO_NET_CONFIG,
    8000701e:	4631                	li	a2,12
    80007020:	100025b7          	lui	a1,0x10002
    80007024:	10058593          	addi	a1,a1,256 # 10002100 <_entry-0x6fffdf00>
    80007028:	00069517          	auipc	a0,0x69
    8000702c:	95850513          	addi	a0,a0,-1704 # 8006f980 <net>
    80007030:	ffffa097          	auipc	ra,0xffffa
    80007034:	e42080e7          	jalr	-446(ra) # 80000e72 <memmove>
          sizeof(struct virtio_net_config));

  // Negotiate the feature bits
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80007038:	100027b7          	lui	a5,0x10002
    8000703c:	4b9c                	lw	a5,16(a5)
  features &= VIRTIO_NET_F_MAC;
    8000703e:	0207f793          	andi	a5,a5,32
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80007042:	10002737          	lui	a4,0x10002
    80007046:	d31c                	sw	a5,32(a4)

  // Tell device that feature negotiation is complete
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007048:	47ad                	li	a5,11
    8000704a:	c09c                	sw	a5,0(s1)

  // Make sure that FEATURES_OK is set
  status = *R(VIRTIO_MMIO_STATUS);
    8000704c:	409c                	lw	a5,0(s1)
    8000704e:	00078d1b          	sext.w	s10,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80007052:	8ba1                	andi	a5,a5,8
    80007054:	2c078363          	beqz	a5,8000731a <virtio_net_init+0x38a>
    panic("virtio net FEATURES_OK unset");

  // Check max queue size
  uint32 max_queue_size = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80007058:	100027b7          	lui	a5,0x10002
    8000705c:	5bdc                	lw	a5,52(a5)
    8000705e:	2781                	sext.w	a5,a5
  if (max_queue_size == 0)
    80007060:	2c078563          	beqz	a5,8000732a <virtio_net_init+0x39a>
    panic("virtio net has no queue 1 (QUEUE_TX)");
  if (max_queue_size < NUM)
    80007064:	471d                	li	a4,7
    80007066:	2cf77a63          	bgeu	a4,a5,8000733a <virtio_net_init+0x3aa>
    panic("virtio net max queue too short");

  /* Initialize QUEUE_TX */
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    8000706a:	10002737          	lui	a4,0x10002
    8000706e:	4785                	li	a5,1
    80007070:	db1c                	sw	a5,48(a4)
  net.txq.num = QUEUE_TX;
    80007072:	00069717          	auipc	a4,0x69
    80007076:	94f72723          	sw	a5,-1714(a4) # 8006f9c0 <net+0x40>

  // ensure QUEUE_TX is not in use.
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000707a:	100027b7          	lui	a5,0x10002
    8000707e:	43fc                	lw	a5,68(a5)
    80007080:	2781                	sext.w	a5,a5
    80007082:	2c079463          	bnez	a5,8000734a <virtio_net_init+0x3ba>
    panic("QUEUE_TX should not be ready\n");

  net.txq.desc = kalloc();
    80007086:	ffffa097          	auipc	ra,0xffffa
    8000708a:	b7e080e7          	jalr	-1154(ra) # 80000c04 <kalloc>
    8000708e:	00069497          	auipc	s1,0x69
    80007092:	8f248493          	addi	s1,s1,-1806 # 8006f980 <net>
    80007096:	f488                	sd	a0,40(s1)
  net.txq.driver_area = kalloc();
    80007098:	ffffa097          	auipc	ra,0xffffa
    8000709c:	b6c080e7          	jalr	-1172(ra) # 80000c04 <kalloc>
    800070a0:	f888                	sd	a0,48(s1)
  net.txq.device_area = kalloc();
    800070a2:	ffffa097          	auipc	ra,0xffffa
    800070a6:	b62080e7          	jalr	-1182(ra) # 80000c04 <kalloc>
    800070aa:	87aa                	mv	a5,a0
    800070ac:	fc88                	sd	a0,56(s1)
  if (!net.txq.desc || !net.txq.driver_area || !net.txq.device_area)
    800070ae:	7488                	ld	a0,40(s1)
    800070b0:	2a050563          	beqz	a0,8000735a <virtio_net_init+0x3ca>
    800070b4:	00069717          	auipc	a4,0x69
    800070b8:	8fc73703          	ld	a4,-1796(a4) # 8006f9b0 <net+0x30>
    800070bc:	28070f63          	beqz	a4,8000735a <virtio_net_init+0x3ca>
    800070c0:	28078d63          	beqz	a5,8000735a <virtio_net_init+0x3ca>
    panic("virtio net alloc\n");
  memset(net.txq.desc, 0, PGSIZE);
    800070c4:	6605                	lui	a2,0x1
    800070c6:	4581                	li	a1,0
    800070c8:	ffffa097          	auipc	ra,0xffffa
    800070cc:	d46080e7          	jalr	-698(ra) # 80000e0e <memset>
  memset(net.txq.free, 1, NUM);
    800070d0:	00069497          	auipc	s1,0x69
    800070d4:	8b048493          	addi	s1,s1,-1872 # 8006f980 <net>
    800070d8:	4621                	li	a2,8
    800070da:	4585                	li	a1,1
    800070dc:	00069517          	auipc	a0,0x69
    800070e0:	8e850513          	addi	a0,a0,-1816 # 8006f9c4 <net+0x44>
    800070e4:	ffffa097          	auipc	ra,0xffffa
    800070e8:	d2a080e7          	jalr	-726(ra) # 80000e0e <memset>
  memset(net.txq.driver_area, 0, PGSIZE);
    800070ec:	6605                	lui	a2,0x1
    800070ee:	4581                	li	a1,0
    800070f0:	7888                	ld	a0,48(s1)
    800070f2:	ffffa097          	auipc	ra,0xffffa
    800070f6:	d1c080e7          	jalr	-740(ra) # 80000e0e <memset>
  memset(net.txq.device_area, 0, PGSIZE);
    800070fa:	6605                	lui	a2,0x1
    800070fc:	4581                	li	a1,0
    800070fe:	7c88                	ld	a0,56(s1)
    80007100:	ffffa097          	auipc	ra,0xffffa
    80007104:	d0e080e7          	jalr	-754(ra) # 80000e0e <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80007108:	100027b7          	lui	a5,0x10002
    8000710c:	4721                	li	a4,8
    8000710e:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.txq.desc;
    80007110:	749c                	ld	a5,40(s1)
    80007112:	0007869b          	sext.w	a3,a5
    80007116:	10002737          	lui	a4,0x10002
    8000711a:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.txq.desc) >> 32;
    8000711e:	9781                	srai	a5,a5,0x20
    80007120:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.txq.driver_area;
    80007124:	789c                	ld	a5,48(s1)
    80007126:	0007869b          	sext.w	a3,a5
    8000712a:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.txq.driver_area) >> 32;
    8000712e:	9781                	srai	a5,a5,0x20
    80007130:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.txq.device_area;
    80007134:	7c9c                	ld	a5,56(s1)
    80007136:	0007869b          	sext.w	a3,a5
    8000713a:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.txq.device_area) >> 32;
    8000713e:	9781                	srai	a5,a5,0x20
    80007140:	0af72223          	sw	a5,164(a4)

  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80007144:	87ba                	mv	a5,a4
    80007146:	4705                	li	a4,1
    80007148:	c3f8                	sw	a4,68(a5)
    8000714a:	04478793          	addi	a5,a5,68 # 10002044 <_entry-0x6fffdfbc>

  /* Initialize QUEUE_RX */

  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_RX;
    8000714e:	10002737          	lui	a4,0x10002
    80007152:	02072823          	sw	zero,48(a4) # 10002030 <_entry-0x6fffdfd0>
  net.rxq.num = QUEUE_RX;
    80007156:	0604a423          	sw	zero,104(s1)
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000715a:	439c                	lw	a5,0(a5)
    8000715c:	2781                	sext.w	a5,a5
    8000715e:	20079663          	bnez	a5,8000736a <virtio_net_init+0x3da>
    panic("QUEUE_RX should not be ready\n");

  net.rxq.desc = kalloc();
    80007162:	ffffa097          	auipc	ra,0xffffa
    80007166:	aa2080e7          	jalr	-1374(ra) # 80000c04 <kalloc>
    8000716a:	00069497          	auipc	s1,0x69
    8000716e:	81648493          	addi	s1,s1,-2026 # 8006f980 <net>
    80007172:	e8a8                	sd	a0,80(s1)
  net.rxq.driver_area = kalloc();
    80007174:	ffffa097          	auipc	ra,0xffffa
    80007178:	a90080e7          	jalr	-1392(ra) # 80000c04 <kalloc>
    8000717c:	eca8                	sd	a0,88(s1)
  net.rxq.device_area = kalloc();
    8000717e:	ffffa097          	auipc	ra,0xffffa
    80007182:	a86080e7          	jalr	-1402(ra) # 80000c04 <kalloc>
    80007186:	87aa                	mv	a5,a0
    80007188:	f0a8                	sd	a0,96(s1)
  if (!net.rxq.desc || !net.rxq.driver_area || !net.rxq.device_area)
    8000718a:	68a8                	ld	a0,80(s1)
    8000718c:	1e050763          	beqz	a0,8000737a <virtio_net_init+0x3ea>
    80007190:	00069717          	auipc	a4,0x69
    80007194:	84873703          	ld	a4,-1976(a4) # 8006f9d8 <net+0x58>
    80007198:	1e070163          	beqz	a4,8000737a <virtio_net_init+0x3ea>
    8000719c:	1c078f63          	beqz	a5,8000737a <virtio_net_init+0x3ea>
    panic("virtio net alloc");
  memset(net.rxq.desc, 0, PGSIZE);
    800071a0:	6605                	lui	a2,0x1
    800071a2:	4581                	li	a1,0
    800071a4:	ffffa097          	auipc	ra,0xffffa
    800071a8:	c6a080e7          	jalr	-918(ra) # 80000e0e <memset>
  memset(net.rxq.free, 1, NUM);
    800071ac:	00068497          	auipc	s1,0x68
    800071b0:	7d448493          	addi	s1,s1,2004 # 8006f980 <net>
    800071b4:	4621                	li	a2,8
    800071b6:	4585                	li	a1,1
    800071b8:	00069517          	auipc	a0,0x69
    800071bc:	83450513          	addi	a0,a0,-1996 # 8006f9ec <net+0x6c>
    800071c0:	ffffa097          	auipc	ra,0xffffa
    800071c4:	c4e080e7          	jalr	-946(ra) # 80000e0e <memset>
  memset(net.rxq.driver_area, 0, PGSIZE);
    800071c8:	6605                	lui	a2,0x1
    800071ca:	4581                	li	a1,0
    800071cc:	6ca8                	ld	a0,88(s1)
    800071ce:	ffffa097          	auipc	ra,0xffffa
    800071d2:	c40080e7          	jalr	-960(ra) # 80000e0e <memset>
  memset(net.rxq.device_area, 0, PGSIZE);
    800071d6:	6605                	lui	a2,0x1
    800071d8:	4581                	li	a1,0
    800071da:	70a8                	ld	a0,96(s1)
    800071dc:	ffffa097          	auipc	ra,0xffffa
    800071e0:	c32080e7          	jalr	-974(ra) # 80000e0e <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800071e4:	100027b7          	lui	a5,0x10002
    800071e8:	4721                	li	a4,8
    800071ea:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.rxq.desc;
    800071ec:	68bc                	ld	a5,80(s1)
    800071ee:	0007869b          	sext.w	a3,a5
    800071f2:	10002737          	lui	a4,0x10002
    800071f6:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.rxq.desc) >> 32;
    800071fa:	9781                	srai	a5,a5,0x20
    800071fc:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.rxq.driver_area;
    80007200:	6cbc                	ld	a5,88(s1)
    80007202:	0007869b          	sext.w	a3,a5
    80007206:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.rxq.driver_area) >> 32;
    8000720a:	9781                	srai	a5,a5,0x20
    8000720c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.rxq.device_area;
    80007210:	70bc                	ld	a5,96(s1)
    80007212:	0007869b          	sext.w	a3,a5
    80007216:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.rxq.device_area) >> 32;
    8000721a:	9781                	srai	a5,a5,0x20
    8000721c:	0af72223          	sw	a5,164(a4)
    80007220:	4a11                	li	s4,4

  for (int i = 0; i < NUM / 2; i++) {
    int rx_hdr_desc = alloc_desc(&net.rxq);
    80007222:	00068a97          	auipc	s5,0x68
    80007226:	7aea8a93          	addi	s5,s5,1966 # 8006f9d0 <net+0x50>
    struct virtio_net_hdr *hdr = kalloc();
    if (!rxbuf)
      panic("rxbuf alloc failed");

    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    8000722a:	4ca9                	li	s9,10
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    8000722c:	4c05                	li	s8,1
    net.rxq.desc[rx_hdr_desc].next = rx_desc;

    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    net.rxq.desc[rx_desc].len = PGSIZE;
    8000722e:	6b85                	lui	s7,0x1
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    80007230:	4b09                	li	s6,2
    int rx_hdr_desc = alloc_desc(&net.rxq);
    80007232:	8556                	mv	a0,s5
    80007234:	00000097          	auipc	ra,0x0
    80007238:	cc6080e7          	jalr	-826(ra) # 80006efa <alloc_desc>
    8000723c:	89aa                	mv	s3,a0
    int rx_desc = alloc_desc(&net.rxq);
    8000723e:	8556                	mv	a0,s5
    80007240:	00000097          	auipc	ra,0x0
    80007244:	cba080e7          	jalr	-838(ra) # 80006efa <alloc_desc>
    80007248:	8daa                	mv	s11,a0
    void *rxbuf = kalloc();
    8000724a:	ffffa097          	auipc	ra,0xffffa
    8000724e:	9ba080e7          	jalr	-1606(ra) # 80000c04 <kalloc>
    80007252:	892a                	mv	s2,a0
    struct virtio_net_hdr *hdr = kalloc();
    80007254:	ffffa097          	auipc	ra,0xffffa
    80007258:	9b0080e7          	jalr	-1616(ra) # 80000c04 <kalloc>
    if (!rxbuf)
    8000725c:	12090763          	beqz	s2,8000738a <virtio_net_init+0x3fa>
    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    80007260:	00499793          	slli	a5,s3,0x4
    80007264:	68b8                	ld	a4,80(s1)
    80007266:	973e                	add	a4,a4,a5
    80007268:	e308                	sd	a0,0(a4)
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    8000726a:	68b8                	ld	a4,80(s1)
    8000726c:	973e                	add	a4,a4,a5
    8000726e:	01972423          	sw	s9,8(a4)
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    80007272:	68b8                	ld	a4,80(s1)
    80007274:	973e                	add	a4,a4,a5
    80007276:	01871623          	sh	s8,12(a4)
    net.rxq.desc[rx_hdr_desc].next = rx_desc;
    8000727a:	68b8                	ld	a4,80(s1)
    8000727c:	97ba                	add	a5,a5,a4
    8000727e:	01b79723          	sh	s11,14(a5) # 1000200e <_entry-0x6fffdff2>
    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    80007282:	004d9793          	slli	a5,s11,0x4
    80007286:	68b8                	ld	a4,80(s1)
    80007288:	973e                	add	a4,a4,a5
    8000728a:	01273023          	sd	s2,0(a4)
    net.rxq.desc[rx_desc].len = PGSIZE;
    8000728e:	68b8                	ld	a4,80(s1)
    80007290:	973e                	add	a4,a4,a5
    80007292:	01772423          	sw	s7,8(a4)
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    80007296:	68b8                	ld	a4,80(s1)
    80007298:	97ba                	add	a5,a5,a4
    8000729a:	01679623          	sh	s6,12(a5)

    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = rx_hdr_desc;
    8000729e:	6cb8                	ld	a4,88(s1)
    800072a0:	00275783          	lhu	a5,2(a4)
    800072a4:	8b9d                	andi	a5,a5,7
    800072a6:	0786                	slli	a5,a5,0x1
    800072a8:	973e                	add	a4,a4,a5
    800072aa:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    800072ae:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    800072b2:	6cb8                	ld	a4,88(s1)
    800072b4:	00275783          	lhu	a5,2(a4)
    800072b8:	2785                	addiw	a5,a5,1
    800072ba:	00f71123          	sh	a5,2(a4)
    __sync_synchronize();
    800072be:	0330000f          	fence	rw,rw
  for (int i = 0; i < NUM / 2; i++) {
    800072c2:	3a7d                	addiw	s4,s4,-1
    800072c4:	f60a17e3          	bnez	s4,80007232 <virtio_net_init+0x2a2>
  }

  // queue is ready
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800072c8:	100027b7          	lui	a5,0x10002
    800072cc:	4705                	li	a4,1
    800072ce:	c3f8                	sw	a4,68(a5)

  // Notify device
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_RX;
    800072d0:	0407a823          	sw	zero,80(a5) # 10002050 <_entry-0x6fffdfb0>

  // Done initializing
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800072d4:	004d6d13          	ori	s10,s10,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800072d8:	07a7a823          	sw	s10,112(a5)

  // initialize packet buffer
  packet_buf = kalloc();
    800072dc:	ffffa097          	auipc	ra,0xffffa
    800072e0:	928080e7          	jalr	-1752(ra) # 80000c04 <kalloc>
    800072e4:	00007797          	auipc	a5,0x7
    800072e8:	00a7ba23          	sd	a0,20(a5) # 8000e2f8 <packet_buf>
}
    800072ec:	70a6                	ld	ra,104(sp)
    800072ee:	7406                	ld	s0,96(sp)
    800072f0:	64e6                	ld	s1,88(sp)
    800072f2:	6946                	ld	s2,80(sp)
    800072f4:	69a6                	ld	s3,72(sp)
    800072f6:	6a06                	ld	s4,64(sp)
    800072f8:	7ae2                	ld	s5,56(sp)
    800072fa:	7b42                	ld	s6,48(sp)
    800072fc:	7ba2                	ld	s7,40(sp)
    800072fe:	7c02                	ld	s8,32(sp)
    80007300:	6ce2                	ld	s9,24(sp)
    80007302:	6d42                	ld	s10,16(sp)
    80007304:	6da2                	ld	s11,8(sp)
    80007306:	6165                	addi	sp,sp,112
    80007308:	8082                	ret
    panic("could not find virtio net");
    8000730a:	00003517          	auipc	a0,0x3
    8000730e:	4be50513          	addi	a0,a0,1214 # 8000a7c8 <etext+0x7c8>
    80007312:	ffff9097          	auipc	ra,0xffff9
    80007316:	24e080e7          	jalr	590(ra) # 80000560 <panic>
    panic("virtio net FEATURES_OK unset");
    8000731a:	00003517          	auipc	a0,0x3
    8000731e:	4ce50513          	addi	a0,a0,1230 # 8000a7e8 <etext+0x7e8>
    80007322:	ffff9097          	auipc	ra,0xffff9
    80007326:	23e080e7          	jalr	574(ra) # 80000560 <panic>
    panic("virtio net has no queue 1 (QUEUE_TX)");
    8000732a:	00003517          	auipc	a0,0x3
    8000732e:	4de50513          	addi	a0,a0,1246 # 8000a808 <etext+0x808>
    80007332:	ffff9097          	auipc	ra,0xffff9
    80007336:	22e080e7          	jalr	558(ra) # 80000560 <panic>
    panic("virtio net max queue too short");
    8000733a:	00003517          	auipc	a0,0x3
    8000733e:	4f650513          	addi	a0,a0,1270 # 8000a830 <etext+0x830>
    80007342:	ffff9097          	auipc	ra,0xffff9
    80007346:	21e080e7          	jalr	542(ra) # 80000560 <panic>
    panic("QUEUE_TX should not be ready\n");
    8000734a:	00003517          	auipc	a0,0x3
    8000734e:	50650513          	addi	a0,a0,1286 # 8000a850 <etext+0x850>
    80007352:	ffff9097          	auipc	ra,0xffff9
    80007356:	20e080e7          	jalr	526(ra) # 80000560 <panic>
    panic("virtio net alloc\n");
    8000735a:	00003517          	auipc	a0,0x3
    8000735e:	51650513          	addi	a0,a0,1302 # 8000a870 <etext+0x870>
    80007362:	ffff9097          	auipc	ra,0xffff9
    80007366:	1fe080e7          	jalr	510(ra) # 80000560 <panic>
    panic("QUEUE_RX should not be ready\n");
    8000736a:	00003517          	auipc	a0,0x3
    8000736e:	51e50513          	addi	a0,a0,1310 # 8000a888 <etext+0x888>
    80007372:	ffff9097          	auipc	ra,0xffff9
    80007376:	1ee080e7          	jalr	494(ra) # 80000560 <panic>
    panic("virtio net alloc");
    8000737a:	00003517          	auipc	a0,0x3
    8000737e:	52e50513          	addi	a0,a0,1326 # 8000a8a8 <etext+0x8a8>
    80007382:	ffff9097          	auipc	ra,0xffff9
    80007386:	1de080e7          	jalr	478(ra) # 80000560 <panic>
      panic("rxbuf alloc failed");
    8000738a:	00003517          	auipc	a0,0x3
    8000738e:	53650513          	addi	a0,a0,1334 # 8000a8c0 <etext+0x8c0>
    80007392:	ffff9097          	auipc	ra,0xffff9
    80007396:	1ce080e7          	jalr	462(ra) # 80000560 <panic>

000000008000739a <apply_padding>:
 *      return 0 on success
 *      return 1 when the number of bytes calculated does not make sense
 */
int apply_padding(uint8 num_bytes) {
  uint8 *pkt_ptr =
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    8000739a:	04a00693          	li	a3,74
    8000739e:	9e89                	subw	a3,a3,a0
  if (num_bytes > 64 - sizeof(struct virtio_net_hdr) || num_bytes < 1) {
    800073a0:	fff5079b          	addiw	a5,a0,-1
    800073a4:	0ff7f793          	zext.b	a5,a5
    800073a8:	03500713          	li	a4,53
    800073ac:	02f76563          	bltu	a4,a5,800073d6 <apply_padding+0x3c>
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    800073b0:	00007717          	auipc	a4,0x7
    800073b4:	f4873703          	ld	a4,-184(a4) # 8000e2f8 <packet_buf>
    800073b8:	00d707b3          	add	a5,a4,a3
    800073bc:	0705                	addi	a4,a4,1
    800073be:	9736                	add	a4,a4,a3
    800073c0:	357d                	addiw	a0,a0,-1
    800073c2:	1502                	slli	a0,a0,0x20
    800073c4:	9101                	srli	a0,a0,0x20
    800073c6:	972a                	add	a4,a4,a0
    printf("malformed packet data");
    return 1;
  }
  for (int i = 0; i < num_bytes; i++) {
    pkt_ptr[i] = 0;
    800073c8:	00078023          	sb	zero,0(a5)
  for (int i = 0; i < num_bytes; i++) {
    800073cc:	0785                	addi	a5,a5,1
    800073ce:	fee79de3          	bne	a5,a4,800073c8 <apply_padding+0x2e>
  }
  return 0;
    800073d2:	4501                	li	a0,0
}
    800073d4:	8082                	ret
int apply_padding(uint8 num_bytes) {
    800073d6:	1141                	addi	sp,sp,-16
    800073d8:	e406                	sd	ra,8(sp)
    800073da:	e022                	sd	s0,0(sp)
    800073dc:	0800                	addi	s0,sp,16
    printf("malformed packet data");
    800073de:	00003517          	auipc	a0,0x3
    800073e2:	4fa50513          	addi	a0,a0,1274 # 8000a8d8 <etext+0x8d8>
    800073e6:	ffff9097          	auipc	ra,0xffff9
    800073ea:	1c4080e7          	jalr	452(ra) # 800005aa <printf>
    return 1;
    800073ee:	4505                	li	a0,1
}
    800073f0:	60a2                	ld	ra,8(sp)
    800073f2:	6402                	ld	s0,0(sp)
    800073f4:	0141                	addi	sp,sp,16
    800073f6:	8082                	ret

00000000800073f8 <transmit_packet>:
 *                     of the data is 1500 (defined by the ethernet protocol)
 *
 * Output: There is no return value from the function, but the packet frame
 *         is given to the NIC to be transmitted.
 */
void transmit_packet(void *pkt_data, uint16 pkt_len, uint16 protocol) {
    800073f8:	711d                	addi	sp,sp,-96
    800073fa:	ec86                	sd	ra,88(sp)
    800073fc:	e8a2                	sd	s0,80(sp)
    800073fe:	e4a6                	sd	s1,72(sp)
    80007400:	e0ca                	sd	s2,64(sp)
    80007402:	fc4e                	sd	s3,56(sp)
    80007404:	f852                	sd	s4,48(sp)
    80007406:	f456                	sd	s5,40(sp)
    80007408:	f05a                	sd	s6,32(sp)
    8000740a:	ec5e                	sd	s7,24(sp)
    8000740c:	e862                	sd	s8,16(sp)
    8000740e:	e466                	sd	s9,8(sp)
    80007410:	1080                	addi	s0,sp,96
    80007412:	8caa                	mv	s9,a0
    80007414:	8aae                	mv	s5,a1
    80007416:	84b2                	mv	s1,a2
  /* Create the header for transmission */
  acquire(&net.vnet_lock);
    80007418:	00068517          	auipc	a0,0x68
    8000741c:	57850513          	addi	a0,a0,1400 # 8006f990 <net+0x10>
    80007420:	ffffa097          	auipc	ra,0xffffa
    80007424:	8f6080e7          	jalr	-1802(ra) # 80000d16 <acquire>
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    80007428:	100027b7          	lui	a5,0x10002
    8000742c:	4705                	li	a4,1
    8000742e:	db98                	sw	a4,48(a5)
  // allocate for packet header and packet_frame
  struct virtio_net_hdr *hdr = kalloc();
    80007430:	ffff9097          	auipc	ra,0xffff9
    80007434:	7d4080e7          	jalr	2004(ra) # 80000c04 <kalloc>
  if (hdr == 0)
    80007438:	1c050d63          	beqz	a0,80007612 <transmit_packet+0x21a>
    8000743c:	8baa                	mv	s7,a0
    panic("failed to allocate header\n");
  // initialize the header and packet
  memset(hdr, 0, PGSIZE);
    8000743e:	6605                	lui	a2,0x1
    80007440:	4581                	li	a1,0
    80007442:	ffffa097          	auipc	ra,0xffffa
    80007446:	9cc080e7          	jalr	-1588(ra) # 80000e0e <memset>

  int hdr_desc = alloc_desc(&net.txq);
    8000744a:	00068a17          	auipc	s4,0x68
    8000744e:	536a0a13          	addi	s4,s4,1334 # 8006f980 <net>
    80007452:	00068997          	auipc	s3,0x68
    80007456:	55698993          	addi	s3,s3,1366 # 8006f9a8 <net+0x28>
    8000745a:	854e                	mv	a0,s3
    8000745c:	00000097          	auipc	ra,0x0
    80007460:	a9e080e7          	jalr	-1378(ra) # 80006efa <alloc_desc>
    80007464:	892a                	mv	s2,a0
  int pkt_desc = alloc_desc(&net.txq);
    80007466:	854e                	mv	a0,s3
    80007468:	00000097          	auipc	ra,0x0
    8000746c:	a92080e7          	jalr	-1390(ra) # 80006efa <alloc_desc>
    80007470:	89aa                	mv	s3,a0

  hdr->flags = 0;
    80007472:	000b8023          	sb	zero,0(s7) # 1000 <_entry-0x7ffff000>
  hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
    80007476:	000b80a3          	sb	zero,1(s7)
  hdr->hdr_len = 0;
    8000747a:	000b9123          	sh	zero,2(s7)

  memmove(packet_buf, "\xe2\x71\xad\xf4\x7b\xff", 6);
    8000747e:	00007b17          	auipc	s6,0x7
    80007482:	e7ab0b13          	addi	s6,s6,-390 # 8000e2f8 <packet_buf>
    80007486:	4619                	li	a2,6
    80007488:	00003597          	auipc	a1,0x3
    8000748c:	48858593          	addi	a1,a1,1160 # 8000a910 <etext+0x910>
    80007490:	000b3503          	ld	a0,0(s6)
    80007494:	ffffa097          	auipc	ra,0xffffa
    80007498:	9de080e7          	jalr	-1570(ra) # 80000e72 <memmove>
  memmove(packet_buf + 6, net.cfg.mac, 6);
    8000749c:	000b3503          	ld	a0,0(s6)
    800074a0:	4619                	li	a2,6
    800074a2:	85d2                	mv	a1,s4
    800074a4:	9532                	add	a0,a0,a2
    800074a6:	ffffa097          	auipc	ra,0xffffa
    800074aa:	9cc080e7          	jalr	-1588(ra) # 80000e72 <memmove>

  packet_buf[12] = (protocol >> 8);
    800074ae:	000b3503          	ld	a0,0(s6)
    800074b2:	0084d71b          	srliw	a4,s1,0x8
    800074b6:	00e50623          	sb	a4,12(a0)
  packet_buf[13] = (protocol & 0xF);
    800074ba:	88bd                	andi	s1,s1,15
    800074bc:	009506a3          	sb	s1,13(a0)

  memmove(packet_buf + 14, pkt_data, pkt_len);
    800074c0:	000a8c1b          	sext.w	s8,s5
    800074c4:	8662                	mv	a2,s8
    800074c6:	85e6                	mv	a1,s9
    800074c8:	0539                	addi	a0,a0,14
    800074ca:	ffffa097          	auipc	ra,0xffffa
    800074ce:	9a8080e7          	jalr	-1624(ra) # 80000e72 <memmove>

  net.txq.desc[hdr_desc].flags |=
    800074d2:	00491793          	slli	a5,s2,0x4
    800074d6:	028a3703          	ld	a4,40(s4)
    800074da:	973e                	add	a4,a4,a5
    800074dc:	00c75683          	lhu	a3,12(a4)
    800074e0:	0016e693          	ori	a3,a3,1
    800074e4:	00d71623          	sh	a3,12(a4)
      VRING_DESC_F_NEXT; // This tells the device it's a chain
  net.txq.desc[hdr_desc].len = HDR_SIZE;
    800074e8:	028a3703          	ld	a4,40(s4)
    800074ec:	973e                	add	a4,a4,a5
    800074ee:	46a9                	li	a3,10
    800074f0:	c714                	sw	a3,8(a4)
  net.txq.desc[hdr_desc].addr = (uint64)hdr;
    800074f2:	028a3703          	ld	a4,40(s4)
    800074f6:	973e                	add	a4,a4,a5
    800074f8:	01773023          	sd	s7,0(a4)
  net.txq.desc[hdr_desc].next = pkt_desc;
    800074fc:	028a3703          	ld	a4,40(s4)
    80007500:	97ba                	add	a5,a5,a4
    80007502:	01379723          	sh	s3,14(a5) # 1000200e <_entry-0x6fffdff2>

  net.txq.desc[pkt_desc].len = 14 + pkt_len;
    80007506:	0992                	slli	s3,s3,0x4
    80007508:	028a3783          	ld	a5,40(s4)
    8000750c:	97ce                	add	a5,a5,s3
    8000750e:	00ea871b          	addiw	a4,s5,14
    80007512:	c798                	sw	a4,8(a5)
  net.txq.desc[pkt_desc].addr = (uint64)packet_buf;
    80007514:	028a3783          	ld	a5,40(s4)
    80007518:	97ce                	add	a5,a5,s3
    8000751a:	000b3703          	ld	a4,0(s6)
    8000751e:	e398                	sd	a4,0(a5)
  net.txq.desc[pkt_desc].flags = 0;
    80007520:	028a3783          	ld	a5,40(s4)
    80007524:	97ce                	add	a5,a5,s3
    80007526:	00079623          	sh	zero,12(a5)

  if (pkt_len < 64) {
    8000752a:	03f00793          	li	a5,63
    8000752e:	0387e563          	bltu	a5,s8,80007558 <transmit_packet+0x160>
    int res = apply_padding(64 - pkt_len);
    80007532:	04000513          	li	a0,64
    80007536:	4155053b          	subw	a0,a0,s5
    8000753a:	0ff57513          	zext.b	a0,a0
    8000753e:	00000097          	auipc	ra,0x0
    80007542:	e5c080e7          	jalr	-420(ra) # 8000739a <apply_padding>
    net.txq.desc[pkt_desc].len = 64;
    80007546:	00068797          	auipc	a5,0x68
    8000754a:	4627b783          	ld	a5,1122(a5) # 8006f9a8 <net+0x28>
    8000754e:	97ce                	add	a5,a5,s3
    80007550:	04000713          	li	a4,64
    80007554:	c798                	sw	a4,8(a5)
    if (res != 0)
    80007556:	e571                	bnez	a0,80007622 <transmit_packet+0x22a>
      panic("failed to apply padding");
  }

  // Tell the device first index in chain of descriptors
  net.txq.driver_area->ring[net.txq.driver_area->idx % NUM] = hdr_desc;
    80007558:	00068997          	auipc	s3,0x68
    8000755c:	42898993          	addi	s3,s3,1064 # 8006f980 <net>
    80007560:	0309b703          	ld	a4,48(s3)
    80007564:	00275783          	lhu	a5,2(a4)
    80007568:	8b9d                	andi	a5,a5,7
    8000756a:	0786                	slli	a5,a5,0x1
    8000756c:	973e                	add	a4,a4,a5
    8000756e:	01271223          	sh	s2,4(a4)
  __sync_synchronize();
    80007572:	0330000f          	fence	rw,rw
  // Tell the device another avail ring entry is available
  net.txq.driver_area->idx++;
    80007576:	0309b703          	ld	a4,48(s3)
    8000757a:	00275783          	lhu	a5,2(a4)
    8000757e:	2785                	addiw	a5,a5,1
    80007580:	00f71123          	sh	a5,2(a4)
  __sync_synchronize();
    80007584:	0330000f          	fence	rw,rw

  uint16 prev_used_idx = net.txq.device_area->idx;
    80007588:	0389b783          	ld	a5,56(s3)
    8000758c:	0027d483          	lhu	s1,2(a5)
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_TX;
    80007590:	100027b7          	lui	a5,0x10002
    80007594:	4705                	li	a4,1
    80007596:	cbb8                	sw	a4,80(a5)
  release(&net.vnet_lock);
    80007598:	00068517          	auipc	a0,0x68
    8000759c:	3f850513          	addi	a0,a0,1016 # 8006f990 <net+0x10>
    800075a0:	ffffa097          	auipc	ra,0xffffa
    800075a4:	826080e7          	jalr	-2010(ra) # 80000dc6 <release>

  // Wait for the device to use the descriptor. It indicates this by
  // decrementing the index. Polling helps to avoid race conditions
  while (net.txq.device_area->idx == prev_used_idx) {
    800075a8:	0389b783          	ld	a5,56(s3)
    800075ac:	0027d783          	lhu	a5,2(a5) # 10002002 <_entry-0x6fffdffe>
    800075b0:	00979c63          	bne	a5,s1,800075c8 <transmit_packet+0x1d0>
    800075b4:	86ce                	mv	a3,s3
    800075b6:	0004871b          	sext.w	a4,s1
    __sync_synchronize();
    800075ba:	0330000f          	fence	rw,rw
  while (net.txq.device_area->idx == prev_used_idx) {
    800075be:	7e9c                	ld	a5,56(a3)
    800075c0:	0027d783          	lhu	a5,2(a5)
    800075c4:	fee78be3          	beq	a5,a4,800075ba <transmit_packet+0x1c2>
  }
  printf("mac: %x:%x:%x:%x:%x:%x\n", net.cfg.mac[0], net.cfg.mac[1],
         net.cfg.mac[2], net.cfg.mac[3], net.cfg.mac[4], net.cfg.mac[5]);
    800075c8:	00068597          	auipc	a1,0x68
    800075cc:	3b858593          	addi	a1,a1,952 # 8006f980 <net>
  printf("mac: %x:%x:%x:%x:%x:%x\n", net.cfg.mac[0], net.cfg.mac[1],
    800075d0:	0055c803          	lbu	a6,5(a1)
    800075d4:	0045c783          	lbu	a5,4(a1)
    800075d8:	0035c703          	lbu	a4,3(a1)
    800075dc:	0025c683          	lbu	a3,2(a1)
    800075e0:	0015c603          	lbu	a2,1(a1)
    800075e4:	0005c583          	lbu	a1,0(a1)
    800075e8:	00003517          	auipc	a0,0x3
    800075ec:	34850513          	addi	a0,a0,840 # 8000a930 <etext+0x930>
    800075f0:	ffff9097          	auipc	ra,0xffff9
    800075f4:	fba080e7          	jalr	-70(ra) # 800005aa <printf>
}
    800075f8:	60e6                	ld	ra,88(sp)
    800075fa:	6446                	ld	s0,80(sp)
    800075fc:	64a6                	ld	s1,72(sp)
    800075fe:	6906                	ld	s2,64(sp)
    80007600:	79e2                	ld	s3,56(sp)
    80007602:	7a42                	ld	s4,48(sp)
    80007604:	7aa2                	ld	s5,40(sp)
    80007606:	7b02                	ld	s6,32(sp)
    80007608:	6be2                	ld	s7,24(sp)
    8000760a:	6c42                	ld	s8,16(sp)
    8000760c:	6ca2                	ld	s9,8(sp)
    8000760e:	6125                	addi	sp,sp,96
    80007610:	8082                	ret
    panic("failed to allocate header\n");
    80007612:	00003517          	auipc	a0,0x3
    80007616:	2de50513          	addi	a0,a0,734 # 8000a8f0 <etext+0x8f0>
    8000761a:	ffff9097          	auipc	ra,0xffff9
    8000761e:	f46080e7          	jalr	-186(ra) # 80000560 <panic>
      panic("failed to apply padding");
    80007622:	00003517          	auipc	a0,0x3
    80007626:	2f650513          	addi	a0,a0,758 # 8000a918 <etext+0x918>
    8000762a:	ffff9097          	auipc	ra,0xffff9
    8000762e:	f36080e7          	jalr	-202(ra) # 80000560 <panic>

0000000080007632 <print_packet_info>:

void print_packet_info(struct ip_packet *packet) {
    80007632:	7179                	addi	sp,sp,-48
    80007634:	f406                	sd	ra,40(sp)
    80007636:	f022                	sd	s0,32(sp)
    80007638:	e84a                	sd	s2,16(sp)
    8000763a:	1800                	addi	s0,sp,48
    8000763c:	892a                	mv	s2,a0
  printf("protocol: %d\n", packet->protocol);
    8000763e:	00b54583          	lbu	a1,11(a0)
    80007642:	00003517          	auipc	a0,0x3
    80007646:	30650513          	addi	a0,a0,774 # 8000a948 <etext+0x948>
    8000764a:	ffff9097          	auipc	ra,0xffff9
    8000764e:	f60080e7          	jalr	-160(ra) # 800005aa <printf>
  printf("src_ip: %d\n", ntohs(packet->src_ip));
    80007652:	01095503          	lhu	a0,16(s2)
    80007656:	00001097          	auipc	ra,0x1
    8000765a:	a20080e7          	jalr	-1504(ra) # 80008076 <ntohs>
    8000765e:	0005059b          	sext.w	a1,a0
    80007662:	00003517          	auipc	a0,0x3
    80007666:	2f650513          	addi	a0,a0,758 # 8000a958 <etext+0x958>
    8000766a:	ffff9097          	auipc	ra,0xffff9
    8000766e:	f40080e7          	jalr	-192(ra) # 800005aa <printf>
  printf("dst_ip: %d\n", packet->dst_ip);
    80007672:	01492583          	lw	a1,20(s2)
    80007676:	00003517          	auipc	a0,0x3
    8000767a:	2f250513          	addi	a0,a0,754 # 8000a968 <etext+0x968>
    8000767e:	ffff9097          	auipc	ra,0xffff9
    80007682:	f2c080e7          	jalr	-212(ra) # 800005aa <printf>
  for (int i = 0; i < packet->total_len - packet->hdr_len; i++) {
    80007686:	00495703          	lhu	a4,4(s2)
    8000768a:	00194783          	lbu	a5,1(s2)
    8000768e:	02e7df63          	bge	a5,a4,800076cc <print_packet_info+0x9a>
    80007692:	ec26                	sd	s1,24(sp)
    80007694:	e44e                	sd	s3,8(sp)
    80007696:	4481                	li	s1,0
    printf("%c", packet->data[i]);
    80007698:	00003997          	auipc	s3,0x3
    8000769c:	2e098993          	addi	s3,s3,736 # 8000a978 <etext+0x978>
    800076a0:	01893783          	ld	a5,24(s2)
    800076a4:	97a6                	add	a5,a5,s1
    800076a6:	0007c583          	lbu	a1,0(a5)
    800076aa:	854e                	mv	a0,s3
    800076ac:	ffff9097          	auipc	ra,0xffff9
    800076b0:	efe080e7          	jalr	-258(ra) # 800005aa <printf>
  for (int i = 0; i < packet->total_len - packet->hdr_len; i++) {
    800076b4:	0485                	addi	s1,s1,1
    800076b6:	00495783          	lhu	a5,4(s2)
    800076ba:	00194703          	lbu	a4,1(s2)
    800076be:	9f99                	subw	a5,a5,a4
    800076c0:	0004871b          	sext.w	a4,s1
    800076c4:	fcf74ee3          	blt	a4,a5,800076a0 <print_packet_info+0x6e>
    800076c8:	64e2                	ld	s1,24(sp)
    800076ca:	69a2                	ld	s3,8(sp)
  }
  printf("\n");
    800076cc:	00003517          	auipc	a0,0x3
    800076d0:	95450513          	addi	a0,a0,-1708 # 8000a020 <etext+0x20>
    800076d4:	ffff9097          	auipc	ra,0xffff9
    800076d8:	ed6080e7          	jalr	-298(ra) # 800005aa <printf>
}
    800076dc:	70a2                	ld	ra,40(sp)
    800076de:	7402                	ld	s0,32(sp)
    800076e0:	6942                	ld	s2,16(sp)
    800076e2:	6145                	addi	sp,sp,48
    800076e4:	8082                	ret

00000000800076e6 <receive_packet>:

uint16 receive_packet(void *pkt_buf, uint16 num_bytes) {
    800076e6:	7179                	addi	sp,sp,-48
    800076e8:	f406                	sd	ra,40(sp)
    800076ea:	f022                	sd	s0,32(sp)
    800076ec:	ec26                	sd	s1,24(sp)
    800076ee:	1800                	addi	s0,sp,48
  acquire(&net.vnet_lock);
    800076f0:	00068497          	auipc	s1,0x68
    800076f4:	29048493          	addi	s1,s1,656 # 8006f980 <net>
    800076f8:	00068517          	auipc	a0,0x68
    800076fc:	29850513          	addi	a0,a0,664 # 8006f990 <net+0x10>
    80007700:	ffff9097          	auipc	ra,0xffff9
    80007704:	616080e7          	jalr	1558(ra) # 80000d16 <acquire>
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    80007708:	58fc                	lw	a5,116(s1)
    8000770a:	70b8                	ld	a4,96(s1)
    8000770c:	00275683          	lhu	a3,2(a4)
    80007710:	08f68663          	beq	a3,a5,8000779c <receive_packet+0xb6>
    80007714:	e84a                	sd	s2,16(sp)
    80007716:	e44e                	sd	s3,8(sp)
    80007718:	e052                	sd	s4,0(sp)
    int id = net.rxq.device_area->ring[net.rxq.used_idx % NUM].id;
    uint len = net.rxq.device_area->ring[net.rxq.used_idx % NUM].len;

    struct ip_packet *packet = (struct ip_packet *)net.rxq.desc[net.rxq.desc[id].next].addr;

    printf("Interrupt: received packet of length %d\n", len - 10);
    8000771a:	00003917          	auipc	s2,0x3
    8000771e:	26690913          	addi	s2,s2,614 # 8000a980 <etext+0x980>
    int id = net.rxq.device_area->ring[net.rxq.used_idx % NUM].id;
    80007722:	41f7d69b          	sraiw	a3,a5,0x1f
    80007726:	01d6d69b          	srliw	a3,a3,0x1d
    8000772a:	9fb5                	addw	a5,a5,a3
    8000772c:	8b9d                	andi	a5,a5,7
    8000772e:	9f95                	subw	a5,a5,a3
    80007730:	078e                	slli	a5,a5,0x3
    80007732:	973e                	add	a4,a4,a5
    80007734:	00472983          	lw	s3,4(a4)
    struct ip_packet *packet = (struct ip_packet *)net.rxq.desc[net.rxq.desc[id].next].addr;
    80007738:	68bc                	ld	a5,80(s1)
    8000773a:	00499693          	slli	a3,s3,0x4
    8000773e:	96be                	add	a3,a3,a5
    80007740:	00e6d683          	lhu	a3,14(a3)
    80007744:	0692                	slli	a3,a3,0x4
    80007746:	97b6                	add	a5,a5,a3
    80007748:	0007ba03          	ld	s4,0(a5)
    printf("Interrupt: received packet of length %d\n", len - 10);
    8000774c:	470c                	lw	a1,8(a4)
    8000774e:	35d9                	addiw	a1,a1,-10
    80007750:	854a                	mv	a0,s2
    80007752:	ffff9097          	auipc	ra,0xffff9
    80007756:	e58080e7          	jalr	-424(ra) # 800005aa <printf>

    print_packet_info(packet);
    8000775a:	8552                	mv	a0,s4
    8000775c:	00000097          	auipc	ra,0x0
    80007760:	ed6080e7          	jalr	-298(ra) # 80007632 <print_packet_info>

    // Requeue the buffer
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    80007764:	6cb8                	ld	a4,88(s1)
    80007766:	00275783          	lhu	a5,2(a4)
    8000776a:	8b9d                	andi	a5,a5,7
    8000776c:	0786                	slli	a5,a5,0x1
    8000776e:	973e                	add	a4,a4,a5
    80007770:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    80007774:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    80007778:	6cb8                	ld	a4,88(s1)
    8000777a:	00275783          	lhu	a5,2(a4)
    8000777e:	2785                	addiw	a5,a5,1
    80007780:	00f71123          	sh	a5,2(a4)
    net.rxq.used_idx++;
    80007784:	58f8                	lw	a4,116(s1)
    80007786:	2705                	addiw	a4,a4,1
    80007788:	87ba                	mv	a5,a4
    8000778a:	d8f8                	sw	a4,116(s1)
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    8000778c:	70b8                	ld	a4,96(s1)
    8000778e:	00275683          	lhu	a3,2(a4)
    80007792:	f8f698e3          	bne	a3,a5,80007722 <receive_packet+0x3c>
    80007796:	6942                	ld	s2,16(sp)
    80007798:	69a2                	ld	s3,8(sp)
    8000779a:	6a02                	ld	s4,0(sp)
  }
  release(&net.vnet_lock);
    8000779c:	00068517          	auipc	a0,0x68
    800077a0:	1f450513          	addi	a0,a0,500 # 8006f990 <net+0x10>
    800077a4:	ffff9097          	auipc	ra,0xffff9
    800077a8:	622080e7          	jalr	1570(ra) # 80000dc6 <release>
  return 0;
}
    800077ac:	4501                	li	a0,0
    800077ae:	70a2                	ld	ra,40(sp)
    800077b0:	7402                	ld	s0,32(sp)
    800077b2:	64e2                	ld	s1,24(sp)
    800077b4:	6145                	addi	sp,sp,48
    800077b6:	8082                	ret

00000000800077b8 <insert_port_binding>:
    800077b8:	1141                	addi	sp,sp,-16
    800077ba:	e406                	sd	ra,8(sp)
    800077bc:	e022                	sd	s0,0(sp)
    800077be:	0800                	addi	s0,sp,16
    800077c0:	00255703          	lhu	a4,2(a0)
    800077c4:	070e                	slli	a4,a4,0x3
    800077c6:	00068797          	auipc	a5,0x68
    800077ca:	23278793          	addi	a5,a5,562 # 8006f9f8 <port_binds>
    800077ce:	97ba                	add	a5,a5,a4
    800077d0:	e388                	sd	a0,0(a5)
    800077d2:	4501                	li	a0,0
    800077d4:	60a2                	ld	ra,8(sp)
    800077d6:	6402                	ld	s0,0(sp)
    800077d8:	0141                	addi	sp,sp,16
    800077da:	8082                	ret

00000000800077dc <remove_port_binding>:
    800077dc:	1141                	addi	sp,sp,-16
    800077de:	e406                	sd	ra,8(sp)
    800077e0:	e022                	sd	s0,0(sp)
    800077e2:	0800                	addi	s0,sp,16
    800077e4:	00255783          	lhu	a5,2(a0)
    800077e8:	00379693          	slli	a3,a5,0x3
    800077ec:	00068717          	auipc	a4,0x68
    800077f0:	20c70713          	addi	a4,a4,524 # 8006f9f8 <port_binds>
    800077f4:	9736                	add	a4,a4,a3
    800077f6:	6318                	ld	a4,0(a4)
    800077f8:	cf11                	beqz	a4,80007814 <remove_port_binding+0x38>
    800077fa:	00068717          	auipc	a4,0x68
    800077fe:	1fe70713          	addi	a4,a4,510 # 8006f9f8 <port_binds>
    80007802:	00d707b3          	add	a5,a4,a3
    80007806:	0007b023          	sd	zero,0(a5)
    8000780a:	4501                	li	a0,0
    8000780c:	60a2                	ld	ra,8(sp)
    8000780e:	6402                	ld	s0,0(sp)
    80007810:	0141                	addi	sp,sp,16
    80007812:	8082                	ret
    80007814:	557d                	li	a0,-1
    80007816:	bfdd                	j	8000780c <remove_port_binding+0x30>

0000000080007818 <tcp_socket_list_insert>:
    80007818:	1141                	addi	sp,sp,-16
    8000781a:	e406                	sd	ra,8(sp)
    8000781c:	e022                	sd	s0,0(sp)
    8000781e:	0800                	addi	s0,sp,16
    80007820:	00007797          	auipc	a5,0x7
    80007824:	ae87b783          	ld	a5,-1304(a5) # 8000e308 <tcp_sock_list>
    80007828:	4794                	lw	a3,8(a5)
    8000782a:	20000713          	li	a4,512
    8000782e:	02e68a63          	beq	a3,a4,80007862 <tcp_socket_list_insert+0x4a>
    80007832:	862a                	mv	a2,a0
    80007834:	639c                	ld	a5,0(a5)
    80007836:	4501                	li	a0,0
    80007838:	86ba                	mv	a3,a4
    8000783a:	6398                	ld	a4,0(a5)
    8000783c:	c719                	beqz	a4,8000784a <tcp_socket_list_insert+0x32>
    8000783e:	2505                	addiw	a0,a0,1
    80007840:	07a1                	addi	a5,a5,8
    80007842:	fed51ce3          	bne	a0,a3,8000783a <tcp_socket_list_insert+0x22>
    80007846:	557d                	li	a0,-1
    80007848:	a809                	j	8000785a <tcp_socket_list_insert+0x42>
    8000784a:	e390                	sd	a2,0(a5)
    8000784c:	00007717          	auipc	a4,0x7
    80007850:	abc73703          	ld	a4,-1348(a4) # 8000e308 <tcp_sock_list>
    80007854:	471c                	lw	a5,8(a4)
    80007856:	2785                	addiw	a5,a5,1
    80007858:	c71c                	sw	a5,8(a4)
    8000785a:	60a2                	ld	ra,8(sp)
    8000785c:	6402                	ld	s0,0(sp)
    8000785e:	0141                	addi	sp,sp,16
    80007860:	8082                	ret
    80007862:	557d                	li	a0,-1
    80007864:	bfdd                	j	8000785a <tcp_socket_list_insert+0x42>

0000000080007866 <sockalloc>:
    80007866:	1101                	addi	sp,sp,-32
    80007868:	ec06                	sd	ra,24(sp)
    8000786a:	e822                	sd	s0,16(sp)
    8000786c:	e426                	sd	s1,8(sp)
    8000786e:	e04a                	sd	s2,0(sp)
    80007870:	1000                	addi	s0,sp,32
    80007872:	84aa                	mv	s1,a0
    80007874:	ffff9097          	auipc	ra,0xffff9
    80007878:	390080e7          	jalr	912(ra) # 80000c04 <kalloc>
    8000787c:	e088                	sd	a0,0(s1)
    8000787e:	c88d                	beqz	s1,800078b0 <sockalloc+0x4a>
    80007880:	6605                	lui	a2,0x1
    80007882:	4581                	li	a1,0
    80007884:	ffff9097          	auipc	ra,0xffff9
    80007888:	58a080e7          	jalr	1418(ra) # 80000e0e <memset>
    8000788c:	6088                	ld	a0,0(s1)
    8000788e:	00000097          	auipc	ra,0x0
    80007892:	f8a080e7          	jalr	-118(ra) # 80007818 <tcp_socket_list_insert>
    80007896:	892a                	mv	s2,a0
    80007898:	57fd                	li	a5,-1
    8000789a:	02f50563          	beq	a0,a5,800078c4 <sockalloc+0x5e>
    8000789e:	609c                	ld	a5,0(s1)
    800078a0:	c7a8                	sw	a0,72(a5)
    800078a2:	854a                	mv	a0,s2
    800078a4:	60e2                	ld	ra,24(sp)
    800078a6:	6442                	ld	s0,16(sp)
    800078a8:	64a2                	ld	s1,8(sp)
    800078aa:	6902                	ld	s2,0(sp)
    800078ac:	6105                	addi	sp,sp,32
    800078ae:	8082                	ret
    800078b0:	00003517          	auipc	a0,0x3
    800078b4:	10050513          	addi	a0,a0,256 # 8000a9b0 <etext+0x9b0>
    800078b8:	ffff9097          	auipc	ra,0xffff9
    800078bc:	cf2080e7          	jalr	-782(ra) # 800005aa <printf>
    800078c0:	597d                	li	s2,-1
    800078c2:	b7c5                	j	800078a2 <sockalloc+0x3c>
    800078c4:	00003517          	auipc	a0,0x3
    800078c8:	0fc50513          	addi	a0,a0,252 # 8000a9c0 <etext+0x9c0>
    800078cc:	ffff9097          	auipc	ra,0xffff9
    800078d0:	cde080e7          	jalr	-802(ra) # 800005aa <printf>
    800078d4:	6088                	ld	a0,0(s1)
    800078d6:	ffff9097          	auipc	ra,0xffff9
    800078da:	1c6080e7          	jalr	454(ra) # 80000a9c <kfree>
    800078de:	b7d1                	j	800078a2 <sockalloc+0x3c>

00000000800078e0 <bind>:
    800078e0:	7139                	addi	sp,sp,-64
    800078e2:	fc06                	sd	ra,56(sp)
    800078e4:	f822                	sd	s0,48(sp)
    800078e6:	ec4e                	sd	s3,24(sp)
    800078e8:	0080                	addi	s0,sp,64
    800078ea:	0c054a63          	bltz	a0,800079be <bind+0xde>
    800078ee:	f426                	sd	s1,40(sp)
    800078f0:	e05a                	sd	s6,0(sp)
    800078f2:	84ae                	mv	s1,a1
    800078f4:	8b32                	mv	s6,a2
    800078f6:	cdf1                	beqz	a1,800079d2 <bind+0xf2>
    800078f8:	f04a                	sd	s2,32(sp)
    800078fa:	e456                	sd	s5,8(sp)
    800078fc:	00007797          	auipc	a5,0x7
    80007900:	a0c7b783          	ld	a5,-1524(a5) # 8000e308 <tcp_sock_list>
    80007904:	639c                	ld	a5,0(a5)
    80007906:	050e                	slli	a0,a0,0x3
    80007908:	97aa                	add	a5,a5,a0
    8000790a:	0007b903          	ld	s2,0(a5)
    8000790e:	0025d503          	lhu	a0,2(a1)
    80007912:	00000097          	auipc	ra,0x0
    80007916:	764080e7          	jalr	1892(ra) # 80008076 <ntohs>
    8000791a:	8aaa                	mv	s5,a0
    8000791c:	0024d703          	lhu	a4,2(s1)
    80007920:	20000793          	li	a5,512
    80007924:	0ce7e363          	bltu	a5,a4,800079ea <bind+0x10a>
    80007928:	e852                	sd	s4,16(sp)
    8000792a:	00050a1b          	sext.w	s4,a0
    8000792e:	003a1713          	slli	a4,s4,0x3
    80007932:	00068797          	auipc	a5,0x68
    80007936:	0c678793          	addi	a5,a5,198 # 8006f9f8 <port_binds>
    8000793a:	97ba                	add	a5,a5,a4
    8000793c:	639c                	ld	a5,0(a5)
    8000793e:	e7e1                	bnez	a5,80007a06 <bind+0x126>
    80007940:	0004d783          	lhu	a5,0(s1)
    80007944:	0007899b          	sext.w	s3,a5
    80007948:	04f92023          	sw	a5,64(s2)
    8000794c:	14099363          	bnez	s3,80007a92 <bind+0x1b2>
    80007950:	47c1                	li	a5,16
    80007952:	0cfb1963          	bne	s6,a5,80007a24 <bind+0x144>
    80007956:	003a1713          	slli	a4,s4,0x3
    8000795a:	00068797          	auipc	a5,0x68
    8000795e:	09e78793          	addi	a5,a5,158 # 8006f9f8 <port_binds>
    80007962:	97ba                	add	a5,a5,a4
    80007964:	639c                	ld	a5,0(a5)
    80007966:	eff1                	bnez	a5,80007a42 <bind+0x162>
    80007968:	ffff9097          	auipc	ra,0xffff9
    8000796c:	29c080e7          	jalr	668(ra) # 80000c04 <kalloc>
    80007970:	c96d                	beqz	a0,80007a62 <bind+0x182>
    80007972:	01551123          	sh	s5,2(a0)
    80007976:	40dc                	lw	a5,4(s1)
    80007978:	4705                	li	a4,1
    8000797a:	10e78363          	beq	a5,a4,80007a80 <bind+0x1a0>
    8000797e:	00f51023          	sh	a5,0(a0)
    80007982:	40dc                	lw	a5,4(s1)
    80007984:	02f92423          	sw	a5,40(s2)
    80007988:	01253423          	sd	s2,8(a0)
    8000798c:	00255703          	lhu	a4,2(a0)
    80007990:	070e                	slli	a4,a4,0x3
    80007992:	00068797          	auipc	a5,0x68
    80007996:	06678793          	addi	a5,a5,102 # 8006f9f8 <port_binds>
    8000799a:	97ba                	add	a5,a5,a4
    8000799c:	e388                	sd	a0,0(a5)
    8000799e:	03492823          	sw	s4,48(s2)
    800079a2:	0004d783          	lhu	a5,0(s1)
    800079a6:	04f92023          	sw	a5,64(s2)
    800079aa:	03300793          	li	a5,51
    800079ae:	04f92223          	sw	a5,68(s2)
    800079b2:	74a2                	ld	s1,40(sp)
    800079b4:	7902                	ld	s2,32(sp)
    800079b6:	6a42                	ld	s4,16(sp)
    800079b8:	6aa2                	ld	s5,8(sp)
    800079ba:	6b02                	ld	s6,0(sp)
    800079bc:	a0cd                	j	80007a9e <bind+0x1be>
    800079be:	00003517          	auipc	a0,0x3
    800079c2:	01a50513          	addi	a0,a0,26 # 8000a9d8 <etext+0x9d8>
    800079c6:	ffff9097          	auipc	ra,0xffff9
    800079ca:	be4080e7          	jalr	-1052(ra) # 800005aa <printf>
    800079ce:	59fd                	li	s3,-1
    800079d0:	a0f9                	j	80007a9e <bind+0x1be>
    800079d2:	00003517          	auipc	a0,0x3
    800079d6:	01e50513          	addi	a0,a0,30 # 8000a9f0 <etext+0x9f0>
    800079da:	ffff9097          	auipc	ra,0xffff9
    800079de:	bd0080e7          	jalr	-1072(ra) # 800005aa <printf>
    800079e2:	59fd                	li	s3,-1
    800079e4:	74a2                	ld	s1,40(sp)
    800079e6:	6b02                	ld	s6,0(sp)
    800079e8:	a85d                	j	80007a9e <bind+0x1be>
    800079ea:	00003517          	auipc	a0,0x3
    800079ee:	02650513          	addi	a0,a0,38 # 8000aa10 <etext+0xa10>
    800079f2:	ffff9097          	auipc	ra,0xffff9
    800079f6:	bb8080e7          	jalr	-1096(ra) # 800005aa <printf>
    800079fa:	59fd                	li	s3,-1
    800079fc:	74a2                	ld	s1,40(sp)
    800079fe:	7902                	ld	s2,32(sp)
    80007a00:	6aa2                	ld	s5,8(sp)
    80007a02:	6b02                	ld	s6,0(sp)
    80007a04:	a869                	j	80007a9e <bind+0x1be>
    80007a06:	00003517          	auipc	a0,0x3
    80007a0a:	03a50513          	addi	a0,a0,58 # 8000aa40 <etext+0xa40>
    80007a0e:	ffff9097          	auipc	ra,0xffff9
    80007a12:	b9c080e7          	jalr	-1124(ra) # 800005aa <printf>
    80007a16:	59fd                	li	s3,-1
    80007a18:	74a2                	ld	s1,40(sp)
    80007a1a:	7902                	ld	s2,32(sp)
    80007a1c:	6a42                	ld	s4,16(sp)
    80007a1e:	6aa2                	ld	s5,8(sp)
    80007a20:	6b02                	ld	s6,0(sp)
    80007a22:	a8b5                	j	80007a9e <bind+0x1be>
    80007a24:	00003517          	auipc	a0,0x3
    80007a28:	04450513          	addi	a0,a0,68 # 8000aa68 <etext+0xa68>
    80007a2c:	ffff9097          	auipc	ra,0xffff9
    80007a30:	b7e080e7          	jalr	-1154(ra) # 800005aa <printf>
    80007a34:	59fd                	li	s3,-1
    80007a36:	74a2                	ld	s1,40(sp)
    80007a38:	7902                	ld	s2,32(sp)
    80007a3a:	6a42                	ld	s4,16(sp)
    80007a3c:	6aa2                	ld	s5,8(sp)
    80007a3e:	6b02                	ld	s6,0(sp)
    80007a40:	a8b9                	j	80007a9e <bind+0x1be>
    80007a42:	85d2                	mv	a1,s4
    80007a44:	00003517          	auipc	a0,0x3
    80007a48:	04c50513          	addi	a0,a0,76 # 8000aa90 <etext+0xa90>
    80007a4c:	ffff9097          	auipc	ra,0xffff9
    80007a50:	b5e080e7          	jalr	-1186(ra) # 800005aa <printf>
    80007a54:	59fd                	li	s3,-1
    80007a56:	74a2                	ld	s1,40(sp)
    80007a58:	7902                	ld	s2,32(sp)
    80007a5a:	6a42                	ld	s4,16(sp)
    80007a5c:	6aa2                	ld	s5,8(sp)
    80007a5e:	6b02                	ld	s6,0(sp)
    80007a60:	a83d                	j	80007a9e <bind+0x1be>
    80007a62:	00003517          	auipc	a0,0x3
    80007a66:	f4e50513          	addi	a0,a0,-178 # 8000a9b0 <etext+0x9b0>
    80007a6a:	ffff9097          	auipc	ra,0xffff9
    80007a6e:	b40080e7          	jalr	-1216(ra) # 800005aa <printf>
    80007a72:	59fd                	li	s3,-1
    80007a74:	74a2                	ld	s1,40(sp)
    80007a76:	7902                	ld	s2,32(sp)
    80007a78:	6a42                	ld	s4,16(sp)
    80007a7a:	6aa2                	ld	s5,8(sp)
    80007a7c:	6b02                	ld	s6,0(sp)
    80007a7e:	a005                	j	80007a9e <bind+0x1be>
    80007a80:	00069797          	auipc	a5,0x69
    80007a84:	f787a783          	lw	a5,-136(a5) # 800709f8 <netconf>
    80007a88:	02f92423          	sw	a5,40(s2)
    80007a8c:	00f51023          	sh	a5,0(a0)
    80007a90:	bde5                	j	80007988 <bind+0xa8>
    80007a92:	4981                	li	s3,0
    80007a94:	74a2                	ld	s1,40(sp)
    80007a96:	7902                	ld	s2,32(sp)
    80007a98:	6a42                	ld	s4,16(sp)
    80007a9a:	6aa2                	ld	s5,8(sp)
    80007a9c:	6b02                	ld	s6,0(sp)
    80007a9e:	854e                	mv	a0,s3
    80007aa0:	70e2                	ld	ra,56(sp)
    80007aa2:	7442                	ld	s0,48(sp)
    80007aa4:	69e2                	ld	s3,24(sp)
    80007aa6:	6121                	addi	sp,sp,64
    80007aa8:	8082                	ret

0000000080007aaa <listen>:
    80007aaa:	1141                	addi	sp,sp,-16
    80007aac:	e406                	sd	ra,8(sp)
    80007aae:	e022                	sd	s0,0(sp)
    80007ab0:	0800                	addi	s0,sp,16
    80007ab2:	00007797          	auipc	a5,0x7
    80007ab6:	8567b783          	ld	a5,-1962(a5) # 8000e308 <tcp_sock_list>
    80007aba:	639c                	ld	a5,0(a5)
    80007abc:	050e                	slli	a0,a0,0x3
    80007abe:	97aa                	add	a5,a5,a0
    80007ac0:	639c                	ld	a5,0(a5)
    80007ac2:	5fd4                	lw	a3,60(a5)
    80007ac4:	4705                	li	a4,1
    80007ac6:	00e69f63          	bne	a3,a4,80007ae4 <listen+0x3a>
    80007aca:	43f4                	lw	a3,68(a5)
    80007acc:	03300713          	li	a4,51
    80007ad0:	02e69463          	bne	a3,a4,80007af8 <listen+0x4e>
    80007ad4:	03400713          	li	a4,52
    80007ad8:	c3f8                	sw	a4,68(a5)
    80007ada:	4501                	li	a0,0
    80007adc:	60a2                	ld	ra,8(sp)
    80007ade:	6402                	ld	s0,0(sp)
    80007ae0:	0141                	addi	sp,sp,16
    80007ae2:	8082                	ret
    80007ae4:	00003517          	auipc	a0,0x3
    80007ae8:	fc450513          	addi	a0,a0,-60 # 8000aaa8 <etext+0xaa8>
    80007aec:	ffff9097          	auipc	ra,0xffff9
    80007af0:	abe080e7          	jalr	-1346(ra) # 800005aa <printf>
    80007af4:	557d                	li	a0,-1
    80007af6:	b7dd                	j	80007adc <listen+0x32>
    80007af8:	00003517          	auipc	a0,0x3
    80007afc:	fe050513          	addi	a0,a0,-32 # 8000aad8 <etext+0xad8>
    80007b00:	ffff9097          	auipc	ra,0xffff9
    80007b04:	aaa080e7          	jalr	-1366(ra) # 800005aa <printf>
    80007b08:	557d                	li	a0,-1
    80007b0a:	bfc9                	j	80007adc <listen+0x32>

0000000080007b0c <accept>:
    80007b0c:	7179                	addi	sp,sp,-48
    80007b0e:	f406                	sd	ra,40(sp)
    80007b10:	f022                	sd	s0,32(sp)
    80007b12:	ec26                	sd	s1,24(sp)
    80007b14:	1800                	addi	s0,sp,48
    80007b16:	00006797          	auipc	a5,0x6
    80007b1a:	7f27b783          	ld	a5,2034(a5) # 8000e308 <tcp_sock_list>
    80007b1e:	639c                	ld	a5,0(a5)
    80007b20:	050e                	slli	a0,a0,0x3
    80007b22:	97aa                	add	a5,a5,a0
    80007b24:	6384                	ld	s1,0(a5)
    80007b26:	5c98                	lw	a4,56(s1)
    80007b28:	47c1                	li	a5,16
    80007b2a:	06f71963          	bne	a4,a5,80007b9c <accept+0x90>
    80007b2e:	5cd8                	lw	a4,60(s1)
    80007b30:	4785                	li	a5,1
    80007b32:	06f71563          	bne	a4,a5,80007b9c <accept+0x90>
    80007b36:	40f8                	lw	a4,68(s1)
    80007b38:	03400793          	li	a5,52
    80007b3c:	06f71a63          	bne	a4,a5,80007bb0 <accept+0xa4>
    80007b40:	e84a                	sd	s2,16(sp)
    80007b42:	e44e                	sd	s3,8(sp)
    80007b44:	01048993          	addi	s3,s1,16
    80007b48:	854e                	mv	a0,s3
    80007b4a:	ffff9097          	auipc	ra,0xffff9
    80007b4e:	1cc080e7          	jalr	460(ra) # 80000d16 <acquire>
    80007b52:	0084b903          	ld	s2,8(s1)
    80007b56:	00091c63          	bnez	s2,80007b6e <accept+0x62>
    80007b5a:	85ce                	mv	a1,s3
    80007b5c:	8526                	mv	a0,s1
    80007b5e:	ffffb097          	auipc	ra,0xffffb
    80007b62:	baa080e7          	jalr	-1110(ra) # 80002708 <sleep>
    80007b66:	0084b903          	ld	s2,8(s1)
    80007b6a:	fe0908e3          	beqz	s2,80007b5a <accept+0x4e>
    80007b6e:	00093423          	sd	zero,8(s2)
    80007b72:	854e                	mv	a0,s3
    80007b74:	ffff9097          	auipc	ra,0xffff9
    80007b78:	252080e7          	jalr	594(ra) # 80000dc6 <release>
    80007b7c:	ffffd097          	auipc	ra,0xffffd
    80007b80:	4c2080e7          	jalr	1218(ra) # 8000503e <filealloc>
    80007b84:	00a93023          	sd	a0,0(s2)
    80007b88:	cd15                	beqz	a0,80007bc4 <accept+0xb8>
    80007b8a:	04892503          	lw	a0,72(s2)
    80007b8e:	6942                	ld	s2,16(sp)
    80007b90:	69a2                	ld	s3,8(sp)
    80007b92:	70a2                	ld	ra,40(sp)
    80007b94:	7402                	ld	s0,32(sp)
    80007b96:	64e2                	ld	s1,24(sp)
    80007b98:	6145                	addi	sp,sp,48
    80007b9a:	8082                	ret
    80007b9c:	00003517          	auipc	a0,0x3
    80007ba0:	f5c50513          	addi	a0,a0,-164 # 8000aaf8 <etext+0xaf8>
    80007ba4:	ffff9097          	auipc	ra,0xffff9
    80007ba8:	a06080e7          	jalr	-1530(ra) # 800005aa <printf>
    80007bac:	557d                	li	a0,-1
    80007bae:	b7d5                	j	80007b92 <accept+0x86>
    80007bb0:	00003517          	auipc	a0,0x3
    80007bb4:	f8050513          	addi	a0,a0,-128 # 8000ab30 <etext+0xb30>
    80007bb8:	ffff9097          	auipc	ra,0xffff9
    80007bbc:	9f2080e7          	jalr	-1550(ra) # 800005aa <printf>
    80007bc0:	557d                	li	a0,-1
    80007bc2:	bfc1                	j	80007b92 <accept+0x86>
    80007bc4:	00003517          	auipc	a0,0x3
    80007bc8:	f9450513          	addi	a0,a0,-108 # 8000ab58 <etext+0xb58>
    80007bcc:	ffff9097          	auipc	ra,0xffff9
    80007bd0:	9de080e7          	jalr	-1570(ra) # 800005aa <printf>
    80007bd4:	557d                	li	a0,-1
    80007bd6:	6942                	ld	s2,16(sp)
    80007bd8:	69a2                	ld	s3,8(sp)
    80007bda:	bf65                	j	80007b92 <accept+0x86>

0000000080007bdc <connect>:
    80007bdc:	1141                	addi	sp,sp,-16
    80007bde:	e406                	sd	ra,8(sp)
    80007be0:	e022                	sd	s0,0(sp)
    80007be2:	0800                	addi	s0,sp,16
    80007be4:	4501                	li	a0,0
    80007be6:	60a2                	ld	ra,8(sp)
    80007be8:	6402                	ld	s0,0(sp)
    80007bea:	0141                	addi	sp,sp,16
    80007bec:	8082                	ret

0000000080007bee <tcp_socket_list_remove>:
    80007bee:	050e                	slli	a0,a0,0x3
    80007bf0:	00006797          	auipc	a5,0x6
    80007bf4:	7187b783          	ld	a5,1816(a5) # 8000e308 <tcp_sock_list>
    80007bf8:	639c                	ld	a5,0(a5)
    80007bfa:	97aa                	add	a5,a5,a0
    80007bfc:	6398                	ld	a4,0(a5)
    80007bfe:	cf01                	beqz	a4,80007c16 <tcp_socket_list_remove+0x28>
    80007c00:	0007b023          	sd	zero,0(a5)
    80007c04:	00006717          	auipc	a4,0x6
    80007c08:	70473703          	ld	a4,1796(a4) # 8000e308 <tcp_sock_list>
    80007c0c:	471c                	lw	a5,8(a4)
    80007c0e:	37fd                	addiw	a5,a5,-1
    80007c10:	c71c                	sw	a5,8(a4)
    80007c12:	4505                	li	a0,1
    80007c14:	8082                	ret
    80007c16:	1141                	addi	sp,sp,-16
    80007c18:	e406                	sd	ra,8(sp)
    80007c1a:	e022                	sd	s0,0(sp)
    80007c1c:	0800                	addi	s0,sp,16
    80007c1e:	00003517          	auipc	a0,0x3
    80007c22:	f6250513          	addi	a0,a0,-158 # 8000ab80 <etext+0xb80>
    80007c26:	ffff9097          	auipc	ra,0xffff9
    80007c2a:	984080e7          	jalr	-1660(ra) # 800005aa <printf>
    80007c2e:	557d                	li	a0,-1
    80007c30:	60a2                	ld	ra,8(sp)
    80007c32:	6402                	ld	s0,0(sp)
    80007c34:	0141                	addi	sp,sp,16
    80007c36:	8082                	ret

0000000080007c38 <socket>:
    80007c38:	7139                	addi	sp,sp,-64
    80007c3a:	fc06                	sd	ra,56(sp)
    80007c3c:	f822                	sd	s0,48(sp)
    80007c3e:	e852                	sd	s4,16(sp)
    80007c40:	0080                	addi	s0,sp,64
    80007c42:	e53d                	bnez	a0,80007cb0 <socket+0x78>
    80007c44:	f426                	sd	s1,40(sp)
    80007c46:	f04a                	sd	s2,32(sp)
    80007c48:	892e                	mv	s2,a1
    80007c4a:	84b2                	mv	s1,a2
    80007c4c:	fff5879b          	addiw	a5,a1,-1
    80007c50:	4705                	li	a4,1
    80007c52:	06f76963          	bltu	a4,a5,80007cc4 <socket+0x8c>
    80007c56:	e259                	bnez	a2,80007cdc <socket+0xa4>
    80007c58:	4785                	li	a5,1
    80007c5a:	44c5                	li	s1,17
    80007c5c:	0cf58363          	beq	a1,a5,80007d22 <socket+0xea>
    80007c60:	fef48793          	addi	a5,s1,-17
    80007c64:	e781                	bnez	a5,80007c6c <socket+0x34>
    80007c66:	ffe90793          	addi	a5,s2,-2
    80007c6a:	e7c1                	bnez	a5,80007cf2 <socket+0xba>
    80007c6c:	fc840513          	addi	a0,s0,-56
    80007c70:	00000097          	auipc	ra,0x0
    80007c74:	bf6080e7          	jalr	-1034(ra) # 80007866 <sockalloc>
    80007c78:	8a2a                	mv	s4,a0
    80007c7a:	57fd                	li	a5,-1
    80007c7c:	0af50563          	beq	a0,a5,80007d26 <socket+0xee>
    80007c80:	ec4e                	sd	s3,24(sp)
    80007c82:	fc843983          	ld	s3,-56(s0)
    80007c86:	ffffd097          	auipc	ra,0xffffd
    80007c8a:	3b8080e7          	jalr	952(ra) # 8000503e <filealloc>
    80007c8e:	00a9b023          	sd	a0,0(s3)
    80007c92:	c54d                	beqz	a0,80007d3c <socket+0x104>
    80007c94:	47c1                	li	a5,16
    80007c96:	0cf48063          	beq	s1,a5,80007d56 <socket+0x11e>
    80007c9a:	00006797          	auipc	a5,0x6
    80007c9e:	6667b783          	ld	a5,1638(a5) # 8000e300 <udp_sock_list>
    80007ca2:	639c                	ld	a5,0(a5)
    80007ca4:	003a1713          	slli	a4,s4,0x3
    80007ca8:	97ba                	add	a5,a5,a4
    80007caa:	0137b023          	sd	s3,0(a5)
    80007cae:	a875                	j	80007d6a <socket+0x132>
    80007cb0:	00003517          	auipc	a0,0x3
    80007cb4:	ef850513          	addi	a0,a0,-264 # 8000aba8 <etext+0xba8>
    80007cb8:	ffff9097          	auipc	ra,0xffff9
    80007cbc:	8f2080e7          	jalr	-1806(ra) # 800005aa <printf>
    80007cc0:	5a7d                	li	s4,-1
    80007cc2:	a0f9                	j	80007d90 <socket+0x158>
    80007cc4:	00003517          	auipc	a0,0x3
    80007cc8:	f0450513          	addi	a0,a0,-252 # 8000abc8 <etext+0xbc8>
    80007ccc:	ffff9097          	auipc	ra,0xffff9
    80007cd0:	8de080e7          	jalr	-1826(ra) # 800005aa <printf>
    80007cd4:	5a7d                	li	s4,-1
    80007cd6:	74a2                	ld	s1,40(sp)
    80007cd8:	7902                	ld	s2,32(sp)
    80007cda:	a85d                	j	80007d90 <socket+0x158>
    80007cdc:	ff06079b          	addiw	a5,a2,-16 # ff0 <_entry-0x7ffff010>
    80007ce0:	4705                	li	a4,1
    80007ce2:	02f76463          	bltu	a4,a5,80007d0a <socket+0xd2>
    80007ce6:	ff060793          	addi	a5,a2,-16
    80007cea:	fbbd                	bnez	a5,80007c60 <socket+0x28>
    80007cec:	fff58793          	addi	a5,a1,-1
    80007cf0:	dba5                	beqz	a5,80007c60 <socket+0x28>
    80007cf2:	00003517          	auipc	a0,0x3
    80007cf6:	f1650513          	addi	a0,a0,-234 # 8000ac08 <etext+0xc08>
    80007cfa:	ffff9097          	auipc	ra,0xffff9
    80007cfe:	8b0080e7          	jalr	-1872(ra) # 800005aa <printf>
    80007d02:	5a7d                	li	s4,-1
    80007d04:	74a2                	ld	s1,40(sp)
    80007d06:	7902                	ld	s2,32(sp)
    80007d08:	a061                	j	80007d90 <socket+0x158>
    80007d0a:	00003517          	auipc	a0,0x3
    80007d0e:	ede50513          	addi	a0,a0,-290 # 8000abe8 <etext+0xbe8>
    80007d12:	ffff9097          	auipc	ra,0xffff9
    80007d16:	898080e7          	jalr	-1896(ra) # 800005aa <printf>
    80007d1a:	5a7d                	li	s4,-1
    80007d1c:	74a2                	ld	s1,40(sp)
    80007d1e:	7902                	ld	s2,32(sp)
    80007d20:	a885                	j	80007d90 <socket+0x158>
    80007d22:	44c1                	li	s1,16
    80007d24:	b7a1                	j	80007c6c <socket+0x34>
    80007d26:	00003517          	auipc	a0,0x3
    80007d2a:	f1250513          	addi	a0,a0,-238 # 8000ac38 <etext+0xc38>
    80007d2e:	ffff9097          	auipc	ra,0xffff9
    80007d32:	87c080e7          	jalr	-1924(ra) # 800005aa <printf>
    80007d36:	74a2                	ld	s1,40(sp)
    80007d38:	7902                	ld	s2,32(sp)
    80007d3a:	a899                	j	80007d90 <socket+0x158>
    80007d3c:	00003517          	auipc	a0,0x3
    80007d40:	f1c50513          	addi	a0,a0,-228 # 8000ac58 <etext+0xc58>
    80007d44:	ffff9097          	auipc	ra,0xffff9
    80007d48:	866080e7          	jalr	-1946(ra) # 800005aa <printf>
    80007d4c:	5a7d                	li	s4,-1
    80007d4e:	74a2                	ld	s1,40(sp)
    80007d50:	7902                	ld	s2,32(sp)
    80007d52:	69e2                	ld	s3,24(sp)
    80007d54:	a835                	j	80007d90 <socket+0x158>
    80007d56:	00006797          	auipc	a5,0x6
    80007d5a:	5b27b783          	ld	a5,1458(a5) # 8000e308 <tcp_sock_list>
    80007d5e:	639c                	ld	a5,0(a5)
    80007d60:	003a1713          	slli	a4,s4,0x3
    80007d64:	97ba                	add	a5,a5,a4
    80007d66:	0137b023          	sd	s3,0(a5)
    80007d6a:	0299ac23          	sw	s1,56(s3)
    80007d6e:	00069797          	auipc	a5,0x69
    80007d72:	c8a7a783          	lw	a5,-886(a5) # 800709f8 <netconf>
    80007d76:	02f9a423          	sw	a5,40(s3)
    80007d7a:	0329ae23          	sw	s2,60(s3)
    80007d7e:	0409a023          	sw	zero,64(s3)
    80007d82:	03200793          	li	a5,50
    80007d86:	04f9a223          	sw	a5,68(s3)
    80007d8a:	74a2                	ld	s1,40(sp)
    80007d8c:	7902                	ld	s2,32(sp)
    80007d8e:	69e2                	ld	s3,24(sp)
    80007d90:	8552                	mv	a0,s4
    80007d92:	70e2                	ld	ra,56(sp)
    80007d94:	7442                	ld	s0,48(sp)
    80007d96:	6a42                	ld	s4,16(sp)
    80007d98:	6121                	addi	sp,sp,64
    80007d9a:	8082                	ret

0000000080007d9c <close>:
    80007d9c:	1141                	addi	sp,sp,-16
    80007d9e:	e406                	sd	ra,8(sp)
    80007da0:	e022                	sd	s0,0(sp)
    80007da2:	0800                	addi	s0,sp,16
    80007da4:	4501                	li	a0,0
    80007da6:	60a2                	ld	ra,8(sp)
    80007da8:	6402                	ld	s0,0(sp)
    80007daa:	0141                	addi	sp,sp,16
    80007dac:	8082                	ret

0000000080007dae <tcp_sock_list_init>:
    80007dae:	1101                	addi	sp,sp,-32
    80007db0:	ec06                	sd	ra,24(sp)
    80007db2:	e822                	sd	s0,16(sp)
    80007db4:	1000                	addi	s0,sp,32
    80007db6:	ffff9097          	auipc	ra,0xffff9
    80007dba:	e4e080e7          	jalr	-434(ra) # 80000c04 <kalloc>
    80007dbe:	00006797          	auipc	a5,0x6
    80007dc2:	54a7b523          	sd	a0,1354(a5) # 8000e308 <tcp_sock_list>
    80007dc6:	c90d                	beqz	a0,80007df8 <tcp_sock_list_init+0x4a>
    80007dc8:	e426                	sd	s1,8(sp)
    80007dca:	84aa                	mv	s1,a0
    80007dcc:	ffff9097          	auipc	ra,0xffff9
    80007dd0:	e38080e7          	jalr	-456(ra) # 80000c04 <kalloc>
    80007dd4:	e088                	sd	a0,0(s1)
    80007dd6:	00006797          	auipc	a5,0x6
    80007dda:	5327b783          	ld	a5,1330(a5) # 8000e308 <tcp_sock_list>
    80007dde:	6388                	ld	a0,0(a5)
    80007de0:	c50d                	beqz	a0,80007e0a <tcp_sock_list_init+0x5c>
    80007de2:	6605                	lui	a2,0x1
    80007de4:	4581                	li	a1,0
    80007de6:	ffff9097          	auipc	ra,0xffff9
    80007dea:	028080e7          	jalr	40(ra) # 80000e0e <memset>
    80007dee:	64a2                	ld	s1,8(sp)
    80007df0:	60e2                	ld	ra,24(sp)
    80007df2:	6442                	ld	s0,16(sp)
    80007df4:	6105                	addi	sp,sp,32
    80007df6:	8082                	ret
    80007df8:	00003517          	auipc	a0,0x3
    80007dfc:	e7850513          	addi	a0,a0,-392 # 8000ac70 <etext+0xc70>
    80007e00:	ffff8097          	auipc	ra,0xffff8
    80007e04:	7aa080e7          	jalr	1962(ra) # 800005aa <printf>
    80007e08:	b7e5                	j	80007df0 <tcp_sock_list_init+0x42>
    80007e0a:	00003517          	auipc	a0,0x3
    80007e0e:	e9650513          	addi	a0,a0,-362 # 8000aca0 <etext+0xca0>
    80007e12:	ffff8097          	auipc	ra,0xffff8
    80007e16:	798080e7          	jalr	1944(ra) # 800005aa <printf>
    80007e1a:	00006517          	auipc	a0,0x6
    80007e1e:	4ee53503          	ld	a0,1262(a0) # 8000e308 <tcp_sock_list>
    80007e22:	ffff9097          	auipc	ra,0xffff9
    80007e26:	c7a080e7          	jalr	-902(ra) # 80000a9c <kfree>
    80007e2a:	64a2                	ld	s1,8(sp)
    80007e2c:	b7d1                	j	80007df0 <tcp_sock_list_init+0x42>

0000000080007e2e <udp_sock_list_init>:
    80007e2e:	1101                	addi	sp,sp,-32
    80007e30:	ec06                	sd	ra,24(sp)
    80007e32:	e822                	sd	s0,16(sp)
    80007e34:	1000                	addi	s0,sp,32
    80007e36:	ffff9097          	auipc	ra,0xffff9
    80007e3a:	dce080e7          	jalr	-562(ra) # 80000c04 <kalloc>
    80007e3e:	00006797          	auipc	a5,0x6
    80007e42:	4ca7b123          	sd	a0,1218(a5) # 8000e300 <udp_sock_list>
    80007e46:	c90d                	beqz	a0,80007e78 <udp_sock_list_init+0x4a>
    80007e48:	e426                	sd	s1,8(sp)
    80007e4a:	84aa                	mv	s1,a0
    80007e4c:	ffff9097          	auipc	ra,0xffff9
    80007e50:	db8080e7          	jalr	-584(ra) # 80000c04 <kalloc>
    80007e54:	e088                	sd	a0,0(s1)
    80007e56:	00006797          	auipc	a5,0x6
    80007e5a:	4aa7b783          	ld	a5,1194(a5) # 8000e300 <udp_sock_list>
    80007e5e:	6388                	ld	a0,0(a5)
    80007e60:	c50d                	beqz	a0,80007e8a <udp_sock_list_init+0x5c>
    80007e62:	6605                	lui	a2,0x1
    80007e64:	4581                	li	a1,0
    80007e66:	ffff9097          	auipc	ra,0xffff9
    80007e6a:	fa8080e7          	jalr	-88(ra) # 80000e0e <memset>
    80007e6e:	64a2                	ld	s1,8(sp)
    80007e70:	60e2                	ld	ra,24(sp)
    80007e72:	6442                	ld	s0,16(sp)
    80007e74:	6105                	addi	sp,sp,32
    80007e76:	8082                	ret
    80007e78:	00003517          	auipc	a0,0x3
    80007e7c:	e5850513          	addi	a0,a0,-424 # 8000acd0 <etext+0xcd0>
    80007e80:	ffff8097          	auipc	ra,0xffff8
    80007e84:	72a080e7          	jalr	1834(ra) # 800005aa <printf>
    80007e88:	b7e5                	j	80007e70 <udp_sock_list_init+0x42>
    80007e8a:	00003517          	auipc	a0,0x3
    80007e8e:	e7650513          	addi	a0,a0,-394 # 8000ad00 <etext+0xd00>
    80007e92:	ffff8097          	auipc	ra,0xffff8
    80007e96:	718080e7          	jalr	1816(ra) # 800005aa <printf>
    80007e9a:	00006517          	auipc	a0,0x6
    80007e9e:	46653503          	ld	a0,1126(a0) # 8000e300 <udp_sock_list>
    80007ea2:	ffff9097          	auipc	ra,0xffff9
    80007ea6:	bfa080e7          	jalr	-1030(ra) # 80000a9c <kfree>
    80007eaa:	64a2                	ld	s1,8(sp)
    80007eac:	b7d1                	j	80007e70 <udp_sock_list_init+0x42>

0000000080007eae <socket_init>:
    80007eae:	1141                	addi	sp,sp,-16
    80007eb0:	e406                	sd	ra,8(sp)
    80007eb2:	e022                	sd	s0,0(sp)
    80007eb4:	0800                	addi	s0,sp,16
    80007eb6:	00000097          	auipc	ra,0x0
    80007eba:	ef8080e7          	jalr	-264(ra) # 80007dae <tcp_sock_list_init>
    80007ebe:	00000097          	auipc	ra,0x0
    80007ec2:	f70080e7          	jalr	-144(ra) # 80007e2e <udp_sock_list_init>
    80007ec6:	60a2                	ld	ra,8(sp)
    80007ec8:	6402                	ld	s0,0(sp)
    80007eca:	0141                	addi	sp,sp,16
    80007ecc:	8082                	ret

0000000080007ece <my_strlen>:
    80007ece:	1141                	addi	sp,sp,-16
    80007ed0:	e406                	sd	ra,8(sp)
    80007ed2:	e022                	sd	s0,0(sp)
    80007ed4:	0800                	addi	s0,sp,16
    80007ed6:	00054703          	lbu	a4,0(a0)
    80007eda:	00150793          	addi	a5,a0,1
    80007ede:	cf01                	beqz	a4,80007ef6 <my_strlen+0x28>
    80007ee0:	86be                	mv	a3,a5
    80007ee2:	0785                	addi	a5,a5,1
    80007ee4:	fff7c703          	lbu	a4,-1(a5)
    80007ee8:	ff65                	bnez	a4,80007ee0 <my_strlen+0x12>
    80007eea:	40a6853b          	subw	a0,a3,a0
    80007eee:	60a2                	ld	ra,8(sp)
    80007ef0:	6402                	ld	s0,0(sp)
    80007ef2:	0141                	addi	sp,sp,16
    80007ef4:	8082                	ret
    80007ef6:	4501                	li	a0,0
    80007ef8:	bfdd                	j	80007eee <my_strlen+0x20>

0000000080007efa <getaddrinfo>:
    80007efa:	1141                	addi	sp,sp,-16
    80007efc:	e406                	sd	ra,8(sp)
    80007efe:	e022                	sd	s0,0(sp)
    80007f00:	0800                	addi	s0,sp,16
    80007f02:	4501                	li	a0,0
    80007f04:	60a2                	ld	ra,8(sp)
    80007f06:	6402                	ld	s0,0(sp)
    80007f08:	0141                	addi	sp,sp,16
    80007f0a:	8082                	ret

0000000080007f0c <freeaddrinfo>:
    80007f0c:	1141                	addi	sp,sp,-16
    80007f0e:	e406                	sd	ra,8(sp)
    80007f10:	e022                	sd	s0,0(sp)
    80007f12:	0800                	addi	s0,sp,16
    80007f14:	4501                	li	a0,0
    80007f16:	60a2                	ld	ra,8(sp)
    80007f18:	6402                	ld	s0,0(sp)
    80007f1a:	0141                	addi	sp,sp,16
    80007f1c:	8082                	ret

0000000080007f1e <ip_to_u32>:
    80007f1e:	1101                	addi	sp,sp,-32
    80007f20:	ec06                	sd	ra,24(sp)
    80007f22:	e822                	sd	s0,16(sp)
    80007f24:	1000                	addi	s0,sp,32
    80007f26:	fe043023          	sd	zero,-32(s0)
    80007f2a:	fe043423          	sd	zero,-24(s0)
    80007f2e:	00054783          	lbu	a5,0(a0)
    80007f32:	c3dd                	beqz	a5,80007fd8 <ip_to_u32+0xba>
    80007f34:	fe040593          	addi	a1,s0,-32
    80007f38:	4801                	li	a6,0
    80007f3a:	4625                	li	a2,9
    80007f3c:	0ff00313          	li	t1,255
    80007f40:	02e00893          	li	a7,46
    80007f44:	a809                	j	80007f56 <ip_to_u32+0x38>
    80007f46:	0505                	addi	a0,a0,1
    80007f48:	0591                	addi	a1,a1,4
    80007f4a:	00054703          	lbu	a4,0(a0)
    80007f4e:	cf29                	beqz	a4,80007fa8 <ip_to_u32+0x8a>
    80007f50:	0047a793          	slti	a5,a5,4
    80007f54:	cbb1                	beqz	a5,80007fa8 <ip_to_u32+0x8a>
    80007f56:	00054703          	lbu	a4,0(a0)
    80007f5a:	fd07079b          	addiw	a5,a4,-48
    80007f5e:	0ff7f793          	zext.b	a5,a5
    80007f62:	4681                	li	a3,0
    80007f64:	02f66663          	bltu	a2,a5,80007f90 <ip_to_u32+0x72>
    80007f68:	0026979b          	slliw	a5,a3,0x2
    80007f6c:	9fb5                	addw	a5,a5,a3
    80007f6e:	0017979b          	slliw	a5,a5,0x1
    80007f72:	fd07071b          	addiw	a4,a4,-48
    80007f76:	00f706bb          	addw	a3,a4,a5
    80007f7a:	0505                	addi	a0,a0,1
    80007f7c:	00054703          	lbu	a4,0(a0)
    80007f80:	fd07079b          	addiw	a5,a4,-48
    80007f84:	0ff7f793          	zext.b	a5,a5
    80007f88:	fef670e3          	bgeu	a2,a5,80007f68 <ip_to_u32+0x4a>
    80007f8c:	04d36863          	bltu	t1,a3,80007fdc <ip_to_u32+0xbe>
    80007f90:	0018079b          	addiw	a5,a6,1
    80007f94:	883e                	mv	a6,a5
    80007f96:	c194                	sw	a3,0(a1)
    80007f98:	fb1707e3          	beq	a4,a7,80007f46 <ip_to_u32+0x28>
    80007f9c:	0047a693          	slti	a3,a5,4
    80007fa0:	d6c5                	beqz	a3,80007f48 <ip_to_u32+0x2a>
    80007fa2:	d35d                	beqz	a4,80007f48 <ip_to_u32+0x2a>
    80007fa4:	557d                	li	a0,-1
    80007fa6:	a02d                	j	80007fd0 <ip_to_u32+0xb2>
    80007fa8:	4791                	li	a5,4
    80007faa:	02f81b63          	bne	a6,a5,80007fe0 <ip_to_u32+0xc2>
    80007fae:	fe042783          	lw	a5,-32(s0)
    80007fb2:	0187979b          	slliw	a5,a5,0x18
    80007fb6:	fe442703          	lw	a4,-28(s0)
    80007fba:	0107171b          	slliw	a4,a4,0x10
    80007fbe:	8fd9                	or	a5,a5,a4
    80007fc0:	fec42703          	lw	a4,-20(s0)
    80007fc4:	8fd9                	or	a5,a5,a4
    80007fc6:	fe842503          	lw	a0,-24(s0)
    80007fca:	0085151b          	slliw	a0,a0,0x8
    80007fce:	8d5d                	or	a0,a0,a5
    80007fd0:	60e2                	ld	ra,24(sp)
    80007fd2:	6442                	ld	s0,16(sp)
    80007fd4:	6105                	addi	sp,sp,32
    80007fd6:	8082                	ret
    80007fd8:	557d                	li	a0,-1
    80007fda:	bfdd                	j	80007fd0 <ip_to_u32+0xb2>
    80007fdc:	557d                	li	a0,-1
    80007fde:	bfcd                	j	80007fd0 <ip_to_u32+0xb2>
    80007fe0:	557d                	li	a0,-1
    80007fe2:	b7fd                	j	80007fd0 <ip_to_u32+0xb2>

0000000080007fe4 <node_to_dns>:
    80007fe4:	1101                	addi	sp,sp,-32
    80007fe6:	ec06                	sd	ra,24(sp)
    80007fe8:	e822                	sd	s0,16(sp)
    80007fea:	e426                	sd	s1,8(sp)
    80007fec:	e04a                	sd	s2,0(sp)
    80007fee:	1000                	addi	s0,sp,32
    80007ff0:	892a                	mv	s2,a0
    80007ff2:	84ae                	mv	s1,a1
    80007ff4:	00000097          	auipc	ra,0x0
    80007ff8:	eda080e7          	jalr	-294(ra) # 80007ece <my_strlen>
    80007ffc:	0fd00793          	li	a5,253
    80008000:	06a7c263          	blt	a5,a0,80008064 <node_to_dns+0x80>
    80008004:	4785                	li	a5,1
    80008006:	4601                	li	a2,0
    80008008:	04000893          	li	a7,64
    8000800c:	02055463          	bgez	a0,80008034 <node_to_dns+0x50>
    80008010:	94aa                	add	s1,s1,a0
    80008012:	000480a3          	sb	zero,1(s1)
    80008016:	4501                	li	a0,0
    80008018:	a0b9                	j	80008066 <node_to_dns+0x82>
    8000801a:	00c485b3          	add	a1,s1,a2
    8000801e:	fff7871b          	addiw	a4,a5,-1
    80008022:	9f11                	subw	a4,a4,a2
    80008024:	00e58023          	sb	a4,0(a1)
    80008028:	0007871b          	sext.w	a4,a5
    8000802c:	fee542e3          	blt	a0,a4,80008010 <node_to_dns+0x2c>
    80008030:	0785                	addi	a5,a5,1
    80008032:	8636                	mv	a2,a3
    80008034:	0007869b          	sext.w	a3,a5
    80008038:	00f90733          	add	a4,s2,a5
    8000803c:	fff74703          	lbu	a4,-1(a4)
    80008040:	fd270813          	addi	a6,a4,-46
    80008044:	fc080be3          	beqz	a6,8000801a <node_to_dns+0x36>
    80008048:	db69                	beqz	a4,8000801a <node_to_dns+0x36>
    8000804a:	00f485b3          	add	a1,s1,a5
    8000804e:	00e58023          	sb	a4,0(a1)
    80008052:	0007871b          	sext.w	a4,a5
    80008056:	fae54de3          	blt	a0,a4,80008010 <node_to_dns+0x2c>
    8000805a:	9e91                	subw	a3,a3,a2
    8000805c:	01168b63          	beq	a3,a7,80008072 <node_to_dns+0x8e>
    80008060:	0785                	addi	a5,a5,1
    80008062:	bfc9                	j	80008034 <node_to_dns+0x50>
    80008064:	4505                	li	a0,1
    80008066:	60e2                	ld	ra,24(sp)
    80008068:	6442                	ld	s0,16(sp)
    8000806a:	64a2                	ld	s1,8(sp)
    8000806c:	6902                	ld	s2,0(sp)
    8000806e:	6105                	addi	sp,sp,32
    80008070:	8082                	ret
    80008072:	4509                	li	a0,2
    80008074:	bfcd                	j	80008066 <node_to_dns+0x82>

0000000080008076 <ntohs>:
    80008076:	1141                	addi	sp,sp,-16
    80008078:	e406                	sd	ra,8(sp)
    8000807a:	e022                	sd	s0,0(sp)
    8000807c:	0800                	addi	s0,sp,16
    8000807e:	0085579b          	srliw	a5,a0,0x8
    80008082:	0085151b          	slliw	a0,a0,0x8
    80008086:	9d3d                	addw	a0,a0,a5
    80008088:	1542                	slli	a0,a0,0x30
    8000808a:	9141                	srli	a0,a0,0x30
    8000808c:	60a2                	ld	ra,8(sp)
    8000808e:	6402                	ld	s0,0(sp)
    80008090:	0141                	addi	sp,sp,16
    80008092:	8082                	ret

0000000080008094 <htons>:
    80008094:	1141                	addi	sp,sp,-16
    80008096:	e406                	sd	ra,8(sp)
    80008098:	e022                	sd	s0,0(sp)
    8000809a:	0800                	addi	s0,sp,16
    8000809c:	0085579b          	srliw	a5,a0,0x8
    800080a0:	0085151b          	slliw	a0,a0,0x8
    800080a4:	9d3d                	addw	a0,a0,a5
    800080a6:	1542                	slli	a0,a0,0x30
    800080a8:	9141                	srli	a0,a0,0x30
    800080aa:	60a2                	ld	ra,8(sp)
    800080ac:	6402                	ld	s0,0(sp)
    800080ae:	0141                	addi	sp,sp,16
    800080b0:	8082                	ret

00000000800080b2 <net_init>:
    800080b2:	1141                	addi	sp,sp,-16
    800080b4:	e406                	sd	ra,8(sp)
    800080b6:	e022                	sd	s0,0(sp)
    800080b8:	0800                	addi	s0,sp,16
    800080ba:	c0a807b7          	lui	a5,0xc0a80
    800080be:	0789                	addi	a5,a5,2 # ffffffffc0a80002 <end+0xffffffff40a0f5f6>
    800080c0:	00069717          	auipc	a4,0x69
    800080c4:	92f72c23          	sw	a5,-1736(a4) # 800709f8 <netconf>
    800080c8:	00068797          	auipc	a5,0x68
    800080cc:	8b878793          	addi	a5,a5,-1864 # 8006f980 <net>
    800080d0:	00069717          	auipc	a4,0x69
    800080d4:	92c70713          	addi	a4,a4,-1748 # 800709fc <netconf+0x4>
    800080d8:	00068617          	auipc	a2,0x68
    800080dc:	8ae60613          	addi	a2,a2,-1874 # 8006f986 <net+0x6>
    800080e0:	0007c683          	lbu	a3,0(a5)
    800080e4:	00d70023          	sb	a3,0(a4)
    800080e8:	0785                	addi	a5,a5,1
    800080ea:	0705                	addi	a4,a4,1
    800080ec:	fec79ae3          	bne	a5,a2,800080e0 <net_init+0x2e>
    800080f0:	00069797          	auipc	a5,0x69
    800080f4:	90878793          	addi	a5,a5,-1784 # 800709f8 <netconf>
    800080f8:	0007a823          	sw	zero,16(a5)
    800080fc:	0007a623          	sw	zero,12(a5)
    80008100:	4501                	li	a0,0
    80008102:	60a2                	ld	ra,8(sp)
    80008104:	6402                	ld	s0,0(sp)
    80008106:	0141                	addi	sp,sp,16
    80008108:	8082                	ret
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
