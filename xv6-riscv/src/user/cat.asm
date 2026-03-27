
src/user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	02090913          	addi	s2,s2,32 # 1030 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	3a0080e7          	jalr	928(ra) # 3c0 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	394080e7          	jalr	916(ra) # 3c8 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	b5058593          	addi	a1,a1,-1200 # b90 <ithread_join+0x54>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	706080e7          	jalr	1798(ra) # 750 <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	354080e7          	jalr	852(ra) # 3a8 <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	b3a58593          	addi	a1,a1,-1222 # ba8 <ithread_join+0x6c>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	6d8080e7          	jalr	1752(ra) # 750 <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	326080e7          	jalr	806(ra) # 3a8 <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  92:	4785                	li	a5,1
  94:	04a7da63          	bge	a5,a0,e8 <main+0x5e>
  98:	ec26                	sd	s1,24(sp)
  9a:	e84a                	sd	s2,16(sp)
  9c:	e44e                	sd	s3,8(sp)
  9e:	00858913          	addi	s2,a1,8
  a2:	ffe5099b          	addiw	s3,a0,-2
  a6:	02099793          	slli	a5,s3,0x20
  aa:	01d7d993          	srli	s3,a5,0x1d
  ae:	05c1                	addi	a1,a1,16
  b0:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b2:	4581                	li	a1,0
  b4:	00093503          	ld	a0,0(s2)
  b8:	00000097          	auipc	ra,0x0
  bc:	330080e7          	jalr	816(ra) # 3e8 <open>
  c0:	84aa                	mv	s1,a0
  c2:	04054063          	bltz	a0,102 <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	300080e7          	jalr	768(ra) # 3d0 <close>
  for(i = 1; i < argc; i++){
  d8:	0921                	addi	s2,s2,8
  da:	fd391ce3          	bne	s2,s3,b2 <main+0x28>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2c8080e7          	jalr	712(ra) # 3a8 <exit>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
    cat(0);
  ee:	4501                	li	a0,0
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <cat>
    exit(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2ae080e7          	jalr	686(ra) # 3a8 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 102:	00093603          	ld	a2,0(s2)
 106:	00001597          	auipc	a1,0x1
 10a:	aba58593          	addi	a1,a1,-1350 # bc0 <ithread_join+0x84>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	640080e7          	jalr	1600(ra) # 750 <fprintf>
      exit(1);
 118:	4505                	li	a0,1
 11a:	00000097          	auipc	ra,0x0
 11e:	28e080e7          	jalr	654(ra) # 3a8 <exit>

0000000000000122 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  extern int main();
  main();
 12a:	00000097          	auipc	ra,0x0
 12e:	f60080e7          	jalr	-160(ra) # 8a <main>
  exit(0);
 132:	4501                	li	a0,0
 134:	00000097          	auipc	ra,0x0
 138:	274080e7          	jalr	628(ra) # 3a8 <exit>

000000000000013c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 142:	87aa                	mv	a5,a0
 144:	0585                	addi	a1,a1,1
 146:	0785                	addi	a5,a5,1
 148:	fff5c703          	lbu	a4,-1(a1)
 14c:	fee78fa3          	sb	a4,-1(a5)
 150:	fb75                	bnez	a4,144 <strcpy+0x8>
    ;
  return os;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cb91                	beqz	a5,176 <strcmp+0x1e>
 164:	0005c703          	lbu	a4,0(a1)
 168:	00f71763          	bne	a4,a5,176 <strcmp+0x1e>
    p++, q++;
 16c:	0505                	addi	a0,a0,1
 16e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	fbe5                	bnez	a5,164 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 176:	0005c503          	lbu	a0,0(a1)
}
 17a:	40a7853b          	subw	a0,a5,a0
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strlen>:

uint
strlen(const char *s)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cf91                	beqz	a5,1aa <strlen+0x26>
 190:	0505                	addi	a0,a0,1
 192:	87aa                	mv	a5,a0
 194:	86be                	mv	a3,a5
 196:	0785                	addi	a5,a5,1
 198:	fff7c703          	lbu	a4,-1(a5)
 19c:	ff65                	bnez	a4,194 <strlen+0x10>
 19e:	40a6853b          	subw	a0,a3,a0
 1a2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  for(n = 0; s[n]; n++)
 1aa:	4501                	li	a0,0
 1ac:	bfe5                	j	1a4 <strlen+0x20>

00000000000001ae <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b4:	ca19                	beqz	a2,1ca <memset+0x1c>
 1b6:	87aa                	mv	a5,a0
 1b8:	1602                	slli	a2,a2,0x20
 1ba:	9201                	srli	a2,a2,0x20
 1bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c4:	0785                	addi	a5,a5,1
 1c6:	fee79de3          	bne	a5,a4,1c0 <memset+0x12>
  }
  return dst;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret

00000000000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	cb99                	beqz	a5,1f0 <strchr+0x20>
    if(*s == c)
 1dc:	00f58763          	beq	a1,a5,1ea <strchr+0x1a>
  for(; *s; s++)
 1e0:	0505                	addi	a0,a0,1
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	fbfd                	bnez	a5,1dc <strchr+0xc>
      return (char*)s;
  return 0;
 1e8:	4501                	li	a0,0
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret
  return 0;
 1f0:	4501                	li	a0,0
 1f2:	bfe5                	j	1ea <strchr+0x1a>

00000000000001f4 <gets>:

char*
gets(char *buf, int max)
{
 1f4:	711d                	addi	sp,sp,-96
 1f6:	ec86                	sd	ra,88(sp)
 1f8:	e8a2                	sd	s0,80(sp)
 1fa:	e4a6                	sd	s1,72(sp)
 1fc:	e0ca                	sd	s2,64(sp)
 1fe:	fc4e                	sd	s3,56(sp)
 200:	f852                	sd	s4,48(sp)
 202:	f456                	sd	s5,40(sp)
 204:	f05a                	sd	s6,32(sp)
 206:	ec5e                	sd	s7,24(sp)
 208:	1080                	addi	s0,sp,96
 20a:	8baa                	mv	s7,a0
 20c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	892a                	mv	s2,a0
 210:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 212:	4aa9                	li	s5,10
 214:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 216:	89a6                	mv	s3,s1
 218:	2485                	addiw	s1,s1,1
 21a:	0344d863          	bge	s1,s4,24a <gets+0x56>
    cc = read(0, &c, 1);
 21e:	4605                	li	a2,1
 220:	faf40593          	addi	a1,s0,-81
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	19a080e7          	jalr	410(ra) # 3c0 <read>
    if(cc < 1)
 22e:	00a05e63          	blez	a0,24a <gets+0x56>
    buf[i++] = c;
 232:	faf44783          	lbu	a5,-81(s0)
 236:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23a:	01578763          	beq	a5,s5,248 <gets+0x54>
 23e:	0905                	addi	s2,s2,1
 240:	fd679be3          	bne	a5,s6,216 <gets+0x22>
    buf[i++] = c;
 244:	89a6                	mv	s3,s1
 246:	a011                	j	24a <gets+0x56>
 248:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 24a:	99de                	add	s3,s3,s7
 24c:	00098023          	sb	zero,0(s3)
  return buf;
}
 250:	855e                	mv	a0,s7
 252:	60e6                	ld	ra,88(sp)
 254:	6446                	ld	s0,80(sp)
 256:	64a6                	ld	s1,72(sp)
 258:	6906                	ld	s2,64(sp)
 25a:	79e2                	ld	s3,56(sp)
 25c:	7a42                	ld	s4,48(sp)
 25e:	7aa2                	ld	s5,40(sp)
 260:	7b02                	ld	s6,32(sp)
 262:	6be2                	ld	s7,24(sp)
 264:	6125                	addi	sp,sp,96
 266:	8082                	ret

0000000000000268 <stat>:

int
stat(const char *n, struct stat *st)
{
 268:	1101                	addi	sp,sp,-32
 26a:	ec06                	sd	ra,24(sp)
 26c:	e822                	sd	s0,16(sp)
 26e:	e04a                	sd	s2,0(sp)
 270:	1000                	addi	s0,sp,32
 272:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 274:	4581                	li	a1,0
 276:	00000097          	auipc	ra,0x0
 27a:	172080e7          	jalr	370(ra) # 3e8 <open>
  if(fd < 0)
 27e:	02054663          	bltz	a0,2aa <stat+0x42>
 282:	e426                	sd	s1,8(sp)
 284:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 286:	85ca                	mv	a1,s2
 288:	00000097          	auipc	ra,0x0
 28c:	178080e7          	jalr	376(ra) # 400 <fstat>
 290:	892a                	mv	s2,a0
  close(fd);
 292:	8526                	mv	a0,s1
 294:	00000097          	auipc	ra,0x0
 298:	13c080e7          	jalr	316(ra) # 3d0 <close>
  return r;
 29c:	64a2                	ld	s1,8(sp)
}
 29e:	854a                	mv	a0,s2
 2a0:	60e2                	ld	ra,24(sp)
 2a2:	6442                	ld	s0,16(sp)
 2a4:	6902                	ld	s2,0(sp)
 2a6:	6105                	addi	sp,sp,32
 2a8:	8082                	ret
    return -1;
 2aa:	597d                	li	s2,-1
 2ac:	bfcd                	j	29e <stat+0x36>

00000000000002ae <atoi>:

int
atoi(const char *s)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e422                	sd	s0,8(sp)
 2b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b4:	00054683          	lbu	a3,0(a0)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	4625                	li	a2,9
 2c2:	02f66863          	bltu	a2,a5,2f2 <atoi+0x44>
 2c6:	872a                	mv	a4,a0
  n = 0;
 2c8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ca:	0705                	addi	a4,a4,1
 2cc:	0025179b          	slliw	a5,a0,0x2
 2d0:	9fa9                	addw	a5,a5,a0
 2d2:	0017979b          	slliw	a5,a5,0x1
 2d6:	9fb5                	addw	a5,a5,a3
 2d8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2dc:	00074683          	lbu	a3,0(a4)
 2e0:	fd06879b          	addiw	a5,a3,-48
 2e4:	0ff7f793          	zext.b	a5,a5
 2e8:	fef671e3          	bgeu	a2,a5,2ca <atoi+0x1c>
  return n;
}
 2ec:	6422                	ld	s0,8(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
  n = 0;
 2f2:	4501                	li	a0,0
 2f4:	bfe5                	j	2ec <atoi+0x3e>

00000000000002f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fc:	02b57463          	bgeu	a0,a1,324 <memmove+0x2e>
    while(n-- > 0)
 300:	00c05f63          	blez	a2,31e <memmove+0x28>
 304:	1602                	slli	a2,a2,0x20
 306:	9201                	srli	a2,a2,0x20
 308:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 30c:	872a                	mv	a4,a0
      *dst++ = *src++;
 30e:	0585                	addi	a1,a1,1
 310:	0705                	addi	a4,a4,1
 312:	fff5c683          	lbu	a3,-1(a1)
 316:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31a:	fef71ae3          	bne	a4,a5,30e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31e:	6422                	ld	s0,8(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret
    dst += n;
 324:	00c50733          	add	a4,a0,a2
    src += n;
 328:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 32a:	fec05ae3          	blez	a2,31e <memmove+0x28>
 32e:	fff6079b          	addiw	a5,a2,-1
 332:	1782                	slli	a5,a5,0x20
 334:	9381                	srli	a5,a5,0x20
 336:	fff7c793          	not	a5,a5
 33a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33c:	15fd                	addi	a1,a1,-1
 33e:	177d                	addi	a4,a4,-1
 340:	0005c683          	lbu	a3,0(a1)
 344:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 348:	fee79ae3          	bne	a5,a4,33c <memmove+0x46>
 34c:	bfc9                	j	31e <memmove+0x28>

000000000000034e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e422                	sd	s0,8(sp)
 352:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 354:	ca05                	beqz	a2,384 <memcmp+0x36>
 356:	fff6069b          	addiw	a3,a2,-1
 35a:	1682                	slli	a3,a3,0x20
 35c:	9281                	srli	a3,a3,0x20
 35e:	0685                	addi	a3,a3,1
 360:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 362:	00054783          	lbu	a5,0(a0)
 366:	0005c703          	lbu	a4,0(a1)
 36a:	00e79863          	bne	a5,a4,37a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36e:	0505                	addi	a0,a0,1
    p2++;
 370:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 372:	fed518e3          	bne	a0,a3,362 <memcmp+0x14>
  }
  return 0;
 376:	4501                	li	a0,0
 378:	a019                	j	37e <memcmp+0x30>
      return *p1 - *p2;
 37a:	40e7853b          	subw	a0,a5,a4
}
 37e:	6422                	ld	s0,8(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret
  return 0;
 384:	4501                	li	a0,0
 386:	bfe5                	j	37e <memcmp+0x30>

0000000000000388 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 390:	00000097          	auipc	ra,0x0
 394:	f66080e7          	jalr	-154(ra) # 2f6 <memmove>
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a0:	4885                	li	a7,1
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a8:	4889                	li	a7,2
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b0:	488d                	li	a7,3
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b8:	4891                	li	a7,4
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <read>:
.global read
read:
 li a7, SYS_read
 3c0:	4895                	li	a7,5
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <write>:
.global write
write:
 li a7, SYS_write
 3c8:	48c1                	li	a7,16
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <close>:
.global close
close:
 li a7, SYS_close
 3d0:	48d5                	li	a7,21
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d8:	4899                	li	a7,6
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e0:	489d                	li	a7,7
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <open>:
.global open
open:
 li a7, SYS_open
 3e8:	48bd                	li	a7,15
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f0:	48c5                	li	a7,17
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f8:	48c9                	li	a7,18
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 400:	48a1                	li	a7,8
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <link>:
.global link
link:
 li a7, SYS_link
 408:	48cd                	li	a7,19
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 410:	48d1                	li	a7,20
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 418:	48a5                	li	a7,9
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <dup>:
.global dup
dup:
 li a7, SYS_dup
 420:	48a9                	li	a7,10
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 428:	48ad                	li	a7,11
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 430:	48b1                	li	a7,12
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 438:	48b5                	li	a7,13
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 440:	48b9                	li	a7,14
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 448:	48d9                	li	a7,22
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 450:	48dd                	li	a7,23
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 458:	48e1                	li	a7,24
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 460:	48e5                	li	a7,25
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <socket>:
.global socket
socket:
 li a7, SYS_socket
 468:	48e9                	li	a7,26
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <bind>:
.global bind
bind:
 li a7, SYS_bind
 470:	48ed                	li	a7,27
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <accept>:
.global accept
accept:
 li a7, SYS_accept
 478:	48f5                	li	a7,29
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <listen>:
.global listen
listen:
 li a7, SYS_listen
 480:	48f1                	li	a7,28
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <connect>:
.global connect
connect:
 li a7, SYS_connect
 488:	48f9                	li	a7,30
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <send>:
.global send
send:
 li a7, SYS_send
 490:	48fd                	li	a7,31
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <recv>:
.global recv
recv:
 li a7, SYS_recv
 498:	02000893          	li	a7,32
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 4a2:	02100893          	li	a7,33
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 4ac:	02200893          	li	a7,34
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b6:	1101                	addi	sp,sp,-32
 4b8:	ec06                	sd	ra,24(sp)
 4ba:	e822                	sd	s0,16(sp)
 4bc:	1000                	addi	s0,sp,32
 4be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c2:	4605                	li	a2,1
 4c4:	fef40593          	addi	a1,s0,-17
 4c8:	00000097          	auipc	ra,0x0
 4cc:	f00080e7          	jalr	-256(ra) # 3c8 <write>
}
 4d0:	60e2                	ld	ra,24(sp)
 4d2:	6442                	ld	s0,16(sp)
 4d4:	6105                	addi	sp,sp,32
 4d6:	8082                	ret

00000000000004d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d8:	7139                	addi	sp,sp,-64
 4da:	fc06                	sd	ra,56(sp)
 4dc:	f822                	sd	s0,48(sp)
 4de:	f426                	sd	s1,40(sp)
 4e0:	0080                	addi	s0,sp,64
 4e2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e4:	c299                	beqz	a3,4ea <printint+0x12>
 4e6:	0805cb63          	bltz	a1,57c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ea:	2581                	sext.w	a1,a1
  neg = 0;
 4ec:	4881                	li	a7,0
 4ee:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f4:	2601                	sext.w	a2,a2
 4f6:	00000517          	auipc	a0,0x0
 4fa:	77250513          	addi	a0,a0,1906 # c68 <digits>
 4fe:	883a                	mv	a6,a4
 500:	2705                	addiw	a4,a4,1
 502:	02c5f7bb          	remuw	a5,a1,a2
 506:	1782                	slli	a5,a5,0x20
 508:	9381                	srli	a5,a5,0x20
 50a:	97aa                	add	a5,a5,a0
 50c:	0007c783          	lbu	a5,0(a5)
 510:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 514:	0005879b          	sext.w	a5,a1
 518:	02c5d5bb          	divuw	a1,a1,a2
 51c:	0685                	addi	a3,a3,1
 51e:	fec7f0e3          	bgeu	a5,a2,4fe <printint+0x26>
  if(neg)
 522:	00088c63          	beqz	a7,53a <printint+0x62>
    buf[i++] = '-';
 526:	fd070793          	addi	a5,a4,-48
 52a:	00878733          	add	a4,a5,s0
 52e:	02d00793          	li	a5,45
 532:	fef70823          	sb	a5,-16(a4)
 536:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 53a:	02e05c63          	blez	a4,572 <printint+0x9a>
 53e:	f04a                	sd	s2,32(sp)
 540:	ec4e                	sd	s3,24(sp)
 542:	fc040793          	addi	a5,s0,-64
 546:	00e78933          	add	s2,a5,a4
 54a:	fff78993          	addi	s3,a5,-1
 54e:	99ba                	add	s3,s3,a4
 550:	377d                	addiw	a4,a4,-1
 552:	1702                	slli	a4,a4,0x20
 554:	9301                	srli	a4,a4,0x20
 556:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 55a:	fff94583          	lbu	a1,-1(s2)
 55e:	8526                	mv	a0,s1
 560:	00000097          	auipc	ra,0x0
 564:	f56080e7          	jalr	-170(ra) # 4b6 <putc>
  while(--i >= 0)
 568:	197d                	addi	s2,s2,-1
 56a:	ff3918e3          	bne	s2,s3,55a <printint+0x82>
 56e:	7902                	ld	s2,32(sp)
 570:	69e2                	ld	s3,24(sp)
}
 572:	70e2                	ld	ra,56(sp)
 574:	7442                	ld	s0,48(sp)
 576:	74a2                	ld	s1,40(sp)
 578:	6121                	addi	sp,sp,64
 57a:	8082                	ret
    x = -xx;
 57c:	40b005bb          	negw	a1,a1
    neg = 1;
 580:	4885                	li	a7,1
    x = -xx;
 582:	b7b5                	j	4ee <printint+0x16>

0000000000000584 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 584:	715d                	addi	sp,sp,-80
 586:	e486                	sd	ra,72(sp)
 588:	e0a2                	sd	s0,64(sp)
 58a:	f84a                	sd	s2,48(sp)
 58c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 58e:	0005c903          	lbu	s2,0(a1)
 592:	1a090a63          	beqz	s2,746 <vprintf+0x1c2>
 596:	fc26                	sd	s1,56(sp)
 598:	f44e                	sd	s3,40(sp)
 59a:	f052                	sd	s4,32(sp)
 59c:	ec56                	sd	s5,24(sp)
 59e:	e85a                	sd	s6,16(sp)
 5a0:	e45e                	sd	s7,8(sp)
 5a2:	8aaa                	mv	s5,a0
 5a4:	8bb2                	mv	s7,a2
 5a6:	00158493          	addi	s1,a1,1
  state = 0;
 5aa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ac:	02500a13          	li	s4,37
 5b0:	4b55                	li	s6,21
 5b2:	a839                	j	5d0 <vprintf+0x4c>
        putc(fd, c);
 5b4:	85ca                	mv	a1,s2
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	efe080e7          	jalr	-258(ra) # 4b6 <putc>
 5c0:	a019                	j	5c6 <vprintf+0x42>
    } else if(state == '%'){
 5c2:	01498d63          	beq	s3,s4,5dc <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5c6:	0485                	addi	s1,s1,1
 5c8:	fff4c903          	lbu	s2,-1(s1)
 5cc:	16090763          	beqz	s2,73a <vprintf+0x1b6>
    if(state == 0){
 5d0:	fe0999e3          	bnez	s3,5c2 <vprintf+0x3e>
      if(c == '%'){
 5d4:	ff4910e3          	bne	s2,s4,5b4 <vprintf+0x30>
        state = '%';
 5d8:	89d2                	mv	s3,s4
 5da:	b7f5                	j	5c6 <vprintf+0x42>
      if(c == 'd'){
 5dc:	13490463          	beq	s2,s4,704 <vprintf+0x180>
 5e0:	f9d9079b          	addiw	a5,s2,-99
 5e4:	0ff7f793          	zext.b	a5,a5
 5e8:	12fb6763          	bltu	s6,a5,716 <vprintf+0x192>
 5ec:	f9d9079b          	addiw	a5,s2,-99
 5f0:	0ff7f713          	zext.b	a4,a5
 5f4:	12eb6163          	bltu	s6,a4,716 <vprintf+0x192>
 5f8:	00271793          	slli	a5,a4,0x2
 5fc:	00000717          	auipc	a4,0x0
 600:	61470713          	addi	a4,a4,1556 # c10 <ithread_join+0xd4>
 604:	97ba                	add	a5,a5,a4
 606:	439c                	lw	a5,0(a5)
 608:	97ba                	add	a5,a5,a4
 60a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 60c:	008b8913          	addi	s2,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000ba583          	lw	a1,0(s7)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	ebe080e7          	jalr	-322(ra) # 4d8 <printint>
 622:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 624:	4981                	li	s3,0
 626:	b745                	j	5c6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	ea2080e7          	jalr	-350(ra) # 4d8 <printint>
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	b751                	j	5c6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 644:	008b8913          	addi	s2,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000ba583          	lw	a1,0(s7)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	e86080e7          	jalr	-378(ra) # 4d8 <printint>
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	b7a5                	j	5c6 <vprintf+0x42>
 660:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 662:	008b8c13          	addi	s8,s7,8
 666:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 66a:	03000593          	li	a1,48
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	e46080e7          	jalr	-442(ra) # 4b6 <putc>
  putc(fd, 'x');
 678:	07800593          	li	a1,120
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	e38080e7          	jalr	-456(ra) # 4b6 <putc>
 686:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 688:	00000b97          	auipc	s7,0x0
 68c:	5e0b8b93          	addi	s7,s7,1504 # c68 <digits>
 690:	03c9d793          	srli	a5,s3,0x3c
 694:	97de                	add	a5,a5,s7
 696:	0007c583          	lbu	a1,0(a5)
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	e1a080e7          	jalr	-486(ra) # 4b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a4:	0992                	slli	s3,s3,0x4
 6a6:	397d                	addiw	s2,s2,-1
 6a8:	fe0914e3          	bnez	s2,690 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6ac:	8be2                	mv	s7,s8
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	6c02                	ld	s8,0(sp)
 6b2:	bf11                	j	5c6 <vprintf+0x42>
        s = va_arg(ap, char*);
 6b4:	008b8993          	addi	s3,s7,8
 6b8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6bc:	02090163          	beqz	s2,6de <vprintf+0x15a>
        while(*s != 0){
 6c0:	00094583          	lbu	a1,0(s2)
 6c4:	c9a5                	beqz	a1,734 <vprintf+0x1b0>
          putc(fd, *s);
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	dee080e7          	jalr	-530(ra) # 4b6 <putc>
          s++;
 6d0:	0905                	addi	s2,s2,1
        while(*s != 0){
 6d2:	00094583          	lbu	a1,0(s2)
 6d6:	f9e5                	bnez	a1,6c6 <vprintf+0x142>
        s = va_arg(ap, char*);
 6d8:	8bce                	mv	s7,s3
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b5ed                	j	5c6 <vprintf+0x42>
          s = "(null)";
 6de:	00000917          	auipc	s2,0x0
 6e2:	4fa90913          	addi	s2,s2,1274 # bd8 <ithread_join+0x9c>
        while(*s != 0){
 6e6:	02800593          	li	a1,40
 6ea:	bff1                	j	6c6 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6ec:	008b8913          	addi	s2,s7,8
 6f0:	000bc583          	lbu	a1,0(s7)
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	dc0080e7          	jalr	-576(ra) # 4b6 <putc>
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
 702:	b5d1                	j	5c6 <vprintf+0x42>
        putc(fd, c);
 704:	02500593          	li	a1,37
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	dac080e7          	jalr	-596(ra) # 4b6 <putc>
      state = 0;
 712:	4981                	li	s3,0
 714:	bd4d                	j	5c6 <vprintf+0x42>
        putc(fd, '%');
 716:	02500593          	li	a1,37
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	d9a080e7          	jalr	-614(ra) # 4b6 <putc>
        putc(fd, c);
 724:	85ca                	mv	a1,s2
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	d8e080e7          	jalr	-626(ra) # 4b6 <putc>
      state = 0;
 730:	4981                	li	s3,0
 732:	bd51                	j	5c6 <vprintf+0x42>
        s = va_arg(ap, char*);
 734:	8bce                	mv	s7,s3
      state = 0;
 736:	4981                	li	s3,0
 738:	b579                	j	5c6 <vprintf+0x42>
 73a:	74e2                	ld	s1,56(sp)
 73c:	79a2                	ld	s3,40(sp)
 73e:	7a02                	ld	s4,32(sp)
 740:	6ae2                	ld	s5,24(sp)
 742:	6b42                	ld	s6,16(sp)
 744:	6ba2                	ld	s7,8(sp)
    }
  }
}
 746:	60a6                	ld	ra,72(sp)
 748:	6406                	ld	s0,64(sp)
 74a:	7942                	ld	s2,48(sp)
 74c:	6161                	addi	sp,sp,80
 74e:	8082                	ret

0000000000000750 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 750:	715d                	addi	sp,sp,-80
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e010                	sd	a2,0(s0)
 75a:	e414                	sd	a3,8(s0)
 75c:	e818                	sd	a4,16(s0)
 75e:	ec1c                	sd	a5,24(s0)
 760:	03043023          	sd	a6,32(s0)
 764:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 768:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76c:	8622                	mv	a2,s0
 76e:	00000097          	auipc	ra,0x0
 772:	e16080e7          	jalr	-490(ra) # 584 <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6161                	addi	sp,sp,80
 77c:	8082                	ret

000000000000077e <printf>:

void
printf(const char *fmt, ...)
{
 77e:	711d                	addi	sp,sp,-96
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e40c                	sd	a1,8(s0)
 788:	e810                	sd	a2,16(s0)
 78a:	ec14                	sd	a3,24(s0)
 78c:	f018                	sd	a4,32(s0)
 78e:	f41c                	sd	a5,40(s0)
 790:	03043823          	sd	a6,48(s0)
 794:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	00840613          	addi	a2,s0,8
 79c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a0:	85aa                	mv	a1,a0
 7a2:	4505                	li	a0,1
 7a4:	00000097          	auipc	ra,0x0
 7a8:	de0080e7          	jalr	-544(ra) # 584 <vprintf>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6125                	addi	sp,sp,96
 7b2:	8082                	ret

00000000000007b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b4:	1141                	addi	sp,sp,-16
 7b6:	e422                	sd	s0,8(sp)
 7b8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	00001797          	auipc	a5,0x1
 7c2:	8527b783          	ld	a5,-1966(a5) # 1010 <freep>
 7c6:	a02d                	j	7f0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c8:	4618                	lw	a4,8(a2)
 7ca:	9f2d                	addw	a4,a4,a1
 7cc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	6398                	ld	a4,0(a5)
 7d2:	6310                	ld	a2,0(a4)
 7d4:	a83d                	j	812 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d6:	ff852703          	lw	a4,-8(a0)
 7da:	9f31                	addw	a4,a4,a2
 7dc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7de:	ff053683          	ld	a3,-16(a0)
 7e2:	a091                	j	826 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	6398                	ld	a4,0(a5)
 7e6:	00e7e463          	bltu	a5,a4,7ee <free+0x3a>
 7ea:	00e6ea63          	bltu	a3,a4,7fe <free+0x4a>
{
 7ee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	fed7fae3          	bgeu	a5,a3,7e4 <free+0x30>
 7f4:	6398                	ld	a4,0(a5)
 7f6:	00e6e463          	bltu	a3,a4,7fe <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fa:	fee7eae3          	bltu	a5,a4,7ee <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7fe:	ff852583          	lw	a1,-8(a0)
 802:	6390                	ld	a2,0(a5)
 804:	02059813          	slli	a6,a1,0x20
 808:	01c85713          	srli	a4,a6,0x1c
 80c:	9736                	add	a4,a4,a3
 80e:	fae60de3          	beq	a2,a4,7c8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 812:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 816:	4790                	lw	a2,8(a5)
 818:	02061593          	slli	a1,a2,0x20
 81c:	01c5d713          	srli	a4,a1,0x1c
 820:	973e                	add	a4,a4,a5
 822:	fae68ae3          	beq	a3,a4,7d6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 826:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 828:	00000717          	auipc	a4,0x0
 82c:	7ef73423          	sd	a5,2024(a4) # 1010 <freep>
}
 830:	6422                	ld	s0,8(sp)
 832:	0141                	addi	sp,sp,16
 834:	8082                	ret

0000000000000836 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 836:	7139                	addi	sp,sp,-64
 838:	fc06                	sd	ra,56(sp)
 83a:	f822                	sd	s0,48(sp)
 83c:	f426                	sd	s1,40(sp)
 83e:	ec4e                	sd	s3,24(sp)
 840:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 842:	02051493          	slli	s1,a0,0x20
 846:	9081                	srli	s1,s1,0x20
 848:	04bd                	addi	s1,s1,15
 84a:	8091                	srli	s1,s1,0x4
 84c:	0014899b          	addiw	s3,s1,1
 850:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 852:	00000517          	auipc	a0,0x0
 856:	7be53503          	ld	a0,1982(a0) # 1010 <freep>
 85a:	c915                	beqz	a0,88e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85e:	4798                	lw	a4,8(a5)
 860:	08977e63          	bgeu	a4,s1,8fc <malloc+0xc6>
 864:	f04a                	sd	s2,32(sp)
 866:	e852                	sd	s4,16(sp)
 868:	e456                	sd	s5,8(sp)
 86a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 86c:	8a4e                	mv	s4,s3
 86e:	0009871b          	sext.w	a4,s3
 872:	6685                	lui	a3,0x1
 874:	00d77363          	bgeu	a4,a3,87a <malloc+0x44>
 878:	6a05                	lui	s4,0x1
 87a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 882:	00000917          	auipc	s2,0x0
 886:	78e90913          	addi	s2,s2,1934 # 1010 <freep>
  if(p == (char*)-1)
 88a:	5afd                	li	s5,-1
 88c:	a091                	j	8d0 <malloc+0x9a>
 88e:	f04a                	sd	s2,32(sp)
 890:	e852                	sd	s4,16(sp)
 892:	e456                	sd	s5,8(sp)
 894:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 896:	00001797          	auipc	a5,0x1
 89a:	99a78793          	addi	a5,a5,-1638 # 1230 <base>
 89e:	00000717          	auipc	a4,0x0
 8a2:	76f73923          	sd	a5,1906(a4) # 1010 <freep>
 8a6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ac:	b7c1                	j	86c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	e118                	sd	a4,0(a0)
 8b2:	a08d                	j	914 <malloc+0xde>
  hp->s.size = nu;
 8b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b8:	0541                	addi	a0,a0,16
 8ba:	00000097          	auipc	ra,0x0
 8be:	efa080e7          	jalr	-262(ra) # 7b4 <free>
  return freep;
 8c2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c6:	c13d                	beqz	a0,92c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ca:	4798                	lw	a4,8(a5)
 8cc:	02977463          	bgeu	a4,s1,8f4 <malloc+0xbe>
    if(p == freep)
 8d0:	00093703          	ld	a4,0(s2)
 8d4:	853e                	mv	a0,a5
 8d6:	fef719e3          	bne	a4,a5,8c8 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 8da:	8552                	mv	a0,s4
 8dc:	00000097          	auipc	ra,0x0
 8e0:	b54080e7          	jalr	-1196(ra) # 430 <sbrk>
  if(p == (char*)-1)
 8e4:	fd5518e3          	bne	a0,s5,8b4 <malloc+0x7e>
        return 0;
 8e8:	4501                	li	a0,0
 8ea:	7902                	ld	s2,32(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
 8f2:	a03d                	j	920 <malloc+0xea>
 8f4:	7902                	ld	s2,32(sp)
 8f6:	6a42                	ld	s4,16(sp)
 8f8:	6aa2                	ld	s5,8(sp)
 8fa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8fc:	fae489e3          	beq	s1,a4,8ae <malloc+0x78>
        p->s.size -= nunits;
 900:	4137073b          	subw	a4,a4,s3
 904:	c798                	sw	a4,8(a5)
        p += p->s.size;
 906:	02071693          	slli	a3,a4,0x20
 90a:	01c6d713          	srli	a4,a3,0x1c
 90e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 910:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 914:	00000717          	auipc	a4,0x0
 918:	6ea73e23          	sd	a0,1788(a4) # 1010 <freep>
      return (void*)(p + 1);
 91c:	01078513          	addi	a0,a5,16
  }
}
 920:	70e2                	ld	ra,56(sp)
 922:	7442                	ld	s0,48(sp)
 924:	74a2                	ld	s1,40(sp)
 926:	69e2                	ld	s3,24(sp)
 928:	6121                	addi	sp,sp,64
 92a:	8082                	ret
 92c:	7902                	ld	s2,32(sp)
 92e:	6a42                	ld	s4,16(sp)
 930:	6aa2                	ld	s5,8(sp)
 932:	6b02                	ld	s6,0(sp)
 934:	b7f5                	j	920 <malloc+0xea>

0000000000000936 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 936:	1141                	addi	sp,sp,-16
 938:	e406                	sd	ra,8(sp)
 93a:	e022                	sd	s0,0(sp)
 93c:	0800                	addi	s0,sp,16
  thread_exit(status);
 93e:	2501                	sext.w	a0,a0
 940:	00000097          	auipc	ra,0x0
 944:	b20080e7          	jalr	-1248(ra) # 460 <thread_exit>
}
 948:	60a2                	ld	ra,8(sp)
 94a:	6402                	ld	s0,0(sp)
 94c:	0141                	addi	sp,sp,16
 94e:	8082                	ret

0000000000000950 <free_stacks>:
int free_stacks() {
 950:	7179                	addi	sp,sp,-48
 952:	f406                	sd	ra,40(sp)
 954:	f022                	sd	s0,32(sp)
 956:	ec26                	sd	s1,24(sp)
 958:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 95a:	00000797          	auipc	a5,0x0
 95e:	6c67a783          	lw	a5,1734(a5) # 1020 <num_threads>
 962:	04f05063          	blez	a5,9a2 <free_stacks+0x52>
 966:	e84a                	sd	s2,16(sp)
 968:	e44e                	sd	s3,8(sp)
 96a:	4481                	li	s1,0
    free(stacks[i]);
 96c:	00000997          	auipc	s3,0x0
 970:	6ac98993          	addi	s3,s3,1708 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 974:	00000917          	auipc	s2,0x0
 978:	6ac90913          	addi	s2,s2,1708 # 1020 <num_threads>
    free(stacks[i]);
 97c:	0009b783          	ld	a5,0(s3)
 980:	00349713          	slli	a4,s1,0x3
 984:	97ba                	add	a5,a5,a4
 986:	6388                	ld	a0,0(a5)
 988:	00000097          	auipc	ra,0x0
 98c:	e2c080e7          	jalr	-468(ra) # 7b4 <free>
  for (int i = 0; i < num_threads; i++) {
 990:	0485                	addi	s1,s1,1
 992:	00092703          	lw	a4,0(s2)
 996:	0004879b          	sext.w	a5,s1
 99a:	fee7c1e3          	blt	a5,a4,97c <free_stacks+0x2c>
 99e:	6942                	ld	s2,16(sp)
 9a0:	69a2                	ld	s3,8(sp)
  free(stacks);
 9a2:	00000497          	auipc	s1,0x0
 9a6:	67648493          	addi	s1,s1,1654 # 1018 <stacks>
 9aa:	6088                	ld	a0,0(s1)
 9ac:	00000097          	auipc	ra,0x0
 9b0:	e08080e7          	jalr	-504(ra) # 7b4 <free>
  stacks = 0;
 9b4:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9b8:	00000797          	auipc	a5,0x0
 9bc:	6607a423          	sw	zero,1640(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9c0:	47a1                	li	a5,8
 9c2:	00000717          	auipc	a4,0x0
 9c6:	62f72f23          	sw	a5,1598(a4) # 1000 <max_stacks>
  threads_done = 0;
 9ca:	00000797          	auipc	a5,0x0
 9ce:	6407ad23          	sw	zero,1626(a5) # 1024 <threads_done>
}
 9d2:	4501                	li	a0,0
 9d4:	70a2                	ld	ra,40(sp)
 9d6:	7402                	ld	s0,32(sp)
 9d8:	64e2                	ld	s1,24(sp)
 9da:	6145                	addi	sp,sp,48
 9dc:	8082                	ret

00000000000009de <expand_num_threads>:
int expand_num_threads() {
 9de:	1101                	addi	sp,sp,-32
 9e0:	ec06                	sd	ra,24(sp)
 9e2:	e822                	sd	s0,16(sp)
 9e4:	e426                	sd	s1,8(sp)
 9e6:	e04a                	sd	s2,0(sp)
 9e8:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9ea:	00000797          	auipc	a5,0x0
 9ee:	61678793          	addi	a5,a5,1558 # 1000 <max_stacks>
 9f2:	4388                	lw	a0,0(a5)
 9f4:	0015151b          	slliw	a0,a0,0x1
 9f8:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9fa:	0035151b          	slliw	a0,a0,0x3
 9fe:	00000097          	auipc	ra,0x0
 a02:	e38080e7          	jalr	-456(ra) # 836 <malloc>
 a06:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a08:	00000617          	auipc	a2,0x0
 a0c:	61862603          	lw	a2,1560(a2) # 1020 <num_threads>
 a10:	00000497          	auipc	s1,0x0
 a14:	60848493          	addi	s1,s1,1544 # 1018 <stacks>
 a18:	0036161b          	slliw	a2,a2,0x3
 a1c:	608c                	ld	a1,0(s1)
 a1e:	00000097          	auipc	ra,0x0
 a22:	8d8080e7          	jalr	-1832(ra) # 2f6 <memmove>
  free(stacks);
 a26:	6088                	ld	a0,0(s1)
 a28:	00000097          	auipc	ra,0x0
 a2c:	d8c080e7          	jalr	-628(ra) # 7b4 <free>
  stacks = new_stacks;
 a30:	0124b023          	sd	s2,0(s1)
}
 a34:	4501                	li	a0,0
 a36:	60e2                	ld	ra,24(sp)
 a38:	6442                	ld	s0,16(sp)
 a3a:	64a2                	ld	s1,8(sp)
 a3c:	6902                	ld	s2,0(sp)
 a3e:	6105                	addi	sp,sp,32
 a40:	8082                	ret

0000000000000a42 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a42:	7179                	addi	sp,sp,-48
 a44:	f406                	sd	ra,40(sp)
 a46:	f022                	sd	s0,32(sp)
 a48:	e84a                	sd	s2,16(sp)
 a4a:	e44e                	sd	s3,8(sp)
 a4c:	1800                	addi	s0,sp,48
 a4e:	892a                	mv	s2,a0
 a50:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a52:	00000797          	auipc	a5,0x0
 a56:	5c67b783          	ld	a5,1478(a5) # 1018 <stacks>
 a5a:	c3d9                	beqz	a5,ae0 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a5c:	00000797          	auipc	a5,0x0
 a60:	5a47a783          	lw	a5,1444(a5) # 1000 <max_stacks>
 a64:	00000717          	auipc	a4,0x0
 a68:	5bc72703          	lw	a4,1468(a4) # 1020 <num_threads>
 a6c:	0af71363          	bne	a4,a5,b12 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 a70:	04000713          	li	a4,64
 a74:	08e78563          	beq	a5,a4,afe <ithread_create+0xbc>
 a78:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a7a:	00000097          	auipc	ra,0x0
 a7e:	f64080e7          	jalr	-156(ra) # 9de <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a82:	6505                	lui	a0,0x1
 a84:	00000097          	auipc	ra,0x0
 a88:	db2080e7          	jalr	-590(ra) # 836 <malloc>
 a8c:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a8e:	00000717          	auipc	a4,0x0
 a92:	59272703          	lw	a4,1426(a4) # 1020 <num_threads>
 a96:	070e                	slli	a4,a4,0x3
 a98:	00000797          	auipc	a5,0x0
 a9c:	5807b783          	ld	a5,1408(a5) # 1018 <stacks>
 aa0:	97ba                	add	a5,a5,a4
 aa2:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 aa4:	00000697          	auipc	a3,0x0
 aa8:	e9268693          	addi	a3,a3,-366 # 936 <ithread_exit>
 aac:	862a                	mv	a2,a0
 aae:	85ce                	mv	a1,s3
 ab0:	854a                	mv	a0,s2
 ab2:	00000097          	auipc	ra,0x0
 ab6:	99e080e7          	jalr	-1634(ra) # 450 <create_thread>
 aba:	892a                	mv	s2,a0
  if (res != -1) {
 abc:	57fd                	li	a5,-1
 abe:	04f50c63          	beq	a0,a5,b16 <ithread_create+0xd4>
    num_threads++;
 ac2:	00000717          	auipc	a4,0x0
 ac6:	55e70713          	addi	a4,a4,1374 # 1020 <num_threads>
 aca:	431c                	lw	a5,0(a4)
 acc:	2785                	addiw	a5,a5,1
 ace:	c31c                	sw	a5,0(a4)
 ad0:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 ad2:	854a                	mv	a0,s2
 ad4:	70a2                	ld	ra,40(sp)
 ad6:	7402                	ld	s0,32(sp)
 ad8:	6942                	ld	s2,16(sp)
 ada:	69a2                	ld	s3,8(sp)
 adc:	6145                	addi	sp,sp,48
 ade:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 ae0:	00000517          	auipc	a0,0x0
 ae4:	52052503          	lw	a0,1312(a0) # 1000 <max_stacks>
 ae8:	0035151b          	slliw	a0,a0,0x3
 aec:	00000097          	auipc	ra,0x0
 af0:	d4a080e7          	jalr	-694(ra) # 836 <malloc>
 af4:	00000797          	auipc	a5,0x0
 af8:	52a7b223          	sd	a0,1316(a5) # 1018 <stacks>
 afc:	b785                	j	a5c <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 afe:	00000517          	auipc	a0,0x0
 b02:	0e250513          	addi	a0,a0,226 # be0 <ithread_join+0xa4>
 b06:	00000097          	auipc	ra,0x0
 b0a:	c78080e7          	jalr	-904(ra) # 77e <printf>
      return -1;
 b0e:	597d                	li	s2,-1
 b10:	b7c9                	j	ad2 <ithread_create+0x90>
 b12:	ec26                	sd	s1,24(sp)
 b14:	b7bd                	j	a82 <ithread_create+0x40>
    free(stack_ptr);
 b16:	8526                	mv	a0,s1
 b18:	00000097          	auipc	ra,0x0
 b1c:	c9c080e7          	jalr	-868(ra) # 7b4 <free>
    stacks[num_threads] = 0;
 b20:	00000717          	auipc	a4,0x0
 b24:	50072703          	lw	a4,1280(a4) # 1020 <num_threads>
 b28:	070e                	slli	a4,a4,0x3
 b2a:	00000797          	auipc	a5,0x0
 b2e:	4ee7b783          	ld	a5,1262(a5) # 1018 <stacks>
 b32:	97ba                	add	a5,a5,a4
 b34:	0007b023          	sd	zero,0(a5)
 b38:	64e2                	ld	s1,24(sp)
 b3a:	bf61                	j	ad2 <ithread_create+0x90>

0000000000000b3c <ithread_join>:

int ithread_join(int thread_id) {
 b3c:	1101                	addi	sp,sp,-32
 b3e:	ec06                	sd	ra,24(sp)
 b40:	e822                	sd	s0,16(sp)
 b42:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b44:	ff040793          	addi	a5,s0,-16
 b48:	ffc7859b          	addiw	a1,a5,-4
 b4c:	00000097          	auipc	ra,0x0
 b50:	90c080e7          	jalr	-1780(ra) # 458 <join_thread>
  threads_done++;
 b54:	00000717          	auipc	a4,0x0
 b58:	4d070713          	addi	a4,a4,1232 # 1024 <threads_done>
 b5c:	431c                	lw	a5,0(a4)
 b5e:	2785                	addiw	a5,a5,1
 b60:	0007869b          	sext.w	a3,a5
 b64:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b66:	00000797          	auipc	a5,0x0
 b6a:	4ba7a783          	lw	a5,1210(a5) # 1020 <num_threads>
 b6e:	00d78863          	beq	a5,a3,b7e <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 b72:	fec42503          	lw	a0,-20(s0)
 b76:	60e2                	ld	ra,24(sp)
 b78:	6442                	ld	s0,16(sp)
 b7a:	6105                	addi	sp,sp,32
 b7c:	8082                	ret
    free_stacks();
 b7e:	00000097          	auipc	ra,0x0
 b82:	dd2080e7          	jalr	-558(ra) # 950 <free_stacks>
 b86:	b7f5                	j	b72 <ithread_join+0x36>
