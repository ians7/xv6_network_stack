
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00010117          	auipc	sp,0x10
    80000004:	f3010113          	addi	sp,sp,-208 # 8000ff30 <stack0>
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
    80000054:	da078793          	addi	a5,a5,-608 # 8000fdf0 <timer_scratch>
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
    80000066:	bfe78793          	addi	a5,a5,-1026 # 80006c60 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff8af07>
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
    8000019c:	00018517          	auipc	a0,0x18
    800001a0:	d9450513          	addi	a0,a0,-620 # 80017f30 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	b72080e7          	jalr	-1166(ra) # 80000d16 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001ac:	00018497          	auipc	s1,0x18
    800001b0:	d8448493          	addi	s1,s1,-636 # 80017f30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b4:	00018917          	auipc	s2,0x18
    800001b8:	e1490913          	addi	s2,s2,-492 # 80017fc8 <cons+0x98>
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
    800001f8:	00018717          	auipc	a4,0x18
    800001fc:	d3870713          	addi	a4,a4,-712 # 80017f30 <cons>
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
    80000246:	00018517          	auipc	a0,0x18
    8000024a:	cea50513          	addi	a0,a0,-790 # 80017f30 <cons>
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
    80000270:	00018717          	auipc	a4,0x18
    80000274:	d4f72c23          	sw	a5,-680(a4) # 80017fc8 <cons+0x98>
    80000278:	6be2                	ld	s7,24(sp)
    8000027a:	a031                	j	80000286 <consoleread+0x106>
    8000027c:	ec5e                	sd	s7,24(sp)
    8000027e:	bfad                	j	800001f8 <consoleread+0x78>
    80000280:	6be2                	ld	s7,24(sp)
    80000282:	a011                	j	80000286 <consoleread+0x106>
    80000284:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000286:	00018517          	auipc	a0,0x18
    8000028a:	caa50513          	addi	a0,a0,-854 # 80017f30 <cons>
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
    800002ee:	00018517          	auipc	a0,0x18
    800002f2:	c4250513          	addi	a0,a0,-958 # 80017f30 <cons>
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
    8000031c:	00018517          	auipc	a0,0x18
    80000320:	c1450513          	addi	a0,a0,-1004 # 80017f30 <cons>
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
    8000033e:	00018717          	auipc	a4,0x18
    80000342:	bf270713          	addi	a4,a4,-1038 # 80017f30 <cons>
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
    80000368:	00018797          	auipc	a5,0x18
    8000036c:	bc878793          	addi	a5,a5,-1080 # 80017f30 <cons>
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
    80000394:	00018797          	auipc	a5,0x18
    80000398:	c347a783          	lw	a5,-972(a5) # 80017fc8 <cons+0x98>
    8000039c:	9f1d                	subw	a4,a4,a5
    8000039e:	08000793          	li	a5,128
    800003a2:	f6f71de3          	bne	a4,a5,8000031c <consoleintr+0x3a>
    800003a6:	a0c9                	j	80000468 <consoleintr+0x186>
    800003a8:	e84a                	sd	s2,16(sp)
    800003aa:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    800003ac:	00018717          	auipc	a4,0x18
    800003b0:	b8470713          	addi	a4,a4,-1148 # 80017f30 <cons>
    800003b4:	0a072783          	lw	a5,160(a4)
    800003b8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003bc:	00018497          	auipc	s1,0x18
    800003c0:	b7448493          	addi	s1,s1,-1164 # 80017f30 <cons>
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
    8000040a:	00018717          	auipc	a4,0x18
    8000040e:	b2670713          	addi	a4,a4,-1242 # 80017f30 <cons>
    80000412:	0a072783          	lw	a5,160(a4)
    80000416:	09c72703          	lw	a4,156(a4)
    8000041a:	f0f701e3          	beq	a4,a5,8000031c <consoleintr+0x3a>
      cons.e--;
    8000041e:	37fd                	addiw	a5,a5,-1
    80000420:	00018717          	auipc	a4,0x18
    80000424:	baf72823          	sw	a5,-1104(a4) # 80017fd0 <cons+0xa0>
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
    80000446:	00018797          	auipc	a5,0x18
    8000044a:	aea78793          	addi	a5,a5,-1302 # 80017f30 <cons>
    8000044e:	0a07a703          	lw	a4,160(a5)
    80000452:	0017069b          	addiw	a3,a4,1
    80000456:	8636                	mv	a2,a3
    80000458:	0ad7a023          	sw	a3,160(a5)
    8000045c:	07f77713          	andi	a4,a4,127
    80000460:	97ba                	add	a5,a5,a4
    80000462:	4729                	li	a4,10
    80000464:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000468:	00018797          	auipc	a5,0x18
    8000046c:	b6c7a223          	sw	a2,-1180(a5) # 80017fcc <cons+0x9c>
        wakeup(&cons.r);
    80000470:	00018517          	auipc	a0,0x18
    80000474:	b5850513          	addi	a0,a0,-1192 # 80017fc8 <cons+0x98>
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
    8000048a:	0000b597          	auipc	a1,0xb
    8000048e:	b8658593          	addi	a1,a1,-1146 # 8000b010 <etext+0x10>
    80000492:	00018517          	auipc	a0,0x18
    80000496:	a9e50513          	addi	a0,a0,-1378 # 80017f30 <cons>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	7e8080e7          	jalr	2024(ra) # 80000c82 <initlock>

  uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	344080e7          	jalr	836(ra) # 800007e6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800004aa:	00070797          	auipc	a5,0x70
    800004ae:	e1e78793          	addi	a5,a5,-482 # 800702c8 <devsw>
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
    800004ea:	0000c817          	auipc	a6,0xc
    800004ee:	9ee80813          	addi	a6,a6,-1554 # 8000bed8 <digits>
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
    8000056c:	00018797          	auipc	a5,0x18
    80000570:	a807a223          	sw	zero,-1404(a5) # 80017ff0 <pr+0x18>
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
    800005a0:	0000f717          	auipc	a4,0xf
    800005a4:	7ef72823          	sw	a5,2032(a4) # 8000fd90 <panicked>
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
    800005ca:	00018d97          	auipc	s11,0x18
    800005ce:	a26dad83          	lw	s11,-1498(s11) # 80017ff0 <pr+0x18>
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
    8000060c:	0000ca97          	auipc	s5,0xc
    80000610:	8cca8a93          	addi	s5,s5,-1844 # 8000bed8 <digits>
    switch(c){
    80000614:	07300c13          	li	s8,115
    80000618:	a0b9                	j	80000666 <printf+0xbc>
    acquire(&pr.lock);
    8000061a:	00018517          	auipc	a0,0x18
    8000061e:	9be50513          	addi	a0,a0,-1602 # 80017fd8 <pr>
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
    8000063e:	0000b517          	auipc	a0,0xb
    80000642:	9f250513          	addi	a0,a0,-1550 # 8000b030 <etext+0x30>
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
    8000073c:	0000b497          	auipc	s1,0xb
    80000740:	8ec48493          	addi	s1,s1,-1812 # 8000b028 <etext+0x28>
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
    800007a2:	00018517          	auipc	a0,0x18
    800007a6:	83650513          	addi	a0,a0,-1994 # 80017fd8 <pr>
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
    800007be:	00018497          	auipc	s1,0x18
    800007c2:	81a48493          	addi	s1,s1,-2022 # 80017fd8 <pr>
    800007c6:	0000b597          	auipc	a1,0xb
    800007ca:	87a58593          	addi	a1,a1,-1926 # 8000b040 <etext+0x40>
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
    80000820:	0000b597          	auipc	a1,0xb
    80000824:	82858593          	addi	a1,a1,-2008 # 8000b048 <etext+0x48>
    80000828:	00017517          	auipc	a0,0x17
    8000082c:	7d050513          	addi	a0,a0,2000 # 80017ff8 <uart_tx_lock>
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
    80000854:	0000f797          	auipc	a5,0xf
    80000858:	53c7a783          	lw	a5,1340(a5) # 8000fd90 <panicked>
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
    8000088e:	0000f797          	auipc	a5,0xf
    80000892:	50a7b783          	ld	a5,1290(a5) # 8000fd98 <uart_tx_r>
    80000896:	0000f717          	auipc	a4,0xf
    8000089a:	50a73703          	ld	a4,1290(a4) # 8000fda0 <uart_tx_w>
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
    800008bc:	00017a97          	auipc	s5,0x17
    800008c0:	73ca8a93          	addi	s5,s5,1852 # 80017ff8 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000f497          	auipc	s1,0xf
    800008c8:	4d448493          	addi	s1,s1,1236 # 8000fd98 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000f997          	auipc	s3,0xf
    800008d4:	4d098993          	addi	s3,s3,1232 # 8000fda0 <uart_tx_w>
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
    80000930:	00017517          	auipc	a0,0x17
    80000934:	6c850513          	addi	a0,a0,1736 # 80017ff8 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	3de080e7          	jalr	990(ra) # 80000d16 <acquire>
  if(panicked){
    80000940:	0000f797          	auipc	a5,0xf
    80000944:	4507a783          	lw	a5,1104(a5) # 8000fd90 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000f717          	auipc	a4,0xf
    8000094e:	45673703          	ld	a4,1110(a4) # 8000fda0 <uart_tx_w>
    80000952:	0000f797          	auipc	a5,0xf
    80000956:	4467b783          	ld	a5,1094(a5) # 8000fd98 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00017997          	auipc	s3,0x17
    80000962:	69a98993          	addi	s3,s3,1690 # 80017ff8 <uart_tx_lock>
    80000966:	0000f497          	auipc	s1,0xf
    8000096a:	43248493          	addi	s1,s1,1074 # 8000fd98 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000f917          	auipc	s2,0xf
    80000972:	43290913          	addi	s2,s2,1074 # 8000fda0 <uart_tx_w>
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
    80000994:	00017497          	auipc	s1,0x17
    80000998:	66448493          	addi	s1,s1,1636 # 80017ff8 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000f797          	auipc	a5,0xf
    800009ac:	3ee7bc23          	sd	a4,1016(a5) # 8000fda0 <uart_tx_w>
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
    80000a1e:	00017497          	auipc	s1,0x17
    80000a22:	5da48493          	addi	s1,s1,1498 # 80017ff8 <uart_tx_lock>
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
    80000a5a:	00017917          	auipc	s2,0x17
    80000a5e:	5d690913          	addi	s2,s2,1494 # 80018030 <kmem>
    80000a62:	854a                	mv	a0,s2
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	2b2080e7          	jalr	690(ra) # 80000d16 <acquire>
  uint page_num = PGROUNDDOWN((uint64)pointer_in_page)/PGSIZE;
    80000a6c:	80b1                	srli	s1,s1,0xc
  ref_counter[page_num]++;
    80000a6e:	02049793          	slli	a5,s1,0x20
    80000a72:	01d7d493          	srli	s1,a5,0x1d
    80000a76:	00017797          	auipc	a5,0x17
    80000a7a:	5da78793          	addi	a5,a5,1498 # 80018050 <ref_counter>
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
    80000aae:	00073797          	auipc	a5,0x73
    80000ab2:	e4a78793          	addi	a5,a5,-438 # 800738f8 <end>
    80000ab6:	08f56963          	bltu	a0,a5,80000b48 <kfree+0xac>
    80000aba:	47c5                	li	a5,17
    80000abc:	07ee                	slli	a5,a5,0x1b
    80000abe:	08f57563          	bgeu	a0,a5,80000b48 <kfree+0xac>
    panic("kfree");

  acquire(&kmem.lock);
    80000ac2:	00017517          	auipc	a0,0x17
    80000ac6:	56e50513          	addi	a0,a0,1390 # 80018030 <kmem>
    80000aca:	00000097          	auipc	ra,0x0
    80000ace:	24c080e7          	jalr	588(ra) # 80000d16 <acquire>
  uint64 page_num = PGROUNDDOWN((uint64)pa)/PGSIZE;
    80000ad2:	00c4d793          	srli	a5,s1,0xc
  if (ref_counter[page_num] > 1) {
    80000ad6:	00379693          	slli	a3,a5,0x3
    80000ada:	00017717          	auipc	a4,0x17
    80000ade:	57670713          	addi	a4,a4,1398 # 80018050 <ref_counter>
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
    80000af0:	00017717          	auipc	a4,0x17
    80000af4:	56070713          	addi	a4,a4,1376 # 80018050 <ref_counter>
    80000af8:	97ba                	add	a5,a5,a4
    80000afa:	0007b023          	sd	zero,0(a5)
  release(&kmem.lock);
    80000afe:	00017917          	auipc	s2,0x17
    80000b02:	53290913          	addi	s2,s2,1330 # 80018030 <kmem>
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
    80000b4a:	0000a517          	auipc	a0,0xa
    80000b4e:	50650513          	addi	a0,a0,1286 # 8000b050 <etext+0x50>
    80000b52:	00000097          	auipc	ra,0x0
    80000b56:	a0e080e7          	jalr	-1522(ra) # 80000560 <panic>
    ref_counter[page_num]--;
    80000b5a:	078e                	slli	a5,a5,0x3
    80000b5c:	00017697          	auipc	a3,0x17
    80000b60:	4f468693          	addi	a3,a3,1268 # 80018050 <ref_counter>
    80000b64:	97b6                	add	a5,a5,a3
    80000b66:	177d                	addi	a4,a4,-1
    80000b68:	e398                	sd	a4,0(a5)
    release(&kmem.lock);
    80000b6a:	00017517          	auipc	a0,0x17
    80000b6e:	4c650513          	addi	a0,a0,1222 # 80018030 <kmem>
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
    80000bd0:	0000a597          	auipc	a1,0xa
    80000bd4:	48858593          	addi	a1,a1,1160 # 8000b058 <etext+0x58>
    80000bd8:	00017517          	auipc	a0,0x17
    80000bdc:	45850513          	addi	a0,a0,1112 # 80018030 <kmem>
    80000be0:	00000097          	auipc	ra,0x0
    80000be4:	0a2080e7          	jalr	162(ra) # 80000c82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000be8:	45c5                	li	a1,17
    80000bea:	05ee                	slli	a1,a1,0x1b
    80000bec:	00073517          	auipc	a0,0x73
    80000bf0:	d0c50513          	addi	a0,a0,-756 # 800738f8 <end>
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
    80000c0e:	00017497          	auipc	s1,0x17
    80000c12:	42248493          	addi	s1,s1,1058 # 80018030 <kmem>
    80000c16:	8526                	mv	a0,s1
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	0fe080e7          	jalr	254(ra) # 80000d16 <acquire>

  r = kmem.freelist;
    80000c20:	6c84                	ld	s1,24(s1)
  if(r)
    80000c22:	c0b1                	beqz	s1,80000c66 <kalloc+0x62>
    kmem.freelist = r->next;
    80000c24:	609c                	ld	a5,0(s1)
    80000c26:	00017517          	auipc	a0,0x17
    80000c2a:	40a50513          	addi	a0,a0,1034 # 80018030 <kmem>
    80000c2e:	ed1c                	sd	a5,24(a0)
  uint64 page_num = PGROUNDDOWN((uint64)r)/PGSIZE;
    80000c30:	00c4d713          	srli	a4,s1,0xc
  ref_counter[page_num] = 1;
    80000c34:	070e                	slli	a4,a4,0x3
    80000c36:	00017797          	auipc	a5,0x17
    80000c3a:	41a78793          	addi	a5,a5,1050 # 80018050 <ref_counter>
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
    80000c68:	00017717          	auipc	a4,0x17
    80000c6c:	3ef73423          	sd	a5,1000(a4) # 80018050 <ref_counter>
  release(&kmem.lock);
    80000c70:	00017517          	auipc	a0,0x17
    80000c74:	3c050513          	addi	a0,a0,960 # 80018030 <kmem>
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
    80000d5a:	0000a517          	auipc	a0,0xa
    80000d5e:	30650513          	addi	a0,a0,774 # 8000b060 <etext+0x60>
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
    80000da6:	0000a517          	auipc	a0,0xa
    80000daa:	2c250513          	addi	a0,a0,706 # 8000b068 <etext+0x68>
    80000dae:	fffff097          	auipc	ra,0xfffff
    80000db2:	7b2080e7          	jalr	1970(ra) # 80000560 <panic>
    panic("pop_off");
    80000db6:	0000a517          	auipc	a0,0xa
    80000dba:	2ca50513          	addi	a0,a0,714 # 8000b080 <etext+0x80>
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
    80000dfe:	0000a517          	auipc	a0,0xa
    80000e02:	28a50513          	addi	a0,a0,650 # 8000b088 <etext+0x88>
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
    virtio_net_init(); // emulated NIC driver 
    __sync_synchronize();
    userinit();      // first user process
    started = 1;
  } else {
    while(started == 0)
    80000fd8:	0000f717          	auipc	a4,0xf
    80000fdc:	dd070713          	addi	a4,a4,-560 # 8000fda8 <started>
  if(cpuid() == 0){
    80000fe0:	c939                	beqz	a0,80001036 <main+0x6e>
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
    80000ff6:	0000a517          	auipc	a0,0xa
    80000ffa:	0b250513          	addi	a0,a0,178 # 8000b0a8 <etext+0xa8>
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
    8000101a:	c90080e7          	jalr	-880(ra) # 80006ca6 <plicinithart>
    net_init();
    8000101e:	00007097          	auipc	ra,0x7
    80001022:	100080e7          	jalr	256(ra) # 8000811e <net_init>
    socket_init();
    80001026:	00008097          	auipc	ra,0x8
    8000102a:	898080e7          	jalr	-1896(ra) # 800088be <socket_init>
  }

  scheduler();        
    8000102e:	00001097          	auipc	ra,0x1
    80001032:	528080e7          	jalr	1320(ra) # 80002556 <scheduler>
    consoleinit();
    80001036:	fffff097          	auipc	ra,0xfffff
    8000103a:	44c080e7          	jalr	1100(ra) # 80000482 <consoleinit>
    printfinit();
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	776080e7          	jalr	1910(ra) # 800007b4 <printfinit>
    printf("\n");
    80001046:	0000a517          	auipc	a0,0xa
    8000104a:	fda50513          	addi	a0,a0,-38 # 8000b020 <etext+0x20>
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	55c080e7          	jalr	1372(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80001056:	0000a517          	auipc	a0,0xa
    8000105a:	03a50513          	addi	a0,a0,58 # 8000b090 <etext+0x90>
    8000105e:	fffff097          	auipc	ra,0xfffff
    80001062:	54c080e7          	jalr	1356(ra) # 800005aa <printf>
    printf("\n");
    80001066:	0000a517          	auipc	a0,0xa
    8000106a:	fba50513          	addi	a0,a0,-70 # 8000b020 <etext+0x20>
    8000106e:	fffff097          	auipc	ra,0xfffff
    80001072:	53c080e7          	jalr	1340(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80001076:	00000097          	auipc	ra,0x0
    8000107a:	b52080e7          	jalr	-1198(ra) # 80000bc8 <kinit>
    kvminit();       // create kernel page table
    8000107e:	00000097          	auipc	ra,0x0
    80001082:	346080e7          	jalr	838(ra) # 800013c4 <kvminit>
    kvminithart();   // turn on paging
    80001086:	00000097          	auipc	ra,0x0
    8000108a:	070080e7          	jalr	112(ra) # 800010f6 <kvminithart>
    procinit();      // process table
    8000108e:	00001097          	auipc	ra,0x1
    80001092:	cdc080e7          	jalr	-804(ra) # 80001d6a <procinit>
    trapinit();      // trap vectors
    80001096:	00002097          	auipc	ra,0x2
    8000109a:	f1e080e7          	jalr	-226(ra) # 80002fb4 <trapinit>
    trapinithart();  // install kernel trap vector
    8000109e:	00002097          	auipc	ra,0x2
    800010a2:	f3e080e7          	jalr	-194(ra) # 80002fdc <trapinithart>
    plicinit();      // set up interrupt controller
    800010a6:	00006097          	auipc	ra,0x6
    800010aa:	be4080e7          	jalr	-1052(ra) # 80006c8a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800010ae:	00006097          	auipc	ra,0x6
    800010b2:	bf8080e7          	jalr	-1032(ra) # 80006ca6 <plicinithart>
    binit();         // buffer cache
    800010b6:	00003097          	auipc	ra,0x3
    800010ba:	c28080e7          	jalr	-984(ra) # 80003cde <binit>
    iinit();         // inode table
    800010be:	00003097          	auipc	ra,0x3
    800010c2:	2b8080e7          	jalr	696(ra) # 80004376 <iinit>
    fileinit();      // file table
    800010c6:	00004097          	auipc	ra,0x4
    800010ca:	28a080e7          	jalr	650(ra) # 80005350 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800010ce:	00006097          	auipc	ra,0x6
    800010d2:	ce0080e7          	jalr	-800(ra) # 80006dae <virtio_disk_init>
    virtio_net_init(); // emulated NIC driver 
    800010d6:	00006097          	auipc	ra,0x6
    800010da:	24a080e7          	jalr	586(ra) # 80007320 <virtio_net_init>
    __sync_synchronize();
    800010de:	0330000f          	fence	rw,rw
    userinit();      // first user process
    800010e2:	00001097          	auipc	ra,0x1
    800010e6:	062080e7          	jalr	98(ra) # 80002144 <userinit>
    started = 1;
    800010ea:	4785                	li	a5,1
    800010ec:	0000f717          	auipc	a4,0xf
    800010f0:	caf72e23          	sw	a5,-836(a4) # 8000fda8 <started>
    800010f4:	bf2d                	j	8000102e <main+0x66>

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
    80001102:	0000f797          	auipc	a5,0xf
    80001106:	cae7b783          	ld	a5,-850(a5) # 8000fdb0 <kernel_pagetable>
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
    80001188:	0000a517          	auipc	a0,0xa
    8000118c:	f3850513          	addi	a0,a0,-200 # 8000b0c0 <etext+0xc0>
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
    80001272:	0000a517          	auipc	a0,0xa
    80001276:	e5650513          	addi	a0,a0,-426 # 8000b0c8 <etext+0xc8>
    8000127a:	fffff097          	auipc	ra,0xfffff
    8000127e:	2e6080e7          	jalr	742(ra) # 80000560 <panic>
      panic("mappages: remap");
    80001282:	0000a517          	auipc	a0,0xa
    80001286:	e5650513          	addi	a0,a0,-426 # 8000b0d8 <etext+0xd8>
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
    800012d0:	0000a517          	auipc	a0,0xa
    800012d4:	e1850513          	addi	a0,a0,-488 # 8000b0e8 <etext+0xe8>
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
    80001354:	0000a917          	auipc	s2,0xa
    80001358:	cac90913          	addi	s2,s2,-852 # 8000b000 <etext>
    8000135c:	4729                	li	a4,10
    8000135e:	8000a697          	auipc	a3,0x8000a
    80001362:	ca268693          	addi	a3,a3,-862 # b000 <_entry-0x7fff5000>
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
    80001392:	00009617          	auipc	a2,0x9
    80001396:	c6e60613          	addi	a2,a2,-914 # 8000a000 <_trampoline>
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
    800013d4:	0000f797          	auipc	a5,0xf
    800013d8:	9ca7be23          	sd	a0,-1572(a5) # 8000fdb0 <kernel_pagetable>
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
    80001424:	0000a517          	auipc	a0,0xa
    80001428:	ccc50513          	addi	a0,a0,-820 # 8000b0f0 <etext+0xf0>
    8000142c:	fffff097          	auipc	ra,0xfffff
    80001430:	134080e7          	jalr	308(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    80001434:	0000a517          	auipc	a0,0xa
    80001438:	cd450513          	addi	a0,a0,-812 # 8000b108 <etext+0x108>
    8000143c:	fffff097          	auipc	ra,0xfffff
    80001440:	124080e7          	jalr	292(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    80001444:	0000a517          	auipc	a0,0xa
    80001448:	cd450513          	addi	a0,a0,-812 # 8000b118 <etext+0x118>
    8000144c:	fffff097          	auipc	ra,0xfffff
    80001450:	114080e7          	jalr	276(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    80001454:	0000a517          	auipc	a0,0xa
    80001458:	cdc50513          	addi	a0,a0,-804 # 8000b130 <etext+0x130>
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
    80001548:	0000a517          	auipc	a0,0xa
    8000154c:	c0050513          	addi	a0,a0,-1024 # 8000b148 <etext+0x148>
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
    800018ca:	0000a517          	auipc	a0,0xa
    800018ce:	89e50513          	addi	a0,a0,-1890 # 8000b168 <etext+0x168>
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
    800019aa:	00009517          	auipc	a0,0x9
    800019ae:	7ce50513          	addi	a0,a0,1998 # 8000b178 <etext+0x178>
    800019b2:	fffff097          	auipc	ra,0xfffff
    800019b6:	bae080e7          	jalr	-1106(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    800019ba:	00009517          	auipc	a0,0x9
    800019be:	7de50513          	addi	a0,a0,2014 # 8000b198 <etext+0x198>
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
    80001a28:	00009517          	auipc	a0,0x9
    80001a2c:	79050513          	addi	a0,a0,1936 # 8000b1b8 <etext+0x1b8>
    80001a30:	fffff097          	auipc	ra,0xfffff
    80001a34:	b30080e7          	jalr	-1232(ra) # 80000560 <panic>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    80001a38:	00009517          	auipc	a0,0x9
    80001a3c:	7a050513          	addi	a0,a0,1952 # 8000b1d8 <etext+0x1d8>
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
    80001af2:	00009517          	auipc	a0,0x9
    80001af6:	70650513          	addi	a0,a0,1798 # 8000b1f8 <etext+0x1f8>
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
    80001c9e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff8b708>
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
    80001cda:	00056497          	auipc	s1,0x56
    80001cde:	7a648493          	addi	s1,s1,1958 # 80058480 <proc>
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
    80001d04:	00064a97          	auipc	s5,0x64
    80001d08:	37ca8a93          	addi	s5,s5,892 # 80066080 <tickslock>
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
    80001d5a:	00009517          	auipc	a0,0x9
    80001d5e:	4ae50513          	addi	a0,a0,1198 # 8000b208 <etext+0x208>
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
    80001d7e:	00009597          	auipc	a1,0x9
    80001d82:	49258593          	addi	a1,a1,1170 # 8000b210 <etext+0x210>
    80001d86:	00056517          	auipc	a0,0x56
    80001d8a:	2ca50513          	addi	a0,a0,714 # 80058050 <pid_lock>
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	ef4080e7          	jalr	-268(ra) # 80000c82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001d96:	00009597          	auipc	a1,0x9
    80001d9a:	48258593          	addi	a1,a1,1154 # 8000b218 <etext+0x218>
    80001d9e:	00056517          	auipc	a0,0x56
    80001da2:	2ca50513          	addi	a0,a0,714 # 80058068 <wait_lock>
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	edc080e7          	jalr	-292(ra) # 80000c82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001dae:	00056497          	auipc	s1,0x56
    80001db2:	6d248493          	addi	s1,s1,1746 # 80058480 <proc>
      initlock(&p->lock, "proc");
    80001db6:	00009b17          	auipc	s6,0x9
    80001dba:	472b0b13          	addi	s6,s6,1138 # 8000b228 <etext+0x228>
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
    80001ddc:	00064a17          	auipc	s4,0x64
    80001de0:	2a4a0a13          	addi	s4,s4,676 # 80066080 <tickslock>
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
    80001e48:	00056517          	auipc	a0,0x56
    80001e4c:	23850513          	addi	a0,a0,568 # 80058080 <cpus>
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
    80001e72:	00056717          	auipc	a4,0x56
    80001e76:	1de70713          	addi	a4,a4,478 # 80058050 <pid_lock>
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
    80001eaa:	0000e797          	auipc	a5,0xe
    80001eae:	e167a783          	lw	a5,-490(a5) # 8000fcc0 <first.1>
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
    80001ec4:	0000e797          	auipc	a5,0xe
    80001ec8:	de07ae23          	sw	zero,-516(a5) # 8000fcc0 <first.1>
    fsinit(ROOTDEV);
    80001ecc:	4505                	li	a0,1
    80001ece:	00002097          	auipc	ra,0x2
    80001ed2:	428080e7          	jalr	1064(ra) # 800042f6 <fsinit>
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
    80001ee4:	00056917          	auipc	s2,0x56
    80001ee8:	16c90913          	addi	s2,s2,364 # 80058050 <pid_lock>
    80001eec:	854a                	mv	a0,s2
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	e28080e7          	jalr	-472(ra) # 80000d16 <acquire>
  pid = nextpid;
    80001ef6:	0000e797          	auipc	a5,0xe
    80001efa:	dce78793          	addi	a5,a5,-562 # 8000fcc4 <nextpid>
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
    80001f3a:	00008697          	auipc	a3,0x8
    80001f3e:	0c668693          	addi	a3,a3,198 # 8000a000 <_trampoline>
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
    80002070:	00056497          	auipc	s1,0x56
    80002074:	41048493          	addi	s1,s1,1040 # 80058480 <proc>
    80002078:	00064917          	auipc	s2,0x64
    8000207c:	00890913          	addi	s2,s2,8 # 80066080 <tickslock>
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
    80002158:	0000e797          	auipc	a5,0xe
    8000215c:	c6a7b023          	sd	a0,-928(a5) # 8000fdb8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002160:	03400613          	li	a2,52
    80002164:	0000e597          	auipc	a1,0xe
    80002168:	b6c58593          	addi	a1,a1,-1172 # 8000fcd0 <initcode>
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
    80002186:	00009597          	auipc	a1,0x9
    8000218a:	0aa58593          	addi	a1,a1,170 # 8000b230 <etext+0x230>
    8000218e:	15848513          	addi	a0,s1,344
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	dd2080e7          	jalr	-558(ra) # 80000f64 <safestrcpy>
  p->cwd = namei("/");
    8000219a:	00009517          	auipc	a0,0x9
    8000219e:	0a650513          	addi	a0,a0,166 # 8000b240 <etext+0x240>
    800021a2:	00003097          	auipc	ra,0x3
    800021a6:	bbc080e7          	jalr	-1092(ra) # 80004d5e <namei>
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
    80002312:	0d4080e7          	jalr	212(ra) # 800053e2 <filedup>
    80002316:	00a93023          	sd	a0,0(s2)
    8000231a:	b7e5                	j	80002302 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000231c:	150ab503          	ld	a0,336(s5)
    80002320:	00002097          	auipc	ra,0x2
    80002324:	21c080e7          	jalr	540(ra) # 8000453c <idup>
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
    8000234c:	00056497          	auipc	s1,0x56
    80002350:	d1c48493          	addi	s1,s1,-740 # 80058068 <wait_lock>
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
    80002472:	00009517          	auipc	a0,0x9
    80002476:	dd650513          	addi	a0,a0,-554 # 8000b248 <etext+0x248>
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
    800024ae:	f38080e7          	jalr	-200(ra) # 800053e2 <filedup>
    800024b2:	00a9b023          	sd	a0,0(s3)
    800024b6:	b7e5                	j	8000249e <create_thread+0xfc>
  np->cwd = idup(p->cwd);
    800024b8:	150b3503          	ld	a0,336(s6)
    800024bc:	00002097          	auipc	ra,0x2
    800024c0:	080080e7          	jalr	128(ra) # 8000453c <idup>
    800024c4:	14aa3823          	sd	a0,336(s4)
  release(&np->lock);
    800024c8:	8552                	mv	a0,s4
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	8fc080e7          	jalr	-1796(ra) # 80000dc6 <release>
  acquire(&wait_lock);
    800024d2:	00056517          	auipc	a0,0x56
    800024d6:	b9650513          	addi	a0,a0,-1130 # 80058068 <wait_lock>
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
    800024fa:	00056517          	auipc	a0,0x56
    800024fe:	b6e50513          	addi	a0,a0,-1170 # 80058068 <wait_lock>
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
    80002572:	00056717          	auipc	a4,0x56
    80002576:	ade70713          	addi	a4,a4,-1314 # 80058050 <pid_lock>
    8000257a:	9756                	add	a4,a4,s5
    8000257c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002580:	00056717          	auipc	a4,0x56
    80002584:	b0870713          	addi	a4,a4,-1272 # 80058088 <cpus+0x8>
    80002588:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000258a:	498d                	li	s3,3
        p->state = RUNNING;
    8000258c:	4b11                	li	s6,4
        c->proc = p;
    8000258e:	079e                	slli	a5,a5,0x7
    80002590:	00056a17          	auipc	s4,0x56
    80002594:	ac0a0a13          	addi	s4,s4,-1344 # 80058050 <pid_lock>
    80002598:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000259a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000259e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025a2:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800025a6:	00056497          	auipc	s1,0x56
    800025aa:	eda48493          	addi	s1,s1,-294 # 80058480 <proc>
    800025ae:	00064917          	auipc	s2,0x64
    800025b2:	ad290913          	addi	s2,s2,-1326 # 80066080 <tickslock>
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
    8000261e:	00056717          	auipc	a4,0x56
    80002622:	a3270713          	addi	a4,a4,-1486 # 80058050 <pid_lock>
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
    80002644:	00056917          	auipc	s2,0x56
    80002648:	a0c90913          	addi	s2,s2,-1524 # 80058050 <pid_lock>
    8000264c:	2781                	sext.w	a5,a5
    8000264e:	079e                	slli	a5,a5,0x7
    80002650:	97ca                	add	a5,a5,s2
    80002652:	0ac7a983          	lw	s3,172(a5)
    80002656:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002658:	2781                	sext.w	a5,a5
    8000265a:	079e                	slli	a5,a5,0x7
    8000265c:	00056597          	auipc	a1,0x56
    80002660:	a2c58593          	addi	a1,a1,-1492 # 80058088 <cpus+0x8>
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
    8000268c:	00009517          	auipc	a0,0x9
    80002690:	bd450513          	addi	a0,a0,-1068 # 8000b260 <etext+0x260>
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	ecc080e7          	jalr	-308(ra) # 80000560 <panic>
    panic("sched locks");
    8000269c:	00009517          	auipc	a0,0x9
    800026a0:	bd450513          	addi	a0,a0,-1068 # 8000b270 <etext+0x270>
    800026a4:	ffffe097          	auipc	ra,0xffffe
    800026a8:	ebc080e7          	jalr	-324(ra) # 80000560 <panic>
    panic("sched running");
    800026ac:	00009517          	auipc	a0,0x9
    800026b0:	bd450513          	addi	a0,a0,-1068 # 8000b280 <etext+0x280>
    800026b4:	ffffe097          	auipc	ra,0xffffe
    800026b8:	eac080e7          	jalr	-340(ra) # 80000560 <panic>
    panic("sched interruptible");
    800026bc:	00009517          	auipc	a0,0x9
    800026c0:	bd450513          	addi	a0,a0,-1068 # 8000b290 <etext+0x290>
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
    80002780:	00056497          	auipc	s1,0x56
    80002784:	d0048493          	addi	s1,s1,-768 # 80058480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002788:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000278a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000278c:	00064917          	auipc	s2,0x64
    80002790:	8f490913          	addi	s2,s2,-1804 # 80066080 <tickslock>
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
    800027f4:	00056497          	auipc	s1,0x56
    800027f8:	c8c48493          	addi	s1,s1,-884 # 80058480 <proc>
      pp->parent = initproc;
    800027fc:	0000da17          	auipc	s4,0xd
    80002800:	5bca0a13          	addi	s4,s4,1468 # 8000fdb8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002804:	00064997          	auipc	s3,0x64
    80002808:	87c98993          	addi	s3,s3,-1924 # 80066080 <tickslock>
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
    80002858:	0000d797          	auipc	a5,0xd
    8000285c:	5607b783          	ld	a5,1376(a5) # 8000fdb8 <initproc>
    80002860:	0d050493          	addi	s1,a0,208
    80002864:	15050913          	addi	s2,a0,336
    80002868:	00a79d63          	bne	a5,a0,80002882 <thread_exit+0x46>
    panic("init exiting");
    8000286c:	00009517          	auipc	a0,0x9
    80002870:	a3c50513          	addi	a0,a0,-1476 # 8000b2a8 <etext+0x2a8>
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
    8000288a:	bae080e7          	jalr	-1106(ra) # 80005434 <fileclose>
      p->ofile[fd] = 0;
    8000288e:	0004b023          	sd	zero,0(s1)
    80002892:	b7ed                	j	8000287c <thread_exit+0x40>
  begin_op();
    80002894:	00002097          	auipc	ra,0x2
    80002898:	6d0080e7          	jalr	1744(ra) # 80004f64 <begin_op>
  iput(p->cwd);
    8000289c:	1509b503          	ld	a0,336(s3)
    800028a0:	00002097          	auipc	ra,0x2
    800028a4:	e98080e7          	jalr	-360(ra) # 80004738 <iput>
  end_op();
    800028a8:	00002097          	auipc	ra,0x2
    800028ac:	736080e7          	jalr	1846(ra) # 80004fde <end_op>
  p->cwd = 0;
    800028b0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800028b4:	00055497          	auipc	s1,0x55
    800028b8:	7b448493          	addi	s1,s1,1972 # 80058068 <wait_lock>
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
    80002902:	00009517          	auipc	a0,0x9
    80002906:	9b650513          	addi	a0,a0,-1610 # 8000b2b8 <etext+0x2b8>
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
    8000294a:	00055a97          	auipc	s5,0x55
    8000294e:	71ea8a93          	addi	s5,s5,1822 # 80058068 <wait_lock>
      infant->state = ZOMBIE;
    80002952:	4c95                	li	s9,5
    80002954:	a885                	j	800029c4 <exit+0xb2>
          fileclose(f);
    80002956:	00003097          	auipc	ra,0x3
    8000295a:	ade080e7          	jalr	-1314(ra) # 80005434 <fileclose>
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
    80002972:	5f6080e7          	jalr	1526(ra) # 80004f64 <begin_op>
      iput(infant->cwd);
    80002976:	1509b503          	ld	a0,336(s3)
    8000297a:	00002097          	auipc	ra,0x2
    8000297e:	dbe080e7          	jalr	-578(ra) # 80004738 <iput>
      end_op();
    80002982:	00002097          	auipc	ra,0x2
    80002986:	65c080e7          	jalr	1628(ra) # 80004fde <end_op>
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
    800029d6:	0000d797          	auipc	a5,0xd
    800029da:	3e27b783          	ld	a5,994(a5) # 8000fdb8 <initproc>
    800029de:	0d0c0493          	addi	s1,s8,208
    800029e2:	150c0913          	addi	s2,s8,336
    800029e6:	01879d63          	bne	a5,s8,80002a00 <exit+0xee>
    panic("init exiting");
    800029ea:	00009517          	auipc	a0,0x9
    800029ee:	8be50513          	addi	a0,a0,-1858 # 8000b2a8 <etext+0x2a8>
    800029f2:	ffffe097          	auipc	ra,0xffffe
    800029f6:	b6e080e7          	jalr	-1170(ra) # 80000560 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800029fa:	04a1                	addi	s1,s1,8
    800029fc:	01248b63          	beq	s1,s2,80002a12 <exit+0x100>
    if(p->ofile[fd]){
    80002a00:	6088                	ld	a0,0(s1)
    80002a02:	dd65                	beqz	a0,800029fa <exit+0xe8>
      fileclose(f);
    80002a04:	00003097          	auipc	ra,0x3
    80002a08:	a30080e7          	jalr	-1488(ra) # 80005434 <fileclose>
      p->ofile[fd] = 0;
    80002a0c:	0004b023          	sd	zero,0(s1)
    80002a10:	b7ed                	j	800029fa <exit+0xe8>
  begin_op();
    80002a12:	00002097          	auipc	ra,0x2
    80002a16:	552080e7          	jalr	1362(ra) # 80004f64 <begin_op>
  iput(p->cwd);
    80002a1a:	150c3503          	ld	a0,336(s8)
    80002a1e:	00002097          	auipc	ra,0x2
    80002a22:	d1a080e7          	jalr	-742(ra) # 80004738 <iput>
  end_op();
    80002a26:	00002097          	auipc	ra,0x2
    80002a2a:	5b8080e7          	jalr	1464(ra) # 80004fde <end_op>
  p->cwd = 0;
    80002a2e:	140c3823          	sd	zero,336(s8)
  acquire(&wait_lock);
    80002a32:	00055497          	auipc	s1,0x55
    80002a36:	63648493          	addi	s1,s1,1590 # 80058068 <wait_lock>
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
    80002a80:	00009517          	auipc	a0,0x9
    80002a84:	83850513          	addi	a0,a0,-1992 # 8000b2b8 <etext+0x2b8>
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
    80002aa0:	00056497          	auipc	s1,0x56
    80002aa4:	9e048493          	addi	s1,s1,-1568 # 80058480 <proc>
    80002aa8:	00063997          	auipc	s3,0x63
    80002aac:	5d898993          	addi	s3,s3,1496 # 80066080 <tickslock>
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
    80002b8a:	00055517          	auipc	a0,0x55
    80002b8e:	4de50513          	addi	a0,a0,1246 # 80058068 <wait_lock>
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
    80002bbe:	00055b97          	auipc	s7,0x55
    80002bc2:	4aab8b93          	addi	s7,s7,1194 # 80058068 <wait_lock>
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
    80002c20:	00055517          	auipc	a0,0x55
    80002c24:	44850513          	addi	a0,a0,1096 # 80058068 <wait_lock>
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
    80002c4e:	00055517          	auipc	a0,0x55
    80002c52:	41a50513          	addi	a0,a0,1050 # 80058068 <wait_lock>
    80002c56:	ffffe097          	auipc	ra,0xffffe
    80002c5a:	170080e7          	jalr	368(ra) # 80000dc6 <release>
        return -1;
    80002c5e:	557d                	li	a0,-1
    80002c60:	6ae2                	ld	s5,24(sp)
    80002c62:	6ba2                	ld	s7,8(sp)
    80002c64:	a821                	j	80002c7c <join_thread+0x11c>
      release(&wait_lock);
    80002c66:	00055517          	auipc	a0,0x55
    80002c6a:	40250513          	addi	a0,a0,1026 # 80058068 <wait_lock>
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
    80002c8e:	00055517          	auipc	a0,0x55
    80002c92:	3da50513          	addi	a0,a0,986 # 80058068 <wait_lock>
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
    80002cc4:	00055517          	auipc	a0,0x55
    80002cc8:	3a450513          	addi	a0,a0,932 # 80058068 <wait_lock>
    80002ccc:	ffffe097          	auipc	ra,0xffffe
    80002cd0:	04a080e7          	jalr	74(ra) # 80000d16 <acquire>
        if(pp->state == ZOMBIE){
    80002cd4:	4a15                	li	s4,5
        havekids = 1;
    80002cd6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002cd8:	00063997          	auipc	s3,0x63
    80002cdc:	3a898993          	addi	s3,s3,936 # 80066080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002ce0:	00055b97          	auipc	s7,0x55
    80002ce4:	388b8b93          	addi	s7,s7,904 # 80058068 <wait_lock>
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
    80002d1e:	00055517          	auipc	a0,0x55
    80002d22:	34a50513          	addi	a0,a0,842 # 80058068 <wait_lock>
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
    80002d50:	00055517          	auipc	a0,0x55
    80002d54:	31850513          	addi	a0,a0,792 # 80058068 <wait_lock>
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
    80002dac:	00055497          	auipc	s1,0x55
    80002db0:	6d448493          	addi	s1,s1,1748 # 80058480 <proc>
    80002db4:	bf65                	j	80002d6c <wait+0xca>
      release(&wait_lock);
    80002db6:	00055517          	auipc	a0,0x55
    80002dba:	2b250513          	addi	a0,a0,690 # 80058068 <wait_lock>
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
    80002e8c:	00008517          	auipc	a0,0x8
    80002e90:	19450513          	addi	a0,a0,404 # 8000b020 <etext+0x20>
    80002e94:	ffffd097          	auipc	ra,0xffffd
    80002e98:	716080e7          	jalr	1814(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002e9c:	00055497          	auipc	s1,0x55
    80002ea0:	73c48493          	addi	s1,s1,1852 # 800585d8 <proc+0x158>
    80002ea4:	00063917          	auipc	s2,0x63
    80002ea8:	33490913          	addi	s2,s2,820 # 800661d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002eac:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002eae:	00008997          	auipc	s3,0x8
    80002eb2:	41a98993          	addi	s3,s3,1050 # 8000b2c8 <etext+0x2c8>
    printf("%d %s %s", p->pid, state, p->name);
    80002eb6:	00008a97          	auipc	s5,0x8
    80002eba:	41aa8a93          	addi	s5,s5,1050 # 8000b2d0 <etext+0x2d0>
    printf("\n");
    80002ebe:	00008a17          	auipc	s4,0x8
    80002ec2:	162a0a13          	addi	s4,s4,354 # 8000b020 <etext+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ec6:	00009b97          	auipc	s7,0x9
    80002eca:	02ab8b93          	addi	s7,s7,42 # 8000bef0 <states.0>
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
    80002f30:	00008517          	auipc	a0,0x8
    80002f34:	3b050513          	addi	a0,a0,944 # 8000b2e0 <etext+0x2e0>
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
    80002fbc:	00008597          	auipc	a1,0x8
    80002fc0:	37c58593          	addi	a1,a1,892 # 8000b338 <etext+0x338>
    80002fc4:	00063517          	auipc	a0,0x63
    80002fc8:	0bc50513          	addi	a0,a0,188 # 80066080 <tickslock>
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
    80002fe8:	bec78793          	addi	a5,a5,-1044 # 80006bd0 <kernelvec>
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
    80003012:	00007697          	auipc	a3,0x7
    80003016:	fee68693          	addi	a3,a3,-18 # 8000a000 <_trampoline>
    8000301a:	00007717          	auipc	a4,0x7
    8000301e:	fe670713          	addi	a4,a4,-26 # 8000a000 <_trampoline>
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
    8000304a:	14860613          	addi	a2,a2,328 # 8000318e <usertrap>
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
    80003072:	00007717          	auipc	a4,0x7
    80003076:	02a70713          	addi	a4,a4,42 # 8000a09c <userret>
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
    80003098:	00063497          	auipc	s1,0x63
    8000309c:	fe848493          	addi	s1,s1,-24 # 80066080 <tickslock>
    800030a0:	8526                	mv	a0,s1
    800030a2:	ffffe097          	auipc	ra,0xffffe
    800030a6:	c74080e7          	jalr	-908(ra) # 80000d16 <acquire>
  ticks++;
    800030aa:	0000d517          	auipc	a0,0xd
    800030ae:	d1a50513          	addi	a0,a0,-742 # 8000fdc4 <ticks>
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
    800030da:	0a07d963          	bgez	a5,8000318c <devintr+0xb8>
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
    800030f8:	06e78963          	beq	a5,a4,8000316a <devintr+0x96>
  }
}
    800030fc:	60e2                	ld	ra,24(sp)
    800030fe:	6442                	ld	s0,16(sp)
    80003100:	6105                	addi	sp,sp,32
    80003102:	8082                	ret
    80003104:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80003106:	00004097          	auipc	ra,0x4
    8000310a:	bd8080e7          	jalr	-1064(ra) # 80006cde <plic_claim>
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
    80003124:	e88d                	bnez	s1,80003156 <devintr+0x82>
    80003126:	64a2                	ld	s1,8(sp)
    80003128:	bfd1                	j	800030fc <devintr+0x28>
      uartintr();
    8000312a:	ffffe097          	auipc	ra,0xffffe
    8000312e:	8d2080e7          	jalr	-1838(ra) # 800009fc <uartintr>
      plic_complete(irq);
    80003132:	8526                	mv	a0,s1
    80003134:	00004097          	auipc	ra,0x4
    80003138:	bce080e7          	jalr	-1074(ra) # 80006d02 <plic_complete>
    return 1;
    8000313c:	4505                	li	a0,1
    8000313e:	64a2                	ld	s1,8(sp)
    80003140:	bf75                	j	800030fc <devintr+0x28>
      virtio_disk_intr();
    80003142:	00004097          	auipc	ra,0x4
    80003146:	090080e7          	jalr	144(ra) # 800071d2 <virtio_disk_intr>
    if(irq)
    8000314a:	b7e5                	j	80003132 <devintr+0x5e>
      receive_packet();
    8000314c:	00005097          	auipc	ra,0x5
    80003150:	890080e7          	jalr	-1904(ra) # 800079dc <receive_packet>
    if(irq)
    80003154:	bff9                	j	80003132 <devintr+0x5e>
      printf("unexpected interrupt irq=%d\n", irq);
    80003156:	85a6                	mv	a1,s1
    80003158:	00008517          	auipc	a0,0x8
    8000315c:	1e850513          	addi	a0,a0,488 # 8000b340 <etext+0x340>
    80003160:	ffffd097          	auipc	ra,0xffffd
    80003164:	44a080e7          	jalr	1098(ra) # 800005aa <printf>
    if(irq)
    80003168:	b7e9                	j	80003132 <devintr+0x5e>
    if(cpuid() == 0){
    8000316a:	fffff097          	auipc	ra,0xfffff
    8000316e:	cbc080e7          	jalr	-836(ra) # 80001e26 <cpuid>
    80003172:	c901                	beqz	a0,80003182 <devintr+0xae>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003174:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003178:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000317a:	14479073          	csrw	sip,a5
    return 2;
    8000317e:	4509                	li	a0,2
    80003180:	bfb5                	j	800030fc <devintr+0x28>
      clockintr();
    80003182:	00000097          	auipc	ra,0x0
    80003186:	f0c080e7          	jalr	-244(ra) # 8000308e <clockintr>
    8000318a:	b7ed                	j	80003174 <devintr+0xa0>
}
    8000318c:	8082                	ret

000000008000318e <usertrap>:
{
    8000318e:	1101                	addi	sp,sp,-32
    80003190:	ec06                	sd	ra,24(sp)
    80003192:	e822                	sd	s0,16(sp)
    80003194:	e426                	sd	s1,8(sp)
    80003196:	e04a                	sd	s2,0(sp)
    80003198:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000319a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000319e:	1007f793          	andi	a5,a5,256
    800031a2:	e3b1                	bnez	a5,800031e6 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800031a4:	00004797          	auipc	a5,0x4
    800031a8:	a2c78793          	addi	a5,a5,-1492 # 80006bd0 <kernelvec>
    800031ac:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800031b0:	fffff097          	auipc	ra,0xfffff
    800031b4:	caa080e7          	jalr	-854(ra) # 80001e5a <myproc>
    800031b8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800031ba:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800031bc:	14102773          	csrr	a4,sepc
    800031c0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800031c2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800031c6:	47a1                	li	a5,8
    800031c8:	02f70763          	beq	a4,a5,800031f6 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	f08080e7          	jalr	-248(ra) # 800030d4 <devintr>
    800031d4:	892a                	mv	s2,a0
    800031d6:	c151                	beqz	a0,8000325a <usertrap+0xcc>
  if(killed(p))
    800031d8:	8526                	mv	a0,s1
    800031da:	00000097          	auipc	ra,0x0
    800031de:	954080e7          	jalr	-1708(ra) # 80002b2e <killed>
    800031e2:	c929                	beqz	a0,80003234 <usertrap+0xa6>
    800031e4:	a099                	j	8000322a <usertrap+0x9c>
    panic("usertrap: not from user mode");
    800031e6:	00008517          	auipc	a0,0x8
    800031ea:	17a50513          	addi	a0,a0,378 # 8000b360 <etext+0x360>
    800031ee:	ffffd097          	auipc	ra,0xffffd
    800031f2:	372080e7          	jalr	882(ra) # 80000560 <panic>
    if(killed(p))
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	938080e7          	jalr	-1736(ra) # 80002b2e <killed>
    800031fe:	e921                	bnez	a0,8000324e <usertrap+0xc0>
    p->trapframe->epc += 4;
    80003200:	6cb8                	ld	a4,88(s1)
    80003202:	6f1c                	ld	a5,24(a4)
    80003204:	0791                	addi	a5,a5,4
    80003206:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003208:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000320c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003210:	10079073          	csrw	sstatus,a5
    syscall();
    80003214:	00000097          	auipc	ra,0x0
    80003218:	2cc080e7          	jalr	716(ra) # 800034e0 <syscall>
  if(killed(p))
    8000321c:	8526                	mv	a0,s1
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	910080e7          	jalr	-1776(ra) # 80002b2e <killed>
    80003226:	c911                	beqz	a0,8000323a <usertrap+0xac>
    80003228:	4901                	li	s2,0
    exit(-1);
    8000322a:	557d                	li	a0,-1
    8000322c:	fffff097          	auipc	ra,0xfffff
    80003230:	6e6080e7          	jalr	1766(ra) # 80002912 <exit>
  if(which_dev == 2)
    80003234:	4789                	li	a5,2
    80003236:	04f90f63          	beq	s2,a5,80003294 <usertrap+0x106>
  usertrapret();
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	dbe080e7          	jalr	-578(ra) # 80002ff8 <usertrapret>
}
    80003242:	60e2                	ld	ra,24(sp)
    80003244:	6442                	ld	s0,16(sp)
    80003246:	64a2                	ld	s1,8(sp)
    80003248:	6902                	ld	s2,0(sp)
    8000324a:	6105                	addi	sp,sp,32
    8000324c:	8082                	ret
      exit(-1);
    8000324e:	557d                	li	a0,-1
    80003250:	fffff097          	auipc	ra,0xfffff
    80003254:	6c2080e7          	jalr	1730(ra) # 80002912 <exit>
    80003258:	b765                	j	80003200 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000325a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000325e:	5890                	lw	a2,48(s1)
    80003260:	00008517          	auipc	a0,0x8
    80003264:	12050513          	addi	a0,a0,288 # 8000b380 <etext+0x380>
    80003268:	ffffd097          	auipc	ra,0xffffd
    8000326c:	342080e7          	jalr	834(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003270:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003274:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003278:	00008517          	auipc	a0,0x8
    8000327c:	13850513          	addi	a0,a0,312 # 8000b3b0 <etext+0x3b0>
    80003280:	ffffd097          	auipc	ra,0xffffd
    80003284:	32a080e7          	jalr	810(ra) # 800005aa <printf>
    setkilled(p);
    80003288:	8526                	mv	a0,s1
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	878080e7          	jalr	-1928(ra) # 80002b02 <setkilled>
    80003292:	b769                	j	8000321c <usertrap+0x8e>
    yield();
    80003294:	fffff097          	auipc	ra,0xfffff
    80003298:	438080e7          	jalr	1080(ra) # 800026cc <yield>
    8000329c:	bf79                	j	8000323a <usertrap+0xac>

000000008000329e <kerneltrap>:
{
    8000329e:	7179                	addi	sp,sp,-48
    800032a0:	f406                	sd	ra,40(sp)
    800032a2:	f022                	sd	s0,32(sp)
    800032a4:	ec26                	sd	s1,24(sp)
    800032a6:	e84a                	sd	s2,16(sp)
    800032a8:	e44e                	sd	s3,8(sp)
    800032aa:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800032ac:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032b0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800032b4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800032b8:	1004f793          	andi	a5,s1,256
    800032bc:	cb85                	beqz	a5,800032ec <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032be:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800032c2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800032c4:	ef85                	bnez	a5,800032fc <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	e0e080e7          	jalr	-498(ra) # 800030d4 <devintr>
    800032ce:	cd1d                	beqz	a0,8000330c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800032d0:	4789                	li	a5,2
    800032d2:	06f50a63          	beq	a0,a5,80003346 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800032d6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800032da:	10049073          	csrw	sstatus,s1
}
    800032de:	70a2                	ld	ra,40(sp)
    800032e0:	7402                	ld	s0,32(sp)
    800032e2:	64e2                	ld	s1,24(sp)
    800032e4:	6942                	ld	s2,16(sp)
    800032e6:	69a2                	ld	s3,8(sp)
    800032e8:	6145                	addi	sp,sp,48
    800032ea:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800032ec:	00008517          	auipc	a0,0x8
    800032f0:	0e450513          	addi	a0,a0,228 # 8000b3d0 <etext+0x3d0>
    800032f4:	ffffd097          	auipc	ra,0xffffd
    800032f8:	26c080e7          	jalr	620(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    800032fc:	00008517          	auipc	a0,0x8
    80003300:	0fc50513          	addi	a0,a0,252 # 8000b3f8 <etext+0x3f8>
    80003304:	ffffd097          	auipc	ra,0xffffd
    80003308:	25c080e7          	jalr	604(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    8000330c:	85ce                	mv	a1,s3
    8000330e:	00008517          	auipc	a0,0x8
    80003312:	10a50513          	addi	a0,a0,266 # 8000b418 <etext+0x418>
    80003316:	ffffd097          	auipc	ra,0xffffd
    8000331a:	294080e7          	jalr	660(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000331e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003322:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003326:	00008517          	auipc	a0,0x8
    8000332a:	10250513          	addi	a0,a0,258 # 8000b428 <etext+0x428>
    8000332e:	ffffd097          	auipc	ra,0xffffd
    80003332:	27c080e7          	jalr	636(ra) # 800005aa <printf>
    panic("kerneltrap");
    80003336:	00008517          	auipc	a0,0x8
    8000333a:	10a50513          	addi	a0,a0,266 # 8000b440 <etext+0x440>
    8000333e:	ffffd097          	auipc	ra,0xffffd
    80003342:	222080e7          	jalr	546(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003346:	fffff097          	auipc	ra,0xfffff
    8000334a:	b14080e7          	jalr	-1260(ra) # 80001e5a <myproc>
    8000334e:	d541                	beqz	a0,800032d6 <kerneltrap+0x38>
    80003350:	fffff097          	auipc	ra,0xfffff
    80003354:	b0a080e7          	jalr	-1270(ra) # 80001e5a <myproc>
    80003358:	4d18                	lw	a4,24(a0)
    8000335a:	4791                	li	a5,4
    8000335c:	f6f71de3          	bne	a4,a5,800032d6 <kerneltrap+0x38>
    yield();
    80003360:	fffff097          	auipc	ra,0xfffff
    80003364:	36c080e7          	jalr	876(ra) # 800026cc <yield>
    80003368:	b7bd                	j	800032d6 <kerneltrap+0x38>

000000008000336a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000336a:	1101                	addi	sp,sp,-32
    8000336c:	ec06                	sd	ra,24(sp)
    8000336e:	e822                	sd	s0,16(sp)
    80003370:	e426                	sd	s1,8(sp)
    80003372:	1000                	addi	s0,sp,32
    80003374:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003376:	fffff097          	auipc	ra,0xfffff
    8000337a:	ae4080e7          	jalr	-1308(ra) # 80001e5a <myproc>
  switch (n) {
    8000337e:	4795                	li	a5,5
    80003380:	0497e163          	bltu	a5,s1,800033c2 <argraw+0x58>
    80003384:	048a                	slli	s1,s1,0x2
    80003386:	00009717          	auipc	a4,0x9
    8000338a:	b9a70713          	addi	a4,a4,-1126 # 8000bf20 <states.0+0x30>
    8000338e:	94ba                	add	s1,s1,a4
    80003390:	409c                	lw	a5,0(s1)
    80003392:	97ba                	add	a5,a5,a4
    80003394:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80003396:	6d3c                	ld	a5,88(a0)
    80003398:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000339a:	60e2                	ld	ra,24(sp)
    8000339c:	6442                	ld	s0,16(sp)
    8000339e:	64a2                	ld	s1,8(sp)
    800033a0:	6105                	addi	sp,sp,32
    800033a2:	8082                	ret
    return p->trapframe->a1;
    800033a4:	6d3c                	ld	a5,88(a0)
    800033a6:	7fa8                	ld	a0,120(a5)
    800033a8:	bfcd                	j	8000339a <argraw+0x30>
    return p->trapframe->a2;
    800033aa:	6d3c                	ld	a5,88(a0)
    800033ac:	63c8                	ld	a0,128(a5)
    800033ae:	b7f5                	j	8000339a <argraw+0x30>
    return p->trapframe->a3;
    800033b0:	6d3c                	ld	a5,88(a0)
    800033b2:	67c8                	ld	a0,136(a5)
    800033b4:	b7dd                	j	8000339a <argraw+0x30>
    return p->trapframe->a4;
    800033b6:	6d3c                	ld	a5,88(a0)
    800033b8:	6bc8                	ld	a0,144(a5)
    800033ba:	b7c5                	j	8000339a <argraw+0x30>
    return p->trapframe->a5;
    800033bc:	6d3c                	ld	a5,88(a0)
    800033be:	6fc8                	ld	a0,152(a5)
    800033c0:	bfe9                	j	8000339a <argraw+0x30>
  panic("argraw");
    800033c2:	00008517          	auipc	a0,0x8
    800033c6:	08e50513          	addi	a0,a0,142 # 8000b450 <etext+0x450>
    800033ca:	ffffd097          	auipc	ra,0xffffd
    800033ce:	196080e7          	jalr	406(ra) # 80000560 <panic>

00000000800033d2 <fetchaddr>:
{
    800033d2:	1101                	addi	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	e426                	sd	s1,8(sp)
    800033da:	e04a                	sd	s2,0(sp)
    800033dc:	1000                	addi	s0,sp,32
    800033de:	84aa                	mv	s1,a0
    800033e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800033e2:	fffff097          	auipc	ra,0xfffff
    800033e6:	a78080e7          	jalr	-1416(ra) # 80001e5a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800033ea:	653c                	ld	a5,72(a0)
    800033ec:	02f4f863          	bgeu	s1,a5,8000341c <fetchaddr+0x4a>
    800033f0:	00848713          	addi	a4,s1,8
    800033f4:	02e7e663          	bltu	a5,a4,80003420 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800033f8:	46a1                	li	a3,8
    800033fa:	8626                	mv	a2,s1
    800033fc:	85ca                	mv	a1,s2
    800033fe:	6928                	ld	a0,80(a0)
    80003400:	ffffe097          	auipc	ra,0xffffe
    80003404:	78e080e7          	jalr	1934(ra) # 80001b8e <copyin>
    80003408:	00a03533          	snez	a0,a0
    8000340c:	40a0053b          	negw	a0,a0
}
    80003410:	60e2                	ld	ra,24(sp)
    80003412:	6442                	ld	s0,16(sp)
    80003414:	64a2                	ld	s1,8(sp)
    80003416:	6902                	ld	s2,0(sp)
    80003418:	6105                	addi	sp,sp,32
    8000341a:	8082                	ret
    return -1;
    8000341c:	557d                	li	a0,-1
    8000341e:	bfcd                	j	80003410 <fetchaddr+0x3e>
    80003420:	557d                	li	a0,-1
    80003422:	b7fd                	j	80003410 <fetchaddr+0x3e>

0000000080003424 <fetchstr>:
{
    80003424:	7179                	addi	sp,sp,-48
    80003426:	f406                	sd	ra,40(sp)
    80003428:	f022                	sd	s0,32(sp)
    8000342a:	ec26                	sd	s1,24(sp)
    8000342c:	e84a                	sd	s2,16(sp)
    8000342e:	e44e                	sd	s3,8(sp)
    80003430:	1800                	addi	s0,sp,48
    80003432:	892a                	mv	s2,a0
    80003434:	84ae                	mv	s1,a1
    80003436:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003438:	fffff097          	auipc	ra,0xfffff
    8000343c:	a22080e7          	jalr	-1502(ra) # 80001e5a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003440:	86ce                	mv	a3,s3
    80003442:	864a                	mv	a2,s2
    80003444:	85a6                	mv	a1,s1
    80003446:	6928                	ld	a0,80(a0)
    80003448:	ffffe097          	auipc	ra,0xffffe
    8000344c:	7d4080e7          	jalr	2004(ra) # 80001c1c <copyinstr>
    80003450:	00054e63          	bltz	a0,8000346c <fetchstr+0x48>
  return strlen(buf);
    80003454:	8526                	mv	a0,s1
    80003456:	ffffe097          	auipc	ra,0xffffe
    8000345a:	b44080e7          	jalr	-1212(ra) # 80000f9a <strlen>
}
    8000345e:	70a2                	ld	ra,40(sp)
    80003460:	7402                	ld	s0,32(sp)
    80003462:	64e2                	ld	s1,24(sp)
    80003464:	6942                	ld	s2,16(sp)
    80003466:	69a2                	ld	s3,8(sp)
    80003468:	6145                	addi	sp,sp,48
    8000346a:	8082                	ret
    return -1;
    8000346c:	557d                	li	a0,-1
    8000346e:	bfc5                	j	8000345e <fetchstr+0x3a>

0000000080003470 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003470:	1101                	addi	sp,sp,-32
    80003472:	ec06                	sd	ra,24(sp)
    80003474:	e822                	sd	s0,16(sp)
    80003476:	e426                	sd	s1,8(sp)
    80003478:	1000                	addi	s0,sp,32
    8000347a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	eee080e7          	jalr	-274(ra) # 8000336a <argraw>
    80003484:	c088                	sw	a0,0(s1)
}
    80003486:	60e2                	ld	ra,24(sp)
    80003488:	6442                	ld	s0,16(sp)
    8000348a:	64a2                	ld	s1,8(sp)
    8000348c:	6105                	addi	sp,sp,32
    8000348e:	8082                	ret

0000000080003490 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80003490:	1101                	addi	sp,sp,-32
    80003492:	ec06                	sd	ra,24(sp)
    80003494:	e822                	sd	s0,16(sp)
    80003496:	e426                	sd	s1,8(sp)
    80003498:	1000                	addi	s0,sp,32
    8000349a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000349c:	00000097          	auipc	ra,0x0
    800034a0:	ece080e7          	jalr	-306(ra) # 8000336a <argraw>
    800034a4:	e088                	sd	a0,0(s1)
}
    800034a6:	60e2                	ld	ra,24(sp)
    800034a8:	6442                	ld	s0,16(sp)
    800034aa:	64a2                	ld	s1,8(sp)
    800034ac:	6105                	addi	sp,sp,32
    800034ae:	8082                	ret

00000000800034b0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800034b0:	1101                	addi	sp,sp,-32
    800034b2:	ec06                	sd	ra,24(sp)
    800034b4:	e822                	sd	s0,16(sp)
    800034b6:	e426                	sd	s1,8(sp)
    800034b8:	e04a                	sd	s2,0(sp)
    800034ba:	1000                	addi	s0,sp,32
    800034bc:	84ae                	mv	s1,a1
    800034be:	8932                	mv	s2,a2
  *ip = argraw(n);
    800034c0:	00000097          	auipc	ra,0x0
    800034c4:	eaa080e7          	jalr	-342(ra) # 8000336a <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800034c8:	864a                	mv	a2,s2
    800034ca:	85a6                	mv	a1,s1
    800034cc:	00000097          	auipc	ra,0x0
    800034d0:	f58080e7          	jalr	-168(ra) # 80003424 <fetchstr>
}
    800034d4:	60e2                	ld	ra,24(sp)
    800034d6:	6442                	ld	s0,16(sp)
    800034d8:	64a2                	ld	s1,8(sp)
    800034da:	6902                	ld	s2,0(sp)
    800034dc:	6105                	addi	sp,sp,32
    800034de:	8082                	ret

00000000800034e0 <syscall>:
[SYS_recvfrom]      sys_recvfrom,
};

void
syscall(void)
{
    800034e0:	1101                	addi	sp,sp,-32
    800034e2:	ec06                	sd	ra,24(sp)
    800034e4:	e822                	sd	s0,16(sp)
    800034e6:	e426                	sd	s1,8(sp)
    800034e8:	e04a                	sd	s2,0(sp)
    800034ea:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	96e080e7          	jalr	-1682(ra) # 80001e5a <myproc>
    800034f4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800034f6:	05853903          	ld	s2,88(a0)
    800034fa:	0a893783          	ld	a5,168(s2)
    800034fe:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003502:	37fd                	addiw	a5,a5,-1
    80003504:	02100713          	li	a4,33
    80003508:	00f76f63          	bltu	a4,a5,80003526 <syscall+0x46>
    8000350c:	00369713          	slli	a4,a3,0x3
    80003510:	00009797          	auipc	a5,0x9
    80003514:	a2878793          	addi	a5,a5,-1496 # 8000bf38 <syscalls>
    80003518:	97ba                	add	a5,a5,a4
    8000351a:	639c                	ld	a5,0(a5)
    8000351c:	c789                	beqz	a5,80003526 <syscall+0x46>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000351e:	9782                	jalr	a5
    80003520:	06a93823          	sd	a0,112(s2)
    80003524:	a839                	j	80003542 <syscall+0x62>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003526:	15848613          	addi	a2,s1,344
    8000352a:	588c                	lw	a1,48(s1)
    8000352c:	00008517          	auipc	a0,0x8
    80003530:	f2c50513          	addi	a0,a0,-212 # 8000b458 <etext+0x458>
    80003534:	ffffd097          	auipc	ra,0xffffd
    80003538:	076080e7          	jalr	118(ra) # 800005aa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000353c:	6cbc                	ld	a5,88(s1)
    8000353e:	577d                	li	a4,-1
    80003540:	fbb8                	sd	a4,112(a5)
  }
}
    80003542:	60e2                	ld	ra,24(sp)
    80003544:	6442                	ld	s0,16(sp)
    80003546:	64a2                	ld	s1,8(sp)
    80003548:	6902                	ld	s2,0(sp)
    8000354a:	6105                	addi	sp,sp,32
    8000354c:	8082                	ret

000000008000354e <sys_exit>:
#include "file.h"
#include "sys/net.h"
#include "sys/socket.h"
#include "proc.h"

uint64 sys_exit(void) {
    8000354e:	1101                	addi	sp,sp,-32
    80003550:	ec06                	sd	ra,24(sp)
    80003552:	e822                	sd	s0,16(sp)
    80003554:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003556:	fec40593          	addi	a1,s0,-20
    8000355a:	4501                	li	a0,0
    8000355c:	00000097          	auipc	ra,0x0
    80003560:	f14080e7          	jalr	-236(ra) # 80003470 <argint>
  exit(n);
    80003564:	fec42503          	lw	a0,-20(s0)
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	3aa080e7          	jalr	938(ra) # 80002912 <exit>
  return 0; // not reached
}
    80003570:	4501                	li	a0,0
    80003572:	60e2                	ld	ra,24(sp)
    80003574:	6442                	ld	s0,16(sp)
    80003576:	6105                	addi	sp,sp,32
    80003578:	8082                	ret

000000008000357a <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    8000357a:	1141                	addi	sp,sp,-16
    8000357c:	e406                	sd	ra,8(sp)
    8000357e:	e022                	sd	s0,0(sp)
    80003580:	0800                	addi	s0,sp,16
    80003582:	fffff097          	auipc	ra,0xfffff
    80003586:	8d8080e7          	jalr	-1832(ra) # 80001e5a <myproc>
    8000358a:	5908                	lw	a0,48(a0)
    8000358c:	60a2                	ld	ra,8(sp)
    8000358e:	6402                	ld	s0,0(sp)
    80003590:	0141                	addi	sp,sp,16
    80003592:	8082                	ret

0000000080003594 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80003594:	1141                	addi	sp,sp,-16
    80003596:	e406                	sd	ra,8(sp)
    80003598:	e022                	sd	s0,0(sp)
    8000359a:	0800                	addi	s0,sp,16
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	cc0080e7          	jalr	-832(ra) # 8000225c <fork>
    800035a4:	60a2                	ld	ra,8(sp)
    800035a6:	6402                	ld	s0,0(sp)
    800035a8:	0141                	addi	sp,sp,16
    800035aa:	8082                	ret

00000000800035ac <sys_wait>:

uint64 sys_wait(void) {
    800035ac:	1101                	addi	sp,sp,-32
    800035ae:	ec06                	sd	ra,24(sp)
    800035b0:	e822                	sd	s0,16(sp)
    800035b2:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800035b4:	fe840593          	addi	a1,s0,-24
    800035b8:	4501                	li	a0,0
    800035ba:	00000097          	auipc	ra,0x0
    800035be:	ed6080e7          	jalr	-298(ra) # 80003490 <argaddr>
  return wait(p);
    800035c2:	fe843503          	ld	a0,-24(s0)
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	6dc080e7          	jalr	1756(ra) # 80002ca2 <wait>
}
    800035ce:	60e2                	ld	ra,24(sp)
    800035d0:	6442                	ld	s0,16(sp)
    800035d2:	6105                	addi	sp,sp,32
    800035d4:	8082                	ret

00000000800035d6 <sys_sbrk>:

uint64 sys_sbrk(void) {
    800035d6:	7179                	addi	sp,sp,-48
    800035d8:	f406                	sd	ra,40(sp)
    800035da:	f022                	sd	s0,32(sp)
    800035dc:	ec26                	sd	s1,24(sp)
    800035de:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800035e0:	fdc40593          	addi	a1,s0,-36
    800035e4:	4501                	li	a0,0
    800035e6:	00000097          	auipc	ra,0x0
    800035ea:	e8a080e7          	jalr	-374(ra) # 80003470 <argint>
  addr = myproc()->sz;
    800035ee:	fffff097          	auipc	ra,0xfffff
    800035f2:	86c080e7          	jalr	-1940(ra) # 80001e5a <myproc>
    800035f6:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    800035f8:	fdc42503          	lw	a0,-36(s0)
    800035fc:	fffff097          	auipc	ra,0xfffff
    80003600:	bca080e7          	jalr	-1078(ra) # 800021c6 <growproc>
    80003604:	00054863          	bltz	a0,80003614 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80003608:	8526                	mv	a0,s1
    8000360a:	70a2                	ld	ra,40(sp)
    8000360c:	7402                	ld	s0,32(sp)
    8000360e:	64e2                	ld	s1,24(sp)
    80003610:	6145                	addi	sp,sp,48
    80003612:	8082                	ret
    return -1;
    80003614:	54fd                	li	s1,-1
    80003616:	bfcd                	j	80003608 <sys_sbrk+0x32>

0000000080003618 <sys_sleep>:

uint64 sys_sleep(void) {
    80003618:	7139                	addi	sp,sp,-64
    8000361a:	fc06                	sd	ra,56(sp)
    8000361c:	f822                	sd	s0,48(sp)
    8000361e:	f04a                	sd	s2,32(sp)
    80003620:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003622:	fcc40593          	addi	a1,s0,-52
    80003626:	4501                	li	a0,0
    80003628:	00000097          	auipc	ra,0x0
    8000362c:	e48080e7          	jalr	-440(ra) # 80003470 <argint>
  acquire(&tickslock);
    80003630:	00063517          	auipc	a0,0x63
    80003634:	a5050513          	addi	a0,a0,-1456 # 80066080 <tickslock>
    80003638:	ffffd097          	auipc	ra,0xffffd
    8000363c:	6de080e7          	jalr	1758(ra) # 80000d16 <acquire>
  ticks0 = ticks;
    80003640:	0000c917          	auipc	s2,0xc
    80003644:	78492903          	lw	s2,1924(s2) # 8000fdc4 <ticks>
  while (ticks - ticks0 < n) {
    80003648:	fcc42783          	lw	a5,-52(s0)
    8000364c:	c3b9                	beqz	a5,80003692 <sys_sleep+0x7a>
    8000364e:	f426                	sd	s1,40(sp)
    80003650:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003652:	00063997          	auipc	s3,0x63
    80003656:	a2e98993          	addi	s3,s3,-1490 # 80066080 <tickslock>
    8000365a:	0000c497          	auipc	s1,0xc
    8000365e:	76a48493          	addi	s1,s1,1898 # 8000fdc4 <ticks>
    if (killed(myproc())) {
    80003662:	ffffe097          	auipc	ra,0xffffe
    80003666:	7f8080e7          	jalr	2040(ra) # 80001e5a <myproc>
    8000366a:	fffff097          	auipc	ra,0xfffff
    8000366e:	4c4080e7          	jalr	1220(ra) # 80002b2e <killed>
    80003672:	ed15                	bnez	a0,800036ae <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003674:	85ce                	mv	a1,s3
    80003676:	8526                	mv	a0,s1
    80003678:	fffff097          	auipc	ra,0xfffff
    8000367c:	090080e7          	jalr	144(ra) # 80002708 <sleep>
  while (ticks - ticks0 < n) {
    80003680:	409c                	lw	a5,0(s1)
    80003682:	412787bb          	subw	a5,a5,s2
    80003686:	fcc42703          	lw	a4,-52(s0)
    8000368a:	fce7ece3          	bltu	a5,a4,80003662 <sys_sleep+0x4a>
    8000368e:	74a2                	ld	s1,40(sp)
    80003690:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003692:	00063517          	auipc	a0,0x63
    80003696:	9ee50513          	addi	a0,a0,-1554 # 80066080 <tickslock>
    8000369a:	ffffd097          	auipc	ra,0xffffd
    8000369e:	72c080e7          	jalr	1836(ra) # 80000dc6 <release>
  return 0;
    800036a2:	4501                	li	a0,0
}
    800036a4:	70e2                	ld	ra,56(sp)
    800036a6:	7442                	ld	s0,48(sp)
    800036a8:	7902                	ld	s2,32(sp)
    800036aa:	6121                	addi	sp,sp,64
    800036ac:	8082                	ret
      release(&tickslock);
    800036ae:	00063517          	auipc	a0,0x63
    800036b2:	9d250513          	addi	a0,a0,-1582 # 80066080 <tickslock>
    800036b6:	ffffd097          	auipc	ra,0xffffd
    800036ba:	710080e7          	jalr	1808(ra) # 80000dc6 <release>
      return -1;
    800036be:	557d                	li	a0,-1
    800036c0:	74a2                	ld	s1,40(sp)
    800036c2:	69e2                	ld	s3,24(sp)
    800036c4:	b7c5                	j	800036a4 <sys_sleep+0x8c>

00000000800036c6 <sys_kill>:

uint64 sys_kill(void) {
    800036c6:	1101                	addi	sp,sp,-32
    800036c8:	ec06                	sd	ra,24(sp)
    800036ca:	e822                	sd	s0,16(sp)
    800036cc:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800036ce:	fec40593          	addi	a1,s0,-20
    800036d2:	4501                	li	a0,0
    800036d4:	00000097          	auipc	ra,0x0
    800036d8:	d9c080e7          	jalr	-612(ra) # 80003470 <argint>
  return kill(pid);
    800036dc:	fec42503          	lw	a0,-20(s0)
    800036e0:	fffff097          	auipc	ra,0xfffff
    800036e4:	3b0080e7          	jalr	944(ra) # 80002a90 <kill>
}
    800036e8:	60e2                	ld	ra,24(sp)
    800036ea:	6442                	ld	s0,16(sp)
    800036ec:	6105                	addi	sp,sp,32
    800036ee:	8082                	ret

00000000800036f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800036f0:	1101                	addi	sp,sp,-32
    800036f2:	ec06                	sd	ra,24(sp)
    800036f4:	e822                	sd	s0,16(sp)
    800036f6:	e426                	sd	s1,8(sp)
    800036f8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800036fa:	00063517          	auipc	a0,0x63
    800036fe:	98650513          	addi	a0,a0,-1658 # 80066080 <tickslock>
    80003702:	ffffd097          	auipc	ra,0xffffd
    80003706:	614080e7          	jalr	1556(ra) # 80000d16 <acquire>
  xticks = ticks;
    8000370a:	0000c497          	auipc	s1,0xc
    8000370e:	6ba4a483          	lw	s1,1722(s1) # 8000fdc4 <ticks>
  release(&tickslock);
    80003712:	00063517          	auipc	a0,0x63
    80003716:	96e50513          	addi	a0,a0,-1682 # 80066080 <tickslock>
    8000371a:	ffffd097          	auipc	ra,0xffffd
    8000371e:	6ac080e7          	jalr	1708(ra) # 80000dc6 <release>
  return xticks;
}
    80003722:	02049513          	slli	a0,s1,0x20
    80003726:	9101                	srli	a0,a0,0x20
    80003728:	60e2                	ld	ra,24(sp)
    8000372a:	6442                	ld	s0,16(sp)
    8000372c:	64a2                	ld	s1,8(sp)
    8000372e:	6105                	addi	sp,sp,32
    80003730:	8082                	ret

0000000080003732 <sys_spoon>:

uint64 sys_spoon(void) {
    80003732:	1101                	addi	sp,sp,-32
    80003734:	ec06                	sd	ra,24(sp)
    80003736:	e822                	sd	s0,16(sp)
    80003738:	1000                	addi	s0,sp,32
  // obtain the argument from the stack, we need some special handling
  uint64 addr;
  argaddr(0, &addr);
    8000373a:	fe840593          	addi	a1,s0,-24
    8000373e:	4501                	li	a0,0
    80003740:	00000097          	auipc	ra,0x0
    80003744:	d50080e7          	jalr	-688(ra) # 80003490 <argaddr>
  return spoon((void *)addr);
    80003748:	fe843503          	ld	a0,-24(s0)
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	7da080e7          	jalr	2010(ra) # 80002f26 <spoon>
}
    80003754:	60e2                	ld	ra,24(sp)
    80003756:	6442                	ld	s0,16(sp)
    80003758:	6105                	addi	sp,sp,32
    8000375a:	8082                	ret

000000008000375c <sys_create_thread>:

uint64 sys_create_thread(void *arg) {
    8000375c:	7179                	addi	sp,sp,-48
    8000375e:	f406                	sd	ra,40(sp)
    80003760:	f022                	sd	s0,32(sp)
    80003762:	1800                	addi	s0,sp,48
  uint64 fn_addr, args_addr, stack_addr, exit_fn;
  argaddr(0, &fn_addr);
    80003764:	fe840593          	addi	a1,s0,-24
    80003768:	4501                	li	a0,0
    8000376a:	00000097          	auipc	ra,0x0
    8000376e:	d26080e7          	jalr	-730(ra) # 80003490 <argaddr>
  argaddr(1, &args_addr);
    80003772:	fe040593          	addi	a1,s0,-32
    80003776:	4505                	li	a0,1
    80003778:	00000097          	auipc	ra,0x0
    8000377c:	d18080e7          	jalr	-744(ra) # 80003490 <argaddr>
  argaddr(2, &stack_addr);
    80003780:	fd840593          	addi	a1,s0,-40
    80003784:	4509                	li	a0,2
    80003786:	00000097          	auipc	ra,0x0
    8000378a:	d0a080e7          	jalr	-758(ra) # 80003490 <argaddr>
  argaddr(3, &exit_fn);
    8000378e:	fd040593          	addi	a1,s0,-48
    80003792:	450d                	li	a0,3
    80003794:	00000097          	auipc	ra,0x0
    80003798:	cfc080e7          	jalr	-772(ra) # 80003490 <argaddr>
  return create_thread((void *)fn_addr, (void *)args_addr, (void *)stack_addr,
    8000379c:	fd043683          	ld	a3,-48(s0)
    800037a0:	fd843603          	ld	a2,-40(s0)
    800037a4:	fe043583          	ld	a1,-32(s0)
    800037a8:	fe843503          	ld	a0,-24(s0)
    800037ac:	fffff097          	auipc	ra,0xfffff
    800037b0:	bf6080e7          	jalr	-1034(ra) # 800023a2 <create_thread>
                       (void *)exit_fn);
}
    800037b4:	70a2                	ld	ra,40(sp)
    800037b6:	7402                	ld	s0,32(sp)
    800037b8:	6145                	addi	sp,sp,48
    800037ba:	8082                	ret

00000000800037bc <sys_join_thread>:

uint64 sys_join_thread(void *arg) {
    800037bc:	1101                	addi	sp,sp,-32
    800037be:	ec06                	sd	ra,24(sp)
    800037c0:	e822                	sd	s0,16(sp)
    800037c2:	1000                	addi	s0,sp,32
  uint64 thread_id, status_addr;
  argaddr(0, &thread_id);
    800037c4:	fe840593          	addi	a1,s0,-24
    800037c8:	4501                	li	a0,0
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	cc6080e7          	jalr	-826(ra) # 80003490 <argaddr>
  argaddr(1, &status_addr);
    800037d2:	fe040593          	addi	a1,s0,-32
    800037d6:	4505                	li	a0,1
    800037d8:	00000097          	auipc	ra,0x0
    800037dc:	cb8080e7          	jalr	-840(ra) # 80003490 <argaddr>
  return join_thread(thread_id, status_addr);
    800037e0:	fe043583          	ld	a1,-32(s0)
    800037e4:	fe843503          	ld	a0,-24(s0)
    800037e8:	fffff097          	auipc	ra,0xfffff
    800037ec:	378080e7          	jalr	888(ra) # 80002b60 <join_thread>
}
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	6105                	addi	sp,sp,32
    800037f6:	8082                	ret

00000000800037f8 <sys_thread_exit>:

uint64 sys_thread_exit(void *arg) {
    800037f8:	1101                	addi	sp,sp,-32
    800037fa:	ec06                	sd	ra,24(sp)
    800037fc:	e822                	sd	s0,16(sp)
    800037fe:	1000                	addi	s0,sp,32
  uint64 status_addr;
  argaddr(0, &status_addr);
    80003800:	fe840593          	addi	a1,s0,-24
    80003804:	4501                	li	a0,0
    80003806:	00000097          	auipc	ra,0x0
    8000380a:	c8a080e7          	jalr	-886(ra) # 80003490 <argaddr>
  return thread_exit(status_addr);
    8000380e:	fe843503          	ld	a0,-24(s0)
    80003812:	fffff097          	auipc	ra,0xfffff
    80003816:	02a080e7          	jalr	42(ra) # 8000283c <thread_exit>
}
    8000381a:	60e2                	ld	ra,24(sp)
    8000381c:	6442                	ld	s0,16(sp)
    8000381e:	6105                	addi	sp,sp,32
    80003820:	8082                	ret

0000000080003822 <sys_bind>:

uint64 sys_bind(void) {
    80003822:	715d                	addi	sp,sp,-80
    80003824:	e486                	sd	ra,72(sp)
    80003826:	e0a2                	sd	s0,64(sp)
    80003828:	0880                	addi	s0,sp,80
    int fd;
    uint64 uaddr;
    int addrlen;

    argint(0, &fd);
    8000382a:	fdc40593          	addi	a1,s0,-36
    8000382e:	4501                	li	a0,0
    80003830:	00000097          	auipc	ra,0x0
    80003834:	c40080e7          	jalr	-960(ra) # 80003470 <argint>
    argaddr(1, &uaddr);
    80003838:	fd040593          	addi	a1,s0,-48
    8000383c:	4505                	li	a0,1
    8000383e:	00000097          	auipc	ra,0x0
    80003842:	c52080e7          	jalr	-942(ra) # 80003490 <argaddr>
    argint(2, &addrlen);
    80003846:	fcc40593          	addi	a1,s0,-52
    8000384a:	4509                	li	a0,2
    8000384c:	00000097          	auipc	ra,0x0
    80003850:	c24080e7          	jalr	-988(ra) # 80003470 <argint>

    struct file *f = myproc()->ofile[fd];
    80003854:	ffffe097          	auipc	ra,0xffffe
    80003858:	606080e7          	jalr	1542(ra) # 80001e5a <myproc>
    8000385c:	fdc42783          	lw	a5,-36(s0)
    80003860:	07e9                	addi	a5,a5,26
    80003862:	078e                	slli	a5,a5,0x3
    80003864:	953e                	add	a0,a0,a5
    80003866:	611c                	ld	a5,0(a0)
    if (f == 0 || f->type != FD_SOCKET)
    80003868:	cbb9                	beqz	a5,800038be <sys_bind+0x9c>
    8000386a:	4394                	lw	a3,0(a5)
    8000386c:	4711                	li	a4,4
        return -1;
    8000386e:	557d                	li	a0,-1
    if (f == 0 || f->type != FD_SOCKET)
    80003870:	04e69363          	bne	a3,a4,800038b6 <sys_bind+0x94>

    struct socket *sock = f->sock;

    struct sockaddr_in addr;
    if (addrlen > sizeof(addr))
    80003874:	fcc42683          	lw	a3,-52(s0)
    80003878:	4741                	li	a4,16
    8000387a:	02d76e63          	bltu	a4,a3,800038b6 <sys_bind+0x94>
    8000387e:	fc26                	sd	s1,56(sp)
    struct socket *sock = f->sock;
    80003880:	7384                	ld	s1,32(a5)
        return -1;

    // Copy user memory → kernel struct
    if (copyin(myproc()->pagetable, (char*)&addr, uaddr, addrlen) < 0)
    80003882:	ffffe097          	auipc	ra,0xffffe
    80003886:	5d8080e7          	jalr	1496(ra) # 80001e5a <myproc>
    8000388a:	fcc42683          	lw	a3,-52(s0)
    8000388e:	fd043603          	ld	a2,-48(s0)
    80003892:	fb840593          	addi	a1,s0,-72
    80003896:	6928                	ld	a0,80(a0)
    80003898:	ffffe097          	auipc	ra,0xffffe
    8000389c:	2f6080e7          	jalr	758(ra) # 80001b8e <copyin>
    800038a0:	02054163          	bltz	a0,800038c2 <sys_bind+0xa0>
        return -1;

    return sock->ops->bind(sock, (struct sockaddr*)&addr, addrlen);
    800038a4:	64bc                	ld	a5,72(s1)
    800038a6:	639c                	ld	a5,0(a5)
    800038a8:	fcc42603          	lw	a2,-52(s0)
    800038ac:	fb840593          	addi	a1,s0,-72
    800038b0:	8526                	mv	a0,s1
    800038b2:	9782                	jalr	a5
    800038b4:	74e2                	ld	s1,56(sp)
}
    800038b6:	60a6                	ld	ra,72(sp)
    800038b8:	6406                	ld	s0,64(sp)
    800038ba:	6161                	addi	sp,sp,80
    800038bc:	8082                	ret
        return -1;
    800038be:	557d                	li	a0,-1
    800038c0:	bfdd                	j	800038b6 <sys_bind+0x94>
        return -1;
    800038c2:	557d                	li	a0,-1
    800038c4:	74e2                	ld	s1,56(sp)
    800038c6:	bfc5                	j	800038b6 <sys_bind+0x94>

00000000800038c8 <sys_listen>:
uint64 sys_listen(void *arg) {
    800038c8:	1101                	addi	sp,sp,-32
    800038ca:	ec06                	sd	ra,24(sp)
    800038cc:	e822                	sd	s0,16(sp)
    800038ce:	1000                	addi	s0,sp,32
  uint64 socket, backlog;
  argaddr(0, &socket);
    800038d0:	fe840593          	addi	a1,s0,-24
    800038d4:	4501                	li	a0,0
    800038d6:	00000097          	auipc	ra,0x0
    800038da:	bba080e7          	jalr	-1094(ra) # 80003490 <argaddr>
  argaddr(1, &backlog);
    800038de:	fe040593          	addi	a1,s0,-32
    800038e2:	4505                	li	a0,1
    800038e4:	00000097          	auipc	ra,0x0
    800038e8:	bac080e7          	jalr	-1108(ra) # 80003490 <argaddr>
  return listen(socket, backlog);
    800038ec:	fe042583          	lw	a1,-32(s0)
    800038f0:	fe842503          	lw	a0,-24(s0)
    800038f4:	00005097          	auipc	ra,0x5
    800038f8:	bbc080e7          	jalr	-1092(ra) # 800084b0 <listen>
}
    800038fc:	60e2                	ld	ra,24(sp)
    800038fe:	6442                	ld	s0,16(sp)
    80003900:	6105                	addi	sp,sp,32
    80003902:	8082                	ret

0000000080003904 <sys_accept>:

uint64 sys_accept(void *arg) {
    80003904:	7139                	addi	sp,sp,-64
    80003906:	fc06                	sd	ra,56(sp)
    80003908:	f822                	sd	s0,48(sp)
    8000390a:	f426                	sd	s1,40(sp)
    8000390c:	0080                	addi	s0,sp,64
  uint64 socket;
  uint64 address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    8000390e:	fd840593          	addi	a1,s0,-40
    80003912:	4501                	li	a0,0
    80003914:	00000097          	auipc	ra,0x0
    80003918:	b7c080e7          	jalr	-1156(ra) # 80003490 <argaddr>
  argaddr(1, (uint64 *)&address);
    8000391c:	fc040493          	addi	s1,s0,-64
    80003920:	85a6                	mv	a1,s1
    80003922:	4505                	li	a0,1
    80003924:	00000097          	auipc	ra,0x0
    80003928:	b6c080e7          	jalr	-1172(ra) # 80003490 <argaddr>
  argaddr(2, &address_len);
    8000392c:	fd040593          	addi	a1,s0,-48
    80003930:	4509                	li	a0,2
    80003932:	00000097          	auipc	ra,0x0
    80003936:	b5e080e7          	jalr	-1186(ra) # 80003490 <argaddr>
  return accept(socket, &address, address_len);
    8000393a:	fd042603          	lw	a2,-48(s0)
    8000393e:	85a6                	mv	a1,s1
    80003940:	fd842503          	lw	a0,-40(s0)
    80003944:	00005097          	auipc	ra,0x5
    80003948:	b9a080e7          	jalr	-1126(ra) # 800084de <accept>
}
    8000394c:	70e2                	ld	ra,56(sp)
    8000394e:	7442                	ld	s0,48(sp)
    80003950:	74a2                	ld	s1,40(sp)
    80003952:	6121                	addi	sp,sp,64
    80003954:	8082                	ret

0000000080003956 <sys_socket>:

uint64 sys_socket(void *arg) {
    80003956:	7139                	addi	sp,sp,-64
    80003958:	fc06                	sd	ra,56(sp)
    8000395a:	f822                	sd	s0,48(sp)
    8000395c:	0080                	addi	s0,sp,64
  uint64 address_family, address_socktype, protocol;
  argaddr(0, &address_family);
    8000395e:	fd840593          	addi	a1,s0,-40
    80003962:	4501                	li	a0,0
    80003964:	00000097          	auipc	ra,0x0
    80003968:	b2c080e7          	jalr	-1236(ra) # 80003490 <argaddr>
  argaddr(1, &address_socktype);
    8000396c:	fd040593          	addi	a1,s0,-48
    80003970:	4505                	li	a0,1
    80003972:	00000097          	auipc	ra,0x0
    80003976:	b1e080e7          	jalr	-1250(ra) # 80003490 <argaddr>
  argaddr(2, &protocol);
    8000397a:	fc840593          	addi	a1,s0,-56
    8000397e:	4509                	li	a0,2
    80003980:	00000097          	auipc	ra,0x0
    80003984:	b10080e7          	jalr	-1264(ra) # 80003490 <argaddr>

  struct socket *sock = (struct socket *)kalloc();
    80003988:	ffffd097          	auipc	ra,0xffffd
    8000398c:	27c080e7          	jalr	636(ra) # 80000c04 <kalloc>
  if (sock == 0) {
    80003990:	cd29                	beqz	a0,800039ea <sys_socket+0x94>
    80003992:	f426                	sd	s1,40(sp)
    80003994:	f04a                	sd	s2,32(sp)
    80003996:	84aa                	mv	s1,a0
    printf("ERROR: kalloc\n");
    return -1;
  }
  memset(sock, 0, PGSIZE);
    80003998:	6605                	lui	a2,0x1
    8000399a:	4581                	li	a1,0
    8000399c:	ffffd097          	auipc	ra,0xffffd
    800039a0:	472080e7          	jalr	1138(ra) # 80000e0e <memset>

  initsocket(sock, address_family, address_socktype, protocol);
    800039a4:	fc842683          	lw	a3,-56(s0)
    800039a8:	fd042603          	lw	a2,-48(s0)
    800039ac:	fd842583          	lw	a1,-40(s0)
    800039b0:	8526                	mv	a0,s1
    800039b2:	00005097          	auipc	ra,0x5
    800039b6:	bd6080e7          	jalr	-1066(ra) # 80008588 <initsocket>

  struct file *f = filealloc();
    800039ba:	00002097          	auipc	ra,0x2
    800039be:	9be080e7          	jalr	-1602(ra) # 80005378 <filealloc>
    800039c2:	892a                	mv	s2,a0
  if (f == 0) {
    800039c4:	cd0d                	beqz	a0,800039fe <sys_socket+0xa8>
    kfree(sock);
    return -1;
  }

  int fd = fdalloc(f);
    800039c6:	00002097          	auipc	ra,0x2
    800039ca:	774080e7          	jalr	1908(ra) # 8000613a <fdalloc>
  if (fd < 0) {
    800039ce:	04054163          	bltz	a0,80003a10 <sys_socket+0xba>
    fileclose(f);
    kfree(sock);
    return -1;
  }

  f->type = FD_SOCKET;
    800039d2:	4791                	li	a5,4
    800039d4:	00f92023          	sw	a5,0(s2)
  f->sock = sock;
    800039d8:	02993023          	sd	s1,32(s2)
  sock->fd = fd;
    800039dc:	c0a8                	sw	a0,64(s1)
    800039de:	74a2                	ld	s1,40(sp)
    800039e0:	7902                	ld	s2,32(sp)
  // sock->rx_head = 0;
  // sock->rx_tail = 0;

  return fd;
}
    800039e2:	70e2                	ld	ra,56(sp)
    800039e4:	7442                	ld	s0,48(sp)
    800039e6:	6121                	addi	sp,sp,64
    800039e8:	8082                	ret
    printf("ERROR: kalloc\n");
    800039ea:	00008517          	auipc	a0,0x8
    800039ee:	a8e50513          	addi	a0,a0,-1394 # 8000b478 <etext+0x478>
    800039f2:	ffffd097          	auipc	ra,0xffffd
    800039f6:	bb8080e7          	jalr	-1096(ra) # 800005aa <printf>
    return -1;
    800039fa:	557d                	li	a0,-1
    800039fc:	b7dd                	j	800039e2 <sys_socket+0x8c>
    kfree(sock);
    800039fe:	8526                	mv	a0,s1
    80003a00:	ffffd097          	auipc	ra,0xffffd
    80003a04:	09c080e7          	jalr	156(ra) # 80000a9c <kfree>
    return -1;
    80003a08:	557d                	li	a0,-1
    80003a0a:	74a2                	ld	s1,40(sp)
    80003a0c:	7902                	ld	s2,32(sp)
    80003a0e:	bfd1                	j	800039e2 <sys_socket+0x8c>
    fileclose(f);
    80003a10:	854a                	mv	a0,s2
    80003a12:	00002097          	auipc	ra,0x2
    80003a16:	a22080e7          	jalr	-1502(ra) # 80005434 <fileclose>
    kfree(sock);
    80003a1a:	8526                	mv	a0,s1
    80003a1c:	ffffd097          	auipc	ra,0xffffd
    80003a20:	080080e7          	jalr	128(ra) # 80000a9c <kfree>
    return -1;
    80003a24:	557d                	li	a0,-1
    80003a26:	74a2                	ld	s1,40(sp)
    80003a28:	7902                	ld	s2,32(sp)
    80003a2a:	bf65                	j	800039e2 <sys_socket+0x8c>

0000000080003a2c <sys_connect>:

uint64 sys_connect(void *arg) {
    80003a2c:	7139                	addi	sp,sp,-64
    80003a2e:	fc06                	sd	ra,56(sp)
    80003a30:	f822                	sd	s0,48(sp)
    80003a32:	f426                	sd	s1,40(sp)
    80003a34:	0080                	addi	s0,sp,64
  uint64 socket, address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    80003a36:	fd840593          	addi	a1,s0,-40
    80003a3a:	4501                	li	a0,0
    80003a3c:	00000097          	auipc	ra,0x0
    80003a40:	a54080e7          	jalr	-1452(ra) # 80003490 <argaddr>
  argaddr(1, (uint64 *)&address);
    80003a44:	fc040493          	addi	s1,s0,-64
    80003a48:	85a6                	mv	a1,s1
    80003a4a:	4505                	li	a0,1
    80003a4c:	00000097          	auipc	ra,0x0
    80003a50:	a44080e7          	jalr	-1468(ra) # 80003490 <argaddr>
  argaddr(2, &address_len);
    80003a54:	fd040593          	addi	a1,s0,-48
    80003a58:	4509                	li	a0,2
    80003a5a:	00000097          	auipc	ra,0x0
    80003a5e:	a36080e7          	jalr	-1482(ra) # 80003490 <argaddr>
  return connect(socket, &address, address_len);
    80003a62:	fd042603          	lw	a2,-48(s0)
    80003a66:	85a6                	mv	a1,s1
    80003a68:	fd842503          	lw	a0,-40(s0)
    80003a6c:	00005097          	auipc	ra,0x5
    80003a70:	b0a080e7          	jalr	-1270(ra) # 80008576 <connect>
}
    80003a74:	70e2                	ld	ra,56(sp)
    80003a76:	7442                	ld	s0,48(sp)
    80003a78:	74a2                	ld	s1,40(sp)
    80003a7a:	6121                	addi	sp,sp,64
    80003a7c:	8082                	ret

0000000080003a7e <sys_send>:

uint64
sys_send(void)
{
    80003a7e:	7179                	addi	sp,sp,-48
    80003a80:	f406                	sd	ra,40(sp)
    80003a82:	f022                	sd	s0,32(sp)
    80003a84:	1800                	addi	s0,sp,48
  int fd;
  uint64 buf;   // user pointer
  int len;
  int flags;

  argint(0, &fd);
    80003a86:	fec40593          	addi	a1,s0,-20
    80003a8a:	4501                	li	a0,0
    80003a8c:	00000097          	auipc	ra,0x0
    80003a90:	9e4080e7          	jalr	-1564(ra) # 80003470 <argint>
  argaddr(1, &buf);
    80003a94:	fe040593          	addi	a1,s0,-32
    80003a98:	4505                	li	a0,1
    80003a9a:	00000097          	auipc	ra,0x0
    80003a9e:	9f6080e7          	jalr	-1546(ra) # 80003490 <argaddr>
  argint(2, &len);
    80003aa2:	fdc40593          	addi	a1,s0,-36
    80003aa6:	4509                	li	a0,2
    80003aa8:	00000097          	auipc	ra,0x0
    80003aac:	9c8080e7          	jalr	-1592(ra) # 80003470 <argint>
  argint(3, &flags);
    80003ab0:	fd840593          	addi	a1,s0,-40
    80003ab4:	450d                	li	a0,3
    80003ab6:	00000097          	auipc	ra,0x0
    80003aba:	9ba080e7          	jalr	-1606(ra) # 80003470 <argint>

  struct file *f = myproc()->ofile[fd];
    80003abe:	ffffe097          	auipc	ra,0xffffe
    80003ac2:	39c080e7          	jalr	924(ra) # 80001e5a <myproc>
    80003ac6:	fec42703          	lw	a4,-20(s0)
    80003aca:	01a70793          	addi	a5,a4,26
    80003ace:	078e                	slli	a5,a5,0x3
    80003ad0:	97aa                	add	a5,a5,a0
    80003ad2:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003ad4:	c795                	beqz	a5,80003b00 <sys_send+0x82>
    80003ad6:	4394                	lw	a3,0(a5)
    80003ad8:	4791                	li	a5,4
    return -1;
    80003ada:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003adc:	00f68663          	beq	a3,a5,80003ae8 <sys_send+0x6a>

  return send(fd, (uint64 *)buf, len, flags);
}
    80003ae0:	70a2                	ld	ra,40(sp)
    80003ae2:	7402                	ld	s0,32(sp)
    80003ae4:	6145                	addi	sp,sp,48
    80003ae6:	8082                	ret
  return send(fd, (uint64 *)buf, len, flags);
    80003ae8:	fd842683          	lw	a3,-40(s0)
    80003aec:	fdc42603          	lw	a2,-36(s0)
    80003af0:	fe043583          	ld	a1,-32(s0)
    80003af4:	853a                	mv	a0,a4
    80003af6:	00005097          	auipc	ra,0x5
    80003afa:	b88080e7          	jalr	-1144(ra) # 8000867e <send>
    80003afe:	b7cd                	j	80003ae0 <sys_send+0x62>
    return -1;
    80003b00:	557d                	li	a0,-1
    80003b02:	bff9                	j	80003ae0 <sys_send+0x62>

0000000080003b04 <sys_recv>:

uint64 sys_recv(void *arg) {
    80003b04:	7179                	addi	sp,sp,-48
    80003b06:	f406                	sd	ra,40(sp)
    80003b08:	f022                	sd	s0,32(sp)
    80003b0a:	1800                	addi	s0,sp,48
  int fd;
  uint64 buf;
  int len;
  int flags;

  argint(0, &fd);
    80003b0c:	fec40593          	addi	a1,s0,-20
    80003b10:	4501                	li	a0,0
    80003b12:	00000097          	auipc	ra,0x0
    80003b16:	95e080e7          	jalr	-1698(ra) # 80003470 <argint>
  argaddr(1, &buf);
    80003b1a:	fe040593          	addi	a1,s0,-32
    80003b1e:	4505                	li	a0,1
    80003b20:	00000097          	auipc	ra,0x0
    80003b24:	970080e7          	jalr	-1680(ra) # 80003490 <argaddr>
  argint(2, &len);
    80003b28:	fdc40593          	addi	a1,s0,-36
    80003b2c:	4509                	li	a0,2
    80003b2e:	00000097          	auipc	ra,0x0
    80003b32:	942080e7          	jalr	-1726(ra) # 80003470 <argint>
  argint(3, &flags);
    80003b36:	fd840593          	addi	a1,s0,-40
    80003b3a:	450d                	li	a0,3
    80003b3c:	00000097          	auipc	ra,0x0
    80003b40:	934080e7          	jalr	-1740(ra) # 80003470 <argint>

  struct file *f = myproc()->ofile[fd];
    80003b44:	ffffe097          	auipc	ra,0xffffe
    80003b48:	316080e7          	jalr	790(ra) # 80001e5a <myproc>
    80003b4c:	fec42703          	lw	a4,-20(s0)
    80003b50:	01a70793          	addi	a5,a4,26
    80003b54:	078e                	slli	a5,a5,0x3
    80003b56:	97aa                	add	a5,a5,a0
    80003b58:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003b5a:	c795                	beqz	a5,80003b86 <sys_recv+0x82>
    80003b5c:	4394                	lw	a3,0(a5)
    80003b5e:	4791                	li	a5,4
    return -1;
    80003b60:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003b62:	00f68663          	beq	a3,a5,80003b6e <sys_recv+0x6a>

  return recv(fd, (uint64 *)buf, len, flags);
}
    80003b66:	70a2                	ld	ra,40(sp)
    80003b68:	7402                	ld	s0,32(sp)
    80003b6a:	6145                	addi	sp,sp,48
    80003b6c:	8082                	ret
  return recv(fd, (uint64 *)buf, len, flags);
    80003b6e:	fd842683          	lw	a3,-40(s0)
    80003b72:	fdc42603          	lw	a2,-36(s0)
    80003b76:	fe043583          	ld	a1,-32(s0)
    80003b7a:	853a                	mv	a0,a4
    80003b7c:	00005097          	auipc	ra,0x5
    80003b80:	b14080e7          	jalr	-1260(ra) # 80008690 <recv>
    80003b84:	b7cd                	j	80003b66 <sys_recv+0x62>
    return -1;
    80003b86:	557d                	li	a0,-1
    80003b88:	bff9                	j	80003b66 <sys_recv+0x62>

0000000080003b8a <sys_sendto>:

uint64 sys_sendto(void) {
    80003b8a:	7139                	addi	sp,sp,-64
    80003b8c:	fc06                	sd	ra,56(sp)
    80003b8e:	f822                	sd	s0,48(sp)
    80003b90:	0080                	addi	s0,sp,64
  int len;
  int flags;
  uint64 dest_addr;
  int addrlen;

  argint(0, &fd);
    80003b92:	fec40593          	addi	a1,s0,-20
    80003b96:	4501                	li	a0,0
    80003b98:	00000097          	auipc	ra,0x0
    80003b9c:	8d8080e7          	jalr	-1832(ra) # 80003470 <argint>
  argaddr(1, &buf);
    80003ba0:	fe040593          	addi	a1,s0,-32
    80003ba4:	4505                	li	a0,1
    80003ba6:	00000097          	auipc	ra,0x0
    80003baa:	8ea080e7          	jalr	-1814(ra) # 80003490 <argaddr>
  argint(2, &len);
    80003bae:	fdc40593          	addi	a1,s0,-36
    80003bb2:	4509                	li	a0,2
    80003bb4:	00000097          	auipc	ra,0x0
    80003bb8:	8bc080e7          	jalr	-1860(ra) # 80003470 <argint>
  argint(3, &flags);
    80003bbc:	fd840593          	addi	a1,s0,-40
    80003bc0:	450d                	li	a0,3
    80003bc2:	00000097          	auipc	ra,0x0
    80003bc6:	8ae080e7          	jalr	-1874(ra) # 80003470 <argint>
  argaddr(4, &dest_addr);
    80003bca:	fd040593          	addi	a1,s0,-48
    80003bce:	4511                	li	a0,4
    80003bd0:	00000097          	auipc	ra,0x0
    80003bd4:	8c0080e7          	jalr	-1856(ra) # 80003490 <argaddr>
  argint(5, &addrlen);
    80003bd8:	fcc40593          	addi	a1,s0,-52
    80003bdc:	4515                	li	a0,5
    80003bde:	00000097          	auipc	ra,0x0
    80003be2:	892080e7          	jalr	-1902(ra) # 80003470 <argint>

  struct file *f = myproc()->ofile[fd];
    80003be6:	ffffe097          	auipc	ra,0xffffe
    80003bea:	274080e7          	jalr	628(ra) # 80001e5a <myproc>
    80003bee:	fec42803          	lw	a6,-20(s0)
    80003bf2:	01a80793          	addi	a5,a6,26
    80003bf6:	078e                	slli	a5,a5,0x3
    80003bf8:	97aa                	add	a5,a5,a0
    80003bfa:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003bfc:	cb95                	beqz	a5,80003c30 <sys_sendto+0xa6>
    80003bfe:	4398                	lw	a4,0(a5)
    80003c00:	4791                	li	a5,4
    return -1;
    80003c02:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003c04:	00f70663          	beq	a4,a5,80003c10 <sys_sendto+0x86>

  return sendto(fd, (uint64 *)buf, len, flags,
                     (struct sockaddr *)dest_addr, addrlen);
}
    80003c08:	70e2                	ld	ra,56(sp)
    80003c0a:	7442                	ld	s0,48(sp)
    80003c0c:	6121                	addi	sp,sp,64
    80003c0e:	8082                	ret
  return sendto(fd, (uint64 *)buf, len, flags,
    80003c10:	fcc42783          	lw	a5,-52(s0)
    80003c14:	fd043703          	ld	a4,-48(s0)
    80003c18:	fd842683          	lw	a3,-40(s0)
    80003c1c:	fdc42603          	lw	a2,-36(s0)
    80003c20:	fe043583          	ld	a1,-32(s0)
    80003c24:	8542                	mv	a0,a6
    80003c26:	00005097          	auipc	ra,0x5
    80003c2a:	a7c080e7          	jalr	-1412(ra) # 800086a2 <sendto>
    80003c2e:	bfe9                	j	80003c08 <sys_sendto+0x7e>
    return -1;
    80003c30:	557d                	li	a0,-1
    80003c32:	bfd9                	j	80003c08 <sys_sendto+0x7e>

0000000080003c34 <sys_recvfrom>:

uint64 sys_recvfrom(void *arg) {
    80003c34:	7139                	addi	sp,sp,-64
    80003c36:	fc06                	sd	ra,56(sp)
    80003c38:	f822                	sd	s0,48(sp)
    80003c3a:	0080                	addi	s0,sp,64
  int len;
  int flags;
  uint64 src_addr;
  uint64 addrlen;

  argint(0, &fd);
    80003c3c:	fec40593          	addi	a1,s0,-20
    80003c40:	4501                	li	a0,0
    80003c42:	00000097          	auipc	ra,0x0
    80003c46:	82e080e7          	jalr	-2002(ra) # 80003470 <argint>
  argaddr(1, &buf);
    80003c4a:	fe040593          	addi	a1,s0,-32
    80003c4e:	4505                	li	a0,1
    80003c50:	00000097          	auipc	ra,0x0
    80003c54:	840080e7          	jalr	-1984(ra) # 80003490 <argaddr>
  argint(2, &len);
    80003c58:	fdc40593          	addi	a1,s0,-36
    80003c5c:	4509                	li	a0,2
    80003c5e:	00000097          	auipc	ra,0x0
    80003c62:	812080e7          	jalr	-2030(ra) # 80003470 <argint>
  argint(3, &flags);
    80003c66:	fd840593          	addi	a1,s0,-40
    80003c6a:	450d                	li	a0,3
    80003c6c:	00000097          	auipc	ra,0x0
    80003c70:	804080e7          	jalr	-2044(ra) # 80003470 <argint>
  argaddr(4, &src_addr);
    80003c74:	fd040593          	addi	a1,s0,-48
    80003c78:	4511                	li	a0,4
    80003c7a:	00000097          	auipc	ra,0x0
    80003c7e:	816080e7          	jalr	-2026(ra) # 80003490 <argaddr>
  argaddr(5, &addrlen);
    80003c82:	fc840593          	addi	a1,s0,-56
    80003c86:	4515                	li	a0,5
    80003c88:	00000097          	auipc	ra,0x0
    80003c8c:	808080e7          	jalr	-2040(ra) # 80003490 <argaddr>

  struct file *f = myproc()->ofile[fd];
    80003c90:	ffffe097          	auipc	ra,0xffffe
    80003c94:	1ca080e7          	jalr	458(ra) # 80001e5a <myproc>
    80003c98:	fec42803          	lw	a6,-20(s0)
    80003c9c:	01a80793          	addi	a5,a6,26
    80003ca0:	078e                	slli	a5,a5,0x3
    80003ca2:	97aa                	add	a5,a5,a0
    80003ca4:	639c                	ld	a5,0(a5)
  if (f == 0 || f->type != FD_SOCKET)
    80003ca6:	cb95                	beqz	a5,80003cda <sys_recvfrom+0xa6>
    80003ca8:	4398                	lw	a4,0(a5)
    80003caa:	4791                	li	a5,4
    return -1;
    80003cac:	557d                	li	a0,-1
  if (f == 0 || f->type != FD_SOCKET)
    80003cae:	00f70663          	beq	a4,a5,80003cba <sys_recvfrom+0x86>

  return recvfrom(fd, (uint64 *)buf, len, flags,
                       (struct sockaddr *)src_addr,
                       (socklen_t *)addrlen);
}
    80003cb2:	70e2                	ld	ra,56(sp)
    80003cb4:	7442                	ld	s0,48(sp)
    80003cb6:	6121                	addi	sp,sp,64
    80003cb8:	8082                	ret
  return recvfrom(fd, (uint64 *)buf, len, flags,
    80003cba:	fc843783          	ld	a5,-56(s0)
    80003cbe:	fd043703          	ld	a4,-48(s0)
    80003cc2:	fd842683          	lw	a3,-40(s0)
    80003cc6:	fdc42603          	lw	a2,-36(s0)
    80003cca:	fe043583          	ld	a1,-32(s0)
    80003cce:	8542                	mv	a0,a6
    80003cd0:	00005097          	auipc	ra,0x5
    80003cd4:	a20080e7          	jalr	-1504(ra) # 800086f0 <recvfrom>
    80003cd8:	bfe9                	j	80003cb2 <sys_recvfrom+0x7e>
    return -1;
    80003cda:	557d                	li	a0,-1
    80003cdc:	bfd9                	j	80003cb2 <sys_recvfrom+0x7e>

0000000080003cde <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003cde:	7179                	addi	sp,sp,-48
    80003ce0:	f406                	sd	ra,40(sp)
    80003ce2:	f022                	sd	s0,32(sp)
    80003ce4:	ec26                	sd	s1,24(sp)
    80003ce6:	e84a                	sd	s2,16(sp)
    80003ce8:	e44e                	sd	s3,8(sp)
    80003cea:	e052                	sd	s4,0(sp)
    80003cec:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003cee:	00007597          	auipc	a1,0x7
    80003cf2:	79a58593          	addi	a1,a1,1946 # 8000b488 <etext+0x488>
    80003cf6:	00062517          	auipc	a0,0x62
    80003cfa:	3a250513          	addi	a0,a0,930 # 80066098 <bcache>
    80003cfe:	ffffd097          	auipc	ra,0xffffd
    80003d02:	f84080e7          	jalr	-124(ra) # 80000c82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003d06:	0006a797          	auipc	a5,0x6a
    80003d0a:	39278793          	addi	a5,a5,914 # 8006e098 <bcache+0x8000>
    80003d0e:	0006a717          	auipc	a4,0x6a
    80003d12:	5f270713          	addi	a4,a4,1522 # 8006e300 <bcache+0x8268>
    80003d16:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003d1a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003d1e:	00062497          	auipc	s1,0x62
    80003d22:	39248493          	addi	s1,s1,914 # 800660b0 <bcache+0x18>
    b->next = bcache.head.next;
    80003d26:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003d28:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003d2a:	00007a17          	auipc	s4,0x7
    80003d2e:	766a0a13          	addi	s4,s4,1894 # 8000b490 <etext+0x490>
    b->next = bcache.head.next;
    80003d32:	2b893783          	ld	a5,696(s2)
    80003d36:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003d38:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003d3c:	85d2                	mv	a1,s4
    80003d3e:	01048513          	addi	a0,s1,16
    80003d42:	00001097          	auipc	ra,0x1
    80003d46:	4e4080e7          	jalr	1252(ra) # 80005226 <initsleeplock>
    bcache.head.next->prev = b;
    80003d4a:	2b893783          	ld	a5,696(s2)
    80003d4e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003d50:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003d54:	45848493          	addi	s1,s1,1112
    80003d58:	fd349de3          	bne	s1,s3,80003d32 <binit+0x54>
  }
}
    80003d5c:	70a2                	ld	ra,40(sp)
    80003d5e:	7402                	ld	s0,32(sp)
    80003d60:	64e2                	ld	s1,24(sp)
    80003d62:	6942                	ld	s2,16(sp)
    80003d64:	69a2                	ld	s3,8(sp)
    80003d66:	6a02                	ld	s4,0(sp)
    80003d68:	6145                	addi	sp,sp,48
    80003d6a:	8082                	ret

0000000080003d6c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003d6c:	7179                	addi	sp,sp,-48
    80003d6e:	f406                	sd	ra,40(sp)
    80003d70:	f022                	sd	s0,32(sp)
    80003d72:	ec26                	sd	s1,24(sp)
    80003d74:	e84a                	sd	s2,16(sp)
    80003d76:	e44e                	sd	s3,8(sp)
    80003d78:	1800                	addi	s0,sp,48
    80003d7a:	892a                	mv	s2,a0
    80003d7c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003d7e:	00062517          	auipc	a0,0x62
    80003d82:	31a50513          	addi	a0,a0,794 # 80066098 <bcache>
    80003d86:	ffffd097          	auipc	ra,0xffffd
    80003d8a:	f90080e7          	jalr	-112(ra) # 80000d16 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003d8e:	0006a497          	auipc	s1,0x6a
    80003d92:	5c24b483          	ld	s1,1474(s1) # 8006e350 <bcache+0x82b8>
    80003d96:	0006a797          	auipc	a5,0x6a
    80003d9a:	56a78793          	addi	a5,a5,1386 # 8006e300 <bcache+0x8268>
    80003d9e:	02f48f63          	beq	s1,a5,80003ddc <bread+0x70>
    80003da2:	873e                	mv	a4,a5
    80003da4:	a021                	j	80003dac <bread+0x40>
    80003da6:	68a4                	ld	s1,80(s1)
    80003da8:	02e48a63          	beq	s1,a4,80003ddc <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003dac:	449c                	lw	a5,8(s1)
    80003dae:	ff279ce3          	bne	a5,s2,80003da6 <bread+0x3a>
    80003db2:	44dc                	lw	a5,12(s1)
    80003db4:	ff3799e3          	bne	a5,s3,80003da6 <bread+0x3a>
      b->refcnt++;
    80003db8:	40bc                	lw	a5,64(s1)
    80003dba:	2785                	addiw	a5,a5,1
    80003dbc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003dbe:	00062517          	auipc	a0,0x62
    80003dc2:	2da50513          	addi	a0,a0,730 # 80066098 <bcache>
    80003dc6:	ffffd097          	auipc	ra,0xffffd
    80003dca:	000080e7          	jalr	ra # 80000dc6 <release>
      acquiresleep(&b->lock);
    80003dce:	01048513          	addi	a0,s1,16
    80003dd2:	00001097          	auipc	ra,0x1
    80003dd6:	48e080e7          	jalr	1166(ra) # 80005260 <acquiresleep>
      return b;
    80003dda:	a8b9                	j	80003e38 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003ddc:	0006a497          	auipc	s1,0x6a
    80003de0:	56c4b483          	ld	s1,1388(s1) # 8006e348 <bcache+0x82b0>
    80003de4:	0006a797          	auipc	a5,0x6a
    80003de8:	51c78793          	addi	a5,a5,1308 # 8006e300 <bcache+0x8268>
    80003dec:	00f48863          	beq	s1,a5,80003dfc <bread+0x90>
    80003df0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003df2:	40bc                	lw	a5,64(s1)
    80003df4:	cf81                	beqz	a5,80003e0c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003df6:	64a4                	ld	s1,72(s1)
    80003df8:	fee49de3          	bne	s1,a4,80003df2 <bread+0x86>
  panic("bget: no buffers");
    80003dfc:	00007517          	auipc	a0,0x7
    80003e00:	69c50513          	addi	a0,a0,1692 # 8000b498 <etext+0x498>
    80003e04:	ffffc097          	auipc	ra,0xffffc
    80003e08:	75c080e7          	jalr	1884(ra) # 80000560 <panic>
      b->dev = dev;
    80003e0c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003e10:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003e14:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003e18:	4785                	li	a5,1
    80003e1a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003e1c:	00062517          	auipc	a0,0x62
    80003e20:	27c50513          	addi	a0,a0,636 # 80066098 <bcache>
    80003e24:	ffffd097          	auipc	ra,0xffffd
    80003e28:	fa2080e7          	jalr	-94(ra) # 80000dc6 <release>
      acquiresleep(&b->lock);
    80003e2c:	01048513          	addi	a0,s1,16
    80003e30:	00001097          	auipc	ra,0x1
    80003e34:	430080e7          	jalr	1072(ra) # 80005260 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003e38:	409c                	lw	a5,0(s1)
    80003e3a:	cb89                	beqz	a5,80003e4c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003e3c:	8526                	mv	a0,s1
    80003e3e:	70a2                	ld	ra,40(sp)
    80003e40:	7402                	ld	s0,32(sp)
    80003e42:	64e2                	ld	s1,24(sp)
    80003e44:	6942                	ld	s2,16(sp)
    80003e46:	69a2                	ld	s3,8(sp)
    80003e48:	6145                	addi	sp,sp,48
    80003e4a:	8082                	ret
    virtio_disk_rw(b, 0);
    80003e4c:	4581                	li	a1,0
    80003e4e:	8526                	mv	a0,s1
    80003e50:	00003097          	auipc	ra,0x3
    80003e54:	15a080e7          	jalr	346(ra) # 80006faa <virtio_disk_rw>
    b->valid = 1;
    80003e58:	4785                	li	a5,1
    80003e5a:	c09c                	sw	a5,0(s1)
  return b;
    80003e5c:	b7c5                	j	80003e3c <bread+0xd0>

0000000080003e5e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003e5e:	1101                	addi	sp,sp,-32
    80003e60:	ec06                	sd	ra,24(sp)
    80003e62:	e822                	sd	s0,16(sp)
    80003e64:	e426                	sd	s1,8(sp)
    80003e66:	1000                	addi	s0,sp,32
    80003e68:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003e6a:	0541                	addi	a0,a0,16
    80003e6c:	00001097          	auipc	ra,0x1
    80003e70:	48e080e7          	jalr	1166(ra) # 800052fa <holdingsleep>
    80003e74:	cd01                	beqz	a0,80003e8c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003e76:	4585                	li	a1,1
    80003e78:	8526                	mv	a0,s1
    80003e7a:	00003097          	auipc	ra,0x3
    80003e7e:	130080e7          	jalr	304(ra) # 80006faa <virtio_disk_rw>
}
    80003e82:	60e2                	ld	ra,24(sp)
    80003e84:	6442                	ld	s0,16(sp)
    80003e86:	64a2                	ld	s1,8(sp)
    80003e88:	6105                	addi	sp,sp,32
    80003e8a:	8082                	ret
    panic("bwrite");
    80003e8c:	00007517          	auipc	a0,0x7
    80003e90:	62450513          	addi	a0,a0,1572 # 8000b4b0 <etext+0x4b0>
    80003e94:	ffffc097          	auipc	ra,0xffffc
    80003e98:	6cc080e7          	jalr	1740(ra) # 80000560 <panic>

0000000080003e9c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003e9c:	1101                	addi	sp,sp,-32
    80003e9e:	ec06                	sd	ra,24(sp)
    80003ea0:	e822                	sd	s0,16(sp)
    80003ea2:	e426                	sd	s1,8(sp)
    80003ea4:	e04a                	sd	s2,0(sp)
    80003ea6:	1000                	addi	s0,sp,32
    80003ea8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003eaa:	01050913          	addi	s2,a0,16
    80003eae:	854a                	mv	a0,s2
    80003eb0:	00001097          	auipc	ra,0x1
    80003eb4:	44a080e7          	jalr	1098(ra) # 800052fa <holdingsleep>
    80003eb8:	c535                	beqz	a0,80003f24 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003eba:	854a                	mv	a0,s2
    80003ebc:	00001097          	auipc	ra,0x1
    80003ec0:	3fa080e7          	jalr	1018(ra) # 800052b6 <releasesleep>

  acquire(&bcache.lock);
    80003ec4:	00062517          	auipc	a0,0x62
    80003ec8:	1d450513          	addi	a0,a0,468 # 80066098 <bcache>
    80003ecc:	ffffd097          	auipc	ra,0xffffd
    80003ed0:	e4a080e7          	jalr	-438(ra) # 80000d16 <acquire>
  b->refcnt--;
    80003ed4:	40bc                	lw	a5,64(s1)
    80003ed6:	37fd                	addiw	a5,a5,-1
    80003ed8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003eda:	e79d                	bnez	a5,80003f08 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003edc:	68b8                	ld	a4,80(s1)
    80003ede:	64bc                	ld	a5,72(s1)
    80003ee0:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003ee2:	68b8                	ld	a4,80(s1)
    80003ee4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003ee6:	0006a797          	auipc	a5,0x6a
    80003eea:	1b278793          	addi	a5,a5,434 # 8006e098 <bcache+0x8000>
    80003eee:	2b87b703          	ld	a4,696(a5)
    80003ef2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003ef4:	0006a717          	auipc	a4,0x6a
    80003ef8:	40c70713          	addi	a4,a4,1036 # 8006e300 <bcache+0x8268>
    80003efc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003efe:	2b87b703          	ld	a4,696(a5)
    80003f02:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003f04:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003f08:	00062517          	auipc	a0,0x62
    80003f0c:	19050513          	addi	a0,a0,400 # 80066098 <bcache>
    80003f10:	ffffd097          	auipc	ra,0xffffd
    80003f14:	eb6080e7          	jalr	-330(ra) # 80000dc6 <release>
}
    80003f18:	60e2                	ld	ra,24(sp)
    80003f1a:	6442                	ld	s0,16(sp)
    80003f1c:	64a2                	ld	s1,8(sp)
    80003f1e:	6902                	ld	s2,0(sp)
    80003f20:	6105                	addi	sp,sp,32
    80003f22:	8082                	ret
    panic("brelse");
    80003f24:	00007517          	auipc	a0,0x7
    80003f28:	59450513          	addi	a0,a0,1428 # 8000b4b8 <etext+0x4b8>
    80003f2c:	ffffc097          	auipc	ra,0xffffc
    80003f30:	634080e7          	jalr	1588(ra) # 80000560 <panic>

0000000080003f34 <bpin>:

void
bpin(struct buf *b) {
    80003f34:	1101                	addi	sp,sp,-32
    80003f36:	ec06                	sd	ra,24(sp)
    80003f38:	e822                	sd	s0,16(sp)
    80003f3a:	e426                	sd	s1,8(sp)
    80003f3c:	1000                	addi	s0,sp,32
    80003f3e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003f40:	00062517          	auipc	a0,0x62
    80003f44:	15850513          	addi	a0,a0,344 # 80066098 <bcache>
    80003f48:	ffffd097          	auipc	ra,0xffffd
    80003f4c:	dce080e7          	jalr	-562(ra) # 80000d16 <acquire>
  b->refcnt++;
    80003f50:	40bc                	lw	a5,64(s1)
    80003f52:	2785                	addiw	a5,a5,1
    80003f54:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003f56:	00062517          	auipc	a0,0x62
    80003f5a:	14250513          	addi	a0,a0,322 # 80066098 <bcache>
    80003f5e:	ffffd097          	auipc	ra,0xffffd
    80003f62:	e68080e7          	jalr	-408(ra) # 80000dc6 <release>
}
    80003f66:	60e2                	ld	ra,24(sp)
    80003f68:	6442                	ld	s0,16(sp)
    80003f6a:	64a2                	ld	s1,8(sp)
    80003f6c:	6105                	addi	sp,sp,32
    80003f6e:	8082                	ret

0000000080003f70 <bunpin>:

void
bunpin(struct buf *b) {
    80003f70:	1101                	addi	sp,sp,-32
    80003f72:	ec06                	sd	ra,24(sp)
    80003f74:	e822                	sd	s0,16(sp)
    80003f76:	e426                	sd	s1,8(sp)
    80003f78:	1000                	addi	s0,sp,32
    80003f7a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003f7c:	00062517          	auipc	a0,0x62
    80003f80:	11c50513          	addi	a0,a0,284 # 80066098 <bcache>
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	d92080e7          	jalr	-622(ra) # 80000d16 <acquire>
  b->refcnt--;
    80003f8c:	40bc                	lw	a5,64(s1)
    80003f8e:	37fd                	addiw	a5,a5,-1
    80003f90:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003f92:	00062517          	auipc	a0,0x62
    80003f96:	10650513          	addi	a0,a0,262 # 80066098 <bcache>
    80003f9a:	ffffd097          	auipc	ra,0xffffd
    80003f9e:	e2c080e7          	jalr	-468(ra) # 80000dc6 <release>
}
    80003fa2:	60e2                	ld	ra,24(sp)
    80003fa4:	6442                	ld	s0,16(sp)
    80003fa6:	64a2                	ld	s1,8(sp)
    80003fa8:	6105                	addi	sp,sp,32
    80003faa:	8082                	ret

0000000080003fac <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003fac:	1101                	addi	sp,sp,-32
    80003fae:	ec06                	sd	ra,24(sp)
    80003fb0:	e822                	sd	s0,16(sp)
    80003fb2:	e426                	sd	s1,8(sp)
    80003fb4:	e04a                	sd	s2,0(sp)
    80003fb6:	1000                	addi	s0,sp,32
    80003fb8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003fba:	00d5d79b          	srliw	a5,a1,0xd
    80003fbe:	0006a597          	auipc	a1,0x6a
    80003fc2:	7b65a583          	lw	a1,1974(a1) # 8006e774 <sb+0x1c>
    80003fc6:	9dbd                	addw	a1,a1,a5
    80003fc8:	00000097          	auipc	ra,0x0
    80003fcc:	da4080e7          	jalr	-604(ra) # 80003d6c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003fd0:	0074f713          	andi	a4,s1,7
    80003fd4:	4785                	li	a5,1
    80003fd6:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003fda:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003fdc:	90d9                	srli	s1,s1,0x36
    80003fde:	00950733          	add	a4,a0,s1
    80003fe2:	05874703          	lbu	a4,88(a4)
    80003fe6:	00e7f6b3          	and	a3,a5,a4
    80003fea:	c69d                	beqz	a3,80004018 <bfree+0x6c>
    80003fec:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003fee:	94aa                	add	s1,s1,a0
    80003ff0:	fff7c793          	not	a5,a5
    80003ff4:	8f7d                	and	a4,a4,a5
    80003ff6:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003ffa:	00001097          	auipc	ra,0x1
    80003ffe:	148080e7          	jalr	328(ra) # 80005142 <log_write>
  brelse(bp);
    80004002:	854a                	mv	a0,s2
    80004004:	00000097          	auipc	ra,0x0
    80004008:	e98080e7          	jalr	-360(ra) # 80003e9c <brelse>
}
    8000400c:	60e2                	ld	ra,24(sp)
    8000400e:	6442                	ld	s0,16(sp)
    80004010:	64a2                	ld	s1,8(sp)
    80004012:	6902                	ld	s2,0(sp)
    80004014:	6105                	addi	sp,sp,32
    80004016:	8082                	ret
    panic("freeing free block");
    80004018:	00007517          	auipc	a0,0x7
    8000401c:	4a850513          	addi	a0,a0,1192 # 8000b4c0 <etext+0x4c0>
    80004020:	ffffc097          	auipc	ra,0xffffc
    80004024:	540080e7          	jalr	1344(ra) # 80000560 <panic>

0000000080004028 <balloc>:
{
    80004028:	715d                	addi	sp,sp,-80
    8000402a:	e486                	sd	ra,72(sp)
    8000402c:	e0a2                	sd	s0,64(sp)
    8000402e:	fc26                	sd	s1,56(sp)
    80004030:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80004032:	0006a797          	auipc	a5,0x6a
    80004036:	72a7a783          	lw	a5,1834(a5) # 8006e75c <sb+0x4>
    8000403a:	10078863          	beqz	a5,8000414a <balloc+0x122>
    8000403e:	f84a                	sd	s2,48(sp)
    80004040:	f44e                	sd	s3,40(sp)
    80004042:	f052                	sd	s4,32(sp)
    80004044:	ec56                	sd	s5,24(sp)
    80004046:	e85a                	sd	s6,16(sp)
    80004048:	e45e                	sd	s7,8(sp)
    8000404a:	e062                	sd	s8,0(sp)
    8000404c:	8baa                	mv	s7,a0
    8000404e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80004050:	0006ab17          	auipc	s6,0x6a
    80004054:	708b0b13          	addi	s6,s6,1800 # 8006e758 <sb>
      m = 1 << (bi % 8);
    80004058:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000405a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000405c:	6c09                	lui	s8,0x2
    8000405e:	a049                	j	800040e0 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004060:	97ca                	add	a5,a5,s2
    80004062:	8e55                	or	a2,a2,a3
    80004064:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80004068:	854a                	mv	a0,s2
    8000406a:	00001097          	auipc	ra,0x1
    8000406e:	0d8080e7          	jalr	216(ra) # 80005142 <log_write>
        brelse(bp);
    80004072:	854a                	mv	a0,s2
    80004074:	00000097          	auipc	ra,0x0
    80004078:	e28080e7          	jalr	-472(ra) # 80003e9c <brelse>
  bp = bread(dev, bno);
    8000407c:	85a6                	mv	a1,s1
    8000407e:	855e                	mv	a0,s7
    80004080:	00000097          	auipc	ra,0x0
    80004084:	cec080e7          	jalr	-788(ra) # 80003d6c <bread>
    80004088:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000408a:	40000613          	li	a2,1024
    8000408e:	4581                	li	a1,0
    80004090:	05850513          	addi	a0,a0,88
    80004094:	ffffd097          	auipc	ra,0xffffd
    80004098:	d7a080e7          	jalr	-646(ra) # 80000e0e <memset>
  log_write(bp);
    8000409c:	854a                	mv	a0,s2
    8000409e:	00001097          	auipc	ra,0x1
    800040a2:	0a4080e7          	jalr	164(ra) # 80005142 <log_write>
  brelse(bp);
    800040a6:	854a                	mv	a0,s2
    800040a8:	00000097          	auipc	ra,0x0
    800040ac:	df4080e7          	jalr	-524(ra) # 80003e9c <brelse>
}
    800040b0:	7942                	ld	s2,48(sp)
    800040b2:	79a2                	ld	s3,40(sp)
    800040b4:	7a02                	ld	s4,32(sp)
    800040b6:	6ae2                	ld	s5,24(sp)
    800040b8:	6b42                	ld	s6,16(sp)
    800040ba:	6ba2                	ld	s7,8(sp)
    800040bc:	6c02                	ld	s8,0(sp)
}
    800040be:	8526                	mv	a0,s1
    800040c0:	60a6                	ld	ra,72(sp)
    800040c2:	6406                	ld	s0,64(sp)
    800040c4:	74e2                	ld	s1,56(sp)
    800040c6:	6161                	addi	sp,sp,80
    800040c8:	8082                	ret
    brelse(bp);
    800040ca:	854a                	mv	a0,s2
    800040cc:	00000097          	auipc	ra,0x0
    800040d0:	dd0080e7          	jalr	-560(ra) # 80003e9c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800040d4:	015c0abb          	addw	s5,s8,s5
    800040d8:	004b2783          	lw	a5,4(s6)
    800040dc:	06faf063          	bgeu	s5,a5,8000413c <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    800040e0:	41fad79b          	sraiw	a5,s5,0x1f
    800040e4:	0137d79b          	srliw	a5,a5,0x13
    800040e8:	015787bb          	addw	a5,a5,s5
    800040ec:	40d7d79b          	sraiw	a5,a5,0xd
    800040f0:	01cb2583          	lw	a1,28(s6)
    800040f4:	9dbd                	addw	a1,a1,a5
    800040f6:	855e                	mv	a0,s7
    800040f8:	00000097          	auipc	ra,0x0
    800040fc:	c74080e7          	jalr	-908(ra) # 80003d6c <bread>
    80004100:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004102:	004b2503          	lw	a0,4(s6)
    80004106:	84d6                	mv	s1,s5
    80004108:	4701                	li	a4,0
    8000410a:	fca4f0e3          	bgeu	s1,a0,800040ca <balloc+0xa2>
      m = 1 << (bi % 8);
    8000410e:	00777693          	andi	a3,a4,7
    80004112:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004116:	41f7579b          	sraiw	a5,a4,0x1f
    8000411a:	01d7d79b          	srliw	a5,a5,0x1d
    8000411e:	9fb9                	addw	a5,a5,a4
    80004120:	4037d79b          	sraiw	a5,a5,0x3
    80004124:	00f90633          	add	a2,s2,a5
    80004128:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    8000412c:	00c6f5b3          	and	a1,a3,a2
    80004130:	d985                	beqz	a1,80004060 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004132:	2705                	addiw	a4,a4,1
    80004134:	2485                	addiw	s1,s1,1
    80004136:	fd471ae3          	bne	a4,s4,8000410a <balloc+0xe2>
    8000413a:	bf41                	j	800040ca <balloc+0xa2>
    8000413c:	7942                	ld	s2,48(sp)
    8000413e:	79a2                	ld	s3,40(sp)
    80004140:	7a02                	ld	s4,32(sp)
    80004142:	6ae2                	ld	s5,24(sp)
    80004144:	6b42                	ld	s6,16(sp)
    80004146:	6ba2                	ld	s7,8(sp)
    80004148:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000414a:	00007517          	auipc	a0,0x7
    8000414e:	38e50513          	addi	a0,a0,910 # 8000b4d8 <etext+0x4d8>
    80004152:	ffffc097          	auipc	ra,0xffffc
    80004156:	458080e7          	jalr	1112(ra) # 800005aa <printf>
  return 0;
    8000415a:	4481                	li	s1,0
    8000415c:	b78d                	j	800040be <balloc+0x96>

000000008000415e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000415e:	7179                	addi	sp,sp,-48
    80004160:	f406                	sd	ra,40(sp)
    80004162:	f022                	sd	s0,32(sp)
    80004164:	ec26                	sd	s1,24(sp)
    80004166:	e84a                	sd	s2,16(sp)
    80004168:	e44e                	sd	s3,8(sp)
    8000416a:	1800                	addi	s0,sp,48
    8000416c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000416e:	47ad                	li	a5,11
    80004170:	02b7e563          	bltu	a5,a1,8000419a <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80004174:	02059793          	slli	a5,a1,0x20
    80004178:	01e7d593          	srli	a1,a5,0x1e
    8000417c:	00b504b3          	add	s1,a0,a1
    80004180:	0504a903          	lw	s2,80(s1)
    80004184:	06091b63          	bnez	s2,800041fa <bmap+0x9c>
      addr = balloc(ip->dev);
    80004188:	4108                	lw	a0,0(a0)
    8000418a:	00000097          	auipc	ra,0x0
    8000418e:	e9e080e7          	jalr	-354(ra) # 80004028 <balloc>
    80004192:	892a                	mv	s2,a0
      if(addr == 0)
    80004194:	c13d                	beqz	a0,800041fa <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    80004196:	c8a8                	sw	a0,80(s1)
    80004198:	a08d                	j	800041fa <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000419a:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    8000419e:	0ff00793          	li	a5,255
    800041a2:	0897e363          	bltu	a5,s1,80004228 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800041a6:	08052903          	lw	s2,128(a0)
    800041aa:	00091d63          	bnez	s2,800041c4 <bmap+0x66>
      addr = balloc(ip->dev);
    800041ae:	4108                	lw	a0,0(a0)
    800041b0:	00000097          	auipc	ra,0x0
    800041b4:	e78080e7          	jalr	-392(ra) # 80004028 <balloc>
    800041b8:	892a                	mv	s2,a0
      if(addr == 0)
    800041ba:	c121                	beqz	a0,800041fa <bmap+0x9c>
    800041bc:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800041be:	08a9a023          	sw	a0,128(s3)
    800041c2:	a011                	j	800041c6 <bmap+0x68>
    800041c4:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800041c6:	85ca                	mv	a1,s2
    800041c8:	0009a503          	lw	a0,0(s3)
    800041cc:	00000097          	auipc	ra,0x0
    800041d0:	ba0080e7          	jalr	-1120(ra) # 80003d6c <bread>
    800041d4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800041d6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800041da:	02049713          	slli	a4,s1,0x20
    800041de:	01e75593          	srli	a1,a4,0x1e
    800041e2:	00b784b3          	add	s1,a5,a1
    800041e6:	0004a903          	lw	s2,0(s1)
    800041ea:	02090063          	beqz	s2,8000420a <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800041ee:	8552                	mv	a0,s4
    800041f0:	00000097          	auipc	ra,0x0
    800041f4:	cac080e7          	jalr	-852(ra) # 80003e9c <brelse>
    return addr;
    800041f8:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800041fa:	854a                	mv	a0,s2
    800041fc:	70a2                	ld	ra,40(sp)
    800041fe:	7402                	ld	s0,32(sp)
    80004200:	64e2                	ld	s1,24(sp)
    80004202:	6942                	ld	s2,16(sp)
    80004204:	69a2                	ld	s3,8(sp)
    80004206:	6145                	addi	sp,sp,48
    80004208:	8082                	ret
      addr = balloc(ip->dev);
    8000420a:	0009a503          	lw	a0,0(s3)
    8000420e:	00000097          	auipc	ra,0x0
    80004212:	e1a080e7          	jalr	-486(ra) # 80004028 <balloc>
    80004216:	892a                	mv	s2,a0
      if(addr){
    80004218:	d979                	beqz	a0,800041ee <bmap+0x90>
        a[bn] = addr;
    8000421a:	c088                	sw	a0,0(s1)
        log_write(bp);
    8000421c:	8552                	mv	a0,s4
    8000421e:	00001097          	auipc	ra,0x1
    80004222:	f24080e7          	jalr	-220(ra) # 80005142 <log_write>
    80004226:	b7e1                	j	800041ee <bmap+0x90>
    80004228:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000422a:	00007517          	auipc	a0,0x7
    8000422e:	2c650513          	addi	a0,a0,710 # 8000b4f0 <etext+0x4f0>
    80004232:	ffffc097          	auipc	ra,0xffffc
    80004236:	32e080e7          	jalr	814(ra) # 80000560 <panic>

000000008000423a <iget>:
{
    8000423a:	7179                	addi	sp,sp,-48
    8000423c:	f406                	sd	ra,40(sp)
    8000423e:	f022                	sd	s0,32(sp)
    80004240:	ec26                	sd	s1,24(sp)
    80004242:	e84a                	sd	s2,16(sp)
    80004244:	e44e                	sd	s3,8(sp)
    80004246:	e052                	sd	s4,0(sp)
    80004248:	1800                	addi	s0,sp,48
    8000424a:	89aa                	mv	s3,a0
    8000424c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000424e:	0006a517          	auipc	a0,0x6a
    80004252:	52a50513          	addi	a0,a0,1322 # 8006e778 <itable>
    80004256:	ffffd097          	auipc	ra,0xffffd
    8000425a:	ac0080e7          	jalr	-1344(ra) # 80000d16 <acquire>
  empty = 0;
    8000425e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004260:	0006a497          	auipc	s1,0x6a
    80004264:	53048493          	addi	s1,s1,1328 # 8006e790 <itable+0x18>
    80004268:	0006c697          	auipc	a3,0x6c
    8000426c:	fb868693          	addi	a3,a3,-72 # 80070220 <log>
    80004270:	a039                	j	8000427e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004272:	02090b63          	beqz	s2,800042a8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004276:	08848493          	addi	s1,s1,136
    8000427a:	02d48a63          	beq	s1,a3,800042ae <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000427e:	449c                	lw	a5,8(s1)
    80004280:	fef059e3          	blez	a5,80004272 <iget+0x38>
    80004284:	4098                	lw	a4,0(s1)
    80004286:	ff3716e3          	bne	a4,s3,80004272 <iget+0x38>
    8000428a:	40d8                	lw	a4,4(s1)
    8000428c:	ff4713e3          	bne	a4,s4,80004272 <iget+0x38>
      ip->ref++;
    80004290:	2785                	addiw	a5,a5,1
    80004292:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80004294:	0006a517          	auipc	a0,0x6a
    80004298:	4e450513          	addi	a0,a0,1252 # 8006e778 <itable>
    8000429c:	ffffd097          	auipc	ra,0xffffd
    800042a0:	b2a080e7          	jalr	-1238(ra) # 80000dc6 <release>
      return ip;
    800042a4:	8926                	mv	s2,s1
    800042a6:	a03d                	j	800042d4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800042a8:	f7f9                	bnez	a5,80004276 <iget+0x3c>
      empty = ip;
    800042aa:	8926                	mv	s2,s1
    800042ac:	b7e9                	j	80004276 <iget+0x3c>
  if(empty == 0)
    800042ae:	02090c63          	beqz	s2,800042e6 <iget+0xac>
  ip->dev = dev;
    800042b2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800042b6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800042ba:	4785                	li	a5,1
    800042bc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800042c0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800042c4:	0006a517          	auipc	a0,0x6a
    800042c8:	4b450513          	addi	a0,a0,1204 # 8006e778 <itable>
    800042cc:	ffffd097          	auipc	ra,0xffffd
    800042d0:	afa080e7          	jalr	-1286(ra) # 80000dc6 <release>
}
    800042d4:	854a                	mv	a0,s2
    800042d6:	70a2                	ld	ra,40(sp)
    800042d8:	7402                	ld	s0,32(sp)
    800042da:	64e2                	ld	s1,24(sp)
    800042dc:	6942                	ld	s2,16(sp)
    800042de:	69a2                	ld	s3,8(sp)
    800042e0:	6a02                	ld	s4,0(sp)
    800042e2:	6145                	addi	sp,sp,48
    800042e4:	8082                	ret
    panic("iget: no inodes");
    800042e6:	00007517          	auipc	a0,0x7
    800042ea:	22250513          	addi	a0,a0,546 # 8000b508 <etext+0x508>
    800042ee:	ffffc097          	auipc	ra,0xffffc
    800042f2:	272080e7          	jalr	626(ra) # 80000560 <panic>

00000000800042f6 <fsinit>:
fsinit(int dev) {
    800042f6:	7179                	addi	sp,sp,-48
    800042f8:	f406                	sd	ra,40(sp)
    800042fa:	f022                	sd	s0,32(sp)
    800042fc:	ec26                	sd	s1,24(sp)
    800042fe:	e84a                	sd	s2,16(sp)
    80004300:	e44e                	sd	s3,8(sp)
    80004302:	1800                	addi	s0,sp,48
    80004304:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80004306:	4585                	li	a1,1
    80004308:	00000097          	auipc	ra,0x0
    8000430c:	a64080e7          	jalr	-1436(ra) # 80003d6c <bread>
    80004310:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80004312:	0006a997          	auipc	s3,0x6a
    80004316:	44698993          	addi	s3,s3,1094 # 8006e758 <sb>
    8000431a:	02000613          	li	a2,32
    8000431e:	05850593          	addi	a1,a0,88
    80004322:	854e                	mv	a0,s3
    80004324:	ffffd097          	auipc	ra,0xffffd
    80004328:	b4e080e7          	jalr	-1202(ra) # 80000e72 <memmove>
  brelse(bp);
    8000432c:	8526                	mv	a0,s1
    8000432e:	00000097          	auipc	ra,0x0
    80004332:	b6e080e7          	jalr	-1170(ra) # 80003e9c <brelse>
  if(sb.magic != FSMAGIC)
    80004336:	0009a703          	lw	a4,0(s3)
    8000433a:	102037b7          	lui	a5,0x10203
    8000433e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004342:	02f71263          	bne	a4,a5,80004366 <fsinit+0x70>
  initlog(dev, &sb);
    80004346:	0006a597          	auipc	a1,0x6a
    8000434a:	41258593          	addi	a1,a1,1042 # 8006e758 <sb>
    8000434e:	854a                	mv	a0,s2
    80004350:	00001097          	auipc	ra,0x1
    80004354:	b7c080e7          	jalr	-1156(ra) # 80004ecc <initlog>
}
    80004358:	70a2                	ld	ra,40(sp)
    8000435a:	7402                	ld	s0,32(sp)
    8000435c:	64e2                	ld	s1,24(sp)
    8000435e:	6942                	ld	s2,16(sp)
    80004360:	69a2                	ld	s3,8(sp)
    80004362:	6145                	addi	sp,sp,48
    80004364:	8082                	ret
    panic("invalid file system");
    80004366:	00007517          	auipc	a0,0x7
    8000436a:	1b250513          	addi	a0,a0,434 # 8000b518 <etext+0x518>
    8000436e:	ffffc097          	auipc	ra,0xffffc
    80004372:	1f2080e7          	jalr	498(ra) # 80000560 <panic>

0000000080004376 <iinit>:
{
    80004376:	7179                	addi	sp,sp,-48
    80004378:	f406                	sd	ra,40(sp)
    8000437a:	f022                	sd	s0,32(sp)
    8000437c:	ec26                	sd	s1,24(sp)
    8000437e:	e84a                	sd	s2,16(sp)
    80004380:	e44e                	sd	s3,8(sp)
    80004382:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80004384:	00007597          	auipc	a1,0x7
    80004388:	1ac58593          	addi	a1,a1,428 # 8000b530 <etext+0x530>
    8000438c:	0006a517          	auipc	a0,0x6a
    80004390:	3ec50513          	addi	a0,a0,1004 # 8006e778 <itable>
    80004394:	ffffd097          	auipc	ra,0xffffd
    80004398:	8ee080e7          	jalr	-1810(ra) # 80000c82 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000439c:	0006a497          	auipc	s1,0x6a
    800043a0:	40448493          	addi	s1,s1,1028 # 8006e7a0 <itable+0x28>
    800043a4:	0006c997          	auipc	s3,0x6c
    800043a8:	e8c98993          	addi	s3,s3,-372 # 80070230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800043ac:	00007917          	auipc	s2,0x7
    800043b0:	18c90913          	addi	s2,s2,396 # 8000b538 <etext+0x538>
    800043b4:	85ca                	mv	a1,s2
    800043b6:	8526                	mv	a0,s1
    800043b8:	00001097          	auipc	ra,0x1
    800043bc:	e6e080e7          	jalr	-402(ra) # 80005226 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800043c0:	08848493          	addi	s1,s1,136
    800043c4:	ff3498e3          	bne	s1,s3,800043b4 <iinit+0x3e>
}
    800043c8:	70a2                	ld	ra,40(sp)
    800043ca:	7402                	ld	s0,32(sp)
    800043cc:	64e2                	ld	s1,24(sp)
    800043ce:	6942                	ld	s2,16(sp)
    800043d0:	69a2                	ld	s3,8(sp)
    800043d2:	6145                	addi	sp,sp,48
    800043d4:	8082                	ret

00000000800043d6 <ialloc>:
{
    800043d6:	7139                	addi	sp,sp,-64
    800043d8:	fc06                	sd	ra,56(sp)
    800043da:	f822                	sd	s0,48(sp)
    800043dc:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800043de:	0006a717          	auipc	a4,0x6a
    800043e2:	38672703          	lw	a4,902(a4) # 8006e764 <sb+0xc>
    800043e6:	4785                	li	a5,1
    800043e8:	06e7f463          	bgeu	a5,a4,80004450 <ialloc+0x7a>
    800043ec:	f426                	sd	s1,40(sp)
    800043ee:	f04a                	sd	s2,32(sp)
    800043f0:	ec4e                	sd	s3,24(sp)
    800043f2:	e852                	sd	s4,16(sp)
    800043f4:	e456                	sd	s5,8(sp)
    800043f6:	e05a                	sd	s6,0(sp)
    800043f8:	8aaa                	mv	s5,a0
    800043fa:	8b2e                	mv	s6,a1
    800043fc:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800043fe:	0006aa17          	auipc	s4,0x6a
    80004402:	35aa0a13          	addi	s4,s4,858 # 8006e758 <sb>
    80004406:	00495593          	srli	a1,s2,0x4
    8000440a:	018a2783          	lw	a5,24(s4)
    8000440e:	9dbd                	addw	a1,a1,a5
    80004410:	8556                	mv	a0,s5
    80004412:	00000097          	auipc	ra,0x0
    80004416:	95a080e7          	jalr	-1702(ra) # 80003d6c <bread>
    8000441a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000441c:	05850993          	addi	s3,a0,88
    80004420:	00f97793          	andi	a5,s2,15
    80004424:	079a                	slli	a5,a5,0x6
    80004426:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80004428:	00099783          	lh	a5,0(s3)
    8000442c:	cf9d                	beqz	a5,8000446a <ialloc+0x94>
    brelse(bp);
    8000442e:	00000097          	auipc	ra,0x0
    80004432:	a6e080e7          	jalr	-1426(ra) # 80003e9c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004436:	0905                	addi	s2,s2,1
    80004438:	00ca2703          	lw	a4,12(s4)
    8000443c:	0009079b          	sext.w	a5,s2
    80004440:	fce7e3e3          	bltu	a5,a4,80004406 <ialloc+0x30>
    80004444:	74a2                	ld	s1,40(sp)
    80004446:	7902                	ld	s2,32(sp)
    80004448:	69e2                	ld	s3,24(sp)
    8000444a:	6a42                	ld	s4,16(sp)
    8000444c:	6aa2                	ld	s5,8(sp)
    8000444e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80004450:	00007517          	auipc	a0,0x7
    80004454:	0f050513          	addi	a0,a0,240 # 8000b540 <etext+0x540>
    80004458:	ffffc097          	auipc	ra,0xffffc
    8000445c:	152080e7          	jalr	338(ra) # 800005aa <printf>
  return 0;
    80004460:	4501                	li	a0,0
}
    80004462:	70e2                	ld	ra,56(sp)
    80004464:	7442                	ld	s0,48(sp)
    80004466:	6121                	addi	sp,sp,64
    80004468:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000446a:	04000613          	li	a2,64
    8000446e:	4581                	li	a1,0
    80004470:	854e                	mv	a0,s3
    80004472:	ffffd097          	auipc	ra,0xffffd
    80004476:	99c080e7          	jalr	-1636(ra) # 80000e0e <memset>
      dip->type = type;
    8000447a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000447e:	8526                	mv	a0,s1
    80004480:	00001097          	auipc	ra,0x1
    80004484:	cc2080e7          	jalr	-830(ra) # 80005142 <log_write>
      brelse(bp);
    80004488:	8526                	mv	a0,s1
    8000448a:	00000097          	auipc	ra,0x0
    8000448e:	a12080e7          	jalr	-1518(ra) # 80003e9c <brelse>
      return iget(dev, inum);
    80004492:	0009059b          	sext.w	a1,s2
    80004496:	8556                	mv	a0,s5
    80004498:	00000097          	auipc	ra,0x0
    8000449c:	da2080e7          	jalr	-606(ra) # 8000423a <iget>
    800044a0:	74a2                	ld	s1,40(sp)
    800044a2:	7902                	ld	s2,32(sp)
    800044a4:	69e2                	ld	s3,24(sp)
    800044a6:	6a42                	ld	s4,16(sp)
    800044a8:	6aa2                	ld	s5,8(sp)
    800044aa:	6b02                	ld	s6,0(sp)
    800044ac:	bf5d                	j	80004462 <ialloc+0x8c>

00000000800044ae <iupdate>:
{
    800044ae:	1101                	addi	sp,sp,-32
    800044b0:	ec06                	sd	ra,24(sp)
    800044b2:	e822                	sd	s0,16(sp)
    800044b4:	e426                	sd	s1,8(sp)
    800044b6:	e04a                	sd	s2,0(sp)
    800044b8:	1000                	addi	s0,sp,32
    800044ba:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800044bc:	415c                	lw	a5,4(a0)
    800044be:	0047d79b          	srliw	a5,a5,0x4
    800044c2:	0006a597          	auipc	a1,0x6a
    800044c6:	2ae5a583          	lw	a1,686(a1) # 8006e770 <sb+0x18>
    800044ca:	9dbd                	addw	a1,a1,a5
    800044cc:	4108                	lw	a0,0(a0)
    800044ce:	00000097          	auipc	ra,0x0
    800044d2:	89e080e7          	jalr	-1890(ra) # 80003d6c <bread>
    800044d6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800044d8:	05850793          	addi	a5,a0,88
    800044dc:	40d8                	lw	a4,4(s1)
    800044de:	8b3d                	andi	a4,a4,15
    800044e0:	071a                	slli	a4,a4,0x6
    800044e2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800044e4:	04449703          	lh	a4,68(s1)
    800044e8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800044ec:	04649703          	lh	a4,70(s1)
    800044f0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800044f4:	04849703          	lh	a4,72(s1)
    800044f8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800044fc:	04a49703          	lh	a4,74(s1)
    80004500:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004504:	44f8                	lw	a4,76(s1)
    80004506:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004508:	03400613          	li	a2,52
    8000450c:	05048593          	addi	a1,s1,80
    80004510:	00c78513          	addi	a0,a5,12
    80004514:	ffffd097          	auipc	ra,0xffffd
    80004518:	95e080e7          	jalr	-1698(ra) # 80000e72 <memmove>
  log_write(bp);
    8000451c:	854a                	mv	a0,s2
    8000451e:	00001097          	auipc	ra,0x1
    80004522:	c24080e7          	jalr	-988(ra) # 80005142 <log_write>
  brelse(bp);
    80004526:	854a                	mv	a0,s2
    80004528:	00000097          	auipc	ra,0x0
    8000452c:	974080e7          	jalr	-1676(ra) # 80003e9c <brelse>
}
    80004530:	60e2                	ld	ra,24(sp)
    80004532:	6442                	ld	s0,16(sp)
    80004534:	64a2                	ld	s1,8(sp)
    80004536:	6902                	ld	s2,0(sp)
    80004538:	6105                	addi	sp,sp,32
    8000453a:	8082                	ret

000000008000453c <idup>:
{
    8000453c:	1101                	addi	sp,sp,-32
    8000453e:	ec06                	sd	ra,24(sp)
    80004540:	e822                	sd	s0,16(sp)
    80004542:	e426                	sd	s1,8(sp)
    80004544:	1000                	addi	s0,sp,32
    80004546:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004548:	0006a517          	auipc	a0,0x6a
    8000454c:	23050513          	addi	a0,a0,560 # 8006e778 <itable>
    80004550:	ffffc097          	auipc	ra,0xffffc
    80004554:	7c6080e7          	jalr	1990(ra) # 80000d16 <acquire>
  ip->ref++;
    80004558:	449c                	lw	a5,8(s1)
    8000455a:	2785                	addiw	a5,a5,1
    8000455c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000455e:	0006a517          	auipc	a0,0x6a
    80004562:	21a50513          	addi	a0,a0,538 # 8006e778 <itable>
    80004566:	ffffd097          	auipc	ra,0xffffd
    8000456a:	860080e7          	jalr	-1952(ra) # 80000dc6 <release>
}
    8000456e:	8526                	mv	a0,s1
    80004570:	60e2                	ld	ra,24(sp)
    80004572:	6442                	ld	s0,16(sp)
    80004574:	64a2                	ld	s1,8(sp)
    80004576:	6105                	addi	sp,sp,32
    80004578:	8082                	ret

000000008000457a <ilock>:
{
    8000457a:	1101                	addi	sp,sp,-32
    8000457c:	ec06                	sd	ra,24(sp)
    8000457e:	e822                	sd	s0,16(sp)
    80004580:	e426                	sd	s1,8(sp)
    80004582:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004584:	c10d                	beqz	a0,800045a6 <ilock+0x2c>
    80004586:	84aa                	mv	s1,a0
    80004588:	451c                	lw	a5,8(a0)
    8000458a:	00f05e63          	blez	a5,800045a6 <ilock+0x2c>
  acquiresleep(&ip->lock);
    8000458e:	0541                	addi	a0,a0,16
    80004590:	00001097          	auipc	ra,0x1
    80004594:	cd0080e7          	jalr	-816(ra) # 80005260 <acquiresleep>
  if(ip->valid == 0){
    80004598:	40bc                	lw	a5,64(s1)
    8000459a:	cf99                	beqz	a5,800045b8 <ilock+0x3e>
}
    8000459c:	60e2                	ld	ra,24(sp)
    8000459e:	6442                	ld	s0,16(sp)
    800045a0:	64a2                	ld	s1,8(sp)
    800045a2:	6105                	addi	sp,sp,32
    800045a4:	8082                	ret
    800045a6:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800045a8:	00007517          	auipc	a0,0x7
    800045ac:	fb050513          	addi	a0,a0,-80 # 8000b558 <etext+0x558>
    800045b0:	ffffc097          	auipc	ra,0xffffc
    800045b4:	fb0080e7          	jalr	-80(ra) # 80000560 <panic>
    800045b8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800045ba:	40dc                	lw	a5,4(s1)
    800045bc:	0047d79b          	srliw	a5,a5,0x4
    800045c0:	0006a597          	auipc	a1,0x6a
    800045c4:	1b05a583          	lw	a1,432(a1) # 8006e770 <sb+0x18>
    800045c8:	9dbd                	addw	a1,a1,a5
    800045ca:	4088                	lw	a0,0(s1)
    800045cc:	fffff097          	auipc	ra,0xfffff
    800045d0:	7a0080e7          	jalr	1952(ra) # 80003d6c <bread>
    800045d4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800045d6:	05850593          	addi	a1,a0,88
    800045da:	40dc                	lw	a5,4(s1)
    800045dc:	8bbd                	andi	a5,a5,15
    800045de:	079a                	slli	a5,a5,0x6
    800045e0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800045e2:	00059783          	lh	a5,0(a1)
    800045e6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800045ea:	00259783          	lh	a5,2(a1)
    800045ee:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800045f2:	00459783          	lh	a5,4(a1)
    800045f6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800045fa:	00659783          	lh	a5,6(a1)
    800045fe:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004602:	459c                	lw	a5,8(a1)
    80004604:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004606:	03400613          	li	a2,52
    8000460a:	05b1                	addi	a1,a1,12
    8000460c:	05048513          	addi	a0,s1,80
    80004610:	ffffd097          	auipc	ra,0xffffd
    80004614:	862080e7          	jalr	-1950(ra) # 80000e72 <memmove>
    brelse(bp);
    80004618:	854a                	mv	a0,s2
    8000461a:	00000097          	auipc	ra,0x0
    8000461e:	882080e7          	jalr	-1918(ra) # 80003e9c <brelse>
    ip->valid = 1;
    80004622:	4785                	li	a5,1
    80004624:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80004626:	04449783          	lh	a5,68(s1)
    8000462a:	c399                	beqz	a5,80004630 <ilock+0xb6>
    8000462c:	6902                	ld	s2,0(sp)
    8000462e:	b7bd                	j	8000459c <ilock+0x22>
      panic("ilock: no type");
    80004630:	00007517          	auipc	a0,0x7
    80004634:	f3050513          	addi	a0,a0,-208 # 8000b560 <etext+0x560>
    80004638:	ffffc097          	auipc	ra,0xffffc
    8000463c:	f28080e7          	jalr	-216(ra) # 80000560 <panic>

0000000080004640 <iunlock>:
{
    80004640:	1101                	addi	sp,sp,-32
    80004642:	ec06                	sd	ra,24(sp)
    80004644:	e822                	sd	s0,16(sp)
    80004646:	e426                	sd	s1,8(sp)
    80004648:	e04a                	sd	s2,0(sp)
    8000464a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000464c:	c905                	beqz	a0,8000467c <iunlock+0x3c>
    8000464e:	84aa                	mv	s1,a0
    80004650:	01050913          	addi	s2,a0,16
    80004654:	854a                	mv	a0,s2
    80004656:	00001097          	auipc	ra,0x1
    8000465a:	ca4080e7          	jalr	-860(ra) # 800052fa <holdingsleep>
    8000465e:	cd19                	beqz	a0,8000467c <iunlock+0x3c>
    80004660:	449c                	lw	a5,8(s1)
    80004662:	00f05d63          	blez	a5,8000467c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80004666:	854a                	mv	a0,s2
    80004668:	00001097          	auipc	ra,0x1
    8000466c:	c4e080e7          	jalr	-946(ra) # 800052b6 <releasesleep>
}
    80004670:	60e2                	ld	ra,24(sp)
    80004672:	6442                	ld	s0,16(sp)
    80004674:	64a2                	ld	s1,8(sp)
    80004676:	6902                	ld	s2,0(sp)
    80004678:	6105                	addi	sp,sp,32
    8000467a:	8082                	ret
    panic("iunlock");
    8000467c:	00007517          	auipc	a0,0x7
    80004680:	ef450513          	addi	a0,a0,-268 # 8000b570 <etext+0x570>
    80004684:	ffffc097          	auipc	ra,0xffffc
    80004688:	edc080e7          	jalr	-292(ra) # 80000560 <panic>

000000008000468c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000468c:	7179                	addi	sp,sp,-48
    8000468e:	f406                	sd	ra,40(sp)
    80004690:	f022                	sd	s0,32(sp)
    80004692:	ec26                	sd	s1,24(sp)
    80004694:	e84a                	sd	s2,16(sp)
    80004696:	e44e                	sd	s3,8(sp)
    80004698:	1800                	addi	s0,sp,48
    8000469a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000469c:	05050493          	addi	s1,a0,80
    800046a0:	08050913          	addi	s2,a0,128
    800046a4:	a021                	j	800046ac <itrunc+0x20>
    800046a6:	0491                	addi	s1,s1,4
    800046a8:	01248d63          	beq	s1,s2,800046c2 <itrunc+0x36>
    if(ip->addrs[i]){
    800046ac:	408c                	lw	a1,0(s1)
    800046ae:	dde5                	beqz	a1,800046a6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800046b0:	0009a503          	lw	a0,0(s3)
    800046b4:	00000097          	auipc	ra,0x0
    800046b8:	8f8080e7          	jalr	-1800(ra) # 80003fac <bfree>
      ip->addrs[i] = 0;
    800046bc:	0004a023          	sw	zero,0(s1)
    800046c0:	b7dd                	j	800046a6 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800046c2:	0809a583          	lw	a1,128(s3)
    800046c6:	ed99                	bnez	a1,800046e4 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800046c8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800046cc:	854e                	mv	a0,s3
    800046ce:	00000097          	auipc	ra,0x0
    800046d2:	de0080e7          	jalr	-544(ra) # 800044ae <iupdate>
}
    800046d6:	70a2                	ld	ra,40(sp)
    800046d8:	7402                	ld	s0,32(sp)
    800046da:	64e2                	ld	s1,24(sp)
    800046dc:	6942                	ld	s2,16(sp)
    800046de:	69a2                	ld	s3,8(sp)
    800046e0:	6145                	addi	sp,sp,48
    800046e2:	8082                	ret
    800046e4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800046e6:	0009a503          	lw	a0,0(s3)
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	682080e7          	jalr	1666(ra) # 80003d6c <bread>
    800046f2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800046f4:	05850493          	addi	s1,a0,88
    800046f8:	45850913          	addi	s2,a0,1112
    800046fc:	a021                	j	80004704 <itrunc+0x78>
    800046fe:	0491                	addi	s1,s1,4
    80004700:	01248b63          	beq	s1,s2,80004716 <itrunc+0x8a>
      if(a[j])
    80004704:	408c                	lw	a1,0(s1)
    80004706:	dde5                	beqz	a1,800046fe <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80004708:	0009a503          	lw	a0,0(s3)
    8000470c:	00000097          	auipc	ra,0x0
    80004710:	8a0080e7          	jalr	-1888(ra) # 80003fac <bfree>
    80004714:	b7ed                	j	800046fe <itrunc+0x72>
    brelse(bp);
    80004716:	8552                	mv	a0,s4
    80004718:	fffff097          	auipc	ra,0xfffff
    8000471c:	784080e7          	jalr	1924(ra) # 80003e9c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004720:	0809a583          	lw	a1,128(s3)
    80004724:	0009a503          	lw	a0,0(s3)
    80004728:	00000097          	auipc	ra,0x0
    8000472c:	884080e7          	jalr	-1916(ra) # 80003fac <bfree>
    ip->addrs[NDIRECT] = 0;
    80004730:	0809a023          	sw	zero,128(s3)
    80004734:	6a02                	ld	s4,0(sp)
    80004736:	bf49                	j	800046c8 <itrunc+0x3c>

0000000080004738 <iput>:
{
    80004738:	1101                	addi	sp,sp,-32
    8000473a:	ec06                	sd	ra,24(sp)
    8000473c:	e822                	sd	s0,16(sp)
    8000473e:	e426                	sd	s1,8(sp)
    80004740:	1000                	addi	s0,sp,32
    80004742:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004744:	0006a517          	auipc	a0,0x6a
    80004748:	03450513          	addi	a0,a0,52 # 8006e778 <itable>
    8000474c:	ffffc097          	auipc	ra,0xffffc
    80004750:	5ca080e7          	jalr	1482(ra) # 80000d16 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004754:	4498                	lw	a4,8(s1)
    80004756:	4785                	li	a5,1
    80004758:	02f70263          	beq	a4,a5,8000477c <iput+0x44>
  ip->ref--;
    8000475c:	449c                	lw	a5,8(s1)
    8000475e:	37fd                	addiw	a5,a5,-1
    80004760:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004762:	0006a517          	auipc	a0,0x6a
    80004766:	01650513          	addi	a0,a0,22 # 8006e778 <itable>
    8000476a:	ffffc097          	auipc	ra,0xffffc
    8000476e:	65c080e7          	jalr	1628(ra) # 80000dc6 <release>
}
    80004772:	60e2                	ld	ra,24(sp)
    80004774:	6442                	ld	s0,16(sp)
    80004776:	64a2                	ld	s1,8(sp)
    80004778:	6105                	addi	sp,sp,32
    8000477a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000477c:	40bc                	lw	a5,64(s1)
    8000477e:	dff9                	beqz	a5,8000475c <iput+0x24>
    80004780:	04a49783          	lh	a5,74(s1)
    80004784:	ffe1                	bnez	a5,8000475c <iput+0x24>
    80004786:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80004788:	01048913          	addi	s2,s1,16
    8000478c:	854a                	mv	a0,s2
    8000478e:	00001097          	auipc	ra,0x1
    80004792:	ad2080e7          	jalr	-1326(ra) # 80005260 <acquiresleep>
    release(&itable.lock);
    80004796:	0006a517          	auipc	a0,0x6a
    8000479a:	fe250513          	addi	a0,a0,-30 # 8006e778 <itable>
    8000479e:	ffffc097          	auipc	ra,0xffffc
    800047a2:	628080e7          	jalr	1576(ra) # 80000dc6 <release>
    itrunc(ip);
    800047a6:	8526                	mv	a0,s1
    800047a8:	00000097          	auipc	ra,0x0
    800047ac:	ee4080e7          	jalr	-284(ra) # 8000468c <itrunc>
    ip->type = 0;
    800047b0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800047b4:	8526                	mv	a0,s1
    800047b6:	00000097          	auipc	ra,0x0
    800047ba:	cf8080e7          	jalr	-776(ra) # 800044ae <iupdate>
    ip->valid = 0;
    800047be:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800047c2:	854a                	mv	a0,s2
    800047c4:	00001097          	auipc	ra,0x1
    800047c8:	af2080e7          	jalr	-1294(ra) # 800052b6 <releasesleep>
    acquire(&itable.lock);
    800047cc:	0006a517          	auipc	a0,0x6a
    800047d0:	fac50513          	addi	a0,a0,-84 # 8006e778 <itable>
    800047d4:	ffffc097          	auipc	ra,0xffffc
    800047d8:	542080e7          	jalr	1346(ra) # 80000d16 <acquire>
    800047dc:	6902                	ld	s2,0(sp)
    800047de:	bfbd                	j	8000475c <iput+0x24>

00000000800047e0 <iunlockput>:
{
    800047e0:	1101                	addi	sp,sp,-32
    800047e2:	ec06                	sd	ra,24(sp)
    800047e4:	e822                	sd	s0,16(sp)
    800047e6:	e426                	sd	s1,8(sp)
    800047e8:	1000                	addi	s0,sp,32
    800047ea:	84aa                	mv	s1,a0
  iunlock(ip);
    800047ec:	00000097          	auipc	ra,0x0
    800047f0:	e54080e7          	jalr	-428(ra) # 80004640 <iunlock>
  iput(ip);
    800047f4:	8526                	mv	a0,s1
    800047f6:	00000097          	auipc	ra,0x0
    800047fa:	f42080e7          	jalr	-190(ra) # 80004738 <iput>
}
    800047fe:	60e2                	ld	ra,24(sp)
    80004800:	6442                	ld	s0,16(sp)
    80004802:	64a2                	ld	s1,8(sp)
    80004804:	6105                	addi	sp,sp,32
    80004806:	8082                	ret

0000000080004808 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004808:	1141                	addi	sp,sp,-16
    8000480a:	e406                	sd	ra,8(sp)
    8000480c:	e022                	sd	s0,0(sp)
    8000480e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004810:	411c                	lw	a5,0(a0)
    80004812:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004814:	415c                	lw	a5,4(a0)
    80004816:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004818:	04451783          	lh	a5,68(a0)
    8000481c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004820:	04a51783          	lh	a5,74(a0)
    80004824:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004828:	04c56783          	lwu	a5,76(a0)
    8000482c:	e99c                	sd	a5,16(a1)
}
    8000482e:	60a2                	ld	ra,8(sp)
    80004830:	6402                	ld	s0,0(sp)
    80004832:	0141                	addi	sp,sp,16
    80004834:	8082                	ret

0000000080004836 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004836:	457c                	lw	a5,76(a0)
    80004838:	10d7e063          	bltu	a5,a3,80004938 <readi+0x102>
{
    8000483c:	7159                	addi	sp,sp,-112
    8000483e:	f486                	sd	ra,104(sp)
    80004840:	f0a2                	sd	s0,96(sp)
    80004842:	eca6                	sd	s1,88(sp)
    80004844:	e0d2                	sd	s4,64(sp)
    80004846:	fc56                	sd	s5,56(sp)
    80004848:	f85a                	sd	s6,48(sp)
    8000484a:	f45e                	sd	s7,40(sp)
    8000484c:	1880                	addi	s0,sp,112
    8000484e:	8b2a                	mv	s6,a0
    80004850:	8bae                	mv	s7,a1
    80004852:	8a32                	mv	s4,a2
    80004854:	84b6                	mv	s1,a3
    80004856:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004858:	9f35                	addw	a4,a4,a3
    return 0;
    8000485a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000485c:	0cd76563          	bltu	a4,a3,80004926 <readi+0xf0>
    80004860:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004862:	00e7f463          	bgeu	a5,a4,8000486a <readi+0x34>
    n = ip->size - off;
    80004866:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000486a:	0a0a8563          	beqz	s5,80004914 <readi+0xde>
    8000486e:	e8ca                	sd	s2,80(sp)
    80004870:	f062                	sd	s8,32(sp)
    80004872:	ec66                	sd	s9,24(sp)
    80004874:	e86a                	sd	s10,16(sp)
    80004876:	e46e                	sd	s11,8(sp)
    80004878:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000487a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000487e:	5c7d                	li	s8,-1
    80004880:	a82d                	j	800048ba <readi+0x84>
    80004882:	020d1d93          	slli	s11,s10,0x20
    80004886:	020ddd93          	srli	s11,s11,0x20
    8000488a:	05890613          	addi	a2,s2,88
    8000488e:	86ee                	mv	a3,s11
    80004890:	963e                	add	a2,a2,a5
    80004892:	85d2                	mv	a1,s4
    80004894:	855e                	mv	a0,s7
    80004896:	ffffe097          	auipc	ra,0xffffe
    8000489a:	534080e7          	jalr	1332(ra) # 80002dca <either_copyout>
    8000489e:	05850963          	beq	a0,s8,800048f0 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800048a2:	854a                	mv	a0,s2
    800048a4:	fffff097          	auipc	ra,0xfffff
    800048a8:	5f8080e7          	jalr	1528(ra) # 80003e9c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800048ac:	013d09bb          	addw	s3,s10,s3
    800048b0:	009d04bb          	addw	s1,s10,s1
    800048b4:	9a6e                	add	s4,s4,s11
    800048b6:	0559f963          	bgeu	s3,s5,80004908 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    800048ba:	00a4d59b          	srliw	a1,s1,0xa
    800048be:	855a                	mv	a0,s6
    800048c0:	00000097          	auipc	ra,0x0
    800048c4:	89e080e7          	jalr	-1890(ra) # 8000415e <bmap>
    800048c8:	85aa                	mv	a1,a0
    if(addr == 0)
    800048ca:	c539                	beqz	a0,80004918 <readi+0xe2>
    bp = bread(ip->dev, addr);
    800048cc:	000b2503          	lw	a0,0(s6)
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	49c080e7          	jalr	1180(ra) # 80003d6c <bread>
    800048d8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800048da:	3ff4f793          	andi	a5,s1,1023
    800048de:	40fc873b          	subw	a4,s9,a5
    800048e2:	413a86bb          	subw	a3,s5,s3
    800048e6:	8d3a                	mv	s10,a4
    800048e8:	f8e6fde3          	bgeu	a3,a4,80004882 <readi+0x4c>
    800048ec:	8d36                	mv	s10,a3
    800048ee:	bf51                	j	80004882 <readi+0x4c>
      brelse(bp);
    800048f0:	854a                	mv	a0,s2
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	5aa080e7          	jalr	1450(ra) # 80003e9c <brelse>
      tot = -1;
    800048fa:	59fd                	li	s3,-1
      break;
    800048fc:	6946                	ld	s2,80(sp)
    800048fe:	7c02                	ld	s8,32(sp)
    80004900:	6ce2                	ld	s9,24(sp)
    80004902:	6d42                	ld	s10,16(sp)
    80004904:	6da2                	ld	s11,8(sp)
    80004906:	a831                	j	80004922 <readi+0xec>
    80004908:	6946                	ld	s2,80(sp)
    8000490a:	7c02                	ld	s8,32(sp)
    8000490c:	6ce2                	ld	s9,24(sp)
    8000490e:	6d42                	ld	s10,16(sp)
    80004910:	6da2                	ld	s11,8(sp)
    80004912:	a801                	j	80004922 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004914:	89d6                	mv	s3,s5
    80004916:	a031                	j	80004922 <readi+0xec>
    80004918:	6946                	ld	s2,80(sp)
    8000491a:	7c02                	ld	s8,32(sp)
    8000491c:	6ce2                	ld	s9,24(sp)
    8000491e:	6d42                	ld	s10,16(sp)
    80004920:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004922:	854e                	mv	a0,s3
    80004924:	69a6                	ld	s3,72(sp)
}
    80004926:	70a6                	ld	ra,104(sp)
    80004928:	7406                	ld	s0,96(sp)
    8000492a:	64e6                	ld	s1,88(sp)
    8000492c:	6a06                	ld	s4,64(sp)
    8000492e:	7ae2                	ld	s5,56(sp)
    80004930:	7b42                	ld	s6,48(sp)
    80004932:	7ba2                	ld	s7,40(sp)
    80004934:	6165                	addi	sp,sp,112
    80004936:	8082                	ret
    return 0;
    80004938:	4501                	li	a0,0
}
    8000493a:	8082                	ret

000000008000493c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000493c:	457c                	lw	a5,76(a0)
    8000493e:	10d7e963          	bltu	a5,a3,80004a50 <writei+0x114>
{
    80004942:	7159                	addi	sp,sp,-112
    80004944:	f486                	sd	ra,104(sp)
    80004946:	f0a2                	sd	s0,96(sp)
    80004948:	e8ca                	sd	s2,80(sp)
    8000494a:	e0d2                	sd	s4,64(sp)
    8000494c:	fc56                	sd	s5,56(sp)
    8000494e:	f85a                	sd	s6,48(sp)
    80004950:	f45e                	sd	s7,40(sp)
    80004952:	1880                	addi	s0,sp,112
    80004954:	8aaa                	mv	s5,a0
    80004956:	8bae                	mv	s7,a1
    80004958:	8a32                	mv	s4,a2
    8000495a:	8936                	mv	s2,a3
    8000495c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000495e:	00e687bb          	addw	a5,a3,a4
    80004962:	0ed7e963          	bltu	a5,a3,80004a54 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004966:	00043737          	lui	a4,0x43
    8000496a:	0ef76763          	bltu	a4,a5,80004a58 <writei+0x11c>
    8000496e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004970:	0c0b0863          	beqz	s6,80004a40 <writei+0x104>
    80004974:	eca6                	sd	s1,88(sp)
    80004976:	f062                	sd	s8,32(sp)
    80004978:	ec66                	sd	s9,24(sp)
    8000497a:	e86a                	sd	s10,16(sp)
    8000497c:	e46e                	sd	s11,8(sp)
    8000497e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004980:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004984:	5c7d                	li	s8,-1
    80004986:	a091                	j	800049ca <writei+0x8e>
    80004988:	020d1d93          	slli	s11,s10,0x20
    8000498c:	020ddd93          	srli	s11,s11,0x20
    80004990:	05848513          	addi	a0,s1,88
    80004994:	86ee                	mv	a3,s11
    80004996:	8652                	mv	a2,s4
    80004998:	85de                	mv	a1,s7
    8000499a:	953e                	add	a0,a0,a5
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	484080e7          	jalr	1156(ra) # 80002e20 <either_copyin>
    800049a4:	05850e63          	beq	a0,s8,80004a00 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    800049a8:	8526                	mv	a0,s1
    800049aa:	00000097          	auipc	ra,0x0
    800049ae:	798080e7          	jalr	1944(ra) # 80005142 <log_write>
    brelse(bp);
    800049b2:	8526                	mv	a0,s1
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	4e8080e7          	jalr	1256(ra) # 80003e9c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800049bc:	013d09bb          	addw	s3,s10,s3
    800049c0:	012d093b          	addw	s2,s10,s2
    800049c4:	9a6e                	add	s4,s4,s11
    800049c6:	0569f263          	bgeu	s3,s6,80004a0a <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800049ca:	00a9559b          	srliw	a1,s2,0xa
    800049ce:	8556                	mv	a0,s5
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	78e080e7          	jalr	1934(ra) # 8000415e <bmap>
    800049d8:	85aa                	mv	a1,a0
    if(addr == 0)
    800049da:	c905                	beqz	a0,80004a0a <writei+0xce>
    bp = bread(ip->dev, addr);
    800049dc:	000aa503          	lw	a0,0(s5)
    800049e0:	fffff097          	auipc	ra,0xfffff
    800049e4:	38c080e7          	jalr	908(ra) # 80003d6c <bread>
    800049e8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800049ea:	3ff97793          	andi	a5,s2,1023
    800049ee:	40fc873b          	subw	a4,s9,a5
    800049f2:	413b06bb          	subw	a3,s6,s3
    800049f6:	8d3a                	mv	s10,a4
    800049f8:	f8e6f8e3          	bgeu	a3,a4,80004988 <writei+0x4c>
    800049fc:	8d36                	mv	s10,a3
    800049fe:	b769                	j	80004988 <writei+0x4c>
      brelse(bp);
    80004a00:	8526                	mv	a0,s1
    80004a02:	fffff097          	auipc	ra,0xfffff
    80004a06:	49a080e7          	jalr	1178(ra) # 80003e9c <brelse>
  }

  if(off > ip->size)
    80004a0a:	04caa783          	lw	a5,76(s5)
    80004a0e:	0327fb63          	bgeu	a5,s2,80004a44 <writei+0x108>
    ip->size = off;
    80004a12:	052aa623          	sw	s2,76(s5)
    80004a16:	64e6                	ld	s1,88(sp)
    80004a18:	7c02                	ld	s8,32(sp)
    80004a1a:	6ce2                	ld	s9,24(sp)
    80004a1c:	6d42                	ld	s10,16(sp)
    80004a1e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004a20:	8556                	mv	a0,s5
    80004a22:	00000097          	auipc	ra,0x0
    80004a26:	a8c080e7          	jalr	-1396(ra) # 800044ae <iupdate>

  return tot;
    80004a2a:	854e                	mv	a0,s3
    80004a2c:	69a6                	ld	s3,72(sp)
}
    80004a2e:	70a6                	ld	ra,104(sp)
    80004a30:	7406                	ld	s0,96(sp)
    80004a32:	6946                	ld	s2,80(sp)
    80004a34:	6a06                	ld	s4,64(sp)
    80004a36:	7ae2                	ld	s5,56(sp)
    80004a38:	7b42                	ld	s6,48(sp)
    80004a3a:	7ba2                	ld	s7,40(sp)
    80004a3c:	6165                	addi	sp,sp,112
    80004a3e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004a40:	89da                	mv	s3,s6
    80004a42:	bff9                	j	80004a20 <writei+0xe4>
    80004a44:	64e6                	ld	s1,88(sp)
    80004a46:	7c02                	ld	s8,32(sp)
    80004a48:	6ce2                	ld	s9,24(sp)
    80004a4a:	6d42                	ld	s10,16(sp)
    80004a4c:	6da2                	ld	s11,8(sp)
    80004a4e:	bfc9                	j	80004a20 <writei+0xe4>
    return -1;
    80004a50:	557d                	li	a0,-1
}
    80004a52:	8082                	ret
    return -1;
    80004a54:	557d                	li	a0,-1
    80004a56:	bfe1                	j	80004a2e <writei+0xf2>
    return -1;
    80004a58:	557d                	li	a0,-1
    80004a5a:	bfd1                	j	80004a2e <writei+0xf2>

0000000080004a5c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004a5c:	1141                	addi	sp,sp,-16
    80004a5e:	e406                	sd	ra,8(sp)
    80004a60:	e022                	sd	s0,0(sp)
    80004a62:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004a64:	4639                	li	a2,14
    80004a66:	ffffc097          	auipc	ra,0xffffc
    80004a6a:	484080e7          	jalr	1156(ra) # 80000eea <strncmp>
}
    80004a6e:	60a2                	ld	ra,8(sp)
    80004a70:	6402                	ld	s0,0(sp)
    80004a72:	0141                	addi	sp,sp,16
    80004a74:	8082                	ret

0000000080004a76 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004a76:	711d                	addi	sp,sp,-96
    80004a78:	ec86                	sd	ra,88(sp)
    80004a7a:	e8a2                	sd	s0,80(sp)
    80004a7c:	e4a6                	sd	s1,72(sp)
    80004a7e:	e0ca                	sd	s2,64(sp)
    80004a80:	fc4e                	sd	s3,56(sp)
    80004a82:	f852                	sd	s4,48(sp)
    80004a84:	f456                	sd	s5,40(sp)
    80004a86:	f05a                	sd	s6,32(sp)
    80004a88:	ec5e                	sd	s7,24(sp)
    80004a8a:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004a8c:	04451703          	lh	a4,68(a0)
    80004a90:	4785                	li	a5,1
    80004a92:	00f71f63          	bne	a4,a5,80004ab0 <dirlookup+0x3a>
    80004a96:	892a                	mv	s2,a0
    80004a98:	8aae                	mv	s5,a1
    80004a9a:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a9c:	457c                	lw	a5,76(a0)
    80004a9e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aa0:	fa040a13          	addi	s4,s0,-96
    80004aa4:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80004aa6:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004aaa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004aac:	e79d                	bnez	a5,80004ada <dirlookup+0x64>
    80004aae:	a88d                	j	80004b20 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80004ab0:	00007517          	auipc	a0,0x7
    80004ab4:	ac850513          	addi	a0,a0,-1336 # 8000b578 <etext+0x578>
    80004ab8:	ffffc097          	auipc	ra,0xffffc
    80004abc:	aa8080e7          	jalr	-1368(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004ac0:	00007517          	auipc	a0,0x7
    80004ac4:	ad050513          	addi	a0,a0,-1328 # 8000b590 <etext+0x590>
    80004ac8:	ffffc097          	auipc	ra,0xffffc
    80004acc:	a98080e7          	jalr	-1384(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004ad0:	24c1                	addiw	s1,s1,16
    80004ad2:	04c92783          	lw	a5,76(s2)
    80004ad6:	04f4f463          	bgeu	s1,a5,80004b1e <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ada:	874e                	mv	a4,s3
    80004adc:	86a6                	mv	a3,s1
    80004ade:	8652                	mv	a2,s4
    80004ae0:	4581                	li	a1,0
    80004ae2:	854a                	mv	a0,s2
    80004ae4:	00000097          	auipc	ra,0x0
    80004ae8:	d52080e7          	jalr	-686(ra) # 80004836 <readi>
    80004aec:	fd351ae3          	bne	a0,s3,80004ac0 <dirlookup+0x4a>
    if(de.inum == 0)
    80004af0:	fa045783          	lhu	a5,-96(s0)
    80004af4:	dff1                	beqz	a5,80004ad0 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80004af6:	85da                	mv	a1,s6
    80004af8:	8556                	mv	a0,s5
    80004afa:	00000097          	auipc	ra,0x0
    80004afe:	f62080e7          	jalr	-158(ra) # 80004a5c <namecmp>
    80004b02:	f579                	bnez	a0,80004ad0 <dirlookup+0x5a>
      if(poff)
    80004b04:	000b8463          	beqz	s7,80004b0c <dirlookup+0x96>
        *poff = off;
    80004b08:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80004b0c:	fa045583          	lhu	a1,-96(s0)
    80004b10:	00092503          	lw	a0,0(s2)
    80004b14:	fffff097          	auipc	ra,0xfffff
    80004b18:	726080e7          	jalr	1830(ra) # 8000423a <iget>
    80004b1c:	a011                	j	80004b20 <dirlookup+0xaa>
  return 0;
    80004b1e:	4501                	li	a0,0
}
    80004b20:	60e6                	ld	ra,88(sp)
    80004b22:	6446                	ld	s0,80(sp)
    80004b24:	64a6                	ld	s1,72(sp)
    80004b26:	6906                	ld	s2,64(sp)
    80004b28:	79e2                	ld	s3,56(sp)
    80004b2a:	7a42                	ld	s4,48(sp)
    80004b2c:	7aa2                	ld	s5,40(sp)
    80004b2e:	7b02                	ld	s6,32(sp)
    80004b30:	6be2                	ld	s7,24(sp)
    80004b32:	6125                	addi	sp,sp,96
    80004b34:	8082                	ret

0000000080004b36 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004b36:	711d                	addi	sp,sp,-96
    80004b38:	ec86                	sd	ra,88(sp)
    80004b3a:	e8a2                	sd	s0,80(sp)
    80004b3c:	e4a6                	sd	s1,72(sp)
    80004b3e:	e0ca                	sd	s2,64(sp)
    80004b40:	fc4e                	sd	s3,56(sp)
    80004b42:	f852                	sd	s4,48(sp)
    80004b44:	f456                	sd	s5,40(sp)
    80004b46:	f05a                	sd	s6,32(sp)
    80004b48:	ec5e                	sd	s7,24(sp)
    80004b4a:	e862                	sd	s8,16(sp)
    80004b4c:	e466                	sd	s9,8(sp)
    80004b4e:	e06a                	sd	s10,0(sp)
    80004b50:	1080                	addi	s0,sp,96
    80004b52:	84aa                	mv	s1,a0
    80004b54:	8b2e                	mv	s6,a1
    80004b56:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004b58:	00054703          	lbu	a4,0(a0)
    80004b5c:	02f00793          	li	a5,47
    80004b60:	02f70363          	beq	a4,a5,80004b86 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004b64:	ffffd097          	auipc	ra,0xffffd
    80004b68:	2f6080e7          	jalr	758(ra) # 80001e5a <myproc>
    80004b6c:	15053503          	ld	a0,336(a0)
    80004b70:	00000097          	auipc	ra,0x0
    80004b74:	9cc080e7          	jalr	-1588(ra) # 8000453c <idup>
    80004b78:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004b7a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004b7e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004b80:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004b82:	4b85                	li	s7,1
    80004b84:	a87d                	j	80004c42 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004b86:	4585                	li	a1,1
    80004b88:	852e                	mv	a0,a1
    80004b8a:	fffff097          	auipc	ra,0xfffff
    80004b8e:	6b0080e7          	jalr	1712(ra) # 8000423a <iget>
    80004b92:	8a2a                	mv	s4,a0
    80004b94:	b7dd                	j	80004b7a <namex+0x44>
      iunlockput(ip);
    80004b96:	8552                	mv	a0,s4
    80004b98:	00000097          	auipc	ra,0x0
    80004b9c:	c48080e7          	jalr	-952(ra) # 800047e0 <iunlockput>
      return 0;
    80004ba0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004ba2:	8552                	mv	a0,s4
    80004ba4:	60e6                	ld	ra,88(sp)
    80004ba6:	6446                	ld	s0,80(sp)
    80004ba8:	64a6                	ld	s1,72(sp)
    80004baa:	6906                	ld	s2,64(sp)
    80004bac:	79e2                	ld	s3,56(sp)
    80004bae:	7a42                	ld	s4,48(sp)
    80004bb0:	7aa2                	ld	s5,40(sp)
    80004bb2:	7b02                	ld	s6,32(sp)
    80004bb4:	6be2                	ld	s7,24(sp)
    80004bb6:	6c42                	ld	s8,16(sp)
    80004bb8:	6ca2                	ld	s9,8(sp)
    80004bba:	6d02                	ld	s10,0(sp)
    80004bbc:	6125                	addi	sp,sp,96
    80004bbe:	8082                	ret
      iunlock(ip);
    80004bc0:	8552                	mv	a0,s4
    80004bc2:	00000097          	auipc	ra,0x0
    80004bc6:	a7e080e7          	jalr	-1410(ra) # 80004640 <iunlock>
      return ip;
    80004bca:	bfe1                	j	80004ba2 <namex+0x6c>
      iunlockput(ip);
    80004bcc:	8552                	mv	a0,s4
    80004bce:	00000097          	auipc	ra,0x0
    80004bd2:	c12080e7          	jalr	-1006(ra) # 800047e0 <iunlockput>
      return 0;
    80004bd6:	8a4e                	mv	s4,s3
    80004bd8:	b7e9                	j	80004ba2 <namex+0x6c>
  len = path - s;
    80004bda:	40998633          	sub	a2,s3,s1
    80004bde:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004be2:	09ac5863          	bge	s8,s10,80004c72 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80004be6:	8666                	mv	a2,s9
    80004be8:	85a6                	mv	a1,s1
    80004bea:	8556                	mv	a0,s5
    80004bec:	ffffc097          	auipc	ra,0xffffc
    80004bf0:	286080e7          	jalr	646(ra) # 80000e72 <memmove>
    80004bf4:	84ce                	mv	s1,s3
  while(*path == '/')
    80004bf6:	0004c783          	lbu	a5,0(s1)
    80004bfa:	01279763          	bne	a5,s2,80004c08 <namex+0xd2>
    path++;
    80004bfe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004c00:	0004c783          	lbu	a5,0(s1)
    80004c04:	ff278de3          	beq	a5,s2,80004bfe <namex+0xc8>
    ilock(ip);
    80004c08:	8552                	mv	a0,s4
    80004c0a:	00000097          	auipc	ra,0x0
    80004c0e:	970080e7          	jalr	-1680(ra) # 8000457a <ilock>
    if(ip->type != T_DIR){
    80004c12:	044a1783          	lh	a5,68(s4)
    80004c16:	f97790e3          	bne	a5,s7,80004b96 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80004c1a:	000b0563          	beqz	s6,80004c24 <namex+0xee>
    80004c1e:	0004c783          	lbu	a5,0(s1)
    80004c22:	dfd9                	beqz	a5,80004bc0 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004c24:	4601                	li	a2,0
    80004c26:	85d6                	mv	a1,s5
    80004c28:	8552                	mv	a0,s4
    80004c2a:	00000097          	auipc	ra,0x0
    80004c2e:	e4c080e7          	jalr	-436(ra) # 80004a76 <dirlookup>
    80004c32:	89aa                	mv	s3,a0
    80004c34:	dd41                	beqz	a0,80004bcc <namex+0x96>
    iunlockput(ip);
    80004c36:	8552                	mv	a0,s4
    80004c38:	00000097          	auipc	ra,0x0
    80004c3c:	ba8080e7          	jalr	-1112(ra) # 800047e0 <iunlockput>
    ip = next;
    80004c40:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004c42:	0004c783          	lbu	a5,0(s1)
    80004c46:	01279763          	bne	a5,s2,80004c54 <namex+0x11e>
    path++;
    80004c4a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004c4c:	0004c783          	lbu	a5,0(s1)
    80004c50:	ff278de3          	beq	a5,s2,80004c4a <namex+0x114>
  if(*path == 0)
    80004c54:	cb9d                	beqz	a5,80004c8a <namex+0x154>
  while(*path != '/' && *path != 0)
    80004c56:	0004c783          	lbu	a5,0(s1)
    80004c5a:	89a6                	mv	s3,s1
  len = path - s;
    80004c5c:	4d01                	li	s10,0
    80004c5e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004c60:	01278963          	beq	a5,s2,80004c72 <namex+0x13c>
    80004c64:	dbbd                	beqz	a5,80004bda <namex+0xa4>
    path++;
    80004c66:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004c68:	0009c783          	lbu	a5,0(s3)
    80004c6c:	ff279ce3          	bne	a5,s2,80004c64 <namex+0x12e>
    80004c70:	b7ad                	j	80004bda <namex+0xa4>
    memmove(name, s, len);
    80004c72:	2601                	sext.w	a2,a2
    80004c74:	85a6                	mv	a1,s1
    80004c76:	8556                	mv	a0,s5
    80004c78:	ffffc097          	auipc	ra,0xffffc
    80004c7c:	1fa080e7          	jalr	506(ra) # 80000e72 <memmove>
    name[len] = 0;
    80004c80:	9d56                	add	s10,s10,s5
    80004c82:	000d0023          	sb	zero,0(s10)
    80004c86:	84ce                	mv	s1,s3
    80004c88:	b7bd                	j	80004bf6 <namex+0xc0>
  if(nameiparent){
    80004c8a:	f00b0ce3          	beqz	s6,80004ba2 <namex+0x6c>
    iput(ip);
    80004c8e:	8552                	mv	a0,s4
    80004c90:	00000097          	auipc	ra,0x0
    80004c94:	aa8080e7          	jalr	-1368(ra) # 80004738 <iput>
    return 0;
    80004c98:	4a01                	li	s4,0
    80004c9a:	b721                	j	80004ba2 <namex+0x6c>

0000000080004c9c <dirlink>:
{
    80004c9c:	715d                	addi	sp,sp,-80
    80004c9e:	e486                	sd	ra,72(sp)
    80004ca0:	e0a2                	sd	s0,64(sp)
    80004ca2:	f84a                	sd	s2,48(sp)
    80004ca4:	ec56                	sd	s5,24(sp)
    80004ca6:	e85a                	sd	s6,16(sp)
    80004ca8:	0880                	addi	s0,sp,80
    80004caa:	892a                	mv	s2,a0
    80004cac:	8aae                	mv	s5,a1
    80004cae:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004cb0:	4601                	li	a2,0
    80004cb2:	00000097          	auipc	ra,0x0
    80004cb6:	dc4080e7          	jalr	-572(ra) # 80004a76 <dirlookup>
    80004cba:	e129                	bnez	a0,80004cfc <dirlink+0x60>
    80004cbc:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004cbe:	04c92483          	lw	s1,76(s2)
    80004cc2:	cca9                	beqz	s1,80004d1c <dirlink+0x80>
    80004cc4:	f44e                	sd	s3,40(sp)
    80004cc6:	f052                	sd	s4,32(sp)
    80004cc8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cca:	fb040a13          	addi	s4,s0,-80
    80004cce:	49c1                	li	s3,16
    80004cd0:	874e                	mv	a4,s3
    80004cd2:	86a6                	mv	a3,s1
    80004cd4:	8652                	mv	a2,s4
    80004cd6:	4581                	li	a1,0
    80004cd8:	854a                	mv	a0,s2
    80004cda:	00000097          	auipc	ra,0x0
    80004cde:	b5c080e7          	jalr	-1188(ra) # 80004836 <readi>
    80004ce2:	03351363          	bne	a0,s3,80004d08 <dirlink+0x6c>
    if(de.inum == 0)
    80004ce6:	fb045783          	lhu	a5,-80(s0)
    80004cea:	c79d                	beqz	a5,80004d18 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004cec:	24c1                	addiw	s1,s1,16
    80004cee:	04c92783          	lw	a5,76(s2)
    80004cf2:	fcf4efe3          	bltu	s1,a5,80004cd0 <dirlink+0x34>
    80004cf6:	79a2                	ld	s3,40(sp)
    80004cf8:	7a02                	ld	s4,32(sp)
    80004cfa:	a00d                	j	80004d1c <dirlink+0x80>
    iput(ip);
    80004cfc:	00000097          	auipc	ra,0x0
    80004d00:	a3c080e7          	jalr	-1476(ra) # 80004738 <iput>
    return -1;
    80004d04:	557d                	li	a0,-1
    80004d06:	a0a9                	j	80004d50 <dirlink+0xb4>
      panic("dirlink read");
    80004d08:	00007517          	auipc	a0,0x7
    80004d0c:	89850513          	addi	a0,a0,-1896 # 8000b5a0 <etext+0x5a0>
    80004d10:	ffffc097          	auipc	ra,0xffffc
    80004d14:	850080e7          	jalr	-1968(ra) # 80000560 <panic>
    80004d18:	79a2                	ld	s3,40(sp)
    80004d1a:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004d1c:	4639                	li	a2,14
    80004d1e:	85d6                	mv	a1,s5
    80004d20:	fb240513          	addi	a0,s0,-78
    80004d24:	ffffc097          	auipc	ra,0xffffc
    80004d28:	200080e7          	jalr	512(ra) # 80000f24 <strncpy>
  de.inum = inum;
    80004d2c:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d30:	4741                	li	a4,16
    80004d32:	86a6                	mv	a3,s1
    80004d34:	fb040613          	addi	a2,s0,-80
    80004d38:	4581                	li	a1,0
    80004d3a:	854a                	mv	a0,s2
    80004d3c:	00000097          	auipc	ra,0x0
    80004d40:	c00080e7          	jalr	-1024(ra) # 8000493c <writei>
    80004d44:	1541                	addi	a0,a0,-16
    80004d46:	00a03533          	snez	a0,a0
    80004d4a:	40a0053b          	negw	a0,a0
    80004d4e:	74e2                	ld	s1,56(sp)
}
    80004d50:	60a6                	ld	ra,72(sp)
    80004d52:	6406                	ld	s0,64(sp)
    80004d54:	7942                	ld	s2,48(sp)
    80004d56:	6ae2                	ld	s5,24(sp)
    80004d58:	6b42                	ld	s6,16(sp)
    80004d5a:	6161                	addi	sp,sp,80
    80004d5c:	8082                	ret

0000000080004d5e <namei>:

struct inode*
namei(char *path)
{
    80004d5e:	1101                	addi	sp,sp,-32
    80004d60:	ec06                	sd	ra,24(sp)
    80004d62:	e822                	sd	s0,16(sp)
    80004d64:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004d66:	fe040613          	addi	a2,s0,-32
    80004d6a:	4581                	li	a1,0
    80004d6c:	00000097          	auipc	ra,0x0
    80004d70:	dca080e7          	jalr	-566(ra) # 80004b36 <namex>
}
    80004d74:	60e2                	ld	ra,24(sp)
    80004d76:	6442                	ld	s0,16(sp)
    80004d78:	6105                	addi	sp,sp,32
    80004d7a:	8082                	ret

0000000080004d7c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004d7c:	1141                	addi	sp,sp,-16
    80004d7e:	e406                	sd	ra,8(sp)
    80004d80:	e022                	sd	s0,0(sp)
    80004d82:	0800                	addi	s0,sp,16
    80004d84:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004d86:	4585                	li	a1,1
    80004d88:	00000097          	auipc	ra,0x0
    80004d8c:	dae080e7          	jalr	-594(ra) # 80004b36 <namex>
}
    80004d90:	60a2                	ld	ra,8(sp)
    80004d92:	6402                	ld	s0,0(sp)
    80004d94:	0141                	addi	sp,sp,16
    80004d96:	8082                	ret

0000000080004d98 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004d98:	1101                	addi	sp,sp,-32
    80004d9a:	ec06                	sd	ra,24(sp)
    80004d9c:	e822                	sd	s0,16(sp)
    80004d9e:	e426                	sd	s1,8(sp)
    80004da0:	e04a                	sd	s2,0(sp)
    80004da2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004da4:	0006b917          	auipc	s2,0x6b
    80004da8:	47c90913          	addi	s2,s2,1148 # 80070220 <log>
    80004dac:	01892583          	lw	a1,24(s2)
    80004db0:	02892503          	lw	a0,40(s2)
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	fb8080e7          	jalr	-72(ra) # 80003d6c <bread>
    80004dbc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004dbe:	02c92603          	lw	a2,44(s2)
    80004dc2:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004dc4:	00c05f63          	blez	a2,80004de2 <write_head+0x4a>
    80004dc8:	0006b717          	auipc	a4,0x6b
    80004dcc:	48870713          	addi	a4,a4,1160 # 80070250 <log+0x30>
    80004dd0:	87aa                	mv	a5,a0
    80004dd2:	060a                	slli	a2,a2,0x2
    80004dd4:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004dd6:	4314                	lw	a3,0(a4)
    80004dd8:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004dda:	0711                	addi	a4,a4,4
    80004ddc:	0791                	addi	a5,a5,4
    80004dde:	fec79ce3          	bne	a5,a2,80004dd6 <write_head+0x3e>
  }
  bwrite(buf);
    80004de2:	8526                	mv	a0,s1
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	07a080e7          	jalr	122(ra) # 80003e5e <bwrite>
  brelse(buf);
    80004dec:	8526                	mv	a0,s1
    80004dee:	fffff097          	auipc	ra,0xfffff
    80004df2:	0ae080e7          	jalr	174(ra) # 80003e9c <brelse>
}
    80004df6:	60e2                	ld	ra,24(sp)
    80004df8:	6442                	ld	s0,16(sp)
    80004dfa:	64a2                	ld	s1,8(sp)
    80004dfc:	6902                	ld	s2,0(sp)
    80004dfe:	6105                	addi	sp,sp,32
    80004e00:	8082                	ret

0000000080004e02 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e02:	0006b797          	auipc	a5,0x6b
    80004e06:	44a7a783          	lw	a5,1098(a5) # 8007024c <log+0x2c>
    80004e0a:	0cf05063          	blez	a5,80004eca <install_trans+0xc8>
{
    80004e0e:	715d                	addi	sp,sp,-80
    80004e10:	e486                	sd	ra,72(sp)
    80004e12:	e0a2                	sd	s0,64(sp)
    80004e14:	fc26                	sd	s1,56(sp)
    80004e16:	f84a                	sd	s2,48(sp)
    80004e18:	f44e                	sd	s3,40(sp)
    80004e1a:	f052                	sd	s4,32(sp)
    80004e1c:	ec56                	sd	s5,24(sp)
    80004e1e:	e85a                	sd	s6,16(sp)
    80004e20:	e45e                	sd	s7,8(sp)
    80004e22:	0880                	addi	s0,sp,80
    80004e24:	8b2a                	mv	s6,a0
    80004e26:	0006ba97          	auipc	s5,0x6b
    80004e2a:	42aa8a93          	addi	s5,s5,1066 # 80070250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e2e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004e30:	0006b997          	auipc	s3,0x6b
    80004e34:	3f098993          	addi	s3,s3,1008 # 80070220 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004e38:	40000b93          	li	s7,1024
    80004e3c:	a00d                	j	80004e5e <install_trans+0x5c>
    brelse(lbuf);
    80004e3e:	854a                	mv	a0,s2
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	05c080e7          	jalr	92(ra) # 80003e9c <brelse>
    brelse(dbuf);
    80004e48:	8526                	mv	a0,s1
    80004e4a:	fffff097          	auipc	ra,0xfffff
    80004e4e:	052080e7          	jalr	82(ra) # 80003e9c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e52:	2a05                	addiw	s4,s4,1
    80004e54:	0a91                	addi	s5,s5,4
    80004e56:	02c9a783          	lw	a5,44(s3)
    80004e5a:	04fa5d63          	bge	s4,a5,80004eb4 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004e5e:	0189a583          	lw	a1,24(s3)
    80004e62:	014585bb          	addw	a1,a1,s4
    80004e66:	2585                	addiw	a1,a1,1
    80004e68:	0289a503          	lw	a0,40(s3)
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	f00080e7          	jalr	-256(ra) # 80003d6c <bread>
    80004e74:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004e76:	000aa583          	lw	a1,0(s5)
    80004e7a:	0289a503          	lw	a0,40(s3)
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	eee080e7          	jalr	-274(ra) # 80003d6c <bread>
    80004e86:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004e88:	865e                	mv	a2,s7
    80004e8a:	05890593          	addi	a1,s2,88
    80004e8e:	05850513          	addi	a0,a0,88
    80004e92:	ffffc097          	auipc	ra,0xffffc
    80004e96:	fe0080e7          	jalr	-32(ra) # 80000e72 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004e9a:	8526                	mv	a0,s1
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	fc2080e7          	jalr	-62(ra) # 80003e5e <bwrite>
    if(recovering == 0)
    80004ea4:	f80b1de3          	bnez	s6,80004e3e <install_trans+0x3c>
      bunpin(dbuf);
    80004ea8:	8526                	mv	a0,s1
    80004eaa:	fffff097          	auipc	ra,0xfffff
    80004eae:	0c6080e7          	jalr	198(ra) # 80003f70 <bunpin>
    80004eb2:	b771                	j	80004e3e <install_trans+0x3c>
}
    80004eb4:	60a6                	ld	ra,72(sp)
    80004eb6:	6406                	ld	s0,64(sp)
    80004eb8:	74e2                	ld	s1,56(sp)
    80004eba:	7942                	ld	s2,48(sp)
    80004ebc:	79a2                	ld	s3,40(sp)
    80004ebe:	7a02                	ld	s4,32(sp)
    80004ec0:	6ae2                	ld	s5,24(sp)
    80004ec2:	6b42                	ld	s6,16(sp)
    80004ec4:	6ba2                	ld	s7,8(sp)
    80004ec6:	6161                	addi	sp,sp,80
    80004ec8:	8082                	ret
    80004eca:	8082                	ret

0000000080004ecc <initlog>:
{
    80004ecc:	7179                	addi	sp,sp,-48
    80004ece:	f406                	sd	ra,40(sp)
    80004ed0:	f022                	sd	s0,32(sp)
    80004ed2:	ec26                	sd	s1,24(sp)
    80004ed4:	e84a                	sd	s2,16(sp)
    80004ed6:	e44e                	sd	s3,8(sp)
    80004ed8:	1800                	addi	s0,sp,48
    80004eda:	892a                	mv	s2,a0
    80004edc:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004ede:	0006b497          	auipc	s1,0x6b
    80004ee2:	34248493          	addi	s1,s1,834 # 80070220 <log>
    80004ee6:	00006597          	auipc	a1,0x6
    80004eea:	6ca58593          	addi	a1,a1,1738 # 8000b5b0 <etext+0x5b0>
    80004eee:	8526                	mv	a0,s1
    80004ef0:	ffffc097          	auipc	ra,0xffffc
    80004ef4:	d92080e7          	jalr	-622(ra) # 80000c82 <initlock>
  log.start = sb->logstart;
    80004ef8:	0149a583          	lw	a1,20(s3)
    80004efc:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004efe:	0109a783          	lw	a5,16(s3)
    80004f02:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004f04:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004f08:	854a                	mv	a0,s2
    80004f0a:	fffff097          	auipc	ra,0xfffff
    80004f0e:	e62080e7          	jalr	-414(ra) # 80003d6c <bread>
  log.lh.n = lh->n;
    80004f12:	4d30                	lw	a2,88(a0)
    80004f14:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004f16:	00c05f63          	blez	a2,80004f34 <initlog+0x68>
    80004f1a:	87aa                	mv	a5,a0
    80004f1c:	0006b717          	auipc	a4,0x6b
    80004f20:	33470713          	addi	a4,a4,820 # 80070250 <log+0x30>
    80004f24:	060a                	slli	a2,a2,0x2
    80004f26:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004f28:	4ff4                	lw	a3,92(a5)
    80004f2a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004f2c:	0791                	addi	a5,a5,4
    80004f2e:	0711                	addi	a4,a4,4
    80004f30:	fec79ce3          	bne	a5,a2,80004f28 <initlog+0x5c>
  brelse(buf);
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	f68080e7          	jalr	-152(ra) # 80003e9c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004f3c:	4505                	li	a0,1
    80004f3e:	00000097          	auipc	ra,0x0
    80004f42:	ec4080e7          	jalr	-316(ra) # 80004e02 <install_trans>
  log.lh.n = 0;
    80004f46:	0006b797          	auipc	a5,0x6b
    80004f4a:	3007a323          	sw	zero,774(a5) # 8007024c <log+0x2c>
  write_head(); // clear the log
    80004f4e:	00000097          	auipc	ra,0x0
    80004f52:	e4a080e7          	jalr	-438(ra) # 80004d98 <write_head>
}
    80004f56:	70a2                	ld	ra,40(sp)
    80004f58:	7402                	ld	s0,32(sp)
    80004f5a:	64e2                	ld	s1,24(sp)
    80004f5c:	6942                	ld	s2,16(sp)
    80004f5e:	69a2                	ld	s3,8(sp)
    80004f60:	6145                	addi	sp,sp,48
    80004f62:	8082                	ret

0000000080004f64 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004f64:	1101                	addi	sp,sp,-32
    80004f66:	ec06                	sd	ra,24(sp)
    80004f68:	e822                	sd	s0,16(sp)
    80004f6a:	e426                	sd	s1,8(sp)
    80004f6c:	e04a                	sd	s2,0(sp)
    80004f6e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004f70:	0006b517          	auipc	a0,0x6b
    80004f74:	2b050513          	addi	a0,a0,688 # 80070220 <log>
    80004f78:	ffffc097          	auipc	ra,0xffffc
    80004f7c:	d9e080e7          	jalr	-610(ra) # 80000d16 <acquire>
  while(1){
    if(log.committing){
    80004f80:	0006b497          	auipc	s1,0x6b
    80004f84:	2a048493          	addi	s1,s1,672 # 80070220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004f88:	4979                	li	s2,30
    80004f8a:	a039                	j	80004f98 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004f8c:	85a6                	mv	a1,s1
    80004f8e:	8526                	mv	a0,s1
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	778080e7          	jalr	1912(ra) # 80002708 <sleep>
    if(log.committing){
    80004f98:	50dc                	lw	a5,36(s1)
    80004f9a:	fbed                	bnez	a5,80004f8c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004f9c:	5098                	lw	a4,32(s1)
    80004f9e:	2705                	addiw	a4,a4,1
    80004fa0:	0027179b          	slliw	a5,a4,0x2
    80004fa4:	9fb9                	addw	a5,a5,a4
    80004fa6:	0017979b          	slliw	a5,a5,0x1
    80004faa:	54d4                	lw	a3,44(s1)
    80004fac:	9fb5                	addw	a5,a5,a3
    80004fae:	00f95963          	bge	s2,a5,80004fc0 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004fb2:	85a6                	mv	a1,s1
    80004fb4:	8526                	mv	a0,s1
    80004fb6:	ffffd097          	auipc	ra,0xffffd
    80004fba:	752080e7          	jalr	1874(ra) # 80002708 <sleep>
    80004fbe:	bfe9                	j	80004f98 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004fc0:	0006b517          	auipc	a0,0x6b
    80004fc4:	26050513          	addi	a0,a0,608 # 80070220 <log>
    80004fc8:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	dfc080e7          	jalr	-516(ra) # 80000dc6 <release>
      break;
    }
  }
}
    80004fd2:	60e2                	ld	ra,24(sp)
    80004fd4:	6442                	ld	s0,16(sp)
    80004fd6:	64a2                	ld	s1,8(sp)
    80004fd8:	6902                	ld	s2,0(sp)
    80004fda:	6105                	addi	sp,sp,32
    80004fdc:	8082                	ret

0000000080004fde <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004fde:	7139                	addi	sp,sp,-64
    80004fe0:	fc06                	sd	ra,56(sp)
    80004fe2:	f822                	sd	s0,48(sp)
    80004fe4:	f426                	sd	s1,40(sp)
    80004fe6:	f04a                	sd	s2,32(sp)
    80004fe8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004fea:	0006b497          	auipc	s1,0x6b
    80004fee:	23648493          	addi	s1,s1,566 # 80070220 <log>
    80004ff2:	8526                	mv	a0,s1
    80004ff4:	ffffc097          	auipc	ra,0xffffc
    80004ff8:	d22080e7          	jalr	-734(ra) # 80000d16 <acquire>
  log.outstanding -= 1;
    80004ffc:	509c                	lw	a5,32(s1)
    80004ffe:	37fd                	addiw	a5,a5,-1
    80005000:	893e                	mv	s2,a5
    80005002:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80005004:	50dc                	lw	a5,36(s1)
    80005006:	e7b9                	bnez	a5,80005054 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    80005008:	06091263          	bnez	s2,8000506c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000500c:	0006b497          	auipc	s1,0x6b
    80005010:	21448493          	addi	s1,s1,532 # 80070220 <log>
    80005014:	4785                	li	a5,1
    80005016:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80005018:	8526                	mv	a0,s1
    8000501a:	ffffc097          	auipc	ra,0xffffc
    8000501e:	dac080e7          	jalr	-596(ra) # 80000dc6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80005022:	54dc                	lw	a5,44(s1)
    80005024:	06f04863          	bgtz	a5,80005094 <end_op+0xb6>
    acquire(&log.lock);
    80005028:	0006b497          	auipc	s1,0x6b
    8000502c:	1f848493          	addi	s1,s1,504 # 80070220 <log>
    80005030:	8526                	mv	a0,s1
    80005032:	ffffc097          	auipc	ra,0xffffc
    80005036:	ce4080e7          	jalr	-796(ra) # 80000d16 <acquire>
    log.committing = 0;
    8000503a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000503e:	8526                	mv	a0,s1
    80005040:	ffffd097          	auipc	ra,0xffffd
    80005044:	72c080e7          	jalr	1836(ra) # 8000276c <wakeup>
    release(&log.lock);
    80005048:	8526                	mv	a0,s1
    8000504a:	ffffc097          	auipc	ra,0xffffc
    8000504e:	d7c080e7          	jalr	-644(ra) # 80000dc6 <release>
}
    80005052:	a81d                	j	80005088 <end_op+0xaa>
    80005054:	ec4e                	sd	s3,24(sp)
    80005056:	e852                	sd	s4,16(sp)
    80005058:	e456                	sd	s5,8(sp)
    8000505a:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    8000505c:	00006517          	auipc	a0,0x6
    80005060:	55c50513          	addi	a0,a0,1372 # 8000b5b8 <etext+0x5b8>
    80005064:	ffffb097          	auipc	ra,0xffffb
    80005068:	4fc080e7          	jalr	1276(ra) # 80000560 <panic>
    wakeup(&log);
    8000506c:	0006b497          	auipc	s1,0x6b
    80005070:	1b448493          	addi	s1,s1,436 # 80070220 <log>
    80005074:	8526                	mv	a0,s1
    80005076:	ffffd097          	auipc	ra,0xffffd
    8000507a:	6f6080e7          	jalr	1782(ra) # 8000276c <wakeup>
  release(&log.lock);
    8000507e:	8526                	mv	a0,s1
    80005080:	ffffc097          	auipc	ra,0xffffc
    80005084:	d46080e7          	jalr	-698(ra) # 80000dc6 <release>
}
    80005088:	70e2                	ld	ra,56(sp)
    8000508a:	7442                	ld	s0,48(sp)
    8000508c:	74a2                	ld	s1,40(sp)
    8000508e:	7902                	ld	s2,32(sp)
    80005090:	6121                	addi	sp,sp,64
    80005092:	8082                	ret
    80005094:	ec4e                	sd	s3,24(sp)
    80005096:	e852                	sd	s4,16(sp)
    80005098:	e456                	sd	s5,8(sp)
    8000509a:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000509c:	0006ba97          	auipc	s5,0x6b
    800050a0:	1b4a8a93          	addi	s5,s5,436 # 80070250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800050a4:	0006ba17          	auipc	s4,0x6b
    800050a8:	17ca0a13          	addi	s4,s4,380 # 80070220 <log>
    memmove(to->data, from->data, BSIZE);
    800050ac:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800050b0:	018a2583          	lw	a1,24(s4)
    800050b4:	012585bb          	addw	a1,a1,s2
    800050b8:	2585                	addiw	a1,a1,1
    800050ba:	028a2503          	lw	a0,40(s4)
    800050be:	fffff097          	auipc	ra,0xfffff
    800050c2:	cae080e7          	jalr	-850(ra) # 80003d6c <bread>
    800050c6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800050c8:	000aa583          	lw	a1,0(s5)
    800050cc:	028a2503          	lw	a0,40(s4)
    800050d0:	fffff097          	auipc	ra,0xfffff
    800050d4:	c9c080e7          	jalr	-868(ra) # 80003d6c <bread>
    800050d8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800050da:	865a                	mv	a2,s6
    800050dc:	05850593          	addi	a1,a0,88
    800050e0:	05848513          	addi	a0,s1,88
    800050e4:	ffffc097          	auipc	ra,0xffffc
    800050e8:	d8e080e7          	jalr	-626(ra) # 80000e72 <memmove>
    bwrite(to);  // write the log
    800050ec:	8526                	mv	a0,s1
    800050ee:	fffff097          	auipc	ra,0xfffff
    800050f2:	d70080e7          	jalr	-656(ra) # 80003e5e <bwrite>
    brelse(from);
    800050f6:	854e                	mv	a0,s3
    800050f8:	fffff097          	auipc	ra,0xfffff
    800050fc:	da4080e7          	jalr	-604(ra) # 80003e9c <brelse>
    brelse(to);
    80005100:	8526                	mv	a0,s1
    80005102:	fffff097          	auipc	ra,0xfffff
    80005106:	d9a080e7          	jalr	-614(ra) # 80003e9c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000510a:	2905                	addiw	s2,s2,1
    8000510c:	0a91                	addi	s5,s5,4
    8000510e:	02ca2783          	lw	a5,44(s4)
    80005112:	f8f94fe3          	blt	s2,a5,800050b0 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80005116:	00000097          	auipc	ra,0x0
    8000511a:	c82080e7          	jalr	-894(ra) # 80004d98 <write_head>
    install_trans(0); // Now install writes to home locations
    8000511e:	4501                	li	a0,0
    80005120:	00000097          	auipc	ra,0x0
    80005124:	ce2080e7          	jalr	-798(ra) # 80004e02 <install_trans>
    log.lh.n = 0;
    80005128:	0006b797          	auipc	a5,0x6b
    8000512c:	1207a223          	sw	zero,292(a5) # 8007024c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80005130:	00000097          	auipc	ra,0x0
    80005134:	c68080e7          	jalr	-920(ra) # 80004d98 <write_head>
    80005138:	69e2                	ld	s3,24(sp)
    8000513a:	6a42                	ld	s4,16(sp)
    8000513c:	6aa2                	ld	s5,8(sp)
    8000513e:	6b02                	ld	s6,0(sp)
    80005140:	b5e5                	j	80005028 <end_op+0x4a>

0000000080005142 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80005142:	1101                	addi	sp,sp,-32
    80005144:	ec06                	sd	ra,24(sp)
    80005146:	e822                	sd	s0,16(sp)
    80005148:	e426                	sd	s1,8(sp)
    8000514a:	e04a                	sd	s2,0(sp)
    8000514c:	1000                	addi	s0,sp,32
    8000514e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80005150:	0006b917          	auipc	s2,0x6b
    80005154:	0d090913          	addi	s2,s2,208 # 80070220 <log>
    80005158:	854a                	mv	a0,s2
    8000515a:	ffffc097          	auipc	ra,0xffffc
    8000515e:	bbc080e7          	jalr	-1092(ra) # 80000d16 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80005162:	02c92603          	lw	a2,44(s2)
    80005166:	47f5                	li	a5,29
    80005168:	06c7c563          	blt	a5,a2,800051d2 <log_write+0x90>
    8000516c:	0006b797          	auipc	a5,0x6b
    80005170:	0d07a783          	lw	a5,208(a5) # 8007023c <log+0x1c>
    80005174:	37fd                	addiw	a5,a5,-1
    80005176:	04f65e63          	bge	a2,a5,800051d2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000517a:	0006b797          	auipc	a5,0x6b
    8000517e:	0c67a783          	lw	a5,198(a5) # 80070240 <log+0x20>
    80005182:	06f05063          	blez	a5,800051e2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80005186:	4781                	li	a5,0
    80005188:	06c05563          	blez	a2,800051f2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000518c:	44cc                	lw	a1,12(s1)
    8000518e:	0006b717          	auipc	a4,0x6b
    80005192:	0c270713          	addi	a4,a4,194 # 80070250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80005196:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005198:	4314                	lw	a3,0(a4)
    8000519a:	04b68c63          	beq	a3,a1,800051f2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000519e:	2785                	addiw	a5,a5,1
    800051a0:	0711                	addi	a4,a4,4
    800051a2:	fef61be3          	bne	a2,a5,80005198 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800051a6:	0621                	addi	a2,a2,8
    800051a8:	060a                	slli	a2,a2,0x2
    800051aa:	0006b797          	auipc	a5,0x6b
    800051ae:	07678793          	addi	a5,a5,118 # 80070220 <log>
    800051b2:	97b2                	add	a5,a5,a2
    800051b4:	44d8                	lw	a4,12(s1)
    800051b6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800051b8:	8526                	mv	a0,s1
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	d7a080e7          	jalr	-646(ra) # 80003f34 <bpin>
    log.lh.n++;
    800051c2:	0006b717          	auipc	a4,0x6b
    800051c6:	05e70713          	addi	a4,a4,94 # 80070220 <log>
    800051ca:	575c                	lw	a5,44(a4)
    800051cc:	2785                	addiw	a5,a5,1
    800051ce:	d75c                	sw	a5,44(a4)
    800051d0:	a82d                	j	8000520a <log_write+0xc8>
    panic("too big a transaction");
    800051d2:	00006517          	auipc	a0,0x6
    800051d6:	3f650513          	addi	a0,a0,1014 # 8000b5c8 <etext+0x5c8>
    800051da:	ffffb097          	auipc	ra,0xffffb
    800051de:	386080e7          	jalr	902(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    800051e2:	00006517          	auipc	a0,0x6
    800051e6:	3fe50513          	addi	a0,a0,1022 # 8000b5e0 <etext+0x5e0>
    800051ea:	ffffb097          	auipc	ra,0xffffb
    800051ee:	376080e7          	jalr	886(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    800051f2:	00878693          	addi	a3,a5,8
    800051f6:	068a                	slli	a3,a3,0x2
    800051f8:	0006b717          	auipc	a4,0x6b
    800051fc:	02870713          	addi	a4,a4,40 # 80070220 <log>
    80005200:	9736                	add	a4,a4,a3
    80005202:	44d4                	lw	a3,12(s1)
    80005204:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80005206:	faf609e3          	beq	a2,a5,800051b8 <log_write+0x76>
  }
  release(&log.lock);
    8000520a:	0006b517          	auipc	a0,0x6b
    8000520e:	01650513          	addi	a0,a0,22 # 80070220 <log>
    80005212:	ffffc097          	auipc	ra,0xffffc
    80005216:	bb4080e7          	jalr	-1100(ra) # 80000dc6 <release>
}
    8000521a:	60e2                	ld	ra,24(sp)
    8000521c:	6442                	ld	s0,16(sp)
    8000521e:	64a2                	ld	s1,8(sp)
    80005220:	6902                	ld	s2,0(sp)
    80005222:	6105                	addi	sp,sp,32
    80005224:	8082                	ret

0000000080005226 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80005226:	1101                	addi	sp,sp,-32
    80005228:	ec06                	sd	ra,24(sp)
    8000522a:	e822                	sd	s0,16(sp)
    8000522c:	e426                	sd	s1,8(sp)
    8000522e:	e04a                	sd	s2,0(sp)
    80005230:	1000                	addi	s0,sp,32
    80005232:	84aa                	mv	s1,a0
    80005234:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80005236:	00006597          	auipc	a1,0x6
    8000523a:	3ca58593          	addi	a1,a1,970 # 8000b600 <etext+0x600>
    8000523e:	0521                	addi	a0,a0,8
    80005240:	ffffc097          	auipc	ra,0xffffc
    80005244:	a42080e7          	jalr	-1470(ra) # 80000c82 <initlock>
  lk->name = name;
    80005248:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000524c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005250:	0204a423          	sw	zero,40(s1)
}
    80005254:	60e2                	ld	ra,24(sp)
    80005256:	6442                	ld	s0,16(sp)
    80005258:	64a2                	ld	s1,8(sp)
    8000525a:	6902                	ld	s2,0(sp)
    8000525c:	6105                	addi	sp,sp,32
    8000525e:	8082                	ret

0000000080005260 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80005260:	1101                	addi	sp,sp,-32
    80005262:	ec06                	sd	ra,24(sp)
    80005264:	e822                	sd	s0,16(sp)
    80005266:	e426                	sd	s1,8(sp)
    80005268:	e04a                	sd	s2,0(sp)
    8000526a:	1000                	addi	s0,sp,32
    8000526c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000526e:	00850913          	addi	s2,a0,8
    80005272:	854a                	mv	a0,s2
    80005274:	ffffc097          	auipc	ra,0xffffc
    80005278:	aa2080e7          	jalr	-1374(ra) # 80000d16 <acquire>
  while (lk->locked) {
    8000527c:	409c                	lw	a5,0(s1)
    8000527e:	cb89                	beqz	a5,80005290 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80005280:	85ca                	mv	a1,s2
    80005282:	8526                	mv	a0,s1
    80005284:	ffffd097          	auipc	ra,0xffffd
    80005288:	484080e7          	jalr	1156(ra) # 80002708 <sleep>
  while (lk->locked) {
    8000528c:	409c                	lw	a5,0(s1)
    8000528e:	fbed                	bnez	a5,80005280 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80005290:	4785                	li	a5,1
    80005292:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80005294:	ffffd097          	auipc	ra,0xffffd
    80005298:	bc6080e7          	jalr	-1082(ra) # 80001e5a <myproc>
    8000529c:	591c                	lw	a5,48(a0)
    8000529e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800052a0:	854a                	mv	a0,s2
    800052a2:	ffffc097          	auipc	ra,0xffffc
    800052a6:	b24080e7          	jalr	-1244(ra) # 80000dc6 <release>
}
    800052aa:	60e2                	ld	ra,24(sp)
    800052ac:	6442                	ld	s0,16(sp)
    800052ae:	64a2                	ld	s1,8(sp)
    800052b0:	6902                	ld	s2,0(sp)
    800052b2:	6105                	addi	sp,sp,32
    800052b4:	8082                	ret

00000000800052b6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800052b6:	1101                	addi	sp,sp,-32
    800052b8:	ec06                	sd	ra,24(sp)
    800052ba:	e822                	sd	s0,16(sp)
    800052bc:	e426                	sd	s1,8(sp)
    800052be:	e04a                	sd	s2,0(sp)
    800052c0:	1000                	addi	s0,sp,32
    800052c2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800052c4:	00850913          	addi	s2,a0,8
    800052c8:	854a                	mv	a0,s2
    800052ca:	ffffc097          	auipc	ra,0xffffc
    800052ce:	a4c080e7          	jalr	-1460(ra) # 80000d16 <acquire>
  lk->locked = 0;
    800052d2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800052d6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800052da:	8526                	mv	a0,s1
    800052dc:	ffffd097          	auipc	ra,0xffffd
    800052e0:	490080e7          	jalr	1168(ra) # 8000276c <wakeup>
  release(&lk->lk);
    800052e4:	854a                	mv	a0,s2
    800052e6:	ffffc097          	auipc	ra,0xffffc
    800052ea:	ae0080e7          	jalr	-1312(ra) # 80000dc6 <release>
}
    800052ee:	60e2                	ld	ra,24(sp)
    800052f0:	6442                	ld	s0,16(sp)
    800052f2:	64a2                	ld	s1,8(sp)
    800052f4:	6902                	ld	s2,0(sp)
    800052f6:	6105                	addi	sp,sp,32
    800052f8:	8082                	ret

00000000800052fa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800052fa:	7179                	addi	sp,sp,-48
    800052fc:	f406                	sd	ra,40(sp)
    800052fe:	f022                	sd	s0,32(sp)
    80005300:	ec26                	sd	s1,24(sp)
    80005302:	e84a                	sd	s2,16(sp)
    80005304:	1800                	addi	s0,sp,48
    80005306:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80005308:	00850913          	addi	s2,a0,8
    8000530c:	854a                	mv	a0,s2
    8000530e:	ffffc097          	auipc	ra,0xffffc
    80005312:	a08080e7          	jalr	-1528(ra) # 80000d16 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80005316:	409c                	lw	a5,0(s1)
    80005318:	ef91                	bnez	a5,80005334 <holdingsleep+0x3a>
    8000531a:	4481                	li	s1,0
  release(&lk->lk);
    8000531c:	854a                	mv	a0,s2
    8000531e:	ffffc097          	auipc	ra,0xffffc
    80005322:	aa8080e7          	jalr	-1368(ra) # 80000dc6 <release>
  return r;
}
    80005326:	8526                	mv	a0,s1
    80005328:	70a2                	ld	ra,40(sp)
    8000532a:	7402                	ld	s0,32(sp)
    8000532c:	64e2                	ld	s1,24(sp)
    8000532e:	6942                	ld	s2,16(sp)
    80005330:	6145                	addi	sp,sp,48
    80005332:	8082                	ret
    80005334:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80005336:	0284a983          	lw	s3,40(s1)
    8000533a:	ffffd097          	auipc	ra,0xffffd
    8000533e:	b20080e7          	jalr	-1248(ra) # 80001e5a <myproc>
    80005342:	5904                	lw	s1,48(a0)
    80005344:	413484b3          	sub	s1,s1,s3
    80005348:	0014b493          	seqz	s1,s1
    8000534c:	69a2                	ld	s3,8(sp)
    8000534e:	b7f9                	j	8000531c <holdingsleep+0x22>

0000000080005350 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005350:	1141                	addi	sp,sp,-16
    80005352:	e406                	sd	ra,8(sp)
    80005354:	e022                	sd	s0,0(sp)
    80005356:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005358:	00006597          	auipc	a1,0x6
    8000535c:	2b858593          	addi	a1,a1,696 # 8000b610 <etext+0x610>
    80005360:	0006b517          	auipc	a0,0x6b
    80005364:	00850513          	addi	a0,a0,8 # 80070368 <ftable>
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	91a080e7          	jalr	-1766(ra) # 80000c82 <initlock>
}
    80005370:	60a2                	ld	ra,8(sp)
    80005372:	6402                	ld	s0,0(sp)
    80005374:	0141                	addi	sp,sp,16
    80005376:	8082                	ret

0000000080005378 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005378:	1101                	addi	sp,sp,-32
    8000537a:	ec06                	sd	ra,24(sp)
    8000537c:	e822                	sd	s0,16(sp)
    8000537e:	e426                	sd	s1,8(sp)
    80005380:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005382:	0006b517          	auipc	a0,0x6b
    80005386:	fe650513          	addi	a0,a0,-26 # 80070368 <ftable>
    8000538a:	ffffc097          	auipc	ra,0xffffc
    8000538e:	98c080e7          	jalr	-1652(ra) # 80000d16 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005392:	0006b497          	auipc	s1,0x6b
    80005396:	fee48493          	addi	s1,s1,-18 # 80070380 <ftable+0x18>
    8000539a:	0006c717          	auipc	a4,0x6c
    8000539e:	2a670713          	addi	a4,a4,678 # 80071640 <disk>
    if(f->ref == 0){
    800053a2:	40dc                	lw	a5,4(s1)
    800053a4:	cf99                	beqz	a5,800053c2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800053a6:	03048493          	addi	s1,s1,48
    800053aa:	fee49ce3          	bne	s1,a4,800053a2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800053ae:	0006b517          	auipc	a0,0x6b
    800053b2:	fba50513          	addi	a0,a0,-70 # 80070368 <ftable>
    800053b6:	ffffc097          	auipc	ra,0xffffc
    800053ba:	a10080e7          	jalr	-1520(ra) # 80000dc6 <release>
  return 0;
    800053be:	4481                	li	s1,0
    800053c0:	a819                	j	800053d6 <filealloc+0x5e>
      f->ref = 1;
    800053c2:	4785                	li	a5,1
    800053c4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800053c6:	0006b517          	auipc	a0,0x6b
    800053ca:	fa250513          	addi	a0,a0,-94 # 80070368 <ftable>
    800053ce:	ffffc097          	auipc	ra,0xffffc
    800053d2:	9f8080e7          	jalr	-1544(ra) # 80000dc6 <release>
}
    800053d6:	8526                	mv	a0,s1
    800053d8:	60e2                	ld	ra,24(sp)
    800053da:	6442                	ld	s0,16(sp)
    800053dc:	64a2                	ld	s1,8(sp)
    800053de:	6105                	addi	sp,sp,32
    800053e0:	8082                	ret

00000000800053e2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800053e2:	1101                	addi	sp,sp,-32
    800053e4:	ec06                	sd	ra,24(sp)
    800053e6:	e822                	sd	s0,16(sp)
    800053e8:	e426                	sd	s1,8(sp)
    800053ea:	1000                	addi	s0,sp,32
    800053ec:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800053ee:	0006b517          	auipc	a0,0x6b
    800053f2:	f7a50513          	addi	a0,a0,-134 # 80070368 <ftable>
    800053f6:	ffffc097          	auipc	ra,0xffffc
    800053fa:	920080e7          	jalr	-1760(ra) # 80000d16 <acquire>
  if(f->ref < 1)
    800053fe:	40dc                	lw	a5,4(s1)
    80005400:	02f05263          	blez	a5,80005424 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80005404:	2785                	addiw	a5,a5,1
    80005406:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80005408:	0006b517          	auipc	a0,0x6b
    8000540c:	f6050513          	addi	a0,a0,-160 # 80070368 <ftable>
    80005410:	ffffc097          	auipc	ra,0xffffc
    80005414:	9b6080e7          	jalr	-1610(ra) # 80000dc6 <release>
  return f;
}
    80005418:	8526                	mv	a0,s1
    8000541a:	60e2                	ld	ra,24(sp)
    8000541c:	6442                	ld	s0,16(sp)
    8000541e:	64a2                	ld	s1,8(sp)
    80005420:	6105                	addi	sp,sp,32
    80005422:	8082                	ret
    panic("filedup");
    80005424:	00006517          	auipc	a0,0x6
    80005428:	1f450513          	addi	a0,a0,500 # 8000b618 <etext+0x618>
    8000542c:	ffffb097          	auipc	ra,0xffffb
    80005430:	134080e7          	jalr	308(ra) # 80000560 <panic>

0000000080005434 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005434:	7139                	addi	sp,sp,-64
    80005436:	fc06                	sd	ra,56(sp)
    80005438:	f822                	sd	s0,48(sp)
    8000543a:	f426                	sd	s1,40(sp)
    8000543c:	0080                	addi	s0,sp,64
    8000543e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005440:	0006b517          	auipc	a0,0x6b
    80005444:	f2850513          	addi	a0,a0,-216 # 80070368 <ftable>
    80005448:	ffffc097          	auipc	ra,0xffffc
    8000544c:	8ce080e7          	jalr	-1842(ra) # 80000d16 <acquire>
  if(f->ref < 1)
    80005450:	40dc                	lw	a5,4(s1)
    80005452:	06f05b63          	blez	a5,800054c8 <fileclose+0x94>
    panic("fileclose");
  if(--f->ref > 0){
    80005456:	37fd                	addiw	a5,a5,-1
    80005458:	c0dc                	sw	a5,4(s1)
    8000545a:	08f04363          	bgtz	a5,800054e0 <fileclose+0xac>
    8000545e:	f04a                	sd	s2,32(sp)
    80005460:	ec4e                	sd	s3,24(sp)
    80005462:	e852                	sd	s4,16(sp)
    80005464:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80005466:	0004a903          	lw	s2,0(s1)
    8000546a:	0094ca83          	lbu	s5,9(s1)
    8000546e:	0104ba03          	ld	s4,16(s1)
    80005472:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80005476:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000547a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000547e:	0006b517          	auipc	a0,0x6b
    80005482:	eea50513          	addi	a0,a0,-278 # 80070368 <ftable>
    80005486:	ffffc097          	auipc	ra,0xffffc
    8000548a:	940080e7          	jalr	-1728(ra) # 80000dc6 <release>

  switch (ff.type) {
    8000548e:	478d                	li	a5,3
    80005490:	0af90663          	beq	s2,a5,8000553c <fileclose+0x108>
    80005494:	0727e863          	bltu	a5,s2,80005504 <fileclose+0xd0>
    80005498:	4785                	li	a5,1
    8000549a:	08f90663          	beq	s2,a5,80005526 <fileclose+0xf2>
    8000549e:	4789                	li	a5,2
    800054a0:	04f91d63          	bne	s2,a5,800054fa <fileclose+0xc6>
  case FD_PIPE :
    pipeclose(ff.pipe, ff.writable);
    break;
  case FD_INODE:
    begin_op();
    800054a4:	00000097          	auipc	ra,0x0
    800054a8:	ac0080e7          	jalr	-1344(ra) # 80004f64 <begin_op>
    iput(ff.ip);
    800054ac:	854e                	mv	a0,s3
    800054ae:	fffff097          	auipc	ra,0xfffff
    800054b2:	28a080e7          	jalr	650(ra) # 80004738 <iput>
    end_op();
    800054b6:	00000097          	auipc	ra,0x0
    800054ba:	b28080e7          	jalr	-1240(ra) # 80004fde <end_op>
    break;
    800054be:	7902                	ld	s2,32(sp)
    800054c0:	69e2                	ld	s3,24(sp)
    800054c2:	6a42                	ld	s4,16(sp)
    800054c4:	6aa2                	ld	s5,8(sp)
    800054c6:	a02d                	j	800054f0 <fileclose+0xbc>
    800054c8:	f04a                	sd	s2,32(sp)
    800054ca:	ec4e                	sd	s3,24(sp)
    800054cc:	e852                	sd	s4,16(sp)
    800054ce:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800054d0:	00006517          	auipc	a0,0x6
    800054d4:	15050513          	addi	a0,a0,336 # 8000b620 <etext+0x620>
    800054d8:	ffffb097          	auipc	ra,0xffffb
    800054dc:	088080e7          	jalr	136(ra) # 80000560 <panic>
    release(&ftable.lock);
    800054e0:	0006b517          	auipc	a0,0x6b
    800054e4:	e8850513          	addi	a0,a0,-376 # 80070368 <ftable>
    800054e8:	ffffc097          	auipc	ra,0xffffc
    800054ec:	8de080e7          	jalr	-1826(ra) # 80000dc6 <release>
    end_op();
    break;
  case FD_SOCKET:
    f->sock->ops->close(f->sock);
  };
}
    800054f0:	70e2                	ld	ra,56(sp)
    800054f2:	7442                	ld	s0,48(sp)
    800054f4:	74a2                	ld	s1,40(sp)
    800054f6:	6121                	addi	sp,sp,64
    800054f8:	8082                	ret
    800054fa:	7902                	ld	s2,32(sp)
    800054fc:	69e2                	ld	s3,24(sp)
    800054fe:	6a42                	ld	s4,16(sp)
    80005500:	6aa2                	ld	s5,8(sp)
    80005502:	b7fd                	j	800054f0 <fileclose+0xbc>
  switch (ff.type) {
    80005504:	4791                	li	a5,4
    80005506:	00f91b63          	bne	s2,a5,8000551c <fileclose+0xe8>
    f->sock->ops->close(f->sock);
    8000550a:	7088                	ld	a0,32(s1)
    8000550c:	653c                	ld	a5,72(a0)
    8000550e:	7b9c                	ld	a5,48(a5)
    80005510:	9782                	jalr	a5
    80005512:	7902                	ld	s2,32(sp)
    80005514:	69e2                	ld	s3,24(sp)
    80005516:	6a42                	ld	s4,16(sp)
    80005518:	6aa2                	ld	s5,8(sp)
    8000551a:	bfd9                	j	800054f0 <fileclose+0xbc>
    8000551c:	7902                	ld	s2,32(sp)
    8000551e:	69e2                	ld	s3,24(sp)
    80005520:	6a42                	ld	s4,16(sp)
    80005522:	6aa2                	ld	s5,8(sp)
    80005524:	b7f1                	j	800054f0 <fileclose+0xbc>
    pipeclose(ff.pipe, ff.writable);
    80005526:	85d6                	mv	a1,s5
    80005528:	8552                	mv	a0,s4
    8000552a:	00000097          	auipc	ra,0x0
    8000552e:	3ac080e7          	jalr	940(ra) # 800058d6 <pipeclose>
    break;
    80005532:	7902                	ld	s2,32(sp)
    80005534:	69e2                	ld	s3,24(sp)
    80005536:	6a42                	ld	s4,16(sp)
    80005538:	6aa2                	ld	s5,8(sp)
    8000553a:	bf5d                	j	800054f0 <fileclose+0xbc>
    begin_op();
    8000553c:	00000097          	auipc	ra,0x0
    80005540:	a28080e7          	jalr	-1496(ra) # 80004f64 <begin_op>
    iput(ff.ip);
    80005544:	854e                	mv	a0,s3
    80005546:	fffff097          	auipc	ra,0xfffff
    8000554a:	1f2080e7          	jalr	498(ra) # 80004738 <iput>
    end_op();
    8000554e:	00000097          	auipc	ra,0x0
    80005552:	a90080e7          	jalr	-1392(ra) # 80004fde <end_op>
    break;
    80005556:	7902                	ld	s2,32(sp)
    80005558:	69e2                	ld	s3,24(sp)
    8000555a:	6a42                	ld	s4,16(sp)
    8000555c:	6aa2                	ld	s5,8(sp)
    8000555e:	bf49                	j	800054f0 <fileclose+0xbc>

0000000080005560 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005560:	715d                	addi	sp,sp,-80
    80005562:	e486                	sd	ra,72(sp)
    80005564:	e0a2                	sd	s0,64(sp)
    80005566:	fc26                	sd	s1,56(sp)
    80005568:	f44e                	sd	s3,40(sp)
    8000556a:	0880                	addi	s0,sp,80
    8000556c:	84aa                	mv	s1,a0
    8000556e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80005570:	ffffd097          	auipc	ra,0xffffd
    80005574:	8ea080e7          	jalr	-1814(ra) # 80001e5a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80005578:	409c                	lw	a5,0(s1)
    8000557a:	37f9                	addiw	a5,a5,-2
    8000557c:	4705                	li	a4,1
    8000557e:	04f76a63          	bltu	a4,a5,800055d2 <filestat+0x72>
    80005582:	f84a                	sd	s2,48(sp)
    80005584:	f052                	sd	s4,32(sp)
    80005586:	892a                	mv	s2,a0
    ilock(f->ip);
    80005588:	6c88                	ld	a0,24(s1)
    8000558a:	fffff097          	auipc	ra,0xfffff
    8000558e:	ff0080e7          	jalr	-16(ra) # 8000457a <ilock>
    stati(f->ip, &st);
    80005592:	fb840a13          	addi	s4,s0,-72
    80005596:	85d2                	mv	a1,s4
    80005598:	6c88                	ld	a0,24(s1)
    8000559a:	fffff097          	auipc	ra,0xfffff
    8000559e:	26e080e7          	jalr	622(ra) # 80004808 <stati>
    iunlock(f->ip);
    800055a2:	6c88                	ld	a0,24(s1)
    800055a4:	fffff097          	auipc	ra,0xfffff
    800055a8:	09c080e7          	jalr	156(ra) # 80004640 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800055ac:	46e1                	li	a3,24
    800055ae:	8652                	mv	a2,s4
    800055b0:	85ce                	mv	a1,s3
    800055b2:	05093503          	ld	a0,80(s2)
    800055b6:	ffffc097          	auipc	ra,0xffffc
    800055ba:	54c080e7          	jalr	1356(ra) # 80001b02 <copyout>
    800055be:	41f5551b          	sraiw	a0,a0,0x1f
    800055c2:	7942                	ld	s2,48(sp)
    800055c4:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800055c6:	60a6                	ld	ra,72(sp)
    800055c8:	6406                	ld	s0,64(sp)
    800055ca:	74e2                	ld	s1,56(sp)
    800055cc:	79a2                	ld	s3,40(sp)
    800055ce:	6161                	addi	sp,sp,80
    800055d0:	8082                	ret
  return -1;
    800055d2:	557d                	li	a0,-1
    800055d4:	bfcd                	j	800055c6 <filestat+0x66>

00000000800055d6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800055d6:	7179                	addi	sp,sp,-48
    800055d8:	f406                	sd	ra,40(sp)
    800055da:	f022                	sd	s0,32(sp)
    800055dc:	e84a                	sd	s2,16(sp)
    800055de:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800055e0:	00854783          	lbu	a5,8(a0)
    800055e4:	cbc5                	beqz	a5,80005694 <fileread+0xbe>
    800055e6:	ec26                	sd	s1,24(sp)
    800055e8:	e44e                	sd	s3,8(sp)
    800055ea:	84aa                	mv	s1,a0
    800055ec:	89ae                	mv	s3,a1
    800055ee:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800055f0:	411c                	lw	a5,0(a0)
    800055f2:	4705                	li	a4,1
    800055f4:	04e78963          	beq	a5,a4,80005646 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800055f8:	470d                	li	a4,3
    800055fa:	04e78f63          	beq	a5,a4,80005658 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800055fe:	4709                	li	a4,2
    80005600:	08e79263          	bne	a5,a4,80005684 <fileread+0xae>
    ilock(f->ip);
    80005604:	6d08                	ld	a0,24(a0)
    80005606:	fffff097          	auipc	ra,0xfffff
    8000560a:	f74080e7          	jalr	-140(ra) # 8000457a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000560e:	874a                	mv	a4,s2
    80005610:	5494                	lw	a3,40(s1)
    80005612:	864e                	mv	a2,s3
    80005614:	4585                	li	a1,1
    80005616:	6c88                	ld	a0,24(s1)
    80005618:	fffff097          	auipc	ra,0xfffff
    8000561c:	21e080e7          	jalr	542(ra) # 80004836 <readi>
    80005620:	892a                	mv	s2,a0
    80005622:	00a05563          	blez	a0,8000562c <fileread+0x56>
      f->off += r;
    80005626:	549c                	lw	a5,40(s1)
    80005628:	9fa9                	addw	a5,a5,a0
    8000562a:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    8000562c:	6c88                	ld	a0,24(s1)
    8000562e:	fffff097          	auipc	ra,0xfffff
    80005632:	012080e7          	jalr	18(ra) # 80004640 <iunlock>
    80005636:	64e2                	ld	s1,24(sp)
    80005638:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000563a:	854a                	mv	a0,s2
    8000563c:	70a2                	ld	ra,40(sp)
    8000563e:	7402                	ld	s0,32(sp)
    80005640:	6942                	ld	s2,16(sp)
    80005642:	6145                	addi	sp,sp,48
    80005644:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005646:	6908                	ld	a0,16(a0)
    80005648:	00000097          	auipc	ra,0x0
    8000564c:	41a080e7          	jalr	1050(ra) # 80005a62 <piperead>
    80005650:	892a                	mv	s2,a0
    80005652:	64e2                	ld	s1,24(sp)
    80005654:	69a2                	ld	s3,8(sp)
    80005656:	b7d5                	j	8000563a <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80005658:	02c51783          	lh	a5,44(a0)
    8000565c:	03079693          	slli	a3,a5,0x30
    80005660:	92c1                	srli	a3,a3,0x30
    80005662:	4725                	li	a4,9
    80005664:	02d76a63          	bltu	a4,a3,80005698 <fileread+0xc2>
    80005668:	0792                	slli	a5,a5,0x4
    8000566a:	0006b717          	auipc	a4,0x6b
    8000566e:	c5e70713          	addi	a4,a4,-930 # 800702c8 <devsw>
    80005672:	97ba                	add	a5,a5,a4
    80005674:	639c                	ld	a5,0(a5)
    80005676:	c78d                	beqz	a5,800056a0 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80005678:	4505                	li	a0,1
    8000567a:	9782                	jalr	a5
    8000567c:	892a                	mv	s2,a0
    8000567e:	64e2                	ld	s1,24(sp)
    80005680:	69a2                	ld	s3,8(sp)
    80005682:	bf65                	j	8000563a <fileread+0x64>
    panic("fileread");
    80005684:	00006517          	auipc	a0,0x6
    80005688:	fac50513          	addi	a0,a0,-84 # 8000b630 <etext+0x630>
    8000568c:	ffffb097          	auipc	ra,0xffffb
    80005690:	ed4080e7          	jalr	-300(ra) # 80000560 <panic>
    return -1;
    80005694:	597d                	li	s2,-1
    80005696:	b755                	j	8000563a <fileread+0x64>
      return -1;
    80005698:	597d                	li	s2,-1
    8000569a:	64e2                	ld	s1,24(sp)
    8000569c:	69a2                	ld	s3,8(sp)
    8000569e:	bf71                	j	8000563a <fileread+0x64>
    800056a0:	597d                	li	s2,-1
    800056a2:	64e2                	ld	s1,24(sp)
    800056a4:	69a2                	ld	s3,8(sp)
    800056a6:	bf51                	j	8000563a <fileread+0x64>

00000000800056a8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800056a8:	00954783          	lbu	a5,9(a0)
    800056ac:	12078c63          	beqz	a5,800057e4 <filewrite+0x13c>
{
    800056b0:	711d                	addi	sp,sp,-96
    800056b2:	ec86                	sd	ra,88(sp)
    800056b4:	e8a2                	sd	s0,80(sp)
    800056b6:	e0ca                	sd	s2,64(sp)
    800056b8:	f456                	sd	s5,40(sp)
    800056ba:	f05a                	sd	s6,32(sp)
    800056bc:	1080                	addi	s0,sp,96
    800056be:	892a                	mv	s2,a0
    800056c0:	8b2e                	mv	s6,a1
    800056c2:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800056c4:	411c                	lw	a5,0(a0)
    800056c6:	4705                	li	a4,1
    800056c8:	02e78963          	beq	a5,a4,800056fa <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800056cc:	470d                	li	a4,3
    800056ce:	02e78c63          	beq	a5,a4,80005706 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800056d2:	4709                	li	a4,2
    800056d4:	0ee79a63          	bne	a5,a4,800057c8 <filewrite+0x120>
    800056d8:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800056da:	0cc05563          	blez	a2,800057a4 <filewrite+0xfc>
    800056de:	e4a6                	sd	s1,72(sp)
    800056e0:	fc4e                	sd	s3,56(sp)
    800056e2:	ec5e                	sd	s7,24(sp)
    800056e4:	e862                	sd	s8,16(sp)
    800056e6:	e466                	sd	s9,8(sp)
    int i = 0;
    800056e8:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800056ea:	6b85                	lui	s7,0x1
    800056ec:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800056f0:	6c85                	lui	s9,0x1
    800056f2:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800056f6:	4c05                	li	s8,1
    800056f8:	a849                	j	8000578a <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    800056fa:	6908                	ld	a0,16(a0)
    800056fc:	00000097          	auipc	ra,0x0
    80005700:	24a080e7          	jalr	586(ra) # 80005946 <pipewrite>
    80005704:	a85d                	j	800057ba <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005706:	02c51783          	lh	a5,44(a0)
    8000570a:	03079693          	slli	a3,a5,0x30
    8000570e:	92c1                	srli	a3,a3,0x30
    80005710:	4725                	li	a4,9
    80005712:	0cd76b63          	bltu	a4,a3,800057e8 <filewrite+0x140>
    80005716:	0792                	slli	a5,a5,0x4
    80005718:	0006b717          	auipc	a4,0x6b
    8000571c:	bb070713          	addi	a4,a4,-1104 # 800702c8 <devsw>
    80005720:	97ba                	add	a5,a5,a4
    80005722:	679c                	ld	a5,8(a5)
    80005724:	c7e1                	beqz	a5,800057ec <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80005726:	4505                	li	a0,1
    80005728:	9782                	jalr	a5
    8000572a:	a841                	j	800057ba <filewrite+0x112>
      if(n1 > max)
    8000572c:	2981                	sext.w	s3,s3
      begin_op();
    8000572e:	00000097          	auipc	ra,0x0
    80005732:	836080e7          	jalr	-1994(ra) # 80004f64 <begin_op>
      ilock(f->ip);
    80005736:	01893503          	ld	a0,24(s2)
    8000573a:	fffff097          	auipc	ra,0xfffff
    8000573e:	e40080e7          	jalr	-448(ra) # 8000457a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005742:	874e                	mv	a4,s3
    80005744:	02892683          	lw	a3,40(s2)
    80005748:	016a0633          	add	a2,s4,s6
    8000574c:	85e2                	mv	a1,s8
    8000574e:	01893503          	ld	a0,24(s2)
    80005752:	fffff097          	auipc	ra,0xfffff
    80005756:	1ea080e7          	jalr	490(ra) # 8000493c <writei>
    8000575a:	84aa                	mv	s1,a0
    8000575c:	00a05763          	blez	a0,8000576a <filewrite+0xc2>
        f->off += r;
    80005760:	02892783          	lw	a5,40(s2)
    80005764:	9fa9                	addw	a5,a5,a0
    80005766:	02f92423          	sw	a5,40(s2)
      iunlock(f->ip);
    8000576a:	01893503          	ld	a0,24(s2)
    8000576e:	fffff097          	auipc	ra,0xfffff
    80005772:	ed2080e7          	jalr	-302(ra) # 80004640 <iunlock>
      end_op();
    80005776:	00000097          	auipc	ra,0x0
    8000577a:	868080e7          	jalr	-1944(ra) # 80004fde <end_op>

      if(r != n1){
    8000577e:	02999563          	bne	s3,s1,800057a8 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80005782:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80005786:	015a5963          	bge	s4,s5,80005798 <filewrite+0xf0>
      int n1 = n - i;
    8000578a:	414a87bb          	subw	a5,s5,s4
    8000578e:	89be                	mv	s3,a5
      if(n1 > max)
    80005790:	f8fbdee3          	bge	s7,a5,8000572c <filewrite+0x84>
    80005794:	89e6                	mv	s3,s9
    80005796:	bf59                	j	8000572c <filewrite+0x84>
    80005798:	64a6                	ld	s1,72(sp)
    8000579a:	79e2                	ld	s3,56(sp)
    8000579c:	6be2                	ld	s7,24(sp)
    8000579e:	6c42                	ld	s8,16(sp)
    800057a0:	6ca2                	ld	s9,8(sp)
    800057a2:	a801                	j	800057b2 <filewrite+0x10a>
    int i = 0;
    800057a4:	4a01                	li	s4,0
    800057a6:	a031                	j	800057b2 <filewrite+0x10a>
    800057a8:	64a6                	ld	s1,72(sp)
    800057aa:	79e2                	ld	s3,56(sp)
    800057ac:	6be2                	ld	s7,24(sp)
    800057ae:	6c42                	ld	s8,16(sp)
    800057b0:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800057b2:	034a9f63          	bne	s5,s4,800057f0 <filewrite+0x148>
    800057b6:	8556                	mv	a0,s5
    800057b8:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800057ba:	60e6                	ld	ra,88(sp)
    800057bc:	6446                	ld	s0,80(sp)
    800057be:	6906                	ld	s2,64(sp)
    800057c0:	7aa2                	ld	s5,40(sp)
    800057c2:	7b02                	ld	s6,32(sp)
    800057c4:	6125                	addi	sp,sp,96
    800057c6:	8082                	ret
    800057c8:	e4a6                	sd	s1,72(sp)
    800057ca:	fc4e                	sd	s3,56(sp)
    800057cc:	f852                	sd	s4,48(sp)
    800057ce:	ec5e                	sd	s7,24(sp)
    800057d0:	e862                	sd	s8,16(sp)
    800057d2:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800057d4:	00006517          	auipc	a0,0x6
    800057d8:	e6c50513          	addi	a0,a0,-404 # 8000b640 <etext+0x640>
    800057dc:	ffffb097          	auipc	ra,0xffffb
    800057e0:	d84080e7          	jalr	-636(ra) # 80000560 <panic>
    return -1;
    800057e4:	557d                	li	a0,-1
}
    800057e6:	8082                	ret
      return -1;
    800057e8:	557d                	li	a0,-1
    800057ea:	bfc1                	j	800057ba <filewrite+0x112>
    800057ec:	557d                	li	a0,-1
    800057ee:	b7f1                	j	800057ba <filewrite+0x112>
    ret = (i == n ? n : -1);
    800057f0:	557d                	li	a0,-1
    800057f2:	7a42                	ld	s4,48(sp)
    800057f4:	b7d9                	j	800057ba <filewrite+0x112>

00000000800057f6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800057f6:	7179                	addi	sp,sp,-48
    800057f8:	f406                	sd	ra,40(sp)
    800057fa:	f022                	sd	s0,32(sp)
    800057fc:	ec26                	sd	s1,24(sp)
    800057fe:	e052                	sd	s4,0(sp)
    80005800:	1800                	addi	s0,sp,48
    80005802:	84aa                	mv	s1,a0
    80005804:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005806:	0005b023          	sd	zero,0(a1)
    8000580a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000580e:	00000097          	auipc	ra,0x0
    80005812:	b6a080e7          	jalr	-1174(ra) # 80005378 <filealloc>
    80005816:	e088                	sd	a0,0(s1)
    80005818:	cd49                	beqz	a0,800058b2 <pipealloc+0xbc>
    8000581a:	00000097          	auipc	ra,0x0
    8000581e:	b5e080e7          	jalr	-1186(ra) # 80005378 <filealloc>
    80005822:	00aa3023          	sd	a0,0(s4)
    80005826:	c141                	beqz	a0,800058a6 <pipealloc+0xb0>
    80005828:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000582a:	ffffb097          	auipc	ra,0xffffb
    8000582e:	3da080e7          	jalr	986(ra) # 80000c04 <kalloc>
    80005832:	892a                	mv	s2,a0
    80005834:	c13d                	beqz	a0,8000589a <pipealloc+0xa4>
    80005836:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80005838:	4985                	li	s3,1
    8000583a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000583e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005842:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005846:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000584a:	00006597          	auipc	a1,0x6
    8000584e:	e0658593          	addi	a1,a1,-506 # 8000b650 <etext+0x650>
    80005852:	ffffb097          	auipc	ra,0xffffb
    80005856:	430080e7          	jalr	1072(ra) # 80000c82 <initlock>
  (*f0)->type = FD_PIPE;
    8000585a:	609c                	ld	a5,0(s1)
    8000585c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80005860:	609c                	ld	a5,0(s1)
    80005862:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005866:	609c                	ld	a5,0(s1)
    80005868:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000586c:	609c                	ld	a5,0(s1)
    8000586e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005872:	000a3783          	ld	a5,0(s4)
    80005876:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000587a:	000a3783          	ld	a5,0(s4)
    8000587e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005882:	000a3783          	ld	a5,0(s4)
    80005886:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000588a:	000a3783          	ld	a5,0(s4)
    8000588e:	0127b823          	sd	s2,16(a5)
  return 0;
    80005892:	4501                	li	a0,0
    80005894:	6942                	ld	s2,16(sp)
    80005896:	69a2                	ld	s3,8(sp)
    80005898:	a03d                	j	800058c6 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000589a:	6088                	ld	a0,0(s1)
    8000589c:	c119                	beqz	a0,800058a2 <pipealloc+0xac>
    8000589e:	6942                	ld	s2,16(sp)
    800058a0:	a029                	j	800058aa <pipealloc+0xb4>
    800058a2:	6942                	ld	s2,16(sp)
    800058a4:	a039                	j	800058b2 <pipealloc+0xbc>
    800058a6:	6088                	ld	a0,0(s1)
    800058a8:	c50d                	beqz	a0,800058d2 <pipealloc+0xdc>
    fileclose(*f0);
    800058aa:	00000097          	auipc	ra,0x0
    800058ae:	b8a080e7          	jalr	-1142(ra) # 80005434 <fileclose>
  if(*f1)
    800058b2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800058b6:	557d                	li	a0,-1
  if(*f1)
    800058b8:	c799                	beqz	a5,800058c6 <pipealloc+0xd0>
    fileclose(*f1);
    800058ba:	853e                	mv	a0,a5
    800058bc:	00000097          	auipc	ra,0x0
    800058c0:	b78080e7          	jalr	-1160(ra) # 80005434 <fileclose>
  return -1;
    800058c4:	557d                	li	a0,-1
}
    800058c6:	70a2                	ld	ra,40(sp)
    800058c8:	7402                	ld	s0,32(sp)
    800058ca:	64e2                	ld	s1,24(sp)
    800058cc:	6a02                	ld	s4,0(sp)
    800058ce:	6145                	addi	sp,sp,48
    800058d0:	8082                	ret
  return -1;
    800058d2:	557d                	li	a0,-1
    800058d4:	bfcd                	j	800058c6 <pipealloc+0xd0>

00000000800058d6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800058d6:	1101                	addi	sp,sp,-32
    800058d8:	ec06                	sd	ra,24(sp)
    800058da:	e822                	sd	s0,16(sp)
    800058dc:	e426                	sd	s1,8(sp)
    800058de:	e04a                	sd	s2,0(sp)
    800058e0:	1000                	addi	s0,sp,32
    800058e2:	84aa                	mv	s1,a0
    800058e4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800058e6:	ffffb097          	auipc	ra,0xffffb
    800058ea:	430080e7          	jalr	1072(ra) # 80000d16 <acquire>
  if(writable){
    800058ee:	02090d63          	beqz	s2,80005928 <pipeclose+0x52>
    pi->writeopen = 0;
    800058f2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800058f6:	21848513          	addi	a0,s1,536
    800058fa:	ffffd097          	auipc	ra,0xffffd
    800058fe:	e72080e7          	jalr	-398(ra) # 8000276c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005902:	2204b783          	ld	a5,544(s1)
    80005906:	eb95                	bnez	a5,8000593a <pipeclose+0x64>
    release(&pi->lock);
    80005908:	8526                	mv	a0,s1
    8000590a:	ffffb097          	auipc	ra,0xffffb
    8000590e:	4bc080e7          	jalr	1212(ra) # 80000dc6 <release>
    kfree((char*)pi);
    80005912:	8526                	mv	a0,s1
    80005914:	ffffb097          	auipc	ra,0xffffb
    80005918:	188080e7          	jalr	392(ra) # 80000a9c <kfree>
  } else
    release(&pi->lock);
}
    8000591c:	60e2                	ld	ra,24(sp)
    8000591e:	6442                	ld	s0,16(sp)
    80005920:	64a2                	ld	s1,8(sp)
    80005922:	6902                	ld	s2,0(sp)
    80005924:	6105                	addi	sp,sp,32
    80005926:	8082                	ret
    pi->readopen = 0;
    80005928:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000592c:	21c48513          	addi	a0,s1,540
    80005930:	ffffd097          	auipc	ra,0xffffd
    80005934:	e3c080e7          	jalr	-452(ra) # 8000276c <wakeup>
    80005938:	b7e9                	j	80005902 <pipeclose+0x2c>
    release(&pi->lock);
    8000593a:	8526                	mv	a0,s1
    8000593c:	ffffb097          	auipc	ra,0xffffb
    80005940:	48a080e7          	jalr	1162(ra) # 80000dc6 <release>
}
    80005944:	bfe1                	j	8000591c <pipeclose+0x46>

0000000080005946 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005946:	7159                	addi	sp,sp,-112
    80005948:	f486                	sd	ra,104(sp)
    8000594a:	f0a2                	sd	s0,96(sp)
    8000594c:	eca6                	sd	s1,88(sp)
    8000594e:	e8ca                	sd	s2,80(sp)
    80005950:	e4ce                	sd	s3,72(sp)
    80005952:	e0d2                	sd	s4,64(sp)
    80005954:	fc56                	sd	s5,56(sp)
    80005956:	1880                	addi	s0,sp,112
    80005958:	84aa                	mv	s1,a0
    8000595a:	8aae                	mv	s5,a1
    8000595c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000595e:	ffffc097          	auipc	ra,0xffffc
    80005962:	4fc080e7          	jalr	1276(ra) # 80001e5a <myproc>
    80005966:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005968:	8526                	mv	a0,s1
    8000596a:	ffffb097          	auipc	ra,0xffffb
    8000596e:	3ac080e7          	jalr	940(ra) # 80000d16 <acquire>
  while(i < n){
    80005972:	0f405063          	blez	s4,80005a52 <pipewrite+0x10c>
    80005976:	f85a                	sd	s6,48(sp)
    80005978:	f45e                	sd	s7,40(sp)
    8000597a:	f062                	sd	s8,32(sp)
    8000597c:	ec66                	sd	s9,24(sp)
    8000597e:	e86a                	sd	s10,16(sp)
  int i = 0;
    80005980:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005982:	f9f40c13          	addi	s8,s0,-97
    80005986:	4b85                	li	s7,1
    80005988:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000598a:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000598e:	21c48c93          	addi	s9,s1,540
    80005992:	a099                	j	800059d8 <pipewrite+0x92>
      release(&pi->lock);
    80005994:	8526                	mv	a0,s1
    80005996:	ffffb097          	auipc	ra,0xffffb
    8000599a:	430080e7          	jalr	1072(ra) # 80000dc6 <release>
      return -1;
    8000599e:	597d                	li	s2,-1
    800059a0:	7b42                	ld	s6,48(sp)
    800059a2:	7ba2                	ld	s7,40(sp)
    800059a4:	7c02                	ld	s8,32(sp)
    800059a6:	6ce2                	ld	s9,24(sp)
    800059a8:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800059aa:	854a                	mv	a0,s2
    800059ac:	70a6                	ld	ra,104(sp)
    800059ae:	7406                	ld	s0,96(sp)
    800059b0:	64e6                	ld	s1,88(sp)
    800059b2:	6946                	ld	s2,80(sp)
    800059b4:	69a6                	ld	s3,72(sp)
    800059b6:	6a06                	ld	s4,64(sp)
    800059b8:	7ae2                	ld	s5,56(sp)
    800059ba:	6165                	addi	sp,sp,112
    800059bc:	8082                	ret
      wakeup(&pi->nread);
    800059be:	856a                	mv	a0,s10
    800059c0:	ffffd097          	auipc	ra,0xffffd
    800059c4:	dac080e7          	jalr	-596(ra) # 8000276c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800059c8:	85a6                	mv	a1,s1
    800059ca:	8566                	mv	a0,s9
    800059cc:	ffffd097          	auipc	ra,0xffffd
    800059d0:	d3c080e7          	jalr	-708(ra) # 80002708 <sleep>
  while(i < n){
    800059d4:	05495e63          	bge	s2,s4,80005a30 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    800059d8:	2204a783          	lw	a5,544(s1)
    800059dc:	dfc5                	beqz	a5,80005994 <pipewrite+0x4e>
    800059de:	854e                	mv	a0,s3
    800059e0:	ffffd097          	auipc	ra,0xffffd
    800059e4:	14e080e7          	jalr	334(ra) # 80002b2e <killed>
    800059e8:	f555                	bnez	a0,80005994 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800059ea:	2184a783          	lw	a5,536(s1)
    800059ee:	21c4a703          	lw	a4,540(s1)
    800059f2:	2007879b          	addiw	a5,a5,512
    800059f6:	fcf704e3          	beq	a4,a5,800059be <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800059fa:	86de                	mv	a3,s7
    800059fc:	01590633          	add	a2,s2,s5
    80005a00:	85e2                	mv	a1,s8
    80005a02:	0509b503          	ld	a0,80(s3)
    80005a06:	ffffc097          	auipc	ra,0xffffc
    80005a0a:	188080e7          	jalr	392(ra) # 80001b8e <copyin>
    80005a0e:	05650463          	beq	a0,s6,80005a56 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005a12:	21c4a783          	lw	a5,540(s1)
    80005a16:	0017871b          	addiw	a4,a5,1
    80005a1a:	20e4ae23          	sw	a4,540(s1)
    80005a1e:	1ff7f793          	andi	a5,a5,511
    80005a22:	97a6                	add	a5,a5,s1
    80005a24:	f9f44703          	lbu	a4,-97(s0)
    80005a28:	00e78c23          	sb	a4,24(a5)
      i++;
    80005a2c:	2905                	addiw	s2,s2,1
    80005a2e:	b75d                	j	800059d4 <pipewrite+0x8e>
    80005a30:	7b42                	ld	s6,48(sp)
    80005a32:	7ba2                	ld	s7,40(sp)
    80005a34:	7c02                	ld	s8,32(sp)
    80005a36:	6ce2                	ld	s9,24(sp)
    80005a38:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80005a3a:	21848513          	addi	a0,s1,536
    80005a3e:	ffffd097          	auipc	ra,0xffffd
    80005a42:	d2e080e7          	jalr	-722(ra) # 8000276c <wakeup>
  release(&pi->lock);
    80005a46:	8526                	mv	a0,s1
    80005a48:	ffffb097          	auipc	ra,0xffffb
    80005a4c:	37e080e7          	jalr	894(ra) # 80000dc6 <release>
  return i;
    80005a50:	bfa9                	j	800059aa <pipewrite+0x64>
  int i = 0;
    80005a52:	4901                	li	s2,0
    80005a54:	b7dd                	j	80005a3a <pipewrite+0xf4>
    80005a56:	7b42                	ld	s6,48(sp)
    80005a58:	7ba2                	ld	s7,40(sp)
    80005a5a:	7c02                	ld	s8,32(sp)
    80005a5c:	6ce2                	ld	s9,24(sp)
    80005a5e:	6d42                	ld	s10,16(sp)
    80005a60:	bfe9                	j	80005a3a <pipewrite+0xf4>

0000000080005a62 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005a62:	711d                	addi	sp,sp,-96
    80005a64:	ec86                	sd	ra,88(sp)
    80005a66:	e8a2                	sd	s0,80(sp)
    80005a68:	e4a6                	sd	s1,72(sp)
    80005a6a:	e0ca                	sd	s2,64(sp)
    80005a6c:	fc4e                	sd	s3,56(sp)
    80005a6e:	f852                	sd	s4,48(sp)
    80005a70:	f456                	sd	s5,40(sp)
    80005a72:	1080                	addi	s0,sp,96
    80005a74:	84aa                	mv	s1,a0
    80005a76:	892e                	mv	s2,a1
    80005a78:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005a7a:	ffffc097          	auipc	ra,0xffffc
    80005a7e:	3e0080e7          	jalr	992(ra) # 80001e5a <myproc>
    80005a82:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005a84:	8526                	mv	a0,s1
    80005a86:	ffffb097          	auipc	ra,0xffffb
    80005a8a:	290080e7          	jalr	656(ra) # 80000d16 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005a8e:	2184a703          	lw	a4,536(s1)
    80005a92:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005a96:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005a9a:	02f71b63          	bne	a4,a5,80005ad0 <piperead+0x6e>
    80005a9e:	2244a783          	lw	a5,548(s1)
    80005aa2:	c3b1                	beqz	a5,80005ae6 <piperead+0x84>
    if(killed(pr)){
    80005aa4:	8552                	mv	a0,s4
    80005aa6:	ffffd097          	auipc	ra,0xffffd
    80005aaa:	088080e7          	jalr	136(ra) # 80002b2e <killed>
    80005aae:	e50d                	bnez	a0,80005ad8 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005ab0:	85a6                	mv	a1,s1
    80005ab2:	854e                	mv	a0,s3
    80005ab4:	ffffd097          	auipc	ra,0xffffd
    80005ab8:	c54080e7          	jalr	-940(ra) # 80002708 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005abc:	2184a703          	lw	a4,536(s1)
    80005ac0:	21c4a783          	lw	a5,540(s1)
    80005ac4:	fcf70de3          	beq	a4,a5,80005a9e <piperead+0x3c>
    80005ac8:	f05a                	sd	s6,32(sp)
    80005aca:	ec5e                	sd	s7,24(sp)
    80005acc:	e862                	sd	s8,16(sp)
    80005ace:	a839                	j	80005aec <piperead+0x8a>
    80005ad0:	f05a                	sd	s6,32(sp)
    80005ad2:	ec5e                	sd	s7,24(sp)
    80005ad4:	e862                	sd	s8,16(sp)
    80005ad6:	a819                	j	80005aec <piperead+0x8a>
      release(&pi->lock);
    80005ad8:	8526                	mv	a0,s1
    80005ada:	ffffb097          	auipc	ra,0xffffb
    80005ade:	2ec080e7          	jalr	748(ra) # 80000dc6 <release>
      return -1;
    80005ae2:	59fd                	li	s3,-1
    80005ae4:	a895                	j	80005b58 <piperead+0xf6>
    80005ae6:	f05a                	sd	s6,32(sp)
    80005ae8:	ec5e                	sd	s7,24(sp)
    80005aea:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005aec:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005aee:	faf40c13          	addi	s8,s0,-81
    80005af2:	4b85                	li	s7,1
    80005af4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005af6:	05505363          	blez	s5,80005b3c <piperead+0xda>
    if(pi->nread == pi->nwrite)
    80005afa:	2184a783          	lw	a5,536(s1)
    80005afe:	21c4a703          	lw	a4,540(s1)
    80005b02:	02f70d63          	beq	a4,a5,80005b3c <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005b06:	0017871b          	addiw	a4,a5,1
    80005b0a:	20e4ac23          	sw	a4,536(s1)
    80005b0e:	1ff7f793          	andi	a5,a5,511
    80005b12:	97a6                	add	a5,a5,s1
    80005b14:	0187c783          	lbu	a5,24(a5)
    80005b18:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005b1c:	86de                	mv	a3,s7
    80005b1e:	8662                	mv	a2,s8
    80005b20:	85ca                	mv	a1,s2
    80005b22:	050a3503          	ld	a0,80(s4)
    80005b26:	ffffc097          	auipc	ra,0xffffc
    80005b2a:	fdc080e7          	jalr	-36(ra) # 80001b02 <copyout>
    80005b2e:	01650763          	beq	a0,s6,80005b3c <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005b32:	2985                	addiw	s3,s3,1
    80005b34:	0905                	addi	s2,s2,1
    80005b36:	fd3a92e3          	bne	s5,s3,80005afa <piperead+0x98>
    80005b3a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005b3c:	21c48513          	addi	a0,s1,540
    80005b40:	ffffd097          	auipc	ra,0xffffd
    80005b44:	c2c080e7          	jalr	-980(ra) # 8000276c <wakeup>
  release(&pi->lock);
    80005b48:	8526                	mv	a0,s1
    80005b4a:	ffffb097          	auipc	ra,0xffffb
    80005b4e:	27c080e7          	jalr	636(ra) # 80000dc6 <release>
    80005b52:	7b02                	ld	s6,32(sp)
    80005b54:	6be2                	ld	s7,24(sp)
    80005b56:	6c42                	ld	s8,16(sp)
  return i;
}
    80005b58:	854e                	mv	a0,s3
    80005b5a:	60e6                	ld	ra,88(sp)
    80005b5c:	6446                	ld	s0,80(sp)
    80005b5e:	64a6                	ld	s1,72(sp)
    80005b60:	6906                	ld	s2,64(sp)
    80005b62:	79e2                	ld	s3,56(sp)
    80005b64:	7a42                	ld	s4,48(sp)
    80005b66:	7aa2                	ld	s5,40(sp)
    80005b68:	6125                	addi	sp,sp,96
    80005b6a:	8082                	ret

0000000080005b6c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005b6c:	1141                	addi	sp,sp,-16
    80005b6e:	e406                	sd	ra,8(sp)
    80005b70:	e022                	sd	s0,0(sp)
    80005b72:	0800                	addi	s0,sp,16
    80005b74:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005b76:	0035151b          	slliw	a0,a0,0x3
    80005b7a:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80005b7c:	8b89                	andi	a5,a5,2
    80005b7e:	c399                	beqz	a5,80005b84 <flags2perm+0x18>
      perm |= PTE_W;
    80005b80:	00456513          	ori	a0,a0,4
    return perm;
}
    80005b84:	60a2                	ld	ra,8(sp)
    80005b86:	6402                	ld	s0,0(sp)
    80005b88:	0141                	addi	sp,sp,16
    80005b8a:	8082                	ret

0000000080005b8c <exec>:

int
exec(char *path, char **argv)
{
    80005b8c:	de010113          	addi	sp,sp,-544
    80005b90:	20113c23          	sd	ra,536(sp)
    80005b94:	20813823          	sd	s0,528(sp)
    80005b98:	20913423          	sd	s1,520(sp)
    80005b9c:	21213023          	sd	s2,512(sp)
    80005ba0:	1400                	addi	s0,sp,544
    80005ba2:	892a                	mv	s2,a0
    80005ba4:	dea43823          	sd	a0,-528(s0)
    80005ba8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005bac:	ffffc097          	auipc	ra,0xffffc
    80005bb0:	2ae080e7          	jalr	686(ra) # 80001e5a <myproc>
    80005bb4:	84aa                	mv	s1,a0

  begin_op();
    80005bb6:	fffff097          	auipc	ra,0xfffff
    80005bba:	3ae080e7          	jalr	942(ra) # 80004f64 <begin_op>

  if((ip = namei(path)) == 0){
    80005bbe:	854a                	mv	a0,s2
    80005bc0:	fffff097          	auipc	ra,0xfffff
    80005bc4:	19e080e7          	jalr	414(ra) # 80004d5e <namei>
    80005bc8:	c525                	beqz	a0,80005c30 <exec+0xa4>
    80005bca:	fbd2                	sd	s4,496(sp)
    80005bcc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005bce:	fffff097          	auipc	ra,0xfffff
    80005bd2:	9ac080e7          	jalr	-1620(ra) # 8000457a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005bd6:	04000713          	li	a4,64
    80005bda:	4681                	li	a3,0
    80005bdc:	e5040613          	addi	a2,s0,-432
    80005be0:	4581                	li	a1,0
    80005be2:	8552                	mv	a0,s4
    80005be4:	fffff097          	auipc	ra,0xfffff
    80005be8:	c52080e7          	jalr	-942(ra) # 80004836 <readi>
    80005bec:	04000793          	li	a5,64
    80005bf0:	00f51a63          	bne	a0,a5,80005c04 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005bf4:	e5042703          	lw	a4,-432(s0)
    80005bf8:	464c47b7          	lui	a5,0x464c4
    80005bfc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005c00:	02f70e63          	beq	a4,a5,80005c3c <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005c04:	8552                	mv	a0,s4
    80005c06:	fffff097          	auipc	ra,0xfffff
    80005c0a:	bda080e7          	jalr	-1062(ra) # 800047e0 <iunlockput>
    end_op();
    80005c0e:	fffff097          	auipc	ra,0xfffff
    80005c12:	3d0080e7          	jalr	976(ra) # 80004fde <end_op>
  }
  return -1;
    80005c16:	557d                	li	a0,-1
    80005c18:	7a5e                	ld	s4,496(sp)
}
    80005c1a:	21813083          	ld	ra,536(sp)
    80005c1e:	21013403          	ld	s0,528(sp)
    80005c22:	20813483          	ld	s1,520(sp)
    80005c26:	20013903          	ld	s2,512(sp)
    80005c2a:	22010113          	addi	sp,sp,544
    80005c2e:	8082                	ret
    end_op();
    80005c30:	fffff097          	auipc	ra,0xfffff
    80005c34:	3ae080e7          	jalr	942(ra) # 80004fde <end_op>
    return -1;
    80005c38:	557d                	li	a0,-1
    80005c3a:	b7c5                	j	80005c1a <exec+0x8e>
    80005c3c:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005c3e:	8526                	mv	a0,s1
    80005c40:	ffffc097          	auipc	ra,0xffffc
    80005c44:	2de080e7          	jalr	734(ra) # 80001f1e <proc_pagetable>
    80005c48:	8b2a                	mv	s6,a0
    80005c4a:	2c050163          	beqz	a0,80005f0c <exec+0x380>
    80005c4e:	ffce                	sd	s3,504(sp)
    80005c50:	f7d6                	sd	s5,488(sp)
    80005c52:	efde                	sd	s7,472(sp)
    80005c54:	ebe2                	sd	s8,464(sp)
    80005c56:	e7e6                	sd	s9,456(sp)
    80005c58:	e3ea                	sd	s10,448(sp)
    80005c5a:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005c5c:	e7042683          	lw	a3,-400(s0)
    80005c60:	e8845783          	lhu	a5,-376(s0)
    80005c64:	10078363          	beqz	a5,80005d6a <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005c68:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005c6a:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005c6c:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80005c70:	6c85                	lui	s9,0x1
    80005c72:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005c76:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005c7a:	6a85                	lui	s5,0x1
    80005c7c:	a0b5                	j	80005ce8 <exec+0x15c>
      panic("loadseg: address should exist");
    80005c7e:	00006517          	auipc	a0,0x6
    80005c82:	9da50513          	addi	a0,a0,-1574 # 8000b658 <etext+0x658>
    80005c86:	ffffb097          	auipc	ra,0xffffb
    80005c8a:	8da080e7          	jalr	-1830(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005c8e:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005c90:	874a                	mv	a4,s2
    80005c92:	009c06bb          	addw	a3,s8,s1
    80005c96:	4581                	li	a1,0
    80005c98:	8552                	mv	a0,s4
    80005c9a:	fffff097          	auipc	ra,0xfffff
    80005c9e:	b9c080e7          	jalr	-1124(ra) # 80004836 <readi>
    80005ca2:	26a91963          	bne	s2,a0,80005f14 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    80005ca6:	009a84bb          	addw	s1,s5,s1
    80005caa:	0334f463          	bgeu	s1,s3,80005cd2 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    80005cae:	02049593          	slli	a1,s1,0x20
    80005cb2:	9181                	srli	a1,a1,0x20
    80005cb4:	95de                	add	a1,a1,s7
    80005cb6:	855a                	mv	a0,s6
    80005cb8:	ffffb097          	auipc	ra,0xffffb
    80005cbc:	510080e7          	jalr	1296(ra) # 800011c8 <walkaddr>
    80005cc0:	862a                	mv	a2,a0
    if(pa == 0)
    80005cc2:	dd55                	beqz	a0,80005c7e <exec+0xf2>
    if(sz - i < PGSIZE)
    80005cc4:	409987bb          	subw	a5,s3,s1
    80005cc8:	893e                	mv	s2,a5
    80005cca:	fcfcf2e3          	bgeu	s9,a5,80005c8e <exec+0x102>
    80005cce:	8956                	mv	s2,s5
    80005cd0:	bf7d                	j	80005c8e <exec+0x102>
    sz = sz1;
    80005cd2:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005cd6:	2d05                	addiw	s10,s10,1
    80005cd8:	e0843783          	ld	a5,-504(s0)
    80005cdc:	0387869b          	addiw	a3,a5,56
    80005ce0:	e8845783          	lhu	a5,-376(s0)
    80005ce4:	08fd5463          	bge	s10,a5,80005d6c <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005ce8:	e0d43423          	sd	a3,-504(s0)
    80005cec:	876e                	mv	a4,s11
    80005cee:	e1840613          	addi	a2,s0,-488
    80005cf2:	4581                	li	a1,0
    80005cf4:	8552                	mv	a0,s4
    80005cf6:	fffff097          	auipc	ra,0xfffff
    80005cfa:	b40080e7          	jalr	-1216(ra) # 80004836 <readi>
    80005cfe:	21b51963          	bne	a0,s11,80005f10 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    80005d02:	e1842783          	lw	a5,-488(s0)
    80005d06:	4705                	li	a4,1
    80005d08:	fce797e3          	bne	a5,a4,80005cd6 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    80005d0c:	e4043483          	ld	s1,-448(s0)
    80005d10:	e3843783          	ld	a5,-456(s0)
    80005d14:	22f4e063          	bltu	s1,a5,80005f34 <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005d18:	e2843783          	ld	a5,-472(s0)
    80005d1c:	94be                	add	s1,s1,a5
    80005d1e:	20f4ee63          	bltu	s1,a5,80005f3a <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    80005d22:	de843703          	ld	a4,-536(s0)
    80005d26:	8ff9                	and	a5,a5,a4
    80005d28:	20079c63          	bnez	a5,80005f40 <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005d2c:	e1c42503          	lw	a0,-484(s0)
    80005d30:	00000097          	auipc	ra,0x0
    80005d34:	e3c080e7          	jalr	-452(ra) # 80005b6c <flags2perm>
    80005d38:	86aa                	mv	a3,a0
    80005d3a:	8626                	mv	a2,s1
    80005d3c:	85ca                	mv	a1,s2
    80005d3e:	855a                	mv	a0,s6
    80005d40:	ffffc097          	auipc	ra,0xffffc
    80005d44:	860080e7          	jalr	-1952(ra) # 800015a0 <uvmalloc>
    80005d48:	dea43c23          	sd	a0,-520(s0)
    80005d4c:	1e050d63          	beqz	a0,80005f46 <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005d50:	e2843b83          	ld	s7,-472(s0)
    80005d54:	e2042c03          	lw	s8,-480(s0)
    80005d58:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005d5c:	00098463          	beqz	s3,80005d64 <exec+0x1d8>
    80005d60:	4481                	li	s1,0
    80005d62:	b7b1                	j	80005cae <exec+0x122>
    sz = sz1;
    80005d64:	df843903          	ld	s2,-520(s0)
    80005d68:	b7bd                	j	80005cd6 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005d6a:	4901                	li	s2,0
  iunlockput(ip);
    80005d6c:	8552                	mv	a0,s4
    80005d6e:	fffff097          	auipc	ra,0xfffff
    80005d72:	a72080e7          	jalr	-1422(ra) # 800047e0 <iunlockput>
  end_op();
    80005d76:	fffff097          	auipc	ra,0xfffff
    80005d7a:	268080e7          	jalr	616(ra) # 80004fde <end_op>
  p = myproc();
    80005d7e:	ffffc097          	auipc	ra,0xffffc
    80005d82:	0dc080e7          	jalr	220(ra) # 80001e5a <myproc>
    80005d86:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005d88:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005d8c:	6985                	lui	s3,0x1
    80005d8e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005d90:	99ca                	add	s3,s3,s2
    80005d92:	77fd                	lui	a5,0xfffff
    80005d94:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005d98:	4691                	li	a3,4
    80005d9a:	6609                	lui	a2,0x2
    80005d9c:	964e                	add	a2,a2,s3
    80005d9e:	85ce                	mv	a1,s3
    80005da0:	855a                	mv	a0,s6
    80005da2:	ffffb097          	auipc	ra,0xffffb
    80005da6:	7fe080e7          	jalr	2046(ra) # 800015a0 <uvmalloc>
    80005daa:	8a2a                	mv	s4,a0
    80005dac:	e115                	bnez	a0,80005dd0 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    80005dae:	85ce                	mv	a1,s3
    80005db0:	855a                	mv	a0,s6
    80005db2:	ffffc097          	auipc	ra,0xffffc
    80005db6:	208080e7          	jalr	520(ra) # 80001fba <proc_freepagetable>
  return -1;
    80005dba:	557d                	li	a0,-1
    80005dbc:	79fe                	ld	s3,504(sp)
    80005dbe:	7a5e                	ld	s4,496(sp)
    80005dc0:	7abe                	ld	s5,488(sp)
    80005dc2:	7b1e                	ld	s6,480(sp)
    80005dc4:	6bfe                	ld	s7,472(sp)
    80005dc6:	6c5e                	ld	s8,464(sp)
    80005dc8:	6cbe                	ld	s9,456(sp)
    80005dca:	6d1e                	ld	s10,448(sp)
    80005dcc:	7dfa                	ld	s11,440(sp)
    80005dce:	b5b1                	j	80005c1a <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005dd0:	75f9                	lui	a1,0xffffe
    80005dd2:	95aa                	add	a1,a1,a0
    80005dd4:	855a                	mv	a0,s6
    80005dd6:	ffffc097          	auipc	ra,0xffffc
    80005dda:	cfa080e7          	jalr	-774(ra) # 80001ad0 <uvmclear>
  stackbase = sp - PGSIZE;
    80005dde:	7bfd                	lui	s7,0xfffff
    80005de0:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80005de2:	e0043783          	ld	a5,-512(s0)
    80005de6:	6388                	ld	a0,0(a5)
  sp = sz;
    80005de8:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80005dea:	4481                	li	s1,0
    ustack[argc] = sp;
    80005dec:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005df0:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005df4:	c135                	beqz	a0,80005e58 <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    80005df6:	ffffb097          	auipc	ra,0xffffb
    80005dfa:	1a4080e7          	jalr	420(ra) # 80000f9a <strlen>
    80005dfe:	0015079b          	addiw	a5,a0,1
    80005e02:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005e06:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005e0a:	15796163          	bltu	s2,s7,80005f4c <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005e0e:	e0043d83          	ld	s11,-512(s0)
    80005e12:	000db983          	ld	s3,0(s11)
    80005e16:	854e                	mv	a0,s3
    80005e18:	ffffb097          	auipc	ra,0xffffb
    80005e1c:	182080e7          	jalr	386(ra) # 80000f9a <strlen>
    80005e20:	0015069b          	addiw	a3,a0,1
    80005e24:	864e                	mv	a2,s3
    80005e26:	85ca                	mv	a1,s2
    80005e28:	855a                	mv	a0,s6
    80005e2a:	ffffc097          	auipc	ra,0xffffc
    80005e2e:	cd8080e7          	jalr	-808(ra) # 80001b02 <copyout>
    80005e32:	10054f63          	bltz	a0,80005f50 <exec+0x3c4>
    ustack[argc] = sp;
    80005e36:	00349793          	slli	a5,s1,0x3
    80005e3a:	97e6                	add	a5,a5,s9
    80005e3c:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ff8b708>
  for(argc = 0; argv[argc]; argc++) {
    80005e40:	0485                	addi	s1,s1,1
    80005e42:	008d8793          	addi	a5,s11,8
    80005e46:	e0f43023          	sd	a5,-512(s0)
    80005e4a:	008db503          	ld	a0,8(s11)
    80005e4e:	c509                	beqz	a0,80005e58 <exec+0x2cc>
    if(argc >= MAXARG)
    80005e50:	fb8493e3          	bne	s1,s8,80005df6 <exec+0x26a>
  sz = sz1;
    80005e54:	89d2                	mv	s3,s4
    80005e56:	bfa1                	j	80005dae <exec+0x222>
  ustack[argc] = 0;
    80005e58:	00349793          	slli	a5,s1,0x3
    80005e5c:	f9078793          	addi	a5,a5,-112
    80005e60:	97a2                	add	a5,a5,s0
    80005e62:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005e66:	00148693          	addi	a3,s1,1
    80005e6a:	068e                	slli	a3,a3,0x3
    80005e6c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005e70:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005e74:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005e76:	f3796ce3          	bltu	s2,s7,80005dae <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005e7a:	e9040613          	addi	a2,s0,-368
    80005e7e:	85ca                	mv	a1,s2
    80005e80:	855a                	mv	a0,s6
    80005e82:	ffffc097          	auipc	ra,0xffffc
    80005e86:	c80080e7          	jalr	-896(ra) # 80001b02 <copyout>
    80005e8a:	f20542e3          	bltz	a0,80005dae <exec+0x222>
  p->trapframe->a1 = sp;
    80005e8e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005e92:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005e96:	df043783          	ld	a5,-528(s0)
    80005e9a:	0007c703          	lbu	a4,0(a5)
    80005e9e:	cf11                	beqz	a4,80005eba <exec+0x32e>
    80005ea0:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005ea2:	02f00693          	li	a3,47
    80005ea6:	a029                	j	80005eb0 <exec+0x324>
  for(last=s=path; *s; s++)
    80005ea8:	0785                	addi	a5,a5,1
    80005eaa:	fff7c703          	lbu	a4,-1(a5)
    80005eae:	c711                	beqz	a4,80005eba <exec+0x32e>
    if(*s == '/')
    80005eb0:	fed71ce3          	bne	a4,a3,80005ea8 <exec+0x31c>
      last = s+1;
    80005eb4:	def43823          	sd	a5,-528(s0)
    80005eb8:	bfc5                	j	80005ea8 <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005eba:	4641                	li	a2,16
    80005ebc:	df043583          	ld	a1,-528(s0)
    80005ec0:	158a8513          	addi	a0,s5,344
    80005ec4:	ffffb097          	auipc	ra,0xffffb
    80005ec8:	0a0080e7          	jalr	160(ra) # 80000f64 <safestrcpy>
  oldpagetable = p->pagetable;
    80005ecc:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005ed0:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005ed4:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005ed8:	058ab783          	ld	a5,88(s5)
    80005edc:	e6843703          	ld	a4,-408(s0)
    80005ee0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005ee2:	058ab783          	ld	a5,88(s5)
    80005ee6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005eea:	85ea                	mv	a1,s10
    80005eec:	ffffc097          	auipc	ra,0xffffc
    80005ef0:	0ce080e7          	jalr	206(ra) # 80001fba <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005ef4:	0004851b          	sext.w	a0,s1
    80005ef8:	79fe                	ld	s3,504(sp)
    80005efa:	7a5e                	ld	s4,496(sp)
    80005efc:	7abe                	ld	s5,488(sp)
    80005efe:	7b1e                	ld	s6,480(sp)
    80005f00:	6bfe                	ld	s7,472(sp)
    80005f02:	6c5e                	ld	s8,464(sp)
    80005f04:	6cbe                	ld	s9,456(sp)
    80005f06:	6d1e                	ld	s10,448(sp)
    80005f08:	7dfa                	ld	s11,440(sp)
    80005f0a:	bb01                	j	80005c1a <exec+0x8e>
    80005f0c:	7b1e                	ld	s6,480(sp)
    80005f0e:	b9dd                	j	80005c04 <exec+0x78>
    80005f10:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005f14:	df843583          	ld	a1,-520(s0)
    80005f18:	855a                	mv	a0,s6
    80005f1a:	ffffc097          	auipc	ra,0xffffc
    80005f1e:	0a0080e7          	jalr	160(ra) # 80001fba <proc_freepagetable>
  if(ip){
    80005f22:	79fe                	ld	s3,504(sp)
    80005f24:	7abe                	ld	s5,488(sp)
    80005f26:	7b1e                	ld	s6,480(sp)
    80005f28:	6bfe                	ld	s7,472(sp)
    80005f2a:	6c5e                	ld	s8,464(sp)
    80005f2c:	6cbe                	ld	s9,456(sp)
    80005f2e:	6d1e                	ld	s10,448(sp)
    80005f30:	7dfa                	ld	s11,440(sp)
    80005f32:	b9c9                	j	80005c04 <exec+0x78>
    80005f34:	df243c23          	sd	s2,-520(s0)
    80005f38:	bff1                	j	80005f14 <exec+0x388>
    80005f3a:	df243c23          	sd	s2,-520(s0)
    80005f3e:	bfd9                	j	80005f14 <exec+0x388>
    80005f40:	df243c23          	sd	s2,-520(s0)
    80005f44:	bfc1                	j	80005f14 <exec+0x388>
    80005f46:	df243c23          	sd	s2,-520(s0)
    80005f4a:	b7e9                	j	80005f14 <exec+0x388>
  sz = sz1;
    80005f4c:	89d2                	mv	s3,s4
    80005f4e:	b585                	j	80005dae <exec+0x222>
    80005f50:	89d2                	mv	s3,s4
    80005f52:	bdb1                	j	80005dae <exec+0x222>

0000000080005f54 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005f54:	7179                	addi	sp,sp,-48
    80005f56:	f406                	sd	ra,40(sp)
    80005f58:	f022                	sd	s0,32(sp)
    80005f5a:	ec26                	sd	s1,24(sp)
    80005f5c:	e84a                	sd	s2,16(sp)
    80005f5e:	1800                	addi	s0,sp,48
    80005f60:	892e                	mv	s2,a1
    80005f62:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005f64:	fdc40593          	addi	a1,s0,-36
    80005f68:	ffffd097          	auipc	ra,0xffffd
    80005f6c:	508080e7          	jalr	1288(ra) # 80003470 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005f70:	fdc42703          	lw	a4,-36(s0)
    80005f74:	47bd                	li	a5,15
    80005f76:	02e7eb63          	bltu	a5,a4,80005fac <argfd+0x58>
    80005f7a:	ffffc097          	auipc	ra,0xffffc
    80005f7e:	ee0080e7          	jalr	-288(ra) # 80001e5a <myproc>
    80005f82:	fdc42703          	lw	a4,-36(s0)
    80005f86:	01a70793          	addi	a5,a4,26
    80005f8a:	078e                	slli	a5,a5,0x3
    80005f8c:	953e                	add	a0,a0,a5
    80005f8e:	611c                	ld	a5,0(a0)
    80005f90:	c385                	beqz	a5,80005fb0 <argfd+0x5c>
    return -1;
  if(pfd)
    80005f92:	00090463          	beqz	s2,80005f9a <argfd+0x46>
    *pfd = fd;
    80005f96:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005f9a:	4501                	li	a0,0
  if(pf)
    80005f9c:	c091                	beqz	s1,80005fa0 <argfd+0x4c>
    *pf = f;
    80005f9e:	e09c                	sd	a5,0(s1)
}
    80005fa0:	70a2                	ld	ra,40(sp)
    80005fa2:	7402                	ld	s0,32(sp)
    80005fa4:	64e2                	ld	s1,24(sp)
    80005fa6:	6942                	ld	s2,16(sp)
    80005fa8:	6145                	addi	sp,sp,48
    80005faa:	8082                	ret
    return -1;
    80005fac:	557d                	li	a0,-1
    80005fae:	bfcd                	j	80005fa0 <argfd+0x4c>
    80005fb0:	557d                	li	a0,-1
    80005fb2:	b7fd                	j	80005fa0 <argfd+0x4c>

0000000080005fb4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005fb4:	715d                	addi	sp,sp,-80
    80005fb6:	e486                	sd	ra,72(sp)
    80005fb8:	e0a2                	sd	s0,64(sp)
    80005fba:	fc26                	sd	s1,56(sp)
    80005fbc:	f84a                	sd	s2,48(sp)
    80005fbe:	f44e                	sd	s3,40(sp)
    80005fc0:	ec56                	sd	s5,24(sp)
    80005fc2:	e85a                	sd	s6,16(sp)
    80005fc4:	0880                	addi	s0,sp,80
    80005fc6:	8b2e                	mv	s6,a1
    80005fc8:	89b2                	mv	s3,a2
    80005fca:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005fcc:	fb040593          	addi	a1,s0,-80
    80005fd0:	fffff097          	auipc	ra,0xfffff
    80005fd4:	dac080e7          	jalr	-596(ra) # 80004d7c <nameiparent>
    80005fd8:	84aa                	mv	s1,a0
    80005fda:	14050e63          	beqz	a0,80006136 <create+0x182>
    return 0;

  ilock(dp);
    80005fde:	ffffe097          	auipc	ra,0xffffe
    80005fe2:	59c080e7          	jalr	1436(ra) # 8000457a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005fe6:	4601                	li	a2,0
    80005fe8:	fb040593          	addi	a1,s0,-80
    80005fec:	8526                	mv	a0,s1
    80005fee:	fffff097          	auipc	ra,0xfffff
    80005ff2:	a88080e7          	jalr	-1400(ra) # 80004a76 <dirlookup>
    80005ff6:	8aaa                	mv	s5,a0
    80005ff8:	c539                	beqz	a0,80006046 <create+0x92>
    iunlockput(dp);
    80005ffa:	8526                	mv	a0,s1
    80005ffc:	ffffe097          	auipc	ra,0xffffe
    80006000:	7e4080e7          	jalr	2020(ra) # 800047e0 <iunlockput>
    ilock(ip);
    80006004:	8556                	mv	a0,s5
    80006006:	ffffe097          	auipc	ra,0xffffe
    8000600a:	574080e7          	jalr	1396(ra) # 8000457a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000600e:	4789                	li	a5,2
    80006010:	02fb1463          	bne	s6,a5,80006038 <create+0x84>
    80006014:	044ad783          	lhu	a5,68(s5)
    80006018:	37f9                	addiw	a5,a5,-2
    8000601a:	17c2                	slli	a5,a5,0x30
    8000601c:	93c1                	srli	a5,a5,0x30
    8000601e:	4705                	li	a4,1
    80006020:	00f76c63          	bltu	a4,a5,80006038 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80006024:	8556                	mv	a0,s5
    80006026:	60a6                	ld	ra,72(sp)
    80006028:	6406                	ld	s0,64(sp)
    8000602a:	74e2                	ld	s1,56(sp)
    8000602c:	7942                	ld	s2,48(sp)
    8000602e:	79a2                	ld	s3,40(sp)
    80006030:	6ae2                	ld	s5,24(sp)
    80006032:	6b42                	ld	s6,16(sp)
    80006034:	6161                	addi	sp,sp,80
    80006036:	8082                	ret
    iunlockput(ip);
    80006038:	8556                	mv	a0,s5
    8000603a:	ffffe097          	auipc	ra,0xffffe
    8000603e:	7a6080e7          	jalr	1958(ra) # 800047e0 <iunlockput>
    return 0;
    80006042:	4a81                	li	s5,0
    80006044:	b7c5                	j	80006024 <create+0x70>
    80006046:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80006048:	85da                	mv	a1,s6
    8000604a:	4088                	lw	a0,0(s1)
    8000604c:	ffffe097          	auipc	ra,0xffffe
    80006050:	38a080e7          	jalr	906(ra) # 800043d6 <ialloc>
    80006054:	8a2a                	mv	s4,a0
    80006056:	c531                	beqz	a0,800060a2 <create+0xee>
  ilock(ip);
    80006058:	ffffe097          	auipc	ra,0xffffe
    8000605c:	522080e7          	jalr	1314(ra) # 8000457a <ilock>
  ip->major = major;
    80006060:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80006064:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80006068:	4905                	li	s2,1
    8000606a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000606e:	8552                	mv	a0,s4
    80006070:	ffffe097          	auipc	ra,0xffffe
    80006074:	43e080e7          	jalr	1086(ra) # 800044ae <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80006078:	032b0d63          	beq	s6,s2,800060b2 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000607c:	004a2603          	lw	a2,4(s4)
    80006080:	fb040593          	addi	a1,s0,-80
    80006084:	8526                	mv	a0,s1
    80006086:	fffff097          	auipc	ra,0xfffff
    8000608a:	c16080e7          	jalr	-1002(ra) # 80004c9c <dirlink>
    8000608e:	08054163          	bltz	a0,80006110 <create+0x15c>
  iunlockput(dp);
    80006092:	8526                	mv	a0,s1
    80006094:	ffffe097          	auipc	ra,0xffffe
    80006098:	74c080e7          	jalr	1868(ra) # 800047e0 <iunlockput>
  return ip;
    8000609c:	8ad2                	mv	s5,s4
    8000609e:	7a02                	ld	s4,32(sp)
    800060a0:	b751                	j	80006024 <create+0x70>
    iunlockput(dp);
    800060a2:	8526                	mv	a0,s1
    800060a4:	ffffe097          	auipc	ra,0xffffe
    800060a8:	73c080e7          	jalr	1852(ra) # 800047e0 <iunlockput>
    return 0;
    800060ac:	8ad2                	mv	s5,s4
    800060ae:	7a02                	ld	s4,32(sp)
    800060b0:	bf95                	j	80006024 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800060b2:	004a2603          	lw	a2,4(s4)
    800060b6:	00005597          	auipc	a1,0x5
    800060ba:	5c258593          	addi	a1,a1,1474 # 8000b678 <etext+0x678>
    800060be:	8552                	mv	a0,s4
    800060c0:	fffff097          	auipc	ra,0xfffff
    800060c4:	bdc080e7          	jalr	-1060(ra) # 80004c9c <dirlink>
    800060c8:	04054463          	bltz	a0,80006110 <create+0x15c>
    800060cc:	40d0                	lw	a2,4(s1)
    800060ce:	00005597          	auipc	a1,0x5
    800060d2:	5b258593          	addi	a1,a1,1458 # 8000b680 <etext+0x680>
    800060d6:	8552                	mv	a0,s4
    800060d8:	fffff097          	auipc	ra,0xfffff
    800060dc:	bc4080e7          	jalr	-1084(ra) # 80004c9c <dirlink>
    800060e0:	02054863          	bltz	a0,80006110 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    800060e4:	004a2603          	lw	a2,4(s4)
    800060e8:	fb040593          	addi	a1,s0,-80
    800060ec:	8526                	mv	a0,s1
    800060ee:	fffff097          	auipc	ra,0xfffff
    800060f2:	bae080e7          	jalr	-1106(ra) # 80004c9c <dirlink>
    800060f6:	00054d63          	bltz	a0,80006110 <create+0x15c>
    dp->nlink++;  // for ".."
    800060fa:	04a4d783          	lhu	a5,74(s1)
    800060fe:	2785                	addiw	a5,a5,1
    80006100:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006104:	8526                	mv	a0,s1
    80006106:	ffffe097          	auipc	ra,0xffffe
    8000610a:	3a8080e7          	jalr	936(ra) # 800044ae <iupdate>
    8000610e:	b751                	j	80006092 <create+0xde>
  ip->nlink = 0;
    80006110:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80006114:	8552                	mv	a0,s4
    80006116:	ffffe097          	auipc	ra,0xffffe
    8000611a:	398080e7          	jalr	920(ra) # 800044ae <iupdate>
  iunlockput(ip);
    8000611e:	8552                	mv	a0,s4
    80006120:	ffffe097          	auipc	ra,0xffffe
    80006124:	6c0080e7          	jalr	1728(ra) # 800047e0 <iunlockput>
  iunlockput(dp);
    80006128:	8526                	mv	a0,s1
    8000612a:	ffffe097          	auipc	ra,0xffffe
    8000612e:	6b6080e7          	jalr	1718(ra) # 800047e0 <iunlockput>
  return 0;
    80006132:	7a02                	ld	s4,32(sp)
    80006134:	bdc5                	j	80006024 <create+0x70>
    return 0;
    80006136:	8aaa                	mv	s5,a0
    80006138:	b5f5                	j	80006024 <create+0x70>

000000008000613a <fdalloc>:
{
    8000613a:	1101                	addi	sp,sp,-32
    8000613c:	ec06                	sd	ra,24(sp)
    8000613e:	e822                	sd	s0,16(sp)
    80006140:	e426                	sd	s1,8(sp)
    80006142:	1000                	addi	s0,sp,32
    80006144:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80006146:	ffffc097          	auipc	ra,0xffffc
    8000614a:	d14080e7          	jalr	-748(ra) # 80001e5a <myproc>
    8000614e:	862a                	mv	a2,a0
  for(fd = 0; fd < NOFILE; fd++){
    80006150:	0d050793          	addi	a5,a0,208
    80006154:	4501                	li	a0,0
    80006156:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80006158:	6398                	ld	a4,0(a5)
    8000615a:	cb19                	beqz	a4,80006170 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000615c:	2505                	addiw	a0,a0,1
    8000615e:	07a1                	addi	a5,a5,8
    80006160:	fed51ce3          	bne	a0,a3,80006158 <fdalloc+0x1e>
  return -1;
    80006164:	557d                	li	a0,-1
}
    80006166:	60e2                	ld	ra,24(sp)
    80006168:	6442                	ld	s0,16(sp)
    8000616a:	64a2                	ld	s1,8(sp)
    8000616c:	6105                	addi	sp,sp,32
    8000616e:	8082                	ret
      p->ofile[fd] = f;
    80006170:	01a50793          	addi	a5,a0,26
    80006174:	078e                	slli	a5,a5,0x3
    80006176:	963e                	add	a2,a2,a5
    80006178:	e204                	sd	s1,0(a2)
      return fd;
    8000617a:	b7f5                	j	80006166 <fdalloc+0x2c>

000000008000617c <sys_dup>:
{
    8000617c:	7179                	addi	sp,sp,-48
    8000617e:	f406                	sd	ra,40(sp)
    80006180:	f022                	sd	s0,32(sp)
    80006182:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80006184:	fd840613          	addi	a2,s0,-40
    80006188:	4581                	li	a1,0
    8000618a:	4501                	li	a0,0
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	dc8080e7          	jalr	-568(ra) # 80005f54 <argfd>
    return -1;
    80006194:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80006196:	02054763          	bltz	a0,800061c4 <sys_dup+0x48>
    8000619a:	ec26                	sd	s1,24(sp)
    8000619c:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000619e:	fd843903          	ld	s2,-40(s0)
    800061a2:	854a                	mv	a0,s2
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	f96080e7          	jalr	-106(ra) # 8000613a <fdalloc>
    800061ac:	84aa                	mv	s1,a0
    return -1;
    800061ae:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800061b0:	00054f63          	bltz	a0,800061ce <sys_dup+0x52>
  filedup(f);
    800061b4:	854a                	mv	a0,s2
    800061b6:	fffff097          	auipc	ra,0xfffff
    800061ba:	22c080e7          	jalr	556(ra) # 800053e2 <filedup>
  return fd;
    800061be:	87a6                	mv	a5,s1
    800061c0:	64e2                	ld	s1,24(sp)
    800061c2:	6942                	ld	s2,16(sp)
}
    800061c4:	853e                	mv	a0,a5
    800061c6:	70a2                	ld	ra,40(sp)
    800061c8:	7402                	ld	s0,32(sp)
    800061ca:	6145                	addi	sp,sp,48
    800061cc:	8082                	ret
    800061ce:	64e2                	ld	s1,24(sp)
    800061d0:	6942                	ld	s2,16(sp)
    800061d2:	bfcd                	j	800061c4 <sys_dup+0x48>

00000000800061d4 <sys_read>:
{
    800061d4:	7179                	addi	sp,sp,-48
    800061d6:	f406                	sd	ra,40(sp)
    800061d8:	f022                	sd	s0,32(sp)
    800061da:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800061dc:	fd840593          	addi	a1,s0,-40
    800061e0:	4505                	li	a0,1
    800061e2:	ffffd097          	auipc	ra,0xffffd
    800061e6:	2ae080e7          	jalr	686(ra) # 80003490 <argaddr>
  argint(2, &n);
    800061ea:	fe440593          	addi	a1,s0,-28
    800061ee:	4509                	li	a0,2
    800061f0:	ffffd097          	auipc	ra,0xffffd
    800061f4:	280080e7          	jalr	640(ra) # 80003470 <argint>
  if(argfd(0, 0, &f) < 0)
    800061f8:	fe840613          	addi	a2,s0,-24
    800061fc:	4581                	li	a1,0
    800061fe:	4501                	li	a0,0
    80006200:	00000097          	auipc	ra,0x0
    80006204:	d54080e7          	jalr	-684(ra) # 80005f54 <argfd>
    80006208:	87aa                	mv	a5,a0
    return -1;
    8000620a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000620c:	0007cc63          	bltz	a5,80006224 <sys_read+0x50>
  return fileread(f, p, n);
    80006210:	fe442603          	lw	a2,-28(s0)
    80006214:	fd843583          	ld	a1,-40(s0)
    80006218:	fe843503          	ld	a0,-24(s0)
    8000621c:	fffff097          	auipc	ra,0xfffff
    80006220:	3ba080e7          	jalr	954(ra) # 800055d6 <fileread>
}
    80006224:	70a2                	ld	ra,40(sp)
    80006226:	7402                	ld	s0,32(sp)
    80006228:	6145                	addi	sp,sp,48
    8000622a:	8082                	ret

000000008000622c <sys_write>:
{
    8000622c:	7179                	addi	sp,sp,-48
    8000622e:	f406                	sd	ra,40(sp)
    80006230:	f022                	sd	s0,32(sp)
    80006232:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80006234:	fd840593          	addi	a1,s0,-40
    80006238:	4505                	li	a0,1
    8000623a:	ffffd097          	auipc	ra,0xffffd
    8000623e:	256080e7          	jalr	598(ra) # 80003490 <argaddr>
  argint(2, &n);
    80006242:	fe440593          	addi	a1,s0,-28
    80006246:	4509                	li	a0,2
    80006248:	ffffd097          	auipc	ra,0xffffd
    8000624c:	228080e7          	jalr	552(ra) # 80003470 <argint>
  if(argfd(0, 0, &f) < 0)
    80006250:	fe840613          	addi	a2,s0,-24
    80006254:	4581                	li	a1,0
    80006256:	4501                	li	a0,0
    80006258:	00000097          	auipc	ra,0x0
    8000625c:	cfc080e7          	jalr	-772(ra) # 80005f54 <argfd>
    80006260:	87aa                	mv	a5,a0
    return -1;
    80006262:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006264:	0007cc63          	bltz	a5,8000627c <sys_write+0x50>
  return filewrite(f, p, n);
    80006268:	fe442603          	lw	a2,-28(s0)
    8000626c:	fd843583          	ld	a1,-40(s0)
    80006270:	fe843503          	ld	a0,-24(s0)
    80006274:	fffff097          	auipc	ra,0xfffff
    80006278:	434080e7          	jalr	1076(ra) # 800056a8 <filewrite>
}
    8000627c:	70a2                	ld	ra,40(sp)
    8000627e:	7402                	ld	s0,32(sp)
    80006280:	6145                	addi	sp,sp,48
    80006282:	8082                	ret

0000000080006284 <sys_close>:
{
    80006284:	1101                	addi	sp,sp,-32
    80006286:	ec06                	sd	ra,24(sp)
    80006288:	e822                	sd	s0,16(sp)
    8000628a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000628c:	fe040613          	addi	a2,s0,-32
    80006290:	fec40593          	addi	a1,s0,-20
    80006294:	4501                	li	a0,0
    80006296:	00000097          	auipc	ra,0x0
    8000629a:	cbe080e7          	jalr	-834(ra) # 80005f54 <argfd>
    return -1;
    8000629e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800062a0:	02054463          	bltz	a0,800062c8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800062a4:	ffffc097          	auipc	ra,0xffffc
    800062a8:	bb6080e7          	jalr	-1098(ra) # 80001e5a <myproc>
    800062ac:	fec42783          	lw	a5,-20(s0)
    800062b0:	07e9                	addi	a5,a5,26
    800062b2:	078e                	slli	a5,a5,0x3
    800062b4:	953e                	add	a0,a0,a5
    800062b6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800062ba:	fe043503          	ld	a0,-32(s0)
    800062be:	fffff097          	auipc	ra,0xfffff
    800062c2:	176080e7          	jalr	374(ra) # 80005434 <fileclose>
  return 0;
    800062c6:	4781                	li	a5,0
}
    800062c8:	853e                	mv	a0,a5
    800062ca:	60e2                	ld	ra,24(sp)
    800062cc:	6442                	ld	s0,16(sp)
    800062ce:	6105                	addi	sp,sp,32
    800062d0:	8082                	ret

00000000800062d2 <sys_fstat>:
{
    800062d2:	1101                	addi	sp,sp,-32
    800062d4:	ec06                	sd	ra,24(sp)
    800062d6:	e822                	sd	s0,16(sp)
    800062d8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800062da:	fe040593          	addi	a1,s0,-32
    800062de:	4505                	li	a0,1
    800062e0:	ffffd097          	auipc	ra,0xffffd
    800062e4:	1b0080e7          	jalr	432(ra) # 80003490 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800062e8:	fe840613          	addi	a2,s0,-24
    800062ec:	4581                	li	a1,0
    800062ee:	4501                	li	a0,0
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	c64080e7          	jalr	-924(ra) # 80005f54 <argfd>
    800062f8:	87aa                	mv	a5,a0
    return -1;
    800062fa:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800062fc:	0007ca63          	bltz	a5,80006310 <sys_fstat+0x3e>
  return filestat(f, st);
    80006300:	fe043583          	ld	a1,-32(s0)
    80006304:	fe843503          	ld	a0,-24(s0)
    80006308:	fffff097          	auipc	ra,0xfffff
    8000630c:	258080e7          	jalr	600(ra) # 80005560 <filestat>
}
    80006310:	60e2                	ld	ra,24(sp)
    80006312:	6442                	ld	s0,16(sp)
    80006314:	6105                	addi	sp,sp,32
    80006316:	8082                	ret

0000000080006318 <sys_link>:
{
    80006318:	7169                	addi	sp,sp,-304
    8000631a:	f606                	sd	ra,296(sp)
    8000631c:	f222                	sd	s0,288(sp)
    8000631e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006320:	08000613          	li	a2,128
    80006324:	ed040593          	addi	a1,s0,-304
    80006328:	4501                	li	a0,0
    8000632a:	ffffd097          	auipc	ra,0xffffd
    8000632e:	186080e7          	jalr	390(ra) # 800034b0 <argstr>
    return -1;
    80006332:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006334:	12054663          	bltz	a0,80006460 <sys_link+0x148>
    80006338:	08000613          	li	a2,128
    8000633c:	f5040593          	addi	a1,s0,-176
    80006340:	4505                	li	a0,1
    80006342:	ffffd097          	auipc	ra,0xffffd
    80006346:	16e080e7          	jalr	366(ra) # 800034b0 <argstr>
    return -1;
    8000634a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000634c:	10054a63          	bltz	a0,80006460 <sys_link+0x148>
    80006350:	ee26                	sd	s1,280(sp)
  begin_op();
    80006352:	fffff097          	auipc	ra,0xfffff
    80006356:	c12080e7          	jalr	-1006(ra) # 80004f64 <begin_op>
  if((ip = namei(old)) == 0){
    8000635a:	ed040513          	addi	a0,s0,-304
    8000635e:	fffff097          	auipc	ra,0xfffff
    80006362:	a00080e7          	jalr	-1536(ra) # 80004d5e <namei>
    80006366:	84aa                	mv	s1,a0
    80006368:	c949                	beqz	a0,800063fa <sys_link+0xe2>
  ilock(ip);
    8000636a:	ffffe097          	auipc	ra,0xffffe
    8000636e:	210080e7          	jalr	528(ra) # 8000457a <ilock>
  if(ip->type == T_DIR){
    80006372:	04449703          	lh	a4,68(s1)
    80006376:	4785                	li	a5,1
    80006378:	08f70863          	beq	a4,a5,80006408 <sys_link+0xf0>
    8000637c:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000637e:	04a4d783          	lhu	a5,74(s1)
    80006382:	2785                	addiw	a5,a5,1
    80006384:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006388:	8526                	mv	a0,s1
    8000638a:	ffffe097          	auipc	ra,0xffffe
    8000638e:	124080e7          	jalr	292(ra) # 800044ae <iupdate>
  iunlock(ip);
    80006392:	8526                	mv	a0,s1
    80006394:	ffffe097          	auipc	ra,0xffffe
    80006398:	2ac080e7          	jalr	684(ra) # 80004640 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000639c:	fd040593          	addi	a1,s0,-48
    800063a0:	f5040513          	addi	a0,s0,-176
    800063a4:	fffff097          	auipc	ra,0xfffff
    800063a8:	9d8080e7          	jalr	-1576(ra) # 80004d7c <nameiparent>
    800063ac:	892a                	mv	s2,a0
    800063ae:	cd35                	beqz	a0,8000642a <sys_link+0x112>
  ilock(dp);
    800063b0:	ffffe097          	auipc	ra,0xffffe
    800063b4:	1ca080e7          	jalr	458(ra) # 8000457a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800063b8:	00092703          	lw	a4,0(s2)
    800063bc:	409c                	lw	a5,0(s1)
    800063be:	06f71163          	bne	a4,a5,80006420 <sys_link+0x108>
    800063c2:	40d0                	lw	a2,4(s1)
    800063c4:	fd040593          	addi	a1,s0,-48
    800063c8:	854a                	mv	a0,s2
    800063ca:	fffff097          	auipc	ra,0xfffff
    800063ce:	8d2080e7          	jalr	-1838(ra) # 80004c9c <dirlink>
    800063d2:	04054763          	bltz	a0,80006420 <sys_link+0x108>
  iunlockput(dp);
    800063d6:	854a                	mv	a0,s2
    800063d8:	ffffe097          	auipc	ra,0xffffe
    800063dc:	408080e7          	jalr	1032(ra) # 800047e0 <iunlockput>
  iput(ip);
    800063e0:	8526                	mv	a0,s1
    800063e2:	ffffe097          	auipc	ra,0xffffe
    800063e6:	356080e7          	jalr	854(ra) # 80004738 <iput>
  end_op();
    800063ea:	fffff097          	auipc	ra,0xfffff
    800063ee:	bf4080e7          	jalr	-1036(ra) # 80004fde <end_op>
  return 0;
    800063f2:	4781                	li	a5,0
    800063f4:	64f2                	ld	s1,280(sp)
    800063f6:	6952                	ld	s2,272(sp)
    800063f8:	a0a5                	j	80006460 <sys_link+0x148>
    end_op();
    800063fa:	fffff097          	auipc	ra,0xfffff
    800063fe:	be4080e7          	jalr	-1052(ra) # 80004fde <end_op>
    return -1;
    80006402:	57fd                	li	a5,-1
    80006404:	64f2                	ld	s1,280(sp)
    80006406:	a8a9                	j	80006460 <sys_link+0x148>
    iunlockput(ip);
    80006408:	8526                	mv	a0,s1
    8000640a:	ffffe097          	auipc	ra,0xffffe
    8000640e:	3d6080e7          	jalr	982(ra) # 800047e0 <iunlockput>
    end_op();
    80006412:	fffff097          	auipc	ra,0xfffff
    80006416:	bcc080e7          	jalr	-1076(ra) # 80004fde <end_op>
    return -1;
    8000641a:	57fd                	li	a5,-1
    8000641c:	64f2                	ld	s1,280(sp)
    8000641e:	a089                	j	80006460 <sys_link+0x148>
    iunlockput(dp);
    80006420:	854a                	mv	a0,s2
    80006422:	ffffe097          	auipc	ra,0xffffe
    80006426:	3be080e7          	jalr	958(ra) # 800047e0 <iunlockput>
  ilock(ip);
    8000642a:	8526                	mv	a0,s1
    8000642c:	ffffe097          	auipc	ra,0xffffe
    80006430:	14e080e7          	jalr	334(ra) # 8000457a <ilock>
  ip->nlink--;
    80006434:	04a4d783          	lhu	a5,74(s1)
    80006438:	37fd                	addiw	a5,a5,-1
    8000643a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000643e:	8526                	mv	a0,s1
    80006440:	ffffe097          	auipc	ra,0xffffe
    80006444:	06e080e7          	jalr	110(ra) # 800044ae <iupdate>
  iunlockput(ip);
    80006448:	8526                	mv	a0,s1
    8000644a:	ffffe097          	auipc	ra,0xffffe
    8000644e:	396080e7          	jalr	918(ra) # 800047e0 <iunlockput>
  end_op();
    80006452:	fffff097          	auipc	ra,0xfffff
    80006456:	b8c080e7          	jalr	-1140(ra) # 80004fde <end_op>
  return -1;
    8000645a:	57fd                	li	a5,-1
    8000645c:	64f2                	ld	s1,280(sp)
    8000645e:	6952                	ld	s2,272(sp)
}
    80006460:	853e                	mv	a0,a5
    80006462:	70b2                	ld	ra,296(sp)
    80006464:	7412                	ld	s0,288(sp)
    80006466:	6155                	addi	sp,sp,304
    80006468:	8082                	ret

000000008000646a <sys_unlink>:
{
    8000646a:	7111                	addi	sp,sp,-256
    8000646c:	fd86                	sd	ra,248(sp)
    8000646e:	f9a2                	sd	s0,240(sp)
    80006470:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80006472:	08000613          	li	a2,128
    80006476:	f2040593          	addi	a1,s0,-224
    8000647a:	4501                	li	a0,0
    8000647c:	ffffd097          	auipc	ra,0xffffd
    80006480:	034080e7          	jalr	52(ra) # 800034b0 <argstr>
    80006484:	1c054063          	bltz	a0,80006644 <sys_unlink+0x1da>
    80006488:	f5a6                	sd	s1,232(sp)
  begin_op();
    8000648a:	fffff097          	auipc	ra,0xfffff
    8000648e:	ada080e7          	jalr	-1318(ra) # 80004f64 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80006492:	fa040593          	addi	a1,s0,-96
    80006496:	f2040513          	addi	a0,s0,-224
    8000649a:	fffff097          	auipc	ra,0xfffff
    8000649e:	8e2080e7          	jalr	-1822(ra) # 80004d7c <nameiparent>
    800064a2:	84aa                	mv	s1,a0
    800064a4:	c165                	beqz	a0,80006584 <sys_unlink+0x11a>
  ilock(dp);
    800064a6:	ffffe097          	auipc	ra,0xffffe
    800064aa:	0d4080e7          	jalr	212(ra) # 8000457a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800064ae:	00005597          	auipc	a1,0x5
    800064b2:	1ca58593          	addi	a1,a1,458 # 8000b678 <etext+0x678>
    800064b6:	fa040513          	addi	a0,s0,-96
    800064ba:	ffffe097          	auipc	ra,0xffffe
    800064be:	5a2080e7          	jalr	1442(ra) # 80004a5c <namecmp>
    800064c2:	16050263          	beqz	a0,80006626 <sys_unlink+0x1bc>
    800064c6:	00005597          	auipc	a1,0x5
    800064ca:	1ba58593          	addi	a1,a1,442 # 8000b680 <etext+0x680>
    800064ce:	fa040513          	addi	a0,s0,-96
    800064d2:	ffffe097          	auipc	ra,0xffffe
    800064d6:	58a080e7          	jalr	1418(ra) # 80004a5c <namecmp>
    800064da:	14050663          	beqz	a0,80006626 <sys_unlink+0x1bc>
    800064de:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800064e0:	f1c40613          	addi	a2,s0,-228
    800064e4:	fa040593          	addi	a1,s0,-96
    800064e8:	8526                	mv	a0,s1
    800064ea:	ffffe097          	auipc	ra,0xffffe
    800064ee:	58c080e7          	jalr	1420(ra) # 80004a76 <dirlookup>
    800064f2:	892a                	mv	s2,a0
    800064f4:	12050863          	beqz	a0,80006624 <sys_unlink+0x1ba>
    800064f8:	edce                	sd	s3,216(sp)
  ilock(ip);
    800064fa:	ffffe097          	auipc	ra,0xffffe
    800064fe:	080080e7          	jalr	128(ra) # 8000457a <ilock>
  if(ip->nlink < 1)
    80006502:	04a91783          	lh	a5,74(s2)
    80006506:	08f05663          	blez	a5,80006592 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000650a:	04491703          	lh	a4,68(s2)
    8000650e:	4785                	li	a5,1
    80006510:	08f70b63          	beq	a4,a5,800065a6 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80006514:	fb040993          	addi	s3,s0,-80
    80006518:	4641                	li	a2,16
    8000651a:	4581                	li	a1,0
    8000651c:	854e                	mv	a0,s3
    8000651e:	ffffb097          	auipc	ra,0xffffb
    80006522:	8f0080e7          	jalr	-1808(ra) # 80000e0e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006526:	4741                	li	a4,16
    80006528:	f1c42683          	lw	a3,-228(s0)
    8000652c:	864e                	mv	a2,s3
    8000652e:	4581                	li	a1,0
    80006530:	8526                	mv	a0,s1
    80006532:	ffffe097          	auipc	ra,0xffffe
    80006536:	40a080e7          	jalr	1034(ra) # 8000493c <writei>
    8000653a:	47c1                	li	a5,16
    8000653c:	0af51f63          	bne	a0,a5,800065fa <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80006540:	04491703          	lh	a4,68(s2)
    80006544:	4785                	li	a5,1
    80006546:	0cf70463          	beq	a4,a5,8000660e <sys_unlink+0x1a4>
  iunlockput(dp);
    8000654a:	8526                	mv	a0,s1
    8000654c:	ffffe097          	auipc	ra,0xffffe
    80006550:	294080e7          	jalr	660(ra) # 800047e0 <iunlockput>
  ip->nlink--;
    80006554:	04a95783          	lhu	a5,74(s2)
    80006558:	37fd                	addiw	a5,a5,-1
    8000655a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000655e:	854a                	mv	a0,s2
    80006560:	ffffe097          	auipc	ra,0xffffe
    80006564:	f4e080e7          	jalr	-178(ra) # 800044ae <iupdate>
  iunlockput(ip);
    80006568:	854a                	mv	a0,s2
    8000656a:	ffffe097          	auipc	ra,0xffffe
    8000656e:	276080e7          	jalr	630(ra) # 800047e0 <iunlockput>
  end_op();
    80006572:	fffff097          	auipc	ra,0xfffff
    80006576:	a6c080e7          	jalr	-1428(ra) # 80004fde <end_op>
  return 0;
    8000657a:	4501                	li	a0,0
    8000657c:	74ae                	ld	s1,232(sp)
    8000657e:	790e                	ld	s2,224(sp)
    80006580:	69ee                	ld	s3,216(sp)
    80006582:	a86d                	j	8000663c <sys_unlink+0x1d2>
    end_op();
    80006584:	fffff097          	auipc	ra,0xfffff
    80006588:	a5a080e7          	jalr	-1446(ra) # 80004fde <end_op>
    return -1;
    8000658c:	557d                	li	a0,-1
    8000658e:	74ae                	ld	s1,232(sp)
    80006590:	a075                	j	8000663c <sys_unlink+0x1d2>
    80006592:	e9d2                	sd	s4,208(sp)
    80006594:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80006596:	00005517          	auipc	a0,0x5
    8000659a:	0f250513          	addi	a0,a0,242 # 8000b688 <etext+0x688>
    8000659e:	ffffa097          	auipc	ra,0xffffa
    800065a2:	fc2080e7          	jalr	-62(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800065a6:	04c92703          	lw	a4,76(s2)
    800065aa:	02000793          	li	a5,32
    800065ae:	f6e7f3e3          	bgeu	a5,a4,80006514 <sys_unlink+0xaa>
    800065b2:	e9d2                	sd	s4,208(sp)
    800065b4:	e5d6                	sd	s5,200(sp)
    800065b6:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800065b8:	f0840a93          	addi	s5,s0,-248
    800065bc:	4a41                	li	s4,16
    800065be:	8752                	mv	a4,s4
    800065c0:	86ce                	mv	a3,s3
    800065c2:	8656                	mv	a2,s5
    800065c4:	4581                	li	a1,0
    800065c6:	854a                	mv	a0,s2
    800065c8:	ffffe097          	auipc	ra,0xffffe
    800065cc:	26e080e7          	jalr	622(ra) # 80004836 <readi>
    800065d0:	01451d63          	bne	a0,s4,800065ea <sys_unlink+0x180>
    if(de.inum != 0)
    800065d4:	f0845783          	lhu	a5,-248(s0)
    800065d8:	eba5                	bnez	a5,80006648 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800065da:	29c1                	addiw	s3,s3,16
    800065dc:	04c92783          	lw	a5,76(s2)
    800065e0:	fcf9efe3          	bltu	s3,a5,800065be <sys_unlink+0x154>
    800065e4:	6a4e                	ld	s4,208(sp)
    800065e6:	6aae                	ld	s5,200(sp)
    800065e8:	b735                	j	80006514 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800065ea:	00005517          	auipc	a0,0x5
    800065ee:	0b650513          	addi	a0,a0,182 # 8000b6a0 <etext+0x6a0>
    800065f2:	ffffa097          	auipc	ra,0xffffa
    800065f6:	f6e080e7          	jalr	-146(ra) # 80000560 <panic>
    800065fa:	e9d2                	sd	s4,208(sp)
    800065fc:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800065fe:	00005517          	auipc	a0,0x5
    80006602:	0ba50513          	addi	a0,a0,186 # 8000b6b8 <etext+0x6b8>
    80006606:	ffffa097          	auipc	ra,0xffffa
    8000660a:	f5a080e7          	jalr	-166(ra) # 80000560 <panic>
    dp->nlink--;
    8000660e:	04a4d783          	lhu	a5,74(s1)
    80006612:	37fd                	addiw	a5,a5,-1
    80006614:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006618:	8526                	mv	a0,s1
    8000661a:	ffffe097          	auipc	ra,0xffffe
    8000661e:	e94080e7          	jalr	-364(ra) # 800044ae <iupdate>
    80006622:	b725                	j	8000654a <sys_unlink+0xe0>
    80006624:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80006626:	8526                	mv	a0,s1
    80006628:	ffffe097          	auipc	ra,0xffffe
    8000662c:	1b8080e7          	jalr	440(ra) # 800047e0 <iunlockput>
  end_op();
    80006630:	fffff097          	auipc	ra,0xfffff
    80006634:	9ae080e7          	jalr	-1618(ra) # 80004fde <end_op>
  return -1;
    80006638:	557d                	li	a0,-1
    8000663a:	74ae                	ld	s1,232(sp)
}
    8000663c:	70ee                	ld	ra,248(sp)
    8000663e:	744e                	ld	s0,240(sp)
    80006640:	6111                	addi	sp,sp,256
    80006642:	8082                	ret
    return -1;
    80006644:	557d                	li	a0,-1
    80006646:	bfdd                	j	8000663c <sys_unlink+0x1d2>
    iunlockput(ip);
    80006648:	854a                	mv	a0,s2
    8000664a:	ffffe097          	auipc	ra,0xffffe
    8000664e:	196080e7          	jalr	406(ra) # 800047e0 <iunlockput>
    goto bad;
    80006652:	790e                	ld	s2,224(sp)
    80006654:	69ee                	ld	s3,216(sp)
    80006656:	6a4e                	ld	s4,208(sp)
    80006658:	6aae                	ld	s5,200(sp)
    8000665a:	b7f1                	j	80006626 <sys_unlink+0x1bc>

000000008000665c <sys_open>:

uint64
sys_open(void)
{
    8000665c:	7131                	addi	sp,sp,-192
    8000665e:	fd06                	sd	ra,184(sp)
    80006660:	f922                	sd	s0,176(sp)
    80006662:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80006664:	f4c40593          	addi	a1,s0,-180
    80006668:	4505                	li	a0,1
    8000666a:	ffffd097          	auipc	ra,0xffffd
    8000666e:	e06080e7          	jalr	-506(ra) # 80003470 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006672:	08000613          	li	a2,128
    80006676:	f5040593          	addi	a1,s0,-176
    8000667a:	4501                	li	a0,0
    8000667c:	ffffd097          	auipc	ra,0xffffd
    80006680:	e34080e7          	jalr	-460(ra) # 800034b0 <argstr>
    80006684:	87aa                	mv	a5,a0
    return -1;
    80006686:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006688:	0a07cf63          	bltz	a5,80006746 <sys_open+0xea>
    8000668c:	f526                	sd	s1,168(sp)

  begin_op();
    8000668e:	fffff097          	auipc	ra,0xfffff
    80006692:	8d6080e7          	jalr	-1834(ra) # 80004f64 <begin_op>

  if(omode & O_CREATE){
    80006696:	f4c42783          	lw	a5,-180(s0)
    8000669a:	2007f793          	andi	a5,a5,512
    8000669e:	cfdd                	beqz	a5,8000675c <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    800066a0:	4681                	li	a3,0
    800066a2:	4601                	li	a2,0
    800066a4:	4589                	li	a1,2
    800066a6:	f5040513          	addi	a0,s0,-176
    800066aa:	00000097          	auipc	ra,0x0
    800066ae:	90a080e7          	jalr	-1782(ra) # 80005fb4 <create>
    800066b2:	84aa                	mv	s1,a0
    if(ip == 0){
    800066b4:	cd49                	beqz	a0,8000674e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800066b6:	04449703          	lh	a4,68(s1)
    800066ba:	478d                	li	a5,3
    800066bc:	00f71763          	bne	a4,a5,800066ca <sys_open+0x6e>
    800066c0:	0464d703          	lhu	a4,70(s1)
    800066c4:	47a5                	li	a5,9
    800066c6:	0ee7e263          	bltu	a5,a4,800067aa <sys_open+0x14e>
    800066ca:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800066cc:	fffff097          	auipc	ra,0xfffff
    800066d0:	cac080e7          	jalr	-852(ra) # 80005378 <filealloc>
    800066d4:	892a                	mv	s2,a0
    800066d6:	cd65                	beqz	a0,800067ce <sys_open+0x172>
    800066d8:	ed4e                	sd	s3,152(sp)
    800066da:	00000097          	auipc	ra,0x0
    800066de:	a60080e7          	jalr	-1440(ra) # 8000613a <fdalloc>
    800066e2:	89aa                	mv	s3,a0
    800066e4:	0c054f63          	bltz	a0,800067c2 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800066e8:	04449703          	lh	a4,68(s1)
    800066ec:	478d                	li	a5,3
    800066ee:	0ef70d63          	beq	a4,a5,800067e8 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800066f2:	4789                	li	a5,2
    800066f4:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800066f8:	02092423          	sw	zero,40(s2)
  }
  f->ip = ip;
    800066fc:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006700:	f4c42783          	lw	a5,-180(s0)
    80006704:	0017f713          	andi	a4,a5,1
    80006708:	00174713          	xori	a4,a4,1
    8000670c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006710:	0037f713          	andi	a4,a5,3
    80006714:	00e03733          	snez	a4,a4
    80006718:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000671c:	4007f793          	andi	a5,a5,1024
    80006720:	c791                	beqz	a5,8000672c <sys_open+0xd0>
    80006722:	04449703          	lh	a4,68(s1)
    80006726:	4789                	li	a5,2
    80006728:	0cf70763          	beq	a4,a5,800067f6 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    8000672c:	8526                	mv	a0,s1
    8000672e:	ffffe097          	auipc	ra,0xffffe
    80006732:	f12080e7          	jalr	-238(ra) # 80004640 <iunlock>
  end_op();
    80006736:	fffff097          	auipc	ra,0xfffff
    8000673a:	8a8080e7          	jalr	-1880(ra) # 80004fde <end_op>

  return fd;
    8000673e:	854e                	mv	a0,s3
    80006740:	74aa                	ld	s1,168(sp)
    80006742:	790a                	ld	s2,160(sp)
    80006744:	69ea                	ld	s3,152(sp)
}
    80006746:	70ea                	ld	ra,184(sp)
    80006748:	744a                	ld	s0,176(sp)
    8000674a:	6129                	addi	sp,sp,192
    8000674c:	8082                	ret
      end_op();
    8000674e:	fffff097          	auipc	ra,0xfffff
    80006752:	890080e7          	jalr	-1904(ra) # 80004fde <end_op>
      return -1;
    80006756:	557d                	li	a0,-1
    80006758:	74aa                	ld	s1,168(sp)
    8000675a:	b7f5                	j	80006746 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    8000675c:	f5040513          	addi	a0,s0,-176
    80006760:	ffffe097          	auipc	ra,0xffffe
    80006764:	5fe080e7          	jalr	1534(ra) # 80004d5e <namei>
    80006768:	84aa                	mv	s1,a0
    8000676a:	c90d                	beqz	a0,8000679c <sys_open+0x140>
    ilock(ip);
    8000676c:	ffffe097          	auipc	ra,0xffffe
    80006770:	e0e080e7          	jalr	-498(ra) # 8000457a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006774:	04449703          	lh	a4,68(s1)
    80006778:	4785                	li	a5,1
    8000677a:	f2f71ee3          	bne	a4,a5,800066b6 <sys_open+0x5a>
    8000677e:	f4c42783          	lw	a5,-180(s0)
    80006782:	d7a1                	beqz	a5,800066ca <sys_open+0x6e>
      iunlockput(ip);
    80006784:	8526                	mv	a0,s1
    80006786:	ffffe097          	auipc	ra,0xffffe
    8000678a:	05a080e7          	jalr	90(ra) # 800047e0 <iunlockput>
      end_op();
    8000678e:	fffff097          	auipc	ra,0xfffff
    80006792:	850080e7          	jalr	-1968(ra) # 80004fde <end_op>
      return -1;
    80006796:	557d                	li	a0,-1
    80006798:	74aa                	ld	s1,168(sp)
    8000679a:	b775                	j	80006746 <sys_open+0xea>
      end_op();
    8000679c:	fffff097          	auipc	ra,0xfffff
    800067a0:	842080e7          	jalr	-1982(ra) # 80004fde <end_op>
      return -1;
    800067a4:	557d                	li	a0,-1
    800067a6:	74aa                	ld	s1,168(sp)
    800067a8:	bf79                	j	80006746 <sys_open+0xea>
    iunlockput(ip);
    800067aa:	8526                	mv	a0,s1
    800067ac:	ffffe097          	auipc	ra,0xffffe
    800067b0:	034080e7          	jalr	52(ra) # 800047e0 <iunlockput>
    end_op();
    800067b4:	fffff097          	auipc	ra,0xfffff
    800067b8:	82a080e7          	jalr	-2006(ra) # 80004fde <end_op>
    return -1;
    800067bc:	557d                	li	a0,-1
    800067be:	74aa                	ld	s1,168(sp)
    800067c0:	b759                	j	80006746 <sys_open+0xea>
      fileclose(f);
    800067c2:	854a                	mv	a0,s2
    800067c4:	fffff097          	auipc	ra,0xfffff
    800067c8:	c70080e7          	jalr	-912(ra) # 80005434 <fileclose>
    800067cc:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800067ce:	8526                	mv	a0,s1
    800067d0:	ffffe097          	auipc	ra,0xffffe
    800067d4:	010080e7          	jalr	16(ra) # 800047e0 <iunlockput>
    end_op();
    800067d8:	fffff097          	auipc	ra,0xfffff
    800067dc:	806080e7          	jalr	-2042(ra) # 80004fde <end_op>
    return -1;
    800067e0:	557d                	li	a0,-1
    800067e2:	74aa                	ld	s1,168(sp)
    800067e4:	790a                	ld	s2,160(sp)
    800067e6:	b785                	j	80006746 <sys_open+0xea>
    f->type = FD_DEVICE;
    800067e8:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800067ec:	04649783          	lh	a5,70(s1)
    800067f0:	02f91623          	sh	a5,44(s2)
    800067f4:	b721                	j	800066fc <sys_open+0xa0>
    itrunc(ip);
    800067f6:	8526                	mv	a0,s1
    800067f8:	ffffe097          	auipc	ra,0xffffe
    800067fc:	e94080e7          	jalr	-364(ra) # 8000468c <itrunc>
    80006800:	b735                	j	8000672c <sys_open+0xd0>

0000000080006802 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006802:	7175                	addi	sp,sp,-144
    80006804:	e506                	sd	ra,136(sp)
    80006806:	e122                	sd	s0,128(sp)
    80006808:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000680a:	ffffe097          	auipc	ra,0xffffe
    8000680e:	75a080e7          	jalr	1882(ra) # 80004f64 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006812:	08000613          	li	a2,128
    80006816:	f7040593          	addi	a1,s0,-144
    8000681a:	4501                	li	a0,0
    8000681c:	ffffd097          	auipc	ra,0xffffd
    80006820:	c94080e7          	jalr	-876(ra) # 800034b0 <argstr>
    80006824:	02054963          	bltz	a0,80006856 <sys_mkdir+0x54>
    80006828:	4681                	li	a3,0
    8000682a:	4601                	li	a2,0
    8000682c:	4585                	li	a1,1
    8000682e:	f7040513          	addi	a0,s0,-144
    80006832:	fffff097          	auipc	ra,0xfffff
    80006836:	782080e7          	jalr	1922(ra) # 80005fb4 <create>
    8000683a:	cd11                	beqz	a0,80006856 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000683c:	ffffe097          	auipc	ra,0xffffe
    80006840:	fa4080e7          	jalr	-92(ra) # 800047e0 <iunlockput>
  end_op();
    80006844:	ffffe097          	auipc	ra,0xffffe
    80006848:	79a080e7          	jalr	1946(ra) # 80004fde <end_op>
  return 0;
    8000684c:	4501                	li	a0,0
}
    8000684e:	60aa                	ld	ra,136(sp)
    80006850:	640a                	ld	s0,128(sp)
    80006852:	6149                	addi	sp,sp,144
    80006854:	8082                	ret
    end_op();
    80006856:	ffffe097          	auipc	ra,0xffffe
    8000685a:	788080e7          	jalr	1928(ra) # 80004fde <end_op>
    return -1;
    8000685e:	557d                	li	a0,-1
    80006860:	b7fd                	j	8000684e <sys_mkdir+0x4c>

0000000080006862 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006862:	7135                	addi	sp,sp,-160
    80006864:	ed06                	sd	ra,152(sp)
    80006866:	e922                	sd	s0,144(sp)
    80006868:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000686a:	ffffe097          	auipc	ra,0xffffe
    8000686e:	6fa080e7          	jalr	1786(ra) # 80004f64 <begin_op>
  argint(1, &major);
    80006872:	f6c40593          	addi	a1,s0,-148
    80006876:	4505                	li	a0,1
    80006878:	ffffd097          	auipc	ra,0xffffd
    8000687c:	bf8080e7          	jalr	-1032(ra) # 80003470 <argint>
  argint(2, &minor);
    80006880:	f6840593          	addi	a1,s0,-152
    80006884:	4509                	li	a0,2
    80006886:	ffffd097          	auipc	ra,0xffffd
    8000688a:	bea080e7          	jalr	-1046(ra) # 80003470 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000688e:	08000613          	li	a2,128
    80006892:	f7040593          	addi	a1,s0,-144
    80006896:	4501                	li	a0,0
    80006898:	ffffd097          	auipc	ra,0xffffd
    8000689c:	c18080e7          	jalr	-1000(ra) # 800034b0 <argstr>
    800068a0:	02054b63          	bltz	a0,800068d6 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800068a4:	f6841683          	lh	a3,-152(s0)
    800068a8:	f6c41603          	lh	a2,-148(s0)
    800068ac:	458d                	li	a1,3
    800068ae:	f7040513          	addi	a0,s0,-144
    800068b2:	fffff097          	auipc	ra,0xfffff
    800068b6:	702080e7          	jalr	1794(ra) # 80005fb4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800068ba:	cd11                	beqz	a0,800068d6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800068bc:	ffffe097          	auipc	ra,0xffffe
    800068c0:	f24080e7          	jalr	-220(ra) # 800047e0 <iunlockput>
  end_op();
    800068c4:	ffffe097          	auipc	ra,0xffffe
    800068c8:	71a080e7          	jalr	1818(ra) # 80004fde <end_op>
  return 0;
    800068cc:	4501                	li	a0,0
}
    800068ce:	60ea                	ld	ra,152(sp)
    800068d0:	644a                	ld	s0,144(sp)
    800068d2:	610d                	addi	sp,sp,160
    800068d4:	8082                	ret
    end_op();
    800068d6:	ffffe097          	auipc	ra,0xffffe
    800068da:	708080e7          	jalr	1800(ra) # 80004fde <end_op>
    return -1;
    800068de:	557d                	li	a0,-1
    800068e0:	b7fd                	j	800068ce <sys_mknod+0x6c>

00000000800068e2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800068e2:	7135                	addi	sp,sp,-160
    800068e4:	ed06                	sd	ra,152(sp)
    800068e6:	e922                	sd	s0,144(sp)
    800068e8:	e14a                	sd	s2,128(sp)
    800068ea:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800068ec:	ffffb097          	auipc	ra,0xffffb
    800068f0:	56e080e7          	jalr	1390(ra) # 80001e5a <myproc>
    800068f4:	892a                	mv	s2,a0
  
  begin_op();
    800068f6:	ffffe097          	auipc	ra,0xffffe
    800068fa:	66e080e7          	jalr	1646(ra) # 80004f64 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800068fe:	08000613          	li	a2,128
    80006902:	f6040593          	addi	a1,s0,-160
    80006906:	4501                	li	a0,0
    80006908:	ffffd097          	auipc	ra,0xffffd
    8000690c:	ba8080e7          	jalr	-1112(ra) # 800034b0 <argstr>
    80006910:	04054d63          	bltz	a0,8000696a <sys_chdir+0x88>
    80006914:	e526                	sd	s1,136(sp)
    80006916:	f6040513          	addi	a0,s0,-160
    8000691a:	ffffe097          	auipc	ra,0xffffe
    8000691e:	444080e7          	jalr	1092(ra) # 80004d5e <namei>
    80006922:	84aa                	mv	s1,a0
    80006924:	c131                	beqz	a0,80006968 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006926:	ffffe097          	auipc	ra,0xffffe
    8000692a:	c54080e7          	jalr	-940(ra) # 8000457a <ilock>
  if(ip->type != T_DIR){
    8000692e:	04449703          	lh	a4,68(s1)
    80006932:	4785                	li	a5,1
    80006934:	04f71163          	bne	a4,a5,80006976 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006938:	8526                	mv	a0,s1
    8000693a:	ffffe097          	auipc	ra,0xffffe
    8000693e:	d06080e7          	jalr	-762(ra) # 80004640 <iunlock>
  iput(p->cwd);
    80006942:	15093503          	ld	a0,336(s2)
    80006946:	ffffe097          	auipc	ra,0xffffe
    8000694a:	df2080e7          	jalr	-526(ra) # 80004738 <iput>
  end_op();
    8000694e:	ffffe097          	auipc	ra,0xffffe
    80006952:	690080e7          	jalr	1680(ra) # 80004fde <end_op>
  p->cwd = ip;
    80006956:	14993823          	sd	s1,336(s2)
  return 0;
    8000695a:	4501                	li	a0,0
    8000695c:	64aa                	ld	s1,136(sp)
}
    8000695e:	60ea                	ld	ra,152(sp)
    80006960:	644a                	ld	s0,144(sp)
    80006962:	690a                	ld	s2,128(sp)
    80006964:	610d                	addi	sp,sp,160
    80006966:	8082                	ret
    80006968:	64aa                	ld	s1,136(sp)
    end_op();
    8000696a:	ffffe097          	auipc	ra,0xffffe
    8000696e:	674080e7          	jalr	1652(ra) # 80004fde <end_op>
    return -1;
    80006972:	557d                	li	a0,-1
    80006974:	b7ed                	j	8000695e <sys_chdir+0x7c>
    iunlockput(ip);
    80006976:	8526                	mv	a0,s1
    80006978:	ffffe097          	auipc	ra,0xffffe
    8000697c:	e68080e7          	jalr	-408(ra) # 800047e0 <iunlockput>
    end_op();
    80006980:	ffffe097          	auipc	ra,0xffffe
    80006984:	65e080e7          	jalr	1630(ra) # 80004fde <end_op>
    return -1;
    80006988:	557d                	li	a0,-1
    8000698a:	64aa                	ld	s1,136(sp)
    8000698c:	bfc9                	j	8000695e <sys_chdir+0x7c>

000000008000698e <sys_exec>:

uint64
sys_exec(void)
{
    8000698e:	7105                	addi	sp,sp,-480
    80006990:	ef86                	sd	ra,472(sp)
    80006992:	eba2                	sd	s0,464(sp)
    80006994:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006996:	e2840593          	addi	a1,s0,-472
    8000699a:	4505                	li	a0,1
    8000699c:	ffffd097          	auipc	ra,0xffffd
    800069a0:	af4080e7          	jalr	-1292(ra) # 80003490 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800069a4:	08000613          	li	a2,128
    800069a8:	f3040593          	addi	a1,s0,-208
    800069ac:	4501                	li	a0,0
    800069ae:	ffffd097          	auipc	ra,0xffffd
    800069b2:	b02080e7          	jalr	-1278(ra) # 800034b0 <argstr>
    800069b6:	87aa                	mv	a5,a0
    return -1;
    800069b8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800069ba:	0e07ce63          	bltz	a5,80006ab6 <sys_exec+0x128>
    800069be:	e7a6                	sd	s1,456(sp)
    800069c0:	e3ca                	sd	s2,448(sp)
    800069c2:	ff4e                	sd	s3,440(sp)
    800069c4:	fb52                	sd	s4,432(sp)
    800069c6:	f756                	sd	s5,424(sp)
    800069c8:	f35a                	sd	s6,416(sp)
    800069ca:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800069cc:	e3040a13          	addi	s4,s0,-464
    800069d0:	10000613          	li	a2,256
    800069d4:	4581                	li	a1,0
    800069d6:	8552                	mv	a0,s4
    800069d8:	ffffa097          	auipc	ra,0xffffa
    800069dc:	436080e7          	jalr	1078(ra) # 80000e0e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800069e0:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800069e2:	89d2                	mv	s3,s4
    800069e4:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800069e6:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800069ea:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800069ec:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800069f0:	00391513          	slli	a0,s2,0x3
    800069f4:	85d6                	mv	a1,s5
    800069f6:	e2843783          	ld	a5,-472(s0)
    800069fa:	953e                	add	a0,a0,a5
    800069fc:	ffffd097          	auipc	ra,0xffffd
    80006a00:	9d6080e7          	jalr	-1578(ra) # 800033d2 <fetchaddr>
    80006a04:	02054a63          	bltz	a0,80006a38 <sys_exec+0xaa>
    if(uarg == 0){
    80006a08:	e2043783          	ld	a5,-480(s0)
    80006a0c:	cbb1                	beqz	a5,80006a60 <sys_exec+0xd2>
    argv[i] = kalloc();
    80006a0e:	ffffa097          	auipc	ra,0xffffa
    80006a12:	1f6080e7          	jalr	502(ra) # 80000c04 <kalloc>
    80006a16:	85aa                	mv	a1,a0
    80006a18:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006a1c:	cd11                	beqz	a0,80006a38 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006a1e:	865a                	mv	a2,s6
    80006a20:	e2043503          	ld	a0,-480(s0)
    80006a24:	ffffd097          	auipc	ra,0xffffd
    80006a28:	a00080e7          	jalr	-1536(ra) # 80003424 <fetchstr>
    80006a2c:	00054663          	bltz	a0,80006a38 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80006a30:	0905                	addi	s2,s2,1
    80006a32:	09a1                	addi	s3,s3,8
    80006a34:	fb791ee3          	bne	s2,s7,800069f0 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a38:	100a0a13          	addi	s4,s4,256
    80006a3c:	6088                	ld	a0,0(s1)
    80006a3e:	c525                	beqz	a0,80006aa6 <sys_exec+0x118>
    kfree(argv[i]);
    80006a40:	ffffa097          	auipc	ra,0xffffa
    80006a44:	05c080e7          	jalr	92(ra) # 80000a9c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a48:	04a1                	addi	s1,s1,8
    80006a4a:	ff4499e3          	bne	s1,s4,80006a3c <sys_exec+0xae>
  return -1;
    80006a4e:	557d                	li	a0,-1
    80006a50:	64be                	ld	s1,456(sp)
    80006a52:	691e                	ld	s2,448(sp)
    80006a54:	79fa                	ld	s3,440(sp)
    80006a56:	7a5a                	ld	s4,432(sp)
    80006a58:	7aba                	ld	s5,424(sp)
    80006a5a:	7b1a                	ld	s6,416(sp)
    80006a5c:	6bfa                	ld	s7,408(sp)
    80006a5e:	a8a1                	j	80006ab6 <sys_exec+0x128>
      argv[i] = 0;
    80006a60:	0009079b          	sext.w	a5,s2
    80006a64:	e3040593          	addi	a1,s0,-464
    80006a68:	078e                	slli	a5,a5,0x3
    80006a6a:	97ae                	add	a5,a5,a1
    80006a6c:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80006a70:	f3040513          	addi	a0,s0,-208
    80006a74:	fffff097          	auipc	ra,0xfffff
    80006a78:	118080e7          	jalr	280(ra) # 80005b8c <exec>
    80006a7c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a7e:	100a0a13          	addi	s4,s4,256
    80006a82:	6088                	ld	a0,0(s1)
    80006a84:	c901                	beqz	a0,80006a94 <sys_exec+0x106>
    kfree(argv[i]);
    80006a86:	ffffa097          	auipc	ra,0xffffa
    80006a8a:	016080e7          	jalr	22(ra) # 80000a9c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a8e:	04a1                	addi	s1,s1,8
    80006a90:	ff4499e3          	bne	s1,s4,80006a82 <sys_exec+0xf4>
  return ret;
    80006a94:	854a                	mv	a0,s2
    80006a96:	64be                	ld	s1,456(sp)
    80006a98:	691e                	ld	s2,448(sp)
    80006a9a:	79fa                	ld	s3,440(sp)
    80006a9c:	7a5a                	ld	s4,432(sp)
    80006a9e:	7aba                	ld	s5,424(sp)
    80006aa0:	7b1a                	ld	s6,416(sp)
    80006aa2:	6bfa                	ld	s7,408(sp)
    80006aa4:	a809                	j	80006ab6 <sys_exec+0x128>
  return -1;
    80006aa6:	557d                	li	a0,-1
    80006aa8:	64be                	ld	s1,456(sp)
    80006aaa:	691e                	ld	s2,448(sp)
    80006aac:	79fa                	ld	s3,440(sp)
    80006aae:	7a5a                	ld	s4,432(sp)
    80006ab0:	7aba                	ld	s5,424(sp)
    80006ab2:	7b1a                	ld	s6,416(sp)
    80006ab4:	6bfa                	ld	s7,408(sp)
}
    80006ab6:	60fe                	ld	ra,472(sp)
    80006ab8:	645e                	ld	s0,464(sp)
    80006aba:	613d                	addi	sp,sp,480
    80006abc:	8082                	ret

0000000080006abe <sys_pipe>:

uint64
sys_pipe(void)
{
    80006abe:	7139                	addi	sp,sp,-64
    80006ac0:	fc06                	sd	ra,56(sp)
    80006ac2:	f822                	sd	s0,48(sp)
    80006ac4:	f426                	sd	s1,40(sp)
    80006ac6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006ac8:	ffffb097          	auipc	ra,0xffffb
    80006acc:	392080e7          	jalr	914(ra) # 80001e5a <myproc>
    80006ad0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006ad2:	fd840593          	addi	a1,s0,-40
    80006ad6:	4501                	li	a0,0
    80006ad8:	ffffd097          	auipc	ra,0xffffd
    80006adc:	9b8080e7          	jalr	-1608(ra) # 80003490 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006ae0:	fc840593          	addi	a1,s0,-56
    80006ae4:	fd040513          	addi	a0,s0,-48
    80006ae8:	fffff097          	auipc	ra,0xfffff
    80006aec:	d0e080e7          	jalr	-754(ra) # 800057f6 <pipealloc>
    return -1;
    80006af0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006af2:	0c054463          	bltz	a0,80006bba <sys_pipe+0xfc>
  fd0 = -1;
    80006af6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006afa:	fd043503          	ld	a0,-48(s0)
    80006afe:	fffff097          	auipc	ra,0xfffff
    80006b02:	63c080e7          	jalr	1596(ra) # 8000613a <fdalloc>
    80006b06:	fca42223          	sw	a0,-60(s0)
    80006b0a:	08054b63          	bltz	a0,80006ba0 <sys_pipe+0xe2>
    80006b0e:	fc843503          	ld	a0,-56(s0)
    80006b12:	fffff097          	auipc	ra,0xfffff
    80006b16:	628080e7          	jalr	1576(ra) # 8000613a <fdalloc>
    80006b1a:	fca42023          	sw	a0,-64(s0)
    80006b1e:	06054863          	bltz	a0,80006b8e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006b22:	4691                	li	a3,4
    80006b24:	fc440613          	addi	a2,s0,-60
    80006b28:	fd843583          	ld	a1,-40(s0)
    80006b2c:	68a8                	ld	a0,80(s1)
    80006b2e:	ffffb097          	auipc	ra,0xffffb
    80006b32:	fd4080e7          	jalr	-44(ra) # 80001b02 <copyout>
    80006b36:	02054063          	bltz	a0,80006b56 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006b3a:	4691                	li	a3,4
    80006b3c:	fc040613          	addi	a2,s0,-64
    80006b40:	fd843583          	ld	a1,-40(s0)
    80006b44:	95b6                	add	a1,a1,a3
    80006b46:	68a8                	ld	a0,80(s1)
    80006b48:	ffffb097          	auipc	ra,0xffffb
    80006b4c:	fba080e7          	jalr	-70(ra) # 80001b02 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006b50:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006b52:	06055463          	bgez	a0,80006bba <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006b56:	fc442783          	lw	a5,-60(s0)
    80006b5a:	07e9                	addi	a5,a5,26
    80006b5c:	078e                	slli	a5,a5,0x3
    80006b5e:	97a6                	add	a5,a5,s1
    80006b60:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006b64:	fc042783          	lw	a5,-64(s0)
    80006b68:	07e9                	addi	a5,a5,26
    80006b6a:	078e                	slli	a5,a5,0x3
    80006b6c:	94be                	add	s1,s1,a5
    80006b6e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006b72:	fd043503          	ld	a0,-48(s0)
    80006b76:	fffff097          	auipc	ra,0xfffff
    80006b7a:	8be080e7          	jalr	-1858(ra) # 80005434 <fileclose>
    fileclose(wf);
    80006b7e:	fc843503          	ld	a0,-56(s0)
    80006b82:	fffff097          	auipc	ra,0xfffff
    80006b86:	8b2080e7          	jalr	-1870(ra) # 80005434 <fileclose>
    return -1;
    80006b8a:	57fd                	li	a5,-1
    80006b8c:	a03d                	j	80006bba <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006b8e:	fc442783          	lw	a5,-60(s0)
    80006b92:	0007c763          	bltz	a5,80006ba0 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006b96:	07e9                	addi	a5,a5,26
    80006b98:	078e                	slli	a5,a5,0x3
    80006b9a:	97a6                	add	a5,a5,s1
    80006b9c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006ba0:	fd043503          	ld	a0,-48(s0)
    80006ba4:	fffff097          	auipc	ra,0xfffff
    80006ba8:	890080e7          	jalr	-1904(ra) # 80005434 <fileclose>
    fileclose(wf);
    80006bac:	fc843503          	ld	a0,-56(s0)
    80006bb0:	fffff097          	auipc	ra,0xfffff
    80006bb4:	884080e7          	jalr	-1916(ra) # 80005434 <fileclose>
    return -1;
    80006bb8:	57fd                	li	a5,-1
}
    80006bba:	853e                	mv	a0,a5
    80006bbc:	70e2                	ld	ra,56(sp)
    80006bbe:	7442                	ld	s0,48(sp)
    80006bc0:	74a2                	ld	s1,40(sp)
    80006bc2:	6121                	addi	sp,sp,64
    80006bc4:	8082                	ret
	...

0000000080006bd0 <kernelvec>:
    80006bd0:	7111                	addi	sp,sp,-256
    80006bd2:	e006                	sd	ra,0(sp)
    80006bd4:	e40a                	sd	sp,8(sp)
    80006bd6:	e80e                	sd	gp,16(sp)
    80006bd8:	ec12                	sd	tp,24(sp)
    80006bda:	f016                	sd	t0,32(sp)
    80006bdc:	f41a                	sd	t1,40(sp)
    80006bde:	f81e                	sd	t2,48(sp)
    80006be0:	fc22                	sd	s0,56(sp)
    80006be2:	e0a6                	sd	s1,64(sp)
    80006be4:	e4aa                	sd	a0,72(sp)
    80006be6:	e8ae                	sd	a1,80(sp)
    80006be8:	ecb2                	sd	a2,88(sp)
    80006bea:	f0b6                	sd	a3,96(sp)
    80006bec:	f4ba                	sd	a4,104(sp)
    80006bee:	f8be                	sd	a5,112(sp)
    80006bf0:	fcc2                	sd	a6,120(sp)
    80006bf2:	e146                	sd	a7,128(sp)
    80006bf4:	e54a                	sd	s2,136(sp)
    80006bf6:	e94e                	sd	s3,144(sp)
    80006bf8:	ed52                	sd	s4,152(sp)
    80006bfa:	f156                	sd	s5,160(sp)
    80006bfc:	f55a                	sd	s6,168(sp)
    80006bfe:	f95e                	sd	s7,176(sp)
    80006c00:	fd62                	sd	s8,184(sp)
    80006c02:	e1e6                	sd	s9,192(sp)
    80006c04:	e5ea                	sd	s10,200(sp)
    80006c06:	e9ee                	sd	s11,208(sp)
    80006c08:	edf2                	sd	t3,216(sp)
    80006c0a:	f1f6                	sd	t4,224(sp)
    80006c0c:	f5fa                	sd	t5,232(sp)
    80006c0e:	f9fe                	sd	t6,240(sp)
    80006c10:	e8efc0ef          	jal	8000329e <kerneltrap>
    80006c14:	6082                	ld	ra,0(sp)
    80006c16:	6122                	ld	sp,8(sp)
    80006c18:	61c2                	ld	gp,16(sp)
    80006c1a:	7282                	ld	t0,32(sp)
    80006c1c:	7322                	ld	t1,40(sp)
    80006c1e:	73c2                	ld	t2,48(sp)
    80006c20:	7462                	ld	s0,56(sp)
    80006c22:	6486                	ld	s1,64(sp)
    80006c24:	6526                	ld	a0,72(sp)
    80006c26:	65c6                	ld	a1,80(sp)
    80006c28:	6666                	ld	a2,88(sp)
    80006c2a:	7686                	ld	a3,96(sp)
    80006c2c:	7726                	ld	a4,104(sp)
    80006c2e:	77c6                	ld	a5,112(sp)
    80006c30:	7866                	ld	a6,120(sp)
    80006c32:	688a                	ld	a7,128(sp)
    80006c34:	692a                	ld	s2,136(sp)
    80006c36:	69ca                	ld	s3,144(sp)
    80006c38:	6a6a                	ld	s4,152(sp)
    80006c3a:	7a8a                	ld	s5,160(sp)
    80006c3c:	7b2a                	ld	s6,168(sp)
    80006c3e:	7bca                	ld	s7,176(sp)
    80006c40:	7c6a                	ld	s8,184(sp)
    80006c42:	6c8e                	ld	s9,192(sp)
    80006c44:	6d2e                	ld	s10,200(sp)
    80006c46:	6dce                	ld	s11,208(sp)
    80006c48:	6e6e                	ld	t3,216(sp)
    80006c4a:	7e8e                	ld	t4,224(sp)
    80006c4c:	7f2e                	ld	t5,232(sp)
    80006c4e:	7fce                	ld	t6,240(sp)
    80006c50:	6111                	addi	sp,sp,256
    80006c52:	10200073          	sret
    80006c56:	00000013          	nop
    80006c5a:	00000013          	nop
    80006c5e:	0001                	nop

0000000080006c60 <timervec>:
    80006c60:	34051573          	csrrw	a0,mscratch,a0
    80006c64:	e10c                	sd	a1,0(a0)
    80006c66:	e510                	sd	a2,8(a0)
    80006c68:	e914                	sd	a3,16(a0)
    80006c6a:	6d0c                	ld	a1,24(a0)
    80006c6c:	7110                	ld	a2,32(a0)
    80006c6e:	6194                	ld	a3,0(a1)
    80006c70:	96b2                	add	a3,a3,a2
    80006c72:	e194                	sd	a3,0(a1)
    80006c74:	4589                	li	a1,2
    80006c76:	14459073          	csrw	sip,a1
    80006c7a:	6914                	ld	a3,16(a0)
    80006c7c:	6510                	ld	a2,8(a0)
    80006c7e:	610c                	ld	a1,0(a0)
    80006c80:	34051573          	csrrw	a0,mscratch,a0
    80006c84:	30200073          	mret
	...

0000000080006c8a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80006c8a:	1141                	addi	sp,sp,-16
    80006c8c:	e406                	sd	ra,8(sp)
    80006c8e:	e022                	sd	s0,0(sp)
    80006c90:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006c92:	0c000737          	lui	a4,0xc000
    80006c96:	4785                	li	a5,1
    80006c98:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006c9a:	c35c                	sw	a5,4(a4)
  *(uint32*)(PLIC + VIRTIO1_IRQ*4) = 1;
    80006c9c:	c71c                	sw	a5,8(a4)
}
    80006c9e:	60a2                	ld	ra,8(sp)
    80006ca0:	6402                	ld	s0,0(sp)
    80006ca2:	0141                	addi	sp,sp,16
    80006ca4:	8082                	ret

0000000080006ca6 <plicinithart>:

void
plicinithart(void)
{
    80006ca6:	1141                	addi	sp,sp,-16
    80006ca8:	e406                	sd	ra,8(sp)
    80006caa:	e022                	sd	s0,0(sp)
    80006cac:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006cae:	ffffb097          	auipc	ra,0xffffb
    80006cb2:	178080e7          	jalr	376(ra) # 80001e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ) | (1 << VIRTIO1_IRQ);
    80006cb6:	0085171b          	slliw	a4,a0,0x8
    80006cba:	0c0027b7          	lui	a5,0xc002
    80006cbe:	97ba                	add	a5,a5,a4
    80006cc0:	40600713          	li	a4,1030
    80006cc4:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006cc8:	00d5151b          	slliw	a0,a0,0xd
    80006ccc:	0c2017b7          	lui	a5,0xc201
    80006cd0:	97aa                	add	a5,a5,a0
    80006cd2:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006cd6:	60a2                	ld	ra,8(sp)
    80006cd8:	6402                	ld	s0,0(sp)
    80006cda:	0141                	addi	sp,sp,16
    80006cdc:	8082                	ret

0000000080006cde <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006cde:	1141                	addi	sp,sp,-16
    80006ce0:	e406                	sd	ra,8(sp)
    80006ce2:	e022                	sd	s0,0(sp)
    80006ce4:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006ce6:	ffffb097          	auipc	ra,0xffffb
    80006cea:	140080e7          	jalr	320(ra) # 80001e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006cee:	00d5151b          	slliw	a0,a0,0xd
    80006cf2:	0c2017b7          	lui	a5,0xc201
    80006cf6:	97aa                	add	a5,a5,a0
  return irq;
}
    80006cf8:	43c8                	lw	a0,4(a5)
    80006cfa:	60a2                	ld	ra,8(sp)
    80006cfc:	6402                	ld	s0,0(sp)
    80006cfe:	0141                	addi	sp,sp,16
    80006d00:	8082                	ret

0000000080006d02 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006d02:	1101                	addi	sp,sp,-32
    80006d04:	ec06                	sd	ra,24(sp)
    80006d06:	e822                	sd	s0,16(sp)
    80006d08:	e426                	sd	s1,8(sp)
    80006d0a:	1000                	addi	s0,sp,32
    80006d0c:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006d0e:	ffffb097          	auipc	ra,0xffffb
    80006d12:	118080e7          	jalr	280(ra) # 80001e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006d16:	00d5179b          	slliw	a5,a0,0xd
    80006d1a:	0c201737          	lui	a4,0xc201
    80006d1e:	97ba                	add	a5,a5,a4
    80006d20:	c3c4                	sw	s1,4(a5)
}
    80006d22:	60e2                	ld	ra,24(sp)
    80006d24:	6442                	ld	s0,16(sp)
    80006d26:	64a2                	ld	s1,8(sp)
    80006d28:	6105                	addi	sp,sp,32
    80006d2a:	8082                	ret

0000000080006d2c <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006d2c:	1141                	addi	sp,sp,-16
    80006d2e:	e406                	sd	ra,8(sp)
    80006d30:	e022                	sd	s0,0(sp)
    80006d32:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006d34:	479d                	li	a5,7
    80006d36:	04a7cc63          	blt	a5,a0,80006d8e <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006d3a:	0006b797          	auipc	a5,0x6b
    80006d3e:	90678793          	addi	a5,a5,-1786 # 80071640 <disk>
    80006d42:	97aa                	add	a5,a5,a0
    80006d44:	0187c783          	lbu	a5,24(a5)
    80006d48:	ebb9                	bnez	a5,80006d9e <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006d4a:	00451693          	slli	a3,a0,0x4
    80006d4e:	0006b797          	auipc	a5,0x6b
    80006d52:	8f278793          	addi	a5,a5,-1806 # 80071640 <disk>
    80006d56:	6398                	ld	a4,0(a5)
    80006d58:	9736                	add	a4,a4,a3
    80006d5a:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80006d5e:	6398                	ld	a4,0(a5)
    80006d60:	9736                	add	a4,a4,a3
    80006d62:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006d66:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006d6a:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006d6e:	97aa                	add	a5,a5,a0
    80006d70:	4705                	li	a4,1
    80006d72:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006d76:	0006b517          	auipc	a0,0x6b
    80006d7a:	8e250513          	addi	a0,a0,-1822 # 80071658 <disk+0x18>
    80006d7e:	ffffc097          	auipc	ra,0xffffc
    80006d82:	9ee080e7          	jalr	-1554(ra) # 8000276c <wakeup>
}
    80006d86:	60a2                	ld	ra,8(sp)
    80006d88:	6402                	ld	s0,0(sp)
    80006d8a:	0141                	addi	sp,sp,16
    80006d8c:	8082                	ret
    panic("free_desc 1");
    80006d8e:	00005517          	auipc	a0,0x5
    80006d92:	93a50513          	addi	a0,a0,-1734 # 8000b6c8 <etext+0x6c8>
    80006d96:	ffff9097          	auipc	ra,0xffff9
    80006d9a:	7ca080e7          	jalr	1994(ra) # 80000560 <panic>
    panic("free_desc 2");
    80006d9e:	00005517          	auipc	a0,0x5
    80006da2:	93a50513          	addi	a0,a0,-1734 # 8000b6d8 <etext+0x6d8>
    80006da6:	ffff9097          	auipc	ra,0xffff9
    80006daa:	7ba080e7          	jalr	1978(ra) # 80000560 <panic>

0000000080006dae <virtio_disk_init>:
{
    80006dae:	1101                	addi	sp,sp,-32
    80006db0:	ec06                	sd	ra,24(sp)
    80006db2:	e822                	sd	s0,16(sp)
    80006db4:	e426                	sd	s1,8(sp)
    80006db6:	e04a                	sd	s2,0(sp)
    80006db8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006dba:	00005597          	auipc	a1,0x5
    80006dbe:	92e58593          	addi	a1,a1,-1746 # 8000b6e8 <etext+0x6e8>
    80006dc2:	0006b517          	auipc	a0,0x6b
    80006dc6:	9a650513          	addi	a0,a0,-1626 # 80071768 <disk+0x128>
    80006dca:	ffffa097          	auipc	ra,0xffffa
    80006dce:	eb8080e7          	jalr	-328(ra) # 80000c82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006dd2:	100017b7          	lui	a5,0x10001
    80006dd6:	4398                	lw	a4,0(a5)
    80006dd8:	2701                	sext.w	a4,a4
    80006dda:	747277b7          	lui	a5,0x74727
    80006dde:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006de2:	16f71463          	bne	a4,a5,80006f4a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006de6:	100017b7          	lui	a5,0x10001
    80006dea:	43dc                	lw	a5,4(a5)
    80006dec:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006dee:	4709                	li	a4,2
    80006df0:	14e79d63          	bne	a5,a4,80006f4a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006df4:	100017b7          	lui	a5,0x10001
    80006df8:	479c                	lw	a5,8(a5)
    80006dfa:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006dfc:	14e79763          	bne	a5,a4,80006f4a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006e00:	100017b7          	lui	a5,0x10001
    80006e04:	47d8                	lw	a4,12(a5)
    80006e06:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006e08:	554d47b7          	lui	a5,0x554d4
    80006e0c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006e10:	12f71d63          	bne	a4,a5,80006f4a <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e14:	100017b7          	lui	a5,0x10001
    80006e18:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e1c:	4705                	li	a4,1
    80006e1e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e20:	470d                	li	a4,3
    80006e22:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006e24:	10001737          	lui	a4,0x10001
    80006e28:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006e2a:	c7ffe6b7          	lui	a3,0xc7ffe
    80006e2e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f8ae67>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006e32:	8f75                	and	a4,a4,a3
    80006e34:	100016b7          	lui	a3,0x10001
    80006e38:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e3a:	472d                	li	a4,11
    80006e3c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006e3e:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006e42:	439c                	lw	a5,0(a5)
    80006e44:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006e48:	8ba1                	andi	a5,a5,8
    80006e4a:	10078863          	beqz	a5,80006f5a <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006e4e:	100017b7          	lui	a5,0x10001
    80006e52:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006e56:	43fc                	lw	a5,68(a5)
    80006e58:	2781                	sext.w	a5,a5
    80006e5a:	10079863          	bnez	a5,80006f6a <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006e5e:	100017b7          	lui	a5,0x10001
    80006e62:	5bdc                	lw	a5,52(a5)
    80006e64:	2781                	sext.w	a5,a5
  if(max == 0)
    80006e66:	10078a63          	beqz	a5,80006f7a <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006e6a:	471d                	li	a4,7
    80006e6c:	10f77f63          	bgeu	a4,a5,80006f8a <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    80006e70:	ffffa097          	auipc	ra,0xffffa
    80006e74:	d94080e7          	jalr	-620(ra) # 80000c04 <kalloc>
    80006e78:	0006a497          	auipc	s1,0x6a
    80006e7c:	7c848493          	addi	s1,s1,1992 # 80071640 <disk>
    80006e80:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006e82:	ffffa097          	auipc	ra,0xffffa
    80006e86:	d82080e7          	jalr	-638(ra) # 80000c04 <kalloc>
    80006e8a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006e8c:	ffffa097          	auipc	ra,0xffffa
    80006e90:	d78080e7          	jalr	-648(ra) # 80000c04 <kalloc>
    80006e94:	87aa                	mv	a5,a0
    80006e96:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006e98:	6088                	ld	a0,0(s1)
    80006e9a:	10050063          	beqz	a0,80006f9a <virtio_disk_init+0x1ec>
    80006e9e:	0006a717          	auipc	a4,0x6a
    80006ea2:	7aa73703          	ld	a4,1962(a4) # 80071648 <disk+0x8>
    80006ea6:	cb75                	beqz	a4,80006f9a <virtio_disk_init+0x1ec>
    80006ea8:	cbed                	beqz	a5,80006f9a <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006eaa:	6605                	lui	a2,0x1
    80006eac:	4581                	li	a1,0
    80006eae:	ffffa097          	auipc	ra,0xffffa
    80006eb2:	f60080e7          	jalr	-160(ra) # 80000e0e <memset>
  memset(disk.avail, 0, PGSIZE);
    80006eb6:	0006a497          	auipc	s1,0x6a
    80006eba:	78a48493          	addi	s1,s1,1930 # 80071640 <disk>
    80006ebe:	6605                	lui	a2,0x1
    80006ec0:	4581                	li	a1,0
    80006ec2:	6488                	ld	a0,8(s1)
    80006ec4:	ffffa097          	auipc	ra,0xffffa
    80006ec8:	f4a080e7          	jalr	-182(ra) # 80000e0e <memset>
  memset(disk.used, 0, PGSIZE);
    80006ecc:	6605                	lui	a2,0x1
    80006ece:	4581                	li	a1,0
    80006ed0:	6888                	ld	a0,16(s1)
    80006ed2:	ffffa097          	auipc	ra,0xffffa
    80006ed6:	f3c080e7          	jalr	-196(ra) # 80000e0e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006eda:	100017b7          	lui	a5,0x10001
    80006ede:	4721                	li	a4,8
    80006ee0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006ee2:	4098                	lw	a4,0(s1)
    80006ee4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006ee8:	40d8                	lw	a4,4(s1)
    80006eea:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006eee:	649c                	ld	a5,8(s1)
    80006ef0:	0007869b          	sext.w	a3,a5
    80006ef4:	10001737          	lui	a4,0x10001
    80006ef8:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006efc:	9781                	srai	a5,a5,0x20
    80006efe:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006f02:	689c                	ld	a5,16(s1)
    80006f04:	0007869b          	sext.w	a3,a5
    80006f08:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006f0c:	9781                	srai	a5,a5,0x20
    80006f0e:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006f12:	4785                	li	a5,1
    80006f14:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006f16:	00f48c23          	sb	a5,24(s1)
    80006f1a:	00f48ca3          	sb	a5,25(s1)
    80006f1e:	00f48d23          	sb	a5,26(s1)
    80006f22:	00f48da3          	sb	a5,27(s1)
    80006f26:	00f48e23          	sb	a5,28(s1)
    80006f2a:	00f48ea3          	sb	a5,29(s1)
    80006f2e:	00f48f23          	sb	a5,30(s1)
    80006f32:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006f36:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006f3a:	07272823          	sw	s2,112(a4)
}
    80006f3e:	60e2                	ld	ra,24(sp)
    80006f40:	6442                	ld	s0,16(sp)
    80006f42:	64a2                	ld	s1,8(sp)
    80006f44:	6902                	ld	s2,0(sp)
    80006f46:	6105                	addi	sp,sp,32
    80006f48:	8082                	ret
    panic("could not find virtio disk");
    80006f4a:	00004517          	auipc	a0,0x4
    80006f4e:	7ae50513          	addi	a0,a0,1966 # 8000b6f8 <etext+0x6f8>
    80006f52:	ffff9097          	auipc	ra,0xffff9
    80006f56:	60e080e7          	jalr	1550(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006f5a:	00004517          	auipc	a0,0x4
    80006f5e:	7be50513          	addi	a0,a0,1982 # 8000b718 <etext+0x718>
    80006f62:	ffff9097          	auipc	ra,0xffff9
    80006f66:	5fe080e7          	jalr	1534(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006f6a:	00004517          	auipc	a0,0x4
    80006f6e:	7ce50513          	addi	a0,a0,1998 # 8000b738 <etext+0x738>
    80006f72:	ffff9097          	auipc	ra,0xffff9
    80006f76:	5ee080e7          	jalr	1518(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006f7a:	00004517          	auipc	a0,0x4
    80006f7e:	7de50513          	addi	a0,a0,2014 # 8000b758 <etext+0x758>
    80006f82:	ffff9097          	auipc	ra,0xffff9
    80006f86:	5de080e7          	jalr	1502(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006f8a:	00004517          	auipc	a0,0x4
    80006f8e:	7ee50513          	addi	a0,a0,2030 # 8000b778 <etext+0x778>
    80006f92:	ffff9097          	auipc	ra,0xffff9
    80006f96:	5ce080e7          	jalr	1486(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006f9a:	00004517          	auipc	a0,0x4
    80006f9e:	7fe50513          	addi	a0,a0,2046 # 8000b798 <etext+0x798>
    80006fa2:	ffff9097          	auipc	ra,0xffff9
    80006fa6:	5be080e7          	jalr	1470(ra) # 80000560 <panic>

0000000080006faa <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006faa:	711d                	addi	sp,sp,-96
    80006fac:	ec86                	sd	ra,88(sp)
    80006fae:	e8a2                	sd	s0,80(sp)
    80006fb0:	e4a6                	sd	s1,72(sp)
    80006fb2:	e0ca                	sd	s2,64(sp)
    80006fb4:	fc4e                	sd	s3,56(sp)
    80006fb6:	f852                	sd	s4,48(sp)
    80006fb8:	f456                	sd	s5,40(sp)
    80006fba:	f05a                	sd	s6,32(sp)
    80006fbc:	ec5e                	sd	s7,24(sp)
    80006fbe:	e862                	sd	s8,16(sp)
    80006fc0:	1080                	addi	s0,sp,96
    80006fc2:	89aa                	mv	s3,a0
    80006fc4:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006fc6:	00c52b83          	lw	s7,12(a0)
    80006fca:	001b9b9b          	slliw	s7,s7,0x1
    80006fce:	1b82                	slli	s7,s7,0x20
    80006fd0:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006fd4:	0006a517          	auipc	a0,0x6a
    80006fd8:	79450513          	addi	a0,a0,1940 # 80071768 <disk+0x128>
    80006fdc:	ffffa097          	auipc	ra,0xffffa
    80006fe0:	d3a080e7          	jalr	-710(ra) # 80000d16 <acquire>
  for(int i = 0; i < NUM; i++){
    80006fe4:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006fe6:	0006aa97          	auipc	s5,0x6a
    80006fea:	65aa8a93          	addi	s5,s5,1626 # 80071640 <disk>
  for(int i = 0; i < 3; i++){
    80006fee:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006ff0:	5c7d                	li	s8,-1
    80006ff2:	a885                	j	80007062 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006ff4:	00fa8733          	add	a4,s5,a5
    80006ff8:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006ffc:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006ffe:	0207c563          	bltz	a5,80007028 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80007002:	2905                	addiw	s2,s2,1
    80007004:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80007006:	07490263          	beq	s2,s4,8000706a <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    8000700a:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000700c:	0006a717          	auipc	a4,0x6a
    80007010:	63470713          	addi	a4,a4,1588 # 80071640 <disk>
    80007014:	4781                	li	a5,0
    if(disk.free[i]){
    80007016:	01874683          	lbu	a3,24(a4)
    8000701a:	fee9                	bnez	a3,80006ff4 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    8000701c:	2785                	addiw	a5,a5,1
    8000701e:	0705                	addi	a4,a4,1
    80007020:	fe979be3          	bne	a5,s1,80007016 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80007024:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80007028:	03205163          	blez	s2,8000704a <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000702c:	fa042503          	lw	a0,-96(s0)
    80007030:	00000097          	auipc	ra,0x0
    80007034:	cfc080e7          	jalr	-772(ra) # 80006d2c <free_desc>
      for(int j = 0; j < i; j++)
    80007038:	4785                	li	a5,1
    8000703a:	0127d863          	bge	a5,s2,8000704a <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000703e:	fa442503          	lw	a0,-92(s0)
    80007042:	00000097          	auipc	ra,0x0
    80007046:	cea080e7          	jalr	-790(ra) # 80006d2c <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000704a:	0006a597          	auipc	a1,0x6a
    8000704e:	71e58593          	addi	a1,a1,1822 # 80071768 <disk+0x128>
    80007052:	0006a517          	auipc	a0,0x6a
    80007056:	60650513          	addi	a0,a0,1542 # 80071658 <disk+0x18>
    8000705a:	ffffb097          	auipc	ra,0xffffb
    8000705e:	6ae080e7          	jalr	1710(ra) # 80002708 <sleep>
  for(int i = 0; i < 3; i++){
    80007062:	fa040613          	addi	a2,s0,-96
    80007066:	4901                	li	s2,0
    80007068:	b74d                	j	8000700a <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000706a:	fa042503          	lw	a0,-96(s0)
    8000706e:	00451693          	slli	a3,a0,0x4

  if(write)
    80007072:	0006a797          	auipc	a5,0x6a
    80007076:	5ce78793          	addi	a5,a5,1486 # 80071640 <disk>
    8000707a:	00a50713          	addi	a4,a0,10
    8000707e:	0712                	slli	a4,a4,0x4
    80007080:	973e                	add	a4,a4,a5
    80007082:	01603633          	snez	a2,s6
    80007086:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80007088:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000708c:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80007090:	6398                	ld	a4,0(a5)
    80007092:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80007094:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80007098:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000709a:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000709c:	6390                	ld	a2,0(a5)
    8000709e:	00d605b3          	add	a1,a2,a3
    800070a2:	4741                	li	a4,16
    800070a4:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800070a6:	4805                	li	a6,1
    800070a8:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800070ac:	fa442703          	lw	a4,-92(s0)
    800070b0:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800070b4:	0712                	slli	a4,a4,0x4
    800070b6:	963a                	add	a2,a2,a4
    800070b8:	05898593          	addi	a1,s3,88
    800070bc:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800070be:	0007b883          	ld	a7,0(a5)
    800070c2:	9746                	add	a4,a4,a7
    800070c4:	40000613          	li	a2,1024
    800070c8:	c710                	sw	a2,8(a4)
  if(write)
    800070ca:	001b3613          	seqz	a2,s6
    800070ce:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800070d2:	01066633          	or	a2,a2,a6
    800070d6:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800070da:	fa842583          	lw	a1,-88(s0)
    800070de:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800070e2:	00250613          	addi	a2,a0,2
    800070e6:	0612                	slli	a2,a2,0x4
    800070e8:	963e                	add	a2,a2,a5
    800070ea:	577d                	li	a4,-1
    800070ec:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800070f0:	0592                	slli	a1,a1,0x4
    800070f2:	98ae                	add	a7,a7,a1
    800070f4:	03068713          	addi	a4,a3,48
    800070f8:	973e                	add	a4,a4,a5
    800070fa:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800070fe:	6398                	ld	a4,0(a5)
    80007100:	972e                	add	a4,a4,a1
    80007102:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80007106:	4689                	li	a3,2
    80007108:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000710c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80007110:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80007114:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80007118:	6794                	ld	a3,8(a5)
    8000711a:	0026d703          	lhu	a4,2(a3)
    8000711e:	8b1d                	andi	a4,a4,7
    80007120:	0706                	slli	a4,a4,0x1
    80007122:	96ba                	add	a3,a3,a4
    80007124:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80007128:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000712c:	6798                	ld	a4,8(a5)
    8000712e:	00275783          	lhu	a5,2(a4)
    80007132:	2785                	addiw	a5,a5,1
    80007134:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80007138:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000713c:	100017b7          	lui	a5,0x10001
    80007140:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80007144:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80007148:	0006a917          	auipc	s2,0x6a
    8000714c:	62090913          	addi	s2,s2,1568 # 80071768 <disk+0x128>
  while(b->disk == 1) {
    80007150:	84c2                	mv	s1,a6
    80007152:	01079c63          	bne	a5,a6,8000716a <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    80007156:	85ca                	mv	a1,s2
    80007158:	854e                	mv	a0,s3
    8000715a:	ffffb097          	auipc	ra,0xffffb
    8000715e:	5ae080e7          	jalr	1454(ra) # 80002708 <sleep>
  while(b->disk == 1) {
    80007162:	0049a783          	lw	a5,4(s3)
    80007166:	fe9788e3          	beq	a5,s1,80007156 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    8000716a:	fa042903          	lw	s2,-96(s0)
    8000716e:	00290713          	addi	a4,s2,2
    80007172:	0712                	slli	a4,a4,0x4
    80007174:	0006a797          	auipc	a5,0x6a
    80007178:	4cc78793          	addi	a5,a5,1228 # 80071640 <disk>
    8000717c:	97ba                	add	a5,a5,a4
    8000717e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80007182:	0006a997          	auipc	s3,0x6a
    80007186:	4be98993          	addi	s3,s3,1214 # 80071640 <disk>
    8000718a:	00491713          	slli	a4,s2,0x4
    8000718e:	0009b783          	ld	a5,0(s3)
    80007192:	97ba                	add	a5,a5,a4
    80007194:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80007198:	854a                	mv	a0,s2
    8000719a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000719e:	00000097          	auipc	ra,0x0
    800071a2:	b8e080e7          	jalr	-1138(ra) # 80006d2c <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800071a6:	8885                	andi	s1,s1,1
    800071a8:	f0ed                	bnez	s1,8000718a <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800071aa:	0006a517          	auipc	a0,0x6a
    800071ae:	5be50513          	addi	a0,a0,1470 # 80071768 <disk+0x128>
    800071b2:	ffffa097          	auipc	ra,0xffffa
    800071b6:	c14080e7          	jalr	-1004(ra) # 80000dc6 <release>
}
    800071ba:	60e6                	ld	ra,88(sp)
    800071bc:	6446                	ld	s0,80(sp)
    800071be:	64a6                	ld	s1,72(sp)
    800071c0:	6906                	ld	s2,64(sp)
    800071c2:	79e2                	ld	s3,56(sp)
    800071c4:	7a42                	ld	s4,48(sp)
    800071c6:	7aa2                	ld	s5,40(sp)
    800071c8:	7b02                	ld	s6,32(sp)
    800071ca:	6be2                	ld	s7,24(sp)
    800071cc:	6c42                	ld	s8,16(sp)
    800071ce:	6125                	addi	sp,sp,96
    800071d0:	8082                	ret

00000000800071d2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800071d2:	1101                	addi	sp,sp,-32
    800071d4:	ec06                	sd	ra,24(sp)
    800071d6:	e822                	sd	s0,16(sp)
    800071d8:	e426                	sd	s1,8(sp)
    800071da:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800071dc:	0006a497          	auipc	s1,0x6a
    800071e0:	46448493          	addi	s1,s1,1124 # 80071640 <disk>
    800071e4:	0006a517          	auipc	a0,0x6a
    800071e8:	58450513          	addi	a0,a0,1412 # 80071768 <disk+0x128>
    800071ec:	ffffa097          	auipc	ra,0xffffa
    800071f0:	b2a080e7          	jalr	-1238(ra) # 80000d16 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800071f4:	100017b7          	lui	a5,0x10001
    800071f8:	53bc                	lw	a5,96(a5)
    800071fa:	8b8d                	andi	a5,a5,3
    800071fc:	10001737          	lui	a4,0x10001
    80007200:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80007202:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80007206:	689c                	ld	a5,16(s1)
    80007208:	0204d703          	lhu	a4,32(s1)
    8000720c:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80007210:	04f70863          	beq	a4,a5,80007260 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80007214:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80007218:	6898                	ld	a4,16(s1)
    8000721a:	0204d783          	lhu	a5,32(s1)
    8000721e:	8b9d                	andi	a5,a5,7
    80007220:	078e                	slli	a5,a5,0x3
    80007222:	97ba                	add	a5,a5,a4
    80007224:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80007226:	00278713          	addi	a4,a5,2
    8000722a:	0712                	slli	a4,a4,0x4
    8000722c:	9726                	add	a4,a4,s1
    8000722e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80007232:	e721                	bnez	a4,8000727a <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80007234:	0789                	addi	a5,a5,2
    80007236:	0792                	slli	a5,a5,0x4
    80007238:	97a6                	add	a5,a5,s1
    8000723a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000723c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80007240:	ffffb097          	auipc	ra,0xffffb
    80007244:	52c080e7          	jalr	1324(ra) # 8000276c <wakeup>

    disk.used_idx += 1;
    80007248:	0204d783          	lhu	a5,32(s1)
    8000724c:	2785                	addiw	a5,a5,1
    8000724e:	17c2                	slli	a5,a5,0x30
    80007250:	93c1                	srli	a5,a5,0x30
    80007252:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80007256:	6898                	ld	a4,16(s1)
    80007258:	00275703          	lhu	a4,2(a4)
    8000725c:	faf71ce3          	bne	a4,a5,80007214 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80007260:	0006a517          	auipc	a0,0x6a
    80007264:	50850513          	addi	a0,a0,1288 # 80071768 <disk+0x128>
    80007268:	ffffa097          	auipc	ra,0xffffa
    8000726c:	b5e080e7          	jalr	-1186(ra) # 80000dc6 <release>
}
    80007270:	60e2                	ld	ra,24(sp)
    80007272:	6442                	ld	s0,16(sp)
    80007274:	64a2                	ld	s1,8(sp)
    80007276:	6105                	addi	sp,sp,32
    80007278:	8082                	ret
      panic("virtio_disk_intr status");
    8000727a:	00004517          	auipc	a0,0x4
    8000727e:	53650513          	addi	a0,a0,1334 # 8000b7b0 <etext+0x7b0>
    80007282:	ffff9097          	auipc	ra,0xffff9
    80007286:	2de080e7          	jalr	734(ra) # 80000560 <panic>

000000008000728a <alloc_desc>:
 *         returns -1 if there are no free descriptors
 *
 */
int 
alloc_desc(struct virtq *q) 
{
    8000728a:	1141                	addi	sp,sp,-16
    8000728c:	e406                	sd	ra,8(sp)
    8000728e:	e022                	sd	s0,0(sp)
    80007290:	0800                	addi	s0,sp,16
    80007292:	862a                	mv	a2,a0
  for (int i = 0; i < NUM; i++) {
    80007294:	01c50793          	addi	a5,a0,28
    80007298:	4501                	li	a0,0
    8000729a:	46a1                	li	a3,8
    if (q->free[i]) {
    8000729c:	0007c703          	lbu	a4,0(a5)
    800072a0:	eb11                	bnez	a4,800072b4 <alloc_desc+0x2a>
  for (int i = 0; i < NUM; i++) {
    800072a2:	2505                	addiw	a0,a0,1
    800072a4:	0785                	addi	a5,a5,1
    800072a6:	fed51be3          	bne	a0,a3,8000729c <alloc_desc+0x12>
      q->free[i] = 0;
      return i;
    }
  }
  return -1;
    800072aa:	557d                	li	a0,-1
}
    800072ac:	60a2                	ld	ra,8(sp)
    800072ae:	6402                	ld	s0,0(sp)
    800072b0:	0141                	addi	sp,sp,16
    800072b2:	8082                	ret
      q->free[i] = 0;
    800072b4:	962a                	add	a2,a2,a0
    800072b6:	00060e23          	sb	zero,28(a2)
      return i;
    800072ba:	bfcd                	j	800072ac <alloc_desc+0x22>

00000000800072bc <free_desc>:
 * Output: None
 *
 */
void 
free_desc(struct virtq *q, int i) 
{
    800072bc:	1141                	addi	sp,sp,-16
    800072be:	e406                	sd	ra,8(sp)
    800072c0:	e022                	sd	s0,0(sp)
    800072c2:	0800                	addi	s0,sp,16
  if (i >= NUM)
    800072c4:	479d                	li	a5,7
    800072c6:	02b7cd63          	blt	a5,a1,80007300 <free_desc+0x44>
    panic("free_desc 1");
  if (q->free[i])
    800072ca:	00b507b3          	add	a5,a0,a1
    800072ce:	01c7c783          	lbu	a5,28(a5)
    800072d2:	ef9d                	bnez	a5,80007310 <free_desc+0x54>
    panic("free_desc 2");

  q->desc->addr = 0;
    800072d4:	611c                	ld	a5,0(a0)
    800072d6:	0007b023          	sd	zero,0(a5)
  q->desc->len = 0;
    800072da:	611c                	ld	a5,0(a0)
    800072dc:	0007a423          	sw	zero,8(a5)
  q->desc->flags = 0;
    800072e0:	611c                	ld	a5,0(a0)
    800072e2:	00079623          	sh	zero,12(a5)
  q->desc->next = 0;
    800072e6:	611c                	ld	a5,0(a0)
    800072e8:	00079723          	sh	zero,14(a5)
  wakeup(&q->free[i]);
    800072ec:	05f1                	addi	a1,a1,28
    800072ee:	952e                	add	a0,a0,a1
    800072f0:	ffffb097          	auipc	ra,0xffffb
    800072f4:	47c080e7          	jalr	1148(ra) # 8000276c <wakeup>
}
    800072f8:	60a2                	ld	ra,8(sp)
    800072fa:	6402                	ld	s0,0(sp)
    800072fc:	0141                	addi	sp,sp,16
    800072fe:	8082                	ret
    panic("free_desc 1");
    80007300:	00004517          	auipc	a0,0x4
    80007304:	3c850513          	addi	a0,a0,968 # 8000b6c8 <etext+0x6c8>
    80007308:	ffff9097          	auipc	ra,0xffff9
    8000730c:	258080e7          	jalr	600(ra) # 80000560 <panic>
    panic("free_desc 2");
    80007310:	00004517          	auipc	a0,0x4
    80007314:	3c850513          	addi	a0,a0,968 # 8000b6d8 <etext+0x6d8>
    80007318:	ffff9097          	auipc	ra,0xffff9
    8000731c:	248080e7          	jalr	584(ra) # 80000560 <panic>

0000000080007320 <virtio_net_init>:
 * a minimal netowrk driver, I only negotiate VIRTIO_NET_F_MAC
 *
 */
void 
virtio_net_init(void) 
{
    80007320:	7159                	addi	sp,sp,-112
    80007322:	f486                	sd	ra,104(sp)
    80007324:	f0a2                	sd	s0,96(sp)
    80007326:	eca6                	sd	s1,88(sp)
    80007328:	e8ca                	sd	s2,80(sp)
    8000732a:	e4ce                	sd	s3,72(sp)
    8000732c:	e0d2                	sd	s4,64(sp)
    8000732e:	fc56                	sd	s5,56(sp)
    80007330:	f85a                	sd	s6,48(sp)
    80007332:	f45e                	sd	s7,40(sp)
    80007334:	f062                	sd	s8,32(sp)
    80007336:	ec66                	sd	s9,24(sp)
    80007338:	e86a                	sd	s10,16(sp)
    8000733a:	e46e                	sd	s11,8(sp)
    8000733c:	1880                	addi	s0,sp,112
  uint32 status = 0;
  initlock(&net.vnet_lock, "virtio_net");
    8000733e:	00004597          	auipc	a1,0x4
    80007342:	48a58593          	addi	a1,a1,1162 # 8000b7c8 <etext+0x7c8>
    80007346:	0006a517          	auipc	a0,0x6a
    8000734a:	44a50513          	addi	a0,a0,1098 # 80071790 <net+0x10>
    8000734e:	ffffa097          	auipc	ra,0xffffa
    80007352:	934080e7          	jalr	-1740(ra) # 80000c82 <initlock>

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80007356:	100027b7          	lui	a5,0x10002
    8000735a:	4398                	lw	a4,0(a5)
    8000735c:	2701                	sext.w	a4,a4
    8000735e:	747277b7          	lui	a5,0x74727
    80007362:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80007366:	32f71a63          	bne	a4,a5,8000769a <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    8000736a:	100027b7          	lui	a5,0x10002
    8000736e:	43dc                	lw	a5,4(a5)
    80007370:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80007372:	4709                	li	a4,2
    80007374:	32e79363          	bne	a5,a4,8000769a <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    80007378:	100027b7          	lui	a5,0x10002
    8000737c:	479c                	lw	a5,8(a5)
    8000737e:	2781                	sext.w	a5,a5
    80007380:	4705                	li	a4,1
    80007382:	30e79c63          	bne	a5,a4,8000769a <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80007386:	100027b7          	lui	a5,0x10002
    8000738a:	47d8                	lw	a4,12(a5)
    8000738c:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    8000738e:	554d47b7          	lui	a5,0x554d4
    80007392:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80007396:	30f71263          	bne	a4,a5,8000769a <virtio_net_init+0x37a>
    panic("could not find virtio net");
  }

  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    8000739a:	100024b7          	lui	s1,0x10002
    8000739e:	07048493          	addi	s1,s1,112 # 10002070 <_entry-0x6fffdf90>
    800073a2:	0004a023          	sw	zero,0(s1)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;
    800073a6:	4785                	li	a5,1
    800073a8:	c09c                	sw	a5,0(s1)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;
    800073aa:	478d                	li	a5,3
    800073ac:	c09c                	sw	a5,0(s1)

  // This copies the memory from the config into my driver state struct
  memmove((void *)&net.cfg, (void *)VIRTIO_NET_CONFIG,
    800073ae:	4631                	li	a2,12
    800073b0:	100025b7          	lui	a1,0x10002
    800073b4:	10058593          	addi	a1,a1,256 # 10002100 <_entry-0x6fffdf00>
    800073b8:	0006a517          	auipc	a0,0x6a
    800073bc:	3c850513          	addi	a0,a0,968 # 80071780 <net>
    800073c0:	ffffa097          	auipc	ra,0xffffa
    800073c4:	ab2080e7          	jalr	-1358(ra) # 80000e72 <memmove>
          sizeof(struct virtio_net_config));

  // Negotiate the feature bits
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800073c8:	100027b7          	lui	a5,0x10002
    800073cc:	4b9c                	lw	a5,16(a5)
  features &= VIRTIO_NET_F_MAC;
    800073ce:	0207f793          	andi	a5,a5,32
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800073d2:	10002737          	lui	a4,0x10002
    800073d6:	d31c                	sw	a5,32(a4)

  // Tell device that feature negotiation is complete
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;
    800073d8:	47ad                	li	a5,11
    800073da:	c09c                	sw	a5,0(s1)

  // Make sure that FEATURES_OK is set
  status = *R(VIRTIO_MMIO_STATUS);
    800073dc:	409c                	lw	a5,0(s1)
    800073de:	00078d1b          	sext.w	s10,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800073e2:	8ba1                	andi	a5,a5,8
    800073e4:	2c078363          	beqz	a5,800076aa <virtio_net_init+0x38a>
    panic("virtio net FEATURES_OK unset");

  // Check max queue size
  uint32 max_queue_size = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800073e8:	100027b7          	lui	a5,0x10002
    800073ec:	5bdc                	lw	a5,52(a5)
    800073ee:	2781                	sext.w	a5,a5
  if (max_queue_size == 0)
    800073f0:	2c078563          	beqz	a5,800076ba <virtio_net_init+0x39a>
    panic("virtio net has no queue 1 (QUEUE_TX)");
  if (max_queue_size < NUM)
    800073f4:	471d                	li	a4,7
    800073f6:	2cf77a63          	bgeu	a4,a5,800076ca <virtio_net_init+0x3aa>
    panic("virtio net max queue too short");

  /* Initialize QUEUE_TX */
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    800073fa:	10002737          	lui	a4,0x10002
    800073fe:	4785                	li	a5,1
    80007400:	db1c                	sw	a5,48(a4)
  net.txq.num = QUEUE_TX;
    80007402:	0006a717          	auipc	a4,0x6a
    80007406:	3af72f23          	sw	a5,958(a4) # 800717c0 <net+0x40>

  // ensure QUEUE_TX is not in use.
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000740a:	100027b7          	lui	a5,0x10002
    8000740e:	43fc                	lw	a5,68(a5)
    80007410:	2781                	sext.w	a5,a5
    80007412:	2c079463          	bnez	a5,800076da <virtio_net_init+0x3ba>
    panic("QUEUE_TX should not be ready\n");

  net.txq.desc = kalloc();
    80007416:	ffff9097          	auipc	ra,0xffff9
    8000741a:	7ee080e7          	jalr	2030(ra) # 80000c04 <kalloc>
    8000741e:	0006a497          	auipc	s1,0x6a
    80007422:	36248493          	addi	s1,s1,866 # 80071780 <net>
    80007426:	f488                	sd	a0,40(s1)
  net.txq.driver_area = kalloc();
    80007428:	ffff9097          	auipc	ra,0xffff9
    8000742c:	7dc080e7          	jalr	2012(ra) # 80000c04 <kalloc>
    80007430:	f888                	sd	a0,48(s1)
  net.txq.device_area = kalloc();
    80007432:	ffff9097          	auipc	ra,0xffff9
    80007436:	7d2080e7          	jalr	2002(ra) # 80000c04 <kalloc>
    8000743a:	87aa                	mv	a5,a0
    8000743c:	fc88                	sd	a0,56(s1)
  if (!net.txq.desc || !net.txq.driver_area || !net.txq.device_area)
    8000743e:	7488                	ld	a0,40(s1)
    80007440:	2a050563          	beqz	a0,800076ea <virtio_net_init+0x3ca>
    80007444:	0006a717          	auipc	a4,0x6a
    80007448:	36c73703          	ld	a4,876(a4) # 800717b0 <net+0x30>
    8000744c:	28070f63          	beqz	a4,800076ea <virtio_net_init+0x3ca>
    80007450:	28078d63          	beqz	a5,800076ea <virtio_net_init+0x3ca>
    panic("virtio net alloc\n");
  memset(net.txq.desc, 0, PGSIZE);
    80007454:	6605                	lui	a2,0x1
    80007456:	4581                	li	a1,0
    80007458:	ffffa097          	auipc	ra,0xffffa
    8000745c:	9b6080e7          	jalr	-1610(ra) # 80000e0e <memset>
  memset(net.txq.free, 1, NUM);
    80007460:	0006a497          	auipc	s1,0x6a
    80007464:	32048493          	addi	s1,s1,800 # 80071780 <net>
    80007468:	4621                	li	a2,8
    8000746a:	4585                	li	a1,1
    8000746c:	0006a517          	auipc	a0,0x6a
    80007470:	35850513          	addi	a0,a0,856 # 800717c4 <net+0x44>
    80007474:	ffffa097          	auipc	ra,0xffffa
    80007478:	99a080e7          	jalr	-1638(ra) # 80000e0e <memset>
  memset(net.txq.driver_area, 0, PGSIZE);
    8000747c:	6605                	lui	a2,0x1
    8000747e:	4581                	li	a1,0
    80007480:	7888                	ld	a0,48(s1)
    80007482:	ffffa097          	auipc	ra,0xffffa
    80007486:	98c080e7          	jalr	-1652(ra) # 80000e0e <memset>
  memset(net.txq.device_area, 0, PGSIZE);
    8000748a:	6605                	lui	a2,0x1
    8000748c:	4581                	li	a1,0
    8000748e:	7c88                	ld	a0,56(s1)
    80007490:	ffffa097          	auipc	ra,0xffffa
    80007494:	97e080e7          	jalr	-1666(ra) # 80000e0e <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80007498:	100027b7          	lui	a5,0x10002
    8000749c:	4721                	li	a4,8
    8000749e:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.txq.desc;
    800074a0:	749c                	ld	a5,40(s1)
    800074a2:	0007869b          	sext.w	a3,a5
    800074a6:	10002737          	lui	a4,0x10002
    800074aa:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.txq.desc) >> 32;
    800074ae:	9781                	srai	a5,a5,0x20
    800074b0:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.txq.driver_area;
    800074b4:	789c                	ld	a5,48(s1)
    800074b6:	0007869b          	sext.w	a3,a5
    800074ba:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.txq.driver_area) >> 32;
    800074be:	9781                	srai	a5,a5,0x20
    800074c0:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.txq.device_area;
    800074c4:	7c9c                	ld	a5,56(s1)
    800074c6:	0007869b          	sext.w	a3,a5
    800074ca:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.txq.device_area) >> 32;
    800074ce:	9781                	srai	a5,a5,0x20
    800074d0:	0af72223          	sw	a5,164(a4)

  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800074d4:	87ba                	mv	a5,a4
    800074d6:	4705                	li	a4,1
    800074d8:	c3f8                	sw	a4,68(a5)
    800074da:	04478793          	addi	a5,a5,68 # 10002044 <_entry-0x6fffdfbc>

  /* Initialize QUEUE_RX */

  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_RX;
    800074de:	10002737          	lui	a4,0x10002
    800074e2:	02072823          	sw	zero,48(a4) # 10002030 <_entry-0x6fffdfd0>
  net.rxq.num = QUEUE_RX;
    800074e6:	0604a423          	sw	zero,104(s1)
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    800074ea:	439c                	lw	a5,0(a5)
    800074ec:	2781                	sext.w	a5,a5
    800074ee:	20079663          	bnez	a5,800076fa <virtio_net_init+0x3da>
    panic("QUEUE_RX should not be ready\n");

  net.rxq.desc = kalloc();
    800074f2:	ffff9097          	auipc	ra,0xffff9
    800074f6:	712080e7          	jalr	1810(ra) # 80000c04 <kalloc>
    800074fa:	0006a497          	auipc	s1,0x6a
    800074fe:	28648493          	addi	s1,s1,646 # 80071780 <net>
    80007502:	e8a8                	sd	a0,80(s1)
  net.rxq.driver_area = kalloc();
    80007504:	ffff9097          	auipc	ra,0xffff9
    80007508:	700080e7          	jalr	1792(ra) # 80000c04 <kalloc>
    8000750c:	eca8                	sd	a0,88(s1)
  net.rxq.device_area = kalloc();
    8000750e:	ffff9097          	auipc	ra,0xffff9
    80007512:	6f6080e7          	jalr	1782(ra) # 80000c04 <kalloc>
    80007516:	87aa                	mv	a5,a0
    80007518:	f0a8                	sd	a0,96(s1)
  if (!net.rxq.desc || !net.rxq.driver_area || !net.rxq.device_area)
    8000751a:	68a8                	ld	a0,80(s1)
    8000751c:	1e050763          	beqz	a0,8000770a <virtio_net_init+0x3ea>
    80007520:	0006a717          	auipc	a4,0x6a
    80007524:	2b873703          	ld	a4,696(a4) # 800717d8 <net+0x58>
    80007528:	1e070163          	beqz	a4,8000770a <virtio_net_init+0x3ea>
    8000752c:	1c078f63          	beqz	a5,8000770a <virtio_net_init+0x3ea>
    panic("virtio net alloc");
  memset(net.rxq.desc, 0, PGSIZE);
    80007530:	6605                	lui	a2,0x1
    80007532:	4581                	li	a1,0
    80007534:	ffffa097          	auipc	ra,0xffffa
    80007538:	8da080e7          	jalr	-1830(ra) # 80000e0e <memset>
  memset(net.rxq.free, 1, NUM);
    8000753c:	0006a497          	auipc	s1,0x6a
    80007540:	24448493          	addi	s1,s1,580 # 80071780 <net>
    80007544:	4621                	li	a2,8
    80007546:	4585                	li	a1,1
    80007548:	0006a517          	auipc	a0,0x6a
    8000754c:	2a450513          	addi	a0,a0,676 # 800717ec <net+0x6c>
    80007550:	ffffa097          	auipc	ra,0xffffa
    80007554:	8be080e7          	jalr	-1858(ra) # 80000e0e <memset>
  memset(net.rxq.driver_area, 0, PGSIZE);
    80007558:	6605                	lui	a2,0x1
    8000755a:	4581                	li	a1,0
    8000755c:	6ca8                	ld	a0,88(s1)
    8000755e:	ffffa097          	auipc	ra,0xffffa
    80007562:	8b0080e7          	jalr	-1872(ra) # 80000e0e <memset>
  memset(net.rxq.device_area, 0, PGSIZE);
    80007566:	6605                	lui	a2,0x1
    80007568:	4581                	li	a1,0
    8000756a:	70a8                	ld	a0,96(s1)
    8000756c:	ffffa097          	auipc	ra,0xffffa
    80007570:	8a2080e7          	jalr	-1886(ra) # 80000e0e <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80007574:	100027b7          	lui	a5,0x10002
    80007578:	4721                	li	a4,8
    8000757a:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.rxq.desc;
    8000757c:	68bc                	ld	a5,80(s1)
    8000757e:	0007869b          	sext.w	a3,a5
    80007582:	10002737          	lui	a4,0x10002
    80007586:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.rxq.desc) >> 32;
    8000758a:	9781                	srai	a5,a5,0x20
    8000758c:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.rxq.driver_area;
    80007590:	6cbc                	ld	a5,88(s1)
    80007592:	0007869b          	sext.w	a3,a5
    80007596:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.rxq.driver_area) >> 32;
    8000759a:	9781                	srai	a5,a5,0x20
    8000759c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.rxq.device_area;
    800075a0:	70bc                	ld	a5,96(s1)
    800075a2:	0007869b          	sext.w	a3,a5
    800075a6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.rxq.device_area) >> 32;
    800075aa:	9781                	srai	a5,a5,0x20
    800075ac:	0af72223          	sw	a5,164(a4)
    800075b0:	4a11                	li	s4,4

  for (int i = 0; i < NUM / 2; i++) {
    int rx_hdr_desc = alloc_desc(&net.rxq);
    800075b2:	0006aa97          	auipc	s5,0x6a
    800075b6:	21ea8a93          	addi	s5,s5,542 # 800717d0 <net+0x50>
    struct virtio_net_hdr *hdr = kalloc();
    if (!rxbuf)
      panic("rxbuf alloc failed");

    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    800075ba:	4ca9                	li	s9,10
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    800075bc:	4c05                	li	s8,1
    net.rxq.desc[rx_hdr_desc].next = rx_desc;

    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    net.rxq.desc[rx_desc].len = PGSIZE;
    800075be:	6b85                	lui	s7,0x1
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    800075c0:	4b09                	li	s6,2
    int rx_hdr_desc = alloc_desc(&net.rxq);
    800075c2:	8556                	mv	a0,s5
    800075c4:	00000097          	auipc	ra,0x0
    800075c8:	cc6080e7          	jalr	-826(ra) # 8000728a <alloc_desc>
    800075cc:	89aa                	mv	s3,a0
    int rx_desc = alloc_desc(&net.rxq);
    800075ce:	8556                	mv	a0,s5
    800075d0:	00000097          	auipc	ra,0x0
    800075d4:	cba080e7          	jalr	-838(ra) # 8000728a <alloc_desc>
    800075d8:	8daa                	mv	s11,a0
    void *rxbuf = kalloc();
    800075da:	ffff9097          	auipc	ra,0xffff9
    800075de:	62a080e7          	jalr	1578(ra) # 80000c04 <kalloc>
    800075e2:	892a                	mv	s2,a0
    struct virtio_net_hdr *hdr = kalloc();
    800075e4:	ffff9097          	auipc	ra,0xffff9
    800075e8:	620080e7          	jalr	1568(ra) # 80000c04 <kalloc>
    if (!rxbuf)
    800075ec:	12090763          	beqz	s2,8000771a <virtio_net_init+0x3fa>
    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    800075f0:	00499793          	slli	a5,s3,0x4
    800075f4:	68b8                	ld	a4,80(s1)
    800075f6:	973e                	add	a4,a4,a5
    800075f8:	e308                	sd	a0,0(a4)
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    800075fa:	68b8                	ld	a4,80(s1)
    800075fc:	973e                	add	a4,a4,a5
    800075fe:	01972423          	sw	s9,8(a4)
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    80007602:	68b8                	ld	a4,80(s1)
    80007604:	973e                	add	a4,a4,a5
    80007606:	01871623          	sh	s8,12(a4)
    net.rxq.desc[rx_hdr_desc].next = rx_desc;
    8000760a:	68b8                	ld	a4,80(s1)
    8000760c:	97ba                	add	a5,a5,a4
    8000760e:	01b79723          	sh	s11,14(a5) # 1000200e <_entry-0x6fffdff2>
    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    80007612:	004d9793          	slli	a5,s11,0x4
    80007616:	68b8                	ld	a4,80(s1)
    80007618:	973e                	add	a4,a4,a5
    8000761a:	01273023          	sd	s2,0(a4)
    net.rxq.desc[rx_desc].len = PGSIZE;
    8000761e:	68b8                	ld	a4,80(s1)
    80007620:	973e                	add	a4,a4,a5
    80007622:	01772423          	sw	s7,8(a4)
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    80007626:	68b8                	ld	a4,80(s1)
    80007628:	97ba                	add	a5,a5,a4
    8000762a:	01679623          	sh	s6,12(a5)

    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = rx_hdr_desc;
    8000762e:	6cb8                	ld	a4,88(s1)
    80007630:	00275783          	lhu	a5,2(a4)
    80007634:	8b9d                	andi	a5,a5,7
    80007636:	0786                	slli	a5,a5,0x1
    80007638:	973e                	add	a4,a4,a5
    8000763a:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    8000763e:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    80007642:	6cb8                	ld	a4,88(s1)
    80007644:	00275783          	lhu	a5,2(a4)
    80007648:	2785                	addiw	a5,a5,1
    8000764a:	00f71123          	sh	a5,2(a4)
    __sync_synchronize();
    8000764e:	0330000f          	fence	rw,rw
  for (int i = 0; i < NUM / 2; i++) {
    80007652:	3a7d                	addiw	s4,s4,-1
    80007654:	f60a17e3          	bnez	s4,800075c2 <virtio_net_init+0x2a2>
  }

  // queue is ready
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80007658:	100027b7          	lui	a5,0x10002
    8000765c:	4705                	li	a4,1
    8000765e:	c3f8                	sw	a4,68(a5)

  // Notify device
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_RX;
    80007660:	0407a823          	sw	zero,80(a5) # 10002050 <_entry-0x6fffdfb0>

  // Done initializing
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80007664:	004d6d13          	ori	s10,s10,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80007668:	07a7a823          	sw	s10,112(a5)

  // initialize packet buffer
  packet_buf = kalloc();
    8000766c:	ffff9097          	auipc	ra,0xffff9
    80007670:	598080e7          	jalr	1432(ra) # 80000c04 <kalloc>
    80007674:	00008797          	auipc	a5,0x8
    80007678:	74a7ba23          	sd	a0,1876(a5) # 8000fdc8 <packet_buf>
}
    8000767c:	70a6                	ld	ra,104(sp)
    8000767e:	7406                	ld	s0,96(sp)
    80007680:	64e6                	ld	s1,88(sp)
    80007682:	6946                	ld	s2,80(sp)
    80007684:	69a6                	ld	s3,72(sp)
    80007686:	6a06                	ld	s4,64(sp)
    80007688:	7ae2                	ld	s5,56(sp)
    8000768a:	7b42                	ld	s6,48(sp)
    8000768c:	7ba2                	ld	s7,40(sp)
    8000768e:	7c02                	ld	s8,32(sp)
    80007690:	6ce2                	ld	s9,24(sp)
    80007692:	6d42                	ld	s10,16(sp)
    80007694:	6da2                	ld	s11,8(sp)
    80007696:	6165                	addi	sp,sp,112
    80007698:	8082                	ret
    panic("could not find virtio net");
    8000769a:	00004517          	auipc	a0,0x4
    8000769e:	13e50513          	addi	a0,a0,318 # 8000b7d8 <etext+0x7d8>
    800076a2:	ffff9097          	auipc	ra,0xffff9
    800076a6:	ebe080e7          	jalr	-322(ra) # 80000560 <panic>
    panic("virtio net FEATURES_OK unset");
    800076aa:	00004517          	auipc	a0,0x4
    800076ae:	14e50513          	addi	a0,a0,334 # 8000b7f8 <etext+0x7f8>
    800076b2:	ffff9097          	auipc	ra,0xffff9
    800076b6:	eae080e7          	jalr	-338(ra) # 80000560 <panic>
    panic("virtio net has no queue 1 (QUEUE_TX)");
    800076ba:	00004517          	auipc	a0,0x4
    800076be:	15e50513          	addi	a0,a0,350 # 8000b818 <etext+0x818>
    800076c2:	ffff9097          	auipc	ra,0xffff9
    800076c6:	e9e080e7          	jalr	-354(ra) # 80000560 <panic>
    panic("virtio net max queue too short");
    800076ca:	00004517          	auipc	a0,0x4
    800076ce:	17650513          	addi	a0,a0,374 # 8000b840 <etext+0x840>
    800076d2:	ffff9097          	auipc	ra,0xffff9
    800076d6:	e8e080e7          	jalr	-370(ra) # 80000560 <panic>
    panic("QUEUE_TX should not be ready\n");
    800076da:	00004517          	auipc	a0,0x4
    800076de:	18650513          	addi	a0,a0,390 # 8000b860 <etext+0x860>
    800076e2:	ffff9097          	auipc	ra,0xffff9
    800076e6:	e7e080e7          	jalr	-386(ra) # 80000560 <panic>
    panic("virtio net alloc\n");
    800076ea:	00004517          	auipc	a0,0x4
    800076ee:	19650513          	addi	a0,a0,406 # 8000b880 <etext+0x880>
    800076f2:	ffff9097          	auipc	ra,0xffff9
    800076f6:	e6e080e7          	jalr	-402(ra) # 80000560 <panic>
    panic("QUEUE_RX should not be ready\n");
    800076fa:	00004517          	auipc	a0,0x4
    800076fe:	19e50513          	addi	a0,a0,414 # 8000b898 <etext+0x898>
    80007702:	ffff9097          	auipc	ra,0xffff9
    80007706:	e5e080e7          	jalr	-418(ra) # 80000560 <panic>
    panic("virtio net alloc");
    8000770a:	00004517          	auipc	a0,0x4
    8000770e:	1ae50513          	addi	a0,a0,430 # 8000b8b8 <etext+0x8b8>
    80007712:	ffff9097          	auipc	ra,0xffff9
    80007716:	e4e080e7          	jalr	-434(ra) # 80000560 <panic>
      panic("rxbuf alloc failed");
    8000771a:	00004517          	auipc	a0,0x4
    8000771e:	1b650513          	addi	a0,a0,438 # 8000b8d0 <etext+0x8d0>
    80007722:	ffff9097          	auipc	ra,0xffff9
    80007726:	e3e080e7          	jalr	-450(ra) # 80000560 <panic>

000000008000772a <apply_padding>:
 */
int 
apply_padding(uint8 num_bytes)
{
  uint8 *pkt_ptr =
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    8000772a:	04a00693          	li	a3,74
    8000772e:	9e89                	subw	a3,a3,a0
  if (num_bytes > 64 - sizeof(struct virtio_net_hdr) || num_bytes < 1) {
    80007730:	fff5079b          	addiw	a5,a0,-1
    80007734:	0ff7f793          	zext.b	a5,a5
    80007738:	03500713          	li	a4,53
    8000773c:	02f76563          	bltu	a4,a5,80007766 <apply_padding+0x3c>
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    80007740:	00008717          	auipc	a4,0x8
    80007744:	68873703          	ld	a4,1672(a4) # 8000fdc8 <packet_buf>
    80007748:	00d707b3          	add	a5,a4,a3
    8000774c:	0705                	addi	a4,a4,1
    8000774e:	9736                	add	a4,a4,a3
    80007750:	357d                	addiw	a0,a0,-1
    80007752:	1502                	slli	a0,a0,0x20
    80007754:	9101                	srli	a0,a0,0x20
    80007756:	972a                	add	a4,a4,a0
    printf("malformed packet data");
    return 1;
  }
  for (int i = 0; i < num_bytes; i++) {
    pkt_ptr[i] = 0;
    80007758:	00078023          	sb	zero,0(a5)
  for (int i = 0; i < num_bytes; i++) {
    8000775c:	0785                	addi	a5,a5,1
    8000775e:	fee79de3          	bne	a5,a4,80007758 <apply_padding+0x2e>
  }
  return 0;
    80007762:	4501                	li	a0,0
}
    80007764:	8082                	ret
{
    80007766:	1141                	addi	sp,sp,-16
    80007768:	e406                	sd	ra,8(sp)
    8000776a:	e022                	sd	s0,0(sp)
    8000776c:	0800                	addi	s0,sp,16
    printf("malformed packet data");
    8000776e:	00004517          	auipc	a0,0x4
    80007772:	17a50513          	addi	a0,a0,378 # 8000b8e8 <etext+0x8e8>
    80007776:	ffff9097          	auipc	ra,0xffff9
    8000777a:	e34080e7          	jalr	-460(ra) # 800005aa <printf>
    return 1;
    8000777e:	4505                	li	a0,1
}
    80007780:	60a2                	ld	ra,8(sp)
    80007782:	6402                	ld	s0,0(sp)
    80007784:	0141                	addi	sp,sp,16
    80007786:	8082                	ret

0000000080007788 <transmit_packet>:
 * Output: There is no return value from the function, but the packet frame
 *         is given to the NIC to be transmitted.
 */
void 
transmit_packet(void *pkt_data, uint16 pkt_len, uint16 protocol)
{
    80007788:	7139                	addi	sp,sp,-64
    8000778a:	fc06                	sd	ra,56(sp)
    8000778c:	f822                	sd	s0,48(sp)
    8000778e:	ec4e                	sd	s3,24(sp)
    80007790:	e852                	sd	s4,16(sp)
    80007792:	0080                	addi	s0,sp,64
    80007794:	89aa                	mv	s3,a0
    80007796:	8a2e                	mv	s4,a1
  /* Create the header for transmission */

  acquire(&net.vnet_lock);
    80007798:	0006a517          	auipc	a0,0x6a
    8000779c:	ff850513          	addi	a0,a0,-8 # 80071790 <net+0x10>
    800077a0:	ffff9097          	auipc	ra,0xffff9
    800077a4:	576080e7          	jalr	1398(ra) # 80000d16 <acquire>
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    800077a8:	100027b7          	lui	a5,0x10002
    800077ac:	4705                	li	a4,1
    800077ae:	db98                	sw	a4,48(a5)
  // allocate for packet header and packet_frame
  struct virtio_net_hdr *hdr = kalloc();
    800077b0:	ffff9097          	auipc	ra,0xffff9
    800077b4:	454080e7          	jalr	1108(ra) # 80000c04 <kalloc>
  if (hdr == 0)
    800077b8:	14050263          	beqz	a0,800078fc <transmit_packet+0x174>
    800077bc:	f426                	sd	s1,40(sp)
    800077be:	f04a                	sd	s2,32(sp)
    800077c0:	e456                	sd	s5,8(sp)
    800077c2:	892a                	mv	s2,a0
    panic("failed to allocate header\n");
  // initialize the header and packet
  memset(hdr, 0, PGSIZE);
    800077c4:	6605                	lui	a2,0x1
    800077c6:	4581                	li	a1,0
    800077c8:	ffff9097          	auipc	ra,0xffff9
    800077cc:	646080e7          	jalr	1606(ra) # 80000e0e <memset>

  int hdr_desc = alloc_desc(&net.txq);
    800077d0:	0006a497          	auipc	s1,0x6a
    800077d4:	fd848493          	addi	s1,s1,-40 # 800717a8 <net+0x28>
    800077d8:	8526                	mv	a0,s1
    800077da:	00000097          	auipc	ra,0x0
    800077de:	ab0080e7          	jalr	-1360(ra) # 8000728a <alloc_desc>
    800077e2:	8aaa                	mv	s5,a0
  int pkt_desc = alloc_desc(&net.txq);
    800077e4:	8526                	mv	a0,s1
    800077e6:	00000097          	auipc	ra,0x0
    800077ea:	aa4080e7          	jalr	-1372(ra) # 8000728a <alloc_desc>
    800077ee:	84aa                	mv	s1,a0
  if (hdr_desc ==  -1 || pkt_desc == -1) {
    800077f0:	57fd                	li	a5,-1
    800077f2:	12fa8163          	beq	s5,a5,80007914 <transmit_packet+0x18c>
    800077f6:	10f50f63          	beq	a0,a5,80007914 <transmit_packet+0x18c>
    800077fa:	e05a                	sd	s6,0(sp)
    release(&net.vnet_lock);
    return;
  }

  hdr->flags = 0;
    800077fc:	00090023          	sb	zero,0(s2)
  hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
    80007800:	000900a3          	sb	zero,1(s2)
  hdr->hdr_len = 0;
    80007804:	00091123          	sh	zero,2(s2)

  // populate the packet buffer
  memmove(packet_buf, pkt_data, pkt_len);
    80007808:	00008b17          	auipc	s6,0x8
    8000780c:	5c0b0b13          	addi	s6,s6,1472 # 8000fdc8 <packet_buf>
    80007810:	8652                	mv	a2,s4
    80007812:	85ce                	mv	a1,s3
    80007814:	000b3503          	ld	a0,0(s6)
    80007818:	ffff9097          	auipc	ra,0xffff9
    8000781c:	65a080e7          	jalr	1626(ra) # 80000e72 <memmove>

  net.txq.desc[hdr_desc].flags |=
    80007820:	004a9793          	slli	a5,s5,0x4
    80007824:	0006a997          	auipc	s3,0x6a
    80007828:	f5c98993          	addi	s3,s3,-164 # 80071780 <net>
    8000782c:	0289b703          	ld	a4,40(s3)
    80007830:	973e                	add	a4,a4,a5
    80007832:	00c75683          	lhu	a3,12(a4)
    80007836:	0016e693          	ori	a3,a3,1
    8000783a:	00d71623          	sh	a3,12(a4)
      VRING_DESC_F_NEXT; // This tells the device it's a chain
  net.txq.desc[hdr_desc].len = HDR_SIZE;
    8000783e:	0289b703          	ld	a4,40(s3)
    80007842:	973e                	add	a4,a4,a5
    80007844:	46a9                	li	a3,10
    80007846:	c714                	sw	a3,8(a4)
  net.txq.desc[hdr_desc].addr = (uint64)hdr;
    80007848:	0289b703          	ld	a4,40(s3)
    8000784c:	973e                	add	a4,a4,a5
    8000784e:	01273023          	sd	s2,0(a4)
  net.txq.desc[hdr_desc].next = pkt_desc;
    80007852:	0289b703          	ld	a4,40(s3)
    80007856:	97ba                	add	a5,a5,a4
    80007858:	00979723          	sh	s1,14(a5) # 1000200e <_entry-0x6fffdff2>

  net.txq.desc[pkt_desc].len = 14 + pkt_len;
    8000785c:	0492                	slli	s1,s1,0x4
    8000785e:	0289b783          	ld	a5,40(s3)
    80007862:	97a6                	add	a5,a5,s1
    80007864:	2a39                	addiw	s4,s4,14
    80007866:	0147a423          	sw	s4,8(a5)
  net.txq.desc[pkt_desc].addr = (uint64)packet_buf;
    8000786a:	0289b783          	ld	a5,40(s3)
    8000786e:	97a6                	add	a5,a5,s1
    80007870:	000b3703          	ld	a4,0(s6)
    80007874:	e398                	sd	a4,0(a5)
  net.txq.desc[pkt_desc].flags = 0;
    80007876:	0289b783          	ld	a5,40(s3)
    8000787a:	97a6                	add	a5,a5,s1
    8000787c:	00079623          	sh	zero,12(a5)
  //   if (res != 0)
  //     panic("failed to apply padding");
  // }

  // Tell the device first index in chain of descriptors
  net.txq.driver_area->ring[net.txq.driver_area->idx % NUM] = hdr_desc;
    80007880:	0309b703          	ld	a4,48(s3)
    80007884:	00275783          	lhu	a5,2(a4)
    80007888:	8b9d                	andi	a5,a5,7
    8000788a:	0786                	slli	a5,a5,0x1
    8000788c:	973e                	add	a4,a4,a5
    8000788e:	01571223          	sh	s5,4(a4)
  __sync_synchronize();
    80007892:	0330000f          	fence	rw,rw
  // Tell the device another avail ring entry is available
  net.txq.driver_area->idx++;
    80007896:	0309b703          	ld	a4,48(s3)
    8000789a:	00275783          	lhu	a5,2(a4)
    8000789e:	2785                	addiw	a5,a5,1
    800078a0:	00f71123          	sh	a5,2(a4)
  __sync_synchronize();
    800078a4:	0330000f          	fence	rw,rw

  uint16 prev_used_idx = net.txq.device_area->idx;
    800078a8:	0389b783          	ld	a5,56(s3)
    800078ac:	0027d483          	lhu	s1,2(a5)
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_TX;
    800078b0:	100027b7          	lui	a5,0x10002
    800078b4:	4705                	li	a4,1
    800078b6:	cbb8                	sw	a4,80(a5)
  release(&net.vnet_lock);
    800078b8:	0006a517          	auipc	a0,0x6a
    800078bc:	ed850513          	addi	a0,a0,-296 # 80071790 <net+0x10>
    800078c0:	ffff9097          	auipc	ra,0xffff9
    800078c4:	506080e7          	jalr	1286(ra) # 80000dc6 <release>

  // Wait for the device to use the descriptor. It indicates this by
  // decrementing the index. Polling helps to avoid race conditions
  while (net.txq.device_area->idx == prev_used_idx) {
    800078c8:	0389b783          	ld	a5,56(s3)
    800078cc:	0027d783          	lhu	a5,2(a5) # 10002002 <_entry-0x6fffdffe>
    800078d0:	04979b63          	bne	a5,s1,80007926 <transmit_packet+0x19e>
    800078d4:	86ce                	mv	a3,s3
    800078d6:	0004871b          	sext.w	a4,s1
    __sync_synchronize();
    800078da:	0330000f          	fence	rw,rw
  while (net.txq.device_area->idx == prev_used_idx) {
    800078de:	7e9c                	ld	a5,56(a3)
    800078e0:	0027d783          	lhu	a5,2(a5)
    800078e4:	fee78be3          	beq	a5,a4,800078da <transmit_packet+0x152>
    800078e8:	6b02                	ld	s6,0(sp)
    800078ea:	74a2                	ld	s1,40(sp)
    800078ec:	7902                	ld	s2,32(sp)
    800078ee:	6aa2                	ld	s5,8(sp)
  }
}
    800078f0:	70e2                	ld	ra,56(sp)
    800078f2:	7442                	ld	s0,48(sp)
    800078f4:	69e2                	ld	s3,24(sp)
    800078f6:	6a42                	ld	s4,16(sp)
    800078f8:	6121                	addi	sp,sp,64
    800078fa:	8082                	ret
    800078fc:	f426                	sd	s1,40(sp)
    800078fe:	f04a                	sd	s2,32(sp)
    80007900:	e456                	sd	s5,8(sp)
    80007902:	e05a                	sd	s6,0(sp)
    panic("failed to allocate header\n");
    80007904:	00004517          	auipc	a0,0x4
    80007908:	ffc50513          	addi	a0,a0,-4 # 8000b900 <etext+0x900>
    8000790c:	ffff9097          	auipc	ra,0xffff9
    80007910:	c54080e7          	jalr	-940(ra) # 80000560 <panic>
    release(&net.vnet_lock);
    80007914:	0006a517          	auipc	a0,0x6a
    80007918:	e7c50513          	addi	a0,a0,-388 # 80071790 <net+0x10>
    8000791c:	ffff9097          	auipc	ra,0xffff9
    80007920:	4aa080e7          	jalr	1194(ra) # 80000dc6 <release>
    return;
    80007924:	b7d9                	j	800078ea <transmit_packet+0x162>
    80007926:	6b02                	ld	s6,0(sp)
    80007928:	b7c9                	j	800078ea <transmit_packet+0x162>

000000008000792a <handle_packet>:

void 
handle_packet(uint8 *packet, uint len) 
{
    8000792a:	7179                	addi	sp,sp,-48
    8000792c:	f406                	sd	ra,40(sp)
    8000792e:	f022                	sd	s0,32(sp)
    80007930:	ec26                	sd	s1,24(sp)
    80007932:	e84a                	sd	s2,16(sp)
    80007934:	e44e                	sd	s3,8(sp)
    80007936:	1800                	addi	s0,sp,48
    80007938:	892a                	mv	s2,a0
    8000793a:	89ae                	mv	s3,a1
    // printf("Interrupt: received packet of length %d\n", len - 10);

    struct eth_frame *eth_frame = kalloc();
    8000793c:	ffff9097          	auipc	ra,0xffff9
    80007940:	2c8080e7          	jalr	712(ra) # 80000c04 <kalloc>
    80007944:	84aa                	mv	s1,a0
    memset(eth_frame, 0, PGSIZE);
    80007946:	6605                	lui	a2,0x1
    80007948:	4581                	li	a1,0
    8000794a:	ffff9097          	auipc	ra,0xffff9
    8000794e:	4c4080e7          	jalr	1220(ra) # 80000e0e <memset>

    if (parse_eth_packet(packet, len, eth_frame) == 0) {
    80007952:	8626                	mv	a2,s1
    80007954:	85ce                	mv	a1,s3
    80007956:	854a                	mv	a0,s2
    80007958:	00001097          	auipc	ra,0x1
    8000795c:	0f2080e7          	jalr	242(ra) # 80008a4a <parse_eth_packet>
    80007960:	e12d                	bnez	a0,800079c2 <handle_packet+0x98>
      switch(ntohs(eth_frame->hdr.type)) {
    80007962:	00c4c703          	lbu	a4,12(s1)
    80007966:	00d4c783          	lbu	a5,13(s1)
    8000796a:	07a2                	slli	a5,a5,0x8
    8000796c:	00e7e6b3          	or	a3,a5,a4
    80007970:	4721                	li	a4,8
    80007972:	00e68e63          	beq	a3,a4,8000798e <handle_packet+0x64>
    80007976:	2681                	sext.w	a3,a3
    80007978:	60800793          	li	a5,1544
    8000797c:	04f69363          	bne	a3,a5,800079c2 <handle_packet+0x98>
            handle_ip4_packet(ip4_pkt);
          } 
          kfree(ip4_pkt);
          break;
        case PROTO_ARP:
          arp_recv((struct arp_pkt *)eth_frame->payload);
    80007980:	00e48513          	addi	a0,s1,14
    80007984:	00002097          	auipc	ra,0x2
    80007988:	15e080e7          	jalr	350(ra) # 80009ae2 <arp_recv>
          break;
      }
    }

    // kfree(eth_frame);
}
    8000798c:	a81d                	j	800079c2 <handle_packet+0x98>
          struct ip4_frame *ip4_pkt = kalloc();
    8000798e:	ffff9097          	auipc	ra,0xffff9
    80007992:	276080e7          	jalr	630(ra) # 80000c04 <kalloc>
    80007996:	892a                	mv	s2,a0
          memset(ip4_pkt, 0, PGSIZE);
    80007998:	6605                	lui	a2,0x1
    8000799a:	4581                	li	a1,0
    8000799c:	ffff9097          	auipc	ra,0xffff9
    800079a0:	472080e7          	jalr	1138(ra) # 80000e0e <memset>
          if (parse_ip4_packet(eth_frame->payload, eth_frame->payload_len, ip4_pkt) == 0) {
    800079a4:	864a                	mv	a2,s2
    800079a6:	5ea4c583          	lbu	a1,1514(s1)
    800079aa:	00e48513          	addi	a0,s1,14
    800079ae:	00000097          	auipc	ra,0x0
    800079b2:	22c080e7          	jalr	556(ra) # 80007bda <parse_ip4_packet>
    800079b6:	cd09                	beqz	a0,800079d0 <handle_packet+0xa6>
          kfree(ip4_pkt);
    800079b8:	854a                	mv	a0,s2
    800079ba:	ffff9097          	auipc	ra,0xffff9
    800079be:	0e2080e7          	jalr	226(ra) # 80000a9c <kfree>
}
    800079c2:	70a2                	ld	ra,40(sp)
    800079c4:	7402                	ld	s0,32(sp)
    800079c6:	64e2                	ld	s1,24(sp)
    800079c8:	6942                	ld	s2,16(sp)
    800079ca:	69a2                	ld	s3,8(sp)
    800079cc:	6145                	addi	sp,sp,48
    800079ce:	8082                	ret
            handle_ip4_packet(ip4_pkt);
    800079d0:	854a                	mv	a0,s2
    800079d2:	00000097          	auipc	ra,0x0
    800079d6:	4e2080e7          	jalr	1250(ra) # 80007eb4 <handle_ip4_packet>
    800079da:	bff9                	j	800079b8 <handle_packet+0x8e>

00000000800079dc <receive_packet>:

uint16 
receive_packet() 
{
    800079dc:	7139                	addi	sp,sp,-64
    800079de:	fc06                	sd	ra,56(sp)
    800079e0:	f822                	sd	s0,48(sp)
    800079e2:	f426                	sd	s1,40(sp)
    800079e4:	0080                	addi	s0,sp,64
  acquire(&net.vnet_lock);
    800079e6:	0006a497          	auipc	s1,0x6a
    800079ea:	d9a48493          	addi	s1,s1,-614 # 80071780 <net>
    800079ee:	0006a517          	auipc	a0,0x6a
    800079f2:	da250513          	addi	a0,a0,-606 # 80071790 <net+0x10>
    800079f6:	ffff9097          	auipc	ra,0xffff9
    800079fa:	320080e7          	jalr	800(ra) # 80000d16 <acquire>
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    800079fe:	58fc                	lw	a5,116(s1)
    80007a00:	70b8                	ld	a4,96(s1)
    80007a02:	00275683          	lhu	a3,2(a4)
    80007a06:	0af68063          	beq	a3,a5,80007aa6 <receive_packet+0xca>
    80007a0a:	f04a                	sd	s2,32(sp)
    80007a0c:	ec4e                	sd	s3,24(sp)
    80007a0e:	e852                	sd	s4,16(sp)
    80007a10:	e456                	sd	s5,8(sp)
    int id = e->id;
    int len = e->len - 10;

    uint8 *packet = (uint8 *)net.rxq.desc[net.rxq.desc[id].next].addr + 10;

    release(&net.vnet_lock);
    80007a12:	0006a917          	auipc	s2,0x6a
    80007a16:	d7e90913          	addi	s2,s2,-642 # 80071790 <net+0x10>
      &net.rxq.device_area->ring[net.rxq.used_idx % NUM];
    80007a1a:	41f7d69b          	sraiw	a3,a5,0x1f
    80007a1e:	01d6d69b          	srliw	a3,a3,0x1d
    80007a22:	9fb5                	addw	a5,a5,a3
    80007a24:	8b9d                	andi	a5,a5,7
    80007a26:	9f95                	subw	a5,a5,a3
    80007a28:	078e                	slli	a5,a5,0x3
    80007a2a:	973e                	add	a4,a4,a5
    int id = e->id;
    80007a2c:	00472983          	lw	s3,4(a4)
    int len = e->len - 10;
    80007a30:	00872a83          	lw	s5,8(a4)
    80007a34:	3ad9                	addiw	s5,s5,-10
    uint8 *packet = (uint8 *)net.rxq.desc[net.rxq.desc[id].next].addr + 10;
    80007a36:	68bc                	ld	a5,80(s1)
    80007a38:	00499713          	slli	a4,s3,0x4
    80007a3c:	973e                	add	a4,a4,a5
    80007a3e:	00e75703          	lhu	a4,14(a4)
    80007a42:	0712                	slli	a4,a4,0x4
    80007a44:	97ba                	add	a5,a5,a4
    80007a46:	0007ba03          	ld	s4,0(a5)
    80007a4a:	0a29                	addi	s4,s4,10
    release(&net.vnet_lock);
    80007a4c:	854a                	mv	a0,s2
    80007a4e:	ffff9097          	auipc	ra,0xffff9
    80007a52:	378080e7          	jalr	888(ra) # 80000dc6 <release>

    handle_packet(packet, len);
    80007a56:	85d6                	mv	a1,s5
    80007a58:	8552                	mv	a0,s4
    80007a5a:	00000097          	auipc	ra,0x0
    80007a5e:	ed0080e7          	jalr	-304(ra) # 8000792a <handle_packet>

    acquire(&net.vnet_lock);
    80007a62:	854a                	mv	a0,s2
    80007a64:	ffff9097          	auipc	ra,0xffff9
    80007a68:	2b2080e7          	jalr	690(ra) # 80000d16 <acquire>
    // Move forward (with wrap)
    net.rxq.used_idx++;
    80007a6c:	58fc                	lw	a5,116(s1)
    80007a6e:	2785                	addiw	a5,a5,1
    80007a70:	d8fc                	sw	a5,116(s1)

    // Requeue descriptor for future packets
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    80007a72:	6cb8                	ld	a4,88(s1)
    80007a74:	00275783          	lhu	a5,2(a4)
    80007a78:	8b9d                	andi	a5,a5,7
    80007a7a:	0786                	slli	a5,a5,0x1
    80007a7c:	973e                	add	a4,a4,a5
    80007a7e:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    80007a82:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    80007a86:	6cb8                	ld	a4,88(s1)
    80007a88:	00275783          	lhu	a5,2(a4)
    80007a8c:	2785                	addiw	a5,a5,1
    80007a8e:	00f71123          	sh	a5,2(a4)
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    80007a92:	58fc                	lw	a5,116(s1)
    80007a94:	70b8                	ld	a4,96(s1)
    80007a96:	00275683          	lhu	a3,2(a4)
    80007a9a:	f8f690e3          	bne	a3,a5,80007a1a <receive_packet+0x3e>
    80007a9e:	7902                	ld	s2,32(sp)
    80007aa0:	69e2                	ld	s3,24(sp)
    80007aa2:	6a42                	ld	s4,16(sp)
    80007aa4:	6aa2                	ld	s5,8(sp)

    // notify device if needed
    // virtio_notify(&net.rxq);
  }
  release(&net.vnet_lock);
    80007aa6:	0006a517          	auipc	a0,0x6a
    80007aaa:	cea50513          	addi	a0,a0,-790 # 80071790 <net+0x10>
    80007aae:	ffff9097          	auipc	ra,0xffff9
    80007ab2:	318080e7          	jalr	792(ra) # 80000dc6 <release>
  return 0;
}
    80007ab6:	4501                	li	a0,0
    80007ab8:	70e2                	ld	ra,56(sp)
    80007aba:	7442                	ld	s0,48(sp)
    80007abc:	74a2                	ld	s1,40(sp)
    80007abe:	6121                	addi	sp,sp,64
    80007ac0:	8082                	ret

0000000080007ac2 <print_ip4_packet>:
#include "udp.h"
#include "ip4.h"

void 
print_ip4_packet(struct ip4_frame *ip)
{
    80007ac2:	7179                	addi	sp,sp,-48
    80007ac4:	f406                	sd	ra,40(sp)
    80007ac6:	f022                	sd	s0,32(sp)
    80007ac8:	ec26                	sd	s1,24(sp)
    80007aca:	1800                	addi	s0,sp,48
    80007acc:	84aa                	mv	s1,a0
  printf("\n");
    80007ace:	00003517          	auipc	a0,0x3
    80007ad2:	55250513          	addi	a0,a0,1362 # 8000b020 <etext+0x20>
    80007ad6:	ffff9097          	auipc	ra,0xffff9
    80007ada:	ad4080e7          	jalr	-1324(ra) # 800005aa <printf>
  printf("IPv%d packet from %d.%d.%d.%d to %d.%d.%d.%d",
      ip->hdr.ver_ihl >> 4,
      (ip->hdr.src_ip >> 24) & 0xFF, (ip->hdr.src_ip >> 16) & 0xFF,
    80007ade:	00c4c783          	lbu	a5,12(s1)
    80007ae2:	00d4c703          	lbu	a4,13(s1)
    80007ae6:	0722                	slli	a4,a4,0x8
    80007ae8:	8f5d                	or	a4,a4,a5
    80007aea:	00e4c783          	lbu	a5,14(s1)
    80007aee:	07c2                	slli	a5,a5,0x10
    80007af0:	8fd9                	or	a5,a5,a4
    80007af2:	00f4c603          	lbu	a2,15(s1)
    80007af6:	0662                	slli	a2,a2,0x18
    80007af8:	8e5d                	or	a2,a2,a5
      (ip->hdr.src_ip >> 8) & 0xFF,  ip->hdr.src_ip & 0xFF,
      (ip->hdr.dst_ip >> 24) & 0xFF, (ip->hdr.dst_ip >> 16) & 0xFF,
    80007afa:	0104c703          	lbu	a4,16(s1)
    80007afe:	0114c683          	lbu	a3,17(s1)
    80007b02:	06a2                	slli	a3,a3,0x8
    80007b04:	8ed9                	or	a3,a3,a4
    80007b06:	0124c703          	lbu	a4,18(s1)
    80007b0a:	0742                	slli	a4,a4,0x10
    80007b0c:	8f55                	or	a4,a4,a3
    80007b0e:	0134c803          	lbu	a6,19(s1)
    80007b12:	0862                	slli	a6,a6,0x18
    80007b14:	00e86833          	or	a6,a6,a4
    80007b18:	01085893          	srli	a7,a6,0x10
      (ip->hdr.src_ip >> 8) & 0xFF,  ip->hdr.src_ip & 0xFF,
    80007b1c:	00865713          	srli	a4,a2,0x8
      (ip->hdr.src_ip >> 24) & 0xFF, (ip->hdr.src_ip >> 16) & 0xFF,
    80007b20:	01065693          	srli	a3,a2,0x10
  printf("IPv%d packet from %d.%d.%d.%d to %d.%d.%d.%d",
    80007b24:	0004c583          	lbu	a1,0(s1)
    80007b28:	0ff87513          	zext.b	a0,a6
    80007b2c:	e42a                	sd	a0,8(sp)
      (ip->hdr.dst_ip >> 8) & 0xFF,  ip->hdr.dst_ip & 0xFF);
    80007b2e:	0088551b          	srliw	a0,a6,0x8
  printf("IPv%d packet from %d.%d.%d.%d to %d.%d.%d.%d",
    80007b32:	0ff57513          	zext.b	a0,a0
    80007b36:	e02a                	sd	a0,0(sp)
    80007b38:	0ff8f893          	zext.b	a7,a7
    80007b3c:	01885813          	srli	a6,a6,0x18
    80007b40:	0ff7f793          	zext.b	a5,a5
    80007b44:	0ff77713          	zext.b	a4,a4
    80007b48:	0ff6f693          	zext.b	a3,a3
    80007b4c:	8261                	srli	a2,a2,0x18
    80007b4e:	8191                	srli	a1,a1,0x4
    80007b50:	00004517          	auipc	a0,0x4
    80007b54:	dd050513          	addi	a0,a0,-560 # 8000b920 <etext+0x920>
    80007b58:	ffff9097          	auipc	ra,0xffff9
    80007b5c:	a52080e7          	jalr	-1454(ra) # 800005aa <printf>
  switch(ip->hdr.protocol) {
    80007b60:	0094c783          	lbu	a5,9(s1)
    80007b64:	4719                	li	a4,6
    80007b66:	00e78e63          	beq	a5,a4,80007b82 <print_ip4_packet+0xc0>
    80007b6a:	4745                	li	a4,17
    80007b6c:	04e78e63          	beq	a5,a4,80007bc8 <print_ip4_packet+0x106>
      break;
    case(IPPROTO_UDP):
      printf(", proto UDP");
      break;
    default:
      printf("unsupported protocol\n");
    80007b70:	00004517          	auipc	a0,0x4
    80007b74:	e0050513          	addi	a0,a0,-512 # 8000b970 <etext+0x970>
    80007b78:	ffff9097          	auipc	ra,0xffff9
    80007b7c:	a32080e7          	jalr	-1486(ra) # 800005aa <printf>
      break;
    80007b80:	a809                	j	80007b92 <print_ip4_packet+0xd0>
      printf(", proto TCP");
    80007b82:	00004517          	auipc	a0,0x4
    80007b86:	dce50513          	addi	a0,a0,-562 # 8000b950 <etext+0x950>
    80007b8a:	ffff9097          	auipc	ra,0xffff9
    80007b8e:	a20080e7          	jalr	-1504(ra) # 800005aa <printf>
  }
  printf(", payload %d bytes\n", ip->payload_len);
    80007b92:	5f04c583          	lbu	a1,1520(s1)
    80007b96:	5f14c783          	lbu	a5,1521(s1)
    80007b9a:	07a2                	slli	a5,a5,0x8
    80007b9c:	8ddd                	or	a1,a1,a5
    80007b9e:	00004517          	auipc	a0,0x4
    80007ba2:	dea50513          	addi	a0,a0,-534 # 8000b988 <etext+0x988>
    80007ba6:	ffff9097          	auipc	ra,0xffff9
    80007baa:	a04080e7          	jalr	-1532(ra) # 800005aa <printf>
  printf("\n");
    80007bae:	00003517          	auipc	a0,0x3
    80007bb2:	47250513          	addi	a0,a0,1138 # 8000b020 <etext+0x20>
    80007bb6:	ffff9097          	auipc	ra,0xffff9
    80007bba:	9f4080e7          	jalr	-1548(ra) # 800005aa <printf>
}
    80007bbe:	70a2                	ld	ra,40(sp)
    80007bc0:	7402                	ld	s0,32(sp)
    80007bc2:	64e2                	ld	s1,24(sp)
    80007bc4:	6145                	addi	sp,sp,48
    80007bc6:	8082                	ret
      printf(", proto UDP");
    80007bc8:	00004517          	auipc	a0,0x4
    80007bcc:	d9850513          	addi	a0,a0,-616 # 8000b960 <etext+0x960>
    80007bd0:	ffff9097          	auipc	ra,0xffff9
    80007bd4:	9da080e7          	jalr	-1574(ra) # 800005aa <printf>
      break;
    80007bd8:	bf6d                	j	80007b92 <print_ip4_packet+0xd0>

0000000080007bda <parse_ip4_packet>:

int 
parse_ip4_packet(uint8 *buf, int len, struct ip4_frame *pkt)
{
    80007bda:	87b2                	mv	a5,a2
  // printf("\tparsing ip packet\n");

  pkt->hdr.ver_ihl = buf[0];
    80007bdc:	00054703          	lbu	a4,0(a0)
    80007be0:	00e60023          	sb	a4,0(a2) # 1000 <_entry-0x7ffff000>
  pkt->hdr.tos = buf[1];
    80007be4:	00154703          	lbu	a4,1(a0)
    80007be8:	00e600a3          	sb	a4,1(a2)
  return (hostshort >> 8) | (hostshort << 8);
}

static inline uint16
ntohs(uint16 netshort) {
  return (netshort >> 8) | (netshort << 8);
    80007bec:	00255703          	lhu	a4,2(a0)
    80007bf0:	00875693          	srli	a3,a4,0x8
  pkt->hdr.total_len = ntohs(*(uint16 *)(buf + 2));
    80007bf4:	00d60123          	sb	a3,2(a2)
    80007bf8:	00e601a3          	sb	a4,3(a2)
    80007bfc:	00455703          	lhu	a4,4(a0)
    80007c00:	00875693          	srli	a3,a4,0x8
  pkt->hdr.identification = ntohs(*(uint16 *)(buf + 4));
    80007c04:	00d60223          	sb	a3,4(a2)
    80007c08:	00e602a3          	sb	a4,5(a2)
    80007c0c:	00655703          	lhu	a4,6(a0)
    80007c10:	00875693          	srli	a3,a4,0x8
  pkt->hdr.fragment_info = ntohs(*(uint16 *)(buf + 6));
    80007c14:	00d60323          	sb	a3,6(a2)
    80007c18:	00e603a3          	sb	a4,7(a2)
  pkt->hdr.ttl = buf[8];
    80007c1c:	00854703          	lbu	a4,8(a0)
    80007c20:	00e60423          	sb	a4,8(a2)
  pkt->hdr.protocol = buf[9];
    80007c24:	00954703          	lbu	a4,9(a0)
    80007c28:	00e604a3          	sb	a4,9(a2)
    80007c2c:	00a55703          	lhu	a4,10(a0)
    80007c30:	00875693          	srli	a3,a4,0x8
  pkt->hdr.hdr_csum = ntohs(*(uint16 *)(buf + 10));
    80007c34:	00d60523          	sb	a3,10(a2)
    80007c38:	00e605a3          	sb	a4,11(a2)
  pkt->hdr.src_ip = ntohl(*(uint32 *)(buf + 12));
    80007c3c:	4558                	lw	a4,12(a0)
}

static inline uint32
ntohl(uint32 netlong) {
  return ((netlong & 0x000000FFU) << 24) |
    80007c3e:	0187169b          	slliw	a3,a4,0x18
    ((netlong & 0x0000FF00U) << 8)  |
    ((netlong & 0x00FF0000U) >> 8)  |
    ((netlong & 0xFF000000U) >> 24);
    80007c42:	0187561b          	srliw	a2,a4,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80007c46:	8ed1                	or	a3,a3,a2
    ((netlong & 0x0000FF00U) << 8)  |
    80007c48:	0087161b          	slliw	a2,a4,0x8
    80007c4c:	00ff0837          	lui	a6,0xff0
    80007c50:	01067633          	and	a2,a2,a6
    ((netlong & 0x00FF0000U) >> 8)  |
    80007c54:	8ed1                	or	a3,a3,a2
    80007c56:	0087571b          	srliw	a4,a4,0x8
    80007c5a:	6641                	lui	a2,0x10
    80007c5c:	f0060613          	addi	a2,a2,-256 # ff00 <_entry-0x7fff0100>
    80007c60:	8f71                	and	a4,a4,a2
    80007c62:	00d78623          	sb	a3,12(a5)
    80007c66:	8321                	srli	a4,a4,0x8
    80007c68:	00e786a3          	sb	a4,13(a5)
    80007c6c:	0106d71b          	srliw	a4,a3,0x10
    80007c70:	00e78723          	sb	a4,14(a5)
    80007c74:	0186d69b          	srliw	a3,a3,0x18
    80007c78:	00d787a3          	sb	a3,15(a5)
  pkt->hdr.dst_ip = ntohl(*(uint32 *)(buf + 16));
    80007c7c:	4918                	lw	a4,16(a0)
  return ((netlong & 0x000000FFU) << 24) |
    80007c7e:	0187169b          	slliw	a3,a4,0x18
    ((netlong & 0xFF000000U) >> 24);
    80007c82:	0187589b          	srliw	a7,a4,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80007c86:	0116e6b3          	or	a3,a3,a7
    ((netlong & 0x0000FF00U) << 8)  |
    80007c8a:	0087189b          	slliw	a7,a4,0x8
    80007c8e:	0108f8b3          	and	a7,a7,a6
    ((netlong & 0x00FF0000U) >> 8)  |
    80007c92:	0116e6b3          	or	a3,a3,a7
    80007c96:	0087571b          	srliw	a4,a4,0x8
    80007c9a:	8f71                	and	a4,a4,a2
    80007c9c:	00d78823          	sb	a3,16(a5)
    80007ca0:	8321                	srli	a4,a4,0x8
    80007ca2:	00e788a3          	sb	a4,17(a5)
    80007ca6:	0106d71b          	srliw	a4,a3,0x10
    80007caa:	00e78923          	sb	a4,18(a5)
    80007cae:	0186d69b          	srliw	a3,a3,0x18
    80007cb2:	00d789a3          	sb	a3,19(a5)
  
  pkt->hdr.ver_ihl = buf[0];
    80007cb6:	00054883          	lbu	a7,0(a0)
    80007cba:	01178023          	sb	a7,0(a5)
  pkt->hdr.tos = buf[1];
    80007cbe:	00154703          	lbu	a4,1(a0)
    80007cc2:	00e780a3          	sb	a4,1(a5)
  return (netshort >> 8) | (netshort << 8);
    80007cc6:	00255683          	lhu	a3,2(a0)
    80007cca:	0086d713          	srli	a4,a3,0x8
    80007cce:	0086969b          	slliw	a3,a3,0x8
    80007cd2:	8f55                	or	a4,a4,a3
    80007cd4:	03071313          	slli	t1,a4,0x30
    80007cd8:	03035313          	srli	t1,t1,0x30
  pkt->hdr.total_len = ntohs(*(uint16 *)(buf + 2));
    80007cdc:	00e78123          	sb	a4,2(a5)
    80007ce0:	00835713          	srli	a4,t1,0x8
    80007ce4:	00e781a3          	sb	a4,3(a5)
    80007ce8:	00455703          	lhu	a4,4(a0)
    80007cec:	00875693          	srli	a3,a4,0x8
  pkt->hdr.identification = ntohs(*(uint16 *)(buf + 4));
    80007cf0:	00d78223          	sb	a3,4(a5)
    80007cf4:	00e782a3          	sb	a4,5(a5)
    80007cf8:	00655703          	lhu	a4,6(a0)
    80007cfc:	00875693          	srli	a3,a4,0x8
  pkt->hdr.fragment_info = ntohs(*(uint16 *)(buf + 6));
    80007d00:	00d78323          	sb	a3,6(a5)
    80007d04:	00e783a3          	sb	a4,7(a5)
  pkt->hdr.ttl = buf[8];
    80007d08:	00854703          	lbu	a4,8(a0)
    80007d0c:	00e78423          	sb	a4,8(a5)
  pkt->hdr.protocol = buf[9];
    80007d10:	00954703          	lbu	a4,9(a0)
    80007d14:	00e784a3          	sb	a4,9(a5)
    80007d18:	00a55703          	lhu	a4,10(a0)
    80007d1c:	00875693          	srli	a3,a4,0x8
  pkt->hdr.hdr_csum = ntohs(*(uint16 *)(buf + 10));
    80007d20:	00d78523          	sb	a3,10(a5)
    80007d24:	00e785a3          	sb	a4,11(a5)
  pkt->hdr.src_ip = ntohl(*(uint32 *)(buf + 12));
    80007d28:	4558                	lw	a4,12(a0)
  return ((netlong & 0x000000FFU) << 24) |
    80007d2a:	0187169b          	slliw	a3,a4,0x18
    ((netlong & 0xFF000000U) >> 24);
    80007d2e:	01875e1b          	srliw	t3,a4,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80007d32:	01c6e6b3          	or	a3,a3,t3
    ((netlong & 0x0000FF00U) << 8)  |
    80007d36:	00871e1b          	slliw	t3,a4,0x8
    80007d3a:	010e7e33          	and	t3,t3,a6
    ((netlong & 0x00FF0000U) >> 8)  |
    80007d3e:	01c6e6b3          	or	a3,a3,t3
    80007d42:	0087571b          	srliw	a4,a4,0x8
    80007d46:	8f71                	and	a4,a4,a2
    80007d48:	00d78623          	sb	a3,12(a5)
    80007d4c:	8321                	srli	a4,a4,0x8
    80007d4e:	00e786a3          	sb	a4,13(a5)
    80007d52:	0106d71b          	srliw	a4,a3,0x10
    80007d56:	00e78723          	sb	a4,14(a5)
    80007d5a:	0186d69b          	srliw	a3,a3,0x18
    80007d5e:	00d787a3          	sb	a3,15(a5)
  pkt->hdr.dst_ip = ntohl(*(uint32 *)(buf + 16));
    80007d62:	4918                	lw	a4,16(a0)
    ((netlong & 0xFF000000U) >> 24);
    80007d64:	0187569b          	srliw	a3,a4,0x18
  return ((netlong & 0x000000FFU) << 24) |
    80007d68:	01871e1b          	slliw	t3,a4,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80007d6c:	01c6e6b3          	or	a3,a3,t3
    ((netlong & 0x0000FF00U) << 8)  |
    80007d70:	00871e1b          	slliw	t3,a4,0x8
    80007d74:	010e7833          	and	a6,t3,a6
    ((netlong & 0x00FF0000U) >> 8)  |
    80007d78:	0106e6b3          	or	a3,a3,a6
    80007d7c:	0087571b          	srliw	a4,a4,0x8
    80007d80:	8f71                	and	a4,a4,a2
    80007d82:	00d78823          	sb	a3,16(a5)
    80007d86:	8321                	srli	a4,a4,0x8
    80007d88:	00e788a3          	sb	a4,17(a5)
    80007d8c:	0106d71b          	srliw	a4,a3,0x10
    80007d90:	00e78923          	sb	a4,18(a5)
    80007d94:	0186d69b          	srliw	a3,a3,0x18
    80007d98:	00d789a3          	sb	a3,19(a5)

  int hdr_len = (pkt->hdr.ver_ihl & 0x0F) * 4;
    80007d9c:	00f8f713          	andi	a4,a7,15
    80007da0:	0027171b          	slliw	a4,a4,0x2
  if (hdr_len < 20 || hdr_len > len) return -1;
    80007da4:	464d                	li	a2,19
    80007da6:	04e65263          	bge	a2,a4,80007dea <parse_ip4_packet+0x210>
    80007daa:	04e5c263          	blt	a1,a4,80007dee <parse_ip4_packet+0x214>
  // printf("\tvalid packet\n");
  if (pkt->hdr.total_len > len) return -1;
    80007dae:	2301                	sext.w	t1,t1
    80007db0:	0465c163          	blt	a1,t1,80007df2 <parse_ip4_packet+0x218>
{
    80007db4:	1141                	addi	sp,sp,-16
    80007db6:	e406                	sd	ra,8(sp)
    80007db8:	e022                	sd	s0,0(sp)
    80007dba:	0800                	addi	s0,sp,16

  pkt->payload_len = len - hdr_len;
    80007dbc:	9d99                	subw	a1,a1,a4
    80007dbe:	03059613          	slli	a2,a1,0x30
    80007dc2:	9241                	srli	a2,a2,0x30
    80007dc4:	5eb78823          	sb	a1,1520(a5)
    80007dc8:	00865693          	srli	a3,a2,0x8
    80007dcc:	5ed788a3          	sb	a3,1521(a5)
  memmove(pkt->payload, buf + hdr_len, pkt->payload_len);
    80007dd0:	00e505b3          	add	a1,a0,a4
    80007dd4:	01478513          	addi	a0,a5,20
    80007dd8:	ffff9097          	auipc	ra,0xffff9
    80007ddc:	09a080e7          	jalr	154(ra) # 80000e72 <memmove>

  return 0;
    80007de0:	4501                	li	a0,0
}
    80007de2:	60a2                	ld	ra,8(sp)
    80007de4:	6402                	ld	s0,0(sp)
    80007de6:	0141                	addi	sp,sp,16
    80007de8:	8082                	ret
  if (hdr_len < 20 || hdr_len > len) return -1;
    80007dea:	557d                	li	a0,-1
    80007dec:	8082                	ret
    80007dee:	557d                	li	a0,-1
    80007df0:	8082                	ret
  if (pkt->hdr.total_len > len) return -1;
    80007df2:	557d                	li	a0,-1
}
    80007df4:	8082                	ret

0000000080007df6 <build_ip4>:


void
build_ip4(struct ip4_frame *ip, uint32 src, uint32 dst, uint8 proto, uint16 len)
{
    80007df6:	1141                	addi	sp,sp,-16
    80007df8:	e406                	sd	ra,8(sp)
    80007dfa:	e022                	sd	s0,0(sp)
    80007dfc:	0800                	addi	s0,sp,16
  ip->hdr.ver_ihl = (4 << 4) | (5);  // v4 + IHL=5 (20 bytes)
    80007dfe:	04500793          	li	a5,69
    80007e02:	00f50023          	sb	a5,0(a0)
  ip->hdr.tos = 0;
    80007e06:	000500a3          	sb	zero,1(a0)
  return (hostshort >> 8) | (hostshort << 8);
    80007e0a:	0087579b          	srliw	a5,a4,0x8
  ip->hdr.total_len = htons(len);
    80007e0e:	00f50123          	sb	a5,2(a0)
    80007e12:	00e501a3          	sb	a4,3(a0)
  ip->hdr.identification = htons(0);   // you can increment per packet
    80007e16:	00050223          	sb	zero,4(a0)
    80007e1a:	000502a3          	sb	zero,5(a0)
  ip->hdr.fragment_info = htons(0);
    80007e1e:	00050323          	sb	zero,6(a0)
    80007e22:	000503a3          	sb	zero,7(a0)
  ip->hdr.ttl = 64;
    80007e26:	04000793          	li	a5,64
    80007e2a:	00f50423          	sb	a5,8(a0)
  ip->hdr.protocol = proto;
    80007e2e:	00d504a3          	sb	a3,9(a0)
  ip->hdr.hdr_csum = 0;
    80007e32:	00050523          	sb	zero,10(a0)
    80007e36:	000505a3          	sb	zero,11(a0)
}

static inline uint32 
htonl(uint32 hostlong) {
    return ((hostlong & 0x000000FFU) << 24) |
    80007e3a:	0185979b          	slliw	a5,a1,0x18
           ((hostlong & 0x0000FF00U) << 8)  |
           ((hostlong & 0x00FF0000U) >> 8)  |
           ((hostlong & 0xFF000000U) >> 24);
    80007e3e:	0185d71b          	srliw	a4,a1,0x18
           ((hostlong & 0x00FF0000U) >> 8)  |
    80007e42:	8fd9                	or	a5,a5,a4
           ((hostlong & 0x0000FF00U) << 8)  |
    80007e44:	0085971b          	slliw	a4,a1,0x8
    80007e48:	00ff0837          	lui	a6,0xff0
    80007e4c:	01077733          	and	a4,a4,a6
           ((hostlong & 0x00FF0000U) >> 8)  |
    80007e50:	8fd9                	or	a5,a5,a4
    80007e52:	0085d59b          	srliw	a1,a1,0x8
    80007e56:	6741                	lui	a4,0x10
    80007e58:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80007e5c:	8df9                	and	a1,a1,a4
  ip->hdr.src_ip = htonl(src);
    80007e5e:	00f50623          	sb	a5,12(a0)
    80007e62:	81a1                	srli	a1,a1,0x8
    80007e64:	00b506a3          	sb	a1,13(a0)
    80007e68:	0107d69b          	srliw	a3,a5,0x10
    80007e6c:	00d50723          	sb	a3,14(a0)
    80007e70:	0187d79b          	srliw	a5,a5,0x18
    80007e74:	00f507a3          	sb	a5,15(a0)
    return ((hostlong & 0x000000FFU) << 24) |
    80007e78:	0186179b          	slliw	a5,a2,0x18
           ((hostlong & 0xFF000000U) >> 24);
    80007e7c:	0186569b          	srliw	a3,a2,0x18
           ((hostlong & 0x00FF0000U) >> 8)  |
    80007e80:	8fd5                	or	a5,a5,a3
           ((hostlong & 0x0000FF00U) << 8)  |
    80007e82:	0086169b          	slliw	a3,a2,0x8
    80007e86:	0106f6b3          	and	a3,a3,a6
           ((hostlong & 0x00FF0000U) >> 8)  |
    80007e8a:	8fd5                	or	a5,a5,a3
    80007e8c:	0086561b          	srliw	a2,a2,0x8
    80007e90:	8e79                	and	a2,a2,a4
  ip->hdr.dst_ip = htonl(dst);
    80007e92:	00f50823          	sb	a5,16(a0)
    80007e96:	8221                	srli	a2,a2,0x8
    80007e98:	00c508a3          	sb	a2,17(a0)
    80007e9c:	0107d71b          	srliw	a4,a5,0x10
    80007ea0:	00e50923          	sb	a4,18(a0)
    80007ea4:	0187d79b          	srliw	a5,a5,0x18
    80007ea8:	00f509a3          	sb	a5,19(a0)
  // ip->hdr_csum = ip4_checksum((uint16*)ip, sizeof(struct ip4_hdr));
}
    80007eac:	60a2                	ld	ra,8(sp)
    80007eae:	6402                	ld	s0,0(sp)
    80007eb0:	0141                	addi	sp,sp,16
    80007eb2:	8082                	ret

0000000080007eb4 <handle_ip4_packet>:

int 
handle_ip4_packet(struct ip4_frame *ip4_pkt) 
{
    80007eb4:	1101                	addi	sp,sp,-32
    80007eb6:	ec06                	sd	ra,24(sp)
    80007eb8:	e822                	sd	s0,16(sp)
    80007eba:	e426                	sd	s1,8(sp)
    80007ebc:	1000                	addi	s0,sp,32
    80007ebe:	84aa                	mv	s1,a0
  switch(ip4_pkt->hdr.protocol) {
    80007ec0:	00954583          	lbu	a1,9(a0)
    80007ec4:	4799                	li	a5,6
    80007ec6:	02f58363          	beq	a1,a5,80007eec <handle_ip4_packet+0x38>
    80007eca:	47c5                	li	a5,17
    80007ecc:	06f58363          	beq	a1,a5,80007f32 <handle_ip4_packet+0x7e>
      if (parse_udp_packet(ip4_pkt->payload, ip4_pkt->payload_len, udp) == 0) {
        handle_udp_packet(udp);
      }
      break;
    default:
      printf("unsupported ip protocol: %d\n", ip4_pkt->hdr.protocol);
    80007ed0:	00004517          	auipc	a0,0x4
    80007ed4:	ad050513          	addi	a0,a0,-1328 # 8000b9a0 <etext+0x9a0>
    80007ed8:	ffff8097          	auipc	ra,0xffff8
    80007edc:	6d2080e7          	jalr	1746(ra) # 800005aa <printf>
      break;
  }
  return 0;
}
    80007ee0:	4501                	li	a0,0
    80007ee2:	60e2                	ld	ra,24(sp)
    80007ee4:	6442                	ld	s0,16(sp)
    80007ee6:	64a2                	ld	s1,8(sp)
    80007ee8:	6105                	addi	sp,sp,32
    80007eea:	8082                	ret
    80007eec:	e04a                	sd	s2,0(sp)
      struct tcp_frame *tcp = kalloc();
    80007eee:	ffff9097          	auipc	ra,0xffff9
    80007ef2:	d16080e7          	jalr	-746(ra) # 80000c04 <kalloc>
    80007ef6:	892a                	mv	s2,a0
      memset(tcp, 0, PGSIZE);
    80007ef8:	6605                	lui	a2,0x1
    80007efa:	4581                	li	a1,0
    80007efc:	ffff9097          	auipc	ra,0xffff9
    80007f00:	f12080e7          	jalr	-238(ra) # 80000e0e <memset>
      if (parse_tcp_packet(ip4_pkt->payload, ip4_pkt->payload_len, tcp) == 0) {
    80007f04:	5f04c583          	lbu	a1,1520(s1)
    80007f08:	5f14c783          	lbu	a5,1521(s1)
    80007f0c:	07a2                	slli	a5,a5,0x8
    80007f0e:	864a                	mv	a2,s2
    80007f10:	8ddd                	or	a1,a1,a5
    80007f12:	01448513          	addi	a0,s1,20
    80007f16:	00001097          	auipc	ra,0x1
    80007f1a:	f0e080e7          	jalr	-242(ra) # 80008e24 <parse_tcp_packet>
    80007f1e:	c119                	beqz	a0,80007f24 <handle_ip4_packet+0x70>
    80007f20:	6902                	ld	s2,0(sp)
    80007f22:	bf7d                	j	80007ee0 <handle_ip4_packet+0x2c>
        handle_tcp_packet(tcp);
    80007f24:	854a                	mv	a0,s2
    80007f26:	00001097          	auipc	ra,0x1
    80007f2a:	19c080e7          	jalr	412(ra) # 800090c2 <handle_tcp_packet>
    80007f2e:	6902                	ld	s2,0(sp)
    80007f30:	bf45                	j	80007ee0 <handle_ip4_packet+0x2c>
    80007f32:	e04a                	sd	s2,0(sp)
      struct udp_frame *udp = kalloc();
    80007f34:	ffff9097          	auipc	ra,0xffff9
    80007f38:	cd0080e7          	jalr	-816(ra) # 80000c04 <kalloc>
    80007f3c:	892a                	mv	s2,a0
      memset(udp, 0, PGSIZE);
    80007f3e:	6605                	lui	a2,0x1
    80007f40:	4581                	li	a1,0
    80007f42:	ffff9097          	auipc	ra,0xffff9
    80007f46:	ecc080e7          	jalr	-308(ra) # 80000e0e <memset>
      if (parse_udp_packet(ip4_pkt->payload, ip4_pkt->payload_len, udp) == 0) {
    80007f4a:	5f04c583          	lbu	a1,1520(s1)
    80007f4e:	5f14c783          	lbu	a5,1521(s1)
    80007f52:	07a2                	slli	a5,a5,0x8
    80007f54:	864a                	mv	a2,s2
    80007f56:	8ddd                	or	a1,a1,a5
    80007f58:	01448513          	addi	a0,s1,20
    80007f5c:	00002097          	auipc	ra,0x2
    80007f60:	8c4080e7          	jalr	-1852(ra) # 80009820 <parse_udp_packet>
    80007f64:	c119                	beqz	a0,80007f6a <handle_ip4_packet+0xb6>
    80007f66:	6902                	ld	s2,0(sp)
    80007f68:	bfa5                	j	80007ee0 <handle_ip4_packet+0x2c>
        handle_udp_packet(udp);
    80007f6a:	854a                	mv	a0,s2
    80007f6c:	00001097          	auipc	ra,0x1
    80007f70:	7e6080e7          	jalr	2022(ra) # 80009752 <handle_udp_packet>
    80007f74:	6902                	ld	s2,0(sp)
    80007f76:	b7ad                	j	80007ee0 <handle_ip4_packet+0x2c>

0000000080007f78 <my_strlen>:
  .ip_addr = temp_ip,
  .gateway = 0,
  .subnet_mask = 0,
};

int my_strlen(char *string) {
    80007f78:	1141                	addi	sp,sp,-16
    80007f7a:	e406                	sd	ra,8(sp)
    80007f7c:	e022                	sd	s0,0(sp)
    80007f7e:	0800                	addi	s0,sp,16
  for (int i = 0; ; i++) {
    if (string[i] == '\0')
    80007f80:	00054703          	lbu	a4,0(a0)
    80007f84:	0505                	addi	a0,a0,1
    80007f86:	87aa                	mv	a5,a0
    80007f88:	cf09                	beqz	a4,80007fa2 <my_strlen+0x2a>
    80007f8a:	86be                	mv	a3,a5
    80007f8c:	0785                	addi	a5,a5,1
    80007f8e:	fff7c703          	lbu	a4,-1(a5)
    80007f92:	ff65                	bnez	a4,80007f8a <my_strlen+0x12>
  for (int i = 0; ; i++) {
    80007f94:	40a6853b          	subw	a0,a3,a0
    80007f98:	2505                	addiw	a0,a0,1
      return i;
  }
}
    80007f9a:	60a2                	ld	ra,8(sp)
    80007f9c:	6402                	ld	s0,0(sp)
    80007f9e:	0141                	addi	sp,sp,16
    80007fa0:	8082                	ret
  for (int i = 0; ; i++) {
    80007fa2:	4501                	li	a0,0
    80007fa4:	bfdd                	j	80007f9a <my_strlen+0x22>

0000000080007fa6 <getaddrinfo>:

int 
getaddrinfo(char *node, char *port, const struct addrinfo *hints,
                struct addrinfo *result)
{
    80007fa6:	1141                	addi	sp,sp,-16
    80007fa8:	e406                	sd	ra,8(sp)
    80007faa:	e022                	sd	s0,0(sp)
    80007fac:	0800                	addi	s0,sp,16
  return 0;
}
    80007fae:	4501                	li	a0,0
    80007fb0:	60a2                	ld	ra,8(sp)
    80007fb2:	6402                	ld	s0,0(sp)
    80007fb4:	0141                	addi	sp,sp,16
    80007fb6:	8082                	ret

0000000080007fb8 <freeaddrinfo>:

int 
freeaddrinfo(struct addrinfo *res)
{
    80007fb8:	1141                	addi	sp,sp,-16
    80007fba:	e406                	sd	ra,8(sp)
    80007fbc:	e022                	sd	s0,0(sp)
    80007fbe:	0800                	addi	s0,sp,16
  return 0;
}
    80007fc0:	4501                	li	a0,0
    80007fc2:	60a2                	ld	ra,8(sp)
    80007fc4:	6402                	ld	s0,0(sp)
    80007fc6:	0141                	addi	sp,sp,16
    80007fc8:	8082                	ret

0000000080007fca <ip_to_u32>:

int ip_to_u32(const char *ip) {
    80007fca:	1101                	addi	sp,sp,-32
    80007fcc:	ec06                	sd	ra,24(sp)
    80007fce:	e822                	sd	s0,16(sp)
    80007fd0:	1000                	addi	s0,sp,32
  int parts[4] = {0};
    80007fd2:	fe043023          	sd	zero,-32(s0)
    80007fd6:	fe043423          	sd	zero,-24(s0)
  int i = 0;

  // Parse the dotted decimal parts
  while (*ip && i < 4) {
    80007fda:	00054783          	lbu	a5,0(a0)
    80007fde:	c3d5                	beqz	a5,80008082 <ip_to_u32+0xb8>
    80007fe0:	fe040813          	addi	a6,s0,-32
  int i = 0;
    80007fe4:	4581                	li	a1,0
    int num = 0;
    while (*ip >= '0' && *ip <= '9') {
    80007fe6:	4625                	li	a2,9
      num = num * 10 + (*ip - '0');
      ip++;
    }
    if (num < 0 || num > 255)
    80007fe8:	0ff00313          	li	t1,255
      return 0xFFFFFFFF;  // invalid
    parts[i++] = num;

    if (*ip == '.')
    80007fec:	02e00893          	li	a7,46
  while (*ip && i < 4) {
    80007ff0:	4e11                	li	t3,4
    80007ff2:	a801                	j	80008002 <ip_to_u32+0x38>
      ip++;
    80007ff4:	0505                	addi	a0,a0,1
  while (*ip && i < 4) {
    80007ff6:	00054783          	lbu	a5,0(a0)
    80007ffa:	cfbd                	beqz	a5,80008078 <ip_to_u32+0xae>
    80007ffc:	0811                	addi	a6,a6,4 # ff0004 <_entry-0x7f00fffc>
    80007ffe:	05c58863          	beq	a1,t3,8000804e <ip_to_u32+0x84>
    while (*ip >= '0' && *ip <= '9') {
    80008002:	00054703          	lbu	a4,0(a0)
    80008006:	fd07079b          	addiw	a5,a4,-48
    8000800a:	0ff7f793          	zext.b	a5,a5
    int num = 0;
    8000800e:	4681                	li	a3,0
    while (*ip >= '0' && *ip <= '9') {
    80008010:	02f66663          	bltu	a2,a5,8000803c <ip_to_u32+0x72>
      num = num * 10 + (*ip - '0');
    80008014:	0026979b          	slliw	a5,a3,0x2
    80008018:	9fb5                	addw	a5,a5,a3
    8000801a:	0017979b          	slliw	a5,a5,0x1
    8000801e:	fd07071b          	addiw	a4,a4,-48
    80008022:	00f706bb          	addw	a3,a4,a5
      ip++;
    80008026:	0505                	addi	a0,a0,1
    while (*ip >= '0' && *ip <= '9') {
    80008028:	00054703          	lbu	a4,0(a0)
    8000802c:	fd07079b          	addiw	a5,a4,-48
    80008030:	0ff7f793          	zext.b	a5,a5
    80008034:	fef670e3          	bgeu	a2,a5,80008014 <ip_to_u32+0x4a>
    if (num < 0 || num > 255)
    80008038:	04d36763          	bltu	t1,a3,80008086 <ip_to_u32+0xbc>
    parts[i++] = num;
    8000803c:	2585                	addiw	a1,a1,1
    8000803e:	00d82023          	sw	a3,0(a6)
    if (*ip == '.')
    80008042:	fb1709e3          	beq	a4,a7,80007ff4 <ip_to_u32+0x2a>
    else if (*ip && i < 4)
    80008046:	db45                	beqz	a4,80007ff6 <ip_to_u32+0x2c>
    80008048:	478d                	li	a5,3
    8000804a:	04b7d063          	bge	a5,a1,8000808a <ip_to_u32+0xc0>

  if (i != 4)
    return 0xFFFFFFFF;

  // Convert to big-endian 32-bit representation
  return (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | (parts[3]);
    8000804e:	fe042783          	lw	a5,-32(s0)
    80008052:	0187979b          	slliw	a5,a5,0x18
    80008056:	fe442703          	lw	a4,-28(s0)
    8000805a:	0107171b          	slliw	a4,a4,0x10
    8000805e:	8fd9                	or	a5,a5,a4
    80008060:	fec42703          	lw	a4,-20(s0)
    80008064:	8fd9                	or	a5,a5,a4
    80008066:	fe842503          	lw	a0,-24(s0)
    8000806a:	0085151b          	slliw	a0,a0,0x8
    8000806e:	8d5d                	or	a0,a0,a5
}
    80008070:	60e2                	ld	ra,24(sp)
    80008072:	6442                	ld	s0,16(sp)
    80008074:	6105                	addi	sp,sp,32
    80008076:	8082                	ret
  if (i != 4)
    80008078:	4791                	li	a5,4
    8000807a:	fcf58ae3          	beq	a1,a5,8000804e <ip_to_u32+0x84>
    return 0xFFFFFFFF;
    8000807e:	557d                	li	a0,-1
    80008080:	bfc5                	j	80008070 <ip_to_u32+0xa6>
    80008082:	557d                	li	a0,-1
    80008084:	b7f5                	j	80008070 <ip_to_u32+0xa6>
      return 0xFFFFFFFF;  // invalid
    80008086:	557d                	li	a0,-1
    80008088:	b7e5                	j	80008070 <ip_to_u32+0xa6>
      return 0xFFFFFFFF;  // invalid format
    8000808a:	557d                	li	a0,-1
    8000808c:	b7d5                	j	80008070 <ip_to_u32+0xa6>

000000008000808e <node_to_dns>:

int
node_to_dns(char *name, char *res)
{
    8000808e:	1101                	addi	sp,sp,-32
    80008090:	ec06                	sd	ra,24(sp)
    80008092:	e822                	sd	s0,16(sp)
    80008094:	e426                	sd	s1,8(sp)
    80008096:	e04a                	sd	s2,0(sp)
    80008098:	1000                	addi	s0,sp,32
    8000809a:	892a                	mv	s2,a0
    8000809c:	84ae                	mv	s1,a1
  int name_len = my_strlen(name);
    8000809e:	00000097          	auipc	ra,0x0
    800080a2:	eda080e7          	jalr	-294(ra) # 80007f78 <my_strlen>
  if (name_len > 253)
    800080a6:	0fd00793          	li	a5,253
    800080aa:	06a7c363          	blt	a5,a0,80008110 <node_to_dns+0x82>
    return LONG_DOMAIN;

  int len_index = 0;
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    800080ae:	4785                	li	a5,1
  int len_index = 0;
    800080b0:	4601                	li	a2,0
    if (i - len_index == 64)
      return LONG_DOMAIN_SECTION;

    if (name[i] == '.' || name[i] == '\0') {
    800080b2:	02e00813          	li	a6,46
    if (i - len_index == 64)
    800080b6:	04000893          	li	a7,64
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    800080ba:	02055463          	bgez	a0,800080e2 <node_to_dns+0x54>
      len_index = res_index;
    } else {
      res[res_index] = name[i];
    }
  }
  res[name_len + 1] = 0;
    800080be:	94aa                	add	s1,s1,a0
    800080c0:	000480a3          	sb	zero,1(s1)
  return 0;
    800080c4:	4501                	li	a0,0
    800080c6:	a0b1                	j	80008112 <node_to_dns+0x84>
      res[len_index] = i - len_index;
    800080c8:	00c485b3          	add	a1,s1,a2
    800080cc:	fff7871b          	addiw	a4,a5,-1
    800080d0:	9f11                	subw	a4,a4,a2
    800080d2:	00e58023          	sb	a4,0(a1)
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    800080d6:	0007871b          	sext.w	a4,a5
    800080da:	fee542e3          	blt	a0,a4,800080be <node_to_dns+0x30>
    if (i - len_index == 64)
    800080de:	0785                	addi	a5,a5,1
      len_index = res_index;
    800080e0:	8636                	mv	a2,a3
    800080e2:	0007869b          	sext.w	a3,a5
    if (name[i] == '.' || name[i] == '\0') {
    800080e6:	00f90733          	add	a4,s2,a5
    800080ea:	fff74703          	lbu	a4,-1(a4)
    800080ee:	fd070de3          	beq	a4,a6,800080c8 <node_to_dns+0x3a>
    800080f2:	db79                	beqz	a4,800080c8 <node_to_dns+0x3a>
      res[res_index] = name[i];
    800080f4:	00f485b3          	add	a1,s1,a5
    800080f8:	00e58023          	sb	a4,0(a1)
  for (int i = 0, res_index = 1; i < name_len + 1; res_index++, i++) {
    800080fc:	0007871b          	sext.w	a4,a5
    80008100:	fae54fe3          	blt	a0,a4,800080be <node_to_dns+0x30>
    if (i - len_index == 64)
    80008104:	0785                	addi	a5,a5,1
    80008106:	9e91                	subw	a3,a3,a2
    80008108:	fd169de3          	bne	a3,a7,800080e2 <node_to_dns+0x54>
      return LONG_DOMAIN_SECTION;
    8000810c:	4509                	li	a0,2
    8000810e:	a011                	j	80008112 <node_to_dns+0x84>
    return LONG_DOMAIN;
    80008110:	4505                	li	a0,1
}
    80008112:	60e2                	ld	ra,24(sp)
    80008114:	6442                	ld	s0,16(sp)
    80008116:	64a2                	ld	s1,8(sp)
    80008118:	6902                	ld	s2,0(sp)
    8000811a:	6105                	addi	sp,sp,32
    8000811c:	8082                	ret

000000008000811e <net_init>:

int net_init() {
    8000811e:	1141                	addi	sp,sp,-16
    80008120:	e406                	sd	ra,8(sp)
    80008122:	e022                	sd	s0,0(sp)
    80008124:	0800                	addi	s0,sp,16
  for (int i = 0; i < 6; i++) {
    80008126:	00069797          	auipc	a5,0x69
    8000812a:	65a78793          	addi	a5,a5,1626 # 80071780 <net>
    8000812e:	00008717          	auipc	a4,0x8
    80008132:	bde70713          	addi	a4,a4,-1058 # 8000fd0c <netconf+0x4>
    80008136:	00069617          	auipc	a2,0x69
    8000813a:	65060613          	addi	a2,a2,1616 # 80071786 <net+0x6>
    netconf.mac_addr[i] = net.cfg.mac[i];
    8000813e:	0007c683          	lbu	a3,0(a5)
    80008142:	00d70023          	sb	a3,0(a4)
  for (int i = 0; i < 6; i++) {
    80008146:	0785                	addi	a5,a5,1
    80008148:	0705                	addi	a4,a4,1
    8000814a:	fec79ae3          	bne	a5,a2,8000813e <net_init+0x20>
  }
  arp_insert(temp_ip, netconf.mac_addr);
    8000814e:	00008597          	auipc	a1,0x8
    80008152:	bbe58593          	addi	a1,a1,-1090 # 8000fd0c <netconf+0x4>
    80008156:	89feb537          	lui	a0,0x89feb
    8000815a:	8c050513          	addi	a0,a0,-1856 # ffffffff89fea8c0 <end+0xffffffff09f76fc8>
    8000815e:	00001097          	auipc	ra,0x1
    80008162:	7d0080e7          	jalr	2000(ra) # 8000992e <arp_insert>
  return 0;
}
    80008166:	4501                	li	a0,0
    80008168:	60a2                	ld	ra,8(sp)
    8000816a:	6402                	ld	s0,0(sp)
    8000816c:	0141                	addi	sp,sp,16
    8000816e:	8082                	ret

0000000080008170 <insert_port_binding>:
  .sendto   = 0,
  .recvfrom = 0,
  .close    = tcp_close,
};

int insert_port_binding(struct port_binding *bind) {
    80008170:	1141                	addi	sp,sp,-16
    80008172:	e406                	sd	ra,8(sp)
    80008174:	e022                	sd	s0,0(sp)
    80008176:	0800                	addi	s0,sp,16
  if (bind->sock->proto == IPPROTO_TCP)
    80008178:	651c                	ld	a5,8(a0)
    8000817a:	5b9c                	lw	a5,48(a5)
    8000817c:	4719                	li	a4,6
    8000817e:	00e78a63          	beq	a5,a4,80008192 <insert_port_binding+0x22>
    tcp_port_binds[bind->port] = bind;
  else if (bind->sock->proto == IPPROTO_UDP)
    80008182:	4745                	li	a4,17
    80008184:	02e78163          	beq	a5,a4,800081a6 <insert_port_binding+0x36>
    udp_port_binds[bind->port] = bind;
  return 0;
}
    80008188:	4501                	li	a0,0
    8000818a:	60a2                	ld	ra,8(sp)
    8000818c:	6402                	ld	s0,0(sp)
    8000818e:	0141                	addi	sp,sp,16
    80008190:	8082                	ret
    tcp_port_binds[bind->port] = bind;
    80008192:	00255703          	lhu	a4,2(a0)
    80008196:	070e                	slli	a4,a4,0x3
    80008198:	00069797          	auipc	a5,0x69
    8000819c:	66078793          	addi	a5,a5,1632 # 800717f8 <tcp_port_binds>
    800081a0:	97ba                	add	a5,a5,a4
    800081a2:	e388                	sd	a0,0(a5)
    800081a4:	b7d5                	j	80008188 <insert_port_binding+0x18>
    udp_port_binds[bind->port] = bind;
    800081a6:	00255703          	lhu	a4,2(a0)
    800081aa:	070e                	slli	a4,a4,0x3
    800081ac:	0006a797          	auipc	a5,0x6a
    800081b0:	64c78793          	addi	a5,a5,1612 # 800727f8 <udp_port_binds>
    800081b4:	97ba                	add	a5,a5,a4
    800081b6:	e388                	sd	a0,0(a5)
    800081b8:	bfc1                	j	80008188 <insert_port_binding+0x18>

00000000800081ba <remove_port_binding>:

int remove_port_binding(struct port_binding *bind) {
    800081ba:	1141                	addi	sp,sp,-16
    800081bc:	e406                	sd	ra,8(sp)
    800081be:	e022                	sd	s0,0(sp)
    800081c0:	0800                	addi	s0,sp,16
    800081c2:	87aa                	mv	a5,a0
  if (bind->sock->proto == IPPROTO_TCP) {
    800081c4:	6518                	ld	a4,8(a0)
    800081c6:	5b18                	lw	a4,48(a4)
    800081c8:	4699                	li	a3,6
    800081ca:	00d70a63          	beq	a4,a3,800081de <remove_port_binding+0x24>
    if (tcp_port_binds[bind->port] == 0)
      return -1;
    tcp_port_binds[bind->port] = bind;
  } else if (bind->sock->proto == IPPROTO_UDP) {
    800081ce:	46c5                	li	a3,17
    if (udp_port_binds[bind->port] == 0)
      return -1;
    udp_port_binds[bind->port] = 0;
  }
  return 0;
    800081d0:	4501                	li	a0,0
  } else if (bind->sock->proto == IPPROTO_UDP) {
    800081d2:	02d70a63          	beq	a4,a3,80008206 <remove_port_binding+0x4c>
}
    800081d6:	60a2                	ld	ra,8(sp)
    800081d8:	6402                	ld	s0,0(sp)
    800081da:	0141                	addi	sp,sp,16
    800081dc:	8082                	ret
    if (tcp_port_binds[bind->port] == 0)
    800081de:	00255703          	lhu	a4,2(a0)
    800081e2:	00371613          	slli	a2,a4,0x3
    800081e6:	00069697          	auipc	a3,0x69
    800081ea:	61268693          	addi	a3,a3,1554 # 800717f8 <tcp_port_binds>
    800081ee:	96b2                	add	a3,a3,a2
    800081f0:	6294                	ld	a3,0(a3)
    800081f2:	ce95                	beqz	a3,8000822e <remove_port_binding+0x74>
    tcp_port_binds[bind->port] = bind;
    800081f4:	00069697          	auipc	a3,0x69
    800081f8:	60468693          	addi	a3,a3,1540 # 800717f8 <tcp_port_binds>
    800081fc:	00c68733          	add	a4,a3,a2
    80008200:	e308                	sd	a0,0(a4)
  return 0;
    80008202:	4501                	li	a0,0
    80008204:	bfc9                	j	800081d6 <remove_port_binding+0x1c>
    if (udp_port_binds[bind->port] == 0)
    80008206:	0027d783          	lhu	a5,2(a5)
    8000820a:	00379693          	slli	a3,a5,0x3
    8000820e:	0006a717          	auipc	a4,0x6a
    80008212:	5ea70713          	addi	a4,a4,1514 # 800727f8 <udp_port_binds>
    80008216:	9736                	add	a4,a4,a3
    80008218:	6318                	ld	a4,0(a4)
    8000821a:	cf01                	beqz	a4,80008232 <remove_port_binding+0x78>
    udp_port_binds[bind->port] = 0;
    8000821c:	0006a717          	auipc	a4,0x6a
    80008220:	5dc70713          	addi	a4,a4,1500 # 800727f8 <udp_port_binds>
    80008224:	00d707b3          	add	a5,a4,a3
    80008228:	0007b023          	sd	zero,0(a5)
    8000822c:	b76d                	j	800081d6 <remove_port_binding+0x1c>
      return -1;
    8000822e:	557d                	li	a0,-1
    80008230:	b75d                	j	800081d6 <remove_port_binding+0x1c>
      return -1;
    80008232:	557d                	li	a0,-1
    80008234:	b74d                	j	800081d6 <remove_port_binding+0x1c>

0000000080008236 <tcp_socket_list_insert>:

int tcp_socket_list_insert(struct socket *sock) {
    80008236:	1141                	addi	sp,sp,-16
    80008238:	e406                	sd	ra,8(sp)
    8000823a:	e022                	sd	s0,0(sp)
    8000823c:	0800                	addi	s0,sp,16
  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    if (tcp_sock_list->socks[i] == 0) {
    8000823e:	00008797          	auipc	a5,0x8
    80008242:	b9a7b783          	ld	a5,-1126(a5) # 8000fdd8 <tcp_sock_list>
    80008246:	639c                	ld	a5,0(a5)
    80008248:	6685                	lui	a3,0x1
    8000824a:	96be                	add	a3,a3,a5
    8000824c:	6398                	ld	a4,0(a5)
    8000824e:	c709                	beqz	a4,80008258 <tcp_socket_list_insert+0x22>
  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    80008250:	07a1                	addi	a5,a5,8
    80008252:	fed79de3          	bne	a5,a3,8000824c <tcp_socket_list_insert+0x16>
    80008256:	a809                	j	80008268 <tcp_socket_list_insert+0x32>
      tcp_sock_list->socks[i] = sock;
    80008258:	e388                	sd	a0,0(a5)
      tcp_sock_list->size++;
    8000825a:	00008717          	auipc	a4,0x8
    8000825e:	b7e73703          	ld	a4,-1154(a4) # 8000fdd8 <tcp_sock_list>
    80008262:	471c                	lw	a5,8(a4)
    80008264:	2785                	addiw	a5,a5,1
    80008266:	c71c                	sw	a5,8(a4)
      break;
    }
  }
  return 0;
}
    80008268:	4501                	li	a0,0
    8000826a:	60a2                	ld	ra,8(sp)
    8000826c:	6402                	ld	s0,0(sp)
    8000826e:	0141                	addi	sp,sp,16
    80008270:	8082                	ret

0000000080008272 <udp_socket_list_insert>:

int udp_socket_list_insert(struct socket *sock) {
    80008272:	1141                	addi	sp,sp,-16
    80008274:	e406                	sd	ra,8(sp)
    80008276:	e022                	sd	s0,0(sp)
    80008278:	0800                	addi	s0,sp,16
  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    if (udp_sock_list->socks[i] == 0) {
    8000827a:	00008797          	auipc	a5,0x8
    8000827e:	b567b783          	ld	a5,-1194(a5) # 8000fdd0 <udp_sock_list>
    80008282:	639c                	ld	a5,0(a5)
    80008284:	6685                	lui	a3,0x1
    80008286:	96be                	add	a3,a3,a5
    80008288:	6398                	ld	a4,0(a5)
    8000828a:	c709                	beqz	a4,80008294 <udp_socket_list_insert+0x22>
  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    8000828c:	07a1                	addi	a5,a5,8
    8000828e:	fed79de3          	bne	a5,a3,80008288 <udp_socket_list_insert+0x16>
    80008292:	a809                	j	800082a4 <udp_socket_list_insert+0x32>
      udp_sock_list->socks[i] = sock;
    80008294:	e388                	sd	a0,0(a5)
      udp_sock_list->size++;
    80008296:	00008717          	auipc	a4,0x8
    8000829a:	b3a73703          	ld	a4,-1222(a4) # 8000fdd0 <udp_sock_list>
    8000829e:	471c                	lw	a5,8(a4)
    800082a0:	2785                	addiw	a5,a5,1
    800082a2:	c71c                	sw	a5,8(a4)
      break;
    }
  }
  return 0;
}
    800082a4:	4501                	li	a0,0
    800082a6:	60a2                	ld	ra,8(sp)
    800082a8:	6402                	ld	s0,0(sp)
    800082aa:	0141                	addi	sp,sp,16
    800082ac:	8082                	ret

00000000800082ae <getsock>:

struct socket* getsock(int fd) {
    800082ae:	1141                	addi	sp,sp,-16
    800082b0:	e406                	sd	ra,8(sp)
    800082b2:	e022                	sd	s0,0(sp)
    800082b4:	0800                	addi	s0,sp,16
  for (int i = 0; i < sock_list->size; i++) {
    800082b6:	00008797          	auipc	a5,0x8
    800082ba:	b2a7b783          	ld	a5,-1238(a5) # 8000fde0 <sock_list>
    800082be:	4794                	lw	a3,8(a5)
    800082c0:	02d05263          	blez	a3,800082e4 <getsock+0x36>
    800082c4:	862a                	mv	a2,a0
    800082c6:	639c                	ld	a5,0(a5)
    800082c8:	068e                	slli	a3,a3,0x3
    800082ca:	96be                	add	a3,a3,a5
    if (sock_list->socks[i]->fd == fd) {
    800082cc:	6388                	ld	a0,0(a5)
    800082ce:	4138                	lw	a4,64(a0)
    800082d0:	00c70663          	beq	a4,a2,800082dc <getsock+0x2e>
  for (int i = 0; i < sock_list->size; i++) {
    800082d4:	07a1                	addi	a5,a5,8
    800082d6:	fed79be3          	bne	a5,a3,800082cc <getsock+0x1e>
      return sock_list->socks[i];
    }
  }
  return 0;
    800082da:	4501                	li	a0,0
}
    800082dc:	60a2                	ld	ra,8(sp)
    800082de:	6402                	ld	s0,0(sp)
    800082e0:	0141                	addi	sp,sp,16
    800082e2:	8082                	ret
  return 0;
    800082e4:	4501                	li	a0,0
    800082e6:	bfdd                	j	800082dc <getsock+0x2e>

00000000800082e8 <socket_list_remove>:

int socket_list_remove(int fd) {
    800082e8:	1101                	addi	sp,sp,-32
    800082ea:	ec06                	sd	ra,24(sp)
    800082ec:	e822                	sd	s0,16(sp)
    800082ee:	e04a                	sd	s2,0(sp)
    800082f0:	1000                	addi	s0,sp,32
  if (sock_list->socks[fd] == 0) {
    800082f2:	00008917          	auipc	s2,0x8
    800082f6:	aee93903          	ld	s2,-1298(s2) # 8000fde0 <sock_list>
    800082fa:	00093783          	ld	a5,0(s2)
    800082fe:	00351713          	slli	a4,a0,0x3
    80008302:	97ba                	add	a5,a5,a4
    80008304:	639c                	ld	a5,0(a5)
    80008306:	c7c5                	beqz	a5,800083ae <socket_list_remove+0xc6>
    80008308:	e426                	sd	s1,8(sp)
    8000830a:	84aa                	mv	s1,a0
    return -1;
  } else {
    struct socket *sock = getsock(fd);
    8000830c:	00000097          	auipc	ra,0x0
    80008310:	fa2080e7          	jalr	-94(ra) # 800082ae <getsock>
    80008314:	86aa                	mv	a3,a0
    if (!sock)
      return -1;
    80008316:	557d                	li	a0,-1
    if (!sock)
    80008318:	cec9                	beqz	a3,800083b2 <socket_list_remove+0xca>
    sock_list->size--;
    8000831a:	00892783          	lw	a5,8(s2)
    8000831e:	37fd                	addiw	a5,a5,-1
    80008320:	00f92423          	sw	a5,8(s2)
    if (sock->type == SOCK_STREAM) {
    80008324:	5adc                	lw	a5,52(a3)
    80008326:	4705                	li	a4,1
    80008328:	02e78163          	beq	a5,a4,8000834a <socket_list_remove+0x62>
          tcp_sock_list->socks[i] = 0;
          tcp_sock_list->size--;
          break;
        }
      }
    } else if (sock->type == SOCK_DGRAM) {
    8000832c:	4709                	li	a4,2
    8000832e:	04e78763          	beq	a5,a4,8000837c <socket_list_remove+0x94>
          udp_sock_list->size--;
          break;
        }
      }
    }
    kfree(sock);
    80008332:	8536                	mv	a0,a3
    80008334:	ffff8097          	auipc	ra,0xffff8
    80008338:	768080e7          	jalr	1896(ra) # 80000a9c <kfree>
    return 1;
    8000833c:	4505                	li	a0,1
    8000833e:	64a2                	ld	s1,8(sp)
  }
}
    80008340:	60e2                	ld	ra,24(sp)
    80008342:	6442                	ld	s0,16(sp)
    80008344:	6902                	ld	s2,0(sp)
    80008346:	6105                	addi	sp,sp,32
    80008348:	8082                	ret
        if (tcp_sock_list->socks[i]->fd == fd) {
    8000834a:	00008797          	auipc	a5,0x8
    8000834e:	a8e7b783          	ld	a5,-1394(a5) # 8000fdd8 <tcp_sock_list>
    80008352:	639c                	ld	a5,0(a5)
    80008354:	6605                	lui	a2,0x1
    80008356:	963e                	add	a2,a2,a5
    80008358:	6398                	ld	a4,0(a5)
    8000835a:	4338                	lw	a4,64(a4)
    8000835c:	00970663          	beq	a4,s1,80008368 <socket_list_remove+0x80>
      for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    80008360:	07a1                	addi	a5,a5,8
    80008362:	fec79be3          	bne	a5,a2,80008358 <socket_list_remove+0x70>
    80008366:	b7f1                	j	80008332 <socket_list_remove+0x4a>
          tcp_sock_list->socks[i] = 0;
    80008368:	0007b023          	sd	zero,0(a5)
          tcp_sock_list->size--;
    8000836c:	00008717          	auipc	a4,0x8
    80008370:	a6c73703          	ld	a4,-1428(a4) # 8000fdd8 <tcp_sock_list>
    80008374:	471c                	lw	a5,8(a4)
    80008376:	37fd                	addiw	a5,a5,-1
    80008378:	c71c                	sw	a5,8(a4)
          break;
    8000837a:	bf65                	j	80008332 <socket_list_remove+0x4a>
        if (udp_sock_list->socks[i]->fd == fd) {
    8000837c:	00008797          	auipc	a5,0x8
    80008380:	a547b783          	ld	a5,-1452(a5) # 8000fdd0 <udp_sock_list>
    80008384:	639c                	ld	a5,0(a5)
    80008386:	6605                	lui	a2,0x1
    80008388:	963e                	add	a2,a2,a5
    8000838a:	6398                	ld	a4,0(a5)
    8000838c:	4338                	lw	a4,64(a4)
    8000838e:	00970663          	beq	a4,s1,8000839a <socket_list_remove+0xb2>
      for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    80008392:	07a1                	addi	a5,a5,8
    80008394:	fec79be3          	bne	a5,a2,8000838a <socket_list_remove+0xa2>
    80008398:	bf69                	j	80008332 <socket_list_remove+0x4a>
          udp_sock_list->socks[i] = 0;
    8000839a:	0007b023          	sd	zero,0(a5)
          udp_sock_list->size--;
    8000839e:	00008717          	auipc	a4,0x8
    800083a2:	a3273703          	ld	a4,-1486(a4) # 8000fdd0 <udp_sock_list>
    800083a6:	471c                	lw	a5,8(a4)
    800083a8:	37fd                	addiw	a5,a5,-1
    800083aa:	c71c                	sw	a5,8(a4)
          break;
    800083ac:	b759                	j	80008332 <socket_list_remove+0x4a>
    return -1;
    800083ae:	557d                	li	a0,-1
    800083b0:	bf41                	j	80008340 <socket_list_remove+0x58>
    800083b2:	64a2                	ld	s1,8(sp)
    800083b4:	b771                	j	80008340 <socket_list_remove+0x58>

00000000800083b6 <sock_list_insert>:

int
sock_list_insert(struct socket *sock)
{
  int idx = -1;
  if (sock_list->size == MAX_SOCKET_CAPACITY) {
    800083b6:	00008797          	auipc	a5,0x8
    800083ba:	a2a7b783          	ld	a5,-1494(a5) # 8000fde0 <sock_list>
    800083be:	4794                	lw	a3,8(a5)
    800083c0:	20000713          	li	a4,512
    800083c4:	0ae68a63          	beq	a3,a4,80008478 <sock_list_insert+0xc2>
{
    800083c8:	1101                	addi	sp,sp,-32
    800083ca:	ec06                	sd	ra,24(sp)
    800083cc:	e822                	sd	s0,16(sp)
    800083ce:	e426                	sd	s1,8(sp)
    800083d0:	1000                	addi	s0,sp,32
    800083d2:	862a                	mv	a2,a0
    800083d4:	639c                	ld	a5,0(a5)
    return -1;
  }
  
  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    800083d6:	4481                	li	s1,0
    800083d8:	86ba                	mv	a3,a4
    if (sock_list->socks[i] == 0) {
    800083da:	6398                	ld	a4,0(a5)
    800083dc:	c719                	beqz	a4,800083ea <sock_list_insert+0x34>
  for (int i = 0; i < MAX_SOCKET_CAPACITY; i++) {
    800083de:	2485                	addiw	s1,s1,1
    800083e0:	07a1                	addi	a5,a5,8
    800083e2:	fed49ce3          	bne	s1,a3,800083da <sock_list_insert+0x24>
  int idx = -1;
    800083e6:	54fd                	li	s1,-1
    800083e8:	a809                	j	800083fa <sock_list_insert+0x44>
      sock_list->socks[i] = sock;
    800083ea:	e390                	sd	a2,0(a5)
      sock_list->size++;
    800083ec:	00008717          	auipc	a4,0x8
    800083f0:	9f473703          	ld	a4,-1548(a4) # 8000fde0 <sock_list>
    800083f4:	471c                	lw	a5,8(a4)
    800083f6:	2785                	addiw	a5,a5,1
    800083f8:	c71c                	sw	a5,8(a4)
      idx = i;
      break;
    }
  }
  if (sock->type == SOCK_DGRAM) {
    800083fa:	5a5c                	lw	a5,52(a2)
    800083fc:	4709                	li	a4,2
    800083fe:	00e78b63          	beq	a5,a4,80008414 <sock_list_insert+0x5e>
    if (udp_socket_list_insert(sock) == -1) {
      sock_list->socks[idx] = 0;
      sock_list->size--;
      return -1;
    }
  } else if (sock->type == SOCK_STREAM) {
    80008402:	4705                	li	a4,1
      sock_list->socks[idx] = 0;
      sock_list->size--;
      return -1;
    }
  }
  return 0;
    80008404:	4501                	li	a0,0
  } else if (sock->type == SOCK_STREAM) {
    80008406:	04e78063          	beq	a5,a4,80008446 <sock_list_insert+0x90>
}
    8000840a:	60e2                	ld	ra,24(sp)
    8000840c:	6442                	ld	s0,16(sp)
    8000840e:	64a2                	ld	s1,8(sp)
    80008410:	6105                	addi	sp,sp,32
    80008412:	8082                	ret
    if (udp_socket_list_insert(sock) == -1) {
    80008414:	8532                	mv	a0,a2
    80008416:	00000097          	auipc	ra,0x0
    8000841a:	e5c080e7          	jalr	-420(ra) # 80008272 <udp_socket_list_insert>
    8000841e:	57fd                	li	a5,-1
    80008420:	00f50463          	beq	a0,a5,80008428 <sock_list_insert+0x72>
  return 0;
    80008424:	4501                	li	a0,0
    80008426:	b7d5                	j	8000840a <sock_list_insert+0x54>
      sock_list->socks[idx] = 0;
    80008428:	00008717          	auipc	a4,0x8
    8000842c:	9b870713          	addi	a4,a4,-1608 # 8000fde0 <sock_list>
    80008430:	631c                	ld	a5,0(a4)
    80008432:	639c                	ld	a5,0(a5)
    80008434:	048e                	slli	s1,s1,0x3
    80008436:	97a6                	add	a5,a5,s1
    80008438:	0007b023          	sd	zero,0(a5)
      sock_list->size--;
    8000843c:	6318                	ld	a4,0(a4)
    8000843e:	471c                	lw	a5,8(a4)
    80008440:	37fd                	addiw	a5,a5,-1
    80008442:	c71c                	sw	a5,8(a4)
      return -1;
    80008444:	b7d9                	j	8000840a <sock_list_insert+0x54>
    if (tcp_socket_list_insert(sock) == -1) {
    80008446:	8532                	mv	a0,a2
    80008448:	00000097          	auipc	ra,0x0
    8000844c:	dee080e7          	jalr	-530(ra) # 80008236 <tcp_socket_list_insert>
    80008450:	57fd                	li	a5,-1
    80008452:	00f50463          	beq	a0,a5,8000845a <sock_list_insert+0xa4>
  return 0;
    80008456:	4501                	li	a0,0
    80008458:	bf4d                	j	8000840a <sock_list_insert+0x54>
      sock_list->socks[idx] = 0;
    8000845a:	00008717          	auipc	a4,0x8
    8000845e:	98670713          	addi	a4,a4,-1658 # 8000fde0 <sock_list>
    80008462:	631c                	ld	a5,0(a4)
    80008464:	639c                	ld	a5,0(a5)
    80008466:	048e                	slli	s1,s1,0x3
    80008468:	97a6                	add	a5,a5,s1
    8000846a:	0007b023          	sd	zero,0(a5)
      sock_list->size--;
    8000846e:	6318                	ld	a4,0(a4)
    80008470:	471c                	lw	a5,8(a4)
    80008472:	37fd                	addiw	a5,a5,-1
    80008474:	c71c                	sw	a5,8(a4)
      return -1;
    80008476:	bf51                	j	8000840a <sock_list_insert+0x54>
    return -1;
    80008478:	557d                	li	a0,-1
}
    8000847a:	8082                	ret

000000008000847c <bind>:

int
bind(int socket, const struct sockaddr *sock_address, socklen_t address_len)
{
    8000847c:	1101                	addi	sp,sp,-32
    8000847e:	ec06                	sd	ra,24(sp)
    80008480:	e822                	sd	s0,16(sp)
    80008482:	e426                	sd	s1,8(sp)
    80008484:	e04a                	sd	s2,0(sp)
    80008486:	1000                	addi	s0,sp,32
    80008488:	84ae                	mv	s1,a1
    8000848a:	8932                	mv	s2,a2
  struct socket *sock = getsock(socket);
    8000848c:	00000097          	auipc	ra,0x0
    80008490:	e22080e7          	jalr	-478(ra) # 800082ae <getsock>
  if (!sock)
    80008494:	cd01                	beqz	a0,800084ac <bind+0x30>
    return -1;
  return sock->ops->bind(sock, sock_address, address_len);
    80008496:	653c                	ld	a5,72(a0)
    80008498:	639c                	ld	a5,0(a5)
    8000849a:	864a                	mv	a2,s2
    8000849c:	85a6                	mv	a1,s1
    8000849e:	9782                	jalr	a5
}
    800084a0:	60e2                	ld	ra,24(sp)
    800084a2:	6442                	ld	s0,16(sp)
    800084a4:	64a2                	ld	s1,8(sp)
    800084a6:	6902                	ld	s2,0(sp)
    800084a8:	6105                	addi	sp,sp,32
    800084aa:	8082                	ret
    return -1;
    800084ac:	557d                	li	a0,-1
    800084ae:	bfcd                	j	800084a0 <bind+0x24>

00000000800084b0 <listen>:

int
listen(int socket, int backlog)
{
    800084b0:	1101                	addi	sp,sp,-32
    800084b2:	ec06                	sd	ra,24(sp)
    800084b4:	e822                	sd	s0,16(sp)
    800084b6:	e426                	sd	s1,8(sp)
    800084b8:	1000                	addi	s0,sp,32
    800084ba:	84ae                	mv	s1,a1
  struct socket *sock = getsock(socket);
    800084bc:	00000097          	auipc	ra,0x0
    800084c0:	df2080e7          	jalr	-526(ra) # 800082ae <getsock>
  if (!sock)
    800084c4:	c919                	beqz	a0,800084da <listen+0x2a>
    return -1;
  sock->ops->listen(sock, backlog);
    800084c6:	653c                	ld	a5,72(a0)
    800084c8:	6b9c                	ld	a5,16(a5)
    800084ca:	85a6                	mv	a1,s1
    800084cc:	9782                	jalr	a5
  return 0;
    800084ce:	4501                	li	a0,0
}
    800084d0:	60e2                	ld	ra,24(sp)
    800084d2:	6442                	ld	s0,16(sp)
    800084d4:	64a2                	ld	s1,8(sp)
    800084d6:	6105                	addi	sp,sp,32
    800084d8:	8082                	ret
    return -1;
    800084da:	557d                	li	a0,-1
    800084dc:	bfd5                	j	800084d0 <listen+0x20>

00000000800084de <accept>:

int
accept(int socket, struct sockaddr *address, socklen_t address_len)
{
    800084de:	1101                	addi	sp,sp,-32
    800084e0:	ec06                	sd	ra,24(sp)
    800084e2:	e822                	sd	s0,16(sp)
    800084e4:	1000                	addi	s0,sp,32
  struct sockaddr_in *sockaddr = (struct sockaddr_in *)address;
  struct socket *sock = getsock(socket);
    800084e6:	00000097          	auipc	ra,0x0
    800084ea:	dc8080e7          	jalr	-568(ra) # 800082ae <getsock>
  if (!sock)
    800084ee:	c151                	beqz	a0,80008572 <accept+0x94>
    800084f0:	e426                	sd	s1,8(sp)
    800084f2:	84aa                	mv	s1,a0
    return -1;

  if (sock->proto != IPPROTO_TCP || sock->type != SOCK_STREAM) {
    800084f4:	7918                	ld	a4,48(a0)
    800084f6:	4785                	li	a5,1
    800084f8:	1782                	slli	a5,a5,0x20
    800084fa:	0799                	addi	a5,a5,6
    800084fc:	04f71563          	bne	a4,a5,80008546 <accept+0x68>
    printf("accept: improper protocol and sock_type combination\n");
    return -1;
  }

  if (sock->state != LISTENING){
    80008500:	5d58                	lw	a4,60(a0)
    80008502:	03400793          	li	a5,52
    80008506:	04f71b63          	bne	a4,a5,8000855c <accept+0x7e>
    8000850a:	e04a                	sd	s2,0(sp)
    printf("accept: socket is not listening\n");
    return -1;
  }

  acquire(&sock->lock);
    8000850c:	00850913          	addi	s2,a0,8
    80008510:	854a                	mv	a0,s2
    80008512:	ffff9097          	auipc	ra,0xffff9
    80008516:	804080e7          	jalr	-2044(ra) # 80000d16 <acquire>
  while (!sock->pending) {
    8000851a:	609c                	ld	a5,0(s1)
    8000851c:	eb89                	bnez	a5,8000852e <accept+0x50>
    sleep(sock, &sock->lock);
    8000851e:	85ca                	mv	a1,s2
    80008520:	8526                	mv	a0,s1
    80008522:	ffffa097          	auipc	ra,0xffffa
    80008526:	1e6080e7          	jalr	486(ra) # 80002708 <sleep>
  while (!sock->pending) {
    8000852a:	609c                	ld	a5,0(s1)
    8000852c:	dbed                	beqz	a5,8000851e <accept+0x40>
  }
  release(&sock->lock);
    8000852e:	854a                	mv	a0,s2
    80008530:	ffff9097          	auipc	ra,0xffff9
    80008534:	896080e7          	jalr	-1898(ra) # 80000dc6 <release>

  return sock->fd;
    80008538:	40a8                	lw	a0,64(s1)
    8000853a:	64a2                	ld	s1,8(sp)
    8000853c:	6902                	ld	s2,0(sp)
}
    8000853e:	60e2                	ld	ra,24(sp)
    80008540:	6442                	ld	s0,16(sp)
    80008542:	6105                	addi	sp,sp,32
    80008544:	8082                	ret
    printf("accept: improper protocol and sock_type combination\n");
    80008546:	00003517          	auipc	a0,0x3
    8000854a:	47a50513          	addi	a0,a0,1146 # 8000b9c0 <etext+0x9c0>
    8000854e:	ffff8097          	auipc	ra,0xffff8
    80008552:	05c080e7          	jalr	92(ra) # 800005aa <printf>
    return -1;
    80008556:	557d                	li	a0,-1
    80008558:	64a2                	ld	s1,8(sp)
    8000855a:	b7d5                	j	8000853e <accept+0x60>
    printf("accept: socket is not listening\n");
    8000855c:	00003517          	auipc	a0,0x3
    80008560:	49c50513          	addi	a0,a0,1180 # 8000b9f8 <etext+0x9f8>
    80008564:	ffff8097          	auipc	ra,0xffff8
    80008568:	046080e7          	jalr	70(ra) # 800005aa <printf>
    return -1;
    8000856c:	557d                	li	a0,-1
    8000856e:	64a2                	ld	s1,8(sp)
    80008570:	b7f9                	j	8000853e <accept+0x60>
    return -1;
    80008572:	557d                	li	a0,-1
    80008574:	b7e9                	j	8000853e <accept+0x60>

0000000080008576 <connect>:

int
connect(int socket, const struct sockaddr *address, socklen_t address_len)
{
    80008576:	1141                	addi	sp,sp,-16
    80008578:	e406                	sd	ra,8(sp)
    8000857a:	e022                	sd	s0,0(sp)
    8000857c:	0800                	addi	s0,sp,16
  return 0;
}
    8000857e:	4501                	li	a0,0
    80008580:	60a2                	ld	ra,8(sp)
    80008582:	6402                	ld	s0,0(sp)
    80008584:	0141                	addi	sp,sp,16
    80008586:	8082                	ret

0000000080008588 <initsocket>:

int 
initsocket(struct socket *sock, int sock_family, int sock_type, int protocol)
{
    80008588:	1141                	addi	sp,sp,-16
    8000858a:	e406                	sd	ra,8(sp)
    8000858c:	e022                	sd	s0,0(sp)
    8000858e:	0800                	addi	s0,sp,16
  if (sock_family != AF_INET)  {
    80008590:	4789                	li	a5,2
    80008592:	04f59e63          	bne	a1,a5,800085ee <initsocket+0x66>
    printf("socket: invalid sock_family\n");
    return -1;
  }

  if (sock_type != SOCK_STREAM && sock_type != SOCK_DGRAM) {
    80008596:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    8000859a:	4705                	li	a4,1
    8000859c:	06f76363          	bltu	a4,a5,80008602 <initsocket+0x7a>
    printf("socket: invalid sock_type\n");
    return -1;
  }

  if (protocol == 0) {
    800085a0:	eabd                	bnez	a3,80008616 <initsocket+0x8e>
    if (sock_type == SOCK_STREAM)
    800085a2:	4785                	li	a5,1
    800085a4:	0af60963          	beq	a2,a5,80008656 <initsocket+0xce>
      (protocol == IPPROTO_UDP && sock_type != SOCK_DGRAM)) {
    printf("socket: invalid protocol-socktype combination\n");
    return -1;
  }

  sock->proto = protocol;
    800085a8:	47c5                	li	a5,17
    800085aa:	d91c                	sw	a5,48(a0)
  sock->src_ip = netconf.ip_addr;
    800085ac:	00007717          	auipc	a4,0x7
    800085b0:	75c72703          	lw	a4,1884(a4) # 8000fd08 <netconf>
    800085b4:	00007797          	auipc	a5,0x7
    800085b8:	7a478793          	addi	a5,a5,1956 # 8000fd58 <udp_ops>
    800085bc:	d118                	sw	a4,32(a0)
  sock->type = sock_type;
    800085be:	d950                	sw	a2,52(a0)
  sock->family = sock_family;
    800085c0:	4709                	li	a4,2
    800085c2:	dd18                	sw	a4,56(a0)
  sock->state = CLOSED;
    800085c4:	03200713          	li	a4,50
    800085c8:	dd58                	sw	a4,60(a0)
  sock->rx_head = 0;
    800085ca:	04053823          	sd	zero,80(a0)
  sock->rx_tail = 0;
    800085ce:	04053c23          	sd	zero,88(a0)

  if (protocol == IPPROTO_TCP)
    sock->ops = &tcp_ops;
    800085d2:	e53c                	sd	a5,72(a0)
  if (protocol == IPPROTO_UDP)
    sock->ops = &udp_ops;

  if (sock_list_insert(sock) == -1)
    800085d4:	00000097          	auipc	ra,0x0
    800085d8:	de2080e7          	jalr	-542(ra) # 800083b6 <sock_list_insert>
    800085dc:	0505                	addi	a0,a0,1
    800085de:	00153513          	seqz	a0,a0
    800085e2:	40a0053b          	negw	a0,a0
    return -1;

  return 0;
}
    800085e6:	60a2                	ld	ra,8(sp)
    800085e8:	6402                	ld	s0,0(sp)
    800085ea:	0141                	addi	sp,sp,16
    800085ec:	8082                	ret
    printf("socket: invalid sock_family\n");
    800085ee:	00003517          	auipc	a0,0x3
    800085f2:	43250513          	addi	a0,a0,1074 # 8000ba20 <etext+0xa20>
    800085f6:	ffff8097          	auipc	ra,0xffff8
    800085fa:	fb4080e7          	jalr	-76(ra) # 800005aa <printf>
    return -1;
    800085fe:	557d                	li	a0,-1
    80008600:	b7dd                	j	800085e6 <initsocket+0x5e>
    printf("socket: invalid sock_type\n");
    80008602:	00003517          	auipc	a0,0x3
    80008606:	43e50513          	addi	a0,a0,1086 # 8000ba40 <etext+0xa40>
    8000860a:	ffff8097          	auipc	ra,0xffff8
    8000860e:	fa0080e7          	jalr	-96(ra) # 800005aa <printf>
    return -1;
    80008612:	557d                	li	a0,-1
    80008614:	bfc9                	j	800085e6 <initsocket+0x5e>
  if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP) {
    80008616:	4799                	li	a5,6
    80008618:	02f68c63          	beq	a3,a5,80008650 <initsocket+0xc8>
    8000861c:	47c5                	li	a5,17
    8000861e:	00f69f63          	bne	a3,a5,8000863c <initsocket+0xb4>
      (protocol == IPPROTO_UDP && sock_type != SOCK_DGRAM)) {
    80008622:	4789                	li	a5,2
    80008624:	f8f602e3          	beq	a2,a5,800085a8 <initsocket+0x20>
    printf("socket: invalid protocol-socktype combination\n");
    80008628:	00003517          	auipc	a0,0x3
    8000862c:	45850513          	addi	a0,a0,1112 # 8000ba80 <etext+0xa80>
    80008630:	ffff8097          	auipc	ra,0xffff8
    80008634:	f7a080e7          	jalr	-134(ra) # 800005aa <printf>
    return -1;
    80008638:	557d                	li	a0,-1
    8000863a:	b775                	j	800085e6 <initsocket+0x5e>
    printf("socket: invalid protocol\n");
    8000863c:	00003517          	auipc	a0,0x3
    80008640:	42450513          	addi	a0,a0,1060 # 8000ba60 <etext+0xa60>
    80008644:	ffff8097          	auipc	ra,0xffff8
    80008648:	f66080e7          	jalr	-154(ra) # 800005aa <printf>
    return -1;
    8000864c:	557d                	li	a0,-1
    8000864e:	bf61                	j	800085e6 <initsocket+0x5e>
  if ((protocol == IPPROTO_TCP && sock_type != SOCK_STREAM) ||
    80008650:	4785                	li	a5,1
    80008652:	fcf61be3          	bne	a2,a5,80008628 <initsocket+0xa0>
  sock->proto = protocol;
    80008656:	4799                	li	a5,6
    80008658:	d91c                	sw	a5,48(a0)
  sock->src_ip = netconf.ip_addr;
    8000865a:	00007717          	auipc	a4,0x7
    8000865e:	6ae72703          	lw	a4,1710(a4) # 8000fd08 <netconf>
    80008662:	00007797          	auipc	a5,0x7
    80008666:	6be78793          	addi	a5,a5,1726 # 8000fd20 <tcp_ops>
    8000866a:	bf89                	j	800085bc <initsocket+0x34>

000000008000866c <close>:

int 
close(int fd)
{
    8000866c:	1141                	addi	sp,sp,-16
    8000866e:	e406                	sd	ra,8(sp)
    80008670:	e022                	sd	s0,0(sp)
    80008672:	0800                	addi	s0,sp,16
  return 0;
}
    80008674:	4501                	li	a0,0
    80008676:	60a2                	ld	ra,8(sp)
    80008678:	6402                	ld	s0,0(sp)
    8000867a:	0141                	addi	sp,sp,16
    8000867c:	8082                	ret

000000008000867e <send>:

int 
send(int socket, const void *msg, int length, int flags)
{
    8000867e:	1141                	addi	sp,sp,-16
    80008680:	e406                	sd	ra,8(sp)
    80008682:	e022                	sd	s0,0(sp)
    80008684:	0800                	addi	s0,sp,16
  return 0;
}
    80008686:	4501                	li	a0,0
    80008688:	60a2                	ld	ra,8(sp)
    8000868a:	6402                	ld	s0,0(sp)
    8000868c:	0141                	addi	sp,sp,16
    8000868e:	8082                	ret

0000000080008690 <recv>:

int 
recv(int socket, void *buf, int length, int flags)
{
    80008690:	1141                	addi	sp,sp,-16
    80008692:	e406                	sd	ra,8(sp)
    80008694:	e022                	sd	s0,0(sp)
    80008696:	0800                	addi	s0,sp,16
  return 0;
}
    80008698:	4501                	li	a0,0
    8000869a:	60a2                	ld	ra,8(sp)
    8000869c:	6402                	ld	s0,0(sp)
    8000869e:	0141                	addi	sp,sp,16
    800086a0:	8082                	ret

00000000800086a2 <sendto>:

int 
sendto(int socket, const void *msg, int length, int flags, 
    const struct sockaddr *dst_addr, socklen_t dst_len)
{
    800086a2:	7139                	addi	sp,sp,-64
    800086a4:	fc06                	sd	ra,56(sp)
    800086a6:	f822                	sd	s0,48(sp)
    800086a8:	f426                	sd	s1,40(sp)
    800086aa:	f04a                	sd	s2,32(sp)
    800086ac:	ec4e                	sd	s3,24(sp)
    800086ae:	e852                	sd	s4,16(sp)
    800086b0:	e456                	sd	s5,8(sp)
    800086b2:	0080                	addi	s0,sp,64
    800086b4:	8aae                	mv	s5,a1
    800086b6:	8a32                	mv	s4,a2
    800086b8:	84b6                	mv	s1,a3
    800086ba:	893a                	mv	s2,a4
    800086bc:	89be                	mv	s3,a5
  struct socket *sock = getsock(socket);
    800086be:	00000097          	auipc	ra,0x0
    800086c2:	bf0080e7          	jalr	-1040(ra) # 800082ae <getsock>
  if (!sock)
    800086c6:	c11d                	beqz	a0,800086ec <sendto+0x4a>
    return -1;
  return sock->ops->sendto(sock, msg, length, flags, dst_addr, dst_len);
    800086c8:	653c                	ld	a5,72(a0)
    800086ca:	0207b803          	ld	a6,32(a5)
    800086ce:	87ce                	mv	a5,s3
    800086d0:	874a                	mv	a4,s2
    800086d2:	86a6                	mv	a3,s1
    800086d4:	8652                	mv	a2,s4
    800086d6:	85d6                	mv	a1,s5
    800086d8:	9802                	jalr	a6
}
    800086da:	70e2                	ld	ra,56(sp)
    800086dc:	7442                	ld	s0,48(sp)
    800086de:	74a2                	ld	s1,40(sp)
    800086e0:	7902                	ld	s2,32(sp)
    800086e2:	69e2                	ld	s3,24(sp)
    800086e4:	6a42                	ld	s4,16(sp)
    800086e6:	6aa2                	ld	s5,8(sp)
    800086e8:	6121                	addi	sp,sp,64
    800086ea:	8082                	ret
    return -1;
    800086ec:	557d                	li	a0,-1
    800086ee:	b7f5                	j	800086da <sendto+0x38>

00000000800086f0 <recvfrom>:

int 
recvfrom(int socket, void *buffer, int length, int flags,
    const struct sockaddr *addr, socklen_t *addrlen)
{
    800086f0:	7139                	addi	sp,sp,-64
    800086f2:	fc06                	sd	ra,56(sp)
    800086f4:	f822                	sd	s0,48(sp)
    800086f6:	f426                	sd	s1,40(sp)
    800086f8:	f04a                	sd	s2,32(sp)
    800086fa:	ec4e                	sd	s3,24(sp)
    800086fc:	e852                	sd	s4,16(sp)
    800086fe:	e456                	sd	s5,8(sp)
    80008700:	0080                	addi	s0,sp,64
    80008702:	8aae                	mv	s5,a1
    80008704:	8a32                	mv	s4,a2
    80008706:	84b6                	mv	s1,a3
    80008708:	893a                	mv	s2,a4
    8000870a:	89be                	mv	s3,a5
  struct socket *sock = getsock(socket);
    8000870c:	00000097          	auipc	ra,0x0
    80008710:	ba2080e7          	jalr	-1118(ra) # 800082ae <getsock>
  if (!sock)
    80008714:	c11d                	beqz	a0,8000873a <recvfrom+0x4a>
    return -1;
  return sock->ops->recvfrom(sock, buffer, length, flags, addr, addrlen);
    80008716:	653c                	ld	a5,72(a0)
    80008718:	0287b803          	ld	a6,40(a5)
    8000871c:	87ce                	mv	a5,s3
    8000871e:	874a                	mv	a4,s2
    80008720:	86a6                	mv	a3,s1
    80008722:	8652                	mv	a2,s4
    80008724:	85d6                	mv	a1,s5
    80008726:	9802                	jalr	a6
}
    80008728:	70e2                	ld	ra,56(sp)
    8000872a:	7442                	ld	s0,48(sp)
    8000872c:	74a2                	ld	s1,40(sp)
    8000872e:	7902                	ld	s2,32(sp)
    80008730:	69e2                	ld	s3,24(sp)
    80008732:	6a42                	ld	s4,16(sp)
    80008734:	6aa2                	ld	s5,8(sp)
    80008736:	6121                	addi	sp,sp,64
    80008738:	8082                	ret
    return -1;
    8000873a:	557d                	li	a0,-1
    8000873c:	b7f5                	j	80008728 <recvfrom+0x38>

000000008000873e <sock_list_init>:

void sock_list_init() {
    8000873e:	1101                	addi	sp,sp,-32
    80008740:	ec06                	sd	ra,24(sp)
    80008742:	e822                	sd	s0,16(sp)
    80008744:	1000                	addi	s0,sp,32
  sock_list = (struct socket_list *)kalloc();
    80008746:	ffff8097          	auipc	ra,0xffff8
    8000874a:	4be080e7          	jalr	1214(ra) # 80000c04 <kalloc>
    8000874e:	00007797          	auipc	a5,0x7
    80008752:	68a7b923          	sd	a0,1682(a5) # 8000fde0 <sock_list>
  if (!sock_list) {
    80008756:	c90d                	beqz	a0,80008788 <sock_list_init+0x4a>
    80008758:	e426                	sd	s1,8(sp)
    8000875a:	84aa                	mv	s1,a0
    printf("ERROR: failed to allocate tcp_sock_list\n");
    return;
  }

  sock_list->socks = (struct socket **)kalloc();
    8000875c:	ffff8097          	auipc	ra,0xffff8
    80008760:	4a8080e7          	jalr	1192(ra) # 80000c04 <kalloc>
    80008764:	e088                	sd	a0,0(s1)
  if (!sock_list->socks) {
    80008766:	00007797          	auipc	a5,0x7
    8000876a:	67a7b783          	ld	a5,1658(a5) # 8000fde0 <sock_list>
    8000876e:	6388                	ld	a0,0(a5)
    80008770:	c50d                	beqz	a0,8000879a <sock_list_init+0x5c>
    printf("ERROR: failed to allocate tcp_sock_list->socks\n");
    kfree(sock_list);
    return;
  }
  memset(sock_list->socks, 0, PGSIZE);
    80008772:	6605                	lui	a2,0x1
    80008774:	4581                	li	a1,0
    80008776:	ffff8097          	auipc	ra,0xffff8
    8000877a:	698080e7          	jalr	1688(ra) # 80000e0e <memset>
    8000877e:	64a2                	ld	s1,8(sp)
}
    80008780:	60e2                	ld	ra,24(sp)
    80008782:	6442                	ld	s0,16(sp)
    80008784:	6105                	addi	sp,sp,32
    80008786:	8082                	ret
    printf("ERROR: failed to allocate tcp_sock_list\n");
    80008788:	00003517          	auipc	a0,0x3
    8000878c:	32850513          	addi	a0,a0,808 # 8000bab0 <etext+0xab0>
    80008790:	ffff8097          	auipc	ra,0xffff8
    80008794:	e1a080e7          	jalr	-486(ra) # 800005aa <printf>
    return;
    80008798:	b7e5                	j	80008780 <sock_list_init+0x42>
    printf("ERROR: failed to allocate tcp_sock_list->socks\n");
    8000879a:	00003517          	auipc	a0,0x3
    8000879e:	34650513          	addi	a0,a0,838 # 8000bae0 <etext+0xae0>
    800087a2:	ffff8097          	auipc	ra,0xffff8
    800087a6:	e08080e7          	jalr	-504(ra) # 800005aa <printf>
    kfree(sock_list);
    800087aa:	00007517          	auipc	a0,0x7
    800087ae:	63653503          	ld	a0,1590(a0) # 8000fde0 <sock_list>
    800087b2:	ffff8097          	auipc	ra,0xffff8
    800087b6:	2ea080e7          	jalr	746(ra) # 80000a9c <kfree>
    return;
    800087ba:	64a2                	ld	s1,8(sp)
    800087bc:	b7d1                	j	80008780 <sock_list_init+0x42>

00000000800087be <tcp_sock_list_init>:

void tcp_sock_list_init() {
    800087be:	1101                	addi	sp,sp,-32
    800087c0:	ec06                	sd	ra,24(sp)
    800087c2:	e822                	sd	s0,16(sp)
    800087c4:	1000                	addi	s0,sp,32
  tcp_sock_list = (struct socket_list *)kalloc();
    800087c6:	ffff8097          	auipc	ra,0xffff8
    800087ca:	43e080e7          	jalr	1086(ra) # 80000c04 <kalloc>
    800087ce:	00007797          	auipc	a5,0x7
    800087d2:	60a7b523          	sd	a0,1546(a5) # 8000fdd8 <tcp_sock_list>
  if (!tcp_sock_list) {
    800087d6:	c90d                	beqz	a0,80008808 <tcp_sock_list_init+0x4a>
    800087d8:	e426                	sd	s1,8(sp)
    800087da:	84aa                	mv	s1,a0
    printf("ERROR: failed to allocate tcp_sock_list\n");
    return;
  }

  tcp_sock_list->socks = (struct socket **)kalloc();
    800087dc:	ffff8097          	auipc	ra,0xffff8
    800087e0:	428080e7          	jalr	1064(ra) # 80000c04 <kalloc>
    800087e4:	e088                	sd	a0,0(s1)
  if (!tcp_sock_list->socks) {
    800087e6:	00007797          	auipc	a5,0x7
    800087ea:	5f27b783          	ld	a5,1522(a5) # 8000fdd8 <tcp_sock_list>
    800087ee:	6388                	ld	a0,0(a5)
    800087f0:	c50d                	beqz	a0,8000881a <tcp_sock_list_init+0x5c>
    printf("ERROR: failed to allocate tcp_sock_list->socks\n");
    kfree(tcp_sock_list);
    return;
  }
  memset(tcp_sock_list->socks, 0, PGSIZE);
    800087f2:	6605                	lui	a2,0x1
    800087f4:	4581                	li	a1,0
    800087f6:	ffff8097          	auipc	ra,0xffff8
    800087fa:	618080e7          	jalr	1560(ra) # 80000e0e <memset>
    800087fe:	64a2                	ld	s1,8(sp)
}
    80008800:	60e2                	ld	ra,24(sp)
    80008802:	6442                	ld	s0,16(sp)
    80008804:	6105                	addi	sp,sp,32
    80008806:	8082                	ret
    printf("ERROR: failed to allocate tcp_sock_list\n");
    80008808:	00003517          	auipc	a0,0x3
    8000880c:	2a850513          	addi	a0,a0,680 # 8000bab0 <etext+0xab0>
    80008810:	ffff8097          	auipc	ra,0xffff8
    80008814:	d9a080e7          	jalr	-614(ra) # 800005aa <printf>
    return;
    80008818:	b7e5                	j	80008800 <tcp_sock_list_init+0x42>
    printf("ERROR: failed to allocate tcp_sock_list->socks\n");
    8000881a:	00003517          	auipc	a0,0x3
    8000881e:	2c650513          	addi	a0,a0,710 # 8000bae0 <etext+0xae0>
    80008822:	ffff8097          	auipc	ra,0xffff8
    80008826:	d88080e7          	jalr	-632(ra) # 800005aa <printf>
    kfree(tcp_sock_list);
    8000882a:	00007517          	auipc	a0,0x7
    8000882e:	5ae53503          	ld	a0,1454(a0) # 8000fdd8 <tcp_sock_list>
    80008832:	ffff8097          	auipc	ra,0xffff8
    80008836:	26a080e7          	jalr	618(ra) # 80000a9c <kfree>
    return;
    8000883a:	64a2                	ld	s1,8(sp)
    8000883c:	b7d1                	j	80008800 <tcp_sock_list_init+0x42>

000000008000883e <udp_sock_list_init>:

void udp_sock_list_init() {
    8000883e:	1101                	addi	sp,sp,-32
    80008840:	ec06                	sd	ra,24(sp)
    80008842:	e822                	sd	s0,16(sp)
    80008844:	1000                	addi	s0,sp,32
  udp_sock_list = (struct socket_list *)kalloc();
    80008846:	ffff8097          	auipc	ra,0xffff8
    8000884a:	3be080e7          	jalr	958(ra) # 80000c04 <kalloc>
    8000884e:	00007797          	auipc	a5,0x7
    80008852:	58a7b123          	sd	a0,1410(a5) # 8000fdd0 <udp_sock_list>
  if (!udp_sock_list) {
    80008856:	c90d                	beqz	a0,80008888 <udp_sock_list_init+0x4a>
    80008858:	e426                	sd	s1,8(sp)
    8000885a:	84aa                	mv	s1,a0
    printf("ERROR: failed to allocate udp_sock_list\n");
    return;
  }

  udp_sock_list->socks = (struct socket **)kalloc();
    8000885c:	ffff8097          	auipc	ra,0xffff8
    80008860:	3a8080e7          	jalr	936(ra) # 80000c04 <kalloc>
    80008864:	e088                	sd	a0,0(s1)
  if (!udp_sock_list->socks) {
    80008866:	00007797          	auipc	a5,0x7
    8000886a:	56a7b783          	ld	a5,1386(a5) # 8000fdd0 <udp_sock_list>
    8000886e:	6388                	ld	a0,0(a5)
    80008870:	c50d                	beqz	a0,8000889a <udp_sock_list_init+0x5c>
    printf("ERROR: failed to allocate udp_sock_list->socks\n");
    kfree(udp_sock_list);
    return;
  }
  memset(udp_sock_list->socks, 0, PGSIZE);
    80008872:	6605                	lui	a2,0x1
    80008874:	4581                	li	a1,0
    80008876:	ffff8097          	auipc	ra,0xffff8
    8000887a:	598080e7          	jalr	1432(ra) # 80000e0e <memset>
    8000887e:	64a2                	ld	s1,8(sp)
}
    80008880:	60e2                	ld	ra,24(sp)
    80008882:	6442                	ld	s0,16(sp)
    80008884:	6105                	addi	sp,sp,32
    80008886:	8082                	ret
    printf("ERROR: failed to allocate udp_sock_list\n");
    80008888:	00003517          	auipc	a0,0x3
    8000888c:	28850513          	addi	a0,a0,648 # 8000bb10 <etext+0xb10>
    80008890:	ffff8097          	auipc	ra,0xffff8
    80008894:	d1a080e7          	jalr	-742(ra) # 800005aa <printf>
    return;
    80008898:	b7e5                	j	80008880 <udp_sock_list_init+0x42>
    printf("ERROR: failed to allocate udp_sock_list->socks\n");
    8000889a:	00003517          	auipc	a0,0x3
    8000889e:	2a650513          	addi	a0,a0,678 # 8000bb40 <etext+0xb40>
    800088a2:	ffff8097          	auipc	ra,0xffff8
    800088a6:	d08080e7          	jalr	-760(ra) # 800005aa <printf>
    kfree(udp_sock_list);
    800088aa:	00007517          	auipc	a0,0x7
    800088ae:	52653503          	ld	a0,1318(a0) # 8000fdd0 <udp_sock_list>
    800088b2:	ffff8097          	auipc	ra,0xffff8
    800088b6:	1ea080e7          	jalr	490(ra) # 80000a9c <kfree>
    return;
    800088ba:	64a2                	ld	s1,8(sp)
    800088bc:	b7d1                	j	80008880 <udp_sock_list_init+0x42>

00000000800088be <socket_init>:

void socket_init() {
    800088be:	1141                	addi	sp,sp,-16
    800088c0:	e406                	sd	ra,8(sp)
    800088c2:	e022                	sd	s0,0(sp)
    800088c4:	0800                	addi	s0,sp,16
  sock_list_init();
    800088c6:	00000097          	auipc	ra,0x0
    800088ca:	e78080e7          	jalr	-392(ra) # 8000873e <sock_list_init>
  tcp_sock_list_init();
    800088ce:	00000097          	auipc	ra,0x0
    800088d2:	ef0080e7          	jalr	-272(ra) # 800087be <tcp_sock_list_init>
  udp_sock_list_init();
    800088d6:	00000097          	auipc	ra,0x0
    800088da:	f68080e7          	jalr	-152(ra) # 8000883e <udp_sock_list_init>
}
    800088de:	60a2                	ld	ra,8(sp)
    800088e0:	6402                	ld	s0,0(sp)
    800088e2:	0141                	addi	sp,sp,16
    800088e4:	8082                	ret

00000000800088e6 <print_eth_frame>:
#include "net.h"
#include "eth.h"

void 
print_eth_frame(struct eth_frame *frame)
{
    800088e6:	7139                	addi	sp,sp,-64
    800088e8:	fc06                	sd	ra,56(sp)
    800088ea:	f822                	sd	s0,48(sp)
    800088ec:	f426                	sd	s1,40(sp)
    800088ee:	f04a                	sd	s2,32(sp)
    800088f0:	ec4e                	sd	s3,24(sp)
    800088f2:	e852                	sd	s4,16(sp)
    800088f4:	e456                	sd	s5,8(sp)
    800088f6:	0080                	addi	s0,sp,64
    800088f8:	892a                	mv	s2,a0
  printf("\n");
    800088fa:	00002517          	auipc	a0,0x2
    800088fe:	72650513          	addi	a0,a0,1830 # 8000b020 <etext+0x20>
    80008902:	ffff8097          	auipc	ra,0xffff8
    80008906:	ca8080e7          	jalr	-856(ra) # 800005aa <printf>
  printf("dst_addr: %x:%x:%x:%x:%x:%x\n", frame->hdr.dst_addr[0],
    8000890a:	00594803          	lbu	a6,5(s2)
    8000890e:	00494783          	lbu	a5,4(s2)
    80008912:	00394703          	lbu	a4,3(s2)
    80008916:	00294683          	lbu	a3,2(s2)
    8000891a:	00194603          	lbu	a2,1(s2)
    8000891e:	00094583          	lbu	a1,0(s2)
    80008922:	00003517          	auipc	a0,0x3
    80008926:	24e50513          	addi	a0,a0,590 # 8000bb70 <etext+0xb70>
    8000892a:	ffff8097          	auipc	ra,0xffff8
    8000892e:	c80080e7          	jalr	-896(ra) # 800005aa <printf>
                                          frame->hdr.dst_addr[1],
                                          frame->hdr.dst_addr[2],
                                          frame->hdr.dst_addr[3],
                                          frame->hdr.dst_addr[4],
                                          frame->hdr.dst_addr[5]);
  printf("src_addr: %x:%x:%x:%x:%x:%x\n", frame->hdr.src_addr[0],
    80008932:	00b94803          	lbu	a6,11(s2)
    80008936:	00a94783          	lbu	a5,10(s2)
    8000893a:	00994703          	lbu	a4,9(s2)
    8000893e:	00894683          	lbu	a3,8(s2)
    80008942:	00794603          	lbu	a2,7(s2)
    80008946:	00694583          	lbu	a1,6(s2)
    8000894a:	00003517          	auipc	a0,0x3
    8000894e:	24650513          	addi	a0,a0,582 # 8000bb90 <etext+0xb90>
    80008952:	ffff8097          	auipc	ra,0xffff8
    80008956:	c58080e7          	jalr	-936(ra) # 800005aa <printf>
                                          frame->hdr.src_addr[2],
                                          frame->hdr.src_addr[3],
                                          frame->hdr.src_addr[4],
                                          frame->hdr.src_addr[5]);

  switch(ntohs(frame->hdr.type)) {
    8000895a:	00c94683          	lbu	a3,12(s2)
    8000895e:	00d94783          	lbu	a5,13(s2)
    80008962:	07a2                	slli	a5,a5,0x8
    80008964:	00d7e733          	or	a4,a5,a3
    80008968:	60800693          	li	a3,1544
    8000896c:	06d70563          	beq	a4,a3,800089d6 <print_eth_frame+0xf0>
    80008970:	0007069b          	sext.w	a3,a4
    80008974:	67b9                	lui	a5,0xe
    80008976:	d0878793          	addi	a5,a5,-760 # dd08 <_entry-0x7fff22f8>
    8000897a:	06f68763          	beq	a3,a5,800089e8 <print_eth_frame+0x102>
    8000897e:	47a1                	li	a5,8
    80008980:	00f69a63          	bne	a3,a5,80008994 <print_eth_frame+0xae>
    case(0x0800):
      printf("type: IPv4\n");
    80008984:	00003517          	auipc	a0,0x3
    80008988:	22c50513          	addi	a0,a0,556 # 8000bbb0 <etext+0xbb0>
    8000898c:	ffff8097          	auipc	ra,0xffff8
    80008990:	c1e080e7          	jalr	-994(ra) # 800005aa <printf>
      break;
  }

  // printf("payload_len: %d\n", frame->payload_len);
  // printf("payload :\n\t");
  for (int i = 0; i < frame->payload_len; i++) {
    80008994:	5ea94783          	lbu	a5,1514(s2)
    80008998:	4481                	li	s1,0
    printf("%x", frame->payload[i]);
    8000899a:	00003997          	auipc	s3,0x3
    8000899e:	24698993          	addi	s3,s3,582 # 8000bbe0 <etext+0xbe0>
    if (i > 0 && i % 40 == 0)
    800089a2:	66666a37          	lui	s4,0x66666
    800089a6:	667a0a13          	addi	s4,s4,1639 # 66666667 <_entry-0x19999999>
      printf("\n\t");
    800089aa:	00003a97          	auipc	s5,0x3
    800089ae:	23ea8a93          	addi	s5,s5,574 # 8000bbe8 <etext+0xbe8>
  for (int i = 0; i < frame->payload_len; i++) {
    800089b2:	ebb9                	bnez	a5,80008a08 <print_eth_frame+0x122>
  }
  printf("\n");
    800089b4:	00002517          	auipc	a0,0x2
    800089b8:	66c50513          	addi	a0,a0,1644 # 8000b020 <etext+0x20>
    800089bc:	ffff8097          	auipc	ra,0xffff8
    800089c0:	bee080e7          	jalr	-1042(ra) # 800005aa <printf>
}
    800089c4:	70e2                	ld	ra,56(sp)
    800089c6:	7442                	ld	s0,48(sp)
    800089c8:	74a2                	ld	s1,40(sp)
    800089ca:	7902                	ld	s2,32(sp)
    800089cc:	69e2                	ld	s3,24(sp)
    800089ce:	6a42                	ld	s4,16(sp)
    800089d0:	6aa2                	ld	s5,8(sp)
    800089d2:	6121                	addi	sp,sp,64
    800089d4:	8082                	ret
      printf("type: ARP\n");
    800089d6:	00003517          	auipc	a0,0x3
    800089da:	1ea50513          	addi	a0,a0,490 # 8000bbc0 <etext+0xbc0>
    800089de:	ffff8097          	auipc	ra,0xffff8
    800089e2:	bcc080e7          	jalr	-1076(ra) # 800005aa <printf>
      break;
    800089e6:	b77d                	j	80008994 <print_eth_frame+0xae>
      printf("type: IPv6\n");
    800089e8:	00003517          	auipc	a0,0x3
    800089ec:	1e850513          	addi	a0,a0,488 # 8000bbd0 <etext+0xbd0>
    800089f0:	ffff8097          	auipc	ra,0xffff8
    800089f4:	bba080e7          	jalr	-1094(ra) # 800005aa <printf>
      break;
    800089f8:	bf71                	j	80008994 <print_eth_frame+0xae>
  for (int i = 0; i < frame->payload_len; i++) {
    800089fa:	0485                	addi	s1,s1,1
    800089fc:	5ea94703          	lbu	a4,1514(s2)
    80008a00:	0004879b          	sext.w	a5,s1
    80008a04:	fae7d8e3          	bge	a5,a4,800089b4 <print_eth_frame+0xce>
    printf("%x", frame->payload[i]);
    80008a08:	009907b3          	add	a5,s2,s1
    80008a0c:	00e7c583          	lbu	a1,14(a5)
    80008a10:	854e                	mv	a0,s3
    80008a12:	ffff8097          	auipc	ra,0xffff8
    80008a16:	b98080e7          	jalr	-1128(ra) # 800005aa <printf>
    if (i > 0 && i % 40 == 0)
    80008a1a:	0004879b          	sext.w	a5,s1
    80008a1e:	fcf05ee3          	blez	a5,800089fa <print_eth_frame+0x114>
    80008a22:	034787b3          	mul	a5,a5,s4
    80008a26:	9791                	srai	a5,a5,0x24
    80008a28:	41f4d71b          	sraiw	a4,s1,0x1f
    80008a2c:	9f99                	subw	a5,a5,a4
    80008a2e:	0027971b          	slliw	a4,a5,0x2
    80008a32:	9fb9                	addw	a5,a5,a4
    80008a34:	0037979b          	slliw	a5,a5,0x3
    80008a38:	40f487bb          	subw	a5,s1,a5
    80008a3c:	ffdd                	bnez	a5,800089fa <print_eth_frame+0x114>
      printf("\n\t");
    80008a3e:	8556                	mv	a0,s5
    80008a40:	ffff8097          	auipc	ra,0xffff8
    80008a44:	b6a080e7          	jalr	-1174(ra) # 800005aa <printf>
    80008a48:	bf4d                	j	800089fa <print_eth_frame+0x114>

0000000080008a4a <parse_eth_packet>:

int
parse_eth_packet(uint8 *buf, int len, struct eth_frame *eth_frame)
{
    80008a4a:	7179                	addi	sp,sp,-48
    80008a4c:	f406                	sd	ra,40(sp)
    80008a4e:	f022                	sd	s0,32(sp)
    80008a50:	ec26                	sd	s1,24(sp)
    80008a52:	e84a                	sd	s2,16(sp)
    80008a54:	e44e                	sd	s3,8(sp)
    80008a56:	1800                	addi	s0,sp,48
    80008a58:	89aa                	mv	s3,a0
    80008a5a:	8932                	mv	s2,a2
  uint16 payload_len = len - sizeof(struct eth_hdr);
    80008a5c:	ff25849b          	addiw	s1,a1,-14
    80008a60:	14c2                	slli	s1,s1,0x30
    80008a62:	90c1                	srli	s1,s1,0x30
  memmove(&eth_frame->hdr, buf, sizeof(struct eth_hdr));
    80008a64:	4639                	li	a2,14
    80008a66:	85aa                	mv	a1,a0
    80008a68:	854a                	mv	a0,s2
    80008a6a:	ffff8097          	auipc	ra,0xffff8
    80008a6e:	408080e7          	jalr	1032(ra) # 80000e72 <memmove>
  memmove(eth_frame->payload, buf + sizeof(struct eth_hdr), payload_len);
    80008a72:	8626                	mv	a2,s1
    80008a74:	00e98593          	addi	a1,s3,14
    80008a78:	00e90513          	addi	a0,s2,14
    80008a7c:	ffff8097          	auipc	ra,0xffff8
    80008a80:	3f6080e7          	jalr	1014(ra) # 80000e72 <memmove>
  eth_frame->payload_len = payload_len;
    80008a84:	5e990523          	sb	s1,1514(s2)
  return 0;
}
    80008a88:	4501                	li	a0,0
    80008a8a:	70a2                	ld	ra,40(sp)
    80008a8c:	7402                	ld	s0,32(sp)
    80008a8e:	64e2                	ld	s1,24(sp)
    80008a90:	6942                	ld	s2,16(sp)
    80008a92:	69a2                	ld	s3,8(sp)
    80008a94:	6145                	addi	sp,sp,48
    80008a96:	8082                	ret

0000000080008a98 <build_eth>:

void build_eth(struct eth_frame *eth, uint8 *dst, uint8 *src, uint16 type) {
    80008a98:	7179                	addi	sp,sp,-48
    80008a9a:	f406                	sd	ra,40(sp)
    80008a9c:	f022                	sd	s0,32(sp)
    80008a9e:	ec26                	sd	s1,24(sp)
    80008aa0:	e84a                	sd	s2,16(sp)
    80008aa2:	e44e                	sd	s3,8(sp)
    80008aa4:	1800                	addi	s0,sp,48
    80008aa6:	84aa                	mv	s1,a0
    80008aa8:	89b2                	mv	s3,a2
    80008aaa:	8936                	mv	s2,a3
  memmove(eth->hdr.dst_addr, dst, 6);
    80008aac:	4619                	li	a2,6
    80008aae:	ffff8097          	auipc	ra,0xffff8
    80008ab2:	3c4080e7          	jalr	964(ra) # 80000e72 <memmove>
  memmove(eth->hdr.src_addr, src, 6);
    80008ab6:	4619                	li	a2,6
    80008ab8:	85ce                	mv	a1,s3
    80008aba:	00c48533          	add	a0,s1,a2
    80008abe:	ffff8097          	auipc	ra,0xffff8
    80008ac2:	3b4080e7          	jalr	948(ra) # 80000e72 <memmove>
  return (hostshort >> 8) | (hostshort << 8);
    80008ac6:	0089579b          	srliw	a5,s2,0x8
  eth->hdr.type = htons(type);
    80008aca:	00f48623          	sb	a5,12(s1)
    80008ace:	012486a3          	sb	s2,13(s1)
}
    80008ad2:	70a2                	ld	ra,40(sp)
    80008ad4:	7402                	ld	s0,32(sp)
    80008ad6:	64e2                	ld	s1,24(sp)
    80008ad8:	6942                	ld	s2,16(sp)
    80008ada:	69a2                	ld	s3,8(sp)
    80008adc:	6145                	addi	sp,sp,48
    80008ade:	8082                	ret

0000000080008ae0 <tcp_bind>:
#include "net_utils.h"
#include "net.h"
#include "ip4.h"

int 
tcp_bind(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen) {
    80008ae0:	7139                	addi	sp,sp,-64
    80008ae2:	fc06                	sd	ra,56(sp)
    80008ae4:	f822                	sd	s0,48(sp)
    80008ae6:	e05a                	sd	s6,0(sp)
    80008ae8:	0080                	addi	s0,sp,64
  if (socket < 0) {
    printf("bind: socket == 0\n");
    return -1;
  } else if (addr == 0) {
    80008aea:	c5f9                	beqz	a1,80008bb8 <tcp_bind+0xd8>
    80008aec:	f426                	sd	s1,40(sp)
    80008aee:	f04a                	sd	s2,32(sp)
    80008af0:	ec4e                	sd	s3,24(sp)
    80008af2:	84aa                	mv	s1,a0
    80008af4:	892e                	mv	s2,a1
    printf("bind: addr == 0\n");
    return -1;
  }

  const struct sockaddr_in *sockaddr = (struct sockaddr_in *)addr;
  uint16 port = ntohs(sockaddr->sin_port);
    80008af6:	0025d583          	lhu	a1,2(a1)
  return (netshort >> 8) | (netshort << 8);
    80008afa:	0085d99b          	srliw	s3,a1,0x8
    80008afe:	0085979b          	slliw	a5,a1,0x8
    80008b02:	00f9e9b3          	or	s3,s3,a5
    80008b06:	19c2                	slli	s3,s3,0x30
    80008b08:	0309d993          	srli	s3,s3,0x30

  if(sockaddr->sin_port < 0 || sockaddr->sin_port > MAX_PORT_BINDINGS) {
    80008b0c:	0005871b          	sext.w	a4,a1
    80008b10:	20000793          	li	a5,512
    80008b14:	0ae7ec63          	bltu	a5,a4,80008bcc <tcp_bind+0xec>
    80008b18:	e456                	sd	s5,8(sp)
    printf("bind: port number %d not valid within range\n", sockaddr->sin_port);
    return -1;
  } else if (tcp_port_binds[port]) {
    80008b1a:	00098a9b          	sext.w	s5,s3
    80008b1e:	00399713          	slli	a4,s3,0x3
    80008b22:	00069797          	auipc	a5,0x69
    80008b26:	cd678793          	addi	a5,a5,-810 # 800717f8 <tcp_port_binds>
    80008b2a:	97ba                	add	a5,a5,a4
    80008b2c:	639c                	ld	a5,0(a5)
    80008b2e:	efc5                	bnez	a5,80008be6 <tcp_bind+0x106>
    printf("bind: port number already bound\n");
    return -1;
  }

  sock->family = addr->sa_family;
    80008b30:	00095783          	lhu	a5,0(s2)
    80008b34:	00078b1b          	sext.w	s6,a5
    80008b38:	dd1c                	sw	a5,56(a0)

  switch(sock->family) {
    80008b3a:	140b1c63          	bnez	s6,80008c92 <tcp_bind+0x1b2>
    case(AF_INET):
      if (addrlen != sizeof(struct sockaddr_in)) {
    80008b3e:	47c1                	li	a5,16
    80008b40:	0cf61163          	bne	a2,a5,80008c02 <tcp_bind+0x122>
        printf("bind: incorrect addrlen for ipv4\n");
        return -1;
      }

      if (tcp_port_binds[port]) {
    80008b44:	003a9713          	slli	a4,s5,0x3
    80008b48:	00069797          	auipc	a5,0x69
    80008b4c:	cb078793          	addi	a5,a5,-848 # 800717f8 <tcp_port_binds>
    80008b50:	97ba                	add	a5,a5,a4
    80008b52:	639c                	ld	a5,0(a5)
    80008b54:	e7e9                	bnez	a5,80008c1e <tcp_bind+0x13e>
    80008b56:	e852                	sd	s4,16(sp)
        printf("bind: port %d in use\n", port);
        return -1;
      }

      struct port_binding *binding = (struct port_binding*) kalloc();
    80008b58:	ffff8097          	auipc	ra,0xffff8
    80008b5c:	0ac080e7          	jalr	172(ra) # 80000c04 <kalloc>
    80008b60:	8a2a                	mv	s4,a0
      if (binding == 0) {
    80008b62:	cd69                	beqz	a0,80008c3c <tcp_bind+0x15c>
        printf("ERROR: kalloc\n");
        return -1;
      }
      binding->port = port;
    80008b64:	01351123          	sh	s3,2(a0)
      if (sockaddr->sin_addr.s_addr == INADDR_ANY) {
    80008b68:	00492783          	lw	a5,4(s2)
    80008b6c:	4705                	li	a4,1
    80008b6e:	0ee78663          	beq	a5,a4,80008c5a <tcp_bind+0x17a>
        sock->src_ip = netconf.ip_addr;
        binding->ip_addr = netconf.ip_addr;
      } else {
        binding->ip_addr = sockaddr->sin_addr.s_addr;
    80008b72:	00f51023          	sh	a5,0(a0)
        sock->src_ip = sockaddr->sin_addr.s_addr;
    80008b76:	00492783          	lw	a5,4(s2)
    80008b7a:	d09c                	sw	a5,32(s1)
      }

      binding->sock = sock;
    80008b7c:	009a3423          	sd	s1,8(s4)

      if (insert_port_binding(binding) == -1){
    80008b80:	8552                	mv	a0,s4
    80008b82:	fffff097          	auipc	ra,0xfffff
    80008b86:	5ee080e7          	jalr	1518(ra) # 80008170 <insert_port_binding>
    80008b8a:	89aa                	mv	s3,a0
    80008b8c:	57fd                	li	a5,-1
    80008b8e:	0cf50e63          	beq	a0,a5,80008c6a <tcp_bind+0x18a>
        printf("bind: failed to bind to port\n");
        kfree(binding);
        return -1;
      }

      sock->src_port = port;
    80008b92:	0354a423          	sw	s5,40(s1)
      sock->family = sockaddr->sin_family;
    80008b96:	00095783          	lhu	a5,0(s2)
    80008b9a:	dc9c                	sw	a5,56(s1)
      sock->state = BOUND;
    80008b9c:	03300793          	li	a5,51
    80008ba0:	dcdc                	sw	a5,60(s1)
      break;
    default:
      return -1;
  }

  return 0;
    80008ba2:	74a2                	ld	s1,40(sp)
    80008ba4:	7902                	ld	s2,32(sp)
    80008ba6:	69e2                	ld	s3,24(sp)
    80008ba8:	6a42                	ld	s4,16(sp)
    80008baa:	6aa2                	ld	s5,8(sp)
}
    80008bac:	855a                	mv	a0,s6
    80008bae:	70e2                	ld	ra,56(sp)
    80008bb0:	7442                	ld	s0,48(sp)
    80008bb2:	6b02                	ld	s6,0(sp)
    80008bb4:	6121                	addi	sp,sp,64
    80008bb6:	8082                	ret
    printf("bind: addr == 0\n");
    80008bb8:	00003517          	auipc	a0,0x3
    80008bbc:	03850513          	addi	a0,a0,56 # 8000bbf0 <etext+0xbf0>
    80008bc0:	ffff8097          	auipc	ra,0xffff8
    80008bc4:	9ea080e7          	jalr	-1558(ra) # 800005aa <printf>
    return -1;
    80008bc8:	5b7d                	li	s6,-1
    80008bca:	b7cd                	j	80008bac <tcp_bind+0xcc>
    printf("bind: port number %d not valid within range\n", sockaddr->sin_port);
    80008bcc:	00003517          	auipc	a0,0x3
    80008bd0:	03c50513          	addi	a0,a0,60 # 8000bc08 <etext+0xc08>
    80008bd4:	ffff8097          	auipc	ra,0xffff8
    80008bd8:	9d6080e7          	jalr	-1578(ra) # 800005aa <printf>
    return -1;
    80008bdc:	5b7d                	li	s6,-1
    80008bde:	74a2                	ld	s1,40(sp)
    80008be0:	7902                	ld	s2,32(sp)
    80008be2:	69e2                	ld	s3,24(sp)
    80008be4:	b7e1                	j	80008bac <tcp_bind+0xcc>
    printf("bind: port number already bound\n");
    80008be6:	00003517          	auipc	a0,0x3
    80008bea:	05250513          	addi	a0,a0,82 # 8000bc38 <etext+0xc38>
    80008bee:	ffff8097          	auipc	ra,0xffff8
    80008bf2:	9bc080e7          	jalr	-1604(ra) # 800005aa <printf>
    return -1;
    80008bf6:	5b7d                	li	s6,-1
    80008bf8:	74a2                	ld	s1,40(sp)
    80008bfa:	7902                	ld	s2,32(sp)
    80008bfc:	69e2                	ld	s3,24(sp)
    80008bfe:	6aa2                	ld	s5,8(sp)
    80008c00:	b775                	j	80008bac <tcp_bind+0xcc>
        printf("bind: incorrect addrlen for ipv4\n");
    80008c02:	00003517          	auipc	a0,0x3
    80008c06:	05e50513          	addi	a0,a0,94 # 8000bc60 <etext+0xc60>
    80008c0a:	ffff8097          	auipc	ra,0xffff8
    80008c0e:	9a0080e7          	jalr	-1632(ra) # 800005aa <printf>
        return -1;
    80008c12:	5b7d                	li	s6,-1
    80008c14:	74a2                	ld	s1,40(sp)
    80008c16:	7902                	ld	s2,32(sp)
    80008c18:	69e2                	ld	s3,24(sp)
    80008c1a:	6aa2                	ld	s5,8(sp)
    80008c1c:	bf41                	j	80008bac <tcp_bind+0xcc>
        printf("bind: port %d in use\n", port);
    80008c1e:	85d6                	mv	a1,s5
    80008c20:	00003517          	auipc	a0,0x3
    80008c24:	06850513          	addi	a0,a0,104 # 8000bc88 <etext+0xc88>
    80008c28:	ffff8097          	auipc	ra,0xffff8
    80008c2c:	982080e7          	jalr	-1662(ra) # 800005aa <printf>
        return -1;
    80008c30:	5b7d                	li	s6,-1
    80008c32:	74a2                	ld	s1,40(sp)
    80008c34:	7902                	ld	s2,32(sp)
    80008c36:	69e2                	ld	s3,24(sp)
    80008c38:	6aa2                	ld	s5,8(sp)
    80008c3a:	bf8d                	j	80008bac <tcp_bind+0xcc>
        printf("ERROR: kalloc\n");
    80008c3c:	00003517          	auipc	a0,0x3
    80008c40:	83c50513          	addi	a0,a0,-1988 # 8000b478 <etext+0x478>
    80008c44:	ffff8097          	auipc	ra,0xffff8
    80008c48:	966080e7          	jalr	-1690(ra) # 800005aa <printf>
        return -1;
    80008c4c:	5b7d                	li	s6,-1
    80008c4e:	74a2                	ld	s1,40(sp)
    80008c50:	7902                	ld	s2,32(sp)
    80008c52:	69e2                	ld	s3,24(sp)
    80008c54:	6a42                	ld	s4,16(sp)
    80008c56:	6aa2                	ld	s5,8(sp)
    80008c58:	bf91                	j	80008bac <tcp_bind+0xcc>
        sock->src_ip = netconf.ip_addr;
    80008c5a:	00007797          	auipc	a5,0x7
    80008c5e:	0ae7a783          	lw	a5,174(a5) # 8000fd08 <netconf>
    80008c62:	d09c                	sw	a5,32(s1)
        binding->ip_addr = netconf.ip_addr;
    80008c64:	00f51023          	sh	a5,0(a0)
    80008c68:	bf11                	j	80008b7c <tcp_bind+0x9c>
        printf("bind: failed to bind to port\n");
    80008c6a:	00003517          	auipc	a0,0x3
    80008c6e:	03650513          	addi	a0,a0,54 # 8000bca0 <etext+0xca0>
    80008c72:	ffff8097          	auipc	ra,0xffff8
    80008c76:	938080e7          	jalr	-1736(ra) # 800005aa <printf>
        kfree(binding);
    80008c7a:	8552                	mv	a0,s4
    80008c7c:	ffff8097          	auipc	ra,0xffff8
    80008c80:	e20080e7          	jalr	-480(ra) # 80000a9c <kfree>
        return -1;
    80008c84:	8b4e                	mv	s6,s3
    80008c86:	74a2                	ld	s1,40(sp)
    80008c88:	7902                	ld	s2,32(sp)
    80008c8a:	69e2                	ld	s3,24(sp)
    80008c8c:	6a42                	ld	s4,16(sp)
    80008c8e:	6aa2                	ld	s5,8(sp)
    80008c90:	bf31                	j	80008bac <tcp_bind+0xcc>
      return -1;
    80008c92:	5b7d                	li	s6,-1
    80008c94:	74a2                	ld	s1,40(sp)
    80008c96:	7902                	ld	s2,32(sp)
    80008c98:	69e2                	ld	s3,24(sp)
    80008c9a:	6aa2                	ld	s5,8(sp)
    80008c9c:	bf01                	j	80008bac <tcp_bind+0xcc>

0000000080008c9e <tcp_connect>:

int 
tcp_connect(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen)
{
    80008c9e:	1141                	addi	sp,sp,-16
    80008ca0:	e406                	sd	ra,8(sp)
    80008ca2:	e022                	sd	s0,0(sp)
    80008ca4:	0800                	addi	s0,sp,16
  return 0;
}
    80008ca6:	4501                	li	a0,0
    80008ca8:	60a2                	ld	ra,8(sp)
    80008caa:	6402                	ld	s0,0(sp)
    80008cac:	0141                	addi	sp,sp,16
    80008cae:	8082                	ret

0000000080008cb0 <tcp_listen>:

int 
tcp_listen(struct socket *sock, int backlog)
{
    80008cb0:	1141                	addi	sp,sp,-16
    80008cb2:	e406                	sd	ra,8(sp)
    80008cb4:	e022                	sd	s0,0(sp)
    80008cb6:	0800                	addi	s0,sp,16
  if (sock->type != SOCK_STREAM)  {
    80008cb8:	5958                	lw	a4,52(a0)
    80008cba:	4785                	li	a5,1
    80008cbc:	00f71f63          	bne	a4,a5,80008cda <tcp_listen+0x2a>
    printf("listen: cannot listen from a UDP socket\n");
    return -1;
  } else if (!(sock->state == BOUND)) {
    80008cc0:	5d58                	lw	a4,60(a0)
    80008cc2:	03300793          	li	a5,51
    80008cc6:	02f71463          	bne	a4,a5,80008cee <tcp_listen+0x3e>
    printf("listen: socket is not bound\n");
    return -1;
  } 

  sock->state = LISTENING;
    80008cca:	03400793          	li	a5,52
    80008cce:	dd5c                	sw	a5,60(a0)
  return 0;
    80008cd0:	4501                	li	a0,0
}
    80008cd2:	60a2                	ld	ra,8(sp)
    80008cd4:	6402                	ld	s0,0(sp)
    80008cd6:	0141                	addi	sp,sp,16
    80008cd8:	8082                	ret
    printf("listen: cannot listen from a UDP socket\n");
    80008cda:	00003517          	auipc	a0,0x3
    80008cde:	fe650513          	addi	a0,a0,-26 # 8000bcc0 <etext+0xcc0>
    80008ce2:	ffff8097          	auipc	ra,0xffff8
    80008ce6:	8c8080e7          	jalr	-1848(ra) # 800005aa <printf>
    return -1;
    80008cea:	557d                	li	a0,-1
    80008cec:	b7dd                	j	80008cd2 <tcp_listen+0x22>
    printf("listen: socket is not bound\n");
    80008cee:	00003517          	auipc	a0,0x3
    80008cf2:	00250513          	addi	a0,a0,2 # 8000bcf0 <etext+0xcf0>
    80008cf6:	ffff8097          	auipc	ra,0xffff8
    80008cfa:	8b4080e7          	jalr	-1868(ra) # 800005aa <printf>
    return -1;
    80008cfe:	557d                	li	a0,-1
    80008d00:	bfc9                	j	80008cd2 <tcp_listen+0x22>

0000000080008d02 <tcp_accept>:

int 
tcp_accept(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen)
{
    80008d02:	1141                	addi	sp,sp,-16
    80008d04:	e406                	sd	ra,8(sp)
    80008d06:	e022                	sd	s0,0(sp)
    80008d08:	0800                	addi	s0,sp,16
  return 0;
}
    80008d0a:	4501                	li	a0,0
    80008d0c:	60a2                	ld	ra,8(sp)
    80008d0e:	6402                	ld	s0,0(sp)
    80008d10:	0141                	addi	sp,sp,16
    80008d12:	8082                	ret

0000000080008d14 <tcp_close>:

int
tcp_close(struct socket *sock)
{
    80008d14:	1141                	addi	sp,sp,-16
    80008d16:	e406                	sd	ra,8(sp)
    80008d18:	e022                	sd	s0,0(sp)
    80008d1a:	0800                	addi	s0,sp,16
  return 0;
}
    80008d1c:	4501                	li	a0,0
    80008d1e:	60a2                	ld	ra,8(sp)
    80008d20:	6402                	ld	s0,0(sp)
    80008d22:	0141                	addi	sp,sp,16
    80008d24:	8082                	ret

0000000080008d26 <build_tcp>:

void 
build_tcp(struct tcp_frame *tcp, uint16 src_port, uint16 dst_port, uint32 seq_num,
          uint32 ack_num, uint8 flags, uint16 window, uint8 *payload, int payload_len,
          uint32 src_ip, uint32 dst_ip)
{
    80008d26:	1101                	addi	sp,sp,-32
    80008d28:	ec06                	sd	ra,24(sp)
    80008d2a:	e822                	sd	s0,16(sp)
    80008d2c:	e426                	sd	s1,8(sp)
    80008d2e:	e04a                	sd	s2,0(sp)
    80008d30:	1000                	addi	s0,sp,32
    80008d32:	84aa                	mv	s1,a0
    80008d34:	852e                	mv	a0,a1
    80008d36:	85c6                	mv	a1,a7
    80008d38:	00042903          	lw	s2,0(s0)
  return (hostshort >> 8) | (hostshort << 8);
    80008d3c:	0085589b          	srliw	a7,a0,0x8
  tcp->hdr.src_port = htons(src_port);
    80008d40:	01148023          	sb	a7,0(s1)
    80008d44:	00a480a3          	sb	a0,1(s1)
    80008d48:	0086551b          	srliw	a0,a2,0x8
  tcp->hdr.dst_port = htons(dst_port);
    80008d4c:	00a48123          	sb	a0,2(s1)
    80008d50:	00c481a3          	sb	a2,3(s1)
    return ((hostlong & 0x000000FFU) << 24) |
    80008d54:	0186961b          	slliw	a2,a3,0x18
           ((hostlong & 0xFF000000U) >> 24);
    80008d58:	0186d51b          	srliw	a0,a3,0x18
           ((hostlong & 0x00FF0000U) >> 8)  |
    80008d5c:	8e49                	or	a2,a2,a0
           ((hostlong & 0x0000FF00U) << 8)  |
    80008d5e:	0086951b          	slliw	a0,a3,0x8
    80008d62:	00ff08b7          	lui	a7,0xff0
    80008d66:	01157533          	and	a0,a0,a7
           ((hostlong & 0x00FF0000U) >> 8)  |
    80008d6a:	8e49                	or	a2,a2,a0
    80008d6c:	0086d69b          	srliw	a3,a3,0x8
    80008d70:	6541                	lui	a0,0x10
    80008d72:	f0050513          	addi	a0,a0,-256 # ff00 <_entry-0x7fff0100>
    80008d76:	8ee9                	and	a3,a3,a0
  tcp->hdr.seq_num = htonl(seq_num);
    80008d78:	00c48223          	sb	a2,4(s1)
    80008d7c:	82a1                	srli	a3,a3,0x8
    80008d7e:	00d482a3          	sb	a3,5(s1)
    80008d82:	0106569b          	srliw	a3,a2,0x10
    80008d86:	00d48323          	sb	a3,6(s1)
    80008d8a:	0186561b          	srliw	a2,a2,0x18
    80008d8e:	00c483a3          	sb	a2,7(s1)
    return ((hostlong & 0x000000FFU) << 24) |
    80008d92:	0187169b          	slliw	a3,a4,0x18
           ((hostlong & 0xFF000000U) >> 24);
    80008d96:	0187561b          	srliw	a2,a4,0x18
           ((hostlong & 0x00FF0000U) >> 8)  |
    80008d9a:	8ed1                	or	a3,a3,a2
           ((hostlong & 0x0000FF00U) << 8)  |
    80008d9c:	0087161b          	slliw	a2,a4,0x8
    80008da0:	01167633          	and	a2,a2,a7
           ((hostlong & 0x00FF0000U) >> 8)  |
    80008da4:	8ed1                	or	a3,a3,a2
    80008da6:	0087571b          	srliw	a4,a4,0x8
    80008daa:	8f69                	and	a4,a4,a0
  tcp->hdr.ack_num = htonl(ack_num);
    80008dac:	00d48423          	sb	a3,8(s1)
    80008db0:	8321                	srli	a4,a4,0x8
    80008db2:	00e484a3          	sb	a4,9(s1)
    80008db6:	0106d71b          	srliw	a4,a3,0x10
    80008dba:	00e48523          	sb	a4,10(s1)
    80008dbe:	0186d69b          	srliw	a3,a3,0x18
    80008dc2:	00d485a3          	sb	a3,11(s1)
  tcp->hdr.data_offset = (5 << 4);   // header len = 20 bytes
    80008dc6:	05000713          	li	a4,80
    80008dca:	00e48623          	sb	a4,12(s1)
  tcp->hdr.flags = flags;
    80008dce:	00f486a3          	sb	a5,13(s1)
  return (hostshort >> 8) | (hostshort << 8);
    80008dd2:	0088579b          	srliw	a5,a6,0x8
  tcp->hdr.window = htons(window);
    80008dd6:	00f48723          	sb	a5,14(s1)
    80008dda:	010487a3          	sb	a6,15(s1)
  tcp->hdr.csum = 0;
    80008dde:	00048823          	sb	zero,16(s1)
    80008de2:	000488a3          	sb	zero,17(s1)
  tcp->hdr.urgent_ptr = 0;
    80008de6:	00048923          	sb	zero,18(s1)
    80008dea:	000489a3          	sb	zero,19(s1)

  memmove(tcp->payload, payload, payload_len);
    80008dee:	864a                	mv	a2,s2
    80008df0:	01448513          	addi	a0,s1,20
    80008df4:	ffff8097          	auipc	ra,0xffff8
    80008df8:	07e080e7          	jalr	126(ra) # 80000e72 <memmove>
  tcp->payload_len = payload_len;
    80008dfc:	5f248823          	sb	s2,1520(s1)
    80008e00:	0089579b          	srliw	a5,s2,0x8
    80008e04:	5ef488a3          	sb	a5,1521(s1)
    80008e08:	0109579b          	srliw	a5,s2,0x10
    80008e0c:	5ef48923          	sb	a5,1522(s1)
    80008e10:	0189591b          	srliw	s2,s2,0x18
    80008e14:	5f2489a3          	sb	s2,1523(s1)

  // tcp->hdr->csum = tcp_checksum(tcp, src_ip, dst_ip);
}
    80008e18:	60e2                	ld	ra,24(sp)
    80008e1a:	6442                	ld	s0,16(sp)
    80008e1c:	64a2                	ld	s1,8(sp)
    80008e1e:	6902                	ld	s2,0(sp)
    80008e20:	6105                	addi	sp,sp,32
    80008e22:	8082                	ret

0000000080008e24 <parse_tcp_packet>:

int parse_tcp_packet(uint8 *buf, int len, struct tcp_frame *tcp_pkt) {
  if (len < 20) return -1; // minimum TCP header
    80008e24:	474d                	li	a4,19
    80008e26:	12b75963          	bge	a4,a1,80008f58 <parse_tcp_packet+0x134>
    80008e2a:	87b2                	mv	a5,a2
  return (netshort >> 8) | (netshort << 8);
    80008e2c:	00055703          	lhu	a4,0(a0)
    80008e30:	00875693          	srli	a3,a4,0x8

  tcp_pkt->hdr.src_port = ntohs(*(uint16*)(buf));
    80008e34:	00d60023          	sb	a3,0(a2) # 1000 <_entry-0x7ffff000>
    80008e38:	00e600a3          	sb	a4,1(a2)
    80008e3c:	00255703          	lhu	a4,2(a0)
    80008e40:	00875693          	srli	a3,a4,0x8
  tcp_pkt->hdr.dst_port = ntohs(*(uint16*)(buf+2));
    80008e44:	00d60123          	sb	a3,2(a2)
    80008e48:	00e601a3          	sb	a4,3(a2)
  tcp_pkt->hdr.seq_num  = ntohl(*(uint32*)(buf+4));
    80008e4c:	4158                	lw	a4,4(a0)
  return ((netlong & 0x000000FFU) << 24) |
    80008e4e:	0187169b          	slliw	a3,a4,0x18
    ((netlong & 0xFF000000U) >> 24);
    80008e52:	0187561b          	srliw	a2,a4,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80008e56:	8ed1                	or	a3,a3,a2
    ((netlong & 0x0000FF00U) << 8)  |
    80008e58:	0087161b          	slliw	a2,a4,0x8
    80008e5c:	00ff08b7          	lui	a7,0xff0
    80008e60:	01167633          	and	a2,a2,a7
    ((netlong & 0x00FF0000U) >> 8)  |
    80008e64:	8ed1                	or	a3,a3,a2
    80008e66:	0087571b          	srliw	a4,a4,0x8
    80008e6a:	6641                	lui	a2,0x10
    80008e6c:	f0060613          	addi	a2,a2,-256 # ff00 <_entry-0x7fff0100>
    80008e70:	8f71                	and	a4,a4,a2
    80008e72:	00d78223          	sb	a3,4(a5)
    80008e76:	8321                	srli	a4,a4,0x8
    80008e78:	00e782a3          	sb	a4,5(a5)
    80008e7c:	0106d71b          	srliw	a4,a3,0x10
    80008e80:	00e78323          	sb	a4,6(a5)
    80008e84:	0186d69b          	srliw	a3,a3,0x18
    80008e88:	00d783a3          	sb	a3,7(a5)
  tcp_pkt->hdr.ack_num  = ntohl(*(uint32*)(buf+8));
    80008e8c:	4518                	lw	a4,8(a0)
  return ((netlong & 0x000000FFU) << 24) |
    80008e8e:	0187169b          	slliw	a3,a4,0x18
    ((netlong & 0xFF000000U) >> 24);
    80008e92:	0187581b          	srliw	a6,a4,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80008e96:	0106e6b3          	or	a3,a3,a6
    ((netlong & 0x0000FF00U) << 8)  |
    80008e9a:	0087181b          	slliw	a6,a4,0x8
    80008e9e:	01187833          	and	a6,a6,a7
    ((netlong & 0x00FF0000U) >> 8)  |
    80008ea2:	0106e6b3          	or	a3,a3,a6
    80008ea6:	0087571b          	srliw	a4,a4,0x8
    80008eaa:	8f71                	and	a4,a4,a2
    80008eac:	00d78423          	sb	a3,8(a5)
    80008eb0:	8321                	srli	a4,a4,0x8
    80008eb2:	00e784a3          	sb	a4,9(a5)
    80008eb6:	0106d71b          	srliw	a4,a3,0x10
    80008eba:	00e78523          	sb	a4,10(a5)
    80008ebe:	0186d69b          	srliw	a3,a3,0x18
    80008ec2:	00d785a3          	sb	a3,11(a5)
  tcp_pkt->hdr.data_offset = (buf[12] >> 4) & 0xF;
    80008ec6:	00c54703          	lbu	a4,12(a0)
    80008eca:	8311                	srli	a4,a4,0x4
    80008ecc:	00e78623          	sb	a4,12(a5)
  tcp_pkt->hdr.flags = buf[13];
    80008ed0:	00d54683          	lbu	a3,13(a0)
    80008ed4:	00d786a3          	sb	a3,13(a5)
  return (netshort >> 8) | (netshort << 8);
    80008ed8:	00e55683          	lhu	a3,14(a0)
    80008edc:	0086d613          	srli	a2,a3,0x8
  tcp_pkt->hdr.window = ntohs(*(uint16*)(buf+14));
    80008ee0:	00c78723          	sb	a2,14(a5)
    80008ee4:	00d787a3          	sb	a3,15(a5)
    80008ee8:	01055683          	lhu	a3,16(a0)
    80008eec:	0086d613          	srli	a2,a3,0x8
  tcp_pkt->hdr.csum = ntohs(*(uint16*)(buf+16));
    80008ef0:	00c78823          	sb	a2,16(a5)
    80008ef4:	00d788a3          	sb	a3,17(a5)
    80008ef8:	01255683          	lhu	a3,18(a0)
    80008efc:	0086d613          	srli	a2,a3,0x8
  tcp_pkt->hdr.urgent_ptr = ntohs(*(uint16*)(buf+18));
    80008f00:	00c78923          	sb	a2,18(a5)
    80008f04:	00d789a3          	sb	a3,19(a5)

  int hdr_len = tcp_pkt->hdr.data_offset * 4;
    80008f08:	0027171b          	slliw	a4,a4,0x2
  if (hdr_len < 20 || hdr_len > len) return -1;
    80008f0c:	464d                	li	a2,19
    80008f0e:	04e65763          	bge	a2,a4,80008f5c <parse_tcp_packet+0x138>
    80008f12:	04e5c763          	blt	a1,a4,80008f60 <parse_tcp_packet+0x13c>
int parse_tcp_packet(uint8 *buf, int len, struct tcp_frame *tcp_pkt) {
    80008f16:	1141                	addi	sp,sp,-16
    80008f18:	e406                	sd	ra,8(sp)
    80008f1a:	e022                	sd	s0,0(sp)
    80008f1c:	0800                	addi	s0,sp,16

  tcp_pkt->payload_len = len - hdr_len;
    80008f1e:	40e5863b          	subw	a2,a1,a4
    80008f22:	5ec78823          	sb	a2,1520(a5)
    80008f26:	0086569b          	srliw	a3,a2,0x8
    80008f2a:	5ed788a3          	sb	a3,1521(a5)
    80008f2e:	0106569b          	srliw	a3,a2,0x10
    80008f32:	5ed78923          	sb	a3,1522(a5)
    80008f36:	0186569b          	srliw	a3,a2,0x18
    80008f3a:	5ed789a3          	sb	a3,1523(a5)
  memmove(tcp_pkt->payload, buf + hdr_len, tcp_pkt->payload_len);
    80008f3e:	00e505b3          	add	a1,a0,a4
    80008f42:	01478513          	addi	a0,a5,20
    80008f46:	ffff8097          	auipc	ra,0xffff8
    80008f4a:	f2c080e7          	jalr	-212(ra) # 80000e72 <memmove>

  return 0;
    80008f4e:	4501                	li	a0,0
}
    80008f50:	60a2                	ld	ra,8(sp)
    80008f52:	6402                	ld	s0,0(sp)
    80008f54:	0141                	addi	sp,sp,16
    80008f56:	8082                	ret
  if (len < 20) return -1; // minimum TCP header
    80008f58:	557d                	li	a0,-1
    80008f5a:	8082                	ret
  if (hdr_len < 20 || hdr_len > len) return -1;
    80008f5c:	557d                	li	a0,-1
    80008f5e:	8082                	ret
    80008f60:	557d                	li	a0,-1
}
    80008f62:	8082                	ret

0000000080008f64 <syn>:

int 
syn(uint16 src_port, uint32 dst_ip, uint16 dst_port, uint32 seq_num) 
{
    80008f64:	7119                	addi	sp,sp,-128
    80008f66:	fc86                	sd	ra,120(sp)
    80008f68:	f8a2                	sd	s0,112(sp)
    80008f6a:	ecce                	sd	s3,88(sp)
    80008f6c:	e8d2                	sd	s4,80(sp)
    80008f6e:	e4d6                	sd	s5,72(sp)
    80008f70:	e0da                	sd	s6,64(sp)
    80008f72:	0100                	addi	s0,sp,128
    80008f74:	8a2a                	mv	s4,a0
    80008f76:	89ae                	mv	s3,a1
    80008f78:	8ab2                	mv	s5,a2
    80008f7a:	8b36                	mv	s6,a3
  uint8 DEFAULT_MAC[6] = {0x63, 0xb0, 0xce, 0xf6, 0xeb, 0x50};
    80008f7c:	f6ceb7b7          	lui	a5,0xf6ceb
    80008f80:	06378793          	addi	a5,a5,99 # fffffffff6ceb063 <end+0xffffffff76c7776b>
    80008f84:	faf42423          	sw	a5,-88(s0)
    80008f88:	6795                	lui	a5,0x5
    80008f8a:	0eb78793          	addi	a5,a5,235 # 50eb <_entry-0x7fffaf15>
    80008f8e:	faf41623          	sh	a5,-84(s0)

  struct tcp_frame *syn_tcp = kalloc();
    80008f92:	ffff8097          	auipc	ra,0xffff8
    80008f96:	c72080e7          	jalr	-910(ra) # 80000c04 <kalloc>
  if (syn_tcp == 0) {
    80008f9a:	c16d                	beqz	a0,8000907c <syn+0x118>
    80008f9c:	f4a6                	sd	s1,104(sp)
    80008f9e:	f862                	sd	s8,48(sp)
    80008fa0:	8c2a                	mv	s8,a0
    printf("ERROR: kalloc");
    return -1;
  }
  struct ip4_frame *ip = kalloc();
    80008fa2:	ffff8097          	auipc	ra,0xffff8
    80008fa6:	c62080e7          	jalr	-926(ra) # 80000c04 <kalloc>
    80008faa:	84aa                	mv	s1,a0
  if (ip == 0) {
    80008fac:	c175                	beqz	a0,80009090 <syn+0x12c>
    80008fae:	fc5e                	sd	s7,56(sp)
    printf("ERROR: kalloc");
    return -1;
  }
  struct eth_frame *eth = kalloc();
    80008fb0:	ffff8097          	auipc	ra,0xffff8
    80008fb4:	c54080e7          	jalr	-940(ra) # 80000c04 <kalloc>
    80008fb8:	8baa                	mv	s7,a0
  if (eth == 0) {
    80008fba:	c57d                	beqz	a0,800090a8 <syn+0x144>
    80008fbc:	f0ca                	sd	s2,96(sp)
    printf("ERROR: kalloc");
    return -1;
  }

  build_tcp(syn_tcp, src_port, dst_port, DEFAULT_SEQ_NUM, seq_num + 1, SYN & ACK,
    80008fbe:	e84e                	sd	s3,16(sp)
    80008fc0:	00007917          	auipc	s2,0x7
    80008fc4:	d4890913          	addi	s2,s2,-696 # 8000fd08 <netconf>
    80008fc8:	00092783          	lw	a5,0(s2)
    80008fcc:	e43e                	sd	a5,8(sp)
    80008fce:	e002                	sd	zero,0(sp)
    80008fd0:	4881                	li	a7,0
    80008fd2:	40000813          	li	a6,1024
    80008fd6:	4781                	li	a5,0
    80008fd8:	001b071b          	addiw	a4,s6,1
    80008fdc:	53900693          	li	a3,1337
    80008fe0:	8656                	mv	a2,s5
    80008fe2:	85d2                	mv	a1,s4
    80008fe4:	8562                	mv	a0,s8
    80008fe6:	00000097          	auipc	ra,0x0
    80008fea:	d40080e7          	jalr	-704(ra) # 80008d26 <build_tcp>
            DEFAULT_WINDOW, 0, 0, netconf.ip_addr, dst_ip);
  build_ip4(ip, netconf.ip_addr, dst_ip, IPPROTO_TCP, sizeof(struct tcp_hdr));
    80008fee:	4751                	li	a4,20
    80008ff0:	4699                	li	a3,6
    80008ff2:	864e                	mv	a2,s3
    80008ff4:	00092583          	lw	a1,0(s2)
    80008ff8:	8526                	mv	a0,s1
    80008ffa:	fffff097          	auipc	ra,0xfffff
    80008ffe:	dfc080e7          	jalr	-516(ra) # 80007df6 <build_ip4>
  build_eth(eth, DEFAULT_MAC, netconf.mac_addr, PROTO_IPV4);
    80009002:	6685                	lui	a3,0x1
    80009004:	80068693          	addi	a3,a3,-2048 # 800 <_entry-0x7ffff800>
    80009008:	00007617          	auipc	a2,0x7
    8000900c:	d0460613          	addi	a2,a2,-764 # 8000fd0c <netconf+0x4>
    80009010:	fa840593          	addi	a1,s0,-88
    80009014:	855e                	mv	a0,s7
    80009016:	00000097          	auipc	ra,0x0
    8000901a:	a82080e7          	jalr	-1406(ra) # 80008a98 <build_eth>

  ip->payload_len = sizeof(struct tcp_hdr);
    8000901e:	47d1                	li	a5,20
    80009020:	5ef48823          	sb	a5,1520(s1)
    80009024:	5e0488a3          	sb	zero,1521(s1)
  memmove(ip->payload, syn_tcp, ip->payload_len);
    80009028:	863e                	mv	a2,a5
    8000902a:	85e2                	mv	a1,s8
    8000902c:	00f48533          	add	a0,s1,a5
    80009030:	ffff8097          	auipc	ra,0xffff8
    80009034:	e42080e7          	jalr	-446(ra) # 80000e72 <memmove>

  eth->payload_len = sizeof(struct ip4_hdr);
    80009038:	4651                	li	a2,20
    8000903a:	5ecb8523          	sb	a2,1514(s7) # 15ea <_entry-0x7fffea16>
  memmove(eth->payload, ip, eth->payload_len);
    8000903e:	85a6                	mv	a1,s1
    80009040:	00eb8513          	addi	a0,s7,14
    80009044:	ffff8097          	auipc	ra,0xffff8
    80009048:	e2e080e7          	jalr	-466(ra) # 80000e72 <memmove>

  transmit_packet((uint8 *)eth, eth->payload_len + sizeof(struct eth_hdr), PROTO_IPV4);
    8000904c:	5eabc583          	lbu	a1,1514(s7)
    80009050:	6605                	lui	a2,0x1
    80009052:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80009056:	05b9                	addi	a1,a1,14
    80009058:	855e                	mv	a0,s7
    8000905a:	ffffe097          	auipc	ra,0xffffe
    8000905e:	72e080e7          	jalr	1838(ra) # 80007788 <transmit_packet>
  
  return 0;
    80009062:	4501                	li	a0,0
    80009064:	74a6                	ld	s1,104(sp)
    80009066:	7906                	ld	s2,96(sp)
    80009068:	7be2                	ld	s7,56(sp)
    8000906a:	7c42                	ld	s8,48(sp)
}
    8000906c:	70e6                	ld	ra,120(sp)
    8000906e:	7446                	ld	s0,112(sp)
    80009070:	69e6                	ld	s3,88(sp)
    80009072:	6a46                	ld	s4,80(sp)
    80009074:	6aa6                	ld	s5,72(sp)
    80009076:	6b06                	ld	s6,64(sp)
    80009078:	6109                	addi	sp,sp,128
    8000907a:	8082                	ret
    printf("ERROR: kalloc");
    8000907c:	00003517          	auipc	a0,0x3
    80009080:	c9450513          	addi	a0,a0,-876 # 8000bd10 <etext+0xd10>
    80009084:	ffff7097          	auipc	ra,0xffff7
    80009088:	526080e7          	jalr	1318(ra) # 800005aa <printf>
    return -1;
    8000908c:	557d                	li	a0,-1
    8000908e:	bff9                	j	8000906c <syn+0x108>
    printf("ERROR: kalloc");
    80009090:	00003517          	auipc	a0,0x3
    80009094:	c8050513          	addi	a0,a0,-896 # 8000bd10 <etext+0xd10>
    80009098:	ffff7097          	auipc	ra,0xffff7
    8000909c:	512080e7          	jalr	1298(ra) # 800005aa <printf>
    return -1;
    800090a0:	557d                	li	a0,-1
    800090a2:	74a6                	ld	s1,104(sp)
    800090a4:	7c42                	ld	s8,48(sp)
    800090a6:	b7d9                	j	8000906c <syn+0x108>
    printf("ERROR: kalloc");
    800090a8:	00003517          	auipc	a0,0x3
    800090ac:	c6850513          	addi	a0,a0,-920 # 8000bd10 <etext+0xd10>
    800090b0:	ffff7097          	auipc	ra,0xffff7
    800090b4:	4fa080e7          	jalr	1274(ra) # 800005aa <printf>
    return -1;
    800090b8:	557d                	li	a0,-1
    800090ba:	74a6                	ld	s1,104(sp)
    800090bc:	7be2                	ld	s7,56(sp)
    800090be:	7c42                	ld	s8,48(sp)
    800090c0:	b775                	j	8000906c <syn+0x108>

00000000800090c2 <handle_tcp_packet>:

int 
handle_tcp_packet(struct tcp_frame *tcp_pkt) 
{
    800090c2:	1101                	addi	sp,sp,-32
    800090c4:	ec06                	sd	ra,24(sp)
    800090c6:	e822                	sd	s0,16(sp)
    800090c8:	e426                	sd	s1,8(sp)
    800090ca:	e04a                	sd	s2,0(sp)
    800090cc:	1000                	addi	s0,sp,32
    800090ce:	84aa                	mv	s1,a0
  printf("TCP packet: src_port=%d dst_port=%d seq=%d ack=%d\n",
    800090d0:	00854783          	lbu	a5,8(a0)
    800090d4:	00954703          	lbu	a4,9(a0)
    800090d8:	0722                	slli	a4,a4,0x8
    800090da:	8f5d                	or	a4,a4,a5
    800090dc:	00a54783          	lbu	a5,10(a0)
    800090e0:	07c2                	slli	a5,a5,0x10
    800090e2:	8fd9                	or	a5,a5,a4
    800090e4:	00b54703          	lbu	a4,11(a0)
    800090e8:	0762                	slli	a4,a4,0x18
    800090ea:	8f5d                	or	a4,a4,a5
    800090ec:	00454783          	lbu	a5,4(a0)
    800090f0:	00554683          	lbu	a3,5(a0)
    800090f4:	06a2                	slli	a3,a3,0x8
    800090f6:	8edd                	or	a3,a3,a5
    800090f8:	00654783          	lbu	a5,6(a0)
    800090fc:	07c2                	slli	a5,a5,0x10
    800090fe:	8fd5                	or	a5,a5,a3
    80009100:	00754683          	lbu	a3,7(a0)
    80009104:	06e2                	slli	a3,a3,0x18
    80009106:	8edd                	or	a3,a3,a5
      tcp_pkt->hdr.src_port, tcp_pkt->hdr.dst_port, tcp_pkt->hdr.seq_num, tcp_pkt->hdr.ack_num);
    80009108:	00254503          	lbu	a0,2(a0)
    8000910c:	0034c603          	lbu	a2,3(s1)
    80009110:	0622                	slli	a2,a2,0x8
    80009112:	0004c583          	lbu	a1,0(s1)
    80009116:	0014c783          	lbu	a5,1(s1)
    8000911a:	07a2                	slli	a5,a5,0x8
  printf("TCP packet: src_port=%d dst_port=%d seq=%d ack=%d\n",
    8000911c:	2701                	sext.w	a4,a4
    8000911e:	2681                	sext.w	a3,a3
    80009120:	8e49                	or	a2,a2,a0
    80009122:	8ddd                	or	a1,a1,a5
    80009124:	00003517          	auipc	a0,0x3
    80009128:	bfc50513          	addi	a0,a0,-1028 # 8000bd20 <etext+0xd20>
    8000912c:	ffff7097          	auipc	ra,0xffff7
    80009130:	47e080e7          	jalr	1150(ra) # 800005aa <printf>
  
  // verify the dest port is open
  struct port_binding *port_bind = tcp_port_binds[tcp_pkt->hdr.dst_port];
    80009134:	0024c703          	lbu	a4,2(s1)
    80009138:	0034c783          	lbu	a5,3(s1)
    8000913c:	07a2                	slli	a5,a5,0x8
    8000913e:	8fd9                	or	a5,a5,a4
    80009140:	078e                	slli	a5,a5,0x3
    80009142:	00068717          	auipc	a4,0x68
    80009146:	6b670713          	addi	a4,a4,1718 # 800717f8 <tcp_port_binds>
    8000914a:	97ba                	add	a5,a5,a4
    8000914c:	0007b903          	ld	s2,0(a5)
  if (port_bind == 0) {
    80009150:	0a090263          	beqz	s2,800091f4 <handle_tcp_packet+0x132>
    return -1;
  } else {
    printf("port_bind->port=%d port_bind.ip4_addr=%d port_bind->sock.state=%d",
    80009154:	00893783          	ld	a5,8(s2)
    80009158:	5fd4                	lw	a3,60(a5)
    8000915a:	00095603          	lhu	a2,0(s2)
    8000915e:	00295583          	lhu	a1,2(s2)
    80009162:	00003517          	auipc	a0,0x3
    80009166:	bf650513          	addi	a0,a0,-1034 # 8000bd58 <etext+0xd58>
    8000916a:	ffff7097          	auipc	ra,0xffff7
    8000916e:	440080e7          	jalr	1088(ra) # 800005aa <printf>
        port_bind->port, port_bind->ip_addr, port_bind->sock->state);
  }

  if (tcp_pkt->hdr.flags & SYN && tcp_pkt->hdr.flags & ACK) {
    80009172:	00d4c783          	lbu	a5,13(s1)
    80009176:	0487f693          	andi	a3,a5,72
    8000917a:	04800713          	li	a4,72
    8000917e:	00e68f63          	beq	a3,a4,8000919c <handle_tcp_packet+0xda>
    printf("SYN+ACK received!\n");

  } else if (tcp_pkt->hdr.flags & SYN) {
    80009182:	0087f713          	andi	a4,a5,8
    80009186:	e70d                	bnez	a4,800091b0 <handle_tcp_packet+0xee>
    // change the state of the socket
    port_bind->sock->state = SYN_RECVD;

    // syn(port_bind->ip4_addr, port_bind->port);
  
  } else if (tcp_pkt->hdr.flags & ACK) {
    80009188:	0407f793          	andi	a5,a5,64
    printf("ACK received!\n");
  }
  
  return 0;
    8000918c:	4501                	li	a0,0
  } else if (tcp_pkt->hdr.flags & ACK) {
    8000918e:	eba9                	bnez	a5,800091e0 <handle_tcp_packet+0x11e>
}
    80009190:	60e2                	ld	ra,24(sp)
    80009192:	6442                	ld	s0,16(sp)
    80009194:	64a2                	ld	s1,8(sp)
    80009196:	6902                	ld	s2,0(sp)
    80009198:	6105                	addi	sp,sp,32
    8000919a:	8082                	ret
    printf("SYN+ACK received!\n");
    8000919c:	00003517          	auipc	a0,0x3
    800091a0:	c0450513          	addi	a0,a0,-1020 # 8000bda0 <etext+0xda0>
    800091a4:	ffff7097          	auipc	ra,0xffff7
    800091a8:	406080e7          	jalr	1030(ra) # 800005aa <printf>
  return 0;
    800091ac:	4501                	li	a0,0
    800091ae:	b7cd                	j	80009190 <handle_tcp_packet+0xce>
    printf("SYN received!\n");
    800091b0:	00003517          	auipc	a0,0x3
    800091b4:	c0850513          	addi	a0,a0,-1016 # 8000bdb8 <etext+0xdb8>
    800091b8:	ffff7097          	auipc	ra,0xffff7
    800091bc:	3f2080e7          	jalr	1010(ra) # 800005aa <printf>
    if (port_bind->sock->type != IPPROTO_TCP) {
    800091c0:	00893783          	ld	a5,8(s2)
    800091c4:	5bd4                	lw	a3,52(a5)
    800091c6:	4719                	li	a4,6
    800091c8:	02e69863          	bne	a3,a4,800091f8 <handle_tcp_packet+0x136>
    if (port_bind->sock->state != LISTENING) {
    800091cc:	5fd4                	lw	a3,60(a5)
    800091ce:	03400713          	li	a4,52
    800091d2:	02e69563          	bne	a3,a4,800091fc <handle_tcp_packet+0x13a>
    port_bind->sock->state = SYN_RECVD;
    800091d6:	03600713          	li	a4,54
    800091da:	dfd8                	sw	a4,60(a5)
  return 0;
    800091dc:	4501                	li	a0,0
    800091de:	bf4d                	j	80009190 <handle_tcp_packet+0xce>
    printf("ACK received!\n");
    800091e0:	00003517          	auipc	a0,0x3
    800091e4:	be850513          	addi	a0,a0,-1048 # 8000bdc8 <etext+0xdc8>
    800091e8:	ffff7097          	auipc	ra,0xffff7
    800091ec:	3c2080e7          	jalr	962(ra) # 800005aa <printf>
  return 0;
    800091f0:	4501                	li	a0,0
    800091f2:	bf79                	j	80009190 <handle_tcp_packet+0xce>
    return -1;
    800091f4:	557d                	li	a0,-1
    800091f6:	bf69                	j	80009190 <handle_tcp_packet+0xce>
      return -1;
    800091f8:	557d                	li	a0,-1
    800091fa:	bf59                	j	80009190 <handle_tcp_packet+0xce>
      return -1;
    800091fc:	557d                	li	a0,-1
    800091fe:	bf49                	j	80009190 <handle_tcp_packet+0xce>

0000000080009200 <build_udp>:
#include "socket.h"
#include "udp.h"

void 
build_udp(struct udp_frame *udp, uint16 src_port, uint16 dst_port, uint8 *payload, int payload_len)
{
    80009200:	1141                	addi	sp,sp,-16
    80009202:	e406                	sd	ra,8(sp)
    80009204:	e022                	sd	s0,0(sp)
    80009206:	0800                	addi	s0,sp,16
    80009208:	87b2                	mv	a5,a2
    8000920a:	863a                	mv	a2,a4
  return (hostshort >> 8) | (hostshort << 8);
    8000920c:	0085d71b          	srliw	a4,a1,0x8
  udp->hdr.src_port = htons(src_port); 
    80009210:	00e50023          	sb	a4,0(a0)
    80009214:	00b500a3          	sb	a1,1(a0)
  udp->hdr.dst_port = (dst_port);
    80009218:	00f50123          	sb	a5,2(a0)
    8000921c:	83a1                	srli	a5,a5,0x8
    8000921e:	00f501a3          	sb	a5,3(a0)
  udp->hdr.len = htons(payload_len + UDP_HDR_SIZE);
    80009222:	03061793          	slli	a5,a2,0x30
    80009226:	93c1                	srli	a5,a5,0x30
    80009228:	0087881b          	addiw	a6,a5,8
    8000922c:	0108171b          	slliw	a4,a6,0x10
    80009230:	0107571b          	srliw	a4,a4,0x10
    80009234:	0087571b          	srliw	a4,a4,0x8
    80009238:	00e50223          	sb	a4,4(a0)
    8000923c:	010502a3          	sb	a6,5(a0)
  udp->hdr.csum = 0;
    80009240:	00050323          	sb	zero,6(a0)
    80009244:	000503a3          	sb	zero,7(a0)
    80009248:	0087d71b          	srliw	a4,a5,0x8
    8000924c:	0087979b          	slliw	a5,a5,0x8
    80009250:	8fd9                	or	a5,a5,a4
  udp->payload_len = htons(payload_len);
    80009252:	0107971b          	slliw	a4,a5,0x10
    80009256:	0107571b          	srliw	a4,a4,0x10
    8000925a:	5ef50223          	sb	a5,1508(a0)
    8000925e:	0087579b          	srliw	a5,a4,0x8
    80009262:	5ef502a3          	sb	a5,1509(a0)
    80009266:	5e050323          	sb	zero,1510(a0)
    8000926a:	5e0503a3          	sb	zero,1511(a0)
  memmove(udp->payload, payload, payload_len);
    8000926e:	85b6                	mv	a1,a3
    80009270:	0521                	addi	a0,a0,8
    80009272:	ffff8097          	auipc	ra,0xffff8
    80009276:	c00080e7          	jalr	-1024(ra) # 80000e72 <memmove>
}
    8000927a:	60a2                	ld	ra,8(sp)
    8000927c:	6402                	ld	s0,0(sp)
    8000927e:	0141                	addi	sp,sp,16
    80009280:	8082                	ret

0000000080009282 <enqueue_udp_packet>:

void
enqueue_udp_packet(struct udp_frame *pkt, struct socket *sock) 
{
    80009282:	1141                	addi	sp,sp,-16
    80009284:	e406                	sd	ra,8(sp)
    80009286:	e022                	sd	s0,0(sp)
    80009288:	0800                	addi	s0,sp,16
  if (sock->rx_head == 0) {
    8000928a:	69bc                	ld	a5,80(a1)
    8000928c:	cbb1                	beqz	a5,800092e0 <enqueue_udp_packet+0x5e>
    sock->rx_head = pkt;
    sock->rx_tail = pkt;
  } else {
    struct udp_frame *temp = sock->rx_tail;
    8000928e:	6dbc                	ld	a5,88(a1)
    sock->rx_tail = pkt;
    80009290:	eda8                	sd	a0,88(a1)
    pkt->next = temp;
    80009292:	5ef50423          	sb	a5,1512(a0)
    80009296:	0087d713          	srli	a4,a5,0x8
    8000929a:	5ee504a3          	sb	a4,1513(a0)
    8000929e:	0107d713          	srli	a4,a5,0x10
    800092a2:	5ee50523          	sb	a4,1514(a0)
    800092a6:	0187d71b          	srliw	a4,a5,0x18
    800092aa:	5ee505a3          	sb	a4,1515(a0)
    800092ae:	0207d713          	srli	a4,a5,0x20
    800092b2:	5ee50623          	sb	a4,1516(a0)
    800092b6:	0287d713          	srli	a4,a5,0x28
    800092ba:	5ee506a3          	sb	a4,1517(a0)
    800092be:	0307d713          	srli	a4,a5,0x30
    800092c2:	5ee50723          	sb	a4,1518(a0)
    800092c6:	93e1                	srli	a5,a5,0x38
    800092c8:	5ef507a3          	sb	a5,1519(a0)
  }
  wakeup(&sock->rx_head);
    800092cc:	05058513          	addi	a0,a1,80
    800092d0:	ffff9097          	auipc	ra,0xffff9
    800092d4:	49c080e7          	jalr	1180(ra) # 8000276c <wakeup>
}
    800092d8:	60a2                	ld	ra,8(sp)
    800092da:	6402                	ld	s0,0(sp)
    800092dc:	0141                	addi	sp,sp,16
    800092de:	8082                	ret
    sock->rx_head = pkt;
    800092e0:	e9a8                	sd	a0,80(a1)
    sock->rx_tail = pkt;
    800092e2:	eda8                	sd	a0,88(a1)
    800092e4:	b7e5                	j	800092cc <enqueue_udp_packet+0x4a>

00000000800092e6 <dequeue_udp_packet>:

struct udp_frame*
dequeue_udp_packet(struct socket *sock)
{
    800092e6:	1141                	addi	sp,sp,-16
    800092e8:	e406                	sd	ra,8(sp)
    800092ea:	e022                	sd	s0,0(sp)
    800092ec:	0800                	addi	s0,sp,16
    800092ee:	872a                	mv	a4,a0
  struct udp_frame *ret = 0;

  if (sock->rx_head) {
    800092f0:	6928                	ld	a0,80(a0)
    800092f2:	c129                	beqz	a0,80009334 <dequeue_udp_packet+0x4e>
    ret = sock->rx_head;
    sock->rx_head = ret->next;
    800092f4:	5e854683          	lbu	a3,1512(a0)
    800092f8:	5e954783          	lbu	a5,1513(a0)
    800092fc:	07a2                	slli	a5,a5,0x8
    800092fe:	8fd5                	or	a5,a5,a3
    80009300:	5ea54683          	lbu	a3,1514(a0)
    80009304:	06c2                	slli	a3,a3,0x10
    80009306:	8edd                	or	a3,a3,a5
    80009308:	5eb54783          	lbu	a5,1515(a0)
    8000930c:	07e2                	slli	a5,a5,0x18
    8000930e:	8fd5                	or	a5,a5,a3
    80009310:	5ec54683          	lbu	a3,1516(a0)
    80009314:	1682                	slli	a3,a3,0x20
    80009316:	8edd                	or	a3,a3,a5
    80009318:	5ed54783          	lbu	a5,1517(a0)
    8000931c:	17a2                	slli	a5,a5,0x28
    8000931e:	8fd5                	or	a5,a5,a3
    80009320:	5ee54683          	lbu	a3,1518(a0)
    80009324:	16c2                	slli	a3,a3,0x30
    80009326:	8edd                	or	a3,a3,a5
    80009328:	5ef54783          	lbu	a5,1519(a0)
    8000932c:	17e2                	slli	a5,a5,0x38
    8000932e:	8fd5                	or	a5,a5,a3
    80009330:	eb3c                	sd	a5,80(a4)
    if (sock->rx_head == 0)
    80009332:	c789                	beqz	a5,8000933c <dequeue_udp_packet+0x56>
      sock->rx_tail = 0;   // queue is now empty
  }
  return ret;   // caller owns ret and must free after use}
}
    80009334:	60a2                	ld	ra,8(sp)
    80009336:	6402                	ld	s0,0(sp)
    80009338:	0141                	addi	sp,sp,16
    8000933a:	8082                	ret
      sock->rx_tail = 0;   // queue is now empty
    8000933c:	04073c23          	sd	zero,88(a4)
  return ret;   // caller owns ret and must free after use}
    80009340:	bfd5                	j	80009334 <dequeue_udp_packet+0x4e>

0000000080009342 <udp_bind>:

int 
udp_bind(struct socket *sock, const struct sockaddr *sock_address, socklen_t addrlen) {
    80009342:	7139                	addi	sp,sp,-64
    80009344:	fc06                	sd	ra,56(sp)
    80009346:	f822                	sd	s0,48(sp)
    80009348:	f426                	sd	s1,40(sp)
    8000934a:	0080                	addi	s0,sp,64
  if (sock == 0) {
    8000934c:	c955                	beqz	a0,80009400 <udp_bind+0xbe>
    8000934e:	ec4e                	sd	s3,24(sp)
    80009350:	e852                	sd	s4,16(sp)
    80009352:	89aa                	mv	s3,a0
    80009354:	8a2e                	mv	s4,a1
    printf("bind: socket == 0\n");
    return -1;
  } else if (sock_address == 0) {
    80009356:	cddd                	beqz	a1,80009414 <udp_bind+0xd2>
  return (netshort >> 8) | (netshort << 8);
    80009358:	0025d783          	lhu	a5,2(a1)
    8000935c:	0087d493          	srli	s1,a5,0x8
    80009360:	0087979b          	slliw	a5,a5,0x8
    80009364:	8cdd                	or	s1,s1,a5
    80009366:	14c2                	slli	s1,s1,0x30
    80009368:	90c1                	srli	s1,s1,0x30
  }

  const struct sockaddr_in *sockaddr = (struct sockaddr_in *)sock_address;
  uint16 port = ntohs(sockaddr->sin_port);

  if(port <= 0 || port >= MAX_PORT_BINDINGS) {
    8000936a:	fff4879b          	addiw	a5,s1,-1
    8000936e:	17c2                	slli	a5,a5,0x30
    80009370:	93c1                	srli	a5,a5,0x30
    80009372:	1fe00713          	li	a4,510
    80009376:	0af76b63          	bltu	a4,a5,8000942c <udp_bind+0xea>
    8000937a:	e456                	sd	s5,8(sp)
    printf("bind: port number %d not valid within range\n", port);
    return -1;
  } else if (udp_port_binds[port]) {
    8000937c:	00048a9b          	sext.w	s5,s1
    80009380:	00349713          	slli	a4,s1,0x3
    80009384:	00069797          	auipc	a5,0x69
    80009388:	47478793          	addi	a5,a5,1140 # 800727f8 <udp_port_binds>
    8000938c:	97ba                	add	a5,a5,a4
    8000938e:	639c                	ld	a5,0(a5)
    80009390:	ebdd                	bnez	a5,80009446 <udp_bind+0x104>
    printf("bind: port number already bound\n");
    return -1;
  }

  switch(sock->family) {
    80009392:	5d18                	lw	a4,56(a0)
    80009394:	4789                	li	a5,2
    80009396:	12f71b63          	bne	a4,a5,800094cc <udp_bind+0x18a>
    case(AF_INET):
      if (addrlen != sizeof(struct sockaddr_in)) {
    8000939a:	47c1                	li	a5,16
    8000939c:	0cf61263          	bne	a2,a5,80009460 <udp_bind+0x11e>
    800093a0:	f04a                	sd	s2,32(sp)
        printf("bind: incorrect addrlen for ipv4\n");
        return -1;
      }

      struct port_binding *binding = (struct port_binding*) kalloc();
    800093a2:	ffff8097          	auipc	ra,0xffff8
    800093a6:	862080e7          	jalr	-1950(ra) # 80000c04 <kalloc>
    800093aa:	892a                	mv	s2,a0
      if (binding == 0) {
    800093ac:	c579                	beqz	a0,8000947a <udp_bind+0x138>
        printf("ERROR: kalloc\n");
        return -1;
      }
      binding->port = port;
    800093ae:	00951123          	sh	s1,2(a0)
      if (sockaddr->sin_addr.s_addr == INADDR_ANY) {
    800093b2:	004a2783          	lw	a5,4(s4)
    800093b6:	4705                	li	a4,1
    800093b8:	0ce78f63          	beq	a5,a4,80009496 <udp_bind+0x154>
        sock->src_ip = netconf.ip_addr;
        binding->ip_addr = netconf.ip_addr;
      } else {
        binding->ip_addr = sockaddr->sin_addr.s_addr;
    800093bc:	00f51023          	sh	a5,0(a0)
        sock->src_ip = sockaddr->sin_addr.s_addr;
    800093c0:	004a2783          	lw	a5,4(s4)
    800093c4:	02f9a023          	sw	a5,32(s3)
      }

      binding->sock = sock;
    800093c8:	01393423          	sd	s3,8(s2)

      if (insert_port_binding(binding) == -1){
    800093cc:	854a                	mv	a0,s2
    800093ce:	fffff097          	auipc	ra,0xfffff
    800093d2:	da2080e7          	jalr	-606(ra) # 80008170 <insert_port_binding>
    800093d6:	84aa                	mv	s1,a0
    800093d8:	57fd                	li	a5,-1
    800093da:	0cf50763          	beq	a0,a5,800094a8 <udp_bind+0x166>
        printf("bind: failed to bind to port\n");
        kfree(binding);
        return -1;
      }

      sock->src_port = port;
    800093de:	0359a423          	sw	s5,40(s3)
      sock->state = BOUND;
    800093e2:	03300793          	li	a5,51
    800093e6:	02f9ae23          	sw	a5,60(s3)
      return 0;
    800093ea:	4481                	li	s1,0
    800093ec:	7902                	ld	s2,32(sp)
    800093ee:	69e2                	ld	s3,24(sp)
    800093f0:	6a42                	ld	s4,16(sp)
    800093f2:	6aa2                	ld	s5,8(sp)
    default:
      return -1;
  }

  return 0;
}
    800093f4:	8526                	mv	a0,s1
    800093f6:	70e2                	ld	ra,56(sp)
    800093f8:	7442                	ld	s0,48(sp)
    800093fa:	74a2                	ld	s1,40(sp)
    800093fc:	6121                	addi	sp,sp,64
    800093fe:	8082                	ret
    printf("bind: socket == 0\n");
    80009400:	00003517          	auipc	a0,0x3
    80009404:	9d850513          	addi	a0,a0,-1576 # 8000bdd8 <etext+0xdd8>
    80009408:	ffff7097          	auipc	ra,0xffff7
    8000940c:	1a2080e7          	jalr	418(ra) # 800005aa <printf>
    return -1;
    80009410:	54fd                	li	s1,-1
    80009412:	b7cd                	j	800093f4 <udp_bind+0xb2>
    printf("bind: sock_address == 0\n");
    80009414:	00003517          	auipc	a0,0x3
    80009418:	9dc50513          	addi	a0,a0,-1572 # 8000bdf0 <etext+0xdf0>
    8000941c:	ffff7097          	auipc	ra,0xffff7
    80009420:	18e080e7          	jalr	398(ra) # 800005aa <printf>
    return -1;
    80009424:	54fd                	li	s1,-1
    80009426:	69e2                	ld	s3,24(sp)
    80009428:	6a42                	ld	s4,16(sp)
    8000942a:	b7e9                	j	800093f4 <udp_bind+0xb2>
    printf("bind: port number %d not valid within range\n", port);
    8000942c:	85a6                	mv	a1,s1
    8000942e:	00002517          	auipc	a0,0x2
    80009432:	7da50513          	addi	a0,a0,2010 # 8000bc08 <etext+0xc08>
    80009436:	ffff7097          	auipc	ra,0xffff7
    8000943a:	174080e7          	jalr	372(ra) # 800005aa <printf>
    return -1;
    8000943e:	54fd                	li	s1,-1
    80009440:	69e2                	ld	s3,24(sp)
    80009442:	6a42                	ld	s4,16(sp)
    80009444:	bf45                	j	800093f4 <udp_bind+0xb2>
    printf("bind: port number already bound\n");
    80009446:	00002517          	auipc	a0,0x2
    8000944a:	7f250513          	addi	a0,a0,2034 # 8000bc38 <etext+0xc38>
    8000944e:	ffff7097          	auipc	ra,0xffff7
    80009452:	15c080e7          	jalr	348(ra) # 800005aa <printf>
    return -1;
    80009456:	54fd                	li	s1,-1
    80009458:	69e2                	ld	s3,24(sp)
    8000945a:	6a42                	ld	s4,16(sp)
    8000945c:	6aa2                	ld	s5,8(sp)
    8000945e:	bf59                	j	800093f4 <udp_bind+0xb2>
        printf("bind: incorrect addrlen for ipv4\n");
    80009460:	00003517          	auipc	a0,0x3
    80009464:	80050513          	addi	a0,a0,-2048 # 8000bc60 <etext+0xc60>
    80009468:	ffff7097          	auipc	ra,0xffff7
    8000946c:	142080e7          	jalr	322(ra) # 800005aa <printf>
        return -1;
    80009470:	54fd                	li	s1,-1
    80009472:	69e2                	ld	s3,24(sp)
    80009474:	6a42                	ld	s4,16(sp)
    80009476:	6aa2                	ld	s5,8(sp)
    80009478:	bfb5                	j	800093f4 <udp_bind+0xb2>
        printf("ERROR: kalloc\n");
    8000947a:	00002517          	auipc	a0,0x2
    8000947e:	ffe50513          	addi	a0,a0,-2 # 8000b478 <etext+0x478>
    80009482:	ffff7097          	auipc	ra,0xffff7
    80009486:	128080e7          	jalr	296(ra) # 800005aa <printf>
        return -1;
    8000948a:	54fd                	li	s1,-1
    8000948c:	7902                	ld	s2,32(sp)
    8000948e:	69e2                	ld	s3,24(sp)
    80009490:	6a42                	ld	s4,16(sp)
    80009492:	6aa2                	ld	s5,8(sp)
    80009494:	b785                	j	800093f4 <udp_bind+0xb2>
        sock->src_ip = netconf.ip_addr;
    80009496:	00007797          	auipc	a5,0x7
    8000949a:	8727a783          	lw	a5,-1934(a5) # 8000fd08 <netconf>
    8000949e:	02f9a023          	sw	a5,32(s3)
        binding->ip_addr = netconf.ip_addr;
    800094a2:	00f51023          	sh	a5,0(a0)
    800094a6:	b70d                	j	800093c8 <udp_bind+0x86>
        printf("bind: failed to bind to port\n");
    800094a8:	00002517          	auipc	a0,0x2
    800094ac:	7f850513          	addi	a0,a0,2040 # 8000bca0 <etext+0xca0>
    800094b0:	ffff7097          	auipc	ra,0xffff7
    800094b4:	0fa080e7          	jalr	250(ra) # 800005aa <printf>
        kfree(binding);
    800094b8:	854a                	mv	a0,s2
    800094ba:	ffff7097          	auipc	ra,0xffff7
    800094be:	5e2080e7          	jalr	1506(ra) # 80000a9c <kfree>
        return -1;
    800094c2:	7902                	ld	s2,32(sp)
    800094c4:	69e2                	ld	s3,24(sp)
    800094c6:	6a42                	ld	s4,16(sp)
    800094c8:	6aa2                	ld	s5,8(sp)
    800094ca:	b72d                	j	800093f4 <udp_bind+0xb2>
      return -1;
    800094cc:	54fd                	li	s1,-1
    800094ce:	69e2                	ld	s3,24(sp)
    800094d0:	6a42                	ld	s4,16(sp)
    800094d2:	6aa2                	ld	s5,8(sp)
    800094d4:	b705                	j	800093f4 <udp_bind+0xb2>

00000000800094d6 <udp_connect>:

int 
udp_connect(struct socket *sock, const struct sockaddr *addr, socklen_t addrlen)
{
    800094d6:	1141                	addi	sp,sp,-16
    800094d8:	e406                	sd	ra,8(sp)
    800094da:	e022                	sd	s0,0(sp)
    800094dc:	0800                	addi	s0,sp,16
  return 0;
}
    800094de:	4501                	li	a0,0
    800094e0:	60a2                	ld	ra,8(sp)
    800094e2:	6402                	ld	s0,0(sp)
    800094e4:	0141                	addi	sp,sp,16
    800094e6:	8082                	ret

00000000800094e8 <udp_close>:

int
udp_close(struct socket *sock)
{
    800094e8:	1141                	addi	sp,sp,-16
    800094ea:	e406                	sd	ra,8(sp)
    800094ec:	e022                	sd	s0,0(sp)
    800094ee:	0800                	addi	s0,sp,16
  return 0;
}
    800094f0:	4501                	li	a0,0
    800094f2:	60a2                	ld	ra,8(sp)
    800094f4:	6402                	ld	s0,0(sp)
    800094f6:	0141                	addi	sp,sp,16
    800094f8:	8082                	ret

00000000800094fa <udp_sendto>:

int 
udp_sendto(struct socket *sock, const void *buf, int len, int flags, 
    const struct sockaddr *dest, socklen_t addrlen)
{
    800094fa:	7159                	addi	sp,sp,-112
    800094fc:	f486                	sd	ra,104(sp)
    800094fe:	f0a2                	sd	s0,96(sp)
    80009500:	eca6                	sd	s1,88(sp)
    80009502:	1880                	addi	s0,sp,112
    80009504:	f8b43c23          	sd	a1,-104(s0)
    80009508:	84ba                	mv	s1,a4
  struct sockaddr_in kaddr;
  if (addrlen < sizeof(kaddr))
    8000950a:	473d                	li	a4,15
    8000950c:	14f77363          	bgeu	a4,a5,80009652 <udp_sendto+0x158>
    80009510:	e8ca                	sd	s2,80(sp)
    80009512:	fc56                	sd	s5,56(sp)
    80009514:	8aaa                	mv	s5,a0
    80009516:	8932                	mv	s2,a2
    return -1;

  if (copyin(myproc()->pagetable, (char *)&kaddr, (uint64)dest, sizeof(kaddr)) < 0)
    80009518:	ffff9097          	auipc	ra,0xffff9
    8000951c:	942080e7          	jalr	-1726(ra) # 80001e5a <myproc>
    80009520:	46c1                	li	a3,16
    80009522:	8626                	mv	a2,s1
    80009524:	fb040593          	addi	a1,s0,-80
    80009528:	6928                	ld	a0,80(a0)
    8000952a:	ffff8097          	auipc	ra,0xffff8
    8000952e:	664080e7          	jalr	1636(ra) # 80001b8e <copyin>
    80009532:	12054263          	bltz	a0,80009656 <udp_sendto+0x15c>
    80009536:	e4ce                	sd	s3,72(sp)
    80009538:	e0d2                	sd	s4,64(sp)
    return -1;

  uint32 dst_ip = (&kaddr)->sin_addr.s_addr;
    8000953a:	fb442483          	lw	s1,-76(s0)
  uint8 dst_mac[6];
  if (arp_lookup(dst_ip, dst_mac) == -1) {
    8000953e:	fa840593          	addi	a1,s0,-88
    80009542:	8526                	mv	a0,s1
    80009544:	00000097          	auipc	ra,0x0
    80009548:	390080e7          	jalr	912(ra) # 800098d4 <arp_lookup>
    8000954c:	57fd                	li	a5,-1
    8000954e:	0ef50163          	beq	a0,a5,80009630 <udp_sendto+0x136>
      // return -1;
    }
    // return -1;
  }

  struct eth_frame *eth = kalloc();
    80009552:	ffff7097          	auipc	ra,0xffff7
    80009556:	6b2080e7          	jalr	1714(ra) # 80000c04 <kalloc>
    8000955a:	89aa                	mv	s3,a0
  struct ip4_frame *ip = (struct ip4_frame *)eth->payload;
  struct udp_frame *udp = (struct udp_frame *)ip->payload;
    8000955c:	00e50a13          	addi	s4,a0,14

  build_udp(udp, sock->src_port, ((struct sockaddr_in *)&kaddr)->sin_port, (uint8 *)&buf, len);
    80009560:	874a                	mv	a4,s2
    80009562:	f9840693          	addi	a3,s0,-104
    80009566:	fb245603          	lhu	a2,-78(s0)
    8000956a:	028ad583          	lhu	a1,40(s5)
    8000956e:	02250513          	addi	a0,a0,34
    80009572:	00000097          	auipc	ra,0x0
    80009576:	c8e080e7          	jalr	-882(ra) # 80009200 <build_udp>
  build_ip4(ip, ntohl(netconf.ip_addr), ntohl(dst_ip), IPPROTO_UDP, len + sizeof(struct udp_hdr) + sizeof(struct ip4_hdr));
    8000957a:	00006797          	auipc	a5,0x6
    8000957e:	78e7a783          	lw	a5,1934(a5) # 8000fd08 <netconf>
    80009582:	1942                	slli	s2,s2,0x30
    80009584:	03095913          	srli	s2,s2,0x30
    80009588:	01c9071b          	addiw	a4,s2,28
  return ((netlong & 0x000000FFU) << 24) |
    8000958c:	0184961b          	slliw	a2,s1,0x18
    ((netlong & 0xFF000000U) >> 24);
    80009590:	0184d69b          	srliw	a3,s1,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    80009594:	8e55                	or	a2,a2,a3
    ((netlong & 0x0000FF00U) << 8)  |
    80009596:	0084969b          	slliw	a3,s1,0x8
    8000959a:	00ff0837          	lui	a6,0xff0
    8000959e:	0106f6b3          	and	a3,a3,a6
    ((netlong & 0x00FF0000U) >> 8)  |
    800095a2:	8e55                	or	a2,a2,a3
    800095a4:	0084d49b          	srliw	s1,s1,0x8
    800095a8:	66c1                	lui	a3,0x10
    800095aa:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800095ae:	8cf5                	and	s1,s1,a3
  return ((netlong & 0x000000FFU) << 24) |
    800095b0:	0187959b          	slliw	a1,a5,0x18
    ((netlong & 0xFF000000U) >> 24);
    800095b4:	0187d51b          	srliw	a0,a5,0x18
    ((netlong & 0x00FF0000U) >> 8)  |
    800095b8:	8dc9                	or	a1,a1,a0
    ((netlong & 0x0000FF00U) << 8)  |
    800095ba:	0087951b          	slliw	a0,a5,0x8
    800095be:	01057533          	and	a0,a0,a6
    ((netlong & 0x00FF0000U) >> 8)  |
    800095c2:	8dc9                	or	a1,a1,a0
    800095c4:	0087d79b          	srliw	a5,a5,0x8
    800095c8:	8ff5                	and	a5,a5,a3
    800095ca:	1742                	slli	a4,a4,0x30
    800095cc:	9341                	srli	a4,a4,0x30
    800095ce:	46c5                	li	a3,17
    800095d0:	8e45                	or	a2,a2,s1
    800095d2:	8ddd                	or	a1,a1,a5
    800095d4:	8552                	mv	a0,s4
    800095d6:	fffff097          	auipc	ra,0xfffff
    800095da:	820080e7          	jalr	-2016(ra) # 80007df6 <build_ip4>
  build_eth(eth, dst_mac, netconf.mac_addr, PROTO_IPV4);
    800095de:	6685                	lui	a3,0x1
    800095e0:	80068693          	addi	a3,a3,-2048 # 800 <_entry-0x7ffff800>
    800095e4:	00006617          	auipc	a2,0x6
    800095e8:	72860613          	addi	a2,a2,1832 # 8000fd0c <netconf+0x4>
    800095ec:	fa840593          	addi	a1,s0,-88
    800095f0:	854e                	mv	a0,s3
    800095f2:	fffff097          	auipc	ra,0xfffff
    800095f6:	4a6080e7          	jalr	1190(ra) # 80008a98 <build_eth>

  transmit_packet(eth, len + sizeof(struct udp_hdr) + sizeof(struct ip4_hdr) + sizeof(struct eth_hdr), PROTO_IPV4);
    800095fa:	02a9059b          	addiw	a1,s2,42
    800095fe:	6605                	lui	a2,0x1
    80009600:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80009604:	15c2                	slli	a1,a1,0x30
    80009606:	91c1                	srli	a1,a1,0x30
    80009608:	854e                	mv	a0,s3
    8000960a:	ffffe097          	auipc	ra,0xffffe
    8000960e:	17e080e7          	jalr	382(ra) # 80007788 <transmit_packet>
  kfree(eth);
    80009612:	854e                	mv	a0,s3
    80009614:	ffff7097          	auipc	ra,0xffff7
    80009618:	488080e7          	jalr	1160(ra) # 80000a9c <kfree>
  eth = 0;
  ip = 0;
  udp = 0;

  return 0;
    8000961c:	4501                	li	a0,0
    8000961e:	6946                	ld	s2,80(sp)
    80009620:	69a6                	ld	s3,72(sp)
    80009622:	6a06                	ld	s4,64(sp)
    80009624:	7ae2                	ld	s5,56(sp)
}
    80009626:	70a6                	ld	ra,104(sp)
    80009628:	7406                	ld	s0,96(sp)
    8000962a:	64e6                	ld	s1,88(sp)
    8000962c:	6165                	addi	sp,sp,112
    8000962e:	8082                	ret
    arp_request(dst_ip);
    80009630:	8526                	mv	a0,s1
    80009632:	00000097          	auipc	ra,0x0
    80009636:	386080e7          	jalr	902(ra) # 800099b8 <arp_request>
    while (arp_lookup(dst_ip, dst_mac) == -1) {
    8000963a:	fa840a13          	addi	s4,s0,-88
    8000963e:	59fd                	li	s3,-1
    80009640:	85d2                	mv	a1,s4
    80009642:	8526                	mv	a0,s1
    80009644:	00000097          	auipc	ra,0x0
    80009648:	290080e7          	jalr	656(ra) # 800098d4 <arp_lookup>
    8000964c:	ff350ae3          	beq	a0,s3,80009640 <udp_sendto+0x146>
    80009650:	b709                	j	80009552 <udp_sendto+0x58>
    return -1;
    80009652:	557d                	li	a0,-1
    80009654:	bfc9                	j	80009626 <udp_sendto+0x12c>
    return -1;
    80009656:	557d                	li	a0,-1
    80009658:	6946                	ld	s2,80(sp)
    8000965a:	7ae2                	ld	s5,56(sp)
    8000965c:	b7e9                	j	80009626 <udp_sendto+0x12c>

000000008000965e <udp_recvfrom>:

int 
udp_recvfrom(struct socket *sock, void *buf, int len, int flags,
    const struct sockaddr *src, socklen_t *addrlen)
{
    8000965e:	7139                	addi	sp,sp,-64
    80009660:	fc06                	sd	ra,56(sp)
    80009662:	f822                	sd	s0,48(sp)
    80009664:	f426                	sd	s1,40(sp)
    80009666:	f04a                	sd	s2,32(sp)
    80009668:	ec4e                	sd	s3,24(sp)
    8000966a:	e852                	sd	s4,16(sp)
    8000966c:	0080                	addi	s0,sp,64
    8000966e:	84aa                	mv	s1,a0
    80009670:	8a2e                	mv	s4,a1
    80009672:	89b2                	mv	s3,a2
  struct udp_frame *pkt = 0;
  acquire(&sock->lock);
    80009674:	00850913          	addi	s2,a0,8
    80009678:	854a                	mv	a0,s2
    8000967a:	ffff7097          	auipc	ra,0xffff7
    8000967e:	69c080e7          	jalr	1692(ra) # 80000d16 <acquire>
  while (!sock->rx_head) {
    80009682:	68bc                	ld	a5,80(s1)
    80009684:	ef89                	bnez	a5,8000969e <udp_recvfrom+0x40>
    80009686:	e456                	sd	s5,8(sp)
    sleep(&sock->rx_head, &sock->lock);
    80009688:	05048a93          	addi	s5,s1,80
    8000968c:	85ca                	mv	a1,s2
    8000968e:	8556                	mv	a0,s5
    80009690:	ffff9097          	auipc	ra,0xffff9
    80009694:	078080e7          	jalr	120(ra) # 80002708 <sleep>
  while (!sock->rx_head) {
    80009698:	68bc                	ld	a5,80(s1)
    8000969a:	dbed                	beqz	a5,8000968c <udp_recvfrom+0x2e>
    8000969c:	6aa2                	ld	s5,8(sp)
  }
  printf("received a packet!\n");
    8000969e:	00002517          	auipc	a0,0x2
    800096a2:	77250513          	addi	a0,a0,1906 # 8000be10 <etext+0xe10>
    800096a6:	ffff7097          	auipc	ra,0xffff7
    800096aa:	f04080e7          	jalr	-252(ra) # 800005aa <printf>
  pkt = (struct udp_frame *)dequeue_udp_packet(sock);
    800096ae:	8526                	mv	a0,s1
    800096b0:	00000097          	auipc	ra,0x0
    800096b4:	c36080e7          	jalr	-970(ra) # 800092e6 <dequeue_udp_packet>
    800096b8:	84aa                	mv	s1,a0

  int payload_len = len - sizeof(struct udp_hdr);
  release(&sock->lock);
    800096ba:	854a                	mv	a0,s2
    800096bc:	ffff7097          	auipc	ra,0xffff7
    800096c0:	70a080e7          	jalr	1802(ra) # 80000dc6 <release>

  // Copy payload
  int n;
  if (pkt->payload_len < len) {
    800096c4:	5e44c703          	lbu	a4,1508(s1)
    800096c8:	5e54c783          	lbu	a5,1509(s1)
    800096cc:	07a2                	slli	a5,a5,0x8
    800096ce:	8fd9                	or	a5,a5,a4
    800096d0:	5e64c703          	lbu	a4,1510(s1)
    800096d4:	0742                	slli	a4,a4,0x10
    800096d6:	8f5d                	or	a4,a4,a5
    800096d8:	5e74c783          	lbu	a5,1511(s1)
    800096dc:	07e2                	slli	a5,a5,0x18
    800096de:	8fd9                	or	a5,a5,a4
    800096e0:	2781                	sext.w	a5,a5
    800096e2:	893e                	mv	s2,a5
    800096e4:	2781                	sext.w	a5,a5
    800096e6:	00f9d363          	bge	s3,a5,800096ec <udp_recvfrom+0x8e>
    800096ea:	894e                	mv	s2,s3
    800096ec:	2901                	sext.w	s2,s2
    n = pkt->payload_len;
  } else {
    n = len;
  }

  if (copyout(myproc()->pagetable, (uint64)buf, (char *)pkt->payload, pkt->payload_len) < 0) {;;
    800096ee:	ffff8097          	auipc	ra,0xffff8
    800096f2:	76c080e7          	jalr	1900(ra) # 80001e5a <myproc>
    800096f6:	5e44c783          	lbu	a5,1508(s1)
    800096fa:	5e54c703          	lbu	a4,1509(s1)
    800096fe:	0722                	slli	a4,a4,0x8
    80009700:	8f5d                	or	a4,a4,a5
    80009702:	5e64c783          	lbu	a5,1510(s1)
    80009706:	07c2                	slli	a5,a5,0x10
    80009708:	8fd9                	or	a5,a5,a4
    8000970a:	5e74c683          	lbu	a3,1511(s1)
    8000970e:	06e2                	slli	a3,a3,0x18
    80009710:	8edd                	or	a3,a3,a5
    80009712:	2681                	sext.w	a3,a3
    80009714:	00848613          	addi	a2,s1,8
    80009718:	85d2                	mv	a1,s4
    8000971a:	6928                	ld	a0,80(a0)
    8000971c:	ffff8097          	auipc	ra,0xffff8
    80009720:	3e6080e7          	jalr	998(ra) # 80001b02 <copyout>
    80009724:	02054063          	bltz	a0,80009744 <udp_recvfrom+0xe6>
      kfree(pkt);
      return -1;;
  }

  kfree(pkt);
    80009728:	8526                	mv	a0,s1
    8000972a:	ffff7097          	auipc	ra,0xffff7
    8000972e:	372080e7          	jalr	882(ra) # 80000a9c <kfree>
  return n;
}
    80009732:	854a                	mv	a0,s2
    80009734:	70e2                	ld	ra,56(sp)
    80009736:	7442                	ld	s0,48(sp)
    80009738:	74a2                	ld	s1,40(sp)
    8000973a:	7902                	ld	s2,32(sp)
    8000973c:	69e2                	ld	s3,24(sp)
    8000973e:	6a42                	ld	s4,16(sp)
    80009740:	6121                	addi	sp,sp,64
    80009742:	8082                	ret
      kfree(pkt);
    80009744:	8526                	mv	a0,s1
    80009746:	ffff7097          	auipc	ra,0xffff7
    8000974a:	356080e7          	jalr	854(ra) # 80000a9c <kfree>
      return -1;;
    8000974e:	597d                	li	s2,-1
    80009750:	b7cd                	j	80009732 <udp_recvfrom+0xd4>

0000000080009752 <handle_udp_packet>:

int 
handle_udp_packet(struct udp_frame *udp_pkt) 
{
    80009752:	1101                	addi	sp,sp,-32
    80009754:	ec06                	sd	ra,24(sp)
    80009756:	e822                	sd	s0,16(sp)
    80009758:	e426                	sd	s1,8(sp)
    8000975a:	1000                	addi	s0,sp,32
    8000975c:	84aa                	mv	s1,a0
  printf("\tUDP packet: src_port=%d dst_port=%d len=%d csum=%d\n",
      udp_pkt->hdr.src_port, udp_pkt->hdr.dst_port, udp_pkt->hdr.len, udp_pkt->hdr.csum);
    8000975e:	00654883          	lbu	a7,6(a0)
    80009762:	00754703          	lbu	a4,7(a0)
    80009766:	0722                	slli	a4,a4,0x8
    80009768:	00454803          	lbu	a6,4(a0)
    8000976c:	00554683          	lbu	a3,5(a0)
    80009770:	06a2                	slli	a3,a3,0x8
    80009772:	00254503          	lbu	a0,2(a0)
    80009776:	0034c603          	lbu	a2,3(s1)
    8000977a:	0622                	slli	a2,a2,0x8
    8000977c:	0004c583          	lbu	a1,0(s1)
    80009780:	0014c783          	lbu	a5,1(s1)
    80009784:	07a2                	slli	a5,a5,0x8
  printf("\tUDP packet: src_port=%d dst_port=%d len=%d csum=%d\n",
    80009786:	01176733          	or	a4,a4,a7
    8000978a:	0106e6b3          	or	a3,a3,a6
    8000978e:	8e49                	or	a2,a2,a0
    80009790:	8ddd                	or	a1,a1,a5
    80009792:	00002517          	auipc	a0,0x2
    80009796:	69650513          	addi	a0,a0,1686 # 8000be28 <etext+0xe28>
    8000979a:	ffff7097          	auipc	ra,0xffff7
    8000979e:	e10080e7          	jalr	-496(ra) # 800005aa <printf>

  // validate the port number
  if (udp_pkt->hdr.dst_port < 0 || udp_pkt->hdr.dst_port >= MAX_PORT_BINDINGS) 
    800097a2:	0024c683          	lbu	a3,2(s1)
    800097a6:	0034c783          	lbu	a5,3(s1)
    800097aa:	07a2                	slli	a5,a5,0x8
    800097ac:	00d7e733          	or	a4,a5,a3
    800097b0:	1ff00693          	li	a3,511
    800097b4:	06e6e463          	bltu	a3,a4,8000981c <handle_udp_packet+0xca>
    return -1;

  // validate the socket is listening for datagrams
  if (udp_port_binds[udp_pkt->hdr.dst_port] == 0) {
    800097b8:	070e                	slli	a4,a4,0x3
    800097ba:	00069797          	auipc	a5,0x69
    800097be:	03e78793          	addi	a5,a5,62 # 800727f8 <udp_port_binds>
    800097c2:	97ba                	add	a5,a5,a4
    800097c4:	639c                	ld	a5,0(a5)
    800097c6:	c385                	beqz	a5,800097e6 <handle_udp_packet+0x94>
    800097c8:	e04a                	sd	s2,0(sp)
    printf("port is not bound to socket\n");
    return -1;
  };

  struct socket *sock = udp_port_binds[udp_pkt->hdr.dst_port]->sock;
    800097ca:	0087b903          	ld	s2,8(a5)
  if (sock->proto == IPPROTO_UDP) {
    800097ce:	03092703          	lw	a4,48(s2)
    800097d2:	47c5                	li	a5,17
    printf("enqeueing packet\n");
    enqueue_udp_packet(udp_pkt, sock);
  }
  return 0;
    800097d4:	4501                	li	a0,0
  if (sock->proto == IPPROTO_UDP) {
    800097d6:	02f70263          	beq	a4,a5,800097fa <handle_udp_packet+0xa8>
    800097da:	6902                	ld	s2,0(sp)
}
    800097dc:	60e2                	ld	ra,24(sp)
    800097de:	6442                	ld	s0,16(sp)
    800097e0:	64a2                	ld	s1,8(sp)
    800097e2:	6105                	addi	sp,sp,32
    800097e4:	8082                	ret
    printf("port is not bound to socket\n");
    800097e6:	00002517          	auipc	a0,0x2
    800097ea:	67a50513          	addi	a0,a0,1658 # 8000be60 <etext+0xe60>
    800097ee:	ffff7097          	auipc	ra,0xffff7
    800097f2:	dbc080e7          	jalr	-580(ra) # 800005aa <printf>
    return -1;
    800097f6:	557d                	li	a0,-1
    800097f8:	b7d5                	j	800097dc <handle_udp_packet+0x8a>
    printf("enqeueing packet\n");
    800097fa:	00002517          	auipc	a0,0x2
    800097fe:	68650513          	addi	a0,a0,1670 # 8000be80 <etext+0xe80>
    80009802:	ffff7097          	auipc	ra,0xffff7
    80009806:	da8080e7          	jalr	-600(ra) # 800005aa <printf>
    enqueue_udp_packet(udp_pkt, sock);
    8000980a:	85ca                	mv	a1,s2
    8000980c:	8526                	mv	a0,s1
    8000980e:	00000097          	auipc	ra,0x0
    80009812:	a74080e7          	jalr	-1420(ra) # 80009282 <enqueue_udp_packet>
  return 0;
    80009816:	4501                	li	a0,0
    80009818:	6902                	ld	s2,0(sp)
    8000981a:	b7c9                	j	800097dc <handle_udp_packet+0x8a>
    return -1;
    8000981c:	557d                	li	a0,-1
    8000981e:	bf7d                	j	800097dc <handle_udp_packet+0x8a>

0000000080009820 <parse_udp_packet>:

int 
parse_udp_packet(uint8 *buf, int len, struct udp_frame *udp_pkt) 
{
  if (len < 8) return -1;  // too short for UDP header
    80009820:	471d                	li	a4,7
    80009822:	0ab75363          	bge	a4,a1,800098c8 <parse_udp_packet+0xa8>
    80009826:	87b2                	mv	a5,a2
  return (netshort >> 8) | (netshort << 8);
    80009828:	00055703          	lhu	a4,0(a0)
    8000982c:	00875693          	srli	a3,a4,0x8

  udp_pkt->hdr.src_port = ntohs(*(uint16 *)(buf));
    80009830:	00d60023          	sb	a3,0(a2)
    80009834:	00e600a3          	sb	a4,1(a2)
    80009838:	00255703          	lhu	a4,2(a0)
    8000983c:	00875693          	srli	a3,a4,0x8
  udp_pkt->hdr.dst_port = ntohs(*(uint16 *)(buf + 2));
    80009840:	00d60123          	sb	a3,2(a2)
    80009844:	00e601a3          	sb	a4,3(a2)
    80009848:	00455703          	lhu	a4,4(a0)
    8000984c:	00875693          	srli	a3,a4,0x8
    80009850:	0087171b          	slliw	a4,a4,0x8
    80009854:	8ed9                	or	a3,a3,a4
    80009856:	03069713          	slli	a4,a3,0x30
    8000985a:	9341                	srli	a4,a4,0x30
  udp_pkt->hdr.len      = ntohs(*(uint16 *)(buf + 4));
    8000985c:	00d60223          	sb	a3,4(a2)
    80009860:	00875693          	srli	a3,a4,0x8
    80009864:	00d602a3          	sb	a3,5(a2)
    80009868:	00655683          	lhu	a3,6(a0)
    8000986c:	0086d613          	srli	a2,a3,0x8
  udp_pkt->hdr.csum     = ntohs(*(uint16 *)(buf + 6));
    80009870:	00c78323          	sb	a2,6(a5)
    80009874:	00d783a3          	sb	a3,7(a5)

  if (udp_pkt->hdr.len < 8 || udp_pkt->hdr.len > len)
    80009878:	0007061b          	sext.w	a2,a4
    8000987c:	469d                	li	a3,7
    8000987e:	04c6f763          	bgeu	a3,a2,800098cc <parse_udp_packet+0xac>
    80009882:	04c5c763          	blt	a1,a2,800098d0 <parse_udp_packet+0xb0>
{
    80009886:	1141                	addi	sp,sp,-16
    80009888:	e406                	sd	ra,8(sp)
    8000988a:	e022                	sd	s0,0(sp)
    8000988c:	0800                	addi	s0,sp,16
      return -1;  // malformed length

  udp_pkt->payload_len = len - sizeof(struct udp_hdr);
    8000988e:	ff85861b          	addiw	a2,a1,-8
    80009892:	5ec78223          	sb	a2,1508(a5)
    80009896:	0086571b          	srliw	a4,a2,0x8
    8000989a:	5ee782a3          	sb	a4,1509(a5)
    8000989e:	0106571b          	srliw	a4,a2,0x10
    800098a2:	5ee78323          	sb	a4,1510(a5)
    800098a6:	0186571b          	srliw	a4,a2,0x18
    800098aa:	5ee783a3          	sb	a4,1511(a5)
  memmove(udp_pkt->payload, buf + sizeof(struct udp_hdr), udp_pkt->payload_len);
    800098ae:	00850593          	addi	a1,a0,8
    800098b2:	00878513          	addi	a0,a5,8
    800098b6:	ffff7097          	auipc	ra,0xffff7
    800098ba:	5bc080e7          	jalr	1468(ra) # 80000e72 <memmove>

  return 0;
    800098be:	4501                	li	a0,0
}
    800098c0:	60a2                	ld	ra,8(sp)
    800098c2:	6402                	ld	s0,0(sp)
    800098c4:	0141                	addi	sp,sp,16
    800098c6:	8082                	ret
  if (len < 8) return -1;  // too short for UDP header
    800098c8:	557d                	li	a0,-1
    800098ca:	8082                	ret
      return -1;  // malformed length
    800098cc:	557d                	li	a0,-1
    800098ce:	8082                	ret
    800098d0:	557d                	li	a0,-1
}
    800098d2:	8082                	ret

00000000800098d4 <arp_lookup>:
extern struct arp_entry arp_cache[ARP_CACHE_SIZE];


int
arp_lookup(uint32 ip, uint8 *mac)
{
    800098d4:	1101                	addi	sp,sp,-32
    800098d6:	ec06                	sd	ra,24(sp)
    800098d8:	e822                	sd	s0,16(sp)
    800098da:	e426                	sd	s1,8(sp)
    800098dc:	1000                	addi	s0,sp,32
    800098de:	88aa                	mv	a7,a0
    800098e0:	852e                	mv	a0,a1
  for (int i = 0; i < ARP_CACHE_SIZE; i++) {
    800098e2:	0006a797          	auipc	a5,0x6a
    800098e6:	f1678793          	addi	a5,a5,-234 # 800737f8 <arp_cache>
    800098ea:	4701                	li	a4,0
    struct arp_entry *ae = &arp_cache[i];
    if (ae->valid == 1 && ae->ip == ip) {
    800098ec:	4685                	li	a3,1
  for (int i = 0; i < ARP_CACHE_SIZE; i++) {
    800098ee:	4641                	li	a2,16
    800098f0:	a029                	j	800098fa <arp_lookup+0x26>
    800098f2:	2705                	addiw	a4,a4,1
    800098f4:	07c1                	addi	a5,a5,16
    800098f6:	02c70563          	beq	a4,a2,80009920 <arp_lookup+0x4c>
    if (ae->valid == 1 && ae->ip == ip) {
    800098fa:	47c4                	lw	s1,12(a5)
    800098fc:	fed49be3          	bne	s1,a3,800098f2 <arp_lookup+0x1e>
    80009900:	0007a803          	lw	a6,0(a5)
    80009904:	ff1817e3          	bne	a6,a7,800098f2 <arp_lookup+0x1e>
      memmove(mac, ae->mac, 6);
    80009908:	0712                	slli	a4,a4,0x4
    8000990a:	4619                	li	a2,6
    8000990c:	0006a597          	auipc	a1,0x6a
    80009910:	ef058593          	addi	a1,a1,-272 # 800737fc <arp_cache+0x4>
    80009914:	95ba                	add	a1,a1,a4
    80009916:	ffff7097          	auipc	ra,0xffff7
    8000991a:	55c080e7          	jalr	1372(ra) # 80000e72 <memmove>
      return 1;
    8000991e:	a011                	j	80009922 <arp_lookup+0x4e>
    }
  }
  return -1;
    80009920:	54fd                	li	s1,-1
}
    80009922:	8526                	mv	a0,s1
    80009924:	60e2                	ld	ra,24(sp)
    80009926:	6442                	ld	s0,16(sp)
    80009928:	64a2                	ld	s1,8(sp)
    8000992a:	6105                	addi	sp,sp,32
    8000992c:	8082                	ret

000000008000992e <arp_insert>:

void
arp_insert(uint32 ip, uint8 *mac)
{
    8000992e:	1101                	addi	sp,sp,-32
    80009930:	ec06                	sd	ra,24(sp)
    80009932:	e822                	sd	s0,16(sp)
    80009934:	1000                	addi	s0,sp,32
  for (int i = 0; i < ARP_CACHE_SIZE; i++) {
    80009936:	0006a797          	auipc	a5,0x6a
    8000993a:	ec278793          	addi	a5,a5,-318 # 800737f8 <arp_cache>
    8000993e:	4701                	li	a4,0
    struct arp_entry *ae = &arp_cache[i];
    if (ae->ip == ip) {
      memmove(ae->mac, mac, 6);
      ae->valid = 1;
      break;
    } else if (ae->valid != 1) {
    80009940:	4605                	li	a2,1
  for (int i = 0; i < ARP_CACHE_SIZE; i++) {
    80009942:	4841                	li	a6,16
    if (ae->ip == ip) {
    80009944:	4394                	lw	a3,0(a5)
    80009946:	00a68d63          	beq	a3,a0,80009960 <arp_insert+0x32>
    } else if (ae->valid != 1) {
    8000994a:	47d4                	lw	a3,12(a5)
    8000994c:	04c69163          	bne	a3,a2,8000998e <arp_insert+0x60>
  for (int i = 0; i < ARP_CACHE_SIZE; i++) {
    80009950:	2705                	addiw	a4,a4,1
    80009952:	07c1                	addi	a5,a5,16
    80009954:	ff0718e3          	bne	a4,a6,80009944 <arp_insert+0x16>
      memmove(ae->mac, mac, 6);
      ae->valid = 1;
      break;
    }
  }
}
    80009958:	60e2                	ld	ra,24(sp)
    8000995a:	6442                	ld	s0,16(sp)
    8000995c:	6105                	addi	sp,sp,32
    8000995e:	8082                	ret
    80009960:	e426                	sd	s1,8(sp)
    80009962:	e04a                	sd	s2,0(sp)
      memmove(ae->mac, mac, 6);
    80009964:	0006a917          	auipc	s2,0x6a
    80009968:	e9490913          	addi	s2,s2,-364 # 800737f8 <arp_cache>
    8000996c:	00471493          	slli	s1,a4,0x4
    80009970:	00448513          	addi	a0,s1,4
    80009974:	4619                	li	a2,6
    80009976:	954a                	add	a0,a0,s2
    80009978:	ffff7097          	auipc	ra,0xffff7
    8000997c:	4fa080e7          	jalr	1274(ra) # 80000e72 <memmove>
      ae->valid = 1;
    80009980:	9926                	add	s2,s2,s1
    80009982:	4785                	li	a5,1
    80009984:	00f92623          	sw	a5,12(s2)
      break;
    80009988:	64a2                	ld	s1,8(sp)
    8000998a:	6902                	ld	s2,0(sp)
    8000998c:	b7f1                	j	80009958 <arp_insert+0x2a>
    8000998e:	e426                	sd	s1,8(sp)
      ae->ip = ip;
    80009990:	0006a797          	auipc	a5,0x6a
    80009994:	e6878793          	addi	a5,a5,-408 # 800737f8 <arp_cache>
    80009998:	0712                	slli	a4,a4,0x4
    8000999a:	00e784b3          	add	s1,a5,a4
    8000999e:	c088                	sw	a0,0(s1)
      memmove(ae->mac, mac, 6);
    800099a0:	0711                	addi	a4,a4,4
    800099a2:	4619                	li	a2,6
    800099a4:	00e78533          	add	a0,a5,a4
    800099a8:	ffff7097          	auipc	ra,0xffff7
    800099ac:	4ca080e7          	jalr	1226(ra) # 80000e72 <memmove>
      ae->valid = 1;
    800099b0:	4785                	li	a5,1
    800099b2:	c4dc                	sw	a5,12(s1)
      break;
    800099b4:	64a2                	ld	s1,8(sp)
    800099b6:	b74d                	j	80009958 <arp_insert+0x2a>

00000000800099b8 <arp_request>:

void
arp_request(uint32 target_ip)
{
    800099b8:	7139                	addi	sp,sp,-64
    800099ba:	fc06                	sd	ra,56(sp)
    800099bc:	f822                	sd	s0,48(sp)
    800099be:	f04a                	sd	s2,32(sp)
    800099c0:	0080                	addi	s0,sp,64
    800099c2:	892a                	mv	s2,a0
  struct eth_frame *frame = kalloc();
    800099c4:	ffff7097          	auipc	ra,0xffff7
    800099c8:	240080e7          	jalr	576(ra) # 80000c04 <kalloc>
  if (frame == 0) {
    800099cc:	10050263          	beqz	a0,80009ad0 <arp_request+0x118>
    800099d0:	f426                	sd	s1,40(sp)
    800099d2:	ec4e                	sd	s3,24(sp)
    800099d4:	e852                	sd	s4,16(sp)
    800099d6:	84aa                	mv	s1,a0
    printf("ERROR: kalloc\n");
    return;
  }
  uint8 dst_mac[6] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
    800099d8:	57fd                	li	a5,-1
    800099da:	fcf42423          	sw	a5,-56(s0)
    800099de:	fcf41623          	sh	a5,-52(s0)
  struct arp_pkt *arp = (struct arp_pkt *)frame->payload;
  build_eth(frame, dst_mac, netconf.mac_addr, PROTO_ARP);
    800099e2:	fc840a13          	addi	s4,s0,-56
    800099e6:	6685                	lui	a3,0x1
    800099e8:	80668693          	addi	a3,a3,-2042 # 806 <_entry-0x7ffff7fa>
    800099ec:	00006617          	auipc	a2,0x6
    800099f0:	32060613          	addi	a2,a2,800 # 8000fd0c <netconf+0x4>
    800099f4:	85d2                	mv	a1,s4
    800099f6:	fffff097          	auipc	ra,0xfffff
    800099fa:	0a2080e7          	jalr	162(ra) # 80008a98 <build_eth>

  arp->htype = htons(ARP_HTYPE_ETH);
    800099fe:	00048723          	sb	zero,14(s1)
    80009a02:	4785                	li	a5,1
    80009a04:	00f487a3          	sb	a5,15(s1)
  arp->ptype = htons(PROTO_IPV4);
    80009a08:	4721                	li	a4,8
    80009a0a:	00e48823          	sb	a4,16(s1)
    80009a0e:	000488a3          	sb	zero,17(s1)
  arp->hlen = ARP_HLEN;
    80009a12:	4999                	li	s3,6
    80009a14:	01348923          	sb	s3,18(s1)
  arp->plen = ARP_PLEN;
    80009a18:	4711                	li	a4,4
    80009a1a:	00e489a3          	sb	a4,19(s1)
  arp->oper = htons(ARP_OP_REQUEST); 
    80009a1e:	00048a23          	sb	zero,20(s1)
    80009a22:	00f48aa3          	sb	a5,21(s1)
  arp->spa = netconf.ip_addr;
    80009a26:	00006797          	auipc	a5,0x6
    80009a2a:	2e278793          	addi	a5,a5,738 # 8000fd08 <netconf>
    80009a2e:	0007c703          	lbu	a4,0(a5)
    80009a32:	00e48e23          	sb	a4,28(s1)
    80009a36:	439c                	lw	a5,0(a5)
    80009a38:	0087d71b          	srliw	a4,a5,0x8
    80009a3c:	00e48ea3          	sb	a4,29(s1)
    80009a40:	0107d71b          	srliw	a4,a5,0x10
    80009a44:	00e48f23          	sb	a4,30(s1)
    80009a48:	0187d79b          	srliw	a5,a5,0x18
    80009a4c:	00f48fa3          	sb	a5,31(s1)
  arp->tpa = target_ip;
    80009a50:	03248323          	sb	s2,38(s1)
    80009a54:	0089579b          	srliw	a5,s2,0x8
    80009a58:	02f483a3          	sb	a5,39(s1)
    80009a5c:	0109579b          	srliw	a5,s2,0x10
    80009a60:	02f48423          	sb	a5,40(s1)
    80009a64:	0189591b          	srliw	s2,s2,0x18
    80009a68:	032484a3          	sb	s2,41(s1)
  memmove(arp->sha, netconf.mac_addr, 6);
    80009a6c:	864e                	mv	a2,s3
    80009a6e:	00006597          	auipc	a1,0x6
    80009a72:	29e58593          	addi	a1,a1,670 # 8000fd0c <netconf+0x4>
    80009a76:	01648513          	addi	a0,s1,22
    80009a7a:	ffff7097          	auipc	ra,0xffff7
    80009a7e:	3f8080e7          	jalr	1016(ra) # 80000e72 <memmove>
  memmove(arp->tha, dst_mac, 6);
    80009a82:	864e                	mv	a2,s3
    80009a84:	85d2                	mv	a1,s4
    80009a86:	02048513          	addi	a0,s1,32
    80009a8a:	ffff7097          	auipc	ra,0xffff7
    80009a8e:	3e8080e7          	jalr	1000(ra) # 80000e72 <memmove>
  printf("arp_request: sending arp request!\n");
    80009a92:	00002517          	auipc	a0,0x2
    80009a96:	40650513          	addi	a0,a0,1030 # 8000be98 <etext+0xe98>
    80009a9a:	ffff7097          	auipc	ra,0xffff7
    80009a9e:	b10080e7          	jalr	-1264(ra) # 800005aa <printf>
  transmit_packet(frame, ARP_PACKET_SIZE, PROTO_ARP);
    80009aa2:	6605                	lui	a2,0x1
    80009aa4:	80660613          	addi	a2,a2,-2042 # 806 <_entry-0x7ffff7fa>
    80009aa8:	02a00593          	li	a1,42
    80009aac:	8526                	mv	a0,s1
    80009aae:	ffffe097          	auipc	ra,0xffffe
    80009ab2:	cda080e7          	jalr	-806(ra) # 80007788 <transmit_packet>
  kfree(frame);
    80009ab6:	8526                	mv	a0,s1
    80009ab8:	ffff7097          	auipc	ra,0xffff7
    80009abc:	fe4080e7          	jalr	-28(ra) # 80000a9c <kfree>
    80009ac0:	74a2                	ld	s1,40(sp)
    80009ac2:	69e2                	ld	s3,24(sp)
    80009ac4:	6a42                	ld	s4,16(sp)
}
    80009ac6:	70e2                	ld	ra,56(sp)
    80009ac8:	7442                	ld	s0,48(sp)
    80009aca:	7902                	ld	s2,32(sp)
    80009acc:	6121                	addi	sp,sp,64
    80009ace:	8082                	ret
    printf("ERROR: kalloc\n");
    80009ad0:	00002517          	auipc	a0,0x2
    80009ad4:	9a850513          	addi	a0,a0,-1624 # 8000b478 <etext+0x478>
    80009ad8:	ffff7097          	auipc	ra,0xffff7
    80009adc:	ad2080e7          	jalr	-1326(ra) # 800005aa <printf>
    return;
    80009ae0:	b7dd                	j	80009ac6 <arp_request+0x10e>

0000000080009ae2 <arp_recv>:

void 
arp_recv(struct arp_pkt *pkt)  
{
    80009ae2:	7179                	addi	sp,sp,-48
    80009ae4:	f406                	sd	ra,40(sp)
    80009ae6:	f022                	sd	s0,32(sp)
    80009ae8:	ec26                	sd	s1,24(sp)
    80009aea:	e052                	sd	s4,0(sp)
    80009aec:	1800                	addi	s0,sp,48
    80009aee:	8a2a                	mv	s4,a0
  if (ntohs(pkt->oper) == ARP_OP_REQUEST) {
    80009af0:	00654683          	lbu	a3,6(a0)
    80009af4:	00754783          	lbu	a5,7(a0)
    80009af8:	07a2                	slli	a5,a5,0x8
    80009afa:	00d7e733          	or	a4,a5,a3
    80009afe:	10000693          	li	a3,256
    80009b02:	06d70f63          	beq	a4,a3,80009b80 <arp_recv+0x9e>
    80009b06:	e84a                	sd	s2,16(sp)
    80009b08:	e44e                	sd	s3,8(sp)
    reply->tpa = pkt->spa;
    memmove(reply->sha, netconf.mac_addr, 6);
    memmove(reply->tha, pkt->sha, 6);
    transmit_packet(frame, ARP_PACKET_SIZE, PROTO_ARP);
    kfree(frame);
  } else if (ntohs(pkt->oper) == ARP_OP_REPLY) {
    80009b0a:	2701                	sext.w	a4,a4
    80009b0c:	20000793          	li	a5,512
    80009b10:	84aa                	mv	s1,a0
    80009b12:	01c50993          	addi	s3,a0,28
    arp_insert(pkt->spa, pkt->sha);
  } else {
    for (int i = 0; i < sizeof(struct arp_pkt); i++) {
      printf("%x ", ((uint8*)pkt)[i]);
    80009b16:	00002917          	auipc	s2,0x2
    80009b1a:	3aa90913          	addi	s2,s2,938 # 8000bec0 <etext+0xec0>
  } else if (ntohs(pkt->oper) == ARP_OP_REPLY) {
    80009b1e:	1cf70863          	beq	a4,a5,80009cee <arp_recv+0x20c>
      printf("%x ", ((uint8*)pkt)[i]);
    80009b22:	0004c583          	lbu	a1,0(s1)
    80009b26:	854a                	mv	a0,s2
    80009b28:	ffff7097          	auipc	ra,0xffff7
    80009b2c:	a82080e7          	jalr	-1406(ra) # 800005aa <printf>
    for (int i = 0; i < sizeof(struct arp_pkt); i++) {
    80009b30:	0485                	addi	s1,s1,1
    80009b32:	ff3498e3          	bne	s1,s3,80009b22 <arp_recv+0x40>
    }
    printf("\n");
    80009b36:	00001517          	auipc	a0,0x1
    80009b3a:	4ea50513          	addi	a0,a0,1258 # 8000b020 <etext+0x20>
    80009b3e:	ffff7097          	auipc	ra,0xffff7
    80009b42:	a6c080e7          	jalr	-1428(ra) # 800005aa <printf>
    printf("\tpkt->oper=%x\n", ntohs(pkt->oper));
    80009b46:	006a4703          	lbu	a4,6(s4)
    80009b4a:	007a4783          	lbu	a5,7(s4)
    80009b4e:	07a2                	slli	a5,a5,0x8
    80009b50:	8f5d                	or	a4,a4,a5
    80009b52:	83a1                	srli	a5,a5,0x8
    80009b54:	0087171b          	slliw	a4,a4,0x8
    80009b58:	00e7e5b3          	or	a1,a5,a4
    80009b5c:	15c2                	slli	a1,a1,0x30
    80009b5e:	91c1                	srli	a1,a1,0x30
    80009b60:	00002517          	auipc	a0,0x2
    80009b64:	36850513          	addi	a0,a0,872 # 8000bec8 <etext+0xec8>
    80009b68:	ffff7097          	auipc	ra,0xffff7
    80009b6c:	a42080e7          	jalr	-1470(ra) # 800005aa <printf>
    80009b70:	6942                	ld	s2,16(sp)
    80009b72:	69a2                	ld	s3,8(sp)
  }

}
    80009b74:	70a2                	ld	ra,40(sp)
    80009b76:	7402                	ld	s0,32(sp)
    80009b78:	64e2                	ld	s1,24(sp)
    80009b7a:	6a02                	ld	s4,0(sp)
    80009b7c:	6145                	addi	sp,sp,48
    80009b7e:	8082                	ret
    struct eth_frame *frame = kalloc();
    80009b80:	ffff7097          	auipc	ra,0xffff7
    80009b84:	084080e7          	jalr	132(ra) # 80000c04 <kalloc>
    80009b88:	84aa                	mv	s1,a0
    if (frame == 0) {
    80009b8a:	14050963          	beqz	a0,80009cdc <arp_recv+0x1fa>
    80009b8e:	e84a                	sd	s2,16(sp)
    arp_insert(pkt->spa, pkt->sha);
    80009b90:	008a0913          	addi	s2,s4,8
    80009b94:	00ea4783          	lbu	a5,14(s4)
    80009b98:	00fa4703          	lbu	a4,15(s4)
    80009b9c:	0722                	slli	a4,a4,0x8
    80009b9e:	8f5d                	or	a4,a4,a5
    80009ba0:	010a4783          	lbu	a5,16(s4)
    80009ba4:	07c2                	slli	a5,a5,0x10
    80009ba6:	8fd9                	or	a5,a5,a4
    80009ba8:	011a4503          	lbu	a0,17(s4)
    80009bac:	0562                	slli	a0,a0,0x18
    80009bae:	8d5d                	or	a0,a0,a5
    80009bb0:	85ca                	mv	a1,s2
    80009bb2:	2501                	sext.w	a0,a0
    80009bb4:	00000097          	auipc	ra,0x0
    80009bb8:	d7a080e7          	jalr	-646(ra) # 8000992e <arp_insert>
    if (pkt->tpa == netconf.ip_addr || pkt->tpa == 0xFFFFFFFF) {
    80009bbc:	018a4703          	lbu	a4,24(s4)
    80009bc0:	019a4783          	lbu	a5,25(s4)
    80009bc4:	07a2                	slli	a5,a5,0x8
    80009bc6:	8fd9                	or	a5,a5,a4
    80009bc8:	01aa4703          	lbu	a4,26(s4)
    80009bcc:	0742                	slli	a4,a4,0x10
    80009bce:	8f5d                	or	a4,a4,a5
    80009bd0:	01ba4783          	lbu	a5,27(s4)
    80009bd4:	07e2                	slli	a5,a5,0x18
    80009bd6:	8fd9                	or	a5,a5,a4
    80009bd8:	2781                	sext.w	a5,a5
    80009bda:	00006717          	auipc	a4,0x6
    80009bde:	12e72703          	lw	a4,302(a4) # 8000fd08 <netconf>
    80009be2:	00f70563          	beq	a4,a5,80009bec <arp_recv+0x10a>
    80009be6:	577d                	li	a4,-1
    80009be8:	12e79b63          	bne	a5,a4,80009d1e <arp_recv+0x23c>
    80009bec:	e44e                	sd	s3,8(sp)
      build_eth(frame, pkt->sha, netconf.mac_addr, PROTO_ARP);
    80009bee:	6685                	lui	a3,0x1
    80009bf0:	80668693          	addi	a3,a3,-2042 # 806 <_entry-0x7ffff7fa>
    80009bf4:	00006617          	auipc	a2,0x6
    80009bf8:	11860613          	addi	a2,a2,280 # 8000fd0c <netconf+0x4>
    80009bfc:	85ca                	mv	a1,s2
    80009bfe:	8526                	mv	a0,s1
    80009c00:	fffff097          	auipc	ra,0xfffff
    80009c04:	e98080e7          	jalr	-360(ra) # 80008a98 <build_eth>
    reply->htype = htons(ARP_HTYPE_ETH);
    80009c08:	00048723          	sb	zero,14(s1)
    80009c0c:	4785                	li	a5,1
    80009c0e:	00f487a3          	sb	a5,15(s1)
    reply->ptype = htons(PROTO_IPV4);
    80009c12:	47a1                	li	a5,8
    80009c14:	00f48823          	sb	a5,16(s1)
    80009c18:	000488a3          	sb	zero,17(s1)
    reply->hlen = ARP_HLEN;
    80009c1c:	4999                	li	s3,6
    80009c1e:	01348923          	sb	s3,18(s1)
    reply->plen = ARP_PLEN;
    80009c22:	4791                	li	a5,4
    80009c24:	00f489a3          	sb	a5,19(s1)
    reply->oper = htons(ARP_OP_REPLY);
    80009c28:	00048a23          	sb	zero,20(s1)
    80009c2c:	4789                	li	a5,2
    80009c2e:	00f48aa3          	sb	a5,21(s1)
    reply->spa = netconf.ip_addr;
    80009c32:	00006797          	auipc	a5,0x6
    80009c36:	0d678793          	addi	a5,a5,214 # 8000fd08 <netconf>
    80009c3a:	0007c703          	lbu	a4,0(a5)
    80009c3e:	00e48e23          	sb	a4,28(s1)
    80009c42:	439c                	lw	a5,0(a5)
    80009c44:	0087d71b          	srliw	a4,a5,0x8
    80009c48:	00e48ea3          	sb	a4,29(s1)
    80009c4c:	0107d71b          	srliw	a4,a5,0x10
    80009c50:	00e48f23          	sb	a4,30(s1)
    80009c54:	0187d79b          	srliw	a5,a5,0x18
    80009c58:	00f48fa3          	sb	a5,31(s1)
    reply->tpa = pkt->spa;
    80009c5c:	00ea4703          	lbu	a4,14(s4)
    80009c60:	00fa4783          	lbu	a5,15(s4)
    80009c64:	07a2                	slli	a5,a5,0x8
    80009c66:	8fd9                	or	a5,a5,a4
    80009c68:	010a4703          	lbu	a4,16(s4)
    80009c6c:	0742                	slli	a4,a4,0x10
    80009c6e:	8f5d                	or	a4,a4,a5
    80009c70:	011a4783          	lbu	a5,17(s4)
    80009c74:	07e2                	slli	a5,a5,0x18
    80009c76:	8fd9                	or	a5,a5,a4
    80009c78:	02f48323          	sb	a5,38(s1)
    80009c7c:	0087d713          	srli	a4,a5,0x8
    80009c80:	02e483a3          	sb	a4,39(s1)
    80009c84:	0107d713          	srli	a4,a5,0x10
    80009c88:	02e48423          	sb	a4,40(s1)
    80009c8c:	83e1                	srli	a5,a5,0x18
    80009c8e:	02f484a3          	sb	a5,41(s1)
    memmove(reply->sha, netconf.mac_addr, 6);
    80009c92:	864e                	mv	a2,s3
    80009c94:	00006597          	auipc	a1,0x6
    80009c98:	07858593          	addi	a1,a1,120 # 8000fd0c <netconf+0x4>
    80009c9c:	01648513          	addi	a0,s1,22
    80009ca0:	ffff7097          	auipc	ra,0xffff7
    80009ca4:	1d2080e7          	jalr	466(ra) # 80000e72 <memmove>
    memmove(reply->tha, pkt->sha, 6);
    80009ca8:	864e                	mv	a2,s3
    80009caa:	85ca                	mv	a1,s2
    80009cac:	02048513          	addi	a0,s1,32
    80009cb0:	ffff7097          	auipc	ra,0xffff7
    80009cb4:	1c2080e7          	jalr	450(ra) # 80000e72 <memmove>
    transmit_packet(frame, ARP_PACKET_SIZE, PROTO_ARP);
    80009cb8:	6605                	lui	a2,0x1
    80009cba:	80660613          	addi	a2,a2,-2042 # 806 <_entry-0x7ffff7fa>
    80009cbe:	02a00593          	li	a1,42
    80009cc2:	8526                	mv	a0,s1
    80009cc4:	ffffe097          	auipc	ra,0xffffe
    80009cc8:	ac4080e7          	jalr	-1340(ra) # 80007788 <transmit_packet>
    kfree(frame);
    80009ccc:	8526                	mv	a0,s1
    80009cce:	ffff7097          	auipc	ra,0xffff7
    80009cd2:	dce080e7          	jalr	-562(ra) # 80000a9c <kfree>
    80009cd6:	6942                	ld	s2,16(sp)
    80009cd8:	69a2                	ld	s3,8(sp)
    80009cda:	bd69                	j	80009b74 <arp_recv+0x92>
      printf("ERROR: kalloc\n");
    80009cdc:	00001517          	auipc	a0,0x1
    80009ce0:	79c50513          	addi	a0,a0,1948 # 8000b478 <etext+0x478>
    80009ce4:	ffff7097          	auipc	ra,0xffff7
    80009ce8:	8c6080e7          	jalr	-1850(ra) # 800005aa <printf>
      return;
    80009cec:	b561                	j	80009b74 <arp_recv+0x92>
    arp_insert(pkt->spa, pkt->sha);
    80009cee:	00e54783          	lbu	a5,14(a0)
    80009cf2:	00f54703          	lbu	a4,15(a0)
    80009cf6:	0722                	slli	a4,a4,0x8
    80009cf8:	8f5d                	or	a4,a4,a5
    80009cfa:	01054783          	lbu	a5,16(a0)
    80009cfe:	07c2                	slli	a5,a5,0x10
    80009d00:	8fd9                	or	a5,a5,a4
    80009d02:	01154503          	lbu	a0,17(a0)
    80009d06:	0562                	slli	a0,a0,0x18
    80009d08:	8d5d                	or	a0,a0,a5
    80009d0a:	008a0593          	addi	a1,s4,8
    80009d0e:	2501                	sext.w	a0,a0
    80009d10:	00000097          	auipc	ra,0x0
    80009d14:	c1e080e7          	jalr	-994(ra) # 8000992e <arp_insert>
    80009d18:	6942                	ld	s2,16(sp)
    80009d1a:	69a2                	ld	s3,8(sp)
    80009d1c:	bda1                	j	80009b74 <arp_recv+0x92>
    80009d1e:	6942                	ld	s2,16(sp)
    80009d20:	bd91                	j	80009b74 <arp_recv+0x92>
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
