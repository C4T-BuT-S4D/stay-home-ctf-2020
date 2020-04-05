package tokens

import (
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha512"
	"encoding/base64"
	"errors"
	"fmt"
	"io/ioutil"
	"math/big"
	"os"
)

var (
	curve                 elliptic.Curve
	privateKey, publicKey *big.Int
)

func Init(filename string) error {
	curve = elliptic.P521()
	if _, err := os.Stat(filename); err == nil {
		bytes, err := ioutil.ReadFile(filename)
		if err != nil {
			return err
		}
		privateKey = new(big.Int).SetBytes(bytes)
	} else if os.IsNotExist(err) {
		bytes := make([]byte, 512)
		_, err := rand.Read(bytes)
		if err != nil {
			return err
		}
		hash := sha512.Sum384(bytes)
		privateKey = new(big.Int).SetBytes(hash[:])
		err = ioutil.WriteFile(filename, privateKey.Bytes(), 0644)
		if err != nil {
			return err
		}
	} else {
		return errors.New("failed to check private key file: " + filename)
	}
	publicKey, _ = curve.ScalarBaseMult(privateKey.Bytes())
	return nil
}

func sign(data []byte) (r, s *big.Int) {
	hash := sha512.Sum384(data)
	message := new(big.Int).SetBytes(hash[:])
	message.Mod(message, curve.Params().N)

	var nonce, nonceInv *big.Int

	for {
		for {
			bytes := make([]byte, 512)
			_, err := rand.Read(bytes)
			if err != nil {
				fmt.Printf("Failed to read random bytes: %s\n", err)
				os.Exit(1)
			}

			hash = sha512.Sum384(bytes)
			nonce = new(big.Int).SetBytes(hash[:])
			nonce.Mod(nonce, curve.Params().N)

			nonceInv = new(big.Int).ModInverse(nonce, curve.Params().N)

			r, _ = curve.ScalarBaseMult(nonce.Bytes())
			r.Mod(r, curve.Params().N)

			if r.Sign() != 0 {
				break
			}
		}

		s = new(big.Int).Mul(privateKey, r)
		s.Add(s, message)
		s.Mul(s, nonceInv)
		s.Mod(s, curve.Params().N)

		if s.Sign() != 0 {
			break
		}
	}

	return
}

func verify(data []byte, r, s *big.Int) bool {
	hash := sha512.Sum384(data)

	message := new(big.Int).SetBytes(hash[:])
	message.Mod(message, curve.Params().N)

	if r.Sign() == 0 || s.Sign() == 0 {
		return false
	}

	sInv := new(big.Int).ModInverse(s, curve.Params().N)

	u1 := message.Mul(message, sInv)
	u2 := new(big.Int).Mul(sInv.Mul(r, sInv), privateKey)

	x1, y1 := curve.ScalarBaseMult(u1.Bytes())
	x2, y2 := curve.ScalarBaseMult(u2.Bytes())

	if x1.Cmp(x2) == 0 {
		return false
	}

	x, _ := curve.Add(x1, y1, x2, y2)
	x.Mod(x, curve.Params().N)

	return x.Cmp(r) == 0
}

func GenerateToken(data string) string {
	r, s := sign([]byte(data))

	rBytes, sBytes := r.Bytes(), s.Bytes()
	rLength, sLength := byte(len(rBytes)), byte(len(sBytes))

	tokenBytes := append(append(rBytes, sBytes...), rLength, sLength)
	return base64.StdEncoding.EncodeToString(tokenBytes)
}

func CheckToken(data, token string) bool {
	tokenBytes, err := base64.StdEncoding.DecodeString(token)
	if err != nil {
		return false
	}

	rLength, sLength := tokenBytes[len(tokenBytes)-2], tokenBytes[len(tokenBytes)-1]

	rBytes, sBytes := tokenBytes[0:rLength], tokenBytes[rLength:rLength+sLength]
	r, s := new(big.Int).SetBytes(rBytes), new(big.Int).SetBytes(sBytes)

	return verify([]byte(data), r, s)
}
