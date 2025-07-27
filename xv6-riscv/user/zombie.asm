
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

00000000000003ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ba:	1101                	addi	sp,sp,-32
 3bc:	ec06                	sd	ra,24(sp)
 3be:	e822                	sd	s0,16(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c6:	4605                	li	a2,1
 3c8:	fef40593          	addi	a1,s0,-17
 3cc:	00000097          	auipc	ra,0x0
 3d0:	f26080e7          	jalr	-218(ra) # 2f2 <write>
}
 3d4:	60e2                	ld	ra,24(sp)
 3d6:	6442                	ld	s0,16(sp)
 3d8:	6105                	addi	sp,sp,32
 3da:	8082                	ret

00000000000003dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3dc:	7139                	addi	sp,sp,-64
 3de:	fc06                	sd	ra,56(sp)
 3e0:	f822                	sd	s0,48(sp)
 3e2:	f04a                	sd	s2,32(sp)
 3e4:	ec4e                	sd	s3,24(sp)
 3e6:	0080                	addi	s0,sp,64
 3e8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ea:	cad9                	beqz	a3,480 <printint+0xa4>
 3ec:	01f5d79b          	srliw	a5,a1,0x1f
 3f0:	cbc1                	beqz	a5,480 <printint+0xa4>
    neg = 1;
    x = -xx;
 3f2:	40b005bb          	negw	a1,a1
    neg = 1;
 3f6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3f8:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3fc:	86ce                	mv	a3,s3
  i = 0;
 3fe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 400:	00000817          	auipc	a6,0x0
 404:	72080813          	addi	a6,a6,1824 # b20 <digits>
 408:	88ba                	mv	a7,a4
 40a:	0017051b          	addiw	a0,a4,1
 40e:	872a                	mv	a4,a0
 410:	02c5f7bb          	remuw	a5,a1,a2
 414:	1782                	slli	a5,a5,0x20
 416:	9381                	srli	a5,a5,0x20
 418:	97c2                	add	a5,a5,a6
 41a:	0007c783          	lbu	a5,0(a5)
 41e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 422:	87ae                	mv	a5,a1
 424:	02c5d5bb          	divuw	a1,a1,a2
 428:	0685                	addi	a3,a3,1
 42a:	fcc7ffe3          	bgeu	a5,a2,408 <printint+0x2c>
  if(neg)
 42e:	00030c63          	beqz	t1,446 <printint+0x6a>
    buf[i++] = '-';
 432:	fd050793          	addi	a5,a0,-48
 436:	00878533          	add	a0,a5,s0
 43a:	02d00793          	li	a5,45
 43e:	fef50823          	sb	a5,-16(a0)
 442:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 446:	02e05763          	blez	a4,474 <printint+0x98>
 44a:	f426                	sd	s1,40(sp)
 44c:	377d                	addiw	a4,a4,-1
 44e:	00e984b3          	add	s1,s3,a4
 452:	19fd                	addi	s3,s3,-1
 454:	99ba                	add	s3,s3,a4
 456:	1702                	slli	a4,a4,0x20
 458:	9301                	srli	a4,a4,0x20
 45a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 45e:	0004c583          	lbu	a1,0(s1)
 462:	854a                	mv	a0,s2
 464:	00000097          	auipc	ra,0x0
 468:	f56080e7          	jalr	-170(ra) # 3ba <putc>
  while(--i >= 0)
 46c:	14fd                	addi	s1,s1,-1
 46e:	ff3498e3          	bne	s1,s3,45e <printint+0x82>
 472:	74a2                	ld	s1,40(sp)
}
 474:	70e2                	ld	ra,56(sp)
 476:	7442                	ld	s0,48(sp)
 478:	7902                	ld	s2,32(sp)
 47a:	69e2                	ld	s3,24(sp)
 47c:	6121                	addi	sp,sp,64
 47e:	8082                	ret
  neg = 0;
 480:	4301                	li	t1,0
 482:	bf9d                	j	3f8 <printint+0x1c>

0000000000000484 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 484:	715d                	addi	sp,sp,-80
 486:	e486                	sd	ra,72(sp)
 488:	e0a2                	sd	s0,64(sp)
 48a:	f84a                	sd	s2,48(sp)
 48c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48e:	0005c903          	lbu	s2,0(a1)
 492:	1a090b63          	beqz	s2,648 <vprintf+0x1c4>
 496:	fc26                	sd	s1,56(sp)
 498:	f44e                	sd	s3,40(sp)
 49a:	f052                	sd	s4,32(sp)
 49c:	ec56                	sd	s5,24(sp)
 49e:	e85a                	sd	s6,16(sp)
 4a0:	e45e                	sd	s7,8(sp)
 4a2:	8aaa                	mv	s5,a0
 4a4:	8bb2                	mv	s7,a2
 4a6:	00158493          	addi	s1,a1,1
  state = 0;
 4aa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ac:	02500a13          	li	s4,37
 4b0:	4b55                	li	s6,21
 4b2:	a839                	j	4d0 <vprintf+0x4c>
        putc(fd, c);
 4b4:	85ca                	mv	a1,s2
 4b6:	8556                	mv	a0,s5
 4b8:	00000097          	auipc	ra,0x0
 4bc:	f02080e7          	jalr	-254(ra) # 3ba <putc>
 4c0:	a019                	j	4c6 <vprintf+0x42>
    } else if(state == '%'){
 4c2:	01498d63          	beq	s3,s4,4dc <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4c6:	0485                	addi	s1,s1,1
 4c8:	fff4c903          	lbu	s2,-1(s1)
 4cc:	16090863          	beqz	s2,63c <vprintf+0x1b8>
    if(state == 0){
 4d0:	fe0999e3          	bnez	s3,4c2 <vprintf+0x3e>
      if(c == '%'){
 4d4:	ff4910e3          	bne	s2,s4,4b4 <vprintf+0x30>
        state = '%';
 4d8:	89d2                	mv	s3,s4
 4da:	b7f5                	j	4c6 <vprintf+0x42>
      if(c == 'd'){
 4dc:	13490563          	beq	s2,s4,606 <vprintf+0x182>
 4e0:	f9d9079b          	addiw	a5,s2,-99
 4e4:	0ff7f793          	zext.b	a5,a5
 4e8:	12fb6863          	bltu	s6,a5,618 <vprintf+0x194>
 4ec:	f9d9079b          	addiw	a5,s2,-99
 4f0:	0ff7f713          	zext.b	a4,a5
 4f4:	12eb6263          	bltu	s6,a4,618 <vprintf+0x194>
 4f8:	00271793          	slli	a5,a4,0x2
 4fc:	00000717          	auipc	a4,0x0
 500:	5cc70713          	addi	a4,a4,1484 # ac8 <ithread_join+0x8a>
 504:	97ba                	add	a5,a5,a4
 506:	439c                	lw	a5,0(a5)
 508:	97ba                	add	a5,a5,a4
 50a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 50c:	008b8913          	addi	s2,s7,8
 510:	4685                	li	a3,1
 512:	4629                	li	a2,10
 514:	000ba583          	lw	a1,0(s7)
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	ec2080e7          	jalr	-318(ra) # 3dc <printint>
 522:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 524:	4981                	li	s3,0
 526:	b745                	j	4c6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 528:	008b8913          	addi	s2,s7,8
 52c:	4681                	li	a3,0
 52e:	4629                	li	a2,10
 530:	000ba583          	lw	a1,0(s7)
 534:	8556                	mv	a0,s5
 536:	00000097          	auipc	ra,0x0
 53a:	ea6080e7          	jalr	-346(ra) # 3dc <printint>
 53e:	8bca                	mv	s7,s2
      state = 0;
 540:	4981                	li	s3,0
 542:	b751                	j	4c6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 544:	008b8913          	addi	s2,s7,8
 548:	4681                	li	a3,0
 54a:	4641                	li	a2,16
 54c:	000ba583          	lw	a1,0(s7)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e8a080e7          	jalr	-374(ra) # 3dc <printint>
 55a:	8bca                	mv	s7,s2
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b7a5                	j	4c6 <vprintf+0x42>
 560:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 562:	008b8793          	addi	a5,s7,8
 566:	8c3e                	mv	s8,a5
 568:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 56c:	03000593          	li	a1,48
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	e48080e7          	jalr	-440(ra) # 3ba <putc>
  putc(fd, 'x');
 57a:	07800593          	li	a1,120
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e3a080e7          	jalr	-454(ra) # 3ba <putc>
 588:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 58a:	00000b97          	auipc	s7,0x0
 58e:	596b8b93          	addi	s7,s7,1430 # b20 <digits>
 592:	03c9d793          	srli	a5,s3,0x3c
 596:	97de                	add	a5,a5,s7
 598:	0007c583          	lbu	a1,0(a5)
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	e1c080e7          	jalr	-484(ra) # 3ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a6:	0992                	slli	s3,s3,0x4
 5a8:	397d                	addiw	s2,s2,-1
 5aa:	fe0914e3          	bnez	s2,592 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5ae:	8be2                	mv	s7,s8
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	6c02                	ld	s8,0(sp)
 5b4:	bf09                	j	4c6 <vprintf+0x42>
        s = va_arg(ap, char*);
 5b6:	008b8993          	addi	s3,s7,8
 5ba:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5be:	02090163          	beqz	s2,5e0 <vprintf+0x15c>
        while(*s != 0){
 5c2:	00094583          	lbu	a1,0(s2)
 5c6:	c9a5                	beqz	a1,636 <vprintf+0x1b2>
          putc(fd, *s);
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	df0080e7          	jalr	-528(ra) # 3ba <putc>
          s++;
 5d2:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d4:	00094583          	lbu	a1,0(s2)
 5d8:	f9e5                	bnez	a1,5c8 <vprintf+0x144>
        s = va_arg(ap, char*);
 5da:	8bce                	mv	s7,s3
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b5e5                	j	4c6 <vprintf+0x42>
          s = "(null)";
 5e0:	00000917          	auipc	s2,0x0
 5e4:	4b090913          	addi	s2,s2,1200 # a90 <ithread_join+0x52>
        while(*s != 0){
 5e8:	02800593          	li	a1,40
 5ec:	bff1                	j	5c8 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	000bc583          	lbu	a1,0(s7)
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	dc2080e7          	jalr	-574(ra) # 3ba <putc>
 600:	8bca                	mv	s7,s2
      state = 0;
 602:	4981                	li	s3,0
 604:	b5c9                	j	4c6 <vprintf+0x42>
        putc(fd, c);
 606:	02500593          	li	a1,37
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	dae080e7          	jalr	-594(ra) # 3ba <putc>
      state = 0;
 614:	4981                	li	s3,0
 616:	bd45                	j	4c6 <vprintf+0x42>
        putc(fd, '%');
 618:	02500593          	li	a1,37
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	d9c080e7          	jalr	-612(ra) # 3ba <putc>
        putc(fd, c);
 626:	85ca                	mv	a1,s2
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	d90080e7          	jalr	-624(ra) # 3ba <putc>
      state = 0;
 632:	4981                	li	s3,0
 634:	bd49                	j	4c6 <vprintf+0x42>
        s = va_arg(ap, char*);
 636:	8bce                	mv	s7,s3
      state = 0;
 638:	4981                	li	s3,0
 63a:	b571                	j	4c6 <vprintf+0x42>
 63c:	74e2                	ld	s1,56(sp)
 63e:	79a2                	ld	s3,40(sp)
 640:	7a02                	ld	s4,32(sp)
 642:	6ae2                	ld	s5,24(sp)
 644:	6b42                	ld	s6,16(sp)
 646:	6ba2                	ld	s7,8(sp)
    }
  }
}
 648:	60a6                	ld	ra,72(sp)
 64a:	6406                	ld	s0,64(sp)
 64c:	7942                	ld	s2,48(sp)
 64e:	6161                	addi	sp,sp,80
 650:	8082                	ret

0000000000000652 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 652:	715d                	addi	sp,sp,-80
 654:	ec06                	sd	ra,24(sp)
 656:	e822                	sd	s0,16(sp)
 658:	1000                	addi	s0,sp,32
 65a:	e010                	sd	a2,0(s0)
 65c:	e414                	sd	a3,8(s0)
 65e:	e818                	sd	a4,16(s0)
 660:	ec1c                	sd	a5,24(s0)
 662:	03043023          	sd	a6,32(s0)
 666:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 66a:	8622                	mv	a2,s0
 66c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 670:	00000097          	auipc	ra,0x0
 674:	e14080e7          	jalr	-492(ra) # 484 <vprintf>
}
 678:	60e2                	ld	ra,24(sp)
 67a:	6442                	ld	s0,16(sp)
 67c:	6161                	addi	sp,sp,80
 67e:	8082                	ret

0000000000000680 <printf>:

void
printf(const char *fmt, ...)
{
 680:	711d                	addi	sp,sp,-96
 682:	ec06                	sd	ra,24(sp)
 684:	e822                	sd	s0,16(sp)
 686:	1000                	addi	s0,sp,32
 688:	e40c                	sd	a1,8(s0)
 68a:	e810                	sd	a2,16(s0)
 68c:	ec14                	sd	a3,24(s0)
 68e:	f018                	sd	a4,32(s0)
 690:	f41c                	sd	a5,40(s0)
 692:	03043823          	sd	a6,48(s0)
 696:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 69a:	00840613          	addi	a2,s0,8
 69e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a2:	85aa                	mv	a1,a0
 6a4:	4505                	li	a0,1
 6a6:	00000097          	auipc	ra,0x0
 6aa:	dde080e7          	jalr	-546(ra) # 484 <vprintf>
}
 6ae:	60e2                	ld	ra,24(sp)
 6b0:	6442                	ld	s0,16(sp)
 6b2:	6125                	addi	sp,sp,96
 6b4:	8082                	ret

00000000000006b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b6:	1141                	addi	sp,sp,-16
 6b8:	e406                	sd	ra,8(sp)
 6ba:	e022                	sd	s0,0(sp)
 6bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	00001797          	auipc	a5,0x1
 6c6:	e4e7b783          	ld	a5,-434(a5) # 1510 <freep>
 6ca:	a039                	j	6d8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cc:	6398                	ld	a4,0(a5)
 6ce:	00e7e463          	bltu	a5,a4,6d6 <free+0x20>
 6d2:	00e6ea63          	bltu	a3,a4,6e6 <free+0x30>
{
 6d6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d8:	fed7fae3          	bgeu	a5,a3,6cc <free+0x16>
 6dc:	6398                	ld	a4,0(a5)
 6de:	00e6e463          	bltu	a3,a4,6e6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e2:	fee7eae3          	bltu	a5,a4,6d6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e6:	ff852583          	lw	a1,-8(a0)
 6ea:	6390                	ld	a2,0(a5)
 6ec:	02059813          	slli	a6,a1,0x20
 6f0:	01c85713          	srli	a4,a6,0x1c
 6f4:	9736                	add	a4,a4,a3
 6f6:	02e60563          	beq	a2,a4,720 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6fa:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6fe:	4790                	lw	a2,8(a5)
 700:	02061593          	slli	a1,a2,0x20
 704:	01c5d713          	srli	a4,a1,0x1c
 708:	973e                	add	a4,a4,a5
 70a:	02e68263          	beq	a3,a4,72e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 70e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 710:	00001717          	auipc	a4,0x1
 714:	e0f73023          	sd	a5,-512(a4) # 1510 <freep>
}
 718:	60a2                	ld	ra,8(sp)
 71a:	6402                	ld	s0,0(sp)
 71c:	0141                	addi	sp,sp,16
 71e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 720:	4618                	lw	a4,8(a2)
 722:	9f2d                	addw	a4,a4,a1
 724:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 728:	6398                	ld	a4,0(a5)
 72a:	6310                	ld	a2,0(a4)
 72c:	b7f9                	j	6fa <free+0x44>
    p->s.size += bp->s.size;
 72e:	ff852703          	lw	a4,-8(a0)
 732:	9f31                	addw	a4,a4,a2
 734:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 736:	ff053683          	ld	a3,-16(a0)
 73a:	bfd1                	j	70e <free+0x58>

000000000000073c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 73c:	7139                	addi	sp,sp,-64
 73e:	fc06                	sd	ra,56(sp)
 740:	f822                	sd	s0,48(sp)
 742:	f04a                	sd	s2,32(sp)
 744:	ec4e                	sd	s3,24(sp)
 746:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 748:	02051993          	slli	s3,a0,0x20
 74c:	0209d993          	srli	s3,s3,0x20
 750:	09bd                	addi	s3,s3,15
 752:	0049d993          	srli	s3,s3,0x4
 756:	2985                	addiw	s3,s3,1
 758:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 75a:	00001517          	auipc	a0,0x1
 75e:	db653503          	ld	a0,-586(a0) # 1510 <freep>
 762:	c905                	beqz	a0,792 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 764:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 766:	4798                	lw	a4,8(a5)
 768:	09377a63          	bgeu	a4,s3,7fc <malloc+0xc0>
 76c:	f426                	sd	s1,40(sp)
 76e:	e852                	sd	s4,16(sp)
 770:	e456                	sd	s5,8(sp)
 772:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 774:	8a4e                	mv	s4,s3
 776:	6705                	lui	a4,0x1
 778:	00e9f363          	bgeu	s3,a4,77e <malloc+0x42>
 77c:	6a05                	lui	s4,0x1
 77e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 782:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 786:	00001497          	auipc	s1,0x1
 78a:	d8a48493          	addi	s1,s1,-630 # 1510 <freep>
  if(p == (char*)-1)
 78e:	5afd                	li	s5,-1
 790:	a089                	j	7d2 <malloc+0x96>
 792:	f426                	sd	s1,40(sp)
 794:	e852                	sd	s4,16(sp)
 796:	e456                	sd	s5,8(sp)
 798:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 79a:	00001797          	auipc	a5,0x1
 79e:	d9678793          	addi	a5,a5,-618 # 1530 <base>
 7a2:	00001717          	auipc	a4,0x1
 7a6:	d6f73723          	sd	a5,-658(a4) # 1510 <freep>
 7aa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ac:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7b0:	b7d1                	j	774 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7b2:	6398                	ld	a4,0(a5)
 7b4:	e118                	sd	a4,0(a0)
 7b6:	a8b9                	j	814 <malloc+0xd8>
  hp->s.size = nu;
 7b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7bc:	0541                	addi	a0,a0,16
 7be:	00000097          	auipc	ra,0x0
 7c2:	ef8080e7          	jalr	-264(ra) # 6b6 <free>
  return freep;
 7c6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7c8:	c135                	beqz	a0,82c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7cc:	4798                	lw	a4,8(a5)
 7ce:	03277363          	bgeu	a4,s2,7f4 <malloc+0xb8>
    if(p == freep)
 7d2:	6098                	ld	a4,0(s1)
 7d4:	853e                	mv	a0,a5
 7d6:	fef71ae3          	bne	a4,a5,7ca <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7da:	8552                	mv	a0,s4
 7dc:	00000097          	auipc	ra,0x0
 7e0:	b7e080e7          	jalr	-1154(ra) # 35a <sbrk>
  if(p == (char*)-1)
 7e4:	fd551ae3          	bne	a0,s5,7b8 <malloc+0x7c>
        return 0;
 7e8:	4501                	li	a0,0
 7ea:	74a2                	ld	s1,40(sp)
 7ec:	6a42                	ld	s4,16(sp)
 7ee:	6aa2                	ld	s5,8(sp)
 7f0:	6b02                	ld	s6,0(sp)
 7f2:	a03d                	j	820 <malloc+0xe4>
 7f4:	74a2                	ld	s1,40(sp)
 7f6:	6a42                	ld	s4,16(sp)
 7f8:	6aa2                	ld	s5,8(sp)
 7fa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7fc:	fae90be3          	beq	s2,a4,7b2 <malloc+0x76>
        p->s.size -= nunits;
 800:	4137073b          	subw	a4,a4,s3
 804:	c798                	sw	a4,8(a5)
        p += p->s.size;
 806:	02071693          	slli	a3,a4,0x20
 80a:	01c6d713          	srli	a4,a3,0x1c
 80e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 810:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 814:	00001717          	auipc	a4,0x1
 818:	cea73e23          	sd	a0,-772(a4) # 1510 <freep>
      return (void*)(p + 1);
 81c:	01078513          	addi	a0,a5,16
  }
}
 820:	70e2                	ld	ra,56(sp)
 822:	7442                	ld	s0,48(sp)
 824:	7902                	ld	s2,32(sp)
 826:	69e2                	ld	s3,24(sp)
 828:	6121                	addi	sp,sp,64
 82a:	8082                	ret
 82c:	74a2                	ld	s1,40(sp)
 82e:	6a42                	ld	s4,16(sp)
 830:	6aa2                	ld	s5,8(sp)
 832:	6b02                	ld	s6,0(sp)
 834:	b7f5                	j	820 <malloc+0xe4>

0000000000000836 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 836:	1141                	addi	sp,sp,-16
 838:	e406                	sd	ra,8(sp)
 83a:	e022                	sd	s0,0(sp)
 83c:	0800                	addi	s0,sp,16
  thread_exit(status);
 83e:	2501                	sext.w	a0,a0
 840:	00000097          	auipc	ra,0x0
 844:	b4a080e7          	jalr	-1206(ra) # 38a <thread_exit>
}
 848:	60a2                	ld	ra,8(sp)
 84a:	6402                	ld	s0,0(sp)
 84c:	0141                	addi	sp,sp,16
 84e:	8082                	ret

0000000000000850 <free_stacks>:
int free_stacks() {
 850:	7179                	addi	sp,sp,-48
 852:	f406                	sd	ra,40(sp)
 854:	f022                	sd	s0,32(sp)
 856:	ec26                	sd	s1,24(sp)
 858:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 85a:	00001797          	auipc	a5,0x1
 85e:	cc67a783          	lw	a5,-826(a5) # 1520 <num_threads>
 862:	04f05063          	blez	a5,8a2 <free_stacks+0x52>
 866:	e84a                	sd	s2,16(sp)
 868:	e44e                	sd	s3,8(sp)
 86a:	4481                	li	s1,0
    free(stacks[i]);
 86c:	00001997          	auipc	s3,0x1
 870:	cac98993          	addi	s3,s3,-852 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 874:	00001917          	auipc	s2,0x1
 878:	cac90913          	addi	s2,s2,-852 # 1520 <num_threads>
    free(stacks[i]);
 87c:	0009b783          	ld	a5,0(s3)
 880:	00349713          	slli	a4,s1,0x3
 884:	97ba                	add	a5,a5,a4
 886:	6388                	ld	a0,0(a5)
 888:	00000097          	auipc	ra,0x0
 88c:	e2e080e7          	jalr	-466(ra) # 6b6 <free>
  for (int i = 0; i < num_threads; i++) {
 890:	0485                	addi	s1,s1,1
 892:	00092703          	lw	a4,0(s2)
 896:	0004879b          	sext.w	a5,s1
 89a:	fee7c1e3          	blt	a5,a4,87c <free_stacks+0x2c>
 89e:	6942                	ld	s2,16(sp)
 8a0:	69a2                	ld	s3,8(sp)
  free(stacks);
 8a2:	00001497          	auipc	s1,0x1
 8a6:	c7648493          	addi	s1,s1,-906 # 1518 <stacks>
 8aa:	6088                	ld	a0,0(s1)
 8ac:	00000097          	auipc	ra,0x0
 8b0:	e0a080e7          	jalr	-502(ra) # 6b6 <free>
  stacks = 0;
 8b4:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8b8:	00001797          	auipc	a5,0x1
 8bc:	c607a423          	sw	zero,-920(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8c0:	47a1                	li	a5,8
 8c2:	00001717          	auipc	a4,0x1
 8c6:	c2f72f23          	sw	a5,-962(a4) # 1500 <max_stacks>
  threads_done = 0;
 8ca:	00001797          	auipc	a5,0x1
 8ce:	c407ad23          	sw	zero,-934(a5) # 1524 <threads_done>
}
 8d2:	4501                	li	a0,0
 8d4:	70a2                	ld	ra,40(sp)
 8d6:	7402                	ld	s0,32(sp)
 8d8:	64e2                	ld	s1,24(sp)
 8da:	6145                	addi	sp,sp,48
 8dc:	8082                	ret

00000000000008de <expand_num_threads>:
int expand_num_threads() {
 8de:	1101                	addi	sp,sp,-32
 8e0:	ec06                	sd	ra,24(sp)
 8e2:	e822                	sd	s0,16(sp)
 8e4:	e426                	sd	s1,8(sp)
 8e6:	e04a                	sd	s2,0(sp)
 8e8:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 8ea:	00001797          	auipc	a5,0x1
 8ee:	c1678793          	addi	a5,a5,-1002 # 1500 <max_stacks>
 8f2:	4388                	lw	a0,0(a5)
 8f4:	0015151b          	slliw	a0,a0,0x1
 8f8:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 8fa:	0035151b          	slliw	a0,a0,0x3
 8fe:	00000097          	auipc	ra,0x0
 902:	e3e080e7          	jalr	-450(ra) # 73c <malloc>
 906:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 908:	00001617          	auipc	a2,0x1
 90c:	c1862603          	lw	a2,-1000(a2) # 1520 <num_threads>
 910:	00001497          	auipc	s1,0x1
 914:	c0848493          	addi	s1,s1,-1016 # 1518 <stacks>
 918:	0036161b          	slliw	a2,a2,0x3
 91c:	608c                	ld	a1,0(s1)
 91e:	00000097          	auipc	ra,0x0
 922:	8fe080e7          	jalr	-1794(ra) # 21c <memmove>
  free(stacks);
 926:	6088                	ld	a0,0(s1)
 928:	00000097          	auipc	ra,0x0
 92c:	d8e080e7          	jalr	-626(ra) # 6b6 <free>
  stacks = new_stacks;
 930:	0124b023          	sd	s2,0(s1)
}
 934:	4501                	li	a0,0
 936:	60e2                	ld	ra,24(sp)
 938:	6442                	ld	s0,16(sp)
 93a:	64a2                	ld	s1,8(sp)
 93c:	6902                	ld	s2,0(sp)
 93e:	6105                	addi	sp,sp,32
 940:	8082                	ret

0000000000000942 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 942:	7179                	addi	sp,sp,-48
 944:	f406                	sd	ra,40(sp)
 946:	f022                	sd	s0,32(sp)
 948:	e84a                	sd	s2,16(sp)
 94a:	e44e                	sd	s3,8(sp)
 94c:	1800                	addi	s0,sp,48
 94e:	892a                	mv	s2,a0
 950:	89ae                	mv	s3,a1
  if (stacks == 0) {
 952:	00001797          	auipc	a5,0x1
 956:	bc67b783          	ld	a5,-1082(a5) # 1518 <stacks>
 95a:	c3d9                	beqz	a5,9e0 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 95c:	00001797          	auipc	a5,0x1
 960:	ba47a783          	lw	a5,-1116(a5) # 1500 <max_stacks>
 964:	00001717          	auipc	a4,0x1
 968:	bbc72703          	lw	a4,-1092(a4) # 1520 <num_threads>
 96c:	0af71463          	bne	a4,a5,a14 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 970:	04000713          	li	a4,64
 974:	08e78563          	beq	a5,a4,9fe <ithread_create+0xbc>
 978:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 97a:	00000097          	auipc	ra,0x0
 97e:	f64080e7          	jalr	-156(ra) # 8de <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 982:	6505                	lui	a0,0x1
 984:	00000097          	auipc	ra,0x0
 988:	db8080e7          	jalr	-584(ra) # 73c <malloc>
 98c:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 98e:	00001717          	auipc	a4,0x1
 992:	b9272703          	lw	a4,-1134(a4) # 1520 <num_threads>
 996:	070e                	slli	a4,a4,0x3
 998:	00001797          	auipc	a5,0x1
 99c:	b807b783          	ld	a5,-1152(a5) # 1518 <stacks>
 9a0:	97ba                	add	a5,a5,a4
 9a2:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9a4:	00000697          	auipc	a3,0x0
 9a8:	e9268693          	addi	a3,a3,-366 # 836 <ithread_exit>
 9ac:	862a                	mv	a2,a0
 9ae:	85ce                	mv	a1,s3
 9b0:	854a                	mv	a0,s2
 9b2:	00000097          	auipc	ra,0x0
 9b6:	9c8080e7          	jalr	-1592(ra) # 37a <create_thread>
 9ba:	892a                	mv	s2,a0
  if (res != -1) {
 9bc:	57fd                	li	a5,-1
 9be:	04f50d63          	beq	a0,a5,a18 <ithread_create+0xd6>
    num_threads++;
 9c2:	00001717          	auipc	a4,0x1
 9c6:	b5e70713          	addi	a4,a4,-1186 # 1520 <num_threads>
 9ca:	431c                	lw	a5,0(a4)
 9cc:	2785                	addiw	a5,a5,1
 9ce:	c31c                	sw	a5,0(a4)
 9d0:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 9d2:	854a                	mv	a0,s2
 9d4:	70a2                	ld	ra,40(sp)
 9d6:	7402                	ld	s0,32(sp)
 9d8:	6942                	ld	s2,16(sp)
 9da:	69a2                	ld	s3,8(sp)
 9dc:	6145                	addi	sp,sp,48
 9de:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 9e0:	00001517          	auipc	a0,0x1
 9e4:	b2052503          	lw	a0,-1248(a0) # 1500 <max_stacks>
 9e8:	0035151b          	slliw	a0,a0,0x3
 9ec:	00000097          	auipc	ra,0x0
 9f0:	d50080e7          	jalr	-688(ra) # 73c <malloc>
 9f4:	00001797          	auipc	a5,0x1
 9f8:	b2a7b223          	sd	a0,-1244(a5) # 1518 <stacks>
 9fc:	b785                	j	95c <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 9fe:	00000517          	auipc	a0,0x0
 a02:	09a50513          	addi	a0,a0,154 # a98 <ithread_join+0x5a>
 a06:	00000097          	auipc	ra,0x0
 a0a:	c7a080e7          	jalr	-902(ra) # 680 <printf>
      return -1;
 a0e:	57fd                	li	a5,-1
 a10:	893e                	mv	s2,a5
 a12:	b7c1                	j	9d2 <ithread_create+0x90>
 a14:	ec26                	sd	s1,24(sp)
 a16:	b7b5                	j	982 <ithread_create+0x40>
    free(stack_ptr);
 a18:	8526                	mv	a0,s1
 a1a:	00000097          	auipc	ra,0x0
 a1e:	c9c080e7          	jalr	-868(ra) # 6b6 <free>
    stacks[num_threads] = 0;
 a22:	00001717          	auipc	a4,0x1
 a26:	afe72703          	lw	a4,-1282(a4) # 1520 <num_threads>
 a2a:	070e                	slli	a4,a4,0x3
 a2c:	00001797          	auipc	a5,0x1
 a30:	aec7b783          	ld	a5,-1300(a5) # 1518 <stacks>
 a34:	97ba                	add	a5,a5,a4
 a36:	0007b023          	sd	zero,0(a5)
 a3a:	64e2                	ld	s1,24(sp)
 a3c:	bf59                	j	9d2 <ithread_create+0x90>

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
 a52:	934080e7          	jalr	-1740(ra) # 382 <join_thread>
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
 a80:	dd4080e7          	jalr	-556(ra) # 850 <free_stacks>
 a84:	b7f5                	j	a70 <ithread_join+0x32>
