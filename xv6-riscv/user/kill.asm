
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
  50:	aa458593          	addi	a1,a1,-1372 # af0 <ithread_join+0x4e>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	660080e7          	jalr	1632(ra) # 6b6 <fprintf>
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

00000000000003d0 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3d0:	48e9                	li	a7,26
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3d8:	48ed                	li	a7,27
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3e0:	48f5                	li	a7,29
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <listen>:
.global listen
listen:
 li a7, SYS_listen
 3e8:	48f1                	li	a7,28
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3f0:	48f9                	li	a7,30
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <send>:
.global send
send:
 li a7, SYS_send
 3f8:	48fd                	li	a7,31
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <recv>:
.global recv
recv:
 li a7, SYS_recv
 400:	02000893          	li	a7,32
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 40a:	02100893          	li	a7,33
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 414:	02200893          	li	a7,34
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41e:	1101                	addi	sp,sp,-32
 420:	ec06                	sd	ra,24(sp)
 422:	e822                	sd	s0,16(sp)
 424:	1000                	addi	s0,sp,32
 426:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42a:	4605                	li	a2,1
 42c:	fef40593          	addi	a1,s0,-17
 430:	00000097          	auipc	ra,0x0
 434:	f00080e7          	jalr	-256(ra) # 330 <write>
}
 438:	60e2                	ld	ra,24(sp)
 43a:	6442                	ld	s0,16(sp)
 43c:	6105                	addi	sp,sp,32
 43e:	8082                	ret

0000000000000440 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	7139                	addi	sp,sp,-64
 442:	fc06                	sd	ra,56(sp)
 444:	f822                	sd	s0,48(sp)
 446:	f04a                	sd	s2,32(sp)
 448:	ec4e                	sd	s3,24(sp)
 44a:	0080                	addi	s0,sp,64
 44c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44e:	cad9                	beqz	a3,4e4 <printint+0xa4>
 450:	01f5d79b          	srliw	a5,a1,0x1f
 454:	cbc1                	beqz	a5,4e4 <printint+0xa4>
    neg = 1;
    x = -xx;
 456:	40b005bb          	negw	a1,a1
    neg = 1;
 45a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 45c:	fc040993          	addi	s3,s0,-64
  neg = 0;
 460:	86ce                	mv	a3,s3
  i = 0;
 462:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 464:	00000817          	auipc	a6,0x0
 468:	73480813          	addi	a6,a6,1844 # b98 <digits>
 46c:	88ba                	mv	a7,a4
 46e:	0017051b          	addiw	a0,a4,1
 472:	872a                	mv	a4,a0
 474:	02c5f7bb          	remuw	a5,a1,a2
 478:	1782                	slli	a5,a5,0x20
 47a:	9381                	srli	a5,a5,0x20
 47c:	97c2                	add	a5,a5,a6
 47e:	0007c783          	lbu	a5,0(a5)
 482:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 486:	87ae                	mv	a5,a1
 488:	02c5d5bb          	divuw	a1,a1,a2
 48c:	0685                	addi	a3,a3,1
 48e:	fcc7ffe3          	bgeu	a5,a2,46c <printint+0x2c>
  if(neg)
 492:	00030c63          	beqz	t1,4aa <printint+0x6a>
    buf[i++] = '-';
 496:	fd050793          	addi	a5,a0,-48
 49a:	00878533          	add	a0,a5,s0
 49e:	02d00793          	li	a5,45
 4a2:	fef50823          	sb	a5,-16(a0)
 4a6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4aa:	02e05763          	blez	a4,4d8 <printint+0x98>
 4ae:	f426                	sd	s1,40(sp)
 4b0:	377d                	addiw	a4,a4,-1
 4b2:	00e984b3          	add	s1,s3,a4
 4b6:	19fd                	addi	s3,s3,-1
 4b8:	99ba                	add	s3,s3,a4
 4ba:	1702                	slli	a4,a4,0x20
 4bc:	9301                	srli	a4,a4,0x20
 4be:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c2:	0004c583          	lbu	a1,0(s1)
 4c6:	854a                	mv	a0,s2
 4c8:	00000097          	auipc	ra,0x0
 4cc:	f56080e7          	jalr	-170(ra) # 41e <putc>
  while(--i >= 0)
 4d0:	14fd                	addi	s1,s1,-1
 4d2:	ff3498e3          	bne	s1,s3,4c2 <printint+0x82>
 4d6:	74a2                	ld	s1,40(sp)
}
 4d8:	70e2                	ld	ra,56(sp)
 4da:	7442                	ld	s0,48(sp)
 4dc:	7902                	ld	s2,32(sp)
 4de:	69e2                	ld	s3,24(sp)
 4e0:	6121                	addi	sp,sp,64
 4e2:	8082                	ret
  neg = 0;
 4e4:	4301                	li	t1,0
 4e6:	bf9d                	j	45c <printint+0x1c>

00000000000004e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e8:	715d                	addi	sp,sp,-80
 4ea:	e486                	sd	ra,72(sp)
 4ec:	e0a2                	sd	s0,64(sp)
 4ee:	f84a                	sd	s2,48(sp)
 4f0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f2:	0005c903          	lbu	s2,0(a1)
 4f6:	1a090b63          	beqz	s2,6ac <vprintf+0x1c4>
 4fa:	fc26                	sd	s1,56(sp)
 4fc:	f44e                	sd	s3,40(sp)
 4fe:	f052                	sd	s4,32(sp)
 500:	ec56                	sd	s5,24(sp)
 502:	e85a                	sd	s6,16(sp)
 504:	e45e                	sd	s7,8(sp)
 506:	8aaa                	mv	s5,a0
 508:	8bb2                	mv	s7,a2
 50a:	00158493          	addi	s1,a1,1
  state = 0;
 50e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 510:	02500a13          	li	s4,37
 514:	4b55                	li	s6,21
 516:	a839                	j	534 <vprintf+0x4c>
        putc(fd, c);
 518:	85ca                	mv	a1,s2
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	f02080e7          	jalr	-254(ra) # 41e <putc>
 524:	a019                	j	52a <vprintf+0x42>
    } else if(state == '%'){
 526:	01498d63          	beq	s3,s4,540 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 52a:	0485                	addi	s1,s1,1
 52c:	fff4c903          	lbu	s2,-1(s1)
 530:	16090863          	beqz	s2,6a0 <vprintf+0x1b8>
    if(state == 0){
 534:	fe0999e3          	bnez	s3,526 <vprintf+0x3e>
      if(c == '%'){
 538:	ff4910e3          	bne	s2,s4,518 <vprintf+0x30>
        state = '%';
 53c:	89d2                	mv	s3,s4
 53e:	b7f5                	j	52a <vprintf+0x42>
      if(c == 'd'){
 540:	13490563          	beq	s2,s4,66a <vprintf+0x182>
 544:	f9d9079b          	addiw	a5,s2,-99
 548:	0ff7f793          	zext.b	a5,a5
 54c:	12fb6863          	bltu	s6,a5,67c <vprintf+0x194>
 550:	f9d9079b          	addiw	a5,s2,-99
 554:	0ff7f713          	zext.b	a4,a5
 558:	12eb6263          	bltu	s6,a4,67c <vprintf+0x194>
 55c:	00271793          	slli	a5,a4,0x2
 560:	00000717          	auipc	a4,0x0
 564:	5e070713          	addi	a4,a4,1504 # b40 <ithread_join+0x9e>
 568:	97ba                	add	a5,a5,a4
 56a:	439c                	lw	a5,0(a5)
 56c:	97ba                	add	a5,a5,a4
 56e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 570:	008b8913          	addi	s2,s7,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	ec2080e7          	jalr	-318(ra) # 440 <printint>
 586:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 588:	4981                	li	s3,0
 58a:	b745                	j	52a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	008b8913          	addi	s2,s7,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000ba583          	lw	a1,0(s7)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	ea6080e7          	jalr	-346(ra) # 440 <printint>
 5a2:	8bca                	mv	s7,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b751                	j	52a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5a8:	008b8913          	addi	s2,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4641                	li	a2,16
 5b0:	000ba583          	lw	a1,0(s7)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e8a080e7          	jalr	-374(ra) # 440 <printint>
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b7a5                	j	52a <vprintf+0x42>
 5c4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5c6:	008b8793          	addi	a5,s7,8
 5ca:	8c3e                	mv	s8,a5
 5cc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5d0:	03000593          	li	a1,48
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	e48080e7          	jalr	-440(ra) # 41e <putc>
  putc(fd, 'x');
 5de:	07800593          	li	a1,120
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e3a080e7          	jalr	-454(ra) # 41e <putc>
 5ec:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ee:	00000b97          	auipc	s7,0x0
 5f2:	5aab8b93          	addi	s7,s7,1450 # b98 <digits>
 5f6:	03c9d793          	srli	a5,s3,0x3c
 5fa:	97de                	add	a5,a5,s7
 5fc:	0007c583          	lbu	a1,0(a5)
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	e1c080e7          	jalr	-484(ra) # 41e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60a:	0992                	slli	s3,s3,0x4
 60c:	397d                	addiw	s2,s2,-1
 60e:	fe0914e3          	bnez	s2,5f6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 612:	8be2                	mv	s7,s8
      state = 0;
 614:	4981                	li	s3,0
 616:	6c02                	ld	s8,0(sp)
 618:	bf09                	j	52a <vprintf+0x42>
        s = va_arg(ap, char*);
 61a:	008b8993          	addi	s3,s7,8
 61e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 622:	02090163          	beqz	s2,644 <vprintf+0x15c>
        while(*s != 0){
 626:	00094583          	lbu	a1,0(s2)
 62a:	c9a5                	beqz	a1,69a <vprintf+0x1b2>
          putc(fd, *s);
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	df0080e7          	jalr	-528(ra) # 41e <putc>
          s++;
 636:	0905                	addi	s2,s2,1
        while(*s != 0){
 638:	00094583          	lbu	a1,0(s2)
 63c:	f9e5                	bnez	a1,62c <vprintf+0x144>
        s = va_arg(ap, char*);
 63e:	8bce                	mv	s7,s3
      state = 0;
 640:	4981                	li	s3,0
 642:	b5e5                	j	52a <vprintf+0x42>
          s = "(null)";
 644:	00000917          	auipc	s2,0x0
 648:	4c490913          	addi	s2,s2,1220 # b08 <ithread_join+0x66>
        while(*s != 0){
 64c:	02800593          	li	a1,40
 650:	bff1                	j	62c <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 652:	008b8913          	addi	s2,s7,8
 656:	000bc583          	lbu	a1,0(s7)
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	dc2080e7          	jalr	-574(ra) # 41e <putc>
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
 668:	b5c9                	j	52a <vprintf+0x42>
        putc(fd, c);
 66a:	02500593          	li	a1,37
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	dae080e7          	jalr	-594(ra) # 41e <putc>
      state = 0;
 678:	4981                	li	s3,0
 67a:	bd45                	j	52a <vprintf+0x42>
        putc(fd, '%');
 67c:	02500593          	li	a1,37
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	d9c080e7          	jalr	-612(ra) # 41e <putc>
        putc(fd, c);
 68a:	85ca                	mv	a1,s2
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	d90080e7          	jalr	-624(ra) # 41e <putc>
      state = 0;
 696:	4981                	li	s3,0
 698:	bd49                	j	52a <vprintf+0x42>
        s = va_arg(ap, char*);
 69a:	8bce                	mv	s7,s3
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b571                	j	52a <vprintf+0x42>
 6a0:	74e2                	ld	s1,56(sp)
 6a2:	79a2                	ld	s3,40(sp)
 6a4:	7a02                	ld	s4,32(sp)
 6a6:	6ae2                	ld	s5,24(sp)
 6a8:	6b42                	ld	s6,16(sp)
 6aa:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6ac:	60a6                	ld	ra,72(sp)
 6ae:	6406                	ld	s0,64(sp)
 6b0:	7942                	ld	s2,48(sp)
 6b2:	6161                	addi	sp,sp,80
 6b4:	8082                	ret

00000000000006b6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b6:	715d                	addi	sp,sp,-80
 6b8:	ec06                	sd	ra,24(sp)
 6ba:	e822                	sd	s0,16(sp)
 6bc:	1000                	addi	s0,sp,32
 6be:	e010                	sd	a2,0(s0)
 6c0:	e414                	sd	a3,8(s0)
 6c2:	e818                	sd	a4,16(s0)
 6c4:	ec1c                	sd	a5,24(s0)
 6c6:	03043023          	sd	a6,32(s0)
 6ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ce:	8622                	mv	a2,s0
 6d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e14080e7          	jalr	-492(ra) # 4e8 <vprintf>
}
 6dc:	60e2                	ld	ra,24(sp)
 6de:	6442                	ld	s0,16(sp)
 6e0:	6161                	addi	sp,sp,80
 6e2:	8082                	ret

00000000000006e4 <printf>:

void
printf(const char *fmt, ...)
{
 6e4:	711d                	addi	sp,sp,-96
 6e6:	ec06                	sd	ra,24(sp)
 6e8:	e822                	sd	s0,16(sp)
 6ea:	1000                	addi	s0,sp,32
 6ec:	e40c                	sd	a1,8(s0)
 6ee:	e810                	sd	a2,16(s0)
 6f0:	ec14                	sd	a3,24(s0)
 6f2:	f018                	sd	a4,32(s0)
 6f4:	f41c                	sd	a5,40(s0)
 6f6:	03043823          	sd	a6,48(s0)
 6fa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6fe:	00840613          	addi	a2,s0,8
 702:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 706:	85aa                	mv	a1,a0
 708:	4505                	li	a0,1
 70a:	00000097          	auipc	ra,0x0
 70e:	dde080e7          	jalr	-546(ra) # 4e8 <vprintf>
}
 712:	60e2                	ld	ra,24(sp)
 714:	6442                	ld	s0,16(sp)
 716:	6125                	addi	sp,sp,96
 718:	8082                	ret

000000000000071a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71a:	1141                	addi	sp,sp,-16
 71c:	e406                	sd	ra,8(sp)
 71e:	e022                	sd	s0,0(sp)
 720:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 722:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 726:	00001797          	auipc	a5,0x1
 72a:	dea7b783          	ld	a5,-534(a5) # 1510 <freep>
 72e:	a039                	j	73c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	6398                	ld	a4,0(a5)
 732:	00e7e463          	bltu	a5,a4,73a <free+0x20>
 736:	00e6ea63          	bltu	a3,a4,74a <free+0x30>
{
 73a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73c:	fed7fae3          	bgeu	a5,a3,730 <free+0x16>
 740:	6398                	ld	a4,0(a5)
 742:	00e6e463          	bltu	a3,a4,74a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 746:	fee7eae3          	bltu	a5,a4,73a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 74a:	ff852583          	lw	a1,-8(a0)
 74e:	6390                	ld	a2,0(a5)
 750:	02059813          	slli	a6,a1,0x20
 754:	01c85713          	srli	a4,a6,0x1c
 758:	9736                	add	a4,a4,a3
 75a:	02e60563          	beq	a2,a4,784 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 75e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 762:	4790                	lw	a2,8(a5)
 764:	02061593          	slli	a1,a2,0x20
 768:	01c5d713          	srli	a4,a1,0x1c
 76c:	973e                	add	a4,a4,a5
 76e:	02e68263          	beq	a3,a4,792 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 772:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 774:	00001717          	auipc	a4,0x1
 778:	d8f73e23          	sd	a5,-612(a4) # 1510 <freep>
}
 77c:	60a2                	ld	ra,8(sp)
 77e:	6402                	ld	s0,0(sp)
 780:	0141                	addi	sp,sp,16
 782:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 784:	4618                	lw	a4,8(a2)
 786:	9f2d                	addw	a4,a4,a1
 788:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78c:	6398                	ld	a4,0(a5)
 78e:	6310                	ld	a2,0(a4)
 790:	b7f9                	j	75e <free+0x44>
    p->s.size += bp->s.size;
 792:	ff852703          	lw	a4,-8(a0)
 796:	9f31                	addw	a4,a4,a2
 798:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 79a:	ff053683          	ld	a3,-16(a0)
 79e:	bfd1                	j	772 <free+0x58>

00000000000007a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a0:	7139                	addi	sp,sp,-64
 7a2:	fc06                	sd	ra,56(sp)
 7a4:	f822                	sd	s0,48(sp)
 7a6:	f04a                	sd	s2,32(sp)
 7a8:	ec4e                	sd	s3,24(sp)
 7aa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ac:	02051993          	slli	s3,a0,0x20
 7b0:	0209d993          	srli	s3,s3,0x20
 7b4:	09bd                	addi	s3,s3,15
 7b6:	0049d993          	srli	s3,s3,0x4
 7ba:	2985                	addiw	s3,s3,1
 7bc:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7be:	00001517          	auipc	a0,0x1
 7c2:	d5253503          	ld	a0,-686(a0) # 1510 <freep>
 7c6:	c905                	beqz	a0,7f6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ca:	4798                	lw	a4,8(a5)
 7cc:	09377a63          	bgeu	a4,s3,860 <malloc+0xc0>
 7d0:	f426                	sd	s1,40(sp)
 7d2:	e852                	sd	s4,16(sp)
 7d4:	e456                	sd	s5,8(sp)
 7d6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7d8:	8a4e                	mv	s4,s3
 7da:	6705                	lui	a4,0x1
 7dc:	00e9f363          	bgeu	s3,a4,7e2 <malloc+0x42>
 7e0:	6a05                	lui	s4,0x1
 7e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ea:	00001497          	auipc	s1,0x1
 7ee:	d2648493          	addi	s1,s1,-730 # 1510 <freep>
  if(p == (char*)-1)
 7f2:	5afd                	li	s5,-1
 7f4:	a089                	j	836 <malloc+0x96>
 7f6:	f426                	sd	s1,40(sp)
 7f8:	e852                	sd	s4,16(sp)
 7fa:	e456                	sd	s5,8(sp)
 7fc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7fe:	00001797          	auipc	a5,0x1
 802:	d3278793          	addi	a5,a5,-718 # 1530 <base>
 806:	00001717          	auipc	a4,0x1
 80a:	d0f73523          	sd	a5,-758(a4) # 1510 <freep>
 80e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 810:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 814:	b7d1                	j	7d8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 816:	6398                	ld	a4,0(a5)
 818:	e118                	sd	a4,0(a0)
 81a:	a8b9                	j	878 <malloc+0xd8>
  hp->s.size = nu;
 81c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 820:	0541                	addi	a0,a0,16
 822:	00000097          	auipc	ra,0x0
 826:	ef8080e7          	jalr	-264(ra) # 71a <free>
  return freep;
 82a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 82c:	c135                	beqz	a0,890 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 830:	4798                	lw	a4,8(a5)
 832:	03277363          	bgeu	a4,s2,858 <malloc+0xb8>
    if(p == freep)
 836:	6098                	ld	a4,0(s1)
 838:	853e                	mv	a0,a5
 83a:	fef71ae3          	bne	a4,a5,82e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 83e:	8552                	mv	a0,s4
 840:	00000097          	auipc	ra,0x0
 844:	b58080e7          	jalr	-1192(ra) # 398 <sbrk>
  if(p == (char*)-1)
 848:	fd551ae3          	bne	a0,s5,81c <malloc+0x7c>
        return 0;
 84c:	4501                	li	a0,0
 84e:	74a2                	ld	s1,40(sp)
 850:	6a42                	ld	s4,16(sp)
 852:	6aa2                	ld	s5,8(sp)
 854:	6b02                	ld	s6,0(sp)
 856:	a03d                	j	884 <malloc+0xe4>
 858:	74a2                	ld	s1,40(sp)
 85a:	6a42                	ld	s4,16(sp)
 85c:	6aa2                	ld	s5,8(sp)
 85e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 860:	fae90be3          	beq	s2,a4,816 <malloc+0x76>
        p->s.size -= nunits;
 864:	4137073b          	subw	a4,a4,s3
 868:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86a:	02071693          	slli	a3,a4,0x20
 86e:	01c6d713          	srli	a4,a3,0x1c
 872:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 874:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 878:	00001717          	auipc	a4,0x1
 87c:	c8a73c23          	sd	a0,-872(a4) # 1510 <freep>
      return (void*)(p + 1);
 880:	01078513          	addi	a0,a5,16
  }
}
 884:	70e2                	ld	ra,56(sp)
 886:	7442                	ld	s0,48(sp)
 888:	7902                	ld	s2,32(sp)
 88a:	69e2                	ld	s3,24(sp)
 88c:	6121                	addi	sp,sp,64
 88e:	8082                	ret
 890:	74a2                	ld	s1,40(sp)
 892:	6a42                	ld	s4,16(sp)
 894:	6aa2                	ld	s5,8(sp)
 896:	6b02                	ld	s6,0(sp)
 898:	b7f5                	j	884 <malloc+0xe4>

000000000000089a <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 89a:	1141                	addi	sp,sp,-16
 89c:	e406                	sd	ra,8(sp)
 89e:	e022                	sd	s0,0(sp)
 8a0:	0800                	addi	s0,sp,16
  thread_exit(status);
 8a2:	2501                	sext.w	a0,a0
 8a4:	00000097          	auipc	ra,0x0
 8a8:	b24080e7          	jalr	-1244(ra) # 3c8 <thread_exit>
}
 8ac:	60a2                	ld	ra,8(sp)
 8ae:	6402                	ld	s0,0(sp)
 8b0:	0141                	addi	sp,sp,16
 8b2:	8082                	ret

00000000000008b4 <free_stacks>:
int free_stacks() {
 8b4:	7179                	addi	sp,sp,-48
 8b6:	f406                	sd	ra,40(sp)
 8b8:	f022                	sd	s0,32(sp)
 8ba:	ec26                	sd	s1,24(sp)
 8bc:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8be:	00001797          	auipc	a5,0x1
 8c2:	c627a783          	lw	a5,-926(a5) # 1520 <num_threads>
 8c6:	04f05063          	blez	a5,906 <free_stacks+0x52>
 8ca:	e84a                	sd	s2,16(sp)
 8cc:	e44e                	sd	s3,8(sp)
 8ce:	4481                	li	s1,0
    free(stacks[i]);
 8d0:	00001997          	auipc	s3,0x1
 8d4:	c4898993          	addi	s3,s3,-952 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8d8:	00001917          	auipc	s2,0x1
 8dc:	c4890913          	addi	s2,s2,-952 # 1520 <num_threads>
    free(stacks[i]);
 8e0:	0009b783          	ld	a5,0(s3)
 8e4:	00349713          	slli	a4,s1,0x3
 8e8:	97ba                	add	a5,a5,a4
 8ea:	6388                	ld	a0,0(a5)
 8ec:	00000097          	auipc	ra,0x0
 8f0:	e2e080e7          	jalr	-466(ra) # 71a <free>
  for (int i = 0; i < num_threads; i++) {
 8f4:	0485                	addi	s1,s1,1
 8f6:	00092703          	lw	a4,0(s2)
 8fa:	0004879b          	sext.w	a5,s1
 8fe:	fee7c1e3          	blt	a5,a4,8e0 <free_stacks+0x2c>
 902:	6942                	ld	s2,16(sp)
 904:	69a2                	ld	s3,8(sp)
  free(stacks);
 906:	00001497          	auipc	s1,0x1
 90a:	c1248493          	addi	s1,s1,-1006 # 1518 <stacks>
 90e:	6088                	ld	a0,0(s1)
 910:	00000097          	auipc	ra,0x0
 914:	e0a080e7          	jalr	-502(ra) # 71a <free>
  stacks = 0;
 918:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 91c:	00001797          	auipc	a5,0x1
 920:	c007a223          	sw	zero,-1020(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 924:	47a1                	li	a5,8
 926:	00001717          	auipc	a4,0x1
 92a:	bcf72d23          	sw	a5,-1062(a4) # 1500 <max_stacks>
  threads_done = 0;
 92e:	00001797          	auipc	a5,0x1
 932:	be07ab23          	sw	zero,-1034(a5) # 1524 <threads_done>
}
 936:	4501                	li	a0,0
 938:	70a2                	ld	ra,40(sp)
 93a:	7402                	ld	s0,32(sp)
 93c:	64e2                	ld	s1,24(sp)
 93e:	6145                	addi	sp,sp,48
 940:	8082                	ret

0000000000000942 <expand_num_threads>:
int expand_num_threads() {
 942:	1101                	addi	sp,sp,-32
 944:	ec06                	sd	ra,24(sp)
 946:	e822                	sd	s0,16(sp)
 948:	e426                	sd	s1,8(sp)
 94a:	e04a                	sd	s2,0(sp)
 94c:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 94e:	00001797          	auipc	a5,0x1
 952:	bb278793          	addi	a5,a5,-1102 # 1500 <max_stacks>
 956:	4388                	lw	a0,0(a5)
 958:	0015151b          	slliw	a0,a0,0x1
 95c:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 95e:	0035151b          	slliw	a0,a0,0x3
 962:	00000097          	auipc	ra,0x0
 966:	e3e080e7          	jalr	-450(ra) # 7a0 <malloc>
 96a:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 96c:	00001617          	auipc	a2,0x1
 970:	bb462603          	lw	a2,-1100(a2) # 1520 <num_threads>
 974:	00001497          	auipc	s1,0x1
 978:	ba448493          	addi	s1,s1,-1116 # 1518 <stacks>
 97c:	0036161b          	slliw	a2,a2,0x3
 980:	608c                	ld	a1,0(s1)
 982:	00000097          	auipc	ra,0x0
 986:	8d8080e7          	jalr	-1832(ra) # 25a <memmove>
  free(stacks);
 98a:	6088                	ld	a0,0(s1)
 98c:	00000097          	auipc	ra,0x0
 990:	d8e080e7          	jalr	-626(ra) # 71a <free>
  stacks = new_stacks;
 994:	0124b023          	sd	s2,0(s1)
}
 998:	4501                	li	a0,0
 99a:	60e2                	ld	ra,24(sp)
 99c:	6442                	ld	s0,16(sp)
 99e:	64a2                	ld	s1,8(sp)
 9a0:	6902                	ld	s2,0(sp)
 9a2:	6105                	addi	sp,sp,32
 9a4:	8082                	ret

00000000000009a6 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9a6:	7179                	addi	sp,sp,-48
 9a8:	f406                	sd	ra,40(sp)
 9aa:	f022                	sd	s0,32(sp)
 9ac:	e84a                	sd	s2,16(sp)
 9ae:	e44e                	sd	s3,8(sp)
 9b0:	1800                	addi	s0,sp,48
 9b2:	892a                	mv	s2,a0
 9b4:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9b6:	00001797          	auipc	a5,0x1
 9ba:	b627b783          	ld	a5,-1182(a5) # 1518 <stacks>
 9be:	c3d9                	beqz	a5,a44 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9c0:	00001797          	auipc	a5,0x1
 9c4:	b407a783          	lw	a5,-1216(a5) # 1500 <max_stacks>
 9c8:	00001717          	auipc	a4,0x1
 9cc:	b5872703          	lw	a4,-1192(a4) # 1520 <num_threads>
 9d0:	0af71463          	bne	a4,a5,a78 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 9d4:	04000713          	li	a4,64
 9d8:	08e78563          	beq	a5,a4,a62 <ithread_create+0xbc>
 9dc:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9de:	00000097          	auipc	ra,0x0
 9e2:	f64080e7          	jalr	-156(ra) # 942 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9e6:	6505                	lui	a0,0x1
 9e8:	00000097          	auipc	ra,0x0
 9ec:	db8080e7          	jalr	-584(ra) # 7a0 <malloc>
 9f0:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9f2:	00001717          	auipc	a4,0x1
 9f6:	b2e72703          	lw	a4,-1234(a4) # 1520 <num_threads>
 9fa:	070e                	slli	a4,a4,0x3
 9fc:	00001797          	auipc	a5,0x1
 a00:	b1c7b783          	ld	a5,-1252(a5) # 1518 <stacks>
 a04:	97ba                	add	a5,a5,a4
 a06:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a08:	00000697          	auipc	a3,0x0
 a0c:	e9268693          	addi	a3,a3,-366 # 89a <ithread_exit>
 a10:	862a                	mv	a2,a0
 a12:	85ce                	mv	a1,s3
 a14:	854a                	mv	a0,s2
 a16:	00000097          	auipc	ra,0x0
 a1a:	9a2080e7          	jalr	-1630(ra) # 3b8 <create_thread>
 a1e:	892a                	mv	s2,a0
  if (res != -1) {
 a20:	57fd                	li	a5,-1
 a22:	04f50d63          	beq	a0,a5,a7c <ithread_create+0xd6>
    num_threads++;
 a26:	00001717          	auipc	a4,0x1
 a2a:	afa70713          	addi	a4,a4,-1286 # 1520 <num_threads>
 a2e:	431c                	lw	a5,0(a4)
 a30:	2785                	addiw	a5,a5,1
 a32:	c31c                	sw	a5,0(a4)
 a34:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a36:	854a                	mv	a0,s2
 a38:	70a2                	ld	ra,40(sp)
 a3a:	7402                	ld	s0,32(sp)
 a3c:	6942                	ld	s2,16(sp)
 a3e:	69a2                	ld	s3,8(sp)
 a40:	6145                	addi	sp,sp,48
 a42:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a44:	00001517          	auipc	a0,0x1
 a48:	abc52503          	lw	a0,-1348(a0) # 1500 <max_stacks>
 a4c:	0035151b          	slliw	a0,a0,0x3
 a50:	00000097          	auipc	ra,0x0
 a54:	d50080e7          	jalr	-688(ra) # 7a0 <malloc>
 a58:	00001797          	auipc	a5,0x1
 a5c:	aca7b023          	sd	a0,-1344(a5) # 1518 <stacks>
 a60:	b785                	j	9c0 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a62:	00000517          	auipc	a0,0x0
 a66:	0ae50513          	addi	a0,a0,174 # b10 <ithread_join+0x6e>
 a6a:	00000097          	auipc	ra,0x0
 a6e:	c7a080e7          	jalr	-902(ra) # 6e4 <printf>
      return -1;
 a72:	57fd                	li	a5,-1
 a74:	893e                	mv	s2,a5
 a76:	b7c1                	j	a36 <ithread_create+0x90>
 a78:	ec26                	sd	s1,24(sp)
 a7a:	b7b5                	j	9e6 <ithread_create+0x40>
    free(stack_ptr);
 a7c:	8526                	mv	a0,s1
 a7e:	00000097          	auipc	ra,0x0
 a82:	c9c080e7          	jalr	-868(ra) # 71a <free>
    stacks[num_threads] = 0;
 a86:	00001717          	auipc	a4,0x1
 a8a:	a9a72703          	lw	a4,-1382(a4) # 1520 <num_threads>
 a8e:	070e                	slli	a4,a4,0x3
 a90:	00001797          	auipc	a5,0x1
 a94:	a887b783          	ld	a5,-1400(a5) # 1518 <stacks>
 a98:	97ba                	add	a5,a5,a4
 a9a:	0007b023          	sd	zero,0(a5)
 a9e:	64e2                	ld	s1,24(sp)
 aa0:	bf59                	j	a36 <ithread_create+0x90>

0000000000000aa2 <ithread_join>:

int ithread_join(int thread_id) {
 aa2:	1101                	addi	sp,sp,-32
 aa4:	ec06                	sd	ra,24(sp)
 aa6:	e822                	sd	s0,16(sp)
 aa8:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 aaa:	ff040793          	addi	a5,s0,-16
 aae:	ffc7859b          	addiw	a1,a5,-4
 ab2:	00000097          	auipc	ra,0x0
 ab6:	90e080e7          	jalr	-1778(ra) # 3c0 <join_thread>
  threads_done++;
 aba:	00001717          	auipc	a4,0x1
 abe:	a6a70713          	addi	a4,a4,-1430 # 1524 <threads_done>
 ac2:	431c                	lw	a5,0(a4)
 ac4:	2785                	addiw	a5,a5,1
 ac6:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ac8:	00001717          	auipc	a4,0x1
 acc:	a5872703          	lw	a4,-1448(a4) # 1520 <num_threads>
 ad0:	00f70863          	beq	a4,a5,ae0 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ad4:	fec42503          	lw	a0,-20(s0)
 ad8:	60e2                	ld	ra,24(sp)
 ada:	6442                	ld	s0,16(sp)
 adc:	6105                	addi	sp,sp,32
 ade:	8082                	ret
    free_stacks();
 ae0:	00000097          	auipc	ra,0x0
 ae4:	dd4080e7          	jalr	-556(ra) # 8b4 <free_stacks>
 ae8:	b7f5                	j	ad4 <ithread_join+0x32>
