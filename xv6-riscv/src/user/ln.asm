
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
  14:	bd058593          	addi	a1,a1,-1072 # be0 <ithread_join+0x58>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	782080e7          	jalr	1922(ra) # 79c <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	3d0080e7          	jalr	976(ra) # 3f4 <exit>
  2c:	e426                	sd	s1,8(sp)
  2e:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  30:	698c                	ld	a1,16(a1)
  32:	6488                	ld	a0,8(s1)
  34:	00000097          	auipc	ra,0x0
  38:	420080e7          	jalr	1056(ra) # 454 <link>
  3c:	00054763          	bltz	a0,4a <main+0x4a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	3b2080e7          	jalr	946(ra) # 3f4 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4a:	6894                	ld	a3,16(s1)
  4c:	6490                	ld	a2,8(s1)
  4e:	00001597          	auipc	a1,0x1
  52:	baa58593          	addi	a1,a1,-1110 # bf8 <ithread_join+0x70>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	744080e7          	jalr	1860(ra) # 79c <fprintf>
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
  78:	380080e7          	jalr	896(ra) # 3f4 <exit>

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
 16a:	2a6080e7          	jalr	678(ra) # 40c <read>
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

00000000000001a8 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 1a8:	711d                	addi	sp,sp,-96
 1aa:	ec86                	sd	ra,88(sp)
 1ac:	e8a2                	sd	s0,80(sp)
 1ae:	e4a6                	sd	s1,72(sp)
 1b0:	e0ca                	sd	s2,64(sp)
 1b2:	fc4e                	sd	s3,56(sp)
 1b4:	f852                	sd	s4,48(sp)
 1b6:	f456                	sd	s5,40(sp)
 1b8:	f05a                	sd	s6,32(sp)
 1ba:	ec5e                	sd	s7,24(sp)
 1bc:	1080                	addi	s0,sp,96
 1be:	8baa                	mv	s7,a0
 1c0:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 1c2:	892a                	mv	s2,a0
 1c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c6:	4aa9                	li	s5,10
 1c8:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 1ca:	8a26                	mv	s4,s1
 1cc:	2485                	addiw	s1,s1,1
 1ce:	0334d863          	bge	s1,s3,1fe <fgetstdin+0x56>
    cc = read(0, &c, 1);
 1d2:	4605                	li	a2,1
 1d4:	faf40593          	addi	a1,s0,-81
 1d8:	4501                	li	a0,0
 1da:	00000097          	auipc	ra,0x0
 1de:	232080e7          	jalr	562(ra) # 40c <read>
    if(cc < 1)
 1e2:	00a05e63          	blez	a0,1fe <fgetstdin+0x56>
    buf[i++] = c;
 1e6:	faf44783          	lbu	a5,-81(s0)
 1ea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ee:	01578763          	beq	a5,s5,1fc <fgetstdin+0x54>
 1f2:	0905                	addi	s2,s2,1
 1f4:	fd679be3          	bne	a5,s6,1ca <fgetstdin+0x22>
    buf[i++] = c;
 1f8:	8a26                	mv	s4,s1
 1fa:	a011                	j	1fe <fgetstdin+0x56>
 1fc:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 1fe:	9bd2                	add	s7,s7,s4
 200:	000b8023          	sb	zero,0(s7)
  return i;
}
 204:	8552                	mv	a0,s4
 206:	60e6                	ld	ra,88(sp)
 208:	6446                	ld	s0,80(sp)
 20a:	64a6                	ld	s1,72(sp)
 20c:	6906                	ld	s2,64(sp)
 20e:	79e2                	ld	s3,56(sp)
 210:	7a42                	ld	s4,48(sp)
 212:	7aa2                	ld	s5,40(sp)
 214:	7b02                	ld	s6,32(sp)
 216:	6be2                	ld	s7,24(sp)
 218:	6125                	addi	sp,sp,96
 21a:	8082                	ret

000000000000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	1101                	addi	sp,sp,-32
 21e:	ec06                	sd	ra,24(sp)
 220:	e822                	sd	s0,16(sp)
 222:	e04a                	sd	s2,0(sp)
 224:	1000                	addi	s0,sp,32
 226:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 228:	4581                	li	a1,0
 22a:	00000097          	auipc	ra,0x0
 22e:	20a080e7          	jalr	522(ra) # 434 <open>
  if(fd < 0)
 232:	02054663          	bltz	a0,25e <stat+0x42>
 236:	e426                	sd	s1,8(sp)
 238:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23a:	85ca                	mv	a1,s2
 23c:	00000097          	auipc	ra,0x0
 240:	210080e7          	jalr	528(ra) # 44c <fstat>
 244:	892a                	mv	s2,a0
  close(fd);
 246:	8526                	mv	a0,s1
 248:	00000097          	auipc	ra,0x0
 24c:	1d4080e7          	jalr	468(ra) # 41c <close>
  return r;
 250:	64a2                	ld	s1,8(sp)
}
 252:	854a                	mv	a0,s2
 254:	60e2                	ld	ra,24(sp)
 256:	6442                	ld	s0,16(sp)
 258:	6902                	ld	s2,0(sp)
 25a:	6105                	addi	sp,sp,32
 25c:	8082                	ret
    return -1;
 25e:	597d                	li	s2,-1
 260:	bfcd                	j	252 <stat+0x36>

0000000000000262 <atoi>:

int
atoi(const char *s)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 268:	00054683          	lbu	a3,0(a0)
 26c:	fd06879b          	addiw	a5,a3,-48
 270:	0ff7f793          	zext.b	a5,a5
 274:	4625                	li	a2,9
 276:	02f66863          	bltu	a2,a5,2a6 <atoi+0x44>
 27a:	872a                	mv	a4,a0
  n = 0;
 27c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 27e:	0705                	addi	a4,a4,1
 280:	0025179b          	slliw	a5,a0,0x2
 284:	9fa9                	addw	a5,a5,a0
 286:	0017979b          	slliw	a5,a5,0x1
 28a:	9fb5                	addw	a5,a5,a3
 28c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 290:	00074683          	lbu	a3,0(a4)
 294:	fd06879b          	addiw	a5,a3,-48
 298:	0ff7f793          	zext.b	a5,a5
 29c:	fef671e3          	bgeu	a2,a5,27e <atoi+0x1c>
  return n;
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
  n = 0;
 2a6:	4501                	li	a0,0
 2a8:	bfe5                	j	2a0 <atoi+0x3e>

00000000000002aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b0:	02b57463          	bgeu	a0,a1,2d8 <memmove+0x2e>
    while(n-- > 0)
 2b4:	00c05f63          	blez	a2,2d2 <memmove+0x28>
 2b8:	1602                	slli	a2,a2,0x20
 2ba:	9201                	srli	a2,a2,0x20
 2bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c2:	0585                	addi	a1,a1,1
 2c4:	0705                	addi	a4,a4,1
 2c6:	fff5c683          	lbu	a3,-1(a1)
 2ca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ce:	fef71ae3          	bne	a4,a5,2c2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
    dst += n;
 2d8:	00c50733          	add	a4,a0,a2
    src += n;
 2dc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2de:	fec05ae3          	blez	a2,2d2 <memmove+0x28>
 2e2:	fff6079b          	addiw	a5,a2,-1
 2e6:	1782                	slli	a5,a5,0x20
 2e8:	9381                	srli	a5,a5,0x20
 2ea:	fff7c793          	not	a5,a5
 2ee:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f0:	15fd                	addi	a1,a1,-1
 2f2:	177d                	addi	a4,a4,-1
 2f4:	0005c683          	lbu	a3,0(a1)
 2f8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2fc:	fee79ae3          	bne	a5,a4,2f0 <memmove+0x46>
 300:	bfc9                	j	2d2 <memmove+0x28>

0000000000000302 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 308:	ca05                	beqz	a2,338 <memcmp+0x36>
 30a:	fff6069b          	addiw	a3,a2,-1
 30e:	1682                	slli	a3,a3,0x20
 310:	9281                	srli	a3,a3,0x20
 312:	0685                	addi	a3,a3,1
 314:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 316:	00054783          	lbu	a5,0(a0)
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00e79863          	bne	a5,a4,32e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 322:	0505                	addi	a0,a0,1
    p2++;
 324:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 326:	fed518e3          	bne	a0,a3,316 <memcmp+0x14>
  }
  return 0;
 32a:	4501                	li	a0,0
 32c:	a019                	j	332 <memcmp+0x30>
      return *p1 - *p2;
 32e:	40e7853b          	subw	a0,a5,a4
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret
  return 0;
 338:	4501                	li	a0,0
 33a:	bfe5                	j	332 <memcmp+0x30>

000000000000033c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e406                	sd	ra,8(sp)
 340:	e022                	sd	s0,0(sp)
 342:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 344:	00000097          	auipc	ra,0x0
 348:	f66080e7          	jalr	-154(ra) # 2aa <memmove>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 354:	1141                	addi	sp,sp,-16
 356:	e422                	sd	s0,8(sp)
 358:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 35a:	00054783          	lbu	a5,0(a0)
 35e:	cfbd                	beqz	a5,3dc <inet_addr+0x88>
  int dots = 0;
 360:	4801                	li	a6,0
  int digits = 0;
 362:	4601                	li	a2,0
  int octet = 0;
 364:	4681                	li	a3,0
  uint result = 0;
 366:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 368:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 36a:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 36e:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 370:	4301                	li	t1,0
      if (octet > 255)
 372:	0ff00e13          	li	t3,255
 376:	a015                	j	39a <inet_addr+0x46>
    } else if (*s == '.') {
 378:	07d79463          	bne	a5,t4,3e0 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 37c:	c625                	beqz	a2,3e4 <inet_addr+0x90>
 37e:	07e80563          	beq	a6,t5,3e8 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 382:	0085959b          	slliw	a1,a1,0x8
 386:	8ecd                	or	a3,a3,a1
 388:	0006859b          	sext.w	a1,a3
      dots++;
 38c:	2805                	addiw	a6,a6,1
      digits = 0;
 38e:	861a                	mv	a2,t1
      octet = 0;
 390:	869a                	mv	a3,t1
  for (; *s; s++) {
 392:	0505                	addi	a0,a0,1
 394:	00054783          	lbu	a5,0(a0)
 398:	c79d                	beqz	a5,3c6 <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 39a:	fd07871b          	addiw	a4,a5,-48
 39e:	0ff77713          	zext.b	a4,a4
 3a2:	fce8ebe3          	bltu	a7,a4,378 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 3a6:	0026971b          	slliw	a4,a3,0x2
 3aa:	9f35                	addw	a4,a4,a3
 3ac:	0017171b          	slliw	a4,a4,0x1
 3b0:	fd07879b          	addiw	a5,a5,-48
 3b4:	00e786bb          	addw	a3,a5,a4
      digits++;
 3b8:	2605                	addiw	a2,a2,1
      if (octet > 255)
 3ba:	fcde5ce3          	bge	t3,a3,392 <inet_addr+0x3e>
        return 0;
 3be:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
    return 0;
 3c6:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 3c8:	de65                	beqz	a2,3c0 <inet_addr+0x6c>
 3ca:	478d                	li	a5,3
 3cc:	fef81ae3          	bne	a6,a5,3c0 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 3d0:	0085959b          	slliw	a1,a1,0x8
 3d4:	8ecd                	or	a3,a3,a1
 3d6:	0006851b          	sext.w	a0,a3
  return result;
 3da:	b7dd                	j	3c0 <inet_addr+0x6c>
    return 0;
 3dc:	4501                	li	a0,0
 3de:	b7cd                	j	3c0 <inet_addr+0x6c>
      return 0;
 3e0:	4501                	li	a0,0
 3e2:	bff9                	j	3c0 <inet_addr+0x6c>
        return 0;
 3e4:	4501                	li	a0,0
 3e6:	bfe9                	j	3c0 <inet_addr+0x6c>
 3e8:	4501                	li	a0,0
 3ea:	bfd9                	j	3c0 <inet_addr+0x6c>

00000000000003ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ec:	4885                	li	a7,1
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f4:	4889                	li	a7,2
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3fc:	488d                	li	a7,3
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 404:	4891                	li	a7,4
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <read>:
.global read
read:
 li a7, SYS_read
 40c:	4895                	li	a7,5
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <write>:
.global write
write:
 li a7, SYS_write
 414:	48c1                	li	a7,16
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <close>:
.global close
close:
 li a7, SYS_close
 41c:	48d5                	li	a7,21
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <kill>:
.global kill
kill:
 li a7, SYS_kill
 424:	4899                	li	a7,6
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <exec>:
.global exec
exec:
 li a7, SYS_exec
 42c:	489d                	li	a7,7
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <open>:
.global open
open:
 li a7, SYS_open
 434:	48bd                	li	a7,15
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 43c:	48c5                	li	a7,17
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 444:	48c9                	li	a7,18
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 44c:	48a1                	li	a7,8
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <link>:
.global link
link:
 li a7, SYS_link
 454:	48cd                	li	a7,19
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 45c:	48d1                	li	a7,20
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 464:	48a5                	li	a7,9
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <dup>:
.global dup
dup:
 li a7, SYS_dup
 46c:	48a9                	li	a7,10
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 474:	48ad                	li	a7,11
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 47c:	48b1                	li	a7,12
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 484:	48b5                	li	a7,13
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 48c:	48b9                	li	a7,14
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 494:	48d9                	li	a7,22
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 49c:	48dd                	li	a7,23
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 4a4:	48e1                	li	a7,24
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 4ac:	48e5                	li	a7,25
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <socket>:
.global socket
socket:
 li a7, SYS_socket
 4b4:	48e9                	li	a7,26
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <bind>:
.global bind
bind:
 li a7, SYS_bind
 4bc:	48ed                	li	a7,27
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <accept>:
.global accept
accept:
 li a7, SYS_accept
 4c4:	48f5                	li	a7,29
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <listen>:
.global listen
listen:
 li a7, SYS_listen
 4cc:	48f1                	li	a7,28
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4d4:	48f9                	li	a7,30
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <send>:
.global send
send:
 li a7, SYS_send
 4dc:	48fd                	li	a7,31
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <recv>:
.global recv
recv:
 li a7, SYS_recv
 4e4:	02000893          	li	a7,32
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 4ee:	02100893          	li	a7,33
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 4f8:	02200893          	li	a7,34
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 502:	1101                	addi	sp,sp,-32
 504:	ec06                	sd	ra,24(sp)
 506:	e822                	sd	s0,16(sp)
 508:	1000                	addi	s0,sp,32
 50a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 50e:	4605                	li	a2,1
 510:	fef40593          	addi	a1,s0,-17
 514:	00000097          	auipc	ra,0x0
 518:	f00080e7          	jalr	-256(ra) # 414 <write>
}
 51c:	60e2                	ld	ra,24(sp)
 51e:	6442                	ld	s0,16(sp)
 520:	6105                	addi	sp,sp,32
 522:	8082                	ret

0000000000000524 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 524:	7139                	addi	sp,sp,-64
 526:	fc06                	sd	ra,56(sp)
 528:	f822                	sd	s0,48(sp)
 52a:	f426                	sd	s1,40(sp)
 52c:	0080                	addi	s0,sp,64
 52e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 530:	c299                	beqz	a3,536 <printint+0x12>
 532:	0805cb63          	bltz	a1,5c8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 536:	2581                	sext.w	a1,a1
  neg = 0;
 538:	4881                	li	a7,0
 53a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 53e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 540:	2601                	sext.w	a2,a2
 542:	00000517          	auipc	a0,0x0
 546:	75e50513          	addi	a0,a0,1886 # ca0 <digits>
 54a:	883a                	mv	a6,a4
 54c:	2705                	addiw	a4,a4,1
 54e:	02c5f7bb          	remuw	a5,a1,a2
 552:	1782                	slli	a5,a5,0x20
 554:	9381                	srli	a5,a5,0x20
 556:	97aa                	add	a5,a5,a0
 558:	0007c783          	lbu	a5,0(a5)
 55c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 560:	0005879b          	sext.w	a5,a1
 564:	02c5d5bb          	divuw	a1,a1,a2
 568:	0685                	addi	a3,a3,1
 56a:	fec7f0e3          	bgeu	a5,a2,54a <printint+0x26>
  if(neg)
 56e:	00088c63          	beqz	a7,586 <printint+0x62>
    buf[i++] = '-';
 572:	fd070793          	addi	a5,a4,-48
 576:	00878733          	add	a4,a5,s0
 57a:	02d00793          	li	a5,45
 57e:	fef70823          	sb	a5,-16(a4)
 582:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 586:	02e05c63          	blez	a4,5be <printint+0x9a>
 58a:	f04a                	sd	s2,32(sp)
 58c:	ec4e                	sd	s3,24(sp)
 58e:	fc040793          	addi	a5,s0,-64
 592:	00e78933          	add	s2,a5,a4
 596:	fff78993          	addi	s3,a5,-1
 59a:	99ba                	add	s3,s3,a4
 59c:	377d                	addiw	a4,a4,-1
 59e:	1702                	slli	a4,a4,0x20
 5a0:	9301                	srli	a4,a4,0x20
 5a2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5a6:	fff94583          	lbu	a1,-1(s2)
 5aa:	8526                	mv	a0,s1
 5ac:	00000097          	auipc	ra,0x0
 5b0:	f56080e7          	jalr	-170(ra) # 502 <putc>
  while(--i >= 0)
 5b4:	197d                	addi	s2,s2,-1
 5b6:	ff3918e3          	bne	s2,s3,5a6 <printint+0x82>
 5ba:	7902                	ld	s2,32(sp)
 5bc:	69e2                	ld	s3,24(sp)
}
 5be:	70e2                	ld	ra,56(sp)
 5c0:	7442                	ld	s0,48(sp)
 5c2:	74a2                	ld	s1,40(sp)
 5c4:	6121                	addi	sp,sp,64
 5c6:	8082                	ret
    x = -xx;
 5c8:	40b005bb          	negw	a1,a1
    neg = 1;
 5cc:	4885                	li	a7,1
    x = -xx;
 5ce:	b7b5                	j	53a <printint+0x16>

00000000000005d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d0:	715d                	addi	sp,sp,-80
 5d2:	e486                	sd	ra,72(sp)
 5d4:	e0a2                	sd	s0,64(sp)
 5d6:	f84a                	sd	s2,48(sp)
 5d8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5da:	0005c903          	lbu	s2,0(a1)
 5de:	1a090a63          	beqz	s2,792 <vprintf+0x1c2>
 5e2:	fc26                	sd	s1,56(sp)
 5e4:	f44e                	sd	s3,40(sp)
 5e6:	f052                	sd	s4,32(sp)
 5e8:	ec56                	sd	s5,24(sp)
 5ea:	e85a                	sd	s6,16(sp)
 5ec:	e45e                	sd	s7,8(sp)
 5ee:	8aaa                	mv	s5,a0
 5f0:	8bb2                	mv	s7,a2
 5f2:	00158493          	addi	s1,a1,1
  state = 0;
 5f6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5f8:	02500a13          	li	s4,37
 5fc:	4b55                	li	s6,21
 5fe:	a839                	j	61c <vprintf+0x4c>
        putc(fd, c);
 600:	85ca                	mv	a1,s2
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	efe080e7          	jalr	-258(ra) # 502 <putc>
 60c:	a019                	j	612 <vprintf+0x42>
    } else if(state == '%'){
 60e:	01498d63          	beq	s3,s4,628 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 612:	0485                	addi	s1,s1,1
 614:	fff4c903          	lbu	s2,-1(s1)
 618:	16090763          	beqz	s2,786 <vprintf+0x1b6>
    if(state == 0){
 61c:	fe0999e3          	bnez	s3,60e <vprintf+0x3e>
      if(c == '%'){
 620:	ff4910e3          	bne	s2,s4,600 <vprintf+0x30>
        state = '%';
 624:	89d2                	mv	s3,s4
 626:	b7f5                	j	612 <vprintf+0x42>
      if(c == 'd'){
 628:	13490463          	beq	s2,s4,750 <vprintf+0x180>
 62c:	f9d9079b          	addiw	a5,s2,-99
 630:	0ff7f793          	zext.b	a5,a5
 634:	12fb6763          	bltu	s6,a5,762 <vprintf+0x192>
 638:	f9d9079b          	addiw	a5,s2,-99
 63c:	0ff7f713          	zext.b	a4,a5
 640:	12eb6163          	bltu	s6,a4,762 <vprintf+0x192>
 644:	00271793          	slli	a5,a4,0x2
 648:	00000717          	auipc	a4,0x0
 64c:	60070713          	addi	a4,a4,1536 # c48 <ithread_join+0xc0>
 650:	97ba                	add	a5,a5,a4
 652:	439c                	lw	a5,0(a5)
 654:	97ba                	add	a5,a5,a4
 656:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 658:	008b8913          	addi	s2,s7,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000ba583          	lw	a1,0(s7)
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	ebe080e7          	jalr	-322(ra) # 524 <printint>
 66e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 670:	4981                	li	s3,0
 672:	b745                	j	612 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	008b8913          	addi	s2,s7,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000ba583          	lw	a1,0(s7)
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	ea2080e7          	jalr	-350(ra) # 524 <printint>
 68a:	8bca                	mv	s7,s2
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b751                	j	612 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 690:	008b8913          	addi	s2,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000ba583          	lw	a1,0(s7)
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e86080e7          	jalr	-378(ra) # 524 <printint>
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b7a5                	j	612 <vprintf+0x42>
 6ac:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ae:	008b8c13          	addi	s8,s7,8
 6b2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b6:	03000593          	li	a1,48
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	e46080e7          	jalr	-442(ra) # 502 <putc>
  putc(fd, 'x');
 6c4:	07800593          	li	a1,120
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e38080e7          	jalr	-456(ra) # 502 <putc>
 6d2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d4:	00000b97          	auipc	s7,0x0
 6d8:	5ccb8b93          	addi	s7,s7,1484 # ca0 <digits>
 6dc:	03c9d793          	srli	a5,s3,0x3c
 6e0:	97de                	add	a5,a5,s7
 6e2:	0007c583          	lbu	a1,0(a5)
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e1a080e7          	jalr	-486(ra) # 502 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f0:	0992                	slli	s3,s3,0x4
 6f2:	397d                	addiw	s2,s2,-1
 6f4:	fe0914e3          	bnez	s2,6dc <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6f8:	8be2                	mv	s7,s8
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	6c02                	ld	s8,0(sp)
 6fe:	bf11                	j	612 <vprintf+0x42>
        s = va_arg(ap, char*);
 700:	008b8993          	addi	s3,s7,8
 704:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 708:	02090163          	beqz	s2,72a <vprintf+0x15a>
        while(*s != 0){
 70c:	00094583          	lbu	a1,0(s2)
 710:	c9a5                	beqz	a1,780 <vprintf+0x1b0>
          putc(fd, *s);
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	dee080e7          	jalr	-530(ra) # 502 <putc>
          s++;
 71c:	0905                	addi	s2,s2,1
        while(*s != 0){
 71e:	00094583          	lbu	a1,0(s2)
 722:	f9e5                	bnez	a1,712 <vprintf+0x142>
        s = va_arg(ap, char*);
 724:	8bce                	mv	s7,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	b5ed                	j	612 <vprintf+0x42>
          s = "(null)";
 72a:	00000917          	auipc	s2,0x0
 72e:	4e690913          	addi	s2,s2,1254 # c10 <ithread_join+0x88>
        while(*s != 0){
 732:	02800593          	li	a1,40
 736:	bff1                	j	712 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 738:	008b8913          	addi	s2,s7,8
 73c:	000bc583          	lbu	a1,0(s7)
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	dc0080e7          	jalr	-576(ra) # 502 <putc>
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b5d1                	j	612 <vprintf+0x42>
        putc(fd, c);
 750:	02500593          	li	a1,37
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	dac080e7          	jalr	-596(ra) # 502 <putc>
      state = 0;
 75e:	4981                	li	s3,0
 760:	bd4d                	j	612 <vprintf+0x42>
        putc(fd, '%');
 762:	02500593          	li	a1,37
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	d9a080e7          	jalr	-614(ra) # 502 <putc>
        putc(fd, c);
 770:	85ca                	mv	a1,s2
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	d8e080e7          	jalr	-626(ra) # 502 <putc>
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bd51                	j	612 <vprintf+0x42>
        s = va_arg(ap, char*);
 780:	8bce                	mv	s7,s3
      state = 0;
 782:	4981                	li	s3,0
 784:	b579                	j	612 <vprintf+0x42>
 786:	74e2                	ld	s1,56(sp)
 788:	79a2                	ld	s3,40(sp)
 78a:	7a02                	ld	s4,32(sp)
 78c:	6ae2                	ld	s5,24(sp)
 78e:	6b42                	ld	s6,16(sp)
 790:	6ba2                	ld	s7,8(sp)
    }
  }
}
 792:	60a6                	ld	ra,72(sp)
 794:	6406                	ld	s0,64(sp)
 796:	7942                	ld	s2,48(sp)
 798:	6161                	addi	sp,sp,80
 79a:	8082                	ret

000000000000079c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 79c:	715d                	addi	sp,sp,-80
 79e:	ec06                	sd	ra,24(sp)
 7a0:	e822                	sd	s0,16(sp)
 7a2:	1000                	addi	s0,sp,32
 7a4:	e010                	sd	a2,0(s0)
 7a6:	e414                	sd	a3,8(s0)
 7a8:	e818                	sd	a4,16(s0)
 7aa:	ec1c                	sd	a5,24(s0)
 7ac:	03043023          	sd	a6,32(s0)
 7b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b8:	8622                	mv	a2,s0
 7ba:	00000097          	auipc	ra,0x0
 7be:	e16080e7          	jalr	-490(ra) # 5d0 <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6161                	addi	sp,sp,80
 7c8:	8082                	ret

00000000000007ca <printf>:

void
printf(const char *fmt, ...)
{
 7ca:	711d                	addi	sp,sp,-96
 7cc:	ec06                	sd	ra,24(sp)
 7ce:	e822                	sd	s0,16(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	e40c                	sd	a1,8(s0)
 7d4:	e810                	sd	a2,16(s0)
 7d6:	ec14                	sd	a3,24(s0)
 7d8:	f018                	sd	a4,32(s0)
 7da:	f41c                	sd	a5,40(s0)
 7dc:	03043823          	sd	a6,48(s0)
 7e0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e4:	00840613          	addi	a2,s0,8
 7e8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ec:	85aa                	mv	a1,a0
 7ee:	4505                	li	a0,1
 7f0:	00000097          	auipc	ra,0x0
 7f4:	de0080e7          	jalr	-544(ra) # 5d0 <vprintf>
}
 7f8:	60e2                	ld	ra,24(sp)
 7fa:	6442                	ld	s0,16(sp)
 7fc:	6125                	addi	sp,sp,96
 7fe:	8082                	ret

0000000000000800 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 800:	1141                	addi	sp,sp,-16
 802:	e422                	sd	s0,8(sp)
 804:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 806:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80a:	00001797          	auipc	a5,0x1
 80e:	8067b783          	ld	a5,-2042(a5) # 1010 <freep>
 812:	a02d                	j	83c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 814:	4618                	lw	a4,8(a2)
 816:	9f2d                	addw	a4,a4,a1
 818:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81c:	6398                	ld	a4,0(a5)
 81e:	6310                	ld	a2,0(a4)
 820:	a83d                	j	85e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 822:	ff852703          	lw	a4,-8(a0)
 826:	9f31                	addw	a4,a4,a2
 828:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 82a:	ff053683          	ld	a3,-16(a0)
 82e:	a091                	j	872 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	6398                	ld	a4,0(a5)
 832:	00e7e463          	bltu	a5,a4,83a <free+0x3a>
 836:	00e6ea63          	bltu	a3,a4,84a <free+0x4a>
{
 83a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83c:	fed7fae3          	bgeu	a5,a3,830 <free+0x30>
 840:	6398                	ld	a4,0(a5)
 842:	00e6e463          	bltu	a3,a4,84a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 846:	fee7eae3          	bltu	a5,a4,83a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 84a:	ff852583          	lw	a1,-8(a0)
 84e:	6390                	ld	a2,0(a5)
 850:	02059813          	slli	a6,a1,0x20
 854:	01c85713          	srli	a4,a6,0x1c
 858:	9736                	add	a4,a4,a3
 85a:	fae60de3          	beq	a2,a4,814 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 85e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 862:	4790                	lw	a2,8(a5)
 864:	02061593          	slli	a1,a2,0x20
 868:	01c5d713          	srli	a4,a1,0x1c
 86c:	973e                	add	a4,a4,a5
 86e:	fae68ae3          	beq	a3,a4,822 <free+0x22>
    p->s.ptr = bp->s.ptr;
 872:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 874:	00000717          	auipc	a4,0x0
 878:	78f73e23          	sd	a5,1948(a4) # 1010 <freep>
}
 87c:	6422                	ld	s0,8(sp)
 87e:	0141                	addi	sp,sp,16
 880:	8082                	ret

0000000000000882 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 882:	7139                	addi	sp,sp,-64
 884:	fc06                	sd	ra,56(sp)
 886:	f822                	sd	s0,48(sp)
 888:	f426                	sd	s1,40(sp)
 88a:	ec4e                	sd	s3,24(sp)
 88c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88e:	02051493          	slli	s1,a0,0x20
 892:	9081                	srli	s1,s1,0x20
 894:	04bd                	addi	s1,s1,15
 896:	8091                	srli	s1,s1,0x4
 898:	0014899b          	addiw	s3,s1,1
 89c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 89e:	00000517          	auipc	a0,0x0
 8a2:	77253503          	ld	a0,1906(a0) # 1010 <freep>
 8a6:	c915                	beqz	a0,8da <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8aa:	4798                	lw	a4,8(a5)
 8ac:	08977e63          	bgeu	a4,s1,948 <malloc+0xc6>
 8b0:	f04a                	sd	s2,32(sp)
 8b2:	e852                	sd	s4,16(sp)
 8b4:	e456                	sd	s5,8(sp)
 8b6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8b8:	8a4e                	mv	s4,s3
 8ba:	0009871b          	sext.w	a4,s3
 8be:	6685                	lui	a3,0x1
 8c0:	00d77363          	bgeu	a4,a3,8c6 <malloc+0x44>
 8c4:	6a05                	lui	s4,0x1
 8c6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ca:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ce:	00000917          	auipc	s2,0x0
 8d2:	74290913          	addi	s2,s2,1858 # 1010 <freep>
  if(p == (char*)-1)
 8d6:	5afd                	li	s5,-1
 8d8:	a091                	j	91c <malloc+0x9a>
 8da:	f04a                	sd	s2,32(sp)
 8dc:	e852                	sd	s4,16(sp)
 8de:	e456                	sd	s5,8(sp)
 8e0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e2:	00000797          	auipc	a5,0x0
 8e6:	74e78793          	addi	a5,a5,1870 # 1030 <base>
 8ea:	00000717          	auipc	a4,0x0
 8ee:	72f73323          	sd	a5,1830(a4) # 1010 <freep>
 8f2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f8:	b7c1                	j	8b8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8fa:	6398                	ld	a4,0(a5)
 8fc:	e118                	sd	a4,0(a0)
 8fe:	a08d                	j	960 <malloc+0xde>
  hp->s.size = nu;
 900:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 904:	0541                	addi	a0,a0,16
 906:	00000097          	auipc	ra,0x0
 90a:	efa080e7          	jalr	-262(ra) # 800 <free>
  return freep;
 90e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 912:	c13d                	beqz	a0,978 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 914:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 916:	4798                	lw	a4,8(a5)
 918:	02977463          	bgeu	a4,s1,940 <malloc+0xbe>
    if(p == freep)
 91c:	00093703          	ld	a4,0(s2)
 920:	853e                	mv	a0,a5
 922:	fef719e3          	bne	a4,a5,914 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 926:	8552                	mv	a0,s4
 928:	00000097          	auipc	ra,0x0
 92c:	b54080e7          	jalr	-1196(ra) # 47c <sbrk>
  if(p == (char*)-1)
 930:	fd5518e3          	bne	a0,s5,900 <malloc+0x7e>
        return 0;
 934:	4501                	li	a0,0
 936:	7902                	ld	s2,32(sp)
 938:	6a42                	ld	s4,16(sp)
 93a:	6aa2                	ld	s5,8(sp)
 93c:	6b02                	ld	s6,0(sp)
 93e:	a03d                	j	96c <malloc+0xea>
 940:	7902                	ld	s2,32(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 948:	fae489e3          	beq	s1,a4,8fa <malloc+0x78>
        p->s.size -= nunits;
 94c:	4137073b          	subw	a4,a4,s3
 950:	c798                	sw	a4,8(a5)
        p += p->s.size;
 952:	02071693          	slli	a3,a4,0x20
 956:	01c6d713          	srli	a4,a3,0x1c
 95a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 95c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 960:	00000717          	auipc	a4,0x0
 964:	6aa73823          	sd	a0,1712(a4) # 1010 <freep>
      return (void*)(p + 1);
 968:	01078513          	addi	a0,a5,16
  }
}
 96c:	70e2                	ld	ra,56(sp)
 96e:	7442                	ld	s0,48(sp)
 970:	74a2                	ld	s1,40(sp)
 972:	69e2                	ld	s3,24(sp)
 974:	6121                	addi	sp,sp,64
 976:	8082                	ret
 978:	7902                	ld	s2,32(sp)
 97a:	6a42                	ld	s4,16(sp)
 97c:	6aa2                	ld	s5,8(sp)
 97e:	6b02                	ld	s6,0(sp)
 980:	b7f5                	j	96c <malloc+0xea>

0000000000000982 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 982:	1141                	addi	sp,sp,-16
 984:	e406                	sd	ra,8(sp)
 986:	e022                	sd	s0,0(sp)
 988:	0800                	addi	s0,sp,16
  thread_exit(status);
 98a:	2501                	sext.w	a0,a0
 98c:	00000097          	auipc	ra,0x0
 990:	b20080e7          	jalr	-1248(ra) # 4ac <thread_exit>
}
 994:	60a2                	ld	ra,8(sp)
 996:	6402                	ld	s0,0(sp)
 998:	0141                	addi	sp,sp,16
 99a:	8082                	ret

000000000000099c <free_stacks>:
int free_stacks() {
 99c:	7179                	addi	sp,sp,-48
 99e:	f406                	sd	ra,40(sp)
 9a0:	f022                	sd	s0,32(sp)
 9a2:	ec26                	sd	s1,24(sp)
 9a4:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 9a6:	00000797          	auipc	a5,0x0
 9aa:	67a7a783          	lw	a5,1658(a5) # 1020 <num_threads>
 9ae:	04f05063          	blez	a5,9ee <free_stacks+0x52>
 9b2:	e84a                	sd	s2,16(sp)
 9b4:	e44e                	sd	s3,8(sp)
 9b6:	4481                	li	s1,0
    free(stacks[i]);
 9b8:	00000997          	auipc	s3,0x0
 9bc:	66098993          	addi	s3,s3,1632 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 9c0:	00000917          	auipc	s2,0x0
 9c4:	66090913          	addi	s2,s2,1632 # 1020 <num_threads>
    free(stacks[i]);
 9c8:	0009b783          	ld	a5,0(s3)
 9cc:	00349713          	slli	a4,s1,0x3
 9d0:	97ba                	add	a5,a5,a4
 9d2:	6388                	ld	a0,0(a5)
 9d4:	00000097          	auipc	ra,0x0
 9d8:	e2c080e7          	jalr	-468(ra) # 800 <free>
  for (int i = 0; i < num_threads; i++) {
 9dc:	0485                	addi	s1,s1,1
 9de:	00092703          	lw	a4,0(s2)
 9e2:	0004879b          	sext.w	a5,s1
 9e6:	fee7c1e3          	blt	a5,a4,9c8 <free_stacks+0x2c>
 9ea:	6942                	ld	s2,16(sp)
 9ec:	69a2                	ld	s3,8(sp)
  free(stacks);
 9ee:	00000497          	auipc	s1,0x0
 9f2:	62a48493          	addi	s1,s1,1578 # 1018 <stacks>
 9f6:	6088                	ld	a0,0(s1)
 9f8:	00000097          	auipc	ra,0x0
 9fc:	e08080e7          	jalr	-504(ra) # 800 <free>
  stacks = 0;
 a00:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 a04:	00000797          	auipc	a5,0x0
 a08:	6007ae23          	sw	zero,1564(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 a0c:	47a1                	li	a5,8
 a0e:	00000717          	auipc	a4,0x0
 a12:	5ef72923          	sw	a5,1522(a4) # 1000 <max_stacks>
  threads_done = 0;
 a16:	00000797          	auipc	a5,0x0
 a1a:	6007a723          	sw	zero,1550(a5) # 1024 <threads_done>
}
 a1e:	4501                	li	a0,0
 a20:	70a2                	ld	ra,40(sp)
 a22:	7402                	ld	s0,32(sp)
 a24:	64e2                	ld	s1,24(sp)
 a26:	6145                	addi	sp,sp,48
 a28:	8082                	ret

0000000000000a2a <expand_num_threads>:
int expand_num_threads() {
 a2a:	1101                	addi	sp,sp,-32
 a2c:	ec06                	sd	ra,24(sp)
 a2e:	e822                	sd	s0,16(sp)
 a30:	e426                	sd	s1,8(sp)
 a32:	e04a                	sd	s2,0(sp)
 a34:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a36:	00000797          	auipc	a5,0x0
 a3a:	5ca78793          	addi	a5,a5,1482 # 1000 <max_stacks>
 a3e:	4388                	lw	a0,0(a5)
 a40:	0015151b          	slliw	a0,a0,0x1
 a44:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a46:	0035151b          	slliw	a0,a0,0x3
 a4a:	00000097          	auipc	ra,0x0
 a4e:	e38080e7          	jalr	-456(ra) # 882 <malloc>
 a52:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a54:	00000617          	auipc	a2,0x0
 a58:	5cc62603          	lw	a2,1484(a2) # 1020 <num_threads>
 a5c:	00000497          	auipc	s1,0x0
 a60:	5bc48493          	addi	s1,s1,1468 # 1018 <stacks>
 a64:	0036161b          	slliw	a2,a2,0x3
 a68:	608c                	ld	a1,0(s1)
 a6a:	00000097          	auipc	ra,0x0
 a6e:	840080e7          	jalr	-1984(ra) # 2aa <memmove>
  free(stacks);
 a72:	6088                	ld	a0,0(s1)
 a74:	00000097          	auipc	ra,0x0
 a78:	d8c080e7          	jalr	-628(ra) # 800 <free>
  stacks = new_stacks;
 a7c:	0124b023          	sd	s2,0(s1)
}
 a80:	4501                	li	a0,0
 a82:	60e2                	ld	ra,24(sp)
 a84:	6442                	ld	s0,16(sp)
 a86:	64a2                	ld	s1,8(sp)
 a88:	6902                	ld	s2,0(sp)
 a8a:	6105                	addi	sp,sp,32
 a8c:	8082                	ret

0000000000000a8e <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a8e:	7179                	addi	sp,sp,-48
 a90:	f406                	sd	ra,40(sp)
 a92:	f022                	sd	s0,32(sp)
 a94:	e84a                	sd	s2,16(sp)
 a96:	e44e                	sd	s3,8(sp)
 a98:	1800                	addi	s0,sp,48
 a9a:	892a                	mv	s2,a0
 a9c:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a9e:	00000797          	auipc	a5,0x0
 aa2:	57a7b783          	ld	a5,1402(a5) # 1018 <stacks>
 aa6:	c3d9                	beqz	a5,b2c <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 aa8:	00000797          	auipc	a5,0x0
 aac:	5587a783          	lw	a5,1368(a5) # 1000 <max_stacks>
 ab0:	00000717          	auipc	a4,0x0
 ab4:	57072703          	lw	a4,1392(a4) # 1020 <num_threads>
 ab8:	0af71363          	bne	a4,a5,b5e <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 abc:	04000713          	li	a4,64
 ac0:	08e78563          	beq	a5,a4,b4a <ithread_create+0xbc>
 ac4:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 ac6:	00000097          	auipc	ra,0x0
 aca:	f64080e7          	jalr	-156(ra) # a2a <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 ace:	6505                	lui	a0,0x1
 ad0:	00000097          	auipc	ra,0x0
 ad4:	db2080e7          	jalr	-590(ra) # 882 <malloc>
 ad8:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 ada:	00000717          	auipc	a4,0x0
 ade:	54672703          	lw	a4,1350(a4) # 1020 <num_threads>
 ae2:	070e                	slli	a4,a4,0x3
 ae4:	00000797          	auipc	a5,0x0
 ae8:	5347b783          	ld	a5,1332(a5) # 1018 <stacks>
 aec:	97ba                	add	a5,a5,a4
 aee:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 af0:	00000697          	auipc	a3,0x0
 af4:	e9268693          	addi	a3,a3,-366 # 982 <ithread_exit>
 af8:	862a                	mv	a2,a0
 afa:	85ce                	mv	a1,s3
 afc:	854a                	mv	a0,s2
 afe:	00000097          	auipc	ra,0x0
 b02:	99e080e7          	jalr	-1634(ra) # 49c <create_thread>
 b06:	892a                	mv	s2,a0
  if (res != -1) {
 b08:	57fd                	li	a5,-1
 b0a:	04f50c63          	beq	a0,a5,b62 <ithread_create+0xd4>
    num_threads++;
 b0e:	00000717          	auipc	a4,0x0
 b12:	51270713          	addi	a4,a4,1298 # 1020 <num_threads>
 b16:	431c                	lw	a5,0(a4)
 b18:	2785                	addiw	a5,a5,1
 b1a:	c31c                	sw	a5,0(a4)
 b1c:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 b1e:	854a                	mv	a0,s2
 b20:	70a2                	ld	ra,40(sp)
 b22:	7402                	ld	s0,32(sp)
 b24:	6942                	ld	s2,16(sp)
 b26:	69a2                	ld	s3,8(sp)
 b28:	6145                	addi	sp,sp,48
 b2a:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 b2c:	00000517          	auipc	a0,0x0
 b30:	4d452503          	lw	a0,1236(a0) # 1000 <max_stacks>
 b34:	0035151b          	slliw	a0,a0,0x3
 b38:	00000097          	auipc	ra,0x0
 b3c:	d4a080e7          	jalr	-694(ra) # 882 <malloc>
 b40:	00000797          	auipc	a5,0x0
 b44:	4ca7bc23          	sd	a0,1240(a5) # 1018 <stacks>
 b48:	b785                	j	aa8 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b4a:	00000517          	auipc	a0,0x0
 b4e:	0ce50513          	addi	a0,a0,206 # c18 <ithread_join+0x90>
 b52:	00000097          	auipc	ra,0x0
 b56:	c78080e7          	jalr	-904(ra) # 7ca <printf>
      return -1;
 b5a:	597d                	li	s2,-1
 b5c:	b7c9                	j	b1e <ithread_create+0x90>
 b5e:	ec26                	sd	s1,24(sp)
 b60:	b7bd                	j	ace <ithread_create+0x40>
    free(stack_ptr);
 b62:	8526                	mv	a0,s1
 b64:	00000097          	auipc	ra,0x0
 b68:	c9c080e7          	jalr	-868(ra) # 800 <free>
    stacks[num_threads] = 0;
 b6c:	00000717          	auipc	a4,0x0
 b70:	4b472703          	lw	a4,1204(a4) # 1020 <num_threads>
 b74:	070e                	slli	a4,a4,0x3
 b76:	00000797          	auipc	a5,0x0
 b7a:	4a27b783          	ld	a5,1186(a5) # 1018 <stacks>
 b7e:	97ba                	add	a5,a5,a4
 b80:	0007b023          	sd	zero,0(a5)
 b84:	64e2                	ld	s1,24(sp)
 b86:	bf61                	j	b1e <ithread_create+0x90>

0000000000000b88 <ithread_join>:

int ithread_join(int thread_id) {
 b88:	1101                	addi	sp,sp,-32
 b8a:	ec06                	sd	ra,24(sp)
 b8c:	e822                	sd	s0,16(sp)
 b8e:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b90:	ff040793          	addi	a5,s0,-16
 b94:	ffc7859b          	addiw	a1,a5,-4
 b98:	00000097          	auipc	ra,0x0
 b9c:	90c080e7          	jalr	-1780(ra) # 4a4 <join_thread>
  threads_done++;
 ba0:	00000717          	auipc	a4,0x0
 ba4:	48470713          	addi	a4,a4,1156 # 1024 <threads_done>
 ba8:	431c                	lw	a5,0(a4)
 baa:	2785                	addiw	a5,a5,1
 bac:	0007869b          	sext.w	a3,a5
 bb0:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 bb2:	00000797          	auipc	a5,0x0
 bb6:	46e7a783          	lw	a5,1134(a5) # 1020 <num_threads>
 bba:	00d78863          	beq	a5,a3,bca <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 bbe:	fec42503          	lw	a0,-20(s0)
 bc2:	60e2                	ld	ra,24(sp)
 bc4:	6442                	ld	s0,16(sp)
 bc6:	6105                	addi	sp,sp,32
 bc8:	8082                	ret
    free_stacks();
 bca:	00000097          	auipc	ra,0x0
 bce:	dd2080e7          	jalr	-558(ra) # 99c <free_stacks>
 bd2:	b7f5                	j	bbe <ithread_join+0x36>
