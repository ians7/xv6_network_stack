
src/user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7d863          	bge	a5,a0,84 <main+0x84>
  18:	00858493          	addi	s1,a1,8
  1c:	3579                	addiw	a0,a0,-2
  1e:	02051793          	slli	a5,a0,0x20
  22:	01d7d513          	srli	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	addi	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	ad0a8a93          	addi	s5,s5,-1328 # b00 <ithread_join+0x58>
  38:	a819                	j	4e <main+0x4e>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	00000097          	auipc	ra,0x0
  44:	2f4080e7          	jalr	756(ra) # 334 <write>
  for(i = 1; i < argc; i++){
  48:	04a1                	addi	s1,s1,8
  4a:	03348d63          	beq	s1,s3,84 <main+0x84>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	00000097          	auipc	ra,0x0
  58:	09c080e7          	jalr	156(ra) # f0 <strlen>
  5c:	0005061b          	sext.w	a2,a0
  60:	85ca                	mv	a1,s2
  62:	4505                	li	a0,1
  64:	00000097          	auipc	ra,0x0
  68:	2d0080e7          	jalr	720(ra) # 334 <write>
    if(i + 1 < argc){
  6c:	fd4497e3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  70:	4605                	li	a2,1
  72:	00001597          	auipc	a1,0x1
  76:	a9658593          	addi	a1,a1,-1386 # b08 <ithread_join+0x60>
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	2b8080e7          	jalr	696(ra) # 334 <write>
    }
  }
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	28e080e7          	jalr	654(ra) # 314 <exit>

000000000000008e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  extern int main();
  main();
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <main>
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	274080e7          	jalr	628(ra) # 314 <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ae:	87aa                	mv	a5,a0
  b0:	0585                	addi	a1,a1,1
  b2:	0785                	addi	a5,a5,1
  b4:	fff5c703          	lbu	a4,-1(a1)
  b8:	fee78fa3          	sb	a4,-1(a5)
  bc:	fb75                	bnez	a4,b0 <strcpy+0x8>
    ;
  return os;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb91                	beqz	a5,e2 <strcmp+0x1e>
  d0:	0005c703          	lbu	a4,0(a1)
  d4:	00f71763          	bne	a4,a5,e2 <strcmp+0x1e>
    p++, q++;
  d8:	0505                	addi	a0,a0,1
  da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	fbe5                	bnez	a5,d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e2:	0005c503          	lbu	a0,0(a1)
}
  e6:	40a7853b          	subw	a0,a5,a0
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cf91                	beqz	a5,116 <strlen+0x26>
  fc:	0505                	addi	a0,a0,1
  fe:	87aa                	mv	a5,a0
 100:	86be                	mv	a3,a5
 102:	0785                	addi	a5,a5,1
 104:	fff7c703          	lbu	a4,-1(a5)
 108:	ff65                	bnez	a4,100 <strlen+0x10>
 10a:	40a6853b          	subw	a0,a3,a0
 10e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret
  for(n = 0; s[n]; n++)
 116:	4501                	li	a0,0
 118:	bfe5                	j	110 <strlen+0x20>

000000000000011a <memset>:

void*
memset(void *dst, int c, uint n)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	ca19                	beqz	a2,136 <memset+0x1c>
 122:	87aa                	mv	a5,a0
 124:	1602                	slli	a2,a2,0x20
 126:	9201                	srli	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 130:	0785                	addi	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x12>
  }
  return dst;
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret

000000000000013c <strchr>:

char*
strchr(const char *s, char c)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  for(; *s; s++)
 142:	00054783          	lbu	a5,0(a0)
 146:	cb99                	beqz	a5,15c <strchr+0x20>
    if(*s == c)
 148:	00f58763          	beq	a1,a5,156 <strchr+0x1a>
  for(; *s; s++)
 14c:	0505                	addi	a0,a0,1
 14e:	00054783          	lbu	a5,0(a0)
 152:	fbfd                	bnez	a5,148 <strchr+0xc>
      return (char*)s;
  return 0;
 154:	4501                	li	a0,0
}
 156:	6422                	ld	s0,8(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret
  return 0;
 15c:	4501                	li	a0,0
 15e:	bfe5                	j	156 <strchr+0x1a>

0000000000000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	711d                	addi	sp,sp,-96
 162:	ec86                	sd	ra,88(sp)
 164:	e8a2                	sd	s0,80(sp)
 166:	e4a6                	sd	s1,72(sp)
 168:	e0ca                	sd	s2,64(sp)
 16a:	fc4e                	sd	s3,56(sp)
 16c:	f852                	sd	s4,48(sp)
 16e:	f456                	sd	s5,40(sp)
 170:	f05a                	sd	s6,32(sp)
 172:	ec5e                	sd	s7,24(sp)
 174:	1080                	addi	s0,sp,96
 176:	8baa                	mv	s7,a0
 178:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	892a                	mv	s2,a0
 17c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 17e:	4aa9                	li	s5,10
 180:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 182:	89a6                	mv	s3,s1
 184:	2485                	addiw	s1,s1,1
 186:	0344d863          	bge	s1,s4,1b6 <gets+0x56>
    cc = read(0, &c, 1);
 18a:	4605                	li	a2,1
 18c:	faf40593          	addi	a1,s0,-81
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	19a080e7          	jalr	410(ra) # 32c <read>
    if(cc < 1)
 19a:	00a05e63          	blez	a0,1b6 <gets+0x56>
    buf[i++] = c;
 19e:	faf44783          	lbu	a5,-81(s0)
 1a2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a6:	01578763          	beq	a5,s5,1b4 <gets+0x54>
 1aa:	0905                	addi	s2,s2,1
 1ac:	fd679be3          	bne	a5,s6,182 <gets+0x22>
    buf[i++] = c;
 1b0:	89a6                	mv	s3,s1
 1b2:	a011                	j	1b6 <gets+0x56>
 1b4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1b6:	99de                	add	s3,s3,s7
 1b8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1bc:	855e                	mv	a0,s7
 1be:	60e6                	ld	ra,88(sp)
 1c0:	6446                	ld	s0,80(sp)
 1c2:	64a6                	ld	s1,72(sp)
 1c4:	6906                	ld	s2,64(sp)
 1c6:	79e2                	ld	s3,56(sp)
 1c8:	7a42                	ld	s4,48(sp)
 1ca:	7aa2                	ld	s5,40(sp)
 1cc:	7b02                	ld	s6,32(sp)
 1ce:	6be2                	ld	s7,24(sp)
 1d0:	6125                	addi	sp,sp,96
 1d2:	8082                	ret

00000000000001d4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d4:	1101                	addi	sp,sp,-32
 1d6:	ec06                	sd	ra,24(sp)
 1d8:	e822                	sd	s0,16(sp)
 1da:	e04a                	sd	s2,0(sp)
 1dc:	1000                	addi	s0,sp,32
 1de:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e0:	4581                	li	a1,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	172080e7          	jalr	370(ra) # 354 <open>
  if(fd < 0)
 1ea:	02054663          	bltz	a0,216 <stat+0x42>
 1ee:	e426                	sd	s1,8(sp)
 1f0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f2:	85ca                	mv	a1,s2
 1f4:	00000097          	auipc	ra,0x0
 1f8:	178080e7          	jalr	376(ra) # 36c <fstat>
 1fc:	892a                	mv	s2,a0
  close(fd);
 1fe:	8526                	mv	a0,s1
 200:	00000097          	auipc	ra,0x0
 204:	13c080e7          	jalr	316(ra) # 33c <close>
  return r;
 208:	64a2                	ld	s1,8(sp)
}
 20a:	854a                	mv	a0,s2
 20c:	60e2                	ld	ra,24(sp)
 20e:	6442                	ld	s0,16(sp)
 210:	6902                	ld	s2,0(sp)
 212:	6105                	addi	sp,sp,32
 214:	8082                	ret
    return -1;
 216:	597d                	li	s2,-1
 218:	bfcd                	j	20a <stat+0x36>

000000000000021a <atoi>:

int
atoi(const char *s)
{
 21a:	1141                	addi	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 220:	00054683          	lbu	a3,0(a0)
 224:	fd06879b          	addiw	a5,a3,-48
 228:	0ff7f793          	zext.b	a5,a5
 22c:	4625                	li	a2,9
 22e:	02f66863          	bltu	a2,a5,25e <atoi+0x44>
 232:	872a                	mv	a4,a0
  n = 0;
 234:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 236:	0705                	addi	a4,a4,1
 238:	0025179b          	slliw	a5,a0,0x2
 23c:	9fa9                	addw	a5,a5,a0
 23e:	0017979b          	slliw	a5,a5,0x1
 242:	9fb5                	addw	a5,a5,a3
 244:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 248:	00074683          	lbu	a3,0(a4)
 24c:	fd06879b          	addiw	a5,a3,-48
 250:	0ff7f793          	zext.b	a5,a5
 254:	fef671e3          	bgeu	a2,a5,236 <atoi+0x1c>
  return n;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  n = 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <atoi+0x3e>

0000000000000262 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 268:	02b57463          	bgeu	a0,a1,290 <memmove+0x2e>
    while(n-- > 0)
 26c:	00c05f63          	blez	a2,28a <memmove+0x28>
 270:	1602                	slli	a2,a2,0x20
 272:	9201                	srli	a2,a2,0x20
 274:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 278:	872a                	mv	a4,a0
      *dst++ = *src++;
 27a:	0585                	addi	a1,a1,1
 27c:	0705                	addi	a4,a4,1
 27e:	fff5c683          	lbu	a3,-1(a1)
 282:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 286:	fef71ae3          	bne	a4,a5,27a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
    dst += n;
 290:	00c50733          	add	a4,a0,a2
    src += n;
 294:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 296:	fec05ae3          	blez	a2,28a <memmove+0x28>
 29a:	fff6079b          	addiw	a5,a2,-1
 29e:	1782                	slli	a5,a5,0x20
 2a0:	9381                	srli	a5,a5,0x20
 2a2:	fff7c793          	not	a5,a5
 2a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a8:	15fd                	addi	a1,a1,-1
 2aa:	177d                	addi	a4,a4,-1
 2ac:	0005c683          	lbu	a3,0(a1)
 2b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b4:	fee79ae3          	bne	a5,a4,2a8 <memmove+0x46>
 2b8:	bfc9                	j	28a <memmove+0x28>

00000000000002ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c0:	ca05                	beqz	a2,2f0 <memcmp+0x36>
 2c2:	fff6069b          	addiw	a3,a2,-1
 2c6:	1682                	slli	a3,a3,0x20
 2c8:	9281                	srli	a3,a3,0x20
 2ca:	0685                	addi	a3,a3,1
 2cc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00e79863          	bne	a5,a4,2e6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2da:	0505                	addi	a0,a0,1
    p2++;
 2dc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2de:	fed518e3          	bne	a0,a3,2ce <memcmp+0x14>
  }
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	a019                	j	2ea <memcmp+0x30>
      return *p1 - *p2;
 2e6:	40e7853b          	subw	a0,a5,a4
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  return 0;
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <memcmp+0x30>

00000000000002f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2fc:	00000097          	auipc	ra,0x0
 300:	f66080e7          	jalr	-154(ra) # 262 <memmove>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30c:	4885                	li	a7,1
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exit>:
.global exit
exit:
 li a7, SYS_exit
 314:	4889                	li	a7,2
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <wait>:
.global wait
wait:
 li a7, SYS_wait
 31c:	488d                	li	a7,3
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 324:	4891                	li	a7,4
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <read>:
.global read
read:
 li a7, SYS_read
 32c:	4895                	li	a7,5
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <write>:
.global write
write:
 li a7, SYS_write
 334:	48c1                	li	a7,16
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <close>:
.global close
close:
 li a7, SYS_close
 33c:	48d5                	li	a7,21
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <kill>:
.global kill
kill:
 li a7, SYS_kill
 344:	4899                	li	a7,6
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exec>:
.global exec
exec:
 li a7, SYS_exec
 34c:	489d                	li	a7,7
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <open>:
.global open
open:
 li a7, SYS_open
 354:	48bd                	li	a7,15
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35c:	48c5                	li	a7,17
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 364:	48c9                	li	a7,18
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36c:	48a1                	li	a7,8
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <link>:
.global link
link:
 li a7, SYS_link
 374:	48cd                	li	a7,19
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37c:	48d1                	li	a7,20
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 384:	48a5                	li	a7,9
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <dup>:
.global dup
dup:
 li a7, SYS_dup
 38c:	48a9                	li	a7,10
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 394:	48ad                	li	a7,11
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39c:	48b1                	li	a7,12
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a4:	48b5                	li	a7,13
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ac:	48b9                	li	a7,14
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 3b4:	48d9                	li	a7,22
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 3bc:	48dd                	li	a7,23
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 3c4:	48e1                	li	a7,24
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 3cc:	48e5                	li	a7,25
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <socket>:
.global socket
socket:
 li a7, SYS_socket
 3d4:	48e9                	li	a7,26
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <bind>:
.global bind
bind:
 li a7, SYS_bind
 3dc:	48ed                	li	a7,27
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <accept>:
.global accept
accept:
 li a7, SYS_accept
 3e4:	48f5                	li	a7,29
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <listen>:
.global listen
listen:
 li a7, SYS_listen
 3ec:	48f1                	li	a7,28
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <connect>:
.global connect
connect:
 li a7, SYS_connect
 3f4:	48f9                	li	a7,30
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <send>:
.global send
send:
 li a7, SYS_send
 3fc:	48fd                	li	a7,31
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <recv>:
.global recv
recv:
 li a7, SYS_recv
 404:	02000893          	li	a7,32
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 40e:	02100893          	li	a7,33
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 418:	02200893          	li	a7,34
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 422:	1101                	addi	sp,sp,-32
 424:	ec06                	sd	ra,24(sp)
 426:	e822                	sd	s0,16(sp)
 428:	1000                	addi	s0,sp,32
 42a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42e:	4605                	li	a2,1
 430:	fef40593          	addi	a1,s0,-17
 434:	00000097          	auipc	ra,0x0
 438:	f00080e7          	jalr	-256(ra) # 334 <write>
}
 43c:	60e2                	ld	ra,24(sp)
 43e:	6442                	ld	s0,16(sp)
 440:	6105                	addi	sp,sp,32
 442:	8082                	ret

0000000000000444 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 444:	7139                	addi	sp,sp,-64
 446:	fc06                	sd	ra,56(sp)
 448:	f822                	sd	s0,48(sp)
 44a:	f426                	sd	s1,40(sp)
 44c:	0080                	addi	s0,sp,64
 44e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 450:	c299                	beqz	a3,456 <printint+0x12>
 452:	0805cb63          	bltz	a1,4e8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 456:	2581                	sext.w	a1,a1
  neg = 0;
 458:	4881                	li	a7,0
 45a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 45e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 460:	2601                	sext.w	a2,a2
 462:	00000517          	auipc	a0,0x0
 466:	73e50513          	addi	a0,a0,1854 # ba0 <digits>
 46a:	883a                	mv	a6,a4
 46c:	2705                	addiw	a4,a4,1
 46e:	02c5f7bb          	remuw	a5,a1,a2
 472:	1782                	slli	a5,a5,0x20
 474:	9381                	srli	a5,a5,0x20
 476:	97aa                	add	a5,a5,a0
 478:	0007c783          	lbu	a5,0(a5)
 47c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 480:	0005879b          	sext.w	a5,a1
 484:	02c5d5bb          	divuw	a1,a1,a2
 488:	0685                	addi	a3,a3,1
 48a:	fec7f0e3          	bgeu	a5,a2,46a <printint+0x26>
  if(neg)
 48e:	00088c63          	beqz	a7,4a6 <printint+0x62>
    buf[i++] = '-';
 492:	fd070793          	addi	a5,a4,-48
 496:	00878733          	add	a4,a5,s0
 49a:	02d00793          	li	a5,45
 49e:	fef70823          	sb	a5,-16(a4)
 4a2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4a6:	02e05c63          	blez	a4,4de <printint+0x9a>
 4aa:	f04a                	sd	s2,32(sp)
 4ac:	ec4e                	sd	s3,24(sp)
 4ae:	fc040793          	addi	a5,s0,-64
 4b2:	00e78933          	add	s2,a5,a4
 4b6:	fff78993          	addi	s3,a5,-1
 4ba:	99ba                	add	s3,s3,a4
 4bc:	377d                	addiw	a4,a4,-1
 4be:	1702                	slli	a4,a4,0x20
 4c0:	9301                	srli	a4,a4,0x20
 4c2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c6:	fff94583          	lbu	a1,-1(s2)
 4ca:	8526                	mv	a0,s1
 4cc:	00000097          	auipc	ra,0x0
 4d0:	f56080e7          	jalr	-170(ra) # 422 <putc>
  while(--i >= 0)
 4d4:	197d                	addi	s2,s2,-1
 4d6:	ff3918e3          	bne	s2,s3,4c6 <printint+0x82>
 4da:	7902                	ld	s2,32(sp)
 4dc:	69e2                	ld	s3,24(sp)
}
 4de:	70e2                	ld	ra,56(sp)
 4e0:	7442                	ld	s0,48(sp)
 4e2:	74a2                	ld	s1,40(sp)
 4e4:	6121                	addi	sp,sp,64
 4e6:	8082                	ret
    x = -xx;
 4e8:	40b005bb          	negw	a1,a1
    neg = 1;
 4ec:	4885                	li	a7,1
    x = -xx;
 4ee:	b7b5                	j	45a <printint+0x16>

00000000000004f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f0:	715d                	addi	sp,sp,-80
 4f2:	e486                	sd	ra,72(sp)
 4f4:	e0a2                	sd	s0,64(sp)
 4f6:	f84a                	sd	s2,48(sp)
 4f8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4fa:	0005c903          	lbu	s2,0(a1)
 4fe:	1a090a63          	beqz	s2,6b2 <vprintf+0x1c2>
 502:	fc26                	sd	s1,56(sp)
 504:	f44e                	sd	s3,40(sp)
 506:	f052                	sd	s4,32(sp)
 508:	ec56                	sd	s5,24(sp)
 50a:	e85a                	sd	s6,16(sp)
 50c:	e45e                	sd	s7,8(sp)
 50e:	8aaa                	mv	s5,a0
 510:	8bb2                	mv	s7,a2
 512:	00158493          	addi	s1,a1,1
  state = 0;
 516:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 518:	02500a13          	li	s4,37
 51c:	4b55                	li	s6,21
 51e:	a839                	j	53c <vprintf+0x4c>
        putc(fd, c);
 520:	85ca                	mv	a1,s2
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	efe080e7          	jalr	-258(ra) # 422 <putc>
 52c:	a019                	j	532 <vprintf+0x42>
    } else if(state == '%'){
 52e:	01498d63          	beq	s3,s4,548 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 532:	0485                	addi	s1,s1,1
 534:	fff4c903          	lbu	s2,-1(s1)
 538:	16090763          	beqz	s2,6a6 <vprintf+0x1b6>
    if(state == 0){
 53c:	fe0999e3          	bnez	s3,52e <vprintf+0x3e>
      if(c == '%'){
 540:	ff4910e3          	bne	s2,s4,520 <vprintf+0x30>
        state = '%';
 544:	89d2                	mv	s3,s4
 546:	b7f5                	j	532 <vprintf+0x42>
      if(c == 'd'){
 548:	13490463          	beq	s2,s4,670 <vprintf+0x180>
 54c:	f9d9079b          	addiw	a5,s2,-99
 550:	0ff7f793          	zext.b	a5,a5
 554:	12fb6763          	bltu	s6,a5,682 <vprintf+0x192>
 558:	f9d9079b          	addiw	a5,s2,-99
 55c:	0ff7f713          	zext.b	a4,a5
 560:	12eb6163          	bltu	s6,a4,682 <vprintf+0x192>
 564:	00271793          	slli	a5,a4,0x2
 568:	00000717          	auipc	a4,0x0
 56c:	5e070713          	addi	a4,a4,1504 # b48 <ithread_join+0xa0>
 570:	97ba                	add	a5,a5,a4
 572:	439c                	lw	a5,0(a5)
 574:	97ba                	add	a5,a5,a4
 576:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 578:	008b8913          	addi	s2,s7,8
 57c:	4685                	li	a3,1
 57e:	4629                	li	a2,10
 580:	000ba583          	lw	a1,0(s7)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	ebe080e7          	jalr	-322(ra) # 444 <printint>
 58e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 590:	4981                	li	s3,0
 592:	b745                	j	532 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 594:	008b8913          	addi	s2,s7,8
 598:	4681                	li	a3,0
 59a:	4629                	li	a2,10
 59c:	000ba583          	lw	a1,0(s7)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	ea2080e7          	jalr	-350(ra) # 444 <printint>
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b751                	j	532 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4641                	li	a2,16
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e86080e7          	jalr	-378(ra) # 444 <printint>
 5c6:	8bca                	mv	s7,s2
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b7a5                	j	532 <vprintf+0x42>
 5cc:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5ce:	008b8c13          	addi	s8,s7,8
 5d2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5d6:	03000593          	li	a1,48
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e46080e7          	jalr	-442(ra) # 422 <putc>
  putc(fd, 'x');
 5e4:	07800593          	li	a1,120
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	e38080e7          	jalr	-456(ra) # 422 <putc>
 5f2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f4:	00000b97          	auipc	s7,0x0
 5f8:	5acb8b93          	addi	s7,s7,1452 # ba0 <digits>
 5fc:	03c9d793          	srli	a5,s3,0x3c
 600:	97de                	add	a5,a5,s7
 602:	0007c583          	lbu	a1,0(a5)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	e1a080e7          	jalr	-486(ra) # 422 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 610:	0992                	slli	s3,s3,0x4
 612:	397d                	addiw	s2,s2,-1
 614:	fe0914e3          	bnez	s2,5fc <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 618:	8be2                	mv	s7,s8
      state = 0;
 61a:	4981                	li	s3,0
 61c:	6c02                	ld	s8,0(sp)
 61e:	bf11                	j	532 <vprintf+0x42>
        s = va_arg(ap, char*);
 620:	008b8993          	addi	s3,s7,8
 624:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 628:	02090163          	beqz	s2,64a <vprintf+0x15a>
        while(*s != 0){
 62c:	00094583          	lbu	a1,0(s2)
 630:	c9a5                	beqz	a1,6a0 <vprintf+0x1b0>
          putc(fd, *s);
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	dee080e7          	jalr	-530(ra) # 422 <putc>
          s++;
 63c:	0905                	addi	s2,s2,1
        while(*s != 0){
 63e:	00094583          	lbu	a1,0(s2)
 642:	f9e5                	bnez	a1,632 <vprintf+0x142>
        s = va_arg(ap, char*);
 644:	8bce                	mv	s7,s3
      state = 0;
 646:	4981                	li	s3,0
 648:	b5ed                	j	532 <vprintf+0x42>
          s = "(null)";
 64a:	00000917          	auipc	s2,0x0
 64e:	4c690913          	addi	s2,s2,1222 # b10 <ithread_join+0x68>
        while(*s != 0){
 652:	02800593          	li	a1,40
 656:	bff1                	j	632 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 658:	008b8913          	addi	s2,s7,8
 65c:	000bc583          	lbu	a1,0(s7)
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	dc0080e7          	jalr	-576(ra) # 422 <putc>
 66a:	8bca                	mv	s7,s2
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b5d1                	j	532 <vprintf+0x42>
        putc(fd, c);
 670:	02500593          	li	a1,37
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	dac080e7          	jalr	-596(ra) # 422 <putc>
      state = 0;
 67e:	4981                	li	s3,0
 680:	bd4d                	j	532 <vprintf+0x42>
        putc(fd, '%');
 682:	02500593          	li	a1,37
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	d9a080e7          	jalr	-614(ra) # 422 <putc>
        putc(fd, c);
 690:	85ca                	mv	a1,s2
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	d8e080e7          	jalr	-626(ra) # 422 <putc>
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bd51                	j	532 <vprintf+0x42>
        s = va_arg(ap, char*);
 6a0:	8bce                	mv	s7,s3
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b579                	j	532 <vprintf+0x42>
 6a6:	74e2                	ld	s1,56(sp)
 6a8:	79a2                	ld	s3,40(sp)
 6aa:	7a02                	ld	s4,32(sp)
 6ac:	6ae2                	ld	s5,24(sp)
 6ae:	6b42                	ld	s6,16(sp)
 6b0:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6b2:	60a6                	ld	ra,72(sp)
 6b4:	6406                	ld	s0,64(sp)
 6b6:	7942                	ld	s2,48(sp)
 6b8:	6161                	addi	sp,sp,80
 6ba:	8082                	ret

00000000000006bc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6bc:	715d                	addi	sp,sp,-80
 6be:	ec06                	sd	ra,24(sp)
 6c0:	e822                	sd	s0,16(sp)
 6c2:	1000                	addi	s0,sp,32
 6c4:	e010                	sd	a2,0(s0)
 6c6:	e414                	sd	a3,8(s0)
 6c8:	e818                	sd	a4,16(s0)
 6ca:	ec1c                	sd	a5,24(s0)
 6cc:	03043023          	sd	a6,32(s0)
 6d0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d8:	8622                	mv	a2,s0
 6da:	00000097          	auipc	ra,0x0
 6de:	e16080e7          	jalr	-490(ra) # 4f0 <vprintf>
}
 6e2:	60e2                	ld	ra,24(sp)
 6e4:	6442                	ld	s0,16(sp)
 6e6:	6161                	addi	sp,sp,80
 6e8:	8082                	ret

00000000000006ea <printf>:

void
printf(const char *fmt, ...)
{
 6ea:	711d                	addi	sp,sp,-96
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	addi	s0,sp,32
 6f2:	e40c                	sd	a1,8(s0)
 6f4:	e810                	sd	a2,16(s0)
 6f6:	ec14                	sd	a3,24(s0)
 6f8:	f018                	sd	a4,32(s0)
 6fa:	f41c                	sd	a5,40(s0)
 6fc:	03043823          	sd	a6,48(s0)
 700:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 704:	00840613          	addi	a2,s0,8
 708:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 70c:	85aa                	mv	a1,a0
 70e:	4505                	li	a0,1
 710:	00000097          	auipc	ra,0x0
 714:	de0080e7          	jalr	-544(ra) # 4f0 <vprintf>
}
 718:	60e2                	ld	ra,24(sp)
 71a:	6442                	ld	s0,16(sp)
 71c:	6125                	addi	sp,sp,96
 71e:	8082                	ret

0000000000000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	1141                	addi	sp,sp,-16
 722:	e422                	sd	s0,8(sp)
 724:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 726:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72a:	00001797          	auipc	a5,0x1
 72e:	8e67b783          	ld	a5,-1818(a5) # 1010 <freep>
 732:	a02d                	j	75c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 734:	4618                	lw	a4,8(a2)
 736:	9f2d                	addw	a4,a4,a1
 738:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 73c:	6398                	ld	a4,0(a5)
 73e:	6310                	ld	a2,0(a4)
 740:	a83d                	j	77e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 742:	ff852703          	lw	a4,-8(a0)
 746:	9f31                	addw	a4,a4,a2
 748:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 74a:	ff053683          	ld	a3,-16(a0)
 74e:	a091                	j	792 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	6398                	ld	a4,0(a5)
 752:	00e7e463          	bltu	a5,a4,75a <free+0x3a>
 756:	00e6ea63          	bltu	a3,a4,76a <free+0x4a>
{
 75a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75c:	fed7fae3          	bgeu	a5,a3,750 <free+0x30>
 760:	6398                	ld	a4,0(a5)
 762:	00e6e463          	bltu	a3,a4,76a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 766:	fee7eae3          	bltu	a5,a4,75a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 76a:	ff852583          	lw	a1,-8(a0)
 76e:	6390                	ld	a2,0(a5)
 770:	02059813          	slli	a6,a1,0x20
 774:	01c85713          	srli	a4,a6,0x1c
 778:	9736                	add	a4,a4,a3
 77a:	fae60de3          	beq	a2,a4,734 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 77e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 782:	4790                	lw	a2,8(a5)
 784:	02061593          	slli	a1,a2,0x20
 788:	01c5d713          	srli	a4,a1,0x1c
 78c:	973e                	add	a4,a4,a5
 78e:	fae68ae3          	beq	a3,a4,742 <free+0x22>
    p->s.ptr = bp->s.ptr;
 792:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 794:	00001717          	auipc	a4,0x1
 798:	86f73e23          	sd	a5,-1924(a4) # 1010 <freep>
}
 79c:	6422                	ld	s0,8(sp)
 79e:	0141                	addi	sp,sp,16
 7a0:	8082                	ret

00000000000007a2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a2:	7139                	addi	sp,sp,-64
 7a4:	fc06                	sd	ra,56(sp)
 7a6:	f822                	sd	s0,48(sp)
 7a8:	f426                	sd	s1,40(sp)
 7aa:	ec4e                	sd	s3,24(sp)
 7ac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ae:	02051493          	slli	s1,a0,0x20
 7b2:	9081                	srli	s1,s1,0x20
 7b4:	04bd                	addi	s1,s1,15
 7b6:	8091                	srli	s1,s1,0x4
 7b8:	0014899b          	addiw	s3,s1,1
 7bc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7be:	00001517          	auipc	a0,0x1
 7c2:	85253503          	ld	a0,-1966(a0) # 1010 <freep>
 7c6:	c915                	beqz	a0,7fa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ca:	4798                	lw	a4,8(a5)
 7cc:	08977e63          	bgeu	a4,s1,868 <malloc+0xc6>
 7d0:	f04a                	sd	s2,32(sp)
 7d2:	e852                	sd	s4,16(sp)
 7d4:	e456                	sd	s5,8(sp)
 7d6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7d8:	8a4e                	mv	s4,s3
 7da:	0009871b          	sext.w	a4,s3
 7de:	6685                	lui	a3,0x1
 7e0:	00d77363          	bgeu	a4,a3,7e6 <malloc+0x44>
 7e4:	6a05                	lui	s4,0x1
 7e6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ee:	00001917          	auipc	s2,0x1
 7f2:	82290913          	addi	s2,s2,-2014 # 1010 <freep>
  if(p == (char*)-1)
 7f6:	5afd                	li	s5,-1
 7f8:	a091                	j	83c <malloc+0x9a>
 7fa:	f04a                	sd	s2,32(sp)
 7fc:	e852                	sd	s4,16(sp)
 7fe:	e456                	sd	s5,8(sp)
 800:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 802:	00001797          	auipc	a5,0x1
 806:	82e78793          	addi	a5,a5,-2002 # 1030 <base>
 80a:	00001717          	auipc	a4,0x1
 80e:	80f73323          	sd	a5,-2042(a4) # 1010 <freep>
 812:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 814:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 818:	b7c1                	j	7d8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 81a:	6398                	ld	a4,0(a5)
 81c:	e118                	sd	a4,0(a0)
 81e:	a08d                	j	880 <malloc+0xde>
  hp->s.size = nu;
 820:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 824:	0541                	addi	a0,a0,16
 826:	00000097          	auipc	ra,0x0
 82a:	efa080e7          	jalr	-262(ra) # 720 <free>
  return freep;
 82e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 832:	c13d                	beqz	a0,898 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 834:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 836:	4798                	lw	a4,8(a5)
 838:	02977463          	bgeu	a4,s1,860 <malloc+0xbe>
    if(p == freep)
 83c:	00093703          	ld	a4,0(s2)
 840:	853e                	mv	a0,a5
 842:	fef719e3          	bne	a4,a5,834 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 846:	8552                	mv	a0,s4
 848:	00000097          	auipc	ra,0x0
 84c:	b54080e7          	jalr	-1196(ra) # 39c <sbrk>
  if(p == (char*)-1)
 850:	fd5518e3          	bne	a0,s5,820 <malloc+0x7e>
        return 0;
 854:	4501                	li	a0,0
 856:	7902                	ld	s2,32(sp)
 858:	6a42                	ld	s4,16(sp)
 85a:	6aa2                	ld	s5,8(sp)
 85c:	6b02                	ld	s6,0(sp)
 85e:	a03d                	j	88c <malloc+0xea>
 860:	7902                	ld	s2,32(sp)
 862:	6a42                	ld	s4,16(sp)
 864:	6aa2                	ld	s5,8(sp)
 866:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 868:	fae489e3          	beq	s1,a4,81a <malloc+0x78>
        p->s.size -= nunits;
 86c:	4137073b          	subw	a4,a4,s3
 870:	c798                	sw	a4,8(a5)
        p += p->s.size;
 872:	02071693          	slli	a3,a4,0x20
 876:	01c6d713          	srli	a4,a3,0x1c
 87a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 880:	00000717          	auipc	a4,0x0
 884:	78a73823          	sd	a0,1936(a4) # 1010 <freep>
      return (void*)(p + 1);
 888:	01078513          	addi	a0,a5,16
  }
}
 88c:	70e2                	ld	ra,56(sp)
 88e:	7442                	ld	s0,48(sp)
 890:	74a2                	ld	s1,40(sp)
 892:	69e2                	ld	s3,24(sp)
 894:	6121                	addi	sp,sp,64
 896:	8082                	ret
 898:	7902                	ld	s2,32(sp)
 89a:	6a42                	ld	s4,16(sp)
 89c:	6aa2                	ld	s5,8(sp)
 89e:	6b02                	ld	s6,0(sp)
 8a0:	b7f5                	j	88c <malloc+0xea>

00000000000008a2 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 8a2:	1141                	addi	sp,sp,-16
 8a4:	e406                	sd	ra,8(sp)
 8a6:	e022                	sd	s0,0(sp)
 8a8:	0800                	addi	s0,sp,16
  thread_exit(status);
 8aa:	2501                	sext.w	a0,a0
 8ac:	00000097          	auipc	ra,0x0
 8b0:	b20080e7          	jalr	-1248(ra) # 3cc <thread_exit>
}
 8b4:	60a2                	ld	ra,8(sp)
 8b6:	6402                	ld	s0,0(sp)
 8b8:	0141                	addi	sp,sp,16
 8ba:	8082                	ret

00000000000008bc <free_stacks>:
int free_stacks() {
 8bc:	7179                	addi	sp,sp,-48
 8be:	f406                	sd	ra,40(sp)
 8c0:	f022                	sd	s0,32(sp)
 8c2:	ec26                	sd	s1,24(sp)
 8c4:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8c6:	00000797          	auipc	a5,0x0
 8ca:	75a7a783          	lw	a5,1882(a5) # 1020 <num_threads>
 8ce:	04f05063          	blez	a5,90e <free_stacks+0x52>
 8d2:	e84a                	sd	s2,16(sp)
 8d4:	e44e                	sd	s3,8(sp)
 8d6:	4481                	li	s1,0
    free(stacks[i]);
 8d8:	00000997          	auipc	s3,0x0
 8dc:	74098993          	addi	s3,s3,1856 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8e0:	00000917          	auipc	s2,0x0
 8e4:	74090913          	addi	s2,s2,1856 # 1020 <num_threads>
    free(stacks[i]);
 8e8:	0009b783          	ld	a5,0(s3)
 8ec:	00349713          	slli	a4,s1,0x3
 8f0:	97ba                	add	a5,a5,a4
 8f2:	6388                	ld	a0,0(a5)
 8f4:	00000097          	auipc	ra,0x0
 8f8:	e2c080e7          	jalr	-468(ra) # 720 <free>
  for (int i = 0; i < num_threads; i++) {
 8fc:	0485                	addi	s1,s1,1
 8fe:	00092703          	lw	a4,0(s2)
 902:	0004879b          	sext.w	a5,s1
 906:	fee7c1e3          	blt	a5,a4,8e8 <free_stacks+0x2c>
 90a:	6942                	ld	s2,16(sp)
 90c:	69a2                	ld	s3,8(sp)
  free(stacks);
 90e:	00000497          	auipc	s1,0x0
 912:	70a48493          	addi	s1,s1,1802 # 1018 <stacks>
 916:	6088                	ld	a0,0(s1)
 918:	00000097          	auipc	ra,0x0
 91c:	e08080e7          	jalr	-504(ra) # 720 <free>
  stacks = 0;
 920:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 924:	00000797          	auipc	a5,0x0
 928:	6e07ae23          	sw	zero,1788(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 92c:	47a1                	li	a5,8
 92e:	00000717          	auipc	a4,0x0
 932:	6cf72923          	sw	a5,1746(a4) # 1000 <max_stacks>
  threads_done = 0;
 936:	00000797          	auipc	a5,0x0
 93a:	6e07a723          	sw	zero,1774(a5) # 1024 <threads_done>
}
 93e:	4501                	li	a0,0
 940:	70a2                	ld	ra,40(sp)
 942:	7402                	ld	s0,32(sp)
 944:	64e2                	ld	s1,24(sp)
 946:	6145                	addi	sp,sp,48
 948:	8082                	ret

000000000000094a <expand_num_threads>:
int expand_num_threads() {
 94a:	1101                	addi	sp,sp,-32
 94c:	ec06                	sd	ra,24(sp)
 94e:	e822                	sd	s0,16(sp)
 950:	e426                	sd	s1,8(sp)
 952:	e04a                	sd	s2,0(sp)
 954:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 956:	00000797          	auipc	a5,0x0
 95a:	6aa78793          	addi	a5,a5,1706 # 1000 <max_stacks>
 95e:	4388                	lw	a0,0(a5)
 960:	0015151b          	slliw	a0,a0,0x1
 964:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 966:	0035151b          	slliw	a0,a0,0x3
 96a:	00000097          	auipc	ra,0x0
 96e:	e38080e7          	jalr	-456(ra) # 7a2 <malloc>
 972:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 974:	00000617          	auipc	a2,0x0
 978:	6ac62603          	lw	a2,1708(a2) # 1020 <num_threads>
 97c:	00000497          	auipc	s1,0x0
 980:	69c48493          	addi	s1,s1,1692 # 1018 <stacks>
 984:	0036161b          	slliw	a2,a2,0x3
 988:	608c                	ld	a1,0(s1)
 98a:	00000097          	auipc	ra,0x0
 98e:	8d8080e7          	jalr	-1832(ra) # 262 <memmove>
  free(stacks);
 992:	6088                	ld	a0,0(s1)
 994:	00000097          	auipc	ra,0x0
 998:	d8c080e7          	jalr	-628(ra) # 720 <free>
  stacks = new_stacks;
 99c:	0124b023          	sd	s2,0(s1)
}
 9a0:	4501                	li	a0,0
 9a2:	60e2                	ld	ra,24(sp)
 9a4:	6442                	ld	s0,16(sp)
 9a6:	64a2                	ld	s1,8(sp)
 9a8:	6902                	ld	s2,0(sp)
 9aa:	6105                	addi	sp,sp,32
 9ac:	8082                	ret

00000000000009ae <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9ae:	7179                	addi	sp,sp,-48
 9b0:	f406                	sd	ra,40(sp)
 9b2:	f022                	sd	s0,32(sp)
 9b4:	e84a                	sd	s2,16(sp)
 9b6:	e44e                	sd	s3,8(sp)
 9b8:	1800                	addi	s0,sp,48
 9ba:	892a                	mv	s2,a0
 9bc:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9be:	00000797          	auipc	a5,0x0
 9c2:	65a7b783          	ld	a5,1626(a5) # 1018 <stacks>
 9c6:	c3d9                	beqz	a5,a4c <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9c8:	00000797          	auipc	a5,0x0
 9cc:	6387a783          	lw	a5,1592(a5) # 1000 <max_stacks>
 9d0:	00000717          	auipc	a4,0x0
 9d4:	65072703          	lw	a4,1616(a4) # 1020 <num_threads>
 9d8:	0af71363          	bne	a4,a5,a7e <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 9dc:	04000713          	li	a4,64
 9e0:	08e78563          	beq	a5,a4,a6a <ithread_create+0xbc>
 9e4:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9e6:	00000097          	auipc	ra,0x0
 9ea:	f64080e7          	jalr	-156(ra) # 94a <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 9ee:	6505                	lui	a0,0x1
 9f0:	00000097          	auipc	ra,0x0
 9f4:	db2080e7          	jalr	-590(ra) # 7a2 <malloc>
 9f8:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 9fa:	00000717          	auipc	a4,0x0
 9fe:	62672703          	lw	a4,1574(a4) # 1020 <num_threads>
 a02:	070e                	slli	a4,a4,0x3
 a04:	00000797          	auipc	a5,0x0
 a08:	6147b783          	ld	a5,1556(a5) # 1018 <stacks>
 a0c:	97ba                	add	a5,a5,a4
 a0e:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a10:	00000697          	auipc	a3,0x0
 a14:	e9268693          	addi	a3,a3,-366 # 8a2 <ithread_exit>
 a18:	862a                	mv	a2,a0
 a1a:	85ce                	mv	a1,s3
 a1c:	854a                	mv	a0,s2
 a1e:	00000097          	auipc	ra,0x0
 a22:	99e080e7          	jalr	-1634(ra) # 3bc <create_thread>
 a26:	892a                	mv	s2,a0
  if (res != -1) {
 a28:	57fd                	li	a5,-1
 a2a:	04f50c63          	beq	a0,a5,a82 <ithread_create+0xd4>
    num_threads++;
 a2e:	00000717          	auipc	a4,0x0
 a32:	5f270713          	addi	a4,a4,1522 # 1020 <num_threads>
 a36:	431c                	lw	a5,0(a4)
 a38:	2785                	addiw	a5,a5,1
 a3a:	c31c                	sw	a5,0(a4)
 a3c:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a3e:	854a                	mv	a0,s2
 a40:	70a2                	ld	ra,40(sp)
 a42:	7402                	ld	s0,32(sp)
 a44:	6942                	ld	s2,16(sp)
 a46:	69a2                	ld	s3,8(sp)
 a48:	6145                	addi	sp,sp,48
 a4a:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a4c:	00000517          	auipc	a0,0x0
 a50:	5b452503          	lw	a0,1460(a0) # 1000 <max_stacks>
 a54:	0035151b          	slliw	a0,a0,0x3
 a58:	00000097          	auipc	ra,0x0
 a5c:	d4a080e7          	jalr	-694(ra) # 7a2 <malloc>
 a60:	00000797          	auipc	a5,0x0
 a64:	5aa7bc23          	sd	a0,1464(a5) # 1018 <stacks>
 a68:	b785                	j	9c8 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 a6a:	00000517          	auipc	a0,0x0
 a6e:	0ae50513          	addi	a0,a0,174 # b18 <ithread_join+0x70>
 a72:	00000097          	auipc	ra,0x0
 a76:	c78080e7          	jalr	-904(ra) # 6ea <printf>
      return -1;
 a7a:	597d                	li	s2,-1
 a7c:	b7c9                	j	a3e <ithread_create+0x90>
 a7e:	ec26                	sd	s1,24(sp)
 a80:	b7bd                	j	9ee <ithread_create+0x40>
    free(stack_ptr);
 a82:	8526                	mv	a0,s1
 a84:	00000097          	auipc	ra,0x0
 a88:	c9c080e7          	jalr	-868(ra) # 720 <free>
    stacks[num_threads] = 0;
 a8c:	00000717          	auipc	a4,0x0
 a90:	59472703          	lw	a4,1428(a4) # 1020 <num_threads>
 a94:	070e                	slli	a4,a4,0x3
 a96:	00000797          	auipc	a5,0x0
 a9a:	5827b783          	ld	a5,1410(a5) # 1018 <stacks>
 a9e:	97ba                	add	a5,a5,a4
 aa0:	0007b023          	sd	zero,0(a5)
 aa4:	64e2                	ld	s1,24(sp)
 aa6:	bf61                	j	a3e <ithread_create+0x90>

0000000000000aa8 <ithread_join>:

int ithread_join(int thread_id) {
 aa8:	1101                	addi	sp,sp,-32
 aaa:	ec06                	sd	ra,24(sp)
 aac:	e822                	sd	s0,16(sp)
 aae:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 ab0:	ff040793          	addi	a5,s0,-16
 ab4:	ffc7859b          	addiw	a1,a5,-4
 ab8:	00000097          	auipc	ra,0x0
 abc:	90c080e7          	jalr	-1780(ra) # 3c4 <join_thread>
  threads_done++;
 ac0:	00000717          	auipc	a4,0x0
 ac4:	56470713          	addi	a4,a4,1380 # 1024 <threads_done>
 ac8:	431c                	lw	a5,0(a4)
 aca:	2785                	addiw	a5,a5,1
 acc:	0007869b          	sext.w	a3,a5
 ad0:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ad2:	00000797          	auipc	a5,0x0
 ad6:	54e7a783          	lw	a5,1358(a5) # 1020 <num_threads>
 ada:	00d78863          	beq	a5,a3,aea <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 ade:	fec42503          	lw	a0,-20(s0)
 ae2:	60e2                	ld	ra,24(sp)
 ae4:	6442                	ld	s0,16(sp)
 ae6:	6105                	addi	sp,sp,32
 ae8:	8082                	ret
    free_stacks();
 aea:	00000097          	auipc	ra,0x0
 aee:	dd2080e7          	jalr	-558(ra) # 8bc <free_stacks>
 af2:	b7f5                	j	ade <ithread_join+0x36>
