
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
  38:	abcb0b13          	addi	s6,s6,-1348 # af0 <ithread_join+0x4c>
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
  78:	a8458593          	addi	a1,a1,-1404 # af8 <ithread_join+0x54>
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

0000000000000420 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 420:	1101                	addi	sp,sp,-32
 422:	ec06                	sd	ra,24(sp)
 424:	e822                	sd	s0,16(sp)
 426:	1000                	addi	s0,sp,32
 428:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42c:	4605                	li	a2,1
 42e:	fef40593          	addi	a1,s0,-17
 432:	00000097          	auipc	ra,0x0
 436:	f26080e7          	jalr	-218(ra) # 358 <write>
}
 43a:	60e2                	ld	ra,24(sp)
 43c:	6442                	ld	s0,16(sp)
 43e:	6105                	addi	sp,sp,32
 440:	8082                	ret

0000000000000442 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 442:	7139                	addi	sp,sp,-64
 444:	fc06                	sd	ra,56(sp)
 446:	f822                	sd	s0,48(sp)
 448:	f04a                	sd	s2,32(sp)
 44a:	ec4e                	sd	s3,24(sp)
 44c:	0080                	addi	s0,sp,64
 44e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 450:	cad9                	beqz	a3,4e6 <printint+0xa4>
 452:	01f5d79b          	srliw	a5,a1,0x1f
 456:	cbc1                	beqz	a5,4e6 <printint+0xa4>
    neg = 1;
    x = -xx;
 458:	40b005bb          	negw	a1,a1
    neg = 1;
 45c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 45e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 462:	86ce                	mv	a3,s3
  i = 0;
 464:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 466:	00000817          	auipc	a6,0x0
 46a:	72a80813          	addi	a6,a6,1834 # b90 <digits>
 46e:	88ba                	mv	a7,a4
 470:	0017051b          	addiw	a0,a4,1
 474:	872a                	mv	a4,a0
 476:	02c5f7bb          	remuw	a5,a1,a2
 47a:	1782                	slli	a5,a5,0x20
 47c:	9381                	srli	a5,a5,0x20
 47e:	97c2                	add	a5,a5,a6
 480:	0007c783          	lbu	a5,0(a5)
 484:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 488:	87ae                	mv	a5,a1
 48a:	02c5d5bb          	divuw	a1,a1,a2
 48e:	0685                	addi	a3,a3,1
 490:	fcc7ffe3          	bgeu	a5,a2,46e <printint+0x2c>
  if(neg)
 494:	00030c63          	beqz	t1,4ac <printint+0x6a>
    buf[i++] = '-';
 498:	fd050793          	addi	a5,a0,-48
 49c:	00878533          	add	a0,a5,s0
 4a0:	02d00793          	li	a5,45
 4a4:	fef50823          	sb	a5,-16(a0)
 4a8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4ac:	02e05763          	blez	a4,4da <printint+0x98>
 4b0:	f426                	sd	s1,40(sp)
 4b2:	377d                	addiw	a4,a4,-1
 4b4:	00e984b3          	add	s1,s3,a4
 4b8:	19fd                	addi	s3,s3,-1
 4ba:	99ba                	add	s3,s3,a4
 4bc:	1702                	slli	a4,a4,0x20
 4be:	9301                	srli	a4,a4,0x20
 4c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c4:	0004c583          	lbu	a1,0(s1)
 4c8:	854a                	mv	a0,s2
 4ca:	00000097          	auipc	ra,0x0
 4ce:	f56080e7          	jalr	-170(ra) # 420 <putc>
  while(--i >= 0)
 4d2:	14fd                	addi	s1,s1,-1
 4d4:	ff3498e3          	bne	s1,s3,4c4 <printint+0x82>
 4d8:	74a2                	ld	s1,40(sp)
}
 4da:	70e2                	ld	ra,56(sp)
 4dc:	7442                	ld	s0,48(sp)
 4de:	7902                	ld	s2,32(sp)
 4e0:	69e2                	ld	s3,24(sp)
 4e2:	6121                	addi	sp,sp,64
 4e4:	8082                	ret
  neg = 0;
 4e6:	4301                	li	t1,0
 4e8:	bf9d                	j	45e <printint+0x1c>

00000000000004ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ea:	715d                	addi	sp,sp,-80
 4ec:	e486                	sd	ra,72(sp)
 4ee:	e0a2                	sd	s0,64(sp)
 4f0:	f84a                	sd	s2,48(sp)
 4f2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f4:	0005c903          	lbu	s2,0(a1)
 4f8:	1a090b63          	beqz	s2,6ae <vprintf+0x1c4>
 4fc:	fc26                	sd	s1,56(sp)
 4fe:	f44e                	sd	s3,40(sp)
 500:	f052                	sd	s4,32(sp)
 502:	ec56                	sd	s5,24(sp)
 504:	e85a                	sd	s6,16(sp)
 506:	e45e                	sd	s7,8(sp)
 508:	8aaa                	mv	s5,a0
 50a:	8bb2                	mv	s7,a2
 50c:	00158493          	addi	s1,a1,1
  state = 0;
 510:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 512:	02500a13          	li	s4,37
 516:	4b55                	li	s6,21
 518:	a839                	j	536 <vprintf+0x4c>
        putc(fd, c);
 51a:	85ca                	mv	a1,s2
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	f02080e7          	jalr	-254(ra) # 420 <putc>
 526:	a019                	j	52c <vprintf+0x42>
    } else if(state == '%'){
 528:	01498d63          	beq	s3,s4,542 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 52c:	0485                	addi	s1,s1,1
 52e:	fff4c903          	lbu	s2,-1(s1)
 532:	16090863          	beqz	s2,6a2 <vprintf+0x1b8>
    if(state == 0){
 536:	fe0999e3          	bnez	s3,528 <vprintf+0x3e>
      if(c == '%'){
 53a:	ff4910e3          	bne	s2,s4,51a <vprintf+0x30>
        state = '%';
 53e:	89d2                	mv	s3,s4
 540:	b7f5                	j	52c <vprintf+0x42>
      if(c == 'd'){
 542:	13490563          	beq	s2,s4,66c <vprintf+0x182>
 546:	f9d9079b          	addiw	a5,s2,-99
 54a:	0ff7f793          	zext.b	a5,a5
 54e:	12fb6863          	bltu	s6,a5,67e <vprintf+0x194>
 552:	f9d9079b          	addiw	a5,s2,-99
 556:	0ff7f713          	zext.b	a4,a5
 55a:	12eb6263          	bltu	s6,a4,67e <vprintf+0x194>
 55e:	00271793          	slli	a5,a4,0x2
 562:	00000717          	auipc	a4,0x0
 566:	5d670713          	addi	a4,a4,1494 # b38 <ithread_join+0x94>
 56a:	97ba                	add	a5,a5,a4
 56c:	439c                	lw	a5,0(a5)
 56e:	97ba                	add	a5,a5,a4
 570:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 572:	008b8913          	addi	s2,s7,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000ba583          	lw	a1,0(s7)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	ec2080e7          	jalr	-318(ra) # 442 <printint>
 588:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b745                	j	52c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58e:	008b8913          	addi	s2,s7,8
 592:	4681                	li	a3,0
 594:	4629                	li	a2,10
 596:	000ba583          	lw	a1,0(s7)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	ea6080e7          	jalr	-346(ra) # 442 <printint>
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b751                	j	52c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4681                	li	a3,0
 5b0:	4641                	li	a2,16
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e8a080e7          	jalr	-374(ra) # 442 <printint>
 5c0:	8bca                	mv	s7,s2
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b7a5                	j	52c <vprintf+0x42>
 5c6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5c8:	008b8793          	addi	a5,s7,8
 5cc:	8c3e                	mv	s8,a5
 5ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5d2:	03000593          	li	a1,48
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e48080e7          	jalr	-440(ra) # 420 <putc>
  putc(fd, 'x');
 5e0:	07800593          	li	a1,120
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e3a080e7          	jalr	-454(ra) # 420 <putc>
 5ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f0:	00000b97          	auipc	s7,0x0
 5f4:	5a0b8b93          	addi	s7,s7,1440 # b90 <digits>
 5f8:	03c9d793          	srli	a5,s3,0x3c
 5fc:	97de                	add	a5,a5,s7
 5fe:	0007c583          	lbu	a1,0(a5)
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e1c080e7          	jalr	-484(ra) # 420 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60c:	0992                	slli	s3,s3,0x4
 60e:	397d                	addiw	s2,s2,-1
 610:	fe0914e3          	bnez	s2,5f8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 614:	8be2                	mv	s7,s8
      state = 0;
 616:	4981                	li	s3,0
 618:	6c02                	ld	s8,0(sp)
 61a:	bf09                	j	52c <vprintf+0x42>
        s = va_arg(ap, char*);
 61c:	008b8993          	addi	s3,s7,8
 620:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 624:	02090163          	beqz	s2,646 <vprintf+0x15c>
        while(*s != 0){
 628:	00094583          	lbu	a1,0(s2)
 62c:	c9a5                	beqz	a1,69c <vprintf+0x1b2>
          putc(fd, *s);
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	df0080e7          	jalr	-528(ra) # 420 <putc>
          s++;
 638:	0905                	addi	s2,s2,1
        while(*s != 0){
 63a:	00094583          	lbu	a1,0(s2)
 63e:	f9e5                	bnez	a1,62e <vprintf+0x144>
        s = va_arg(ap, char*);
 640:	8bce                	mv	s7,s3
      state = 0;
 642:	4981                	li	s3,0
 644:	b5e5                	j	52c <vprintf+0x42>
          s = "(null)";
 646:	00000917          	auipc	s2,0x0
 64a:	4ba90913          	addi	s2,s2,1210 # b00 <ithread_join+0x5c>
        while(*s != 0){
 64e:	02800593          	li	a1,40
 652:	bff1                	j	62e <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 654:	008b8913          	addi	s2,s7,8
 658:	000bc583          	lbu	a1,0(s7)
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	dc2080e7          	jalr	-574(ra) # 420 <putc>
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
 66a:	b5c9                	j	52c <vprintf+0x42>
        putc(fd, c);
 66c:	02500593          	li	a1,37
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	dae080e7          	jalr	-594(ra) # 420 <putc>
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bd45                	j	52c <vprintf+0x42>
        putc(fd, '%');
 67e:	02500593          	li	a1,37
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	d9c080e7          	jalr	-612(ra) # 420 <putc>
        putc(fd, c);
 68c:	85ca                	mv	a1,s2
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	d90080e7          	jalr	-624(ra) # 420 <putc>
      state = 0;
 698:	4981                	li	s3,0
 69a:	bd49                	j	52c <vprintf+0x42>
        s = va_arg(ap, char*);
 69c:	8bce                	mv	s7,s3
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b571                	j	52c <vprintf+0x42>
 6a2:	74e2                	ld	s1,56(sp)
 6a4:	79a2                	ld	s3,40(sp)
 6a6:	7a02                	ld	s4,32(sp)
 6a8:	6ae2                	ld	s5,24(sp)
 6aa:	6b42                	ld	s6,16(sp)
 6ac:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6ae:	60a6                	ld	ra,72(sp)
 6b0:	6406                	ld	s0,64(sp)
 6b2:	7942                	ld	s2,48(sp)
 6b4:	6161                	addi	sp,sp,80
 6b6:	8082                	ret

00000000000006b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b8:	715d                	addi	sp,sp,-80
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e010                	sd	a2,0(s0)
 6c2:	e414                	sd	a3,8(s0)
 6c4:	e818                	sd	a4,16(s0)
 6c6:	ec1c                	sd	a5,24(s0)
 6c8:	03043023          	sd	a6,32(s0)
 6cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d0:	8622                	mv	a2,s0
 6d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d6:	00000097          	auipc	ra,0x0
 6da:	e14080e7          	jalr	-492(ra) # 4ea <vprintf>
}
 6de:	60e2                	ld	ra,24(sp)
 6e0:	6442                	ld	s0,16(sp)
 6e2:	6161                	addi	sp,sp,80
 6e4:	8082                	ret

00000000000006e6 <printf>:

void
printf(const char *fmt, ...)
{
 6e6:	711d                	addi	sp,sp,-96
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	e40c                	sd	a1,8(s0)
 6f0:	e810                	sd	a2,16(s0)
 6f2:	ec14                	sd	a3,24(s0)
 6f4:	f018                	sd	a4,32(s0)
 6f6:	f41c                	sd	a5,40(s0)
 6f8:	03043823          	sd	a6,48(s0)
 6fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 700:	00840613          	addi	a2,s0,8
 704:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 708:	85aa                	mv	a1,a0
 70a:	4505                	li	a0,1
 70c:	00000097          	auipc	ra,0x0
 710:	dde080e7          	jalr	-546(ra) # 4ea <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6125                	addi	sp,sp,96
 71a:	8082                	ret

000000000000071c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71c:	1141                	addi	sp,sp,-16
 71e:	e406                	sd	ra,8(sp)
 720:	e022                	sd	s0,0(sp)
 722:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 724:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	00001797          	auipc	a5,0x1
 72c:	de87b783          	ld	a5,-536(a5) # 1510 <freep>
 730:	a039                	j	73e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	6398                	ld	a4,0(a5)
 734:	00e7e463          	bltu	a5,a4,73c <free+0x20>
 738:	00e6ea63          	bltu	a3,a4,74c <free+0x30>
{
 73c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73e:	fed7fae3          	bgeu	a5,a3,732 <free+0x16>
 742:	6398                	ld	a4,0(a5)
 744:	00e6e463          	bltu	a3,a4,74c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 748:	fee7eae3          	bltu	a5,a4,73c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 74c:	ff852583          	lw	a1,-8(a0)
 750:	6390                	ld	a2,0(a5)
 752:	02059813          	slli	a6,a1,0x20
 756:	01c85713          	srli	a4,a6,0x1c
 75a:	9736                	add	a4,a4,a3
 75c:	02e60563          	beq	a2,a4,786 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 764:	4790                	lw	a2,8(a5)
 766:	02061593          	slli	a1,a2,0x20
 76a:	01c5d713          	srli	a4,a1,0x1c
 76e:	973e                	add	a4,a4,a5
 770:	02e68263          	beq	a3,a4,794 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 774:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 776:	00001717          	auipc	a4,0x1
 77a:	d8f73d23          	sd	a5,-614(a4) # 1510 <freep>
}
 77e:	60a2                	ld	ra,8(sp)
 780:	6402                	ld	s0,0(sp)
 782:	0141                	addi	sp,sp,16
 784:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 786:	4618                	lw	a4,8(a2)
 788:	9f2d                	addw	a4,a4,a1
 78a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78e:	6398                	ld	a4,0(a5)
 790:	6310                	ld	a2,0(a4)
 792:	b7f9                	j	760 <free+0x44>
    p->s.size += bp->s.size;
 794:	ff852703          	lw	a4,-8(a0)
 798:	9f31                	addw	a4,a4,a2
 79a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 79c:	ff053683          	ld	a3,-16(a0)
 7a0:	bfd1                	j	774 <free+0x58>

00000000000007a2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a2:	7139                	addi	sp,sp,-64
 7a4:	fc06                	sd	ra,56(sp)
 7a6:	f822                	sd	s0,48(sp)
 7a8:	f04a                	sd	s2,32(sp)
 7aa:	ec4e                	sd	s3,24(sp)
 7ac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ae:	02051993          	slli	s3,a0,0x20
 7b2:	0209d993          	srli	s3,s3,0x20
 7b6:	09bd                	addi	s3,s3,15
 7b8:	0049d993          	srli	s3,s3,0x4
 7bc:	2985                	addiw	s3,s3,1
 7be:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7c0:	00001517          	auipc	a0,0x1
 7c4:	d5053503          	ld	a0,-688(a0) # 1510 <freep>
 7c8:	c905                	beqz	a0,7f8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7cc:	4798                	lw	a4,8(a5)
 7ce:	09377a63          	bgeu	a4,s3,862 <malloc+0xc0>
 7d2:	f426                	sd	s1,40(sp)
 7d4:	e852                	sd	s4,16(sp)
 7d6:	e456                	sd	s5,8(sp)
 7d8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7da:	8a4e                	mv	s4,s3
 7dc:	6705                	lui	a4,0x1
 7de:	00e9f363          	bgeu	s3,a4,7e4 <malloc+0x42>
 7e2:	6a05                	lui	s4,0x1
 7e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ec:	00001497          	auipc	s1,0x1
 7f0:	d2448493          	addi	s1,s1,-732 # 1510 <freep>
  if(p == (char*)-1)
 7f4:	5afd                	li	s5,-1
 7f6:	a089                	j	838 <malloc+0x96>
 7f8:	f426                	sd	s1,40(sp)
 7fa:	e852                	sd	s4,16(sp)
 7fc:	e456                	sd	s5,8(sp)
 7fe:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 800:	00001797          	auipc	a5,0x1
 804:	d3078793          	addi	a5,a5,-720 # 1530 <base>
 808:	00001717          	auipc	a4,0x1
 80c:	d0f73423          	sd	a5,-760(a4) # 1510 <freep>
 810:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 812:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 816:	b7d1                	j	7da <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 818:	6398                	ld	a4,0(a5)
 81a:	e118                	sd	a4,0(a0)
 81c:	a8b9                	j	87a <malloc+0xd8>
  hp->s.size = nu;
 81e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 822:	0541                	addi	a0,a0,16
 824:	00000097          	auipc	ra,0x0
 828:	ef8080e7          	jalr	-264(ra) # 71c <free>
  return freep;
 82c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 82e:	c135                	beqz	a0,892 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 830:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 832:	4798                	lw	a4,8(a5)
 834:	03277363          	bgeu	a4,s2,85a <malloc+0xb8>
    if(p == freep)
 838:	6098                	ld	a4,0(s1)
 83a:	853e                	mv	a0,a5
 83c:	fef71ae3          	bne	a4,a5,830 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 840:	8552                	mv	a0,s4
 842:	00000097          	auipc	ra,0x0
 846:	b7e080e7          	jalr	-1154(ra) # 3c0 <sbrk>
  if(p == (char*)-1)
 84a:	fd551ae3          	bne	a0,s5,81e <malloc+0x7c>
        return 0;
 84e:	4501                	li	a0,0
 850:	74a2                	ld	s1,40(sp)
 852:	6a42                	ld	s4,16(sp)
 854:	6aa2                	ld	s5,8(sp)
 856:	6b02                	ld	s6,0(sp)
 858:	a03d                	j	886 <malloc+0xe4>
 85a:	74a2                	ld	s1,40(sp)
 85c:	6a42                	ld	s4,16(sp)
 85e:	6aa2                	ld	s5,8(sp)
 860:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 862:	fae90be3          	beq	s2,a4,818 <malloc+0x76>
        p->s.size -= nunits;
 866:	4137073b          	subw	a4,a4,s3
 86a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86c:	02071693          	slli	a3,a4,0x20
 870:	01c6d713          	srli	a4,a3,0x1c
 874:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 876:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87a:	00001717          	auipc	a4,0x1
 87e:	c8a73b23          	sd	a0,-874(a4) # 1510 <freep>
      return (void*)(p + 1);
 882:	01078513          	addi	a0,a5,16
  }
}
 886:	70e2                	ld	ra,56(sp)
 888:	7442                	ld	s0,48(sp)
 88a:	7902                	ld	s2,32(sp)
 88c:	69e2                	ld	s3,24(sp)
 88e:	6121                	addi	sp,sp,64
 890:	8082                	ret
 892:	74a2                	ld	s1,40(sp)
 894:	6a42                	ld	s4,16(sp)
 896:	6aa2                	ld	s5,8(sp)
 898:	6b02                	ld	s6,0(sp)
 89a:	b7f5                	j	886 <malloc+0xe4>

000000000000089c <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 89c:	1141                	addi	sp,sp,-16
 89e:	e406                	sd	ra,8(sp)
 8a0:	e022                	sd	s0,0(sp)
 8a2:	0800                	addi	s0,sp,16
  thread_exit(status);
 8a4:	2501                	sext.w	a0,a0
 8a6:	00000097          	auipc	ra,0x0
 8aa:	b4a080e7          	jalr	-1206(ra) # 3f0 <thread_exit>
}
 8ae:	60a2                	ld	ra,8(sp)
 8b0:	6402                	ld	s0,0(sp)
 8b2:	0141                	addi	sp,sp,16
 8b4:	8082                	ret

00000000000008b6 <free_stacks>:
int free_stacks() {
 8b6:	7179                	addi	sp,sp,-48
 8b8:	f406                	sd	ra,40(sp)
 8ba:	f022                	sd	s0,32(sp)
 8bc:	ec26                	sd	s1,24(sp)
 8be:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8c0:	00001797          	auipc	a5,0x1
 8c4:	c607a783          	lw	a5,-928(a5) # 1520 <num_threads>
 8c8:	04f05063          	blez	a5,908 <free_stacks+0x52>
 8cc:	e84a                	sd	s2,16(sp)
 8ce:	e44e                	sd	s3,8(sp)
 8d0:	4481                	li	s1,0
    free(stacks[i]);
 8d2:	00001997          	auipc	s3,0x1
 8d6:	c4698993          	addi	s3,s3,-954 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8da:	00001917          	auipc	s2,0x1
 8de:	c4690913          	addi	s2,s2,-954 # 1520 <num_threads>
    free(stacks[i]);
 8e2:	0009b783          	ld	a5,0(s3)
 8e6:	00349713          	slli	a4,s1,0x3
 8ea:	97ba                	add	a5,a5,a4
 8ec:	6388                	ld	a0,0(a5)
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e2e080e7          	jalr	-466(ra) # 71c <free>
  for (int i = 0; i < num_threads; i++) {
 8f6:	0485                	addi	s1,s1,1
 8f8:	00092703          	lw	a4,0(s2)
 8fc:	0004879b          	sext.w	a5,s1
 900:	fee7c1e3          	blt	a5,a4,8e2 <free_stacks+0x2c>
 904:	6942                	ld	s2,16(sp)
 906:	69a2                	ld	s3,8(sp)
  free(stacks);
 908:	00001497          	auipc	s1,0x1
 90c:	c1048493          	addi	s1,s1,-1008 # 1518 <stacks>
 910:	6088                	ld	a0,0(s1)
 912:	00000097          	auipc	ra,0x0
 916:	e0a080e7          	jalr	-502(ra) # 71c <free>
  stacks = 0;
 91a:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 91e:	00001797          	auipc	a5,0x1
 922:	c007a123          	sw	zero,-1022(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 926:	47a1                	li	a5,8
 928:	00001717          	auipc	a4,0x1
 92c:	bcf72c23          	sw	a5,-1064(a4) # 1500 <max_stacks>
  threads_done = 0;
 930:	00001797          	auipc	a5,0x1
 934:	be07aa23          	sw	zero,-1036(a5) # 1524 <threads_done>
}
 938:	4501                	li	a0,0
 93a:	70a2                	ld	ra,40(sp)
 93c:	7402                	ld	s0,32(sp)
 93e:	64e2                	ld	s1,24(sp)
 940:	6145                	addi	sp,sp,48
 942:	8082                	ret

0000000000000944 <expand_num_threads>:
int expand_num_threads() {
 944:	1101                	addi	sp,sp,-32
 946:	ec06                	sd	ra,24(sp)
 948:	e822                	sd	s0,16(sp)
 94a:	e426                	sd	s1,8(sp)
 94c:	e04a                	sd	s2,0(sp)
 94e:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 950:	00001797          	auipc	a5,0x1
 954:	bb078793          	addi	a5,a5,-1104 # 1500 <max_stacks>
 958:	4388                	lw	a0,0(a5)
 95a:	0015151b          	slliw	a0,a0,0x1
 95e:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 960:	0035151b          	slliw	a0,a0,0x3
 964:	00000097          	auipc	ra,0x0
 968:	e3e080e7          	jalr	-450(ra) # 7a2 <malloc>
 96c:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 96e:	00001617          	auipc	a2,0x1
 972:	bb262603          	lw	a2,-1102(a2) # 1520 <num_threads>
 976:	00001497          	auipc	s1,0x1
 97a:	ba248493          	addi	s1,s1,-1118 # 1518 <stacks>
 97e:	0036161b          	slliw	a2,a2,0x3
 982:	608c                	ld	a1,0(s1)
 984:	00000097          	auipc	ra,0x0
 988:	8fe080e7          	jalr	-1794(ra) # 282 <memmove>
  free(stacks);
 98c:	6088                	ld	a0,0(s1)
 98e:	00000097          	auipc	ra,0x0
 992:	d8e080e7          	jalr	-626(ra) # 71c <free>
  stacks = new_stacks;
 996:	0124b023          	sd	s2,0(s1)
}
 99a:	4501                	li	a0,0
 99c:	60e2                	ld	ra,24(sp)
 99e:	6442                	ld	s0,16(sp)
 9a0:	64a2                	ld	s1,8(sp)
 9a2:	6902                	ld	s2,0(sp)
 9a4:	6105                	addi	sp,sp,32
 9a6:	8082                	ret

00000000000009a8 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9a8:	7179                	addi	sp,sp,-48
 9aa:	f406                	sd	ra,40(sp)
 9ac:	f022                	sd	s0,32(sp)
 9ae:	e84a                	sd	s2,16(sp)
 9b0:	e44e                	sd	s3,8(sp)
 9b2:	1800                	addi	s0,sp,48
 9b4:	892a                	mv	s2,a0
 9b6:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9b8:	00001797          	auipc	a5,0x1
 9bc:	b607b783          	ld	a5,-1184(a5) # 1518 <stacks>
 9c0:	c3d9                	beqz	a5,a46 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9c2:	00001797          	auipc	a5,0x1
 9c6:	b3e7a783          	lw	a5,-1218(a5) # 1500 <max_stacks>
 9ca:	00001717          	auipc	a4,0x1
 9ce:	b5672703          	lw	a4,-1194(a4) # 1520 <num_threads>
 9d2:	0af71463          	bne	a4,a5,a7a <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 9d6:	04000713          	li	a4,64
 9da:	08e78563          	beq	a5,a4,a64 <ithread_create+0xbc>
 9de:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9e0:	00000097          	auipc	ra,0x0
 9e4:	f64080e7          	jalr	-156(ra) # 944 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9e8:	6505                	lui	a0,0x1
 9ea:	00000097          	auipc	ra,0x0
 9ee:	db8080e7          	jalr	-584(ra) # 7a2 <malloc>
 9f2:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9f4:	00001717          	auipc	a4,0x1
 9f8:	b2c72703          	lw	a4,-1236(a4) # 1520 <num_threads>
 9fc:	070e                	slli	a4,a4,0x3
 9fe:	00001797          	auipc	a5,0x1
 a02:	b1a7b783          	ld	a5,-1254(a5) # 1518 <stacks>
 a06:	97ba                	add	a5,a5,a4
 a08:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a0a:	00000697          	auipc	a3,0x0
 a0e:	e9268693          	addi	a3,a3,-366 # 89c <ithread_exit>
 a12:	862a                	mv	a2,a0
 a14:	85ce                	mv	a1,s3
 a16:	854a                	mv	a0,s2
 a18:	00000097          	auipc	ra,0x0
 a1c:	9c8080e7          	jalr	-1592(ra) # 3e0 <create_thread>
 a20:	892a                	mv	s2,a0
  if (res != -1) {
 a22:	57fd                	li	a5,-1
 a24:	04f50d63          	beq	a0,a5,a7e <ithread_create+0xd6>
    num_threads++;
 a28:	00001717          	auipc	a4,0x1
 a2c:	af870713          	addi	a4,a4,-1288 # 1520 <num_threads>
 a30:	431c                	lw	a5,0(a4)
 a32:	2785                	addiw	a5,a5,1
 a34:	c31c                	sw	a5,0(a4)
 a36:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a38:	854a                	mv	a0,s2
 a3a:	70a2                	ld	ra,40(sp)
 a3c:	7402                	ld	s0,32(sp)
 a3e:	6942                	ld	s2,16(sp)
 a40:	69a2                	ld	s3,8(sp)
 a42:	6145                	addi	sp,sp,48
 a44:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a46:	00001517          	auipc	a0,0x1
 a4a:	aba52503          	lw	a0,-1350(a0) # 1500 <max_stacks>
 a4e:	0035151b          	slliw	a0,a0,0x3
 a52:	00000097          	auipc	ra,0x0
 a56:	d50080e7          	jalr	-688(ra) # 7a2 <malloc>
 a5a:	00001797          	auipc	a5,0x1
 a5e:	aaa7bf23          	sd	a0,-1346(a5) # 1518 <stacks>
 a62:	b785                	j	9c2 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a64:	00000517          	auipc	a0,0x0
 a68:	0a450513          	addi	a0,a0,164 # b08 <ithread_join+0x64>
 a6c:	00000097          	auipc	ra,0x0
 a70:	c7a080e7          	jalr	-902(ra) # 6e6 <printf>
      return -1;
 a74:	57fd                	li	a5,-1
 a76:	893e                	mv	s2,a5
 a78:	b7c1                	j	a38 <ithread_create+0x90>
 a7a:	ec26                	sd	s1,24(sp)
 a7c:	b7b5                	j	9e8 <ithread_create+0x40>
    free(stack_ptr);
 a7e:	8526                	mv	a0,s1
 a80:	00000097          	auipc	ra,0x0
 a84:	c9c080e7          	jalr	-868(ra) # 71c <free>
    stacks[num_threads] = 0;
 a88:	00001717          	auipc	a4,0x1
 a8c:	a9872703          	lw	a4,-1384(a4) # 1520 <num_threads>
 a90:	070e                	slli	a4,a4,0x3
 a92:	00001797          	auipc	a5,0x1
 a96:	a867b783          	ld	a5,-1402(a5) # 1518 <stacks>
 a9a:	97ba                	add	a5,a5,a4
 a9c:	0007b023          	sd	zero,0(a5)
 aa0:	64e2                	ld	s1,24(sp)
 aa2:	bf59                	j	a38 <ithread_create+0x90>

0000000000000aa4 <ithread_join>:

int ithread_join(int thread_id) {
 aa4:	1101                	addi	sp,sp,-32
 aa6:	ec06                	sd	ra,24(sp)
 aa8:	e822                	sd	s0,16(sp)
 aaa:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 aac:	ff040793          	addi	a5,s0,-16
 ab0:	ffc7859b          	addiw	a1,a5,-4
 ab4:	00000097          	auipc	ra,0x0
 ab8:	934080e7          	jalr	-1740(ra) # 3e8 <join_thread>
  threads_done++;
 abc:	00001717          	auipc	a4,0x1
 ac0:	a6870713          	addi	a4,a4,-1432 # 1524 <threads_done>
 ac4:	431c                	lw	a5,0(a4)
 ac6:	2785                	addiw	a5,a5,1
 ac8:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 aca:	00001717          	auipc	a4,0x1
 ace:	a5672703          	lw	a4,-1450(a4) # 1520 <num_threads>
 ad2:	00f70863          	beq	a4,a5,ae2 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ad6:	fec42503          	lw	a0,-20(s0)
 ada:	60e2                	ld	ra,24(sp)
 adc:	6442                	ld	s0,16(sp)
 ade:	6105                	addi	sp,sp,32
 ae0:	8082                	ret
    free_stacks();
 ae2:	00000097          	auipc	ra,0x0
 ae6:	dd4080e7          	jalr	-556(ra) # 8b6 <free_stacks>
 aea:	b7f5                	j	ad6 <ithread_join+0x32>
