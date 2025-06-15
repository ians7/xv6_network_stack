
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
   c:	2c2080e7          	jalr	706(ra) # 2ca <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	2bc080e7          	jalr	700(ra) # 2d2 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	342080e7          	jalr	834(ra) # 362 <sleep>
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
  40:	296080e7          	jalr	662(ra) # 2d2 <exit>

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
  a0:	cf91                	beqz	a5,bc <strlen+0x28>
  a2:	00150793          	addi	a5,a0,1
  a6:	86be                	mv	a3,a5
  a8:	0785                	addi	a5,a5,1
  aa:	fff7c703          	lbu	a4,-1(a5)
  ae:	ff65                	bnez	a4,a6 <strlen+0x12>
  b0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret
  for(n = 0; s[n]; n++)
  bc:	4501                	li	a0,0
  be:	bfdd                	j	b4 <strlen+0x20>

00000000000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e406                	sd	ra,8(sp)
  c4:	e022                	sd	s0,0(sp)
  c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  c8:	ca19                	beqz	a2,de <memset+0x1e>
  ca:	87aa                	mv	a5,a0
  cc:	1602                	slli	a2,a2,0x20
  ce:	9201                	srli	a2,a2,0x20
  d0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  d8:	0785                	addi	a5,a5,1
  da:	fee79de3          	bne	a5,a4,d4 <memset+0x14>
  }
  return dst;
}
  de:	60a2                	ld	ra,8(sp)
  e0:	6402                	ld	s0,0(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret

00000000000000e6 <strchr>:

char*
strchr(const char *s, char c)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cf81                	beqz	a5,10a <strchr+0x24>
    if(*s == c)
  f4:	00f58763          	beq	a1,a5,102 <strchr+0x1c>
  for(; *s; s++)
  f8:	0505                	addi	a0,a0,1
  fa:	00054783          	lbu	a5,0(a0)
  fe:	fbfd                	bnez	a5,f4 <strchr+0xe>
      return (char*)s;
  return 0;
 100:	4501                	li	a0,0
}
 102:	60a2                	ld	ra,8(sp)
 104:	6402                	ld	s0,0(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  return 0;
 10a:	4501                	li	a0,0
 10c:	bfdd                	j	102 <strchr+0x1c>

000000000000010e <gets>:

char*
gets(char *buf, int max)
{
 10e:	711d                	addi	sp,sp,-96
 110:	ec86                	sd	ra,88(sp)
 112:	e8a2                	sd	s0,80(sp)
 114:	e4a6                	sd	s1,72(sp)
 116:	e0ca                	sd	s2,64(sp)
 118:	fc4e                	sd	s3,56(sp)
 11a:	f852                	sd	s4,48(sp)
 11c:	f456                	sd	s5,40(sp)
 11e:	f05a                	sd	s6,32(sp)
 120:	ec5e                	sd	s7,24(sp)
 122:	e862                	sd	s8,16(sp)
 124:	1080                	addi	s0,sp,96
 126:	8baa                	mv	s7,a0
 128:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12a:	892a                	mv	s2,a0
 12c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 12e:	faf40b13          	addi	s6,s0,-81
 132:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 134:	8c26                	mv	s8,s1
 136:	0014899b          	addiw	s3,s1,1
 13a:	84ce                	mv	s1,s3
 13c:	0349d663          	bge	s3,s4,168 <gets+0x5a>
    cc = read(0, &c, 1);
 140:	8656                	mv	a2,s5
 142:	85da                	mv	a1,s6
 144:	4501                	li	a0,0
 146:	00000097          	auipc	ra,0x0
 14a:	1a4080e7          	jalr	420(ra) # 2ea <read>
    if(cc < 1)
 14e:	00a05d63          	blez	a0,168 <gets+0x5a>
      break;
    buf[i++] = c;
 152:	faf44783          	lbu	a5,-81(s0)
 156:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15a:	0905                	addi	s2,s2,1
 15c:	ff678713          	addi	a4,a5,-10
 160:	c319                	beqz	a4,166 <gets+0x58>
 162:	17cd                	addi	a5,a5,-13
 164:	fbe1                	bnez	a5,134 <gets+0x26>
    buf[i++] = c;
 166:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 168:	9c5e                	add	s8,s8,s7
 16a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 16e:	855e                	mv	a0,s7
 170:	60e6                	ld	ra,88(sp)
 172:	6446                	ld	s0,80(sp)
 174:	64a6                	ld	s1,72(sp)
 176:	6906                	ld	s2,64(sp)
 178:	79e2                	ld	s3,56(sp)
 17a:	7a42                	ld	s4,48(sp)
 17c:	7aa2                	ld	s5,40(sp)
 17e:	7b02                	ld	s6,32(sp)
 180:	6be2                	ld	s7,24(sp)
 182:	6c42                	ld	s8,16(sp)
 184:	6125                	addi	sp,sp,96
 186:	8082                	ret

0000000000000188 <stat>:

int
stat(const char *n, struct stat *st)
{
 188:	1101                	addi	sp,sp,-32
 18a:	ec06                	sd	ra,24(sp)
 18c:	e822                	sd	s0,16(sp)
 18e:	e04a                	sd	s2,0(sp)
 190:	1000                	addi	s0,sp,32
 192:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	4581                	li	a1,0
 196:	00000097          	auipc	ra,0x0
 19a:	17c080e7          	jalr	380(ra) # 312 <open>
  if(fd < 0)
 19e:	02054663          	bltz	a0,1ca <stat+0x42>
 1a2:	e426                	sd	s1,8(sp)
 1a4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a6:	85ca                	mv	a1,s2
 1a8:	00000097          	auipc	ra,0x0
 1ac:	182080e7          	jalr	386(ra) # 32a <fstat>
 1b0:	892a                	mv	s2,a0
  close(fd);
 1b2:	8526                	mv	a0,s1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	146080e7          	jalr	326(ra) # 2fa <close>
  return r;
 1bc:	64a2                	ld	s1,8(sp)
}
 1be:	854a                	mv	a0,s2
 1c0:	60e2                	ld	ra,24(sp)
 1c2:	6442                	ld	s0,16(sp)
 1c4:	6902                	ld	s2,0(sp)
 1c6:	6105                	addi	sp,sp,32
 1c8:	8082                	ret
    return -1;
 1ca:	57fd                	li	a5,-1
 1cc:	893e                	mv	s2,a5
 1ce:	bfc5                	j	1be <stat+0x36>

00000000000001d0 <atoi>:

int
atoi(const char *s)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e406                	sd	ra,8(sp)
 1d4:	e022                	sd	s0,0(sp)
 1d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d8:	00054683          	lbu	a3,0(a0)
 1dc:	fd06879b          	addiw	a5,a3,-48
 1e0:	0ff7f793          	zext.b	a5,a5
 1e4:	4625                	li	a2,9
 1e6:	02f66963          	bltu	a2,a5,218 <atoi+0x48>
 1ea:	872a                	mv	a4,a0
  n = 0;
 1ec:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ee:	0705                	addi	a4,a4,1
 1f0:	0025179b          	slliw	a5,a0,0x2
 1f4:	9fa9                	addw	a5,a5,a0
 1f6:	0017979b          	slliw	a5,a5,0x1
 1fa:	9fb5                	addw	a5,a5,a3
 1fc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 200:	00074683          	lbu	a3,0(a4)
 204:	fd06879b          	addiw	a5,a3,-48
 208:	0ff7f793          	zext.b	a5,a5
 20c:	fef671e3          	bgeu	a2,a5,1ee <atoi+0x1e>
  return n;
}
 210:	60a2                	ld	ra,8(sp)
 212:	6402                	ld	s0,0(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  n = 0;
 218:	4501                	li	a0,0
 21a:	bfdd                	j	210 <atoi+0x40>

000000000000021c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e406                	sd	ra,8(sp)
 220:	e022                	sd	s0,0(sp)
 222:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 224:	02b57563          	bgeu	a0,a1,24e <memmove+0x32>
    while(n-- > 0)
 228:	00c05f63          	blez	a2,246 <memmove+0x2a>
 22c:	1602                	slli	a2,a2,0x20
 22e:	9201                	srli	a2,a2,0x20
 230:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 234:	872a                	mv	a4,a0
      *dst++ = *src++;
 236:	0585                	addi	a1,a1,1
 238:	0705                	addi	a4,a4,1
 23a:	fff5c683          	lbu	a3,-1(a1)
 23e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 242:	fee79ae3          	bne	a5,a4,236 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 246:	60a2                	ld	ra,8(sp)
 248:	6402                	ld	s0,0(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
    while(n-- > 0)
 24e:	fec05ce3          	blez	a2,246 <memmove+0x2a>
    dst += n;
 252:	00c50733          	add	a4,a0,a2
    src += n;
 256:	95b2                	add	a1,a1,a2
 258:	fff6079b          	addiw	a5,a2,-1
 25c:	1782                	slli	a5,a5,0x20
 25e:	9381                	srli	a5,a5,0x20
 260:	fff7c793          	not	a5,a5
 264:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 266:	15fd                	addi	a1,a1,-1
 268:	177d                	addi	a4,a4,-1
 26a:	0005c683          	lbu	a3,0(a1)
 26e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 272:	fef71ae3          	bne	a4,a5,266 <memmove+0x4a>
 276:	bfc1                	j	246 <memmove+0x2a>

0000000000000278 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 280:	c61d                	beqz	a2,2ae <memcmp+0x36>
 282:	1602                	slli	a2,a2,0x20
 284:	9201                	srli	a2,a2,0x20
 286:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 28a:	00054783          	lbu	a5,0(a0)
 28e:	0005c703          	lbu	a4,0(a1)
 292:	00e79863          	bne	a5,a4,2a2 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 296:	0505                	addi	a0,a0,1
    p2++;
 298:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29a:	fed518e3          	bne	a0,a3,28a <memcmp+0x12>
  }
  return 0;
 29e:	4501                	li	a0,0
 2a0:	a019                	j	2a6 <memcmp+0x2e>
      return *p1 - *p2;
 2a2:	40e7853b          	subw	a0,a5,a4
}
 2a6:	60a2                	ld	ra,8(sp)
 2a8:	6402                	ld	s0,0(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  return 0;
 2ae:	4501                	li	a0,0
 2b0:	bfdd                	j	2a6 <memcmp+0x2e>

00000000000002b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ba:	00000097          	auipc	ra,0x0
 2be:	f62080e7          	jalr	-158(ra) # 21c <memmove>
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret

00000000000002ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ca:	4885                	li	a7,1
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d2:	4889                	li	a7,2
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <wait>:
.global wait
wait:
 li a7, SYS_wait
 2da:	488d                	li	a7,3
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e2:	4891                	li	a7,4
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <read>:
.global read
read:
 li a7, SYS_read
 2ea:	4895                	li	a7,5
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <write>:
.global write
write:
 li a7, SYS_write
 2f2:	48c1                	li	a7,16
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <close>:
.global close
close:
 li a7, SYS_close
 2fa:	48d5                	li	a7,21
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <kill>:
.global kill
kill:
 li a7, SYS_kill
 302:	4899                	li	a7,6
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exec>:
.global exec
exec:
 li a7, SYS_exec
 30a:	489d                	li	a7,7
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <open>:
.global open
open:
 li a7, SYS_open
 312:	48bd                	li	a7,15
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31a:	48c5                	li	a7,17
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 322:	48c9                	li	a7,18
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32a:	48a1                	li	a7,8
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <link>:
.global link
link:
 li a7, SYS_link
 332:	48cd                	li	a7,19
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33a:	48d1                	li	a7,20
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 342:	48a5                	li	a7,9
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <dup>:
.global dup
dup:
 li a7, SYS_dup
 34a:	48a9                	li	a7,10
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 352:	48ad                	li	a7,11
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 35a:	48b1                	li	a7,12
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 362:	48b5                	li	a7,13
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36a:	48b9                	li	a7,14
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 372:	48d9                	li	a7,22
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 37a:	48dd                	li	a7,23
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 382:	48e1                	li	a7,24
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 38a:	48e5                	li	a7,25
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 392:	1101                	addi	sp,sp,-32
 394:	ec06                	sd	ra,24(sp)
 396:	e822                	sd	s0,16(sp)
 398:	1000                	addi	s0,sp,32
 39a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39e:	4605                	li	a2,1
 3a0:	fef40593          	addi	a1,s0,-17
 3a4:	00000097          	auipc	ra,0x0
 3a8:	f4e080e7          	jalr	-178(ra) # 2f2 <write>
}
 3ac:	60e2                	ld	ra,24(sp)
 3ae:	6442                	ld	s0,16(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret

00000000000003b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b4:	7139                	addi	sp,sp,-64
 3b6:	fc06                	sd	ra,56(sp)
 3b8:	f822                	sd	s0,48(sp)
 3ba:	f04a                	sd	s2,32(sp)
 3bc:	ec4e                	sd	s3,24(sp)
 3be:	0080                	addi	s0,sp,64
 3c0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c2:	cad9                	beqz	a3,458 <printint+0xa4>
 3c4:	01f5d79b          	srliw	a5,a1,0x1f
 3c8:	cbc1                	beqz	a5,458 <printint+0xa4>
    neg = 1;
    x = -xx;
 3ca:	40b005bb          	negw	a1,a1
    neg = 1;
 3ce:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3d0:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3d4:	86ce                	mv	a3,s3
  i = 0;
 3d6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d8:	00000817          	auipc	a6,0x0
 3dc:	71880813          	addi	a6,a6,1816 # af0 <digits>
 3e0:	88ba                	mv	a7,a4
 3e2:	0017051b          	addiw	a0,a4,1
 3e6:	872a                	mv	a4,a0
 3e8:	02c5f7bb          	remuw	a5,a1,a2
 3ec:	1782                	slli	a5,a5,0x20
 3ee:	9381                	srli	a5,a5,0x20
 3f0:	97c2                	add	a5,a5,a6
 3f2:	0007c783          	lbu	a5,0(a5)
 3f6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3fa:	87ae                	mv	a5,a1
 3fc:	02c5d5bb          	divuw	a1,a1,a2
 400:	0685                	addi	a3,a3,1
 402:	fcc7ffe3          	bgeu	a5,a2,3e0 <printint+0x2c>
  if(neg)
 406:	00030c63          	beqz	t1,41e <printint+0x6a>
    buf[i++] = '-';
 40a:	fd050793          	addi	a5,a0,-48
 40e:	00878533          	add	a0,a5,s0
 412:	02d00793          	li	a5,45
 416:	fef50823          	sb	a5,-16(a0)
 41a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 41e:	02e05763          	blez	a4,44c <printint+0x98>
 422:	f426                	sd	s1,40(sp)
 424:	377d                	addiw	a4,a4,-1
 426:	00e984b3          	add	s1,s3,a4
 42a:	19fd                	addi	s3,s3,-1
 42c:	99ba                	add	s3,s3,a4
 42e:	1702                	slli	a4,a4,0x20
 430:	9301                	srli	a4,a4,0x20
 432:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 436:	0004c583          	lbu	a1,0(s1)
 43a:	854a                	mv	a0,s2
 43c:	00000097          	auipc	ra,0x0
 440:	f56080e7          	jalr	-170(ra) # 392 <putc>
  while(--i >= 0)
 444:	14fd                	addi	s1,s1,-1
 446:	ff3498e3          	bne	s1,s3,436 <printint+0x82>
 44a:	74a2                	ld	s1,40(sp)
}
 44c:	70e2                	ld	ra,56(sp)
 44e:	7442                	ld	s0,48(sp)
 450:	7902                	ld	s2,32(sp)
 452:	69e2                	ld	s3,24(sp)
 454:	6121                	addi	sp,sp,64
 456:	8082                	ret
  neg = 0;
 458:	4301                	li	t1,0
 45a:	bf9d                	j	3d0 <printint+0x1c>

000000000000045c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45c:	715d                	addi	sp,sp,-80
 45e:	e486                	sd	ra,72(sp)
 460:	e0a2                	sd	s0,64(sp)
 462:	f84a                	sd	s2,48(sp)
 464:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 466:	0005c903          	lbu	s2,0(a1)
 46a:	1a090b63          	beqz	s2,620 <vprintf+0x1c4>
 46e:	fc26                	sd	s1,56(sp)
 470:	f44e                	sd	s3,40(sp)
 472:	f052                	sd	s4,32(sp)
 474:	ec56                	sd	s5,24(sp)
 476:	e85a                	sd	s6,16(sp)
 478:	e45e                	sd	s7,8(sp)
 47a:	8aaa                	mv	s5,a0
 47c:	8bb2                	mv	s7,a2
 47e:	00158493          	addi	s1,a1,1
  state = 0;
 482:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 484:	02500a13          	li	s4,37
 488:	4b55                	li	s6,21
 48a:	a839                	j	4a8 <vprintf+0x4c>
        putc(fd, c);
 48c:	85ca                	mv	a1,s2
 48e:	8556                	mv	a0,s5
 490:	00000097          	auipc	ra,0x0
 494:	f02080e7          	jalr	-254(ra) # 392 <putc>
 498:	a019                	j	49e <vprintf+0x42>
    } else if(state == '%'){
 49a:	01498d63          	beq	s3,s4,4b4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 49e:	0485                	addi	s1,s1,1
 4a0:	fff4c903          	lbu	s2,-1(s1)
 4a4:	16090863          	beqz	s2,614 <vprintf+0x1b8>
    if(state == 0){
 4a8:	fe0999e3          	bnez	s3,49a <vprintf+0x3e>
      if(c == '%'){
 4ac:	ff4910e3          	bne	s2,s4,48c <vprintf+0x30>
        state = '%';
 4b0:	89d2                	mv	s3,s4
 4b2:	b7f5                	j	49e <vprintf+0x42>
      if(c == 'd'){
 4b4:	13490563          	beq	s2,s4,5de <vprintf+0x182>
 4b8:	f9d9079b          	addiw	a5,s2,-99
 4bc:	0ff7f793          	zext.b	a5,a5
 4c0:	12fb6863          	bltu	s6,a5,5f0 <vprintf+0x194>
 4c4:	f9d9079b          	addiw	a5,s2,-99
 4c8:	0ff7f713          	zext.b	a4,a5
 4cc:	12eb6263          	bltu	s6,a4,5f0 <vprintf+0x194>
 4d0:	00271793          	slli	a5,a4,0x2
 4d4:	00000717          	auipc	a4,0x0
 4d8:	5c470713          	addi	a4,a4,1476 # a98 <ithread_join+0x84>
 4dc:	97ba                	add	a5,a5,a4
 4de:	439c                	lw	a5,0(a5)
 4e0:	97ba                	add	a5,a5,a4
 4e2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4e4:	008b8913          	addi	s2,s7,8
 4e8:	4685                	li	a3,1
 4ea:	4629                	li	a2,10
 4ec:	000ba583          	lw	a1,0(s7)
 4f0:	8556                	mv	a0,s5
 4f2:	00000097          	auipc	ra,0x0
 4f6:	ec2080e7          	jalr	-318(ra) # 3b4 <printint>
 4fa:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4fc:	4981                	li	s3,0
 4fe:	b745                	j	49e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 500:	008b8913          	addi	s2,s7,8
 504:	4681                	li	a3,0
 506:	4629                	li	a2,10
 508:	000ba583          	lw	a1,0(s7)
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	ea6080e7          	jalr	-346(ra) # 3b4 <printint>
 516:	8bca                	mv	s7,s2
      state = 0;
 518:	4981                	li	s3,0
 51a:	b751                	j	49e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 51c:	008b8913          	addi	s2,s7,8
 520:	4681                	li	a3,0
 522:	4641                	li	a2,16
 524:	000ba583          	lw	a1,0(s7)
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	e8a080e7          	jalr	-374(ra) # 3b4 <printint>
 532:	8bca                	mv	s7,s2
      state = 0;
 534:	4981                	li	s3,0
 536:	b7a5                	j	49e <vprintf+0x42>
 538:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 53a:	008b8793          	addi	a5,s7,8
 53e:	8c3e                	mv	s8,a5
 540:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 544:	03000593          	li	a1,48
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e48080e7          	jalr	-440(ra) # 392 <putc>
  putc(fd, 'x');
 552:	07800593          	li	a1,120
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	e3a080e7          	jalr	-454(ra) # 392 <putc>
 560:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 562:	00000b97          	auipc	s7,0x0
 566:	58eb8b93          	addi	s7,s7,1422 # af0 <digits>
 56a:	03c9d793          	srli	a5,s3,0x3c
 56e:	97de                	add	a5,a5,s7
 570:	0007c583          	lbu	a1,0(a5)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e1c080e7          	jalr	-484(ra) # 392 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 57e:	0992                	slli	s3,s3,0x4
 580:	397d                	addiw	s2,s2,-1
 582:	fe0914e3          	bnez	s2,56a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 586:	8be2                	mv	s7,s8
      state = 0;
 588:	4981                	li	s3,0
 58a:	6c02                	ld	s8,0(sp)
 58c:	bf09                	j	49e <vprintf+0x42>
        s = va_arg(ap, char*);
 58e:	008b8993          	addi	s3,s7,8
 592:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 596:	02090163          	beqz	s2,5b8 <vprintf+0x15c>
        while(*s != 0){
 59a:	00094583          	lbu	a1,0(s2)
 59e:	c9a5                	beqz	a1,60e <vprintf+0x1b2>
          putc(fd, *s);
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	df0080e7          	jalr	-528(ra) # 392 <putc>
          s++;
 5aa:	0905                	addi	s2,s2,1
        while(*s != 0){
 5ac:	00094583          	lbu	a1,0(s2)
 5b0:	f9e5                	bnez	a1,5a0 <vprintf+0x144>
        s = va_arg(ap, char*);
 5b2:	8bce                	mv	s7,s3
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b5e5                	j	49e <vprintf+0x42>
          s = "(null)";
 5b8:	00000917          	auipc	s2,0x0
 5bc:	4a890913          	addi	s2,s2,1192 # a60 <ithread_join+0x4c>
        while(*s != 0){
 5c0:	02800593          	li	a1,40
 5c4:	bff1                	j	5a0 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 5c6:	008b8913          	addi	s2,s7,8
 5ca:	000bc583          	lbu	a1,0(s7)
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	dc2080e7          	jalr	-574(ra) # 392 <putc>
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b5c9                	j	49e <vprintf+0x42>
        putc(fd, c);
 5de:	02500593          	li	a1,37
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	dae080e7          	jalr	-594(ra) # 392 <putc>
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	bd45                	j	49e <vprintf+0x42>
        putc(fd, '%');
 5f0:	02500593          	li	a1,37
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	d9c080e7          	jalr	-612(ra) # 392 <putc>
        putc(fd, c);
 5fe:	85ca                	mv	a1,s2
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	d90080e7          	jalr	-624(ra) # 392 <putc>
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bd49                	j	49e <vprintf+0x42>
        s = va_arg(ap, char*);
 60e:	8bce                	mv	s7,s3
      state = 0;
 610:	4981                	li	s3,0
 612:	b571                	j	49e <vprintf+0x42>
 614:	74e2                	ld	s1,56(sp)
 616:	79a2                	ld	s3,40(sp)
 618:	7a02                	ld	s4,32(sp)
 61a:	6ae2                	ld	s5,24(sp)
 61c:	6b42                	ld	s6,16(sp)
 61e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 620:	60a6                	ld	ra,72(sp)
 622:	6406                	ld	s0,64(sp)
 624:	7942                	ld	s2,48(sp)
 626:	6161                	addi	sp,sp,80
 628:	8082                	ret

000000000000062a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 62a:	715d                	addi	sp,sp,-80
 62c:	ec06                	sd	ra,24(sp)
 62e:	e822                	sd	s0,16(sp)
 630:	1000                	addi	s0,sp,32
 632:	e010                	sd	a2,0(s0)
 634:	e414                	sd	a3,8(s0)
 636:	e818                	sd	a4,16(s0)
 638:	ec1c                	sd	a5,24(s0)
 63a:	03043023          	sd	a6,32(s0)
 63e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 642:	8622                	mv	a2,s0
 644:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 648:	00000097          	auipc	ra,0x0
 64c:	e14080e7          	jalr	-492(ra) # 45c <vprintf>
}
 650:	60e2                	ld	ra,24(sp)
 652:	6442                	ld	s0,16(sp)
 654:	6161                	addi	sp,sp,80
 656:	8082                	ret

0000000000000658 <printf>:

void
printf(const char *fmt, ...)
{
 658:	711d                	addi	sp,sp,-96
 65a:	ec06                	sd	ra,24(sp)
 65c:	e822                	sd	s0,16(sp)
 65e:	1000                	addi	s0,sp,32
 660:	e40c                	sd	a1,8(s0)
 662:	e810                	sd	a2,16(s0)
 664:	ec14                	sd	a3,24(s0)
 666:	f018                	sd	a4,32(s0)
 668:	f41c                	sd	a5,40(s0)
 66a:	03043823          	sd	a6,48(s0)
 66e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 672:	00840613          	addi	a2,s0,8
 676:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 67a:	85aa                	mv	a1,a0
 67c:	4505                	li	a0,1
 67e:	00000097          	auipc	ra,0x0
 682:	dde080e7          	jalr	-546(ra) # 45c <vprintf>
}
 686:	60e2                	ld	ra,24(sp)
 688:	6442                	ld	s0,16(sp)
 68a:	6125                	addi	sp,sp,96
 68c:	8082                	ret

000000000000068e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68e:	1141                	addi	sp,sp,-16
 690:	e406                	sd	ra,8(sp)
 692:	e022                	sd	s0,0(sp)
 694:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 696:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69a:	00001797          	auipc	a5,0x1
 69e:	e767b783          	ld	a5,-394(a5) # 1510 <freep>
 6a2:	a039                	j	6b0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a4:	6398                	ld	a4,0(a5)
 6a6:	00e7e463          	bltu	a5,a4,6ae <free+0x20>
 6aa:	00e6ea63          	bltu	a3,a4,6be <free+0x30>
{
 6ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b0:	fed7fae3          	bgeu	a5,a3,6a4 <free+0x16>
 6b4:	6398                	ld	a4,0(a5)
 6b6:	00e6e463          	bltu	a3,a4,6be <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ba:	fee7eae3          	bltu	a5,a4,6ae <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6be:	ff852583          	lw	a1,-8(a0)
 6c2:	6390                	ld	a2,0(a5)
 6c4:	02059813          	slli	a6,a1,0x20
 6c8:	01c85713          	srli	a4,a6,0x1c
 6cc:	9736                	add	a4,a4,a3
 6ce:	02e60563          	beq	a2,a4,6f8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6d2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6d6:	4790                	lw	a2,8(a5)
 6d8:	02061593          	slli	a1,a2,0x20
 6dc:	01c5d713          	srli	a4,a1,0x1c
 6e0:	973e                	add	a4,a4,a5
 6e2:	02e68263          	beq	a3,a4,706 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6e6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6e8:	00001717          	auipc	a4,0x1
 6ec:	e2f73423          	sd	a5,-472(a4) # 1510 <freep>
}
 6f0:	60a2                	ld	ra,8(sp)
 6f2:	6402                	ld	s0,0(sp)
 6f4:	0141                	addi	sp,sp,16
 6f6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 6f8:	4618                	lw	a4,8(a2)
 6fa:	9f2d                	addw	a4,a4,a1
 6fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 700:	6398                	ld	a4,0(a5)
 702:	6310                	ld	a2,0(a4)
 704:	b7f9                	j	6d2 <free+0x44>
    p->s.size += bp->s.size;
 706:	ff852703          	lw	a4,-8(a0)
 70a:	9f31                	addw	a4,a4,a2
 70c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 70e:	ff053683          	ld	a3,-16(a0)
 712:	bfd1                	j	6e6 <free+0x58>

0000000000000714 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 714:	7139                	addi	sp,sp,-64
 716:	fc06                	sd	ra,56(sp)
 718:	f822                	sd	s0,48(sp)
 71a:	f04a                	sd	s2,32(sp)
 71c:	ec4e                	sd	s3,24(sp)
 71e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 720:	02051993          	slli	s3,a0,0x20
 724:	0209d993          	srli	s3,s3,0x20
 728:	09bd                	addi	s3,s3,15
 72a:	0049d993          	srli	s3,s3,0x4
 72e:	2985                	addiw	s3,s3,1
 730:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 732:	00001517          	auipc	a0,0x1
 736:	dde53503          	ld	a0,-546(a0) # 1510 <freep>
 73a:	c905                	beqz	a0,76a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 73e:	4798                	lw	a4,8(a5)
 740:	09377a63          	bgeu	a4,s3,7d4 <malloc+0xc0>
 744:	f426                	sd	s1,40(sp)
 746:	e852                	sd	s4,16(sp)
 748:	e456                	sd	s5,8(sp)
 74a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 74c:	8a4e                	mv	s4,s3
 74e:	6705                	lui	a4,0x1
 750:	00e9f363          	bgeu	s3,a4,756 <malloc+0x42>
 754:	6a05                	lui	s4,0x1
 756:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 75a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 75e:	00001497          	auipc	s1,0x1
 762:	db248493          	addi	s1,s1,-590 # 1510 <freep>
  if(p == (char*)-1)
 766:	5afd                	li	s5,-1
 768:	a089                	j	7aa <malloc+0x96>
 76a:	f426                	sd	s1,40(sp)
 76c:	e852                	sd	s4,16(sp)
 76e:	e456                	sd	s5,8(sp)
 770:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 772:	00001797          	auipc	a5,0x1
 776:	dbe78793          	addi	a5,a5,-578 # 1530 <base>
 77a:	00001717          	auipc	a4,0x1
 77e:	d8f73b23          	sd	a5,-618(a4) # 1510 <freep>
 782:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 784:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 788:	b7d1                	j	74c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 78a:	6398                	ld	a4,0(a5)
 78c:	e118                	sd	a4,0(a0)
 78e:	a8b9                	j	7ec <malloc+0xd8>
  hp->s.size = nu;
 790:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 794:	0541                	addi	a0,a0,16
 796:	00000097          	auipc	ra,0x0
 79a:	ef8080e7          	jalr	-264(ra) # 68e <free>
  return freep;
 79e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7a0:	c135                	beqz	a0,804 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a4:	4798                	lw	a4,8(a5)
 7a6:	03277363          	bgeu	a4,s2,7cc <malloc+0xb8>
    if(p == freep)
 7aa:	6098                	ld	a4,0(s1)
 7ac:	853e                	mv	a0,a5
 7ae:	fef71ae3          	bne	a4,a5,7a2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7b2:	8552                	mv	a0,s4
 7b4:	00000097          	auipc	ra,0x0
 7b8:	ba6080e7          	jalr	-1114(ra) # 35a <sbrk>
  if(p == (char*)-1)
 7bc:	fd551ae3          	bne	a0,s5,790 <malloc+0x7c>
        return 0;
 7c0:	4501                	li	a0,0
 7c2:	74a2                	ld	s1,40(sp)
 7c4:	6a42                	ld	s4,16(sp)
 7c6:	6aa2                	ld	s5,8(sp)
 7c8:	6b02                	ld	s6,0(sp)
 7ca:	a03d                	j	7f8 <malloc+0xe4>
 7cc:	74a2                	ld	s1,40(sp)
 7ce:	6a42                	ld	s4,16(sp)
 7d0:	6aa2                	ld	s5,8(sp)
 7d2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7d4:	fae90be3          	beq	s2,a4,78a <malloc+0x76>
        p->s.size -= nunits;
 7d8:	4137073b          	subw	a4,a4,s3
 7dc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7de:	02071693          	slli	a3,a4,0x20
 7e2:	01c6d713          	srli	a4,a3,0x1c
 7e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ec:	00001717          	auipc	a4,0x1
 7f0:	d2a73223          	sd	a0,-732(a4) # 1510 <freep>
      return (void*)(p + 1);
 7f4:	01078513          	addi	a0,a5,16
  }
}
 7f8:	70e2                	ld	ra,56(sp)
 7fa:	7442                	ld	s0,48(sp)
 7fc:	7902                	ld	s2,32(sp)
 7fe:	69e2                	ld	s3,24(sp)
 800:	6121                	addi	sp,sp,64
 802:	8082                	ret
 804:	74a2                	ld	s1,40(sp)
 806:	6a42                	ld	s4,16(sp)
 808:	6aa2                	ld	s5,8(sp)
 80a:	6b02                	ld	s6,0(sp)
 80c:	b7f5                	j	7f8 <malloc+0xe4>

000000000000080e <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 80e:	1141                	addi	sp,sp,-16
 810:	e406                	sd	ra,8(sp)
 812:	e022                	sd	s0,0(sp)
 814:	0800                	addi	s0,sp,16
  thread_exit(status);
 816:	00000097          	auipc	ra,0x0
 81a:	b74080e7          	jalr	-1164(ra) # 38a <thread_exit>
}
 81e:	60a2                	ld	ra,8(sp)
 820:	6402                	ld	s0,0(sp)
 822:	0141                	addi	sp,sp,16
 824:	8082                	ret

0000000000000826 <free_stacks>:
int free_stacks() {
 826:	7179                	addi	sp,sp,-48
 828:	f406                	sd	ra,40(sp)
 82a:	f022                	sd	s0,32(sp)
 82c:	ec26                	sd	s1,24(sp)
 82e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 830:	00001797          	auipc	a5,0x1
 834:	cf07a783          	lw	a5,-784(a5) # 1520 <num_threads>
 838:	04f05063          	blez	a5,878 <free_stacks+0x52>
 83c:	e84a                	sd	s2,16(sp)
 83e:	e44e                	sd	s3,8(sp)
 840:	4481                	li	s1,0
    free(stacks[i]);
 842:	00001997          	auipc	s3,0x1
 846:	cd698993          	addi	s3,s3,-810 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 84a:	00001917          	auipc	s2,0x1
 84e:	cd690913          	addi	s2,s2,-810 # 1520 <num_threads>
    free(stacks[i]);
 852:	0009b783          	ld	a5,0(s3)
 856:	00349713          	slli	a4,s1,0x3
 85a:	97ba                	add	a5,a5,a4
 85c:	6388                	ld	a0,0(a5)
 85e:	00000097          	auipc	ra,0x0
 862:	e30080e7          	jalr	-464(ra) # 68e <free>
  for (int i = 0; i < num_threads; i++) {
 866:	0485                	addi	s1,s1,1
 868:	00092703          	lw	a4,0(s2)
 86c:	0004879b          	sext.w	a5,s1
 870:	fee7c1e3          	blt	a5,a4,852 <free_stacks+0x2c>
 874:	6942                	ld	s2,16(sp)
 876:	69a2                	ld	s3,8(sp)
  free(stacks);
 878:	00001497          	auipc	s1,0x1
 87c:	ca048493          	addi	s1,s1,-864 # 1518 <stacks>
 880:	6088                	ld	a0,0(s1)
 882:	00000097          	auipc	ra,0x0
 886:	e0c080e7          	jalr	-500(ra) # 68e <free>
  stacks = 0;
 88a:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 88e:	00001797          	auipc	a5,0x1
 892:	c807a923          	sw	zero,-878(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 896:	47a1                	li	a5,8
 898:	00001717          	auipc	a4,0x1
 89c:	c6f72423          	sw	a5,-920(a4) # 1500 <max_stacks>
  threads_done = 0;
 8a0:	00001797          	auipc	a5,0x1
 8a4:	c807a223          	sw	zero,-892(a5) # 1524 <threads_done>
}
 8a8:	4501                	li	a0,0
 8aa:	70a2                	ld	ra,40(sp)
 8ac:	7402                	ld	s0,32(sp)
 8ae:	64e2                	ld	s1,24(sp)
 8b0:	6145                	addi	sp,sp,48
 8b2:	8082                	ret

00000000000008b4 <expand_num_threads>:
int expand_num_threads() {
 8b4:	1101                	addi	sp,sp,-32
 8b6:	ec06                	sd	ra,24(sp)
 8b8:	e822                	sd	s0,16(sp)
 8ba:	e426                	sd	s1,8(sp)
 8bc:	e04a                	sd	s2,0(sp)
 8be:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 8c0:	00001797          	auipc	a5,0x1
 8c4:	c4078793          	addi	a5,a5,-960 # 1500 <max_stacks>
 8c8:	4388                	lw	a0,0(a5)
 8ca:	0015151b          	slliw	a0,a0,0x1
 8ce:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 8d0:	0035151b          	slliw	a0,a0,0x3
 8d4:	00000097          	auipc	ra,0x0
 8d8:	e40080e7          	jalr	-448(ra) # 714 <malloc>
 8dc:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 8de:	00001617          	auipc	a2,0x1
 8e2:	c4262603          	lw	a2,-958(a2) # 1520 <num_threads>
 8e6:	00001497          	auipc	s1,0x1
 8ea:	c3248493          	addi	s1,s1,-974 # 1518 <stacks>
 8ee:	0036161b          	slliw	a2,a2,0x3
 8f2:	608c                	ld	a1,0(s1)
 8f4:	00000097          	auipc	ra,0x0
 8f8:	928080e7          	jalr	-1752(ra) # 21c <memmove>
  free(stacks);
 8fc:	6088                	ld	a0,0(s1)
 8fe:	00000097          	auipc	ra,0x0
 902:	d90080e7          	jalr	-624(ra) # 68e <free>
  stacks = new_stacks;
 906:	0124b023          	sd	s2,0(s1)
}
 90a:	4501                	li	a0,0
 90c:	60e2                	ld	ra,24(sp)
 90e:	6442                	ld	s0,16(sp)
 910:	64a2                	ld	s1,8(sp)
 912:	6902                	ld	s2,0(sp)
 914:	6105                	addi	sp,sp,32
 916:	8082                	ret

0000000000000918 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 918:	7179                	addi	sp,sp,-48
 91a:	f406                	sd	ra,40(sp)
 91c:	f022                	sd	s0,32(sp)
 91e:	e84a                	sd	s2,16(sp)
 920:	e44e                	sd	s3,8(sp)
 922:	1800                	addi	s0,sp,48
 924:	892a                	mv	s2,a0
 926:	89ae                	mv	s3,a1
  if (stacks == 0) {
 928:	00001797          	auipc	a5,0x1
 92c:	bf07b783          	ld	a5,-1040(a5) # 1518 <stacks>
 930:	c3d9                	beqz	a5,9b6 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 932:	00001797          	auipc	a5,0x1
 936:	bce7a783          	lw	a5,-1074(a5) # 1500 <max_stacks>
 93a:	00001717          	auipc	a4,0x1
 93e:	be672703          	lw	a4,-1050(a4) # 1520 <num_threads>
 942:	0af71463          	bne	a4,a5,9ea <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 946:	04000713          	li	a4,64
 94a:	08e78563          	beq	a5,a4,9d4 <ithread_create+0xbc>
 94e:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 950:	00000097          	auipc	ra,0x0
 954:	f64080e7          	jalr	-156(ra) # 8b4 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 958:	6505                	lui	a0,0x1
 95a:	00000097          	auipc	ra,0x0
 95e:	dba080e7          	jalr	-582(ra) # 714 <malloc>
 962:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 964:	00001717          	auipc	a4,0x1
 968:	bbc72703          	lw	a4,-1092(a4) # 1520 <num_threads>
 96c:	070e                	slli	a4,a4,0x3
 96e:	00001797          	auipc	a5,0x1
 972:	baa7b783          	ld	a5,-1110(a5) # 1518 <stacks>
 976:	97ba                	add	a5,a5,a4
 978:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 97a:	00000697          	auipc	a3,0x0
 97e:	e9468693          	addi	a3,a3,-364 # 80e <ithread_exit>
 982:	862a                	mv	a2,a0
 984:	85ce                	mv	a1,s3
 986:	854a                	mv	a0,s2
 988:	00000097          	auipc	ra,0x0
 98c:	9f2080e7          	jalr	-1550(ra) # 37a <create_thread>
 990:	892a                	mv	s2,a0
  if (res != -1) {
 992:	57fd                	li	a5,-1
 994:	04f50d63          	beq	a0,a5,9ee <ithread_create+0xd6>
    num_threads++;
 998:	00001717          	auipc	a4,0x1
 99c:	b8870713          	addi	a4,a4,-1144 # 1520 <num_threads>
 9a0:	431c                	lw	a5,0(a4)
 9a2:	2785                	addiw	a5,a5,1
 9a4:	c31c                	sw	a5,0(a4)
 9a6:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 9a8:	854a                	mv	a0,s2
 9aa:	70a2                	ld	ra,40(sp)
 9ac:	7402                	ld	s0,32(sp)
 9ae:	6942                	ld	s2,16(sp)
 9b0:	69a2                	ld	s3,8(sp)
 9b2:	6145                	addi	sp,sp,48
 9b4:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 9b6:	00001517          	auipc	a0,0x1
 9ba:	b4a52503          	lw	a0,-1206(a0) # 1500 <max_stacks>
 9be:	0035151b          	slliw	a0,a0,0x3
 9c2:	00000097          	auipc	ra,0x0
 9c6:	d52080e7          	jalr	-686(ra) # 714 <malloc>
 9ca:	00001797          	auipc	a5,0x1
 9ce:	b4a7b723          	sd	a0,-1202(a5) # 1518 <stacks>
 9d2:	b785                	j	932 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 9d4:	00000517          	auipc	a0,0x0
 9d8:	09450513          	addi	a0,a0,148 # a68 <ithread_join+0x54>
 9dc:	00000097          	auipc	ra,0x0
 9e0:	c7c080e7          	jalr	-900(ra) # 658 <printf>
      return -1;
 9e4:	57fd                	li	a5,-1
 9e6:	893e                	mv	s2,a5
 9e8:	b7c1                	j	9a8 <ithread_create+0x90>
 9ea:	ec26                	sd	s1,24(sp)
 9ec:	b7b5                	j	958 <ithread_create+0x40>
    free(stack_ptr);
 9ee:	8526                	mv	a0,s1
 9f0:	00000097          	auipc	ra,0x0
 9f4:	c9e080e7          	jalr	-866(ra) # 68e <free>
    stacks[num_threads] = 0;
 9f8:	00001717          	auipc	a4,0x1
 9fc:	b2872703          	lw	a4,-1240(a4) # 1520 <num_threads>
 a00:	070e                	slli	a4,a4,0x3
 a02:	00001797          	auipc	a5,0x1
 a06:	b167b783          	ld	a5,-1258(a5) # 1518 <stacks>
 a0a:	97ba                	add	a5,a5,a4
 a0c:	0007b023          	sd	zero,0(a5)
 a10:	64e2                	ld	s1,24(sp)
 a12:	bf59                	j	9a8 <ithread_create+0x90>

0000000000000a14 <ithread_join>:

int ithread_join(int thread_id) {
 a14:	1101                	addi	sp,sp,-32
 a16:	ec06                	sd	ra,24(sp)
 a18:	e822                	sd	s0,16(sp)
 a1a:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a1c:	fec40593          	addi	a1,s0,-20
 a20:	00000097          	auipc	ra,0x0
 a24:	962080e7          	jalr	-1694(ra) # 382 <join_thread>
  threads_done++;
 a28:	00001717          	auipc	a4,0x1
 a2c:	afc70713          	addi	a4,a4,-1284 # 1524 <threads_done>
 a30:	431c                	lw	a5,0(a4)
 a32:	2785                	addiw	a5,a5,1
 a34:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a36:	00001717          	auipc	a4,0x1
 a3a:	aea72703          	lw	a4,-1302(a4) # 1520 <num_threads>
 a3e:	00f70863          	beq	a4,a5,a4e <ithread_join+0x3a>
    free_stacks();
  }
  return status;
}
 a42:	fec42503          	lw	a0,-20(s0)
 a46:	60e2                	ld	ra,24(sp)
 a48:	6442                	ld	s0,16(sp)
 a4a:	6105                	addi	sp,sp,32
 a4c:	8082                	ret
    free_stacks();
 a4e:	00000097          	auipc	ra,0x0
 a52:	dd8080e7          	jalr	-552(ra) # 826 <free_stacks>
 a56:	b7f5                	j	a42 <ithread_join+0x2e>
