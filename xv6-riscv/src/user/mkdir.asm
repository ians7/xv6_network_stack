
src/user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	340080e7          	jalr	832(ra) # 368 <mkdir>
  30:	02054663          	bltz	a0,5c <main+0x5c>
  for(i = 1; i < argc; i++){
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
  3a:	a81d                	j	70 <main+0x70>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	aa058593          	addi	a1,a1,-1376 # ae0 <ithread_join+0x4c>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	65e080e7          	jalr	1630(ra) # 6a8 <fprintf>
    exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	2ac080e7          	jalr	684(ra) # 300 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  5c:	6090                	ld	a2,0(s1)
  5e:	00001597          	auipc	a1,0x1
  62:	a9a58593          	addi	a1,a1,-1382 # af8 <ithread_join+0x64>
  66:	4509                	li	a0,2
  68:	00000097          	auipc	ra,0x0
  6c:	640080e7          	jalr	1600(ra) # 6a8 <fprintf>
      break;
    }
  }

  exit(0);
  70:	4501                	li	a0,0
  72:	00000097          	auipc	ra,0x0
  76:	28e080e7          	jalr	654(ra) # 300 <exit>

000000000000007a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  extern int main();
  main();
  82:	00000097          	auipc	ra,0x0
  86:	f7e080e7          	jalr	-130(ra) # 0 <main>
  exit(0);
  8a:	4501                	li	a0,0
  8c:	00000097          	auipc	ra,0x0
  90:	274080e7          	jalr	628(ra) # 300 <exit>

0000000000000094 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	87aa                	mv	a5,a0
  9c:	0585                	addi	a1,a1,1
  9e:	0785                	addi	a5,a5,1
  a0:	fff5c703          	lbu	a4,-1(a1)
  a4:	fee78fa3          	sb	a4,-1(a5)
  a8:	fb75                	bnez	a4,9c <strcpy+0x8>
    ;
  return os;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb91                	beqz	a5,ce <strcmp+0x1e>
  bc:	0005c703          	lbu	a4,0(a1)
  c0:	00f71763          	bne	a4,a5,ce <strcmp+0x1e>
    p++, q++;
  c4:	0505                	addi	a0,a0,1
  c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	fbe5                	bnez	a5,bc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ce:	0005c503          	lbu	a0,0(a1)
}
  d2:	40a7853b          	subw	a0,a5,a0
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e422                	sd	s0,8(sp)
  e0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	cf91                	beqz	a5,102 <strlen+0x26>
  e8:	0505                	addi	a0,a0,1
  ea:	87aa                	mv	a5,a0
  ec:	86be                	mv	a3,a5
  ee:	0785                	addi	a5,a5,1
  f0:	fff7c703          	lbu	a4,-1(a5)
  f4:	ff65                	bnez	a4,ec <strlen+0x10>
  f6:	40a6853b          	subw	a0,a3,a0
  fa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  fc:	6422                	ld	s0,8(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret
  for(n = 0; s[n]; n++)
 102:	4501                	li	a0,0
 104:	bfe5                	j	fc <strlen+0x20>

0000000000000106 <memset>:

void*
memset(void *dst, int c, uint n)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10c:	ca19                	beqz	a2,122 <memset+0x1c>
 10e:	87aa                	mv	a5,a0
 110:	1602                	slli	a2,a2,0x20
 112:	9201                	srli	a2,a2,0x20
 114:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 118:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11c:	0785                	addi	a5,a5,1
 11e:	fee79de3          	bne	a5,a4,118 <memset+0x12>
  }
  return dst;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strchr>:

char*
strchr(const char *s, char c)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb99                	beqz	a5,148 <strchr+0x20>
    if(*s == c)
 134:	00f58763          	beq	a1,a5,142 <strchr+0x1a>
  for(; *s; s++)
 138:	0505                	addi	a0,a0,1
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbfd                	bnez	a5,134 <strchr+0xc>
      return (char*)s;
  return 0;
 140:	4501                	li	a0,0
}
 142:	6422                	ld	s0,8(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret
  return 0;
 148:	4501                	li	a0,0
 14a:	bfe5                	j	142 <strchr+0x1a>

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
 160:	1080                	addi	s0,sp,96
 162:	8baa                	mv	s7,a0
 164:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 166:	892a                	mv	s2,a0
 168:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16a:	4aa9                	li	s5,10
 16c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 16e:	89a6                	mv	s3,s1
 170:	2485                	addiw	s1,s1,1
 172:	0344d863          	bge	s1,s4,1a2 <gets+0x56>
    cc = read(0, &c, 1);
 176:	4605                	li	a2,1
 178:	faf40593          	addi	a1,s0,-81
 17c:	4501                	li	a0,0
 17e:	00000097          	auipc	ra,0x0
 182:	19a080e7          	jalr	410(ra) # 318 <read>
    if(cc < 1)
 186:	00a05e63          	blez	a0,1a2 <gets+0x56>
    buf[i++] = c;
 18a:	faf44783          	lbu	a5,-81(s0)
 18e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 192:	01578763          	beq	a5,s5,1a0 <gets+0x54>
 196:	0905                	addi	s2,s2,1
 198:	fd679be3          	bne	a5,s6,16e <gets+0x22>
    buf[i++] = c;
 19c:	89a6                	mv	s3,s1
 19e:	a011                	j	1a2 <gets+0x56>
 1a0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a2:	99de                	add	s3,s3,s7
 1a4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a8:	855e                	mv	a0,s7
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6125                	addi	sp,sp,96
 1be:	8082                	ret

00000000000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	1101                	addi	sp,sp,-32
 1c2:	ec06                	sd	ra,24(sp)
 1c4:	e822                	sd	s0,16(sp)
 1c6:	e04a                	sd	s2,0(sp)
 1c8:	1000                	addi	s0,sp,32
 1ca:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cc:	4581                	li	a1,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	172080e7          	jalr	370(ra) # 340 <open>
  if(fd < 0)
 1d6:	02054663          	bltz	a0,202 <stat+0x42>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	00000097          	auipc	ra,0x0
 1e4:	178080e7          	jalr	376(ra) # 358 <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	13c080e7          	jalr	316(ra) # 328 <close>
  return r;
 1f4:	64a2                	ld	s1,8(sp)
}
 1f6:	854a                	mv	a0,s2
 1f8:	60e2                	ld	ra,24(sp)
 1fa:	6442                	ld	s0,16(sp)
 1fc:	6902                	ld	s2,0(sp)
 1fe:	6105                	addi	sp,sp,32
 200:	8082                	ret
    return -1;
 202:	597d                	li	s2,-1
 204:	bfcd                	j	1f6 <stat+0x36>

0000000000000206 <atoi>:

int
atoi(const char *s)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20c:	00054683          	lbu	a3,0(a0)
 210:	fd06879b          	addiw	a5,a3,-48
 214:	0ff7f793          	zext.b	a5,a5
 218:	4625                	li	a2,9
 21a:	02f66863          	bltu	a2,a5,24a <atoi+0x44>
 21e:	872a                	mv	a4,a0
  n = 0;
 220:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 222:	0705                	addi	a4,a4,1
 224:	0025179b          	slliw	a5,a0,0x2
 228:	9fa9                	addw	a5,a5,a0
 22a:	0017979b          	slliw	a5,a5,0x1
 22e:	9fb5                	addw	a5,a5,a3
 230:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 234:	00074683          	lbu	a3,0(a4)
 238:	fd06879b          	addiw	a5,a3,-48
 23c:	0ff7f793          	zext.b	a5,a5
 240:	fef671e3          	bgeu	a2,a5,222 <atoi+0x1c>
  return n;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  n = 0;
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <atoi+0x3e>

000000000000024e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 254:	02b57463          	bgeu	a0,a1,27c <memmove+0x2e>
    while(n-- > 0)
 258:	00c05f63          	blez	a2,276 <memmove+0x28>
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	addi	a1,a1,1
 268:	0705                	addi	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 272:	fef71ae3          	bne	a4,a5,266 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
    dst += n;
 27c:	00c50733          	add	a4,a0,a2
    src += n;
 280:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 282:	fec05ae3          	blez	a2,276 <memmove+0x28>
 286:	fff6079b          	addiw	a5,a2,-1
 28a:	1782                	slli	a5,a5,0x20
 28c:	9381                	srli	a5,a5,0x20
 28e:	fff7c793          	not	a5,a5
 292:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 294:	15fd                	addi	a1,a1,-1
 296:	177d                	addi	a4,a4,-1
 298:	0005c683          	lbu	a3,0(a1)
 29c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a0:	fee79ae3          	bne	a5,a4,294 <memmove+0x46>
 2a4:	bfc9                	j	276 <memmove+0x28>

00000000000002a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ac:	ca05                	beqz	a2,2dc <memcmp+0x36>
 2ae:	fff6069b          	addiw	a3,a2,-1
 2b2:	1682                	slli	a3,a3,0x20
 2b4:	9281                	srli	a3,a3,0x20
 2b6:	0685                	addi	a3,a3,1
 2b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00e79863          	bne	a5,a4,2d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c6:	0505                	addi	a0,a0,1
    p2++;
 2c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ca:	fed518e3          	bne	a0,a3,2ba <memcmp+0x14>
  }
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	a019                	j	2d6 <memcmp+0x30>
      return *p1 - *p2;
 2d2:	40e7853b          	subw	a0,a5,a4
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  return 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <memcmp+0x30>

00000000000002e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e8:	00000097          	auipc	ra,0x0
 2ec:	f66080e7          	jalr	-154(ra) # 24e <memmove>
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f8:	4885                	li	a7,1
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exit>:
.global exit
exit:
 li a7, SYS_exit
 300:	4889                	li	a7,2
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <wait>:
.global wait
wait:
 li a7, SYS_wait
 308:	488d                	li	a7,3
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 310:	4891                	li	a7,4
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <read>:
.global read
read:
 li a7, SYS_read
 318:	4895                	li	a7,5
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <write>:
.global write
write:
 li a7, SYS_write
 320:	48c1                	li	a7,16
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <close>:
.global close
close:
 li a7, SYS_close
 328:	48d5                	li	a7,21
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <kill>:
.global kill
kill:
 li a7, SYS_kill
 330:	4899                	li	a7,6
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exec>:
.global exec
exec:
 li a7, SYS_exec
 338:	489d                	li	a7,7
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <open>:
.global open
open:
 li a7, SYS_open
 340:	48bd                	li	a7,15
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 348:	48c5                	li	a7,17
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 350:	48c9                	li	a7,18
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 358:	48a1                	li	a7,8
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <link>:
.global link
link:
 li a7, SYS_link
 360:	48cd                	li	a7,19
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 368:	48d1                	li	a7,20
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 370:	48a5                	li	a7,9
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <dup>:
.global dup
dup:
 li a7, SYS_dup
 378:	48a9                	li	a7,10
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 380:	48ad                	li	a7,11
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 388:	48b1                	li	a7,12
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 390:	48b5                	li	a7,13
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 398:	48b9                	li	a7,14
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3a0:	48d9                	li	a7,22
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3a8:	48dd                	li	a7,23
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3b0:	48e1                	li	a7,24
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3b8:	48e5                	li	a7,25
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3c0:	48e9                	li	a7,26
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3c8:	48ed                	li	a7,27
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3d0:	48f5                	li	a7,29
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <listen>:
.global listen
listen:
 li a7, SYS_listen
 3d8:	48f1                	li	a7,28
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3e0:	48f9                	li	a7,30
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <send>:
.global send
send:
 li a7, SYS_send
 3e8:	48fd                	li	a7,31
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <recv>:
.global recv
recv:
 li a7, SYS_recv
 3f0:	02000893          	li	a7,32
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 3fa:	02100893          	li	a7,33
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 404:	02200893          	li	a7,34
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40e:	1101                	addi	sp,sp,-32
 410:	ec06                	sd	ra,24(sp)
 412:	e822                	sd	s0,16(sp)
 414:	1000                	addi	s0,sp,32
 416:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41a:	4605                	li	a2,1
 41c:	fef40593          	addi	a1,s0,-17
 420:	00000097          	auipc	ra,0x0
 424:	f00080e7          	jalr	-256(ra) # 320 <write>
}
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6105                	addi	sp,sp,32
 42e:	8082                	ret

0000000000000430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	7139                	addi	sp,sp,-64
 432:	fc06                	sd	ra,56(sp)
 434:	f822                	sd	s0,48(sp)
 436:	f426                	sd	s1,40(sp)
 438:	0080                	addi	s0,sp,64
 43a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43c:	c299                	beqz	a3,442 <printint+0x12>
 43e:	0805cb63          	bltz	a1,4d4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 442:	2581                	sext.w	a1,a1
  neg = 0;
 444:	4881                	li	a7,0
 446:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 44a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 44c:	2601                	sext.w	a2,a2
 44e:	00000517          	auipc	a0,0x0
 452:	75a50513          	addi	a0,a0,1882 # ba8 <digits>
 456:	883a                	mv	a6,a4
 458:	2705                	addiw	a4,a4,1
 45a:	02c5f7bb          	remuw	a5,a1,a2
 45e:	1782                	slli	a5,a5,0x20
 460:	9381                	srli	a5,a5,0x20
 462:	97aa                	add	a5,a5,a0
 464:	0007c783          	lbu	a5,0(a5)
 468:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 46c:	0005879b          	sext.w	a5,a1
 470:	02c5d5bb          	divuw	a1,a1,a2
 474:	0685                	addi	a3,a3,1
 476:	fec7f0e3          	bgeu	a5,a2,456 <printint+0x26>
  if(neg)
 47a:	00088c63          	beqz	a7,492 <printint+0x62>
    buf[i++] = '-';
 47e:	fd070793          	addi	a5,a4,-48
 482:	00878733          	add	a4,a5,s0
 486:	02d00793          	li	a5,45
 48a:	fef70823          	sb	a5,-16(a4)
 48e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 492:	02e05c63          	blez	a4,4ca <printint+0x9a>
 496:	f04a                	sd	s2,32(sp)
 498:	ec4e                	sd	s3,24(sp)
 49a:	fc040793          	addi	a5,s0,-64
 49e:	00e78933          	add	s2,a5,a4
 4a2:	fff78993          	addi	s3,a5,-1
 4a6:	99ba                	add	s3,s3,a4
 4a8:	377d                	addiw	a4,a4,-1
 4aa:	1702                	slli	a4,a4,0x20
 4ac:	9301                	srli	a4,a4,0x20
 4ae:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b2:	fff94583          	lbu	a1,-1(s2)
 4b6:	8526                	mv	a0,s1
 4b8:	00000097          	auipc	ra,0x0
 4bc:	f56080e7          	jalr	-170(ra) # 40e <putc>
  while(--i >= 0)
 4c0:	197d                	addi	s2,s2,-1
 4c2:	ff3918e3          	bne	s2,s3,4b2 <printint+0x82>
 4c6:	7902                	ld	s2,32(sp)
 4c8:	69e2                	ld	s3,24(sp)
}
 4ca:	70e2                	ld	ra,56(sp)
 4cc:	7442                	ld	s0,48(sp)
 4ce:	74a2                	ld	s1,40(sp)
 4d0:	6121                	addi	sp,sp,64
 4d2:	8082                	ret
    x = -xx;
 4d4:	40b005bb          	negw	a1,a1
    neg = 1;
 4d8:	4885                	li	a7,1
    x = -xx;
 4da:	b7b5                	j	446 <printint+0x16>

00000000000004dc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4dc:	715d                	addi	sp,sp,-80
 4de:	e486                	sd	ra,72(sp)
 4e0:	e0a2                	sd	s0,64(sp)
 4e2:	f84a                	sd	s2,48(sp)
 4e4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e6:	0005c903          	lbu	s2,0(a1)
 4ea:	1a090a63          	beqz	s2,69e <vprintf+0x1c2>
 4ee:	fc26                	sd	s1,56(sp)
 4f0:	f44e                	sd	s3,40(sp)
 4f2:	f052                	sd	s4,32(sp)
 4f4:	ec56                	sd	s5,24(sp)
 4f6:	e85a                	sd	s6,16(sp)
 4f8:	e45e                	sd	s7,8(sp)
 4fa:	8aaa                	mv	s5,a0
 4fc:	8bb2                	mv	s7,a2
 4fe:	00158493          	addi	s1,a1,1
  state = 0;
 502:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 504:	02500a13          	li	s4,37
 508:	4b55                	li	s6,21
 50a:	a839                	j	528 <vprintf+0x4c>
        putc(fd, c);
 50c:	85ca                	mv	a1,s2
 50e:	8556                	mv	a0,s5
 510:	00000097          	auipc	ra,0x0
 514:	efe080e7          	jalr	-258(ra) # 40e <putc>
 518:	a019                	j	51e <vprintf+0x42>
    } else if(state == '%'){
 51a:	01498d63          	beq	s3,s4,534 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 51e:	0485                	addi	s1,s1,1
 520:	fff4c903          	lbu	s2,-1(s1)
 524:	16090763          	beqz	s2,692 <vprintf+0x1b6>
    if(state == 0){
 528:	fe0999e3          	bnez	s3,51a <vprintf+0x3e>
      if(c == '%'){
 52c:	ff4910e3          	bne	s2,s4,50c <vprintf+0x30>
        state = '%';
 530:	89d2                	mv	s3,s4
 532:	b7f5                	j	51e <vprintf+0x42>
      if(c == 'd'){
 534:	13490463          	beq	s2,s4,65c <vprintf+0x180>
 538:	f9d9079b          	addiw	a5,s2,-99
 53c:	0ff7f793          	zext.b	a5,a5
 540:	12fb6763          	bltu	s6,a5,66e <vprintf+0x192>
 544:	f9d9079b          	addiw	a5,s2,-99
 548:	0ff7f713          	zext.b	a4,a5
 54c:	12eb6163          	bltu	s6,a4,66e <vprintf+0x192>
 550:	00271793          	slli	a5,a4,0x2
 554:	00000717          	auipc	a4,0x0
 558:	5fc70713          	addi	a4,a4,1532 # b50 <ithread_join+0xbc>
 55c:	97ba                	add	a5,a5,a4
 55e:	439c                	lw	a5,0(a5)
 560:	97ba                	add	a5,a5,a4
 562:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 564:	008b8913          	addi	s2,s7,8
 568:	4685                	li	a3,1
 56a:	4629                	li	a2,10
 56c:	000ba583          	lw	a1,0(s7)
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	ebe080e7          	jalr	-322(ra) # 430 <printint>
 57a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 57c:	4981                	li	s3,0
 57e:	b745                	j	51e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 580:	008b8913          	addi	s2,s7,8
 584:	4681                	li	a3,0
 586:	4629                	li	a2,10
 588:	000ba583          	lw	a1,0(s7)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	ea2080e7          	jalr	-350(ra) # 430 <printint>
 596:	8bca                	mv	s7,s2
      state = 0;
 598:	4981                	li	s3,0
 59a:	b751                	j	51e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 59c:	008b8913          	addi	s2,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4641                	li	a2,16
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e86080e7          	jalr	-378(ra) # 430 <printint>
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b7a5                	j	51e <vprintf+0x42>
 5b8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5ba:	008b8c13          	addi	s8,s7,8
 5be:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5c2:	03000593          	li	a1,48
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e46080e7          	jalr	-442(ra) # 40e <putc>
  putc(fd, 'x');
 5d0:	07800593          	li	a1,120
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	e38080e7          	jalr	-456(ra) # 40e <putc>
 5de:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e0:	00000b97          	auipc	s7,0x0
 5e4:	5c8b8b93          	addi	s7,s7,1480 # ba8 <digits>
 5e8:	03c9d793          	srli	a5,s3,0x3c
 5ec:	97de                	add	a5,a5,s7
 5ee:	0007c583          	lbu	a1,0(a5)
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e1a080e7          	jalr	-486(ra) # 40e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5fc:	0992                	slli	s3,s3,0x4
 5fe:	397d                	addiw	s2,s2,-1
 600:	fe0914e3          	bnez	s2,5e8 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 604:	8be2                	mv	s7,s8
      state = 0;
 606:	4981                	li	s3,0
 608:	6c02                	ld	s8,0(sp)
 60a:	bf11                	j	51e <vprintf+0x42>
        s = va_arg(ap, char*);
 60c:	008b8993          	addi	s3,s7,8
 610:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 614:	02090163          	beqz	s2,636 <vprintf+0x15a>
        while(*s != 0){
 618:	00094583          	lbu	a1,0(s2)
 61c:	c9a5                	beqz	a1,68c <vprintf+0x1b0>
          putc(fd, *s);
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	dee080e7          	jalr	-530(ra) # 40e <putc>
          s++;
 628:	0905                	addi	s2,s2,1
        while(*s != 0){
 62a:	00094583          	lbu	a1,0(s2)
 62e:	f9e5                	bnez	a1,61e <vprintf+0x142>
        s = va_arg(ap, char*);
 630:	8bce                	mv	s7,s3
      state = 0;
 632:	4981                	li	s3,0
 634:	b5ed                	j	51e <vprintf+0x42>
          s = "(null)";
 636:	00000917          	auipc	s2,0x0
 63a:	4e290913          	addi	s2,s2,1250 # b18 <ithread_join+0x84>
        while(*s != 0){
 63e:	02800593          	li	a1,40
 642:	bff1                	j	61e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 644:	008b8913          	addi	s2,s7,8
 648:	000bc583          	lbu	a1,0(s7)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	dc0080e7          	jalr	-576(ra) # 40e <putc>
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	b5d1                	j	51e <vprintf+0x42>
        putc(fd, c);
 65c:	02500593          	li	a1,37
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	dac080e7          	jalr	-596(ra) # 40e <putc>
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bd4d                	j	51e <vprintf+0x42>
        putc(fd, '%');
 66e:	02500593          	li	a1,37
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	d9a080e7          	jalr	-614(ra) # 40e <putc>
        putc(fd, c);
 67c:	85ca                	mv	a1,s2
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	d8e080e7          	jalr	-626(ra) # 40e <putc>
      state = 0;
 688:	4981                	li	s3,0
 68a:	bd51                	j	51e <vprintf+0x42>
        s = va_arg(ap, char*);
 68c:	8bce                	mv	s7,s3
      state = 0;
 68e:	4981                	li	s3,0
 690:	b579                	j	51e <vprintf+0x42>
 692:	74e2                	ld	s1,56(sp)
 694:	79a2                	ld	s3,40(sp)
 696:	7a02                	ld	s4,32(sp)
 698:	6ae2                	ld	s5,24(sp)
 69a:	6b42                	ld	s6,16(sp)
 69c:	6ba2                	ld	s7,8(sp)
    }
  }
}
 69e:	60a6                	ld	ra,72(sp)
 6a0:	6406                	ld	s0,64(sp)
 6a2:	7942                	ld	s2,48(sp)
 6a4:	6161                	addi	sp,sp,80
 6a6:	8082                	ret

00000000000006a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a8:	715d                	addi	sp,sp,-80
 6aa:	ec06                	sd	ra,24(sp)
 6ac:	e822                	sd	s0,16(sp)
 6ae:	1000                	addi	s0,sp,32
 6b0:	e010                	sd	a2,0(s0)
 6b2:	e414                	sd	a3,8(s0)
 6b4:	e818                	sd	a4,16(s0)
 6b6:	ec1c                	sd	a5,24(s0)
 6b8:	03043023          	sd	a6,32(s0)
 6bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c4:	8622                	mv	a2,s0
 6c6:	00000097          	auipc	ra,0x0
 6ca:	e16080e7          	jalr	-490(ra) # 4dc <vprintf>
}
 6ce:	60e2                	ld	ra,24(sp)
 6d0:	6442                	ld	s0,16(sp)
 6d2:	6161                	addi	sp,sp,80
 6d4:	8082                	ret

00000000000006d6 <printf>:

void
printf(const char *fmt, ...)
{
 6d6:	711d                	addi	sp,sp,-96
 6d8:	ec06                	sd	ra,24(sp)
 6da:	e822                	sd	s0,16(sp)
 6dc:	1000                	addi	s0,sp,32
 6de:	e40c                	sd	a1,8(s0)
 6e0:	e810                	sd	a2,16(s0)
 6e2:	ec14                	sd	a3,24(s0)
 6e4:	f018                	sd	a4,32(s0)
 6e6:	f41c                	sd	a5,40(s0)
 6e8:	03043823          	sd	a6,48(s0)
 6ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f0:	00840613          	addi	a2,s0,8
 6f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f8:	85aa                	mv	a1,a0
 6fa:	4505                	li	a0,1
 6fc:	00000097          	auipc	ra,0x0
 700:	de0080e7          	jalr	-544(ra) # 4dc <vprintf>
}
 704:	60e2                	ld	ra,24(sp)
 706:	6442                	ld	s0,16(sp)
 708:	6125                	addi	sp,sp,96
 70a:	8082                	ret

000000000000070c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70c:	1141                	addi	sp,sp,-16
 70e:	e422                	sd	s0,8(sp)
 710:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 712:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	00001797          	auipc	a5,0x1
 71a:	8fa7b783          	ld	a5,-1798(a5) # 1010 <freep>
 71e:	a02d                	j	748 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 720:	4618                	lw	a4,8(a2)
 722:	9f2d                	addw	a4,a4,a1
 724:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 728:	6398                	ld	a4,0(a5)
 72a:	6310                	ld	a2,0(a4)
 72c:	a83d                	j	76a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 72e:	ff852703          	lw	a4,-8(a0)
 732:	9f31                	addw	a4,a4,a2
 734:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 736:	ff053683          	ld	a3,-16(a0)
 73a:	a091                	j	77e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73c:	6398                	ld	a4,0(a5)
 73e:	00e7e463          	bltu	a5,a4,746 <free+0x3a>
 742:	00e6ea63          	bltu	a3,a4,756 <free+0x4a>
{
 746:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 748:	fed7fae3          	bgeu	a5,a3,73c <free+0x30>
 74c:	6398                	ld	a4,0(a5)
 74e:	00e6e463          	bltu	a3,a4,756 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 752:	fee7eae3          	bltu	a5,a4,746 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 756:	ff852583          	lw	a1,-8(a0)
 75a:	6390                	ld	a2,0(a5)
 75c:	02059813          	slli	a6,a1,0x20
 760:	01c85713          	srli	a4,a6,0x1c
 764:	9736                	add	a4,a4,a3
 766:	fae60de3          	beq	a2,a4,720 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 76a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 76e:	4790                	lw	a2,8(a5)
 770:	02061593          	slli	a1,a2,0x20
 774:	01c5d713          	srli	a4,a1,0x1c
 778:	973e                	add	a4,a4,a5
 77a:	fae68ae3          	beq	a3,a4,72e <free+0x22>
    p->s.ptr = bp->s.ptr;
 77e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 780:	00001717          	auipc	a4,0x1
 784:	88f73823          	sd	a5,-1904(a4) # 1010 <freep>
}
 788:	6422                	ld	s0,8(sp)
 78a:	0141                	addi	sp,sp,16
 78c:	8082                	ret

000000000000078e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 78e:	7139                	addi	sp,sp,-64
 790:	fc06                	sd	ra,56(sp)
 792:	f822                	sd	s0,48(sp)
 794:	f426                	sd	s1,40(sp)
 796:	ec4e                	sd	s3,24(sp)
 798:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79a:	02051493          	slli	s1,a0,0x20
 79e:	9081                	srli	s1,s1,0x20
 7a0:	04bd                	addi	s1,s1,15
 7a2:	8091                	srli	s1,s1,0x4
 7a4:	0014899b          	addiw	s3,s1,1
 7a8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7aa:	00001517          	auipc	a0,0x1
 7ae:	86653503          	ld	a0,-1946(a0) # 1010 <freep>
 7b2:	c915                	beqz	a0,7e6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b6:	4798                	lw	a4,8(a5)
 7b8:	08977e63          	bgeu	a4,s1,854 <malloc+0xc6>
 7bc:	f04a                	sd	s2,32(sp)
 7be:	e852                	sd	s4,16(sp)
 7c0:	e456                	sd	s5,8(sp)
 7c2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7c4:	8a4e                	mv	s4,s3
 7c6:	0009871b          	sext.w	a4,s3
 7ca:	6685                	lui	a3,0x1
 7cc:	00d77363          	bgeu	a4,a3,7d2 <malloc+0x44>
 7d0:	6a05                	lui	s4,0x1
 7d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7da:	00001917          	auipc	s2,0x1
 7de:	83690913          	addi	s2,s2,-1994 # 1010 <freep>
  if(p == (char*)-1)
 7e2:	5afd                	li	s5,-1
 7e4:	a091                	j	828 <malloc+0x9a>
 7e6:	f04a                	sd	s2,32(sp)
 7e8:	e852                	sd	s4,16(sp)
 7ea:	e456                	sd	s5,8(sp)
 7ec:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7ee:	00001797          	auipc	a5,0x1
 7f2:	84278793          	addi	a5,a5,-1982 # 1030 <base>
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80f73d23          	sd	a5,-2022(a4) # 1010 <freep>
 7fe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 800:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 804:	b7c1                	j	7c4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 806:	6398                	ld	a4,0(a5)
 808:	e118                	sd	a4,0(a0)
 80a:	a08d                	j	86c <malloc+0xde>
  hp->s.size = nu;
 80c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 810:	0541                	addi	a0,a0,16
 812:	00000097          	auipc	ra,0x0
 816:	efa080e7          	jalr	-262(ra) # 70c <free>
  return freep;
 81a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 81e:	c13d                	beqz	a0,884 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 822:	4798                	lw	a4,8(a5)
 824:	02977463          	bgeu	a4,s1,84c <malloc+0xbe>
    if(p == freep)
 828:	00093703          	ld	a4,0(s2)
 82c:	853e                	mv	a0,a5
 82e:	fef719e3          	bne	a4,a5,820 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 832:	8552                	mv	a0,s4
 834:	00000097          	auipc	ra,0x0
 838:	b54080e7          	jalr	-1196(ra) # 388 <sbrk>
  if(p == (char*)-1)
 83c:	fd5518e3          	bne	a0,s5,80c <malloc+0x7e>
        return 0;
 840:	4501                	li	a0,0
 842:	7902                	ld	s2,32(sp)
 844:	6a42                	ld	s4,16(sp)
 846:	6aa2                	ld	s5,8(sp)
 848:	6b02                	ld	s6,0(sp)
 84a:	a03d                	j	878 <malloc+0xea>
 84c:	7902                	ld	s2,32(sp)
 84e:	6a42                	ld	s4,16(sp)
 850:	6aa2                	ld	s5,8(sp)
 852:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 854:	fae489e3          	beq	s1,a4,806 <malloc+0x78>
        p->s.size -= nunits;
 858:	4137073b          	subw	a4,a4,s3
 85c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 85e:	02071693          	slli	a3,a4,0x20
 862:	01c6d713          	srli	a4,a3,0x1c
 866:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 868:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 86c:	00000717          	auipc	a4,0x0
 870:	7aa73223          	sd	a0,1956(a4) # 1010 <freep>
      return (void*)(p + 1);
 874:	01078513          	addi	a0,a5,16
  }
}
 878:	70e2                	ld	ra,56(sp)
 87a:	7442                	ld	s0,48(sp)
 87c:	74a2                	ld	s1,40(sp)
 87e:	69e2                	ld	s3,24(sp)
 880:	6121                	addi	sp,sp,64
 882:	8082                	ret
 884:	7902                	ld	s2,32(sp)
 886:	6a42                	ld	s4,16(sp)
 888:	6aa2                	ld	s5,8(sp)
 88a:	6b02                	ld	s6,0(sp)
 88c:	b7f5                	j	878 <malloc+0xea>

000000000000088e <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 88e:	1141                	addi	sp,sp,-16
 890:	e406                	sd	ra,8(sp)
 892:	e022                	sd	s0,0(sp)
 894:	0800                	addi	s0,sp,16
  thread_exit(status);
 896:	2501                	sext.w	a0,a0
 898:	00000097          	auipc	ra,0x0
 89c:	b20080e7          	jalr	-1248(ra) # 3b8 <thread_exit>
}
 8a0:	60a2                	ld	ra,8(sp)
 8a2:	6402                	ld	s0,0(sp)
 8a4:	0141                	addi	sp,sp,16
 8a6:	8082                	ret

00000000000008a8 <free_stacks>:
int free_stacks() {
 8a8:	7179                	addi	sp,sp,-48
 8aa:	f406                	sd	ra,40(sp)
 8ac:	f022                	sd	s0,32(sp)
 8ae:	ec26                	sd	s1,24(sp)
 8b0:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8b2:	00000797          	auipc	a5,0x0
 8b6:	76e7a783          	lw	a5,1902(a5) # 1020 <num_threads>
 8ba:	04f05063          	blez	a5,8fa <free_stacks+0x52>
 8be:	e84a                	sd	s2,16(sp)
 8c0:	e44e                	sd	s3,8(sp)
 8c2:	4481                	li	s1,0
    free(stacks[i]);
 8c4:	00000997          	auipc	s3,0x0
 8c8:	75498993          	addi	s3,s3,1876 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8cc:	00000917          	auipc	s2,0x0
 8d0:	75490913          	addi	s2,s2,1876 # 1020 <num_threads>
    free(stacks[i]);
 8d4:	0009b783          	ld	a5,0(s3)
 8d8:	00349713          	slli	a4,s1,0x3
 8dc:	97ba                	add	a5,a5,a4
 8de:	6388                	ld	a0,0(a5)
 8e0:	00000097          	auipc	ra,0x0
 8e4:	e2c080e7          	jalr	-468(ra) # 70c <free>
  for (int i = 0; i < num_threads; i++) {
 8e8:	0485                	addi	s1,s1,1
 8ea:	00092703          	lw	a4,0(s2)
 8ee:	0004879b          	sext.w	a5,s1
 8f2:	fee7c1e3          	blt	a5,a4,8d4 <free_stacks+0x2c>
 8f6:	6942                	ld	s2,16(sp)
 8f8:	69a2                	ld	s3,8(sp)
  free(stacks);
 8fa:	00000497          	auipc	s1,0x0
 8fe:	71e48493          	addi	s1,s1,1822 # 1018 <stacks>
 902:	6088                	ld	a0,0(s1)
 904:	00000097          	auipc	ra,0x0
 908:	e08080e7          	jalr	-504(ra) # 70c <free>
  stacks = 0;
 90c:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 910:	00000797          	auipc	a5,0x0
 914:	7007a823          	sw	zero,1808(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 918:	47a1                	li	a5,8
 91a:	00000717          	auipc	a4,0x0
 91e:	6ef72323          	sw	a5,1766(a4) # 1000 <max_stacks>
  threads_done = 0;
 922:	00000797          	auipc	a5,0x0
 926:	7007a123          	sw	zero,1794(a5) # 1024 <threads_done>
}
 92a:	4501                	li	a0,0
 92c:	70a2                	ld	ra,40(sp)
 92e:	7402                	ld	s0,32(sp)
 930:	64e2                	ld	s1,24(sp)
 932:	6145                	addi	sp,sp,48
 934:	8082                	ret

0000000000000936 <expand_num_threads>:
int expand_num_threads() {
 936:	1101                	addi	sp,sp,-32
 938:	ec06                	sd	ra,24(sp)
 93a:	e822                	sd	s0,16(sp)
 93c:	e426                	sd	s1,8(sp)
 93e:	e04a                	sd	s2,0(sp)
 940:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 942:	00000797          	auipc	a5,0x0
 946:	6be78793          	addi	a5,a5,1726 # 1000 <max_stacks>
 94a:	4388                	lw	a0,0(a5)
 94c:	0015151b          	slliw	a0,a0,0x1
 950:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 952:	0035151b          	slliw	a0,a0,0x3
 956:	00000097          	auipc	ra,0x0
 95a:	e38080e7          	jalr	-456(ra) # 78e <malloc>
 95e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 960:	00000617          	auipc	a2,0x0
 964:	6c062603          	lw	a2,1728(a2) # 1020 <num_threads>
 968:	00000497          	auipc	s1,0x0
 96c:	6b048493          	addi	s1,s1,1712 # 1018 <stacks>
 970:	0036161b          	slliw	a2,a2,0x3
 974:	608c                	ld	a1,0(s1)
 976:	00000097          	auipc	ra,0x0
 97a:	8d8080e7          	jalr	-1832(ra) # 24e <memmove>
  free(stacks);
 97e:	6088                	ld	a0,0(s1)
 980:	00000097          	auipc	ra,0x0
 984:	d8c080e7          	jalr	-628(ra) # 70c <free>
  stacks = new_stacks;
 988:	0124b023          	sd	s2,0(s1)
}
 98c:	4501                	li	a0,0
 98e:	60e2                	ld	ra,24(sp)
 990:	6442                	ld	s0,16(sp)
 992:	64a2                	ld	s1,8(sp)
 994:	6902                	ld	s2,0(sp)
 996:	6105                	addi	sp,sp,32
 998:	8082                	ret

000000000000099a <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 99a:	7179                	addi	sp,sp,-48
 99c:	f406                	sd	ra,40(sp)
 99e:	f022                	sd	s0,32(sp)
 9a0:	e84a                	sd	s2,16(sp)
 9a2:	e44e                	sd	s3,8(sp)
 9a4:	1800                	addi	s0,sp,48
 9a6:	892a                	mv	s2,a0
 9a8:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9aa:	00000797          	auipc	a5,0x0
 9ae:	66e7b783          	ld	a5,1646(a5) # 1018 <stacks>
 9b2:	c3d9                	beqz	a5,a38 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9b4:	00000797          	auipc	a5,0x0
 9b8:	64c7a783          	lw	a5,1612(a5) # 1000 <max_stacks>
 9bc:	00000717          	auipc	a4,0x0
 9c0:	66472703          	lw	a4,1636(a4) # 1020 <num_threads>
 9c4:	0af71363          	bne	a4,a5,a6a <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9c8:	04000713          	li	a4,64
 9cc:	08e78563          	beq	a5,a4,a56 <ithread_create+0xbc>
 9d0:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9d2:	00000097          	auipc	ra,0x0
 9d6:	f64080e7          	jalr	-156(ra) # 936 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9da:	6505                	lui	a0,0x1
 9dc:	00000097          	auipc	ra,0x0
 9e0:	db2080e7          	jalr	-590(ra) # 78e <malloc>
 9e4:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9e6:	00000717          	auipc	a4,0x0
 9ea:	63a72703          	lw	a4,1594(a4) # 1020 <num_threads>
 9ee:	070e                	slli	a4,a4,0x3
 9f0:	00000797          	auipc	a5,0x0
 9f4:	6287b783          	ld	a5,1576(a5) # 1018 <stacks>
 9f8:	97ba                	add	a5,a5,a4
 9fa:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9fc:	00000697          	auipc	a3,0x0
 a00:	e9268693          	addi	a3,a3,-366 # 88e <ithread_exit>
 a04:	862a                	mv	a2,a0
 a06:	85ce                	mv	a1,s3
 a08:	854a                	mv	a0,s2
 a0a:	00000097          	auipc	ra,0x0
 a0e:	99e080e7          	jalr	-1634(ra) # 3a8 <create_thread>
 a12:	892a                	mv	s2,a0
  if (res != -1) {
 a14:	57fd                	li	a5,-1
 a16:	04f50c63          	beq	a0,a5,a6e <ithread_create+0xd4>
    num_threads++;
 a1a:	00000717          	auipc	a4,0x0
 a1e:	60670713          	addi	a4,a4,1542 # 1020 <num_threads>
 a22:	431c                	lw	a5,0(a4)
 a24:	2785                	addiw	a5,a5,1
 a26:	c31c                	sw	a5,0(a4)
 a28:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a2a:	854a                	mv	a0,s2
 a2c:	70a2                	ld	ra,40(sp)
 a2e:	7402                	ld	s0,32(sp)
 a30:	6942                	ld	s2,16(sp)
 a32:	69a2                	ld	s3,8(sp)
 a34:	6145                	addi	sp,sp,48
 a36:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a38:	00000517          	auipc	a0,0x0
 a3c:	5c852503          	lw	a0,1480(a0) # 1000 <max_stacks>
 a40:	0035151b          	slliw	a0,a0,0x3
 a44:	00000097          	auipc	ra,0x0
 a48:	d4a080e7          	jalr	-694(ra) # 78e <malloc>
 a4c:	00000797          	auipc	a5,0x0
 a50:	5ca7b623          	sd	a0,1484(a5) # 1018 <stacks>
 a54:	b785                	j	9b4 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a56:	00000517          	auipc	a0,0x0
 a5a:	0ca50513          	addi	a0,a0,202 # b20 <ithread_join+0x8c>
 a5e:	00000097          	auipc	ra,0x0
 a62:	c78080e7          	jalr	-904(ra) # 6d6 <printf>
      return -1;
 a66:	597d                	li	s2,-1
 a68:	b7c9                	j	a2a <ithread_create+0x90>
 a6a:	ec26                	sd	s1,24(sp)
 a6c:	b7bd                	j	9da <ithread_create+0x40>
    free(stack_ptr);
 a6e:	8526                	mv	a0,s1
 a70:	00000097          	auipc	ra,0x0
 a74:	c9c080e7          	jalr	-868(ra) # 70c <free>
    stacks[num_threads] = 0;
 a78:	00000717          	auipc	a4,0x0
 a7c:	5a872703          	lw	a4,1448(a4) # 1020 <num_threads>
 a80:	070e                	slli	a4,a4,0x3
 a82:	00000797          	auipc	a5,0x0
 a86:	5967b783          	ld	a5,1430(a5) # 1018 <stacks>
 a8a:	97ba                	add	a5,a5,a4
 a8c:	0007b023          	sd	zero,0(a5)
 a90:	64e2                	ld	s1,24(sp)
 a92:	bf61                	j	a2a <ithread_create+0x90>

0000000000000a94 <ithread_join>:

int ithread_join(int thread_id) {
 a94:	1101                	addi	sp,sp,-32
 a96:	ec06                	sd	ra,24(sp)
 a98:	e822                	sd	s0,16(sp)
 a9a:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a9c:	ff040793          	addi	a5,s0,-16
 aa0:	ffc7859b          	addiw	a1,a5,-4
 aa4:	00000097          	auipc	ra,0x0
 aa8:	90c080e7          	jalr	-1780(ra) # 3b0 <join_thread>
  threads_done++;
 aac:	00000717          	auipc	a4,0x0
 ab0:	57870713          	addi	a4,a4,1400 # 1024 <threads_done>
 ab4:	431c                	lw	a5,0(a4)
 ab6:	2785                	addiw	a5,a5,1
 ab8:	0007869b          	sext.w	a3,a5
 abc:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 abe:	00000797          	auipc	a5,0x0
 ac2:	5627a783          	lw	a5,1378(a5) # 1020 <num_threads>
 ac6:	00d78863          	beq	a5,a3,ad6 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 aca:	fec42503          	lw	a0,-20(s0)
 ace:	60e2                	ld	ra,24(sp)
 ad0:	6442                	ld	s0,16(sp)
 ad2:	6105                	addi	sp,sp,32
 ad4:	8082                	ret
    free_stacks();
 ad6:	00000097          	auipc	ra,0x0
 ada:	dd2080e7          	jalr	-558(ra) # 8a8 <free_stacks>
 ade:	b7f5                	j	aca <ithread_join+0x36>
