
user/_net_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <socket_test1>:
#include "user.h"
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
   e:	4585                	li	a1,1
  10:	c3cc                	sw	a1,4(a5)
  p->ai_protocol = 0;
  12:	0007a623          	sw	zero,12(a5)
  int fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
  16:	4601                	li	a2,0
  18:	4501                	li	a0,0
  1a:	00000097          	auipc	ra,0x0
  1e:	3ca080e7          	jalr	970(ra) # 3e4 <socket>

  if (fd == 0) 
  22:	ed11                	bnez	a0,3e <socket_test1+0x3e>
    printf("socket_test1: PASSED\n");
  24:	00001517          	auipc	a0,0x1
  28:	aac50513          	addi	a0,a0,-1364 # ad0 <ithread_join+0x52>
  2c:	00000097          	auipc	ra,0x0
  30:	696080e7          	jalr	1686(ra) # 6c2 <printf>
  else
    printf("socket_test1: FAILED\n");

  return 0;
}
  34:	4501                	li	a0,0
  36:	60a2                	ld	ra,8(sp)
  38:	6402                	ld	s0,0(sp)
  3a:	0141                	addi	sp,sp,16
  3c:	8082                	ret
    printf("socket_test1: FAILED\n");
  3e:	00001517          	auipc	a0,0x1
  42:	aaa50513          	addi	a0,a0,-1366 # ae8 <ithread_join+0x6a>
  46:	00000097          	auipc	ra,0x0
  4a:	67c080e7          	jalr	1660(ra) # 6c2 <printf>
  4e:	b7dd                	j	34 <socket_test1+0x34>

0000000000000050 <main>:

int main() {
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  socket_test1();
  58:	00000097          	auipc	ra,0x0
  5c:	fa8080e7          	jalr	-88(ra) # 0 <socket_test1>
}
  60:	4501                	li	a0,0
  62:	60a2                	ld	ra,8(sp)
  64:	6402                	ld	s0,0(sp)
  66:	0141                	addi	sp,sp,16
  68:	8082                	ret

000000000000006a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  6a:	1141                	addi	sp,sp,-16
  6c:	e406                	sd	ra,8(sp)
  6e:	e022                	sd	s0,0(sp)
  70:	0800                	addi	s0,sp,16
  extern int main();
  main();
  72:	00000097          	auipc	ra,0x0
  76:	fde080e7          	jalr	-34(ra) # 50 <main>
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	2a8080e7          	jalr	680(ra) # 324 <exit>

0000000000000084 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8c:	87aa                	mv	a5,a0
  8e:	0585                	addi	a1,a1,1
  90:	0785                	addi	a5,a5,1
  92:	fff5c703          	lbu	a4,-1(a1)
  96:	fee78fa3          	sb	a4,-1(a5)
  9a:	fb75                	bnez	a4,8e <strcpy+0xa>
    ;
  return os;
}
  9c:	60a2                	ld	ra,8(sp)
  9e:	6402                	ld	s0,0(sp)
  a0:	0141                	addi	sp,sp,16
  a2:	8082                	ret

00000000000000a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e406                	sd	ra,8(sp)
  a8:	e022                	sd	s0,0(sp)
  aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cb91                	beqz	a5,c4 <strcmp+0x20>
  b2:	0005c703          	lbu	a4,0(a1)
  b6:	00f71763          	bne	a4,a5,c4 <strcmp+0x20>
    p++, q++;
  ba:	0505                	addi	a0,a0,1
  bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	fbe5                	bnez	a5,b2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  c4:	0005c503          	lbu	a0,0(a1)
}
  c8:	40a7853b          	subw	a0,a5,a0
  cc:	60a2                	ld	ra,8(sp)
  ce:	6402                	ld	s0,0(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strlen>:

uint
strlen(const char *s)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e406                	sd	ra,8(sp)
  d8:	e022                	sd	s0,0(sp)
  da:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cf99                	beqz	a5,fe <strlen+0x2a>
  e2:	0505                	addi	a0,a0,1
  e4:	87aa                	mv	a5,a0
  e6:	86be                	mv	a3,a5
  e8:	0785                	addi	a5,a5,1
  ea:	fff7c703          	lbu	a4,-1(a5)
  ee:	ff65                	bnez	a4,e6 <strlen+0x12>
  f0:	40a6853b          	subw	a0,a3,a0
  f4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  f6:	60a2                	ld	ra,8(sp)
  f8:	6402                	ld	s0,0(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret
  for(n = 0; s[n]; n++)
  fe:	4501                	li	a0,0
 100:	bfdd                	j	f6 <strlen+0x22>

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
 150:	7159                	addi	sp,sp,-112
 152:	f486                	sd	ra,104(sp)
 154:	f0a2                	sd	s0,96(sp)
 156:	eca6                	sd	s1,88(sp)
 158:	e8ca                	sd	s2,80(sp)
 15a:	e4ce                	sd	s3,72(sp)
 15c:	e0d2                	sd	s4,64(sp)
 15e:	fc56                	sd	s5,56(sp)
 160:	f85a                	sd	s6,48(sp)
 162:	f45e                	sd	s7,40(sp)
 164:	f062                	sd	s8,32(sp)
 166:	ec66                	sd	s9,24(sp)
 168:	e86a                	sd	s10,16(sp)
 16a:	1880                	addi	s0,sp,112
 16c:	8caa                	mv	s9,a0
 16e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 170:	892a                	mv	s2,a0
 172:	4481                	li	s1,0
    cc = read(0, &c, 1);
 174:	f9f40b13          	addi	s6,s0,-97
 178:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 17a:	4ba9                	li	s7,10
 17c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 17e:	8d26                	mv	s10,s1
 180:	0014899b          	addiw	s3,s1,1
 184:	84ce                	mv	s1,s3
 186:	0349d763          	bge	s3,s4,1b4 <gets+0x64>
    cc = read(0, &c, 1);
 18a:	8656                	mv	a2,s5
 18c:	85da                	mv	a1,s6
 18e:	4501                	li	a0,0
 190:	00000097          	auipc	ra,0x0
 194:	1ac080e7          	jalr	428(ra) # 33c <read>
    if(cc < 1)
 198:	00a05e63          	blez	a0,1b4 <gets+0x64>
    buf[i++] = c;
 19c:	f9f44783          	lbu	a5,-97(s0)
 1a0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a4:	01778763          	beq	a5,s7,1b2 <gets+0x62>
 1a8:	0905                	addi	s2,s2,1
 1aa:	fd879ae3          	bne	a5,s8,17e <gets+0x2e>
    buf[i++] = c;
 1ae:	8d4e                	mv	s10,s3
 1b0:	a011                	j	1b4 <gets+0x64>
 1b2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1b4:	9d66                	add	s10,s10,s9
 1b6:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1ba:	8566                	mv	a0,s9
 1bc:	70a6                	ld	ra,104(sp)
 1be:	7406                	ld	s0,96(sp)
 1c0:	64e6                	ld	s1,88(sp)
 1c2:	6946                	ld	s2,80(sp)
 1c4:	69a6                	ld	s3,72(sp)
 1c6:	6a06                	ld	s4,64(sp)
 1c8:	7ae2                	ld	s5,56(sp)
 1ca:	7b42                	ld	s6,48(sp)
 1cc:	7ba2                	ld	s7,40(sp)
 1ce:	7c02                	ld	s8,32(sp)
 1d0:	6ce2                	ld	s9,24(sp)
 1d2:	6d42                	ld	s10,16(sp)
 1d4:	6165                	addi	sp,sp,112
 1d6:	8082                	ret

00000000000001d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d8:	1101                	addi	sp,sp,-32
 1da:	ec06                	sd	ra,24(sp)
 1dc:	e822                	sd	s0,16(sp)
 1de:	e04a                	sd	s2,0(sp)
 1e0:	1000                	addi	s0,sp,32
 1e2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e4:	4581                	li	a1,0
 1e6:	00000097          	auipc	ra,0x0
 1ea:	17e080e7          	jalr	382(ra) # 364 <open>
  if(fd < 0)
 1ee:	02054663          	bltz	a0,21a <stat+0x42>
 1f2:	e426                	sd	s1,8(sp)
 1f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f6:	85ca                	mv	a1,s2
 1f8:	00000097          	auipc	ra,0x0
 1fc:	184080e7          	jalr	388(ra) # 37c <fstat>
 200:	892a                	mv	s2,a0
  close(fd);
 202:	8526                	mv	a0,s1
 204:	00000097          	auipc	ra,0x0
 208:	148080e7          	jalr	328(ra) # 34c <close>
  return r;
 20c:	64a2                	ld	s1,8(sp)
}
 20e:	854a                	mv	a0,s2
 210:	60e2                	ld	ra,24(sp)
 212:	6442                	ld	s0,16(sp)
 214:	6902                	ld	s2,0(sp)
 216:	6105                	addi	sp,sp,32
 218:	8082                	ret
    return -1;
 21a:	597d                	li	s2,-1
 21c:	bfcd                	j	20e <stat+0x36>

000000000000021e <atoi>:

int
atoi(const char *s)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e406                	sd	ra,8(sp)
 222:	e022                	sd	s0,0(sp)
 224:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 226:	00054683          	lbu	a3,0(a0)
 22a:	fd06879b          	addiw	a5,a3,-48
 22e:	0ff7f793          	zext.b	a5,a5
 232:	4625                	li	a2,9
 234:	02f66963          	bltu	a2,a5,266 <atoi+0x48>
 238:	872a                	mv	a4,a0
  n = 0;
 23a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 23c:	0705                	addi	a4,a4,1
 23e:	0025179b          	slliw	a5,a0,0x2
 242:	9fa9                	addw	a5,a5,a0
 244:	0017979b          	slliw	a5,a5,0x1
 248:	9fb5                	addw	a5,a5,a3
 24a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 24e:	00074683          	lbu	a3,0(a4)
 252:	fd06879b          	addiw	a5,a3,-48
 256:	0ff7f793          	zext.b	a5,a5
 25a:	fef671e3          	bgeu	a2,a5,23c <atoi+0x1e>
  return n;
}
 25e:	60a2                	ld	ra,8(sp)
 260:	6402                	ld	s0,0(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
  n = 0;
 266:	4501                	li	a0,0
 268:	bfdd                	j	25e <atoi+0x40>

000000000000026a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e406                	sd	ra,8(sp)
 26e:	e022                	sd	s0,0(sp)
 270:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 272:	02b57563          	bgeu	a0,a1,29c <memmove+0x32>
    while(n-- > 0)
 276:	00c05f63          	blez	a2,294 <memmove+0x2a>
 27a:	1602                	slli	a2,a2,0x20
 27c:	9201                	srli	a2,a2,0x20
 27e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 282:	872a                	mv	a4,a0
      *dst++ = *src++;
 284:	0585                	addi	a1,a1,1
 286:	0705                	addi	a4,a4,1
 288:	fff5c683          	lbu	a3,-1(a1)
 28c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 290:	fee79ae3          	bne	a5,a4,284 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 294:	60a2                	ld	ra,8(sp)
 296:	6402                	ld	s0,0(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
    dst += n;
 29c:	00c50733          	add	a4,a0,a2
    src += n;
 2a0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a2:	fec059e3          	blez	a2,294 <memmove+0x2a>
 2a6:	fff6079b          	addiw	a5,a2,-1
 2aa:	1782                	slli	a5,a5,0x20
 2ac:	9381                	srli	a5,a5,0x20
 2ae:	fff7c793          	not	a5,a5
 2b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b4:	15fd                	addi	a1,a1,-1
 2b6:	177d                	addi	a4,a4,-1
 2b8:	0005c683          	lbu	a3,0(a1)
 2bc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c0:	fef71ae3          	bne	a4,a5,2b4 <memmove+0x4a>
 2c4:	bfc1                	j	294 <memmove+0x2a>

00000000000002c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ce:	ca0d                	beqz	a2,300 <memcmp+0x3a>
 2d0:	fff6069b          	addiw	a3,a2,-1
 2d4:	1682                	slli	a3,a3,0x20
 2d6:	9281                	srli	a3,a3,0x20
 2d8:	0685                	addi	a3,a3,1
 2da:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	0005c703          	lbu	a4,0(a1)
 2e4:	00e79863          	bne	a5,a4,2f4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2e8:	0505                	addi	a0,a0,1
    p2++;
 2ea:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ec:	fed518e3          	bne	a0,a3,2dc <memcmp+0x16>
  }
  return 0;
 2f0:	4501                	li	a0,0
 2f2:	a019                	j	2f8 <memcmp+0x32>
      return *p1 - *p2;
 2f4:	40e7853b          	subw	a0,a5,a4
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
  return 0;
 300:	4501                	li	a0,0
 302:	bfdd                	j	2f8 <memcmp+0x32>

0000000000000304 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30c:	00000097          	auipc	ra,0x0
 310:	f5e080e7          	jalr	-162(ra) # 26a <memmove>
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31c:	4885                	li	a7,1
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <exit>:
.global exit
exit:
 li a7, SYS_exit
 324:	4889                	li	a7,2
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <wait>:
.global wait
wait:
 li a7, SYS_wait
 32c:	488d                	li	a7,3
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 334:	4891                	li	a7,4
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <read>:
.global read
read:
 li a7, SYS_read
 33c:	4895                	li	a7,5
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <write>:
.global write
write:
 li a7, SYS_write
 344:	48c1                	li	a7,16
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <close>:
.global close
close:
 li a7, SYS_close
 34c:	48d5                	li	a7,21
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <kill>:
.global kill
kill:
 li a7, SYS_kill
 354:	4899                	li	a7,6
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <exec>:
.global exec
exec:
 li a7, SYS_exec
 35c:	489d                	li	a7,7
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <open>:
.global open
open:
 li a7, SYS_open
 364:	48bd                	li	a7,15
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36c:	48c5                	li	a7,17
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 374:	48c9                	li	a7,18
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37c:	48a1                	li	a7,8
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <link>:
.global link
link:
 li a7, SYS_link
 384:	48cd                	li	a7,19
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38c:	48d1                	li	a7,20
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 394:	48a5                	li	a7,9
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <dup>:
.global dup
dup:
 li a7, SYS_dup
 39c:	48a9                	li	a7,10
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a4:	48ad                	li	a7,11
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ac:	48b1                	li	a7,12
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b4:	48b5                	li	a7,13
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3bc:	48b9                	li	a7,14
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3c4:	48d9                	li	a7,22
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3cc:	48dd                	li	a7,23
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3d4:	48e1                	li	a7,24
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3dc:	48e5                	li	a7,25
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3e4:	48e9                	li	a7,26
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <bind>:
.global bind
bind:
 li a7, SYS_bind
 3ec:	48ed                	li	a7,27
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3f4:	48f5                	li	a7,29
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <listen>:
.global listen
listen:
 li a7, SYS_listen
 3fc:	48f1                	li	a7,28
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <connect>:
.global connect
connect:
 li a7, SYS_connect
 404:	48f9                	li	a7,30
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40c:	1101                	addi	sp,sp,-32
 40e:	ec06                	sd	ra,24(sp)
 410:	e822                	sd	s0,16(sp)
 412:	1000                	addi	s0,sp,32
 414:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 418:	4605                	li	a2,1
 41a:	fef40593          	addi	a1,s0,-17
 41e:	00000097          	auipc	ra,0x0
 422:	f26080e7          	jalr	-218(ra) # 344 <write>
}
 426:	60e2                	ld	ra,24(sp)
 428:	6442                	ld	s0,16(sp)
 42a:	6105                	addi	sp,sp,32
 42c:	8082                	ret

000000000000042e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42e:	7139                	addi	sp,sp,-64
 430:	fc06                	sd	ra,56(sp)
 432:	f822                	sd	s0,48(sp)
 434:	f426                	sd	s1,40(sp)
 436:	f04a                	sd	s2,32(sp)
 438:	ec4e                	sd	s3,24(sp)
 43a:	0080                	addi	s0,sp,64
 43c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43e:	c299                	beqz	a3,444 <printint+0x16>
 440:	0805c063          	bltz	a1,4c0 <printint+0x92>
  neg = 0;
 444:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 446:	fc040313          	addi	t1,s0,-64
  neg = 0;
 44a:	869a                	mv	a3,t1
  i = 0;
 44c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 44e:	00000817          	auipc	a6,0x0
 452:	74280813          	addi	a6,a6,1858 # b90 <digits>
 456:	88be                	mv	a7,a5
 458:	0017851b          	addiw	a0,a5,1
 45c:	87aa                	mv	a5,a0
 45e:	02c5f73b          	remuw	a4,a1,a2
 462:	1702                	slli	a4,a4,0x20
 464:	9301                	srli	a4,a4,0x20
 466:	9742                	add	a4,a4,a6
 468:	00074703          	lbu	a4,0(a4)
 46c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 470:	872e                	mv	a4,a1
 472:	02c5d5bb          	divuw	a1,a1,a2
 476:	0685                	addi	a3,a3,1
 478:	fcc77fe3          	bgeu	a4,a2,456 <printint+0x28>
  if(neg)
 47c:	000e0c63          	beqz	t3,494 <printint+0x66>
    buf[i++] = '-';
 480:	fd050793          	addi	a5,a0,-48
 484:	00878533          	add	a0,a5,s0
 488:	02d00793          	li	a5,45
 48c:	fef50823          	sb	a5,-16(a0)
 490:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 494:	fff7899b          	addiw	s3,a5,-1
 498:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 49c:	fff4c583          	lbu	a1,-1(s1)
 4a0:	854a                	mv	a0,s2
 4a2:	00000097          	auipc	ra,0x0
 4a6:	f6a080e7          	jalr	-150(ra) # 40c <putc>
  while(--i >= 0)
 4aa:	39fd                	addiw	s3,s3,-1
 4ac:	14fd                	addi	s1,s1,-1
 4ae:	fe09d7e3          	bgez	s3,49c <printint+0x6e>
}
 4b2:	70e2                	ld	ra,56(sp)
 4b4:	7442                	ld	s0,48(sp)
 4b6:	74a2                	ld	s1,40(sp)
 4b8:	7902                	ld	s2,32(sp)
 4ba:	69e2                	ld	s3,24(sp)
 4bc:	6121                	addi	sp,sp,64
 4be:	8082                	ret
    x = -xx;
 4c0:	40b005bb          	negw	a1,a1
    neg = 1;
 4c4:	4e05                	li	t3,1
    x = -xx;
 4c6:	b741                	j	446 <printint+0x18>

00000000000004c8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c8:	715d                	addi	sp,sp,-80
 4ca:	e486                	sd	ra,72(sp)
 4cc:	e0a2                	sd	s0,64(sp)
 4ce:	f84a                	sd	s2,48(sp)
 4d0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d2:	0005c903          	lbu	s2,0(a1)
 4d6:	1a090a63          	beqz	s2,68a <vprintf+0x1c2>
 4da:	fc26                	sd	s1,56(sp)
 4dc:	f44e                	sd	s3,40(sp)
 4de:	f052                	sd	s4,32(sp)
 4e0:	ec56                	sd	s5,24(sp)
 4e2:	e85a                	sd	s6,16(sp)
 4e4:	e45e                	sd	s7,8(sp)
 4e6:	8aaa                	mv	s5,a0
 4e8:	8bb2                	mv	s7,a2
 4ea:	00158493          	addi	s1,a1,1
  state = 0;
 4ee:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4f0:	02500a13          	li	s4,37
 4f4:	4b55                	li	s6,21
 4f6:	a839                	j	514 <vprintf+0x4c>
        putc(fd, c);
 4f8:	85ca                	mv	a1,s2
 4fa:	8556                	mv	a0,s5
 4fc:	00000097          	auipc	ra,0x0
 500:	f10080e7          	jalr	-240(ra) # 40c <putc>
 504:	a019                	j	50a <vprintf+0x42>
    } else if(state == '%'){
 506:	01498d63          	beq	s3,s4,520 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 50a:	0485                	addi	s1,s1,1
 50c:	fff4c903          	lbu	s2,-1(s1)
 510:	16090763          	beqz	s2,67e <vprintf+0x1b6>
    if(state == 0){
 514:	fe0999e3          	bnez	s3,506 <vprintf+0x3e>
      if(c == '%'){
 518:	ff4910e3          	bne	s2,s4,4f8 <vprintf+0x30>
        state = '%';
 51c:	89d2                	mv	s3,s4
 51e:	b7f5                	j	50a <vprintf+0x42>
      if(c == 'd'){
 520:	13490463          	beq	s2,s4,648 <vprintf+0x180>
 524:	f9d9079b          	addiw	a5,s2,-99
 528:	0ff7f793          	zext.b	a5,a5
 52c:	12fb6763          	bltu	s6,a5,65a <vprintf+0x192>
 530:	f9d9079b          	addiw	a5,s2,-99
 534:	0ff7f713          	zext.b	a4,a5
 538:	12eb6163          	bltu	s6,a4,65a <vprintf+0x192>
 53c:	00271793          	slli	a5,a4,0x2
 540:	00000717          	auipc	a4,0x0
 544:	5f870713          	addi	a4,a4,1528 # b38 <ithread_join+0xba>
 548:	97ba                	add	a5,a5,a4
 54a:	439c                	lw	a5,0(a5)
 54c:	97ba                	add	a5,a5,a4
 54e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 550:	008b8913          	addi	s2,s7,8
 554:	4685                	li	a3,1
 556:	4629                	li	a2,10
 558:	000ba583          	lw	a1,0(s7)
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	ed0080e7          	jalr	-304(ra) # 42e <printint>
 566:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 568:	4981                	li	s3,0
 56a:	b745                	j	50a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56c:	008b8913          	addi	s2,s7,8
 570:	4681                	li	a3,0
 572:	4629                	li	a2,10
 574:	000ba583          	lw	a1,0(s7)
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	eb4080e7          	jalr	-332(ra) # 42e <printint>
 582:	8bca                	mv	s7,s2
      state = 0;
 584:	4981                	li	s3,0
 586:	b751                	j	50a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 588:	008b8913          	addi	s2,s7,8
 58c:	4681                	li	a3,0
 58e:	4641                	li	a2,16
 590:	000ba583          	lw	a1,0(s7)
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	e98080e7          	jalr	-360(ra) # 42e <printint>
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b7a5                	j	50a <vprintf+0x42>
 5a4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5a6:	008b8c13          	addi	s8,s7,8
 5aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ae:	03000593          	li	a1,48
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e58080e7          	jalr	-424(ra) # 40c <putc>
  putc(fd, 'x');
 5bc:	07800593          	li	a1,120
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e4a080e7          	jalr	-438(ra) # 40c <putc>
 5ca:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5cc:	00000b97          	auipc	s7,0x0
 5d0:	5c4b8b93          	addi	s7,s7,1476 # b90 <digits>
 5d4:	03c9d793          	srli	a5,s3,0x3c
 5d8:	97de                	add	a5,a5,s7
 5da:	0007c583          	lbu	a1,0(a5)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e2c080e7          	jalr	-468(ra) # 40c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e8:	0992                	slli	s3,s3,0x4
 5ea:	397d                	addiw	s2,s2,-1
 5ec:	fe0914e3          	bnez	s2,5d4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5f0:	8be2                	mv	s7,s8
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	6c02                	ld	s8,0(sp)
 5f6:	bf11                	j	50a <vprintf+0x42>
        s = va_arg(ap, char*);
 5f8:	008b8993          	addi	s3,s7,8
 5fc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 600:	02090163          	beqz	s2,622 <vprintf+0x15a>
        while(*s != 0){
 604:	00094583          	lbu	a1,0(s2)
 608:	c9a5                	beqz	a1,678 <vprintf+0x1b0>
          putc(fd, *s);
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e00080e7          	jalr	-512(ra) # 40c <putc>
          s++;
 614:	0905                	addi	s2,s2,1
        while(*s != 0){
 616:	00094583          	lbu	a1,0(s2)
 61a:	f9e5                	bnez	a1,60a <vprintf+0x142>
        s = va_arg(ap, char*);
 61c:	8bce                	mv	s7,s3
      state = 0;
 61e:	4981                	li	s3,0
 620:	b5ed                	j	50a <vprintf+0x42>
          s = "(null)";
 622:	00000917          	auipc	s2,0x0
 626:	4de90913          	addi	s2,s2,1246 # b00 <ithread_join+0x82>
        while(*s != 0){
 62a:	02800593          	li	a1,40
 62e:	bff1                	j	60a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 630:	008b8913          	addi	s2,s7,8
 634:	000bc583          	lbu	a1,0(s7)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	dd2080e7          	jalr	-558(ra) # 40c <putc>
 642:	8bca                	mv	s7,s2
      state = 0;
 644:	4981                	li	s3,0
 646:	b5d1                	j	50a <vprintf+0x42>
        putc(fd, c);
 648:	02500593          	li	a1,37
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	dbe080e7          	jalr	-578(ra) # 40c <putc>
      state = 0;
 656:	4981                	li	s3,0
 658:	bd4d                	j	50a <vprintf+0x42>
        putc(fd, '%');
 65a:	02500593          	li	a1,37
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	dac080e7          	jalr	-596(ra) # 40c <putc>
        putc(fd, c);
 668:	85ca                	mv	a1,s2
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	da0080e7          	jalr	-608(ra) # 40c <putc>
      state = 0;
 674:	4981                	li	s3,0
 676:	bd51                	j	50a <vprintf+0x42>
        s = va_arg(ap, char*);
 678:	8bce                	mv	s7,s3
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b579                	j	50a <vprintf+0x42>
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
 6b6:	e16080e7          	jalr	-490(ra) # 4c8 <vprintf>
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
 6ec:	de0080e7          	jalr	-544(ra) # 4c8 <vprintf>
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
 70c:	a02d                	j	736 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70e:	4618                	lw	a4,8(a2)
 710:	9f2d                	addw	a4,a4,a1
 712:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	6398                	ld	a4,0(a5)
 718:	6310                	ld	a2,0(a4)
 71a:	a83d                	j	758 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71c:	ff852703          	lw	a4,-8(a0)
 720:	9f31                	addw	a4,a4,a2
 722:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 724:	ff053683          	ld	a3,-16(a0)
 728:	a091                	j	76c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72a:	6398                	ld	a4,0(a5)
 72c:	00e7e463          	bltu	a5,a4,734 <free+0x3c>
 730:	00e6ea63          	bltu	a3,a4,744 <free+0x4c>
{
 734:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 736:	fed7fae3          	bgeu	a5,a3,72a <free+0x32>
 73a:	6398                	ld	a4,0(a5)
 73c:	00e6e463          	bltu	a3,a4,744 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 740:	fee7eae3          	bltu	a5,a4,734 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 744:	ff852583          	lw	a1,-8(a0)
 748:	6390                	ld	a2,0(a5)
 74a:	02059813          	slli	a6,a1,0x20
 74e:	01c85713          	srli	a4,a6,0x1c
 752:	9736                	add	a4,a4,a3
 754:	fae60de3          	beq	a2,a4,70e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 758:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 75c:	4790                	lw	a2,8(a5)
 75e:	02061593          	slli	a1,a2,0x20
 762:	01c5d713          	srli	a4,a1,0x1c
 766:	973e                	add	a4,a4,a5
 768:	fae68ae3          	beq	a3,a4,71c <free+0x24>
    p->s.ptr = bp->s.ptr;
 76c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 76e:	00001717          	auipc	a4,0x1
 772:	dcf73923          	sd	a5,-558(a4) # 1540 <freep>
}
 776:	60a2                	ld	ra,8(sp)
 778:	6402                	ld	s0,0(sp)
 77a:	0141                	addi	sp,sp,16
 77c:	8082                	ret

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
 822:	b8e080e7          	jalr	-1138(ra) # 3ac <sbrk>
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
 886:	b5a080e7          	jalr	-1190(ra) # 3dc <thread_exit>
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
 964:	90a080e7          	jalr	-1782(ra) # 26a <memmove>
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
 9ae:	0af71363          	bne	a4,a5,a54 <ithread_create+0xd0>
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
 9f8:	9d8080e7          	jalr	-1576(ra) # 3cc <create_thread>
 9fc:	892a                	mv	s2,a0
  if (res != -1) {
 9fe:	57fd                	li	a5,-1
 a00:	04f50c63          	beq	a0,a5,a58 <ithread_create+0xd4>
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
 a44:	0c850513          	addi	a0,a0,200 # b08 <ithread_join+0x8a>
 a48:	00000097          	auipc	ra,0x0
 a4c:	c7a080e7          	jalr	-902(ra) # 6c2 <printf>
      return -1;
 a50:	597d                	li	s2,-1
 a52:	b7c9                	j	a14 <ithread_create+0x90>
 a54:	ec26                	sd	s1,24(sp)
 a56:	b7bd                	j	9c4 <ithread_create+0x40>
    free(stack_ptr);
 a58:	8526                	mv	a0,s1
 a5a:	00000097          	auipc	ra,0x0
 a5e:	c9e080e7          	jalr	-866(ra) # 6f8 <free>
    stacks[num_threads] = 0;
 a62:	00001717          	auipc	a4,0x1
 a66:	aee72703          	lw	a4,-1298(a4) # 1550 <num_threads>
 a6a:	070e                	slli	a4,a4,0x3
 a6c:	00001797          	auipc	a5,0x1
 a70:	adc7b783          	ld	a5,-1316(a5) # 1548 <stacks>
 a74:	97ba                	add	a5,a5,a4
 a76:	0007b023          	sd	zero,0(a5)
 a7a:	64e2                	ld	s1,24(sp)
 a7c:	bf61                	j	a14 <ithread_create+0x90>

0000000000000a7e <ithread_join>:

int ithread_join(int thread_id) {
 a7e:	1101                	addi	sp,sp,-32
 a80:	ec06                	sd	ra,24(sp)
 a82:	e822                	sd	s0,16(sp)
 a84:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a86:	ff040793          	addi	a5,s0,-16
 a8a:	ffc7859b          	addiw	a1,a5,-4
 a8e:	00000097          	auipc	ra,0x0
 a92:	946080e7          	jalr	-1722(ra) # 3d4 <join_thread>
  threads_done++;
 a96:	00001717          	auipc	a4,0x1
 a9a:	abe70713          	addi	a4,a4,-1346 # 1554 <threads_done>
 a9e:	431c                	lw	a5,0(a4)
 aa0:	2785                	addiw	a5,a5,1
 aa2:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 aa4:	00001717          	auipc	a4,0x1
 aa8:	aac72703          	lw	a4,-1364(a4) # 1550 <num_threads>
 aac:	00f70863          	beq	a4,a5,abc <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ab0:	fec42503          	lw	a0,-20(s0)
 ab4:	60e2                	ld	ra,24(sp)
 ab6:	6442                	ld	s0,16(sp)
 ab8:	6105                	addi	sp,sp,32
 aba:	8082                	ret
    free_stacks();
 abc:	00000097          	auipc	ra,0x0
 ac0:	dd6080e7          	jalr	-554(ra) # 892 <free_stacks>
 ac4:	b7f5                	j	ab0 <ithread_join+0x32>
