package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"io"
	"log"
	"os"
)

// Amountaction type for record conversion
type AmountAction int

const (
	Debit AmountAction = iota
	Credit
	AutoPayStart
	AutoPayEnd
)

type Record struct {
	rtype  int32
	userID uint64
	amount float64
}

type Balance struct {
	uid     uint64
	balance float64
}

func (r *Record) Type() AmountAction {
	var ttype AmountAction

	// this just makes things nicer to deal with later
	switch r.rtype {
	case 0:
		ttype = Debit
	case 1:
		ttype = Credit
	case 2:
		ttype = AutoPayStart
	case 3:
		ttype = AutoPayEnd
	}

	return ttype
}

// convenience function becuase go doesn't have algebreaic data types :(
func checkErr(e error) {
	if e != nil {
		if e != io.EOF {
			log.Fatalf("Err %v", e)
		}
	}
}

// use this to just get the amount of records in the file
func readHeader(file io.Reader, number int) uint32 {
	ms := make([]byte, 4)
	version := make([]byte, 1)
	nor := make([]byte, 4)

	_, err := file.Read(ms)
	checkErr(err)

	_, err = file.Read(version)
	checkErr(err)

	_, err = file.Read(nor)
	checkErr(err)

	return binary.BigEndian.Uint32(nor)

}

func getRecord(f io.Reader) *Record {
	// allocate for the amount of bytes we want to read
	rtype := make([]byte, 1)
	ts := make([]byte, 4)
	uid := make([]byte, 8)
	amnt := make([]byte, 8)

	_, err := f.Read(rtype)
	checkErr(err)

	_, err = f.Read(ts)
	checkErr(err)

	_, err = f.Read(uid)
	checkErr(err)

	uuid := binary.BigEndian.Uint64(uid)

	var record *Record

	// we need to sort out debit/credit vs autopay for reading
	if (rtype[0] == 0x00) || (rtype[0] == 0x01) {
		_, err = f.Read(amnt)
		checkErr(err)

		var cash float64
		buf := bytes.NewReader(amnt)
		err = binary.Read(buf, binary.BigEndian, &cash)
		checkErr(err)

		record = &Record{
			rtype:  int32(rtype[0]),
			userID: uuid,
			amount: cash,
		}
	} else {
		record = &Record{
			rtype:  int32(rtype[0]),
			userID: uuid,
		}
	}

	return record
}

func main() {
	var index uint32

	// maybe make this a cli arg?
	var account uint64

	// user balance setup
	account = 2456938384156277127
	userAcct := Balance{uid: account}

	// placeholders for calcs
	credits := Balance{}
	debits := Balance{}

	// counters for autopay
	var autoStart int = 0
	var autoEnd int = 0

	f, err := os.Open("./txnlog.dat")
	checkErr(err)

	// lets just defer this in a real situation maybe keep track and close
	defer f.Close()

	recs := readHeader(f, 4)

	for index = 0; index <= recs; index++ {
		rec := getRecord(f)

		switch rec.Type() {
		case Debit:
			debits.balance += rec.amount

			if rec.userID == userAcct.uid {
				userAcct.balance -= rec.amount
			}
		case Credit:
			credits.balance += rec.amount
			if rec.userID == userAcct.uid {
				userAcct.balance += rec.amount
			}
		case AutoPayStart:
			autoStart++
		case AutoPayEnd:
			autoEnd++
		}
	}

	fmt.Printf("total credit amount=%0.2f\n", debits.balance)
	fmt.Printf("total debit amount=%0.2f\n", credits.balance)
	fmt.Printf("autopays started=%+v\n", autoStart)
	fmt.Printf("autopays ended=%v\n", autoEnd)
	fmt.Printf("balance for user %+v = %+v\n", account, userAcct.balance)

}
