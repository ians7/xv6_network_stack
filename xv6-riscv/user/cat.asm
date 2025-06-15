
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
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
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	20000a13          	li	s4,512
  18:	00001917          	auipc	s2,0x1
  1c:	56890913          	addi	s2,s2,1384 # 1580 <buf>
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	00000097          	auipc	ra,0x0
  2c:	3c6080e7          	jalr	966(ra) # 3ee <read>
  30:	84aa                	mv	s1,a0
  32:	02a05963          	blez	a0,64 <cat+0x64>
    if (write(1, buf, n) != n) {
  36:	8626                	mv	a2,s1
  38:	85ca                	mv	a1,s2
  3a:	8556                	mv	a0,s5
  3c:	00000097          	auipc	ra,0x0
  40:	3ba080e7          	jalr	954(ra) # 3f6 <write>
  44:	fc950fe3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  48:	00001597          	auipc	a1,0x1
  4c:	b1858593          	addi	a1,a1,-1256 # b60 <ithread_join+0x48>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	6dc080e7          	jalr	1756(ra) # 72e <fprintf>
      exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	37a080e7          	jalr	890(ra) # 3d6 <exit>
    }
  }
  if(n < 0){
  64:	00054b63          	bltz	a0,7a <cat+0x7a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  68:	70e2                	ld	ra,56(sp)
  6a:	7442                	ld	s0,48(sp)
  6c:	74a2                	ld	s1,40(sp)
  6e:	7902                	ld	s2,32(sp)
  70:	69e2                	ld	s3,24(sp)
  72:	6a42                	ld	s4,16(sp)
  74:	6aa2                	ld	s5,8(sp)
  76:	6121                	addi	sp,sp,64
  78:	8082                	ret
    fprintf(2, "cat: read error\n");
  7a:	00001597          	auipc	a1,0x1
  7e:	afe58593          	addi	a1,a1,-1282 # b78 <ithread_join+0x60>
  82:	4509                	li	a0,2
  84:	00000097          	auipc	ra,0x0
  88:	6aa080e7          	jalr	1706(ra) # 72e <fprintf>
    exit(1);
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	348080e7          	jalr	840(ra) # 3d6 <exit>

0000000000000096 <main>:

int
main(int argc, char *argv[])
{
  96:	7179                	addi	sp,sp,-48
  98:	f406                	sd	ra,40(sp)
  9a:	f022                	sd	s0,32(sp)
  9c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9e:	4785                	li	a5,1
  a0:	04a7da63          	bge	a5,a0,f4 <main+0x5e>
  a4:	ec26                	sd	s1,24(sp)
  a6:	e84a                	sd	s2,16(sp)
  a8:	e44e                	sd	s3,8(sp)
  aa:	00858913          	addi	s2,a1,8
  ae:	ffe5099b          	addiw	s3,a0,-2
  b2:	02099793          	slli	a5,s3,0x20
  b6:	01d7d993          	srli	s3,a5,0x1d
  ba:	05c1                	addi	a1,a1,16
  bc:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  be:	4581                	li	a1,0
  c0:	00093503          	ld	a0,0(s2)
  c4:	00000097          	auipc	ra,0x0
  c8:	352080e7          	jalr	850(ra) # 416 <open>
  cc:	84aa                	mv	s1,a0
  ce:	04054063          	bltz	a0,10e <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <cat>
    close(fd);
  da:	8526                	mv	a0,s1
  dc:	00000097          	auipc	ra,0x0
  e0:	322080e7          	jalr	802(ra) # 3fe <close>
  for(i = 1; i < argc; i++){
  e4:	0921                	addi	s2,s2,8
  e6:	fd391ce3          	bne	s2,s3,be <main+0x28>
  }
  exit(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	2ea080e7          	jalr	746(ra) # 3d6 <exit>
  f4:	ec26                	sd	s1,24(sp)
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
    cat(0);
  fa:	4501                	li	a0,0
  fc:	00000097          	auipc	ra,0x0
 100:	f04080e7          	jalr	-252(ra) # 0 <cat>
    exit(0);
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	2d0080e7          	jalr	720(ra) # 3d6 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 10e:	00093603          	ld	a2,0(s2)
 112:	00001597          	auipc	a1,0x1
 116:	a7e58593          	addi	a1,a1,-1410 # b90 <ithread_join+0x78>
 11a:	4509                	li	a0,2
 11c:	00000097          	auipc	ra,0x0
 120:	612080e7          	jalr	1554(ra) # 72e <fprintf>
      exit(1);
 124:	4505                	li	a0,1
 126:	00000097          	auipc	ra,0x0
 12a:	2b0080e7          	jalr	688(ra) # 3d6 <exit>

000000000000012e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  extern int main();
  main();
 136:	00000097          	auipc	ra,0x0
 13a:	f60080e7          	jalr	-160(ra) # 96 <main>
  exit(0);
 13e:	4501                	li	a0,0
 140:	00000097          	auipc	ra,0x0
 144:	296080e7          	jalr	662(ra) # 3d6 <exit>

0000000000000148 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 150:	87aa                	mv	a5,a0
 152:	0585                	addi	a1,a1,1
 154:	0785                	addi	a5,a5,1
 156:	fff5c703          	lbu	a4,-1(a1)
 15a:	fee78fa3          	sb	a4,-1(a5)
 15e:	fb75                	bnez	a4,152 <strcpy+0xa>
    ;
  return os;
}
 160:	60a2                	ld	ra,8(sp)
 162:	6402                	ld	s0,0(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e406                	sd	ra,8(sp)
 16c:	e022                	sd	s0,0(sp)
 16e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	cb91                	beqz	a5,188 <strcmp+0x20>
 176:	0005c703          	lbu	a4,0(a1)
 17a:	00f71763          	bne	a4,a5,188 <strcmp+0x20>
    p++, q++;
 17e:	0505                	addi	a0,a0,1
 180:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	fbe5                	bnez	a5,176 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 188:	0005c503          	lbu	a0,0(a1)
}
 18c:	40a7853b          	subw	a0,a5,a0
 190:	60a2                	ld	ra,8(sp)
 192:	6402                	ld	s0,0(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret

0000000000000198 <strlen>:

uint
strlen(const char *s)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e406                	sd	ra,8(sp)
 19c:	e022                	sd	s0,0(sp)
 19e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	cf91                	beqz	a5,1c0 <strlen+0x28>
 1a6:	00150793          	addi	a5,a0,1
 1aa:	86be                	mv	a3,a5
 1ac:	0785                	addi	a5,a5,1
 1ae:	fff7c703          	lbu	a4,-1(a5)
 1b2:	ff65                	bnez	a4,1aa <strlen+0x12>
 1b4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
  for(n = 0; s[n]; n++)
 1c0:	4501                	li	a0,0
 1c2:	bfdd                	j	1b8 <strlen+0x20>

00000000000001c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c4:	1141                	addi	sp,sp,-16
 1c6:	e406                	sd	ra,8(sp)
 1c8:	e022                	sd	s0,0(sp)
 1ca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1cc:	ca19                	beqz	a2,1e2 <memset+0x1e>
 1ce:	87aa                	mv	a5,a0
 1d0:	1602                	slli	a2,a2,0x20
 1d2:	9201                	srli	a2,a2,0x20
 1d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1dc:	0785                	addi	a5,a5,1
 1de:	fee79de3          	bne	a5,a4,1d8 <memset+0x14>
  }
  return dst;
}
 1e2:	60a2                	ld	ra,8(sp)
 1e4:	6402                	ld	s0,0(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret

00000000000001ea <strchr>:

char*
strchr(const char *s, char c)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cf81                	beqz	a5,20e <strchr+0x24>
    if(*s == c)
 1f8:	00f58763          	beq	a1,a5,206 <strchr+0x1c>
  for(; *s; s++)
 1fc:	0505                	addi	a0,a0,1
 1fe:	00054783          	lbu	a5,0(a0)
 202:	fbfd                	bnez	a5,1f8 <strchr+0xe>
      return (char*)s;
  return 0;
 204:	4501                	li	a0,0
}
 206:	60a2                	ld	ra,8(sp)
 208:	6402                	ld	s0,0(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
  return 0;
 20e:	4501                	li	a0,0
 210:	bfdd                	j	206 <strchr+0x1c>

0000000000000212 <gets>:

char*
gets(char *buf, int max)
{
 212:	711d                	addi	sp,sp,-96
 214:	ec86                	sd	ra,88(sp)
 216:	e8a2                	sd	s0,80(sp)
 218:	e4a6                	sd	s1,72(sp)
 21a:	e0ca                	sd	s2,64(sp)
 21c:	fc4e                	sd	s3,56(sp)
 21e:	f852                	sd	s4,48(sp)
 220:	f456                	sd	s5,40(sp)
 222:	f05a                	sd	s6,32(sp)
 224:	ec5e                	sd	s7,24(sp)
 226:	e862                	sd	s8,16(sp)
 228:	1080                	addi	s0,sp,96
 22a:	8baa                	mv	s7,a0
 22c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	892a                	mv	s2,a0
 230:	4481                	li	s1,0
    cc = read(0, &c, 1);
 232:	faf40b13          	addi	s6,s0,-81
 236:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 238:	8c26                	mv	s8,s1
 23a:	0014899b          	addiw	s3,s1,1
 23e:	84ce                	mv	s1,s3
 240:	0349d663          	bge	s3,s4,26c <gets+0x5a>
    cc = read(0, &c, 1);
 244:	8656                	mv	a2,s5
 246:	85da                	mv	a1,s6
 248:	4501                	li	a0,0
 24a:	00000097          	auipc	ra,0x0
 24e:	1a4080e7          	jalr	420(ra) # 3ee <read>
    if(cc < 1)
 252:	00a05d63          	blez	a0,26c <gets+0x5a>
      break;
    buf[i++] = c;
 256:	faf44783          	lbu	a5,-81(s0)
 25a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25e:	0905                	addi	s2,s2,1
 260:	ff678713          	addi	a4,a5,-10
 264:	c319                	beqz	a4,26a <gets+0x58>
 266:	17cd                	addi	a5,a5,-13
 268:	fbe1                	bnez	a5,238 <gets+0x26>
    buf[i++] = c;
 26a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 26c:	9c5e                	add	s8,s8,s7
 26e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 272:	855e                	mv	a0,s7
 274:	60e6                	ld	ra,88(sp)
 276:	6446                	ld	s0,80(sp)
 278:	64a6                	ld	s1,72(sp)
 27a:	6906                	ld	s2,64(sp)
 27c:	79e2                	ld	s3,56(sp)
 27e:	7a42                	ld	s4,48(sp)
 280:	7aa2                	ld	s5,40(sp)
 282:	7b02                	ld	s6,32(sp)
 284:	6be2                	ld	s7,24(sp)
 286:	6c42                	ld	s8,16(sp)
 288:	6125                	addi	sp,sp,96
 28a:	8082                	ret

000000000000028c <stat>:

int
stat(const char *n, struct stat *st)
{
 28c:	1101                	addi	sp,sp,-32
 28e:	ec06                	sd	ra,24(sp)
 290:	e822                	sd	s0,16(sp)
 292:	e04a                	sd	s2,0(sp)
 294:	1000                	addi	s0,sp,32
 296:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 298:	4581                	li	a1,0
 29a:	00000097          	auipc	ra,0x0
 29e:	17c080e7          	jalr	380(ra) # 416 <open>
  if(fd < 0)
 2a2:	02054663          	bltz	a0,2ce <stat+0x42>
 2a6:	e426                	sd	s1,8(sp)
 2a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2aa:	85ca                	mv	a1,s2
 2ac:	00000097          	auipc	ra,0x0
 2b0:	182080e7          	jalr	386(ra) # 42e <fstat>
 2b4:	892a                	mv	s2,a0
  close(fd);
 2b6:	8526                	mv	a0,s1
 2b8:	00000097          	auipc	ra,0x0
 2bc:	146080e7          	jalr	326(ra) # 3fe <close>
  return r;
 2c0:	64a2                	ld	s1,8(sp)
}
 2c2:	854a                	mv	a0,s2
 2c4:	60e2                	ld	ra,24(sp)
 2c6:	6442                	ld	s0,16(sp)
 2c8:	6902                	ld	s2,0(sp)
 2ca:	6105                	addi	sp,sp,32
 2cc:	8082                	ret
    return -1;
 2ce:	57fd                	li	a5,-1
 2d0:	893e                	mv	s2,a5
 2d2:	bfc5                	j	2c2 <stat+0x36>

00000000000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2dc:	00054683          	lbu	a3,0(a0)
 2e0:	fd06879b          	addiw	a5,a3,-48
 2e4:	0ff7f793          	zext.b	a5,a5
 2e8:	4625                	li	a2,9
 2ea:	02f66963          	bltu	a2,a5,31c <atoi+0x48>
 2ee:	872a                	mv	a4,a0
  n = 0;
 2f0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2f2:	0705                	addi	a4,a4,1
 2f4:	0025179b          	slliw	a5,a0,0x2
 2f8:	9fa9                	addw	a5,a5,a0
 2fa:	0017979b          	slliw	a5,a5,0x1
 2fe:	9fb5                	addw	a5,a5,a3
 300:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 304:	00074683          	lbu	a3,0(a4)
 308:	fd06879b          	addiw	a5,a3,-48
 30c:	0ff7f793          	zext.b	a5,a5
 310:	fef671e3          	bgeu	a2,a5,2f2 <atoi+0x1e>
  return n;
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
  n = 0;
 31c:	4501                	li	a0,0
 31e:	bfdd                	j	314 <atoi+0x40>

0000000000000320 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 328:	02b57563          	bgeu	a0,a1,352 <memmove+0x32>
    while(n-- > 0)
 32c:	00c05f63          	blez	a2,34a <memmove+0x2a>
 330:	1602                	slli	a2,a2,0x20
 332:	9201                	srli	a2,a2,0x20
 334:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 338:	872a                	mv	a4,a0
      *dst++ = *src++;
 33a:	0585                	addi	a1,a1,1
 33c:	0705                	addi	a4,a4,1
 33e:	fff5c683          	lbu	a3,-1(a1)
 342:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 346:	fee79ae3          	bne	a5,a4,33a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
    while(n-- > 0)
 352:	fec05ce3          	blez	a2,34a <memmove+0x2a>
    dst += n;
 356:	00c50733          	add	a4,a0,a2
    src += n;
 35a:	95b2                	add	a1,a1,a2
 35c:	fff6079b          	addiw	a5,a2,-1
 360:	1782                	slli	a5,a5,0x20
 362:	9381                	srli	a5,a5,0x20
 364:	fff7c793          	not	a5,a5
 368:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36a:	15fd                	addi	a1,a1,-1
 36c:	177d                	addi	a4,a4,-1
 36e:	0005c683          	lbu	a3,0(a1)
 372:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 376:	fef71ae3          	bne	a4,a5,36a <memmove+0x4a>
 37a:	bfc1                	j	34a <memmove+0x2a>

000000000000037c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 384:	c61d                	beqz	a2,3b2 <memcmp+0x36>
 386:	1602                	slli	a2,a2,0x20
 388:	9201                	srli	a2,a2,0x20
 38a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 38e:	00054783          	lbu	a5,0(a0)
 392:	0005c703          	lbu	a4,0(a1)
 396:	00e79863          	bne	a5,a4,3a6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 39a:	0505                	addi	a0,a0,1
    p2++;
 39c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 39e:	fed518e3          	bne	a0,a3,38e <memcmp+0x12>
  }
  return 0;
 3a2:	4501                	li	a0,0
 3a4:	a019                	j	3aa <memcmp+0x2e>
      return *p1 - *p2;
 3a6:	40e7853b          	subw	a0,a5,a4
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
  return 0;
 3b2:	4501                	li	a0,0
 3b4:	bfdd                	j	3aa <memcmp+0x2e>

00000000000003b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3be:	00000097          	auipc	ra,0x0
 3c2:	f62080e7          	jalr	-158(ra) # 320 <memmove>
}
 3c6:	60a2                	ld	ra,8(sp)
 3c8:	6402                	ld	s0,0(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ce:	4885                	li	a7,1
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d6:	4889                	li	a7,2
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <wait>:
.global wait
wait:
 li a7, SYS_wait
 3de:	488d                	li	a7,3
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e6:	4891                	li	a7,4
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <read>:
.global read
read:
 li a7, SYS_read
 3ee:	4895                	li	a7,5
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <write>:
.global write
write:
 li a7, SYS_write
 3f6:	48c1                	li	a7,16
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <close>:
.global close
close:
 li a7, SYS_close
 3fe:	48d5                	li	a7,21
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <kill>:
.global kill
kill:
 li a7, SYS_kill
 406:	4899                	li	a7,6
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <exec>:
.global exec
exec:
 li a7, SYS_exec
 40e:	489d                	li	a7,7
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <open>:
.global open
open:
 li a7, SYS_open
 416:	48bd                	li	a7,15
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41e:	48c5                	li	a7,17
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 426:	48c9                	li	a7,18
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42e:	48a1                	li	a7,8
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <link>:
.global link
link:
 li a7, SYS_link
 436:	48cd                	li	a7,19
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43e:	48d1                	li	a7,20
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 446:	48a5                	li	a7,9
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <dup>:
.global dup
dup:
 li a7, SYS_dup
 44e:	48a9                	li	a7,10
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 456:	48ad                	li	a7,11
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45e:	48b1                	li	a7,12
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 466:	48b5                	li	a7,13
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46e:	48b9                	li	a7,14
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 476:	48d9                	li	a7,22
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 47e:	48dd                	li	a7,23
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 486:	48e1                	li	a7,24
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 48e:	48e5                	li	a7,25
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 496:	1101                	addi	sp,sp,-32
 498:	ec06                	sd	ra,24(sp)
 49a:	e822                	sd	s0,16(sp)
 49c:	1000                	addi	s0,sp,32
 49e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a2:	4605                	li	a2,1
 4a4:	fef40593          	addi	a1,s0,-17
 4a8:	00000097          	auipc	ra,0x0
 4ac:	f4e080e7          	jalr	-178(ra) # 3f6 <write>
}
 4b0:	60e2                	ld	ra,24(sp)
 4b2:	6442                	ld	s0,16(sp)
 4b4:	6105                	addi	sp,sp,32
 4b6:	8082                	ret

00000000000004b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b8:	7139                	addi	sp,sp,-64
 4ba:	fc06                	sd	ra,56(sp)
 4bc:	f822                	sd	s0,48(sp)
 4be:	f04a                	sd	s2,32(sp)
 4c0:	ec4e                	sd	s3,24(sp)
 4c2:	0080                	addi	s0,sp,64
 4c4:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4c6:	cad9                	beqz	a3,55c <printint+0xa4>
 4c8:	01f5d79b          	srliw	a5,a1,0x1f
 4cc:	cbc1                	beqz	a5,55c <printint+0xa4>
    neg = 1;
    x = -xx;
 4ce:	40b005bb          	negw	a1,a1
    neg = 1;
 4d2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4d4:	fc040993          	addi	s3,s0,-64
  neg = 0;
 4d8:	86ce                	mv	a3,s3
  i = 0;
 4da:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4dc:	00000817          	auipc	a6,0x0
 4e0:	75c80813          	addi	a6,a6,1884 # c38 <digits>
 4e4:	88ba                	mv	a7,a4
 4e6:	0017051b          	addiw	a0,a4,1
 4ea:	872a                	mv	a4,a0
 4ec:	02c5f7bb          	remuw	a5,a1,a2
 4f0:	1782                	slli	a5,a5,0x20
 4f2:	9381                	srli	a5,a5,0x20
 4f4:	97c2                	add	a5,a5,a6
 4f6:	0007c783          	lbu	a5,0(a5)
 4fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fe:	87ae                	mv	a5,a1
 500:	02c5d5bb          	divuw	a1,a1,a2
 504:	0685                	addi	a3,a3,1
 506:	fcc7ffe3          	bgeu	a5,a2,4e4 <printint+0x2c>
  if(neg)
 50a:	00030c63          	beqz	t1,522 <printint+0x6a>
    buf[i++] = '-';
 50e:	fd050793          	addi	a5,a0,-48
 512:	00878533          	add	a0,a5,s0
 516:	02d00793          	li	a5,45
 51a:	fef50823          	sb	a5,-16(a0)
 51e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 522:	02e05763          	blez	a4,550 <printint+0x98>
 526:	f426                	sd	s1,40(sp)
 528:	377d                	addiw	a4,a4,-1
 52a:	00e984b3          	add	s1,s3,a4
 52e:	19fd                	addi	s3,s3,-1
 530:	99ba                	add	s3,s3,a4
 532:	1702                	slli	a4,a4,0x20
 534:	9301                	srli	a4,a4,0x20
 536:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 53a:	0004c583          	lbu	a1,0(s1)
 53e:	854a                	mv	a0,s2
 540:	00000097          	auipc	ra,0x0
 544:	f56080e7          	jalr	-170(ra) # 496 <putc>
  while(--i >= 0)
 548:	14fd                	addi	s1,s1,-1
 54a:	ff3498e3          	bne	s1,s3,53a <printint+0x82>
 54e:	74a2                	ld	s1,40(sp)
}
 550:	70e2                	ld	ra,56(sp)
 552:	7442                	ld	s0,48(sp)
 554:	7902                	ld	s2,32(sp)
 556:	69e2                	ld	s3,24(sp)
 558:	6121                	addi	sp,sp,64
 55a:	8082                	ret
  neg = 0;
 55c:	4301                	li	t1,0
 55e:	bf9d                	j	4d4 <printint+0x1c>

0000000000000560 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 560:	715d                	addi	sp,sp,-80
 562:	e486                	sd	ra,72(sp)
 564:	e0a2                	sd	s0,64(sp)
 566:	f84a                	sd	s2,48(sp)
 568:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 56a:	0005c903          	lbu	s2,0(a1)
 56e:	1a090b63          	beqz	s2,724 <vprintf+0x1c4>
 572:	fc26                	sd	s1,56(sp)
 574:	f44e                	sd	s3,40(sp)
 576:	f052                	sd	s4,32(sp)
 578:	ec56                	sd	s5,24(sp)
 57a:	e85a                	sd	s6,16(sp)
 57c:	e45e                	sd	s7,8(sp)
 57e:	8aaa                	mv	s5,a0
 580:	8bb2                	mv	s7,a2
 582:	00158493          	addi	s1,a1,1
  state = 0;
 586:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 588:	02500a13          	li	s4,37
 58c:	4b55                	li	s6,21
 58e:	a839                	j	5ac <vprintf+0x4c>
        putc(fd, c);
 590:	85ca                	mv	a1,s2
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	f02080e7          	jalr	-254(ra) # 496 <putc>
 59c:	a019                	j	5a2 <vprintf+0x42>
    } else if(state == '%'){
 59e:	01498d63          	beq	s3,s4,5b8 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5a2:	0485                	addi	s1,s1,1
 5a4:	fff4c903          	lbu	s2,-1(s1)
 5a8:	16090863          	beqz	s2,718 <vprintf+0x1b8>
    if(state == 0){
 5ac:	fe0999e3          	bnez	s3,59e <vprintf+0x3e>
      if(c == '%'){
 5b0:	ff4910e3          	bne	s2,s4,590 <vprintf+0x30>
        state = '%';
 5b4:	89d2                	mv	s3,s4
 5b6:	b7f5                	j	5a2 <vprintf+0x42>
      if(c == 'd'){
 5b8:	13490563          	beq	s2,s4,6e2 <vprintf+0x182>
 5bc:	f9d9079b          	addiw	a5,s2,-99
 5c0:	0ff7f793          	zext.b	a5,a5
 5c4:	12fb6863          	bltu	s6,a5,6f4 <vprintf+0x194>
 5c8:	f9d9079b          	addiw	a5,s2,-99
 5cc:	0ff7f713          	zext.b	a4,a5
 5d0:	12eb6263          	bltu	s6,a4,6f4 <vprintf+0x194>
 5d4:	00271793          	slli	a5,a4,0x2
 5d8:	00000717          	auipc	a4,0x0
 5dc:	60870713          	addi	a4,a4,1544 # be0 <ithread_join+0xc8>
 5e0:	97ba                	add	a5,a5,a4
 5e2:	439c                	lw	a5,0(a5)
 5e4:	97ba                	add	a5,a5,a4
 5e6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4685                	li	a3,1
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	ec2080e7          	jalr	-318(ra) # 4b8 <printint>
 5fe:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 600:	4981                	li	s3,0
 602:	b745                	j	5a2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 604:	008b8913          	addi	s2,s7,8
 608:	4681                	li	a3,0
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	ea6080e7          	jalr	-346(ra) # 4b8 <printint>
 61a:	8bca                	mv	s7,s2
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b751                	j	5a2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 620:	008b8913          	addi	s2,s7,8
 624:	4681                	li	a3,0
 626:	4641                	li	a2,16
 628:	000ba583          	lw	a1,0(s7)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	e8a080e7          	jalr	-374(ra) # 4b8 <printint>
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	b7a5                	j	5a2 <vprintf+0x42>
 63c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 63e:	008b8793          	addi	a5,s7,8
 642:	8c3e                	mv	s8,a5
 644:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 648:	03000593          	li	a1,48
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e48080e7          	jalr	-440(ra) # 496 <putc>
  putc(fd, 'x');
 656:	07800593          	li	a1,120
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	e3a080e7          	jalr	-454(ra) # 496 <putc>
 664:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 666:	00000b97          	auipc	s7,0x0
 66a:	5d2b8b93          	addi	s7,s7,1490 # c38 <digits>
 66e:	03c9d793          	srli	a5,s3,0x3c
 672:	97de                	add	a5,a5,s7
 674:	0007c583          	lbu	a1,0(a5)
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	e1c080e7          	jalr	-484(ra) # 496 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 682:	0992                	slli	s3,s3,0x4
 684:	397d                	addiw	s2,s2,-1
 686:	fe0914e3          	bnez	s2,66e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 68a:	8be2                	mv	s7,s8
      state = 0;
 68c:	4981                	li	s3,0
 68e:	6c02                	ld	s8,0(sp)
 690:	bf09                	j	5a2 <vprintf+0x42>
        s = va_arg(ap, char*);
 692:	008b8993          	addi	s3,s7,8
 696:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 69a:	02090163          	beqz	s2,6bc <vprintf+0x15c>
        while(*s != 0){
 69e:	00094583          	lbu	a1,0(s2)
 6a2:	c9a5                	beqz	a1,712 <vprintf+0x1b2>
          putc(fd, *s);
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	df0080e7          	jalr	-528(ra) # 496 <putc>
          s++;
 6ae:	0905                	addi	s2,s2,1
        while(*s != 0){
 6b0:	00094583          	lbu	a1,0(s2)
 6b4:	f9e5                	bnez	a1,6a4 <vprintf+0x144>
        s = va_arg(ap, char*);
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b5e5                	j	5a2 <vprintf+0x42>
          s = "(null)";
 6bc:	00000917          	auipc	s2,0x0
 6c0:	4ec90913          	addi	s2,s2,1260 # ba8 <ithread_join+0x90>
        while(*s != 0){
 6c4:	02800593          	li	a1,40
 6c8:	bff1                	j	6a4 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 6ca:	008b8913          	addi	s2,s7,8
 6ce:	000bc583          	lbu	a1,0(s7)
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	dc2080e7          	jalr	-574(ra) # 496 <putc>
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b5c9                	j	5a2 <vprintf+0x42>
        putc(fd, c);
 6e2:	02500593          	li	a1,37
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	dae080e7          	jalr	-594(ra) # 496 <putc>
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bd45                	j	5a2 <vprintf+0x42>
        putc(fd, '%');
 6f4:	02500593          	li	a1,37
 6f8:	8556                	mv	a0,s5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	d9c080e7          	jalr	-612(ra) # 496 <putc>
        putc(fd, c);
 702:	85ca                	mv	a1,s2
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	d90080e7          	jalr	-624(ra) # 496 <putc>
      state = 0;
 70e:	4981                	li	s3,0
 710:	bd49                	j	5a2 <vprintf+0x42>
        s = va_arg(ap, char*);
 712:	8bce                	mv	s7,s3
      state = 0;
 714:	4981                	li	s3,0
 716:	b571                	j	5a2 <vprintf+0x42>
 718:	74e2                	ld	s1,56(sp)
 71a:	79a2                	ld	s3,40(sp)
 71c:	7a02                	ld	s4,32(sp)
 71e:	6ae2                	ld	s5,24(sp)
 720:	6b42                	ld	s6,16(sp)
 722:	6ba2                	ld	s7,8(sp)
    }
  }
}
 724:	60a6                	ld	ra,72(sp)
 726:	6406                	ld	s0,64(sp)
 728:	7942                	ld	s2,48(sp)
 72a:	6161                	addi	sp,sp,80
 72c:	8082                	ret

000000000000072e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 72e:	715d                	addi	sp,sp,-80
 730:	ec06                	sd	ra,24(sp)
 732:	e822                	sd	s0,16(sp)
 734:	1000                	addi	s0,sp,32
 736:	e010                	sd	a2,0(s0)
 738:	e414                	sd	a3,8(s0)
 73a:	e818                	sd	a4,16(s0)
 73c:	ec1c                	sd	a5,24(s0)
 73e:	03043023          	sd	a6,32(s0)
 742:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 746:	8622                	mv	a2,s0
 748:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74c:	00000097          	auipc	ra,0x0
 750:	e14080e7          	jalr	-492(ra) # 560 <vprintf>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6161                	addi	sp,sp,80
 75a:	8082                	ret

000000000000075c <printf>:

void
printf(const char *fmt, ...)
{
 75c:	711d                	addi	sp,sp,-96
 75e:	ec06                	sd	ra,24(sp)
 760:	e822                	sd	s0,16(sp)
 762:	1000                	addi	s0,sp,32
 764:	e40c                	sd	a1,8(s0)
 766:	e810                	sd	a2,16(s0)
 768:	ec14                	sd	a3,24(s0)
 76a:	f018                	sd	a4,32(s0)
 76c:	f41c                	sd	a5,40(s0)
 76e:	03043823          	sd	a6,48(s0)
 772:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 776:	00840613          	addi	a2,s0,8
 77a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 77e:	85aa                	mv	a1,a0
 780:	4505                	li	a0,1
 782:	00000097          	auipc	ra,0x0
 786:	dde080e7          	jalr	-546(ra) # 560 <vprintf>
}
 78a:	60e2                	ld	ra,24(sp)
 78c:	6442                	ld	s0,16(sp)
 78e:	6125                	addi	sp,sp,96
 790:	8082                	ret

0000000000000792 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 792:	1141                	addi	sp,sp,-16
 794:	e406                	sd	ra,8(sp)
 796:	e022                	sd	s0,0(sp)
 798:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	00001797          	auipc	a5,0x1
 7a2:	dc27b783          	ld	a5,-574(a5) # 1560 <freep>
 7a6:	a039                	j	7b4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e7e463          	bltu	a5,a4,7b2 <free+0x20>
 7ae:	00e6ea63          	bltu	a3,a4,7c2 <free+0x30>
{
 7b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	fed7fae3          	bgeu	a5,a3,7a8 <free+0x16>
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e6e463          	bltu	a3,a4,7c2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	fee7eae3          	bltu	a5,a4,7b2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c2:	ff852583          	lw	a1,-8(a0)
 7c6:	6390                	ld	a2,0(a5)
 7c8:	02059813          	slli	a6,a1,0x20
 7cc:	01c85713          	srli	a4,a6,0x1c
 7d0:	9736                	add	a4,a4,a3
 7d2:	02e60563          	beq	a2,a4,7fc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7da:	4790                	lw	a2,8(a5)
 7dc:	02061593          	slli	a1,a2,0x20
 7e0:	01c5d713          	srli	a4,a1,0x1c
 7e4:	973e                	add	a4,a4,a5
 7e6:	02e68263          	beq	a3,a4,80a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ec:	00001717          	auipc	a4,0x1
 7f0:	d6f73a23          	sd	a5,-652(a4) # 1560 <freep>
}
 7f4:	60a2                	ld	ra,8(sp)
 7f6:	6402                	ld	s0,0(sp)
 7f8:	0141                	addi	sp,sp,16
 7fa:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7fc:	4618                	lw	a4,8(a2)
 7fe:	9f2d                	addw	a4,a4,a1
 800:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 804:	6398                	ld	a4,0(a5)
 806:	6310                	ld	a2,0(a4)
 808:	b7f9                	j	7d6 <free+0x44>
    p->s.size += bp->s.size;
 80a:	ff852703          	lw	a4,-8(a0)
 80e:	9f31                	addw	a4,a4,a2
 810:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 812:	ff053683          	ld	a3,-16(a0)
 816:	bfd1                	j	7ea <free+0x58>

0000000000000818 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 818:	7139                	addi	sp,sp,-64
 81a:	fc06                	sd	ra,56(sp)
 81c:	f822                	sd	s0,48(sp)
 81e:	f04a                	sd	s2,32(sp)
 820:	ec4e                	sd	s3,24(sp)
 822:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 824:	02051993          	slli	s3,a0,0x20
 828:	0209d993          	srli	s3,s3,0x20
 82c:	09bd                	addi	s3,s3,15
 82e:	0049d993          	srli	s3,s3,0x4
 832:	2985                	addiw	s3,s3,1
 834:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 836:	00001517          	auipc	a0,0x1
 83a:	d2a53503          	ld	a0,-726(a0) # 1560 <freep>
 83e:	c905                	beqz	a0,86e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 842:	4798                	lw	a4,8(a5)
 844:	09377a63          	bgeu	a4,s3,8d8 <malloc+0xc0>
 848:	f426                	sd	s1,40(sp)
 84a:	e852                	sd	s4,16(sp)
 84c:	e456                	sd	s5,8(sp)
 84e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 850:	8a4e                	mv	s4,s3
 852:	6705                	lui	a4,0x1
 854:	00e9f363          	bgeu	s3,a4,85a <malloc+0x42>
 858:	6a05                	lui	s4,0x1
 85a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 862:	00001497          	auipc	s1,0x1
 866:	cfe48493          	addi	s1,s1,-770 # 1560 <freep>
  if(p == (char*)-1)
 86a:	5afd                	li	s5,-1
 86c:	a089                	j	8ae <malloc+0x96>
 86e:	f426                	sd	s1,40(sp)
 870:	e852                	sd	s4,16(sp)
 872:	e456                	sd	s5,8(sp)
 874:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 876:	00001797          	auipc	a5,0x1
 87a:	f0a78793          	addi	a5,a5,-246 # 1780 <base>
 87e:	00001717          	auipc	a4,0x1
 882:	cef73123          	sd	a5,-798(a4) # 1560 <freep>
 886:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 888:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88c:	b7d1                	j	850 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 88e:	6398                	ld	a4,0(a5)
 890:	e118                	sd	a4,0(a0)
 892:	a8b9                	j	8f0 <malloc+0xd8>
  hp->s.size = nu;
 894:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 898:	0541                	addi	a0,a0,16
 89a:	00000097          	auipc	ra,0x0
 89e:	ef8080e7          	jalr	-264(ra) # 792 <free>
  return freep;
 8a2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8a4:	c135                	beqz	a0,908 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a8:	4798                	lw	a4,8(a5)
 8aa:	03277363          	bgeu	a4,s2,8d0 <malloc+0xb8>
    if(p == freep)
 8ae:	6098                	ld	a4,0(s1)
 8b0:	853e                	mv	a0,a5
 8b2:	fef71ae3          	bne	a4,a5,8a6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8b6:	8552                	mv	a0,s4
 8b8:	00000097          	auipc	ra,0x0
 8bc:	ba6080e7          	jalr	-1114(ra) # 45e <sbrk>
  if(p == (char*)-1)
 8c0:	fd551ae3          	bne	a0,s5,894 <malloc+0x7c>
        return 0;
 8c4:	4501                	li	a0,0
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	6a42                	ld	s4,16(sp)
 8ca:	6aa2                	ld	s5,8(sp)
 8cc:	6b02                	ld	s6,0(sp)
 8ce:	a03d                	j	8fc <malloc+0xe4>
 8d0:	74a2                	ld	s1,40(sp)
 8d2:	6a42                	ld	s4,16(sp)
 8d4:	6aa2                	ld	s5,8(sp)
 8d6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d8:	fae90be3          	beq	s2,a4,88e <malloc+0x76>
        p->s.size -= nunits;
 8dc:	4137073b          	subw	a4,a4,s3
 8e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e2:	02071693          	slli	a3,a4,0x20
 8e6:	01c6d713          	srli	a4,a3,0x1c
 8ea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f0:	00001717          	auipc	a4,0x1
 8f4:	c6a73823          	sd	a0,-912(a4) # 1560 <freep>
      return (void*)(p + 1);
 8f8:	01078513          	addi	a0,a5,16
  }
}
 8fc:	70e2                	ld	ra,56(sp)
 8fe:	7442                	ld	s0,48(sp)
 900:	7902                	ld	s2,32(sp)
 902:	69e2                	ld	s3,24(sp)
 904:	6121                	addi	sp,sp,64
 906:	8082                	ret
 908:	74a2                	ld	s1,40(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
 910:	b7f5                	j	8fc <malloc+0xe4>

0000000000000912 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 912:	1141                	addi	sp,sp,-16
 914:	e406                	sd	ra,8(sp)
 916:	e022                	sd	s0,0(sp)
 918:	0800                	addi	s0,sp,16
  thread_exit(status);
 91a:	00000097          	auipc	ra,0x0
 91e:	b74080e7          	jalr	-1164(ra) # 48e <thread_exit>
}
 922:	60a2                	ld	ra,8(sp)
 924:	6402                	ld	s0,0(sp)
 926:	0141                	addi	sp,sp,16
 928:	8082                	ret

000000000000092a <free_stacks>:
int free_stacks() {
 92a:	7179                	addi	sp,sp,-48
 92c:	f406                	sd	ra,40(sp)
 92e:	f022                	sd	s0,32(sp)
 930:	ec26                	sd	s1,24(sp)
 932:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 934:	00001797          	auipc	a5,0x1
 938:	c3c7a783          	lw	a5,-964(a5) # 1570 <num_threads>
 93c:	04f05063          	blez	a5,97c <free_stacks+0x52>
 940:	e84a                	sd	s2,16(sp)
 942:	e44e                	sd	s3,8(sp)
 944:	4481                	li	s1,0
    free(stacks[i]);
 946:	00001997          	auipc	s3,0x1
 94a:	c2298993          	addi	s3,s3,-990 # 1568 <stacks>
  for (int i = 0; i < num_threads; i++) {
 94e:	00001917          	auipc	s2,0x1
 952:	c2290913          	addi	s2,s2,-990 # 1570 <num_threads>
    free(stacks[i]);
 956:	0009b783          	ld	a5,0(s3)
 95a:	00349713          	slli	a4,s1,0x3
 95e:	97ba                	add	a5,a5,a4
 960:	6388                	ld	a0,0(a5)
 962:	00000097          	auipc	ra,0x0
 966:	e30080e7          	jalr	-464(ra) # 792 <free>
  for (int i = 0; i < num_threads; i++) {
 96a:	0485                	addi	s1,s1,1
 96c:	00092703          	lw	a4,0(s2)
 970:	0004879b          	sext.w	a5,s1
 974:	fee7c1e3          	blt	a5,a4,956 <free_stacks+0x2c>
 978:	6942                	ld	s2,16(sp)
 97a:	69a2                	ld	s3,8(sp)
  free(stacks);
 97c:	00001497          	auipc	s1,0x1
 980:	bec48493          	addi	s1,s1,-1044 # 1568 <stacks>
 984:	6088                	ld	a0,0(s1)
 986:	00000097          	auipc	ra,0x0
 98a:	e0c080e7          	jalr	-500(ra) # 792 <free>
  stacks = 0;
 98e:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 992:	00001797          	auipc	a5,0x1
 996:	bc07af23          	sw	zero,-1058(a5) # 1570 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 99a:	47a1                	li	a5,8
 99c:	00001717          	auipc	a4,0x1
 9a0:	baf72a23          	sw	a5,-1100(a4) # 1550 <max_stacks>
  threads_done = 0;
 9a4:	00001797          	auipc	a5,0x1
 9a8:	bc07a823          	sw	zero,-1072(a5) # 1574 <threads_done>
}
 9ac:	4501                	li	a0,0
 9ae:	70a2                	ld	ra,40(sp)
 9b0:	7402                	ld	s0,32(sp)
 9b2:	64e2                	ld	s1,24(sp)
 9b4:	6145                	addi	sp,sp,48
 9b6:	8082                	ret

00000000000009b8 <expand_num_threads>:
int expand_num_threads() {
 9b8:	1101                	addi	sp,sp,-32
 9ba:	ec06                	sd	ra,24(sp)
 9bc:	e822                	sd	s0,16(sp)
 9be:	e426                	sd	s1,8(sp)
 9c0:	e04a                	sd	s2,0(sp)
 9c2:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9c4:	00001797          	auipc	a5,0x1
 9c8:	b8c78793          	addi	a5,a5,-1140 # 1550 <max_stacks>
 9cc:	4388                	lw	a0,0(a5)
 9ce:	0015151b          	slliw	a0,a0,0x1
 9d2:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9d4:	0035151b          	slliw	a0,a0,0x3
 9d8:	00000097          	auipc	ra,0x0
 9dc:	e40080e7          	jalr	-448(ra) # 818 <malloc>
 9e0:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 9e2:	00001617          	auipc	a2,0x1
 9e6:	b8e62603          	lw	a2,-1138(a2) # 1570 <num_threads>
 9ea:	00001497          	auipc	s1,0x1
 9ee:	b7e48493          	addi	s1,s1,-1154 # 1568 <stacks>
 9f2:	0036161b          	slliw	a2,a2,0x3
 9f6:	608c                	ld	a1,0(s1)
 9f8:	00000097          	auipc	ra,0x0
 9fc:	928080e7          	jalr	-1752(ra) # 320 <memmove>
  free(stacks);
 a00:	6088                	ld	a0,0(s1)
 a02:	00000097          	auipc	ra,0x0
 a06:	d90080e7          	jalr	-624(ra) # 792 <free>
  stacks = new_stacks;
 a0a:	0124b023          	sd	s2,0(s1)
}
 a0e:	4501                	li	a0,0
 a10:	60e2                	ld	ra,24(sp)
 a12:	6442                	ld	s0,16(sp)
 a14:	64a2                	ld	s1,8(sp)
 a16:	6902                	ld	s2,0(sp)
 a18:	6105                	addi	sp,sp,32
 a1a:	8082                	ret

0000000000000a1c <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a1c:	7179                	addi	sp,sp,-48
 a1e:	f406                	sd	ra,40(sp)
 a20:	f022                	sd	s0,32(sp)
 a22:	e84a                	sd	s2,16(sp)
 a24:	e44e                	sd	s3,8(sp)
 a26:	1800                	addi	s0,sp,48
 a28:	892a                	mv	s2,a0
 a2a:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a2c:	00001797          	auipc	a5,0x1
 a30:	b3c7b783          	ld	a5,-1220(a5) # 1568 <stacks>
 a34:	c3d9                	beqz	a5,aba <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a36:	00001797          	auipc	a5,0x1
 a3a:	b1a7a783          	lw	a5,-1254(a5) # 1550 <max_stacks>
 a3e:	00001717          	auipc	a4,0x1
 a42:	b3272703          	lw	a4,-1230(a4) # 1570 <num_threads>
 a46:	0af71463          	bne	a4,a5,aee <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 a4a:	04000713          	li	a4,64
 a4e:	08e78563          	beq	a5,a4,ad8 <ithread_create+0xbc>
 a52:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a54:	00000097          	auipc	ra,0x0
 a58:	f64080e7          	jalr	-156(ra) # 9b8 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a5c:	6505                	lui	a0,0x1
 a5e:	00000097          	auipc	ra,0x0
 a62:	dba080e7          	jalr	-582(ra) # 818 <malloc>
 a66:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a68:	00001717          	auipc	a4,0x1
 a6c:	b0872703          	lw	a4,-1272(a4) # 1570 <num_threads>
 a70:	070e                	slli	a4,a4,0x3
 a72:	00001797          	auipc	a5,0x1
 a76:	af67b783          	ld	a5,-1290(a5) # 1568 <stacks>
 a7a:	97ba                	add	a5,a5,a4
 a7c:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a7e:	00000697          	auipc	a3,0x0
 a82:	e9468693          	addi	a3,a3,-364 # 912 <ithread_exit>
 a86:	862a                	mv	a2,a0
 a88:	85ce                	mv	a1,s3
 a8a:	854a                	mv	a0,s2
 a8c:	00000097          	auipc	ra,0x0
 a90:	9f2080e7          	jalr	-1550(ra) # 47e <create_thread>
 a94:	892a                	mv	s2,a0
  if (res != -1) {
 a96:	57fd                	li	a5,-1
 a98:	04f50d63          	beq	a0,a5,af2 <ithread_create+0xd6>
    num_threads++;
 a9c:	00001717          	auipc	a4,0x1
 aa0:	ad470713          	addi	a4,a4,-1324 # 1570 <num_threads>
 aa4:	431c                	lw	a5,0(a4)
 aa6:	2785                	addiw	a5,a5,1
 aa8:	c31c                	sw	a5,0(a4)
 aaa:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 aac:	854a                	mv	a0,s2
 aae:	70a2                	ld	ra,40(sp)
 ab0:	7402                	ld	s0,32(sp)
 ab2:	6942                	ld	s2,16(sp)
 ab4:	69a2                	ld	s3,8(sp)
 ab6:	6145                	addi	sp,sp,48
 ab8:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 aba:	00001517          	auipc	a0,0x1
 abe:	a9652503          	lw	a0,-1386(a0) # 1550 <max_stacks>
 ac2:	0035151b          	slliw	a0,a0,0x3
 ac6:	00000097          	auipc	ra,0x0
 aca:	d52080e7          	jalr	-686(ra) # 818 <malloc>
 ace:	00001797          	auipc	a5,0x1
 ad2:	a8a7bd23          	sd	a0,-1382(a5) # 1568 <stacks>
 ad6:	b785                	j	a36 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 ad8:	00000517          	auipc	a0,0x0
 adc:	0d850513          	addi	a0,a0,216 # bb0 <ithread_join+0x98>
 ae0:	00000097          	auipc	ra,0x0
 ae4:	c7c080e7          	jalr	-900(ra) # 75c <printf>
      return -1;
 ae8:	57fd                	li	a5,-1
 aea:	893e                	mv	s2,a5
 aec:	b7c1                	j	aac <ithread_create+0x90>
 aee:	ec26                	sd	s1,24(sp)
 af0:	b7b5                	j	a5c <ithread_create+0x40>
    free(stack_ptr);
 af2:	8526                	mv	a0,s1
 af4:	00000097          	auipc	ra,0x0
 af8:	c9e080e7          	jalr	-866(ra) # 792 <free>
    stacks[num_threads] = 0;
 afc:	00001717          	auipc	a4,0x1
 b00:	a7472703          	lw	a4,-1420(a4) # 1570 <num_threads>
 b04:	070e                	slli	a4,a4,0x3
 b06:	00001797          	auipc	a5,0x1
 b0a:	a627b783          	ld	a5,-1438(a5) # 1568 <stacks>
 b0e:	97ba                	add	a5,a5,a4
 b10:	0007b023          	sd	zero,0(a5)
 b14:	64e2                	ld	s1,24(sp)
 b16:	bf59                	j	aac <ithread_create+0x90>

0000000000000b18 <ithread_join>:

int ithread_join(int thread_id) {
 b18:	1101                	addi	sp,sp,-32
 b1a:	ec06                	sd	ra,24(sp)
 b1c:	e822                	sd	s0,16(sp)
 b1e:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b20:	fec40593          	addi	a1,s0,-20
 b24:	00000097          	auipc	ra,0x0
 b28:	962080e7          	jalr	-1694(ra) # 486 <join_thread>
  threads_done++;
 b2c:	00001717          	auipc	a4,0x1
 b30:	a4870713          	addi	a4,a4,-1464 # 1574 <threads_done>
 b34:	431c                	lw	a5,0(a4)
 b36:	2785                	addiw	a5,a5,1
 b38:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b3a:	00001717          	auipc	a4,0x1
 b3e:	a3672703          	lw	a4,-1482(a4) # 1570 <num_threads>
 b42:	00f70863          	beq	a4,a5,b52 <ithread_join+0x3a>
    free_stacks();
  }
  return status;
}
 b46:	fec42503          	lw	a0,-20(s0)
 b4a:	60e2                	ld	ra,24(sp)
 b4c:	6442                	ld	s0,16(sp)
 b4e:	6105                	addi	sp,sp,32
 b50:	8082                	ret
    free_stacks();
 b52:	00000097          	auipc	ra,0x0
 b56:	dd8080e7          	jalr	-552(ra) # 92a <free_stacks>
 b5a:	b7f5                	j	b46 <ithread_join+0x2e>
