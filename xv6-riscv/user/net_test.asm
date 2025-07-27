
user/_net_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <socket_test1>:
#include "kernel/types.h"
#include "kernel/sys/types.h"
#include "kernel/sys/socket.h"
#include "kernel/sys/net.h"

int socket_test1() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  struct addrinfo hints, *servinfo, *p;
  p->ai_family = AF_INET;
   8:	4781                	li	a5,0
   a:	0007a023          	sw	zero,0(a5)
  p->ai_socktype = SOCK_STREAM;
   e:	4705                	li	a4,1
  10:	c3d8                	sw	a4,4(a5)
  p->ai_protocol = 0;
  12:	0007a623          	sw	zero,12(a5)
  int fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
  16:	4601                	li	a2,0
  18:	85ba                	mv	a1,a4
  1a:	4501                	li	a0,0
  1c:	00000097          	auipc	ra,0x0
  20:	3b8080e7          	jalr	952(ra) # 3d4 <socket>

  if (fd == 0) 
  24:	ed11                	bnez	a0,40 <socket_test1+0x40>
    printf("socket_test1: PASSED\n");
  26:	00001517          	auipc	a0,0x1
  2a:	aaa50513          	addi	a0,a0,-1366 # ad0 <ithread_join+0x50>
  2e:	00000097          	auipc	ra,0x0
  32:	694080e7          	jalr	1684(ra) # 6c2 <printf>
  else
    printf("socket_test1: FAILED\n");

  return 0;
}
  36:	4501                	li	a0,0
  38:	60a2                	ld	ra,8(sp)
  3a:	6402                	ld	s0,0(sp)
  3c:	0141                	addi	sp,sp,16
  3e:	8082                	ret
    printf("socket_test1: FAILED\n");
  40:	00001517          	auipc	a0,0x1
  44:	aa850513          	addi	a0,a0,-1368 # ae8 <ithread_join+0x68>
  48:	00000097          	auipc	ra,0x0
  4c:	67a080e7          	jalr	1658(ra) # 6c2 <printf>
  50:	b7dd                	j	36 <socket_test1+0x36>

0000000000000052 <main>:

int main() {
  52:	1141                	addi	sp,sp,-16
  54:	e406                	sd	ra,8(sp)
  56:	e022                	sd	s0,0(sp)
  58:	0800                	addi	s0,sp,16
  socket_test1();
  5a:	00000097          	auipc	ra,0x0
  5e:	fa6080e7          	jalr	-90(ra) # 0 <socket_test1>
}
  62:	4501                	li	a0,0
  64:	60a2                	ld	ra,8(sp)
  66:	6402                	ld	s0,0(sp)
  68:	0141                	addi	sp,sp,16
  6a:	8082                	ret

000000000000006c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e406                	sd	ra,8(sp)
  70:	e022                	sd	s0,0(sp)
  72:	0800                	addi	s0,sp,16
  extern int main();
  main();
  74:	00000097          	auipc	ra,0x0
  78:	fde080e7          	jalr	-34(ra) # 52 <main>
  exit(0);
  7c:	4501                	li	a0,0
  7e:	00000097          	auipc	ra,0x0
  82:	296080e7          	jalr	662(ra) # 314 <exit>

0000000000000086 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  86:	1141                	addi	sp,sp,-16
  88:	e406                	sd	ra,8(sp)
  8a:	e022                	sd	s0,0(sp)
  8c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8e:	87aa                	mv	a5,a0
  90:	0585                	addi	a1,a1,1
  92:	0785                	addi	a5,a5,1
  94:	fff5c703          	lbu	a4,-1(a1)
  98:	fee78fa3          	sb	a4,-1(a5)
  9c:	fb75                	bnez	a4,90 <strcpy+0xa>
    ;
  return os;
}
  9e:	60a2                	ld	ra,8(sp)
  a0:	6402                	ld	s0,0(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret

00000000000000a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e406                	sd	ra,8(sp)
  aa:	e022                	sd	s0,0(sp)
  ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cb91                	beqz	a5,c6 <strcmp+0x20>
  b4:	0005c703          	lbu	a4,0(a1)
  b8:	00f71763          	bne	a4,a5,c6 <strcmp+0x20>
    p++, q++;
  bc:	0505                	addi	a0,a0,1
  be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	fbe5                	bnez	a5,b4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  c6:	0005c503          	lbu	a0,0(a1)
}
  ca:	40a7853b          	subw	a0,a5,a0
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret

00000000000000d6 <strlen>:

uint
strlen(const char *s)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cf91                	beqz	a5,fe <strlen+0x28>
  e4:	00150793          	addi	a5,a0,1
  e8:	86be                	mv	a3,a5
  ea:	0785                	addi	a5,a5,1
  ec:	fff7c703          	lbu	a4,-1(a5)
  f0:	ff65                	bnez	a4,e8 <strlen+0x12>
  f2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  f6:	60a2                	ld	ra,8(sp)
  f8:	6402                	ld	s0,0(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret
  for(n = 0; s[n]; n++)
  fe:	4501                	li	a0,0
 100:	bfdd                	j	f6 <strlen+0x20>

0000000000000102 <memset>:

void*
memset(void *dst, int c, uint n)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10a:	ca19                	beqz	a2,120 <memset+0x1e>
 10c:	87aa                	mv	a5,a0
 10e:	1602                	slli	a2,a2,0x20
 110:	9201                	srli	a2,a2,0x20
 112:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 116:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11a:	0785                	addi	a5,a5,1
 11c:	fee79de3          	bne	a5,a4,116 <memset+0x14>
  }
  return dst;
}
 120:	60a2                	ld	ra,8(sp)
 122:	6402                	ld	s0,0(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strchr>:

char*
strchr(const char *s, char c)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 130:	00054783          	lbu	a5,0(a0)
 134:	cf81                	beqz	a5,14c <strchr+0x24>
    if(*s == c)
 136:	00f58763          	beq	a1,a5,144 <strchr+0x1c>
  for(; *s; s++)
 13a:	0505                	addi	a0,a0,1
 13c:	00054783          	lbu	a5,0(a0)
 140:	fbfd                	bnez	a5,136 <strchr+0xe>
      return (char*)s;
  return 0;
 142:	4501                	li	a0,0
}
 144:	60a2                	ld	ra,8(sp)
 146:	6402                	ld	s0,0(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret
  return 0;
 14c:	4501                	li	a0,0
 14e:	bfdd                	j	144 <strchr+0x1c>

0000000000000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	711d                	addi	sp,sp,-96
 152:	ec86                	sd	ra,88(sp)
 154:	e8a2                	sd	s0,80(sp)
 156:	e4a6                	sd	s1,72(sp)
 158:	e0ca                	sd	s2,64(sp)
 15a:	fc4e                	sd	s3,56(sp)
 15c:	f852                	sd	s4,48(sp)
 15e:	f456                	sd	s5,40(sp)
 160:	f05a                	sd	s6,32(sp)
 162:	ec5e                	sd	s7,24(sp)
 164:	e862                	sd	s8,16(sp)
 166:	1080                	addi	s0,sp,96
 168:	8baa                	mv	s7,a0
 16a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16c:	892a                	mv	s2,a0
 16e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 170:	faf40b13          	addi	s6,s0,-81
 174:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 176:	8c26                	mv	s8,s1
 178:	0014899b          	addiw	s3,s1,1
 17c:	84ce                	mv	s1,s3
 17e:	0349d663          	bge	s3,s4,1aa <gets+0x5a>
    cc = read(0, &c, 1);
 182:	8656                	mv	a2,s5
 184:	85da                	mv	a1,s6
 186:	4501                	li	a0,0
 188:	00000097          	auipc	ra,0x0
 18c:	1a4080e7          	jalr	420(ra) # 32c <read>
    if(cc < 1)
 190:	00a05d63          	blez	a0,1aa <gets+0x5a>
      break;
    buf[i++] = c;
 194:	faf44783          	lbu	a5,-81(s0)
 198:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 19c:	0905                	addi	s2,s2,1
 19e:	ff678713          	addi	a4,a5,-10
 1a2:	c319                	beqz	a4,1a8 <gets+0x58>
 1a4:	17cd                	addi	a5,a5,-13
 1a6:	fbe1                	bnez	a5,176 <gets+0x26>
    buf[i++] = c;
 1a8:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1aa:	9c5e                	add	s8,s8,s7
 1ac:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1b0:	855e                	mv	a0,s7
 1b2:	60e6                	ld	ra,88(sp)
 1b4:	6446                	ld	s0,80(sp)
 1b6:	64a6                	ld	s1,72(sp)
 1b8:	6906                	ld	s2,64(sp)
 1ba:	79e2                	ld	s3,56(sp)
 1bc:	7a42                	ld	s4,48(sp)
 1be:	7aa2                	ld	s5,40(sp)
 1c0:	7b02                	ld	s6,32(sp)
 1c2:	6be2                	ld	s7,24(sp)
 1c4:	6c42                	ld	s8,16(sp)
 1c6:	6125                	addi	sp,sp,96
 1c8:	8082                	ret

00000000000001ca <stat>:

int
stat(const char *n, struct stat *st)
{
 1ca:	1101                	addi	sp,sp,-32
 1cc:	ec06                	sd	ra,24(sp)
 1ce:	e822                	sd	s0,16(sp)
 1d0:	e04a                	sd	s2,0(sp)
 1d2:	1000                	addi	s0,sp,32
 1d4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d6:	4581                	li	a1,0
 1d8:	00000097          	auipc	ra,0x0
 1dc:	17c080e7          	jalr	380(ra) # 354 <open>
  if(fd < 0)
 1e0:	02054663          	bltz	a0,20c <stat+0x42>
 1e4:	e426                	sd	s1,8(sp)
 1e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e8:	85ca                	mv	a1,s2
 1ea:	00000097          	auipc	ra,0x0
 1ee:	182080e7          	jalr	386(ra) # 36c <fstat>
 1f2:	892a                	mv	s2,a0
  close(fd);
 1f4:	8526                	mv	a0,s1
 1f6:	00000097          	auipc	ra,0x0
 1fa:	146080e7          	jalr	326(ra) # 33c <close>
  return r;
 1fe:	64a2                	ld	s1,8(sp)
}
 200:	854a                	mv	a0,s2
 202:	60e2                	ld	ra,24(sp)
 204:	6442                	ld	s0,16(sp)
 206:	6902                	ld	s2,0(sp)
 208:	6105                	addi	sp,sp,32
 20a:	8082                	ret
    return -1;
 20c:	57fd                	li	a5,-1
 20e:	893e                	mv	s2,a5
 210:	bfc5                	j	200 <stat+0x36>

0000000000000212 <atoi>:

int
atoi(const char *s)
{
 212:	1141                	addi	sp,sp,-16
 214:	e406                	sd	ra,8(sp)
 216:	e022                	sd	s0,0(sp)
 218:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21a:	00054683          	lbu	a3,0(a0)
 21e:	fd06879b          	addiw	a5,a3,-48
 222:	0ff7f793          	zext.b	a5,a5
 226:	4625                	li	a2,9
 228:	02f66963          	bltu	a2,a5,25a <atoi+0x48>
 22c:	872a                	mv	a4,a0
  n = 0;
 22e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 230:	0705                	addi	a4,a4,1
 232:	0025179b          	slliw	a5,a0,0x2
 236:	9fa9                	addw	a5,a5,a0
 238:	0017979b          	slliw	a5,a5,0x1
 23c:	9fb5                	addw	a5,a5,a3
 23e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 242:	00074683          	lbu	a3,0(a4)
 246:	fd06879b          	addiw	a5,a3,-48
 24a:	0ff7f793          	zext.b	a5,a5
 24e:	fef671e3          	bgeu	a2,a5,230 <atoi+0x1e>
  return n;
}
 252:	60a2                	ld	ra,8(sp)
 254:	6402                	ld	s0,0(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret
  n = 0;
 25a:	4501                	li	a0,0
 25c:	bfdd                	j	252 <atoi+0x40>

000000000000025e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 266:	02b57563          	bgeu	a0,a1,290 <memmove+0x32>
    while(n-- > 0)
 26a:	00c05f63          	blez	a2,288 <memmove+0x2a>
 26e:	1602                	slli	a2,a2,0x20
 270:	9201                	srli	a2,a2,0x20
 272:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 276:	872a                	mv	a4,a0
      *dst++ = *src++;
 278:	0585                	addi	a1,a1,1
 27a:	0705                	addi	a4,a4,1
 27c:	fff5c683          	lbu	a3,-1(a1)
 280:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 284:	fee79ae3          	bne	a5,a4,278 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 288:	60a2                	ld	ra,8(sp)
 28a:	6402                	ld	s0,0(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
    while(n-- > 0)
 290:	fec05ce3          	blez	a2,288 <memmove+0x2a>
    dst += n;
 294:	00c50733          	add	a4,a0,a2
    src += n;
 298:	95b2                	add	a1,a1,a2
 29a:	fff6079b          	addiw	a5,a2,-1
 29e:	1782                	slli	a5,a5,0x20
 2a0:	9381                	srli	a5,a5,0x20
 2a2:	fff7c793          	not	a5,a5
 2a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a8:	15fd                	addi	a1,a1,-1
 2aa:	177d                	addi	a4,a4,-1
 2ac:	0005c683          	lbu	a3,0(a1)
 2b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b4:	fef71ae3          	bne	a4,a5,2a8 <memmove+0x4a>
 2b8:	bfc1                	j	288 <memmove+0x2a>

00000000000002ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c2:	c61d                	beqz	a2,2f0 <memcmp+0x36>
 2c4:	1602                	slli	a2,a2,0x20
 2c6:	9201                	srli	a2,a2,0x20
 2c8:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	0005c703          	lbu	a4,0(a1)
 2d4:	00e79863          	bne	a5,a4,2e4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2d8:	0505                	addi	a0,a0,1
    p2++;
 2da:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2dc:	fed518e3          	bne	a0,a3,2cc <memcmp+0x12>
  }
  return 0;
 2e0:	4501                	li	a0,0
 2e2:	a019                	j	2e8 <memcmp+0x2e>
      return *p1 - *p2;
 2e4:	40e7853b          	subw	a0,a5,a4
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  return 0;
 2f0:	4501                	li	a0,0
 2f2:	bfdd                	j	2e8 <memcmp+0x2e>

00000000000002f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2fc:	00000097          	auipc	ra,0x0
 300:	f62080e7          	jalr	-158(ra) # 25e <memmove>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30c:	4885                	li	a7,1
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exit>:
.global exit
exit:
 li a7, SYS_exit
 314:	4889                	li	a7,2
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <wait>:
.global wait
wait:
 li a7, SYS_wait
 31c:	488d                	li	a7,3
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 324:	4891                	li	a7,4
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <read>:
.global read
read:
 li a7, SYS_read
 32c:	4895                	li	a7,5
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <write>:
.global write
write:
 li a7, SYS_write
 334:	48c1                	li	a7,16
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <close>:
.global close
close:
 li a7, SYS_close
 33c:	48d5                	li	a7,21
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <kill>:
.global kill
kill:
 li a7, SYS_kill
 344:	4899                	li	a7,6
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exec>:
.global exec
exec:
 li a7, SYS_exec
 34c:	489d                	li	a7,7
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <open>:
.global open
open:
 li a7, SYS_open
 354:	48bd                	li	a7,15
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35c:	48c5                	li	a7,17
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 364:	48c9                	li	a7,18
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36c:	48a1                	li	a7,8
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <link>:
.global link
link:
 li a7, SYS_link
 374:	48cd                	li	a7,19
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37c:	48d1                	li	a7,20
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 384:	48a5                	li	a7,9
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <dup>:
.global dup
dup:
 li a7, SYS_dup
 38c:	48a9                	li	a7,10
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 394:	48ad                	li	a7,11
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39c:	48b1                	li	a7,12
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a4:	48b5                	li	a7,13
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ac:	48b9                	li	a7,14
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3b4:	48d9                	li	a7,22
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3bc:	48dd                	li	a7,23
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3c4:	48e1                	li	a7,24
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3cc:	48e5                	li	a7,25
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3d4:	48e9                	li	a7,26
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <bind>:
.global bind
bind:
 li a7, SYS_bind
 3dc:	48ed                	li	a7,27
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3e4:	48f5                	li	a7,29
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <listen>:
.global listen
listen:
 li a7, SYS_listen
 3ec:	48f1                	li	a7,28
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3f4:	48f9                	li	a7,30
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fc:	1101                	addi	sp,sp,-32
 3fe:	ec06                	sd	ra,24(sp)
 400:	e822                	sd	s0,16(sp)
 402:	1000                	addi	s0,sp,32
 404:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 408:	4605                	li	a2,1
 40a:	fef40593          	addi	a1,s0,-17
 40e:	00000097          	auipc	ra,0x0
 412:	f26080e7          	jalr	-218(ra) # 334 <write>
}
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	6105                	addi	sp,sp,32
 41c:	8082                	ret

000000000000041e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41e:	7139                	addi	sp,sp,-64
 420:	fc06                	sd	ra,56(sp)
 422:	f822                	sd	s0,48(sp)
 424:	f04a                	sd	s2,32(sp)
 426:	ec4e                	sd	s3,24(sp)
 428:	0080                	addi	s0,sp,64
 42a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42c:	cad9                	beqz	a3,4c2 <printint+0xa4>
 42e:	01f5d79b          	srliw	a5,a1,0x1f
 432:	cbc1                	beqz	a5,4c2 <printint+0xa4>
    neg = 1;
    x = -xx;
 434:	40b005bb          	negw	a1,a1
    neg = 1;
 438:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 43a:	fc040993          	addi	s3,s0,-64
  neg = 0;
 43e:	86ce                	mv	a3,s3
  i = 0;
 440:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 442:	00000817          	auipc	a6,0x0
 446:	74e80813          	addi	a6,a6,1870 # b90 <digits>
 44a:	88ba                	mv	a7,a4
 44c:	0017051b          	addiw	a0,a4,1
 450:	872a                	mv	a4,a0
 452:	02c5f7bb          	remuw	a5,a1,a2
 456:	1782                	slli	a5,a5,0x20
 458:	9381                	srli	a5,a5,0x20
 45a:	97c2                	add	a5,a5,a6
 45c:	0007c783          	lbu	a5,0(a5)
 460:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 464:	87ae                	mv	a5,a1
 466:	02c5d5bb          	divuw	a1,a1,a2
 46a:	0685                	addi	a3,a3,1
 46c:	fcc7ffe3          	bgeu	a5,a2,44a <printint+0x2c>
  if(neg)
 470:	00030c63          	beqz	t1,488 <printint+0x6a>
    buf[i++] = '-';
 474:	fd050793          	addi	a5,a0,-48
 478:	00878533          	add	a0,a5,s0
 47c:	02d00793          	li	a5,45
 480:	fef50823          	sb	a5,-16(a0)
 484:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 488:	02e05763          	blez	a4,4b6 <printint+0x98>
 48c:	f426                	sd	s1,40(sp)
 48e:	377d                	addiw	a4,a4,-1
 490:	00e984b3          	add	s1,s3,a4
 494:	19fd                	addi	s3,s3,-1
 496:	99ba                	add	s3,s3,a4
 498:	1702                	slli	a4,a4,0x20
 49a:	9301                	srli	a4,a4,0x20
 49c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a0:	0004c583          	lbu	a1,0(s1)
 4a4:	854a                	mv	a0,s2
 4a6:	00000097          	auipc	ra,0x0
 4aa:	f56080e7          	jalr	-170(ra) # 3fc <putc>
  while(--i >= 0)
 4ae:	14fd                	addi	s1,s1,-1
 4b0:	ff3498e3          	bne	s1,s3,4a0 <printint+0x82>
 4b4:	74a2                	ld	s1,40(sp)
}
 4b6:	70e2                	ld	ra,56(sp)
 4b8:	7442                	ld	s0,48(sp)
 4ba:	7902                	ld	s2,32(sp)
 4bc:	69e2                	ld	s3,24(sp)
 4be:	6121                	addi	sp,sp,64
 4c0:	8082                	ret
  neg = 0;
 4c2:	4301                	li	t1,0
 4c4:	bf9d                	j	43a <printint+0x1c>

00000000000004c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c6:	715d                	addi	sp,sp,-80
 4c8:	e486                	sd	ra,72(sp)
 4ca:	e0a2                	sd	s0,64(sp)
 4cc:	f84a                	sd	s2,48(sp)
 4ce:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d0:	0005c903          	lbu	s2,0(a1)
 4d4:	1a090b63          	beqz	s2,68a <vprintf+0x1c4>
 4d8:	fc26                	sd	s1,56(sp)
 4da:	f44e                	sd	s3,40(sp)
 4dc:	f052                	sd	s4,32(sp)
 4de:	ec56                	sd	s5,24(sp)
 4e0:	e85a                	sd	s6,16(sp)
 4e2:	e45e                	sd	s7,8(sp)
 4e4:	8aaa                	mv	s5,a0
 4e6:	8bb2                	mv	s7,a2
 4e8:	00158493          	addi	s1,a1,1
  state = 0;
 4ec:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ee:	02500a13          	li	s4,37
 4f2:	4b55                	li	s6,21
 4f4:	a839                	j	512 <vprintf+0x4c>
        putc(fd, c);
 4f6:	85ca                	mv	a1,s2
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	f02080e7          	jalr	-254(ra) # 3fc <putc>
 502:	a019                	j	508 <vprintf+0x42>
    } else if(state == '%'){
 504:	01498d63          	beq	s3,s4,51e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 508:	0485                	addi	s1,s1,1
 50a:	fff4c903          	lbu	s2,-1(s1)
 50e:	16090863          	beqz	s2,67e <vprintf+0x1b8>
    if(state == 0){
 512:	fe0999e3          	bnez	s3,504 <vprintf+0x3e>
      if(c == '%'){
 516:	ff4910e3          	bne	s2,s4,4f6 <vprintf+0x30>
        state = '%';
 51a:	89d2                	mv	s3,s4
 51c:	b7f5                	j	508 <vprintf+0x42>
      if(c == 'd'){
 51e:	13490563          	beq	s2,s4,648 <vprintf+0x182>
 522:	f9d9079b          	addiw	a5,s2,-99
 526:	0ff7f793          	zext.b	a5,a5
 52a:	12fb6863          	bltu	s6,a5,65a <vprintf+0x194>
 52e:	f9d9079b          	addiw	a5,s2,-99
 532:	0ff7f713          	zext.b	a4,a5
 536:	12eb6263          	bltu	s6,a4,65a <vprintf+0x194>
 53a:	00271793          	slli	a5,a4,0x2
 53e:	00000717          	auipc	a4,0x0
 542:	5fa70713          	addi	a4,a4,1530 # b38 <ithread_join+0xb8>
 546:	97ba                	add	a5,a5,a4
 548:	439c                	lw	a5,0(a5)
 54a:	97ba                	add	a5,a5,a4
 54c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 54e:	008b8913          	addi	s2,s7,8
 552:	4685                	li	a3,1
 554:	4629                	li	a2,10
 556:	000ba583          	lw	a1,0(s7)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	ec2080e7          	jalr	-318(ra) # 41e <printint>
 564:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 566:	4981                	li	s3,0
 568:	b745                	j	508 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56a:	008b8913          	addi	s2,s7,8
 56e:	4681                	li	a3,0
 570:	4629                	li	a2,10
 572:	000ba583          	lw	a1,0(s7)
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	ea6080e7          	jalr	-346(ra) # 41e <printint>
 580:	8bca                	mv	s7,s2
      state = 0;
 582:	4981                	li	s3,0
 584:	b751                	j	508 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 586:	008b8913          	addi	s2,s7,8
 58a:	4681                	li	a3,0
 58c:	4641                	li	a2,16
 58e:	000ba583          	lw	a1,0(s7)
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	e8a080e7          	jalr	-374(ra) # 41e <printint>
 59c:	8bca                	mv	s7,s2
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b7a5                	j	508 <vprintf+0x42>
 5a2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5a4:	008b8793          	addi	a5,s7,8
 5a8:	8c3e                	mv	s8,a5
 5aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ae:	03000593          	li	a1,48
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e48080e7          	jalr	-440(ra) # 3fc <putc>
  putc(fd, 'x');
 5bc:	07800593          	li	a1,120
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e3a080e7          	jalr	-454(ra) # 3fc <putc>
 5ca:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5cc:	00000b97          	auipc	s7,0x0
 5d0:	5c4b8b93          	addi	s7,s7,1476 # b90 <digits>
 5d4:	03c9d793          	srli	a5,s3,0x3c
 5d8:	97de                	add	a5,a5,s7
 5da:	0007c583          	lbu	a1,0(a5)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e1c080e7          	jalr	-484(ra) # 3fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e8:	0992                	slli	s3,s3,0x4
 5ea:	397d                	addiw	s2,s2,-1
 5ec:	fe0914e3          	bnez	s2,5d4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5f0:	8be2                	mv	s7,s8
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	6c02                	ld	s8,0(sp)
 5f6:	bf09                	j	508 <vprintf+0x42>
        s = va_arg(ap, char*);
 5f8:	008b8993          	addi	s3,s7,8
 5fc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 600:	02090163          	beqz	s2,622 <vprintf+0x15c>
        while(*s != 0){
 604:	00094583          	lbu	a1,0(s2)
 608:	c9a5                	beqz	a1,678 <vprintf+0x1b2>
          putc(fd, *s);
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	df0080e7          	jalr	-528(ra) # 3fc <putc>
          s++;
 614:	0905                	addi	s2,s2,1
        while(*s != 0){
 616:	00094583          	lbu	a1,0(s2)
 61a:	f9e5                	bnez	a1,60a <vprintf+0x144>
        s = va_arg(ap, char*);
 61c:	8bce                	mv	s7,s3
      state = 0;
 61e:	4981                	li	s3,0
 620:	b5e5                	j	508 <vprintf+0x42>
          s = "(null)";
 622:	00000917          	auipc	s2,0x0
 626:	4de90913          	addi	s2,s2,1246 # b00 <ithread_join+0x80>
        while(*s != 0){
 62a:	02800593          	li	a1,40
 62e:	bff1                	j	60a <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 630:	008b8913          	addi	s2,s7,8
 634:	000bc583          	lbu	a1,0(s7)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	dc2080e7          	jalr	-574(ra) # 3fc <putc>
 642:	8bca                	mv	s7,s2
      state = 0;
 644:	4981                	li	s3,0
 646:	b5c9                	j	508 <vprintf+0x42>
        putc(fd, c);
 648:	02500593          	li	a1,37
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	dae080e7          	jalr	-594(ra) # 3fc <putc>
      state = 0;
 656:	4981                	li	s3,0
 658:	bd45                	j	508 <vprintf+0x42>
        putc(fd, '%');
 65a:	02500593          	li	a1,37
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	d9c080e7          	jalr	-612(ra) # 3fc <putc>
        putc(fd, c);
 668:	85ca                	mv	a1,s2
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	d90080e7          	jalr	-624(ra) # 3fc <putc>
      state = 0;
 674:	4981                	li	s3,0
 676:	bd49                	j	508 <vprintf+0x42>
        s = va_arg(ap, char*);
 678:	8bce                	mv	s7,s3
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b571                	j	508 <vprintf+0x42>
 67e:	74e2                	ld	s1,56(sp)
 680:	79a2                	ld	s3,40(sp)
 682:	7a02                	ld	s4,32(sp)
 684:	6ae2                	ld	s5,24(sp)
 686:	6b42                	ld	s6,16(sp)
 688:	6ba2                	ld	s7,8(sp)
    }
  }
}
 68a:	60a6                	ld	ra,72(sp)
 68c:	6406                	ld	s0,64(sp)
 68e:	7942                	ld	s2,48(sp)
 690:	6161                	addi	sp,sp,80
 692:	8082                	ret

0000000000000694 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 694:	715d                	addi	sp,sp,-80
 696:	ec06                	sd	ra,24(sp)
 698:	e822                	sd	s0,16(sp)
 69a:	1000                	addi	s0,sp,32
 69c:	e010                	sd	a2,0(s0)
 69e:	e414                	sd	a3,8(s0)
 6a0:	e818                	sd	a4,16(s0)
 6a2:	ec1c                	sd	a5,24(s0)
 6a4:	03043023          	sd	a6,32(s0)
 6a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ac:	8622                	mv	a2,s0
 6ae:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b2:	00000097          	auipc	ra,0x0
 6b6:	e14080e7          	jalr	-492(ra) # 4c6 <vprintf>
}
 6ba:	60e2                	ld	ra,24(sp)
 6bc:	6442                	ld	s0,16(sp)
 6be:	6161                	addi	sp,sp,80
 6c0:	8082                	ret

00000000000006c2 <printf>:

void
printf(const char *fmt, ...)
{
 6c2:	711d                	addi	sp,sp,-96
 6c4:	ec06                	sd	ra,24(sp)
 6c6:	e822                	sd	s0,16(sp)
 6c8:	1000                	addi	s0,sp,32
 6ca:	e40c                	sd	a1,8(s0)
 6cc:	e810                	sd	a2,16(s0)
 6ce:	ec14                	sd	a3,24(s0)
 6d0:	f018                	sd	a4,32(s0)
 6d2:	f41c                	sd	a5,40(s0)
 6d4:	03043823          	sd	a6,48(s0)
 6d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6dc:	00840613          	addi	a2,s0,8
 6e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e4:	85aa                	mv	a1,a0
 6e6:	4505                	li	a0,1
 6e8:	00000097          	auipc	ra,0x0
 6ec:	dde080e7          	jalr	-546(ra) # 4c6 <vprintf>
}
 6f0:	60e2                	ld	ra,24(sp)
 6f2:	6442                	ld	s0,16(sp)
 6f4:	6125                	addi	sp,sp,96
 6f6:	8082                	ret

00000000000006f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f8:	1141                	addi	sp,sp,-16
 6fa:	e406                	sd	ra,8(sp)
 6fc:	e022                	sd	s0,0(sp)
 6fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 700:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 704:	00001797          	auipc	a5,0x1
 708:	e3c7b783          	ld	a5,-452(a5) # 1540 <freep>
 70c:	a039                	j	71a <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70e:	6398                	ld	a4,0(a5)
 710:	00e7e463          	bltu	a5,a4,718 <free+0x20>
 714:	00e6ea63          	bltu	a3,a4,728 <free+0x30>
{
 718:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71a:	fed7fae3          	bgeu	a5,a3,70e <free+0x16>
 71e:	6398                	ld	a4,0(a5)
 720:	00e6e463          	bltu	a3,a4,728 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	fee7eae3          	bltu	a5,a4,718 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 728:	ff852583          	lw	a1,-8(a0)
 72c:	6390                	ld	a2,0(a5)
 72e:	02059813          	slli	a6,a1,0x20
 732:	01c85713          	srli	a4,a6,0x1c
 736:	9736                	add	a4,a4,a3
 738:	02e60563          	beq	a2,a4,762 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 73c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 740:	4790                	lw	a2,8(a5)
 742:	02061593          	slli	a1,a2,0x20
 746:	01c5d713          	srli	a4,a1,0x1c
 74a:	973e                	add	a4,a4,a5
 74c:	02e68263          	beq	a3,a4,770 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 750:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 752:	00001717          	auipc	a4,0x1
 756:	def73723          	sd	a5,-530(a4) # 1540 <freep>
}
 75a:	60a2                	ld	ra,8(sp)
 75c:	6402                	ld	s0,0(sp)
 75e:	0141                	addi	sp,sp,16
 760:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 762:	4618                	lw	a4,8(a2)
 764:	9f2d                	addw	a4,a4,a1
 766:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76a:	6398                	ld	a4,0(a5)
 76c:	6310                	ld	a2,0(a4)
 76e:	b7f9                	j	73c <free+0x44>
    p->s.size += bp->s.size;
 770:	ff852703          	lw	a4,-8(a0)
 774:	9f31                	addw	a4,a4,a2
 776:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 778:	ff053683          	ld	a3,-16(a0)
 77c:	bfd1                	j	750 <free+0x58>

000000000000077e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77e:	7139                	addi	sp,sp,-64
 780:	fc06                	sd	ra,56(sp)
 782:	f822                	sd	s0,48(sp)
 784:	f04a                	sd	s2,32(sp)
 786:	ec4e                	sd	s3,24(sp)
 788:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78a:	02051993          	slli	s3,a0,0x20
 78e:	0209d993          	srli	s3,s3,0x20
 792:	09bd                	addi	s3,s3,15
 794:	0049d993          	srli	s3,s3,0x4
 798:	2985                	addiw	s3,s3,1
 79a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 79c:	00001517          	auipc	a0,0x1
 7a0:	da453503          	ld	a0,-604(a0) # 1540 <freep>
 7a4:	c905                	beqz	a0,7d4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a8:	4798                	lw	a4,8(a5)
 7aa:	09377a63          	bgeu	a4,s3,83e <malloc+0xc0>
 7ae:	f426                	sd	s1,40(sp)
 7b0:	e852                	sd	s4,16(sp)
 7b2:	e456                	sd	s5,8(sp)
 7b4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b6:	8a4e                	mv	s4,s3
 7b8:	6705                	lui	a4,0x1
 7ba:	00e9f363          	bgeu	s3,a4,7c0 <malloc+0x42>
 7be:	6a05                	lui	s4,0x1
 7c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c8:	00001497          	auipc	s1,0x1
 7cc:	d7848493          	addi	s1,s1,-648 # 1540 <freep>
  if(p == (char*)-1)
 7d0:	5afd                	li	s5,-1
 7d2:	a089                	j	814 <malloc+0x96>
 7d4:	f426                	sd	s1,40(sp)
 7d6:	e852                	sd	s4,16(sp)
 7d8:	e456                	sd	s5,8(sp)
 7da:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7dc:	00001797          	auipc	a5,0x1
 7e0:	d8478793          	addi	a5,a5,-636 # 1560 <base>
 7e4:	00001717          	auipc	a4,0x1
 7e8:	d4f73e23          	sd	a5,-676(a4) # 1540 <freep>
 7ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f2:	b7d1                	j	7b6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	e118                	sd	a4,0(a0)
 7f8:	a8b9                	j	856 <malloc+0xd8>
  hp->s.size = nu;
 7fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fe:	0541                	addi	a0,a0,16
 800:	00000097          	auipc	ra,0x0
 804:	ef8080e7          	jalr	-264(ra) # 6f8 <free>
  return freep;
 808:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 80a:	c135                	beqz	a0,86e <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80e:	4798                	lw	a4,8(a5)
 810:	03277363          	bgeu	a4,s2,836 <malloc+0xb8>
    if(p == freep)
 814:	6098                	ld	a4,0(s1)
 816:	853e                	mv	a0,a5
 818:	fef71ae3          	bne	a4,a5,80c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 81c:	8552                	mv	a0,s4
 81e:	00000097          	auipc	ra,0x0
 822:	b7e080e7          	jalr	-1154(ra) # 39c <sbrk>
  if(p == (char*)-1)
 826:	fd551ae3          	bne	a0,s5,7fa <malloc+0x7c>
        return 0;
 82a:	4501                	li	a0,0
 82c:	74a2                	ld	s1,40(sp)
 82e:	6a42                	ld	s4,16(sp)
 830:	6aa2                	ld	s5,8(sp)
 832:	6b02                	ld	s6,0(sp)
 834:	a03d                	j	862 <malloc+0xe4>
 836:	74a2                	ld	s1,40(sp)
 838:	6a42                	ld	s4,16(sp)
 83a:	6aa2                	ld	s5,8(sp)
 83c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 83e:	fae90be3          	beq	s2,a4,7f4 <malloc+0x76>
        p->s.size -= nunits;
 842:	4137073b          	subw	a4,a4,s3
 846:	c798                	sw	a4,8(a5)
        p += p->s.size;
 848:	02071693          	slli	a3,a4,0x20
 84c:	01c6d713          	srli	a4,a3,0x1c
 850:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 852:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 856:	00001717          	auipc	a4,0x1
 85a:	cea73523          	sd	a0,-790(a4) # 1540 <freep>
      return (void*)(p + 1);
 85e:	01078513          	addi	a0,a5,16
  }
}
 862:	70e2                	ld	ra,56(sp)
 864:	7442                	ld	s0,48(sp)
 866:	7902                	ld	s2,32(sp)
 868:	69e2                	ld	s3,24(sp)
 86a:	6121                	addi	sp,sp,64
 86c:	8082                	ret
 86e:	74a2                	ld	s1,40(sp)
 870:	6a42                	ld	s4,16(sp)
 872:	6aa2                	ld	s5,8(sp)
 874:	6b02                	ld	s6,0(sp)
 876:	b7f5                	j	862 <malloc+0xe4>

0000000000000878 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 878:	1141                	addi	sp,sp,-16
 87a:	e406                	sd	ra,8(sp)
 87c:	e022                	sd	s0,0(sp)
 87e:	0800                	addi	s0,sp,16
  thread_exit(status);
 880:	2501                	sext.w	a0,a0
 882:	00000097          	auipc	ra,0x0
 886:	b4a080e7          	jalr	-1206(ra) # 3cc <thread_exit>
}
 88a:	60a2                	ld	ra,8(sp)
 88c:	6402                	ld	s0,0(sp)
 88e:	0141                	addi	sp,sp,16
 890:	8082                	ret

0000000000000892 <free_stacks>:
int free_stacks() {
 892:	7179                	addi	sp,sp,-48
 894:	f406                	sd	ra,40(sp)
 896:	f022                	sd	s0,32(sp)
 898:	ec26                	sd	s1,24(sp)
 89a:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 89c:	00001797          	auipc	a5,0x1
 8a0:	cb47a783          	lw	a5,-844(a5) # 1550 <num_threads>
 8a4:	04f05063          	blez	a5,8e4 <free_stacks+0x52>
 8a8:	e84a                	sd	s2,16(sp)
 8aa:	e44e                	sd	s3,8(sp)
 8ac:	4481                	li	s1,0
    free(stacks[i]);
 8ae:	00001997          	auipc	s3,0x1
 8b2:	c9a98993          	addi	s3,s3,-870 # 1548 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8b6:	00001917          	auipc	s2,0x1
 8ba:	c9a90913          	addi	s2,s2,-870 # 1550 <num_threads>
    free(stacks[i]);
 8be:	0009b783          	ld	a5,0(s3)
 8c2:	00349713          	slli	a4,s1,0x3
 8c6:	97ba                	add	a5,a5,a4
 8c8:	6388                	ld	a0,0(a5)
 8ca:	00000097          	auipc	ra,0x0
 8ce:	e2e080e7          	jalr	-466(ra) # 6f8 <free>
  for (int i = 0; i < num_threads; i++) {
 8d2:	0485                	addi	s1,s1,1
 8d4:	00092703          	lw	a4,0(s2)
 8d8:	0004879b          	sext.w	a5,s1
 8dc:	fee7c1e3          	blt	a5,a4,8be <free_stacks+0x2c>
 8e0:	6942                	ld	s2,16(sp)
 8e2:	69a2                	ld	s3,8(sp)
  free(stacks);
 8e4:	00001497          	auipc	s1,0x1
 8e8:	c6448493          	addi	s1,s1,-924 # 1548 <stacks>
 8ec:	6088                	ld	a0,0(s1)
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e0a080e7          	jalr	-502(ra) # 6f8 <free>
  stacks = 0;
 8f6:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8fa:	00001797          	auipc	a5,0x1
 8fe:	c407ab23          	sw	zero,-938(a5) # 1550 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 902:	47a1                	li	a5,8
 904:	00001717          	auipc	a4,0x1
 908:	c2f72623          	sw	a5,-980(a4) # 1530 <max_stacks>
  threads_done = 0;
 90c:	00001797          	auipc	a5,0x1
 910:	c407a423          	sw	zero,-952(a5) # 1554 <threads_done>
}
 914:	4501                	li	a0,0
 916:	70a2                	ld	ra,40(sp)
 918:	7402                	ld	s0,32(sp)
 91a:	64e2                	ld	s1,24(sp)
 91c:	6145                	addi	sp,sp,48
 91e:	8082                	ret

0000000000000920 <expand_num_threads>:
int expand_num_threads() {
 920:	1101                	addi	sp,sp,-32
 922:	ec06                	sd	ra,24(sp)
 924:	e822                	sd	s0,16(sp)
 926:	e426                	sd	s1,8(sp)
 928:	e04a                	sd	s2,0(sp)
 92a:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 92c:	00001797          	auipc	a5,0x1
 930:	c0478793          	addi	a5,a5,-1020 # 1530 <max_stacks>
 934:	4388                	lw	a0,0(a5)
 936:	0015151b          	slliw	a0,a0,0x1
 93a:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 93c:	0035151b          	slliw	a0,a0,0x3
 940:	00000097          	auipc	ra,0x0
 944:	e3e080e7          	jalr	-450(ra) # 77e <malloc>
 948:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 94a:	00001617          	auipc	a2,0x1
 94e:	c0662603          	lw	a2,-1018(a2) # 1550 <num_threads>
 952:	00001497          	auipc	s1,0x1
 956:	bf648493          	addi	s1,s1,-1034 # 1548 <stacks>
 95a:	0036161b          	slliw	a2,a2,0x3
 95e:	608c                	ld	a1,0(s1)
 960:	00000097          	auipc	ra,0x0
 964:	8fe080e7          	jalr	-1794(ra) # 25e <memmove>
  free(stacks);
 968:	6088                	ld	a0,0(s1)
 96a:	00000097          	auipc	ra,0x0
 96e:	d8e080e7          	jalr	-626(ra) # 6f8 <free>
  stacks = new_stacks;
 972:	0124b023          	sd	s2,0(s1)
}
 976:	4501                	li	a0,0
 978:	60e2                	ld	ra,24(sp)
 97a:	6442                	ld	s0,16(sp)
 97c:	64a2                	ld	s1,8(sp)
 97e:	6902                	ld	s2,0(sp)
 980:	6105                	addi	sp,sp,32
 982:	8082                	ret

0000000000000984 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 984:	7179                	addi	sp,sp,-48
 986:	f406                	sd	ra,40(sp)
 988:	f022                	sd	s0,32(sp)
 98a:	e84a                	sd	s2,16(sp)
 98c:	e44e                	sd	s3,8(sp)
 98e:	1800                	addi	s0,sp,48
 990:	892a                	mv	s2,a0
 992:	89ae                	mv	s3,a1
  if (stacks == 0) {
 994:	00001797          	auipc	a5,0x1
 998:	bb47b783          	ld	a5,-1100(a5) # 1548 <stacks>
 99c:	c3d9                	beqz	a5,a22 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 99e:	00001797          	auipc	a5,0x1
 9a2:	b927a783          	lw	a5,-1134(a5) # 1530 <max_stacks>
 9a6:	00001717          	auipc	a4,0x1
 9aa:	baa72703          	lw	a4,-1110(a4) # 1550 <num_threads>
 9ae:	0af71463          	bne	a4,a5,a56 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 9b2:	04000713          	li	a4,64
 9b6:	08e78563          	beq	a5,a4,a40 <ithread_create+0xbc>
 9ba:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9bc:	00000097          	auipc	ra,0x0
 9c0:	f64080e7          	jalr	-156(ra) # 920 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9c4:	6505                	lui	a0,0x1
 9c6:	00000097          	auipc	ra,0x0
 9ca:	db8080e7          	jalr	-584(ra) # 77e <malloc>
 9ce:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9d0:	00001717          	auipc	a4,0x1
 9d4:	b8072703          	lw	a4,-1152(a4) # 1550 <num_threads>
 9d8:	070e                	slli	a4,a4,0x3
 9da:	00001797          	auipc	a5,0x1
 9de:	b6e7b783          	ld	a5,-1170(a5) # 1548 <stacks>
 9e2:	97ba                	add	a5,a5,a4
 9e4:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9e6:	00000697          	auipc	a3,0x0
 9ea:	e9268693          	addi	a3,a3,-366 # 878 <ithread_exit>
 9ee:	862a                	mv	a2,a0
 9f0:	85ce                	mv	a1,s3
 9f2:	854a                	mv	a0,s2
 9f4:	00000097          	auipc	ra,0x0
 9f8:	9c8080e7          	jalr	-1592(ra) # 3bc <create_thread>
 9fc:	892a                	mv	s2,a0
  if (res != -1) {
 9fe:	57fd                	li	a5,-1
 a00:	04f50d63          	beq	a0,a5,a5a <ithread_create+0xd6>
    num_threads++;
 a04:	00001717          	auipc	a4,0x1
 a08:	b4c70713          	addi	a4,a4,-1204 # 1550 <num_threads>
 a0c:	431c                	lw	a5,0(a4)
 a0e:	2785                	addiw	a5,a5,1
 a10:	c31c                	sw	a5,0(a4)
 a12:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a14:	854a                	mv	a0,s2
 a16:	70a2                	ld	ra,40(sp)
 a18:	7402                	ld	s0,32(sp)
 a1a:	6942                	ld	s2,16(sp)
 a1c:	69a2                	ld	s3,8(sp)
 a1e:	6145                	addi	sp,sp,48
 a20:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a22:	00001517          	auipc	a0,0x1
 a26:	b0e52503          	lw	a0,-1266(a0) # 1530 <max_stacks>
 a2a:	0035151b          	slliw	a0,a0,0x3
 a2e:	00000097          	auipc	ra,0x0
 a32:	d50080e7          	jalr	-688(ra) # 77e <malloc>
 a36:	00001797          	auipc	a5,0x1
 a3a:	b0a7b923          	sd	a0,-1262(a5) # 1548 <stacks>
 a3e:	b785                	j	99e <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a40:	00000517          	auipc	a0,0x0
 a44:	0c850513          	addi	a0,a0,200 # b08 <ithread_join+0x88>
 a48:	00000097          	auipc	ra,0x0
 a4c:	c7a080e7          	jalr	-902(ra) # 6c2 <printf>
      return -1;
 a50:	57fd                	li	a5,-1
 a52:	893e                	mv	s2,a5
 a54:	b7c1                	j	a14 <ithread_create+0x90>
 a56:	ec26                	sd	s1,24(sp)
 a58:	b7b5                	j	9c4 <ithread_create+0x40>
    free(stack_ptr);
 a5a:	8526                	mv	a0,s1
 a5c:	00000097          	auipc	ra,0x0
 a60:	c9c080e7          	jalr	-868(ra) # 6f8 <free>
    stacks[num_threads] = 0;
 a64:	00001717          	auipc	a4,0x1
 a68:	aec72703          	lw	a4,-1300(a4) # 1550 <num_threads>
 a6c:	070e                	slli	a4,a4,0x3
 a6e:	00001797          	auipc	a5,0x1
 a72:	ada7b783          	ld	a5,-1318(a5) # 1548 <stacks>
 a76:	97ba                	add	a5,a5,a4
 a78:	0007b023          	sd	zero,0(a5)
 a7c:	64e2                	ld	s1,24(sp)
 a7e:	bf59                	j	a14 <ithread_create+0x90>

0000000000000a80 <ithread_join>:

int ithread_join(int thread_id) {
 a80:	1101                	addi	sp,sp,-32
 a82:	ec06                	sd	ra,24(sp)
 a84:	e822                	sd	s0,16(sp)
 a86:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a88:	ff040793          	addi	a5,s0,-16
 a8c:	ffc7859b          	addiw	a1,a5,-4
 a90:	00000097          	auipc	ra,0x0
 a94:	934080e7          	jalr	-1740(ra) # 3c4 <join_thread>
  threads_done++;
 a98:	00001717          	auipc	a4,0x1
 a9c:	abc70713          	addi	a4,a4,-1348 # 1554 <threads_done>
 aa0:	431c                	lw	a5,0(a4)
 aa2:	2785                	addiw	a5,a5,1
 aa4:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 aa6:	00001717          	auipc	a4,0x1
 aaa:	aaa72703          	lw	a4,-1366(a4) # 1550 <num_threads>
 aae:	00f70863          	beq	a4,a5,abe <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ab2:	fec42503          	lw	a0,-20(s0)
 ab6:	60e2                	ld	ra,24(sp)
 ab8:	6442                	ld	s0,16(sp)
 aba:	6105                	addi	sp,sp,32
 abc:	8082                	ret
    free_stacks();
 abe:	00000097          	auipc	ra,0x0
 ac2:	dd4080e7          	jalr	-556(ra) # 892 <free_stacks>
 ac6:	b7f5                	j	ab2 <ithread_join+0x32>
