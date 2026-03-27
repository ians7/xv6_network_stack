
src/user/_ln:     file format elf64-littleriscv


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
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	02f50163          	beq	a0,a5,2c <main+0x2c>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	ac058593          	addi	a1,a1,-1344 # ad0 <ithread_join+0x54>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	676080e7          	jalr	1654(ra) # 690 <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2c4080e7          	jalr	708(ra) # 2e8 <exit>
  2c:	e426                	sd	s1,8(sp)
  2e:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  30:	698c                	ld	a1,16(a1)
  32:	6488                	ld	a0,8(s1)
  34:	00000097          	auipc	ra,0x0
  38:	314080e7          	jalr	788(ra) # 348 <link>
  3c:	00054763          	bltz	a0,4a <main+0x4a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	2a6080e7          	jalr	678(ra) # 2e8 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4a:	6894                	ld	a3,16(s1)
  4c:	6490                	ld	a2,8(s1)
  4e:	00001597          	auipc	a1,0x1
  52:	a9a58593          	addi	a1,a1,-1382 # ae8 <ithread_join+0x6c>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	638080e7          	jalr	1592(ra) # 690 <fprintf>
  60:	b7c5                	j	40 <main+0x40>

0000000000000062 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6a:	00000097          	auipc	ra,0x0
  6e:	f96080e7          	jalr	-106(ra) # 0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	00000097          	auipc	ra,0x0
  78:	274080e7          	jalr	628(ra) # 2e8 <exit>

000000000000007c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  82:	87aa                	mv	a5,a0
  84:	0585                	addi	a1,a1,1
  86:	0785                	addi	a5,a5,1
  88:	fff5c703          	lbu	a4,-1(a1)
  8c:	fee78fa3          	sb	a4,-1(a5)
  90:	fb75                	bnez	a4,84 <strcpy+0x8>
    ;
  return os;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret

0000000000000098 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  98:	1141                	addi	sp,sp,-16
  9a:	e422                	sd	s0,8(sp)
  9c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x1e>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x1e>
    p++, q++;
  ac:	0505                	addi	a0,a0,1
  ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strlen>:

uint
strlen(const char *s)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cf91                	beqz	a5,ea <strlen+0x26>
  d0:	0505                	addi	a0,a0,1
  d2:	87aa                	mv	a5,a0
  d4:	86be                	mv	a3,a5
  d6:	0785                	addi	a5,a5,1
  d8:	fff7c703          	lbu	a4,-1(a5)
  dc:	ff65                	bnez	a4,d4 <strlen+0x10>
  de:	40a6853b          	subw	a0,a3,a0
  e2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret
  for(n = 0; s[n]; n++)
  ea:	4501                	li	a0,0
  ec:	bfe5                	j	e4 <strlen+0x20>

00000000000000ee <memset>:

void*
memset(void *dst, int c, uint n)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f4:	ca19                	beqz	a2,10a <memset+0x1c>
  f6:	87aa                	mv	a5,a0
  f8:	1602                	slli	a2,a2,0x20
  fa:	9201                	srli	a2,a2,0x20
  fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 100:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 104:	0785                	addi	a5,a5,1
 106:	fee79de3          	bne	a5,a4,100 <memset+0x12>
  }
  return dst;
}
 10a:	6422                	ld	s0,8(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret

0000000000000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  for(; *s; s++)
 116:	00054783          	lbu	a5,0(a0)
 11a:	cb99                	beqz	a5,130 <strchr+0x20>
    if(*s == c)
 11c:	00f58763          	beq	a1,a5,12a <strchr+0x1a>
  for(; *s; s++)
 120:	0505                	addi	a0,a0,1
 122:	00054783          	lbu	a5,0(a0)
 126:	fbfd                	bnez	a5,11c <strchr+0xc>
      return (char*)s;
  return 0;
 128:	4501                	li	a0,0
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret
  return 0;
 130:	4501                	li	a0,0
 132:	bfe5                	j	12a <strchr+0x1a>

0000000000000134 <gets>:

char*
gets(char *buf, int max)
{
 134:	711d                	addi	sp,sp,-96
 136:	ec86                	sd	ra,88(sp)
 138:	e8a2                	sd	s0,80(sp)
 13a:	e4a6                	sd	s1,72(sp)
 13c:	e0ca                	sd	s2,64(sp)
 13e:	fc4e                	sd	s3,56(sp)
 140:	f852                	sd	s4,48(sp)
 142:	f456                	sd	s5,40(sp)
 144:	f05a                	sd	s6,32(sp)
 146:	ec5e                	sd	s7,24(sp)
 148:	1080                	addi	s0,sp,96
 14a:	8baa                	mv	s7,a0
 14c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14e:	892a                	mv	s2,a0
 150:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 152:	4aa9                	li	s5,10
 154:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 156:	89a6                	mv	s3,s1
 158:	2485                	addiw	s1,s1,1
 15a:	0344d863          	bge	s1,s4,18a <gets+0x56>
    cc = read(0, &c, 1);
 15e:	4605                	li	a2,1
 160:	faf40593          	addi	a1,s0,-81
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	19a080e7          	jalr	410(ra) # 300 <read>
    if(cc < 1)
 16e:	00a05e63          	blez	a0,18a <gets+0x56>
    buf[i++] = c;
 172:	faf44783          	lbu	a5,-81(s0)
 176:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17a:	01578763          	beq	a5,s5,188 <gets+0x54>
 17e:	0905                	addi	s2,s2,1
 180:	fd679be3          	bne	a5,s6,156 <gets+0x22>
    buf[i++] = c;
 184:	89a6                	mv	s3,s1
 186:	a011                	j	18a <gets+0x56>
 188:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18a:	99de                	add	s3,s3,s7
 18c:	00098023          	sb	zero,0(s3)
  return buf;
}
 190:	855e                	mv	a0,s7
 192:	60e6                	ld	ra,88(sp)
 194:	6446                	ld	s0,80(sp)
 196:	64a6                	ld	s1,72(sp)
 198:	6906                	ld	s2,64(sp)
 19a:	79e2                	ld	s3,56(sp)
 19c:	7a42                	ld	s4,48(sp)
 19e:	7aa2                	ld	s5,40(sp)
 1a0:	7b02                	ld	s6,32(sp)
 1a2:	6be2                	ld	s7,24(sp)
 1a4:	6125                	addi	sp,sp,96
 1a6:	8082                	ret

00000000000001a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a8:	1101                	addi	sp,sp,-32
 1aa:	ec06                	sd	ra,24(sp)
 1ac:	e822                	sd	s0,16(sp)
 1ae:	e04a                	sd	s2,0(sp)
 1b0:	1000                	addi	s0,sp,32
 1b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b4:	4581                	li	a1,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	172080e7          	jalr	370(ra) # 328 <open>
  if(fd < 0)
 1be:	02054663          	bltz	a0,1ea <stat+0x42>
 1c2:	e426                	sd	s1,8(sp)
 1c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c6:	85ca                	mv	a1,s2
 1c8:	00000097          	auipc	ra,0x0
 1cc:	178080e7          	jalr	376(ra) # 340 <fstat>
 1d0:	892a                	mv	s2,a0
  close(fd);
 1d2:	8526                	mv	a0,s1
 1d4:	00000097          	auipc	ra,0x0
 1d8:	13c080e7          	jalr	316(ra) # 310 <close>
  return r;
 1dc:	64a2                	ld	s1,8(sp)
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret
    return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfcd                	j	1de <stat+0x36>

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f4:	00054683          	lbu	a3,0(a0)
 1f8:	fd06879b          	addiw	a5,a3,-48
 1fc:	0ff7f793          	zext.b	a5,a5
 200:	4625                	li	a2,9
 202:	02f66863          	bltu	a2,a5,232 <atoi+0x44>
 206:	872a                	mv	a4,a0
  n = 0;
 208:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20a:	0705                	addi	a4,a4,1
 20c:	0025179b          	slliw	a5,a0,0x2
 210:	9fa9                	addw	a5,a5,a0
 212:	0017979b          	slliw	a5,a5,0x1
 216:	9fb5                	addw	a5,a5,a3
 218:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21c:	00074683          	lbu	a3,0(a4)
 220:	fd06879b          	addiw	a5,a3,-48
 224:	0ff7f793          	zext.b	a5,a5
 228:	fef671e3          	bgeu	a2,a5,20a <atoi+0x1c>
  return n;
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  n = 0;
 232:	4501                	li	a0,0
 234:	bfe5                	j	22c <atoi+0x3e>

0000000000000236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 236:	1141                	addi	sp,sp,-16
 238:	e422                	sd	s0,8(sp)
 23a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23c:	02b57463          	bgeu	a0,a1,264 <memmove+0x2e>
    while(n-- > 0)
 240:	00c05f63          	blez	a2,25e <memmove+0x28>
 244:	1602                	slli	a2,a2,0x20
 246:	9201                	srli	a2,a2,0x20
 248:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24c:	872a                	mv	a4,a0
      *dst++ = *src++;
 24e:	0585                	addi	a1,a1,1
 250:	0705                	addi	a4,a4,1
 252:	fff5c683          	lbu	a3,-1(a1)
 256:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25a:	fef71ae3          	bne	a4,a5,24e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
    dst += n;
 264:	00c50733          	add	a4,a0,a2
    src += n;
 268:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26a:	fec05ae3          	blez	a2,25e <memmove+0x28>
 26e:	fff6079b          	addiw	a5,a2,-1
 272:	1782                	slli	a5,a5,0x20
 274:	9381                	srli	a5,a5,0x20
 276:	fff7c793          	not	a5,a5
 27a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27c:	15fd                	addi	a1,a1,-1
 27e:	177d                	addi	a4,a4,-1
 280:	0005c683          	lbu	a3,0(a1)
 284:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x46>
 28c:	bfc9                	j	25e <memmove+0x28>

000000000000028e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 294:	ca05                	beqz	a2,2c4 <memcmp+0x36>
 296:	fff6069b          	addiw	a3,a2,-1
 29a:	1682                	slli	a3,a3,0x20
 29c:	9281                	srli	a3,a3,0x20
 29e:	0685                	addi	a3,a3,1
 2a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	0005c703          	lbu	a4,0(a1)
 2aa:	00e79863          	bne	a5,a4,2ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ae:	0505                	addi	a0,a0,1
    p2++;
 2b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b2:	fed518e3          	bne	a0,a3,2a2 <memcmp+0x14>
  }
  return 0;
 2b6:	4501                	li	a0,0
 2b8:	a019                	j	2be <memcmp+0x30>
      return *p1 - *p2;
 2ba:	40e7853b          	subw	a0,a5,a4
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <memcmp+0x30>

00000000000002c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d0:	00000097          	auipc	ra,0x0
 2d4:	f66080e7          	jalr	-154(ra) # 236 <memmove>
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e0:	4885                	li	a7,1
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e8:	4889                	li	a7,2
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f0:	488d                	li	a7,3
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f8:	4891                	li	a7,4
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <read>:
.global read
read:
 li a7, SYS_read
 300:	4895                	li	a7,5
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <write>:
.global write
write:
 li a7, SYS_write
 308:	48c1                	li	a7,16
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <close>:
.global close
close:
 li a7, SYS_close
 310:	48d5                	li	a7,21
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <kill>:
.global kill
kill:
 li a7, SYS_kill
 318:	4899                	li	a7,6
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exec>:
.global exec
exec:
 li a7, SYS_exec
 320:	489d                	li	a7,7
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <open>:
.global open
open:
 li a7, SYS_open
 328:	48bd                	li	a7,15
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 330:	48c5                	li	a7,17
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 338:	48c9                	li	a7,18
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 340:	48a1                	li	a7,8
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <link>:
.global link
link:
 li a7, SYS_link
 348:	48cd                	li	a7,19
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 350:	48d1                	li	a7,20
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 358:	48a5                	li	a7,9
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <dup>:
.global dup
dup:
 li a7, SYS_dup
 360:	48a9                	li	a7,10
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 368:	48ad                	li	a7,11
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 370:	48b1                	li	a7,12
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 378:	48b5                	li	a7,13
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 380:	48b9                	li	a7,14
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 388:	48d9                	li	a7,22
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 390:	48dd                	li	a7,23
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 398:	48e1                	li	a7,24
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3a0:	48e5                	li	a7,25
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3a8:	48e9                	li	a7,26
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3b0:	48ed                	li	a7,27
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3b8:	48f5                	li	a7,29
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <listen>:
.global listen
listen:
 li a7, SYS_listen
 3c0:	48f1                	li	a7,28
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3c8:	48f9                	li	a7,30
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <send>:
.global send
send:
 li a7, SYS_send
 3d0:	48fd                	li	a7,31
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <recv>:
.global recv
recv:
 li a7, SYS_recv
 3d8:	02000893          	li	a7,32
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 3e2:	02100893          	li	a7,33
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 3ec:	02200893          	li	a7,34
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f6:	1101                	addi	sp,sp,-32
 3f8:	ec06                	sd	ra,24(sp)
 3fa:	e822                	sd	s0,16(sp)
 3fc:	1000                	addi	s0,sp,32
 3fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 402:	4605                	li	a2,1
 404:	fef40593          	addi	a1,s0,-17
 408:	00000097          	auipc	ra,0x0
 40c:	f00080e7          	jalr	-256(ra) # 308 <write>
}
 410:	60e2                	ld	ra,24(sp)
 412:	6442                	ld	s0,16(sp)
 414:	6105                	addi	sp,sp,32
 416:	8082                	ret

0000000000000418 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 418:	7139                	addi	sp,sp,-64
 41a:	fc06                	sd	ra,56(sp)
 41c:	f822                	sd	s0,48(sp)
 41e:	f426                	sd	s1,40(sp)
 420:	0080                	addi	s0,sp,64
 422:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 424:	c299                	beqz	a3,42a <printint+0x12>
 426:	0805cb63          	bltz	a1,4bc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 42a:	2581                	sext.w	a1,a1
  neg = 0;
 42c:	4881                	li	a7,0
 42e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 432:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 434:	2601                	sext.w	a2,a2
 436:	00000517          	auipc	a0,0x0
 43a:	75a50513          	addi	a0,a0,1882 # b90 <digits>
 43e:	883a                	mv	a6,a4
 440:	2705                	addiw	a4,a4,1
 442:	02c5f7bb          	remuw	a5,a1,a2
 446:	1782                	slli	a5,a5,0x20
 448:	9381                	srli	a5,a5,0x20
 44a:	97aa                	add	a5,a5,a0
 44c:	0007c783          	lbu	a5,0(a5)
 450:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 454:	0005879b          	sext.w	a5,a1
 458:	02c5d5bb          	divuw	a1,a1,a2
 45c:	0685                	addi	a3,a3,1
 45e:	fec7f0e3          	bgeu	a5,a2,43e <printint+0x26>
  if(neg)
 462:	00088c63          	beqz	a7,47a <printint+0x62>
    buf[i++] = '-';
 466:	fd070793          	addi	a5,a4,-48
 46a:	00878733          	add	a4,a5,s0
 46e:	02d00793          	li	a5,45
 472:	fef70823          	sb	a5,-16(a4)
 476:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 47a:	02e05c63          	blez	a4,4b2 <printint+0x9a>
 47e:	f04a                	sd	s2,32(sp)
 480:	ec4e                	sd	s3,24(sp)
 482:	fc040793          	addi	a5,s0,-64
 486:	00e78933          	add	s2,a5,a4
 48a:	fff78993          	addi	s3,a5,-1
 48e:	99ba                	add	s3,s3,a4
 490:	377d                	addiw	a4,a4,-1
 492:	1702                	slli	a4,a4,0x20
 494:	9301                	srli	a4,a4,0x20
 496:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 49a:	fff94583          	lbu	a1,-1(s2)
 49e:	8526                	mv	a0,s1
 4a0:	00000097          	auipc	ra,0x0
 4a4:	f56080e7          	jalr	-170(ra) # 3f6 <putc>
  while(--i >= 0)
 4a8:	197d                	addi	s2,s2,-1
 4aa:	ff3918e3          	bne	s2,s3,49a <printint+0x82>
 4ae:	7902                	ld	s2,32(sp)
 4b0:	69e2                	ld	s3,24(sp)
}
 4b2:	70e2                	ld	ra,56(sp)
 4b4:	7442                	ld	s0,48(sp)
 4b6:	74a2                	ld	s1,40(sp)
 4b8:	6121                	addi	sp,sp,64
 4ba:	8082                	ret
    x = -xx;
 4bc:	40b005bb          	negw	a1,a1
    neg = 1;
 4c0:	4885                	li	a7,1
    x = -xx;
 4c2:	b7b5                	j	42e <printint+0x16>

00000000000004c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c4:	715d                	addi	sp,sp,-80
 4c6:	e486                	sd	ra,72(sp)
 4c8:	e0a2                	sd	s0,64(sp)
 4ca:	f84a                	sd	s2,48(sp)
 4cc:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ce:	0005c903          	lbu	s2,0(a1)
 4d2:	1a090a63          	beqz	s2,686 <vprintf+0x1c2>
 4d6:	fc26                	sd	s1,56(sp)
 4d8:	f44e                	sd	s3,40(sp)
 4da:	f052                	sd	s4,32(sp)
 4dc:	ec56                	sd	s5,24(sp)
 4de:	e85a                	sd	s6,16(sp)
 4e0:	e45e                	sd	s7,8(sp)
 4e2:	8aaa                	mv	s5,a0
 4e4:	8bb2                	mv	s7,a2
 4e6:	00158493          	addi	s1,a1,1
  state = 0;
 4ea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ec:	02500a13          	li	s4,37
 4f0:	4b55                	li	s6,21
 4f2:	a839                	j	510 <vprintf+0x4c>
        putc(fd, c);
 4f4:	85ca                	mv	a1,s2
 4f6:	8556                	mv	a0,s5
 4f8:	00000097          	auipc	ra,0x0
 4fc:	efe080e7          	jalr	-258(ra) # 3f6 <putc>
 500:	a019                	j	506 <vprintf+0x42>
    } else if(state == '%'){
 502:	01498d63          	beq	s3,s4,51c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 506:	0485                	addi	s1,s1,1
 508:	fff4c903          	lbu	s2,-1(s1)
 50c:	16090763          	beqz	s2,67a <vprintf+0x1b6>
    if(state == 0){
 510:	fe0999e3          	bnez	s3,502 <vprintf+0x3e>
      if(c == '%'){
 514:	ff4910e3          	bne	s2,s4,4f4 <vprintf+0x30>
        state = '%';
 518:	89d2                	mv	s3,s4
 51a:	b7f5                	j	506 <vprintf+0x42>
      if(c == 'd'){
 51c:	13490463          	beq	s2,s4,644 <vprintf+0x180>
 520:	f9d9079b          	addiw	a5,s2,-99
 524:	0ff7f793          	zext.b	a5,a5
 528:	12fb6763          	bltu	s6,a5,656 <vprintf+0x192>
 52c:	f9d9079b          	addiw	a5,s2,-99
 530:	0ff7f713          	zext.b	a4,a5
 534:	12eb6163          	bltu	s6,a4,656 <vprintf+0x192>
 538:	00271793          	slli	a5,a4,0x2
 53c:	00000717          	auipc	a4,0x0
 540:	5fc70713          	addi	a4,a4,1532 # b38 <ithread_join+0xbc>
 544:	97ba                	add	a5,a5,a4
 546:	439c                	lw	a5,0(a5)
 548:	97ba                	add	a5,a5,a4
 54a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 54c:	008b8913          	addi	s2,s7,8
 550:	4685                	li	a3,1
 552:	4629                	li	a2,10
 554:	000ba583          	lw	a1,0(s7)
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	ebe080e7          	jalr	-322(ra) # 418 <printint>
 562:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 564:	4981                	li	s3,0
 566:	b745                	j	506 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 568:	008b8913          	addi	s2,s7,8
 56c:	4681                	li	a3,0
 56e:	4629                	li	a2,10
 570:	000ba583          	lw	a1,0(s7)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	ea2080e7          	jalr	-350(ra) # 418 <printint>
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	b751                	j	506 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 584:	008b8913          	addi	s2,s7,8
 588:	4681                	li	a3,0
 58a:	4641                	li	a2,16
 58c:	000ba583          	lw	a1,0(s7)
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	e86080e7          	jalr	-378(ra) # 418 <printint>
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b7a5                	j	506 <vprintf+0x42>
 5a0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5a2:	008b8c13          	addi	s8,s7,8
 5a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5aa:	03000593          	li	a1,48
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e46080e7          	jalr	-442(ra) # 3f6 <putc>
  putc(fd, 'x');
 5b8:	07800593          	li	a1,120
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e38080e7          	jalr	-456(ra) # 3f6 <putc>
 5c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c8:	00000b97          	auipc	s7,0x0
 5cc:	5c8b8b93          	addi	s7,s7,1480 # b90 <digits>
 5d0:	03c9d793          	srli	a5,s3,0x3c
 5d4:	97de                	add	a5,a5,s7
 5d6:	0007c583          	lbu	a1,0(a5)
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e1a080e7          	jalr	-486(ra) # 3f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e4:	0992                	slli	s3,s3,0x4
 5e6:	397d                	addiw	s2,s2,-1
 5e8:	fe0914e3          	bnez	s2,5d0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5ec:	8be2                	mv	s7,s8
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	6c02                	ld	s8,0(sp)
 5f2:	bf11                	j	506 <vprintf+0x42>
        s = va_arg(ap, char*);
 5f4:	008b8993          	addi	s3,s7,8
 5f8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5fc:	02090163          	beqz	s2,61e <vprintf+0x15a>
        while(*s != 0){
 600:	00094583          	lbu	a1,0(s2)
 604:	c9a5                	beqz	a1,674 <vprintf+0x1b0>
          putc(fd, *s);
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	dee080e7          	jalr	-530(ra) # 3f6 <putc>
          s++;
 610:	0905                	addi	s2,s2,1
        while(*s != 0){
 612:	00094583          	lbu	a1,0(s2)
 616:	f9e5                	bnez	a1,606 <vprintf+0x142>
        s = va_arg(ap, char*);
 618:	8bce                	mv	s7,s3
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b5ed                	j	506 <vprintf+0x42>
          s = "(null)";
 61e:	00000917          	auipc	s2,0x0
 622:	4e290913          	addi	s2,s2,1250 # b00 <ithread_join+0x84>
        while(*s != 0){
 626:	02800593          	li	a1,40
 62a:	bff1                	j	606 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 62c:	008b8913          	addi	s2,s7,8
 630:	000bc583          	lbu	a1,0(s7)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	dc0080e7          	jalr	-576(ra) # 3f6 <putc>
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	b5d1                	j	506 <vprintf+0x42>
        putc(fd, c);
 644:	02500593          	li	a1,37
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	dac080e7          	jalr	-596(ra) # 3f6 <putc>
      state = 0;
 652:	4981                	li	s3,0
 654:	bd4d                	j	506 <vprintf+0x42>
        putc(fd, '%');
 656:	02500593          	li	a1,37
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	d9a080e7          	jalr	-614(ra) # 3f6 <putc>
        putc(fd, c);
 664:	85ca                	mv	a1,s2
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	d8e080e7          	jalr	-626(ra) # 3f6 <putc>
      state = 0;
 670:	4981                	li	s3,0
 672:	bd51                	j	506 <vprintf+0x42>
        s = va_arg(ap, char*);
 674:	8bce                	mv	s7,s3
      state = 0;
 676:	4981                	li	s3,0
 678:	b579                	j	506 <vprintf+0x42>
 67a:	74e2                	ld	s1,56(sp)
 67c:	79a2                	ld	s3,40(sp)
 67e:	7a02                	ld	s4,32(sp)
 680:	6ae2                	ld	s5,24(sp)
 682:	6b42                	ld	s6,16(sp)
 684:	6ba2                	ld	s7,8(sp)
    }
  }
}
 686:	60a6                	ld	ra,72(sp)
 688:	6406                	ld	s0,64(sp)
 68a:	7942                	ld	s2,48(sp)
 68c:	6161                	addi	sp,sp,80
 68e:	8082                	ret

0000000000000690 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 690:	715d                	addi	sp,sp,-80
 692:	ec06                	sd	ra,24(sp)
 694:	e822                	sd	s0,16(sp)
 696:	1000                	addi	s0,sp,32
 698:	e010                	sd	a2,0(s0)
 69a:	e414                	sd	a3,8(s0)
 69c:	e818                	sd	a4,16(s0)
 69e:	ec1c                	sd	a5,24(s0)
 6a0:	03043023          	sd	a6,32(s0)
 6a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ac:	8622                	mv	a2,s0
 6ae:	00000097          	auipc	ra,0x0
 6b2:	e16080e7          	jalr	-490(ra) # 4c4 <vprintf>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6161                	addi	sp,sp,80
 6bc:	8082                	ret

00000000000006be <printf>:

void
printf(const char *fmt, ...)
{
 6be:	711d                	addi	sp,sp,-96
 6c0:	ec06                	sd	ra,24(sp)
 6c2:	e822                	sd	s0,16(sp)
 6c4:	1000                	addi	s0,sp,32
 6c6:	e40c                	sd	a1,8(s0)
 6c8:	e810                	sd	a2,16(s0)
 6ca:	ec14                	sd	a3,24(s0)
 6cc:	f018                	sd	a4,32(s0)
 6ce:	f41c                	sd	a5,40(s0)
 6d0:	03043823          	sd	a6,48(s0)
 6d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d8:	00840613          	addi	a2,s0,8
 6dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e0:	85aa                	mv	a1,a0
 6e2:	4505                	li	a0,1
 6e4:	00000097          	auipc	ra,0x0
 6e8:	de0080e7          	jalr	-544(ra) # 4c4 <vprintf>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6125                	addi	sp,sp,96
 6f2:	8082                	ret

00000000000006f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f4:	1141                	addi	sp,sp,-16
 6f6:	e422                	sd	s0,8(sp)
 6f8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fe:	00001797          	auipc	a5,0x1
 702:	9127b783          	ld	a5,-1774(a5) # 1010 <freep>
 706:	a02d                	j	730 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 708:	4618                	lw	a4,8(a2)
 70a:	9f2d                	addw	a4,a4,a1
 70c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	6398                	ld	a4,0(a5)
 712:	6310                	ld	a2,0(a4)
 714:	a83d                	j	752 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 716:	ff852703          	lw	a4,-8(a0)
 71a:	9f31                	addw	a4,a4,a2
 71c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 71e:	ff053683          	ld	a3,-16(a0)
 722:	a091                	j	766 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	6398                	ld	a4,0(a5)
 726:	00e7e463          	bltu	a5,a4,72e <free+0x3a>
 72a:	00e6ea63          	bltu	a3,a4,73e <free+0x4a>
{
 72e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	fed7fae3          	bgeu	a5,a3,724 <free+0x30>
 734:	6398                	ld	a4,0(a5)
 736:	00e6e463          	bltu	a3,a4,73e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	fee7eae3          	bltu	a5,a4,72e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 73e:	ff852583          	lw	a1,-8(a0)
 742:	6390                	ld	a2,0(a5)
 744:	02059813          	slli	a6,a1,0x20
 748:	01c85713          	srli	a4,a6,0x1c
 74c:	9736                	add	a4,a4,a3
 74e:	fae60de3          	beq	a2,a4,708 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 752:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 756:	4790                	lw	a2,8(a5)
 758:	02061593          	slli	a1,a2,0x20
 75c:	01c5d713          	srli	a4,a1,0x1c
 760:	973e                	add	a4,a4,a5
 762:	fae68ae3          	beq	a3,a4,716 <free+0x22>
    p->s.ptr = bp->s.ptr;
 766:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 768:	00001717          	auipc	a4,0x1
 76c:	8af73423          	sd	a5,-1880(a4) # 1010 <freep>
}
 770:	6422                	ld	s0,8(sp)
 772:	0141                	addi	sp,sp,16
 774:	8082                	ret

0000000000000776 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 776:	7139                	addi	sp,sp,-64
 778:	fc06                	sd	ra,56(sp)
 77a:	f822                	sd	s0,48(sp)
 77c:	f426                	sd	s1,40(sp)
 77e:	ec4e                	sd	s3,24(sp)
 780:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	02051493          	slli	s1,a0,0x20
 786:	9081                	srli	s1,s1,0x20
 788:	04bd                	addi	s1,s1,15
 78a:	8091                	srli	s1,s1,0x4
 78c:	0014899b          	addiw	s3,s1,1
 790:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 792:	00001517          	auipc	a0,0x1
 796:	87e53503          	ld	a0,-1922(a0) # 1010 <freep>
 79a:	c915                	beqz	a0,7ce <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79e:	4798                	lw	a4,8(a5)
 7a0:	08977e63          	bgeu	a4,s1,83c <malloc+0xc6>
 7a4:	f04a                	sd	s2,32(sp)
 7a6:	e852                	sd	s4,16(sp)
 7a8:	e456                	sd	s5,8(sp)
 7aa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ac:	8a4e                	mv	s4,s3
 7ae:	0009871b          	sext.w	a4,s3
 7b2:	6685                	lui	a3,0x1
 7b4:	00d77363          	bgeu	a4,a3,7ba <malloc+0x44>
 7b8:	6a05                	lui	s4,0x1
 7ba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7be:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c2:	00001917          	auipc	s2,0x1
 7c6:	84e90913          	addi	s2,s2,-1970 # 1010 <freep>
  if(p == (char*)-1)
 7ca:	5afd                	li	s5,-1
 7cc:	a091                	j	810 <malloc+0x9a>
 7ce:	f04a                	sd	s2,32(sp)
 7d0:	e852                	sd	s4,16(sp)
 7d2:	e456                	sd	s5,8(sp)
 7d4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7d6:	00001797          	auipc	a5,0x1
 7da:	85a78793          	addi	a5,a5,-1958 # 1030 <base>
 7de:	00001717          	auipc	a4,0x1
 7e2:	82f73923          	sd	a5,-1998(a4) # 1010 <freep>
 7e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ec:	b7c1                	j	7ac <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7ee:	6398                	ld	a4,0(a5)
 7f0:	e118                	sd	a4,0(a0)
 7f2:	a08d                	j	854 <malloc+0xde>
  hp->s.size = nu;
 7f4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f8:	0541                	addi	a0,a0,16
 7fa:	00000097          	auipc	ra,0x0
 7fe:	efa080e7          	jalr	-262(ra) # 6f4 <free>
  return freep;
 802:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 806:	c13d                	beqz	a0,86c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80a:	4798                	lw	a4,8(a5)
 80c:	02977463          	bgeu	a4,s1,834 <malloc+0xbe>
    if(p == freep)
 810:	00093703          	ld	a4,0(s2)
 814:	853e                	mv	a0,a5
 816:	fef719e3          	bne	a4,a5,808 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 81a:	8552                	mv	a0,s4
 81c:	00000097          	auipc	ra,0x0
 820:	b54080e7          	jalr	-1196(ra) # 370 <sbrk>
  if(p == (char*)-1)
 824:	fd5518e3          	bne	a0,s5,7f4 <malloc+0x7e>
        return 0;
 828:	4501                	li	a0,0
 82a:	7902                	ld	s2,32(sp)
 82c:	6a42                	ld	s4,16(sp)
 82e:	6aa2                	ld	s5,8(sp)
 830:	6b02                	ld	s6,0(sp)
 832:	a03d                	j	860 <malloc+0xea>
 834:	7902                	ld	s2,32(sp)
 836:	6a42                	ld	s4,16(sp)
 838:	6aa2                	ld	s5,8(sp)
 83a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 83c:	fae489e3          	beq	s1,a4,7ee <malloc+0x78>
        p->s.size -= nunits;
 840:	4137073b          	subw	a4,a4,s3
 844:	c798                	sw	a4,8(a5)
        p += p->s.size;
 846:	02071693          	slli	a3,a4,0x20
 84a:	01c6d713          	srli	a4,a3,0x1c
 84e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 850:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 854:	00000717          	auipc	a4,0x0
 858:	7aa73e23          	sd	a0,1980(a4) # 1010 <freep>
      return (void*)(p + 1);
 85c:	01078513          	addi	a0,a5,16
  }
}
 860:	70e2                	ld	ra,56(sp)
 862:	7442                	ld	s0,48(sp)
 864:	74a2                	ld	s1,40(sp)
 866:	69e2                	ld	s3,24(sp)
 868:	6121                	addi	sp,sp,64
 86a:	8082                	ret
 86c:	7902                	ld	s2,32(sp)
 86e:	6a42                	ld	s4,16(sp)
 870:	6aa2                	ld	s5,8(sp)
 872:	6b02                	ld	s6,0(sp)
 874:	b7f5                	j	860 <malloc+0xea>

0000000000000876 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 876:	1141                	addi	sp,sp,-16
 878:	e406                	sd	ra,8(sp)
 87a:	e022                	sd	s0,0(sp)
 87c:	0800                	addi	s0,sp,16
  thread_exit(status);
 87e:	2501                	sext.w	a0,a0
 880:	00000097          	auipc	ra,0x0
 884:	b20080e7          	jalr	-1248(ra) # 3a0 <thread_exit>
}
 888:	60a2                	ld	ra,8(sp)
 88a:	6402                	ld	s0,0(sp)
 88c:	0141                	addi	sp,sp,16
 88e:	8082                	ret

0000000000000890 <free_stacks>:
int free_stacks() {
 890:	7179                	addi	sp,sp,-48
 892:	f406                	sd	ra,40(sp)
 894:	f022                	sd	s0,32(sp)
 896:	ec26                	sd	s1,24(sp)
 898:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 89a:	00000797          	auipc	a5,0x0
 89e:	7867a783          	lw	a5,1926(a5) # 1020 <num_threads>
 8a2:	04f05063          	blez	a5,8e2 <free_stacks+0x52>
 8a6:	e84a                	sd	s2,16(sp)
 8a8:	e44e                	sd	s3,8(sp)
 8aa:	4481                	li	s1,0
    free(stacks[i]);
 8ac:	00000997          	auipc	s3,0x0
 8b0:	76c98993          	addi	s3,s3,1900 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8b4:	00000917          	auipc	s2,0x0
 8b8:	76c90913          	addi	s2,s2,1900 # 1020 <num_threads>
    free(stacks[i]);
 8bc:	0009b783          	ld	a5,0(s3)
 8c0:	00349713          	slli	a4,s1,0x3
 8c4:	97ba                	add	a5,a5,a4
 8c6:	6388                	ld	a0,0(a5)
 8c8:	00000097          	auipc	ra,0x0
 8cc:	e2c080e7          	jalr	-468(ra) # 6f4 <free>
  for (int i = 0; i < num_threads; i++) {
 8d0:	0485                	addi	s1,s1,1
 8d2:	00092703          	lw	a4,0(s2)
 8d6:	0004879b          	sext.w	a5,s1
 8da:	fee7c1e3          	blt	a5,a4,8bc <free_stacks+0x2c>
 8de:	6942                	ld	s2,16(sp)
 8e0:	69a2                	ld	s3,8(sp)
  free(stacks);
 8e2:	00000497          	auipc	s1,0x0
 8e6:	73648493          	addi	s1,s1,1846 # 1018 <stacks>
 8ea:	6088                	ld	a0,0(s1)
 8ec:	00000097          	auipc	ra,0x0
 8f0:	e08080e7          	jalr	-504(ra) # 6f4 <free>
  stacks = 0;
 8f4:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 8f8:	00000797          	auipc	a5,0x0
 8fc:	7207a423          	sw	zero,1832(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 900:	47a1                	li	a5,8
 902:	00000717          	auipc	a4,0x0
 906:	6ef72f23          	sw	a5,1790(a4) # 1000 <max_stacks>
  threads_done = 0;
 90a:	00000797          	auipc	a5,0x0
 90e:	7007ad23          	sw	zero,1818(a5) # 1024 <threads_done>
}
 912:	4501                	li	a0,0
 914:	70a2                	ld	ra,40(sp)
 916:	7402                	ld	s0,32(sp)
 918:	64e2                	ld	s1,24(sp)
 91a:	6145                	addi	sp,sp,48
 91c:	8082                	ret

000000000000091e <expand_num_threads>:
int expand_num_threads() {
 91e:	1101                	addi	sp,sp,-32
 920:	ec06                	sd	ra,24(sp)
 922:	e822                	sd	s0,16(sp)
 924:	e426                	sd	s1,8(sp)
 926:	e04a                	sd	s2,0(sp)
 928:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 92a:	00000797          	auipc	a5,0x0
 92e:	6d678793          	addi	a5,a5,1750 # 1000 <max_stacks>
 932:	4388                	lw	a0,0(a5)
 934:	0015151b          	slliw	a0,a0,0x1
 938:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 93a:	0035151b          	slliw	a0,a0,0x3
 93e:	00000097          	auipc	ra,0x0
 942:	e38080e7          	jalr	-456(ra) # 776 <malloc>
 946:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 948:	00000617          	auipc	a2,0x0
 94c:	6d862603          	lw	a2,1752(a2) # 1020 <num_threads>
 950:	00000497          	auipc	s1,0x0
 954:	6c848493          	addi	s1,s1,1736 # 1018 <stacks>
 958:	0036161b          	slliw	a2,a2,0x3
 95c:	608c                	ld	a1,0(s1)
 95e:	00000097          	auipc	ra,0x0
 962:	8d8080e7          	jalr	-1832(ra) # 236 <memmove>
  free(stacks);
 966:	6088                	ld	a0,0(s1)
 968:	00000097          	auipc	ra,0x0
 96c:	d8c080e7          	jalr	-628(ra) # 6f4 <free>
  stacks = new_stacks;
 970:	0124b023          	sd	s2,0(s1)
}
 974:	4501                	li	a0,0
 976:	60e2                	ld	ra,24(sp)
 978:	6442                	ld	s0,16(sp)
 97a:	64a2                	ld	s1,8(sp)
 97c:	6902                	ld	s2,0(sp)
 97e:	6105                	addi	sp,sp,32
 980:	8082                	ret

0000000000000982 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 982:	7179                	addi	sp,sp,-48
 984:	f406                	sd	ra,40(sp)
 986:	f022                	sd	s0,32(sp)
 988:	e84a                	sd	s2,16(sp)
 98a:	e44e                	sd	s3,8(sp)
 98c:	1800                	addi	s0,sp,48
 98e:	892a                	mv	s2,a0
 990:	89ae                	mv	s3,a1
  if (stacks == 0) {
 992:	00000797          	auipc	a5,0x0
 996:	6867b783          	ld	a5,1670(a5) # 1018 <stacks>
 99a:	c3d9                	beqz	a5,a20 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 99c:	00000797          	auipc	a5,0x0
 9a0:	6647a783          	lw	a5,1636(a5) # 1000 <max_stacks>
 9a4:	00000717          	auipc	a4,0x0
 9a8:	67c72703          	lw	a4,1660(a4) # 1020 <num_threads>
 9ac:	0af71363          	bne	a4,a5,a52 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9b0:	04000713          	li	a4,64
 9b4:	08e78563          	beq	a5,a4,a3e <ithread_create+0xbc>
 9b8:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9ba:	00000097          	auipc	ra,0x0
 9be:	f64080e7          	jalr	-156(ra) # 91e <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9c2:	6505                	lui	a0,0x1
 9c4:	00000097          	auipc	ra,0x0
 9c8:	db2080e7          	jalr	-590(ra) # 776 <malloc>
 9cc:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9ce:	00000717          	auipc	a4,0x0
 9d2:	65272703          	lw	a4,1618(a4) # 1020 <num_threads>
 9d6:	070e                	slli	a4,a4,0x3
 9d8:	00000797          	auipc	a5,0x0
 9dc:	6407b783          	ld	a5,1600(a5) # 1018 <stacks>
 9e0:	97ba                	add	a5,a5,a4
 9e2:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 9e4:	00000697          	auipc	a3,0x0
 9e8:	e9268693          	addi	a3,a3,-366 # 876 <ithread_exit>
 9ec:	862a                	mv	a2,a0
 9ee:	85ce                	mv	a1,s3
 9f0:	854a                	mv	a0,s2
 9f2:	00000097          	auipc	ra,0x0
 9f6:	99e080e7          	jalr	-1634(ra) # 390 <create_thread>
 9fa:	892a                	mv	s2,a0
  if (res != -1) {
 9fc:	57fd                	li	a5,-1
 9fe:	04f50c63          	beq	a0,a5,a56 <ithread_create+0xd4>
    num_threads++;
 a02:	00000717          	auipc	a4,0x0
 a06:	61e70713          	addi	a4,a4,1566 # 1020 <num_threads>
 a0a:	431c                	lw	a5,0(a4)
 a0c:	2785                	addiw	a5,a5,1
 a0e:	c31c                	sw	a5,0(a4)
 a10:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a12:	854a                	mv	a0,s2
 a14:	70a2                	ld	ra,40(sp)
 a16:	7402                	ld	s0,32(sp)
 a18:	6942                	ld	s2,16(sp)
 a1a:	69a2                	ld	s3,8(sp)
 a1c:	6145                	addi	sp,sp,48
 a1e:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a20:	00000517          	auipc	a0,0x0
 a24:	5e052503          	lw	a0,1504(a0) # 1000 <max_stacks>
 a28:	0035151b          	slliw	a0,a0,0x3
 a2c:	00000097          	auipc	ra,0x0
 a30:	d4a080e7          	jalr	-694(ra) # 776 <malloc>
 a34:	00000797          	auipc	a5,0x0
 a38:	5ea7b223          	sd	a0,1508(a5) # 1018 <stacks>
 a3c:	b785                	j	99c <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a3e:	00000517          	auipc	a0,0x0
 a42:	0ca50513          	addi	a0,a0,202 # b08 <ithread_join+0x8c>
 a46:	00000097          	auipc	ra,0x0
 a4a:	c78080e7          	jalr	-904(ra) # 6be <printf>
      return -1;
 a4e:	597d                	li	s2,-1
 a50:	b7c9                	j	a12 <ithread_create+0x90>
 a52:	ec26                	sd	s1,24(sp)
 a54:	b7bd                	j	9c2 <ithread_create+0x40>
    free(stack_ptr);
 a56:	8526                	mv	a0,s1
 a58:	00000097          	auipc	ra,0x0
 a5c:	c9c080e7          	jalr	-868(ra) # 6f4 <free>
    stacks[num_threads] = 0;
 a60:	00000717          	auipc	a4,0x0
 a64:	5c072703          	lw	a4,1472(a4) # 1020 <num_threads>
 a68:	070e                	slli	a4,a4,0x3
 a6a:	00000797          	auipc	a5,0x0
 a6e:	5ae7b783          	ld	a5,1454(a5) # 1018 <stacks>
 a72:	97ba                	add	a5,a5,a4
 a74:	0007b023          	sd	zero,0(a5)
 a78:	64e2                	ld	s1,24(sp)
 a7a:	bf61                	j	a12 <ithread_create+0x90>

0000000000000a7c <ithread_join>:

int ithread_join(int thread_id) {
 a7c:	1101                	addi	sp,sp,-32
 a7e:	ec06                	sd	ra,24(sp)
 a80:	e822                	sd	s0,16(sp)
 a82:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 a84:	ff040793          	addi	a5,s0,-16
 a88:	ffc7859b          	addiw	a1,a5,-4
 a8c:	00000097          	auipc	ra,0x0
 a90:	90c080e7          	jalr	-1780(ra) # 398 <join_thread>
  threads_done++;
 a94:	00000717          	auipc	a4,0x0
 a98:	59070713          	addi	a4,a4,1424 # 1024 <threads_done>
 a9c:	431c                	lw	a5,0(a4)
 a9e:	2785                	addiw	a5,a5,1
 aa0:	0007869b          	sext.w	a3,a5
 aa4:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 aa6:	00000797          	auipc	a5,0x0
 aaa:	57a7a783          	lw	a5,1402(a5) # 1020 <num_threads>
 aae:	00d78863          	beq	a5,a3,abe <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 ab2:	fec42503          	lw	a0,-20(s0)
 ab6:	60e2                	ld	ra,24(sp)
 ab8:	6442                	ld	s0,16(sp)
 aba:	6105                	addi	sp,sp,32
 abc:	8082                	ret
    free_stacks();
 abe:	00000097          	auipc	ra,0x0
 ac2:	dd2080e7          	jalr	-558(ra) # 890 <free_stacks>
 ac6:	b7f5                	j	ab2 <ithread_join+0x36>
