
src/user/_zombie:     file format elf64-littleriscv


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
  9c:	86be                	mv	a3,a5
  9e:	0785                	addi	a5,a5,1
  a0:	fff7c703          	lbu	a4,-1(a5)
  a4:	ff65                	bnez	a4,9c <strlen+0x10>
  a6:	40a6853b          	subw	a0,a3,a0
  aa:	2505                	addiw	a0,a0,1
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
    buf[i++] = c;
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
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	addi	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	00000097          	auipc	ra,0x0
 182:	172080e7          	jalr	370(ra) # 2f0 <open>
  if(fd < 0)
 186:	02054663          	bltz	a0,1b2 <stat+0x42>
 18a:	e426                	sd	s1,8(sp)
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
 1a4:	64a2                	ld	s1,8(sp)
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	6902                	ld	s2,0(sp)
 1ae:	6105                	addi	sp,sp,32
 1b0:	8082                	ret
    return -1;
 1b2:	597d                	li	s2,-1
 1b4:	bfcd                	j	1a6 <stat+0x36>

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
 222:	fef71ae3          	bne	a4,a5,216 <memmove+0x18>
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

0000000000000370 <socket>:
.global socket
socket:
 li a7, SYS_socket
 370:	48e9                	li	a7,26
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <bind>:
.global bind
bind:
 li a7, SYS_bind
 378:	48ed                	li	a7,27
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <accept>:
.global accept
accept:
 li a7, SYS_accept
 380:	48f5                	li	a7,29
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <listen>:
.global listen
listen:
 li a7, SYS_listen
 388:	48f1                	li	a7,28
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <connect>:
.global connect
connect:
 li a7, SYS_connect
 390:	48f9                	li	a7,30
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <send>:
.global send
send:
 li a7, SYS_send
 398:	48fd                	li	a7,31
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <recv>:
.global recv
recv:
 li a7, SYS_recv
 3a0:	02000893          	li	a7,32
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 3aa:	02100893          	li	a7,33
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 3b4:	02200893          	li	a7,34
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3be:	1101                	addi	sp,sp,-32
 3c0:	ec06                	sd	ra,24(sp)
 3c2:	e822                	sd	s0,16(sp)
 3c4:	1000                	addi	s0,sp,32
 3c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ca:	4605                	li	a2,1
 3cc:	fef40593          	addi	a1,s0,-17
 3d0:	00000097          	auipc	ra,0x0
 3d4:	f00080e7          	jalr	-256(ra) # 2d0 <write>
}
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6105                	addi	sp,sp,32
 3de:	8082                	ret

00000000000003e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	7139                	addi	sp,sp,-64
 3e2:	fc06                	sd	ra,56(sp)
 3e4:	f822                	sd	s0,48(sp)
 3e6:	f426                	sd	s1,40(sp)
 3e8:	0080                	addi	s0,sp,64
 3ea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ec:	c299                	beqz	a3,3f2 <printint+0x12>
 3ee:	0805cb63          	bltz	a1,484 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f2:	2581                	sext.w	a1,a1
  neg = 0;
 3f4:	4881                	li	a7,0
 3f6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fc:	2601                	sext.w	a2,a2
 3fe:	00000517          	auipc	a0,0x0
 402:	72250513          	addi	a0,a0,1826 # b20 <digits>
 406:	883a                	mv	a6,a4
 408:	2705                	addiw	a4,a4,1
 40a:	02c5f7bb          	remuw	a5,a1,a2
 40e:	1782                	slli	a5,a5,0x20
 410:	9381                	srli	a5,a5,0x20
 412:	97aa                	add	a5,a5,a0
 414:	0007c783          	lbu	a5,0(a5)
 418:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 41c:	0005879b          	sext.w	a5,a1
 420:	02c5d5bb          	divuw	a1,a1,a2
 424:	0685                	addi	a3,a3,1
 426:	fec7f0e3          	bgeu	a5,a2,406 <printint+0x26>
  if(neg)
 42a:	00088c63          	beqz	a7,442 <printint+0x62>
    buf[i++] = '-';
 42e:	fd070793          	addi	a5,a4,-48
 432:	00878733          	add	a4,a5,s0
 436:	02d00793          	li	a5,45
 43a:	fef70823          	sb	a5,-16(a4)
 43e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 442:	02e05c63          	blez	a4,47a <printint+0x9a>
 446:	f04a                	sd	s2,32(sp)
 448:	ec4e                	sd	s3,24(sp)
 44a:	fc040793          	addi	a5,s0,-64
 44e:	00e78933          	add	s2,a5,a4
 452:	fff78993          	addi	s3,a5,-1
 456:	99ba                	add	s3,s3,a4
 458:	377d                	addiw	a4,a4,-1
 45a:	1702                	slli	a4,a4,0x20
 45c:	9301                	srli	a4,a4,0x20
 45e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 462:	fff94583          	lbu	a1,-1(s2)
 466:	8526                	mv	a0,s1
 468:	00000097          	auipc	ra,0x0
 46c:	f56080e7          	jalr	-170(ra) # 3be <putc>
  while(--i >= 0)
 470:	197d                	addi	s2,s2,-1
 472:	ff3918e3          	bne	s2,s3,462 <printint+0x82>
 476:	7902                	ld	s2,32(sp)
 478:	69e2                	ld	s3,24(sp)
}
 47a:	70e2                	ld	ra,56(sp)
 47c:	7442                	ld	s0,48(sp)
 47e:	74a2                	ld	s1,40(sp)
 480:	6121                	addi	sp,sp,64
 482:	8082                	ret
    x = -xx;
 484:	40b005bb          	negw	a1,a1
    neg = 1;
 488:	4885                	li	a7,1
    x = -xx;
 48a:	b7b5                	j	3f6 <printint+0x16>

000000000000048c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48c:	715d                	addi	sp,sp,-80
 48e:	e486                	sd	ra,72(sp)
 490:	e0a2                	sd	s0,64(sp)
 492:	f84a                	sd	s2,48(sp)
 494:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 496:	0005c903          	lbu	s2,0(a1)
 49a:	1a090a63          	beqz	s2,64e <vprintf+0x1c2>
 49e:	fc26                	sd	s1,56(sp)
 4a0:	f44e                	sd	s3,40(sp)
 4a2:	f052                	sd	s4,32(sp)
 4a4:	ec56                	sd	s5,24(sp)
 4a6:	e85a                	sd	s6,16(sp)
 4a8:	e45e                	sd	s7,8(sp)
 4aa:	8aaa                	mv	s5,a0
 4ac:	8bb2                	mv	s7,a2
 4ae:	00158493          	addi	s1,a1,1
  state = 0;
 4b2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b4:	02500a13          	li	s4,37
 4b8:	4b55                	li	s6,21
 4ba:	a839                	j	4d8 <vprintf+0x4c>
        putc(fd, c);
 4bc:	85ca                	mv	a1,s2
 4be:	8556                	mv	a0,s5
 4c0:	00000097          	auipc	ra,0x0
 4c4:	efe080e7          	jalr	-258(ra) # 3be <putc>
 4c8:	a019                	j	4ce <vprintf+0x42>
    } else if(state == '%'){
 4ca:	01498d63          	beq	s3,s4,4e4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4ce:	0485                	addi	s1,s1,1
 4d0:	fff4c903          	lbu	s2,-1(s1)
 4d4:	16090763          	beqz	s2,642 <vprintf+0x1b6>
    if(state == 0){
 4d8:	fe0999e3          	bnez	s3,4ca <vprintf+0x3e>
      if(c == '%'){
 4dc:	ff4910e3          	bne	s2,s4,4bc <vprintf+0x30>
        state = '%';
 4e0:	89d2                	mv	s3,s4
 4e2:	b7f5                	j	4ce <vprintf+0x42>
      if(c == 'd'){
 4e4:	13490463          	beq	s2,s4,60c <vprintf+0x180>
 4e8:	f9d9079b          	addiw	a5,s2,-99
 4ec:	0ff7f793          	zext.b	a5,a5
 4f0:	12fb6763          	bltu	s6,a5,61e <vprintf+0x192>
 4f4:	f9d9079b          	addiw	a5,s2,-99
 4f8:	0ff7f713          	zext.b	a4,a5
 4fc:	12eb6163          	bltu	s6,a4,61e <vprintf+0x192>
 500:	00271793          	slli	a5,a4,0x2
 504:	00000717          	auipc	a4,0x0
 508:	5c470713          	addi	a4,a4,1476 # ac8 <ithread_join+0x84>
 50c:	97ba                	add	a5,a5,a4
 50e:	439c                	lw	a5,0(a5)
 510:	97ba                	add	a5,a5,a4
 512:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 514:	008b8913          	addi	s2,s7,8
 518:	4685                	li	a3,1
 51a:	4629                	li	a2,10
 51c:	000ba583          	lw	a1,0(s7)
 520:	8556                	mv	a0,s5
 522:	00000097          	auipc	ra,0x0
 526:	ebe080e7          	jalr	-322(ra) # 3e0 <printint>
 52a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 52c:	4981                	li	s3,0
 52e:	b745                	j	4ce <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 530:	008b8913          	addi	s2,s7,8
 534:	4681                	li	a3,0
 536:	4629                	li	a2,10
 538:	000ba583          	lw	a1,0(s7)
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	ea2080e7          	jalr	-350(ra) # 3e0 <printint>
 546:	8bca                	mv	s7,s2
      state = 0;
 548:	4981                	li	s3,0
 54a:	b751                	j	4ce <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 54c:	008b8913          	addi	s2,s7,8
 550:	4681                	li	a3,0
 552:	4641                	li	a2,16
 554:	000ba583          	lw	a1,0(s7)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e86080e7          	jalr	-378(ra) # 3e0 <printint>
 562:	8bca                	mv	s7,s2
      state = 0;
 564:	4981                	li	s3,0
 566:	b7a5                	j	4ce <vprintf+0x42>
 568:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 56a:	008b8c13          	addi	s8,s7,8
 56e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 572:	03000593          	li	a1,48
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	e46080e7          	jalr	-442(ra) # 3be <putc>
  putc(fd, 'x');
 580:	07800593          	li	a1,120
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	e38080e7          	jalr	-456(ra) # 3be <putc>
 58e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 590:	00000b97          	auipc	s7,0x0
 594:	590b8b93          	addi	s7,s7,1424 # b20 <digits>
 598:	03c9d793          	srli	a5,s3,0x3c
 59c:	97de                	add	a5,a5,s7
 59e:	0007c583          	lbu	a1,0(a5)
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e1a080e7          	jalr	-486(ra) # 3be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ac:	0992                	slli	s3,s3,0x4
 5ae:	397d                	addiw	s2,s2,-1
 5b0:	fe0914e3          	bnez	s2,598 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5b4:	8be2                	mv	s7,s8
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	6c02                	ld	s8,0(sp)
 5ba:	bf11                	j	4ce <vprintf+0x42>
        s = va_arg(ap, char*);
 5bc:	008b8993          	addi	s3,s7,8
 5c0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5c4:	02090163          	beqz	s2,5e6 <vprintf+0x15a>
        while(*s != 0){
 5c8:	00094583          	lbu	a1,0(s2)
 5cc:	c9a5                	beqz	a1,63c <vprintf+0x1b0>
          putc(fd, *s);
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	dee080e7          	jalr	-530(ra) # 3be <putc>
          s++;
 5d8:	0905                	addi	s2,s2,1
        while(*s != 0){
 5da:	00094583          	lbu	a1,0(s2)
 5de:	f9e5                	bnez	a1,5ce <vprintf+0x142>
        s = va_arg(ap, char*);
 5e0:	8bce                	mv	s7,s3
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b5ed                	j	4ce <vprintf+0x42>
          s = "(null)";
 5e6:	00000917          	auipc	s2,0x0
 5ea:	4aa90913          	addi	s2,s2,1194 # a90 <ithread_join+0x4c>
        while(*s != 0){
 5ee:	02800593          	li	a1,40
 5f2:	bff1                	j	5ce <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5f4:	008b8913          	addi	s2,s7,8
 5f8:	000bc583          	lbu	a1,0(s7)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	dc0080e7          	jalr	-576(ra) # 3be <putc>
 606:	8bca                	mv	s7,s2
      state = 0;
 608:	4981                	li	s3,0
 60a:	b5d1                	j	4ce <vprintf+0x42>
        putc(fd, c);
 60c:	02500593          	li	a1,37
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	dac080e7          	jalr	-596(ra) # 3be <putc>
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bd4d                	j	4ce <vprintf+0x42>
        putc(fd, '%');
 61e:	02500593          	li	a1,37
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	d9a080e7          	jalr	-614(ra) # 3be <putc>
        putc(fd, c);
 62c:	85ca                	mv	a1,s2
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	d8e080e7          	jalr	-626(ra) # 3be <putc>
      state = 0;
 638:	4981                	li	s3,0
 63a:	bd51                	j	4ce <vprintf+0x42>
        s = va_arg(ap, char*);
 63c:	8bce                	mv	s7,s3
      state = 0;
 63e:	4981                	li	s3,0
 640:	b579                	j	4ce <vprintf+0x42>
 642:	74e2                	ld	s1,56(sp)
 644:	79a2                	ld	s3,40(sp)
 646:	7a02                	ld	s4,32(sp)
 648:	6ae2                	ld	s5,24(sp)
 64a:	6b42                	ld	s6,16(sp)
 64c:	6ba2                	ld	s7,8(sp)
    }
  }
}
 64e:	60a6                	ld	ra,72(sp)
 650:	6406                	ld	s0,64(sp)
 652:	7942                	ld	s2,48(sp)
 654:	6161                	addi	sp,sp,80
 656:	8082                	ret

0000000000000658 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 658:	715d                	addi	sp,sp,-80
 65a:	ec06                	sd	ra,24(sp)
 65c:	e822                	sd	s0,16(sp)
 65e:	1000                	addi	s0,sp,32
 660:	e010                	sd	a2,0(s0)
 662:	e414                	sd	a3,8(s0)
 664:	e818                	sd	a4,16(s0)
 666:	ec1c                	sd	a5,24(s0)
 668:	03043023          	sd	a6,32(s0)
 66c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 670:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 674:	8622                	mv	a2,s0
 676:	00000097          	auipc	ra,0x0
 67a:	e16080e7          	jalr	-490(ra) # 48c <vprintf>
}
 67e:	60e2                	ld	ra,24(sp)
 680:	6442                	ld	s0,16(sp)
 682:	6161                	addi	sp,sp,80
 684:	8082                	ret

0000000000000686 <printf>:

void
printf(const char *fmt, ...)
{
 686:	711d                	addi	sp,sp,-96
 688:	ec06                	sd	ra,24(sp)
 68a:	e822                	sd	s0,16(sp)
 68c:	1000                	addi	s0,sp,32
 68e:	e40c                	sd	a1,8(s0)
 690:	e810                	sd	a2,16(s0)
 692:	ec14                	sd	a3,24(s0)
 694:	f018                	sd	a4,32(s0)
 696:	f41c                	sd	a5,40(s0)
 698:	03043823          	sd	a6,48(s0)
 69c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a0:	00840613          	addi	a2,s0,8
 6a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a8:	85aa                	mv	a1,a0
 6aa:	4505                	li	a0,1
 6ac:	00000097          	auipc	ra,0x0
 6b0:	de0080e7          	jalr	-544(ra) # 48c <vprintf>
}
 6b4:	60e2                	ld	ra,24(sp)
 6b6:	6442                	ld	s0,16(sp)
 6b8:	6125                	addi	sp,sp,96
 6ba:	8082                	ret

00000000000006bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6bc:	1141                	addi	sp,sp,-16
 6be:	e422                	sd	s0,8(sp)
 6c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c6:	00001797          	auipc	a5,0x1
 6ca:	94a7b783          	ld	a5,-1718(a5) # 1010 <freep>
 6ce:	a02d                	j	6f8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d0:	4618                	lw	a4,8(a2)
 6d2:	9f2d                	addw	a4,a4,a1
 6d4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d8:	6398                	ld	a4,0(a5)
 6da:	6310                	ld	a2,0(a4)
 6dc:	a83d                	j	71a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6de:	ff852703          	lw	a4,-8(a0)
 6e2:	9f31                	addw	a4,a4,a2
 6e4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6e6:	ff053683          	ld	a3,-16(a0)
 6ea:	a091                	j	72e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ec:	6398                	ld	a4,0(a5)
 6ee:	00e7e463          	bltu	a5,a4,6f6 <free+0x3a>
 6f2:	00e6ea63          	bltu	a3,a4,706 <free+0x4a>
{
 6f6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f8:	fed7fae3          	bgeu	a5,a3,6ec <free+0x30>
 6fc:	6398                	ld	a4,0(a5)
 6fe:	00e6e463          	bltu	a3,a4,706 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 702:	fee7eae3          	bltu	a5,a4,6f6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 706:	ff852583          	lw	a1,-8(a0)
 70a:	6390                	ld	a2,0(a5)
 70c:	02059813          	slli	a6,a1,0x20
 710:	01c85713          	srli	a4,a6,0x1c
 714:	9736                	add	a4,a4,a3
 716:	fae60de3          	beq	a2,a4,6d0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 71a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 71e:	4790                	lw	a2,8(a5)
 720:	02061593          	slli	a1,a2,0x20
 724:	01c5d713          	srli	a4,a1,0x1c
 728:	973e                	add	a4,a4,a5
 72a:	fae68ae3          	beq	a3,a4,6de <free+0x22>
    p->s.ptr = bp->s.ptr;
 72e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 730:	00001717          	auipc	a4,0x1
 734:	8ef73023          	sd	a5,-1824(a4) # 1010 <freep>
}
 738:	6422                	ld	s0,8(sp)
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
 744:	f426                	sd	s1,40(sp)
 746:	ec4e                	sd	s3,24(sp)
 748:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74a:	02051493          	slli	s1,a0,0x20
 74e:	9081                	srli	s1,s1,0x20
 750:	04bd                	addi	s1,s1,15
 752:	8091                	srli	s1,s1,0x4
 754:	0014899b          	addiw	s3,s1,1
 758:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 75a:	00001517          	auipc	a0,0x1
 75e:	8b653503          	ld	a0,-1866(a0) # 1010 <freep>
 762:	c915                	beqz	a0,796 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 764:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 766:	4798                	lw	a4,8(a5)
 768:	08977e63          	bgeu	a4,s1,804 <malloc+0xc6>
 76c:	f04a                	sd	s2,32(sp)
 76e:	e852                	sd	s4,16(sp)
 770:	e456                	sd	s5,8(sp)
 772:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 774:	8a4e                	mv	s4,s3
 776:	0009871b          	sext.w	a4,s3
 77a:	6685                	lui	a3,0x1
 77c:	00d77363          	bgeu	a4,a3,782 <malloc+0x44>
 780:	6a05                	lui	s4,0x1
 782:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 786:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 78a:	00001917          	auipc	s2,0x1
 78e:	88690913          	addi	s2,s2,-1914 # 1010 <freep>
  if(p == (char*)-1)
 792:	5afd                	li	s5,-1
 794:	a091                	j	7d8 <malloc+0x9a>
 796:	f04a                	sd	s2,32(sp)
 798:	e852                	sd	s4,16(sp)
 79a:	e456                	sd	s5,8(sp)
 79c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 79e:	00001797          	auipc	a5,0x1
 7a2:	89278793          	addi	a5,a5,-1902 # 1030 <base>
 7a6:	00001717          	auipc	a4,0x1
 7aa:	86f73523          	sd	a5,-1942(a4) # 1010 <freep>
 7ae:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7b0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7b4:	b7c1                	j	774 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7b6:	6398                	ld	a4,0(a5)
 7b8:	e118                	sd	a4,0(a0)
 7ba:	a08d                	j	81c <malloc+0xde>
  hp->s.size = nu;
 7bc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7c0:	0541                	addi	a0,a0,16
 7c2:	00000097          	auipc	ra,0x0
 7c6:	efa080e7          	jalr	-262(ra) # 6bc <free>
  return freep;
 7ca:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ce:	c13d                	beqz	a0,834 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d2:	4798                	lw	a4,8(a5)
 7d4:	02977463          	bgeu	a4,s1,7fc <malloc+0xbe>
    if(p == freep)
 7d8:	00093703          	ld	a4,0(s2)
 7dc:	853e                	mv	a0,a5
 7de:	fef719e3          	bne	a4,a5,7d0 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 7e2:	8552                	mv	a0,s4
 7e4:	00000097          	auipc	ra,0x0
 7e8:	b54080e7          	jalr	-1196(ra) # 338 <sbrk>
  if(p == (char*)-1)
 7ec:	fd5518e3          	bne	a0,s5,7bc <malloc+0x7e>
        return 0;
 7f0:	4501                	li	a0,0
 7f2:	7902                	ld	s2,32(sp)
 7f4:	6a42                	ld	s4,16(sp)
 7f6:	6aa2                	ld	s5,8(sp)
 7f8:	6b02                	ld	s6,0(sp)
 7fa:	a03d                	j	828 <malloc+0xea>
 7fc:	7902                	ld	s2,32(sp)
 7fe:	6a42                	ld	s4,16(sp)
 800:	6aa2                	ld	s5,8(sp)
 802:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 804:	fae489e3          	beq	s1,a4,7b6 <malloc+0x78>
        p->s.size -= nunits;
 808:	4137073b          	subw	a4,a4,s3
 80c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 80e:	02071693          	slli	a3,a4,0x20
 812:	01c6d713          	srli	a4,a3,0x1c
 816:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 818:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 81c:	00000717          	auipc	a4,0x0
 820:	7ea73a23          	sd	a0,2036(a4) # 1010 <freep>
      return (void*)(p + 1);
 824:	01078513          	addi	a0,a5,16
  }
}
 828:	70e2                	ld	ra,56(sp)
 82a:	7442                	ld	s0,48(sp)
 82c:	74a2                	ld	s1,40(sp)
 82e:	69e2                	ld	s3,24(sp)
 830:	6121                	addi	sp,sp,64
 832:	8082                	ret
 834:	7902                	ld	s2,32(sp)
 836:	6a42                	ld	s4,16(sp)
 838:	6aa2                	ld	s5,8(sp)
 83a:	6b02                	ld	s6,0(sp)
 83c:	b7f5                	j	828 <malloc+0xea>

000000000000083e <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 83e:	1141                	addi	sp,sp,-16
 840:	e406                	sd	ra,8(sp)
 842:	e022                	sd	s0,0(sp)
 844:	0800                	addi	s0,sp,16
  thread_exit(status);
 846:	2501                	sext.w	a0,a0
 848:	00000097          	auipc	ra,0x0
 84c:	b20080e7          	jalr	-1248(ra) # 368 <thread_exit>
}
 850:	60a2                	ld	ra,8(sp)
 852:	6402                	ld	s0,0(sp)
 854:	0141                	addi	sp,sp,16
 856:	8082                	ret

0000000000000858 <free_stacks>:
int free_stacks() {
 858:	7179                	addi	sp,sp,-48
 85a:	f406                	sd	ra,40(sp)
 85c:	f022                	sd	s0,32(sp)
 85e:	ec26                	sd	s1,24(sp)
 860:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 862:	00000797          	auipc	a5,0x0
 866:	7be7a783          	lw	a5,1982(a5) # 1020 <num_threads>
 86a:	04f05063          	blez	a5,8aa <free_stacks+0x52>
 86e:	e84a                	sd	s2,16(sp)
 870:	e44e                	sd	s3,8(sp)
 872:	4481                	li	s1,0
    free(stacks[i]);
 874:	00000997          	auipc	s3,0x0
 878:	7a498993          	addi	s3,s3,1956 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 87c:	00000917          	auipc	s2,0x0
 880:	7a490913          	addi	s2,s2,1956 # 1020 <num_threads>
    free(stacks[i]);
 884:	0009b783          	ld	a5,0(s3)
 888:	00349713          	slli	a4,s1,0x3
 88c:	97ba                	add	a5,a5,a4
 88e:	6388                	ld	a0,0(a5)
 890:	00000097          	auipc	ra,0x0
 894:	e2c080e7          	jalr	-468(ra) # 6bc <free>
  for (int i = 0; i < num_threads; i++) {
 898:	0485                	addi	s1,s1,1
 89a:	00092703          	lw	a4,0(s2)
 89e:	0004879b          	sext.w	a5,s1
 8a2:	fee7c1e3          	blt	a5,a4,884 <free_stacks+0x2c>
 8a6:	6942                	ld	s2,16(sp)
 8a8:	69a2                	ld	s3,8(sp)
  free(stacks);
 8aa:	00000497          	auipc	s1,0x0
 8ae:	76e48493          	addi	s1,s1,1902 # 1018 <stacks>
 8b2:	6088                	ld	a0,0(s1)
 8b4:	00000097          	auipc	ra,0x0
 8b8:	e08080e7          	jalr	-504(ra) # 6bc <free>
  stacks = 0;
 8bc:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8c0:	00000797          	auipc	a5,0x0
 8c4:	7607a023          	sw	zero,1888(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8c8:	47a1                	li	a5,8
 8ca:	00000717          	auipc	a4,0x0
 8ce:	72f72b23          	sw	a5,1846(a4) # 1000 <max_stacks>
  threads_done = 0;
 8d2:	00000797          	auipc	a5,0x0
 8d6:	7407a923          	sw	zero,1874(a5) # 1024 <threads_done>
}
 8da:	4501                	li	a0,0
 8dc:	70a2                	ld	ra,40(sp)
 8de:	7402                	ld	s0,32(sp)
 8e0:	64e2                	ld	s1,24(sp)
 8e2:	6145                	addi	sp,sp,48
 8e4:	8082                	ret

00000000000008e6 <expand_num_threads>:
int expand_num_threads() {
 8e6:	1101                	addi	sp,sp,-32
 8e8:	ec06                	sd	ra,24(sp)
 8ea:	e822                	sd	s0,16(sp)
 8ec:	e426                	sd	s1,8(sp)
 8ee:	e04a                	sd	s2,0(sp)
 8f0:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 8f2:	00000797          	auipc	a5,0x0
 8f6:	70e78793          	addi	a5,a5,1806 # 1000 <max_stacks>
 8fa:	4388                	lw	a0,0(a5)
 8fc:	0015151b          	slliw	a0,a0,0x1
 900:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 902:	0035151b          	slliw	a0,a0,0x3
 906:	00000097          	auipc	ra,0x0
 90a:	e38080e7          	jalr	-456(ra) # 73e <malloc>
 90e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 910:	00000617          	auipc	a2,0x0
 914:	71062603          	lw	a2,1808(a2) # 1020 <num_threads>
 918:	00000497          	auipc	s1,0x0
 91c:	70048493          	addi	s1,s1,1792 # 1018 <stacks>
 920:	0036161b          	slliw	a2,a2,0x3
 924:	608c                	ld	a1,0(s1)
 926:	00000097          	auipc	ra,0x0
 92a:	8d8080e7          	jalr	-1832(ra) # 1fe <memmove>
  free(stacks);
 92e:	6088                	ld	a0,0(s1)
 930:	00000097          	auipc	ra,0x0
 934:	d8c080e7          	jalr	-628(ra) # 6bc <free>
  stacks = new_stacks;
 938:	0124b023          	sd	s2,0(s1)
}
 93c:	4501                	li	a0,0
 93e:	60e2                	ld	ra,24(sp)
 940:	6442                	ld	s0,16(sp)
 942:	64a2                	ld	s1,8(sp)
 944:	6902                	ld	s2,0(sp)
 946:	6105                	addi	sp,sp,32
 948:	8082                	ret

000000000000094a <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 94a:	7179                	addi	sp,sp,-48
 94c:	f406                	sd	ra,40(sp)
 94e:	f022                	sd	s0,32(sp)
 950:	e84a                	sd	s2,16(sp)
 952:	e44e                	sd	s3,8(sp)
 954:	1800                	addi	s0,sp,48
 956:	892a                	mv	s2,a0
 958:	89ae                	mv	s3,a1
  if (stacks == 0) {
 95a:	00000797          	auipc	a5,0x0
 95e:	6be7b783          	ld	a5,1726(a5) # 1018 <stacks>
 962:	c3d9                	beqz	a5,9e8 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 964:	00000797          	auipc	a5,0x0
 968:	69c7a783          	lw	a5,1692(a5) # 1000 <max_stacks>
 96c:	00000717          	auipc	a4,0x0
 970:	6b472703          	lw	a4,1716(a4) # 1020 <num_threads>
 974:	0af71363          	bne	a4,a5,a1a <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 978:	04000713          	li	a4,64
 97c:	08e78563          	beq	a5,a4,a06 <ithread_create+0xbc>
 980:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 982:	00000097          	auipc	ra,0x0
 986:	f64080e7          	jalr	-156(ra) # 8e6 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 98a:	6505                	lui	a0,0x1
 98c:	00000097          	auipc	ra,0x0
 990:	db2080e7          	jalr	-590(ra) # 73e <malloc>
 994:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 996:	00000717          	auipc	a4,0x0
 99a:	68a72703          	lw	a4,1674(a4) # 1020 <num_threads>
 99e:	070e                	slli	a4,a4,0x3
 9a0:	00000797          	auipc	a5,0x0
 9a4:	6787b783          	ld	a5,1656(a5) # 1018 <stacks>
 9a8:	97ba                	add	a5,a5,a4
 9aa:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9ac:	00000697          	auipc	a3,0x0
 9b0:	e9268693          	addi	a3,a3,-366 # 83e <ithread_exit>
 9b4:	862a                	mv	a2,a0
 9b6:	85ce                	mv	a1,s3
 9b8:	854a                	mv	a0,s2
 9ba:	00000097          	auipc	ra,0x0
 9be:	99e080e7          	jalr	-1634(ra) # 358 <create_thread>
 9c2:	892a                	mv	s2,a0
  if (res != -1) {
 9c4:	57fd                	li	a5,-1
 9c6:	04f50c63          	beq	a0,a5,a1e <ithread_create+0xd4>
    num_threads++;
 9ca:	00000717          	auipc	a4,0x0
 9ce:	65670713          	addi	a4,a4,1622 # 1020 <num_threads>
 9d2:	431c                	lw	a5,0(a4)
 9d4:	2785                	addiw	a5,a5,1
 9d6:	c31c                	sw	a5,0(a4)
 9d8:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 9da:	854a                	mv	a0,s2
 9dc:	70a2                	ld	ra,40(sp)
 9de:	7402                	ld	s0,32(sp)
 9e0:	6942                	ld	s2,16(sp)
 9e2:	69a2                	ld	s3,8(sp)
 9e4:	6145                	addi	sp,sp,48
 9e6:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 9e8:	00000517          	auipc	a0,0x0
 9ec:	61852503          	lw	a0,1560(a0) # 1000 <max_stacks>
 9f0:	0035151b          	slliw	a0,a0,0x3
 9f4:	00000097          	auipc	ra,0x0
 9f8:	d4a080e7          	jalr	-694(ra) # 73e <malloc>
 9fc:	00000797          	auipc	a5,0x0
 a00:	60a7be23          	sd	a0,1564(a5) # 1018 <stacks>
 a04:	b785                	j	964 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a06:	00000517          	auipc	a0,0x0
 a0a:	09250513          	addi	a0,a0,146 # a98 <ithread_join+0x54>
 a0e:	00000097          	auipc	ra,0x0
 a12:	c78080e7          	jalr	-904(ra) # 686 <printf>
      return -1;
 a16:	597d                	li	s2,-1
 a18:	b7c9                	j	9da <ithread_create+0x90>
 a1a:	ec26                	sd	s1,24(sp)
 a1c:	b7bd                	j	98a <ithread_create+0x40>
    free(stack_ptr);
 a1e:	8526                	mv	a0,s1
 a20:	00000097          	auipc	ra,0x0
 a24:	c9c080e7          	jalr	-868(ra) # 6bc <free>
    stacks[num_threads] = 0;
 a28:	00000717          	auipc	a4,0x0
 a2c:	5f872703          	lw	a4,1528(a4) # 1020 <num_threads>
 a30:	070e                	slli	a4,a4,0x3
 a32:	00000797          	auipc	a5,0x0
 a36:	5e67b783          	ld	a5,1510(a5) # 1018 <stacks>
 a3a:	97ba                	add	a5,a5,a4
 a3c:	0007b023          	sd	zero,0(a5)
 a40:	64e2                	ld	s1,24(sp)
 a42:	bf61                	j	9da <ithread_create+0x90>

0000000000000a44 <ithread_join>:

int ithread_join(int thread_id) {
 a44:	1101                	addi	sp,sp,-32
 a46:	ec06                	sd	ra,24(sp)
 a48:	e822                	sd	s0,16(sp)
 a4a:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a4c:	ff040793          	addi	a5,s0,-16
 a50:	ffc7859b          	addiw	a1,a5,-4
 a54:	00000097          	auipc	ra,0x0
 a58:	90c080e7          	jalr	-1780(ra) # 360 <join_thread>
  threads_done++;
 a5c:	00000717          	auipc	a4,0x0
 a60:	5c870713          	addi	a4,a4,1480 # 1024 <threads_done>
 a64:	431c                	lw	a5,0(a4)
 a66:	2785                	addiw	a5,a5,1
 a68:	0007869b          	sext.w	a3,a5
 a6c:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a6e:	00000797          	auipc	a5,0x0
 a72:	5b27a783          	lw	a5,1458(a5) # 1020 <num_threads>
 a76:	00d78863          	beq	a5,a3,a86 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 a7a:	fec42503          	lw	a0,-20(s0)
 a7e:	60e2                	ld	ra,24(sp)
 a80:	6442                	ld	s0,16(sp)
 a82:	6105                	addi	sp,sp,32
 a84:	8082                	ret
    free_stacks();
 a86:	00000097          	auipc	ra,0x0
 a8a:	dd2080e7          	jalr	-558(ra) # 858 <free_stacks>
 a8e:	b7f5                	j	a7a <ithread_join+0x36>
