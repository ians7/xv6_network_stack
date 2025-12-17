
user/_ln:     file format elf64-littleriscv


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
  14:	ae058593          	addi	a1,a1,-1312 # af0 <ithread_join+0x54>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	696080e7          	jalr	1686(ra) # 6b0 <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2e6080e7          	jalr	742(ra) # 30a <exit>
  2c:	e426                	sd	s1,8(sp)
  2e:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  30:	698c                	ld	a1,16(a1)
  32:	6488                	ld	a0,8(s1)
  34:	00000097          	auipc	ra,0x0
  38:	336080e7          	jalr	822(ra) # 36a <link>
  3c:	00054763          	bltz	a0,4a <main+0x4a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	2c8080e7          	jalr	712(ra) # 30a <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4a:	6894                	ld	a3,16(s1)
  4c:	6490                	ld	a2,8(s1)
  4e:	00001597          	auipc	a1,0x1
  52:	aba58593          	addi	a1,a1,-1350 # b08 <ithread_join+0x6c>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	658080e7          	jalr	1624(ra) # 6b0 <fprintf>
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
  78:	296080e7          	jalr	662(ra) # 30a <exit>

000000000000007c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  84:	87aa                	mv	a5,a0
  86:	0585                	addi	a1,a1,1
  88:	0785                	addi	a5,a5,1
  8a:	fff5c703          	lbu	a4,-1(a1)
  8e:	fee78fa3          	sb	a4,-1(a5)
  92:	fb75                	bnez	a4,86 <strcpy+0xa>
    ;
  return os;
}
  94:	60a2                	ld	ra,8(sp)
  96:	6402                	ld	s0,0(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret

000000000000009c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x20>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x20>
    p++, q++;
  b2:	0505                	addi	a0,a0,1
  b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	60a2                	ld	ra,8(sp)
  c6:	6402                	ld	s0,0(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d4:	00054783          	lbu	a5,0(a0)
  d8:	cf91                	beqz	a5,f4 <strlen+0x28>
  da:	00150793          	addi	a5,a0,1
  de:	86be                	mv	a3,a5
  e0:	0785                	addi	a5,a5,1
  e2:	fff7c703          	lbu	a4,-1(a5)
  e6:	ff65                	bnez	a4,de <strlen+0x12>
  e8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ec:	60a2                	ld	ra,8(sp)
  ee:	6402                	ld	s0,0(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret
  for(n = 0; s[n]; n++)
  f4:	4501                	li	a0,0
  f6:	bfdd                	j	ec <strlen+0x20>

00000000000000f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 100:	ca19                	beqz	a2,116 <memset+0x1e>
 102:	87aa                	mv	a5,a0
 104:	1602                	slli	a2,a2,0x20
 106:	9201                	srli	a2,a2,0x20
 108:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 110:	0785                	addi	a5,a5,1
 112:	fee79de3          	bne	a5,a4,10c <memset+0x14>
  }
  return dst;
}
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strchr>:

char*
strchr(const char *s, char c)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  for(; *s; s++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cf81                	beqz	a5,142 <strchr+0x24>
    if(*s == c)
 12c:	00f58763          	beq	a1,a5,13a <strchr+0x1c>
  for(; *s; s++)
 130:	0505                	addi	a0,a0,1
 132:	00054783          	lbu	a5,0(a0)
 136:	fbfd                	bnez	a5,12c <strchr+0xe>
      return (char*)s;
  return 0;
 138:	4501                	li	a0,0
}
 13a:	60a2                	ld	ra,8(sp)
 13c:	6402                	ld	s0,0(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret
  return 0;
 142:	4501                	li	a0,0
 144:	bfdd                	j	13a <strchr+0x1c>

0000000000000146 <gets>:

char*
gets(char *buf, int max)
{
 146:	711d                	addi	sp,sp,-96
 148:	ec86                	sd	ra,88(sp)
 14a:	e8a2                	sd	s0,80(sp)
 14c:	e4a6                	sd	s1,72(sp)
 14e:	e0ca                	sd	s2,64(sp)
 150:	fc4e                	sd	s3,56(sp)
 152:	f852                	sd	s4,48(sp)
 154:	f456                	sd	s5,40(sp)
 156:	f05a                	sd	s6,32(sp)
 158:	ec5e                	sd	s7,24(sp)
 15a:	e862                	sd	s8,16(sp)
 15c:	1080                	addi	s0,sp,96
 15e:	8baa                	mv	s7,a0
 160:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 162:	892a                	mv	s2,a0
 164:	4481                	li	s1,0
    cc = read(0, &c, 1);
 166:	faf40b13          	addi	s6,s0,-81
 16a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 16c:	8c26                	mv	s8,s1
 16e:	0014899b          	addiw	s3,s1,1
 172:	84ce                	mv	s1,s3
 174:	0349d663          	bge	s3,s4,1a0 <gets+0x5a>
    cc = read(0, &c, 1);
 178:	8656                	mv	a2,s5
 17a:	85da                	mv	a1,s6
 17c:	4501                	li	a0,0
 17e:	00000097          	auipc	ra,0x0
 182:	1a4080e7          	jalr	420(ra) # 322 <read>
    if(cc < 1)
 186:	00a05d63          	blez	a0,1a0 <gets+0x5a>
      break;
    buf[i++] = c;
 18a:	faf44783          	lbu	a5,-81(s0)
 18e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 192:	0905                	addi	s2,s2,1
 194:	ff678713          	addi	a4,a5,-10
 198:	c319                	beqz	a4,19e <gets+0x58>
 19a:	17cd                	addi	a5,a5,-13
 19c:	fbe1                	bnez	a5,16c <gets+0x26>
    buf[i++] = c;
 19e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1a0:	9c5e                	add	s8,s8,s7
 1a2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1a6:	855e                	mv	a0,s7
 1a8:	60e6                	ld	ra,88(sp)
 1aa:	6446                	ld	s0,80(sp)
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	6906                	ld	s2,64(sp)
 1b0:	79e2                	ld	s3,56(sp)
 1b2:	7a42                	ld	s4,48(sp)
 1b4:	7aa2                	ld	s5,40(sp)
 1b6:	7b02                	ld	s6,32(sp)
 1b8:	6be2                	ld	s7,24(sp)
 1ba:	6c42                	ld	s8,16(sp)
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
 1d2:	17c080e7          	jalr	380(ra) # 34a <open>
  if(fd < 0)
 1d6:	02054663          	bltz	a0,202 <stat+0x42>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	00000097          	auipc	ra,0x0
 1e4:	182080e7          	jalr	386(ra) # 362 <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	146080e7          	jalr	326(ra) # 332 <close>
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
 202:	57fd                	li	a5,-1
 204:	893e                	mv	s2,a5
 206:	bfc5                	j	1f6 <stat+0x36>

0000000000000208 <atoi>:

int
atoi(const char *s)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e406                	sd	ra,8(sp)
 20c:	e022                	sd	s0,0(sp)
 20e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 210:	00054683          	lbu	a3,0(a0)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	4625                	li	a2,9
 21e:	02f66963          	bltu	a2,a5,250 <atoi+0x48>
 222:	872a                	mv	a4,a0
  n = 0;
 224:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 226:	0705                	addi	a4,a4,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb5                	addw	a5,a5,a3
 234:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 238:	00074683          	lbu	a3,0(a4)
 23c:	fd06879b          	addiw	a5,a3,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	fef671e3          	bgeu	a2,a5,226 <atoi+0x1e>
  return n;
}
 248:	60a2                	ld	ra,8(sp)
 24a:	6402                	ld	s0,0(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
  n = 0;
 250:	4501                	li	a0,0
 252:	bfdd                	j	248 <atoi+0x40>

0000000000000254 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 254:	1141                	addi	sp,sp,-16
 256:	e406                	sd	ra,8(sp)
 258:	e022                	sd	s0,0(sp)
 25a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25c:	02b57563          	bgeu	a0,a1,286 <memmove+0x32>
    while(n-- > 0)
 260:	00c05f63          	blez	a2,27e <memmove+0x2a>
 264:	1602                	slli	a2,a2,0x20
 266:	9201                	srli	a2,a2,0x20
 268:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26c:	872a                	mv	a4,a0
      *dst++ = *src++;
 26e:	0585                	addi	a1,a1,1
 270:	0705                	addi	a4,a4,1
 272:	fff5c683          	lbu	a3,-1(a1)
 276:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 27a:	fee79ae3          	bne	a5,a4,26e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
    while(n-- > 0)
 286:	fec05ce3          	blez	a2,27e <memmove+0x2a>
    dst += n;
 28a:	00c50733          	add	a4,a0,a2
    src += n;
 28e:	95b2                	add	a1,a1,a2
 290:	fff6079b          	addiw	a5,a2,-1
 294:	1782                	slli	a5,a5,0x20
 296:	9381                	srli	a5,a5,0x20
 298:	fff7c793          	not	a5,a5
 29c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29e:	15fd                	addi	a1,a1,-1
 2a0:	177d                	addi	a4,a4,-1
 2a2:	0005c683          	lbu	a3,0(a1)
 2a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2aa:	fef71ae3          	bne	a4,a5,29e <memmove+0x4a>
 2ae:	bfc1                	j	27e <memmove+0x2a>

00000000000002b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b8:	c61d                	beqz	a2,2e6 <memcmp+0x36>
 2ba:	1602                	slli	a2,a2,0x20
 2bc:	9201                	srli	a2,a2,0x20
 2be:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	0005c703          	lbu	a4,0(a1)
 2ca:	00e79863          	bne	a5,a4,2da <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2ce:	0505                	addi	a0,a0,1
    p2++;
 2d0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d2:	fed518e3          	bne	a0,a3,2c2 <memcmp+0x12>
  }
  return 0;
 2d6:	4501                	li	a0,0
 2d8:	a019                	j	2de <memcmp+0x2e>
      return *p1 - *p2;
 2da:	40e7853b          	subw	a0,a5,a4
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	bfdd                	j	2de <memcmp+0x2e>

00000000000002ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f2:	00000097          	auipc	ra,0x0
 2f6:	f62080e7          	jalr	-158(ra) # 254 <memmove>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 302:	4885                	li	a7,1
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exit>:
.global exit
exit:
 li a7, SYS_exit
 30a:	4889                	li	a7,2
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <wait>:
.global wait
wait:
 li a7, SYS_wait
 312:	488d                	li	a7,3
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31a:	4891                	li	a7,4
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <read>:
.global read
read:
 li a7, SYS_read
 322:	4895                	li	a7,5
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <write>:
.global write
write:
 li a7, SYS_write
 32a:	48c1                	li	a7,16
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <close>:
.global close
close:
 li a7, SYS_close
 332:	48d5                	li	a7,21
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <kill>:
.global kill
kill:
 li a7, SYS_kill
 33a:	4899                	li	a7,6
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exec>:
.global exec
exec:
 li a7, SYS_exec
 342:	489d                	li	a7,7
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <open>:
.global open
open:
 li a7, SYS_open
 34a:	48bd                	li	a7,15
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 352:	48c5                	li	a7,17
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35a:	48c9                	li	a7,18
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 362:	48a1                	li	a7,8
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <link>:
.global link
link:
 li a7, SYS_link
 36a:	48cd                	li	a7,19
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 372:	48d1                	li	a7,20
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37a:	48a5                	li	a7,9
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <dup>:
.global dup
dup:
 li a7, SYS_dup
 382:	48a9                	li	a7,10
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38a:	48ad                	li	a7,11
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 392:	48b1                	li	a7,12
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 39a:	48b5                	li	a7,13
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a2:	48b9                	li	a7,14
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3aa:	48d9                	li	a7,22
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3b2:	48dd                	li	a7,23
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3ba:	48e1                	li	a7,24
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3c2:	48e5                	li	a7,25
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <socket>:
.global socket
socket:
 li a7, SYS_socket
 3ca:	48e9                	li	a7,26
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3d2:	48ed                	li	a7,27
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <accept>:
.global accept
accept:
 li a7, SYS_accept
 3da:	48f5                	li	a7,29
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <listen>:
.global listen
listen:
 li a7, SYS_listen
 3e2:	48f1                	li	a7,28
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <connect>:
.global connect
connect:
 li a7, SYS_connect
 3ea:	48f9                	li	a7,30
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <send>:
.global send
send:
 li a7, SYS_send
 3f2:	48fd                	li	a7,31
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <recv>:
.global recv
recv:
 li a7, SYS_recv
 3fa:	02000893          	li	a7,32
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 404:	02100893          	li	a7,33
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 40e:	02200893          	li	a7,34
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 418:	1101                	addi	sp,sp,-32
 41a:	ec06                	sd	ra,24(sp)
 41c:	e822                	sd	s0,16(sp)
 41e:	1000                	addi	s0,sp,32
 420:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 424:	4605                	li	a2,1
 426:	fef40593          	addi	a1,s0,-17
 42a:	00000097          	auipc	ra,0x0
 42e:	f00080e7          	jalr	-256(ra) # 32a <write>
}
 432:	60e2                	ld	ra,24(sp)
 434:	6442                	ld	s0,16(sp)
 436:	6105                	addi	sp,sp,32
 438:	8082                	ret

000000000000043a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43a:	7139                	addi	sp,sp,-64
 43c:	fc06                	sd	ra,56(sp)
 43e:	f822                	sd	s0,48(sp)
 440:	f04a                	sd	s2,32(sp)
 442:	ec4e                	sd	s3,24(sp)
 444:	0080                	addi	s0,sp,64
 446:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 448:	cad9                	beqz	a3,4de <printint+0xa4>
 44a:	01f5d79b          	srliw	a5,a1,0x1f
 44e:	cbc1                	beqz	a5,4de <printint+0xa4>
    neg = 1;
    x = -xx;
 450:	40b005bb          	negw	a1,a1
    neg = 1;
 454:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 456:	fc040993          	addi	s3,s0,-64
  neg = 0;
 45a:	86ce                	mv	a3,s3
  i = 0;
 45c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45e:	00000817          	auipc	a6,0x0
 462:	75280813          	addi	a6,a6,1874 # bb0 <digits>
 466:	88ba                	mv	a7,a4
 468:	0017051b          	addiw	a0,a4,1
 46c:	872a                	mv	a4,a0
 46e:	02c5f7bb          	remuw	a5,a1,a2
 472:	1782                	slli	a5,a5,0x20
 474:	9381                	srli	a5,a5,0x20
 476:	97c2                	add	a5,a5,a6
 478:	0007c783          	lbu	a5,0(a5)
 47c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 480:	87ae                	mv	a5,a1
 482:	02c5d5bb          	divuw	a1,a1,a2
 486:	0685                	addi	a3,a3,1
 488:	fcc7ffe3          	bgeu	a5,a2,466 <printint+0x2c>
  if(neg)
 48c:	00030c63          	beqz	t1,4a4 <printint+0x6a>
    buf[i++] = '-';
 490:	fd050793          	addi	a5,a0,-48
 494:	00878533          	add	a0,a5,s0
 498:	02d00793          	li	a5,45
 49c:	fef50823          	sb	a5,-16(a0)
 4a0:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4a4:	02e05763          	blez	a4,4d2 <printint+0x98>
 4a8:	f426                	sd	s1,40(sp)
 4aa:	377d                	addiw	a4,a4,-1
 4ac:	00e984b3          	add	s1,s3,a4
 4b0:	19fd                	addi	s3,s3,-1
 4b2:	99ba                	add	s3,s3,a4
 4b4:	1702                	slli	a4,a4,0x20
 4b6:	9301                	srli	a4,a4,0x20
 4b8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4bc:	0004c583          	lbu	a1,0(s1)
 4c0:	854a                	mv	a0,s2
 4c2:	00000097          	auipc	ra,0x0
 4c6:	f56080e7          	jalr	-170(ra) # 418 <putc>
  while(--i >= 0)
 4ca:	14fd                	addi	s1,s1,-1
 4cc:	ff3498e3          	bne	s1,s3,4bc <printint+0x82>
 4d0:	74a2                	ld	s1,40(sp)
}
 4d2:	70e2                	ld	ra,56(sp)
 4d4:	7442                	ld	s0,48(sp)
 4d6:	7902                	ld	s2,32(sp)
 4d8:	69e2                	ld	s3,24(sp)
 4da:	6121                	addi	sp,sp,64
 4dc:	8082                	ret
  neg = 0;
 4de:	4301                	li	t1,0
 4e0:	bf9d                	j	456 <printint+0x1c>

00000000000004e2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e2:	715d                	addi	sp,sp,-80
 4e4:	e486                	sd	ra,72(sp)
 4e6:	e0a2                	sd	s0,64(sp)
 4e8:	f84a                	sd	s2,48(sp)
 4ea:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ec:	0005c903          	lbu	s2,0(a1)
 4f0:	1a090b63          	beqz	s2,6a6 <vprintf+0x1c4>
 4f4:	fc26                	sd	s1,56(sp)
 4f6:	f44e                	sd	s3,40(sp)
 4f8:	f052                	sd	s4,32(sp)
 4fa:	ec56                	sd	s5,24(sp)
 4fc:	e85a                	sd	s6,16(sp)
 4fe:	e45e                	sd	s7,8(sp)
 500:	8aaa                	mv	s5,a0
 502:	8bb2                	mv	s7,a2
 504:	00158493          	addi	s1,a1,1
  state = 0;
 508:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 50a:	02500a13          	li	s4,37
 50e:	4b55                	li	s6,21
 510:	a839                	j	52e <vprintf+0x4c>
        putc(fd, c);
 512:	85ca                	mv	a1,s2
 514:	8556                	mv	a0,s5
 516:	00000097          	auipc	ra,0x0
 51a:	f02080e7          	jalr	-254(ra) # 418 <putc>
 51e:	a019                	j	524 <vprintf+0x42>
    } else if(state == '%'){
 520:	01498d63          	beq	s3,s4,53a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 524:	0485                	addi	s1,s1,1
 526:	fff4c903          	lbu	s2,-1(s1)
 52a:	16090863          	beqz	s2,69a <vprintf+0x1b8>
    if(state == 0){
 52e:	fe0999e3          	bnez	s3,520 <vprintf+0x3e>
      if(c == '%'){
 532:	ff4910e3          	bne	s2,s4,512 <vprintf+0x30>
        state = '%';
 536:	89d2                	mv	s3,s4
 538:	b7f5                	j	524 <vprintf+0x42>
      if(c == 'd'){
 53a:	13490563          	beq	s2,s4,664 <vprintf+0x182>
 53e:	f9d9079b          	addiw	a5,s2,-99
 542:	0ff7f793          	zext.b	a5,a5
 546:	12fb6863          	bltu	s6,a5,676 <vprintf+0x194>
 54a:	f9d9079b          	addiw	a5,s2,-99
 54e:	0ff7f713          	zext.b	a4,a5
 552:	12eb6263          	bltu	s6,a4,676 <vprintf+0x194>
 556:	00271793          	slli	a5,a4,0x2
 55a:	00000717          	auipc	a4,0x0
 55e:	5fe70713          	addi	a4,a4,1534 # b58 <ithread_join+0xbc>
 562:	97ba                	add	a5,a5,a4
 564:	439c                	lw	a5,0(a5)
 566:	97ba                	add	a5,a5,a4
 568:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 56a:	008b8913          	addi	s2,s7,8
 56e:	4685                	li	a3,1
 570:	4629                	li	a2,10
 572:	000ba583          	lw	a1,0(s7)
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	ec2080e7          	jalr	-318(ra) # 43a <printint>
 580:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 582:	4981                	li	s3,0
 584:	b745                	j	524 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 586:	008b8913          	addi	s2,s7,8
 58a:	4681                	li	a3,0
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	ea6080e7          	jalr	-346(ra) # 43a <printint>
 59c:	8bca                	mv	s7,s2
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b751                	j	524 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5a2:	008b8913          	addi	s2,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4641                	li	a2,16
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e8a080e7          	jalr	-374(ra) # 43a <printint>
 5b8:	8bca                	mv	s7,s2
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b7a5                	j	524 <vprintf+0x42>
 5be:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5c0:	008b8793          	addi	a5,s7,8
 5c4:	8c3e                	mv	s8,a5
 5c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ca:	03000593          	li	a1,48
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e48080e7          	jalr	-440(ra) # 418 <putc>
  putc(fd, 'x');
 5d8:	07800593          	li	a1,120
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	e3a080e7          	jalr	-454(ra) # 418 <putc>
 5e6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e8:	00000b97          	auipc	s7,0x0
 5ec:	5c8b8b93          	addi	s7,s7,1480 # bb0 <digits>
 5f0:	03c9d793          	srli	a5,s3,0x3c
 5f4:	97de                	add	a5,a5,s7
 5f6:	0007c583          	lbu	a1,0(a5)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e1c080e7          	jalr	-484(ra) # 418 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 604:	0992                	slli	s3,s3,0x4
 606:	397d                	addiw	s2,s2,-1
 608:	fe0914e3          	bnez	s2,5f0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 60c:	8be2                	mv	s7,s8
      state = 0;
 60e:	4981                	li	s3,0
 610:	6c02                	ld	s8,0(sp)
 612:	bf09                	j	524 <vprintf+0x42>
        s = va_arg(ap, char*);
 614:	008b8993          	addi	s3,s7,8
 618:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 61c:	02090163          	beqz	s2,63e <vprintf+0x15c>
        while(*s != 0){
 620:	00094583          	lbu	a1,0(s2)
 624:	c9a5                	beqz	a1,694 <vprintf+0x1b2>
          putc(fd, *s);
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	df0080e7          	jalr	-528(ra) # 418 <putc>
          s++;
 630:	0905                	addi	s2,s2,1
        while(*s != 0){
 632:	00094583          	lbu	a1,0(s2)
 636:	f9e5                	bnez	a1,626 <vprintf+0x144>
        s = va_arg(ap, char*);
 638:	8bce                	mv	s7,s3
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b5e5                	j	524 <vprintf+0x42>
          s = "(null)";
 63e:	00000917          	auipc	s2,0x0
 642:	4e290913          	addi	s2,s2,1250 # b20 <ithread_join+0x84>
        while(*s != 0){
 646:	02800593          	li	a1,40
 64a:	bff1                	j	626 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 64c:	008b8913          	addi	s2,s7,8
 650:	000bc583          	lbu	a1,0(s7)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	dc2080e7          	jalr	-574(ra) # 418 <putc>
 65e:	8bca                	mv	s7,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	b5c9                	j	524 <vprintf+0x42>
        putc(fd, c);
 664:	02500593          	li	a1,37
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	dae080e7          	jalr	-594(ra) # 418 <putc>
      state = 0;
 672:	4981                	li	s3,0
 674:	bd45                	j	524 <vprintf+0x42>
        putc(fd, '%');
 676:	02500593          	li	a1,37
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	d9c080e7          	jalr	-612(ra) # 418 <putc>
        putc(fd, c);
 684:	85ca                	mv	a1,s2
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	d90080e7          	jalr	-624(ra) # 418 <putc>
      state = 0;
 690:	4981                	li	s3,0
 692:	bd49                	j	524 <vprintf+0x42>
        s = va_arg(ap, char*);
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	b571                	j	524 <vprintf+0x42>
 69a:	74e2                	ld	s1,56(sp)
 69c:	79a2                	ld	s3,40(sp)
 69e:	7a02                	ld	s4,32(sp)
 6a0:	6ae2                	ld	s5,24(sp)
 6a2:	6b42                	ld	s6,16(sp)
 6a4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6a6:	60a6                	ld	ra,72(sp)
 6a8:	6406                	ld	s0,64(sp)
 6aa:	7942                	ld	s2,48(sp)
 6ac:	6161                	addi	sp,sp,80
 6ae:	8082                	ret

00000000000006b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b0:	715d                	addi	sp,sp,-80
 6b2:	ec06                	sd	ra,24(sp)
 6b4:	e822                	sd	s0,16(sp)
 6b6:	1000                	addi	s0,sp,32
 6b8:	e010                	sd	a2,0(s0)
 6ba:	e414                	sd	a3,8(s0)
 6bc:	e818                	sd	a4,16(s0)
 6be:	ec1c                	sd	a5,24(s0)
 6c0:	03043023          	sd	a6,32(s0)
 6c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c8:	8622                	mv	a2,s0
 6ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e14080e7          	jalr	-492(ra) # 4e2 <vprintf>
}
 6d6:	60e2                	ld	ra,24(sp)
 6d8:	6442                	ld	s0,16(sp)
 6da:	6161                	addi	sp,sp,80
 6dc:	8082                	ret

00000000000006de <printf>:

void
printf(const char *fmt, ...)
{
 6de:	711d                	addi	sp,sp,-96
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	addi	s0,sp,32
 6e6:	e40c                	sd	a1,8(s0)
 6e8:	e810                	sd	a2,16(s0)
 6ea:	ec14                	sd	a3,24(s0)
 6ec:	f018                	sd	a4,32(s0)
 6ee:	f41c                	sd	a5,40(s0)
 6f0:	03043823          	sd	a6,48(s0)
 6f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f8:	00840613          	addi	a2,s0,8
 6fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 700:	85aa                	mv	a1,a0
 702:	4505                	li	a0,1
 704:	00000097          	auipc	ra,0x0
 708:	dde080e7          	jalr	-546(ra) # 4e2 <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6125                	addi	sp,sp,96
 712:	8082                	ret

0000000000000714 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 714:	1141                	addi	sp,sp,-16
 716:	e406                	sd	ra,8(sp)
 718:	e022                	sd	s0,0(sp)
 71a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 720:	00001797          	auipc	a5,0x1
 724:	df07b783          	ld	a5,-528(a5) # 1510 <freep>
 728:	a039                	j	736 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72a:	6398                	ld	a4,0(a5)
 72c:	00e7e463          	bltu	a5,a4,734 <free+0x20>
 730:	00e6ea63          	bltu	a3,a4,744 <free+0x30>
{
 734:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 736:	fed7fae3          	bgeu	a5,a3,72a <free+0x16>
 73a:	6398                	ld	a4,0(a5)
 73c:	00e6e463          	bltu	a3,a4,744 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 740:	fee7eae3          	bltu	a5,a4,734 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 744:	ff852583          	lw	a1,-8(a0)
 748:	6390                	ld	a2,0(a5)
 74a:	02059813          	slli	a6,a1,0x20
 74e:	01c85713          	srli	a4,a6,0x1c
 752:	9736                	add	a4,a4,a3
 754:	02e60563          	beq	a2,a4,77e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 758:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 75c:	4790                	lw	a2,8(a5)
 75e:	02061593          	slli	a1,a2,0x20
 762:	01c5d713          	srli	a4,a1,0x1c
 766:	973e                	add	a4,a4,a5
 768:	02e68263          	beq	a3,a4,78c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 76c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 76e:	00001717          	auipc	a4,0x1
 772:	daf73123          	sd	a5,-606(a4) # 1510 <freep>
}
 776:	60a2                	ld	ra,8(sp)
 778:	6402                	ld	s0,0(sp)
 77a:	0141                	addi	sp,sp,16
 77c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 77e:	4618                	lw	a4,8(a2)
 780:	9f2d                	addw	a4,a4,a1
 782:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	6398                	ld	a4,0(a5)
 788:	6310                	ld	a2,0(a4)
 78a:	b7f9                	j	758 <free+0x44>
    p->s.size += bp->s.size;
 78c:	ff852703          	lw	a4,-8(a0)
 790:	9f31                	addw	a4,a4,a2
 792:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 794:	ff053683          	ld	a3,-16(a0)
 798:	bfd1                	j	76c <free+0x58>

000000000000079a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79a:	7139                	addi	sp,sp,-64
 79c:	fc06                	sd	ra,56(sp)
 79e:	f822                	sd	s0,48(sp)
 7a0:	f04a                	sd	s2,32(sp)
 7a2:	ec4e                	sd	s3,24(sp)
 7a4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a6:	02051993          	slli	s3,a0,0x20
 7aa:	0209d993          	srli	s3,s3,0x20
 7ae:	09bd                	addi	s3,s3,15
 7b0:	0049d993          	srli	s3,s3,0x4
 7b4:	2985                	addiw	s3,s3,1
 7b6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7b8:	00001517          	auipc	a0,0x1
 7bc:	d5853503          	ld	a0,-680(a0) # 1510 <freep>
 7c0:	c905                	beqz	a0,7f0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c4:	4798                	lw	a4,8(a5)
 7c6:	09377a63          	bgeu	a4,s3,85a <malloc+0xc0>
 7ca:	f426                	sd	s1,40(sp)
 7cc:	e852                	sd	s4,16(sp)
 7ce:	e456                	sd	s5,8(sp)
 7d0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7d2:	8a4e                	mv	s4,s3
 7d4:	6705                	lui	a4,0x1
 7d6:	00e9f363          	bgeu	s3,a4,7dc <malloc+0x42>
 7da:	6a05                	lui	s4,0x1
 7dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e4:	00001497          	auipc	s1,0x1
 7e8:	d2c48493          	addi	s1,s1,-724 # 1510 <freep>
  if(p == (char*)-1)
 7ec:	5afd                	li	s5,-1
 7ee:	a089                	j	830 <malloc+0x96>
 7f0:	f426                	sd	s1,40(sp)
 7f2:	e852                	sd	s4,16(sp)
 7f4:	e456                	sd	s5,8(sp)
 7f6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7f8:	00001797          	auipc	a5,0x1
 7fc:	d3878793          	addi	a5,a5,-712 # 1530 <base>
 800:	00001717          	auipc	a4,0x1
 804:	d0f73823          	sd	a5,-752(a4) # 1510 <freep>
 808:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 80a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 80e:	b7d1                	j	7d2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 810:	6398                	ld	a4,0(a5)
 812:	e118                	sd	a4,0(a0)
 814:	a8b9                	j	872 <malloc+0xd8>
  hp->s.size = nu;
 816:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 81a:	0541                	addi	a0,a0,16
 81c:	00000097          	auipc	ra,0x0
 820:	ef8080e7          	jalr	-264(ra) # 714 <free>
  return freep;
 824:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 826:	c135                	beqz	a0,88a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	03277363          	bgeu	a4,s2,852 <malloc+0xb8>
    if(p == freep)
 830:	6098                	ld	a4,0(s1)
 832:	853e                	mv	a0,a5
 834:	fef71ae3          	bne	a4,a5,828 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 838:	8552                	mv	a0,s4
 83a:	00000097          	auipc	ra,0x0
 83e:	b58080e7          	jalr	-1192(ra) # 392 <sbrk>
  if(p == (char*)-1)
 842:	fd551ae3          	bne	a0,s5,816 <malloc+0x7c>
        return 0;
 846:	4501                	li	a0,0
 848:	74a2                	ld	s1,40(sp)
 84a:	6a42                	ld	s4,16(sp)
 84c:	6aa2                	ld	s5,8(sp)
 84e:	6b02                	ld	s6,0(sp)
 850:	a03d                	j	87e <malloc+0xe4>
 852:	74a2                	ld	s1,40(sp)
 854:	6a42                	ld	s4,16(sp)
 856:	6aa2                	ld	s5,8(sp)
 858:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 85a:	fae90be3          	beq	s2,a4,810 <malloc+0x76>
        p->s.size -= nunits;
 85e:	4137073b          	subw	a4,a4,s3
 862:	c798                	sw	a4,8(a5)
        p += p->s.size;
 864:	02071693          	slli	a3,a4,0x20
 868:	01c6d713          	srli	a4,a3,0x1c
 86c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 872:	00001717          	auipc	a4,0x1
 876:	c8a73f23          	sd	a0,-866(a4) # 1510 <freep>
      return (void*)(p + 1);
 87a:	01078513          	addi	a0,a5,16
  }
}
 87e:	70e2                	ld	ra,56(sp)
 880:	7442                	ld	s0,48(sp)
 882:	7902                	ld	s2,32(sp)
 884:	69e2                	ld	s3,24(sp)
 886:	6121                	addi	sp,sp,64
 888:	8082                	ret
 88a:	74a2                	ld	s1,40(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
 892:	b7f5                	j	87e <malloc+0xe4>

0000000000000894 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 894:	1141                	addi	sp,sp,-16
 896:	e406                	sd	ra,8(sp)
 898:	e022                	sd	s0,0(sp)
 89a:	0800                	addi	s0,sp,16
  thread_exit(status);
 89c:	2501                	sext.w	a0,a0
 89e:	00000097          	auipc	ra,0x0
 8a2:	b24080e7          	jalr	-1244(ra) # 3c2 <thread_exit>
}
 8a6:	60a2                	ld	ra,8(sp)
 8a8:	6402                	ld	s0,0(sp)
 8aa:	0141                	addi	sp,sp,16
 8ac:	8082                	ret

00000000000008ae <free_stacks>:
int free_stacks() {
 8ae:	7179                	addi	sp,sp,-48
 8b0:	f406                	sd	ra,40(sp)
 8b2:	f022                	sd	s0,32(sp)
 8b4:	ec26                	sd	s1,24(sp)
 8b6:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8b8:	00001797          	auipc	a5,0x1
 8bc:	c687a783          	lw	a5,-920(a5) # 1520 <num_threads>
 8c0:	04f05063          	blez	a5,900 <free_stacks+0x52>
 8c4:	e84a                	sd	s2,16(sp)
 8c6:	e44e                	sd	s3,8(sp)
 8c8:	4481                	li	s1,0
    free(stacks[i]);
 8ca:	00001997          	auipc	s3,0x1
 8ce:	c4e98993          	addi	s3,s3,-946 # 1518 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8d2:	00001917          	auipc	s2,0x1
 8d6:	c4e90913          	addi	s2,s2,-946 # 1520 <num_threads>
    free(stacks[i]);
 8da:	0009b783          	ld	a5,0(s3)
 8de:	00349713          	slli	a4,s1,0x3
 8e2:	97ba                	add	a5,a5,a4
 8e4:	6388                	ld	a0,0(a5)
 8e6:	00000097          	auipc	ra,0x0
 8ea:	e2e080e7          	jalr	-466(ra) # 714 <free>
  for (int i = 0; i < num_threads; i++) {
 8ee:	0485                	addi	s1,s1,1
 8f0:	00092703          	lw	a4,0(s2)
 8f4:	0004879b          	sext.w	a5,s1
 8f8:	fee7c1e3          	blt	a5,a4,8da <free_stacks+0x2c>
 8fc:	6942                	ld	s2,16(sp)
 8fe:	69a2                	ld	s3,8(sp)
  free(stacks);
 900:	00001497          	auipc	s1,0x1
 904:	c1848493          	addi	s1,s1,-1000 # 1518 <stacks>
 908:	6088                	ld	a0,0(s1)
 90a:	00000097          	auipc	ra,0x0
 90e:	e0a080e7          	jalr	-502(ra) # 714 <free>
  stacks = 0;
 912:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 916:	00001797          	auipc	a5,0x1
 91a:	c007a523          	sw	zero,-1014(a5) # 1520 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 91e:	47a1                	li	a5,8
 920:	00001717          	auipc	a4,0x1
 924:	bef72023          	sw	a5,-1056(a4) # 1500 <max_stacks>
  threads_done = 0;
 928:	00001797          	auipc	a5,0x1
 92c:	be07ae23          	sw	zero,-1028(a5) # 1524 <threads_done>
}
 930:	4501                	li	a0,0
 932:	70a2                	ld	ra,40(sp)
 934:	7402                	ld	s0,32(sp)
 936:	64e2                	ld	s1,24(sp)
 938:	6145                	addi	sp,sp,48
 93a:	8082                	ret

000000000000093c <expand_num_threads>:
int expand_num_threads() {
 93c:	1101                	addi	sp,sp,-32
 93e:	ec06                	sd	ra,24(sp)
 940:	e822                	sd	s0,16(sp)
 942:	e426                	sd	s1,8(sp)
 944:	e04a                	sd	s2,0(sp)
 946:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 948:	00001797          	auipc	a5,0x1
 94c:	bb878793          	addi	a5,a5,-1096 # 1500 <max_stacks>
 950:	4388                	lw	a0,0(a5)
 952:	0015151b          	slliw	a0,a0,0x1
 956:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 958:	0035151b          	slliw	a0,a0,0x3
 95c:	00000097          	auipc	ra,0x0
 960:	e3e080e7          	jalr	-450(ra) # 79a <malloc>
 964:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 966:	00001617          	auipc	a2,0x1
 96a:	bba62603          	lw	a2,-1094(a2) # 1520 <num_threads>
 96e:	00001497          	auipc	s1,0x1
 972:	baa48493          	addi	s1,s1,-1110 # 1518 <stacks>
 976:	0036161b          	slliw	a2,a2,0x3
 97a:	608c                	ld	a1,0(s1)
 97c:	00000097          	auipc	ra,0x0
 980:	8d8080e7          	jalr	-1832(ra) # 254 <memmove>
  free(stacks);
 984:	6088                	ld	a0,0(s1)
 986:	00000097          	auipc	ra,0x0
 98a:	d8e080e7          	jalr	-626(ra) # 714 <free>
  stacks = new_stacks;
 98e:	0124b023          	sd	s2,0(s1)
}
 992:	4501                	li	a0,0
 994:	60e2                	ld	ra,24(sp)
 996:	6442                	ld	s0,16(sp)
 998:	64a2                	ld	s1,8(sp)
 99a:	6902                	ld	s2,0(sp)
 99c:	6105                	addi	sp,sp,32
 99e:	8082                	ret

00000000000009a0 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9a0:	7179                	addi	sp,sp,-48
 9a2:	f406                	sd	ra,40(sp)
 9a4:	f022                	sd	s0,32(sp)
 9a6:	e84a                	sd	s2,16(sp)
 9a8:	e44e                	sd	s3,8(sp)
 9aa:	1800                	addi	s0,sp,48
 9ac:	892a                	mv	s2,a0
 9ae:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9b0:	00001797          	auipc	a5,0x1
 9b4:	b687b783          	ld	a5,-1176(a5) # 1518 <stacks>
 9b8:	c3d9                	beqz	a5,a3e <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9ba:	00001797          	auipc	a5,0x1
 9be:	b467a783          	lw	a5,-1210(a5) # 1500 <max_stacks>
 9c2:	00001717          	auipc	a4,0x1
 9c6:	b5e72703          	lw	a4,-1186(a4) # 1520 <num_threads>
 9ca:	0af71463          	bne	a4,a5,a72 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 9ce:	04000713          	li	a4,64
 9d2:	08e78563          	beq	a5,a4,a5c <ithread_create+0xbc>
 9d6:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9d8:	00000097          	auipc	ra,0x0
 9dc:	f64080e7          	jalr	-156(ra) # 93c <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9e0:	6505                	lui	a0,0x1
 9e2:	00000097          	auipc	ra,0x0
 9e6:	db8080e7          	jalr	-584(ra) # 79a <malloc>
 9ea:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9ec:	00001717          	auipc	a4,0x1
 9f0:	b3472703          	lw	a4,-1228(a4) # 1520 <num_threads>
 9f4:	070e                	slli	a4,a4,0x3
 9f6:	00001797          	auipc	a5,0x1
 9fa:	b227b783          	ld	a5,-1246(a5) # 1518 <stacks>
 9fe:	97ba                	add	a5,a5,a4
 a00:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a02:	00000697          	auipc	a3,0x0
 a06:	e9268693          	addi	a3,a3,-366 # 894 <ithread_exit>
 a0a:	862a                	mv	a2,a0
 a0c:	85ce                	mv	a1,s3
 a0e:	854a                	mv	a0,s2
 a10:	00000097          	auipc	ra,0x0
 a14:	9a2080e7          	jalr	-1630(ra) # 3b2 <create_thread>
 a18:	892a                	mv	s2,a0
  if (res != -1) {
 a1a:	57fd                	li	a5,-1
 a1c:	04f50d63          	beq	a0,a5,a76 <ithread_create+0xd6>
    num_threads++;
 a20:	00001717          	auipc	a4,0x1
 a24:	b0070713          	addi	a4,a4,-1280 # 1520 <num_threads>
 a28:	431c                	lw	a5,0(a4)
 a2a:	2785                	addiw	a5,a5,1
 a2c:	c31c                	sw	a5,0(a4)
 a2e:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a30:	854a                	mv	a0,s2
 a32:	70a2                	ld	ra,40(sp)
 a34:	7402                	ld	s0,32(sp)
 a36:	6942                	ld	s2,16(sp)
 a38:	69a2                	ld	s3,8(sp)
 a3a:	6145                	addi	sp,sp,48
 a3c:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a3e:	00001517          	auipc	a0,0x1
 a42:	ac252503          	lw	a0,-1342(a0) # 1500 <max_stacks>
 a46:	0035151b          	slliw	a0,a0,0x3
 a4a:	00000097          	auipc	ra,0x0
 a4e:	d50080e7          	jalr	-688(ra) # 79a <malloc>
 a52:	00001797          	auipc	a5,0x1
 a56:	aca7b323          	sd	a0,-1338(a5) # 1518 <stacks>
 a5a:	b785                	j	9ba <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a5c:	00000517          	auipc	a0,0x0
 a60:	0cc50513          	addi	a0,a0,204 # b28 <ithread_join+0x8c>
 a64:	00000097          	auipc	ra,0x0
 a68:	c7a080e7          	jalr	-902(ra) # 6de <printf>
      return -1;
 a6c:	57fd                	li	a5,-1
 a6e:	893e                	mv	s2,a5
 a70:	b7c1                	j	a30 <ithread_create+0x90>
 a72:	ec26                	sd	s1,24(sp)
 a74:	b7b5                	j	9e0 <ithread_create+0x40>
    free(stack_ptr);
 a76:	8526                	mv	a0,s1
 a78:	00000097          	auipc	ra,0x0
 a7c:	c9c080e7          	jalr	-868(ra) # 714 <free>
    stacks[num_threads] = 0;
 a80:	00001717          	auipc	a4,0x1
 a84:	aa072703          	lw	a4,-1376(a4) # 1520 <num_threads>
 a88:	070e                	slli	a4,a4,0x3
 a8a:	00001797          	auipc	a5,0x1
 a8e:	a8e7b783          	ld	a5,-1394(a5) # 1518 <stacks>
 a92:	97ba                	add	a5,a5,a4
 a94:	0007b023          	sd	zero,0(a5)
 a98:	64e2                	ld	s1,24(sp)
 a9a:	bf59                	j	a30 <ithread_create+0x90>

0000000000000a9c <ithread_join>:

int ithread_join(int thread_id) {
 a9c:	1101                	addi	sp,sp,-32
 a9e:	ec06                	sd	ra,24(sp)
 aa0:	e822                	sd	s0,16(sp)
 aa2:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 aa4:	ff040793          	addi	a5,s0,-16
 aa8:	ffc7859b          	addiw	a1,a5,-4
 aac:	00000097          	auipc	ra,0x0
 ab0:	90e080e7          	jalr	-1778(ra) # 3ba <join_thread>
  threads_done++;
 ab4:	00001717          	auipc	a4,0x1
 ab8:	a7070713          	addi	a4,a4,-1424 # 1524 <threads_done>
 abc:	431c                	lw	a5,0(a4)
 abe:	2785                	addiw	a5,a5,1
 ac0:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ac2:	00001717          	auipc	a4,0x1
 ac6:	a5e72703          	lw	a4,-1442(a4) # 1520 <num_threads>
 aca:	00f70863          	beq	a4,a5,ada <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ace:	fec42503          	lw	a0,-20(s0)
 ad2:	60e2                	ld	ra,24(sp)
 ad4:	6442                	ld	s0,16(sp)
 ad6:	6105                	addi	sp,sp,32
 ad8:	8082                	ret
    free_stacks();
 ada:	00000097          	auipc	ra,0x0
 ade:	dd4080e7          	jalr	-556(ra) # 8ae <free_stacks>
 ae2:	b7f5                	j	ace <ithread_join+0x32>
