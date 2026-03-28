
src/user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	3ac080e7          	jalr	940(ra) # 3b4 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	3a6080e7          	jalr	934(ra) # 3bc <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	42c080e7          	jalr	1068(ra) # 44c <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	380080e7          	jalr	896(ra) # 3bc <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
    ;
  return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
    p++, q++;
  74:	0505                	addi	a0,a0,1
  76:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	addi	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	86be                	mv	a3,a5
  9e:	0785                	addi	a5,a5,1
  a0:	fff7c703          	lbu	a4,-1(a5)
  a4:	ff65                	bnez	a4,9c <strlen+0x10>
  a6:	40a6853b          	subw	a0,a3,a0
  aa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret
  for(n = 0; s[n]; n++)
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	slli	a2,a2,0x20
  c2:	9201                	srli	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  cc:	0785                	addi	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
  }
  return dst;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
    if(*s == c)
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
  for(; *s; s++)
  e8:	0505                	addi	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
      return (char*)s;
  return 0;
  f0:	4501                	li	a0,0
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	711d                	addi	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11e:	89a6                	mv	s3,s1
 120:	2485                	addiw	s1,s1,1
 122:	0344d863          	bge	s1,s4,152 <gets+0x56>
    cc = read(0, &c, 1);
 126:	4605                	li	a2,1
 128:	faf40593          	addi	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	2a6080e7          	jalr	678(ra) # 3d4 <read>
    if(cc < 1)
 136:	00a05e63          	blez	a0,152 <gets+0x56>
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 142:	01578763          	beq	a5,s5,150 <gets+0x54>
 146:	0905                	addi	s2,s2,1
 148:	fd679be3          	bne	a5,s6,11e <gets+0x22>
    buf[i++] = c;
 14c:	89a6                	mv	s3,s1
 14e:	a011                	j	152 <gets+0x56>
 150:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 152:	99de                	add	s3,s3,s7
 154:	00098023          	sb	zero,0(s3)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6125                	addi	sp,sp,96
 16e:	8082                	ret

0000000000000170 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 170:	711d                	addi	sp,sp,-96
 172:	ec86                	sd	ra,88(sp)
 174:	e8a2                	sd	s0,80(sp)
 176:	e4a6                	sd	s1,72(sp)
 178:	e0ca                	sd	s2,64(sp)
 17a:	fc4e                	sd	s3,56(sp)
 17c:	f852                	sd	s4,48(sp)
 17e:	f456                	sd	s5,40(sp)
 180:	f05a                	sd	s6,32(sp)
 182:	ec5e                	sd	s7,24(sp)
 184:	1080                	addi	s0,sp,96
 186:	8baa                	mv	s7,a0
 188:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 18a:	892a                	mv	s2,a0
 18c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 18e:	4aa9                	li	s5,10
 190:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 192:	8a26                	mv	s4,s1
 194:	2485                	addiw	s1,s1,1
 196:	0334d863          	bge	s1,s3,1c6 <fgetstdin+0x56>
    cc = read(0, &c, 1);
 19a:	4605                	li	a2,1
 19c:	faf40593          	addi	a1,s0,-81
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	232080e7          	jalr	562(ra) # 3d4 <read>
    if(cc < 1)
 1aa:	00a05e63          	blez	a0,1c6 <fgetstdin+0x56>
    buf[i++] = c;
 1ae:	faf44783          	lbu	a5,-81(s0)
 1b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b6:	01578763          	beq	a5,s5,1c4 <fgetstdin+0x54>
 1ba:	0905                	addi	s2,s2,1
 1bc:	fd679be3          	bne	a5,s6,192 <fgetstdin+0x22>
    buf[i++] = c;
 1c0:	8a26                	mv	s4,s1
 1c2:	a011                	j	1c6 <fgetstdin+0x56>
 1c4:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 1c6:	9bd2                	add	s7,s7,s4
 1c8:	000b8023          	sb	zero,0(s7)
  return i;
}
 1cc:	8552                	mv	a0,s4
 1ce:	60e6                	ld	ra,88(sp)
 1d0:	6446                	ld	s0,80(sp)
 1d2:	64a6                	ld	s1,72(sp)
 1d4:	6906                	ld	s2,64(sp)
 1d6:	79e2                	ld	s3,56(sp)
 1d8:	7a42                	ld	s4,48(sp)
 1da:	7aa2                	ld	s5,40(sp)
 1dc:	7b02                	ld	s6,32(sp)
 1de:	6be2                	ld	s7,24(sp)
 1e0:	6125                	addi	sp,sp,96
 1e2:	8082                	ret

00000000000001e4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1e4:	1101                	addi	sp,sp,-32
 1e6:	ec06                	sd	ra,24(sp)
 1e8:	e822                	sd	s0,16(sp)
 1ea:	e04a                	sd	s2,0(sp)
 1ec:	1000                	addi	s0,sp,32
 1ee:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	4581                	li	a1,0
 1f2:	00000097          	auipc	ra,0x0
 1f6:	20a080e7          	jalr	522(ra) # 3fc <open>
  if(fd < 0)
 1fa:	02054663          	bltz	a0,226 <stat+0x42>
 1fe:	e426                	sd	s1,8(sp)
 200:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 202:	85ca                	mv	a1,s2
 204:	00000097          	auipc	ra,0x0
 208:	210080e7          	jalr	528(ra) # 414 <fstat>
 20c:	892a                	mv	s2,a0
  close(fd);
 20e:	8526                	mv	a0,s1
 210:	00000097          	auipc	ra,0x0
 214:	1d4080e7          	jalr	468(ra) # 3e4 <close>
  return r;
 218:	64a2                	ld	s1,8(sp)
}
 21a:	854a                	mv	a0,s2
 21c:	60e2                	ld	ra,24(sp)
 21e:	6442                	ld	s0,16(sp)
 220:	6902                	ld	s2,0(sp)
 222:	6105                	addi	sp,sp,32
 224:	8082                	ret
    return -1;
 226:	597d                	li	s2,-1
 228:	bfcd                	j	21a <stat+0x36>

000000000000022a <atoi>:

int
atoi(const char *s)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 230:	00054683          	lbu	a3,0(a0)
 234:	fd06879b          	addiw	a5,a3,-48
 238:	0ff7f793          	zext.b	a5,a5
 23c:	4625                	li	a2,9
 23e:	02f66863          	bltu	a2,a5,26e <atoi+0x44>
 242:	872a                	mv	a4,a0
  n = 0;
 244:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 246:	0705                	addi	a4,a4,1
 248:	0025179b          	slliw	a5,a0,0x2
 24c:	9fa9                	addw	a5,a5,a0
 24e:	0017979b          	slliw	a5,a5,0x1
 252:	9fb5                	addw	a5,a5,a3
 254:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 258:	00074683          	lbu	a3,0(a4)
 25c:	fd06879b          	addiw	a5,a3,-48
 260:	0ff7f793          	zext.b	a5,a5
 264:	fef671e3          	bgeu	a2,a5,246 <atoi+0x1c>
  return n;
}
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
  n = 0;
 26e:	4501                	li	a0,0
 270:	bfe5                	j	268 <atoi+0x3e>

0000000000000272 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 278:	02b57463          	bgeu	a0,a1,2a0 <memmove+0x2e>
    while(n-- > 0)
 27c:	00c05f63          	blez	a2,29a <memmove+0x28>
 280:	1602                	slli	a2,a2,0x20
 282:	9201                	srli	a2,a2,0x20
 284:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 288:	872a                	mv	a4,a0
      *dst++ = *src++;
 28a:	0585                	addi	a1,a1,1
 28c:	0705                	addi	a4,a4,1
 28e:	fff5c683          	lbu	a3,-1(a1)
 292:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 296:	fef71ae3          	bne	a4,a5,28a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
    dst += n;
 2a0:	00c50733          	add	a4,a0,a2
    src += n;
 2a4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a6:	fec05ae3          	blez	a2,29a <memmove+0x28>
 2aa:	fff6079b          	addiw	a5,a2,-1
 2ae:	1782                	slli	a5,a5,0x20
 2b0:	9381                	srli	a5,a5,0x20
 2b2:	fff7c793          	not	a5,a5
 2b6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b8:	15fd                	addi	a1,a1,-1
 2ba:	177d                	addi	a4,a4,-1
 2bc:	0005c683          	lbu	a3,0(a1)
 2c0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c4:	fee79ae3          	bne	a5,a4,2b8 <memmove+0x46>
 2c8:	bfc9                	j	29a <memmove+0x28>

00000000000002ca <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e422                	sd	s0,8(sp)
 2ce:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d0:	ca05                	beqz	a2,300 <memcmp+0x36>
 2d2:	fff6069b          	addiw	a3,a2,-1
 2d6:	1682                	slli	a3,a3,0x20
 2d8:	9281                	srli	a3,a3,0x20
 2da:	0685                	addi	a3,a3,1
 2dc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	0005c703          	lbu	a4,0(a1)
 2e6:	00e79863          	bne	a5,a4,2f6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ea:	0505                	addi	a0,a0,1
    p2++;
 2ec:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ee:	fed518e3          	bne	a0,a3,2de <memcmp+0x14>
  }
  return 0;
 2f2:	4501                	li	a0,0
 2f4:	a019                	j	2fa <memcmp+0x30>
      return *p1 - *p2;
 2f6:	40e7853b          	subw	a0,a5,a4
}
 2fa:	6422                	ld	s0,8(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
  return 0;
 300:	4501                	li	a0,0
 302:	bfe5                	j	2fa <memcmp+0x30>

0000000000000304 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30c:	00000097          	auipc	ra,0x0
 310:	f66080e7          	jalr	-154(ra) # 272 <memmove>
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 322:	00054783          	lbu	a5,0(a0)
 326:	cfbd                	beqz	a5,3a4 <inet_addr+0x88>
  int dots = 0;
 328:	4801                	li	a6,0
  int digits = 0;
 32a:	4601                	li	a2,0
  int octet = 0;
 32c:	4681                	li	a3,0
  uint result = 0;
 32e:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 330:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 332:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 336:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 338:	4301                	li	t1,0
      if (octet > 255)
 33a:	0ff00e13          	li	t3,255
 33e:	a015                	j	362 <inet_addr+0x46>
    } else if (*s == '.') {
 340:	07d79463          	bne	a5,t4,3a8 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 344:	c625                	beqz	a2,3ac <inet_addr+0x90>
 346:	07e80563          	beq	a6,t5,3b0 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 34a:	0085959b          	slliw	a1,a1,0x8
 34e:	8ecd                	or	a3,a3,a1
 350:	0006859b          	sext.w	a1,a3
      dots++;
 354:	2805                	addiw	a6,a6,1
      digits = 0;
 356:	861a                	mv	a2,t1
      octet = 0;
 358:	869a                	mv	a3,t1
  for (; *s; s++) {
 35a:	0505                	addi	a0,a0,1
 35c:	00054783          	lbu	a5,0(a0)
 360:	c79d                	beqz	a5,38e <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 362:	fd07871b          	addiw	a4,a5,-48
 366:	0ff77713          	zext.b	a4,a4
 36a:	fce8ebe3          	bltu	a7,a4,340 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 36e:	0026971b          	slliw	a4,a3,0x2
 372:	9f35                	addw	a4,a4,a3
 374:	0017171b          	slliw	a4,a4,0x1
 378:	fd07879b          	addiw	a5,a5,-48
 37c:	00e786bb          	addw	a3,a5,a4
      digits++;
 380:	2605                	addiw	a2,a2,1
      if (octet > 255)
 382:	fcde5ce3          	bge	t3,a3,35a <inet_addr+0x3e>
        return 0;
 386:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
    return 0;
 38e:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 390:	de65                	beqz	a2,388 <inet_addr+0x6c>
 392:	478d                	li	a5,3
 394:	fef81ae3          	bne	a6,a5,388 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 398:	0085959b          	slliw	a1,a1,0x8
 39c:	8ecd                	or	a3,a3,a1
 39e:	0006851b          	sext.w	a0,a3
  return result;
 3a2:	b7dd                	j	388 <inet_addr+0x6c>
    return 0;
 3a4:	4501                	li	a0,0
 3a6:	b7cd                	j	388 <inet_addr+0x6c>
      return 0;
 3a8:	4501                	li	a0,0
 3aa:	bff9                	j	388 <inet_addr+0x6c>
        return 0;
 3ac:	4501                	li	a0,0
 3ae:	bfe9                	j	388 <inet_addr+0x6c>
 3b0:	4501                	li	a0,0
 3b2:	bfd9                	j	388 <inet_addr+0x6c>

00000000000003b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b4:	4885                	li	a7,1
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3bc:	4889                	li	a7,2
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c4:	488d                	li	a7,3
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3cc:	4891                	li	a7,4
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <read>:
.global read
read:
 li a7, SYS_read
 3d4:	4895                	li	a7,5
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <write>:
.global write
write:
 li a7, SYS_write
 3dc:	48c1                	li	a7,16
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <close>:
.global close
close:
 li a7, SYS_close
 3e4:	48d5                	li	a7,21
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ec:	4899                	li	a7,6
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f4:	489d                	li	a7,7
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <open>:
.global open
open:
 li a7, SYS_open
 3fc:	48bd                	li	a7,15
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 404:	48c5                	li	a7,17
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 40c:	48c9                	li	a7,18
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 414:	48a1                	li	a7,8
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <link>:
.global link
link:
 li a7, SYS_link
 41c:	48cd                	li	a7,19
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 424:	48d1                	li	a7,20
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 42c:	48a5                	li	a7,9
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <dup>:
.global dup
dup:
 li a7, SYS_dup
 434:	48a9                	li	a7,10
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 43c:	48ad                	li	a7,11
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 444:	48b1                	li	a7,12
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 44c:	48b5                	li	a7,13
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 454:	48b9                	li	a7,14
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 45c:	48d9                	li	a7,22
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 464:	48dd                	li	a7,23
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 46c:	48e1                	li	a7,24
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 474:	48e5                	li	a7,25
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <socket>:
.global socket
socket:
 li a7, SYS_socket
 47c:	48e9                	li	a7,26
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <bind>:
.global bind
bind:
 li a7, SYS_bind
 484:	48ed                	li	a7,27
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <accept>:
.global accept
accept:
 li a7, SYS_accept
 48c:	48f5                	li	a7,29
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <listen>:
.global listen
listen:
 li a7, SYS_listen
 494:	48f1                	li	a7,28
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <connect>:
.global connect
connect:
 li a7, SYS_connect
 49c:	48f9                	li	a7,30
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <send>:
.global send
send:
 li a7, SYS_send
 4a4:	48fd                	li	a7,31
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <recv>:
.global recv
recv:
 li a7, SYS_recv
 4ac:	02000893          	li	a7,32
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 4b6:	02100893          	li	a7,33
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 4c0:	02200893          	li	a7,34
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ca:	1101                	addi	sp,sp,-32
 4cc:	ec06                	sd	ra,24(sp)
 4ce:	e822                	sd	s0,16(sp)
 4d0:	1000                	addi	s0,sp,32
 4d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4d6:	4605                	li	a2,1
 4d8:	fef40593          	addi	a1,s0,-17
 4dc:	00000097          	auipc	ra,0x0
 4e0:	f00080e7          	jalr	-256(ra) # 3dc <write>
}
 4e4:	60e2                	ld	ra,24(sp)
 4e6:	6442                	ld	s0,16(sp)
 4e8:	6105                	addi	sp,sp,32
 4ea:	8082                	ret

00000000000004ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ec:	7139                	addi	sp,sp,-64
 4ee:	fc06                	sd	ra,56(sp)
 4f0:	f822                	sd	s0,48(sp)
 4f2:	f426                	sd	s1,40(sp)
 4f4:	0080                	addi	s0,sp,64
 4f6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4f8:	c299                	beqz	a3,4fe <printint+0x12>
 4fa:	0805cb63          	bltz	a1,590 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4fe:	2581                	sext.w	a1,a1
  neg = 0;
 500:	4881                	li	a7,0
 502:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 506:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 508:	2601                	sext.w	a2,a2
 50a:	00000517          	auipc	a0,0x0
 50e:	72650513          	addi	a0,a0,1830 # c30 <digits>
 512:	883a                	mv	a6,a4
 514:	2705                	addiw	a4,a4,1
 516:	02c5f7bb          	remuw	a5,a1,a2
 51a:	1782                	slli	a5,a5,0x20
 51c:	9381                	srli	a5,a5,0x20
 51e:	97aa                	add	a5,a5,a0
 520:	0007c783          	lbu	a5,0(a5)
 524:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 528:	0005879b          	sext.w	a5,a1
 52c:	02c5d5bb          	divuw	a1,a1,a2
 530:	0685                	addi	a3,a3,1
 532:	fec7f0e3          	bgeu	a5,a2,512 <printint+0x26>
  if(neg)
 536:	00088c63          	beqz	a7,54e <printint+0x62>
    buf[i++] = '-';
 53a:	fd070793          	addi	a5,a4,-48
 53e:	00878733          	add	a4,a5,s0
 542:	02d00793          	li	a5,45
 546:	fef70823          	sb	a5,-16(a4)
 54a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 54e:	02e05c63          	blez	a4,586 <printint+0x9a>
 552:	f04a                	sd	s2,32(sp)
 554:	ec4e                	sd	s3,24(sp)
 556:	fc040793          	addi	a5,s0,-64
 55a:	00e78933          	add	s2,a5,a4
 55e:	fff78993          	addi	s3,a5,-1
 562:	99ba                	add	s3,s3,a4
 564:	377d                	addiw	a4,a4,-1
 566:	1702                	slli	a4,a4,0x20
 568:	9301                	srli	a4,a4,0x20
 56a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 56e:	fff94583          	lbu	a1,-1(s2)
 572:	8526                	mv	a0,s1
 574:	00000097          	auipc	ra,0x0
 578:	f56080e7          	jalr	-170(ra) # 4ca <putc>
  while(--i >= 0)
 57c:	197d                	addi	s2,s2,-1
 57e:	ff3918e3          	bne	s2,s3,56e <printint+0x82>
 582:	7902                	ld	s2,32(sp)
 584:	69e2                	ld	s3,24(sp)
}
 586:	70e2                	ld	ra,56(sp)
 588:	7442                	ld	s0,48(sp)
 58a:	74a2                	ld	s1,40(sp)
 58c:	6121                	addi	sp,sp,64
 58e:	8082                	ret
    x = -xx;
 590:	40b005bb          	negw	a1,a1
    neg = 1;
 594:	4885                	li	a7,1
    x = -xx;
 596:	b7b5                	j	502 <printint+0x16>

0000000000000598 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 598:	715d                	addi	sp,sp,-80
 59a:	e486                	sd	ra,72(sp)
 59c:	e0a2                	sd	s0,64(sp)
 59e:	f84a                	sd	s2,48(sp)
 5a0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5a2:	0005c903          	lbu	s2,0(a1)
 5a6:	1a090a63          	beqz	s2,75a <vprintf+0x1c2>
 5aa:	fc26                	sd	s1,56(sp)
 5ac:	f44e                	sd	s3,40(sp)
 5ae:	f052                	sd	s4,32(sp)
 5b0:	ec56                	sd	s5,24(sp)
 5b2:	e85a                	sd	s6,16(sp)
 5b4:	e45e                	sd	s7,8(sp)
 5b6:	8aaa                	mv	s5,a0
 5b8:	8bb2                	mv	s7,a2
 5ba:	00158493          	addi	s1,a1,1
  state = 0;
 5be:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5c0:	02500a13          	li	s4,37
 5c4:	4b55                	li	s6,21
 5c6:	a839                	j	5e4 <vprintf+0x4c>
        putc(fd, c);
 5c8:	85ca                	mv	a1,s2
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	efe080e7          	jalr	-258(ra) # 4ca <putc>
 5d4:	a019                	j	5da <vprintf+0x42>
    } else if(state == '%'){
 5d6:	01498d63          	beq	s3,s4,5f0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5da:	0485                	addi	s1,s1,1
 5dc:	fff4c903          	lbu	s2,-1(s1)
 5e0:	16090763          	beqz	s2,74e <vprintf+0x1b6>
    if(state == 0){
 5e4:	fe0999e3          	bnez	s3,5d6 <vprintf+0x3e>
      if(c == '%'){
 5e8:	ff4910e3          	bne	s2,s4,5c8 <vprintf+0x30>
        state = '%';
 5ec:	89d2                	mv	s3,s4
 5ee:	b7f5                	j	5da <vprintf+0x42>
      if(c == 'd'){
 5f0:	13490463          	beq	s2,s4,718 <vprintf+0x180>
 5f4:	f9d9079b          	addiw	a5,s2,-99
 5f8:	0ff7f793          	zext.b	a5,a5
 5fc:	12fb6763          	bltu	s6,a5,72a <vprintf+0x192>
 600:	f9d9079b          	addiw	a5,s2,-99
 604:	0ff7f713          	zext.b	a4,a5
 608:	12eb6163          	bltu	s6,a4,72a <vprintf+0x192>
 60c:	00271793          	slli	a5,a4,0x2
 610:	00000717          	auipc	a4,0x0
 614:	5c870713          	addi	a4,a4,1480 # bd8 <ithread_join+0x88>
 618:	97ba                	add	a5,a5,a4
 61a:	439c                	lw	a5,0(a5)
 61c:	97ba                	add	a5,a5,a4
 61e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 620:	008b8913          	addi	s2,s7,8
 624:	4685                	li	a3,1
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	ebe080e7          	jalr	-322(ra) # 4ec <printint>
 636:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 638:	4981                	li	s3,0
 63a:	b745                	j	5da <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000ba583          	lw	a1,0(s7)
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	ea2080e7          	jalr	-350(ra) # 4ec <printint>
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	b751                	j	5da <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 658:	008b8913          	addi	s2,s7,8
 65c:	4681                	li	a3,0
 65e:	4641                	li	a2,16
 660:	000ba583          	lw	a1,0(s7)
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	e86080e7          	jalr	-378(ra) # 4ec <printint>
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	b7a5                	j	5da <vprintf+0x42>
 674:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 676:	008b8c13          	addi	s8,s7,8
 67a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 67e:	03000593          	li	a1,48
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e46080e7          	jalr	-442(ra) # 4ca <putc>
  putc(fd, 'x');
 68c:	07800593          	li	a1,120
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e38080e7          	jalr	-456(ra) # 4ca <putc>
 69a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69c:	00000b97          	auipc	s7,0x0
 6a0:	594b8b93          	addi	s7,s7,1428 # c30 <digits>
 6a4:	03c9d793          	srli	a5,s3,0x3c
 6a8:	97de                	add	a5,a5,s7
 6aa:	0007c583          	lbu	a1,0(a5)
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e1a080e7          	jalr	-486(ra) # 4ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b8:	0992                	slli	s3,s3,0x4
 6ba:	397d                	addiw	s2,s2,-1
 6bc:	fe0914e3          	bnez	s2,6a4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6c0:	8be2                	mv	s7,s8
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	6c02                	ld	s8,0(sp)
 6c6:	bf11                	j	5da <vprintf+0x42>
        s = va_arg(ap, char*);
 6c8:	008b8993          	addi	s3,s7,8
 6cc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6d0:	02090163          	beqz	s2,6f2 <vprintf+0x15a>
        while(*s != 0){
 6d4:	00094583          	lbu	a1,0(s2)
 6d8:	c9a5                	beqz	a1,748 <vprintf+0x1b0>
          putc(fd, *s);
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	dee080e7          	jalr	-530(ra) # 4ca <putc>
          s++;
 6e4:	0905                	addi	s2,s2,1
        while(*s != 0){
 6e6:	00094583          	lbu	a1,0(s2)
 6ea:	f9e5                	bnez	a1,6da <vprintf+0x142>
        s = va_arg(ap, char*);
 6ec:	8bce                	mv	s7,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b5ed                	j	5da <vprintf+0x42>
          s = "(null)";
 6f2:	00000917          	auipc	s2,0x0
 6f6:	4ae90913          	addi	s2,s2,1198 # ba0 <ithread_join+0x50>
        while(*s != 0){
 6fa:	02800593          	li	a1,40
 6fe:	bff1                	j	6da <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 700:	008b8913          	addi	s2,s7,8
 704:	000bc583          	lbu	a1,0(s7)
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	dc0080e7          	jalr	-576(ra) # 4ca <putc>
 712:	8bca                	mv	s7,s2
      state = 0;
 714:	4981                	li	s3,0
 716:	b5d1                	j	5da <vprintf+0x42>
        putc(fd, c);
 718:	02500593          	li	a1,37
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	dac080e7          	jalr	-596(ra) # 4ca <putc>
      state = 0;
 726:	4981                	li	s3,0
 728:	bd4d                	j	5da <vprintf+0x42>
        putc(fd, '%');
 72a:	02500593          	li	a1,37
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	d9a080e7          	jalr	-614(ra) # 4ca <putc>
        putc(fd, c);
 738:	85ca                	mv	a1,s2
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	d8e080e7          	jalr	-626(ra) # 4ca <putc>
      state = 0;
 744:	4981                	li	s3,0
 746:	bd51                	j	5da <vprintf+0x42>
        s = va_arg(ap, char*);
 748:	8bce                	mv	s7,s3
      state = 0;
 74a:	4981                	li	s3,0
 74c:	b579                	j	5da <vprintf+0x42>
 74e:	74e2                	ld	s1,56(sp)
 750:	79a2                	ld	s3,40(sp)
 752:	7a02                	ld	s4,32(sp)
 754:	6ae2                	ld	s5,24(sp)
 756:	6b42                	ld	s6,16(sp)
 758:	6ba2                	ld	s7,8(sp)
    }
  }
}
 75a:	60a6                	ld	ra,72(sp)
 75c:	6406                	ld	s0,64(sp)
 75e:	7942                	ld	s2,48(sp)
 760:	6161                	addi	sp,sp,80
 762:	8082                	ret

0000000000000764 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 764:	715d                	addi	sp,sp,-80
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e010                	sd	a2,0(s0)
 76e:	e414                	sd	a3,8(s0)
 770:	e818                	sd	a4,16(s0)
 772:	ec1c                	sd	a5,24(s0)
 774:	03043023          	sd	a6,32(s0)
 778:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 780:	8622                	mv	a2,s0
 782:	00000097          	auipc	ra,0x0
 786:	e16080e7          	jalr	-490(ra) # 598 <vprintf>
}
 78a:	60e2                	ld	ra,24(sp)
 78c:	6442                	ld	s0,16(sp)
 78e:	6161                	addi	sp,sp,80
 790:	8082                	ret

0000000000000792 <printf>:

void
printf(const char *fmt, ...)
{
 792:	711d                	addi	sp,sp,-96
 794:	ec06                	sd	ra,24(sp)
 796:	e822                	sd	s0,16(sp)
 798:	1000                	addi	s0,sp,32
 79a:	e40c                	sd	a1,8(s0)
 79c:	e810                	sd	a2,16(s0)
 79e:	ec14                	sd	a3,24(s0)
 7a0:	f018                	sd	a4,32(s0)
 7a2:	f41c                	sd	a5,40(s0)
 7a4:	03043823          	sd	a6,48(s0)
 7a8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ac:	00840613          	addi	a2,s0,8
 7b0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7b4:	85aa                	mv	a1,a0
 7b6:	4505                	li	a0,1
 7b8:	00000097          	auipc	ra,0x0
 7bc:	de0080e7          	jalr	-544(ra) # 598 <vprintf>
}
 7c0:	60e2                	ld	ra,24(sp)
 7c2:	6442                	ld	s0,16(sp)
 7c4:	6125                	addi	sp,sp,96
 7c6:	8082                	ret

00000000000007c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c8:	1141                	addi	sp,sp,-16
 7ca:	e422                	sd	s0,8(sp)
 7cc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ce:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d2:	00001797          	auipc	a5,0x1
 7d6:	83e7b783          	ld	a5,-1986(a5) # 1010 <freep>
 7da:	a02d                	j	804 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7dc:	4618                	lw	a4,8(a2)
 7de:	9f2d                	addw	a4,a4,a1
 7e0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e4:	6398                	ld	a4,0(a5)
 7e6:	6310                	ld	a2,0(a4)
 7e8:	a83d                	j	826 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ea:	ff852703          	lw	a4,-8(a0)
 7ee:	9f31                	addw	a4,a4,a2
 7f0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f2:	ff053683          	ld	a3,-16(a0)
 7f6:	a091                	j	83a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	6398                	ld	a4,0(a5)
 7fa:	00e7e463          	bltu	a5,a4,802 <free+0x3a>
 7fe:	00e6ea63          	bltu	a3,a4,812 <free+0x4a>
{
 802:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 804:	fed7fae3          	bgeu	a5,a3,7f8 <free+0x30>
 808:	6398                	ld	a4,0(a5)
 80a:	00e6e463          	bltu	a3,a4,812 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80e:	fee7eae3          	bltu	a5,a4,802 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 812:	ff852583          	lw	a1,-8(a0)
 816:	6390                	ld	a2,0(a5)
 818:	02059813          	slli	a6,a1,0x20
 81c:	01c85713          	srli	a4,a6,0x1c
 820:	9736                	add	a4,a4,a3
 822:	fae60de3          	beq	a2,a4,7dc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 82a:	4790                	lw	a2,8(a5)
 82c:	02061593          	slli	a1,a2,0x20
 830:	01c5d713          	srli	a4,a1,0x1c
 834:	973e                	add	a4,a4,a5
 836:	fae68ae3          	beq	a3,a4,7ea <free+0x22>
    p->s.ptr = bp->s.ptr;
 83a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 83c:	00000717          	auipc	a4,0x0
 840:	7cf73a23          	sd	a5,2004(a4) # 1010 <freep>
}
 844:	6422                	ld	s0,8(sp)
 846:	0141                	addi	sp,sp,16
 848:	8082                	ret

000000000000084a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 84a:	7139                	addi	sp,sp,-64
 84c:	fc06                	sd	ra,56(sp)
 84e:	f822                	sd	s0,48(sp)
 850:	f426                	sd	s1,40(sp)
 852:	ec4e                	sd	s3,24(sp)
 854:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 856:	02051493          	slli	s1,a0,0x20
 85a:	9081                	srli	s1,s1,0x20
 85c:	04bd                	addi	s1,s1,15
 85e:	8091                	srli	s1,s1,0x4
 860:	0014899b          	addiw	s3,s1,1
 864:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 866:	00000517          	auipc	a0,0x0
 86a:	7aa53503          	ld	a0,1962(a0) # 1010 <freep>
 86e:	c915                	beqz	a0,8a2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 872:	4798                	lw	a4,8(a5)
 874:	08977e63          	bgeu	a4,s1,910 <malloc+0xc6>
 878:	f04a                	sd	s2,32(sp)
 87a:	e852                	sd	s4,16(sp)
 87c:	e456                	sd	s5,8(sp)
 87e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 880:	8a4e                	mv	s4,s3
 882:	0009871b          	sext.w	a4,s3
 886:	6685                	lui	a3,0x1
 888:	00d77363          	bgeu	a4,a3,88e <malloc+0x44>
 88c:	6a05                	lui	s4,0x1
 88e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 892:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 896:	00000917          	auipc	s2,0x0
 89a:	77a90913          	addi	s2,s2,1914 # 1010 <freep>
  if(p == (char*)-1)
 89e:	5afd                	li	s5,-1
 8a0:	a091                	j	8e4 <malloc+0x9a>
 8a2:	f04a                	sd	s2,32(sp)
 8a4:	e852                	sd	s4,16(sp)
 8a6:	e456                	sd	s5,8(sp)
 8a8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8aa:	00000797          	auipc	a5,0x0
 8ae:	78678793          	addi	a5,a5,1926 # 1030 <base>
 8b2:	00000717          	auipc	a4,0x0
 8b6:	74f73f23          	sd	a5,1886(a4) # 1010 <freep>
 8ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8bc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c0:	b7c1                	j	880 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8c2:	6398                	ld	a4,0(a5)
 8c4:	e118                	sd	a4,0(a0)
 8c6:	a08d                	j	928 <malloc+0xde>
  hp->s.size = nu;
 8c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8cc:	0541                	addi	a0,a0,16
 8ce:	00000097          	auipc	ra,0x0
 8d2:	efa080e7          	jalr	-262(ra) # 7c8 <free>
  return freep;
 8d6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8da:	c13d                	beqz	a0,940 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8de:	4798                	lw	a4,8(a5)
 8e0:	02977463          	bgeu	a4,s1,908 <malloc+0xbe>
    if(p == freep)
 8e4:	00093703          	ld	a4,0(s2)
 8e8:	853e                	mv	a0,a5
 8ea:	fef719e3          	bne	a4,a5,8dc <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 8ee:	8552                	mv	a0,s4
 8f0:	00000097          	auipc	ra,0x0
 8f4:	b54080e7          	jalr	-1196(ra) # 444 <sbrk>
  if(p == (char*)-1)
 8f8:	fd5518e3          	bne	a0,s5,8c8 <malloc+0x7e>
        return 0;
 8fc:	4501                	li	a0,0
 8fe:	7902                	ld	s2,32(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
 906:	a03d                	j	934 <malloc+0xea>
 908:	7902                	ld	s2,32(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 910:	fae489e3          	beq	s1,a4,8c2 <malloc+0x78>
        p->s.size -= nunits;
 914:	4137073b          	subw	a4,a4,s3
 918:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91a:	02071693          	slli	a3,a4,0x20
 91e:	01c6d713          	srli	a4,a3,0x1c
 922:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 924:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 928:	00000717          	auipc	a4,0x0
 92c:	6ea73423          	sd	a0,1768(a4) # 1010 <freep>
      return (void*)(p + 1);
 930:	01078513          	addi	a0,a5,16
  }
}
 934:	70e2                	ld	ra,56(sp)
 936:	7442                	ld	s0,48(sp)
 938:	74a2                	ld	s1,40(sp)
 93a:	69e2                	ld	s3,24(sp)
 93c:	6121                	addi	sp,sp,64
 93e:	8082                	ret
 940:	7902                	ld	s2,32(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
 948:	b7f5                	j	934 <malloc+0xea>

000000000000094a <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 94a:	1141                	addi	sp,sp,-16
 94c:	e406                	sd	ra,8(sp)
 94e:	e022                	sd	s0,0(sp)
 950:	0800                	addi	s0,sp,16
  thread_exit(status);
 952:	2501                	sext.w	a0,a0
 954:	00000097          	auipc	ra,0x0
 958:	b20080e7          	jalr	-1248(ra) # 474 <thread_exit>
}
 95c:	60a2                	ld	ra,8(sp)
 95e:	6402                	ld	s0,0(sp)
 960:	0141                	addi	sp,sp,16
 962:	8082                	ret

0000000000000964 <free_stacks>:
int free_stacks() {
 964:	7179                	addi	sp,sp,-48
 966:	f406                	sd	ra,40(sp)
 968:	f022                	sd	s0,32(sp)
 96a:	ec26                	sd	s1,24(sp)
 96c:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 96e:	00000797          	auipc	a5,0x0
 972:	6b27a783          	lw	a5,1714(a5) # 1020 <num_threads>
 976:	04f05063          	blez	a5,9b6 <free_stacks+0x52>
 97a:	e84a                	sd	s2,16(sp)
 97c:	e44e                	sd	s3,8(sp)
 97e:	4481                	li	s1,0
    free(stacks[i]);
 980:	00000997          	auipc	s3,0x0
 984:	69898993          	addi	s3,s3,1688 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 988:	00000917          	auipc	s2,0x0
 98c:	69890913          	addi	s2,s2,1688 # 1020 <num_threads>
    free(stacks[i]);
 990:	0009b783          	ld	a5,0(s3)
 994:	00349713          	slli	a4,s1,0x3
 998:	97ba                	add	a5,a5,a4
 99a:	6388                	ld	a0,0(a5)
 99c:	00000097          	auipc	ra,0x0
 9a0:	e2c080e7          	jalr	-468(ra) # 7c8 <free>
  for (int i = 0; i < num_threads; i++) {
 9a4:	0485                	addi	s1,s1,1
 9a6:	00092703          	lw	a4,0(s2)
 9aa:	0004879b          	sext.w	a5,s1
 9ae:	fee7c1e3          	blt	a5,a4,990 <free_stacks+0x2c>
 9b2:	6942                	ld	s2,16(sp)
 9b4:	69a2                	ld	s3,8(sp)
  free(stacks);
 9b6:	00000497          	auipc	s1,0x0
 9ba:	66248493          	addi	s1,s1,1634 # 1018 <stacks>
 9be:	6088                	ld	a0,0(s1)
 9c0:	00000097          	auipc	ra,0x0
 9c4:	e08080e7          	jalr	-504(ra) # 7c8 <free>
  stacks = 0;
 9c8:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9cc:	00000797          	auipc	a5,0x0
 9d0:	6407aa23          	sw	zero,1620(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9d4:	47a1                	li	a5,8
 9d6:	00000717          	auipc	a4,0x0
 9da:	62f72523          	sw	a5,1578(a4) # 1000 <max_stacks>
  threads_done = 0;
 9de:	00000797          	auipc	a5,0x0
 9e2:	6407a323          	sw	zero,1606(a5) # 1024 <threads_done>
}
 9e6:	4501                	li	a0,0
 9e8:	70a2                	ld	ra,40(sp)
 9ea:	7402                	ld	s0,32(sp)
 9ec:	64e2                	ld	s1,24(sp)
 9ee:	6145                	addi	sp,sp,48
 9f0:	8082                	ret

00000000000009f2 <expand_num_threads>:
int expand_num_threads() {
 9f2:	1101                	addi	sp,sp,-32
 9f4:	ec06                	sd	ra,24(sp)
 9f6:	e822                	sd	s0,16(sp)
 9f8:	e426                	sd	s1,8(sp)
 9fa:	e04a                	sd	s2,0(sp)
 9fc:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9fe:	00000797          	auipc	a5,0x0
 a02:	60278793          	addi	a5,a5,1538 # 1000 <max_stacks>
 a06:	4388                	lw	a0,0(a5)
 a08:	0015151b          	slliw	a0,a0,0x1
 a0c:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a0e:	0035151b          	slliw	a0,a0,0x3
 a12:	00000097          	auipc	ra,0x0
 a16:	e38080e7          	jalr	-456(ra) # 84a <malloc>
 a1a:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a1c:	00000617          	auipc	a2,0x0
 a20:	60462603          	lw	a2,1540(a2) # 1020 <num_threads>
 a24:	00000497          	auipc	s1,0x0
 a28:	5f448493          	addi	s1,s1,1524 # 1018 <stacks>
 a2c:	0036161b          	slliw	a2,a2,0x3
 a30:	608c                	ld	a1,0(s1)
 a32:	00000097          	auipc	ra,0x0
 a36:	840080e7          	jalr	-1984(ra) # 272 <memmove>
  free(stacks);
 a3a:	6088                	ld	a0,0(s1)
 a3c:	00000097          	auipc	ra,0x0
 a40:	d8c080e7          	jalr	-628(ra) # 7c8 <free>
  stacks = new_stacks;
 a44:	0124b023          	sd	s2,0(s1)
}
 a48:	4501                	li	a0,0
 a4a:	60e2                	ld	ra,24(sp)
 a4c:	6442                	ld	s0,16(sp)
 a4e:	64a2                	ld	s1,8(sp)
 a50:	6902                	ld	s2,0(sp)
 a52:	6105                	addi	sp,sp,32
 a54:	8082                	ret

0000000000000a56 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a56:	7179                	addi	sp,sp,-48
 a58:	f406                	sd	ra,40(sp)
 a5a:	f022                	sd	s0,32(sp)
 a5c:	e84a                	sd	s2,16(sp)
 a5e:	e44e                	sd	s3,8(sp)
 a60:	1800                	addi	s0,sp,48
 a62:	892a                	mv	s2,a0
 a64:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a66:	00000797          	auipc	a5,0x0
 a6a:	5b27b783          	ld	a5,1458(a5) # 1018 <stacks>
 a6e:	c3d9                	beqz	a5,af4 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a70:	00000797          	auipc	a5,0x0
 a74:	5907a783          	lw	a5,1424(a5) # 1000 <max_stacks>
 a78:	00000717          	auipc	a4,0x0
 a7c:	5a872703          	lw	a4,1448(a4) # 1020 <num_threads>
 a80:	0af71363          	bne	a4,a5,b26 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 a84:	04000713          	li	a4,64
 a88:	08e78563          	beq	a5,a4,b12 <ithread_create+0xbc>
 a8c:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a8e:	00000097          	auipc	ra,0x0
 a92:	f64080e7          	jalr	-156(ra) # 9f2 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a96:	6505                	lui	a0,0x1
 a98:	00000097          	auipc	ra,0x0
 a9c:	db2080e7          	jalr	-590(ra) # 84a <malloc>
 aa0:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 aa2:	00000717          	auipc	a4,0x0
 aa6:	57e72703          	lw	a4,1406(a4) # 1020 <num_threads>
 aaa:	070e                	slli	a4,a4,0x3
 aac:	00000797          	auipc	a5,0x0
 ab0:	56c7b783          	ld	a5,1388(a5) # 1018 <stacks>
 ab4:	97ba                	add	a5,a5,a4
 ab6:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 ab8:	00000697          	auipc	a3,0x0
 abc:	e9268693          	addi	a3,a3,-366 # 94a <ithread_exit>
 ac0:	862a                	mv	a2,a0
 ac2:	85ce                	mv	a1,s3
 ac4:	854a                	mv	a0,s2
 ac6:	00000097          	auipc	ra,0x0
 aca:	99e080e7          	jalr	-1634(ra) # 464 <create_thread>
 ace:	892a                	mv	s2,a0
  if (res != -1) {
 ad0:	57fd                	li	a5,-1
 ad2:	04f50c63          	beq	a0,a5,b2a <ithread_create+0xd4>
    num_threads++;
 ad6:	00000717          	auipc	a4,0x0
 ada:	54a70713          	addi	a4,a4,1354 # 1020 <num_threads>
 ade:	431c                	lw	a5,0(a4)
 ae0:	2785                	addiw	a5,a5,1
 ae2:	c31c                	sw	a5,0(a4)
 ae4:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 ae6:	854a                	mv	a0,s2
 ae8:	70a2                	ld	ra,40(sp)
 aea:	7402                	ld	s0,32(sp)
 aec:	6942                	ld	s2,16(sp)
 aee:	69a2                	ld	s3,8(sp)
 af0:	6145                	addi	sp,sp,48
 af2:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 af4:	00000517          	auipc	a0,0x0
 af8:	50c52503          	lw	a0,1292(a0) # 1000 <max_stacks>
 afc:	0035151b          	slliw	a0,a0,0x3
 b00:	00000097          	auipc	ra,0x0
 b04:	d4a080e7          	jalr	-694(ra) # 84a <malloc>
 b08:	00000797          	auipc	a5,0x0
 b0c:	50a7b823          	sd	a0,1296(a5) # 1018 <stacks>
 b10:	b785                	j	a70 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b12:	00000517          	auipc	a0,0x0
 b16:	09650513          	addi	a0,a0,150 # ba8 <ithread_join+0x58>
 b1a:	00000097          	auipc	ra,0x0
 b1e:	c78080e7          	jalr	-904(ra) # 792 <printf>
      return -1;
 b22:	597d                	li	s2,-1
 b24:	b7c9                	j	ae6 <ithread_create+0x90>
 b26:	ec26                	sd	s1,24(sp)
 b28:	b7bd                	j	a96 <ithread_create+0x40>
    free(stack_ptr);
 b2a:	8526                	mv	a0,s1
 b2c:	00000097          	auipc	ra,0x0
 b30:	c9c080e7          	jalr	-868(ra) # 7c8 <free>
    stacks[num_threads] = 0;
 b34:	00000717          	auipc	a4,0x0
 b38:	4ec72703          	lw	a4,1260(a4) # 1020 <num_threads>
 b3c:	070e                	slli	a4,a4,0x3
 b3e:	00000797          	auipc	a5,0x0
 b42:	4da7b783          	ld	a5,1242(a5) # 1018 <stacks>
 b46:	97ba                	add	a5,a5,a4
 b48:	0007b023          	sd	zero,0(a5)
 b4c:	64e2                	ld	s1,24(sp)
 b4e:	bf61                	j	ae6 <ithread_create+0x90>

0000000000000b50 <ithread_join>:

int ithread_join(int thread_id) {
 b50:	1101                	addi	sp,sp,-32
 b52:	ec06                	sd	ra,24(sp)
 b54:	e822                	sd	s0,16(sp)
 b56:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b58:	ff040793          	addi	a5,s0,-16
 b5c:	ffc7859b          	addiw	a1,a5,-4
 b60:	00000097          	auipc	ra,0x0
 b64:	90c080e7          	jalr	-1780(ra) # 46c <join_thread>
  threads_done++;
 b68:	00000717          	auipc	a4,0x0
 b6c:	4bc70713          	addi	a4,a4,1212 # 1024 <threads_done>
 b70:	431c                	lw	a5,0(a4)
 b72:	2785                	addiw	a5,a5,1
 b74:	0007869b          	sext.w	a3,a5
 b78:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b7a:	00000797          	auipc	a5,0x0
 b7e:	4a67a783          	lw	a5,1190(a5) # 1020 <num_threads>
 b82:	00d78863          	beq	a5,a3,b92 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 b86:	fec42503          	lw	a0,-20(s0)
 b8a:	60e2                	ld	ra,24(sp)
 b8c:	6442                	ld	s0,16(sp)
 b8e:	6105                	addi	sp,sp,32
 b90:	8082                	ret
    free_stacks();
 b92:	00000097          	auipc	ra,0x0
 b96:	dd2080e7          	jalr	-558(ra) # 964 <free_stacks>
 b9a:	b7f5                	j	b86 <ithread_join+0x36>
