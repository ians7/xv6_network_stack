
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
   c:	2a0080e7          	jalr	672(ra) # 2a8 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	29a080e7          	jalr	666(ra) # 2b0 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	320080e7          	jalr	800(ra) # 340 <sleep>
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
  40:	274080e7          	jalr	628(ra) # 2b0 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
    ;
  return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
    p++, q++;
  74:	0505                	addi	a0,a0,1
  76:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	addi	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	4685                	li	a3,1
  9e:	9e89                	subw	a3,a3,a0
  a0:	00f6853b          	addw	a0,a3,a5
  a4:	0785                	addi	a5,a5,1
  a6:	fff7c703          	lbu	a4,-1(a5)
  aa:	fb7d                	bnez	a4,a0 <strlen+0x14>
    ;
  return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret
  for(n = 0; s[n]; n++)
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	slli	a2,a2,0x20
  c2:	9201                	srli	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  cc:	0785                	addi	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
  }
  return dst;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
    if(*s == c)
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
  for(; *s; s++)
  e8:	0505                	addi	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
      return (char*)s;
  return 0;
  f0:	4501                	li	a0,0
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	711d                	addi	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11e:	89a6                	mv	s3,s1
 120:	2485                	addiw	s1,s1,1
 122:	0344d863          	bge	s1,s4,152 <gets+0x56>
    cc = read(0, &c, 1);
 126:	4605                	li	a2,1
 128:	faf40593          	addi	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	19a080e7          	jalr	410(ra) # 2c8 <read>
    if(cc < 1)
 136:	00a05e63          	blez	a0,152 <gets+0x56>
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 142:	01578763          	beq	a5,s5,150 <gets+0x54>
 146:	0905                	addi	s2,s2,1
 148:	fd679be3          	bne	a5,s6,11e <gets+0x22>
  for(i=0; i+1 < max; ){
 14c:	89a6                	mv	s3,s1
 14e:	a011                	j	152 <gets+0x56>
 150:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 152:	99de                	add	s3,s3,s7
 154:	00098023          	sb	zero,0(s3)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6125                	addi	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e426                	sd	s1,8(sp)
 178:	e04a                	sd	s2,0(sp)
 17a:	1000                	addi	s0,sp,32
 17c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17e:	4581                	li	a1,0
 180:	00000097          	auipc	ra,0x0
 184:	170080e7          	jalr	368(ra) # 2f0 <open>
  if(fd < 0)
 188:	02054563          	bltz	a0,1b2 <stat+0x42>
 18c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	00000097          	auipc	ra,0x0
 194:	178080e7          	jalr	376(ra) # 308 <fstat>
 198:	892a                	mv	s2,a0
  close(fd);
 19a:	8526                	mv	a0,s1
 19c:	00000097          	auipc	ra,0x0
 1a0:	13c080e7          	jalr	316(ra) # 2d8 <close>
  return r;
}
 1a4:	854a                	mv	a0,s2
 1a6:	60e2                	ld	ra,24(sp)
 1a8:	6442                	ld	s0,16(sp)
 1aa:	64a2                	ld	s1,8(sp)
 1ac:	6902                	ld	s2,0(sp)
 1ae:	6105                	addi	sp,sp,32
 1b0:	8082                	ret
    return -1;
 1b2:	597d                	li	s2,-1
 1b4:	bfc5                	j	1a4 <stat+0x34>

00000000000001b6 <atoi>:

int
atoi(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1bc:	00054683          	lbu	a3,0(a0)
 1c0:	fd06879b          	addiw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	4625                	li	a2,9
 1ca:	02f66863          	bltu	a2,a5,1fa <atoi+0x44>
 1ce:	872a                	mv	a4,a0
  n = 0;
 1d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d2:	0705                	addi	a4,a4,1
 1d4:	0025179b          	slliw	a5,a0,0x2
 1d8:	9fa9                	addw	a5,a5,a0
 1da:	0017979b          	slliw	a5,a5,0x1
 1de:	9fb5                	addw	a5,a5,a3
 1e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e4:	00074683          	lbu	a3,0(a4)
 1e8:	fd06879b          	addiw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	fef671e3          	bgeu	a2,a5,1d2 <atoi+0x1c>
  return n;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
  n = 0;
 1fa:	4501                	li	a0,0
 1fc:	bfe5                	j	1f4 <atoi+0x3e>

00000000000001fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 204:	02b57463          	bgeu	a0,a1,22c <memmove+0x2e>
    while(n-- > 0)
 208:	00c05f63          	blez	a2,226 <memmove+0x28>
 20c:	1602                	slli	a2,a2,0x20
 20e:	9201                	srli	a2,a2,0x20
 210:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 214:	872a                	mv	a4,a0
      *dst++ = *src++;
 216:	0585                	addi	a1,a1,1
 218:	0705                	addi	a4,a4,1
 21a:	fff5c683          	lbu	a3,-1(a1)
 21e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 222:	fee79ae3          	bne	a5,a4,216 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 232:	fec05ae3          	blez	a2,226 <memmove+0x28>
 236:	fff6079b          	addiw	a5,a2,-1
 23a:	1782                	slli	a5,a5,0x20
 23c:	9381                	srli	a5,a5,0x20
 23e:	fff7c793          	not	a5,a5
 242:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 244:	15fd                	addi	a1,a1,-1
 246:	177d                	addi	a4,a4,-1
 248:	0005c683          	lbu	a3,0(a1)
 24c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x46>
 254:	bfc9                	j	226 <memmove+0x28>

0000000000000256 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	ca05                	beqz	a2,28c <memcmp+0x36>
 25e:	fff6069b          	addiw	a3,a2,-1
 262:	1682                	slli	a3,a3,0x20
 264:	9281                	srli	a3,a3,0x20
 266:	0685                	addi	a3,a3,1
 268:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79863          	bne	a5,a4,282 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 276:	0505                	addi	a0,a0,1
    p2++;
 278:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x14>
  }
  return 0;
 27e:	4501                	li	a0,0
 280:	a019                	j	286 <memcmp+0x30>
      return *p1 - *p2;
 282:	40e7853b          	subw	a0,a5,a4
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <memcmp+0x30>

0000000000000290 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 298:	00000097          	auipc	ra,0x0
 29c:	f66080e7          	jalr	-154(ra) # 1fe <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a8:	4885                	li	a7,1
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b0:	4889                	li	a7,2
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b8:	488d                	li	a7,3
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c0:	4891                	li	a7,4
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <read>:
.global read
read:
 li a7, SYS_read
 2c8:	4895                	li	a7,5
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <write>:
.global write
write:
 li a7, SYS_write
 2d0:	48c1                	li	a7,16
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <close>:
.global close
close:
 li a7, SYS_close
 2d8:	48d5                	li	a7,21
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e0:	4899                	li	a7,6
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e8:	489d                	li	a7,7
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <open>:
.global open
open:
 li a7, SYS_open
 2f0:	48bd                	li	a7,15
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f8:	48c5                	li	a7,17
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 300:	48c9                	li	a7,18
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 308:	48a1                	li	a7,8
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <link>:
.global link
link:
 li a7, SYS_link
 310:	48cd                	li	a7,19
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 318:	48d1                	li	a7,20
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 320:	48a5                	li	a7,9
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <dup>:
.global dup
dup:
 li a7, SYS_dup
 328:	48a9                	li	a7,10
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 330:	48ad                	li	a7,11
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 338:	48b1                	li	a7,12
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 340:	48b5                	li	a7,13
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 348:	48b9                	li	a7,14
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 350:	48d9                	li	a7,22
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 358:	48dd                	li	a7,23
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 360:	48e1                	li	a7,24
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 368:	48e5                	li	a7,25
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 370:	1101                	addi	sp,sp,-32
 372:	ec06                	sd	ra,24(sp)
 374:	e822                	sd	s0,16(sp)
 376:	1000                	addi	s0,sp,32
 378:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 37c:	4605                	li	a2,1
 37e:	fef40593          	addi	a1,s0,-17
 382:	00000097          	auipc	ra,0x0
 386:	f4e080e7          	jalr	-178(ra) # 2d0 <write>
}
 38a:	60e2                	ld	ra,24(sp)
 38c:	6442                	ld	s0,16(sp)
 38e:	6105                	addi	sp,sp,32
 390:	8082                	ret

0000000000000392 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 392:	7139                	addi	sp,sp,-64
 394:	fc06                	sd	ra,56(sp)
 396:	f822                	sd	s0,48(sp)
 398:	f426                	sd	s1,40(sp)
 39a:	f04a                	sd	s2,32(sp)
 39c:	ec4e                	sd	s3,24(sp)
 39e:	0080                	addi	s0,sp,64
 3a0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a2:	c299                	beqz	a3,3a8 <printint+0x16>
 3a4:	0805c963          	bltz	a1,436 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a8:	2581                	sext.w	a1,a1
  neg = 0;
 3aa:	4881                	li	a7,0
 3ac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3b0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b2:	2601                	sext.w	a2,a2
 3b4:	00000517          	auipc	a0,0x0
 3b8:	6dc50513          	addi	a0,a0,1756 # a90 <digits>
 3bc:	883a                	mv	a6,a4
 3be:	2705                	addiw	a4,a4,1
 3c0:	02c5f7bb          	remuw	a5,a1,a2
 3c4:	1782                	slli	a5,a5,0x20
 3c6:	9381                	srli	a5,a5,0x20
 3c8:	97aa                	add	a5,a5,a0
 3ca:	0007c783          	lbu	a5,0(a5)
 3ce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d2:	0005879b          	sext.w	a5,a1
 3d6:	02c5d5bb          	divuw	a1,a1,a2
 3da:	0685                	addi	a3,a3,1
 3dc:	fec7f0e3          	bgeu	a5,a2,3bc <printint+0x2a>
  if(neg)
 3e0:	00088c63          	beqz	a7,3f8 <printint+0x66>
    buf[i++] = '-';
 3e4:	fd070793          	addi	a5,a4,-48
 3e8:	00878733          	add	a4,a5,s0
 3ec:	02d00793          	li	a5,45
 3f0:	fef70823          	sb	a5,-16(a4)
 3f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3f8:	02e05863          	blez	a4,428 <printint+0x96>
 3fc:	fc040793          	addi	a5,s0,-64
 400:	00e78933          	add	s2,a5,a4
 404:	fff78993          	addi	s3,a5,-1
 408:	99ba                	add	s3,s3,a4
 40a:	377d                	addiw	a4,a4,-1
 40c:	1702                	slli	a4,a4,0x20
 40e:	9301                	srli	a4,a4,0x20
 410:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 414:	fff94583          	lbu	a1,-1(s2)
 418:	8526                	mv	a0,s1
 41a:	00000097          	auipc	ra,0x0
 41e:	f56080e7          	jalr	-170(ra) # 370 <putc>
  while(--i >= 0)
 422:	197d                	addi	s2,s2,-1
 424:	ff3918e3          	bne	s2,s3,414 <printint+0x82>
}
 428:	70e2                	ld	ra,56(sp)
 42a:	7442                	ld	s0,48(sp)
 42c:	74a2                	ld	s1,40(sp)
 42e:	7902                	ld	s2,32(sp)
 430:	69e2                	ld	s3,24(sp)
 432:	6121                	addi	sp,sp,64
 434:	8082                	ret
    x = -xx;
 436:	40b005bb          	negw	a1,a1
    neg = 1;
 43a:	4885                	li	a7,1
    x = -xx;
 43c:	bf85                	j	3ac <printint+0x1a>

000000000000043e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 43e:	7119                	addi	sp,sp,-128
 440:	fc86                	sd	ra,120(sp)
 442:	f8a2                	sd	s0,112(sp)
 444:	f4a6                	sd	s1,104(sp)
 446:	f0ca                	sd	s2,96(sp)
 448:	ecce                	sd	s3,88(sp)
 44a:	e8d2                	sd	s4,80(sp)
 44c:	e4d6                	sd	s5,72(sp)
 44e:	e0da                	sd	s6,64(sp)
 450:	fc5e                	sd	s7,56(sp)
 452:	f862                	sd	s8,48(sp)
 454:	f466                	sd	s9,40(sp)
 456:	f06a                	sd	s10,32(sp)
 458:	ec6e                	sd	s11,24(sp)
 45a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45c:	0005c903          	lbu	s2,0(a1)
 460:	18090f63          	beqz	s2,5fe <vprintf+0x1c0>
 464:	8aaa                	mv	s5,a0
 466:	8b32                	mv	s6,a2
 468:	00158493          	addi	s1,a1,1
  state = 0;
 46c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 46e:	02500a13          	li	s4,37
 472:	4c55                	li	s8,21
 474:	00000c97          	auipc	s9,0x0
 478:	5c4c8c93          	addi	s9,s9,1476 # a38 <ithread_join+0x52>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 47c:	02800d93          	li	s11,40
  putc(fd, 'x');
 480:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 482:	00000b97          	auipc	s7,0x0
 486:	60eb8b93          	addi	s7,s7,1550 # a90 <digits>
 48a:	a839                	j	4a8 <vprintf+0x6a>
        putc(fd, c);
 48c:	85ca                	mv	a1,s2
 48e:	8556                	mv	a0,s5
 490:	00000097          	auipc	ra,0x0
 494:	ee0080e7          	jalr	-288(ra) # 370 <putc>
 498:	a019                	j	49e <vprintf+0x60>
    } else if(state == '%'){
 49a:	01498d63          	beq	s3,s4,4b4 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 49e:	0485                	addi	s1,s1,1
 4a0:	fff4c903          	lbu	s2,-1(s1)
 4a4:	14090d63          	beqz	s2,5fe <vprintf+0x1c0>
    if(state == 0){
 4a8:	fe0999e3          	bnez	s3,49a <vprintf+0x5c>
      if(c == '%'){
 4ac:	ff4910e3          	bne	s2,s4,48c <vprintf+0x4e>
        state = '%';
 4b0:	89d2                	mv	s3,s4
 4b2:	b7f5                	j	49e <vprintf+0x60>
      if(c == 'd'){
 4b4:	11490c63          	beq	s2,s4,5cc <vprintf+0x18e>
 4b8:	f9d9079b          	addiw	a5,s2,-99
 4bc:	0ff7f793          	zext.b	a5,a5
 4c0:	10fc6e63          	bltu	s8,a5,5dc <vprintf+0x19e>
 4c4:	f9d9079b          	addiw	a5,s2,-99
 4c8:	0ff7f713          	zext.b	a4,a5
 4cc:	10ec6863          	bltu	s8,a4,5dc <vprintf+0x19e>
 4d0:	00271793          	slli	a5,a4,0x2
 4d4:	97e6                	add	a5,a5,s9
 4d6:	439c                	lw	a5,0(a5)
 4d8:	97e6                	add	a5,a5,s9
 4da:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4dc:	008b0913          	addi	s2,s6,8
 4e0:	4685                	li	a3,1
 4e2:	4629                	li	a2,10
 4e4:	000b2583          	lw	a1,0(s6)
 4e8:	8556                	mv	a0,s5
 4ea:	00000097          	auipc	ra,0x0
 4ee:	ea8080e7          	jalr	-344(ra) # 392 <printint>
 4f2:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	b765                	j	49e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f8:	008b0913          	addi	s2,s6,8
 4fc:	4681                	li	a3,0
 4fe:	4629                	li	a2,10
 500:	000b2583          	lw	a1,0(s6)
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	e8c080e7          	jalr	-372(ra) # 392 <printint>
 50e:	8b4a                	mv	s6,s2
      state = 0;
 510:	4981                	li	s3,0
 512:	b771                	j	49e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 514:	008b0913          	addi	s2,s6,8
 518:	4681                	li	a3,0
 51a:	866a                	mv	a2,s10
 51c:	000b2583          	lw	a1,0(s6)
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	e70080e7          	jalr	-400(ra) # 392 <printint>
 52a:	8b4a                	mv	s6,s2
      state = 0;
 52c:	4981                	li	s3,0
 52e:	bf85                	j	49e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 530:	008b0793          	addi	a5,s6,8
 534:	f8f43423          	sd	a5,-120(s0)
 538:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 53c:	03000593          	li	a1,48
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e2e080e7          	jalr	-466(ra) # 370 <putc>
  putc(fd, 'x');
 54a:	07800593          	li	a1,120
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e20080e7          	jalr	-480(ra) # 370 <putc>
 558:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55a:	03c9d793          	srli	a5,s3,0x3c
 55e:	97de                	add	a5,a5,s7
 560:	0007c583          	lbu	a1,0(a5)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e0a080e7          	jalr	-502(ra) # 370 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 56e:	0992                	slli	s3,s3,0x4
 570:	397d                	addiw	s2,s2,-1
 572:	fe0914e3          	bnez	s2,55a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 576:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 57a:	4981                	li	s3,0
 57c:	b70d                	j	49e <vprintf+0x60>
        s = va_arg(ap, char*);
 57e:	008b0913          	addi	s2,s6,8
 582:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 586:	02098163          	beqz	s3,5a8 <vprintf+0x16a>
        while(*s != 0){
 58a:	0009c583          	lbu	a1,0(s3)
 58e:	c5ad                	beqz	a1,5f8 <vprintf+0x1ba>
          putc(fd, *s);
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	dde080e7          	jalr	-546(ra) # 370 <putc>
          s++;
 59a:	0985                	addi	s3,s3,1
        while(*s != 0){
 59c:	0009c583          	lbu	a1,0(s3)
 5a0:	f9e5                	bnez	a1,590 <vprintf+0x152>
        s = va_arg(ap, char*);
 5a2:	8b4a                	mv	s6,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bde5                	j	49e <vprintf+0x60>
          s = "(null)";
 5a8:	00000997          	auipc	s3,0x0
 5ac:	48898993          	addi	s3,s3,1160 # a30 <ithread_join+0x4a>
        while(*s != 0){
 5b0:	85ee                	mv	a1,s11
 5b2:	bff9                	j	590 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5b4:	008b0913          	addi	s2,s6,8
 5b8:	000b4583          	lbu	a1,0(s6)
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	db2080e7          	jalr	-590(ra) # 370 <putc>
 5c6:	8b4a                	mv	s6,s2
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bdd1                	j	49e <vprintf+0x60>
        putc(fd, c);
 5cc:	85d2                	mv	a1,s4
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	da0080e7          	jalr	-608(ra) # 370 <putc>
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b5d1                	j	49e <vprintf+0x60>
        putc(fd, '%');
 5dc:	85d2                	mv	a1,s4
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	d90080e7          	jalr	-624(ra) # 370 <putc>
        putc(fd, c);
 5e8:	85ca                	mv	a1,s2
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	d84080e7          	jalr	-636(ra) # 370 <putc>
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b565                	j	49e <vprintf+0x60>
        s = va_arg(ap, char*);
 5f8:	8b4a                	mv	s6,s2
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b54d                	j	49e <vprintf+0x60>
    }
  }
}
 5fe:	70e6                	ld	ra,120(sp)
 600:	7446                	ld	s0,112(sp)
 602:	74a6                	ld	s1,104(sp)
 604:	7906                	ld	s2,96(sp)
 606:	69e6                	ld	s3,88(sp)
 608:	6a46                	ld	s4,80(sp)
 60a:	6aa6                	ld	s5,72(sp)
 60c:	6b06                	ld	s6,64(sp)
 60e:	7be2                	ld	s7,56(sp)
 610:	7c42                	ld	s8,48(sp)
 612:	7ca2                	ld	s9,40(sp)
 614:	7d02                	ld	s10,32(sp)
 616:	6de2                	ld	s11,24(sp)
 618:	6109                	addi	sp,sp,128
 61a:	8082                	ret

000000000000061c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 61c:	715d                	addi	sp,sp,-80
 61e:	ec06                	sd	ra,24(sp)
 620:	e822                	sd	s0,16(sp)
 622:	1000                	addi	s0,sp,32
 624:	e010                	sd	a2,0(s0)
 626:	e414                	sd	a3,8(s0)
 628:	e818                	sd	a4,16(s0)
 62a:	ec1c                	sd	a5,24(s0)
 62c:	03043023          	sd	a6,32(s0)
 630:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 634:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 638:	8622                	mv	a2,s0
 63a:	00000097          	auipc	ra,0x0
 63e:	e04080e7          	jalr	-508(ra) # 43e <vprintf>
}
 642:	60e2                	ld	ra,24(sp)
 644:	6442                	ld	s0,16(sp)
 646:	6161                	addi	sp,sp,80
 648:	8082                	ret

000000000000064a <printf>:

void
printf(const char *fmt, ...)
{
 64a:	711d                	addi	sp,sp,-96
 64c:	ec06                	sd	ra,24(sp)
 64e:	e822                	sd	s0,16(sp)
 650:	1000                	addi	s0,sp,32
 652:	e40c                	sd	a1,8(s0)
 654:	e810                	sd	a2,16(s0)
 656:	ec14                	sd	a3,24(s0)
 658:	f018                	sd	a4,32(s0)
 65a:	f41c                	sd	a5,40(s0)
 65c:	03043823          	sd	a6,48(s0)
 660:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 664:	00840613          	addi	a2,s0,8
 668:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 66c:	85aa                	mv	a1,a0
 66e:	4505                	li	a0,1
 670:	00000097          	auipc	ra,0x0
 674:	dce080e7          	jalr	-562(ra) # 43e <vprintf>
}
 678:	60e2                	ld	ra,24(sp)
 67a:	6442                	ld	s0,16(sp)
 67c:	6125                	addi	sp,sp,96
 67e:	8082                	ret

0000000000000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	1141                	addi	sp,sp,-16
 682:	e422                	sd	s0,8(sp)
 684:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 686:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68a:	00001797          	auipc	a5,0x1
 68e:	9867b783          	ld	a5,-1658(a5) # 1010 <freep>
 692:	a02d                	j	6bc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 694:	4618                	lw	a4,8(a2)
 696:	9f2d                	addw	a4,a4,a1
 698:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 69c:	6398                	ld	a4,0(a5)
 69e:	6310                	ld	a2,0(a4)
 6a0:	a83d                	j	6de <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6a2:	ff852703          	lw	a4,-8(a0)
 6a6:	9f31                	addw	a4,a4,a2
 6a8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6aa:	ff053683          	ld	a3,-16(a0)
 6ae:	a091                	j	6f2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b0:	6398                	ld	a4,0(a5)
 6b2:	00e7e463          	bltu	a5,a4,6ba <free+0x3a>
 6b6:	00e6ea63          	bltu	a3,a4,6ca <free+0x4a>
{
 6ba:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bc:	fed7fae3          	bgeu	a5,a3,6b0 <free+0x30>
 6c0:	6398                	ld	a4,0(a5)
 6c2:	00e6e463          	bltu	a3,a4,6ca <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c6:	fee7eae3          	bltu	a5,a4,6ba <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6ca:	ff852583          	lw	a1,-8(a0)
 6ce:	6390                	ld	a2,0(a5)
 6d0:	02059813          	slli	a6,a1,0x20
 6d4:	01c85713          	srli	a4,a6,0x1c
 6d8:	9736                	add	a4,a4,a3
 6da:	fae60de3          	beq	a2,a4,694 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6de:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6e2:	4790                	lw	a2,8(a5)
 6e4:	02061593          	slli	a1,a2,0x20
 6e8:	01c5d713          	srli	a4,a1,0x1c
 6ec:	973e                	add	a4,a4,a5
 6ee:	fae68ae3          	beq	a3,a4,6a2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6f2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6f4:	00001717          	auipc	a4,0x1
 6f8:	90f73e23          	sd	a5,-1764(a4) # 1010 <freep>
}
 6fc:	6422                	ld	s0,8(sp)
 6fe:	0141                	addi	sp,sp,16
 700:	8082                	ret

0000000000000702 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 702:	7139                	addi	sp,sp,-64
 704:	fc06                	sd	ra,56(sp)
 706:	f822                	sd	s0,48(sp)
 708:	f426                	sd	s1,40(sp)
 70a:	f04a                	sd	s2,32(sp)
 70c:	ec4e                	sd	s3,24(sp)
 70e:	e852                	sd	s4,16(sp)
 710:	e456                	sd	s5,8(sp)
 712:	e05a                	sd	s6,0(sp)
 714:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 716:	02051493          	slli	s1,a0,0x20
 71a:	9081                	srli	s1,s1,0x20
 71c:	04bd                	addi	s1,s1,15
 71e:	8091                	srli	s1,s1,0x4
 720:	0014899b          	addiw	s3,s1,1
 724:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 726:	00001517          	auipc	a0,0x1
 72a:	8ea53503          	ld	a0,-1814(a0) # 1010 <freep>
 72e:	c515                	beqz	a0,75a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 730:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 732:	4798                	lw	a4,8(a5)
 734:	02977f63          	bgeu	a4,s1,772 <malloc+0x70>
 738:	8a4e                	mv	s4,s3
 73a:	0009871b          	sext.w	a4,s3
 73e:	6685                	lui	a3,0x1
 740:	00d77363          	bgeu	a4,a3,746 <malloc+0x44>
 744:	6a05                	lui	s4,0x1
 746:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 74a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 74e:	00001917          	auipc	s2,0x1
 752:	8c290913          	addi	s2,s2,-1854 # 1010 <freep>
  if(p == (char*)-1)
 756:	5afd                	li	s5,-1
 758:	a895                	j	7cc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 75a:	00001797          	auipc	a5,0x1
 75e:	8d678793          	addi	a5,a5,-1834 # 1030 <base>
 762:	00001717          	auipc	a4,0x1
 766:	8af73723          	sd	a5,-1874(a4) # 1010 <freep>
 76a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 76c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 770:	b7e1                	j	738 <malloc+0x36>
      if(p->s.size == nunits)
 772:	02e48c63          	beq	s1,a4,7aa <malloc+0xa8>
        p->s.size -= nunits;
 776:	4137073b          	subw	a4,a4,s3
 77a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 77c:	02071693          	slli	a3,a4,0x20
 780:	01c6d713          	srli	a4,a3,0x1c
 784:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 786:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 78a:	00001717          	auipc	a4,0x1
 78e:	88a73323          	sd	a0,-1914(a4) # 1010 <freep>
      return (void*)(p + 1);
 792:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 796:	70e2                	ld	ra,56(sp)
 798:	7442                	ld	s0,48(sp)
 79a:	74a2                	ld	s1,40(sp)
 79c:	7902                	ld	s2,32(sp)
 79e:	69e2                	ld	s3,24(sp)
 7a0:	6a42                	ld	s4,16(sp)
 7a2:	6aa2                	ld	s5,8(sp)
 7a4:	6b02                	ld	s6,0(sp)
 7a6:	6121                	addi	sp,sp,64
 7a8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7aa:	6398                	ld	a4,0(a5)
 7ac:	e118                	sd	a4,0(a0)
 7ae:	bff1                	j	78a <malloc+0x88>
  hp->s.size = nu;
 7b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7b4:	0541                	addi	a0,a0,16
 7b6:	00000097          	auipc	ra,0x0
 7ba:	eca080e7          	jalr	-310(ra) # 680 <free>
  return freep;
 7be:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7c2:	d971                	beqz	a0,796 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c6:	4798                	lw	a4,8(a5)
 7c8:	fa9775e3          	bgeu	a4,s1,772 <malloc+0x70>
    if(p == freep)
 7cc:	00093703          	ld	a4,0(s2)
 7d0:	853e                	mv	a0,a5
 7d2:	fef719e3          	bne	a4,a5,7c4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7d6:	8552                	mv	a0,s4
 7d8:	00000097          	auipc	ra,0x0
 7dc:	b60080e7          	jalr	-1184(ra) # 338 <sbrk>
  if(p == (char*)-1)
 7e0:	fd5518e3          	bne	a0,s5,7b0 <malloc+0xae>
        return 0;
 7e4:	4501                	li	a0,0
 7e6:	bf45                	j	796 <malloc+0x94>

00000000000007e8 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 7e8:	1141                	addi	sp,sp,-16
 7ea:	e406                	sd	ra,8(sp)
 7ec:	e022                	sd	s0,0(sp)
 7ee:	0800                	addi	s0,sp,16
  thread_exit(status);
 7f0:	00000097          	auipc	ra,0x0
 7f4:	b78080e7          	jalr	-1160(ra) # 368 <thread_exit>
}
 7f8:	60a2                	ld	ra,8(sp)
 7fa:	6402                	ld	s0,0(sp)
 7fc:	0141                	addi	sp,sp,16
 7fe:	8082                	ret

0000000000000800 <free_stacks>:
int free_stacks() {
 800:	7179                	addi	sp,sp,-48
 802:	f406                	sd	ra,40(sp)
 804:	f022                	sd	s0,32(sp)
 806:	ec26                	sd	s1,24(sp)
 808:	e84a                	sd	s2,16(sp)
 80a:	e44e                	sd	s3,8(sp)
 80c:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 80e:	00001797          	auipc	a5,0x1
 812:	8127a783          	lw	a5,-2030(a5) # 1020 <num_threads>
 816:	02f05c63          	blez	a5,84e <free_stacks+0x4e>
 81a:	4481                	li	s1,0
    free(stacks[i]);
 81c:	00000997          	auipc	s3,0x0
 820:	7fc98993          	addi	s3,s3,2044 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 824:	00000917          	auipc	s2,0x0
 828:	7fc90913          	addi	s2,s2,2044 # 1020 <num_threads>
    free(stacks[i]);
 82c:	0009b783          	ld	a5,0(s3)
 830:	00349713          	slli	a4,s1,0x3
 834:	97ba                	add	a5,a5,a4
 836:	6388                	ld	a0,0(a5)
 838:	00000097          	auipc	ra,0x0
 83c:	e48080e7          	jalr	-440(ra) # 680 <free>
  for (int i = 0; i < num_threads; i++) {
 840:	0485                	addi	s1,s1,1
 842:	00092703          	lw	a4,0(s2)
 846:	0004879b          	sext.w	a5,s1
 84a:	fee7c1e3          	blt	a5,a4,82c <free_stacks+0x2c>
  free(stacks);
 84e:	00000497          	auipc	s1,0x0
 852:	7ca48493          	addi	s1,s1,1994 # 1018 <stacks>
 856:	6088                	ld	a0,0(s1)
 858:	00000097          	auipc	ra,0x0
 85c:	e28080e7          	jalr	-472(ra) # 680 <free>
  stacks = 0;
 860:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 864:	00000797          	auipc	a5,0x0
 868:	7a07ae23          	sw	zero,1980(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 86c:	47a1                	li	a5,8
 86e:	00000717          	auipc	a4,0x0
 872:	78f72923          	sw	a5,1938(a4) # 1000 <max_stacks>
  threads_done = 0;
 876:	00000797          	auipc	a5,0x0
 87a:	7a07a723          	sw	zero,1966(a5) # 1024 <threads_done>
}
 87e:	4501                	li	a0,0
 880:	70a2                	ld	ra,40(sp)
 882:	7402                	ld	s0,32(sp)
 884:	64e2                	ld	s1,24(sp)
 886:	6942                	ld	s2,16(sp)
 888:	69a2                	ld	s3,8(sp)
 88a:	6145                	addi	sp,sp,48
 88c:	8082                	ret

000000000000088e <expand_num_threads>:
int expand_num_threads() {
 88e:	1101                	addi	sp,sp,-32
 890:	ec06                	sd	ra,24(sp)
 892:	e822                	sd	s0,16(sp)
 894:	e426                	sd	s1,8(sp)
 896:	e04a                	sd	s2,0(sp)
 898:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 89a:	00000797          	auipc	a5,0x0
 89e:	76678793          	addi	a5,a5,1894 # 1000 <max_stacks>
 8a2:	4388                	lw	a0,0(a5)
 8a4:	0015151b          	slliw	a0,a0,0x1
 8a8:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 8aa:	0035151b          	slliw	a0,a0,0x3
 8ae:	00000097          	auipc	ra,0x0
 8b2:	e54080e7          	jalr	-428(ra) # 702 <malloc>
 8b6:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 8b8:	00000617          	auipc	a2,0x0
 8bc:	76862603          	lw	a2,1896(a2) # 1020 <num_threads>
 8c0:	00000497          	auipc	s1,0x0
 8c4:	75848493          	addi	s1,s1,1880 # 1018 <stacks>
 8c8:	0036161b          	slliw	a2,a2,0x3
 8cc:	608c                	ld	a1,0(s1)
 8ce:	00000097          	auipc	ra,0x0
 8d2:	930080e7          	jalr	-1744(ra) # 1fe <memmove>
  free(stacks);
 8d6:	6088                	ld	a0,0(s1)
 8d8:	00000097          	auipc	ra,0x0
 8dc:	da8080e7          	jalr	-600(ra) # 680 <free>
  stacks = new_stacks;
 8e0:	0124b023          	sd	s2,0(s1)
}
 8e4:	4501                	li	a0,0
 8e6:	60e2                	ld	ra,24(sp)
 8e8:	6442                	ld	s0,16(sp)
 8ea:	64a2                	ld	s1,8(sp)
 8ec:	6902                	ld	s2,0(sp)
 8ee:	6105                	addi	sp,sp,32
 8f0:	8082                	ret

00000000000008f2 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 8f2:	7179                	addi	sp,sp,-48
 8f4:	f406                	sd	ra,40(sp)
 8f6:	f022                	sd	s0,32(sp)
 8f8:	ec26                	sd	s1,24(sp)
 8fa:	e84a                	sd	s2,16(sp)
 8fc:	e44e                	sd	s3,8(sp)
 8fe:	1800                	addi	s0,sp,48
 900:	892a                	mv	s2,a0
 902:	89ae                	mv	s3,a1
  if (stacks == 0) {
 904:	00000797          	auipc	a5,0x0
 908:	7147b783          	ld	a5,1812(a5) # 1018 <stacks>
 90c:	c3d1                	beqz	a5,990 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 90e:	00000797          	auipc	a5,0x0
 912:	6f27a783          	lw	a5,1778(a5) # 1000 <max_stacks>
 916:	00000717          	auipc	a4,0x0
 91a:	70a72703          	lw	a4,1802(a4) # 1020 <num_threads>
 91e:	00f71a63          	bne	a4,a5,932 <ithread_create+0x40>
    if (max_stacks == MAX_THREADS) {
 922:	04000713          	li	a4,64
 926:	08e78463          	beq	a5,a4,9ae <ithread_create+0xbc>
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 92a:	00000097          	auipc	ra,0x0
 92e:	f64080e7          	jalr	-156(ra) # 88e <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 932:	6505                	lui	a0,0x1
 934:	00000097          	auipc	ra,0x0
 938:	dce080e7          	jalr	-562(ra) # 702 <malloc>
 93c:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 93e:	00000717          	auipc	a4,0x0
 942:	6e272703          	lw	a4,1762(a4) # 1020 <num_threads>
 946:	070e                	slli	a4,a4,0x3
 948:	00000797          	auipc	a5,0x0
 94c:	6d07b783          	ld	a5,1744(a5) # 1018 <stacks>
 950:	97ba                	add	a5,a5,a4
 952:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 954:	00000697          	auipc	a3,0x0
 958:	e9468693          	addi	a3,a3,-364 # 7e8 <ithread_exit>
 95c:	862a                	mv	a2,a0
 95e:	85ce                	mv	a1,s3
 960:	854a                	mv	a0,s2
 962:	00000097          	auipc	ra,0x0
 966:	9f6080e7          	jalr	-1546(ra) # 358 <create_thread>
 96a:	892a                	mv	s2,a0
  if (res != -1) {
 96c:	57fd                	li	a5,-1
 96e:	04f50a63          	beq	a0,a5,9c2 <ithread_create+0xd0>
    num_threads++;
 972:	00000717          	auipc	a4,0x0
 976:	6ae70713          	addi	a4,a4,1710 # 1020 <num_threads>
 97a:	431c                	lw	a5,0(a4)
 97c:	2785                	addiw	a5,a5,1
 97e:	c31c                	sw	a5,0(a4)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 980:	854a                	mv	a0,s2
 982:	70a2                	ld	ra,40(sp)
 984:	7402                	ld	s0,32(sp)
 986:	64e2                	ld	s1,24(sp)
 988:	6942                	ld	s2,16(sp)
 98a:	69a2                	ld	s3,8(sp)
 98c:	6145                	addi	sp,sp,48
 98e:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 990:	00000517          	auipc	a0,0x0
 994:	67052503          	lw	a0,1648(a0) # 1000 <max_stacks>
 998:	0035151b          	slliw	a0,a0,0x3
 99c:	00000097          	auipc	ra,0x0
 9a0:	d66080e7          	jalr	-666(ra) # 702 <malloc>
 9a4:	00000797          	auipc	a5,0x0
 9a8:	66a7ba23          	sd	a0,1652(a5) # 1018 <stacks>
 9ac:	b78d                	j	90e <ithread_create+0x1c>
      printf("ERROR: Thread capacity has been reached\n");
 9ae:	00000517          	auipc	a0,0x0
 9b2:	0fa50513          	addi	a0,a0,250 # aa8 <digits+0x18>
 9b6:	00000097          	auipc	ra,0x0
 9ba:	c94080e7          	jalr	-876(ra) # 64a <printf>
      return -1;
 9be:	597d                	li	s2,-1
 9c0:	b7c1                	j	980 <ithread_create+0x8e>
    free(stack_ptr);
 9c2:	8526                	mv	a0,s1
 9c4:	00000097          	auipc	ra,0x0
 9c8:	cbc080e7          	jalr	-836(ra) # 680 <free>
    stacks[num_threads] = 0;
 9cc:	00000717          	auipc	a4,0x0
 9d0:	65472703          	lw	a4,1620(a4) # 1020 <num_threads>
 9d4:	070e                	slli	a4,a4,0x3
 9d6:	00000797          	auipc	a5,0x0
 9da:	6427b783          	ld	a5,1602(a5) # 1018 <stacks>
 9de:	97ba                	add	a5,a5,a4
 9e0:	0007b023          	sd	zero,0(a5)
 9e4:	bf71                	j	980 <ithread_create+0x8e>

00000000000009e6 <ithread_join>:

int ithread_join(int thread_id) {
 9e6:	1101                	addi	sp,sp,-32
 9e8:	ec06                	sd	ra,24(sp)
 9ea:	e822                	sd	s0,16(sp)
 9ec:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 9ee:	fec40593          	addi	a1,s0,-20
 9f2:	00000097          	auipc	ra,0x0
 9f6:	96e080e7          	jalr	-1682(ra) # 360 <join_thread>
  threads_done++;
 9fa:	00000717          	auipc	a4,0x0
 9fe:	62a70713          	addi	a4,a4,1578 # 1024 <threads_done>
 a02:	431c                	lw	a5,0(a4)
 a04:	2785                	addiw	a5,a5,1
 a06:	0007869b          	sext.w	a3,a5
 a0a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a0c:	00000797          	auipc	a5,0x0
 a10:	6147a783          	lw	a5,1556(a5) # 1020 <num_threads>
 a14:	00d78863          	beq	a5,a3,a24 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 a18:	fec42503          	lw	a0,-20(s0)
 a1c:	60e2                	ld	ra,24(sp)
 a1e:	6442                	ld	s0,16(sp)
 a20:	6105                	addi	sp,sp,32
 a22:	8082                	ret
    free_stacks();
 a24:	00000097          	auipc	ra,0x0
 a28:	ddc080e7          	jalr	-548(ra) # 800 <free_stacks>
 a2c:	b7f5                	j	a18 <ithread_join+0x32>
