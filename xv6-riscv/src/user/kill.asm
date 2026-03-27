
src/user/_kill:     file format elf64-littleriscv


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
  2c:	1cc080e7          	jalr	460(ra) # 1f4 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	2ee080e7          	jalr	750(ra) # 31e <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2ae080e7          	jalr	686(ra) # 2ee <exit>
  48:	e426                	sd	s1,8(sp)
  4a:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  4c:	00001597          	auipc	a1,0x1
  50:	a8458593          	addi	a1,a1,-1404 # ad0 <ithread_join+0x4e>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	640080e7          	jalr	1600(ra) # 696 <fprintf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	28e080e7          	jalr	654(ra) # 2ee <exit>

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
  7e:	274080e7          	jalr	628(ra) # 2ee <exit>

0000000000000082 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  88:	87aa                	mv	a5,a0
  8a:	0585                	addi	a1,a1,1
  8c:	0785                	addi	a5,a5,1
  8e:	fff5c703          	lbu	a4,-1(a1)
  92:	fee78fa3          	sb	a4,-1(a5)
  96:	fb75                	bnez	a4,8a <strcpy+0x8>
    ;
  return os;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret

000000000000009e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x1e>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x1e>
    p++, q++;
  b2:	0505                	addi	a0,a0,1
  b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint
strlen(const char *s)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strlen+0x26>
  d6:	0505                	addi	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	86be                	mv	a3,a5
  dc:	0785                	addi	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x10>
  e4:	40a6853b          	subw	a0,a3,a0
  e8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strlen+0x20>

00000000000000f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fa:	ca19                	beqz	a2,110 <memset+0x1c>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	slli	a2,a2,0x20
 100:	9201                	srli	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10a:	0785                	addi	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x12>
  }
  return dst;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strchr>:

char*
strchr(const char *s, char c)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cb99                	beqz	a5,136 <strchr+0x20>
    if(*s == c)
 122:	00f58763          	beq	a1,a5,130 <strchr+0x1a>
  for(; *s; s++)
 126:	0505                	addi	a0,a0,1
 128:	00054783          	lbu	a5,0(a0)
 12c:	fbfd                	bnez	a5,122 <strchr+0xc>
      return (char*)s;
  return 0;
 12e:	4501                	li	a0,0
}
 130:	6422                	ld	s0,8(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret
  return 0;
 136:	4501                	li	a0,0
 138:	bfe5                	j	130 <strchr+0x1a>

000000000000013a <gets>:

char*
gets(char *buf, int max)
{
 13a:	711d                	addi	sp,sp,-96
 13c:	ec86                	sd	ra,88(sp)
 13e:	e8a2                	sd	s0,80(sp)
 140:	e4a6                	sd	s1,72(sp)
 142:	e0ca                	sd	s2,64(sp)
 144:	fc4e                	sd	s3,56(sp)
 146:	f852                	sd	s4,48(sp)
 148:	f456                	sd	s5,40(sp)
 14a:	f05a                	sd	s6,32(sp)
 14c:	ec5e                	sd	s7,24(sp)
 14e:	1080                	addi	s0,sp,96
 150:	8baa                	mv	s7,a0
 152:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 154:	892a                	mv	s2,a0
 156:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 158:	4aa9                	li	s5,10
 15a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 15c:	89a6                	mv	s3,s1
 15e:	2485                	addiw	s1,s1,1
 160:	0344d863          	bge	s1,s4,190 <gets+0x56>
    cc = read(0, &c, 1);
 164:	4605                	li	a2,1
 166:	faf40593          	addi	a1,s0,-81
 16a:	4501                	li	a0,0
 16c:	00000097          	auipc	ra,0x0
 170:	19a080e7          	jalr	410(ra) # 306 <read>
    if(cc < 1)
 174:	00a05e63          	blez	a0,190 <gets+0x56>
    buf[i++] = c;
 178:	faf44783          	lbu	a5,-81(s0)
 17c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 180:	01578763          	beq	a5,s5,18e <gets+0x54>
 184:	0905                	addi	s2,s2,1
 186:	fd679be3          	bne	a5,s6,15c <gets+0x22>
    buf[i++] = c;
 18a:	89a6                	mv	s3,s1
 18c:	a011                	j	190 <gets+0x56>
 18e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 190:	99de                	add	s3,s3,s7
 192:	00098023          	sb	zero,0(s3)
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
 1aa:	6125                	addi	sp,sp,96
 1ac:	8082                	ret

00000000000001ae <stat>:

int
stat(const char *n, struct stat *st)
{
 1ae:	1101                	addi	sp,sp,-32
 1b0:	ec06                	sd	ra,24(sp)
 1b2:	e822                	sd	s0,16(sp)
 1b4:	e04a                	sd	s2,0(sp)
 1b6:	1000                	addi	s0,sp,32
 1b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	4581                	li	a1,0
 1bc:	00000097          	auipc	ra,0x0
 1c0:	172080e7          	jalr	370(ra) # 32e <open>
  if(fd < 0)
 1c4:	02054663          	bltz	a0,1f0 <stat+0x42>
 1c8:	e426                	sd	s1,8(sp)
 1ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1cc:	85ca                	mv	a1,s2
 1ce:	00000097          	auipc	ra,0x0
 1d2:	178080e7          	jalr	376(ra) # 346 <fstat>
 1d6:	892a                	mv	s2,a0
  close(fd);
 1d8:	8526                	mv	a0,s1
 1da:	00000097          	auipc	ra,0x0
 1de:	13c080e7          	jalr	316(ra) # 316 <close>
  return r;
 1e2:	64a2                	ld	s1,8(sp)
}
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	6902                	ld	s2,0(sp)
 1ec:	6105                	addi	sp,sp,32
 1ee:	8082                	ret
    return -1;
 1f0:	597d                	li	s2,-1
 1f2:	bfcd                	j	1e4 <stat+0x36>

00000000000001f4 <atoi>:

int
atoi(const char *s)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fa:	00054683          	lbu	a3,0(a0)
 1fe:	fd06879b          	addiw	a5,a3,-48
 202:	0ff7f793          	zext.b	a5,a5
 206:	4625                	li	a2,9
 208:	02f66863          	bltu	a2,a5,238 <atoi+0x44>
 20c:	872a                	mv	a4,a0
  n = 0;
 20e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 210:	0705                	addi	a4,a4,1
 212:	0025179b          	slliw	a5,a0,0x2
 216:	9fa9                	addw	a5,a5,a0
 218:	0017979b          	slliw	a5,a5,0x1
 21c:	9fb5                	addw	a5,a5,a3
 21e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 222:	00074683          	lbu	a3,0(a4)
 226:	fd06879b          	addiw	a5,a3,-48
 22a:	0ff7f793          	zext.b	a5,a5
 22e:	fef671e3          	bgeu	a2,a5,210 <atoi+0x1c>
  return n;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
  n = 0;
 238:	4501                	li	a0,0
 23a:	bfe5                	j	232 <atoi+0x3e>

000000000000023c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 242:	02b57463          	bgeu	a0,a1,26a <memmove+0x2e>
    while(n-- > 0)
 246:	00c05f63          	blez	a2,264 <memmove+0x28>
 24a:	1602                	slli	a2,a2,0x20
 24c:	9201                	srli	a2,a2,0x20
 24e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 252:	872a                	mv	a4,a0
      *dst++ = *src++;
 254:	0585                	addi	a1,a1,1
 256:	0705                	addi	a4,a4,1
 258:	fff5c683          	lbu	a3,-1(a1)
 25c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 260:	fef71ae3          	bne	a4,a5,254 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
    dst += n;
 26a:	00c50733          	add	a4,a0,a2
    src += n;
 26e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 270:	fec05ae3          	blez	a2,264 <memmove+0x28>
 274:	fff6079b          	addiw	a5,a2,-1
 278:	1782                	slli	a5,a5,0x20
 27a:	9381                	srli	a5,a5,0x20
 27c:	fff7c793          	not	a5,a5
 280:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 282:	15fd                	addi	a1,a1,-1
 284:	177d                	addi	a4,a4,-1
 286:	0005c683          	lbu	a3,0(a1)
 28a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28e:	fee79ae3          	bne	a5,a4,282 <memmove+0x46>
 292:	bfc9                	j	264 <memmove+0x28>

0000000000000294 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29a:	ca05                	beqz	a2,2ca <memcmp+0x36>
 29c:	fff6069b          	addiw	a3,a2,-1
 2a0:	1682                	slli	a3,a3,0x20
 2a2:	9281                	srli	a3,a3,0x20
 2a4:	0685                	addi	a3,a3,1
 2a6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	0005c703          	lbu	a4,0(a1)
 2b0:	00e79863          	bne	a5,a4,2c0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b4:	0505                	addi	a0,a0,1
    p2++;
 2b6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b8:	fed518e3          	bne	a0,a3,2a8 <memcmp+0x14>
  }
  return 0;
 2bc:	4501                	li	a0,0
 2be:	a019                	j	2c4 <memcmp+0x30>
      return *p1 - *p2;
 2c0:	40e7853b          	subw	a0,a5,a4
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  return 0;
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <memcmp+0x30>

00000000000002ce <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d6:	00000097          	auipc	ra,0x0
 2da:	f66080e7          	jalr	-154(ra) # 23c <memmove>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e6:	4885                	li	a7,1
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ee:	4889                	li	a7,2
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f6:	488d                	li	a7,3
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fe:	4891                	li	a7,4
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <read>:
.global read
read:
 li a7, SYS_read
 306:	4895                	li	a7,5
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <write>:
.global write
write:
 li a7, SYS_write
 30e:	48c1                	li	a7,16
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <close>:
.global close
close:
 li a7, SYS_close
 316:	48d5                	li	a7,21
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <kill>:
.global kill
kill:
 li a7, SYS_kill
 31e:	4899                	li	a7,6
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <exec>:
.global exec
exec:
 li a7, SYS_exec
 326:	489d                	li	a7,7
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <open>:
.global open
open:
 li a7, SYS_open
 32e:	48bd                	li	a7,15
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 336:	48c5                	li	a7,17
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33e:	48c9                	li	a7,18
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 346:	48a1                	li	a7,8
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <link>:
.global link
link:
 li a7, SYS_link
 34e:	48cd                	li	a7,19
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 356:	48d1                	li	a7,20
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35e:	48a5                	li	a7,9
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <dup>:
.global dup
dup:
 li a7, SYS_dup
 366:	48a9                	li	a7,10
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36e:	48ad                	li	a7,11
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 376:	48b1                	li	a7,12
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37e:	48b5                	li	a7,13
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 386:	48b9                	li	a7,14
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 38e:	48d9                	li	a7,22
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 396:	48dd                	li	a7,23
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 39e:	48e1                	li	a7,24
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3a6:	48e5                	li	a7,25
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <socket>:
.global socket
socket:
 li a7, SYS_socket
 3ae:	48e9                	li	a7,26
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3b6:	48ed                	li	a7,27
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <accept>:
.global accept
accept:
 li a7, SYS_accept
 3be:	48f5                	li	a7,29
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <listen>:
.global listen
listen:
 li a7, SYS_listen
 3c6:	48f1                	li	a7,28
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <connect>:
.global connect
connect:
 li a7, SYS_connect
 3ce:	48f9                	li	a7,30
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <send>:
.global send
send:
 li a7, SYS_send
 3d6:	48fd                	li	a7,31
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <recv>:
.global recv
recv:
 li a7, SYS_recv
 3de:	02000893          	li	a7,32
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 3e8:	02100893          	li	a7,33
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 3f2:	02200893          	li	a7,34
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fc:	1101                	addi	sp,sp,-32
 3fe:	ec06                	sd	ra,24(sp)
 400:	e822                	sd	s0,16(sp)
 402:	1000                	addi	s0,sp,32
 404:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 408:	4605                	li	a2,1
 40a:	fef40593          	addi	a1,s0,-17
 40e:	00000097          	auipc	ra,0x0
 412:	f00080e7          	jalr	-256(ra) # 30e <write>
}
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	6105                	addi	sp,sp,32
 41c:	8082                	ret

000000000000041e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41e:	7139                	addi	sp,sp,-64
 420:	fc06                	sd	ra,56(sp)
 422:	f822                	sd	s0,48(sp)
 424:	f426                	sd	s1,40(sp)
 426:	0080                	addi	s0,sp,64
 428:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42a:	c299                	beqz	a3,430 <printint+0x12>
 42c:	0805cb63          	bltz	a1,4c2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 430:	2581                	sext.w	a1,a1
  neg = 0;
 432:	4881                	li	a7,0
 434:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 438:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 43a:	2601                	sext.w	a2,a2
 43c:	00000517          	auipc	a0,0x0
 440:	73c50513          	addi	a0,a0,1852 # b78 <digits>
 444:	883a                	mv	a6,a4
 446:	2705                	addiw	a4,a4,1
 448:	02c5f7bb          	remuw	a5,a1,a2
 44c:	1782                	slli	a5,a5,0x20
 44e:	9381                	srli	a5,a5,0x20
 450:	97aa                	add	a5,a5,a0
 452:	0007c783          	lbu	a5,0(a5)
 456:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 45a:	0005879b          	sext.w	a5,a1
 45e:	02c5d5bb          	divuw	a1,a1,a2
 462:	0685                	addi	a3,a3,1
 464:	fec7f0e3          	bgeu	a5,a2,444 <printint+0x26>
  if(neg)
 468:	00088c63          	beqz	a7,480 <printint+0x62>
    buf[i++] = '-';
 46c:	fd070793          	addi	a5,a4,-48
 470:	00878733          	add	a4,a5,s0
 474:	02d00793          	li	a5,45
 478:	fef70823          	sb	a5,-16(a4)
 47c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 480:	02e05c63          	blez	a4,4b8 <printint+0x9a>
 484:	f04a                	sd	s2,32(sp)
 486:	ec4e                	sd	s3,24(sp)
 488:	fc040793          	addi	a5,s0,-64
 48c:	00e78933          	add	s2,a5,a4
 490:	fff78993          	addi	s3,a5,-1
 494:	99ba                	add	s3,s3,a4
 496:	377d                	addiw	a4,a4,-1
 498:	1702                	slli	a4,a4,0x20
 49a:	9301                	srli	a4,a4,0x20
 49c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a0:	fff94583          	lbu	a1,-1(s2)
 4a4:	8526                	mv	a0,s1
 4a6:	00000097          	auipc	ra,0x0
 4aa:	f56080e7          	jalr	-170(ra) # 3fc <putc>
  while(--i >= 0)
 4ae:	197d                	addi	s2,s2,-1
 4b0:	ff3918e3          	bne	s2,s3,4a0 <printint+0x82>
 4b4:	7902                	ld	s2,32(sp)
 4b6:	69e2                	ld	s3,24(sp)
}
 4b8:	70e2                	ld	ra,56(sp)
 4ba:	7442                	ld	s0,48(sp)
 4bc:	74a2                	ld	s1,40(sp)
 4be:	6121                	addi	sp,sp,64
 4c0:	8082                	ret
    x = -xx;
 4c2:	40b005bb          	negw	a1,a1
    neg = 1;
 4c6:	4885                	li	a7,1
    x = -xx;
 4c8:	b7b5                	j	434 <printint+0x16>

00000000000004ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ca:	715d                	addi	sp,sp,-80
 4cc:	e486                	sd	ra,72(sp)
 4ce:	e0a2                	sd	s0,64(sp)
 4d0:	f84a                	sd	s2,48(sp)
 4d2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d4:	0005c903          	lbu	s2,0(a1)
 4d8:	1a090a63          	beqz	s2,68c <vprintf+0x1c2>
 4dc:	fc26                	sd	s1,56(sp)
 4de:	f44e                	sd	s3,40(sp)
 4e0:	f052                	sd	s4,32(sp)
 4e2:	ec56                	sd	s5,24(sp)
 4e4:	e85a                	sd	s6,16(sp)
 4e6:	e45e                	sd	s7,8(sp)
 4e8:	8aaa                	mv	s5,a0
 4ea:	8bb2                	mv	s7,a2
 4ec:	00158493          	addi	s1,a1,1
  state = 0;
 4f0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4f2:	02500a13          	li	s4,37
 4f6:	4b55                	li	s6,21
 4f8:	a839                	j	516 <vprintf+0x4c>
        putc(fd, c);
 4fa:	85ca                	mv	a1,s2
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	efe080e7          	jalr	-258(ra) # 3fc <putc>
 506:	a019                	j	50c <vprintf+0x42>
    } else if(state == '%'){
 508:	01498d63          	beq	s3,s4,522 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 50c:	0485                	addi	s1,s1,1
 50e:	fff4c903          	lbu	s2,-1(s1)
 512:	16090763          	beqz	s2,680 <vprintf+0x1b6>
    if(state == 0){
 516:	fe0999e3          	bnez	s3,508 <vprintf+0x3e>
      if(c == '%'){
 51a:	ff4910e3          	bne	s2,s4,4fa <vprintf+0x30>
        state = '%';
 51e:	89d2                	mv	s3,s4
 520:	b7f5                	j	50c <vprintf+0x42>
      if(c == 'd'){
 522:	13490463          	beq	s2,s4,64a <vprintf+0x180>
 526:	f9d9079b          	addiw	a5,s2,-99
 52a:	0ff7f793          	zext.b	a5,a5
 52e:	12fb6763          	bltu	s6,a5,65c <vprintf+0x192>
 532:	f9d9079b          	addiw	a5,s2,-99
 536:	0ff7f713          	zext.b	a4,a5
 53a:	12eb6163          	bltu	s6,a4,65c <vprintf+0x192>
 53e:	00271793          	slli	a5,a4,0x2
 542:	00000717          	auipc	a4,0x0
 546:	5de70713          	addi	a4,a4,1502 # b20 <ithread_join+0x9e>
 54a:	97ba                	add	a5,a5,a4
 54c:	439c                	lw	a5,0(a5)
 54e:	97ba                	add	a5,a5,a4
 550:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 552:	008b8913          	addi	s2,s7,8
 556:	4685                	li	a3,1
 558:	4629                	li	a2,10
 55a:	000ba583          	lw	a1,0(s7)
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	ebe080e7          	jalr	-322(ra) # 41e <printint>
 568:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b745                	j	50c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56e:	008b8913          	addi	s2,s7,8
 572:	4681                	li	a3,0
 574:	4629                	li	a2,10
 576:	000ba583          	lw	a1,0(s7)
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	ea2080e7          	jalr	-350(ra) # 41e <printint>
 584:	8bca                	mv	s7,s2
      state = 0;
 586:	4981                	li	s3,0
 588:	b751                	j	50c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 58a:	008b8913          	addi	s2,s7,8
 58e:	4681                	li	a3,0
 590:	4641                	li	a2,16
 592:	000ba583          	lw	a1,0(s7)
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e86080e7          	jalr	-378(ra) # 41e <printint>
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b7a5                	j	50c <vprintf+0x42>
 5a6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5a8:	008b8c13          	addi	s8,s7,8
 5ac:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5b0:	03000593          	li	a1,48
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e46080e7          	jalr	-442(ra) # 3fc <putc>
  putc(fd, 'x');
 5be:	07800593          	li	a1,120
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	e38080e7          	jalr	-456(ra) # 3fc <putc>
 5cc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ce:	00000b97          	auipc	s7,0x0
 5d2:	5aab8b93          	addi	s7,s7,1450 # b78 <digits>
 5d6:	03c9d793          	srli	a5,s3,0x3c
 5da:	97de                	add	a5,a5,s7
 5dc:	0007c583          	lbu	a1,0(a5)
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e1a080e7          	jalr	-486(ra) # 3fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ea:	0992                	slli	s3,s3,0x4
 5ec:	397d                	addiw	s2,s2,-1
 5ee:	fe0914e3          	bnez	s2,5d6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5f2:	8be2                	mv	s7,s8
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	6c02                	ld	s8,0(sp)
 5f8:	bf11                	j	50c <vprintf+0x42>
        s = va_arg(ap, char*);
 5fa:	008b8993          	addi	s3,s7,8
 5fe:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 602:	02090163          	beqz	s2,624 <vprintf+0x15a>
        while(*s != 0){
 606:	00094583          	lbu	a1,0(s2)
 60a:	c9a5                	beqz	a1,67a <vprintf+0x1b0>
          putc(fd, *s);
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	dee080e7          	jalr	-530(ra) # 3fc <putc>
          s++;
 616:	0905                	addi	s2,s2,1
        while(*s != 0){
 618:	00094583          	lbu	a1,0(s2)
 61c:	f9e5                	bnez	a1,60c <vprintf+0x142>
        s = va_arg(ap, char*);
 61e:	8bce                	mv	s7,s3
      state = 0;
 620:	4981                	li	s3,0
 622:	b5ed                	j	50c <vprintf+0x42>
          s = "(null)";
 624:	00000917          	auipc	s2,0x0
 628:	4c490913          	addi	s2,s2,1220 # ae8 <ithread_join+0x66>
        while(*s != 0){
 62c:	02800593          	li	a1,40
 630:	bff1                	j	60c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 632:	008b8913          	addi	s2,s7,8
 636:	000bc583          	lbu	a1,0(s7)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	dc0080e7          	jalr	-576(ra) # 3fc <putc>
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
 648:	b5d1                	j	50c <vprintf+0x42>
        putc(fd, c);
 64a:	02500593          	li	a1,37
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	dac080e7          	jalr	-596(ra) # 3fc <putc>
      state = 0;
 658:	4981                	li	s3,0
 65a:	bd4d                	j	50c <vprintf+0x42>
        putc(fd, '%');
 65c:	02500593          	li	a1,37
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	d9a080e7          	jalr	-614(ra) # 3fc <putc>
        putc(fd, c);
 66a:	85ca                	mv	a1,s2
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	d8e080e7          	jalr	-626(ra) # 3fc <putc>
      state = 0;
 676:	4981                	li	s3,0
 678:	bd51                	j	50c <vprintf+0x42>
        s = va_arg(ap, char*);
 67a:	8bce                	mv	s7,s3
      state = 0;
 67c:	4981                	li	s3,0
 67e:	b579                	j	50c <vprintf+0x42>
 680:	74e2                	ld	s1,56(sp)
 682:	79a2                	ld	s3,40(sp)
 684:	7a02                	ld	s4,32(sp)
 686:	6ae2                	ld	s5,24(sp)
 688:	6b42                	ld	s6,16(sp)
 68a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 68c:	60a6                	ld	ra,72(sp)
 68e:	6406                	ld	s0,64(sp)
 690:	7942                	ld	s2,48(sp)
 692:	6161                	addi	sp,sp,80
 694:	8082                	ret

0000000000000696 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 696:	715d                	addi	sp,sp,-80
 698:	ec06                	sd	ra,24(sp)
 69a:	e822                	sd	s0,16(sp)
 69c:	1000                	addi	s0,sp,32
 69e:	e010                	sd	a2,0(s0)
 6a0:	e414                	sd	a3,8(s0)
 6a2:	e818                	sd	a4,16(s0)
 6a4:	ec1c                	sd	a5,24(s0)
 6a6:	03043023          	sd	a6,32(s0)
 6aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ae:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b2:	8622                	mv	a2,s0
 6b4:	00000097          	auipc	ra,0x0
 6b8:	e16080e7          	jalr	-490(ra) # 4ca <vprintf>
}
 6bc:	60e2                	ld	ra,24(sp)
 6be:	6442                	ld	s0,16(sp)
 6c0:	6161                	addi	sp,sp,80
 6c2:	8082                	ret

00000000000006c4 <printf>:

void
printf(const char *fmt, ...)
{
 6c4:	711d                	addi	sp,sp,-96
 6c6:	ec06                	sd	ra,24(sp)
 6c8:	e822                	sd	s0,16(sp)
 6ca:	1000                	addi	s0,sp,32
 6cc:	e40c                	sd	a1,8(s0)
 6ce:	e810                	sd	a2,16(s0)
 6d0:	ec14                	sd	a3,24(s0)
 6d2:	f018                	sd	a4,32(s0)
 6d4:	f41c                	sd	a5,40(s0)
 6d6:	03043823          	sd	a6,48(s0)
 6da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6de:	00840613          	addi	a2,s0,8
 6e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e6:	85aa                	mv	a1,a0
 6e8:	4505                	li	a0,1
 6ea:	00000097          	auipc	ra,0x0
 6ee:	de0080e7          	jalr	-544(ra) # 4ca <vprintf>
}
 6f2:	60e2                	ld	ra,24(sp)
 6f4:	6442                	ld	s0,16(sp)
 6f6:	6125                	addi	sp,sp,96
 6f8:	8082                	ret

00000000000006fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fa:	1141                	addi	sp,sp,-16
 6fc:	e422                	sd	s0,8(sp)
 6fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 700:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 704:	00001797          	auipc	a5,0x1
 708:	90c7b783          	ld	a5,-1780(a5) # 1010 <freep>
 70c:	a02d                	j	736 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70e:	4618                	lw	a4,8(a2)
 710:	9f2d                	addw	a4,a4,a1
 712:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	6398                	ld	a4,0(a5)
 718:	6310                	ld	a2,0(a4)
 71a:	a83d                	j	758 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71c:	ff852703          	lw	a4,-8(a0)
 720:	9f31                	addw	a4,a4,a2
 722:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 724:	ff053683          	ld	a3,-16(a0)
 728:	a091                	j	76c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72a:	6398                	ld	a4,0(a5)
 72c:	00e7e463          	bltu	a5,a4,734 <free+0x3a>
 730:	00e6ea63          	bltu	a3,a4,744 <free+0x4a>
{
 734:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 736:	fed7fae3          	bgeu	a5,a3,72a <free+0x30>
 73a:	6398                	ld	a4,0(a5)
 73c:	00e6e463          	bltu	a3,a4,744 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 740:	fee7eae3          	bltu	a5,a4,734 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 744:	ff852583          	lw	a1,-8(a0)
 748:	6390                	ld	a2,0(a5)
 74a:	02059813          	slli	a6,a1,0x20
 74e:	01c85713          	srli	a4,a6,0x1c
 752:	9736                	add	a4,a4,a3
 754:	fae60de3          	beq	a2,a4,70e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 758:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 75c:	4790                	lw	a2,8(a5)
 75e:	02061593          	slli	a1,a2,0x20
 762:	01c5d713          	srli	a4,a1,0x1c
 766:	973e                	add	a4,a4,a5
 768:	fae68ae3          	beq	a3,a4,71c <free+0x22>
    p->s.ptr = bp->s.ptr;
 76c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 76e:	00001717          	auipc	a4,0x1
 772:	8af73123          	sd	a5,-1886(a4) # 1010 <freep>
}
 776:	6422                	ld	s0,8(sp)
 778:	0141                	addi	sp,sp,16
 77a:	8082                	ret

000000000000077c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77c:	7139                	addi	sp,sp,-64
 77e:	fc06                	sd	ra,56(sp)
 780:	f822                	sd	s0,48(sp)
 782:	f426                	sd	s1,40(sp)
 784:	ec4e                	sd	s3,24(sp)
 786:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 788:	02051493          	slli	s1,a0,0x20
 78c:	9081                	srli	s1,s1,0x20
 78e:	04bd                	addi	s1,s1,15
 790:	8091                	srli	s1,s1,0x4
 792:	0014899b          	addiw	s3,s1,1
 796:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 798:	00001517          	auipc	a0,0x1
 79c:	87853503          	ld	a0,-1928(a0) # 1010 <freep>
 7a0:	c915                	beqz	a0,7d4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a4:	4798                	lw	a4,8(a5)
 7a6:	08977e63          	bgeu	a4,s1,842 <malloc+0xc6>
 7aa:	f04a                	sd	s2,32(sp)
 7ac:	e852                	sd	s4,16(sp)
 7ae:	e456                	sd	s5,8(sp)
 7b0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b2:	8a4e                	mv	s4,s3
 7b4:	0009871b          	sext.w	a4,s3
 7b8:	6685                	lui	a3,0x1
 7ba:	00d77363          	bgeu	a4,a3,7c0 <malloc+0x44>
 7be:	6a05                	lui	s4,0x1
 7c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c8:	00001917          	auipc	s2,0x1
 7cc:	84890913          	addi	s2,s2,-1976 # 1010 <freep>
  if(p == (char*)-1)
 7d0:	5afd                	li	s5,-1
 7d2:	a091                	j	816 <malloc+0x9a>
 7d4:	f04a                	sd	s2,32(sp)
 7d6:	e852                	sd	s4,16(sp)
 7d8:	e456                	sd	s5,8(sp)
 7da:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7dc:	00001797          	auipc	a5,0x1
 7e0:	85478793          	addi	a5,a5,-1964 # 1030 <base>
 7e4:	00001717          	auipc	a4,0x1
 7e8:	82f73623          	sd	a5,-2004(a4) # 1010 <freep>
 7ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f2:	b7c1                	j	7b2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	e118                	sd	a4,0(a0)
 7f8:	a08d                	j	85a <malloc+0xde>
  hp->s.size = nu;
 7fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fe:	0541                	addi	a0,a0,16
 800:	00000097          	auipc	ra,0x0
 804:	efa080e7          	jalr	-262(ra) # 6fa <free>
  return freep;
 808:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 80c:	c13d                	beqz	a0,872 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 810:	4798                	lw	a4,8(a5)
 812:	02977463          	bgeu	a4,s1,83a <malloc+0xbe>
    if(p == freep)
 816:	00093703          	ld	a4,0(s2)
 81a:	853e                	mv	a0,a5
 81c:	fef719e3          	bne	a4,a5,80e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 820:	8552                	mv	a0,s4
 822:	00000097          	auipc	ra,0x0
 826:	b54080e7          	jalr	-1196(ra) # 376 <sbrk>
  if(p == (char*)-1)
 82a:	fd5518e3          	bne	a0,s5,7fa <malloc+0x7e>
        return 0;
 82e:	4501                	li	a0,0
 830:	7902                	ld	s2,32(sp)
 832:	6a42                	ld	s4,16(sp)
 834:	6aa2                	ld	s5,8(sp)
 836:	6b02                	ld	s6,0(sp)
 838:	a03d                	j	866 <malloc+0xea>
 83a:	7902                	ld	s2,32(sp)
 83c:	6a42                	ld	s4,16(sp)
 83e:	6aa2                	ld	s5,8(sp)
 840:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 842:	fae489e3          	beq	s1,a4,7f4 <malloc+0x78>
        p->s.size -= nunits;
 846:	4137073b          	subw	a4,a4,s3
 84a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84c:	02071693          	slli	a3,a4,0x20
 850:	01c6d713          	srli	a4,a3,0x1c
 854:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 856:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 85a:	00000717          	auipc	a4,0x0
 85e:	7aa73b23          	sd	a0,1974(a4) # 1010 <freep>
      return (void*)(p + 1);
 862:	01078513          	addi	a0,a5,16
  }
}
 866:	70e2                	ld	ra,56(sp)
 868:	7442                	ld	s0,48(sp)
 86a:	74a2                	ld	s1,40(sp)
 86c:	69e2                	ld	s3,24(sp)
 86e:	6121                	addi	sp,sp,64
 870:	8082                	ret
 872:	7902                	ld	s2,32(sp)
 874:	6a42                	ld	s4,16(sp)
 876:	6aa2                	ld	s5,8(sp)
 878:	6b02                	ld	s6,0(sp)
 87a:	b7f5                	j	866 <malloc+0xea>

000000000000087c <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 87c:	1141                	addi	sp,sp,-16
 87e:	e406                	sd	ra,8(sp)
 880:	e022                	sd	s0,0(sp)
 882:	0800                	addi	s0,sp,16
  thread_exit(status);
 884:	2501                	sext.w	a0,a0
 886:	00000097          	auipc	ra,0x0
 88a:	b20080e7          	jalr	-1248(ra) # 3a6 <thread_exit>
}
 88e:	60a2                	ld	ra,8(sp)
 890:	6402                	ld	s0,0(sp)
 892:	0141                	addi	sp,sp,16
 894:	8082                	ret

0000000000000896 <free_stacks>:
int free_stacks() {
 896:	7179                	addi	sp,sp,-48
 898:	f406                	sd	ra,40(sp)
 89a:	f022                	sd	s0,32(sp)
 89c:	ec26                	sd	s1,24(sp)
 89e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8a0:	00000797          	auipc	a5,0x0
 8a4:	7807a783          	lw	a5,1920(a5) # 1020 <num_threads>
 8a8:	04f05063          	blez	a5,8e8 <free_stacks+0x52>
 8ac:	e84a                	sd	s2,16(sp)
 8ae:	e44e                	sd	s3,8(sp)
 8b0:	4481                	li	s1,0
    free(stacks[i]);
 8b2:	00000997          	auipc	s3,0x0
 8b6:	76698993          	addi	s3,s3,1894 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8ba:	00000917          	auipc	s2,0x0
 8be:	76690913          	addi	s2,s2,1894 # 1020 <num_threads>
    free(stacks[i]);
 8c2:	0009b783          	ld	a5,0(s3)
 8c6:	00349713          	slli	a4,s1,0x3
 8ca:	97ba                	add	a5,a5,a4
 8cc:	6388                	ld	a0,0(a5)
 8ce:	00000097          	auipc	ra,0x0
 8d2:	e2c080e7          	jalr	-468(ra) # 6fa <free>
  for (int i = 0; i < num_threads; i++) {
 8d6:	0485                	addi	s1,s1,1
 8d8:	00092703          	lw	a4,0(s2)
 8dc:	0004879b          	sext.w	a5,s1
 8e0:	fee7c1e3          	blt	a5,a4,8c2 <free_stacks+0x2c>
 8e4:	6942                	ld	s2,16(sp)
 8e6:	69a2                	ld	s3,8(sp)
  free(stacks);
 8e8:	00000497          	auipc	s1,0x0
 8ec:	73048493          	addi	s1,s1,1840 # 1018 <stacks>
 8f0:	6088                	ld	a0,0(s1)
 8f2:	00000097          	auipc	ra,0x0
 8f6:	e08080e7          	jalr	-504(ra) # 6fa <free>
  stacks = 0;
 8fa:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8fe:	00000797          	auipc	a5,0x0
 902:	7207a123          	sw	zero,1826(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 906:	47a1                	li	a5,8
 908:	00000717          	auipc	a4,0x0
 90c:	6ef72c23          	sw	a5,1784(a4) # 1000 <max_stacks>
  threads_done = 0;
 910:	00000797          	auipc	a5,0x0
 914:	7007aa23          	sw	zero,1812(a5) # 1024 <threads_done>
}
 918:	4501                	li	a0,0
 91a:	70a2                	ld	ra,40(sp)
 91c:	7402                	ld	s0,32(sp)
 91e:	64e2                	ld	s1,24(sp)
 920:	6145                	addi	sp,sp,48
 922:	8082                	ret

0000000000000924 <expand_num_threads>:
int expand_num_threads() {
 924:	1101                	addi	sp,sp,-32
 926:	ec06                	sd	ra,24(sp)
 928:	e822                	sd	s0,16(sp)
 92a:	e426                	sd	s1,8(sp)
 92c:	e04a                	sd	s2,0(sp)
 92e:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 930:	00000797          	auipc	a5,0x0
 934:	6d078793          	addi	a5,a5,1744 # 1000 <max_stacks>
 938:	4388                	lw	a0,0(a5)
 93a:	0015151b          	slliw	a0,a0,0x1
 93e:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 940:	0035151b          	slliw	a0,a0,0x3
 944:	00000097          	auipc	ra,0x0
 948:	e38080e7          	jalr	-456(ra) # 77c <malloc>
 94c:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 94e:	00000617          	auipc	a2,0x0
 952:	6d262603          	lw	a2,1746(a2) # 1020 <num_threads>
 956:	00000497          	auipc	s1,0x0
 95a:	6c248493          	addi	s1,s1,1730 # 1018 <stacks>
 95e:	0036161b          	slliw	a2,a2,0x3
 962:	608c                	ld	a1,0(s1)
 964:	00000097          	auipc	ra,0x0
 968:	8d8080e7          	jalr	-1832(ra) # 23c <memmove>
  free(stacks);
 96c:	6088                	ld	a0,0(s1)
 96e:	00000097          	auipc	ra,0x0
 972:	d8c080e7          	jalr	-628(ra) # 6fa <free>
  stacks = new_stacks;
 976:	0124b023          	sd	s2,0(s1)
}
 97a:	4501                	li	a0,0
 97c:	60e2                	ld	ra,24(sp)
 97e:	6442                	ld	s0,16(sp)
 980:	64a2                	ld	s1,8(sp)
 982:	6902                	ld	s2,0(sp)
 984:	6105                	addi	sp,sp,32
 986:	8082                	ret

0000000000000988 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 988:	7179                	addi	sp,sp,-48
 98a:	f406                	sd	ra,40(sp)
 98c:	f022                	sd	s0,32(sp)
 98e:	e84a                	sd	s2,16(sp)
 990:	e44e                	sd	s3,8(sp)
 992:	1800                	addi	s0,sp,48
 994:	892a                	mv	s2,a0
 996:	89ae                	mv	s3,a1
  if (stacks == 0) {
 998:	00000797          	auipc	a5,0x0
 99c:	6807b783          	ld	a5,1664(a5) # 1018 <stacks>
 9a0:	c3d9                	beqz	a5,a26 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9a2:	00000797          	auipc	a5,0x0
 9a6:	65e7a783          	lw	a5,1630(a5) # 1000 <max_stacks>
 9aa:	00000717          	auipc	a4,0x0
 9ae:	67672703          	lw	a4,1654(a4) # 1020 <num_threads>
 9b2:	0af71363          	bne	a4,a5,a58 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9b6:	04000713          	li	a4,64
 9ba:	08e78563          	beq	a5,a4,a44 <ithread_create+0xbc>
 9be:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9c0:	00000097          	auipc	ra,0x0
 9c4:	f64080e7          	jalr	-156(ra) # 924 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9c8:	6505                	lui	a0,0x1
 9ca:	00000097          	auipc	ra,0x0
 9ce:	db2080e7          	jalr	-590(ra) # 77c <malloc>
 9d2:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9d4:	00000717          	auipc	a4,0x0
 9d8:	64c72703          	lw	a4,1612(a4) # 1020 <num_threads>
 9dc:	070e                	slli	a4,a4,0x3
 9de:	00000797          	auipc	a5,0x0
 9e2:	63a7b783          	ld	a5,1594(a5) # 1018 <stacks>
 9e6:	97ba                	add	a5,a5,a4
 9e8:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9ea:	00000697          	auipc	a3,0x0
 9ee:	e9268693          	addi	a3,a3,-366 # 87c <ithread_exit>
 9f2:	862a                	mv	a2,a0
 9f4:	85ce                	mv	a1,s3
 9f6:	854a                	mv	a0,s2
 9f8:	00000097          	auipc	ra,0x0
 9fc:	99e080e7          	jalr	-1634(ra) # 396 <create_thread>
 a00:	892a                	mv	s2,a0
  if (res != -1) {
 a02:	57fd                	li	a5,-1
 a04:	04f50c63          	beq	a0,a5,a5c <ithread_create+0xd4>
    num_threads++;
 a08:	00000717          	auipc	a4,0x0
 a0c:	61870713          	addi	a4,a4,1560 # 1020 <num_threads>
 a10:	431c                	lw	a5,0(a4)
 a12:	2785                	addiw	a5,a5,1
 a14:	c31c                	sw	a5,0(a4)
 a16:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a18:	854a                	mv	a0,s2
 a1a:	70a2                	ld	ra,40(sp)
 a1c:	7402                	ld	s0,32(sp)
 a1e:	6942                	ld	s2,16(sp)
 a20:	69a2                	ld	s3,8(sp)
 a22:	6145                	addi	sp,sp,48
 a24:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a26:	00000517          	auipc	a0,0x0
 a2a:	5da52503          	lw	a0,1498(a0) # 1000 <max_stacks>
 a2e:	0035151b          	slliw	a0,a0,0x3
 a32:	00000097          	auipc	ra,0x0
 a36:	d4a080e7          	jalr	-694(ra) # 77c <malloc>
 a3a:	00000797          	auipc	a5,0x0
 a3e:	5ca7bf23          	sd	a0,1502(a5) # 1018 <stacks>
 a42:	b785                	j	9a2 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a44:	00000517          	auipc	a0,0x0
 a48:	0ac50513          	addi	a0,a0,172 # af0 <ithread_join+0x6e>
 a4c:	00000097          	auipc	ra,0x0
 a50:	c78080e7          	jalr	-904(ra) # 6c4 <printf>
      return -1;
 a54:	597d                	li	s2,-1
 a56:	b7c9                	j	a18 <ithread_create+0x90>
 a58:	ec26                	sd	s1,24(sp)
 a5a:	b7bd                	j	9c8 <ithread_create+0x40>
    free(stack_ptr);
 a5c:	8526                	mv	a0,s1
 a5e:	00000097          	auipc	ra,0x0
 a62:	c9c080e7          	jalr	-868(ra) # 6fa <free>
    stacks[num_threads] = 0;
 a66:	00000717          	auipc	a4,0x0
 a6a:	5ba72703          	lw	a4,1466(a4) # 1020 <num_threads>
 a6e:	070e                	slli	a4,a4,0x3
 a70:	00000797          	auipc	a5,0x0
 a74:	5a87b783          	ld	a5,1448(a5) # 1018 <stacks>
 a78:	97ba                	add	a5,a5,a4
 a7a:	0007b023          	sd	zero,0(a5)
 a7e:	64e2                	ld	s1,24(sp)
 a80:	bf61                	j	a18 <ithread_create+0x90>

0000000000000a82 <ithread_join>:

int ithread_join(int thread_id) {
 a82:	1101                	addi	sp,sp,-32
 a84:	ec06                	sd	ra,24(sp)
 a86:	e822                	sd	s0,16(sp)
 a88:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a8a:	ff040793          	addi	a5,s0,-16
 a8e:	ffc7859b          	addiw	a1,a5,-4
 a92:	00000097          	auipc	ra,0x0
 a96:	90c080e7          	jalr	-1780(ra) # 39e <join_thread>
  threads_done++;
 a9a:	00000717          	auipc	a4,0x0
 a9e:	58a70713          	addi	a4,a4,1418 # 1024 <threads_done>
 aa2:	431c                	lw	a5,0(a4)
 aa4:	2785                	addiw	a5,a5,1
 aa6:	0007869b          	sext.w	a3,a5
 aaa:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 aac:	00000797          	auipc	a5,0x0
 ab0:	5747a783          	lw	a5,1396(a5) # 1020 <num_threads>
 ab4:	00d78863          	beq	a5,a3,ac4 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 ab8:	fec42503          	lw	a0,-20(s0)
 abc:	60e2                	ld	ra,24(sp)
 abe:	6442                	ld	s0,16(sp)
 ac0:	6105                	addi	sp,sp,32
 ac2:	8082                	ret
    free_stacks();
 ac4:	00000097          	auipc	ra,0x0
 ac8:	dd2080e7          	jalr	-558(ra) # 896 <free_stacks>
 acc:	b7f5                	j	ab8 <ithread_join+0x36>
