
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
  16:	718080e7          	jalr	1816(ra) # 72a <malloc>
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
  32:	a3298993          	addi	s3,s3,-1486 # a60 <ithread_join+0x52>
  36:	02049713          	slli	a4,s1,0x20
  3a:	01e75793          	srli	a5,a4,0x1e
  3e:	97ca                	add	a5,a5,s2
  40:	4390                	lw	a2,0(a5)
  42:	85a6                	mv	a1,s1
  44:	854e                	mv	a0,s3
  46:	00000097          	auipc	ra,0x0
  4a:	62c080e7          	jalr	1580(ra) # 672 <printf>
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
  68:	274080e7          	jalr	628(ra) # 2d8 <exit>

000000000000006c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e422                	sd	s0,8(sp)
  70:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  72:	87aa                	mv	a5,a0
  74:	0585                	addi	a1,a1,1
  76:	0785                	addi	a5,a5,1
  78:	fff5c703          	lbu	a4,-1(a1)
  7c:	fee78fa3          	sb	a4,-1(a5)
  80:	fb75                	bnez	a4,74 <strcpy+0x8>
    ;
  return os;
}
  82:	6422                	ld	s0,8(sp)
  84:	0141                	addi	sp,sp,16
  86:	8082                	ret

0000000000000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e422                	sd	s0,8(sp)
  8c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  8e:	00054783          	lbu	a5,0(a0)
  92:	cb91                	beqz	a5,a6 <strcmp+0x1e>
  94:	0005c703          	lbu	a4,0(a1)
  98:	00f71763          	bne	a4,a5,a6 <strcmp+0x1e>
    p++, q++;
  9c:	0505                	addi	a0,a0,1
  9e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	fbe5                	bnez	a5,94 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a6:	0005c503          	lbu	a0,0(a1)
}
  aa:	40a7853b          	subw	a0,a5,a0
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strlen>:

uint
strlen(const char *s)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cf91                	beqz	a5,da <strlen+0x26>
  c0:	0505                	addi	a0,a0,1
  c2:	87aa                	mv	a5,a0
  c4:	4685                	li	a3,1
  c6:	9e89                	subw	a3,a3,a0
  c8:	00f6853b          	addw	a0,a3,a5
  cc:	0785                	addi	a5,a5,1
  ce:	fff7c703          	lbu	a4,-1(a5)
  d2:	fb7d                	bnez	a4,c8 <strlen+0x14>
    ;
  return n;
}
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret
  for(n = 0; s[n]; n++)
  da:	4501                	li	a0,0
  dc:	bfe5                	j	d4 <strlen+0x20>

00000000000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e4:	ca19                	beqz	a2,fa <memset+0x1c>
  e6:	87aa                	mv	a5,a0
  e8:	1602                	slli	a2,a2,0x20
  ea:	9201                	srli	a2,a2,0x20
  ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f4:	0785                	addi	a5,a5,1
  f6:	fee79de3          	bne	a5,a4,f0 <memset+0x12>
  }
  return dst;
}
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e422                	sd	s0,8(sp)
 104:	0800                	addi	s0,sp,16
  for(; *s; s++)
 106:	00054783          	lbu	a5,0(a0)
 10a:	cb99                	beqz	a5,120 <strchr+0x20>
    if(*s == c)
 10c:	00f58763          	beq	a1,a5,11a <strchr+0x1a>
  for(; *s; s++)
 110:	0505                	addi	a0,a0,1
 112:	00054783          	lbu	a5,0(a0)
 116:	fbfd                	bnez	a5,10c <strchr+0xc>
      return (char*)s;
  return 0;
 118:	4501                	li	a0,0
}
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret
  return 0;
 120:	4501                	li	a0,0
 122:	bfe5                	j	11a <strchr+0x1a>

0000000000000124 <gets>:

char*
gets(char *buf, int max)
{
 124:	711d                	addi	sp,sp,-96
 126:	ec86                	sd	ra,88(sp)
 128:	e8a2                	sd	s0,80(sp)
 12a:	e4a6                	sd	s1,72(sp)
 12c:	e0ca                	sd	s2,64(sp)
 12e:	fc4e                	sd	s3,56(sp)
 130:	f852                	sd	s4,48(sp)
 132:	f456                	sd	s5,40(sp)
 134:	f05a                	sd	s6,32(sp)
 136:	ec5e                	sd	s7,24(sp)
 138:	1080                	addi	s0,sp,96
 13a:	8baa                	mv	s7,a0
 13c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13e:	892a                	mv	s2,a0
 140:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 142:	4aa9                	li	s5,10
 144:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 146:	89a6                	mv	s3,s1
 148:	2485                	addiw	s1,s1,1
 14a:	0344d863          	bge	s1,s4,17a <gets+0x56>
    cc = read(0, &c, 1);
 14e:	4605                	li	a2,1
 150:	faf40593          	addi	a1,s0,-81
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	19a080e7          	jalr	410(ra) # 2f0 <read>
    if(cc < 1)
 15e:	00a05e63          	blez	a0,17a <gets+0x56>
    buf[i++] = c;
 162:	faf44783          	lbu	a5,-81(s0)
 166:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 16a:	01578763          	beq	a5,s5,178 <gets+0x54>
 16e:	0905                	addi	s2,s2,1
 170:	fd679be3          	bne	a5,s6,146 <gets+0x22>
  for(i=0; i+1 < max; ){
 174:	89a6                	mv	s3,s1
 176:	a011                	j	17a <gets+0x56>
 178:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 17a:	99de                	add	s3,s3,s7
 17c:	00098023          	sb	zero,0(s3)
  return buf;
}
 180:	855e                	mv	a0,s7
 182:	60e6                	ld	ra,88(sp)
 184:	6446                	ld	s0,80(sp)
 186:	64a6                	ld	s1,72(sp)
 188:	6906                	ld	s2,64(sp)
 18a:	79e2                	ld	s3,56(sp)
 18c:	7a42                	ld	s4,48(sp)
 18e:	7aa2                	ld	s5,40(sp)
 190:	7b02                	ld	s6,32(sp)
 192:	6be2                	ld	s7,24(sp)
 194:	6125                	addi	sp,sp,96
 196:	8082                	ret

0000000000000198 <stat>:

int
stat(const char *n, struct stat *st)
{
 198:	1101                	addi	sp,sp,-32
 19a:	ec06                	sd	ra,24(sp)
 19c:	e822                	sd	s0,16(sp)
 19e:	e426                	sd	s1,8(sp)
 1a0:	e04a                	sd	s2,0(sp)
 1a2:	1000                	addi	s0,sp,32
 1a4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a6:	4581                	li	a1,0
 1a8:	00000097          	auipc	ra,0x0
 1ac:	170080e7          	jalr	368(ra) # 318 <open>
  if(fd < 0)
 1b0:	02054563          	bltz	a0,1da <stat+0x42>
 1b4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b6:	85ca                	mv	a1,s2
 1b8:	00000097          	auipc	ra,0x0
 1bc:	178080e7          	jalr	376(ra) # 330 <fstat>
 1c0:	892a                	mv	s2,a0
  close(fd);
 1c2:	8526                	mv	a0,s1
 1c4:	00000097          	auipc	ra,0x0
 1c8:	13c080e7          	jalr	316(ra) # 300 <close>
  return r;
}
 1cc:	854a                	mv	a0,s2
 1ce:	60e2                	ld	ra,24(sp)
 1d0:	6442                	ld	s0,16(sp)
 1d2:	64a2                	ld	s1,8(sp)
 1d4:	6902                	ld	s2,0(sp)
 1d6:	6105                	addi	sp,sp,32
 1d8:	8082                	ret
    return -1;
 1da:	597d                	li	s2,-1
 1dc:	bfc5                	j	1cc <stat+0x34>

00000000000001de <atoi>:

int
atoi(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e4:	00054683          	lbu	a3,0(a0)
 1e8:	fd06879b          	addiw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	4625                	li	a2,9
 1f2:	02f66863          	bltu	a2,a5,222 <atoi+0x44>
 1f6:	872a                	mv	a4,a0
  n = 0;
 1f8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1fa:	0705                	addi	a4,a4,1
 1fc:	0025179b          	slliw	a5,a0,0x2
 200:	9fa9                	addw	a5,a5,a0
 202:	0017979b          	slliw	a5,a5,0x1
 206:	9fb5                	addw	a5,a5,a3
 208:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20c:	00074683          	lbu	a3,0(a4)
 210:	fd06879b          	addiw	a5,a3,-48
 214:	0ff7f793          	zext.b	a5,a5
 218:	fef671e3          	bgeu	a2,a5,1fa <atoi+0x1c>
  return n;
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  n = 0;
 222:	4501                	li	a0,0
 224:	bfe5                	j	21c <atoi+0x3e>

0000000000000226 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 22c:	02b57463          	bgeu	a0,a1,254 <memmove+0x2e>
    while(n-- > 0)
 230:	00c05f63          	blez	a2,24e <memmove+0x28>
 234:	1602                	slli	a2,a2,0x20
 236:	9201                	srli	a2,a2,0x20
 238:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 23c:	872a                	mv	a4,a0
      *dst++ = *src++;
 23e:	0585                	addi	a1,a1,1
 240:	0705                	addi	a4,a4,1
 242:	fff5c683          	lbu	a3,-1(a1)
 246:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24a:	fee79ae3          	bne	a5,a4,23e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 24e:	6422                	ld	s0,8(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret
    dst += n;
 254:	00c50733          	add	a4,a0,a2
    src += n;
 258:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 25a:	fec05ae3          	blez	a2,24e <memmove+0x28>
 25e:	fff6079b          	addiw	a5,a2,-1
 262:	1782                	slli	a5,a5,0x20
 264:	9381                	srli	a5,a5,0x20
 266:	fff7c793          	not	a5,a5
 26a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 26c:	15fd                	addi	a1,a1,-1
 26e:	177d                	addi	a4,a4,-1
 270:	0005c683          	lbu	a3,0(a1)
 274:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 278:	fee79ae3          	bne	a5,a4,26c <memmove+0x46>
 27c:	bfc9                	j	24e <memmove+0x28>

000000000000027e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 284:	ca05                	beqz	a2,2b4 <memcmp+0x36>
 286:	fff6069b          	addiw	a3,a2,-1
 28a:	1682                	slli	a3,a3,0x20
 28c:	9281                	srli	a3,a3,0x20
 28e:	0685                	addi	a3,a3,1
 290:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 292:	00054783          	lbu	a5,0(a0)
 296:	0005c703          	lbu	a4,0(a1)
 29a:	00e79863          	bne	a5,a4,2aa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 29e:	0505                	addi	a0,a0,1
    p2++;
 2a0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a2:	fed518e3          	bne	a0,a3,292 <memcmp+0x14>
  }
  return 0;
 2a6:	4501                	li	a0,0
 2a8:	a019                	j	2ae <memcmp+0x30>
      return *p1 - *p2;
 2aa:	40e7853b          	subw	a0,a5,a4
}
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	bfe5                	j	2ae <memcmp+0x30>

00000000000002b8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c0:	00000097          	auipc	ra,0x0
 2c4:	f66080e7          	jalr	-154(ra) # 226 <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d0:	4885                	li	a7,1
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d8:	4889                	li	a7,2
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e0:	488d                	li	a7,3
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e8:	4891                	li	a7,4
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <read>:
.global read
read:
 li a7, SYS_read
 2f0:	4895                	li	a7,5
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <write>:
.global write
write:
 li a7, SYS_write
 2f8:	48c1                	li	a7,16
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <close>:
.global close
close:
 li a7, SYS_close
 300:	48d5                	li	a7,21
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <kill>:
.global kill
kill:
 li a7, SYS_kill
 308:	4899                	li	a7,6
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <exec>:
.global exec
exec:
 li a7, SYS_exec
 310:	489d                	li	a7,7
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <open>:
.global open
open:
 li a7, SYS_open
 318:	48bd                	li	a7,15
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 320:	48c5                	li	a7,17
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 328:	48c9                	li	a7,18
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 330:	48a1                	li	a7,8
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <link>:
.global link
link:
 li a7, SYS_link
 338:	48cd                	li	a7,19
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 340:	48d1                	li	a7,20
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 348:	48a5                	li	a7,9
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <dup>:
.global dup
dup:
 li a7, SYS_dup
 350:	48a9                	li	a7,10
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 358:	48ad                	li	a7,11
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 360:	48b1                	li	a7,12
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 368:	48b5                	li	a7,13
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 370:	48b9                	li	a7,14
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 378:	48d9                	li	a7,22
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 380:	48dd                	li	a7,23
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 388:	48e1                	li	a7,24
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 390:	48e5                	li	a7,25
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 398:	1101                	addi	sp,sp,-32
 39a:	ec06                	sd	ra,24(sp)
 39c:	e822                	sd	s0,16(sp)
 39e:	1000                	addi	s0,sp,32
 3a0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a4:	4605                	li	a2,1
 3a6:	fef40593          	addi	a1,s0,-17
 3aa:	00000097          	auipc	ra,0x0
 3ae:	f4e080e7          	jalr	-178(ra) # 2f8 <write>
}
 3b2:	60e2                	ld	ra,24(sp)
 3b4:	6442                	ld	s0,16(sp)
 3b6:	6105                	addi	sp,sp,32
 3b8:	8082                	ret

00000000000003ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ba:	7139                	addi	sp,sp,-64
 3bc:	fc06                	sd	ra,56(sp)
 3be:	f822                	sd	s0,48(sp)
 3c0:	f426                	sd	s1,40(sp)
 3c2:	f04a                	sd	s2,32(sp)
 3c4:	ec4e                	sd	s3,24(sp)
 3c6:	0080                	addi	s0,sp,64
 3c8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ca:	c299                	beqz	a3,3d0 <printint+0x16>
 3cc:	0805c963          	bltz	a1,45e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3d0:	2581                	sext.w	a1,a1
  neg = 0;
 3d2:	4881                	li	a7,0
 3d4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3d8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3da:	2601                	sext.w	a2,a2
 3dc:	00000517          	auipc	a0,0x0
 3e0:	6fc50513          	addi	a0,a0,1788 # ad8 <digits>
 3e4:	883a                	mv	a6,a4
 3e6:	2705                	addiw	a4,a4,1
 3e8:	02c5f7bb          	remuw	a5,a1,a2
 3ec:	1782                	slli	a5,a5,0x20
 3ee:	9381                	srli	a5,a5,0x20
 3f0:	97aa                	add	a5,a5,a0
 3f2:	0007c783          	lbu	a5,0(a5)
 3f6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3fa:	0005879b          	sext.w	a5,a1
 3fe:	02c5d5bb          	divuw	a1,a1,a2
 402:	0685                	addi	a3,a3,1
 404:	fec7f0e3          	bgeu	a5,a2,3e4 <printint+0x2a>
  if(neg)
 408:	00088c63          	beqz	a7,420 <printint+0x66>
    buf[i++] = '-';
 40c:	fd070793          	addi	a5,a4,-48
 410:	00878733          	add	a4,a5,s0
 414:	02d00793          	li	a5,45
 418:	fef70823          	sb	a5,-16(a4)
 41c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 420:	02e05863          	blez	a4,450 <printint+0x96>
 424:	fc040793          	addi	a5,s0,-64
 428:	00e78933          	add	s2,a5,a4
 42c:	fff78993          	addi	s3,a5,-1
 430:	99ba                	add	s3,s3,a4
 432:	377d                	addiw	a4,a4,-1
 434:	1702                	slli	a4,a4,0x20
 436:	9301                	srli	a4,a4,0x20
 438:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 43c:	fff94583          	lbu	a1,-1(s2)
 440:	8526                	mv	a0,s1
 442:	00000097          	auipc	ra,0x0
 446:	f56080e7          	jalr	-170(ra) # 398 <putc>
  while(--i >= 0)
 44a:	197d                	addi	s2,s2,-1
 44c:	ff3918e3          	bne	s2,s3,43c <printint+0x82>
}
 450:	70e2                	ld	ra,56(sp)
 452:	7442                	ld	s0,48(sp)
 454:	74a2                	ld	s1,40(sp)
 456:	7902                	ld	s2,32(sp)
 458:	69e2                	ld	s3,24(sp)
 45a:	6121                	addi	sp,sp,64
 45c:	8082                	ret
    x = -xx;
 45e:	40b005bb          	negw	a1,a1
    neg = 1;
 462:	4885                	li	a7,1
    x = -xx;
 464:	bf85                	j	3d4 <printint+0x1a>

0000000000000466 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 466:	7119                	addi	sp,sp,-128
 468:	fc86                	sd	ra,120(sp)
 46a:	f8a2                	sd	s0,112(sp)
 46c:	f4a6                	sd	s1,104(sp)
 46e:	f0ca                	sd	s2,96(sp)
 470:	ecce                	sd	s3,88(sp)
 472:	e8d2                	sd	s4,80(sp)
 474:	e4d6                	sd	s5,72(sp)
 476:	e0da                	sd	s6,64(sp)
 478:	fc5e                	sd	s7,56(sp)
 47a:	f862                	sd	s8,48(sp)
 47c:	f466                	sd	s9,40(sp)
 47e:	f06a                	sd	s10,32(sp)
 480:	ec6e                	sd	s11,24(sp)
 482:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 484:	0005c903          	lbu	s2,0(a1)
 488:	18090f63          	beqz	s2,626 <vprintf+0x1c0>
 48c:	8aaa                	mv	s5,a0
 48e:	8b32                	mv	s6,a2
 490:	00158493          	addi	s1,a1,1
  state = 0;
 494:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 496:	02500a13          	li	s4,37
 49a:	4c55                	li	s8,21
 49c:	00000c97          	auipc	s9,0x0
 4a0:	5e4c8c93          	addi	s9,s9,1508 # a80 <ithread_join+0x72>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4a4:	02800d93          	li	s11,40
  putc(fd, 'x');
 4a8:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4aa:	00000b97          	auipc	s7,0x0
 4ae:	62eb8b93          	addi	s7,s7,1582 # ad8 <digits>
 4b2:	a839                	j	4d0 <vprintf+0x6a>
        putc(fd, c);
 4b4:	85ca                	mv	a1,s2
 4b6:	8556                	mv	a0,s5
 4b8:	00000097          	auipc	ra,0x0
 4bc:	ee0080e7          	jalr	-288(ra) # 398 <putc>
 4c0:	a019                	j	4c6 <vprintf+0x60>
    } else if(state == '%'){
 4c2:	01498d63          	beq	s3,s4,4dc <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4c6:	0485                	addi	s1,s1,1
 4c8:	fff4c903          	lbu	s2,-1(s1)
 4cc:	14090d63          	beqz	s2,626 <vprintf+0x1c0>
    if(state == 0){
 4d0:	fe0999e3          	bnez	s3,4c2 <vprintf+0x5c>
      if(c == '%'){
 4d4:	ff4910e3          	bne	s2,s4,4b4 <vprintf+0x4e>
        state = '%';
 4d8:	89d2                	mv	s3,s4
 4da:	b7f5                	j	4c6 <vprintf+0x60>
      if(c == 'd'){
 4dc:	11490c63          	beq	s2,s4,5f4 <vprintf+0x18e>
 4e0:	f9d9079b          	addiw	a5,s2,-99
 4e4:	0ff7f793          	zext.b	a5,a5
 4e8:	10fc6e63          	bltu	s8,a5,604 <vprintf+0x19e>
 4ec:	f9d9079b          	addiw	a5,s2,-99
 4f0:	0ff7f713          	zext.b	a4,a5
 4f4:	10ec6863          	bltu	s8,a4,604 <vprintf+0x19e>
 4f8:	00271793          	slli	a5,a4,0x2
 4fc:	97e6                	add	a5,a5,s9
 4fe:	439c                	lw	a5,0(a5)
 500:	97e6                	add	a5,a5,s9
 502:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 504:	008b0913          	addi	s2,s6,8
 508:	4685                	li	a3,1
 50a:	4629                	li	a2,10
 50c:	000b2583          	lw	a1,0(s6)
 510:	8556                	mv	a0,s5
 512:	00000097          	auipc	ra,0x0
 516:	ea8080e7          	jalr	-344(ra) # 3ba <printint>
 51a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51c:	4981                	li	s3,0
 51e:	b765                	j	4c6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 520:	008b0913          	addi	s2,s6,8
 524:	4681                	li	a3,0
 526:	4629                	li	a2,10
 528:	000b2583          	lw	a1,0(s6)
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	e8c080e7          	jalr	-372(ra) # 3ba <printint>
 536:	8b4a                	mv	s6,s2
      state = 0;
 538:	4981                	li	s3,0
 53a:	b771                	j	4c6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 53c:	008b0913          	addi	s2,s6,8
 540:	4681                	li	a3,0
 542:	866a                	mv	a2,s10
 544:	000b2583          	lw	a1,0(s6)
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e70080e7          	jalr	-400(ra) # 3ba <printint>
 552:	8b4a                	mv	s6,s2
      state = 0;
 554:	4981                	li	s3,0
 556:	bf85                	j	4c6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 558:	008b0793          	addi	a5,s6,8
 55c:	f8f43423          	sd	a5,-120(s0)
 560:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 564:	03000593          	li	a1,48
 568:	8556                	mv	a0,s5
 56a:	00000097          	auipc	ra,0x0
 56e:	e2e080e7          	jalr	-466(ra) # 398 <putc>
  putc(fd, 'x');
 572:	07800593          	li	a1,120
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	e20080e7          	jalr	-480(ra) # 398 <putc>
 580:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 582:	03c9d793          	srli	a5,s3,0x3c
 586:	97de                	add	a5,a5,s7
 588:	0007c583          	lbu	a1,0(a5)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	e0a080e7          	jalr	-502(ra) # 398 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 596:	0992                	slli	s3,s3,0x4
 598:	397d                	addiw	s2,s2,-1
 59a:	fe0914e3          	bnez	s2,582 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 59e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b70d                	j	4c6 <vprintf+0x60>
        s = va_arg(ap, char*);
 5a6:	008b0913          	addi	s2,s6,8
 5aa:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5ae:	02098163          	beqz	s3,5d0 <vprintf+0x16a>
        while(*s != 0){
 5b2:	0009c583          	lbu	a1,0(s3)
 5b6:	c5ad                	beqz	a1,620 <vprintf+0x1ba>
          putc(fd, *s);
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	dde080e7          	jalr	-546(ra) # 398 <putc>
          s++;
 5c2:	0985                	addi	s3,s3,1
        while(*s != 0){
 5c4:	0009c583          	lbu	a1,0(s3)
 5c8:	f9e5                	bnez	a1,5b8 <vprintf+0x152>
        s = va_arg(ap, char*);
 5ca:	8b4a                	mv	s6,s2
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	bde5                	j	4c6 <vprintf+0x60>
          s = "(null)";
 5d0:	00000997          	auipc	s3,0x0
 5d4:	4a898993          	addi	s3,s3,1192 # a78 <ithread_join+0x6a>
        while(*s != 0){
 5d8:	85ee                	mv	a1,s11
 5da:	bff9                	j	5b8 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5dc:	008b0913          	addi	s2,s6,8
 5e0:	000b4583          	lbu	a1,0(s6)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	db2080e7          	jalr	-590(ra) # 398 <putc>
 5ee:	8b4a                	mv	s6,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bdd1                	j	4c6 <vprintf+0x60>
        putc(fd, c);
 5f4:	85d2                	mv	a1,s4
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	da0080e7          	jalr	-608(ra) # 398 <putc>
      state = 0;
 600:	4981                	li	s3,0
 602:	b5d1                	j	4c6 <vprintf+0x60>
        putc(fd, '%');
 604:	85d2                	mv	a1,s4
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	d90080e7          	jalr	-624(ra) # 398 <putc>
        putc(fd, c);
 610:	85ca                	mv	a1,s2
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	d84080e7          	jalr	-636(ra) # 398 <putc>
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b565                	j	4c6 <vprintf+0x60>
        s = va_arg(ap, char*);
 620:	8b4a                	mv	s6,s2
      state = 0;
 622:	4981                	li	s3,0
 624:	b54d                	j	4c6 <vprintf+0x60>
    }
  }
}
 626:	70e6                	ld	ra,120(sp)
 628:	7446                	ld	s0,112(sp)
 62a:	74a6                	ld	s1,104(sp)
 62c:	7906                	ld	s2,96(sp)
 62e:	69e6                	ld	s3,88(sp)
 630:	6a46                	ld	s4,80(sp)
 632:	6aa6                	ld	s5,72(sp)
 634:	6b06                	ld	s6,64(sp)
 636:	7be2                	ld	s7,56(sp)
 638:	7c42                	ld	s8,48(sp)
 63a:	7ca2                	ld	s9,40(sp)
 63c:	7d02                	ld	s10,32(sp)
 63e:	6de2                	ld	s11,24(sp)
 640:	6109                	addi	sp,sp,128
 642:	8082                	ret

0000000000000644 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 644:	715d                	addi	sp,sp,-80
 646:	ec06                	sd	ra,24(sp)
 648:	e822                	sd	s0,16(sp)
 64a:	1000                	addi	s0,sp,32
 64c:	e010                	sd	a2,0(s0)
 64e:	e414                	sd	a3,8(s0)
 650:	e818                	sd	a4,16(s0)
 652:	ec1c                	sd	a5,24(s0)
 654:	03043023          	sd	a6,32(s0)
 658:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 65c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 660:	8622                	mv	a2,s0
 662:	00000097          	auipc	ra,0x0
 666:	e04080e7          	jalr	-508(ra) # 466 <vprintf>
}
 66a:	60e2                	ld	ra,24(sp)
 66c:	6442                	ld	s0,16(sp)
 66e:	6161                	addi	sp,sp,80
 670:	8082                	ret

0000000000000672 <printf>:

void
printf(const char *fmt, ...)
{
 672:	711d                	addi	sp,sp,-96
 674:	ec06                	sd	ra,24(sp)
 676:	e822                	sd	s0,16(sp)
 678:	1000                	addi	s0,sp,32
 67a:	e40c                	sd	a1,8(s0)
 67c:	e810                	sd	a2,16(s0)
 67e:	ec14                	sd	a3,24(s0)
 680:	f018                	sd	a4,32(s0)
 682:	f41c                	sd	a5,40(s0)
 684:	03043823          	sd	a6,48(s0)
 688:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 68c:	00840613          	addi	a2,s0,8
 690:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 694:	85aa                	mv	a1,a0
 696:	4505                	li	a0,1
 698:	00000097          	auipc	ra,0x0
 69c:	dce080e7          	jalr	-562(ra) # 466 <vprintf>
}
 6a0:	60e2                	ld	ra,24(sp)
 6a2:	6442                	ld	s0,16(sp)
 6a4:	6125                	addi	sp,sp,96
 6a6:	8082                	ret

00000000000006a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a8:	1141                	addi	sp,sp,-16
 6aa:	e422                	sd	s0,8(sp)
 6ac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b2:	00001797          	auipc	a5,0x1
 6b6:	95e7b783          	ld	a5,-1698(a5) # 1010 <freep>
 6ba:	a02d                	j	6e4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6bc:	4618                	lw	a4,8(a2)
 6be:	9f2d                	addw	a4,a4,a1
 6c0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c4:	6398                	ld	a4,0(a5)
 6c6:	6310                	ld	a2,0(a4)
 6c8:	a83d                	j	706 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ca:	ff852703          	lw	a4,-8(a0)
 6ce:	9f31                	addw	a4,a4,a2
 6d0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6d2:	ff053683          	ld	a3,-16(a0)
 6d6:	a091                	j	71a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d8:	6398                	ld	a4,0(a5)
 6da:	00e7e463          	bltu	a5,a4,6e2 <free+0x3a>
 6de:	00e6ea63          	bltu	a3,a4,6f2 <free+0x4a>
{
 6e2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	fed7fae3          	bgeu	a5,a3,6d8 <free+0x30>
 6e8:	6398                	ld	a4,0(a5)
 6ea:	00e6e463          	bltu	a3,a4,6f2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ee:	fee7eae3          	bltu	a5,a4,6e2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6f2:	ff852583          	lw	a1,-8(a0)
 6f6:	6390                	ld	a2,0(a5)
 6f8:	02059813          	slli	a6,a1,0x20
 6fc:	01c85713          	srli	a4,a6,0x1c
 700:	9736                	add	a4,a4,a3
 702:	fae60de3          	beq	a2,a4,6bc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 706:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 70a:	4790                	lw	a2,8(a5)
 70c:	02061593          	slli	a1,a2,0x20
 710:	01c5d713          	srli	a4,a1,0x1c
 714:	973e                	add	a4,a4,a5
 716:	fae68ae3          	beq	a3,a4,6ca <free+0x22>
    p->s.ptr = bp->s.ptr;
 71a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 71c:	00001717          	auipc	a4,0x1
 720:	8ef73a23          	sd	a5,-1804(a4) # 1010 <freep>
}
 724:	6422                	ld	s0,8(sp)
 726:	0141                	addi	sp,sp,16
 728:	8082                	ret

000000000000072a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 72a:	7139                	addi	sp,sp,-64
 72c:	fc06                	sd	ra,56(sp)
 72e:	f822                	sd	s0,48(sp)
 730:	f426                	sd	s1,40(sp)
 732:	f04a                	sd	s2,32(sp)
 734:	ec4e                	sd	s3,24(sp)
 736:	e852                	sd	s4,16(sp)
 738:	e456                	sd	s5,8(sp)
 73a:	e05a                	sd	s6,0(sp)
 73c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73e:	02051493          	slli	s1,a0,0x20
 742:	9081                	srli	s1,s1,0x20
 744:	04bd                	addi	s1,s1,15
 746:	8091                	srli	s1,s1,0x4
 748:	0014899b          	addiw	s3,s1,1
 74c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 74e:	00001517          	auipc	a0,0x1
 752:	8c253503          	ld	a0,-1854(a0) # 1010 <freep>
 756:	c515                	beqz	a0,782 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 758:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 75a:	4798                	lw	a4,8(a5)
 75c:	02977f63          	bgeu	a4,s1,79a <malloc+0x70>
 760:	8a4e                	mv	s4,s3
 762:	0009871b          	sext.w	a4,s3
 766:	6685                	lui	a3,0x1
 768:	00d77363          	bgeu	a4,a3,76e <malloc+0x44>
 76c:	6a05                	lui	s4,0x1
 76e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 772:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 776:	00001917          	auipc	s2,0x1
 77a:	89a90913          	addi	s2,s2,-1894 # 1010 <freep>
  if(p == (char*)-1)
 77e:	5afd                	li	s5,-1
 780:	a895                	j	7f4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 782:	00001797          	auipc	a5,0x1
 786:	8ae78793          	addi	a5,a5,-1874 # 1030 <base>
 78a:	00001717          	auipc	a4,0x1
 78e:	88f73323          	sd	a5,-1914(a4) # 1010 <freep>
 792:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 794:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 798:	b7e1                	j	760 <malloc+0x36>
      if(p->s.size == nunits)
 79a:	02e48c63          	beq	s1,a4,7d2 <malloc+0xa8>
        p->s.size -= nunits;
 79e:	4137073b          	subw	a4,a4,s3
 7a2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7a4:	02071693          	slli	a3,a4,0x20
 7a8:	01c6d713          	srli	a4,a3,0x1c
 7ac:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7ae:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7b2:	00001717          	auipc	a4,0x1
 7b6:	84a73f23          	sd	a0,-1954(a4) # 1010 <freep>
      return (void*)(p + 1);
 7ba:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7be:	70e2                	ld	ra,56(sp)
 7c0:	7442                	ld	s0,48(sp)
 7c2:	74a2                	ld	s1,40(sp)
 7c4:	7902                	ld	s2,32(sp)
 7c6:	69e2                	ld	s3,24(sp)
 7c8:	6a42                	ld	s4,16(sp)
 7ca:	6aa2                	ld	s5,8(sp)
 7cc:	6b02                	ld	s6,0(sp)
 7ce:	6121                	addi	sp,sp,64
 7d0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7d2:	6398                	ld	a4,0(a5)
 7d4:	e118                	sd	a4,0(a0)
 7d6:	bff1                	j	7b2 <malloc+0x88>
  hp->s.size = nu;
 7d8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7dc:	0541                	addi	a0,a0,16
 7de:	00000097          	auipc	ra,0x0
 7e2:	eca080e7          	jalr	-310(ra) # 6a8 <free>
  return freep;
 7e6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ea:	d971                	beqz	a0,7be <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ee:	4798                	lw	a4,8(a5)
 7f0:	fa9775e3          	bgeu	a4,s1,79a <malloc+0x70>
    if(p == freep)
 7f4:	00093703          	ld	a4,0(s2)
 7f8:	853e                	mv	a0,a5
 7fa:	fef719e3          	bne	a4,a5,7ec <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7fe:	8552                	mv	a0,s4
 800:	00000097          	auipc	ra,0x0
 804:	b60080e7          	jalr	-1184(ra) # 360 <sbrk>
  if(p == (char*)-1)
 808:	fd5518e3          	bne	a0,s5,7d8 <malloc+0xae>
        return 0;
 80c:	4501                	li	a0,0
 80e:	bf45                	j	7be <malloc+0x94>

0000000000000810 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 810:	1141                	addi	sp,sp,-16
 812:	e406                	sd	ra,8(sp)
 814:	e022                	sd	s0,0(sp)
 816:	0800                	addi	s0,sp,16
  thread_exit(status);
 818:	00000097          	auipc	ra,0x0
 81c:	b78080e7          	jalr	-1160(ra) # 390 <thread_exit>
}
 820:	60a2                	ld	ra,8(sp)
 822:	6402                	ld	s0,0(sp)
 824:	0141                	addi	sp,sp,16
 826:	8082                	ret

0000000000000828 <free_stacks>:
int free_stacks() {
 828:	7179                	addi	sp,sp,-48
 82a:	f406                	sd	ra,40(sp)
 82c:	f022                	sd	s0,32(sp)
 82e:	ec26                	sd	s1,24(sp)
 830:	e84a                	sd	s2,16(sp)
 832:	e44e                	sd	s3,8(sp)
 834:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 836:	00000797          	auipc	a5,0x0
 83a:	7ea7a783          	lw	a5,2026(a5) # 1020 <num_threads>
 83e:	02f05c63          	blez	a5,876 <free_stacks+0x4e>
 842:	4481                	li	s1,0
    free(stacks[i]);
 844:	00000997          	auipc	s3,0x0
 848:	7d498993          	addi	s3,s3,2004 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 84c:	00000917          	auipc	s2,0x0
 850:	7d490913          	addi	s2,s2,2004 # 1020 <num_threads>
    free(stacks[i]);
 854:	0009b783          	ld	a5,0(s3)
 858:	00349713          	slli	a4,s1,0x3
 85c:	97ba                	add	a5,a5,a4
 85e:	6388                	ld	a0,0(a5)
 860:	00000097          	auipc	ra,0x0
 864:	e48080e7          	jalr	-440(ra) # 6a8 <free>
  for (int i = 0; i < num_threads; i++) {
 868:	0485                	addi	s1,s1,1
 86a:	00092703          	lw	a4,0(s2)
 86e:	0004879b          	sext.w	a5,s1
 872:	fee7c1e3          	blt	a5,a4,854 <free_stacks+0x2c>
  free(stacks);
 876:	00000497          	auipc	s1,0x0
 87a:	7a248493          	addi	s1,s1,1954 # 1018 <stacks>
 87e:	6088                	ld	a0,0(s1)
 880:	00000097          	auipc	ra,0x0
 884:	e28080e7          	jalr	-472(ra) # 6a8 <free>
  stacks = 0;
 888:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 88c:	00000797          	auipc	a5,0x0
 890:	7807aa23          	sw	zero,1940(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 894:	47a1                	li	a5,8
 896:	00000717          	auipc	a4,0x0
 89a:	76f72523          	sw	a5,1898(a4) # 1000 <max_stacks>
  threads_done = 0;
 89e:	00000797          	auipc	a5,0x0
 8a2:	7807a323          	sw	zero,1926(a5) # 1024 <threads_done>
}
 8a6:	4501                	li	a0,0
 8a8:	70a2                	ld	ra,40(sp)
 8aa:	7402                	ld	s0,32(sp)
 8ac:	64e2                	ld	s1,24(sp)
 8ae:	6942                	ld	s2,16(sp)
 8b0:	69a2                	ld	s3,8(sp)
 8b2:	6145                	addi	sp,sp,48
 8b4:	8082                	ret

00000000000008b6 <expand_num_threads>:
int expand_num_threads() {
 8b6:	1101                	addi	sp,sp,-32
 8b8:	ec06                	sd	ra,24(sp)
 8ba:	e822                	sd	s0,16(sp)
 8bc:	e426                	sd	s1,8(sp)
 8be:	e04a                	sd	s2,0(sp)
 8c0:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 8c2:	00000797          	auipc	a5,0x0
 8c6:	73e78793          	addi	a5,a5,1854 # 1000 <max_stacks>
 8ca:	4388                	lw	a0,0(a5)
 8cc:	0015151b          	slliw	a0,a0,0x1
 8d0:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 8d2:	0035151b          	slliw	a0,a0,0x3
 8d6:	00000097          	auipc	ra,0x0
 8da:	e54080e7          	jalr	-428(ra) # 72a <malloc>
 8de:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 8e0:	00000617          	auipc	a2,0x0
 8e4:	74062603          	lw	a2,1856(a2) # 1020 <num_threads>
 8e8:	00000497          	auipc	s1,0x0
 8ec:	73048493          	addi	s1,s1,1840 # 1018 <stacks>
 8f0:	0036161b          	slliw	a2,a2,0x3
 8f4:	608c                	ld	a1,0(s1)
 8f6:	00000097          	auipc	ra,0x0
 8fa:	930080e7          	jalr	-1744(ra) # 226 <memmove>
  free(stacks);
 8fe:	6088                	ld	a0,0(s1)
 900:	00000097          	auipc	ra,0x0
 904:	da8080e7          	jalr	-600(ra) # 6a8 <free>
  stacks = new_stacks;
 908:	0124b023          	sd	s2,0(s1)
}
 90c:	4501                	li	a0,0
 90e:	60e2                	ld	ra,24(sp)
 910:	6442                	ld	s0,16(sp)
 912:	64a2                	ld	s1,8(sp)
 914:	6902                	ld	s2,0(sp)
 916:	6105                	addi	sp,sp,32
 918:	8082                	ret

000000000000091a <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 91a:	7179                	addi	sp,sp,-48
 91c:	f406                	sd	ra,40(sp)
 91e:	f022                	sd	s0,32(sp)
 920:	ec26                	sd	s1,24(sp)
 922:	e84a                	sd	s2,16(sp)
 924:	e44e                	sd	s3,8(sp)
 926:	1800                	addi	s0,sp,48
 928:	892a                	mv	s2,a0
 92a:	89ae                	mv	s3,a1
  if (stacks == 0) {
 92c:	00000797          	auipc	a5,0x0
 930:	6ec7b783          	ld	a5,1772(a5) # 1018 <stacks>
 934:	c3d1                	beqz	a5,9b8 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 936:	00000797          	auipc	a5,0x0
 93a:	6ca7a783          	lw	a5,1738(a5) # 1000 <max_stacks>
 93e:	00000717          	auipc	a4,0x0
 942:	6e272703          	lw	a4,1762(a4) # 1020 <num_threads>
 946:	00f71a63          	bne	a4,a5,95a <ithread_create+0x40>
    if (max_stacks == MAX_THREADS) {
 94a:	04000713          	li	a4,64
 94e:	08e78463          	beq	a5,a4,9d6 <ithread_create+0xbc>
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 952:	00000097          	auipc	ra,0x0
 956:	f64080e7          	jalr	-156(ra) # 8b6 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 95a:	6505                	lui	a0,0x1
 95c:	00000097          	auipc	ra,0x0
 960:	dce080e7          	jalr	-562(ra) # 72a <malloc>
 964:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 966:	00000717          	auipc	a4,0x0
 96a:	6ba72703          	lw	a4,1722(a4) # 1020 <num_threads>
 96e:	070e                	slli	a4,a4,0x3
 970:	00000797          	auipc	a5,0x0
 974:	6a87b783          	ld	a5,1704(a5) # 1018 <stacks>
 978:	97ba                	add	a5,a5,a4
 97a:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 97c:	00000697          	auipc	a3,0x0
 980:	e9468693          	addi	a3,a3,-364 # 810 <ithread_exit>
 984:	862a                	mv	a2,a0
 986:	85ce                	mv	a1,s3
 988:	854a                	mv	a0,s2
 98a:	00000097          	auipc	ra,0x0
 98e:	9f6080e7          	jalr	-1546(ra) # 380 <create_thread>
 992:	892a                	mv	s2,a0
  if (res != -1) {
 994:	57fd                	li	a5,-1
 996:	04f50a63          	beq	a0,a5,9ea <ithread_create+0xd0>
    num_threads++;
 99a:	00000717          	auipc	a4,0x0
 99e:	68670713          	addi	a4,a4,1670 # 1020 <num_threads>
 9a2:	431c                	lw	a5,0(a4)
 9a4:	2785                	addiw	a5,a5,1
 9a6:	c31c                	sw	a5,0(a4)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 9a8:	854a                	mv	a0,s2
 9aa:	70a2                	ld	ra,40(sp)
 9ac:	7402                	ld	s0,32(sp)
 9ae:	64e2                	ld	s1,24(sp)
 9b0:	6942                	ld	s2,16(sp)
 9b2:	69a2                	ld	s3,8(sp)
 9b4:	6145                	addi	sp,sp,48
 9b6:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 9b8:	00000517          	auipc	a0,0x0
 9bc:	64852503          	lw	a0,1608(a0) # 1000 <max_stacks>
 9c0:	0035151b          	slliw	a0,a0,0x3
 9c4:	00000097          	auipc	ra,0x0
 9c8:	d66080e7          	jalr	-666(ra) # 72a <malloc>
 9cc:	00000797          	auipc	a5,0x0
 9d0:	64a7b623          	sd	a0,1612(a5) # 1018 <stacks>
 9d4:	b78d                	j	936 <ithread_create+0x1c>
      printf("ERROR: Thread capacity has been reached\n");
 9d6:	00000517          	auipc	a0,0x0
 9da:	11a50513          	addi	a0,a0,282 # af0 <digits+0x18>
 9de:	00000097          	auipc	ra,0x0
 9e2:	c94080e7          	jalr	-876(ra) # 672 <printf>
      return -1;
 9e6:	597d                	li	s2,-1
 9e8:	b7c1                	j	9a8 <ithread_create+0x8e>
    free(stack_ptr);
 9ea:	8526                	mv	a0,s1
 9ec:	00000097          	auipc	ra,0x0
 9f0:	cbc080e7          	jalr	-836(ra) # 6a8 <free>
    stacks[num_threads] = 0;
 9f4:	00000717          	auipc	a4,0x0
 9f8:	62c72703          	lw	a4,1580(a4) # 1020 <num_threads>
 9fc:	070e                	slli	a4,a4,0x3
 9fe:	00000797          	auipc	a5,0x0
 a02:	61a7b783          	ld	a5,1562(a5) # 1018 <stacks>
 a06:	97ba                	add	a5,a5,a4
 a08:	0007b023          	sd	zero,0(a5)
 a0c:	bf71                	j	9a8 <ithread_create+0x8e>

0000000000000a0e <ithread_join>:

int ithread_join(int thread_id) {
 a0e:	1101                	addi	sp,sp,-32
 a10:	ec06                	sd	ra,24(sp)
 a12:	e822                	sd	s0,16(sp)
 a14:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a16:	fec40593          	addi	a1,s0,-20
 a1a:	00000097          	auipc	ra,0x0
 a1e:	96e080e7          	jalr	-1682(ra) # 388 <join_thread>
  threads_done++;
 a22:	00000717          	auipc	a4,0x0
 a26:	60270713          	addi	a4,a4,1538 # 1024 <threads_done>
 a2a:	431c                	lw	a5,0(a4)
 a2c:	2785                	addiw	a5,a5,1
 a2e:	0007869b          	sext.w	a3,a5
 a32:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a34:	00000797          	auipc	a5,0x0
 a38:	5ec7a783          	lw	a5,1516(a5) # 1020 <num_threads>
 a3c:	00d78863          	beq	a5,a3,a4c <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 a40:	fec42503          	lw	a0,-20(s0)
 a44:	60e2                	ld	ra,24(sp)
 a46:	6442                	ld	s0,16(sp)
 a48:	6105                	addi	sp,sp,32
 a4a:	8082                	ret
    free_stacks();
 a4c:	00000097          	auipc	ra,0x0
 a50:	ddc080e7          	jalr	-548(ra) # 828 <free_stacks>
 a54:	b7f5                	j	a40 <ithread_join+0x32>
