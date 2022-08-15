;; SIP009 NFT trait on mainnet
;; (impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

(impl-trait .sip009-nft-trait.sip009-nft-trait)

;; constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; asset identifier
(define-non-fungible-token dino-token uint)

;; this var will be incremented at every token mint
(define-data-var last-token-id uint u0)

(define-read-only (get-last-token-id) 
    (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint)) 
    (ok none)
)

(define-read-only (get-owner (token-id uint)) 
    (ok (nft-get-owner? dino-token token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) err-not-token-owner)
        (nft-transfer? dino-token token-id sender recipient)
    )
)

(define-public (mint (recipient principal))
    (let 
        (
            (token-id (+ (var-get last-token-id) u1))
        ) 
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (try! (nft-mint? dino-token token-id recipient))
        (var-set last-token-id token-id)
        (ok token-id)
    )
)