
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
  38:	a8cb0b13          	addi	s6,s6,-1396 # ac0 <ithread_join+0x46>
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
  78:	a5458593          	addi	a1,a1,-1452 # ac8 <ithread_join+0x4e>
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

00000000000003f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f8:	1101                	addi	sp,sp,-32
 3fa:	ec06                	sd	ra,24(sp)
 3fc:	e822                	sd	s0,16(sp)
 3fe:	1000                	addi	s0,sp,32
 400:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 404:	4605                	li	a2,1
 406:	fef40593          	addi	a1,s0,-17
 40a:	00000097          	auipc	ra,0x0
 40e:	f4e080e7          	jalr	-178(ra) # 358 <write>
}
 412:	60e2                	ld	ra,24(sp)
 414:	6442                	ld	s0,16(sp)
 416:	6105                	addi	sp,sp,32
 418:	8082                	ret

000000000000041a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41a:	7139                	addi	sp,sp,-64
 41c:	fc06                	sd	ra,56(sp)
 41e:	f822                	sd	s0,48(sp)
 420:	f04a                	sd	s2,32(sp)
 422:	ec4e                	sd	s3,24(sp)
 424:	0080                	addi	s0,sp,64
 426:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 428:	cad9                	beqz	a3,4be <printint+0xa4>
 42a:	01f5d79b          	srliw	a5,a1,0x1f
 42e:	cbc1                	beqz	a5,4be <printint+0xa4>
    neg = 1;
    x = -xx;
 430:	40b005bb          	negw	a1,a1
    neg = 1;
 434:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 436:	fc040993          	addi	s3,s0,-64
  neg = 0;
 43a:	86ce                	mv	a3,s3
  i = 0;
 43c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 43e:	00000817          	auipc	a6,0x0
 442:	72280813          	addi	a6,a6,1826 # b60 <digits>
 446:	88ba                	mv	a7,a4
 448:	0017051b          	addiw	a0,a4,1
 44c:	872a                	mv	a4,a0
 44e:	02c5f7bb          	remuw	a5,a1,a2
 452:	1782                	slli	a5,a5,0x20
 454:	9381                	srli	a5,a5,0x20
 456:	97c2                	add	a5,a5,a6
 458:	0007c783          	lbu	a5,0(a5)
 45c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 460:	87ae                	mv	a5,a1
 462:	02c5d5bb          	divuw	a1,a1,a2
 466:	0685                	addi	a3,a3,1
 468:	fcc7ffe3          	bgeu	a5,a2,446 <printint+0x2c>
  if(neg)
 46c:	00030c63          	beqz	t1,484 <printint+0x6a>
    buf[i++] = '-';
 470:	fd050793          	addi	a5,a0,-48
 474:	00878533          	add	a0,a5,s0
 478:	02d00793          	li	a5,45
 47c:	fef50823          	sb	a5,-16(a0)
 480:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 484:	02e05763          	blez	a4,4b2 <printint+0x98>
 488:	f426                	sd	s1,40(sp)
 48a:	377d                	addiw	a4,a4,-1
 48c:	00e984b3          	add	s1,s3,a4
 490:	19fd                	addi	s3,s3,-1
 492:	99ba                	add	s3,s3,a4
 494:	1702                	slli	a4,a4,0x20
 496:	9301                	srli	a4,a4,0x20
 498:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 49c:	0004c583          	lbu	a1,0(s1)
 4a0:	854a                	mv	a0,s2
 4a2:	00000097          	auipc	ra,0x0
 4a6:	f56080e7          	jalr	-170(ra) # 3f8 <putc>
  while(--i >= 0)
 4aa:	14fd                	addi	s1,s1,-1
 4ac:	ff3498e3          	bne	s1,s3,49c <printint+0x82>
 4b0:	74a2                	ld	s1,40(sp)
}
 4b2:	70e2                	ld	ra,56(sp)
 4b4:	7442                	ld	s0,48(sp)
 4b6:	7902                	ld	s2,32(sp)
 4b8:	69e2                	ld	s3,24(sp)
 4ba:	6121                	addi	sp,sp,64
 4bc:	8082                	ret
  neg = 0;
 4be:	4301                	li	t1,0
 4c0:	bf9d                	j	436 <printint+0x1c>

00000000000004c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c2:	715d                	addi	sp,sp,-80
 4c4:	e486                	sd	ra,72(sp)
 4c6:	e0a2                	sd	s0,64(sp)
 4c8:	f84a                	sd	s2,48(sp)
 4ca:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4cc:	0005c903          	lbu	s2,0(a1)
 4d0:	1a090b63          	beqz	s2,686 <vprintf+0x1c4>
 4d4:	fc26                	sd	s1,56(sp)
 4d6:	f44e                	sd	s3,40(sp)
 4d8:	f052                	sd	s4,32(sp)
 4da:	ec56                	sd	s5,24(sp)
 4dc:	e85a                	sd	s6,16(sp)
 4de:	e45e                	sd	s7,8(sp)
 4e0:	8aaa                	mv	s5,a0
 4e2:	8bb2                	mv	s7,a2
 4e4:	00158493          	addi	s1,a1,1
  state = 0;
 4e8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ea:	02500a13          	li	s4,37
 4ee:	4b55                	li	s6,21
 4f0:	a839                	j	50e <vprintf+0x4c>
        putc(fd, c);
 4f2:	85ca                	mv	a1,s2
 4f4:	8556                	mv	a0,s5
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f02080e7          	jalr	-254(ra) # 3f8 <putc>
 4fe:	a019                	j	504 <vprintf+0x42>
    } else if(state == '%'){
 500:	01498d63          	beq	s3,s4,51a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 504:	0485                	addi	s1,s1,1
 506:	fff4c903          	lbu	s2,-1(s1)
 50a:	16090863          	beqz	s2,67a <vprintf+0x1b8>
    if(state == 0){
 50e:	fe0999e3          	bnez	s3,500 <vprintf+0x3e>
      if(c == '%'){
 512:	ff4910e3          	bne	s2,s4,4f2 <vprintf+0x30>
        state = '%';
 516:	89d2                	mv	s3,s4
 518:	b7f5                	j	504 <vprintf+0x42>
      if(c == 'd'){
 51a:	13490563          	beq	s2,s4,644 <vprintf+0x182>
 51e:	f9d9079b          	addiw	a5,s2,-99
 522:	0ff7f793          	zext.b	a5,a5
 526:	12fb6863          	bltu	s6,a5,656 <vprintf+0x194>
 52a:	f9d9079b          	addiw	a5,s2,-99
 52e:	0ff7f713          	zext.b	a4,a5
 532:	12eb6263          	bltu	s6,a4,656 <vprintf+0x194>
 536:	00271793          	slli	a5,a4,0x2
 53a:	00000717          	auipc	a4,0x0
 53e:	5ce70713          	addi	a4,a4,1486 # b08 <ithread_join+0x8e>
 542:	97ba                	add	a5,a5,a4
 544:	439c                	lw	a5,0(a5)
 546:	97ba                	add	a5,a5,a4
 548:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 54a:	008b8913          	addi	s2,s7,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000ba583          	lw	a1,0(s7)
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	ec2080e7          	jalr	-318(ra) # 41a <printint>
 560:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 562:	4981                	li	s3,0
 564:	b745                	j	504 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 566:	008b8913          	addi	s2,s7,8
 56a:	4681                	li	a3,0
 56c:	4629                	li	a2,10
 56e:	000ba583          	lw	a1,0(s7)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	ea6080e7          	jalr	-346(ra) # 41a <printint>
 57c:	8bca                	mv	s7,s2
      state = 0;
 57e:	4981                	li	s3,0
 580:	b751                	j	504 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 582:	008b8913          	addi	s2,s7,8
 586:	4681                	li	a3,0
 588:	4641                	li	a2,16
 58a:	000ba583          	lw	a1,0(s7)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e8a080e7          	jalr	-374(ra) # 41a <printint>
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b7a5                	j	504 <vprintf+0x42>
 59e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5a0:	008b8793          	addi	a5,s7,8
 5a4:	8c3e                	mv	s8,a5
 5a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5aa:	03000593          	li	a1,48
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e48080e7          	jalr	-440(ra) # 3f8 <putc>
  putc(fd, 'x');
 5b8:	07800593          	li	a1,120
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e3a080e7          	jalr	-454(ra) # 3f8 <putc>
 5c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c8:	00000b97          	auipc	s7,0x0
 5cc:	598b8b93          	addi	s7,s7,1432 # b60 <digits>
 5d0:	03c9d793          	srli	a5,s3,0x3c
 5d4:	97de                	add	a5,a5,s7
 5d6:	0007c583          	lbu	a1,0(a5)
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e1c080e7          	jalr	-484(ra) # 3f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e4:	0992                	slli	s3,s3,0x4
 5e6:	397d                	addiw	s2,s2,-1
 5e8:	fe0914e3          	bnez	s2,5d0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5ec:	8be2                	mv	s7,s8
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	6c02                	ld	s8,0(sp)
 5f2:	bf09                	j	504 <vprintf+0x42>
        s = va_arg(ap, char*);
 5f4:	008b8993          	addi	s3,s7,8
 5f8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5fc:	02090163          	beqz	s2,61e <vprintf+0x15c>
        while(*s != 0){
 600:	00094583          	lbu	a1,0(s2)
 604:	c9a5                	beqz	a1,674 <vprintf+0x1b2>
          putc(fd, *s);
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	df0080e7          	jalr	-528(ra) # 3f8 <putc>
          s++;
 610:	0905                	addi	s2,s2,1
        while(*s != 0){
 612:	00094583          	lbu	a1,0(s2)
 616:	f9e5                	bnez	a1,606 <vprintf+0x144>
        s = va_arg(ap, char*);
 618:	8bce                	mv	s7,s3
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b5e5                	j	504 <vprintf+0x42>
          s = "(null)";
 61e:	00000917          	auipc	s2,0x0
 622:	4b290913          	addi	s2,s2,1202 # ad0 <ithread_join+0x56>
        while(*s != 0){
 626:	02800593          	li	a1,40
 62a:	bff1                	j	606 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 62c:	008b8913          	addi	s2,s7,8
 630:	000bc583          	lbu	a1,0(s7)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	dc2080e7          	jalr	-574(ra) # 3f8 <putc>
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	b5c9                	j	504 <vprintf+0x42>
        putc(fd, c);
 644:	02500593          	li	a1,37
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	dae080e7          	jalr	-594(ra) # 3f8 <putc>
      state = 0;
 652:	4981                	li	s3,0
 654:	bd45                	j	504 <vprintf+0x42>
        putc(fd, '%');
 656:	02500593          	li	a1,37
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	d9c080e7          	jalr	-612(ra) # 3f8 <putc>
        putc(fd, c);
 664:	85ca                	mv	a1,s2
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	d90080e7          	jalr	-624(ra) # 3f8 <putc>
      state = 0;
 670:	4981                	li	s3,0
 672:	bd49                	j	504 <vprintf+0x42>
        s = va_arg(ap, char*);
 674:	8bce                	mv	s7,s3
      state = 0;
 676:	4981                	li	s3,0
 678:	b571                	j	504 <vprintf+0x42>
 67a:	74e2                	ld	s1,56(sp)
 67c:	79a2                	ld	s3,40(sp)
 67e:	7a02                	ld	s4,32(sp)
 680:	6ae2                	ld	s5,24(sp)
 682:	6b42                	ld	s6,16(sp)
 684:	6ba2                	ld	s7,8(sp)
    }
  }
}
 686:	60a6                	ld	ra,72(sp)
 688:	6406                	ld	s0,64(sp)
 68a:	7942                	ld	s2,48(sp)
 68c:	6161                	addi	sp,sp,80
 68e:	8082                	ret

0000000000000690 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 690:	715d                	addi	sp,sp,-80
 692:	ec06                	sd	ra,24(sp)
 694:	e822                	sd	s0,16(sp)
 696:	1000                	addi	s0,sp,32
 698:	e010                	sd	a2,0(s0)
 69a:	e414                	sd	a3,8(s0)
 69c:	e818                	sd	a4,16(s0)
 69e:	ec1c                	sd	a5,24(s0)
 6a0:	03043023          	sd	a6,32(s0)
 6a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a8:	8622                	mv	a2,s0
 6aa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ae:	00000097          	auipc	ra,0x0
 6b2:	e14080e7          	jalr	-492(ra) # 4c2 <vprintf>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6161                	addi	sp,sp,80
 6bc:	8082                	ret

00000000000006be <printf>:

void
printf(const char *fmt, ...)
{
 6be:	711d                	addi	sp,sp,-96
 6c0:	ec06                	sd	ra,24(sp)
 6c2:	e822                	sd	s0,16(sp)
 6c4:	1000                	addi	s0,sp,32
 6c6:	e40c                	sd	a1,8(s0)
 6c8:	e810                	sd	a2,16(s0)
 6ca:	ec14                	sd	a3,24(s0)
 6cc:	f018                	sd	a4,32(s0)
 6ce:	f41c                	sd	a5,40(s0)
 6d0:	03043823          	sd	a6,48(s0)
 6d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d8:	00840613          	addi	a2,s0,8
 6dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e0:	85aa                	mv	a1,a0
 6e2:	4505                	li	a0,1
 6e4:	00000097          	auipc	ra,0x0
 6e8:	dde080e7          	jalr	-546(ra) # 4c2 <vprintf>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6125                	addi	sp,sp,96
 6f2:	8082                	ret

00000000000006f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f4:	1141                	addi	sp,sp,-16
 6f6:	e406                	sd	ra,8(sp)
 6f8:	e022                	sd	s0,0(sp)
 6fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	00001797          	auipc	a5,0x1
 704:	e107b783          	ld	a5,-496(a5) # 1510 <freep>
 708:	a039                	j	716 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	6398                	ld	a4,0(a5)
 70c:	00e7e463          	bltu	a5,a4,714 <free+0x20>
 710:	00e6ea63          	bltu	a3,a4,724 <free+0x30>
{
 714:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	fed7fae3          	bgeu	a5,a3,70a <free+0x16>
 71a:	6398                	ld	a4,0(a5)
 71c:	00e6e463          	bltu	a3,a4,724 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	fee7eae3          	bltu	a5,a4,714 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 724:	ff852583          	lw	a1,-8(a0)
 728:	6390                	ld	a2,0(a5)
 72a:	02059813          	slli	a6,a1,0x20
 72e:	01c85713          	srli	a4,a6,0x1c
 732:	9736                	add	a4,a4,a3
 734:	02e60563          	beq	a2,a4,75e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 73c:	4790                	lw	a2,8(a5)
 73e:	02061593          	slli	a1,a2,0x20
 742:	01c5d713          	srli	a4,a1,0x1c
 746:	973e                	add	a4,a4,a5
 748:	02e68263          	beq	a3,a4,76c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 74c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 74e:	00001717          	auipc	a4,0x1
 752:	dcf73123          	sd	a5,-574(a4) # 1510 <freep>
}
 756:	60a2                	ld	ra,8(sp)
 758:	6402                	ld	s0,0(sp)
 75a:	0141                	addi	sp,sp,16
 75c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 75e:	4618                	lw	a4,8(a2)
 760:	9f2d                	addw	a4,a4,a1
 762:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 766:	6398                	ld	a4,0(a5)
 768:	6310                	ld	a2,0(a4)
 76a:	b7f9                	j	738 <free+0x44>
    p->s.size += bp->s.size;
 76c:	ff852703          	lw	a4,-8(a0)
 770:	9f31                	addw	a4,a4,a2
 772:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 774:	ff053683          	ld	a3,-16(a0)
 778:	bfd1                	j	74c <free+0x58>

000000000000077a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77a:	7139                	addi	sp,sp,-64
 77c:	fc06                	sd	ra,56(sp)
 77e:	f822                	sd	s0,48(sp)
 780:	f04a                	sd	s2,32(sp)
 782:	ec4e                	sd	s3,24(sp)
 784:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 786:	02051993          	slli	s3,a0,0x20
 78a:	0209d993          	srli	s3,s3,0x20
 78e:	09bd                	addi	s3,s3,15
 790:	0049d993          	srli	s3,s3,0x4
 794:	2985                	addiw	s3,s3,1
 796:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 798:	00001517          	auipc	a0,0x1
 79c:	d7853503          	ld	a0,-648(a0) # 1510 <freep>
 7a0:	c905                	beqz	a0,7d0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a4:	4798                	lw	a4,8(a5)
 7a6:	09377a63          	bgeu	a4,s3,83a <malloc+0xc0>
 7aa:	f426                	sd	s1,40(sp)
 7ac:	e852                	sd	s4,16(sp)
 7ae:	e456                	sd	s5,8(sp)
 7b0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b2:	8a4e                	mv	s4,s3
 7b4:	6705                	lui	a4,0x1
 7b6:	00e9f363          	bgeu	s3,a4,7bc <malloc+0x42>
 7ba:	6a05                	lui	s4,0x1
 7bc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c4:	00001497          	auipc	s1,0x1
 7c8:	d4c48493          	addi	s1,s1,-692 # 1510 <freep>
  if(p == (char*)-1)
 7cc:	5afd                	li	s5,-1
 7ce:	a089                	j	810 <malloc+0x96>
 7d0:	f426                	sd	s1,40(sp)
 7d2:	e852                	sd	s4,16(sp)
 7d4:	e456                	sd	s5,8(sp)
 7d6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7d8:	00001797          	auipc	a5,0x1
 7dc:	d5878793          	addi	a5,a5,-680 # 1530 <base>
 7e0:	00001717          	auipc	a4,0x1
 7e4:	d2f73823          	sd	a5,-720(a4) # 1510 <freep>
 7e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ee:	b7d1                	j	7b2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7f0:	6398                	ld	a4,0(a5)
 7f2:	e118                	sd	a4,0(a0)
 7f4:	a8b9                	j	852 <malloc+0xd8>
  hp->s.size = nu;
 7f6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fa:	0541                	addi	a0,a0,16
 7fc:	00000097          	auipc	ra,0x0
 800:	ef8080e7          	jalr	-264(ra) # 6f4 <free>
  return freep;
 804:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 806:	c135                	beqz	a0,86a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80a:	4798                	lw	a4,8(a5)
 80c:	03277363          	bgeu	a4,s2,832 <malloc+0xb8>
    if(p == freep)
 810:	6098                	ld	a4,0(s1)
 812:	853e                	mv	a0,a5
 814:	fef71ae3          	bne	a4,a5,808 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 818:	8552                	mv	a0,s4
 81a:	00000097          	auipc	ra,0x0
 81e:	ba6080e7          	jalr	-1114(ra) # 3c0 <sbrk>
  if(p == (char*)-1)
 822:	fd551ae3          	bne	a0,s5,7f6 <malloc+0x7c>
        return 0;
 826:	4501                	li	a0,0
 828:	74a2                	ld	s1,40(sp)
 82a:	6a42                	ld	s4,16(sp)
 82c:	6aa2                	ld	s5,8(sp)
 82e:	6b02                	ld	s6,0(sp)
 830:	a03d                	j	85e <malloc+0xe4>
 832:	74a2                	ld	s1,40(sp)
 834:	6a42                	ld	s4,16(sp)
 836:	6aa2                	ld	s5,8(sp)
 838:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 83a:	fae90be3          	beq	s2,a4,7f0 <malloc+0x76>
        p->s.size -= nunits;
 83e:	4137073b          	subw	a4,a4,s3
 842:	c798                	sw	a4,8(a5)
        p += p->s.size;
 844:	02071693          	slli	a3,a4,0x20
 848:	01c6d713          	srli	a4,a3,0x1c
 84c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 84e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 852:	00001717          	auipc	a4,0x1
 856:	caa73f23          	sd	a0,-834(a4) # 1510 <freep>
      return (void*)(p + 1);
 85a:	01078513          	addi	a0,a5,16
  }
}
 85e:	70e2                	ld	ra,56(sp)
 860:	7442                	ld	s0,48(sp)
 862:	7902                	ld	s2,32(sp)
 864:	69e2                	ld	s3,24(sp)
 866:	6121                	addi	sp,sp,64
 868:	8082                	ret
 86a:	74a2                	ld	s1,40(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6b02                	ld	s6,0(sp)
 872:	b7f5                	j	85e <malloc+0xe4>

0000000000000874 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 874:	1141                	addi	sp,sp,-16
 876:	e406                	sd	ra,8(sp)
 878:	e022                	sd	s0,0(sp)
 87a:	0800                	addi	s0,sp,16
  thread_exit(status);
 87c:	00000097          	auipc	ra,0x0
 880:	b74080e7          	jalr	-1164(ra) # 3f0 <thread_exit>
}
 884:	60a2                	ld	ra,8(sp)
 886:	6402                	ld	s0,0(sp)
 888:	0141                	addi	sp,sp,16
 88a:	8082                	ret

000000000000088c <free_stacks>:
int free_stacks() {
 88c:	7179                	addi	sp,sp,-48
 88e:	f406                	sd	ra,40(sp)
 890:	f022                	sd	s0,32(sp)
 892:	ec26                	sd	s1,24(sp)
 894:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 896:	00001797          	auipc	a5,0x1
 89a:	c8a7a783          	lw	a5,-886(a5) # 1520 <num_threads>
 89e:	04f05063          	blez	a5,8de <free_stacks+0x52>
 8a2:	e84a                	sd	s2,16(sp)
 8a4:	e44e                	sd	s3,8(sp)
 8a6:	4481                	li	s1,0
    free(stacks[i]);
 8a8:	00001997          	auipc	s3,0x1
 8ac:	c7098993          	addi	s3,s3,-912 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8b0:	00001917          	auipc	s2,0x1
 8b4:	c7090913          	addi	s2,s2,-912 # 1520 <num_threads>
    free(stacks[i]);
 8b8:	0009b783          	ld	a5,0(s3)
 8bc:	00349713          	slli	a4,s1,0x3
 8c0:	97ba                	add	a5,a5,a4
 8c2:	6388                	ld	a0,0(a5)
 8c4:	00000097          	auipc	ra,0x0
 8c8:	e30080e7          	jalr	-464(ra) # 6f4 <free>
  for (int i = 0; i < num_threads; i++) {
 8cc:	0485                	addi	s1,s1,1
 8ce:	00092703          	lw	a4,0(s2)
 8d2:	0004879b          	sext.w	a5,s1
 8d6:	fee7c1e3          	blt	a5,a4,8b8 <free_stacks+0x2c>
 8da:	6942                	ld	s2,16(sp)
 8dc:	69a2                	ld	s3,8(sp)
  free(stacks);
 8de:	00001497          	auipc	s1,0x1
 8e2:	c3a48493          	addi	s1,s1,-966 # 1518 <stacks>
 8e6:	6088                	ld	a0,0(s1)
 8e8:	00000097          	auipc	ra,0x0
 8ec:	e0c080e7          	jalr	-500(ra) # 6f4 <free>
  stacks = 0;
 8f0:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8f4:	00001797          	auipc	a5,0x1
 8f8:	c207a623          	sw	zero,-980(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8fc:	47a1                	li	a5,8
 8fe:	00001717          	auipc	a4,0x1
 902:	c0f72123          	sw	a5,-1022(a4) # 1500 <max_stacks>
  threads_done = 0;
 906:	00001797          	auipc	a5,0x1
 90a:	c007af23          	sw	zero,-994(a5) # 1524 <threads_done>
}
 90e:	4501                	li	a0,0
 910:	70a2                	ld	ra,40(sp)
 912:	7402                	ld	s0,32(sp)
 914:	64e2                	ld	s1,24(sp)
 916:	6145                	addi	sp,sp,48
 918:	8082                	ret

000000000000091a <expand_num_threads>:
int expand_num_threads() {
 91a:	1101                	addi	sp,sp,-32
 91c:	ec06                	sd	ra,24(sp)
 91e:	e822                	sd	s0,16(sp)
 920:	e426                	sd	s1,8(sp)
 922:	e04a                	sd	s2,0(sp)
 924:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 926:	00001797          	auipc	a5,0x1
 92a:	bda78793          	addi	a5,a5,-1062 # 1500 <max_stacks>
 92e:	4388                	lw	a0,0(a5)
 930:	0015151b          	slliw	a0,a0,0x1
 934:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 936:	0035151b          	slliw	a0,a0,0x3
 93a:	00000097          	auipc	ra,0x0
 93e:	e40080e7          	jalr	-448(ra) # 77a <malloc>
 942:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 944:	00001617          	auipc	a2,0x1
 948:	bdc62603          	lw	a2,-1060(a2) # 1520 <num_threads>
 94c:	00001497          	auipc	s1,0x1
 950:	bcc48493          	addi	s1,s1,-1076 # 1518 <stacks>
 954:	0036161b          	slliw	a2,a2,0x3
 958:	608c                	ld	a1,0(s1)
 95a:	00000097          	auipc	ra,0x0
 95e:	928080e7          	jalr	-1752(ra) # 282 <memmove>
  free(stacks);
 962:	6088                	ld	a0,0(s1)
 964:	00000097          	auipc	ra,0x0
 968:	d90080e7          	jalr	-624(ra) # 6f4 <free>
  stacks = new_stacks;
 96c:	0124b023          	sd	s2,0(s1)
}
 970:	4501                	li	a0,0
 972:	60e2                	ld	ra,24(sp)
 974:	6442                	ld	s0,16(sp)
 976:	64a2                	ld	s1,8(sp)
 978:	6902                	ld	s2,0(sp)
 97a:	6105                	addi	sp,sp,32
 97c:	8082                	ret

000000000000097e <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 97e:	7179                	addi	sp,sp,-48
 980:	f406                	sd	ra,40(sp)
 982:	f022                	sd	s0,32(sp)
 984:	e84a                	sd	s2,16(sp)
 986:	e44e                	sd	s3,8(sp)
 988:	1800                	addi	s0,sp,48
 98a:	892a                	mv	s2,a0
 98c:	89ae                	mv	s3,a1
  if (stacks == 0) {
 98e:	00001797          	auipc	a5,0x1
 992:	b8a7b783          	ld	a5,-1142(a5) # 1518 <stacks>
 996:	c3d9                	beqz	a5,a1c <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 998:	00001797          	auipc	a5,0x1
 99c:	b687a783          	lw	a5,-1176(a5) # 1500 <max_stacks>
 9a0:	00001717          	auipc	a4,0x1
 9a4:	b8072703          	lw	a4,-1152(a4) # 1520 <num_threads>
 9a8:	0af71463          	bne	a4,a5,a50 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 9ac:	04000713          	li	a4,64
 9b0:	08e78563          	beq	a5,a4,a3a <ithread_create+0xbc>
 9b4:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9b6:	00000097          	auipc	ra,0x0
 9ba:	f64080e7          	jalr	-156(ra) # 91a <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9be:	6505                	lui	a0,0x1
 9c0:	00000097          	auipc	ra,0x0
 9c4:	dba080e7          	jalr	-582(ra) # 77a <malloc>
 9c8:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9ca:	00001717          	auipc	a4,0x1
 9ce:	b5672703          	lw	a4,-1194(a4) # 1520 <num_threads>
 9d2:	070e                	slli	a4,a4,0x3
 9d4:	00001797          	auipc	a5,0x1
 9d8:	b447b783          	ld	a5,-1212(a5) # 1518 <stacks>
 9dc:	97ba                	add	a5,a5,a4
 9de:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9e0:	00000697          	auipc	a3,0x0
 9e4:	e9468693          	addi	a3,a3,-364 # 874 <ithread_exit>
 9e8:	862a                	mv	a2,a0
 9ea:	85ce                	mv	a1,s3
 9ec:	854a                	mv	a0,s2
 9ee:	00000097          	auipc	ra,0x0
 9f2:	9f2080e7          	jalr	-1550(ra) # 3e0 <create_thread>
 9f6:	892a                	mv	s2,a0
  if (res != -1) {
 9f8:	57fd                	li	a5,-1
 9fa:	04f50d63          	beq	a0,a5,a54 <ithread_create+0xd6>
    num_threads++;
 9fe:	00001717          	auipc	a4,0x1
 a02:	b2270713          	addi	a4,a4,-1246 # 1520 <num_threads>
 a06:	431c                	lw	a5,0(a4)
 a08:	2785                	addiw	a5,a5,1
 a0a:	c31c                	sw	a5,0(a4)
 a0c:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a0e:	854a                	mv	a0,s2
 a10:	70a2                	ld	ra,40(sp)
 a12:	7402                	ld	s0,32(sp)
 a14:	6942                	ld	s2,16(sp)
 a16:	69a2                	ld	s3,8(sp)
 a18:	6145                	addi	sp,sp,48
 a1a:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a1c:	00001517          	auipc	a0,0x1
 a20:	ae452503          	lw	a0,-1308(a0) # 1500 <max_stacks>
 a24:	0035151b          	slliw	a0,a0,0x3
 a28:	00000097          	auipc	ra,0x0
 a2c:	d52080e7          	jalr	-686(ra) # 77a <malloc>
 a30:	00001797          	auipc	a5,0x1
 a34:	aea7b423          	sd	a0,-1304(a5) # 1518 <stacks>
 a38:	b785                	j	998 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a3a:	00000517          	auipc	a0,0x0
 a3e:	09e50513          	addi	a0,a0,158 # ad8 <ithread_join+0x5e>
 a42:	00000097          	auipc	ra,0x0
 a46:	c7c080e7          	jalr	-900(ra) # 6be <printf>
      return -1;
 a4a:	57fd                	li	a5,-1
 a4c:	893e                	mv	s2,a5
 a4e:	b7c1                	j	a0e <ithread_create+0x90>
 a50:	ec26                	sd	s1,24(sp)
 a52:	b7b5                	j	9be <ithread_create+0x40>
    free(stack_ptr);
 a54:	8526                	mv	a0,s1
 a56:	00000097          	auipc	ra,0x0
 a5a:	c9e080e7          	jalr	-866(ra) # 6f4 <free>
    stacks[num_threads] = 0;
 a5e:	00001717          	auipc	a4,0x1
 a62:	ac272703          	lw	a4,-1342(a4) # 1520 <num_threads>
 a66:	070e                	slli	a4,a4,0x3
 a68:	00001797          	auipc	a5,0x1
 a6c:	ab07b783          	ld	a5,-1360(a5) # 1518 <stacks>
 a70:	97ba                	add	a5,a5,a4
 a72:	0007b023          	sd	zero,0(a5)
 a76:	64e2                	ld	s1,24(sp)
 a78:	bf59                	j	a0e <ithread_create+0x90>

0000000000000a7a <ithread_join>:

int ithread_join(int thread_id) {
 a7a:	1101                	addi	sp,sp,-32
 a7c:	ec06                	sd	ra,24(sp)
 a7e:	e822                	sd	s0,16(sp)
 a80:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a82:	fec40593          	addi	a1,s0,-20
 a86:	00000097          	auipc	ra,0x0
 a8a:	962080e7          	jalr	-1694(ra) # 3e8 <join_thread>
  threads_done++;
 a8e:	00001717          	auipc	a4,0x1
 a92:	a9670713          	addi	a4,a4,-1386 # 1524 <threads_done>
 a96:	431c                	lw	a5,0(a4)
 a98:	2785                	addiw	a5,a5,1
 a9a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a9c:	00001717          	auipc	a4,0x1
 aa0:	a8472703          	lw	a4,-1404(a4) # 1520 <num_threads>
 aa4:	00f70863          	beq	a4,a5,ab4 <ithread_join+0x3a>
    free_stacks();
  }
  return status;
}
 aa8:	fec42503          	lw	a0,-20(s0)
 aac:	60e2                	ld	ra,24(sp)
 aae:	6442                	ld	s0,16(sp)
 ab0:	6105                	addi	sp,sp,32
 ab2:	8082                	ret
    free_stacks();
 ab4:	00000097          	auipc	ra,0x0
 ab8:	dd8080e7          	jalr	-552(ra) # 88c <free_stacks>
 abc:	b7f5                	j	aa8 <ithread_join+0x2e>
