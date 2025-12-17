
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

0000000000000392 <socket>:
.global socket
socket:
 li a7, SYS_socket
 392:	48e9                	li	a7,26
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <bind>:
.global bind
bind:
 li a7, SYS_bind
 39a:	48ed                	li	a7,27
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3a2:	48f5                	li	a7,29
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <listen>:
.global listen
listen:
 li a7, SYS_listen
 3aa:	48f1                	li	a7,28
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3b2:	48f9                	li	a7,30
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <send>:
.global send
send:
 li a7, SYS_send
 3ba:	48fd                	li	a7,31
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <recv>:
.global recv
recv:
 li a7, SYS_recv
 3c2:	02000893          	li	a7,32
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 3cc:	02100893          	li	a7,33
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 3d6:	02200893          	li	a7,34
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e0:	1101                	addi	sp,sp,-32
 3e2:	ec06                	sd	ra,24(sp)
 3e4:	e822                	sd	s0,16(sp)
 3e6:	1000                	addi	s0,sp,32
 3e8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ec:	4605                	li	a2,1
 3ee:	fef40593          	addi	a1,s0,-17
 3f2:	00000097          	auipc	ra,0x0
 3f6:	f00080e7          	jalr	-256(ra) # 2f2 <write>
}
 3fa:	60e2                	ld	ra,24(sp)
 3fc:	6442                	ld	s0,16(sp)
 3fe:	6105                	addi	sp,sp,32
 400:	8082                	ret

0000000000000402 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 402:	7139                	addi	sp,sp,-64
 404:	fc06                	sd	ra,56(sp)
 406:	f822                	sd	s0,48(sp)
 408:	f04a                	sd	s2,32(sp)
 40a:	ec4e                	sd	s3,24(sp)
 40c:	0080                	addi	s0,sp,64
 40e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 410:	cad9                	beqz	a3,4a6 <printint+0xa4>
 412:	01f5d79b          	srliw	a5,a1,0x1f
 416:	cbc1                	beqz	a5,4a6 <printint+0xa4>
    neg = 1;
    x = -xx;
 418:	40b005bb          	negw	a1,a1
    neg = 1;
 41c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 41e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 422:	86ce                	mv	a3,s3
  i = 0;
 424:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 426:	00000817          	auipc	a6,0x0
 42a:	71a80813          	addi	a6,a6,1818 # b40 <digits>
 42e:	88ba                	mv	a7,a4
 430:	0017051b          	addiw	a0,a4,1
 434:	872a                	mv	a4,a0
 436:	02c5f7bb          	remuw	a5,a1,a2
 43a:	1782                	slli	a5,a5,0x20
 43c:	9381                	srli	a5,a5,0x20
 43e:	97c2                	add	a5,a5,a6
 440:	0007c783          	lbu	a5,0(a5)
 444:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 448:	87ae                	mv	a5,a1
 44a:	02c5d5bb          	divuw	a1,a1,a2
 44e:	0685                	addi	a3,a3,1
 450:	fcc7ffe3          	bgeu	a5,a2,42e <printint+0x2c>
  if(neg)
 454:	00030c63          	beqz	t1,46c <printint+0x6a>
    buf[i++] = '-';
 458:	fd050793          	addi	a5,a0,-48
 45c:	00878533          	add	a0,a5,s0
 460:	02d00793          	li	a5,45
 464:	fef50823          	sb	a5,-16(a0)
 468:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 46c:	02e05763          	blez	a4,49a <printint+0x98>
 470:	f426                	sd	s1,40(sp)
 472:	377d                	addiw	a4,a4,-1
 474:	00e984b3          	add	s1,s3,a4
 478:	19fd                	addi	s3,s3,-1
 47a:	99ba                	add	s3,s3,a4
 47c:	1702                	slli	a4,a4,0x20
 47e:	9301                	srli	a4,a4,0x20
 480:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 484:	0004c583          	lbu	a1,0(s1)
 488:	854a                	mv	a0,s2
 48a:	00000097          	auipc	ra,0x0
 48e:	f56080e7          	jalr	-170(ra) # 3e0 <putc>
  while(--i >= 0)
 492:	14fd                	addi	s1,s1,-1
 494:	ff3498e3          	bne	s1,s3,484 <printint+0x82>
 498:	74a2                	ld	s1,40(sp)
}
 49a:	70e2                	ld	ra,56(sp)
 49c:	7442                	ld	s0,48(sp)
 49e:	7902                	ld	s2,32(sp)
 4a0:	69e2                	ld	s3,24(sp)
 4a2:	6121                	addi	sp,sp,64
 4a4:	8082                	ret
  neg = 0;
 4a6:	4301                	li	t1,0
 4a8:	bf9d                	j	41e <printint+0x1c>

00000000000004aa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4aa:	715d                	addi	sp,sp,-80
 4ac:	e486                	sd	ra,72(sp)
 4ae:	e0a2                	sd	s0,64(sp)
 4b0:	f84a                	sd	s2,48(sp)
 4b2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b4:	0005c903          	lbu	s2,0(a1)
 4b8:	1a090b63          	beqz	s2,66e <vprintf+0x1c4>
 4bc:	fc26                	sd	s1,56(sp)
 4be:	f44e                	sd	s3,40(sp)
 4c0:	f052                	sd	s4,32(sp)
 4c2:	ec56                	sd	s5,24(sp)
 4c4:	e85a                	sd	s6,16(sp)
 4c6:	e45e                	sd	s7,8(sp)
 4c8:	8aaa                	mv	s5,a0
 4ca:	8bb2                	mv	s7,a2
 4cc:	00158493          	addi	s1,a1,1
  state = 0;
 4d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d2:	02500a13          	li	s4,37
 4d6:	4b55                	li	s6,21
 4d8:	a839                	j	4f6 <vprintf+0x4c>
        putc(fd, c);
 4da:	85ca                	mv	a1,s2
 4dc:	8556                	mv	a0,s5
 4de:	00000097          	auipc	ra,0x0
 4e2:	f02080e7          	jalr	-254(ra) # 3e0 <putc>
 4e6:	a019                	j	4ec <vprintf+0x42>
    } else if(state == '%'){
 4e8:	01498d63          	beq	s3,s4,502 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4ec:	0485                	addi	s1,s1,1
 4ee:	fff4c903          	lbu	s2,-1(s1)
 4f2:	16090863          	beqz	s2,662 <vprintf+0x1b8>
    if(state == 0){
 4f6:	fe0999e3          	bnez	s3,4e8 <vprintf+0x3e>
      if(c == '%'){
 4fa:	ff4910e3          	bne	s2,s4,4da <vprintf+0x30>
        state = '%';
 4fe:	89d2                	mv	s3,s4
 500:	b7f5                	j	4ec <vprintf+0x42>
      if(c == 'd'){
 502:	13490563          	beq	s2,s4,62c <vprintf+0x182>
 506:	f9d9079b          	addiw	a5,s2,-99
 50a:	0ff7f793          	zext.b	a5,a5
 50e:	12fb6863          	bltu	s6,a5,63e <vprintf+0x194>
 512:	f9d9079b          	addiw	a5,s2,-99
 516:	0ff7f713          	zext.b	a4,a5
 51a:	12eb6263          	bltu	s6,a4,63e <vprintf+0x194>
 51e:	00271793          	slli	a5,a4,0x2
 522:	00000717          	auipc	a4,0x0
 526:	5c670713          	addi	a4,a4,1478 # ae8 <ithread_join+0x84>
 52a:	97ba                	add	a5,a5,a4
 52c:	439c                	lw	a5,0(a5)
 52e:	97ba                	add	a5,a5,a4
 530:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 532:	008b8913          	addi	s2,s7,8
 536:	4685                	li	a3,1
 538:	4629                	li	a2,10
 53a:	000ba583          	lw	a1,0(s7)
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	ec2080e7          	jalr	-318(ra) # 402 <printint>
 548:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 54a:	4981                	li	s3,0
 54c:	b745                	j	4ec <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 54e:	008b8913          	addi	s2,s7,8
 552:	4681                	li	a3,0
 554:	4629                	li	a2,10
 556:	000ba583          	lw	a1,0(s7)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	ea6080e7          	jalr	-346(ra) # 402 <printint>
 564:	8bca                	mv	s7,s2
      state = 0;
 566:	4981                	li	s3,0
 568:	b751                	j	4ec <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 56a:	008b8913          	addi	s2,s7,8
 56e:	4681                	li	a3,0
 570:	4641                	li	a2,16
 572:	000ba583          	lw	a1,0(s7)
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	e8a080e7          	jalr	-374(ra) # 402 <printint>
 580:	8bca                	mv	s7,s2
      state = 0;
 582:	4981                	li	s3,0
 584:	b7a5                	j	4ec <vprintf+0x42>
 586:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 588:	008b8793          	addi	a5,s7,8
 58c:	8c3e                	mv	s8,a5
 58e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 592:	03000593          	li	a1,48
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e48080e7          	jalr	-440(ra) # 3e0 <putc>
  putc(fd, 'x');
 5a0:	07800593          	li	a1,120
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e3a080e7          	jalr	-454(ra) # 3e0 <putc>
 5ae:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b0:	00000b97          	auipc	s7,0x0
 5b4:	590b8b93          	addi	s7,s7,1424 # b40 <digits>
 5b8:	03c9d793          	srli	a5,s3,0x3c
 5bc:	97de                	add	a5,a5,s7
 5be:	0007c583          	lbu	a1,0(a5)
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	e1c080e7          	jalr	-484(ra) # 3e0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5cc:	0992                	slli	s3,s3,0x4
 5ce:	397d                	addiw	s2,s2,-1
 5d0:	fe0914e3          	bnez	s2,5b8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5d4:	8be2                	mv	s7,s8
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	6c02                	ld	s8,0(sp)
 5da:	bf09                	j	4ec <vprintf+0x42>
        s = va_arg(ap, char*);
 5dc:	008b8993          	addi	s3,s7,8
 5e0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5e4:	02090163          	beqz	s2,606 <vprintf+0x15c>
        while(*s != 0){
 5e8:	00094583          	lbu	a1,0(s2)
 5ec:	c9a5                	beqz	a1,65c <vprintf+0x1b2>
          putc(fd, *s);
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	df0080e7          	jalr	-528(ra) # 3e0 <putc>
          s++;
 5f8:	0905                	addi	s2,s2,1
        while(*s != 0){
 5fa:	00094583          	lbu	a1,0(s2)
 5fe:	f9e5                	bnez	a1,5ee <vprintf+0x144>
        s = va_arg(ap, char*);
 600:	8bce                	mv	s7,s3
      state = 0;
 602:	4981                	li	s3,0
 604:	b5e5                	j	4ec <vprintf+0x42>
          s = "(null)";
 606:	00000917          	auipc	s2,0x0
 60a:	4aa90913          	addi	s2,s2,1194 # ab0 <ithread_join+0x4c>
        while(*s != 0){
 60e:	02800593          	li	a1,40
 612:	bff1                	j	5ee <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 614:	008b8913          	addi	s2,s7,8
 618:	000bc583          	lbu	a1,0(s7)
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	dc2080e7          	jalr	-574(ra) # 3e0 <putc>
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
 62a:	b5c9                	j	4ec <vprintf+0x42>
        putc(fd, c);
 62c:	02500593          	li	a1,37
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	dae080e7          	jalr	-594(ra) # 3e0 <putc>
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bd45                	j	4ec <vprintf+0x42>
        putc(fd, '%');
 63e:	02500593          	li	a1,37
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	d9c080e7          	jalr	-612(ra) # 3e0 <putc>
        putc(fd, c);
 64c:	85ca                	mv	a1,s2
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	d90080e7          	jalr	-624(ra) # 3e0 <putc>
      state = 0;
 658:	4981                	li	s3,0
 65a:	bd49                	j	4ec <vprintf+0x42>
        s = va_arg(ap, char*);
 65c:	8bce                	mv	s7,s3
      state = 0;
 65e:	4981                	li	s3,0
 660:	b571                	j	4ec <vprintf+0x42>
 662:	74e2                	ld	s1,56(sp)
 664:	79a2                	ld	s3,40(sp)
 666:	7a02                	ld	s4,32(sp)
 668:	6ae2                	ld	s5,24(sp)
 66a:	6b42                	ld	s6,16(sp)
 66c:	6ba2                	ld	s7,8(sp)
    }
  }
}
 66e:	60a6                	ld	ra,72(sp)
 670:	6406                	ld	s0,64(sp)
 672:	7942                	ld	s2,48(sp)
 674:	6161                	addi	sp,sp,80
 676:	8082                	ret

0000000000000678 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 678:	715d                	addi	sp,sp,-80
 67a:	ec06                	sd	ra,24(sp)
 67c:	e822                	sd	s0,16(sp)
 67e:	1000                	addi	s0,sp,32
 680:	e010                	sd	a2,0(s0)
 682:	e414                	sd	a3,8(s0)
 684:	e818                	sd	a4,16(s0)
 686:	ec1c                	sd	a5,24(s0)
 688:	03043023          	sd	a6,32(s0)
 68c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 690:	8622                	mv	a2,s0
 692:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 696:	00000097          	auipc	ra,0x0
 69a:	e14080e7          	jalr	-492(ra) # 4aa <vprintf>
}
 69e:	60e2                	ld	ra,24(sp)
 6a0:	6442                	ld	s0,16(sp)
 6a2:	6161                	addi	sp,sp,80
 6a4:	8082                	ret

00000000000006a6 <printf>:

void
printf(const char *fmt, ...)
{
 6a6:	711d                	addi	sp,sp,-96
 6a8:	ec06                	sd	ra,24(sp)
 6aa:	e822                	sd	s0,16(sp)
 6ac:	1000                	addi	s0,sp,32
 6ae:	e40c                	sd	a1,8(s0)
 6b0:	e810                	sd	a2,16(s0)
 6b2:	ec14                	sd	a3,24(s0)
 6b4:	f018                	sd	a4,32(s0)
 6b6:	f41c                	sd	a5,40(s0)
 6b8:	03043823          	sd	a6,48(s0)
 6bc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c0:	00840613          	addi	a2,s0,8
 6c4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c8:	85aa                	mv	a1,a0
 6ca:	4505                	li	a0,1
 6cc:	00000097          	auipc	ra,0x0
 6d0:	dde080e7          	jalr	-546(ra) # 4aa <vprintf>
}
 6d4:	60e2                	ld	ra,24(sp)
 6d6:	6442                	ld	s0,16(sp)
 6d8:	6125                	addi	sp,sp,96
 6da:	8082                	ret

00000000000006dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6dc:	1141                	addi	sp,sp,-16
 6de:	e406                	sd	ra,8(sp)
 6e0:	e022                	sd	s0,0(sp)
 6e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e8:	00001797          	auipc	a5,0x1
 6ec:	e287b783          	ld	a5,-472(a5) # 1510 <freep>
 6f0:	a039                	j	6fe <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f2:	6398                	ld	a4,0(a5)
 6f4:	00e7e463          	bltu	a5,a4,6fc <free+0x20>
 6f8:	00e6ea63          	bltu	a3,a4,70c <free+0x30>
{
 6fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fe:	fed7fae3          	bgeu	a5,a3,6f2 <free+0x16>
 702:	6398                	ld	a4,0(a5)
 704:	00e6e463          	bltu	a3,a4,70c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	fee7eae3          	bltu	a5,a4,6fc <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 70c:	ff852583          	lw	a1,-8(a0)
 710:	6390                	ld	a2,0(a5)
 712:	02059813          	slli	a6,a1,0x20
 716:	01c85713          	srli	a4,a6,0x1c
 71a:	9736                	add	a4,a4,a3
 71c:	02e60563          	beq	a2,a4,746 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 720:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 724:	4790                	lw	a2,8(a5)
 726:	02061593          	slli	a1,a2,0x20
 72a:	01c5d713          	srli	a4,a1,0x1c
 72e:	973e                	add	a4,a4,a5
 730:	02e68263          	beq	a3,a4,754 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 734:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 736:	00001717          	auipc	a4,0x1
 73a:	dcf73d23          	sd	a5,-550(a4) # 1510 <freep>
}
 73e:	60a2                	ld	ra,8(sp)
 740:	6402                	ld	s0,0(sp)
 742:	0141                	addi	sp,sp,16
 744:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 746:	4618                	lw	a4,8(a2)
 748:	9f2d                	addw	a4,a4,a1
 74a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 74e:	6398                	ld	a4,0(a5)
 750:	6310                	ld	a2,0(a4)
 752:	b7f9                	j	720 <free+0x44>
    p->s.size += bp->s.size;
 754:	ff852703          	lw	a4,-8(a0)
 758:	9f31                	addw	a4,a4,a2
 75a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 75c:	ff053683          	ld	a3,-16(a0)
 760:	bfd1                	j	734 <free+0x58>

0000000000000762 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 762:	7139                	addi	sp,sp,-64
 764:	fc06                	sd	ra,56(sp)
 766:	f822                	sd	s0,48(sp)
 768:	f04a                	sd	s2,32(sp)
 76a:	ec4e                	sd	s3,24(sp)
 76c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76e:	02051993          	slli	s3,a0,0x20
 772:	0209d993          	srli	s3,s3,0x20
 776:	09bd                	addi	s3,s3,15
 778:	0049d993          	srli	s3,s3,0x4
 77c:	2985                	addiw	s3,s3,1
 77e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 780:	00001517          	auipc	a0,0x1
 784:	d9053503          	ld	a0,-624(a0) # 1510 <freep>
 788:	c905                	beqz	a0,7b8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78c:	4798                	lw	a4,8(a5)
 78e:	09377a63          	bgeu	a4,s3,822 <malloc+0xc0>
 792:	f426                	sd	s1,40(sp)
 794:	e852                	sd	s4,16(sp)
 796:	e456                	sd	s5,8(sp)
 798:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 79a:	8a4e                	mv	s4,s3
 79c:	6705                	lui	a4,0x1
 79e:	00e9f363          	bgeu	s3,a4,7a4 <malloc+0x42>
 7a2:	6a05                	lui	s4,0x1
 7a4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ac:	00001497          	auipc	s1,0x1
 7b0:	d6448493          	addi	s1,s1,-668 # 1510 <freep>
  if(p == (char*)-1)
 7b4:	5afd                	li	s5,-1
 7b6:	a089                	j	7f8 <malloc+0x96>
 7b8:	f426                	sd	s1,40(sp)
 7ba:	e852                	sd	s4,16(sp)
 7bc:	e456                	sd	s5,8(sp)
 7be:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7c0:	00001797          	auipc	a5,0x1
 7c4:	d7078793          	addi	a5,a5,-656 # 1530 <base>
 7c8:	00001717          	auipc	a4,0x1
 7cc:	d4f73423          	sd	a5,-696(a4) # 1510 <freep>
 7d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d6:	b7d1                	j	79a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7d8:	6398                	ld	a4,0(a5)
 7da:	e118                	sd	a4,0(a0)
 7dc:	a8b9                	j	83a <malloc+0xd8>
  hp->s.size = nu;
 7de:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7e2:	0541                	addi	a0,a0,16
 7e4:	00000097          	auipc	ra,0x0
 7e8:	ef8080e7          	jalr	-264(ra) # 6dc <free>
  return freep;
 7ec:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7ee:	c135                	beqz	a0,852 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f2:	4798                	lw	a4,8(a5)
 7f4:	03277363          	bgeu	a4,s2,81a <malloc+0xb8>
    if(p == freep)
 7f8:	6098                	ld	a4,0(s1)
 7fa:	853e                	mv	a0,a5
 7fc:	fef71ae3          	bne	a4,a5,7f0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 800:	8552                	mv	a0,s4
 802:	00000097          	auipc	ra,0x0
 806:	b58080e7          	jalr	-1192(ra) # 35a <sbrk>
  if(p == (char*)-1)
 80a:	fd551ae3          	bne	a0,s5,7de <malloc+0x7c>
        return 0;
 80e:	4501                	li	a0,0
 810:	74a2                	ld	s1,40(sp)
 812:	6a42                	ld	s4,16(sp)
 814:	6aa2                	ld	s5,8(sp)
 816:	6b02                	ld	s6,0(sp)
 818:	a03d                	j	846 <malloc+0xe4>
 81a:	74a2                	ld	s1,40(sp)
 81c:	6a42                	ld	s4,16(sp)
 81e:	6aa2                	ld	s5,8(sp)
 820:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 822:	fae90be3          	beq	s2,a4,7d8 <malloc+0x76>
        p->s.size -= nunits;
 826:	4137073b          	subw	a4,a4,s3
 82a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 82c:	02071693          	slli	a3,a4,0x20
 830:	01c6d713          	srli	a4,a3,0x1c
 834:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 836:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 83a:	00001717          	auipc	a4,0x1
 83e:	cca73b23          	sd	a0,-810(a4) # 1510 <freep>
      return (void*)(p + 1);
 842:	01078513          	addi	a0,a5,16
  }
}
 846:	70e2                	ld	ra,56(sp)
 848:	7442                	ld	s0,48(sp)
 84a:	7902                	ld	s2,32(sp)
 84c:	69e2                	ld	s3,24(sp)
 84e:	6121                	addi	sp,sp,64
 850:	8082                	ret
 852:	74a2                	ld	s1,40(sp)
 854:	6a42                	ld	s4,16(sp)
 856:	6aa2                	ld	s5,8(sp)
 858:	6b02                	ld	s6,0(sp)
 85a:	b7f5                	j	846 <malloc+0xe4>

000000000000085c <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 85c:	1141                	addi	sp,sp,-16
 85e:	e406                	sd	ra,8(sp)
 860:	e022                	sd	s0,0(sp)
 862:	0800                	addi	s0,sp,16
  thread_exit(status);
 864:	2501                	sext.w	a0,a0
 866:	00000097          	auipc	ra,0x0
 86a:	b24080e7          	jalr	-1244(ra) # 38a <thread_exit>
}
 86e:	60a2                	ld	ra,8(sp)
 870:	6402                	ld	s0,0(sp)
 872:	0141                	addi	sp,sp,16
 874:	8082                	ret

0000000000000876 <free_stacks>:
int free_stacks() {
 876:	7179                	addi	sp,sp,-48
 878:	f406                	sd	ra,40(sp)
 87a:	f022                	sd	s0,32(sp)
 87c:	ec26                	sd	s1,24(sp)
 87e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 880:	00001797          	auipc	a5,0x1
 884:	ca07a783          	lw	a5,-864(a5) # 1520 <num_threads>
 888:	04f05063          	blez	a5,8c8 <free_stacks+0x52>
 88c:	e84a                	sd	s2,16(sp)
 88e:	e44e                	sd	s3,8(sp)
 890:	4481                	li	s1,0
    free(stacks[i]);
 892:	00001997          	auipc	s3,0x1
 896:	c8698993          	addi	s3,s3,-890 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 89a:	00001917          	auipc	s2,0x1
 89e:	c8690913          	addi	s2,s2,-890 # 1520 <num_threads>
    free(stacks[i]);
 8a2:	0009b783          	ld	a5,0(s3)
 8a6:	00349713          	slli	a4,s1,0x3
 8aa:	97ba                	add	a5,a5,a4
 8ac:	6388                	ld	a0,0(a5)
 8ae:	00000097          	auipc	ra,0x0
 8b2:	e2e080e7          	jalr	-466(ra) # 6dc <free>
  for (int i = 0; i < num_threads; i++) {
 8b6:	0485                	addi	s1,s1,1
 8b8:	00092703          	lw	a4,0(s2)
 8bc:	0004879b          	sext.w	a5,s1
 8c0:	fee7c1e3          	blt	a5,a4,8a2 <free_stacks+0x2c>
 8c4:	6942                	ld	s2,16(sp)
 8c6:	69a2                	ld	s3,8(sp)
  free(stacks);
 8c8:	00001497          	auipc	s1,0x1
 8cc:	c5048493          	addi	s1,s1,-944 # 1518 <stacks>
 8d0:	6088                	ld	a0,0(s1)
 8d2:	00000097          	auipc	ra,0x0
 8d6:	e0a080e7          	jalr	-502(ra) # 6dc <free>
  stacks = 0;
 8da:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8de:	00001797          	auipc	a5,0x1
 8e2:	c407a123          	sw	zero,-958(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8e6:	47a1                	li	a5,8
 8e8:	00001717          	auipc	a4,0x1
 8ec:	c0f72c23          	sw	a5,-1000(a4) # 1500 <max_stacks>
  threads_done = 0;
 8f0:	00001797          	auipc	a5,0x1
 8f4:	c207aa23          	sw	zero,-972(a5) # 1524 <threads_done>
}
 8f8:	4501                	li	a0,0
 8fa:	70a2                	ld	ra,40(sp)
 8fc:	7402                	ld	s0,32(sp)
 8fe:	64e2                	ld	s1,24(sp)
 900:	6145                	addi	sp,sp,48
 902:	8082                	ret

0000000000000904 <expand_num_threads>:
int expand_num_threads() {
 904:	1101                	addi	sp,sp,-32
 906:	ec06                	sd	ra,24(sp)
 908:	e822                	sd	s0,16(sp)
 90a:	e426                	sd	s1,8(sp)
 90c:	e04a                	sd	s2,0(sp)
 90e:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 910:	00001797          	auipc	a5,0x1
 914:	bf078793          	addi	a5,a5,-1040 # 1500 <max_stacks>
 918:	4388                	lw	a0,0(a5)
 91a:	0015151b          	slliw	a0,a0,0x1
 91e:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 920:	0035151b          	slliw	a0,a0,0x3
 924:	00000097          	auipc	ra,0x0
 928:	e3e080e7          	jalr	-450(ra) # 762 <malloc>
 92c:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 92e:	00001617          	auipc	a2,0x1
 932:	bf262603          	lw	a2,-1038(a2) # 1520 <num_threads>
 936:	00001497          	auipc	s1,0x1
 93a:	be248493          	addi	s1,s1,-1054 # 1518 <stacks>
 93e:	0036161b          	slliw	a2,a2,0x3
 942:	608c                	ld	a1,0(s1)
 944:	00000097          	auipc	ra,0x0
 948:	8d8080e7          	jalr	-1832(ra) # 21c <memmove>
  free(stacks);
 94c:	6088                	ld	a0,0(s1)
 94e:	00000097          	auipc	ra,0x0
 952:	d8e080e7          	jalr	-626(ra) # 6dc <free>
  stacks = new_stacks;
 956:	0124b023          	sd	s2,0(s1)
}
 95a:	4501                	li	a0,0
 95c:	60e2                	ld	ra,24(sp)
 95e:	6442                	ld	s0,16(sp)
 960:	64a2                	ld	s1,8(sp)
 962:	6902                	ld	s2,0(sp)
 964:	6105                	addi	sp,sp,32
 966:	8082                	ret

0000000000000968 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 968:	7179                	addi	sp,sp,-48
 96a:	f406                	sd	ra,40(sp)
 96c:	f022                	sd	s0,32(sp)
 96e:	e84a                	sd	s2,16(sp)
 970:	e44e                	sd	s3,8(sp)
 972:	1800                	addi	s0,sp,48
 974:	892a                	mv	s2,a0
 976:	89ae                	mv	s3,a1
  if (stacks == 0) {
 978:	00001797          	auipc	a5,0x1
 97c:	ba07b783          	ld	a5,-1120(a5) # 1518 <stacks>
 980:	c3d9                	beqz	a5,a06 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 982:	00001797          	auipc	a5,0x1
 986:	b7e7a783          	lw	a5,-1154(a5) # 1500 <max_stacks>
 98a:	00001717          	auipc	a4,0x1
 98e:	b9672703          	lw	a4,-1130(a4) # 1520 <num_threads>
 992:	0af71463          	bne	a4,a5,a3a <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 996:	04000713          	li	a4,64
 99a:	08e78563          	beq	a5,a4,a24 <ithread_create+0xbc>
 99e:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9a0:	00000097          	auipc	ra,0x0
 9a4:	f64080e7          	jalr	-156(ra) # 904 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9a8:	6505                	lui	a0,0x1
 9aa:	00000097          	auipc	ra,0x0
 9ae:	db8080e7          	jalr	-584(ra) # 762 <malloc>
 9b2:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9b4:	00001717          	auipc	a4,0x1
 9b8:	b6c72703          	lw	a4,-1172(a4) # 1520 <num_threads>
 9bc:	070e                	slli	a4,a4,0x3
 9be:	00001797          	auipc	a5,0x1
 9c2:	b5a7b783          	ld	a5,-1190(a5) # 1518 <stacks>
 9c6:	97ba                	add	a5,a5,a4
 9c8:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9ca:	00000697          	auipc	a3,0x0
 9ce:	e9268693          	addi	a3,a3,-366 # 85c <ithread_exit>
 9d2:	862a                	mv	a2,a0
 9d4:	85ce                	mv	a1,s3
 9d6:	854a                	mv	a0,s2
 9d8:	00000097          	auipc	ra,0x0
 9dc:	9a2080e7          	jalr	-1630(ra) # 37a <create_thread>
 9e0:	892a                	mv	s2,a0
  if (res != -1) {
 9e2:	57fd                	li	a5,-1
 9e4:	04f50d63          	beq	a0,a5,a3e <ithread_create+0xd6>
    num_threads++;
 9e8:	00001717          	auipc	a4,0x1
 9ec:	b3870713          	addi	a4,a4,-1224 # 1520 <num_threads>
 9f0:	431c                	lw	a5,0(a4)
 9f2:	2785                	addiw	a5,a5,1
 9f4:	c31c                	sw	a5,0(a4)
 9f6:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 9f8:	854a                	mv	a0,s2
 9fa:	70a2                	ld	ra,40(sp)
 9fc:	7402                	ld	s0,32(sp)
 9fe:	6942                	ld	s2,16(sp)
 a00:	69a2                	ld	s3,8(sp)
 a02:	6145                	addi	sp,sp,48
 a04:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a06:	00001517          	auipc	a0,0x1
 a0a:	afa52503          	lw	a0,-1286(a0) # 1500 <max_stacks>
 a0e:	0035151b          	slliw	a0,a0,0x3
 a12:	00000097          	auipc	ra,0x0
 a16:	d50080e7          	jalr	-688(ra) # 762 <malloc>
 a1a:	00001797          	auipc	a5,0x1
 a1e:	aea7bf23          	sd	a0,-1282(a5) # 1518 <stacks>
 a22:	b785                	j	982 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a24:	00000517          	auipc	a0,0x0
 a28:	09450513          	addi	a0,a0,148 # ab8 <ithread_join+0x54>
 a2c:	00000097          	auipc	ra,0x0
 a30:	c7a080e7          	jalr	-902(ra) # 6a6 <printf>
      return -1;
 a34:	57fd                	li	a5,-1
 a36:	893e                	mv	s2,a5
 a38:	b7c1                	j	9f8 <ithread_create+0x90>
 a3a:	ec26                	sd	s1,24(sp)
 a3c:	b7b5                	j	9a8 <ithread_create+0x40>
    free(stack_ptr);
 a3e:	8526                	mv	a0,s1
 a40:	00000097          	auipc	ra,0x0
 a44:	c9c080e7          	jalr	-868(ra) # 6dc <free>
    stacks[num_threads] = 0;
 a48:	00001717          	auipc	a4,0x1
 a4c:	ad872703          	lw	a4,-1320(a4) # 1520 <num_threads>
 a50:	070e                	slli	a4,a4,0x3
 a52:	00001797          	auipc	a5,0x1
 a56:	ac67b783          	ld	a5,-1338(a5) # 1518 <stacks>
 a5a:	97ba                	add	a5,a5,a4
 a5c:	0007b023          	sd	zero,0(a5)
 a60:	64e2                	ld	s1,24(sp)
 a62:	bf59                	j	9f8 <ithread_create+0x90>

0000000000000a64 <ithread_join>:

int ithread_join(int thread_id) {
 a64:	1101                	addi	sp,sp,-32
 a66:	ec06                	sd	ra,24(sp)
 a68:	e822                	sd	s0,16(sp)
 a6a:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a6c:	ff040793          	addi	a5,s0,-16
 a70:	ffc7859b          	addiw	a1,a5,-4
 a74:	00000097          	auipc	ra,0x0
 a78:	90e080e7          	jalr	-1778(ra) # 382 <join_thread>
  threads_done++;
 a7c:	00001717          	auipc	a4,0x1
 a80:	aa870713          	addi	a4,a4,-1368 # 1524 <threads_done>
 a84:	431c                	lw	a5,0(a4)
 a86:	2785                	addiw	a5,a5,1
 a88:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a8a:	00001717          	auipc	a4,0x1
 a8e:	a9672703          	lw	a4,-1386(a4) # 1520 <num_threads>
 a92:	00f70863          	beq	a4,a5,aa2 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 a96:	fec42503          	lw	a0,-20(s0)
 a9a:	60e2                	ld	ra,24(sp)
 a9c:	6442                	ld	s0,16(sp)
 a9e:	6105                	addi	sp,sp,32
 aa0:	8082                	ret
    free_stacks();
 aa2:	00000097          	auipc	ra,0x0
 aa6:	dd4080e7          	jalr	-556(ra) # 876 <free_stacks>
 aaa:	b7f5                	j	a96 <ithread_join+0x32>
