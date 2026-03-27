
src/user/_debug:     file format elf64-littleriscv


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
  16:	754080e7          	jalr	1876(ra) # 766 <malloc>
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
  32:	a9298993          	addi	s3,s3,-1390 # ac0 <ithread_join+0x54>
  36:	02049713          	slli	a4,s1,0x20
  3a:	01e75793          	srli	a5,a4,0x1e
  3e:	97ca                	add	a5,a5,s2
  40:	4390                	lw	a2,0(a5)
  42:	85a6                	mv	a1,s1
  44:	854e                	mv	a0,s3
  46:	00000097          	auipc	ra,0x0
  4a:	668080e7          	jalr	1640(ra) # 6ae <printf>
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
  c4:	86be                	mv	a3,a5
  c6:	0785                	addi	a5,a5,1
  c8:	fff7c703          	lbu	a4,-1(a5)
  cc:	ff65                	bnez	a4,c4 <strlen+0x10>
  ce:	40a6853b          	subw	a0,a3,a0
  d2:	2505                	addiw	a0,a0,1
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
    buf[i++] = c;
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
 19e:	e04a                	sd	s2,0(sp)
 1a0:	1000                	addi	s0,sp,32
 1a2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a4:	4581                	li	a1,0
 1a6:	00000097          	auipc	ra,0x0
 1aa:	172080e7          	jalr	370(ra) # 318 <open>
  if(fd < 0)
 1ae:	02054663          	bltz	a0,1da <stat+0x42>
 1b2:	e426                	sd	s1,8(sp)
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
 24a:	fef71ae3          	bne	a4,a5,23e <memmove+0x18>
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

0000000000000398 <socket>:
.global socket
socket:
 li a7, SYS_socket
 398:	48e9                	li	a7,26
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3a0:	48ed                	li	a7,27
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3a8:	48f5                	li	a7,29
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <listen>:
.global listen
listen:
 li a7, SYS_listen
 3b0:	48f1                	li	a7,28
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3b8:	48f9                	li	a7,30
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <send>:
.global send
send:
 li a7, SYS_send
 3c0:	48fd                	li	a7,31
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <recv>:
.global recv
recv:
 li a7, SYS_recv
 3c8:	02000893          	li	a7,32
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 3d2:	02100893          	li	a7,33
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 3dc:	02200893          	li	a7,34
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e6:	1101                	addi	sp,sp,-32
 3e8:	ec06                	sd	ra,24(sp)
 3ea:	e822                	sd	s0,16(sp)
 3ec:	1000                	addi	s0,sp,32
 3ee:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f2:	4605                	li	a2,1
 3f4:	fef40593          	addi	a1,s0,-17
 3f8:	00000097          	auipc	ra,0x0
 3fc:	f00080e7          	jalr	-256(ra) # 2f8 <write>
}
 400:	60e2                	ld	ra,24(sp)
 402:	6442                	ld	s0,16(sp)
 404:	6105                	addi	sp,sp,32
 406:	8082                	ret

0000000000000408 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 408:	7139                	addi	sp,sp,-64
 40a:	fc06                	sd	ra,56(sp)
 40c:	f822                	sd	s0,48(sp)
 40e:	f426                	sd	s1,40(sp)
 410:	0080                	addi	s0,sp,64
 412:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 414:	c299                	beqz	a3,41a <printint+0x12>
 416:	0805cb63          	bltz	a1,4ac <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 41a:	2581                	sext.w	a1,a1
  neg = 0;
 41c:	4881                	li	a7,0
 41e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 422:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 424:	2601                	sext.w	a2,a2
 426:	00000517          	auipc	a0,0x0
 42a:	74250513          	addi	a0,a0,1858 # b68 <digits>
 42e:	883a                	mv	a6,a4
 430:	2705                	addiw	a4,a4,1
 432:	02c5f7bb          	remuw	a5,a1,a2
 436:	1782                	slli	a5,a5,0x20
 438:	9381                	srli	a5,a5,0x20
 43a:	97aa                	add	a5,a5,a0
 43c:	0007c783          	lbu	a5,0(a5)
 440:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 444:	0005879b          	sext.w	a5,a1
 448:	02c5d5bb          	divuw	a1,a1,a2
 44c:	0685                	addi	a3,a3,1
 44e:	fec7f0e3          	bgeu	a5,a2,42e <printint+0x26>
  if(neg)
 452:	00088c63          	beqz	a7,46a <printint+0x62>
    buf[i++] = '-';
 456:	fd070793          	addi	a5,a4,-48
 45a:	00878733          	add	a4,a5,s0
 45e:	02d00793          	li	a5,45
 462:	fef70823          	sb	a5,-16(a4)
 466:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 46a:	02e05c63          	blez	a4,4a2 <printint+0x9a>
 46e:	f04a                	sd	s2,32(sp)
 470:	ec4e                	sd	s3,24(sp)
 472:	fc040793          	addi	a5,s0,-64
 476:	00e78933          	add	s2,a5,a4
 47a:	fff78993          	addi	s3,a5,-1
 47e:	99ba                	add	s3,s3,a4
 480:	377d                	addiw	a4,a4,-1
 482:	1702                	slli	a4,a4,0x20
 484:	9301                	srli	a4,a4,0x20
 486:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48a:	fff94583          	lbu	a1,-1(s2)
 48e:	8526                	mv	a0,s1
 490:	00000097          	auipc	ra,0x0
 494:	f56080e7          	jalr	-170(ra) # 3e6 <putc>
  while(--i >= 0)
 498:	197d                	addi	s2,s2,-1
 49a:	ff3918e3          	bne	s2,s3,48a <printint+0x82>
 49e:	7902                	ld	s2,32(sp)
 4a0:	69e2                	ld	s3,24(sp)
}
 4a2:	70e2                	ld	ra,56(sp)
 4a4:	7442                	ld	s0,48(sp)
 4a6:	74a2                	ld	s1,40(sp)
 4a8:	6121                	addi	sp,sp,64
 4aa:	8082                	ret
    x = -xx;
 4ac:	40b005bb          	negw	a1,a1
    neg = 1;
 4b0:	4885                	li	a7,1
    x = -xx;
 4b2:	b7b5                	j	41e <printint+0x16>

00000000000004b4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b4:	715d                	addi	sp,sp,-80
 4b6:	e486                	sd	ra,72(sp)
 4b8:	e0a2                	sd	s0,64(sp)
 4ba:	f84a                	sd	s2,48(sp)
 4bc:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4be:	0005c903          	lbu	s2,0(a1)
 4c2:	1a090a63          	beqz	s2,676 <vprintf+0x1c2>
 4c6:	fc26                	sd	s1,56(sp)
 4c8:	f44e                	sd	s3,40(sp)
 4ca:	f052                	sd	s4,32(sp)
 4cc:	ec56                	sd	s5,24(sp)
 4ce:	e85a                	sd	s6,16(sp)
 4d0:	e45e                	sd	s7,8(sp)
 4d2:	8aaa                	mv	s5,a0
 4d4:	8bb2                	mv	s7,a2
 4d6:	00158493          	addi	s1,a1,1
  state = 0;
 4da:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4dc:	02500a13          	li	s4,37
 4e0:	4b55                	li	s6,21
 4e2:	a839                	j	500 <vprintf+0x4c>
        putc(fd, c);
 4e4:	85ca                	mv	a1,s2
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	efe080e7          	jalr	-258(ra) # 3e6 <putc>
 4f0:	a019                	j	4f6 <vprintf+0x42>
    } else if(state == '%'){
 4f2:	01498d63          	beq	s3,s4,50c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4f6:	0485                	addi	s1,s1,1
 4f8:	fff4c903          	lbu	s2,-1(s1)
 4fc:	16090763          	beqz	s2,66a <vprintf+0x1b6>
    if(state == 0){
 500:	fe0999e3          	bnez	s3,4f2 <vprintf+0x3e>
      if(c == '%'){
 504:	ff4910e3          	bne	s2,s4,4e4 <vprintf+0x30>
        state = '%';
 508:	89d2                	mv	s3,s4
 50a:	b7f5                	j	4f6 <vprintf+0x42>
      if(c == 'd'){
 50c:	13490463          	beq	s2,s4,634 <vprintf+0x180>
 510:	f9d9079b          	addiw	a5,s2,-99
 514:	0ff7f793          	zext.b	a5,a5
 518:	12fb6763          	bltu	s6,a5,646 <vprintf+0x192>
 51c:	f9d9079b          	addiw	a5,s2,-99
 520:	0ff7f713          	zext.b	a4,a5
 524:	12eb6163          	bltu	s6,a4,646 <vprintf+0x192>
 528:	00271793          	slli	a5,a4,0x2
 52c:	00000717          	auipc	a4,0x0
 530:	5e470713          	addi	a4,a4,1508 # b10 <ithread_join+0xa4>
 534:	97ba                	add	a5,a5,a4
 536:	439c                	lw	a5,0(a5)
 538:	97ba                	add	a5,a5,a4
 53a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 53c:	008b8913          	addi	s2,s7,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000ba583          	lw	a1,0(s7)
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	ebe080e7          	jalr	-322(ra) # 408 <printint>
 552:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 554:	4981                	li	s3,0
 556:	b745                	j	4f6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 558:	008b8913          	addi	s2,s7,8
 55c:	4681                	li	a3,0
 55e:	4629                	li	a2,10
 560:	000ba583          	lw	a1,0(s7)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	ea2080e7          	jalr	-350(ra) # 408 <printint>
 56e:	8bca                	mv	s7,s2
      state = 0;
 570:	4981                	li	s3,0
 572:	b751                	j	4f6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 574:	008b8913          	addi	s2,s7,8
 578:	4681                	li	a3,0
 57a:	4641                	li	a2,16
 57c:	000ba583          	lw	a1,0(s7)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e86080e7          	jalr	-378(ra) # 408 <printint>
 58a:	8bca                	mv	s7,s2
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b7a5                	j	4f6 <vprintf+0x42>
 590:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 592:	008b8c13          	addi	s8,s7,8
 596:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 59a:	03000593          	li	a1,48
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	e46080e7          	jalr	-442(ra) # 3e6 <putc>
  putc(fd, 'x');
 5a8:	07800593          	li	a1,120
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	e38080e7          	jalr	-456(ra) # 3e6 <putc>
 5b6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b8:	00000b97          	auipc	s7,0x0
 5bc:	5b0b8b93          	addi	s7,s7,1456 # b68 <digits>
 5c0:	03c9d793          	srli	a5,s3,0x3c
 5c4:	97de                	add	a5,a5,s7
 5c6:	0007c583          	lbu	a1,0(a5)
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e1a080e7          	jalr	-486(ra) # 3e6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5d4:	0992                	slli	s3,s3,0x4
 5d6:	397d                	addiw	s2,s2,-1
 5d8:	fe0914e3          	bnez	s2,5c0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5dc:	8be2                	mv	s7,s8
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	6c02                	ld	s8,0(sp)
 5e2:	bf11                	j	4f6 <vprintf+0x42>
        s = va_arg(ap, char*);
 5e4:	008b8993          	addi	s3,s7,8
 5e8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5ec:	02090163          	beqz	s2,60e <vprintf+0x15a>
        while(*s != 0){
 5f0:	00094583          	lbu	a1,0(s2)
 5f4:	c9a5                	beqz	a1,664 <vprintf+0x1b0>
          putc(fd, *s);
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	dee080e7          	jalr	-530(ra) # 3e6 <putc>
          s++;
 600:	0905                	addi	s2,s2,1
        while(*s != 0){
 602:	00094583          	lbu	a1,0(s2)
 606:	f9e5                	bnez	a1,5f6 <vprintf+0x142>
        s = va_arg(ap, char*);
 608:	8bce                	mv	s7,s3
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b5ed                	j	4f6 <vprintf+0x42>
          s = "(null)";
 60e:	00000917          	auipc	s2,0x0
 612:	4ca90913          	addi	s2,s2,1226 # ad8 <ithread_join+0x6c>
        while(*s != 0){
 616:	02800593          	li	a1,40
 61a:	bff1                	j	5f6 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 61c:	008b8913          	addi	s2,s7,8
 620:	000bc583          	lbu	a1,0(s7)
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	dc0080e7          	jalr	-576(ra) # 3e6 <putc>
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
 632:	b5d1                	j	4f6 <vprintf+0x42>
        putc(fd, c);
 634:	02500593          	li	a1,37
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	dac080e7          	jalr	-596(ra) # 3e6 <putc>
      state = 0;
 642:	4981                	li	s3,0
 644:	bd4d                	j	4f6 <vprintf+0x42>
        putc(fd, '%');
 646:	02500593          	li	a1,37
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	d9a080e7          	jalr	-614(ra) # 3e6 <putc>
        putc(fd, c);
 654:	85ca                	mv	a1,s2
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	d8e080e7          	jalr	-626(ra) # 3e6 <putc>
      state = 0;
 660:	4981                	li	s3,0
 662:	bd51                	j	4f6 <vprintf+0x42>
        s = va_arg(ap, char*);
 664:	8bce                	mv	s7,s3
      state = 0;
 666:	4981                	li	s3,0
 668:	b579                	j	4f6 <vprintf+0x42>
 66a:	74e2                	ld	s1,56(sp)
 66c:	79a2                	ld	s3,40(sp)
 66e:	7a02                	ld	s4,32(sp)
 670:	6ae2                	ld	s5,24(sp)
 672:	6b42                	ld	s6,16(sp)
 674:	6ba2                	ld	s7,8(sp)
    }
  }
}
 676:	60a6                	ld	ra,72(sp)
 678:	6406                	ld	s0,64(sp)
 67a:	7942                	ld	s2,48(sp)
 67c:	6161                	addi	sp,sp,80
 67e:	8082                	ret

0000000000000680 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 680:	715d                	addi	sp,sp,-80
 682:	ec06                	sd	ra,24(sp)
 684:	e822                	sd	s0,16(sp)
 686:	1000                	addi	s0,sp,32
 688:	e010                	sd	a2,0(s0)
 68a:	e414                	sd	a3,8(s0)
 68c:	e818                	sd	a4,16(s0)
 68e:	ec1c                	sd	a5,24(s0)
 690:	03043023          	sd	a6,32(s0)
 694:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 698:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 69c:	8622                	mv	a2,s0
 69e:	00000097          	auipc	ra,0x0
 6a2:	e16080e7          	jalr	-490(ra) # 4b4 <vprintf>
}
 6a6:	60e2                	ld	ra,24(sp)
 6a8:	6442                	ld	s0,16(sp)
 6aa:	6161                	addi	sp,sp,80
 6ac:	8082                	ret

00000000000006ae <printf>:

void
printf(const char *fmt, ...)
{
 6ae:	711d                	addi	sp,sp,-96
 6b0:	ec06                	sd	ra,24(sp)
 6b2:	e822                	sd	s0,16(sp)
 6b4:	1000                	addi	s0,sp,32
 6b6:	e40c                	sd	a1,8(s0)
 6b8:	e810                	sd	a2,16(s0)
 6ba:	ec14                	sd	a3,24(s0)
 6bc:	f018                	sd	a4,32(s0)
 6be:	f41c                	sd	a5,40(s0)
 6c0:	03043823          	sd	a6,48(s0)
 6c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c8:	00840613          	addi	a2,s0,8
 6cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d0:	85aa                	mv	a1,a0
 6d2:	4505                	li	a0,1
 6d4:	00000097          	auipc	ra,0x0
 6d8:	de0080e7          	jalr	-544(ra) # 4b4 <vprintf>
}
 6dc:	60e2                	ld	ra,24(sp)
 6de:	6442                	ld	s0,16(sp)
 6e0:	6125                	addi	sp,sp,96
 6e2:	8082                	ret

00000000000006e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e4:	1141                	addi	sp,sp,-16
 6e6:	e422                	sd	s0,8(sp)
 6e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ee:	00001797          	auipc	a5,0x1
 6f2:	9227b783          	ld	a5,-1758(a5) # 1010 <freep>
 6f6:	a02d                	j	720 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f8:	4618                	lw	a4,8(a2)
 6fa:	9f2d                	addw	a4,a4,a1
 6fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 700:	6398                	ld	a4,0(a5)
 702:	6310                	ld	a2,0(a4)
 704:	a83d                	j	742 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 706:	ff852703          	lw	a4,-8(a0)
 70a:	9f31                	addw	a4,a4,a2
 70c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 70e:	ff053683          	ld	a3,-16(a0)
 712:	a091                	j	756 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 714:	6398                	ld	a4,0(a5)
 716:	00e7e463          	bltu	a5,a4,71e <free+0x3a>
 71a:	00e6ea63          	bltu	a3,a4,72e <free+0x4a>
{
 71e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 720:	fed7fae3          	bgeu	a5,a3,714 <free+0x30>
 724:	6398                	ld	a4,0(a5)
 726:	00e6e463          	bltu	a3,a4,72e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72a:	fee7eae3          	bltu	a5,a4,71e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 72e:	ff852583          	lw	a1,-8(a0)
 732:	6390                	ld	a2,0(a5)
 734:	02059813          	slli	a6,a1,0x20
 738:	01c85713          	srli	a4,a6,0x1c
 73c:	9736                	add	a4,a4,a3
 73e:	fae60de3          	beq	a2,a4,6f8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 742:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 746:	4790                	lw	a2,8(a5)
 748:	02061593          	slli	a1,a2,0x20
 74c:	01c5d713          	srli	a4,a1,0x1c
 750:	973e                	add	a4,a4,a5
 752:	fae68ae3          	beq	a3,a4,706 <free+0x22>
    p->s.ptr = bp->s.ptr;
 756:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 758:	00001717          	auipc	a4,0x1
 75c:	8af73c23          	sd	a5,-1864(a4) # 1010 <freep>
}
 760:	6422                	ld	s0,8(sp)
 762:	0141                	addi	sp,sp,16
 764:	8082                	ret

0000000000000766 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 766:	7139                	addi	sp,sp,-64
 768:	fc06                	sd	ra,56(sp)
 76a:	f822                	sd	s0,48(sp)
 76c:	f426                	sd	s1,40(sp)
 76e:	ec4e                	sd	s3,24(sp)
 770:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 772:	02051493          	slli	s1,a0,0x20
 776:	9081                	srli	s1,s1,0x20
 778:	04bd                	addi	s1,s1,15
 77a:	8091                	srli	s1,s1,0x4
 77c:	0014899b          	addiw	s3,s1,1
 780:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 782:	00001517          	auipc	a0,0x1
 786:	88e53503          	ld	a0,-1906(a0) # 1010 <freep>
 78a:	c915                	beqz	a0,7be <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78e:	4798                	lw	a4,8(a5)
 790:	08977e63          	bgeu	a4,s1,82c <malloc+0xc6>
 794:	f04a                	sd	s2,32(sp)
 796:	e852                	sd	s4,16(sp)
 798:	e456                	sd	s5,8(sp)
 79a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 79c:	8a4e                	mv	s4,s3
 79e:	0009871b          	sext.w	a4,s3
 7a2:	6685                	lui	a3,0x1
 7a4:	00d77363          	bgeu	a4,a3,7aa <malloc+0x44>
 7a8:	6a05                	lui	s4,0x1
 7aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b2:	00001917          	auipc	s2,0x1
 7b6:	85e90913          	addi	s2,s2,-1954 # 1010 <freep>
  if(p == (char*)-1)
 7ba:	5afd                	li	s5,-1
 7bc:	a091                	j	800 <malloc+0x9a>
 7be:	f04a                	sd	s2,32(sp)
 7c0:	e852                	sd	s4,16(sp)
 7c2:	e456                	sd	s5,8(sp)
 7c4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7c6:	00001797          	auipc	a5,0x1
 7ca:	86a78793          	addi	a5,a5,-1942 # 1030 <base>
 7ce:	00001717          	auipc	a4,0x1
 7d2:	84f73123          	sd	a5,-1982(a4) # 1010 <freep>
 7d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7dc:	b7c1                	j	79c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7de:	6398                	ld	a4,0(a5)
 7e0:	e118                	sd	a4,0(a0)
 7e2:	a08d                	j	844 <malloc+0xde>
  hp->s.size = nu;
 7e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7e8:	0541                	addi	a0,a0,16
 7ea:	00000097          	auipc	ra,0x0
 7ee:	efa080e7          	jalr	-262(ra) # 6e4 <free>
  return freep;
 7f2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7f6:	c13d                	beqz	a0,85c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fa:	4798                	lw	a4,8(a5)
 7fc:	02977463          	bgeu	a4,s1,824 <malloc+0xbe>
    if(p == freep)
 800:	00093703          	ld	a4,0(s2)
 804:	853e                	mv	a0,a5
 806:	fef719e3          	bne	a4,a5,7f8 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 80a:	8552                	mv	a0,s4
 80c:	00000097          	auipc	ra,0x0
 810:	b54080e7          	jalr	-1196(ra) # 360 <sbrk>
  if(p == (char*)-1)
 814:	fd5518e3          	bne	a0,s5,7e4 <malloc+0x7e>
        return 0;
 818:	4501                	li	a0,0
 81a:	7902                	ld	s2,32(sp)
 81c:	6a42                	ld	s4,16(sp)
 81e:	6aa2                	ld	s5,8(sp)
 820:	6b02                	ld	s6,0(sp)
 822:	a03d                	j	850 <malloc+0xea>
 824:	7902                	ld	s2,32(sp)
 826:	6a42                	ld	s4,16(sp)
 828:	6aa2                	ld	s5,8(sp)
 82a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 82c:	fae489e3          	beq	s1,a4,7de <malloc+0x78>
        p->s.size -= nunits;
 830:	4137073b          	subw	a4,a4,s3
 834:	c798                	sw	a4,8(a5)
        p += p->s.size;
 836:	02071693          	slli	a3,a4,0x20
 83a:	01c6d713          	srli	a4,a3,0x1c
 83e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 840:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 844:	00000717          	auipc	a4,0x0
 848:	7ca73623          	sd	a0,1996(a4) # 1010 <freep>
      return (void*)(p + 1);
 84c:	01078513          	addi	a0,a5,16
  }
}
 850:	70e2                	ld	ra,56(sp)
 852:	7442                	ld	s0,48(sp)
 854:	74a2                	ld	s1,40(sp)
 856:	69e2                	ld	s3,24(sp)
 858:	6121                	addi	sp,sp,64
 85a:	8082                	ret
 85c:	7902                	ld	s2,32(sp)
 85e:	6a42                	ld	s4,16(sp)
 860:	6aa2                	ld	s5,8(sp)
 862:	6b02                	ld	s6,0(sp)
 864:	b7f5                	j	850 <malloc+0xea>

0000000000000866 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 866:	1141                	addi	sp,sp,-16
 868:	e406                	sd	ra,8(sp)
 86a:	e022                	sd	s0,0(sp)
 86c:	0800                	addi	s0,sp,16
  thread_exit(status);
 86e:	2501                	sext.w	a0,a0
 870:	00000097          	auipc	ra,0x0
 874:	b20080e7          	jalr	-1248(ra) # 390 <thread_exit>
}
 878:	60a2                	ld	ra,8(sp)
 87a:	6402                	ld	s0,0(sp)
 87c:	0141                	addi	sp,sp,16
 87e:	8082                	ret

0000000000000880 <free_stacks>:
int free_stacks() {
 880:	7179                	addi	sp,sp,-48
 882:	f406                	sd	ra,40(sp)
 884:	f022                	sd	s0,32(sp)
 886:	ec26                	sd	s1,24(sp)
 888:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 88a:	00000797          	auipc	a5,0x0
 88e:	7967a783          	lw	a5,1942(a5) # 1020 <num_threads>
 892:	04f05063          	blez	a5,8d2 <free_stacks+0x52>
 896:	e84a                	sd	s2,16(sp)
 898:	e44e                	sd	s3,8(sp)
 89a:	4481                	li	s1,0
    free(stacks[i]);
 89c:	00000997          	auipc	s3,0x0
 8a0:	77c98993          	addi	s3,s3,1916 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8a4:	00000917          	auipc	s2,0x0
 8a8:	77c90913          	addi	s2,s2,1916 # 1020 <num_threads>
    free(stacks[i]);
 8ac:	0009b783          	ld	a5,0(s3)
 8b0:	00349713          	slli	a4,s1,0x3
 8b4:	97ba                	add	a5,a5,a4
 8b6:	6388                	ld	a0,0(a5)
 8b8:	00000097          	auipc	ra,0x0
 8bc:	e2c080e7          	jalr	-468(ra) # 6e4 <free>
  for (int i = 0; i < num_threads; i++) {
 8c0:	0485                	addi	s1,s1,1
 8c2:	00092703          	lw	a4,0(s2)
 8c6:	0004879b          	sext.w	a5,s1
 8ca:	fee7c1e3          	blt	a5,a4,8ac <free_stacks+0x2c>
 8ce:	6942                	ld	s2,16(sp)
 8d0:	69a2                	ld	s3,8(sp)
  free(stacks);
 8d2:	00000497          	auipc	s1,0x0
 8d6:	74648493          	addi	s1,s1,1862 # 1018 <stacks>
 8da:	6088                	ld	a0,0(s1)
 8dc:	00000097          	auipc	ra,0x0
 8e0:	e08080e7          	jalr	-504(ra) # 6e4 <free>
  stacks = 0;
 8e4:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8e8:	00000797          	auipc	a5,0x0
 8ec:	7207ac23          	sw	zero,1848(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8f0:	47a1                	li	a5,8
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70f72723          	sw	a5,1806(a4) # 1000 <max_stacks>
  threads_done = 0;
 8fa:	00000797          	auipc	a5,0x0
 8fe:	7207a523          	sw	zero,1834(a5) # 1024 <threads_done>
}
 902:	4501                	li	a0,0
 904:	70a2                	ld	ra,40(sp)
 906:	7402                	ld	s0,32(sp)
 908:	64e2                	ld	s1,24(sp)
 90a:	6145                	addi	sp,sp,48
 90c:	8082                	ret

000000000000090e <expand_num_threads>:
int expand_num_threads() {
 90e:	1101                	addi	sp,sp,-32
 910:	ec06                	sd	ra,24(sp)
 912:	e822                	sd	s0,16(sp)
 914:	e426                	sd	s1,8(sp)
 916:	e04a                	sd	s2,0(sp)
 918:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 91a:	00000797          	auipc	a5,0x0
 91e:	6e678793          	addi	a5,a5,1766 # 1000 <max_stacks>
 922:	4388                	lw	a0,0(a5)
 924:	0015151b          	slliw	a0,a0,0x1
 928:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 92a:	0035151b          	slliw	a0,a0,0x3
 92e:	00000097          	auipc	ra,0x0
 932:	e38080e7          	jalr	-456(ra) # 766 <malloc>
 936:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 938:	00000617          	auipc	a2,0x0
 93c:	6e862603          	lw	a2,1768(a2) # 1020 <num_threads>
 940:	00000497          	auipc	s1,0x0
 944:	6d848493          	addi	s1,s1,1752 # 1018 <stacks>
 948:	0036161b          	slliw	a2,a2,0x3
 94c:	608c                	ld	a1,0(s1)
 94e:	00000097          	auipc	ra,0x0
 952:	8d8080e7          	jalr	-1832(ra) # 226 <memmove>
  free(stacks);
 956:	6088                	ld	a0,0(s1)
 958:	00000097          	auipc	ra,0x0
 95c:	d8c080e7          	jalr	-628(ra) # 6e4 <free>
  stacks = new_stacks;
 960:	0124b023          	sd	s2,0(s1)
}
 964:	4501                	li	a0,0
 966:	60e2                	ld	ra,24(sp)
 968:	6442                	ld	s0,16(sp)
 96a:	64a2                	ld	s1,8(sp)
 96c:	6902                	ld	s2,0(sp)
 96e:	6105                	addi	sp,sp,32
 970:	8082                	ret

0000000000000972 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 972:	7179                	addi	sp,sp,-48
 974:	f406                	sd	ra,40(sp)
 976:	f022                	sd	s0,32(sp)
 978:	e84a                	sd	s2,16(sp)
 97a:	e44e                	sd	s3,8(sp)
 97c:	1800                	addi	s0,sp,48
 97e:	892a                	mv	s2,a0
 980:	89ae                	mv	s3,a1
  if (stacks == 0) {
 982:	00000797          	auipc	a5,0x0
 986:	6967b783          	ld	a5,1686(a5) # 1018 <stacks>
 98a:	c3d9                	beqz	a5,a10 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 98c:	00000797          	auipc	a5,0x0
 990:	6747a783          	lw	a5,1652(a5) # 1000 <max_stacks>
 994:	00000717          	auipc	a4,0x0
 998:	68c72703          	lw	a4,1676(a4) # 1020 <num_threads>
 99c:	0af71363          	bne	a4,a5,a42 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9a0:	04000713          	li	a4,64
 9a4:	08e78563          	beq	a5,a4,a2e <ithread_create+0xbc>
 9a8:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9aa:	00000097          	auipc	ra,0x0
 9ae:	f64080e7          	jalr	-156(ra) # 90e <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9b2:	6505                	lui	a0,0x1
 9b4:	00000097          	auipc	ra,0x0
 9b8:	db2080e7          	jalr	-590(ra) # 766 <malloc>
 9bc:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9be:	00000717          	auipc	a4,0x0
 9c2:	66272703          	lw	a4,1634(a4) # 1020 <num_threads>
 9c6:	070e                	slli	a4,a4,0x3
 9c8:	00000797          	auipc	a5,0x0
 9cc:	6507b783          	ld	a5,1616(a5) # 1018 <stacks>
 9d0:	97ba                	add	a5,a5,a4
 9d2:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9d4:	00000697          	auipc	a3,0x0
 9d8:	e9268693          	addi	a3,a3,-366 # 866 <ithread_exit>
 9dc:	862a                	mv	a2,a0
 9de:	85ce                	mv	a1,s3
 9e0:	854a                	mv	a0,s2
 9e2:	00000097          	auipc	ra,0x0
 9e6:	99e080e7          	jalr	-1634(ra) # 380 <create_thread>
 9ea:	892a                	mv	s2,a0
  if (res != -1) {
 9ec:	57fd                	li	a5,-1
 9ee:	04f50c63          	beq	a0,a5,a46 <ithread_create+0xd4>
    num_threads++;
 9f2:	00000717          	auipc	a4,0x0
 9f6:	62e70713          	addi	a4,a4,1582 # 1020 <num_threads>
 9fa:	431c                	lw	a5,0(a4)
 9fc:	2785                	addiw	a5,a5,1
 9fe:	c31c                	sw	a5,0(a4)
 a00:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a02:	854a                	mv	a0,s2
 a04:	70a2                	ld	ra,40(sp)
 a06:	7402                	ld	s0,32(sp)
 a08:	6942                	ld	s2,16(sp)
 a0a:	69a2                	ld	s3,8(sp)
 a0c:	6145                	addi	sp,sp,48
 a0e:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a10:	00000517          	auipc	a0,0x0
 a14:	5f052503          	lw	a0,1520(a0) # 1000 <max_stacks>
 a18:	0035151b          	slliw	a0,a0,0x3
 a1c:	00000097          	auipc	ra,0x0
 a20:	d4a080e7          	jalr	-694(ra) # 766 <malloc>
 a24:	00000797          	auipc	a5,0x0
 a28:	5ea7ba23          	sd	a0,1524(a5) # 1018 <stacks>
 a2c:	b785                	j	98c <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a2e:	00000517          	auipc	a0,0x0
 a32:	0b250513          	addi	a0,a0,178 # ae0 <ithread_join+0x74>
 a36:	00000097          	auipc	ra,0x0
 a3a:	c78080e7          	jalr	-904(ra) # 6ae <printf>
      return -1;
 a3e:	597d                	li	s2,-1
 a40:	b7c9                	j	a02 <ithread_create+0x90>
 a42:	ec26                	sd	s1,24(sp)
 a44:	b7bd                	j	9b2 <ithread_create+0x40>
    free(stack_ptr);
 a46:	8526                	mv	a0,s1
 a48:	00000097          	auipc	ra,0x0
 a4c:	c9c080e7          	jalr	-868(ra) # 6e4 <free>
    stacks[num_threads] = 0;
 a50:	00000717          	auipc	a4,0x0
 a54:	5d072703          	lw	a4,1488(a4) # 1020 <num_threads>
 a58:	070e                	slli	a4,a4,0x3
 a5a:	00000797          	auipc	a5,0x0
 a5e:	5be7b783          	ld	a5,1470(a5) # 1018 <stacks>
 a62:	97ba                	add	a5,a5,a4
 a64:	0007b023          	sd	zero,0(a5)
 a68:	64e2                	ld	s1,24(sp)
 a6a:	bf61                	j	a02 <ithread_create+0x90>

0000000000000a6c <ithread_join>:

int ithread_join(int thread_id) {
 a6c:	1101                	addi	sp,sp,-32
 a6e:	ec06                	sd	ra,24(sp)
 a70:	e822                	sd	s0,16(sp)
 a72:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a74:	ff040793          	addi	a5,s0,-16
 a78:	ffc7859b          	addiw	a1,a5,-4
 a7c:	00000097          	auipc	ra,0x0
 a80:	90c080e7          	jalr	-1780(ra) # 388 <join_thread>
  threads_done++;
 a84:	00000717          	auipc	a4,0x0
 a88:	5a070713          	addi	a4,a4,1440 # 1024 <threads_done>
 a8c:	431c                	lw	a5,0(a4)
 a8e:	2785                	addiw	a5,a5,1
 a90:	0007869b          	sext.w	a3,a5
 a94:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a96:	00000797          	auipc	a5,0x0
 a9a:	58a7a783          	lw	a5,1418(a5) # 1020 <num_threads>
 a9e:	00d78863          	beq	a5,a3,aae <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 aa2:	fec42503          	lw	a0,-20(s0)
 aa6:	60e2                	ld	ra,24(sp)
 aa8:	6442                	ld	s0,16(sp)
 aaa:	6105                	addi	sp,sp,32
 aac:	8082                	ret
    free_stacks();
 aae:	00000097          	auipc	ra,0x0
 ab2:	dd2080e7          	jalr	-558(ra) # 880 <free_stacks>
 ab6:	b7f5                	j	aa2 <ithread_join+0x36>
