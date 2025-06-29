
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	562d8d93          	addi	s11,s11,1378 # 1590 <buf>
  36:	20000d13          	li	s10,512
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	bb4a0a13          	addi	s4,s4,-1100 # bf0 <ithread_join+0x4c>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  44:	a805                	j	74 <wc+0x74>
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	00000097          	auipc	ra,0x0
  4c:	206080e7          	jalr	518(ra) # 24e <strchr>
  50:	c919                	beqz	a0,66 <wc+0x66>
        inword = 0;
  52:	4901                	li	s2,0
    for(i=0; i<n; i++){
  54:	0485                	addi	s1,s1,1
  56:	01348d63          	beq	s1,s3,70 <wc+0x70>
      if(buf[i] == '\n')
  5a:	0004c583          	lbu	a1,0(s1)
  5e:	ff5594e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  62:	2b85                	addiw	s7,s7,1
  64:	b7cd                	j	46 <wc+0x46>
      else if(!inword){
  66:	fe0917e3          	bnez	s2,54 <wc+0x54>
        w++;
  6a:	2c05                	addiw	s8,s8,1
        inword = 1;
  6c:	4905                	li	s2,1
  6e:	b7dd                	j	54 <wc+0x54>
  70:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  74:	866a                	mv	a2,s10
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3e6080e7          	jalr	998(ra) # 462 <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
  8a:	00001497          	auipc	s1,0x1
  8e:	50648493          	addi	s1,s1,1286 # 1590 <buf>
  92:	009b09b3          	add	s3,s6,s1
  96:	b7d1                	j	5a <wc+0x5a>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86e6                	mv	a3,s9
  a2:	8662                	mv	a2,s8
  a4:	85de                	mv	a1,s7
  a6:	00001517          	auipc	a0,0x1
  aa:	b6250513          	addi	a0,a0,-1182 # c08 <ithread_join+0x64>
  ae:	00000097          	auipc	ra,0x0
  b2:	73a080e7          	jalr	1850(ra) # 7e8 <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	b2450513          	addi	a0,a0,-1244 # bf8 <ithread_join+0x54>
  dc:	00000097          	auipc	ra,0x0
  e0:	70c080e7          	jalr	1804(ra) # 7e8 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	364080e7          	jalr	868(ra) # 44a <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  f6:	4785                	li	a5,1
  f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	36e080e7          	jalr	878(ra) # 48a <open>
 124:	84aa                	mv	s1,a0
 126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	33a080e7          	jalr	826(ra) # 472 <close>
  for(i = 1; i < argc; i++){
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	302080e7          	jalr	770(ra) # 44a <exit>
 150:	ec26                	sd	s1,24(sp)
 152:	e84a                	sd	s2,16(sp)
 154:	e44e                	sd	s3,8(sp)
    wc(0, "");
 156:	00001597          	auipc	a1,0x1
 15a:	b0a58593          	addi	a1,a1,-1270 # c60 <ithread_join+0xbc>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	2e0080e7          	jalr	736(ra) # 44a <exit>
      printf("wc: cannot open %s\n", argv[i]);
 172:	00093583          	ld	a1,0(s2)
 176:	00001517          	auipc	a0,0x1
 17a:	aa250513          	addi	a0,a0,-1374 # c18 <ithread_join+0x74>
 17e:	00000097          	auipc	ra,0x0
 182:	66a080e7          	jalr	1642(ra) # 7e8 <printf>
      exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	2c2080e7          	jalr	706(ra) # 44a <exit>

0000000000000190 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  extern int main();
  main();
 198:	00000097          	auipc	ra,0x0
 19c:	f56080e7          	jalr	-170(ra) # ee <main>
  exit(0);
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	2a8080e7          	jalr	680(ra) # 44a <exit>

00000000000001aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b2:	87aa                	mv	a5,a0
 1b4:	0585                	addi	a1,a1,1
 1b6:	0785                	addi	a5,a5,1
 1b8:	fff5c703          	lbu	a4,-1(a1)
 1bc:	fee78fa3          	sb	a4,-1(a5)
 1c0:	fb75                	bnez	a4,1b4 <strcpy+0xa>
    ;
  return os;
}
 1c2:	60a2                	ld	ra,8(sp)
 1c4:	6402                	ld	s0,0(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret

00000000000001ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e406                	sd	ra,8(sp)
 1ce:	e022                	sd	s0,0(sp)
 1d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cb91                	beqz	a5,1ea <strcmp+0x20>
 1d8:	0005c703          	lbu	a4,0(a1)
 1dc:	00f71763          	bne	a4,a5,1ea <strcmp+0x20>
    p++, q++;
 1e0:	0505                	addi	a0,a0,1
 1e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	fbe5                	bnez	a5,1d8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ea:	0005c503          	lbu	a0,0(a1)
}
 1ee:	40a7853b          	subw	a0,a5,a0
 1f2:	60a2                	ld	ra,8(sp)
 1f4:	6402                	ld	s0,0(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret

00000000000001fa <strlen>:

uint
strlen(const char *s)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e406                	sd	ra,8(sp)
 1fe:	e022                	sd	s0,0(sp)
 200:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 202:	00054783          	lbu	a5,0(a0)
 206:	cf99                	beqz	a5,224 <strlen+0x2a>
 208:	0505                	addi	a0,a0,1
 20a:	87aa                	mv	a5,a0
 20c:	86be                	mv	a3,a5
 20e:	0785                	addi	a5,a5,1
 210:	fff7c703          	lbu	a4,-1(a5)
 214:	ff65                	bnez	a4,20c <strlen+0x12>
 216:	40a6853b          	subw	a0,a3,a0
 21a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 21c:	60a2                	ld	ra,8(sp)
 21e:	6402                	ld	s0,0(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
  for(n = 0; s[n]; n++)
 224:	4501                	li	a0,0
 226:	bfdd                	j	21c <strlen+0x22>

0000000000000228 <memset>:

void*
memset(void *dst, int c, uint n)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e406                	sd	ra,8(sp)
 22c:	e022                	sd	s0,0(sp)
 22e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 230:	ca19                	beqz	a2,246 <memset+0x1e>
 232:	87aa                	mv	a5,a0
 234:	1602                	slli	a2,a2,0x20
 236:	9201                	srli	a2,a2,0x20
 238:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 23c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 240:	0785                	addi	a5,a5,1
 242:	fee79de3          	bne	a5,a4,23c <memset+0x14>
  }
  return dst;
}
 246:	60a2                	ld	ra,8(sp)
 248:	6402                	ld	s0,0(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret

000000000000024e <strchr>:

char*
strchr(const char *s, char c)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  for(; *s; s++)
 256:	00054783          	lbu	a5,0(a0)
 25a:	cf81                	beqz	a5,272 <strchr+0x24>
    if(*s == c)
 25c:	00f58763          	beq	a1,a5,26a <strchr+0x1c>
  for(; *s; s++)
 260:	0505                	addi	a0,a0,1
 262:	00054783          	lbu	a5,0(a0)
 266:	fbfd                	bnez	a5,25c <strchr+0xe>
      return (char*)s;
  return 0;
 268:	4501                	li	a0,0
}
 26a:	60a2                	ld	ra,8(sp)
 26c:	6402                	ld	s0,0(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfdd                	j	26a <strchr+0x1c>

0000000000000276 <gets>:

char*
gets(char *buf, int max)
{
 276:	7159                	addi	sp,sp,-112
 278:	f486                	sd	ra,104(sp)
 27a:	f0a2                	sd	s0,96(sp)
 27c:	eca6                	sd	s1,88(sp)
 27e:	e8ca                	sd	s2,80(sp)
 280:	e4ce                	sd	s3,72(sp)
 282:	e0d2                	sd	s4,64(sp)
 284:	fc56                	sd	s5,56(sp)
 286:	f85a                	sd	s6,48(sp)
 288:	f45e                	sd	s7,40(sp)
 28a:	f062                	sd	s8,32(sp)
 28c:	ec66                	sd	s9,24(sp)
 28e:	e86a                	sd	s10,16(sp)
 290:	1880                	addi	s0,sp,112
 292:	8caa                	mv	s9,a0
 294:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 296:	892a                	mv	s2,a0
 298:	4481                	li	s1,0
    cc = read(0, &c, 1);
 29a:	f9f40b13          	addi	s6,s0,-97
 29e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2a0:	4ba9                	li	s7,10
 2a2:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 2a4:	8d26                	mv	s10,s1
 2a6:	0014899b          	addiw	s3,s1,1
 2aa:	84ce                	mv	s1,s3
 2ac:	0349d763          	bge	s3,s4,2da <gets+0x64>
    cc = read(0, &c, 1);
 2b0:	8656                	mv	a2,s5
 2b2:	85da                	mv	a1,s6
 2b4:	4501                	li	a0,0
 2b6:	00000097          	auipc	ra,0x0
 2ba:	1ac080e7          	jalr	428(ra) # 462 <read>
    if(cc < 1)
 2be:	00a05e63          	blez	a0,2da <gets+0x64>
    buf[i++] = c;
 2c2:	f9f44783          	lbu	a5,-97(s0)
 2c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ca:	01778763          	beq	a5,s7,2d8 <gets+0x62>
 2ce:	0905                	addi	s2,s2,1
 2d0:	fd879ae3          	bne	a5,s8,2a4 <gets+0x2e>
    buf[i++] = c;
 2d4:	8d4e                	mv	s10,s3
 2d6:	a011                	j	2da <gets+0x64>
 2d8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 2da:	9d66                	add	s10,s10,s9
 2dc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 2e0:	8566                	mv	a0,s9
 2e2:	70a6                	ld	ra,104(sp)
 2e4:	7406                	ld	s0,96(sp)
 2e6:	64e6                	ld	s1,88(sp)
 2e8:	6946                	ld	s2,80(sp)
 2ea:	69a6                	ld	s3,72(sp)
 2ec:	6a06                	ld	s4,64(sp)
 2ee:	7ae2                	ld	s5,56(sp)
 2f0:	7b42                	ld	s6,48(sp)
 2f2:	7ba2                	ld	s7,40(sp)
 2f4:	7c02                	ld	s8,32(sp)
 2f6:	6ce2                	ld	s9,24(sp)
 2f8:	6d42                	ld	s10,16(sp)
 2fa:	6165                	addi	sp,sp,112
 2fc:	8082                	ret

00000000000002fe <stat>:

int
stat(const char *n, struct stat *st)
{
 2fe:	1101                	addi	sp,sp,-32
 300:	ec06                	sd	ra,24(sp)
 302:	e822                	sd	s0,16(sp)
 304:	e04a                	sd	s2,0(sp)
 306:	1000                	addi	s0,sp,32
 308:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 30a:	4581                	li	a1,0
 30c:	00000097          	auipc	ra,0x0
 310:	17e080e7          	jalr	382(ra) # 48a <open>
  if(fd < 0)
 314:	02054663          	bltz	a0,340 <stat+0x42>
 318:	e426                	sd	s1,8(sp)
 31a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 31c:	85ca                	mv	a1,s2
 31e:	00000097          	auipc	ra,0x0
 322:	184080e7          	jalr	388(ra) # 4a2 <fstat>
 326:	892a                	mv	s2,a0
  close(fd);
 328:	8526                	mv	a0,s1
 32a:	00000097          	auipc	ra,0x0
 32e:	148080e7          	jalr	328(ra) # 472 <close>
  return r;
 332:	64a2                	ld	s1,8(sp)
}
 334:	854a                	mv	a0,s2
 336:	60e2                	ld	ra,24(sp)
 338:	6442                	ld	s0,16(sp)
 33a:	6902                	ld	s2,0(sp)
 33c:	6105                	addi	sp,sp,32
 33e:	8082                	ret
    return -1;
 340:	597d                	li	s2,-1
 342:	bfcd                	j	334 <stat+0x36>

0000000000000344 <atoi>:

int
atoi(const char *s)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 34c:	00054683          	lbu	a3,0(a0)
 350:	fd06879b          	addiw	a5,a3,-48
 354:	0ff7f793          	zext.b	a5,a5
 358:	4625                	li	a2,9
 35a:	02f66963          	bltu	a2,a5,38c <atoi+0x48>
 35e:	872a                	mv	a4,a0
  n = 0;
 360:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 362:	0705                	addi	a4,a4,1
 364:	0025179b          	slliw	a5,a0,0x2
 368:	9fa9                	addw	a5,a5,a0
 36a:	0017979b          	slliw	a5,a5,0x1
 36e:	9fb5                	addw	a5,a5,a3
 370:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 374:	00074683          	lbu	a3,0(a4)
 378:	fd06879b          	addiw	a5,a3,-48
 37c:	0ff7f793          	zext.b	a5,a5
 380:	fef671e3          	bgeu	a2,a5,362 <atoi+0x1e>
  return n;
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
  n = 0;
 38c:	4501                	li	a0,0
 38e:	bfdd                	j	384 <atoi+0x40>

0000000000000390 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 390:	1141                	addi	sp,sp,-16
 392:	e406                	sd	ra,8(sp)
 394:	e022                	sd	s0,0(sp)
 396:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 398:	02b57563          	bgeu	a0,a1,3c2 <memmove+0x32>
    while(n-- > 0)
 39c:	00c05f63          	blez	a2,3ba <memmove+0x2a>
 3a0:	1602                	slli	a2,a2,0x20
 3a2:	9201                	srli	a2,a2,0x20
 3a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 3aa:	0585                	addi	a1,a1,1
 3ac:	0705                	addi	a4,a4,1
 3ae:	fff5c683          	lbu	a3,-1(a1)
 3b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3b6:	fee79ae3          	bne	a5,a4,3aa <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ba:	60a2                	ld	ra,8(sp)
 3bc:	6402                	ld	s0,0(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret
    dst += n;
 3c2:	00c50733          	add	a4,a0,a2
    src += n;
 3c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3c8:	fec059e3          	blez	a2,3ba <memmove+0x2a>
 3cc:	fff6079b          	addiw	a5,a2,-1
 3d0:	1782                	slli	a5,a5,0x20
 3d2:	9381                	srli	a5,a5,0x20
 3d4:	fff7c793          	not	a5,a5
 3d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3da:	15fd                	addi	a1,a1,-1
 3dc:	177d                	addi	a4,a4,-1
 3de:	0005c683          	lbu	a3,0(a1)
 3e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e6:	fef71ae3          	bne	a4,a5,3da <memmove+0x4a>
 3ea:	bfc1                	j	3ba <memmove+0x2a>

00000000000003ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e406                	sd	ra,8(sp)
 3f0:	e022                	sd	s0,0(sp)
 3f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f4:	ca0d                	beqz	a2,426 <memcmp+0x3a>
 3f6:	fff6069b          	addiw	a3,a2,-1
 3fa:	1682                	slli	a3,a3,0x20
 3fc:	9281                	srli	a3,a3,0x20
 3fe:	0685                	addi	a3,a3,1
 400:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 402:	00054783          	lbu	a5,0(a0)
 406:	0005c703          	lbu	a4,0(a1)
 40a:	00e79863          	bne	a5,a4,41a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 40e:	0505                	addi	a0,a0,1
    p2++;
 410:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 412:	fed518e3          	bne	a0,a3,402 <memcmp+0x16>
  }
  return 0;
 416:	4501                	li	a0,0
 418:	a019                	j	41e <memcmp+0x32>
      return *p1 - *p2;
 41a:	40e7853b          	subw	a0,a5,a4
}
 41e:	60a2                	ld	ra,8(sp)
 420:	6402                	ld	s0,0(sp)
 422:	0141                	addi	sp,sp,16
 424:	8082                	ret
  return 0;
 426:	4501                	li	a0,0
 428:	bfdd                	j	41e <memcmp+0x32>

000000000000042a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e406                	sd	ra,8(sp)
 42e:	e022                	sd	s0,0(sp)
 430:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 432:	00000097          	auipc	ra,0x0
 436:	f5e080e7          	jalr	-162(ra) # 390 <memmove>
}
 43a:	60a2                	ld	ra,8(sp)
 43c:	6402                	ld	s0,0(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret

0000000000000442 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 442:	4885                	li	a7,1
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <exit>:
.global exit
exit:
 li a7, SYS_exit
 44a:	4889                	li	a7,2
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <wait>:
.global wait
wait:
 li a7, SYS_wait
 452:	488d                	li	a7,3
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45a:	4891                	li	a7,4
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <read>:
.global read
read:
 li a7, SYS_read
 462:	4895                	li	a7,5
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <write>:
.global write
write:
 li a7, SYS_write
 46a:	48c1                	li	a7,16
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <close>:
.global close
close:
 li a7, SYS_close
 472:	48d5                	li	a7,21
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <kill>:
.global kill
kill:
 li a7, SYS_kill
 47a:	4899                	li	a7,6
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <exec>:
.global exec
exec:
 li a7, SYS_exec
 482:	489d                	li	a7,7
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <open>:
.global open
open:
 li a7, SYS_open
 48a:	48bd                	li	a7,15
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 492:	48c5                	li	a7,17
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49a:	48c9                	li	a7,18
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a2:	48a1                	li	a7,8
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <link>:
.global link
link:
 li a7, SYS_link
 4aa:	48cd                	li	a7,19
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b2:	48d1                	li	a7,20
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ba:	48a5                	li	a7,9
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c2:	48a9                	li	a7,10
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ca:	48ad                	li	a7,11
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d2:	48b1                	li	a7,12
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4da:	48b5                	li	a7,13
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e2:	48b9                	li	a7,14
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 4ea:	48d9                	li	a7,22
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 4f2:	48dd                	li	a7,23
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 4fa:	48e1                	li	a7,24
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 502:	48e5                	li	a7,25
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <socket>:
.global socket
socket:
 li a7, SYS_socket
 50a:	48e9                	li	a7,26
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <bind>:
.global bind
bind:
 li a7, SYS_bind
 512:	48ed                	li	a7,27
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <accept>:
.global accept
accept:
 li a7, SYS_accept
 51a:	48f5                	li	a7,29
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <listen>:
.global listen
listen:
 li a7, SYS_listen
 522:	48f1                	li	a7,28
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <connect>:
.global connect
connect:
 li a7, SYS_connect
 52a:	48f9                	li	a7,30
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 532:	1101                	addi	sp,sp,-32
 534:	ec06                	sd	ra,24(sp)
 536:	e822                	sd	s0,16(sp)
 538:	1000                	addi	s0,sp,32
 53a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 53e:	4605                	li	a2,1
 540:	fef40593          	addi	a1,s0,-17
 544:	00000097          	auipc	ra,0x0
 548:	f26080e7          	jalr	-218(ra) # 46a <write>
}
 54c:	60e2                	ld	ra,24(sp)
 54e:	6442                	ld	s0,16(sp)
 550:	6105                	addi	sp,sp,32
 552:	8082                	ret

0000000000000554 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 554:	7139                	addi	sp,sp,-64
 556:	fc06                	sd	ra,56(sp)
 558:	f822                	sd	s0,48(sp)
 55a:	f426                	sd	s1,40(sp)
 55c:	f04a                	sd	s2,32(sp)
 55e:	ec4e                	sd	s3,24(sp)
 560:	0080                	addi	s0,sp,64
 562:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 564:	c299                	beqz	a3,56a <printint+0x16>
 566:	0805c063          	bltz	a1,5e6 <printint+0x92>
  neg = 0;
 56a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 56c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 570:	869a                	mv	a3,t1
  i = 0;
 572:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 574:	00000817          	auipc	a6,0x0
 578:	74c80813          	addi	a6,a6,1868 # cc0 <digits>
 57c:	88be                	mv	a7,a5
 57e:	0017851b          	addiw	a0,a5,1
 582:	87aa                	mv	a5,a0
 584:	02c5f73b          	remuw	a4,a1,a2
 588:	1702                	slli	a4,a4,0x20
 58a:	9301                	srli	a4,a4,0x20
 58c:	9742                	add	a4,a4,a6
 58e:	00074703          	lbu	a4,0(a4)
 592:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 596:	872e                	mv	a4,a1
 598:	02c5d5bb          	divuw	a1,a1,a2
 59c:	0685                	addi	a3,a3,1
 59e:	fcc77fe3          	bgeu	a4,a2,57c <printint+0x28>
  if(neg)
 5a2:	000e0c63          	beqz	t3,5ba <printint+0x66>
    buf[i++] = '-';
 5a6:	fd050793          	addi	a5,a0,-48
 5aa:	00878533          	add	a0,a5,s0
 5ae:	02d00793          	li	a5,45
 5b2:	fef50823          	sb	a5,-16(a0)
 5b6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 5ba:	fff7899b          	addiw	s3,a5,-1
 5be:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5c2:	fff4c583          	lbu	a1,-1(s1)
 5c6:	854a                	mv	a0,s2
 5c8:	00000097          	auipc	ra,0x0
 5cc:	f6a080e7          	jalr	-150(ra) # 532 <putc>
  while(--i >= 0)
 5d0:	39fd                	addiw	s3,s3,-1
 5d2:	14fd                	addi	s1,s1,-1
 5d4:	fe09d7e3          	bgez	s3,5c2 <printint+0x6e>
}
 5d8:	70e2                	ld	ra,56(sp)
 5da:	7442                	ld	s0,48(sp)
 5dc:	74a2                	ld	s1,40(sp)
 5de:	7902                	ld	s2,32(sp)
 5e0:	69e2                	ld	s3,24(sp)
 5e2:	6121                	addi	sp,sp,64
 5e4:	8082                	ret
    x = -xx;
 5e6:	40b005bb          	negw	a1,a1
    neg = 1;
 5ea:	4e05                	li	t3,1
    x = -xx;
 5ec:	b741                	j	56c <printint+0x18>

00000000000005ee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ee:	715d                	addi	sp,sp,-80
 5f0:	e486                	sd	ra,72(sp)
 5f2:	e0a2                	sd	s0,64(sp)
 5f4:	f84a                	sd	s2,48(sp)
 5f6:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f8:	0005c903          	lbu	s2,0(a1)
 5fc:	1a090a63          	beqz	s2,7b0 <vprintf+0x1c2>
 600:	fc26                	sd	s1,56(sp)
 602:	f44e                	sd	s3,40(sp)
 604:	f052                	sd	s4,32(sp)
 606:	ec56                	sd	s5,24(sp)
 608:	e85a                	sd	s6,16(sp)
 60a:	e45e                	sd	s7,8(sp)
 60c:	8aaa                	mv	s5,a0
 60e:	8bb2                	mv	s7,a2
 610:	00158493          	addi	s1,a1,1
  state = 0;
 614:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 616:	02500a13          	li	s4,37
 61a:	4b55                	li	s6,21
 61c:	a839                	j	63a <vprintf+0x4c>
        putc(fd, c);
 61e:	85ca                	mv	a1,s2
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	f10080e7          	jalr	-240(ra) # 532 <putc>
 62a:	a019                	j	630 <vprintf+0x42>
    } else if(state == '%'){
 62c:	01498d63          	beq	s3,s4,646 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 630:	0485                	addi	s1,s1,1
 632:	fff4c903          	lbu	s2,-1(s1)
 636:	16090763          	beqz	s2,7a4 <vprintf+0x1b6>
    if(state == 0){
 63a:	fe0999e3          	bnez	s3,62c <vprintf+0x3e>
      if(c == '%'){
 63e:	ff4910e3          	bne	s2,s4,61e <vprintf+0x30>
        state = '%';
 642:	89d2                	mv	s3,s4
 644:	b7f5                	j	630 <vprintf+0x42>
      if(c == 'd'){
 646:	13490463          	beq	s2,s4,76e <vprintf+0x180>
 64a:	f9d9079b          	addiw	a5,s2,-99
 64e:	0ff7f793          	zext.b	a5,a5
 652:	12fb6763          	bltu	s6,a5,780 <vprintf+0x192>
 656:	f9d9079b          	addiw	a5,s2,-99
 65a:	0ff7f713          	zext.b	a4,a5
 65e:	12eb6163          	bltu	s6,a4,780 <vprintf+0x192>
 662:	00271793          	slli	a5,a4,0x2
 666:	00000717          	auipc	a4,0x0
 66a:	60270713          	addi	a4,a4,1538 # c68 <ithread_join+0xc4>
 66e:	97ba                	add	a5,a5,a4
 670:	439c                	lw	a5,0(a5)
 672:	97ba                	add	a5,a5,a4
 674:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 676:	008b8913          	addi	s2,s7,8
 67a:	4685                	li	a3,1
 67c:	4629                	li	a2,10
 67e:	000ba583          	lw	a1,0(s7)
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	ed0080e7          	jalr	-304(ra) # 554 <printint>
 68c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 68e:	4981                	li	s3,0
 690:	b745                	j	630 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 692:	008b8913          	addi	s2,s7,8
 696:	4681                	li	a3,0
 698:	4629                	li	a2,10
 69a:	000ba583          	lw	a1,0(s7)
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	eb4080e7          	jalr	-332(ra) # 554 <printint>
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b751                	j	630 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4641                	li	a2,16
 6b6:	000ba583          	lw	a1,0(s7)
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	e98080e7          	jalr	-360(ra) # 554 <printint>
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b7a5                	j	630 <vprintf+0x42>
 6ca:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6cc:	008b8c13          	addi	s8,s7,8
 6d0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6d4:	03000593          	li	a1,48
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	e58080e7          	jalr	-424(ra) # 532 <putc>
  putc(fd, 'x');
 6e2:	07800593          	li	a1,120
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e4a080e7          	jalr	-438(ra) # 532 <putc>
 6f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f2:	00000b97          	auipc	s7,0x0
 6f6:	5ceb8b93          	addi	s7,s7,1486 # cc0 <digits>
 6fa:	03c9d793          	srli	a5,s3,0x3c
 6fe:	97de                	add	a5,a5,s7
 700:	0007c583          	lbu	a1,0(a5)
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	e2c080e7          	jalr	-468(ra) # 532 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70e:	0992                	slli	s3,s3,0x4
 710:	397d                	addiw	s2,s2,-1
 712:	fe0914e3          	bnez	s2,6fa <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 716:	8be2                	mv	s7,s8
      state = 0;
 718:	4981                	li	s3,0
 71a:	6c02                	ld	s8,0(sp)
 71c:	bf11                	j	630 <vprintf+0x42>
        s = va_arg(ap, char*);
 71e:	008b8993          	addi	s3,s7,8
 722:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 726:	02090163          	beqz	s2,748 <vprintf+0x15a>
        while(*s != 0){
 72a:	00094583          	lbu	a1,0(s2)
 72e:	c9a5                	beqz	a1,79e <vprintf+0x1b0>
          putc(fd, *s);
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	e00080e7          	jalr	-512(ra) # 532 <putc>
          s++;
 73a:	0905                	addi	s2,s2,1
        while(*s != 0){
 73c:	00094583          	lbu	a1,0(s2)
 740:	f9e5                	bnez	a1,730 <vprintf+0x142>
        s = va_arg(ap, char*);
 742:	8bce                	mv	s7,s3
      state = 0;
 744:	4981                	li	s3,0
 746:	b5ed                	j	630 <vprintf+0x42>
          s = "(null)";
 748:	00000917          	auipc	s2,0x0
 74c:	4e890913          	addi	s2,s2,1256 # c30 <ithread_join+0x8c>
        while(*s != 0){
 750:	02800593          	li	a1,40
 754:	bff1                	j	730 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 756:	008b8913          	addi	s2,s7,8
 75a:	000bc583          	lbu	a1,0(s7)
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	dd2080e7          	jalr	-558(ra) # 532 <putc>
 768:	8bca                	mv	s7,s2
      state = 0;
 76a:	4981                	li	s3,0
 76c:	b5d1                	j	630 <vprintf+0x42>
        putc(fd, c);
 76e:	02500593          	li	a1,37
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	dbe080e7          	jalr	-578(ra) # 532 <putc>
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bd4d                	j	630 <vprintf+0x42>
        putc(fd, '%');
 780:	02500593          	li	a1,37
 784:	8556                	mv	a0,s5
 786:	00000097          	auipc	ra,0x0
 78a:	dac080e7          	jalr	-596(ra) # 532 <putc>
        putc(fd, c);
 78e:	85ca                	mv	a1,s2
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	da0080e7          	jalr	-608(ra) # 532 <putc>
      state = 0;
 79a:	4981                	li	s3,0
 79c:	bd51                	j	630 <vprintf+0x42>
        s = va_arg(ap, char*);
 79e:	8bce                	mv	s7,s3
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b579                	j	630 <vprintf+0x42>
 7a4:	74e2                	ld	s1,56(sp)
 7a6:	79a2                	ld	s3,40(sp)
 7a8:	7a02                	ld	s4,32(sp)
 7aa:	6ae2                	ld	s5,24(sp)
 7ac:	6b42                	ld	s6,16(sp)
 7ae:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7b0:	60a6                	ld	ra,72(sp)
 7b2:	6406                	ld	s0,64(sp)
 7b4:	7942                	ld	s2,48(sp)
 7b6:	6161                	addi	sp,sp,80
 7b8:	8082                	ret

00000000000007ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ba:	715d                	addi	sp,sp,-80
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	addi	s0,sp,32
 7c2:	e010                	sd	a2,0(s0)
 7c4:	e414                	sd	a3,8(s0)
 7c6:	e818                	sd	a4,16(s0)
 7c8:	ec1c                	sd	a5,24(s0)
 7ca:	03043023          	sd	a6,32(s0)
 7ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d2:	8622                	mv	a2,s0
 7d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d8:	00000097          	auipc	ra,0x0
 7dc:	e16080e7          	jalr	-490(ra) # 5ee <vprintf>
}
 7e0:	60e2                	ld	ra,24(sp)
 7e2:	6442                	ld	s0,16(sp)
 7e4:	6161                	addi	sp,sp,80
 7e6:	8082                	ret

00000000000007e8 <printf>:

void
printf(const char *fmt, ...)
{
 7e8:	711d                	addi	sp,sp,-96
 7ea:	ec06                	sd	ra,24(sp)
 7ec:	e822                	sd	s0,16(sp)
 7ee:	1000                	addi	s0,sp,32
 7f0:	e40c                	sd	a1,8(s0)
 7f2:	e810                	sd	a2,16(s0)
 7f4:	ec14                	sd	a3,24(s0)
 7f6:	f018                	sd	a4,32(s0)
 7f8:	f41c                	sd	a5,40(s0)
 7fa:	03043823          	sd	a6,48(s0)
 7fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 802:	00840613          	addi	a2,s0,8
 806:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80a:	85aa                	mv	a1,a0
 80c:	4505                	li	a0,1
 80e:	00000097          	auipc	ra,0x0
 812:	de0080e7          	jalr	-544(ra) # 5ee <vprintf>
}
 816:	60e2                	ld	ra,24(sp)
 818:	6442                	ld	s0,16(sp)
 81a:	6125                	addi	sp,sp,96
 81c:	8082                	ret

000000000000081e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81e:	1141                	addi	sp,sp,-16
 820:	e406                	sd	ra,8(sp)
 822:	e022                	sd	s0,0(sp)
 824:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 826:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	00001797          	auipc	a5,0x1
 82e:	d467b783          	ld	a5,-698(a5) # 1570 <freep>
 832:	a02d                	j	85c <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 834:	4618                	lw	a4,8(a2)
 836:	9f2d                	addw	a4,a4,a1
 838:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83c:	6398                	ld	a4,0(a5)
 83e:	6310                	ld	a2,0(a4)
 840:	a83d                	j	87e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 842:	ff852703          	lw	a4,-8(a0)
 846:	9f31                	addw	a4,a4,a2
 848:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 84a:	ff053683          	ld	a3,-16(a0)
 84e:	a091                	j	892 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 850:	6398                	ld	a4,0(a5)
 852:	00e7e463          	bltu	a5,a4,85a <free+0x3c>
 856:	00e6ea63          	bltu	a3,a4,86a <free+0x4c>
{
 85a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85c:	fed7fae3          	bgeu	a5,a3,850 <free+0x32>
 860:	6398                	ld	a4,0(a5)
 862:	00e6e463          	bltu	a3,a4,86a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 866:	fee7eae3          	bltu	a5,a4,85a <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 86a:	ff852583          	lw	a1,-8(a0)
 86e:	6390                	ld	a2,0(a5)
 870:	02059813          	slli	a6,a1,0x20
 874:	01c85713          	srli	a4,a6,0x1c
 878:	9736                	add	a4,a4,a3
 87a:	fae60de3          	beq	a2,a4,834 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 87e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 882:	4790                	lw	a2,8(a5)
 884:	02061593          	slli	a1,a2,0x20
 888:	01c5d713          	srli	a4,a1,0x1c
 88c:	973e                	add	a4,a4,a5
 88e:	fae68ae3          	beq	a3,a4,842 <free+0x24>
    p->s.ptr = bp->s.ptr;
 892:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 894:	00001717          	auipc	a4,0x1
 898:	ccf73e23          	sd	a5,-804(a4) # 1570 <freep>
}
 89c:	60a2                	ld	ra,8(sp)
 89e:	6402                	ld	s0,0(sp)
 8a0:	0141                	addi	sp,sp,16
 8a2:	8082                	ret

00000000000008a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a4:	7139                	addi	sp,sp,-64
 8a6:	fc06                	sd	ra,56(sp)
 8a8:	f822                	sd	s0,48(sp)
 8aa:	f04a                	sd	s2,32(sp)
 8ac:	ec4e                	sd	s3,24(sp)
 8ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b0:	02051993          	slli	s3,a0,0x20
 8b4:	0209d993          	srli	s3,s3,0x20
 8b8:	09bd                	addi	s3,s3,15
 8ba:	0049d993          	srli	s3,s3,0x4
 8be:	2985                	addiw	s3,s3,1
 8c0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8c2:	00001517          	auipc	a0,0x1
 8c6:	cae53503          	ld	a0,-850(a0) # 1570 <freep>
 8ca:	c905                	beqz	a0,8fa <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ce:	4798                	lw	a4,8(a5)
 8d0:	09377a63          	bgeu	a4,s3,964 <malloc+0xc0>
 8d4:	f426                	sd	s1,40(sp)
 8d6:	e852                	sd	s4,16(sp)
 8d8:	e456                	sd	s5,8(sp)
 8da:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8dc:	8a4e                	mv	s4,s3
 8de:	6705                	lui	a4,0x1
 8e0:	00e9f363          	bgeu	s3,a4,8e6 <malloc+0x42>
 8e4:	6a05                	lui	s4,0x1
 8e6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ee:	00001497          	auipc	s1,0x1
 8f2:	c8248493          	addi	s1,s1,-894 # 1570 <freep>
  if(p == (char*)-1)
 8f6:	5afd                	li	s5,-1
 8f8:	a089                	j	93a <malloc+0x96>
 8fa:	f426                	sd	s1,40(sp)
 8fc:	e852                	sd	s4,16(sp)
 8fe:	e456                	sd	s5,8(sp)
 900:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 902:	00001797          	auipc	a5,0x1
 906:	e8e78793          	addi	a5,a5,-370 # 1790 <base>
 90a:	00001717          	auipc	a4,0x1
 90e:	c6f73323          	sd	a5,-922(a4) # 1570 <freep>
 912:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 914:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 918:	b7d1                	j	8dc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 91a:	6398                	ld	a4,0(a5)
 91c:	e118                	sd	a4,0(a0)
 91e:	a8b9                	j	97c <malloc+0xd8>
  hp->s.size = nu;
 920:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 924:	0541                	addi	a0,a0,16
 926:	00000097          	auipc	ra,0x0
 92a:	ef8080e7          	jalr	-264(ra) # 81e <free>
  return freep;
 92e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 930:	c135                	beqz	a0,994 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 932:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 934:	4798                	lw	a4,8(a5)
 936:	03277363          	bgeu	a4,s2,95c <malloc+0xb8>
    if(p == freep)
 93a:	6098                	ld	a4,0(s1)
 93c:	853e                	mv	a0,a5
 93e:	fef71ae3          	bne	a4,a5,932 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 942:	8552                	mv	a0,s4
 944:	00000097          	auipc	ra,0x0
 948:	b8e080e7          	jalr	-1138(ra) # 4d2 <sbrk>
  if(p == (char*)-1)
 94c:	fd551ae3          	bne	a0,s5,920 <malloc+0x7c>
        return 0;
 950:	4501                	li	a0,0
 952:	74a2                	ld	s1,40(sp)
 954:	6a42                	ld	s4,16(sp)
 956:	6aa2                	ld	s5,8(sp)
 958:	6b02                	ld	s6,0(sp)
 95a:	a03d                	j	988 <malloc+0xe4>
 95c:	74a2                	ld	s1,40(sp)
 95e:	6a42                	ld	s4,16(sp)
 960:	6aa2                	ld	s5,8(sp)
 962:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 964:	fae90be3          	beq	s2,a4,91a <malloc+0x76>
        p->s.size -= nunits;
 968:	4137073b          	subw	a4,a4,s3
 96c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 96e:	02071693          	slli	a3,a4,0x20
 972:	01c6d713          	srli	a4,a3,0x1c
 976:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 978:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97c:	00001717          	auipc	a4,0x1
 980:	bea73a23          	sd	a0,-1036(a4) # 1570 <freep>
      return (void*)(p + 1);
 984:	01078513          	addi	a0,a5,16
  }
}
 988:	70e2                	ld	ra,56(sp)
 98a:	7442                	ld	s0,48(sp)
 98c:	7902                	ld	s2,32(sp)
 98e:	69e2                	ld	s3,24(sp)
 990:	6121                	addi	sp,sp,64
 992:	8082                	ret
 994:	74a2                	ld	s1,40(sp)
 996:	6a42                	ld	s4,16(sp)
 998:	6aa2                	ld	s5,8(sp)
 99a:	6b02                	ld	s6,0(sp)
 99c:	b7f5                	j	988 <malloc+0xe4>

000000000000099e <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 99e:	1141                	addi	sp,sp,-16
 9a0:	e406                	sd	ra,8(sp)
 9a2:	e022                	sd	s0,0(sp)
 9a4:	0800                	addi	s0,sp,16
  thread_exit(status);
 9a6:	2501                	sext.w	a0,a0
 9a8:	00000097          	auipc	ra,0x0
 9ac:	b5a080e7          	jalr	-1190(ra) # 502 <thread_exit>
}
 9b0:	60a2                	ld	ra,8(sp)
 9b2:	6402                	ld	s0,0(sp)
 9b4:	0141                	addi	sp,sp,16
 9b6:	8082                	ret

00000000000009b8 <free_stacks>:
int free_stacks() {
 9b8:	7179                	addi	sp,sp,-48
 9ba:	f406                	sd	ra,40(sp)
 9bc:	f022                	sd	s0,32(sp)
 9be:	ec26                	sd	s1,24(sp)
 9c0:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 9c2:	00001797          	auipc	a5,0x1
 9c6:	bbe7a783          	lw	a5,-1090(a5) # 1580 <num_threads>
 9ca:	04f05063          	blez	a5,a0a <free_stacks+0x52>
 9ce:	e84a                	sd	s2,16(sp)
 9d0:	e44e                	sd	s3,8(sp)
 9d2:	4481                	li	s1,0
    free(stacks[i]);
 9d4:	00001997          	auipc	s3,0x1
 9d8:	ba498993          	addi	s3,s3,-1116 # 1578 <stacks>
  for (int i = 0; i < num_threads; i++) {
 9dc:	00001917          	auipc	s2,0x1
 9e0:	ba490913          	addi	s2,s2,-1116 # 1580 <num_threads>
    free(stacks[i]);
 9e4:	0009b783          	ld	a5,0(s3)
 9e8:	00349713          	slli	a4,s1,0x3
 9ec:	97ba                	add	a5,a5,a4
 9ee:	6388                	ld	a0,0(a5)
 9f0:	00000097          	auipc	ra,0x0
 9f4:	e2e080e7          	jalr	-466(ra) # 81e <free>
  for (int i = 0; i < num_threads; i++) {
 9f8:	0485                	addi	s1,s1,1
 9fa:	00092703          	lw	a4,0(s2)
 9fe:	0004879b          	sext.w	a5,s1
 a02:	fee7c1e3          	blt	a5,a4,9e4 <free_stacks+0x2c>
 a06:	6942                	ld	s2,16(sp)
 a08:	69a2                	ld	s3,8(sp)
  free(stacks);
 a0a:	00001497          	auipc	s1,0x1
 a0e:	b6e48493          	addi	s1,s1,-1170 # 1578 <stacks>
 a12:	6088                	ld	a0,0(s1)
 a14:	00000097          	auipc	ra,0x0
 a18:	e0a080e7          	jalr	-502(ra) # 81e <free>
  stacks = 0;
 a1c:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 a20:	00001797          	auipc	a5,0x1
 a24:	b607a023          	sw	zero,-1184(a5) # 1580 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 a28:	47a1                	li	a5,8
 a2a:	00001717          	auipc	a4,0x1
 a2e:	b2f72b23          	sw	a5,-1226(a4) # 1560 <max_stacks>
  threads_done = 0;
 a32:	00001797          	auipc	a5,0x1
 a36:	b407a923          	sw	zero,-1198(a5) # 1584 <threads_done>
}
 a3a:	4501                	li	a0,0
 a3c:	70a2                	ld	ra,40(sp)
 a3e:	7402                	ld	s0,32(sp)
 a40:	64e2                	ld	s1,24(sp)
 a42:	6145                	addi	sp,sp,48
 a44:	8082                	ret

0000000000000a46 <expand_num_threads>:
int expand_num_threads() {
 a46:	1101                	addi	sp,sp,-32
 a48:	ec06                	sd	ra,24(sp)
 a4a:	e822                	sd	s0,16(sp)
 a4c:	e426                	sd	s1,8(sp)
 a4e:	e04a                	sd	s2,0(sp)
 a50:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a52:	00001797          	auipc	a5,0x1
 a56:	b0e78793          	addi	a5,a5,-1266 # 1560 <max_stacks>
 a5a:	4388                	lw	a0,0(a5)
 a5c:	0015151b          	slliw	a0,a0,0x1
 a60:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a62:	0035151b          	slliw	a0,a0,0x3
 a66:	00000097          	auipc	ra,0x0
 a6a:	e3e080e7          	jalr	-450(ra) # 8a4 <malloc>
 a6e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a70:	00001617          	auipc	a2,0x1
 a74:	b1062603          	lw	a2,-1264(a2) # 1580 <num_threads>
 a78:	00001497          	auipc	s1,0x1
 a7c:	b0048493          	addi	s1,s1,-1280 # 1578 <stacks>
 a80:	0036161b          	slliw	a2,a2,0x3
 a84:	608c                	ld	a1,0(s1)
 a86:	00000097          	auipc	ra,0x0
 a8a:	90a080e7          	jalr	-1782(ra) # 390 <memmove>
  free(stacks);
 a8e:	6088                	ld	a0,0(s1)
 a90:	00000097          	auipc	ra,0x0
 a94:	d8e080e7          	jalr	-626(ra) # 81e <free>
  stacks = new_stacks;
 a98:	0124b023          	sd	s2,0(s1)
}
 a9c:	4501                	li	a0,0
 a9e:	60e2                	ld	ra,24(sp)
 aa0:	6442                	ld	s0,16(sp)
 aa2:	64a2                	ld	s1,8(sp)
 aa4:	6902                	ld	s2,0(sp)
 aa6:	6105                	addi	sp,sp,32
 aa8:	8082                	ret

0000000000000aaa <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 aaa:	7179                	addi	sp,sp,-48
 aac:	f406                	sd	ra,40(sp)
 aae:	f022                	sd	s0,32(sp)
 ab0:	e84a                	sd	s2,16(sp)
 ab2:	e44e                	sd	s3,8(sp)
 ab4:	1800                	addi	s0,sp,48
 ab6:	892a                	mv	s2,a0
 ab8:	89ae                	mv	s3,a1
  if (stacks == 0) {
 aba:	00001797          	auipc	a5,0x1
 abe:	abe7b783          	ld	a5,-1346(a5) # 1578 <stacks>
 ac2:	c3d9                	beqz	a5,b48 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 ac4:	00001797          	auipc	a5,0x1
 ac8:	a9c7a783          	lw	a5,-1380(a5) # 1560 <max_stacks>
 acc:	00001717          	auipc	a4,0x1
 ad0:	ab472703          	lw	a4,-1356(a4) # 1580 <num_threads>
 ad4:	0af71363          	bne	a4,a5,b7a <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 ad8:	04000713          	li	a4,64
 adc:	08e78563          	beq	a5,a4,b66 <ithread_create+0xbc>
 ae0:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 ae2:	00000097          	auipc	ra,0x0
 ae6:	f64080e7          	jalr	-156(ra) # a46 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 aea:	6505                	lui	a0,0x1
 aec:	00000097          	auipc	ra,0x0
 af0:	db8080e7          	jalr	-584(ra) # 8a4 <malloc>
 af4:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 af6:	00001717          	auipc	a4,0x1
 afa:	a8a72703          	lw	a4,-1398(a4) # 1580 <num_threads>
 afe:	070e                	slli	a4,a4,0x3
 b00:	00001797          	auipc	a5,0x1
 b04:	a787b783          	ld	a5,-1416(a5) # 1578 <stacks>
 b08:	97ba                	add	a5,a5,a4
 b0a:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 b0c:	00000697          	auipc	a3,0x0
 b10:	e9268693          	addi	a3,a3,-366 # 99e <ithread_exit>
 b14:	862a                	mv	a2,a0
 b16:	85ce                	mv	a1,s3
 b18:	854a                	mv	a0,s2
 b1a:	00000097          	auipc	ra,0x0
 b1e:	9d8080e7          	jalr	-1576(ra) # 4f2 <create_thread>
 b22:	892a                	mv	s2,a0
  if (res != -1) {
 b24:	57fd                	li	a5,-1
 b26:	04f50c63          	beq	a0,a5,b7e <ithread_create+0xd4>
    num_threads++;
 b2a:	00001717          	auipc	a4,0x1
 b2e:	a5670713          	addi	a4,a4,-1450 # 1580 <num_threads>
 b32:	431c                	lw	a5,0(a4)
 b34:	2785                	addiw	a5,a5,1
 b36:	c31c                	sw	a5,0(a4)
 b38:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 b3a:	854a                	mv	a0,s2
 b3c:	70a2                	ld	ra,40(sp)
 b3e:	7402                	ld	s0,32(sp)
 b40:	6942                	ld	s2,16(sp)
 b42:	69a2                	ld	s3,8(sp)
 b44:	6145                	addi	sp,sp,48
 b46:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 b48:	00001517          	auipc	a0,0x1
 b4c:	a1852503          	lw	a0,-1512(a0) # 1560 <max_stacks>
 b50:	0035151b          	slliw	a0,a0,0x3
 b54:	00000097          	auipc	ra,0x0
 b58:	d50080e7          	jalr	-688(ra) # 8a4 <malloc>
 b5c:	00001797          	auipc	a5,0x1
 b60:	a0a7be23          	sd	a0,-1508(a5) # 1578 <stacks>
 b64:	b785                	j	ac4 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b66:	00000517          	auipc	a0,0x0
 b6a:	0d250513          	addi	a0,a0,210 # c38 <ithread_join+0x94>
 b6e:	00000097          	auipc	ra,0x0
 b72:	c7a080e7          	jalr	-902(ra) # 7e8 <printf>
      return -1;
 b76:	597d                	li	s2,-1
 b78:	b7c9                	j	b3a <ithread_create+0x90>
 b7a:	ec26                	sd	s1,24(sp)
 b7c:	b7bd                	j	aea <ithread_create+0x40>
    free(stack_ptr);
 b7e:	8526                	mv	a0,s1
 b80:	00000097          	auipc	ra,0x0
 b84:	c9e080e7          	jalr	-866(ra) # 81e <free>
    stacks[num_threads] = 0;
 b88:	00001717          	auipc	a4,0x1
 b8c:	9f872703          	lw	a4,-1544(a4) # 1580 <num_threads>
 b90:	070e                	slli	a4,a4,0x3
 b92:	00001797          	auipc	a5,0x1
 b96:	9e67b783          	ld	a5,-1562(a5) # 1578 <stacks>
 b9a:	97ba                	add	a5,a5,a4
 b9c:	0007b023          	sd	zero,0(a5)
 ba0:	64e2                	ld	s1,24(sp)
 ba2:	bf61                	j	b3a <ithread_create+0x90>

0000000000000ba4 <ithread_join>:

int ithread_join(int thread_id) {
 ba4:	1101                	addi	sp,sp,-32
 ba6:	ec06                	sd	ra,24(sp)
 ba8:	e822                	sd	s0,16(sp)
 baa:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 bac:	ff040793          	addi	a5,s0,-16
 bb0:	ffc7859b          	addiw	a1,a5,-4
 bb4:	00000097          	auipc	ra,0x0
 bb8:	946080e7          	jalr	-1722(ra) # 4fa <join_thread>
  threads_done++;
 bbc:	00001717          	auipc	a4,0x1
 bc0:	9c870713          	addi	a4,a4,-1592 # 1584 <threads_done>
 bc4:	431c                	lw	a5,0(a4)
 bc6:	2785                	addiw	a5,a5,1
 bc8:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 bca:	00001717          	auipc	a4,0x1
 bce:	9b672703          	lw	a4,-1610(a4) # 1580 <num_threads>
 bd2:	00f70863          	beq	a4,a5,be2 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 bd6:	fec42503          	lw	a0,-20(s0)
 bda:	60e2                	ld	ra,24(sp)
 bdc:	6442                	ld	s0,16(sp)
 bde:	6105                	addi	sp,sp,32
 be0:	8082                	ret
    free_stacks();
 be2:	00000097          	auipc	ra,0x0
 be6:	dd6080e7          	jalr	-554(ra) # 9b8 <free_stacks>
 bea:	b7f5                	j	bd6 <ithread_join+0x32>
