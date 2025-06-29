
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2d4080e7          	jalr	724(ra) # 2dc <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	2ce080e7          	jalr	718(ra) # 2e4 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	354080e7          	jalr	852(ra) # 374 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	2a8080e7          	jalr	680(ra) # 2e4 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e406                	sd	ra,8(sp)
  48:	e022                	sd	s0,0(sp)
  4a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4c:	87aa                	mv	a5,a0
  4e:	0585                	addi	a1,a1,1
  50:	0785                	addi	a5,a5,1
  52:	fff5c703          	lbu	a4,-1(a1)
  56:	fee78fa3          	sb	a4,-1(a5)
  5a:	fb75                	bnez	a4,4e <strcpy+0xa>
    ;
  return os;
}
  5c:	60a2                	ld	ra,8(sp)
  5e:	6402                	ld	s0,0(sp)
  60:	0141                	addi	sp,sp,16
  62:	8082                	ret

0000000000000064 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  6c:	00054783          	lbu	a5,0(a0)
  70:	cb91                	beqz	a5,84 <strcmp+0x20>
  72:	0005c703          	lbu	a4,0(a1)
  76:	00f71763          	bne	a4,a5,84 <strcmp+0x20>
    p++, q++;
  7a:	0505                	addi	a0,a0,1
  7c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  7e:	00054783          	lbu	a5,0(a0)
  82:	fbe5                	bnez	a5,72 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  84:	0005c503          	lbu	a0,0(a1)
}
  88:	40a7853b          	subw	a0,a5,a0
  8c:	60a2                	ld	ra,8(sp)
  8e:	6402                	ld	s0,0(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strlen>:

uint
strlen(const char *s)
{
  94:	1141                	addi	sp,sp,-16
  96:	e406                	sd	ra,8(sp)
  98:	e022                	sd	s0,0(sp)
  9a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	cf99                	beqz	a5,be <strlen+0x2a>
  a2:	0505                	addi	a0,a0,1
  a4:	87aa                	mv	a5,a0
  a6:	86be                	mv	a3,a5
  a8:	0785                	addi	a5,a5,1
  aa:	fff7c703          	lbu	a4,-1(a5)
  ae:	ff65                	bnez	a4,a6 <strlen+0x12>
  b0:	40a6853b          	subw	a0,a3,a0
  b4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  b6:	60a2                	ld	ra,8(sp)
  b8:	6402                	ld	s0,0(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret
  for(n = 0; s[n]; n++)
  be:	4501                	li	a0,0
  c0:	bfdd                	j	b6 <strlen+0x22>

00000000000000c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ca:	ca19                	beqz	a2,e0 <memset+0x1e>
  cc:	87aa                	mv	a5,a0
  ce:	1602                	slli	a2,a2,0x20
  d0:	9201                	srli	a2,a2,0x20
  d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  da:	0785                	addi	a5,a5,1
  dc:	fee79de3          	bne	a5,a4,d6 <memset+0x14>
  }
  return dst;
}
  e0:	60a2                	ld	ra,8(sp)
  e2:	6402                	ld	s0,0(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strchr>:

char*
strchr(const char *s, char c)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  for(; *s; s++)
  f0:	00054783          	lbu	a5,0(a0)
  f4:	cf81                	beqz	a5,10c <strchr+0x24>
    if(*s == c)
  f6:	00f58763          	beq	a1,a5,104 <strchr+0x1c>
  for(; *s; s++)
  fa:	0505                	addi	a0,a0,1
  fc:	00054783          	lbu	a5,0(a0)
 100:	fbfd                	bnez	a5,f6 <strchr+0xe>
      return (char*)s;
  return 0;
 102:	4501                	li	a0,0
}
 104:	60a2                	ld	ra,8(sp)
 106:	6402                	ld	s0,0(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret
  return 0;
 10c:	4501                	li	a0,0
 10e:	bfdd                	j	104 <strchr+0x1c>

0000000000000110 <gets>:

char*
gets(char *buf, int max)
{
 110:	7159                	addi	sp,sp,-112
 112:	f486                	sd	ra,104(sp)
 114:	f0a2                	sd	s0,96(sp)
 116:	eca6                	sd	s1,88(sp)
 118:	e8ca                	sd	s2,80(sp)
 11a:	e4ce                	sd	s3,72(sp)
 11c:	e0d2                	sd	s4,64(sp)
 11e:	fc56                	sd	s5,56(sp)
 120:	f85a                	sd	s6,48(sp)
 122:	f45e                	sd	s7,40(sp)
 124:	f062                	sd	s8,32(sp)
 126:	ec66                	sd	s9,24(sp)
 128:	e86a                	sd	s10,16(sp)
 12a:	1880                	addi	s0,sp,112
 12c:	8caa                	mv	s9,a0
 12e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 130:	892a                	mv	s2,a0
 132:	4481                	li	s1,0
    cc = read(0, &c, 1);
 134:	f9f40b13          	addi	s6,s0,-97
 138:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13a:	4ba9                	li	s7,10
 13c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 13e:	8d26                	mv	s10,s1
 140:	0014899b          	addiw	s3,s1,1
 144:	84ce                	mv	s1,s3
 146:	0349d763          	bge	s3,s4,174 <gets+0x64>
    cc = read(0, &c, 1);
 14a:	8656                	mv	a2,s5
 14c:	85da                	mv	a1,s6
 14e:	4501                	li	a0,0
 150:	00000097          	auipc	ra,0x0
 154:	1ac080e7          	jalr	428(ra) # 2fc <read>
    if(cc < 1)
 158:	00a05e63          	blez	a0,174 <gets+0x64>
    buf[i++] = c;
 15c:	f9f44783          	lbu	a5,-97(s0)
 160:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 164:	01778763          	beq	a5,s7,172 <gets+0x62>
 168:	0905                	addi	s2,s2,1
 16a:	fd879ae3          	bne	a5,s8,13e <gets+0x2e>
    buf[i++] = c;
 16e:	8d4e                	mv	s10,s3
 170:	a011                	j	174 <gets+0x64>
 172:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 174:	9d66                	add	s10,s10,s9
 176:	000d0023          	sb	zero,0(s10)
  return buf;
}
 17a:	8566                	mv	a0,s9
 17c:	70a6                	ld	ra,104(sp)
 17e:	7406                	ld	s0,96(sp)
 180:	64e6                	ld	s1,88(sp)
 182:	6946                	ld	s2,80(sp)
 184:	69a6                	ld	s3,72(sp)
 186:	6a06                	ld	s4,64(sp)
 188:	7ae2                	ld	s5,56(sp)
 18a:	7b42                	ld	s6,48(sp)
 18c:	7ba2                	ld	s7,40(sp)
 18e:	7c02                	ld	s8,32(sp)
 190:	6ce2                	ld	s9,24(sp)
 192:	6d42                	ld	s10,16(sp)
 194:	6165                	addi	sp,sp,112
 196:	8082                	ret

0000000000000198 <stat>:

int
stat(const char *n, struct stat *st)
{
 198:	1101                	addi	sp,sp,-32
 19a:	ec06                	sd	ra,24(sp)
 19c:	e822                	sd	s0,16(sp)
 19e:	e04a                	sd	s2,0(sp)
 1a0:	1000                	addi	s0,sp,32
 1a2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a4:	4581                	li	a1,0
 1a6:	00000097          	auipc	ra,0x0
 1aa:	17e080e7          	jalr	382(ra) # 324 <open>
  if(fd < 0)
 1ae:	02054663          	bltz	a0,1da <stat+0x42>
 1b2:	e426                	sd	s1,8(sp)
 1b4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b6:	85ca                	mv	a1,s2
 1b8:	00000097          	auipc	ra,0x0
 1bc:	184080e7          	jalr	388(ra) # 33c <fstat>
 1c0:	892a                	mv	s2,a0
  close(fd);
 1c2:	8526                	mv	a0,s1
 1c4:	00000097          	auipc	ra,0x0
 1c8:	148080e7          	jalr	328(ra) # 30c <close>
  return r;
 1cc:	64a2                	ld	s1,8(sp)
}
 1ce:	854a                	mv	a0,s2
 1d0:	60e2                	ld	ra,24(sp)
 1d2:	6442                	ld	s0,16(sp)
 1d4:	6902                	ld	s2,0(sp)
 1d6:	6105                	addi	sp,sp,32
 1d8:	8082                	ret
    return -1;
 1da:	597d                	li	s2,-1
 1dc:	bfcd                	j	1ce <stat+0x36>

00000000000001de <atoi>:

int
atoi(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e406                	sd	ra,8(sp)
 1e2:	e022                	sd	s0,0(sp)
 1e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e6:	00054683          	lbu	a3,0(a0)
 1ea:	fd06879b          	addiw	a5,a3,-48
 1ee:	0ff7f793          	zext.b	a5,a5
 1f2:	4625                	li	a2,9
 1f4:	02f66963          	bltu	a2,a5,226 <atoi+0x48>
 1f8:	872a                	mv	a4,a0
  n = 0;
 1fa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1fc:	0705                	addi	a4,a4,1
 1fe:	0025179b          	slliw	a5,a0,0x2
 202:	9fa9                	addw	a5,a5,a0
 204:	0017979b          	slliw	a5,a5,0x1
 208:	9fb5                	addw	a5,a5,a3
 20a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20e:	00074683          	lbu	a3,0(a4)
 212:	fd06879b          	addiw	a5,a3,-48
 216:	0ff7f793          	zext.b	a5,a5
 21a:	fef671e3          	bgeu	a2,a5,1fc <atoi+0x1e>
  return n;
}
 21e:	60a2                	ld	ra,8(sp)
 220:	6402                	ld	s0,0(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
  n = 0;
 226:	4501                	li	a0,0
 228:	bfdd                	j	21e <atoi+0x40>

000000000000022a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 232:	02b57563          	bgeu	a0,a1,25c <memmove+0x32>
    while(n-- > 0)
 236:	00c05f63          	blez	a2,254 <memmove+0x2a>
 23a:	1602                	slli	a2,a2,0x20
 23c:	9201                	srli	a2,a2,0x20
 23e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 242:	872a                	mv	a4,a0
      *dst++ = *src++;
 244:	0585                	addi	a1,a1,1
 246:	0705                	addi	a4,a4,1
 248:	fff5c683          	lbu	a3,-1(a1)
 24c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 254:	60a2                	ld	ra,8(sp)
 256:	6402                	ld	s0,0(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
    dst += n;
 25c:	00c50733          	add	a4,a0,a2
    src += n;
 260:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 262:	fec059e3          	blez	a2,254 <memmove+0x2a>
 266:	fff6079b          	addiw	a5,a2,-1
 26a:	1782                	slli	a5,a5,0x20
 26c:	9381                	srli	a5,a5,0x20
 26e:	fff7c793          	not	a5,a5
 272:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 274:	15fd                	addi	a1,a1,-1
 276:	177d                	addi	a4,a4,-1
 278:	0005c683          	lbu	a3,0(a1)
 27c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 280:	fef71ae3          	bne	a4,a5,274 <memmove+0x4a>
 284:	bfc1                	j	254 <memmove+0x2a>

0000000000000286 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28e:	ca0d                	beqz	a2,2c0 <memcmp+0x3a>
 290:	fff6069b          	addiw	a3,a2,-1
 294:	1682                	slli	a3,a3,0x20
 296:	9281                	srli	a3,a3,0x20
 298:	0685                	addi	a3,a3,1
 29a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00e79863          	bne	a5,a4,2b4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2a8:	0505                	addi	a0,a0,1
    p2++;
 2aa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ac:	fed518e3          	bne	a0,a3,29c <memcmp+0x16>
  }
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	a019                	j	2b8 <memcmp+0x32>
      return *p1 - *p2;
 2b4:	40e7853b          	subw	a0,a5,a4
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	bfdd                	j	2b8 <memcmp+0x32>

00000000000002c4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2cc:	00000097          	auipc	ra,0x0
 2d0:	f5e080e7          	jalr	-162(ra) # 22a <memmove>
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2dc:	4885                	li	a7,1
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e4:	4889                	li	a7,2
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ec:	488d                	li	a7,3
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f4:	4891                	li	a7,4
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <read>:
.global read
read:
 li a7, SYS_read
 2fc:	4895                	li	a7,5
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <write>:
.global write
write:
 li a7, SYS_write
 304:	48c1                	li	a7,16
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <close>:
.global close
close:
 li a7, SYS_close
 30c:	48d5                	li	a7,21
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <kill>:
.global kill
kill:
 li a7, SYS_kill
 314:	4899                	li	a7,6
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exec>:
.global exec
exec:
 li a7, SYS_exec
 31c:	489d                	li	a7,7
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <open>:
.global open
open:
 li a7, SYS_open
 324:	48bd                	li	a7,15
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32c:	48c5                	li	a7,17
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 334:	48c9                	li	a7,18
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33c:	48a1                	li	a7,8
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <link>:
.global link
link:
 li a7, SYS_link
 344:	48cd                	li	a7,19
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34c:	48d1                	li	a7,20
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 354:	48a5                	li	a7,9
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <dup>:
.global dup
dup:
 li a7, SYS_dup
 35c:	48a9                	li	a7,10
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 364:	48ad                	li	a7,11
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 36c:	48b1                	li	a7,12
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 374:	48b5                	li	a7,13
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37c:	48b9                	li	a7,14
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 384:	48d9                	li	a7,22
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 38c:	48dd                	li	a7,23
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 394:	48e1                	li	a7,24
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 39c:	48e5                	li	a7,25
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3a4:	48e9                	li	a7,26
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <bind>:
.global bind
bind:
 li a7, SYS_bind
 3ac:	48ed                	li	a7,27
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3b4:	48f5                	li	a7,29
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <listen>:
.global listen
listen:
 li a7, SYS_listen
 3bc:	48f1                	li	a7,28
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3c4:	48f9                	li	a7,30
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3cc:	1101                	addi	sp,sp,-32
 3ce:	ec06                	sd	ra,24(sp)
 3d0:	e822                	sd	s0,16(sp)
 3d2:	1000                	addi	s0,sp,32
 3d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	fef40593          	addi	a1,s0,-17
 3de:	00000097          	auipc	ra,0x0
 3e2:	f26080e7          	jalr	-218(ra) # 304 <write>
}
 3e6:	60e2                	ld	ra,24(sp)
 3e8:	6442                	ld	s0,16(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret

00000000000003ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ee:	7139                	addi	sp,sp,-64
 3f0:	fc06                	sd	ra,56(sp)
 3f2:	f822                	sd	s0,48(sp)
 3f4:	f426                	sd	s1,40(sp)
 3f6:	f04a                	sd	s2,32(sp)
 3f8:	ec4e                	sd	s3,24(sp)
 3fa:	0080                	addi	s0,sp,64
 3fc:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fe:	c299                	beqz	a3,404 <printint+0x16>
 400:	0805c063          	bltz	a1,480 <printint+0x92>
  neg = 0;
 404:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 406:	fc040313          	addi	t1,s0,-64
  neg = 0;
 40a:	869a                	mv	a3,t1
  i = 0;
 40c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 40e:	00000817          	auipc	a6,0x0
 412:	71280813          	addi	a6,a6,1810 # b20 <digits>
 416:	88be                	mv	a7,a5
 418:	0017851b          	addiw	a0,a5,1
 41c:	87aa                	mv	a5,a0
 41e:	02c5f73b          	remuw	a4,a1,a2
 422:	1702                	slli	a4,a4,0x20
 424:	9301                	srli	a4,a4,0x20
 426:	9742                	add	a4,a4,a6
 428:	00074703          	lbu	a4,0(a4)
 42c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 430:	872e                	mv	a4,a1
 432:	02c5d5bb          	divuw	a1,a1,a2
 436:	0685                	addi	a3,a3,1
 438:	fcc77fe3          	bgeu	a4,a2,416 <printint+0x28>
  if(neg)
 43c:	000e0c63          	beqz	t3,454 <printint+0x66>
    buf[i++] = '-';
 440:	fd050793          	addi	a5,a0,-48
 444:	00878533          	add	a0,a5,s0
 448:	02d00793          	li	a5,45
 44c:	fef50823          	sb	a5,-16(a0)
 450:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 454:	fff7899b          	addiw	s3,a5,-1
 458:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 45c:	fff4c583          	lbu	a1,-1(s1)
 460:	854a                	mv	a0,s2
 462:	00000097          	auipc	ra,0x0
 466:	f6a080e7          	jalr	-150(ra) # 3cc <putc>
  while(--i >= 0)
 46a:	39fd                	addiw	s3,s3,-1
 46c:	14fd                	addi	s1,s1,-1
 46e:	fe09d7e3          	bgez	s3,45c <printint+0x6e>
}
 472:	70e2                	ld	ra,56(sp)
 474:	7442                	ld	s0,48(sp)
 476:	74a2                	ld	s1,40(sp)
 478:	7902                	ld	s2,32(sp)
 47a:	69e2                	ld	s3,24(sp)
 47c:	6121                	addi	sp,sp,64
 47e:	8082                	ret
    x = -xx;
 480:	40b005bb          	negw	a1,a1
    neg = 1;
 484:	4e05                	li	t3,1
    x = -xx;
 486:	b741                	j	406 <printint+0x18>

0000000000000488 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 488:	715d                	addi	sp,sp,-80
 48a:	e486                	sd	ra,72(sp)
 48c:	e0a2                	sd	s0,64(sp)
 48e:	f84a                	sd	s2,48(sp)
 490:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 492:	0005c903          	lbu	s2,0(a1)
 496:	1a090a63          	beqz	s2,64a <vprintf+0x1c2>
 49a:	fc26                	sd	s1,56(sp)
 49c:	f44e                	sd	s3,40(sp)
 49e:	f052                	sd	s4,32(sp)
 4a0:	ec56                	sd	s5,24(sp)
 4a2:	e85a                	sd	s6,16(sp)
 4a4:	e45e                	sd	s7,8(sp)
 4a6:	8aaa                	mv	s5,a0
 4a8:	8bb2                	mv	s7,a2
 4aa:	00158493          	addi	s1,a1,1
  state = 0;
 4ae:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b0:	02500a13          	li	s4,37
 4b4:	4b55                	li	s6,21
 4b6:	a839                	j	4d4 <vprintf+0x4c>
        putc(fd, c);
 4b8:	85ca                	mv	a1,s2
 4ba:	8556                	mv	a0,s5
 4bc:	00000097          	auipc	ra,0x0
 4c0:	f10080e7          	jalr	-240(ra) # 3cc <putc>
 4c4:	a019                	j	4ca <vprintf+0x42>
    } else if(state == '%'){
 4c6:	01498d63          	beq	s3,s4,4e0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4ca:	0485                	addi	s1,s1,1
 4cc:	fff4c903          	lbu	s2,-1(s1)
 4d0:	16090763          	beqz	s2,63e <vprintf+0x1b6>
    if(state == 0){
 4d4:	fe0999e3          	bnez	s3,4c6 <vprintf+0x3e>
      if(c == '%'){
 4d8:	ff4910e3          	bne	s2,s4,4b8 <vprintf+0x30>
        state = '%';
 4dc:	89d2                	mv	s3,s4
 4de:	b7f5                	j	4ca <vprintf+0x42>
      if(c == 'd'){
 4e0:	13490463          	beq	s2,s4,608 <vprintf+0x180>
 4e4:	f9d9079b          	addiw	a5,s2,-99
 4e8:	0ff7f793          	zext.b	a5,a5
 4ec:	12fb6763          	bltu	s6,a5,61a <vprintf+0x192>
 4f0:	f9d9079b          	addiw	a5,s2,-99
 4f4:	0ff7f713          	zext.b	a4,a5
 4f8:	12eb6163          	bltu	s6,a4,61a <vprintf+0x192>
 4fc:	00271793          	slli	a5,a4,0x2
 500:	00000717          	auipc	a4,0x0
 504:	5c870713          	addi	a4,a4,1480 # ac8 <ithread_join+0x8a>
 508:	97ba                	add	a5,a5,a4
 50a:	439c                	lw	a5,0(a5)
 50c:	97ba                	add	a5,a5,a4
 50e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 510:	008b8913          	addi	s2,s7,8
 514:	4685                	li	a3,1
 516:	4629                	li	a2,10
 518:	000ba583          	lw	a1,0(s7)
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	ed0080e7          	jalr	-304(ra) # 3ee <printint>
 526:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 528:	4981                	li	s3,0
 52a:	b745                	j	4ca <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 52c:	008b8913          	addi	s2,s7,8
 530:	4681                	li	a3,0
 532:	4629                	li	a2,10
 534:	000ba583          	lw	a1,0(s7)
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	eb4080e7          	jalr	-332(ra) # 3ee <printint>
 542:	8bca                	mv	s7,s2
      state = 0;
 544:	4981                	li	s3,0
 546:	b751                	j	4ca <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 548:	008b8913          	addi	s2,s7,8
 54c:	4681                	li	a3,0
 54e:	4641                	li	a2,16
 550:	000ba583          	lw	a1,0(s7)
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	e98080e7          	jalr	-360(ra) # 3ee <printint>
 55e:	8bca                	mv	s7,s2
      state = 0;
 560:	4981                	li	s3,0
 562:	b7a5                	j	4ca <vprintf+0x42>
 564:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 566:	008b8c13          	addi	s8,s7,8
 56a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 56e:	03000593          	li	a1,48
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e58080e7          	jalr	-424(ra) # 3cc <putc>
  putc(fd, 'x');
 57c:	07800593          	li	a1,120
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e4a080e7          	jalr	-438(ra) # 3cc <putc>
 58a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 58c:	00000b97          	auipc	s7,0x0
 590:	594b8b93          	addi	s7,s7,1428 # b20 <digits>
 594:	03c9d793          	srli	a5,s3,0x3c
 598:	97de                	add	a5,a5,s7
 59a:	0007c583          	lbu	a1,0(a5)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	e2c080e7          	jalr	-468(ra) # 3cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a8:	0992                	slli	s3,s3,0x4
 5aa:	397d                	addiw	s2,s2,-1
 5ac:	fe0914e3          	bnez	s2,594 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5b0:	8be2                	mv	s7,s8
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	6c02                	ld	s8,0(sp)
 5b6:	bf11                	j	4ca <vprintf+0x42>
        s = va_arg(ap, char*);
 5b8:	008b8993          	addi	s3,s7,8
 5bc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5c0:	02090163          	beqz	s2,5e2 <vprintf+0x15a>
        while(*s != 0){
 5c4:	00094583          	lbu	a1,0(s2)
 5c8:	c9a5                	beqz	a1,638 <vprintf+0x1b0>
          putc(fd, *s);
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e00080e7          	jalr	-512(ra) # 3cc <putc>
          s++;
 5d4:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d6:	00094583          	lbu	a1,0(s2)
 5da:	f9e5                	bnez	a1,5ca <vprintf+0x142>
        s = va_arg(ap, char*);
 5dc:	8bce                	mv	s7,s3
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b5ed                	j	4ca <vprintf+0x42>
          s = "(null)";
 5e2:	00000917          	auipc	s2,0x0
 5e6:	4ae90913          	addi	s2,s2,1198 # a90 <ithread_join+0x52>
        while(*s != 0){
 5ea:	02800593          	li	a1,40
 5ee:	bff1                	j	5ca <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5f0:	008b8913          	addi	s2,s7,8
 5f4:	000bc583          	lbu	a1,0(s7)
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	dd2080e7          	jalr	-558(ra) # 3cc <putc>
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
 606:	b5d1                	j	4ca <vprintf+0x42>
        putc(fd, c);
 608:	02500593          	li	a1,37
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	dbe080e7          	jalr	-578(ra) # 3cc <putc>
      state = 0;
 616:	4981                	li	s3,0
 618:	bd4d                	j	4ca <vprintf+0x42>
        putc(fd, '%');
 61a:	02500593          	li	a1,37
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	dac080e7          	jalr	-596(ra) # 3cc <putc>
        putc(fd, c);
 628:	85ca                	mv	a1,s2
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	da0080e7          	jalr	-608(ra) # 3cc <putc>
      state = 0;
 634:	4981                	li	s3,0
 636:	bd51                	j	4ca <vprintf+0x42>
        s = va_arg(ap, char*);
 638:	8bce                	mv	s7,s3
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b579                	j	4ca <vprintf+0x42>
 63e:	74e2                	ld	s1,56(sp)
 640:	79a2                	ld	s3,40(sp)
 642:	7a02                	ld	s4,32(sp)
 644:	6ae2                	ld	s5,24(sp)
 646:	6b42                	ld	s6,16(sp)
 648:	6ba2                	ld	s7,8(sp)
    }
  }
}
 64a:	60a6                	ld	ra,72(sp)
 64c:	6406                	ld	s0,64(sp)
 64e:	7942                	ld	s2,48(sp)
 650:	6161                	addi	sp,sp,80
 652:	8082                	ret

0000000000000654 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 654:	715d                	addi	sp,sp,-80
 656:	ec06                	sd	ra,24(sp)
 658:	e822                	sd	s0,16(sp)
 65a:	1000                	addi	s0,sp,32
 65c:	e010                	sd	a2,0(s0)
 65e:	e414                	sd	a3,8(s0)
 660:	e818                	sd	a4,16(s0)
 662:	ec1c                	sd	a5,24(s0)
 664:	03043023          	sd	a6,32(s0)
 668:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 66c:	8622                	mv	a2,s0
 66e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 672:	00000097          	auipc	ra,0x0
 676:	e16080e7          	jalr	-490(ra) # 488 <vprintf>
}
 67a:	60e2                	ld	ra,24(sp)
 67c:	6442                	ld	s0,16(sp)
 67e:	6161                	addi	sp,sp,80
 680:	8082                	ret

0000000000000682 <printf>:

void
printf(const char *fmt, ...)
{
 682:	711d                	addi	sp,sp,-96
 684:	ec06                	sd	ra,24(sp)
 686:	e822                	sd	s0,16(sp)
 688:	1000                	addi	s0,sp,32
 68a:	e40c                	sd	a1,8(s0)
 68c:	e810                	sd	a2,16(s0)
 68e:	ec14                	sd	a3,24(s0)
 690:	f018                	sd	a4,32(s0)
 692:	f41c                	sd	a5,40(s0)
 694:	03043823          	sd	a6,48(s0)
 698:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 69c:	00840613          	addi	a2,s0,8
 6a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a4:	85aa                	mv	a1,a0
 6a6:	4505                	li	a0,1
 6a8:	00000097          	auipc	ra,0x0
 6ac:	de0080e7          	jalr	-544(ra) # 488 <vprintf>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6125                	addi	sp,sp,96
 6b6:	8082                	ret

00000000000006b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b8:	1141                	addi	sp,sp,-16
 6ba:	e406                	sd	ra,8(sp)
 6bc:	e022                	sd	s0,0(sp)
 6be:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c4:	00001797          	auipc	a5,0x1
 6c8:	e4c7b783          	ld	a5,-436(a5) # 1510 <freep>
 6cc:	a02d                	j	6f6 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ce:	4618                	lw	a4,8(a2)
 6d0:	9f2d                	addw	a4,a4,a1
 6d2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d6:	6398                	ld	a4,0(a5)
 6d8:	6310                	ld	a2,0(a4)
 6da:	a83d                	j	718 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6dc:	ff852703          	lw	a4,-8(a0)
 6e0:	9f31                	addw	a4,a4,a2
 6e2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6e4:	ff053683          	ld	a3,-16(a0)
 6e8:	a091                	j	72c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ea:	6398                	ld	a4,0(a5)
 6ec:	00e7e463          	bltu	a5,a4,6f4 <free+0x3c>
 6f0:	00e6ea63          	bltu	a3,a4,704 <free+0x4c>
{
 6f4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f6:	fed7fae3          	bgeu	a5,a3,6ea <free+0x32>
 6fa:	6398                	ld	a4,0(a5)
 6fc:	00e6e463          	bltu	a3,a4,704 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 700:	fee7eae3          	bltu	a5,a4,6f4 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 704:	ff852583          	lw	a1,-8(a0)
 708:	6390                	ld	a2,0(a5)
 70a:	02059813          	slli	a6,a1,0x20
 70e:	01c85713          	srli	a4,a6,0x1c
 712:	9736                	add	a4,a4,a3
 714:	fae60de3          	beq	a2,a4,6ce <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 718:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 71c:	4790                	lw	a2,8(a5)
 71e:	02061593          	slli	a1,a2,0x20
 722:	01c5d713          	srli	a4,a1,0x1c
 726:	973e                	add	a4,a4,a5
 728:	fae68ae3          	beq	a3,a4,6dc <free+0x24>
    p->s.ptr = bp->s.ptr;
 72c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 72e:	00001717          	auipc	a4,0x1
 732:	def73123          	sd	a5,-542(a4) # 1510 <freep>
}
 736:	60a2                	ld	ra,8(sp)
 738:	6402                	ld	s0,0(sp)
 73a:	0141                	addi	sp,sp,16
 73c:	8082                	ret

000000000000073e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 73e:	7139                	addi	sp,sp,-64
 740:	fc06                	sd	ra,56(sp)
 742:	f822                	sd	s0,48(sp)
 744:	f04a                	sd	s2,32(sp)
 746:	ec4e                	sd	s3,24(sp)
 748:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74a:	02051993          	slli	s3,a0,0x20
 74e:	0209d993          	srli	s3,s3,0x20
 752:	09bd                	addi	s3,s3,15
 754:	0049d993          	srli	s3,s3,0x4
 758:	2985                	addiw	s3,s3,1
 75a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 75c:	00001517          	auipc	a0,0x1
 760:	db453503          	ld	a0,-588(a0) # 1510 <freep>
 764:	c905                	beqz	a0,794 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 766:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 768:	4798                	lw	a4,8(a5)
 76a:	09377a63          	bgeu	a4,s3,7fe <malloc+0xc0>
 76e:	f426                	sd	s1,40(sp)
 770:	e852                	sd	s4,16(sp)
 772:	e456                	sd	s5,8(sp)
 774:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 776:	8a4e                	mv	s4,s3
 778:	6705                	lui	a4,0x1
 77a:	00e9f363          	bgeu	s3,a4,780 <malloc+0x42>
 77e:	6a05                	lui	s4,0x1
 780:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 784:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 788:	00001497          	auipc	s1,0x1
 78c:	d8848493          	addi	s1,s1,-632 # 1510 <freep>
  if(p == (char*)-1)
 790:	5afd                	li	s5,-1
 792:	a089                	j	7d4 <malloc+0x96>
 794:	f426                	sd	s1,40(sp)
 796:	e852                	sd	s4,16(sp)
 798:	e456                	sd	s5,8(sp)
 79a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 79c:	00001797          	auipc	a5,0x1
 7a0:	d9478793          	addi	a5,a5,-620 # 1530 <base>
 7a4:	00001717          	auipc	a4,0x1
 7a8:	d6f73623          	sd	a5,-660(a4) # 1510 <freep>
 7ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7b2:	b7d1                	j	776 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7b4:	6398                	ld	a4,0(a5)
 7b6:	e118                	sd	a4,0(a0)
 7b8:	a8b9                	j	816 <malloc+0xd8>
  hp->s.size = nu;
 7ba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7be:	0541                	addi	a0,a0,16
 7c0:	00000097          	auipc	ra,0x0
 7c4:	ef8080e7          	jalr	-264(ra) # 6b8 <free>
  return freep;
 7c8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7ca:	c135                	beqz	a0,82e <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ce:	4798                	lw	a4,8(a5)
 7d0:	03277363          	bgeu	a4,s2,7f6 <malloc+0xb8>
    if(p == freep)
 7d4:	6098                	ld	a4,0(s1)
 7d6:	853e                	mv	a0,a5
 7d8:	fef71ae3          	bne	a4,a5,7cc <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7dc:	8552                	mv	a0,s4
 7de:	00000097          	auipc	ra,0x0
 7e2:	b8e080e7          	jalr	-1138(ra) # 36c <sbrk>
  if(p == (char*)-1)
 7e6:	fd551ae3          	bne	a0,s5,7ba <malloc+0x7c>
        return 0;
 7ea:	4501                	li	a0,0
 7ec:	74a2                	ld	s1,40(sp)
 7ee:	6a42                	ld	s4,16(sp)
 7f0:	6aa2                	ld	s5,8(sp)
 7f2:	6b02                	ld	s6,0(sp)
 7f4:	a03d                	j	822 <malloc+0xe4>
 7f6:	74a2                	ld	s1,40(sp)
 7f8:	6a42                	ld	s4,16(sp)
 7fa:	6aa2                	ld	s5,8(sp)
 7fc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7fe:	fae90be3          	beq	s2,a4,7b4 <malloc+0x76>
        p->s.size -= nunits;
 802:	4137073b          	subw	a4,a4,s3
 806:	c798                	sw	a4,8(a5)
        p += p->s.size;
 808:	02071693          	slli	a3,a4,0x20
 80c:	01c6d713          	srli	a4,a3,0x1c
 810:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 812:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 816:	00001717          	auipc	a4,0x1
 81a:	cea73d23          	sd	a0,-774(a4) # 1510 <freep>
      return (void*)(p + 1);
 81e:	01078513          	addi	a0,a5,16
  }
}
 822:	70e2                	ld	ra,56(sp)
 824:	7442                	ld	s0,48(sp)
 826:	7902                	ld	s2,32(sp)
 828:	69e2                	ld	s3,24(sp)
 82a:	6121                	addi	sp,sp,64
 82c:	8082                	ret
 82e:	74a2                	ld	s1,40(sp)
 830:	6a42                	ld	s4,16(sp)
 832:	6aa2                	ld	s5,8(sp)
 834:	6b02                	ld	s6,0(sp)
 836:	b7f5                	j	822 <malloc+0xe4>

0000000000000838 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 838:	1141                	addi	sp,sp,-16
 83a:	e406                	sd	ra,8(sp)
 83c:	e022                	sd	s0,0(sp)
 83e:	0800                	addi	s0,sp,16
  thread_exit(status);
 840:	2501                	sext.w	a0,a0
 842:	00000097          	auipc	ra,0x0
 846:	b5a080e7          	jalr	-1190(ra) # 39c <thread_exit>
}
 84a:	60a2                	ld	ra,8(sp)
 84c:	6402                	ld	s0,0(sp)
 84e:	0141                	addi	sp,sp,16
 850:	8082                	ret

0000000000000852 <free_stacks>:
int free_stacks() {
 852:	7179                	addi	sp,sp,-48
 854:	f406                	sd	ra,40(sp)
 856:	f022                	sd	s0,32(sp)
 858:	ec26                	sd	s1,24(sp)
 85a:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 85c:	00001797          	auipc	a5,0x1
 860:	cc47a783          	lw	a5,-828(a5) # 1520 <num_threads>
 864:	04f05063          	blez	a5,8a4 <free_stacks+0x52>
 868:	e84a                	sd	s2,16(sp)
 86a:	e44e                	sd	s3,8(sp)
 86c:	4481                	li	s1,0
    free(stacks[i]);
 86e:	00001997          	auipc	s3,0x1
 872:	caa98993          	addi	s3,s3,-854 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 876:	00001917          	auipc	s2,0x1
 87a:	caa90913          	addi	s2,s2,-854 # 1520 <num_threads>
    free(stacks[i]);
 87e:	0009b783          	ld	a5,0(s3)
 882:	00349713          	slli	a4,s1,0x3
 886:	97ba                	add	a5,a5,a4
 888:	6388                	ld	a0,0(a5)
 88a:	00000097          	auipc	ra,0x0
 88e:	e2e080e7          	jalr	-466(ra) # 6b8 <free>
  for (int i = 0; i < num_threads; i++) {
 892:	0485                	addi	s1,s1,1
 894:	00092703          	lw	a4,0(s2)
 898:	0004879b          	sext.w	a5,s1
 89c:	fee7c1e3          	blt	a5,a4,87e <free_stacks+0x2c>
 8a0:	6942                	ld	s2,16(sp)
 8a2:	69a2                	ld	s3,8(sp)
  free(stacks);
 8a4:	00001497          	auipc	s1,0x1
 8a8:	c7448493          	addi	s1,s1,-908 # 1518 <stacks>
 8ac:	6088                	ld	a0,0(s1)
 8ae:	00000097          	auipc	ra,0x0
 8b2:	e0a080e7          	jalr	-502(ra) # 6b8 <free>
  stacks = 0;
 8b6:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8ba:	00001797          	auipc	a5,0x1
 8be:	c607a323          	sw	zero,-922(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8c2:	47a1                	li	a5,8
 8c4:	00001717          	auipc	a4,0x1
 8c8:	c2f72e23          	sw	a5,-964(a4) # 1500 <max_stacks>
  threads_done = 0;
 8cc:	00001797          	auipc	a5,0x1
 8d0:	c407ac23          	sw	zero,-936(a5) # 1524 <threads_done>
}
 8d4:	4501                	li	a0,0
 8d6:	70a2                	ld	ra,40(sp)
 8d8:	7402                	ld	s0,32(sp)
 8da:	64e2                	ld	s1,24(sp)
 8dc:	6145                	addi	sp,sp,48
 8de:	8082                	ret

00000000000008e0 <expand_num_threads>:
int expand_num_threads() {
 8e0:	1101                	addi	sp,sp,-32
 8e2:	ec06                	sd	ra,24(sp)
 8e4:	e822                	sd	s0,16(sp)
 8e6:	e426                	sd	s1,8(sp)
 8e8:	e04a                	sd	s2,0(sp)
 8ea:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 8ec:	00001797          	auipc	a5,0x1
 8f0:	c1478793          	addi	a5,a5,-1004 # 1500 <max_stacks>
 8f4:	4388                	lw	a0,0(a5)
 8f6:	0015151b          	slliw	a0,a0,0x1
 8fa:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 8fc:	0035151b          	slliw	a0,a0,0x3
 900:	00000097          	auipc	ra,0x0
 904:	e3e080e7          	jalr	-450(ra) # 73e <malloc>
 908:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 90a:	00001617          	auipc	a2,0x1
 90e:	c1662603          	lw	a2,-1002(a2) # 1520 <num_threads>
 912:	00001497          	auipc	s1,0x1
 916:	c0648493          	addi	s1,s1,-1018 # 1518 <stacks>
 91a:	0036161b          	slliw	a2,a2,0x3
 91e:	608c                	ld	a1,0(s1)
 920:	00000097          	auipc	ra,0x0
 924:	90a080e7          	jalr	-1782(ra) # 22a <memmove>
  free(stacks);
 928:	6088                	ld	a0,0(s1)
 92a:	00000097          	auipc	ra,0x0
 92e:	d8e080e7          	jalr	-626(ra) # 6b8 <free>
  stacks = new_stacks;
 932:	0124b023          	sd	s2,0(s1)
}
 936:	4501                	li	a0,0
 938:	60e2                	ld	ra,24(sp)
 93a:	6442                	ld	s0,16(sp)
 93c:	64a2                	ld	s1,8(sp)
 93e:	6902                	ld	s2,0(sp)
 940:	6105                	addi	sp,sp,32
 942:	8082                	ret

0000000000000944 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 944:	7179                	addi	sp,sp,-48
 946:	f406                	sd	ra,40(sp)
 948:	f022                	sd	s0,32(sp)
 94a:	e84a                	sd	s2,16(sp)
 94c:	e44e                	sd	s3,8(sp)
 94e:	1800                	addi	s0,sp,48
 950:	892a                	mv	s2,a0
 952:	89ae                	mv	s3,a1
  if (stacks == 0) {
 954:	00001797          	auipc	a5,0x1
 958:	bc47b783          	ld	a5,-1084(a5) # 1518 <stacks>
 95c:	c3d9                	beqz	a5,9e2 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 95e:	00001797          	auipc	a5,0x1
 962:	ba27a783          	lw	a5,-1118(a5) # 1500 <max_stacks>
 966:	00001717          	auipc	a4,0x1
 96a:	bba72703          	lw	a4,-1094(a4) # 1520 <num_threads>
 96e:	0af71363          	bne	a4,a5,a14 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 972:	04000713          	li	a4,64
 976:	08e78563          	beq	a5,a4,a00 <ithread_create+0xbc>
 97a:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 97c:	00000097          	auipc	ra,0x0
 980:	f64080e7          	jalr	-156(ra) # 8e0 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 984:	6505                	lui	a0,0x1
 986:	00000097          	auipc	ra,0x0
 98a:	db8080e7          	jalr	-584(ra) # 73e <malloc>
 98e:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 990:	00001717          	auipc	a4,0x1
 994:	b9072703          	lw	a4,-1136(a4) # 1520 <num_threads>
 998:	070e                	slli	a4,a4,0x3
 99a:	00001797          	auipc	a5,0x1
 99e:	b7e7b783          	ld	a5,-1154(a5) # 1518 <stacks>
 9a2:	97ba                	add	a5,a5,a4
 9a4:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9a6:	00000697          	auipc	a3,0x0
 9aa:	e9268693          	addi	a3,a3,-366 # 838 <ithread_exit>
 9ae:	862a                	mv	a2,a0
 9b0:	85ce                	mv	a1,s3
 9b2:	854a                	mv	a0,s2
 9b4:	00000097          	auipc	ra,0x0
 9b8:	9d8080e7          	jalr	-1576(ra) # 38c <create_thread>
 9bc:	892a                	mv	s2,a0
  if (res != -1) {
 9be:	57fd                	li	a5,-1
 9c0:	04f50c63          	beq	a0,a5,a18 <ithread_create+0xd4>
    num_threads++;
 9c4:	00001717          	auipc	a4,0x1
 9c8:	b5c70713          	addi	a4,a4,-1188 # 1520 <num_threads>
 9cc:	431c                	lw	a5,0(a4)
 9ce:	2785                	addiw	a5,a5,1
 9d0:	c31c                	sw	a5,0(a4)
 9d2:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 9d4:	854a                	mv	a0,s2
 9d6:	70a2                	ld	ra,40(sp)
 9d8:	7402                	ld	s0,32(sp)
 9da:	6942                	ld	s2,16(sp)
 9dc:	69a2                	ld	s3,8(sp)
 9de:	6145                	addi	sp,sp,48
 9e0:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 9e2:	00001517          	auipc	a0,0x1
 9e6:	b1e52503          	lw	a0,-1250(a0) # 1500 <max_stacks>
 9ea:	0035151b          	slliw	a0,a0,0x3
 9ee:	00000097          	auipc	ra,0x0
 9f2:	d50080e7          	jalr	-688(ra) # 73e <malloc>
 9f6:	00001797          	auipc	a5,0x1
 9fa:	b2a7b123          	sd	a0,-1246(a5) # 1518 <stacks>
 9fe:	b785                	j	95e <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a00:	00000517          	auipc	a0,0x0
 a04:	09850513          	addi	a0,a0,152 # a98 <ithread_join+0x5a>
 a08:	00000097          	auipc	ra,0x0
 a0c:	c7a080e7          	jalr	-902(ra) # 682 <printf>
      return -1;
 a10:	597d                	li	s2,-1
 a12:	b7c9                	j	9d4 <ithread_create+0x90>
 a14:	ec26                	sd	s1,24(sp)
 a16:	b7bd                	j	984 <ithread_create+0x40>
    free(stack_ptr);
 a18:	8526                	mv	a0,s1
 a1a:	00000097          	auipc	ra,0x0
 a1e:	c9e080e7          	jalr	-866(ra) # 6b8 <free>
    stacks[num_threads] = 0;
 a22:	00001717          	auipc	a4,0x1
 a26:	afe72703          	lw	a4,-1282(a4) # 1520 <num_threads>
 a2a:	070e                	slli	a4,a4,0x3
 a2c:	00001797          	auipc	a5,0x1
 a30:	aec7b783          	ld	a5,-1300(a5) # 1518 <stacks>
 a34:	97ba                	add	a5,a5,a4
 a36:	0007b023          	sd	zero,0(a5)
 a3a:	64e2                	ld	s1,24(sp)
 a3c:	bf61                	j	9d4 <ithread_create+0x90>

0000000000000a3e <ithread_join>:

int ithread_join(int thread_id) {
 a3e:	1101                	addi	sp,sp,-32
 a40:	ec06                	sd	ra,24(sp)
 a42:	e822                	sd	s0,16(sp)
 a44:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a46:	ff040793          	addi	a5,s0,-16
 a4a:	ffc7859b          	addiw	a1,a5,-4
 a4e:	00000097          	auipc	ra,0x0
 a52:	946080e7          	jalr	-1722(ra) # 394 <join_thread>
  threads_done++;
 a56:	00001717          	auipc	a4,0x1
 a5a:	ace70713          	addi	a4,a4,-1330 # 1524 <threads_done>
 a5e:	431c                	lw	a5,0(a4)
 a60:	2785                	addiw	a5,a5,1
 a62:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a64:	00001717          	auipc	a4,0x1
 a68:	abc72703          	lw	a4,-1348(a4) # 1520 <num_threads>
 a6c:	00f70863          	beq	a4,a5,a7c <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 a70:	fec42503          	lw	a0,-20(s0)
 a74:	60e2                	ld	ra,24(sp)
 a76:	6442                	ld	s0,16(sp)
 a78:	6105                	addi	sp,sp,32
 a7a:	8082                	ret
    free_stacks();
 a7c:	00000097          	auipc	ra,0x0
 a80:	dd6080e7          	jalr	-554(ra) # 852 <free_stacks>
 a84:	b7f5                	j	a70 <ithread_join+0x32>
