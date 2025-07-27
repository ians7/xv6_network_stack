
user/_debug:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char **argv) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  unsigned int i;
  int *p = malloc(10 *sizeof(int));
   e:	02800513          	li	a0,40
  12:	00000097          	auipc	ra,0x0
  16:	752080e7          	jalr	1874(ra) # 764 <malloc>
  1a:	892a                	mv	s2,a0

  for(i = 0; i < 10; i++)
  1c:	872a                	mv	a4,a0
  1e:	4781                	li	a5,0
  20:	46a9                	li	a3,10
    p[i] = i;
  22:	c31c                	sw	a5,0(a4)
  for(i = 0; i < 10; i++)
  24:	2785                	addiw	a5,a5,1
  26:	0711                	addi	a4,a4,4
  28:	fed79de3          	bne	a5,a3,22 <main+0x22>

  for(i = 9; i >= 0; i--)
  2c:	44a5                	li	s1,9
    printf("index: %d, value: %d\n", i, p[i]);
  2e:	00001997          	auipc	s3,0x1
  32:	a8298993          	addi	s3,s3,-1406 # ab0 <ithread_join+0x4a>
  36:	02049713          	slli	a4,s1,0x20
  3a:	01e75793          	srli	a5,a4,0x1e
  3e:	97ca                	add	a5,a5,s2
  40:	4390                	lw	a2,0(a5)
  42:	85a6                	mv	a1,s1
  44:	854e                	mv	a0,s3
  46:	00000097          	auipc	ra,0x0
  4a:	662080e7          	jalr	1634(ra) # 6a8 <printf>
  for(i = 9; i >= 0; i--)
  4e:	34fd                	addiw	s1,s1,-1
  50:	b7dd                	j	36 <main+0x36>

0000000000000052 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  52:	1141                	addi	sp,sp,-16
  54:	e406                	sd	ra,8(sp)
  56:	e022                	sd	s0,0(sp)
  58:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5a:	00000097          	auipc	ra,0x0
  5e:	fa6080e7          	jalr	-90(ra) # 0 <main>
  exit(0);
  62:	4501                	li	a0,0
  64:	00000097          	auipc	ra,0x0
  68:	296080e7          	jalr	662(ra) # 2fa <exit>

000000000000006c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e406                	sd	ra,8(sp)
  70:	e022                	sd	s0,0(sp)
  72:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  74:	87aa                	mv	a5,a0
  76:	0585                	addi	a1,a1,1
  78:	0785                	addi	a5,a5,1
  7a:	fff5c703          	lbu	a4,-1(a1)
  7e:	fee78fa3          	sb	a4,-1(a5)
  82:	fb75                	bnez	a4,76 <strcpy+0xa>
    ;
  return os;
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	cb91                	beqz	a5,ac <strcmp+0x20>
  9a:	0005c703          	lbu	a4,0(a1)
  9e:	00f71763          	bne	a4,a5,ac <strcmp+0x20>
    p++, q++;
  a2:	0505                	addi	a0,a0,1
  a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	fbe5                	bnez	a5,9a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ac:	0005c503          	lbu	a0,0(a1)
}
  b0:	40a7853b          	subw	a0,a5,a0
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strlen>:

uint
strlen(const char *s)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cf91                	beqz	a5,e4 <strlen+0x28>
  ca:	00150793          	addi	a5,a0,1
  ce:	86be                	mv	a3,a5
  d0:	0785                	addi	a5,a5,1
  d2:	fff7c703          	lbu	a4,-1(a5)
  d6:	ff65                	bnez	a4,ce <strlen+0x12>
  d8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  dc:	60a2                	ld	ra,8(sp)
  de:	6402                	ld	s0,0(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  for(n = 0; s[n]; n++)
  e4:	4501                	li	a0,0
  e6:	bfdd                	j	dc <strlen+0x20>

00000000000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f0:	ca19                	beqz	a2,106 <memset+0x1e>
  f2:	87aa                	mv	a5,a0
  f4:	1602                	slli	a2,a2,0x20
  f6:	9201                	srli	a2,a2,0x20
  f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 100:	0785                	addi	a5,a5,1
 102:	fee79de3          	bne	a5,a4,fc <memset+0x14>
  }
  return dst;
}
 106:	60a2                	ld	ra,8(sp)
 108:	6402                	ld	s0,0(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret

000000000000010e <strchr>:

char*
strchr(const char *s, char c)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e406                	sd	ra,8(sp)
 112:	e022                	sd	s0,0(sp)
 114:	0800                	addi	s0,sp,16
  for(; *s; s++)
 116:	00054783          	lbu	a5,0(a0)
 11a:	cf81                	beqz	a5,132 <strchr+0x24>
    if(*s == c)
 11c:	00f58763          	beq	a1,a5,12a <strchr+0x1c>
  for(; *s; s++)
 120:	0505                	addi	a0,a0,1
 122:	00054783          	lbu	a5,0(a0)
 126:	fbfd                	bnez	a5,11c <strchr+0xe>
      return (char*)s;
  return 0;
 128:	4501                	li	a0,0
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret
  return 0;
 132:	4501                	li	a0,0
 134:	bfdd                	j	12a <strchr+0x1c>

0000000000000136 <gets>:

char*
gets(char *buf, int max)
{
 136:	711d                	addi	sp,sp,-96
 138:	ec86                	sd	ra,88(sp)
 13a:	e8a2                	sd	s0,80(sp)
 13c:	e4a6                	sd	s1,72(sp)
 13e:	e0ca                	sd	s2,64(sp)
 140:	fc4e                	sd	s3,56(sp)
 142:	f852                	sd	s4,48(sp)
 144:	f456                	sd	s5,40(sp)
 146:	f05a                	sd	s6,32(sp)
 148:	ec5e                	sd	s7,24(sp)
 14a:	e862                	sd	s8,16(sp)
 14c:	1080                	addi	s0,sp,96
 14e:	8baa                	mv	s7,a0
 150:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 152:	892a                	mv	s2,a0
 154:	4481                	li	s1,0
    cc = read(0, &c, 1);
 156:	faf40b13          	addi	s6,s0,-81
 15a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 15c:	8c26                	mv	s8,s1
 15e:	0014899b          	addiw	s3,s1,1
 162:	84ce                	mv	s1,s3
 164:	0349d663          	bge	s3,s4,190 <gets+0x5a>
    cc = read(0, &c, 1);
 168:	8656                	mv	a2,s5
 16a:	85da                	mv	a1,s6
 16c:	4501                	li	a0,0
 16e:	00000097          	auipc	ra,0x0
 172:	1a4080e7          	jalr	420(ra) # 312 <read>
    if(cc < 1)
 176:	00a05d63          	blez	a0,190 <gets+0x5a>
      break;
    buf[i++] = c;
 17a:	faf44783          	lbu	a5,-81(s0)
 17e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 182:	0905                	addi	s2,s2,1
 184:	ff678713          	addi	a4,a5,-10
 188:	c319                	beqz	a4,18e <gets+0x58>
 18a:	17cd                	addi	a5,a5,-13
 18c:	fbe1                	bnez	a5,15c <gets+0x26>
    buf[i++] = c;
 18e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 190:	9c5e                	add	s8,s8,s7
 192:	000c0023          	sb	zero,0(s8)
  return buf;
}
 196:	855e                	mv	a0,s7
 198:	60e6                	ld	ra,88(sp)
 19a:	6446                	ld	s0,80(sp)
 19c:	64a6                	ld	s1,72(sp)
 19e:	6906                	ld	s2,64(sp)
 1a0:	79e2                	ld	s3,56(sp)
 1a2:	7a42                	ld	s4,48(sp)
 1a4:	7aa2                	ld	s5,40(sp)
 1a6:	7b02                	ld	s6,32(sp)
 1a8:	6be2                	ld	s7,24(sp)
 1aa:	6c42                	ld	s8,16(sp)
 1ac:	6125                	addi	sp,sp,96
 1ae:	8082                	ret

00000000000001b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b0:	1101                	addi	sp,sp,-32
 1b2:	ec06                	sd	ra,24(sp)
 1b4:	e822                	sd	s0,16(sp)
 1b6:	e04a                	sd	s2,0(sp)
 1b8:	1000                	addi	s0,sp,32
 1ba:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1bc:	4581                	li	a1,0
 1be:	00000097          	auipc	ra,0x0
 1c2:	17c080e7          	jalr	380(ra) # 33a <open>
  if(fd < 0)
 1c6:	02054663          	bltz	a0,1f2 <stat+0x42>
 1ca:	e426                	sd	s1,8(sp)
 1cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ce:	85ca                	mv	a1,s2
 1d0:	00000097          	auipc	ra,0x0
 1d4:	182080e7          	jalr	386(ra) # 352 <fstat>
 1d8:	892a                	mv	s2,a0
  close(fd);
 1da:	8526                	mv	a0,s1
 1dc:	00000097          	auipc	ra,0x0
 1e0:	146080e7          	jalr	326(ra) # 322 <close>
  return r;
 1e4:	64a2                	ld	s1,8(sp)
}
 1e6:	854a                	mv	a0,s2
 1e8:	60e2                	ld	ra,24(sp)
 1ea:	6442                	ld	s0,16(sp)
 1ec:	6902                	ld	s2,0(sp)
 1ee:	6105                	addi	sp,sp,32
 1f0:	8082                	ret
    return -1;
 1f2:	57fd                	li	a5,-1
 1f4:	893e                	mv	s2,a5
 1f6:	bfc5                	j	1e6 <stat+0x36>

00000000000001f8 <atoi>:

int
atoi(const char *s)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e406                	sd	ra,8(sp)
 1fc:	e022                	sd	s0,0(sp)
 1fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 200:	00054683          	lbu	a3,0(a0)
 204:	fd06879b          	addiw	a5,a3,-48
 208:	0ff7f793          	zext.b	a5,a5
 20c:	4625                	li	a2,9
 20e:	02f66963          	bltu	a2,a5,240 <atoi+0x48>
 212:	872a                	mv	a4,a0
  n = 0;
 214:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 216:	0705                	addi	a4,a4,1
 218:	0025179b          	slliw	a5,a0,0x2
 21c:	9fa9                	addw	a5,a5,a0
 21e:	0017979b          	slliw	a5,a5,0x1
 222:	9fb5                	addw	a5,a5,a3
 224:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 228:	00074683          	lbu	a3,0(a4)
 22c:	fd06879b          	addiw	a5,a3,-48
 230:	0ff7f793          	zext.b	a5,a5
 234:	fef671e3          	bgeu	a2,a5,216 <atoi+0x1e>
  return n;
}
 238:	60a2                	ld	ra,8(sp)
 23a:	6402                	ld	s0,0(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  n = 0;
 240:	4501                	li	a0,0
 242:	bfdd                	j	238 <atoi+0x40>

0000000000000244 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57563          	bgeu	a0,a1,276 <memmove+0x32>
    while(n-- > 0)
 250:	00c05f63          	blez	a2,26e <memmove+0x2a>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25c:	872a                	mv	a4,a0
      *dst++ = *src++;
 25e:	0585                	addi	a1,a1,1
 260:	0705                	addi	a4,a4,1
 262:	fff5c683          	lbu	a3,-1(a1)
 266:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26a:	fee79ae3          	bne	a5,a4,25e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26e:	60a2                	ld	ra,8(sp)
 270:	6402                	ld	s0,0(sp)
 272:	0141                	addi	sp,sp,16
 274:	8082                	ret
    while(n-- > 0)
 276:	fec05ce3          	blez	a2,26e <memmove+0x2a>
    dst += n;
 27a:	00c50733          	add	a4,a0,a2
    src += n;
 27e:	95b2                	add	a1,a1,a2
 280:	fff6079b          	addiw	a5,a2,-1
 284:	1782                	slli	a5,a5,0x20
 286:	9381                	srli	a5,a5,0x20
 288:	fff7c793          	not	a5,a5
 28c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28e:	15fd                	addi	a1,a1,-1
 290:	177d                	addi	a4,a4,-1
 292:	0005c683          	lbu	a3,0(a1)
 296:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 29a:	fef71ae3          	bne	a4,a5,28e <memmove+0x4a>
 29e:	bfc1                	j	26e <memmove+0x2a>

00000000000002a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a8:	c61d                	beqz	a2,2d6 <memcmp+0x36>
 2aa:	1602                	slli	a2,a2,0x20
 2ac:	9201                	srli	a2,a2,0x20
 2ae:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	0005c703          	lbu	a4,0(a1)
 2ba:	00e79863          	bne	a5,a4,2ca <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2be:	0505                	addi	a0,a0,1
    p2++;
 2c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c2:	fed518e3          	bne	a0,a3,2b2 <memcmp+0x12>
  }
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	a019                	j	2ce <memcmp+0x2e>
      return *p1 - *p2;
 2ca:	40e7853b          	subw	a0,a5,a4
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
  return 0;
 2d6:	4501                	li	a0,0
 2d8:	bfdd                	j	2ce <memcmp+0x2e>

00000000000002da <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e2:	00000097          	auipc	ra,0x0
 2e6:	f62080e7          	jalr	-158(ra) # 244 <memmove>
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f2:	4885                	li	a7,1
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fa:	4889                	li	a7,2
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <wait>:
.global wait
wait:
 li a7, SYS_wait
 302:	488d                	li	a7,3
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30a:	4891                	li	a7,4
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <read>:
.global read
read:
 li a7, SYS_read
 312:	4895                	li	a7,5
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <write>:
.global write
write:
 li a7, SYS_write
 31a:	48c1                	li	a7,16
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <close>:
.global close
close:
 li a7, SYS_close
 322:	48d5                	li	a7,21
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <kill>:
.global kill
kill:
 li a7, SYS_kill
 32a:	4899                	li	a7,6
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <exec>:
.global exec
exec:
 li a7, SYS_exec
 332:	489d                	li	a7,7
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <open>:
.global open
open:
 li a7, SYS_open
 33a:	48bd                	li	a7,15
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 342:	48c5                	li	a7,17
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34a:	48c9                	li	a7,18
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 352:	48a1                	li	a7,8
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <link>:
.global link
link:
 li a7, SYS_link
 35a:	48cd                	li	a7,19
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 362:	48d1                	li	a7,20
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36a:	48a5                	li	a7,9
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <dup>:
.global dup
dup:
 li a7, SYS_dup
 372:	48a9                	li	a7,10
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37a:	48ad                	li	a7,11
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 382:	48b1                	li	a7,12
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38a:	48b5                	li	a7,13
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 392:	48b9                	li	a7,14
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 39a:	48d9                	li	a7,22
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3a2:	48dd                	li	a7,23
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3aa:	48e1                	li	a7,24
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3b2:	48e5                	li	a7,25
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <socket>:
.global socket
socket:
 li a7, SYS_socket
 3ba:	48e9                	li	a7,26
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3c2:	48ed                	li	a7,27
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <accept>:
.global accept
accept:
 li a7, SYS_accept
 3ca:	48f5                	li	a7,29
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <listen>:
.global listen
listen:
 li a7, SYS_listen
 3d2:	48f1                	li	a7,28
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <connect>:
.global connect
connect:
 li a7, SYS_connect
 3da:	48f9                	li	a7,30
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e2:	1101                	addi	sp,sp,-32
 3e4:	ec06                	sd	ra,24(sp)
 3e6:	e822                	sd	s0,16(sp)
 3e8:	1000                	addi	s0,sp,32
 3ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ee:	4605                	li	a2,1
 3f0:	fef40593          	addi	a1,s0,-17
 3f4:	00000097          	auipc	ra,0x0
 3f8:	f26080e7          	jalr	-218(ra) # 31a <write>
}
 3fc:	60e2                	ld	ra,24(sp)
 3fe:	6442                	ld	s0,16(sp)
 400:	6105                	addi	sp,sp,32
 402:	8082                	ret

0000000000000404 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 404:	7139                	addi	sp,sp,-64
 406:	fc06                	sd	ra,56(sp)
 408:	f822                	sd	s0,48(sp)
 40a:	f04a                	sd	s2,32(sp)
 40c:	ec4e                	sd	s3,24(sp)
 40e:	0080                	addi	s0,sp,64
 410:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 412:	cad9                	beqz	a3,4a8 <printint+0xa4>
 414:	01f5d79b          	srliw	a5,a1,0x1f
 418:	cbc1                	beqz	a5,4a8 <printint+0xa4>
    neg = 1;
    x = -xx;
 41a:	40b005bb          	negw	a1,a1
    neg = 1;
 41e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 420:	fc040993          	addi	s3,s0,-64
  neg = 0;
 424:	86ce                	mv	a3,s3
  i = 0;
 426:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 428:	00000817          	auipc	a6,0x0
 42c:	73080813          	addi	a6,a6,1840 # b58 <digits>
 430:	88ba                	mv	a7,a4
 432:	0017051b          	addiw	a0,a4,1
 436:	872a                	mv	a4,a0
 438:	02c5f7bb          	remuw	a5,a1,a2
 43c:	1782                	slli	a5,a5,0x20
 43e:	9381                	srli	a5,a5,0x20
 440:	97c2                	add	a5,a5,a6
 442:	0007c783          	lbu	a5,0(a5)
 446:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 44a:	87ae                	mv	a5,a1
 44c:	02c5d5bb          	divuw	a1,a1,a2
 450:	0685                	addi	a3,a3,1
 452:	fcc7ffe3          	bgeu	a5,a2,430 <printint+0x2c>
  if(neg)
 456:	00030c63          	beqz	t1,46e <printint+0x6a>
    buf[i++] = '-';
 45a:	fd050793          	addi	a5,a0,-48
 45e:	00878533          	add	a0,a5,s0
 462:	02d00793          	li	a5,45
 466:	fef50823          	sb	a5,-16(a0)
 46a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 46e:	02e05763          	blez	a4,49c <printint+0x98>
 472:	f426                	sd	s1,40(sp)
 474:	377d                	addiw	a4,a4,-1
 476:	00e984b3          	add	s1,s3,a4
 47a:	19fd                	addi	s3,s3,-1
 47c:	99ba                	add	s3,s3,a4
 47e:	1702                	slli	a4,a4,0x20
 480:	9301                	srli	a4,a4,0x20
 482:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 486:	0004c583          	lbu	a1,0(s1)
 48a:	854a                	mv	a0,s2
 48c:	00000097          	auipc	ra,0x0
 490:	f56080e7          	jalr	-170(ra) # 3e2 <putc>
  while(--i >= 0)
 494:	14fd                	addi	s1,s1,-1
 496:	ff3498e3          	bne	s1,s3,486 <printint+0x82>
 49a:	74a2                	ld	s1,40(sp)
}
 49c:	70e2                	ld	ra,56(sp)
 49e:	7442                	ld	s0,48(sp)
 4a0:	7902                	ld	s2,32(sp)
 4a2:	69e2                	ld	s3,24(sp)
 4a4:	6121                	addi	sp,sp,64
 4a6:	8082                	ret
  neg = 0;
 4a8:	4301                	li	t1,0
 4aa:	bf9d                	j	420 <printint+0x1c>

00000000000004ac <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ac:	715d                	addi	sp,sp,-80
 4ae:	e486                	sd	ra,72(sp)
 4b0:	e0a2                	sd	s0,64(sp)
 4b2:	f84a                	sd	s2,48(sp)
 4b4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b6:	0005c903          	lbu	s2,0(a1)
 4ba:	1a090b63          	beqz	s2,670 <vprintf+0x1c4>
 4be:	fc26                	sd	s1,56(sp)
 4c0:	f44e                	sd	s3,40(sp)
 4c2:	f052                	sd	s4,32(sp)
 4c4:	ec56                	sd	s5,24(sp)
 4c6:	e85a                	sd	s6,16(sp)
 4c8:	e45e                	sd	s7,8(sp)
 4ca:	8aaa                	mv	s5,a0
 4cc:	8bb2                	mv	s7,a2
 4ce:	00158493          	addi	s1,a1,1
  state = 0;
 4d2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d4:	02500a13          	li	s4,37
 4d8:	4b55                	li	s6,21
 4da:	a839                	j	4f8 <vprintf+0x4c>
        putc(fd, c);
 4dc:	85ca                	mv	a1,s2
 4de:	8556                	mv	a0,s5
 4e0:	00000097          	auipc	ra,0x0
 4e4:	f02080e7          	jalr	-254(ra) # 3e2 <putc>
 4e8:	a019                	j	4ee <vprintf+0x42>
    } else if(state == '%'){
 4ea:	01498d63          	beq	s3,s4,504 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4ee:	0485                	addi	s1,s1,1
 4f0:	fff4c903          	lbu	s2,-1(s1)
 4f4:	16090863          	beqz	s2,664 <vprintf+0x1b8>
    if(state == 0){
 4f8:	fe0999e3          	bnez	s3,4ea <vprintf+0x3e>
      if(c == '%'){
 4fc:	ff4910e3          	bne	s2,s4,4dc <vprintf+0x30>
        state = '%';
 500:	89d2                	mv	s3,s4
 502:	b7f5                	j	4ee <vprintf+0x42>
      if(c == 'd'){
 504:	13490563          	beq	s2,s4,62e <vprintf+0x182>
 508:	f9d9079b          	addiw	a5,s2,-99
 50c:	0ff7f793          	zext.b	a5,a5
 510:	12fb6863          	bltu	s6,a5,640 <vprintf+0x194>
 514:	f9d9079b          	addiw	a5,s2,-99
 518:	0ff7f713          	zext.b	a4,a5
 51c:	12eb6263          	bltu	s6,a4,640 <vprintf+0x194>
 520:	00271793          	slli	a5,a4,0x2
 524:	00000717          	auipc	a4,0x0
 528:	5dc70713          	addi	a4,a4,1500 # b00 <ithread_join+0x9a>
 52c:	97ba                	add	a5,a5,a4
 52e:	439c                	lw	a5,0(a5)
 530:	97ba                	add	a5,a5,a4
 532:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 534:	008b8913          	addi	s2,s7,8
 538:	4685                	li	a3,1
 53a:	4629                	li	a2,10
 53c:	000ba583          	lw	a1,0(s7)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	ec2080e7          	jalr	-318(ra) # 404 <printint>
 54a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b745                	j	4ee <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 550:	008b8913          	addi	s2,s7,8
 554:	4681                	li	a3,0
 556:	4629                	li	a2,10
 558:	000ba583          	lw	a1,0(s7)
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	ea6080e7          	jalr	-346(ra) # 404 <printint>
 566:	8bca                	mv	s7,s2
      state = 0;
 568:	4981                	li	s3,0
 56a:	b751                	j	4ee <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 56c:	008b8913          	addi	s2,s7,8
 570:	4681                	li	a3,0
 572:	4641                	li	a2,16
 574:	000ba583          	lw	a1,0(s7)
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e8a080e7          	jalr	-374(ra) # 404 <printint>
 582:	8bca                	mv	s7,s2
      state = 0;
 584:	4981                	li	s3,0
 586:	b7a5                	j	4ee <vprintf+0x42>
 588:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 58a:	008b8793          	addi	a5,s7,8
 58e:	8c3e                	mv	s8,a5
 590:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 594:	03000593          	li	a1,48
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	e48080e7          	jalr	-440(ra) # 3e2 <putc>
  putc(fd, 'x');
 5a2:	07800593          	li	a1,120
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	e3a080e7          	jalr	-454(ra) # 3e2 <putc>
 5b0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b2:	00000b97          	auipc	s7,0x0
 5b6:	5a6b8b93          	addi	s7,s7,1446 # b58 <digits>
 5ba:	03c9d793          	srli	a5,s3,0x3c
 5be:	97de                	add	a5,a5,s7
 5c0:	0007c583          	lbu	a1,0(a5)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e1c080e7          	jalr	-484(ra) # 3e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ce:	0992                	slli	s3,s3,0x4
 5d0:	397d                	addiw	s2,s2,-1
 5d2:	fe0914e3          	bnez	s2,5ba <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5d6:	8be2                	mv	s7,s8
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	6c02                	ld	s8,0(sp)
 5dc:	bf09                	j	4ee <vprintf+0x42>
        s = va_arg(ap, char*);
 5de:	008b8993          	addi	s3,s7,8
 5e2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5e6:	02090163          	beqz	s2,608 <vprintf+0x15c>
        while(*s != 0){
 5ea:	00094583          	lbu	a1,0(s2)
 5ee:	c9a5                	beqz	a1,65e <vprintf+0x1b2>
          putc(fd, *s);
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	df0080e7          	jalr	-528(ra) # 3e2 <putc>
          s++;
 5fa:	0905                	addi	s2,s2,1
        while(*s != 0){
 5fc:	00094583          	lbu	a1,0(s2)
 600:	f9e5                	bnez	a1,5f0 <vprintf+0x144>
        s = va_arg(ap, char*);
 602:	8bce                	mv	s7,s3
      state = 0;
 604:	4981                	li	s3,0
 606:	b5e5                	j	4ee <vprintf+0x42>
          s = "(null)";
 608:	00000917          	auipc	s2,0x0
 60c:	4c090913          	addi	s2,s2,1216 # ac8 <ithread_join+0x62>
        while(*s != 0){
 610:	02800593          	li	a1,40
 614:	bff1                	j	5f0 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 616:	008b8913          	addi	s2,s7,8
 61a:	000bc583          	lbu	a1,0(s7)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	dc2080e7          	jalr	-574(ra) # 3e2 <putc>
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b5c9                	j	4ee <vprintf+0x42>
        putc(fd, c);
 62e:	02500593          	li	a1,37
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	dae080e7          	jalr	-594(ra) # 3e2 <putc>
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bd45                	j	4ee <vprintf+0x42>
        putc(fd, '%');
 640:	02500593          	li	a1,37
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	d9c080e7          	jalr	-612(ra) # 3e2 <putc>
        putc(fd, c);
 64e:	85ca                	mv	a1,s2
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	d90080e7          	jalr	-624(ra) # 3e2 <putc>
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bd49                	j	4ee <vprintf+0x42>
        s = va_arg(ap, char*);
 65e:	8bce                	mv	s7,s3
      state = 0;
 660:	4981                	li	s3,0
 662:	b571                	j	4ee <vprintf+0x42>
 664:	74e2                	ld	s1,56(sp)
 666:	79a2                	ld	s3,40(sp)
 668:	7a02                	ld	s4,32(sp)
 66a:	6ae2                	ld	s5,24(sp)
 66c:	6b42                	ld	s6,16(sp)
 66e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 670:	60a6                	ld	ra,72(sp)
 672:	6406                	ld	s0,64(sp)
 674:	7942                	ld	s2,48(sp)
 676:	6161                	addi	sp,sp,80
 678:	8082                	ret

000000000000067a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 67a:	715d                	addi	sp,sp,-80
 67c:	ec06                	sd	ra,24(sp)
 67e:	e822                	sd	s0,16(sp)
 680:	1000                	addi	s0,sp,32
 682:	e010                	sd	a2,0(s0)
 684:	e414                	sd	a3,8(s0)
 686:	e818                	sd	a4,16(s0)
 688:	ec1c                	sd	a5,24(s0)
 68a:	03043023          	sd	a6,32(s0)
 68e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 692:	8622                	mv	a2,s0
 694:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 698:	00000097          	auipc	ra,0x0
 69c:	e14080e7          	jalr	-492(ra) # 4ac <vprintf>
}
 6a0:	60e2                	ld	ra,24(sp)
 6a2:	6442                	ld	s0,16(sp)
 6a4:	6161                	addi	sp,sp,80
 6a6:	8082                	ret

00000000000006a8 <printf>:

void
printf(const char *fmt, ...)
{
 6a8:	711d                	addi	sp,sp,-96
 6aa:	ec06                	sd	ra,24(sp)
 6ac:	e822                	sd	s0,16(sp)
 6ae:	1000                	addi	s0,sp,32
 6b0:	e40c                	sd	a1,8(s0)
 6b2:	e810                	sd	a2,16(s0)
 6b4:	ec14                	sd	a3,24(s0)
 6b6:	f018                	sd	a4,32(s0)
 6b8:	f41c                	sd	a5,40(s0)
 6ba:	03043823          	sd	a6,48(s0)
 6be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c2:	00840613          	addi	a2,s0,8
 6c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ca:	85aa                	mv	a1,a0
 6cc:	4505                	li	a0,1
 6ce:	00000097          	auipc	ra,0x0
 6d2:	dde080e7          	jalr	-546(ra) # 4ac <vprintf>
}
 6d6:	60e2                	ld	ra,24(sp)
 6d8:	6442                	ld	s0,16(sp)
 6da:	6125                	addi	sp,sp,96
 6dc:	8082                	ret

00000000000006de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6de:	1141                	addi	sp,sp,-16
 6e0:	e406                	sd	ra,8(sp)
 6e2:	e022                	sd	s0,0(sp)
 6e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ea:	00001797          	auipc	a5,0x1
 6ee:	e267b783          	ld	a5,-474(a5) # 1510 <freep>
 6f2:	a039                	j	700 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f4:	6398                	ld	a4,0(a5)
 6f6:	00e7e463          	bltu	a5,a4,6fe <free+0x20>
 6fa:	00e6ea63          	bltu	a3,a4,70e <free+0x30>
{
 6fe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	fed7fae3          	bgeu	a5,a3,6f4 <free+0x16>
 704:	6398                	ld	a4,0(a5)
 706:	00e6e463          	bltu	a3,a4,70e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	fee7eae3          	bltu	a5,a4,6fe <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 70e:	ff852583          	lw	a1,-8(a0)
 712:	6390                	ld	a2,0(a5)
 714:	02059813          	slli	a6,a1,0x20
 718:	01c85713          	srli	a4,a6,0x1c
 71c:	9736                	add	a4,a4,a3
 71e:	02e60563          	beq	a2,a4,748 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 722:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 726:	4790                	lw	a2,8(a5)
 728:	02061593          	slli	a1,a2,0x20
 72c:	01c5d713          	srli	a4,a1,0x1c
 730:	973e                	add	a4,a4,a5
 732:	02e68263          	beq	a3,a4,756 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 736:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 738:	00001717          	auipc	a4,0x1
 73c:	dcf73c23          	sd	a5,-552(a4) # 1510 <freep>
}
 740:	60a2                	ld	ra,8(sp)
 742:	6402                	ld	s0,0(sp)
 744:	0141                	addi	sp,sp,16
 746:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 748:	4618                	lw	a4,8(a2)
 74a:	9f2d                	addw	a4,a4,a1
 74c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	6398                	ld	a4,0(a5)
 752:	6310                	ld	a2,0(a4)
 754:	b7f9                	j	722 <free+0x44>
    p->s.size += bp->s.size;
 756:	ff852703          	lw	a4,-8(a0)
 75a:	9f31                	addw	a4,a4,a2
 75c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 75e:	ff053683          	ld	a3,-16(a0)
 762:	bfd1                	j	736 <free+0x58>

0000000000000764 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 764:	7139                	addi	sp,sp,-64
 766:	fc06                	sd	ra,56(sp)
 768:	f822                	sd	s0,48(sp)
 76a:	f04a                	sd	s2,32(sp)
 76c:	ec4e                	sd	s3,24(sp)
 76e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 770:	02051993          	slli	s3,a0,0x20
 774:	0209d993          	srli	s3,s3,0x20
 778:	09bd                	addi	s3,s3,15
 77a:	0049d993          	srli	s3,s3,0x4
 77e:	2985                	addiw	s3,s3,1
 780:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 782:	00001517          	auipc	a0,0x1
 786:	d8e53503          	ld	a0,-626(a0) # 1510 <freep>
 78a:	c905                	beqz	a0,7ba <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78e:	4798                	lw	a4,8(a5)
 790:	09377a63          	bgeu	a4,s3,824 <malloc+0xc0>
 794:	f426                	sd	s1,40(sp)
 796:	e852                	sd	s4,16(sp)
 798:	e456                	sd	s5,8(sp)
 79a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 79c:	8a4e                	mv	s4,s3
 79e:	6705                	lui	a4,0x1
 7a0:	00e9f363          	bgeu	s3,a4,7a6 <malloc+0x42>
 7a4:	6a05                	lui	s4,0x1
 7a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7aa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ae:	00001497          	auipc	s1,0x1
 7b2:	d6248493          	addi	s1,s1,-670 # 1510 <freep>
  if(p == (char*)-1)
 7b6:	5afd                	li	s5,-1
 7b8:	a089                	j	7fa <malloc+0x96>
 7ba:	f426                	sd	s1,40(sp)
 7bc:	e852                	sd	s4,16(sp)
 7be:	e456                	sd	s5,8(sp)
 7c0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7c2:	00001797          	auipc	a5,0x1
 7c6:	d6e78793          	addi	a5,a5,-658 # 1530 <base>
 7ca:	00001717          	auipc	a4,0x1
 7ce:	d4f73323          	sd	a5,-698(a4) # 1510 <freep>
 7d2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d8:	b7d1                	j	79c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7da:	6398                	ld	a4,0(a5)
 7dc:	e118                	sd	a4,0(a0)
 7de:	a8b9                	j	83c <malloc+0xd8>
  hp->s.size = nu;
 7e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7e4:	0541                	addi	a0,a0,16
 7e6:	00000097          	auipc	ra,0x0
 7ea:	ef8080e7          	jalr	-264(ra) # 6de <free>
  return freep;
 7ee:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7f0:	c135                	beqz	a0,854 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f4:	4798                	lw	a4,8(a5)
 7f6:	03277363          	bgeu	a4,s2,81c <malloc+0xb8>
    if(p == freep)
 7fa:	6098                	ld	a4,0(s1)
 7fc:	853e                	mv	a0,a5
 7fe:	fef71ae3          	bne	a4,a5,7f2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 802:	8552                	mv	a0,s4
 804:	00000097          	auipc	ra,0x0
 808:	b7e080e7          	jalr	-1154(ra) # 382 <sbrk>
  if(p == (char*)-1)
 80c:	fd551ae3          	bne	a0,s5,7e0 <malloc+0x7c>
        return 0;
 810:	4501                	li	a0,0
 812:	74a2                	ld	s1,40(sp)
 814:	6a42                	ld	s4,16(sp)
 816:	6aa2                	ld	s5,8(sp)
 818:	6b02                	ld	s6,0(sp)
 81a:	a03d                	j	848 <malloc+0xe4>
 81c:	74a2                	ld	s1,40(sp)
 81e:	6a42                	ld	s4,16(sp)
 820:	6aa2                	ld	s5,8(sp)
 822:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 824:	fae90be3          	beq	s2,a4,7da <malloc+0x76>
        p->s.size -= nunits;
 828:	4137073b          	subw	a4,a4,s3
 82c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 82e:	02071693          	slli	a3,a4,0x20
 832:	01c6d713          	srli	a4,a3,0x1c
 836:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 838:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 83c:	00001717          	auipc	a4,0x1
 840:	cca73a23          	sd	a0,-812(a4) # 1510 <freep>
      return (void*)(p + 1);
 844:	01078513          	addi	a0,a5,16
  }
}
 848:	70e2                	ld	ra,56(sp)
 84a:	7442                	ld	s0,48(sp)
 84c:	7902                	ld	s2,32(sp)
 84e:	69e2                	ld	s3,24(sp)
 850:	6121                	addi	sp,sp,64
 852:	8082                	ret
 854:	74a2                	ld	s1,40(sp)
 856:	6a42                	ld	s4,16(sp)
 858:	6aa2                	ld	s5,8(sp)
 85a:	6b02                	ld	s6,0(sp)
 85c:	b7f5                	j	848 <malloc+0xe4>

000000000000085e <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 85e:	1141                	addi	sp,sp,-16
 860:	e406                	sd	ra,8(sp)
 862:	e022                	sd	s0,0(sp)
 864:	0800                	addi	s0,sp,16
  thread_exit(status);
 866:	2501                	sext.w	a0,a0
 868:	00000097          	auipc	ra,0x0
 86c:	b4a080e7          	jalr	-1206(ra) # 3b2 <thread_exit>
}
 870:	60a2                	ld	ra,8(sp)
 872:	6402                	ld	s0,0(sp)
 874:	0141                	addi	sp,sp,16
 876:	8082                	ret

0000000000000878 <free_stacks>:
int free_stacks() {
 878:	7179                	addi	sp,sp,-48
 87a:	f406                	sd	ra,40(sp)
 87c:	f022                	sd	s0,32(sp)
 87e:	ec26                	sd	s1,24(sp)
 880:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 882:	00001797          	auipc	a5,0x1
 886:	c9e7a783          	lw	a5,-866(a5) # 1520 <num_threads>
 88a:	04f05063          	blez	a5,8ca <free_stacks+0x52>
 88e:	e84a                	sd	s2,16(sp)
 890:	e44e                	sd	s3,8(sp)
 892:	4481                	li	s1,0
    free(stacks[i]);
 894:	00001997          	auipc	s3,0x1
 898:	c8498993          	addi	s3,s3,-892 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 89c:	00001917          	auipc	s2,0x1
 8a0:	c8490913          	addi	s2,s2,-892 # 1520 <num_threads>
    free(stacks[i]);
 8a4:	0009b783          	ld	a5,0(s3)
 8a8:	00349713          	slli	a4,s1,0x3
 8ac:	97ba                	add	a5,a5,a4
 8ae:	6388                	ld	a0,0(a5)
 8b0:	00000097          	auipc	ra,0x0
 8b4:	e2e080e7          	jalr	-466(ra) # 6de <free>
  for (int i = 0; i < num_threads; i++) {
 8b8:	0485                	addi	s1,s1,1
 8ba:	00092703          	lw	a4,0(s2)
 8be:	0004879b          	sext.w	a5,s1
 8c2:	fee7c1e3          	blt	a5,a4,8a4 <free_stacks+0x2c>
 8c6:	6942                	ld	s2,16(sp)
 8c8:	69a2                	ld	s3,8(sp)
  free(stacks);
 8ca:	00001497          	auipc	s1,0x1
 8ce:	c4e48493          	addi	s1,s1,-946 # 1518 <stacks>
 8d2:	6088                	ld	a0,0(s1)
 8d4:	00000097          	auipc	ra,0x0
 8d8:	e0a080e7          	jalr	-502(ra) # 6de <free>
  stacks = 0;
 8dc:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8e0:	00001797          	auipc	a5,0x1
 8e4:	c407a023          	sw	zero,-960(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8e8:	47a1                	li	a5,8
 8ea:	00001717          	auipc	a4,0x1
 8ee:	c0f72b23          	sw	a5,-1002(a4) # 1500 <max_stacks>
  threads_done = 0;
 8f2:	00001797          	auipc	a5,0x1
 8f6:	c207a923          	sw	zero,-974(a5) # 1524 <threads_done>
}
 8fa:	4501                	li	a0,0
 8fc:	70a2                	ld	ra,40(sp)
 8fe:	7402                	ld	s0,32(sp)
 900:	64e2                	ld	s1,24(sp)
 902:	6145                	addi	sp,sp,48
 904:	8082                	ret

0000000000000906 <expand_num_threads>:
int expand_num_threads() {
 906:	1101                	addi	sp,sp,-32
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	e426                	sd	s1,8(sp)
 90e:	e04a                	sd	s2,0(sp)
 910:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 912:	00001797          	auipc	a5,0x1
 916:	bee78793          	addi	a5,a5,-1042 # 1500 <max_stacks>
 91a:	4388                	lw	a0,0(a5)
 91c:	0015151b          	slliw	a0,a0,0x1
 920:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 922:	0035151b          	slliw	a0,a0,0x3
 926:	00000097          	auipc	ra,0x0
 92a:	e3e080e7          	jalr	-450(ra) # 764 <malloc>
 92e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 930:	00001617          	auipc	a2,0x1
 934:	bf062603          	lw	a2,-1040(a2) # 1520 <num_threads>
 938:	00001497          	auipc	s1,0x1
 93c:	be048493          	addi	s1,s1,-1056 # 1518 <stacks>
 940:	0036161b          	slliw	a2,a2,0x3
 944:	608c                	ld	a1,0(s1)
 946:	00000097          	auipc	ra,0x0
 94a:	8fe080e7          	jalr	-1794(ra) # 244 <memmove>
  free(stacks);
 94e:	6088                	ld	a0,0(s1)
 950:	00000097          	auipc	ra,0x0
 954:	d8e080e7          	jalr	-626(ra) # 6de <free>
  stacks = new_stacks;
 958:	0124b023          	sd	s2,0(s1)
}
 95c:	4501                	li	a0,0
 95e:	60e2                	ld	ra,24(sp)
 960:	6442                	ld	s0,16(sp)
 962:	64a2                	ld	s1,8(sp)
 964:	6902                	ld	s2,0(sp)
 966:	6105                	addi	sp,sp,32
 968:	8082                	ret

000000000000096a <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 96a:	7179                	addi	sp,sp,-48
 96c:	f406                	sd	ra,40(sp)
 96e:	f022                	sd	s0,32(sp)
 970:	e84a                	sd	s2,16(sp)
 972:	e44e                	sd	s3,8(sp)
 974:	1800                	addi	s0,sp,48
 976:	892a                	mv	s2,a0
 978:	89ae                	mv	s3,a1
  if (stacks == 0) {
 97a:	00001797          	auipc	a5,0x1
 97e:	b9e7b783          	ld	a5,-1122(a5) # 1518 <stacks>
 982:	c3d9                	beqz	a5,a08 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 984:	00001797          	auipc	a5,0x1
 988:	b7c7a783          	lw	a5,-1156(a5) # 1500 <max_stacks>
 98c:	00001717          	auipc	a4,0x1
 990:	b9472703          	lw	a4,-1132(a4) # 1520 <num_threads>
 994:	0af71463          	bne	a4,a5,a3c <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 998:	04000713          	li	a4,64
 99c:	08e78563          	beq	a5,a4,a26 <ithread_create+0xbc>
 9a0:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9a2:	00000097          	auipc	ra,0x0
 9a6:	f64080e7          	jalr	-156(ra) # 906 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9aa:	6505                	lui	a0,0x1
 9ac:	00000097          	auipc	ra,0x0
 9b0:	db8080e7          	jalr	-584(ra) # 764 <malloc>
 9b4:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9b6:	00001717          	auipc	a4,0x1
 9ba:	b6a72703          	lw	a4,-1174(a4) # 1520 <num_threads>
 9be:	070e                	slli	a4,a4,0x3
 9c0:	00001797          	auipc	a5,0x1
 9c4:	b587b783          	ld	a5,-1192(a5) # 1518 <stacks>
 9c8:	97ba                	add	a5,a5,a4
 9ca:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9cc:	00000697          	auipc	a3,0x0
 9d0:	e9268693          	addi	a3,a3,-366 # 85e <ithread_exit>
 9d4:	862a                	mv	a2,a0
 9d6:	85ce                	mv	a1,s3
 9d8:	854a                	mv	a0,s2
 9da:	00000097          	auipc	ra,0x0
 9de:	9c8080e7          	jalr	-1592(ra) # 3a2 <create_thread>
 9e2:	892a                	mv	s2,a0
  if (res != -1) {
 9e4:	57fd                	li	a5,-1
 9e6:	04f50d63          	beq	a0,a5,a40 <ithread_create+0xd6>
    num_threads++;
 9ea:	00001717          	auipc	a4,0x1
 9ee:	b3670713          	addi	a4,a4,-1226 # 1520 <num_threads>
 9f2:	431c                	lw	a5,0(a4)
 9f4:	2785                	addiw	a5,a5,1
 9f6:	c31c                	sw	a5,0(a4)
 9f8:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 9fa:	854a                	mv	a0,s2
 9fc:	70a2                	ld	ra,40(sp)
 9fe:	7402                	ld	s0,32(sp)
 a00:	6942                	ld	s2,16(sp)
 a02:	69a2                	ld	s3,8(sp)
 a04:	6145                	addi	sp,sp,48
 a06:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a08:	00001517          	auipc	a0,0x1
 a0c:	af852503          	lw	a0,-1288(a0) # 1500 <max_stacks>
 a10:	0035151b          	slliw	a0,a0,0x3
 a14:	00000097          	auipc	ra,0x0
 a18:	d50080e7          	jalr	-688(ra) # 764 <malloc>
 a1c:	00001797          	auipc	a5,0x1
 a20:	aea7be23          	sd	a0,-1284(a5) # 1518 <stacks>
 a24:	b785                	j	984 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a26:	00000517          	auipc	a0,0x0
 a2a:	0aa50513          	addi	a0,a0,170 # ad0 <ithread_join+0x6a>
 a2e:	00000097          	auipc	ra,0x0
 a32:	c7a080e7          	jalr	-902(ra) # 6a8 <printf>
      return -1;
 a36:	57fd                	li	a5,-1
 a38:	893e                	mv	s2,a5
 a3a:	b7c1                	j	9fa <ithread_create+0x90>
 a3c:	ec26                	sd	s1,24(sp)
 a3e:	b7b5                	j	9aa <ithread_create+0x40>
    free(stack_ptr);
 a40:	8526                	mv	a0,s1
 a42:	00000097          	auipc	ra,0x0
 a46:	c9c080e7          	jalr	-868(ra) # 6de <free>
    stacks[num_threads] = 0;
 a4a:	00001717          	auipc	a4,0x1
 a4e:	ad672703          	lw	a4,-1322(a4) # 1520 <num_threads>
 a52:	070e                	slli	a4,a4,0x3
 a54:	00001797          	auipc	a5,0x1
 a58:	ac47b783          	ld	a5,-1340(a5) # 1518 <stacks>
 a5c:	97ba                	add	a5,a5,a4
 a5e:	0007b023          	sd	zero,0(a5)
 a62:	64e2                	ld	s1,24(sp)
 a64:	bf59                	j	9fa <ithread_create+0x90>

0000000000000a66 <ithread_join>:

int ithread_join(int thread_id) {
 a66:	1101                	addi	sp,sp,-32
 a68:	ec06                	sd	ra,24(sp)
 a6a:	e822                	sd	s0,16(sp)
 a6c:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a6e:	ff040793          	addi	a5,s0,-16
 a72:	ffc7859b          	addiw	a1,a5,-4
 a76:	00000097          	auipc	ra,0x0
 a7a:	934080e7          	jalr	-1740(ra) # 3aa <join_thread>
  threads_done++;
 a7e:	00001717          	auipc	a4,0x1
 a82:	aa670713          	addi	a4,a4,-1370 # 1524 <threads_done>
 a86:	431c                	lw	a5,0(a4)
 a88:	2785                	addiw	a5,a5,1
 a8a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a8c:	00001717          	auipc	a4,0x1
 a90:	a9472703          	lw	a4,-1388(a4) # 1520 <num_threads>
 a94:	00f70863          	beq	a4,a5,aa4 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 a98:	fec42503          	lw	a0,-20(s0)
 a9c:	60e2                	ld	ra,24(sp)
 a9e:	6442                	ld	s0,16(sp)
 aa0:	6105                	addi	sp,sp,32
 aa2:	8082                	ret
    free_stacks();
 aa4:	00000097          	auipc	ra,0x0
 aa8:	dd4080e7          	jalr	-556(ra) # 878 <free_stacks>
 aac:	b7f5                	j	a98 <ithread_join+0x32>
