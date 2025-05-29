
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	93013103          	ld	sp,-1744(sp) # 80008930 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

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
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
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
    80000050:	00009717          	auipc	a4,0x9
    80000054:	94070713          	addi	a4,a4,-1728 # 80008990 <timer_scratch>
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
    80000062:	00006797          	auipc	a5,0x6
    80000066:	48e78793          	addi	a5,a5,1166 # 800064f0 <timervec>
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
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff947ff>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	ea278793          	addi	a5,a5,-350 # 80000f4e <main>
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
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
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
    8000012e:	bbe080e7          	jalr	-1090(ra) # 80002ce8 <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	784080e7          	jalr	1924(ra) # 800008be <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	94650513          	addi	a0,a0,-1722 # 80010ad0 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	b1a080e7          	jalr	-1254(ra) # 80000cac <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	93648493          	addi	s1,s1,-1738 # 80010ad0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	9c690913          	addi	s2,s2,-1594 # 80010b68 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	b48080e7          	jalr	-1208(ra) # 80001d08 <myproc>
    800001c8:	00003097          	auipc	ra,0x3
    800001cc:	828080e7          	jalr	-2008(ra) # 800029f0 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	3de080e7          	jalr	990(ra) # 800025b4 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00003097          	auipc	ra,0x3
    80000216:	a80080e7          	jalr	-1408(ra) # 80002c92 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	8aa50513          	addi	a0,a0,-1878 # 80010ad0 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	b32080e7          	jalr	-1230(ra) # 80000d60 <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	89450513          	addi	a0,a0,-1900 # 80010ad0 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	b1c080e7          	jalr	-1252(ra) # 80000d60 <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	8ef72b23          	sw	a5,-1802(a4) # 80010b68 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	560080e7          	jalr	1376(ra) # 800007ec <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54e080e7          	jalr	1358(ra) # 800007ec <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	542080e7          	jalr	1346(ra) # 800007ec <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	538080e7          	jalr	1336(ra) # 800007ec <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00011517          	auipc	a0,0x11
    800002d0:	80450513          	addi	a0,a0,-2044 # 80010ad0 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	9d8080e7          	jalr	-1576(ra) # 80000cac <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00003097          	auipc	ra,0x3
    800002f6:	a4c080e7          	jalr	-1460(ra) # 80002d3e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	7d650513          	addi	a0,a0,2006 # 80010ad0 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	a5e080e7          	jalr	-1442(ra) # 80000d60 <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	7b270713          	addi	a4,a4,1970 # 80010ad0 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	78878793          	addi	a5,a5,1928 # 80010ad0 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7f27a783          	lw	a5,2034(a5) # 80010b68 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	74670713          	addi	a4,a4,1862 # 80010ad0 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	73648493          	addi	s1,s1,1846 # 80010ad0 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	6fa70713          	addi	a4,a4,1786 # 80010ad0 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	78f72223          	sw	a5,1924(a4) # 80010b70 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	6be78793          	addi	a5,a5,1726 # 80010ad0 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	72c7ab23          	sw	a2,1846(a5) # 80010b6c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	72a50513          	addi	a0,a0,1834 # 80010b68 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	1d2080e7          	jalr	466(ra) # 80002618 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	67050513          	addi	a0,a0,1648 # 80010ad0 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	7b4080e7          	jalr	1972(ra) # 80000c1c <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32c080e7          	jalr	812(ra) # 8000079c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00069797          	auipc	a5,0x69
    8000047c:	9f078793          	addi	a5,a5,-1552 # 80068e68 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7670713          	addi	a4,a4,-906 # 80000100 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054763          	bltz	a0,80000538 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	b8660613          	addi	a2,a2,-1146 # 80008040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088c63          	beqz	a7,800004fe <printint+0x62>
    buf[i++] = '-';
    800004ea:	fe070793          	addi	a5,a4,-32
    800004ee:	00878733          	add	a4,a5,s0
    800004f2:	02d00793          	li	a5,45
    800004f6:	fef70823          	sb	a5,-16(a4)
    800004fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fe:	02e05763          	blez	a4,8000052c <printint+0x90>
    80000502:	fd040793          	addi	a5,s0,-48
    80000506:	00e784b3          	add	s1,a5,a4
    8000050a:	fff78913          	addi	s2,a5,-1
    8000050e:	993a                	add	s2,s2,a4
    80000510:	377d                	addiw	a4,a4,-1
    80000512:	1702                	slli	a4,a4,0x20
    80000514:	9301                	srli	a4,a4,0x20
    80000516:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051a:	fff4c503          	lbu	a0,-1(s1)
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	d5e080e7          	jalr	-674(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000526:	14fd                	addi	s1,s1,-1
    80000528:	ff2499e3          	bne	s1,s2,8000051a <printint+0x7e>
}
    8000052c:	70a2                	ld	ra,40(sp)
    8000052e:	7402                	ld	s0,32(sp)
    80000530:	64e2                	ld	s1,24(sp)
    80000532:	6942                	ld	s2,16(sp)
    80000534:	6145                	addi	sp,sp,48
    80000536:	8082                	ret
    x = -xx;
    80000538:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053c:	4885                	li	a7,1
    x = -xx;
    8000053e:	bf95                	j	800004b2 <printint+0x16>

0000000080000540 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000540:	1101                	addi	sp,sp,-32
    80000542:	ec06                	sd	ra,24(sp)
    80000544:	e822                	sd	s0,16(sp)
    80000546:	e426                	sd	s1,8(sp)
    80000548:	1000                	addi	s0,sp,32
    8000054a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054c:	00010797          	auipc	a5,0x10
    80000550:	6407a223          	sw	zero,1604(a5) # 80010b90 <pr+0x18>
  printf("panic: ");
    80000554:	00008517          	auipc	a0,0x8
    80000558:	ac450513          	addi	a0,a0,-1340 # 80008018 <etext+0x18>
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	02e080e7          	jalr	46(ra) # 8000058a <printf>
  printf(s);
    80000564:	8526                	mv	a0,s1
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	024080e7          	jalr	36(ra) # 8000058a <printf>
  printf("\n");
    8000056e:	00008517          	auipc	a0,0x8
    80000572:	b5a50513          	addi	a0,a0,-1190 # 800080c8 <digits+0x88>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	014080e7          	jalr	20(ra) # 8000058a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057e:	4785                	li	a5,1
    80000580:	00008717          	auipc	a4,0x8
    80000584:	3cf72823          	sw	a5,976(a4) # 80008950 <panicked>
  for(;;)
    80000588:	a001                	j	80000588 <panic+0x48>

000000008000058a <printf>:
{
    8000058a:	7131                	addi	sp,sp,-192
    8000058c:	fc86                	sd	ra,120(sp)
    8000058e:	f8a2                	sd	s0,112(sp)
    80000590:	f4a6                	sd	s1,104(sp)
    80000592:	f0ca                	sd	s2,96(sp)
    80000594:	ecce                	sd	s3,88(sp)
    80000596:	e8d2                	sd	s4,80(sp)
    80000598:	e4d6                	sd	s5,72(sp)
    8000059a:	e0da                	sd	s6,64(sp)
    8000059c:	fc5e                	sd	s7,56(sp)
    8000059e:	f862                	sd	s8,48(sp)
    800005a0:	f466                	sd	s9,40(sp)
    800005a2:	f06a                	sd	s10,32(sp)
    800005a4:	ec6e                	sd	s11,24(sp)
    800005a6:	0100                	addi	s0,sp,128
    800005a8:	8a2a                	mv	s4,a0
    800005aa:	e40c                	sd	a1,8(s0)
    800005ac:	e810                	sd	a2,16(s0)
    800005ae:	ec14                	sd	a3,24(s0)
    800005b0:	f018                	sd	a4,32(s0)
    800005b2:	f41c                	sd	a5,40(s0)
    800005b4:	03043823          	sd	a6,48(s0)
    800005b8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005bc:	00010d97          	auipc	s11,0x10
    800005c0:	5d4dad83          	lw	s11,1492(s11) # 80010b90 <pr+0x18>
  if(locking)
    800005c4:	020d9b63          	bnez	s11,800005fa <printf+0x70>
  if (fmt == 0)
    800005c8:	040a0263          	beqz	s4,8000060c <printf+0x82>
  va_start(ap, fmt);
    800005cc:	00840793          	addi	a5,s0,8
    800005d0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d4:	000a4503          	lbu	a0,0(s4)
    800005d8:	14050f63          	beqz	a0,80000736 <printf+0x1ac>
    800005dc:	4981                	li	s3,0
    if(c != '%'){
    800005de:	02500a93          	li	s5,37
    switch(c){
    800005e2:	07000b93          	li	s7,112
  consputc('x');
    800005e6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e8:	00008b17          	auipc	s6,0x8
    800005ec:	a58b0b13          	addi	s6,s6,-1448 # 80008040 <digits>
    switch(c){
    800005f0:	07300c93          	li	s9,115
    800005f4:	06400c13          	li	s8,100
    800005f8:	a82d                	j	80000632 <printf+0xa8>
    acquire(&pr.lock);
    800005fa:	00010517          	auipc	a0,0x10
    800005fe:	57e50513          	addi	a0,a0,1406 # 80010b78 <pr>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	6aa080e7          	jalr	1706(ra) # 80000cac <acquire>
    8000060a:	bf7d                	j	800005c8 <printf+0x3e>
    panic("null fmt");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a1c50513          	addi	a0,a0,-1508 # 80008028 <etext+0x28>
    80000614:	00000097          	auipc	ra,0x0
    80000618:	f2c080e7          	jalr	-212(ra) # 80000540 <panic>
      consputc(c);
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	c60080e7          	jalr	-928(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000624:	2985                	addiw	s3,s3,1
    80000626:	013a07b3          	add	a5,s4,s3
    8000062a:	0007c503          	lbu	a0,0(a5)
    8000062e:	10050463          	beqz	a0,80000736 <printf+0x1ac>
    if(c != '%'){
    80000632:	ff5515e3          	bne	a0,s5,8000061c <printf+0x92>
    c = fmt[++i] & 0xff;
    80000636:	2985                	addiw	s3,s3,1
    80000638:	013a07b3          	add	a5,s4,s3
    8000063c:	0007c783          	lbu	a5,0(a5)
    80000640:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000644:	cbed                	beqz	a5,80000736 <printf+0x1ac>
    switch(c){
    80000646:	05778a63          	beq	a5,s7,8000069a <printf+0x110>
    8000064a:	02fbf663          	bgeu	s7,a5,80000676 <printf+0xec>
    8000064e:	09978863          	beq	a5,s9,800006de <printf+0x154>
    80000652:	07800713          	li	a4,120
    80000656:	0ce79563          	bne	a5,a4,80000720 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000065a:	f8843783          	ld	a5,-120(s0)
    8000065e:	00878713          	addi	a4,a5,8
    80000662:	f8e43423          	sd	a4,-120(s0)
    80000666:	4605                	li	a2,1
    80000668:	85ea                	mv	a1,s10
    8000066a:	4388                	lw	a0,0(a5)
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	e30080e7          	jalr	-464(ra) # 8000049c <printint>
      break;
    80000674:	bf45                	j	80000624 <printf+0x9a>
    switch(c){
    80000676:	09578f63          	beq	a5,s5,80000714 <printf+0x18a>
    8000067a:	0b879363          	bne	a5,s8,80000720 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	addi	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4605                	li	a2,1
    8000068c:	45a9                	li	a1,10
    8000068e:	4388                	lw	a0,0(a5)
    80000690:	00000097          	auipc	ra,0x0
    80000694:	e0c080e7          	jalr	-500(ra) # 8000049c <printint>
      break;
    80000698:	b771                	j	80000624 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000069a:	f8843783          	ld	a5,-120(s0)
    8000069e:	00878713          	addi	a4,a5,8
    800006a2:	f8e43423          	sd	a4,-120(s0)
    800006a6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006aa:	03000513          	li	a0,48
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	bce080e7          	jalr	-1074(ra) # 8000027c <consputc>
  consputc('x');
    800006b6:	07800513          	li	a0,120
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	bc2080e7          	jalr	-1086(ra) # 8000027c <consputc>
    800006c2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c4:	03c95793          	srli	a5,s2,0x3c
    800006c8:	97da                	add	a5,a5,s6
    800006ca:	0007c503          	lbu	a0,0(a5)
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	bae080e7          	jalr	-1106(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d6:	0912                	slli	s2,s2,0x4
    800006d8:	34fd                	addiw	s1,s1,-1
    800006da:	f4ed                	bnez	s1,800006c4 <printf+0x13a>
    800006dc:	b7a1                	j	80000624 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006de:	f8843783          	ld	a5,-120(s0)
    800006e2:	00878713          	addi	a4,a5,8
    800006e6:	f8e43423          	sd	a4,-120(s0)
    800006ea:	6384                	ld	s1,0(a5)
    800006ec:	cc89                	beqz	s1,80000706 <printf+0x17c>
      for(; *s; s++)
    800006ee:	0004c503          	lbu	a0,0(s1)
    800006f2:	d90d                	beqz	a0,80000624 <printf+0x9a>
        consputc(*s);
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	b88080e7          	jalr	-1144(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fc:	0485                	addi	s1,s1,1
    800006fe:	0004c503          	lbu	a0,0(s1)
    80000702:	f96d                	bnez	a0,800006f4 <printf+0x16a>
    80000704:	b705                	j	80000624 <printf+0x9a>
        s = "(null)";
    80000706:	00008497          	auipc	s1,0x8
    8000070a:	91a48493          	addi	s1,s1,-1766 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070e:	02800513          	li	a0,40
    80000712:	b7cd                	j	800006f4 <printf+0x16a>
      consputc('%');
    80000714:	8556                	mv	a0,s5
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b66080e7          	jalr	-1178(ra) # 8000027c <consputc>
      break;
    8000071e:	b719                	j	80000624 <printf+0x9a>
      consputc('%');
    80000720:	8556                	mv	a0,s5
    80000722:	00000097          	auipc	ra,0x0
    80000726:	b5a080e7          	jalr	-1190(ra) # 8000027c <consputc>
      consputc(c);
    8000072a:	8526                	mv	a0,s1
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b50080e7          	jalr	-1200(ra) # 8000027c <consputc>
      break;
    80000734:	bdc5                	j	80000624 <printf+0x9a>
  if(locking)
    80000736:	020d9163          	bnez	s11,80000758 <printf+0x1ce>
}
    8000073a:	70e6                	ld	ra,120(sp)
    8000073c:	7446                	ld	s0,112(sp)
    8000073e:	74a6                	ld	s1,104(sp)
    80000740:	7906                	ld	s2,96(sp)
    80000742:	69e6                	ld	s3,88(sp)
    80000744:	6a46                	ld	s4,80(sp)
    80000746:	6aa6                	ld	s5,72(sp)
    80000748:	6b06                	ld	s6,64(sp)
    8000074a:	7be2                	ld	s7,56(sp)
    8000074c:	7c42                	ld	s8,48(sp)
    8000074e:	7ca2                	ld	s9,40(sp)
    80000750:	7d02                	ld	s10,32(sp)
    80000752:	6de2                	ld	s11,24(sp)
    80000754:	6129                	addi	sp,sp,192
    80000756:	8082                	ret
    release(&pr.lock);
    80000758:	00010517          	auipc	a0,0x10
    8000075c:	42050513          	addi	a0,a0,1056 # 80010b78 <pr>
    80000760:	00000097          	auipc	ra,0x0
    80000764:	600080e7          	jalr	1536(ra) # 80000d60 <release>
}
    80000768:	bfc9                	j	8000073a <printf+0x1b0>

000000008000076a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000774:	00010497          	auipc	s1,0x10
    80000778:	40448493          	addi	s1,s1,1028 # 80010b78 <pr>
    8000077c:	00008597          	auipc	a1,0x8
    80000780:	8bc58593          	addi	a1,a1,-1860 # 80008038 <etext+0x38>
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	496080e7          	jalr	1174(ra) # 80000c1c <initlock>
  pr.locking = 1;
    8000078e:	4785                	li	a5,1
    80000790:	cc9c                	sw	a5,24(s1)
}
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6105                	addi	sp,sp,32
    8000079a:	8082                	ret

000000008000079c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079c:	1141                	addi	sp,sp,-16
    8000079e:	e406                	sd	ra,8(sp)
    800007a0:	e022                	sd	s0,0(sp)
    800007a2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a4:	100007b7          	lui	a5,0x10000
    800007a8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ac:	f8000713          	li	a4,-128
    800007b0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b4:	470d                	li	a4,3
    800007b6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007ba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007be:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c2:	469d                	li	a3,7
    800007c4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007cc:	00008597          	auipc	a1,0x8
    800007d0:	88c58593          	addi	a1,a1,-1908 # 80008058 <digits+0x18>
    800007d4:	00010517          	auipc	a0,0x10
    800007d8:	3c450513          	addi	a0,a0,964 # 80010b98 <uart_tx_lock>
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	440080e7          	jalr	1088(ra) # 80000c1c <initlock>
}
    800007e4:	60a2                	ld	ra,8(sp)
    800007e6:	6402                	ld	s0,0(sp)
    800007e8:	0141                	addi	sp,sp,16
    800007ea:	8082                	ret

00000000800007ec <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ec:	1101                	addi	sp,sp,-32
    800007ee:	ec06                	sd	ra,24(sp)
    800007f0:	e822                	sd	s0,16(sp)
    800007f2:	e426                	sd	s1,8(sp)
    800007f4:	1000                	addi	s0,sp,32
    800007f6:	84aa                	mv	s1,a0
  push_off();
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	468080e7          	jalr	1128(ra) # 80000c60 <push_off>

  if(panicked){
    80000800:	00008797          	auipc	a5,0x8
    80000804:	1507a783          	lw	a5,336(a5) # 80008950 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000808:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080c:	c391                	beqz	a5,80000810 <uartputc_sync+0x24>
    for(;;)
    8000080e:	a001                	j	8000080e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000810:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000814:	0207f793          	andi	a5,a5,32
    80000818:	dfe5                	beqz	a5,80000810 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000081a:	0ff4f513          	zext.b	a0,s1
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	4da080e7          	jalr	1242(ra) # 80000d00 <pop_off>
}
    8000082e:	60e2                	ld	ra,24(sp)
    80000830:	6442                	ld	s0,16(sp)
    80000832:	64a2                	ld	s1,8(sp)
    80000834:	6105                	addi	sp,sp,32
    80000836:	8082                	ret

0000000080000838 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000838:	00008797          	auipc	a5,0x8
    8000083c:	1207b783          	ld	a5,288(a5) # 80008958 <uart_tx_r>
    80000840:	00008717          	auipc	a4,0x8
    80000844:	12073703          	ld	a4,288(a4) # 80008960 <uart_tx_w>
    80000848:	06f70a63          	beq	a4,a5,800008bc <uartstart+0x84>
{
    8000084c:	7139                	addi	sp,sp,-64
    8000084e:	fc06                	sd	ra,56(sp)
    80000850:	f822                	sd	s0,48(sp)
    80000852:	f426                	sd	s1,40(sp)
    80000854:	f04a                	sd	s2,32(sp)
    80000856:	ec4e                	sd	s3,24(sp)
    80000858:	e852                	sd	s4,16(sp)
    8000085a:	e456                	sd	s5,8(sp)
    8000085c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000862:	00010a17          	auipc	s4,0x10
    80000866:	336a0a13          	addi	s4,s4,822 # 80010b98 <uart_tx_lock>
    uart_tx_r += 1;
    8000086a:	00008497          	auipc	s1,0x8
    8000086e:	0ee48493          	addi	s1,s1,238 # 80008958 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000872:	00008997          	auipc	s3,0x8
    80000876:	0ee98993          	addi	s3,s3,238 # 80008960 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087e:	02077713          	andi	a4,a4,32
    80000882:	c705                	beqz	a4,800008aa <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000884:	01f7f713          	andi	a4,a5,31
    80000888:	9752                	add	a4,a4,s4
    8000088a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088e:	0785                	addi	a5,a5,1
    80000890:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000892:	8526                	mv	a0,s1
    80000894:	00002097          	auipc	ra,0x2
    80000898:	d84080e7          	jalr	-636(ra) # 80002618 <wakeup>
    
    WriteReg(THR, c);
    8000089c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008a0:	609c                	ld	a5,0(s1)
    800008a2:	0009b703          	ld	a4,0(s3)
    800008a6:	fcf71ae3          	bne	a4,a5,8000087a <uartstart+0x42>
  }
}
    800008aa:	70e2                	ld	ra,56(sp)
    800008ac:	7442                	ld	s0,48(sp)
    800008ae:	74a2                	ld	s1,40(sp)
    800008b0:	7902                	ld	s2,32(sp)
    800008b2:	69e2                	ld	s3,24(sp)
    800008b4:	6a42                	ld	s4,16(sp)
    800008b6:	6aa2                	ld	s5,8(sp)
    800008b8:	6121                	addi	sp,sp,64
    800008ba:	8082                	ret
    800008bc:	8082                	ret

00000000800008be <uartputc>:
{
    800008be:	7179                	addi	sp,sp,-48
    800008c0:	f406                	sd	ra,40(sp)
    800008c2:	f022                	sd	s0,32(sp)
    800008c4:	ec26                	sd	s1,24(sp)
    800008c6:	e84a                	sd	s2,16(sp)
    800008c8:	e44e                	sd	s3,8(sp)
    800008ca:	e052                	sd	s4,0(sp)
    800008cc:	1800                	addi	s0,sp,48
    800008ce:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008d0:	00010517          	auipc	a0,0x10
    800008d4:	2c850513          	addi	a0,a0,712 # 80010b98 <uart_tx_lock>
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	3d4080e7          	jalr	980(ra) # 80000cac <acquire>
  if(panicked){
    800008e0:	00008797          	auipc	a5,0x8
    800008e4:	0707a783          	lw	a5,112(a5) # 80008950 <panicked>
    800008e8:	e7c9                	bnez	a5,80000972 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008ea:	00008717          	auipc	a4,0x8
    800008ee:	07673703          	ld	a4,118(a4) # 80008960 <uart_tx_w>
    800008f2:	00008797          	auipc	a5,0x8
    800008f6:	0667b783          	ld	a5,102(a5) # 80008958 <uart_tx_r>
    800008fa:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00010997          	auipc	s3,0x10
    80000902:	29a98993          	addi	s3,s3,666 # 80010b98 <uart_tx_lock>
    80000906:	00008497          	auipc	s1,0x8
    8000090a:	05248493          	addi	s1,s1,82 # 80008958 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00008917          	auipc	s2,0x8
    80000912:	05290913          	addi	s2,s2,82 # 80008960 <uart_tx_w>
    80000916:	00e79f63          	bne	a5,a4,80000934 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091a:	85ce                	mv	a1,s3
    8000091c:	8526                	mv	a0,s1
    8000091e:	00002097          	auipc	ra,0x2
    80000922:	c96080e7          	jalr	-874(ra) # 800025b4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000926:	00093703          	ld	a4,0(s2)
    8000092a:	609c                	ld	a5,0(s1)
    8000092c:	02078793          	addi	a5,a5,32
    80000930:	fee785e3          	beq	a5,a4,8000091a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000934:	00010497          	auipc	s1,0x10
    80000938:	26448493          	addi	s1,s1,612 # 80010b98 <uart_tx_lock>
    8000093c:	01f77793          	andi	a5,a4,31
    80000940:	97a6                	add	a5,a5,s1
    80000942:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000946:	0705                	addi	a4,a4,1
    80000948:	00008797          	auipc	a5,0x8
    8000094c:	00e7bc23          	sd	a4,24(a5) # 80008960 <uart_tx_w>
  uartstart();
    80000950:	00000097          	auipc	ra,0x0
    80000954:	ee8080e7          	jalr	-280(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    80000958:	8526                	mv	a0,s1
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	406080e7          	jalr	1030(ra) # 80000d60 <release>
}
    80000962:	70a2                	ld	ra,40(sp)
    80000964:	7402                	ld	s0,32(sp)
    80000966:	64e2                	ld	s1,24(sp)
    80000968:	6942                	ld	s2,16(sp)
    8000096a:	69a2                	ld	s3,8(sp)
    8000096c:	6a02                	ld	s4,0(sp)
    8000096e:	6145                	addi	sp,sp,48
    80000970:	8082                	ret
    for(;;)
    80000972:	a001                	j	80000972 <uartputc+0xb4>

0000000080000974 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000974:	1141                	addi	sp,sp,-16
    80000976:	e422                	sd	s0,8(sp)
    80000978:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000097a:	100007b7          	lui	a5,0x10000
    8000097e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000982:	8b85                	andi	a5,a5,1
    80000984:	cb81                	beqz	a5,80000994 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000986:	100007b7          	lui	a5,0x10000
    8000098a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098e:	6422                	ld	s0,8(sp)
    80000990:	0141                	addi	sp,sp,16
    80000992:	8082                	ret
    return -1;
    80000994:	557d                	li	a0,-1
    80000996:	bfe5                	j	8000098e <uartgetc+0x1a>

0000000080000998 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000998:	1101                	addi	sp,sp,-32
    8000099a:	ec06                	sd	ra,24(sp)
    8000099c:	e822                	sd	s0,16(sp)
    8000099e:	e426                	sd	s1,8(sp)
    800009a0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a2:	54fd                	li	s1,-1
    800009a4:	a029                	j	800009ae <uartintr+0x16>
      break;
    consoleintr(c);
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	918080e7          	jalr	-1768(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	fc6080e7          	jalr	-58(ra) # 80000974 <uartgetc>
    if(c == -1)
    800009b6:	fe9518e3          	bne	a0,s1,800009a6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009ba:	00010497          	auipc	s1,0x10
    800009be:	1de48493          	addi	s1,s1,478 # 80010b98 <uart_tx_lock>
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	2e8080e7          	jalr	744(ra) # 80000cac <acquire>
  uartstart();
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	e6c080e7          	jalr	-404(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	38a080e7          	jalr	906(ra) # 80000d60 <release>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret

00000000800009e8 <add_page_reference>:
struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void add_page_reference(uint64 pointer_in_page){
    800009e8:	1101                	addi	sp,sp,-32
    800009ea:	ec06                	sd	ra,24(sp)
    800009ec:	e822                	sd	s0,16(sp)
    800009ee:	e426                	sd	s1,8(sp)
    800009f0:	e04a                	sd	s2,0(sp)
    800009f2:	1000                	addi	s0,sp,32
    800009f4:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    800009f6:	00010917          	auipc	s2,0x10
    800009fa:	1da90913          	addi	s2,s2,474 # 80010bd0 <kmem>
    800009fe:	854a                	mv	a0,s2
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	2ac080e7          	jalr	684(ra) # 80000cac <acquire>
  uint page_num = PGROUNDDOWN((uint64)pointer_in_page)/PGSIZE;
    80000a08:	80b1                	srli	s1,s1,0xc
  ref_counter[page_num]++;
    80000a0a:	02049793          	slli	a5,s1,0x20
    80000a0e:	01d7d493          	srli	s1,a5,0x1d
    80000a12:	00010797          	auipc	a5,0x10
    80000a16:	1de78793          	addi	a5,a5,478 # 80010bf0 <ref_counter>
    80000a1a:	97a6                	add	a5,a5,s1
    80000a1c:	6398                	ld	a4,0(a5)
    80000a1e:	0705                	addi	a4,a4,1
    80000a20:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000a22:	854a                	mv	a0,s2
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	33c080e7          	jalr	828(ra) # 80000d60 <release>
}
    80000a2c:	60e2                	ld	ra,24(sp)
    80000a2e:	6442                	ld	s0,16(sp)
    80000a30:	64a2                	ld	s1,8(sp)
    80000a32:	6902                	ld	s2,0(sp)
    80000a34:	6105                	addi	sp,sp,32
    80000a36:	8082                	ret

0000000080000a38 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a38:	1101                	addi	sp,sp,-32
    80000a3a:	ec06                	sd	ra,24(sp)
    80000a3c:	e822                	sd	s0,16(sp)
    80000a3e:	e426                	sd	s1,8(sp)
    80000a40:	e04a                	sd	s2,0(sp)
    80000a42:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a44:	03451793          	slli	a5,a0,0x34
    80000a48:	efd1                	bnez	a5,80000ae4 <kfree+0xac>
    80000a4a:	84aa                	mv	s1,a0
    80000a4c:	00069797          	auipc	a5,0x69
    80000a50:	5b478793          	addi	a5,a5,1460 # 8006a000 <end>
    80000a54:	08f56863          	bltu	a0,a5,80000ae4 <kfree+0xac>
    80000a58:	47c5                	li	a5,17
    80000a5a:	07ee                	slli	a5,a5,0x1b
    80000a5c:	08f57463          	bgeu	a0,a5,80000ae4 <kfree+0xac>
    panic("kfree");

  acquire(&kmem.lock);
    80000a60:	00010517          	auipc	a0,0x10
    80000a64:	17050513          	addi	a0,a0,368 # 80010bd0 <kmem>
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	244080e7          	jalr	580(ra) # 80000cac <acquire>
  uint64 page_num = PGROUNDDOWN((uint64)pa)/PGSIZE;
    80000a70:	00c4d793          	srli	a5,s1,0xc
  if (ref_counter[page_num] > 1) {
    80000a74:	00379693          	slli	a3,a5,0x3
    80000a78:	00010717          	auipc	a4,0x10
    80000a7c:	17870713          	addi	a4,a4,376 # 80010bf0 <ref_counter>
    80000a80:	9736                	add	a4,a4,a3
    80000a82:	6318                	ld	a4,0(a4)
    80000a84:	4685                	li	a3,1
    80000a86:	06e6e763          	bltu	a3,a4,80000af4 <kfree+0xbc>
    ref_counter[page_num]--;
    release(&kmem.lock);
    return;
  }
  ref_counter[page_num] = 0; // insurance
    80000a8a:	078e                	slli	a5,a5,0x3
    80000a8c:	00010717          	auipc	a4,0x10
    80000a90:	16470713          	addi	a4,a4,356 # 80010bf0 <ref_counter>
    80000a94:	97ba                	add	a5,a5,a4
    80000a96:	0007b023          	sd	zero,0(a5)
  release(&kmem.lock);
    80000a9a:	00010917          	auipc	s2,0x10
    80000a9e:	13690913          	addi	s2,s2,310 # 80010bd0 <kmem>
    80000aa2:	854a                	mv	a0,s2
    80000aa4:	00000097          	auipc	ra,0x0
    80000aa8:	2bc080e7          	jalr	700(ra) # 80000d60 <release>

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000aac:	6605                	lui	a2,0x1
    80000aae:	4585                	li	a1,1
    80000ab0:	8526                	mv	a0,s1
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	2f6080e7          	jalr	758(ra) # 80000da8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000aba:	854a                	mv	a0,s2
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	1f0080e7          	jalr	496(ra) # 80000cac <acquire>
  r->next = kmem.freelist;
    80000ac4:	01893783          	ld	a5,24(s2)
    80000ac8:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aca:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000ace:	854a                	mv	a0,s2
    80000ad0:	00000097          	auipc	ra,0x0
    80000ad4:	290080e7          	jalr	656(ra) # 80000d60 <release>
}
    80000ad8:	60e2                	ld	ra,24(sp)
    80000ada:	6442                	ld	s0,16(sp)
    80000adc:	64a2                	ld	s1,8(sp)
    80000ade:	6902                	ld	s2,0(sp)
    80000ae0:	6105                	addi	sp,sp,32
    80000ae2:	8082                	ret
    panic("kfree");
    80000ae4:	00007517          	auipc	a0,0x7
    80000ae8:	57c50513          	addi	a0,a0,1404 # 80008060 <digits+0x20>
    80000aec:	00000097          	auipc	ra,0x0
    80000af0:	a54080e7          	jalr	-1452(ra) # 80000540 <panic>
    ref_counter[page_num]--;
    80000af4:	078e                	slli	a5,a5,0x3
    80000af6:	00010697          	auipc	a3,0x10
    80000afa:	0fa68693          	addi	a3,a3,250 # 80010bf0 <ref_counter>
    80000afe:	97b6                	add	a5,a5,a3
    80000b00:	177d                	addi	a4,a4,-1
    80000b02:	e398                	sd	a4,0(a5)
    release(&kmem.lock);
    80000b04:	00010517          	auipc	a0,0x10
    80000b08:	0cc50513          	addi	a0,a0,204 # 80010bd0 <kmem>
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	254080e7          	jalr	596(ra) # 80000d60 <release>
    return;
    80000b14:	b7d1                	j	80000ad8 <kfree+0xa0>

0000000080000b16 <freerange>:
{
    80000b16:	7179                	addi	sp,sp,-48
    80000b18:	f406                	sd	ra,40(sp)
    80000b1a:	f022                	sd	s0,32(sp)
    80000b1c:	ec26                	sd	s1,24(sp)
    80000b1e:	e84a                	sd	s2,16(sp)
    80000b20:	e44e                	sd	s3,8(sp)
    80000b22:	e052                	sd	s4,0(sp)
    80000b24:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b26:	6785                	lui	a5,0x1
    80000b28:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b2c:	00e504b3          	add	s1,a0,a4
    80000b30:	777d                	lui	a4,0xfffff
    80000b32:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b34:	94be                	add	s1,s1,a5
    80000b36:	0095ee63          	bltu	a1,s1,80000b52 <freerange+0x3c>
    80000b3a:	892e                	mv	s2,a1
    kfree(p);
    80000b3c:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b3e:	6985                	lui	s3,0x1
    kfree(p);
    80000b40:	01448533          	add	a0,s1,s4
    80000b44:	00000097          	auipc	ra,0x0
    80000b48:	ef4080e7          	jalr	-268(ra) # 80000a38 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b4c:	94ce                	add	s1,s1,s3
    80000b4e:	fe9979e3          	bgeu	s2,s1,80000b40 <freerange+0x2a>
}
    80000b52:	70a2                	ld	ra,40(sp)
    80000b54:	7402                	ld	s0,32(sp)
    80000b56:	64e2                	ld	s1,24(sp)
    80000b58:	6942                	ld	s2,16(sp)
    80000b5a:	69a2                	ld	s3,8(sp)
    80000b5c:	6a02                	ld	s4,0(sp)
    80000b5e:	6145                	addi	sp,sp,48
    80000b60:	8082                	ret

0000000080000b62 <kinit>:
{
    80000b62:	1141                	addi	sp,sp,-16
    80000b64:	e406                	sd	ra,8(sp)
    80000b66:	e022                	sd	s0,0(sp)
    80000b68:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b6a:	00007597          	auipc	a1,0x7
    80000b6e:	4fe58593          	addi	a1,a1,1278 # 80008068 <digits+0x28>
    80000b72:	00010517          	auipc	a0,0x10
    80000b76:	05e50513          	addi	a0,a0,94 # 80010bd0 <kmem>
    80000b7a:	00000097          	auipc	ra,0x0
    80000b7e:	0a2080e7          	jalr	162(ra) # 80000c1c <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b82:	45c5                	li	a1,17
    80000b84:	05ee                	slli	a1,a1,0x1b
    80000b86:	00069517          	auipc	a0,0x69
    80000b8a:	47a50513          	addi	a0,a0,1146 # 8006a000 <end>
    80000b8e:	00000097          	auipc	ra,0x0
    80000b92:	f88080e7          	jalr	-120(ra) # 80000b16 <freerange>
}
    80000b96:	60a2                	ld	ra,8(sp)
    80000b98:	6402                	ld	s0,0(sp)
    80000b9a:	0141                	addi	sp,sp,16
    80000b9c:	8082                	ret

0000000080000b9e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b9e:	1101                	addi	sp,sp,-32
    80000ba0:	ec06                	sd	ra,24(sp)
    80000ba2:	e822                	sd	s0,16(sp)
    80000ba4:	e426                	sd	s1,8(sp)
    80000ba6:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ba8:	00010497          	auipc	s1,0x10
    80000bac:	02848493          	addi	s1,s1,40 # 80010bd0 <kmem>
    80000bb0:	8526                	mv	a0,s1
    80000bb2:	00000097          	auipc	ra,0x0
    80000bb6:	0fa080e7          	jalr	250(ra) # 80000cac <acquire>

  r = kmem.freelist;
    80000bba:	6c84                	ld	s1,24(s1)
  if(r)
    80000bbc:	c0b1                	beqz	s1,80000c00 <kalloc+0x62>
    kmem.freelist = r->next;
    80000bbe:	609c                	ld	a5,0(s1)
    80000bc0:	00010517          	auipc	a0,0x10
    80000bc4:	01050513          	addi	a0,a0,16 # 80010bd0 <kmem>
    80000bc8:	ed1c                	sd	a5,24(a0)
  uint64 page_num = PGROUNDDOWN((uint64)r)/PGSIZE;
    80000bca:	00c4d713          	srli	a4,s1,0xc
  ref_counter[page_num] = 1;
    80000bce:	070e                	slli	a4,a4,0x3
    80000bd0:	00010797          	auipc	a5,0x10
    80000bd4:	02078793          	addi	a5,a5,32 # 80010bf0 <ref_counter>
    80000bd8:	97ba                	add	a5,a5,a4
    80000bda:	4705                	li	a4,1
    80000bdc:	e398                	sd	a4,0(a5)
  release(&kmem.lock);
    80000bde:	00000097          	auipc	ra,0x0
    80000be2:	182080e7          	jalr	386(ra) # 80000d60 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000be6:	6605                	lui	a2,0x1
    80000be8:	4595                	li	a1,5
    80000bea:	8526                	mv	a0,s1
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	1bc080e7          	jalr	444(ra) # 80000da8 <memset>
  return (void*)r;
}
    80000bf4:	8526                	mv	a0,s1
    80000bf6:	60e2                	ld	ra,24(sp)
    80000bf8:	6442                	ld	s0,16(sp)
    80000bfa:	64a2                	ld	s1,8(sp)
    80000bfc:	6105                	addi	sp,sp,32
    80000bfe:	8082                	ret
  ref_counter[page_num] = 1;
    80000c00:	4785                	li	a5,1
    80000c02:	00010717          	auipc	a4,0x10
    80000c06:	fef73723          	sd	a5,-18(a4) # 80010bf0 <ref_counter>
  release(&kmem.lock);
    80000c0a:	00010517          	auipc	a0,0x10
    80000c0e:	fc650513          	addi	a0,a0,-58 # 80010bd0 <kmem>
    80000c12:	00000097          	auipc	ra,0x0
    80000c16:	14e080e7          	jalr	334(ra) # 80000d60 <release>
  if(r)
    80000c1a:	bfe9                	j	80000bf4 <kalloc+0x56>

0000000080000c1c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c1c:	1141                	addi	sp,sp,-16
    80000c1e:	e422                	sd	s0,8(sp)
    80000c20:	0800                	addi	s0,sp,16
  lk->name = name;
    80000c22:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c24:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c28:	00053823          	sd	zero,16(a0)
}
    80000c2c:	6422                	ld	s0,8(sp)
    80000c2e:	0141                	addi	sp,sp,16
    80000c30:	8082                	ret

0000000080000c32 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c32:	411c                	lw	a5,0(a0)
    80000c34:	e399                	bnez	a5,80000c3a <holding+0x8>
    80000c36:	4501                	li	a0,0
  return r;
}
    80000c38:	8082                	ret
{
    80000c3a:	1101                	addi	sp,sp,-32
    80000c3c:	ec06                	sd	ra,24(sp)
    80000c3e:	e822                	sd	s0,16(sp)
    80000c40:	e426                	sd	s1,8(sp)
    80000c42:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c44:	6904                	ld	s1,16(a0)
    80000c46:	00001097          	auipc	ra,0x1
    80000c4a:	0a6080e7          	jalr	166(ra) # 80001cec <mycpu>
    80000c4e:	40a48533          	sub	a0,s1,a0
    80000c52:	00153513          	seqz	a0,a0
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret

0000000080000c60 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c60:	1101                	addi	sp,sp,-32
    80000c62:	ec06                	sd	ra,24(sp)
    80000c64:	e822                	sd	s0,16(sp)
    80000c66:	e426                	sd	s1,8(sp)
    80000c68:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c6a:	100024f3          	csrr	s1,sstatus
    80000c6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c72:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c74:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c78:	00001097          	auipc	ra,0x1
    80000c7c:	074080e7          	jalr	116(ra) # 80001cec <mycpu>
    80000c80:	5d3c                	lw	a5,120(a0)
    80000c82:	cf89                	beqz	a5,80000c9c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c84:	00001097          	auipc	ra,0x1
    80000c88:	068080e7          	jalr	104(ra) # 80001cec <mycpu>
    80000c8c:	5d3c                	lw	a5,120(a0)
    80000c8e:	2785                	addiw	a5,a5,1
    80000c90:	dd3c                	sw	a5,120(a0)
}
    80000c92:	60e2                	ld	ra,24(sp)
    80000c94:	6442                	ld	s0,16(sp)
    80000c96:	64a2                	ld	s1,8(sp)
    80000c98:	6105                	addi	sp,sp,32
    80000c9a:	8082                	ret
    mycpu()->intena = old;
    80000c9c:	00001097          	auipc	ra,0x1
    80000ca0:	050080e7          	jalr	80(ra) # 80001cec <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000ca4:	8085                	srli	s1,s1,0x1
    80000ca6:	8885                	andi	s1,s1,1
    80000ca8:	dd64                	sw	s1,124(a0)
    80000caa:	bfe9                	j	80000c84 <push_off+0x24>

0000000080000cac <acquire>:
{
    80000cac:	1101                	addi	sp,sp,-32
    80000cae:	ec06                	sd	ra,24(sp)
    80000cb0:	e822                	sd	s0,16(sp)
    80000cb2:	e426                	sd	s1,8(sp)
    80000cb4:	1000                	addi	s0,sp,32
    80000cb6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000cb8:	00000097          	auipc	ra,0x0
    80000cbc:	fa8080e7          	jalr	-88(ra) # 80000c60 <push_off>
  if(holding(lk))
    80000cc0:	8526                	mv	a0,s1
    80000cc2:	00000097          	auipc	ra,0x0
    80000cc6:	f70080e7          	jalr	-144(ra) # 80000c32 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000cca:	4705                	li	a4,1
  if(holding(lk))
    80000ccc:	e115                	bnez	a0,80000cf0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000cce:	87ba                	mv	a5,a4
    80000cd0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000cd4:	2781                	sext.w	a5,a5
    80000cd6:	ffe5                	bnez	a5,80000cce <acquire+0x22>
  __sync_synchronize();
    80000cd8:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000cdc:	00001097          	auipc	ra,0x1
    80000ce0:	010080e7          	jalr	16(ra) # 80001cec <mycpu>
    80000ce4:	e888                	sd	a0,16(s1)
}
    80000ce6:	60e2                	ld	ra,24(sp)
    80000ce8:	6442                	ld	s0,16(sp)
    80000cea:	64a2                	ld	s1,8(sp)
    80000cec:	6105                	addi	sp,sp,32
    80000cee:	8082                	ret
    panic("acquire");
    80000cf0:	00007517          	auipc	a0,0x7
    80000cf4:	38050513          	addi	a0,a0,896 # 80008070 <digits+0x30>
    80000cf8:	00000097          	auipc	ra,0x0
    80000cfc:	848080e7          	jalr	-1976(ra) # 80000540 <panic>

0000000080000d00 <pop_off>:

void
pop_off(void)
{
    80000d00:	1141                	addi	sp,sp,-16
    80000d02:	e406                	sd	ra,8(sp)
    80000d04:	e022                	sd	s0,0(sp)
    80000d06:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d08:	00001097          	auipc	ra,0x1
    80000d0c:	fe4080e7          	jalr	-28(ra) # 80001cec <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d10:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d14:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d16:	e78d                	bnez	a5,80000d40 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d18:	5d3c                	lw	a5,120(a0)
    80000d1a:	02f05b63          	blez	a5,80000d50 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000d1e:	37fd                	addiw	a5,a5,-1
    80000d20:	0007871b          	sext.w	a4,a5
    80000d24:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d26:	eb09                	bnez	a4,80000d38 <pop_off+0x38>
    80000d28:	5d7c                	lw	a5,124(a0)
    80000d2a:	c799                	beqz	a5,80000d38 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d2c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000d30:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d34:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000d38:	60a2                	ld	ra,8(sp)
    80000d3a:	6402                	ld	s0,0(sp)
    80000d3c:	0141                	addi	sp,sp,16
    80000d3e:	8082                	ret
    panic("pop_off - interruptible");
    80000d40:	00007517          	auipc	a0,0x7
    80000d44:	33850513          	addi	a0,a0,824 # 80008078 <digits+0x38>
    80000d48:	fffff097          	auipc	ra,0xfffff
    80000d4c:	7f8080e7          	jalr	2040(ra) # 80000540 <panic>
    panic("pop_off");
    80000d50:	00007517          	auipc	a0,0x7
    80000d54:	34050513          	addi	a0,a0,832 # 80008090 <digits+0x50>
    80000d58:	fffff097          	auipc	ra,0xfffff
    80000d5c:	7e8080e7          	jalr	2024(ra) # 80000540 <panic>

0000000080000d60 <release>:
{
    80000d60:	1101                	addi	sp,sp,-32
    80000d62:	ec06                	sd	ra,24(sp)
    80000d64:	e822                	sd	s0,16(sp)
    80000d66:	e426                	sd	s1,8(sp)
    80000d68:	1000                	addi	s0,sp,32
    80000d6a:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d6c:	00000097          	auipc	ra,0x0
    80000d70:	ec6080e7          	jalr	-314(ra) # 80000c32 <holding>
    80000d74:	c115                	beqz	a0,80000d98 <release+0x38>
  lk->cpu = 0;
    80000d76:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d7a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000d7e:	0f50000f          	fence	iorw,ow
    80000d82:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	f7a080e7          	jalr	-134(ra) # 80000d00 <pop_off>
}
    80000d8e:	60e2                	ld	ra,24(sp)
    80000d90:	6442                	ld	s0,16(sp)
    80000d92:	64a2                	ld	s1,8(sp)
    80000d94:	6105                	addi	sp,sp,32
    80000d96:	8082                	ret
    panic("release");
    80000d98:	00007517          	auipc	a0,0x7
    80000d9c:	30050513          	addi	a0,a0,768 # 80008098 <digits+0x58>
    80000da0:	fffff097          	auipc	ra,0xfffff
    80000da4:	7a0080e7          	jalr	1952(ra) # 80000540 <panic>

0000000080000da8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000da8:	1141                	addi	sp,sp,-16
    80000daa:	e422                	sd	s0,8(sp)
    80000dac:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000dae:	ca19                	beqz	a2,80000dc4 <memset+0x1c>
    80000db0:	87aa                	mv	a5,a0
    80000db2:	1602                	slli	a2,a2,0x20
    80000db4:	9201                	srli	a2,a2,0x20
    80000db6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000dba:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000dbe:	0785                	addi	a5,a5,1
    80000dc0:	fee79de3          	bne	a5,a4,80000dba <memset+0x12>
  }
  return dst;
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000dd0:	ca05                	beqz	a2,80000e00 <memcmp+0x36>
    80000dd2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000dd6:	1682                	slli	a3,a3,0x20
    80000dd8:	9281                	srli	a3,a3,0x20
    80000dda:	0685                	addi	a3,a3,1
    80000ddc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000dde:	00054783          	lbu	a5,0(a0)
    80000de2:	0005c703          	lbu	a4,0(a1)
    80000de6:	00e79863          	bne	a5,a4,80000df6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000dea:	0505                	addi	a0,a0,1
    80000dec:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000dee:	fed518e3          	bne	a0,a3,80000dde <memcmp+0x14>
  }

  return 0;
    80000df2:	4501                	li	a0,0
    80000df4:	a019                	j	80000dfa <memcmp+0x30>
      return *s1 - *s2;
    80000df6:	40e7853b          	subw	a0,a5,a4
}
    80000dfa:	6422                	ld	s0,8(sp)
    80000dfc:	0141                	addi	sp,sp,16
    80000dfe:	8082                	ret
  return 0;
    80000e00:	4501                	li	a0,0
    80000e02:	bfe5                	j	80000dfa <memcmp+0x30>

0000000080000e04 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e04:	1141                	addi	sp,sp,-16
    80000e06:	e422                	sd	s0,8(sp)
    80000e08:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e0a:	c205                	beqz	a2,80000e2a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e0c:	02a5e263          	bltu	a1,a0,80000e30 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e10:	1602                	slli	a2,a2,0x20
    80000e12:	9201                	srli	a2,a2,0x20
    80000e14:	00c587b3          	add	a5,a1,a2
{
    80000e18:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e1a:	0585                	addi	a1,a1,1
    80000e1c:	0705                	addi	a4,a4,1
    80000e1e:	fff5c683          	lbu	a3,-1(a1)
    80000e22:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e26:	fef59ae3          	bne	a1,a5,80000e1a <memmove+0x16>

  return dst;
}
    80000e2a:	6422                	ld	s0,8(sp)
    80000e2c:	0141                	addi	sp,sp,16
    80000e2e:	8082                	ret
  if(s < d && s + n > d){
    80000e30:	02061693          	slli	a3,a2,0x20
    80000e34:	9281                	srli	a3,a3,0x20
    80000e36:	00d58733          	add	a4,a1,a3
    80000e3a:	fce57be3          	bgeu	a0,a4,80000e10 <memmove+0xc>
    d += n;
    80000e3e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000e40:	fff6079b          	addiw	a5,a2,-1
    80000e44:	1782                	slli	a5,a5,0x20
    80000e46:	9381                	srli	a5,a5,0x20
    80000e48:	fff7c793          	not	a5,a5
    80000e4c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000e4e:	177d                	addi	a4,a4,-1
    80000e50:	16fd                	addi	a3,a3,-1
    80000e52:	00074603          	lbu	a2,0(a4)
    80000e56:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000e5a:	fee79ae3          	bne	a5,a4,80000e4e <memmove+0x4a>
    80000e5e:	b7f1                	j	80000e2a <memmove+0x26>

0000000080000e60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e406                	sd	ra,8(sp)
    80000e64:	e022                	sd	s0,0(sp)
    80000e66:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e68:	00000097          	auipc	ra,0x0
    80000e6c:	f9c080e7          	jalr	-100(ra) # 80000e04 <memmove>
}
    80000e70:	60a2                	ld	ra,8(sp)
    80000e72:	6402                	ld	s0,0(sp)
    80000e74:	0141                	addi	sp,sp,16
    80000e76:	8082                	ret

0000000080000e78 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e78:	1141                	addi	sp,sp,-16
    80000e7a:	e422                	sd	s0,8(sp)
    80000e7c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e7e:	ce11                	beqz	a2,80000e9a <strncmp+0x22>
    80000e80:	00054783          	lbu	a5,0(a0)
    80000e84:	cf89                	beqz	a5,80000e9e <strncmp+0x26>
    80000e86:	0005c703          	lbu	a4,0(a1)
    80000e8a:	00f71a63          	bne	a4,a5,80000e9e <strncmp+0x26>
    n--, p++, q++;
    80000e8e:	367d                	addiw	a2,a2,-1
    80000e90:	0505                	addi	a0,a0,1
    80000e92:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e94:	f675                	bnez	a2,80000e80 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e96:	4501                	li	a0,0
    80000e98:	a809                	j	80000eaa <strncmp+0x32>
    80000e9a:	4501                	li	a0,0
    80000e9c:	a039                	j	80000eaa <strncmp+0x32>
  if(n == 0)
    80000e9e:	ca09                	beqz	a2,80000eb0 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000ea0:	00054503          	lbu	a0,0(a0)
    80000ea4:	0005c783          	lbu	a5,0(a1)
    80000ea8:	9d1d                	subw	a0,a0,a5
}
    80000eaa:	6422                	ld	s0,8(sp)
    80000eac:	0141                	addi	sp,sp,16
    80000eae:	8082                	ret
    return 0;
    80000eb0:	4501                	li	a0,0
    80000eb2:	bfe5                	j	80000eaa <strncmp+0x32>

0000000080000eb4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e422                	sd	s0,8(sp)
    80000eb8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000eba:	872a                	mv	a4,a0
    80000ebc:	8832                	mv	a6,a2
    80000ebe:	367d                	addiw	a2,a2,-1
    80000ec0:	01005963          	blez	a6,80000ed2 <strncpy+0x1e>
    80000ec4:	0705                	addi	a4,a4,1
    80000ec6:	0005c783          	lbu	a5,0(a1)
    80000eca:	fef70fa3          	sb	a5,-1(a4)
    80000ece:	0585                	addi	a1,a1,1
    80000ed0:	f7f5                	bnez	a5,80000ebc <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ed2:	86ba                	mv	a3,a4
    80000ed4:	00c05c63          	blez	a2,80000eec <strncpy+0x38>
    *s++ = 0;
    80000ed8:	0685                	addi	a3,a3,1
    80000eda:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000ede:	40d707bb          	subw	a5,a4,a3
    80000ee2:	37fd                	addiw	a5,a5,-1
    80000ee4:	010787bb          	addw	a5,a5,a6
    80000ee8:	fef048e3          	bgtz	a5,80000ed8 <strncpy+0x24>
  return os;
}
    80000eec:	6422                	ld	s0,8(sp)
    80000eee:	0141                	addi	sp,sp,16
    80000ef0:	8082                	ret

0000000080000ef2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ef2:	1141                	addi	sp,sp,-16
    80000ef4:	e422                	sd	s0,8(sp)
    80000ef6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000ef8:	02c05363          	blez	a2,80000f1e <safestrcpy+0x2c>
    80000efc:	fff6069b          	addiw	a3,a2,-1
    80000f00:	1682                	slli	a3,a3,0x20
    80000f02:	9281                	srli	a3,a3,0x20
    80000f04:	96ae                	add	a3,a3,a1
    80000f06:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f08:	00d58963          	beq	a1,a3,80000f1a <safestrcpy+0x28>
    80000f0c:	0585                	addi	a1,a1,1
    80000f0e:	0785                	addi	a5,a5,1
    80000f10:	fff5c703          	lbu	a4,-1(a1)
    80000f14:	fee78fa3          	sb	a4,-1(a5)
    80000f18:	fb65                	bnez	a4,80000f08 <safestrcpy+0x16>
    ;
  *s = 0;
    80000f1a:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f1e:	6422                	ld	s0,8(sp)
    80000f20:	0141                	addi	sp,sp,16
    80000f22:	8082                	ret

0000000080000f24 <strlen>:

int
strlen(const char *s)
{
    80000f24:	1141                	addi	sp,sp,-16
    80000f26:	e422                	sd	s0,8(sp)
    80000f28:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f2a:	00054783          	lbu	a5,0(a0)
    80000f2e:	cf91                	beqz	a5,80000f4a <strlen+0x26>
    80000f30:	0505                	addi	a0,a0,1
    80000f32:	87aa                	mv	a5,a0
    80000f34:	4685                	li	a3,1
    80000f36:	9e89                	subw	a3,a3,a0
    80000f38:	00f6853b          	addw	a0,a3,a5
    80000f3c:	0785                	addi	a5,a5,1
    80000f3e:	fff7c703          	lbu	a4,-1(a5)
    80000f42:	fb7d                	bnez	a4,80000f38 <strlen+0x14>
    ;
  return n;
}
    80000f44:	6422                	ld	s0,8(sp)
    80000f46:	0141                	addi	sp,sp,16
    80000f48:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f4a:	4501                	li	a0,0
    80000f4c:	bfe5                	j	80000f44 <strlen+0x20>

0000000080000f4e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f4e:	1141                	addi	sp,sp,-16
    80000f50:	e406                	sd	ra,8(sp)
    80000f52:	e022                	sd	s0,0(sp)
    80000f54:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f56:	00001097          	auipc	ra,0x1
    80000f5a:	d86080e7          	jalr	-634(ra) # 80001cdc <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f5e:	00008717          	auipc	a4,0x8
    80000f62:	a0a70713          	addi	a4,a4,-1526 # 80008968 <started>
  if(cpuid() == 0){
    80000f66:	c139                	beqz	a0,80000fac <main+0x5e>
    while(started == 0)
    80000f68:	431c                	lw	a5,0(a4)
    80000f6a:	2781                	sext.w	a5,a5
    80000f6c:	dff5                	beqz	a5,80000f68 <main+0x1a>
      ;
    __sync_synchronize();
    80000f6e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f72:	00001097          	auipc	ra,0x1
    80000f76:	d6a080e7          	jalr	-662(ra) # 80001cdc <cpuid>
    80000f7a:	85aa                	mv	a1,a0
    80000f7c:	00007517          	auipc	a0,0x7
    80000f80:	13c50513          	addi	a0,a0,316 # 800080b8 <digits+0x78>
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	606080e7          	jalr	1542(ra) # 8000058a <printf>
    kvminithart();    // turn on paging
    80000f8c:	00000097          	auipc	ra,0x0
    80000f90:	0d8080e7          	jalr	216(ra) # 80001064 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f94:	00002097          	auipc	ra,0x2
    80000f98:	f10080e7          	jalr	-240(ra) # 80002ea4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f9c:	00005097          	auipc	ra,0x5
    80000fa0:	594080e7          	jalr	1428(ra) # 80006530 <plicinithart>
  }

  scheduler();        
    80000fa4:	00001097          	auipc	ra,0x1
    80000fa8:	45e080e7          	jalr	1118(ra) # 80002402 <scheduler>
    consoleinit();
    80000fac:	fffff097          	auipc	ra,0xfffff
    80000fb0:	4a4080e7          	jalr	1188(ra) # 80000450 <consoleinit>
    printfinit();
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	7b6080e7          	jalr	1974(ra) # 8000076a <printfinit>
    printf("\n");
    80000fbc:	00007517          	auipc	a0,0x7
    80000fc0:	10c50513          	addi	a0,a0,268 # 800080c8 <digits+0x88>
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	5c6080e7          	jalr	1478(ra) # 8000058a <printf>
    printf("xv6 kernel is booting\n");
    80000fcc:	00007517          	auipc	a0,0x7
    80000fd0:	0d450513          	addi	a0,a0,212 # 800080a0 <digits+0x60>
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	5b6080e7          	jalr	1462(ra) # 8000058a <printf>
    printf("\n");
    80000fdc:	00007517          	auipc	a0,0x7
    80000fe0:	0ec50513          	addi	a0,a0,236 # 800080c8 <digits+0x88>
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	5a6080e7          	jalr	1446(ra) # 8000058a <printf>
    kinit();         // physical page allocator
    80000fec:	00000097          	auipc	ra,0x0
    80000ff0:	b76080e7          	jalr	-1162(ra) # 80000b62 <kinit>
    kvminit();       // create kernel page table
    80000ff4:	00000097          	auipc	ra,0x0
    80000ff8:	326080e7          	jalr	806(ra) # 8000131a <kvminit>
    kvminithart();   // turn on paging
    80000ffc:	00000097          	auipc	ra,0x0
    80001000:	068080e7          	jalr	104(ra) # 80001064 <kvminithart>
    procinit();      // process table
    80001004:	00001097          	auipc	ra,0x1
    80001008:	c24080e7          	jalr	-988(ra) # 80001c28 <procinit>
    trapinit();      // trap vectors
    8000100c:	00002097          	auipc	ra,0x2
    80001010:	e70080e7          	jalr	-400(ra) # 80002e7c <trapinit>
    trapinithart();  // install kernel trap vector
    80001014:	00002097          	auipc	ra,0x2
    80001018:	e90080e7          	jalr	-368(ra) # 80002ea4 <trapinithart>
    plicinit();      // set up interrupt controller
    8000101c:	00005097          	auipc	ra,0x5
    80001020:	4fe080e7          	jalr	1278(ra) # 8000651a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001024:	00005097          	auipc	ra,0x5
    80001028:	50c080e7          	jalr	1292(ra) # 80006530 <plicinithart>
    binit();         // buffer cache
    8000102c:	00002097          	auipc	ra,0x2
    80001030:	6a4080e7          	jalr	1700(ra) # 800036d0 <binit>
    iinit();         // inode table
    80001034:	00003097          	auipc	ra,0x3
    80001038:	d44080e7          	jalr	-700(ra) # 80003d78 <iinit>
    fileinit();      // file table
    8000103c:	00004097          	auipc	ra,0x4
    80001040:	cea080e7          	jalr	-790(ra) # 80004d26 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001044:	00005097          	auipc	ra,0x5
    80001048:	5f4080e7          	jalr	1524(ra) # 80006638 <virtio_disk_init>
    userinit();      // first user process
    8000104c:	00001097          	auipc	ra,0x1
    80001050:	fa6080e7          	jalr	-90(ra) # 80001ff2 <userinit>
    __sync_synchronize();
    80001054:	0ff0000f          	fence
    started = 1;
    80001058:	4785                	li	a5,1
    8000105a:	00008717          	auipc	a4,0x8
    8000105e:	90f72723          	sw	a5,-1778(a4) # 80008968 <started>
    80001062:	b789                	j	80000fa4 <main+0x56>

0000000080001064 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001064:	1141                	addi	sp,sp,-16
    80001066:	e422                	sd	s0,8(sp)
    80001068:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000106a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000106e:	00008797          	auipc	a5,0x8
    80001072:	9027b783          	ld	a5,-1790(a5) # 80008970 <kernel_pagetable>
    80001076:	83b1                	srli	a5,a5,0xc
    80001078:	577d                	li	a4,-1
    8000107a:	177e                	slli	a4,a4,0x3f
    8000107c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000107e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001082:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001086:	6422                	ld	s0,8(sp)
    80001088:	0141                	addi	sp,sp,16
    8000108a:	8082                	ret

000000008000108c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000108c:	7139                	addi	sp,sp,-64
    8000108e:	fc06                	sd	ra,56(sp)
    80001090:	f822                	sd	s0,48(sp)
    80001092:	f426                	sd	s1,40(sp)
    80001094:	f04a                	sd	s2,32(sp)
    80001096:	ec4e                	sd	s3,24(sp)
    80001098:	e852                	sd	s4,16(sp)
    8000109a:	e456                	sd	s5,8(sp)
    8000109c:	e05a                	sd	s6,0(sp)
    8000109e:	0080                	addi	s0,sp,64
    800010a0:	84aa                	mv	s1,a0
    800010a2:	89ae                	mv	s3,a1
    800010a4:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800010a6:	57fd                	li	a5,-1
    800010a8:	83e9                	srli	a5,a5,0x1a
    800010aa:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800010ac:	4b31                	li	s6,12
  if(va >= MAXVA)
    800010ae:	04b7f263          	bgeu	a5,a1,800010f2 <walk+0x66>
    panic("walk");
    800010b2:	00007517          	auipc	a0,0x7
    800010b6:	01e50513          	addi	a0,a0,30 # 800080d0 <digits+0x90>
    800010ba:	fffff097          	auipc	ra,0xfffff
    800010be:	486080e7          	jalr	1158(ra) # 80000540 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010c2:	060a8663          	beqz	s5,8000112e <walk+0xa2>
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	ad8080e7          	jalr	-1320(ra) # 80000b9e <kalloc>
    800010ce:	84aa                	mv	s1,a0
    800010d0:	c529                	beqz	a0,8000111a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800010d2:	6605                	lui	a2,0x1
    800010d4:	4581                	li	a1,0
    800010d6:	00000097          	auipc	ra,0x0
    800010da:	cd2080e7          	jalr	-814(ra) # 80000da8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010de:	00c4d793          	srli	a5,s1,0xc
    800010e2:	07aa                	slli	a5,a5,0xa
    800010e4:	0017e793          	ori	a5,a5,1
    800010e8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800010ec:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ff94ff7>
    800010ee:	036a0063          	beq	s4,s6,8000110e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800010f2:	0149d933          	srl	s2,s3,s4
    800010f6:	1ff97913          	andi	s2,s2,511
    800010fa:	090e                	slli	s2,s2,0x3
    800010fc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010fe:	00093483          	ld	s1,0(s2)
    80001102:	0014f793          	andi	a5,s1,1
    80001106:	dfd5                	beqz	a5,800010c2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001108:	80a9                	srli	s1,s1,0xa
    8000110a:	04b2                	slli	s1,s1,0xc
    8000110c:	b7c5                	j	800010ec <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000110e:	00c9d513          	srli	a0,s3,0xc
    80001112:	1ff57513          	andi	a0,a0,511
    80001116:	050e                	slli	a0,a0,0x3
    80001118:	9526                	add	a0,a0,s1
}
    8000111a:	70e2                	ld	ra,56(sp)
    8000111c:	7442                	ld	s0,48(sp)
    8000111e:	74a2                	ld	s1,40(sp)
    80001120:	7902                	ld	s2,32(sp)
    80001122:	69e2                	ld	s3,24(sp)
    80001124:	6a42                	ld	s4,16(sp)
    80001126:	6aa2                	ld	s5,8(sp)
    80001128:	6b02                	ld	s6,0(sp)
    8000112a:	6121                	addi	sp,sp,64
    8000112c:	8082                	ret
        return 0;
    8000112e:	4501                	li	a0,0
    80001130:	b7ed                	j	8000111a <walk+0x8e>

0000000080001132 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001132:	57fd                	li	a5,-1
    80001134:	83e9                	srli	a5,a5,0x1a
    80001136:	00b7f463          	bgeu	a5,a1,8000113e <walkaddr+0xc>
    return 0;
    8000113a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000113c:	8082                	ret
{
    8000113e:	1141                	addi	sp,sp,-16
    80001140:	e406                	sd	ra,8(sp)
    80001142:	e022                	sd	s0,0(sp)
    80001144:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001146:	4601                	li	a2,0
    80001148:	00000097          	auipc	ra,0x0
    8000114c:	f44080e7          	jalr	-188(ra) # 8000108c <walk>
  if(pte == 0)
    80001150:	c105                	beqz	a0,80001170 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001152:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001154:	0117f693          	andi	a3,a5,17
    80001158:	4745                	li	a4,17
    return 0;
    8000115a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000115c:	00e68663          	beq	a3,a4,80001168 <walkaddr+0x36>
}
    80001160:	60a2                	ld	ra,8(sp)
    80001162:	6402                	ld	s0,0(sp)
    80001164:	0141                	addi	sp,sp,16
    80001166:	8082                	ret
  pa = PTE2PA(*pte);
    80001168:	83a9                	srli	a5,a5,0xa
    8000116a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000116e:	bfcd                	j	80001160 <walkaddr+0x2e>
    return 0;
    80001170:	4501                	li	a0,0
    80001172:	b7fd                	j	80001160 <walkaddr+0x2e>

0000000080001174 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001174:	715d                	addi	sp,sp,-80
    80001176:	e486                	sd	ra,72(sp)
    80001178:	e0a2                	sd	s0,64(sp)
    8000117a:	fc26                	sd	s1,56(sp)
    8000117c:	f84a                	sd	s2,48(sp)
    8000117e:	f44e                	sd	s3,40(sp)
    80001180:	f052                	sd	s4,32(sp)
    80001182:	ec56                	sd	s5,24(sp)
    80001184:	e85a                	sd	s6,16(sp)
    80001186:	e45e                	sd	s7,8(sp)
    80001188:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000118a:	c639                	beqz	a2,800011d8 <mappages+0x64>
    8000118c:	8aaa                	mv	s5,a0
    8000118e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001190:	777d                	lui	a4,0xfffff
    80001192:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001196:	fff58993          	addi	s3,a1,-1
    8000119a:	99b2                	add	s3,s3,a2
    8000119c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800011a0:	893e                	mv	s2,a5
    800011a2:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800011a6:	6b85                	lui	s7,0x1
    800011a8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800011ac:	4605                	li	a2,1
    800011ae:	85ca                	mv	a1,s2
    800011b0:	8556                	mv	a0,s5
    800011b2:	00000097          	auipc	ra,0x0
    800011b6:	eda080e7          	jalr	-294(ra) # 8000108c <walk>
    800011ba:	cd1d                	beqz	a0,800011f8 <mappages+0x84>
    if(*pte & PTE_V)
    800011bc:	611c                	ld	a5,0(a0)
    800011be:	8b85                	andi	a5,a5,1
    800011c0:	e785                	bnez	a5,800011e8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011c2:	80b1                	srli	s1,s1,0xc
    800011c4:	04aa                	slli	s1,s1,0xa
    800011c6:	0164e4b3          	or	s1,s1,s6
    800011ca:	0014e493          	ori	s1,s1,1
    800011ce:	e104                	sd	s1,0(a0)
    if(a == last)
    800011d0:	05390063          	beq	s2,s3,80001210 <mappages+0x9c>
    a += PGSIZE;
    800011d4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800011d6:	bfc9                	j	800011a8 <mappages+0x34>
    panic("mappages: size");
    800011d8:	00007517          	auipc	a0,0x7
    800011dc:	f0050513          	addi	a0,a0,-256 # 800080d8 <digits+0x98>
    800011e0:	fffff097          	auipc	ra,0xfffff
    800011e4:	360080e7          	jalr	864(ra) # 80000540 <panic>
      panic("mappages: remap");
    800011e8:	00007517          	auipc	a0,0x7
    800011ec:	f0050513          	addi	a0,a0,-256 # 800080e8 <digits+0xa8>
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	350080e7          	jalr	848(ra) # 80000540 <panic>
      return -1;
    800011f8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011fa:	60a6                	ld	ra,72(sp)
    800011fc:	6406                	ld	s0,64(sp)
    800011fe:	74e2                	ld	s1,56(sp)
    80001200:	7942                	ld	s2,48(sp)
    80001202:	79a2                	ld	s3,40(sp)
    80001204:	7a02                	ld	s4,32(sp)
    80001206:	6ae2                	ld	s5,24(sp)
    80001208:	6b42                	ld	s6,16(sp)
    8000120a:	6ba2                	ld	s7,8(sp)
    8000120c:	6161                	addi	sp,sp,80
    8000120e:	8082                	ret
  return 0;
    80001210:	4501                	li	a0,0
    80001212:	b7e5                	j	800011fa <mappages+0x86>

0000000080001214 <kvmmap>:
{
    80001214:	1141                	addi	sp,sp,-16
    80001216:	e406                	sd	ra,8(sp)
    80001218:	e022                	sd	s0,0(sp)
    8000121a:	0800                	addi	s0,sp,16
    8000121c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000121e:	86b2                	mv	a3,a2
    80001220:	863e                	mv	a2,a5
    80001222:	00000097          	auipc	ra,0x0
    80001226:	f52080e7          	jalr	-174(ra) # 80001174 <mappages>
    8000122a:	e509                	bnez	a0,80001234 <kvmmap+0x20>
}
    8000122c:	60a2                	ld	ra,8(sp)
    8000122e:	6402                	ld	s0,0(sp)
    80001230:	0141                	addi	sp,sp,16
    80001232:	8082                	ret
    panic("kvmmap");
    80001234:	00007517          	auipc	a0,0x7
    80001238:	ec450513          	addi	a0,a0,-316 # 800080f8 <digits+0xb8>
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	304080e7          	jalr	772(ra) # 80000540 <panic>

0000000080001244 <kvmmake>:
{
    80001244:	1101                	addi	sp,sp,-32
    80001246:	ec06                	sd	ra,24(sp)
    80001248:	e822                	sd	s0,16(sp)
    8000124a:	e426                	sd	s1,8(sp)
    8000124c:	e04a                	sd	s2,0(sp)
    8000124e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001250:	00000097          	auipc	ra,0x0
    80001254:	94e080e7          	jalr	-1714(ra) # 80000b9e <kalloc>
    80001258:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000125a:	6605                	lui	a2,0x1
    8000125c:	4581                	li	a1,0
    8000125e:	00000097          	auipc	ra,0x0
    80001262:	b4a080e7          	jalr	-1206(ra) # 80000da8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001266:	4719                	li	a4,6
    80001268:	6685                	lui	a3,0x1
    8000126a:	10000637          	lui	a2,0x10000
    8000126e:	100005b7          	lui	a1,0x10000
    80001272:	8526                	mv	a0,s1
    80001274:	00000097          	auipc	ra,0x0
    80001278:	fa0080e7          	jalr	-96(ra) # 80001214 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000127c:	4719                	li	a4,6
    8000127e:	6685                	lui	a3,0x1
    80001280:	10001637          	lui	a2,0x10001
    80001284:	100015b7          	lui	a1,0x10001
    80001288:	8526                	mv	a0,s1
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	f8a080e7          	jalr	-118(ra) # 80001214 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001292:	4719                	li	a4,6
    80001294:	004006b7          	lui	a3,0x400
    80001298:	0c000637          	lui	a2,0xc000
    8000129c:	0c0005b7          	lui	a1,0xc000
    800012a0:	8526                	mv	a0,s1
    800012a2:	00000097          	auipc	ra,0x0
    800012a6:	f72080e7          	jalr	-142(ra) # 80001214 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012aa:	00007917          	auipc	s2,0x7
    800012ae:	d5690913          	addi	s2,s2,-682 # 80008000 <etext>
    800012b2:	4729                	li	a4,10
    800012b4:	80007697          	auipc	a3,0x80007
    800012b8:	d4c68693          	addi	a3,a3,-692 # 8000 <_entry-0x7fff8000>
    800012bc:	4605                	li	a2,1
    800012be:	067e                	slli	a2,a2,0x1f
    800012c0:	85b2                	mv	a1,a2
    800012c2:	8526                	mv	a0,s1
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	f50080e7          	jalr	-176(ra) # 80001214 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800012cc:	4719                	li	a4,6
    800012ce:	46c5                	li	a3,17
    800012d0:	06ee                	slli	a3,a3,0x1b
    800012d2:	412686b3          	sub	a3,a3,s2
    800012d6:	864a                	mv	a2,s2
    800012d8:	85ca                	mv	a1,s2
    800012da:	8526                	mv	a0,s1
    800012dc:	00000097          	auipc	ra,0x0
    800012e0:	f38080e7          	jalr	-200(ra) # 80001214 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012e4:	4729                	li	a4,10
    800012e6:	6685                	lui	a3,0x1
    800012e8:	00006617          	auipc	a2,0x6
    800012ec:	d1860613          	addi	a2,a2,-744 # 80007000 <_trampoline>
    800012f0:	040005b7          	lui	a1,0x4000
    800012f4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012f6:	05b2                	slli	a1,a1,0xc
    800012f8:	8526                	mv	a0,s1
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	f1a080e7          	jalr	-230(ra) # 80001214 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001302:	8526                	mv	a0,s1
    80001304:	00001097          	auipc	ra,0x1
    80001308:	88e080e7          	jalr	-1906(ra) # 80001b92 <proc_mapstacks>
}
    8000130c:	8526                	mv	a0,s1
    8000130e:	60e2                	ld	ra,24(sp)
    80001310:	6442                	ld	s0,16(sp)
    80001312:	64a2                	ld	s1,8(sp)
    80001314:	6902                	ld	s2,0(sp)
    80001316:	6105                	addi	sp,sp,32
    80001318:	8082                	ret

000000008000131a <kvminit>:
{
    8000131a:	1141                	addi	sp,sp,-16
    8000131c:	e406                	sd	ra,8(sp)
    8000131e:	e022                	sd	s0,0(sp)
    80001320:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001322:	00000097          	auipc	ra,0x0
    80001326:	f22080e7          	jalr	-222(ra) # 80001244 <kvmmake>
    8000132a:	00007797          	auipc	a5,0x7
    8000132e:	64a7b323          	sd	a0,1606(a5) # 80008970 <kernel_pagetable>
}
    80001332:	60a2                	ld	ra,8(sp)
    80001334:	6402                	ld	s0,0(sp)
    80001336:	0141                	addi	sp,sp,16
    80001338:	8082                	ret

000000008000133a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000133a:	715d                	addi	sp,sp,-80
    8000133c:	e486                	sd	ra,72(sp)
    8000133e:	e0a2                	sd	s0,64(sp)
    80001340:	fc26                	sd	s1,56(sp)
    80001342:	f84a                	sd	s2,48(sp)
    80001344:	f44e                	sd	s3,40(sp)
    80001346:	f052                	sd	s4,32(sp)
    80001348:	ec56                	sd	s5,24(sp)
    8000134a:	e85a                	sd	s6,16(sp)
    8000134c:	e45e                	sd	s7,8(sp)
    8000134e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001350:	03459793          	slli	a5,a1,0x34
    80001354:	e795                	bnez	a5,80001380 <uvmunmap+0x46>
    80001356:	8a2a                	mv	s4,a0
    80001358:	892e                	mv	s2,a1
    8000135a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000135c:	0632                	slli	a2,a2,0xc
    8000135e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001362:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001364:	6b05                	lui	s6,0x1
    80001366:	0735e263          	bltu	a1,s3,800013ca <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000136a:	60a6                	ld	ra,72(sp)
    8000136c:	6406                	ld	s0,64(sp)
    8000136e:	74e2                	ld	s1,56(sp)
    80001370:	7942                	ld	s2,48(sp)
    80001372:	79a2                	ld	s3,40(sp)
    80001374:	7a02                	ld	s4,32(sp)
    80001376:	6ae2                	ld	s5,24(sp)
    80001378:	6b42                	ld	s6,16(sp)
    8000137a:	6ba2                	ld	s7,8(sp)
    8000137c:	6161                	addi	sp,sp,80
    8000137e:	8082                	ret
    panic("uvmunmap: not aligned");
    80001380:	00007517          	auipc	a0,0x7
    80001384:	d8050513          	addi	a0,a0,-640 # 80008100 <digits+0xc0>
    80001388:	fffff097          	auipc	ra,0xfffff
    8000138c:	1b8080e7          	jalr	440(ra) # 80000540 <panic>
      panic("uvmunmap: walk");
    80001390:	00007517          	auipc	a0,0x7
    80001394:	d8850513          	addi	a0,a0,-632 # 80008118 <digits+0xd8>
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	1a8080e7          	jalr	424(ra) # 80000540 <panic>
      panic("uvmunmap: not mapped");
    800013a0:	00007517          	auipc	a0,0x7
    800013a4:	d8850513          	addi	a0,a0,-632 # 80008128 <digits+0xe8>
    800013a8:	fffff097          	auipc	ra,0xfffff
    800013ac:	198080e7          	jalr	408(ra) # 80000540 <panic>
      panic("uvmunmap: not a leaf");
    800013b0:	00007517          	auipc	a0,0x7
    800013b4:	d9050513          	addi	a0,a0,-624 # 80008140 <digits+0x100>
    800013b8:	fffff097          	auipc	ra,0xfffff
    800013bc:	188080e7          	jalr	392(ra) # 80000540 <panic>
    *pte = 0;
    800013c0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013c4:	995a                	add	s2,s2,s6
    800013c6:	fb3972e3          	bgeu	s2,s3,8000136a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800013ca:	4601                	li	a2,0
    800013cc:	85ca                	mv	a1,s2
    800013ce:	8552                	mv	a0,s4
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	cbc080e7          	jalr	-836(ra) # 8000108c <walk>
    800013d8:	84aa                	mv	s1,a0
    800013da:	d95d                	beqz	a0,80001390 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800013dc:	6108                	ld	a0,0(a0)
    800013de:	00157793          	andi	a5,a0,1
    800013e2:	dfdd                	beqz	a5,800013a0 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800013e4:	3ff57793          	andi	a5,a0,1023
    800013e8:	fd7784e3          	beq	a5,s7,800013b0 <uvmunmap+0x76>
    if(do_free){
    800013ec:	fc0a8ae3          	beqz	s5,800013c0 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800013f0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800013f2:	0532                	slli	a0,a0,0xc
    800013f4:	fffff097          	auipc	ra,0xfffff
    800013f8:	644080e7          	jalr	1604(ra) # 80000a38 <kfree>
    800013fc:	b7d1                	j	800013c0 <uvmunmap+0x86>

00000000800013fe <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013fe:	1101                	addi	sp,sp,-32
    80001400:	ec06                	sd	ra,24(sp)
    80001402:	e822                	sd	s0,16(sp)
    80001404:	e426                	sd	s1,8(sp)
    80001406:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001408:	fffff097          	auipc	ra,0xfffff
    8000140c:	796080e7          	jalr	1942(ra) # 80000b9e <kalloc>
    80001410:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001412:	c519                	beqz	a0,80001420 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001414:	6605                	lui	a2,0x1
    80001416:	4581                	li	a1,0
    80001418:	00000097          	auipc	ra,0x0
    8000141c:	990080e7          	jalr	-1648(ra) # 80000da8 <memset>
  return pagetable;
}
    80001420:	8526                	mv	a0,s1
    80001422:	60e2                	ld	ra,24(sp)
    80001424:	6442                	ld	s0,16(sp)
    80001426:	64a2                	ld	s1,8(sp)
    80001428:	6105                	addi	sp,sp,32
    8000142a:	8082                	ret

000000008000142c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000142c:	7179                	addi	sp,sp,-48
    8000142e:	f406                	sd	ra,40(sp)
    80001430:	f022                	sd	s0,32(sp)
    80001432:	ec26                	sd	s1,24(sp)
    80001434:	e84a                	sd	s2,16(sp)
    80001436:	e44e                	sd	s3,8(sp)
    80001438:	e052                	sd	s4,0(sp)
    8000143a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000143c:	6785                	lui	a5,0x1
    8000143e:	04f67863          	bgeu	a2,a5,8000148e <uvmfirst+0x62>
    80001442:	8a2a                	mv	s4,a0
    80001444:	89ae                	mv	s3,a1
    80001446:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001448:	fffff097          	auipc	ra,0xfffff
    8000144c:	756080e7          	jalr	1878(ra) # 80000b9e <kalloc>
    80001450:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001452:	6605                	lui	a2,0x1
    80001454:	4581                	li	a1,0
    80001456:	00000097          	auipc	ra,0x0
    8000145a:	952080e7          	jalr	-1710(ra) # 80000da8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000145e:	4779                	li	a4,30
    80001460:	86ca                	mv	a3,s2
    80001462:	6605                	lui	a2,0x1
    80001464:	4581                	li	a1,0
    80001466:	8552                	mv	a0,s4
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	d0c080e7          	jalr	-756(ra) # 80001174 <mappages>
  memmove(mem, src, sz);
    80001470:	8626                	mv	a2,s1
    80001472:	85ce                	mv	a1,s3
    80001474:	854a                	mv	a0,s2
    80001476:	00000097          	auipc	ra,0x0
    8000147a:	98e080e7          	jalr	-1650(ra) # 80000e04 <memmove>
}
    8000147e:	70a2                	ld	ra,40(sp)
    80001480:	7402                	ld	s0,32(sp)
    80001482:	64e2                	ld	s1,24(sp)
    80001484:	6942                	ld	s2,16(sp)
    80001486:	69a2                	ld	s3,8(sp)
    80001488:	6a02                	ld	s4,0(sp)
    8000148a:	6145                	addi	sp,sp,48
    8000148c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000148e:	00007517          	auipc	a0,0x7
    80001492:	cca50513          	addi	a0,a0,-822 # 80008158 <digits+0x118>
    80001496:	fffff097          	auipc	ra,0xfffff
    8000149a:	0aa080e7          	jalr	170(ra) # 80000540 <panic>

000000008000149e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
  uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000149e:	1101                	addi	sp,sp,-32
    800014a0:	ec06                	sd	ra,24(sp)
    800014a2:	e822                	sd	s0,16(sp)
    800014a4:	e426                	sd	s1,8(sp)
    800014a6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800014a8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014aa:	00b67d63          	bgeu	a2,a1,800014c4 <uvmdealloc+0x26>
    800014ae:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014b0:	6785                	lui	a5,0x1
    800014b2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014b4:	00f60733          	add	a4,a2,a5
    800014b8:	76fd                	lui	a3,0xfffff
    800014ba:	8f75                	and	a4,a4,a3
    800014bc:	97ae                	add	a5,a5,a1
    800014be:	8ff5                	and	a5,a5,a3
    800014c0:	00f76863          	bltu	a4,a5,800014d0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800014c4:	8526                	mv	a0,s1
    800014c6:	60e2                	ld	ra,24(sp)
    800014c8:	6442                	ld	s0,16(sp)
    800014ca:	64a2                	ld	s1,8(sp)
    800014cc:	6105                	addi	sp,sp,32
    800014ce:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800014d0:	8f99                	sub	a5,a5,a4
    800014d2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014d4:	4685                	li	a3,1
    800014d6:	0007861b          	sext.w	a2,a5
    800014da:	85ba                	mv	a1,a4
    800014dc:	00000097          	auipc	ra,0x0
    800014e0:	e5e080e7          	jalr	-418(ra) # 8000133a <uvmunmap>
    800014e4:	b7c5                	j	800014c4 <uvmdealloc+0x26>

00000000800014e6 <uvmalloc>:
  if(newsz < oldsz)
    800014e6:	0ab66563          	bltu	a2,a1,80001590 <uvmalloc+0xaa>
{
    800014ea:	7139                	addi	sp,sp,-64
    800014ec:	fc06                	sd	ra,56(sp)
    800014ee:	f822                	sd	s0,48(sp)
    800014f0:	f426                	sd	s1,40(sp)
    800014f2:	f04a                	sd	s2,32(sp)
    800014f4:	ec4e                	sd	s3,24(sp)
    800014f6:	e852                	sd	s4,16(sp)
    800014f8:	e456                	sd	s5,8(sp)
    800014fa:	e05a                	sd	s6,0(sp)
    800014fc:	0080                	addi	s0,sp,64
    800014fe:	8aaa                	mv	s5,a0
    80001500:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001502:	6785                	lui	a5,0x1
    80001504:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001506:	95be                	add	a1,a1,a5
    80001508:	77fd                	lui	a5,0xfffff
    8000150a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000150e:	08c9f363          	bgeu	s3,a2,80001594 <uvmalloc+0xae>
    80001512:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001514:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001518:	fffff097          	auipc	ra,0xfffff
    8000151c:	686080e7          	jalr	1670(ra) # 80000b9e <kalloc>
    80001520:	84aa                	mv	s1,a0
    if(mem == 0){
    80001522:	c51d                	beqz	a0,80001550 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001524:	6605                	lui	a2,0x1
    80001526:	4581                	li	a1,0
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	880080e7          	jalr	-1920(ra) # 80000da8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001530:	875a                	mv	a4,s6
    80001532:	86a6                	mv	a3,s1
    80001534:	6605                	lui	a2,0x1
    80001536:	85ca                	mv	a1,s2
    80001538:	8556                	mv	a0,s5
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	c3a080e7          	jalr	-966(ra) # 80001174 <mappages>
    80001542:	e90d                	bnez	a0,80001574 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001544:	6785                	lui	a5,0x1
    80001546:	993e                	add	s2,s2,a5
    80001548:	fd4968e3          	bltu	s2,s4,80001518 <uvmalloc+0x32>
  return newsz;
    8000154c:	8552                	mv	a0,s4
    8000154e:	a809                	j	80001560 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80001550:	864e                	mv	a2,s3
    80001552:	85ca                	mv	a1,s2
    80001554:	8556                	mv	a0,s5
    80001556:	00000097          	auipc	ra,0x0
    8000155a:	f48080e7          	jalr	-184(ra) # 8000149e <uvmdealloc>
      return 0;
    8000155e:	4501                	li	a0,0
}
    80001560:	70e2                	ld	ra,56(sp)
    80001562:	7442                	ld	s0,48(sp)
    80001564:	74a2                	ld	s1,40(sp)
    80001566:	7902                	ld	s2,32(sp)
    80001568:	69e2                	ld	s3,24(sp)
    8000156a:	6a42                	ld	s4,16(sp)
    8000156c:	6aa2                	ld	s5,8(sp)
    8000156e:	6b02                	ld	s6,0(sp)
    80001570:	6121                	addi	sp,sp,64
    80001572:	8082                	ret
      kfree(mem);
    80001574:	8526                	mv	a0,s1
    80001576:	fffff097          	auipc	ra,0xfffff
    8000157a:	4c2080e7          	jalr	1218(ra) # 80000a38 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000157e:	864e                	mv	a2,s3
    80001580:	85ca                	mv	a1,s2
    80001582:	8556                	mv	a0,s5
    80001584:	00000097          	auipc	ra,0x0
    80001588:	f1a080e7          	jalr	-230(ra) # 8000149e <uvmdealloc>
      return 0;
    8000158c:	4501                	li	a0,0
    8000158e:	bfc9                	j	80001560 <uvmalloc+0x7a>
    return oldsz;
    80001590:	852e                	mv	a0,a1
}
    80001592:	8082                	ret
  return newsz;
    80001594:	8532                	mv	a0,a2
    80001596:	b7e9                	j	80001560 <uvmalloc+0x7a>

0000000080001598 <uvmthreaded_alloc>:
  if(newsz < oldsz)
    80001598:	10b66f63          	bltu	a2,a1,800016b6 <uvmthreaded_alloc+0x11e>
uvmthreaded_alloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz, uint64 xperm) {
    8000159c:	711d                	addi	sp,sp,-96
    8000159e:	ec86                	sd	ra,88(sp)
    800015a0:	e8a2                	sd	s0,80(sp)
    800015a2:	e4a6                	sd	s1,72(sp)
    800015a4:	e0ca                	sd	s2,64(sp)
    800015a6:	fc4e                	sd	s3,56(sp)
    800015a8:	f852                	sd	s4,48(sp)
    800015aa:	f456                	sd	s5,40(sp)
    800015ac:	f05a                	sd	s6,32(sp)
    800015ae:	ec5e                	sd	s7,24(sp)
    800015b0:	e862                	sd	s8,16(sp)
    800015b2:	e466                	sd	s9,8(sp)
    800015b4:	e06a                	sd	s10,0(sp)
    800015b6:	1080                	addi	s0,sp,96
    800015b8:	8b2a                	mv	s6,a0
    800015ba:	8bb2                	mv	s7,a2
  oldsz = PGROUNDUP(oldsz);
    800015bc:	6785                	lui	a5,0x1
    800015be:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015c0:	95be                	add	a1,a1,a5
    800015c2:	77fd                	lui	a5,0xfffff
    800015c4:	00f5fcb3          	and	s9,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015c8:	0eccf963          	bgeu	s9,a2,800016ba <uvmthreaded_alloc+0x122>
  struct proc *p = thread_proc->parent;
    800015cc:	03853d03          	ld	s10,56(a0)
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015d0:	8c66                	mv	s8,s9
    800015d2:	370d0a93          	addi	s5,s10,880
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015d6:	0126e693          	ori	a3,a3,18
    800015da:	0006899b          	sext.w	s3,a3
    mem = kalloc();
    800015de:	fffff097          	auipc	ra,0xfffff
    800015e2:	5c0080e7          	jalr	1472(ra) # 80000b9e <kalloc>
    800015e6:	8a2a                	mv	s4,a0
    if(mem == 0){
    800015e8:	c911                	beqz	a0,800015fc <uvmthreaded_alloc+0x64>
    memset(mem, 0, PGSIZE);
    800015ea:	6605                	lui	a2,0x1
    800015ec:	4581                	li	a1,0
    800015ee:	fffff097          	auipc	ra,0xfffff
    800015f2:	7ba080e7          	jalr	1978(ra) # 80000da8 <memset>
    for (int i = 0; i < MAX_THREADS; i++) {
    800015f6:	170d0493          	addi	s1,s10,368
    800015fa:	a891                	j	8000164e <uvmthreaded_alloc+0xb6>
      uvmdealloc(thread_proc->pagetable, a, oldsz);
    800015fc:	8666                	mv	a2,s9
    800015fe:	85e2                	mv	a1,s8
    80001600:	050b3503          	ld	a0,80(s6) # 1050 <_entry-0x7fffefb0>
    80001604:	00000097          	auipc	ra,0x0
    80001608:	e9a080e7          	jalr	-358(ra) # 8000149e <uvmdealloc>
      return 0;
    8000160c:	4501                	li	a0,0
    8000160e:	a839                	j	8000162c <uvmthreaded_alloc+0x94>
        kfree(mem);
    80001610:	8552                	mv	a0,s4
    80001612:	fffff097          	auipc	ra,0xfffff
    80001616:	426080e7          	jalr	1062(ra) # 80000a38 <kfree>
        uvmdealloc(infant->pagetable, a, oldsz);
    8000161a:	8666                	mv	a2,s9
    8000161c:	85e2                	mv	a1,s8
    8000161e:	05093503          	ld	a0,80(s2)
    80001622:	00000097          	auipc	ra,0x0
    80001626:	e7c080e7          	jalr	-388(ra) # 8000149e <uvmdealloc>
        return 0;
    8000162a:	4501                	li	a0,0
}
    8000162c:	60e6                	ld	ra,88(sp)
    8000162e:	6446                	ld	s0,80(sp)
    80001630:	64a6                	ld	s1,72(sp)
    80001632:	6906                	ld	s2,64(sp)
    80001634:	79e2                	ld	s3,56(sp)
    80001636:	7a42                	ld	s4,48(sp)
    80001638:	7aa2                	ld	s5,40(sp)
    8000163a:	7b02                	ld	s6,32(sp)
    8000163c:	6be2                	ld	s7,24(sp)
    8000163e:	6c42                	ld	s8,16(sp)
    80001640:	6ca2                	ld	s9,8(sp)
    80001642:	6d02                	ld	s10,0(sp)
    80001644:	6125                	addi	sp,sp,96
    80001646:	8082                	ret
    for (int i = 0; i < MAX_THREADS; i++) {
    80001648:	04a1                	addi	s1,s1,8
    8000164a:	03548463          	beq	s1,s5,80001672 <uvmthreaded_alloc+0xda>
      struct proc *infant = p->infant_threads[i];
    8000164e:	0004b903          	ld	s2,0(s1)
      if (infant == 0)
    80001652:	fe090be3          	beqz	s2,80001648 <uvmthreaded_alloc+0xb0>
      if(mappages(infant->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001656:	874e                	mv	a4,s3
    80001658:	86d2                	mv	a3,s4
    8000165a:	6605                	lui	a2,0x1
    8000165c:	85e2                	mv	a1,s8
    8000165e:	05093503          	ld	a0,80(s2)
    80001662:	00000097          	auipc	ra,0x0
    80001666:	b12080e7          	jalr	-1262(ra) # 80001174 <mappages>
    8000166a:	f15d                	bnez	a0,80001610 <uvmthreaded_alloc+0x78>
      infant->sz = newsz;
    8000166c:	05793423          	sd	s7,72(s2)
    80001670:	bfe1                	j	80001648 <uvmthreaded_alloc+0xb0>
    if(mappages(p->pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001672:	874e                	mv	a4,s3
    80001674:	86d2                	mv	a3,s4
    80001676:	6605                	lui	a2,0x1
    80001678:	85e2                	mv	a1,s8
    8000167a:	050d3503          	ld	a0,80(s10)
    8000167e:	00000097          	auipc	ra,0x0
    80001682:	af6080e7          	jalr	-1290(ra) # 80001174 <mappages>
    80001686:	e909                	bnez	a0,80001698 <uvmthreaded_alloc+0x100>
    p->sz = newsz;
    80001688:	057d3423          	sd	s7,72(s10)
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000168c:	6785                	lui	a5,0x1
    8000168e:	9c3e                	add	s8,s8,a5
    80001690:	f57c67e3          	bltu	s8,s7,800015de <uvmthreaded_alloc+0x46>
  return newsz;
    80001694:	855e                	mv	a0,s7
    80001696:	bf59                	j	8000162c <uvmthreaded_alloc+0x94>
      kfree(mem);
    80001698:	8552                	mv	a0,s4
    8000169a:	fffff097          	auipc	ra,0xfffff
    8000169e:	39e080e7          	jalr	926(ra) # 80000a38 <kfree>
      uvmdealloc(p->pagetable, a, oldsz);
    800016a2:	8666                	mv	a2,s9
    800016a4:	85e2                	mv	a1,s8
    800016a6:	050d3503          	ld	a0,80(s10)
    800016aa:	00000097          	auipc	ra,0x0
    800016ae:	df4080e7          	jalr	-524(ra) # 8000149e <uvmdealloc>
      return 0;
    800016b2:	4501                	li	a0,0
    800016b4:	bfa5                	j	8000162c <uvmthreaded_alloc+0x94>
    return oldsz;
    800016b6:	852e                	mv	a0,a1
}
    800016b8:	8082                	ret
  return newsz;
    800016ba:	8532                	mv	a0,a2
    800016bc:	bf85                	j	8000162c <uvmthreaded_alloc+0x94>

00000000800016be <uvmthreaded_dealloc>:

uint64
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
  struct proc *p = thread_proc->parent;

  if(newsz >= oldsz)
    800016be:	0ab67163          	bgeu	a2,a1,80001760 <uvmthreaded_dealloc+0xa2>
uvmthreaded_dealloc(struct proc *thread_proc, uint64 oldsz, uint64 newsz) {
    800016c2:	715d                	addi	sp,sp,-80
    800016c4:	e486                	sd	ra,72(sp)
    800016c6:	e0a2                	sd	s0,64(sp)
    800016c8:	fc26                	sd	s1,56(sp)
    800016ca:	f84a                	sd	s2,48(sp)
    800016cc:	f44e                	sd	s3,40(sp)
    800016ce:	f052                	sd	s4,32(sp)
    800016d0:	ec56                	sd	s5,24(sp)
    800016d2:	e85a                	sd	s6,16(sp)
    800016d4:	e45e                	sd	s7,8(sp)
    800016d6:	e062                	sd	s8,0(sp)
    800016d8:	0880                	addi	s0,sp,80
    800016da:	8ab2                	mv	s5,a2
  struct proc *p = thread_proc->parent;
    800016dc:	03853c03          	ld	s8,56(a0)
    return oldsz;

  int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800016e0:	6785                	lui	a5,0x1
    800016e2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800016e4:	95be                	add	a1,a1,a5
    800016e6:	777d                	lui	a4,0xfffff
    800016e8:	00e5fb33          	and	s6,a1,a4
    800016ec:	97b2                	add	a5,a5,a2
    800016ee:	00e7f9b3          	and	s3,a5,a4
    800016f2:	413b0bb3          	sub	s7,s6,s3
    800016f6:	00cbdb93          	srli	s7,s7,0xc
    800016fa:	2b81                	sext.w	s7,s7

  for (int i = 0; i < MAX_THREADS; i++) {
    800016fc:	170c0493          	addi	s1,s8,368
    80001700:	370c0a13          	addi	s4,s8,880
    80001704:	a031                	j	80001710 <uvmthreaded_dealloc+0x52>
      continue;

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    }
    infant->sz = newsz;
    80001706:	05593423          	sd	s5,72(s2)
  for (int i = 0; i < MAX_THREADS; i++) {
    8000170a:	04a1                	addi	s1,s1,8
    8000170c:	03448263          	beq	s1,s4,80001730 <uvmthreaded_dealloc+0x72>
    struct proc *infant = p->infant_threads[i];
    80001710:	0004b903          	ld	s2,0(s1)
    if (infant == 0)
    80001714:	fe090be3          	beqz	s2,8000170a <uvmthreaded_dealloc+0x4c>
    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){ //maybe pointless, but idk
    80001718:	ff69f7e3          	bgeu	s3,s6,80001706 <uvmthreaded_dealloc+0x48>
      uvmunmap(infant->pagetable, PGROUNDUP(newsz), npages, 0);//unmap without freeing
    8000171c:	4681                	li	a3,0
    8000171e:	865e                	mv	a2,s7
    80001720:	85ce                	mv	a1,s3
    80001722:	05093503          	ld	a0,80(s2)
    80001726:	00000097          	auipc	ra,0x0
    8000172a:	c14080e7          	jalr	-1004(ra) # 8000133a <uvmunmap>
    8000172e:	bfe1                	j	80001706 <uvmthreaded_dealloc+0x48>
  }

  uvmunmap(p->pagetable, PGROUNDUP(newsz), npages, 1); //unmap with freeing
    80001730:	4685                	li	a3,1
    80001732:	865e                	mv	a2,s7
    80001734:	85ce                	mv	a1,s3
    80001736:	050c3503          	ld	a0,80(s8)
    8000173a:	00000097          	auipc	ra,0x0
    8000173e:	c00080e7          	jalr	-1024(ra) # 8000133a <uvmunmap>
  p->sz = newsz;
    80001742:	055c3423          	sd	s5,72(s8)

  return newsz;
    80001746:	8556                	mv	a0,s5
}
    80001748:	60a6                	ld	ra,72(sp)
    8000174a:	6406                	ld	s0,64(sp)
    8000174c:	74e2                	ld	s1,56(sp)
    8000174e:	7942                	ld	s2,48(sp)
    80001750:	79a2                	ld	s3,40(sp)
    80001752:	7a02                	ld	s4,32(sp)
    80001754:	6ae2                	ld	s5,24(sp)
    80001756:	6b42                	ld	s6,16(sp)
    80001758:	6ba2                	ld	s7,8(sp)
    8000175a:	6c02                	ld	s8,0(sp)
    8000175c:	6161                	addi	sp,sp,80
    8000175e:	8082                	ret
    return oldsz;
    80001760:	852e                	mv	a0,a1
}
    80001762:	8082                	ret

0000000080001764 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001764:	7179                	addi	sp,sp,-48
    80001766:	f406                	sd	ra,40(sp)
    80001768:	f022                	sd	s0,32(sp)
    8000176a:	ec26                	sd	s1,24(sp)
    8000176c:	e84a                	sd	s2,16(sp)
    8000176e:	e44e                	sd	s3,8(sp)
    80001770:	e052                	sd	s4,0(sp)
    80001772:	1800                	addi	s0,sp,48
    80001774:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001776:	84aa                	mv	s1,a0
    80001778:	6905                	lui	s2,0x1
    8000177a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000177c:	4985                	li	s3,1
    8000177e:	a829                	j	80001798 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001780:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001782:	00c79513          	slli	a0,a5,0xc
    80001786:	00000097          	auipc	ra,0x0
    8000178a:	fde080e7          	jalr	-34(ra) # 80001764 <freewalk>
      pagetable[i] = 0;
    8000178e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001792:	04a1                	addi	s1,s1,8
    80001794:	03248163          	beq	s1,s2,800017b6 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001798:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000179a:	00f7f713          	andi	a4,a5,15
    8000179e:	ff3701e3          	beq	a4,s3,80001780 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800017a2:	8b85                	andi	a5,a5,1
    800017a4:	d7fd                	beqz	a5,80001792 <freewalk+0x2e>
      panic("freewalk: leaf");
    800017a6:	00007517          	auipc	a0,0x7
    800017aa:	9d250513          	addi	a0,a0,-1582 # 80008178 <digits+0x138>
    800017ae:	fffff097          	auipc	ra,0xfffff
    800017b2:	d92080e7          	jalr	-622(ra) # 80000540 <panic>
    }
  }
  kfree((void*)pagetable);
    800017b6:	8552                	mv	a0,s4
    800017b8:	fffff097          	auipc	ra,0xfffff
    800017bc:	280080e7          	jalr	640(ra) # 80000a38 <kfree>
}
    800017c0:	70a2                	ld	ra,40(sp)
    800017c2:	7402                	ld	s0,32(sp)
    800017c4:	64e2                	ld	s1,24(sp)
    800017c6:	6942                	ld	s2,16(sp)
    800017c8:	69a2                	ld	s3,8(sp)
    800017ca:	6a02                	ld	s4,0(sp)
    800017cc:	6145                	addi	sp,sp,48
    800017ce:	8082                	ret

00000000800017d0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800017d0:	1101                	addi	sp,sp,-32
    800017d2:	ec06                	sd	ra,24(sp)
    800017d4:	e822                	sd	s0,16(sp)
    800017d6:	e426                	sd	s1,8(sp)
    800017d8:	1000                	addi	s0,sp,32
    800017da:	84aa                	mv	s1,a0
  if(sz > 0)
    800017dc:	e999                	bnez	a1,800017f2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800017de:	8526                	mv	a0,s1
    800017e0:	00000097          	auipc	ra,0x0
    800017e4:	f84080e7          	jalr	-124(ra) # 80001764 <freewalk>
}
    800017e8:	60e2                	ld	ra,24(sp)
    800017ea:	6442                	ld	s0,16(sp)
    800017ec:	64a2                	ld	s1,8(sp)
    800017ee:	6105                	addi	sp,sp,32
    800017f0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800017f2:	6785                	lui	a5,0x1
    800017f4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800017f6:	95be                	add	a1,a1,a5
    800017f8:	4685                	li	a3,1
    800017fa:	00c5d613          	srli	a2,a1,0xc
    800017fe:	4581                	li	a1,0
    80001800:	00000097          	auipc	ra,0x0
    80001804:	b3a080e7          	jalr	-1222(ra) # 8000133a <uvmunmap>
    80001808:	bfd9                	j	800017de <uvmfree+0xe>

000000008000180a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000180a:	c679                	beqz	a2,800018d8 <uvmcopy+0xce>
{
    8000180c:	715d                	addi	sp,sp,-80
    8000180e:	e486                	sd	ra,72(sp)
    80001810:	e0a2                	sd	s0,64(sp)
    80001812:	fc26                	sd	s1,56(sp)
    80001814:	f84a                	sd	s2,48(sp)
    80001816:	f44e                	sd	s3,40(sp)
    80001818:	f052                	sd	s4,32(sp)
    8000181a:	ec56                	sd	s5,24(sp)
    8000181c:	e85a                	sd	s6,16(sp)
    8000181e:	e45e                	sd	s7,8(sp)
    80001820:	0880                	addi	s0,sp,80
    80001822:	8b2a                	mv	s6,a0
    80001824:	8aae                	mv	s5,a1
    80001826:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001828:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000182a:	4601                	li	a2,0
    8000182c:	85ce                	mv	a1,s3
    8000182e:	855a                	mv	a0,s6
    80001830:	00000097          	auipc	ra,0x0
    80001834:	85c080e7          	jalr	-1956(ra) # 8000108c <walk>
    80001838:	c531                	beqz	a0,80001884 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000183a:	6118                	ld	a4,0(a0)
    8000183c:	00177793          	andi	a5,a4,1
    80001840:	cbb1                	beqz	a5,80001894 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001842:	00a75593          	srli	a1,a4,0xa
    80001846:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000184a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	350080e7          	jalr	848(ra) # 80000b9e <kalloc>
    80001856:	892a                	mv	s2,a0
    80001858:	c939                	beqz	a0,800018ae <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000185a:	6605                	lui	a2,0x1
    8000185c:	85de                	mv	a1,s7
    8000185e:	fffff097          	auipc	ra,0xfffff
    80001862:	5a6080e7          	jalr	1446(ra) # 80000e04 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001866:	8726                	mv	a4,s1
    80001868:	86ca                	mv	a3,s2
    8000186a:	6605                	lui	a2,0x1
    8000186c:	85ce                	mv	a1,s3
    8000186e:	8556                	mv	a0,s5
    80001870:	00000097          	auipc	ra,0x0
    80001874:	904080e7          	jalr	-1788(ra) # 80001174 <mappages>
    80001878:	e515                	bnez	a0,800018a4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000187a:	6785                	lui	a5,0x1
    8000187c:	99be                	add	s3,s3,a5
    8000187e:	fb49e6e3          	bltu	s3,s4,8000182a <uvmcopy+0x20>
    80001882:	a081                	j	800018c2 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001884:	00007517          	auipc	a0,0x7
    80001888:	90450513          	addi	a0,a0,-1788 # 80008188 <digits+0x148>
    8000188c:	fffff097          	auipc	ra,0xfffff
    80001890:	cb4080e7          	jalr	-844(ra) # 80000540 <panic>
      panic("uvmcopy: page not present");
    80001894:	00007517          	auipc	a0,0x7
    80001898:	91450513          	addi	a0,a0,-1772 # 800081a8 <digits+0x168>
    8000189c:	fffff097          	auipc	ra,0xfffff
    800018a0:	ca4080e7          	jalr	-860(ra) # 80000540 <panic>
      kfree(mem);
    800018a4:	854a                	mv	a0,s2
    800018a6:	fffff097          	auipc	ra,0xfffff
    800018aa:	192080e7          	jalr	402(ra) # 80000a38 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800018ae:	4685                	li	a3,1
    800018b0:	00c9d613          	srli	a2,s3,0xc
    800018b4:	4581                	li	a1,0
    800018b6:	8556                	mv	a0,s5
    800018b8:	00000097          	auipc	ra,0x0
    800018bc:	a82080e7          	jalr	-1406(ra) # 8000133a <uvmunmap>
  return -1;
    800018c0:	557d                	li	a0,-1
}
    800018c2:	60a6                	ld	ra,72(sp)
    800018c4:	6406                	ld	s0,64(sp)
    800018c6:	74e2                	ld	s1,56(sp)
    800018c8:	7942                	ld	s2,48(sp)
    800018ca:	79a2                	ld	s3,40(sp)
    800018cc:	7a02                	ld	s4,32(sp)
    800018ce:	6ae2                	ld	s5,24(sp)
    800018d0:	6b42                	ld	s6,16(sp)
    800018d2:	6ba2                	ld	s7,8(sp)
    800018d4:	6161                	addi	sp,sp,80
    800018d6:	8082                	ret
  return 0;
    800018d8:	4501                	li	a0,0
}
    800018da:	8082                	ret

00000000800018dc <uvmshare>:

int
uvmshare(pagetable_t old, pagetable_t new, uint64 sz)
{
    800018dc:	7139                	addi	sp,sp,-64
    800018de:	fc06                	sd	ra,56(sp)
    800018e0:	f822                	sd	s0,48(sp)
    800018e2:	f426                	sd	s1,40(sp)
    800018e4:	f04a                	sd	s2,32(sp)
    800018e6:	ec4e                	sd	s3,24(sp)
    800018e8:	e852                	sd	s4,16(sp)
    800018ea:	e456                	sd	s5,8(sp)
    800018ec:	e05a                	sd	s6,0(sp)
    800018ee:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa = 0, i;
  uint flags;
  
  for(i = 0; i < sz; i += PGSIZE) {
    800018f0:	c24d                	beqz	a2,80001992 <uvmshare+0xb6>
    800018f2:	8b2a                	mv	s6,a0
    800018f4:	8aae                	mv	s5,a1
    800018f6:	8a32                	mv	s4,a2
    800018f8:	4901                	li	s2,0
    800018fa:	a891                	j	8000194e <uvmshare+0x72>
    pte = walk(old, i, 0);

    if(pte == 0) panic("uvmshare: pte should exist");
    800018fc:	00007517          	auipc	a0,0x7
    80001900:	8cc50513          	addi	a0,a0,-1844 # 800081c8 <digits+0x188>
    80001904:	fffff097          	auipc	ra,0xfffff
    80001908:	c3c080e7          	jalr	-964(ra) # 80000540 <panic>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    8000190c:	00007517          	auipc	a0,0x7
    80001910:	8dc50513          	addi	a0,a0,-1828 # 800081e8 <digits+0x1a8>
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	c2c080e7          	jalr	-980(ra) # 80000540 <panic>
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    // flags |= PTE_W;

    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
      uvmunmap(new, 0, i / PGSIZE, 0);
    8000191c:	4681                	li	a3,0
    8000191e:	00c95613          	srli	a2,s2,0xc
    80001922:	4581                	li	a1,0
    80001924:	8556                	mv	a0,s5
    80001926:	00000097          	auipc	ra,0x0
    8000192a:	a14080e7          	jalr	-1516(ra) # 8000133a <uvmunmap>
      return -1;
    8000192e:	59fd                	li	s3,-1
      add_page_reference((uint64)pa);
  }

  return 0;

}
    80001930:	854e                	mv	a0,s3
    80001932:	70e2                	ld	ra,56(sp)
    80001934:	7442                	ld	s0,48(sp)
    80001936:	74a2                	ld	s1,40(sp)
    80001938:	7902                	ld	s2,32(sp)
    8000193a:	69e2                	ld	s3,24(sp)
    8000193c:	6a42                	ld	s4,16(sp)
    8000193e:	6aa2                	ld	s5,8(sp)
    80001940:	6b02                	ld	s6,0(sp)
    80001942:	6121                	addi	sp,sp,64
    80001944:	8082                	ret
  for(i = 0; i < sz; i += PGSIZE) {
    80001946:	6785                	lui	a5,0x1
    80001948:	993e                	add	s2,s2,a5
    8000194a:	ff4973e3          	bgeu	s2,s4,80001930 <uvmshare+0x54>
    pte = walk(old, i, 0);
    8000194e:	4601                	li	a2,0
    80001950:	85ca                	mv	a1,s2
    80001952:	855a                	mv	a0,s6
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	738080e7          	jalr	1848(ra) # 8000108c <walk>
    if(pte == 0) panic("uvmshare: pte should exist");
    8000195c:	d145                	beqz	a0,800018fc <uvmshare+0x20>
    if((*pte & PTE_V) == 0) panic("uvmshare: page not present");
    8000195e:	6118                	ld	a4,0(a0)
    80001960:	00177793          	andi	a5,a4,1
    80001964:	d7c5                	beqz	a5,8000190c <uvmshare+0x30>
    pa = PTE2PA(*pte);
    80001966:	00a75493          	srli	s1,a4,0xa
    8000196a:	04b2                	slli	s1,s1,0xc
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0) { 
    8000196c:	3ff77713          	andi	a4,a4,1023
    80001970:	86a6                	mv	a3,s1
    80001972:	6605                	lui	a2,0x1
    80001974:	85ca                	mv	a1,s2
    80001976:	8556                	mv	a0,s5
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	7fc080e7          	jalr	2044(ra) # 80001174 <mappages>
    80001980:	89aa                	mv	s3,a0
    80001982:	fd49                	bnez	a0,8000191c <uvmshare+0x40>
    if (pa != 0)
    80001984:	d0e9                	beqz	s1,80001946 <uvmshare+0x6a>
      add_page_reference((uint64)pa);
    80001986:	8526                	mv	a0,s1
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	060080e7          	jalr	96(ra) # 800009e8 <add_page_reference>
    80001990:	bf5d                	j	80001946 <uvmshare+0x6a>
  return 0;
    80001992:	4981                	li	s3,0
    80001994:	bf71                	j	80001930 <uvmshare+0x54>

0000000080001996 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001996:	1141                	addi	sp,sp,-16
    80001998:	e406                	sd	ra,8(sp)
    8000199a:	e022                	sd	s0,0(sp)
    8000199c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000199e:	4601                	li	a2,0
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	6ec080e7          	jalr	1772(ra) # 8000108c <walk>
  if(pte == 0)
    800019a8:	c901                	beqz	a0,800019b8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800019aa:	611c                	ld	a5,0(a0)
    800019ac:	9bbd                	andi	a5,a5,-17
    800019ae:	e11c                	sd	a5,0(a0)
}
    800019b0:	60a2                	ld	ra,8(sp)
    800019b2:	6402                	ld	s0,0(sp)
    800019b4:	0141                	addi	sp,sp,16
    800019b6:	8082                	ret
    panic("uvmclear");
    800019b8:	00007517          	auipc	a0,0x7
    800019bc:	85050513          	addi	a0,a0,-1968 # 80008208 <digits+0x1c8>
    800019c0:	fffff097          	auipc	ra,0xfffff
    800019c4:	b80080e7          	jalr	-1152(ra) # 80000540 <panic>

00000000800019c8 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800019c8:	c6bd                	beqz	a3,80001a36 <copyout+0x6e>
{
    800019ca:	715d                	addi	sp,sp,-80
    800019cc:	e486                	sd	ra,72(sp)
    800019ce:	e0a2                	sd	s0,64(sp)
    800019d0:	fc26                	sd	s1,56(sp)
    800019d2:	f84a                	sd	s2,48(sp)
    800019d4:	f44e                	sd	s3,40(sp)
    800019d6:	f052                	sd	s4,32(sp)
    800019d8:	ec56                	sd	s5,24(sp)
    800019da:	e85a                	sd	s6,16(sp)
    800019dc:	e45e                	sd	s7,8(sp)
    800019de:	e062                	sd	s8,0(sp)
    800019e0:	0880                	addi	s0,sp,80
    800019e2:	8b2a                	mv	s6,a0
    800019e4:	8c2e                	mv	s8,a1
    800019e6:	8a32                	mv	s4,a2
    800019e8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800019ea:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800019ec:	6a85                	lui	s5,0x1
    800019ee:	a015                	j	80001a12 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800019f0:	9562                	add	a0,a0,s8
    800019f2:	0004861b          	sext.w	a2,s1
    800019f6:	85d2                	mv	a1,s4
    800019f8:	41250533          	sub	a0,a0,s2
    800019fc:	fffff097          	auipc	ra,0xfffff
    80001a00:	408080e7          	jalr	1032(ra) # 80000e04 <memmove>

    len -= n;
    80001a04:	409989b3          	sub	s3,s3,s1
    src += n;
    80001a08:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001a0a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001a0e:	02098263          	beqz	s3,80001a32 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001a12:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001a16:	85ca                	mv	a1,s2
    80001a18:	855a                	mv	a0,s6
    80001a1a:	fffff097          	auipc	ra,0xfffff
    80001a1e:	718080e7          	jalr	1816(ra) # 80001132 <walkaddr>
    if(pa0 == 0)
    80001a22:	cd01                	beqz	a0,80001a3a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001a24:	418904b3          	sub	s1,s2,s8
    80001a28:	94d6                	add	s1,s1,s5
    80001a2a:	fc99f3e3          	bgeu	s3,s1,800019f0 <copyout+0x28>
    80001a2e:	84ce                	mv	s1,s3
    80001a30:	b7c1                	j	800019f0 <copyout+0x28>
  }
  return 0;
    80001a32:	4501                	li	a0,0
    80001a34:	a021                	j	80001a3c <copyout+0x74>
    80001a36:	4501                	li	a0,0
}
    80001a38:	8082                	ret
      return -1;
    80001a3a:	557d                	li	a0,-1
}
    80001a3c:	60a6                	ld	ra,72(sp)
    80001a3e:	6406                	ld	s0,64(sp)
    80001a40:	74e2                	ld	s1,56(sp)
    80001a42:	7942                	ld	s2,48(sp)
    80001a44:	79a2                	ld	s3,40(sp)
    80001a46:	7a02                	ld	s4,32(sp)
    80001a48:	6ae2                	ld	s5,24(sp)
    80001a4a:	6b42                	ld	s6,16(sp)
    80001a4c:	6ba2                	ld	s7,8(sp)
    80001a4e:	6c02                	ld	s8,0(sp)
    80001a50:	6161                	addi	sp,sp,80
    80001a52:	8082                	ret

0000000080001a54 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001a54:	caa5                	beqz	a3,80001ac4 <copyin+0x70>
{
    80001a56:	715d                	addi	sp,sp,-80
    80001a58:	e486                	sd	ra,72(sp)
    80001a5a:	e0a2                	sd	s0,64(sp)
    80001a5c:	fc26                	sd	s1,56(sp)
    80001a5e:	f84a                	sd	s2,48(sp)
    80001a60:	f44e                	sd	s3,40(sp)
    80001a62:	f052                	sd	s4,32(sp)
    80001a64:	ec56                	sd	s5,24(sp)
    80001a66:	e85a                	sd	s6,16(sp)
    80001a68:	e45e                	sd	s7,8(sp)
    80001a6a:	e062                	sd	s8,0(sp)
    80001a6c:	0880                	addi	s0,sp,80
    80001a6e:	8b2a                	mv	s6,a0
    80001a70:	8a2e                	mv	s4,a1
    80001a72:	8c32                	mv	s8,a2
    80001a74:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001a76:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a78:	6a85                	lui	s5,0x1
    80001a7a:	a01d                	j	80001aa0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001a7c:	018505b3          	add	a1,a0,s8
    80001a80:	0004861b          	sext.w	a2,s1
    80001a84:	412585b3          	sub	a1,a1,s2
    80001a88:	8552                	mv	a0,s4
    80001a8a:	fffff097          	auipc	ra,0xfffff
    80001a8e:	37a080e7          	jalr	890(ra) # 80000e04 <memmove>

    len -= n;
    80001a92:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001a96:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001a98:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001a9c:	02098263          	beqz	s3,80001ac0 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001aa0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001aa4:	85ca                	mv	a1,s2
    80001aa6:	855a                	mv	a0,s6
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	68a080e7          	jalr	1674(ra) # 80001132 <walkaddr>
    if(pa0 == 0)
    80001ab0:	cd01                	beqz	a0,80001ac8 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001ab2:	418904b3          	sub	s1,s2,s8
    80001ab6:	94d6                	add	s1,s1,s5
    80001ab8:	fc99f2e3          	bgeu	s3,s1,80001a7c <copyin+0x28>
    80001abc:	84ce                	mv	s1,s3
    80001abe:	bf7d                	j	80001a7c <copyin+0x28>
  }
  return 0;
    80001ac0:	4501                	li	a0,0
    80001ac2:	a021                	j	80001aca <copyin+0x76>
    80001ac4:	4501                	li	a0,0
}
    80001ac6:	8082                	ret
      return -1;
    80001ac8:	557d                	li	a0,-1
}
    80001aca:	60a6                	ld	ra,72(sp)
    80001acc:	6406                	ld	s0,64(sp)
    80001ace:	74e2                	ld	s1,56(sp)
    80001ad0:	7942                	ld	s2,48(sp)
    80001ad2:	79a2                	ld	s3,40(sp)
    80001ad4:	7a02                	ld	s4,32(sp)
    80001ad6:	6ae2                	ld	s5,24(sp)
    80001ad8:	6b42                	ld	s6,16(sp)
    80001ada:	6ba2                	ld	s7,8(sp)
    80001adc:	6c02                	ld	s8,0(sp)
    80001ade:	6161                	addi	sp,sp,80
    80001ae0:	8082                	ret

0000000080001ae2 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001ae2:	c2dd                	beqz	a3,80001b88 <copyinstr+0xa6>
{
    80001ae4:	715d                	addi	sp,sp,-80
    80001ae6:	e486                	sd	ra,72(sp)
    80001ae8:	e0a2                	sd	s0,64(sp)
    80001aea:	fc26                	sd	s1,56(sp)
    80001aec:	f84a                	sd	s2,48(sp)
    80001aee:	f44e                	sd	s3,40(sp)
    80001af0:	f052                	sd	s4,32(sp)
    80001af2:	ec56                	sd	s5,24(sp)
    80001af4:	e85a                	sd	s6,16(sp)
    80001af6:	e45e                	sd	s7,8(sp)
    80001af8:	0880                	addi	s0,sp,80
    80001afa:	8a2a                	mv	s4,a0
    80001afc:	8b2e                	mv	s6,a1
    80001afe:	8bb2                	mv	s7,a2
    80001b00:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001b02:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001b04:	6985                	lui	s3,0x1
    80001b06:	a02d                	j	80001b30 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001b08:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001b0c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001b0e:	37fd                	addiw	a5,a5,-1
    80001b10:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001b14:	60a6                	ld	ra,72(sp)
    80001b16:	6406                	ld	s0,64(sp)
    80001b18:	74e2                	ld	s1,56(sp)
    80001b1a:	7942                	ld	s2,48(sp)
    80001b1c:	79a2                	ld	s3,40(sp)
    80001b1e:	7a02                	ld	s4,32(sp)
    80001b20:	6ae2                	ld	s5,24(sp)
    80001b22:	6b42                	ld	s6,16(sp)
    80001b24:	6ba2                	ld	s7,8(sp)
    80001b26:	6161                	addi	sp,sp,80
    80001b28:	8082                	ret
    srcva = va0 + PGSIZE;
    80001b2a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001b2e:	c8a9                	beqz	s1,80001b80 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80001b30:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001b34:	85ca                	mv	a1,s2
    80001b36:	8552                	mv	a0,s4
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	5fa080e7          	jalr	1530(ra) # 80001132 <walkaddr>
    if(pa0 == 0)
    80001b40:	c131                	beqz	a0,80001b84 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001b42:	417906b3          	sub	a3,s2,s7
    80001b46:	96ce                	add	a3,a3,s3
    80001b48:	00d4f363          	bgeu	s1,a3,80001b4e <copyinstr+0x6c>
    80001b4c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001b4e:	955e                	add	a0,a0,s7
    80001b50:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001b54:	daf9                	beqz	a3,80001b2a <copyinstr+0x48>
    80001b56:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001b58:	41650633          	sub	a2,a0,s6
    80001b5c:	fff48593          	addi	a1,s1,-1
    80001b60:	95da                	add	a1,a1,s6
    while(n > 0){
    80001b62:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80001b64:	00f60733          	add	a4,a2,a5
    80001b68:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ff95000>
    80001b6c:	df51                	beqz	a4,80001b08 <copyinstr+0x26>
        *dst = *p;
    80001b6e:	00e78023          	sb	a4,0(a5)
      --max;
    80001b72:	40f584b3          	sub	s1,a1,a5
      dst++;
    80001b76:	0785                	addi	a5,a5,1
    while(n > 0){
    80001b78:	fed796e3          	bne	a5,a3,80001b64 <copyinstr+0x82>
      dst++;
    80001b7c:	8b3e                	mv	s6,a5
    80001b7e:	b775                	j	80001b2a <copyinstr+0x48>
    80001b80:	4781                	li	a5,0
    80001b82:	b771                	j	80001b0e <copyinstr+0x2c>
      return -1;
    80001b84:	557d                	li	a0,-1
    80001b86:	b779                	j	80001b14 <copyinstr+0x32>
  int got_null = 0;
    80001b88:	4781                	li	a5,0
  if(got_null){
    80001b8a:	37fd                	addiw	a5,a5,-1
    80001b8c:	0007851b          	sext.w	a0,a5
}
    80001b90:	8082                	ret

0000000080001b92 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001b92:	7139                	addi	sp,sp,-64
    80001b94:	fc06                	sd	ra,56(sp)
    80001b96:	f822                	sd	s0,48(sp)
    80001b98:	f426                	sd	s1,40(sp)
    80001b9a:	f04a                	sd	s2,32(sp)
    80001b9c:	ec4e                	sd	s3,24(sp)
    80001b9e:	e852                	sd	s4,16(sp)
    80001ba0:	e456                	sd	s5,8(sp)
    80001ba2:	e05a                	sd	s6,0(sp)
    80001ba4:	0080                	addi	s0,sp,64
    80001ba6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ba8:	0004f497          	auipc	s1,0x4f
    80001bac:	47848493          	addi	s1,s1,1144 # 80051020 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001bb0:	8b26                	mv	s6,s1
    80001bb2:	00006a97          	auipc	s5,0x6
    80001bb6:	44ea8a93          	addi	s5,s5,1102 # 80008000 <etext>
    80001bba:	04000937          	lui	s2,0x4000
    80001bbe:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001bc0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bc2:	0005da17          	auipc	s4,0x5d
    80001bc6:	05ea0a13          	addi	s4,s4,94 # 8005ec20 <tickslock>
    char *pa = kalloc();
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	fd4080e7          	jalr	-44(ra) # 80000b9e <kalloc>
    80001bd2:	862a                	mv	a2,a0
    if(pa == 0)
    80001bd4:	c131                	beqz	a0,80001c18 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001bd6:	416485b3          	sub	a1,s1,s6
    80001bda:	8591                	srai	a1,a1,0x4
    80001bdc:	000ab783          	ld	a5,0(s5)
    80001be0:	02f585b3          	mul	a1,a1,a5
    80001be4:	2585                	addiw	a1,a1,1
    80001be6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001bea:	4719                	li	a4,6
    80001bec:	6685                	lui	a3,0x1
    80001bee:	40b905b3          	sub	a1,s2,a1
    80001bf2:	854e                	mv	a0,s3
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	620080e7          	jalr	1568(ra) # 80001214 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bfc:	37048493          	addi	s1,s1,880
    80001c00:	fd4495e3          	bne	s1,s4,80001bca <proc_mapstacks+0x38>
  }
}
    80001c04:	70e2                	ld	ra,56(sp)
    80001c06:	7442                	ld	s0,48(sp)
    80001c08:	74a2                	ld	s1,40(sp)
    80001c0a:	7902                	ld	s2,32(sp)
    80001c0c:	69e2                	ld	s3,24(sp)
    80001c0e:	6a42                	ld	s4,16(sp)
    80001c10:	6aa2                	ld	s5,8(sp)
    80001c12:	6b02                	ld	s6,0(sp)
    80001c14:	6121                	addi	sp,sp,64
    80001c16:	8082                	ret
      panic("kalloc");
    80001c18:	00006517          	auipc	a0,0x6
    80001c1c:	60050513          	addi	a0,a0,1536 # 80008218 <digits+0x1d8>
    80001c20:	fffff097          	auipc	ra,0xfffff
    80001c24:	920080e7          	jalr	-1760(ra) # 80000540 <panic>

0000000080001c28 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001c28:	7139                	addi	sp,sp,-64
    80001c2a:	fc06                	sd	ra,56(sp)
    80001c2c:	f822                	sd	s0,48(sp)
    80001c2e:	f426                	sd	s1,40(sp)
    80001c30:	f04a                	sd	s2,32(sp)
    80001c32:	ec4e                	sd	s3,24(sp)
    80001c34:	e852                	sd	s4,16(sp)
    80001c36:	e456                	sd	s5,8(sp)
    80001c38:	e05a                	sd	s6,0(sp)
    80001c3a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001c3c:	00006597          	auipc	a1,0x6
    80001c40:	5e458593          	addi	a1,a1,1508 # 80008220 <digits+0x1e0>
    80001c44:	0004f517          	auipc	a0,0x4f
    80001c48:	fac50513          	addi	a0,a0,-84 # 80050bf0 <pid_lock>
    80001c4c:	fffff097          	auipc	ra,0xfffff
    80001c50:	fd0080e7          	jalr	-48(ra) # 80000c1c <initlock>
  initlock(&wait_lock, "wait_lock");
    80001c54:	00006597          	auipc	a1,0x6
    80001c58:	5d458593          	addi	a1,a1,1492 # 80008228 <digits+0x1e8>
    80001c5c:	0004f517          	auipc	a0,0x4f
    80001c60:	fac50513          	addi	a0,a0,-84 # 80050c08 <wait_lock>
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	fb8080e7          	jalr	-72(ra) # 80000c1c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c6c:	0004f497          	auipc	s1,0x4f
    80001c70:	3b448493          	addi	s1,s1,948 # 80051020 <proc>
      initlock(&p->lock, "proc");
    80001c74:	00006b17          	auipc	s6,0x6
    80001c78:	5c4b0b13          	addi	s6,s6,1476 # 80008238 <digits+0x1f8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001c7c:	8aa6                	mv	s5,s1
    80001c7e:	00006a17          	auipc	s4,0x6
    80001c82:	382a0a13          	addi	s4,s4,898 # 80008000 <etext>
    80001c86:	04000937          	lui	s2,0x4000
    80001c8a:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001c8c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c8e:	0005d997          	auipc	s3,0x5d
    80001c92:	f9298993          	addi	s3,s3,-110 # 8005ec20 <tickslock>
      initlock(&p->lock, "proc");
    80001c96:	85da                	mv	a1,s6
    80001c98:	8526                	mv	a0,s1
    80001c9a:	fffff097          	auipc	ra,0xfffff
    80001c9e:	f82080e7          	jalr	-126(ra) # 80000c1c <initlock>
      p->state = UNUSED;
    80001ca2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001ca6:	415487b3          	sub	a5,s1,s5
    80001caa:	8791                	srai	a5,a5,0x4
    80001cac:	000a3703          	ld	a4,0(s4)
    80001cb0:	02e787b3          	mul	a5,a5,a4
    80001cb4:	2785                	addiw	a5,a5,1
    80001cb6:	00d7979b          	slliw	a5,a5,0xd
    80001cba:	40f907b3          	sub	a5,s2,a5
    80001cbe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cc0:	37048493          	addi	s1,s1,880
    80001cc4:	fd3499e3          	bne	s1,s3,80001c96 <procinit+0x6e>
  }
}
    80001cc8:	70e2                	ld	ra,56(sp)
    80001cca:	7442                	ld	s0,48(sp)
    80001ccc:	74a2                	ld	s1,40(sp)
    80001cce:	7902                	ld	s2,32(sp)
    80001cd0:	69e2                	ld	s3,24(sp)
    80001cd2:	6a42                	ld	s4,16(sp)
    80001cd4:	6aa2                	ld	s5,8(sp)
    80001cd6:	6b02                	ld	s6,0(sp)
    80001cd8:	6121                	addi	sp,sp,64
    80001cda:	8082                	ret

0000000080001cdc <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001cdc:	1141                	addi	sp,sp,-16
    80001cde:	e422                	sd	s0,8(sp)
    80001ce0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ce2:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001ce4:	2501                	sext.w	a0,a0
    80001ce6:	6422                	ld	s0,8(sp)
    80001ce8:	0141                	addi	sp,sp,16
    80001cea:	8082                	ret

0000000080001cec <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001cec:	1141                	addi	sp,sp,-16
    80001cee:	e422                	sd	s0,8(sp)
    80001cf0:	0800                	addi	s0,sp,16
    80001cf2:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001cf4:	2781                	sext.w	a5,a5
    80001cf6:	079e                	slli	a5,a5,0x7
  return c;
}
    80001cf8:	0004f517          	auipc	a0,0x4f
    80001cfc:	f2850513          	addi	a0,a0,-216 # 80050c20 <cpus>
    80001d00:	953e                	add	a0,a0,a5
    80001d02:	6422                	ld	s0,8(sp)
    80001d04:	0141                	addi	sp,sp,16
    80001d06:	8082                	ret

0000000080001d08 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001d08:	1101                	addi	sp,sp,-32
    80001d0a:	ec06                	sd	ra,24(sp)
    80001d0c:	e822                	sd	s0,16(sp)
    80001d0e:	e426                	sd	s1,8(sp)
    80001d10:	1000                	addi	s0,sp,32
  push_off();
    80001d12:	fffff097          	auipc	ra,0xfffff
    80001d16:	f4e080e7          	jalr	-178(ra) # 80000c60 <push_off>
    80001d1a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001d1c:	2781                	sext.w	a5,a5
    80001d1e:	079e                	slli	a5,a5,0x7
    80001d20:	0004f717          	auipc	a4,0x4f
    80001d24:	ed070713          	addi	a4,a4,-304 # 80050bf0 <pid_lock>
    80001d28:	97ba                	add	a5,a5,a4
    80001d2a:	7b84                	ld	s1,48(a5)
  pop_off();
    80001d2c:	fffff097          	auipc	ra,0xfffff
    80001d30:	fd4080e7          	jalr	-44(ra) # 80000d00 <pop_off>
  return p;
}
    80001d34:	8526                	mv	a0,s1
    80001d36:	60e2                	ld	ra,24(sp)
    80001d38:	6442                	ld	s0,16(sp)
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	6105                	addi	sp,sp,32
    80001d3e:	8082                	ret

0000000080001d40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001d40:	1141                	addi	sp,sp,-16
    80001d42:	e406                	sd	ra,8(sp)
    80001d44:	e022                	sd	s0,0(sp)
    80001d46:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	fc0080e7          	jalr	-64(ra) # 80001d08 <myproc>
    80001d50:	fffff097          	auipc	ra,0xfffff
    80001d54:	010080e7          	jalr	16(ra) # 80000d60 <release>

  if (first) {
    80001d58:	00007797          	auipc	a5,0x7
    80001d5c:	b887a783          	lw	a5,-1144(a5) # 800088e0 <first.1>
    80001d60:	eb89                	bnez	a5,80001d72 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001d62:	00001097          	auipc	ra,0x1
    80001d66:	15a080e7          	jalr	346(ra) # 80002ebc <usertrapret>
}
    80001d6a:	60a2                	ld	ra,8(sp)
    80001d6c:	6402                	ld	s0,0(sp)
    80001d6e:	0141                	addi	sp,sp,16
    80001d70:	8082                	ret
    first = 0;
    80001d72:	00007797          	auipc	a5,0x7
    80001d76:	b607a723          	sw	zero,-1170(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80001d7a:	4505                	li	a0,1
    80001d7c:	00002097          	auipc	ra,0x2
    80001d80:	f7c080e7          	jalr	-132(ra) # 80003cf8 <fsinit>
    80001d84:	bff9                	j	80001d62 <forkret+0x22>

0000000080001d86 <allocpid>:
{
    80001d86:	1101                	addi	sp,sp,-32
    80001d88:	ec06                	sd	ra,24(sp)
    80001d8a:	e822                	sd	s0,16(sp)
    80001d8c:	e426                	sd	s1,8(sp)
    80001d8e:	e04a                	sd	s2,0(sp)
    80001d90:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001d92:	0004f917          	auipc	s2,0x4f
    80001d96:	e5e90913          	addi	s2,s2,-418 # 80050bf0 <pid_lock>
    80001d9a:	854a                	mv	a0,s2
    80001d9c:	fffff097          	auipc	ra,0xfffff
    80001da0:	f10080e7          	jalr	-240(ra) # 80000cac <acquire>
  pid = nextpid;
    80001da4:	00007797          	auipc	a5,0x7
    80001da8:	b4078793          	addi	a5,a5,-1216 # 800088e4 <nextpid>
    80001dac:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001dae:	0014871b          	addiw	a4,s1,1
    80001db2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001db4:	854a                	mv	a0,s2
    80001db6:	fffff097          	auipc	ra,0xfffff
    80001dba:	faa080e7          	jalr	-86(ra) # 80000d60 <release>
}
    80001dbe:	8526                	mv	a0,s1
    80001dc0:	60e2                	ld	ra,24(sp)
    80001dc2:	6442                	ld	s0,16(sp)
    80001dc4:	64a2                	ld	s1,8(sp)
    80001dc6:	6902                	ld	s2,0(sp)
    80001dc8:	6105                	addi	sp,sp,32
    80001dca:	8082                	ret

0000000080001dcc <proc_pagetable>:
{
    80001dcc:	1101                	addi	sp,sp,-32
    80001dce:	ec06                	sd	ra,24(sp)
    80001dd0:	e822                	sd	s0,16(sp)
    80001dd2:	e426                	sd	s1,8(sp)
    80001dd4:	e04a                	sd	s2,0(sp)
    80001dd6:	1000                	addi	s0,sp,32
    80001dd8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001dda:	fffff097          	auipc	ra,0xfffff
    80001dde:	624080e7          	jalr	1572(ra) # 800013fe <uvmcreate>
    80001de2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001de4:	c121                	beqz	a0,80001e24 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001de6:	4729                	li	a4,10
    80001de8:	00005697          	auipc	a3,0x5
    80001dec:	21868693          	addi	a3,a3,536 # 80007000 <_trampoline>
    80001df0:	6605                	lui	a2,0x1
    80001df2:	040005b7          	lui	a1,0x4000
    80001df6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001df8:	05b2                	slli	a1,a1,0xc
    80001dfa:	fffff097          	auipc	ra,0xfffff
    80001dfe:	37a080e7          	jalr	890(ra) # 80001174 <mappages>
    80001e02:	02054863          	bltz	a0,80001e32 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001e06:	4719                	li	a4,6
    80001e08:	05893683          	ld	a3,88(s2)
    80001e0c:	6605                	lui	a2,0x1
    80001e0e:	020005b7          	lui	a1,0x2000
    80001e12:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e14:	05b6                	slli	a1,a1,0xd
    80001e16:	8526                	mv	a0,s1
    80001e18:	fffff097          	auipc	ra,0xfffff
    80001e1c:	35c080e7          	jalr	860(ra) # 80001174 <mappages>
    80001e20:	02054163          	bltz	a0,80001e42 <proc_pagetable+0x76>
}
    80001e24:	8526                	mv	a0,s1
    80001e26:	60e2                	ld	ra,24(sp)
    80001e28:	6442                	ld	s0,16(sp)
    80001e2a:	64a2                	ld	s1,8(sp)
    80001e2c:	6902                	ld	s2,0(sp)
    80001e2e:	6105                	addi	sp,sp,32
    80001e30:	8082                	ret
    uvmfree(pagetable, 0);
    80001e32:	4581                	li	a1,0
    80001e34:	8526                	mv	a0,s1
    80001e36:	00000097          	auipc	ra,0x0
    80001e3a:	99a080e7          	jalr	-1638(ra) # 800017d0 <uvmfree>
    return 0;
    80001e3e:	4481                	li	s1,0
    80001e40:	b7d5                	j	80001e24 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e42:	4681                	li	a3,0
    80001e44:	4605                	li	a2,1
    80001e46:	040005b7          	lui	a1,0x4000
    80001e4a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e4c:	05b2                	slli	a1,a1,0xc
    80001e4e:	8526                	mv	a0,s1
    80001e50:	fffff097          	auipc	ra,0xfffff
    80001e54:	4ea080e7          	jalr	1258(ra) # 8000133a <uvmunmap>
    uvmfree(pagetable, 0);
    80001e58:	4581                	li	a1,0
    80001e5a:	8526                	mv	a0,s1
    80001e5c:	00000097          	auipc	ra,0x0
    80001e60:	974080e7          	jalr	-1676(ra) # 800017d0 <uvmfree>
    return 0;
    80001e64:	4481                	li	s1,0
    80001e66:	bf7d                	j	80001e24 <proc_pagetable+0x58>

0000000080001e68 <proc_freepagetable>:
{
    80001e68:	1101                	addi	sp,sp,-32
    80001e6a:	ec06                	sd	ra,24(sp)
    80001e6c:	e822                	sd	s0,16(sp)
    80001e6e:	e426                	sd	s1,8(sp)
    80001e70:	e04a                	sd	s2,0(sp)
    80001e72:	1000                	addi	s0,sp,32
    80001e74:	84aa                	mv	s1,a0
    80001e76:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e78:	4681                	li	a3,0
    80001e7a:	4605                	li	a2,1
    80001e7c:	040005b7          	lui	a1,0x4000
    80001e80:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e82:	05b2                	slli	a1,a1,0xc
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	4b6080e7          	jalr	1206(ra) # 8000133a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001e8c:	4681                	li	a3,0
    80001e8e:	4605                	li	a2,1
    80001e90:	020005b7          	lui	a1,0x2000
    80001e94:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e96:	05b6                	slli	a1,a1,0xd
    80001e98:	8526                	mv	a0,s1
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	4a0080e7          	jalr	1184(ra) # 8000133a <uvmunmap>
  uvmfree(pagetable, sz);
    80001ea2:	85ca                	mv	a1,s2
    80001ea4:	8526                	mv	a0,s1
    80001ea6:	00000097          	auipc	ra,0x0
    80001eaa:	92a080e7          	jalr	-1750(ra) # 800017d0 <uvmfree>
}
    80001eae:	60e2                	ld	ra,24(sp)
    80001eb0:	6442                	ld	s0,16(sp)
    80001eb2:	64a2                	ld	s1,8(sp)
    80001eb4:	6902                	ld	s2,0(sp)
    80001eb6:	6105                	addi	sp,sp,32
    80001eb8:	8082                	ret

0000000080001eba <freeproc>:
{
    80001eba:	1101                	addi	sp,sp,-32
    80001ebc:	ec06                	sd	ra,24(sp)
    80001ebe:	e822                	sd	s0,16(sp)
    80001ec0:	e426                	sd	s1,8(sp)
    80001ec2:	1000                	addi	s0,sp,32
    80001ec4:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001ec6:	6d28                	ld	a0,88(a0)
    80001ec8:	c509                	beqz	a0,80001ed2 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	b6e080e7          	jalr	-1170(ra) # 80000a38 <kfree>
  p->trapframe = 0;
    80001ed2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001ed6:	68a8                	ld	a0,80(s1)
    80001ed8:	c511                	beqz	a0,80001ee4 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001eda:	64ac                	ld	a1,72(s1)
    80001edc:	00000097          	auipc	ra,0x0
    80001ee0:	f8c080e7          	jalr	-116(ra) # 80001e68 <proc_freepagetable>
  p->pagetable = 0;
    80001ee4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ee8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001eec:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ef0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ef4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001ef8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001efc:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001f00:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001f04:	0004ac23          	sw	zero,24(s1)
}
    80001f08:	60e2                	ld	ra,24(sp)
    80001f0a:	6442                	ld	s0,16(sp)
    80001f0c:	64a2                	ld	s1,8(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret

0000000080001f12 <allocproc>:
{
    80001f12:	1101                	addi	sp,sp,-32
    80001f14:	ec06                	sd	ra,24(sp)
    80001f16:	e822                	sd	s0,16(sp)
    80001f18:	e426                	sd	s1,8(sp)
    80001f1a:	e04a                	sd	s2,0(sp)
    80001f1c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f1e:	0004f497          	auipc	s1,0x4f
    80001f22:	10248493          	addi	s1,s1,258 # 80051020 <proc>
    80001f26:	0005d917          	auipc	s2,0x5d
    80001f2a:	cfa90913          	addi	s2,s2,-774 # 8005ec20 <tickslock>
    acquire(&p->lock);
    80001f2e:	8526                	mv	a0,s1
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	d7c080e7          	jalr	-644(ra) # 80000cac <acquire>
    if(p->state == UNUSED) {
    80001f38:	4c9c                	lw	a5,24(s1)
    80001f3a:	cf81                	beqz	a5,80001f52 <allocproc+0x40>
      release(&p->lock);
    80001f3c:	8526                	mv	a0,s1
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	e22080e7          	jalr	-478(ra) # 80000d60 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f46:	37048493          	addi	s1,s1,880
    80001f4a:	ff2492e3          	bne	s1,s2,80001f2e <allocproc+0x1c>
  return 0;
    80001f4e:	4481                	li	s1,0
    80001f50:	a095                	j	80001fb4 <allocproc+0xa2>
  p->pid = allocpid();
    80001f52:	00000097          	auipc	ra,0x0
    80001f56:	e34080e7          	jalr	-460(ra) # 80001d86 <allocpid>
    80001f5a:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001f5c:	4785                	li	a5,1
    80001f5e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	c3e080e7          	jalr	-962(ra) # 80000b9e <kalloc>
    80001f68:	892a                	mv	s2,a0
    80001f6a:	eca8                	sd	a0,88(s1)
    80001f6c:	c939                	beqz	a0,80001fc2 <allocproc+0xb0>
  p->pagetable = proc_pagetable(p);
    80001f6e:	8526                	mv	a0,s1
    80001f70:	00000097          	auipc	ra,0x0
    80001f74:	e5c080e7          	jalr	-420(ra) # 80001dcc <proc_pagetable>
    80001f78:	892a                	mv	s2,a0
    80001f7a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001f7c:	cd39                	beqz	a0,80001fda <allocproc+0xc8>
  memset(&p->context, 0, sizeof(p->context));
    80001f7e:	07000613          	li	a2,112
    80001f82:	4581                	li	a1,0
    80001f84:	06048513          	addi	a0,s1,96
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	e20080e7          	jalr	-480(ra) # 80000da8 <memset>
  p->context.ra = (uint64)forkret;
    80001f90:	00000797          	auipc	a5,0x0
    80001f94:	db078793          	addi	a5,a5,-592 # 80001d40 <forkret>
    80001f98:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001f9a:	60bc                	ld	a5,64(s1)
    80001f9c:	6705                	lui	a4,0x1
    80001f9e:	97ba                	add	a5,a5,a4
    80001fa0:	f4bc                	sd	a5,104(s1)
  memset(p->infant_threads, 0, MAX_THREADS);
    80001fa2:	04000613          	li	a2,64
    80001fa6:	4581                	li	a1,0
    80001fa8:	17048513          	addi	a0,s1,368
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	dfc080e7          	jalr	-516(ra) # 80000da8 <memset>
}
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	60e2                	ld	ra,24(sp)
    80001fb8:	6442                	ld	s0,16(sp)
    80001fba:	64a2                	ld	s1,8(sp)
    80001fbc:	6902                	ld	s2,0(sp)
    80001fbe:	6105                	addi	sp,sp,32
    80001fc0:	8082                	ret
    freeproc(p);
    80001fc2:	8526                	mv	a0,s1
    80001fc4:	00000097          	auipc	ra,0x0
    80001fc8:	ef6080e7          	jalr	-266(ra) # 80001eba <freeproc>
    release(&p->lock);
    80001fcc:	8526                	mv	a0,s1
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	d92080e7          	jalr	-622(ra) # 80000d60 <release>
    return 0;
    80001fd6:	84ca                	mv	s1,s2
    80001fd8:	bff1                	j	80001fb4 <allocproc+0xa2>
    freeproc(p);
    80001fda:	8526                	mv	a0,s1
    80001fdc:	00000097          	auipc	ra,0x0
    80001fe0:	ede080e7          	jalr	-290(ra) # 80001eba <freeproc>
    release(&p->lock);
    80001fe4:	8526                	mv	a0,s1
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	d7a080e7          	jalr	-646(ra) # 80000d60 <release>
    return 0;
    80001fee:	84ca                	mv	s1,s2
    80001ff0:	b7d1                	j	80001fb4 <allocproc+0xa2>

0000000080001ff2 <userinit>:
{
    80001ff2:	1101                	addi	sp,sp,-32
    80001ff4:	ec06                	sd	ra,24(sp)
    80001ff6:	e822                	sd	s0,16(sp)
    80001ff8:	e426                	sd	s1,8(sp)
    80001ffa:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	f16080e7          	jalr	-234(ra) # 80001f12 <allocproc>
    80002004:	84aa                	mv	s1,a0
  initproc = p;
    80002006:	00007797          	auipc	a5,0x7
    8000200a:	96a7b923          	sd	a0,-1678(a5) # 80008978 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000200e:	03400613          	li	a2,52
    80002012:	00007597          	auipc	a1,0x7
    80002016:	8de58593          	addi	a1,a1,-1826 # 800088f0 <initcode>
    8000201a:	6928                	ld	a0,80(a0)
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	410080e7          	jalr	1040(ra) # 8000142c <uvmfirst>
  p->sz = PGSIZE;
    80002024:	6785                	lui	a5,0x1
    80002026:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80002028:	6cb8                	ld	a4,88(s1)
    8000202a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000202e:	6cb8                	ld	a4,88(s1)
    80002030:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002032:	4641                	li	a2,16
    80002034:	00006597          	auipc	a1,0x6
    80002038:	20c58593          	addi	a1,a1,524 # 80008240 <digits+0x200>
    8000203c:	15848513          	addi	a0,s1,344
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	eb2080e7          	jalr	-334(ra) # 80000ef2 <safestrcpy>
  p->cwd = namei("/");
    80002048:	00006517          	auipc	a0,0x6
    8000204c:	20850513          	addi	a0,a0,520 # 80008250 <digits+0x210>
    80002050:	00002097          	auipc	ra,0x2
    80002054:	6d2080e7          	jalr	1746(ra) # 80004722 <namei>
    80002058:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000205c:	478d                	li	a5,3
    8000205e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002060:	8526                	mv	a0,s1
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	cfe080e7          	jalr	-770(ra) # 80000d60 <release>
}
    8000206a:	60e2                	ld	ra,24(sp)
    8000206c:	6442                	ld	s0,16(sp)
    8000206e:	64a2                	ld	s1,8(sp)
    80002070:	6105                	addi	sp,sp,32
    80002072:	8082                	ret

0000000080002074 <growproc>:
{
    80002074:	1101                	addi	sp,sp,-32
    80002076:	ec06                	sd	ra,24(sp)
    80002078:	e822                	sd	s0,16(sp)
    8000207a:	e426                	sd	s1,8(sp)
    8000207c:	e04a                	sd	s2,0(sp)
    8000207e:	1000                	addi	s0,sp,32
    80002080:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80002082:	00000097          	auipc	ra,0x0
    80002086:	c86080e7          	jalr	-890(ra) # 80001d08 <myproc>
    8000208a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000208c:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000208e:	05205463          	blez	s2,800020d6 <growproc+0x62>
    if (p->is_thread == 1) {
    80002092:	16852703          	lw	a4,360(a0)
    80002096:	4785                	li	a5,1
    80002098:	02f70463          	beq	a4,a5,800020c0 <growproc+0x4c>
    } else if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000209c:	4691                	li	a3,4
    8000209e:	00b90633          	add	a2,s2,a1
    800020a2:	6928                	ld	a0,80(a0)
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	442080e7          	jalr	1090(ra) # 800014e6 <uvmalloc>
    800020ac:	85aa                	mv	a1,a0
    800020ae:	cd21                	beqz	a0,80002106 <growproc+0x92>
  p->sz = sz;
    800020b0:	e4ac                	sd	a1,72(s1)
  return 0;
    800020b2:	4501                	li	a0,0
}
    800020b4:	60e2                	ld	ra,24(sp)
    800020b6:	6442                	ld	s0,16(sp)
    800020b8:	64a2                	ld	s1,8(sp)
    800020ba:	6902                	ld	s2,0(sp)
    800020bc:	6105                	addi	sp,sp,32
    800020be:	8082                	ret
      if ((sz = uvmthreaded_alloc(p, sz, sz + n, PTE_W)) == 0) {
    800020c0:	4691                	li	a3,4
    800020c2:	00b90633          	add	a2,s2,a1
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	4d2080e7          	jalr	1234(ra) # 80001598 <uvmthreaded_alloc>
    800020ce:	85aa                	mv	a1,a0
    800020d0:	f165                	bnez	a0,800020b0 <growproc+0x3c>
        return -1;
    800020d2:	557d                	li	a0,-1
    800020d4:	b7c5                	j	800020b4 <growproc+0x40>
  } else if(n < 0){
    800020d6:	fc095de3          	bgez	s2,800020b0 <growproc+0x3c>
    if (p->is_thread == 1)
    800020da:	16852703          	lw	a4,360(a0)
    800020de:	4785                	li	a5,1
    800020e0:	00f70b63          	beq	a4,a5,800020f6 <growproc+0x82>
      sz = uvmdealloc(p->pagetable, sz, sz + n);
    800020e4:	00b90633          	add	a2,s2,a1
    800020e8:	6928                	ld	a0,80(a0)
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	3b4080e7          	jalr	948(ra) # 8000149e <uvmdealloc>
    800020f2:	85aa                	mv	a1,a0
    800020f4:	bf75                	j	800020b0 <growproc+0x3c>
      sz = uvmthreaded_dealloc(p, sz, sz + n);
    800020f6:	00b90633          	add	a2,s2,a1
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	5c4080e7          	jalr	1476(ra) # 800016be <uvmthreaded_dealloc>
    80002102:	85aa                	mv	a1,a0
    80002104:	b775                	j	800020b0 <growproc+0x3c>
      return -1;
    80002106:	557d                	li	a0,-1
    80002108:	b775                	j	800020b4 <growproc+0x40>

000000008000210a <fork>:
{
    8000210a:	7139                	addi	sp,sp,-64
    8000210c:	fc06                	sd	ra,56(sp)
    8000210e:	f822                	sd	s0,48(sp)
    80002110:	f426                	sd	s1,40(sp)
    80002112:	f04a                	sd	s2,32(sp)
    80002114:	ec4e                	sd	s3,24(sp)
    80002116:	e852                	sd	s4,16(sp)
    80002118:	e456                	sd	s5,8(sp)
    8000211a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000211c:	00000097          	auipc	ra,0x0
    80002120:	bec080e7          	jalr	-1044(ra) # 80001d08 <myproc>
    80002124:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80002126:	00000097          	auipc	ra,0x0
    8000212a:	dec080e7          	jalr	-532(ra) # 80001f12 <allocproc>
    8000212e:	10050e63          	beqz	a0,8000224a <fork+0x140>
    80002132:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002134:	048ab603          	ld	a2,72(s5)
    80002138:	692c                	ld	a1,80(a0)
    8000213a:	050ab503          	ld	a0,80(s5)
    8000213e:	fffff097          	auipc	ra,0xfffff
    80002142:	6cc080e7          	jalr	1740(ra) # 8000180a <uvmcopy>
    80002146:	04054863          	bltz	a0,80002196 <fork+0x8c>
  np->sz = p->sz;
    8000214a:	048ab783          	ld	a5,72(s5)
    8000214e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80002152:	058ab683          	ld	a3,88(s5)
    80002156:	87b6                	mv	a5,a3
    80002158:	0589b703          	ld	a4,88(s3)
    8000215c:	12068693          	addi	a3,a3,288
    80002160:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002164:	6788                	ld	a0,8(a5)
    80002166:	6b8c                	ld	a1,16(a5)
    80002168:	6f90                	ld	a2,24(a5)
    8000216a:	01073023          	sd	a6,0(a4)
    8000216e:	e708                	sd	a0,8(a4)
    80002170:	eb0c                	sd	a1,16(a4)
    80002172:	ef10                	sd	a2,24(a4)
    80002174:	02078793          	addi	a5,a5,32
    80002178:	02070713          	addi	a4,a4,32
    8000217c:	fed792e3          	bne	a5,a3,80002160 <fork+0x56>
  np->trapframe->a0 = 0;
    80002180:	0589b783          	ld	a5,88(s3)
    80002184:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002188:	0d0a8493          	addi	s1,s5,208
    8000218c:	0d098913          	addi	s2,s3,208
    80002190:	150a8a13          	addi	s4,s5,336
    80002194:	a00d                	j	800021b6 <fork+0xac>
    freeproc(np);
    80002196:	854e                	mv	a0,s3
    80002198:	00000097          	auipc	ra,0x0
    8000219c:	d22080e7          	jalr	-734(ra) # 80001eba <freeproc>
    release(&np->lock);
    800021a0:	854e                	mv	a0,s3
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	bbe080e7          	jalr	-1090(ra) # 80000d60 <release>
    return -1;
    800021aa:	597d                	li	s2,-1
    800021ac:	a069                	j	80002236 <fork+0x12c>
  for(i = 0; i < NOFILE; i++)
    800021ae:	04a1                	addi	s1,s1,8
    800021b0:	0921                	addi	s2,s2,8
    800021b2:	01448b63          	beq	s1,s4,800021c8 <fork+0xbe>
    if(p->ofile[i])
    800021b6:	6088                	ld	a0,0(s1)
    800021b8:	d97d                	beqz	a0,800021ae <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800021ba:	00003097          	auipc	ra,0x3
    800021be:	bfe080e7          	jalr	-1026(ra) # 80004db8 <filedup>
    800021c2:	00a93023          	sd	a0,0(s2)
    800021c6:	b7e5                	j	800021ae <fork+0xa4>
  np->cwd = idup(p->cwd);
    800021c8:	150ab503          	ld	a0,336(s5)
    800021cc:	00002097          	auipc	ra,0x2
    800021d0:	d6c080e7          	jalr	-660(ra) # 80003f38 <idup>
    800021d4:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800021d8:	4641                	li	a2,16
    800021da:	158a8593          	addi	a1,s5,344
    800021de:	15898513          	addi	a0,s3,344
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	d10080e7          	jalr	-752(ra) # 80000ef2 <safestrcpy>
  pid = np->pid;
    800021ea:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800021ee:	854e                	mv	a0,s3
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	b70080e7          	jalr	-1168(ra) # 80000d60 <release>
  acquire(&wait_lock);
    800021f8:	0004f497          	auipc	s1,0x4f
    800021fc:	a1048493          	addi	s1,s1,-1520 # 80050c08 <wait_lock>
    80002200:	8526                	mv	a0,s1
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	aaa080e7          	jalr	-1366(ra) # 80000cac <acquire>
  np->parent = p;
    8000220a:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000220e:	8526                	mv	a0,s1
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	b50080e7          	jalr	-1200(ra) # 80000d60 <release>
  acquire(&np->lock);
    80002218:	854e                	mv	a0,s3
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	a92080e7          	jalr	-1390(ra) # 80000cac <acquire>
  np->state = RUNNABLE;
    80002222:	478d                	li	a5,3
    80002224:	00f9ac23          	sw	a5,24(s3)
  np->is_thread = 0;
    80002228:	1609a423          	sw	zero,360(s3)
  release(&np->lock);
    8000222c:	854e                	mv	a0,s3
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	b32080e7          	jalr	-1230(ra) # 80000d60 <release>
}
    80002236:	854a                	mv	a0,s2
    80002238:	70e2                	ld	ra,56(sp)
    8000223a:	7442                	ld	s0,48(sp)
    8000223c:	74a2                	ld	s1,40(sp)
    8000223e:	7902                	ld	s2,32(sp)
    80002240:	69e2                	ld	s3,24(sp)
    80002242:	6a42                	ld	s4,16(sp)
    80002244:	6aa2                	ld	s5,8(sp)
    80002246:	6121                	addi	sp,sp,64
    80002248:	8082                	ret
    return -1;
    8000224a:	597d                	li	s2,-1
    8000224c:	b7ed                	j	80002236 <fork+0x12c>

000000008000224e <create_thread>:
int create_thread(void* (*fn_addr)(void *), void *args, void *stack_addr, void (*exit_fn)(uint64)) {
    8000224e:	715d                	addi	sp,sp,-80
    80002250:	e486                	sd	ra,72(sp)
    80002252:	e0a2                	sd	s0,64(sp)
    80002254:	fc26                	sd	s1,56(sp)
    80002256:	f84a                	sd	s2,48(sp)
    80002258:	f44e                	sd	s3,40(sp)
    8000225a:	f052                	sd	s4,32(sp)
    8000225c:	ec56                	sd	s5,24(sp)
    8000225e:	e85a                	sd	s6,16(sp)
    80002260:	e45e                	sd	s7,8(sp)
    80002262:	0880                	addi	s0,sp,80
    80002264:	8baa                	mv	s7,a0
    80002266:	8b2e                	mv	s6,a1
    80002268:	84b2                	mv	s1,a2
    8000226a:	89b6                	mv	s3,a3
  struct proc *p = myproc();
    8000226c:	00000097          	auipc	ra,0x0
    80002270:	a9c080e7          	jalr	-1380(ra) # 80001d08 <myproc>
    80002274:	8aaa                	mv	s5,a0
  for (int i = 0; i < MAX_THREADS; i++) {
    80002276:	17050713          	addi	a4,a0,368
    8000227a:	4781                	li	a5,0
    8000227c:	04000693          	li	a3,64
    if (p->infant_threads[i] == 0) {
    80002280:	00073803          	ld	a6,0(a4)
    80002284:	00080863          	beqz	a6,80002294 <create_thread+0x46>
  for (int i = 0; i < MAX_THREADS; i++) {
    80002288:	2785                	addiw	a5,a5,1
    8000228a:	0721                	addi	a4,a4,8
    8000228c:	fed79ae3          	bne	a5,a3,80002280 <create_thread+0x32>
  uint64 thread_idx = 0;
    80002290:	4901                	li	s2,0
    80002292:	a011                	j	80002296 <create_thread+0x48>
      thread_idx = i;
    80002294:	893e                	mv	s2,a5
  if((np = allocproc()) == 0){
    80002296:	00000097          	auipc	ra,0x0
    8000229a:	c7c080e7          	jalr	-900(ra) # 80001f12 <allocproc>
    8000229e:	8a2a                	mv	s4,a0
    800022a0:	cd3d                	beqz	a0,8000231e <create_thread+0xd0>
  if(uvmshare(p->pagetable, np->pagetable, p->sz) < 0){
    800022a2:	048ab603          	ld	a2,72(s5)
    800022a6:	692c                	ld	a1,80(a0)
    800022a8:	050ab503          	ld	a0,80(s5)
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	630080e7          	jalr	1584(ra) # 800018dc <uvmshare>
    800022b4:	06054f63          	bltz	a0,80002332 <create_thread+0xe4>
  np->sz = p->sz;
    800022b8:	048ab783          	ld	a5,72(s5)
    800022bc:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800022c0:	058ab683          	ld	a3,88(s5)
    800022c4:	87b6                	mv	a5,a3
    800022c6:	058a3703          	ld	a4,88(s4)
    800022ca:	12068693          	addi	a3,a3,288
    800022ce:	0007b803          	ld	a6,0(a5)
    800022d2:	6788                	ld	a0,8(a5)
    800022d4:	6b8c                	ld	a1,16(a5)
    800022d6:	6f90                	ld	a2,24(a5)
    800022d8:	01073023          	sd	a6,0(a4)
    800022dc:	e708                	sd	a0,8(a4)
    800022de:	eb0c                	sd	a1,16(a4)
    800022e0:	ef10                	sd	a2,24(a4)
    800022e2:	02078793          	addi	a5,a5,32
    800022e6:	02070713          	addi	a4,a4,32
    800022ea:	fed792e3          	bne	a5,a3,800022ce <create_thread+0x80>
  np->trapframe->sp = (uint64)stack_addr + PGSIZE;
    800022ee:	058a3783          	ld	a5,88(s4)
    800022f2:	6705                	lui	a4,0x1
    800022f4:	94ba                	add	s1,s1,a4
    800022f6:	fb84                	sd	s1,48(a5)
  np->trapframe->epc = (uint64)fn_addr;
    800022f8:	058a3783          	ld	a5,88(s4)
    800022fc:	0177bc23          	sd	s7,24(a5)
  np->trapframe->a0 = (uint64)args;
    80002300:	058a3783          	ld	a5,88(s4)
    80002304:	0767b823          	sd	s6,112(a5)
  np->trapframe->ra = (uint64)exit_fn;
    80002308:	058a3783          	ld	a5,88(s4)
    8000230c:	0337b423          	sd	s3,40(a5)
  for(i = 0; i < NOFILE; i++)
    80002310:	0d0a8493          	addi	s1,s5,208
    80002314:	0d0a0993          	addi	s3,s4,208
    80002318:	150a8b13          	addi	s6,s5,336
    8000231c:	a089                	j	8000235e <create_thread+0x110>
    printf("Max processes reached\n");
    8000231e:	00006517          	auipc	a0,0x6
    80002322:	f3a50513          	addi	a0,a0,-198 # 80008258 <digits+0x218>
    80002326:	ffffe097          	auipc	ra,0xffffe
    8000232a:	264080e7          	jalr	612(ra) # 8000058a <printf>
    return -1;
    8000232e:	557d                	li	a0,-1
    80002330:	a85d                	j	800023e6 <create_thread+0x198>
    freeproc(np);
    80002332:	8552                	mv	a0,s4
    80002334:	00000097          	auipc	ra,0x0
    80002338:	b86080e7          	jalr	-1146(ra) # 80001eba <freeproc>
    release(&np->lock);
    8000233c:	8552                	mv	a0,s4
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	a22080e7          	jalr	-1502(ra) # 80000d60 <release>
    return -1;
    80002346:	557d                	li	a0,-1
    80002348:	a879                	j	800023e6 <create_thread+0x198>
      np->ofile[i] = filedup(p->ofile[i]);
    8000234a:	00003097          	auipc	ra,0x3
    8000234e:	a6e080e7          	jalr	-1426(ra) # 80004db8 <filedup>
    80002352:	00a9b023          	sd	a0,0(s3)
  for(i = 0; i < NOFILE; i++)
    80002356:	04a1                	addi	s1,s1,8
    80002358:	09a1                	addi	s3,s3,8
    8000235a:	01648563          	beq	s1,s6,80002364 <create_thread+0x116>
    if(p->ofile[i])
    8000235e:	6088                	ld	a0,0(s1)
    80002360:	f56d                	bnez	a0,8000234a <create_thread+0xfc>
    80002362:	bfd5                	j	80002356 <create_thread+0x108>
  np->cwd = idup(p->cwd);
    80002364:	150ab503          	ld	a0,336(s5)
    80002368:	00002097          	auipc	ra,0x2
    8000236c:	bd0080e7          	jalr	-1072(ra) # 80003f38 <idup>
    80002370:	14aa3823          	sd	a0,336(s4)
  release(&np->lock);
    80002374:	8552                	mv	a0,s4
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	9ea080e7          	jalr	-1558(ra) # 80000d60 <release>
  acquire(&wait_lock);
    8000237e:	0004f517          	auipc	a0,0x4f
    80002382:	88a50513          	addi	a0,a0,-1910 # 80050c08 <wait_lock>
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	926080e7          	jalr	-1754(ra) # 80000cac <acquire>
  if (p->is_thread) {
    8000238e:	168aa783          	lw	a5,360(s5)
    80002392:	c7ad                	beqz	a5,800023fc <create_thread+0x1ae>
    np->parent = p->parent->parent;
    80002394:	038ab783          	ld	a5,56(s5)
    80002398:	7f9c                	ld	a5,56(a5)
    8000239a:	02fa3c23          	sd	a5,56(s4)
    p = p->parent->parent;
    8000239e:	038ab783          	ld	a5,56(s5)
    800023a2:	0387ba83          	ld	s5,56(a5)
  release(&wait_lock);
    800023a6:	0004f517          	auipc	a0,0x4f
    800023aa:	86250513          	addi	a0,a0,-1950 # 80050c08 <wait_lock>
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	9b2080e7          	jalr	-1614(ra) # 80000d60 <release>
  acquire(&np->lock);
    800023b6:	8552                	mv	a0,s4
    800023b8:	fffff097          	auipc	ra,0xfffff
    800023bc:	8f4080e7          	jalr	-1804(ra) # 80000cac <acquire>
  np->is_thread = 1;
    800023c0:	4785                	li	a5,1
    800023c2:	16fa2423          	sw	a5,360(s4)
  np->state = RUNNABLE;
    800023c6:	478d                	li	a5,3
    800023c8:	00fa2c23          	sw	a5,24(s4)
  p->infant_threads[thread_idx] = np;
    800023cc:	02e90793          	addi	a5,s2,46
    800023d0:	078e                	slli	a5,a5,0x3
    800023d2:	9abe                	add	s5,s5,a5
    800023d4:	014ab023          	sd	s4,0(s5)
  release(&np->lock);
    800023d8:	8552                	mv	a0,s4
    800023da:	fffff097          	auipc	ra,0xfffff
    800023de:	986080e7          	jalr	-1658(ra) # 80000d60 <release>
  return np->pid;
    800023e2:	030a2503          	lw	a0,48(s4)
}
    800023e6:	60a6                	ld	ra,72(sp)
    800023e8:	6406                	ld	s0,64(sp)
    800023ea:	74e2                	ld	s1,56(sp)
    800023ec:	7942                	ld	s2,48(sp)
    800023ee:	79a2                	ld	s3,40(sp)
    800023f0:	7a02                	ld	s4,32(sp)
    800023f2:	6ae2                	ld	s5,24(sp)
    800023f4:	6b42                	ld	s6,16(sp)
    800023f6:	6ba2                	ld	s7,8(sp)
    800023f8:	6161                	addi	sp,sp,80
    800023fa:	8082                	ret
    np->parent = p;
    800023fc:	035a3c23          	sd	s5,56(s4)
    80002400:	b75d                	j	800023a6 <create_thread+0x158>

0000000080002402 <scheduler>:
{
    80002402:	7139                	addi	sp,sp,-64
    80002404:	fc06                	sd	ra,56(sp)
    80002406:	f822                	sd	s0,48(sp)
    80002408:	f426                	sd	s1,40(sp)
    8000240a:	f04a                	sd	s2,32(sp)
    8000240c:	ec4e                	sd	s3,24(sp)
    8000240e:	e852                	sd	s4,16(sp)
    80002410:	e456                	sd	s5,8(sp)
    80002412:	e05a                	sd	s6,0(sp)
    80002414:	0080                	addi	s0,sp,64
    80002416:	8792                	mv	a5,tp
  int id = r_tp();
    80002418:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000241a:	00779a93          	slli	s5,a5,0x7
    8000241e:	0004e717          	auipc	a4,0x4e
    80002422:	7d270713          	addi	a4,a4,2002 # 80050bf0 <pid_lock>
    80002426:	9756                	add	a4,a4,s5
    80002428:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000242c:	0004e717          	auipc	a4,0x4e
    80002430:	7fc70713          	addi	a4,a4,2044 # 80050c28 <cpus+0x8>
    80002434:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80002436:	498d                	li	s3,3
        p->state = RUNNING;
    80002438:	4b11                	li	s6,4
        c->proc = p;
    8000243a:	079e                	slli	a5,a5,0x7
    8000243c:	0004ea17          	auipc	s4,0x4e
    80002440:	7b4a0a13          	addi	s4,s4,1972 # 80050bf0 <pid_lock>
    80002444:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002446:	0005c917          	auipc	s2,0x5c
    8000244a:	7da90913          	addi	s2,s2,2010 # 8005ec20 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000244e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002452:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002456:	10079073          	csrw	sstatus,a5
    8000245a:	0004f497          	auipc	s1,0x4f
    8000245e:	bc648493          	addi	s1,s1,-1082 # 80051020 <proc>
    80002462:	a811                	j	80002476 <scheduler+0x74>
      release(&p->lock);
    80002464:	8526                	mv	a0,s1
    80002466:	fffff097          	auipc	ra,0xfffff
    8000246a:	8fa080e7          	jalr	-1798(ra) # 80000d60 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000246e:	37048493          	addi	s1,s1,880
    80002472:	fd248ee3          	beq	s1,s2,8000244e <scheduler+0x4c>
      acquire(&p->lock);
    80002476:	8526                	mv	a0,s1
    80002478:	fffff097          	auipc	ra,0xfffff
    8000247c:	834080e7          	jalr	-1996(ra) # 80000cac <acquire>
      if(p->state == RUNNABLE) {
    80002480:	4c9c                	lw	a5,24(s1)
    80002482:	ff3791e3          	bne	a5,s3,80002464 <scheduler+0x62>
        p->state = RUNNING;
    80002486:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000248a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000248e:	06048593          	addi	a1,s1,96
    80002492:	8556                	mv	a0,s5
    80002494:	00001097          	auipc	ra,0x1
    80002498:	97e080e7          	jalr	-1666(ra) # 80002e12 <swtch>
        c->proc = 0;
    8000249c:	020a3823          	sd	zero,48(s4)
    800024a0:	b7d1                	j	80002464 <scheduler+0x62>

00000000800024a2 <sched>:
{
    800024a2:	7179                	addi	sp,sp,-48
    800024a4:	f406                	sd	ra,40(sp)
    800024a6:	f022                	sd	s0,32(sp)
    800024a8:	ec26                	sd	s1,24(sp)
    800024aa:	e84a                	sd	s2,16(sp)
    800024ac:	e44e                	sd	s3,8(sp)
    800024ae:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800024b0:	00000097          	auipc	ra,0x0
    800024b4:	858080e7          	jalr	-1960(ra) # 80001d08 <myproc>
    800024b8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800024ba:	ffffe097          	auipc	ra,0xffffe
    800024be:	778080e7          	jalr	1912(ra) # 80000c32 <holding>
    800024c2:	c93d                	beqz	a0,80002538 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800024c4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800024c6:	2781                	sext.w	a5,a5
    800024c8:	079e                	slli	a5,a5,0x7
    800024ca:	0004e717          	auipc	a4,0x4e
    800024ce:	72670713          	addi	a4,a4,1830 # 80050bf0 <pid_lock>
    800024d2:	97ba                	add	a5,a5,a4
    800024d4:	0a87a703          	lw	a4,168(a5)
    800024d8:	4785                	li	a5,1
    800024da:	06f71763          	bne	a4,a5,80002548 <sched+0xa6>
  if(p->state == RUNNING)
    800024de:	4c98                	lw	a4,24(s1)
    800024e0:	4791                	li	a5,4
    800024e2:	06f70b63          	beq	a4,a5,80002558 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024e6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800024ea:	8b89                	andi	a5,a5,2
  if(intr_get())
    800024ec:	efb5                	bnez	a5,80002568 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800024ee:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800024f0:	0004e917          	auipc	s2,0x4e
    800024f4:	70090913          	addi	s2,s2,1792 # 80050bf0 <pid_lock>
    800024f8:	2781                	sext.w	a5,a5
    800024fa:	079e                	slli	a5,a5,0x7
    800024fc:	97ca                	add	a5,a5,s2
    800024fe:	0ac7a983          	lw	s3,172(a5)
    80002502:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002504:	2781                	sext.w	a5,a5
    80002506:	079e                	slli	a5,a5,0x7
    80002508:	0004e597          	auipc	a1,0x4e
    8000250c:	72058593          	addi	a1,a1,1824 # 80050c28 <cpus+0x8>
    80002510:	95be                	add	a1,a1,a5
    80002512:	06048513          	addi	a0,s1,96
    80002516:	00001097          	auipc	ra,0x1
    8000251a:	8fc080e7          	jalr	-1796(ra) # 80002e12 <swtch>
    8000251e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002520:	2781                	sext.w	a5,a5
    80002522:	079e                	slli	a5,a5,0x7
    80002524:	993e                	add	s2,s2,a5
    80002526:	0b392623          	sw	s3,172(s2)
}
    8000252a:	70a2                	ld	ra,40(sp)
    8000252c:	7402                	ld	s0,32(sp)
    8000252e:	64e2                	ld	s1,24(sp)
    80002530:	6942                	ld	s2,16(sp)
    80002532:	69a2                	ld	s3,8(sp)
    80002534:	6145                	addi	sp,sp,48
    80002536:	8082                	ret
    panic("sched p->lock");
    80002538:	00006517          	auipc	a0,0x6
    8000253c:	d3850513          	addi	a0,a0,-712 # 80008270 <digits+0x230>
    80002540:	ffffe097          	auipc	ra,0xffffe
    80002544:	000080e7          	jalr	ra # 80000540 <panic>
    panic("sched locks");
    80002548:	00006517          	auipc	a0,0x6
    8000254c:	d3850513          	addi	a0,a0,-712 # 80008280 <digits+0x240>
    80002550:	ffffe097          	auipc	ra,0xffffe
    80002554:	ff0080e7          	jalr	-16(ra) # 80000540 <panic>
    panic("sched running");
    80002558:	00006517          	auipc	a0,0x6
    8000255c:	d3850513          	addi	a0,a0,-712 # 80008290 <digits+0x250>
    80002560:	ffffe097          	auipc	ra,0xffffe
    80002564:	fe0080e7          	jalr	-32(ra) # 80000540 <panic>
    panic("sched interruptible");
    80002568:	00006517          	auipc	a0,0x6
    8000256c:	d3850513          	addi	a0,a0,-712 # 800082a0 <digits+0x260>
    80002570:	ffffe097          	auipc	ra,0xffffe
    80002574:	fd0080e7          	jalr	-48(ra) # 80000540 <panic>

0000000080002578 <yield>:
{
    80002578:	1101                	addi	sp,sp,-32
    8000257a:	ec06                	sd	ra,24(sp)
    8000257c:	e822                	sd	s0,16(sp)
    8000257e:	e426                	sd	s1,8(sp)
    80002580:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002582:	fffff097          	auipc	ra,0xfffff
    80002586:	786080e7          	jalr	1926(ra) # 80001d08 <myproc>
    8000258a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000258c:	ffffe097          	auipc	ra,0xffffe
    80002590:	720080e7          	jalr	1824(ra) # 80000cac <acquire>
  p->state = RUNNABLE;
    80002594:	478d                	li	a5,3
    80002596:	cc9c                	sw	a5,24(s1)
  sched();
    80002598:	00000097          	auipc	ra,0x0
    8000259c:	f0a080e7          	jalr	-246(ra) # 800024a2 <sched>
  release(&p->lock);
    800025a0:	8526                	mv	a0,s1
    800025a2:	ffffe097          	auipc	ra,0xffffe
    800025a6:	7be080e7          	jalr	1982(ra) # 80000d60 <release>
}
    800025aa:	60e2                	ld	ra,24(sp)
    800025ac:	6442                	ld	s0,16(sp)
    800025ae:	64a2                	ld	s1,8(sp)
    800025b0:	6105                	addi	sp,sp,32
    800025b2:	8082                	ret

00000000800025b4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800025b4:	7179                	addi	sp,sp,-48
    800025b6:	f406                	sd	ra,40(sp)
    800025b8:	f022                	sd	s0,32(sp)
    800025ba:	ec26                	sd	s1,24(sp)
    800025bc:	e84a                	sd	s2,16(sp)
    800025be:	e44e                	sd	s3,8(sp)
    800025c0:	1800                	addi	s0,sp,48
    800025c2:	89aa                	mv	s3,a0
    800025c4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800025c6:	fffff097          	auipc	ra,0xfffff
    800025ca:	742080e7          	jalr	1858(ra) # 80001d08 <myproc>
    800025ce:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800025d0:	ffffe097          	auipc	ra,0xffffe
    800025d4:	6dc080e7          	jalr	1756(ra) # 80000cac <acquire>
  release(lk);
    800025d8:	854a                	mv	a0,s2
    800025da:	ffffe097          	auipc	ra,0xffffe
    800025de:	786080e7          	jalr	1926(ra) # 80000d60 <release>

  // Go to sleep.
  p->chan = chan;
    800025e2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800025e6:	4789                	li	a5,2
    800025e8:	cc9c                	sw	a5,24(s1)

  sched();
    800025ea:	00000097          	auipc	ra,0x0
    800025ee:	eb8080e7          	jalr	-328(ra) # 800024a2 <sched>

  // Tidy up.
  p->chan = 0;
    800025f2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800025f6:	8526                	mv	a0,s1
    800025f8:	ffffe097          	auipc	ra,0xffffe
    800025fc:	768080e7          	jalr	1896(ra) # 80000d60 <release>
  acquire(lk);
    80002600:	854a                	mv	a0,s2
    80002602:	ffffe097          	auipc	ra,0xffffe
    80002606:	6aa080e7          	jalr	1706(ra) # 80000cac <acquire>
}
    8000260a:	70a2                	ld	ra,40(sp)
    8000260c:	7402                	ld	s0,32(sp)
    8000260e:	64e2                	ld	s1,24(sp)
    80002610:	6942                	ld	s2,16(sp)
    80002612:	69a2                	ld	s3,8(sp)
    80002614:	6145                	addi	sp,sp,48
    80002616:	8082                	ret

0000000080002618 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002618:	7139                	addi	sp,sp,-64
    8000261a:	fc06                	sd	ra,56(sp)
    8000261c:	f822                	sd	s0,48(sp)
    8000261e:	f426                	sd	s1,40(sp)
    80002620:	f04a                	sd	s2,32(sp)
    80002622:	ec4e                	sd	s3,24(sp)
    80002624:	e852                	sd	s4,16(sp)
    80002626:	e456                	sd	s5,8(sp)
    80002628:	0080                	addi	s0,sp,64
    8000262a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000262c:	0004f497          	auipc	s1,0x4f
    80002630:	9f448493          	addi	s1,s1,-1548 # 80051020 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002634:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002636:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002638:	0005c917          	auipc	s2,0x5c
    8000263c:	5e890913          	addi	s2,s2,1512 # 8005ec20 <tickslock>
    80002640:	a811                	j	80002654 <wakeup+0x3c>
      }
      release(&p->lock);
    80002642:	8526                	mv	a0,s1
    80002644:	ffffe097          	auipc	ra,0xffffe
    80002648:	71c080e7          	jalr	1820(ra) # 80000d60 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000264c:	37048493          	addi	s1,s1,880
    80002650:	03248663          	beq	s1,s2,8000267c <wakeup+0x64>
    if(p != myproc()){
    80002654:	fffff097          	auipc	ra,0xfffff
    80002658:	6b4080e7          	jalr	1716(ra) # 80001d08 <myproc>
    8000265c:	fea488e3          	beq	s1,a0,8000264c <wakeup+0x34>
      acquire(&p->lock);
    80002660:	8526                	mv	a0,s1
    80002662:	ffffe097          	auipc	ra,0xffffe
    80002666:	64a080e7          	jalr	1610(ra) # 80000cac <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000266a:	4c9c                	lw	a5,24(s1)
    8000266c:	fd379be3          	bne	a5,s3,80002642 <wakeup+0x2a>
    80002670:	709c                	ld	a5,32(s1)
    80002672:	fd4798e3          	bne	a5,s4,80002642 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002676:	0154ac23          	sw	s5,24(s1)
    8000267a:	b7e1                	j	80002642 <wakeup+0x2a>
    }
  }
}
    8000267c:	70e2                	ld	ra,56(sp)
    8000267e:	7442                	ld	s0,48(sp)
    80002680:	74a2                	ld	s1,40(sp)
    80002682:	7902                	ld	s2,32(sp)
    80002684:	69e2                	ld	s3,24(sp)
    80002686:	6a42                	ld	s4,16(sp)
    80002688:	6aa2                	ld	s5,8(sp)
    8000268a:	6121                	addi	sp,sp,64
    8000268c:	8082                	ret

000000008000268e <reparent>:
{
    8000268e:	7179                	addi	sp,sp,-48
    80002690:	f406                	sd	ra,40(sp)
    80002692:	f022                	sd	s0,32(sp)
    80002694:	ec26                	sd	s1,24(sp)
    80002696:	e84a                	sd	s2,16(sp)
    80002698:	e44e                	sd	s3,8(sp)
    8000269a:	e052                	sd	s4,0(sp)
    8000269c:	1800                	addi	s0,sp,48
    8000269e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800026a0:	0004f497          	auipc	s1,0x4f
    800026a4:	98048493          	addi	s1,s1,-1664 # 80051020 <proc>
      pp->parent = initproc;
    800026a8:	00006a17          	auipc	s4,0x6
    800026ac:	2d0a0a13          	addi	s4,s4,720 # 80008978 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800026b0:	0005c997          	auipc	s3,0x5c
    800026b4:	57098993          	addi	s3,s3,1392 # 8005ec20 <tickslock>
    800026b8:	a029                	j	800026c2 <reparent+0x34>
    800026ba:	37048493          	addi	s1,s1,880
    800026be:	01348d63          	beq	s1,s3,800026d8 <reparent+0x4a>
    if(pp->parent == p){
    800026c2:	7c9c                	ld	a5,56(s1)
    800026c4:	ff279be3          	bne	a5,s2,800026ba <reparent+0x2c>
      pp->parent = initproc;
    800026c8:	000a3503          	ld	a0,0(s4)
    800026cc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800026ce:	00000097          	auipc	ra,0x0
    800026d2:	f4a080e7          	jalr	-182(ra) # 80002618 <wakeup>
    800026d6:	b7d5                	j	800026ba <reparent+0x2c>
}
    800026d8:	70a2                	ld	ra,40(sp)
    800026da:	7402                	ld	s0,32(sp)
    800026dc:	64e2                	ld	s1,24(sp)
    800026de:	6942                	ld	s2,16(sp)
    800026e0:	69a2                	ld	s3,8(sp)
    800026e2:	6a02                	ld	s4,0(sp)
    800026e4:	6145                	addi	sp,sp,48
    800026e6:	8082                	ret

00000000800026e8 <thread_exit>:
uint64 thread_exit(uint64 status) {
    800026e8:	7179                	addi	sp,sp,-48
    800026ea:	f406                	sd	ra,40(sp)
    800026ec:	f022                	sd	s0,32(sp)
    800026ee:	ec26                	sd	s1,24(sp)
    800026f0:	e84a                	sd	s2,16(sp)
    800026f2:	e44e                	sd	s3,8(sp)
    800026f4:	e052                	sd	s4,0(sp)
    800026f6:	1800                	addi	s0,sp,48
    800026f8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800026fa:	fffff097          	auipc	ra,0xfffff
    800026fe:	60e080e7          	jalr	1550(ra) # 80001d08 <myproc>
    80002702:	89aa                	mv	s3,a0
  if(p == initproc)
    80002704:	00006797          	auipc	a5,0x6
    80002708:	2747b783          	ld	a5,628(a5) # 80008978 <initproc>
    8000270c:	0d050493          	addi	s1,a0,208
    80002710:	15050913          	addi	s2,a0,336
    80002714:	02a79363          	bne	a5,a0,8000273a <thread_exit+0x52>
    panic("init exiting");
    80002718:	00006517          	auipc	a0,0x6
    8000271c:	ba050513          	addi	a0,a0,-1120 # 800082b8 <digits+0x278>
    80002720:	ffffe097          	auipc	ra,0xffffe
    80002724:	e20080e7          	jalr	-480(ra) # 80000540 <panic>
      fileclose(f);
    80002728:	00002097          	auipc	ra,0x2
    8000272c:	6e2080e7          	jalr	1762(ra) # 80004e0a <fileclose>
      p->ofile[fd] = 0;
    80002730:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002734:	04a1                	addi	s1,s1,8
    80002736:	01248563          	beq	s1,s2,80002740 <thread_exit+0x58>
    if(p->ofile[fd]){
    8000273a:	6088                	ld	a0,0(s1)
    8000273c:	f575                	bnez	a0,80002728 <thread_exit+0x40>
    8000273e:	bfdd                	j	80002734 <thread_exit+0x4c>
  begin_op();
    80002740:	00002097          	auipc	ra,0x2
    80002744:	202080e7          	jalr	514(ra) # 80004942 <begin_op>
  iput(p->cwd);
    80002748:	1509b503          	ld	a0,336(s3)
    8000274c:	00002097          	auipc	ra,0x2
    80002750:	9e4080e7          	jalr	-1564(ra) # 80004130 <iput>
  end_op();
    80002754:	00002097          	auipc	ra,0x2
    80002758:	26c080e7          	jalr	620(ra) # 800049c0 <end_op>
  p->cwd = 0;
    8000275c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002760:	0004e497          	auipc	s1,0x4e
    80002764:	4a848493          	addi	s1,s1,1192 # 80050c08 <wait_lock>
    80002768:	8526                	mv	a0,s1
    8000276a:	ffffe097          	auipc	ra,0xffffe
    8000276e:	542080e7          	jalr	1346(ra) # 80000cac <acquire>
  reparent(p);
    80002772:	854e                	mv	a0,s3
    80002774:	00000097          	auipc	ra,0x0
    80002778:	f1a080e7          	jalr	-230(ra) # 8000268e <reparent>
  wakeup(p->parent);
    8000277c:	0389b503          	ld	a0,56(s3)
    80002780:	00000097          	auipc	ra,0x0
    80002784:	e98080e7          	jalr	-360(ra) # 80002618 <wakeup>
  acquire(&p->lock);
    80002788:	854e                	mv	a0,s3
    8000278a:	ffffe097          	auipc	ra,0xffffe
    8000278e:	522080e7          	jalr	1314(ra) # 80000cac <acquire>
  p->xstate = status;
    80002792:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002796:	4795                	li	a5,5
    80002798:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000279c:	8526                	mv	a0,s1
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	5c2080e7          	jalr	1474(ra) # 80000d60 <release>
  sched();
    800027a6:	00000097          	auipc	ra,0x0
    800027aa:	cfc080e7          	jalr	-772(ra) # 800024a2 <sched>
  panic("zombie exit");
    800027ae:	00006517          	auipc	a0,0x6
    800027b2:	b1a50513          	addi	a0,a0,-1254 # 800082c8 <digits+0x288>
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	d8a080e7          	jalr	-630(ra) # 80000540 <panic>

00000000800027be <exit>:
{
    800027be:	715d                	addi	sp,sp,-80
    800027c0:	e486                	sd	ra,72(sp)
    800027c2:	e0a2                	sd	s0,64(sp)
    800027c4:	fc26                	sd	s1,56(sp)
    800027c6:	f84a                	sd	s2,48(sp)
    800027c8:	f44e                	sd	s3,40(sp)
    800027ca:	f052                	sd	s4,32(sp)
    800027cc:	ec56                	sd	s5,24(sp)
    800027ce:	e85a                	sd	s6,16(sp)
    800027d0:	e45e                	sd	s7,8(sp)
    800027d2:	e062                	sd	s8,0(sp)
    800027d4:	0880                	addi	s0,sp,80
    800027d6:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800027d8:	fffff097          	auipc	ra,0xfffff
    800027dc:	530080e7          	jalr	1328(ra) # 80001d08 <myproc>
    800027e0:	89aa                	mv	s3,a0
  if (p->is_thread) {
    800027e2:	16852783          	lw	a5,360(a0)
    800027e6:	e39d                	bnez	a5,8000280c <exit+0x4e>
  if(p == initproc)
    800027e8:	00006797          	auipc	a5,0x6
    800027ec:	1907b783          	ld	a5,400(a5) # 80008978 <initproc>
    800027f0:	0d050493          	addi	s1,a0,208
    800027f4:	15050913          	addi	s2,a0,336
    800027f8:	0aa79963          	bne	a5,a0,800028aa <exit+0xec>
    panic("init exiting");
    800027fc:	00006517          	auipc	a0,0x6
    80002800:	abc50513          	addi	a0,a0,-1348 # 800082b8 <digits+0x278>
    80002804:	ffffe097          	auipc	ra,0xffffe
    80002808:	d3c080e7          	jalr	-708(ra) # 80000540 <panic>
    struct proc *parent = p->parent;
    8000280c:	03853b03          	ld	s6,56(a0)
    for (int i = 0; i < MAX_THREADS; i++) {
    80002810:	170b0a13          	addi	s4,s6,368
    80002814:	370b0b13          	addi	s6,s6,880
      acquire(&wait_lock);
    80002818:	0004ea97          	auipc	s5,0x4e
    8000281c:	3f0a8a93          	addi	s5,s5,1008 # 80050c08 <wait_lock>
      infant->state = ZOMBIE;
    80002820:	4c15                	li	s8,5
    80002822:	a885                	j	80002892 <exit+0xd4>
          fileclose(f);
    80002824:	00002097          	auipc	ra,0x2
    80002828:	5e6080e7          	jalr	1510(ra) # 80004e0a <fileclose>
          infant->ofile[fd] = 0;
    8000282c:	0004b023          	sd	zero,0(s1)
      for(int fd = 0; fd < NOFILE; fd++){
    80002830:	04a1                	addi	s1,s1,8
    80002832:	01248563          	beq	s1,s2,8000283c <exit+0x7e>
        if(infant->ofile[fd]){
    80002836:	6088                	ld	a0,0(s1)
    80002838:	f575                	bnez	a0,80002824 <exit+0x66>
    8000283a:	bfdd                	j	80002830 <exit+0x72>
      begin_op();
    8000283c:	00002097          	auipc	ra,0x2
    80002840:	106080e7          	jalr	262(ra) # 80004942 <begin_op>
      iput(infant->cwd);
    80002844:	1509b503          	ld	a0,336(s3)
    80002848:	00002097          	auipc	ra,0x2
    8000284c:	8e8080e7          	jalr	-1816(ra) # 80004130 <iput>
      end_op();
    80002850:	00002097          	auipc	ra,0x2
    80002854:	170080e7          	jalr	368(ra) # 800049c0 <end_op>
      infant->cwd = 0;
    80002858:	1409b823          	sd	zero,336(s3)
      acquire(&wait_lock);
    8000285c:	8556                	mv	a0,s5
    8000285e:	ffffe097          	auipc	ra,0xffffe
    80002862:	44e080e7          	jalr	1102(ra) # 80000cac <acquire>
      acquire(&infant->lock);
    80002866:	854e                	mv	a0,s3
    80002868:	ffffe097          	auipc	ra,0xffffe
    8000286c:	444080e7          	jalr	1092(ra) # 80000cac <acquire>
      infant->xstate = status;
    80002870:	0379a623          	sw	s7,44(s3)
      infant->state = ZOMBIE;
    80002874:	0189ac23          	sw	s8,24(s3)
      release(&infant->lock);
    80002878:	854e                	mv	a0,s3
    8000287a:	ffffe097          	auipc	ra,0xffffe
    8000287e:	4e6080e7          	jalr	1254(ra) # 80000d60 <release>
      release(&wait_lock);
    80002882:	8556                	mv	a0,s5
    80002884:	ffffe097          	auipc	ra,0xffffe
    80002888:	4dc080e7          	jalr	1244(ra) # 80000d60 <release>
    for (int i = 0; i < MAX_THREADS; i++) {
    8000288c:	0a21                	addi	s4,s4,8
    8000288e:	0b6a0663          	beq	s4,s6,8000293a <exit+0x17c>
      struct proc *infant = parent->infant_threads[i];
    80002892:	000a3983          	ld	s3,0(s4)
      if (infant == 0) 
    80002896:	fe098be3          	beqz	s3,8000288c <exit+0xce>
    8000289a:	0d098493          	addi	s1,s3,208
    8000289e:	15098913          	addi	s2,s3,336
    800028a2:	bf51                	j	80002836 <exit+0x78>
  for(int fd = 0; fd < NOFILE; fd++){
    800028a4:	04a1                	addi	s1,s1,8
    800028a6:	01248b63          	beq	s1,s2,800028bc <exit+0xfe>
    if(p->ofile[fd]){
    800028aa:	6088                	ld	a0,0(s1)
    800028ac:	dd65                	beqz	a0,800028a4 <exit+0xe6>
      fileclose(f);
    800028ae:	00002097          	auipc	ra,0x2
    800028b2:	55c080e7          	jalr	1372(ra) # 80004e0a <fileclose>
      p->ofile[fd] = 0;
    800028b6:	0004b023          	sd	zero,0(s1)
    800028ba:	b7ed                	j	800028a4 <exit+0xe6>
  begin_op();
    800028bc:	00002097          	auipc	ra,0x2
    800028c0:	086080e7          	jalr	134(ra) # 80004942 <begin_op>
  iput(p->cwd);
    800028c4:	1509b503          	ld	a0,336(s3)
    800028c8:	00002097          	auipc	ra,0x2
    800028cc:	868080e7          	jalr	-1944(ra) # 80004130 <iput>
  end_op();
    800028d0:	00002097          	auipc	ra,0x2
    800028d4:	0f0080e7          	jalr	240(ra) # 800049c0 <end_op>
  p->cwd = 0;
    800028d8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800028dc:	0004e497          	auipc	s1,0x4e
    800028e0:	32c48493          	addi	s1,s1,812 # 80050c08 <wait_lock>
    800028e4:	8526                	mv	a0,s1
    800028e6:	ffffe097          	auipc	ra,0xffffe
    800028ea:	3c6080e7          	jalr	966(ra) # 80000cac <acquire>
  reparent(p);
    800028ee:	854e                	mv	a0,s3
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	d9e080e7          	jalr	-610(ra) # 8000268e <reparent>
  wakeup(p->parent);
    800028f8:	0389b503          	ld	a0,56(s3)
    800028fc:	00000097          	auipc	ra,0x0
    80002900:	d1c080e7          	jalr	-740(ra) # 80002618 <wakeup>
  acquire(&p->lock);
    80002904:	854e                	mv	a0,s3
    80002906:	ffffe097          	auipc	ra,0xffffe
    8000290a:	3a6080e7          	jalr	934(ra) # 80000cac <acquire>
  p->xstate = status;
    8000290e:	0379a623          	sw	s7,44(s3)
  p->state = ZOMBIE;
    80002912:	4795                	li	a5,5
    80002914:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002918:	8526                	mv	a0,s1
    8000291a:	ffffe097          	auipc	ra,0xffffe
    8000291e:	446080e7          	jalr	1094(ra) # 80000d60 <release>
  sched();
    80002922:	00000097          	auipc	ra,0x0
    80002926:	b80080e7          	jalr	-1152(ra) # 800024a2 <sched>
  panic("zombie exit");
    8000292a:	00006517          	auipc	a0,0x6
    8000292e:	99e50513          	addi	a0,a0,-1634 # 800082c8 <digits+0x288>
    80002932:	ffffe097          	auipc	ra,0xffffe
    80002936:	c0e080e7          	jalr	-1010(ra) # 80000540 <panic>
}
    8000293a:	60a6                	ld	ra,72(sp)
    8000293c:	6406                	ld	s0,64(sp)
    8000293e:	74e2                	ld	s1,56(sp)
    80002940:	7942                	ld	s2,48(sp)
    80002942:	79a2                	ld	s3,40(sp)
    80002944:	7a02                	ld	s4,32(sp)
    80002946:	6ae2                	ld	s5,24(sp)
    80002948:	6b42                	ld	s6,16(sp)
    8000294a:	6ba2                	ld	s7,8(sp)
    8000294c:	6c02                	ld	s8,0(sp)
    8000294e:	6161                	addi	sp,sp,80
    80002950:	8082                	ret

0000000080002952 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002952:	7179                	addi	sp,sp,-48
    80002954:	f406                	sd	ra,40(sp)
    80002956:	f022                	sd	s0,32(sp)
    80002958:	ec26                	sd	s1,24(sp)
    8000295a:	e84a                	sd	s2,16(sp)
    8000295c:	e44e                	sd	s3,8(sp)
    8000295e:	1800                	addi	s0,sp,48
    80002960:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002962:	0004e497          	auipc	s1,0x4e
    80002966:	6be48493          	addi	s1,s1,1726 # 80051020 <proc>
    8000296a:	0005c997          	auipc	s3,0x5c
    8000296e:	2b698993          	addi	s3,s3,694 # 8005ec20 <tickslock>
    acquire(&p->lock);
    80002972:	8526                	mv	a0,s1
    80002974:	ffffe097          	auipc	ra,0xffffe
    80002978:	338080e7          	jalr	824(ra) # 80000cac <acquire>
    if(p->pid == pid){
    8000297c:	589c                	lw	a5,48(s1)
    8000297e:	01278d63          	beq	a5,s2,80002998 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002982:	8526                	mv	a0,s1
    80002984:	ffffe097          	auipc	ra,0xffffe
    80002988:	3dc080e7          	jalr	988(ra) # 80000d60 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000298c:	37048493          	addi	s1,s1,880
    80002990:	ff3491e3          	bne	s1,s3,80002972 <kill+0x20>
  }
  return -1;
    80002994:	557d                	li	a0,-1
    80002996:	a829                	j	800029b0 <kill+0x5e>
      p->killed = 1;
    80002998:	4785                	li	a5,1
    8000299a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000299c:	4c98                	lw	a4,24(s1)
    8000299e:	4789                	li	a5,2
    800029a0:	00f70f63          	beq	a4,a5,800029be <kill+0x6c>
      release(&p->lock);
    800029a4:	8526                	mv	a0,s1
    800029a6:	ffffe097          	auipc	ra,0xffffe
    800029aa:	3ba080e7          	jalr	954(ra) # 80000d60 <release>
      return 0;
    800029ae:	4501                	li	a0,0
}
    800029b0:	70a2                	ld	ra,40(sp)
    800029b2:	7402                	ld	s0,32(sp)
    800029b4:	64e2                	ld	s1,24(sp)
    800029b6:	6942                	ld	s2,16(sp)
    800029b8:	69a2                	ld	s3,8(sp)
    800029ba:	6145                	addi	sp,sp,48
    800029bc:	8082                	ret
        p->state = RUNNABLE;
    800029be:	478d                	li	a5,3
    800029c0:	cc9c                	sw	a5,24(s1)
    800029c2:	b7cd                	j	800029a4 <kill+0x52>

00000000800029c4 <setkilled>:

void
setkilled(struct proc *p)
{
    800029c4:	1101                	addi	sp,sp,-32
    800029c6:	ec06                	sd	ra,24(sp)
    800029c8:	e822                	sd	s0,16(sp)
    800029ca:	e426                	sd	s1,8(sp)
    800029cc:	1000                	addi	s0,sp,32
    800029ce:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800029d0:	ffffe097          	auipc	ra,0xffffe
    800029d4:	2dc080e7          	jalr	732(ra) # 80000cac <acquire>
  p->killed = 1;
    800029d8:	4785                	li	a5,1
    800029da:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800029dc:	8526                	mv	a0,s1
    800029de:	ffffe097          	auipc	ra,0xffffe
    800029e2:	382080e7          	jalr	898(ra) # 80000d60 <release>
}
    800029e6:	60e2                	ld	ra,24(sp)
    800029e8:	6442                	ld	s0,16(sp)
    800029ea:	64a2                	ld	s1,8(sp)
    800029ec:	6105                	addi	sp,sp,32
    800029ee:	8082                	ret

00000000800029f0 <killed>:

int
killed(struct proc *p)
{
    800029f0:	1101                	addi	sp,sp,-32
    800029f2:	ec06                	sd	ra,24(sp)
    800029f4:	e822                	sd	s0,16(sp)
    800029f6:	e426                	sd	s1,8(sp)
    800029f8:	e04a                	sd	s2,0(sp)
    800029fa:	1000                	addi	s0,sp,32
    800029fc:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800029fe:	ffffe097          	auipc	ra,0xffffe
    80002a02:	2ae080e7          	jalr	686(ra) # 80000cac <acquire>
  k = p->killed;
    80002a06:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002a0a:	8526                	mv	a0,s1
    80002a0c:	ffffe097          	auipc	ra,0xffffe
    80002a10:	354080e7          	jalr	852(ra) # 80000d60 <release>
  return k;
}
    80002a14:	854a                	mv	a0,s2
    80002a16:	60e2                	ld	ra,24(sp)
    80002a18:	6442                	ld	s0,16(sp)
    80002a1a:	64a2                	ld	s1,8(sp)
    80002a1c:	6902                	ld	s2,0(sp)
    80002a1e:	6105                	addi	sp,sp,32
    80002a20:	8082                	ret

0000000080002a22 <join_thread>:
uint64 join_thread(uint64 thread_id, uint64 status_addr) {
    80002a22:	715d                	addi	sp,sp,-80
    80002a24:	e486                	sd	ra,72(sp)
    80002a26:	e0a2                	sd	s0,64(sp)
    80002a28:	fc26                	sd	s1,56(sp)
    80002a2a:	f84a                	sd	s2,48(sp)
    80002a2c:	f44e                	sd	s3,40(sp)
    80002a2e:	f052                	sd	s4,32(sp)
    80002a30:	ec56                	sd	s5,24(sp)
    80002a32:	e85a                	sd	s6,16(sp)
    80002a34:	e45e                	sd	s7,8(sp)
    80002a36:	0880                	addi	s0,sp,80
    80002a38:	8a2a                	mv	s4,a0
    80002a3a:	8b2e                	mv	s6,a1
  struct proc *p = myproc();
    80002a3c:	fffff097          	auipc	ra,0xfffff
    80002a40:	2cc080e7          	jalr	716(ra) # 80001d08 <myproc>
    80002a44:	89aa                	mv	s3,a0
  if (p->is_thread) 
    80002a46:	16852783          	lw	a5,360(a0)
    80002a4a:	c399                	beqz	a5,80002a50 <join_thread+0x2e>
    p = p->parent;
    80002a4c:	03853983          	ld	s3,56(a0)
  acquire(&wait_lock);
    80002a50:	0004e517          	auipc	a0,0x4e
    80002a54:	1b850513          	addi	a0,a0,440 # 80050c08 <wait_lock>
    80002a58:	ffffe097          	auipc	ra,0xffffe
    80002a5c:	254080e7          	jalr	596(ra) # 80000cac <acquire>
  for (thread_idx = 0; thread_idx < MAX_THREADS; thread_idx++) {
    80002a60:	17098793          	addi	a5,s3,368
    80002a64:	4901                	li	s2,0
    80002a66:	04000693          	li	a3,64
    80002a6a:	a029                	j	80002a74 <join_thread+0x52>
    80002a6c:	2905                	addiw	s2,s2,1
    80002a6e:	07a1                	addi	a5,a5,8
    80002a70:	04d90a63          	beq	s2,a3,80002ac4 <join_thread+0xa2>
    if (p->infant_threads[thread_idx] && thread_id == p->infant_threads[thread_idx]->pid) {
    80002a74:	6384                	ld	s1,0(a5)
    80002a76:	d8fd                	beqz	s1,80002a6c <join_thread+0x4a>
    80002a78:	5898                	lw	a4,48(s1)
    80002a7a:	ff4719e3          	bne	a4,s4,80002a6c <join_thread+0x4a>
  if (thread_idx == MAX_THREADS) {
    80002a7e:	04000793          	li	a5,64
    if (child->state == ZOMBIE) {
    80002a82:	4a95                	li	s5,5
    sleep(p, &wait_lock);
    80002a84:	0004eb97          	auipc	s7,0x4e
    80002a88:	184b8b93          	addi	s7,s7,388 # 80050c08 <wait_lock>
  if (thread_idx == MAX_THREADS) {
    80002a8c:	02f90c63          	beq	s2,a5,80002ac4 <join_thread+0xa2>
    acquire(&child->lock);
    80002a90:	8526                	mv	a0,s1
    80002a92:	ffffe097          	auipc	ra,0xffffe
    80002a96:	21a080e7          	jalr	538(ra) # 80000cac <acquire>
    if (child->state == ZOMBIE) {
    80002a9a:	4c9c                	lw	a5,24(s1)
    80002a9c:	03578e63          	beq	a5,s5,80002ad8 <join_thread+0xb6>
    release(&child->lock);
    80002aa0:	8526                	mv	a0,s1
    80002aa2:	ffffe097          	auipc	ra,0xffffe
    80002aa6:	2be080e7          	jalr	702(ra) # 80000d60 <release>
    if (killed(p)) {
    80002aaa:	854e                	mv	a0,s3
    80002aac:	00000097          	auipc	ra,0x0
    80002ab0:	f44080e7          	jalr	-188(ra) # 800029f0 <killed>
    80002ab4:	e541                	bnez	a0,80002b3c <join_thread+0x11a>
    sleep(p, &wait_lock);
    80002ab6:	85de                	mv	a1,s7
    80002ab8:	854e                	mv	a0,s3
    80002aba:	00000097          	auipc	ra,0x0
    80002abe:	afa080e7          	jalr	-1286(ra) # 800025b4 <sleep>
    acquire(&child->lock);
    80002ac2:	b7f9                	j	80002a90 <join_thread+0x6e>
    release(&wait_lock);
    80002ac4:	0004e517          	auipc	a0,0x4e
    80002ac8:	14450513          	addi	a0,a0,324 # 80050c08 <wait_lock>
    80002acc:	ffffe097          	auipc	ra,0xffffe
    80002ad0:	294080e7          	jalr	660(ra) # 80000d60 <release>
    return -1;
    80002ad4:	557d                	li	a0,-1
    80002ad6:	a8a5                	j	80002b4e <join_thread+0x12c>
      if (status_addr != 0 && copyout(p->pagetable, status_addr, (char *)&child->xstate, sizeof(child->xstate)) < 0) {
    80002ad8:	000b0e63          	beqz	s6,80002af4 <join_thread+0xd2>
    80002adc:	4691                	li	a3,4
    80002ade:	02c48613          	addi	a2,s1,44
    80002ae2:	85da                	mv	a1,s6
    80002ae4:	0509b503          	ld	a0,80(s3)
    80002ae8:	fffff097          	auipc	ra,0xfffff
    80002aec:	ee0080e7          	jalr	-288(ra) # 800019c8 <copyout>
    80002af0:	02054763          	bltz	a0,80002b1e <join_thread+0xfc>
      release(&child->lock);
    80002af4:	8526                	mv	a0,s1
    80002af6:	ffffe097          	auipc	ra,0xffffe
    80002afa:	26a080e7          	jalr	618(ra) # 80000d60 <release>
      release(&wait_lock);
    80002afe:	0004e517          	auipc	a0,0x4e
    80002b02:	10a50513          	addi	a0,a0,266 # 80050c08 <wait_lock>
    80002b06:	ffffe097          	auipc	ra,0xffffe
    80002b0a:	25a080e7          	jalr	602(ra) # 80000d60 <release>
      p->infant_threads[thread_idx] = 0;
    80002b0e:	02e90913          	addi	s2,s2,46
    80002b12:	090e                	slli	s2,s2,0x3
    80002b14:	99ca                	add	s3,s3,s2
    80002b16:	0009b023          	sd	zero,0(s3)
      return thread_id;
    80002b1a:	8552                	mv	a0,s4
    80002b1c:	a80d                	j	80002b4e <join_thread+0x12c>
        release(&child->lock);
    80002b1e:	8526                	mv	a0,s1
    80002b20:	ffffe097          	auipc	ra,0xffffe
    80002b24:	240080e7          	jalr	576(ra) # 80000d60 <release>
        release(&wait_lock);
    80002b28:	0004e517          	auipc	a0,0x4e
    80002b2c:	0e050513          	addi	a0,a0,224 # 80050c08 <wait_lock>
    80002b30:	ffffe097          	auipc	ra,0xffffe
    80002b34:	230080e7          	jalr	560(ra) # 80000d60 <release>
        return -1;
    80002b38:	557d                	li	a0,-1
    80002b3a:	a811                	j	80002b4e <join_thread+0x12c>
      release(&wait_lock);
    80002b3c:	0004e517          	auipc	a0,0x4e
    80002b40:	0cc50513          	addi	a0,a0,204 # 80050c08 <wait_lock>
    80002b44:	ffffe097          	auipc	ra,0xffffe
    80002b48:	21c080e7          	jalr	540(ra) # 80000d60 <release>
      return -1;
    80002b4c:	557d                	li	a0,-1
}
    80002b4e:	60a6                	ld	ra,72(sp)
    80002b50:	6406                	ld	s0,64(sp)
    80002b52:	74e2                	ld	s1,56(sp)
    80002b54:	7942                	ld	s2,48(sp)
    80002b56:	79a2                	ld	s3,40(sp)
    80002b58:	7a02                	ld	s4,32(sp)
    80002b5a:	6ae2                	ld	s5,24(sp)
    80002b5c:	6b42                	ld	s6,16(sp)
    80002b5e:	6ba2                	ld	s7,8(sp)
    80002b60:	6161                	addi	sp,sp,80
    80002b62:	8082                	ret

0000000080002b64 <wait>:
{
    80002b64:	715d                	addi	sp,sp,-80
    80002b66:	e486                	sd	ra,72(sp)
    80002b68:	e0a2                	sd	s0,64(sp)
    80002b6a:	fc26                	sd	s1,56(sp)
    80002b6c:	f84a                	sd	s2,48(sp)
    80002b6e:	f44e                	sd	s3,40(sp)
    80002b70:	f052                	sd	s4,32(sp)
    80002b72:	ec56                	sd	s5,24(sp)
    80002b74:	e85a                	sd	s6,16(sp)
    80002b76:	e45e                	sd	s7,8(sp)
    80002b78:	e062                	sd	s8,0(sp)
    80002b7a:	0880                	addi	s0,sp,80
    80002b7c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002b7e:	fffff097          	auipc	ra,0xfffff
    80002b82:	18a080e7          	jalr	394(ra) # 80001d08 <myproc>
    80002b86:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002b88:	0004e517          	auipc	a0,0x4e
    80002b8c:	08050513          	addi	a0,a0,128 # 80050c08 <wait_lock>
    80002b90:	ffffe097          	auipc	ra,0xffffe
    80002b94:	11c080e7          	jalr	284(ra) # 80000cac <acquire>
    havekids = 0;
    80002b98:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002b9a:	4a15                	li	s4,5
        havekids = 1;
    80002b9c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002b9e:	0005c997          	auipc	s3,0x5c
    80002ba2:	08298993          	addi	s3,s3,130 # 8005ec20 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002ba6:	0004ec17          	auipc	s8,0x4e
    80002baa:	062c0c13          	addi	s8,s8,98 # 80050c08 <wait_lock>
    havekids = 0;
    80002bae:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002bb0:	0004e497          	auipc	s1,0x4e
    80002bb4:	47048493          	addi	s1,s1,1136 # 80051020 <proc>
    80002bb8:	a0bd                	j	80002c26 <wait+0xc2>
          pid = pp->pid;
    80002bba:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002bbe:	000b0e63          	beqz	s6,80002bda <wait+0x76>
    80002bc2:	4691                	li	a3,4
    80002bc4:	02c48613          	addi	a2,s1,44
    80002bc8:	85da                	mv	a1,s6
    80002bca:	05093503          	ld	a0,80(s2)
    80002bce:	fffff097          	auipc	ra,0xfffff
    80002bd2:	dfa080e7          	jalr	-518(ra) # 800019c8 <copyout>
    80002bd6:	02054563          	bltz	a0,80002c00 <wait+0x9c>
          freeproc(pp);
    80002bda:	8526                	mv	a0,s1
    80002bdc:	fffff097          	auipc	ra,0xfffff
    80002be0:	2de080e7          	jalr	734(ra) # 80001eba <freeproc>
          release(&pp->lock);
    80002be4:	8526                	mv	a0,s1
    80002be6:	ffffe097          	auipc	ra,0xffffe
    80002bea:	17a080e7          	jalr	378(ra) # 80000d60 <release>
          release(&wait_lock);
    80002bee:	0004e517          	auipc	a0,0x4e
    80002bf2:	01a50513          	addi	a0,a0,26 # 80050c08 <wait_lock>
    80002bf6:	ffffe097          	auipc	ra,0xffffe
    80002bfa:	16a080e7          	jalr	362(ra) # 80000d60 <release>
          return pid;
    80002bfe:	a0b5                	j	80002c6a <wait+0x106>
            release(&pp->lock);
    80002c00:	8526                	mv	a0,s1
    80002c02:	ffffe097          	auipc	ra,0xffffe
    80002c06:	15e080e7          	jalr	350(ra) # 80000d60 <release>
            release(&wait_lock);
    80002c0a:	0004e517          	auipc	a0,0x4e
    80002c0e:	ffe50513          	addi	a0,a0,-2 # 80050c08 <wait_lock>
    80002c12:	ffffe097          	auipc	ra,0xffffe
    80002c16:	14e080e7          	jalr	334(ra) # 80000d60 <release>
            return -1;
    80002c1a:	59fd                	li	s3,-1
    80002c1c:	a0b9                	j	80002c6a <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002c1e:	37048493          	addi	s1,s1,880
    80002c22:	03348463          	beq	s1,s3,80002c4a <wait+0xe6>
      if(pp->parent == p){
    80002c26:	7c9c                	ld	a5,56(s1)
    80002c28:	ff279be3          	bne	a5,s2,80002c1e <wait+0xba>
        acquire(&pp->lock);
    80002c2c:	8526                	mv	a0,s1
    80002c2e:	ffffe097          	auipc	ra,0xffffe
    80002c32:	07e080e7          	jalr	126(ra) # 80000cac <acquire>
        if(pp->state == ZOMBIE){
    80002c36:	4c9c                	lw	a5,24(s1)
    80002c38:	f94781e3          	beq	a5,s4,80002bba <wait+0x56>
        release(&pp->lock);
    80002c3c:	8526                	mv	a0,s1
    80002c3e:	ffffe097          	auipc	ra,0xffffe
    80002c42:	122080e7          	jalr	290(ra) # 80000d60 <release>
        havekids = 1;
    80002c46:	8756                	mv	a4,s5
    80002c48:	bfd9                	j	80002c1e <wait+0xba>
    if(!havekids || killed(p)){
    80002c4a:	c719                	beqz	a4,80002c58 <wait+0xf4>
    80002c4c:	854a                	mv	a0,s2
    80002c4e:	00000097          	auipc	ra,0x0
    80002c52:	da2080e7          	jalr	-606(ra) # 800029f0 <killed>
    80002c56:	c51d                	beqz	a0,80002c84 <wait+0x120>
      release(&wait_lock);
    80002c58:	0004e517          	auipc	a0,0x4e
    80002c5c:	fb050513          	addi	a0,a0,-80 # 80050c08 <wait_lock>
    80002c60:	ffffe097          	auipc	ra,0xffffe
    80002c64:	100080e7          	jalr	256(ra) # 80000d60 <release>
      return -1;
    80002c68:	59fd                	li	s3,-1
}
    80002c6a:	854e                	mv	a0,s3
    80002c6c:	60a6                	ld	ra,72(sp)
    80002c6e:	6406                	ld	s0,64(sp)
    80002c70:	74e2                	ld	s1,56(sp)
    80002c72:	7942                	ld	s2,48(sp)
    80002c74:	79a2                	ld	s3,40(sp)
    80002c76:	7a02                	ld	s4,32(sp)
    80002c78:	6ae2                	ld	s5,24(sp)
    80002c7a:	6b42                	ld	s6,16(sp)
    80002c7c:	6ba2                	ld	s7,8(sp)
    80002c7e:	6c02                	ld	s8,0(sp)
    80002c80:	6161                	addi	sp,sp,80
    80002c82:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002c84:	85e2                	mv	a1,s8
    80002c86:	854a                	mv	a0,s2
    80002c88:	00000097          	auipc	ra,0x0
    80002c8c:	92c080e7          	jalr	-1748(ra) # 800025b4 <sleep>
    havekids = 0;
    80002c90:	bf39                	j	80002bae <wait+0x4a>

0000000080002c92 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002c92:	7179                	addi	sp,sp,-48
    80002c94:	f406                	sd	ra,40(sp)
    80002c96:	f022                	sd	s0,32(sp)
    80002c98:	ec26                	sd	s1,24(sp)
    80002c9a:	e84a                	sd	s2,16(sp)
    80002c9c:	e44e                	sd	s3,8(sp)
    80002c9e:	e052                	sd	s4,0(sp)
    80002ca0:	1800                	addi	s0,sp,48
    80002ca2:	84aa                	mv	s1,a0
    80002ca4:	892e                	mv	s2,a1
    80002ca6:	89b2                	mv	s3,a2
    80002ca8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002caa:	fffff097          	auipc	ra,0xfffff
    80002cae:	05e080e7          	jalr	94(ra) # 80001d08 <myproc>
  if(user_dst){
    80002cb2:	c08d                	beqz	s1,80002cd4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002cb4:	86d2                	mv	a3,s4
    80002cb6:	864e                	mv	a2,s3
    80002cb8:	85ca                	mv	a1,s2
    80002cba:	6928                	ld	a0,80(a0)
    80002cbc:	fffff097          	auipc	ra,0xfffff
    80002cc0:	d0c080e7          	jalr	-756(ra) # 800019c8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002cc4:	70a2                	ld	ra,40(sp)
    80002cc6:	7402                	ld	s0,32(sp)
    80002cc8:	64e2                	ld	s1,24(sp)
    80002cca:	6942                	ld	s2,16(sp)
    80002ccc:	69a2                	ld	s3,8(sp)
    80002cce:	6a02                	ld	s4,0(sp)
    80002cd0:	6145                	addi	sp,sp,48
    80002cd2:	8082                	ret
    memmove((char *)dst, src, len);
    80002cd4:	000a061b          	sext.w	a2,s4
    80002cd8:	85ce                	mv	a1,s3
    80002cda:	854a                	mv	a0,s2
    80002cdc:	ffffe097          	auipc	ra,0xffffe
    80002ce0:	128080e7          	jalr	296(ra) # 80000e04 <memmove>
    return 0;
    80002ce4:	8526                	mv	a0,s1
    80002ce6:	bff9                	j	80002cc4 <either_copyout+0x32>

0000000080002ce8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002ce8:	7179                	addi	sp,sp,-48
    80002cea:	f406                	sd	ra,40(sp)
    80002cec:	f022                	sd	s0,32(sp)
    80002cee:	ec26                	sd	s1,24(sp)
    80002cf0:	e84a                	sd	s2,16(sp)
    80002cf2:	e44e                	sd	s3,8(sp)
    80002cf4:	e052                	sd	s4,0(sp)
    80002cf6:	1800                	addi	s0,sp,48
    80002cf8:	892a                	mv	s2,a0
    80002cfa:	84ae                	mv	s1,a1
    80002cfc:	89b2                	mv	s3,a2
    80002cfe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002d00:	fffff097          	auipc	ra,0xfffff
    80002d04:	008080e7          	jalr	8(ra) # 80001d08 <myproc>
  if(user_src){
    80002d08:	c08d                	beqz	s1,80002d2a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002d0a:	86d2                	mv	a3,s4
    80002d0c:	864e                	mv	a2,s3
    80002d0e:	85ca                	mv	a1,s2
    80002d10:	6928                	ld	a0,80(a0)
    80002d12:	fffff097          	auipc	ra,0xfffff
    80002d16:	d42080e7          	jalr	-702(ra) # 80001a54 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002d1a:	70a2                	ld	ra,40(sp)
    80002d1c:	7402                	ld	s0,32(sp)
    80002d1e:	64e2                	ld	s1,24(sp)
    80002d20:	6942                	ld	s2,16(sp)
    80002d22:	69a2                	ld	s3,8(sp)
    80002d24:	6a02                	ld	s4,0(sp)
    80002d26:	6145                	addi	sp,sp,48
    80002d28:	8082                	ret
    memmove(dst, (char*)src, len);
    80002d2a:	000a061b          	sext.w	a2,s4
    80002d2e:	85ce                	mv	a1,s3
    80002d30:	854a                	mv	a0,s2
    80002d32:	ffffe097          	auipc	ra,0xffffe
    80002d36:	0d2080e7          	jalr	210(ra) # 80000e04 <memmove>
    return 0;
    80002d3a:	8526                	mv	a0,s1
    80002d3c:	bff9                	j	80002d1a <either_copyin+0x32>

0000000080002d3e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002d3e:	715d                	addi	sp,sp,-80
    80002d40:	e486                	sd	ra,72(sp)
    80002d42:	e0a2                	sd	s0,64(sp)
    80002d44:	fc26                	sd	s1,56(sp)
    80002d46:	f84a                	sd	s2,48(sp)
    80002d48:	f44e                	sd	s3,40(sp)
    80002d4a:	f052                	sd	s4,32(sp)
    80002d4c:	ec56                	sd	s5,24(sp)
    80002d4e:	e85a                	sd	s6,16(sp)
    80002d50:	e45e                	sd	s7,8(sp)
    80002d52:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002d54:	00005517          	auipc	a0,0x5
    80002d58:	37450513          	addi	a0,a0,884 # 800080c8 <digits+0x88>
    80002d5c:	ffffe097          	auipc	ra,0xffffe
    80002d60:	82e080e7          	jalr	-2002(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002d64:	0004e497          	auipc	s1,0x4e
    80002d68:	41448493          	addi	s1,s1,1044 # 80051178 <proc+0x158>
    80002d6c:	0005c917          	auipc	s2,0x5c
    80002d70:	00c90913          	addi	s2,s2,12 # 8005ed78 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002d74:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002d76:	00005997          	auipc	s3,0x5
    80002d7a:	56298993          	addi	s3,s3,1378 # 800082d8 <digits+0x298>
    printf("%d %s %s", p->pid, state, p->name);
    80002d7e:	00005a97          	auipc	s5,0x5
    80002d82:	562a8a93          	addi	s5,s5,1378 # 800082e0 <digits+0x2a0>
    printf("\n");
    80002d86:	00005a17          	auipc	s4,0x5
    80002d8a:	342a0a13          	addi	s4,s4,834 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002d8e:	00005b97          	auipc	s7,0x5
    80002d92:	5bab8b93          	addi	s7,s7,1466 # 80008348 <states.0>
    80002d96:	a00d                	j	80002db8 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002d98:	ed86a583          	lw	a1,-296(a3)
    80002d9c:	8556                	mv	a0,s5
    80002d9e:	ffffd097          	auipc	ra,0xffffd
    80002da2:	7ec080e7          	jalr	2028(ra) # 8000058a <printf>
    printf("\n");
    80002da6:	8552                	mv	a0,s4
    80002da8:	ffffd097          	auipc	ra,0xffffd
    80002dac:	7e2080e7          	jalr	2018(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002db0:	37048493          	addi	s1,s1,880
    80002db4:	03248263          	beq	s1,s2,80002dd8 <procdump+0x9a>
    if(p->state == UNUSED)
    80002db8:	86a6                	mv	a3,s1
    80002dba:	ec04a783          	lw	a5,-320(s1)
    80002dbe:	dbed                	beqz	a5,80002db0 <procdump+0x72>
      state = "???";
    80002dc0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002dc2:	fcfb6be3          	bltu	s6,a5,80002d98 <procdump+0x5a>
    80002dc6:	02079713          	slli	a4,a5,0x20
    80002dca:	01d75793          	srli	a5,a4,0x1d
    80002dce:	97de                	add	a5,a5,s7
    80002dd0:	6390                	ld	a2,0(a5)
    80002dd2:	f279                	bnez	a2,80002d98 <procdump+0x5a>
      state = "???";
    80002dd4:	864e                	mv	a2,s3
    80002dd6:	b7c9                	j	80002d98 <procdump+0x5a>
  }
}
    80002dd8:	60a6                	ld	ra,72(sp)
    80002dda:	6406                	ld	s0,64(sp)
    80002ddc:	74e2                	ld	s1,56(sp)
    80002dde:	7942                	ld	s2,48(sp)
    80002de0:	79a2                	ld	s3,40(sp)
    80002de2:	7a02                	ld	s4,32(sp)
    80002de4:	6ae2                	ld	s5,24(sp)
    80002de6:	6b42                	ld	s6,16(sp)
    80002de8:	6ba2                	ld	s7,8(sp)
    80002dea:	6161                	addi	sp,sp,80
    80002dec:	8082                	ret

0000000080002dee <spoon>:

uint64 spoon(void *arg)
{
    80002dee:	1141                	addi	sp,sp,-16
    80002df0:	e406                	sd	ra,8(sp)
    80002df2:	e022                	sd	s0,0(sp)
    80002df4:	0800                	addi	s0,sp,16
    80002df6:	85aa                	mv	a1,a0
  // Add your code here...
  printf("In spoon system call with argument %p\n", arg);
    80002df8:	00005517          	auipc	a0,0x5
    80002dfc:	4f850513          	addi	a0,a0,1272 # 800082f0 <digits+0x2b0>
    80002e00:	ffffd097          	auipc	ra,0xffffd
    80002e04:	78a080e7          	jalr	1930(ra) # 8000058a <printf>
  return 0;
}
    80002e08:	4501                	li	a0,0
    80002e0a:	60a2                	ld	ra,8(sp)
    80002e0c:	6402                	ld	s0,0(sp)
    80002e0e:	0141                	addi	sp,sp,16
    80002e10:	8082                	ret

0000000080002e12 <swtch>:
    80002e12:	00153023          	sd	ra,0(a0)
    80002e16:	00253423          	sd	sp,8(a0)
    80002e1a:	e900                	sd	s0,16(a0)
    80002e1c:	ed04                	sd	s1,24(a0)
    80002e1e:	03253023          	sd	s2,32(a0)
    80002e22:	03353423          	sd	s3,40(a0)
    80002e26:	03453823          	sd	s4,48(a0)
    80002e2a:	03553c23          	sd	s5,56(a0)
    80002e2e:	05653023          	sd	s6,64(a0)
    80002e32:	05753423          	sd	s7,72(a0)
    80002e36:	05853823          	sd	s8,80(a0)
    80002e3a:	05953c23          	sd	s9,88(a0)
    80002e3e:	07a53023          	sd	s10,96(a0)
    80002e42:	07b53423          	sd	s11,104(a0)
    80002e46:	0005b083          	ld	ra,0(a1)
    80002e4a:	0085b103          	ld	sp,8(a1)
    80002e4e:	6980                	ld	s0,16(a1)
    80002e50:	6d84                	ld	s1,24(a1)
    80002e52:	0205b903          	ld	s2,32(a1)
    80002e56:	0285b983          	ld	s3,40(a1)
    80002e5a:	0305ba03          	ld	s4,48(a1)
    80002e5e:	0385ba83          	ld	s5,56(a1)
    80002e62:	0405bb03          	ld	s6,64(a1)
    80002e66:	0485bb83          	ld	s7,72(a1)
    80002e6a:	0505bc03          	ld	s8,80(a1)
    80002e6e:	0585bc83          	ld	s9,88(a1)
    80002e72:	0605bd03          	ld	s10,96(a1)
    80002e76:	0685bd83          	ld	s11,104(a1)
    80002e7a:	8082                	ret

0000000080002e7c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002e7c:	1141                	addi	sp,sp,-16
    80002e7e:	e406                	sd	ra,8(sp)
    80002e80:	e022                	sd	s0,0(sp)
    80002e82:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002e84:	00005597          	auipc	a1,0x5
    80002e88:	4f458593          	addi	a1,a1,1268 # 80008378 <states.0+0x30>
    80002e8c:	0005c517          	auipc	a0,0x5c
    80002e90:	d9450513          	addi	a0,a0,-620 # 8005ec20 <tickslock>
    80002e94:	ffffe097          	auipc	ra,0xffffe
    80002e98:	d88080e7          	jalr	-632(ra) # 80000c1c <initlock>
}
    80002e9c:	60a2                	ld	ra,8(sp)
    80002e9e:	6402                	ld	s0,0(sp)
    80002ea0:	0141                	addi	sp,sp,16
    80002ea2:	8082                	ret

0000000080002ea4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002ea4:	1141                	addi	sp,sp,-16
    80002ea6:	e422                	sd	s0,8(sp)
    80002ea8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002eaa:	00003797          	auipc	a5,0x3
    80002eae:	5b678793          	addi	a5,a5,1462 # 80006460 <kernelvec>
    80002eb2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002eb6:	6422                	ld	s0,8(sp)
    80002eb8:	0141                	addi	sp,sp,16
    80002eba:	8082                	ret

0000000080002ebc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002ebc:	1141                	addi	sp,sp,-16
    80002ebe:	e406                	sd	ra,8(sp)
    80002ec0:	e022                	sd	s0,0(sp)
    80002ec2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002ec4:	fffff097          	auipc	ra,0xfffff
    80002ec8:	e44080e7          	jalr	-444(ra) # 80001d08 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ecc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002ed0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ed2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002ed6:	00004697          	auipc	a3,0x4
    80002eda:	12a68693          	addi	a3,a3,298 # 80007000 <_trampoline>
    80002ede:	00004717          	auipc	a4,0x4
    80002ee2:	12270713          	addi	a4,a4,290 # 80007000 <_trampoline>
    80002ee6:	8f15                	sub	a4,a4,a3
    80002ee8:	040007b7          	lui	a5,0x4000
    80002eec:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002eee:	07b2                	slli	a5,a5,0xc
    80002ef0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ef2:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002ef6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ef8:	18002673          	csrr	a2,satp
    80002efc:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002efe:	6d30                	ld	a2,88(a0)
    80002f00:	6138                	ld	a4,64(a0)
    80002f02:	6585                	lui	a1,0x1
    80002f04:	972e                	add	a4,a4,a1
    80002f06:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002f08:	6d38                	ld	a4,88(a0)
    80002f0a:	00000617          	auipc	a2,0x0
    80002f0e:	13060613          	addi	a2,a2,304 # 8000303a <usertrap>
    80002f12:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002f14:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002f16:	8612                	mv	a2,tp
    80002f18:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f1a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002f1e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002f22:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f26:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002f2a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f2c:	6f18                	ld	a4,24(a4)
    80002f2e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002f32:	6928                	ld	a0,80(a0)
    80002f34:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002f36:	00004717          	auipc	a4,0x4
    80002f3a:	16670713          	addi	a4,a4,358 # 8000709c <userret>
    80002f3e:	8f15                	sub	a4,a4,a3
    80002f40:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002f42:	577d                	li	a4,-1
    80002f44:	177e                	slli	a4,a4,0x3f
    80002f46:	8d59                	or	a0,a0,a4
    80002f48:	9782                	jalr	a5
}
    80002f4a:	60a2                	ld	ra,8(sp)
    80002f4c:	6402                	ld	s0,0(sp)
    80002f4e:	0141                	addi	sp,sp,16
    80002f50:	8082                	ret

0000000080002f52 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002f52:	1101                	addi	sp,sp,-32
    80002f54:	ec06                	sd	ra,24(sp)
    80002f56:	e822                	sd	s0,16(sp)
    80002f58:	e426                	sd	s1,8(sp)
    80002f5a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002f5c:	0005c497          	auipc	s1,0x5c
    80002f60:	cc448493          	addi	s1,s1,-828 # 8005ec20 <tickslock>
    80002f64:	8526                	mv	a0,s1
    80002f66:	ffffe097          	auipc	ra,0xffffe
    80002f6a:	d46080e7          	jalr	-698(ra) # 80000cac <acquire>
  ticks++;
    80002f6e:	00006517          	auipc	a0,0x6
    80002f72:	a1250513          	addi	a0,a0,-1518 # 80008980 <ticks>
    80002f76:	411c                	lw	a5,0(a0)
    80002f78:	2785                	addiw	a5,a5,1
    80002f7a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002f7c:	fffff097          	auipc	ra,0xfffff
    80002f80:	69c080e7          	jalr	1692(ra) # 80002618 <wakeup>
  release(&tickslock);
    80002f84:	8526                	mv	a0,s1
    80002f86:	ffffe097          	auipc	ra,0xffffe
    80002f8a:	dda080e7          	jalr	-550(ra) # 80000d60 <release>
}
    80002f8e:	60e2                	ld	ra,24(sp)
    80002f90:	6442                	ld	s0,16(sp)
    80002f92:	64a2                	ld	s1,8(sp)
    80002f94:	6105                	addi	sp,sp,32
    80002f96:	8082                	ret

0000000080002f98 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002f98:	1101                	addi	sp,sp,-32
    80002f9a:	ec06                	sd	ra,24(sp)
    80002f9c:	e822                	sd	s0,16(sp)
    80002f9e:	e426                	sd	s1,8(sp)
    80002fa0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002fa2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002fa6:	00074d63          	bltz	a4,80002fc0 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002faa:	57fd                	li	a5,-1
    80002fac:	17fe                	slli	a5,a5,0x3f
    80002fae:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002fb0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002fb2:	06f70363          	beq	a4,a5,80003018 <devintr+0x80>
  }
}
    80002fb6:	60e2                	ld	ra,24(sp)
    80002fb8:	6442                	ld	s0,16(sp)
    80002fba:	64a2                	ld	s1,8(sp)
    80002fbc:	6105                	addi	sp,sp,32
    80002fbe:	8082                	ret
     (scause & 0xff) == 9){
    80002fc0:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80002fc4:	46a5                	li	a3,9
    80002fc6:	fed792e3          	bne	a5,a3,80002faa <devintr+0x12>
    int irq = plic_claim();
    80002fca:	00003097          	auipc	ra,0x3
    80002fce:	59e080e7          	jalr	1438(ra) # 80006568 <plic_claim>
    80002fd2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002fd4:	47a9                	li	a5,10
    80002fd6:	02f50763          	beq	a0,a5,80003004 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002fda:	4785                	li	a5,1
    80002fdc:	02f50963          	beq	a0,a5,8000300e <devintr+0x76>
    return 1;
    80002fe0:	4505                	li	a0,1
    } else if(irq){
    80002fe2:	d8f1                	beqz	s1,80002fb6 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002fe4:	85a6                	mv	a1,s1
    80002fe6:	00005517          	auipc	a0,0x5
    80002fea:	39a50513          	addi	a0,a0,922 # 80008380 <states.0+0x38>
    80002fee:	ffffd097          	auipc	ra,0xffffd
    80002ff2:	59c080e7          	jalr	1436(ra) # 8000058a <printf>
      plic_complete(irq);
    80002ff6:	8526                	mv	a0,s1
    80002ff8:	00003097          	auipc	ra,0x3
    80002ffc:	594080e7          	jalr	1428(ra) # 8000658c <plic_complete>
    return 1;
    80003000:	4505                	li	a0,1
    80003002:	bf55                	j	80002fb6 <devintr+0x1e>
      uartintr();
    80003004:	ffffe097          	auipc	ra,0xffffe
    80003008:	994080e7          	jalr	-1644(ra) # 80000998 <uartintr>
    8000300c:	b7ed                	j	80002ff6 <devintr+0x5e>
      virtio_disk_intr();
    8000300e:	00004097          	auipc	ra,0x4
    80003012:	a46080e7          	jalr	-1466(ra) # 80006a54 <virtio_disk_intr>
    80003016:	b7c5                	j	80002ff6 <devintr+0x5e>
    if(cpuid() == 0){
    80003018:	fffff097          	auipc	ra,0xfffff
    8000301c:	cc4080e7          	jalr	-828(ra) # 80001cdc <cpuid>
    80003020:	c901                	beqz	a0,80003030 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003022:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003026:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003028:	14479073          	csrw	sip,a5
    return 2;
    8000302c:	4509                	li	a0,2
    8000302e:	b761                	j	80002fb6 <devintr+0x1e>
      clockintr();
    80003030:	00000097          	auipc	ra,0x0
    80003034:	f22080e7          	jalr	-222(ra) # 80002f52 <clockintr>
    80003038:	b7ed                	j	80003022 <devintr+0x8a>

000000008000303a <usertrap>:
{
    8000303a:	1101                	addi	sp,sp,-32
    8000303c:	ec06                	sd	ra,24(sp)
    8000303e:	e822                	sd	s0,16(sp)
    80003040:	e426                	sd	s1,8(sp)
    80003042:	e04a                	sd	s2,0(sp)
    80003044:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003046:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000304a:	1007f793          	andi	a5,a5,256
    8000304e:	e3b1                	bnez	a5,80003092 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003050:	00003797          	auipc	a5,0x3
    80003054:	41078793          	addi	a5,a5,1040 # 80006460 <kernelvec>
    80003058:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000305c:	fffff097          	auipc	ra,0xfffff
    80003060:	cac080e7          	jalr	-852(ra) # 80001d08 <myproc>
    80003064:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80003066:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003068:	14102773          	csrr	a4,sepc
    8000306c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000306e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80003072:	47a1                	li	a5,8
    80003074:	02f70763          	beq	a4,a5,800030a2 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80003078:	00000097          	auipc	ra,0x0
    8000307c:	f20080e7          	jalr	-224(ra) # 80002f98 <devintr>
    80003080:	892a                	mv	s2,a0
    80003082:	c151                	beqz	a0,80003106 <usertrap+0xcc>
  if(killed(p))
    80003084:	8526                	mv	a0,s1
    80003086:	00000097          	auipc	ra,0x0
    8000308a:	96a080e7          	jalr	-1686(ra) # 800029f0 <killed>
    8000308e:	c929                	beqz	a0,800030e0 <usertrap+0xa6>
    80003090:	a099                	j	800030d6 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80003092:	00005517          	auipc	a0,0x5
    80003096:	30e50513          	addi	a0,a0,782 # 800083a0 <states.0+0x58>
    8000309a:	ffffd097          	auipc	ra,0xffffd
    8000309e:	4a6080e7          	jalr	1190(ra) # 80000540 <panic>
    if(killed(p))
    800030a2:	00000097          	auipc	ra,0x0
    800030a6:	94e080e7          	jalr	-1714(ra) # 800029f0 <killed>
    800030aa:	e921                	bnez	a0,800030fa <usertrap+0xc0>
    p->trapframe->epc += 4;
    800030ac:	6cb8                	ld	a4,88(s1)
    800030ae:	6f1c                	ld	a5,24(a4)
    800030b0:	0791                	addi	a5,a5,4
    800030b2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800030b8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800030bc:	10079073          	csrw	sstatus,a5
    syscall();
    800030c0:	00000097          	auipc	ra,0x0
    800030c4:	2d4080e7          	jalr	724(ra) # 80003394 <syscall>
  if(killed(p))
    800030c8:	8526                	mv	a0,s1
    800030ca:	00000097          	auipc	ra,0x0
    800030ce:	926080e7          	jalr	-1754(ra) # 800029f0 <killed>
    800030d2:	c911                	beqz	a0,800030e6 <usertrap+0xac>
    800030d4:	4901                	li	s2,0
    exit(-1);
    800030d6:	557d                	li	a0,-1
    800030d8:	fffff097          	auipc	ra,0xfffff
    800030dc:	6e6080e7          	jalr	1766(ra) # 800027be <exit>
  if(which_dev == 2)
    800030e0:	4789                	li	a5,2
    800030e2:	04f90f63          	beq	s2,a5,80003140 <usertrap+0x106>
  usertrapret();
    800030e6:	00000097          	auipc	ra,0x0
    800030ea:	dd6080e7          	jalr	-554(ra) # 80002ebc <usertrapret>
}
    800030ee:	60e2                	ld	ra,24(sp)
    800030f0:	6442                	ld	s0,16(sp)
    800030f2:	64a2                	ld	s1,8(sp)
    800030f4:	6902                	ld	s2,0(sp)
    800030f6:	6105                	addi	sp,sp,32
    800030f8:	8082                	ret
      exit(-1);
    800030fa:	557d                	li	a0,-1
    800030fc:	fffff097          	auipc	ra,0xfffff
    80003100:	6c2080e7          	jalr	1730(ra) # 800027be <exit>
    80003104:	b765                	j	800030ac <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003106:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000310a:	5890                	lw	a2,48(s1)
    8000310c:	00005517          	auipc	a0,0x5
    80003110:	2b450513          	addi	a0,a0,692 # 800083c0 <states.0+0x78>
    80003114:	ffffd097          	auipc	ra,0xffffd
    80003118:	476080e7          	jalr	1142(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000311c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003120:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003124:	00005517          	auipc	a0,0x5
    80003128:	2cc50513          	addi	a0,a0,716 # 800083f0 <states.0+0xa8>
    8000312c:	ffffd097          	auipc	ra,0xffffd
    80003130:	45e080e7          	jalr	1118(ra) # 8000058a <printf>
    setkilled(p);
    80003134:	8526                	mv	a0,s1
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	88e080e7          	jalr	-1906(ra) # 800029c4 <setkilled>
    8000313e:	b769                	j	800030c8 <usertrap+0x8e>
    yield();
    80003140:	fffff097          	auipc	ra,0xfffff
    80003144:	438080e7          	jalr	1080(ra) # 80002578 <yield>
    80003148:	bf79                	j	800030e6 <usertrap+0xac>

000000008000314a <kerneltrap>:
{
    8000314a:	7179                	addi	sp,sp,-48
    8000314c:	f406                	sd	ra,40(sp)
    8000314e:	f022                	sd	s0,32(sp)
    80003150:	ec26                	sd	s1,24(sp)
    80003152:	e84a                	sd	s2,16(sp)
    80003154:	e44e                	sd	s3,8(sp)
    80003156:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003158:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000315c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003160:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80003164:	1004f793          	andi	a5,s1,256
    80003168:	cb85                	beqz	a5,80003198 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000316a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000316e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80003170:	ef85                	bnez	a5,800031a8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80003172:	00000097          	auipc	ra,0x0
    80003176:	e26080e7          	jalr	-474(ra) # 80002f98 <devintr>
    8000317a:	cd1d                	beqz	a0,800031b8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000317c:	4789                	li	a5,2
    8000317e:	06f50a63          	beq	a0,a5,800031f2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003182:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003186:	10049073          	csrw	sstatus,s1
}
    8000318a:	70a2                	ld	ra,40(sp)
    8000318c:	7402                	ld	s0,32(sp)
    8000318e:	64e2                	ld	s1,24(sp)
    80003190:	6942                	ld	s2,16(sp)
    80003192:	69a2                	ld	s3,8(sp)
    80003194:	6145                	addi	sp,sp,48
    80003196:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003198:	00005517          	auipc	a0,0x5
    8000319c:	27850513          	addi	a0,a0,632 # 80008410 <states.0+0xc8>
    800031a0:	ffffd097          	auipc	ra,0xffffd
    800031a4:	3a0080e7          	jalr	928(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    800031a8:	00005517          	auipc	a0,0x5
    800031ac:	29050513          	addi	a0,a0,656 # 80008438 <states.0+0xf0>
    800031b0:	ffffd097          	auipc	ra,0xffffd
    800031b4:	390080e7          	jalr	912(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    800031b8:	85ce                	mv	a1,s3
    800031ba:	00005517          	auipc	a0,0x5
    800031be:	29e50513          	addi	a0,a0,670 # 80008458 <states.0+0x110>
    800031c2:	ffffd097          	auipc	ra,0xffffd
    800031c6:	3c8080e7          	jalr	968(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800031ca:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800031ce:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800031d2:	00005517          	auipc	a0,0x5
    800031d6:	29650513          	addi	a0,a0,662 # 80008468 <states.0+0x120>
    800031da:	ffffd097          	auipc	ra,0xffffd
    800031de:	3b0080e7          	jalr	944(ra) # 8000058a <printf>
    panic("kerneltrap");
    800031e2:	00005517          	auipc	a0,0x5
    800031e6:	29e50513          	addi	a0,a0,670 # 80008480 <states.0+0x138>
    800031ea:	ffffd097          	auipc	ra,0xffffd
    800031ee:	356080e7          	jalr	854(ra) # 80000540 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800031f2:	fffff097          	auipc	ra,0xfffff
    800031f6:	b16080e7          	jalr	-1258(ra) # 80001d08 <myproc>
    800031fa:	d541                	beqz	a0,80003182 <kerneltrap+0x38>
    800031fc:	fffff097          	auipc	ra,0xfffff
    80003200:	b0c080e7          	jalr	-1268(ra) # 80001d08 <myproc>
    80003204:	4d18                	lw	a4,24(a0)
    80003206:	4791                	li	a5,4
    80003208:	f6f71de3          	bne	a4,a5,80003182 <kerneltrap+0x38>
    yield();
    8000320c:	fffff097          	auipc	ra,0xfffff
    80003210:	36c080e7          	jalr	876(ra) # 80002578 <yield>
    80003214:	b7bd                	j	80003182 <kerneltrap+0x38>

0000000080003216 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003216:	1101                	addi	sp,sp,-32
    80003218:	ec06                	sd	ra,24(sp)
    8000321a:	e822                	sd	s0,16(sp)
    8000321c:	e426                	sd	s1,8(sp)
    8000321e:	1000                	addi	s0,sp,32
    80003220:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003222:	fffff097          	auipc	ra,0xfffff
    80003226:	ae6080e7          	jalr	-1306(ra) # 80001d08 <myproc>
  switch (n) {
    8000322a:	4795                	li	a5,5
    8000322c:	0497e163          	bltu	a5,s1,8000326e <argraw+0x58>
    80003230:	048a                	slli	s1,s1,0x2
    80003232:	00005717          	auipc	a4,0x5
    80003236:	28670713          	addi	a4,a4,646 # 800084b8 <states.0+0x170>
    8000323a:	94ba                	add	s1,s1,a4
    8000323c:	409c                	lw	a5,0(s1)
    8000323e:	97ba                	add	a5,a5,a4
    80003240:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80003242:	6d3c                	ld	a5,88(a0)
    80003244:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003246:	60e2                	ld	ra,24(sp)
    80003248:	6442                	ld	s0,16(sp)
    8000324a:	64a2                	ld	s1,8(sp)
    8000324c:	6105                	addi	sp,sp,32
    8000324e:	8082                	ret
    return p->trapframe->a1;
    80003250:	6d3c                	ld	a5,88(a0)
    80003252:	7fa8                	ld	a0,120(a5)
    80003254:	bfcd                	j	80003246 <argraw+0x30>
    return p->trapframe->a2;
    80003256:	6d3c                	ld	a5,88(a0)
    80003258:	63c8                	ld	a0,128(a5)
    8000325a:	b7f5                	j	80003246 <argraw+0x30>
    return p->trapframe->a3;
    8000325c:	6d3c                	ld	a5,88(a0)
    8000325e:	67c8                	ld	a0,136(a5)
    80003260:	b7dd                	j	80003246 <argraw+0x30>
    return p->trapframe->a4;
    80003262:	6d3c                	ld	a5,88(a0)
    80003264:	6bc8                	ld	a0,144(a5)
    80003266:	b7c5                	j	80003246 <argraw+0x30>
    return p->trapframe->a5;
    80003268:	6d3c                	ld	a5,88(a0)
    8000326a:	6fc8                	ld	a0,152(a5)
    8000326c:	bfe9                	j	80003246 <argraw+0x30>
  panic("argraw");
    8000326e:	00005517          	auipc	a0,0x5
    80003272:	22250513          	addi	a0,a0,546 # 80008490 <states.0+0x148>
    80003276:	ffffd097          	auipc	ra,0xffffd
    8000327a:	2ca080e7          	jalr	714(ra) # 80000540 <panic>

000000008000327e <fetchaddr>:
{
    8000327e:	1101                	addi	sp,sp,-32
    80003280:	ec06                	sd	ra,24(sp)
    80003282:	e822                	sd	s0,16(sp)
    80003284:	e426                	sd	s1,8(sp)
    80003286:	e04a                	sd	s2,0(sp)
    80003288:	1000                	addi	s0,sp,32
    8000328a:	84aa                	mv	s1,a0
    8000328c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000328e:	fffff097          	auipc	ra,0xfffff
    80003292:	a7a080e7          	jalr	-1414(ra) # 80001d08 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003296:	653c                	ld	a5,72(a0)
    80003298:	02f4f863          	bgeu	s1,a5,800032c8 <fetchaddr+0x4a>
    8000329c:	00848713          	addi	a4,s1,8
    800032a0:	02e7e663          	bltu	a5,a4,800032cc <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800032a4:	46a1                	li	a3,8
    800032a6:	8626                	mv	a2,s1
    800032a8:	85ca                	mv	a1,s2
    800032aa:	6928                	ld	a0,80(a0)
    800032ac:	ffffe097          	auipc	ra,0xffffe
    800032b0:	7a8080e7          	jalr	1960(ra) # 80001a54 <copyin>
    800032b4:	00a03533          	snez	a0,a0
    800032b8:	40a00533          	neg	a0,a0
}
    800032bc:	60e2                	ld	ra,24(sp)
    800032be:	6442                	ld	s0,16(sp)
    800032c0:	64a2                	ld	s1,8(sp)
    800032c2:	6902                	ld	s2,0(sp)
    800032c4:	6105                	addi	sp,sp,32
    800032c6:	8082                	ret
    return -1;
    800032c8:	557d                	li	a0,-1
    800032ca:	bfcd                	j	800032bc <fetchaddr+0x3e>
    800032cc:	557d                	li	a0,-1
    800032ce:	b7fd                	j	800032bc <fetchaddr+0x3e>

00000000800032d0 <fetchstr>:
{
    800032d0:	7179                	addi	sp,sp,-48
    800032d2:	f406                	sd	ra,40(sp)
    800032d4:	f022                	sd	s0,32(sp)
    800032d6:	ec26                	sd	s1,24(sp)
    800032d8:	e84a                	sd	s2,16(sp)
    800032da:	e44e                	sd	s3,8(sp)
    800032dc:	1800                	addi	s0,sp,48
    800032de:	892a                	mv	s2,a0
    800032e0:	84ae                	mv	s1,a1
    800032e2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800032e4:	fffff097          	auipc	ra,0xfffff
    800032e8:	a24080e7          	jalr	-1500(ra) # 80001d08 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800032ec:	86ce                	mv	a3,s3
    800032ee:	864a                	mv	a2,s2
    800032f0:	85a6                	mv	a1,s1
    800032f2:	6928                	ld	a0,80(a0)
    800032f4:	ffffe097          	auipc	ra,0xffffe
    800032f8:	7ee080e7          	jalr	2030(ra) # 80001ae2 <copyinstr>
    800032fc:	00054e63          	bltz	a0,80003318 <fetchstr+0x48>
  return strlen(buf);
    80003300:	8526                	mv	a0,s1
    80003302:	ffffe097          	auipc	ra,0xffffe
    80003306:	c22080e7          	jalr	-990(ra) # 80000f24 <strlen>
}
    8000330a:	70a2                	ld	ra,40(sp)
    8000330c:	7402                	ld	s0,32(sp)
    8000330e:	64e2                	ld	s1,24(sp)
    80003310:	6942                	ld	s2,16(sp)
    80003312:	69a2                	ld	s3,8(sp)
    80003314:	6145                	addi	sp,sp,48
    80003316:	8082                	ret
    return -1;
    80003318:	557d                	li	a0,-1
    8000331a:	bfc5                	j	8000330a <fetchstr+0x3a>

000000008000331c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000331c:	1101                	addi	sp,sp,-32
    8000331e:	ec06                	sd	ra,24(sp)
    80003320:	e822                	sd	s0,16(sp)
    80003322:	e426                	sd	s1,8(sp)
    80003324:	1000                	addi	s0,sp,32
    80003326:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	eee080e7          	jalr	-274(ra) # 80003216 <argraw>
    80003330:	c088                	sw	a0,0(s1)
}
    80003332:	60e2                	ld	ra,24(sp)
    80003334:	6442                	ld	s0,16(sp)
    80003336:	64a2                	ld	s1,8(sp)
    80003338:	6105                	addi	sp,sp,32
    8000333a:	8082                	ret

000000008000333c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000333c:	1101                	addi	sp,sp,-32
    8000333e:	ec06                	sd	ra,24(sp)
    80003340:	e822                	sd	s0,16(sp)
    80003342:	e426                	sd	s1,8(sp)
    80003344:	1000                	addi	s0,sp,32
    80003346:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003348:	00000097          	auipc	ra,0x0
    8000334c:	ece080e7          	jalr	-306(ra) # 80003216 <argraw>
    80003350:	e088                	sd	a0,0(s1)
}
    80003352:	60e2                	ld	ra,24(sp)
    80003354:	6442                	ld	s0,16(sp)
    80003356:	64a2                	ld	s1,8(sp)
    80003358:	6105                	addi	sp,sp,32
    8000335a:	8082                	ret

000000008000335c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000335c:	7179                	addi	sp,sp,-48
    8000335e:	f406                	sd	ra,40(sp)
    80003360:	f022                	sd	s0,32(sp)
    80003362:	ec26                	sd	s1,24(sp)
    80003364:	e84a                	sd	s2,16(sp)
    80003366:	1800                	addi	s0,sp,48
    80003368:	84ae                	mv	s1,a1
    8000336a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000336c:	fd840593          	addi	a1,s0,-40
    80003370:	00000097          	auipc	ra,0x0
    80003374:	fcc080e7          	jalr	-52(ra) # 8000333c <argaddr>
  return fetchstr(addr, buf, max);
    80003378:	864a                	mv	a2,s2
    8000337a:	85a6                	mv	a1,s1
    8000337c:	fd843503          	ld	a0,-40(s0)
    80003380:	00000097          	auipc	ra,0x0
    80003384:	f50080e7          	jalr	-176(ra) # 800032d0 <fetchstr>
}
    80003388:	70a2                	ld	ra,40(sp)
    8000338a:	7402                	ld	s0,32(sp)
    8000338c:	64e2                	ld	s1,24(sp)
    8000338e:	6942                	ld	s2,16(sp)
    80003390:	6145                	addi	sp,sp,48
    80003392:	8082                	ret

0000000080003394 <syscall>:
[SYS_thread_exit]   sys_thread_exit,
};

void
syscall(void)
{
    80003394:	1101                	addi	sp,sp,-32
    80003396:	ec06                	sd	ra,24(sp)
    80003398:	e822                	sd	s0,16(sp)
    8000339a:	e426                	sd	s1,8(sp)
    8000339c:	e04a                	sd	s2,0(sp)
    8000339e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800033a0:	fffff097          	auipc	ra,0xfffff
    800033a4:	968080e7          	jalr	-1688(ra) # 80001d08 <myproc>
    800033a8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800033aa:	05853903          	ld	s2,88(a0)
    800033ae:	0a893783          	ld	a5,168(s2)
    800033b2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800033b6:	37fd                	addiw	a5,a5,-1
    800033b8:	4761                	li	a4,24
    800033ba:	00f76f63          	bltu	a4,a5,800033d8 <syscall+0x44>
    800033be:	00369713          	slli	a4,a3,0x3
    800033c2:	00005797          	auipc	a5,0x5
    800033c6:	10e78793          	addi	a5,a5,270 # 800084d0 <syscalls>
    800033ca:	97ba                	add	a5,a5,a4
    800033cc:	639c                	ld	a5,0(a5)
    800033ce:	c789                	beqz	a5,800033d8 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800033d0:	9782                	jalr	a5
    800033d2:	06a93823          	sd	a0,112(s2)
    800033d6:	a839                	j	800033f4 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800033d8:	15848613          	addi	a2,s1,344
    800033dc:	588c                	lw	a1,48(s1)
    800033de:	00005517          	auipc	a0,0x5
    800033e2:	0ba50513          	addi	a0,a0,186 # 80008498 <states.0+0x150>
    800033e6:	ffffd097          	auipc	ra,0xffffd
    800033ea:	1a4080e7          	jalr	420(ra) # 8000058a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800033ee:	6cbc                	ld	a5,88(s1)
    800033f0:	577d                	li	a4,-1
    800033f2:	fbb8                	sd	a4,112(a5)
  }
}
    800033f4:	60e2                	ld	ra,24(sp)
    800033f6:	6442                	ld	s0,16(sp)
    800033f8:	64a2                	ld	s1,8(sp)
    800033fa:	6902                	ld	s2,0(sp)
    800033fc:	6105                	addi	sp,sp,32
    800033fe:	8082                	ret

0000000080003400 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003400:	1101                	addi	sp,sp,-32
    80003402:	ec06                	sd	ra,24(sp)
    80003404:	e822                	sd	s0,16(sp)
    80003406:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003408:	fec40593          	addi	a1,s0,-20
    8000340c:	4501                	li	a0,0
    8000340e:	00000097          	auipc	ra,0x0
    80003412:	f0e080e7          	jalr	-242(ra) # 8000331c <argint>
  exit(n);
    80003416:	fec42503          	lw	a0,-20(s0)
    8000341a:	fffff097          	auipc	ra,0xfffff
    8000341e:	3a4080e7          	jalr	932(ra) # 800027be <exit>
  return 0;  // not reached
}
    80003422:	4501                	li	a0,0
    80003424:	60e2                	ld	ra,24(sp)
    80003426:	6442                	ld	s0,16(sp)
    80003428:	6105                	addi	sp,sp,32
    8000342a:	8082                	ret

000000008000342c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000342c:	1141                	addi	sp,sp,-16
    8000342e:	e406                	sd	ra,8(sp)
    80003430:	e022                	sd	s0,0(sp)
    80003432:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003434:	fffff097          	auipc	ra,0xfffff
    80003438:	8d4080e7          	jalr	-1836(ra) # 80001d08 <myproc>
}
    8000343c:	5908                	lw	a0,48(a0)
    8000343e:	60a2                	ld	ra,8(sp)
    80003440:	6402                	ld	s0,0(sp)
    80003442:	0141                	addi	sp,sp,16
    80003444:	8082                	ret

0000000080003446 <sys_fork>:

uint64
sys_fork(void)
{
    80003446:	1141                	addi	sp,sp,-16
    80003448:	e406                	sd	ra,8(sp)
    8000344a:	e022                	sd	s0,0(sp)
    8000344c:	0800                	addi	s0,sp,16
  return fork();
    8000344e:	fffff097          	auipc	ra,0xfffff
    80003452:	cbc080e7          	jalr	-836(ra) # 8000210a <fork>
}
    80003456:	60a2                	ld	ra,8(sp)
    80003458:	6402                	ld	s0,0(sp)
    8000345a:	0141                	addi	sp,sp,16
    8000345c:	8082                	ret

000000008000345e <sys_wait>:

uint64
sys_wait(void)
{
    8000345e:	1101                	addi	sp,sp,-32
    80003460:	ec06                	sd	ra,24(sp)
    80003462:	e822                	sd	s0,16(sp)
    80003464:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003466:	fe840593          	addi	a1,s0,-24
    8000346a:	4501                	li	a0,0
    8000346c:	00000097          	auipc	ra,0x0
    80003470:	ed0080e7          	jalr	-304(ra) # 8000333c <argaddr>
  return wait(p);
    80003474:	fe843503          	ld	a0,-24(s0)
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	6ec080e7          	jalr	1772(ra) # 80002b64 <wait>
}
    80003480:	60e2                	ld	ra,24(sp)
    80003482:	6442                	ld	s0,16(sp)
    80003484:	6105                	addi	sp,sp,32
    80003486:	8082                	ret

0000000080003488 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003488:	7179                	addi	sp,sp,-48
    8000348a:	f406                	sd	ra,40(sp)
    8000348c:	f022                	sd	s0,32(sp)
    8000348e:	ec26                	sd	s1,24(sp)
    80003490:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80003492:	fdc40593          	addi	a1,s0,-36
    80003496:	4501                	li	a0,0
    80003498:	00000097          	auipc	ra,0x0
    8000349c:	e84080e7          	jalr	-380(ra) # 8000331c <argint>
  addr = myproc()->sz;
    800034a0:	fffff097          	auipc	ra,0xfffff
    800034a4:	868080e7          	jalr	-1944(ra) # 80001d08 <myproc>
    800034a8:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800034aa:	fdc42503          	lw	a0,-36(s0)
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	bc6080e7          	jalr	-1082(ra) # 80002074 <growproc>
    800034b6:	00054863          	bltz	a0,800034c6 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800034ba:	8526                	mv	a0,s1
    800034bc:	70a2                	ld	ra,40(sp)
    800034be:	7402                	ld	s0,32(sp)
    800034c0:	64e2                	ld	s1,24(sp)
    800034c2:	6145                	addi	sp,sp,48
    800034c4:	8082                	ret
    return -1;
    800034c6:	54fd                	li	s1,-1
    800034c8:	bfcd                	j	800034ba <sys_sbrk+0x32>

00000000800034ca <sys_sleep>:

uint64
sys_sleep(void)
{
    800034ca:	7139                	addi	sp,sp,-64
    800034cc:	fc06                	sd	ra,56(sp)
    800034ce:	f822                	sd	s0,48(sp)
    800034d0:	f426                	sd	s1,40(sp)
    800034d2:	f04a                	sd	s2,32(sp)
    800034d4:	ec4e                	sd	s3,24(sp)
    800034d6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800034d8:	fcc40593          	addi	a1,s0,-52
    800034dc:	4501                	li	a0,0
    800034de:	00000097          	auipc	ra,0x0
    800034e2:	e3e080e7          	jalr	-450(ra) # 8000331c <argint>
  acquire(&tickslock);
    800034e6:	0005b517          	auipc	a0,0x5b
    800034ea:	73a50513          	addi	a0,a0,1850 # 8005ec20 <tickslock>
    800034ee:	ffffd097          	auipc	ra,0xffffd
    800034f2:	7be080e7          	jalr	1982(ra) # 80000cac <acquire>
  ticks0 = ticks;
    800034f6:	00005917          	auipc	s2,0x5
    800034fa:	48a92903          	lw	s2,1162(s2) # 80008980 <ticks>
  while(ticks - ticks0 < n){
    800034fe:	fcc42783          	lw	a5,-52(s0)
    80003502:	cf9d                	beqz	a5,80003540 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003504:	0005b997          	auipc	s3,0x5b
    80003508:	71c98993          	addi	s3,s3,1820 # 8005ec20 <tickslock>
    8000350c:	00005497          	auipc	s1,0x5
    80003510:	47448493          	addi	s1,s1,1140 # 80008980 <ticks>
    if(killed(myproc())){
    80003514:	ffffe097          	auipc	ra,0xffffe
    80003518:	7f4080e7          	jalr	2036(ra) # 80001d08 <myproc>
    8000351c:	fffff097          	auipc	ra,0xfffff
    80003520:	4d4080e7          	jalr	1236(ra) # 800029f0 <killed>
    80003524:	ed15                	bnez	a0,80003560 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003526:	85ce                	mv	a1,s3
    80003528:	8526                	mv	a0,s1
    8000352a:	fffff097          	auipc	ra,0xfffff
    8000352e:	08a080e7          	jalr	138(ra) # 800025b4 <sleep>
  while(ticks - ticks0 < n){
    80003532:	409c                	lw	a5,0(s1)
    80003534:	412787bb          	subw	a5,a5,s2
    80003538:	fcc42703          	lw	a4,-52(s0)
    8000353c:	fce7ece3          	bltu	a5,a4,80003514 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80003540:	0005b517          	auipc	a0,0x5b
    80003544:	6e050513          	addi	a0,a0,1760 # 8005ec20 <tickslock>
    80003548:	ffffe097          	auipc	ra,0xffffe
    8000354c:	818080e7          	jalr	-2024(ra) # 80000d60 <release>
  return 0;
    80003550:	4501                	li	a0,0
}
    80003552:	70e2                	ld	ra,56(sp)
    80003554:	7442                	ld	s0,48(sp)
    80003556:	74a2                	ld	s1,40(sp)
    80003558:	7902                	ld	s2,32(sp)
    8000355a:	69e2                	ld	s3,24(sp)
    8000355c:	6121                	addi	sp,sp,64
    8000355e:	8082                	ret
      release(&tickslock);
    80003560:	0005b517          	auipc	a0,0x5b
    80003564:	6c050513          	addi	a0,a0,1728 # 8005ec20 <tickslock>
    80003568:	ffffd097          	auipc	ra,0xffffd
    8000356c:	7f8080e7          	jalr	2040(ra) # 80000d60 <release>
      return -1;
    80003570:	557d                	li	a0,-1
    80003572:	b7c5                	j	80003552 <sys_sleep+0x88>

0000000080003574 <sys_kill>:

uint64
sys_kill(void)
{
    80003574:	1101                	addi	sp,sp,-32
    80003576:	ec06                	sd	ra,24(sp)
    80003578:	e822                	sd	s0,16(sp)
    8000357a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000357c:	fec40593          	addi	a1,s0,-20
    80003580:	4501                	li	a0,0
    80003582:	00000097          	auipc	ra,0x0
    80003586:	d9a080e7          	jalr	-614(ra) # 8000331c <argint>
  return kill(pid);
    8000358a:	fec42503          	lw	a0,-20(s0)
    8000358e:	fffff097          	auipc	ra,0xfffff
    80003592:	3c4080e7          	jalr	964(ra) # 80002952 <kill>
}
    80003596:	60e2                	ld	ra,24(sp)
    80003598:	6442                	ld	s0,16(sp)
    8000359a:	6105                	addi	sp,sp,32
    8000359c:	8082                	ret

000000008000359e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000359e:	1101                	addi	sp,sp,-32
    800035a0:	ec06                	sd	ra,24(sp)
    800035a2:	e822                	sd	s0,16(sp)
    800035a4:	e426                	sd	s1,8(sp)
    800035a6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800035a8:	0005b517          	auipc	a0,0x5b
    800035ac:	67850513          	addi	a0,a0,1656 # 8005ec20 <tickslock>
    800035b0:	ffffd097          	auipc	ra,0xffffd
    800035b4:	6fc080e7          	jalr	1788(ra) # 80000cac <acquire>
  xticks = ticks;
    800035b8:	00005497          	auipc	s1,0x5
    800035bc:	3c84a483          	lw	s1,968(s1) # 80008980 <ticks>
  release(&tickslock);
    800035c0:	0005b517          	auipc	a0,0x5b
    800035c4:	66050513          	addi	a0,a0,1632 # 8005ec20 <tickslock>
    800035c8:	ffffd097          	auipc	ra,0xffffd
    800035cc:	798080e7          	jalr	1944(ra) # 80000d60 <release>
  return xticks;
}
    800035d0:	02049513          	slli	a0,s1,0x20
    800035d4:	9101                	srli	a0,a0,0x20
    800035d6:	60e2                	ld	ra,24(sp)
    800035d8:	6442                	ld	s0,16(sp)
    800035da:	64a2                	ld	s1,8(sp)
    800035dc:	6105                	addi	sp,sp,32
    800035de:	8082                	ret

00000000800035e0 <sys_spoon>:

uint64 sys_spoon(void)
{
    800035e0:	1101                	addi	sp,sp,-32
    800035e2:	ec06                	sd	ra,24(sp)
    800035e4:	e822                	sd	s0,16(sp)
    800035e6:	1000                	addi	s0,sp,32
  // obtain the argument from the stack, we need some special handling
  uint64 addr;
  argaddr(0, &addr);
    800035e8:	fe840593          	addi	a1,s0,-24
    800035ec:	4501                	li	a0,0
    800035ee:	00000097          	auipc	ra,0x0
    800035f2:	d4e080e7          	jalr	-690(ra) # 8000333c <argaddr>
  return spoon((void*)addr);
    800035f6:	fe843503          	ld	a0,-24(s0)
    800035fa:	fffff097          	auipc	ra,0xfffff
    800035fe:	7f4080e7          	jalr	2036(ra) # 80002dee <spoon>
}
    80003602:	60e2                	ld	ra,24(sp)
    80003604:	6442                	ld	s0,16(sp)
    80003606:	6105                	addi	sp,sp,32
    80003608:	8082                	ret

000000008000360a <sys_create_thread>:

uint64 sys_create_thread(void* arg) {
    8000360a:	7179                	addi	sp,sp,-48
    8000360c:	f406                	sd	ra,40(sp)
    8000360e:	f022                	sd	s0,32(sp)
    80003610:	1800                	addi	s0,sp,48
  uint64 fn_addr, args_addr, stack_addr, exit_fn;
  argaddr(0, &fn_addr);
    80003612:	fe840593          	addi	a1,s0,-24
    80003616:	4501                	li	a0,0
    80003618:	00000097          	auipc	ra,0x0
    8000361c:	d24080e7          	jalr	-732(ra) # 8000333c <argaddr>
  argaddr(1, &args_addr);
    80003620:	fe040593          	addi	a1,s0,-32
    80003624:	4505                	li	a0,1
    80003626:	00000097          	auipc	ra,0x0
    8000362a:	d16080e7          	jalr	-746(ra) # 8000333c <argaddr>
  argaddr(2, &stack_addr);
    8000362e:	fd840593          	addi	a1,s0,-40
    80003632:	4509                	li	a0,2
    80003634:	00000097          	auipc	ra,0x0
    80003638:	d08080e7          	jalr	-760(ra) # 8000333c <argaddr>
  argaddr(3, &exit_fn);
    8000363c:	fd040593          	addi	a1,s0,-48
    80003640:	450d                	li	a0,3
    80003642:	00000097          	auipc	ra,0x0
    80003646:	cfa080e7          	jalr	-774(ra) # 8000333c <argaddr>
  return create_thread((void*)fn_addr, (void *)args_addr, (void *)stack_addr, (void *)exit_fn);
    8000364a:	fd043683          	ld	a3,-48(s0)
    8000364e:	fd843603          	ld	a2,-40(s0)
    80003652:	fe043583          	ld	a1,-32(s0)
    80003656:	fe843503          	ld	a0,-24(s0)
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	bf4080e7          	jalr	-1036(ra) # 8000224e <create_thread>
}
    80003662:	70a2                	ld	ra,40(sp)
    80003664:	7402                	ld	s0,32(sp)
    80003666:	6145                	addi	sp,sp,48
    80003668:	8082                	ret

000000008000366a <sys_join_thread>:

uint64 sys_join_thread(void* arg) {
    8000366a:	1101                	addi	sp,sp,-32
    8000366c:	ec06                	sd	ra,24(sp)
    8000366e:	e822                	sd	s0,16(sp)
    80003670:	1000                	addi	s0,sp,32
  uint64 thread_id, status_addr;
  argaddr(0, &thread_id);
    80003672:	fe840593          	addi	a1,s0,-24
    80003676:	4501                	li	a0,0
    80003678:	00000097          	auipc	ra,0x0
    8000367c:	cc4080e7          	jalr	-828(ra) # 8000333c <argaddr>
  argaddr(1, &status_addr);
    80003680:	fe040593          	addi	a1,s0,-32
    80003684:	4505                	li	a0,1
    80003686:	00000097          	auipc	ra,0x0
    8000368a:	cb6080e7          	jalr	-842(ra) # 8000333c <argaddr>
  return join_thread(thread_id, status_addr);
    8000368e:	fe043583          	ld	a1,-32(s0)
    80003692:	fe843503          	ld	a0,-24(s0)
    80003696:	fffff097          	auipc	ra,0xfffff
    8000369a:	38c080e7          	jalr	908(ra) # 80002a22 <join_thread>
}
    8000369e:	60e2                	ld	ra,24(sp)
    800036a0:	6442                	ld	s0,16(sp)
    800036a2:	6105                	addi	sp,sp,32
    800036a4:	8082                	ret

00000000800036a6 <sys_thread_exit>:

uint64 sys_thread_exit(void *arg) {
    800036a6:	1101                	addi	sp,sp,-32
    800036a8:	ec06                	sd	ra,24(sp)
    800036aa:	e822                	sd	s0,16(sp)
    800036ac:	1000                	addi	s0,sp,32
  uint64 status_addr;
  argaddr(0, &status_addr);
    800036ae:	fe840593          	addi	a1,s0,-24
    800036b2:	4501                	li	a0,0
    800036b4:	00000097          	auipc	ra,0x0
    800036b8:	c88080e7          	jalr	-888(ra) # 8000333c <argaddr>
  return thread_exit(status_addr);
    800036bc:	fe843503          	ld	a0,-24(s0)
    800036c0:	fffff097          	auipc	ra,0xfffff
    800036c4:	028080e7          	jalr	40(ra) # 800026e8 <thread_exit>
}
    800036c8:	60e2                	ld	ra,24(sp)
    800036ca:	6442                	ld	s0,16(sp)
    800036cc:	6105                	addi	sp,sp,32
    800036ce:	8082                	ret

00000000800036d0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800036d0:	7179                	addi	sp,sp,-48
    800036d2:	f406                	sd	ra,40(sp)
    800036d4:	f022                	sd	s0,32(sp)
    800036d6:	ec26                	sd	s1,24(sp)
    800036d8:	e84a                	sd	s2,16(sp)
    800036da:	e44e                	sd	s3,8(sp)
    800036dc:	e052                	sd	s4,0(sp)
    800036de:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800036e0:	00005597          	auipc	a1,0x5
    800036e4:	ec058593          	addi	a1,a1,-320 # 800085a0 <syscalls+0xd0>
    800036e8:	0005b517          	auipc	a0,0x5b
    800036ec:	55050513          	addi	a0,a0,1360 # 8005ec38 <bcache>
    800036f0:	ffffd097          	auipc	ra,0xffffd
    800036f4:	52c080e7          	jalr	1324(ra) # 80000c1c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800036f8:	00063797          	auipc	a5,0x63
    800036fc:	54078793          	addi	a5,a5,1344 # 80066c38 <bcache+0x8000>
    80003700:	00063717          	auipc	a4,0x63
    80003704:	7a070713          	addi	a4,a4,1952 # 80066ea0 <bcache+0x8268>
    80003708:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000370c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003710:	0005b497          	auipc	s1,0x5b
    80003714:	54048493          	addi	s1,s1,1344 # 8005ec50 <bcache+0x18>
    b->next = bcache.head.next;
    80003718:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000371a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000371c:	00005a17          	auipc	s4,0x5
    80003720:	e8ca0a13          	addi	s4,s4,-372 # 800085a8 <syscalls+0xd8>
    b->next = bcache.head.next;
    80003724:	2b893783          	ld	a5,696(s2)
    80003728:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000372a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000372e:	85d2                	mv	a1,s4
    80003730:	01048513          	addi	a0,s1,16
    80003734:	00001097          	auipc	ra,0x1
    80003738:	4c8080e7          	jalr	1224(ra) # 80004bfc <initsleeplock>
    bcache.head.next->prev = b;
    8000373c:	2b893783          	ld	a5,696(s2)
    80003740:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003742:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003746:	45848493          	addi	s1,s1,1112
    8000374a:	fd349de3          	bne	s1,s3,80003724 <binit+0x54>
  }
}
    8000374e:	70a2                	ld	ra,40(sp)
    80003750:	7402                	ld	s0,32(sp)
    80003752:	64e2                	ld	s1,24(sp)
    80003754:	6942                	ld	s2,16(sp)
    80003756:	69a2                	ld	s3,8(sp)
    80003758:	6a02                	ld	s4,0(sp)
    8000375a:	6145                	addi	sp,sp,48
    8000375c:	8082                	ret

000000008000375e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000375e:	7179                	addi	sp,sp,-48
    80003760:	f406                	sd	ra,40(sp)
    80003762:	f022                	sd	s0,32(sp)
    80003764:	ec26                	sd	s1,24(sp)
    80003766:	e84a                	sd	s2,16(sp)
    80003768:	e44e                	sd	s3,8(sp)
    8000376a:	1800                	addi	s0,sp,48
    8000376c:	892a                	mv	s2,a0
    8000376e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003770:	0005b517          	auipc	a0,0x5b
    80003774:	4c850513          	addi	a0,a0,1224 # 8005ec38 <bcache>
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	534080e7          	jalr	1332(ra) # 80000cac <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003780:	00063497          	auipc	s1,0x63
    80003784:	7704b483          	ld	s1,1904(s1) # 80066ef0 <bcache+0x82b8>
    80003788:	00063797          	auipc	a5,0x63
    8000378c:	71878793          	addi	a5,a5,1816 # 80066ea0 <bcache+0x8268>
    80003790:	02f48f63          	beq	s1,a5,800037ce <bread+0x70>
    80003794:	873e                	mv	a4,a5
    80003796:	a021                	j	8000379e <bread+0x40>
    80003798:	68a4                	ld	s1,80(s1)
    8000379a:	02e48a63          	beq	s1,a4,800037ce <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000379e:	449c                	lw	a5,8(s1)
    800037a0:	ff279ce3          	bne	a5,s2,80003798 <bread+0x3a>
    800037a4:	44dc                	lw	a5,12(s1)
    800037a6:	ff3799e3          	bne	a5,s3,80003798 <bread+0x3a>
      b->refcnt++;
    800037aa:	40bc                	lw	a5,64(s1)
    800037ac:	2785                	addiw	a5,a5,1
    800037ae:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800037b0:	0005b517          	auipc	a0,0x5b
    800037b4:	48850513          	addi	a0,a0,1160 # 8005ec38 <bcache>
    800037b8:	ffffd097          	auipc	ra,0xffffd
    800037bc:	5a8080e7          	jalr	1448(ra) # 80000d60 <release>
      acquiresleep(&b->lock);
    800037c0:	01048513          	addi	a0,s1,16
    800037c4:	00001097          	auipc	ra,0x1
    800037c8:	472080e7          	jalr	1138(ra) # 80004c36 <acquiresleep>
      return b;
    800037cc:	a8b9                	j	8000382a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800037ce:	00063497          	auipc	s1,0x63
    800037d2:	71a4b483          	ld	s1,1818(s1) # 80066ee8 <bcache+0x82b0>
    800037d6:	00063797          	auipc	a5,0x63
    800037da:	6ca78793          	addi	a5,a5,1738 # 80066ea0 <bcache+0x8268>
    800037de:	00f48863          	beq	s1,a5,800037ee <bread+0x90>
    800037e2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800037e4:	40bc                	lw	a5,64(s1)
    800037e6:	cf81                	beqz	a5,800037fe <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800037e8:	64a4                	ld	s1,72(s1)
    800037ea:	fee49de3          	bne	s1,a4,800037e4 <bread+0x86>
  panic("bget: no buffers");
    800037ee:	00005517          	auipc	a0,0x5
    800037f2:	dc250513          	addi	a0,a0,-574 # 800085b0 <syscalls+0xe0>
    800037f6:	ffffd097          	auipc	ra,0xffffd
    800037fa:	d4a080e7          	jalr	-694(ra) # 80000540 <panic>
      b->dev = dev;
    800037fe:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003802:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003806:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000380a:	4785                	li	a5,1
    8000380c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000380e:	0005b517          	auipc	a0,0x5b
    80003812:	42a50513          	addi	a0,a0,1066 # 8005ec38 <bcache>
    80003816:	ffffd097          	auipc	ra,0xffffd
    8000381a:	54a080e7          	jalr	1354(ra) # 80000d60 <release>
      acquiresleep(&b->lock);
    8000381e:	01048513          	addi	a0,s1,16
    80003822:	00001097          	auipc	ra,0x1
    80003826:	414080e7          	jalr	1044(ra) # 80004c36 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000382a:	409c                	lw	a5,0(s1)
    8000382c:	cb89                	beqz	a5,8000383e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000382e:	8526                	mv	a0,s1
    80003830:	70a2                	ld	ra,40(sp)
    80003832:	7402                	ld	s0,32(sp)
    80003834:	64e2                	ld	s1,24(sp)
    80003836:	6942                	ld	s2,16(sp)
    80003838:	69a2                	ld	s3,8(sp)
    8000383a:	6145                	addi	sp,sp,48
    8000383c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000383e:	4581                	li	a1,0
    80003840:	8526                	mv	a0,s1
    80003842:	00003097          	auipc	ra,0x3
    80003846:	fe0080e7          	jalr	-32(ra) # 80006822 <virtio_disk_rw>
    b->valid = 1;
    8000384a:	4785                	li	a5,1
    8000384c:	c09c                	sw	a5,0(s1)
  return b;
    8000384e:	b7c5                	j	8000382e <bread+0xd0>

0000000080003850 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003850:	1101                	addi	sp,sp,-32
    80003852:	ec06                	sd	ra,24(sp)
    80003854:	e822                	sd	s0,16(sp)
    80003856:	e426                	sd	s1,8(sp)
    80003858:	1000                	addi	s0,sp,32
    8000385a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000385c:	0541                	addi	a0,a0,16
    8000385e:	00001097          	auipc	ra,0x1
    80003862:	472080e7          	jalr	1138(ra) # 80004cd0 <holdingsleep>
    80003866:	cd01                	beqz	a0,8000387e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003868:	4585                	li	a1,1
    8000386a:	8526                	mv	a0,s1
    8000386c:	00003097          	auipc	ra,0x3
    80003870:	fb6080e7          	jalr	-74(ra) # 80006822 <virtio_disk_rw>
}
    80003874:	60e2                	ld	ra,24(sp)
    80003876:	6442                	ld	s0,16(sp)
    80003878:	64a2                	ld	s1,8(sp)
    8000387a:	6105                	addi	sp,sp,32
    8000387c:	8082                	ret
    panic("bwrite");
    8000387e:	00005517          	auipc	a0,0x5
    80003882:	d4a50513          	addi	a0,a0,-694 # 800085c8 <syscalls+0xf8>
    80003886:	ffffd097          	auipc	ra,0xffffd
    8000388a:	cba080e7          	jalr	-838(ra) # 80000540 <panic>

000000008000388e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000388e:	1101                	addi	sp,sp,-32
    80003890:	ec06                	sd	ra,24(sp)
    80003892:	e822                	sd	s0,16(sp)
    80003894:	e426                	sd	s1,8(sp)
    80003896:	e04a                	sd	s2,0(sp)
    80003898:	1000                	addi	s0,sp,32
    8000389a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000389c:	01050913          	addi	s2,a0,16
    800038a0:	854a                	mv	a0,s2
    800038a2:	00001097          	auipc	ra,0x1
    800038a6:	42e080e7          	jalr	1070(ra) # 80004cd0 <holdingsleep>
    800038aa:	c92d                	beqz	a0,8000391c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800038ac:	854a                	mv	a0,s2
    800038ae:	00001097          	auipc	ra,0x1
    800038b2:	3de080e7          	jalr	990(ra) # 80004c8c <releasesleep>

  acquire(&bcache.lock);
    800038b6:	0005b517          	auipc	a0,0x5b
    800038ba:	38250513          	addi	a0,a0,898 # 8005ec38 <bcache>
    800038be:	ffffd097          	auipc	ra,0xffffd
    800038c2:	3ee080e7          	jalr	1006(ra) # 80000cac <acquire>
  b->refcnt--;
    800038c6:	40bc                	lw	a5,64(s1)
    800038c8:	37fd                	addiw	a5,a5,-1
    800038ca:	0007871b          	sext.w	a4,a5
    800038ce:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800038d0:	eb05                	bnez	a4,80003900 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800038d2:	68bc                	ld	a5,80(s1)
    800038d4:	64b8                	ld	a4,72(s1)
    800038d6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800038d8:	64bc                	ld	a5,72(s1)
    800038da:	68b8                	ld	a4,80(s1)
    800038dc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800038de:	00063797          	auipc	a5,0x63
    800038e2:	35a78793          	addi	a5,a5,858 # 80066c38 <bcache+0x8000>
    800038e6:	2b87b703          	ld	a4,696(a5)
    800038ea:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800038ec:	00063717          	auipc	a4,0x63
    800038f0:	5b470713          	addi	a4,a4,1460 # 80066ea0 <bcache+0x8268>
    800038f4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800038f6:	2b87b703          	ld	a4,696(a5)
    800038fa:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800038fc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003900:	0005b517          	auipc	a0,0x5b
    80003904:	33850513          	addi	a0,a0,824 # 8005ec38 <bcache>
    80003908:	ffffd097          	auipc	ra,0xffffd
    8000390c:	458080e7          	jalr	1112(ra) # 80000d60 <release>
}
    80003910:	60e2                	ld	ra,24(sp)
    80003912:	6442                	ld	s0,16(sp)
    80003914:	64a2                	ld	s1,8(sp)
    80003916:	6902                	ld	s2,0(sp)
    80003918:	6105                	addi	sp,sp,32
    8000391a:	8082                	ret
    panic("brelse");
    8000391c:	00005517          	auipc	a0,0x5
    80003920:	cb450513          	addi	a0,a0,-844 # 800085d0 <syscalls+0x100>
    80003924:	ffffd097          	auipc	ra,0xffffd
    80003928:	c1c080e7          	jalr	-996(ra) # 80000540 <panic>

000000008000392c <bpin>:

void
bpin(struct buf *b) {
    8000392c:	1101                	addi	sp,sp,-32
    8000392e:	ec06                	sd	ra,24(sp)
    80003930:	e822                	sd	s0,16(sp)
    80003932:	e426                	sd	s1,8(sp)
    80003934:	1000                	addi	s0,sp,32
    80003936:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003938:	0005b517          	auipc	a0,0x5b
    8000393c:	30050513          	addi	a0,a0,768 # 8005ec38 <bcache>
    80003940:	ffffd097          	auipc	ra,0xffffd
    80003944:	36c080e7          	jalr	876(ra) # 80000cac <acquire>
  b->refcnt++;
    80003948:	40bc                	lw	a5,64(s1)
    8000394a:	2785                	addiw	a5,a5,1
    8000394c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000394e:	0005b517          	auipc	a0,0x5b
    80003952:	2ea50513          	addi	a0,a0,746 # 8005ec38 <bcache>
    80003956:	ffffd097          	auipc	ra,0xffffd
    8000395a:	40a080e7          	jalr	1034(ra) # 80000d60 <release>
}
    8000395e:	60e2                	ld	ra,24(sp)
    80003960:	6442                	ld	s0,16(sp)
    80003962:	64a2                	ld	s1,8(sp)
    80003964:	6105                	addi	sp,sp,32
    80003966:	8082                	ret

0000000080003968 <bunpin>:

void
bunpin(struct buf *b) {
    80003968:	1101                	addi	sp,sp,-32
    8000396a:	ec06                	sd	ra,24(sp)
    8000396c:	e822                	sd	s0,16(sp)
    8000396e:	e426                	sd	s1,8(sp)
    80003970:	1000                	addi	s0,sp,32
    80003972:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003974:	0005b517          	auipc	a0,0x5b
    80003978:	2c450513          	addi	a0,a0,708 # 8005ec38 <bcache>
    8000397c:	ffffd097          	auipc	ra,0xffffd
    80003980:	330080e7          	jalr	816(ra) # 80000cac <acquire>
  b->refcnt--;
    80003984:	40bc                	lw	a5,64(s1)
    80003986:	37fd                	addiw	a5,a5,-1
    80003988:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000398a:	0005b517          	auipc	a0,0x5b
    8000398e:	2ae50513          	addi	a0,a0,686 # 8005ec38 <bcache>
    80003992:	ffffd097          	auipc	ra,0xffffd
    80003996:	3ce080e7          	jalr	974(ra) # 80000d60 <release>
}
    8000399a:	60e2                	ld	ra,24(sp)
    8000399c:	6442                	ld	s0,16(sp)
    8000399e:	64a2                	ld	s1,8(sp)
    800039a0:	6105                	addi	sp,sp,32
    800039a2:	8082                	ret

00000000800039a4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800039a4:	1101                	addi	sp,sp,-32
    800039a6:	ec06                	sd	ra,24(sp)
    800039a8:	e822                	sd	s0,16(sp)
    800039aa:	e426                	sd	s1,8(sp)
    800039ac:	e04a                	sd	s2,0(sp)
    800039ae:	1000                	addi	s0,sp,32
    800039b0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800039b2:	00d5d59b          	srliw	a1,a1,0xd
    800039b6:	00064797          	auipc	a5,0x64
    800039ba:	95e7a783          	lw	a5,-1698(a5) # 80067314 <sb+0x1c>
    800039be:	9dbd                	addw	a1,a1,a5
    800039c0:	00000097          	auipc	ra,0x0
    800039c4:	d9e080e7          	jalr	-610(ra) # 8000375e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800039c8:	0074f713          	andi	a4,s1,7
    800039cc:	4785                	li	a5,1
    800039ce:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800039d2:	14ce                	slli	s1,s1,0x33
    800039d4:	90d9                	srli	s1,s1,0x36
    800039d6:	00950733          	add	a4,a0,s1
    800039da:	05874703          	lbu	a4,88(a4)
    800039de:	00e7f6b3          	and	a3,a5,a4
    800039e2:	c69d                	beqz	a3,80003a10 <bfree+0x6c>
    800039e4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800039e6:	94aa                	add	s1,s1,a0
    800039e8:	fff7c793          	not	a5,a5
    800039ec:	8f7d                	and	a4,a4,a5
    800039ee:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800039f2:	00001097          	auipc	ra,0x1
    800039f6:	126080e7          	jalr	294(ra) # 80004b18 <log_write>
  brelse(bp);
    800039fa:	854a                	mv	a0,s2
    800039fc:	00000097          	auipc	ra,0x0
    80003a00:	e92080e7          	jalr	-366(ra) # 8000388e <brelse>
}
    80003a04:	60e2                	ld	ra,24(sp)
    80003a06:	6442                	ld	s0,16(sp)
    80003a08:	64a2                	ld	s1,8(sp)
    80003a0a:	6902                	ld	s2,0(sp)
    80003a0c:	6105                	addi	sp,sp,32
    80003a0e:	8082                	ret
    panic("freeing free block");
    80003a10:	00005517          	auipc	a0,0x5
    80003a14:	bc850513          	addi	a0,a0,-1080 # 800085d8 <syscalls+0x108>
    80003a18:	ffffd097          	auipc	ra,0xffffd
    80003a1c:	b28080e7          	jalr	-1240(ra) # 80000540 <panic>

0000000080003a20 <balloc>:
{
    80003a20:	711d                	addi	sp,sp,-96
    80003a22:	ec86                	sd	ra,88(sp)
    80003a24:	e8a2                	sd	s0,80(sp)
    80003a26:	e4a6                	sd	s1,72(sp)
    80003a28:	e0ca                	sd	s2,64(sp)
    80003a2a:	fc4e                	sd	s3,56(sp)
    80003a2c:	f852                	sd	s4,48(sp)
    80003a2e:	f456                	sd	s5,40(sp)
    80003a30:	f05a                	sd	s6,32(sp)
    80003a32:	ec5e                	sd	s7,24(sp)
    80003a34:	e862                	sd	s8,16(sp)
    80003a36:	e466                	sd	s9,8(sp)
    80003a38:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003a3a:	00064797          	auipc	a5,0x64
    80003a3e:	8c27a783          	lw	a5,-1854(a5) # 800672fc <sb+0x4>
    80003a42:	cff5                	beqz	a5,80003b3e <balloc+0x11e>
    80003a44:	8baa                	mv	s7,a0
    80003a46:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003a48:	00064b17          	auipc	s6,0x64
    80003a4c:	8b0b0b13          	addi	s6,s6,-1872 # 800672f8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a50:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003a52:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a54:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003a56:	6c89                	lui	s9,0x2
    80003a58:	a061                	j	80003ae0 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003a5a:	97ca                	add	a5,a5,s2
    80003a5c:	8e55                	or	a2,a2,a3
    80003a5e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003a62:	854a                	mv	a0,s2
    80003a64:	00001097          	auipc	ra,0x1
    80003a68:	0b4080e7          	jalr	180(ra) # 80004b18 <log_write>
        brelse(bp);
    80003a6c:	854a                	mv	a0,s2
    80003a6e:	00000097          	auipc	ra,0x0
    80003a72:	e20080e7          	jalr	-480(ra) # 8000388e <brelse>
  bp = bread(dev, bno);
    80003a76:	85a6                	mv	a1,s1
    80003a78:	855e                	mv	a0,s7
    80003a7a:	00000097          	auipc	ra,0x0
    80003a7e:	ce4080e7          	jalr	-796(ra) # 8000375e <bread>
    80003a82:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003a84:	40000613          	li	a2,1024
    80003a88:	4581                	li	a1,0
    80003a8a:	05850513          	addi	a0,a0,88
    80003a8e:	ffffd097          	auipc	ra,0xffffd
    80003a92:	31a080e7          	jalr	794(ra) # 80000da8 <memset>
  log_write(bp);
    80003a96:	854a                	mv	a0,s2
    80003a98:	00001097          	auipc	ra,0x1
    80003a9c:	080080e7          	jalr	128(ra) # 80004b18 <log_write>
  brelse(bp);
    80003aa0:	854a                	mv	a0,s2
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	dec080e7          	jalr	-532(ra) # 8000388e <brelse>
}
    80003aaa:	8526                	mv	a0,s1
    80003aac:	60e6                	ld	ra,88(sp)
    80003aae:	6446                	ld	s0,80(sp)
    80003ab0:	64a6                	ld	s1,72(sp)
    80003ab2:	6906                	ld	s2,64(sp)
    80003ab4:	79e2                	ld	s3,56(sp)
    80003ab6:	7a42                	ld	s4,48(sp)
    80003ab8:	7aa2                	ld	s5,40(sp)
    80003aba:	7b02                	ld	s6,32(sp)
    80003abc:	6be2                	ld	s7,24(sp)
    80003abe:	6c42                	ld	s8,16(sp)
    80003ac0:	6ca2                	ld	s9,8(sp)
    80003ac2:	6125                	addi	sp,sp,96
    80003ac4:	8082                	ret
    brelse(bp);
    80003ac6:	854a                	mv	a0,s2
    80003ac8:	00000097          	auipc	ra,0x0
    80003acc:	dc6080e7          	jalr	-570(ra) # 8000388e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003ad0:	015c87bb          	addw	a5,s9,s5
    80003ad4:	00078a9b          	sext.w	s5,a5
    80003ad8:	004b2703          	lw	a4,4(s6)
    80003adc:	06eaf163          	bgeu	s5,a4,80003b3e <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003ae0:	41fad79b          	sraiw	a5,s5,0x1f
    80003ae4:	0137d79b          	srliw	a5,a5,0x13
    80003ae8:	015787bb          	addw	a5,a5,s5
    80003aec:	40d7d79b          	sraiw	a5,a5,0xd
    80003af0:	01cb2583          	lw	a1,28(s6)
    80003af4:	9dbd                	addw	a1,a1,a5
    80003af6:	855e                	mv	a0,s7
    80003af8:	00000097          	auipc	ra,0x0
    80003afc:	c66080e7          	jalr	-922(ra) # 8000375e <bread>
    80003b00:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b02:	004b2503          	lw	a0,4(s6)
    80003b06:	000a849b          	sext.w	s1,s5
    80003b0a:	8762                	mv	a4,s8
    80003b0c:	faa4fde3          	bgeu	s1,a0,80003ac6 <balloc+0xa6>
      m = 1 << (bi % 8);
    80003b10:	00777693          	andi	a3,a4,7
    80003b14:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003b18:	41f7579b          	sraiw	a5,a4,0x1f
    80003b1c:	01d7d79b          	srliw	a5,a5,0x1d
    80003b20:	9fb9                	addw	a5,a5,a4
    80003b22:	4037d79b          	sraiw	a5,a5,0x3
    80003b26:	00f90633          	add	a2,s2,a5
    80003b2a:	05864603          	lbu	a2,88(a2)
    80003b2e:	00c6f5b3          	and	a1,a3,a2
    80003b32:	d585                	beqz	a1,80003a5a <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b34:	2705                	addiw	a4,a4,1
    80003b36:	2485                	addiw	s1,s1,1
    80003b38:	fd471ae3          	bne	a4,s4,80003b0c <balloc+0xec>
    80003b3c:	b769                	j	80003ac6 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003b3e:	00005517          	auipc	a0,0x5
    80003b42:	ab250513          	addi	a0,a0,-1358 # 800085f0 <syscalls+0x120>
    80003b46:	ffffd097          	auipc	ra,0xffffd
    80003b4a:	a44080e7          	jalr	-1468(ra) # 8000058a <printf>
  return 0;
    80003b4e:	4481                	li	s1,0
    80003b50:	bfa9                	j	80003aaa <balloc+0x8a>

0000000080003b52 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003b52:	7179                	addi	sp,sp,-48
    80003b54:	f406                	sd	ra,40(sp)
    80003b56:	f022                	sd	s0,32(sp)
    80003b58:	ec26                	sd	s1,24(sp)
    80003b5a:	e84a                	sd	s2,16(sp)
    80003b5c:	e44e                	sd	s3,8(sp)
    80003b5e:	e052                	sd	s4,0(sp)
    80003b60:	1800                	addi	s0,sp,48
    80003b62:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003b64:	47ad                	li	a5,11
    80003b66:	02b7e863          	bltu	a5,a1,80003b96 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80003b6a:	02059793          	slli	a5,a1,0x20
    80003b6e:	01e7d593          	srli	a1,a5,0x1e
    80003b72:	00b504b3          	add	s1,a0,a1
    80003b76:	0504a903          	lw	s2,80(s1)
    80003b7a:	06091e63          	bnez	s2,80003bf6 <bmap+0xa4>
      addr = balloc(ip->dev);
    80003b7e:	4108                	lw	a0,0(a0)
    80003b80:	00000097          	auipc	ra,0x0
    80003b84:	ea0080e7          	jalr	-352(ra) # 80003a20 <balloc>
    80003b88:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003b8c:	06090563          	beqz	s2,80003bf6 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80003b90:	0524a823          	sw	s2,80(s1)
    80003b94:	a08d                	j	80003bf6 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003b96:	ff45849b          	addiw	s1,a1,-12
    80003b9a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003b9e:	0ff00793          	li	a5,255
    80003ba2:	08e7e563          	bltu	a5,a4,80003c2c <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003ba6:	08052903          	lw	s2,128(a0)
    80003baa:	00091d63          	bnez	s2,80003bc4 <bmap+0x72>
      addr = balloc(ip->dev);
    80003bae:	4108                	lw	a0,0(a0)
    80003bb0:	00000097          	auipc	ra,0x0
    80003bb4:	e70080e7          	jalr	-400(ra) # 80003a20 <balloc>
    80003bb8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003bbc:	02090d63          	beqz	s2,80003bf6 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003bc0:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003bc4:	85ca                	mv	a1,s2
    80003bc6:	0009a503          	lw	a0,0(s3)
    80003bca:	00000097          	auipc	ra,0x0
    80003bce:	b94080e7          	jalr	-1132(ra) # 8000375e <bread>
    80003bd2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003bd4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003bd8:	02049713          	slli	a4,s1,0x20
    80003bdc:	01e75593          	srli	a1,a4,0x1e
    80003be0:	00b784b3          	add	s1,a5,a1
    80003be4:	0004a903          	lw	s2,0(s1)
    80003be8:	02090063          	beqz	s2,80003c08 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003bec:	8552                	mv	a0,s4
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	ca0080e7          	jalr	-864(ra) # 8000388e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003bf6:	854a                	mv	a0,s2
    80003bf8:	70a2                	ld	ra,40(sp)
    80003bfa:	7402                	ld	s0,32(sp)
    80003bfc:	64e2                	ld	s1,24(sp)
    80003bfe:	6942                	ld	s2,16(sp)
    80003c00:	69a2                	ld	s3,8(sp)
    80003c02:	6a02                	ld	s4,0(sp)
    80003c04:	6145                	addi	sp,sp,48
    80003c06:	8082                	ret
      addr = balloc(ip->dev);
    80003c08:	0009a503          	lw	a0,0(s3)
    80003c0c:	00000097          	auipc	ra,0x0
    80003c10:	e14080e7          	jalr	-492(ra) # 80003a20 <balloc>
    80003c14:	0005091b          	sext.w	s2,a0
      if(addr){
    80003c18:	fc090ae3          	beqz	s2,80003bec <bmap+0x9a>
        a[bn] = addr;
    80003c1c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003c20:	8552                	mv	a0,s4
    80003c22:	00001097          	auipc	ra,0x1
    80003c26:	ef6080e7          	jalr	-266(ra) # 80004b18 <log_write>
    80003c2a:	b7c9                	j	80003bec <bmap+0x9a>
  panic("bmap: out of range");
    80003c2c:	00005517          	auipc	a0,0x5
    80003c30:	9dc50513          	addi	a0,a0,-1572 # 80008608 <syscalls+0x138>
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	90c080e7          	jalr	-1780(ra) # 80000540 <panic>

0000000080003c3c <iget>:
{
    80003c3c:	7179                	addi	sp,sp,-48
    80003c3e:	f406                	sd	ra,40(sp)
    80003c40:	f022                	sd	s0,32(sp)
    80003c42:	ec26                	sd	s1,24(sp)
    80003c44:	e84a                	sd	s2,16(sp)
    80003c46:	e44e                	sd	s3,8(sp)
    80003c48:	e052                	sd	s4,0(sp)
    80003c4a:	1800                	addi	s0,sp,48
    80003c4c:	89aa                	mv	s3,a0
    80003c4e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003c50:	00063517          	auipc	a0,0x63
    80003c54:	6c850513          	addi	a0,a0,1736 # 80067318 <itable>
    80003c58:	ffffd097          	auipc	ra,0xffffd
    80003c5c:	054080e7          	jalr	84(ra) # 80000cac <acquire>
  empty = 0;
    80003c60:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003c62:	00063497          	auipc	s1,0x63
    80003c66:	6ce48493          	addi	s1,s1,1742 # 80067330 <itable+0x18>
    80003c6a:	00065697          	auipc	a3,0x65
    80003c6e:	15668693          	addi	a3,a3,342 # 80068dc0 <log>
    80003c72:	a039                	j	80003c80 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003c74:	02090b63          	beqz	s2,80003caa <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003c78:	08848493          	addi	s1,s1,136
    80003c7c:	02d48a63          	beq	s1,a3,80003cb0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003c80:	449c                	lw	a5,8(s1)
    80003c82:	fef059e3          	blez	a5,80003c74 <iget+0x38>
    80003c86:	4098                	lw	a4,0(s1)
    80003c88:	ff3716e3          	bne	a4,s3,80003c74 <iget+0x38>
    80003c8c:	40d8                	lw	a4,4(s1)
    80003c8e:	ff4713e3          	bne	a4,s4,80003c74 <iget+0x38>
      ip->ref++;
    80003c92:	2785                	addiw	a5,a5,1
    80003c94:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003c96:	00063517          	auipc	a0,0x63
    80003c9a:	68250513          	addi	a0,a0,1666 # 80067318 <itable>
    80003c9e:	ffffd097          	auipc	ra,0xffffd
    80003ca2:	0c2080e7          	jalr	194(ra) # 80000d60 <release>
      return ip;
    80003ca6:	8926                	mv	s2,s1
    80003ca8:	a03d                	j	80003cd6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003caa:	f7f9                	bnez	a5,80003c78 <iget+0x3c>
    80003cac:	8926                	mv	s2,s1
    80003cae:	b7e9                	j	80003c78 <iget+0x3c>
  if(empty == 0)
    80003cb0:	02090c63          	beqz	s2,80003ce8 <iget+0xac>
  ip->dev = dev;
    80003cb4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003cb8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003cbc:	4785                	li	a5,1
    80003cbe:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003cc2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003cc6:	00063517          	auipc	a0,0x63
    80003cca:	65250513          	addi	a0,a0,1618 # 80067318 <itable>
    80003cce:	ffffd097          	auipc	ra,0xffffd
    80003cd2:	092080e7          	jalr	146(ra) # 80000d60 <release>
}
    80003cd6:	854a                	mv	a0,s2
    80003cd8:	70a2                	ld	ra,40(sp)
    80003cda:	7402                	ld	s0,32(sp)
    80003cdc:	64e2                	ld	s1,24(sp)
    80003cde:	6942                	ld	s2,16(sp)
    80003ce0:	69a2                	ld	s3,8(sp)
    80003ce2:	6a02                	ld	s4,0(sp)
    80003ce4:	6145                	addi	sp,sp,48
    80003ce6:	8082                	ret
    panic("iget: no inodes");
    80003ce8:	00005517          	auipc	a0,0x5
    80003cec:	93850513          	addi	a0,a0,-1736 # 80008620 <syscalls+0x150>
    80003cf0:	ffffd097          	auipc	ra,0xffffd
    80003cf4:	850080e7          	jalr	-1968(ra) # 80000540 <panic>

0000000080003cf8 <fsinit>:
fsinit(int dev) {
    80003cf8:	7179                	addi	sp,sp,-48
    80003cfa:	f406                	sd	ra,40(sp)
    80003cfc:	f022                	sd	s0,32(sp)
    80003cfe:	ec26                	sd	s1,24(sp)
    80003d00:	e84a                	sd	s2,16(sp)
    80003d02:	e44e                	sd	s3,8(sp)
    80003d04:	1800                	addi	s0,sp,48
    80003d06:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003d08:	4585                	li	a1,1
    80003d0a:	00000097          	auipc	ra,0x0
    80003d0e:	a54080e7          	jalr	-1452(ra) # 8000375e <bread>
    80003d12:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003d14:	00063997          	auipc	s3,0x63
    80003d18:	5e498993          	addi	s3,s3,1508 # 800672f8 <sb>
    80003d1c:	02000613          	li	a2,32
    80003d20:	05850593          	addi	a1,a0,88
    80003d24:	854e                	mv	a0,s3
    80003d26:	ffffd097          	auipc	ra,0xffffd
    80003d2a:	0de080e7          	jalr	222(ra) # 80000e04 <memmove>
  brelse(bp);
    80003d2e:	8526                	mv	a0,s1
    80003d30:	00000097          	auipc	ra,0x0
    80003d34:	b5e080e7          	jalr	-1186(ra) # 8000388e <brelse>
  if(sb.magic != FSMAGIC)
    80003d38:	0009a703          	lw	a4,0(s3)
    80003d3c:	102037b7          	lui	a5,0x10203
    80003d40:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003d44:	02f71263          	bne	a4,a5,80003d68 <fsinit+0x70>
  initlog(dev, &sb);
    80003d48:	00063597          	auipc	a1,0x63
    80003d4c:	5b058593          	addi	a1,a1,1456 # 800672f8 <sb>
    80003d50:	854a                	mv	a0,s2
    80003d52:	00001097          	auipc	ra,0x1
    80003d56:	b4a080e7          	jalr	-1206(ra) # 8000489c <initlog>
}
    80003d5a:	70a2                	ld	ra,40(sp)
    80003d5c:	7402                	ld	s0,32(sp)
    80003d5e:	64e2                	ld	s1,24(sp)
    80003d60:	6942                	ld	s2,16(sp)
    80003d62:	69a2                	ld	s3,8(sp)
    80003d64:	6145                	addi	sp,sp,48
    80003d66:	8082                	ret
    panic("invalid file system");
    80003d68:	00005517          	auipc	a0,0x5
    80003d6c:	8c850513          	addi	a0,a0,-1848 # 80008630 <syscalls+0x160>
    80003d70:	ffffc097          	auipc	ra,0xffffc
    80003d74:	7d0080e7          	jalr	2000(ra) # 80000540 <panic>

0000000080003d78 <iinit>:
{
    80003d78:	7179                	addi	sp,sp,-48
    80003d7a:	f406                	sd	ra,40(sp)
    80003d7c:	f022                	sd	s0,32(sp)
    80003d7e:	ec26                	sd	s1,24(sp)
    80003d80:	e84a                	sd	s2,16(sp)
    80003d82:	e44e                	sd	s3,8(sp)
    80003d84:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003d86:	00005597          	auipc	a1,0x5
    80003d8a:	8c258593          	addi	a1,a1,-1854 # 80008648 <syscalls+0x178>
    80003d8e:	00063517          	auipc	a0,0x63
    80003d92:	58a50513          	addi	a0,a0,1418 # 80067318 <itable>
    80003d96:	ffffd097          	auipc	ra,0xffffd
    80003d9a:	e86080e7          	jalr	-378(ra) # 80000c1c <initlock>
  for(i = 0; i < NINODE; i++) {
    80003d9e:	00063497          	auipc	s1,0x63
    80003da2:	5a248493          	addi	s1,s1,1442 # 80067340 <itable+0x28>
    80003da6:	00065997          	auipc	s3,0x65
    80003daa:	02a98993          	addi	s3,s3,42 # 80068dd0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003dae:	00005917          	auipc	s2,0x5
    80003db2:	8a290913          	addi	s2,s2,-1886 # 80008650 <syscalls+0x180>
    80003db6:	85ca                	mv	a1,s2
    80003db8:	8526                	mv	a0,s1
    80003dba:	00001097          	auipc	ra,0x1
    80003dbe:	e42080e7          	jalr	-446(ra) # 80004bfc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003dc2:	08848493          	addi	s1,s1,136
    80003dc6:	ff3498e3          	bne	s1,s3,80003db6 <iinit+0x3e>
}
    80003dca:	70a2                	ld	ra,40(sp)
    80003dcc:	7402                	ld	s0,32(sp)
    80003dce:	64e2                	ld	s1,24(sp)
    80003dd0:	6942                	ld	s2,16(sp)
    80003dd2:	69a2                	ld	s3,8(sp)
    80003dd4:	6145                	addi	sp,sp,48
    80003dd6:	8082                	ret

0000000080003dd8 <ialloc>:
{
    80003dd8:	715d                	addi	sp,sp,-80
    80003dda:	e486                	sd	ra,72(sp)
    80003ddc:	e0a2                	sd	s0,64(sp)
    80003dde:	fc26                	sd	s1,56(sp)
    80003de0:	f84a                	sd	s2,48(sp)
    80003de2:	f44e                	sd	s3,40(sp)
    80003de4:	f052                	sd	s4,32(sp)
    80003de6:	ec56                	sd	s5,24(sp)
    80003de8:	e85a                	sd	s6,16(sp)
    80003dea:	e45e                	sd	s7,8(sp)
    80003dec:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003dee:	00063717          	auipc	a4,0x63
    80003df2:	51672703          	lw	a4,1302(a4) # 80067304 <sb+0xc>
    80003df6:	4785                	li	a5,1
    80003df8:	04e7fa63          	bgeu	a5,a4,80003e4c <ialloc+0x74>
    80003dfc:	8aaa                	mv	s5,a0
    80003dfe:	8bae                	mv	s7,a1
    80003e00:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003e02:	00063a17          	auipc	s4,0x63
    80003e06:	4f6a0a13          	addi	s4,s4,1270 # 800672f8 <sb>
    80003e0a:	00048b1b          	sext.w	s6,s1
    80003e0e:	0044d593          	srli	a1,s1,0x4
    80003e12:	018a2783          	lw	a5,24(s4)
    80003e16:	9dbd                	addw	a1,a1,a5
    80003e18:	8556                	mv	a0,s5
    80003e1a:	00000097          	auipc	ra,0x0
    80003e1e:	944080e7          	jalr	-1724(ra) # 8000375e <bread>
    80003e22:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003e24:	05850993          	addi	s3,a0,88
    80003e28:	00f4f793          	andi	a5,s1,15
    80003e2c:	079a                	slli	a5,a5,0x6
    80003e2e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003e30:	00099783          	lh	a5,0(s3)
    80003e34:	c3a1                	beqz	a5,80003e74 <ialloc+0x9c>
    brelse(bp);
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	a58080e7          	jalr	-1448(ra) # 8000388e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003e3e:	0485                	addi	s1,s1,1
    80003e40:	00ca2703          	lw	a4,12(s4)
    80003e44:	0004879b          	sext.w	a5,s1
    80003e48:	fce7e1e3          	bltu	a5,a4,80003e0a <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003e4c:	00005517          	auipc	a0,0x5
    80003e50:	80c50513          	addi	a0,a0,-2036 # 80008658 <syscalls+0x188>
    80003e54:	ffffc097          	auipc	ra,0xffffc
    80003e58:	736080e7          	jalr	1846(ra) # 8000058a <printf>
  return 0;
    80003e5c:	4501                	li	a0,0
}
    80003e5e:	60a6                	ld	ra,72(sp)
    80003e60:	6406                	ld	s0,64(sp)
    80003e62:	74e2                	ld	s1,56(sp)
    80003e64:	7942                	ld	s2,48(sp)
    80003e66:	79a2                	ld	s3,40(sp)
    80003e68:	7a02                	ld	s4,32(sp)
    80003e6a:	6ae2                	ld	s5,24(sp)
    80003e6c:	6b42                	ld	s6,16(sp)
    80003e6e:	6ba2                	ld	s7,8(sp)
    80003e70:	6161                	addi	sp,sp,80
    80003e72:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003e74:	04000613          	li	a2,64
    80003e78:	4581                	li	a1,0
    80003e7a:	854e                	mv	a0,s3
    80003e7c:	ffffd097          	auipc	ra,0xffffd
    80003e80:	f2c080e7          	jalr	-212(ra) # 80000da8 <memset>
      dip->type = type;
    80003e84:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003e88:	854a                	mv	a0,s2
    80003e8a:	00001097          	auipc	ra,0x1
    80003e8e:	c8e080e7          	jalr	-882(ra) # 80004b18 <log_write>
      brelse(bp);
    80003e92:	854a                	mv	a0,s2
    80003e94:	00000097          	auipc	ra,0x0
    80003e98:	9fa080e7          	jalr	-1542(ra) # 8000388e <brelse>
      return iget(dev, inum);
    80003e9c:	85da                	mv	a1,s6
    80003e9e:	8556                	mv	a0,s5
    80003ea0:	00000097          	auipc	ra,0x0
    80003ea4:	d9c080e7          	jalr	-612(ra) # 80003c3c <iget>
    80003ea8:	bf5d                	j	80003e5e <ialloc+0x86>

0000000080003eaa <iupdate>:
{
    80003eaa:	1101                	addi	sp,sp,-32
    80003eac:	ec06                	sd	ra,24(sp)
    80003eae:	e822                	sd	s0,16(sp)
    80003eb0:	e426                	sd	s1,8(sp)
    80003eb2:	e04a                	sd	s2,0(sp)
    80003eb4:	1000                	addi	s0,sp,32
    80003eb6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003eb8:	415c                	lw	a5,4(a0)
    80003eba:	0047d79b          	srliw	a5,a5,0x4
    80003ebe:	00063597          	auipc	a1,0x63
    80003ec2:	4525a583          	lw	a1,1106(a1) # 80067310 <sb+0x18>
    80003ec6:	9dbd                	addw	a1,a1,a5
    80003ec8:	4108                	lw	a0,0(a0)
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	894080e7          	jalr	-1900(ra) # 8000375e <bread>
    80003ed2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ed4:	05850793          	addi	a5,a0,88
    80003ed8:	40d8                	lw	a4,4(s1)
    80003eda:	8b3d                	andi	a4,a4,15
    80003edc:	071a                	slli	a4,a4,0x6
    80003ede:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003ee0:	04449703          	lh	a4,68(s1)
    80003ee4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003ee8:	04649703          	lh	a4,70(s1)
    80003eec:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003ef0:	04849703          	lh	a4,72(s1)
    80003ef4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003ef8:	04a49703          	lh	a4,74(s1)
    80003efc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003f00:	44f8                	lw	a4,76(s1)
    80003f02:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003f04:	03400613          	li	a2,52
    80003f08:	05048593          	addi	a1,s1,80
    80003f0c:	00c78513          	addi	a0,a5,12
    80003f10:	ffffd097          	auipc	ra,0xffffd
    80003f14:	ef4080e7          	jalr	-268(ra) # 80000e04 <memmove>
  log_write(bp);
    80003f18:	854a                	mv	a0,s2
    80003f1a:	00001097          	auipc	ra,0x1
    80003f1e:	bfe080e7          	jalr	-1026(ra) # 80004b18 <log_write>
  brelse(bp);
    80003f22:	854a                	mv	a0,s2
    80003f24:	00000097          	auipc	ra,0x0
    80003f28:	96a080e7          	jalr	-1686(ra) # 8000388e <brelse>
}
    80003f2c:	60e2                	ld	ra,24(sp)
    80003f2e:	6442                	ld	s0,16(sp)
    80003f30:	64a2                	ld	s1,8(sp)
    80003f32:	6902                	ld	s2,0(sp)
    80003f34:	6105                	addi	sp,sp,32
    80003f36:	8082                	ret

0000000080003f38 <idup>:
{
    80003f38:	1101                	addi	sp,sp,-32
    80003f3a:	ec06                	sd	ra,24(sp)
    80003f3c:	e822                	sd	s0,16(sp)
    80003f3e:	e426                	sd	s1,8(sp)
    80003f40:	1000                	addi	s0,sp,32
    80003f42:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003f44:	00063517          	auipc	a0,0x63
    80003f48:	3d450513          	addi	a0,a0,980 # 80067318 <itable>
    80003f4c:	ffffd097          	auipc	ra,0xffffd
    80003f50:	d60080e7          	jalr	-672(ra) # 80000cac <acquire>
  ip->ref++;
    80003f54:	449c                	lw	a5,8(s1)
    80003f56:	2785                	addiw	a5,a5,1
    80003f58:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003f5a:	00063517          	auipc	a0,0x63
    80003f5e:	3be50513          	addi	a0,a0,958 # 80067318 <itable>
    80003f62:	ffffd097          	auipc	ra,0xffffd
    80003f66:	dfe080e7          	jalr	-514(ra) # 80000d60 <release>
}
    80003f6a:	8526                	mv	a0,s1
    80003f6c:	60e2                	ld	ra,24(sp)
    80003f6e:	6442                	ld	s0,16(sp)
    80003f70:	64a2                	ld	s1,8(sp)
    80003f72:	6105                	addi	sp,sp,32
    80003f74:	8082                	ret

0000000080003f76 <ilock>:
{
    80003f76:	1101                	addi	sp,sp,-32
    80003f78:	ec06                	sd	ra,24(sp)
    80003f7a:	e822                	sd	s0,16(sp)
    80003f7c:	e426                	sd	s1,8(sp)
    80003f7e:	e04a                	sd	s2,0(sp)
    80003f80:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003f82:	c115                	beqz	a0,80003fa6 <ilock+0x30>
    80003f84:	84aa                	mv	s1,a0
    80003f86:	451c                	lw	a5,8(a0)
    80003f88:	00f05f63          	blez	a5,80003fa6 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003f8c:	0541                	addi	a0,a0,16
    80003f8e:	00001097          	auipc	ra,0x1
    80003f92:	ca8080e7          	jalr	-856(ra) # 80004c36 <acquiresleep>
  if(ip->valid == 0){
    80003f96:	40bc                	lw	a5,64(s1)
    80003f98:	cf99                	beqz	a5,80003fb6 <ilock+0x40>
}
    80003f9a:	60e2                	ld	ra,24(sp)
    80003f9c:	6442                	ld	s0,16(sp)
    80003f9e:	64a2                	ld	s1,8(sp)
    80003fa0:	6902                	ld	s2,0(sp)
    80003fa2:	6105                	addi	sp,sp,32
    80003fa4:	8082                	ret
    panic("ilock");
    80003fa6:	00004517          	auipc	a0,0x4
    80003faa:	6ca50513          	addi	a0,a0,1738 # 80008670 <syscalls+0x1a0>
    80003fae:	ffffc097          	auipc	ra,0xffffc
    80003fb2:	592080e7          	jalr	1426(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003fb6:	40dc                	lw	a5,4(s1)
    80003fb8:	0047d79b          	srliw	a5,a5,0x4
    80003fbc:	00063597          	auipc	a1,0x63
    80003fc0:	3545a583          	lw	a1,852(a1) # 80067310 <sb+0x18>
    80003fc4:	9dbd                	addw	a1,a1,a5
    80003fc6:	4088                	lw	a0,0(s1)
    80003fc8:	fffff097          	auipc	ra,0xfffff
    80003fcc:	796080e7          	jalr	1942(ra) # 8000375e <bread>
    80003fd0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003fd2:	05850593          	addi	a1,a0,88
    80003fd6:	40dc                	lw	a5,4(s1)
    80003fd8:	8bbd                	andi	a5,a5,15
    80003fda:	079a                	slli	a5,a5,0x6
    80003fdc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003fde:	00059783          	lh	a5,0(a1)
    80003fe2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003fe6:	00259783          	lh	a5,2(a1)
    80003fea:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003fee:	00459783          	lh	a5,4(a1)
    80003ff2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003ff6:	00659783          	lh	a5,6(a1)
    80003ffa:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003ffe:	459c                	lw	a5,8(a1)
    80004000:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004002:	03400613          	li	a2,52
    80004006:	05b1                	addi	a1,a1,12
    80004008:	05048513          	addi	a0,s1,80
    8000400c:	ffffd097          	auipc	ra,0xffffd
    80004010:	df8080e7          	jalr	-520(ra) # 80000e04 <memmove>
    brelse(bp);
    80004014:	854a                	mv	a0,s2
    80004016:	00000097          	auipc	ra,0x0
    8000401a:	878080e7          	jalr	-1928(ra) # 8000388e <brelse>
    ip->valid = 1;
    8000401e:	4785                	li	a5,1
    80004020:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80004022:	04449783          	lh	a5,68(s1)
    80004026:	fbb5                	bnez	a5,80003f9a <ilock+0x24>
      panic("ilock: no type");
    80004028:	00004517          	auipc	a0,0x4
    8000402c:	65050513          	addi	a0,a0,1616 # 80008678 <syscalls+0x1a8>
    80004030:	ffffc097          	auipc	ra,0xffffc
    80004034:	510080e7          	jalr	1296(ra) # 80000540 <panic>

0000000080004038 <iunlock>:
{
    80004038:	1101                	addi	sp,sp,-32
    8000403a:	ec06                	sd	ra,24(sp)
    8000403c:	e822                	sd	s0,16(sp)
    8000403e:	e426                	sd	s1,8(sp)
    80004040:	e04a                	sd	s2,0(sp)
    80004042:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004044:	c905                	beqz	a0,80004074 <iunlock+0x3c>
    80004046:	84aa                	mv	s1,a0
    80004048:	01050913          	addi	s2,a0,16
    8000404c:	854a                	mv	a0,s2
    8000404e:	00001097          	auipc	ra,0x1
    80004052:	c82080e7          	jalr	-894(ra) # 80004cd0 <holdingsleep>
    80004056:	cd19                	beqz	a0,80004074 <iunlock+0x3c>
    80004058:	449c                	lw	a5,8(s1)
    8000405a:	00f05d63          	blez	a5,80004074 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000405e:	854a                	mv	a0,s2
    80004060:	00001097          	auipc	ra,0x1
    80004064:	c2c080e7          	jalr	-980(ra) # 80004c8c <releasesleep>
}
    80004068:	60e2                	ld	ra,24(sp)
    8000406a:	6442                	ld	s0,16(sp)
    8000406c:	64a2                	ld	s1,8(sp)
    8000406e:	6902                	ld	s2,0(sp)
    80004070:	6105                	addi	sp,sp,32
    80004072:	8082                	ret
    panic("iunlock");
    80004074:	00004517          	auipc	a0,0x4
    80004078:	61450513          	addi	a0,a0,1556 # 80008688 <syscalls+0x1b8>
    8000407c:	ffffc097          	auipc	ra,0xffffc
    80004080:	4c4080e7          	jalr	1220(ra) # 80000540 <panic>

0000000080004084 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004084:	7179                	addi	sp,sp,-48
    80004086:	f406                	sd	ra,40(sp)
    80004088:	f022                	sd	s0,32(sp)
    8000408a:	ec26                	sd	s1,24(sp)
    8000408c:	e84a                	sd	s2,16(sp)
    8000408e:	e44e                	sd	s3,8(sp)
    80004090:	e052                	sd	s4,0(sp)
    80004092:	1800                	addi	s0,sp,48
    80004094:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004096:	05050493          	addi	s1,a0,80
    8000409a:	08050913          	addi	s2,a0,128
    8000409e:	a021                	j	800040a6 <itrunc+0x22>
    800040a0:	0491                	addi	s1,s1,4
    800040a2:	01248d63          	beq	s1,s2,800040bc <itrunc+0x38>
    if(ip->addrs[i]){
    800040a6:	408c                	lw	a1,0(s1)
    800040a8:	dde5                	beqz	a1,800040a0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800040aa:	0009a503          	lw	a0,0(s3)
    800040ae:	00000097          	auipc	ra,0x0
    800040b2:	8f6080e7          	jalr	-1802(ra) # 800039a4 <bfree>
      ip->addrs[i] = 0;
    800040b6:	0004a023          	sw	zero,0(s1)
    800040ba:	b7dd                	j	800040a0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800040bc:	0809a583          	lw	a1,128(s3)
    800040c0:	e185                	bnez	a1,800040e0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800040c2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800040c6:	854e                	mv	a0,s3
    800040c8:	00000097          	auipc	ra,0x0
    800040cc:	de2080e7          	jalr	-542(ra) # 80003eaa <iupdate>
}
    800040d0:	70a2                	ld	ra,40(sp)
    800040d2:	7402                	ld	s0,32(sp)
    800040d4:	64e2                	ld	s1,24(sp)
    800040d6:	6942                	ld	s2,16(sp)
    800040d8:	69a2                	ld	s3,8(sp)
    800040da:	6a02                	ld	s4,0(sp)
    800040dc:	6145                	addi	sp,sp,48
    800040de:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800040e0:	0009a503          	lw	a0,0(s3)
    800040e4:	fffff097          	auipc	ra,0xfffff
    800040e8:	67a080e7          	jalr	1658(ra) # 8000375e <bread>
    800040ec:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800040ee:	05850493          	addi	s1,a0,88
    800040f2:	45850913          	addi	s2,a0,1112
    800040f6:	a021                	j	800040fe <itrunc+0x7a>
    800040f8:	0491                	addi	s1,s1,4
    800040fa:	01248b63          	beq	s1,s2,80004110 <itrunc+0x8c>
      if(a[j])
    800040fe:	408c                	lw	a1,0(s1)
    80004100:	dde5                	beqz	a1,800040f8 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80004102:	0009a503          	lw	a0,0(s3)
    80004106:	00000097          	auipc	ra,0x0
    8000410a:	89e080e7          	jalr	-1890(ra) # 800039a4 <bfree>
    8000410e:	b7ed                	j	800040f8 <itrunc+0x74>
    brelse(bp);
    80004110:	8552                	mv	a0,s4
    80004112:	fffff097          	auipc	ra,0xfffff
    80004116:	77c080e7          	jalr	1916(ra) # 8000388e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000411a:	0809a583          	lw	a1,128(s3)
    8000411e:	0009a503          	lw	a0,0(s3)
    80004122:	00000097          	auipc	ra,0x0
    80004126:	882080e7          	jalr	-1918(ra) # 800039a4 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000412a:	0809a023          	sw	zero,128(s3)
    8000412e:	bf51                	j	800040c2 <itrunc+0x3e>

0000000080004130 <iput>:
{
    80004130:	1101                	addi	sp,sp,-32
    80004132:	ec06                	sd	ra,24(sp)
    80004134:	e822                	sd	s0,16(sp)
    80004136:	e426                	sd	s1,8(sp)
    80004138:	e04a                	sd	s2,0(sp)
    8000413a:	1000                	addi	s0,sp,32
    8000413c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000413e:	00063517          	auipc	a0,0x63
    80004142:	1da50513          	addi	a0,a0,474 # 80067318 <itable>
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	b66080e7          	jalr	-1178(ra) # 80000cac <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000414e:	4498                	lw	a4,8(s1)
    80004150:	4785                	li	a5,1
    80004152:	02f70363          	beq	a4,a5,80004178 <iput+0x48>
  ip->ref--;
    80004156:	449c                	lw	a5,8(s1)
    80004158:	37fd                	addiw	a5,a5,-1
    8000415a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000415c:	00063517          	auipc	a0,0x63
    80004160:	1bc50513          	addi	a0,a0,444 # 80067318 <itable>
    80004164:	ffffd097          	auipc	ra,0xffffd
    80004168:	bfc080e7          	jalr	-1028(ra) # 80000d60 <release>
}
    8000416c:	60e2                	ld	ra,24(sp)
    8000416e:	6442                	ld	s0,16(sp)
    80004170:	64a2                	ld	s1,8(sp)
    80004172:	6902                	ld	s2,0(sp)
    80004174:	6105                	addi	sp,sp,32
    80004176:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004178:	40bc                	lw	a5,64(s1)
    8000417a:	dff1                	beqz	a5,80004156 <iput+0x26>
    8000417c:	04a49783          	lh	a5,74(s1)
    80004180:	fbf9                	bnez	a5,80004156 <iput+0x26>
    acquiresleep(&ip->lock);
    80004182:	01048913          	addi	s2,s1,16
    80004186:	854a                	mv	a0,s2
    80004188:	00001097          	auipc	ra,0x1
    8000418c:	aae080e7          	jalr	-1362(ra) # 80004c36 <acquiresleep>
    release(&itable.lock);
    80004190:	00063517          	auipc	a0,0x63
    80004194:	18850513          	addi	a0,a0,392 # 80067318 <itable>
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	bc8080e7          	jalr	-1080(ra) # 80000d60 <release>
    itrunc(ip);
    800041a0:	8526                	mv	a0,s1
    800041a2:	00000097          	auipc	ra,0x0
    800041a6:	ee2080e7          	jalr	-286(ra) # 80004084 <itrunc>
    ip->type = 0;
    800041aa:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800041ae:	8526                	mv	a0,s1
    800041b0:	00000097          	auipc	ra,0x0
    800041b4:	cfa080e7          	jalr	-774(ra) # 80003eaa <iupdate>
    ip->valid = 0;
    800041b8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800041bc:	854a                	mv	a0,s2
    800041be:	00001097          	auipc	ra,0x1
    800041c2:	ace080e7          	jalr	-1330(ra) # 80004c8c <releasesleep>
    acquire(&itable.lock);
    800041c6:	00063517          	auipc	a0,0x63
    800041ca:	15250513          	addi	a0,a0,338 # 80067318 <itable>
    800041ce:	ffffd097          	auipc	ra,0xffffd
    800041d2:	ade080e7          	jalr	-1314(ra) # 80000cac <acquire>
    800041d6:	b741                	j	80004156 <iput+0x26>

00000000800041d8 <iunlockput>:
{
    800041d8:	1101                	addi	sp,sp,-32
    800041da:	ec06                	sd	ra,24(sp)
    800041dc:	e822                	sd	s0,16(sp)
    800041de:	e426                	sd	s1,8(sp)
    800041e0:	1000                	addi	s0,sp,32
    800041e2:	84aa                	mv	s1,a0
  iunlock(ip);
    800041e4:	00000097          	auipc	ra,0x0
    800041e8:	e54080e7          	jalr	-428(ra) # 80004038 <iunlock>
  iput(ip);
    800041ec:	8526                	mv	a0,s1
    800041ee:	00000097          	auipc	ra,0x0
    800041f2:	f42080e7          	jalr	-190(ra) # 80004130 <iput>
}
    800041f6:	60e2                	ld	ra,24(sp)
    800041f8:	6442                	ld	s0,16(sp)
    800041fa:	64a2                	ld	s1,8(sp)
    800041fc:	6105                	addi	sp,sp,32
    800041fe:	8082                	ret

0000000080004200 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004200:	1141                	addi	sp,sp,-16
    80004202:	e422                	sd	s0,8(sp)
    80004204:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004206:	411c                	lw	a5,0(a0)
    80004208:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000420a:	415c                	lw	a5,4(a0)
    8000420c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000420e:	04451783          	lh	a5,68(a0)
    80004212:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004216:	04a51783          	lh	a5,74(a0)
    8000421a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000421e:	04c56783          	lwu	a5,76(a0)
    80004222:	e99c                	sd	a5,16(a1)
}
    80004224:	6422                	ld	s0,8(sp)
    80004226:	0141                	addi	sp,sp,16
    80004228:	8082                	ret

000000008000422a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000422a:	457c                	lw	a5,76(a0)
    8000422c:	0ed7e963          	bltu	a5,a3,8000431e <readi+0xf4>
{
    80004230:	7159                	addi	sp,sp,-112
    80004232:	f486                	sd	ra,104(sp)
    80004234:	f0a2                	sd	s0,96(sp)
    80004236:	eca6                	sd	s1,88(sp)
    80004238:	e8ca                	sd	s2,80(sp)
    8000423a:	e4ce                	sd	s3,72(sp)
    8000423c:	e0d2                	sd	s4,64(sp)
    8000423e:	fc56                	sd	s5,56(sp)
    80004240:	f85a                	sd	s6,48(sp)
    80004242:	f45e                	sd	s7,40(sp)
    80004244:	f062                	sd	s8,32(sp)
    80004246:	ec66                	sd	s9,24(sp)
    80004248:	e86a                	sd	s10,16(sp)
    8000424a:	e46e                	sd	s11,8(sp)
    8000424c:	1880                	addi	s0,sp,112
    8000424e:	8b2a                	mv	s6,a0
    80004250:	8bae                	mv	s7,a1
    80004252:	8a32                	mv	s4,a2
    80004254:	84b6                	mv	s1,a3
    80004256:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004258:	9f35                	addw	a4,a4,a3
    return 0;
    8000425a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000425c:	0ad76063          	bltu	a4,a3,800042fc <readi+0xd2>
  if(off + n > ip->size)
    80004260:	00e7f463          	bgeu	a5,a4,80004268 <readi+0x3e>
    n = ip->size - off;
    80004264:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004268:	0a0a8963          	beqz	s5,8000431a <readi+0xf0>
    8000426c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000426e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004272:	5c7d                	li	s8,-1
    80004274:	a82d                	j	800042ae <readi+0x84>
    80004276:	020d1d93          	slli	s11,s10,0x20
    8000427a:	020ddd93          	srli	s11,s11,0x20
    8000427e:	05890613          	addi	a2,s2,88
    80004282:	86ee                	mv	a3,s11
    80004284:	963a                	add	a2,a2,a4
    80004286:	85d2                	mv	a1,s4
    80004288:	855e                	mv	a0,s7
    8000428a:	fffff097          	auipc	ra,0xfffff
    8000428e:	a08080e7          	jalr	-1528(ra) # 80002c92 <either_copyout>
    80004292:	05850d63          	beq	a0,s8,800042ec <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004296:	854a                	mv	a0,s2
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	5f6080e7          	jalr	1526(ra) # 8000388e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800042a0:	013d09bb          	addw	s3,s10,s3
    800042a4:	009d04bb          	addw	s1,s10,s1
    800042a8:	9a6e                	add	s4,s4,s11
    800042aa:	0559f763          	bgeu	s3,s5,800042f8 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800042ae:	00a4d59b          	srliw	a1,s1,0xa
    800042b2:	855a                	mv	a0,s6
    800042b4:	00000097          	auipc	ra,0x0
    800042b8:	89e080e7          	jalr	-1890(ra) # 80003b52 <bmap>
    800042bc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800042c0:	cd85                	beqz	a1,800042f8 <readi+0xce>
    bp = bread(ip->dev, addr);
    800042c2:	000b2503          	lw	a0,0(s6)
    800042c6:	fffff097          	auipc	ra,0xfffff
    800042ca:	498080e7          	jalr	1176(ra) # 8000375e <bread>
    800042ce:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800042d0:	3ff4f713          	andi	a4,s1,1023
    800042d4:	40ec87bb          	subw	a5,s9,a4
    800042d8:	413a86bb          	subw	a3,s5,s3
    800042dc:	8d3e                	mv	s10,a5
    800042de:	2781                	sext.w	a5,a5
    800042e0:	0006861b          	sext.w	a2,a3
    800042e4:	f8f679e3          	bgeu	a2,a5,80004276 <readi+0x4c>
    800042e8:	8d36                	mv	s10,a3
    800042ea:	b771                	j	80004276 <readi+0x4c>
      brelse(bp);
    800042ec:	854a                	mv	a0,s2
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	5a0080e7          	jalr	1440(ra) # 8000388e <brelse>
      tot = -1;
    800042f6:	59fd                	li	s3,-1
  }
  return tot;
    800042f8:	0009851b          	sext.w	a0,s3
}
    800042fc:	70a6                	ld	ra,104(sp)
    800042fe:	7406                	ld	s0,96(sp)
    80004300:	64e6                	ld	s1,88(sp)
    80004302:	6946                	ld	s2,80(sp)
    80004304:	69a6                	ld	s3,72(sp)
    80004306:	6a06                	ld	s4,64(sp)
    80004308:	7ae2                	ld	s5,56(sp)
    8000430a:	7b42                	ld	s6,48(sp)
    8000430c:	7ba2                	ld	s7,40(sp)
    8000430e:	7c02                	ld	s8,32(sp)
    80004310:	6ce2                	ld	s9,24(sp)
    80004312:	6d42                	ld	s10,16(sp)
    80004314:	6da2                	ld	s11,8(sp)
    80004316:	6165                	addi	sp,sp,112
    80004318:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000431a:	89d6                	mv	s3,s5
    8000431c:	bff1                	j	800042f8 <readi+0xce>
    return 0;
    8000431e:	4501                	li	a0,0
}
    80004320:	8082                	ret

0000000080004322 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004322:	457c                	lw	a5,76(a0)
    80004324:	10d7e863          	bltu	a5,a3,80004434 <writei+0x112>
{
    80004328:	7159                	addi	sp,sp,-112
    8000432a:	f486                	sd	ra,104(sp)
    8000432c:	f0a2                	sd	s0,96(sp)
    8000432e:	eca6                	sd	s1,88(sp)
    80004330:	e8ca                	sd	s2,80(sp)
    80004332:	e4ce                	sd	s3,72(sp)
    80004334:	e0d2                	sd	s4,64(sp)
    80004336:	fc56                	sd	s5,56(sp)
    80004338:	f85a                	sd	s6,48(sp)
    8000433a:	f45e                	sd	s7,40(sp)
    8000433c:	f062                	sd	s8,32(sp)
    8000433e:	ec66                	sd	s9,24(sp)
    80004340:	e86a                	sd	s10,16(sp)
    80004342:	e46e                	sd	s11,8(sp)
    80004344:	1880                	addi	s0,sp,112
    80004346:	8aaa                	mv	s5,a0
    80004348:	8bae                	mv	s7,a1
    8000434a:	8a32                	mv	s4,a2
    8000434c:	8936                	mv	s2,a3
    8000434e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004350:	00e687bb          	addw	a5,a3,a4
    80004354:	0ed7e263          	bltu	a5,a3,80004438 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004358:	00043737          	lui	a4,0x43
    8000435c:	0ef76063          	bltu	a4,a5,8000443c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004360:	0c0b0863          	beqz	s6,80004430 <writei+0x10e>
    80004364:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004366:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000436a:	5c7d                	li	s8,-1
    8000436c:	a091                	j	800043b0 <writei+0x8e>
    8000436e:	020d1d93          	slli	s11,s10,0x20
    80004372:	020ddd93          	srli	s11,s11,0x20
    80004376:	05848513          	addi	a0,s1,88
    8000437a:	86ee                	mv	a3,s11
    8000437c:	8652                	mv	a2,s4
    8000437e:	85de                	mv	a1,s7
    80004380:	953a                	add	a0,a0,a4
    80004382:	fffff097          	auipc	ra,0xfffff
    80004386:	966080e7          	jalr	-1690(ra) # 80002ce8 <either_copyin>
    8000438a:	07850263          	beq	a0,s8,800043ee <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000438e:	8526                	mv	a0,s1
    80004390:	00000097          	auipc	ra,0x0
    80004394:	788080e7          	jalr	1928(ra) # 80004b18 <log_write>
    brelse(bp);
    80004398:	8526                	mv	a0,s1
    8000439a:	fffff097          	auipc	ra,0xfffff
    8000439e:	4f4080e7          	jalr	1268(ra) # 8000388e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800043a2:	013d09bb          	addw	s3,s10,s3
    800043a6:	012d093b          	addw	s2,s10,s2
    800043aa:	9a6e                	add	s4,s4,s11
    800043ac:	0569f663          	bgeu	s3,s6,800043f8 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800043b0:	00a9559b          	srliw	a1,s2,0xa
    800043b4:	8556                	mv	a0,s5
    800043b6:	fffff097          	auipc	ra,0xfffff
    800043ba:	79c080e7          	jalr	1948(ra) # 80003b52 <bmap>
    800043be:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800043c2:	c99d                	beqz	a1,800043f8 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800043c4:	000aa503          	lw	a0,0(s5)
    800043c8:	fffff097          	auipc	ra,0xfffff
    800043cc:	396080e7          	jalr	918(ra) # 8000375e <bread>
    800043d0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800043d2:	3ff97713          	andi	a4,s2,1023
    800043d6:	40ec87bb          	subw	a5,s9,a4
    800043da:	413b06bb          	subw	a3,s6,s3
    800043de:	8d3e                	mv	s10,a5
    800043e0:	2781                	sext.w	a5,a5
    800043e2:	0006861b          	sext.w	a2,a3
    800043e6:	f8f674e3          	bgeu	a2,a5,8000436e <writei+0x4c>
    800043ea:	8d36                	mv	s10,a3
    800043ec:	b749                	j	8000436e <writei+0x4c>
      brelse(bp);
    800043ee:	8526                	mv	a0,s1
    800043f0:	fffff097          	auipc	ra,0xfffff
    800043f4:	49e080e7          	jalr	1182(ra) # 8000388e <brelse>
  }

  if(off > ip->size)
    800043f8:	04caa783          	lw	a5,76(s5)
    800043fc:	0127f463          	bgeu	a5,s2,80004404 <writei+0xe2>
    ip->size = off;
    80004400:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004404:	8556                	mv	a0,s5
    80004406:	00000097          	auipc	ra,0x0
    8000440a:	aa4080e7          	jalr	-1372(ra) # 80003eaa <iupdate>

  return tot;
    8000440e:	0009851b          	sext.w	a0,s3
}
    80004412:	70a6                	ld	ra,104(sp)
    80004414:	7406                	ld	s0,96(sp)
    80004416:	64e6                	ld	s1,88(sp)
    80004418:	6946                	ld	s2,80(sp)
    8000441a:	69a6                	ld	s3,72(sp)
    8000441c:	6a06                	ld	s4,64(sp)
    8000441e:	7ae2                	ld	s5,56(sp)
    80004420:	7b42                	ld	s6,48(sp)
    80004422:	7ba2                	ld	s7,40(sp)
    80004424:	7c02                	ld	s8,32(sp)
    80004426:	6ce2                	ld	s9,24(sp)
    80004428:	6d42                	ld	s10,16(sp)
    8000442a:	6da2                	ld	s11,8(sp)
    8000442c:	6165                	addi	sp,sp,112
    8000442e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004430:	89da                	mv	s3,s6
    80004432:	bfc9                	j	80004404 <writei+0xe2>
    return -1;
    80004434:	557d                	li	a0,-1
}
    80004436:	8082                	ret
    return -1;
    80004438:	557d                	li	a0,-1
    8000443a:	bfe1                	j	80004412 <writei+0xf0>
    return -1;
    8000443c:	557d                	li	a0,-1
    8000443e:	bfd1                	j	80004412 <writei+0xf0>

0000000080004440 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004440:	1141                	addi	sp,sp,-16
    80004442:	e406                	sd	ra,8(sp)
    80004444:	e022                	sd	s0,0(sp)
    80004446:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004448:	4639                	li	a2,14
    8000444a:	ffffd097          	auipc	ra,0xffffd
    8000444e:	a2e080e7          	jalr	-1490(ra) # 80000e78 <strncmp>
}
    80004452:	60a2                	ld	ra,8(sp)
    80004454:	6402                	ld	s0,0(sp)
    80004456:	0141                	addi	sp,sp,16
    80004458:	8082                	ret

000000008000445a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000445a:	7139                	addi	sp,sp,-64
    8000445c:	fc06                	sd	ra,56(sp)
    8000445e:	f822                	sd	s0,48(sp)
    80004460:	f426                	sd	s1,40(sp)
    80004462:	f04a                	sd	s2,32(sp)
    80004464:	ec4e                	sd	s3,24(sp)
    80004466:	e852                	sd	s4,16(sp)
    80004468:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000446a:	04451703          	lh	a4,68(a0)
    8000446e:	4785                	li	a5,1
    80004470:	00f71a63          	bne	a4,a5,80004484 <dirlookup+0x2a>
    80004474:	892a                	mv	s2,a0
    80004476:	89ae                	mv	s3,a1
    80004478:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000447a:	457c                	lw	a5,76(a0)
    8000447c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000447e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004480:	e79d                	bnez	a5,800044ae <dirlookup+0x54>
    80004482:	a8a5                	j	800044fa <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004484:	00004517          	auipc	a0,0x4
    80004488:	20c50513          	addi	a0,a0,524 # 80008690 <syscalls+0x1c0>
    8000448c:	ffffc097          	auipc	ra,0xffffc
    80004490:	0b4080e7          	jalr	180(ra) # 80000540 <panic>
      panic("dirlookup read");
    80004494:	00004517          	auipc	a0,0x4
    80004498:	21450513          	addi	a0,a0,532 # 800086a8 <syscalls+0x1d8>
    8000449c:	ffffc097          	auipc	ra,0xffffc
    800044a0:	0a4080e7          	jalr	164(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044a4:	24c1                	addiw	s1,s1,16
    800044a6:	04c92783          	lw	a5,76(s2)
    800044aa:	04f4f763          	bgeu	s1,a5,800044f8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044ae:	4741                	li	a4,16
    800044b0:	86a6                	mv	a3,s1
    800044b2:	fc040613          	addi	a2,s0,-64
    800044b6:	4581                	li	a1,0
    800044b8:	854a                	mv	a0,s2
    800044ba:	00000097          	auipc	ra,0x0
    800044be:	d70080e7          	jalr	-656(ra) # 8000422a <readi>
    800044c2:	47c1                	li	a5,16
    800044c4:	fcf518e3          	bne	a0,a5,80004494 <dirlookup+0x3a>
    if(de.inum == 0)
    800044c8:	fc045783          	lhu	a5,-64(s0)
    800044cc:	dfe1                	beqz	a5,800044a4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800044ce:	fc240593          	addi	a1,s0,-62
    800044d2:	854e                	mv	a0,s3
    800044d4:	00000097          	auipc	ra,0x0
    800044d8:	f6c080e7          	jalr	-148(ra) # 80004440 <namecmp>
    800044dc:	f561                	bnez	a0,800044a4 <dirlookup+0x4a>
      if(poff)
    800044de:	000a0463          	beqz	s4,800044e6 <dirlookup+0x8c>
        *poff = off;
    800044e2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800044e6:	fc045583          	lhu	a1,-64(s0)
    800044ea:	00092503          	lw	a0,0(s2)
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	74e080e7          	jalr	1870(ra) # 80003c3c <iget>
    800044f6:	a011                	j	800044fa <dirlookup+0xa0>
  return 0;
    800044f8:	4501                	li	a0,0
}
    800044fa:	70e2                	ld	ra,56(sp)
    800044fc:	7442                	ld	s0,48(sp)
    800044fe:	74a2                	ld	s1,40(sp)
    80004500:	7902                	ld	s2,32(sp)
    80004502:	69e2                	ld	s3,24(sp)
    80004504:	6a42                	ld	s4,16(sp)
    80004506:	6121                	addi	sp,sp,64
    80004508:	8082                	ret

000000008000450a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000450a:	711d                	addi	sp,sp,-96
    8000450c:	ec86                	sd	ra,88(sp)
    8000450e:	e8a2                	sd	s0,80(sp)
    80004510:	e4a6                	sd	s1,72(sp)
    80004512:	e0ca                	sd	s2,64(sp)
    80004514:	fc4e                	sd	s3,56(sp)
    80004516:	f852                	sd	s4,48(sp)
    80004518:	f456                	sd	s5,40(sp)
    8000451a:	f05a                	sd	s6,32(sp)
    8000451c:	ec5e                	sd	s7,24(sp)
    8000451e:	e862                	sd	s8,16(sp)
    80004520:	e466                	sd	s9,8(sp)
    80004522:	e06a                	sd	s10,0(sp)
    80004524:	1080                	addi	s0,sp,96
    80004526:	84aa                	mv	s1,a0
    80004528:	8b2e                	mv	s6,a1
    8000452a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000452c:	00054703          	lbu	a4,0(a0)
    80004530:	02f00793          	li	a5,47
    80004534:	02f70363          	beq	a4,a5,8000455a <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004538:	ffffd097          	auipc	ra,0xffffd
    8000453c:	7d0080e7          	jalr	2000(ra) # 80001d08 <myproc>
    80004540:	15053503          	ld	a0,336(a0)
    80004544:	00000097          	auipc	ra,0x0
    80004548:	9f4080e7          	jalr	-1548(ra) # 80003f38 <idup>
    8000454c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000454e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004552:	4cb5                	li	s9,13
  len = path - s;
    80004554:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004556:	4c05                	li	s8,1
    80004558:	a87d                	j	80004616 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000455a:	4585                	li	a1,1
    8000455c:	4505                	li	a0,1
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	6de080e7          	jalr	1758(ra) # 80003c3c <iget>
    80004566:	8a2a                	mv	s4,a0
    80004568:	b7dd                	j	8000454e <namex+0x44>
      iunlockput(ip);
    8000456a:	8552                	mv	a0,s4
    8000456c:	00000097          	auipc	ra,0x0
    80004570:	c6c080e7          	jalr	-916(ra) # 800041d8 <iunlockput>
      return 0;
    80004574:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004576:	8552                	mv	a0,s4
    80004578:	60e6                	ld	ra,88(sp)
    8000457a:	6446                	ld	s0,80(sp)
    8000457c:	64a6                	ld	s1,72(sp)
    8000457e:	6906                	ld	s2,64(sp)
    80004580:	79e2                	ld	s3,56(sp)
    80004582:	7a42                	ld	s4,48(sp)
    80004584:	7aa2                	ld	s5,40(sp)
    80004586:	7b02                	ld	s6,32(sp)
    80004588:	6be2                	ld	s7,24(sp)
    8000458a:	6c42                	ld	s8,16(sp)
    8000458c:	6ca2                	ld	s9,8(sp)
    8000458e:	6d02                	ld	s10,0(sp)
    80004590:	6125                	addi	sp,sp,96
    80004592:	8082                	ret
      iunlock(ip);
    80004594:	8552                	mv	a0,s4
    80004596:	00000097          	auipc	ra,0x0
    8000459a:	aa2080e7          	jalr	-1374(ra) # 80004038 <iunlock>
      return ip;
    8000459e:	bfe1                	j	80004576 <namex+0x6c>
      iunlockput(ip);
    800045a0:	8552                	mv	a0,s4
    800045a2:	00000097          	auipc	ra,0x0
    800045a6:	c36080e7          	jalr	-970(ra) # 800041d8 <iunlockput>
      return 0;
    800045aa:	8a4e                	mv	s4,s3
    800045ac:	b7e9                	j	80004576 <namex+0x6c>
  len = path - s;
    800045ae:	40998633          	sub	a2,s3,s1
    800045b2:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800045b6:	09acd863          	bge	s9,s10,80004646 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800045ba:	4639                	li	a2,14
    800045bc:	85a6                	mv	a1,s1
    800045be:	8556                	mv	a0,s5
    800045c0:	ffffd097          	auipc	ra,0xffffd
    800045c4:	844080e7          	jalr	-1980(ra) # 80000e04 <memmove>
    800045c8:	84ce                	mv	s1,s3
  while(*path == '/')
    800045ca:	0004c783          	lbu	a5,0(s1)
    800045ce:	01279763          	bne	a5,s2,800045dc <namex+0xd2>
    path++;
    800045d2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800045d4:	0004c783          	lbu	a5,0(s1)
    800045d8:	ff278de3          	beq	a5,s2,800045d2 <namex+0xc8>
    ilock(ip);
    800045dc:	8552                	mv	a0,s4
    800045de:	00000097          	auipc	ra,0x0
    800045e2:	998080e7          	jalr	-1640(ra) # 80003f76 <ilock>
    if(ip->type != T_DIR){
    800045e6:	044a1783          	lh	a5,68(s4)
    800045ea:	f98790e3          	bne	a5,s8,8000456a <namex+0x60>
    if(nameiparent && *path == '\0'){
    800045ee:	000b0563          	beqz	s6,800045f8 <namex+0xee>
    800045f2:	0004c783          	lbu	a5,0(s1)
    800045f6:	dfd9                	beqz	a5,80004594 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800045f8:	865e                	mv	a2,s7
    800045fa:	85d6                	mv	a1,s5
    800045fc:	8552                	mv	a0,s4
    800045fe:	00000097          	auipc	ra,0x0
    80004602:	e5c080e7          	jalr	-420(ra) # 8000445a <dirlookup>
    80004606:	89aa                	mv	s3,a0
    80004608:	dd41                	beqz	a0,800045a0 <namex+0x96>
    iunlockput(ip);
    8000460a:	8552                	mv	a0,s4
    8000460c:	00000097          	auipc	ra,0x0
    80004610:	bcc080e7          	jalr	-1076(ra) # 800041d8 <iunlockput>
    ip = next;
    80004614:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004616:	0004c783          	lbu	a5,0(s1)
    8000461a:	01279763          	bne	a5,s2,80004628 <namex+0x11e>
    path++;
    8000461e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004620:	0004c783          	lbu	a5,0(s1)
    80004624:	ff278de3          	beq	a5,s2,8000461e <namex+0x114>
  if(*path == 0)
    80004628:	cb9d                	beqz	a5,8000465e <namex+0x154>
  while(*path != '/' && *path != 0)
    8000462a:	0004c783          	lbu	a5,0(s1)
    8000462e:	89a6                	mv	s3,s1
  len = path - s;
    80004630:	8d5e                	mv	s10,s7
    80004632:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80004634:	01278963          	beq	a5,s2,80004646 <namex+0x13c>
    80004638:	dbbd                	beqz	a5,800045ae <namex+0xa4>
    path++;
    8000463a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000463c:	0009c783          	lbu	a5,0(s3)
    80004640:	ff279ce3          	bne	a5,s2,80004638 <namex+0x12e>
    80004644:	b7ad                	j	800045ae <namex+0xa4>
    memmove(name, s, len);
    80004646:	2601                	sext.w	a2,a2
    80004648:	85a6                	mv	a1,s1
    8000464a:	8556                	mv	a0,s5
    8000464c:	ffffc097          	auipc	ra,0xffffc
    80004650:	7b8080e7          	jalr	1976(ra) # 80000e04 <memmove>
    name[len] = 0;
    80004654:	9d56                	add	s10,s10,s5
    80004656:	000d0023          	sb	zero,0(s10)
    8000465a:	84ce                	mv	s1,s3
    8000465c:	b7bd                	j	800045ca <namex+0xc0>
  if(nameiparent){
    8000465e:	f00b0ce3          	beqz	s6,80004576 <namex+0x6c>
    iput(ip);
    80004662:	8552                	mv	a0,s4
    80004664:	00000097          	auipc	ra,0x0
    80004668:	acc080e7          	jalr	-1332(ra) # 80004130 <iput>
    return 0;
    8000466c:	4a01                	li	s4,0
    8000466e:	b721                	j	80004576 <namex+0x6c>

0000000080004670 <dirlink>:
{
    80004670:	7139                	addi	sp,sp,-64
    80004672:	fc06                	sd	ra,56(sp)
    80004674:	f822                	sd	s0,48(sp)
    80004676:	f426                	sd	s1,40(sp)
    80004678:	f04a                	sd	s2,32(sp)
    8000467a:	ec4e                	sd	s3,24(sp)
    8000467c:	e852                	sd	s4,16(sp)
    8000467e:	0080                	addi	s0,sp,64
    80004680:	892a                	mv	s2,a0
    80004682:	8a2e                	mv	s4,a1
    80004684:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004686:	4601                	li	a2,0
    80004688:	00000097          	auipc	ra,0x0
    8000468c:	dd2080e7          	jalr	-558(ra) # 8000445a <dirlookup>
    80004690:	e93d                	bnez	a0,80004706 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004692:	04c92483          	lw	s1,76(s2)
    80004696:	c49d                	beqz	s1,800046c4 <dirlink+0x54>
    80004698:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000469a:	4741                	li	a4,16
    8000469c:	86a6                	mv	a3,s1
    8000469e:	fc040613          	addi	a2,s0,-64
    800046a2:	4581                	li	a1,0
    800046a4:	854a                	mv	a0,s2
    800046a6:	00000097          	auipc	ra,0x0
    800046aa:	b84080e7          	jalr	-1148(ra) # 8000422a <readi>
    800046ae:	47c1                	li	a5,16
    800046b0:	06f51163          	bne	a0,a5,80004712 <dirlink+0xa2>
    if(de.inum == 0)
    800046b4:	fc045783          	lhu	a5,-64(s0)
    800046b8:	c791                	beqz	a5,800046c4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800046ba:	24c1                	addiw	s1,s1,16
    800046bc:	04c92783          	lw	a5,76(s2)
    800046c0:	fcf4ede3          	bltu	s1,a5,8000469a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800046c4:	4639                	li	a2,14
    800046c6:	85d2                	mv	a1,s4
    800046c8:	fc240513          	addi	a0,s0,-62
    800046cc:	ffffc097          	auipc	ra,0xffffc
    800046d0:	7e8080e7          	jalr	2024(ra) # 80000eb4 <strncpy>
  de.inum = inum;
    800046d4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800046d8:	4741                	li	a4,16
    800046da:	86a6                	mv	a3,s1
    800046dc:	fc040613          	addi	a2,s0,-64
    800046e0:	4581                	li	a1,0
    800046e2:	854a                	mv	a0,s2
    800046e4:	00000097          	auipc	ra,0x0
    800046e8:	c3e080e7          	jalr	-962(ra) # 80004322 <writei>
    800046ec:	1541                	addi	a0,a0,-16
    800046ee:	00a03533          	snez	a0,a0
    800046f2:	40a00533          	neg	a0,a0
}
    800046f6:	70e2                	ld	ra,56(sp)
    800046f8:	7442                	ld	s0,48(sp)
    800046fa:	74a2                	ld	s1,40(sp)
    800046fc:	7902                	ld	s2,32(sp)
    800046fe:	69e2                	ld	s3,24(sp)
    80004700:	6a42                	ld	s4,16(sp)
    80004702:	6121                	addi	sp,sp,64
    80004704:	8082                	ret
    iput(ip);
    80004706:	00000097          	auipc	ra,0x0
    8000470a:	a2a080e7          	jalr	-1494(ra) # 80004130 <iput>
    return -1;
    8000470e:	557d                	li	a0,-1
    80004710:	b7dd                	j	800046f6 <dirlink+0x86>
      panic("dirlink read");
    80004712:	00004517          	auipc	a0,0x4
    80004716:	fa650513          	addi	a0,a0,-90 # 800086b8 <syscalls+0x1e8>
    8000471a:	ffffc097          	auipc	ra,0xffffc
    8000471e:	e26080e7          	jalr	-474(ra) # 80000540 <panic>

0000000080004722 <namei>:

struct inode*
namei(char *path)
{
    80004722:	1101                	addi	sp,sp,-32
    80004724:	ec06                	sd	ra,24(sp)
    80004726:	e822                	sd	s0,16(sp)
    80004728:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000472a:	fe040613          	addi	a2,s0,-32
    8000472e:	4581                	li	a1,0
    80004730:	00000097          	auipc	ra,0x0
    80004734:	dda080e7          	jalr	-550(ra) # 8000450a <namex>
}
    80004738:	60e2                	ld	ra,24(sp)
    8000473a:	6442                	ld	s0,16(sp)
    8000473c:	6105                	addi	sp,sp,32
    8000473e:	8082                	ret

0000000080004740 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004740:	1141                	addi	sp,sp,-16
    80004742:	e406                	sd	ra,8(sp)
    80004744:	e022                	sd	s0,0(sp)
    80004746:	0800                	addi	s0,sp,16
    80004748:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000474a:	4585                	li	a1,1
    8000474c:	00000097          	auipc	ra,0x0
    80004750:	dbe080e7          	jalr	-578(ra) # 8000450a <namex>
}
    80004754:	60a2                	ld	ra,8(sp)
    80004756:	6402                	ld	s0,0(sp)
    80004758:	0141                	addi	sp,sp,16
    8000475a:	8082                	ret

000000008000475c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000475c:	1101                	addi	sp,sp,-32
    8000475e:	ec06                	sd	ra,24(sp)
    80004760:	e822                	sd	s0,16(sp)
    80004762:	e426                	sd	s1,8(sp)
    80004764:	e04a                	sd	s2,0(sp)
    80004766:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004768:	00064917          	auipc	s2,0x64
    8000476c:	65890913          	addi	s2,s2,1624 # 80068dc0 <log>
    80004770:	01892583          	lw	a1,24(s2)
    80004774:	02892503          	lw	a0,40(s2)
    80004778:	fffff097          	auipc	ra,0xfffff
    8000477c:	fe6080e7          	jalr	-26(ra) # 8000375e <bread>
    80004780:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004782:	02c92683          	lw	a3,44(s2)
    80004786:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004788:	02d05863          	blez	a3,800047b8 <write_head+0x5c>
    8000478c:	00064797          	auipc	a5,0x64
    80004790:	66478793          	addi	a5,a5,1636 # 80068df0 <log+0x30>
    80004794:	05c50713          	addi	a4,a0,92
    80004798:	36fd                	addiw	a3,a3,-1
    8000479a:	02069613          	slli	a2,a3,0x20
    8000479e:	01e65693          	srli	a3,a2,0x1e
    800047a2:	00064617          	auipc	a2,0x64
    800047a6:	65260613          	addi	a2,a2,1618 # 80068df4 <log+0x34>
    800047aa:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800047ac:	4390                	lw	a2,0(a5)
    800047ae:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800047b0:	0791                	addi	a5,a5,4
    800047b2:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800047b4:	fed79ce3          	bne	a5,a3,800047ac <write_head+0x50>
  }
  bwrite(buf);
    800047b8:	8526                	mv	a0,s1
    800047ba:	fffff097          	auipc	ra,0xfffff
    800047be:	096080e7          	jalr	150(ra) # 80003850 <bwrite>
  brelse(buf);
    800047c2:	8526                	mv	a0,s1
    800047c4:	fffff097          	auipc	ra,0xfffff
    800047c8:	0ca080e7          	jalr	202(ra) # 8000388e <brelse>
}
    800047cc:	60e2                	ld	ra,24(sp)
    800047ce:	6442                	ld	s0,16(sp)
    800047d0:	64a2                	ld	s1,8(sp)
    800047d2:	6902                	ld	s2,0(sp)
    800047d4:	6105                	addi	sp,sp,32
    800047d6:	8082                	ret

00000000800047d8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800047d8:	00064797          	auipc	a5,0x64
    800047dc:	6147a783          	lw	a5,1556(a5) # 80068dec <log+0x2c>
    800047e0:	0af05d63          	blez	a5,8000489a <install_trans+0xc2>
{
    800047e4:	7139                	addi	sp,sp,-64
    800047e6:	fc06                	sd	ra,56(sp)
    800047e8:	f822                	sd	s0,48(sp)
    800047ea:	f426                	sd	s1,40(sp)
    800047ec:	f04a                	sd	s2,32(sp)
    800047ee:	ec4e                	sd	s3,24(sp)
    800047f0:	e852                	sd	s4,16(sp)
    800047f2:	e456                	sd	s5,8(sp)
    800047f4:	e05a                	sd	s6,0(sp)
    800047f6:	0080                	addi	s0,sp,64
    800047f8:	8b2a                	mv	s6,a0
    800047fa:	00064a97          	auipc	s5,0x64
    800047fe:	5f6a8a93          	addi	s5,s5,1526 # 80068df0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004802:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004804:	00064997          	auipc	s3,0x64
    80004808:	5bc98993          	addi	s3,s3,1468 # 80068dc0 <log>
    8000480c:	a00d                	j	8000482e <install_trans+0x56>
    brelse(lbuf);
    8000480e:	854a                	mv	a0,s2
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	07e080e7          	jalr	126(ra) # 8000388e <brelse>
    brelse(dbuf);
    80004818:	8526                	mv	a0,s1
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	074080e7          	jalr	116(ra) # 8000388e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004822:	2a05                	addiw	s4,s4,1
    80004824:	0a91                	addi	s5,s5,4
    80004826:	02c9a783          	lw	a5,44(s3)
    8000482a:	04fa5e63          	bge	s4,a5,80004886 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000482e:	0189a583          	lw	a1,24(s3)
    80004832:	014585bb          	addw	a1,a1,s4
    80004836:	2585                	addiw	a1,a1,1
    80004838:	0289a503          	lw	a0,40(s3)
    8000483c:	fffff097          	auipc	ra,0xfffff
    80004840:	f22080e7          	jalr	-222(ra) # 8000375e <bread>
    80004844:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004846:	000aa583          	lw	a1,0(s5)
    8000484a:	0289a503          	lw	a0,40(s3)
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	f10080e7          	jalr	-240(ra) # 8000375e <bread>
    80004856:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004858:	40000613          	li	a2,1024
    8000485c:	05890593          	addi	a1,s2,88
    80004860:	05850513          	addi	a0,a0,88
    80004864:	ffffc097          	auipc	ra,0xffffc
    80004868:	5a0080e7          	jalr	1440(ra) # 80000e04 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000486c:	8526                	mv	a0,s1
    8000486e:	fffff097          	auipc	ra,0xfffff
    80004872:	fe2080e7          	jalr	-30(ra) # 80003850 <bwrite>
    if(recovering == 0)
    80004876:	f80b1ce3          	bnez	s6,8000480e <install_trans+0x36>
      bunpin(dbuf);
    8000487a:	8526                	mv	a0,s1
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	0ec080e7          	jalr	236(ra) # 80003968 <bunpin>
    80004884:	b769                	j	8000480e <install_trans+0x36>
}
    80004886:	70e2                	ld	ra,56(sp)
    80004888:	7442                	ld	s0,48(sp)
    8000488a:	74a2                	ld	s1,40(sp)
    8000488c:	7902                	ld	s2,32(sp)
    8000488e:	69e2                	ld	s3,24(sp)
    80004890:	6a42                	ld	s4,16(sp)
    80004892:	6aa2                	ld	s5,8(sp)
    80004894:	6b02                	ld	s6,0(sp)
    80004896:	6121                	addi	sp,sp,64
    80004898:	8082                	ret
    8000489a:	8082                	ret

000000008000489c <initlog>:
{
    8000489c:	7179                	addi	sp,sp,-48
    8000489e:	f406                	sd	ra,40(sp)
    800048a0:	f022                	sd	s0,32(sp)
    800048a2:	ec26                	sd	s1,24(sp)
    800048a4:	e84a                	sd	s2,16(sp)
    800048a6:	e44e                	sd	s3,8(sp)
    800048a8:	1800                	addi	s0,sp,48
    800048aa:	892a                	mv	s2,a0
    800048ac:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800048ae:	00064497          	auipc	s1,0x64
    800048b2:	51248493          	addi	s1,s1,1298 # 80068dc0 <log>
    800048b6:	00004597          	auipc	a1,0x4
    800048ba:	e1258593          	addi	a1,a1,-494 # 800086c8 <syscalls+0x1f8>
    800048be:	8526                	mv	a0,s1
    800048c0:	ffffc097          	auipc	ra,0xffffc
    800048c4:	35c080e7          	jalr	860(ra) # 80000c1c <initlock>
  log.start = sb->logstart;
    800048c8:	0149a583          	lw	a1,20(s3)
    800048cc:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800048ce:	0109a783          	lw	a5,16(s3)
    800048d2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800048d4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800048d8:	854a                	mv	a0,s2
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	e84080e7          	jalr	-380(ra) # 8000375e <bread>
  log.lh.n = lh->n;
    800048e2:	4d34                	lw	a3,88(a0)
    800048e4:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800048e6:	02d05663          	blez	a3,80004912 <initlog+0x76>
    800048ea:	05c50793          	addi	a5,a0,92
    800048ee:	00064717          	auipc	a4,0x64
    800048f2:	50270713          	addi	a4,a4,1282 # 80068df0 <log+0x30>
    800048f6:	36fd                	addiw	a3,a3,-1
    800048f8:	02069613          	slli	a2,a3,0x20
    800048fc:	01e65693          	srli	a3,a2,0x1e
    80004900:	06050613          	addi	a2,a0,96
    80004904:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004906:	4390                	lw	a2,0(a5)
    80004908:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000490a:	0791                	addi	a5,a5,4
    8000490c:	0711                	addi	a4,a4,4
    8000490e:	fed79ce3          	bne	a5,a3,80004906 <initlog+0x6a>
  brelse(buf);
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	f7c080e7          	jalr	-132(ra) # 8000388e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000491a:	4505                	li	a0,1
    8000491c:	00000097          	auipc	ra,0x0
    80004920:	ebc080e7          	jalr	-324(ra) # 800047d8 <install_trans>
  log.lh.n = 0;
    80004924:	00064797          	auipc	a5,0x64
    80004928:	4c07a423          	sw	zero,1224(a5) # 80068dec <log+0x2c>
  write_head(); // clear the log
    8000492c:	00000097          	auipc	ra,0x0
    80004930:	e30080e7          	jalr	-464(ra) # 8000475c <write_head>
}
    80004934:	70a2                	ld	ra,40(sp)
    80004936:	7402                	ld	s0,32(sp)
    80004938:	64e2                	ld	s1,24(sp)
    8000493a:	6942                	ld	s2,16(sp)
    8000493c:	69a2                	ld	s3,8(sp)
    8000493e:	6145                	addi	sp,sp,48
    80004940:	8082                	ret

0000000080004942 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004942:	1101                	addi	sp,sp,-32
    80004944:	ec06                	sd	ra,24(sp)
    80004946:	e822                	sd	s0,16(sp)
    80004948:	e426                	sd	s1,8(sp)
    8000494a:	e04a                	sd	s2,0(sp)
    8000494c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000494e:	00064517          	auipc	a0,0x64
    80004952:	47250513          	addi	a0,a0,1138 # 80068dc0 <log>
    80004956:	ffffc097          	auipc	ra,0xffffc
    8000495a:	356080e7          	jalr	854(ra) # 80000cac <acquire>
  while(1){
    if(log.committing){
    8000495e:	00064497          	auipc	s1,0x64
    80004962:	46248493          	addi	s1,s1,1122 # 80068dc0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004966:	4979                	li	s2,30
    80004968:	a039                	j	80004976 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000496a:	85a6                	mv	a1,s1
    8000496c:	8526                	mv	a0,s1
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	c46080e7          	jalr	-954(ra) # 800025b4 <sleep>
    if(log.committing){
    80004976:	50dc                	lw	a5,36(s1)
    80004978:	fbed                	bnez	a5,8000496a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000497a:	5098                	lw	a4,32(s1)
    8000497c:	2705                	addiw	a4,a4,1
    8000497e:	0007069b          	sext.w	a3,a4
    80004982:	0027179b          	slliw	a5,a4,0x2
    80004986:	9fb9                	addw	a5,a5,a4
    80004988:	0017979b          	slliw	a5,a5,0x1
    8000498c:	54d8                	lw	a4,44(s1)
    8000498e:	9fb9                	addw	a5,a5,a4
    80004990:	00f95963          	bge	s2,a5,800049a2 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004994:	85a6                	mv	a1,s1
    80004996:	8526                	mv	a0,s1
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	c1c080e7          	jalr	-996(ra) # 800025b4 <sleep>
    800049a0:	bfd9                	j	80004976 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800049a2:	00064517          	auipc	a0,0x64
    800049a6:	41e50513          	addi	a0,a0,1054 # 80068dc0 <log>
    800049aa:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800049ac:	ffffc097          	auipc	ra,0xffffc
    800049b0:	3b4080e7          	jalr	948(ra) # 80000d60 <release>
      break;
    }
  }
}
    800049b4:	60e2                	ld	ra,24(sp)
    800049b6:	6442                	ld	s0,16(sp)
    800049b8:	64a2                	ld	s1,8(sp)
    800049ba:	6902                	ld	s2,0(sp)
    800049bc:	6105                	addi	sp,sp,32
    800049be:	8082                	ret

00000000800049c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800049c0:	7139                	addi	sp,sp,-64
    800049c2:	fc06                	sd	ra,56(sp)
    800049c4:	f822                	sd	s0,48(sp)
    800049c6:	f426                	sd	s1,40(sp)
    800049c8:	f04a                	sd	s2,32(sp)
    800049ca:	ec4e                	sd	s3,24(sp)
    800049cc:	e852                	sd	s4,16(sp)
    800049ce:	e456                	sd	s5,8(sp)
    800049d0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800049d2:	00064497          	auipc	s1,0x64
    800049d6:	3ee48493          	addi	s1,s1,1006 # 80068dc0 <log>
    800049da:	8526                	mv	a0,s1
    800049dc:	ffffc097          	auipc	ra,0xffffc
    800049e0:	2d0080e7          	jalr	720(ra) # 80000cac <acquire>
  log.outstanding -= 1;
    800049e4:	509c                	lw	a5,32(s1)
    800049e6:	37fd                	addiw	a5,a5,-1
    800049e8:	0007891b          	sext.w	s2,a5
    800049ec:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800049ee:	50dc                	lw	a5,36(s1)
    800049f0:	e7b9                	bnez	a5,80004a3e <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800049f2:	04091e63          	bnez	s2,80004a4e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800049f6:	00064497          	auipc	s1,0x64
    800049fa:	3ca48493          	addi	s1,s1,970 # 80068dc0 <log>
    800049fe:	4785                	li	a5,1
    80004a00:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004a02:	8526                	mv	a0,s1
    80004a04:	ffffc097          	auipc	ra,0xffffc
    80004a08:	35c080e7          	jalr	860(ra) # 80000d60 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004a0c:	54dc                	lw	a5,44(s1)
    80004a0e:	06f04763          	bgtz	a5,80004a7c <end_op+0xbc>
    acquire(&log.lock);
    80004a12:	00064497          	auipc	s1,0x64
    80004a16:	3ae48493          	addi	s1,s1,942 # 80068dc0 <log>
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffc097          	auipc	ra,0xffffc
    80004a20:	290080e7          	jalr	656(ra) # 80000cac <acquire>
    log.committing = 0;
    80004a24:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	bee080e7          	jalr	-1042(ra) # 80002618 <wakeup>
    release(&log.lock);
    80004a32:	8526                	mv	a0,s1
    80004a34:	ffffc097          	auipc	ra,0xffffc
    80004a38:	32c080e7          	jalr	812(ra) # 80000d60 <release>
}
    80004a3c:	a03d                	j	80004a6a <end_op+0xaa>
    panic("log.committing");
    80004a3e:	00004517          	auipc	a0,0x4
    80004a42:	c9250513          	addi	a0,a0,-878 # 800086d0 <syscalls+0x200>
    80004a46:	ffffc097          	auipc	ra,0xffffc
    80004a4a:	afa080e7          	jalr	-1286(ra) # 80000540 <panic>
    wakeup(&log);
    80004a4e:	00064497          	auipc	s1,0x64
    80004a52:	37248493          	addi	s1,s1,882 # 80068dc0 <log>
    80004a56:	8526                	mv	a0,s1
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	bc0080e7          	jalr	-1088(ra) # 80002618 <wakeup>
  release(&log.lock);
    80004a60:	8526                	mv	a0,s1
    80004a62:	ffffc097          	auipc	ra,0xffffc
    80004a66:	2fe080e7          	jalr	766(ra) # 80000d60 <release>
}
    80004a6a:	70e2                	ld	ra,56(sp)
    80004a6c:	7442                	ld	s0,48(sp)
    80004a6e:	74a2                	ld	s1,40(sp)
    80004a70:	7902                	ld	s2,32(sp)
    80004a72:	69e2                	ld	s3,24(sp)
    80004a74:	6a42                	ld	s4,16(sp)
    80004a76:	6aa2                	ld	s5,8(sp)
    80004a78:	6121                	addi	sp,sp,64
    80004a7a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a7c:	00064a97          	auipc	s5,0x64
    80004a80:	374a8a93          	addi	s5,s5,884 # 80068df0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004a84:	00064a17          	auipc	s4,0x64
    80004a88:	33ca0a13          	addi	s4,s4,828 # 80068dc0 <log>
    80004a8c:	018a2583          	lw	a1,24(s4)
    80004a90:	012585bb          	addw	a1,a1,s2
    80004a94:	2585                	addiw	a1,a1,1
    80004a96:	028a2503          	lw	a0,40(s4)
    80004a9a:	fffff097          	auipc	ra,0xfffff
    80004a9e:	cc4080e7          	jalr	-828(ra) # 8000375e <bread>
    80004aa2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004aa4:	000aa583          	lw	a1,0(s5)
    80004aa8:	028a2503          	lw	a0,40(s4)
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	cb2080e7          	jalr	-846(ra) # 8000375e <bread>
    80004ab4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004ab6:	40000613          	li	a2,1024
    80004aba:	05850593          	addi	a1,a0,88
    80004abe:	05848513          	addi	a0,s1,88
    80004ac2:	ffffc097          	auipc	ra,0xffffc
    80004ac6:	342080e7          	jalr	834(ra) # 80000e04 <memmove>
    bwrite(to);  // write the log
    80004aca:	8526                	mv	a0,s1
    80004acc:	fffff097          	auipc	ra,0xfffff
    80004ad0:	d84080e7          	jalr	-636(ra) # 80003850 <bwrite>
    brelse(from);
    80004ad4:	854e                	mv	a0,s3
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	db8080e7          	jalr	-584(ra) # 8000388e <brelse>
    brelse(to);
    80004ade:	8526                	mv	a0,s1
    80004ae0:	fffff097          	auipc	ra,0xfffff
    80004ae4:	dae080e7          	jalr	-594(ra) # 8000388e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004ae8:	2905                	addiw	s2,s2,1
    80004aea:	0a91                	addi	s5,s5,4
    80004aec:	02ca2783          	lw	a5,44(s4)
    80004af0:	f8f94ee3          	blt	s2,a5,80004a8c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004af4:	00000097          	auipc	ra,0x0
    80004af8:	c68080e7          	jalr	-920(ra) # 8000475c <write_head>
    install_trans(0); // Now install writes to home locations
    80004afc:	4501                	li	a0,0
    80004afe:	00000097          	auipc	ra,0x0
    80004b02:	cda080e7          	jalr	-806(ra) # 800047d8 <install_trans>
    log.lh.n = 0;
    80004b06:	00064797          	auipc	a5,0x64
    80004b0a:	2e07a323          	sw	zero,742(a5) # 80068dec <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004b0e:	00000097          	auipc	ra,0x0
    80004b12:	c4e080e7          	jalr	-946(ra) # 8000475c <write_head>
    80004b16:	bdf5                	j	80004a12 <end_op+0x52>

0000000080004b18 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004b18:	1101                	addi	sp,sp,-32
    80004b1a:	ec06                	sd	ra,24(sp)
    80004b1c:	e822                	sd	s0,16(sp)
    80004b1e:	e426                	sd	s1,8(sp)
    80004b20:	e04a                	sd	s2,0(sp)
    80004b22:	1000                	addi	s0,sp,32
    80004b24:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004b26:	00064917          	auipc	s2,0x64
    80004b2a:	29a90913          	addi	s2,s2,666 # 80068dc0 <log>
    80004b2e:	854a                	mv	a0,s2
    80004b30:	ffffc097          	auipc	ra,0xffffc
    80004b34:	17c080e7          	jalr	380(ra) # 80000cac <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004b38:	02c92603          	lw	a2,44(s2)
    80004b3c:	47f5                	li	a5,29
    80004b3e:	06c7c563          	blt	a5,a2,80004ba8 <log_write+0x90>
    80004b42:	00064797          	auipc	a5,0x64
    80004b46:	29a7a783          	lw	a5,666(a5) # 80068ddc <log+0x1c>
    80004b4a:	37fd                	addiw	a5,a5,-1
    80004b4c:	04f65e63          	bge	a2,a5,80004ba8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004b50:	00064797          	auipc	a5,0x64
    80004b54:	2907a783          	lw	a5,656(a5) # 80068de0 <log+0x20>
    80004b58:	06f05063          	blez	a5,80004bb8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004b5c:	4781                	li	a5,0
    80004b5e:	06c05563          	blez	a2,80004bc8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b62:	44cc                	lw	a1,12(s1)
    80004b64:	00064717          	auipc	a4,0x64
    80004b68:	28c70713          	addi	a4,a4,652 # 80068df0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004b6c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b6e:	4314                	lw	a3,0(a4)
    80004b70:	04b68c63          	beq	a3,a1,80004bc8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004b74:	2785                	addiw	a5,a5,1
    80004b76:	0711                	addi	a4,a4,4
    80004b78:	fef61be3          	bne	a2,a5,80004b6e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004b7c:	0621                	addi	a2,a2,8
    80004b7e:	060a                	slli	a2,a2,0x2
    80004b80:	00064797          	auipc	a5,0x64
    80004b84:	24078793          	addi	a5,a5,576 # 80068dc0 <log>
    80004b88:	97b2                	add	a5,a5,a2
    80004b8a:	44d8                	lw	a4,12(s1)
    80004b8c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004b8e:	8526                	mv	a0,s1
    80004b90:	fffff097          	auipc	ra,0xfffff
    80004b94:	d9c080e7          	jalr	-612(ra) # 8000392c <bpin>
    log.lh.n++;
    80004b98:	00064717          	auipc	a4,0x64
    80004b9c:	22870713          	addi	a4,a4,552 # 80068dc0 <log>
    80004ba0:	575c                	lw	a5,44(a4)
    80004ba2:	2785                	addiw	a5,a5,1
    80004ba4:	d75c                	sw	a5,44(a4)
    80004ba6:	a82d                	j	80004be0 <log_write+0xc8>
    panic("too big a transaction");
    80004ba8:	00004517          	auipc	a0,0x4
    80004bac:	b3850513          	addi	a0,a0,-1224 # 800086e0 <syscalls+0x210>
    80004bb0:	ffffc097          	auipc	ra,0xffffc
    80004bb4:	990080e7          	jalr	-1648(ra) # 80000540 <panic>
    panic("log_write outside of trans");
    80004bb8:	00004517          	auipc	a0,0x4
    80004bbc:	b4050513          	addi	a0,a0,-1216 # 800086f8 <syscalls+0x228>
    80004bc0:	ffffc097          	auipc	ra,0xffffc
    80004bc4:	980080e7          	jalr	-1664(ra) # 80000540 <panic>
  log.lh.block[i] = b->blockno;
    80004bc8:	00878693          	addi	a3,a5,8
    80004bcc:	068a                	slli	a3,a3,0x2
    80004bce:	00064717          	auipc	a4,0x64
    80004bd2:	1f270713          	addi	a4,a4,498 # 80068dc0 <log>
    80004bd6:	9736                	add	a4,a4,a3
    80004bd8:	44d4                	lw	a3,12(s1)
    80004bda:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004bdc:	faf609e3          	beq	a2,a5,80004b8e <log_write+0x76>
  }
  release(&log.lock);
    80004be0:	00064517          	auipc	a0,0x64
    80004be4:	1e050513          	addi	a0,a0,480 # 80068dc0 <log>
    80004be8:	ffffc097          	auipc	ra,0xffffc
    80004bec:	178080e7          	jalr	376(ra) # 80000d60 <release>
}
    80004bf0:	60e2                	ld	ra,24(sp)
    80004bf2:	6442                	ld	s0,16(sp)
    80004bf4:	64a2                	ld	s1,8(sp)
    80004bf6:	6902                	ld	s2,0(sp)
    80004bf8:	6105                	addi	sp,sp,32
    80004bfa:	8082                	ret

0000000080004bfc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004bfc:	1101                	addi	sp,sp,-32
    80004bfe:	ec06                	sd	ra,24(sp)
    80004c00:	e822                	sd	s0,16(sp)
    80004c02:	e426                	sd	s1,8(sp)
    80004c04:	e04a                	sd	s2,0(sp)
    80004c06:	1000                	addi	s0,sp,32
    80004c08:	84aa                	mv	s1,a0
    80004c0a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004c0c:	00004597          	auipc	a1,0x4
    80004c10:	b0c58593          	addi	a1,a1,-1268 # 80008718 <syscalls+0x248>
    80004c14:	0521                	addi	a0,a0,8
    80004c16:	ffffc097          	auipc	ra,0xffffc
    80004c1a:	006080e7          	jalr	6(ra) # 80000c1c <initlock>
  lk->name = name;
    80004c1e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004c22:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004c26:	0204a423          	sw	zero,40(s1)
}
    80004c2a:	60e2                	ld	ra,24(sp)
    80004c2c:	6442                	ld	s0,16(sp)
    80004c2e:	64a2                	ld	s1,8(sp)
    80004c30:	6902                	ld	s2,0(sp)
    80004c32:	6105                	addi	sp,sp,32
    80004c34:	8082                	ret

0000000080004c36 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004c36:	1101                	addi	sp,sp,-32
    80004c38:	ec06                	sd	ra,24(sp)
    80004c3a:	e822                	sd	s0,16(sp)
    80004c3c:	e426                	sd	s1,8(sp)
    80004c3e:	e04a                	sd	s2,0(sp)
    80004c40:	1000                	addi	s0,sp,32
    80004c42:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c44:	00850913          	addi	s2,a0,8
    80004c48:	854a                	mv	a0,s2
    80004c4a:	ffffc097          	auipc	ra,0xffffc
    80004c4e:	062080e7          	jalr	98(ra) # 80000cac <acquire>
  while (lk->locked) {
    80004c52:	409c                	lw	a5,0(s1)
    80004c54:	cb89                	beqz	a5,80004c66 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004c56:	85ca                	mv	a1,s2
    80004c58:	8526                	mv	a0,s1
    80004c5a:	ffffe097          	auipc	ra,0xffffe
    80004c5e:	95a080e7          	jalr	-1702(ra) # 800025b4 <sleep>
  while (lk->locked) {
    80004c62:	409c                	lw	a5,0(s1)
    80004c64:	fbed                	bnez	a5,80004c56 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004c66:	4785                	li	a5,1
    80004c68:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004c6a:	ffffd097          	auipc	ra,0xffffd
    80004c6e:	09e080e7          	jalr	158(ra) # 80001d08 <myproc>
    80004c72:	591c                	lw	a5,48(a0)
    80004c74:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004c76:	854a                	mv	a0,s2
    80004c78:	ffffc097          	auipc	ra,0xffffc
    80004c7c:	0e8080e7          	jalr	232(ra) # 80000d60 <release>
}
    80004c80:	60e2                	ld	ra,24(sp)
    80004c82:	6442                	ld	s0,16(sp)
    80004c84:	64a2                	ld	s1,8(sp)
    80004c86:	6902                	ld	s2,0(sp)
    80004c88:	6105                	addi	sp,sp,32
    80004c8a:	8082                	ret

0000000080004c8c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004c8c:	1101                	addi	sp,sp,-32
    80004c8e:	ec06                	sd	ra,24(sp)
    80004c90:	e822                	sd	s0,16(sp)
    80004c92:	e426                	sd	s1,8(sp)
    80004c94:	e04a                	sd	s2,0(sp)
    80004c96:	1000                	addi	s0,sp,32
    80004c98:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c9a:	00850913          	addi	s2,a0,8
    80004c9e:	854a                	mv	a0,s2
    80004ca0:	ffffc097          	auipc	ra,0xffffc
    80004ca4:	00c080e7          	jalr	12(ra) # 80000cac <acquire>
  lk->locked = 0;
    80004ca8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004cac:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004cb0:	8526                	mv	a0,s1
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	966080e7          	jalr	-1690(ra) # 80002618 <wakeup>
  release(&lk->lk);
    80004cba:	854a                	mv	a0,s2
    80004cbc:	ffffc097          	auipc	ra,0xffffc
    80004cc0:	0a4080e7          	jalr	164(ra) # 80000d60 <release>
}
    80004cc4:	60e2                	ld	ra,24(sp)
    80004cc6:	6442                	ld	s0,16(sp)
    80004cc8:	64a2                	ld	s1,8(sp)
    80004cca:	6902                	ld	s2,0(sp)
    80004ccc:	6105                	addi	sp,sp,32
    80004cce:	8082                	ret

0000000080004cd0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004cd0:	7179                	addi	sp,sp,-48
    80004cd2:	f406                	sd	ra,40(sp)
    80004cd4:	f022                	sd	s0,32(sp)
    80004cd6:	ec26                	sd	s1,24(sp)
    80004cd8:	e84a                	sd	s2,16(sp)
    80004cda:	e44e                	sd	s3,8(sp)
    80004cdc:	1800                	addi	s0,sp,48
    80004cde:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004ce0:	00850913          	addi	s2,a0,8
    80004ce4:	854a                	mv	a0,s2
    80004ce6:	ffffc097          	auipc	ra,0xffffc
    80004cea:	fc6080e7          	jalr	-58(ra) # 80000cac <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004cee:	409c                	lw	a5,0(s1)
    80004cf0:	ef99                	bnez	a5,80004d0e <holdingsleep+0x3e>
    80004cf2:	4481                	li	s1,0
  release(&lk->lk);
    80004cf4:	854a                	mv	a0,s2
    80004cf6:	ffffc097          	auipc	ra,0xffffc
    80004cfa:	06a080e7          	jalr	106(ra) # 80000d60 <release>
  return r;
}
    80004cfe:	8526                	mv	a0,s1
    80004d00:	70a2                	ld	ra,40(sp)
    80004d02:	7402                	ld	s0,32(sp)
    80004d04:	64e2                	ld	s1,24(sp)
    80004d06:	6942                	ld	s2,16(sp)
    80004d08:	69a2                	ld	s3,8(sp)
    80004d0a:	6145                	addi	sp,sp,48
    80004d0c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004d0e:	0284a983          	lw	s3,40(s1)
    80004d12:	ffffd097          	auipc	ra,0xffffd
    80004d16:	ff6080e7          	jalr	-10(ra) # 80001d08 <myproc>
    80004d1a:	5904                	lw	s1,48(a0)
    80004d1c:	413484b3          	sub	s1,s1,s3
    80004d20:	0014b493          	seqz	s1,s1
    80004d24:	bfc1                	j	80004cf4 <holdingsleep+0x24>

0000000080004d26 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004d26:	1141                	addi	sp,sp,-16
    80004d28:	e406                	sd	ra,8(sp)
    80004d2a:	e022                	sd	s0,0(sp)
    80004d2c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004d2e:	00004597          	auipc	a1,0x4
    80004d32:	9fa58593          	addi	a1,a1,-1542 # 80008728 <syscalls+0x258>
    80004d36:	00064517          	auipc	a0,0x64
    80004d3a:	1d250513          	addi	a0,a0,466 # 80068f08 <ftable>
    80004d3e:	ffffc097          	auipc	ra,0xffffc
    80004d42:	ede080e7          	jalr	-290(ra) # 80000c1c <initlock>
}
    80004d46:	60a2                	ld	ra,8(sp)
    80004d48:	6402                	ld	s0,0(sp)
    80004d4a:	0141                	addi	sp,sp,16
    80004d4c:	8082                	ret

0000000080004d4e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004d4e:	1101                	addi	sp,sp,-32
    80004d50:	ec06                	sd	ra,24(sp)
    80004d52:	e822                	sd	s0,16(sp)
    80004d54:	e426                	sd	s1,8(sp)
    80004d56:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004d58:	00064517          	auipc	a0,0x64
    80004d5c:	1b050513          	addi	a0,a0,432 # 80068f08 <ftable>
    80004d60:	ffffc097          	auipc	ra,0xffffc
    80004d64:	f4c080e7          	jalr	-180(ra) # 80000cac <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d68:	00064497          	auipc	s1,0x64
    80004d6c:	1b848493          	addi	s1,s1,440 # 80068f20 <ftable+0x18>
    80004d70:	00065717          	auipc	a4,0x65
    80004d74:	15070713          	addi	a4,a4,336 # 80069ec0 <disk>
    if(f->ref == 0){
    80004d78:	40dc                	lw	a5,4(s1)
    80004d7a:	cf99                	beqz	a5,80004d98 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d7c:	02848493          	addi	s1,s1,40
    80004d80:	fee49ce3          	bne	s1,a4,80004d78 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004d84:	00064517          	auipc	a0,0x64
    80004d88:	18450513          	addi	a0,a0,388 # 80068f08 <ftable>
    80004d8c:	ffffc097          	auipc	ra,0xffffc
    80004d90:	fd4080e7          	jalr	-44(ra) # 80000d60 <release>
  return 0;
    80004d94:	4481                	li	s1,0
    80004d96:	a819                	j	80004dac <filealloc+0x5e>
      f->ref = 1;
    80004d98:	4785                	li	a5,1
    80004d9a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004d9c:	00064517          	auipc	a0,0x64
    80004da0:	16c50513          	addi	a0,a0,364 # 80068f08 <ftable>
    80004da4:	ffffc097          	auipc	ra,0xffffc
    80004da8:	fbc080e7          	jalr	-68(ra) # 80000d60 <release>
}
    80004dac:	8526                	mv	a0,s1
    80004dae:	60e2                	ld	ra,24(sp)
    80004db0:	6442                	ld	s0,16(sp)
    80004db2:	64a2                	ld	s1,8(sp)
    80004db4:	6105                	addi	sp,sp,32
    80004db6:	8082                	ret

0000000080004db8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004db8:	1101                	addi	sp,sp,-32
    80004dba:	ec06                	sd	ra,24(sp)
    80004dbc:	e822                	sd	s0,16(sp)
    80004dbe:	e426                	sd	s1,8(sp)
    80004dc0:	1000                	addi	s0,sp,32
    80004dc2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004dc4:	00064517          	auipc	a0,0x64
    80004dc8:	14450513          	addi	a0,a0,324 # 80068f08 <ftable>
    80004dcc:	ffffc097          	auipc	ra,0xffffc
    80004dd0:	ee0080e7          	jalr	-288(ra) # 80000cac <acquire>
  if(f->ref < 1)
    80004dd4:	40dc                	lw	a5,4(s1)
    80004dd6:	02f05263          	blez	a5,80004dfa <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004dda:	2785                	addiw	a5,a5,1
    80004ddc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004dde:	00064517          	auipc	a0,0x64
    80004de2:	12a50513          	addi	a0,a0,298 # 80068f08 <ftable>
    80004de6:	ffffc097          	auipc	ra,0xffffc
    80004dea:	f7a080e7          	jalr	-134(ra) # 80000d60 <release>
  return f;
}
    80004dee:	8526                	mv	a0,s1
    80004df0:	60e2                	ld	ra,24(sp)
    80004df2:	6442                	ld	s0,16(sp)
    80004df4:	64a2                	ld	s1,8(sp)
    80004df6:	6105                	addi	sp,sp,32
    80004df8:	8082                	ret
    panic("filedup");
    80004dfa:	00004517          	auipc	a0,0x4
    80004dfe:	93650513          	addi	a0,a0,-1738 # 80008730 <syscalls+0x260>
    80004e02:	ffffb097          	auipc	ra,0xffffb
    80004e06:	73e080e7          	jalr	1854(ra) # 80000540 <panic>

0000000080004e0a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004e0a:	7139                	addi	sp,sp,-64
    80004e0c:	fc06                	sd	ra,56(sp)
    80004e0e:	f822                	sd	s0,48(sp)
    80004e10:	f426                	sd	s1,40(sp)
    80004e12:	f04a                	sd	s2,32(sp)
    80004e14:	ec4e                	sd	s3,24(sp)
    80004e16:	e852                	sd	s4,16(sp)
    80004e18:	e456                	sd	s5,8(sp)
    80004e1a:	0080                	addi	s0,sp,64
    80004e1c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004e1e:	00064517          	auipc	a0,0x64
    80004e22:	0ea50513          	addi	a0,a0,234 # 80068f08 <ftable>
    80004e26:	ffffc097          	auipc	ra,0xffffc
    80004e2a:	e86080e7          	jalr	-378(ra) # 80000cac <acquire>
  if(f->ref < 1)
    80004e2e:	40dc                	lw	a5,4(s1)
    80004e30:	06f05163          	blez	a5,80004e92 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004e34:	37fd                	addiw	a5,a5,-1
    80004e36:	0007871b          	sext.w	a4,a5
    80004e3a:	c0dc                	sw	a5,4(s1)
    80004e3c:	06e04363          	bgtz	a4,80004ea2 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004e40:	0004a903          	lw	s2,0(s1)
    80004e44:	0094ca83          	lbu	s5,9(s1)
    80004e48:	0104ba03          	ld	s4,16(s1)
    80004e4c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004e50:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004e54:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004e58:	00064517          	auipc	a0,0x64
    80004e5c:	0b050513          	addi	a0,a0,176 # 80068f08 <ftable>
    80004e60:	ffffc097          	auipc	ra,0xffffc
    80004e64:	f00080e7          	jalr	-256(ra) # 80000d60 <release>

  if(ff.type == FD_PIPE){
    80004e68:	4785                	li	a5,1
    80004e6a:	04f90d63          	beq	s2,a5,80004ec4 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004e6e:	3979                	addiw	s2,s2,-2
    80004e70:	4785                	li	a5,1
    80004e72:	0527e063          	bltu	a5,s2,80004eb2 <fileclose+0xa8>
    begin_op();
    80004e76:	00000097          	auipc	ra,0x0
    80004e7a:	acc080e7          	jalr	-1332(ra) # 80004942 <begin_op>
    iput(ff.ip);
    80004e7e:	854e                	mv	a0,s3
    80004e80:	fffff097          	auipc	ra,0xfffff
    80004e84:	2b0080e7          	jalr	688(ra) # 80004130 <iput>
    end_op();
    80004e88:	00000097          	auipc	ra,0x0
    80004e8c:	b38080e7          	jalr	-1224(ra) # 800049c0 <end_op>
    80004e90:	a00d                	j	80004eb2 <fileclose+0xa8>
    panic("fileclose");
    80004e92:	00004517          	auipc	a0,0x4
    80004e96:	8a650513          	addi	a0,a0,-1882 # 80008738 <syscalls+0x268>
    80004e9a:	ffffb097          	auipc	ra,0xffffb
    80004e9e:	6a6080e7          	jalr	1702(ra) # 80000540 <panic>
    release(&ftable.lock);
    80004ea2:	00064517          	auipc	a0,0x64
    80004ea6:	06650513          	addi	a0,a0,102 # 80068f08 <ftable>
    80004eaa:	ffffc097          	auipc	ra,0xffffc
    80004eae:	eb6080e7          	jalr	-330(ra) # 80000d60 <release>
  }
}
    80004eb2:	70e2                	ld	ra,56(sp)
    80004eb4:	7442                	ld	s0,48(sp)
    80004eb6:	74a2                	ld	s1,40(sp)
    80004eb8:	7902                	ld	s2,32(sp)
    80004eba:	69e2                	ld	s3,24(sp)
    80004ebc:	6a42                	ld	s4,16(sp)
    80004ebe:	6aa2                	ld	s5,8(sp)
    80004ec0:	6121                	addi	sp,sp,64
    80004ec2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004ec4:	85d6                	mv	a1,s5
    80004ec6:	8552                	mv	a0,s4
    80004ec8:	00000097          	auipc	ra,0x0
    80004ecc:	34c080e7          	jalr	844(ra) # 80005214 <pipeclose>
    80004ed0:	b7cd                	j	80004eb2 <fileclose+0xa8>

0000000080004ed2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004ed2:	715d                	addi	sp,sp,-80
    80004ed4:	e486                	sd	ra,72(sp)
    80004ed6:	e0a2                	sd	s0,64(sp)
    80004ed8:	fc26                	sd	s1,56(sp)
    80004eda:	f84a                	sd	s2,48(sp)
    80004edc:	f44e                	sd	s3,40(sp)
    80004ede:	0880                	addi	s0,sp,80
    80004ee0:	84aa                	mv	s1,a0
    80004ee2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	e24080e7          	jalr	-476(ra) # 80001d08 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004eec:	409c                	lw	a5,0(s1)
    80004eee:	37f9                	addiw	a5,a5,-2
    80004ef0:	4705                	li	a4,1
    80004ef2:	04f76763          	bltu	a4,a5,80004f40 <filestat+0x6e>
    80004ef6:	892a                	mv	s2,a0
    ilock(f->ip);
    80004ef8:	6c88                	ld	a0,24(s1)
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	07c080e7          	jalr	124(ra) # 80003f76 <ilock>
    stati(f->ip, &st);
    80004f02:	fb840593          	addi	a1,s0,-72
    80004f06:	6c88                	ld	a0,24(s1)
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	2f8080e7          	jalr	760(ra) # 80004200 <stati>
    iunlock(f->ip);
    80004f10:	6c88                	ld	a0,24(s1)
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	126080e7          	jalr	294(ra) # 80004038 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004f1a:	46e1                	li	a3,24
    80004f1c:	fb840613          	addi	a2,s0,-72
    80004f20:	85ce                	mv	a1,s3
    80004f22:	05093503          	ld	a0,80(s2)
    80004f26:	ffffd097          	auipc	ra,0xffffd
    80004f2a:	aa2080e7          	jalr	-1374(ra) # 800019c8 <copyout>
    80004f2e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004f32:	60a6                	ld	ra,72(sp)
    80004f34:	6406                	ld	s0,64(sp)
    80004f36:	74e2                	ld	s1,56(sp)
    80004f38:	7942                	ld	s2,48(sp)
    80004f3a:	79a2                	ld	s3,40(sp)
    80004f3c:	6161                	addi	sp,sp,80
    80004f3e:	8082                	ret
  return -1;
    80004f40:	557d                	li	a0,-1
    80004f42:	bfc5                	j	80004f32 <filestat+0x60>

0000000080004f44 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004f44:	7179                	addi	sp,sp,-48
    80004f46:	f406                	sd	ra,40(sp)
    80004f48:	f022                	sd	s0,32(sp)
    80004f4a:	ec26                	sd	s1,24(sp)
    80004f4c:	e84a                	sd	s2,16(sp)
    80004f4e:	e44e                	sd	s3,8(sp)
    80004f50:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004f52:	00854783          	lbu	a5,8(a0)
    80004f56:	c3d5                	beqz	a5,80004ffa <fileread+0xb6>
    80004f58:	84aa                	mv	s1,a0
    80004f5a:	89ae                	mv	s3,a1
    80004f5c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f5e:	411c                	lw	a5,0(a0)
    80004f60:	4705                	li	a4,1
    80004f62:	04e78963          	beq	a5,a4,80004fb4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f66:	470d                	li	a4,3
    80004f68:	04e78d63          	beq	a5,a4,80004fc2 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f6c:	4709                	li	a4,2
    80004f6e:	06e79e63          	bne	a5,a4,80004fea <fileread+0xa6>
    ilock(f->ip);
    80004f72:	6d08                	ld	a0,24(a0)
    80004f74:	fffff097          	auipc	ra,0xfffff
    80004f78:	002080e7          	jalr	2(ra) # 80003f76 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004f7c:	874a                	mv	a4,s2
    80004f7e:	5094                	lw	a3,32(s1)
    80004f80:	864e                	mv	a2,s3
    80004f82:	4585                	li	a1,1
    80004f84:	6c88                	ld	a0,24(s1)
    80004f86:	fffff097          	auipc	ra,0xfffff
    80004f8a:	2a4080e7          	jalr	676(ra) # 8000422a <readi>
    80004f8e:	892a                	mv	s2,a0
    80004f90:	00a05563          	blez	a0,80004f9a <fileread+0x56>
      f->off += r;
    80004f94:	509c                	lw	a5,32(s1)
    80004f96:	9fa9                	addw	a5,a5,a0
    80004f98:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004f9a:	6c88                	ld	a0,24(s1)
    80004f9c:	fffff097          	auipc	ra,0xfffff
    80004fa0:	09c080e7          	jalr	156(ra) # 80004038 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004fa4:	854a                	mv	a0,s2
    80004fa6:	70a2                	ld	ra,40(sp)
    80004fa8:	7402                	ld	s0,32(sp)
    80004faa:	64e2                	ld	s1,24(sp)
    80004fac:	6942                	ld	s2,16(sp)
    80004fae:	69a2                	ld	s3,8(sp)
    80004fb0:	6145                	addi	sp,sp,48
    80004fb2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004fb4:	6908                	ld	a0,16(a0)
    80004fb6:	00000097          	auipc	ra,0x0
    80004fba:	3c6080e7          	jalr	966(ra) # 8000537c <piperead>
    80004fbe:	892a                	mv	s2,a0
    80004fc0:	b7d5                	j	80004fa4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004fc2:	02451783          	lh	a5,36(a0)
    80004fc6:	03079693          	slli	a3,a5,0x30
    80004fca:	92c1                	srli	a3,a3,0x30
    80004fcc:	4725                	li	a4,9
    80004fce:	02d76863          	bltu	a4,a3,80004ffe <fileread+0xba>
    80004fd2:	0792                	slli	a5,a5,0x4
    80004fd4:	00064717          	auipc	a4,0x64
    80004fd8:	e9470713          	addi	a4,a4,-364 # 80068e68 <devsw>
    80004fdc:	97ba                	add	a5,a5,a4
    80004fde:	639c                	ld	a5,0(a5)
    80004fe0:	c38d                	beqz	a5,80005002 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004fe2:	4505                	li	a0,1
    80004fe4:	9782                	jalr	a5
    80004fe6:	892a                	mv	s2,a0
    80004fe8:	bf75                	j	80004fa4 <fileread+0x60>
    panic("fileread");
    80004fea:	00003517          	auipc	a0,0x3
    80004fee:	75e50513          	addi	a0,a0,1886 # 80008748 <syscalls+0x278>
    80004ff2:	ffffb097          	auipc	ra,0xffffb
    80004ff6:	54e080e7          	jalr	1358(ra) # 80000540 <panic>
    return -1;
    80004ffa:	597d                	li	s2,-1
    80004ffc:	b765                	j	80004fa4 <fileread+0x60>
      return -1;
    80004ffe:	597d                	li	s2,-1
    80005000:	b755                	j	80004fa4 <fileread+0x60>
    80005002:	597d                	li	s2,-1
    80005004:	b745                	j	80004fa4 <fileread+0x60>

0000000080005006 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80005006:	715d                	addi	sp,sp,-80
    80005008:	e486                	sd	ra,72(sp)
    8000500a:	e0a2                	sd	s0,64(sp)
    8000500c:	fc26                	sd	s1,56(sp)
    8000500e:	f84a                	sd	s2,48(sp)
    80005010:	f44e                	sd	s3,40(sp)
    80005012:	f052                	sd	s4,32(sp)
    80005014:	ec56                	sd	s5,24(sp)
    80005016:	e85a                	sd	s6,16(sp)
    80005018:	e45e                	sd	s7,8(sp)
    8000501a:	e062                	sd	s8,0(sp)
    8000501c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    8000501e:	00954783          	lbu	a5,9(a0)
    80005022:	10078663          	beqz	a5,8000512e <filewrite+0x128>
    80005026:	892a                	mv	s2,a0
    80005028:	8b2e                	mv	s6,a1
    8000502a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000502c:	411c                	lw	a5,0(a0)
    8000502e:	4705                	li	a4,1
    80005030:	02e78263          	beq	a5,a4,80005054 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005034:	470d                	li	a4,3
    80005036:	02e78663          	beq	a5,a4,80005062 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000503a:	4709                	li	a4,2
    8000503c:	0ee79163          	bne	a5,a4,8000511e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005040:	0ac05d63          	blez	a2,800050fa <filewrite+0xf4>
    int i = 0;
    80005044:	4981                	li	s3,0
    80005046:	6b85                	lui	s7,0x1
    80005048:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000504c:	6c05                	lui	s8,0x1
    8000504e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80005052:	a861                	j	800050ea <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80005054:	6908                	ld	a0,16(a0)
    80005056:	00000097          	auipc	ra,0x0
    8000505a:	22e080e7          	jalr	558(ra) # 80005284 <pipewrite>
    8000505e:	8a2a                	mv	s4,a0
    80005060:	a045                	j	80005100 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005062:	02451783          	lh	a5,36(a0)
    80005066:	03079693          	slli	a3,a5,0x30
    8000506a:	92c1                	srli	a3,a3,0x30
    8000506c:	4725                	li	a4,9
    8000506e:	0cd76263          	bltu	a4,a3,80005132 <filewrite+0x12c>
    80005072:	0792                	slli	a5,a5,0x4
    80005074:	00064717          	auipc	a4,0x64
    80005078:	df470713          	addi	a4,a4,-524 # 80068e68 <devsw>
    8000507c:	97ba                	add	a5,a5,a4
    8000507e:	679c                	ld	a5,8(a5)
    80005080:	cbdd                	beqz	a5,80005136 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80005082:	4505                	li	a0,1
    80005084:	9782                	jalr	a5
    80005086:	8a2a                	mv	s4,a0
    80005088:	a8a5                	j	80005100 <filewrite+0xfa>
    8000508a:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000508e:	00000097          	auipc	ra,0x0
    80005092:	8b4080e7          	jalr	-1868(ra) # 80004942 <begin_op>
      ilock(f->ip);
    80005096:	01893503          	ld	a0,24(s2)
    8000509a:	fffff097          	auipc	ra,0xfffff
    8000509e:	edc080e7          	jalr	-292(ra) # 80003f76 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800050a2:	8756                	mv	a4,s5
    800050a4:	02092683          	lw	a3,32(s2)
    800050a8:	01698633          	add	a2,s3,s6
    800050ac:	4585                	li	a1,1
    800050ae:	01893503          	ld	a0,24(s2)
    800050b2:	fffff097          	auipc	ra,0xfffff
    800050b6:	270080e7          	jalr	624(ra) # 80004322 <writei>
    800050ba:	84aa                	mv	s1,a0
    800050bc:	00a05763          	blez	a0,800050ca <filewrite+0xc4>
        f->off += r;
    800050c0:	02092783          	lw	a5,32(s2)
    800050c4:	9fa9                	addw	a5,a5,a0
    800050c6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800050ca:	01893503          	ld	a0,24(s2)
    800050ce:	fffff097          	auipc	ra,0xfffff
    800050d2:	f6a080e7          	jalr	-150(ra) # 80004038 <iunlock>
      end_op();
    800050d6:	00000097          	auipc	ra,0x0
    800050da:	8ea080e7          	jalr	-1814(ra) # 800049c0 <end_op>

      if(r != n1){
    800050de:	009a9f63          	bne	s5,s1,800050fc <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800050e2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800050e6:	0149db63          	bge	s3,s4,800050fc <filewrite+0xf6>
      int n1 = n - i;
    800050ea:	413a04bb          	subw	s1,s4,s3
    800050ee:	0004879b          	sext.w	a5,s1
    800050f2:	f8fbdce3          	bge	s7,a5,8000508a <filewrite+0x84>
    800050f6:	84e2                	mv	s1,s8
    800050f8:	bf49                	j	8000508a <filewrite+0x84>
    int i = 0;
    800050fa:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800050fc:	013a1f63          	bne	s4,s3,8000511a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005100:	8552                	mv	a0,s4
    80005102:	60a6                	ld	ra,72(sp)
    80005104:	6406                	ld	s0,64(sp)
    80005106:	74e2                	ld	s1,56(sp)
    80005108:	7942                	ld	s2,48(sp)
    8000510a:	79a2                	ld	s3,40(sp)
    8000510c:	7a02                	ld	s4,32(sp)
    8000510e:	6ae2                	ld	s5,24(sp)
    80005110:	6b42                	ld	s6,16(sp)
    80005112:	6ba2                	ld	s7,8(sp)
    80005114:	6c02                	ld	s8,0(sp)
    80005116:	6161                	addi	sp,sp,80
    80005118:	8082                	ret
    ret = (i == n ? n : -1);
    8000511a:	5a7d                	li	s4,-1
    8000511c:	b7d5                	j	80005100 <filewrite+0xfa>
    panic("filewrite");
    8000511e:	00003517          	auipc	a0,0x3
    80005122:	63a50513          	addi	a0,a0,1594 # 80008758 <syscalls+0x288>
    80005126:	ffffb097          	auipc	ra,0xffffb
    8000512a:	41a080e7          	jalr	1050(ra) # 80000540 <panic>
    return -1;
    8000512e:	5a7d                	li	s4,-1
    80005130:	bfc1                	j	80005100 <filewrite+0xfa>
      return -1;
    80005132:	5a7d                	li	s4,-1
    80005134:	b7f1                	j	80005100 <filewrite+0xfa>
    80005136:	5a7d                	li	s4,-1
    80005138:	b7e1                	j	80005100 <filewrite+0xfa>

000000008000513a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000513a:	7179                	addi	sp,sp,-48
    8000513c:	f406                	sd	ra,40(sp)
    8000513e:	f022                	sd	s0,32(sp)
    80005140:	ec26                	sd	s1,24(sp)
    80005142:	e84a                	sd	s2,16(sp)
    80005144:	e44e                	sd	s3,8(sp)
    80005146:	e052                	sd	s4,0(sp)
    80005148:	1800                	addi	s0,sp,48
    8000514a:	84aa                	mv	s1,a0
    8000514c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000514e:	0005b023          	sd	zero,0(a1)
    80005152:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005156:	00000097          	auipc	ra,0x0
    8000515a:	bf8080e7          	jalr	-1032(ra) # 80004d4e <filealloc>
    8000515e:	e088                	sd	a0,0(s1)
    80005160:	c551                	beqz	a0,800051ec <pipealloc+0xb2>
    80005162:	00000097          	auipc	ra,0x0
    80005166:	bec080e7          	jalr	-1044(ra) # 80004d4e <filealloc>
    8000516a:	00aa3023          	sd	a0,0(s4)
    8000516e:	c92d                	beqz	a0,800051e0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	a2e080e7          	jalr	-1490(ra) # 80000b9e <kalloc>
    80005178:	892a                	mv	s2,a0
    8000517a:	c125                	beqz	a0,800051da <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000517c:	4985                	li	s3,1
    8000517e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005182:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005186:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000518a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000518e:	00003597          	auipc	a1,0x3
    80005192:	5da58593          	addi	a1,a1,1498 # 80008768 <syscalls+0x298>
    80005196:	ffffc097          	auipc	ra,0xffffc
    8000519a:	a86080e7          	jalr	-1402(ra) # 80000c1c <initlock>
  (*f0)->type = FD_PIPE;
    8000519e:	609c                	ld	a5,0(s1)
    800051a0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800051a4:	609c                	ld	a5,0(s1)
    800051a6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800051aa:	609c                	ld	a5,0(s1)
    800051ac:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800051b0:	609c                	ld	a5,0(s1)
    800051b2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800051b6:	000a3783          	ld	a5,0(s4)
    800051ba:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800051be:	000a3783          	ld	a5,0(s4)
    800051c2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800051c6:	000a3783          	ld	a5,0(s4)
    800051ca:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800051ce:	000a3783          	ld	a5,0(s4)
    800051d2:	0127b823          	sd	s2,16(a5)
  return 0;
    800051d6:	4501                	li	a0,0
    800051d8:	a025                	j	80005200 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800051da:	6088                	ld	a0,0(s1)
    800051dc:	e501                	bnez	a0,800051e4 <pipealloc+0xaa>
    800051de:	a039                	j	800051ec <pipealloc+0xb2>
    800051e0:	6088                	ld	a0,0(s1)
    800051e2:	c51d                	beqz	a0,80005210 <pipealloc+0xd6>
    fileclose(*f0);
    800051e4:	00000097          	auipc	ra,0x0
    800051e8:	c26080e7          	jalr	-986(ra) # 80004e0a <fileclose>
  if(*f1)
    800051ec:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800051f0:	557d                	li	a0,-1
  if(*f1)
    800051f2:	c799                	beqz	a5,80005200 <pipealloc+0xc6>
    fileclose(*f1);
    800051f4:	853e                	mv	a0,a5
    800051f6:	00000097          	auipc	ra,0x0
    800051fa:	c14080e7          	jalr	-1004(ra) # 80004e0a <fileclose>
  return -1;
    800051fe:	557d                	li	a0,-1
}
    80005200:	70a2                	ld	ra,40(sp)
    80005202:	7402                	ld	s0,32(sp)
    80005204:	64e2                	ld	s1,24(sp)
    80005206:	6942                	ld	s2,16(sp)
    80005208:	69a2                	ld	s3,8(sp)
    8000520a:	6a02                	ld	s4,0(sp)
    8000520c:	6145                	addi	sp,sp,48
    8000520e:	8082                	ret
  return -1;
    80005210:	557d                	li	a0,-1
    80005212:	b7fd                	j	80005200 <pipealloc+0xc6>

0000000080005214 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005214:	1101                	addi	sp,sp,-32
    80005216:	ec06                	sd	ra,24(sp)
    80005218:	e822                	sd	s0,16(sp)
    8000521a:	e426                	sd	s1,8(sp)
    8000521c:	e04a                	sd	s2,0(sp)
    8000521e:	1000                	addi	s0,sp,32
    80005220:	84aa                	mv	s1,a0
    80005222:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005224:	ffffc097          	auipc	ra,0xffffc
    80005228:	a88080e7          	jalr	-1400(ra) # 80000cac <acquire>
  if(writable){
    8000522c:	02090d63          	beqz	s2,80005266 <pipeclose+0x52>
    pi->writeopen = 0;
    80005230:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005234:	21848513          	addi	a0,s1,536
    80005238:	ffffd097          	auipc	ra,0xffffd
    8000523c:	3e0080e7          	jalr	992(ra) # 80002618 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005240:	2204b783          	ld	a5,544(s1)
    80005244:	eb95                	bnez	a5,80005278 <pipeclose+0x64>
    release(&pi->lock);
    80005246:	8526                	mv	a0,s1
    80005248:	ffffc097          	auipc	ra,0xffffc
    8000524c:	b18080e7          	jalr	-1256(ra) # 80000d60 <release>
    kfree((char*)pi);
    80005250:	8526                	mv	a0,s1
    80005252:	ffffb097          	auipc	ra,0xffffb
    80005256:	7e6080e7          	jalr	2022(ra) # 80000a38 <kfree>
  } else
    release(&pi->lock);
}
    8000525a:	60e2                	ld	ra,24(sp)
    8000525c:	6442                	ld	s0,16(sp)
    8000525e:	64a2                	ld	s1,8(sp)
    80005260:	6902                	ld	s2,0(sp)
    80005262:	6105                	addi	sp,sp,32
    80005264:	8082                	ret
    pi->readopen = 0;
    80005266:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000526a:	21c48513          	addi	a0,s1,540
    8000526e:	ffffd097          	auipc	ra,0xffffd
    80005272:	3aa080e7          	jalr	938(ra) # 80002618 <wakeup>
    80005276:	b7e9                	j	80005240 <pipeclose+0x2c>
    release(&pi->lock);
    80005278:	8526                	mv	a0,s1
    8000527a:	ffffc097          	auipc	ra,0xffffc
    8000527e:	ae6080e7          	jalr	-1306(ra) # 80000d60 <release>
}
    80005282:	bfe1                	j	8000525a <pipeclose+0x46>

0000000080005284 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005284:	711d                	addi	sp,sp,-96
    80005286:	ec86                	sd	ra,88(sp)
    80005288:	e8a2                	sd	s0,80(sp)
    8000528a:	e4a6                	sd	s1,72(sp)
    8000528c:	e0ca                	sd	s2,64(sp)
    8000528e:	fc4e                	sd	s3,56(sp)
    80005290:	f852                	sd	s4,48(sp)
    80005292:	f456                	sd	s5,40(sp)
    80005294:	f05a                	sd	s6,32(sp)
    80005296:	ec5e                	sd	s7,24(sp)
    80005298:	e862                	sd	s8,16(sp)
    8000529a:	1080                	addi	s0,sp,96
    8000529c:	84aa                	mv	s1,a0
    8000529e:	8aae                	mv	s5,a1
    800052a0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800052a2:	ffffd097          	auipc	ra,0xffffd
    800052a6:	a66080e7          	jalr	-1434(ra) # 80001d08 <myproc>
    800052aa:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800052ac:	8526                	mv	a0,s1
    800052ae:	ffffc097          	auipc	ra,0xffffc
    800052b2:	9fe080e7          	jalr	-1538(ra) # 80000cac <acquire>
  while(i < n){
    800052b6:	0b405663          	blez	s4,80005362 <pipewrite+0xde>
  int i = 0;
    800052ba:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800052bc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800052be:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800052c2:	21c48b93          	addi	s7,s1,540
    800052c6:	a089                	j	80005308 <pipewrite+0x84>
      release(&pi->lock);
    800052c8:	8526                	mv	a0,s1
    800052ca:	ffffc097          	auipc	ra,0xffffc
    800052ce:	a96080e7          	jalr	-1386(ra) # 80000d60 <release>
      return -1;
    800052d2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800052d4:	854a                	mv	a0,s2
    800052d6:	60e6                	ld	ra,88(sp)
    800052d8:	6446                	ld	s0,80(sp)
    800052da:	64a6                	ld	s1,72(sp)
    800052dc:	6906                	ld	s2,64(sp)
    800052de:	79e2                	ld	s3,56(sp)
    800052e0:	7a42                	ld	s4,48(sp)
    800052e2:	7aa2                	ld	s5,40(sp)
    800052e4:	7b02                	ld	s6,32(sp)
    800052e6:	6be2                	ld	s7,24(sp)
    800052e8:	6c42                	ld	s8,16(sp)
    800052ea:	6125                	addi	sp,sp,96
    800052ec:	8082                	ret
      wakeup(&pi->nread);
    800052ee:	8562                	mv	a0,s8
    800052f0:	ffffd097          	auipc	ra,0xffffd
    800052f4:	328080e7          	jalr	808(ra) # 80002618 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800052f8:	85a6                	mv	a1,s1
    800052fa:	855e                	mv	a0,s7
    800052fc:	ffffd097          	auipc	ra,0xffffd
    80005300:	2b8080e7          	jalr	696(ra) # 800025b4 <sleep>
  while(i < n){
    80005304:	07495063          	bge	s2,s4,80005364 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80005308:	2204a783          	lw	a5,544(s1)
    8000530c:	dfd5                	beqz	a5,800052c8 <pipewrite+0x44>
    8000530e:	854e                	mv	a0,s3
    80005310:	ffffd097          	auipc	ra,0xffffd
    80005314:	6e0080e7          	jalr	1760(ra) # 800029f0 <killed>
    80005318:	f945                	bnez	a0,800052c8 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000531a:	2184a783          	lw	a5,536(s1)
    8000531e:	21c4a703          	lw	a4,540(s1)
    80005322:	2007879b          	addiw	a5,a5,512
    80005326:	fcf704e3          	beq	a4,a5,800052ee <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000532a:	4685                	li	a3,1
    8000532c:	01590633          	add	a2,s2,s5
    80005330:	faf40593          	addi	a1,s0,-81
    80005334:	0509b503          	ld	a0,80(s3)
    80005338:	ffffc097          	auipc	ra,0xffffc
    8000533c:	71c080e7          	jalr	1820(ra) # 80001a54 <copyin>
    80005340:	03650263          	beq	a0,s6,80005364 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005344:	21c4a783          	lw	a5,540(s1)
    80005348:	0017871b          	addiw	a4,a5,1
    8000534c:	20e4ae23          	sw	a4,540(s1)
    80005350:	1ff7f793          	andi	a5,a5,511
    80005354:	97a6                	add	a5,a5,s1
    80005356:	faf44703          	lbu	a4,-81(s0)
    8000535a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000535e:	2905                	addiw	s2,s2,1
    80005360:	b755                	j	80005304 <pipewrite+0x80>
  int i = 0;
    80005362:	4901                	li	s2,0
  wakeup(&pi->nread);
    80005364:	21848513          	addi	a0,s1,536
    80005368:	ffffd097          	auipc	ra,0xffffd
    8000536c:	2b0080e7          	jalr	688(ra) # 80002618 <wakeup>
  release(&pi->lock);
    80005370:	8526                	mv	a0,s1
    80005372:	ffffc097          	auipc	ra,0xffffc
    80005376:	9ee080e7          	jalr	-1554(ra) # 80000d60 <release>
  return i;
    8000537a:	bfa9                	j	800052d4 <pipewrite+0x50>

000000008000537c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000537c:	715d                	addi	sp,sp,-80
    8000537e:	e486                	sd	ra,72(sp)
    80005380:	e0a2                	sd	s0,64(sp)
    80005382:	fc26                	sd	s1,56(sp)
    80005384:	f84a                	sd	s2,48(sp)
    80005386:	f44e                	sd	s3,40(sp)
    80005388:	f052                	sd	s4,32(sp)
    8000538a:	ec56                	sd	s5,24(sp)
    8000538c:	e85a                	sd	s6,16(sp)
    8000538e:	0880                	addi	s0,sp,80
    80005390:	84aa                	mv	s1,a0
    80005392:	892e                	mv	s2,a1
    80005394:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005396:	ffffd097          	auipc	ra,0xffffd
    8000539a:	972080e7          	jalr	-1678(ra) # 80001d08 <myproc>
    8000539e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800053a0:	8526                	mv	a0,s1
    800053a2:	ffffc097          	auipc	ra,0xffffc
    800053a6:	90a080e7          	jalr	-1782(ra) # 80000cac <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053aa:	2184a703          	lw	a4,536(s1)
    800053ae:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800053b2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053b6:	02f71763          	bne	a4,a5,800053e4 <piperead+0x68>
    800053ba:	2244a783          	lw	a5,548(s1)
    800053be:	c39d                	beqz	a5,800053e4 <piperead+0x68>
    if(killed(pr)){
    800053c0:	8552                	mv	a0,s4
    800053c2:	ffffd097          	auipc	ra,0xffffd
    800053c6:	62e080e7          	jalr	1582(ra) # 800029f0 <killed>
    800053ca:	e949                	bnez	a0,8000545c <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800053cc:	85a6                	mv	a1,s1
    800053ce:	854e                	mv	a0,s3
    800053d0:	ffffd097          	auipc	ra,0xffffd
    800053d4:	1e4080e7          	jalr	484(ra) # 800025b4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053d8:	2184a703          	lw	a4,536(s1)
    800053dc:	21c4a783          	lw	a5,540(s1)
    800053e0:	fcf70de3          	beq	a4,a5,800053ba <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800053e4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800053e6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800053e8:	05505463          	blez	s5,80005430 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800053ec:	2184a783          	lw	a5,536(s1)
    800053f0:	21c4a703          	lw	a4,540(s1)
    800053f4:	02f70e63          	beq	a4,a5,80005430 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800053f8:	0017871b          	addiw	a4,a5,1
    800053fc:	20e4ac23          	sw	a4,536(s1)
    80005400:	1ff7f793          	andi	a5,a5,511
    80005404:	97a6                	add	a5,a5,s1
    80005406:	0187c783          	lbu	a5,24(a5)
    8000540a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000540e:	4685                	li	a3,1
    80005410:	fbf40613          	addi	a2,s0,-65
    80005414:	85ca                	mv	a1,s2
    80005416:	050a3503          	ld	a0,80(s4)
    8000541a:	ffffc097          	auipc	ra,0xffffc
    8000541e:	5ae080e7          	jalr	1454(ra) # 800019c8 <copyout>
    80005422:	01650763          	beq	a0,s6,80005430 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005426:	2985                	addiw	s3,s3,1
    80005428:	0905                	addi	s2,s2,1
    8000542a:	fd3a91e3          	bne	s5,s3,800053ec <piperead+0x70>
    8000542e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005430:	21c48513          	addi	a0,s1,540
    80005434:	ffffd097          	auipc	ra,0xffffd
    80005438:	1e4080e7          	jalr	484(ra) # 80002618 <wakeup>
  release(&pi->lock);
    8000543c:	8526                	mv	a0,s1
    8000543e:	ffffc097          	auipc	ra,0xffffc
    80005442:	922080e7          	jalr	-1758(ra) # 80000d60 <release>
  return i;
}
    80005446:	854e                	mv	a0,s3
    80005448:	60a6                	ld	ra,72(sp)
    8000544a:	6406                	ld	s0,64(sp)
    8000544c:	74e2                	ld	s1,56(sp)
    8000544e:	7942                	ld	s2,48(sp)
    80005450:	79a2                	ld	s3,40(sp)
    80005452:	7a02                	ld	s4,32(sp)
    80005454:	6ae2                	ld	s5,24(sp)
    80005456:	6b42                	ld	s6,16(sp)
    80005458:	6161                	addi	sp,sp,80
    8000545a:	8082                	ret
      release(&pi->lock);
    8000545c:	8526                	mv	a0,s1
    8000545e:	ffffc097          	auipc	ra,0xffffc
    80005462:	902080e7          	jalr	-1790(ra) # 80000d60 <release>
      return -1;
    80005466:	59fd                	li	s3,-1
    80005468:	bff9                	j	80005446 <piperead+0xca>

000000008000546a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000546a:	1141                	addi	sp,sp,-16
    8000546c:	e422                	sd	s0,8(sp)
    8000546e:	0800                	addi	s0,sp,16
    80005470:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005472:	8905                	andi	a0,a0,1
    80005474:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005476:	8b89                	andi	a5,a5,2
    80005478:	c399                	beqz	a5,8000547e <flags2perm+0x14>
      perm |= PTE_W;
    8000547a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000547e:	6422                	ld	s0,8(sp)
    80005480:	0141                	addi	sp,sp,16
    80005482:	8082                	ret

0000000080005484 <exec>:

int
exec(char *path, char **argv)
{
    80005484:	de010113          	addi	sp,sp,-544
    80005488:	20113c23          	sd	ra,536(sp)
    8000548c:	20813823          	sd	s0,528(sp)
    80005490:	20913423          	sd	s1,520(sp)
    80005494:	21213023          	sd	s2,512(sp)
    80005498:	ffce                	sd	s3,504(sp)
    8000549a:	fbd2                	sd	s4,496(sp)
    8000549c:	f7d6                	sd	s5,488(sp)
    8000549e:	f3da                	sd	s6,480(sp)
    800054a0:	efde                	sd	s7,472(sp)
    800054a2:	ebe2                	sd	s8,464(sp)
    800054a4:	e7e6                	sd	s9,456(sp)
    800054a6:	e3ea                	sd	s10,448(sp)
    800054a8:	ff6e                	sd	s11,440(sp)
    800054aa:	1400                	addi	s0,sp,544
    800054ac:	892a                	mv	s2,a0
    800054ae:	dea43423          	sd	a0,-536(s0)
    800054b2:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800054b6:	ffffd097          	auipc	ra,0xffffd
    800054ba:	852080e7          	jalr	-1966(ra) # 80001d08 <myproc>
    800054be:	84aa                	mv	s1,a0

  begin_op();
    800054c0:	fffff097          	auipc	ra,0xfffff
    800054c4:	482080e7          	jalr	1154(ra) # 80004942 <begin_op>

  if((ip = namei(path)) == 0){
    800054c8:	854a                	mv	a0,s2
    800054ca:	fffff097          	auipc	ra,0xfffff
    800054ce:	258080e7          	jalr	600(ra) # 80004722 <namei>
    800054d2:	c93d                	beqz	a0,80005548 <exec+0xc4>
    800054d4:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800054d6:	fffff097          	auipc	ra,0xfffff
    800054da:	aa0080e7          	jalr	-1376(ra) # 80003f76 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800054de:	04000713          	li	a4,64
    800054e2:	4681                	li	a3,0
    800054e4:	e5040613          	addi	a2,s0,-432
    800054e8:	4581                	li	a1,0
    800054ea:	8556                	mv	a0,s5
    800054ec:	fffff097          	auipc	ra,0xfffff
    800054f0:	d3e080e7          	jalr	-706(ra) # 8000422a <readi>
    800054f4:	04000793          	li	a5,64
    800054f8:	00f51a63          	bne	a0,a5,8000550c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800054fc:	e5042703          	lw	a4,-432(s0)
    80005500:	464c47b7          	lui	a5,0x464c4
    80005504:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005508:	04f70663          	beq	a4,a5,80005554 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000550c:	8556                	mv	a0,s5
    8000550e:	fffff097          	auipc	ra,0xfffff
    80005512:	cca080e7          	jalr	-822(ra) # 800041d8 <iunlockput>
    end_op();
    80005516:	fffff097          	auipc	ra,0xfffff
    8000551a:	4aa080e7          	jalr	1194(ra) # 800049c0 <end_op>
  }
  return -1;
    8000551e:	557d                	li	a0,-1
}
    80005520:	21813083          	ld	ra,536(sp)
    80005524:	21013403          	ld	s0,528(sp)
    80005528:	20813483          	ld	s1,520(sp)
    8000552c:	20013903          	ld	s2,512(sp)
    80005530:	79fe                	ld	s3,504(sp)
    80005532:	7a5e                	ld	s4,496(sp)
    80005534:	7abe                	ld	s5,488(sp)
    80005536:	7b1e                	ld	s6,480(sp)
    80005538:	6bfe                	ld	s7,472(sp)
    8000553a:	6c5e                	ld	s8,464(sp)
    8000553c:	6cbe                	ld	s9,456(sp)
    8000553e:	6d1e                	ld	s10,448(sp)
    80005540:	7dfa                	ld	s11,440(sp)
    80005542:	22010113          	addi	sp,sp,544
    80005546:	8082                	ret
    end_op();
    80005548:	fffff097          	auipc	ra,0xfffff
    8000554c:	478080e7          	jalr	1144(ra) # 800049c0 <end_op>
    return -1;
    80005550:	557d                	li	a0,-1
    80005552:	b7f9                	j	80005520 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80005554:	8526                	mv	a0,s1
    80005556:	ffffd097          	auipc	ra,0xffffd
    8000555a:	876080e7          	jalr	-1930(ra) # 80001dcc <proc_pagetable>
    8000555e:	8b2a                	mv	s6,a0
    80005560:	d555                	beqz	a0,8000550c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005562:	e7042783          	lw	a5,-400(s0)
    80005566:	e8845703          	lhu	a4,-376(s0)
    8000556a:	c735                	beqz	a4,800055d6 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000556c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000556e:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005572:	6a05                	lui	s4,0x1
    80005574:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005578:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000557c:	6d85                	lui	s11,0x1
    8000557e:	7d7d                	lui	s10,0xfffff
    80005580:	ac3d                	j	800057be <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005582:	00003517          	auipc	a0,0x3
    80005586:	1ee50513          	addi	a0,a0,494 # 80008770 <syscalls+0x2a0>
    8000558a:	ffffb097          	auipc	ra,0xffffb
    8000558e:	fb6080e7          	jalr	-74(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005592:	874a                	mv	a4,s2
    80005594:	009c86bb          	addw	a3,s9,s1
    80005598:	4581                	li	a1,0
    8000559a:	8556                	mv	a0,s5
    8000559c:	fffff097          	auipc	ra,0xfffff
    800055a0:	c8e080e7          	jalr	-882(ra) # 8000422a <readi>
    800055a4:	2501                	sext.w	a0,a0
    800055a6:	1aa91963          	bne	s2,a0,80005758 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800055aa:	009d84bb          	addw	s1,s11,s1
    800055ae:	013d09bb          	addw	s3,s10,s3
    800055b2:	1f74f663          	bgeu	s1,s7,8000579e <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800055b6:	02049593          	slli	a1,s1,0x20
    800055ba:	9181                	srli	a1,a1,0x20
    800055bc:	95e2                	add	a1,a1,s8
    800055be:	855a                	mv	a0,s6
    800055c0:	ffffc097          	auipc	ra,0xffffc
    800055c4:	b72080e7          	jalr	-1166(ra) # 80001132 <walkaddr>
    800055c8:	862a                	mv	a2,a0
    if(pa == 0)
    800055ca:	dd45                	beqz	a0,80005582 <exec+0xfe>
      n = PGSIZE;
    800055cc:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800055ce:	fd49f2e3          	bgeu	s3,s4,80005592 <exec+0x10e>
      n = sz - i;
    800055d2:	894e                	mv	s2,s3
    800055d4:	bf7d                	j	80005592 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800055d6:	4901                	li	s2,0
  iunlockput(ip);
    800055d8:	8556                	mv	a0,s5
    800055da:	fffff097          	auipc	ra,0xfffff
    800055de:	bfe080e7          	jalr	-1026(ra) # 800041d8 <iunlockput>
  end_op();
    800055e2:	fffff097          	auipc	ra,0xfffff
    800055e6:	3de080e7          	jalr	990(ra) # 800049c0 <end_op>
  p = myproc();
    800055ea:	ffffc097          	auipc	ra,0xffffc
    800055ee:	71e080e7          	jalr	1822(ra) # 80001d08 <myproc>
    800055f2:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800055f4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800055f8:	6785                	lui	a5,0x1
    800055fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800055fc:	97ca                	add	a5,a5,s2
    800055fe:	777d                	lui	a4,0xfffff
    80005600:	8ff9                	and	a5,a5,a4
    80005602:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005606:	4691                	li	a3,4
    80005608:	6609                	lui	a2,0x2
    8000560a:	963e                	add	a2,a2,a5
    8000560c:	85be                	mv	a1,a5
    8000560e:	855a                	mv	a0,s6
    80005610:	ffffc097          	auipc	ra,0xffffc
    80005614:	ed6080e7          	jalr	-298(ra) # 800014e6 <uvmalloc>
    80005618:	8c2a                	mv	s8,a0
  ip = 0;
    8000561a:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000561c:	12050e63          	beqz	a0,80005758 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005620:	75f9                	lui	a1,0xffffe
    80005622:	95aa                	add	a1,a1,a0
    80005624:	855a                	mv	a0,s6
    80005626:	ffffc097          	auipc	ra,0xffffc
    8000562a:	370080e7          	jalr	880(ra) # 80001996 <uvmclear>
  stackbase = sp - PGSIZE;
    8000562e:	7afd                	lui	s5,0xfffff
    80005630:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80005632:	df043783          	ld	a5,-528(s0)
    80005636:	6388                	ld	a0,0(a5)
    80005638:	c925                	beqz	a0,800056a8 <exec+0x224>
    8000563a:	e9040993          	addi	s3,s0,-368
    8000563e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80005642:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005644:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005646:	ffffc097          	auipc	ra,0xffffc
    8000564a:	8de080e7          	jalr	-1826(ra) # 80000f24 <strlen>
    8000564e:	0015079b          	addiw	a5,a0,1
    80005652:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005656:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000565a:	13596663          	bltu	s2,s5,80005786 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000565e:	df043d83          	ld	s11,-528(s0)
    80005662:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005666:	8552                	mv	a0,s4
    80005668:	ffffc097          	auipc	ra,0xffffc
    8000566c:	8bc080e7          	jalr	-1860(ra) # 80000f24 <strlen>
    80005670:	0015069b          	addiw	a3,a0,1
    80005674:	8652                	mv	a2,s4
    80005676:	85ca                	mv	a1,s2
    80005678:	855a                	mv	a0,s6
    8000567a:	ffffc097          	auipc	ra,0xffffc
    8000567e:	34e080e7          	jalr	846(ra) # 800019c8 <copyout>
    80005682:	10054663          	bltz	a0,8000578e <exec+0x30a>
    ustack[argc] = sp;
    80005686:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000568a:	0485                	addi	s1,s1,1
    8000568c:	008d8793          	addi	a5,s11,8
    80005690:	def43823          	sd	a5,-528(s0)
    80005694:	008db503          	ld	a0,8(s11)
    80005698:	c911                	beqz	a0,800056ac <exec+0x228>
    if(argc >= MAXARG)
    8000569a:	09a1                	addi	s3,s3,8
    8000569c:	fb3c95e3          	bne	s9,s3,80005646 <exec+0x1c2>
  sz = sz1;
    800056a0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800056a4:	4a81                	li	s5,0
    800056a6:	a84d                	j	80005758 <exec+0x2d4>
  sp = sz;
    800056a8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800056aa:	4481                	li	s1,0
  ustack[argc] = 0;
    800056ac:	00349793          	slli	a5,s1,0x3
    800056b0:	f9078793          	addi	a5,a5,-112
    800056b4:	97a2                	add	a5,a5,s0
    800056b6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800056ba:	00148693          	addi	a3,s1,1
    800056be:	068e                	slli	a3,a3,0x3
    800056c0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800056c4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800056c8:	01597663          	bgeu	s2,s5,800056d4 <exec+0x250>
  sz = sz1;
    800056cc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800056d0:	4a81                	li	s5,0
    800056d2:	a059                	j	80005758 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800056d4:	e9040613          	addi	a2,s0,-368
    800056d8:	85ca                	mv	a1,s2
    800056da:	855a                	mv	a0,s6
    800056dc:	ffffc097          	auipc	ra,0xffffc
    800056e0:	2ec080e7          	jalr	748(ra) # 800019c8 <copyout>
    800056e4:	0a054963          	bltz	a0,80005796 <exec+0x312>
  p->trapframe->a1 = sp;
    800056e8:	058bb783          	ld	a5,88(s7)
    800056ec:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800056f0:	de843783          	ld	a5,-536(s0)
    800056f4:	0007c703          	lbu	a4,0(a5)
    800056f8:	cf11                	beqz	a4,80005714 <exec+0x290>
    800056fa:	0785                	addi	a5,a5,1
    if(*s == '/')
    800056fc:	02f00693          	li	a3,47
    80005700:	a039                	j	8000570e <exec+0x28a>
      last = s+1;
    80005702:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005706:	0785                	addi	a5,a5,1
    80005708:	fff7c703          	lbu	a4,-1(a5)
    8000570c:	c701                	beqz	a4,80005714 <exec+0x290>
    if(*s == '/')
    8000570e:	fed71ce3          	bne	a4,a3,80005706 <exec+0x282>
    80005712:	bfc5                	j	80005702 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80005714:	4641                	li	a2,16
    80005716:	de843583          	ld	a1,-536(s0)
    8000571a:	158b8513          	addi	a0,s7,344
    8000571e:	ffffb097          	auipc	ra,0xffffb
    80005722:	7d4080e7          	jalr	2004(ra) # 80000ef2 <safestrcpy>
  oldpagetable = p->pagetable;
    80005726:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000572a:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000572e:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005732:	058bb783          	ld	a5,88(s7)
    80005736:	e6843703          	ld	a4,-408(s0)
    8000573a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000573c:	058bb783          	ld	a5,88(s7)
    80005740:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005744:	85ea                	mv	a1,s10
    80005746:	ffffc097          	auipc	ra,0xffffc
    8000574a:	722080e7          	jalr	1826(ra) # 80001e68 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000574e:	0004851b          	sext.w	a0,s1
    80005752:	b3f9                	j	80005520 <exec+0x9c>
    80005754:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005758:	df843583          	ld	a1,-520(s0)
    8000575c:	855a                	mv	a0,s6
    8000575e:	ffffc097          	auipc	ra,0xffffc
    80005762:	70a080e7          	jalr	1802(ra) # 80001e68 <proc_freepagetable>
  if(ip){
    80005766:	da0a93e3          	bnez	s5,8000550c <exec+0x88>
  return -1;
    8000576a:	557d                	li	a0,-1
    8000576c:	bb55                	j	80005520 <exec+0x9c>
    8000576e:	df243c23          	sd	s2,-520(s0)
    80005772:	b7dd                	j	80005758 <exec+0x2d4>
    80005774:	df243c23          	sd	s2,-520(s0)
    80005778:	b7c5                	j	80005758 <exec+0x2d4>
    8000577a:	df243c23          	sd	s2,-520(s0)
    8000577e:	bfe9                	j	80005758 <exec+0x2d4>
    80005780:	df243c23          	sd	s2,-520(s0)
    80005784:	bfd1                	j	80005758 <exec+0x2d4>
  sz = sz1;
    80005786:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000578a:	4a81                	li	s5,0
    8000578c:	b7f1                	j	80005758 <exec+0x2d4>
  sz = sz1;
    8000578e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005792:	4a81                	li	s5,0
    80005794:	b7d1                	j	80005758 <exec+0x2d4>
  sz = sz1;
    80005796:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000579a:	4a81                	li	s5,0
    8000579c:	bf75                	j	80005758 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000579e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800057a2:	e0843783          	ld	a5,-504(s0)
    800057a6:	0017869b          	addiw	a3,a5,1
    800057aa:	e0d43423          	sd	a3,-504(s0)
    800057ae:	e0043783          	ld	a5,-512(s0)
    800057b2:	0387879b          	addiw	a5,a5,56
    800057b6:	e8845703          	lhu	a4,-376(s0)
    800057ba:	e0e6dfe3          	bge	a3,a4,800055d8 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800057be:	2781                	sext.w	a5,a5
    800057c0:	e0f43023          	sd	a5,-512(s0)
    800057c4:	03800713          	li	a4,56
    800057c8:	86be                	mv	a3,a5
    800057ca:	e1840613          	addi	a2,s0,-488
    800057ce:	4581                	li	a1,0
    800057d0:	8556                	mv	a0,s5
    800057d2:	fffff097          	auipc	ra,0xfffff
    800057d6:	a58080e7          	jalr	-1448(ra) # 8000422a <readi>
    800057da:	03800793          	li	a5,56
    800057de:	f6f51be3          	bne	a0,a5,80005754 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    800057e2:	e1842783          	lw	a5,-488(s0)
    800057e6:	4705                	li	a4,1
    800057e8:	fae79de3          	bne	a5,a4,800057a2 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    800057ec:	e4043483          	ld	s1,-448(s0)
    800057f0:	e3843783          	ld	a5,-456(s0)
    800057f4:	f6f4ede3          	bltu	s1,a5,8000576e <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800057f8:	e2843783          	ld	a5,-472(s0)
    800057fc:	94be                	add	s1,s1,a5
    800057fe:	f6f4ebe3          	bltu	s1,a5,80005774 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80005802:	de043703          	ld	a4,-544(s0)
    80005806:	8ff9                	and	a5,a5,a4
    80005808:	fbad                	bnez	a5,8000577a <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000580a:	e1c42503          	lw	a0,-484(s0)
    8000580e:	00000097          	auipc	ra,0x0
    80005812:	c5c080e7          	jalr	-932(ra) # 8000546a <flags2perm>
    80005816:	86aa                	mv	a3,a0
    80005818:	8626                	mv	a2,s1
    8000581a:	85ca                	mv	a1,s2
    8000581c:	855a                	mv	a0,s6
    8000581e:	ffffc097          	auipc	ra,0xffffc
    80005822:	cc8080e7          	jalr	-824(ra) # 800014e6 <uvmalloc>
    80005826:	dea43c23          	sd	a0,-520(s0)
    8000582a:	d939                	beqz	a0,80005780 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000582c:	e2843c03          	ld	s8,-472(s0)
    80005830:	e2042c83          	lw	s9,-480(s0)
    80005834:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005838:	f60b83e3          	beqz	s7,8000579e <exec+0x31a>
    8000583c:	89de                	mv	s3,s7
    8000583e:	4481                	li	s1,0
    80005840:	bb9d                	j	800055b6 <exec+0x132>

0000000080005842 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005842:	7179                	addi	sp,sp,-48
    80005844:	f406                	sd	ra,40(sp)
    80005846:	f022                	sd	s0,32(sp)
    80005848:	ec26                	sd	s1,24(sp)
    8000584a:	e84a                	sd	s2,16(sp)
    8000584c:	1800                	addi	s0,sp,48
    8000584e:	892e                	mv	s2,a1
    80005850:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005852:	fdc40593          	addi	a1,s0,-36
    80005856:	ffffe097          	auipc	ra,0xffffe
    8000585a:	ac6080e7          	jalr	-1338(ra) # 8000331c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000585e:	fdc42703          	lw	a4,-36(s0)
    80005862:	47bd                	li	a5,15
    80005864:	02e7eb63          	bltu	a5,a4,8000589a <argfd+0x58>
    80005868:	ffffc097          	auipc	ra,0xffffc
    8000586c:	4a0080e7          	jalr	1184(ra) # 80001d08 <myproc>
    80005870:	fdc42703          	lw	a4,-36(s0)
    80005874:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ff9501a>
    80005878:	078e                	slli	a5,a5,0x3
    8000587a:	953e                	add	a0,a0,a5
    8000587c:	611c                	ld	a5,0(a0)
    8000587e:	c385                	beqz	a5,8000589e <argfd+0x5c>
    return -1;
  if(pfd)
    80005880:	00090463          	beqz	s2,80005888 <argfd+0x46>
    *pfd = fd;
    80005884:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005888:	4501                	li	a0,0
  if(pf)
    8000588a:	c091                	beqz	s1,8000588e <argfd+0x4c>
    *pf = f;
    8000588c:	e09c                	sd	a5,0(s1)
}
    8000588e:	70a2                	ld	ra,40(sp)
    80005890:	7402                	ld	s0,32(sp)
    80005892:	64e2                	ld	s1,24(sp)
    80005894:	6942                	ld	s2,16(sp)
    80005896:	6145                	addi	sp,sp,48
    80005898:	8082                	ret
    return -1;
    8000589a:	557d                	li	a0,-1
    8000589c:	bfcd                	j	8000588e <argfd+0x4c>
    8000589e:	557d                	li	a0,-1
    800058a0:	b7fd                	j	8000588e <argfd+0x4c>

00000000800058a2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800058a2:	1101                	addi	sp,sp,-32
    800058a4:	ec06                	sd	ra,24(sp)
    800058a6:	e822                	sd	s0,16(sp)
    800058a8:	e426                	sd	s1,8(sp)
    800058aa:	1000                	addi	s0,sp,32
    800058ac:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800058ae:	ffffc097          	auipc	ra,0xffffc
    800058b2:	45a080e7          	jalr	1114(ra) # 80001d08 <myproc>
    800058b6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800058b8:	0d050793          	addi	a5,a0,208
    800058bc:	4501                	li	a0,0
    800058be:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800058c0:	6398                	ld	a4,0(a5)
    800058c2:	cb19                	beqz	a4,800058d8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800058c4:	2505                	addiw	a0,a0,1
    800058c6:	07a1                	addi	a5,a5,8
    800058c8:	fed51ce3          	bne	a0,a3,800058c0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800058cc:	557d                	li	a0,-1
}
    800058ce:	60e2                	ld	ra,24(sp)
    800058d0:	6442                	ld	s0,16(sp)
    800058d2:	64a2                	ld	s1,8(sp)
    800058d4:	6105                	addi	sp,sp,32
    800058d6:	8082                	ret
      p->ofile[fd] = f;
    800058d8:	01a50793          	addi	a5,a0,26
    800058dc:	078e                	slli	a5,a5,0x3
    800058de:	963e                	add	a2,a2,a5
    800058e0:	e204                	sd	s1,0(a2)
      return fd;
    800058e2:	b7f5                	j	800058ce <fdalloc+0x2c>

00000000800058e4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800058e4:	715d                	addi	sp,sp,-80
    800058e6:	e486                	sd	ra,72(sp)
    800058e8:	e0a2                	sd	s0,64(sp)
    800058ea:	fc26                	sd	s1,56(sp)
    800058ec:	f84a                	sd	s2,48(sp)
    800058ee:	f44e                	sd	s3,40(sp)
    800058f0:	f052                	sd	s4,32(sp)
    800058f2:	ec56                	sd	s5,24(sp)
    800058f4:	e85a                	sd	s6,16(sp)
    800058f6:	0880                	addi	s0,sp,80
    800058f8:	8b2e                	mv	s6,a1
    800058fa:	89b2                	mv	s3,a2
    800058fc:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800058fe:	fb040593          	addi	a1,s0,-80
    80005902:	fffff097          	auipc	ra,0xfffff
    80005906:	e3e080e7          	jalr	-450(ra) # 80004740 <nameiparent>
    8000590a:	84aa                	mv	s1,a0
    8000590c:	14050f63          	beqz	a0,80005a6a <create+0x186>
    return 0;

  ilock(dp);
    80005910:	ffffe097          	auipc	ra,0xffffe
    80005914:	666080e7          	jalr	1638(ra) # 80003f76 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005918:	4601                	li	a2,0
    8000591a:	fb040593          	addi	a1,s0,-80
    8000591e:	8526                	mv	a0,s1
    80005920:	fffff097          	auipc	ra,0xfffff
    80005924:	b3a080e7          	jalr	-1222(ra) # 8000445a <dirlookup>
    80005928:	8aaa                	mv	s5,a0
    8000592a:	c931                	beqz	a0,8000597e <create+0x9a>
    iunlockput(dp);
    8000592c:	8526                	mv	a0,s1
    8000592e:	fffff097          	auipc	ra,0xfffff
    80005932:	8aa080e7          	jalr	-1878(ra) # 800041d8 <iunlockput>
    ilock(ip);
    80005936:	8556                	mv	a0,s5
    80005938:	ffffe097          	auipc	ra,0xffffe
    8000593c:	63e080e7          	jalr	1598(ra) # 80003f76 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005940:	000b059b          	sext.w	a1,s6
    80005944:	4789                	li	a5,2
    80005946:	02f59563          	bne	a1,a5,80005970 <create+0x8c>
    8000594a:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ff95044>
    8000594e:	37f9                	addiw	a5,a5,-2
    80005950:	17c2                	slli	a5,a5,0x30
    80005952:	93c1                	srli	a5,a5,0x30
    80005954:	4705                	li	a4,1
    80005956:	00f76d63          	bltu	a4,a5,80005970 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000595a:	8556                	mv	a0,s5
    8000595c:	60a6                	ld	ra,72(sp)
    8000595e:	6406                	ld	s0,64(sp)
    80005960:	74e2                	ld	s1,56(sp)
    80005962:	7942                	ld	s2,48(sp)
    80005964:	79a2                	ld	s3,40(sp)
    80005966:	7a02                	ld	s4,32(sp)
    80005968:	6ae2                	ld	s5,24(sp)
    8000596a:	6b42                	ld	s6,16(sp)
    8000596c:	6161                	addi	sp,sp,80
    8000596e:	8082                	ret
    iunlockput(ip);
    80005970:	8556                	mv	a0,s5
    80005972:	fffff097          	auipc	ra,0xfffff
    80005976:	866080e7          	jalr	-1946(ra) # 800041d8 <iunlockput>
    return 0;
    8000597a:	4a81                	li	s5,0
    8000597c:	bff9                	j	8000595a <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000597e:	85da                	mv	a1,s6
    80005980:	4088                	lw	a0,0(s1)
    80005982:	ffffe097          	auipc	ra,0xffffe
    80005986:	456080e7          	jalr	1110(ra) # 80003dd8 <ialloc>
    8000598a:	8a2a                	mv	s4,a0
    8000598c:	c539                	beqz	a0,800059da <create+0xf6>
  ilock(ip);
    8000598e:	ffffe097          	auipc	ra,0xffffe
    80005992:	5e8080e7          	jalr	1512(ra) # 80003f76 <ilock>
  ip->major = major;
    80005996:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000599a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000599e:	4905                	li	s2,1
    800059a0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800059a4:	8552                	mv	a0,s4
    800059a6:	ffffe097          	auipc	ra,0xffffe
    800059aa:	504080e7          	jalr	1284(ra) # 80003eaa <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800059ae:	000b059b          	sext.w	a1,s6
    800059b2:	03258b63          	beq	a1,s2,800059e8 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800059b6:	004a2603          	lw	a2,4(s4)
    800059ba:	fb040593          	addi	a1,s0,-80
    800059be:	8526                	mv	a0,s1
    800059c0:	fffff097          	auipc	ra,0xfffff
    800059c4:	cb0080e7          	jalr	-848(ra) # 80004670 <dirlink>
    800059c8:	06054f63          	bltz	a0,80005a46 <create+0x162>
  iunlockput(dp);
    800059cc:	8526                	mv	a0,s1
    800059ce:	fffff097          	auipc	ra,0xfffff
    800059d2:	80a080e7          	jalr	-2038(ra) # 800041d8 <iunlockput>
  return ip;
    800059d6:	8ad2                	mv	s5,s4
    800059d8:	b749                	j	8000595a <create+0x76>
    iunlockput(dp);
    800059da:	8526                	mv	a0,s1
    800059dc:	ffffe097          	auipc	ra,0xffffe
    800059e0:	7fc080e7          	jalr	2044(ra) # 800041d8 <iunlockput>
    return 0;
    800059e4:	8ad2                	mv	s5,s4
    800059e6:	bf95                	j	8000595a <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800059e8:	004a2603          	lw	a2,4(s4)
    800059ec:	00003597          	auipc	a1,0x3
    800059f0:	da458593          	addi	a1,a1,-604 # 80008790 <syscalls+0x2c0>
    800059f4:	8552                	mv	a0,s4
    800059f6:	fffff097          	auipc	ra,0xfffff
    800059fa:	c7a080e7          	jalr	-902(ra) # 80004670 <dirlink>
    800059fe:	04054463          	bltz	a0,80005a46 <create+0x162>
    80005a02:	40d0                	lw	a2,4(s1)
    80005a04:	00003597          	auipc	a1,0x3
    80005a08:	d9458593          	addi	a1,a1,-620 # 80008798 <syscalls+0x2c8>
    80005a0c:	8552                	mv	a0,s4
    80005a0e:	fffff097          	auipc	ra,0xfffff
    80005a12:	c62080e7          	jalr	-926(ra) # 80004670 <dirlink>
    80005a16:	02054863          	bltz	a0,80005a46 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80005a1a:	004a2603          	lw	a2,4(s4)
    80005a1e:	fb040593          	addi	a1,s0,-80
    80005a22:	8526                	mv	a0,s1
    80005a24:	fffff097          	auipc	ra,0xfffff
    80005a28:	c4c080e7          	jalr	-948(ra) # 80004670 <dirlink>
    80005a2c:	00054d63          	bltz	a0,80005a46 <create+0x162>
    dp->nlink++;  // for ".."
    80005a30:	04a4d783          	lhu	a5,74(s1)
    80005a34:	2785                	addiw	a5,a5,1
    80005a36:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a3a:	8526                	mv	a0,s1
    80005a3c:	ffffe097          	auipc	ra,0xffffe
    80005a40:	46e080e7          	jalr	1134(ra) # 80003eaa <iupdate>
    80005a44:	b761                	j	800059cc <create+0xe8>
  ip->nlink = 0;
    80005a46:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005a4a:	8552                	mv	a0,s4
    80005a4c:	ffffe097          	auipc	ra,0xffffe
    80005a50:	45e080e7          	jalr	1118(ra) # 80003eaa <iupdate>
  iunlockput(ip);
    80005a54:	8552                	mv	a0,s4
    80005a56:	ffffe097          	auipc	ra,0xffffe
    80005a5a:	782080e7          	jalr	1922(ra) # 800041d8 <iunlockput>
  iunlockput(dp);
    80005a5e:	8526                	mv	a0,s1
    80005a60:	ffffe097          	auipc	ra,0xffffe
    80005a64:	778080e7          	jalr	1912(ra) # 800041d8 <iunlockput>
  return 0;
    80005a68:	bdcd                	j	8000595a <create+0x76>
    return 0;
    80005a6a:	8aaa                	mv	s5,a0
    80005a6c:	b5fd                	j	8000595a <create+0x76>

0000000080005a6e <sys_dup>:
{
    80005a6e:	7179                	addi	sp,sp,-48
    80005a70:	f406                	sd	ra,40(sp)
    80005a72:	f022                	sd	s0,32(sp)
    80005a74:	ec26                	sd	s1,24(sp)
    80005a76:	e84a                	sd	s2,16(sp)
    80005a78:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005a7a:	fd840613          	addi	a2,s0,-40
    80005a7e:	4581                	li	a1,0
    80005a80:	4501                	li	a0,0
    80005a82:	00000097          	auipc	ra,0x0
    80005a86:	dc0080e7          	jalr	-576(ra) # 80005842 <argfd>
    return -1;
    80005a8a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005a8c:	02054363          	bltz	a0,80005ab2 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005a90:	fd843903          	ld	s2,-40(s0)
    80005a94:	854a                	mv	a0,s2
    80005a96:	00000097          	auipc	ra,0x0
    80005a9a:	e0c080e7          	jalr	-500(ra) # 800058a2 <fdalloc>
    80005a9e:	84aa                	mv	s1,a0
    return -1;
    80005aa0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005aa2:	00054863          	bltz	a0,80005ab2 <sys_dup+0x44>
  filedup(f);
    80005aa6:	854a                	mv	a0,s2
    80005aa8:	fffff097          	auipc	ra,0xfffff
    80005aac:	310080e7          	jalr	784(ra) # 80004db8 <filedup>
  return fd;
    80005ab0:	87a6                	mv	a5,s1
}
    80005ab2:	853e                	mv	a0,a5
    80005ab4:	70a2                	ld	ra,40(sp)
    80005ab6:	7402                	ld	s0,32(sp)
    80005ab8:	64e2                	ld	s1,24(sp)
    80005aba:	6942                	ld	s2,16(sp)
    80005abc:	6145                	addi	sp,sp,48
    80005abe:	8082                	ret

0000000080005ac0 <sys_read>:
{
    80005ac0:	7179                	addi	sp,sp,-48
    80005ac2:	f406                	sd	ra,40(sp)
    80005ac4:	f022                	sd	s0,32(sp)
    80005ac6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005ac8:	fd840593          	addi	a1,s0,-40
    80005acc:	4505                	li	a0,1
    80005ace:	ffffe097          	auipc	ra,0xffffe
    80005ad2:	86e080e7          	jalr	-1938(ra) # 8000333c <argaddr>
  argint(2, &n);
    80005ad6:	fe440593          	addi	a1,s0,-28
    80005ada:	4509                	li	a0,2
    80005adc:	ffffe097          	auipc	ra,0xffffe
    80005ae0:	840080e7          	jalr	-1984(ra) # 8000331c <argint>
  if(argfd(0, 0, &f) < 0)
    80005ae4:	fe840613          	addi	a2,s0,-24
    80005ae8:	4581                	li	a1,0
    80005aea:	4501                	li	a0,0
    80005aec:	00000097          	auipc	ra,0x0
    80005af0:	d56080e7          	jalr	-682(ra) # 80005842 <argfd>
    80005af4:	87aa                	mv	a5,a0
    return -1;
    80005af6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005af8:	0007cc63          	bltz	a5,80005b10 <sys_read+0x50>
  return fileread(f, p, n);
    80005afc:	fe442603          	lw	a2,-28(s0)
    80005b00:	fd843583          	ld	a1,-40(s0)
    80005b04:	fe843503          	ld	a0,-24(s0)
    80005b08:	fffff097          	auipc	ra,0xfffff
    80005b0c:	43c080e7          	jalr	1084(ra) # 80004f44 <fileread>
}
    80005b10:	70a2                	ld	ra,40(sp)
    80005b12:	7402                	ld	s0,32(sp)
    80005b14:	6145                	addi	sp,sp,48
    80005b16:	8082                	ret

0000000080005b18 <sys_write>:
{
    80005b18:	7179                	addi	sp,sp,-48
    80005b1a:	f406                	sd	ra,40(sp)
    80005b1c:	f022                	sd	s0,32(sp)
    80005b1e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005b20:	fd840593          	addi	a1,s0,-40
    80005b24:	4505                	li	a0,1
    80005b26:	ffffe097          	auipc	ra,0xffffe
    80005b2a:	816080e7          	jalr	-2026(ra) # 8000333c <argaddr>
  argint(2, &n);
    80005b2e:	fe440593          	addi	a1,s0,-28
    80005b32:	4509                	li	a0,2
    80005b34:	ffffd097          	auipc	ra,0xffffd
    80005b38:	7e8080e7          	jalr	2024(ra) # 8000331c <argint>
  if(argfd(0, 0, &f) < 0)
    80005b3c:	fe840613          	addi	a2,s0,-24
    80005b40:	4581                	li	a1,0
    80005b42:	4501                	li	a0,0
    80005b44:	00000097          	auipc	ra,0x0
    80005b48:	cfe080e7          	jalr	-770(ra) # 80005842 <argfd>
    80005b4c:	87aa                	mv	a5,a0
    return -1;
    80005b4e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b50:	0007cc63          	bltz	a5,80005b68 <sys_write+0x50>
  return filewrite(f, p, n);
    80005b54:	fe442603          	lw	a2,-28(s0)
    80005b58:	fd843583          	ld	a1,-40(s0)
    80005b5c:	fe843503          	ld	a0,-24(s0)
    80005b60:	fffff097          	auipc	ra,0xfffff
    80005b64:	4a6080e7          	jalr	1190(ra) # 80005006 <filewrite>
}
    80005b68:	70a2                	ld	ra,40(sp)
    80005b6a:	7402                	ld	s0,32(sp)
    80005b6c:	6145                	addi	sp,sp,48
    80005b6e:	8082                	ret

0000000080005b70 <sys_close>:
{
    80005b70:	1101                	addi	sp,sp,-32
    80005b72:	ec06                	sd	ra,24(sp)
    80005b74:	e822                	sd	s0,16(sp)
    80005b76:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005b78:	fe040613          	addi	a2,s0,-32
    80005b7c:	fec40593          	addi	a1,s0,-20
    80005b80:	4501                	li	a0,0
    80005b82:	00000097          	auipc	ra,0x0
    80005b86:	cc0080e7          	jalr	-832(ra) # 80005842 <argfd>
    return -1;
    80005b8a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005b8c:	02054463          	bltz	a0,80005bb4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005b90:	ffffc097          	auipc	ra,0xffffc
    80005b94:	178080e7          	jalr	376(ra) # 80001d08 <myproc>
    80005b98:	fec42783          	lw	a5,-20(s0)
    80005b9c:	07e9                	addi	a5,a5,26
    80005b9e:	078e                	slli	a5,a5,0x3
    80005ba0:	953e                	add	a0,a0,a5
    80005ba2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005ba6:	fe043503          	ld	a0,-32(s0)
    80005baa:	fffff097          	auipc	ra,0xfffff
    80005bae:	260080e7          	jalr	608(ra) # 80004e0a <fileclose>
  return 0;
    80005bb2:	4781                	li	a5,0
}
    80005bb4:	853e                	mv	a0,a5
    80005bb6:	60e2                	ld	ra,24(sp)
    80005bb8:	6442                	ld	s0,16(sp)
    80005bba:	6105                	addi	sp,sp,32
    80005bbc:	8082                	ret

0000000080005bbe <sys_fstat>:
{
    80005bbe:	1101                	addi	sp,sp,-32
    80005bc0:	ec06                	sd	ra,24(sp)
    80005bc2:	e822                	sd	s0,16(sp)
    80005bc4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005bc6:	fe040593          	addi	a1,s0,-32
    80005bca:	4505                	li	a0,1
    80005bcc:	ffffd097          	auipc	ra,0xffffd
    80005bd0:	770080e7          	jalr	1904(ra) # 8000333c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005bd4:	fe840613          	addi	a2,s0,-24
    80005bd8:	4581                	li	a1,0
    80005bda:	4501                	li	a0,0
    80005bdc:	00000097          	auipc	ra,0x0
    80005be0:	c66080e7          	jalr	-922(ra) # 80005842 <argfd>
    80005be4:	87aa                	mv	a5,a0
    return -1;
    80005be6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005be8:	0007ca63          	bltz	a5,80005bfc <sys_fstat+0x3e>
  return filestat(f, st);
    80005bec:	fe043583          	ld	a1,-32(s0)
    80005bf0:	fe843503          	ld	a0,-24(s0)
    80005bf4:	fffff097          	auipc	ra,0xfffff
    80005bf8:	2de080e7          	jalr	734(ra) # 80004ed2 <filestat>
}
    80005bfc:	60e2                	ld	ra,24(sp)
    80005bfe:	6442                	ld	s0,16(sp)
    80005c00:	6105                	addi	sp,sp,32
    80005c02:	8082                	ret

0000000080005c04 <sys_link>:
{
    80005c04:	7169                	addi	sp,sp,-304
    80005c06:	f606                	sd	ra,296(sp)
    80005c08:	f222                	sd	s0,288(sp)
    80005c0a:	ee26                	sd	s1,280(sp)
    80005c0c:	ea4a                	sd	s2,272(sp)
    80005c0e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c10:	08000613          	li	a2,128
    80005c14:	ed040593          	addi	a1,s0,-304
    80005c18:	4501                	li	a0,0
    80005c1a:	ffffd097          	auipc	ra,0xffffd
    80005c1e:	742080e7          	jalr	1858(ra) # 8000335c <argstr>
    return -1;
    80005c22:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c24:	10054e63          	bltz	a0,80005d40 <sys_link+0x13c>
    80005c28:	08000613          	li	a2,128
    80005c2c:	f5040593          	addi	a1,s0,-176
    80005c30:	4505                	li	a0,1
    80005c32:	ffffd097          	auipc	ra,0xffffd
    80005c36:	72a080e7          	jalr	1834(ra) # 8000335c <argstr>
    return -1;
    80005c3a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c3c:	10054263          	bltz	a0,80005d40 <sys_link+0x13c>
  begin_op();
    80005c40:	fffff097          	auipc	ra,0xfffff
    80005c44:	d02080e7          	jalr	-766(ra) # 80004942 <begin_op>
  if((ip = namei(old)) == 0){
    80005c48:	ed040513          	addi	a0,s0,-304
    80005c4c:	fffff097          	auipc	ra,0xfffff
    80005c50:	ad6080e7          	jalr	-1322(ra) # 80004722 <namei>
    80005c54:	84aa                	mv	s1,a0
    80005c56:	c551                	beqz	a0,80005ce2 <sys_link+0xde>
  ilock(ip);
    80005c58:	ffffe097          	auipc	ra,0xffffe
    80005c5c:	31e080e7          	jalr	798(ra) # 80003f76 <ilock>
  if(ip->type == T_DIR){
    80005c60:	04449703          	lh	a4,68(s1)
    80005c64:	4785                	li	a5,1
    80005c66:	08f70463          	beq	a4,a5,80005cee <sys_link+0xea>
  ip->nlink++;
    80005c6a:	04a4d783          	lhu	a5,74(s1)
    80005c6e:	2785                	addiw	a5,a5,1
    80005c70:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005c74:	8526                	mv	a0,s1
    80005c76:	ffffe097          	auipc	ra,0xffffe
    80005c7a:	234080e7          	jalr	564(ra) # 80003eaa <iupdate>
  iunlock(ip);
    80005c7e:	8526                	mv	a0,s1
    80005c80:	ffffe097          	auipc	ra,0xffffe
    80005c84:	3b8080e7          	jalr	952(ra) # 80004038 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005c88:	fd040593          	addi	a1,s0,-48
    80005c8c:	f5040513          	addi	a0,s0,-176
    80005c90:	fffff097          	auipc	ra,0xfffff
    80005c94:	ab0080e7          	jalr	-1360(ra) # 80004740 <nameiparent>
    80005c98:	892a                	mv	s2,a0
    80005c9a:	c935                	beqz	a0,80005d0e <sys_link+0x10a>
  ilock(dp);
    80005c9c:	ffffe097          	auipc	ra,0xffffe
    80005ca0:	2da080e7          	jalr	730(ra) # 80003f76 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005ca4:	00092703          	lw	a4,0(s2)
    80005ca8:	409c                	lw	a5,0(s1)
    80005caa:	04f71d63          	bne	a4,a5,80005d04 <sys_link+0x100>
    80005cae:	40d0                	lw	a2,4(s1)
    80005cb0:	fd040593          	addi	a1,s0,-48
    80005cb4:	854a                	mv	a0,s2
    80005cb6:	fffff097          	auipc	ra,0xfffff
    80005cba:	9ba080e7          	jalr	-1606(ra) # 80004670 <dirlink>
    80005cbe:	04054363          	bltz	a0,80005d04 <sys_link+0x100>
  iunlockput(dp);
    80005cc2:	854a                	mv	a0,s2
    80005cc4:	ffffe097          	auipc	ra,0xffffe
    80005cc8:	514080e7          	jalr	1300(ra) # 800041d8 <iunlockput>
  iput(ip);
    80005ccc:	8526                	mv	a0,s1
    80005cce:	ffffe097          	auipc	ra,0xffffe
    80005cd2:	462080e7          	jalr	1122(ra) # 80004130 <iput>
  end_op();
    80005cd6:	fffff097          	auipc	ra,0xfffff
    80005cda:	cea080e7          	jalr	-790(ra) # 800049c0 <end_op>
  return 0;
    80005cde:	4781                	li	a5,0
    80005ce0:	a085                	j	80005d40 <sys_link+0x13c>
    end_op();
    80005ce2:	fffff097          	auipc	ra,0xfffff
    80005ce6:	cde080e7          	jalr	-802(ra) # 800049c0 <end_op>
    return -1;
    80005cea:	57fd                	li	a5,-1
    80005cec:	a891                	j	80005d40 <sys_link+0x13c>
    iunlockput(ip);
    80005cee:	8526                	mv	a0,s1
    80005cf0:	ffffe097          	auipc	ra,0xffffe
    80005cf4:	4e8080e7          	jalr	1256(ra) # 800041d8 <iunlockput>
    end_op();
    80005cf8:	fffff097          	auipc	ra,0xfffff
    80005cfc:	cc8080e7          	jalr	-824(ra) # 800049c0 <end_op>
    return -1;
    80005d00:	57fd                	li	a5,-1
    80005d02:	a83d                	j	80005d40 <sys_link+0x13c>
    iunlockput(dp);
    80005d04:	854a                	mv	a0,s2
    80005d06:	ffffe097          	auipc	ra,0xffffe
    80005d0a:	4d2080e7          	jalr	1234(ra) # 800041d8 <iunlockput>
  ilock(ip);
    80005d0e:	8526                	mv	a0,s1
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	266080e7          	jalr	614(ra) # 80003f76 <ilock>
  ip->nlink--;
    80005d18:	04a4d783          	lhu	a5,74(s1)
    80005d1c:	37fd                	addiw	a5,a5,-1
    80005d1e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005d22:	8526                	mv	a0,s1
    80005d24:	ffffe097          	auipc	ra,0xffffe
    80005d28:	186080e7          	jalr	390(ra) # 80003eaa <iupdate>
  iunlockput(ip);
    80005d2c:	8526                	mv	a0,s1
    80005d2e:	ffffe097          	auipc	ra,0xffffe
    80005d32:	4aa080e7          	jalr	1194(ra) # 800041d8 <iunlockput>
  end_op();
    80005d36:	fffff097          	auipc	ra,0xfffff
    80005d3a:	c8a080e7          	jalr	-886(ra) # 800049c0 <end_op>
  return -1;
    80005d3e:	57fd                	li	a5,-1
}
    80005d40:	853e                	mv	a0,a5
    80005d42:	70b2                	ld	ra,296(sp)
    80005d44:	7412                	ld	s0,288(sp)
    80005d46:	64f2                	ld	s1,280(sp)
    80005d48:	6952                	ld	s2,272(sp)
    80005d4a:	6155                	addi	sp,sp,304
    80005d4c:	8082                	ret

0000000080005d4e <sys_unlink>:
{
    80005d4e:	7151                	addi	sp,sp,-240
    80005d50:	f586                	sd	ra,232(sp)
    80005d52:	f1a2                	sd	s0,224(sp)
    80005d54:	eda6                	sd	s1,216(sp)
    80005d56:	e9ca                	sd	s2,208(sp)
    80005d58:	e5ce                	sd	s3,200(sp)
    80005d5a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005d5c:	08000613          	li	a2,128
    80005d60:	f3040593          	addi	a1,s0,-208
    80005d64:	4501                	li	a0,0
    80005d66:	ffffd097          	auipc	ra,0xffffd
    80005d6a:	5f6080e7          	jalr	1526(ra) # 8000335c <argstr>
    80005d6e:	18054163          	bltz	a0,80005ef0 <sys_unlink+0x1a2>
  begin_op();
    80005d72:	fffff097          	auipc	ra,0xfffff
    80005d76:	bd0080e7          	jalr	-1072(ra) # 80004942 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005d7a:	fb040593          	addi	a1,s0,-80
    80005d7e:	f3040513          	addi	a0,s0,-208
    80005d82:	fffff097          	auipc	ra,0xfffff
    80005d86:	9be080e7          	jalr	-1602(ra) # 80004740 <nameiparent>
    80005d8a:	84aa                	mv	s1,a0
    80005d8c:	c979                	beqz	a0,80005e62 <sys_unlink+0x114>
  ilock(dp);
    80005d8e:	ffffe097          	auipc	ra,0xffffe
    80005d92:	1e8080e7          	jalr	488(ra) # 80003f76 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005d96:	00003597          	auipc	a1,0x3
    80005d9a:	9fa58593          	addi	a1,a1,-1542 # 80008790 <syscalls+0x2c0>
    80005d9e:	fb040513          	addi	a0,s0,-80
    80005da2:	ffffe097          	auipc	ra,0xffffe
    80005da6:	69e080e7          	jalr	1694(ra) # 80004440 <namecmp>
    80005daa:	14050a63          	beqz	a0,80005efe <sys_unlink+0x1b0>
    80005dae:	00003597          	auipc	a1,0x3
    80005db2:	9ea58593          	addi	a1,a1,-1558 # 80008798 <syscalls+0x2c8>
    80005db6:	fb040513          	addi	a0,s0,-80
    80005dba:	ffffe097          	auipc	ra,0xffffe
    80005dbe:	686080e7          	jalr	1670(ra) # 80004440 <namecmp>
    80005dc2:	12050e63          	beqz	a0,80005efe <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005dc6:	f2c40613          	addi	a2,s0,-212
    80005dca:	fb040593          	addi	a1,s0,-80
    80005dce:	8526                	mv	a0,s1
    80005dd0:	ffffe097          	auipc	ra,0xffffe
    80005dd4:	68a080e7          	jalr	1674(ra) # 8000445a <dirlookup>
    80005dd8:	892a                	mv	s2,a0
    80005dda:	12050263          	beqz	a0,80005efe <sys_unlink+0x1b0>
  ilock(ip);
    80005dde:	ffffe097          	auipc	ra,0xffffe
    80005de2:	198080e7          	jalr	408(ra) # 80003f76 <ilock>
  if(ip->nlink < 1)
    80005de6:	04a91783          	lh	a5,74(s2)
    80005dea:	08f05263          	blez	a5,80005e6e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005dee:	04491703          	lh	a4,68(s2)
    80005df2:	4785                	li	a5,1
    80005df4:	08f70563          	beq	a4,a5,80005e7e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005df8:	4641                	li	a2,16
    80005dfa:	4581                	li	a1,0
    80005dfc:	fc040513          	addi	a0,s0,-64
    80005e00:	ffffb097          	auipc	ra,0xffffb
    80005e04:	fa8080e7          	jalr	-88(ra) # 80000da8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e08:	4741                	li	a4,16
    80005e0a:	f2c42683          	lw	a3,-212(s0)
    80005e0e:	fc040613          	addi	a2,s0,-64
    80005e12:	4581                	li	a1,0
    80005e14:	8526                	mv	a0,s1
    80005e16:	ffffe097          	auipc	ra,0xffffe
    80005e1a:	50c080e7          	jalr	1292(ra) # 80004322 <writei>
    80005e1e:	47c1                	li	a5,16
    80005e20:	0af51563          	bne	a0,a5,80005eca <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005e24:	04491703          	lh	a4,68(s2)
    80005e28:	4785                	li	a5,1
    80005e2a:	0af70863          	beq	a4,a5,80005eda <sys_unlink+0x18c>
  iunlockput(dp);
    80005e2e:	8526                	mv	a0,s1
    80005e30:	ffffe097          	auipc	ra,0xffffe
    80005e34:	3a8080e7          	jalr	936(ra) # 800041d8 <iunlockput>
  ip->nlink--;
    80005e38:	04a95783          	lhu	a5,74(s2)
    80005e3c:	37fd                	addiw	a5,a5,-1
    80005e3e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005e42:	854a                	mv	a0,s2
    80005e44:	ffffe097          	auipc	ra,0xffffe
    80005e48:	066080e7          	jalr	102(ra) # 80003eaa <iupdate>
  iunlockput(ip);
    80005e4c:	854a                	mv	a0,s2
    80005e4e:	ffffe097          	auipc	ra,0xffffe
    80005e52:	38a080e7          	jalr	906(ra) # 800041d8 <iunlockput>
  end_op();
    80005e56:	fffff097          	auipc	ra,0xfffff
    80005e5a:	b6a080e7          	jalr	-1174(ra) # 800049c0 <end_op>
  return 0;
    80005e5e:	4501                	li	a0,0
    80005e60:	a84d                	j	80005f12 <sys_unlink+0x1c4>
    end_op();
    80005e62:	fffff097          	auipc	ra,0xfffff
    80005e66:	b5e080e7          	jalr	-1186(ra) # 800049c0 <end_op>
    return -1;
    80005e6a:	557d                	li	a0,-1
    80005e6c:	a05d                	j	80005f12 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005e6e:	00003517          	auipc	a0,0x3
    80005e72:	93250513          	addi	a0,a0,-1742 # 800087a0 <syscalls+0x2d0>
    80005e76:	ffffa097          	auipc	ra,0xffffa
    80005e7a:	6ca080e7          	jalr	1738(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005e7e:	04c92703          	lw	a4,76(s2)
    80005e82:	02000793          	li	a5,32
    80005e86:	f6e7f9e3          	bgeu	a5,a4,80005df8 <sys_unlink+0xaa>
    80005e8a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e8e:	4741                	li	a4,16
    80005e90:	86ce                	mv	a3,s3
    80005e92:	f1840613          	addi	a2,s0,-232
    80005e96:	4581                	li	a1,0
    80005e98:	854a                	mv	a0,s2
    80005e9a:	ffffe097          	auipc	ra,0xffffe
    80005e9e:	390080e7          	jalr	912(ra) # 8000422a <readi>
    80005ea2:	47c1                	li	a5,16
    80005ea4:	00f51b63          	bne	a0,a5,80005eba <sys_unlink+0x16c>
    if(de.inum != 0)
    80005ea8:	f1845783          	lhu	a5,-232(s0)
    80005eac:	e7a1                	bnez	a5,80005ef4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005eae:	29c1                	addiw	s3,s3,16
    80005eb0:	04c92783          	lw	a5,76(s2)
    80005eb4:	fcf9ede3          	bltu	s3,a5,80005e8e <sys_unlink+0x140>
    80005eb8:	b781                	j	80005df8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005eba:	00003517          	auipc	a0,0x3
    80005ebe:	8fe50513          	addi	a0,a0,-1794 # 800087b8 <syscalls+0x2e8>
    80005ec2:	ffffa097          	auipc	ra,0xffffa
    80005ec6:	67e080e7          	jalr	1662(ra) # 80000540 <panic>
    panic("unlink: writei");
    80005eca:	00003517          	auipc	a0,0x3
    80005ece:	90650513          	addi	a0,a0,-1786 # 800087d0 <syscalls+0x300>
    80005ed2:	ffffa097          	auipc	ra,0xffffa
    80005ed6:	66e080e7          	jalr	1646(ra) # 80000540 <panic>
    dp->nlink--;
    80005eda:	04a4d783          	lhu	a5,74(s1)
    80005ede:	37fd                	addiw	a5,a5,-1
    80005ee0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005ee4:	8526                	mv	a0,s1
    80005ee6:	ffffe097          	auipc	ra,0xffffe
    80005eea:	fc4080e7          	jalr	-60(ra) # 80003eaa <iupdate>
    80005eee:	b781                	j	80005e2e <sys_unlink+0xe0>
    return -1;
    80005ef0:	557d                	li	a0,-1
    80005ef2:	a005                	j	80005f12 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005ef4:	854a                	mv	a0,s2
    80005ef6:	ffffe097          	auipc	ra,0xffffe
    80005efa:	2e2080e7          	jalr	738(ra) # 800041d8 <iunlockput>
  iunlockput(dp);
    80005efe:	8526                	mv	a0,s1
    80005f00:	ffffe097          	auipc	ra,0xffffe
    80005f04:	2d8080e7          	jalr	728(ra) # 800041d8 <iunlockput>
  end_op();
    80005f08:	fffff097          	auipc	ra,0xfffff
    80005f0c:	ab8080e7          	jalr	-1352(ra) # 800049c0 <end_op>
  return -1;
    80005f10:	557d                	li	a0,-1
}
    80005f12:	70ae                	ld	ra,232(sp)
    80005f14:	740e                	ld	s0,224(sp)
    80005f16:	64ee                	ld	s1,216(sp)
    80005f18:	694e                	ld	s2,208(sp)
    80005f1a:	69ae                	ld	s3,200(sp)
    80005f1c:	616d                	addi	sp,sp,240
    80005f1e:	8082                	ret

0000000080005f20 <sys_open>:

uint64
sys_open(void)
{
    80005f20:	7131                	addi	sp,sp,-192
    80005f22:	fd06                	sd	ra,184(sp)
    80005f24:	f922                	sd	s0,176(sp)
    80005f26:	f526                	sd	s1,168(sp)
    80005f28:	f14a                	sd	s2,160(sp)
    80005f2a:	ed4e                	sd	s3,152(sp)
    80005f2c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005f2e:	f4c40593          	addi	a1,s0,-180
    80005f32:	4505                	li	a0,1
    80005f34:	ffffd097          	auipc	ra,0xffffd
    80005f38:	3e8080e7          	jalr	1000(ra) # 8000331c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005f3c:	08000613          	li	a2,128
    80005f40:	f5040593          	addi	a1,s0,-176
    80005f44:	4501                	li	a0,0
    80005f46:	ffffd097          	auipc	ra,0xffffd
    80005f4a:	416080e7          	jalr	1046(ra) # 8000335c <argstr>
    80005f4e:	87aa                	mv	a5,a0
    return -1;
    80005f50:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005f52:	0a07c963          	bltz	a5,80006004 <sys_open+0xe4>

  begin_op();
    80005f56:	fffff097          	auipc	ra,0xfffff
    80005f5a:	9ec080e7          	jalr	-1556(ra) # 80004942 <begin_op>

  if(omode & O_CREATE){
    80005f5e:	f4c42783          	lw	a5,-180(s0)
    80005f62:	2007f793          	andi	a5,a5,512
    80005f66:	cfc5                	beqz	a5,8000601e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005f68:	4681                	li	a3,0
    80005f6a:	4601                	li	a2,0
    80005f6c:	4589                	li	a1,2
    80005f6e:	f5040513          	addi	a0,s0,-176
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	972080e7          	jalr	-1678(ra) # 800058e4 <create>
    80005f7a:	84aa                	mv	s1,a0
    if(ip == 0){
    80005f7c:	c959                	beqz	a0,80006012 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005f7e:	04449703          	lh	a4,68(s1)
    80005f82:	478d                	li	a5,3
    80005f84:	00f71763          	bne	a4,a5,80005f92 <sys_open+0x72>
    80005f88:	0464d703          	lhu	a4,70(s1)
    80005f8c:	47a5                	li	a5,9
    80005f8e:	0ce7ed63          	bltu	a5,a4,80006068 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005f92:	fffff097          	auipc	ra,0xfffff
    80005f96:	dbc080e7          	jalr	-580(ra) # 80004d4e <filealloc>
    80005f9a:	89aa                	mv	s3,a0
    80005f9c:	10050363          	beqz	a0,800060a2 <sys_open+0x182>
    80005fa0:	00000097          	auipc	ra,0x0
    80005fa4:	902080e7          	jalr	-1790(ra) # 800058a2 <fdalloc>
    80005fa8:	892a                	mv	s2,a0
    80005faa:	0e054763          	bltz	a0,80006098 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005fae:	04449703          	lh	a4,68(s1)
    80005fb2:	478d                	li	a5,3
    80005fb4:	0cf70563          	beq	a4,a5,8000607e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005fb8:	4789                	li	a5,2
    80005fba:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005fbe:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005fc2:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005fc6:	f4c42783          	lw	a5,-180(s0)
    80005fca:	0017c713          	xori	a4,a5,1
    80005fce:	8b05                	andi	a4,a4,1
    80005fd0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005fd4:	0037f713          	andi	a4,a5,3
    80005fd8:	00e03733          	snez	a4,a4
    80005fdc:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005fe0:	4007f793          	andi	a5,a5,1024
    80005fe4:	c791                	beqz	a5,80005ff0 <sys_open+0xd0>
    80005fe6:	04449703          	lh	a4,68(s1)
    80005fea:	4789                	li	a5,2
    80005fec:	0af70063          	beq	a4,a5,8000608c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005ff0:	8526                	mv	a0,s1
    80005ff2:	ffffe097          	auipc	ra,0xffffe
    80005ff6:	046080e7          	jalr	70(ra) # 80004038 <iunlock>
  end_op();
    80005ffa:	fffff097          	auipc	ra,0xfffff
    80005ffe:	9c6080e7          	jalr	-1594(ra) # 800049c0 <end_op>

  return fd;
    80006002:	854a                	mv	a0,s2
}
    80006004:	70ea                	ld	ra,184(sp)
    80006006:	744a                	ld	s0,176(sp)
    80006008:	74aa                	ld	s1,168(sp)
    8000600a:	790a                	ld	s2,160(sp)
    8000600c:	69ea                	ld	s3,152(sp)
    8000600e:	6129                	addi	sp,sp,192
    80006010:	8082                	ret
      end_op();
    80006012:	fffff097          	auipc	ra,0xfffff
    80006016:	9ae080e7          	jalr	-1618(ra) # 800049c0 <end_op>
      return -1;
    8000601a:	557d                	li	a0,-1
    8000601c:	b7e5                	j	80006004 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    8000601e:	f5040513          	addi	a0,s0,-176
    80006022:	ffffe097          	auipc	ra,0xffffe
    80006026:	700080e7          	jalr	1792(ra) # 80004722 <namei>
    8000602a:	84aa                	mv	s1,a0
    8000602c:	c905                	beqz	a0,8000605c <sys_open+0x13c>
    ilock(ip);
    8000602e:	ffffe097          	auipc	ra,0xffffe
    80006032:	f48080e7          	jalr	-184(ra) # 80003f76 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006036:	04449703          	lh	a4,68(s1)
    8000603a:	4785                	li	a5,1
    8000603c:	f4f711e3          	bne	a4,a5,80005f7e <sys_open+0x5e>
    80006040:	f4c42783          	lw	a5,-180(s0)
    80006044:	d7b9                	beqz	a5,80005f92 <sys_open+0x72>
      iunlockput(ip);
    80006046:	8526                	mv	a0,s1
    80006048:	ffffe097          	auipc	ra,0xffffe
    8000604c:	190080e7          	jalr	400(ra) # 800041d8 <iunlockput>
      end_op();
    80006050:	fffff097          	auipc	ra,0xfffff
    80006054:	970080e7          	jalr	-1680(ra) # 800049c0 <end_op>
      return -1;
    80006058:	557d                	li	a0,-1
    8000605a:	b76d                	j	80006004 <sys_open+0xe4>
      end_op();
    8000605c:	fffff097          	auipc	ra,0xfffff
    80006060:	964080e7          	jalr	-1692(ra) # 800049c0 <end_op>
      return -1;
    80006064:	557d                	li	a0,-1
    80006066:	bf79                	j	80006004 <sys_open+0xe4>
    iunlockput(ip);
    80006068:	8526                	mv	a0,s1
    8000606a:	ffffe097          	auipc	ra,0xffffe
    8000606e:	16e080e7          	jalr	366(ra) # 800041d8 <iunlockput>
    end_op();
    80006072:	fffff097          	auipc	ra,0xfffff
    80006076:	94e080e7          	jalr	-1714(ra) # 800049c0 <end_op>
    return -1;
    8000607a:	557d                	li	a0,-1
    8000607c:	b761                	j	80006004 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000607e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80006082:	04649783          	lh	a5,70(s1)
    80006086:	02f99223          	sh	a5,36(s3)
    8000608a:	bf25                	j	80005fc2 <sys_open+0xa2>
    itrunc(ip);
    8000608c:	8526                	mv	a0,s1
    8000608e:	ffffe097          	auipc	ra,0xffffe
    80006092:	ff6080e7          	jalr	-10(ra) # 80004084 <itrunc>
    80006096:	bfa9                	j	80005ff0 <sys_open+0xd0>
      fileclose(f);
    80006098:	854e                	mv	a0,s3
    8000609a:	fffff097          	auipc	ra,0xfffff
    8000609e:	d70080e7          	jalr	-656(ra) # 80004e0a <fileclose>
    iunlockput(ip);
    800060a2:	8526                	mv	a0,s1
    800060a4:	ffffe097          	auipc	ra,0xffffe
    800060a8:	134080e7          	jalr	308(ra) # 800041d8 <iunlockput>
    end_op();
    800060ac:	fffff097          	auipc	ra,0xfffff
    800060b0:	914080e7          	jalr	-1772(ra) # 800049c0 <end_op>
    return -1;
    800060b4:	557d                	li	a0,-1
    800060b6:	b7b9                	j	80006004 <sys_open+0xe4>

00000000800060b8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800060b8:	7175                	addi	sp,sp,-144
    800060ba:	e506                	sd	ra,136(sp)
    800060bc:	e122                	sd	s0,128(sp)
    800060be:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800060c0:	fffff097          	auipc	ra,0xfffff
    800060c4:	882080e7          	jalr	-1918(ra) # 80004942 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800060c8:	08000613          	li	a2,128
    800060cc:	f7040593          	addi	a1,s0,-144
    800060d0:	4501                	li	a0,0
    800060d2:	ffffd097          	auipc	ra,0xffffd
    800060d6:	28a080e7          	jalr	650(ra) # 8000335c <argstr>
    800060da:	02054963          	bltz	a0,8000610c <sys_mkdir+0x54>
    800060de:	4681                	li	a3,0
    800060e0:	4601                	li	a2,0
    800060e2:	4585                	li	a1,1
    800060e4:	f7040513          	addi	a0,s0,-144
    800060e8:	fffff097          	auipc	ra,0xfffff
    800060ec:	7fc080e7          	jalr	2044(ra) # 800058e4 <create>
    800060f0:	cd11                	beqz	a0,8000610c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800060f2:	ffffe097          	auipc	ra,0xffffe
    800060f6:	0e6080e7          	jalr	230(ra) # 800041d8 <iunlockput>
  end_op();
    800060fa:	fffff097          	auipc	ra,0xfffff
    800060fe:	8c6080e7          	jalr	-1850(ra) # 800049c0 <end_op>
  return 0;
    80006102:	4501                	li	a0,0
}
    80006104:	60aa                	ld	ra,136(sp)
    80006106:	640a                	ld	s0,128(sp)
    80006108:	6149                	addi	sp,sp,144
    8000610a:	8082                	ret
    end_op();
    8000610c:	fffff097          	auipc	ra,0xfffff
    80006110:	8b4080e7          	jalr	-1868(ra) # 800049c0 <end_op>
    return -1;
    80006114:	557d                	li	a0,-1
    80006116:	b7fd                	j	80006104 <sys_mkdir+0x4c>

0000000080006118 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006118:	7135                	addi	sp,sp,-160
    8000611a:	ed06                	sd	ra,152(sp)
    8000611c:	e922                	sd	s0,144(sp)
    8000611e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80006120:	fffff097          	auipc	ra,0xfffff
    80006124:	822080e7          	jalr	-2014(ra) # 80004942 <begin_op>
  argint(1, &major);
    80006128:	f6c40593          	addi	a1,s0,-148
    8000612c:	4505                	li	a0,1
    8000612e:	ffffd097          	auipc	ra,0xffffd
    80006132:	1ee080e7          	jalr	494(ra) # 8000331c <argint>
  argint(2, &minor);
    80006136:	f6840593          	addi	a1,s0,-152
    8000613a:	4509                	li	a0,2
    8000613c:	ffffd097          	auipc	ra,0xffffd
    80006140:	1e0080e7          	jalr	480(ra) # 8000331c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006144:	08000613          	li	a2,128
    80006148:	f7040593          	addi	a1,s0,-144
    8000614c:	4501                	li	a0,0
    8000614e:	ffffd097          	auipc	ra,0xffffd
    80006152:	20e080e7          	jalr	526(ra) # 8000335c <argstr>
    80006156:	02054b63          	bltz	a0,8000618c <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000615a:	f6841683          	lh	a3,-152(s0)
    8000615e:	f6c41603          	lh	a2,-148(s0)
    80006162:	458d                	li	a1,3
    80006164:	f7040513          	addi	a0,s0,-144
    80006168:	fffff097          	auipc	ra,0xfffff
    8000616c:	77c080e7          	jalr	1916(ra) # 800058e4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006170:	cd11                	beqz	a0,8000618c <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006172:	ffffe097          	auipc	ra,0xffffe
    80006176:	066080e7          	jalr	102(ra) # 800041d8 <iunlockput>
  end_op();
    8000617a:	fffff097          	auipc	ra,0xfffff
    8000617e:	846080e7          	jalr	-1978(ra) # 800049c0 <end_op>
  return 0;
    80006182:	4501                	li	a0,0
}
    80006184:	60ea                	ld	ra,152(sp)
    80006186:	644a                	ld	s0,144(sp)
    80006188:	610d                	addi	sp,sp,160
    8000618a:	8082                	ret
    end_op();
    8000618c:	fffff097          	auipc	ra,0xfffff
    80006190:	834080e7          	jalr	-1996(ra) # 800049c0 <end_op>
    return -1;
    80006194:	557d                	li	a0,-1
    80006196:	b7fd                	j	80006184 <sys_mknod+0x6c>

0000000080006198 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006198:	7135                	addi	sp,sp,-160
    8000619a:	ed06                	sd	ra,152(sp)
    8000619c:	e922                	sd	s0,144(sp)
    8000619e:	e526                	sd	s1,136(sp)
    800061a0:	e14a                	sd	s2,128(sp)
    800061a2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800061a4:	ffffc097          	auipc	ra,0xffffc
    800061a8:	b64080e7          	jalr	-1180(ra) # 80001d08 <myproc>
    800061ac:	892a                	mv	s2,a0
  
  begin_op();
    800061ae:	ffffe097          	auipc	ra,0xffffe
    800061b2:	794080e7          	jalr	1940(ra) # 80004942 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800061b6:	08000613          	li	a2,128
    800061ba:	f6040593          	addi	a1,s0,-160
    800061be:	4501                	li	a0,0
    800061c0:	ffffd097          	auipc	ra,0xffffd
    800061c4:	19c080e7          	jalr	412(ra) # 8000335c <argstr>
    800061c8:	04054b63          	bltz	a0,8000621e <sys_chdir+0x86>
    800061cc:	f6040513          	addi	a0,s0,-160
    800061d0:	ffffe097          	auipc	ra,0xffffe
    800061d4:	552080e7          	jalr	1362(ra) # 80004722 <namei>
    800061d8:	84aa                	mv	s1,a0
    800061da:	c131                	beqz	a0,8000621e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800061dc:	ffffe097          	auipc	ra,0xffffe
    800061e0:	d9a080e7          	jalr	-614(ra) # 80003f76 <ilock>
  if(ip->type != T_DIR){
    800061e4:	04449703          	lh	a4,68(s1)
    800061e8:	4785                	li	a5,1
    800061ea:	04f71063          	bne	a4,a5,8000622a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800061ee:	8526                	mv	a0,s1
    800061f0:	ffffe097          	auipc	ra,0xffffe
    800061f4:	e48080e7          	jalr	-440(ra) # 80004038 <iunlock>
  iput(p->cwd);
    800061f8:	15093503          	ld	a0,336(s2)
    800061fc:	ffffe097          	auipc	ra,0xffffe
    80006200:	f34080e7          	jalr	-204(ra) # 80004130 <iput>
  end_op();
    80006204:	ffffe097          	auipc	ra,0xffffe
    80006208:	7bc080e7          	jalr	1980(ra) # 800049c0 <end_op>
  p->cwd = ip;
    8000620c:	14993823          	sd	s1,336(s2)
  return 0;
    80006210:	4501                	li	a0,0
}
    80006212:	60ea                	ld	ra,152(sp)
    80006214:	644a                	ld	s0,144(sp)
    80006216:	64aa                	ld	s1,136(sp)
    80006218:	690a                	ld	s2,128(sp)
    8000621a:	610d                	addi	sp,sp,160
    8000621c:	8082                	ret
    end_op();
    8000621e:	ffffe097          	auipc	ra,0xffffe
    80006222:	7a2080e7          	jalr	1954(ra) # 800049c0 <end_op>
    return -1;
    80006226:	557d                	li	a0,-1
    80006228:	b7ed                	j	80006212 <sys_chdir+0x7a>
    iunlockput(ip);
    8000622a:	8526                	mv	a0,s1
    8000622c:	ffffe097          	auipc	ra,0xffffe
    80006230:	fac080e7          	jalr	-84(ra) # 800041d8 <iunlockput>
    end_op();
    80006234:	ffffe097          	auipc	ra,0xffffe
    80006238:	78c080e7          	jalr	1932(ra) # 800049c0 <end_op>
    return -1;
    8000623c:	557d                	li	a0,-1
    8000623e:	bfd1                	j	80006212 <sys_chdir+0x7a>

0000000080006240 <sys_exec>:

uint64
sys_exec(void)
{
    80006240:	7145                	addi	sp,sp,-464
    80006242:	e786                	sd	ra,456(sp)
    80006244:	e3a2                	sd	s0,448(sp)
    80006246:	ff26                	sd	s1,440(sp)
    80006248:	fb4a                	sd	s2,432(sp)
    8000624a:	f74e                	sd	s3,424(sp)
    8000624c:	f352                	sd	s4,416(sp)
    8000624e:	ef56                	sd	s5,408(sp)
    80006250:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006252:	e3840593          	addi	a1,s0,-456
    80006256:	4505                	li	a0,1
    80006258:	ffffd097          	auipc	ra,0xffffd
    8000625c:	0e4080e7          	jalr	228(ra) # 8000333c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006260:	08000613          	li	a2,128
    80006264:	f4040593          	addi	a1,s0,-192
    80006268:	4501                	li	a0,0
    8000626a:	ffffd097          	auipc	ra,0xffffd
    8000626e:	0f2080e7          	jalr	242(ra) # 8000335c <argstr>
    80006272:	87aa                	mv	a5,a0
    return -1;
    80006274:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006276:	0c07c363          	bltz	a5,8000633c <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000627a:	10000613          	li	a2,256
    8000627e:	4581                	li	a1,0
    80006280:	e4040513          	addi	a0,s0,-448
    80006284:	ffffb097          	auipc	ra,0xffffb
    80006288:	b24080e7          	jalr	-1244(ra) # 80000da8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000628c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80006290:	89a6                	mv	s3,s1
    80006292:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006294:	02000a13          	li	s4,32
    80006298:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000629c:	00391513          	slli	a0,s2,0x3
    800062a0:	e3040593          	addi	a1,s0,-464
    800062a4:	e3843783          	ld	a5,-456(s0)
    800062a8:	953e                	add	a0,a0,a5
    800062aa:	ffffd097          	auipc	ra,0xffffd
    800062ae:	fd4080e7          	jalr	-44(ra) # 8000327e <fetchaddr>
    800062b2:	02054a63          	bltz	a0,800062e6 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800062b6:	e3043783          	ld	a5,-464(s0)
    800062ba:	c3b9                	beqz	a5,80006300 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800062bc:	ffffb097          	auipc	ra,0xffffb
    800062c0:	8e2080e7          	jalr	-1822(ra) # 80000b9e <kalloc>
    800062c4:	85aa                	mv	a1,a0
    800062c6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800062ca:	cd11                	beqz	a0,800062e6 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800062cc:	6605                	lui	a2,0x1
    800062ce:	e3043503          	ld	a0,-464(s0)
    800062d2:	ffffd097          	auipc	ra,0xffffd
    800062d6:	ffe080e7          	jalr	-2(ra) # 800032d0 <fetchstr>
    800062da:	00054663          	bltz	a0,800062e6 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800062de:	0905                	addi	s2,s2,1
    800062e0:	09a1                	addi	s3,s3,8
    800062e2:	fb491be3          	bne	s2,s4,80006298 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062e6:	f4040913          	addi	s2,s0,-192
    800062ea:	6088                	ld	a0,0(s1)
    800062ec:	c539                	beqz	a0,8000633a <sys_exec+0xfa>
    kfree(argv[i]);
    800062ee:	ffffa097          	auipc	ra,0xffffa
    800062f2:	74a080e7          	jalr	1866(ra) # 80000a38 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062f6:	04a1                	addi	s1,s1,8
    800062f8:	ff2499e3          	bne	s1,s2,800062ea <sys_exec+0xaa>
  return -1;
    800062fc:	557d                	li	a0,-1
    800062fe:	a83d                	j	8000633c <sys_exec+0xfc>
      argv[i] = 0;
    80006300:	0a8e                	slli	s5,s5,0x3
    80006302:	fc0a8793          	addi	a5,s5,-64
    80006306:	00878ab3          	add	s5,a5,s0
    8000630a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000630e:	e4040593          	addi	a1,s0,-448
    80006312:	f4040513          	addi	a0,s0,-192
    80006316:	fffff097          	auipc	ra,0xfffff
    8000631a:	16e080e7          	jalr	366(ra) # 80005484 <exec>
    8000631e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006320:	f4040993          	addi	s3,s0,-192
    80006324:	6088                	ld	a0,0(s1)
    80006326:	c901                	beqz	a0,80006336 <sys_exec+0xf6>
    kfree(argv[i]);
    80006328:	ffffa097          	auipc	ra,0xffffa
    8000632c:	710080e7          	jalr	1808(ra) # 80000a38 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006330:	04a1                	addi	s1,s1,8
    80006332:	ff3499e3          	bne	s1,s3,80006324 <sys_exec+0xe4>
  return ret;
    80006336:	854a                	mv	a0,s2
    80006338:	a011                	j	8000633c <sys_exec+0xfc>
  return -1;
    8000633a:	557d                	li	a0,-1
}
    8000633c:	60be                	ld	ra,456(sp)
    8000633e:	641e                	ld	s0,448(sp)
    80006340:	74fa                	ld	s1,440(sp)
    80006342:	795a                	ld	s2,432(sp)
    80006344:	79ba                	ld	s3,424(sp)
    80006346:	7a1a                	ld	s4,416(sp)
    80006348:	6afa                	ld	s5,408(sp)
    8000634a:	6179                	addi	sp,sp,464
    8000634c:	8082                	ret

000000008000634e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000634e:	7139                	addi	sp,sp,-64
    80006350:	fc06                	sd	ra,56(sp)
    80006352:	f822                	sd	s0,48(sp)
    80006354:	f426                	sd	s1,40(sp)
    80006356:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006358:	ffffc097          	auipc	ra,0xffffc
    8000635c:	9b0080e7          	jalr	-1616(ra) # 80001d08 <myproc>
    80006360:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006362:	fd840593          	addi	a1,s0,-40
    80006366:	4501                	li	a0,0
    80006368:	ffffd097          	auipc	ra,0xffffd
    8000636c:	fd4080e7          	jalr	-44(ra) # 8000333c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006370:	fc840593          	addi	a1,s0,-56
    80006374:	fd040513          	addi	a0,s0,-48
    80006378:	fffff097          	auipc	ra,0xfffff
    8000637c:	dc2080e7          	jalr	-574(ra) # 8000513a <pipealloc>
    return -1;
    80006380:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006382:	0c054463          	bltz	a0,8000644a <sys_pipe+0xfc>
  fd0 = -1;
    80006386:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000638a:	fd043503          	ld	a0,-48(s0)
    8000638e:	fffff097          	auipc	ra,0xfffff
    80006392:	514080e7          	jalr	1300(ra) # 800058a2 <fdalloc>
    80006396:	fca42223          	sw	a0,-60(s0)
    8000639a:	08054b63          	bltz	a0,80006430 <sys_pipe+0xe2>
    8000639e:	fc843503          	ld	a0,-56(s0)
    800063a2:	fffff097          	auipc	ra,0xfffff
    800063a6:	500080e7          	jalr	1280(ra) # 800058a2 <fdalloc>
    800063aa:	fca42023          	sw	a0,-64(s0)
    800063ae:	06054863          	bltz	a0,8000641e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800063b2:	4691                	li	a3,4
    800063b4:	fc440613          	addi	a2,s0,-60
    800063b8:	fd843583          	ld	a1,-40(s0)
    800063bc:	68a8                	ld	a0,80(s1)
    800063be:	ffffb097          	auipc	ra,0xffffb
    800063c2:	60a080e7          	jalr	1546(ra) # 800019c8 <copyout>
    800063c6:	02054063          	bltz	a0,800063e6 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800063ca:	4691                	li	a3,4
    800063cc:	fc040613          	addi	a2,s0,-64
    800063d0:	fd843583          	ld	a1,-40(s0)
    800063d4:	0591                	addi	a1,a1,4
    800063d6:	68a8                	ld	a0,80(s1)
    800063d8:	ffffb097          	auipc	ra,0xffffb
    800063dc:	5f0080e7          	jalr	1520(ra) # 800019c8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800063e0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800063e2:	06055463          	bgez	a0,8000644a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800063e6:	fc442783          	lw	a5,-60(s0)
    800063ea:	07e9                	addi	a5,a5,26
    800063ec:	078e                	slli	a5,a5,0x3
    800063ee:	97a6                	add	a5,a5,s1
    800063f0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800063f4:	fc042783          	lw	a5,-64(s0)
    800063f8:	07e9                	addi	a5,a5,26
    800063fa:	078e                	slli	a5,a5,0x3
    800063fc:	94be                	add	s1,s1,a5
    800063fe:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006402:	fd043503          	ld	a0,-48(s0)
    80006406:	fffff097          	auipc	ra,0xfffff
    8000640a:	a04080e7          	jalr	-1532(ra) # 80004e0a <fileclose>
    fileclose(wf);
    8000640e:	fc843503          	ld	a0,-56(s0)
    80006412:	fffff097          	auipc	ra,0xfffff
    80006416:	9f8080e7          	jalr	-1544(ra) # 80004e0a <fileclose>
    return -1;
    8000641a:	57fd                	li	a5,-1
    8000641c:	a03d                	j	8000644a <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000641e:	fc442783          	lw	a5,-60(s0)
    80006422:	0007c763          	bltz	a5,80006430 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006426:	07e9                	addi	a5,a5,26
    80006428:	078e                	slli	a5,a5,0x3
    8000642a:	97a6                	add	a5,a5,s1
    8000642c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006430:	fd043503          	ld	a0,-48(s0)
    80006434:	fffff097          	auipc	ra,0xfffff
    80006438:	9d6080e7          	jalr	-1578(ra) # 80004e0a <fileclose>
    fileclose(wf);
    8000643c:	fc843503          	ld	a0,-56(s0)
    80006440:	fffff097          	auipc	ra,0xfffff
    80006444:	9ca080e7          	jalr	-1590(ra) # 80004e0a <fileclose>
    return -1;
    80006448:	57fd                	li	a5,-1
}
    8000644a:	853e                	mv	a0,a5
    8000644c:	70e2                	ld	ra,56(sp)
    8000644e:	7442                	ld	s0,48(sp)
    80006450:	74a2                	ld	s1,40(sp)
    80006452:	6121                	addi	sp,sp,64
    80006454:	8082                	ret
	...

0000000080006460 <kernelvec>:
    80006460:	7111                	addi	sp,sp,-256
    80006462:	e006                	sd	ra,0(sp)
    80006464:	e40a                	sd	sp,8(sp)
    80006466:	e80e                	sd	gp,16(sp)
    80006468:	ec12                	sd	tp,24(sp)
    8000646a:	f016                	sd	t0,32(sp)
    8000646c:	f41a                	sd	t1,40(sp)
    8000646e:	f81e                	sd	t2,48(sp)
    80006470:	fc22                	sd	s0,56(sp)
    80006472:	e0a6                	sd	s1,64(sp)
    80006474:	e4aa                	sd	a0,72(sp)
    80006476:	e8ae                	sd	a1,80(sp)
    80006478:	ecb2                	sd	a2,88(sp)
    8000647a:	f0b6                	sd	a3,96(sp)
    8000647c:	f4ba                	sd	a4,104(sp)
    8000647e:	f8be                	sd	a5,112(sp)
    80006480:	fcc2                	sd	a6,120(sp)
    80006482:	e146                	sd	a7,128(sp)
    80006484:	e54a                	sd	s2,136(sp)
    80006486:	e94e                	sd	s3,144(sp)
    80006488:	ed52                	sd	s4,152(sp)
    8000648a:	f156                	sd	s5,160(sp)
    8000648c:	f55a                	sd	s6,168(sp)
    8000648e:	f95e                	sd	s7,176(sp)
    80006490:	fd62                	sd	s8,184(sp)
    80006492:	e1e6                	sd	s9,192(sp)
    80006494:	e5ea                	sd	s10,200(sp)
    80006496:	e9ee                	sd	s11,208(sp)
    80006498:	edf2                	sd	t3,216(sp)
    8000649a:	f1f6                	sd	t4,224(sp)
    8000649c:	f5fa                	sd	t5,232(sp)
    8000649e:	f9fe                	sd	t6,240(sp)
    800064a0:	cabfc0ef          	jal	ra,8000314a <kerneltrap>
    800064a4:	6082                	ld	ra,0(sp)
    800064a6:	6122                	ld	sp,8(sp)
    800064a8:	61c2                	ld	gp,16(sp)
    800064aa:	7282                	ld	t0,32(sp)
    800064ac:	7322                	ld	t1,40(sp)
    800064ae:	73c2                	ld	t2,48(sp)
    800064b0:	7462                	ld	s0,56(sp)
    800064b2:	6486                	ld	s1,64(sp)
    800064b4:	6526                	ld	a0,72(sp)
    800064b6:	65c6                	ld	a1,80(sp)
    800064b8:	6666                	ld	a2,88(sp)
    800064ba:	7686                	ld	a3,96(sp)
    800064bc:	7726                	ld	a4,104(sp)
    800064be:	77c6                	ld	a5,112(sp)
    800064c0:	7866                	ld	a6,120(sp)
    800064c2:	688a                	ld	a7,128(sp)
    800064c4:	692a                	ld	s2,136(sp)
    800064c6:	69ca                	ld	s3,144(sp)
    800064c8:	6a6a                	ld	s4,152(sp)
    800064ca:	7a8a                	ld	s5,160(sp)
    800064cc:	7b2a                	ld	s6,168(sp)
    800064ce:	7bca                	ld	s7,176(sp)
    800064d0:	7c6a                	ld	s8,184(sp)
    800064d2:	6c8e                	ld	s9,192(sp)
    800064d4:	6d2e                	ld	s10,200(sp)
    800064d6:	6dce                	ld	s11,208(sp)
    800064d8:	6e6e                	ld	t3,216(sp)
    800064da:	7e8e                	ld	t4,224(sp)
    800064dc:	7f2e                	ld	t5,232(sp)
    800064de:	7fce                	ld	t6,240(sp)
    800064e0:	6111                	addi	sp,sp,256
    800064e2:	10200073          	sret
    800064e6:	00000013          	nop
    800064ea:	00000013          	nop
    800064ee:	0001                	nop

00000000800064f0 <timervec>:
    800064f0:	34051573          	csrrw	a0,mscratch,a0
    800064f4:	e10c                	sd	a1,0(a0)
    800064f6:	e510                	sd	a2,8(a0)
    800064f8:	e914                	sd	a3,16(a0)
    800064fa:	6d0c                	ld	a1,24(a0)
    800064fc:	7110                	ld	a2,32(a0)
    800064fe:	6194                	ld	a3,0(a1)
    80006500:	96b2                	add	a3,a3,a2
    80006502:	e194                	sd	a3,0(a1)
    80006504:	4589                	li	a1,2
    80006506:	14459073          	csrw	sip,a1
    8000650a:	6914                	ld	a3,16(a0)
    8000650c:	6510                	ld	a2,8(a0)
    8000650e:	610c                	ld	a1,0(a0)
    80006510:	34051573          	csrrw	a0,mscratch,a0
    80006514:	30200073          	mret
	...

000000008000651a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000651a:	1141                	addi	sp,sp,-16
    8000651c:	e422                	sd	s0,8(sp)
    8000651e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006520:	0c0007b7          	lui	a5,0xc000
    80006524:	4705                	li	a4,1
    80006526:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006528:	c3d8                	sw	a4,4(a5)
}
    8000652a:	6422                	ld	s0,8(sp)
    8000652c:	0141                	addi	sp,sp,16
    8000652e:	8082                	ret

0000000080006530 <plicinithart>:

void
plicinithart(void)
{
    80006530:	1141                	addi	sp,sp,-16
    80006532:	e406                	sd	ra,8(sp)
    80006534:	e022                	sd	s0,0(sp)
    80006536:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006538:	ffffb097          	auipc	ra,0xffffb
    8000653c:	7a4080e7          	jalr	1956(ra) # 80001cdc <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006540:	0085171b          	slliw	a4,a0,0x8
    80006544:	0c0027b7          	lui	a5,0xc002
    80006548:	97ba                	add	a5,a5,a4
    8000654a:	40200713          	li	a4,1026
    8000654e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006552:	00d5151b          	slliw	a0,a0,0xd
    80006556:	0c2017b7          	lui	a5,0xc201
    8000655a:	97aa                	add	a5,a5,a0
    8000655c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006560:	60a2                	ld	ra,8(sp)
    80006562:	6402                	ld	s0,0(sp)
    80006564:	0141                	addi	sp,sp,16
    80006566:	8082                	ret

0000000080006568 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006568:	1141                	addi	sp,sp,-16
    8000656a:	e406                	sd	ra,8(sp)
    8000656c:	e022                	sd	s0,0(sp)
    8000656e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006570:	ffffb097          	auipc	ra,0xffffb
    80006574:	76c080e7          	jalr	1900(ra) # 80001cdc <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006578:	00d5151b          	slliw	a0,a0,0xd
    8000657c:	0c2017b7          	lui	a5,0xc201
    80006580:	97aa                	add	a5,a5,a0
  return irq;
}
    80006582:	43c8                	lw	a0,4(a5)
    80006584:	60a2                	ld	ra,8(sp)
    80006586:	6402                	ld	s0,0(sp)
    80006588:	0141                	addi	sp,sp,16
    8000658a:	8082                	ret

000000008000658c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000658c:	1101                	addi	sp,sp,-32
    8000658e:	ec06                	sd	ra,24(sp)
    80006590:	e822                	sd	s0,16(sp)
    80006592:	e426                	sd	s1,8(sp)
    80006594:	1000                	addi	s0,sp,32
    80006596:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006598:	ffffb097          	auipc	ra,0xffffb
    8000659c:	744080e7          	jalr	1860(ra) # 80001cdc <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800065a0:	00d5151b          	slliw	a0,a0,0xd
    800065a4:	0c2017b7          	lui	a5,0xc201
    800065a8:	97aa                	add	a5,a5,a0
    800065aa:	c3c4                	sw	s1,4(a5)
}
    800065ac:	60e2                	ld	ra,24(sp)
    800065ae:	6442                	ld	s0,16(sp)
    800065b0:	64a2                	ld	s1,8(sp)
    800065b2:	6105                	addi	sp,sp,32
    800065b4:	8082                	ret

00000000800065b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800065b6:	1141                	addi	sp,sp,-16
    800065b8:	e406                	sd	ra,8(sp)
    800065ba:	e022                	sd	s0,0(sp)
    800065bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800065be:	479d                	li	a5,7
    800065c0:	04a7cc63          	blt	a5,a0,80006618 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800065c4:	00064797          	auipc	a5,0x64
    800065c8:	8fc78793          	addi	a5,a5,-1796 # 80069ec0 <disk>
    800065cc:	97aa                	add	a5,a5,a0
    800065ce:	0187c783          	lbu	a5,24(a5)
    800065d2:	ebb9                	bnez	a5,80006628 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800065d4:	00451693          	slli	a3,a0,0x4
    800065d8:	00064797          	auipc	a5,0x64
    800065dc:	8e878793          	addi	a5,a5,-1816 # 80069ec0 <disk>
    800065e0:	6398                	ld	a4,0(a5)
    800065e2:	9736                	add	a4,a4,a3
    800065e4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800065e8:	6398                	ld	a4,0(a5)
    800065ea:	9736                	add	a4,a4,a3
    800065ec:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800065f0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800065f4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800065f8:	97aa                	add	a5,a5,a0
    800065fa:	4705                	li	a4,1
    800065fc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006600:	00064517          	auipc	a0,0x64
    80006604:	8d850513          	addi	a0,a0,-1832 # 80069ed8 <disk+0x18>
    80006608:	ffffc097          	auipc	ra,0xffffc
    8000660c:	010080e7          	jalr	16(ra) # 80002618 <wakeup>
}
    80006610:	60a2                	ld	ra,8(sp)
    80006612:	6402                	ld	s0,0(sp)
    80006614:	0141                	addi	sp,sp,16
    80006616:	8082                	ret
    panic("free_desc 1");
    80006618:	00002517          	auipc	a0,0x2
    8000661c:	1c850513          	addi	a0,a0,456 # 800087e0 <syscalls+0x310>
    80006620:	ffffa097          	auipc	ra,0xffffa
    80006624:	f20080e7          	jalr	-224(ra) # 80000540 <panic>
    panic("free_desc 2");
    80006628:	00002517          	auipc	a0,0x2
    8000662c:	1c850513          	addi	a0,a0,456 # 800087f0 <syscalls+0x320>
    80006630:	ffffa097          	auipc	ra,0xffffa
    80006634:	f10080e7          	jalr	-240(ra) # 80000540 <panic>

0000000080006638 <virtio_disk_init>:
{
    80006638:	1101                	addi	sp,sp,-32
    8000663a:	ec06                	sd	ra,24(sp)
    8000663c:	e822                	sd	s0,16(sp)
    8000663e:	e426                	sd	s1,8(sp)
    80006640:	e04a                	sd	s2,0(sp)
    80006642:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006644:	00002597          	auipc	a1,0x2
    80006648:	1bc58593          	addi	a1,a1,444 # 80008800 <syscalls+0x330>
    8000664c:	00064517          	auipc	a0,0x64
    80006650:	99c50513          	addi	a0,a0,-1636 # 80069fe8 <disk+0x128>
    80006654:	ffffa097          	auipc	ra,0xffffa
    80006658:	5c8080e7          	jalr	1480(ra) # 80000c1c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000665c:	100017b7          	lui	a5,0x10001
    80006660:	4398                	lw	a4,0(a5)
    80006662:	2701                	sext.w	a4,a4
    80006664:	747277b7          	lui	a5,0x74727
    80006668:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000666c:	14f71b63          	bne	a4,a5,800067c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006670:	100017b7          	lui	a5,0x10001
    80006674:	43dc                	lw	a5,4(a5)
    80006676:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006678:	4709                	li	a4,2
    8000667a:	14e79463          	bne	a5,a4,800067c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000667e:	100017b7          	lui	a5,0x10001
    80006682:	479c                	lw	a5,8(a5)
    80006684:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006686:	12e79e63          	bne	a5,a4,800067c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000668a:	100017b7          	lui	a5,0x10001
    8000668e:	47d8                	lw	a4,12(a5)
    80006690:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006692:	554d47b7          	lui	a5,0x554d4
    80006696:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000669a:	12f71463          	bne	a4,a5,800067c2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000669e:	100017b7          	lui	a5,0x10001
    800066a2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800066a6:	4705                	li	a4,1
    800066a8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800066aa:	470d                	li	a4,3
    800066ac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800066ae:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800066b0:	c7ffe6b7          	lui	a3,0xc7ffe
    800066b4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f9475f>
    800066b8:	8f75                	and	a4,a4,a3
    800066ba:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800066bc:	472d                	li	a4,11
    800066be:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800066c0:	5bbc                	lw	a5,112(a5)
    800066c2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800066c6:	8ba1                	andi	a5,a5,8
    800066c8:	10078563          	beqz	a5,800067d2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800066cc:	100017b7          	lui	a5,0x10001
    800066d0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800066d4:	43fc                	lw	a5,68(a5)
    800066d6:	2781                	sext.w	a5,a5
    800066d8:	10079563          	bnez	a5,800067e2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800066dc:	100017b7          	lui	a5,0x10001
    800066e0:	5bdc                	lw	a5,52(a5)
    800066e2:	2781                	sext.w	a5,a5
  if(max == 0)
    800066e4:	10078763          	beqz	a5,800067f2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800066e8:	471d                	li	a4,7
    800066ea:	10f77c63          	bgeu	a4,a5,80006802 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800066ee:	ffffa097          	auipc	ra,0xffffa
    800066f2:	4b0080e7          	jalr	1200(ra) # 80000b9e <kalloc>
    800066f6:	00063497          	auipc	s1,0x63
    800066fa:	7ca48493          	addi	s1,s1,1994 # 80069ec0 <disk>
    800066fe:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006700:	ffffa097          	auipc	ra,0xffffa
    80006704:	49e080e7          	jalr	1182(ra) # 80000b9e <kalloc>
    80006708:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000670a:	ffffa097          	auipc	ra,0xffffa
    8000670e:	494080e7          	jalr	1172(ra) # 80000b9e <kalloc>
    80006712:	87aa                	mv	a5,a0
    80006714:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006716:	6088                	ld	a0,0(s1)
    80006718:	cd6d                	beqz	a0,80006812 <virtio_disk_init+0x1da>
    8000671a:	00063717          	auipc	a4,0x63
    8000671e:	7ae73703          	ld	a4,1966(a4) # 80069ec8 <disk+0x8>
    80006722:	cb65                	beqz	a4,80006812 <virtio_disk_init+0x1da>
    80006724:	c7fd                	beqz	a5,80006812 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006726:	6605                	lui	a2,0x1
    80006728:	4581                	li	a1,0
    8000672a:	ffffa097          	auipc	ra,0xffffa
    8000672e:	67e080e7          	jalr	1662(ra) # 80000da8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006732:	00063497          	auipc	s1,0x63
    80006736:	78e48493          	addi	s1,s1,1934 # 80069ec0 <disk>
    8000673a:	6605                	lui	a2,0x1
    8000673c:	4581                	li	a1,0
    8000673e:	6488                	ld	a0,8(s1)
    80006740:	ffffa097          	auipc	ra,0xffffa
    80006744:	668080e7          	jalr	1640(ra) # 80000da8 <memset>
  memset(disk.used, 0, PGSIZE);
    80006748:	6605                	lui	a2,0x1
    8000674a:	4581                	li	a1,0
    8000674c:	6888                	ld	a0,16(s1)
    8000674e:	ffffa097          	auipc	ra,0xffffa
    80006752:	65a080e7          	jalr	1626(ra) # 80000da8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006756:	100017b7          	lui	a5,0x10001
    8000675a:	4721                	li	a4,8
    8000675c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000675e:	4098                	lw	a4,0(s1)
    80006760:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006764:	40d8                	lw	a4,4(s1)
    80006766:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000676a:	6498                	ld	a4,8(s1)
    8000676c:	0007069b          	sext.w	a3,a4
    80006770:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006774:	9701                	srai	a4,a4,0x20
    80006776:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000677a:	6898                	ld	a4,16(s1)
    8000677c:	0007069b          	sext.w	a3,a4
    80006780:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006784:	9701                	srai	a4,a4,0x20
    80006786:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000678a:	4705                	li	a4,1
    8000678c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000678e:	00e48c23          	sb	a4,24(s1)
    80006792:	00e48ca3          	sb	a4,25(s1)
    80006796:	00e48d23          	sb	a4,26(s1)
    8000679a:	00e48da3          	sb	a4,27(s1)
    8000679e:	00e48e23          	sb	a4,28(s1)
    800067a2:	00e48ea3          	sb	a4,29(s1)
    800067a6:	00e48f23          	sb	a4,30(s1)
    800067aa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800067ae:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800067b2:	0727a823          	sw	s2,112(a5)
}
    800067b6:	60e2                	ld	ra,24(sp)
    800067b8:	6442                	ld	s0,16(sp)
    800067ba:	64a2                	ld	s1,8(sp)
    800067bc:	6902                	ld	s2,0(sp)
    800067be:	6105                	addi	sp,sp,32
    800067c0:	8082                	ret
    panic("could not find virtio disk");
    800067c2:	00002517          	auipc	a0,0x2
    800067c6:	04e50513          	addi	a0,a0,78 # 80008810 <syscalls+0x340>
    800067ca:	ffffa097          	auipc	ra,0xffffa
    800067ce:	d76080e7          	jalr	-650(ra) # 80000540 <panic>
    panic("virtio disk FEATURES_OK unset");
    800067d2:	00002517          	auipc	a0,0x2
    800067d6:	05e50513          	addi	a0,a0,94 # 80008830 <syscalls+0x360>
    800067da:	ffffa097          	auipc	ra,0xffffa
    800067de:	d66080e7          	jalr	-666(ra) # 80000540 <panic>
    panic("virtio disk should not be ready");
    800067e2:	00002517          	auipc	a0,0x2
    800067e6:	06e50513          	addi	a0,a0,110 # 80008850 <syscalls+0x380>
    800067ea:	ffffa097          	auipc	ra,0xffffa
    800067ee:	d56080e7          	jalr	-682(ra) # 80000540 <panic>
    panic("virtio disk has no queue 0");
    800067f2:	00002517          	auipc	a0,0x2
    800067f6:	07e50513          	addi	a0,a0,126 # 80008870 <syscalls+0x3a0>
    800067fa:	ffffa097          	auipc	ra,0xffffa
    800067fe:	d46080e7          	jalr	-698(ra) # 80000540 <panic>
    panic("virtio disk max queue too short");
    80006802:	00002517          	auipc	a0,0x2
    80006806:	08e50513          	addi	a0,a0,142 # 80008890 <syscalls+0x3c0>
    8000680a:	ffffa097          	auipc	ra,0xffffa
    8000680e:	d36080e7          	jalr	-714(ra) # 80000540 <panic>
    panic("virtio disk kalloc");
    80006812:	00002517          	auipc	a0,0x2
    80006816:	09e50513          	addi	a0,a0,158 # 800088b0 <syscalls+0x3e0>
    8000681a:	ffffa097          	auipc	ra,0xffffa
    8000681e:	d26080e7          	jalr	-730(ra) # 80000540 <panic>

0000000080006822 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006822:	7119                	addi	sp,sp,-128
    80006824:	fc86                	sd	ra,120(sp)
    80006826:	f8a2                	sd	s0,112(sp)
    80006828:	f4a6                	sd	s1,104(sp)
    8000682a:	f0ca                	sd	s2,96(sp)
    8000682c:	ecce                	sd	s3,88(sp)
    8000682e:	e8d2                	sd	s4,80(sp)
    80006830:	e4d6                	sd	s5,72(sp)
    80006832:	e0da                	sd	s6,64(sp)
    80006834:	fc5e                	sd	s7,56(sp)
    80006836:	f862                	sd	s8,48(sp)
    80006838:	f466                	sd	s9,40(sp)
    8000683a:	f06a                	sd	s10,32(sp)
    8000683c:	ec6e                	sd	s11,24(sp)
    8000683e:	0100                	addi	s0,sp,128
    80006840:	8aaa                	mv	s5,a0
    80006842:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006844:	00c52d03          	lw	s10,12(a0)
    80006848:	001d1d1b          	slliw	s10,s10,0x1
    8000684c:	1d02                	slli	s10,s10,0x20
    8000684e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006852:	00063517          	auipc	a0,0x63
    80006856:	79650513          	addi	a0,a0,1942 # 80069fe8 <disk+0x128>
    8000685a:	ffffa097          	auipc	ra,0xffffa
    8000685e:	452080e7          	jalr	1106(ra) # 80000cac <acquire>
  for(int i = 0; i < 3; i++){
    80006862:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006864:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006866:	00063b97          	auipc	s7,0x63
    8000686a:	65ab8b93          	addi	s7,s7,1626 # 80069ec0 <disk>
  for(int i = 0; i < 3; i++){
    8000686e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006870:	00063c97          	auipc	s9,0x63
    80006874:	778c8c93          	addi	s9,s9,1912 # 80069fe8 <disk+0x128>
    80006878:	a08d                	j	800068da <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000687a:	00fb8733          	add	a4,s7,a5
    8000687e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006882:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006884:	0207c563          	bltz	a5,800068ae <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80006888:	2905                	addiw	s2,s2,1
    8000688a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000688c:	05690c63          	beq	s2,s6,800068e4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006890:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006892:	00063717          	auipc	a4,0x63
    80006896:	62e70713          	addi	a4,a4,1582 # 80069ec0 <disk>
    8000689a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000689c:	01874683          	lbu	a3,24(a4)
    800068a0:	fee9                	bnez	a3,8000687a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800068a2:	2785                	addiw	a5,a5,1
    800068a4:	0705                	addi	a4,a4,1
    800068a6:	fe979be3          	bne	a5,s1,8000689c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800068aa:	57fd                	li	a5,-1
    800068ac:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800068ae:	01205d63          	blez	s2,800068c8 <virtio_disk_rw+0xa6>
    800068b2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800068b4:	000a2503          	lw	a0,0(s4)
    800068b8:	00000097          	auipc	ra,0x0
    800068bc:	cfe080e7          	jalr	-770(ra) # 800065b6 <free_desc>
      for(int j = 0; j < i; j++)
    800068c0:	2d85                	addiw	s11,s11,1
    800068c2:	0a11                	addi	s4,s4,4
    800068c4:	ff2d98e3          	bne	s11,s2,800068b4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800068c8:	85e6                	mv	a1,s9
    800068ca:	00063517          	auipc	a0,0x63
    800068ce:	60e50513          	addi	a0,a0,1550 # 80069ed8 <disk+0x18>
    800068d2:	ffffc097          	auipc	ra,0xffffc
    800068d6:	ce2080e7          	jalr	-798(ra) # 800025b4 <sleep>
  for(int i = 0; i < 3; i++){
    800068da:	f8040a13          	addi	s4,s0,-128
{
    800068de:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800068e0:	894e                	mv	s2,s3
    800068e2:	b77d                	j	80006890 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800068e4:	f8042503          	lw	a0,-128(s0)
    800068e8:	00a50713          	addi	a4,a0,10
    800068ec:	0712                	slli	a4,a4,0x4

  if(write)
    800068ee:	00063797          	auipc	a5,0x63
    800068f2:	5d278793          	addi	a5,a5,1490 # 80069ec0 <disk>
    800068f6:	00e786b3          	add	a3,a5,a4
    800068fa:	01803633          	snez	a2,s8
    800068fe:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006900:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006904:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006908:	f6070613          	addi	a2,a4,-160
    8000690c:	6394                	ld	a3,0(a5)
    8000690e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006910:	00870593          	addi	a1,a4,8
    80006914:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006916:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006918:	0007b803          	ld	a6,0(a5)
    8000691c:	9642                	add	a2,a2,a6
    8000691e:	46c1                	li	a3,16
    80006920:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006922:	4585                	li	a1,1
    80006924:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80006928:	f8442683          	lw	a3,-124(s0)
    8000692c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006930:	0692                	slli	a3,a3,0x4
    80006932:	9836                	add	a6,a6,a3
    80006934:	058a8613          	addi	a2,s5,88
    80006938:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000693c:	0007b803          	ld	a6,0(a5)
    80006940:	96c2                	add	a3,a3,a6
    80006942:	40000613          	li	a2,1024
    80006946:	c690                	sw	a2,8(a3)
  if(write)
    80006948:	001c3613          	seqz	a2,s8
    8000694c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006950:	00166613          	ori	a2,a2,1
    80006954:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006958:	f8842603          	lw	a2,-120(s0)
    8000695c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006960:	00250693          	addi	a3,a0,2
    80006964:	0692                	slli	a3,a3,0x4
    80006966:	96be                	add	a3,a3,a5
    80006968:	58fd                	li	a7,-1
    8000696a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000696e:	0612                	slli	a2,a2,0x4
    80006970:	9832                	add	a6,a6,a2
    80006972:	f9070713          	addi	a4,a4,-112
    80006976:	973e                	add	a4,a4,a5
    80006978:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000697c:	6398                	ld	a4,0(a5)
    8000697e:	9732                	add	a4,a4,a2
    80006980:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006982:	4609                	li	a2,2
    80006984:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80006988:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000698c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80006990:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006994:	6794                	ld	a3,8(a5)
    80006996:	0026d703          	lhu	a4,2(a3)
    8000699a:	8b1d                	andi	a4,a4,7
    8000699c:	0706                	slli	a4,a4,0x1
    8000699e:	96ba                	add	a3,a3,a4
    800069a0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800069a4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800069a8:	6798                	ld	a4,8(a5)
    800069aa:	00275783          	lhu	a5,2(a4)
    800069ae:	2785                	addiw	a5,a5,1
    800069b0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800069b4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800069b8:	100017b7          	lui	a5,0x10001
    800069bc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800069c0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800069c4:	00063917          	auipc	s2,0x63
    800069c8:	62490913          	addi	s2,s2,1572 # 80069fe8 <disk+0x128>
  while(b->disk == 1) {
    800069cc:	4485                	li	s1,1
    800069ce:	00b79c63          	bne	a5,a1,800069e6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800069d2:	85ca                	mv	a1,s2
    800069d4:	8556                	mv	a0,s5
    800069d6:	ffffc097          	auipc	ra,0xffffc
    800069da:	bde080e7          	jalr	-1058(ra) # 800025b4 <sleep>
  while(b->disk == 1) {
    800069de:	004aa783          	lw	a5,4(s5)
    800069e2:	fe9788e3          	beq	a5,s1,800069d2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800069e6:	f8042903          	lw	s2,-128(s0)
    800069ea:	00290713          	addi	a4,s2,2
    800069ee:	0712                	slli	a4,a4,0x4
    800069f0:	00063797          	auipc	a5,0x63
    800069f4:	4d078793          	addi	a5,a5,1232 # 80069ec0 <disk>
    800069f8:	97ba                	add	a5,a5,a4
    800069fa:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800069fe:	00063997          	auipc	s3,0x63
    80006a02:	4c298993          	addi	s3,s3,1218 # 80069ec0 <disk>
    80006a06:	00491713          	slli	a4,s2,0x4
    80006a0a:	0009b783          	ld	a5,0(s3)
    80006a0e:	97ba                	add	a5,a5,a4
    80006a10:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006a14:	854a                	mv	a0,s2
    80006a16:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006a1a:	00000097          	auipc	ra,0x0
    80006a1e:	b9c080e7          	jalr	-1124(ra) # 800065b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006a22:	8885                	andi	s1,s1,1
    80006a24:	f0ed                	bnez	s1,80006a06 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006a26:	00063517          	auipc	a0,0x63
    80006a2a:	5c250513          	addi	a0,a0,1474 # 80069fe8 <disk+0x128>
    80006a2e:	ffffa097          	auipc	ra,0xffffa
    80006a32:	332080e7          	jalr	818(ra) # 80000d60 <release>
}
    80006a36:	70e6                	ld	ra,120(sp)
    80006a38:	7446                	ld	s0,112(sp)
    80006a3a:	74a6                	ld	s1,104(sp)
    80006a3c:	7906                	ld	s2,96(sp)
    80006a3e:	69e6                	ld	s3,88(sp)
    80006a40:	6a46                	ld	s4,80(sp)
    80006a42:	6aa6                	ld	s5,72(sp)
    80006a44:	6b06                	ld	s6,64(sp)
    80006a46:	7be2                	ld	s7,56(sp)
    80006a48:	7c42                	ld	s8,48(sp)
    80006a4a:	7ca2                	ld	s9,40(sp)
    80006a4c:	7d02                	ld	s10,32(sp)
    80006a4e:	6de2                	ld	s11,24(sp)
    80006a50:	6109                	addi	sp,sp,128
    80006a52:	8082                	ret

0000000080006a54 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006a54:	1101                	addi	sp,sp,-32
    80006a56:	ec06                	sd	ra,24(sp)
    80006a58:	e822                	sd	s0,16(sp)
    80006a5a:	e426                	sd	s1,8(sp)
    80006a5c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006a5e:	00063497          	auipc	s1,0x63
    80006a62:	46248493          	addi	s1,s1,1122 # 80069ec0 <disk>
    80006a66:	00063517          	auipc	a0,0x63
    80006a6a:	58250513          	addi	a0,a0,1410 # 80069fe8 <disk+0x128>
    80006a6e:	ffffa097          	auipc	ra,0xffffa
    80006a72:	23e080e7          	jalr	574(ra) # 80000cac <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006a76:	10001737          	lui	a4,0x10001
    80006a7a:	533c                	lw	a5,96(a4)
    80006a7c:	8b8d                	andi	a5,a5,3
    80006a7e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006a80:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006a84:	689c                	ld	a5,16(s1)
    80006a86:	0204d703          	lhu	a4,32(s1)
    80006a8a:	0027d783          	lhu	a5,2(a5)
    80006a8e:	04f70863          	beq	a4,a5,80006ade <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006a92:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006a96:	6898                	ld	a4,16(s1)
    80006a98:	0204d783          	lhu	a5,32(s1)
    80006a9c:	8b9d                	andi	a5,a5,7
    80006a9e:	078e                	slli	a5,a5,0x3
    80006aa0:	97ba                	add	a5,a5,a4
    80006aa2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006aa4:	00278713          	addi	a4,a5,2
    80006aa8:	0712                	slli	a4,a4,0x4
    80006aaa:	9726                	add	a4,a4,s1
    80006aac:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006ab0:	e721                	bnez	a4,80006af8 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006ab2:	0789                	addi	a5,a5,2
    80006ab4:	0792                	slli	a5,a5,0x4
    80006ab6:	97a6                	add	a5,a5,s1
    80006ab8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006aba:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006abe:	ffffc097          	auipc	ra,0xffffc
    80006ac2:	b5a080e7          	jalr	-1190(ra) # 80002618 <wakeup>

    disk.used_idx += 1;
    80006ac6:	0204d783          	lhu	a5,32(s1)
    80006aca:	2785                	addiw	a5,a5,1
    80006acc:	17c2                	slli	a5,a5,0x30
    80006ace:	93c1                	srli	a5,a5,0x30
    80006ad0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006ad4:	6898                	ld	a4,16(s1)
    80006ad6:	00275703          	lhu	a4,2(a4)
    80006ada:	faf71ce3          	bne	a4,a5,80006a92 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006ade:	00063517          	auipc	a0,0x63
    80006ae2:	50a50513          	addi	a0,a0,1290 # 80069fe8 <disk+0x128>
    80006ae6:	ffffa097          	auipc	ra,0xffffa
    80006aea:	27a080e7          	jalr	634(ra) # 80000d60 <release>
}
    80006aee:	60e2                	ld	ra,24(sp)
    80006af0:	6442                	ld	s0,16(sp)
    80006af2:	64a2                	ld	s1,8(sp)
    80006af4:	6105                	addi	sp,sp,32
    80006af6:	8082                	ret
      panic("virtio_disk_intr status");
    80006af8:	00002517          	auipc	a0,0x2
    80006afc:	dd050513          	addi	a0,a0,-560 # 800088c8 <syscalls+0x3f8>
    80006b00:	ffffa097          	auipc	ra,0xffffa
    80006b04:	a40080e7          	jalr	-1472(ra) # 80000540 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
