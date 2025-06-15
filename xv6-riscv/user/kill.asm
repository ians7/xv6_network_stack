
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7df63          	bge	a5,a0,48 <main+0x48>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1e6080e7          	jalr	486(ra) # 20e <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	310080e7          	jalr	784(ra) # 340 <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2d0080e7          	jalr	720(ra) # 310 <exit>
  48:	e426                	sd	s1,8(sp)
  4a:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  4c:	00001597          	auipc	a1,0x1
  50:	a5458593          	addi	a1,a1,-1452 # aa0 <ithread_join+0x4e>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	612080e7          	jalr	1554(ra) # 668 <fprintf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	2b0080e7          	jalr	688(ra) # 310 <exit>

0000000000000068 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  68:	1141                	addi	sp,sp,-16
  6a:	e406                	sd	ra,8(sp)
  6c:	e022                	sd	s0,0(sp)
  6e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <main>
  exit(0);
  78:	4501                	li	a0,0
  7a:	00000097          	auipc	ra,0x0
  7e:	296080e7          	jalr	662(ra) # 310 <exit>

0000000000000082 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  82:	1141                	addi	sp,sp,-16
  84:	e406                	sd	ra,8(sp)
  86:	e022                	sd	s0,0(sp)
  88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0xa>
    ;
  return os;
}
  9a:	60a2                	ld	ra,8(sp)
  9c:	6402                	ld	s0,0(sp)
  9e:	0141                	addi	sp,sp,16
  a0:	8082                	ret

00000000000000a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e406                	sd	ra,8(sp)
  a6:	e022                	sd	s0,0(sp)
  a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  aa:	00054783          	lbu	a5,0(a0)
  ae:	cb91                	beqz	a5,c2 <strcmp+0x20>
  b0:	0005c703          	lbu	a4,0(a1)
  b4:	00f71763          	bne	a4,a5,c2 <strcmp+0x20>
    p++, q++;
  b8:	0505                	addi	a0,a0,1
  ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	fbe5                	bnez	a5,b0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  c2:	0005c503          	lbu	a0,0(a1)
}
  c6:	40a7853b          	subw	a0,a5,a0
  ca:	60a2                	ld	ra,8(sp)
  cc:	6402                	ld	s0,0(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strlen>:

uint
strlen(const char *s)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf91                	beqz	a5,fa <strlen+0x28>
  e0:	00150793          	addi	a5,a0,1
  e4:	86be                	mv	a3,a5
  e6:	0785                	addi	a5,a5,1
  e8:	fff7c703          	lbu	a4,-1(a5)
  ec:	ff65                	bnez	a4,e4 <strlen+0x12>
  ee:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  f2:	60a2                	ld	ra,8(sp)
  f4:	6402                	ld	s0,0(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret
  for(n = 0; s[n]; n++)
  fa:	4501                	li	a0,0
  fc:	bfdd                	j	f2 <strlen+0x20>

00000000000000fe <memset>:

void*
memset(void *dst, int c, uint n)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e406                	sd	ra,8(sp)
 102:	e022                	sd	s0,0(sp)
 104:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 106:	ca19                	beqz	a2,11c <memset+0x1e>
 108:	87aa                	mv	a5,a0
 10a:	1602                	slli	a2,a2,0x20
 10c:	9201                	srli	a2,a2,0x20
 10e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 112:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 116:	0785                	addi	a5,a5,1
 118:	fee79de3          	bne	a5,a4,112 <memset+0x14>
  }
  return dst;
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <strchr>:

char*
strchr(const char *s, char c)
{
 124:	1141                	addi	sp,sp,-16
 126:	e406                	sd	ra,8(sp)
 128:	e022                	sd	s0,0(sp)
 12a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12c:	00054783          	lbu	a5,0(a0)
 130:	cf81                	beqz	a5,148 <strchr+0x24>
    if(*s == c)
 132:	00f58763          	beq	a1,a5,140 <strchr+0x1c>
  for(; *s; s++)
 136:	0505                	addi	a0,a0,1
 138:	00054783          	lbu	a5,0(a0)
 13c:	fbfd                	bnez	a5,132 <strchr+0xe>
      return (char*)s;
  return 0;
 13e:	4501                	li	a0,0
}
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret
  return 0;
 148:	4501                	li	a0,0
 14a:	bfdd                	j	140 <strchr+0x1c>

000000000000014c <gets>:

char*
gets(char *buf, int max)
{
 14c:	711d                	addi	sp,sp,-96
 14e:	ec86                	sd	ra,88(sp)
 150:	e8a2                	sd	s0,80(sp)
 152:	e4a6                	sd	s1,72(sp)
 154:	e0ca                	sd	s2,64(sp)
 156:	fc4e                	sd	s3,56(sp)
 158:	f852                	sd	s4,48(sp)
 15a:	f456                	sd	s5,40(sp)
 15c:	f05a                	sd	s6,32(sp)
 15e:	ec5e                	sd	s7,24(sp)
 160:	e862                	sd	s8,16(sp)
 162:	1080                	addi	s0,sp,96
 164:	8baa                	mv	s7,a0
 166:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 168:	892a                	mv	s2,a0
 16a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 16c:	faf40b13          	addi	s6,s0,-81
 170:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 172:	8c26                	mv	s8,s1
 174:	0014899b          	addiw	s3,s1,1
 178:	84ce                	mv	s1,s3
 17a:	0349d663          	bge	s3,s4,1a6 <gets+0x5a>
    cc = read(0, &c, 1);
 17e:	8656                	mv	a2,s5
 180:	85da                	mv	a1,s6
 182:	4501                	li	a0,0
 184:	00000097          	auipc	ra,0x0
 188:	1a4080e7          	jalr	420(ra) # 328 <read>
    if(cc < 1)
 18c:	00a05d63          	blez	a0,1a6 <gets+0x5a>
      break;
    buf[i++] = c;
 190:	faf44783          	lbu	a5,-81(s0)
 194:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 198:	0905                	addi	s2,s2,1
 19a:	ff678713          	addi	a4,a5,-10
 19e:	c319                	beqz	a4,1a4 <gets+0x58>
 1a0:	17cd                	addi	a5,a5,-13
 1a2:	fbe1                	bnez	a5,172 <gets+0x26>
    buf[i++] = c;
 1a4:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1a6:	9c5e                	add	s8,s8,s7
 1a8:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6c42                	ld	s8,16(sp)
 1c2:	6125                	addi	sp,sp,96
 1c4:	8082                	ret

00000000000001c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c6:	1101                	addi	sp,sp,-32
 1c8:	ec06                	sd	ra,24(sp)
 1ca:	e822                	sd	s0,16(sp)
 1cc:	e04a                	sd	s2,0(sp)
 1ce:	1000                	addi	s0,sp,32
 1d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d2:	4581                	li	a1,0
 1d4:	00000097          	auipc	ra,0x0
 1d8:	17c080e7          	jalr	380(ra) # 350 <open>
  if(fd < 0)
 1dc:	02054663          	bltz	a0,208 <stat+0x42>
 1e0:	e426                	sd	s1,8(sp)
 1e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e4:	85ca                	mv	a1,s2
 1e6:	00000097          	auipc	ra,0x0
 1ea:	182080e7          	jalr	386(ra) # 368 <fstat>
 1ee:	892a                	mv	s2,a0
  close(fd);
 1f0:	8526                	mv	a0,s1
 1f2:	00000097          	auipc	ra,0x0
 1f6:	146080e7          	jalr	326(ra) # 338 <close>
  return r;
 1fa:	64a2                	ld	s1,8(sp)
}
 1fc:	854a                	mv	a0,s2
 1fe:	60e2                	ld	ra,24(sp)
 200:	6442                	ld	s0,16(sp)
 202:	6902                	ld	s2,0(sp)
 204:	6105                	addi	sp,sp,32
 206:	8082                	ret
    return -1;
 208:	57fd                	li	a5,-1
 20a:	893e                	mv	s2,a5
 20c:	bfc5                	j	1fc <stat+0x36>

000000000000020e <atoi>:

int
atoi(const char *s)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e406                	sd	ra,8(sp)
 212:	e022                	sd	s0,0(sp)
 214:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 216:	00054683          	lbu	a3,0(a0)
 21a:	fd06879b          	addiw	a5,a3,-48
 21e:	0ff7f793          	zext.b	a5,a5
 222:	4625                	li	a2,9
 224:	02f66963          	bltu	a2,a5,256 <atoi+0x48>
 228:	872a                	mv	a4,a0
  n = 0;
 22a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 22c:	0705                	addi	a4,a4,1
 22e:	0025179b          	slliw	a5,a0,0x2
 232:	9fa9                	addw	a5,a5,a0
 234:	0017979b          	slliw	a5,a5,0x1
 238:	9fb5                	addw	a5,a5,a3
 23a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 23e:	00074683          	lbu	a3,0(a4)
 242:	fd06879b          	addiw	a5,a3,-48
 246:	0ff7f793          	zext.b	a5,a5
 24a:	fef671e3          	bgeu	a2,a5,22c <atoi+0x1e>
  return n;
}
 24e:	60a2                	ld	ra,8(sp)
 250:	6402                	ld	s0,0(sp)
 252:	0141                	addi	sp,sp,16
 254:	8082                	ret
  n = 0;
 256:	4501                	li	a0,0
 258:	bfdd                	j	24e <atoi+0x40>

000000000000025a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 262:	02b57563          	bgeu	a0,a1,28c <memmove+0x32>
    while(n-- > 0)
 266:	00c05f63          	blez	a2,284 <memmove+0x2a>
 26a:	1602                	slli	a2,a2,0x20
 26c:	9201                	srli	a2,a2,0x20
 26e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 272:	872a                	mv	a4,a0
      *dst++ = *src++;
 274:	0585                	addi	a1,a1,1
 276:	0705                	addi	a4,a4,1
 278:	fff5c683          	lbu	a3,-1(a1)
 27c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 280:	fee79ae3          	bne	a5,a4,274 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
    while(n-- > 0)
 28c:	fec05ce3          	blez	a2,284 <memmove+0x2a>
    dst += n;
 290:	00c50733          	add	a4,a0,a2
    src += n;
 294:	95b2                	add	a1,a1,a2
 296:	fff6079b          	addiw	a5,a2,-1
 29a:	1782                	slli	a5,a5,0x20
 29c:	9381                	srli	a5,a5,0x20
 29e:	fff7c793          	not	a5,a5
 2a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a4:	15fd                	addi	a1,a1,-1
 2a6:	177d                	addi	a4,a4,-1
 2a8:	0005c683          	lbu	a3,0(a1)
 2ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b0:	fef71ae3          	bne	a4,a5,2a4 <memmove+0x4a>
 2b4:	bfc1                	j	284 <memmove+0x2a>

00000000000002b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2be:	c61d                	beqz	a2,2ec <memcmp+0x36>
 2c0:	1602                	slli	a2,a2,0x20
 2c2:	9201                	srli	a2,a2,0x20
 2c4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	0005c703          	lbu	a4,0(a1)
 2d0:	00e79863          	bne	a5,a4,2e0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2d4:	0505                	addi	a0,a0,1
    p2++;
 2d6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d8:	fed518e3          	bne	a0,a3,2c8 <memcmp+0x12>
  }
  return 0;
 2dc:	4501                	li	a0,0
 2de:	a019                	j	2e4 <memcmp+0x2e>
      return *p1 - *p2;
 2e0:	40e7853b          	subw	a0,a5,a4
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
  return 0;
 2ec:	4501                	li	a0,0
 2ee:	bfdd                	j	2e4 <memcmp+0x2e>

00000000000002f0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f8:	00000097          	auipc	ra,0x0
 2fc:	f62080e7          	jalr	-158(ra) # 25a <memmove>
}
 300:	60a2                	ld	ra,8(sp)
 302:	6402                	ld	s0,0(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 308:	4885                	li	a7,1
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <exit>:
.global exit
exit:
 li a7, SYS_exit
 310:	4889                	li	a7,2
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <wait>:
.global wait
wait:
 li a7, SYS_wait
 318:	488d                	li	a7,3
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 320:	4891                	li	a7,4
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <read>:
.global read
read:
 li a7, SYS_read
 328:	4895                	li	a7,5
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <write>:
.global write
write:
 li a7, SYS_write
 330:	48c1                	li	a7,16
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <close>:
.global close
close:
 li a7, SYS_close
 338:	48d5                	li	a7,21
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <kill>:
.global kill
kill:
 li a7, SYS_kill
 340:	4899                	li	a7,6
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <exec>:
.global exec
exec:
 li a7, SYS_exec
 348:	489d                	li	a7,7
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <open>:
.global open
open:
 li a7, SYS_open
 350:	48bd                	li	a7,15
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 358:	48c5                	li	a7,17
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 360:	48c9                	li	a7,18
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 368:	48a1                	li	a7,8
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <link>:
.global link
link:
 li a7, SYS_link
 370:	48cd                	li	a7,19
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 378:	48d1                	li	a7,20
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 380:	48a5                	li	a7,9
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <dup>:
.global dup
dup:
 li a7, SYS_dup
 388:	48a9                	li	a7,10
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 390:	48ad                	li	a7,11
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 398:	48b1                	li	a7,12
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a0:	48b5                	li	a7,13
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a8:	48b9                	li	a7,14
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3b0:	48d9                	li	a7,22
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3b8:	48dd                	li	a7,23
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3c0:	48e1                	li	a7,24
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3c8:	48e5                	li	a7,25
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d0:	1101                	addi	sp,sp,-32
 3d2:	ec06                	sd	ra,24(sp)
 3d4:	e822                	sd	s0,16(sp)
 3d6:	1000                	addi	s0,sp,32
 3d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3dc:	4605                	li	a2,1
 3de:	fef40593          	addi	a1,s0,-17
 3e2:	00000097          	auipc	ra,0x0
 3e6:	f4e080e7          	jalr	-178(ra) # 330 <write>
}
 3ea:	60e2                	ld	ra,24(sp)
 3ec:	6442                	ld	s0,16(sp)
 3ee:	6105                	addi	sp,sp,32
 3f0:	8082                	ret

00000000000003f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f2:	7139                	addi	sp,sp,-64
 3f4:	fc06                	sd	ra,56(sp)
 3f6:	f822                	sd	s0,48(sp)
 3f8:	f04a                	sd	s2,32(sp)
 3fa:	ec4e                	sd	s3,24(sp)
 3fc:	0080                	addi	s0,sp,64
 3fe:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 400:	cad9                	beqz	a3,496 <printint+0xa4>
 402:	01f5d79b          	srliw	a5,a1,0x1f
 406:	cbc1                	beqz	a5,496 <printint+0xa4>
    neg = 1;
    x = -xx;
 408:	40b005bb          	negw	a1,a1
    neg = 1;
 40c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 40e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 412:	86ce                	mv	a3,s3
  i = 0;
 414:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 416:	00000817          	auipc	a6,0x0
 41a:	73280813          	addi	a6,a6,1842 # b48 <digits>
 41e:	88ba                	mv	a7,a4
 420:	0017051b          	addiw	a0,a4,1
 424:	872a                	mv	a4,a0
 426:	02c5f7bb          	remuw	a5,a1,a2
 42a:	1782                	slli	a5,a5,0x20
 42c:	9381                	srli	a5,a5,0x20
 42e:	97c2                	add	a5,a5,a6
 430:	0007c783          	lbu	a5,0(a5)
 434:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 438:	87ae                	mv	a5,a1
 43a:	02c5d5bb          	divuw	a1,a1,a2
 43e:	0685                	addi	a3,a3,1
 440:	fcc7ffe3          	bgeu	a5,a2,41e <printint+0x2c>
  if(neg)
 444:	00030c63          	beqz	t1,45c <printint+0x6a>
    buf[i++] = '-';
 448:	fd050793          	addi	a5,a0,-48
 44c:	00878533          	add	a0,a5,s0
 450:	02d00793          	li	a5,45
 454:	fef50823          	sb	a5,-16(a0)
 458:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 45c:	02e05763          	blez	a4,48a <printint+0x98>
 460:	f426                	sd	s1,40(sp)
 462:	377d                	addiw	a4,a4,-1
 464:	00e984b3          	add	s1,s3,a4
 468:	19fd                	addi	s3,s3,-1
 46a:	99ba                	add	s3,s3,a4
 46c:	1702                	slli	a4,a4,0x20
 46e:	9301                	srli	a4,a4,0x20
 470:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 474:	0004c583          	lbu	a1,0(s1)
 478:	854a                	mv	a0,s2
 47a:	00000097          	auipc	ra,0x0
 47e:	f56080e7          	jalr	-170(ra) # 3d0 <putc>
  while(--i >= 0)
 482:	14fd                	addi	s1,s1,-1
 484:	ff3498e3          	bne	s1,s3,474 <printint+0x82>
 488:	74a2                	ld	s1,40(sp)
}
 48a:	70e2                	ld	ra,56(sp)
 48c:	7442                	ld	s0,48(sp)
 48e:	7902                	ld	s2,32(sp)
 490:	69e2                	ld	s3,24(sp)
 492:	6121                	addi	sp,sp,64
 494:	8082                	ret
  neg = 0;
 496:	4301                	li	t1,0
 498:	bf9d                	j	40e <printint+0x1c>

000000000000049a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 49a:	715d                	addi	sp,sp,-80
 49c:	e486                	sd	ra,72(sp)
 49e:	e0a2                	sd	s0,64(sp)
 4a0:	f84a                	sd	s2,48(sp)
 4a2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a4:	0005c903          	lbu	s2,0(a1)
 4a8:	1a090b63          	beqz	s2,65e <vprintf+0x1c4>
 4ac:	fc26                	sd	s1,56(sp)
 4ae:	f44e                	sd	s3,40(sp)
 4b0:	f052                	sd	s4,32(sp)
 4b2:	ec56                	sd	s5,24(sp)
 4b4:	e85a                	sd	s6,16(sp)
 4b6:	e45e                	sd	s7,8(sp)
 4b8:	8aaa                	mv	s5,a0
 4ba:	8bb2                	mv	s7,a2
 4bc:	00158493          	addi	s1,a1,1
  state = 0;
 4c0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c2:	02500a13          	li	s4,37
 4c6:	4b55                	li	s6,21
 4c8:	a839                	j	4e6 <vprintf+0x4c>
        putc(fd, c);
 4ca:	85ca                	mv	a1,s2
 4cc:	8556                	mv	a0,s5
 4ce:	00000097          	auipc	ra,0x0
 4d2:	f02080e7          	jalr	-254(ra) # 3d0 <putc>
 4d6:	a019                	j	4dc <vprintf+0x42>
    } else if(state == '%'){
 4d8:	01498d63          	beq	s3,s4,4f2 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4dc:	0485                	addi	s1,s1,1
 4de:	fff4c903          	lbu	s2,-1(s1)
 4e2:	16090863          	beqz	s2,652 <vprintf+0x1b8>
    if(state == 0){
 4e6:	fe0999e3          	bnez	s3,4d8 <vprintf+0x3e>
      if(c == '%'){
 4ea:	ff4910e3          	bne	s2,s4,4ca <vprintf+0x30>
        state = '%';
 4ee:	89d2                	mv	s3,s4
 4f0:	b7f5                	j	4dc <vprintf+0x42>
      if(c == 'd'){
 4f2:	13490563          	beq	s2,s4,61c <vprintf+0x182>
 4f6:	f9d9079b          	addiw	a5,s2,-99
 4fa:	0ff7f793          	zext.b	a5,a5
 4fe:	12fb6863          	bltu	s6,a5,62e <vprintf+0x194>
 502:	f9d9079b          	addiw	a5,s2,-99
 506:	0ff7f713          	zext.b	a4,a5
 50a:	12eb6263          	bltu	s6,a4,62e <vprintf+0x194>
 50e:	00271793          	slli	a5,a4,0x2
 512:	00000717          	auipc	a4,0x0
 516:	5de70713          	addi	a4,a4,1502 # af0 <ithread_join+0x9e>
 51a:	97ba                	add	a5,a5,a4
 51c:	439c                	lw	a5,0(a5)
 51e:	97ba                	add	a5,a5,a4
 520:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 522:	008b8913          	addi	s2,s7,8
 526:	4685                	li	a3,1
 528:	4629                	li	a2,10
 52a:	000ba583          	lw	a1,0(s7)
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	ec2080e7          	jalr	-318(ra) # 3f2 <printint>
 538:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 53a:	4981                	li	s3,0
 53c:	b745                	j	4dc <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 53e:	008b8913          	addi	s2,s7,8
 542:	4681                	li	a3,0
 544:	4629                	li	a2,10
 546:	000ba583          	lw	a1,0(s7)
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	ea6080e7          	jalr	-346(ra) # 3f2 <printint>
 554:	8bca                	mv	s7,s2
      state = 0;
 556:	4981                	li	s3,0
 558:	b751                	j	4dc <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 55a:	008b8913          	addi	s2,s7,8
 55e:	4681                	li	a3,0
 560:	4641                	li	a2,16
 562:	000ba583          	lw	a1,0(s7)
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e8a080e7          	jalr	-374(ra) # 3f2 <printint>
 570:	8bca                	mv	s7,s2
      state = 0;
 572:	4981                	li	s3,0
 574:	b7a5                	j	4dc <vprintf+0x42>
 576:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 578:	008b8793          	addi	a5,s7,8
 57c:	8c3e                	mv	s8,a5
 57e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 582:	03000593          	li	a1,48
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	e48080e7          	jalr	-440(ra) # 3d0 <putc>
  putc(fd, 'x');
 590:	07800593          	li	a1,120
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	e3a080e7          	jalr	-454(ra) # 3d0 <putc>
 59e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a0:	00000b97          	auipc	s7,0x0
 5a4:	5a8b8b93          	addi	s7,s7,1448 # b48 <digits>
 5a8:	03c9d793          	srli	a5,s3,0x3c
 5ac:	97de                	add	a5,a5,s7
 5ae:	0007c583          	lbu	a1,0(a5)
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e1c080e7          	jalr	-484(ra) # 3d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5bc:	0992                	slli	s3,s3,0x4
 5be:	397d                	addiw	s2,s2,-1
 5c0:	fe0914e3          	bnez	s2,5a8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5c4:	8be2                	mv	s7,s8
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	6c02                	ld	s8,0(sp)
 5ca:	bf09                	j	4dc <vprintf+0x42>
        s = va_arg(ap, char*);
 5cc:	008b8993          	addi	s3,s7,8
 5d0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5d4:	02090163          	beqz	s2,5f6 <vprintf+0x15c>
        while(*s != 0){
 5d8:	00094583          	lbu	a1,0(s2)
 5dc:	c9a5                	beqz	a1,64c <vprintf+0x1b2>
          putc(fd, *s);
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	df0080e7          	jalr	-528(ra) # 3d0 <putc>
          s++;
 5e8:	0905                	addi	s2,s2,1
        while(*s != 0){
 5ea:	00094583          	lbu	a1,0(s2)
 5ee:	f9e5                	bnez	a1,5de <vprintf+0x144>
        s = va_arg(ap, char*);
 5f0:	8bce                	mv	s7,s3
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	b5e5                	j	4dc <vprintf+0x42>
          s = "(null)";
 5f6:	00000917          	auipc	s2,0x0
 5fa:	4c290913          	addi	s2,s2,1218 # ab8 <ithread_join+0x66>
        while(*s != 0){
 5fe:	02800593          	li	a1,40
 602:	bff1                	j	5de <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 604:	008b8913          	addi	s2,s7,8
 608:	000bc583          	lbu	a1,0(s7)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	dc2080e7          	jalr	-574(ra) # 3d0 <putc>
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
 61a:	b5c9                	j	4dc <vprintf+0x42>
        putc(fd, c);
 61c:	02500593          	li	a1,37
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	dae080e7          	jalr	-594(ra) # 3d0 <putc>
      state = 0;
 62a:	4981                	li	s3,0
 62c:	bd45                	j	4dc <vprintf+0x42>
        putc(fd, '%');
 62e:	02500593          	li	a1,37
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	d9c080e7          	jalr	-612(ra) # 3d0 <putc>
        putc(fd, c);
 63c:	85ca                	mv	a1,s2
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	d90080e7          	jalr	-624(ra) # 3d0 <putc>
      state = 0;
 648:	4981                	li	s3,0
 64a:	bd49                	j	4dc <vprintf+0x42>
        s = va_arg(ap, char*);
 64c:	8bce                	mv	s7,s3
      state = 0;
 64e:	4981                	li	s3,0
 650:	b571                	j	4dc <vprintf+0x42>
 652:	74e2                	ld	s1,56(sp)
 654:	79a2                	ld	s3,40(sp)
 656:	7a02                	ld	s4,32(sp)
 658:	6ae2                	ld	s5,24(sp)
 65a:	6b42                	ld	s6,16(sp)
 65c:	6ba2                	ld	s7,8(sp)
    }
  }
}
 65e:	60a6                	ld	ra,72(sp)
 660:	6406                	ld	s0,64(sp)
 662:	7942                	ld	s2,48(sp)
 664:	6161                	addi	sp,sp,80
 666:	8082                	ret

0000000000000668 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 668:	715d                	addi	sp,sp,-80
 66a:	ec06                	sd	ra,24(sp)
 66c:	e822                	sd	s0,16(sp)
 66e:	1000                	addi	s0,sp,32
 670:	e010                	sd	a2,0(s0)
 672:	e414                	sd	a3,8(s0)
 674:	e818                	sd	a4,16(s0)
 676:	ec1c                	sd	a5,24(s0)
 678:	03043023          	sd	a6,32(s0)
 67c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 680:	8622                	mv	a2,s0
 682:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 686:	00000097          	auipc	ra,0x0
 68a:	e14080e7          	jalr	-492(ra) # 49a <vprintf>
}
 68e:	60e2                	ld	ra,24(sp)
 690:	6442                	ld	s0,16(sp)
 692:	6161                	addi	sp,sp,80
 694:	8082                	ret

0000000000000696 <printf>:

void
printf(const char *fmt, ...)
{
 696:	711d                	addi	sp,sp,-96
 698:	ec06                	sd	ra,24(sp)
 69a:	e822                	sd	s0,16(sp)
 69c:	1000                	addi	s0,sp,32
 69e:	e40c                	sd	a1,8(s0)
 6a0:	e810                	sd	a2,16(s0)
 6a2:	ec14                	sd	a3,24(s0)
 6a4:	f018                	sd	a4,32(s0)
 6a6:	f41c                	sd	a5,40(s0)
 6a8:	03043823          	sd	a6,48(s0)
 6ac:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b0:	00840613          	addi	a2,s0,8
 6b4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6b8:	85aa                	mv	a1,a0
 6ba:	4505                	li	a0,1
 6bc:	00000097          	auipc	ra,0x0
 6c0:	dde080e7          	jalr	-546(ra) # 49a <vprintf>
}
 6c4:	60e2                	ld	ra,24(sp)
 6c6:	6442                	ld	s0,16(sp)
 6c8:	6125                	addi	sp,sp,96
 6ca:	8082                	ret

00000000000006cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cc:	1141                	addi	sp,sp,-16
 6ce:	e406                	sd	ra,8(sp)
 6d0:	e022                	sd	s0,0(sp)
 6d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d8:	00001797          	auipc	a5,0x1
 6dc:	e387b783          	ld	a5,-456(a5) # 1510 <freep>
 6e0:	a039                	j	6ee <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e2:	6398                	ld	a4,0(a5)
 6e4:	00e7e463          	bltu	a5,a4,6ec <free+0x20>
 6e8:	00e6ea63          	bltu	a3,a4,6fc <free+0x30>
{
 6ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ee:	fed7fae3          	bgeu	a5,a3,6e2 <free+0x16>
 6f2:	6398                	ld	a4,0(a5)
 6f4:	00e6e463          	bltu	a3,a4,6fc <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f8:	fee7eae3          	bltu	a5,a4,6ec <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fc:	ff852583          	lw	a1,-8(a0)
 700:	6390                	ld	a2,0(a5)
 702:	02059813          	slli	a6,a1,0x20
 706:	01c85713          	srli	a4,a6,0x1c
 70a:	9736                	add	a4,a4,a3
 70c:	02e60563          	beq	a2,a4,736 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 714:	4790                	lw	a2,8(a5)
 716:	02061593          	slli	a1,a2,0x20
 71a:	01c5d713          	srli	a4,a1,0x1c
 71e:	973e                	add	a4,a4,a5
 720:	02e68263          	beq	a3,a4,744 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 724:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 726:	00001717          	auipc	a4,0x1
 72a:	def73523          	sd	a5,-534(a4) # 1510 <freep>
}
 72e:	60a2                	ld	ra,8(sp)
 730:	6402                	ld	s0,0(sp)
 732:	0141                	addi	sp,sp,16
 734:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 736:	4618                	lw	a4,8(a2)
 738:	9f2d                	addw	a4,a4,a1
 73a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 73e:	6398                	ld	a4,0(a5)
 740:	6310                	ld	a2,0(a4)
 742:	b7f9                	j	710 <free+0x44>
    p->s.size += bp->s.size;
 744:	ff852703          	lw	a4,-8(a0)
 748:	9f31                	addw	a4,a4,a2
 74a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 74c:	ff053683          	ld	a3,-16(a0)
 750:	bfd1                	j	724 <free+0x58>

0000000000000752 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 752:	7139                	addi	sp,sp,-64
 754:	fc06                	sd	ra,56(sp)
 756:	f822                	sd	s0,48(sp)
 758:	f04a                	sd	s2,32(sp)
 75a:	ec4e                	sd	s3,24(sp)
 75c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75e:	02051993          	slli	s3,a0,0x20
 762:	0209d993          	srli	s3,s3,0x20
 766:	09bd                	addi	s3,s3,15
 768:	0049d993          	srli	s3,s3,0x4
 76c:	2985                	addiw	s3,s3,1
 76e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 770:	00001517          	auipc	a0,0x1
 774:	da053503          	ld	a0,-608(a0) # 1510 <freep>
 778:	c905                	beqz	a0,7a8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 77c:	4798                	lw	a4,8(a5)
 77e:	09377a63          	bgeu	a4,s3,812 <malloc+0xc0>
 782:	f426                	sd	s1,40(sp)
 784:	e852                	sd	s4,16(sp)
 786:	e456                	sd	s5,8(sp)
 788:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 78a:	8a4e                	mv	s4,s3
 78c:	6705                	lui	a4,0x1
 78e:	00e9f363          	bgeu	s3,a4,794 <malloc+0x42>
 792:	6a05                	lui	s4,0x1
 794:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 798:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 79c:	00001497          	auipc	s1,0x1
 7a0:	d7448493          	addi	s1,s1,-652 # 1510 <freep>
  if(p == (char*)-1)
 7a4:	5afd                	li	s5,-1
 7a6:	a089                	j	7e8 <malloc+0x96>
 7a8:	f426                	sd	s1,40(sp)
 7aa:	e852                	sd	s4,16(sp)
 7ac:	e456                	sd	s5,8(sp)
 7ae:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7b0:	00001797          	auipc	a5,0x1
 7b4:	d8078793          	addi	a5,a5,-640 # 1530 <base>
 7b8:	00001717          	auipc	a4,0x1
 7bc:	d4f73c23          	sd	a5,-680(a4) # 1510 <freep>
 7c0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c6:	b7d1                	j	78a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7c8:	6398                	ld	a4,0(a5)
 7ca:	e118                	sd	a4,0(a0)
 7cc:	a8b9                	j	82a <malloc+0xd8>
  hp->s.size = nu;
 7ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7d2:	0541                	addi	a0,a0,16
 7d4:	00000097          	auipc	ra,0x0
 7d8:	ef8080e7          	jalr	-264(ra) # 6cc <free>
  return freep;
 7dc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7de:	c135                	beqz	a0,842 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e2:	4798                	lw	a4,8(a5)
 7e4:	03277363          	bgeu	a4,s2,80a <malloc+0xb8>
    if(p == freep)
 7e8:	6098                	ld	a4,0(s1)
 7ea:	853e                	mv	a0,a5
 7ec:	fef71ae3          	bne	a4,a5,7e0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7f0:	8552                	mv	a0,s4
 7f2:	00000097          	auipc	ra,0x0
 7f6:	ba6080e7          	jalr	-1114(ra) # 398 <sbrk>
  if(p == (char*)-1)
 7fa:	fd551ae3          	bne	a0,s5,7ce <malloc+0x7c>
        return 0;
 7fe:	4501                	li	a0,0
 800:	74a2                	ld	s1,40(sp)
 802:	6a42                	ld	s4,16(sp)
 804:	6aa2                	ld	s5,8(sp)
 806:	6b02                	ld	s6,0(sp)
 808:	a03d                	j	836 <malloc+0xe4>
 80a:	74a2                	ld	s1,40(sp)
 80c:	6a42                	ld	s4,16(sp)
 80e:	6aa2                	ld	s5,8(sp)
 810:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 812:	fae90be3          	beq	s2,a4,7c8 <malloc+0x76>
        p->s.size -= nunits;
 816:	4137073b          	subw	a4,a4,s3
 81a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 81c:	02071693          	slli	a3,a4,0x20
 820:	01c6d713          	srli	a4,a3,0x1c
 824:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 826:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 82a:	00001717          	auipc	a4,0x1
 82e:	cea73323          	sd	a0,-794(a4) # 1510 <freep>
      return (void*)(p + 1);
 832:	01078513          	addi	a0,a5,16
  }
}
 836:	70e2                	ld	ra,56(sp)
 838:	7442                	ld	s0,48(sp)
 83a:	7902                	ld	s2,32(sp)
 83c:	69e2                	ld	s3,24(sp)
 83e:	6121                	addi	sp,sp,64
 840:	8082                	ret
 842:	74a2                	ld	s1,40(sp)
 844:	6a42                	ld	s4,16(sp)
 846:	6aa2                	ld	s5,8(sp)
 848:	6b02                	ld	s6,0(sp)
 84a:	b7f5                	j	836 <malloc+0xe4>

000000000000084c <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 84c:	1141                	addi	sp,sp,-16
 84e:	e406                	sd	ra,8(sp)
 850:	e022                	sd	s0,0(sp)
 852:	0800                	addi	s0,sp,16
  thread_exit(status);
 854:	00000097          	auipc	ra,0x0
 858:	b74080e7          	jalr	-1164(ra) # 3c8 <thread_exit>
}
 85c:	60a2                	ld	ra,8(sp)
 85e:	6402                	ld	s0,0(sp)
 860:	0141                	addi	sp,sp,16
 862:	8082                	ret

0000000000000864 <free_stacks>:
int free_stacks() {
 864:	7179                	addi	sp,sp,-48
 866:	f406                	sd	ra,40(sp)
 868:	f022                	sd	s0,32(sp)
 86a:	ec26                	sd	s1,24(sp)
 86c:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 86e:	00001797          	auipc	a5,0x1
 872:	cb27a783          	lw	a5,-846(a5) # 1520 <num_threads>
 876:	04f05063          	blez	a5,8b6 <free_stacks+0x52>
 87a:	e84a                	sd	s2,16(sp)
 87c:	e44e                	sd	s3,8(sp)
 87e:	4481                	li	s1,0
    free(stacks[i]);
 880:	00001997          	auipc	s3,0x1
 884:	c9898993          	addi	s3,s3,-872 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 888:	00001917          	auipc	s2,0x1
 88c:	c9890913          	addi	s2,s2,-872 # 1520 <num_threads>
    free(stacks[i]);
 890:	0009b783          	ld	a5,0(s3)
 894:	00349713          	slli	a4,s1,0x3
 898:	97ba                	add	a5,a5,a4
 89a:	6388                	ld	a0,0(a5)
 89c:	00000097          	auipc	ra,0x0
 8a0:	e30080e7          	jalr	-464(ra) # 6cc <free>
  for (int i = 0; i < num_threads; i++) {
 8a4:	0485                	addi	s1,s1,1
 8a6:	00092703          	lw	a4,0(s2)
 8aa:	0004879b          	sext.w	a5,s1
 8ae:	fee7c1e3          	blt	a5,a4,890 <free_stacks+0x2c>
 8b2:	6942                	ld	s2,16(sp)
 8b4:	69a2                	ld	s3,8(sp)
  free(stacks);
 8b6:	00001497          	auipc	s1,0x1
 8ba:	c6248493          	addi	s1,s1,-926 # 1518 <stacks>
 8be:	6088                	ld	a0,0(s1)
 8c0:	00000097          	auipc	ra,0x0
 8c4:	e0c080e7          	jalr	-500(ra) # 6cc <free>
  stacks = 0;
 8c8:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8cc:	00001797          	auipc	a5,0x1
 8d0:	c407aa23          	sw	zero,-940(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 8d4:	47a1                	li	a5,8
 8d6:	00001717          	auipc	a4,0x1
 8da:	c2f72523          	sw	a5,-982(a4) # 1500 <max_stacks>
  threads_done = 0;
 8de:	00001797          	auipc	a5,0x1
 8e2:	c407a323          	sw	zero,-954(a5) # 1524 <threads_done>
}
 8e6:	4501                	li	a0,0
 8e8:	70a2                	ld	ra,40(sp)
 8ea:	7402                	ld	s0,32(sp)
 8ec:	64e2                	ld	s1,24(sp)
 8ee:	6145                	addi	sp,sp,48
 8f0:	8082                	ret

00000000000008f2 <expand_num_threads>:
int expand_num_threads() {
 8f2:	1101                	addi	sp,sp,-32
 8f4:	ec06                	sd	ra,24(sp)
 8f6:	e822                	sd	s0,16(sp)
 8f8:	e426                	sd	s1,8(sp)
 8fa:	e04a                	sd	s2,0(sp)
 8fc:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 8fe:	00001797          	auipc	a5,0x1
 902:	c0278793          	addi	a5,a5,-1022 # 1500 <max_stacks>
 906:	4388                	lw	a0,0(a5)
 908:	0015151b          	slliw	a0,a0,0x1
 90c:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 90e:	0035151b          	slliw	a0,a0,0x3
 912:	00000097          	auipc	ra,0x0
 916:	e40080e7          	jalr	-448(ra) # 752 <malloc>
 91a:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 91c:	00001617          	auipc	a2,0x1
 920:	c0462603          	lw	a2,-1020(a2) # 1520 <num_threads>
 924:	00001497          	auipc	s1,0x1
 928:	bf448493          	addi	s1,s1,-1036 # 1518 <stacks>
 92c:	0036161b          	slliw	a2,a2,0x3
 930:	608c                	ld	a1,0(s1)
 932:	00000097          	auipc	ra,0x0
 936:	928080e7          	jalr	-1752(ra) # 25a <memmove>
  free(stacks);
 93a:	6088                	ld	a0,0(s1)
 93c:	00000097          	auipc	ra,0x0
 940:	d90080e7          	jalr	-624(ra) # 6cc <free>
  stacks = new_stacks;
 944:	0124b023          	sd	s2,0(s1)
}
 948:	4501                	li	a0,0
 94a:	60e2                	ld	ra,24(sp)
 94c:	6442                	ld	s0,16(sp)
 94e:	64a2                	ld	s1,8(sp)
 950:	6902                	ld	s2,0(sp)
 952:	6105                	addi	sp,sp,32
 954:	8082                	ret

0000000000000956 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 956:	7179                	addi	sp,sp,-48
 958:	f406                	sd	ra,40(sp)
 95a:	f022                	sd	s0,32(sp)
 95c:	e84a                	sd	s2,16(sp)
 95e:	e44e                	sd	s3,8(sp)
 960:	1800                	addi	s0,sp,48
 962:	892a                	mv	s2,a0
 964:	89ae                	mv	s3,a1
  if (stacks == 0) {
 966:	00001797          	auipc	a5,0x1
 96a:	bb27b783          	ld	a5,-1102(a5) # 1518 <stacks>
 96e:	c3d9                	beqz	a5,9f4 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 970:	00001797          	auipc	a5,0x1
 974:	b907a783          	lw	a5,-1136(a5) # 1500 <max_stacks>
 978:	00001717          	auipc	a4,0x1
 97c:	ba872703          	lw	a4,-1112(a4) # 1520 <num_threads>
 980:	0af71463          	bne	a4,a5,a28 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 984:	04000713          	li	a4,64
 988:	08e78563          	beq	a5,a4,a12 <ithread_create+0xbc>
 98c:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 98e:	00000097          	auipc	ra,0x0
 992:	f64080e7          	jalr	-156(ra) # 8f2 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 996:	6505                	lui	a0,0x1
 998:	00000097          	auipc	ra,0x0
 99c:	dba080e7          	jalr	-582(ra) # 752 <malloc>
 9a0:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9a2:	00001717          	auipc	a4,0x1
 9a6:	b7e72703          	lw	a4,-1154(a4) # 1520 <num_threads>
 9aa:	070e                	slli	a4,a4,0x3
 9ac:	00001797          	auipc	a5,0x1
 9b0:	b6c7b783          	ld	a5,-1172(a5) # 1518 <stacks>
 9b4:	97ba                	add	a5,a5,a4
 9b6:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9b8:	00000697          	auipc	a3,0x0
 9bc:	e9468693          	addi	a3,a3,-364 # 84c <ithread_exit>
 9c0:	862a                	mv	a2,a0
 9c2:	85ce                	mv	a1,s3
 9c4:	854a                	mv	a0,s2
 9c6:	00000097          	auipc	ra,0x0
 9ca:	9f2080e7          	jalr	-1550(ra) # 3b8 <create_thread>
 9ce:	892a                	mv	s2,a0
  if (res != -1) {
 9d0:	57fd                	li	a5,-1
 9d2:	04f50d63          	beq	a0,a5,a2c <ithread_create+0xd6>
    num_threads++;
 9d6:	00001717          	auipc	a4,0x1
 9da:	b4a70713          	addi	a4,a4,-1206 # 1520 <num_threads>
 9de:	431c                	lw	a5,0(a4)
 9e0:	2785                	addiw	a5,a5,1
 9e2:	c31c                	sw	a5,0(a4)
 9e4:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 9e6:	854a                	mv	a0,s2
 9e8:	70a2                	ld	ra,40(sp)
 9ea:	7402                	ld	s0,32(sp)
 9ec:	6942                	ld	s2,16(sp)
 9ee:	69a2                	ld	s3,8(sp)
 9f0:	6145                	addi	sp,sp,48
 9f2:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 9f4:	00001517          	auipc	a0,0x1
 9f8:	b0c52503          	lw	a0,-1268(a0) # 1500 <max_stacks>
 9fc:	0035151b          	slliw	a0,a0,0x3
 a00:	00000097          	auipc	ra,0x0
 a04:	d52080e7          	jalr	-686(ra) # 752 <malloc>
 a08:	00001797          	auipc	a5,0x1
 a0c:	b0a7b823          	sd	a0,-1264(a5) # 1518 <stacks>
 a10:	b785                	j	970 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a12:	00000517          	auipc	a0,0x0
 a16:	0ae50513          	addi	a0,a0,174 # ac0 <ithread_join+0x6e>
 a1a:	00000097          	auipc	ra,0x0
 a1e:	c7c080e7          	jalr	-900(ra) # 696 <printf>
      return -1;
 a22:	57fd                	li	a5,-1
 a24:	893e                	mv	s2,a5
 a26:	b7c1                	j	9e6 <ithread_create+0x90>
 a28:	ec26                	sd	s1,24(sp)
 a2a:	b7b5                	j	996 <ithread_create+0x40>
    free(stack_ptr);
 a2c:	8526                	mv	a0,s1
 a2e:	00000097          	auipc	ra,0x0
 a32:	c9e080e7          	jalr	-866(ra) # 6cc <free>
    stacks[num_threads] = 0;
 a36:	00001717          	auipc	a4,0x1
 a3a:	aea72703          	lw	a4,-1302(a4) # 1520 <num_threads>
 a3e:	070e                	slli	a4,a4,0x3
 a40:	00001797          	auipc	a5,0x1
 a44:	ad87b783          	ld	a5,-1320(a5) # 1518 <stacks>
 a48:	97ba                	add	a5,a5,a4
 a4a:	0007b023          	sd	zero,0(a5)
 a4e:	64e2                	ld	s1,24(sp)
 a50:	bf59                	j	9e6 <ithread_create+0x90>

0000000000000a52 <ithread_join>:

int ithread_join(int thread_id) {
 a52:	1101                	addi	sp,sp,-32
 a54:	ec06                	sd	ra,24(sp)
 a56:	e822                	sd	s0,16(sp)
 a58:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a5a:	fec40593          	addi	a1,s0,-20
 a5e:	00000097          	auipc	ra,0x0
 a62:	962080e7          	jalr	-1694(ra) # 3c0 <join_thread>
  threads_done++;
 a66:	00001717          	auipc	a4,0x1
 a6a:	abe70713          	addi	a4,a4,-1346 # 1524 <threads_done>
 a6e:	431c                	lw	a5,0(a4)
 a70:	2785                	addiw	a5,a5,1
 a72:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 a74:	00001717          	auipc	a4,0x1
 a78:	aac72703          	lw	a4,-1364(a4) # 1520 <num_threads>
 a7c:	00f70863          	beq	a4,a5,a8c <ithread_join+0x3a>
    free_stacks();
  }
  return status;
}
 a80:	fec42503          	lw	a0,-20(s0)
 a84:	60e2                	ld	ra,24(sp)
 a86:	6442                	ld	s0,16(sp)
 a88:	6105                	addi	sp,sp,32
 a8a:	8082                	ret
    free_stacks();
 a8c:	00000097          	auipc	ra,0x0
 a90:	dd8080e7          	jalr	-552(ra) # 864 <free_stacks>
 a94:	b7f5                	j	a80 <ithread_join+0x2e>
