
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	06a7d863          	bge	a5,a0,86 <main+0x86>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	aecb0b13          	addi	s6,s6,-1300 # b20 <ithread_join+0x56>
  3c:	a819                	j	52 <main+0x52>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	00000097          	auipc	ra,0x0
  48:	314080e7          	jalr	788(ra) # 358 <write>
  for(i = 1; i < argc; i++){
  4c:	04a1                	addi	s1,s1,8
  4e:	03448c63          	beq	s1,s4,86 <main+0x86>
    write(1, argv[i], strlen(argv[i]));
  52:	0004b903          	ld	s2,0(s1)
  56:	854a                	mv	a0,s2
  58:	00000097          	auipc	ra,0x0
  5c:	0a2080e7          	jalr	162(ra) # fa <strlen>
  60:	862a                	mv	a2,a0
  62:	85ca                	mv	a1,s2
  64:	854e                	mv	a0,s3
  66:	00000097          	auipc	ra,0x0
  6a:	2f2080e7          	jalr	754(ra) # 358 <write>
    if(i + 1 < argc){
  6e:	fd5498e3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  72:	4605                	li	a2,1
  74:	00001597          	auipc	a1,0x1
  78:	ab458593          	addi	a1,a1,-1356 # b28 <ithread_join+0x5e>
  7c:	8532                	mv	a0,a2
  7e:	00000097          	auipc	ra,0x0
  82:	2da080e7          	jalr	730(ra) # 358 <write>
    }
  }
  exit(0);
  86:	4501                	li	a0,0
  88:	00000097          	auipc	ra,0x0
  8c:	2b0080e7          	jalr	688(ra) # 338 <exit>

0000000000000090 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  90:	1141                	addi	sp,sp,-16
  92:	e406                	sd	ra,8(sp)
  94:	e022                	sd	s0,0(sp)
  96:	0800                	addi	s0,sp,16
  extern int main();
  main();
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <main>
  exit(0);
  a0:	4501                	li	a0,0
  a2:	00000097          	auipc	ra,0x0
  a6:	296080e7          	jalr	662(ra) # 338 <exit>

00000000000000aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b2:	87aa                	mv	a5,a0
  b4:	0585                	addi	a1,a1,1
  b6:	0785                	addi	a5,a5,1
  b8:	fff5c703          	lbu	a4,-1(a1)
  bc:	fee78fa3          	sb	a4,-1(a5)
  c0:	fb75                	bnez	a4,b4 <strcpy+0xa>
    ;
  return os;
}
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cb91                	beqz	a5,ea <strcmp+0x20>
  d8:	0005c703          	lbu	a4,0(a1)
  dc:	00f71763          	bne	a4,a5,ea <strcmp+0x20>
    p++, q++;
  e0:	0505                	addi	a0,a0,1
  e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbe5                	bnez	a5,d8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ea:	0005c503          	lbu	a0,0(a1)
}
  ee:	40a7853b          	subw	a0,a5,a0
  f2:	60a2                	ld	ra,8(sp)
  f4:	6402                	ld	s0,0(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strlen>:

uint
strlen(const char *s)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 102:	00054783          	lbu	a5,0(a0)
 106:	cf91                	beqz	a5,122 <strlen+0x28>
 108:	00150793          	addi	a5,a0,1
 10c:	86be                	mv	a3,a5
 10e:	0785                	addi	a5,a5,1
 110:	fff7c703          	lbu	a4,-1(a5)
 114:	ff65                	bnez	a4,10c <strlen+0x12>
 116:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 11a:	60a2                	ld	ra,8(sp)
 11c:	6402                	ld	s0,0(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret
  for(n = 0; s[n]; n++)
 122:	4501                	li	a0,0
 124:	bfdd                	j	11a <strlen+0x20>

0000000000000126 <memset>:

void*
memset(void *dst, int c, uint n)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 12e:	ca19                	beqz	a2,144 <memset+0x1e>
 130:	87aa                	mv	a5,a0
 132:	1602                	slli	a2,a2,0x20
 134:	9201                	srli	a2,a2,0x20
 136:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 13e:	0785                	addi	a5,a5,1
 140:	fee79de3          	bne	a5,a4,13a <memset+0x14>
  }
  return dst;
}
 144:	60a2                	ld	ra,8(sp)
 146:	6402                	ld	s0,0(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret

000000000000014c <strchr>:

char*
strchr(const char *s, char c)
{
 14c:	1141                	addi	sp,sp,-16
 14e:	e406                	sd	ra,8(sp)
 150:	e022                	sd	s0,0(sp)
 152:	0800                	addi	s0,sp,16
  for(; *s; s++)
 154:	00054783          	lbu	a5,0(a0)
 158:	cf81                	beqz	a5,170 <strchr+0x24>
    if(*s == c)
 15a:	00f58763          	beq	a1,a5,168 <strchr+0x1c>
  for(; *s; s++)
 15e:	0505                	addi	a0,a0,1
 160:	00054783          	lbu	a5,0(a0)
 164:	fbfd                	bnez	a5,15a <strchr+0xe>
      return (char*)s;
  return 0;
 166:	4501                	li	a0,0
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret
  return 0;
 170:	4501                	li	a0,0
 172:	bfdd                	j	168 <strchr+0x1c>

0000000000000174 <gets>:

char*
gets(char *buf, int max)
{
 174:	711d                	addi	sp,sp,-96
 176:	ec86                	sd	ra,88(sp)
 178:	e8a2                	sd	s0,80(sp)
 17a:	e4a6                	sd	s1,72(sp)
 17c:	e0ca                	sd	s2,64(sp)
 17e:	fc4e                	sd	s3,56(sp)
 180:	f852                	sd	s4,48(sp)
 182:	f456                	sd	s5,40(sp)
 184:	f05a                	sd	s6,32(sp)
 186:	ec5e                	sd	s7,24(sp)
 188:	e862                	sd	s8,16(sp)
 18a:	1080                	addi	s0,sp,96
 18c:	8baa                	mv	s7,a0
 18e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	892a                	mv	s2,a0
 192:	4481                	li	s1,0
    cc = read(0, &c, 1);
 194:	faf40b13          	addi	s6,s0,-81
 198:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 19a:	8c26                	mv	s8,s1
 19c:	0014899b          	addiw	s3,s1,1
 1a0:	84ce                	mv	s1,s3
 1a2:	0349d663          	bge	s3,s4,1ce <gets+0x5a>
    cc = read(0, &c, 1);
 1a6:	8656                	mv	a2,s5
 1a8:	85da                	mv	a1,s6
 1aa:	4501                	li	a0,0
 1ac:	00000097          	auipc	ra,0x0
 1b0:	1a4080e7          	jalr	420(ra) # 350 <read>
    if(cc < 1)
 1b4:	00a05d63          	blez	a0,1ce <gets+0x5a>
      break;
    buf[i++] = c;
 1b8:	faf44783          	lbu	a5,-81(s0)
 1bc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c0:	0905                	addi	s2,s2,1
 1c2:	ff678713          	addi	a4,a5,-10
 1c6:	c319                	beqz	a4,1cc <gets+0x58>
 1c8:	17cd                	addi	a5,a5,-13
 1ca:	fbe1                	bnez	a5,19a <gets+0x26>
    buf[i++] = c;
 1cc:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ce:	9c5e                	add	s8,s8,s7
 1d0:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1d4:	855e                	mv	a0,s7
 1d6:	60e6                	ld	ra,88(sp)
 1d8:	6446                	ld	s0,80(sp)
 1da:	64a6                	ld	s1,72(sp)
 1dc:	6906                	ld	s2,64(sp)
 1de:	79e2                	ld	s3,56(sp)
 1e0:	7a42                	ld	s4,48(sp)
 1e2:	7aa2                	ld	s5,40(sp)
 1e4:	7b02                	ld	s6,32(sp)
 1e6:	6be2                	ld	s7,24(sp)
 1e8:	6c42                	ld	s8,16(sp)
 1ea:	6125                	addi	sp,sp,96
 1ec:	8082                	ret

00000000000001ee <stat>:

int
stat(const char *n, struct stat *st)
{
 1ee:	1101                	addi	sp,sp,-32
 1f0:	ec06                	sd	ra,24(sp)
 1f2:	e822                	sd	s0,16(sp)
 1f4:	e04a                	sd	s2,0(sp)
 1f6:	1000                	addi	s0,sp,32
 1f8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fa:	4581                	li	a1,0
 1fc:	00000097          	auipc	ra,0x0
 200:	17c080e7          	jalr	380(ra) # 378 <open>
  if(fd < 0)
 204:	02054663          	bltz	a0,230 <stat+0x42>
 208:	e426                	sd	s1,8(sp)
 20a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 20c:	85ca                	mv	a1,s2
 20e:	00000097          	auipc	ra,0x0
 212:	182080e7          	jalr	386(ra) # 390 <fstat>
 216:	892a                	mv	s2,a0
  close(fd);
 218:	8526                	mv	a0,s1
 21a:	00000097          	auipc	ra,0x0
 21e:	146080e7          	jalr	326(ra) # 360 <close>
  return r;
 222:	64a2                	ld	s1,8(sp)
}
 224:	854a                	mv	a0,s2
 226:	60e2                	ld	ra,24(sp)
 228:	6442                	ld	s0,16(sp)
 22a:	6902                	ld	s2,0(sp)
 22c:	6105                	addi	sp,sp,32
 22e:	8082                	ret
    return -1;
 230:	57fd                	li	a5,-1
 232:	893e                	mv	s2,a5
 234:	bfc5                	j	224 <stat+0x36>

0000000000000236 <atoi>:

int
atoi(const char *s)
{
 236:	1141                	addi	sp,sp,-16
 238:	e406                	sd	ra,8(sp)
 23a:	e022                	sd	s0,0(sp)
 23c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23e:	00054683          	lbu	a3,0(a0)
 242:	fd06879b          	addiw	a5,a3,-48
 246:	0ff7f793          	zext.b	a5,a5
 24a:	4625                	li	a2,9
 24c:	02f66963          	bltu	a2,a5,27e <atoi+0x48>
 250:	872a                	mv	a4,a0
  n = 0;
 252:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 254:	0705                	addi	a4,a4,1
 256:	0025179b          	slliw	a5,a0,0x2
 25a:	9fa9                	addw	a5,a5,a0
 25c:	0017979b          	slliw	a5,a5,0x1
 260:	9fb5                	addw	a5,a5,a3
 262:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 266:	00074683          	lbu	a3,0(a4)
 26a:	fd06879b          	addiw	a5,a3,-48
 26e:	0ff7f793          	zext.b	a5,a5
 272:	fef671e3          	bgeu	a2,a5,254 <atoi+0x1e>
  return n;
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  n = 0;
 27e:	4501                	li	a0,0
 280:	bfdd                	j	276 <atoi+0x40>

0000000000000282 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 28a:	02b57563          	bgeu	a0,a1,2b4 <memmove+0x32>
    while(n-- > 0)
 28e:	00c05f63          	blez	a2,2ac <memmove+0x2a>
 292:	1602                	slli	a2,a2,0x20
 294:	9201                	srli	a2,a2,0x20
 296:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 29a:	872a                	mv	a4,a0
      *dst++ = *src++;
 29c:	0585                	addi	a1,a1,1
 29e:	0705                	addi	a4,a4,1
 2a0:	fff5c683          	lbu	a3,-1(a1)
 2a4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a8:	fee79ae3          	bne	a5,a4,29c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
    while(n-- > 0)
 2b4:	fec05ce3          	blez	a2,2ac <memmove+0x2a>
    dst += n;
 2b8:	00c50733          	add	a4,a0,a2
    src += n;
 2bc:	95b2                	add	a1,a1,a2
 2be:	fff6079b          	addiw	a5,a2,-1
 2c2:	1782                	slli	a5,a5,0x20
 2c4:	9381                	srli	a5,a5,0x20
 2c6:	fff7c793          	not	a5,a5
 2ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2cc:	15fd                	addi	a1,a1,-1
 2ce:	177d                	addi	a4,a4,-1
 2d0:	0005c683          	lbu	a3,0(a1)
 2d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d8:	fef71ae3          	bne	a4,a5,2cc <memmove+0x4a>
 2dc:	bfc1                	j	2ac <memmove+0x2a>

00000000000002de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e6:	c61d                	beqz	a2,314 <memcmp+0x36>
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	0005c703          	lbu	a4,0(a1)
 2f8:	00e79863          	bne	a5,a4,308 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2fc:	0505                	addi	a0,a0,1
    p2++;
 2fe:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 300:	fed518e3          	bne	a0,a3,2f0 <memcmp+0x12>
  }
  return 0;
 304:	4501                	li	a0,0
 306:	a019                	j	30c <memcmp+0x2e>
      return *p1 - *p2;
 308:	40e7853b          	subw	a0,a5,a4
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  return 0;
 314:	4501                	li	a0,0
 316:	bfdd                	j	30c <memcmp+0x2e>

0000000000000318 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 320:	00000097          	auipc	ra,0x0
 324:	f62080e7          	jalr	-158(ra) # 282 <memmove>
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret

0000000000000330 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 330:	4885                	li	a7,1
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exit>:
.global exit
exit:
 li a7, SYS_exit
 338:	4889                	li	a7,2
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <wait>:
.global wait
wait:
 li a7, SYS_wait
 340:	488d                	li	a7,3
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 348:	4891                	li	a7,4
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <read>:
.global read
read:
 li a7, SYS_read
 350:	4895                	li	a7,5
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <write>:
.global write
write:
 li a7, SYS_write
 358:	48c1                	li	a7,16
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <close>:
.global close
close:
 li a7, SYS_close
 360:	48d5                	li	a7,21
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <kill>:
.global kill
kill:
 li a7, SYS_kill
 368:	4899                	li	a7,6
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <exec>:
.global exec
exec:
 li a7, SYS_exec
 370:	489d                	li	a7,7
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <open>:
.global open
open:
 li a7, SYS_open
 378:	48bd                	li	a7,15
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 380:	48c5                	li	a7,17
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 388:	48c9                	li	a7,18
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 390:	48a1                	li	a7,8
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <link>:
.global link
link:
 li a7, SYS_link
 398:	48cd                	li	a7,19
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3a0:	48d1                	li	a7,20
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a8:	48a5                	li	a7,9
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3b0:	48a9                	li	a7,10
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b8:	48ad                	li	a7,11
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3c0:	48b1                	li	a7,12
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c8:	48b5                	li	a7,13
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d0:	48b9                	li	a7,14
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3d8:	48d9                	li	a7,22
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3e0:	48dd                	li	a7,23
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3e8:	48e1                	li	a7,24
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3f0:	48e5                	li	a7,25
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3f8:	48e9                	li	a7,26
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <bind>:
.global bind
bind:
 li a7, SYS_bind
 400:	48ed                	li	a7,27
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <accept>:
.global accept
accept:
 li a7, SYS_accept
 408:	48f5                	li	a7,29
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <listen>:
.global listen
listen:
 li a7, SYS_listen
 410:	48f1                	li	a7,28
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <connect>:
.global connect
connect:
 li a7, SYS_connect
 418:	48f9                	li	a7,30
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <send>:
.global send
send:
 li a7, SYS_send
 420:	48fd                	li	a7,31
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <recv>:
.global recv
recv:
 li a7, SYS_recv
 428:	02000893          	li	a7,32
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 432:	02100893          	li	a7,33
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 43c:	02200893          	li	a7,34
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 446:	1101                	addi	sp,sp,-32
 448:	ec06                	sd	ra,24(sp)
 44a:	e822                	sd	s0,16(sp)
 44c:	1000                	addi	s0,sp,32
 44e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 452:	4605                	li	a2,1
 454:	fef40593          	addi	a1,s0,-17
 458:	00000097          	auipc	ra,0x0
 45c:	f00080e7          	jalr	-256(ra) # 358 <write>
}
 460:	60e2                	ld	ra,24(sp)
 462:	6442                	ld	s0,16(sp)
 464:	6105                	addi	sp,sp,32
 466:	8082                	ret

0000000000000468 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 468:	7139                	addi	sp,sp,-64
 46a:	fc06                	sd	ra,56(sp)
 46c:	f822                	sd	s0,48(sp)
 46e:	f04a                	sd	s2,32(sp)
 470:	ec4e                	sd	s3,24(sp)
 472:	0080                	addi	s0,sp,64
 474:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 476:	cad9                	beqz	a3,50c <printint+0xa4>
 478:	01f5d79b          	srliw	a5,a1,0x1f
 47c:	cbc1                	beqz	a5,50c <printint+0xa4>
    neg = 1;
    x = -xx;
 47e:	40b005bb          	negw	a1,a1
    neg = 1;
 482:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 484:	fc040993          	addi	s3,s0,-64
  neg = 0;
 488:	86ce                	mv	a3,s3
  i = 0;
 48a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 48c:	00000817          	auipc	a6,0x0
 490:	73480813          	addi	a6,a6,1844 # bc0 <digits>
 494:	88ba                	mv	a7,a4
 496:	0017051b          	addiw	a0,a4,1
 49a:	872a                	mv	a4,a0
 49c:	02c5f7bb          	remuw	a5,a1,a2
 4a0:	1782                	slli	a5,a5,0x20
 4a2:	9381                	srli	a5,a5,0x20
 4a4:	97c2                	add	a5,a5,a6
 4a6:	0007c783          	lbu	a5,0(a5)
 4aa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ae:	87ae                	mv	a5,a1
 4b0:	02c5d5bb          	divuw	a1,a1,a2
 4b4:	0685                	addi	a3,a3,1
 4b6:	fcc7ffe3          	bgeu	a5,a2,494 <printint+0x2c>
  if(neg)
 4ba:	00030c63          	beqz	t1,4d2 <printint+0x6a>
    buf[i++] = '-';
 4be:	fd050793          	addi	a5,a0,-48
 4c2:	00878533          	add	a0,a5,s0
 4c6:	02d00793          	li	a5,45
 4ca:	fef50823          	sb	a5,-16(a0)
 4ce:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4d2:	02e05763          	blez	a4,500 <printint+0x98>
 4d6:	f426                	sd	s1,40(sp)
 4d8:	377d                	addiw	a4,a4,-1
 4da:	00e984b3          	add	s1,s3,a4
 4de:	19fd                	addi	s3,s3,-1
 4e0:	99ba                	add	s3,s3,a4
 4e2:	1702                	slli	a4,a4,0x20
 4e4:	9301                	srli	a4,a4,0x20
 4e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ea:	0004c583          	lbu	a1,0(s1)
 4ee:	854a                	mv	a0,s2
 4f0:	00000097          	auipc	ra,0x0
 4f4:	f56080e7          	jalr	-170(ra) # 446 <putc>
  while(--i >= 0)
 4f8:	14fd                	addi	s1,s1,-1
 4fa:	ff3498e3          	bne	s1,s3,4ea <printint+0x82>
 4fe:	74a2                	ld	s1,40(sp)
}
 500:	70e2                	ld	ra,56(sp)
 502:	7442                	ld	s0,48(sp)
 504:	7902                	ld	s2,32(sp)
 506:	69e2                	ld	s3,24(sp)
 508:	6121                	addi	sp,sp,64
 50a:	8082                	ret
  neg = 0;
 50c:	4301                	li	t1,0
 50e:	bf9d                	j	484 <printint+0x1c>

0000000000000510 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 510:	715d                	addi	sp,sp,-80
 512:	e486                	sd	ra,72(sp)
 514:	e0a2                	sd	s0,64(sp)
 516:	f84a                	sd	s2,48(sp)
 518:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 51a:	0005c903          	lbu	s2,0(a1)
 51e:	1a090b63          	beqz	s2,6d4 <vprintf+0x1c4>
 522:	fc26                	sd	s1,56(sp)
 524:	f44e                	sd	s3,40(sp)
 526:	f052                	sd	s4,32(sp)
 528:	ec56                	sd	s5,24(sp)
 52a:	e85a                	sd	s6,16(sp)
 52c:	e45e                	sd	s7,8(sp)
 52e:	8aaa                	mv	s5,a0
 530:	8bb2                	mv	s7,a2
 532:	00158493          	addi	s1,a1,1
  state = 0;
 536:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 538:	02500a13          	li	s4,37
 53c:	4b55                	li	s6,21
 53e:	a839                	j	55c <vprintf+0x4c>
        putc(fd, c);
 540:	85ca                	mv	a1,s2
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	f02080e7          	jalr	-254(ra) # 446 <putc>
 54c:	a019                	j	552 <vprintf+0x42>
    } else if(state == '%'){
 54e:	01498d63          	beq	s3,s4,568 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 552:	0485                	addi	s1,s1,1
 554:	fff4c903          	lbu	s2,-1(s1)
 558:	16090863          	beqz	s2,6c8 <vprintf+0x1b8>
    if(state == 0){
 55c:	fe0999e3          	bnez	s3,54e <vprintf+0x3e>
      if(c == '%'){
 560:	ff4910e3          	bne	s2,s4,540 <vprintf+0x30>
        state = '%';
 564:	89d2                	mv	s3,s4
 566:	b7f5                	j	552 <vprintf+0x42>
      if(c == 'd'){
 568:	13490563          	beq	s2,s4,692 <vprintf+0x182>
 56c:	f9d9079b          	addiw	a5,s2,-99
 570:	0ff7f793          	zext.b	a5,a5
 574:	12fb6863          	bltu	s6,a5,6a4 <vprintf+0x194>
 578:	f9d9079b          	addiw	a5,s2,-99
 57c:	0ff7f713          	zext.b	a4,a5
 580:	12eb6263          	bltu	s6,a4,6a4 <vprintf+0x194>
 584:	00271793          	slli	a5,a4,0x2
 588:	00000717          	auipc	a4,0x0
 58c:	5e070713          	addi	a4,a4,1504 # b68 <ithread_join+0x9e>
 590:	97ba                	add	a5,a5,a4
 592:	439c                	lw	a5,0(a5)
 594:	97ba                	add	a5,a5,a4
 596:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 598:	008b8913          	addi	s2,s7,8
 59c:	4685                	li	a3,1
 59e:	4629                	li	a2,10
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	ec2080e7          	jalr	-318(ra) # 468 <printint>
 5ae:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b745                	j	552 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b4:	008b8913          	addi	s2,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4629                	li	a2,10
 5bc:	000ba583          	lw	a1,0(s7)
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	ea6080e7          	jalr	-346(ra) # 468 <printint>
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b751                	j	552 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4641                	li	a2,16
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	e8a080e7          	jalr	-374(ra) # 468 <printint>
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b7a5                	j	552 <vprintf+0x42>
 5ec:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5ee:	008b8793          	addi	a5,s7,8
 5f2:	8c3e                	mv	s8,a5
 5f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5f8:	03000593          	li	a1,48
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e48080e7          	jalr	-440(ra) # 446 <putc>
  putc(fd, 'x');
 606:	07800593          	li	a1,120
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e3a080e7          	jalr	-454(ra) # 446 <putc>
 614:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 616:	00000b97          	auipc	s7,0x0
 61a:	5aab8b93          	addi	s7,s7,1450 # bc0 <digits>
 61e:	03c9d793          	srli	a5,s3,0x3c
 622:	97de                	add	a5,a5,s7
 624:	0007c583          	lbu	a1,0(a5)
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	e1c080e7          	jalr	-484(ra) # 446 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 632:	0992                	slli	s3,s3,0x4
 634:	397d                	addiw	s2,s2,-1
 636:	fe0914e3          	bnez	s2,61e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 63a:	8be2                	mv	s7,s8
      state = 0;
 63c:	4981                	li	s3,0
 63e:	6c02                	ld	s8,0(sp)
 640:	bf09                	j	552 <vprintf+0x42>
        s = va_arg(ap, char*);
 642:	008b8993          	addi	s3,s7,8
 646:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 64a:	02090163          	beqz	s2,66c <vprintf+0x15c>
        while(*s != 0){
 64e:	00094583          	lbu	a1,0(s2)
 652:	c9a5                	beqz	a1,6c2 <vprintf+0x1b2>
          putc(fd, *s);
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	df0080e7          	jalr	-528(ra) # 446 <putc>
          s++;
 65e:	0905                	addi	s2,s2,1
        while(*s != 0){
 660:	00094583          	lbu	a1,0(s2)
 664:	f9e5                	bnez	a1,654 <vprintf+0x144>
        s = va_arg(ap, char*);
 666:	8bce                	mv	s7,s3
      state = 0;
 668:	4981                	li	s3,0
 66a:	b5e5                	j	552 <vprintf+0x42>
          s = "(null)";
 66c:	00000917          	auipc	s2,0x0
 670:	4c490913          	addi	s2,s2,1220 # b30 <ithread_join+0x66>
        while(*s != 0){
 674:	02800593          	li	a1,40
 678:	bff1                	j	654 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 67a:	008b8913          	addi	s2,s7,8
 67e:	000bc583          	lbu	a1,0(s7)
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	dc2080e7          	jalr	-574(ra) # 446 <putc>
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	b5c9                	j	552 <vprintf+0x42>
        putc(fd, c);
 692:	02500593          	li	a1,37
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	dae080e7          	jalr	-594(ra) # 446 <putc>
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bd45                	j	552 <vprintf+0x42>
        putc(fd, '%');
 6a4:	02500593          	li	a1,37
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	d9c080e7          	jalr	-612(ra) # 446 <putc>
        putc(fd, c);
 6b2:	85ca                	mv	a1,s2
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	d90080e7          	jalr	-624(ra) # 446 <putc>
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bd49                	j	552 <vprintf+0x42>
        s = va_arg(ap, char*);
 6c2:	8bce                	mv	s7,s3
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b571                	j	552 <vprintf+0x42>
 6c8:	74e2                	ld	s1,56(sp)
 6ca:	79a2                	ld	s3,40(sp)
 6cc:	7a02                	ld	s4,32(sp)
 6ce:	6ae2                	ld	s5,24(sp)
 6d0:	6b42                	ld	s6,16(sp)
 6d2:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6d4:	60a6                	ld	ra,72(sp)
 6d6:	6406                	ld	s0,64(sp)
 6d8:	7942                	ld	s2,48(sp)
 6da:	6161                	addi	sp,sp,80
 6dc:	8082                	ret

00000000000006de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6de:	715d                	addi	sp,sp,-80
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	addi	s0,sp,32
 6e6:	e010                	sd	a2,0(s0)
 6e8:	e414                	sd	a3,8(s0)
 6ea:	e818                	sd	a4,16(s0)
 6ec:	ec1c                	sd	a5,24(s0)
 6ee:	03043023          	sd	a6,32(s0)
 6f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f6:	8622                	mv	a2,s0
 6f8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6fc:	00000097          	auipc	ra,0x0
 700:	e14080e7          	jalr	-492(ra) # 510 <vprintf>
}
 704:	60e2                	ld	ra,24(sp)
 706:	6442                	ld	s0,16(sp)
 708:	6161                	addi	sp,sp,80
 70a:	8082                	ret

000000000000070c <printf>:

void
printf(const char *fmt, ...)
{
 70c:	711d                	addi	sp,sp,-96
 70e:	ec06                	sd	ra,24(sp)
 710:	e822                	sd	s0,16(sp)
 712:	1000                	addi	s0,sp,32
 714:	e40c                	sd	a1,8(s0)
 716:	e810                	sd	a2,16(s0)
 718:	ec14                	sd	a3,24(s0)
 71a:	f018                	sd	a4,32(s0)
 71c:	f41c                	sd	a5,40(s0)
 71e:	03043823          	sd	a6,48(s0)
 722:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 726:	00840613          	addi	a2,s0,8
 72a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 72e:	85aa                	mv	a1,a0
 730:	4505                	li	a0,1
 732:	00000097          	auipc	ra,0x0
 736:	dde080e7          	jalr	-546(ra) # 510 <vprintf>
}
 73a:	60e2                	ld	ra,24(sp)
 73c:	6442                	ld	s0,16(sp)
 73e:	6125                	addi	sp,sp,96
 740:	8082                	ret

0000000000000742 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 742:	1141                	addi	sp,sp,-16
 744:	e406                	sd	ra,8(sp)
 746:	e022                	sd	s0,0(sp)
 748:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74e:	00001797          	auipc	a5,0x1
 752:	dc27b783          	ld	a5,-574(a5) # 1510 <freep>
 756:	a039                	j	764 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 758:	6398                	ld	a4,0(a5)
 75a:	00e7e463          	bltu	a5,a4,762 <free+0x20>
 75e:	00e6ea63          	bltu	a3,a4,772 <free+0x30>
{
 762:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 764:	fed7fae3          	bgeu	a5,a3,758 <free+0x16>
 768:	6398                	ld	a4,0(a5)
 76a:	00e6e463          	bltu	a3,a4,772 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76e:	fee7eae3          	bltu	a5,a4,762 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 772:	ff852583          	lw	a1,-8(a0)
 776:	6390                	ld	a2,0(a5)
 778:	02059813          	slli	a6,a1,0x20
 77c:	01c85713          	srli	a4,a6,0x1c
 780:	9736                	add	a4,a4,a3
 782:	02e60563          	beq	a2,a4,7ac <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 78a:	4790                	lw	a2,8(a5)
 78c:	02061593          	slli	a1,a2,0x20
 790:	01c5d713          	srli	a4,a1,0x1c
 794:	973e                	add	a4,a4,a5
 796:	02e68263          	beq	a3,a4,7ba <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 79a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79c:	00001717          	auipc	a4,0x1
 7a0:	d6f73a23          	sd	a5,-652(a4) # 1510 <freep>
}
 7a4:	60a2                	ld	ra,8(sp)
 7a6:	6402                	ld	s0,0(sp)
 7a8:	0141                	addi	sp,sp,16
 7aa:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ac:	4618                	lw	a4,8(a2)
 7ae:	9f2d                	addw	a4,a4,a1
 7b0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b4:	6398                	ld	a4,0(a5)
 7b6:	6310                	ld	a2,0(a4)
 7b8:	b7f9                	j	786 <free+0x44>
    p->s.size += bp->s.size;
 7ba:	ff852703          	lw	a4,-8(a0)
 7be:	9f31                	addw	a4,a4,a2
 7c0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c2:	ff053683          	ld	a3,-16(a0)
 7c6:	bfd1                	j	79a <free+0x58>

00000000000007c8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c8:	7139                	addi	sp,sp,-64
 7ca:	fc06                	sd	ra,56(sp)
 7cc:	f822                	sd	s0,48(sp)
 7ce:	f04a                	sd	s2,32(sp)
 7d0:	ec4e                	sd	s3,24(sp)
 7d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d4:	02051993          	slli	s3,a0,0x20
 7d8:	0209d993          	srli	s3,s3,0x20
 7dc:	09bd                	addi	s3,s3,15
 7de:	0049d993          	srli	s3,s3,0x4
 7e2:	2985                	addiw	s3,s3,1
 7e4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7e6:	00001517          	auipc	a0,0x1
 7ea:	d2a53503          	ld	a0,-726(a0) # 1510 <freep>
 7ee:	c905                	beqz	a0,81e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f2:	4798                	lw	a4,8(a5)
 7f4:	09377a63          	bgeu	a4,s3,888 <malloc+0xc0>
 7f8:	f426                	sd	s1,40(sp)
 7fa:	e852                	sd	s4,16(sp)
 7fc:	e456                	sd	s5,8(sp)
 7fe:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 800:	8a4e                	mv	s4,s3
 802:	6705                	lui	a4,0x1
 804:	00e9f363          	bgeu	s3,a4,80a <malloc+0x42>
 808:	6a05                	lui	s4,0x1
 80a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 80e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 812:	00001497          	auipc	s1,0x1
 816:	cfe48493          	addi	s1,s1,-770 # 1510 <freep>
  if(p == (char*)-1)
 81a:	5afd                	li	s5,-1
 81c:	a089                	j	85e <malloc+0x96>
 81e:	f426                	sd	s1,40(sp)
 820:	e852                	sd	s4,16(sp)
 822:	e456                	sd	s5,8(sp)
 824:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 826:	00001797          	auipc	a5,0x1
 82a:	d0a78793          	addi	a5,a5,-758 # 1530 <base>
 82e:	00001717          	auipc	a4,0x1
 832:	cef73123          	sd	a5,-798(a4) # 1510 <freep>
 836:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 838:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 83c:	b7d1                	j	800 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 83e:	6398                	ld	a4,0(a5)
 840:	e118                	sd	a4,0(a0)
 842:	a8b9                	j	8a0 <malloc+0xd8>
  hp->s.size = nu;
 844:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 848:	0541                	addi	a0,a0,16
 84a:	00000097          	auipc	ra,0x0
 84e:	ef8080e7          	jalr	-264(ra) # 742 <free>
  return freep;
 852:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 854:	c135                	beqz	a0,8b8 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 856:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 858:	4798                	lw	a4,8(a5)
 85a:	03277363          	bgeu	a4,s2,880 <malloc+0xb8>
    if(p == freep)
 85e:	6098                	ld	a4,0(s1)
 860:	853e                	mv	a0,a5
 862:	fef71ae3          	bne	a4,a5,856 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 866:	8552                	mv	a0,s4
 868:	00000097          	auipc	ra,0x0
 86c:	b58080e7          	jalr	-1192(ra) # 3c0 <sbrk>
  if(p == (char*)-1)
 870:	fd551ae3          	bne	a0,s5,844 <malloc+0x7c>
        return 0;
 874:	4501                	li	a0,0
 876:	74a2                	ld	s1,40(sp)
 878:	6a42                	ld	s4,16(sp)
 87a:	6aa2                	ld	s5,8(sp)
 87c:	6b02                	ld	s6,0(sp)
 87e:	a03d                	j	8ac <malloc+0xe4>
 880:	74a2                	ld	s1,40(sp)
 882:	6a42                	ld	s4,16(sp)
 884:	6aa2                	ld	s5,8(sp)
 886:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 888:	fae90be3          	beq	s2,a4,83e <malloc+0x76>
        p->s.size -= nunits;
 88c:	4137073b          	subw	a4,a4,s3
 890:	c798                	sw	a4,8(a5)
        p += p->s.size;
 892:	02071693          	slli	a3,a4,0x20
 896:	01c6d713          	srli	a4,a3,0x1c
 89a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a0:	00001717          	auipc	a4,0x1
 8a4:	c6a73823          	sd	a0,-912(a4) # 1510 <freep>
      return (void*)(p + 1);
 8a8:	01078513          	addi	a0,a5,16
  }
}
 8ac:	70e2                	ld	ra,56(sp)
 8ae:	7442                	ld	s0,48(sp)
 8b0:	7902                	ld	s2,32(sp)
 8b2:	69e2                	ld	s3,24(sp)
 8b4:	6121                	addi	sp,sp,64
 8b6:	8082                	ret
 8b8:	74a2                	ld	s1,40(sp)
 8ba:	6a42                	ld	s4,16(sp)
 8bc:	6aa2                	ld	s5,8(sp)
 8be:	6b02                	ld	s6,0(sp)
 8c0:	b7f5                	j	8ac <malloc+0xe4>

00000000000008c2 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 8c2:	1141                	addi	sp,sp,-16
 8c4:	e406                	sd	ra,8(sp)
 8c6:	e022                	sd	s0,0(sp)
 8c8:	0800                	addi	s0,sp,16
  thread_exit(status);
 8ca:	2501                	sext.w	a0,a0
 8cc:	00000097          	auipc	ra,0x0
 8d0:	b24080e7          	jalr	-1244(ra) # 3f0 <thread_exit>
}
 8d4:	60a2                	ld	ra,8(sp)
 8d6:	6402                	ld	s0,0(sp)
 8d8:	0141                	addi	sp,sp,16
 8da:	8082                	ret

00000000000008dc <free_stacks>:
int free_stacks() {
 8dc:	7179                	addi	sp,sp,-48
 8de:	f406                	sd	ra,40(sp)
 8e0:	f022                	sd	s0,32(sp)
 8e2:	ec26                	sd	s1,24(sp)
 8e4:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8e6:	00001797          	auipc	a5,0x1
 8ea:	c3a7a783          	lw	a5,-966(a5) # 1520 <num_threads>
 8ee:	04f05063          	blez	a5,92e <free_stacks+0x52>
 8f2:	e84a                	sd	s2,16(sp)
 8f4:	e44e                	sd	s3,8(sp)
 8f6:	4481                	li	s1,0
    free(stacks[i]);
 8f8:	00001997          	auipc	s3,0x1
 8fc:	c2098993          	addi	s3,s3,-992 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 900:	00001917          	auipc	s2,0x1
 904:	c2090913          	addi	s2,s2,-992 # 1520 <num_threads>
    free(stacks[i]);
 908:	0009b783          	ld	a5,0(s3)
 90c:	00349713          	slli	a4,s1,0x3
 910:	97ba                	add	a5,a5,a4
 912:	6388                	ld	a0,0(a5)
 914:	00000097          	auipc	ra,0x0
 918:	e2e080e7          	jalr	-466(ra) # 742 <free>
  for (int i = 0; i < num_threads; i++) {
 91c:	0485                	addi	s1,s1,1
 91e:	00092703          	lw	a4,0(s2)
 922:	0004879b          	sext.w	a5,s1
 926:	fee7c1e3          	blt	a5,a4,908 <free_stacks+0x2c>
 92a:	6942                	ld	s2,16(sp)
 92c:	69a2                	ld	s3,8(sp)
  free(stacks);
 92e:	00001497          	auipc	s1,0x1
 932:	bea48493          	addi	s1,s1,-1046 # 1518 <stacks>
 936:	6088                	ld	a0,0(s1)
 938:	00000097          	auipc	ra,0x0
 93c:	e0a080e7          	jalr	-502(ra) # 742 <free>
  stacks = 0;
 940:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 944:	00001797          	auipc	a5,0x1
 948:	bc07ae23          	sw	zero,-1060(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 94c:	47a1                	li	a5,8
 94e:	00001717          	auipc	a4,0x1
 952:	baf72923          	sw	a5,-1102(a4) # 1500 <max_stacks>
  threads_done = 0;
 956:	00001797          	auipc	a5,0x1
 95a:	bc07a723          	sw	zero,-1074(a5) # 1524 <threads_done>
}
 95e:	4501                	li	a0,0
 960:	70a2                	ld	ra,40(sp)
 962:	7402                	ld	s0,32(sp)
 964:	64e2                	ld	s1,24(sp)
 966:	6145                	addi	sp,sp,48
 968:	8082                	ret

000000000000096a <expand_num_threads>:
int expand_num_threads() {
 96a:	1101                	addi	sp,sp,-32
 96c:	ec06                	sd	ra,24(sp)
 96e:	e822                	sd	s0,16(sp)
 970:	e426                	sd	s1,8(sp)
 972:	e04a                	sd	s2,0(sp)
 974:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 976:	00001797          	auipc	a5,0x1
 97a:	b8a78793          	addi	a5,a5,-1142 # 1500 <max_stacks>
 97e:	4388                	lw	a0,0(a5)
 980:	0015151b          	slliw	a0,a0,0x1
 984:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 986:	0035151b          	slliw	a0,a0,0x3
 98a:	00000097          	auipc	ra,0x0
 98e:	e3e080e7          	jalr	-450(ra) # 7c8 <malloc>
 992:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 994:	00001617          	auipc	a2,0x1
 998:	b8c62603          	lw	a2,-1140(a2) # 1520 <num_threads>
 99c:	00001497          	auipc	s1,0x1
 9a0:	b7c48493          	addi	s1,s1,-1156 # 1518 <stacks>
 9a4:	0036161b          	slliw	a2,a2,0x3
 9a8:	608c                	ld	a1,0(s1)
 9aa:	00000097          	auipc	ra,0x0
 9ae:	8d8080e7          	jalr	-1832(ra) # 282 <memmove>
  free(stacks);
 9b2:	6088                	ld	a0,0(s1)
 9b4:	00000097          	auipc	ra,0x0
 9b8:	d8e080e7          	jalr	-626(ra) # 742 <free>
  stacks = new_stacks;
 9bc:	0124b023          	sd	s2,0(s1)
}
 9c0:	4501                	li	a0,0
 9c2:	60e2                	ld	ra,24(sp)
 9c4:	6442                	ld	s0,16(sp)
 9c6:	64a2                	ld	s1,8(sp)
 9c8:	6902                	ld	s2,0(sp)
 9ca:	6105                	addi	sp,sp,32
 9cc:	8082                	ret

00000000000009ce <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9ce:	7179                	addi	sp,sp,-48
 9d0:	f406                	sd	ra,40(sp)
 9d2:	f022                	sd	s0,32(sp)
 9d4:	e84a                	sd	s2,16(sp)
 9d6:	e44e                	sd	s3,8(sp)
 9d8:	1800                	addi	s0,sp,48
 9da:	892a                	mv	s2,a0
 9dc:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9de:	00001797          	auipc	a5,0x1
 9e2:	b3a7b783          	ld	a5,-1222(a5) # 1518 <stacks>
 9e6:	c3d9                	beqz	a5,a6c <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9e8:	00001797          	auipc	a5,0x1
 9ec:	b187a783          	lw	a5,-1256(a5) # 1500 <max_stacks>
 9f0:	00001717          	auipc	a4,0x1
 9f4:	b3072703          	lw	a4,-1232(a4) # 1520 <num_threads>
 9f8:	0af71463          	bne	a4,a5,aa0 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 9fc:	04000713          	li	a4,64
 a00:	08e78563          	beq	a5,a4,a8a <ithread_create+0xbc>
 a04:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a06:	00000097          	auipc	ra,0x0
 a0a:	f64080e7          	jalr	-156(ra) # 96a <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a0e:	6505                	lui	a0,0x1
 a10:	00000097          	auipc	ra,0x0
 a14:	db8080e7          	jalr	-584(ra) # 7c8 <malloc>
 a18:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a1a:	00001717          	auipc	a4,0x1
 a1e:	b0672703          	lw	a4,-1274(a4) # 1520 <num_threads>
 a22:	070e                	slli	a4,a4,0x3
 a24:	00001797          	auipc	a5,0x1
 a28:	af47b783          	ld	a5,-1292(a5) # 1518 <stacks>
 a2c:	97ba                	add	a5,a5,a4
 a2e:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a30:	00000697          	auipc	a3,0x0
 a34:	e9268693          	addi	a3,a3,-366 # 8c2 <ithread_exit>
 a38:	862a                	mv	a2,a0
 a3a:	85ce                	mv	a1,s3
 a3c:	854a                	mv	a0,s2
 a3e:	00000097          	auipc	ra,0x0
 a42:	9a2080e7          	jalr	-1630(ra) # 3e0 <create_thread>
 a46:	892a                	mv	s2,a0
  if (res != -1) {
 a48:	57fd                	li	a5,-1
 a4a:	04f50d63          	beq	a0,a5,aa4 <ithread_create+0xd6>
    num_threads++;
 a4e:	00001717          	auipc	a4,0x1
 a52:	ad270713          	addi	a4,a4,-1326 # 1520 <num_threads>
 a56:	431c                	lw	a5,0(a4)
 a58:	2785                	addiw	a5,a5,1
 a5a:	c31c                	sw	a5,0(a4)
 a5c:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a5e:	854a                	mv	a0,s2
 a60:	70a2                	ld	ra,40(sp)
 a62:	7402                	ld	s0,32(sp)
 a64:	6942                	ld	s2,16(sp)
 a66:	69a2                	ld	s3,8(sp)
 a68:	6145                	addi	sp,sp,48
 a6a:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a6c:	00001517          	auipc	a0,0x1
 a70:	a9452503          	lw	a0,-1388(a0) # 1500 <max_stacks>
 a74:	0035151b          	slliw	a0,a0,0x3
 a78:	00000097          	auipc	ra,0x0
 a7c:	d50080e7          	jalr	-688(ra) # 7c8 <malloc>
 a80:	00001797          	auipc	a5,0x1
 a84:	a8a7bc23          	sd	a0,-1384(a5) # 1518 <stacks>
 a88:	b785                	j	9e8 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a8a:	00000517          	auipc	a0,0x0
 a8e:	0ae50513          	addi	a0,a0,174 # b38 <ithread_join+0x6e>
 a92:	00000097          	auipc	ra,0x0
 a96:	c7a080e7          	jalr	-902(ra) # 70c <printf>
      return -1;
 a9a:	57fd                	li	a5,-1
 a9c:	893e                	mv	s2,a5
 a9e:	b7c1                	j	a5e <ithread_create+0x90>
 aa0:	ec26                	sd	s1,24(sp)
 aa2:	b7b5                	j	a0e <ithread_create+0x40>
    free(stack_ptr);
 aa4:	8526                	mv	a0,s1
 aa6:	00000097          	auipc	ra,0x0
 aaa:	c9c080e7          	jalr	-868(ra) # 742 <free>
    stacks[num_threads] = 0;
 aae:	00001717          	auipc	a4,0x1
 ab2:	a7272703          	lw	a4,-1422(a4) # 1520 <num_threads>
 ab6:	070e                	slli	a4,a4,0x3
 ab8:	00001797          	auipc	a5,0x1
 abc:	a607b783          	ld	a5,-1440(a5) # 1518 <stacks>
 ac0:	97ba                	add	a5,a5,a4
 ac2:	0007b023          	sd	zero,0(a5)
 ac6:	64e2                	ld	s1,24(sp)
 ac8:	bf59                	j	a5e <ithread_create+0x90>

0000000000000aca <ithread_join>:

int ithread_join(int thread_id) {
 aca:	1101                	addi	sp,sp,-32
 acc:	ec06                	sd	ra,24(sp)
 ace:	e822                	sd	s0,16(sp)
 ad0:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 ad2:	ff040793          	addi	a5,s0,-16
 ad6:	ffc7859b          	addiw	a1,a5,-4
 ada:	00000097          	auipc	ra,0x0
 ade:	90e080e7          	jalr	-1778(ra) # 3e8 <join_thread>
  threads_done++;
 ae2:	00001717          	auipc	a4,0x1
 ae6:	a4270713          	addi	a4,a4,-1470 # 1524 <threads_done>
 aea:	431c                	lw	a5,0(a4)
 aec:	2785                	addiw	a5,a5,1
 aee:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 af0:	00001717          	auipc	a4,0x1
 af4:	a3072703          	lw	a4,-1488(a4) # 1520 <num_threads>
 af8:	00f70863          	beq	a4,a5,b08 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 afc:	fec42503          	lw	a0,-20(s0)
 b00:	60e2                	ld	ra,24(sp)
 b02:	6442                	ld	s0,16(sp)
 b04:	6105                	addi	sp,sp,32
 b06:	8082                	ret
    free_stacks();
 b08:	00000097          	auipc	ra,0x0
 b0c:	dd4080e7          	jalr	-556(ra) # 8dc <free_stacks>
 b10:	b7f5                	j	afc <ithread_join+0x32>
