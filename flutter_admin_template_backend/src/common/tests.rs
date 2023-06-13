mod tests{
    use gm_sm3::sm3_hash;
    #[test]
    fn sm3_test(){
        let hash = sm3_hash(b"123456");
        let r = hex::encode(hash.as_ref());
        println!("{:?}",r);
    }
}