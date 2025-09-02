
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	711d                	addi	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	e862                	sd	s8,16(sp)
 130:	e466                	sd	s9,8(sp)
 132:	e06a                	sd	s10,0(sp)
 134:	1080                	addi	s0,sp,96
 136:	8aaa                	mv	s5,a0
 138:	8cae                	mv	s9,a1
  m = 0;
 13a:	4b01                	li	s6,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13c:	3ff00d13          	li	s10,1023
 140:	00001b97          	auipc	s7,0x1
 144:	4e0b8b93          	addi	s7,s7,1248 # 1620 <buf>
    while((q = strchr(p, '\n')) != 0){
 148:	49a9                	li	s3,10
        write(1, p, q+1 - p);
 14a:	4c05                	li	s8,1
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 14c:	a099                	j	192 <grep+0x78>
      p = q+1;
 14e:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 152:	85ce                	mv	a1,s3
 154:	854a                	mv	a0,s2
 156:	00000097          	auipc	ra,0x0
 15a:	21a080e7          	jalr	538(ra) # 370 <strchr>
 15e:	84aa                	mv	s1,a0
 160:	c51d                	beqz	a0,18e <grep+0x74>
      *q = 0;
 162:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 166:	85ca                	mv	a1,s2
 168:	8556                	mv	a0,s5
 16a:	00000097          	auipc	ra,0x0
 16e:	f62080e7          	jalr	-158(ra) # cc <match>
 172:	dd71                	beqz	a0,14e <grep+0x34>
        *q = '\n';
 174:	01348023          	sb	s3,0(s1)
        write(1, p, q+1 - p);
 178:	00148613          	addi	a2,s1,1
 17c:	4126063b          	subw	a2,a2,s2
 180:	85ca                	mv	a1,s2
 182:	8562                	mv	a0,s8
 184:	00000097          	auipc	ra,0x0
 188:	408080e7          	jalr	1032(ra) # 58c <write>
 18c:	b7c9                	j	14e <grep+0x34>
    if(m > 0){
 18e:	03604663          	bgtz	s6,1ba <grep+0xa0>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 192:	416d063b          	subw	a2,s10,s6
 196:	016b85b3          	add	a1,s7,s6
 19a:	8566                	mv	a0,s9
 19c:	00000097          	auipc	ra,0x0
 1a0:	3e8080e7          	jalr	1000(ra) # 584 <read>
 1a4:	02a05a63          	blez	a0,1d8 <grep+0xbe>
    m += n;
 1a8:	00ab0a3b          	addw	s4,s6,a0
 1ac:	8b52                	mv	s6,s4
    buf[m] = '\0';
 1ae:	014b87b3          	add	a5,s7,s4
 1b2:	00078023          	sb	zero,0(a5)
    p = buf;
 1b6:	895e                	mv	s2,s7
    while((q = strchr(p, '\n')) != 0){
 1b8:	bf69                	j	152 <grep+0x38>
      m -= p - buf;
 1ba:	00001517          	auipc	a0,0x1
 1be:	46650513          	addi	a0,a0,1126 # 1620 <buf>
 1c2:	40a907b3          	sub	a5,s2,a0
 1c6:	40fa063b          	subw	a2,s4,a5
 1ca:	8b32                	mv	s6,a2
      memmove(buf, p, m);
 1cc:	85ca                	mv	a1,s2
 1ce:	00000097          	auipc	ra,0x0
 1d2:	2e4080e7          	jalr	740(ra) # 4b2 <memmove>
 1d6:	bf75                	j	192 <grep+0x78>
}
 1d8:	60e6                	ld	ra,88(sp)
 1da:	6446                	ld	s0,80(sp)
 1dc:	64a6                	ld	s1,72(sp)
 1de:	6906                	ld	s2,64(sp)
 1e0:	79e2                	ld	s3,56(sp)
 1e2:	7a42                	ld	s4,48(sp)
 1e4:	7aa2                	ld	s5,40(sp)
 1e6:	7b02                	ld	s6,32(sp)
 1e8:	6be2                	ld	s7,24(sp)
 1ea:	6c42                	ld	s8,16(sp)
 1ec:	6ca2                	ld	s9,8(sp)
 1ee:	6d02                	ld	s10,0(sp)
 1f0:	6125                	addi	sp,sp,96
 1f2:	8082                	ret

00000000000001f4 <main>:
{
 1f4:	7179                	addi	sp,sp,-48
 1f6:	f406                	sd	ra,40(sp)
 1f8:	f022                	sd	s0,32(sp)
 1fa:	ec26                	sd	s1,24(sp)
 1fc:	e84a                	sd	s2,16(sp)
 1fe:	e44e                	sd	s3,8(sp)
 200:	e052                	sd	s4,0(sp)
 202:	1800                	addi	s0,sp,48
  if(argc <= 1){
 204:	4785                	li	a5,1
 206:	04a7de63          	bge	a5,a0,262 <main+0x6e>
  pattern = argv[1];
 20a:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 20e:	4789                	li	a5,2
 210:	06a7d763          	bge	a5,a0,27e <main+0x8a>
 214:	01058913          	addi	s2,a1,16
 218:	ffd5099b          	addiw	s3,a0,-3
 21c:	02099793          	slli	a5,s3,0x20
 220:	01d7d993          	srli	s3,a5,0x1d
 224:	05e1                	addi	a1,a1,24
 226:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 228:	4581                	li	a1,0
 22a:	00093503          	ld	a0,0(s2)
 22e:	00000097          	auipc	ra,0x0
 232:	37e080e7          	jalr	894(ra) # 5ac <open>
 236:	84aa                	mv	s1,a0
 238:	04054e63          	bltz	a0,294 <main+0xa0>
    grep(pattern, fd);
 23c:	85aa                	mv	a1,a0
 23e:	8552                	mv	a0,s4
 240:	00000097          	auipc	ra,0x0
 244:	eda080e7          	jalr	-294(ra) # 11a <grep>
    close(fd);
 248:	8526                	mv	a0,s1
 24a:	00000097          	auipc	ra,0x0
 24e:	34a080e7          	jalr	842(ra) # 594 <close>
  for(i = 2; i < argc; i++){
 252:	0921                	addi	s2,s2,8
 254:	fd391ae3          	bne	s2,s3,228 <main+0x34>
  exit(0);
 258:	4501                	li	a0,0
 25a:	00000097          	auipc	ra,0x0
 25e:	312080e7          	jalr	786(ra) # 56c <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 262:	00001597          	auipc	a1,0x1
 266:	ade58593          	addi	a1,a1,-1314 # d40 <ithread_join+0x54>
 26a:	4509                	li	a0,2
 26c:	00000097          	auipc	ra,0x0
 270:	696080e7          	jalr	1686(ra) # 902 <fprintf>
    exit(1);
 274:	4505                	li	a0,1
 276:	00000097          	auipc	ra,0x0
 27a:	2f6080e7          	jalr	758(ra) # 56c <exit>
    grep(pattern, 0);
 27e:	4581                	li	a1,0
 280:	8552                	mv	a0,s4
 282:	00000097          	auipc	ra,0x0
 286:	e98080e7          	jalr	-360(ra) # 11a <grep>
    exit(0);
 28a:	4501                	li	a0,0
 28c:	00000097          	auipc	ra,0x0
 290:	2e0080e7          	jalr	736(ra) # 56c <exit>
      printf("grep: cannot open %s\n", argv[i]);
 294:	00093583          	ld	a1,0(s2)
 298:	00001517          	auipc	a0,0x1
 29c:	ac850513          	addi	a0,a0,-1336 # d60 <ithread_join+0x74>
 2a0:	00000097          	auipc	ra,0x0
 2a4:	690080e7          	jalr	1680(ra) # 930 <printf>
      exit(1);
 2a8:	4505                	li	a0,1
 2aa:	00000097          	auipc	ra,0x0
 2ae:	2c2080e7          	jalr	706(ra) # 56c <exit>

00000000000002b2 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2ba:	00000097          	auipc	ra,0x0
 2be:	f3a080e7          	jalr	-198(ra) # 1f4 <main>
  exit(0);
 2c2:	4501                	li	a0,0
 2c4:	00000097          	auipc	ra,0x0
 2c8:	2a8080e7          	jalr	680(ra) # 56c <exit>

00000000000002cc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2d4:	87aa                	mv	a5,a0
 2d6:	0585                	addi	a1,a1,1
 2d8:	0785                	addi	a5,a5,1
 2da:	fff5c703          	lbu	a4,-1(a1)
 2de:	fee78fa3          	sb	a4,-1(a5)
 2e2:	fb75                	bnez	a4,2d6 <strcpy+0xa>
    ;
  return os;
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	cb91                	beqz	a5,30c <strcmp+0x20>
 2fa:	0005c703          	lbu	a4,0(a1)
 2fe:	00f71763          	bne	a4,a5,30c <strcmp+0x20>
    p++, q++;
 302:	0505                	addi	a0,a0,1
 304:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 306:	00054783          	lbu	a5,0(a0)
 30a:	fbe5                	bnez	a5,2fa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 30c:	0005c503          	lbu	a0,0(a1)
}
 310:	40a7853b          	subw	a0,a5,a0
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <strlen>:

uint
strlen(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 324:	00054783          	lbu	a5,0(a0)
 328:	cf99                	beqz	a5,346 <strlen+0x2a>
 32a:	0505                	addi	a0,a0,1
 32c:	87aa                	mv	a5,a0
 32e:	86be                	mv	a3,a5
 330:	0785                	addi	a5,a5,1
 332:	fff7c703          	lbu	a4,-1(a5)
 336:	ff65                	bnez	a4,32e <strlen+0x12>
 338:	40a6853b          	subw	a0,a3,a0
 33c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
  for(n = 0; s[n]; n++)
 346:	4501                	li	a0,0
 348:	bfdd                	j	33e <strlen+0x22>

000000000000034a <memset>:

void*
memset(void *dst, int c, uint n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 352:	ca19                	beqz	a2,368 <memset+0x1e>
 354:	87aa                	mv	a5,a0
 356:	1602                	slli	a2,a2,0x20
 358:	9201                	srli	a2,a2,0x20
 35a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 35e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 362:	0785                	addi	a5,a5,1
 364:	fee79de3          	bne	a5,a4,35e <memset+0x14>
  }
  return dst;
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret

0000000000000370 <strchr>:

char*
strchr(const char *s, char c)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  for(; *s; s++)
 378:	00054783          	lbu	a5,0(a0)
 37c:	cf81                	beqz	a5,394 <strchr+0x24>
    if(*s == c)
 37e:	00f58763          	beq	a1,a5,38c <strchr+0x1c>
  for(; *s; s++)
 382:	0505                	addi	a0,a0,1
 384:	00054783          	lbu	a5,0(a0)
 388:	fbfd                	bnez	a5,37e <strchr+0xe>
      return (char*)s;
  return 0;
 38a:	4501                	li	a0,0
}
 38c:	60a2                	ld	ra,8(sp)
 38e:	6402                	ld	s0,0(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret
  return 0;
 394:	4501                	li	a0,0
 396:	bfdd                	j	38c <strchr+0x1c>

0000000000000398 <gets>:

char*
gets(char *buf, int max)
{
 398:	7159                	addi	sp,sp,-112
 39a:	f486                	sd	ra,104(sp)
 39c:	f0a2                	sd	s0,96(sp)
 39e:	eca6                	sd	s1,88(sp)
 3a0:	e8ca                	sd	s2,80(sp)
 3a2:	e4ce                	sd	s3,72(sp)
 3a4:	e0d2                	sd	s4,64(sp)
 3a6:	fc56                	sd	s5,56(sp)
 3a8:	f85a                	sd	s6,48(sp)
 3aa:	f45e                	sd	s7,40(sp)
 3ac:	f062                	sd	s8,32(sp)
 3ae:	ec66                	sd	s9,24(sp)
 3b0:	e86a                	sd	s10,16(sp)
 3b2:	1880                	addi	s0,sp,112
 3b4:	8caa                	mv	s9,a0
 3b6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b8:	892a                	mv	s2,a0
 3ba:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3bc:	f9f40b13          	addi	s6,s0,-97
 3c0:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3c2:	4ba9                	li	s7,10
 3c4:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 3c6:	8d26                	mv	s10,s1
 3c8:	0014899b          	addiw	s3,s1,1
 3cc:	84ce                	mv	s1,s3
 3ce:	0349d763          	bge	s3,s4,3fc <gets+0x64>
    cc = read(0, &c, 1);
 3d2:	8656                	mv	a2,s5
 3d4:	85da                	mv	a1,s6
 3d6:	4501                	li	a0,0
 3d8:	00000097          	auipc	ra,0x0
 3dc:	1ac080e7          	jalr	428(ra) # 584 <read>
    if(cc < 1)
 3e0:	00a05e63          	blez	a0,3fc <gets+0x64>
    buf[i++] = c;
 3e4:	f9f44783          	lbu	a5,-97(s0)
 3e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ec:	01778763          	beq	a5,s7,3fa <gets+0x62>
 3f0:	0905                	addi	s2,s2,1
 3f2:	fd879ae3          	bne	a5,s8,3c6 <gets+0x2e>
    buf[i++] = c;
 3f6:	8d4e                	mv	s10,s3
 3f8:	a011                	j	3fc <gets+0x64>
 3fa:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3fc:	9d66                	add	s10,s10,s9
 3fe:	000d0023          	sb	zero,0(s10)
  return buf;
}
 402:	8566                	mv	a0,s9
 404:	70a6                	ld	ra,104(sp)
 406:	7406                	ld	s0,96(sp)
 408:	64e6                	ld	s1,88(sp)
 40a:	6946                	ld	s2,80(sp)
 40c:	69a6                	ld	s3,72(sp)
 40e:	6a06                	ld	s4,64(sp)
 410:	7ae2                	ld	s5,56(sp)
 412:	7b42                	ld	s6,48(sp)
 414:	7ba2                	ld	s7,40(sp)
 416:	7c02                	ld	s8,32(sp)
 418:	6ce2                	ld	s9,24(sp)
 41a:	6d42                	ld	s10,16(sp)
 41c:	6165                	addi	sp,sp,112
 41e:	8082                	ret

0000000000000420 <stat>:

int
stat(const char *n, struct stat *st)
{
 420:	1101                	addi	sp,sp,-32
 422:	ec06                	sd	ra,24(sp)
 424:	e822                	sd	s0,16(sp)
 426:	e04a                	sd	s2,0(sp)
 428:	1000                	addi	s0,sp,32
 42a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42c:	4581                	li	a1,0
 42e:	00000097          	auipc	ra,0x0
 432:	17e080e7          	jalr	382(ra) # 5ac <open>
  if(fd < 0)
 436:	02054663          	bltz	a0,462 <stat+0x42>
 43a:	e426                	sd	s1,8(sp)
 43c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 43e:	85ca                	mv	a1,s2
 440:	00000097          	auipc	ra,0x0
 444:	184080e7          	jalr	388(ra) # 5c4 <fstat>
 448:	892a                	mv	s2,a0
  close(fd);
 44a:	8526                	mv	a0,s1
 44c:	00000097          	auipc	ra,0x0
 450:	148080e7          	jalr	328(ra) # 594 <close>
  return r;
 454:	64a2                	ld	s1,8(sp)
}
 456:	854a                	mv	a0,s2
 458:	60e2                	ld	ra,24(sp)
 45a:	6442                	ld	s0,16(sp)
 45c:	6902                	ld	s2,0(sp)
 45e:	6105                	addi	sp,sp,32
 460:	8082                	ret
    return -1;
 462:	597d                	li	s2,-1
 464:	bfcd                	j	456 <stat+0x36>

0000000000000466 <atoi>:

int
atoi(const char *s)
{
 466:	1141                	addi	sp,sp,-16
 468:	e406                	sd	ra,8(sp)
 46a:	e022                	sd	s0,0(sp)
 46c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 46e:	00054683          	lbu	a3,0(a0)
 472:	fd06879b          	addiw	a5,a3,-48
 476:	0ff7f793          	zext.b	a5,a5
 47a:	4625                	li	a2,9
 47c:	02f66963          	bltu	a2,a5,4ae <atoi+0x48>
 480:	872a                	mv	a4,a0
  n = 0;
 482:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 484:	0705                	addi	a4,a4,1
 486:	0025179b          	slliw	a5,a0,0x2
 48a:	9fa9                	addw	a5,a5,a0
 48c:	0017979b          	slliw	a5,a5,0x1
 490:	9fb5                	addw	a5,a5,a3
 492:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 496:	00074683          	lbu	a3,0(a4)
 49a:	fd06879b          	addiw	a5,a3,-48
 49e:	0ff7f793          	zext.b	a5,a5
 4a2:	fef671e3          	bgeu	a2,a5,484 <atoi+0x1e>
  return n;
}
 4a6:	60a2                	ld	ra,8(sp)
 4a8:	6402                	ld	s0,0(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret
  n = 0;
 4ae:	4501                	li	a0,0
 4b0:	bfdd                	j	4a6 <atoi+0x40>

00000000000004b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e406                	sd	ra,8(sp)
 4b6:	e022                	sd	s0,0(sp)
 4b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ba:	02b57563          	bgeu	a0,a1,4e4 <memmove+0x32>
    while(n-- > 0)
 4be:	00c05f63          	blez	a2,4dc <memmove+0x2a>
 4c2:	1602                	slli	a2,a2,0x20
 4c4:	9201                	srli	a2,a2,0x20
 4c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 4cc:	0585                	addi	a1,a1,1
 4ce:	0705                	addi	a4,a4,1
 4d0:	fff5c683          	lbu	a3,-1(a1)
 4d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4d8:	fee79ae3          	bne	a5,a4,4cc <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4dc:	60a2                	ld	ra,8(sp)
 4de:	6402                	ld	s0,0(sp)
 4e0:	0141                	addi	sp,sp,16
 4e2:	8082                	ret
    dst += n;
 4e4:	00c50733          	add	a4,a0,a2
    src += n;
 4e8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4ea:	fec059e3          	blez	a2,4dc <memmove+0x2a>
 4ee:	fff6079b          	addiw	a5,a2,-1
 4f2:	1782                	slli	a5,a5,0x20
 4f4:	9381                	srli	a5,a5,0x20
 4f6:	fff7c793          	not	a5,a5
 4fa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4fc:	15fd                	addi	a1,a1,-1
 4fe:	177d                	addi	a4,a4,-1
 500:	0005c683          	lbu	a3,0(a1)
 504:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 508:	fef71ae3          	bne	a4,a5,4fc <memmove+0x4a>
 50c:	bfc1                	j	4dc <memmove+0x2a>

000000000000050e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 50e:	1141                	addi	sp,sp,-16
 510:	e406                	sd	ra,8(sp)
 512:	e022                	sd	s0,0(sp)
 514:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 516:	ca0d                	beqz	a2,548 <memcmp+0x3a>
 518:	fff6069b          	addiw	a3,a2,-1
 51c:	1682                	slli	a3,a3,0x20
 51e:	9281                	srli	a3,a3,0x20
 520:	0685                	addi	a3,a3,1
 522:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 524:	00054783          	lbu	a5,0(a0)
 528:	0005c703          	lbu	a4,0(a1)
 52c:	00e79863          	bne	a5,a4,53c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 530:	0505                	addi	a0,a0,1
    p2++;
 532:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 534:	fed518e3          	bne	a0,a3,524 <memcmp+0x16>
  }
  return 0;
 538:	4501                	li	a0,0
 53a:	a019                	j	540 <memcmp+0x32>
      return *p1 - *p2;
 53c:	40e7853b          	subw	a0,a5,a4
}
 540:	60a2                	ld	ra,8(sp)
 542:	6402                	ld	s0,0(sp)
 544:	0141                	addi	sp,sp,16
 546:	8082                	ret
  return 0;
 548:	4501                	li	a0,0
 54a:	bfdd                	j	540 <memcmp+0x32>

000000000000054c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 54c:	1141                	addi	sp,sp,-16
 54e:	e406                	sd	ra,8(sp)
 550:	e022                	sd	s0,0(sp)
 552:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 554:	00000097          	auipc	ra,0x0
 558:	f5e080e7          	jalr	-162(ra) # 4b2 <memmove>
}
 55c:	60a2                	ld	ra,8(sp)
 55e:	6402                	ld	s0,0(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret

0000000000000564 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 564:	4885                	li	a7,1
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <exit>:
.global exit
exit:
 li a7, SYS_exit
 56c:	4889                	li	a7,2
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <wait>:
.global wait
wait:
 li a7, SYS_wait
 574:	488d                	li	a7,3
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57c:	4891                	li	a7,4
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <read>:
.global read
read:
 li a7, SYS_read
 584:	4895                	li	a7,5
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <write>:
.global write
write:
 li a7, SYS_write
 58c:	48c1                	li	a7,16
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <close>:
.global close
close:
 li a7, SYS_close
 594:	48d5                	li	a7,21
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <kill>:
.global kill
kill:
 li a7, SYS_kill
 59c:	4899                	li	a7,6
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a4:	489d                	li	a7,7
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <open>:
.global open
open:
 li a7, SYS_open
 5ac:	48bd                	li	a7,15
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b4:	48c5                	li	a7,17
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5bc:	48c9                	li	a7,18
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c4:	48a1                	li	a7,8
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <link>:
.global link
link:
 li a7, SYS_link
 5cc:	48cd                	li	a7,19
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d4:	48d1                	li	a7,20
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5dc:	48a5                	li	a7,9
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e4:	48a9                	li	a7,10
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ec:	48ad                	li	a7,11
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f4:	48b1                	li	a7,12
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5fc:	48b5                	li	a7,13
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 604:	48b9                	li	a7,14
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 60c:	48d9                	li	a7,22
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 614:	48dd                	li	a7,23
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 61c:	48e1                	li	a7,24
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 624:	48e5                	li	a7,25
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <socket>:
.global socket
socket:
 li a7, SYS_socket
 62c:	48e9                	li	a7,26
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <bind>:
.global bind
bind:
 li a7, SYS_bind
 634:	48ed                	li	a7,27
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <accept>:
.global accept
accept:
 li a7, SYS_accept
 63c:	48f5                	li	a7,29
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <listen>:
.global listen
listen:
 li a7, SYS_listen
 644:	48f1                	li	a7,28
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <connect>:
.global connect
connect:
 li a7, SYS_connect
 64c:	48f9                	li	a7,30
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <send>:
.global send
send:
 li a7, SYS_send
 654:	48fd                	li	a7,31
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <recv>:
.global recv
recv:
 li a7, SYS_recv
 65c:	02000893          	li	a7,32
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 666:	02100893          	li	a7,33
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 670:	02200893          	li	a7,34
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 67a:	1101                	addi	sp,sp,-32
 67c:	ec06                	sd	ra,24(sp)
 67e:	e822                	sd	s0,16(sp)
 680:	1000                	addi	s0,sp,32
 682:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 686:	4605                	li	a2,1
 688:	fef40593          	addi	a1,s0,-17
 68c:	00000097          	auipc	ra,0x0
 690:	f00080e7          	jalr	-256(ra) # 58c <write>
}
 694:	60e2                	ld	ra,24(sp)
 696:	6442                	ld	s0,16(sp)
 698:	6105                	addi	sp,sp,32
 69a:	8082                	ret

000000000000069c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 69c:	7139                	addi	sp,sp,-64
 69e:	fc06                	sd	ra,56(sp)
 6a0:	f822                	sd	s0,48(sp)
 6a2:	f426                	sd	s1,40(sp)
 6a4:	f04a                	sd	s2,32(sp)
 6a6:	ec4e                	sd	s3,24(sp)
 6a8:	0080                	addi	s0,sp,64
 6aa:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6ac:	c299                	beqz	a3,6b2 <printint+0x16>
 6ae:	0805c063          	bltz	a1,72e <printint+0x92>
  neg = 0;
 6b2:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 6b4:	fc040313          	addi	t1,s0,-64
  neg = 0;
 6b8:	869a                	mv	a3,t1
  i = 0;
 6ba:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 6bc:	00000817          	auipc	a6,0x0
 6c0:	74c80813          	addi	a6,a6,1868 # e08 <digits>
 6c4:	88be                	mv	a7,a5
 6c6:	0017851b          	addiw	a0,a5,1
 6ca:	87aa                	mv	a5,a0
 6cc:	02c5f73b          	remuw	a4,a1,a2
 6d0:	1702                	slli	a4,a4,0x20
 6d2:	9301                	srli	a4,a4,0x20
 6d4:	9742                	add	a4,a4,a6
 6d6:	00074703          	lbu	a4,0(a4)
 6da:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 6de:	872e                	mv	a4,a1
 6e0:	02c5d5bb          	divuw	a1,a1,a2
 6e4:	0685                	addi	a3,a3,1
 6e6:	fcc77fe3          	bgeu	a4,a2,6c4 <printint+0x28>
  if(neg)
 6ea:	000e0c63          	beqz	t3,702 <printint+0x66>
    buf[i++] = '-';
 6ee:	fd050793          	addi	a5,a0,-48
 6f2:	00878533          	add	a0,a5,s0
 6f6:	02d00793          	li	a5,45
 6fa:	fef50823          	sb	a5,-16(a0)
 6fe:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 702:	fff7899b          	addiw	s3,a5,-1
 706:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 70a:	fff4c583          	lbu	a1,-1(s1)
 70e:	854a                	mv	a0,s2
 710:	00000097          	auipc	ra,0x0
 714:	f6a080e7          	jalr	-150(ra) # 67a <putc>
  while(--i >= 0)
 718:	39fd                	addiw	s3,s3,-1
 71a:	14fd                	addi	s1,s1,-1
 71c:	fe09d7e3          	bgez	s3,70a <printint+0x6e>
}
 720:	70e2                	ld	ra,56(sp)
 722:	7442                	ld	s0,48(sp)
 724:	74a2                	ld	s1,40(sp)
 726:	7902                	ld	s2,32(sp)
 728:	69e2                	ld	s3,24(sp)
 72a:	6121                	addi	sp,sp,64
 72c:	8082                	ret
    x = -xx;
 72e:	40b005bb          	negw	a1,a1
    neg = 1;
 732:	4e05                	li	t3,1
    x = -xx;
 734:	b741                	j	6b4 <printint+0x18>

0000000000000736 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 736:	715d                	addi	sp,sp,-80
 738:	e486                	sd	ra,72(sp)
 73a:	e0a2                	sd	s0,64(sp)
 73c:	f84a                	sd	s2,48(sp)
 73e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 740:	0005c903          	lbu	s2,0(a1)
 744:	1a090a63          	beqz	s2,8f8 <vprintf+0x1c2>
 748:	fc26                	sd	s1,56(sp)
 74a:	f44e                	sd	s3,40(sp)
 74c:	f052                	sd	s4,32(sp)
 74e:	ec56                	sd	s5,24(sp)
 750:	e85a                	sd	s6,16(sp)
 752:	e45e                	sd	s7,8(sp)
 754:	8aaa                	mv	s5,a0
 756:	8bb2                	mv	s7,a2
 758:	00158493          	addi	s1,a1,1
  state = 0;
 75c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 75e:	02500a13          	li	s4,37
 762:	4b55                	li	s6,21
 764:	a839                	j	782 <vprintf+0x4c>
        putc(fd, c);
 766:	85ca                	mv	a1,s2
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	f10080e7          	jalr	-240(ra) # 67a <putc>
 772:	a019                	j	778 <vprintf+0x42>
    } else if(state == '%'){
 774:	01498d63          	beq	s3,s4,78e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 778:	0485                	addi	s1,s1,1
 77a:	fff4c903          	lbu	s2,-1(s1)
 77e:	16090763          	beqz	s2,8ec <vprintf+0x1b6>
    if(state == 0){
 782:	fe0999e3          	bnez	s3,774 <vprintf+0x3e>
      if(c == '%'){
 786:	ff4910e3          	bne	s2,s4,766 <vprintf+0x30>
        state = '%';
 78a:	89d2                	mv	s3,s4
 78c:	b7f5                	j	778 <vprintf+0x42>
      if(c == 'd'){
 78e:	13490463          	beq	s2,s4,8b6 <vprintf+0x180>
 792:	f9d9079b          	addiw	a5,s2,-99
 796:	0ff7f793          	zext.b	a5,a5
 79a:	12fb6763          	bltu	s6,a5,8c8 <vprintf+0x192>
 79e:	f9d9079b          	addiw	a5,s2,-99
 7a2:	0ff7f713          	zext.b	a4,a5
 7a6:	12eb6163          	bltu	s6,a4,8c8 <vprintf+0x192>
 7aa:	00271793          	slli	a5,a4,0x2
 7ae:	00000717          	auipc	a4,0x0
 7b2:	60270713          	addi	a4,a4,1538 # db0 <ithread_join+0xc4>
 7b6:	97ba                	add	a5,a5,a4
 7b8:	439c                	lw	a5,0(a5)
 7ba:	97ba                	add	a5,a5,a4
 7bc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	ed0080e7          	jalr	-304(ra) # 69c <printint>
 7d4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	b745                	j	778 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7da:	008b8913          	addi	s2,s7,8
 7de:	4681                	li	a3,0
 7e0:	4629                	li	a2,10
 7e2:	000ba583          	lw	a1,0(s7)
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	eb4080e7          	jalr	-332(ra) # 69c <printint>
 7f0:	8bca                	mv	s7,s2
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b751                	j	778 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7f6:	008b8913          	addi	s2,s7,8
 7fa:	4681                	li	a3,0
 7fc:	4641                	li	a2,16
 7fe:	000ba583          	lw	a1,0(s7)
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	e98080e7          	jalr	-360(ra) # 69c <printint>
 80c:	8bca                	mv	s7,s2
      state = 0;
 80e:	4981                	li	s3,0
 810:	b7a5                	j	778 <vprintf+0x42>
 812:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 814:	008b8c13          	addi	s8,s7,8
 818:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 81c:	03000593          	li	a1,48
 820:	8556                	mv	a0,s5
 822:	00000097          	auipc	ra,0x0
 826:	e58080e7          	jalr	-424(ra) # 67a <putc>
  putc(fd, 'x');
 82a:	07800593          	li	a1,120
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	e4a080e7          	jalr	-438(ra) # 67a <putc>
 838:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83a:	00000b97          	auipc	s7,0x0
 83e:	5ceb8b93          	addi	s7,s7,1486 # e08 <digits>
 842:	03c9d793          	srli	a5,s3,0x3c
 846:	97de                	add	a5,a5,s7
 848:	0007c583          	lbu	a1,0(a5)
 84c:	8556                	mv	a0,s5
 84e:	00000097          	auipc	ra,0x0
 852:	e2c080e7          	jalr	-468(ra) # 67a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 856:	0992                	slli	s3,s3,0x4
 858:	397d                	addiw	s2,s2,-1
 85a:	fe0914e3          	bnez	s2,842 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 85e:	8be2                	mv	s7,s8
      state = 0;
 860:	4981                	li	s3,0
 862:	6c02                	ld	s8,0(sp)
 864:	bf11                	j	778 <vprintf+0x42>
        s = va_arg(ap, char*);
 866:	008b8993          	addi	s3,s7,8
 86a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 86e:	02090163          	beqz	s2,890 <vprintf+0x15a>
        while(*s != 0){
 872:	00094583          	lbu	a1,0(s2)
 876:	c9a5                	beqz	a1,8e6 <vprintf+0x1b0>
          putc(fd, *s);
 878:	8556                	mv	a0,s5
 87a:	00000097          	auipc	ra,0x0
 87e:	e00080e7          	jalr	-512(ra) # 67a <putc>
          s++;
 882:	0905                	addi	s2,s2,1
        while(*s != 0){
 884:	00094583          	lbu	a1,0(s2)
 888:	f9e5                	bnez	a1,878 <vprintf+0x142>
        s = va_arg(ap, char*);
 88a:	8bce                	mv	s7,s3
      state = 0;
 88c:	4981                	li	s3,0
 88e:	b5ed                	j	778 <vprintf+0x42>
          s = "(null)";
 890:	00000917          	auipc	s2,0x0
 894:	4e890913          	addi	s2,s2,1256 # d78 <ithread_join+0x8c>
        while(*s != 0){
 898:	02800593          	li	a1,40
 89c:	bff1                	j	878 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 89e:	008b8913          	addi	s2,s7,8
 8a2:	000bc583          	lbu	a1,0(s7)
 8a6:	8556                	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	dd2080e7          	jalr	-558(ra) # 67a <putc>
 8b0:	8bca                	mv	s7,s2
      state = 0;
 8b2:	4981                	li	s3,0
 8b4:	b5d1                	j	778 <vprintf+0x42>
        putc(fd, c);
 8b6:	02500593          	li	a1,37
 8ba:	8556                	mv	a0,s5
 8bc:	00000097          	auipc	ra,0x0
 8c0:	dbe080e7          	jalr	-578(ra) # 67a <putc>
      state = 0;
 8c4:	4981                	li	s3,0
 8c6:	bd4d                	j	778 <vprintf+0x42>
        putc(fd, '%');
 8c8:	02500593          	li	a1,37
 8cc:	8556                	mv	a0,s5
 8ce:	00000097          	auipc	ra,0x0
 8d2:	dac080e7          	jalr	-596(ra) # 67a <putc>
        putc(fd, c);
 8d6:	85ca                	mv	a1,s2
 8d8:	8556                	mv	a0,s5
 8da:	00000097          	auipc	ra,0x0
 8de:	da0080e7          	jalr	-608(ra) # 67a <putc>
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	bd51                	j	778 <vprintf+0x42>
        s = va_arg(ap, char*);
 8e6:	8bce                	mv	s7,s3
      state = 0;
 8e8:	4981                	li	s3,0
 8ea:	b579                	j	778 <vprintf+0x42>
 8ec:	74e2                	ld	s1,56(sp)
 8ee:	79a2                	ld	s3,40(sp)
 8f0:	7a02                	ld	s4,32(sp)
 8f2:	6ae2                	ld	s5,24(sp)
 8f4:	6b42                	ld	s6,16(sp)
 8f6:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8f8:	60a6                	ld	ra,72(sp)
 8fa:	6406                	ld	s0,64(sp)
 8fc:	7942                	ld	s2,48(sp)
 8fe:	6161                	addi	sp,sp,80
 900:	8082                	ret

0000000000000902 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 902:	715d                	addi	sp,sp,-80
 904:	ec06                	sd	ra,24(sp)
 906:	e822                	sd	s0,16(sp)
 908:	1000                	addi	s0,sp,32
 90a:	e010                	sd	a2,0(s0)
 90c:	e414                	sd	a3,8(s0)
 90e:	e818                	sd	a4,16(s0)
 910:	ec1c                	sd	a5,24(s0)
 912:	03043023          	sd	a6,32(s0)
 916:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 91a:	8622                	mv	a2,s0
 91c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 920:	00000097          	auipc	ra,0x0
 924:	e16080e7          	jalr	-490(ra) # 736 <vprintf>
}
 928:	60e2                	ld	ra,24(sp)
 92a:	6442                	ld	s0,16(sp)
 92c:	6161                	addi	sp,sp,80
 92e:	8082                	ret

0000000000000930 <printf>:

void
printf(const char *fmt, ...)
{
 930:	711d                	addi	sp,sp,-96
 932:	ec06                	sd	ra,24(sp)
 934:	e822                	sd	s0,16(sp)
 936:	1000                	addi	s0,sp,32
 938:	e40c                	sd	a1,8(s0)
 93a:	e810                	sd	a2,16(s0)
 93c:	ec14                	sd	a3,24(s0)
 93e:	f018                	sd	a4,32(s0)
 940:	f41c                	sd	a5,40(s0)
 942:	03043823          	sd	a6,48(s0)
 946:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 94a:	00840613          	addi	a2,s0,8
 94e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 952:	85aa                	mv	a1,a0
 954:	4505                	li	a0,1
 956:	00000097          	auipc	ra,0x0
 95a:	de0080e7          	jalr	-544(ra) # 736 <vprintf>
}
 95e:	60e2                	ld	ra,24(sp)
 960:	6442                	ld	s0,16(sp)
 962:	6125                	addi	sp,sp,96
 964:	8082                	ret

0000000000000966 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 966:	1141                	addi	sp,sp,-16
 968:	e406                	sd	ra,8(sp)
 96a:	e022                	sd	s0,0(sp)
 96c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 96e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 972:	00001797          	auipc	a5,0x1
 976:	c8e7b783          	ld	a5,-882(a5) # 1600 <freep>
 97a:	a02d                	j	9a4 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 97c:	4618                	lw	a4,8(a2)
 97e:	9f2d                	addw	a4,a4,a1
 980:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 984:	6398                	ld	a4,0(a5)
 986:	6310                	ld	a2,0(a4)
 988:	a83d                	j	9c6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 98a:	ff852703          	lw	a4,-8(a0)
 98e:	9f31                	addw	a4,a4,a2
 990:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 992:	ff053683          	ld	a3,-16(a0)
 996:	a091                	j	9da <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 998:	6398                	ld	a4,0(a5)
 99a:	00e7e463          	bltu	a5,a4,9a2 <free+0x3c>
 99e:	00e6ea63          	bltu	a3,a4,9b2 <free+0x4c>
{
 9a2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a4:	fed7fae3          	bgeu	a5,a3,998 <free+0x32>
 9a8:	6398                	ld	a4,0(a5)
 9aa:	00e6e463          	bltu	a3,a4,9b2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ae:	fee7eae3          	bltu	a5,a4,9a2 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 9b2:	ff852583          	lw	a1,-8(a0)
 9b6:	6390                	ld	a2,0(a5)
 9b8:	02059813          	slli	a6,a1,0x20
 9bc:	01c85713          	srli	a4,a6,0x1c
 9c0:	9736                	add	a4,a4,a3
 9c2:	fae60de3          	beq	a2,a4,97c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ca:	4790                	lw	a2,8(a5)
 9cc:	02061593          	slli	a1,a2,0x20
 9d0:	01c5d713          	srli	a4,a1,0x1c
 9d4:	973e                	add	a4,a4,a5
 9d6:	fae68ae3          	beq	a3,a4,98a <free+0x24>
    p->s.ptr = bp->s.ptr;
 9da:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9dc:	00001717          	auipc	a4,0x1
 9e0:	c2f73223          	sd	a5,-988(a4) # 1600 <freep>
}
 9e4:	60a2                	ld	ra,8(sp)
 9e6:	6402                	ld	s0,0(sp)
 9e8:	0141                	addi	sp,sp,16
 9ea:	8082                	ret

00000000000009ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ec:	7139                	addi	sp,sp,-64
 9ee:	fc06                	sd	ra,56(sp)
 9f0:	f822                	sd	s0,48(sp)
 9f2:	f04a                	sd	s2,32(sp)
 9f4:	ec4e                	sd	s3,24(sp)
 9f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f8:	02051993          	slli	s3,a0,0x20
 9fc:	0209d993          	srli	s3,s3,0x20
 a00:	09bd                	addi	s3,s3,15
 a02:	0049d993          	srli	s3,s3,0x4
 a06:	2985                	addiw	s3,s3,1
 a08:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a0a:	00001517          	auipc	a0,0x1
 a0e:	bf653503          	ld	a0,-1034(a0) # 1600 <freep>
 a12:	c905                	beqz	a0,a42 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a14:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a16:	4798                	lw	a4,8(a5)
 a18:	09377a63          	bgeu	a4,s3,aac <malloc+0xc0>
 a1c:	f426                	sd	s1,40(sp)
 a1e:	e852                	sd	s4,16(sp)
 a20:	e456                	sd	s5,8(sp)
 a22:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a24:	8a4e                	mv	s4,s3
 a26:	6705                	lui	a4,0x1
 a28:	00e9f363          	bgeu	s3,a4,a2e <malloc+0x42>
 a2c:	6a05                	lui	s4,0x1
 a2e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a32:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a36:	00001497          	auipc	s1,0x1
 a3a:	bca48493          	addi	s1,s1,-1078 # 1600 <freep>
  if(p == (char*)-1)
 a3e:	5afd                	li	s5,-1
 a40:	a089                	j	a82 <malloc+0x96>
 a42:	f426                	sd	s1,40(sp)
 a44:	e852                	sd	s4,16(sp)
 a46:	e456                	sd	s5,8(sp)
 a48:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a4a:	00001797          	auipc	a5,0x1
 a4e:	fd678793          	addi	a5,a5,-42 # 1a20 <base>
 a52:	00001717          	auipc	a4,0x1
 a56:	baf73723          	sd	a5,-1106(a4) # 1600 <freep>
 a5a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a5c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a60:	b7d1                	j	a24 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a62:	6398                	ld	a4,0(a5)
 a64:	e118                	sd	a4,0(a0)
 a66:	a8b9                	j	ac4 <malloc+0xd8>
  hp->s.size = nu;
 a68:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a6c:	0541                	addi	a0,a0,16
 a6e:	00000097          	auipc	ra,0x0
 a72:	ef8080e7          	jalr	-264(ra) # 966 <free>
  return freep;
 a76:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a78:	c135                	beqz	a0,adc <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a7c:	4798                	lw	a4,8(a5)
 a7e:	03277363          	bgeu	a4,s2,aa4 <malloc+0xb8>
    if(p == freep)
 a82:	6098                	ld	a4,0(s1)
 a84:	853e                	mv	a0,a5
 a86:	fef71ae3          	bne	a4,a5,a7a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a8a:	8552                	mv	a0,s4
 a8c:	00000097          	auipc	ra,0x0
 a90:	b68080e7          	jalr	-1176(ra) # 5f4 <sbrk>
  if(p == (char*)-1)
 a94:	fd551ae3          	bne	a0,s5,a68 <malloc+0x7c>
        return 0;
 a98:	4501                	li	a0,0
 a9a:	74a2                	ld	s1,40(sp)
 a9c:	6a42                	ld	s4,16(sp)
 a9e:	6aa2                	ld	s5,8(sp)
 aa0:	6b02                	ld	s6,0(sp)
 aa2:	a03d                	j	ad0 <malloc+0xe4>
 aa4:	74a2                	ld	s1,40(sp)
 aa6:	6a42                	ld	s4,16(sp)
 aa8:	6aa2                	ld	s5,8(sp)
 aaa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aac:	fae90be3          	beq	s2,a4,a62 <malloc+0x76>
        p->s.size -= nunits;
 ab0:	4137073b          	subw	a4,a4,s3
 ab4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ab6:	02071693          	slli	a3,a4,0x20
 aba:	01c6d713          	srli	a4,a3,0x1c
 abe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ac0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ac4:	00001717          	auipc	a4,0x1
 ac8:	b2a73e23          	sd	a0,-1220(a4) # 1600 <freep>
      return (void*)(p + 1);
 acc:	01078513          	addi	a0,a5,16
  }
}
 ad0:	70e2                	ld	ra,56(sp)
 ad2:	7442                	ld	s0,48(sp)
 ad4:	7902                	ld	s2,32(sp)
 ad6:	69e2                	ld	s3,24(sp)
 ad8:	6121                	addi	sp,sp,64
 ada:	8082                	ret
 adc:	74a2                	ld	s1,40(sp)
 ade:	6a42                	ld	s4,16(sp)
 ae0:	6aa2                	ld	s5,8(sp)
 ae2:	6b02                	ld	s6,0(sp)
 ae4:	b7f5                	j	ad0 <malloc+0xe4>

0000000000000ae6 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 ae6:	1141                	addi	sp,sp,-16
 ae8:	e406                	sd	ra,8(sp)
 aea:	e022                	sd	s0,0(sp)
 aec:	0800                	addi	s0,sp,16
  thread_exit(status);
 aee:	2501                	sext.w	a0,a0
 af0:	00000097          	auipc	ra,0x0
 af4:	b34080e7          	jalr	-1228(ra) # 624 <thread_exit>
}
 af8:	60a2                	ld	ra,8(sp)
 afa:	6402                	ld	s0,0(sp)
 afc:	0141                	addi	sp,sp,16
 afe:	8082                	ret

0000000000000b00 <free_stacks>:
int free_stacks() {
 b00:	7179                	addi	sp,sp,-48
 b02:	f406                	sd	ra,40(sp)
 b04:	f022                	sd	s0,32(sp)
 b06:	ec26                	sd	s1,24(sp)
 b08:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 b0a:	00001797          	auipc	a5,0x1
 b0e:	b067a783          	lw	a5,-1274(a5) # 1610 <num_threads>
 b12:	04f05063          	blez	a5,b52 <free_stacks+0x52>
 b16:	e84a                	sd	s2,16(sp)
 b18:	e44e                	sd	s3,8(sp)
 b1a:	4481                	li	s1,0
    free(stacks[i]);
 b1c:	00001997          	auipc	s3,0x1
 b20:	aec98993          	addi	s3,s3,-1300 # 1608 <stacks>
  for (int i = 0; i < num_threads; i++) {
 b24:	00001917          	auipc	s2,0x1
 b28:	aec90913          	addi	s2,s2,-1300 # 1610 <num_threads>
    free(stacks[i]);
 b2c:	0009b783          	ld	a5,0(s3)
 b30:	00349713          	slli	a4,s1,0x3
 b34:	97ba                	add	a5,a5,a4
 b36:	6388                	ld	a0,0(a5)
 b38:	00000097          	auipc	ra,0x0
 b3c:	e2e080e7          	jalr	-466(ra) # 966 <free>
  for (int i = 0; i < num_threads; i++) {
 b40:	0485                	addi	s1,s1,1
 b42:	00092703          	lw	a4,0(s2)
 b46:	0004879b          	sext.w	a5,s1
 b4a:	fee7c1e3          	blt	a5,a4,b2c <free_stacks+0x2c>
 b4e:	6942                	ld	s2,16(sp)
 b50:	69a2                	ld	s3,8(sp)
  free(stacks);
 b52:	00001497          	auipc	s1,0x1
 b56:	ab648493          	addi	s1,s1,-1354 # 1608 <stacks>
 b5a:	6088                	ld	a0,0(s1)
 b5c:	00000097          	auipc	ra,0x0
 b60:	e0a080e7          	jalr	-502(ra) # 966 <free>
  stacks = 0;
 b64:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 b68:	00001797          	auipc	a5,0x1
 b6c:	aa07a423          	sw	zero,-1368(a5) # 1610 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 b70:	47a1                	li	a5,8
 b72:	00001717          	auipc	a4,0x1
 b76:	a6f72f23          	sw	a5,-1410(a4) # 15f0 <max_stacks>
  threads_done = 0;
 b7a:	00001797          	auipc	a5,0x1
 b7e:	a807ad23          	sw	zero,-1382(a5) # 1614 <threads_done>
}
 b82:	4501                	li	a0,0
 b84:	70a2                	ld	ra,40(sp)
 b86:	7402                	ld	s0,32(sp)
 b88:	64e2                	ld	s1,24(sp)
 b8a:	6145                	addi	sp,sp,48
 b8c:	8082                	ret

0000000000000b8e <expand_num_threads>:
int expand_num_threads() {
 b8e:	1101                	addi	sp,sp,-32
 b90:	ec06                	sd	ra,24(sp)
 b92:	e822                	sd	s0,16(sp)
 b94:	e426                	sd	s1,8(sp)
 b96:	e04a                	sd	s2,0(sp)
 b98:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 b9a:	00001797          	auipc	a5,0x1
 b9e:	a5678793          	addi	a5,a5,-1450 # 15f0 <max_stacks>
 ba2:	4388                	lw	a0,0(a5)
 ba4:	0015151b          	slliw	a0,a0,0x1
 ba8:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 baa:	0035151b          	slliw	a0,a0,0x3
 bae:	00000097          	auipc	ra,0x0
 bb2:	e3e080e7          	jalr	-450(ra) # 9ec <malloc>
 bb6:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 bb8:	00001617          	auipc	a2,0x1
 bbc:	a5862603          	lw	a2,-1448(a2) # 1610 <num_threads>
 bc0:	00001497          	auipc	s1,0x1
 bc4:	a4848493          	addi	s1,s1,-1464 # 1608 <stacks>
 bc8:	0036161b          	slliw	a2,a2,0x3
 bcc:	608c                	ld	a1,0(s1)
 bce:	00000097          	auipc	ra,0x0
 bd2:	8e4080e7          	jalr	-1820(ra) # 4b2 <memmove>
  free(stacks);
 bd6:	6088                	ld	a0,0(s1)
 bd8:	00000097          	auipc	ra,0x0
 bdc:	d8e080e7          	jalr	-626(ra) # 966 <free>
  stacks = new_stacks;
 be0:	0124b023          	sd	s2,0(s1)
}
 be4:	4501                	li	a0,0
 be6:	60e2                	ld	ra,24(sp)
 be8:	6442                	ld	s0,16(sp)
 bea:	64a2                	ld	s1,8(sp)
 bec:	6902                	ld	s2,0(sp)
 bee:	6105                	addi	sp,sp,32
 bf0:	8082                	ret

0000000000000bf2 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 bf2:	7179                	addi	sp,sp,-48
 bf4:	f406                	sd	ra,40(sp)
 bf6:	f022                	sd	s0,32(sp)
 bf8:	e84a                	sd	s2,16(sp)
 bfa:	e44e                	sd	s3,8(sp)
 bfc:	1800                	addi	s0,sp,48
 bfe:	892a                	mv	s2,a0
 c00:	89ae                	mv	s3,a1
  if (stacks == 0) {
 c02:	00001797          	auipc	a5,0x1
 c06:	a067b783          	ld	a5,-1530(a5) # 1608 <stacks>
 c0a:	c3d9                	beqz	a5,c90 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 c0c:	00001797          	auipc	a5,0x1
 c10:	9e47a783          	lw	a5,-1564(a5) # 15f0 <max_stacks>
 c14:	00001717          	auipc	a4,0x1
 c18:	9fc72703          	lw	a4,-1540(a4) # 1610 <num_threads>
 c1c:	0af71363          	bne	a4,a5,cc2 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 c20:	04000713          	li	a4,64
 c24:	08e78563          	beq	a5,a4,cae <ithread_create+0xbc>
 c28:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 c2a:	00000097          	auipc	ra,0x0
 c2e:	f64080e7          	jalr	-156(ra) # b8e <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 c32:	6505                	lui	a0,0x1
 c34:	00000097          	auipc	ra,0x0
 c38:	db8080e7          	jalr	-584(ra) # 9ec <malloc>
 c3c:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 c3e:	00001717          	auipc	a4,0x1
 c42:	9d272703          	lw	a4,-1582(a4) # 1610 <num_threads>
 c46:	070e                	slli	a4,a4,0x3
 c48:	00001797          	auipc	a5,0x1
 c4c:	9c07b783          	ld	a5,-1600(a5) # 1608 <stacks>
 c50:	97ba                	add	a5,a5,a4
 c52:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 c54:	00000697          	auipc	a3,0x0
 c58:	e9268693          	addi	a3,a3,-366 # ae6 <ithread_exit>
 c5c:	862a                	mv	a2,a0
 c5e:	85ce                	mv	a1,s3
 c60:	854a                	mv	a0,s2
 c62:	00000097          	auipc	ra,0x0
 c66:	9b2080e7          	jalr	-1614(ra) # 614 <create_thread>
 c6a:	892a                	mv	s2,a0
  if (res != -1) {
 c6c:	57fd                	li	a5,-1
 c6e:	04f50c63          	beq	a0,a5,cc6 <ithread_create+0xd4>
    num_threads++;
 c72:	00001717          	auipc	a4,0x1
 c76:	99e70713          	addi	a4,a4,-1634 # 1610 <num_threads>
 c7a:	431c                	lw	a5,0(a4)
 c7c:	2785                	addiw	a5,a5,1
 c7e:	c31c                	sw	a5,0(a4)
 c80:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 c82:	854a                	mv	a0,s2
 c84:	70a2                	ld	ra,40(sp)
 c86:	7402                	ld	s0,32(sp)
 c88:	6942                	ld	s2,16(sp)
 c8a:	69a2                	ld	s3,8(sp)
 c8c:	6145                	addi	sp,sp,48
 c8e:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 c90:	00001517          	auipc	a0,0x1
 c94:	96052503          	lw	a0,-1696(a0) # 15f0 <max_stacks>
 c98:	0035151b          	slliw	a0,a0,0x3
 c9c:	00000097          	auipc	ra,0x0
 ca0:	d50080e7          	jalr	-688(ra) # 9ec <malloc>
 ca4:	00001797          	auipc	a5,0x1
 ca8:	96a7b223          	sd	a0,-1692(a5) # 1608 <stacks>
 cac:	b785                	j	c0c <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 cae:	00000517          	auipc	a0,0x0
 cb2:	0d250513          	addi	a0,a0,210 # d80 <ithread_join+0x94>
 cb6:	00000097          	auipc	ra,0x0
 cba:	c7a080e7          	jalr	-902(ra) # 930 <printf>
      return -1;
 cbe:	597d                	li	s2,-1
 cc0:	b7c9                	j	c82 <ithread_create+0x90>
 cc2:	ec26                	sd	s1,24(sp)
 cc4:	b7bd                	j	c32 <ithread_create+0x40>
    free(stack_ptr);
 cc6:	8526                	mv	a0,s1
 cc8:	00000097          	auipc	ra,0x0
 ccc:	c9e080e7          	jalr	-866(ra) # 966 <free>
    stacks[num_threads] = 0;
 cd0:	00001717          	auipc	a4,0x1
 cd4:	94072703          	lw	a4,-1728(a4) # 1610 <num_threads>
 cd8:	070e                	slli	a4,a4,0x3
 cda:	00001797          	auipc	a5,0x1
 cde:	92e7b783          	ld	a5,-1746(a5) # 1608 <stacks>
 ce2:	97ba                	add	a5,a5,a4
 ce4:	0007b023          	sd	zero,0(a5)
 ce8:	64e2                	ld	s1,24(sp)
 cea:	bf61                	j	c82 <ithread_create+0x90>

0000000000000cec <ithread_join>:

int ithread_join(int thread_id) {
 cec:	1101                	addi	sp,sp,-32
 cee:	ec06                	sd	ra,24(sp)
 cf0:	e822                	sd	s0,16(sp)
 cf2:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 cf4:	ff040793          	addi	a5,s0,-16
 cf8:	ffc7859b          	addiw	a1,a5,-4
 cfc:	00000097          	auipc	ra,0x0
 d00:	920080e7          	jalr	-1760(ra) # 61c <join_thread>
  threads_done++;
 d04:	00001717          	auipc	a4,0x1
 d08:	91070713          	addi	a4,a4,-1776 # 1614 <threads_done>
 d0c:	431c                	lw	a5,0(a4)
 d0e:	2785                	addiw	a5,a5,1
 d10:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 d12:	00001717          	auipc	a4,0x1
 d16:	8fe72703          	lw	a4,-1794(a4) # 1610 <num_threads>
 d1a:	00f70863          	beq	a4,a5,d2a <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 d1e:	fec42503          	lw	a0,-20(s0)
 d22:	60e2                	ld	ra,24(sp)
 d24:	6442                	ld	s0,16(sp)
 d26:	6105                	addi	sp,sp,32
 d28:	8082                	ret
    free_stacks();
 d2a:	00000097          	auipc	ra,0x0
 d2e:	dd6080e7          	jalr	-554(ra) # b00 <free_stacks>
 d32:	b7f5                	j	d1e <ithread_join+0x32>
