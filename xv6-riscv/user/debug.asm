
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
  16:	778080e7          	jalr	1912(ra) # 78a <malloc>
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
  32:	ab298993          	addi	s3,s3,-1358 # ae0 <ithread_join+0x54>
  36:	02049713          	slli	a4,s1,0x20
  3a:	01e75793          	srli	a5,a4,0x1e
  3e:	97ca                	add	a5,a5,s2
  40:	4390                	lw	a2,0(a5)
  42:	85a6                	mv	a1,s1
  44:	854e                	mv	a0,s3
  46:	00000097          	auipc	ra,0x0
  4a:	688080e7          	jalr	1672(ra) # 6ce <printf>
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

00000000000003e2 <send>:
.global send
send:
 li a7, SYS_send
 3e2:	48fd                	li	a7,31
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <recv>:
.global recv
recv:
 li a7, SYS_recv
 3ea:	02000893          	li	a7,32
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 3f4:	02100893          	li	a7,33
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 3fe:	02200893          	li	a7,34
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 408:	1101                	addi	sp,sp,-32
 40a:	ec06                	sd	ra,24(sp)
 40c:	e822                	sd	s0,16(sp)
 40e:	1000                	addi	s0,sp,32
 410:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 414:	4605                	li	a2,1
 416:	fef40593          	addi	a1,s0,-17
 41a:	00000097          	auipc	ra,0x0
 41e:	f00080e7          	jalr	-256(ra) # 31a <write>
}
 422:	60e2                	ld	ra,24(sp)
 424:	6442                	ld	s0,16(sp)
 426:	6105                	addi	sp,sp,32
 428:	8082                	ret

000000000000042a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42a:	7139                	addi	sp,sp,-64
 42c:	fc06                	sd	ra,56(sp)
 42e:	f822                	sd	s0,48(sp)
 430:	f04a                	sd	s2,32(sp)
 432:	ec4e                	sd	s3,24(sp)
 434:	0080                	addi	s0,sp,64
 436:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 438:	cad9                	beqz	a3,4ce <printint+0xa4>
 43a:	01f5d79b          	srliw	a5,a1,0x1f
 43e:	cbc1                	beqz	a5,4ce <printint+0xa4>
    neg = 1;
    x = -xx;
 440:	40b005bb          	negw	a1,a1
    neg = 1;
 444:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 446:	fc040993          	addi	s3,s0,-64
  neg = 0;
 44a:	86ce                	mv	a3,s3
  i = 0;
 44c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 44e:	00000817          	auipc	a6,0x0
 452:	73a80813          	addi	a6,a6,1850 # b88 <digits>
 456:	88ba                	mv	a7,a4
 458:	0017051b          	addiw	a0,a4,1
 45c:	872a                	mv	a4,a0
 45e:	02c5f7bb          	remuw	a5,a1,a2
 462:	1782                	slli	a5,a5,0x20
 464:	9381                	srli	a5,a5,0x20
 466:	97c2                	add	a5,a5,a6
 468:	0007c783          	lbu	a5,0(a5)
 46c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 470:	87ae                	mv	a5,a1
 472:	02c5d5bb          	divuw	a1,a1,a2
 476:	0685                	addi	a3,a3,1
 478:	fcc7ffe3          	bgeu	a5,a2,456 <printint+0x2c>
  if(neg)
 47c:	00030c63          	beqz	t1,494 <printint+0x6a>
    buf[i++] = '-';
 480:	fd050793          	addi	a5,a0,-48
 484:	00878533          	add	a0,a5,s0
 488:	02d00793          	li	a5,45
 48c:	fef50823          	sb	a5,-16(a0)
 490:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 494:	02e05763          	blez	a4,4c2 <printint+0x98>
 498:	f426                	sd	s1,40(sp)
 49a:	377d                	addiw	a4,a4,-1
 49c:	00e984b3          	add	s1,s3,a4
 4a0:	19fd                	addi	s3,s3,-1
 4a2:	99ba                	add	s3,s3,a4
 4a4:	1702                	slli	a4,a4,0x20
 4a6:	9301                	srli	a4,a4,0x20
 4a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ac:	0004c583          	lbu	a1,0(s1)
 4b0:	854a                	mv	a0,s2
 4b2:	00000097          	auipc	ra,0x0
 4b6:	f56080e7          	jalr	-170(ra) # 408 <putc>
  while(--i >= 0)
 4ba:	14fd                	addi	s1,s1,-1
 4bc:	ff3498e3          	bne	s1,s3,4ac <printint+0x82>
 4c0:	74a2                	ld	s1,40(sp)
}
 4c2:	70e2                	ld	ra,56(sp)
 4c4:	7442                	ld	s0,48(sp)
 4c6:	7902                	ld	s2,32(sp)
 4c8:	69e2                	ld	s3,24(sp)
 4ca:	6121                	addi	sp,sp,64
 4cc:	8082                	ret
  neg = 0;
 4ce:	4301                	li	t1,0
 4d0:	bf9d                	j	446 <printint+0x1c>

00000000000004d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d2:	715d                	addi	sp,sp,-80
 4d4:	e486                	sd	ra,72(sp)
 4d6:	e0a2                	sd	s0,64(sp)
 4d8:	f84a                	sd	s2,48(sp)
 4da:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4dc:	0005c903          	lbu	s2,0(a1)
 4e0:	1a090b63          	beqz	s2,696 <vprintf+0x1c4>
 4e4:	fc26                	sd	s1,56(sp)
 4e6:	f44e                	sd	s3,40(sp)
 4e8:	f052                	sd	s4,32(sp)
 4ea:	ec56                	sd	s5,24(sp)
 4ec:	e85a                	sd	s6,16(sp)
 4ee:	e45e                	sd	s7,8(sp)
 4f0:	8aaa                	mv	s5,a0
 4f2:	8bb2                	mv	s7,a2
 4f4:	00158493          	addi	s1,a1,1
  state = 0;
 4f8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fa:	02500a13          	li	s4,37
 4fe:	4b55                	li	s6,21
 500:	a839                	j	51e <vprintf+0x4c>
        putc(fd, c);
 502:	85ca                	mv	a1,s2
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	f02080e7          	jalr	-254(ra) # 408 <putc>
 50e:	a019                	j	514 <vprintf+0x42>
    } else if(state == '%'){
 510:	01498d63          	beq	s3,s4,52a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 514:	0485                	addi	s1,s1,1
 516:	fff4c903          	lbu	s2,-1(s1)
 51a:	16090863          	beqz	s2,68a <vprintf+0x1b8>
    if(state == 0){
 51e:	fe0999e3          	bnez	s3,510 <vprintf+0x3e>
      if(c == '%'){
 522:	ff4910e3          	bne	s2,s4,502 <vprintf+0x30>
        state = '%';
 526:	89d2                	mv	s3,s4
 528:	b7f5                	j	514 <vprintf+0x42>
      if(c == 'd'){
 52a:	13490563          	beq	s2,s4,654 <vprintf+0x182>
 52e:	f9d9079b          	addiw	a5,s2,-99
 532:	0ff7f793          	zext.b	a5,a5
 536:	12fb6863          	bltu	s6,a5,666 <vprintf+0x194>
 53a:	f9d9079b          	addiw	a5,s2,-99
 53e:	0ff7f713          	zext.b	a4,a5
 542:	12eb6263          	bltu	s6,a4,666 <vprintf+0x194>
 546:	00271793          	slli	a5,a4,0x2
 54a:	00000717          	auipc	a4,0x0
 54e:	5e670713          	addi	a4,a4,1510 # b30 <ithread_join+0xa4>
 552:	97ba                	add	a5,a5,a4
 554:	439c                	lw	a5,0(a5)
 556:	97ba                	add	a5,a5,a4
 558:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 55a:	008b8913          	addi	s2,s7,8
 55e:	4685                	li	a3,1
 560:	4629                	li	a2,10
 562:	000ba583          	lw	a1,0(s7)
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	ec2080e7          	jalr	-318(ra) # 42a <printint>
 570:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 572:	4981                	li	s3,0
 574:	b745                	j	514 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 576:	008b8913          	addi	s2,s7,8
 57a:	4681                	li	a3,0
 57c:	4629                	li	a2,10
 57e:	000ba583          	lw	a1,0(s7)
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	ea6080e7          	jalr	-346(ra) # 42a <printint>
 58c:	8bca                	mv	s7,s2
      state = 0;
 58e:	4981                	li	s3,0
 590:	b751                	j	514 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 592:	008b8913          	addi	s2,s7,8
 596:	4681                	li	a3,0
 598:	4641                	li	a2,16
 59a:	000ba583          	lw	a1,0(s7)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	e8a080e7          	jalr	-374(ra) # 42a <printint>
 5a8:	8bca                	mv	s7,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b7a5                	j	514 <vprintf+0x42>
 5ae:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5b0:	008b8793          	addi	a5,s7,8
 5b4:	8c3e                	mv	s8,a5
 5b6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ba:	03000593          	li	a1,48
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e48080e7          	jalr	-440(ra) # 408 <putc>
  putc(fd, 'x');
 5c8:	07800593          	li	a1,120
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e3a080e7          	jalr	-454(ra) # 408 <putc>
 5d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d8:	00000b97          	auipc	s7,0x0
 5dc:	5b0b8b93          	addi	s7,s7,1456 # b88 <digits>
 5e0:	03c9d793          	srli	a5,s3,0x3c
 5e4:	97de                	add	a5,a5,s7
 5e6:	0007c583          	lbu	a1,0(a5)
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e1c080e7          	jalr	-484(ra) # 408 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f4:	0992                	slli	s3,s3,0x4
 5f6:	397d                	addiw	s2,s2,-1
 5f8:	fe0914e3          	bnez	s2,5e0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5fc:	8be2                	mv	s7,s8
      state = 0;
 5fe:	4981                	li	s3,0
 600:	6c02                	ld	s8,0(sp)
 602:	bf09                	j	514 <vprintf+0x42>
        s = va_arg(ap, char*);
 604:	008b8993          	addi	s3,s7,8
 608:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 60c:	02090163          	beqz	s2,62e <vprintf+0x15c>
        while(*s != 0){
 610:	00094583          	lbu	a1,0(s2)
 614:	c9a5                	beqz	a1,684 <vprintf+0x1b2>
          putc(fd, *s);
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	df0080e7          	jalr	-528(ra) # 408 <putc>
          s++;
 620:	0905                	addi	s2,s2,1
        while(*s != 0){
 622:	00094583          	lbu	a1,0(s2)
 626:	f9e5                	bnez	a1,616 <vprintf+0x144>
        s = va_arg(ap, char*);
 628:	8bce                	mv	s7,s3
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b5e5                	j	514 <vprintf+0x42>
          s = "(null)";
 62e:	00000917          	auipc	s2,0x0
 632:	4ca90913          	addi	s2,s2,1226 # af8 <ithread_join+0x6c>
        while(*s != 0){
 636:	02800593          	li	a1,40
 63a:	bff1                	j	616 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 63c:	008b8913          	addi	s2,s7,8
 640:	000bc583          	lbu	a1,0(s7)
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	dc2080e7          	jalr	-574(ra) # 408 <putc>
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
 652:	b5c9                	j	514 <vprintf+0x42>
        putc(fd, c);
 654:	02500593          	li	a1,37
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	dae080e7          	jalr	-594(ra) # 408 <putc>
      state = 0;
 662:	4981                	li	s3,0
 664:	bd45                	j	514 <vprintf+0x42>
        putc(fd, '%');
 666:	02500593          	li	a1,37
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	d9c080e7          	jalr	-612(ra) # 408 <putc>
        putc(fd, c);
 674:	85ca                	mv	a1,s2
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	d90080e7          	jalr	-624(ra) # 408 <putc>
      state = 0;
 680:	4981                	li	s3,0
 682:	bd49                	j	514 <vprintf+0x42>
        s = va_arg(ap, char*);
 684:	8bce                	mv	s7,s3
      state = 0;
 686:	4981                	li	s3,0
 688:	b571                	j	514 <vprintf+0x42>
 68a:	74e2                	ld	s1,56(sp)
 68c:	79a2                	ld	s3,40(sp)
 68e:	7a02                	ld	s4,32(sp)
 690:	6ae2                	ld	s5,24(sp)
 692:	6b42                	ld	s6,16(sp)
 694:	6ba2                	ld	s7,8(sp)
    }
  }
}
 696:	60a6                	ld	ra,72(sp)
 698:	6406                	ld	s0,64(sp)
 69a:	7942                	ld	s2,48(sp)
 69c:	6161                	addi	sp,sp,80
 69e:	8082                	ret

00000000000006a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a0:	715d                	addi	sp,sp,-80
 6a2:	ec06                	sd	ra,24(sp)
 6a4:	e822                	sd	s0,16(sp)
 6a6:	1000                	addi	s0,sp,32
 6a8:	e010                	sd	a2,0(s0)
 6aa:	e414                	sd	a3,8(s0)
 6ac:	e818                	sd	a4,16(s0)
 6ae:	ec1c                	sd	a5,24(s0)
 6b0:	03043023          	sd	a6,32(s0)
 6b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b8:	8622                	mv	a2,s0
 6ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6be:	00000097          	auipc	ra,0x0
 6c2:	e14080e7          	jalr	-492(ra) # 4d2 <vprintf>
}
 6c6:	60e2                	ld	ra,24(sp)
 6c8:	6442                	ld	s0,16(sp)
 6ca:	6161                	addi	sp,sp,80
 6cc:	8082                	ret

00000000000006ce <printf>:

void
printf(const char *fmt, ...)
{
 6ce:	711d                	addi	sp,sp,-96
 6d0:	ec06                	sd	ra,24(sp)
 6d2:	e822                	sd	s0,16(sp)
 6d4:	1000                	addi	s0,sp,32
 6d6:	e40c                	sd	a1,8(s0)
 6d8:	e810                	sd	a2,16(s0)
 6da:	ec14                	sd	a3,24(s0)
 6dc:	f018                	sd	a4,32(s0)
 6de:	f41c                	sd	a5,40(s0)
 6e0:	03043823          	sd	a6,48(s0)
 6e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e8:	00840613          	addi	a2,s0,8
 6ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f0:	85aa                	mv	a1,a0
 6f2:	4505                	li	a0,1
 6f4:	00000097          	auipc	ra,0x0
 6f8:	dde080e7          	jalr	-546(ra) # 4d2 <vprintf>
}
 6fc:	60e2                	ld	ra,24(sp)
 6fe:	6442                	ld	s0,16(sp)
 700:	6125                	addi	sp,sp,96
 702:	8082                	ret

0000000000000704 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 704:	1141                	addi	sp,sp,-16
 706:	e406                	sd	ra,8(sp)
 708:	e022                	sd	s0,0(sp)
 70a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 710:	00001797          	auipc	a5,0x1
 714:	e007b783          	ld	a5,-512(a5) # 1510 <freep>
 718:	a039                	j	726 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71a:	6398                	ld	a4,0(a5)
 71c:	00e7e463          	bltu	a5,a4,724 <free+0x20>
 720:	00e6ea63          	bltu	a3,a4,734 <free+0x30>
{
 724:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 726:	fed7fae3          	bgeu	a5,a3,71a <free+0x16>
 72a:	6398                	ld	a4,0(a5)
 72c:	00e6e463          	bltu	a3,a4,734 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	fee7eae3          	bltu	a5,a4,724 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 734:	ff852583          	lw	a1,-8(a0)
 738:	6390                	ld	a2,0(a5)
 73a:	02059813          	slli	a6,a1,0x20
 73e:	01c85713          	srli	a4,a6,0x1c
 742:	9736                	add	a4,a4,a3
 744:	02e60563          	beq	a2,a4,76e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 748:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 74c:	4790                	lw	a2,8(a5)
 74e:	02061593          	slli	a1,a2,0x20
 752:	01c5d713          	srli	a4,a1,0x1c
 756:	973e                	add	a4,a4,a5
 758:	02e68263          	beq	a3,a4,77c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 75c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 75e:	00001717          	auipc	a4,0x1
 762:	daf73923          	sd	a5,-590(a4) # 1510 <freep>
}
 766:	60a2                	ld	ra,8(sp)
 768:	6402                	ld	s0,0(sp)
 76a:	0141                	addi	sp,sp,16
 76c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 76e:	4618                	lw	a4,8(a2)
 770:	9f2d                	addw	a4,a4,a1
 772:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 776:	6398                	ld	a4,0(a5)
 778:	6310                	ld	a2,0(a4)
 77a:	b7f9                	j	748 <free+0x44>
    p->s.size += bp->s.size;
 77c:	ff852703          	lw	a4,-8(a0)
 780:	9f31                	addw	a4,a4,a2
 782:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 784:	ff053683          	ld	a3,-16(a0)
 788:	bfd1                	j	75c <free+0x58>

000000000000078a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 78a:	7139                	addi	sp,sp,-64
 78c:	fc06                	sd	ra,56(sp)
 78e:	f822                	sd	s0,48(sp)
 790:	f04a                	sd	s2,32(sp)
 792:	ec4e                	sd	s3,24(sp)
 794:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 796:	02051993          	slli	s3,a0,0x20
 79a:	0209d993          	srli	s3,s3,0x20
 79e:	09bd                	addi	s3,s3,15
 7a0:	0049d993          	srli	s3,s3,0x4
 7a4:	2985                	addiw	s3,s3,1
 7a6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7a8:	00001517          	auipc	a0,0x1
 7ac:	d6853503          	ld	a0,-664(a0) # 1510 <freep>
 7b0:	c905                	beqz	a0,7e0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b4:	4798                	lw	a4,8(a5)
 7b6:	09377a63          	bgeu	a4,s3,84a <malloc+0xc0>
 7ba:	f426                	sd	s1,40(sp)
 7bc:	e852                	sd	s4,16(sp)
 7be:	e456                	sd	s5,8(sp)
 7c0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7c2:	8a4e                	mv	s4,s3
 7c4:	6705                	lui	a4,0x1
 7c6:	00e9f363          	bgeu	s3,a4,7cc <malloc+0x42>
 7ca:	6a05                	lui	s4,0x1
 7cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d4:	00001497          	auipc	s1,0x1
 7d8:	d3c48493          	addi	s1,s1,-708 # 1510 <freep>
  if(p == (char*)-1)
 7dc:	5afd                	li	s5,-1
 7de:	a089                	j	820 <malloc+0x96>
 7e0:	f426                	sd	s1,40(sp)
 7e2:	e852                	sd	s4,16(sp)
 7e4:	e456                	sd	s5,8(sp)
 7e6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7e8:	00001797          	auipc	a5,0x1
 7ec:	d4878793          	addi	a5,a5,-696 # 1530 <base>
 7f0:	00001717          	auipc	a4,0x1
 7f4:	d2f73023          	sd	a5,-736(a4) # 1510 <freep>
 7f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7fe:	b7d1                	j	7c2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	e118                	sd	a4,0(a0)
 804:	a8b9                	j	862 <malloc+0xd8>
  hp->s.size = nu;
 806:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 80a:	0541                	addi	a0,a0,16
 80c:	00000097          	auipc	ra,0x0
 810:	ef8080e7          	jalr	-264(ra) # 704 <free>
  return freep;
 814:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 816:	c135                	beqz	a0,87a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81a:	4798                	lw	a4,8(a5)
 81c:	03277363          	bgeu	a4,s2,842 <malloc+0xb8>
    if(p == freep)
 820:	6098                	ld	a4,0(s1)
 822:	853e                	mv	a0,a5
 824:	fef71ae3          	bne	a4,a5,818 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 828:	8552                	mv	a0,s4
 82a:	00000097          	auipc	ra,0x0
 82e:	b58080e7          	jalr	-1192(ra) # 382 <sbrk>
  if(p == (char*)-1)
 832:	fd551ae3          	bne	a0,s5,806 <malloc+0x7c>
        return 0;
 836:	4501                	li	a0,0
 838:	74a2                	ld	s1,40(sp)
 83a:	6a42                	ld	s4,16(sp)
 83c:	6aa2                	ld	s5,8(sp)
 83e:	6b02                	ld	s6,0(sp)
 840:	a03d                	j	86e <malloc+0xe4>
 842:	74a2                	ld	s1,40(sp)
 844:	6a42                	ld	s4,16(sp)
 846:	6aa2                	ld	s5,8(sp)
 848:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 84a:	fae90be3          	beq	s2,a4,800 <malloc+0x76>
        p->s.size -= nunits;
 84e:	4137073b          	subw	a4,a4,s3
 852:	c798                	sw	a4,8(a5)
        p += p->s.size;
 854:	02071693          	slli	a3,a4,0x20
 858:	01c6d713          	srli	a4,a3,0x1c
 85c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 85e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 862:	00001717          	auipc	a4,0x1
 866:	caa73723          	sd	a0,-850(a4) # 1510 <freep>
      return (void*)(p + 1);
 86a:	01078513          	addi	a0,a5,16
  }
}
 86e:	70e2                	ld	ra,56(sp)
 870:	7442                	ld	s0,48(sp)
 872:	7902                	ld	s2,32(sp)
 874:	69e2                	ld	s3,24(sp)
 876:	6121                	addi	sp,sp,64
 878:	8082                	ret
 87a:	74a2                	ld	s1,40(sp)
 87c:	6a42                	ld	s4,16(sp)
 87e:	6aa2                	ld	s5,8(sp)
 880:	6b02                	ld	s6,0(sp)
 882:	b7f5                	j	86e <malloc+0xe4>

0000000000000884 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 884:	1141                	addi	sp,sp,-16
 886:	e406                	sd	ra,8(sp)
 888:	e022                	sd	s0,0(sp)
 88a:	0800                	addi	s0,sp,16
  thread_exit(status);
 88c:	2501                	sext.w	a0,a0
 88e:	00000097          	auipc	ra,0x0
 892:	b24080e7          	jalr	-1244(ra) # 3b2 <thread_exit>
}
 896:	60a2                	ld	ra,8(sp)
 898:	6402                	ld	s0,0(sp)
 89a:	0141                	addi	sp,sp,16
 89c:	8082                	ret

000000000000089e <free_stacks>:
int free_stacks() {
 89e:	7179                	addi	sp,sp,-48
 8a0:	f406                	sd	ra,40(sp)
 8a2:	f022                	sd	s0,32(sp)
 8a4:	ec26                	sd	s1,24(sp)
 8a6:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8a8:	00001797          	auipc	a5,0x1
 8ac:	c787a783          	lw	a5,-904(a5) # 1520 <num_threads>
 8b0:	04f05063          	blez	a5,8f0 <free_stacks+0x52>
 8b4:	e84a                	sd	s2,16(sp)
 8b6:	e44e                	sd	s3,8(sp)
 8b8:	4481                	li	s1,0
    free(stacks[i]);
 8ba:	00001997          	auipc	s3,0x1
 8be:	c5e98993          	addi	s3,s3,-930 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8c2:	00001917          	auipc	s2,0x1
 8c6:	c5e90913          	addi	s2,s2,-930 # 1520 <num_threads>
    free(stacks[i]);
 8ca:	0009b783          	ld	a5,0(s3)
 8ce:	00349713          	slli	a4,s1,0x3
 8d2:	97ba                	add	a5,a5,a4
 8d4:	6388                	ld	a0,0(a5)
 8d6:	00000097          	auipc	ra,0x0
 8da:	e2e080e7          	jalr	-466(ra) # 704 <free>
  for (int i = 0; i < num_threads; i++) {
 8de:	0485                	addi	s1,s1,1
 8e0:	00092703          	lw	a4,0(s2)
 8e4:	0004879b          	sext.w	a5,s1
 8e8:	fee7c1e3          	blt	a5,a4,8ca <free_stacks+0x2c>
 8ec:	6942                	ld	s2,16(sp)
 8ee:	69a2                	ld	s3,8(sp)
  free(stacks);
 8f0:	00001497          	auipc	s1,0x1
 8f4:	c2848493          	addi	s1,s1,-984 # 1518 <stacks>
 8f8:	6088                	ld	a0,0(s1)
 8fa:	00000097          	auipc	ra,0x0
 8fe:	e0a080e7          	jalr	-502(ra) # 704 <free>
  stacks = 0;
 902:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 906:	00001797          	auipc	a5,0x1
 90a:	c007ad23          	sw	zero,-998(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 90e:	47a1                	li	a5,8
 910:	00001717          	auipc	a4,0x1
 914:	bef72823          	sw	a5,-1040(a4) # 1500 <max_stacks>
  threads_done = 0;
 918:	00001797          	auipc	a5,0x1
 91c:	c007a623          	sw	zero,-1012(a5) # 1524 <threads_done>
}
 920:	4501                	li	a0,0
 922:	70a2                	ld	ra,40(sp)
 924:	7402                	ld	s0,32(sp)
 926:	64e2                	ld	s1,24(sp)
 928:	6145                	addi	sp,sp,48
 92a:	8082                	ret

000000000000092c <expand_num_threads>:
int expand_num_threads() {
 92c:	1101                	addi	sp,sp,-32
 92e:	ec06                	sd	ra,24(sp)
 930:	e822                	sd	s0,16(sp)
 932:	e426                	sd	s1,8(sp)
 934:	e04a                	sd	s2,0(sp)
 936:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 938:	00001797          	auipc	a5,0x1
 93c:	bc878793          	addi	a5,a5,-1080 # 1500 <max_stacks>
 940:	4388                	lw	a0,0(a5)
 942:	0015151b          	slliw	a0,a0,0x1
 946:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 948:	0035151b          	slliw	a0,a0,0x3
 94c:	00000097          	auipc	ra,0x0
 950:	e3e080e7          	jalr	-450(ra) # 78a <malloc>
 954:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 956:	00001617          	auipc	a2,0x1
 95a:	bca62603          	lw	a2,-1078(a2) # 1520 <num_threads>
 95e:	00001497          	auipc	s1,0x1
 962:	bba48493          	addi	s1,s1,-1094 # 1518 <stacks>
 966:	0036161b          	slliw	a2,a2,0x3
 96a:	608c                	ld	a1,0(s1)
 96c:	00000097          	auipc	ra,0x0
 970:	8d8080e7          	jalr	-1832(ra) # 244 <memmove>
  free(stacks);
 974:	6088                	ld	a0,0(s1)
 976:	00000097          	auipc	ra,0x0
 97a:	d8e080e7          	jalr	-626(ra) # 704 <free>
  stacks = new_stacks;
 97e:	0124b023          	sd	s2,0(s1)
}
 982:	4501                	li	a0,0
 984:	60e2                	ld	ra,24(sp)
 986:	6442                	ld	s0,16(sp)
 988:	64a2                	ld	s1,8(sp)
 98a:	6902                	ld	s2,0(sp)
 98c:	6105                	addi	sp,sp,32
 98e:	8082                	ret

0000000000000990 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 990:	7179                	addi	sp,sp,-48
 992:	f406                	sd	ra,40(sp)
 994:	f022                	sd	s0,32(sp)
 996:	e84a                	sd	s2,16(sp)
 998:	e44e                	sd	s3,8(sp)
 99a:	1800                	addi	s0,sp,48
 99c:	892a                	mv	s2,a0
 99e:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9a0:	00001797          	auipc	a5,0x1
 9a4:	b787b783          	ld	a5,-1160(a5) # 1518 <stacks>
 9a8:	c3d9                	beqz	a5,a2e <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9aa:	00001797          	auipc	a5,0x1
 9ae:	b567a783          	lw	a5,-1194(a5) # 1500 <max_stacks>
 9b2:	00001717          	auipc	a4,0x1
 9b6:	b6e72703          	lw	a4,-1170(a4) # 1520 <num_threads>
 9ba:	0af71463          	bne	a4,a5,a62 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 9be:	04000713          	li	a4,64
 9c2:	08e78563          	beq	a5,a4,a4c <ithread_create+0xbc>
 9c6:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9c8:	00000097          	auipc	ra,0x0
 9cc:	f64080e7          	jalr	-156(ra) # 92c <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9d0:	6505                	lui	a0,0x1
 9d2:	00000097          	auipc	ra,0x0
 9d6:	db8080e7          	jalr	-584(ra) # 78a <malloc>
 9da:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9dc:	00001717          	auipc	a4,0x1
 9e0:	b4472703          	lw	a4,-1212(a4) # 1520 <num_threads>
 9e4:	070e                	slli	a4,a4,0x3
 9e6:	00001797          	auipc	a5,0x1
 9ea:	b327b783          	ld	a5,-1230(a5) # 1518 <stacks>
 9ee:	97ba                	add	a5,a5,a4
 9f0:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9f2:	00000697          	auipc	a3,0x0
 9f6:	e9268693          	addi	a3,a3,-366 # 884 <ithread_exit>
 9fa:	862a                	mv	a2,a0
 9fc:	85ce                	mv	a1,s3
 9fe:	854a                	mv	a0,s2
 a00:	00000097          	auipc	ra,0x0
 a04:	9a2080e7          	jalr	-1630(ra) # 3a2 <create_thread>
 a08:	892a                	mv	s2,a0
  if (res != -1) {
 a0a:	57fd                	li	a5,-1
 a0c:	04f50d63          	beq	a0,a5,a66 <ithread_create+0xd6>
    num_threads++;
 a10:	00001717          	auipc	a4,0x1
 a14:	b1070713          	addi	a4,a4,-1264 # 1520 <num_threads>
 a18:	431c                	lw	a5,0(a4)
 a1a:	2785                	addiw	a5,a5,1
 a1c:	c31c                	sw	a5,0(a4)
 a1e:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a20:	854a                	mv	a0,s2
 a22:	70a2                	ld	ra,40(sp)
 a24:	7402                	ld	s0,32(sp)
 a26:	6942                	ld	s2,16(sp)
 a28:	69a2                	ld	s3,8(sp)
 a2a:	6145                	addi	sp,sp,48
 a2c:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a2e:	00001517          	auipc	a0,0x1
 a32:	ad252503          	lw	a0,-1326(a0) # 1500 <max_stacks>
 a36:	0035151b          	slliw	a0,a0,0x3
 a3a:	00000097          	auipc	ra,0x0
 a3e:	d50080e7          	jalr	-688(ra) # 78a <malloc>
 a42:	00001797          	auipc	a5,0x1
 a46:	aca7bb23          	sd	a0,-1322(a5) # 1518 <stacks>
 a4a:	b785                	j	9aa <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a4c:	00000517          	auipc	a0,0x0
 a50:	0b450513          	addi	a0,a0,180 # b00 <ithread_join+0x74>
 a54:	00000097          	auipc	ra,0x0
 a58:	c7a080e7          	jalr	-902(ra) # 6ce <printf>
      return -1;
 a5c:	57fd                	li	a5,-1
 a5e:	893e                	mv	s2,a5
 a60:	b7c1                	j	a20 <ithread_create+0x90>
 a62:	ec26                	sd	s1,24(sp)
 a64:	b7b5                	j	9d0 <ithread_create+0x40>
    free(stack_ptr);
 a66:	8526                	mv	a0,s1
 a68:	00000097          	auipc	ra,0x0
 a6c:	c9c080e7          	jalr	-868(ra) # 704 <free>
    stacks[num_threads] = 0;
 a70:	00001717          	auipc	a4,0x1
 a74:	ab072703          	lw	a4,-1360(a4) # 1520 <num_threads>
 a78:	070e                	slli	a4,a4,0x3
 a7a:	00001797          	auipc	a5,0x1
 a7e:	a9e7b783          	ld	a5,-1378(a5) # 1518 <stacks>
 a82:	97ba                	add	a5,a5,a4
 a84:	0007b023          	sd	zero,0(a5)
 a88:	64e2                	ld	s1,24(sp)
 a8a:	bf59                	j	a20 <ithread_create+0x90>

0000000000000a8c <ithread_join>:

int ithread_join(int thread_id) {
 a8c:	1101                	addi	sp,sp,-32
 a8e:	ec06                	sd	ra,24(sp)
 a90:	e822                	sd	s0,16(sp)
 a92:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a94:	ff040793          	addi	a5,s0,-16
 a98:	ffc7859b          	addiw	a1,a5,-4
 a9c:	00000097          	auipc	ra,0x0
 aa0:	90e080e7          	jalr	-1778(ra) # 3aa <join_thread>
  threads_done++;
 aa4:	00001717          	auipc	a4,0x1
 aa8:	a8070713          	addi	a4,a4,-1408 # 1524 <threads_done>
 aac:	431c                	lw	a5,0(a4)
 aae:	2785                	addiw	a5,a5,1
 ab0:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ab2:	00001717          	auipc	a4,0x1
 ab6:	a6e72703          	lw	a4,-1426(a4) # 1520 <num_threads>
 aba:	00f70863          	beq	a4,a5,aca <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 abe:	fec42503          	lw	a0,-20(s0)
 ac2:	60e2                	ld	ra,24(sp)
 ac4:	6442                	ld	s0,16(sp)
 ac6:	6105                	addi	sp,sp,32
 ac8:	8082                	ret
    free_stacks();
 aca:	00000097          	auipc	ra,0x0
 ace:	dd4080e7          	jalr	-556(ra) # 89e <free_stacks>
 ad2:	b7f5                	j	abe <ithread_join+0x32>
