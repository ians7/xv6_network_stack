
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000d117          	auipc	sp,0xd
    80000004:	d5010113          	addi	sp,sp,-688 # 8000cd50 <stack0>
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
    80000054:	bc078793          	addi	a5,a5,-1088 # 8000cc10 <timer_scratch>
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
    80000066:	93e78793          	addi	a5,a5,-1730 # 800069a0 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff90507>
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
    80000138:	db4080e7          	jalr	-588(ra) # 80002ee8 <either_copyin>
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
    800001a0:	bb450513          	addi	a0,a0,-1100 # 80014d50 <cons>
    800001a4:	00001097          	auipc	ra,0x1
    800001a8:	b72080e7          	jalr	-1166(ra) # 80000d16 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001ac:	00015497          	auipc	s1,0x15
    800001b0:	ba448493          	addi	s1,s1,-1116 # 80014d50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b4:	00015917          	auipc	s2,0x15
    800001b8:	c3490913          	addi	s2,s2,-972 # 80014de8 <cons+0x98>
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
    800001d8:	a22080e7          	jalr	-1502(ra) # 80002bf6 <killed>
    800001dc:	e52d                	bnez	a0,80000246 <consoleread+0xc6>
      sleep(&cons.r, &cons.lock);
    800001de:	85a6                	mv	a1,s1
    800001e0:	854a                	mv	a0,s2
    800001e2:	00002097          	auipc	ra,0x2
    800001e6:	5ee080e7          	jalr	1518(ra) # 800027d0 <sleep>
    while(cons.r == cons.w){
    800001ea:	0984a783          	lw	a5,152(s1)
    800001ee:	09c4a703          	lw	a4,156(s1)
    800001f2:	fcf70de3          	beq	a4,a5,800001cc <consoleread+0x4c>
    800001f6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f8:	00015717          	auipc	a4,0x15
    800001fc:	b5870713          	addi	a4,a4,-1192 # 80014d50 <cons>
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
    8000022e:	c68080e7          	jalr	-920(ra) # 80002e92 <either_copyout>
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
    8000024a:	b0a50513          	addi	a0,a0,-1270 # 80014d50 <cons>
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
    80000274:	b6f72c23          	sw	a5,-1160(a4) # 80014de8 <cons+0x98>
    80000278:	6be2                	ld	s7,24(sp)
    8000027a:	a031                	j	80000286 <consoleread+0x106>
    8000027c:	ec5e                	sd	s7,24(sp)
    8000027e:	bfad                	j	800001f8 <consoleread+0x78>
    80000280:	6be2                	ld	s7,24(sp)
    80000282:	a011                	j	80000286 <consoleread+0x106>
    80000284:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000286:	00015517          	auipc	a0,0x15
    8000028a:	aca50513          	addi	a0,a0,-1334 # 80014d50 <cons>
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
    800002f2:	a6250513          	addi	a0,a0,-1438 # 80014d50 <cons>
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
    80000318:	c2a080e7          	jalr	-982(ra) # 80002f3e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000031c:	00015517          	auipc	a0,0x15
    80000320:	a3450513          	addi	a0,a0,-1484 # 80014d50 <cons>
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
    80000342:	a1270713          	addi	a4,a4,-1518 # 80014d50 <cons>
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
    8000036c:	9e878793          	addi	a5,a5,-1560 # 80014d50 <cons>
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
    80000398:	a547a783          	lw	a5,-1452(a5) # 80014de8 <cons+0x98>
    8000039c:	9f1d                	subw	a4,a4,a5
    8000039e:	08000793          	li	a5,128
    800003a2:	f6f71de3          	bne	a4,a5,8000031c <consoleintr+0x3a>
    800003a6:	a0c9                	j	80000468 <consoleintr+0x186>
    800003a8:	e84a                	sd	s2,16(sp)
    800003aa:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    800003ac:	00015717          	auipc	a4,0x15
    800003b0:	9a470713          	addi	a4,a4,-1628 # 80014d50 <cons>
    800003b4:	0a072783          	lw	a5,160(a4)
    800003b8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003bc:	00015497          	auipc	s1,0x15
    800003c0:	99448493          	addi	s1,s1,-1644 # 80014d50 <cons>
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
    8000040e:	94670713          	addi	a4,a4,-1722 # 80014d50 <cons>
    80000412:	0a072783          	lw	a5,160(a4)
    80000416:	09c72703          	lw	a4,156(a4)
    8000041a:	f0f701e3          	beq	a4,a5,8000031c <consoleintr+0x3a>
      cons.e--;
    8000041e:	37fd                	addiw	a5,a5,-1
    80000420:	00015717          	auipc	a4,0x15
    80000424:	9cf72823          	sw	a5,-1584(a4) # 80014df0 <cons+0xa0>
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
    8000044a:	90a78793          	addi	a5,a5,-1782 # 80014d50 <cons>
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
    8000046c:	98c7a223          	sw	a2,-1660(a5) # 80014dec <cons+0x9c>
        wakeup(&cons.r);
    80000470:	00015517          	auipc	a0,0x15
    80000474:	97850513          	addi	a0,a0,-1672 # 80014de8 <cons+0x98>
    80000478:	00002097          	auipc	ra,0x2
    8000047c:	3bc080e7          	jalr	956(ra) # 80002834 <wakeup>
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
    80000496:	8be50513          	addi	a0,a0,-1858 # 80014d50 <cons>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	7e8080e7          	jalr	2024(ra) # 80000c82 <initlock>

  uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	344080e7          	jalr	836(ra) # 800007e6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800004aa:	0006d797          	auipc	a5,0x6d
    800004ae:	c3e78793          	addi	a5,a5,-962 # 8006d0e8 <devsw>
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
    80000570:	8a07a223          	sw	zero,-1884(a5) # 80014e10 <pr+0x18>
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
    800005a4:	62f72823          	sw	a5,1584(a4) # 8000cbd0 <panicked>
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
    800005ca:	00015d97          	auipc	s11,0x15
    800005ce:	846dad83          	lw	s11,-1978(s11) # 80014e10 <pr+0x18>
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
    8000061e:	7de50513          	addi	a0,a0,2014 # 80014df8 <pr>
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
    800007a6:	65650513          	addi	a0,a0,1622 # 80014df8 <pr>
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
    800007c2:	63a48493          	addi	s1,s1,1594 # 80014df8 <pr>
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
    8000082c:	5f050513          	addi	a0,a0,1520 # 80014e18 <uart_tx_lock>
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
    80000858:	37c7a783          	lw	a5,892(a5) # 8000cbd0 <panicked>
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
    80000892:	34a7b783          	ld	a5,842(a5) # 8000cbd8 <uart_tx_r>
    80000896:	0000c717          	auipc	a4,0xc
    8000089a:	34a73703          	ld	a4,842(a4) # 8000cbe0 <uart_tx_w>
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
    800008c0:	55ca8a93          	addi	s5,s5,1372 # 80014e18 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000c497          	auipc	s1,0xc
    800008c8:	31448493          	addi	s1,s1,788 # 8000cbd8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000c997          	auipc	s3,0xc
    800008d4:	31098993          	addi	s3,s3,784 # 8000cbe0 <uart_tx_w>
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
    800008f6:	f42080e7          	jalr	-190(ra) # 80002834 <wakeup>
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
    80000934:	4e850513          	addi	a0,a0,1256 # 80014e18 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	3de080e7          	jalr	990(ra) # 80000d16 <acquire>
  if(panicked){
    80000940:	0000c797          	auipc	a5,0xc
    80000944:	2907a783          	lw	a5,656(a5) # 8000cbd0 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000c717          	auipc	a4,0xc
    8000094e:	29673703          	ld	a4,662(a4) # 8000cbe0 <uart_tx_w>
    80000952:	0000c797          	auipc	a5,0xc
    80000956:	2867b783          	ld	a5,646(a5) # 8000cbd8 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00014997          	auipc	s3,0x14
    80000962:	4ba98993          	addi	s3,s3,1210 # 80014e18 <uart_tx_lock>
    80000966:	0000c497          	auipc	s1,0xc
    8000096a:	27248493          	addi	s1,s1,626 # 8000cbd8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000c917          	auipc	s2,0xc
    80000972:	27290913          	addi	s2,s2,626 # 8000cbe0 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	e52080e7          	jalr	-430(ra) # 800027d0 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00014497          	auipc	s1,0x14
    80000998:	48448493          	addi	s1,s1,1156 # 80014e18 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000c797          	auipc	a5,0xc
    800009ac:	22e7bc23          	sd	a4,568(a5) # 8000cbe0 <uart_tx_w>
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
    80000a22:	3fa48493          	addi	s1,s1,1018 # 80014e18 <uart_tx_lock>
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
    80000a5e:	3f690913          	addi	s2,s2,1014 # 80014e50 <kmem>
    80000a62:	854a                	mv	a0,s2
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	2b2080e7          	jalr	690(ra) # 80000d16 <acquire>
  uint page_num = PGROUNDDOWN((uint64)pointer_in_page)/PGSIZE;
    80000a6c:	80b1                	srli	s1,s1,0xc
  ref_counter[page_num]++;
    80000a6e:	02049793          	slli	a5,s1,0x20
    80000a72:	01d7d493          	srli	s1,a5,0x1d
    80000a76:	00014797          	auipc	a5,0x14
    80000a7a:	3fa78793          	addi	a5,a5,1018 # 80014e70 <ref_counter>
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
    80000aae:	0006e797          	auipc	a5,0x6e
    80000ab2:	84a78793          	addi	a5,a5,-1974 # 8006e2f8 <end>
    80000ab6:	08f56963          	bltu	a0,a5,80000b48 <kfree+0xac>
    80000aba:	47c5                	li	a5,17
    80000abc:	07ee                	slli	a5,a5,0x1b
    80000abe:	08f57563          	bgeu	a0,a5,80000b48 <kfree+0xac>
    panic("kfree");

  acquire(&kmem.lock);
    80000ac2:	00014517          	auipc	a0,0x14
    80000ac6:	38e50513          	addi	a0,a0,910 # 80014e50 <kmem>
    80000aca:	00000097          	auipc	ra,0x0
    80000ace:	24c080e7          	jalr	588(ra) # 80000d16 <acquire>
  uint64 page_num = PGROUNDDOWN((uint64)pa)/PGSIZE;
    80000ad2:	00c4d793          	srli	a5,s1,0xc
  if (ref_counter[page_num] > 1) {
    80000ad6:	00379693          	slli	a3,a5,0x3
    80000ada:	00014717          	auipc	a4,0x14
    80000ade:	39670713          	addi	a4,a4,918 # 80014e70 <ref_counter>
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
    80000af4:	38070713          	addi	a4,a4,896 # 80014e70 <ref_counter>
    80000af8:	97ba                	add	a5,a5,a4
    80000afa:	0007b023          	sd	zero,0(a5)
  release(&kmem.lock);
    80000afe:	00014917          	auipc	s2,0x14
    80000b02:	35290913          	addi	s2,s2,850 # 80014e50 <kmem>
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
    80000b60:	31468693          	addi	a3,a3,788 # 80014e70 <ref_counter>
    80000b64:	97b6                	add	a5,a5,a3
    80000b66:	177d                	addi	a4,a4,-1
    80000b68:	e398                	sd	a4,0(a5)
    release(&kmem.lock);
    80000b6a:	00014517          	auipc	a0,0x14
    80000b6e:	2e650513          	addi	a0,a0,742 # 80014e50 <kmem>
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
    80000bdc:	27850513          	addi	a0,a0,632 # 80014e50 <kmem>
    80000be0:	00000097          	auipc	ra,0x0
    80000be4:	0a2080e7          	jalr	162(ra) # 80000c82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000be8:	45c5                	li	a1,17
    80000bea:	05ee                	slli	a1,a1,0x1b
    80000bec:	0006d517          	auipc	a0,0x6d
    80000bf0:	70c50513          	addi	a0,a0,1804 # 8006e2f8 <end>
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
    80000c12:	24248493          	addi	s1,s1,578 # 80014e50 <kmem>
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
    80000c2a:	22a50513          	addi	a0,a0,554 # 80014e50 <kmem>
    80000c2e:	ed1c                	sd	a5,24(a0)
  uint64 page_num = PGROUNDDOWN((uint64)r)/PGSIZE;
    80000c30:	00c4d713          	srli	a4,s1,0xc
  ref_counter[page_num] = 1;
    80000c34:	070e                	slli	a4,a4,0x3
    80000c36:	00014797          	auipc	a5,0x14
    80000c3a:	23a78793          	addi	a5,a5,570 # 80014e70 <ref_counter>
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
    80000c6c:	20f73423          	sd	a5,520(a4) # 80014e70 <ref_counter>
  release(&kmem.lock);
    80000c70:	00014517          	auipc	a0,0x14
    80000c74:	1e050513          	addi	a0,a0,480 # 80014e50 <kmem>
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
    80000ff8:	4d4080e7          	jalr	1236(ra) # 800074c8 <transmit_packet>
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
    8000105c:	470080e7          	jalr	1136(ra) # 800074c8 <transmit_packet>
  transmit_packet(pkt2_str, pkt2_len, 0x7a05);
    80001060:	6621                	lui	a2,0x8
    80001062:	a0560613          	addi	a2,a2,-1531 # 7a05 <_entry-0x7fff85fb>
    80001066:	03049593          	slli	a1,s1,0x30
    8000106a:	91c1                	srli	a1,a1,0x30
    8000106c:	00008517          	auipc	a0,0x8
    80001070:	04c50513          	addi	a0,a0,76 # 800090b8 <etext+0xb8>
    80001074:	00006097          	auipc	ra,0x6
    80001078:	454080e7          	jalr	1108(ra) # 800074c8 <transmit_packet>
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
    800010ac:	b4070713          	addi	a4,a4,-1216 # 8000cbe8 <started>
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
    800010e2:	fc6080e7          	jalr	-58(ra) # 800030a4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800010e6:	00006097          	auipc	ra,0x6
    800010ea:	900080e7          	jalr	-1792(ra) # 800069e6 <plicinithart>
  }

  scheduler();        
    800010ee:	00001097          	auipc	ra,0x1
    800010f2:	530080e7          	jalr	1328(ra) # 8000261e <scheduler>
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
    8000115a:	f26080e7          	jalr	-218(ra) # 8000307c <trapinit>
    trapinithart();  // install kernel trap vector
    8000115e:	00002097          	auipc	ra,0x2
    80001162:	f46080e7          	jalr	-186(ra) # 800030a4 <trapinithart>
    plicinit();      // set up interrupt controller
    80001166:	00006097          	auipc	ra,0x6
    8000116a:	864080e7          	jalr	-1948(ra) # 800069ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000116e:	00006097          	auipc	ra,0x6
    80001172:	878080e7          	jalr	-1928(ra) # 800069e6 <plicinithart>
    binit();         // buffer cache
    80001176:	00003097          	auipc	ra,0x3
    8000117a:	8f6080e7          	jalr	-1802(ra) # 80003a6c <binit>
    iinit();         // inode table
    8000117e:	00003097          	auipc	ra,0x3
    80001182:	f86080e7          	jalr	-122(ra) # 80004104 <iinit>
    fileinit();      // file table
    80001186:	00004097          	auipc	ra,0x4
    8000118a:	f58080e7          	jalr	-168(ra) # 800050de <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000118e:	00006097          	auipc	ra,0x6
    80001192:	960080e7          	jalr	-1696(ra) # 80006aee <virtio_disk_init>
    virtio_net_init(); // emulated NIC driver 
    80001196:	00006097          	auipc	ra,0x6
    8000119a:	eca080e7          	jalr	-310(ra) # 80007060 <virtio_net_init>
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
    800011b8:	a2f72a23          	sw	a5,-1484(a4) # 8000cbe8 <started>
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
    800011ce:	a267b783          	ld	a5,-1498(a5) # 8000cbf0 <kernel_pagetable>
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
    800014a0:	74a7ba23          	sd	a0,1876(a5) # 8000cbf0 <kernel_pagetable>
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
    80001d66:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff90d08>
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
    80001da6:	4fe48493          	addi	s1,s1,1278 # 800552a0 <proc>
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
    80001dd0:	0d4a8a93          	addi	s5,s5,212 # 80062ea0 <tickslock>
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
    80001e52:	02250513          	addi	a0,a0,34 # 80054e70 <pid_lock>
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	e2c080e7          	jalr	-468(ra) # 80000c82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001e5e:	00007597          	auipc	a1,0x7
    80001e62:	41a58593          	addi	a1,a1,1050 # 80009278 <etext+0x278>
    80001e66:	00053517          	auipc	a0,0x53
    80001e6a:	02250513          	addi	a0,a0,34 # 80054e88 <wait_lock>
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	e14080e7          	jalr	-492(ra) # 80000c82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e76:	00053497          	auipc	s1,0x53
    80001e7a:	42a48493          	addi	s1,s1,1066 # 800552a0 <proc>
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
    80001ea8:	ffca0a13          	addi	s4,s4,-4 # 80062ea0 <tickslock>
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
    80001f14:	f9050513          	addi	a0,a0,-112 # 80054ea0 <cpus>
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
    80001f3e:	f3670713          	addi	a4,a4,-202 # 80054e70 <pid_lock>
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
    80001f76:	c0e7a783          	lw	a5,-1010(a5) # 8000cb80 <first.1>
    80001f7a:	eb89                	bnez	a5,80001f8c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001f7c:	00001097          	auipc	ra,0x1
    80001f80:	144080e7          	jalr	324(ra) # 800030c0 <usertrapret>
}
    80001f84:	60a2                	ld	ra,8(sp)
    80001f86:	6402                	ld	s0,0(sp)
    80001f88:	0141                	addi	sp,sp,16
    80001f8a:	8082                	ret
    first = 0;
    80001f8c:	0000b797          	auipc	a5,0xb
    80001f90:	be07aa23          	sw	zero,-1036(a5) # 8000cb80 <first.1>
    fsinit(ROOTDEV);
    80001f94:	4505                	li	a0,1
    80001f96:	00002097          	auipc	ra,0x2
    80001f9a:	0ee080e7          	jalr	238(ra) # 80004084 <fsinit>
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
    80001fb0:	ec490913          	addi	s2,s2,-316 # 80054e70 <pid_lock>
    80001fb4:	854a                	mv	a0,s2
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	d60080e7          	jalr	-672(ra) # 80000d16 <acquire>
  pid = nextpid;
    80001fbe:	0000b797          	auipc	a5,0xb
    80001fc2:	bc678793          	addi	a5,a5,-1082 # 8000cb84 <nextpid>
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
    8000213c:	16848493          	addi	s1,s1,360 # 800552a0 <proc>
    80002140:	00061917          	auipc	s2,0x61
    80002144:	d6090913          	addi	s2,s2,-672 # 80062ea0 <tickslock>
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
    80002224:	9ca7bc23          	sd	a0,-1576(a5) # 8000cbf8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002228:	03400613          	li	a2,52
    8000222c:	0000b597          	auipc	a1,0xb
    80002230:	96458593          	addi	a1,a1,-1692 # 8000cb90 <initcode>
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
    8000226e:	882080e7          	jalr	-1918(ra) # 80004aec <namei>
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
    800023da:	d9a080e7          	jalr	-614(ra) # 80005170 <filedup>
    800023de:	00a93023          	sd	a0,0(s2)
    800023e2:	b7e5                	j	800023ca <fork+0xa6>
  np->cwd = idup(p->cwd);
    800023e4:	150ab503          	ld	a0,336(s5)
    800023e8:	00002097          	auipc	ra,0x2
    800023ec:	ee2080e7          	jalr	-286(ra) # 800042ca <idup>
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
    80002418:	a7448493          	addi	s1,s1,-1420 # 80054e88 <wait_lock>
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
    80002576:	bfe080e7          	jalr	-1026(ra) # 80005170 <filedup>
    8000257a:	00a9b023          	sd	a0,0(s3)
    8000257e:	b7e5                	j	80002566 <create_thread+0xfc>
  np->cwd = idup(p->cwd);
    80002580:	150b3503          	ld	a0,336(s6)
    80002584:	00002097          	auipc	ra,0x2
    80002588:	d46080e7          	jalr	-698(ra) # 800042ca <idup>
    8000258c:	14aa3823          	sd	a0,336(s4)
  release(&np->lock);
    80002590:	8552                	mv	a0,s4
    80002592:	fffff097          	auipc	ra,0xfffff
    80002596:	834080e7          	jalr	-1996(ra) # 80000dc6 <release>
  acquire(&wait_lock);
    8000259a:	00053517          	auipc	a0,0x53
    8000259e:	8ee50513          	addi	a0,a0,-1810 # 80054e88 <wait_lock>
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
    800025c6:	8c650513          	addi	a0,a0,-1850 # 80054e88 <wait_lock>
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

000000008000261e <scheduler>:
{
    8000261e:	7139                	addi	sp,sp,-64
    80002620:	fc06                	sd	ra,56(sp)
    80002622:	f822                	sd	s0,48(sp)
    80002624:	f426                	sd	s1,40(sp)
    80002626:	f04a                	sd	s2,32(sp)
    80002628:	ec4e                	sd	s3,24(sp)
    8000262a:	e852                	sd	s4,16(sp)
    8000262c:	e456                	sd	s5,8(sp)
    8000262e:	e05a                	sd	s6,0(sp)
    80002630:	0080                	addi	s0,sp,64
    80002632:	8792                	mv	a5,tp
  int id = r_tp();
    80002634:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002636:	00779a93          	slli	s5,a5,0x7
    8000263a:	00053717          	auipc	a4,0x53
    8000263e:	83670713          	addi	a4,a4,-1994 # 80054e70 <pid_lock>
    80002642:	9756                	add	a4,a4,s5
    80002644:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002648:	00053717          	auipc	a4,0x53
    8000264c:	86070713          	addi	a4,a4,-1952 # 80054ea8 <cpus+0x8>
    80002650:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80002652:	498d                	li	s3,3
        p->state = RUNNING;
    80002654:	4b11                	li	s6,4
        c->proc = p;
    80002656:	079e                	slli	a5,a5,0x7
    80002658:	00053a17          	auipc	s4,0x53
    8000265c:	818a0a13          	addi	s4,s4,-2024 # 80054e70 <pid_lock>
    80002660:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002662:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002666:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000266a:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000266e:	00053497          	auipc	s1,0x53
    80002672:	c3248493          	addi	s1,s1,-974 # 800552a0 <proc>
    80002676:	00061917          	auipc	s2,0x61
    8000267a:	82a90913          	addi	s2,s2,-2006 # 80062ea0 <tickslock>
    8000267e:	a811                	j	80002692 <scheduler+0x74>
      release(&p->lock);
    80002680:	8526                	mv	a0,s1
    80002682:	ffffe097          	auipc	ra,0xffffe
    80002686:	744080e7          	jalr	1860(ra) # 80000dc6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000268a:	37048493          	addi	s1,s1,880
    8000268e:	fd248ae3          	beq	s1,s2,80002662 <scheduler+0x44>
      acquire(&p->lock);
    80002692:	8526                	mv	a0,s1
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	682080e7          	jalr	1666(ra) # 80000d16 <acquire>
      if(p->state == RUNNABLE) {
    8000269c:	4c9c                	lw	a5,24(s1)
    8000269e:	ff3791e3          	bne	a5,s3,80002680 <scheduler+0x62>
        p->state = RUNNING;
    800026a2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800026a6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800026aa:	06048593          	addi	a1,s1,96
    800026ae:	8556                	mv	a0,s5
    800026b0:	00001097          	auipc	ra,0x1
    800026b4:	962080e7          	jalr	-1694(ra) # 80003012 <swtch>
        c->proc = 0;
    800026b8:	020a3823          	sd	zero,48(s4)
    800026bc:	b7d1                	j	80002680 <scheduler+0x62>

00000000800026be <sched>:
{
    800026be:	7179                	addi	sp,sp,-48
    800026c0:	f406                	sd	ra,40(sp)
    800026c2:	f022                	sd	s0,32(sp)
    800026c4:	ec26                	sd	s1,24(sp)
    800026c6:	e84a                	sd	s2,16(sp)
    800026c8:	e44e                	sd	s3,8(sp)
    800026ca:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	856080e7          	jalr	-1962(ra) # 80001f22 <myproc>
    800026d4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800026d6:	ffffe097          	auipc	ra,0xffffe
    800026da:	5c6080e7          	jalr	1478(ra) # 80000c9c <holding>
    800026de:	c93d                	beqz	a0,80002754 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800026e0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800026e2:	2781                	sext.w	a5,a5
    800026e4:	079e                	slli	a5,a5,0x7
    800026e6:	00052717          	auipc	a4,0x52
    800026ea:	78a70713          	addi	a4,a4,1930 # 80054e70 <pid_lock>
    800026ee:	97ba                	add	a5,a5,a4
    800026f0:	0a87a703          	lw	a4,168(a5)
    800026f4:	4785                	li	a5,1
    800026f6:	06f71763          	bne	a4,a5,80002764 <sched+0xa6>
  if(p->state == RUNNING)
    800026fa:	4c98                	lw	a4,24(s1)
    800026fc:	4791                	li	a5,4
    800026fe:	06f70b63          	beq	a4,a5,80002774 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002702:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002706:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002708:	efb5                	bnez	a5,80002784 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000270a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000270c:	00052917          	auipc	s2,0x52
    80002710:	76490913          	addi	s2,s2,1892 # 80054e70 <pid_lock>
    80002714:	2781                	sext.w	a5,a5
    80002716:	079e                	slli	a5,a5,0x7
    80002718:	97ca                	add	a5,a5,s2
    8000271a:	0ac7a983          	lw	s3,172(a5)
    8000271e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002720:	2781                	sext.w	a5,a5
    80002722:	079e                	slli	a5,a5,0x7
    80002724:	00052597          	auipc	a1,0x52
    80002728:	78458593          	addi	a1,a1,1924 # 80054ea8 <cpus+0x8>
    8000272c:	95be                	add	a1,a1,a5
    8000272e:	06048513          	addi	a0,s1,96
    80002732:	00001097          	auipc	ra,0x1
    80002736:	8e0080e7          	jalr	-1824(ra) # 80003012 <swtch>
    8000273a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000273c:	2781                	sext.w	a5,a5
    8000273e:	079e                	slli	a5,a5,0x7
    80002740:	993e                	add	s2,s2,a5
    80002742:	0b392623          	sw	s3,172(s2)
}
    80002746:	70a2                	ld	ra,40(sp)
    80002748:	7402                	ld	s0,32(sp)
    8000274a:	64e2                	ld	s1,24(sp)
    8000274c:	6942                	ld	s2,16(sp)
    8000274e:	69a2                	ld	s3,8(sp)
    80002750:	6145                	addi	sp,sp,48
    80002752:	8082                	ret
    panic("sched p->lock");
    80002754:	00007517          	auipc	a0,0x7
    80002758:	b6c50513          	addi	a0,a0,-1172 # 800092c0 <etext+0x2c0>
    8000275c:	ffffe097          	auipc	ra,0xffffe
    80002760:	e04080e7          	jalr	-508(ra) # 80000560 <panic>
    panic("sched locks");
    80002764:	00007517          	auipc	a0,0x7
    80002768:	b6c50513          	addi	a0,a0,-1172 # 800092d0 <etext+0x2d0>
    8000276c:	ffffe097          	auipc	ra,0xffffe
    80002770:	df4080e7          	jalr	-524(ra) # 80000560 <panic>
    panic("sched running");
    80002774:	00007517          	auipc	a0,0x7
    80002778:	b6c50513          	addi	a0,a0,-1172 # 800092e0 <etext+0x2e0>
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	de4080e7          	jalr	-540(ra) # 80000560 <panic>
    panic("sched interruptible");
    80002784:	00007517          	auipc	a0,0x7
    80002788:	b6c50513          	addi	a0,a0,-1172 # 800092f0 <etext+0x2f0>
    8000278c:	ffffe097          	auipc	ra,0xffffe
    80002790:	dd4080e7          	jalr	-556(ra) # 80000560 <panic>

0000000080002794 <yield>:
{
    80002794:	1101                	addi	sp,sp,-32
    80002796:	ec06                	sd	ra,24(sp)
    80002798:	e822                	sd	s0,16(sp)
    8000279a:	e426                	sd	s1,8(sp)
    8000279c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000279e:	fffff097          	auipc	ra,0xfffff
    800027a2:	784080e7          	jalr	1924(ra) # 80001f22 <myproc>
    800027a6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800027a8:	ffffe097          	auipc	ra,0xffffe
    800027ac:	56e080e7          	jalr	1390(ra) # 80000d16 <acquire>
  p->state = RUNNABLE;
    800027b0:	478d                	li	a5,3
    800027b2:	cc9c                	sw	a5,24(s1)
  sched();
    800027b4:	00000097          	auipc	ra,0x0
    800027b8:	f0a080e7          	jalr	-246(ra) # 800026be <sched>
  release(&p->lock);
    800027bc:	8526                	mv	a0,s1
    800027be:	ffffe097          	auipc	ra,0xffffe
    800027c2:	608080e7          	jalr	1544(ra) # 80000dc6 <release>
}
    800027c6:	60e2                	ld	ra,24(sp)
    800027c8:	6442                	ld	s0,16(sp)
    800027ca:	64a2                	ld	s1,8(sp)
    800027cc:	6105                	addi	sp,sp,32
    800027ce:	8082                	ret

00000000800027d0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800027d0:	7179                	addi	sp,sp,-48
    800027d2:	f406                	sd	ra,40(sp)
    800027d4:	f022                	sd	s0,32(sp)
    800027d6:	ec26                	sd	s1,24(sp)
    800027d8:	e84a                	sd	s2,16(sp)
    800027da:	e44e                	sd	s3,8(sp)
    800027dc:	1800                	addi	s0,sp,48
    800027de:	89aa                	mv	s3,a0
    800027e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027e2:	fffff097          	auipc	ra,0xfffff
    800027e6:	740080e7          	jalr	1856(ra) # 80001f22 <myproc>
    800027ea:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800027ec:	ffffe097          	auipc	ra,0xffffe
    800027f0:	52a080e7          	jalr	1322(ra) # 80000d16 <acquire>
  release(lk);
    800027f4:	854a                	mv	a0,s2
    800027f6:	ffffe097          	auipc	ra,0xffffe
    800027fa:	5d0080e7          	jalr	1488(ra) # 80000dc6 <release>

  // Go to sleep.
  p->chan = chan;
    800027fe:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002802:	4789                	li	a5,2
    80002804:	cc9c                	sw	a5,24(s1)

  sched();
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	eb8080e7          	jalr	-328(ra) # 800026be <sched>

  // Tidy up.
  p->chan = 0;
    8000280e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002812:	8526                	mv	a0,s1
    80002814:	ffffe097          	auipc	ra,0xffffe
    80002818:	5b2080e7          	jalr	1458(ra) # 80000dc6 <release>
  acquire(lk);
    8000281c:	854a                	mv	a0,s2
    8000281e:	ffffe097          	auipc	ra,0xffffe
    80002822:	4f8080e7          	jalr	1272(ra) # 80000d16 <acquire>
}
    80002826:	70a2                	ld	ra,40(sp)
    80002828:	7402                	ld	s0,32(sp)
    8000282a:	64e2                	ld	s1,24(sp)
    8000282c:	6942                	ld	s2,16(sp)
    8000282e:	69a2                	ld	s3,8(sp)
    80002830:	6145                	addi	sp,sp,48
    80002832:	8082                	ret

0000000080002834 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002834:	7139                	addi	sp,sp,-64
    80002836:	fc06                	sd	ra,56(sp)
    80002838:	f822                	sd	s0,48(sp)
    8000283a:	f426                	sd	s1,40(sp)
    8000283c:	f04a                	sd	s2,32(sp)
    8000283e:	ec4e                	sd	s3,24(sp)
    80002840:	e852                	sd	s4,16(sp)
    80002842:	e456                	sd	s5,8(sp)
    80002844:	0080                	addi	s0,sp,64
    80002846:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002848:	00053497          	auipc	s1,0x53
    8000284c:	a5848493          	addi	s1,s1,-1448 # 800552a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002850:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002852:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002854:	00060917          	auipc	s2,0x60
    80002858:	64c90913          	addi	s2,s2,1612 # 80062ea0 <tickslock>
    8000285c:	a811                	j	80002870 <wakeup+0x3c>
      }
      release(&p->lock);
    8000285e:	8526                	mv	a0,s1
    80002860:	ffffe097          	auipc	ra,0xffffe
    80002864:	566080e7          	jalr	1382(ra) # 80000dc6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002868:	37048493          	addi	s1,s1,880
    8000286c:	03248663          	beq	s1,s2,80002898 <wakeup+0x64>
    if(p != myproc()){
    80002870:	fffff097          	auipc	ra,0xfffff
    80002874:	6b2080e7          	jalr	1714(ra) # 80001f22 <myproc>
    80002878:	fea488e3          	beq	s1,a0,80002868 <wakeup+0x34>
      acquire(&p->lock);
    8000287c:	8526                	mv	a0,s1
    8000287e:	ffffe097          	auipc	ra,0xffffe
    80002882:	498080e7          	jalr	1176(ra) # 80000d16 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002886:	4c9c                	lw	a5,24(s1)
    80002888:	fd379be3          	bne	a5,s3,8000285e <wakeup+0x2a>
    8000288c:	709c                	ld	a5,32(s1)
    8000288e:	fd4798e3          	bne	a5,s4,8000285e <wakeup+0x2a>
        p->state = RUNNABLE;
    80002892:	0154ac23          	sw	s5,24(s1)
    80002896:	b7e1                	j	8000285e <wakeup+0x2a>
    }
  }
}
    80002898:	70e2                	ld	ra,56(sp)
    8000289a:	7442                	ld	s0,48(sp)
    8000289c:	74a2                	ld	s1,40(sp)
    8000289e:	7902                	ld	s2,32(sp)
    800028a0:	69e2                	ld	s3,24(sp)
    800028a2:	6a42                	ld	s4,16(sp)
    800028a4:	6aa2                	ld	s5,8(sp)
    800028a6:	6121                	addi	sp,sp,64
    800028a8:	8082                	ret

00000000800028aa <reparent>:
{
    800028aa:	7179                	addi	sp,sp,-48
    800028ac:	f406                	sd	ra,40(sp)
    800028ae:	f022                	sd	s0,32(sp)
    800028b0:	ec26                	sd	s1,24(sp)
    800028b2:	e84a                	sd	s2,16(sp)
    800028b4:	e44e                	sd	s3,8(sp)
    800028b6:	e052                	sd	s4,0(sp)
    800028b8:	1800                	addi	s0,sp,48
    800028ba:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800028bc:	00053497          	auipc	s1,0x53
    800028c0:	9e448493          	addi	s1,s1,-1564 # 800552a0 <proc>
      pp->parent = initproc;
    800028c4:	0000aa17          	auipc	s4,0xa
    800028c8:	334a0a13          	addi	s4,s4,820 # 8000cbf8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800028cc:	00060997          	auipc	s3,0x60
    800028d0:	5d498993          	addi	s3,s3,1492 # 80062ea0 <tickslock>
    800028d4:	a029                	j	800028de <reparent+0x34>
    800028d6:	37048493          	addi	s1,s1,880
    800028da:	01348d63          	beq	s1,s3,800028f4 <reparent+0x4a>
    if(pp->parent == p){
    800028de:	7c9c                	ld	a5,56(s1)
    800028e0:	ff279be3          	bne	a5,s2,800028d6 <reparent+0x2c>
      pp->parent = initproc;
    800028e4:	000a3503          	ld	a0,0(s4)
    800028e8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800028ea:	00000097          	auipc	ra,0x0
    800028ee:	f4a080e7          	jalr	-182(ra) # 80002834 <wakeup>
    800028f2:	b7d5                	j	800028d6 <reparent+0x2c>
}
    800028f4:	70a2                	ld	ra,40(sp)
    800028f6:	7402                	ld	s0,32(sp)
    800028f8:	64e2                	ld	s1,24(sp)
    800028fa:	6942                	ld	s2,16(sp)
    800028fc:	69a2                	ld	s3,8(sp)
    800028fe:	6a02                	ld	s4,0(sp)
    80002900:	6145                	addi	sp,sp,48
    80002902:	8082                	ret

0000000080002904 <thread_exit>:
uint64 thread_exit(uint64 status) {
    80002904:	7179                	addi	sp,sp,-48
    80002906:	f406                	sd	ra,40(sp)
    80002908:	f022                	sd	s0,32(sp)
    8000290a:	ec26                	sd	s1,24(sp)
    8000290c:	e84a                	sd	s2,16(sp)
    8000290e:	e44e                	sd	s3,8(sp)
    80002910:	e052                	sd	s4,0(sp)
    80002912:	1800                	addi	s0,sp,48
    80002914:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002916:	fffff097          	auipc	ra,0xfffff
    8000291a:	60c080e7          	jalr	1548(ra) # 80001f22 <myproc>
    8000291e:	89aa                	mv	s3,a0
  if(p == initproc)
    80002920:	0000a797          	auipc	a5,0xa
    80002924:	2d87b783          	ld	a5,728(a5) # 8000cbf8 <initproc>
    80002928:	0d050493          	addi	s1,a0,208
    8000292c:	15050913          	addi	s2,a0,336
    80002930:	00a79d63          	bne	a5,a0,8000294a <thread_exit+0x46>
    panic("init exiting");
    80002934:	00007517          	auipc	a0,0x7
    80002938:	9d450513          	addi	a0,a0,-1580 # 80009308 <etext+0x308>
    8000293c:	ffffe097          	auipc	ra,0xffffe
    80002940:	c24080e7          	jalr	-988(ra) # 80000560 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002944:	04a1                	addi	s1,s1,8
    80002946:	01248b63          	beq	s1,s2,8000295c <thread_exit+0x58>
    if(p->ofile[fd]){
    8000294a:	6088                	ld	a0,0(s1)
    8000294c:	dd65                	beqz	a0,80002944 <thread_exit+0x40>
      fileclose(f);
    8000294e:	00003097          	auipc	ra,0x3
    80002952:	874080e7          	jalr	-1932(ra) # 800051c2 <fileclose>
      p->ofile[fd] = 0;
    80002956:	0004b023          	sd	zero,0(s1)
    8000295a:	b7ed                	j	80002944 <thread_exit+0x40>
  begin_op();
    8000295c:	00002097          	auipc	ra,0x2
    80002960:	396080e7          	jalr	918(ra) # 80004cf2 <begin_op>
  iput(p->cwd);
    80002964:	1509b503          	ld	a0,336(s3)
    80002968:	00002097          	auipc	ra,0x2
    8000296c:	b5e080e7          	jalr	-1186(ra) # 800044c6 <iput>
  end_op();
    80002970:	00002097          	auipc	ra,0x2
    80002974:	3fc080e7          	jalr	1020(ra) # 80004d6c <end_op>
  p->cwd = 0;
    80002978:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000297c:	00052497          	auipc	s1,0x52
    80002980:	50c48493          	addi	s1,s1,1292 # 80054e88 <wait_lock>
    80002984:	8526                	mv	a0,s1
    80002986:	ffffe097          	auipc	ra,0xffffe
    8000298a:	390080e7          	jalr	912(ra) # 80000d16 <acquire>
  reparent(p);
    8000298e:	854e                	mv	a0,s3
    80002990:	00000097          	auipc	ra,0x0
    80002994:	f1a080e7          	jalr	-230(ra) # 800028aa <reparent>
  wakeup(p->parent);
    80002998:	0389b503          	ld	a0,56(s3)
    8000299c:	00000097          	auipc	ra,0x0
    800029a0:	e98080e7          	jalr	-360(ra) # 80002834 <wakeup>
  acquire(&p->lock);
    800029a4:	854e                	mv	a0,s3
    800029a6:	ffffe097          	auipc	ra,0xffffe
    800029aa:	370080e7          	jalr	880(ra) # 80000d16 <acquire>
  p->xstate = status;
    800029ae:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800029b2:	4795                	li	a5,5
    800029b4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800029b8:	8526                	mv	a0,s1
    800029ba:	ffffe097          	auipc	ra,0xffffe
    800029be:	40c080e7          	jalr	1036(ra) # 80000dc6 <release>
  sched();
    800029c2:	00000097          	auipc	ra,0x0
    800029c6:	cfc080e7          	jalr	-772(ra) # 800026be <sched>
  panic("zombie exit");
    800029ca:	00007517          	auipc	a0,0x7
    800029ce:	94e50513          	addi	a0,a0,-1714 # 80009318 <etext+0x318>
    800029d2:	ffffe097          	auipc	ra,0xffffe
    800029d6:	b8e080e7          	jalr	-1138(ra) # 80000560 <panic>

00000000800029da <exit>:
{
    800029da:	711d                	addi	sp,sp,-96
    800029dc:	ec86                	sd	ra,88(sp)
    800029de:	e8a2                	sd	s0,80(sp)
    800029e0:	e4a6                	sd	s1,72(sp)
    800029e2:	e0ca                	sd	s2,64(sp)
    800029e4:	fc4e                	sd	s3,56(sp)
    800029e6:	f852                	sd	s4,48(sp)
    800029e8:	f456                	sd	s5,40(sp)
    800029ea:	f05a                	sd	s6,32(sp)
    800029ec:	ec5e                	sd	s7,24(sp)
    800029ee:	e862                	sd	s8,16(sp)
    800029f0:	e466                	sd	s9,8(sp)
    800029f2:	1080                	addi	s0,sp,96
    800029f4:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800029f6:	fffff097          	auipc	ra,0xfffff
    800029fa:	52c080e7          	jalr	1324(ra) # 80001f22 <myproc>
    800029fe:	8c2a                	mv	s8,a0
  if (p->is_thread) {
    80002a00:	16852783          	lw	a5,360(a0)
    80002a04:	cfc9                	beqz	a5,80002a9e <exit+0xc4>
    struct proc *parent = p->parent;
    80002a06:	03853b03          	ld	s6,56(a0)
    for (int i = 0; i < MAX_THREADS; i++) {
    80002a0a:	170b0a13          	addi	s4,s6,368
    80002a0e:	370b0b13          	addi	s6,s6,880
      acquire(&wait_lock);
    80002a12:	00052a97          	auipc	s5,0x52
    80002a16:	476a8a93          	addi	s5,s5,1142 # 80054e88 <wait_lock>
      infant->state = ZOMBIE;
    80002a1a:	4c95                	li	s9,5
    80002a1c:	a885                	j	80002a8c <exit+0xb2>
          fileclose(f);
    80002a1e:	00002097          	auipc	ra,0x2
    80002a22:	7a4080e7          	jalr	1956(ra) # 800051c2 <fileclose>
          infant->ofile[fd] = 0;
    80002a26:	0004b023          	sd	zero,0(s1)
      for(int fd = 0; fd < NOFILE; fd++){
    80002a2a:	04a1                	addi	s1,s1,8
    80002a2c:	01248563          	beq	s1,s2,80002a36 <exit+0x5c>
        if(infant->ofile[fd]){
    80002a30:	6088                	ld	a0,0(s1)
    80002a32:	f575                	bnez	a0,80002a1e <exit+0x44>
    80002a34:	bfdd                	j	80002a2a <exit+0x50>
      begin_op();
    80002a36:	00002097          	auipc	ra,0x2
    80002a3a:	2bc080e7          	jalr	700(ra) # 80004cf2 <begin_op>
      iput(infant->cwd);
    80002a3e:	1509b503          	ld	a0,336(s3)
    80002a42:	00002097          	auipc	ra,0x2
    80002a46:	a84080e7          	jalr	-1404(ra) # 800044c6 <iput>
      end_op();
    80002a4a:	00002097          	auipc	ra,0x2
    80002a4e:	322080e7          	jalr	802(ra) # 80004d6c <end_op>
      infant->cwd = 0;
    80002a52:	1409b823          	sd	zero,336(s3)
      acquire(&wait_lock);
    80002a56:	8556                	mv	a0,s5
    80002a58:	ffffe097          	auipc	ra,0xffffe
    80002a5c:	2be080e7          	jalr	702(ra) # 80000d16 <acquire>
      acquire(&infant->lock);
    80002a60:	854e                	mv	a0,s3
    80002a62:	ffffe097          	auipc	ra,0xffffe
    80002a66:	2b4080e7          	jalr	692(ra) # 80000d16 <acquire>
      infant->xstate = status;
    80002a6a:	0379a623          	sw	s7,44(s3)
      infant->state = ZOMBIE;
    80002a6e:	0199ac23          	sw	s9,24(s3)
      release(&infant->lock);
    80002a72:	854e                	mv	a0,s3
    80002a74:	ffffe097          	auipc	ra,0xffffe
    80002a78:	352080e7          	jalr	850(ra) # 80000dc6 <release>
      release(&wait_lock);
    80002a7c:	8556                	mv	a0,s5
    80002a7e:	ffffe097          	auipc	ra,0xffffe
    80002a82:	348080e7          	jalr	840(ra) # 80000dc6 <release>
    for (int i = 0; i < MAX_THREADS; i++) {
    80002a86:	0a21                	addi	s4,s4,8
    80002a88:	016a0b63          	beq	s4,s6,80002a9e <exit+0xc4>
      struct proc *infant = parent->infant_threads[i];
    80002a8c:	000a3983          	ld	s3,0(s4)
      if (infant == 0) 
    80002a90:	fe098be3          	beqz	s3,80002a86 <exit+0xac>
    80002a94:	0d098493          	addi	s1,s3,208
    80002a98:	15098913          	addi	s2,s3,336
    80002a9c:	bf51                	j	80002a30 <exit+0x56>
  if(p == initproc)
    80002a9e:	0000a797          	auipc	a5,0xa
    80002aa2:	15a7b783          	ld	a5,346(a5) # 8000cbf8 <initproc>
    80002aa6:	0d0c0493          	addi	s1,s8,208
    80002aaa:	150c0913          	addi	s2,s8,336
    80002aae:	01879d63          	bne	a5,s8,80002ac8 <exit+0xee>
    panic("init exiting");
    80002ab2:	00007517          	auipc	a0,0x7
    80002ab6:	85650513          	addi	a0,a0,-1962 # 80009308 <etext+0x308>
    80002aba:	ffffe097          	auipc	ra,0xffffe
    80002abe:	aa6080e7          	jalr	-1370(ra) # 80000560 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002ac2:	04a1                	addi	s1,s1,8
    80002ac4:	01248b63          	beq	s1,s2,80002ada <exit+0x100>
    if(p->ofile[fd]){
    80002ac8:	6088                	ld	a0,0(s1)
    80002aca:	dd65                	beqz	a0,80002ac2 <exit+0xe8>
      fileclose(f);
    80002acc:	00002097          	auipc	ra,0x2
    80002ad0:	6f6080e7          	jalr	1782(ra) # 800051c2 <fileclose>
      p->ofile[fd] = 0;
    80002ad4:	0004b023          	sd	zero,0(s1)
    80002ad8:	b7ed                	j	80002ac2 <exit+0xe8>
  begin_op();
    80002ada:	00002097          	auipc	ra,0x2
    80002ade:	218080e7          	jalr	536(ra) # 80004cf2 <begin_op>
  iput(p->cwd);
    80002ae2:	150c3503          	ld	a0,336(s8)
    80002ae6:	00002097          	auipc	ra,0x2
    80002aea:	9e0080e7          	jalr	-1568(ra) # 800044c6 <iput>
  end_op();
    80002aee:	00002097          	auipc	ra,0x2
    80002af2:	27e080e7          	jalr	638(ra) # 80004d6c <end_op>
  p->cwd = 0;
    80002af6:	140c3823          	sd	zero,336(s8)
  acquire(&wait_lock);
    80002afa:	00052497          	auipc	s1,0x52
    80002afe:	38e48493          	addi	s1,s1,910 # 80054e88 <wait_lock>
    80002b02:	8526                	mv	a0,s1
    80002b04:	ffffe097          	auipc	ra,0xffffe
    80002b08:	212080e7          	jalr	530(ra) # 80000d16 <acquire>
  reparent(p);
    80002b0c:	8562                	mv	a0,s8
    80002b0e:	00000097          	auipc	ra,0x0
    80002b12:	d9c080e7          	jalr	-612(ra) # 800028aa <reparent>
  wakeup(p->parent);
    80002b16:	038c3503          	ld	a0,56(s8)
    80002b1a:	00000097          	auipc	ra,0x0
    80002b1e:	d1a080e7          	jalr	-742(ra) # 80002834 <wakeup>
  acquire(&p->lock);
    80002b22:	8562                	mv	a0,s8
    80002b24:	ffffe097          	auipc	ra,0xffffe
    80002b28:	1f2080e7          	jalr	498(ra) # 80000d16 <acquire>
  p->xstate = status;
    80002b2c:	037c2623          	sw	s7,44(s8)
  p->state = ZOMBIE;
    80002b30:	4795                	li	a5,5
    80002b32:	00fc2c23          	sw	a5,24(s8)
  release(&wait_lock);
    80002b36:	8526                	mv	a0,s1
    80002b38:	ffffe097          	auipc	ra,0xffffe
    80002b3c:	28e080e7          	jalr	654(ra) # 80000dc6 <release>
  sched();
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	b7e080e7          	jalr	-1154(ra) # 800026be <sched>
  panic("zombie exit");
    80002b48:	00006517          	auipc	a0,0x6
    80002b4c:	7d050513          	addi	a0,a0,2000 # 80009318 <etext+0x318>
    80002b50:	ffffe097          	auipc	ra,0xffffe
    80002b54:	a10080e7          	jalr	-1520(ra) # 80000560 <panic>

0000000080002b58 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002b58:	7179                	addi	sp,sp,-48
    80002b5a:	f406                	sd	ra,40(sp)
    80002b5c:	f022                	sd	s0,32(sp)
    80002b5e:	ec26                	sd	s1,24(sp)
    80002b60:	e84a                	sd	s2,16(sp)
    80002b62:	e44e                	sd	s3,8(sp)
    80002b64:	1800                	addi	s0,sp,48
    80002b66:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002b68:	00052497          	auipc	s1,0x52
    80002b6c:	73848493          	addi	s1,s1,1848 # 800552a0 <proc>
    80002b70:	00060997          	auipc	s3,0x60
    80002b74:	33098993          	addi	s3,s3,816 # 80062ea0 <tickslock>
    acquire(&p->lock);
    80002b78:	8526                	mv	a0,s1
    80002b7a:	ffffe097          	auipc	ra,0xffffe
    80002b7e:	19c080e7          	jalr	412(ra) # 80000d16 <acquire>
    if(p->pid == pid){
    80002b82:	589c                	lw	a5,48(s1)
    80002b84:	01278d63          	beq	a5,s2,80002b9e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002b88:	8526                	mv	a0,s1
    80002b8a:	ffffe097          	auipc	ra,0xffffe
    80002b8e:	23c080e7          	jalr	572(ra) # 80000dc6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002b92:	37048493          	addi	s1,s1,880
    80002b96:	ff3491e3          	bne	s1,s3,80002b78 <kill+0x20>
  }
  return -1;
    80002b9a:	557d                	li	a0,-1
    80002b9c:	a829                	j	80002bb6 <kill+0x5e>
      p->killed = 1;
    80002b9e:	4785                	li	a5,1
    80002ba0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002ba2:	4c98                	lw	a4,24(s1)
    80002ba4:	4789                	li	a5,2
    80002ba6:	00f70f63          	beq	a4,a5,80002bc4 <kill+0x6c>
      release(&p->lock);
    80002baa:	8526                	mv	a0,s1
    80002bac:	ffffe097          	auipc	ra,0xffffe
    80002bb0:	21a080e7          	jalr	538(ra) # 80000dc6 <release>
      return 0;
    80002bb4:	4501                	li	a0,0
}
    80002bb6:	70a2                	ld	ra,40(sp)
    80002bb8:	7402                	ld	s0,32(sp)
    80002bba:	64e2                	ld	s1,24(sp)
    80002bbc:	6942                	ld	s2,16(sp)
    80002bbe:	69a2                	ld	s3,8(sp)
    80002bc0:	6145                	addi	sp,sp,48
    80002bc2:	8082                	ret
        p->state = RUNNABLE;
    80002bc4:	478d                	li	a5,3
    80002bc6:	cc9c                	sw	a5,24(s1)
    80002bc8:	b7cd                	j	80002baa <kill+0x52>

0000000080002bca <setkilled>:

void
setkilled(struct proc *p)
{
    80002bca:	1101                	addi	sp,sp,-32
    80002bcc:	ec06                	sd	ra,24(sp)
    80002bce:	e822                	sd	s0,16(sp)
    80002bd0:	e426                	sd	s1,8(sp)
    80002bd2:	1000                	addi	s0,sp,32
    80002bd4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002bd6:	ffffe097          	auipc	ra,0xffffe
    80002bda:	140080e7          	jalr	320(ra) # 80000d16 <acquire>
  p->killed = 1;
    80002bde:	4785                	li	a5,1
    80002be0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002be2:	8526                	mv	a0,s1
    80002be4:	ffffe097          	auipc	ra,0xffffe
    80002be8:	1e2080e7          	jalr	482(ra) # 80000dc6 <release>
}
    80002bec:	60e2                	ld	ra,24(sp)
    80002bee:	6442                	ld	s0,16(sp)
    80002bf0:	64a2                	ld	s1,8(sp)
    80002bf2:	6105                	addi	sp,sp,32
    80002bf4:	8082                	ret

0000000080002bf6 <killed>:

int
killed(struct proc *p)
{
    80002bf6:	1101                	addi	sp,sp,-32
    80002bf8:	ec06                	sd	ra,24(sp)
    80002bfa:	e822                	sd	s0,16(sp)
    80002bfc:	e426                	sd	s1,8(sp)
    80002bfe:	e04a                	sd	s2,0(sp)
    80002c00:	1000                	addi	s0,sp,32
    80002c02:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002c04:	ffffe097          	auipc	ra,0xffffe
    80002c08:	112080e7          	jalr	274(ra) # 80000d16 <acquire>
  k = p->killed;
    80002c0c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002c10:	8526                	mv	a0,s1
    80002c12:	ffffe097          	auipc	ra,0xffffe
    80002c16:	1b4080e7          	jalr	436(ra) # 80000dc6 <release>
  return k;
}
    80002c1a:	854a                	mv	a0,s2
    80002c1c:	60e2                	ld	ra,24(sp)
    80002c1e:	6442                	ld	s0,16(sp)
    80002c20:	64a2                	ld	s1,8(sp)
    80002c22:	6902                	ld	s2,0(sp)
    80002c24:	6105                	addi	sp,sp,32
    80002c26:	8082                	ret

0000000080002c28 <join_thread>:
uint64 join_thread(uint64 thread_id, uint64 status_addr) {
    80002c28:	715d                	addi	sp,sp,-80
    80002c2a:	e486                	sd	ra,72(sp)
    80002c2c:	e0a2                	sd	s0,64(sp)
    80002c2e:	fc26                	sd	s1,56(sp)
    80002c30:	f84a                	sd	s2,48(sp)
    80002c32:	f44e                	sd	s3,40(sp)
    80002c34:	f052                	sd	s4,32(sp)
    80002c36:	e85a                	sd	s6,16(sp)
    80002c38:	0880                	addi	s0,sp,80
    80002c3a:	8a2a                	mv	s4,a0
    80002c3c:	8b2e                	mv	s6,a1
  struct proc *p = myproc();
    80002c3e:	fffff097          	auipc	ra,0xfffff
    80002c42:	2e4080e7          	jalr	740(ra) # 80001f22 <myproc>
    80002c46:	89aa                	mv	s3,a0
  if (p->is_thread) 
    80002c48:	16852783          	lw	a5,360(a0)
    80002c4c:	c399                	beqz	a5,80002c52 <join_thread+0x2a>
    p = p->parent;
    80002c4e:	03853983          	ld	s3,56(a0)
  acquire(&wait_lock);
    80002c52:	00052517          	auipc	a0,0x52
    80002c56:	23650513          	addi	a0,a0,566 # 80054e88 <wait_lock>
    80002c5a:	ffffe097          	auipc	ra,0xffffe
    80002c5e:	0bc080e7          	jalr	188(ra) # 80000d16 <acquire>
  for (thread_idx = 0; thread_idx < MAX_THREADS; thread_idx++) {
    80002c62:	17098793          	addi	a5,s3,368
    80002c66:	4901                	li	s2,0
    80002c68:	04000693          	li	a3,64
    80002c6c:	a029                	j	80002c76 <join_thread+0x4e>
    80002c6e:	2905                	addiw	s2,s2,1
    80002c70:	07a1                	addi	a5,a5,8
    80002c72:	0ed90263          	beq	s2,a3,80002d56 <join_thread+0x12e>
    if (p->infant_threads[thread_idx] && thread_id == p->infant_threads[thread_idx]->pid) {
    80002c76:	6384                	ld	s1,0(a5)
    80002c78:	d8fd                	beqz	s1,80002c6e <join_thread+0x46>
    80002c7a:	5898                	lw	a4,48(s1)
    80002c7c:	ff4719e3          	bne	a4,s4,80002c6e <join_thread+0x46>
    80002c80:	ec56                	sd	s5,24(sp)
    80002c82:	e45e                	sd	s7,8(sp)
    if (child->state == ZOMBIE) {
    80002c84:	4a95                	li	s5,5
    sleep(p, &wait_lock);
    80002c86:	00052b97          	auipc	s7,0x52
    80002c8a:	202b8b93          	addi	s7,s7,514 # 80054e88 <wait_lock>
    acquire(&child->lock);
    80002c8e:	8526                	mv	a0,s1
    80002c90:	ffffe097          	auipc	ra,0xffffe
    80002c94:	086080e7          	jalr	134(ra) # 80000d16 <acquire>
    if (child->state == ZOMBIE) {
    80002c98:	4c9c                	lw	a5,24(s1)
    80002c9a:	03578463          	beq	a5,s5,80002cc2 <join_thread+0x9a>
    release(&child->lock);
    80002c9e:	8526                	mv	a0,s1
    80002ca0:	ffffe097          	auipc	ra,0xffffe
    80002ca4:	126080e7          	jalr	294(ra) # 80000dc6 <release>
    if (killed(p)) {
    80002ca8:	854e                	mv	a0,s3
    80002caa:	00000097          	auipc	ra,0x0
    80002cae:	f4c080e7          	jalr	-180(ra) # 80002bf6 <killed>
    80002cb2:	ed35                	bnez	a0,80002d2e <join_thread+0x106>
    sleep(p, &wait_lock);
    80002cb4:	85de                	mv	a1,s7
    80002cb6:	854e                	mv	a0,s3
    80002cb8:	00000097          	auipc	ra,0x0
    80002cbc:	b18080e7          	jalr	-1256(ra) # 800027d0 <sleep>
    acquire(&child->lock);
    80002cc0:	b7f9                	j	80002c8e <join_thread+0x66>
      if (status_addr != 0 && copyout(p->pagetable, status_addr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
    80002cc2:	000b0e63          	beqz	s6,80002cde <join_thread+0xb6>
    80002cc6:	4691                	li	a3,4
    80002cc8:	02c48613          	addi	a2,s1,44
    80002ccc:	85da                	mv	a1,s6
    80002cce:	0509b503          	ld	a0,80(s3)
    80002cd2:	fffff097          	auipc	ra,0xfffff
    80002cd6:	ef8080e7          	jalr	-264(ra) # 80001bca <copyout>
    80002cda:	02054963          	bltz	a0,80002d0c <join_thread+0xe4>
      release(&child->lock);
    80002cde:	8526                	mv	a0,s1
    80002ce0:	ffffe097          	auipc	ra,0xffffe
    80002ce4:	0e6080e7          	jalr	230(ra) # 80000dc6 <release>
      release(&wait_lock);
    80002ce8:	00052517          	auipc	a0,0x52
    80002cec:	1a050513          	addi	a0,a0,416 # 80054e88 <wait_lock>
    80002cf0:	ffffe097          	auipc	ra,0xffffe
    80002cf4:	0d6080e7          	jalr	214(ra) # 80000dc6 <release>
      p->infant_threads[thread_idx] = 0;
    80002cf8:	02e90913          	addi	s2,s2,46
    80002cfc:	090e                	slli	s2,s2,0x3
    80002cfe:	99ca                	add	s3,s3,s2
    80002d00:	0009b023          	sd	zero,0(s3)
      return thread_id;
    80002d04:	8552                	mv	a0,s4
    80002d06:	6ae2                	ld	s5,24(sp)
    80002d08:	6ba2                	ld	s7,8(sp)
    80002d0a:	a82d                	j	80002d44 <join_thread+0x11c>
        release(&child->lock);
    80002d0c:	8526                	mv	a0,s1
    80002d0e:	ffffe097          	auipc	ra,0xffffe
    80002d12:	0b8080e7          	jalr	184(ra) # 80000dc6 <release>
        release(&wait_lock);
    80002d16:	00052517          	auipc	a0,0x52
    80002d1a:	17250513          	addi	a0,a0,370 # 80054e88 <wait_lock>
    80002d1e:	ffffe097          	auipc	ra,0xffffe
    80002d22:	0a8080e7          	jalr	168(ra) # 80000dc6 <release>
        return -1;
    80002d26:	557d                	li	a0,-1
    80002d28:	6ae2                	ld	s5,24(sp)
    80002d2a:	6ba2                	ld	s7,8(sp)
    80002d2c:	a821                	j	80002d44 <join_thread+0x11c>
      release(&wait_lock);
    80002d2e:	00052517          	auipc	a0,0x52
    80002d32:	15a50513          	addi	a0,a0,346 # 80054e88 <wait_lock>
    80002d36:	ffffe097          	auipc	ra,0xffffe
    80002d3a:	090080e7          	jalr	144(ra) # 80000dc6 <release>
      return -1;
    80002d3e:	557d                	li	a0,-1
    80002d40:	6ae2                	ld	s5,24(sp)
    80002d42:	6ba2                	ld	s7,8(sp)
}
    80002d44:	60a6                	ld	ra,72(sp)
    80002d46:	6406                	ld	s0,64(sp)
    80002d48:	74e2                	ld	s1,56(sp)
    80002d4a:	7942                	ld	s2,48(sp)
    80002d4c:	79a2                	ld	s3,40(sp)
    80002d4e:	7a02                	ld	s4,32(sp)
    80002d50:	6b42                	ld	s6,16(sp)
    80002d52:	6161                	addi	sp,sp,80
    80002d54:	8082                	ret
    release(&wait_lock);
    80002d56:	00052517          	auipc	a0,0x52
    80002d5a:	13250513          	addi	a0,a0,306 # 80054e88 <wait_lock>
    80002d5e:	ffffe097          	auipc	ra,0xffffe
    80002d62:	068080e7          	jalr	104(ra) # 80000dc6 <release>
    return -1;
    80002d66:	557d                	li	a0,-1
    80002d68:	bff1                	j	80002d44 <join_thread+0x11c>

0000000080002d6a <wait>:
{
    80002d6a:	715d                	addi	sp,sp,-80
    80002d6c:	e486                	sd	ra,72(sp)
    80002d6e:	e0a2                	sd	s0,64(sp)
    80002d70:	fc26                	sd	s1,56(sp)
    80002d72:	f84a                	sd	s2,48(sp)
    80002d74:	f44e                	sd	s3,40(sp)
    80002d76:	f052                	sd	s4,32(sp)
    80002d78:	ec56                	sd	s5,24(sp)
    80002d7a:	e85a                	sd	s6,16(sp)
    80002d7c:	e45e                	sd	s7,8(sp)
    80002d7e:	0880                	addi	s0,sp,80
    80002d80:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002d82:	fffff097          	auipc	ra,0xfffff
    80002d86:	1a0080e7          	jalr	416(ra) # 80001f22 <myproc>
    80002d8a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002d8c:	00052517          	auipc	a0,0x52
    80002d90:	0fc50513          	addi	a0,a0,252 # 80054e88 <wait_lock>
    80002d94:	ffffe097          	auipc	ra,0xffffe
    80002d98:	f82080e7          	jalr	-126(ra) # 80000d16 <acquire>
        if(pp->state == ZOMBIE){
    80002d9c:	4a15                	li	s4,5
        havekids = 1;
    80002d9e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002da0:	00060997          	auipc	s3,0x60
    80002da4:	10098993          	addi	s3,s3,256 # 80062ea0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002da8:	00052b97          	auipc	s7,0x52
    80002dac:	0e0b8b93          	addi	s7,s7,224 # 80054e88 <wait_lock>
    80002db0:	a0c9                	j	80002e72 <wait+0x108>
          pid = pp->pid;
    80002db2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002db6:	000b0e63          	beqz	s6,80002dd2 <wait+0x68>
    80002dba:	4691                	li	a3,4
    80002dbc:	02c48613          	addi	a2,s1,44
    80002dc0:	85da                	mv	a1,s6
    80002dc2:	05093503          	ld	a0,80(s2)
    80002dc6:	fffff097          	auipc	ra,0xfffff
    80002dca:	e04080e7          	jalr	-508(ra) # 80001bca <copyout>
    80002dce:	04054063          	bltz	a0,80002e0e <wait+0xa4>
          freeproc(pp);
    80002dd2:	8526                	mv	a0,s1
    80002dd4:	fffff097          	auipc	ra,0xfffff
    80002dd8:	300080e7          	jalr	768(ra) # 800020d4 <freeproc>
          release(&pp->lock);
    80002ddc:	8526                	mv	a0,s1
    80002dde:	ffffe097          	auipc	ra,0xffffe
    80002de2:	fe8080e7          	jalr	-24(ra) # 80000dc6 <release>
          release(&wait_lock);
    80002de6:	00052517          	auipc	a0,0x52
    80002dea:	0a250513          	addi	a0,a0,162 # 80054e88 <wait_lock>
    80002dee:	ffffe097          	auipc	ra,0xffffe
    80002df2:	fd8080e7          	jalr	-40(ra) # 80000dc6 <release>
}
    80002df6:	854e                	mv	a0,s3
    80002df8:	60a6                	ld	ra,72(sp)
    80002dfa:	6406                	ld	s0,64(sp)
    80002dfc:	74e2                	ld	s1,56(sp)
    80002dfe:	7942                	ld	s2,48(sp)
    80002e00:	79a2                	ld	s3,40(sp)
    80002e02:	7a02                	ld	s4,32(sp)
    80002e04:	6ae2                	ld	s5,24(sp)
    80002e06:	6b42                	ld	s6,16(sp)
    80002e08:	6ba2                	ld	s7,8(sp)
    80002e0a:	6161                	addi	sp,sp,80
    80002e0c:	8082                	ret
            release(&pp->lock);
    80002e0e:	8526                	mv	a0,s1
    80002e10:	ffffe097          	auipc	ra,0xffffe
    80002e14:	fb6080e7          	jalr	-74(ra) # 80000dc6 <release>
            release(&wait_lock);
    80002e18:	00052517          	auipc	a0,0x52
    80002e1c:	07050513          	addi	a0,a0,112 # 80054e88 <wait_lock>
    80002e20:	ffffe097          	auipc	ra,0xffffe
    80002e24:	fa6080e7          	jalr	-90(ra) # 80000dc6 <release>
            return -1;
    80002e28:	59fd                	li	s3,-1
    80002e2a:	b7f1                	j	80002df6 <wait+0x8c>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002e2c:	37048493          	addi	s1,s1,880
    80002e30:	03348463          	beq	s1,s3,80002e58 <wait+0xee>
      if(pp->parent == p){
    80002e34:	7c9c                	ld	a5,56(s1)
    80002e36:	ff279be3          	bne	a5,s2,80002e2c <wait+0xc2>
        acquire(&pp->lock);
    80002e3a:	8526                	mv	a0,s1
    80002e3c:	ffffe097          	auipc	ra,0xffffe
    80002e40:	eda080e7          	jalr	-294(ra) # 80000d16 <acquire>
        if(pp->state == ZOMBIE){
    80002e44:	4c9c                	lw	a5,24(s1)
    80002e46:	f74786e3          	beq	a5,s4,80002db2 <wait+0x48>
        release(&pp->lock);
    80002e4a:	8526                	mv	a0,s1
    80002e4c:	ffffe097          	auipc	ra,0xffffe
    80002e50:	f7a080e7          	jalr	-134(ra) # 80000dc6 <release>
        havekids = 1;
    80002e54:	8756                	mv	a4,s5
    80002e56:	bfd9                	j	80002e2c <wait+0xc2>
    if(!havekids || killed(p)){
    80002e58:	c31d                	beqz	a4,80002e7e <wait+0x114>
    80002e5a:	854a                	mv	a0,s2
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	d9a080e7          	jalr	-614(ra) # 80002bf6 <killed>
    80002e64:	ed09                	bnez	a0,80002e7e <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002e66:	85de                	mv	a1,s7
    80002e68:	854a                	mv	a0,s2
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	966080e7          	jalr	-1690(ra) # 800027d0 <sleep>
    havekids = 0;
    80002e72:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002e74:	00052497          	auipc	s1,0x52
    80002e78:	42c48493          	addi	s1,s1,1068 # 800552a0 <proc>
    80002e7c:	bf65                	j	80002e34 <wait+0xca>
      release(&wait_lock);
    80002e7e:	00052517          	auipc	a0,0x52
    80002e82:	00a50513          	addi	a0,a0,10 # 80054e88 <wait_lock>
    80002e86:	ffffe097          	auipc	ra,0xffffe
    80002e8a:	f40080e7          	jalr	-192(ra) # 80000dc6 <release>
      return -1;
    80002e8e:	59fd                	li	s3,-1
    80002e90:	b79d                	j	80002df6 <wait+0x8c>

0000000080002e92 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002e92:	7179                	addi	sp,sp,-48
    80002e94:	f406                	sd	ra,40(sp)
    80002e96:	f022                	sd	s0,32(sp)
    80002e98:	ec26                	sd	s1,24(sp)
    80002e9a:	e84a                	sd	s2,16(sp)
    80002e9c:	e44e                	sd	s3,8(sp)
    80002e9e:	e052                	sd	s4,0(sp)
    80002ea0:	1800                	addi	s0,sp,48
    80002ea2:	84aa                	mv	s1,a0
    80002ea4:	892e                	mv	s2,a1
    80002ea6:	89b2                	mv	s3,a2
    80002ea8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002eaa:	fffff097          	auipc	ra,0xfffff
    80002eae:	078080e7          	jalr	120(ra) # 80001f22 <myproc>
  if(user_dst){
    80002eb2:	c08d                	beqz	s1,80002ed4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002eb4:	86d2                	mv	a3,s4
    80002eb6:	864e                	mv	a2,s3
    80002eb8:	85ca                	mv	a1,s2
    80002eba:	6928                	ld	a0,80(a0)
    80002ebc:	fffff097          	auipc	ra,0xfffff
    80002ec0:	d0e080e7          	jalr	-754(ra) # 80001bca <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002ec4:	70a2                	ld	ra,40(sp)
    80002ec6:	7402                	ld	s0,32(sp)
    80002ec8:	64e2                	ld	s1,24(sp)
    80002eca:	6942                	ld	s2,16(sp)
    80002ecc:	69a2                	ld	s3,8(sp)
    80002ece:	6a02                	ld	s4,0(sp)
    80002ed0:	6145                	addi	sp,sp,48
    80002ed2:	8082                	ret
    memmove((char *)dst, src, len);
    80002ed4:	000a061b          	sext.w	a2,s4
    80002ed8:	85ce                	mv	a1,s3
    80002eda:	854a                	mv	a0,s2
    80002edc:	ffffe097          	auipc	ra,0xffffe
    80002ee0:	f96080e7          	jalr	-106(ra) # 80000e72 <memmove>
    return 0;
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	bff9                	j	80002ec4 <either_copyout+0x32>

0000000080002ee8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002ee8:	7179                	addi	sp,sp,-48
    80002eea:	f406                	sd	ra,40(sp)
    80002eec:	f022                	sd	s0,32(sp)
    80002eee:	ec26                	sd	s1,24(sp)
    80002ef0:	e84a                	sd	s2,16(sp)
    80002ef2:	e44e                	sd	s3,8(sp)
    80002ef4:	e052                	sd	s4,0(sp)
    80002ef6:	1800                	addi	s0,sp,48
    80002ef8:	892a                	mv	s2,a0
    80002efa:	84ae                	mv	s1,a1
    80002efc:	89b2                	mv	s3,a2
    80002efe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002f00:	fffff097          	auipc	ra,0xfffff
    80002f04:	022080e7          	jalr	34(ra) # 80001f22 <myproc>
  if(user_src){
    80002f08:	c08d                	beqz	s1,80002f2a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002f0a:	86d2                	mv	a3,s4
    80002f0c:	864e                	mv	a2,s3
    80002f0e:	85ca                	mv	a1,s2
    80002f10:	6928                	ld	a0,80(a0)
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	d44080e7          	jalr	-700(ra) # 80001c56 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002f1a:	70a2                	ld	ra,40(sp)
    80002f1c:	7402                	ld	s0,32(sp)
    80002f1e:	64e2                	ld	s1,24(sp)
    80002f20:	6942                	ld	s2,16(sp)
    80002f22:	69a2                	ld	s3,8(sp)
    80002f24:	6a02                	ld	s4,0(sp)
    80002f26:	6145                	addi	sp,sp,48
    80002f28:	8082                	ret
    memmove(dst, (char*)src, len);
    80002f2a:	000a061b          	sext.w	a2,s4
    80002f2e:	85ce                	mv	a1,s3
    80002f30:	854a                	mv	a0,s2
    80002f32:	ffffe097          	auipc	ra,0xffffe
    80002f36:	f40080e7          	jalr	-192(ra) # 80000e72 <memmove>
    return 0;
    80002f3a:	8526                	mv	a0,s1
    80002f3c:	bff9                	j	80002f1a <either_copyin+0x32>

0000000080002f3e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002f3e:	715d                	addi	sp,sp,-80
    80002f40:	e486                	sd	ra,72(sp)
    80002f42:	e0a2                	sd	s0,64(sp)
    80002f44:	fc26                	sd	s1,56(sp)
    80002f46:	f84a                	sd	s2,48(sp)
    80002f48:	f44e                	sd	s3,40(sp)
    80002f4a:	f052                	sd	s4,32(sp)
    80002f4c:	ec56                	sd	s5,24(sp)
    80002f4e:	e85a                	sd	s6,16(sp)
    80002f50:	e45e                	sd	s7,8(sp)
    80002f52:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002f54:	00006517          	auipc	a0,0x6
    80002f58:	0bc50513          	addi	a0,a0,188 # 80009010 <etext+0x10>
    80002f5c:	ffffd097          	auipc	ra,0xffffd
    80002f60:	64e080e7          	jalr	1614(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002f64:	00052497          	auipc	s1,0x52
    80002f68:	49448493          	addi	s1,s1,1172 # 800553f8 <proc+0x158>
    80002f6c:	00060917          	auipc	s2,0x60
    80002f70:	08c90913          	addi	s2,s2,140 # 80062ff8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002f74:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002f76:	00006997          	auipc	s3,0x6
    80002f7a:	3b298993          	addi	s3,s3,946 # 80009328 <etext+0x328>
    printf("%d %s %s", p->pid, state, p->name);
    80002f7e:	00006a97          	auipc	s5,0x6
    80002f82:	3b2a8a93          	addi	s5,s5,946 # 80009330 <etext+0x330>
    printf("\n");
    80002f86:	00006a17          	auipc	s4,0x6
    80002f8a:	08aa0a13          	addi	s4,s4,138 # 80009010 <etext+0x10>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002f8e:	00007b97          	auipc	s7,0x7
    80002f92:	a32b8b93          	addi	s7,s7,-1486 # 800099c0 <states.0>
    80002f96:	a00d                	j	80002fb8 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002f98:	ed86a583          	lw	a1,-296(a3)
    80002f9c:	8556                	mv	a0,s5
    80002f9e:	ffffd097          	auipc	ra,0xffffd
    80002fa2:	60c080e7          	jalr	1548(ra) # 800005aa <printf>
    printf("\n");
    80002fa6:	8552                	mv	a0,s4
    80002fa8:	ffffd097          	auipc	ra,0xffffd
    80002fac:	602080e7          	jalr	1538(ra) # 800005aa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002fb0:	37048493          	addi	s1,s1,880
    80002fb4:	03248263          	beq	s1,s2,80002fd8 <procdump+0x9a>
    if(p->state == UNUSED)
    80002fb8:	86a6                	mv	a3,s1
    80002fba:	ec04a783          	lw	a5,-320(s1)
    80002fbe:	dbed                	beqz	a5,80002fb0 <procdump+0x72>
      state = "???";
    80002fc0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002fc2:	fcfb6be3          	bltu	s6,a5,80002f98 <procdump+0x5a>
    80002fc6:	02079713          	slli	a4,a5,0x20
    80002fca:	01d75793          	srli	a5,a4,0x1d
    80002fce:	97de                	add	a5,a5,s7
    80002fd0:	6390                	ld	a2,0(a5)
    80002fd2:	f279                	bnez	a2,80002f98 <procdump+0x5a>
      state = "???";
    80002fd4:	864e                	mv	a2,s3
    80002fd6:	b7c9                	j	80002f98 <procdump+0x5a>
  }
}
    80002fd8:	60a6                	ld	ra,72(sp)
    80002fda:	6406                	ld	s0,64(sp)
    80002fdc:	74e2                	ld	s1,56(sp)
    80002fde:	7942                	ld	s2,48(sp)
    80002fe0:	79a2                	ld	s3,40(sp)
    80002fe2:	7a02                	ld	s4,32(sp)
    80002fe4:	6ae2                	ld	s5,24(sp)
    80002fe6:	6b42                	ld	s6,16(sp)
    80002fe8:	6ba2                	ld	s7,8(sp)
    80002fea:	6161                	addi	sp,sp,80
    80002fec:	8082                	ret

0000000080002fee <spoon>:

uint64 spoon(void *arg)
{
    80002fee:	1141                	addi	sp,sp,-16
    80002ff0:	e406                	sd	ra,8(sp)
    80002ff2:	e022                	sd	s0,0(sp)
    80002ff4:	0800                	addi	s0,sp,16
    80002ff6:	85aa                	mv	a1,a0
  // Add your code here...
  printf("In spoon system call with argument %p\n", arg);
    80002ff8:	00006517          	auipc	a0,0x6
    80002ffc:	34850513          	addi	a0,a0,840 # 80009340 <etext+0x340>
    80003000:	ffffd097          	auipc	ra,0xffffd
    80003004:	5aa080e7          	jalr	1450(ra) # 800005aa <printf>
  return 0;
}
    80003008:	4501                	li	a0,0
    8000300a:	60a2                	ld	ra,8(sp)
    8000300c:	6402                	ld	s0,0(sp)
    8000300e:	0141                	addi	sp,sp,16
    80003010:	8082                	ret

0000000080003012 <swtch>:
    80003012:	00153023          	sd	ra,0(a0)
    80003016:	00253423          	sd	sp,8(a0)
    8000301a:	e900                	sd	s0,16(a0)
    8000301c:	ed04                	sd	s1,24(a0)
    8000301e:	03253023          	sd	s2,32(a0)
    80003022:	03353423          	sd	s3,40(a0)
    80003026:	03453823          	sd	s4,48(a0)
    8000302a:	03553c23          	sd	s5,56(a0)
    8000302e:	05653023          	sd	s6,64(a0)
    80003032:	05753423          	sd	s7,72(a0)
    80003036:	05853823          	sd	s8,80(a0)
    8000303a:	05953c23          	sd	s9,88(a0)
    8000303e:	07a53023          	sd	s10,96(a0)
    80003042:	07b53423          	sd	s11,104(a0)
    80003046:	0005b083          	ld	ra,0(a1)
    8000304a:	0085b103          	ld	sp,8(a1)
    8000304e:	6980                	ld	s0,16(a1)
    80003050:	6d84                	ld	s1,24(a1)
    80003052:	0205b903          	ld	s2,32(a1)
    80003056:	0285b983          	ld	s3,40(a1)
    8000305a:	0305ba03          	ld	s4,48(a1)
    8000305e:	0385ba83          	ld	s5,56(a1)
    80003062:	0405bb03          	ld	s6,64(a1)
    80003066:	0485bb83          	ld	s7,72(a1)
    8000306a:	0505bc03          	ld	s8,80(a1)
    8000306e:	0585bc83          	ld	s9,88(a1)
    80003072:	0605bd03          	ld	s10,96(a1)
    80003076:	0685bd83          	ld	s11,104(a1)
    8000307a:	8082                	ret

000000008000307c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000307c:	1141                	addi	sp,sp,-16
    8000307e:	e406                	sd	ra,8(sp)
    80003080:	e022                	sd	s0,0(sp)
    80003082:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003084:	00006597          	auipc	a1,0x6
    80003088:	31458593          	addi	a1,a1,788 # 80009398 <etext+0x398>
    8000308c:	00060517          	auipc	a0,0x60
    80003090:	e1450513          	addi	a0,a0,-492 # 80062ea0 <tickslock>
    80003094:	ffffe097          	auipc	ra,0xffffe
    80003098:	bee080e7          	jalr	-1042(ra) # 80000c82 <initlock>
}
    8000309c:	60a2                	ld	ra,8(sp)
    8000309e:	6402                	ld	s0,0(sp)
    800030a0:	0141                	addi	sp,sp,16
    800030a2:	8082                	ret

00000000800030a4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800030a4:	1141                	addi	sp,sp,-16
    800030a6:	e406                	sd	ra,8(sp)
    800030a8:	e022                	sd	s0,0(sp)
    800030aa:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800030ac:	00004797          	auipc	a5,0x4
    800030b0:	86478793          	addi	a5,a5,-1948 # 80006910 <kernelvec>
    800030b4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800030b8:	60a2                	ld	ra,8(sp)
    800030ba:	6402                	ld	s0,0(sp)
    800030bc:	0141                	addi	sp,sp,16
    800030be:	8082                	ret

00000000800030c0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800030c0:	1141                	addi	sp,sp,-16
    800030c2:	e406                	sd	ra,8(sp)
    800030c4:	e022                	sd	s0,0(sp)
    800030c6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800030c8:	fffff097          	auipc	ra,0xfffff
    800030cc:	e5a080e7          	jalr	-422(ra) # 80001f22 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030d0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800030d4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800030d6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800030da:	00005697          	auipc	a3,0x5
    800030de:	f2668693          	addi	a3,a3,-218 # 80008000 <_trampoline>
    800030e2:	00005717          	auipc	a4,0x5
    800030e6:	f1e70713          	addi	a4,a4,-226 # 80008000 <_trampoline>
    800030ea:	8f15                	sub	a4,a4,a3
    800030ec:	040007b7          	lui	a5,0x4000
    800030f0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800030f2:	07b2                	slli	a5,a5,0xc
    800030f4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800030f6:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800030fa:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800030fc:	18002673          	csrr	a2,satp
    80003100:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003102:	6d30                	ld	a2,88(a0)
    80003104:	6138                	ld	a4,64(a0)
    80003106:	6585                	lui	a1,0x1
    80003108:	972e                	add	a4,a4,a1
    8000310a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000310c:	6d38                	ld	a4,88(a0)
    8000310e:	00000617          	auipc	a2,0x0
    80003112:	14c60613          	addi	a2,a2,332 # 8000325a <usertrap>
    80003116:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003118:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000311a:	8612                	mv	a2,tp
    8000311c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000311e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003122:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003126:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000312a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000312e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003130:	6f18                	ld	a4,24(a4)
    80003132:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003136:	6928                	ld	a0,80(a0)
    80003138:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000313a:	00005717          	auipc	a4,0x5
    8000313e:	f6270713          	addi	a4,a4,-158 # 8000809c <userret>
    80003142:	8f15                	sub	a4,a4,a3
    80003144:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80003146:	577d                	li	a4,-1
    80003148:	177e                	slli	a4,a4,0x3f
    8000314a:	8d59                	or	a0,a0,a4
    8000314c:	9782                	jalr	a5
}
    8000314e:	60a2                	ld	ra,8(sp)
    80003150:	6402                	ld	s0,0(sp)
    80003152:	0141                	addi	sp,sp,16
    80003154:	8082                	ret

0000000080003156 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80003156:	1101                	addi	sp,sp,-32
    80003158:	ec06                	sd	ra,24(sp)
    8000315a:	e822                	sd	s0,16(sp)
    8000315c:	e426                	sd	s1,8(sp)
    8000315e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80003160:	00060497          	auipc	s1,0x60
    80003164:	d4048493          	addi	s1,s1,-704 # 80062ea0 <tickslock>
    80003168:	8526                	mv	a0,s1
    8000316a:	ffffe097          	auipc	ra,0xffffe
    8000316e:	bac080e7          	jalr	-1108(ra) # 80000d16 <acquire>
  ticks++;
    80003172:	0000a517          	auipc	a0,0xa
    80003176:	a8e50513          	addi	a0,a0,-1394 # 8000cc00 <ticks>
    8000317a:	411c                	lw	a5,0(a0)
    8000317c:	2785                	addiw	a5,a5,1
    8000317e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80003180:	fffff097          	auipc	ra,0xfffff
    80003184:	6b4080e7          	jalr	1716(ra) # 80002834 <wakeup>
  release(&tickslock);
    80003188:	8526                	mv	a0,s1
    8000318a:	ffffe097          	auipc	ra,0xffffe
    8000318e:	c3c080e7          	jalr	-964(ra) # 80000dc6 <release>
}
    80003192:	60e2                	ld	ra,24(sp)
    80003194:	6442                	ld	s0,16(sp)
    80003196:	64a2                	ld	s1,8(sp)
    80003198:	6105                	addi	sp,sp,32
    8000319a:	8082                	ret

000000008000319c <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000319c:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800031a0:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    800031a2:	0a07db63          	bgez	a5,80003258 <devintr+0xbc>
{
    800031a6:	1101                	addi	sp,sp,-32
    800031a8:	ec06                	sd	ra,24(sp)
    800031aa:	e822                	sd	s0,16(sp)
    800031ac:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    800031ae:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    800031b2:	46a5                	li	a3,9
    800031b4:	00d70c63          	beq	a4,a3,800031cc <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    800031b8:	577d                	li	a4,-1
    800031ba:	177e                	slli	a4,a4,0x3f
    800031bc:	0705                	addi	a4,a4,1
    return 0;
    800031be:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800031c0:	06e78b63          	beq	a5,a4,80003236 <devintr+0x9a>
  }
}
    800031c4:	60e2                	ld	ra,24(sp)
    800031c6:	6442                	ld	s0,16(sp)
    800031c8:	6105                	addi	sp,sp,32
    800031ca:	8082                	ret
    800031cc:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800031ce:	00004097          	auipc	ra,0x4
    800031d2:	850080e7          	jalr	-1968(ra) # 80006a1e <plic_claim>
    800031d6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800031d8:	47a9                	li	a5,10
    800031da:	00f50c63          	beq	a0,a5,800031f2 <devintr+0x56>
    } else if(irq == VIRTIO0_IRQ){
    800031de:	4785                	li	a5,1
    800031e0:	02f50563          	beq	a0,a5,8000320a <devintr+0x6e>
    } else if (irq == VIRTIO1_IRQ) {
    800031e4:	4789                	li	a5,2
    800031e6:	02f50763          	beq	a0,a5,80003214 <devintr+0x78>
    return 1;
    800031ea:	4505                	li	a0,1
    } else if(irq){
    800031ec:	e89d                	bnez	s1,80003222 <devintr+0x86>
    800031ee:	64a2                	ld	s1,8(sp)
    800031f0:	bfd1                	j	800031c4 <devintr+0x28>
      uartintr();
    800031f2:	ffffe097          	auipc	ra,0xffffe
    800031f6:	80a080e7          	jalr	-2038(ra) # 800009fc <uartintr>
      plic_complete(irq);
    800031fa:	8526                	mv	a0,s1
    800031fc:	00004097          	auipc	ra,0x4
    80003200:	846080e7          	jalr	-1978(ra) # 80006a42 <plic_complete>
    return 1;
    80003204:	4505                	li	a0,1
    80003206:	64a2                	ld	s1,8(sp)
    80003208:	bf75                	j	800031c4 <devintr+0x28>
      virtio_disk_intr();
    8000320a:	00004097          	auipc	ra,0x4
    8000320e:	d08080e7          	jalr	-760(ra) # 80006f12 <virtio_disk_intr>
    if(irq)
    80003212:	b7e5                	j	800031fa <devintr+0x5e>
      receive_packet(temp, 0);
    80003214:	4581                	li	a1,0
    80003216:	4501                	li	a0,0
    80003218:	00004097          	auipc	ra,0x4
    8000321c:	4ea080e7          	jalr	1258(ra) # 80007702 <receive_packet>
    80003220:	bfe9                	j	800031fa <devintr+0x5e>
      printf("unexpected interrupt irq=%d\n", irq);
    80003222:	85a6                	mv	a1,s1
    80003224:	00006517          	auipc	a0,0x6
    80003228:	17c50513          	addi	a0,a0,380 # 800093a0 <etext+0x3a0>
    8000322c:	ffffd097          	auipc	ra,0xffffd
    80003230:	37e080e7          	jalr	894(ra) # 800005aa <printf>
    if(irq)
    80003234:	b7d9                	j	800031fa <devintr+0x5e>
    if(cpuid() == 0){
    80003236:	fffff097          	auipc	ra,0xfffff
    8000323a:	cb8080e7          	jalr	-840(ra) # 80001eee <cpuid>
    8000323e:	c901                	beqz	a0,8000324e <devintr+0xb2>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003240:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003244:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003246:	14479073          	csrw	sip,a5
    return 2;
    8000324a:	4509                	li	a0,2
    8000324c:	bfa5                	j	800031c4 <devintr+0x28>
      clockintr();
    8000324e:	00000097          	auipc	ra,0x0
    80003252:	f08080e7          	jalr	-248(ra) # 80003156 <clockintr>
    80003256:	b7ed                	j	80003240 <devintr+0xa4>
}
    80003258:	8082                	ret

000000008000325a <usertrap>:
{
    8000325a:	1101                	addi	sp,sp,-32
    8000325c:	ec06                	sd	ra,24(sp)
    8000325e:	e822                	sd	s0,16(sp)
    80003260:	e426                	sd	s1,8(sp)
    80003262:	e04a                	sd	s2,0(sp)
    80003264:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003266:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000326a:	1007f793          	andi	a5,a5,256
    8000326e:	e3b1                	bnez	a5,800032b2 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003270:	00003797          	auipc	a5,0x3
    80003274:	6a078793          	addi	a5,a5,1696 # 80006910 <kernelvec>
    80003278:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000327c:	fffff097          	auipc	ra,0xfffff
    80003280:	ca6080e7          	jalr	-858(ra) # 80001f22 <myproc>
    80003284:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80003286:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003288:	14102773          	csrr	a4,sepc
    8000328c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000328e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80003292:	47a1                	li	a5,8
    80003294:	02f70763          	beq	a4,a5,800032c2 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80003298:	00000097          	auipc	ra,0x0
    8000329c:	f04080e7          	jalr	-252(ra) # 8000319c <devintr>
    800032a0:	892a                	mv	s2,a0
    800032a2:	c151                	beqz	a0,80003326 <usertrap+0xcc>
  if(killed(p))
    800032a4:	8526                	mv	a0,s1
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	950080e7          	jalr	-1712(ra) # 80002bf6 <killed>
    800032ae:	c929                	beqz	a0,80003300 <usertrap+0xa6>
    800032b0:	a099                	j	800032f6 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    800032b2:	00006517          	auipc	a0,0x6
    800032b6:	10e50513          	addi	a0,a0,270 # 800093c0 <etext+0x3c0>
    800032ba:	ffffd097          	auipc	ra,0xffffd
    800032be:	2a6080e7          	jalr	678(ra) # 80000560 <panic>
    if(killed(p))
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	934080e7          	jalr	-1740(ra) # 80002bf6 <killed>
    800032ca:	e921                	bnez	a0,8000331a <usertrap+0xc0>
    p->trapframe->epc += 4;
    800032cc:	6cb8                	ld	a4,88(s1)
    800032ce:	6f1c                	ld	a5,24(a4)
    800032d0:	0791                	addi	a5,a5,4
    800032d2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800032d8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800032dc:	10079073          	csrw	sstatus,a5
    syscall();
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	2cc080e7          	jalr	716(ra) # 800035ac <syscall>
  if(killed(p))
    800032e8:	8526                	mv	a0,s1
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	90c080e7          	jalr	-1780(ra) # 80002bf6 <killed>
    800032f2:	c911                	beqz	a0,80003306 <usertrap+0xac>
    800032f4:	4901                	li	s2,0
    exit(-1);
    800032f6:	557d                	li	a0,-1
    800032f8:	fffff097          	auipc	ra,0xfffff
    800032fc:	6e2080e7          	jalr	1762(ra) # 800029da <exit>
  if(which_dev == 2)
    80003300:	4789                	li	a5,2
    80003302:	04f90f63          	beq	s2,a5,80003360 <usertrap+0x106>
  usertrapret();
    80003306:	00000097          	auipc	ra,0x0
    8000330a:	dba080e7          	jalr	-582(ra) # 800030c0 <usertrapret>
}
    8000330e:	60e2                	ld	ra,24(sp)
    80003310:	6442                	ld	s0,16(sp)
    80003312:	64a2                	ld	s1,8(sp)
    80003314:	6902                	ld	s2,0(sp)
    80003316:	6105                	addi	sp,sp,32
    80003318:	8082                	ret
      exit(-1);
    8000331a:	557d                	li	a0,-1
    8000331c:	fffff097          	auipc	ra,0xfffff
    80003320:	6be080e7          	jalr	1726(ra) # 800029da <exit>
    80003324:	b765                	j	800032cc <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003326:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000332a:	5890                	lw	a2,48(s1)
    8000332c:	00006517          	auipc	a0,0x6
    80003330:	0b450513          	addi	a0,a0,180 # 800093e0 <etext+0x3e0>
    80003334:	ffffd097          	auipc	ra,0xffffd
    80003338:	276080e7          	jalr	630(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000333c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003340:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003344:	00006517          	auipc	a0,0x6
    80003348:	0cc50513          	addi	a0,a0,204 # 80009410 <etext+0x410>
    8000334c:	ffffd097          	auipc	ra,0xffffd
    80003350:	25e080e7          	jalr	606(ra) # 800005aa <printf>
    setkilled(p);
    80003354:	8526                	mv	a0,s1
    80003356:	00000097          	auipc	ra,0x0
    8000335a:	874080e7          	jalr	-1932(ra) # 80002bca <setkilled>
    8000335e:	b769                	j	800032e8 <usertrap+0x8e>
    yield();
    80003360:	fffff097          	auipc	ra,0xfffff
    80003364:	434080e7          	jalr	1076(ra) # 80002794 <yield>
    80003368:	bf79                	j	80003306 <usertrap+0xac>

000000008000336a <kerneltrap>:
{
    8000336a:	7179                	addi	sp,sp,-48
    8000336c:	f406                	sd	ra,40(sp)
    8000336e:	f022                	sd	s0,32(sp)
    80003370:	ec26                	sd	s1,24(sp)
    80003372:	e84a                	sd	s2,16(sp)
    80003374:	e44e                	sd	s3,8(sp)
    80003376:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003378:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000337c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003380:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80003384:	1004f793          	andi	a5,s1,256
    80003388:	cb85                	beqz	a5,800033b8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000338a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000338e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80003390:	ef85                	bnez	a5,800033c8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80003392:	00000097          	auipc	ra,0x0
    80003396:	e0a080e7          	jalr	-502(ra) # 8000319c <devintr>
    8000339a:	cd1d                	beqz	a0,800033d8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000339c:	4789                	li	a5,2
    8000339e:	06f50a63          	beq	a0,a5,80003412 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800033a2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800033a6:	10049073          	csrw	sstatus,s1
}
    800033aa:	70a2                	ld	ra,40(sp)
    800033ac:	7402                	ld	s0,32(sp)
    800033ae:	64e2                	ld	s1,24(sp)
    800033b0:	6942                	ld	s2,16(sp)
    800033b2:	69a2                	ld	s3,8(sp)
    800033b4:	6145                	addi	sp,sp,48
    800033b6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800033b8:	00006517          	auipc	a0,0x6
    800033bc:	07850513          	addi	a0,a0,120 # 80009430 <etext+0x430>
    800033c0:	ffffd097          	auipc	ra,0xffffd
    800033c4:	1a0080e7          	jalr	416(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    800033c8:	00006517          	auipc	a0,0x6
    800033cc:	09050513          	addi	a0,a0,144 # 80009458 <etext+0x458>
    800033d0:	ffffd097          	auipc	ra,0xffffd
    800033d4:	190080e7          	jalr	400(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    800033d8:	85ce                	mv	a1,s3
    800033da:	00006517          	auipc	a0,0x6
    800033de:	09e50513          	addi	a0,a0,158 # 80009478 <etext+0x478>
    800033e2:	ffffd097          	auipc	ra,0xffffd
    800033e6:	1c8080e7          	jalr	456(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800033ea:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800033ee:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800033f2:	00006517          	auipc	a0,0x6
    800033f6:	09650513          	addi	a0,a0,150 # 80009488 <etext+0x488>
    800033fa:	ffffd097          	auipc	ra,0xffffd
    800033fe:	1b0080e7          	jalr	432(ra) # 800005aa <printf>
    panic("kerneltrap");
    80003402:	00006517          	auipc	a0,0x6
    80003406:	09e50513          	addi	a0,a0,158 # 800094a0 <etext+0x4a0>
    8000340a:	ffffd097          	auipc	ra,0xffffd
    8000340e:	156080e7          	jalr	342(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003412:	fffff097          	auipc	ra,0xfffff
    80003416:	b10080e7          	jalr	-1264(ra) # 80001f22 <myproc>
    8000341a:	d541                	beqz	a0,800033a2 <kerneltrap+0x38>
    8000341c:	fffff097          	auipc	ra,0xfffff
    80003420:	b06080e7          	jalr	-1274(ra) # 80001f22 <myproc>
    80003424:	4d18                	lw	a4,24(a0)
    80003426:	4791                	li	a5,4
    80003428:	f6f71de3          	bne	a4,a5,800033a2 <kerneltrap+0x38>
    yield();
    8000342c:	fffff097          	auipc	ra,0xfffff
    80003430:	368080e7          	jalr	872(ra) # 80002794 <yield>
    80003434:	b7bd                	j	800033a2 <kerneltrap+0x38>

0000000080003436 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003436:	1101                	addi	sp,sp,-32
    80003438:	ec06                	sd	ra,24(sp)
    8000343a:	e822                	sd	s0,16(sp)
    8000343c:	e426                	sd	s1,8(sp)
    8000343e:	1000                	addi	s0,sp,32
    80003440:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	ae0080e7          	jalr	-1312(ra) # 80001f22 <myproc>
  switch (n) {
    8000344a:	4795                	li	a5,5
    8000344c:	0497e163          	bltu	a5,s1,8000348e <argraw+0x58>
    80003450:	048a                	slli	s1,s1,0x2
    80003452:	00006717          	auipc	a4,0x6
    80003456:	59e70713          	addi	a4,a4,1438 # 800099f0 <states.0+0x30>
    8000345a:	94ba                	add	s1,s1,a4
    8000345c:	409c                	lw	a5,0(s1)
    8000345e:	97ba                	add	a5,a5,a4
    80003460:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80003462:	6d3c                	ld	a5,88(a0)
    80003464:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003466:	60e2                	ld	ra,24(sp)
    80003468:	6442                	ld	s0,16(sp)
    8000346a:	64a2                	ld	s1,8(sp)
    8000346c:	6105                	addi	sp,sp,32
    8000346e:	8082                	ret
    return p->trapframe->a1;
    80003470:	6d3c                	ld	a5,88(a0)
    80003472:	7fa8                	ld	a0,120(a5)
    80003474:	bfcd                	j	80003466 <argraw+0x30>
    return p->trapframe->a2;
    80003476:	6d3c                	ld	a5,88(a0)
    80003478:	63c8                	ld	a0,128(a5)
    8000347a:	b7f5                	j	80003466 <argraw+0x30>
    return p->trapframe->a3;
    8000347c:	6d3c                	ld	a5,88(a0)
    8000347e:	67c8                	ld	a0,136(a5)
    80003480:	b7dd                	j	80003466 <argraw+0x30>
    return p->trapframe->a4;
    80003482:	6d3c                	ld	a5,88(a0)
    80003484:	6bc8                	ld	a0,144(a5)
    80003486:	b7c5                	j	80003466 <argraw+0x30>
    return p->trapframe->a5;
    80003488:	6d3c                	ld	a5,88(a0)
    8000348a:	6fc8                	ld	a0,152(a5)
    8000348c:	bfe9                	j	80003466 <argraw+0x30>
  panic("argraw");
    8000348e:	00006517          	auipc	a0,0x6
    80003492:	02250513          	addi	a0,a0,34 # 800094b0 <etext+0x4b0>
    80003496:	ffffd097          	auipc	ra,0xffffd
    8000349a:	0ca080e7          	jalr	202(ra) # 80000560 <panic>

000000008000349e <fetchaddr>:
{
    8000349e:	1101                	addi	sp,sp,-32
    800034a0:	ec06                	sd	ra,24(sp)
    800034a2:	e822                	sd	s0,16(sp)
    800034a4:	e426                	sd	s1,8(sp)
    800034a6:	e04a                	sd	s2,0(sp)
    800034a8:	1000                	addi	s0,sp,32
    800034aa:	84aa                	mv	s1,a0
    800034ac:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	a74080e7          	jalr	-1420(ra) # 80001f22 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800034b6:	653c                	ld	a5,72(a0)
    800034b8:	02f4f863          	bgeu	s1,a5,800034e8 <fetchaddr+0x4a>
    800034bc:	00848713          	addi	a4,s1,8
    800034c0:	02e7e663          	bltu	a5,a4,800034ec <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800034c4:	46a1                	li	a3,8
    800034c6:	8626                	mv	a2,s1
    800034c8:	85ca                	mv	a1,s2
    800034ca:	6928                	ld	a0,80(a0)
    800034cc:	ffffe097          	auipc	ra,0xffffe
    800034d0:	78a080e7          	jalr	1930(ra) # 80001c56 <copyin>
    800034d4:	00a03533          	snez	a0,a0
    800034d8:	40a0053b          	negw	a0,a0
}
    800034dc:	60e2                	ld	ra,24(sp)
    800034de:	6442                	ld	s0,16(sp)
    800034e0:	64a2                	ld	s1,8(sp)
    800034e2:	6902                	ld	s2,0(sp)
    800034e4:	6105                	addi	sp,sp,32
    800034e6:	8082                	ret
    return -1;
    800034e8:	557d                	li	a0,-1
    800034ea:	bfcd                	j	800034dc <fetchaddr+0x3e>
    800034ec:	557d                	li	a0,-1
    800034ee:	b7fd                	j	800034dc <fetchaddr+0x3e>

00000000800034f0 <fetchstr>:
{
    800034f0:	7179                	addi	sp,sp,-48
    800034f2:	f406                	sd	ra,40(sp)
    800034f4:	f022                	sd	s0,32(sp)
    800034f6:	ec26                	sd	s1,24(sp)
    800034f8:	e84a                	sd	s2,16(sp)
    800034fa:	e44e                	sd	s3,8(sp)
    800034fc:	1800                	addi	s0,sp,48
    800034fe:	892a                	mv	s2,a0
    80003500:	84ae                	mv	s1,a1
    80003502:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003504:	fffff097          	auipc	ra,0xfffff
    80003508:	a1e080e7          	jalr	-1506(ra) # 80001f22 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000350c:	86ce                	mv	a3,s3
    8000350e:	864a                	mv	a2,s2
    80003510:	85a6                	mv	a1,s1
    80003512:	6928                	ld	a0,80(a0)
    80003514:	ffffe097          	auipc	ra,0xffffe
    80003518:	7d0080e7          	jalr	2000(ra) # 80001ce4 <copyinstr>
    8000351c:	00054e63          	bltz	a0,80003538 <fetchstr+0x48>
  return strlen(buf);
    80003520:	8526                	mv	a0,s1
    80003522:	ffffe097          	auipc	ra,0xffffe
    80003526:	a78080e7          	jalr	-1416(ra) # 80000f9a <strlen>
}
    8000352a:	70a2                	ld	ra,40(sp)
    8000352c:	7402                	ld	s0,32(sp)
    8000352e:	64e2                	ld	s1,24(sp)
    80003530:	6942                	ld	s2,16(sp)
    80003532:	69a2                	ld	s3,8(sp)
    80003534:	6145                	addi	sp,sp,48
    80003536:	8082                	ret
    return -1;
    80003538:	557d                	li	a0,-1
    8000353a:	bfc5                	j	8000352a <fetchstr+0x3a>

000000008000353c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000353c:	1101                	addi	sp,sp,-32
    8000353e:	ec06                	sd	ra,24(sp)
    80003540:	e822                	sd	s0,16(sp)
    80003542:	e426                	sd	s1,8(sp)
    80003544:	1000                	addi	s0,sp,32
    80003546:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003548:	00000097          	auipc	ra,0x0
    8000354c:	eee080e7          	jalr	-274(ra) # 80003436 <argraw>
    80003550:	c088                	sw	a0,0(s1)
}
    80003552:	60e2                	ld	ra,24(sp)
    80003554:	6442                	ld	s0,16(sp)
    80003556:	64a2                	ld	s1,8(sp)
    80003558:	6105                	addi	sp,sp,32
    8000355a:	8082                	ret

000000008000355c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000355c:	1101                	addi	sp,sp,-32
    8000355e:	ec06                	sd	ra,24(sp)
    80003560:	e822                	sd	s0,16(sp)
    80003562:	e426                	sd	s1,8(sp)
    80003564:	1000                	addi	s0,sp,32
    80003566:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003568:	00000097          	auipc	ra,0x0
    8000356c:	ece080e7          	jalr	-306(ra) # 80003436 <argraw>
    80003570:	e088                	sd	a0,0(s1)
}
    80003572:	60e2                	ld	ra,24(sp)
    80003574:	6442                	ld	s0,16(sp)
    80003576:	64a2                	ld	s1,8(sp)
    80003578:	6105                	addi	sp,sp,32
    8000357a:	8082                	ret

000000008000357c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000357c:	1101                	addi	sp,sp,-32
    8000357e:	ec06                	sd	ra,24(sp)
    80003580:	e822                	sd	s0,16(sp)
    80003582:	e426                	sd	s1,8(sp)
    80003584:	e04a                	sd	s2,0(sp)
    80003586:	1000                	addi	s0,sp,32
    80003588:	84ae                	mv	s1,a1
    8000358a:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000358c:	00000097          	auipc	ra,0x0
    80003590:	eaa080e7          	jalr	-342(ra) # 80003436 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80003594:	864a                	mv	a2,s2
    80003596:	85a6                	mv	a1,s1
    80003598:	00000097          	auipc	ra,0x0
    8000359c:	f58080e7          	jalr	-168(ra) # 800034f0 <fetchstr>
}
    800035a0:	60e2                	ld	ra,24(sp)
    800035a2:	6442                	ld	s0,16(sp)
    800035a4:	64a2                	ld	s1,8(sp)
    800035a6:	6902                	ld	s2,0(sp)
    800035a8:	6105                	addi	sp,sp,32
    800035aa:	8082                	ret

00000000800035ac <syscall>:
[SYS_connect]       sys_connect,
};

void
syscall(void)
{
    800035ac:	1101                	addi	sp,sp,-32
    800035ae:	ec06                	sd	ra,24(sp)
    800035b0:	e822                	sd	s0,16(sp)
    800035b2:	e426                	sd	s1,8(sp)
    800035b4:	e04a                	sd	s2,0(sp)
    800035b6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800035b8:	fffff097          	auipc	ra,0xfffff
    800035bc:	96a080e7          	jalr	-1686(ra) # 80001f22 <myproc>
    800035c0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800035c2:	05853903          	ld	s2,88(a0)
    800035c6:	0a893783          	ld	a5,168(s2)
    800035ca:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800035ce:	37fd                	addiw	a5,a5,-1
    800035d0:	4775                	li	a4,29
    800035d2:	00f76f63          	bltu	a4,a5,800035f0 <syscall+0x44>
    800035d6:	00369713          	slli	a4,a3,0x3
    800035da:	00006797          	auipc	a5,0x6
    800035de:	42e78793          	addi	a5,a5,1070 # 80009a08 <syscalls>
    800035e2:	97ba                	add	a5,a5,a4
    800035e4:	639c                	ld	a5,0(a5)
    800035e6:	c789                	beqz	a5,800035f0 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800035e8:	9782                	jalr	a5
    800035ea:	06a93823          	sd	a0,112(s2)
    800035ee:	a839                	j	8000360c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800035f0:	15848613          	addi	a2,s1,344
    800035f4:	588c                	lw	a1,48(s1)
    800035f6:	00006517          	auipc	a0,0x6
    800035fa:	ec250513          	addi	a0,a0,-318 # 800094b8 <etext+0x4b8>
    800035fe:	ffffd097          	auipc	ra,0xffffd
    80003602:	fac080e7          	jalr	-84(ra) # 800005aa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003606:	6cbc                	ld	a5,88(s1)
    80003608:	577d                	li	a4,-1
    8000360a:	fbb8                	sd	a4,112(a5)
  }
}
    8000360c:	60e2                	ld	ra,24(sp)
    8000360e:	6442                	ld	s0,16(sp)
    80003610:	64a2                	ld	s1,8(sp)
    80003612:	6902                	ld	s2,0(sp)
    80003614:	6105                	addi	sp,sp,32
    80003616:	8082                	ret

0000000080003618 <sys_exit>:
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void) {
    80003618:	1101                	addi	sp,sp,-32
    8000361a:	ec06                	sd	ra,24(sp)
    8000361c:	e822                	sd	s0,16(sp)
    8000361e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003620:	fec40593          	addi	a1,s0,-20
    80003624:	4501                	li	a0,0
    80003626:	00000097          	auipc	ra,0x0
    8000362a:	f16080e7          	jalr	-234(ra) # 8000353c <argint>
  exit(n);
    8000362e:	fec42503          	lw	a0,-20(s0)
    80003632:	fffff097          	auipc	ra,0xfffff
    80003636:	3a8080e7          	jalr	936(ra) # 800029da <exit>
  return 0; // not reached
}
    8000363a:	4501                	li	a0,0
    8000363c:	60e2                	ld	ra,24(sp)
    8000363e:	6442                	ld	s0,16(sp)
    80003640:	6105                	addi	sp,sp,32
    80003642:	8082                	ret

0000000080003644 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80003644:	1141                	addi	sp,sp,-16
    80003646:	e406                	sd	ra,8(sp)
    80003648:	e022                	sd	s0,0(sp)
    8000364a:	0800                	addi	s0,sp,16
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	8d6080e7          	jalr	-1834(ra) # 80001f22 <myproc>
    80003654:	5908                	lw	a0,48(a0)
    80003656:	60a2                	ld	ra,8(sp)
    80003658:	6402                	ld	s0,0(sp)
    8000365a:	0141                	addi	sp,sp,16
    8000365c:	8082                	ret

000000008000365e <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    8000365e:	1141                	addi	sp,sp,-16
    80003660:	e406                	sd	ra,8(sp)
    80003662:	e022                	sd	s0,0(sp)
    80003664:	0800                	addi	s0,sp,16
    80003666:	fffff097          	auipc	ra,0xfffff
    8000366a:	cbe080e7          	jalr	-834(ra) # 80002324 <fork>
    8000366e:	60a2                	ld	ra,8(sp)
    80003670:	6402                	ld	s0,0(sp)
    80003672:	0141                	addi	sp,sp,16
    80003674:	8082                	ret

0000000080003676 <sys_wait>:

uint64 sys_wait(void) {
    80003676:	1101                	addi	sp,sp,-32
    80003678:	ec06                	sd	ra,24(sp)
    8000367a:	e822                	sd	s0,16(sp)
    8000367c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000367e:	fe840593          	addi	a1,s0,-24
    80003682:	4501                	li	a0,0
    80003684:	00000097          	auipc	ra,0x0
    80003688:	ed8080e7          	jalr	-296(ra) # 8000355c <argaddr>
  return wait(p);
    8000368c:	fe843503          	ld	a0,-24(s0)
    80003690:	fffff097          	auipc	ra,0xfffff
    80003694:	6da080e7          	jalr	1754(ra) # 80002d6a <wait>
}
    80003698:	60e2                	ld	ra,24(sp)
    8000369a:	6442                	ld	s0,16(sp)
    8000369c:	6105                	addi	sp,sp,32
    8000369e:	8082                	ret

00000000800036a0 <sys_sbrk>:

uint64 sys_sbrk(void) {
    800036a0:	7179                	addi	sp,sp,-48
    800036a2:	f406                	sd	ra,40(sp)
    800036a4:	f022                	sd	s0,32(sp)
    800036a6:	ec26                	sd	s1,24(sp)
    800036a8:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800036aa:	fdc40593          	addi	a1,s0,-36
    800036ae:	4501                	li	a0,0
    800036b0:	00000097          	auipc	ra,0x0
    800036b4:	e8c080e7          	jalr	-372(ra) # 8000353c <argint>
  addr = myproc()->sz;
    800036b8:	fffff097          	auipc	ra,0xfffff
    800036bc:	86a080e7          	jalr	-1942(ra) # 80001f22 <myproc>
    800036c0:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    800036c2:	fdc42503          	lw	a0,-36(s0)
    800036c6:	fffff097          	auipc	ra,0xfffff
    800036ca:	bc8080e7          	jalr	-1080(ra) # 8000228e <growproc>
    800036ce:	00054863          	bltz	a0,800036de <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800036d2:	8526                	mv	a0,s1
    800036d4:	70a2                	ld	ra,40(sp)
    800036d6:	7402                	ld	s0,32(sp)
    800036d8:	64e2                	ld	s1,24(sp)
    800036da:	6145                	addi	sp,sp,48
    800036dc:	8082                	ret
    return -1;
    800036de:	54fd                	li	s1,-1
    800036e0:	bfcd                	j	800036d2 <sys_sbrk+0x32>

00000000800036e2 <sys_sleep>:

uint64 sys_sleep(void) {
    800036e2:	7139                	addi	sp,sp,-64
    800036e4:	fc06                	sd	ra,56(sp)
    800036e6:	f822                	sd	s0,48(sp)
    800036e8:	f04a                	sd	s2,32(sp)
    800036ea:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800036ec:	fcc40593          	addi	a1,s0,-52
    800036f0:	4501                	li	a0,0
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	e4a080e7          	jalr	-438(ra) # 8000353c <argint>
  acquire(&tickslock);
    800036fa:	0005f517          	auipc	a0,0x5f
    800036fe:	7a650513          	addi	a0,a0,1958 # 80062ea0 <tickslock>
    80003702:	ffffd097          	auipc	ra,0xffffd
    80003706:	614080e7          	jalr	1556(ra) # 80000d16 <acquire>
  ticks0 = ticks;
    8000370a:	00009917          	auipc	s2,0x9
    8000370e:	4f692903          	lw	s2,1270(s2) # 8000cc00 <ticks>
  while (ticks - ticks0 < n) {
    80003712:	fcc42783          	lw	a5,-52(s0)
    80003716:	c3b9                	beqz	a5,8000375c <sys_sleep+0x7a>
    80003718:	f426                	sd	s1,40(sp)
    8000371a:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000371c:	0005f997          	auipc	s3,0x5f
    80003720:	78498993          	addi	s3,s3,1924 # 80062ea0 <tickslock>
    80003724:	00009497          	auipc	s1,0x9
    80003728:	4dc48493          	addi	s1,s1,1244 # 8000cc00 <ticks>
    if (killed(myproc())) {
    8000372c:	ffffe097          	auipc	ra,0xffffe
    80003730:	7f6080e7          	jalr	2038(ra) # 80001f22 <myproc>
    80003734:	fffff097          	auipc	ra,0xfffff
    80003738:	4c2080e7          	jalr	1218(ra) # 80002bf6 <killed>
    8000373c:	ed15                	bnez	a0,80003778 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000373e:	85ce                	mv	a1,s3
    80003740:	8526                	mv	a0,s1
    80003742:	fffff097          	auipc	ra,0xfffff
    80003746:	08e080e7          	jalr	142(ra) # 800027d0 <sleep>
  while (ticks - ticks0 < n) {
    8000374a:	409c                	lw	a5,0(s1)
    8000374c:	412787bb          	subw	a5,a5,s2
    80003750:	fcc42703          	lw	a4,-52(s0)
    80003754:	fce7ece3          	bltu	a5,a4,8000372c <sys_sleep+0x4a>
    80003758:	74a2                	ld	s1,40(sp)
    8000375a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000375c:	0005f517          	auipc	a0,0x5f
    80003760:	74450513          	addi	a0,a0,1860 # 80062ea0 <tickslock>
    80003764:	ffffd097          	auipc	ra,0xffffd
    80003768:	662080e7          	jalr	1634(ra) # 80000dc6 <release>
  return 0;
    8000376c:	4501                	li	a0,0
}
    8000376e:	70e2                	ld	ra,56(sp)
    80003770:	7442                	ld	s0,48(sp)
    80003772:	7902                	ld	s2,32(sp)
    80003774:	6121                	addi	sp,sp,64
    80003776:	8082                	ret
      release(&tickslock);
    80003778:	0005f517          	auipc	a0,0x5f
    8000377c:	72850513          	addi	a0,a0,1832 # 80062ea0 <tickslock>
    80003780:	ffffd097          	auipc	ra,0xffffd
    80003784:	646080e7          	jalr	1606(ra) # 80000dc6 <release>
      return -1;
    80003788:	557d                	li	a0,-1
    8000378a:	74a2                	ld	s1,40(sp)
    8000378c:	69e2                	ld	s3,24(sp)
    8000378e:	b7c5                	j	8000376e <sys_sleep+0x8c>

0000000080003790 <sys_kill>:

uint64 sys_kill(void) {
    80003790:	1101                	addi	sp,sp,-32
    80003792:	ec06                	sd	ra,24(sp)
    80003794:	e822                	sd	s0,16(sp)
    80003796:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003798:	fec40593          	addi	a1,s0,-20
    8000379c:	4501                	li	a0,0
    8000379e:	00000097          	auipc	ra,0x0
    800037a2:	d9e080e7          	jalr	-610(ra) # 8000353c <argint>
  return kill(pid);
    800037a6:	fec42503          	lw	a0,-20(s0)
    800037aa:	fffff097          	auipc	ra,0xfffff
    800037ae:	3ae080e7          	jalr	942(ra) # 80002b58 <kill>
}
    800037b2:	60e2                	ld	ra,24(sp)
    800037b4:	6442                	ld	s0,16(sp)
    800037b6:	6105                	addi	sp,sp,32
    800037b8:	8082                	ret

00000000800037ba <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800037c4:	0005f517          	auipc	a0,0x5f
    800037c8:	6dc50513          	addi	a0,a0,1756 # 80062ea0 <tickslock>
    800037cc:	ffffd097          	auipc	ra,0xffffd
    800037d0:	54a080e7          	jalr	1354(ra) # 80000d16 <acquire>
  xticks = ticks;
    800037d4:	00009497          	auipc	s1,0x9
    800037d8:	42c4a483          	lw	s1,1068(s1) # 8000cc00 <ticks>
  release(&tickslock);
    800037dc:	0005f517          	auipc	a0,0x5f
    800037e0:	6c450513          	addi	a0,a0,1732 # 80062ea0 <tickslock>
    800037e4:	ffffd097          	auipc	ra,0xffffd
    800037e8:	5e2080e7          	jalr	1506(ra) # 80000dc6 <release>
  return xticks;
}
    800037ec:	02049513          	slli	a0,s1,0x20
    800037f0:	9101                	srli	a0,a0,0x20
    800037f2:	60e2                	ld	ra,24(sp)
    800037f4:	6442                	ld	s0,16(sp)
    800037f6:	64a2                	ld	s1,8(sp)
    800037f8:	6105                	addi	sp,sp,32
    800037fa:	8082                	ret

00000000800037fc <sys_spoon>:

uint64 sys_spoon(void) {
    800037fc:	1101                	addi	sp,sp,-32
    800037fe:	ec06                	sd	ra,24(sp)
    80003800:	e822                	sd	s0,16(sp)
    80003802:	1000                	addi	s0,sp,32
  // obtain the argument from the stack, we need some special handling
  uint64 addr;
  argaddr(0, &addr);
    80003804:	fe840593          	addi	a1,s0,-24
    80003808:	4501                	li	a0,0
    8000380a:	00000097          	auipc	ra,0x0
    8000380e:	d52080e7          	jalr	-686(ra) # 8000355c <argaddr>
  return spoon((void *)addr);
    80003812:	fe843503          	ld	a0,-24(s0)
    80003816:	fffff097          	auipc	ra,0xfffff
    8000381a:	7d8080e7          	jalr	2008(ra) # 80002fee <spoon>
}
    8000381e:	60e2                	ld	ra,24(sp)
    80003820:	6442                	ld	s0,16(sp)
    80003822:	6105                	addi	sp,sp,32
    80003824:	8082                	ret

0000000080003826 <sys_create_thread>:

uint64 sys_create_thread(void *arg) {
    80003826:	7179                	addi	sp,sp,-48
    80003828:	f406                	sd	ra,40(sp)
    8000382a:	f022                	sd	s0,32(sp)
    8000382c:	1800                	addi	s0,sp,48
  uint64 fn_addr, args_addr, stack_addr, exit_fn;
  argaddr(0, &fn_addr);
    8000382e:	fe840593          	addi	a1,s0,-24
    80003832:	4501                	li	a0,0
    80003834:	00000097          	auipc	ra,0x0
    80003838:	d28080e7          	jalr	-728(ra) # 8000355c <argaddr>
  argaddr(1, &args_addr);
    8000383c:	fe040593          	addi	a1,s0,-32
    80003840:	4505                	li	a0,1
    80003842:	00000097          	auipc	ra,0x0
    80003846:	d1a080e7          	jalr	-742(ra) # 8000355c <argaddr>
  argaddr(2, &stack_addr);
    8000384a:	fd840593          	addi	a1,s0,-40
    8000384e:	4509                	li	a0,2
    80003850:	00000097          	auipc	ra,0x0
    80003854:	d0c080e7          	jalr	-756(ra) # 8000355c <argaddr>
  argaddr(3, &exit_fn);
    80003858:	fd040593          	addi	a1,s0,-48
    8000385c:	450d                	li	a0,3
    8000385e:	00000097          	auipc	ra,0x0
    80003862:	cfe080e7          	jalr	-770(ra) # 8000355c <argaddr>
  return create_thread((void *)fn_addr, (void *)args_addr, (void *)stack_addr,
    80003866:	fd043683          	ld	a3,-48(s0)
    8000386a:	fd843603          	ld	a2,-40(s0)
    8000386e:	fe043583          	ld	a1,-32(s0)
    80003872:	fe843503          	ld	a0,-24(s0)
    80003876:	fffff097          	auipc	ra,0xfffff
    8000387a:	bf4080e7          	jalr	-1036(ra) # 8000246a <create_thread>
                       (void *)exit_fn);
}
    8000387e:	70a2                	ld	ra,40(sp)
    80003880:	7402                	ld	s0,32(sp)
    80003882:	6145                	addi	sp,sp,48
    80003884:	8082                	ret

0000000080003886 <sys_join_thread>:

uint64 sys_join_thread(void *arg) {
    80003886:	1101                	addi	sp,sp,-32
    80003888:	ec06                	sd	ra,24(sp)
    8000388a:	e822                	sd	s0,16(sp)
    8000388c:	1000                	addi	s0,sp,32
  uint64 thread_id, status_addr;
  argaddr(0, &thread_id);
    8000388e:	fe840593          	addi	a1,s0,-24
    80003892:	4501                	li	a0,0
    80003894:	00000097          	auipc	ra,0x0
    80003898:	cc8080e7          	jalr	-824(ra) # 8000355c <argaddr>
  argaddr(1, &status_addr);
    8000389c:	fe040593          	addi	a1,s0,-32
    800038a0:	4505                	li	a0,1
    800038a2:	00000097          	auipc	ra,0x0
    800038a6:	cba080e7          	jalr	-838(ra) # 8000355c <argaddr>
  return join_thread(thread_id, status_addr);
    800038aa:	fe043583          	ld	a1,-32(s0)
    800038ae:	fe843503          	ld	a0,-24(s0)
    800038b2:	fffff097          	auipc	ra,0xfffff
    800038b6:	376080e7          	jalr	886(ra) # 80002c28 <join_thread>
}
    800038ba:	60e2                	ld	ra,24(sp)
    800038bc:	6442                	ld	s0,16(sp)
    800038be:	6105                	addi	sp,sp,32
    800038c0:	8082                	ret

00000000800038c2 <sys_thread_exit>:

uint64 sys_thread_exit(void *arg) {
    800038c2:	1101                	addi	sp,sp,-32
    800038c4:	ec06                	sd	ra,24(sp)
    800038c6:	e822                	sd	s0,16(sp)
    800038c8:	1000                	addi	s0,sp,32
  uint64 status_addr;
  argaddr(0, &status_addr);
    800038ca:	fe840593          	addi	a1,s0,-24
    800038ce:	4501                	li	a0,0
    800038d0:	00000097          	auipc	ra,0x0
    800038d4:	c8c080e7          	jalr	-884(ra) # 8000355c <argaddr>
  return thread_exit(status_addr);
    800038d8:	fe843503          	ld	a0,-24(s0)
    800038dc:	fffff097          	auipc	ra,0xfffff
    800038e0:	028080e7          	jalr	40(ra) # 80002904 <thread_exit>
}
    800038e4:	60e2                	ld	ra,24(sp)
    800038e6:	6442                	ld	s0,16(sp)
    800038e8:	6105                	addi	sp,sp,32
    800038ea:	8082                	ret

00000000800038ec <sys_bind>:

uint64 sys_bind(void *arg) {
    800038ec:	7139                	addi	sp,sp,-64
    800038ee:	fc06                	sd	ra,56(sp)
    800038f0:	f822                	sd	s0,48(sp)
    800038f2:	f426                	sd	s1,40(sp)
    800038f4:	0080                	addi	s0,sp,64
  uint64 address_family, protocol;
  struct sockaddr address;
  argaddr(0, &address_family);
    800038f6:	fd840593          	addi	a1,s0,-40
    800038fa:	4501                	li	a0,0
    800038fc:	00000097          	auipc	ra,0x0
    80003900:	c60080e7          	jalr	-928(ra) # 8000355c <argaddr>
  argaddr(1, (uint64 *)&address);
    80003904:	fc040493          	addi	s1,s0,-64
    80003908:	85a6                	mv	a1,s1
    8000390a:	4505                	li	a0,1
    8000390c:	00000097          	auipc	ra,0x0
    80003910:	c50080e7          	jalr	-944(ra) # 8000355c <argaddr>
  argaddr(2, &protocol);
    80003914:	fd040593          	addi	a1,s0,-48
    80003918:	4509                	li	a0,2
    8000391a:	00000097          	auipc	ra,0x0
    8000391e:	c42080e7          	jalr	-958(ra) # 8000355c <argaddr>
  return bind(address_family, &address, protocol);
    80003922:	fd042603          	lw	a2,-48(s0)
    80003926:	85a6                	mv	a1,s1
    80003928:	fd842503          	lw	a0,-40(s0)
    8000392c:	00004097          	auipc	ra,0x4
    80003930:	e7a080e7          	jalr	-390(ra) # 800077a6 <bind>
}
    80003934:	70e2                	ld	ra,56(sp)
    80003936:	7442                	ld	s0,48(sp)
    80003938:	74a2                	ld	s1,40(sp)
    8000393a:	6121                	addi	sp,sp,64
    8000393c:	8082                	ret

000000008000393e <sys_listen>:

uint64 sys_listen(void *arg) {
    8000393e:	1101                	addi	sp,sp,-32
    80003940:	ec06                	sd	ra,24(sp)
    80003942:	e822                	sd	s0,16(sp)
    80003944:	1000                	addi	s0,sp,32
  uint64 socket, backlog;
  argaddr(0, &socket);
    80003946:	fe840593          	addi	a1,s0,-24
    8000394a:	4501                	li	a0,0
    8000394c:	00000097          	auipc	ra,0x0
    80003950:	c10080e7          	jalr	-1008(ra) # 8000355c <argaddr>
  argaddr(1, &backlog);
    80003954:	fe040593          	addi	a1,s0,-32
    80003958:	4505                	li	a0,1
    8000395a:	00000097          	auipc	ra,0x0
    8000395e:	c02080e7          	jalr	-1022(ra) # 8000355c <argaddr>
  return listen(socket, backlog);
    80003962:	fe042583          	lw	a1,-32(s0)
    80003966:	fe842503          	lw	a0,-24(s0)
    8000396a:	00004097          	auipc	ra,0x4
    8000396e:	e4e080e7          	jalr	-434(ra) # 800077b8 <listen>
}
    80003972:	60e2                	ld	ra,24(sp)
    80003974:	6442                	ld	s0,16(sp)
    80003976:	6105                	addi	sp,sp,32
    80003978:	8082                	ret

000000008000397a <sys_accept>:

uint64 sys_accept(void *arg) {
    8000397a:	7139                	addi	sp,sp,-64
    8000397c:	fc06                	sd	ra,56(sp)
    8000397e:	f822                	sd	s0,48(sp)
    80003980:	f426                	sd	s1,40(sp)
    80003982:	0080                	addi	s0,sp,64
  uint64 socket;
  uint64 address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    80003984:	fd840593          	addi	a1,s0,-40
    80003988:	4501                	li	a0,0
    8000398a:	00000097          	auipc	ra,0x0
    8000398e:	bd2080e7          	jalr	-1070(ra) # 8000355c <argaddr>
  argaddr(1, (uint64 *)&address);
    80003992:	fc040493          	addi	s1,s0,-64
    80003996:	85a6                	mv	a1,s1
    80003998:	4505                	li	a0,1
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	bc2080e7          	jalr	-1086(ra) # 8000355c <argaddr>
  argaddr(2, &address_len);
    800039a2:	fd040593          	addi	a1,s0,-48
    800039a6:	4509                	li	a0,2
    800039a8:	00000097          	auipc	ra,0x0
    800039ac:	bb4080e7          	jalr	-1100(ra) # 8000355c <argaddr>
  return accept(socket, &address, address_len);
    800039b0:	fd042603          	lw	a2,-48(s0)
    800039b4:	85a6                	mv	a1,s1
    800039b6:	fd842503          	lw	a0,-40(s0)
    800039ba:	00004097          	auipc	ra,0x4
    800039be:	e10080e7          	jalr	-496(ra) # 800077ca <accept>
}
    800039c2:	70e2                	ld	ra,56(sp)
    800039c4:	7442                	ld	s0,48(sp)
    800039c6:	74a2                	ld	s1,40(sp)
    800039c8:	6121                	addi	sp,sp,64
    800039ca:	8082                	ret

00000000800039cc <sys_socket>:

uint64 sys_socket(void *arg) {
    800039cc:	7179                	addi	sp,sp,-48
    800039ce:	f406                	sd	ra,40(sp)
    800039d0:	f022                	sd	s0,32(sp)
    800039d2:	1800                	addi	s0,sp,48
  uint64 address_family, address_socktype, protocol;
  argaddr(0, &address_family);
    800039d4:	fe840593          	addi	a1,s0,-24
    800039d8:	4501                	li	a0,0
    800039da:	00000097          	auipc	ra,0x0
    800039de:	b82080e7          	jalr	-1150(ra) # 8000355c <argaddr>
  argaddr(1, &address_socktype);
    800039e2:	fe040593          	addi	a1,s0,-32
    800039e6:	4505                	li	a0,1
    800039e8:	00000097          	auipc	ra,0x0
    800039ec:	b74080e7          	jalr	-1164(ra) # 8000355c <argaddr>
  argaddr(2, &protocol);
    800039f0:	fd840593          	addi	a1,s0,-40
    800039f4:	4509                	li	a0,2
    800039f6:	00000097          	auipc	ra,0x0
    800039fa:	b66080e7          	jalr	-1178(ra) # 8000355c <argaddr>
  return socket(address_family, address_socktype, protocol);
    800039fe:	fd842603          	lw	a2,-40(s0)
    80003a02:	fe042583          	lw	a1,-32(s0)
    80003a06:	fe842503          	lw	a0,-24(s0)
    80003a0a:	00004097          	auipc	ra,0x4
    80003a0e:	d8a080e7          	jalr	-630(ra) # 80007794 <socket>
}
    80003a12:	70a2                	ld	ra,40(sp)
    80003a14:	7402                	ld	s0,32(sp)
    80003a16:	6145                	addi	sp,sp,48
    80003a18:	8082                	ret

0000000080003a1a <sys_connect>:

uint64 sys_connect(void *arg) {
    80003a1a:	7139                	addi	sp,sp,-64
    80003a1c:	fc06                	sd	ra,56(sp)
    80003a1e:	f822                	sd	s0,48(sp)
    80003a20:	f426                	sd	s1,40(sp)
    80003a22:	0080                	addi	s0,sp,64
  uint64 socket, address_len;
  struct sockaddr address;
  argaddr(0, &socket);
    80003a24:	fd840593          	addi	a1,s0,-40
    80003a28:	4501                	li	a0,0
    80003a2a:	00000097          	auipc	ra,0x0
    80003a2e:	b32080e7          	jalr	-1230(ra) # 8000355c <argaddr>
  argaddr(1, (uint64 *)&address);
    80003a32:	fc040493          	addi	s1,s0,-64
    80003a36:	85a6                	mv	a1,s1
    80003a38:	4505                	li	a0,1
    80003a3a:	00000097          	auipc	ra,0x0
    80003a3e:	b22080e7          	jalr	-1246(ra) # 8000355c <argaddr>
  argaddr(2, &address_len);
    80003a42:	fd040593          	addi	a1,s0,-48
    80003a46:	4509                	li	a0,2
    80003a48:	00000097          	auipc	ra,0x0
    80003a4c:	b14080e7          	jalr	-1260(ra) # 8000355c <argaddr>
  return connect(socket, &address, address_len);
    80003a50:	fd042603          	lw	a2,-48(s0)
    80003a54:	85a6                	mv	a1,s1
    80003a56:	fd842503          	lw	a0,-40(s0)
    80003a5a:	00004097          	auipc	ra,0x4
    80003a5e:	d82080e7          	jalr	-638(ra) # 800077dc <connect>
}
    80003a62:	70e2                	ld	ra,56(sp)
    80003a64:	7442                	ld	s0,48(sp)
    80003a66:	74a2                	ld	s1,40(sp)
    80003a68:	6121                	addi	sp,sp,64
    80003a6a:	8082                	ret

0000000080003a6c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003a6c:	7179                	addi	sp,sp,-48
    80003a6e:	f406                	sd	ra,40(sp)
    80003a70:	f022                	sd	s0,32(sp)
    80003a72:	ec26                	sd	s1,24(sp)
    80003a74:	e84a                	sd	s2,16(sp)
    80003a76:	e44e                	sd	s3,8(sp)
    80003a78:	e052                	sd	s4,0(sp)
    80003a7a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003a7c:	00006597          	auipc	a1,0x6
    80003a80:	a5c58593          	addi	a1,a1,-1444 # 800094d8 <etext+0x4d8>
    80003a84:	0005f517          	auipc	a0,0x5f
    80003a88:	43450513          	addi	a0,a0,1076 # 80062eb8 <bcache>
    80003a8c:	ffffd097          	auipc	ra,0xffffd
    80003a90:	1f6080e7          	jalr	502(ra) # 80000c82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003a94:	00067797          	auipc	a5,0x67
    80003a98:	42478793          	addi	a5,a5,1060 # 8006aeb8 <bcache+0x8000>
    80003a9c:	00067717          	auipc	a4,0x67
    80003aa0:	68470713          	addi	a4,a4,1668 # 8006b120 <bcache+0x8268>
    80003aa4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003aa8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003aac:	0005f497          	auipc	s1,0x5f
    80003ab0:	42448493          	addi	s1,s1,1060 # 80062ed0 <bcache+0x18>
    b->next = bcache.head.next;
    80003ab4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003ab6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003ab8:	00006a17          	auipc	s4,0x6
    80003abc:	a28a0a13          	addi	s4,s4,-1496 # 800094e0 <etext+0x4e0>
    b->next = bcache.head.next;
    80003ac0:	2b893783          	ld	a5,696(s2)
    80003ac4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003ac6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003aca:	85d2                	mv	a1,s4
    80003acc:	01048513          	addi	a0,s1,16
    80003ad0:	00001097          	auipc	ra,0x1
    80003ad4:	4e4080e7          	jalr	1252(ra) # 80004fb4 <initsleeplock>
    bcache.head.next->prev = b;
    80003ad8:	2b893783          	ld	a5,696(s2)
    80003adc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003ade:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003ae2:	45848493          	addi	s1,s1,1112
    80003ae6:	fd349de3          	bne	s1,s3,80003ac0 <binit+0x54>
  }
}
    80003aea:	70a2                	ld	ra,40(sp)
    80003aec:	7402                	ld	s0,32(sp)
    80003aee:	64e2                	ld	s1,24(sp)
    80003af0:	6942                	ld	s2,16(sp)
    80003af2:	69a2                	ld	s3,8(sp)
    80003af4:	6a02                	ld	s4,0(sp)
    80003af6:	6145                	addi	sp,sp,48
    80003af8:	8082                	ret

0000000080003afa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003afa:	7179                	addi	sp,sp,-48
    80003afc:	f406                	sd	ra,40(sp)
    80003afe:	f022                	sd	s0,32(sp)
    80003b00:	ec26                	sd	s1,24(sp)
    80003b02:	e84a                	sd	s2,16(sp)
    80003b04:	e44e                	sd	s3,8(sp)
    80003b06:	1800                	addi	s0,sp,48
    80003b08:	892a                	mv	s2,a0
    80003b0a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003b0c:	0005f517          	auipc	a0,0x5f
    80003b10:	3ac50513          	addi	a0,a0,940 # 80062eb8 <bcache>
    80003b14:	ffffd097          	auipc	ra,0xffffd
    80003b18:	202080e7          	jalr	514(ra) # 80000d16 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003b1c:	00067497          	auipc	s1,0x67
    80003b20:	6544b483          	ld	s1,1620(s1) # 8006b170 <bcache+0x82b8>
    80003b24:	00067797          	auipc	a5,0x67
    80003b28:	5fc78793          	addi	a5,a5,1532 # 8006b120 <bcache+0x8268>
    80003b2c:	02f48f63          	beq	s1,a5,80003b6a <bread+0x70>
    80003b30:	873e                	mv	a4,a5
    80003b32:	a021                	j	80003b3a <bread+0x40>
    80003b34:	68a4                	ld	s1,80(s1)
    80003b36:	02e48a63          	beq	s1,a4,80003b6a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003b3a:	449c                	lw	a5,8(s1)
    80003b3c:	ff279ce3          	bne	a5,s2,80003b34 <bread+0x3a>
    80003b40:	44dc                	lw	a5,12(s1)
    80003b42:	ff3799e3          	bne	a5,s3,80003b34 <bread+0x3a>
      b->refcnt++;
    80003b46:	40bc                	lw	a5,64(s1)
    80003b48:	2785                	addiw	a5,a5,1
    80003b4a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003b4c:	0005f517          	auipc	a0,0x5f
    80003b50:	36c50513          	addi	a0,a0,876 # 80062eb8 <bcache>
    80003b54:	ffffd097          	auipc	ra,0xffffd
    80003b58:	272080e7          	jalr	626(ra) # 80000dc6 <release>
      acquiresleep(&b->lock);
    80003b5c:	01048513          	addi	a0,s1,16
    80003b60:	00001097          	auipc	ra,0x1
    80003b64:	48e080e7          	jalr	1166(ra) # 80004fee <acquiresleep>
      return b;
    80003b68:	a8b9                	j	80003bc6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003b6a:	00067497          	auipc	s1,0x67
    80003b6e:	5fe4b483          	ld	s1,1534(s1) # 8006b168 <bcache+0x82b0>
    80003b72:	00067797          	auipc	a5,0x67
    80003b76:	5ae78793          	addi	a5,a5,1454 # 8006b120 <bcache+0x8268>
    80003b7a:	00f48863          	beq	s1,a5,80003b8a <bread+0x90>
    80003b7e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003b80:	40bc                	lw	a5,64(s1)
    80003b82:	cf81                	beqz	a5,80003b9a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003b84:	64a4                	ld	s1,72(s1)
    80003b86:	fee49de3          	bne	s1,a4,80003b80 <bread+0x86>
  panic("bget: no buffers");
    80003b8a:	00006517          	auipc	a0,0x6
    80003b8e:	95e50513          	addi	a0,a0,-1698 # 800094e8 <etext+0x4e8>
    80003b92:	ffffd097          	auipc	ra,0xffffd
    80003b96:	9ce080e7          	jalr	-1586(ra) # 80000560 <panic>
      b->dev = dev;
    80003b9a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003b9e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003ba2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003ba6:	4785                	li	a5,1
    80003ba8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003baa:	0005f517          	auipc	a0,0x5f
    80003bae:	30e50513          	addi	a0,a0,782 # 80062eb8 <bcache>
    80003bb2:	ffffd097          	auipc	ra,0xffffd
    80003bb6:	214080e7          	jalr	532(ra) # 80000dc6 <release>
      acquiresleep(&b->lock);
    80003bba:	01048513          	addi	a0,s1,16
    80003bbe:	00001097          	auipc	ra,0x1
    80003bc2:	430080e7          	jalr	1072(ra) # 80004fee <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003bc6:	409c                	lw	a5,0(s1)
    80003bc8:	cb89                	beqz	a5,80003bda <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003bca:	8526                	mv	a0,s1
    80003bcc:	70a2                	ld	ra,40(sp)
    80003bce:	7402                	ld	s0,32(sp)
    80003bd0:	64e2                	ld	s1,24(sp)
    80003bd2:	6942                	ld	s2,16(sp)
    80003bd4:	69a2                	ld	s3,8(sp)
    80003bd6:	6145                	addi	sp,sp,48
    80003bd8:	8082                	ret
    virtio_disk_rw(b, 0);
    80003bda:	4581                	li	a1,0
    80003bdc:	8526                	mv	a0,s1
    80003bde:	00003097          	auipc	ra,0x3
    80003be2:	10c080e7          	jalr	268(ra) # 80006cea <virtio_disk_rw>
    b->valid = 1;
    80003be6:	4785                	li	a5,1
    80003be8:	c09c                	sw	a5,0(s1)
  return b;
    80003bea:	b7c5                	j	80003bca <bread+0xd0>

0000000080003bec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003bec:	1101                	addi	sp,sp,-32
    80003bee:	ec06                	sd	ra,24(sp)
    80003bf0:	e822                	sd	s0,16(sp)
    80003bf2:	e426                	sd	s1,8(sp)
    80003bf4:	1000                	addi	s0,sp,32
    80003bf6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003bf8:	0541                	addi	a0,a0,16
    80003bfa:	00001097          	auipc	ra,0x1
    80003bfe:	48e080e7          	jalr	1166(ra) # 80005088 <holdingsleep>
    80003c02:	cd01                	beqz	a0,80003c1a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003c04:	4585                	li	a1,1
    80003c06:	8526                	mv	a0,s1
    80003c08:	00003097          	auipc	ra,0x3
    80003c0c:	0e2080e7          	jalr	226(ra) # 80006cea <virtio_disk_rw>
}
    80003c10:	60e2                	ld	ra,24(sp)
    80003c12:	6442                	ld	s0,16(sp)
    80003c14:	64a2                	ld	s1,8(sp)
    80003c16:	6105                	addi	sp,sp,32
    80003c18:	8082                	ret
    panic("bwrite");
    80003c1a:	00006517          	auipc	a0,0x6
    80003c1e:	8e650513          	addi	a0,a0,-1818 # 80009500 <etext+0x500>
    80003c22:	ffffd097          	auipc	ra,0xffffd
    80003c26:	93e080e7          	jalr	-1730(ra) # 80000560 <panic>

0000000080003c2a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003c2a:	1101                	addi	sp,sp,-32
    80003c2c:	ec06                	sd	ra,24(sp)
    80003c2e:	e822                	sd	s0,16(sp)
    80003c30:	e426                	sd	s1,8(sp)
    80003c32:	e04a                	sd	s2,0(sp)
    80003c34:	1000                	addi	s0,sp,32
    80003c36:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003c38:	01050913          	addi	s2,a0,16
    80003c3c:	854a                	mv	a0,s2
    80003c3e:	00001097          	auipc	ra,0x1
    80003c42:	44a080e7          	jalr	1098(ra) # 80005088 <holdingsleep>
    80003c46:	c535                	beqz	a0,80003cb2 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003c48:	854a                	mv	a0,s2
    80003c4a:	00001097          	auipc	ra,0x1
    80003c4e:	3fa080e7          	jalr	1018(ra) # 80005044 <releasesleep>

  acquire(&bcache.lock);
    80003c52:	0005f517          	auipc	a0,0x5f
    80003c56:	26650513          	addi	a0,a0,614 # 80062eb8 <bcache>
    80003c5a:	ffffd097          	auipc	ra,0xffffd
    80003c5e:	0bc080e7          	jalr	188(ra) # 80000d16 <acquire>
  b->refcnt--;
    80003c62:	40bc                	lw	a5,64(s1)
    80003c64:	37fd                	addiw	a5,a5,-1
    80003c66:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003c68:	e79d                	bnez	a5,80003c96 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003c6a:	68b8                	ld	a4,80(s1)
    80003c6c:	64bc                	ld	a5,72(s1)
    80003c6e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003c70:	68b8                	ld	a4,80(s1)
    80003c72:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003c74:	00067797          	auipc	a5,0x67
    80003c78:	24478793          	addi	a5,a5,580 # 8006aeb8 <bcache+0x8000>
    80003c7c:	2b87b703          	ld	a4,696(a5)
    80003c80:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003c82:	00067717          	auipc	a4,0x67
    80003c86:	49e70713          	addi	a4,a4,1182 # 8006b120 <bcache+0x8268>
    80003c8a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003c8c:	2b87b703          	ld	a4,696(a5)
    80003c90:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003c92:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003c96:	0005f517          	auipc	a0,0x5f
    80003c9a:	22250513          	addi	a0,a0,546 # 80062eb8 <bcache>
    80003c9e:	ffffd097          	auipc	ra,0xffffd
    80003ca2:	128080e7          	jalr	296(ra) # 80000dc6 <release>
}
    80003ca6:	60e2                	ld	ra,24(sp)
    80003ca8:	6442                	ld	s0,16(sp)
    80003caa:	64a2                	ld	s1,8(sp)
    80003cac:	6902                	ld	s2,0(sp)
    80003cae:	6105                	addi	sp,sp,32
    80003cb0:	8082                	ret
    panic("brelse");
    80003cb2:	00006517          	auipc	a0,0x6
    80003cb6:	85650513          	addi	a0,a0,-1962 # 80009508 <etext+0x508>
    80003cba:	ffffd097          	auipc	ra,0xffffd
    80003cbe:	8a6080e7          	jalr	-1882(ra) # 80000560 <panic>

0000000080003cc2 <bpin>:

void
bpin(struct buf *b) {
    80003cc2:	1101                	addi	sp,sp,-32
    80003cc4:	ec06                	sd	ra,24(sp)
    80003cc6:	e822                	sd	s0,16(sp)
    80003cc8:	e426                	sd	s1,8(sp)
    80003cca:	1000                	addi	s0,sp,32
    80003ccc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003cce:	0005f517          	auipc	a0,0x5f
    80003cd2:	1ea50513          	addi	a0,a0,490 # 80062eb8 <bcache>
    80003cd6:	ffffd097          	auipc	ra,0xffffd
    80003cda:	040080e7          	jalr	64(ra) # 80000d16 <acquire>
  b->refcnt++;
    80003cde:	40bc                	lw	a5,64(s1)
    80003ce0:	2785                	addiw	a5,a5,1
    80003ce2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003ce4:	0005f517          	auipc	a0,0x5f
    80003ce8:	1d450513          	addi	a0,a0,468 # 80062eb8 <bcache>
    80003cec:	ffffd097          	auipc	ra,0xffffd
    80003cf0:	0da080e7          	jalr	218(ra) # 80000dc6 <release>
}
    80003cf4:	60e2                	ld	ra,24(sp)
    80003cf6:	6442                	ld	s0,16(sp)
    80003cf8:	64a2                	ld	s1,8(sp)
    80003cfa:	6105                	addi	sp,sp,32
    80003cfc:	8082                	ret

0000000080003cfe <bunpin>:

void
bunpin(struct buf *b) {
    80003cfe:	1101                	addi	sp,sp,-32
    80003d00:	ec06                	sd	ra,24(sp)
    80003d02:	e822                	sd	s0,16(sp)
    80003d04:	e426                	sd	s1,8(sp)
    80003d06:	1000                	addi	s0,sp,32
    80003d08:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003d0a:	0005f517          	auipc	a0,0x5f
    80003d0e:	1ae50513          	addi	a0,a0,430 # 80062eb8 <bcache>
    80003d12:	ffffd097          	auipc	ra,0xffffd
    80003d16:	004080e7          	jalr	4(ra) # 80000d16 <acquire>
  b->refcnt--;
    80003d1a:	40bc                	lw	a5,64(s1)
    80003d1c:	37fd                	addiw	a5,a5,-1
    80003d1e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003d20:	0005f517          	auipc	a0,0x5f
    80003d24:	19850513          	addi	a0,a0,408 # 80062eb8 <bcache>
    80003d28:	ffffd097          	auipc	ra,0xffffd
    80003d2c:	09e080e7          	jalr	158(ra) # 80000dc6 <release>
}
    80003d30:	60e2                	ld	ra,24(sp)
    80003d32:	6442                	ld	s0,16(sp)
    80003d34:	64a2                	ld	s1,8(sp)
    80003d36:	6105                	addi	sp,sp,32
    80003d38:	8082                	ret

0000000080003d3a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003d3a:	1101                	addi	sp,sp,-32
    80003d3c:	ec06                	sd	ra,24(sp)
    80003d3e:	e822                	sd	s0,16(sp)
    80003d40:	e426                	sd	s1,8(sp)
    80003d42:	e04a                	sd	s2,0(sp)
    80003d44:	1000                	addi	s0,sp,32
    80003d46:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003d48:	00d5d79b          	srliw	a5,a1,0xd
    80003d4c:	00068597          	auipc	a1,0x68
    80003d50:	8485a583          	lw	a1,-1976(a1) # 8006b594 <sb+0x1c>
    80003d54:	9dbd                	addw	a1,a1,a5
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	da4080e7          	jalr	-604(ra) # 80003afa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003d5e:	0074f713          	andi	a4,s1,7
    80003d62:	4785                	li	a5,1
    80003d64:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003d68:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003d6a:	90d9                	srli	s1,s1,0x36
    80003d6c:	00950733          	add	a4,a0,s1
    80003d70:	05874703          	lbu	a4,88(a4)
    80003d74:	00e7f6b3          	and	a3,a5,a4
    80003d78:	c69d                	beqz	a3,80003da6 <bfree+0x6c>
    80003d7a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003d7c:	94aa                	add	s1,s1,a0
    80003d7e:	fff7c793          	not	a5,a5
    80003d82:	8f7d                	and	a4,a4,a5
    80003d84:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003d88:	00001097          	auipc	ra,0x1
    80003d8c:	148080e7          	jalr	328(ra) # 80004ed0 <log_write>
  brelse(bp);
    80003d90:	854a                	mv	a0,s2
    80003d92:	00000097          	auipc	ra,0x0
    80003d96:	e98080e7          	jalr	-360(ra) # 80003c2a <brelse>
}
    80003d9a:	60e2                	ld	ra,24(sp)
    80003d9c:	6442                	ld	s0,16(sp)
    80003d9e:	64a2                	ld	s1,8(sp)
    80003da0:	6902                	ld	s2,0(sp)
    80003da2:	6105                	addi	sp,sp,32
    80003da4:	8082                	ret
    panic("freeing free block");
    80003da6:	00005517          	auipc	a0,0x5
    80003daa:	76a50513          	addi	a0,a0,1898 # 80009510 <etext+0x510>
    80003dae:	ffffc097          	auipc	ra,0xffffc
    80003db2:	7b2080e7          	jalr	1970(ra) # 80000560 <panic>

0000000080003db6 <balloc>:
{
    80003db6:	715d                	addi	sp,sp,-80
    80003db8:	e486                	sd	ra,72(sp)
    80003dba:	e0a2                	sd	s0,64(sp)
    80003dbc:	fc26                	sd	s1,56(sp)
    80003dbe:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003dc0:	00067797          	auipc	a5,0x67
    80003dc4:	7bc7a783          	lw	a5,1980(a5) # 8006b57c <sb+0x4>
    80003dc8:	10078863          	beqz	a5,80003ed8 <balloc+0x122>
    80003dcc:	f84a                	sd	s2,48(sp)
    80003dce:	f44e                	sd	s3,40(sp)
    80003dd0:	f052                	sd	s4,32(sp)
    80003dd2:	ec56                	sd	s5,24(sp)
    80003dd4:	e85a                	sd	s6,16(sp)
    80003dd6:	e45e                	sd	s7,8(sp)
    80003dd8:	e062                	sd	s8,0(sp)
    80003dda:	8baa                	mv	s7,a0
    80003ddc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003dde:	00067b17          	auipc	s6,0x67
    80003de2:	79ab0b13          	addi	s6,s6,1946 # 8006b578 <sb>
      m = 1 << (bi % 8);
    80003de6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003de8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003dea:	6c09                	lui	s8,0x2
    80003dec:	a049                	j	80003e6e <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003dee:	97ca                	add	a5,a5,s2
    80003df0:	8e55                	or	a2,a2,a3
    80003df2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003df6:	854a                	mv	a0,s2
    80003df8:	00001097          	auipc	ra,0x1
    80003dfc:	0d8080e7          	jalr	216(ra) # 80004ed0 <log_write>
        brelse(bp);
    80003e00:	854a                	mv	a0,s2
    80003e02:	00000097          	auipc	ra,0x0
    80003e06:	e28080e7          	jalr	-472(ra) # 80003c2a <brelse>
  bp = bread(dev, bno);
    80003e0a:	85a6                	mv	a1,s1
    80003e0c:	855e                	mv	a0,s7
    80003e0e:	00000097          	auipc	ra,0x0
    80003e12:	cec080e7          	jalr	-788(ra) # 80003afa <bread>
    80003e16:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003e18:	40000613          	li	a2,1024
    80003e1c:	4581                	li	a1,0
    80003e1e:	05850513          	addi	a0,a0,88
    80003e22:	ffffd097          	auipc	ra,0xffffd
    80003e26:	fec080e7          	jalr	-20(ra) # 80000e0e <memset>
  log_write(bp);
    80003e2a:	854a                	mv	a0,s2
    80003e2c:	00001097          	auipc	ra,0x1
    80003e30:	0a4080e7          	jalr	164(ra) # 80004ed0 <log_write>
  brelse(bp);
    80003e34:	854a                	mv	a0,s2
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	df4080e7          	jalr	-524(ra) # 80003c2a <brelse>
}
    80003e3e:	7942                	ld	s2,48(sp)
    80003e40:	79a2                	ld	s3,40(sp)
    80003e42:	7a02                	ld	s4,32(sp)
    80003e44:	6ae2                	ld	s5,24(sp)
    80003e46:	6b42                	ld	s6,16(sp)
    80003e48:	6ba2                	ld	s7,8(sp)
    80003e4a:	6c02                	ld	s8,0(sp)
}
    80003e4c:	8526                	mv	a0,s1
    80003e4e:	60a6                	ld	ra,72(sp)
    80003e50:	6406                	ld	s0,64(sp)
    80003e52:	74e2                	ld	s1,56(sp)
    80003e54:	6161                	addi	sp,sp,80
    80003e56:	8082                	ret
    brelse(bp);
    80003e58:	854a                	mv	a0,s2
    80003e5a:	00000097          	auipc	ra,0x0
    80003e5e:	dd0080e7          	jalr	-560(ra) # 80003c2a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003e62:	015c0abb          	addw	s5,s8,s5
    80003e66:	004b2783          	lw	a5,4(s6)
    80003e6a:	06faf063          	bgeu	s5,a5,80003eca <balloc+0x114>
    bp = bread(dev, BBLOCK(b, sb));
    80003e6e:	41fad79b          	sraiw	a5,s5,0x1f
    80003e72:	0137d79b          	srliw	a5,a5,0x13
    80003e76:	015787bb          	addw	a5,a5,s5
    80003e7a:	40d7d79b          	sraiw	a5,a5,0xd
    80003e7e:	01cb2583          	lw	a1,28(s6)
    80003e82:	9dbd                	addw	a1,a1,a5
    80003e84:	855e                	mv	a0,s7
    80003e86:	00000097          	auipc	ra,0x0
    80003e8a:	c74080e7          	jalr	-908(ra) # 80003afa <bread>
    80003e8e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003e90:	004b2503          	lw	a0,4(s6)
    80003e94:	84d6                	mv	s1,s5
    80003e96:	4701                	li	a4,0
    80003e98:	fca4f0e3          	bgeu	s1,a0,80003e58 <balloc+0xa2>
      m = 1 << (bi % 8);
    80003e9c:	00777693          	andi	a3,a4,7
    80003ea0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003ea4:	41f7579b          	sraiw	a5,a4,0x1f
    80003ea8:	01d7d79b          	srliw	a5,a5,0x1d
    80003eac:	9fb9                	addw	a5,a5,a4
    80003eae:	4037d79b          	sraiw	a5,a5,0x3
    80003eb2:	00f90633          	add	a2,s2,a5
    80003eb6:	05864603          	lbu	a2,88(a2)
    80003eba:	00c6f5b3          	and	a1,a3,a2
    80003ebe:	d985                	beqz	a1,80003dee <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003ec0:	2705                	addiw	a4,a4,1
    80003ec2:	2485                	addiw	s1,s1,1
    80003ec4:	fd471ae3          	bne	a4,s4,80003e98 <balloc+0xe2>
    80003ec8:	bf41                	j	80003e58 <balloc+0xa2>
    80003eca:	7942                	ld	s2,48(sp)
    80003ecc:	79a2                	ld	s3,40(sp)
    80003ece:	7a02                	ld	s4,32(sp)
    80003ed0:	6ae2                	ld	s5,24(sp)
    80003ed2:	6b42                	ld	s6,16(sp)
    80003ed4:	6ba2                	ld	s7,8(sp)
    80003ed6:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003ed8:	00005517          	auipc	a0,0x5
    80003edc:	65050513          	addi	a0,a0,1616 # 80009528 <etext+0x528>
    80003ee0:	ffffc097          	auipc	ra,0xffffc
    80003ee4:	6ca080e7          	jalr	1738(ra) # 800005aa <printf>
  return 0;
    80003ee8:	4481                	li	s1,0
    80003eea:	b78d                	j	80003e4c <balloc+0x96>

0000000080003eec <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003eec:	7179                	addi	sp,sp,-48
    80003eee:	f406                	sd	ra,40(sp)
    80003ef0:	f022                	sd	s0,32(sp)
    80003ef2:	ec26                	sd	s1,24(sp)
    80003ef4:	e84a                	sd	s2,16(sp)
    80003ef6:	e44e                	sd	s3,8(sp)
    80003ef8:	1800                	addi	s0,sp,48
    80003efa:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003efc:	47ad                	li	a5,11
    80003efe:	02b7e563          	bltu	a5,a1,80003f28 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003f02:	02059793          	slli	a5,a1,0x20
    80003f06:	01e7d593          	srli	a1,a5,0x1e
    80003f0a:	00b504b3          	add	s1,a0,a1
    80003f0e:	0504a903          	lw	s2,80(s1)
    80003f12:	06091b63          	bnez	s2,80003f88 <bmap+0x9c>
      addr = balloc(ip->dev);
    80003f16:	4108                	lw	a0,0(a0)
    80003f18:	00000097          	auipc	ra,0x0
    80003f1c:	e9e080e7          	jalr	-354(ra) # 80003db6 <balloc>
    80003f20:	892a                	mv	s2,a0
      if(addr == 0)
    80003f22:	c13d                	beqz	a0,80003f88 <bmap+0x9c>
        return 0;
      ip->addrs[bn] = addr;
    80003f24:	c8a8                	sw	a0,80(s1)
    80003f26:	a08d                	j	80003f88 <bmap+0x9c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003f28:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80003f2c:	0ff00793          	li	a5,255
    80003f30:	0897e363          	bltu	a5,s1,80003fb6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003f34:	08052903          	lw	s2,128(a0)
    80003f38:	00091d63          	bnez	s2,80003f52 <bmap+0x66>
      addr = balloc(ip->dev);
    80003f3c:	4108                	lw	a0,0(a0)
    80003f3e:	00000097          	auipc	ra,0x0
    80003f42:	e78080e7          	jalr	-392(ra) # 80003db6 <balloc>
    80003f46:	892a                	mv	s2,a0
      if(addr == 0)
    80003f48:	c121                	beqz	a0,80003f88 <bmap+0x9c>
    80003f4a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003f4c:	08a9a023          	sw	a0,128(s3)
    80003f50:	a011                	j	80003f54 <bmap+0x68>
    80003f52:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003f54:	85ca                	mv	a1,s2
    80003f56:	0009a503          	lw	a0,0(s3)
    80003f5a:	00000097          	auipc	ra,0x0
    80003f5e:	ba0080e7          	jalr	-1120(ra) # 80003afa <bread>
    80003f62:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003f64:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003f68:	02049713          	slli	a4,s1,0x20
    80003f6c:	01e75593          	srli	a1,a4,0x1e
    80003f70:	00b784b3          	add	s1,a5,a1
    80003f74:	0004a903          	lw	s2,0(s1)
    80003f78:	02090063          	beqz	s2,80003f98 <bmap+0xac>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003f7c:	8552                	mv	a0,s4
    80003f7e:	00000097          	auipc	ra,0x0
    80003f82:	cac080e7          	jalr	-852(ra) # 80003c2a <brelse>
    return addr;
    80003f86:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003f88:	854a                	mv	a0,s2
    80003f8a:	70a2                	ld	ra,40(sp)
    80003f8c:	7402                	ld	s0,32(sp)
    80003f8e:	64e2                	ld	s1,24(sp)
    80003f90:	6942                	ld	s2,16(sp)
    80003f92:	69a2                	ld	s3,8(sp)
    80003f94:	6145                	addi	sp,sp,48
    80003f96:	8082                	ret
      addr = balloc(ip->dev);
    80003f98:	0009a503          	lw	a0,0(s3)
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	e1a080e7          	jalr	-486(ra) # 80003db6 <balloc>
    80003fa4:	892a                	mv	s2,a0
      if(addr){
    80003fa6:	d979                	beqz	a0,80003f7c <bmap+0x90>
        a[bn] = addr;
    80003fa8:	c088                	sw	a0,0(s1)
        log_write(bp);
    80003faa:	8552                	mv	a0,s4
    80003fac:	00001097          	auipc	ra,0x1
    80003fb0:	f24080e7          	jalr	-220(ra) # 80004ed0 <log_write>
    80003fb4:	b7e1                	j	80003f7c <bmap+0x90>
    80003fb6:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003fb8:	00005517          	auipc	a0,0x5
    80003fbc:	58850513          	addi	a0,a0,1416 # 80009540 <etext+0x540>
    80003fc0:	ffffc097          	auipc	ra,0xffffc
    80003fc4:	5a0080e7          	jalr	1440(ra) # 80000560 <panic>

0000000080003fc8 <iget>:
{
    80003fc8:	7179                	addi	sp,sp,-48
    80003fca:	f406                	sd	ra,40(sp)
    80003fcc:	f022                	sd	s0,32(sp)
    80003fce:	ec26                	sd	s1,24(sp)
    80003fd0:	e84a                	sd	s2,16(sp)
    80003fd2:	e44e                	sd	s3,8(sp)
    80003fd4:	e052                	sd	s4,0(sp)
    80003fd6:	1800                	addi	s0,sp,48
    80003fd8:	89aa                	mv	s3,a0
    80003fda:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003fdc:	00067517          	auipc	a0,0x67
    80003fe0:	5bc50513          	addi	a0,a0,1468 # 8006b598 <itable>
    80003fe4:	ffffd097          	auipc	ra,0xffffd
    80003fe8:	d32080e7          	jalr	-718(ra) # 80000d16 <acquire>
  empty = 0;
    80003fec:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003fee:	00067497          	auipc	s1,0x67
    80003ff2:	5c248493          	addi	s1,s1,1474 # 8006b5b0 <itable+0x18>
    80003ff6:	00069697          	auipc	a3,0x69
    80003ffa:	04a68693          	addi	a3,a3,74 # 8006d040 <log>
    80003ffe:	a039                	j	8000400c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004000:	02090b63          	beqz	s2,80004036 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004004:	08848493          	addi	s1,s1,136
    80004008:	02d48a63          	beq	s1,a3,8000403c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000400c:	449c                	lw	a5,8(s1)
    8000400e:	fef059e3          	blez	a5,80004000 <iget+0x38>
    80004012:	4098                	lw	a4,0(s1)
    80004014:	ff3716e3          	bne	a4,s3,80004000 <iget+0x38>
    80004018:	40d8                	lw	a4,4(s1)
    8000401a:	ff4713e3          	bne	a4,s4,80004000 <iget+0x38>
      ip->ref++;
    8000401e:	2785                	addiw	a5,a5,1
    80004020:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80004022:	00067517          	auipc	a0,0x67
    80004026:	57650513          	addi	a0,a0,1398 # 8006b598 <itable>
    8000402a:	ffffd097          	auipc	ra,0xffffd
    8000402e:	d9c080e7          	jalr	-612(ra) # 80000dc6 <release>
      return ip;
    80004032:	8926                	mv	s2,s1
    80004034:	a03d                	j	80004062 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004036:	f7f9                	bnez	a5,80004004 <iget+0x3c>
      empty = ip;
    80004038:	8926                	mv	s2,s1
    8000403a:	b7e9                	j	80004004 <iget+0x3c>
  if(empty == 0)
    8000403c:	02090c63          	beqz	s2,80004074 <iget+0xac>
  ip->dev = dev;
    80004040:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004044:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80004048:	4785                	li	a5,1
    8000404a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000404e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80004052:	00067517          	auipc	a0,0x67
    80004056:	54650513          	addi	a0,a0,1350 # 8006b598 <itable>
    8000405a:	ffffd097          	auipc	ra,0xffffd
    8000405e:	d6c080e7          	jalr	-660(ra) # 80000dc6 <release>
}
    80004062:	854a                	mv	a0,s2
    80004064:	70a2                	ld	ra,40(sp)
    80004066:	7402                	ld	s0,32(sp)
    80004068:	64e2                	ld	s1,24(sp)
    8000406a:	6942                	ld	s2,16(sp)
    8000406c:	69a2                	ld	s3,8(sp)
    8000406e:	6a02                	ld	s4,0(sp)
    80004070:	6145                	addi	sp,sp,48
    80004072:	8082                	ret
    panic("iget: no inodes");
    80004074:	00005517          	auipc	a0,0x5
    80004078:	4e450513          	addi	a0,a0,1252 # 80009558 <etext+0x558>
    8000407c:	ffffc097          	auipc	ra,0xffffc
    80004080:	4e4080e7          	jalr	1252(ra) # 80000560 <panic>

0000000080004084 <fsinit>:
fsinit(int dev) {
    80004084:	7179                	addi	sp,sp,-48
    80004086:	f406                	sd	ra,40(sp)
    80004088:	f022                	sd	s0,32(sp)
    8000408a:	ec26                	sd	s1,24(sp)
    8000408c:	e84a                	sd	s2,16(sp)
    8000408e:	e44e                	sd	s3,8(sp)
    80004090:	1800                	addi	s0,sp,48
    80004092:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80004094:	4585                	li	a1,1
    80004096:	00000097          	auipc	ra,0x0
    8000409a:	a64080e7          	jalr	-1436(ra) # 80003afa <bread>
    8000409e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800040a0:	00067997          	auipc	s3,0x67
    800040a4:	4d898993          	addi	s3,s3,1240 # 8006b578 <sb>
    800040a8:	02000613          	li	a2,32
    800040ac:	05850593          	addi	a1,a0,88
    800040b0:	854e                	mv	a0,s3
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	dc0080e7          	jalr	-576(ra) # 80000e72 <memmove>
  brelse(bp);
    800040ba:	8526                	mv	a0,s1
    800040bc:	00000097          	auipc	ra,0x0
    800040c0:	b6e080e7          	jalr	-1170(ra) # 80003c2a <brelse>
  if(sb.magic != FSMAGIC)
    800040c4:	0009a703          	lw	a4,0(s3)
    800040c8:	102037b7          	lui	a5,0x10203
    800040cc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800040d0:	02f71263          	bne	a4,a5,800040f4 <fsinit+0x70>
  initlog(dev, &sb);
    800040d4:	00067597          	auipc	a1,0x67
    800040d8:	4a458593          	addi	a1,a1,1188 # 8006b578 <sb>
    800040dc:	854a                	mv	a0,s2
    800040de:	00001097          	auipc	ra,0x1
    800040e2:	b7c080e7          	jalr	-1156(ra) # 80004c5a <initlog>
}
    800040e6:	70a2                	ld	ra,40(sp)
    800040e8:	7402                	ld	s0,32(sp)
    800040ea:	64e2                	ld	s1,24(sp)
    800040ec:	6942                	ld	s2,16(sp)
    800040ee:	69a2                	ld	s3,8(sp)
    800040f0:	6145                	addi	sp,sp,48
    800040f2:	8082                	ret
    panic("invalid file system");
    800040f4:	00005517          	auipc	a0,0x5
    800040f8:	47450513          	addi	a0,a0,1140 # 80009568 <etext+0x568>
    800040fc:	ffffc097          	auipc	ra,0xffffc
    80004100:	464080e7          	jalr	1124(ra) # 80000560 <panic>

0000000080004104 <iinit>:
{
    80004104:	7179                	addi	sp,sp,-48
    80004106:	f406                	sd	ra,40(sp)
    80004108:	f022                	sd	s0,32(sp)
    8000410a:	ec26                	sd	s1,24(sp)
    8000410c:	e84a                	sd	s2,16(sp)
    8000410e:	e44e                	sd	s3,8(sp)
    80004110:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80004112:	00005597          	auipc	a1,0x5
    80004116:	46e58593          	addi	a1,a1,1134 # 80009580 <etext+0x580>
    8000411a:	00067517          	auipc	a0,0x67
    8000411e:	47e50513          	addi	a0,a0,1150 # 8006b598 <itable>
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	b60080e7          	jalr	-1184(ra) # 80000c82 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000412a:	00067497          	auipc	s1,0x67
    8000412e:	49648493          	addi	s1,s1,1174 # 8006b5c0 <itable+0x28>
    80004132:	00069997          	auipc	s3,0x69
    80004136:	f1e98993          	addi	s3,s3,-226 # 8006d050 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000413a:	00005917          	auipc	s2,0x5
    8000413e:	44e90913          	addi	s2,s2,1102 # 80009588 <etext+0x588>
    80004142:	85ca                	mv	a1,s2
    80004144:	8526                	mv	a0,s1
    80004146:	00001097          	auipc	ra,0x1
    8000414a:	e6e080e7          	jalr	-402(ra) # 80004fb4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000414e:	08848493          	addi	s1,s1,136
    80004152:	ff3498e3          	bne	s1,s3,80004142 <iinit+0x3e>
}
    80004156:	70a2                	ld	ra,40(sp)
    80004158:	7402                	ld	s0,32(sp)
    8000415a:	64e2                	ld	s1,24(sp)
    8000415c:	6942                	ld	s2,16(sp)
    8000415e:	69a2                	ld	s3,8(sp)
    80004160:	6145                	addi	sp,sp,48
    80004162:	8082                	ret

0000000080004164 <ialloc>:
{
    80004164:	7139                	addi	sp,sp,-64
    80004166:	fc06                	sd	ra,56(sp)
    80004168:	f822                	sd	s0,48(sp)
    8000416a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000416c:	00067717          	auipc	a4,0x67
    80004170:	41872703          	lw	a4,1048(a4) # 8006b584 <sb+0xc>
    80004174:	4785                	li	a5,1
    80004176:	06e7f463          	bgeu	a5,a4,800041de <ialloc+0x7a>
    8000417a:	f426                	sd	s1,40(sp)
    8000417c:	f04a                	sd	s2,32(sp)
    8000417e:	ec4e                	sd	s3,24(sp)
    80004180:	e852                	sd	s4,16(sp)
    80004182:	e456                	sd	s5,8(sp)
    80004184:	e05a                	sd	s6,0(sp)
    80004186:	8aaa                	mv	s5,a0
    80004188:	8b2e                	mv	s6,a1
    8000418a:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000418c:	00067a17          	auipc	s4,0x67
    80004190:	3eca0a13          	addi	s4,s4,1004 # 8006b578 <sb>
    80004194:	00495593          	srli	a1,s2,0x4
    80004198:	018a2783          	lw	a5,24(s4)
    8000419c:	9dbd                	addw	a1,a1,a5
    8000419e:	8556                	mv	a0,s5
    800041a0:	00000097          	auipc	ra,0x0
    800041a4:	95a080e7          	jalr	-1702(ra) # 80003afa <bread>
    800041a8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800041aa:	05850993          	addi	s3,a0,88
    800041ae:	00f97793          	andi	a5,s2,15
    800041b2:	079a                	slli	a5,a5,0x6
    800041b4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800041b6:	00099783          	lh	a5,0(s3)
    800041ba:	cf9d                	beqz	a5,800041f8 <ialloc+0x94>
    brelse(bp);
    800041bc:	00000097          	auipc	ra,0x0
    800041c0:	a6e080e7          	jalr	-1426(ra) # 80003c2a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800041c4:	0905                	addi	s2,s2,1
    800041c6:	00ca2703          	lw	a4,12(s4)
    800041ca:	0009079b          	sext.w	a5,s2
    800041ce:	fce7e3e3          	bltu	a5,a4,80004194 <ialloc+0x30>
    800041d2:	74a2                	ld	s1,40(sp)
    800041d4:	7902                	ld	s2,32(sp)
    800041d6:	69e2                	ld	s3,24(sp)
    800041d8:	6a42                	ld	s4,16(sp)
    800041da:	6aa2                	ld	s5,8(sp)
    800041dc:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800041de:	00005517          	auipc	a0,0x5
    800041e2:	3b250513          	addi	a0,a0,946 # 80009590 <etext+0x590>
    800041e6:	ffffc097          	auipc	ra,0xffffc
    800041ea:	3c4080e7          	jalr	964(ra) # 800005aa <printf>
  return 0;
    800041ee:	4501                	li	a0,0
}
    800041f0:	70e2                	ld	ra,56(sp)
    800041f2:	7442                	ld	s0,48(sp)
    800041f4:	6121                	addi	sp,sp,64
    800041f6:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800041f8:	04000613          	li	a2,64
    800041fc:	4581                	li	a1,0
    800041fe:	854e                	mv	a0,s3
    80004200:	ffffd097          	auipc	ra,0xffffd
    80004204:	c0e080e7          	jalr	-1010(ra) # 80000e0e <memset>
      dip->type = type;
    80004208:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000420c:	8526                	mv	a0,s1
    8000420e:	00001097          	auipc	ra,0x1
    80004212:	cc2080e7          	jalr	-830(ra) # 80004ed0 <log_write>
      brelse(bp);
    80004216:	8526                	mv	a0,s1
    80004218:	00000097          	auipc	ra,0x0
    8000421c:	a12080e7          	jalr	-1518(ra) # 80003c2a <brelse>
      return iget(dev, inum);
    80004220:	0009059b          	sext.w	a1,s2
    80004224:	8556                	mv	a0,s5
    80004226:	00000097          	auipc	ra,0x0
    8000422a:	da2080e7          	jalr	-606(ra) # 80003fc8 <iget>
    8000422e:	74a2                	ld	s1,40(sp)
    80004230:	7902                	ld	s2,32(sp)
    80004232:	69e2                	ld	s3,24(sp)
    80004234:	6a42                	ld	s4,16(sp)
    80004236:	6aa2                	ld	s5,8(sp)
    80004238:	6b02                	ld	s6,0(sp)
    8000423a:	bf5d                	j	800041f0 <ialloc+0x8c>

000000008000423c <iupdate>:
{
    8000423c:	1101                	addi	sp,sp,-32
    8000423e:	ec06                	sd	ra,24(sp)
    80004240:	e822                	sd	s0,16(sp)
    80004242:	e426                	sd	s1,8(sp)
    80004244:	e04a                	sd	s2,0(sp)
    80004246:	1000                	addi	s0,sp,32
    80004248:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000424a:	415c                	lw	a5,4(a0)
    8000424c:	0047d79b          	srliw	a5,a5,0x4
    80004250:	00067597          	auipc	a1,0x67
    80004254:	3405a583          	lw	a1,832(a1) # 8006b590 <sb+0x18>
    80004258:	9dbd                	addw	a1,a1,a5
    8000425a:	4108                	lw	a0,0(a0)
    8000425c:	00000097          	auipc	ra,0x0
    80004260:	89e080e7          	jalr	-1890(ra) # 80003afa <bread>
    80004264:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004266:	05850793          	addi	a5,a0,88
    8000426a:	40d8                	lw	a4,4(s1)
    8000426c:	8b3d                	andi	a4,a4,15
    8000426e:	071a                	slli	a4,a4,0x6
    80004270:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80004272:	04449703          	lh	a4,68(s1)
    80004276:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000427a:	04649703          	lh	a4,70(s1)
    8000427e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004282:	04849703          	lh	a4,72(s1)
    80004286:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000428a:	04a49703          	lh	a4,74(s1)
    8000428e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004292:	44f8                	lw	a4,76(s1)
    80004294:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004296:	03400613          	li	a2,52
    8000429a:	05048593          	addi	a1,s1,80
    8000429e:	00c78513          	addi	a0,a5,12
    800042a2:	ffffd097          	auipc	ra,0xffffd
    800042a6:	bd0080e7          	jalr	-1072(ra) # 80000e72 <memmove>
  log_write(bp);
    800042aa:	854a                	mv	a0,s2
    800042ac:	00001097          	auipc	ra,0x1
    800042b0:	c24080e7          	jalr	-988(ra) # 80004ed0 <log_write>
  brelse(bp);
    800042b4:	854a                	mv	a0,s2
    800042b6:	00000097          	auipc	ra,0x0
    800042ba:	974080e7          	jalr	-1676(ra) # 80003c2a <brelse>
}
    800042be:	60e2                	ld	ra,24(sp)
    800042c0:	6442                	ld	s0,16(sp)
    800042c2:	64a2                	ld	s1,8(sp)
    800042c4:	6902                	ld	s2,0(sp)
    800042c6:	6105                	addi	sp,sp,32
    800042c8:	8082                	ret

00000000800042ca <idup>:
{
    800042ca:	1101                	addi	sp,sp,-32
    800042cc:	ec06                	sd	ra,24(sp)
    800042ce:	e822                	sd	s0,16(sp)
    800042d0:	e426                	sd	s1,8(sp)
    800042d2:	1000                	addi	s0,sp,32
    800042d4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800042d6:	00067517          	auipc	a0,0x67
    800042da:	2c250513          	addi	a0,a0,706 # 8006b598 <itable>
    800042de:	ffffd097          	auipc	ra,0xffffd
    800042e2:	a38080e7          	jalr	-1480(ra) # 80000d16 <acquire>
  ip->ref++;
    800042e6:	449c                	lw	a5,8(s1)
    800042e8:	2785                	addiw	a5,a5,1
    800042ea:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800042ec:	00067517          	auipc	a0,0x67
    800042f0:	2ac50513          	addi	a0,a0,684 # 8006b598 <itable>
    800042f4:	ffffd097          	auipc	ra,0xffffd
    800042f8:	ad2080e7          	jalr	-1326(ra) # 80000dc6 <release>
}
    800042fc:	8526                	mv	a0,s1
    800042fe:	60e2                	ld	ra,24(sp)
    80004300:	6442                	ld	s0,16(sp)
    80004302:	64a2                	ld	s1,8(sp)
    80004304:	6105                	addi	sp,sp,32
    80004306:	8082                	ret

0000000080004308 <ilock>:
{
    80004308:	1101                	addi	sp,sp,-32
    8000430a:	ec06                	sd	ra,24(sp)
    8000430c:	e822                	sd	s0,16(sp)
    8000430e:	e426                	sd	s1,8(sp)
    80004310:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004312:	c10d                	beqz	a0,80004334 <ilock+0x2c>
    80004314:	84aa                	mv	s1,a0
    80004316:	451c                	lw	a5,8(a0)
    80004318:	00f05e63          	blez	a5,80004334 <ilock+0x2c>
  acquiresleep(&ip->lock);
    8000431c:	0541                	addi	a0,a0,16
    8000431e:	00001097          	auipc	ra,0x1
    80004322:	cd0080e7          	jalr	-816(ra) # 80004fee <acquiresleep>
  if(ip->valid == 0){
    80004326:	40bc                	lw	a5,64(s1)
    80004328:	cf99                	beqz	a5,80004346 <ilock+0x3e>
}
    8000432a:	60e2                	ld	ra,24(sp)
    8000432c:	6442                	ld	s0,16(sp)
    8000432e:	64a2                	ld	s1,8(sp)
    80004330:	6105                	addi	sp,sp,32
    80004332:	8082                	ret
    80004334:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80004336:	00005517          	auipc	a0,0x5
    8000433a:	27250513          	addi	a0,a0,626 # 800095a8 <etext+0x5a8>
    8000433e:	ffffc097          	auipc	ra,0xffffc
    80004342:	222080e7          	jalr	546(ra) # 80000560 <panic>
    80004346:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004348:	40dc                	lw	a5,4(s1)
    8000434a:	0047d79b          	srliw	a5,a5,0x4
    8000434e:	00067597          	auipc	a1,0x67
    80004352:	2425a583          	lw	a1,578(a1) # 8006b590 <sb+0x18>
    80004356:	9dbd                	addw	a1,a1,a5
    80004358:	4088                	lw	a0,0(s1)
    8000435a:	fffff097          	auipc	ra,0xfffff
    8000435e:	7a0080e7          	jalr	1952(ra) # 80003afa <bread>
    80004362:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004364:	05850593          	addi	a1,a0,88
    80004368:	40dc                	lw	a5,4(s1)
    8000436a:	8bbd                	andi	a5,a5,15
    8000436c:	079a                	slli	a5,a5,0x6
    8000436e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80004370:	00059783          	lh	a5,0(a1)
    80004374:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80004378:	00259783          	lh	a5,2(a1)
    8000437c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004380:	00459783          	lh	a5,4(a1)
    80004384:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004388:	00659783          	lh	a5,6(a1)
    8000438c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004390:	459c                	lw	a5,8(a1)
    80004392:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004394:	03400613          	li	a2,52
    80004398:	05b1                	addi	a1,a1,12
    8000439a:	05048513          	addi	a0,s1,80
    8000439e:	ffffd097          	auipc	ra,0xffffd
    800043a2:	ad4080e7          	jalr	-1324(ra) # 80000e72 <memmove>
    brelse(bp);
    800043a6:	854a                	mv	a0,s2
    800043a8:	00000097          	auipc	ra,0x0
    800043ac:	882080e7          	jalr	-1918(ra) # 80003c2a <brelse>
    ip->valid = 1;
    800043b0:	4785                	li	a5,1
    800043b2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800043b4:	04449783          	lh	a5,68(s1)
    800043b8:	c399                	beqz	a5,800043be <ilock+0xb6>
    800043ba:	6902                	ld	s2,0(sp)
    800043bc:	b7bd                	j	8000432a <ilock+0x22>
      panic("ilock: no type");
    800043be:	00005517          	auipc	a0,0x5
    800043c2:	1f250513          	addi	a0,a0,498 # 800095b0 <etext+0x5b0>
    800043c6:	ffffc097          	auipc	ra,0xffffc
    800043ca:	19a080e7          	jalr	410(ra) # 80000560 <panic>

00000000800043ce <iunlock>:
{
    800043ce:	1101                	addi	sp,sp,-32
    800043d0:	ec06                	sd	ra,24(sp)
    800043d2:	e822                	sd	s0,16(sp)
    800043d4:	e426                	sd	s1,8(sp)
    800043d6:	e04a                	sd	s2,0(sp)
    800043d8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800043da:	c905                	beqz	a0,8000440a <iunlock+0x3c>
    800043dc:	84aa                	mv	s1,a0
    800043de:	01050913          	addi	s2,a0,16
    800043e2:	854a                	mv	a0,s2
    800043e4:	00001097          	auipc	ra,0x1
    800043e8:	ca4080e7          	jalr	-860(ra) # 80005088 <holdingsleep>
    800043ec:	cd19                	beqz	a0,8000440a <iunlock+0x3c>
    800043ee:	449c                	lw	a5,8(s1)
    800043f0:	00f05d63          	blez	a5,8000440a <iunlock+0x3c>
  releasesleep(&ip->lock);
    800043f4:	854a                	mv	a0,s2
    800043f6:	00001097          	auipc	ra,0x1
    800043fa:	c4e080e7          	jalr	-946(ra) # 80005044 <releasesleep>
}
    800043fe:	60e2                	ld	ra,24(sp)
    80004400:	6442                	ld	s0,16(sp)
    80004402:	64a2                	ld	s1,8(sp)
    80004404:	6902                	ld	s2,0(sp)
    80004406:	6105                	addi	sp,sp,32
    80004408:	8082                	ret
    panic("iunlock");
    8000440a:	00005517          	auipc	a0,0x5
    8000440e:	1b650513          	addi	a0,a0,438 # 800095c0 <etext+0x5c0>
    80004412:	ffffc097          	auipc	ra,0xffffc
    80004416:	14e080e7          	jalr	334(ra) # 80000560 <panic>

000000008000441a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000441a:	7179                	addi	sp,sp,-48
    8000441c:	f406                	sd	ra,40(sp)
    8000441e:	f022                	sd	s0,32(sp)
    80004420:	ec26                	sd	s1,24(sp)
    80004422:	e84a                	sd	s2,16(sp)
    80004424:	e44e                	sd	s3,8(sp)
    80004426:	1800                	addi	s0,sp,48
    80004428:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000442a:	05050493          	addi	s1,a0,80
    8000442e:	08050913          	addi	s2,a0,128
    80004432:	a021                	j	8000443a <itrunc+0x20>
    80004434:	0491                	addi	s1,s1,4
    80004436:	01248d63          	beq	s1,s2,80004450 <itrunc+0x36>
    if(ip->addrs[i]){
    8000443a:	408c                	lw	a1,0(s1)
    8000443c:	dde5                	beqz	a1,80004434 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000443e:	0009a503          	lw	a0,0(s3)
    80004442:	00000097          	auipc	ra,0x0
    80004446:	8f8080e7          	jalr	-1800(ra) # 80003d3a <bfree>
      ip->addrs[i] = 0;
    8000444a:	0004a023          	sw	zero,0(s1)
    8000444e:	b7dd                	j	80004434 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004450:	0809a583          	lw	a1,128(s3)
    80004454:	ed99                	bnez	a1,80004472 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004456:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000445a:	854e                	mv	a0,s3
    8000445c:	00000097          	auipc	ra,0x0
    80004460:	de0080e7          	jalr	-544(ra) # 8000423c <iupdate>
}
    80004464:	70a2                	ld	ra,40(sp)
    80004466:	7402                	ld	s0,32(sp)
    80004468:	64e2                	ld	s1,24(sp)
    8000446a:	6942                	ld	s2,16(sp)
    8000446c:	69a2                	ld	s3,8(sp)
    8000446e:	6145                	addi	sp,sp,48
    80004470:	8082                	ret
    80004472:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004474:	0009a503          	lw	a0,0(s3)
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	682080e7          	jalr	1666(ra) # 80003afa <bread>
    80004480:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004482:	05850493          	addi	s1,a0,88
    80004486:	45850913          	addi	s2,a0,1112
    8000448a:	a021                	j	80004492 <itrunc+0x78>
    8000448c:	0491                	addi	s1,s1,4
    8000448e:	01248b63          	beq	s1,s2,800044a4 <itrunc+0x8a>
      if(a[j])
    80004492:	408c                	lw	a1,0(s1)
    80004494:	dde5                	beqz	a1,8000448c <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80004496:	0009a503          	lw	a0,0(s3)
    8000449a:	00000097          	auipc	ra,0x0
    8000449e:	8a0080e7          	jalr	-1888(ra) # 80003d3a <bfree>
    800044a2:	b7ed                	j	8000448c <itrunc+0x72>
    brelse(bp);
    800044a4:	8552                	mv	a0,s4
    800044a6:	fffff097          	auipc	ra,0xfffff
    800044aa:	784080e7          	jalr	1924(ra) # 80003c2a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800044ae:	0809a583          	lw	a1,128(s3)
    800044b2:	0009a503          	lw	a0,0(s3)
    800044b6:	00000097          	auipc	ra,0x0
    800044ba:	884080e7          	jalr	-1916(ra) # 80003d3a <bfree>
    ip->addrs[NDIRECT] = 0;
    800044be:	0809a023          	sw	zero,128(s3)
    800044c2:	6a02                	ld	s4,0(sp)
    800044c4:	bf49                	j	80004456 <itrunc+0x3c>

00000000800044c6 <iput>:
{
    800044c6:	1101                	addi	sp,sp,-32
    800044c8:	ec06                	sd	ra,24(sp)
    800044ca:	e822                	sd	s0,16(sp)
    800044cc:	e426                	sd	s1,8(sp)
    800044ce:	1000                	addi	s0,sp,32
    800044d0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800044d2:	00067517          	auipc	a0,0x67
    800044d6:	0c650513          	addi	a0,a0,198 # 8006b598 <itable>
    800044da:	ffffd097          	auipc	ra,0xffffd
    800044de:	83c080e7          	jalr	-1988(ra) # 80000d16 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800044e2:	4498                	lw	a4,8(s1)
    800044e4:	4785                	li	a5,1
    800044e6:	02f70263          	beq	a4,a5,8000450a <iput+0x44>
  ip->ref--;
    800044ea:	449c                	lw	a5,8(s1)
    800044ec:	37fd                	addiw	a5,a5,-1
    800044ee:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800044f0:	00067517          	auipc	a0,0x67
    800044f4:	0a850513          	addi	a0,a0,168 # 8006b598 <itable>
    800044f8:	ffffd097          	auipc	ra,0xffffd
    800044fc:	8ce080e7          	jalr	-1842(ra) # 80000dc6 <release>
}
    80004500:	60e2                	ld	ra,24(sp)
    80004502:	6442                	ld	s0,16(sp)
    80004504:	64a2                	ld	s1,8(sp)
    80004506:	6105                	addi	sp,sp,32
    80004508:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000450a:	40bc                	lw	a5,64(s1)
    8000450c:	dff9                	beqz	a5,800044ea <iput+0x24>
    8000450e:	04a49783          	lh	a5,74(s1)
    80004512:	ffe1                	bnez	a5,800044ea <iput+0x24>
    80004514:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80004516:	01048913          	addi	s2,s1,16
    8000451a:	854a                	mv	a0,s2
    8000451c:	00001097          	auipc	ra,0x1
    80004520:	ad2080e7          	jalr	-1326(ra) # 80004fee <acquiresleep>
    release(&itable.lock);
    80004524:	00067517          	auipc	a0,0x67
    80004528:	07450513          	addi	a0,a0,116 # 8006b598 <itable>
    8000452c:	ffffd097          	auipc	ra,0xffffd
    80004530:	89a080e7          	jalr	-1894(ra) # 80000dc6 <release>
    itrunc(ip);
    80004534:	8526                	mv	a0,s1
    80004536:	00000097          	auipc	ra,0x0
    8000453a:	ee4080e7          	jalr	-284(ra) # 8000441a <itrunc>
    ip->type = 0;
    8000453e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004542:	8526                	mv	a0,s1
    80004544:	00000097          	auipc	ra,0x0
    80004548:	cf8080e7          	jalr	-776(ra) # 8000423c <iupdate>
    ip->valid = 0;
    8000454c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004550:	854a                	mv	a0,s2
    80004552:	00001097          	auipc	ra,0x1
    80004556:	af2080e7          	jalr	-1294(ra) # 80005044 <releasesleep>
    acquire(&itable.lock);
    8000455a:	00067517          	auipc	a0,0x67
    8000455e:	03e50513          	addi	a0,a0,62 # 8006b598 <itable>
    80004562:	ffffc097          	auipc	ra,0xffffc
    80004566:	7b4080e7          	jalr	1972(ra) # 80000d16 <acquire>
    8000456a:	6902                	ld	s2,0(sp)
    8000456c:	bfbd                	j	800044ea <iput+0x24>

000000008000456e <iunlockput>:
{
    8000456e:	1101                	addi	sp,sp,-32
    80004570:	ec06                	sd	ra,24(sp)
    80004572:	e822                	sd	s0,16(sp)
    80004574:	e426                	sd	s1,8(sp)
    80004576:	1000                	addi	s0,sp,32
    80004578:	84aa                	mv	s1,a0
  iunlock(ip);
    8000457a:	00000097          	auipc	ra,0x0
    8000457e:	e54080e7          	jalr	-428(ra) # 800043ce <iunlock>
  iput(ip);
    80004582:	8526                	mv	a0,s1
    80004584:	00000097          	auipc	ra,0x0
    80004588:	f42080e7          	jalr	-190(ra) # 800044c6 <iput>
}
    8000458c:	60e2                	ld	ra,24(sp)
    8000458e:	6442                	ld	s0,16(sp)
    80004590:	64a2                	ld	s1,8(sp)
    80004592:	6105                	addi	sp,sp,32
    80004594:	8082                	ret

0000000080004596 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004596:	1141                	addi	sp,sp,-16
    80004598:	e406                	sd	ra,8(sp)
    8000459a:	e022                	sd	s0,0(sp)
    8000459c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000459e:	411c                	lw	a5,0(a0)
    800045a0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800045a2:	415c                	lw	a5,4(a0)
    800045a4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800045a6:	04451783          	lh	a5,68(a0)
    800045aa:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800045ae:	04a51783          	lh	a5,74(a0)
    800045b2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800045b6:	04c56783          	lwu	a5,76(a0)
    800045ba:	e99c                	sd	a5,16(a1)
}
    800045bc:	60a2                	ld	ra,8(sp)
    800045be:	6402                	ld	s0,0(sp)
    800045c0:	0141                	addi	sp,sp,16
    800045c2:	8082                	ret

00000000800045c4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800045c4:	457c                	lw	a5,76(a0)
    800045c6:	10d7e063          	bltu	a5,a3,800046c6 <readi+0x102>
{
    800045ca:	7159                	addi	sp,sp,-112
    800045cc:	f486                	sd	ra,104(sp)
    800045ce:	f0a2                	sd	s0,96(sp)
    800045d0:	eca6                	sd	s1,88(sp)
    800045d2:	e0d2                	sd	s4,64(sp)
    800045d4:	fc56                	sd	s5,56(sp)
    800045d6:	f85a                	sd	s6,48(sp)
    800045d8:	f45e                	sd	s7,40(sp)
    800045da:	1880                	addi	s0,sp,112
    800045dc:	8b2a                	mv	s6,a0
    800045de:	8bae                	mv	s7,a1
    800045e0:	8a32                	mv	s4,a2
    800045e2:	84b6                	mv	s1,a3
    800045e4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800045e6:	9f35                	addw	a4,a4,a3
    return 0;
    800045e8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800045ea:	0cd76563          	bltu	a4,a3,800046b4 <readi+0xf0>
    800045ee:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800045f0:	00e7f463          	bgeu	a5,a4,800045f8 <readi+0x34>
    n = ip->size - off;
    800045f4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800045f8:	0a0a8563          	beqz	s5,800046a2 <readi+0xde>
    800045fc:	e8ca                	sd	s2,80(sp)
    800045fe:	f062                	sd	s8,32(sp)
    80004600:	ec66                	sd	s9,24(sp)
    80004602:	e86a                	sd	s10,16(sp)
    80004604:	e46e                	sd	s11,8(sp)
    80004606:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004608:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000460c:	5c7d                	li	s8,-1
    8000460e:	a82d                	j	80004648 <readi+0x84>
    80004610:	020d1d93          	slli	s11,s10,0x20
    80004614:	020ddd93          	srli	s11,s11,0x20
    80004618:	05890613          	addi	a2,s2,88
    8000461c:	86ee                	mv	a3,s11
    8000461e:	963e                	add	a2,a2,a5
    80004620:	85d2                	mv	a1,s4
    80004622:	855e                	mv	a0,s7
    80004624:	fffff097          	auipc	ra,0xfffff
    80004628:	86e080e7          	jalr	-1938(ra) # 80002e92 <either_copyout>
    8000462c:	05850963          	beq	a0,s8,8000467e <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004630:	854a                	mv	a0,s2
    80004632:	fffff097          	auipc	ra,0xfffff
    80004636:	5f8080e7          	jalr	1528(ra) # 80003c2a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000463a:	013d09bb          	addw	s3,s10,s3
    8000463e:	009d04bb          	addw	s1,s10,s1
    80004642:	9a6e                	add	s4,s4,s11
    80004644:	0559f963          	bgeu	s3,s5,80004696 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80004648:	00a4d59b          	srliw	a1,s1,0xa
    8000464c:	855a                	mv	a0,s6
    8000464e:	00000097          	auipc	ra,0x0
    80004652:	89e080e7          	jalr	-1890(ra) # 80003eec <bmap>
    80004656:	85aa                	mv	a1,a0
    if(addr == 0)
    80004658:	c539                	beqz	a0,800046a6 <readi+0xe2>
    bp = bread(ip->dev, addr);
    8000465a:	000b2503          	lw	a0,0(s6)
    8000465e:	fffff097          	auipc	ra,0xfffff
    80004662:	49c080e7          	jalr	1180(ra) # 80003afa <bread>
    80004666:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004668:	3ff4f793          	andi	a5,s1,1023
    8000466c:	40fc873b          	subw	a4,s9,a5
    80004670:	413a86bb          	subw	a3,s5,s3
    80004674:	8d3a                	mv	s10,a4
    80004676:	f8e6fde3          	bgeu	a3,a4,80004610 <readi+0x4c>
    8000467a:	8d36                	mv	s10,a3
    8000467c:	bf51                	j	80004610 <readi+0x4c>
      brelse(bp);
    8000467e:	854a                	mv	a0,s2
    80004680:	fffff097          	auipc	ra,0xfffff
    80004684:	5aa080e7          	jalr	1450(ra) # 80003c2a <brelse>
      tot = -1;
    80004688:	59fd                	li	s3,-1
      break;
    8000468a:	6946                	ld	s2,80(sp)
    8000468c:	7c02                	ld	s8,32(sp)
    8000468e:	6ce2                	ld	s9,24(sp)
    80004690:	6d42                	ld	s10,16(sp)
    80004692:	6da2                	ld	s11,8(sp)
    80004694:	a831                	j	800046b0 <readi+0xec>
    80004696:	6946                	ld	s2,80(sp)
    80004698:	7c02                	ld	s8,32(sp)
    8000469a:	6ce2                	ld	s9,24(sp)
    8000469c:	6d42                	ld	s10,16(sp)
    8000469e:	6da2                	ld	s11,8(sp)
    800046a0:	a801                	j	800046b0 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800046a2:	89d6                	mv	s3,s5
    800046a4:	a031                	j	800046b0 <readi+0xec>
    800046a6:	6946                	ld	s2,80(sp)
    800046a8:	7c02                	ld	s8,32(sp)
    800046aa:	6ce2                	ld	s9,24(sp)
    800046ac:	6d42                	ld	s10,16(sp)
    800046ae:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800046b0:	854e                	mv	a0,s3
    800046b2:	69a6                	ld	s3,72(sp)
}
    800046b4:	70a6                	ld	ra,104(sp)
    800046b6:	7406                	ld	s0,96(sp)
    800046b8:	64e6                	ld	s1,88(sp)
    800046ba:	6a06                	ld	s4,64(sp)
    800046bc:	7ae2                	ld	s5,56(sp)
    800046be:	7b42                	ld	s6,48(sp)
    800046c0:	7ba2                	ld	s7,40(sp)
    800046c2:	6165                	addi	sp,sp,112
    800046c4:	8082                	ret
    return 0;
    800046c6:	4501                	li	a0,0
}
    800046c8:	8082                	ret

00000000800046ca <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800046ca:	457c                	lw	a5,76(a0)
    800046cc:	10d7e963          	bltu	a5,a3,800047de <writei+0x114>
{
    800046d0:	7159                	addi	sp,sp,-112
    800046d2:	f486                	sd	ra,104(sp)
    800046d4:	f0a2                	sd	s0,96(sp)
    800046d6:	e8ca                	sd	s2,80(sp)
    800046d8:	e0d2                	sd	s4,64(sp)
    800046da:	fc56                	sd	s5,56(sp)
    800046dc:	f85a                	sd	s6,48(sp)
    800046de:	f45e                	sd	s7,40(sp)
    800046e0:	1880                	addi	s0,sp,112
    800046e2:	8aaa                	mv	s5,a0
    800046e4:	8bae                	mv	s7,a1
    800046e6:	8a32                	mv	s4,a2
    800046e8:	8936                	mv	s2,a3
    800046ea:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800046ec:	00e687bb          	addw	a5,a3,a4
    800046f0:	0ed7e963          	bltu	a5,a3,800047e2 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800046f4:	00043737          	lui	a4,0x43
    800046f8:	0ef76763          	bltu	a4,a5,800047e6 <writei+0x11c>
    800046fc:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800046fe:	0c0b0863          	beqz	s6,800047ce <writei+0x104>
    80004702:	eca6                	sd	s1,88(sp)
    80004704:	f062                	sd	s8,32(sp)
    80004706:	ec66                	sd	s9,24(sp)
    80004708:	e86a                	sd	s10,16(sp)
    8000470a:	e46e                	sd	s11,8(sp)
    8000470c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000470e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004712:	5c7d                	li	s8,-1
    80004714:	a091                	j	80004758 <writei+0x8e>
    80004716:	020d1d93          	slli	s11,s10,0x20
    8000471a:	020ddd93          	srli	s11,s11,0x20
    8000471e:	05848513          	addi	a0,s1,88
    80004722:	86ee                	mv	a3,s11
    80004724:	8652                	mv	a2,s4
    80004726:	85de                	mv	a1,s7
    80004728:	953e                	add	a0,a0,a5
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	7be080e7          	jalr	1982(ra) # 80002ee8 <either_copyin>
    80004732:	05850e63          	beq	a0,s8,8000478e <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004736:	8526                	mv	a0,s1
    80004738:	00000097          	auipc	ra,0x0
    8000473c:	798080e7          	jalr	1944(ra) # 80004ed0 <log_write>
    brelse(bp);
    80004740:	8526                	mv	a0,s1
    80004742:	fffff097          	auipc	ra,0xfffff
    80004746:	4e8080e7          	jalr	1256(ra) # 80003c2a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000474a:	013d09bb          	addw	s3,s10,s3
    8000474e:	012d093b          	addw	s2,s10,s2
    80004752:	9a6e                	add	s4,s4,s11
    80004754:	0569f263          	bgeu	s3,s6,80004798 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80004758:	00a9559b          	srliw	a1,s2,0xa
    8000475c:	8556                	mv	a0,s5
    8000475e:	fffff097          	auipc	ra,0xfffff
    80004762:	78e080e7          	jalr	1934(ra) # 80003eec <bmap>
    80004766:	85aa                	mv	a1,a0
    if(addr == 0)
    80004768:	c905                	beqz	a0,80004798 <writei+0xce>
    bp = bread(ip->dev, addr);
    8000476a:	000aa503          	lw	a0,0(s5)
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	38c080e7          	jalr	908(ra) # 80003afa <bread>
    80004776:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004778:	3ff97793          	andi	a5,s2,1023
    8000477c:	40fc873b          	subw	a4,s9,a5
    80004780:	413b06bb          	subw	a3,s6,s3
    80004784:	8d3a                	mv	s10,a4
    80004786:	f8e6f8e3          	bgeu	a3,a4,80004716 <writei+0x4c>
    8000478a:	8d36                	mv	s10,a3
    8000478c:	b769                	j	80004716 <writei+0x4c>
      brelse(bp);
    8000478e:	8526                	mv	a0,s1
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	49a080e7          	jalr	1178(ra) # 80003c2a <brelse>
  }

  if(off > ip->size)
    80004798:	04caa783          	lw	a5,76(s5)
    8000479c:	0327fb63          	bgeu	a5,s2,800047d2 <writei+0x108>
    ip->size = off;
    800047a0:	052aa623          	sw	s2,76(s5)
    800047a4:	64e6                	ld	s1,88(sp)
    800047a6:	7c02                	ld	s8,32(sp)
    800047a8:	6ce2                	ld	s9,24(sp)
    800047aa:	6d42                	ld	s10,16(sp)
    800047ac:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800047ae:	8556                	mv	a0,s5
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	a8c080e7          	jalr	-1396(ra) # 8000423c <iupdate>

  return tot;
    800047b8:	854e                	mv	a0,s3
    800047ba:	69a6                	ld	s3,72(sp)
}
    800047bc:	70a6                	ld	ra,104(sp)
    800047be:	7406                	ld	s0,96(sp)
    800047c0:	6946                	ld	s2,80(sp)
    800047c2:	6a06                	ld	s4,64(sp)
    800047c4:	7ae2                	ld	s5,56(sp)
    800047c6:	7b42                	ld	s6,48(sp)
    800047c8:	7ba2                	ld	s7,40(sp)
    800047ca:	6165                	addi	sp,sp,112
    800047cc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800047ce:	89da                	mv	s3,s6
    800047d0:	bff9                	j	800047ae <writei+0xe4>
    800047d2:	64e6                	ld	s1,88(sp)
    800047d4:	7c02                	ld	s8,32(sp)
    800047d6:	6ce2                	ld	s9,24(sp)
    800047d8:	6d42                	ld	s10,16(sp)
    800047da:	6da2                	ld	s11,8(sp)
    800047dc:	bfc9                	j	800047ae <writei+0xe4>
    return -1;
    800047de:	557d                	li	a0,-1
}
    800047e0:	8082                	ret
    return -1;
    800047e2:	557d                	li	a0,-1
    800047e4:	bfe1                	j	800047bc <writei+0xf2>
    return -1;
    800047e6:	557d                	li	a0,-1
    800047e8:	bfd1                	j	800047bc <writei+0xf2>

00000000800047ea <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800047ea:	1141                	addi	sp,sp,-16
    800047ec:	e406                	sd	ra,8(sp)
    800047ee:	e022                	sd	s0,0(sp)
    800047f0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800047f2:	4639                	li	a2,14
    800047f4:	ffffc097          	auipc	ra,0xffffc
    800047f8:	6f6080e7          	jalr	1782(ra) # 80000eea <strncmp>
}
    800047fc:	60a2                	ld	ra,8(sp)
    800047fe:	6402                	ld	s0,0(sp)
    80004800:	0141                	addi	sp,sp,16
    80004802:	8082                	ret

0000000080004804 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004804:	711d                	addi	sp,sp,-96
    80004806:	ec86                	sd	ra,88(sp)
    80004808:	e8a2                	sd	s0,80(sp)
    8000480a:	e4a6                	sd	s1,72(sp)
    8000480c:	e0ca                	sd	s2,64(sp)
    8000480e:	fc4e                	sd	s3,56(sp)
    80004810:	f852                	sd	s4,48(sp)
    80004812:	f456                	sd	s5,40(sp)
    80004814:	f05a                	sd	s6,32(sp)
    80004816:	ec5e                	sd	s7,24(sp)
    80004818:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000481a:	04451703          	lh	a4,68(a0)
    8000481e:	4785                	li	a5,1
    80004820:	00f71f63          	bne	a4,a5,8000483e <dirlookup+0x3a>
    80004824:	892a                	mv	s2,a0
    80004826:	8aae                	mv	s5,a1
    80004828:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000482a:	457c                	lw	a5,76(a0)
    8000482c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000482e:	fa040a13          	addi	s4,s0,-96
    80004832:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80004834:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004838:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000483a:	e79d                	bnez	a5,80004868 <dirlookup+0x64>
    8000483c:	a88d                	j	800048ae <dirlookup+0xaa>
    panic("dirlookup not DIR");
    8000483e:	00005517          	auipc	a0,0x5
    80004842:	d8a50513          	addi	a0,a0,-630 # 800095c8 <etext+0x5c8>
    80004846:	ffffc097          	auipc	ra,0xffffc
    8000484a:	d1a080e7          	jalr	-742(ra) # 80000560 <panic>
      panic("dirlookup read");
    8000484e:	00005517          	auipc	a0,0x5
    80004852:	d9250513          	addi	a0,a0,-622 # 800095e0 <etext+0x5e0>
    80004856:	ffffc097          	auipc	ra,0xffffc
    8000485a:	d0a080e7          	jalr	-758(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000485e:	24c1                	addiw	s1,s1,16
    80004860:	04c92783          	lw	a5,76(s2)
    80004864:	04f4f463          	bgeu	s1,a5,800048ac <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004868:	874e                	mv	a4,s3
    8000486a:	86a6                	mv	a3,s1
    8000486c:	8652                	mv	a2,s4
    8000486e:	4581                	li	a1,0
    80004870:	854a                	mv	a0,s2
    80004872:	00000097          	auipc	ra,0x0
    80004876:	d52080e7          	jalr	-686(ra) # 800045c4 <readi>
    8000487a:	fd351ae3          	bne	a0,s3,8000484e <dirlookup+0x4a>
    if(de.inum == 0)
    8000487e:	fa045783          	lhu	a5,-96(s0)
    80004882:	dff1                	beqz	a5,8000485e <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80004884:	85da                	mv	a1,s6
    80004886:	8556                	mv	a0,s5
    80004888:	00000097          	auipc	ra,0x0
    8000488c:	f62080e7          	jalr	-158(ra) # 800047ea <namecmp>
    80004890:	f579                	bnez	a0,8000485e <dirlookup+0x5a>
      if(poff)
    80004892:	000b8463          	beqz	s7,8000489a <dirlookup+0x96>
        *poff = off;
    80004896:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000489a:	fa045583          	lhu	a1,-96(s0)
    8000489e:	00092503          	lw	a0,0(s2)
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	726080e7          	jalr	1830(ra) # 80003fc8 <iget>
    800048aa:	a011                	j	800048ae <dirlookup+0xaa>
  return 0;
    800048ac:	4501                	li	a0,0
}
    800048ae:	60e6                	ld	ra,88(sp)
    800048b0:	6446                	ld	s0,80(sp)
    800048b2:	64a6                	ld	s1,72(sp)
    800048b4:	6906                	ld	s2,64(sp)
    800048b6:	79e2                	ld	s3,56(sp)
    800048b8:	7a42                	ld	s4,48(sp)
    800048ba:	7aa2                	ld	s5,40(sp)
    800048bc:	7b02                	ld	s6,32(sp)
    800048be:	6be2                	ld	s7,24(sp)
    800048c0:	6125                	addi	sp,sp,96
    800048c2:	8082                	ret

00000000800048c4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800048c4:	711d                	addi	sp,sp,-96
    800048c6:	ec86                	sd	ra,88(sp)
    800048c8:	e8a2                	sd	s0,80(sp)
    800048ca:	e4a6                	sd	s1,72(sp)
    800048cc:	e0ca                	sd	s2,64(sp)
    800048ce:	fc4e                	sd	s3,56(sp)
    800048d0:	f852                	sd	s4,48(sp)
    800048d2:	f456                	sd	s5,40(sp)
    800048d4:	f05a                	sd	s6,32(sp)
    800048d6:	ec5e                	sd	s7,24(sp)
    800048d8:	e862                	sd	s8,16(sp)
    800048da:	e466                	sd	s9,8(sp)
    800048dc:	e06a                	sd	s10,0(sp)
    800048de:	1080                	addi	s0,sp,96
    800048e0:	84aa                	mv	s1,a0
    800048e2:	8b2e                	mv	s6,a1
    800048e4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800048e6:	00054703          	lbu	a4,0(a0)
    800048ea:	02f00793          	li	a5,47
    800048ee:	02f70363          	beq	a4,a5,80004914 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800048f2:	ffffd097          	auipc	ra,0xffffd
    800048f6:	630080e7          	jalr	1584(ra) # 80001f22 <myproc>
    800048fa:	15053503          	ld	a0,336(a0)
    800048fe:	00000097          	auipc	ra,0x0
    80004902:	9cc080e7          	jalr	-1588(ra) # 800042ca <idup>
    80004906:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004908:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000490c:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    8000490e:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004910:	4b85                	li	s7,1
    80004912:	a87d                	j	800049d0 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004914:	4585                	li	a1,1
    80004916:	852e                	mv	a0,a1
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	6b0080e7          	jalr	1712(ra) # 80003fc8 <iget>
    80004920:	8a2a                	mv	s4,a0
    80004922:	b7dd                	j	80004908 <namex+0x44>
      iunlockput(ip);
    80004924:	8552                	mv	a0,s4
    80004926:	00000097          	auipc	ra,0x0
    8000492a:	c48080e7          	jalr	-952(ra) # 8000456e <iunlockput>
      return 0;
    8000492e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004930:	8552                	mv	a0,s4
    80004932:	60e6                	ld	ra,88(sp)
    80004934:	6446                	ld	s0,80(sp)
    80004936:	64a6                	ld	s1,72(sp)
    80004938:	6906                	ld	s2,64(sp)
    8000493a:	79e2                	ld	s3,56(sp)
    8000493c:	7a42                	ld	s4,48(sp)
    8000493e:	7aa2                	ld	s5,40(sp)
    80004940:	7b02                	ld	s6,32(sp)
    80004942:	6be2                	ld	s7,24(sp)
    80004944:	6c42                	ld	s8,16(sp)
    80004946:	6ca2                	ld	s9,8(sp)
    80004948:	6d02                	ld	s10,0(sp)
    8000494a:	6125                	addi	sp,sp,96
    8000494c:	8082                	ret
      iunlock(ip);
    8000494e:	8552                	mv	a0,s4
    80004950:	00000097          	auipc	ra,0x0
    80004954:	a7e080e7          	jalr	-1410(ra) # 800043ce <iunlock>
      return ip;
    80004958:	bfe1                	j	80004930 <namex+0x6c>
      iunlockput(ip);
    8000495a:	8552                	mv	a0,s4
    8000495c:	00000097          	auipc	ra,0x0
    80004960:	c12080e7          	jalr	-1006(ra) # 8000456e <iunlockput>
      return 0;
    80004964:	8a4e                	mv	s4,s3
    80004966:	b7e9                	j	80004930 <namex+0x6c>
  len = path - s;
    80004968:	40998633          	sub	a2,s3,s1
    8000496c:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004970:	09ac5863          	bge	s8,s10,80004a00 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80004974:	8666                	mv	a2,s9
    80004976:	85a6                	mv	a1,s1
    80004978:	8556                	mv	a0,s5
    8000497a:	ffffc097          	auipc	ra,0xffffc
    8000497e:	4f8080e7          	jalr	1272(ra) # 80000e72 <memmove>
    80004982:	84ce                	mv	s1,s3
  while(*path == '/')
    80004984:	0004c783          	lbu	a5,0(s1)
    80004988:	01279763          	bne	a5,s2,80004996 <namex+0xd2>
    path++;
    8000498c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000498e:	0004c783          	lbu	a5,0(s1)
    80004992:	ff278de3          	beq	a5,s2,8000498c <namex+0xc8>
    ilock(ip);
    80004996:	8552                	mv	a0,s4
    80004998:	00000097          	auipc	ra,0x0
    8000499c:	970080e7          	jalr	-1680(ra) # 80004308 <ilock>
    if(ip->type != T_DIR){
    800049a0:	044a1783          	lh	a5,68(s4)
    800049a4:	f97790e3          	bne	a5,s7,80004924 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800049a8:	000b0563          	beqz	s6,800049b2 <namex+0xee>
    800049ac:	0004c783          	lbu	a5,0(s1)
    800049b0:	dfd9                	beqz	a5,8000494e <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800049b2:	4601                	li	a2,0
    800049b4:	85d6                	mv	a1,s5
    800049b6:	8552                	mv	a0,s4
    800049b8:	00000097          	auipc	ra,0x0
    800049bc:	e4c080e7          	jalr	-436(ra) # 80004804 <dirlookup>
    800049c0:	89aa                	mv	s3,a0
    800049c2:	dd41                	beqz	a0,8000495a <namex+0x96>
    iunlockput(ip);
    800049c4:	8552                	mv	a0,s4
    800049c6:	00000097          	auipc	ra,0x0
    800049ca:	ba8080e7          	jalr	-1112(ra) # 8000456e <iunlockput>
    ip = next;
    800049ce:	8a4e                	mv	s4,s3
  while(*path == '/')
    800049d0:	0004c783          	lbu	a5,0(s1)
    800049d4:	01279763          	bne	a5,s2,800049e2 <namex+0x11e>
    path++;
    800049d8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800049da:	0004c783          	lbu	a5,0(s1)
    800049de:	ff278de3          	beq	a5,s2,800049d8 <namex+0x114>
  if(*path == 0)
    800049e2:	cb9d                	beqz	a5,80004a18 <namex+0x154>
  while(*path != '/' && *path != 0)
    800049e4:	0004c783          	lbu	a5,0(s1)
    800049e8:	89a6                	mv	s3,s1
  len = path - s;
    800049ea:	4d01                	li	s10,0
    800049ec:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800049ee:	01278963          	beq	a5,s2,80004a00 <namex+0x13c>
    800049f2:	dbbd                	beqz	a5,80004968 <namex+0xa4>
    path++;
    800049f4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800049f6:	0009c783          	lbu	a5,0(s3)
    800049fa:	ff279ce3          	bne	a5,s2,800049f2 <namex+0x12e>
    800049fe:	b7ad                	j	80004968 <namex+0xa4>
    memmove(name, s, len);
    80004a00:	2601                	sext.w	a2,a2
    80004a02:	85a6                	mv	a1,s1
    80004a04:	8556                	mv	a0,s5
    80004a06:	ffffc097          	auipc	ra,0xffffc
    80004a0a:	46c080e7          	jalr	1132(ra) # 80000e72 <memmove>
    name[len] = 0;
    80004a0e:	9d56                	add	s10,s10,s5
    80004a10:	000d0023          	sb	zero,0(s10)
    80004a14:	84ce                	mv	s1,s3
    80004a16:	b7bd                	j	80004984 <namex+0xc0>
  if(nameiparent){
    80004a18:	f00b0ce3          	beqz	s6,80004930 <namex+0x6c>
    iput(ip);
    80004a1c:	8552                	mv	a0,s4
    80004a1e:	00000097          	auipc	ra,0x0
    80004a22:	aa8080e7          	jalr	-1368(ra) # 800044c6 <iput>
    return 0;
    80004a26:	4a01                	li	s4,0
    80004a28:	b721                	j	80004930 <namex+0x6c>

0000000080004a2a <dirlink>:
{
    80004a2a:	715d                	addi	sp,sp,-80
    80004a2c:	e486                	sd	ra,72(sp)
    80004a2e:	e0a2                	sd	s0,64(sp)
    80004a30:	f84a                	sd	s2,48(sp)
    80004a32:	ec56                	sd	s5,24(sp)
    80004a34:	e85a                	sd	s6,16(sp)
    80004a36:	0880                	addi	s0,sp,80
    80004a38:	892a                	mv	s2,a0
    80004a3a:	8aae                	mv	s5,a1
    80004a3c:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004a3e:	4601                	li	a2,0
    80004a40:	00000097          	auipc	ra,0x0
    80004a44:	dc4080e7          	jalr	-572(ra) # 80004804 <dirlookup>
    80004a48:	e129                	bnez	a0,80004a8a <dirlink+0x60>
    80004a4a:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a4c:	04c92483          	lw	s1,76(s2)
    80004a50:	cca9                	beqz	s1,80004aaa <dirlink+0x80>
    80004a52:	f44e                	sd	s3,40(sp)
    80004a54:	f052                	sd	s4,32(sp)
    80004a56:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a58:	fb040a13          	addi	s4,s0,-80
    80004a5c:	49c1                	li	s3,16
    80004a5e:	874e                	mv	a4,s3
    80004a60:	86a6                	mv	a3,s1
    80004a62:	8652                	mv	a2,s4
    80004a64:	4581                	li	a1,0
    80004a66:	854a                	mv	a0,s2
    80004a68:	00000097          	auipc	ra,0x0
    80004a6c:	b5c080e7          	jalr	-1188(ra) # 800045c4 <readi>
    80004a70:	03351363          	bne	a0,s3,80004a96 <dirlink+0x6c>
    if(de.inum == 0)
    80004a74:	fb045783          	lhu	a5,-80(s0)
    80004a78:	c79d                	beqz	a5,80004aa6 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a7a:	24c1                	addiw	s1,s1,16
    80004a7c:	04c92783          	lw	a5,76(s2)
    80004a80:	fcf4efe3          	bltu	s1,a5,80004a5e <dirlink+0x34>
    80004a84:	79a2                	ld	s3,40(sp)
    80004a86:	7a02                	ld	s4,32(sp)
    80004a88:	a00d                	j	80004aaa <dirlink+0x80>
    iput(ip);
    80004a8a:	00000097          	auipc	ra,0x0
    80004a8e:	a3c080e7          	jalr	-1476(ra) # 800044c6 <iput>
    return -1;
    80004a92:	557d                	li	a0,-1
    80004a94:	a0a9                	j	80004ade <dirlink+0xb4>
      panic("dirlink read");
    80004a96:	00005517          	auipc	a0,0x5
    80004a9a:	b5a50513          	addi	a0,a0,-1190 # 800095f0 <etext+0x5f0>
    80004a9e:	ffffc097          	auipc	ra,0xffffc
    80004aa2:	ac2080e7          	jalr	-1342(ra) # 80000560 <panic>
    80004aa6:	79a2                	ld	s3,40(sp)
    80004aa8:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004aaa:	4639                	li	a2,14
    80004aac:	85d6                	mv	a1,s5
    80004aae:	fb240513          	addi	a0,s0,-78
    80004ab2:	ffffc097          	auipc	ra,0xffffc
    80004ab6:	472080e7          	jalr	1138(ra) # 80000f24 <strncpy>
  de.inum = inum;
    80004aba:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004abe:	4741                	li	a4,16
    80004ac0:	86a6                	mv	a3,s1
    80004ac2:	fb040613          	addi	a2,s0,-80
    80004ac6:	4581                	li	a1,0
    80004ac8:	854a                	mv	a0,s2
    80004aca:	00000097          	auipc	ra,0x0
    80004ace:	c00080e7          	jalr	-1024(ra) # 800046ca <writei>
    80004ad2:	1541                	addi	a0,a0,-16
    80004ad4:	00a03533          	snez	a0,a0
    80004ad8:	40a0053b          	negw	a0,a0
    80004adc:	74e2                	ld	s1,56(sp)
}
    80004ade:	60a6                	ld	ra,72(sp)
    80004ae0:	6406                	ld	s0,64(sp)
    80004ae2:	7942                	ld	s2,48(sp)
    80004ae4:	6ae2                	ld	s5,24(sp)
    80004ae6:	6b42                	ld	s6,16(sp)
    80004ae8:	6161                	addi	sp,sp,80
    80004aea:	8082                	ret

0000000080004aec <namei>:

struct inode*
namei(char *path)
{
    80004aec:	1101                	addi	sp,sp,-32
    80004aee:	ec06                	sd	ra,24(sp)
    80004af0:	e822                	sd	s0,16(sp)
    80004af2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004af4:	fe040613          	addi	a2,s0,-32
    80004af8:	4581                	li	a1,0
    80004afa:	00000097          	auipc	ra,0x0
    80004afe:	dca080e7          	jalr	-566(ra) # 800048c4 <namex>
}
    80004b02:	60e2                	ld	ra,24(sp)
    80004b04:	6442                	ld	s0,16(sp)
    80004b06:	6105                	addi	sp,sp,32
    80004b08:	8082                	ret

0000000080004b0a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004b0a:	1141                	addi	sp,sp,-16
    80004b0c:	e406                	sd	ra,8(sp)
    80004b0e:	e022                	sd	s0,0(sp)
    80004b10:	0800                	addi	s0,sp,16
    80004b12:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004b14:	4585                	li	a1,1
    80004b16:	00000097          	auipc	ra,0x0
    80004b1a:	dae080e7          	jalr	-594(ra) # 800048c4 <namex>
}
    80004b1e:	60a2                	ld	ra,8(sp)
    80004b20:	6402                	ld	s0,0(sp)
    80004b22:	0141                	addi	sp,sp,16
    80004b24:	8082                	ret

0000000080004b26 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004b26:	1101                	addi	sp,sp,-32
    80004b28:	ec06                	sd	ra,24(sp)
    80004b2a:	e822                	sd	s0,16(sp)
    80004b2c:	e426                	sd	s1,8(sp)
    80004b2e:	e04a                	sd	s2,0(sp)
    80004b30:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004b32:	00068917          	auipc	s2,0x68
    80004b36:	50e90913          	addi	s2,s2,1294 # 8006d040 <log>
    80004b3a:	01892583          	lw	a1,24(s2)
    80004b3e:	02892503          	lw	a0,40(s2)
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	fb8080e7          	jalr	-72(ra) # 80003afa <bread>
    80004b4a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004b4c:	02c92603          	lw	a2,44(s2)
    80004b50:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004b52:	00c05f63          	blez	a2,80004b70 <write_head+0x4a>
    80004b56:	00068717          	auipc	a4,0x68
    80004b5a:	51a70713          	addi	a4,a4,1306 # 8006d070 <log+0x30>
    80004b5e:	87aa                	mv	a5,a0
    80004b60:	060a                	slli	a2,a2,0x2
    80004b62:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004b64:	4314                	lw	a3,0(a4)
    80004b66:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004b68:	0711                	addi	a4,a4,4
    80004b6a:	0791                	addi	a5,a5,4
    80004b6c:	fec79ce3          	bne	a5,a2,80004b64 <write_head+0x3e>
  }
  bwrite(buf);
    80004b70:	8526                	mv	a0,s1
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	07a080e7          	jalr	122(ra) # 80003bec <bwrite>
  brelse(buf);
    80004b7a:	8526                	mv	a0,s1
    80004b7c:	fffff097          	auipc	ra,0xfffff
    80004b80:	0ae080e7          	jalr	174(ra) # 80003c2a <brelse>
}
    80004b84:	60e2                	ld	ra,24(sp)
    80004b86:	6442                	ld	s0,16(sp)
    80004b88:	64a2                	ld	s1,8(sp)
    80004b8a:	6902                	ld	s2,0(sp)
    80004b8c:	6105                	addi	sp,sp,32
    80004b8e:	8082                	ret

0000000080004b90 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b90:	00068797          	auipc	a5,0x68
    80004b94:	4dc7a783          	lw	a5,1244(a5) # 8006d06c <log+0x2c>
    80004b98:	0cf05063          	blez	a5,80004c58 <install_trans+0xc8>
{
    80004b9c:	715d                	addi	sp,sp,-80
    80004b9e:	e486                	sd	ra,72(sp)
    80004ba0:	e0a2                	sd	s0,64(sp)
    80004ba2:	fc26                	sd	s1,56(sp)
    80004ba4:	f84a                	sd	s2,48(sp)
    80004ba6:	f44e                	sd	s3,40(sp)
    80004ba8:	f052                	sd	s4,32(sp)
    80004baa:	ec56                	sd	s5,24(sp)
    80004bac:	e85a                	sd	s6,16(sp)
    80004bae:	e45e                	sd	s7,8(sp)
    80004bb0:	0880                	addi	s0,sp,80
    80004bb2:	8b2a                	mv	s6,a0
    80004bb4:	00068a97          	auipc	s5,0x68
    80004bb8:	4bca8a93          	addi	s5,s5,1212 # 8006d070 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004bbc:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004bbe:	00068997          	auipc	s3,0x68
    80004bc2:	48298993          	addi	s3,s3,1154 # 8006d040 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004bc6:	40000b93          	li	s7,1024
    80004bca:	a00d                	j	80004bec <install_trans+0x5c>
    brelse(lbuf);
    80004bcc:	854a                	mv	a0,s2
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	05c080e7          	jalr	92(ra) # 80003c2a <brelse>
    brelse(dbuf);
    80004bd6:	8526                	mv	a0,s1
    80004bd8:	fffff097          	auipc	ra,0xfffff
    80004bdc:	052080e7          	jalr	82(ra) # 80003c2a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004be0:	2a05                	addiw	s4,s4,1
    80004be2:	0a91                	addi	s5,s5,4
    80004be4:	02c9a783          	lw	a5,44(s3)
    80004be8:	04fa5d63          	bge	s4,a5,80004c42 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004bec:	0189a583          	lw	a1,24(s3)
    80004bf0:	014585bb          	addw	a1,a1,s4
    80004bf4:	2585                	addiw	a1,a1,1
    80004bf6:	0289a503          	lw	a0,40(s3)
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	f00080e7          	jalr	-256(ra) # 80003afa <bread>
    80004c02:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004c04:	000aa583          	lw	a1,0(s5)
    80004c08:	0289a503          	lw	a0,40(s3)
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	eee080e7          	jalr	-274(ra) # 80003afa <bread>
    80004c14:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004c16:	865e                	mv	a2,s7
    80004c18:	05890593          	addi	a1,s2,88
    80004c1c:	05850513          	addi	a0,a0,88
    80004c20:	ffffc097          	auipc	ra,0xffffc
    80004c24:	252080e7          	jalr	594(ra) # 80000e72 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004c28:	8526                	mv	a0,s1
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	fc2080e7          	jalr	-62(ra) # 80003bec <bwrite>
    if(recovering == 0)
    80004c32:	f80b1de3          	bnez	s6,80004bcc <install_trans+0x3c>
      bunpin(dbuf);
    80004c36:	8526                	mv	a0,s1
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	0c6080e7          	jalr	198(ra) # 80003cfe <bunpin>
    80004c40:	b771                	j	80004bcc <install_trans+0x3c>
}
    80004c42:	60a6                	ld	ra,72(sp)
    80004c44:	6406                	ld	s0,64(sp)
    80004c46:	74e2                	ld	s1,56(sp)
    80004c48:	7942                	ld	s2,48(sp)
    80004c4a:	79a2                	ld	s3,40(sp)
    80004c4c:	7a02                	ld	s4,32(sp)
    80004c4e:	6ae2                	ld	s5,24(sp)
    80004c50:	6b42                	ld	s6,16(sp)
    80004c52:	6ba2                	ld	s7,8(sp)
    80004c54:	6161                	addi	sp,sp,80
    80004c56:	8082                	ret
    80004c58:	8082                	ret

0000000080004c5a <initlog>:
{
    80004c5a:	7179                	addi	sp,sp,-48
    80004c5c:	f406                	sd	ra,40(sp)
    80004c5e:	f022                	sd	s0,32(sp)
    80004c60:	ec26                	sd	s1,24(sp)
    80004c62:	e84a                	sd	s2,16(sp)
    80004c64:	e44e                	sd	s3,8(sp)
    80004c66:	1800                	addi	s0,sp,48
    80004c68:	892a                	mv	s2,a0
    80004c6a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004c6c:	00068497          	auipc	s1,0x68
    80004c70:	3d448493          	addi	s1,s1,980 # 8006d040 <log>
    80004c74:	00005597          	auipc	a1,0x5
    80004c78:	98c58593          	addi	a1,a1,-1652 # 80009600 <etext+0x600>
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	ffffc097          	auipc	ra,0xffffc
    80004c82:	004080e7          	jalr	4(ra) # 80000c82 <initlock>
  log.start = sb->logstart;
    80004c86:	0149a583          	lw	a1,20(s3)
    80004c8a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004c8c:	0109a783          	lw	a5,16(s3)
    80004c90:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004c92:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004c96:	854a                	mv	a0,s2
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	e62080e7          	jalr	-414(ra) # 80003afa <bread>
  log.lh.n = lh->n;
    80004ca0:	4d30                	lw	a2,88(a0)
    80004ca2:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004ca4:	00c05f63          	blez	a2,80004cc2 <initlog+0x68>
    80004ca8:	87aa                	mv	a5,a0
    80004caa:	00068717          	auipc	a4,0x68
    80004cae:	3c670713          	addi	a4,a4,966 # 8006d070 <log+0x30>
    80004cb2:	060a                	slli	a2,a2,0x2
    80004cb4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004cb6:	4ff4                	lw	a3,92(a5)
    80004cb8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004cba:	0791                	addi	a5,a5,4
    80004cbc:	0711                	addi	a4,a4,4
    80004cbe:	fec79ce3          	bne	a5,a2,80004cb6 <initlog+0x5c>
  brelse(buf);
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	f68080e7          	jalr	-152(ra) # 80003c2a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004cca:	4505                	li	a0,1
    80004ccc:	00000097          	auipc	ra,0x0
    80004cd0:	ec4080e7          	jalr	-316(ra) # 80004b90 <install_trans>
  log.lh.n = 0;
    80004cd4:	00068797          	auipc	a5,0x68
    80004cd8:	3807ac23          	sw	zero,920(a5) # 8006d06c <log+0x2c>
  write_head(); // clear the log
    80004cdc:	00000097          	auipc	ra,0x0
    80004ce0:	e4a080e7          	jalr	-438(ra) # 80004b26 <write_head>
}
    80004ce4:	70a2                	ld	ra,40(sp)
    80004ce6:	7402                	ld	s0,32(sp)
    80004ce8:	64e2                	ld	s1,24(sp)
    80004cea:	6942                	ld	s2,16(sp)
    80004cec:	69a2                	ld	s3,8(sp)
    80004cee:	6145                	addi	sp,sp,48
    80004cf0:	8082                	ret

0000000080004cf2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004cf2:	1101                	addi	sp,sp,-32
    80004cf4:	ec06                	sd	ra,24(sp)
    80004cf6:	e822                	sd	s0,16(sp)
    80004cf8:	e426                	sd	s1,8(sp)
    80004cfa:	e04a                	sd	s2,0(sp)
    80004cfc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004cfe:	00068517          	auipc	a0,0x68
    80004d02:	34250513          	addi	a0,a0,834 # 8006d040 <log>
    80004d06:	ffffc097          	auipc	ra,0xffffc
    80004d0a:	010080e7          	jalr	16(ra) # 80000d16 <acquire>
  while(1){
    if(log.committing){
    80004d0e:	00068497          	auipc	s1,0x68
    80004d12:	33248493          	addi	s1,s1,818 # 8006d040 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004d16:	4979                	li	s2,30
    80004d18:	a039                	j	80004d26 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004d1a:	85a6                	mv	a1,s1
    80004d1c:	8526                	mv	a0,s1
    80004d1e:	ffffe097          	auipc	ra,0xffffe
    80004d22:	ab2080e7          	jalr	-1358(ra) # 800027d0 <sleep>
    if(log.committing){
    80004d26:	50dc                	lw	a5,36(s1)
    80004d28:	fbed                	bnez	a5,80004d1a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004d2a:	5098                	lw	a4,32(s1)
    80004d2c:	2705                	addiw	a4,a4,1
    80004d2e:	0027179b          	slliw	a5,a4,0x2
    80004d32:	9fb9                	addw	a5,a5,a4
    80004d34:	0017979b          	slliw	a5,a5,0x1
    80004d38:	54d4                	lw	a3,44(s1)
    80004d3a:	9fb5                	addw	a5,a5,a3
    80004d3c:	00f95963          	bge	s2,a5,80004d4e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004d40:	85a6                	mv	a1,s1
    80004d42:	8526                	mv	a0,s1
    80004d44:	ffffe097          	auipc	ra,0xffffe
    80004d48:	a8c080e7          	jalr	-1396(ra) # 800027d0 <sleep>
    80004d4c:	bfe9                	j	80004d26 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004d4e:	00068517          	auipc	a0,0x68
    80004d52:	2f250513          	addi	a0,a0,754 # 8006d040 <log>
    80004d56:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004d58:	ffffc097          	auipc	ra,0xffffc
    80004d5c:	06e080e7          	jalr	110(ra) # 80000dc6 <release>
      break;
    }
  }
}
    80004d60:	60e2                	ld	ra,24(sp)
    80004d62:	6442                	ld	s0,16(sp)
    80004d64:	64a2                	ld	s1,8(sp)
    80004d66:	6902                	ld	s2,0(sp)
    80004d68:	6105                	addi	sp,sp,32
    80004d6a:	8082                	ret

0000000080004d6c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004d6c:	7139                	addi	sp,sp,-64
    80004d6e:	fc06                	sd	ra,56(sp)
    80004d70:	f822                	sd	s0,48(sp)
    80004d72:	f426                	sd	s1,40(sp)
    80004d74:	f04a                	sd	s2,32(sp)
    80004d76:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004d78:	00068497          	auipc	s1,0x68
    80004d7c:	2c848493          	addi	s1,s1,712 # 8006d040 <log>
    80004d80:	8526                	mv	a0,s1
    80004d82:	ffffc097          	auipc	ra,0xffffc
    80004d86:	f94080e7          	jalr	-108(ra) # 80000d16 <acquire>
  log.outstanding -= 1;
    80004d8a:	509c                	lw	a5,32(s1)
    80004d8c:	37fd                	addiw	a5,a5,-1
    80004d8e:	893e                	mv	s2,a5
    80004d90:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004d92:	50dc                	lw	a5,36(s1)
    80004d94:	e7b9                	bnez	a5,80004de2 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    80004d96:	06091263          	bnez	s2,80004dfa <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004d9a:	00068497          	auipc	s1,0x68
    80004d9e:	2a648493          	addi	s1,s1,678 # 8006d040 <log>
    80004da2:	4785                	li	a5,1
    80004da4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004da6:	8526                	mv	a0,s1
    80004da8:	ffffc097          	auipc	ra,0xffffc
    80004dac:	01e080e7          	jalr	30(ra) # 80000dc6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004db0:	54dc                	lw	a5,44(s1)
    80004db2:	06f04863          	bgtz	a5,80004e22 <end_op+0xb6>
    acquire(&log.lock);
    80004db6:	00068497          	auipc	s1,0x68
    80004dba:	28a48493          	addi	s1,s1,650 # 8006d040 <log>
    80004dbe:	8526                	mv	a0,s1
    80004dc0:	ffffc097          	auipc	ra,0xffffc
    80004dc4:	f56080e7          	jalr	-170(ra) # 80000d16 <acquire>
    log.committing = 0;
    80004dc8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004dcc:	8526                	mv	a0,s1
    80004dce:	ffffe097          	auipc	ra,0xffffe
    80004dd2:	a66080e7          	jalr	-1434(ra) # 80002834 <wakeup>
    release(&log.lock);
    80004dd6:	8526                	mv	a0,s1
    80004dd8:	ffffc097          	auipc	ra,0xffffc
    80004ddc:	fee080e7          	jalr	-18(ra) # 80000dc6 <release>
}
    80004de0:	a81d                	j	80004e16 <end_op+0xaa>
    80004de2:	ec4e                	sd	s3,24(sp)
    80004de4:	e852                	sd	s4,16(sp)
    80004de6:	e456                	sd	s5,8(sp)
    80004de8:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80004dea:	00005517          	auipc	a0,0x5
    80004dee:	81e50513          	addi	a0,a0,-2018 # 80009608 <etext+0x608>
    80004df2:	ffffb097          	auipc	ra,0xffffb
    80004df6:	76e080e7          	jalr	1902(ra) # 80000560 <panic>
    wakeup(&log);
    80004dfa:	00068497          	auipc	s1,0x68
    80004dfe:	24648493          	addi	s1,s1,582 # 8006d040 <log>
    80004e02:	8526                	mv	a0,s1
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	a30080e7          	jalr	-1488(ra) # 80002834 <wakeup>
  release(&log.lock);
    80004e0c:	8526                	mv	a0,s1
    80004e0e:	ffffc097          	auipc	ra,0xffffc
    80004e12:	fb8080e7          	jalr	-72(ra) # 80000dc6 <release>
}
    80004e16:	70e2                	ld	ra,56(sp)
    80004e18:	7442                	ld	s0,48(sp)
    80004e1a:	74a2                	ld	s1,40(sp)
    80004e1c:	7902                	ld	s2,32(sp)
    80004e1e:	6121                	addi	sp,sp,64
    80004e20:	8082                	ret
    80004e22:	ec4e                	sd	s3,24(sp)
    80004e24:	e852                	sd	s4,16(sp)
    80004e26:	e456                	sd	s5,8(sp)
    80004e28:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e2a:	00068a97          	auipc	s5,0x68
    80004e2e:	246a8a93          	addi	s5,s5,582 # 8006d070 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004e32:	00068a17          	auipc	s4,0x68
    80004e36:	20ea0a13          	addi	s4,s4,526 # 8006d040 <log>
    memmove(to->data, from->data, BSIZE);
    80004e3a:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004e3e:	018a2583          	lw	a1,24(s4)
    80004e42:	012585bb          	addw	a1,a1,s2
    80004e46:	2585                	addiw	a1,a1,1
    80004e48:	028a2503          	lw	a0,40(s4)
    80004e4c:	fffff097          	auipc	ra,0xfffff
    80004e50:	cae080e7          	jalr	-850(ra) # 80003afa <bread>
    80004e54:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004e56:	000aa583          	lw	a1,0(s5)
    80004e5a:	028a2503          	lw	a0,40(s4)
    80004e5e:	fffff097          	auipc	ra,0xfffff
    80004e62:	c9c080e7          	jalr	-868(ra) # 80003afa <bread>
    80004e66:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004e68:	865a                	mv	a2,s6
    80004e6a:	05850593          	addi	a1,a0,88
    80004e6e:	05848513          	addi	a0,s1,88
    80004e72:	ffffc097          	auipc	ra,0xffffc
    80004e76:	000080e7          	jalr	ra # 80000e72 <memmove>
    bwrite(to);  // write the log
    80004e7a:	8526                	mv	a0,s1
    80004e7c:	fffff097          	auipc	ra,0xfffff
    80004e80:	d70080e7          	jalr	-656(ra) # 80003bec <bwrite>
    brelse(from);
    80004e84:	854e                	mv	a0,s3
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	da4080e7          	jalr	-604(ra) # 80003c2a <brelse>
    brelse(to);
    80004e8e:	8526                	mv	a0,s1
    80004e90:	fffff097          	auipc	ra,0xfffff
    80004e94:	d9a080e7          	jalr	-614(ra) # 80003c2a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004e98:	2905                	addiw	s2,s2,1
    80004e9a:	0a91                	addi	s5,s5,4
    80004e9c:	02ca2783          	lw	a5,44(s4)
    80004ea0:	f8f94fe3          	blt	s2,a5,80004e3e <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004ea4:	00000097          	auipc	ra,0x0
    80004ea8:	c82080e7          	jalr	-894(ra) # 80004b26 <write_head>
    install_trans(0); // Now install writes to home locations
    80004eac:	4501                	li	a0,0
    80004eae:	00000097          	auipc	ra,0x0
    80004eb2:	ce2080e7          	jalr	-798(ra) # 80004b90 <install_trans>
    log.lh.n = 0;
    80004eb6:	00068797          	auipc	a5,0x68
    80004eba:	1a07ab23          	sw	zero,438(a5) # 8006d06c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004ebe:	00000097          	auipc	ra,0x0
    80004ec2:	c68080e7          	jalr	-920(ra) # 80004b26 <write_head>
    80004ec6:	69e2                	ld	s3,24(sp)
    80004ec8:	6a42                	ld	s4,16(sp)
    80004eca:	6aa2                	ld	s5,8(sp)
    80004ecc:	6b02                	ld	s6,0(sp)
    80004ece:	b5e5                	j	80004db6 <end_op+0x4a>

0000000080004ed0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004ed0:	1101                	addi	sp,sp,-32
    80004ed2:	ec06                	sd	ra,24(sp)
    80004ed4:	e822                	sd	s0,16(sp)
    80004ed6:	e426                	sd	s1,8(sp)
    80004ed8:	e04a                	sd	s2,0(sp)
    80004eda:	1000                	addi	s0,sp,32
    80004edc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004ede:	00068917          	auipc	s2,0x68
    80004ee2:	16290913          	addi	s2,s2,354 # 8006d040 <log>
    80004ee6:	854a                	mv	a0,s2
    80004ee8:	ffffc097          	auipc	ra,0xffffc
    80004eec:	e2e080e7          	jalr	-466(ra) # 80000d16 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004ef0:	02c92603          	lw	a2,44(s2)
    80004ef4:	47f5                	li	a5,29
    80004ef6:	06c7c563          	blt	a5,a2,80004f60 <log_write+0x90>
    80004efa:	00068797          	auipc	a5,0x68
    80004efe:	1627a783          	lw	a5,354(a5) # 8006d05c <log+0x1c>
    80004f02:	37fd                	addiw	a5,a5,-1
    80004f04:	04f65e63          	bge	a2,a5,80004f60 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004f08:	00068797          	auipc	a5,0x68
    80004f0c:	1587a783          	lw	a5,344(a5) # 8006d060 <log+0x20>
    80004f10:	06f05063          	blez	a5,80004f70 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004f14:	4781                	li	a5,0
    80004f16:	06c05563          	blez	a2,80004f80 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004f1a:	44cc                	lw	a1,12(s1)
    80004f1c:	00068717          	auipc	a4,0x68
    80004f20:	15470713          	addi	a4,a4,340 # 8006d070 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004f24:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004f26:	4314                	lw	a3,0(a4)
    80004f28:	04b68c63          	beq	a3,a1,80004f80 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004f2c:	2785                	addiw	a5,a5,1
    80004f2e:	0711                	addi	a4,a4,4
    80004f30:	fef61be3          	bne	a2,a5,80004f26 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004f34:	0621                	addi	a2,a2,8
    80004f36:	060a                	slli	a2,a2,0x2
    80004f38:	00068797          	auipc	a5,0x68
    80004f3c:	10878793          	addi	a5,a5,264 # 8006d040 <log>
    80004f40:	97b2                	add	a5,a5,a2
    80004f42:	44d8                	lw	a4,12(s1)
    80004f44:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004f46:	8526                	mv	a0,s1
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	d7a080e7          	jalr	-646(ra) # 80003cc2 <bpin>
    log.lh.n++;
    80004f50:	00068717          	auipc	a4,0x68
    80004f54:	0f070713          	addi	a4,a4,240 # 8006d040 <log>
    80004f58:	575c                	lw	a5,44(a4)
    80004f5a:	2785                	addiw	a5,a5,1
    80004f5c:	d75c                	sw	a5,44(a4)
    80004f5e:	a82d                	j	80004f98 <log_write+0xc8>
    panic("too big a transaction");
    80004f60:	00004517          	auipc	a0,0x4
    80004f64:	6b850513          	addi	a0,a0,1720 # 80009618 <etext+0x618>
    80004f68:	ffffb097          	auipc	ra,0xffffb
    80004f6c:	5f8080e7          	jalr	1528(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004f70:	00004517          	auipc	a0,0x4
    80004f74:	6c050513          	addi	a0,a0,1728 # 80009630 <etext+0x630>
    80004f78:	ffffb097          	auipc	ra,0xffffb
    80004f7c:	5e8080e7          	jalr	1512(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004f80:	00878693          	addi	a3,a5,8
    80004f84:	068a                	slli	a3,a3,0x2
    80004f86:	00068717          	auipc	a4,0x68
    80004f8a:	0ba70713          	addi	a4,a4,186 # 8006d040 <log>
    80004f8e:	9736                	add	a4,a4,a3
    80004f90:	44d4                	lw	a3,12(s1)
    80004f92:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004f94:	faf609e3          	beq	a2,a5,80004f46 <log_write+0x76>
  }
  release(&log.lock);
    80004f98:	00068517          	auipc	a0,0x68
    80004f9c:	0a850513          	addi	a0,a0,168 # 8006d040 <log>
    80004fa0:	ffffc097          	auipc	ra,0xffffc
    80004fa4:	e26080e7          	jalr	-474(ra) # 80000dc6 <release>
}
    80004fa8:	60e2                	ld	ra,24(sp)
    80004faa:	6442                	ld	s0,16(sp)
    80004fac:	64a2                	ld	s1,8(sp)
    80004fae:	6902                	ld	s2,0(sp)
    80004fb0:	6105                	addi	sp,sp,32
    80004fb2:	8082                	ret

0000000080004fb4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004fb4:	1101                	addi	sp,sp,-32
    80004fb6:	ec06                	sd	ra,24(sp)
    80004fb8:	e822                	sd	s0,16(sp)
    80004fba:	e426                	sd	s1,8(sp)
    80004fbc:	e04a                	sd	s2,0(sp)
    80004fbe:	1000                	addi	s0,sp,32
    80004fc0:	84aa                	mv	s1,a0
    80004fc2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004fc4:	00004597          	auipc	a1,0x4
    80004fc8:	68c58593          	addi	a1,a1,1676 # 80009650 <etext+0x650>
    80004fcc:	0521                	addi	a0,a0,8
    80004fce:	ffffc097          	auipc	ra,0xffffc
    80004fd2:	cb4080e7          	jalr	-844(ra) # 80000c82 <initlock>
  lk->name = name;
    80004fd6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004fda:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004fde:	0204a423          	sw	zero,40(s1)
}
    80004fe2:	60e2                	ld	ra,24(sp)
    80004fe4:	6442                	ld	s0,16(sp)
    80004fe6:	64a2                	ld	s1,8(sp)
    80004fe8:	6902                	ld	s2,0(sp)
    80004fea:	6105                	addi	sp,sp,32
    80004fec:	8082                	ret

0000000080004fee <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004fee:	1101                	addi	sp,sp,-32
    80004ff0:	ec06                	sd	ra,24(sp)
    80004ff2:	e822                	sd	s0,16(sp)
    80004ff4:	e426                	sd	s1,8(sp)
    80004ff6:	e04a                	sd	s2,0(sp)
    80004ff8:	1000                	addi	s0,sp,32
    80004ffa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004ffc:	00850913          	addi	s2,a0,8
    80005000:	854a                	mv	a0,s2
    80005002:	ffffc097          	auipc	ra,0xffffc
    80005006:	d14080e7          	jalr	-748(ra) # 80000d16 <acquire>
  while (lk->locked) {
    8000500a:	409c                	lw	a5,0(s1)
    8000500c:	cb89                	beqz	a5,8000501e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000500e:	85ca                	mv	a1,s2
    80005010:	8526                	mv	a0,s1
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	7be080e7          	jalr	1982(ra) # 800027d0 <sleep>
  while (lk->locked) {
    8000501a:	409c                	lw	a5,0(s1)
    8000501c:	fbed                	bnez	a5,8000500e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000501e:	4785                	li	a5,1
    80005020:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	f00080e7          	jalr	-256(ra) # 80001f22 <myproc>
    8000502a:	591c                	lw	a5,48(a0)
    8000502c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000502e:	854a                	mv	a0,s2
    80005030:	ffffc097          	auipc	ra,0xffffc
    80005034:	d96080e7          	jalr	-618(ra) # 80000dc6 <release>
}
    80005038:	60e2                	ld	ra,24(sp)
    8000503a:	6442                	ld	s0,16(sp)
    8000503c:	64a2                	ld	s1,8(sp)
    8000503e:	6902                	ld	s2,0(sp)
    80005040:	6105                	addi	sp,sp,32
    80005042:	8082                	ret

0000000080005044 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005044:	1101                	addi	sp,sp,-32
    80005046:	ec06                	sd	ra,24(sp)
    80005048:	e822                	sd	s0,16(sp)
    8000504a:	e426                	sd	s1,8(sp)
    8000504c:	e04a                	sd	s2,0(sp)
    8000504e:	1000                	addi	s0,sp,32
    80005050:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80005052:	00850913          	addi	s2,a0,8
    80005056:	854a                	mv	a0,s2
    80005058:	ffffc097          	auipc	ra,0xffffc
    8000505c:	cbe080e7          	jalr	-834(ra) # 80000d16 <acquire>
  lk->locked = 0;
    80005060:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005064:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80005068:	8526                	mv	a0,s1
    8000506a:	ffffd097          	auipc	ra,0xffffd
    8000506e:	7ca080e7          	jalr	1994(ra) # 80002834 <wakeup>
  release(&lk->lk);
    80005072:	854a                	mv	a0,s2
    80005074:	ffffc097          	auipc	ra,0xffffc
    80005078:	d52080e7          	jalr	-686(ra) # 80000dc6 <release>
}
    8000507c:	60e2                	ld	ra,24(sp)
    8000507e:	6442                	ld	s0,16(sp)
    80005080:	64a2                	ld	s1,8(sp)
    80005082:	6902                	ld	s2,0(sp)
    80005084:	6105                	addi	sp,sp,32
    80005086:	8082                	ret

0000000080005088 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80005088:	7179                	addi	sp,sp,-48
    8000508a:	f406                	sd	ra,40(sp)
    8000508c:	f022                	sd	s0,32(sp)
    8000508e:	ec26                	sd	s1,24(sp)
    80005090:	e84a                	sd	s2,16(sp)
    80005092:	1800                	addi	s0,sp,48
    80005094:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80005096:	00850913          	addi	s2,a0,8
    8000509a:	854a                	mv	a0,s2
    8000509c:	ffffc097          	auipc	ra,0xffffc
    800050a0:	c7a080e7          	jalr	-902(ra) # 80000d16 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800050a4:	409c                	lw	a5,0(s1)
    800050a6:	ef91                	bnez	a5,800050c2 <holdingsleep+0x3a>
    800050a8:	4481                	li	s1,0
  release(&lk->lk);
    800050aa:	854a                	mv	a0,s2
    800050ac:	ffffc097          	auipc	ra,0xffffc
    800050b0:	d1a080e7          	jalr	-742(ra) # 80000dc6 <release>
  return r;
}
    800050b4:	8526                	mv	a0,s1
    800050b6:	70a2                	ld	ra,40(sp)
    800050b8:	7402                	ld	s0,32(sp)
    800050ba:	64e2                	ld	s1,24(sp)
    800050bc:	6942                	ld	s2,16(sp)
    800050be:	6145                	addi	sp,sp,48
    800050c0:	8082                	ret
    800050c2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800050c4:	0284a983          	lw	s3,40(s1)
    800050c8:	ffffd097          	auipc	ra,0xffffd
    800050cc:	e5a080e7          	jalr	-422(ra) # 80001f22 <myproc>
    800050d0:	5904                	lw	s1,48(a0)
    800050d2:	413484b3          	sub	s1,s1,s3
    800050d6:	0014b493          	seqz	s1,s1
    800050da:	69a2                	ld	s3,8(sp)
    800050dc:	b7f9                	j	800050aa <holdingsleep+0x22>

00000000800050de <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800050de:	1141                	addi	sp,sp,-16
    800050e0:	e406                	sd	ra,8(sp)
    800050e2:	e022                	sd	s0,0(sp)
    800050e4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800050e6:	00004597          	auipc	a1,0x4
    800050ea:	57a58593          	addi	a1,a1,1402 # 80009660 <etext+0x660>
    800050ee:	00068517          	auipc	a0,0x68
    800050f2:	09a50513          	addi	a0,a0,154 # 8006d188 <ftable>
    800050f6:	ffffc097          	auipc	ra,0xffffc
    800050fa:	b8c080e7          	jalr	-1140(ra) # 80000c82 <initlock>
}
    800050fe:	60a2                	ld	ra,8(sp)
    80005100:	6402                	ld	s0,0(sp)
    80005102:	0141                	addi	sp,sp,16
    80005104:	8082                	ret

0000000080005106 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005106:	1101                	addi	sp,sp,-32
    80005108:	ec06                	sd	ra,24(sp)
    8000510a:	e822                	sd	s0,16(sp)
    8000510c:	e426                	sd	s1,8(sp)
    8000510e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005110:	00068517          	auipc	a0,0x68
    80005114:	07850513          	addi	a0,a0,120 # 8006d188 <ftable>
    80005118:	ffffc097          	auipc	ra,0xffffc
    8000511c:	bfe080e7          	jalr	-1026(ra) # 80000d16 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005120:	00068497          	auipc	s1,0x68
    80005124:	08048493          	addi	s1,s1,128 # 8006d1a0 <ftable+0x18>
    80005128:	00069717          	auipc	a4,0x69
    8000512c:	01870713          	addi	a4,a4,24 # 8006e140 <disk>
    if(f->ref == 0){
    80005130:	40dc                	lw	a5,4(s1)
    80005132:	cf99                	beqz	a5,80005150 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005134:	02848493          	addi	s1,s1,40
    80005138:	fee49ce3          	bne	s1,a4,80005130 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000513c:	00068517          	auipc	a0,0x68
    80005140:	04c50513          	addi	a0,a0,76 # 8006d188 <ftable>
    80005144:	ffffc097          	auipc	ra,0xffffc
    80005148:	c82080e7          	jalr	-894(ra) # 80000dc6 <release>
  return 0;
    8000514c:	4481                	li	s1,0
    8000514e:	a819                	j	80005164 <filealloc+0x5e>
      f->ref = 1;
    80005150:	4785                	li	a5,1
    80005152:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80005154:	00068517          	auipc	a0,0x68
    80005158:	03450513          	addi	a0,a0,52 # 8006d188 <ftable>
    8000515c:	ffffc097          	auipc	ra,0xffffc
    80005160:	c6a080e7          	jalr	-918(ra) # 80000dc6 <release>
}
    80005164:	8526                	mv	a0,s1
    80005166:	60e2                	ld	ra,24(sp)
    80005168:	6442                	ld	s0,16(sp)
    8000516a:	64a2                	ld	s1,8(sp)
    8000516c:	6105                	addi	sp,sp,32
    8000516e:	8082                	ret

0000000080005170 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005170:	1101                	addi	sp,sp,-32
    80005172:	ec06                	sd	ra,24(sp)
    80005174:	e822                	sd	s0,16(sp)
    80005176:	e426                	sd	s1,8(sp)
    80005178:	1000                	addi	s0,sp,32
    8000517a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000517c:	00068517          	auipc	a0,0x68
    80005180:	00c50513          	addi	a0,a0,12 # 8006d188 <ftable>
    80005184:	ffffc097          	auipc	ra,0xffffc
    80005188:	b92080e7          	jalr	-1134(ra) # 80000d16 <acquire>
  if(f->ref < 1)
    8000518c:	40dc                	lw	a5,4(s1)
    8000518e:	02f05263          	blez	a5,800051b2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80005192:	2785                	addiw	a5,a5,1
    80005194:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80005196:	00068517          	auipc	a0,0x68
    8000519a:	ff250513          	addi	a0,a0,-14 # 8006d188 <ftable>
    8000519e:	ffffc097          	auipc	ra,0xffffc
    800051a2:	c28080e7          	jalr	-984(ra) # 80000dc6 <release>
  return f;
}
    800051a6:	8526                	mv	a0,s1
    800051a8:	60e2                	ld	ra,24(sp)
    800051aa:	6442                	ld	s0,16(sp)
    800051ac:	64a2                	ld	s1,8(sp)
    800051ae:	6105                	addi	sp,sp,32
    800051b0:	8082                	ret
    panic("filedup");
    800051b2:	00004517          	auipc	a0,0x4
    800051b6:	4b650513          	addi	a0,a0,1206 # 80009668 <etext+0x668>
    800051ba:	ffffb097          	auipc	ra,0xffffb
    800051be:	3a6080e7          	jalr	934(ra) # 80000560 <panic>

00000000800051c2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800051c2:	7139                	addi	sp,sp,-64
    800051c4:	fc06                	sd	ra,56(sp)
    800051c6:	f822                	sd	s0,48(sp)
    800051c8:	f426                	sd	s1,40(sp)
    800051ca:	0080                	addi	s0,sp,64
    800051cc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800051ce:	00068517          	auipc	a0,0x68
    800051d2:	fba50513          	addi	a0,a0,-70 # 8006d188 <ftable>
    800051d6:	ffffc097          	auipc	ra,0xffffc
    800051da:	b40080e7          	jalr	-1216(ra) # 80000d16 <acquire>
  if(f->ref < 1)
    800051de:	40dc                	lw	a5,4(s1)
    800051e0:	04f05a63          	blez	a5,80005234 <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    800051e4:	37fd                	addiw	a5,a5,-1
    800051e6:	c0dc                	sw	a5,4(s1)
    800051e8:	06f04263          	bgtz	a5,8000524c <fileclose+0x8a>
    800051ec:	f04a                	sd	s2,32(sp)
    800051ee:	ec4e                	sd	s3,24(sp)
    800051f0:	e852                	sd	s4,16(sp)
    800051f2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800051f4:	0004a903          	lw	s2,0(s1)
    800051f8:	0094ca83          	lbu	s5,9(s1)
    800051fc:	0104ba03          	ld	s4,16(s1)
    80005200:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80005204:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80005208:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000520c:	00068517          	auipc	a0,0x68
    80005210:	f7c50513          	addi	a0,a0,-132 # 8006d188 <ftable>
    80005214:	ffffc097          	auipc	ra,0xffffc
    80005218:	bb2080e7          	jalr	-1102(ra) # 80000dc6 <release>

  if(ff.type == FD_PIPE){
    8000521c:	4785                	li	a5,1
    8000521e:	04f90463          	beq	s2,a5,80005266 <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80005222:	3979                	addiw	s2,s2,-2
    80005224:	4785                	li	a5,1
    80005226:	0527fb63          	bgeu	a5,s2,8000527c <fileclose+0xba>
    8000522a:	7902                	ld	s2,32(sp)
    8000522c:	69e2                	ld	s3,24(sp)
    8000522e:	6a42                	ld	s4,16(sp)
    80005230:	6aa2                	ld	s5,8(sp)
    80005232:	a02d                	j	8000525c <fileclose+0x9a>
    80005234:	f04a                	sd	s2,32(sp)
    80005236:	ec4e                	sd	s3,24(sp)
    80005238:	e852                	sd	s4,16(sp)
    8000523a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000523c:	00004517          	auipc	a0,0x4
    80005240:	43450513          	addi	a0,a0,1076 # 80009670 <etext+0x670>
    80005244:	ffffb097          	auipc	ra,0xffffb
    80005248:	31c080e7          	jalr	796(ra) # 80000560 <panic>
    release(&ftable.lock);
    8000524c:	00068517          	auipc	a0,0x68
    80005250:	f3c50513          	addi	a0,a0,-196 # 8006d188 <ftable>
    80005254:	ffffc097          	auipc	ra,0xffffc
    80005258:	b72080e7          	jalr	-1166(ra) # 80000dc6 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000525c:	70e2                	ld	ra,56(sp)
    8000525e:	7442                	ld	s0,48(sp)
    80005260:	74a2                	ld	s1,40(sp)
    80005262:	6121                	addi	sp,sp,64
    80005264:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80005266:	85d6                	mv	a1,s5
    80005268:	8552                	mv	a0,s4
    8000526a:	00000097          	auipc	ra,0x0
    8000526e:	3ac080e7          	jalr	940(ra) # 80005616 <pipeclose>
    80005272:	7902                	ld	s2,32(sp)
    80005274:	69e2                	ld	s3,24(sp)
    80005276:	6a42                	ld	s4,16(sp)
    80005278:	6aa2                	ld	s5,8(sp)
    8000527a:	b7cd                	j	8000525c <fileclose+0x9a>
    begin_op();
    8000527c:	00000097          	auipc	ra,0x0
    80005280:	a76080e7          	jalr	-1418(ra) # 80004cf2 <begin_op>
    iput(ff.ip);
    80005284:	854e                	mv	a0,s3
    80005286:	fffff097          	auipc	ra,0xfffff
    8000528a:	240080e7          	jalr	576(ra) # 800044c6 <iput>
    end_op();
    8000528e:	00000097          	auipc	ra,0x0
    80005292:	ade080e7          	jalr	-1314(ra) # 80004d6c <end_op>
    80005296:	7902                	ld	s2,32(sp)
    80005298:	69e2                	ld	s3,24(sp)
    8000529a:	6a42                	ld	s4,16(sp)
    8000529c:	6aa2                	ld	s5,8(sp)
    8000529e:	bf7d                	j	8000525c <fileclose+0x9a>

00000000800052a0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800052a0:	715d                	addi	sp,sp,-80
    800052a2:	e486                	sd	ra,72(sp)
    800052a4:	e0a2                	sd	s0,64(sp)
    800052a6:	fc26                	sd	s1,56(sp)
    800052a8:	f44e                	sd	s3,40(sp)
    800052aa:	0880                	addi	s0,sp,80
    800052ac:	84aa                	mv	s1,a0
    800052ae:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800052b0:	ffffd097          	auipc	ra,0xffffd
    800052b4:	c72080e7          	jalr	-910(ra) # 80001f22 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800052b8:	409c                	lw	a5,0(s1)
    800052ba:	37f9                	addiw	a5,a5,-2
    800052bc:	4705                	li	a4,1
    800052be:	04f76a63          	bltu	a4,a5,80005312 <filestat+0x72>
    800052c2:	f84a                	sd	s2,48(sp)
    800052c4:	f052                	sd	s4,32(sp)
    800052c6:	892a                	mv	s2,a0
    ilock(f->ip);
    800052c8:	6c88                	ld	a0,24(s1)
    800052ca:	fffff097          	auipc	ra,0xfffff
    800052ce:	03e080e7          	jalr	62(ra) # 80004308 <ilock>
    stati(f->ip, &st);
    800052d2:	fb840a13          	addi	s4,s0,-72
    800052d6:	85d2                	mv	a1,s4
    800052d8:	6c88                	ld	a0,24(s1)
    800052da:	fffff097          	auipc	ra,0xfffff
    800052de:	2bc080e7          	jalr	700(ra) # 80004596 <stati>
    iunlock(f->ip);
    800052e2:	6c88                	ld	a0,24(s1)
    800052e4:	fffff097          	auipc	ra,0xfffff
    800052e8:	0ea080e7          	jalr	234(ra) # 800043ce <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800052ec:	46e1                	li	a3,24
    800052ee:	8652                	mv	a2,s4
    800052f0:	85ce                	mv	a1,s3
    800052f2:	05093503          	ld	a0,80(s2)
    800052f6:	ffffd097          	auipc	ra,0xffffd
    800052fa:	8d4080e7          	jalr	-1836(ra) # 80001bca <copyout>
    800052fe:	41f5551b          	sraiw	a0,a0,0x1f
    80005302:	7942                	ld	s2,48(sp)
    80005304:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80005306:	60a6                	ld	ra,72(sp)
    80005308:	6406                	ld	s0,64(sp)
    8000530a:	74e2                	ld	s1,56(sp)
    8000530c:	79a2                	ld	s3,40(sp)
    8000530e:	6161                	addi	sp,sp,80
    80005310:	8082                	ret
  return -1;
    80005312:	557d                	li	a0,-1
    80005314:	bfcd                	j	80005306 <filestat+0x66>

0000000080005316 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005316:	7179                	addi	sp,sp,-48
    80005318:	f406                	sd	ra,40(sp)
    8000531a:	f022                	sd	s0,32(sp)
    8000531c:	e84a                	sd	s2,16(sp)
    8000531e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80005320:	00854783          	lbu	a5,8(a0)
    80005324:	cbc5                	beqz	a5,800053d4 <fileread+0xbe>
    80005326:	ec26                	sd	s1,24(sp)
    80005328:	e44e                	sd	s3,8(sp)
    8000532a:	84aa                	mv	s1,a0
    8000532c:	89ae                	mv	s3,a1
    8000532e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80005330:	411c                	lw	a5,0(a0)
    80005332:	4705                	li	a4,1
    80005334:	04e78963          	beq	a5,a4,80005386 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005338:	470d                	li	a4,3
    8000533a:	04e78f63          	beq	a5,a4,80005398 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000533e:	4709                	li	a4,2
    80005340:	08e79263          	bne	a5,a4,800053c4 <fileread+0xae>
    ilock(f->ip);
    80005344:	6d08                	ld	a0,24(a0)
    80005346:	fffff097          	auipc	ra,0xfffff
    8000534a:	fc2080e7          	jalr	-62(ra) # 80004308 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000534e:	874a                	mv	a4,s2
    80005350:	5094                	lw	a3,32(s1)
    80005352:	864e                	mv	a2,s3
    80005354:	4585                	li	a1,1
    80005356:	6c88                	ld	a0,24(s1)
    80005358:	fffff097          	auipc	ra,0xfffff
    8000535c:	26c080e7          	jalr	620(ra) # 800045c4 <readi>
    80005360:	892a                	mv	s2,a0
    80005362:	00a05563          	blez	a0,8000536c <fileread+0x56>
      f->off += r;
    80005366:	509c                	lw	a5,32(s1)
    80005368:	9fa9                	addw	a5,a5,a0
    8000536a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000536c:	6c88                	ld	a0,24(s1)
    8000536e:	fffff097          	auipc	ra,0xfffff
    80005372:	060080e7          	jalr	96(ra) # 800043ce <iunlock>
    80005376:	64e2                	ld	s1,24(sp)
    80005378:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000537a:	854a                	mv	a0,s2
    8000537c:	70a2                	ld	ra,40(sp)
    8000537e:	7402                	ld	s0,32(sp)
    80005380:	6942                	ld	s2,16(sp)
    80005382:	6145                	addi	sp,sp,48
    80005384:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005386:	6908                	ld	a0,16(a0)
    80005388:	00000097          	auipc	ra,0x0
    8000538c:	41a080e7          	jalr	1050(ra) # 800057a2 <piperead>
    80005390:	892a                	mv	s2,a0
    80005392:	64e2                	ld	s1,24(sp)
    80005394:	69a2                	ld	s3,8(sp)
    80005396:	b7d5                	j	8000537a <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80005398:	02451783          	lh	a5,36(a0)
    8000539c:	03079693          	slli	a3,a5,0x30
    800053a0:	92c1                	srli	a3,a3,0x30
    800053a2:	4725                	li	a4,9
    800053a4:	02d76a63          	bltu	a4,a3,800053d8 <fileread+0xc2>
    800053a8:	0792                	slli	a5,a5,0x4
    800053aa:	00068717          	auipc	a4,0x68
    800053ae:	d3e70713          	addi	a4,a4,-706 # 8006d0e8 <devsw>
    800053b2:	97ba                	add	a5,a5,a4
    800053b4:	639c                	ld	a5,0(a5)
    800053b6:	c78d                	beqz	a5,800053e0 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    800053b8:	4505                	li	a0,1
    800053ba:	9782                	jalr	a5
    800053bc:	892a                	mv	s2,a0
    800053be:	64e2                	ld	s1,24(sp)
    800053c0:	69a2                	ld	s3,8(sp)
    800053c2:	bf65                	j	8000537a <fileread+0x64>
    panic("fileread");
    800053c4:	00004517          	auipc	a0,0x4
    800053c8:	2bc50513          	addi	a0,a0,700 # 80009680 <etext+0x680>
    800053cc:	ffffb097          	auipc	ra,0xffffb
    800053d0:	194080e7          	jalr	404(ra) # 80000560 <panic>
    return -1;
    800053d4:	597d                	li	s2,-1
    800053d6:	b755                	j	8000537a <fileread+0x64>
      return -1;
    800053d8:	597d                	li	s2,-1
    800053da:	64e2                	ld	s1,24(sp)
    800053dc:	69a2                	ld	s3,8(sp)
    800053de:	bf71                	j	8000537a <fileread+0x64>
    800053e0:	597d                	li	s2,-1
    800053e2:	64e2                	ld	s1,24(sp)
    800053e4:	69a2                	ld	s3,8(sp)
    800053e6:	bf51                	j	8000537a <fileread+0x64>

00000000800053e8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800053e8:	00954783          	lbu	a5,9(a0)
    800053ec:	12078c63          	beqz	a5,80005524 <filewrite+0x13c>
{
    800053f0:	711d                	addi	sp,sp,-96
    800053f2:	ec86                	sd	ra,88(sp)
    800053f4:	e8a2                	sd	s0,80(sp)
    800053f6:	e0ca                	sd	s2,64(sp)
    800053f8:	f456                	sd	s5,40(sp)
    800053fa:	f05a                	sd	s6,32(sp)
    800053fc:	1080                	addi	s0,sp,96
    800053fe:	892a                	mv	s2,a0
    80005400:	8b2e                	mv	s6,a1
    80005402:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80005404:	411c                	lw	a5,0(a0)
    80005406:	4705                	li	a4,1
    80005408:	02e78963          	beq	a5,a4,8000543a <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000540c:	470d                	li	a4,3
    8000540e:	02e78c63          	beq	a5,a4,80005446 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005412:	4709                	li	a4,2
    80005414:	0ee79a63          	bne	a5,a4,80005508 <filewrite+0x120>
    80005418:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000541a:	0cc05563          	blez	a2,800054e4 <filewrite+0xfc>
    8000541e:	e4a6                	sd	s1,72(sp)
    80005420:	fc4e                	sd	s3,56(sp)
    80005422:	ec5e                	sd	s7,24(sp)
    80005424:	e862                	sd	s8,16(sp)
    80005426:	e466                	sd	s9,8(sp)
    int i = 0;
    80005428:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    8000542a:	6b85                	lui	s7,0x1
    8000542c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005430:	6c85                	lui	s9,0x1
    80005432:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005436:	4c05                	li	s8,1
    80005438:	a849                	j	800054ca <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    8000543a:	6908                	ld	a0,16(a0)
    8000543c:	00000097          	auipc	ra,0x0
    80005440:	24a080e7          	jalr	586(ra) # 80005686 <pipewrite>
    80005444:	a85d                	j	800054fa <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005446:	02451783          	lh	a5,36(a0)
    8000544a:	03079693          	slli	a3,a5,0x30
    8000544e:	92c1                	srli	a3,a3,0x30
    80005450:	4725                	li	a4,9
    80005452:	0cd76b63          	bltu	a4,a3,80005528 <filewrite+0x140>
    80005456:	0792                	slli	a5,a5,0x4
    80005458:	00068717          	auipc	a4,0x68
    8000545c:	c9070713          	addi	a4,a4,-880 # 8006d0e8 <devsw>
    80005460:	97ba                	add	a5,a5,a4
    80005462:	679c                	ld	a5,8(a5)
    80005464:	c7e1                	beqz	a5,8000552c <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80005466:	4505                	li	a0,1
    80005468:	9782                	jalr	a5
    8000546a:	a841                	j	800054fa <filewrite+0x112>
      if(n1 > max)
    8000546c:	2981                	sext.w	s3,s3
      begin_op();
    8000546e:	00000097          	auipc	ra,0x0
    80005472:	884080e7          	jalr	-1916(ra) # 80004cf2 <begin_op>
      ilock(f->ip);
    80005476:	01893503          	ld	a0,24(s2)
    8000547a:	fffff097          	auipc	ra,0xfffff
    8000547e:	e8e080e7          	jalr	-370(ra) # 80004308 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005482:	874e                	mv	a4,s3
    80005484:	02092683          	lw	a3,32(s2)
    80005488:	016a0633          	add	a2,s4,s6
    8000548c:	85e2                	mv	a1,s8
    8000548e:	01893503          	ld	a0,24(s2)
    80005492:	fffff097          	auipc	ra,0xfffff
    80005496:	238080e7          	jalr	568(ra) # 800046ca <writei>
    8000549a:	84aa                	mv	s1,a0
    8000549c:	00a05763          	blez	a0,800054aa <filewrite+0xc2>
        f->off += r;
    800054a0:	02092783          	lw	a5,32(s2)
    800054a4:	9fa9                	addw	a5,a5,a0
    800054a6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800054aa:	01893503          	ld	a0,24(s2)
    800054ae:	fffff097          	auipc	ra,0xfffff
    800054b2:	f20080e7          	jalr	-224(ra) # 800043ce <iunlock>
      end_op();
    800054b6:	00000097          	auipc	ra,0x0
    800054ba:	8b6080e7          	jalr	-1866(ra) # 80004d6c <end_op>

      if(r != n1){
    800054be:	02999563          	bne	s3,s1,800054e8 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    800054c2:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800054c6:	015a5963          	bge	s4,s5,800054d8 <filewrite+0xf0>
      int n1 = n - i;
    800054ca:	414a87bb          	subw	a5,s5,s4
    800054ce:	89be                	mv	s3,a5
      if(n1 > max)
    800054d0:	f8fbdee3          	bge	s7,a5,8000546c <filewrite+0x84>
    800054d4:	89e6                	mv	s3,s9
    800054d6:	bf59                	j	8000546c <filewrite+0x84>
    800054d8:	64a6                	ld	s1,72(sp)
    800054da:	79e2                	ld	s3,56(sp)
    800054dc:	6be2                	ld	s7,24(sp)
    800054de:	6c42                	ld	s8,16(sp)
    800054e0:	6ca2                	ld	s9,8(sp)
    800054e2:	a801                	j	800054f2 <filewrite+0x10a>
    int i = 0;
    800054e4:	4a01                	li	s4,0
    800054e6:	a031                	j	800054f2 <filewrite+0x10a>
    800054e8:	64a6                	ld	s1,72(sp)
    800054ea:	79e2                	ld	s3,56(sp)
    800054ec:	6be2                	ld	s7,24(sp)
    800054ee:	6c42                	ld	s8,16(sp)
    800054f0:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800054f2:	034a9f63          	bne	s5,s4,80005530 <filewrite+0x148>
    800054f6:	8556                	mv	a0,s5
    800054f8:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800054fa:	60e6                	ld	ra,88(sp)
    800054fc:	6446                	ld	s0,80(sp)
    800054fe:	6906                	ld	s2,64(sp)
    80005500:	7aa2                	ld	s5,40(sp)
    80005502:	7b02                	ld	s6,32(sp)
    80005504:	6125                	addi	sp,sp,96
    80005506:	8082                	ret
    80005508:	e4a6                	sd	s1,72(sp)
    8000550a:	fc4e                	sd	s3,56(sp)
    8000550c:	f852                	sd	s4,48(sp)
    8000550e:	ec5e                	sd	s7,24(sp)
    80005510:	e862                	sd	s8,16(sp)
    80005512:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80005514:	00004517          	auipc	a0,0x4
    80005518:	17c50513          	addi	a0,a0,380 # 80009690 <etext+0x690>
    8000551c:	ffffb097          	auipc	ra,0xffffb
    80005520:	044080e7          	jalr	68(ra) # 80000560 <panic>
    return -1;
    80005524:	557d                	li	a0,-1
}
    80005526:	8082                	ret
      return -1;
    80005528:	557d                	li	a0,-1
    8000552a:	bfc1                	j	800054fa <filewrite+0x112>
    8000552c:	557d                	li	a0,-1
    8000552e:	b7f1                	j	800054fa <filewrite+0x112>
    ret = (i == n ? n : -1);
    80005530:	557d                	li	a0,-1
    80005532:	7a42                	ld	s4,48(sp)
    80005534:	b7d9                	j	800054fa <filewrite+0x112>

0000000080005536 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005536:	7179                	addi	sp,sp,-48
    80005538:	f406                	sd	ra,40(sp)
    8000553a:	f022                	sd	s0,32(sp)
    8000553c:	ec26                	sd	s1,24(sp)
    8000553e:	e052                	sd	s4,0(sp)
    80005540:	1800                	addi	s0,sp,48
    80005542:	84aa                	mv	s1,a0
    80005544:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005546:	0005b023          	sd	zero,0(a1)
    8000554a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000554e:	00000097          	auipc	ra,0x0
    80005552:	bb8080e7          	jalr	-1096(ra) # 80005106 <filealloc>
    80005556:	e088                	sd	a0,0(s1)
    80005558:	cd49                	beqz	a0,800055f2 <pipealloc+0xbc>
    8000555a:	00000097          	auipc	ra,0x0
    8000555e:	bac080e7          	jalr	-1108(ra) # 80005106 <filealloc>
    80005562:	00aa3023          	sd	a0,0(s4)
    80005566:	c141                	beqz	a0,800055e6 <pipealloc+0xb0>
    80005568:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000556a:	ffffb097          	auipc	ra,0xffffb
    8000556e:	69a080e7          	jalr	1690(ra) # 80000c04 <kalloc>
    80005572:	892a                	mv	s2,a0
    80005574:	c13d                	beqz	a0,800055da <pipealloc+0xa4>
    80005576:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80005578:	4985                	li	s3,1
    8000557a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000557e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005582:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005586:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000558a:	00004597          	auipc	a1,0x4
    8000558e:	11658593          	addi	a1,a1,278 # 800096a0 <etext+0x6a0>
    80005592:	ffffb097          	auipc	ra,0xffffb
    80005596:	6f0080e7          	jalr	1776(ra) # 80000c82 <initlock>
  (*f0)->type = FD_PIPE;
    8000559a:	609c                	ld	a5,0(s1)
    8000559c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800055a0:	609c                	ld	a5,0(s1)
    800055a2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800055a6:	609c                	ld	a5,0(s1)
    800055a8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800055ac:	609c                	ld	a5,0(s1)
    800055ae:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800055b2:	000a3783          	ld	a5,0(s4)
    800055b6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800055ba:	000a3783          	ld	a5,0(s4)
    800055be:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800055c2:	000a3783          	ld	a5,0(s4)
    800055c6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800055ca:	000a3783          	ld	a5,0(s4)
    800055ce:	0127b823          	sd	s2,16(a5)
  return 0;
    800055d2:	4501                	li	a0,0
    800055d4:	6942                	ld	s2,16(sp)
    800055d6:	69a2                	ld	s3,8(sp)
    800055d8:	a03d                	j	80005606 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800055da:	6088                	ld	a0,0(s1)
    800055dc:	c119                	beqz	a0,800055e2 <pipealloc+0xac>
    800055de:	6942                	ld	s2,16(sp)
    800055e0:	a029                	j	800055ea <pipealloc+0xb4>
    800055e2:	6942                	ld	s2,16(sp)
    800055e4:	a039                	j	800055f2 <pipealloc+0xbc>
    800055e6:	6088                	ld	a0,0(s1)
    800055e8:	c50d                	beqz	a0,80005612 <pipealloc+0xdc>
    fileclose(*f0);
    800055ea:	00000097          	auipc	ra,0x0
    800055ee:	bd8080e7          	jalr	-1064(ra) # 800051c2 <fileclose>
  if(*f1)
    800055f2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800055f6:	557d                	li	a0,-1
  if(*f1)
    800055f8:	c799                	beqz	a5,80005606 <pipealloc+0xd0>
    fileclose(*f1);
    800055fa:	853e                	mv	a0,a5
    800055fc:	00000097          	auipc	ra,0x0
    80005600:	bc6080e7          	jalr	-1082(ra) # 800051c2 <fileclose>
  return -1;
    80005604:	557d                	li	a0,-1
}
    80005606:	70a2                	ld	ra,40(sp)
    80005608:	7402                	ld	s0,32(sp)
    8000560a:	64e2                	ld	s1,24(sp)
    8000560c:	6a02                	ld	s4,0(sp)
    8000560e:	6145                	addi	sp,sp,48
    80005610:	8082                	ret
  return -1;
    80005612:	557d                	li	a0,-1
    80005614:	bfcd                	j	80005606 <pipealloc+0xd0>

0000000080005616 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005616:	1101                	addi	sp,sp,-32
    80005618:	ec06                	sd	ra,24(sp)
    8000561a:	e822                	sd	s0,16(sp)
    8000561c:	e426                	sd	s1,8(sp)
    8000561e:	e04a                	sd	s2,0(sp)
    80005620:	1000                	addi	s0,sp,32
    80005622:	84aa                	mv	s1,a0
    80005624:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005626:	ffffb097          	auipc	ra,0xffffb
    8000562a:	6f0080e7          	jalr	1776(ra) # 80000d16 <acquire>
  if(writable){
    8000562e:	02090d63          	beqz	s2,80005668 <pipeclose+0x52>
    pi->writeopen = 0;
    80005632:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005636:	21848513          	addi	a0,s1,536
    8000563a:	ffffd097          	auipc	ra,0xffffd
    8000563e:	1fa080e7          	jalr	506(ra) # 80002834 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005642:	2204b783          	ld	a5,544(s1)
    80005646:	eb95                	bnez	a5,8000567a <pipeclose+0x64>
    release(&pi->lock);
    80005648:	8526                	mv	a0,s1
    8000564a:	ffffb097          	auipc	ra,0xffffb
    8000564e:	77c080e7          	jalr	1916(ra) # 80000dc6 <release>
    kfree((char*)pi);
    80005652:	8526                	mv	a0,s1
    80005654:	ffffb097          	auipc	ra,0xffffb
    80005658:	448080e7          	jalr	1096(ra) # 80000a9c <kfree>
  } else
    release(&pi->lock);
}
    8000565c:	60e2                	ld	ra,24(sp)
    8000565e:	6442                	ld	s0,16(sp)
    80005660:	64a2                	ld	s1,8(sp)
    80005662:	6902                	ld	s2,0(sp)
    80005664:	6105                	addi	sp,sp,32
    80005666:	8082                	ret
    pi->readopen = 0;
    80005668:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000566c:	21c48513          	addi	a0,s1,540
    80005670:	ffffd097          	auipc	ra,0xffffd
    80005674:	1c4080e7          	jalr	452(ra) # 80002834 <wakeup>
    80005678:	b7e9                	j	80005642 <pipeclose+0x2c>
    release(&pi->lock);
    8000567a:	8526                	mv	a0,s1
    8000567c:	ffffb097          	auipc	ra,0xffffb
    80005680:	74a080e7          	jalr	1866(ra) # 80000dc6 <release>
}
    80005684:	bfe1                	j	8000565c <pipeclose+0x46>

0000000080005686 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005686:	7159                	addi	sp,sp,-112
    80005688:	f486                	sd	ra,104(sp)
    8000568a:	f0a2                	sd	s0,96(sp)
    8000568c:	eca6                	sd	s1,88(sp)
    8000568e:	e8ca                	sd	s2,80(sp)
    80005690:	e4ce                	sd	s3,72(sp)
    80005692:	e0d2                	sd	s4,64(sp)
    80005694:	fc56                	sd	s5,56(sp)
    80005696:	1880                	addi	s0,sp,112
    80005698:	84aa                	mv	s1,a0
    8000569a:	8aae                	mv	s5,a1
    8000569c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000569e:	ffffd097          	auipc	ra,0xffffd
    800056a2:	884080e7          	jalr	-1916(ra) # 80001f22 <myproc>
    800056a6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800056a8:	8526                	mv	a0,s1
    800056aa:	ffffb097          	auipc	ra,0xffffb
    800056ae:	66c080e7          	jalr	1644(ra) # 80000d16 <acquire>
  while(i < n){
    800056b2:	0f405063          	blez	s4,80005792 <pipewrite+0x10c>
    800056b6:	f85a                	sd	s6,48(sp)
    800056b8:	f45e                	sd	s7,40(sp)
    800056ba:	f062                	sd	s8,32(sp)
    800056bc:	ec66                	sd	s9,24(sp)
    800056be:	e86a                	sd	s10,16(sp)
  int i = 0;
    800056c0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800056c2:	f9f40c13          	addi	s8,s0,-97
    800056c6:	4b85                	li	s7,1
    800056c8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800056ca:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800056ce:	21c48c93          	addi	s9,s1,540
    800056d2:	a099                	j	80005718 <pipewrite+0x92>
      release(&pi->lock);
    800056d4:	8526                	mv	a0,s1
    800056d6:	ffffb097          	auipc	ra,0xffffb
    800056da:	6f0080e7          	jalr	1776(ra) # 80000dc6 <release>
      return -1;
    800056de:	597d                	li	s2,-1
    800056e0:	7b42                	ld	s6,48(sp)
    800056e2:	7ba2                	ld	s7,40(sp)
    800056e4:	7c02                	ld	s8,32(sp)
    800056e6:	6ce2                	ld	s9,24(sp)
    800056e8:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800056ea:	854a                	mv	a0,s2
    800056ec:	70a6                	ld	ra,104(sp)
    800056ee:	7406                	ld	s0,96(sp)
    800056f0:	64e6                	ld	s1,88(sp)
    800056f2:	6946                	ld	s2,80(sp)
    800056f4:	69a6                	ld	s3,72(sp)
    800056f6:	6a06                	ld	s4,64(sp)
    800056f8:	7ae2                	ld	s5,56(sp)
    800056fa:	6165                	addi	sp,sp,112
    800056fc:	8082                	ret
      wakeup(&pi->nread);
    800056fe:	856a                	mv	a0,s10
    80005700:	ffffd097          	auipc	ra,0xffffd
    80005704:	134080e7          	jalr	308(ra) # 80002834 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005708:	85a6                	mv	a1,s1
    8000570a:	8566                	mv	a0,s9
    8000570c:	ffffd097          	auipc	ra,0xffffd
    80005710:	0c4080e7          	jalr	196(ra) # 800027d0 <sleep>
  while(i < n){
    80005714:	05495e63          	bge	s2,s4,80005770 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    80005718:	2204a783          	lw	a5,544(s1)
    8000571c:	dfc5                	beqz	a5,800056d4 <pipewrite+0x4e>
    8000571e:	854e                	mv	a0,s3
    80005720:	ffffd097          	auipc	ra,0xffffd
    80005724:	4d6080e7          	jalr	1238(ra) # 80002bf6 <killed>
    80005728:	f555                	bnez	a0,800056d4 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000572a:	2184a783          	lw	a5,536(s1)
    8000572e:	21c4a703          	lw	a4,540(s1)
    80005732:	2007879b          	addiw	a5,a5,512
    80005736:	fcf704e3          	beq	a4,a5,800056fe <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000573a:	86de                	mv	a3,s7
    8000573c:	01590633          	add	a2,s2,s5
    80005740:	85e2                	mv	a1,s8
    80005742:	0509b503          	ld	a0,80(s3)
    80005746:	ffffc097          	auipc	ra,0xffffc
    8000574a:	510080e7          	jalr	1296(ra) # 80001c56 <copyin>
    8000574e:	05650463          	beq	a0,s6,80005796 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005752:	21c4a783          	lw	a5,540(s1)
    80005756:	0017871b          	addiw	a4,a5,1
    8000575a:	20e4ae23          	sw	a4,540(s1)
    8000575e:	1ff7f793          	andi	a5,a5,511
    80005762:	97a6                	add	a5,a5,s1
    80005764:	f9f44703          	lbu	a4,-97(s0)
    80005768:	00e78c23          	sb	a4,24(a5)
      i++;
    8000576c:	2905                	addiw	s2,s2,1
    8000576e:	b75d                	j	80005714 <pipewrite+0x8e>
    80005770:	7b42                	ld	s6,48(sp)
    80005772:	7ba2                	ld	s7,40(sp)
    80005774:	7c02                	ld	s8,32(sp)
    80005776:	6ce2                	ld	s9,24(sp)
    80005778:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000577a:	21848513          	addi	a0,s1,536
    8000577e:	ffffd097          	auipc	ra,0xffffd
    80005782:	0b6080e7          	jalr	182(ra) # 80002834 <wakeup>
  release(&pi->lock);
    80005786:	8526                	mv	a0,s1
    80005788:	ffffb097          	auipc	ra,0xffffb
    8000578c:	63e080e7          	jalr	1598(ra) # 80000dc6 <release>
  return i;
    80005790:	bfa9                	j	800056ea <pipewrite+0x64>
  int i = 0;
    80005792:	4901                	li	s2,0
    80005794:	b7dd                	j	8000577a <pipewrite+0xf4>
    80005796:	7b42                	ld	s6,48(sp)
    80005798:	7ba2                	ld	s7,40(sp)
    8000579a:	7c02                	ld	s8,32(sp)
    8000579c:	6ce2                	ld	s9,24(sp)
    8000579e:	6d42                	ld	s10,16(sp)
    800057a0:	bfe9                	j	8000577a <pipewrite+0xf4>

00000000800057a2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800057a2:	711d                	addi	sp,sp,-96
    800057a4:	ec86                	sd	ra,88(sp)
    800057a6:	e8a2                	sd	s0,80(sp)
    800057a8:	e4a6                	sd	s1,72(sp)
    800057aa:	e0ca                	sd	s2,64(sp)
    800057ac:	fc4e                	sd	s3,56(sp)
    800057ae:	f852                	sd	s4,48(sp)
    800057b0:	f456                	sd	s5,40(sp)
    800057b2:	1080                	addi	s0,sp,96
    800057b4:	84aa                	mv	s1,a0
    800057b6:	892e                	mv	s2,a1
    800057b8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800057ba:	ffffc097          	auipc	ra,0xffffc
    800057be:	768080e7          	jalr	1896(ra) # 80001f22 <myproc>
    800057c2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800057c4:	8526                	mv	a0,s1
    800057c6:	ffffb097          	auipc	ra,0xffffb
    800057ca:	550080e7          	jalr	1360(ra) # 80000d16 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800057ce:	2184a703          	lw	a4,536(s1)
    800057d2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800057d6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800057da:	02f71b63          	bne	a4,a5,80005810 <piperead+0x6e>
    800057de:	2244a783          	lw	a5,548(s1)
    800057e2:	c3b1                	beqz	a5,80005826 <piperead+0x84>
    if(killed(pr)){
    800057e4:	8552                	mv	a0,s4
    800057e6:	ffffd097          	auipc	ra,0xffffd
    800057ea:	410080e7          	jalr	1040(ra) # 80002bf6 <killed>
    800057ee:	e50d                	bnez	a0,80005818 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800057f0:	85a6                	mv	a1,s1
    800057f2:	854e                	mv	a0,s3
    800057f4:	ffffd097          	auipc	ra,0xffffd
    800057f8:	fdc080e7          	jalr	-36(ra) # 800027d0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800057fc:	2184a703          	lw	a4,536(s1)
    80005800:	21c4a783          	lw	a5,540(s1)
    80005804:	fcf70de3          	beq	a4,a5,800057de <piperead+0x3c>
    80005808:	f05a                	sd	s6,32(sp)
    8000580a:	ec5e                	sd	s7,24(sp)
    8000580c:	e862                	sd	s8,16(sp)
    8000580e:	a839                	j	8000582c <piperead+0x8a>
    80005810:	f05a                	sd	s6,32(sp)
    80005812:	ec5e                	sd	s7,24(sp)
    80005814:	e862                	sd	s8,16(sp)
    80005816:	a819                	j	8000582c <piperead+0x8a>
      release(&pi->lock);
    80005818:	8526                	mv	a0,s1
    8000581a:	ffffb097          	auipc	ra,0xffffb
    8000581e:	5ac080e7          	jalr	1452(ra) # 80000dc6 <release>
      return -1;
    80005822:	59fd                	li	s3,-1
    80005824:	a895                	j	80005898 <piperead+0xf6>
    80005826:	f05a                	sd	s6,32(sp)
    80005828:	ec5e                	sd	s7,24(sp)
    8000582a:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000582c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000582e:	faf40c13          	addi	s8,s0,-81
    80005832:	4b85                	li	s7,1
    80005834:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005836:	05505363          	blez	s5,8000587c <piperead+0xda>
    if(pi->nread == pi->nwrite)
    8000583a:	2184a783          	lw	a5,536(s1)
    8000583e:	21c4a703          	lw	a4,540(s1)
    80005842:	02f70d63          	beq	a4,a5,8000587c <piperead+0xda>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005846:	0017871b          	addiw	a4,a5,1
    8000584a:	20e4ac23          	sw	a4,536(s1)
    8000584e:	1ff7f793          	andi	a5,a5,511
    80005852:	97a6                	add	a5,a5,s1
    80005854:	0187c783          	lbu	a5,24(a5)
    80005858:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000585c:	86de                	mv	a3,s7
    8000585e:	8662                	mv	a2,s8
    80005860:	85ca                	mv	a1,s2
    80005862:	050a3503          	ld	a0,80(s4)
    80005866:	ffffc097          	auipc	ra,0xffffc
    8000586a:	364080e7          	jalr	868(ra) # 80001bca <copyout>
    8000586e:	01650763          	beq	a0,s6,8000587c <piperead+0xda>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005872:	2985                	addiw	s3,s3,1
    80005874:	0905                	addi	s2,s2,1
    80005876:	fd3a92e3          	bne	s5,s3,8000583a <piperead+0x98>
    8000587a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000587c:	21c48513          	addi	a0,s1,540
    80005880:	ffffd097          	auipc	ra,0xffffd
    80005884:	fb4080e7          	jalr	-76(ra) # 80002834 <wakeup>
  release(&pi->lock);
    80005888:	8526                	mv	a0,s1
    8000588a:	ffffb097          	auipc	ra,0xffffb
    8000588e:	53c080e7          	jalr	1340(ra) # 80000dc6 <release>
    80005892:	7b02                	ld	s6,32(sp)
    80005894:	6be2                	ld	s7,24(sp)
    80005896:	6c42                	ld	s8,16(sp)
  return i;
}
    80005898:	854e                	mv	a0,s3
    8000589a:	60e6                	ld	ra,88(sp)
    8000589c:	6446                	ld	s0,80(sp)
    8000589e:	64a6                	ld	s1,72(sp)
    800058a0:	6906                	ld	s2,64(sp)
    800058a2:	79e2                	ld	s3,56(sp)
    800058a4:	7a42                	ld	s4,48(sp)
    800058a6:	7aa2                	ld	s5,40(sp)
    800058a8:	6125                	addi	sp,sp,96
    800058aa:	8082                	ret

00000000800058ac <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800058ac:	1141                	addi	sp,sp,-16
    800058ae:	e406                	sd	ra,8(sp)
    800058b0:	e022                	sd	s0,0(sp)
    800058b2:	0800                	addi	s0,sp,16
    800058b4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800058b6:	0035151b          	slliw	a0,a0,0x3
    800058ba:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800058bc:	8b89                	andi	a5,a5,2
    800058be:	c399                	beqz	a5,800058c4 <flags2perm+0x18>
      perm |= PTE_W;
    800058c0:	00456513          	ori	a0,a0,4
    return perm;
}
    800058c4:	60a2                	ld	ra,8(sp)
    800058c6:	6402                	ld	s0,0(sp)
    800058c8:	0141                	addi	sp,sp,16
    800058ca:	8082                	ret

00000000800058cc <exec>:

int
exec(char *path, char **argv)
{
    800058cc:	de010113          	addi	sp,sp,-544
    800058d0:	20113c23          	sd	ra,536(sp)
    800058d4:	20813823          	sd	s0,528(sp)
    800058d8:	20913423          	sd	s1,520(sp)
    800058dc:	21213023          	sd	s2,512(sp)
    800058e0:	1400                	addi	s0,sp,544
    800058e2:	892a                	mv	s2,a0
    800058e4:	dea43823          	sd	a0,-528(s0)
    800058e8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800058ec:	ffffc097          	auipc	ra,0xffffc
    800058f0:	636080e7          	jalr	1590(ra) # 80001f22 <myproc>
    800058f4:	84aa                	mv	s1,a0

  begin_op();
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	3fc080e7          	jalr	1020(ra) # 80004cf2 <begin_op>

  if((ip = namei(path)) == 0){
    800058fe:	854a                	mv	a0,s2
    80005900:	fffff097          	auipc	ra,0xfffff
    80005904:	1ec080e7          	jalr	492(ra) # 80004aec <namei>
    80005908:	c525                	beqz	a0,80005970 <exec+0xa4>
    8000590a:	fbd2                	sd	s4,496(sp)
    8000590c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000590e:	fffff097          	auipc	ra,0xfffff
    80005912:	9fa080e7          	jalr	-1542(ra) # 80004308 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005916:	04000713          	li	a4,64
    8000591a:	4681                	li	a3,0
    8000591c:	e5040613          	addi	a2,s0,-432
    80005920:	4581                	li	a1,0
    80005922:	8552                	mv	a0,s4
    80005924:	fffff097          	auipc	ra,0xfffff
    80005928:	ca0080e7          	jalr	-864(ra) # 800045c4 <readi>
    8000592c:	04000793          	li	a5,64
    80005930:	00f51a63          	bne	a0,a5,80005944 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005934:	e5042703          	lw	a4,-432(s0)
    80005938:	464c47b7          	lui	a5,0x464c4
    8000593c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005940:	02f70e63          	beq	a4,a5,8000597c <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005944:	8552                	mv	a0,s4
    80005946:	fffff097          	auipc	ra,0xfffff
    8000594a:	c28080e7          	jalr	-984(ra) # 8000456e <iunlockput>
    end_op();
    8000594e:	fffff097          	auipc	ra,0xfffff
    80005952:	41e080e7          	jalr	1054(ra) # 80004d6c <end_op>
  }
  return -1;
    80005956:	557d                	li	a0,-1
    80005958:	7a5e                	ld	s4,496(sp)
}
    8000595a:	21813083          	ld	ra,536(sp)
    8000595e:	21013403          	ld	s0,528(sp)
    80005962:	20813483          	ld	s1,520(sp)
    80005966:	20013903          	ld	s2,512(sp)
    8000596a:	22010113          	addi	sp,sp,544
    8000596e:	8082                	ret
    end_op();
    80005970:	fffff097          	auipc	ra,0xfffff
    80005974:	3fc080e7          	jalr	1020(ra) # 80004d6c <end_op>
    return -1;
    80005978:	557d                	li	a0,-1
    8000597a:	b7c5                	j	8000595a <exec+0x8e>
    8000597c:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000597e:	8526                	mv	a0,s1
    80005980:	ffffc097          	auipc	ra,0xffffc
    80005984:	666080e7          	jalr	1638(ra) # 80001fe6 <proc_pagetable>
    80005988:	8b2a                	mv	s6,a0
    8000598a:	2c050163          	beqz	a0,80005c4c <exec+0x380>
    8000598e:	ffce                	sd	s3,504(sp)
    80005990:	f7d6                	sd	s5,488(sp)
    80005992:	efde                	sd	s7,472(sp)
    80005994:	ebe2                	sd	s8,464(sp)
    80005996:	e7e6                	sd	s9,456(sp)
    80005998:	e3ea                	sd	s10,448(sp)
    8000599a:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000599c:	e7042683          	lw	a3,-400(s0)
    800059a0:	e8845783          	lhu	a5,-376(s0)
    800059a4:	10078363          	beqz	a5,80005aaa <exec+0x1de>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800059a8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800059aa:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800059ac:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800059b0:	6c85                	lui	s9,0x1
    800059b2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800059b6:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800059ba:	6a85                	lui	s5,0x1
    800059bc:	a0b5                	j	80005a28 <exec+0x15c>
      panic("loadseg: address should exist");
    800059be:	00004517          	auipc	a0,0x4
    800059c2:	cea50513          	addi	a0,a0,-790 # 800096a8 <etext+0x6a8>
    800059c6:	ffffb097          	auipc	ra,0xffffb
    800059ca:	b9a080e7          	jalr	-1126(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    800059ce:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800059d0:	874a                	mv	a4,s2
    800059d2:	009c06bb          	addw	a3,s8,s1
    800059d6:	4581                	li	a1,0
    800059d8:	8552                	mv	a0,s4
    800059da:	fffff097          	auipc	ra,0xfffff
    800059de:	bea080e7          	jalr	-1046(ra) # 800045c4 <readi>
    800059e2:	26a91963          	bne	s2,a0,80005c54 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800059e6:	009a84bb          	addw	s1,s5,s1
    800059ea:	0334f463          	bgeu	s1,s3,80005a12 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    800059ee:	02049593          	slli	a1,s1,0x20
    800059f2:	9181                	srli	a1,a1,0x20
    800059f4:	95de                	add	a1,a1,s7
    800059f6:	855a                	mv	a0,s6
    800059f8:	ffffc097          	auipc	ra,0xffffc
    800059fc:	898080e7          	jalr	-1896(ra) # 80001290 <walkaddr>
    80005a00:	862a                	mv	a2,a0
    if(pa == 0)
    80005a02:	dd55                	beqz	a0,800059be <exec+0xf2>
    if(sz - i < PGSIZE)
    80005a04:	409987bb          	subw	a5,s3,s1
    80005a08:	893e                	mv	s2,a5
    80005a0a:	fcfcf2e3          	bgeu	s9,a5,800059ce <exec+0x102>
    80005a0e:	8956                	mv	s2,s5
    80005a10:	bf7d                	j	800059ce <exec+0x102>
    sz = sz1;
    80005a12:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005a16:	2d05                	addiw	s10,s10,1
    80005a18:	e0843783          	ld	a5,-504(s0)
    80005a1c:	0387869b          	addiw	a3,a5,56
    80005a20:	e8845783          	lhu	a5,-376(s0)
    80005a24:	08fd5463          	bge	s10,a5,80005aac <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005a28:	e0d43423          	sd	a3,-504(s0)
    80005a2c:	876e                	mv	a4,s11
    80005a2e:	e1840613          	addi	a2,s0,-488
    80005a32:	4581                	li	a1,0
    80005a34:	8552                	mv	a0,s4
    80005a36:	fffff097          	auipc	ra,0xfffff
    80005a3a:	b8e080e7          	jalr	-1138(ra) # 800045c4 <readi>
    80005a3e:	21b51963          	bne	a0,s11,80005c50 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    80005a42:	e1842783          	lw	a5,-488(s0)
    80005a46:	4705                	li	a4,1
    80005a48:	fce797e3          	bne	a5,a4,80005a16 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    80005a4c:	e4043483          	ld	s1,-448(s0)
    80005a50:	e3843783          	ld	a5,-456(s0)
    80005a54:	22f4e063          	bltu	s1,a5,80005c74 <exec+0x3a8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005a58:	e2843783          	ld	a5,-472(s0)
    80005a5c:	94be                	add	s1,s1,a5
    80005a5e:	20f4ee63          	bltu	s1,a5,80005c7a <exec+0x3ae>
    if(ph.vaddr % PGSIZE != 0)
    80005a62:	de843703          	ld	a4,-536(s0)
    80005a66:	8ff9                	and	a5,a5,a4
    80005a68:	20079c63          	bnez	a5,80005c80 <exec+0x3b4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005a6c:	e1c42503          	lw	a0,-484(s0)
    80005a70:	00000097          	auipc	ra,0x0
    80005a74:	e3c080e7          	jalr	-452(ra) # 800058ac <flags2perm>
    80005a78:	86aa                	mv	a3,a0
    80005a7a:	8626                	mv	a2,s1
    80005a7c:	85ca                	mv	a1,s2
    80005a7e:	855a                	mv	a0,s6
    80005a80:	ffffc097          	auipc	ra,0xffffc
    80005a84:	be8080e7          	jalr	-1048(ra) # 80001668 <uvmalloc>
    80005a88:	dea43c23          	sd	a0,-520(s0)
    80005a8c:	1e050d63          	beqz	a0,80005c86 <exec+0x3ba>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005a90:	e2843b83          	ld	s7,-472(s0)
    80005a94:	e2042c03          	lw	s8,-480(s0)
    80005a98:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005a9c:	00098463          	beqz	s3,80005aa4 <exec+0x1d8>
    80005aa0:	4481                	li	s1,0
    80005aa2:	b7b1                	j	800059ee <exec+0x122>
    sz = sz1;
    80005aa4:	df843903          	ld	s2,-520(s0)
    80005aa8:	b7bd                	j	80005a16 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005aaa:	4901                	li	s2,0
  iunlockput(ip);
    80005aac:	8552                	mv	a0,s4
    80005aae:	fffff097          	auipc	ra,0xfffff
    80005ab2:	ac0080e7          	jalr	-1344(ra) # 8000456e <iunlockput>
  end_op();
    80005ab6:	fffff097          	auipc	ra,0xfffff
    80005aba:	2b6080e7          	jalr	694(ra) # 80004d6c <end_op>
  p = myproc();
    80005abe:	ffffc097          	auipc	ra,0xffffc
    80005ac2:	464080e7          	jalr	1124(ra) # 80001f22 <myproc>
    80005ac6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005ac8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005acc:	6985                	lui	s3,0x1
    80005ace:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005ad0:	99ca                	add	s3,s3,s2
    80005ad2:	77fd                	lui	a5,0xfffff
    80005ad4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005ad8:	4691                	li	a3,4
    80005ada:	6609                	lui	a2,0x2
    80005adc:	964e                	add	a2,a2,s3
    80005ade:	85ce                	mv	a1,s3
    80005ae0:	855a                	mv	a0,s6
    80005ae2:	ffffc097          	auipc	ra,0xffffc
    80005ae6:	b86080e7          	jalr	-1146(ra) # 80001668 <uvmalloc>
    80005aea:	8a2a                	mv	s4,a0
    80005aec:	e115                	bnez	a0,80005b10 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    80005aee:	85ce                	mv	a1,s3
    80005af0:	855a                	mv	a0,s6
    80005af2:	ffffc097          	auipc	ra,0xffffc
    80005af6:	590080e7          	jalr	1424(ra) # 80002082 <proc_freepagetable>
  return -1;
    80005afa:	557d                	li	a0,-1
    80005afc:	79fe                	ld	s3,504(sp)
    80005afe:	7a5e                	ld	s4,496(sp)
    80005b00:	7abe                	ld	s5,488(sp)
    80005b02:	7b1e                	ld	s6,480(sp)
    80005b04:	6bfe                	ld	s7,472(sp)
    80005b06:	6c5e                	ld	s8,464(sp)
    80005b08:	6cbe                	ld	s9,456(sp)
    80005b0a:	6d1e                	ld	s10,448(sp)
    80005b0c:	7dfa                	ld	s11,440(sp)
    80005b0e:	b5b1                	j	8000595a <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005b10:	75f9                	lui	a1,0xffffe
    80005b12:	95aa                	add	a1,a1,a0
    80005b14:	855a                	mv	a0,s6
    80005b16:	ffffc097          	auipc	ra,0xffffc
    80005b1a:	082080e7          	jalr	130(ra) # 80001b98 <uvmclear>
  stackbase = sp - PGSIZE;
    80005b1e:	7bfd                	lui	s7,0xfffff
    80005b20:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80005b22:	e0043783          	ld	a5,-512(s0)
    80005b26:	6388                	ld	a0,0(a5)
  sp = sz;
    80005b28:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80005b2a:	4481                	li	s1,0
    ustack[argc] = sp;
    80005b2c:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005b30:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005b34:	c135                	beqz	a0,80005b98 <exec+0x2cc>
    sp -= strlen(argv[argc]) + 1;
    80005b36:	ffffb097          	auipc	ra,0xffffb
    80005b3a:	464080e7          	jalr	1124(ra) # 80000f9a <strlen>
    80005b3e:	0015079b          	addiw	a5,a0,1
    80005b42:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005b46:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005b4a:	15796163          	bltu	s2,s7,80005c8c <exec+0x3c0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005b4e:	e0043d83          	ld	s11,-512(s0)
    80005b52:	000db983          	ld	s3,0(s11)
    80005b56:	854e                	mv	a0,s3
    80005b58:	ffffb097          	auipc	ra,0xffffb
    80005b5c:	442080e7          	jalr	1090(ra) # 80000f9a <strlen>
    80005b60:	0015069b          	addiw	a3,a0,1
    80005b64:	864e                	mv	a2,s3
    80005b66:	85ca                	mv	a1,s2
    80005b68:	855a                	mv	a0,s6
    80005b6a:	ffffc097          	auipc	ra,0xffffc
    80005b6e:	060080e7          	jalr	96(ra) # 80001bca <copyout>
    80005b72:	10054f63          	bltz	a0,80005c90 <exec+0x3c4>
    ustack[argc] = sp;
    80005b76:	00349793          	slli	a5,s1,0x3
    80005b7a:	97e6                	add	a5,a5,s9
    80005b7c:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ff90d08>
  for(argc = 0; argv[argc]; argc++) {
    80005b80:	0485                	addi	s1,s1,1
    80005b82:	008d8793          	addi	a5,s11,8
    80005b86:	e0f43023          	sd	a5,-512(s0)
    80005b8a:	008db503          	ld	a0,8(s11)
    80005b8e:	c509                	beqz	a0,80005b98 <exec+0x2cc>
    if(argc >= MAXARG)
    80005b90:	fb8493e3          	bne	s1,s8,80005b36 <exec+0x26a>
  sz = sz1;
    80005b94:	89d2                	mv	s3,s4
    80005b96:	bfa1                	j	80005aee <exec+0x222>
  ustack[argc] = 0;
    80005b98:	00349793          	slli	a5,s1,0x3
    80005b9c:	f9078793          	addi	a5,a5,-112
    80005ba0:	97a2                	add	a5,a5,s0
    80005ba2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005ba6:	00148693          	addi	a3,s1,1
    80005baa:	068e                	slli	a3,a3,0x3
    80005bac:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005bb0:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005bb4:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005bb6:	f3796ce3          	bltu	s2,s7,80005aee <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005bba:	e9040613          	addi	a2,s0,-368
    80005bbe:	85ca                	mv	a1,s2
    80005bc0:	855a                	mv	a0,s6
    80005bc2:	ffffc097          	auipc	ra,0xffffc
    80005bc6:	008080e7          	jalr	8(ra) # 80001bca <copyout>
    80005bca:	f20542e3          	bltz	a0,80005aee <exec+0x222>
  p->trapframe->a1 = sp;
    80005bce:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005bd2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005bd6:	df043783          	ld	a5,-528(s0)
    80005bda:	0007c703          	lbu	a4,0(a5)
    80005bde:	cf11                	beqz	a4,80005bfa <exec+0x32e>
    80005be0:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005be2:	02f00693          	li	a3,47
    80005be6:	a029                	j	80005bf0 <exec+0x324>
  for(last=s=path; *s; s++)
    80005be8:	0785                	addi	a5,a5,1
    80005bea:	fff7c703          	lbu	a4,-1(a5)
    80005bee:	c711                	beqz	a4,80005bfa <exec+0x32e>
    if(*s == '/')
    80005bf0:	fed71ce3          	bne	a4,a3,80005be8 <exec+0x31c>
      last = s+1;
    80005bf4:	def43823          	sd	a5,-528(s0)
    80005bf8:	bfc5                	j	80005be8 <exec+0x31c>
  safestrcpy(p->name, last, sizeof(p->name));
    80005bfa:	4641                	li	a2,16
    80005bfc:	df043583          	ld	a1,-528(s0)
    80005c00:	158a8513          	addi	a0,s5,344
    80005c04:	ffffb097          	auipc	ra,0xffffb
    80005c08:	360080e7          	jalr	864(ra) # 80000f64 <safestrcpy>
  oldpagetable = p->pagetable;
    80005c0c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005c10:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005c14:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005c18:	058ab783          	ld	a5,88(s5)
    80005c1c:	e6843703          	ld	a4,-408(s0)
    80005c20:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005c22:	058ab783          	ld	a5,88(s5)
    80005c26:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005c2a:	85ea                	mv	a1,s10
    80005c2c:	ffffc097          	auipc	ra,0xffffc
    80005c30:	456080e7          	jalr	1110(ra) # 80002082 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005c34:	0004851b          	sext.w	a0,s1
    80005c38:	79fe                	ld	s3,504(sp)
    80005c3a:	7a5e                	ld	s4,496(sp)
    80005c3c:	7abe                	ld	s5,488(sp)
    80005c3e:	7b1e                	ld	s6,480(sp)
    80005c40:	6bfe                	ld	s7,472(sp)
    80005c42:	6c5e                	ld	s8,464(sp)
    80005c44:	6cbe                	ld	s9,456(sp)
    80005c46:	6d1e                	ld	s10,448(sp)
    80005c48:	7dfa                	ld	s11,440(sp)
    80005c4a:	bb01                	j	8000595a <exec+0x8e>
    80005c4c:	7b1e                	ld	s6,480(sp)
    80005c4e:	b9dd                	j	80005944 <exec+0x78>
    80005c50:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005c54:	df843583          	ld	a1,-520(s0)
    80005c58:	855a                	mv	a0,s6
    80005c5a:	ffffc097          	auipc	ra,0xffffc
    80005c5e:	428080e7          	jalr	1064(ra) # 80002082 <proc_freepagetable>
  if(ip){
    80005c62:	79fe                	ld	s3,504(sp)
    80005c64:	7abe                	ld	s5,488(sp)
    80005c66:	7b1e                	ld	s6,480(sp)
    80005c68:	6bfe                	ld	s7,472(sp)
    80005c6a:	6c5e                	ld	s8,464(sp)
    80005c6c:	6cbe                	ld	s9,456(sp)
    80005c6e:	6d1e                	ld	s10,448(sp)
    80005c70:	7dfa                	ld	s11,440(sp)
    80005c72:	b9c9                	j	80005944 <exec+0x78>
    80005c74:	df243c23          	sd	s2,-520(s0)
    80005c78:	bff1                	j	80005c54 <exec+0x388>
    80005c7a:	df243c23          	sd	s2,-520(s0)
    80005c7e:	bfd9                	j	80005c54 <exec+0x388>
    80005c80:	df243c23          	sd	s2,-520(s0)
    80005c84:	bfc1                	j	80005c54 <exec+0x388>
    80005c86:	df243c23          	sd	s2,-520(s0)
    80005c8a:	b7e9                	j	80005c54 <exec+0x388>
  sz = sz1;
    80005c8c:	89d2                	mv	s3,s4
    80005c8e:	b585                	j	80005aee <exec+0x222>
    80005c90:	89d2                	mv	s3,s4
    80005c92:	bdb1                	j	80005aee <exec+0x222>

0000000080005c94 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005c94:	7179                	addi	sp,sp,-48
    80005c96:	f406                	sd	ra,40(sp)
    80005c98:	f022                	sd	s0,32(sp)
    80005c9a:	ec26                	sd	s1,24(sp)
    80005c9c:	e84a                	sd	s2,16(sp)
    80005c9e:	1800                	addi	s0,sp,48
    80005ca0:	892e                	mv	s2,a1
    80005ca2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005ca4:	fdc40593          	addi	a1,s0,-36
    80005ca8:	ffffe097          	auipc	ra,0xffffe
    80005cac:	894080e7          	jalr	-1900(ra) # 8000353c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005cb0:	fdc42703          	lw	a4,-36(s0)
    80005cb4:	47bd                	li	a5,15
    80005cb6:	02e7eb63          	bltu	a5,a4,80005cec <argfd+0x58>
    80005cba:	ffffc097          	auipc	ra,0xffffc
    80005cbe:	268080e7          	jalr	616(ra) # 80001f22 <myproc>
    80005cc2:	fdc42703          	lw	a4,-36(s0)
    80005cc6:	01a70793          	addi	a5,a4,26
    80005cca:	078e                	slli	a5,a5,0x3
    80005ccc:	953e                	add	a0,a0,a5
    80005cce:	611c                	ld	a5,0(a0)
    80005cd0:	c385                	beqz	a5,80005cf0 <argfd+0x5c>
    return -1;
  if(pfd)
    80005cd2:	00090463          	beqz	s2,80005cda <argfd+0x46>
    *pfd = fd;
    80005cd6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005cda:	4501                	li	a0,0
  if(pf)
    80005cdc:	c091                	beqz	s1,80005ce0 <argfd+0x4c>
    *pf = f;
    80005cde:	e09c                	sd	a5,0(s1)
}
    80005ce0:	70a2                	ld	ra,40(sp)
    80005ce2:	7402                	ld	s0,32(sp)
    80005ce4:	64e2                	ld	s1,24(sp)
    80005ce6:	6942                	ld	s2,16(sp)
    80005ce8:	6145                	addi	sp,sp,48
    80005cea:	8082                	ret
    return -1;
    80005cec:	557d                	li	a0,-1
    80005cee:	bfcd                	j	80005ce0 <argfd+0x4c>
    80005cf0:	557d                	li	a0,-1
    80005cf2:	b7fd                	j	80005ce0 <argfd+0x4c>

0000000080005cf4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005cf4:	1101                	addi	sp,sp,-32
    80005cf6:	ec06                	sd	ra,24(sp)
    80005cf8:	e822                	sd	s0,16(sp)
    80005cfa:	e426                	sd	s1,8(sp)
    80005cfc:	1000                	addi	s0,sp,32
    80005cfe:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005d00:	ffffc097          	auipc	ra,0xffffc
    80005d04:	222080e7          	jalr	546(ra) # 80001f22 <myproc>
    80005d08:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005d0a:	0d050793          	addi	a5,a0,208
    80005d0e:	4501                	li	a0,0
    80005d10:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005d12:	6398                	ld	a4,0(a5)
    80005d14:	cb19                	beqz	a4,80005d2a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005d16:	2505                	addiw	a0,a0,1
    80005d18:	07a1                	addi	a5,a5,8
    80005d1a:	fed51ce3          	bne	a0,a3,80005d12 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005d1e:	557d                	li	a0,-1
}
    80005d20:	60e2                	ld	ra,24(sp)
    80005d22:	6442                	ld	s0,16(sp)
    80005d24:	64a2                	ld	s1,8(sp)
    80005d26:	6105                	addi	sp,sp,32
    80005d28:	8082                	ret
      p->ofile[fd] = f;
    80005d2a:	01a50793          	addi	a5,a0,26
    80005d2e:	078e                	slli	a5,a5,0x3
    80005d30:	963e                	add	a2,a2,a5
    80005d32:	e204                	sd	s1,0(a2)
      return fd;
    80005d34:	b7f5                	j	80005d20 <fdalloc+0x2c>

0000000080005d36 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005d36:	715d                	addi	sp,sp,-80
    80005d38:	e486                	sd	ra,72(sp)
    80005d3a:	e0a2                	sd	s0,64(sp)
    80005d3c:	fc26                	sd	s1,56(sp)
    80005d3e:	f84a                	sd	s2,48(sp)
    80005d40:	f44e                	sd	s3,40(sp)
    80005d42:	ec56                	sd	s5,24(sp)
    80005d44:	e85a                	sd	s6,16(sp)
    80005d46:	0880                	addi	s0,sp,80
    80005d48:	8b2e                	mv	s6,a1
    80005d4a:	89b2                	mv	s3,a2
    80005d4c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005d4e:	fb040593          	addi	a1,s0,-80
    80005d52:	fffff097          	auipc	ra,0xfffff
    80005d56:	db8080e7          	jalr	-584(ra) # 80004b0a <nameiparent>
    80005d5a:	84aa                	mv	s1,a0
    80005d5c:	14050e63          	beqz	a0,80005eb8 <create+0x182>
    return 0;

  ilock(dp);
    80005d60:	ffffe097          	auipc	ra,0xffffe
    80005d64:	5a8080e7          	jalr	1448(ra) # 80004308 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005d68:	4601                	li	a2,0
    80005d6a:	fb040593          	addi	a1,s0,-80
    80005d6e:	8526                	mv	a0,s1
    80005d70:	fffff097          	auipc	ra,0xfffff
    80005d74:	a94080e7          	jalr	-1388(ra) # 80004804 <dirlookup>
    80005d78:	8aaa                	mv	s5,a0
    80005d7a:	c539                	beqz	a0,80005dc8 <create+0x92>
    iunlockput(dp);
    80005d7c:	8526                	mv	a0,s1
    80005d7e:	ffffe097          	auipc	ra,0xffffe
    80005d82:	7f0080e7          	jalr	2032(ra) # 8000456e <iunlockput>
    ilock(ip);
    80005d86:	8556                	mv	a0,s5
    80005d88:	ffffe097          	auipc	ra,0xffffe
    80005d8c:	580080e7          	jalr	1408(ra) # 80004308 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005d90:	4789                	li	a5,2
    80005d92:	02fb1463          	bne	s6,a5,80005dba <create+0x84>
    80005d96:	044ad783          	lhu	a5,68(s5)
    80005d9a:	37f9                	addiw	a5,a5,-2
    80005d9c:	17c2                	slli	a5,a5,0x30
    80005d9e:	93c1                	srli	a5,a5,0x30
    80005da0:	4705                	li	a4,1
    80005da2:	00f76c63          	bltu	a4,a5,80005dba <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005da6:	8556                	mv	a0,s5
    80005da8:	60a6                	ld	ra,72(sp)
    80005daa:	6406                	ld	s0,64(sp)
    80005dac:	74e2                	ld	s1,56(sp)
    80005dae:	7942                	ld	s2,48(sp)
    80005db0:	79a2                	ld	s3,40(sp)
    80005db2:	6ae2                	ld	s5,24(sp)
    80005db4:	6b42                	ld	s6,16(sp)
    80005db6:	6161                	addi	sp,sp,80
    80005db8:	8082                	ret
    iunlockput(ip);
    80005dba:	8556                	mv	a0,s5
    80005dbc:	ffffe097          	auipc	ra,0xffffe
    80005dc0:	7b2080e7          	jalr	1970(ra) # 8000456e <iunlockput>
    return 0;
    80005dc4:	4a81                	li	s5,0
    80005dc6:	b7c5                	j	80005da6 <create+0x70>
    80005dc8:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005dca:	85da                	mv	a1,s6
    80005dcc:	4088                	lw	a0,0(s1)
    80005dce:	ffffe097          	auipc	ra,0xffffe
    80005dd2:	396080e7          	jalr	918(ra) # 80004164 <ialloc>
    80005dd6:	8a2a                	mv	s4,a0
    80005dd8:	c531                	beqz	a0,80005e24 <create+0xee>
  ilock(ip);
    80005dda:	ffffe097          	auipc	ra,0xffffe
    80005dde:	52e080e7          	jalr	1326(ra) # 80004308 <ilock>
  ip->major = major;
    80005de2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005de6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005dea:	4905                	li	s2,1
    80005dec:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005df0:	8552                	mv	a0,s4
    80005df2:	ffffe097          	auipc	ra,0xffffe
    80005df6:	44a080e7          	jalr	1098(ra) # 8000423c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005dfa:	032b0d63          	beq	s6,s2,80005e34 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005dfe:	004a2603          	lw	a2,4(s4)
    80005e02:	fb040593          	addi	a1,s0,-80
    80005e06:	8526                	mv	a0,s1
    80005e08:	fffff097          	auipc	ra,0xfffff
    80005e0c:	c22080e7          	jalr	-990(ra) # 80004a2a <dirlink>
    80005e10:	08054163          	bltz	a0,80005e92 <create+0x15c>
  iunlockput(dp);
    80005e14:	8526                	mv	a0,s1
    80005e16:	ffffe097          	auipc	ra,0xffffe
    80005e1a:	758080e7          	jalr	1880(ra) # 8000456e <iunlockput>
  return ip;
    80005e1e:	8ad2                	mv	s5,s4
    80005e20:	7a02                	ld	s4,32(sp)
    80005e22:	b751                	j	80005da6 <create+0x70>
    iunlockput(dp);
    80005e24:	8526                	mv	a0,s1
    80005e26:	ffffe097          	auipc	ra,0xffffe
    80005e2a:	748080e7          	jalr	1864(ra) # 8000456e <iunlockput>
    return 0;
    80005e2e:	8ad2                	mv	s5,s4
    80005e30:	7a02                	ld	s4,32(sp)
    80005e32:	bf95                	j	80005da6 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005e34:	004a2603          	lw	a2,4(s4)
    80005e38:	00004597          	auipc	a1,0x4
    80005e3c:	89058593          	addi	a1,a1,-1904 # 800096c8 <etext+0x6c8>
    80005e40:	8552                	mv	a0,s4
    80005e42:	fffff097          	auipc	ra,0xfffff
    80005e46:	be8080e7          	jalr	-1048(ra) # 80004a2a <dirlink>
    80005e4a:	04054463          	bltz	a0,80005e92 <create+0x15c>
    80005e4e:	40d0                	lw	a2,4(s1)
    80005e50:	00004597          	auipc	a1,0x4
    80005e54:	88058593          	addi	a1,a1,-1920 # 800096d0 <etext+0x6d0>
    80005e58:	8552                	mv	a0,s4
    80005e5a:	fffff097          	auipc	ra,0xfffff
    80005e5e:	bd0080e7          	jalr	-1072(ra) # 80004a2a <dirlink>
    80005e62:	02054863          	bltz	a0,80005e92 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005e66:	004a2603          	lw	a2,4(s4)
    80005e6a:	fb040593          	addi	a1,s0,-80
    80005e6e:	8526                	mv	a0,s1
    80005e70:	fffff097          	auipc	ra,0xfffff
    80005e74:	bba080e7          	jalr	-1094(ra) # 80004a2a <dirlink>
    80005e78:	00054d63          	bltz	a0,80005e92 <create+0x15c>
    dp->nlink++;  // for ".."
    80005e7c:	04a4d783          	lhu	a5,74(s1)
    80005e80:	2785                	addiw	a5,a5,1
    80005e82:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005e86:	8526                	mv	a0,s1
    80005e88:	ffffe097          	auipc	ra,0xffffe
    80005e8c:	3b4080e7          	jalr	948(ra) # 8000423c <iupdate>
    80005e90:	b751                	j	80005e14 <create+0xde>
  ip->nlink = 0;
    80005e92:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005e96:	8552                	mv	a0,s4
    80005e98:	ffffe097          	auipc	ra,0xffffe
    80005e9c:	3a4080e7          	jalr	932(ra) # 8000423c <iupdate>
  iunlockput(ip);
    80005ea0:	8552                	mv	a0,s4
    80005ea2:	ffffe097          	auipc	ra,0xffffe
    80005ea6:	6cc080e7          	jalr	1740(ra) # 8000456e <iunlockput>
  iunlockput(dp);
    80005eaa:	8526                	mv	a0,s1
    80005eac:	ffffe097          	auipc	ra,0xffffe
    80005eb0:	6c2080e7          	jalr	1730(ra) # 8000456e <iunlockput>
  return 0;
    80005eb4:	7a02                	ld	s4,32(sp)
    80005eb6:	bdc5                	j	80005da6 <create+0x70>
    return 0;
    80005eb8:	8aaa                	mv	s5,a0
    80005eba:	b5f5                	j	80005da6 <create+0x70>

0000000080005ebc <sys_dup>:
{
    80005ebc:	7179                	addi	sp,sp,-48
    80005ebe:	f406                	sd	ra,40(sp)
    80005ec0:	f022                	sd	s0,32(sp)
    80005ec2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005ec4:	fd840613          	addi	a2,s0,-40
    80005ec8:	4581                	li	a1,0
    80005eca:	4501                	li	a0,0
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	dc8080e7          	jalr	-568(ra) # 80005c94 <argfd>
    return -1;
    80005ed4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005ed6:	02054763          	bltz	a0,80005f04 <sys_dup+0x48>
    80005eda:	ec26                	sd	s1,24(sp)
    80005edc:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005ede:	fd843903          	ld	s2,-40(s0)
    80005ee2:	854a                	mv	a0,s2
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	e10080e7          	jalr	-496(ra) # 80005cf4 <fdalloc>
    80005eec:	84aa                	mv	s1,a0
    return -1;
    80005eee:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005ef0:	00054f63          	bltz	a0,80005f0e <sys_dup+0x52>
  filedup(f);
    80005ef4:	854a                	mv	a0,s2
    80005ef6:	fffff097          	auipc	ra,0xfffff
    80005efa:	27a080e7          	jalr	634(ra) # 80005170 <filedup>
  return fd;
    80005efe:	87a6                	mv	a5,s1
    80005f00:	64e2                	ld	s1,24(sp)
    80005f02:	6942                	ld	s2,16(sp)
}
    80005f04:	853e                	mv	a0,a5
    80005f06:	70a2                	ld	ra,40(sp)
    80005f08:	7402                	ld	s0,32(sp)
    80005f0a:	6145                	addi	sp,sp,48
    80005f0c:	8082                	ret
    80005f0e:	64e2                	ld	s1,24(sp)
    80005f10:	6942                	ld	s2,16(sp)
    80005f12:	bfcd                	j	80005f04 <sys_dup+0x48>

0000000080005f14 <sys_read>:
{
    80005f14:	7179                	addi	sp,sp,-48
    80005f16:	f406                	sd	ra,40(sp)
    80005f18:	f022                	sd	s0,32(sp)
    80005f1a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005f1c:	fd840593          	addi	a1,s0,-40
    80005f20:	4505                	li	a0,1
    80005f22:	ffffd097          	auipc	ra,0xffffd
    80005f26:	63a080e7          	jalr	1594(ra) # 8000355c <argaddr>
  argint(2, &n);
    80005f2a:	fe440593          	addi	a1,s0,-28
    80005f2e:	4509                	li	a0,2
    80005f30:	ffffd097          	auipc	ra,0xffffd
    80005f34:	60c080e7          	jalr	1548(ra) # 8000353c <argint>
  if(argfd(0, 0, &f) < 0)
    80005f38:	fe840613          	addi	a2,s0,-24
    80005f3c:	4581                	li	a1,0
    80005f3e:	4501                	li	a0,0
    80005f40:	00000097          	auipc	ra,0x0
    80005f44:	d54080e7          	jalr	-684(ra) # 80005c94 <argfd>
    80005f48:	87aa                	mv	a5,a0
    return -1;
    80005f4a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005f4c:	0007cc63          	bltz	a5,80005f64 <sys_read+0x50>
  return fileread(f, p, n);
    80005f50:	fe442603          	lw	a2,-28(s0)
    80005f54:	fd843583          	ld	a1,-40(s0)
    80005f58:	fe843503          	ld	a0,-24(s0)
    80005f5c:	fffff097          	auipc	ra,0xfffff
    80005f60:	3ba080e7          	jalr	954(ra) # 80005316 <fileread>
}
    80005f64:	70a2                	ld	ra,40(sp)
    80005f66:	7402                	ld	s0,32(sp)
    80005f68:	6145                	addi	sp,sp,48
    80005f6a:	8082                	ret

0000000080005f6c <sys_write>:
{
    80005f6c:	7179                	addi	sp,sp,-48
    80005f6e:	f406                	sd	ra,40(sp)
    80005f70:	f022                	sd	s0,32(sp)
    80005f72:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005f74:	fd840593          	addi	a1,s0,-40
    80005f78:	4505                	li	a0,1
    80005f7a:	ffffd097          	auipc	ra,0xffffd
    80005f7e:	5e2080e7          	jalr	1506(ra) # 8000355c <argaddr>
  argint(2, &n);
    80005f82:	fe440593          	addi	a1,s0,-28
    80005f86:	4509                	li	a0,2
    80005f88:	ffffd097          	auipc	ra,0xffffd
    80005f8c:	5b4080e7          	jalr	1460(ra) # 8000353c <argint>
  if(argfd(0, 0, &f) < 0)
    80005f90:	fe840613          	addi	a2,s0,-24
    80005f94:	4581                	li	a1,0
    80005f96:	4501                	li	a0,0
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	cfc080e7          	jalr	-772(ra) # 80005c94 <argfd>
    80005fa0:	87aa                	mv	a5,a0
    return -1;
    80005fa2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005fa4:	0007cc63          	bltz	a5,80005fbc <sys_write+0x50>
  return filewrite(f, p, n);
    80005fa8:	fe442603          	lw	a2,-28(s0)
    80005fac:	fd843583          	ld	a1,-40(s0)
    80005fb0:	fe843503          	ld	a0,-24(s0)
    80005fb4:	fffff097          	auipc	ra,0xfffff
    80005fb8:	434080e7          	jalr	1076(ra) # 800053e8 <filewrite>
}
    80005fbc:	70a2                	ld	ra,40(sp)
    80005fbe:	7402                	ld	s0,32(sp)
    80005fc0:	6145                	addi	sp,sp,48
    80005fc2:	8082                	ret

0000000080005fc4 <sys_close>:
{
    80005fc4:	1101                	addi	sp,sp,-32
    80005fc6:	ec06                	sd	ra,24(sp)
    80005fc8:	e822                	sd	s0,16(sp)
    80005fca:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005fcc:	fe040613          	addi	a2,s0,-32
    80005fd0:	fec40593          	addi	a1,s0,-20
    80005fd4:	4501                	li	a0,0
    80005fd6:	00000097          	auipc	ra,0x0
    80005fda:	cbe080e7          	jalr	-834(ra) # 80005c94 <argfd>
    return -1;
    80005fde:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005fe0:	02054463          	bltz	a0,80006008 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005fe4:	ffffc097          	auipc	ra,0xffffc
    80005fe8:	f3e080e7          	jalr	-194(ra) # 80001f22 <myproc>
    80005fec:	fec42783          	lw	a5,-20(s0)
    80005ff0:	07e9                	addi	a5,a5,26
    80005ff2:	078e                	slli	a5,a5,0x3
    80005ff4:	953e                	add	a0,a0,a5
    80005ff6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005ffa:	fe043503          	ld	a0,-32(s0)
    80005ffe:	fffff097          	auipc	ra,0xfffff
    80006002:	1c4080e7          	jalr	452(ra) # 800051c2 <fileclose>
  return 0;
    80006006:	4781                	li	a5,0
}
    80006008:	853e                	mv	a0,a5
    8000600a:	60e2                	ld	ra,24(sp)
    8000600c:	6442                	ld	s0,16(sp)
    8000600e:	6105                	addi	sp,sp,32
    80006010:	8082                	ret

0000000080006012 <sys_fstat>:
{
    80006012:	1101                	addi	sp,sp,-32
    80006014:	ec06                	sd	ra,24(sp)
    80006016:	e822                	sd	s0,16(sp)
    80006018:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000601a:	fe040593          	addi	a1,s0,-32
    8000601e:	4505                	li	a0,1
    80006020:	ffffd097          	auipc	ra,0xffffd
    80006024:	53c080e7          	jalr	1340(ra) # 8000355c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80006028:	fe840613          	addi	a2,s0,-24
    8000602c:	4581                	li	a1,0
    8000602e:	4501                	li	a0,0
    80006030:	00000097          	auipc	ra,0x0
    80006034:	c64080e7          	jalr	-924(ra) # 80005c94 <argfd>
    80006038:	87aa                	mv	a5,a0
    return -1;
    8000603a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000603c:	0007ca63          	bltz	a5,80006050 <sys_fstat+0x3e>
  return filestat(f, st);
    80006040:	fe043583          	ld	a1,-32(s0)
    80006044:	fe843503          	ld	a0,-24(s0)
    80006048:	fffff097          	auipc	ra,0xfffff
    8000604c:	258080e7          	jalr	600(ra) # 800052a0 <filestat>
}
    80006050:	60e2                	ld	ra,24(sp)
    80006052:	6442                	ld	s0,16(sp)
    80006054:	6105                	addi	sp,sp,32
    80006056:	8082                	ret

0000000080006058 <sys_link>:
{
    80006058:	7169                	addi	sp,sp,-304
    8000605a:	f606                	sd	ra,296(sp)
    8000605c:	f222                	sd	s0,288(sp)
    8000605e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006060:	08000613          	li	a2,128
    80006064:	ed040593          	addi	a1,s0,-304
    80006068:	4501                	li	a0,0
    8000606a:	ffffd097          	auipc	ra,0xffffd
    8000606e:	512080e7          	jalr	1298(ra) # 8000357c <argstr>
    return -1;
    80006072:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006074:	12054663          	bltz	a0,800061a0 <sys_link+0x148>
    80006078:	08000613          	li	a2,128
    8000607c:	f5040593          	addi	a1,s0,-176
    80006080:	4505                	li	a0,1
    80006082:	ffffd097          	auipc	ra,0xffffd
    80006086:	4fa080e7          	jalr	1274(ra) # 8000357c <argstr>
    return -1;
    8000608a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000608c:	10054a63          	bltz	a0,800061a0 <sys_link+0x148>
    80006090:	ee26                	sd	s1,280(sp)
  begin_op();
    80006092:	fffff097          	auipc	ra,0xfffff
    80006096:	c60080e7          	jalr	-928(ra) # 80004cf2 <begin_op>
  if((ip = namei(old)) == 0){
    8000609a:	ed040513          	addi	a0,s0,-304
    8000609e:	fffff097          	auipc	ra,0xfffff
    800060a2:	a4e080e7          	jalr	-1458(ra) # 80004aec <namei>
    800060a6:	84aa                	mv	s1,a0
    800060a8:	c949                	beqz	a0,8000613a <sys_link+0xe2>
  ilock(ip);
    800060aa:	ffffe097          	auipc	ra,0xffffe
    800060ae:	25e080e7          	jalr	606(ra) # 80004308 <ilock>
  if(ip->type == T_DIR){
    800060b2:	04449703          	lh	a4,68(s1)
    800060b6:	4785                	li	a5,1
    800060b8:	08f70863          	beq	a4,a5,80006148 <sys_link+0xf0>
    800060bc:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800060be:	04a4d783          	lhu	a5,74(s1)
    800060c2:	2785                	addiw	a5,a5,1
    800060c4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800060c8:	8526                	mv	a0,s1
    800060ca:	ffffe097          	auipc	ra,0xffffe
    800060ce:	172080e7          	jalr	370(ra) # 8000423c <iupdate>
  iunlock(ip);
    800060d2:	8526                	mv	a0,s1
    800060d4:	ffffe097          	auipc	ra,0xffffe
    800060d8:	2fa080e7          	jalr	762(ra) # 800043ce <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800060dc:	fd040593          	addi	a1,s0,-48
    800060e0:	f5040513          	addi	a0,s0,-176
    800060e4:	fffff097          	auipc	ra,0xfffff
    800060e8:	a26080e7          	jalr	-1498(ra) # 80004b0a <nameiparent>
    800060ec:	892a                	mv	s2,a0
    800060ee:	cd35                	beqz	a0,8000616a <sys_link+0x112>
  ilock(dp);
    800060f0:	ffffe097          	auipc	ra,0xffffe
    800060f4:	218080e7          	jalr	536(ra) # 80004308 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800060f8:	00092703          	lw	a4,0(s2)
    800060fc:	409c                	lw	a5,0(s1)
    800060fe:	06f71163          	bne	a4,a5,80006160 <sys_link+0x108>
    80006102:	40d0                	lw	a2,4(s1)
    80006104:	fd040593          	addi	a1,s0,-48
    80006108:	854a                	mv	a0,s2
    8000610a:	fffff097          	auipc	ra,0xfffff
    8000610e:	920080e7          	jalr	-1760(ra) # 80004a2a <dirlink>
    80006112:	04054763          	bltz	a0,80006160 <sys_link+0x108>
  iunlockput(dp);
    80006116:	854a                	mv	a0,s2
    80006118:	ffffe097          	auipc	ra,0xffffe
    8000611c:	456080e7          	jalr	1110(ra) # 8000456e <iunlockput>
  iput(ip);
    80006120:	8526                	mv	a0,s1
    80006122:	ffffe097          	auipc	ra,0xffffe
    80006126:	3a4080e7          	jalr	932(ra) # 800044c6 <iput>
  end_op();
    8000612a:	fffff097          	auipc	ra,0xfffff
    8000612e:	c42080e7          	jalr	-958(ra) # 80004d6c <end_op>
  return 0;
    80006132:	4781                	li	a5,0
    80006134:	64f2                	ld	s1,280(sp)
    80006136:	6952                	ld	s2,272(sp)
    80006138:	a0a5                	j	800061a0 <sys_link+0x148>
    end_op();
    8000613a:	fffff097          	auipc	ra,0xfffff
    8000613e:	c32080e7          	jalr	-974(ra) # 80004d6c <end_op>
    return -1;
    80006142:	57fd                	li	a5,-1
    80006144:	64f2                	ld	s1,280(sp)
    80006146:	a8a9                	j	800061a0 <sys_link+0x148>
    iunlockput(ip);
    80006148:	8526                	mv	a0,s1
    8000614a:	ffffe097          	auipc	ra,0xffffe
    8000614e:	424080e7          	jalr	1060(ra) # 8000456e <iunlockput>
    end_op();
    80006152:	fffff097          	auipc	ra,0xfffff
    80006156:	c1a080e7          	jalr	-998(ra) # 80004d6c <end_op>
    return -1;
    8000615a:	57fd                	li	a5,-1
    8000615c:	64f2                	ld	s1,280(sp)
    8000615e:	a089                	j	800061a0 <sys_link+0x148>
    iunlockput(dp);
    80006160:	854a                	mv	a0,s2
    80006162:	ffffe097          	auipc	ra,0xffffe
    80006166:	40c080e7          	jalr	1036(ra) # 8000456e <iunlockput>
  ilock(ip);
    8000616a:	8526                	mv	a0,s1
    8000616c:	ffffe097          	auipc	ra,0xffffe
    80006170:	19c080e7          	jalr	412(ra) # 80004308 <ilock>
  ip->nlink--;
    80006174:	04a4d783          	lhu	a5,74(s1)
    80006178:	37fd                	addiw	a5,a5,-1
    8000617a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000617e:	8526                	mv	a0,s1
    80006180:	ffffe097          	auipc	ra,0xffffe
    80006184:	0bc080e7          	jalr	188(ra) # 8000423c <iupdate>
  iunlockput(ip);
    80006188:	8526                	mv	a0,s1
    8000618a:	ffffe097          	auipc	ra,0xffffe
    8000618e:	3e4080e7          	jalr	996(ra) # 8000456e <iunlockput>
  end_op();
    80006192:	fffff097          	auipc	ra,0xfffff
    80006196:	bda080e7          	jalr	-1062(ra) # 80004d6c <end_op>
  return -1;
    8000619a:	57fd                	li	a5,-1
    8000619c:	64f2                	ld	s1,280(sp)
    8000619e:	6952                	ld	s2,272(sp)
}
    800061a0:	853e                	mv	a0,a5
    800061a2:	70b2                	ld	ra,296(sp)
    800061a4:	7412                	ld	s0,288(sp)
    800061a6:	6155                	addi	sp,sp,304
    800061a8:	8082                	ret

00000000800061aa <sys_unlink>:
{
    800061aa:	7111                	addi	sp,sp,-256
    800061ac:	fd86                	sd	ra,248(sp)
    800061ae:	f9a2                	sd	s0,240(sp)
    800061b0:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    800061b2:	08000613          	li	a2,128
    800061b6:	f2040593          	addi	a1,s0,-224
    800061ba:	4501                	li	a0,0
    800061bc:	ffffd097          	auipc	ra,0xffffd
    800061c0:	3c0080e7          	jalr	960(ra) # 8000357c <argstr>
    800061c4:	1c054063          	bltz	a0,80006384 <sys_unlink+0x1da>
    800061c8:	f5a6                	sd	s1,232(sp)
  begin_op();
    800061ca:	fffff097          	auipc	ra,0xfffff
    800061ce:	b28080e7          	jalr	-1240(ra) # 80004cf2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800061d2:	fa040593          	addi	a1,s0,-96
    800061d6:	f2040513          	addi	a0,s0,-224
    800061da:	fffff097          	auipc	ra,0xfffff
    800061de:	930080e7          	jalr	-1744(ra) # 80004b0a <nameiparent>
    800061e2:	84aa                	mv	s1,a0
    800061e4:	c165                	beqz	a0,800062c4 <sys_unlink+0x11a>
  ilock(dp);
    800061e6:	ffffe097          	auipc	ra,0xffffe
    800061ea:	122080e7          	jalr	290(ra) # 80004308 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800061ee:	00003597          	auipc	a1,0x3
    800061f2:	4da58593          	addi	a1,a1,1242 # 800096c8 <etext+0x6c8>
    800061f6:	fa040513          	addi	a0,s0,-96
    800061fa:	ffffe097          	auipc	ra,0xffffe
    800061fe:	5f0080e7          	jalr	1520(ra) # 800047ea <namecmp>
    80006202:	16050263          	beqz	a0,80006366 <sys_unlink+0x1bc>
    80006206:	00003597          	auipc	a1,0x3
    8000620a:	4ca58593          	addi	a1,a1,1226 # 800096d0 <etext+0x6d0>
    8000620e:	fa040513          	addi	a0,s0,-96
    80006212:	ffffe097          	auipc	ra,0xffffe
    80006216:	5d8080e7          	jalr	1496(ra) # 800047ea <namecmp>
    8000621a:	14050663          	beqz	a0,80006366 <sys_unlink+0x1bc>
    8000621e:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80006220:	f1c40613          	addi	a2,s0,-228
    80006224:	fa040593          	addi	a1,s0,-96
    80006228:	8526                	mv	a0,s1
    8000622a:	ffffe097          	auipc	ra,0xffffe
    8000622e:	5da080e7          	jalr	1498(ra) # 80004804 <dirlookup>
    80006232:	892a                	mv	s2,a0
    80006234:	12050863          	beqz	a0,80006364 <sys_unlink+0x1ba>
    80006238:	edce                	sd	s3,216(sp)
  ilock(ip);
    8000623a:	ffffe097          	auipc	ra,0xffffe
    8000623e:	0ce080e7          	jalr	206(ra) # 80004308 <ilock>
  if(ip->nlink < 1)
    80006242:	04a91783          	lh	a5,74(s2)
    80006246:	08f05663          	blez	a5,800062d2 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000624a:	04491703          	lh	a4,68(s2)
    8000624e:	4785                	li	a5,1
    80006250:	08f70b63          	beq	a4,a5,800062e6 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80006254:	fb040993          	addi	s3,s0,-80
    80006258:	4641                	li	a2,16
    8000625a:	4581                	li	a1,0
    8000625c:	854e                	mv	a0,s3
    8000625e:	ffffb097          	auipc	ra,0xffffb
    80006262:	bb0080e7          	jalr	-1104(ra) # 80000e0e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006266:	4741                	li	a4,16
    80006268:	f1c42683          	lw	a3,-228(s0)
    8000626c:	864e                	mv	a2,s3
    8000626e:	4581                	li	a1,0
    80006270:	8526                	mv	a0,s1
    80006272:	ffffe097          	auipc	ra,0xffffe
    80006276:	458080e7          	jalr	1112(ra) # 800046ca <writei>
    8000627a:	47c1                	li	a5,16
    8000627c:	0af51f63          	bne	a0,a5,8000633a <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80006280:	04491703          	lh	a4,68(s2)
    80006284:	4785                	li	a5,1
    80006286:	0cf70463          	beq	a4,a5,8000634e <sys_unlink+0x1a4>
  iunlockput(dp);
    8000628a:	8526                	mv	a0,s1
    8000628c:	ffffe097          	auipc	ra,0xffffe
    80006290:	2e2080e7          	jalr	738(ra) # 8000456e <iunlockput>
  ip->nlink--;
    80006294:	04a95783          	lhu	a5,74(s2)
    80006298:	37fd                	addiw	a5,a5,-1
    8000629a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000629e:	854a                	mv	a0,s2
    800062a0:	ffffe097          	auipc	ra,0xffffe
    800062a4:	f9c080e7          	jalr	-100(ra) # 8000423c <iupdate>
  iunlockput(ip);
    800062a8:	854a                	mv	a0,s2
    800062aa:	ffffe097          	auipc	ra,0xffffe
    800062ae:	2c4080e7          	jalr	708(ra) # 8000456e <iunlockput>
  end_op();
    800062b2:	fffff097          	auipc	ra,0xfffff
    800062b6:	aba080e7          	jalr	-1350(ra) # 80004d6c <end_op>
  return 0;
    800062ba:	4501                	li	a0,0
    800062bc:	74ae                	ld	s1,232(sp)
    800062be:	790e                	ld	s2,224(sp)
    800062c0:	69ee                	ld	s3,216(sp)
    800062c2:	a86d                	j	8000637c <sys_unlink+0x1d2>
    end_op();
    800062c4:	fffff097          	auipc	ra,0xfffff
    800062c8:	aa8080e7          	jalr	-1368(ra) # 80004d6c <end_op>
    return -1;
    800062cc:	557d                	li	a0,-1
    800062ce:	74ae                	ld	s1,232(sp)
    800062d0:	a075                	j	8000637c <sys_unlink+0x1d2>
    800062d2:	e9d2                	sd	s4,208(sp)
    800062d4:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    800062d6:	00003517          	auipc	a0,0x3
    800062da:	40250513          	addi	a0,a0,1026 # 800096d8 <etext+0x6d8>
    800062de:	ffffa097          	auipc	ra,0xffffa
    800062e2:	282080e7          	jalr	642(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800062e6:	04c92703          	lw	a4,76(s2)
    800062ea:	02000793          	li	a5,32
    800062ee:	f6e7f3e3          	bgeu	a5,a4,80006254 <sys_unlink+0xaa>
    800062f2:	e9d2                	sd	s4,208(sp)
    800062f4:	e5d6                	sd	s5,200(sp)
    800062f6:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800062f8:	f0840a93          	addi	s5,s0,-248
    800062fc:	4a41                	li	s4,16
    800062fe:	8752                	mv	a4,s4
    80006300:	86ce                	mv	a3,s3
    80006302:	8656                	mv	a2,s5
    80006304:	4581                	li	a1,0
    80006306:	854a                	mv	a0,s2
    80006308:	ffffe097          	auipc	ra,0xffffe
    8000630c:	2bc080e7          	jalr	700(ra) # 800045c4 <readi>
    80006310:	01451d63          	bne	a0,s4,8000632a <sys_unlink+0x180>
    if(de.inum != 0)
    80006314:	f0845783          	lhu	a5,-248(s0)
    80006318:	eba5                	bnez	a5,80006388 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000631a:	29c1                	addiw	s3,s3,16
    8000631c:	04c92783          	lw	a5,76(s2)
    80006320:	fcf9efe3          	bltu	s3,a5,800062fe <sys_unlink+0x154>
    80006324:	6a4e                	ld	s4,208(sp)
    80006326:	6aae                	ld	s5,200(sp)
    80006328:	b735                	j	80006254 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000632a:	00003517          	auipc	a0,0x3
    8000632e:	3c650513          	addi	a0,a0,966 # 800096f0 <etext+0x6f0>
    80006332:	ffffa097          	auipc	ra,0xffffa
    80006336:	22e080e7          	jalr	558(ra) # 80000560 <panic>
    8000633a:	e9d2                	sd	s4,208(sp)
    8000633c:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    8000633e:	00003517          	auipc	a0,0x3
    80006342:	3ca50513          	addi	a0,a0,970 # 80009708 <etext+0x708>
    80006346:	ffffa097          	auipc	ra,0xffffa
    8000634a:	21a080e7          	jalr	538(ra) # 80000560 <panic>
    dp->nlink--;
    8000634e:	04a4d783          	lhu	a5,74(s1)
    80006352:	37fd                	addiw	a5,a5,-1
    80006354:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006358:	8526                	mv	a0,s1
    8000635a:	ffffe097          	auipc	ra,0xffffe
    8000635e:	ee2080e7          	jalr	-286(ra) # 8000423c <iupdate>
    80006362:	b725                	j	8000628a <sys_unlink+0xe0>
    80006364:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80006366:	8526                	mv	a0,s1
    80006368:	ffffe097          	auipc	ra,0xffffe
    8000636c:	206080e7          	jalr	518(ra) # 8000456e <iunlockput>
  end_op();
    80006370:	fffff097          	auipc	ra,0xfffff
    80006374:	9fc080e7          	jalr	-1540(ra) # 80004d6c <end_op>
  return -1;
    80006378:	557d                	li	a0,-1
    8000637a:	74ae                	ld	s1,232(sp)
}
    8000637c:	70ee                	ld	ra,248(sp)
    8000637e:	744e                	ld	s0,240(sp)
    80006380:	6111                	addi	sp,sp,256
    80006382:	8082                	ret
    return -1;
    80006384:	557d                	li	a0,-1
    80006386:	bfdd                	j	8000637c <sys_unlink+0x1d2>
    iunlockput(ip);
    80006388:	854a                	mv	a0,s2
    8000638a:	ffffe097          	auipc	ra,0xffffe
    8000638e:	1e4080e7          	jalr	484(ra) # 8000456e <iunlockput>
    goto bad;
    80006392:	790e                	ld	s2,224(sp)
    80006394:	69ee                	ld	s3,216(sp)
    80006396:	6a4e                	ld	s4,208(sp)
    80006398:	6aae                	ld	s5,200(sp)
    8000639a:	b7f1                	j	80006366 <sys_unlink+0x1bc>

000000008000639c <sys_open>:

uint64
sys_open(void)
{
    8000639c:	7131                	addi	sp,sp,-192
    8000639e:	fd06                	sd	ra,184(sp)
    800063a0:	f922                	sd	s0,176(sp)
    800063a2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800063a4:	f4c40593          	addi	a1,s0,-180
    800063a8:	4505                	li	a0,1
    800063aa:	ffffd097          	auipc	ra,0xffffd
    800063ae:	192080e7          	jalr	402(ra) # 8000353c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800063b2:	08000613          	li	a2,128
    800063b6:	f5040593          	addi	a1,s0,-176
    800063ba:	4501                	li	a0,0
    800063bc:	ffffd097          	auipc	ra,0xffffd
    800063c0:	1c0080e7          	jalr	448(ra) # 8000357c <argstr>
    800063c4:	87aa                	mv	a5,a0
    return -1;
    800063c6:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800063c8:	0a07cf63          	bltz	a5,80006486 <sys_open+0xea>
    800063cc:	f526                	sd	s1,168(sp)

  begin_op();
    800063ce:	fffff097          	auipc	ra,0xfffff
    800063d2:	924080e7          	jalr	-1756(ra) # 80004cf2 <begin_op>

  if(omode & O_CREATE){
    800063d6:	f4c42783          	lw	a5,-180(s0)
    800063da:	2007f793          	andi	a5,a5,512
    800063de:	cfdd                	beqz	a5,8000649c <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    800063e0:	4681                	li	a3,0
    800063e2:	4601                	li	a2,0
    800063e4:	4589                	li	a1,2
    800063e6:	f5040513          	addi	a0,s0,-176
    800063ea:	00000097          	auipc	ra,0x0
    800063ee:	94c080e7          	jalr	-1716(ra) # 80005d36 <create>
    800063f2:	84aa                	mv	s1,a0
    if(ip == 0){
    800063f4:	cd49                	beqz	a0,8000648e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800063f6:	04449703          	lh	a4,68(s1)
    800063fa:	478d                	li	a5,3
    800063fc:	00f71763          	bne	a4,a5,8000640a <sys_open+0x6e>
    80006400:	0464d703          	lhu	a4,70(s1)
    80006404:	47a5                	li	a5,9
    80006406:	0ee7e263          	bltu	a5,a4,800064ea <sys_open+0x14e>
    8000640a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000640c:	fffff097          	auipc	ra,0xfffff
    80006410:	cfa080e7          	jalr	-774(ra) # 80005106 <filealloc>
    80006414:	892a                	mv	s2,a0
    80006416:	cd65                	beqz	a0,8000650e <sys_open+0x172>
    80006418:	ed4e                	sd	s3,152(sp)
    8000641a:	00000097          	auipc	ra,0x0
    8000641e:	8da080e7          	jalr	-1830(ra) # 80005cf4 <fdalloc>
    80006422:	89aa                	mv	s3,a0
    80006424:	0c054f63          	bltz	a0,80006502 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80006428:	04449703          	lh	a4,68(s1)
    8000642c:	478d                	li	a5,3
    8000642e:	0ef70d63          	beq	a4,a5,80006528 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006432:	4789                	li	a5,2
    80006434:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80006438:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000643c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006440:	f4c42783          	lw	a5,-180(s0)
    80006444:	0017f713          	andi	a4,a5,1
    80006448:	00174713          	xori	a4,a4,1
    8000644c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006450:	0037f713          	andi	a4,a5,3
    80006454:	00e03733          	snez	a4,a4
    80006458:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000645c:	4007f793          	andi	a5,a5,1024
    80006460:	c791                	beqz	a5,8000646c <sys_open+0xd0>
    80006462:	04449703          	lh	a4,68(s1)
    80006466:	4789                	li	a5,2
    80006468:	0cf70763          	beq	a4,a5,80006536 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    8000646c:	8526                	mv	a0,s1
    8000646e:	ffffe097          	auipc	ra,0xffffe
    80006472:	f60080e7          	jalr	-160(ra) # 800043ce <iunlock>
  end_op();
    80006476:	fffff097          	auipc	ra,0xfffff
    8000647a:	8f6080e7          	jalr	-1802(ra) # 80004d6c <end_op>

  return fd;
    8000647e:	854e                	mv	a0,s3
    80006480:	74aa                	ld	s1,168(sp)
    80006482:	790a                	ld	s2,160(sp)
    80006484:	69ea                	ld	s3,152(sp)
}
    80006486:	70ea                	ld	ra,184(sp)
    80006488:	744a                	ld	s0,176(sp)
    8000648a:	6129                	addi	sp,sp,192
    8000648c:	8082                	ret
      end_op();
    8000648e:	fffff097          	auipc	ra,0xfffff
    80006492:	8de080e7          	jalr	-1826(ra) # 80004d6c <end_op>
      return -1;
    80006496:	557d                	li	a0,-1
    80006498:	74aa                	ld	s1,168(sp)
    8000649a:	b7f5                	j	80006486 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    8000649c:	f5040513          	addi	a0,s0,-176
    800064a0:	ffffe097          	auipc	ra,0xffffe
    800064a4:	64c080e7          	jalr	1612(ra) # 80004aec <namei>
    800064a8:	84aa                	mv	s1,a0
    800064aa:	c90d                	beqz	a0,800064dc <sys_open+0x140>
    ilock(ip);
    800064ac:	ffffe097          	auipc	ra,0xffffe
    800064b0:	e5c080e7          	jalr	-420(ra) # 80004308 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800064b4:	04449703          	lh	a4,68(s1)
    800064b8:	4785                	li	a5,1
    800064ba:	f2f71ee3          	bne	a4,a5,800063f6 <sys_open+0x5a>
    800064be:	f4c42783          	lw	a5,-180(s0)
    800064c2:	d7a1                	beqz	a5,8000640a <sys_open+0x6e>
      iunlockput(ip);
    800064c4:	8526                	mv	a0,s1
    800064c6:	ffffe097          	auipc	ra,0xffffe
    800064ca:	0a8080e7          	jalr	168(ra) # 8000456e <iunlockput>
      end_op();
    800064ce:	fffff097          	auipc	ra,0xfffff
    800064d2:	89e080e7          	jalr	-1890(ra) # 80004d6c <end_op>
      return -1;
    800064d6:	557d                	li	a0,-1
    800064d8:	74aa                	ld	s1,168(sp)
    800064da:	b775                	j	80006486 <sys_open+0xea>
      end_op();
    800064dc:	fffff097          	auipc	ra,0xfffff
    800064e0:	890080e7          	jalr	-1904(ra) # 80004d6c <end_op>
      return -1;
    800064e4:	557d                	li	a0,-1
    800064e6:	74aa                	ld	s1,168(sp)
    800064e8:	bf79                	j	80006486 <sys_open+0xea>
    iunlockput(ip);
    800064ea:	8526                	mv	a0,s1
    800064ec:	ffffe097          	auipc	ra,0xffffe
    800064f0:	082080e7          	jalr	130(ra) # 8000456e <iunlockput>
    end_op();
    800064f4:	fffff097          	auipc	ra,0xfffff
    800064f8:	878080e7          	jalr	-1928(ra) # 80004d6c <end_op>
    return -1;
    800064fc:	557d                	li	a0,-1
    800064fe:	74aa                	ld	s1,168(sp)
    80006500:	b759                	j	80006486 <sys_open+0xea>
      fileclose(f);
    80006502:	854a                	mv	a0,s2
    80006504:	fffff097          	auipc	ra,0xfffff
    80006508:	cbe080e7          	jalr	-834(ra) # 800051c2 <fileclose>
    8000650c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000650e:	8526                	mv	a0,s1
    80006510:	ffffe097          	auipc	ra,0xffffe
    80006514:	05e080e7          	jalr	94(ra) # 8000456e <iunlockput>
    end_op();
    80006518:	fffff097          	auipc	ra,0xfffff
    8000651c:	854080e7          	jalr	-1964(ra) # 80004d6c <end_op>
    return -1;
    80006520:	557d                	li	a0,-1
    80006522:	74aa                	ld	s1,168(sp)
    80006524:	790a                	ld	s2,160(sp)
    80006526:	b785                	j	80006486 <sys_open+0xea>
    f->type = FD_DEVICE;
    80006528:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000652c:	04649783          	lh	a5,70(s1)
    80006530:	02f91223          	sh	a5,36(s2)
    80006534:	b721                	j	8000643c <sys_open+0xa0>
    itrunc(ip);
    80006536:	8526                	mv	a0,s1
    80006538:	ffffe097          	auipc	ra,0xffffe
    8000653c:	ee2080e7          	jalr	-286(ra) # 8000441a <itrunc>
    80006540:	b735                	j	8000646c <sys_open+0xd0>

0000000080006542 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006542:	7175                	addi	sp,sp,-144
    80006544:	e506                	sd	ra,136(sp)
    80006546:	e122                	sd	s0,128(sp)
    80006548:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000654a:	ffffe097          	auipc	ra,0xffffe
    8000654e:	7a8080e7          	jalr	1960(ra) # 80004cf2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006552:	08000613          	li	a2,128
    80006556:	f7040593          	addi	a1,s0,-144
    8000655a:	4501                	li	a0,0
    8000655c:	ffffd097          	auipc	ra,0xffffd
    80006560:	020080e7          	jalr	32(ra) # 8000357c <argstr>
    80006564:	02054963          	bltz	a0,80006596 <sys_mkdir+0x54>
    80006568:	4681                	li	a3,0
    8000656a:	4601                	li	a2,0
    8000656c:	4585                	li	a1,1
    8000656e:	f7040513          	addi	a0,s0,-144
    80006572:	fffff097          	auipc	ra,0xfffff
    80006576:	7c4080e7          	jalr	1988(ra) # 80005d36 <create>
    8000657a:	cd11                	beqz	a0,80006596 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000657c:	ffffe097          	auipc	ra,0xffffe
    80006580:	ff2080e7          	jalr	-14(ra) # 8000456e <iunlockput>
  end_op();
    80006584:	ffffe097          	auipc	ra,0xffffe
    80006588:	7e8080e7          	jalr	2024(ra) # 80004d6c <end_op>
  return 0;
    8000658c:	4501                	li	a0,0
}
    8000658e:	60aa                	ld	ra,136(sp)
    80006590:	640a                	ld	s0,128(sp)
    80006592:	6149                	addi	sp,sp,144
    80006594:	8082                	ret
    end_op();
    80006596:	ffffe097          	auipc	ra,0xffffe
    8000659a:	7d6080e7          	jalr	2006(ra) # 80004d6c <end_op>
    return -1;
    8000659e:	557d                	li	a0,-1
    800065a0:	b7fd                	j	8000658e <sys_mkdir+0x4c>

00000000800065a2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800065a2:	7135                	addi	sp,sp,-160
    800065a4:	ed06                	sd	ra,152(sp)
    800065a6:	e922                	sd	s0,144(sp)
    800065a8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800065aa:	ffffe097          	auipc	ra,0xffffe
    800065ae:	748080e7          	jalr	1864(ra) # 80004cf2 <begin_op>
  argint(1, &major);
    800065b2:	f6c40593          	addi	a1,s0,-148
    800065b6:	4505                	li	a0,1
    800065b8:	ffffd097          	auipc	ra,0xffffd
    800065bc:	f84080e7          	jalr	-124(ra) # 8000353c <argint>
  argint(2, &minor);
    800065c0:	f6840593          	addi	a1,s0,-152
    800065c4:	4509                	li	a0,2
    800065c6:	ffffd097          	auipc	ra,0xffffd
    800065ca:	f76080e7          	jalr	-138(ra) # 8000353c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800065ce:	08000613          	li	a2,128
    800065d2:	f7040593          	addi	a1,s0,-144
    800065d6:	4501                	li	a0,0
    800065d8:	ffffd097          	auipc	ra,0xffffd
    800065dc:	fa4080e7          	jalr	-92(ra) # 8000357c <argstr>
    800065e0:	02054b63          	bltz	a0,80006616 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800065e4:	f6841683          	lh	a3,-152(s0)
    800065e8:	f6c41603          	lh	a2,-148(s0)
    800065ec:	458d                	li	a1,3
    800065ee:	f7040513          	addi	a0,s0,-144
    800065f2:	fffff097          	auipc	ra,0xfffff
    800065f6:	744080e7          	jalr	1860(ra) # 80005d36 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800065fa:	cd11                	beqz	a0,80006616 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800065fc:	ffffe097          	auipc	ra,0xffffe
    80006600:	f72080e7          	jalr	-142(ra) # 8000456e <iunlockput>
  end_op();
    80006604:	ffffe097          	auipc	ra,0xffffe
    80006608:	768080e7          	jalr	1896(ra) # 80004d6c <end_op>
  return 0;
    8000660c:	4501                	li	a0,0
}
    8000660e:	60ea                	ld	ra,152(sp)
    80006610:	644a                	ld	s0,144(sp)
    80006612:	610d                	addi	sp,sp,160
    80006614:	8082                	ret
    end_op();
    80006616:	ffffe097          	auipc	ra,0xffffe
    8000661a:	756080e7          	jalr	1878(ra) # 80004d6c <end_op>
    return -1;
    8000661e:	557d                	li	a0,-1
    80006620:	b7fd                	j	8000660e <sys_mknod+0x6c>

0000000080006622 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006622:	7135                	addi	sp,sp,-160
    80006624:	ed06                	sd	ra,152(sp)
    80006626:	e922                	sd	s0,144(sp)
    80006628:	e14a                	sd	s2,128(sp)
    8000662a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000662c:	ffffc097          	auipc	ra,0xffffc
    80006630:	8f6080e7          	jalr	-1802(ra) # 80001f22 <myproc>
    80006634:	892a                	mv	s2,a0
  
  begin_op();
    80006636:	ffffe097          	auipc	ra,0xffffe
    8000663a:	6bc080e7          	jalr	1724(ra) # 80004cf2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000663e:	08000613          	li	a2,128
    80006642:	f6040593          	addi	a1,s0,-160
    80006646:	4501                	li	a0,0
    80006648:	ffffd097          	auipc	ra,0xffffd
    8000664c:	f34080e7          	jalr	-204(ra) # 8000357c <argstr>
    80006650:	04054d63          	bltz	a0,800066aa <sys_chdir+0x88>
    80006654:	e526                	sd	s1,136(sp)
    80006656:	f6040513          	addi	a0,s0,-160
    8000665a:	ffffe097          	auipc	ra,0xffffe
    8000665e:	492080e7          	jalr	1170(ra) # 80004aec <namei>
    80006662:	84aa                	mv	s1,a0
    80006664:	c131                	beqz	a0,800066a8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006666:	ffffe097          	auipc	ra,0xffffe
    8000666a:	ca2080e7          	jalr	-862(ra) # 80004308 <ilock>
  if(ip->type != T_DIR){
    8000666e:	04449703          	lh	a4,68(s1)
    80006672:	4785                	li	a5,1
    80006674:	04f71163          	bne	a4,a5,800066b6 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006678:	8526                	mv	a0,s1
    8000667a:	ffffe097          	auipc	ra,0xffffe
    8000667e:	d54080e7          	jalr	-684(ra) # 800043ce <iunlock>
  iput(p->cwd);
    80006682:	15093503          	ld	a0,336(s2)
    80006686:	ffffe097          	auipc	ra,0xffffe
    8000668a:	e40080e7          	jalr	-448(ra) # 800044c6 <iput>
  end_op();
    8000668e:	ffffe097          	auipc	ra,0xffffe
    80006692:	6de080e7          	jalr	1758(ra) # 80004d6c <end_op>
  p->cwd = ip;
    80006696:	14993823          	sd	s1,336(s2)
  return 0;
    8000669a:	4501                	li	a0,0
    8000669c:	64aa                	ld	s1,136(sp)
}
    8000669e:	60ea                	ld	ra,152(sp)
    800066a0:	644a                	ld	s0,144(sp)
    800066a2:	690a                	ld	s2,128(sp)
    800066a4:	610d                	addi	sp,sp,160
    800066a6:	8082                	ret
    800066a8:	64aa                	ld	s1,136(sp)
    end_op();
    800066aa:	ffffe097          	auipc	ra,0xffffe
    800066ae:	6c2080e7          	jalr	1730(ra) # 80004d6c <end_op>
    return -1;
    800066b2:	557d                	li	a0,-1
    800066b4:	b7ed                	j	8000669e <sys_chdir+0x7c>
    iunlockput(ip);
    800066b6:	8526                	mv	a0,s1
    800066b8:	ffffe097          	auipc	ra,0xffffe
    800066bc:	eb6080e7          	jalr	-330(ra) # 8000456e <iunlockput>
    end_op();
    800066c0:	ffffe097          	auipc	ra,0xffffe
    800066c4:	6ac080e7          	jalr	1708(ra) # 80004d6c <end_op>
    return -1;
    800066c8:	557d                	li	a0,-1
    800066ca:	64aa                	ld	s1,136(sp)
    800066cc:	bfc9                	j	8000669e <sys_chdir+0x7c>

00000000800066ce <sys_exec>:

uint64
sys_exec(void)
{
    800066ce:	7105                	addi	sp,sp,-480
    800066d0:	ef86                	sd	ra,472(sp)
    800066d2:	eba2                	sd	s0,464(sp)
    800066d4:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800066d6:	e2840593          	addi	a1,s0,-472
    800066da:	4505                	li	a0,1
    800066dc:	ffffd097          	auipc	ra,0xffffd
    800066e0:	e80080e7          	jalr	-384(ra) # 8000355c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800066e4:	08000613          	li	a2,128
    800066e8:	f3040593          	addi	a1,s0,-208
    800066ec:	4501                	li	a0,0
    800066ee:	ffffd097          	auipc	ra,0xffffd
    800066f2:	e8e080e7          	jalr	-370(ra) # 8000357c <argstr>
    800066f6:	87aa                	mv	a5,a0
    return -1;
    800066f8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800066fa:	0e07ce63          	bltz	a5,800067f6 <sys_exec+0x128>
    800066fe:	e7a6                	sd	s1,456(sp)
    80006700:	e3ca                	sd	s2,448(sp)
    80006702:	ff4e                	sd	s3,440(sp)
    80006704:	fb52                	sd	s4,432(sp)
    80006706:	f756                	sd	s5,424(sp)
    80006708:	f35a                	sd	s6,416(sp)
    8000670a:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000670c:	e3040a13          	addi	s4,s0,-464
    80006710:	10000613          	li	a2,256
    80006714:	4581                	li	a1,0
    80006716:	8552                	mv	a0,s4
    80006718:	ffffa097          	auipc	ra,0xffffa
    8000671c:	6f6080e7          	jalr	1782(ra) # 80000e0e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006720:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80006722:	89d2                	mv	s3,s4
    80006724:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006726:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000672a:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000672c:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006730:	00391513          	slli	a0,s2,0x3
    80006734:	85d6                	mv	a1,s5
    80006736:	e2843783          	ld	a5,-472(s0)
    8000673a:	953e                	add	a0,a0,a5
    8000673c:	ffffd097          	auipc	ra,0xffffd
    80006740:	d62080e7          	jalr	-670(ra) # 8000349e <fetchaddr>
    80006744:	02054a63          	bltz	a0,80006778 <sys_exec+0xaa>
    if(uarg == 0){
    80006748:	e2043783          	ld	a5,-480(s0)
    8000674c:	cbb1                	beqz	a5,800067a0 <sys_exec+0xd2>
    argv[i] = kalloc();
    8000674e:	ffffa097          	auipc	ra,0xffffa
    80006752:	4b6080e7          	jalr	1206(ra) # 80000c04 <kalloc>
    80006756:	85aa                	mv	a1,a0
    80006758:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000675c:	cd11                	beqz	a0,80006778 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000675e:	865a                	mv	a2,s6
    80006760:	e2043503          	ld	a0,-480(s0)
    80006764:	ffffd097          	auipc	ra,0xffffd
    80006768:	d8c080e7          	jalr	-628(ra) # 800034f0 <fetchstr>
    8000676c:	00054663          	bltz	a0,80006778 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80006770:	0905                	addi	s2,s2,1
    80006772:	09a1                	addi	s3,s3,8
    80006774:	fb791ee3          	bne	s2,s7,80006730 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006778:	100a0a13          	addi	s4,s4,256
    8000677c:	6088                	ld	a0,0(s1)
    8000677e:	c525                	beqz	a0,800067e6 <sys_exec+0x118>
    kfree(argv[i]);
    80006780:	ffffa097          	auipc	ra,0xffffa
    80006784:	31c080e7          	jalr	796(ra) # 80000a9c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006788:	04a1                	addi	s1,s1,8
    8000678a:	ff4499e3          	bne	s1,s4,8000677c <sys_exec+0xae>
  return -1;
    8000678e:	557d                	li	a0,-1
    80006790:	64be                	ld	s1,456(sp)
    80006792:	691e                	ld	s2,448(sp)
    80006794:	79fa                	ld	s3,440(sp)
    80006796:	7a5a                	ld	s4,432(sp)
    80006798:	7aba                	ld	s5,424(sp)
    8000679a:	7b1a                	ld	s6,416(sp)
    8000679c:	6bfa                	ld	s7,408(sp)
    8000679e:	a8a1                	j	800067f6 <sys_exec+0x128>
      argv[i] = 0;
    800067a0:	0009079b          	sext.w	a5,s2
    800067a4:	e3040593          	addi	a1,s0,-464
    800067a8:	078e                	slli	a5,a5,0x3
    800067aa:	97ae                	add	a5,a5,a1
    800067ac:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800067b0:	f3040513          	addi	a0,s0,-208
    800067b4:	fffff097          	auipc	ra,0xfffff
    800067b8:	118080e7          	jalr	280(ra) # 800058cc <exec>
    800067bc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800067be:	100a0a13          	addi	s4,s4,256
    800067c2:	6088                	ld	a0,0(s1)
    800067c4:	c901                	beqz	a0,800067d4 <sys_exec+0x106>
    kfree(argv[i]);
    800067c6:	ffffa097          	auipc	ra,0xffffa
    800067ca:	2d6080e7          	jalr	726(ra) # 80000a9c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800067ce:	04a1                	addi	s1,s1,8
    800067d0:	ff4499e3          	bne	s1,s4,800067c2 <sys_exec+0xf4>
  return ret;
    800067d4:	854a                	mv	a0,s2
    800067d6:	64be                	ld	s1,456(sp)
    800067d8:	691e                	ld	s2,448(sp)
    800067da:	79fa                	ld	s3,440(sp)
    800067dc:	7a5a                	ld	s4,432(sp)
    800067de:	7aba                	ld	s5,424(sp)
    800067e0:	7b1a                	ld	s6,416(sp)
    800067e2:	6bfa                	ld	s7,408(sp)
    800067e4:	a809                	j	800067f6 <sys_exec+0x128>
  return -1;
    800067e6:	557d                	li	a0,-1
    800067e8:	64be                	ld	s1,456(sp)
    800067ea:	691e                	ld	s2,448(sp)
    800067ec:	79fa                	ld	s3,440(sp)
    800067ee:	7a5a                	ld	s4,432(sp)
    800067f0:	7aba                	ld	s5,424(sp)
    800067f2:	7b1a                	ld	s6,416(sp)
    800067f4:	6bfa                	ld	s7,408(sp)
}
    800067f6:	60fe                	ld	ra,472(sp)
    800067f8:	645e                	ld	s0,464(sp)
    800067fa:	613d                	addi	sp,sp,480
    800067fc:	8082                	ret

00000000800067fe <sys_pipe>:

uint64
sys_pipe(void)
{
    800067fe:	7139                	addi	sp,sp,-64
    80006800:	fc06                	sd	ra,56(sp)
    80006802:	f822                	sd	s0,48(sp)
    80006804:	f426                	sd	s1,40(sp)
    80006806:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006808:	ffffb097          	auipc	ra,0xffffb
    8000680c:	71a080e7          	jalr	1818(ra) # 80001f22 <myproc>
    80006810:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006812:	fd840593          	addi	a1,s0,-40
    80006816:	4501                	li	a0,0
    80006818:	ffffd097          	auipc	ra,0xffffd
    8000681c:	d44080e7          	jalr	-700(ra) # 8000355c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006820:	fc840593          	addi	a1,s0,-56
    80006824:	fd040513          	addi	a0,s0,-48
    80006828:	fffff097          	auipc	ra,0xfffff
    8000682c:	d0e080e7          	jalr	-754(ra) # 80005536 <pipealloc>
    return -1;
    80006830:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006832:	0c054463          	bltz	a0,800068fa <sys_pipe+0xfc>
  fd0 = -1;
    80006836:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000683a:	fd043503          	ld	a0,-48(s0)
    8000683e:	fffff097          	auipc	ra,0xfffff
    80006842:	4b6080e7          	jalr	1206(ra) # 80005cf4 <fdalloc>
    80006846:	fca42223          	sw	a0,-60(s0)
    8000684a:	08054b63          	bltz	a0,800068e0 <sys_pipe+0xe2>
    8000684e:	fc843503          	ld	a0,-56(s0)
    80006852:	fffff097          	auipc	ra,0xfffff
    80006856:	4a2080e7          	jalr	1186(ra) # 80005cf4 <fdalloc>
    8000685a:	fca42023          	sw	a0,-64(s0)
    8000685e:	06054863          	bltz	a0,800068ce <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006862:	4691                	li	a3,4
    80006864:	fc440613          	addi	a2,s0,-60
    80006868:	fd843583          	ld	a1,-40(s0)
    8000686c:	68a8                	ld	a0,80(s1)
    8000686e:	ffffb097          	auipc	ra,0xffffb
    80006872:	35c080e7          	jalr	860(ra) # 80001bca <copyout>
    80006876:	02054063          	bltz	a0,80006896 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000687a:	4691                	li	a3,4
    8000687c:	fc040613          	addi	a2,s0,-64
    80006880:	fd843583          	ld	a1,-40(s0)
    80006884:	95b6                	add	a1,a1,a3
    80006886:	68a8                	ld	a0,80(s1)
    80006888:	ffffb097          	auipc	ra,0xffffb
    8000688c:	342080e7          	jalr	834(ra) # 80001bca <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006890:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006892:	06055463          	bgez	a0,800068fa <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006896:	fc442783          	lw	a5,-60(s0)
    8000689a:	07e9                	addi	a5,a5,26
    8000689c:	078e                	slli	a5,a5,0x3
    8000689e:	97a6                	add	a5,a5,s1
    800068a0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800068a4:	fc042783          	lw	a5,-64(s0)
    800068a8:	07e9                	addi	a5,a5,26
    800068aa:	078e                	slli	a5,a5,0x3
    800068ac:	94be                	add	s1,s1,a5
    800068ae:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800068b2:	fd043503          	ld	a0,-48(s0)
    800068b6:	fffff097          	auipc	ra,0xfffff
    800068ba:	90c080e7          	jalr	-1780(ra) # 800051c2 <fileclose>
    fileclose(wf);
    800068be:	fc843503          	ld	a0,-56(s0)
    800068c2:	fffff097          	auipc	ra,0xfffff
    800068c6:	900080e7          	jalr	-1792(ra) # 800051c2 <fileclose>
    return -1;
    800068ca:	57fd                	li	a5,-1
    800068cc:	a03d                	j	800068fa <sys_pipe+0xfc>
    if(fd0 >= 0)
    800068ce:	fc442783          	lw	a5,-60(s0)
    800068d2:	0007c763          	bltz	a5,800068e0 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800068d6:	07e9                	addi	a5,a5,26
    800068d8:	078e                	slli	a5,a5,0x3
    800068da:	97a6                	add	a5,a5,s1
    800068dc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800068e0:	fd043503          	ld	a0,-48(s0)
    800068e4:	fffff097          	auipc	ra,0xfffff
    800068e8:	8de080e7          	jalr	-1826(ra) # 800051c2 <fileclose>
    fileclose(wf);
    800068ec:	fc843503          	ld	a0,-56(s0)
    800068f0:	fffff097          	auipc	ra,0xfffff
    800068f4:	8d2080e7          	jalr	-1838(ra) # 800051c2 <fileclose>
    return -1;
    800068f8:	57fd                	li	a5,-1
}
    800068fa:	853e                	mv	a0,a5
    800068fc:	70e2                	ld	ra,56(sp)
    800068fe:	7442                	ld	s0,48(sp)
    80006900:	74a2                	ld	s1,40(sp)
    80006902:	6121                	addi	sp,sp,64
    80006904:	8082                	ret
	...

0000000080006910 <kernelvec>:
    80006910:	7111                	addi	sp,sp,-256
    80006912:	e006                	sd	ra,0(sp)
    80006914:	e40a                	sd	sp,8(sp)
    80006916:	e80e                	sd	gp,16(sp)
    80006918:	ec12                	sd	tp,24(sp)
    8000691a:	f016                	sd	t0,32(sp)
    8000691c:	f41a                	sd	t1,40(sp)
    8000691e:	f81e                	sd	t2,48(sp)
    80006920:	fc22                	sd	s0,56(sp)
    80006922:	e0a6                	sd	s1,64(sp)
    80006924:	e4aa                	sd	a0,72(sp)
    80006926:	e8ae                	sd	a1,80(sp)
    80006928:	ecb2                	sd	a2,88(sp)
    8000692a:	f0b6                	sd	a3,96(sp)
    8000692c:	f4ba                	sd	a4,104(sp)
    8000692e:	f8be                	sd	a5,112(sp)
    80006930:	fcc2                	sd	a6,120(sp)
    80006932:	e146                	sd	a7,128(sp)
    80006934:	e54a                	sd	s2,136(sp)
    80006936:	e94e                	sd	s3,144(sp)
    80006938:	ed52                	sd	s4,152(sp)
    8000693a:	f156                	sd	s5,160(sp)
    8000693c:	f55a                	sd	s6,168(sp)
    8000693e:	f95e                	sd	s7,176(sp)
    80006940:	fd62                	sd	s8,184(sp)
    80006942:	e1e6                	sd	s9,192(sp)
    80006944:	e5ea                	sd	s10,200(sp)
    80006946:	e9ee                	sd	s11,208(sp)
    80006948:	edf2                	sd	t3,216(sp)
    8000694a:	f1f6                	sd	t4,224(sp)
    8000694c:	f5fa                	sd	t5,232(sp)
    8000694e:	f9fe                	sd	t6,240(sp)
    80006950:	a1bfc0ef          	jal	8000336a <kerneltrap>
    80006954:	6082                	ld	ra,0(sp)
    80006956:	6122                	ld	sp,8(sp)
    80006958:	61c2                	ld	gp,16(sp)
    8000695a:	7282                	ld	t0,32(sp)
    8000695c:	7322                	ld	t1,40(sp)
    8000695e:	73c2                	ld	t2,48(sp)
    80006960:	7462                	ld	s0,56(sp)
    80006962:	6486                	ld	s1,64(sp)
    80006964:	6526                	ld	a0,72(sp)
    80006966:	65c6                	ld	a1,80(sp)
    80006968:	6666                	ld	a2,88(sp)
    8000696a:	7686                	ld	a3,96(sp)
    8000696c:	7726                	ld	a4,104(sp)
    8000696e:	77c6                	ld	a5,112(sp)
    80006970:	7866                	ld	a6,120(sp)
    80006972:	688a                	ld	a7,128(sp)
    80006974:	692a                	ld	s2,136(sp)
    80006976:	69ca                	ld	s3,144(sp)
    80006978:	6a6a                	ld	s4,152(sp)
    8000697a:	7a8a                	ld	s5,160(sp)
    8000697c:	7b2a                	ld	s6,168(sp)
    8000697e:	7bca                	ld	s7,176(sp)
    80006980:	7c6a                	ld	s8,184(sp)
    80006982:	6c8e                	ld	s9,192(sp)
    80006984:	6d2e                	ld	s10,200(sp)
    80006986:	6dce                	ld	s11,208(sp)
    80006988:	6e6e                	ld	t3,216(sp)
    8000698a:	7e8e                	ld	t4,224(sp)
    8000698c:	7f2e                	ld	t5,232(sp)
    8000698e:	7fce                	ld	t6,240(sp)
    80006990:	6111                	addi	sp,sp,256
    80006992:	10200073          	sret
    80006996:	00000013          	nop
    8000699a:	00000013          	nop
    8000699e:	0001                	nop

00000000800069a0 <timervec>:
    800069a0:	34051573          	csrrw	a0,mscratch,a0
    800069a4:	e10c                	sd	a1,0(a0)
    800069a6:	e510                	sd	a2,8(a0)
    800069a8:	e914                	sd	a3,16(a0)
    800069aa:	6d0c                	ld	a1,24(a0)
    800069ac:	7110                	ld	a2,32(a0)
    800069ae:	6194                	ld	a3,0(a1)
    800069b0:	96b2                	add	a3,a3,a2
    800069b2:	e194                	sd	a3,0(a1)
    800069b4:	4589                	li	a1,2
    800069b6:	14459073          	csrw	sip,a1
    800069ba:	6914                	ld	a3,16(a0)
    800069bc:	6510                	ld	a2,8(a0)
    800069be:	610c                	ld	a1,0(a0)
    800069c0:	34051573          	csrrw	a0,mscratch,a0
    800069c4:	30200073          	mret
	...

00000000800069ca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800069ca:	1141                	addi	sp,sp,-16
    800069cc:	e406                	sd	ra,8(sp)
    800069ce:	e022                	sd	s0,0(sp)
    800069d0:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800069d2:	0c000737          	lui	a4,0xc000
    800069d6:	4785                	li	a5,1
    800069d8:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800069da:	c35c                	sw	a5,4(a4)
  *(uint32*)(PLIC + VIRTIO1_IRQ*4) = 1;
    800069dc:	c71c                	sw	a5,8(a4)
}
    800069de:	60a2                	ld	ra,8(sp)
    800069e0:	6402                	ld	s0,0(sp)
    800069e2:	0141                	addi	sp,sp,16
    800069e4:	8082                	ret

00000000800069e6 <plicinithart>:

void
plicinithart(void)
{
    800069e6:	1141                	addi	sp,sp,-16
    800069e8:	e406                	sd	ra,8(sp)
    800069ea:	e022                	sd	s0,0(sp)
    800069ec:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800069ee:	ffffb097          	auipc	ra,0xffffb
    800069f2:	500080e7          	jalr	1280(ra) # 80001eee <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ) | (1 << VIRTIO1_IRQ);
    800069f6:	0085171b          	slliw	a4,a0,0x8
    800069fa:	0c0027b7          	lui	a5,0xc002
    800069fe:	97ba                	add	a5,a5,a4
    80006a00:	40600713          	li	a4,1030
    80006a04:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006a08:	00d5151b          	slliw	a0,a0,0xd
    80006a0c:	0c2017b7          	lui	a5,0xc201
    80006a10:	97aa                	add	a5,a5,a0
    80006a12:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006a16:	60a2                	ld	ra,8(sp)
    80006a18:	6402                	ld	s0,0(sp)
    80006a1a:	0141                	addi	sp,sp,16
    80006a1c:	8082                	ret

0000000080006a1e <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006a1e:	1141                	addi	sp,sp,-16
    80006a20:	e406                	sd	ra,8(sp)
    80006a22:	e022                	sd	s0,0(sp)
    80006a24:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006a26:	ffffb097          	auipc	ra,0xffffb
    80006a2a:	4c8080e7          	jalr	1224(ra) # 80001eee <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006a2e:	00d5151b          	slliw	a0,a0,0xd
    80006a32:	0c2017b7          	lui	a5,0xc201
    80006a36:	97aa                	add	a5,a5,a0
  return irq;
}
    80006a38:	43c8                	lw	a0,4(a5)
    80006a3a:	60a2                	ld	ra,8(sp)
    80006a3c:	6402                	ld	s0,0(sp)
    80006a3e:	0141                	addi	sp,sp,16
    80006a40:	8082                	ret

0000000080006a42 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006a42:	1101                	addi	sp,sp,-32
    80006a44:	ec06                	sd	ra,24(sp)
    80006a46:	e822                	sd	s0,16(sp)
    80006a48:	e426                	sd	s1,8(sp)
    80006a4a:	1000                	addi	s0,sp,32
    80006a4c:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006a4e:	ffffb097          	auipc	ra,0xffffb
    80006a52:	4a0080e7          	jalr	1184(ra) # 80001eee <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006a56:	00d5179b          	slliw	a5,a0,0xd
    80006a5a:	0c201737          	lui	a4,0xc201
    80006a5e:	97ba                	add	a5,a5,a4
    80006a60:	c3c4                	sw	s1,4(a5)
}
    80006a62:	60e2                	ld	ra,24(sp)
    80006a64:	6442                	ld	s0,16(sp)
    80006a66:	64a2                	ld	s1,8(sp)
    80006a68:	6105                	addi	sp,sp,32
    80006a6a:	8082                	ret

0000000080006a6c <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006a6c:	1141                	addi	sp,sp,-16
    80006a6e:	e406                	sd	ra,8(sp)
    80006a70:	e022                	sd	s0,0(sp)
    80006a72:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006a74:	479d                	li	a5,7
    80006a76:	04a7cc63          	blt	a5,a0,80006ace <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006a7a:	00067797          	auipc	a5,0x67
    80006a7e:	6c678793          	addi	a5,a5,1734 # 8006e140 <disk>
    80006a82:	97aa                	add	a5,a5,a0
    80006a84:	0187c783          	lbu	a5,24(a5)
    80006a88:	ebb9                	bnez	a5,80006ade <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006a8a:	00451693          	slli	a3,a0,0x4
    80006a8e:	00067797          	auipc	a5,0x67
    80006a92:	6b278793          	addi	a5,a5,1714 # 8006e140 <disk>
    80006a96:	6398                	ld	a4,0(a5)
    80006a98:	9736                	add	a4,a4,a3
    80006a9a:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80006a9e:	6398                	ld	a4,0(a5)
    80006aa0:	9736                	add	a4,a4,a3
    80006aa2:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006aa6:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006aaa:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006aae:	97aa                	add	a5,a5,a0
    80006ab0:	4705                	li	a4,1
    80006ab2:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006ab6:	00067517          	auipc	a0,0x67
    80006aba:	6a250513          	addi	a0,a0,1698 # 8006e158 <disk+0x18>
    80006abe:	ffffc097          	auipc	ra,0xffffc
    80006ac2:	d76080e7          	jalr	-650(ra) # 80002834 <wakeup>
}
    80006ac6:	60a2                	ld	ra,8(sp)
    80006ac8:	6402                	ld	s0,0(sp)
    80006aca:	0141                	addi	sp,sp,16
    80006acc:	8082                	ret
    panic("free_desc 1");
    80006ace:	00003517          	auipc	a0,0x3
    80006ad2:	c4a50513          	addi	a0,a0,-950 # 80009718 <etext+0x718>
    80006ad6:	ffffa097          	auipc	ra,0xffffa
    80006ada:	a8a080e7          	jalr	-1398(ra) # 80000560 <panic>
    panic("free_desc 2");
    80006ade:	00003517          	auipc	a0,0x3
    80006ae2:	c4a50513          	addi	a0,a0,-950 # 80009728 <etext+0x728>
    80006ae6:	ffffa097          	auipc	ra,0xffffa
    80006aea:	a7a080e7          	jalr	-1414(ra) # 80000560 <panic>

0000000080006aee <virtio_disk_init>:
{
    80006aee:	1101                	addi	sp,sp,-32
    80006af0:	ec06                	sd	ra,24(sp)
    80006af2:	e822                	sd	s0,16(sp)
    80006af4:	e426                	sd	s1,8(sp)
    80006af6:	e04a                	sd	s2,0(sp)
    80006af8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006afa:	00003597          	auipc	a1,0x3
    80006afe:	c3e58593          	addi	a1,a1,-962 # 80009738 <etext+0x738>
    80006b02:	00067517          	auipc	a0,0x67
    80006b06:	76650513          	addi	a0,a0,1894 # 8006e268 <disk+0x128>
    80006b0a:	ffffa097          	auipc	ra,0xffffa
    80006b0e:	178080e7          	jalr	376(ra) # 80000c82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006b12:	100017b7          	lui	a5,0x10001
    80006b16:	4398                	lw	a4,0(a5)
    80006b18:	2701                	sext.w	a4,a4
    80006b1a:	747277b7          	lui	a5,0x74727
    80006b1e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006b22:	16f71463          	bne	a4,a5,80006c8a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006b26:	100017b7          	lui	a5,0x10001
    80006b2a:	43dc                	lw	a5,4(a5)
    80006b2c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006b2e:	4709                	li	a4,2
    80006b30:	14e79d63          	bne	a5,a4,80006c8a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006b34:	100017b7          	lui	a5,0x10001
    80006b38:	479c                	lw	a5,8(a5)
    80006b3a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006b3c:	14e79763          	bne	a5,a4,80006c8a <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006b40:	100017b7          	lui	a5,0x10001
    80006b44:	47d8                	lw	a4,12(a5)
    80006b46:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006b48:	554d47b7          	lui	a5,0x554d4
    80006b4c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006b50:	12f71d63          	bne	a4,a5,80006c8a <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006b54:	100017b7          	lui	a5,0x10001
    80006b58:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006b5c:	4705                	li	a4,1
    80006b5e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006b60:	470d                	li	a4,3
    80006b62:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006b64:	10001737          	lui	a4,0x10001
    80006b68:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006b6a:	c7ffe6b7          	lui	a3,0xc7ffe
    80006b6e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f90467>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006b72:	8f75                	and	a4,a4,a3
    80006b74:	100016b7          	lui	a3,0x10001
    80006b78:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006b7a:	472d                	li	a4,11
    80006b7c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006b7e:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006b82:	439c                	lw	a5,0(a5)
    80006b84:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006b88:	8ba1                	andi	a5,a5,8
    80006b8a:	10078863          	beqz	a5,80006c9a <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006b8e:	100017b7          	lui	a5,0x10001
    80006b92:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006b96:	43fc                	lw	a5,68(a5)
    80006b98:	2781                	sext.w	a5,a5
    80006b9a:	10079863          	bnez	a5,80006caa <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006b9e:	100017b7          	lui	a5,0x10001
    80006ba2:	5bdc                	lw	a5,52(a5)
    80006ba4:	2781                	sext.w	a5,a5
  if(max == 0)
    80006ba6:	10078a63          	beqz	a5,80006cba <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006baa:	471d                	li	a4,7
    80006bac:	10f77f63          	bgeu	a4,a5,80006cca <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    80006bb0:	ffffa097          	auipc	ra,0xffffa
    80006bb4:	054080e7          	jalr	84(ra) # 80000c04 <kalloc>
    80006bb8:	00067497          	auipc	s1,0x67
    80006bbc:	58848493          	addi	s1,s1,1416 # 8006e140 <disk>
    80006bc0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006bc2:	ffffa097          	auipc	ra,0xffffa
    80006bc6:	042080e7          	jalr	66(ra) # 80000c04 <kalloc>
    80006bca:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006bcc:	ffffa097          	auipc	ra,0xffffa
    80006bd0:	038080e7          	jalr	56(ra) # 80000c04 <kalloc>
    80006bd4:	87aa                	mv	a5,a0
    80006bd6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006bd8:	6088                	ld	a0,0(s1)
    80006bda:	10050063          	beqz	a0,80006cda <virtio_disk_init+0x1ec>
    80006bde:	00067717          	auipc	a4,0x67
    80006be2:	56a73703          	ld	a4,1386(a4) # 8006e148 <disk+0x8>
    80006be6:	cb75                	beqz	a4,80006cda <virtio_disk_init+0x1ec>
    80006be8:	cbed                	beqz	a5,80006cda <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006bea:	6605                	lui	a2,0x1
    80006bec:	4581                	li	a1,0
    80006bee:	ffffa097          	auipc	ra,0xffffa
    80006bf2:	220080e7          	jalr	544(ra) # 80000e0e <memset>
  memset(disk.avail, 0, PGSIZE);
    80006bf6:	00067497          	auipc	s1,0x67
    80006bfa:	54a48493          	addi	s1,s1,1354 # 8006e140 <disk>
    80006bfe:	6605                	lui	a2,0x1
    80006c00:	4581                	li	a1,0
    80006c02:	6488                	ld	a0,8(s1)
    80006c04:	ffffa097          	auipc	ra,0xffffa
    80006c08:	20a080e7          	jalr	522(ra) # 80000e0e <memset>
  memset(disk.used, 0, PGSIZE);
    80006c0c:	6605                	lui	a2,0x1
    80006c0e:	4581                	li	a1,0
    80006c10:	6888                	ld	a0,16(s1)
    80006c12:	ffffa097          	auipc	ra,0xffffa
    80006c16:	1fc080e7          	jalr	508(ra) # 80000e0e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006c1a:	100017b7          	lui	a5,0x10001
    80006c1e:	4721                	li	a4,8
    80006c20:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006c22:	4098                	lw	a4,0(s1)
    80006c24:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006c28:	40d8                	lw	a4,4(s1)
    80006c2a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006c2e:	649c                	ld	a5,8(s1)
    80006c30:	0007869b          	sext.w	a3,a5
    80006c34:	10001737          	lui	a4,0x10001
    80006c38:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006c3c:	9781                	srai	a5,a5,0x20
    80006c3e:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006c42:	689c                	ld	a5,16(s1)
    80006c44:	0007869b          	sext.w	a3,a5
    80006c48:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006c4c:	9781                	srai	a5,a5,0x20
    80006c4e:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006c52:	4785                	li	a5,1
    80006c54:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006c56:	00f48c23          	sb	a5,24(s1)
    80006c5a:	00f48ca3          	sb	a5,25(s1)
    80006c5e:	00f48d23          	sb	a5,26(s1)
    80006c62:	00f48da3          	sb	a5,27(s1)
    80006c66:	00f48e23          	sb	a5,28(s1)
    80006c6a:	00f48ea3          	sb	a5,29(s1)
    80006c6e:	00f48f23          	sb	a5,30(s1)
    80006c72:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006c76:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006c7a:	07272823          	sw	s2,112(a4)
}
    80006c7e:	60e2                	ld	ra,24(sp)
    80006c80:	6442                	ld	s0,16(sp)
    80006c82:	64a2                	ld	s1,8(sp)
    80006c84:	6902                	ld	s2,0(sp)
    80006c86:	6105                	addi	sp,sp,32
    80006c88:	8082                	ret
    panic("could not find virtio disk");
    80006c8a:	00003517          	auipc	a0,0x3
    80006c8e:	abe50513          	addi	a0,a0,-1346 # 80009748 <etext+0x748>
    80006c92:	ffffa097          	auipc	ra,0xffffa
    80006c96:	8ce080e7          	jalr	-1842(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006c9a:	00003517          	auipc	a0,0x3
    80006c9e:	ace50513          	addi	a0,a0,-1330 # 80009768 <etext+0x768>
    80006ca2:	ffffa097          	auipc	ra,0xffffa
    80006ca6:	8be080e7          	jalr	-1858(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006caa:	00003517          	auipc	a0,0x3
    80006cae:	ade50513          	addi	a0,a0,-1314 # 80009788 <etext+0x788>
    80006cb2:	ffffa097          	auipc	ra,0xffffa
    80006cb6:	8ae080e7          	jalr	-1874(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006cba:	00003517          	auipc	a0,0x3
    80006cbe:	aee50513          	addi	a0,a0,-1298 # 800097a8 <etext+0x7a8>
    80006cc2:	ffffa097          	auipc	ra,0xffffa
    80006cc6:	89e080e7          	jalr	-1890(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006cca:	00003517          	auipc	a0,0x3
    80006cce:	afe50513          	addi	a0,a0,-1282 # 800097c8 <etext+0x7c8>
    80006cd2:	ffffa097          	auipc	ra,0xffffa
    80006cd6:	88e080e7          	jalr	-1906(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006cda:	00003517          	auipc	a0,0x3
    80006cde:	b0e50513          	addi	a0,a0,-1266 # 800097e8 <etext+0x7e8>
    80006ce2:	ffffa097          	auipc	ra,0xffffa
    80006ce6:	87e080e7          	jalr	-1922(ra) # 80000560 <panic>

0000000080006cea <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006cea:	711d                	addi	sp,sp,-96
    80006cec:	ec86                	sd	ra,88(sp)
    80006cee:	e8a2                	sd	s0,80(sp)
    80006cf0:	e4a6                	sd	s1,72(sp)
    80006cf2:	e0ca                	sd	s2,64(sp)
    80006cf4:	fc4e                	sd	s3,56(sp)
    80006cf6:	f852                	sd	s4,48(sp)
    80006cf8:	f456                	sd	s5,40(sp)
    80006cfa:	f05a                	sd	s6,32(sp)
    80006cfc:	ec5e                	sd	s7,24(sp)
    80006cfe:	e862                	sd	s8,16(sp)
    80006d00:	1080                	addi	s0,sp,96
    80006d02:	89aa                	mv	s3,a0
    80006d04:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006d06:	00c52b83          	lw	s7,12(a0)
    80006d0a:	001b9b9b          	slliw	s7,s7,0x1
    80006d0e:	1b82                	slli	s7,s7,0x20
    80006d10:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006d14:	00067517          	auipc	a0,0x67
    80006d18:	55450513          	addi	a0,a0,1364 # 8006e268 <disk+0x128>
    80006d1c:	ffffa097          	auipc	ra,0xffffa
    80006d20:	ffa080e7          	jalr	-6(ra) # 80000d16 <acquire>
  for(int i = 0; i < NUM; i++){
    80006d24:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006d26:	00067a97          	auipc	s5,0x67
    80006d2a:	41aa8a93          	addi	s5,s5,1050 # 8006e140 <disk>
  for(int i = 0; i < 3; i++){
    80006d2e:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006d30:	5c7d                	li	s8,-1
    80006d32:	a885                	j	80006da2 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006d34:	00fa8733          	add	a4,s5,a5
    80006d38:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006d3c:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006d3e:	0207c563          	bltz	a5,80006d68 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006d42:	2905                	addiw	s2,s2,1
    80006d44:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006d46:	07490263          	beq	s2,s4,80006daa <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006d4a:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006d4c:	00067717          	auipc	a4,0x67
    80006d50:	3f470713          	addi	a4,a4,1012 # 8006e140 <disk>
    80006d54:	4781                	li	a5,0
    if(disk.free[i]){
    80006d56:	01874683          	lbu	a3,24(a4)
    80006d5a:	fee9                	bnez	a3,80006d34 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80006d5c:	2785                	addiw	a5,a5,1
    80006d5e:	0705                	addi	a4,a4,1
    80006d60:	fe979be3          	bne	a5,s1,80006d56 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006d64:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006d68:	03205163          	blez	s2,80006d8a <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006d6c:	fa042503          	lw	a0,-96(s0)
    80006d70:	00000097          	auipc	ra,0x0
    80006d74:	cfc080e7          	jalr	-772(ra) # 80006a6c <free_desc>
      for(int j = 0; j < i; j++)
    80006d78:	4785                	li	a5,1
    80006d7a:	0127d863          	bge	a5,s2,80006d8a <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006d7e:	fa442503          	lw	a0,-92(s0)
    80006d82:	00000097          	auipc	ra,0x0
    80006d86:	cea080e7          	jalr	-790(ra) # 80006a6c <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006d8a:	00067597          	auipc	a1,0x67
    80006d8e:	4de58593          	addi	a1,a1,1246 # 8006e268 <disk+0x128>
    80006d92:	00067517          	auipc	a0,0x67
    80006d96:	3c650513          	addi	a0,a0,966 # 8006e158 <disk+0x18>
    80006d9a:	ffffc097          	auipc	ra,0xffffc
    80006d9e:	a36080e7          	jalr	-1482(ra) # 800027d0 <sleep>
  for(int i = 0; i < 3; i++){
    80006da2:	fa040613          	addi	a2,s0,-96
    80006da6:	4901                	li	s2,0
    80006da8:	b74d                	j	80006d4a <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006daa:	fa042503          	lw	a0,-96(s0)
    80006dae:	00451693          	slli	a3,a0,0x4

  if(write)
    80006db2:	00067797          	auipc	a5,0x67
    80006db6:	38e78793          	addi	a5,a5,910 # 8006e140 <disk>
    80006dba:	00a50713          	addi	a4,a0,10
    80006dbe:	0712                	slli	a4,a4,0x4
    80006dc0:	973e                	add	a4,a4,a5
    80006dc2:	01603633          	snez	a2,s6
    80006dc6:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006dc8:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006dcc:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006dd0:	6398                	ld	a4,0(a5)
    80006dd2:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006dd4:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006dd8:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006dda:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006ddc:	6390                	ld	a2,0(a5)
    80006dde:	00d605b3          	add	a1,a2,a3
    80006de2:	4741                	li	a4,16
    80006de4:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006de6:	4805                	li	a6,1
    80006de8:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80006dec:	fa442703          	lw	a4,-92(s0)
    80006df0:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006df4:	0712                	slli	a4,a4,0x4
    80006df6:	963a                	add	a2,a2,a4
    80006df8:	05898593          	addi	a1,s3,88
    80006dfc:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006dfe:	0007b883          	ld	a7,0(a5)
    80006e02:	9746                	add	a4,a4,a7
    80006e04:	40000613          	li	a2,1024
    80006e08:	c710                	sw	a2,8(a4)
  if(write)
    80006e0a:	001b3613          	seqz	a2,s6
    80006e0e:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006e12:	01066633          	or	a2,a2,a6
    80006e16:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006e1a:	fa842583          	lw	a1,-88(s0)
    80006e1e:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006e22:	00250613          	addi	a2,a0,2
    80006e26:	0612                	slli	a2,a2,0x4
    80006e28:	963e                	add	a2,a2,a5
    80006e2a:	577d                	li	a4,-1
    80006e2c:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006e30:	0592                	slli	a1,a1,0x4
    80006e32:	98ae                	add	a7,a7,a1
    80006e34:	03068713          	addi	a4,a3,48
    80006e38:	973e                	add	a4,a4,a5
    80006e3a:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006e3e:	6398                	ld	a4,0(a5)
    80006e40:	972e                	add	a4,a4,a1
    80006e42:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006e46:	4689                	li	a3,2
    80006e48:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006e4c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006e50:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80006e54:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006e58:	6794                	ld	a3,8(a5)
    80006e5a:	0026d703          	lhu	a4,2(a3)
    80006e5e:	8b1d                	andi	a4,a4,7
    80006e60:	0706                	slli	a4,a4,0x1
    80006e62:	96ba                	add	a3,a3,a4
    80006e64:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006e68:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006e6c:	6798                	ld	a4,8(a5)
    80006e6e:	00275783          	lhu	a5,2(a4)
    80006e72:	2785                	addiw	a5,a5,1
    80006e74:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006e78:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006e7c:	100017b7          	lui	a5,0x10001
    80006e80:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006e84:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006e88:	00067917          	auipc	s2,0x67
    80006e8c:	3e090913          	addi	s2,s2,992 # 8006e268 <disk+0x128>
  while(b->disk == 1) {
    80006e90:	84c2                	mv	s1,a6
    80006e92:	01079c63          	bne	a5,a6,80006eaa <virtio_disk_rw+0x1c0>
    sleep(b, &disk.vdisk_lock);
    80006e96:	85ca                	mv	a1,s2
    80006e98:	854e                	mv	a0,s3
    80006e9a:	ffffc097          	auipc	ra,0xffffc
    80006e9e:	936080e7          	jalr	-1738(ra) # 800027d0 <sleep>
  while(b->disk == 1) {
    80006ea2:	0049a783          	lw	a5,4(s3)
    80006ea6:	fe9788e3          	beq	a5,s1,80006e96 <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    80006eaa:	fa042903          	lw	s2,-96(s0)
    80006eae:	00290713          	addi	a4,s2,2
    80006eb2:	0712                	slli	a4,a4,0x4
    80006eb4:	00067797          	auipc	a5,0x67
    80006eb8:	28c78793          	addi	a5,a5,652 # 8006e140 <disk>
    80006ebc:	97ba                	add	a5,a5,a4
    80006ebe:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006ec2:	00067997          	auipc	s3,0x67
    80006ec6:	27e98993          	addi	s3,s3,638 # 8006e140 <disk>
    80006eca:	00491713          	slli	a4,s2,0x4
    80006ece:	0009b783          	ld	a5,0(s3)
    80006ed2:	97ba                	add	a5,a5,a4
    80006ed4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006ed8:	854a                	mv	a0,s2
    80006eda:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006ede:	00000097          	auipc	ra,0x0
    80006ee2:	b8e080e7          	jalr	-1138(ra) # 80006a6c <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006ee6:	8885                	andi	s1,s1,1
    80006ee8:	f0ed                	bnez	s1,80006eca <virtio_disk_rw+0x1e0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006eea:	00067517          	auipc	a0,0x67
    80006eee:	37e50513          	addi	a0,a0,894 # 8006e268 <disk+0x128>
    80006ef2:	ffffa097          	auipc	ra,0xffffa
    80006ef6:	ed4080e7          	jalr	-300(ra) # 80000dc6 <release>
}
    80006efa:	60e6                	ld	ra,88(sp)
    80006efc:	6446                	ld	s0,80(sp)
    80006efe:	64a6                	ld	s1,72(sp)
    80006f00:	6906                	ld	s2,64(sp)
    80006f02:	79e2                	ld	s3,56(sp)
    80006f04:	7a42                	ld	s4,48(sp)
    80006f06:	7aa2                	ld	s5,40(sp)
    80006f08:	7b02                	ld	s6,32(sp)
    80006f0a:	6be2                	ld	s7,24(sp)
    80006f0c:	6c42                	ld	s8,16(sp)
    80006f0e:	6125                	addi	sp,sp,96
    80006f10:	8082                	ret

0000000080006f12 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006f12:	1101                	addi	sp,sp,-32
    80006f14:	ec06                	sd	ra,24(sp)
    80006f16:	e822                	sd	s0,16(sp)
    80006f18:	e426                	sd	s1,8(sp)
    80006f1a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006f1c:	00067497          	auipc	s1,0x67
    80006f20:	22448493          	addi	s1,s1,548 # 8006e140 <disk>
    80006f24:	00067517          	auipc	a0,0x67
    80006f28:	34450513          	addi	a0,a0,836 # 8006e268 <disk+0x128>
    80006f2c:	ffffa097          	auipc	ra,0xffffa
    80006f30:	dea080e7          	jalr	-534(ra) # 80000d16 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006f34:	100017b7          	lui	a5,0x10001
    80006f38:	53bc                	lw	a5,96(a5)
    80006f3a:	8b8d                	andi	a5,a5,3
    80006f3c:	10001737          	lui	a4,0x10001
    80006f40:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006f42:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006f46:	689c                	ld	a5,16(s1)
    80006f48:	0204d703          	lhu	a4,32(s1)
    80006f4c:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006f50:	04f70863          	beq	a4,a5,80006fa0 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006f54:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006f58:	6898                	ld	a4,16(s1)
    80006f5a:	0204d783          	lhu	a5,32(s1)
    80006f5e:	8b9d                	andi	a5,a5,7
    80006f60:	078e                	slli	a5,a5,0x3
    80006f62:	97ba                	add	a5,a5,a4
    80006f64:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006f66:	00278713          	addi	a4,a5,2
    80006f6a:	0712                	slli	a4,a4,0x4
    80006f6c:	9726                	add	a4,a4,s1
    80006f6e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006f72:	e721                	bnez	a4,80006fba <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006f74:	0789                	addi	a5,a5,2
    80006f76:	0792                	slli	a5,a5,0x4
    80006f78:	97a6                	add	a5,a5,s1
    80006f7a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006f7c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006f80:	ffffc097          	auipc	ra,0xffffc
    80006f84:	8b4080e7          	jalr	-1868(ra) # 80002834 <wakeup>

    disk.used_idx += 1;
    80006f88:	0204d783          	lhu	a5,32(s1)
    80006f8c:	2785                	addiw	a5,a5,1
    80006f8e:	17c2                	slli	a5,a5,0x30
    80006f90:	93c1                	srli	a5,a5,0x30
    80006f92:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006f96:	6898                	ld	a4,16(s1)
    80006f98:	00275703          	lhu	a4,2(a4)
    80006f9c:	faf71ce3          	bne	a4,a5,80006f54 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006fa0:	00067517          	auipc	a0,0x67
    80006fa4:	2c850513          	addi	a0,a0,712 # 8006e268 <disk+0x128>
    80006fa8:	ffffa097          	auipc	ra,0xffffa
    80006fac:	e1e080e7          	jalr	-482(ra) # 80000dc6 <release>
}
    80006fb0:	60e2                	ld	ra,24(sp)
    80006fb2:	6442                	ld	s0,16(sp)
    80006fb4:	64a2                	ld	s1,8(sp)
    80006fb6:	6105                	addi	sp,sp,32
    80006fb8:	8082                	ret
      panic("virtio_disk_intr status");
    80006fba:	00003517          	auipc	a0,0x3
    80006fbe:	84650513          	addi	a0,a0,-1978 # 80009800 <etext+0x800>
    80006fc2:	ffff9097          	auipc	ra,0xffff9
    80006fc6:	59e080e7          	jalr	1438(ra) # 80000560 <panic>

0000000080006fca <alloc_desc>:
 *
 * Output: returns the index of the descriptor on success
 *         returns -1 if there are no free descriptors
 *
 */
int alloc_desc(struct virtq *q) {
    80006fca:	1141                	addi	sp,sp,-16
    80006fcc:	e406                	sd	ra,8(sp)
    80006fce:	e022                	sd	s0,0(sp)
    80006fd0:	0800                	addi	s0,sp,16
    80006fd2:	862a                	mv	a2,a0
  for (int i = 0; i < NUM; i++) {
    80006fd4:	01c50793          	addi	a5,a0,28
    80006fd8:	4501                	li	a0,0
    80006fda:	46a1                	li	a3,8
    if (q->free[i]) {
    80006fdc:	0007c703          	lbu	a4,0(a5)
    80006fe0:	eb11                	bnez	a4,80006ff4 <alloc_desc+0x2a>
  for (int i = 0; i < NUM; i++) {
    80006fe2:	2505                	addiw	a0,a0,1
    80006fe4:	0785                	addi	a5,a5,1
    80006fe6:	fed51be3          	bne	a0,a3,80006fdc <alloc_desc+0x12>
      q->free[i] = 0;
      return i;
    }
  }
  return -1;
    80006fea:	557d                	li	a0,-1
}
    80006fec:	60a2                	ld	ra,8(sp)
    80006fee:	6402                	ld	s0,0(sp)
    80006ff0:	0141                	addi	sp,sp,16
    80006ff2:	8082                	ret
      q->free[i] = 0;
    80006ff4:	962a                	add	a2,a2,a0
    80006ff6:	00060e23          	sb	zero,28(a2)
      return i;
    80006ffa:	bfcd                	j	80006fec <alloc_desc+0x22>

0000000080006ffc <free_desc>:
 * allocated. int i: the index at which a descriptor has been allocated in q
 *
 * Output: None
 *
 */
void free_desc(struct virtq *q, int i) {
    80006ffc:	1141                	addi	sp,sp,-16
    80006ffe:	e406                	sd	ra,8(sp)
    80007000:	e022                	sd	s0,0(sp)
    80007002:	0800                	addi	s0,sp,16
  if (i >= NUM)
    80007004:	479d                	li	a5,7
    80007006:	02b7cd63          	blt	a5,a1,80007040 <free_desc+0x44>
    panic("free_desc 1");
  if (q->free[i])
    8000700a:	00b507b3          	add	a5,a0,a1
    8000700e:	01c7c783          	lbu	a5,28(a5)
    80007012:	ef9d                	bnez	a5,80007050 <free_desc+0x54>
    panic("free_desc 2");

  q->desc->addr = 0;
    80007014:	611c                	ld	a5,0(a0)
    80007016:	0007b023          	sd	zero,0(a5)
  q->desc->len = 0;
    8000701a:	611c                	ld	a5,0(a0)
    8000701c:	0007a423          	sw	zero,8(a5)
  q->desc->flags = 0;
    80007020:	611c                	ld	a5,0(a0)
    80007022:	00079623          	sh	zero,12(a5)
  q->desc->next = 0;
    80007026:	611c                	ld	a5,0(a0)
    80007028:	00079723          	sh	zero,14(a5)
  wakeup(&q->free[i]);
    8000702c:	05f1                	addi	a1,a1,28
    8000702e:	952e                	add	a0,a0,a1
    80007030:	ffffc097          	auipc	ra,0xffffc
    80007034:	804080e7          	jalr	-2044(ra) # 80002834 <wakeup>
}
    80007038:	60a2                	ld	ra,8(sp)
    8000703a:	6402                	ld	s0,0(sp)
    8000703c:	0141                	addi	sp,sp,16
    8000703e:	8082                	ret
    panic("free_desc 1");
    80007040:	00002517          	auipc	a0,0x2
    80007044:	6d850513          	addi	a0,a0,1752 # 80009718 <etext+0x718>
    80007048:	ffff9097          	auipc	ra,0xffff9
    8000704c:	518080e7          	jalr	1304(ra) # 80000560 <panic>
    panic("free_desc 2");
    80007050:	00002517          	auipc	a0,0x2
    80007054:	6d850513          	addi	a0,a0,1752 # 80009728 <etext+0x728>
    80007058:	ffff9097          	auipc	ra,0xffff9
    8000705c:	508080e7          	jalr	1288(ra) # 80000560 <panic>

0000000080007060 <virtio_net_init>:
 * VirtualIO (VIRTIO) device. The process of this function is defined in
 * section 5.1.5 of the VIRTIO Device specification. Since I'm creating
 * a minimal netowrk driver, I only negotiate VIRTIO_NET_F_MAC
 *
 */
void virtio_net_init(void) {
    80007060:	7159                	addi	sp,sp,-112
    80007062:	f486                	sd	ra,104(sp)
    80007064:	f0a2                	sd	s0,96(sp)
    80007066:	eca6                	sd	s1,88(sp)
    80007068:	e8ca                	sd	s2,80(sp)
    8000706a:	e4ce                	sd	s3,72(sp)
    8000706c:	e0d2                	sd	s4,64(sp)
    8000706e:	fc56                	sd	s5,56(sp)
    80007070:	f85a                	sd	s6,48(sp)
    80007072:	f45e                	sd	s7,40(sp)
    80007074:	f062                	sd	s8,32(sp)
    80007076:	ec66                	sd	s9,24(sp)
    80007078:	e86a                	sd	s10,16(sp)
    8000707a:	e46e                	sd	s11,8(sp)
    8000707c:	1880                	addi	s0,sp,112
  uint32 status = 0;
  initlock(&net.vnet_lock, "virtio_net");
    8000707e:	00002597          	auipc	a1,0x2
    80007082:	79a58593          	addi	a1,a1,1946 # 80009818 <etext+0x818>
    80007086:	00067517          	auipc	a0,0x67
    8000708a:	20a50513          	addi	a0,a0,522 # 8006e290 <net+0x10>
    8000708e:	ffffa097          	auipc	ra,0xffffa
    80007092:	bf4080e7          	jalr	-1036(ra) # 80000c82 <initlock>

  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80007096:	100027b7          	lui	a5,0x10002
    8000709a:	4398                	lw	a4,0(a5)
    8000709c:	2701                	sext.w	a4,a4
    8000709e:	747277b7          	lui	a5,0x74727
    800070a2:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800070a6:	32f71a63          	bne	a4,a5,800073da <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    800070aa:	100027b7          	lui	a5,0x10002
    800070ae:	43dc                	lw	a5,4(a5)
    800070b0:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800070b2:	4709                	li	a4,2
    800070b4:	32e79363          	bne	a5,a4,800073da <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    800070b8:	100027b7          	lui	a5,0x10002
    800070bc:	479c                	lw	a5,8(a5)
    800070be:	2781                	sext.w	a5,a5
    800070c0:	4705                	li	a4,1
    800070c2:	30e79c63          	bne	a5,a4,800073da <virtio_net_init+0x37a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    800070c6:	100027b7          	lui	a5,0x10002
    800070ca:	47d8                	lw	a4,12(a5)
    800070cc:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 1 ||
    800070ce:	554d47b7          	lui	a5,0x554d4
    800070d2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800070d6:	30f71263          	bne	a4,a5,800073da <virtio_net_init+0x37a>
    panic("could not find virtio net");
  }

  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    800070da:	100024b7          	lui	s1,0x10002
    800070de:	07048493          	addi	s1,s1,112 # 10002070 <_entry-0x6fffdf90>
    800070e2:	0004a023          	sw	zero,0(s1)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
  *R(VIRTIO_MMIO_STATUS) = status;
    800070e6:	4785                	li	a5,1
    800070e8:	c09c                	sw	a5,0(s1)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
  *R(VIRTIO_MMIO_STATUS) = status;
    800070ea:	478d                	li	a5,3
    800070ec:	c09c                	sw	a5,0(s1)

  // This copies the memory from the config into my driver state struct
  memmove((void *)&net.cfg, (void *)VIRTIO_NET_CONFIG,
    800070ee:	4631                	li	a2,12
    800070f0:	100025b7          	lui	a1,0x10002
    800070f4:	10058593          	addi	a1,a1,256 # 10002100 <_entry-0x6fffdf00>
    800070f8:	00067517          	auipc	a0,0x67
    800070fc:	18850513          	addi	a0,a0,392 # 8006e280 <net>
    80007100:	ffffa097          	auipc	ra,0xffffa
    80007104:	d72080e7          	jalr	-654(ra) # 80000e72 <memmove>
          sizeof(struct virtio_net_config));

  // Negotiate the feature bits
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80007108:	100027b7          	lui	a5,0x10002
    8000710c:	4b9c                	lw	a5,16(a5)
  features &= VIRTIO_NET_F_MAC;
    8000710e:	0207f793          	andi	a5,a5,32
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80007112:	10002737          	lui	a4,0x10002
    80007116:	d31c                	sw	a5,32(a4)

  // Tell device that feature negotiation is complete
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
  *R(VIRTIO_MMIO_STATUS) = status;
    80007118:	47ad                	li	a5,11
    8000711a:	c09c                	sw	a5,0(s1)

  // Make sure that FEATURES_OK is set
  status = *R(VIRTIO_MMIO_STATUS);
    8000711c:	409c                	lw	a5,0(s1)
    8000711e:	00078d1b          	sext.w	s10,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80007122:	8ba1                	andi	a5,a5,8
    80007124:	2c078363          	beqz	a5,800073ea <virtio_net_init+0x38a>
    panic("virtio net FEATURES_OK unset");

  // Check max queue size
  uint32 max_queue_size = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80007128:	100027b7          	lui	a5,0x10002
    8000712c:	5bdc                	lw	a5,52(a5)
    8000712e:	2781                	sext.w	a5,a5
  if (max_queue_size == 0)
    80007130:	2c078563          	beqz	a5,800073fa <virtio_net_init+0x39a>
    panic("virtio net has no queue 1 (QUEUE_TX)");
  if (max_queue_size < NUM)
    80007134:	471d                	li	a4,7
    80007136:	2cf77a63          	bgeu	a4,a5,8000740a <virtio_net_init+0x3aa>
    panic("virtio net max queue too short");

  /* Initialize QUEUE_TX */
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    8000713a:	10002737          	lui	a4,0x10002
    8000713e:	4785                	li	a5,1
    80007140:	db1c                	sw	a5,48(a4)
  net.txq.num = QUEUE_TX;
    80007142:	00067717          	auipc	a4,0x67
    80007146:	16f72f23          	sw	a5,382(a4) # 8006e2c0 <net+0x40>

  // ensure QUEUE_TX is not in use.
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000714a:	100027b7          	lui	a5,0x10002
    8000714e:	43fc                	lw	a5,68(a5)
    80007150:	2781                	sext.w	a5,a5
    80007152:	2c079463          	bnez	a5,8000741a <virtio_net_init+0x3ba>
    panic("QUEUE_TX should not be ready\n");

  net.txq.desc = kalloc();
    80007156:	ffffa097          	auipc	ra,0xffffa
    8000715a:	aae080e7          	jalr	-1362(ra) # 80000c04 <kalloc>
    8000715e:	00067497          	auipc	s1,0x67
    80007162:	12248493          	addi	s1,s1,290 # 8006e280 <net>
    80007166:	f488                	sd	a0,40(s1)
  net.txq.driver_area = kalloc();
    80007168:	ffffa097          	auipc	ra,0xffffa
    8000716c:	a9c080e7          	jalr	-1380(ra) # 80000c04 <kalloc>
    80007170:	f888                	sd	a0,48(s1)
  net.txq.device_area = kalloc();
    80007172:	ffffa097          	auipc	ra,0xffffa
    80007176:	a92080e7          	jalr	-1390(ra) # 80000c04 <kalloc>
    8000717a:	87aa                	mv	a5,a0
    8000717c:	fc88                	sd	a0,56(s1)
  if (!net.txq.desc || !net.txq.driver_area || !net.txq.device_area)
    8000717e:	7488                	ld	a0,40(s1)
    80007180:	2a050563          	beqz	a0,8000742a <virtio_net_init+0x3ca>
    80007184:	00067717          	auipc	a4,0x67
    80007188:	12c73703          	ld	a4,300(a4) # 8006e2b0 <net+0x30>
    8000718c:	28070f63          	beqz	a4,8000742a <virtio_net_init+0x3ca>
    80007190:	28078d63          	beqz	a5,8000742a <virtio_net_init+0x3ca>
    panic("virtio net alloc\n");
  memset(net.txq.desc, 0, PGSIZE);
    80007194:	6605                	lui	a2,0x1
    80007196:	4581                	li	a1,0
    80007198:	ffffa097          	auipc	ra,0xffffa
    8000719c:	c76080e7          	jalr	-906(ra) # 80000e0e <memset>
  memset(net.txq.free, 1, NUM);
    800071a0:	00067497          	auipc	s1,0x67
    800071a4:	0e048493          	addi	s1,s1,224 # 8006e280 <net>
    800071a8:	4621                	li	a2,8
    800071aa:	4585                	li	a1,1
    800071ac:	00067517          	auipc	a0,0x67
    800071b0:	11850513          	addi	a0,a0,280 # 8006e2c4 <net+0x44>
    800071b4:	ffffa097          	auipc	ra,0xffffa
    800071b8:	c5a080e7          	jalr	-934(ra) # 80000e0e <memset>
  memset(net.txq.driver_area, 0, PGSIZE);
    800071bc:	6605                	lui	a2,0x1
    800071be:	4581                	li	a1,0
    800071c0:	7888                	ld	a0,48(s1)
    800071c2:	ffffa097          	auipc	ra,0xffffa
    800071c6:	c4c080e7          	jalr	-948(ra) # 80000e0e <memset>
  memset(net.txq.device_area, 0, PGSIZE);
    800071ca:	6605                	lui	a2,0x1
    800071cc:	4581                	li	a1,0
    800071ce:	7c88                	ld	a0,56(s1)
    800071d0:	ffffa097          	auipc	ra,0xffffa
    800071d4:	c3e080e7          	jalr	-962(ra) # 80000e0e <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800071d8:	100027b7          	lui	a5,0x10002
    800071dc:	4721                	li	a4,8
    800071de:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.txq.desc;
    800071e0:	749c                	ld	a5,40(s1)
    800071e2:	0007869b          	sext.w	a3,a5
    800071e6:	10002737          	lui	a4,0x10002
    800071ea:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.txq.desc) >> 32;
    800071ee:	9781                	srai	a5,a5,0x20
    800071f0:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.txq.driver_area;
    800071f4:	789c                	ld	a5,48(s1)
    800071f6:	0007869b          	sext.w	a3,a5
    800071fa:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.txq.driver_area) >> 32;
    800071fe:	9781                	srai	a5,a5,0x20
    80007200:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.txq.device_area;
    80007204:	7c9c                	ld	a5,56(s1)
    80007206:	0007869b          	sext.w	a3,a5
    8000720a:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.txq.device_area) >> 32;
    8000720e:	9781                	srai	a5,a5,0x20
    80007210:	0af72223          	sw	a5,164(a4)

  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80007214:	87ba                	mv	a5,a4
    80007216:	4705                	li	a4,1
    80007218:	c3f8                	sw	a4,68(a5)
    8000721a:	04478793          	addi	a5,a5,68 # 10002044 <_entry-0x6fffdfbc>

  /* Initialize QUEUE_RX */

  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_RX;
    8000721e:	10002737          	lui	a4,0x10002
    80007222:	02072823          	sw	zero,48(a4) # 10002030 <_entry-0x6fffdfd0>
  net.rxq.num = QUEUE_RX;
    80007226:	0604a423          	sw	zero,104(s1)
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000722a:	439c                	lw	a5,0(a5)
    8000722c:	2781                	sext.w	a5,a5
    8000722e:	20079663          	bnez	a5,8000743a <virtio_net_init+0x3da>
    panic("QUEUE_RX should not be ready\n");

  net.rxq.desc = kalloc();
    80007232:	ffffa097          	auipc	ra,0xffffa
    80007236:	9d2080e7          	jalr	-1582(ra) # 80000c04 <kalloc>
    8000723a:	00067497          	auipc	s1,0x67
    8000723e:	04648493          	addi	s1,s1,70 # 8006e280 <net>
    80007242:	e8a8                	sd	a0,80(s1)
  net.rxq.driver_area = kalloc();
    80007244:	ffffa097          	auipc	ra,0xffffa
    80007248:	9c0080e7          	jalr	-1600(ra) # 80000c04 <kalloc>
    8000724c:	eca8                	sd	a0,88(s1)
  net.rxq.device_area = kalloc();
    8000724e:	ffffa097          	auipc	ra,0xffffa
    80007252:	9b6080e7          	jalr	-1610(ra) # 80000c04 <kalloc>
    80007256:	87aa                	mv	a5,a0
    80007258:	f0a8                	sd	a0,96(s1)
  if (!net.rxq.desc || !net.rxq.driver_area || !net.rxq.device_area)
    8000725a:	68a8                	ld	a0,80(s1)
    8000725c:	1e050763          	beqz	a0,8000744a <virtio_net_init+0x3ea>
    80007260:	00067717          	auipc	a4,0x67
    80007264:	07873703          	ld	a4,120(a4) # 8006e2d8 <net+0x58>
    80007268:	1e070163          	beqz	a4,8000744a <virtio_net_init+0x3ea>
    8000726c:	1c078f63          	beqz	a5,8000744a <virtio_net_init+0x3ea>
    panic("virtio net alloc");
  memset(net.rxq.desc, 0, PGSIZE);
    80007270:	6605                	lui	a2,0x1
    80007272:	4581                	li	a1,0
    80007274:	ffffa097          	auipc	ra,0xffffa
    80007278:	b9a080e7          	jalr	-1126(ra) # 80000e0e <memset>
  memset(net.rxq.free, 1, NUM);
    8000727c:	00067497          	auipc	s1,0x67
    80007280:	00448493          	addi	s1,s1,4 # 8006e280 <net>
    80007284:	4621                	li	a2,8
    80007286:	4585                	li	a1,1
    80007288:	00067517          	auipc	a0,0x67
    8000728c:	06450513          	addi	a0,a0,100 # 8006e2ec <net+0x6c>
    80007290:	ffffa097          	auipc	ra,0xffffa
    80007294:	b7e080e7          	jalr	-1154(ra) # 80000e0e <memset>
  memset(net.rxq.driver_area, 0, PGSIZE);
    80007298:	6605                	lui	a2,0x1
    8000729a:	4581                	li	a1,0
    8000729c:	6ca8                	ld	a0,88(s1)
    8000729e:	ffffa097          	auipc	ra,0xffffa
    800072a2:	b70080e7          	jalr	-1168(ra) # 80000e0e <memset>
  memset(net.rxq.device_area, 0, PGSIZE);
    800072a6:	6605                	lui	a2,0x1
    800072a8:	4581                	li	a1,0
    800072aa:	70a8                	ld	a0,96(s1)
    800072ac:	ffffa097          	auipc	ra,0xffffa
    800072b0:	b62080e7          	jalr	-1182(ra) # 80000e0e <memset>

  // set queue size
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800072b4:	100027b7          	lui	a5,0x10002
    800072b8:	4721                	li	a4,8
    800072ba:	df98                	sw	a4,56(a5)

  // init virtqueue
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)net.rxq.desc;
    800072bc:	68bc                	ld	a5,80(s1)
    800072be:	0007869b          	sext.w	a3,a5
    800072c2:	10002737          	lui	a4,0x10002
    800072c6:	08d72023          	sw	a3,128(a4) # 10002080 <_entry-0x6fffdf80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = ((uint64)net.rxq.desc) >> 32;
    800072ca:	9781                	srai	a5,a5,0x20
    800072cc:	08f72223          	sw	a5,132(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)net.rxq.driver_area;
    800072d0:	6cbc                	ld	a5,88(s1)
    800072d2:	0007869b          	sext.w	a3,a5
    800072d6:	08d72823          	sw	a3,144(a4)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = ((uint64)net.rxq.driver_area) >> 32;
    800072da:	9781                	srai	a5,a5,0x20
    800072dc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)net.rxq.device_area;
    800072e0:	70bc                	ld	a5,96(s1)
    800072e2:	0007869b          	sext.w	a3,a5
    800072e6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = ((uint64)net.rxq.device_area) >> 32;
    800072ea:	9781                	srai	a5,a5,0x20
    800072ec:	0af72223          	sw	a5,164(a4)
    800072f0:	4a11                	li	s4,4

  for (int i = 0; i < NUM / 2; i++) {
    int rx_hdr_desc = alloc_desc(&net.rxq);
    800072f2:	00067a97          	auipc	s5,0x67
    800072f6:	fdea8a93          	addi	s5,s5,-34 # 8006e2d0 <net+0x50>
    struct virtio_net_hdr *hdr = kalloc();
    if (!rxbuf)
      panic("rxbuf alloc failed");

    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    800072fa:	4ca9                	li	s9,10
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    800072fc:	4c05                	li	s8,1
    net.rxq.desc[rx_hdr_desc].next = rx_desc;

    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    net.rxq.desc[rx_desc].len = PGSIZE;
    800072fe:	6b85                	lui	s7,0x1
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    80007300:	4b09                	li	s6,2
    int rx_hdr_desc = alloc_desc(&net.rxq);
    80007302:	8556                	mv	a0,s5
    80007304:	00000097          	auipc	ra,0x0
    80007308:	cc6080e7          	jalr	-826(ra) # 80006fca <alloc_desc>
    8000730c:	89aa                	mv	s3,a0
    int rx_desc = alloc_desc(&net.rxq);
    8000730e:	8556                	mv	a0,s5
    80007310:	00000097          	auipc	ra,0x0
    80007314:	cba080e7          	jalr	-838(ra) # 80006fca <alloc_desc>
    80007318:	8daa                	mv	s11,a0
    void *rxbuf = kalloc();
    8000731a:	ffffa097          	auipc	ra,0xffffa
    8000731e:	8ea080e7          	jalr	-1814(ra) # 80000c04 <kalloc>
    80007322:	892a                	mv	s2,a0
    struct virtio_net_hdr *hdr = kalloc();
    80007324:	ffffa097          	auipc	ra,0xffffa
    80007328:	8e0080e7          	jalr	-1824(ra) # 80000c04 <kalloc>
    if (!rxbuf)
    8000732c:	12090763          	beqz	s2,8000745a <virtio_net_init+0x3fa>
    net.rxq.desc[rx_hdr_desc].addr = (uint64)hdr;
    80007330:	00499793          	slli	a5,s3,0x4
    80007334:	68b8                	ld	a4,80(s1)
    80007336:	973e                	add	a4,a4,a5
    80007338:	e308                	sd	a0,0(a4)
    net.rxq.desc[rx_hdr_desc].len = sizeof(struct virtio_net_hdr);
    8000733a:	68b8                	ld	a4,80(s1)
    8000733c:	973e                	add	a4,a4,a5
    8000733e:	01972423          	sw	s9,8(a4)
    net.rxq.desc[rx_hdr_desc].flags = VRING_DESC_F_NEXT;
    80007342:	68b8                	ld	a4,80(s1)
    80007344:	973e                	add	a4,a4,a5
    80007346:	01871623          	sh	s8,12(a4)
    net.rxq.desc[rx_hdr_desc].next = rx_desc;
    8000734a:	68b8                	ld	a4,80(s1)
    8000734c:	97ba                	add	a5,a5,a4
    8000734e:	01b79723          	sh	s11,14(a5) # 1000200e <_entry-0x6fffdff2>
    net.rxq.desc[rx_desc].addr = (uint64)rxbuf;
    80007352:	004d9793          	slli	a5,s11,0x4
    80007356:	68b8                	ld	a4,80(s1)
    80007358:	973e                	add	a4,a4,a5
    8000735a:	01273023          	sd	s2,0(a4)
    net.rxq.desc[rx_desc].len = PGSIZE;
    8000735e:	68b8                	ld	a4,80(s1)
    80007360:	973e                	add	a4,a4,a5
    80007362:	01772423          	sw	s7,8(a4)
    net.rxq.desc[rx_desc].flags = VRING_DESC_F_WRITE;
    80007366:	68b8                	ld	a4,80(s1)
    80007368:	97ba                	add	a5,a5,a4
    8000736a:	01679623          	sh	s6,12(a5)

    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = rx_hdr_desc;
    8000736e:	6cb8                	ld	a4,88(s1)
    80007370:	00275783          	lhu	a5,2(a4)
    80007374:	8b9d                	andi	a5,a5,7
    80007376:	0786                	slli	a5,a5,0x1
    80007378:	973e                	add	a4,a4,a5
    8000737a:	01371223          	sh	s3,4(a4)
    __sync_synchronize();
    8000737e:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    80007382:	6cb8                	ld	a4,88(s1)
    80007384:	00275783          	lhu	a5,2(a4)
    80007388:	2785                	addiw	a5,a5,1
    8000738a:	00f71123          	sh	a5,2(a4)
    __sync_synchronize();
    8000738e:	0330000f          	fence	rw,rw
  for (int i = 0; i < NUM / 2; i++) {
    80007392:	3a7d                	addiw	s4,s4,-1
    80007394:	f60a17e3          	bnez	s4,80007302 <virtio_net_init+0x2a2>
  }

  // queue is ready
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80007398:	100027b7          	lui	a5,0x10002
    8000739c:	4705                	li	a4,1
    8000739e:	c3f8                	sw	a4,68(a5)

  // Notify device
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_RX;
    800073a0:	0407a823          	sw	zero,80(a5) # 10002050 <_entry-0x6fffdfb0>

  // Done initializing
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800073a4:	004d6d13          	ori	s10,s10,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800073a8:	07a7a823          	sw	s10,112(a5)

  // initialize packet buffer
  packet_buf = kalloc();
    800073ac:	ffffa097          	auipc	ra,0xffffa
    800073b0:	858080e7          	jalr	-1960(ra) # 80000c04 <kalloc>
    800073b4:	00006797          	auipc	a5,0x6
    800073b8:	84a7ba23          	sd	a0,-1964(a5) # 8000cc08 <packet_buf>
}
    800073bc:	70a6                	ld	ra,104(sp)
    800073be:	7406                	ld	s0,96(sp)
    800073c0:	64e6                	ld	s1,88(sp)
    800073c2:	6946                	ld	s2,80(sp)
    800073c4:	69a6                	ld	s3,72(sp)
    800073c6:	6a06                	ld	s4,64(sp)
    800073c8:	7ae2                	ld	s5,56(sp)
    800073ca:	7b42                	ld	s6,48(sp)
    800073cc:	7ba2                	ld	s7,40(sp)
    800073ce:	7c02                	ld	s8,32(sp)
    800073d0:	6ce2                	ld	s9,24(sp)
    800073d2:	6d42                	ld	s10,16(sp)
    800073d4:	6da2                	ld	s11,8(sp)
    800073d6:	6165                	addi	sp,sp,112
    800073d8:	8082                	ret
    panic("could not find virtio net");
    800073da:	00002517          	auipc	a0,0x2
    800073de:	44e50513          	addi	a0,a0,1102 # 80009828 <etext+0x828>
    800073e2:	ffff9097          	auipc	ra,0xffff9
    800073e6:	17e080e7          	jalr	382(ra) # 80000560 <panic>
    panic("virtio net FEATURES_OK unset");
    800073ea:	00002517          	auipc	a0,0x2
    800073ee:	45e50513          	addi	a0,a0,1118 # 80009848 <etext+0x848>
    800073f2:	ffff9097          	auipc	ra,0xffff9
    800073f6:	16e080e7          	jalr	366(ra) # 80000560 <panic>
    panic("virtio net has no queue 1 (QUEUE_TX)");
    800073fa:	00002517          	auipc	a0,0x2
    800073fe:	46e50513          	addi	a0,a0,1134 # 80009868 <etext+0x868>
    80007402:	ffff9097          	auipc	ra,0xffff9
    80007406:	15e080e7          	jalr	350(ra) # 80000560 <panic>
    panic("virtio net max queue too short");
    8000740a:	00002517          	auipc	a0,0x2
    8000740e:	48650513          	addi	a0,a0,1158 # 80009890 <etext+0x890>
    80007412:	ffff9097          	auipc	ra,0xffff9
    80007416:	14e080e7          	jalr	334(ra) # 80000560 <panic>
    panic("QUEUE_TX should not be ready\n");
    8000741a:	00002517          	auipc	a0,0x2
    8000741e:	49650513          	addi	a0,a0,1174 # 800098b0 <etext+0x8b0>
    80007422:	ffff9097          	auipc	ra,0xffff9
    80007426:	13e080e7          	jalr	318(ra) # 80000560 <panic>
    panic("virtio net alloc\n");
    8000742a:	00002517          	auipc	a0,0x2
    8000742e:	4a650513          	addi	a0,a0,1190 # 800098d0 <etext+0x8d0>
    80007432:	ffff9097          	auipc	ra,0xffff9
    80007436:	12e080e7          	jalr	302(ra) # 80000560 <panic>
    panic("QUEUE_RX should not be ready\n");
    8000743a:	00002517          	auipc	a0,0x2
    8000743e:	4ae50513          	addi	a0,a0,1198 # 800098e8 <etext+0x8e8>
    80007442:	ffff9097          	auipc	ra,0xffff9
    80007446:	11e080e7          	jalr	286(ra) # 80000560 <panic>
    panic("virtio net alloc");
    8000744a:	00002517          	auipc	a0,0x2
    8000744e:	4be50513          	addi	a0,a0,1214 # 80009908 <etext+0x908>
    80007452:	ffff9097          	auipc	ra,0xffff9
    80007456:	10e080e7          	jalr	270(ra) # 80000560 <panic>
      panic("rxbuf alloc failed");
    8000745a:	00002517          	auipc	a0,0x2
    8000745e:	4c650513          	addi	a0,a0,1222 # 80009920 <etext+0x920>
    80007462:	ffff9097          	auipc	ra,0xffff9
    80007466:	0fe080e7          	jalr	254(ra) # 80000560 <panic>

000000008000746a <apply_padding>:
 *      return 0 on success
 *      return 1 when the number of bytes calculated does not make sense
 */
int apply_padding(uint8 num_bytes) {
  uint8 *pkt_ptr =
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    8000746a:	04a00693          	li	a3,74
    8000746e:	9e89                	subw	a3,a3,a0
  if (num_bytes > 64 - sizeof(struct virtio_net_hdr) || num_bytes < 1) {
    80007470:	fff5079b          	addiw	a5,a0,-1
    80007474:	0ff7f793          	zext.b	a5,a5
    80007478:	03500713          	li	a4,53
    8000747c:	02f76563          	bltu	a4,a5,800074a6 <apply_padding+0x3c>
      packet_buf + sizeof(struct virtio_net_hdr) + (64 - num_bytes);
    80007480:	00005717          	auipc	a4,0x5
    80007484:	78873703          	ld	a4,1928(a4) # 8000cc08 <packet_buf>
    80007488:	00d707b3          	add	a5,a4,a3
    8000748c:	0705                	addi	a4,a4,1
    8000748e:	9736                	add	a4,a4,a3
    80007490:	357d                	addiw	a0,a0,-1
    80007492:	1502                	slli	a0,a0,0x20
    80007494:	9101                	srli	a0,a0,0x20
    80007496:	972a                	add	a4,a4,a0
    printf("malformed packet data");
    return 1;
  }
  for (int i = 0; i < num_bytes; i++) {
    pkt_ptr[i] = 0;
    80007498:	00078023          	sb	zero,0(a5)
  for (int i = 0; i < num_bytes; i++) {
    8000749c:	0785                	addi	a5,a5,1
    8000749e:	fee79de3          	bne	a5,a4,80007498 <apply_padding+0x2e>
  }
  return 0;
    800074a2:	4501                	li	a0,0
}
    800074a4:	8082                	ret
int apply_padding(uint8 num_bytes) {
    800074a6:	1141                	addi	sp,sp,-16
    800074a8:	e406                	sd	ra,8(sp)
    800074aa:	e022                	sd	s0,0(sp)
    800074ac:	0800                	addi	s0,sp,16
    printf("malformed packet data");
    800074ae:	00002517          	auipc	a0,0x2
    800074b2:	48a50513          	addi	a0,a0,1162 # 80009938 <etext+0x938>
    800074b6:	ffff9097          	auipc	ra,0xffff9
    800074ba:	0f4080e7          	jalr	244(ra) # 800005aa <printf>
    return 1;
    800074be:	4505                	li	a0,1
}
    800074c0:	60a2                	ld	ra,8(sp)
    800074c2:	6402                	ld	s0,0(sp)
    800074c4:	0141                	addi	sp,sp,16
    800074c6:	8082                	ret

00000000800074c8 <transmit_packet>:
 *                     of the data is 1500 (defined by the ethernet protocol)
 *
 * Output: There is no return value from the function, but the packet frame
 *         is given to the NIC to be transmitted.
 */
void transmit_packet(void *pkt_data, uint16 pkt_len, uint16 protocol) {
    800074c8:	711d                	addi	sp,sp,-96
    800074ca:	ec86                	sd	ra,88(sp)
    800074cc:	e8a2                	sd	s0,80(sp)
    800074ce:	e4a6                	sd	s1,72(sp)
    800074d0:	e0ca                	sd	s2,64(sp)
    800074d2:	fc4e                	sd	s3,56(sp)
    800074d4:	f852                	sd	s4,48(sp)
    800074d6:	f456                	sd	s5,40(sp)
    800074d8:	f05a                	sd	s6,32(sp)
    800074da:	ec5e                	sd	s7,24(sp)
    800074dc:	e862                	sd	s8,16(sp)
    800074de:	e466                	sd	s9,8(sp)
    800074e0:	1080                	addi	s0,sp,96
    800074e2:	8caa                	mv	s9,a0
    800074e4:	8aae                	mv	s5,a1
    800074e6:	84b2                	mv	s1,a2
  /* Create the header for transmission */
  acquire(&net.vnet_lock);
    800074e8:	00067517          	auipc	a0,0x67
    800074ec:	da850513          	addi	a0,a0,-600 # 8006e290 <net+0x10>
    800074f0:	ffffa097          	auipc	ra,0xffffa
    800074f4:	826080e7          	jalr	-2010(ra) # 80000d16 <acquire>
  *R(VIRTIO_MMIO_QUEUE_SEL) = QUEUE_TX;
    800074f8:	100027b7          	lui	a5,0x10002
    800074fc:	4705                	li	a4,1
    800074fe:	db98                	sw	a4,48(a5)
  // allocate for packet header and packet_frame
  struct virtio_net_hdr *hdr = kalloc();
    80007500:	ffff9097          	auipc	ra,0xffff9
    80007504:	704080e7          	jalr	1796(ra) # 80000c04 <kalloc>
  if (hdr == 0)
    80007508:	1c050d63          	beqz	a0,800076e2 <transmit_packet+0x21a>
    8000750c:	8baa                	mv	s7,a0
    panic("failed to allocate header\n");
  // initialize the header and packet
  memset(hdr, 0, PGSIZE);
    8000750e:	6605                	lui	a2,0x1
    80007510:	4581                	li	a1,0
    80007512:	ffffa097          	auipc	ra,0xffffa
    80007516:	8fc080e7          	jalr	-1796(ra) # 80000e0e <memset>

  int hdr_desc = alloc_desc(&net.txq);
    8000751a:	00067a17          	auipc	s4,0x67
    8000751e:	d66a0a13          	addi	s4,s4,-666 # 8006e280 <net>
    80007522:	00067997          	auipc	s3,0x67
    80007526:	d8698993          	addi	s3,s3,-634 # 8006e2a8 <net+0x28>
    8000752a:	854e                	mv	a0,s3
    8000752c:	00000097          	auipc	ra,0x0
    80007530:	a9e080e7          	jalr	-1378(ra) # 80006fca <alloc_desc>
    80007534:	892a                	mv	s2,a0
  int pkt_desc = alloc_desc(&net.txq);
    80007536:	854e                	mv	a0,s3
    80007538:	00000097          	auipc	ra,0x0
    8000753c:	a92080e7          	jalr	-1390(ra) # 80006fca <alloc_desc>
    80007540:	89aa                	mv	s3,a0

  hdr->flags = 0;
    80007542:	000b8023          	sb	zero,0(s7) # 1000 <_entry-0x7ffff000>
  hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
    80007546:	000b80a3          	sb	zero,1(s7)
  hdr->hdr_len = 0;
    8000754a:	000b9123          	sh	zero,2(s7)

  memmove(packet_buf, "\xe2\x71\xad\xf4\x7b\xff", 6);
    8000754e:	00005b17          	auipc	s6,0x5
    80007552:	6bab0b13          	addi	s6,s6,1722 # 8000cc08 <packet_buf>
    80007556:	4619                	li	a2,6
    80007558:	00002597          	auipc	a1,0x2
    8000755c:	41858593          	addi	a1,a1,1048 # 80009970 <etext+0x970>
    80007560:	000b3503          	ld	a0,0(s6)
    80007564:	ffffa097          	auipc	ra,0xffffa
    80007568:	90e080e7          	jalr	-1778(ra) # 80000e72 <memmove>
  memmove(packet_buf + 6, net.cfg.mac, 6);
    8000756c:	000b3503          	ld	a0,0(s6)
    80007570:	4619                	li	a2,6
    80007572:	85d2                	mv	a1,s4
    80007574:	9532                	add	a0,a0,a2
    80007576:	ffffa097          	auipc	ra,0xffffa
    8000757a:	8fc080e7          	jalr	-1796(ra) # 80000e72 <memmove>

  packet_buf[12] = (protocol >> 8);
    8000757e:	000b3503          	ld	a0,0(s6)
    80007582:	0084d71b          	srliw	a4,s1,0x8
    80007586:	00e50623          	sb	a4,12(a0)
  packet_buf[13] = (protocol & 0xF);
    8000758a:	88bd                	andi	s1,s1,15
    8000758c:	009506a3          	sb	s1,13(a0)

  memmove(packet_buf + 14, pkt_data, pkt_len);
    80007590:	000a8c1b          	sext.w	s8,s5
    80007594:	8662                	mv	a2,s8
    80007596:	85e6                	mv	a1,s9
    80007598:	0539                	addi	a0,a0,14
    8000759a:	ffffa097          	auipc	ra,0xffffa
    8000759e:	8d8080e7          	jalr	-1832(ra) # 80000e72 <memmove>

  net.txq.desc[hdr_desc].flags |=
    800075a2:	00491793          	slli	a5,s2,0x4
    800075a6:	028a3703          	ld	a4,40(s4)
    800075aa:	973e                	add	a4,a4,a5
    800075ac:	00c75683          	lhu	a3,12(a4)
    800075b0:	0016e693          	ori	a3,a3,1
    800075b4:	00d71623          	sh	a3,12(a4)
      VRING_DESC_F_NEXT; // This tells the device it's a chain
  net.txq.desc[hdr_desc].len = HDR_SIZE;
    800075b8:	028a3703          	ld	a4,40(s4)
    800075bc:	973e                	add	a4,a4,a5
    800075be:	46a9                	li	a3,10
    800075c0:	c714                	sw	a3,8(a4)
  net.txq.desc[hdr_desc].addr = (uint64)hdr;
    800075c2:	028a3703          	ld	a4,40(s4)
    800075c6:	973e                	add	a4,a4,a5
    800075c8:	01773023          	sd	s7,0(a4)
  net.txq.desc[hdr_desc].next = pkt_desc;
    800075cc:	028a3703          	ld	a4,40(s4)
    800075d0:	97ba                	add	a5,a5,a4
    800075d2:	01379723          	sh	s3,14(a5) # 1000200e <_entry-0x6fffdff2>

  net.txq.desc[pkt_desc].len = 14 + pkt_len;
    800075d6:	0992                	slli	s3,s3,0x4
    800075d8:	028a3783          	ld	a5,40(s4)
    800075dc:	97ce                	add	a5,a5,s3
    800075de:	00ea871b          	addiw	a4,s5,14
    800075e2:	c798                	sw	a4,8(a5)
  net.txq.desc[pkt_desc].addr = (uint64)packet_buf;
    800075e4:	028a3783          	ld	a5,40(s4)
    800075e8:	97ce                	add	a5,a5,s3
    800075ea:	000b3703          	ld	a4,0(s6)
    800075ee:	e398                	sd	a4,0(a5)
  net.txq.desc[pkt_desc].flags = 0;
    800075f0:	028a3783          	ld	a5,40(s4)
    800075f4:	97ce                	add	a5,a5,s3
    800075f6:	00079623          	sh	zero,12(a5)

  if (pkt_len < 64) {
    800075fa:	03f00793          	li	a5,63
    800075fe:	0387e563          	bltu	a5,s8,80007628 <transmit_packet+0x160>
    int res = apply_padding(64 - pkt_len);
    80007602:	04000513          	li	a0,64
    80007606:	4155053b          	subw	a0,a0,s5
    8000760a:	0ff57513          	zext.b	a0,a0
    8000760e:	00000097          	auipc	ra,0x0
    80007612:	e5c080e7          	jalr	-420(ra) # 8000746a <apply_padding>
    net.txq.desc[pkt_desc].len = 64;
    80007616:	00067797          	auipc	a5,0x67
    8000761a:	c927b783          	ld	a5,-878(a5) # 8006e2a8 <net+0x28>
    8000761e:	97ce                	add	a5,a5,s3
    80007620:	04000713          	li	a4,64
    80007624:	c798                	sw	a4,8(a5)
    if (res != 0)
    80007626:	e571                	bnez	a0,800076f2 <transmit_packet+0x22a>
      panic("failed to apply padding");
  }

  // Tell the device first index in chain of descriptors
  net.txq.driver_area->ring[net.txq.driver_area->idx % NUM] = hdr_desc;
    80007628:	00067997          	auipc	s3,0x67
    8000762c:	c5898993          	addi	s3,s3,-936 # 8006e280 <net>
    80007630:	0309b703          	ld	a4,48(s3)
    80007634:	00275783          	lhu	a5,2(a4)
    80007638:	8b9d                	andi	a5,a5,7
    8000763a:	0786                	slli	a5,a5,0x1
    8000763c:	973e                	add	a4,a4,a5
    8000763e:	01271223          	sh	s2,4(a4)
  __sync_synchronize();
    80007642:	0330000f          	fence	rw,rw
  // Tell the device another avail ring entry is available
  net.txq.driver_area->idx++;
    80007646:	0309b703          	ld	a4,48(s3)
    8000764a:	00275783          	lhu	a5,2(a4)
    8000764e:	2785                	addiw	a5,a5,1
    80007650:	00f71123          	sh	a5,2(a4)
  __sync_synchronize();
    80007654:	0330000f          	fence	rw,rw

  uint16 prev_used_idx = net.txq.device_area->idx;
    80007658:	0389b783          	ld	a5,56(s3)
    8000765c:	0027d483          	lhu	s1,2(a5)
  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = QUEUE_TX;
    80007660:	100027b7          	lui	a5,0x10002
    80007664:	4705                	li	a4,1
    80007666:	cbb8                	sw	a4,80(a5)
  release(&net.vnet_lock);
    80007668:	00067517          	auipc	a0,0x67
    8000766c:	c2850513          	addi	a0,a0,-984 # 8006e290 <net+0x10>
    80007670:	ffff9097          	auipc	ra,0xffff9
    80007674:	756080e7          	jalr	1878(ra) # 80000dc6 <release>

  // Wait for the device to use the descriptor. It indicates this by
  // decrementing the index. Polling helps to avoid race conditions
  while (net.txq.device_area->idx == prev_used_idx) {
    80007678:	0389b783          	ld	a5,56(s3)
    8000767c:	0027d783          	lhu	a5,2(a5) # 10002002 <_entry-0x6fffdffe>
    80007680:	00979c63          	bne	a5,s1,80007698 <transmit_packet+0x1d0>
    80007684:	86ce                	mv	a3,s3
    80007686:	0004871b          	sext.w	a4,s1
    __sync_synchronize();
    8000768a:	0330000f          	fence	rw,rw
  while (net.txq.device_area->idx == prev_used_idx) {
    8000768e:	7e9c                	ld	a5,56(a3)
    80007690:	0027d783          	lhu	a5,2(a5)
    80007694:	fee78be3          	beq	a5,a4,8000768a <transmit_packet+0x1c2>
  }
  printf("mac: %x:%x:%x:%x:%x:%x\n", net.cfg.mac[0], net.cfg.mac[1],
         net.cfg.mac[2], net.cfg.mac[3], net.cfg.mac[4], net.cfg.mac[5]);
    80007698:	00067597          	auipc	a1,0x67
    8000769c:	be858593          	addi	a1,a1,-1048 # 8006e280 <net>
  printf("mac: %x:%x:%x:%x:%x:%x\n", net.cfg.mac[0], net.cfg.mac[1],
    800076a0:	0055c803          	lbu	a6,5(a1)
    800076a4:	0045c783          	lbu	a5,4(a1)
    800076a8:	0035c703          	lbu	a4,3(a1)
    800076ac:	0025c683          	lbu	a3,2(a1)
    800076b0:	0015c603          	lbu	a2,1(a1)
    800076b4:	0005c583          	lbu	a1,0(a1)
    800076b8:	00002517          	auipc	a0,0x2
    800076bc:	2d850513          	addi	a0,a0,728 # 80009990 <etext+0x990>
    800076c0:	ffff9097          	auipc	ra,0xffff9
    800076c4:	eea080e7          	jalr	-278(ra) # 800005aa <printf>
}
    800076c8:	60e6                	ld	ra,88(sp)
    800076ca:	6446                	ld	s0,80(sp)
    800076cc:	64a6                	ld	s1,72(sp)
    800076ce:	6906                	ld	s2,64(sp)
    800076d0:	79e2                	ld	s3,56(sp)
    800076d2:	7a42                	ld	s4,48(sp)
    800076d4:	7aa2                	ld	s5,40(sp)
    800076d6:	7b02                	ld	s6,32(sp)
    800076d8:	6be2                	ld	s7,24(sp)
    800076da:	6c42                	ld	s8,16(sp)
    800076dc:	6ca2                	ld	s9,8(sp)
    800076de:	6125                	addi	sp,sp,96
    800076e0:	8082                	ret
    panic("failed to allocate header\n");
    800076e2:	00002517          	auipc	a0,0x2
    800076e6:	26e50513          	addi	a0,a0,622 # 80009950 <etext+0x950>
    800076ea:	ffff9097          	auipc	ra,0xffff9
    800076ee:	e76080e7          	jalr	-394(ra) # 80000560 <panic>
      panic("failed to apply padding");
    800076f2:	00002517          	auipc	a0,0x2
    800076f6:	28650513          	addi	a0,a0,646 # 80009978 <etext+0x978>
    800076fa:	ffff9097          	auipc	ra,0xffff9
    800076fe:	e66080e7          	jalr	-410(ra) # 80000560 <panic>

0000000080007702 <receive_packet>:

uint16 receive_packet(void *pkt_buf, uint16 num_bytes) {
    80007702:	1101                	addi	sp,sp,-32
    80007704:	ec06                	sd	ra,24(sp)
    80007706:	e822                	sd	s0,16(sp)
    80007708:	e426                	sd	s1,8(sp)
    8000770a:	1000                	addi	s0,sp,32
  acquire(&net.vnet_lock);
    8000770c:	00067497          	auipc	s1,0x67
    80007710:	b7448493          	addi	s1,s1,-1164 # 8006e280 <net>
    80007714:	00067517          	auipc	a0,0x67
    80007718:	b7c50513          	addi	a0,a0,-1156 # 8006e290 <net+0x10>
    8000771c:	ffff9097          	auipc	ra,0xffff9
    80007720:	5fa080e7          	jalr	1530(ra) # 80000d16 <acquire>
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    80007724:	58fc                	lw	a5,116(s1)
    80007726:	70b4                	ld	a3,96(s1)
    80007728:	0026d703          	lhu	a4,2(a3)
    8000772c:	04f70663          	beq	a4,a5,80007778 <receive_packet+0x76>
    // for (int i = 0; i < len; i++) {
    //   printf("%x", packet[i]);
    // }

    // Requeue the buffer
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    80007730:	8626                	mv	a2,s1
    80007732:	6e2c                	ld	a1,88(a2)
    80007734:	0025d703          	lhu	a4,2(a1)
    80007738:	8b1d                	andi	a4,a4,7
    8000773a:	0706                	slli	a4,a4,0x1
    8000773c:	95ba                	add	a1,a1,a4
    int id = net.rxq.device_area->ring[net.rxq.used_idx % NUM].id;
    8000773e:	41f7d71b          	sraiw	a4,a5,0x1f
    80007742:	01d7571b          	srliw	a4,a4,0x1d
    80007746:	9fb9                	addw	a5,a5,a4
    80007748:	8b9d                	andi	a5,a5,7
    8000774a:	9f99                	subw	a5,a5,a4
    8000774c:	078e                	slli	a5,a5,0x3
    8000774e:	96be                	add	a3,a3,a5
    net.rxq.driver_area->ring[net.rxq.driver_area->idx % NUM] = id;
    80007750:	42dc                	lw	a5,4(a3)
    80007752:	00f59223          	sh	a5,4(a1)
    __sync_synchronize();
    80007756:	0330000f          	fence	rw,rw
    net.rxq.driver_area->idx++;
    8000775a:	6e38                	ld	a4,88(a2)
    8000775c:	00275783          	lhu	a5,2(a4)
    80007760:	2785                	addiw	a5,a5,1
    80007762:	00f71123          	sh	a5,2(a4)
    net.rxq.used_idx++;
    80007766:	5a78                	lw	a4,116(a2)
    80007768:	2705                	addiw	a4,a4,1
    8000776a:	87ba                	mv	a5,a4
    8000776c:	da78                	sw	a4,116(a2)
  while (net.rxq.used_idx != net.rxq.device_area->idx) {
    8000776e:	7234                	ld	a3,96(a2)
    80007770:	0026d703          	lhu	a4,2(a3)
    80007774:	faf71fe3          	bne	a4,a5,80007732 <receive_packet+0x30>
  }
  release(&net.vnet_lock);
    80007778:	00067517          	auipc	a0,0x67
    8000777c:	b1850513          	addi	a0,a0,-1256 # 8006e290 <net+0x10>
    80007780:	ffff9097          	auipc	ra,0xffff9
    80007784:	646080e7          	jalr	1606(ra) # 80000dc6 <release>
  return 0;
}
    80007788:	4501                	li	a0,0
    8000778a:	60e2                	ld	ra,24(sp)
    8000778c:	6442                	ld	s0,16(sp)
    8000778e:	64a2                	ld	s1,8(sp)
    80007790:	6105                	addi	sp,sp,32
    80007792:	8082                	ret

0000000080007794 <socket>:
  int capacity;
};

int 
socket(int address_family, int address_socktype, int protocol)
{
    80007794:	1141                	addi	sp,sp,-16
    80007796:	e406                	sd	ra,8(sp)
    80007798:	e022                	sd	s0,0(sp)
    8000779a:	0800                	addi	s0,sp,16
  return 0;
}
    8000779c:	4501                	li	a0,0
    8000779e:	60a2                	ld	ra,8(sp)
    800077a0:	6402                	ld	s0,0(sp)
    800077a2:	0141                	addi	sp,sp,16
    800077a4:	8082                	ret

00000000800077a6 <bind>:

int
bind(int socket, const struct sockaddr *sock_address, socklen_t address_len)
{
    800077a6:	1141                	addi	sp,sp,-16
    800077a8:	e406                	sd	ra,8(sp)
    800077aa:	e022                	sd	s0,0(sp)
    800077ac:	0800                	addi	s0,sp,16
  return 0;
}
    800077ae:	4501                	li	a0,0
    800077b0:	60a2                	ld	ra,8(sp)
    800077b2:	6402                	ld	s0,0(sp)
    800077b4:	0141                	addi	sp,sp,16
    800077b6:	8082                	ret

00000000800077b8 <listen>:

int
listen(int socket, int backlog)
{
    800077b8:	1141                	addi	sp,sp,-16
    800077ba:	e406                	sd	ra,8(sp)
    800077bc:	e022                	sd	s0,0(sp)
    800077be:	0800                	addi	s0,sp,16
  return 0;
}
    800077c0:	4501                	li	a0,0
    800077c2:	60a2                	ld	ra,8(sp)
    800077c4:	6402                	ld	s0,0(sp)
    800077c6:	0141                	addi	sp,sp,16
    800077c8:	8082                	ret

00000000800077ca <accept>:

int
accept(int socket, struct sockaddr *address, socklen_t address_len)
{
    800077ca:	1141                	addi	sp,sp,-16
    800077cc:	e406                	sd	ra,8(sp)
    800077ce:	e022                	sd	s0,0(sp)
    800077d0:	0800                	addi	s0,sp,16
  return 0;
}
    800077d2:	4501                	li	a0,0
    800077d4:	60a2                	ld	ra,8(sp)
    800077d6:	6402                	ld	s0,0(sp)
    800077d8:	0141                	addi	sp,sp,16
    800077da:	8082                	ret

00000000800077dc <connect>:

int
connect(int socket, const struct sockaddr *address, socklen_t address_len)
{
    800077dc:	1141                	addi	sp,sp,-16
    800077de:	e406                	sd	ra,8(sp)
    800077e0:	e022                	sd	s0,0(sp)
    800077e2:	0800                	addi	s0,sp,16
  return 0;
}
    800077e4:	4501                	li	a0,0
    800077e6:	60a2                	ld	ra,8(sp)
    800077e8:	6402                	ld	s0,0(sp)
    800077ea:	0141                	addi	sp,sp,16
    800077ec:	8082                	ret

00000000800077ee <socket_list_expand>:

int socket_list_expand() {
    800077ee:	1141                	addi	sp,sp,-16
    800077f0:	e406                	sd	ra,8(sp)
    800077f2:	e022                	sd	s0,0(sp)
    800077f4:	0800                	addi	s0,sp,16
  // sock_list->capacity = sock_list_capacity*2;
  // if ()
  return 0;
}
    800077f6:	4501                	li	a0,0
    800077f8:	60a2                	ld	ra,8(sp)
    800077fa:	6402                	ld	s0,0(sp)
    800077fc:	0141                	addi	sp,sp,16
    800077fe:	8082                	ret

0000000080007800 <socket_list_init>:

struct socket_list* socket_list_init() {
    80007800:	1101                	addi	sp,sp,-32
    80007802:	ec06                	sd	ra,24(sp)
    80007804:	e822                	sd	s0,16(sp)
    80007806:	e426                	sd	s1,8(sp)
    80007808:	1000                	addi	s0,sp,32
  struct socket_list *list = (struct socket_list *)kalloc();
    8000780a:	ffff9097          	auipc	ra,0xffff9
    8000780e:	3fa080e7          	jalr	1018(ra) # 80000c04 <kalloc>
    80007812:	84aa                	mv	s1,a0
  if (!list)
    80007814:	c919                	beqz	a0,8000782a <socket_list_init+0x2a>
    return 0;

  list->socks = (struct socket **)kalloc();
    80007816:	ffff9097          	auipc	ra,0xffff9
    8000781a:	3ee080e7          	jalr	1006(ra) # 80000c04 <kalloc>
    8000781e:	e088                	sd	a0,0(s1)
  if (!list->socks)
    80007820:	c919                	beqz	a0,80007836 <socket_list_init+0x36>
    return 0;

  list->capacity = 16;
    80007822:	47c1                	li	a5,16
    80007824:	c4dc                	sw	a5,12(s1)
  list->size = 0;
    80007826:	0004a423          	sw	zero,8(s1)
  return list;
}
    8000782a:	8526                	mv	a0,s1
    8000782c:	60e2                	ld	ra,24(sp)
    8000782e:	6442                	ld	s0,16(sp)
    80007830:	64a2                	ld	s1,8(sp)
    80007832:	6105                	addi	sp,sp,32
    80007834:	8082                	ret
    return 0;
    80007836:	84aa                	mv	s1,a0
    80007838:	bfcd                	j	8000782a <socket_list_init+0x2a>
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
